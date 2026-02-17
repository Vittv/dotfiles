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

local function follow_wiki_link()
  local line = vim.api.nvim_get_current_line()
  
  -- Pattern to match [[filename]] anywhere in the line
  local link = line:match("%[%[([^%]]+)%]%]")
  
  if link then
    -- Add .md extension if not present
    if not link:match("%.md$") then
      link = link .. ".md"
    end
    
    -- Start from current file's directory
    local current_dir = vim.fn.expand("%:p:h")
    
    -- Try current directory first
    local filepath = current_dir .. "/" .. link
    if vim.fn.filereadable(filepath) == 1 then
      vim.cmd("edit " .. filepath)
      return
    end
    
    -- Search upward through parent directories
    local search_dir = current_dir
    for i = 1, 5 do  -- Search up to 5 levels up
      search_dir = vim.fn.fnamemodify(search_dir, ":h")
      
      -- Use find to search recursively from this level
      local find_result = vim.fn.systemlist("find " .. vim.fn.shellescape(search_dir) .. " -name " .. vim.fn.shellescape(link) .. " -type f 2>/dev/null")
      
      if #find_result > 0 then
        vim.cmd("edit " .. find_result[1])
        return
      end
    end
    
    print("File not found: " .. link)
  else
    print("No [[link]] found on this line")
  end
end

return {
  open_url = open_url,
  follow_wiki_link = follow_wiki_link,
}
