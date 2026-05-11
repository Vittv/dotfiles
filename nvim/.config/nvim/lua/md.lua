local enter = require('mdbox.enter')
local keymaps = require('mdbox.keymaps')
require('mdbox.footer')

-- setup keymaps
keymaps.setup()

-- markdown indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- enter key behavior in markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<CR>", enter.handle_enter, { buffer = true, desc = "Toggle checkbox or search tags" })
  end,
})

-- enable heading-based folding
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt_local.foldenable = true   -- enable folds
    vim.opt_local.foldlevel = 99      -- start with all folds open
  end,
})
