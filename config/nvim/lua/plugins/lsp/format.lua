local format = {}

---@private
---Get options table from Lazy.nvim plugin specification
---@param name string
---@return table
local function lazy_opts(name)
   local plugin = require("lazy.core.config").plugins[name]
   return require("lazy.core.plugin").values(plugin, "opts", false)
end

---@type boolean Whether formatting on save should be enabled
local autoformat = lazy_opts("nvim-lspconfig").autoformat or false

---Set up formatting on save when the lsp client attaches to the buffer
---@param client table LspClient, see :h vim.lsp.client
---@param bufnr number
function format.on_attach(client, bufnr)
   if not client.supports_method("textDocument/formatting") then return end
   vim.api.nvim_buf_create_user_command(
      bufnr,
      "LspToggleAutoformat",
      format.toggle_autoformat,
      { desc = "Toggle formatting on save" }
   )
   vim.api.nvim_buf_create_user_command(bufnr, "Format", format.toggle_autoformat, { desc = "Format" })

   vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("auto_format", {}),
      buffer = bufnr,
      callback = function()
         if autoformat then format.format() end
      end,
   })
end

---Format buffer
---Format opts are taken from lspconfig LazySpec.opts.format_opts
---Prefers to use the formatter set up in null_ls
function format.format()
   local bufnr = vim.api.nvim_get_current_buf()

   vim.lsp.buf.format(vim.tbl_deep_extend("force", {
      bufnr = bufnr,
      -- filter = function(client)
      --    local has_null_ls = #require("null-ls.sources").get_available(vim.bo[bufnr].filetype, "NULL_LS_FORMATTING") > 0
      --    if has_null_ls then
      --       return client.name == "null-ls"
      --    else
      --       return client.name ~= "null-ls"
      --    end
      -- end,
   }, lazy_opts("nvim-lspconfig").format_opts or {}))
end

---Toggle formatting on save on and off
function format.toggle_autoformat()
   autoformat = not autoformat
   vim.notify(
      string.format("%s formatting on save", autoformat and "Enabled" or "Disabled"),
      vim.log.levels.INFO,
      { title = "Format" }
   )
end

return format
