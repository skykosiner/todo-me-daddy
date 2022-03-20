Yes, yes, I'm aware that this is a stupid name, but will you shut up man

## What is todo-me-daddy?
The whole idea of this plugin is that we as developers leave hundreds, and
hundreds of TODO comments in our code, and there is no way to find them, other
then grepping them.

Well this plugin makes the finding of to-do's easy.

What this plugin does is a few different options:
1. Output every to-do found to a quickfix list
2. Output every to-do found to telescope

**Right now the plugin only outputs to telescope, but from there you can output to a quickfix list**


## Current bugs
* If your code has the word TODO and it is not a comment the plugin will still find it
* Does not work all to well with git worktree's at moment, if you're using [theprimeagens]() plugin to hop between worktrees

## Warninng
This is my first ever neovim plugin, and I code this in under 2 hours. So this may be a little rough around the edges

## Setup

Add this to your `init.vim` or whatever package manger you use

```vim
Plug 'yonikosiner/todo-me-daddy'
```

In your `telescope.lua` add this:
```lua
local function todo(prompt_bufnr)
    local content = require("telescope.actions.state").get_selected_entry(
        prompt_bufnr
    )

    require("telescope.actions").close(prompt_bufnr)
    require("todo-me-daddy").jump_to_todo(content.value)
end

M.todo = function()
    require("telescope.pickers").new({}, {
        prompt_title = "TODO's",
        finder = require("telescope.finders").new_table({
            results = require("todo-me-daddy").main(),
        }),
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(_, map)
            map("i", "<CR>", todo)
            map("n", "<CR>", todo)
            return true
        end,
    }):find()
end
```
then where you define your keybinds for telescope add this:
```vim
nnoremap <leader>td :lua require('your lua name here.telescope').todo()<CR>
```

now you should be able to call all your todos search them, and then go into them
