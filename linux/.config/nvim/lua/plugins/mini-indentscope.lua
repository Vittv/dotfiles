return {
  "nvim-mini/mini.indentscope",
  version = false,
  config = function()
    require("mini.indentscope").setup({
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Disable mini.indentscope on dashboard and utility buffers",
        -- You can add other utility filetypes here (e.g., 'help', 'NvimTree', 'lazy', 'Trouble')
        pattern = { "alpha", "dashboard", "neo-tree" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    })
  end,
}
