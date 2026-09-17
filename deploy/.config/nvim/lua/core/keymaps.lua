-- Global keymaps that do not depend on plugins.
-- Plugin-specific mappings live next to the plugin's setup in lua/plugins/*.lua.
local map = vim.keymap.set

-- General
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>qall<CR>", { desc = "Quit all" })
map("n", "<leader>qr", "<cmd>restart<CR>", { desc = "Restart Neovim" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Better movement over wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })
map("n", "<leader>-", "<C-w>s", { desc = "Split below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split right" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Alternate buffer" })

-- Editing
map("x", "<", "<gv", { desc = "Indent left (keep selection)" })
map("x", ">", ">gv", { desc = "Indent right (keep selection)" })
map("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Diagnostics ([d / ]d are built-in defaults)
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>xl", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- UI toggles
map("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
map("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle wrap" })
map("n", "<leader>ur", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative numbers" })
map("n", "<leader>us", function()
  vim.wo.spell = not vim.wo.spell
end, { desc = "Toggle spell" })

-- Terminal in a bottom split
map("n", "<leader>tt", function()
  vim.cmd("botright 15split | terminal")
  vim.cmd.startinsert()
end, { desc = "Terminal (bottom split)" })

-- vim.pack helpers
map("n", "<leader>pu", function()
  vim.pack.update()
end, { desc = "Update plugins" })
map("n", "<leader>pl", function()
  local names = vim.tbl_map(function(p)
    return (p.active and "* " or "  ") .. p.spec.name
  end, vim.pack.get(nil, { info = false }))
  vim.notify(table.concat(names, "\n"), vim.log.levels.INFO, { title = "vim.pack" })
end, { desc = "List plugins" })
