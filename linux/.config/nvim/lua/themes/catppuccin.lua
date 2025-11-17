local theme_config = require("config.theme")

return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme(theme_config.colorscheme_name)
    end
  }
}
