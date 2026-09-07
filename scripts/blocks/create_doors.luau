-- Создаёт интерактивную дверь.
-- Поместите Script в ServerScriptService после создания дома.

local Workspace = game:GetService("Workspace")
local house = Workspace:WaitForChild("GeneratedHouse")

local door = Instance.new("Part")
door.Name = "MainDoor"
door.Size = Vector3.new(3, 7, 0.5)
door.Position = Vector3.new(0, 3.5, -11.4)
door.Anchored = true
door.Parent = house

local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Открыть"
prompt.ObjectText = "Дверь"
prompt.HoldDuration = 0.4
prompt.MaxActivationDistance = 10
prompt.Parent = door

local closedCFrame = door.CFrame
local openCFrame = closedCFrame * CFrame.Angles(0, math.rad(-90), 0)
local opened = false

prompt.Triggered:Connect(function()
    opened = not opened
    door.CFrame = opened and openCFrame or closedCFrame
    prompt.ActionText = opened and "Закрыть" or "Открыть"
end)
