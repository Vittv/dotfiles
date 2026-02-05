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
          bold = true,
          italic = true,
          style = {
            -- "none" is the same thing as default. But "italic" and "bold" are also valid options
            boolean = "none",
            number = "none",
            float = "none",
            error = "none",
            comments = "none",
            conditionals = "none",
            functions = "none",
            headings = "bold",
            operators = "none",
            strings = "none",
            variables = "none",

            -- keywords
            keywords = "none",
            keyword_return = "none",
            keywords_loop = "none",
            keywords_label = "none",
            keywords_exception = "none",

            -- builtin
            builtin_constants = "bold",
            builtin_functions = "none",
            builtin_types = "bold",
            builtin_variables = "none",
          }
        })
        vim.cmd.colorscheme "vague"
      end
    end,
  }
}
