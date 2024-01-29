local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local SprintController = { Name = "SprintController" }

function SprintController:KnitStart()
    local Humanoid = Knit.Player.Character.Humanoid
    local DefaultWalkSpeed = Humanoid.WalkSpeed
    local SprintWalkSpeed = DefaultWalkSpeed + 10
    ContextActionService:BindAction("Sprint", function(_,inputState)
        Humanoid.WalkSpeed = if inputState == Enum.UserInputState.Begin then SprintWalkSpeed else DefaultWalkSpeed
    end, true, Enum.KeyCode.LeftShift)
end

return SprintController