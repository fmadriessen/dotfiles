local M = {}

local telescope = require("telescope.builtin")

-- stylua: ignore
local keys = {
   { "K", vim.lsp.buf.hover, desc = "Show hover documentation", has = "hoverProvider", mode = { "n", "v" } },
   { "<M-k>", vim.lsp.buf.signature_help, desc = "Show signature help", has = "signatureHelpProvider", mode = { "n", "v", "i" }, },

   { "gr", telescope.lsp_references, desc = "Show references", has = "referencesProvider" },
   { "go", telescope.lsp_document_symbols, desc = "Show document symbols", has = "documentSymbolProvider" },
   { "gO", telescope.lsp_workspace_symbols, desc = "Show workspace symbols", has = "workspaceSymbolProvider" },

   -- INFO: Since nvim also sets the tagfunc you can also use the following builtins
   --    CTRL-] jump to definition
   --    CTRL-W CTRL-] jump to definition in new split
   --    CTRL-W } definition in preview window
   { "gd", telescope.lsp_definitions, desc = "Goto definition", has = "definitionProvider" },
   { "gD", vim.lsp.buf.declaration, desc = "Goto declaration", has = "declarationProvider" },
   { "gi", telescope.lsp_implementations, desc = "Goto implementation", has = "implementationProvider" },

   -- Code actions
   { "<localleader>ca", vim.lsp.buf.code_action, desc = "Execute code action", has = "codeActionProvider", mode = { "n", "v" } },
   { "<localleader>cr", vim.lsp.buf.rename, desc = "Rename symbol", has = "renameProvider" },
   { "<localleader>cf", require("plugins.lsp.format").format, desc = "Format document", has = "documentFormattingProvider" },
   { "<localleader>cf", require("plugins.lsp.format").format, desc = "Format document", has = "documentRangeFormattingProvider", mode = "v" },

   { "<localleader>tf", require("plugins.lsp.format").toggle_autoformat, desc = "Toggle formatting on save", has = "documentFormattingProvider" },
}

---@param client LspClient
---@param bufnr number
function M.on_attach(client, bufnr)
   for _, map in pairs(keys) do
      if not map.has or client.server_capabilities[map.has] then
         local opts = {}
         for key, value in pairs(map) do
            if type(key) ~= "number" and key ~= "mode" then opts[key] = value end
         end
         opts.has = nil
         opts.silent = opts.silent ~= nil and opts.silent or true
         opts.buffer = bufnr
         vim.keymap.set(map.mode or "n", map[1], map[2], opts)
      end
   end
end

return M
