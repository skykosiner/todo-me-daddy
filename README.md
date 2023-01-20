# Idea behind this plugin
I wanted a way to quickly find all the little todo-comments around your code
and have them put into telescope. This plugin allows you to quickly to do that.

# Setup
## Install
### Packer
```lua
use {
    "skykosiner/todo-me-daddy",
    requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
    }
}
```
### Plug
```vim
Plug "skykosiner/todo-me-daddy"
" This plugin requires these two plugins
Plug "nvim-lua/plenary.nvim"
Plug "nvim-telescope/telescope.nvim"
```
## Telescope config
```lua
require("telescope").load_extension("todo_me_daddy")
```
## todo_me_daddy.lua
```lua
-- Find all files
vim.keymap.set("n", "<leader>td", ":lua require('telescope').extensions.todo_me_daddy.todos()<CR>")

-- Find the files in git
vim.keymap.set("n", "<leader>tg", ":lua require('telescope').extensions.todo_me_daddy.git_todos()<CR>")
```
