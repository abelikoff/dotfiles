-- Completion: blink.cmp + friendly-snippets
-- Pinned to v1 release tags so blink can download its prebuilt Rust fuzzy matcher.
local M = {}

M.specs = {
  { src = "saghen/blink.cmp", version = vim.version.range("^1.0.0") },
  "rafamadriz/friendly-snippets",
}

function M.setup()
  local nerd = vim.g.have_nerd_font

  local menu_draw = { treesitter = { "lsp" } }
  if not nerd then
    -- no kind icons without a Nerd Font; show the kind name instead
    menu_draw.columns = { { "label", "label_description", gap = 1 }, { "kind" } }
  end

  require("blink.cmp").setup({
    -- default preset: <C-y> accept, <C-space> open/docs, <C-n>/<C-p> select,
    -- <C-e> hide, <Tab>/<S-Tab> snippet jumps, <C-k> signature help
    keymap = { preset = "default" },

    appearance = { nerd_font_variant = "mono" },

    completion = {
      list = { selection = { preselect = true, auto_insert = false } },
      documentation = { auto_show = true, auto_show_delay_ms = 250 },
      menu = { draw = menu_draw },
      ghost_text = { enabled = false },
    },

    signature = { enabled = true },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    cmdline = { enabled = true },

    -- Falls back to the pure-Lua matcher if the binary can't be downloaded
    fuzzy = { implementation = "prefer_rust_with_warning" },
  })
end

return M
