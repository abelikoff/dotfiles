-- Linting: nvim-lint for linters that are not already exposed through an LSP
-- (ruff, ESLint, shellcheck-via-bashls and clang-tidy-via-clangd are LSP-based).
local M = {}

M.specs = { "mfussenegger/nvim-lint" }

function M.setup()
  local lint = require("lint")
  lint.linters_by_ft = require("lang").all().linters

  local function try_lint()
    -- ignore_errors: stay quiet when a linter binary isn't installed yet
    lint.try_lint(nil, { ignore_errors = true })
  end

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
    callback = function()
      if vim.bo.modifiable and vim.bo.buftype == "" then
        try_lint()
      end
    end,
  })

  vim.keymap.set("n", "<leader>cL", try_lint, { desc = "Lint buffer" })
end

return M
