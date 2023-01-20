-- Make sure the user has at least nvim version 7 installed on there system
if 1 ~= vim.fn.has("nvim-0.7.0") then
  vim.api.nvim_err_writeln("Wiki.nvim requires at least nvim-0.7.0")
  return
end

-- Make sure the user has telescope
local hasTelescope = pcall(require, "telescope")

if not hasTelescope then
  vim.api.nvim_err_writeln("Wiki.nvim requires telescope.nvim")
  return
end

-- Make sure the user has plenary
local hasPlenary = pcall(require, "plenary")

if not hasPlenary then
  vim.api.nvim_err_writeln("Wiki.nvim requires plenary.nvim")
  return
end
