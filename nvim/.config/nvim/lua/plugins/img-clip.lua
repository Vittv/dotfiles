return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    -- your preferred image directory, relative to the current file
    default = {
      dir_path = function()
        local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        return vim.fn.expand("~/Pictures/pictures/pics/nvim/") .. project
      end,
      template = "![$FILE_NAME]($FILE_PATH)",
    },
  },
  keys = {
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
  },
}
