return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 
      'nvim-treesitter/nvim-treesitter',
      'nvim-mini/mini.nvim'
    },            -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
    },
    config = function()
      require("render-markdown").setup({
        -- paragraph = { left_margin = 0.5 },
        latex = { 
          enabled = true,
          converter = "utftex",
        }
      })

    end
  },
  {
    {
      "OXY2DEV/markview.nvim",
      lazy = false,
      dependencies = { "hrsh7th/nvim-cmp" },
      opts = {
        preview = {
          filetypes = { "typst" },  -- ONLY activate for typst
        }
      }
    }
  }
}
