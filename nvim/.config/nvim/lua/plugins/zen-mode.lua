return {
  "folke/zen-mode.nvim",
  opts = {
    window = {
      width = 100,       -- chars wide (your code column)
      height = 1,        -- 1 = 100% of window height
      options = {
        number = true,
        relativenumber = true,
        signcolumn = "yes",
      },
    },
    plugins = {
      options = { laststatus = 0 },  -- hides statusline
      twilight = { enabled = false }, -- dim inactive code (optional)
    },
  },
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen mode" },
  },
}
