local files = require("todo-me-daddy.files")
local entry_display = require("telescope.pickers.entry_display")
local methods = require("todo-me-daddy.methods")
local info = require("todo-me-daddy.info")

local utils = {
    todos = {}
}

local homeDir = os.getenv("HOME")

function string.isempty(s)
    return s == nil or s == ''
end

function utils:get_todo_comments(name)
    -- Each time we run this, we need to clear the table
    -- This is because we are running this function multiple times
    -- and we don't want to add the same things multiple times
    utils.todos = {}
    for k, v in pairs(files.fileTable) do
        local file = v
        -- Make sure that the file is not a dir
        if utils:file_not_dir(file) then
            local lines = files:get_line_from_file(file)
            for k, v in pairs(lines) do
                v = string.gsub(v, "^%s*", "")
                v = string.gsub(v, "^(%d+)", "%1 ")
                v = string.gsub(v, "^(%d+)%s*", "%1 ")

                local stringWithNoNumber = string.gsub(v, "^(%d+)%s*", "")
                stringWithNoNumber = string.gsub(stringWithNoNumber, "^%s*", "")
                local filetype = string.match(file, "%.([^.]+)$")

                if not methods.Get("get_markdown_todo") == false then
                    if filetype == "md" and string.find(stringWithNoNumber, info(filetype)) then
                        utils:add_todo_to_table(file, v)
                    end
                end

                local searchString = "^" .. info(filetype) .. "TODO"
                local searchStringTwo = "^" .. info(filetype) .. " TODO"
                if string.find(stringWithNoNumber, searchString) or string.find(stringWithNoNumber, searchStringTwo) then
                    utils:add_todo_to_table(file, v)
                end
            end
        end
    end

    return require("telescope.finders").new_table({
        results = utils.todos,
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

function utils:get_todos(your_todos)
    if your_todos then
        local currentDir = utils:get_current_dir()
        files:files_from_dir(currentDir)
        local name = methods.Get("your_name")

        if string.isempty(name) then
            error("You must have your_name value set in order to call this method")
        end

        local todosToReturn = utils:get_todo_comments(name)
        return todosToReturn
    else
        local currentDir = utils:get_current_dir()
        files:files_from_dir(currentDir)
        local todosToReturn = utils:get_todo_comments("")
        return todosToReturn
    end
end

function utils:add_todo_to_table(file, todo)
    local lineNum = string.match(todo, "%d+")

    file = vim.fn.fnamemodify(file, ":.")

    local line = todo

    local displayer = entry_display.create({
        separator = " - ",
        items = {
            { width = 2 },
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
        value = line,
        ordinal = line,
        display = make_display,
        lnum = tonumber(lineNum),
        col = 0,
        filename = file,
    }

    -- table.insert(utils.todos, todo)
    table.insert(utils.todos, insert)
end

return utils
