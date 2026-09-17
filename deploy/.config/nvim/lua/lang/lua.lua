-- Lua: lua_ls + stylua (mainly for editing this configuration)
return {
  treesitter = { "lua", "luadoc", "luap" },

  servers = {
    lua_ls = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
          },
          completion = { callSnippet = "Replace" },
          hint = { enable = true, arrayIndex = "Disable" },
          diagnostics = { globals = { "vim" } },
          telemetry = { enable = false },
        },
      },
    },
  },

  tools = { "stylua" },

  formatters = {
    lua = { "stylua" },
  },

  filetypes = {
    lua = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  },
}
