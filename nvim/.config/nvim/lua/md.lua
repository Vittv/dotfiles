local tags = require('mdbox.tags')
local templates = require('mdbox.templates')
local links = require('mdbox.links')
local enter = require('mdbox.enter')

-- Markdown indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Keymaps
vim.keymap.set('n', 'gx', links.open_url, { desc = 'Open URL under cursor' })
vim.keymap.set("n", "<leader>ot", templates.insert_template, { desc = "Insert template" })
vim.keymap.set("n", "<leader>t", tags.search_tags, { desc = "Search tags in notes" })
vim.keymap.set("n", "<leader>ag", function()
  vim.cmd("w")
  vim.fn.system("~/Documents/Bulletin/src/att.sh")
  vim.cmd("e")
end)

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
