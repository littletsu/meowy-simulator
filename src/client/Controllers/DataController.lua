local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Callbacks = require(ReplicatedStorage.Shared.Module.Callbacks)
local DataShared = require(ReplicatedStorage.Shared.Data.DataShared)
local Signal = require(ReplicatedStorage.Packages.Signal)

local DataController = Knit.CreateController { Name = "DataController" }
local DataService
local callbacks = {}
local localData = {}
local StartSignal = Signal.new()
local Started = false

-- Waits for the DataController to KnitStart
local function CheckStart()
    if not Started and StartSignal then
        StartSignal:Wait()
    end
end

function DataController:KnitStart()
    DataService = Knit.GetService("DataService")
    localData = select(2, DataService:GetData():await())
    DataService.KeyChanged:Connect(function(k: string, v: any)
        localData[k] = v
        local changeCallbacks = callbacks[k]
        if changeCallbacks == nil then return end
        Callbacks.callCallbacks(changeCallbacks, v)
    end)
    Started = true
    StartSignal:Fire()
    StartSignal = nil
end

function DataController:OnKeyChanged(key: string, callback: DataShared.OnKeyChangedCallback)
    if callbacks[key] == nil then
        callbacks[key] = {}
    end
    return Callbacks.insertCallback(callbacks[key], callback)
end

function DataController:GetData(): DataShared.ProfileTemplate
    CheckStart()
    return localData
end

return DataController