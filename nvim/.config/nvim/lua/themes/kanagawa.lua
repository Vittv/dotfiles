local theme_config = require("config.theme")
local theme_selector_name = "kanagawa" 
local colorscheme_cmd_name = "kanagawa" 

return {
  {
    "rebelot/kanagawa.nvim",
    name = theme_selector_name,
    lazy = false,
    priority = 1000,
    
    config = function()
      if theme_config.colorscheme_name == theme_selector_name then 
        require("kanagawa").setup({
            -- You can optionally configure the theme here:
            -- e.g., theme = "dragon" (default), theme = "wave", or theme = "fuji"
            -- background = { dark = "wave" } 
        })
        vim.cmd.colorscheme(colorscheme_cmd_name)
      end
    end,
  },
}
