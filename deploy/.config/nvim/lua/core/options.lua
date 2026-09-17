-- Core editor options (no plugin dependencies)
local icons = require("core.icons")
local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false -- mode is shown in the statusline
opt.laststatus = 3 -- single global statusline
opt.winborder = "rounded" -- default border for floating windows (hover, signature, etc.)
opt.pumheight = 12
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = {
  eob = " ",
  fold = " ",
  foldsep = " ",
  foldopen = icons.fold.open,
  foldclose = icons.fold.close,
}

-- Behaviour
opt.mouse = "a"
opt.undofile = true
opt.confirm = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.virtualedit = "block"
opt.inccommand = "split"
opt.ignorecase = true
opt.smartcase = true
opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }
opt.shortmess:append("I")

-- Sync with the system clipboard after startup (avoids slowing down init).
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)

-- Indentation defaults (languages override these in lua/lang/*.lua)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.breakindent = true

-- Folding: tree-sitter sets foldexpr per buffer; keep everything open by default.
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldtext = ""

-- Disable unused remote-plugin providers (faster startup, cleaner :checkhealth)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
