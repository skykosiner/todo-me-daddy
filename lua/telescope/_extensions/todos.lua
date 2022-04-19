local utils         = require "todo-me-daddy.utils"
local preview       = require("telescope.previewers")
local files         = require("todo-me-daddy.files")
local conf          = require("telescope.config").values
local finders       = require("telescope.finders")
local entry_display = require("telescope.pickers.entry_display")

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

local generate_new_finder = function(todos)
    return finders.new_table({
        entry_maker = function()
            local line = todos.filename .. ":" .. todos.row .. ":" .. todos.col
            local displayer = entry_display.create({
                separator = " - ",
                items = {
                    { width = 2 },
                    { width = 50 },
                    { remaining = true },
                },
            })
            local make_display = function(entry)
                return displayer({
                    tostring(entry.index),
                    line,
                })
            end
            local line = todos.filename .. ":" .. todos.row .. ":" .. todos.col
            return {
                value = todos,
                ordinal = line,
                display = make_display,
                lnum = todos.row,
                col = todos.col,
                filename = todos.filename,
            }
        end,
    })
end

-- TODO: add a thing to get the preview of the to do file
-- local function TodoPreview(opts)
-- end

return function(opts)
    opts = opts or {}

    require("telescope.pickers").new(opts, {
        prompt_title = "Todo's",
        previewer = require("telescope.previewers").cat.new(opts),
        finder = generate_new_finder(utils:get_todos()),
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(_, map)
            map("i", "<CR>", navigate_to_todo)
            map("n", "<CR>", navigate_to_todo)
            return true
        end,
    }):find()
end
