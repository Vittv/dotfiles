local theme_config = require("config.theme")

return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    if theme_config.colorscheme_name == "rose-pine" then
      require("rose-pine").setup({
        variant = "main", -- or "moon" or "dawn"
        dark_variant = "main",
        disable_italic = true,
        styles = {
          transparency = false,
        }
      })
      vim.cmd.colorscheme "rose-pine" 
    end
  end,
}
