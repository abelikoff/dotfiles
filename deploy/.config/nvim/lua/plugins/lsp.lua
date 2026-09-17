-- LSP: native vim.lsp.config()/vim.lsp.enable(), server definitions from
-- nvim-lspconfig, binaries managed by Mason.
local M = {}

M.specs = {
  "neovim/nvim-lspconfig", -- provides lsp/<server>.lua default configs
  "mason-org/mason-lspconfig.nvim", -- mason.nvim itself is set up in plugins/mason.lua
}

local function setup_diagnostics()
  local icons = require("core.icons").diagnostics
  local sev = vim.diagnostic.severity
  vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
    float = { border = "rounded", source = "if_many" },
    signs = {
      text = {
        [sev.ERROR] = icons.Error,
        [sev.WARN] = icons.Warn,
        [sev.INFO] = icons.Info,
        [sev.HINT] = icons.Hint,
      },
    },
  })
end

local function on_attach(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  if not client then
    return
  end
  local buf = ev.buf
  local fzf = require("fzf-lua")
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = "LSP: " .. desc })
  end

  -- Built-in defaults already provide K (hover), grn (rename), gra (code action),
  -- gO (document symbols) and <C-s> (signature help in insert mode).
  -- The mappings below add fzf-lua picker variants and a few extras.
  map("n", "gd", fzf.lsp_definitions, "Goto definition")
  map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
  map("n", "gy", fzf.lsp_typedefs, "Goto type definition")
  map("n", "grr", fzf.lsp_references, "References")
  map("n", "gri", fzf.lsp_implementations, "Implementations")
  map("n", "<leader>ss", fzf.lsp_document_symbols, "Document symbols")
  map("n", "<leader>sS", fzf.lsp_live_workspace_symbols, "Workspace symbols")
  map("n", "<leader>ci", fzf.lsp_incoming_calls, "Incoming calls")
  map("n", "<leader>co", fzf.lsp_outgoing_calls, "Outgoing calls")
  map({ "n", "x" }, "<leader>ca", fzf.lsp_code_actions, "Code action")
  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
  map("n", "<leader>cl", vim.lsp.codelens.run, "Run codelens")

  if client:supports_method("textDocument/inlayHint") then
    map("n", "<leader>uh", function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
    end, "Toggle inlay hints")
  end

  -- Highlight other references of the symbol under the cursor
  if client:supports_method("textDocument/documentHighlight") then
    local group = vim.api.nvim_create_augroup("user_lsp_highlight_" .. buf, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
      group = group,
      buffer = buf,
      callback = vim.lsp.buf.clear_references,
    })
    vim.api.nvim_create_autocmd("LspDetach", {
      group = group,
      buffer = buf,
      callback = function()
        vim.lsp.buf.clear_references()
        pcall(vim.api.nvim_del_augroup_by_id, group)
      end,
    })
  end

  -- Code lenses (gopls: run tests, go mod tidy, ...)
  if client:supports_method("textDocument/codeLens") then
    if vim.lsp.codelens.enable then
      vim.lsp.codelens.enable(true, { bufnr = buf })
    else
      vim.lsp.codelens.refresh({ bufnr = buf })
      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("user_lsp_codelens_" .. buf, { clear = true }),
        buffer = buf,
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = buf })
        end,
      })
    end
  end

  -- Per-language hooks from lua/lang/*.lua
  local hook = require("lang").all().on_attach[client.name]
  if hook then
    hook(client, buf)
  end
end

function M.setup()
  local lang = require("lang")
  local servers = lang.server_names()

  setup_diagnostics()

  -- Capabilities shared by every server (blink.cmp adds completion features)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_blink, blink = pcall(require, "blink.cmp")
  if ok_blink then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end
  vim.lsp.config("*", { capabilities = capabilities })

  -- Per-server overrides merged on top of nvim-lspconfig's defaults
  for name, cfg in pairs(lang.all().servers) do
    if not vim.tbl_isempty(cfg) then
      vim.lsp.config(name, cfg)
    end
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
    callback = on_attach,
  })

  -- Mason installs any missing server and enables it once installed.
  require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_enable = servers,
  })

  -- Also enable servers already on PATH (e.g. system clangd or `go install`ed gopls).
  for _, name in ipairs(servers) do
    local cfg = vim.lsp.config[name]
    local cmd = cfg and cfg.cmd
    if type(cmd) == "function" or (type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1) then
      vim.lsp.enable(name)
    end
  end

  -- Formatters, linters and debug adapters
  require("plugins.mason").ensure(lang.all().tools)

  vim.keymap.set("n", "<leader>cI", "<cmd>checkhealth vim.lsp<CR>", { desc = "LSP info" })
end

return M
