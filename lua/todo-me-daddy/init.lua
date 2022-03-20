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
                    v = string.gsub(v, "^%s*", "")
                    v = string.gsub(v, "^(%d+)", "%1 ")
                    v = string.gsub(v, "^(%d+)%s*", "%1 ")

                    -- Check that v starts with a number then a space then a --
                    -- Ignore the number and the space and then check for the --
                    local stringWithNoNumber = string.sub(v, 3)
                    -- Remove the whitespace at the start of the string
                    stringWithNoNumber = string.gsub(stringWithNoNumber, "^%s*", "")
                    -- Check the filetype using the file extension
                    local filetype = string.match(file, "%.([^.]+)$")

                    if filetype == "lua" then
                        if string.find(stringWithNoNumber, "^--TODO") or string.find(stringWithNoNumber, "^-- TODO") then
                            local todoComment = "%s %s"
                            v = string.format(todoComment, v, file)
                            table.insert(todos, v)
                        end
                    elseif filetype == "js" or filetype == "ts" or filetype == "go" or filetype == "c" then
                        if string.find(stringWithNoNumber, "^//TODO") or string.find(stringWithNoNumber, "^// TODO") then
                            local todoComment = "%s %s"
                            v = string.format(todoComment, v, file)
                            table.insert(todos, v)
                        end
                    elseif filetype == "sh" or filetype == "py" then
                        if string.find(stringWithNoNumber, "^#TODO")  or string.find(stringWithNoNumber, "^# TODO") then
                            local todoComment = "%s %s"
                            v = string.format(todoComment, v, file)
                            table.insert(todos, v)
                        end
                    end
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
    local lineNum = string.match(todo, "%d+")
    todo = string.sub(todo, string.find(todo, homeDir) + 1)
    todo = "/" .. todo
    vim.cmd("e " .. todo)
    vim.cmd(":" .. lineNum)
end

M.quick_fix_list = function()
    M.main()
end

return M
