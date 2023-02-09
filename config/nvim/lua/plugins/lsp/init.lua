return {
   {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
         "mason.nvim",
         { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },

         { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      },
      opts = {
         servers = {
            ["sumneko_lua"] = {
               settings = {
                  Lua = {
                     workspace = { checkThirdParty = false },
                     completion = { callSnippet = "Replace" },
                  },
               },
            },
         },
      },
      config = function(_, opts)
         -- Use a autocmd so that all servers and null-ls pick up the defaults
         vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
               local buffer = args.buf
               local client = vim.lsp.get_client_by_id(args.data.client_id)

               require("plugins.lsp.keymaps").on_attach(client, buffer)
            end,
         })

         local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

         for server, server_opts in pairs(opts.servers) do
            require("lspconfig")[server].setup(
               vim.tbl_deep_extend("force", { capabilities = capabilities }, server_opts or {})
            )
         end
      end,
   },

   {
      -- formatter/linter
      "jose-elias-alvarez/null-ls.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
         "mason.nvim",
         "nvim-lua/plenary.nvim",
         {
            "jay-babu/mason-null-ls.nvim",
            opts = {
               ensure_installed = nil,
               automatic_installation = true,
               automatic_setup = false,
            },
         },
      },
      opts = function()
         local nls = require("null-ls").builtins
         local f = nls.formatting
         local d = nls.diagnostics
         local c = nls.code_actions

         return {
            update_in_insert = true,
            sources = {
               f.stylua,
            },
         }
      end,
      config = function(_, opts)
         require("null-ls").setup(opts)
         require("mason-null-ls").setup()
      end,
   },

   {
      "williamboman/mason.nvim",
      cmd = "Mason",
      opts = {},
   },
}

---@class LspClient
---@field id number The id allocated to the client
---@field name string If a name is specified on creation, that will be used. Otherwise it is just the client id. Used
--for logs and messages
---@field handlers table The handlers used by the client as described in `lsp-handler`
---@field config table copy of the table passed to vim.lsp.start_client()
---@field server_capabilities LspCapabilities describes the server's capabilities

---@class LspCapabilities
---@field codeActionProvider any
---@field codeLensProvider any
---@field colorProvider any
---@field completionProvider any
---@field definitionProvider any
---@field documentFormattingProvider any
---@field documentHighlightProvider any
---@field documentOnTypeFormattingProvider any
---@field documentRangeFormattingProvider any
---@field documentSymbolProvider any
---@field executeCommandProvider any
---@field foldingRangeProvider any
---@field hoverProvider any
---@field inlayHintProvider any
---@field offsetEncoding any
---@field referencesProvider any
---@field renameProvider any
---@field semanticTokensProvider any
---@field signatureHelpProvider any
---@field textDocumentSync any
---@field typeDefinitionProvider any
---@field workspace any
---@field workspaceSymbolProvider any
