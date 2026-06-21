-- vim ui2
-- require("vim._core.ui2").enable({
--   enable = true,
-- })
-- vim.opt.cmdheight = 0

-- lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- better text wrap
-- vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- tmux color fix
vim.opt.termguicolors = true

-- make all windows rounded
vim.o.winborder = "rounded"
require("prefs")
require("md")
require("latex")
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.lsp" },
    { import = "themes" },
  },
})
require('config.term')

-- builtin color preview - no more need for colorizer
vim.lsp.document_color.enable(true, nil, { style = 'virtual' })
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
