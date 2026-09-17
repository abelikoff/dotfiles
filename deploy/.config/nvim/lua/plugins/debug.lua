-- Debugging: nvim-dap + dap-ui + inline variable values.
-- Adapters/configurations are defined per language in lua/lang/*.lua (`dap` field).
local M = {}

M.specs = {
  "mfussenegger/nvim-dap",
  "nvim-neotest/nvim-nio",
  "rcarriga/nvim-dap-ui",
  "theHamsta/nvim-dap-virtual-text",
}

function M.setup()
  local dap, dapui = require("dap"), require("dapui")
  local icons = require("core.icons").dap
  local nerd = vim.g.have_nerd_font

  -- UI -----------------------------------------------------------------------
  local ui_opts = {}
  if not nerd then
    ui_opts.icons = { expanded = "v", collapsed = ">", current_frame = ">" }
    ui_opts.controls = { enabled = false }
  end
  dapui.setup(ui_opts)
  require("nvim-dap-virtual-text").setup({})

  local function open_ui()
    dapui.open()
  end
  local function close_ui()
    dapui.close()
  end
  dap.listeners.before.attach.user_dapui = open_ui
  dap.listeners.before.launch.user_dapui = open_ui
  dap.listeners.before.event_terminated.user_dapui = close_ui
  dap.listeners.before.event_exited.user_dapui = close_ui

  -- Signs ----------------------------------------------------------------------
  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
  local signs = {
    DapBreakpoint = { icons.breakpoint, "DiagnosticError" },
    DapBreakpointCondition = { icons.condition, "DiagnosticWarn" },
    DapBreakpointRejected = { icons.rejected, "DiagnosticError" },
    DapLogPoint = { icons.logpoint, "DiagnosticInfo" },
    DapStopped = { icons.stopped, "DiagnosticWarn", "DapStoppedLine" },
  }
  for name, sign in pairs(signs) do
    vim.fn.sign_define(name, { text = sign[1], texthl = sign[2], linehl = sign[3], numhl = sign[3] })
  end

  -- Language adapters ------------------------------------------------------------
  for _, entry in ipairs(require("lang").all().dap) do
    local ok, err = pcall(entry.setup)
    if not ok then
      vim.notify(("DAP setup for %s failed:\n%s"):format(entry.name, err), vim.log.levels.WARN)
    end
  end

  -- Keymaps ------------------------------------------------------------------------
  local map = vim.keymap.set
  map("n", "<F5>", dap.continue, { desc = "Debug: continue / start" })
  map("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
  map("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
  map("n", "<F12>", dap.step_out, { desc = "Debug: step out" })
  map("n", "<leader>dc", dap.continue, { desc = "Continue / start" })
  map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
  map("n", "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, { desc = "Conditional breakpoint" })
  map("n", "<leader>dL", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
  end, { desc = "Log point" })
  map("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
  map("n", "<leader>dl", dap.run_last, { desc = "Run last" })
  map("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
  map("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
  map("n", "<leader>du", dapui.toggle, { desc = "Toggle debug UI" })
  map({ "n", "x" }, "<leader>de", dapui.eval, { desc = "Evaluate expression" })
end

return M
