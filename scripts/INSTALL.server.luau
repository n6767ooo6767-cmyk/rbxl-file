-- МОЙ ДОМ НЕ МОЙ — ГОТОВАЯ СБОРКА
-- Поместите этот Script в ServerScriptService.
-- Скрипт сам создаёт карту, свет, мебель, двери, события и игровой цикл.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local events = ReplicatedStorage:FindFirstChild("HouseEvents") or Instance.new("Folder")
events.Name = "HouseEvents"
events.Parent = ReplicatedStorage
local message = events:FindFirstChild("Message") or Instance.new("RemoteEvent")
message.Name = "Message"
message.Parent = events

local old = workspace:FindFirstChild("MY_HOUSE_GAME")
if old then old:Destroy() end
local world = Instance.new("Folder")
world.Name = "MY_HOUSE_GAME"
world.Parent = workspace

local function part(name, size, pos, material, parent)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Position = pos
    p.Anchored = true
    p.Material = material or Enum.Material.SmoothPlastic
    p.Parent = parent or world
    return p
end

-- Дом
part("Floor", Vector3.new(42,1,32), Vector3.new(0,0,0), Enum.Material.Wood)
part("BackWall", Vector3.new(42,12,1), Vector3.new(0,6,-16))
part("LeftWall", Vector3.new(1,12,32), Vector3.new(-21,6,0))
part("RightWall", Vector3.new(1,12,32), Vector3.new(21,6,0))
part("FrontWall", Vector3.new(42,12,1), Vector3.new(0,6,16))
part("Ceiling", Vector3.new(42,1,32), Vector3.new(0,12,0))

-- Мебель
part("Table", Vector3.new(7,1,3), Vector3.new(-7,3,1), Enum.Material.Wood)
for i,x in ipairs({-9.5,-4.5}) do part("TableLeg"..i, Vector3.new(.5,3,.5), Vector3.new(x,1.5,0), Enum.Material.Wood) end
part("Bed", Vector3.new(8,1.5,5), Vector3.new(9,1.75,-8), Enum.Material.Fabric)
part("BedHead", Vector3.new(8,4,.7), Vector3.new(9,3,-10.1), Enum.Material.Wood)
part("Sofa", Vector3.new(8,2.2,3), Vector3.new(7,2.1,5), Enum.Material.Fabric)
part("TV", Vector3.new(7,4,.4), Vector3.new(0,5,-15.3), Enum.Material.SmoothPlastic)

-- Дверь с ProximityPrompt
local door = part("FrontDoor", Vector3.new(5,9,.7), Vector3.new(0,4.5,15.4), Enum.Material.Wood)
local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Открыть"
prompt.ObjectText = "Дверь"
prompt.HoldDuration = .25
prompt.MaxActivationDistance = 10
prompt.Parent = door
local open = false
prompt.Triggered:Connect(function()
    open = not open
    door.CanCollide = not open
    door.Transparency = open and .65 or 0
    prompt.ActionText = open and "Закрыть" or "Открыть"
end)

-- Спавн
local spawn = Instance.new("SpawnLocation")
spawn.Name = "HomeSpawn"
spawn.Size = Vector3.new(5,1,5)
spawn.Position = Vector3.new(0,2,9)
spawn.Anchored = true
spawn.Neutral = true
spawn.Parent = world

Lighting.ClockTime = 19.5
Lighting.Brightness = 1.4
Lighting.FogEnd = 180

local rng = Random.new()
local day = 1

local function say(text)
    for _,player in Players:GetPlayers() do message:FireClient(player,text) end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(.1)
        character:PivotTo(CFrame.new(0,3,8))
    end)
    task.delay(2,function()
        if player.Parent then message:FireClient(player,"День "..day.." — ты снова дома.") end
    end)
end)

-- Основной цикл странностей
while true do
    task.wait(rng:NextInteger(18,32))
    local choice = rng:NextInteger(1,4)

    if choice == 1 then
        say("...ты слышал это?")
        local oldBrightness = Lighting.Brightness
        for _=1,8 do
            Lighting.Brightness = rng:NextNumber(.1,1.6)
            task.wait(.12)
        end
        Lighting.Brightness = oldBrightness

    elseif choice == 2 then
        say("Кажется, стол был в другом месте.")
        local tablePart = world:FindFirstChild("Table")
        if tablePart then tablePart.Position += Vector3.new(rng:NextNumber(-2,2),0,rng:NextNumber(-2,2)) end

    elseif choice == 3 then
        say("Почему дверь была открыта?")
        open = true
        door.CanCollide = false
        door.Transparency = .65
        prompt.ActionText = "Закрыть"

    else
        day += 1
        say("День "..day..". Дом стал немного другим.")
        Lighting.ClockTime = rng:NextNumber(18,23)
    end
end
