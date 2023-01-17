local preview    = require("telescope.previewers")
local conf       = require("telescope.config").values
local previewers = require('telescope.previewers')

return function(opts)
  opts = opts or {}

  require("telescope.pickers").new(opts, {
    prompt_title = "Todo's",
    finder = require("todo-me-daddy").read_lines(),
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(_, map)
      return true
    end,
  }):find()
end
