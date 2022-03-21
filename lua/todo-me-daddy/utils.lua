local utils = {}

function utils:exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

function utils:file_not_dir(name)
    if utils:exists(name .. "/") then
        return false
    else
        return true
    end
end

function utils:add_todo_to_table(file, todo, table)
    local todoComment = "%s %s"
    todo = string.format(todoComment, todo, file)
    table.insert(table, todo)
end

return utils
