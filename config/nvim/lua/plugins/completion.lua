return {
   "hrsh7th/nvim-cmp",
   version = false,
   event = "InsertEnter",
   dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-emoji",

      "saadparwaiz1/cmp_luasnip",
   },
   opts = function()
      local cmp = require("cmp")
      ---@type cmp.ConfigSchema
      return {
         snippet = {
            expand = function(args) require("luasnip").lsp_expand(args.body) end,
         },
         mapping = {
            ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-y>"] = cmp.mapping(
               cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
               { "i", "c" }
            ),
            ["<CR>"] = cmp.mapping.confirm({ select = false }),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
         },
         -- FIX: does not appear to work, retest after having set up LSP
         -- does work without the cmp.config.sources wrapper
         sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "path", option = { trailing_slash = true } },
            { name = "emoji" },
         }, {
            { name = "buffer", keyword_length = 5 },
         }),
         experimental = { ghost_text = { hl_group = "LspCodeLens" } },
      }
   end,
}

-- Can use `cmp.setup.filetype` for filetype specific configuration
-- Can use cmp.config.compare.* functions to modify the sorting behaviour with the sorting.comparators option
--         -- sorting = {
--         --    comparators = {
--         --       cmp.config.compare.offset,
--         --       cmp.config.compare.exact,
--         --       cmp.config.compare.score,
--         --       cmp.config.compare.kind,
--         --       cmp.config.compare.sort_text,
--         --       cmp.config.compare.length,
--         --       cmp.config.compare.order,
--         --    },
--         -- },
-- sources order dictates their order in the completion menu
-- sources[n].group_index can be used to hide sources when others are available, e.g.
--    ```lua
--    cmp.setup{sources={{name = "nvim_lsp", group_index = 1}, {name = "buffer", group_index = 2}}}
--    -- or
--    cmp.setup{sources=cmp.config.sources({name = "nvim_lsp"}, {name = "buffer"})}
--    ```
