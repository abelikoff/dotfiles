-- Language registry.
--
-- Each file in lua/lang/ returns a table describing one language stack:
--   treesitter     = { "parser", ... }                 tree-sitter parsers to install
--   servers        = { lspconfig_name = { ...cfg } }   LSP servers (vim.lsp.config overrides)
--   on_attach      = { lspconfig_name = fn(client, buf) }
--   tools          = { "mason-package", ... }          formatters/linters/debuggers via Mason
--   formatters     = { filetype = { ... } }            conform.nvim formatters_by_ft
--   formatter_opts = { formatter = { ... } }           conform.nvim formatter overrides
--   linters        = { filetype = { ... } }            nvim-lint linters_by_ft
--   filetypes      = { filetype = { bo options } }     buffer-local options
--   plugins        = { "owner/repo", ... }             extra language plugins
--   dap            = fn()                               debugger adapter/config setup
--
-- To add a language: create lua/lang/<name>.lua and append <name> below.
local M = {}

M.enabled = { "go", "python", "shell", "javascript", "cpp", "lua" }

-- Parsers useful regardless of language
local common_parsers = {
  "bash", "diff", "dockerfile", "git_config", "gitcommit", "gitignore", "json",
  "make", "markdown", "markdown_inline", "query", "regex", "toml", "vim", "vimdoc", "yaml",
}

local function dedupe(list)
  local seen, out = {}, {}
  for _, v in ipairs(list) do
    if not seen[v] then
      seen[v] = true
      out[#out + 1] = v
    end
  end
  return out
end

local cache

--- Merge every enabled language spec into one table (memoized).
function M.all()
  if cache then
    return cache
  end

  local agg = {
    treesitter = vim.deepcopy(common_parsers),
    servers = {},
    on_attach = {},
    tools = {},
    formatters = {},
    formatter_opts = {},
    linters = {},
    filetypes = {},
    plugins = {},
    dap = {},
  }

  for _, name in ipairs(M.enabled) do
    local ok, spec = pcall(require, "lang." .. name)
    if not ok then
      vim.notify(("lang.%s failed to load:\n%s"):format(name, spec), vim.log.levels.ERROR)
    else
      vim.list_extend(agg.treesitter, spec.treesitter or {})
      vim.list_extend(agg.tools, spec.tools or {})
      vim.list_extend(agg.plugins, spec.plugins or {})
      for _, key in ipairs({ "servers", "on_attach", "formatters", "formatter_opts", "linters", "filetypes" }) do
        for k, v in pairs(spec[key] or {}) do
          agg[key][k] = v
        end
      end
      if spec.dap then
        agg.dap[#agg.dap + 1] = { name = name, setup = spec.dap }
      end
    end
  end

  agg.treesitter = dedupe(agg.treesitter)
  agg.tools = dedupe(agg.tools)
  cache = agg
  return agg
end

--- Names of all configured LSP servers.
function M.server_names()
  local names = vim.tbl_keys(M.all().servers)
  table.sort(names)
  return names
end

--- Apply per-filetype buffer options (indentation style, etc.).
function M.setup_filetypes()
  local fts = M.all().filetypes
  if vim.tbl_isempty(fts) then
    return
  end
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_lang_filetypes", { clear = true }),
    pattern = vim.tbl_keys(fts),
    callback = function(ev)
      for option, value in pairs(fts[ev.match] or {}) do
        vim.bo[ev.buf][option] = value
      end
    end,
  })
end

return M
