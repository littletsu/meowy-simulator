local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local CounterController = Knit.CreateController { Name = "CounterController" }

function CounterController:KnitStart()
    local HUDController = Knit.GetController("HUDController")

    local DataController = Knit.GetController("DataController")
    local HUDGui = HUDController:GetHUD()
    local Counter = HUDGui.Counter
    local CounterFormat = Counter.Text
    local function UpdateCounter(meows)
        Counter.Text = CounterFormat:format(meows)
    end
    print(DataController:GetData())
    UpdateCounter(DataController:GetData().Meows)
    DataController:OnKeyChanged("Meows", UpdateCounter)
end

return CounterController