-- Map leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymaps = {
   -- Diagnostics
   { "<leader>e", vim.diagnostic.open_float, desc = "Show line diagnostics" },
   { "<leader>q", vim.diagnostic.setqflist, desc = "Show diagnostics in quickfix" },
   { "]d", vim.diagnostic.goto_next, desc = "Goto next diagnostic" },
   { "[d", vim.diagnostic.goto_prev, desc = "Goto previous diagnostic" },

   -- Navigate buffers
   { "]b", "<cmd>bnext<cr>", desc = "Goto next buffer" },
   { "[b", "<cmd>bprevious<cr>", desc = "Goto previous buffer" },

   -- Navigate loclist/quickfix
   { "]l", "<cmd>lnext<cr>", desc = "Goto next item in loclist" },
   { "[l", "<cmd>lprev<cr>", desc = "Goto previous item in loclist" },
   { "]q", "<cmd>cnext<cr>", desc = "Goto next item in quickfix" },
   { "[q", "<cmd>cprev<cr>", desc = "Goto previous item in quickfix" },

   { "g/", "<esc>/\\%V", desc = "Search in visual selection", silent = false },

   -- Automatically reselect after (de-)indenting
   { ">", ">gv", desc = "Indent", mode = "x" },
   { "<", "<gv", desc = "De-indent", mode = "x" },

   -- Do not write registers when pasting in visual mode/changing text
   { "p", [[P]], mode = "x" },
   { "c", [["_c]], mode = { "n", "x" } },
   { "C", [["_C]], mode = { "n", "x" } },

   -- Additional breakpoints
   { ",", ",<C-g>u", mode = "i" },
   { ".", ".<C-g>u", mode = "i" },
   { ":", ":<C-g>u", mode = "i" },
   { ";", ";<C-g>u", mode = "i" },
}

for _, map in pairs(keymaps) do
   local opts = {}
   for key, value in pairs(map) do
      if type(key) ~= "number" and key ~= "mode" then opts[key] = value end
   end
   opts.silent = opts.silent ~= nil and opts.silent or true
   vim.keymap.set(map.mode or "n", map[1], map[2], opts)
end

-- Close some file/buftypes with q
-- TODO: Don't know whether we should keep this
local q_augroup = vim.api.nvim_create_augroup("close_with_q", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
   group = q_augroup,
   pattern = { "qf", "help", "man" },
   callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
   end,
})
