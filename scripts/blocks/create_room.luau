-- Универсальный генератор комнаты.

local Workspace = game:GetService("Workspace")
local house = Workspace:FindFirstChild("GeneratedHouse") or Instance.new("Folder")
house.Name = "GeneratedHouse"
house.Parent = Workspace

local function createRoom(origin, width, depth, height)
    local function make(name, size, offset)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.Position = origin + offset
        p.Anchored = true
        p.Parent = house
        return p
    end

    make("RoomFloor", Vector3.new(width, 1, depth), Vector3.new(0, 0, 0))
    make("RoomWall1", Vector3.new(width, height, 1), Vector3.new(0, height / 2, -depth / 2))
    make("RoomWall2", Vector3.new(width, height, 1), Vector3.new(0, height / 2, depth / 2))
    make("RoomWall3", Vector3.new(1, height, depth), Vector3.new(-width / 2, height / 2, 0))
    make("RoomWall4", Vector3.new(1, height, depth), Vector3.new(width / 2, height / 2, 0))
    make("RoomCeiling", Vector3.new(width, 1, depth), Vector3.new(0, height, 0))
end

createRoom(Vector3.new(0, 0, 0), 12, 10, 8)
