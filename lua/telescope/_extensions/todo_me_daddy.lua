local _, telescope = pcall(require, "telescope")

return telescope.register_extension({
  exports = {
    todos = require("telescope._extensions.todos"),
  },
})
