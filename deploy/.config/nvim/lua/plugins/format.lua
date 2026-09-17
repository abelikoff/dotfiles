-- Formatting: conform.nvim (format-on-save, toggleable)
local M = {}

M.specs = { "stevearc/conform.nvim" }

function M.setup()
  local lang = require("lang").all()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = lang.formatters,
    formatters = lang.formatter_opts,
    default_format_opts = { lsp_format = "fallback" },
    notify_on_error = true,
    format_on_save = function(buf)
      if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then
        return nil
      end
      return { timeout_ms = 1500 }
    end,
  })

  -- Let `gq` use conform as well
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  vim.keymap.set({ "n", "x" }, "<leader>cf", function()
    conform.format({ async = true })
  end, { desc = "Format buffer/selection" })

  vim.keymap.set("n", "<leader>uf", function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
  end, { desc = "Toggle format on save (global)" })

  vim.keymap.set("n", "<leader>uF", function()
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    vim.notify("Format on save (buffer): " .. (vim.b.disable_autoformat and "off" or "on"))
  end, { desc = "Toggle format on save (buffer)" })

  vim.keymap.set("n", "<leader>cF", "<cmd>ConformInfo<CR>", { desc = "Formatter info" })
end

return M
