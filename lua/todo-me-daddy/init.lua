local files = require("todo-me-daddy.files")
local entry_display = require("telescope.pickers.entry_display")

local M = {
  todos = {}
}

local comment_string = {
  ["py"] = "#",
  ["ts"] = "//",
  ["js"] = "//",
  ["go"] = "//",
  ["rs"] = "//",
  ["bash"] = "#",
  ["c"] = "//",
  ["lua"] = "--",
}

local function add_todo_to_table(file, todo)
  -- Make sure there is no duplicate values
  for index, value in ipairs(M.todos) do
    if value["value"] == todo then
      return
    end
  end

  local lineNum = string.match(todo, "%d+")
  file = vim.fn.fnamemodify(file, ":.")
  local line = todo

  local displayer = entry_display.create({
    separator = " - ",
    items = {
      { width = 1 },
      { width = 1000 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    return displayer({
      tostring(entry.index),
      line,
    })
  end

  local insert = {
    value = todo,
    ordinal = todo,
    display = make_display,
    lnum = tonumber(lineNum),
    col = 0,
    filename = file,
  }

  table.insert(M.todos, insert)
end

function M.read_lines()
  local allFiles = files.find_files()

  for _, file in ipairs(allFiles) do
    if not file:match(".git") then
      local lines = vim.fn.systemlist("cat -n " .. file)
      local file_type = string.match(file, "%.([^.]+)$")
      local search_string = string.format("^%sTODO", comment_string[file_type])
      for _, line in ipairs(lines) do
        -- Regex magick to remove number from start of string
        line = string.gsub(line, "^%s*", "")
        line = string.gsub(line, "^(%d+)", "%1 ")
        line = string.gsub(line, "^(%d+)%s*", "%1 ")
        local stringWithNoNumber = string.gsub(line, "^(%d+)%s*", "")
        stringWithNoNumber = string.gsub(stringWithNoNumber, "^%s*", "")

        if not stringWithNoNumber:match("Is a directory") then
          if stringWithNoNumber:match(search_string) then
            add_todo_to_table(file, line)
          end
        end
      end
    end
  end

  return require("telescope.finders").new_table({
    results = M.todos,
    entry_maker = function(entry)

      return {
        value = entry,
        ordinal = entry.ordinal,
        display = entry.display,
        lnum = entry.lnum,
        col = entry.col,
        filename = entry.filename,
      }
    end
  })
end

return M
