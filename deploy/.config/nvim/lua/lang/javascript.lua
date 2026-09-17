-- JavaScript / TypeScript: ts_ls, ESLint LSP, prettier, js-debug-adapter
local inlay_hints = {
  includeInlayParameterNameHints = "literals",
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

local js_like = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
local prettier = { "prettierd", "prettier", stop_after_first = true }

local formatters, filetypes = {}, {}
for _, ft in ipairs(vim.list_extend(vim.deepcopy(js_like), { "json", "jsonc", "css", "scss", "html", "yaml", "markdown" })) do
  formatters[ft] = prettier
end
for _, ft in ipairs(vim.list_extend(vim.deepcopy(js_like), { "json", "jsonc", "css", "html", "yaml" })) do
  filetypes[ft] = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 }
end

return {
  treesitter = { "javascript", "typescript", "tsx", "jsdoc", "json", "html", "css", "scss" },

  servers = {
    ts_ls = {
      settings = {
        typescript = { inlayHints = inlay_hints },
        javascript = { inlayHints = inlay_hints },
      },
    },
    eslint = {
      settings = { workingDirectories = { mode = "auto" } },
    },
    jsonls = {},
  },

  on_attach = {
    -- ESLint fixes on save, before conform formats
    eslint = function(_, buf)
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("user_eslint_fix_" .. buf, { clear = true }),
        buffer = buf,
        callback = function()
          if vim.fn.exists(":LspEslintFixAll") == 2 then
            vim.cmd("silent! LspEslintFixAll")
          end
        end,
      })
    end,
    -- Formatting is delegated to prettier via conform
    ts_ls = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },

  tools = { "prettierd", "js-debug-adapter" },

  formatters = formatters,
  filetypes = filetypes,

  dap = function()
    local dap = require("dap")
    for _, adapter in ipairs({ "pwa-node", "node" }) do
      dap.adapters[adapter] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = { command = "js-debug-adapter", args = { "${port}" } },
      }
    end

    local configs = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch current file (node)",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to process",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
        sourceMaps = true,
      },
    }
    for _, ft in ipairs(js_like) do
      dap.configurations[ft] = dap.configurations[ft] or configs
    end
  end,
}
