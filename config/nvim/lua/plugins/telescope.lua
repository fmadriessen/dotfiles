return {
   "nvim-telescope/telescope.nvim",
   version = false,
   keys = {
      { "<leader>b", function() require("telescope.builtin").buffers() end, desc = "List buffers" },

      -- Find
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Files" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
      { "<leader>fg", function() require("telescope.builtin").git_files() end, desc = "Git files" },

      -- Help
      { "<leader>hh", function() require("telescope.builtin").help_tags() end, desc = "Find help tags" },
      { "<leader>hk", function() require("telescope.builtin").keymaps() end, desc = "Find keymaps" },
      { "<leader>hm", function() require("telescope.builtin").man_pages() end, desc = "Find man pages" },

      -- Search
      { "<leader>sg", function() require("telescope.builtin").live_grep() end, desc = "Grep" },
   },
   cmd = "Telescope",
   opts = {
      defaults = {
         prompt_prefix = " ",
         selection_caret = "• ",
         layout_strategy = "vertical",
         layout_config = { prompt_position = "top" },
         sorting_strategy = "ascending",
         mappings = {
            i = {
               ["<C-k>"] = function(...) require("telescope.actions").cycle_history_prev(...) end,
               ["<C-j>"] = function(...) require("telescope.actions").cycle_history_next(...) end,
            },
         },
      },
   },
   config = true,
   dependencies = {
      "nvim-lua/plenary.nvim",
      {
         "nvim-telescope/telescope-fzf-native.nvim",
         build = "make",
         config = function() require("telescope").load_extension("fzf") end,
      },
   },
}
