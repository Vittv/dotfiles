return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()

    -- Install parsers individually (ensure_installed is gone)
    local ts = require("nvim-treesitter")
    local parsers = {
      "lua", "html", "css", "javascript", "typescript",
      "markdown", "markdown_inline", "yaml", "latex", "typst",
      "bash", "python", "c", "cpp", "rust"
    }
    for _, parser in ipairs(parsers) do
      ts.install(parser)
    end
  end
}
