local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local pickers = require("telescope.pickers")
local utils = require("todo-me-daddy.utils")

local function filter_empty_string(list)
    local next = {}
    for idx = 1, #list do
        if list[idx].filename ~= "" then
            table.insert(next, list[idx])
        end
    end

    return next
end


local generate_new_finder = function()
    return finders.new_table({
        results = filter_empty_string(utils.get_todos()),
        entry_maker = function(entry)
            print(entry
            for k,v in pairs(entry) do
                print(v)
            end
            local line = entry.file .. ":" .. entry.line .. "-" .. entry.value
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
            local line = entry.filename .. ":" .. entry.row .. ":" .. entry.col
            return {
                value = entry,
                ordinal = line,
                display = make_display,
                lnum = entry.row,
                col = entry.col,
                filename = entry.filename,
            }
        end,
    })
end

return function(opts)
    opts = opts or {}

    pickers.new(opts, {
        prompt_title = "harpoon marks",
        finder = generate_new_finder(),
        sorter = conf.generic_sorter(opts),
        previewer = conf.grep_previewer(opts),
        attach_mappings = function(_, map)
            return true
        end,
    }):find()
end
