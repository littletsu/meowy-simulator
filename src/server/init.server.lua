local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Find = require(ReplicatedStorage.Shared.Module.Find)

for ModuleScript: ModuleScript in Find(script.Services:GetDescendants()) do
    if not ModuleScript.Name:match("Service$") then continue end
    Knit.CreateService(require(ModuleScript))
end

Knit.Start():catch(warn)