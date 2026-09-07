-- Атмосфера и смена времени суток.

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

Lighting.ClockTime = 18
Lighting.Brightness = 1.2
Lighting.ExposureCompensation = 0

local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
if not atmosphere then
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.25
    atmosphere.Haze = 1.2
    atmosphere.Parent = Lighting
end

while true do
    local tween = TweenService:Create(
        Lighting,
        TweenInfo.new(30, Enum.EasingStyle.Linear),
        {ClockTime = 24}
    )
    tween:Play()
    tween.Completed:Wait()
    Lighting.ClockTime = 0
end
