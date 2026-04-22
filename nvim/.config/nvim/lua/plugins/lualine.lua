return {
  "nvim-lualine/lualine.nvim",
  -- enabled = false,
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto",
        component_separators = '',
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_c = {
          "filename",
          {
            function()
              local bufs = vim.tbl_filter(function(b)
                return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted
              end, vim.api.nvim_list_bufs())
              local current = vim.fn.bufnr()
              local idx = 0
              for i, b in ipairs(bufs) do
                if b == current then idx = i break end
              end
              return idx .. "/" .. #bufs
            end,
          },
        },
      }
    })
  end
}
