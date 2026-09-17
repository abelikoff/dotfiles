-- Shell: bash-language-server (runs shellcheck automatically) + shfmt
return {
  treesitter = { "bash" },

  servers = {
    bashls = {
      settings = {
        bashIde = {
          globPattern = "*@(.sh|.inc|.bash|.command)",
          shellcheckArguments = { "--external-sources" },
        },
      },
    },
  },

  tools = { "shellcheck", "shfmt" },

  formatters = {
    sh = { "shfmt" },
    bash = { "shfmt" },
  },

  -- 2-space indent, indent switch cases.
  -- Remove this block if your projects define shfmt style in .editorconfig.
  formatter_opts = {
    shfmt = { prepend_args = { "-i", "2", "-ci" } },
  },

  filetypes = {
    sh = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
    bash = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
    zsh = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
  },
}
