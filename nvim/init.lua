vim.opt.breakindent = true
vim.opt.breakindentopt = { list = -1 }
vim.opt.completeopt = { "menuone", "noinsert", "popup" }
vim.opt.expandtab = true
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"
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
MiniDeps.add("ibhagwan/fzf-lua")
MiniDeps.add("rebelot/kanagawa.nvim")
MiniDeps.add({
   source = "saghen/blink.cmp",
   hooks = {
      post_checkout = require("plugin").build({ "cargo", "build", "--release" }),
      post_install = require("plugin").build({ "cargo", "build", "--release" }),
   },
})
MiniDeps.add("stevearc/conform.nvim")

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

require("blink.cmp").setup({
   keymap = {
      preset = "default",
      ["<C-n>"] = { "show", "select_next", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
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
   end,
   desc = "Enable treesitter highlighting",
   group = vim.api.nvim_create_augroup("TreesitterHighlighting", { clear = true }),
})

require("conform").setup({
   formatters_by_ft = {
      fish = { "fish_indent" },
      lua = { "stylua", lsp_format = "fallback" },
      markdown = { "prettier", "injected" },
      rust = { "rustfmt", lsp_format = "fallback" },
   },
   format_on_save = function(buf)
      -- INFO: https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md
      if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then return end

      return { timeout_ms = 500, lsp_format = "fallback" }
   end,
})

vim.api.nvim_create_user_command("Format", function(args)
   local range = nil
   if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
         start = { args.line1, 0 },
         ["end"] = { args.line2, end_line:len() },
      }
   end
   require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { desc = "Format buffer or range", range = true })

local function textobject_select(capture_group)
   return function() require("nvim-treesitter-textobjects.select").select_textobject(capture_group, "textobjects") end
end

local function textobject_swap(direction, capture_group)
   return function() require("nvim-treesitter-textobjects.swap")["swap_" .. direction](capture_group) end
end

vim.keymap.set({ "x", "o" }, "af", textobject_select("@function.outer"), { desc = "Select around function" })
vim.keymap.set({ "x", "o" }, "if", textobject_select("@function.inner"), { desc = "Select inside function" })
vim.keymap.set({ "x", "o" }, "ia", textobject_select("@parameter.inner"), { desc = "Select inside parameter" })
vim.keymap.set({ "x", "o" }, "aa", textobject_select("@parameter.outer"), { desc = "Select around paremeter" })

vim.keymap.set("n", ">a", textobject_swap("next", "@parameter.inner"), { desc = "Swap parameter forward" })
vim.keymap.set("n", "<a", textobject_swap("previous", "@parameter.inner"), { desc = "Swap parameter backward" })

vim.keymap.set("x", ">", ">gv", { desc = "Shift lines inward" })
vim.keymap.set("x", "<", "<gv", { desc = "Shift lines outward" })

vim.keymap.set({ "i", "s" }, "<C-f>", function()
   if vim.snippet.active({ direction = 1 }) then return vim.snippet.jump(1) end
end, { desc = "Jump to next placeholder", expr = true })
vim.keymap.set({ "i", "s" }, "<C-b>", function()
   if vim.snippet.active({ direction = -1 }) then return vim.snippet.jump(-1) end
end, { desc = "Jump to previous placeholder", expr = true })
vim.keymap.set({ "i", "s" }, "<ESC>", function()
   if vim.snippet.active() then vim.snippet.stop() end
   return "<ESC>"
end, { expr = true })

vim.keymap.set("n", "<C-l>", function()
   vim.cmd.fclose()
   vim.cmd.nohlsearch()
   vim.cmd.redraw()
end, { desc = "Close floats and clear search highlights" })

vim.keymap.set("n", "gQ", "<cmd>Format<cr>", { desc = "Format buffer" })
vim.keymap.set("n", "<C-p>", function() require("fzf-lua").files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>b", function() require("fzf-lua").buffers() end, { desc = "Show buffers" })

vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float() end, { desc = "Show diagnostics on line" })

vim.keymap.set("n", "<leader>xf", function()
   vim.g.disable_autoformat = not vim.g.disable_autoformat
   vim.notify(
      string.format("%s formatting on save", vim.g.disable_autoformat and "Disabled" or "Enabled"),
      vim.log.levels.INFO
   )
end, { desc = "Toggle formatting on save" })

vim.api.nvim_create_autocmd("TextYankPost", {
   pattern = "*",
   callback = function() vim.highlight.on_yank() end,
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

local augroup_filetype_config = vim.api.nvim_create_augroup("UserFileTypeConfiguration", { clear = true })
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
