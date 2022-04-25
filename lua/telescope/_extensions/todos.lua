local methods    = require("todo-me-daddy.methods")
local utils      = require "todo-me-daddy.utils"
local preview    = require("telescope.previewers")
local files      = require("todo-me-daddy.files")
local conf       = require("telescope.config").values
local previewers = require('telescope.previewers')

return function(opts)
    if methods.Get("ignore_folders") == nil or utils:Count(methods.Get("ignore_folders")) == 0 then
        error("Please make sure that you have at least one folder to be ignored in your config see the README for help (https://github.com/yonikosiner/todo-me-daddy/blob/master/README.md)")
    end

    opts = opts or {}

    require("telescope.pickers").new(opts, {
        prompt_title = "Todo's",
        finder = utils:get_todos(false),
        previewer = conf.grep_previewer(opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(_, map)
            return true
        end,
    }):find()
end
