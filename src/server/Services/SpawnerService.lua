local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(Knit.Util.Promise)
local RandomArea = require(ReplicatedStorage.Shared.Module.RandomArea)
local DataService = require(script.Parent.DataService)
local SpawnerService = { Name = "SpawnerService" }

local OriginalCat =  Workspace.Prefabs.Cat
local CatClone = OriginalCat:Clone()
OriginalCat:Destroy()
local SpawnArea = Workspace.CatSpawnArea
local SpawnTime = 10

function SpawnerService:KnitStart()
    local debounce: {[Player]: boolean} = {}
    local function SpawnMeow()
        local spawnPosition = RandomArea(SpawnArea)
        local cat = CatClone:Clone()
        cat:PivotTo(CFrame.new(spawnPosition))
        cat.Parent = Workspace
        cat.PrimaryPart.Touched:Connect(function(part)
            local player = Players:GetPlayerFromCharacter(part.Parent)
            if player == nil or debounce[player] then return end
            debounce[player] = true
            task.delay(0.2, function()
                debounce[player] = nil
            end)
            cat:Destroy()
            local profile = DataService:GetProfile(player)
            profile:Set("Meows", profile.Data.Meows + 1)
            SpawnMeow()
        end)
        Promise.delay(SpawnTime, SpawnMeow):catch(warn)
    end

    SpawnMeow()
end

return SpawnerService