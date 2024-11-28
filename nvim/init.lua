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

vim.env.VIMPLUGINDIR = vim.fn.stdpath("data") .. "/site/pack/deps"
local deps_path = vim.env.VIMPLUGINDIR .. "/start/mini.deps"
if not vim.uv.fs_stat(deps_path) then
   vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", deps_path })
   vim.cmd("packadd mini.deps | helptags ALL")
end

require("mini.deps").setup({ path = { package = vim.fn.stdpath("data") .. "/site/" } })

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
      "json",
      "latex",
      "lua",
      "luadoc",
      "markdown",
      "toml",
      "yaml",
   },
})

MiniDeps.add({ source = "nvim-treesitter/nvim-treesitter-context" })
MiniDeps.add({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main" })

local function textobject_select(capture_group)
   require("nvim-treesitter-textobjects.select").select_textobject(capture_group, "textobjects")
end

local function textobject_swap(direction, capture_group)
   require("nvim-treesitter-textobjects.swap")["swap_" .. direction](capture_group)
end

require("nvim-treesitter-textobjects").setup()

vim.keymap.set({ "x", "o" }, "af", function() textobject_select("@function.outer") end)
vim.keymap.set({ "x", "o" }, "if", function() textobject_select("@function.inner") end)
vim.keymap.set({ "x", "o" }, "ia", function() textobject_select("@parameter.inner") end)
vim.keymap.set({ "x", "o" }, "aa", function() textobject_select("@parameter.outer") end)

vim.keymap.set("n", ">a", function() textobject_swap("next", "@parameter.inner") end)
vim.keymap.set("n", "<a", function() textobject_swap("previous", "@parameter.inner") end)

vim.api.nvim_create_autocmd("FileType", {
   callback = function(event)
      local filetype = event.match
      if not filetype then return end

      if vim.treesitter.query.get(filetype, "highlights") then vim.treesitter.start(event.buf, filetype) end

      if vim.treesitter.query.get(filetype, "folds") then
         vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
         vim.opt_local.foldmethod = "expr"
      end
   end,
})

local augroup_filetype_config = vim.api.nvim_create_augroup("UserFileTypeConfiguration", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
   pattern = "lua",
   group = augroup_filetype_config,
   callback = function(event)
      vim.lsp.start({
         name = "lua-language-server",
         cmd = { "lua-language-server" },
         root_dir = vim.fs.root(event.buf, { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" }),
         settings = {
            Lua = {
               completion = { callSnippet = "Replace" },
            },
         },
         telemetry = { enable = false },
         single_file_support = true,
      })
   end,
})

vim.api.nvim_create_autocmd("LspAttach", {
   callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then return end

      if client:supports_method("textDocument/completion") then
         vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })

         vim.keymap.set("i", "<C-n>", function()
            if vim.fn.pumvisible() == 0 then return "<C-x><C-o>" end

            return "<C-n>"
         end, { expr = true })
      end
   end,
})

vim.keymap.set({ "i", "s" }, "<C-j>", function()
   if vim.snippet.active({ direction = 1 }) then return vim.snippet.jump(1) end
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<C-k>", function()
   if vim.snippet.active({ direction = -1 }) then return vim.snippet.jump(-1) end
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<ESC>", function()
   vim.snippet.stop()
   return "<ESC>"
end, { expr = true })

MiniDeps.add("ibhagwan/fzf-lua")
vim.keymap.set("n", "<C-p>", function() require("fzf-lua").files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>b", function() require("fzf-lua").buffers() end, { desc = "Show buffers" })

MiniDeps.add("rebelot/kanagawa.nvim")
require("kanagawa").setup({
   background = {
      dark = "dragon",
   },
   colors = {
      theme = {
         all = {
            ui = {
               bg_gutter = "none",
            },
         },
      },
   },
})
vim.cmd.colorscheme("kanagawa")
