local state = {
  win = nil,
  buf = nil,
  job_id = nil,
  original_win = nil,
}

local function create_split_terminal()
  -- save the current window before opening the split
  state.original_win = vim.api.nvim_get_current_win()

  local total_lines = vim.o.lines
  local term_height = math.floor(total_lines * 0.40)

  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    -- open a split at the bottom (pushes current buffer up)
    vim.cmd("botright " .. term_height .. "split")
    state.win = vim.api.nvim_get_current_win()
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(state.win, state.buf)

    state.job_id = vim.fn.jobstart(vim.o.shell, {
      term = true,
      env = { TERM = "xterm-256color" },
      on_exit = function()
        if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
          vim.api.nvim_buf_delete(state.buf, { force = true })
        end
        state.buf = nil
        state.win = nil
        state.job_id = nil
      end,
    })

    vim.keymap.set("n", "<leader>tt", "<nop>", { buffer = state.buf })
    vim.keymap.set("t", "<leader>tt", "<nop>", { buffer = state.buf })
  else
    -- reopen split with existing buffer
    vim.cmd("botright " .. term_height .. "split")
    state.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(state.win, state.buf)
  end

  vim.cmd("startinsert")
end

local function toggle_terminal()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    state.win = nil
    -- return focus to the original window
    if state.original_win and vim.api.nvim_win_is_valid(state.original_win) then
      vim.api.nvim_set_current_win(state.original_win)
    end
  else
    create_split_terminal()
  end
end

vim.keymap.set("n", "<leader>tt", toggle_terminal, { desc = "toggle split terminal" })

vim.keymap.set("t", "<leader>tt", function()
  if vim.api.nvim_get_current_buf() == state.buf then
    if state.win and vim.api.nvim_win_is_valid(state.win) then
      vim.api.nvim_win_hide(state.win)
      state.win = nil
      if state.original_win and vim.api.nvim_win_is_valid(state.original_win) then
        vim.api.nvim_set_current_win(state.original_win)
      end
    end
  end
end, { desc = "close split terminal" })

vim.keymap.set("t", "<Esc><Esc>", function()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    state.win = nil
    if state.original_win and vim.api.nvim_win_is_valid(state.original_win) then
      vim.api.nvim_set_current_win(state.original_win)
    end
  end
end, { desc = "close terminal" })

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(args)
    local buf = args.buf
    vim.keymap.set("n", "<Esc><Esc>", function()
      if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_hide(state.win)
        state.win = nil
        if state.original_win and vim.api.nvim_win_is_valid(state.original_win) then
          vim.api.nvim_set_current_win(state.original_win)
        end
      end
    end, { buffer = buf, desc = "close terminal (normal mode)" })
  end,
})
