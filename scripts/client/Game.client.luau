-- Мой дом не мой — клиент: атмосферный интерфейс и сообщения.
-- Поместить в StarterPlayer > StarterPlayerScripts.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local events = ReplicatedStorage:WaitForChild("HouseEvents")
local messageEvent = events:WaitForChild("Message")

local gui = Instance.new("ScreenGui")
gui.Name = "HouseUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.8, 0, 0, 70)
label.Position = UDim2.new(0.1, 0, 0.82, 0)
label.BackgroundTransparency = 0.25
label.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
label.TextColor3 = Color3.fromRGB(235, 235, 240)
label.TextScaled = true
label.Font = Enum.Font.GothamMedium
label.Text = ""
label.Visible = false
label.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = label

messageEvent.OnClientEvent:Connect(function(text)
    label.Text = text
    label.Visible = true
    label.TextTransparency = 1
    TweenService:Create(label, TweenInfo.new(0.35), {TextTransparency = 0}):Play()
    task.wait(4)
    TweenService:Create(label, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.55)
    label.Visible = false
end)
