return {
  { "vim-denops/denops.vim" },
  {
    "vim-skk/skkeleton",
    dependencies = { "vim-denops/denops.vim" },
    config = function()
      vim.keymap.set({'i', 'c'}, '<C-j>', '<Plug>(skkeleton-toggle)')

      vim.fn['skkeleton#config']({
        globalDictionaries = { vim.fn.expand('~/.skk/SKK-JISYO.L') },
        eggLikeNewline = true,
      })

      vim.api.nvim_create_autocmd('InsertLeave', {
        callback = function()
          vim.fn['skkeleton#disable']()
        end
      })

      vim.api.nvim_create_user_command('Jisho', function(opts)
        local query = opts.args
        local url = 'https://jisho.org/search/' .. query
        vim.fn.jobstart({ 'xdg-open', url })
      end, { nargs = '?' })

      vim.api.nvim_create_user_command('Anki', function()
        vim.fn.jobstart({ 'anki' })
      end, {})
    end,
  },
}
