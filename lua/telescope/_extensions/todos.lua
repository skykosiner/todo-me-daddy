local utils      = require "todo-me-daddy.utils"
local preview    = require("telescope.previewers")
local files      = require("todo-me-daddy.files")
local conf       = require("telescope.config").values
local previewers = require('telescope.previewers')

return function(opts)
    opts = opts or {}

    -- print("inspect from telescope call", vim.inspect(utils:get_todos()))
    require("telescope.pickers").new(opts, {
        prompt_title = "Todo's",
        finder = utils:get_todos(),
        previewer = conf.grep_previewer(opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(_, map)
            -- map("i", "<CR>", navigate_to_todo)
            -- map("n", "<CR>", navigate_to_todo)
            return true
        end,
    }):find()
end
