return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {"lua", "html", "css", "javascript", "typescript", "markdown", "markdown_inline", "yaml", "latex", "typst", "bash", "python", "c"},
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
