-- Мой дом не мой — главный серверный скрипт.
-- Поместить в ServerScriptService.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local events = ReplicatedStorage:FindFirstChild("HouseEvents") or Instance.new("Folder")
events.Name = "HouseEvents"
events.Parent = ReplicatedStorage

local messageEvent = events:FindFirstChild("Message") or Instance.new("RemoteEvent")
messageEvent.Name = "Message"
messageEvent.Parent = events

local function part(parent, name, size, cf, material)
    local p = Instance.new("Part")
    p.Name, p.Size, p.CFrame = name, size, cf
    p.Anchored = true
    p.Material = material or Enum.Material.SmoothPlastic
    p.Parent = parent
    return p
end

local world = workspace:FindFirstChild("MyHouse") or Instance.new("Folder")
world.Name = "MyHouse"
world.Parent = workspace

if not world:FindFirstChild("Floor") then
    part(world, "Floor", Vector3.new(42, 1, 32), CFrame.new(0, 0, 0), Enum.Material.Wood)
    part(world, "BackWall", Vector3.new(42, 12, 1), CFrame.new(0, 6, -16))
    part(world, "LeftWall", Vector3.new(1, 12, 32), CFrame.new(-21, 6, 0))
    part(world, "RightWall", Vector3.new(1, 12, 32), CFrame.new(21, 6, 0))
    part(world, "FrontWall", Vector3.new(42, 12, 1), CFrame.new(0, 6, 16))
    part(world, "Ceiling", Vector3.new(42, 1, 32), CFrame.new(0, 12, 0))
end

local spawn = workspace:FindFirstChildOfClass("SpawnLocation") or Instance.new("SpawnLocation")
spawn.Name = "HomeSpawn"
spawn.Size = Vector3.new(6, 1, 6)
spawn.Position = Vector3.new(0, 2, 10)
spawn.Anchored = true
spawn.Neutral = true
spawn.Parent = workspace

Lighting.ClockTime = 19
Lighting.Brightness = 1.5

local day = 1
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character:PivotTo(CFrame.new(0, 3, 8))
    end)
    messageEvent:FireClient(player, "День " .. day .. ": ты снова дома.")
end)

task.spawn(function()
    while true do
        task.wait(45)
        day += 1
        for _, player in Players:GetPlayers() do
            messageEvent:FireClient(player, "Что-то в доме изменилось...")
        end
    end
end)
