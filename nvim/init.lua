vim.opt.completeopt = { "menuone", "noinsert", "popup" }
vim.opt.expandtab = true
vim.opt.foldlevelstart = 99
vim.opt.foldtext = ""
vim.opt.ignorecase = true
vim.opt.shiftwidth = 0
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.title = true
vim.opt.undofile = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_create_autocmd("TextYankPost", {
   pattern = "*",
   callback = function() vim.highlight.on_yank() end,
})

local package_path = vim.fn.stdpath("data") .. "/site/"
local deps_path = package_path .. "pack/deps/start/mini.deps"
if not vim.uv.fs_stat(deps_path) then
   vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", deps_path })
   vim.cmd("packadd mini.deps | helptags ALL")
end

require("mini.deps").setup({ path = { package = package_path } })

MiniDeps.add({
   source = "nvim-treesitter/nvim-treesitter",
   checkout = "main",
   hooks = {
      post_checkout = function() vim.cmd("TSUpdate") end,
   },
})

require("nvim-treesitter").setup({
   ensure_installed = {
      "bash",
      "editorconfig",
      "fish",
      "latex",
      "lua",
      "luadoc",
      "markdown",
      "toml",
      "yaml",
   },
})

vim.api.nvim_create_autocmd("FileType", {
   callback = function(event)
      local filetype = event.match
      if not filetype then return end

      if vim.treesitter.query.get(filetype, "highlights") then vim.treesitter.start(event.buffer, filetype) end

      if vim.treesitter.query.get(filetype, "folds") then
         vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
         vim.opt_local.foldmethod = "expr"
      end
   end,
})
