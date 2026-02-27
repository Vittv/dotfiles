-- Wrap word in $ for inline LaTeX
vim.keymap.set('n', '<leader>l', function()
  local word = vim.fn.expand('<cword>')
  vim.cmd('normal! ciw$' .. word .. '$')
end, { desc = 'Wrap word in $ (inline LaTeX)' })

-- Wrap selection in $ for inline LaTeX
vim.keymap.set('v', '<leader>l', function()
  vim.cmd('normal! y')
  local sel = vim.fn.getreg('"')
  vim.cmd('normal! gvc$' .. sel .. '$')
end, { desc = 'Wrap selection in $ (inline LaTeX)' })
