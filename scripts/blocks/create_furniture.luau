-- Создаёт базовую мебель внутри GeneratedHouse.

local Workspace = game:GetService("Workspace")
local house = Workspace:WaitForChild("GeneratedHouse")

local function part(name, size, position, color)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Position = position
    p.Anchored = true
    p.Color = color
    p.Parent = house
    return p
end

-- Стол
part("TableTop", Vector3.new(5, 0.4, 3), Vector3.new(0, 2.4, 0))
for _, x in ipairs({-2, 2}) do
    for _, z in ipairs({-1, 1}) do
        part("TableLeg", Vector3.new(0.35, 2.4, 0.35), Vector3.new(x, 1.2, z))
    end
end

-- Кровать
part("Bed", Vector3.new(6, 1, 3), Vector3.new(-8, 1, 5))
part("Pillow", Vector3.new(2, 0.45, 2.4), Vector3.new(-10, 1.65, 5))

-- Шкаф
part("Wardrobe", Vector3.new(3, 6, 1.5), Vector3.new(10, 3, -6))

print("Мебель создана!")
