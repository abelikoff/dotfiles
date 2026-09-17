-- Tree-sitter (nvim-treesitter `main` branch API).
-- Parsers are compiled locally: this needs the `tree-sitter` CLI (>= 0.26.1) and a
-- C compiler. If the CLI is missing or too old, it is installed through Mason.
local M = {}

M.specs = {
  { src = "nvim-treesitter/nvim-treesitter", version = "main" },
  "nvim-treesitter/nvim-treesitter-context",
}

local function attach(buf, lang)
  if not pcall(vim.treesitter.start, buf, lang) then
    return -- no parser available for this language
  end

  local win = vim.fn.bufwinid(buf)
  if win ~= -1 then
    vim.wo[win][0].foldmethod = "expr"
    vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end

  local ok, query = pcall(vim.treesitter.query.get, lang, "indents")
  if ok and query then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

local MIN_CLI = "0.26.1"

--- Version of the `tree-sitter` executable on PATH, or nil.
local function cli_version()
  if vim.fn.executable("tree-sitter") == 0 then
    return nil
  end
  local ok, res = pcall(function()
    return vim.system({ "tree-sitter", "--version" }, { text = true }):wait(3000)
  end)
  if not ok or res.code ~= 0 then
    return nil
  end
  return vim.version.parse((res.stdout or ""):match("%d+%.%d+%.%d+") or "")
end

--- Run `cb` once a recent enough tree-sitter CLI is available.
local function with_cli(cb)
  local version = cli_version()
  if version and not vim.version.lt(version, MIN_CLI) then
    return cb()
  end

  if vim.fn.executable("cc") == 0 and vim.fn.executable("gcc") == 0 and vim.fn.executable("clang") == 0 then
    vim.notify_once("No C compiler found: tree-sitter parsers cannot be built", vim.log.levels.WARN)
    return
  end

  local reason = version and ("tree-sitter CLI %s is older than %s"):format(tostring(version), MIN_CLI)
    or "tree-sitter CLI not found"
  vim.notify(reason .. "; installing it with Mason...")

  -- Mason's bin directory is prepended to PATH, so its binary wins over an old system one.
  require("plugins.mason").ensure({ "tree-sitter-cli" }, function()
    local installed = cli_version()
    if installed and not vim.version.lt(installed, MIN_CLI) then
      cb()
    else
      vim.notify(
        "tree-sitter CLI still unavailable. Install it manually (see README) and run :checkhealth nvim-treesitter",
        vim.log.levels.ERROR
      )
    end
  end)
end

local function install_missing(wanted)
  local ts = require("nvim-treesitter")
  local installed = {}
  for _, lang in ipairs(ts.get_installed()) do
    installed[lang] = true
  end
  local missing = vim.tbl_filter(function(lang)
    return not installed[lang]
  end, wanted)
  if #missing == 0 then
    return
  end
  -- Installation is async; re-attach already-open buffers once it finishes.
  local task = ts.install(missing)
  if type(task) == "table" and task.await then
    task:await(function()
      vim.schedule(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
            local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
            if lang then
              attach(buf, lang)
            end
          end
        end
      end)
    end)
  end
end

function M.setup()
  with_cli(function()
    install_missing(require("lang").all().treesitter)
  end)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
    callback = function(ev)
      local lang = vim.treesitter.language.get_lang(ev.match)
      if lang then
        attach(ev.buf, lang)
      end
    end,
  })

  require("treesitter-context").setup({ max_lines = 3, multiline_threshold = 1 })
  vim.keymap.set("n", "[x", function()
    require("treesitter-context").go_to_context(vim.v.count1)
  end, { desc = "Jump to context" })
  vim.keymap.set("n", "<leader>ux", function()
    require("treesitter-context").toggle()
  end, { desc = "Toggle treesitter context" })
end

return M
