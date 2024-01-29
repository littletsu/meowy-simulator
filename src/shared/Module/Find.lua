return function (children: {Instance}|Instance, class: string)
    if typeof(children) == "Instance" then
        children = children:GetChildren()
    end
    local i = 0
    local n = #children
    local iterator
    iterator = function ()
        i = i + 1
        if i <= n then
            local element = children[i]
            if (element ~= nil) and (not element:IsA(class)) then return iterator() end
            return element, i
        end
    end 
    return iterator
end