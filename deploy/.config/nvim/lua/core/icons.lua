-- Central icon registry.
-- Every Nerd Font glyph used by this config lives here, so the whole setup can
-- fall back to plain ASCII by setting `vim.g.have_nerd_font = false` in init.lua.

local nerd = vim.g.have_nerd_font ~= false

local glyphs = {
  diagnostics = {
    Error = " ",
    Warn = " ",
    Info = " ",
    Hint = "󰌵 ",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
    branch = "",
  },
  dap = {
    breakpoint = "",
    condition = "",
    rejected = "",
    logpoint = ".>",
    stopped = "󰁕",
  },
  lsp = "",
  fold = { open = "", close = "" },
  separators = {
    component = { left = "", right = "" },
    section = { left = "", right = "" },
  },
}

local ascii = {
  diagnostics = { Error = "E ", Warn = "W ", Info = "I ", Hint = "H " },
  git = { added = "+", modified = "~", removed = "-", branch = "" },
  dap = { breakpoint = "B", condition = "C", rejected = "R", logpoint = "L", stopped = ">" },
  lsp = "LSP:",
  fold = { open = "v", close = ">" },
  separators = {
    component = { left = "|", right = "|" },
    section = { left = "", right = "" },
  },
}

return nerd and glyphs or ascii
