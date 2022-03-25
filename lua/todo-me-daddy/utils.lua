local files = require("todo-me-daddy.files")
local methods = require("todo-me-daddy.methods")
local utils = {}

function utils:get_todo_comments()
    -- Each time we run this, we need to clear the table
    -- This is because we are running this function multiple times
    -- and we don't want to add the same comments multiple times
    local todos = {}

    for k,v in pairs(files.fileTable) do
        local file = v
        -- Make sure that the file is not a dir
        if utils:file_not_dir(file) then
            local lines = files:get_line_from_file(file)
            for k,v in pairs(lines) do
                v = string.gsub(v, "^%s*", "")
                v = string.gsub(v, "^(%d+)", "%1 ")
                v = string.gsub(v, "^(%d+)%s*", "%1 ")

                local stringWithNoNumber = string.gsub(v, "^(%d+)%s*", "")
                stringWithNoNumber = string.gsub(stringWithNoNumber, "^%s*", "")
                local filetype = string.match(file, "%.([^.]+)$")

                if not methods.Get("get_markdown_todo") == false then
                    if filetype == "md" then
                        -- Oh god regex is so ugly
                        -- Lua uses % not \ for escaping
                        if string.find(stringWithNoNumber, "^-%s%[ ]") then
                            local todoComment = "%s %s"
                            v = string.format(todoComment, v, file)
                            table.insert(todos, v)
                        end
                    end
                end
                --TODO: Clean this up, it's ugly as hell
                if string.find(v, "TODO") then
                    --TODO: implent this
                    -- local commentString = vim.cmd("echo &commentstring")

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
                    elseif filetype == "" or filetype == nil then
                        if string.find(stringWithNoNumber, "^#TODO") or string.find(stringWithNoNumber, "^# TODO") then
                            local todoComment = "%s %s"
                            v = string.format(todoComment, v, file)
                            table.insert(todos, v)
                        end
                    else
                        if string.find(stringWithNoNumber, "^//TODO") or string.find(stringWithNoNumber, "^// TODO") then
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

function utils:exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

function utils:file_not_dir(name)
    if utils:exists(name .. "/") then
        return false
    else
        return true
    end
end

function utils:get_current_dir()
    return vim.fn.getcwd()
end

-- TODO: use this bad boy instead of the scuffed way of doing it
-- Reason I can't do this now, is beacuse it won't let me pass the table in
-- like that, and I need to return it to the table in order to have telescope
-- have it later
function utils:add_todo_to_table(file, todo, table)
    local todoComment = "%s %s"
    todo = string.format(todoComment, todo, file)
    table.insert(table, todo)
end

return utils
