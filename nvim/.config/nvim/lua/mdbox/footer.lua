local ns = vim.api.nvim_create_namespace("md_footer")

local function count_backlinks(bufnr)
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t:r")
  if fname == "" then return 0 end
  local result = vim.fn.systemlist(string.format(
    "rg --count-matches '\\[\\[%s\\]\\]' --glob '*.md' .",
    fname
  ))
  local total = 0
  for _, line in ipairs(result) do
    local n = tonumber(line:match(":(%d+)$"))
    if n then total = total + n end
  end
  return total
end

local function set_footer(bufnr, skip_backlinks)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local line_count = #lines
  local char_count = 0
  local word_count = 0
  for _, line in ipairs(lines) do
    char_count = char_count + #line
    local _, n = line:gsub("%S+", "")
    word_count = word_count + n
  end
  local tag_count = 0
  for _, line in ipairs(lines) do
    local _, n = line:gsub("#%w+", "")
    tag_count = tag_count + n
  end
  local backlinks = skip_backlinks and 0 or count_backlinks(bufnr)
  local last_line = math.max(0, line_count - 1)
  vim.api.nvim_buf_set_extmark(bufnr, ns, last_line, 0, {
    virt_lines = {
      {},
      { { string.rep("─", vim.api.nvim_win_get_width(0)), "NonText" } },
      {
        { "󰌹 " .. backlinks .. " backlinks", "@property" },
        { "   ", "NonText" },
        { " " .. tag_count .. " tags", "@property" },
        { "   ", "NonText" },
        { "󰄾 " .. word_count .. " words", "@property" },
        { "   ", "NonText" },
        { "󰈚 " .. char_count .. " chars", "@property" },
      },
    },
    virt_lines_above = false,
  })
end

-- shows footer when entering a buffer or saving
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  pattern = "*.md",
  callback = function(ev)
    set_footer(ev.buf, false)
  end,
})

-- hides footer when typing
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*.md",
  callback = function(ev)
    vim.api.nvim_buf_clear_namespace(ev.buf, ns, 0, -1)
  end,
})

-- shows footer again when done typing
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*.md",
  callback = function(ev)
    set_footer(ev.buf, false)
  end,
})
