yes, yes, I'm aware that this is a stupid name, but will you shut up man

## What is todo-me-daddy?
The whole idea of this plugin is that we as developers leave hundreds, and
hundreds of TODO comments in our code, and there is no way to find them, other
then grepping them.

Well this plugin makes the finding of to-do's easy.

What this plugin does is a few different options:
1. Output every to-do found to a quickfix list
2. Output every to-do found to telescope

**Right now the plugin only outputs to telescope**


## Current bugs

## Warninng
This is my first ever neovim plugin, and I code this in under 2 hours. So this may be a little rough around the edges

## Setup

Add this to your `init.vim` (change it depending on what package manger you use)

```vim
Plug 'yonikosiner/todo-me-daddy'
```

Then where you set your remaps add this
`nnoremap <leader>td :lua require('todo-me-daddy').telescope_it()<CR>`
