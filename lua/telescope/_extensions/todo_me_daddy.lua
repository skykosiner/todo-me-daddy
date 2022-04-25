local _, telescope = pcall(require, "telescope")

return telescope.register_extension({
    exports = {
        todos = require("telescope._extensions.todos"),
        your_todos = require("telescope._extensions.your_todos"),
    },
})
