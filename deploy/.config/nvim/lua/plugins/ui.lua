-- UI: colorscheme, icons, statusline, keymap hints, LSP progress/notifications
local M = {}

M.specs = {
  "folke/tokyonight.nvim",
  "nvim-mini/mini.nvim", -- provides mini.icons (and editing modules, see editor.lua)
  "nvim-lualine/lualine.nvim",
  "folke/which-key.nvim",
  "j-hui/fidget.nvim",
}

local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end
  local names = vim.tbl_map(function(c)
    return c.name
  end, clients)
  return require("core.icons").lsp .. " " .. table.concat(names, ", ")
end

function M.setup()
  local icons = require("core.icons")
  local nerd = vim.g.have_nerd_font

  -- Colorscheme --------------------------------------------------------------
  require("tokyonight").setup({
    style = "night",
    styles = { comments = { italic = true }, keywords = { italic = true } },
  })
  vim.cmd.colorscheme("tokyonight")

  -- Icons: mini.icons, also impersonating nvim-web-devicons for other plugins
  require("mini.icons").setup({ style = nerd and "glyph" or "ascii" })
  MiniIcons.mock_nvim_web_devicons()

  -- Statusline ---------------------------------------------------------------
  require("lualine").setup({
    options = {
      theme = "auto",
      globalstatus = true,
      icons_enabled = nerd,
      component_separators = icons.separators.component,
      section_separators = icons.separators.section,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        { "branch", icon = icons.git.branch },
        {
          "diff",
          symbols = { added = icons.git.added, modified = icons.git.modified, removed = icons.git.removed },
        },
      },
      lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        { "filename", path = 1, symbols = { modified = " ●", readonly = " [RO]" } },
      },
      lualine_x = { lsp_clients, "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    extensions = { "quickfix", "oil", "man", "nvim-dap-ui", "trouble" },
  })

  -- Keymap hints -------------------------------------------------------------
  local wk = require("which-key")
  wk.setup({
    preset = "helix",
    icons = { mappings = nerd },
  })
  wk.add({
    { "<leader>b", group = "buffer" },
    { "<leader>c", group = "code" },
    { "<leader>d", group = "debug" },
    { "<leader>dg", group = "go" },
    { "<leader>dp", group = "python" },
    { "<leader>f", group = "find" },
    { "<leader>g", group = "git" },
    { "<leader>h", group = "hunks" },
    { "<leader>p", group = "plugins" },
    { "<leader>q", group = "quit" },
    { "<leader>s", group = "symbols" },
    { "<leader>t", group = "terminal" },
    { "<leader>u", group = "toggles" },
    { "<leader>x", group = "diagnostics" },
    { "gs", group = "surround" },
  })

  -- LSP progress + prettier vim.notify ---------------------------------------
  require("fidget").setup({
    notification = {
      override_vim_notify = true,
      window = { winblend = 0, border = "rounded" },
    },
  })
end

return M
