local function insert_template()
  local template = vim.fn.expand("~/Documents/zettelkasten/Templates/default.md")
  if vim.fn.filereadable(template) == 1 then
    vim.cmd("0r " .. template)
    vim.cmd("%s/{{cryptoID}}/" .. math.random(1000000000, 9999999999) .. "/ge")
    vim.cmd("%s/{{date}}/" .. os.date("%Y-%m-%d") .. "/ge")
    vim.cmd("%s/{{time}}/" .. os.date("%H:%M:%S") .. "/ge")
  else
    print("Template not found: " .. template)
  end
end

return {
  insert_template = insert_template,
}
