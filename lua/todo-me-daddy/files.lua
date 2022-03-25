local methods = require('todo-me-daddy.methods')

local files = {
    fileTable = {},
}

function files:files_from_dir(dir)
    -- Find each file in the current dir, sorry windows users this only works on posix complaint shells (fuck you windows)
    local filesFound = os.capture("find " .. dir)

    -- Get each item, split by new line, and insert it into the table fileTable
    local s = " "
    for f in string.gmatch(filesFound, "([^" .. s .. "]+)") do
        -- Get each file from the ignore list, you can find info on this in the
        -- README (by default the progarm ignores node_modules, and right now
        -- if you change that 0 to do's wil be found)

        for k,v in pairs(methods.Get('ignore_folders')) do
            if string.find(f, v) then
                break
            else
                table.insert(files.fileTable, f)
            end
        end
        -- error("Go back and read the readme, smh. Hint it is the ignore_folders option")
    end
end

function files:get_line_from_file(file)
    local lines = {}
    -- Read each file and split by new line, and insert it into the table fileTable (include line numbers)
    for line in io.lines(file) do
        local lineNum = #lines + 1
        table.insert(lines, lineNum .. line)
    end
    return lines
end

function files:get_git_files(dir)
    local files = os.execute("cd %s && git ls-files --exclude-standard --cached", dir)
    print(files)
end

return files
