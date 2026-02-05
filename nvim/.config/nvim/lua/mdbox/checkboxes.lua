local function toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  
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
end

return {
  toggle_checkbox = toggle_checkbox,
}
