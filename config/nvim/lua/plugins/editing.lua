-- Plugins that make editing easier,
-- (un)commenting regions, adding surrounding characters, and so on.
return {
   {
      "L3MON4D3/LuaSnip",
      opts = {
         history = true,
         update_events = "TextChanged,TextChangedI",
         region_check_events = "CursorMoved,CursorHold,InsertEnter",
         delete_check_events = "TextChanged,TextChangedI",
      },
      keys = function()
         local luasnip = require("luasnip")
         return {
            { "<C-j>", function() luasnip.expand_or_jump() end, mode = { "i", "s" } },
            { "<C-k>", function() luasnip.jump(-1) end, mode = { "i", "s" } },
            {
               "<C-l>",
               function()
                  if luasnip.choice_active() then luasnip.change_choice(1) end
               end,
               mode = { "i", "s" },
            },
         }
      end,
      cmd = "LuaSnipEdit",
      config = function(_, opts)
         require("luasnip").config.set_config(opts)
         require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })

         vim.api.nvim_create_user_command(
            "LuaSnipEdit",
            require("luasnip.loaders").edit_snippet_files,
            { desc = "Edit snippets" }
         )
      end,
   },

   {
      "numToStr/Comment.nvim",
      version = false,
      keys = {
         { "gc", mode = { "n", "v" }, desc = "Toggle comment" },
         { "gb", mode = { "n", "v" }, desc = "Toggle block comment" },
      },
      opts = {
         ignore = "^%s+$",
      },
   },

   {
      "echasnovski/mini.surround",
      version = "*",
      opts = {
         -- Make mini.surround behave more like vim-surround
         mappings = {
            add = "ys",
            delete = "ds",
            replace = "cs",
            find = "",
            find_left = "",
            highlight = "",
            update_n_lines = "",
         },
         search_method = "cover_or_next",
      },
      keys = function(plugin, keys)
         local mappings = plugin.opts.mappings
         return vim.list_extend({
            { mappings.add, mode = { "n", "v" }, desc = "Add surrounding" },
            { mappings.delete, desc = "Delete surrounding" },
            { mappings.replace, desc = "Change surrounding" },
            -- { mappings.find, desc = "Find right surrounding" },
            -- { mappings.find_left, desc = "Find left surrounding" },
            -- { mappings.highlight, desc = "Highlight surrounding" },
            -- { mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
         }, keys)
      end,
      config = function(_, opts) require("mini.surround").setup(opts) end,
   },

   {
      "echasnovski/mini.pairs",
      version = "*",
      event = "InsertEnter",
      config = function(_, opts) require("mini.pairs").setup(opts) end,
   },
}
