local enter = require('mdbox.enter')
local keymaps = require('mdbox.keymaps')

-- Setup keymaps
keymaps.setup()

-- Markdown indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Enter key behavior in markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<CR>", enter.handle_enter, { buffer = true, desc = "Toggle checkbox or search tags" })
  end,
})

-- Enable heading-based folding
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt_local.foldenable = true   -- Enable folds
    vim.opt_local.foldlevel = 99      -- Start with all folds open
  end,
})
