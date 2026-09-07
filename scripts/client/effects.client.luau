-- Клиентские эффекты для странных событий дома.
-- LocalScript в StarterPlayerScripts.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

local remote = ReplicatedStorage:WaitForChild("GameRemotes"):WaitForChild("HouseEvent")

local function message(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "МОЙ ДОМ НЕ МОЙ",
            Text = text,
            Duration = 4
        })
    end)
end

local function flicker()
    local oldBrightness = Lighting.Brightness
    for _ = 1, 5 do
        Lighting.Brightness = 0.15
        task.wait(0.08)
        Lighting.Brightness = oldBrightness
        task.wait(0.12)
    end
end

remote.OnClientEvent:Connect(function(kind, data)
    if kind == "MESSAGE" then
        message(data)
    elseif kind == "LIGHT_FLICKER" then
        flicker()
    end
end)
