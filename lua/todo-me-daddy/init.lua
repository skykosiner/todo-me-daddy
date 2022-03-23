local actions = require('telescope.actions')
local methods = require('todo-me-daddy.methods')
local settings = require('todo-me-daddy.settings')
local utils = require("todo-me-daddy.utils")
local files = require("todo-me-daddy.files")

local homeDir = os.getenv("HOME")
local fileTable = {}
local ignore = methods.Get("ignore_folders")
-- Print the type of ignore

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

function files_from_dir(dir)
    -- Find each file in the current dir, sorry windows users this only works on posix complaint shells (fuck you windows)
    local files = os.capture("find " .. dir)

    -- Get each item, split by new line, and insert it into the table fileTable
    local s = " "
    for f in string.gmatch(files, "([^" .. s .. "]+)") do
        -- Get each file from the ignore list, you can find info on this in the
        -- README (by default the progarm ignores node_modules, and right now
        -- if you change that 0 to do's wil be found)

        for k,v in pairs(methods.Get('ignore_folders')) do
            if string.find(f, v) then
                break
            else
                table.insert(fileTable, f)
            end
        end
        -- error("Go back and read the readme, smh. Hint it is the ignore_folders option")
    end
end

function lines_from(file)
    local lines = {}
    -- Read each file and split by new line, and insert it into the table fileTable (include line numbers)
    for line in io.lines(file) do
        local lineNum = #lines + 1
        table.insert(lines, lineNum .. line)
    end
    return lines
end

local M = {
    setup = methods.Setup,
}

function get_todo_comments()
    -- Each time we run this, we need to clear the table
    -- This is because we are running this function multiple times
    -- and we don't want to add the same comments multiple times
    local todos = {}

    for k,v in pairs(fileTable) do
        local file = v
        -- Make sure that the file is not a dir
        if utils:file_not_dir(file) then
            local lines = lines_from(file)
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

function get_current_dir()
    return vim.fn.getcwd()
end

function get_todos()
    fileTable = {}
    local currentDir = get_current_dir()
    files_from_dir(currentDir)
    return get_todo_comments()
end

M.get_todo_github = function()
    files.get_git_files()
end

M.jump_to_todo = function(todo)
    local lineNum = string.match(todo, "%d+")
    todo = string.sub(todo, string.find(todo, homeDir) + 1)
    todo = "/" .. todo
    vim.cmd("e " .. todo)
    vim.cmd(":" .. lineNum)
end

--TODO: Add a way to jump to the file and line number, with quckfixlist
M.quick_fix_list = function()
    -- Add it to the quickfix list gurlll
    local currentDir = get_current_dir()
end

local function todo(prompt_bufnr)
    local content = require("telescope.actions.state").get_selected_entry(
        prompt_bufnr
    )

    require("telescope.actions").close(prompt_bufnr)
    require("todo-me-daddy").jump_to_todo(content.value)
end

M.find_todos = function()
    require("telescope.pickers").new({}, {
        prompt_title = "TODO's",
        finder = require("telescope.finders").new_table({
            results = get_todos(),
        }),
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(_, map)
            map("i", "<CR>", todo)
            map("n", "<CR>", todo)
            return true
        end,
    }):find()
end

M.complete_markdown_todo = function()
    local currentLine = vim.fn.getline(".")

    if string.find(currentLine, "-%s%[ ]") then
        vim.cmd(":norm! ^ci[x")
    else
        vim.cmd(":norm! ^ci[ ")
    end
end

M.test = function()
    print(methods.Get("get_markdown_todo"))
end

return M
