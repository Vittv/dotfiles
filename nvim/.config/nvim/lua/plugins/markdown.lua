return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.nvim',
    },
    ft = { 'markdown' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { 'markdown', 'blink-cmp-documentation' },
      completions = {
        lsp = { enabled = true },
      },
      latex = {
        enabled = true,
        converter = 'utftex',
      },
    },
    init = function()
      -- highlights go in init, which runs before setup
      vim.api.nvim_set_hl(0, '@markup.strong.markdown_inline', {
        fg = vim.api.nvim_get_hl(0, { name = 'Function' }).fg,
        bold = true,
      })
    end,
  },
}
