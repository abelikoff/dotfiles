-- Python: basedpyright (types) + ruff (lint/format), debugpy
return {
  treesitter = { "python", "requirements", "rst" },

  servers = {
    basedpyright = {
      settings = {
        basedpyright = {
          disableOrganizeImports = true, -- ruff handles imports
          analysis = {
            typeCheckingMode = "standard",
            autoImportCompletions = true,
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
          },
        },
      },
    },
    -- ruff reads pyproject.toml / ruff.toml, so no overrides are needed here
    ruff = {},
  },

  on_attach = {
    -- Let basedpyright own hover; ruff's hover is minimal.
    ruff = function(client)
      client.server_capabilities.hoverProvider = false
    end,
  },

  tools = { "debugpy" },

  formatters = {
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
  },

  filetypes = {
    python = { expandtab = true, tabstop = 4, shiftwidth = 4, softtabstop = 4 },
  },

  plugins = { "mfussenegger/nvim-dap-python" },

  dap = function()
    -- Prefer Mason's debugpy venv; fall back to whatever python is on PATH.
    local base = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/"
    local python = base .. (vim.fn.has("win32") == 1 and "Scripts/python.exe" or "bin/python")
    if vim.fn.executable(python) == 0 then
      python = vim.fn.exepath("python3") ~= "" and "python3" or "python"
    end
    require("dap-python").setup(python)

    vim.keymap.set("n", "<leader>dpm", function()
      require("dap-python").test_method()
    end, { desc = "Debug Python test method" })
    vim.keymap.set("n", "<leader>dpc", function()
      require("dap-python").test_class()
    end, { desc = "Debug Python test class" })
  end,
}
