return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      "javascript",
      "typescript",
      "jsx",
      "tsx",
      "json",
      "conf",
      "rasi",
      "yaml",
      "toml",
      "typst",
      "lua",
      "qml"
    })
  end,
}
