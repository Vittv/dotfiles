local theme_config = require("config.theme")

return {
  {
    "vague-theme/vague.nvim",
    lazy = false,
    name = "vague",
    priority = 1000,
    config = function()
      if theme_config.colorscheme_name == "vague" then
        require("vague").setup({
          -- Vague custom configs
          transparent = true,
          italic = false,
        })
        vim.cmd.colorscheme "vague"
      end
    end,
  }
}
