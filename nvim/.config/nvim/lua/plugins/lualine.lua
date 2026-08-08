return {
  "nvim-lualine/lualine.nvim",
  -- they ruined the lualine for vague with commit f911602 ;w;
  enabled = true,
  config = function()
    local colors = {
      bg       = "#141415",
      fg       = "#cdcdcd",
      keyword  = "#90a0b5",
      func     = "#b4d4cf",
      string   = "#e8b589",
      comment  = "#606079",
      line     = "#252530",
    }

    local vague_theme = {
      normal = {
        a = { fg = colors.bg,  bg = colors.keyword, gui = "bold" },
        b = { fg = colors.fg,  bg = colors.line },
        c = { fg = colors.fg,  bg = colors.bg },
      },
      insert = {
        a = { fg = colors.bg,  bg = colors.string, gui = "bold" },
        b = { fg = colors.fg,  bg = colors.line },
        c = { fg = colors.fg,  bg = colors.bg },
      },
      visual = {
        a = { fg = colors.bg,  bg = colors.func, gui = "bold" },
        b = { fg = colors.fg,  bg = colors.line },
        c = { fg = colors.fg,  bg = colors.bg },
      },
      replace = {
        a = { fg = colors.bg,  bg = colors.func, gui = "bold" },
        b = { fg = colors.fg,  bg = colors.line },
        c = { fg = colors.fg,  bg = colors.bg },
      },
      command = {
        a = { fg = colors.bg,  bg = colors.string, gui = "bold" },
        b = { fg = colors.fg,  bg = colors.line },
        c = { fg = colors.fg,  bg = colors.bg },
      },
      inactive = {
        a = { fg = colors.bg, bg = colors.line },
        b = { fg = colors.fg, bg = colors.comment },
        c = { fg = colors.fg, bg = colors.line },
      },
    }

    require("lualine").setup({
      options = {
        theme = vague_theme,
        component_separators = "",
        -- section_separators = { left = "\u{E0B4}", right = "\u{E0B6}" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        -- lualine_a = {
        --   { "mode", fmt = function(str) return " " .. str end },
        -- },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
