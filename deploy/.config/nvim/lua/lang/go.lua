-- Go: gopls, goimports + gofumpt, golangci-lint, delve
return {
  treesitter = { "go", "gomod", "gosum", "gowork", "gotmpl" },

  servers = {
    gopls = {
      settings = {
        gopls = {
          gofumpt = true,
          staticcheck = true,
          usePlaceholders = true,
          completeUnimported = true,
          semanticTokens = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-node_modules", "-vendor" },
          analyses = {
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          codelenses = {
            generate = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
            gc_details = false,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    },
  },

  tools = { "goimports", "gofumpt", "golangci-lint", "delve" },

  formatters = {
    go = { "goimports", "gofumpt" },
  },

  linters = {
    go = { "golangcilint" },
  },

  -- Go uses real tabs
  filetypes = {
    go = { expandtab = false, tabstop = 4, shiftwidth = 4, softtabstop = 0 },
    gomod = { expandtab = false, tabstop = 4, shiftwidth = 4, softtabstop = 0 },
  },

  plugins = { "leoluz/nvim-dap-go" },

  dap = function()
    require("dap-go").setup()
    vim.keymap.set("n", "<leader>dgt", function()
      require("dap-go").debug_test()
    end, { desc = "Debug nearest Go test" })
    vim.keymap.set("n", "<leader>dgl", function()
      require("dap-go").debug_last_test()
    end, { desc = "Debug last Go test" })
  end,
}
