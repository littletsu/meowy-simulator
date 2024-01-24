local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local HUDController = Knit.CreateController { Name = "HUDController" }

local UI

function HUDController:GetHUD()
    return UI
end

function HUDController:KnitInit()
    UI = Knit.Player.PlayerGui:WaitForChild("HUD", 60)
end

return HUDController