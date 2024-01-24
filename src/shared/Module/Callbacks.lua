local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(Knit.Util.Promise)
local module = {}

function module.callCallbacks(list: {(...any) -> any}, ...)
    local promises = {}
    local args = {...}
    for _,callback in list do
        if callback == nil then continue end
        table.insert(promises, Promise.new(function(resolve)
            resolve(callback(table.unpack(args)))
        end))
    end
    return Promise.all(promises)
end

function module.insertCallback(list, callback): () -> ()
    table.insert(list, callback)
    local pos = #list
    return function()
        if list[pos] ~= callback then return end
        list[pos] = nil
    end
end

function module.setCallback(t, key, callback)
    t[key] = callback
    return function()
        if t[key] ~= callback then return end
        t[key] = nil
    end
end

return module