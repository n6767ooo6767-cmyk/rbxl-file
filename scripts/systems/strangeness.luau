-- Система странностей. Поместить в ServerScriptService.

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local message = ReplicatedStorage:WaitForChild("HouseEvents"):WaitForChild("Message")
local rng = Random.new()

local function broadcast(text)
    for _, player in game:GetService("Players"):GetPlayers() do
        message:FireClient(player, text)
    end
end

local function flicker()
    local old = Lighting.Brightness
    for _ = 1, 7 do
        Lighting.Brightness = rng:NextNumber(0.15, 1.7)
        task.wait(rng:NextNumber(0.08, 0.22))
    end
    Lighting.Brightness = old
end

local function moveFurniture()
    local house = workspace:FindFirstChild("MyHouse")
    if not house then return end
    local candidates = {}
    for _, obj in house:GetDescendants() do
        if obj:IsA("BasePart") and obj.Name ~= "Floor" and obj.Name ~= "Ceiling" then
            table.insert(candidates, obj)
        end
    end
    if #candidates > 0 then
        local target = candidates[rng:NextInteger(1, #candidates)]
        target.CFrame *= CFrame.new(rng:NextNumber(-1, 1), 0, rng:NextNumber(-1, 1))
    end
end

while true do
    task.wait(rng:NextInteger(20, 40))
    local event = rng:NextInteger(1, 3)
    if event == 1 then
        broadcast("Свет моргнул.")
        flicker()
    elseif event == 2 then
        broadcast("Кажется, предмет стоит не там...")
        moveFurniture()
    else
        broadcast("Ты точно помнишь, что эта комната была такой?")
        Lighting.ClockTime = rng:NextNumber(18, 23)
    end
end
