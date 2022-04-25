local function info(filetype)
    if filetype == "c" or filetype == "js" or filetype == "ts" or filetype == "go" then
        return "//"
    elseif filetype == "sh" or filetype == "py" then
        return "#"
    elseif filetype == "lua" then
        return "--"
    elseif filetype == "md" then
        return "-%s%[ ]"
    else
        return "//"
    end
end

return info
