-- Vague colorscheme for Neovim
-- Converted from VS Code theme

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.g.colors_name = "vague"

local colors = {
  bg = "#18191a",
  fg = "#cdcdcd",
  bg_dark = "#18191a",
  bg_alt = "#282830",
  bg_highlight = "#363738",
  
  gray = "#646477",
  gray_light = "#878787",
  
  red = "#d2788c",
  orange = "#deb896",
  yellow = "#deb896",
  green = "#8faf77",
  cyan = "#7894ab",
  blue = "#8ca0dc",
  func = "#be8c8c",
  
  none = "NONE"
}

local function highlight(group, opts)
  local cmd = "highlight " .. group
  if opts.fg then cmd = cmd .. " guifg=" .. opts.fg end
  if opts.bg then cmd = cmd .. " guibg=" .. opts.bg end
  if opts.sp then cmd = cmd .. " guisp=" .. opts.sp end
  if opts.style then cmd = cmd .. " gui=" .. opts.style end
  vim.cmd(cmd)
end

-- Editor
  highlight("Normal", { fg = colors.fg, bg = colors.bg })
  highlight("NormalFloat", { fg = colors.fg, bg = colors.bg })
  highlight("ColorColumn", { bg = colors.bg_alt })
  highlight("Cursor", { fg = colors.bg, bg = colors.fg })
  highlight("CursorLine", { bg = colors.bg_alt })
  highlight("CursorLineNr", { fg = colors.fg })
  highlight("LineNr", { fg = colors.gray })
  highlight("SignColumn", { fg = colors.gray, bg = colors.bg })
  highlight("VertSplit", { fg = colors.bg_alt })
  highlight("Visual", { bg = colors.bg_highlight })
  highlight("Search", { bg = colors.bg_highlight, fg = colors.fg })
  highlight("IncSearch", { bg = colors.cyan, fg = colors.bg })
  
  -- Statusline
  highlight("StatusLine", { fg = colors.fg, bg = colors.bg })
  highlight("StatusLineNC", { fg = colors.gray, bg = colors.bg })
  
  -- Tabline
  highlight("TabLine", { fg = colors.gray, bg = colors.bg })
  highlight("TabLineSel", { fg = colors.fg, bg = colors.bg })
  highlight("TabLineFill", { bg = colors.bg })
  
  -- Pmenu
  highlight("Pmenu", { fg = colors.fg, bg = colors.bg })
  highlight("PmenuSel", { fg = colors.fg, bg = colors.bg_highlight })
  highlight("PmenuSbar", { bg = colors.bg_alt })
  highlight("PmenuThumb", { bg = colors.gray })
  
  -- Messages
  highlight("ErrorMsg", { fg = colors.red })
  highlight("WarningMsg", { fg = colors.orange })
  highlight("ModeMsg", { fg = colors.fg, style = "bold" })
  highlight("MoreMsg", { fg = colors.cyan })
  highlight("Question", { fg = colors.cyan })
  
  -- Diff
  highlight("DiffAdd", { bg = "#8faf774b" })
  highlight("DiffDelete", { bg = "#d2788c52" })
  highlight("DiffChange", { bg = colors.bg_alt })
  highlight("DiffText", { bg = colors.bg_highlight })
  
  -- Syntax
  highlight("Comment", { fg = colors.gray, style = "italic" })
  highlight("Constant", { fg = colors.blue })
  highlight("String", { fg = colors.orange })
  highlight("Character", { fg = colors.orange })
  highlight("Number", { fg = colors.fg })
  highlight("Boolean", { fg = colors.blue })
  highlight("Float", { fg = colors.fg })
  
  highlight("Identifier", { fg = colors.blue })
  highlight("Function", { fg = colors.func })
  
  highlight("Statement", { fg = colors.cyan })
  highlight("Conditional", { fg = colors.cyan })
  highlight("Repeat", { fg = colors.cyan })
  highlight("Label", { fg = colors.cyan })
  highlight("Operator", { fg = colors.cyan })
  highlight("Keyword", { fg = colors.cyan })
  highlight("Exception", { fg = colors.cyan })
  
  highlight("PreProc", { fg = colors.cyan })
  highlight("Include", { fg = colors.cyan })
  highlight("Define", { fg = colors.cyan })
  highlight("Macro", { fg = colors.cyan })
  highlight("PreCondit", { fg = colors.cyan })
  
  highlight("Type", { fg = colors.orange })
  highlight("StorageClass", { fg = colors.cyan })
  highlight("Structure", { fg = colors.cyan })
  highlight("Typedef", { fg = colors.cyan })
  
  highlight("Special", { fg = colors.orange })
  highlight("SpecialChar", { fg = colors.orange })
  highlight("Tag", { fg = colors.orange })
  highlight("Delimiter", { fg = colors.fg })
  highlight("SpecialComment", { fg = colors.gray })
  highlight("Debug", { fg = colors.red })
  
  highlight("Underlined", { style = "underline" })
  highlight("Bold", { style = "bold" })
  highlight("Italic", { style = "italic" })
  
  highlight("Error", { fg = colors.red })
  highlight("Todo", { fg = colors.cyan, style = "bold" })
  
  -- Treesitter
  highlight("@variable", { fg = colors.blue })
  highlight("@variable.builtin", { fg = colors.blue })
  highlight("@variable.parameter", { fg = colors.orange })
  highlight("@variable.member", { fg = colors.blue })
  
  highlight("@constant", { fg = colors.blue })
  highlight("@constant.builtin", { fg = colors.blue })
  highlight("@constant.macro", { fg = colors.blue })
  
  -- Template expressions ${...}
  highlight("@markup.raw", { fg = colors.func })
  highlight("@string.special", { fg = colors.func })
  highlight("@punctuation.special", { fg = colors.func })
  
  highlight("@constant", { fg = colors.blue })
  highlight("@constant.builtin", { fg = colors.blue })
  highlight("@constant.macro", { fg = colors.blue })
  
  highlight("@string", { fg = colors.orange })
  highlight("@string.regex", { fg = colors.orange })
  highlight("@string.escape", { fg = colors.orange })
  
  highlight("@character", { fg = colors.orange })
  highlight("@number", { fg = colors.fg })
  highlight("@boolean", { fg = colors.blue })
  highlight("@float", { fg = colors.fg })
  
  highlight("@function", { fg = colors.func })
  highlight("@function.builtin", { fg = colors.func })
  highlight("@function.macro", { fg = colors.func })
  highlight("@function.method", { fg = colors.func })
  highlight("@function.call", { fg = colors.func })
  highlight("@method", { fg = colors.func })
  highlight("@method.call", { fg = colors.func })
  
  highlight("@constructor", { fg = colors.func })
  highlight("@parameter", { fg = colors.orange })
  
  highlight("@keyword", { fg = colors.cyan })
  highlight("@keyword.function", { fg = colors.cyan })
  highlight("@keyword.operator", { fg = colors.cyan })
  highlight("@keyword.return", { fg = colors.cyan })
  
  highlight("@conditional", { fg = colors.cyan })
  highlight("@repeat", { fg = colors.cyan })
  highlight("@label", { fg = colors.cyan })
  highlight("@operator", { fg = colors.cyan })
  highlight("@exception", { fg = colors.cyan })
  
  highlight("@type", { fg = colors.orange })
  highlight("@type.builtin", { fg = colors.orange })
  highlight("@type.qualifier", { fg = colors.cyan })
  
  highlight("@property", { fg = colors.blue })
  highlight("@field", { fg = colors.blue })
  highlight("@variable.member", { fg = colors.blue })
  
  highlight("@punctuation.delimiter", { fg = colors.fg })
  highlight("@punctuation.bracket", { fg = colors.fg })
  highlight("@punctuation.special", { fg = colors.fg })
  
  highlight("@comment", { fg = colors.gray, style = "italic" })
  
  highlight("@tag", { fg = colors.orange })
  highlight("@tag.attribute", { fg = colors.blue })
  highlight("@tag.delimiter", { fg = colors.fg })
  
  -- Markdown
  highlight("@markup.heading", { fg = colors.red, style = "bold" })
  highlight("@markup.strong", { fg = colors.red, style = "bold" })
  highlight("@markup.italic", { style = "italic" })
  highlight("@markup.underline", { style = "underline" })
  highlight("@markup.link", { fg = colors.cyan, style = "underline" })
  highlight("@markup.raw", { fg = colors.orange })
  
  -- LSP
  highlight("DiagnosticError", { fg = colors.red })
  highlight("DiagnosticWarn", { fg = colors.orange })
  highlight("DiagnosticInfo", { fg = colors.cyan })
  highlight("DiagnosticHint", { fg = colors.gray_light })
  
  highlight("LspReferenceText", { bg = colors.bg_highlight })
  highlight("LspReferenceRead", { bg = colors.bg_highlight })
  highlight("LspReferenceWrite", { bg = colors.bg_highlight })
  
  -- Git
  highlight("GitSignsAdd", { fg = colors.green })
  highlight("GitSignsChange", { fg = colors.cyan })
  highlight("GitSignsDelete", { fg = colors.red })
  
  -- Rainbow Delimiters (depth 1, 2, 3)
  highlight("RainbowDelimiterYellow", { fg = "#FFD700" })
  highlight("RainbowDelimiterPink", { fg = "#DA70D6" })
  highlight("RainbowDelimiterBlue", { fg = "#179FFF" })
  
  -- Neo-tree
  highlight("NeoTreeNormal", { fg = colors.fg, bg = colors.bg })
  highlight("NeoTreeNormalNC", { fg = colors.fg, bg = colors.bg })
  highlight("NeoTreeDirectoryIcon", { fg = colors.cyan })
  highlight("NeoTreeDirectoryName", { fg = colors.fg })
  highlight("NeoTreeFileName", { fg = colors.fg })
  highlight("NeoTreeFileIcon", { fg = colors.blue })
  highlight("NeoTreeRootName", { fg = colors.cyan, style = "bold" })
  highlight("NeoTreeIndentMarker", { fg = colors.gray })
  highlight("NeoTreeExpander", { fg = colors.gray })
  highlight("NeoTreeFloatBorder", { fg = colors.gray_light, bg = colors.bg })
  highlight("NeoTreeTitleBar", { fg = colors.bg, bg = colors.cyan })
  highlight("NeoTreeGitAdded", { fg = colors.green })
  highlight("NeoTreeGitModified", { fg = colors.orange })
  highlight("NeoTreeGitDeleted", { fg = colors.red })
  highlight("NeoTreeGitConflict", { fg = colors.red, style = "bold" })
  highlight("NeoTreeGitUntracked", { fg = colors.gray })
  highlight("NeoTreeGitIgnored", { fg = colors.gray })
  highlight("NeoTreeCursorLine", { bg = colors.bg_highlight })
  highlight("NeoTreeDimText", { fg = colors.gray })
  highlight("NeoTreeFilterTerm", { fg = colors.cyan, style = "bold" })
  highlight("NeoTreeTabActive", { fg = colors.fg, bg = colors.bg_highlight })
  highlight("NeoTreeTabInactive", { fg = colors.gray, bg = colors.bg })
  highlight("NeoTreeTabSeparatorActive", { fg = colors.bg_highlight, bg = colors.bg_highlight })
  highlight("NeoTreeTabSeparatorInactive", { fg = colors.bg, bg = colors.bg })

  -- Lualine
  highlight("lualine_a_normal", { fg = colors.bg, bg = colors.cyan, style = "bold" })
  highlight("lualine_a_insert", { fg = colors.bg, bg = colors.green, style = "bold" })
  highlight("lualine_a_visual", { fg = colors.bg, bg = colors.blue, style = "bold" })
  highlight("lualine_a_replace", { fg = colors.bg, bg = colors.red, style = "bold" })
  highlight("lualine_a_command", { fg = colors.bg, bg = colors.orange, style = "bold" })
  
  highlight("lualine_b_normal", { fg = colors.fg, bg = colors.bg_alt })
  highlight("lualine_b_insert", { fg = colors.fg, bg = colors.bg_alt })
  highlight("lualine_b_visual", { fg = colors.fg, bg = colors.bg_alt })
  highlight("lualine_b_replace", { fg = colors.fg, bg = colors.bg_alt })
  highlight("lualine_b_command", { fg = colors.fg, bg = colors.bg_alt })
  
  highlight("lualine_c_normal", { fg = colors.gray, bg = colors.bg })
  highlight("lualine_c_insert", { fg = colors.gray, bg = colors.bg })
  highlight("lualine_c_visual", { fg = colors.gray, bg = colors.bg })
  highlight("lualine_c_replace", { fg = colors.gray, bg = colors.bg })
  highlight("lualine_c_command", { fg = colors.gray, bg = colors.bg })
  
  highlight("lualine_x_normal", { fg = colors.gray, bg = colors.bg })
  highlight("lualine_x_insert", { fg = colors.gray, bg = colors.bg })
  highlight("lualine_x_visual", { fg = colors.gray, bg = colors.bg })
  highlight("lualine_x_replace", { fg = colors.gray, bg = colors.bg })
  highlight("lualine_x_command", { fg = colors.gray, bg = colors.bg })
  
  highlight("lualine_y_normal", { fg = colors.fg, bg = colors.bg_alt })
  highlight("lualine_y_insert", { fg = colors.fg, bg = colors.bg_alt })
  highlight("lualine_y_visual", { fg = colors.fg, bg = colors.bg_alt })
  highlight("lualine_y_replace", { fg = colors.fg, bg = colors.bg_alt })
  highlight("lualine_y_command", { fg = colors.fg, bg = colors.bg_alt })
  
  highlight("lualine_z_normal", { fg = colors.bg, bg = colors.cyan, style = "bold" })
  highlight("lualine_z_insert", { fg = colors.bg, bg = colors.green, style = "bold" })
  highlight("lualine_z_visual", { fg = colors.bg, bg = colors.blue, style = "bold" })
  highlight("lualine_z_replace", { fg = colors.bg, bg = colors.red, style = "bold" })
  highlight("lualine_z_command", { fg = colors.bg, bg = colors.orange, style = "bold" })
