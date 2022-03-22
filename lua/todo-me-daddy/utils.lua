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

-- TODO: use this bad boy instead of the scuffed way of doing it
-- Reason I can't do this now, is beacuse it won't let me pass the table in
-- like that, and I need to return it to the table in order to have telescope
-- have it later
function utils:add_todo_to_table(file, todo, table)
    local todoComment = "%s %s"
    todo = string.format(todoComment, todo, file)
    table.insert(table, todo)
end

return utils
