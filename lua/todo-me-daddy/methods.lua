local settings = require('todo-me-daddy.settings')
-- local files = require('todo-me-daddy.files')
local methods = {}

function methods.Setup(update)
    -- files.fileTable = {}
    settings = setmetatable(update, { __index = settings })
end

function methods.Get(key)
    return settings[key]
end

return methods
