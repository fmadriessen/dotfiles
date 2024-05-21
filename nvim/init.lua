vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.shiftwidth = 0
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4

vim.keymap.set("x", ">", ">gv")
vim.keymap.set("x", "<", "<gv")

vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { desc = "Search forward", expr = true })
vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { desc = "Search backward", expr = true })
