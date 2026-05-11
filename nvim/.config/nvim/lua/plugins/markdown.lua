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
      local boldColor = vim.api.nvim_get_hl(0, { name = "Function" }).fg
      vim.api.nvim_set_hl(0, "@markup.strong.markdown_inline", { fg = boldColor, bold = true })

      require("render-markdown").setup({
        -- paragraph = { left_margin = 0.5 },
        latex = { 
          enabled = true,
          converter = "utftex",
        }
      })
    end,
  },
  {
    {
      "OXY2DEV/markview.nvim",
      lazy = false,
      opts = {
        preview = {
          filetypes = { "typst" },  -- ONLY activate for typst
        }
      }
    }
  }
}
