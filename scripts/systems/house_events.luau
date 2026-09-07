local HouseEvents = {}

local rng = Random.new()
local messages = {
    "Ты точно оставлял дверь закрытой?",
    "В доме что-то изменилось.",
    "Кажется, здесь появилась новая комната.",
    "Не обращай внимания на звук.",
    "Сегодня дом выглядит немного иначе."
}

function HouseEvents.Start(remote, dayValue)
    task.spawn(function()
        while true do
            task.wait(20)
            dayValue.Value += 1

            local message = messages[rng:NextInteger(1, #messages)]
            remote:FireAllClients("MESSAGE", message)

            if rng:NextNumber() < 0.45 then
                remote:FireAllClients("LIGHT_FLICKER")
            end
        end
    end)
end

return HouseEvents
