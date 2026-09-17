-- C / C++: clangd (with clang-tidy), CMake LSP, clang-format, codelldb
return {
  treesitter = { "c", "cpp", "cmake", "doxygen" },

  servers = {
    clangd = {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
    },
    neocmake = {},
  },

  on_attach = {
    clangd = function(_, buf)
      vim.keymap.set("n", "<leader>ch", function()
        if vim.fn.exists(":LspClangdSwitchSourceHeader") == 2 then
          vim.cmd("LspClangdSwitchSourceHeader")
        else
          vim.notify("clangd switch command unavailable", vim.log.levels.WARN)
        end
      end, { buffer = buf, desc = "Switch source/header" })
    end,
  },

  tools = { "clang-format", "codelldb" },

  formatters = {
    c = { "clang_format" },
    cpp = { "clang_format" },
  },

  filetypes = {
    c = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
    cpp = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
    cmake = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  },

  dap = function()
    local dap = require("dap")
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
        detached = vim.fn.has("win32") == 0,
      },
    }

    local configs = {
      {
        name = "Launch executable",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        args = function()
          local input = vim.fn.input("Arguments: ")
          return vim.split(input, " ", { trimempty = true })
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
      {
        name = "Attach to process",
        type = "codelldb",
        request = "attach",
        pid = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }
    dap.configurations.c = configs
    dap.configurations.cpp = configs
  end,
}
