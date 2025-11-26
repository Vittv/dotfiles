local theme_config = require("config.theme")

return {
  {
    "oxfist/night-owl.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      if theme_config.colorscheme_name == "night-owl" then
        require("night-owl").setup({
          italics = false,
          transparent_background = false,
        })
        vim.cmd.colorscheme "night-owl"
      end
    end,
  }
}
