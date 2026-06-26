return {
  "neovim-treesitter/nvim-treesitter",
  lazy = false,
  dependencies = { "neovim-treesitter/treesitter-parser-registry" },
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "lua", "html", "css", "javascript", "typescript", "tsx",
        "markdown", "markdown_inline", "yaml", "latex", "typst",
        "bash", "python", "c", "cpp", "rust", "sql", "go"
      },
      highlight = { enable = true },
    })
    -- javascriptreact uses the javascript parser, not a separate jsx one
    vim.treesitter.language.register("javascript", "javascriptreact")
    vim.filetype.add({
      extension = {
        rpy = "python",
      }
    })
  end,
}
