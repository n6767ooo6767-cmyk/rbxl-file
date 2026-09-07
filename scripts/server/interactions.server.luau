-- Общие взаимодействия с объектами.

local CollectionService = game:GetService("CollectionService")

local function setup(object)
    if not object:IsA("BasePart") then
        return
    end

    local prompt = object:FindFirstChildOfClass("ProximityPrompt")
    if not prompt then
        return
    end

    prompt.Triggered:Connect(function(player)
        print(player.Name .. " взаимодействовал с " .. object.Name)
    end)
end

for _, object in ipairs(CollectionService:GetTagged("Interactable")) do
    setup(object)
end

CollectionService:GetInstanceAddedSignal("Interactable"):Connect(setup)
