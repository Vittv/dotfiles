local function search_tags()
  local has_telescope, builtin = pcall(require, "telescope.builtin")
  if not has_telescope then
    print("Telescope not found")
    return
  end
  local notes_dir = vim.fn.expand("~/Documents/zettelkasten")
  
  builtin.live_grep({
    prompt_title = "Search Tags",
    cwd = notes_dir,
    default_text = "tags:.*#",
    additional_args = function()
      return {"--pcre2"}
    end
  })
end

local function search_specific_tag(tag)
  local has_telescope, builtin = pcall(require, "telescope.builtin")
  if not has_telescope then
    print("Telescope not found")
    return
  end
  local notes_dir = vim.fn.expand("~/Documents/zettelkasten")
  
  builtin.live_grep({
    prompt_title = "Files with tag: " .. tag,
    cwd = notes_dir,
    default_text = "tags:.*" .. tag:gsub("#", "\\#"),
    additional_args = function()
      return {"--pcre2"}
    end
  })
end

return {
  search_tags = search_tags,
  search_specific_tag = search_specific_tag,
}
