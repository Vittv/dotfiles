local function find_project_root()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then
    dir = vim.fn.getcwd()
  end
  while dir ~= "/" do
    if vim.fn.isdirectory(dir .. "/.git") == 1 then
      return dir
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return vim.fn.getcwd()
end

local function open_todos()
  local root = find_project_root()
  ---@type table
  local opts = {
    prompt_title = "Todos",
    cwd = root,
    search = [=[\- \[ \]]=],
    glob = "*.md",
    live = false,
    ---@diagnostic disable-next-line: undefined-field
    format = function(item, picker)
      local display = item.text:match("^%s*%- (.+)$") or item.text
      return {
        { "○ ", "TodoPending" },
        { display, "Normal" },
        { "  " .. item.file, "Directory" },
      }
    end,
    ---@diagnostic disable-next-line: undefined-field
    actions = {
      ---@diagnostic disable-next-line: undefined-field
      todo_check = function(picker)
        if picker._todo_busy then
          return
        end
        picker._todo_busy = true

        local items = picker:selected({ fallback = true })
        local item = items[1]
        if not item or not item.pos then
          picker._todo_busy = false
          return
        end

        local filepath = Snacks.picker.util.path(item)
        local lnum = item.pos[1]

        local ok, lines = pcall(vim.fn.readfile, filepath)
        if not ok or not lines[lnum] then
          vim.notify("todo: couldn't read " .. tostring(filepath), vim.log.levels.WARN)
          picker._todo_busy = false
          return
        end

        local line = lines[lnum]
        if line:match("%[ %]") then
          line = line:gsub("%[ %]", "[x]", 1)
        elseif line:match("%[[xX]%]") then
          line = line:gsub("%[[xX]%]", "[ ]", 1)
        end
        lines[lnum] = line

        local write_ok = pcall(vim.fn.writefile, lines, filepath)
        if not write_ok then
          vim.notify("todo: couldn't write " .. filepath, vim.log.levels.ERROR)
          picker._todo_busy = false
          return
        end

        picker:refresh()
        picker._todo_busy = false
      end,
    },
    ---@diagnostic disable-next-line: undefined-field
    win = {
      ---@diagnostic disable-next-line: undefined-field
      input = {
        keys = {
          ["<Tab>"] = { "todo_check", mode = { "i", "n" } },
        },
      },
      ---@diagnostic disable-next-line: undefined-field
      list = {
        keys = {
          ["<Tab>"] = { "todo_check", mode = { "n" } },
        },
      },
    },
  }
  require("snacks").picker.grep(opts)
end

return { open_todos = open_todos }
