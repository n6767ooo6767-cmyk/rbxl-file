-- Небольшие случайные изменения интерьера.
-- Script в ServerScriptService.

local Workspace = game:GetService("Workspace")
local rng = Random.new()
local house = Workspace:WaitForChild("GeneratedHouse")

local function changeObject()
    local objects = {}
    for _, object in ipairs(house:GetChildren()) do
        if object:IsA("BasePart") and object.Name ~= "Floor" and object.Name ~= "Ceiling" then
            table.insert(objects, object)
        end
    end

    if #objects == 0 then return end

    local object = objects[rng:NextInteger(1, #objects)]
    object.Orientation += Vector3.new(0, rng:NextInteger(-15, 15), 0)
end

while true do
    task.wait(rng:NextInteger(12, 25))
    changeObject()
end
