return {
   {
      "nvim-treesitter/nvim-treesitter",
      build = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
      event = "BufReadPost",
      opts = {
         ensure_installed = {
            "bash",
            "c",
            "fish",
            "help",
            "lua",
            "query",
            "regex",
            "vim",
         },
         auto_install = true,
         highlight = { enable = true },
         indent = { enable = true },
         incremental_selection = {
            enable = true,
            keymaps = {
               init_selection = "<C-n>",
               node_incremental = "<C-n>",
               scope_incremental = "<C-s>",
               node_decremental = "<C-r>",
            },
         },
      },
      config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
   },
   {
      "nvim-treesitter/nvim-treesitter",
      dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
      opts = {
         textobjects = {
            select = {
               enable = true,
               lookahead = true,
               keymaps = {
                  ["aa"] = { query = "@parameter.outer", desc = "Select around argument" },
                  ["ia"] = "@parameter.inner",
                  ["ab"] = "@block.outer",
                  ["ib"] = "@block.inner",
                  ["af"] = "@function.outer",
                  ["if"] = "@function.inner",
               },
            },
         },
      },
   },
}
