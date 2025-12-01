return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
    views = {
      hover = {
        border = {
          style = "rounded",
        },
        win_options = {
          winblend = 0,
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
      }
    },
    messages = {
      enabled = true,
    },
    lsp = {
      progress = {
        enabled = true,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize.markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    }
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper module="..." entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    {
      "rcarriga/nvim-notify",
      config = function()
        require("notify").setup({
          background_colour = "#000000"
        })
      end
    }
    --   nvim-notify is only needed, if you want to use the notification view.
    --   If not available, we use mini as the fallback
  },
}
