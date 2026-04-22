return {
  "folke/noice.nvim",
  enabled = true,
  event = "VeryLazy",
  opts = {
    -- add any options here
    -- views = {
    --   hover = {
    --     border = {
    --       style = "rounded",
    --     },
    --     win_options = {
    --       winblend = 0,
    --       winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    --     },
    --   }
    -- },
    cmdline = {
      view = "cmdline",
      format = {
        cmdline = { icon = "" }
      }
    },
    mini = {
      align = "center",
      position = {
        -- centers messages top to bottom
        row = "95%",
        col = "100%"
      }
    },
    messages = {
      enabled = true,
    },
    lsp = {
      progress = {
        enabled = true,
      },
      hover = {
        enabled = false
      },
      signature = {
        enabled = false
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
        ["vim.lsp.util.stylize.markdown"] = false,
        ["cmp.entry.get_documentation"] = false,
      },
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper module="..." entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    -- {
    --   "rcarriga/nvim-notify",
    --   config = function()
    --     require("notify").setup({
    --       background_colour = "#000000",
    --       timeout = 3000,
    --     })
    --   end
    -- }
    --   nvim-notify is only needed, if you want to use the notification view.
    --   If not available, we use mini as the fallback
  },
}
