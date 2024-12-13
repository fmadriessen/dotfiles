vim.opt.breakindent = true
vim.opt.breakindentopt = { list = -1 }
vim.opt.completeopt = { "menuone", "noinsert", "popup" }
vim.opt.expandtab = true
vim.opt.foldtext = ""
vim.opt.ignorecase = true
vim.opt.shiftwidth = 0
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.title = true
vim.opt.undofile = true
vim.opt.wrap = false

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
MiniDeps.add({ source = "nvim-treesitter/nvim-treesitter-context" })
MiniDeps.add({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main" })

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
      "rust",
      "toml",
      "yaml",
   },
})

require("nvim-treesitter-textobjects").setup()

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

local function textobject_select(capture_group)
   require("nvim-treesitter-textobjects.select").select_textobject(capture_group, "textobjects")
end

local function textobject_swap(direction, capture_group)
   require("nvim-treesitter-textobjects.swap")["swap_" .. direction](capture_group)
end

vim.keymap.set({ "x", "o" }, "af", function() textobject_select("@function.outer") end)
vim.keymap.set({ "x", "o" }, "if", function() textobject_select("@function.inner") end)
vim.keymap.set({ "x", "o" }, "ia", function() textobject_select("@parameter.inner") end)
vim.keymap.set({ "x", "o" }, "aa", function() textobject_select("@parameter.outer") end)

vim.keymap.set(
   "n",
   ">a",
   function() textobject_swap("next", "@parameter.inner") end,
   { desc = "Swap parameter forward" }
)
vim.keymap.set(
   "n",
   "<a",
   function() textobject_swap("previous", "@parameter.inner") end,
   { desc = "Swap parameter backward" }
)

vim.keymap.set("x", ">", ">gv", { desc = "Shift lines inward" })
vim.keymap.set("x", "<", "<gv", { desc = "Shift lines outward" })

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

vim.api.nvim_create_autocmd("FileType", {
   pattern = "markdown",
   group = augroup_filetype_config,
   callback = function()
      vim.opt_local.conceallevel = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.tabstop = 2
   end,
})

vim.api.nvim_create_autocmd("FileType", {
   pattern = "rust",
   group = augroup_filetype_config,
   callback = function(event)
      vim.lsp.start({
         name = "rust-analyzer",
         cmd = { "rustup", "run", "stable", "rust-analyzer" },
         root_dir = vim.fs.root(event.buf, { "Cargo.toml" }),
         settings = {
            ["rust-analyzer"] = {
               procMacro = { enable = true },
               check = {
                  command = "clippy",
               },
            },
         },
      })
   end,
})

vim.api.nvim_create_autocmd("LspAttach", {
   callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then return end

      -- TODO: There should be default keymaps for a lot of these actions
      vim.keymap.set(
         "n",
         "<leader>ca",
         function() vim.lsp.buf.code_action() end,
         { desc = "Code action", buffer = event.buf }
      )

      vim.keymap.set(
         "n",
         "<leader>cr",
         function() vim.lsp.buf.rename() end,
         { desc = "Rename symbol", buffer = event.buf }
      )

      if client:supports_method("textDocument/completion") then
         -- vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
         --
         -- vim.keymap.set("i", "<C-n>", function()
         --    if vim.fn.pumvisible() == 0 then return "<C-x><C-o>" end
         --
         --    return "<C-n>"
         -- end, { expr = true })
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

vim.keymap.set("n", "<ESC>", function()
   vim.cmd.fclose()
   vim.cmd.nohlsearch()
end)

vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float() end, { desc = "Show diagnostics on line" })

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

MiniDeps.add({ source = "saghen/blink.cmp", checkout = "v0.6.2", monitor = "main" })
require("blink.cmp").setup({
   keymap = {
      preset = "default",
      ["<C-n>"] = { "show", "select_next", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
   },
})
