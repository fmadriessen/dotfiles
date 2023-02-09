require("config.options")
require("config.keymaps")

vim.api.nvim_create_autocmd("TextYankPost", {
   group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
   callback = function() vim.highlight.on_yank({ on_visual = false }) end,
})

-- Bootstrap Lazy.nvim
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
   vim.notify("Setting up lazy.nvim, wait until installation is finished")
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazy_path,
   })
end
vim.opt.runtimepath:prepend(lazy_path)

require("lazy").setup("plugins", {})

vim.cmd.colorscheme("tokyonight")
