local theme_config = require("config.theme")

return {
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      theme = "dragon",
      background = {
        dark = "dragon",
        light = "lotus",
      },
      colors = {
        palette = {
          dragonBlack0 = "#2a2218",
        },
      },
    },
    config = function(_, opts)
      if theme_config.colorscheme_name == "kanagawa" then
        require("kanagawa").setup(opts)
        vim.cmd.colorscheme("kanagawa")
      end
    end,
  },
}
