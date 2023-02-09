-- Options
-- see :h option-summary
vim.opt.equalalways = false
vim.opt.breakindent = true
vim.opt.cmdheight = 1
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.conceallevel = 1
vim.opt.cursorline = false
vim.opt.expandtab = true
vim.opt.formatoptions = table.concat({ -- see :h fo-table
   "c", -- auto wrap comments
   "q", -- allow formatting comments with gq
   "r", -- auto insert comment leader in insert mode
   "o", -- auto insert comment leader on n_o and n_O
   "j", -- auto remove comment leader when joining lines
   "n", -- properly indent numbered lists (needs 'autoindent')
   "l",
}, "")
vim.opt.ignorecase = true
vim.opt.iskeyword:append("-")
vim.opt.laststatus = 2
vim.opt.linebreak = true -- Break at breakat
vim.opt.list = true
vim.opt.listchars = {
   extends = "…",
   precedes = "…",
   nbsp = "␣",
   trail = "•",
}
vim.opt.number = false
vim.opt.previewheight = 20
vim.opt.relativenumber = false
vim.opt.shada = { "!", "'1000", "<50", "s10", "h", "r:/tmp" }
vim.opt.shiftwidth = 4
vim.opt.shortmess:append(table.concat({
   "W", -- No written when writing file
   "I", -- Hide intro message when starting vim
   "c", -- no ins-completion-menu messages
   "C", -- No messages while scanning for ins-completion items
}, ""))
vim.opt.smartcase = true -- can still search case sensitive by including /C in the search
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.wildignore = {}
vim.opt.wildmode = { "longest:full", "longest" }

if vim.fn.executable("rg") == 1 then
   vim.opt.grepprg = "rg --vimgrep --smart-case"
   vim.opt.grepformat:prepend({
      "%f:%l:%c:%m",
      "%f:%l:%m",
   })
end
