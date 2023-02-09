-- NOTE: for custom coloring of the the colorcolumn local to the window,
-- ```lua
-- do
--      local ns = vim.api.nvim_create_namespace("gitcommit")
--      vim.api.nvim_set_hl(ns, "ColorColumn", {link = "CurSearch"}
--      vim.api.nvim_win_set_hl_ns(0, ns)
-- end
-- ```
vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = "+0"
