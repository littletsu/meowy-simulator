local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Find = require(ReplicatedStorage.Shared.Module.Find)


for ModuleScript: ModuleScript in Find(script.Controllers:GetDescendants()) do
    if not ModuleScript.Name:match("Controller$") then continue end
    Knit.CreateController(require(ModuleScript))
end

Knit.Start():andThen()