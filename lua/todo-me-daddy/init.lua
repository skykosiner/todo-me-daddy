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

local M = {
    setup = methods.Setup,
}

function get_todos()
    files.fileTable = {}
    local currentDir = utils:get_current_dir()
    files:files_from_dir(currentDir)
    return utils:get_todo_comments()
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
