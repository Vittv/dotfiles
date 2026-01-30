-- Markdown indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Set gx as a link opener
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

-- Set leader ot as template paster
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

-- Toggle markdown checkbox with Enter (markdown files only)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<CR>", function()
      local line = vim.api.nvim_get_current_line()
      
      -- Only toggle if line starts with "- [" (with optional whitespace)
      if line:match("^%s*- %[.%]") then
        local new_line
        if line:match("^%s*- %[ %]") then
          -- Unchecked -> Checked
          new_line = line:gsub("^(%s*- )%[ %]", "%1[x]")
        elseif line:match("^%s*- %[[xX]%]") then
          -- Checked -> Unchecked
          new_line = line:gsub("^(%s*- )%[[xX]%]", "%1[ ]")
        else
          -- Any other character in brackets -> Unchecked
          new_line = line:gsub("^(%s*- )%[.%]", "%1[ ]")
        end
        vim.api.nvim_set_current_line(new_line)
      else
        -- If not a checkbox, do normal Enter behavior
        vim.cmd("normal! i\r")
      end
    end, { buffer = true, desc = "Toggle checkbox" })
  end,
})
