# Code Runner for Neovim

This Neovim configuration allows you to compile and run code for multiple programming languages directly within Neovim using `nvim-toggleterm.lua`. Supported languages include C++, C, Python, JavaScript, and Go.

## Features

- Compile and run C and C++ files
- Run Python scripts
- Execute JavaScript files using Node.js
- Run Go programs
- Easily extensible to support more languages

## Prerequisites

- Neovim (version 0.5 or later)
- `nvim-toggleterm.lua`
- `nvim-lua/plenary.nvim` (required by `nvim-toggleterm.lua`)

## Installation

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

Add the following lines to your `init.lua` or `plugins.lua` file:

```lua
use {
  'akinsho/nvim-toggleterm.lua',
  requires = { {'nvim-lua/plenary.nvim'} },
  config = function()
    require('toggleterm').setup{
      size = 20,
      open_mapping = [[<c-\>]],
      shading_factor = 2,
      direction = 'horizontal',
      close_on_exit = true,
      shell = vim.o.shell
    }
  end
}
```
## Configuration
### 1.Create the `code_runner.lua` script:
Save the following content in ~/.config/nvim/lua/code_runner.lua:
```lua
local Terminal = require('toggleterm.terminal').Terminal
-- Function to determine the run command based on file type
local function get_run_command()
  local filetype = vim.bo.filetype
  local file = vim.fn.expand('%')
  local output = vim.fn.expand('%:r')
  local cmd = ''

  if filetype == 'cpp' then
    cmd = string.format('g++ %s -o %s && ./%s', file, output, output)
  elseif filetype == 'c' then
    cmd = string.format('gcc %s -o %s && ./%s', file, output, output)
  elseif filetype == 'python' then
    cmd = string.format('python3 %s', file)
  elseif filetype == 'javascript' then
    cmd = string.format('node %s', file)
  elseif filetype == 'go' then
    cmd = string.format('go run %s', file)
  else
    print('No run command configured for filetype ' .. filetype)
    return nil
  end

  return cmd
end

-- Function to run the command in a terminal
local function run_code()
  local cmd = get_run_command()
  if cmd then
    local term = Terminal:new({
      cmd = cmd,
      close_on_exit = false,
      direction = 'horizontal'
    })
    term:toggle()
  end
end

-- Set keybinding to run code
vim.api.nvim_set_keymap('n', '<leader>r', ':lua require("code_runner").run_code()<CR>', {noremap = true, silent = true})

return {
  run_code = run_code
}

```
2.**Load the script in your Neovim configuration:**

Add the following line to your `init.lua` or another Neovim configuration file to load the script:
```lua
-- ~/.config/nvim/init.lua or another config file

-- Load code_runner.lua
require('code_runner')

```
Usage

    Open a file in Neovim.
    Press <leader>r to compile and run the file based on its file type.

Supported Languages

    C++: Compiles and runs using g++.
    C: Compiles and runs using gcc.
    Python: Runs using python3.
    JavaScript: Runs using node.
    Go: Runs using go run.

Adding Support for More Languages

To add support for more languages, extend the get_run_command function in the code_runner.lua script with the appropriate commands for those languages.
