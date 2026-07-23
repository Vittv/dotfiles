return {
  "brenoprata10/nvim-highlight-colors",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-highlight-colors").setup({
      -- VS Code style: little colored square inline before the color text
      render = "virtual",
      virtual_symbol = "",
      virtual_symbol_prefix = "",
      virtual_symbol_suffix = " ",
      virtual_symbol_position = "inline",

      -- color formats to detect
      enable_hex = true,
      enable_short_hex = true,
      enable_rgb = true,
      enable_hsl = true,
      enable_hsl_without_function = true,  -- `--foo: 0 69% 69%;` style
      enable_var_usage = true,             -- CSS var(--x) usage
      enable_named_colors = true,          -- 'red', 'blue', etc.
      enable_tailwind = false,             -- set true if you use Tailwind classes
      enable_ansi = true,
      enable_xterm256 = true,
      enable_xtermTrueColor = true,

      -- since this runs globally by default, exclude noisy/irrelevant buffers here
      -- instead of opting individual filetypes in like colorizer required
      exclude_filetypes = {},
      exclude_buftypes = { "nofile", "terminal", "prompt" },
      exclude_buffer = function(bufnr)
        return vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 1000000
      end,
    })
  end,
}
