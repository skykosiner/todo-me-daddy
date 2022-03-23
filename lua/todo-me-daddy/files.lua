local files = {}

function files:get_git_files(dir)
    local files = os.execute("cd %s && git ls-files --exclude-standard --cached", dir)
    print(files)
end

return files
