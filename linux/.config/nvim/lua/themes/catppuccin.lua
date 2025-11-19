local theme_config = require("config.theme")

return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true
    },
    config = function()
      if theme_config.colorscheme_name == "catppuccin" then
      require("catppuccin").setup({
        transparent_background = false,
        -- mocha, macchiato, frappe, latte
        flavour = "macchiato",
          custom_highlights = function(colors)
            return {
              -- ["@constant"] = { fg = colors.blue },
              -- ["@constant.builtin"] = { fg = colors.blue },
              -- ["@string"] = { fg = colors.lavender},
              ["@variable.builtin"] = { fg = colors.lavender },
            }
          end,
        })
        vim.cmd.colorscheme(theme_config.colorscheme_name)
      end
    end
  }
}
