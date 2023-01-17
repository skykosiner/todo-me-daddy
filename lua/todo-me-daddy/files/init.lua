local files = {}

function files.find_files()
  return vim.fn.systemlist("find .")
end

function files.git_find_files()
  return vim.fn.systemlist("git ls-files")
end

return files
