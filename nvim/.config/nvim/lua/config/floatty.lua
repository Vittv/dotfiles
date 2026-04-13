local state = {
  win = nil,
  buf = nil,
  job_id = nil,
}

local function create_floating_terminal()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  
  -- create terminal buffer if needed
  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    state.buf = vim.api.nvim_create_buf(false, true)
    
    -- Create the floating window first
    state.win = vim.api.nvim_open_win(state.buf, true, {
      relative = "editor",
      width = width,
      height = height,
      col = col,
      row = row,
      style = "minimal",
      border = "rounded",
    })
    
    -- Start terminal job using jobstart with term option
    state.job_id = vim.fn.jobstart(vim.o.shell, {
      term = true,
      env = {
        TERM = "xterm-256color"
      },
      on_exit = function()
        -- Clean up when terminal exits
        if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
          vim.api.nvim_buf_delete(state.buf, { force = true })
        end
        state.buf = nil
        state.win = nil
        state.job_id = nil
      end,
    })
    
    -- Disable the toggle keybind inside this terminal buffer
    vim.keymap.set("n", "<leader>tt", "<nop>", { buffer = state.buf })
    vim.keymap.set("t", "<leader>tt", "<nop>", { buffer = state.buf })
  else
    -- Just reopen the window if buffer still exists
    state.win = vim.api.nvim_open_win(state.buf, true, {
      relative = "editor",
      width = width,
      height = height,
      col = col,
      row = row,
      style = "minimal",
      border = "rounded",
    })
  end
  
  -- Enter insert mode in terminal
  vim.cmd("startinsert")
end

local function toggle_terminal()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    state.win = nil
  else
    create_floating_terminal()
  end
end

-- Main toggle keybind
vim.keymap.set("n", "<leader>tt", toggle_terminal, { desc = "toggle floating terminal" })

-- Also allow toggling from terminal mode (for easy focus switching)
vim.keymap.set("t", "<leader>tt", function()
  -- Check if we're in the floating terminal
  local current_buf = vim.api.nvim_get_current_buf()
  if current_buf == state.buf then
    -- We're in the floating terminal, just hide it
    if state.win and vim.api.nvim_win_is_valid(state.win) then
      vim.api.nvim_win_hide(state.win)
      state.win = nil
    end
  end
end, { desc = "close floating terminal" })

-- Close terminal with Esc Esc from within it (terminal-mode)
vim.keymap.set("t", "<Esc><Esc>", function()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    state.win = nil
  end
end, { desc = "close terminal" })

-- FIX: Clicking terminal switches it into NORMAL MODE in terminal buffer.
-- So <Esc><Esc> must also work in normal mode for this buffer.
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(args)
    local buf = args.buf
    vim.keymap.set("n", "<Esc><Esc>", function()
      if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_hide(state.win)
        state.win = nil
      end
    end, { buffer = buf, desc = "close terminal (normal mode)" })
  end,
})

