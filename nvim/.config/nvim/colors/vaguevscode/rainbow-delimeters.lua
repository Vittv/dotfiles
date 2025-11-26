-- Rainbow Delimiters Plugin Configuration
-- Add this to your lazy.nvim plugin setup
--[[
return {
  "HiPhish/rainbow-delimiters.nvim",
  config = function()
    local rainbow_delimiters = require('rainbow-delimiters')

    vim.g.rainbow_delimiters = {
      strategy = {
        [''] = rainbow_delimiters.strategy['global'],
      },
      query = {
        [''] = 'rainbow-delimiters',
        html = "",
        markdown = "",
        xml = "",
      },
      priority = {
        [''] = 110,
      },
      highlight = {
        'RainbowDelimiterYellow',
        'RainbowDelimiterPink',
        'RainbowDelimiterBlue',
      },
    }

    -- Define the custom highlight colors
    vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = '#FFD700' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterPink', { fg = '#DA70D6' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = '#179FFF' })
  end
}
--]]
