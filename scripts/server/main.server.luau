-- Главный серверный скрипт игры «Мой дом не мой».
-- Поместите Script в ServerScriptService.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function ensureFolder(parent, name)
    local folder = parent:FindFirstChild(name)
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = name
        folder.Parent = parent
    end
    return folder
end

local remotes = ensureFolder(ReplicatedStorage, "GameRemotes")
local event = remotes:FindFirstChild("HouseEvent")

if not event then
    event = Instance.new("RemoteEvent")
    event.Name = "HouseEvent"
    event.Parent = remotes
end

local state = ensureFolder(ReplicatedStorage, "GameState")
local day = state:FindFirstChild("Day")
if not day then
    day = Instance.new("IntValue")
    day.Name = "Day"
    day.Value = 1
    day.Parent = state
end

local houseEvent = require(script.Parent.Parent.systems.house_events)
houseEvent.Start(event, day)

print("[MY HOUSE IS NOT MINE] Сервер запущен")
