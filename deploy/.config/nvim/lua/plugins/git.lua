-- Git: gutter signs, hunk actions, inline blame
local M = {}

M.specs = { "lewis6991/gitsigns.nvim" }

function M.setup()
  require("gitsigns").setup({
    current_line_blame_opts = { delay = 500, virt_text_pos = "eol" },
    preview_config = { border = "rounded" },
    on_attach = function(buf)
      local gs = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
      end

      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next hunk")
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Previous hunk")

      map({ "n", "x" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
      map({ "n", "x" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
      map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
      map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk")
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, "Blame line")
      map("n", "<leader>hB", gs.blame, "Blame buffer")
      map("n", "<leader>hd", gs.diffthis, "Diff against index")
      map("n", "<leader>ub", gs.toggle_current_line_blame, "Toggle inline blame")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
    end,
  })
end

return M
