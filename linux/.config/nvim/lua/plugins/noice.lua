return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
    views = {
      hover = {
        border = {
          style = "rounded",
        }
      }
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize.markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      }
    }
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
  },
}
