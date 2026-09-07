-- МОЙ ДОМ НЕ МОЙ — CLIENT
-- StarterPlayer -> StarterPlayerScripts -> LocalScript
-- HUD, плавные сообщения, затемнение, переходы, состояние дня и прогресс.

local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")

local player=Players.LocalPlayer
local events=ReplicatedStorage:WaitForChild("HouseEvents")
local message=events:WaitForChild("Message")
local cutscene=events:WaitForChild("Cutscene")
local stateEvent=events:WaitForChild("State")

local gui=Instance.new("ScreenGui")
gui.Name="MyHouseUI"; gui.ResetOnSpawn=false; gui.Parent=player:WaitForChild("PlayerGui")

local top=Instance.new("Frame")
top.Position=UDim2.fromOffset(18,18); top.Size=UDim2.fromOffset(300,126)
top.BackgroundColor3=Color3.fromRGB(10,10,14); top.BackgroundTransparency=.16; top.Parent=gui
local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,14); corner.Parent=top

local title=Instance.new("TextLabel")
title.Position=UDim2.fromOffset(14,9); title.Size=UDim2.new(1,-28,0,25)
title.BackgroundTransparency=1; title.Font=Enum.Font.GothamBold; title.TextColor3=Color3.new(1,1,1)
title.TextSize=18; title.TextXAlignment=Enum.TextXAlignment.Left; title.Text="МОЙ ДОМ НЕ МОЙ"; title.Parent=top

local info=Instance.new("TextLabel")
info.Position=UDim2.fromOffset(14,39); info.Size=UDim2.new(1,-28,0,24)
info.BackgroundTransparency=1; info.Font=Enum.Font.GothamMedium; info.TextColor3=Color3.fromRGB(220,220,225)
info.TextSize=15; info.TextXAlignment=Enum.TextXAlignment.Left; info.Text="День 1 • Утро"; info.Parent=top

local objective=Instance.new("TextLabel")
objective.Position=UDim2.fromOffset(14,67); objective.Size=UDim2.new(1,-28,0,48)
objective.BackgroundTransparency=1; objective.Font=Enum.Font.Gotham; objective.TextColor3=Color3.fromRGB(185,185,195)
objective.TextSize=13; objective.TextWrapped=true; objective.TextXAlignment=Enum.TextXAlignment.Left; objective.TextYAlignment=Enum.TextYAlignment.Top
objective.Text="Задача: начать день"; objective.Parent=top

local toast=Instance.new("TextLabel")
toast.AnchorPoint=Vector2.new(.5,.5); toast.Position=UDim2.fromScale(.5,.84); toast.Size=UDim2.fromScale(.7,.075)
toast.BackgroundColor3=Color3.fromRGB(8,8,12); toast.BackgroundTransparency=.12
toast.TextColor3=Color3.fromRGB(240,240,245); toast.TextScaled=true; toast.Font=Enum.Font.GothamMedium
toast.Visible=false; toast.Parent=gui
local tc=Instance.new("UICorner"); tc.CornerRadius=UDim.new(0,12); tc.Parent=toast

local fade=Instance.new("Frame")
fade.Size=UDim2.fromScale(1,1); fade.BackgroundColor3=Color3.new(0,0,0); fade.BackgroundTransparency=1; fade.ZIndex=20; fade.Parent=gui

local sub=Instance.new("TextLabel")
sub.AnchorPoint=Vector2.new(.5,.5); sub.Position=UDim2.fromScale(.5,.5); sub.Size=UDim2.fromScale(.8,.15)
sub.BackgroundTransparency=1; sub.TextColor3=Color3.new(1,1,1); sub.Font=Enum.Font.GothamBold; sub.TextScaled=true
sub.TextTransparency=1; sub.ZIndex=21; sub.Parent=gui

local function showToast(text)
    toast.Text=text; toast.Visible=true; toast.TextTransparency=1
    TweenService:Create(toast,TweenInfo.new(.3),{TextTransparency=0}):Play()
    task.delay(3.2,function()
        local t=TweenService:Create(toast,TweenInfo.new(.45),{TextTransparency=1}); t:Play(); t.Completed:Wait(); toast.Visible=false
    end)
end
message.OnClientEvent:Connect(showToast)

local function phaseText(p)
    return ({morning="Утро",work="Работа",after_work="После работы",sleeping="Сон"})[p] or p
end
local function objectiveText(d)
    if d.phase=="morning" then return "Задача: начни рабочий день дома."
    elseif d.phase=="work" then return "Задача: выполнить рабочие задачи "..d.workDone.."/3."
    elseif d.phase=="after_work" and not d.shopDone then return "Задача: зайди в магазин и отметь покупки."
    elseif d.phase=="after_work" then return "Задача: возвращайся домой и ложись спать."
    elseif d.phase=="sleeping" then return "Отдых..."
    end
    return "Осмотрись вокруг."
end
stateEvent.OnClientEvent:Connect(function(d)
    info.Text="День "..d.day.." • "..phaseText(d.phase).."   •   💰 "..d.money
    objective.Text=objectiveText(d).."\n🍞 Еда: "..d.food.."   📚 Книги: "..d.books.."   •   Странности: "..d.anomalies
end)

local function cinematic(kind,arg)
    local character=player.Character
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if kind=="walk" then
        fade.BackgroundTransparency=1
        TweenService:Create(fade,TweenInfo.new(.35),{BackgroundTransparency=.15}):Play()
        sub.Text="Идём: "..tostring(arg); sub.TextTransparency=1
        TweenService:Create(sub,TweenInfo.new(.35),{TextTransparency=0}):Play()
        if humanoid then humanoid.WalkSpeed=10 end
        task.wait(.75)
        if humanoid then humanoid.WalkSpeed=16 end
        task.wait(.5)
        TweenService:Create(sub,TweenInfo.new(.3),{TextTransparency=1}):Play()
        TweenService:Create(fade,TweenInfo.new(.45),{BackgroundTransparency=1}):Play()
    elseif kind=="leave_work" then
        TweenService:Create(fade,TweenInfo.new(.5),{BackgroundTransparency=0}):Play()
        sub.Text="Утро • пора на работу"; sub.TextTransparency=1
        TweenService:Create(sub,TweenInfo.new(.35),{TextTransparency=0}):Play(); task.wait(1.1)
        TweenService:Create(sub,TweenInfo.new(.3),{TextTransparency=1}):Play()
        TweenService:Create(fade,TweenInfo.new(.5),{BackgroundTransparency=1}):Play()
    elseif kind=="sleep" then
        TweenService:Create(fade,TweenInfo.new(.8),{BackgroundTransparency=0}):Play()
        sub.Text="Ты засыпаешь..."; sub.TextTransparency=1
        TweenService:Create(sub,TweenInfo.new(.5),{TextTransparency=0}):Play(); task.wait(2)
    elseif kind=="morning" then
        sub.Text="День "..tostring(arg).." • 07:30"; sub.TextTransparency=0
        fade.BackgroundTransparency=0
        TweenService:Create(fade,TweenInfo.new(1.2),{BackgroundTransparency=1}):Play()
        TweenService:Create(sub,TweenInfo.new(.7),{TextTransparency=1}):Play()
    end
end
cutscene.OnClientEvent:Connect(cinematic)

-- Небольшая живая анимация HUD, чтобы интерфейс не был статичным.
local pulse=0
RunService.RenderStepped:Connect(function(dt)
    pulse+=dt
    top.Position=UDim2.fromOffset(18,18+math.sin(pulse*1.2)*1.2)
end)
