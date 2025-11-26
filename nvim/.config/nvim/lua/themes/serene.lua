local theme_config = require("config.theme")

return {
  {
    "samharju/serene.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      if theme_config.colorscheme_name == "serene" then
        require("serene").setup({
          italic = false
        })
        vim.cmd.colorscheme "serene"
      end
    end,
  }
}
