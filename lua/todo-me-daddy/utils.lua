local files = require("todo-me-daddy.files")
local methods = require("todo-me-daddy.methods")

local utils = {
    todos = {}
}

local homeDir = os.getenv("HOME")

function utils:get_todo_comments()
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
                        local lineNum = string.match(v, "%d+")
                        -- Oh god regex is so ugly
                        -- Lua uses % not \ for escaping
                        if string.find(stringWithNoNumber, "^-%s%[ ]") then
                            local todoTable = {
                                file = file,
                                line = lineNum,
                                value = v
                            }
                            utils:add_todo_to_table(file, todoTable)
                        end
                    end
                end
                --TODO: Clean this up, it's ugly as hell
                if string.find(v, "TODO") then
                    local lineNum = string.match(v, "%d+")
                    --TODO: implent this
                    -- local commentString = vim.cmd("echo &commentstring")

                    if filetype == "lua" then
                        if string.find(stringWithNoNumber, "^--TODO") or string.find(stringWithNoNumber, "^-- TODO") then
                            local todoTable = {
                                file = file,
                                line = lineNum,
                                value = v,
                            }

                            utils:add_todo_to_table(file, todoTable)
                        end
                    elseif filetype == "js" or filetype == "ts" or filetype == "go" or filetype == "c" then
                        if string.find(stringWithNoNumber, "^//TODO") or string.find(stringWithNoNumber, "^// TODO") then
                            utils:add_todo_to_table(file, v)
                        end
                    elseif filetype == "sh" or filetype == "py" then
                        if string.find(stringWithNoNumber, "^#TODO")  or string.find(stringWithNoNumber, "^# TODO") then
                            utils:add_todo_to_table(file, v)
                        end
                    elseif filetype == "" or filetype == nil then
                        if string.find(stringWithNoNumber, "^#TODO") or string.find(stringWithNoNumber, "^# TODO") then
                            utils:add_todo_to_table(file, v)
                        end
                    else
                        if string.find(stringWithNoNumber, "^//TODO") or string.find(stringWithNoNumber, "^// TODO") then
                            utils:add_todo_to_table(file, v)
                        end
                    end
                end
            end
        end
    end

    return utils.todos
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

function utils:get_todos()
    local currentDir = utils:get_current_dir()
    files:files_from_dir(currentDir)
    return utils:get_todo_comments()
end

function utils:add_todo_to_table(file, todo)
    local todoComment = "%s %s"
    todo = string.format(todoComment, todo, file)
    table.insert(utils.todos, todo)
end

function utils:jump_to_todo(todo)
    local lineNum = string.match(todo, "%d+")
    todo = string.sub(todo, string.find(todo, homeDir) + 1)
    todo = "/" .. todo
    vim.cmd("e " .. todo)
    vim.cmd(":" .. lineNum)
end

return utils
