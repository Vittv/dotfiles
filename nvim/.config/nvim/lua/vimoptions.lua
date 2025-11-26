-- Personal preferences
-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Keymaps
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
local map = vim.api.nvim_set_keymap
local silent = { silent = true, noremap = true }

-- Leader Keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Map <Space> to <Nop> to allow it to be used as leader
map("", "<space>", "<Nop>", silent)

-- Enable Virtual Text for diagnostics
vim.diagnostic.config({
  virtual_text = {
    set = true,
  },
  signs = true,
  underline = true,
})

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

