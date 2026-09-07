-- Создаёт базовый дом из Part-объектов.
-- Запускайте этот Script в ServerScriptService.

local Workspace = game:GetService("Workspace")

local folder = Instance.new("Folder")
folder.Name = "GeneratedHouse"
folder.Parent = Workspace

local function createPart(name, size, position, material)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.Position = position
    part.Anchored = true
    part.Material = material or Enum.Material.SmoothPlastic
    part.Parent = folder
    return part
end

-- Пол
createPart("Floor", Vector3.new(30, 1, 24), Vector3.new(0, 0, 0), Enum.Material.Wood)

-- Стены
createPart("WallFront", Vector3.new(30, 10, 1), Vector3.new(0, 5, -12))
createPart("WallBack", Vector3.new(30, 10, 1), Vector3.new(0, 5, 12))
createPart("WallLeft", Vector3.new(1, 10, 24), Vector3.new(-15, 5, 0))
createPart("WallRight", Vector3.new(1, 10, 24), Vector3.new(15, 5, 0))

-- Потолок
createPart("Ceiling", Vector3.new(30, 1, 24), Vector3.new(0, 10, 0))

print("Дом создан!")
