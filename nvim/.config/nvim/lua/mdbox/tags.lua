local function search_tags()
  local notes_dir = vim.fn.expand("~/Documents/zettelkasten")
  require("snacks").picker.grep({
    prompt_title = "Search Tags",
    cwd = notes_dir,
    default_text = "tags:.*#",
    args = { "--pcre2" },
  })
end

local function search_specific_tag(tag)
  local notes_dir = vim.fn.expand("~/Documents/zettelkasten")
  require("snacks").picker.grep({
    prompt_title = "Files with tag: " .. tag,
    cwd = notes_dir,
    default_text = "tags:.*" .. tag:gsub("#", "\\#"),
    args = { "--pcre2" },
  })
end

return {
  search_tags = search_tags,
  search_specific_tag = search_specific_tag,
}
