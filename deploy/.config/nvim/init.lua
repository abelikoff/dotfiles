-- ~/.config/nvim/init.lua
-- Modular Neovim 0.12 configuration (Go, Python, Shell, JavaScript/TypeScript, C/C++)
-- Plugins are managed by the built-in `vim.pack` manager (no lazy.nvim needed).

if vim.fn.has("nvim-0.12") == 0 then
  vim.api.nvim_echo({ { "This configuration requires Neovim 0.12 or newer", "ErrorMsg" } }, true, {})
  return
end

vim.loader.enable()

-- Leaders must be set before any mapping is defined.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set to false if your terminal font is NOT a Nerd Font; all icons fall back to ASCII.
vim.g.have_nerd_font = true

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("lang").setup_filetypes() -- per-language buffer options (tabs vs spaces, etc.)
require("plugins") -- install + configure plugins
