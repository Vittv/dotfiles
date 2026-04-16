return {
  "nvim-lualine/lualine.nvim",
  -- enabled = false,
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto",
        component_separators = '',
        section_separators = { left = '', right = '' },
      }
    })
  end
}
