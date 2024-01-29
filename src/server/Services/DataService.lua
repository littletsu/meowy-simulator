local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local ProfileService = require(script.Parent.Parent.Vendors.ProfileService)
local Promise = require(Knit.Util.Promise)
local Callbacks = require(ReplicatedStorage.Shared.Module.Callbacks)
local DataShared = require(ReplicatedStorage.Shared.Data.DataShared)

local ProfileVersion = 1

local DataService = {
    Name = "DataService",
    Client = {
        KeyChanged = Knit.CreateSignal()
    }
}

type ProfileWrapper = {
    OnKeyChanged: (self: Profile, key: string, callback: DataShared.OnKeyChangedCallback) -> (() -> ()),
    Set: (self: Profile, key: string, new: any) -> (),
    Data: DataShared.ProfileTemplate,
    Profile: Profile
}

type Profile = ProfileService.Profile

local Profiles: {[Player]: ProfileWrapper} = {}

function DataService:KnitInit()
    local ProfileStore = ProfileService.GetProfileStore("PlayerData", DataShared.ProfileTemplate)
    local function PlayerAdded(player)
        local profile: Profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId .. ProfileVersion)
        if profile == nil then return player:Kick("Cannot load profile") end
        profile:AddUserId(player.UserId)
        profile:Reconcile()
        profile:ListenToRelease(function()
            Profiles[player] = nil
            player:Kick("Profile released")
        end)
        if not player:IsDescendantOf(Players) then return profile:Release() end
        local callbacks = {}
        local wrapper = {}
        local data = profile.Data

        function wrapper:OnKeyChanged(key, callback)
            if callbacks[key] == nil then
                callbacks[key] = {}
            end
            return Callbacks.insertCallback(callbacks[key], callback)
        end
        function wrapper:Set(key, new)
            data[key] = new
            if DataShared.DefaultTemplate[key].Replicated then
                DataService.Client.KeyChanged:Fire(player, key, new)
            end
            if callbacks[key] == nil then return end
            Callbacks.callCallbacks(callbacks[key]):await()
        end

        wrapper.Data = data
        wrapper.Profile = profile

        Profiles[player] = wrapper
    end
    for _,player in Players:GetPlayers() do
        Promise.try(PlayerAdded, player):catch(warn)
    end
    Players.PlayerAdded:Connect(PlayerAdded)
    Players.PlayerRemoving:Connect(function(player)
        local profile = Profiles[player]
        if profile == nil then return end
        profile.Profile:Release()
    end)
end

function DataService:GetProfile(player: Player): ProfileWrapper | nil
    return Profiles[player]
end

function DataService:GetData(player: Player): DataShared.ProfileTemplate | nil
    local profile = DataService:GetProfile(player)
    if profile == nil then
        warn(`no profile for player {player.Name}!`)
        return nil
    end
    return profile.Data
end

function DataService.Client:GetData(player: Player)
    return self.Server:GetData(player)
end

function DataService:OnKeyChanged(player: Player, key: string, callback: DataShared.OnKeyChangedCallback)
    local profile = DataService:GetProfile(player)
    if profile == nil then
        warn(`no profile for player {player.Name}!`)
        return nil
    end
    return profile:OnKeyChanged(key, callback)
end

return DataService