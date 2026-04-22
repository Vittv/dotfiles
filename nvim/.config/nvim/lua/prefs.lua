-- Personal preferences
-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Clipboard provider
-- If on Windows just install win32yank inside WSL

-- Wayland
vim.g.clipboard = {
  name = "WlClipboard",
  copy = {
    ["+"]  = "wl-copy",
    ["*"]  = "wl-copy",
  },
  paste = {
    ["+"] = "wl-paste --no-newline",
    ["*"] = "wl-paste --no-newline",
  },
  cache_enabled = 0,
}

-- Xorg (make sure to install xclip as it doesn't always come with every distro)
-- vim.g.clipboard = {
--   name = "Xclip",
--   copy = {
--     ["+"]  = "xclip -selection clipboard",
--     ["*"]  = "xclip -selection primary",
--   },
--   paste = {
--     ["+"] = "xclip -selection clipboard -o",
--     ["*"] = "xclip -selection primary -o",
--   },
--   cache_enabled = 0,
-- }

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

-- Navigate buffers with leader 1 2 3...
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    local bufs = vim.tbl_filter(function(b)
      return vim.api.nvim_buf_is_loaded(b)
        and vim.bo[b].buflisted
    end, vim.api.nvim_list_bufs())
    if bufs[i] then
      vim.api.nvim_set_current_buf(bufs[i])
    end
  end, { desc = "Go to buffer " .. i })
end

-- Delete buffer but preserve window
vim.keymap.set("n", "<leader>x", function()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())

  local current = vim.api.nvim_get_current_buf()

  if #bufs > 1 then
    vim.cmd("bprevious")
  end

  vim.api.nvim_buf_delete(current, {})
end, { desc = "Close buffer" })
