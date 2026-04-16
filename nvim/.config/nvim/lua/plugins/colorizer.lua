return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      "javascript",
      "json",
      "conf",
      "rasi",
      "yaml",
      "toml",
      "markdown",
      "typst"
    })
  end,
}
