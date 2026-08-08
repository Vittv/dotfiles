return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'markdown' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { 'markdown', 'blink-cmp-documentation' },
      completions = {
        lsp = { enabled = true },
      },
      latex = {
        enabled = true,
        converter = 'utftex',
      },
    },
    init = function()
      local function set_hl()
        vim.api.nvim_set_hl(0, '@markup.strong.markdown_inline', {
          fg = vim.api.nvim_get_hl(0, { name = 'Function' }).fg,
          bold = true,
        })
      end

      -- apply now (in case colorscheme already loaded)
      set_hl()

      -- re-apply after any colorscheme change
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = set_hl,
      })

      -- mdbox additions (port from lua/mdbox/keymaps.lua + lua/md.lua, minus what obsidian provides)
      -- markdown indentation + treesitter folding
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          vim.opt_local.tabstop = 2
          vim.opt_local.softtabstop = 2
          vim.opt_local.shiftwidth = 2
          vim.opt_local.foldmethod = 'expr'
          vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.opt_local.foldenable = true
          vim.opt_local.foldlevel = 99
        end,
      })

      -- italicize word under cursor
      vim.keymap.set('n', '<leader>i', function()
        local word = vim.fn.expand('<cword>')
        vim.cmd('normal! ciw*' .. word .. '*')
        vim.cmd('normal! l')
      end, { desc = 'Italicize word under cursor' })

      -- italicize visual selection
      vim.keymap.set('v', '<leader>i', 'c**<Esc>P', { desc = 'Italicize selection' })

      -- embolden word under cursor
      vim.keymap.set('n', '<leader>b', function()
        local word = vim.fn.expand('<cword>')
        vim.cmd('normal! ciw**' .. word .. '**')
        vim.cmd('normal! l')
      end, { desc = 'Bold word under cursor' })

      -- embolden visual selection
      vim.keymap.set('v', '<leader>b', 'c****<Esc>hP', { desc = 'Bold selection' })

      -- wrap word in backticks
      vim.keymap.set('n', '<leader>c', function()
        local word = vim.fn.expand('<cword>')
        vim.cmd('normal! ciw`' .. word .. '`')
        vim.cmd('normal! l')
      end, { desc = 'Wrap word in backticks' })

      -- wrap selection in backticks
      vim.keymap.set('v', '<leader>c', function()
        vim.cmd('normal! y')
        local sel = vim.fn.getreg('"')
        vim.cmd('normal! gvc`' .. sel .. '`')
      end, { desc = 'Wrap selection in backticks' })

      -- send finished tasks to archive
      vim.keymap.set('n', '<leader>ag', function()
        vim.cmd('w')
        vim.fn.system('~/Documents/Tasks/src/att.sh')
        vim.cmd('e')
      end, { desc = 'Send finished tasks to archive' })

      -- universal markdown enter: checkbox toggle, heading fold, link follow
      vim.keymap.set('n', '<CR>', function()
        local line = vim.api.nvim_get_current_line()

        -- checkbox: toggle [ ] <-> [x]
        if line:match('^%s*%- %[[ x]%] ') then
          if line:find('%[x%]') then
            vim.api.nvim_set_current_line(line:gsub('%[x%]', '[ ]', 1))
          else
            vim.api.nvim_set_current_line(line:gsub('%[ %]', '[x]', 1))
          end
          return
        end

        -- heading: cycle fold
        if line:match('^#{1,6} ') then
          vim.cmd('normal! za')
          return
        end

        -- markdown link: open URL or follow file path
        local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
        local start = 1
        while start <= #line do
          local s, e, text, url = line:find('%[([^%]]*)%]%(([^)]+)%)', start)
          if s and cursor_col >= s - 1 and cursor_col < e then
            if url:match('^https?://') then
              vim.fn.system('xdg-open "' .. url .. '"')
            else
              vim.cmd('edit ' .. vim.fn.fnamemodify(url, ':p'))
            end
            return
          end
          start = s and e + 1 or #line + 1
        end

        -- fallback: move cursor down (default <CR> in normal mode)
        vim.fn.feedkeys('j', 'n')
      end, { desc = 'Markdown enter: toggle checkbox / fold heading / follow link' })
    end,
  },
}
