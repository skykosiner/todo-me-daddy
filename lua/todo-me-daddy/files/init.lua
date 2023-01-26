local Job = require "plenary.job"

local files = {}

local function is_git_dir()
  local j = Job:new({
    command = "git",
    args = { "rev-parse", "--is-inside-work-tree" },
    cwd = vim.fn.getcwd()
  })

  local ok, result = pcall(function()
    return vim.trim(j:sync()[1])
  end)

  if ok then
    return true
  else
    return false
  end
end

function files.find_files()
  return vim.fn.systemlist("find . | grep -v 'node_modules' | grep -v '.git'")
end

function files.git_find_files()
  if is_git_dir() then
    return vim.fn.systemlist("git ls-files")
  else
    error("Current dir is not a git dir")
  end
end

return files
