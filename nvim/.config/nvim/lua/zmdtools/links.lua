local function open_url()
  local word = vim.fn.expand('<cWORD>')
  local url = word:match("https?://[%w%-_%.%?%+=&/%%#]+")
  
  if url then
    local opener = vim.fn.has('mac') == 1 and 'open' or 'xdg-open'
    vim.fn.jobstart({opener, url}, {detach = true})
    print("Opening: " .. url)
  else
    print("No URL found under cursor")
  end
end

return {
  open_url = open_url,
}
