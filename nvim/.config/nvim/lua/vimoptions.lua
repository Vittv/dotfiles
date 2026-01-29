-- Personal preferences
-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Markdown indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

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

vim.keymap.set('n', 'gx', function()
  -- Get the "WORD" under the cursor
  local word = vim.fn.expand('<cWORD>')
  
  -- Use a regex to extract the URL from within brackets or parentheses
  local url = word:match("https?://[%w%-_%.%?%+=&/%%#]+")
  
  if url then
    -- Detect OS and open accordingly
    local opener = vim.fn.has('mac') == 1 and 'open' or 'xdg-open'
    vim.fn.jobstart({opener, url}, {detach = true})
    print("Opening: " .. url)
  else
    print("No URL found under cursor")
  end
end, { desc = 'Open URL under cursor' })

vim.keymap.set("n", "<leader>ot", function()
  local template = vim.fn.expand("~/manoir/zettelkasten/Templates/default.md")
  if vim.fn.filereadable(template) == 1 then
    -- Read template at cursor position
    vim.cmd("0r " .. template)
    -- Replace placeholders
    vim.cmd("%s/{{cryptoID}}/" .. math.random(1000000000, 9999999999) .. "/ge")
    vim.cmd("%s/{{date}}/" .. os.date("%Y-%m-%d") .. "/ge")
    vim.cmd("%s/{{time}}/" .. os.date("%H:%M:%S") .. "/ge")
  else
    print("Template not found: " .. template)
  end
end, { desc = "Insert template" })
