-- Простой эффект: периодически слегка меняет положение случайной детали дома.
-- Запускайте после create_house.luau.

local Workspace = game:GetService("Workspace")
local rng = Random.new()
local folder = Workspace:WaitForChild("GeneratedHouse")

while true do
    task.wait(15)

    local parts = folder:GetChildren()
    if #parts == 0 then
        continue
    end

    local part = parts[rng:NextInteger(1, #parts)]
    if part:IsA("BasePart") and part.Name ~= "Floor" and part.Name ~= "Ceiling" then
        local offset = Vector3.new(
            rng:NextNumber(-0.25, 0.25),
            0,
            rng:NextNumber(-0.25, 0.25)
        )
        part.Position += offset
    end
end
