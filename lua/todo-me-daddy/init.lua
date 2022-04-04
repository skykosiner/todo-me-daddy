local methods = require('todo-me-daddy.methods')
local settings = require('todo-me-daddy.settings')
local utils = require("todo-me-daddy.utils")
local files = require("todo-me-daddy.files")

local actions = require('telescope.actions')
local conf = require("telescope.config").values

local has_telescope = pcall(require, "telescope")

if not has_telescope then
    error("This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)")
end

local M = {
    setup = methods.Setup,
}

--TODO: Add a way to jump to the file and line number, with quckfixlist

M.complete_markdown_todo = function()
    local currentLine = vim.fn.getline(".")

    if string.find(currentLine, "-%s%[ ]") then
        vim.cmd(":norm! ^ci[x")
    else
        vim.cmd(":norm! ^ci[ ")
    end
end

return M
