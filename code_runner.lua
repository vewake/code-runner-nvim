-- ~/.config/nvim/lua/code_runner.lua

local Terminal = require("toggleterm.terminal").Terminal

-- Function to determine the run command based on file type
local function get_run_command()
  local filetype = vim.bo.filetype
  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r")
  local cmd = ""

  if filetype == "cpp" then
    cmd = string.format("g++ %s -o %s && ./%s", file, output, output)
  elseif filetype == "c" then
    cmd = string.format("gcc %s -o %s && ./%s", file, output, output)
  elseif filetype == "python" then
    cmd = string.format("python3 %s", file)
  elseif filetype == "javascript" then
    cmd = string.format("node %s", file)
  elseif filetype == "go" then
    cmd = string.format("go run %s", file)
  else
    print("No run command configured for filetype " .. filetype)
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
      direction = "horizontal",
    })
    term:toggle()
  end
end

-- Set keybinding to run code
vim.api.nvim_set_keymap(
  "n",
  "<leader>r",
  ':lua require("code_runner").run_code()<CR>',
  { noremap = true, silent = true }
)

return {
  run_code = run_code,
}
