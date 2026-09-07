-- МОЙ ДОМ НЕ МОЙ — ГОТОВЫЙ CLIENT UI
-- Поместите LocalScript в StarterPlayer > StarterPlayerScripts.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local message = ReplicatedStorage:WaitForChild("HouseEvents"):WaitForChild("Message")

local gui = Instance.new("ScreenGui")
gui.Name = "MyHouseUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.AnchorPoint = Vector2.new(.5,.5)
label.Position = UDim2.fromScale(.5,.86)
label.Size = UDim2.fromScale(.72,.08)
label.BackgroundTransparency = .2
label.BackgroundColor3 = Color3.fromRGB(8,8,12)
label.TextColor3 = Color3.fromRGB(235,235,240)
label.TextScaled = true
label.Font = Enum.Font.GothamMedium
label.Visible = false
label.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = label

message.OnClientEvent:Connect(function(text)
    label.Text = text
    label.Visible = true
    label.TextTransparency = 1
    TweenService:Create(label,TweenInfo.new(.35),{TextTransparency=0}):Play()
    task.wait(3.5)
    TweenService:Create(label,TweenInfo.new(.5),{TextTransparency=1}):Play()
    task.wait(.55)
    label.Visible = false
end)
