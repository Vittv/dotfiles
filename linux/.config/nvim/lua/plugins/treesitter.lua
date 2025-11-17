return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUPDATE",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {"lua", "html", "css", "javascript", "typescript"},
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
