local methods = require('todo-me-daddy.methods')
local settings = require('todo-me-daddy.settings')
local utils = require("todo-me-daddy.utils")
local files = require("todo-me-daddy.files")

local actions = require('telescope.actions')
local conf = require("telescope.config").values


local ignore = methods.Get("ignore_folders")

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

M.get_todo_gIthub = function()
    files.get_git_files()
end

--TODO: Add a way to jump to the file and line number, with quckfixlist
M.quick_fix_list = function()
    -- Add it to the quickfix list gurlll
    local currentDir = get_current_dir()
end

M.complete_markdown_todo = function()
    local currentLine = vim.fn.getline(".")

    if string.find(currentLine, "-%s%[ ]") then
        vim.cmd(":norm! ^ci[x")
    else
        vim.cmd(":norm! ^ci[ ")
    end
end

return M
