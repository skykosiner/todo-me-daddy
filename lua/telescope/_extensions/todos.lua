local utils      = require "todo-me-daddy.utils"
local preview    = require("telescope.previewers")
local files      = require("todo-me-daddy.files")
local conf       = require("telescope.config").values
local previewers = require('telescope.previewers')


local homeDir = os.getenv("HOME")


local function navigate_to_todo(prompt_bufnr)
    local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
    require("telescope.actions").close(prompt_bufnr)

    local lineNum = string.match(content.value, "%d+")
    local path = string.sub(content.value, string.find(content.value, homeDir) + 1)
    path = "/" .. path

    -- TODO: maybe implent the fancy vim.api.nvim_win_set_cursor(), but for now this works
    vim.cmd("e " .. path)
    vim.cmd(":" .. lineNum)

end

-- TODO: add a thing to get the preview of the to do file

return function(opts)
    print(vim.inspect(utils:get_todos()))
    require("telescope.pickers").new(opts, {
        prompt_title = "Todo's",
        finder = utils:get_todos(),
        -- previewer = require("telescope.config").values.grep_previewer,
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(_, map)
            map("i", "<CR>", navigate_to_todo)
            map("n", "<CR>", navigate_to_todo)
            return true
        end,
    }):find()
end
