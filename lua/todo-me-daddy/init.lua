local currentDir = vim.fn.getcwd()
local homeDir = os.getenv("HOME")
local fileTable = {}

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

--- Check if a file or directory exists in this path
function exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

function file_not_dir(name)
    if exists(name .. "/") then
        return false
    else
        return true
    end
end

function files_from_dir(dir)
    -- Find each file in the current dir, sorry windows users this only works on posix complaint shells (fuck you windows)
    local files = os.capture("find " .. dir)

    -- Get each item, split by new line, and insert it into the table fileTable
    local s = " "
    for f in string.gmatch(files, "([^" .. s .. "]+)") do
        -- If the string has node_modules in it then skip, as we don't want any gosh darn node_modules
        if not string.find(f, "node_modules") then
            table.insert(fileTable, f)
        end
    end
end

function lines_from(file)
    local lines = {}
    -- Read the file and split it by new line, include the line number in the table
    for line in io.lines(file) do
        local lineNum = #lines + 1
        table.insert(lines, lineNum .. line)
        -- lines[lineNum] = line
    end

    -- for line in io.lines(file) do
    --   lines[#lines + 1] = line
    -- end
    return lines
end


local M = {}

function get_todo_comments()
    -- Each time we run this, we need to clear the table
    -- This is because we are running this function multiple times
    -- and we don't want to add the same comments multiple times
    local todos = {}

    for k,v in pairs(fileTable) do
        local file = v
        if file_not_dir(file) then
            local lines = lines_from(file)
            for k,v in pairs(lines) do
                if string.find(v, "TODO") then
                    -- Remove any whitespace from the start of the line
                    v = string.gsub(v, "^%s*", "")
                    -- Add a space between the line number and the comment
                    v = string.gsub(v, "^(%d+)", "%1 ")
                    local todoComment = "%s %s"
                    v = string.format(todoComment, v, file)
                    table.insert(todos, v)
                end
            end
        end
    end

    return todos
end

M.main = function()
    fileTable = {}
    files_from_dir(currentDir)
    return get_todo_comments()
end

M.jump_to_todo = function(todo)
    lineNum = string.match(todo, "%d+")
    todo = string.sub(todo, string.find(todo, "/home/yoni/") + 1)
    todo = "/" .. todo
    vim.cmd("e " .. todo)
    print(lineNum)
    vim.cmd(":" .. lineNum)
end

return M
