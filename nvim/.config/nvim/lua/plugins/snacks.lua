return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    scope = { enabled = true },
    indent = { enabled = true },
    zen = { enabled = true },
    image = {
      enabled = true,
      doc = {
        inline = true, -- disable inline rendering
        float = true,   -- show on hover instead
      }
    },
    styles = {
      snacks_image = {
        border = "rounded"
      }
    },
    explorer = {
      enabled = true,
      formatters = {
        file = { git_status_hl = true }
      }
    },
    picker = {
      enabled = true,
      ui_select = true,
      sources = {
        files = { excluded = { "node_modules" } },
        explorer = {
          layout = {
            preset = "sidebar",
            layout = {
              width = function()
                return math.min(50, math.floor(vim.o.columns * 0.28))
              end,
            },
            preview = true,
          },
          jump = { close = true }
        },
      },
    },
    terminal = {
      win = {
        position = "float",
        border = "rounded",
        interactive = true,
      }
    }
  },
  keys = {
    { "<leader>z", function() require("snacks").zen() end, desc = "Zen mode" },
    { "<leader>ff", function()
      require("snacks").picker.files({ cwd = vim.fn.getcwd() })
    end, desc = "Find files" },
    { "<leader>fg", function() require("snacks").picker.grep() end, desc = "Live grep" },
    { "<leader>bb", function()
      require("snacks").picker.buffers({
        layout = { preset = "ivy", preview = false }
      })
    end, desc = "Buffers" },
    { "<leader><leader>", function() require("snacks").picker.recent() end, desc = "Recent files" },
    { "<space><Tab>", function() require("snacks").explorer() end, desc = "Explorer" },
    { "<leader>tt", function() require("snacks").terminal() end, desc ="Terminal" },
    { "<C-q>", function()
      if vim.bo.filetype == "snacks_terminal" then
        require("snacks").terminal.toggle()
      end
    end, mode = "t", desc = "Hide Terminal" }
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    local function set_hl()
      vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#2a2a2a" })
      vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#aeaed1", blend = 50 })
      vim.api.nvim_set_hl(0, "SnacksPickerGitStatusAdded",    { fg = "#7fa563" })
      vim.api.nvim_set_hl(0, "SnacksPickerGitStatusModified", { fg = "#f3be7c" })
      vim.api.nvim_set_hl(0, "SnacksPickerGitStatusDeleted",  { fg = "#d8647e" })
      vim.api.nvim_set_hl(0, "SnacksPickerGitStatusStaged", { fg = "#aeaed1" })
    end

    set_hl()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_hl,
    })
  end,
}
