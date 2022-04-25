local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
    error("todo-me-daddy requires nvim-telescope/telescope.nvim")
end

return telescope.register_extension({
    exports = {
        todos = require("telescope._extensions.todos"),
        your_todos = require("telescope._extensions.your_todos"),
    },
})
