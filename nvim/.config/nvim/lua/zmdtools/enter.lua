local tags = require("zmdtools.tags")
local checkboxes = require("zmdtools.checkboxes")

local function handle_enter()
  local line = vim.api.nvim_get_current_line()
  local word = vim.fn.expand("<cWORD>")

  -- Check if line is a heading
  if line:match("^#+%s") then
    vim.cmd("normal! za")
    return
  end
  
  -- Check if cursor is on a tag
  local tag = word:match("(#%w+)")
  if tag then
    tags.search_specific_tag(tag)
    return
  end
  
  -- Otherwise, toggle checkbox
  checkboxes.toggle_checkbox()
end

return {
  handle_enter = handle_enter,
}
