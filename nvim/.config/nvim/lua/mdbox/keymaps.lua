local tags = require('mdbox.tags')
local templates = require('mdbox.templates')
local links = require('mdbox.links')

local M = {}

function M.setup()
  -- Open URL links
  vim.keymap.set('n', 'gx', links.open_url, { desc = 'Open URL under cursor' })

  -- Insert default template
  vim.keymap.set("n", "<leader>ot", templates.insert_template, { desc = "Insert template" })

  -- Search for tags
  vim.keymap.set("n", "<leader>t", tags.search_tags, { desc = "Search tags in notes" })

  -- Format tasks on todo list
  -- Send finished tasks to archive
  vim.keymap.set("n", "<leader>ag", function()
    vim.cmd("w")
    vim.fn.system("~/Documents/Tasks/src/att.sh")
    vim.cmd("e")
  end)

  -- Italicize word under cursor
  vim.keymap.set('n', '<leader>i', function()
    local word = vim.fn.expand('<cword>')
    vim.cmd('normal! ciw*' .. word .. '*')
    vim.cmd('normal! l')
  end, { desc = 'Italicize word under cursor' })

  -- Italicize visual selection
  vim.keymap.set('v', '<leader>i', 'c**<Esc>P', { desc = 'Italicize selection' })

  -- Embolden word under cursor
  vim.keymap.set('n', '<leader>b', function()
    local word = vim.fn.expand('<cword>')
    vim.cmd('normal! ciw**' .. word .. '**')
    vim.cmd('normal! l')
  end, { desc = 'Bold word under cursor' })

  -- Embolden visual selection
  vim.keymap.set('v', '<leader>b', 'c****<Esc>hP', { desc = 'Bold selection' })

  -- Wrap word in backticks
  vim.keymap.set('n', '<leader>c', function()
    local word = vim.fn.expand('<cword>')
    vim.cmd('normal! ciw`' .. word .. '`')
    vim.cmd('normal! l')
  end, { desc = 'Wrap word in backticks' })

  -- Wrap selection in backticks
  vim.keymap.set('v', '<leader>c', function()
    vim.cmd('normal! y')
    local sel = vim.fn.getreg('"')
    vim.cmd('normal! gvc`' .. sel .. '`')
  end, { desc = 'Wrap selection in backticks' })

end

return M
