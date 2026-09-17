-- Editing & navigation: fzf-lua picker, oil file explorer, mini.* helpers,
-- flash motions, trouble diagnostics list
local M = {}

M.specs = {
  "ibhagwan/fzf-lua",
  "stevearc/oil.nvim",
  "nvim-mini/mini.nvim",
  "folke/flash.nvim",
  "folke/trouble.nvim",
}

function M.setup()
  local nerd = vim.g.have_nerd_font
  local map = vim.keymap.set

  -- Fuzzy finder -------------------------------------------------------------
  local fzf = require("fzf-lua")
  fzf.setup({
    "default-title",
    fzf_colors = true,
    winopts = { height = 0.85, width = 0.85, preview = { layout = "flex" } },
    defaults = { file_icons = nerd and "mini" or false },
  })
  fzf.register_ui_select()

  map("n", "<leader><space>", fzf.files, { desc = "Find files" })
  map("n", "<leader>ff", fzf.files, { desc = "Files" })
  map("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
  map("n", "<leader>fw", fzf.grep_cword, { desc = "Grep word under cursor" })
  map("x", "<leader>fw", fzf.grep_visual, { desc = "Grep selection" })
  map("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
  map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
  map("n", "<leader>fh", fzf.helptags, { desc = "Help" })
  map("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })
  map("n", "<leader>fc", fzf.commands, { desc = "Commands" })
  map("n", "<leader>fd", fzf.diagnostics_document, { desc = "Document diagnostics" })
  map("n", "<leader>fD", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
  map("n", "<leader>fR", fzf.resume, { desc = "Resume last picker" })
  map("n", "<leader>/", fzf.blines, { desc = "Search in buffer" })
  map("n", "<leader>fn", function()
    fzf.files({ cwd = vim.fn.stdpath("config") })
  end, { desc = "Neovim config files" })
  map("n", "<leader>gs", fzf.git_status, { desc = "Git status" })
  map("n", "<leader>gc", fzf.git_commits, { desc = "Git commits" })
  map("n", "<leader>gB", fzf.git_branches, { desc = "Git branches" })

  -- File explorer ------------------------------------------------------------
  local oil = require("oil")
  oil.setup({
    default_file_explorer = true,
    columns = nerd and { "icon" } or {},
    view_options = { show_hidden = true },
    keymaps = { ["q"] = "actions.close" },
    float = { border = "rounded" },
  })
  map("n", "-", function()
    oil.open()
  end, { desc = "Open parent directory" })
  map("n", "<leader>e", function()
    oil.toggle_float()
  end, { desc = "File explorer (float)" })

  -- mini.* editing helpers -----------------------------------------------------
  require("mini.ai").setup({ n_lines = 500 })
  require("mini.pairs").setup()
  require("mini.bufremove").setup()
  require("mini.surround").setup({
    -- "gs" prefix so plain `s` stays free for flash.nvim
    mappings = {
      add = "gsa",
      delete = "gsd",
      find = "gsf",
      find_left = "gsF",
      highlight = "gsh",
      replace = "gsr",
      update_n_lines = "gsn",
    },
  })
  local indentscope = require("mini.indentscope")
  indentscope.setup({
    symbol = "│",
    options = { try_as_border = true },
    draw = { delay = 50, animation = indentscope.gen_animation.none() },
  })
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_indentscope_off", { clear = true }),
    pattern = { "help", "oil", "fzf", "trouble", "checkhealth", "nvim-pack", "dapui_*", "dap-repl" },
    callback = function(ev)
      vim.b[ev.buf].miniindentscope_disable = true
    end,
  })

  map("n", "<leader>bd", function()
    MiniBufremove.delete()
  end, { desc = "Delete buffer (keep window)" })

  -- Motions ------------------------------------------------------------------
  local flash = require("flash")
  flash.setup({ modes = { search = { enabled = false } } })
  map({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash jump" })
  map({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash treesitter select" })
  map("o", "r", flash.remote, { desc = "Flash remote" })

  -- Diagnostics / references list ---------------------------------------------
  require("trouble").setup({})
  map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
  map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
  map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols outline" })
  map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix list" })
end

return M
