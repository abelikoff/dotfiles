-- Mason: portable installer for LSP servers, formatters, linters, debug adapters
-- and the tree-sitter CLI. Loaded before treesitter/lsp so both can use it.
local M = {}

M.specs = { "mason-org/mason.nvim" }

function M.setup()
  require("mason").setup({
    PATH = "prepend", -- Mason binaries take precedence over system ones
    ui = { border = "rounded" },
  })
  vim.keymap.set("n", "<leader>cm", "<cmd>Mason<CR>", { desc = "Mason" })
end

--- Install Mason packages that are missing.
---@param names string[] Mason package names
---@param on_ready? fun() called (on the main loop) once every package is installed
function M.ensure(names, on_ready)
  local registry = require("mason-registry")
  registry.refresh(function()
    local pending = {}
    for _, name in ipairs(names) do
      local ok, pkg = pcall(registry.get_package, name)
      if not ok then
        vim.notify("Mason: unknown package " .. name, vim.log.levels.WARN)
      elseif not pkg:is_installed() then
        pending[name] = true
        if not (pkg.is_installing and pkg:is_installing()) then
          vim.notify("Mason: installing " .. name)
          pkg:install()
        end
      end
    end

    if not on_ready then
      return
    end
    if vim.tbl_isempty(pending) then
      vim.schedule(on_ready)
      return
    end

    local done = false
    local function settle(pkg, success)
      if done or not pending[pkg.name] then
        return
      end
      if not success then
        done = true
        vim.schedule(function()
          vim.notify("Mason: failed to install " .. pkg.name .. " (see :MasonLog)", vim.log.levels.ERROR)
        end)
        return
      end
      pending[pkg.name] = nil
      if vim.tbl_isempty(pending) then
        done = true
        vim.schedule(on_ready)
      end
    end
    registry:on("package:install:success", function(pkg)
      settle(pkg, true)
    end)
    registry:on("package:install:failed", function(pkg)
      settle(pkg, false)
    end)
  end)
end

return M
