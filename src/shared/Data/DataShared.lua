local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Default = require(ReplicatedStorage.Shared.Data.Default)
local DataShared = {}

export type ProfileTemplate = {
    Meows: number
}

DataShared.DefaultTemplate = {
    Meows = Default(0)
}

export type OnKeyChangedCallback = (newValue: any) -> ()

DataShared.ProfileTemplate = {} :: ProfileTemplate

for k,v in DataShared.DefaultTemplate do
    DataShared.ProfileTemplate[k] = v.Value
end

return DataShared