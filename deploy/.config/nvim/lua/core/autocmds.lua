-- Global autocommands
local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Restore the last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_position"),
  callback = function(ev)
    local exclude = { gitcommit = true, gitrebase = true }
    if exclude[vim.bo[ev.buf].filetype] or vim.b[ev.buf].last_pos_restored then
      return
    end
    vim.b[ev.buf].last_pos_restored = true
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Keep splits balanced when the terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. tab)
  end,
})

-- Close utility windows with `q`
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "help", "qf", "man", "checkhealth", "nvim-pack", "dap-float", "notify", "startuptime" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true, desc = "Close window" })
  end,
})

-- Create missing parent directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_mkdir"),
  callback = function(ev)
    if ev.match:match("^%w%w+:[\\/][\\/]") then
      return -- skip URLs like oil:// or scp://
    end
    local file = vim.uv.fs_realpath(ev.match) or ev.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Terminal buffers: no line numbers, start in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Wrap and spell-check prose filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
