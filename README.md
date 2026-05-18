# packview.nvim
Just another minimal UI for vim.pack with some conveniences, because I can and want to.

<img width="1539" height="842" alt="Preview" src="https://github.com/user-attachments/assets/f287ad52-b6d2-4e15-a566-59a5019ac7f0" />

Main features:
- Floating window with list of installed plugins
- Keymaps to update all, update selected, delete selected or delete all inactive plugins
- `:Pack`, `:PackUpdate` and `:PackDel` commands (see below for details)

## Requirements
- Neovim 0.12+

## Installation
### vim.pack
```lua
vim.pack.add({ "https://github.com/Roddyck/packview.nvim" })

require("packview").setup() -- required only if you want to pass custom options
```

<details>
<summary>Click here to see the default config</summary>

```lua
{
  window = {
    width = 0.8, -- Percentage of screen width for floating window as a fraction of total width
    height = 0.8, -- Percentage of screen height for floating window as a fraction of total height
    border = "rounded", -- Border style for floating window (same as passed to |nvim_open_win()|)
    title = "Packview", -- Title for floating window
    title_pos = "center", -- Position of title for floating window (same as passed to |nvim_open_win()|)
  },
}
```
</details>


## Usage

To open the plugin list window, run `:Pack` command or use api function directly:
```lua
require("packview").open()
```

### Keymaps inside the plugin list window
- Press `q` to close the window
- Press `u` to update plugin on the current line
- Press `U` to update all plugins
- Press `d` to delete plugin on the current line
- Press `X` to delete all inactive plugins

### Commands
| Command | Description |
| --- | --- |
| `:Pack` | Opens the plugin list window |
| `:PackUpdate` | Updates all plugins |
| `:PackUpdate <plugin1> <plugin2> ...` | Updates plugins passed as arguments |
| `:PackDel` | Deletes all inactive plugins |
| `:PackDel <plugin1> <plugin2> ...` | Deletes plugins passed as arguments |
