local files = {}

function files.find_files()
  return vim.fn.systemlist("find .")
end

return files
