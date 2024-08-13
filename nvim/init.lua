vim.opt.completeopt = { "menuone", "preview" }
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.jumpoptions = { "stack", "view", "unload" }
vim.opt.shiftwidth = 0
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.undofile = true

vim.keymap.set("x", ">", ">gv")
vim.keymap.set("x", "<", "<gv")

vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { desc = "Search forward", expr = true })
vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { desc = "Search backward", expr = true })

vim.keymap.set("x", ".", ":normal .<cr>", { desc = "Dot repeat over selection", silent = true })

---@param markers string[]
---@return string|nil
local function lsp_find_root(markers)
   local root = vim.fs.root(0, markers)
   if root and root ~= vim.env.HOME then
      return root
   end

   return nil
end

---@return string|nil
local function lsp_find_git()
   return vim.fs.root(0, { ".git" })
end

local user_ft_conf = vim.api.nvim_create_augroup("UserFileTypeConf", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
   pattern = "lua",
   group = user_ft_conf,
   callback = function(event)
      local root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml" }
      local root_dir = lsp_find_root(root_markers) or lsp_find_git()
      vim.lsp.start({
         cmd = { "lua-language-server" },
         name = "lua-language-server",
         root_dir = root_dir,
         settings = {
            Lua = {
               completion = { callSnippet = "Replace" },
               format = { enable = false },
            },
         },
         single_file_support = true,
      })
   end,
})
