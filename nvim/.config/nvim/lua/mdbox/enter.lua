local tags = require('mdbox.tags')
local checkboxes = require('mdbox.checkboxes')
local links = require('mdbox.links')

local function handle_enter()
  local line = vim.api.nvim_get_current_line()
  local word = vim.fn.expand("<cWORD>")

  -- Check if line is a heading
  if line:match("^#+%s") then
    vim.cmd("normal! za")
    return
  end

  -- Check if cursor is on a URL
  local url = word:match("https?://[%w%-_%.%?%+=&/%%#]+")
  if url then
    links.open_url()
    return
  end

  -- Check if cursor is on a wiki link [[]]
  if line:match("%[%[.+%]%]") then
    links.follow_wiki_link()
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
