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
require("config.options")
require("prefs")
require("md")
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.lsp" },
    { import = "themes" },
  },
})
require("config.floaterminal")
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
-- In case you'd want to try that local theme,
-- Uncomment the following line:
-- vim.cmd.colorscheme("vaguevscode")
--
