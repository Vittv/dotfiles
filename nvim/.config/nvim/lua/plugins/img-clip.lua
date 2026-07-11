return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      dir_path = function()
        local file = vim.fn.expand("%:p:h")
        local git_root = vim.fn.trim(vim.fn.system("git -C " .. vim.fn.shellescape(file) .. " rev-parse --show-toplevel"))
        if vim.v.shell_error == 0 and git_root ~= "" then
          return git_root .. "/assets/pictures"
        end
        return vim.fn.getcwd() .. "/assets/pictures"
      end,
      extension = "jpg",
      template = "![$FILE_NAME]($FILE_PATH)",
    },
  },
  keys = {
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
  },
}
