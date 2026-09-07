-- МОЙ ДОМ НЕ МОЙ — ПОЛНАЯ ВЕРСИЯ
-- ServerScriptService -> Script
-- Дом + работа + магазин + расписание + задания + странности + сохранение.
-- Для сохранений: опубликуй игру и включи Game Settings -> Security -> Enable Studio Access to API Services.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local DataStoreService = game:GetService("DataStoreService")

local SAVE = DataStoreService:GetDataStore("MyHouseNotMine_v2")
local events = ReplicatedStorage:FindFirstChild("HouseEvents") or Instance.new("Folder")
events.Name = "HouseEvents"
events.Parent = ReplicatedStorage
local message = events:FindFirstChild("Message") or Instance.new("RemoteEvent")
message.Name = "Message"
message.Parent = events
local cutscene = events:FindFirstChild("Cutscene") or Instance.new("RemoteEvent")
cutscene.Name = "Cutscene"
cutscene.Parent = events
local stateEvent = events:FindFirstChild("State") or Instance.new("RemoteEvent")
stateEvent.Name = "State"
stateEvent.Parent = events

local old = workspace:FindFirstChild("MY_HOUSE_GAME")
if old then old:Destroy() end
local world = Instance.new("Folder")
world.Name = "MY_HOUSE_GAME"
world.Parent = workspace

local function part(name,size,pos,material,parent)
    local p=Instance.new("Part")
    p.Name=name; p.Size=size; p.Position=pos; p.Anchored=true
    p.Material=material or Enum.Material.SmoothPlastic; p.Parent=parent or world
    return p
end
local function sign(text,pos,parent)
    local p=part("Sign",Vector3.new(7,.15,3),pos,Enum.Material.SmoothPlastic,parent)
    local gui=Instance.new("SurfaceGui"); gui.Face=Enum.NormalId.Front; gui.Parent=p
    local l=Instance.new("TextLabel"); l.Size=UDim2.fromScale(1,1); l.BackgroundTransparency=1
    l.Text=text; l.TextScaled=true; l.Font=Enum.Font.GothamBold; l.TextColor3=Color3.new(1,1,1); l.Parent=gui
    return p
end
local function prompt(parent,action,object,callback)
    local pr=Instance.new("ProximityPrompt")
    pr.ActionText=action; pr.ObjectText=object; pr.HoldDuration=.35; pr.MaxActivationDistance=10
    pr.RequiresLineOfSight=false; pr.Parent=parent; pr.Triggered:Connect(callback)
    return pr
end

-- ДОМ
local house=Instance.new("Folder"); house.Name="House"; house.Parent=world
part("Floor",Vector3.new(42,1,32),Vector3.new(0,0,0),Enum.Material.Wood,house)
part("BackWall",Vector3.new(42,12,1),Vector3.new(0,6,-16),nil,house)
part("LeftWall",Vector3.new(1,12,32),Vector3.new(-21,6,0),nil,house)
part("RightWall",Vector3.new(1,12,32),Vector3.new(21,6,0),nil,house)
part("FrontWall",Vector3.new(42,12,1),Vector3.new(0,6,16),nil,house)
part("Ceiling",Vector3.new(42,1,32),Vector3.new(0,12,0),nil,house)
part("Table",Vector3.new(7,1,3),Vector3.new(-7,3,1),Enum.Material.Wood,house)
for i,x in ipairs({-9.5,-4.5}) do part("TableLeg"..i,Vector3.new(.5,3,.5),Vector3.new(x,1.5,0),Enum.Material.Wood,house) end
part("Bed",Vector3.new(8,1.5,5),Vector3.new(9,1.75,-8),Enum.Material.Fabric,house)
part("BedHead",Vector3.new(8,4,.7),Vector3.new(9,3,-10.1),Enum.Material.Wood,house)
part("Sofa",Vector3.new(8,2.2,3),Vector3.new(7,2.1,5),Enum.Material.Fabric,house)
part("TV",Vector3.new(7,4,.4),Vector3.new(0,5,-15.3),Enum.Material.SmoothPlastic,house)
sign("МОЙ ДОМ",Vector3.new(0,9,15.2),house)

local door=part("FrontDoor",Vector3.new(5,9,.7),Vector3.new(0,4.5,15.4),Enum.Material.Wood,house)
local doorOpen=false
local doorPrompt
local function setDoor(open)
    doorOpen=open; door.CanCollide=not open; door.Transparency=open and .65 or 0
    if doorPrompt then doorPrompt.ActionText=open and "Закрыть" or "Открыть" end
end
doorPrompt=prompt(door,"Открыть","Дверь",function() setDoor(not doorOpen) end)

-- РАБОТА И МАГАЗИН
local function building(name,center,material)
    local f=Instance.new("Folder"); f.Name=name; f.Parent=world
    part("Floor",Vector3.new(44,1,28),center,material,f)
    part("Back",Vector3.new(44,11,1),center+Vector3.new(0,5.5,-14),nil,f)
    part("Left",Vector3.new(1,11,28),center+Vector3.new(-22,5.5,0),nil,f)
    part("Right",Vector3.new(1,11,28),center+Vector3.new(22,5.5,0),nil,f)
    part("Front",Vector3.new(44,11,1),center+Vector3.new(0,5.5,14),nil,f)
    sign(name,center+Vector3.new(0,8,13.2),f)
    return f
end
local work=building("WORK",Vector3.new(75,0,0),Enum.Material.Metal)
local desk=part("Desk",Vector3.new(12,1,4),Vector3.new(75,3,0),Enum.Material.Wood,work)
part("Computer",Vector3.new(3,3,.5),Vector3.new(75,5,-1),Enum.Material.SmoothPlastic,work)
local shop=building("SHOP",Vector3.new(0,0,60),Enum.Material.Concrete)
part("Counter",Vector3.new(14,2,4),Vector3.new(0,2.5,55),Enum.Material.Wood,shop)
local food=part("Food",Vector3.new(2,2,2),Vector3.new(-4,4,55),Enum.Material.SmoothPlastic,shop)
local water=part("Water",Vector3.new(2,2,2),Vector3.new(0,4,55),Enum.Material.SmoothPlastic,shop)
local book=part("Book",Vector3.new(2,2,2),Vector3.new(4,4,55),Enum.Material.SmoothPlastic,shop)

local spawn=Instance.new("SpawnLocation"); spawn.Name="HomeSpawn"; spawn.Size=Vector3.new(5,1,5)
spawn.Position=Vector3.new(0,2,9); spawn.Anchored=true; spawn.Neutral=true; spawn.Parent=house

local function travelPrompt(pos,text,destination)
    local p=part("Travel_"..text,Vector3.new(4,1,4),pos,Enum.Material.Neon,world)
    prompt(p,"Идти",text,function(player)
        local d=player:GetAttribute("LifeState")
        if d=="sleeping" then return end
        cutscene:FireClient(player,"walk",text)
        task.delay(1.4,function()
            if player.Character and player.Character.Parent then
                player.Character:PivotTo(CFrame.new(destination)); message:FireClient(player,"Ты пришёл: "..text)
            end
        end)
    end)
end
travelPrompt(Vector3.new(17,1,0),"На работу",Vector3.new(70,3,8))
travelPrompt(Vector3.new(0,1,13),"В магазин",Vector3.new(0,3,50))
travelPrompt(Vector3.new(70,1,8),"Домой",Vector3.new(0,3,8))
travelPrompt(Vector3.new(0,1,50),"Домой из магазина",Vector3.new(0,3,8))

-- ПРОФИЛЬ И СОХРАНЕНИЕ
local DEFAULT={day=1,money=60,food=2,books=0,phase="morning",workDone=0,shopDone=false,anomalies=0,totalMinutes=0}
local profiles={}
local function copyDefault() local t={} for k,v in pairs(DEFAULT) do t[k]=v end return t end
local function savePlayer(player)
    local d=profiles[player]; if not d then return end
    local payload={} for k,v in pairs(d) do payload[k]=v end
    local ok,err=pcall(function() SAVE:UpdateAsync("u_"..player.UserId,function() return payload end) end)
    if not ok then warn("Save failed",player.Name,err) end
end
local function loadPlayer(player)
    local data=copyDefault()
    local ok,result=pcall(function() return SAVE:GetAsync("u_"..player.UserId) end)
    if ok and type(result)=="table" then for k,v in pairs(result) do data[k]=v end end
    profiles[player]=data; player:SetAttribute("LifeState",data.phase); return data
end
local function sync(player)
    local d=profiles[player]; if not d then return end
    stateEvent:FireClient(player,{day=d.day,money=d.money,food=d.food,books=d.books,phase=d.phase,workDone=d.workDone,shopDone=d.shopDone,anomalies=d.anomalies,totalMinutes=d.totalMinutes})
end
local function say(player,text) if player and player.Parent then message:FireClient(player,text) end end
local function setPhase(player,phase)
    local d=profiles[player]; if not d then return end
    d.phase=phase; player:SetAttribute("LifeState",phase); sync(player)
end
local function nextDay(player)
    local d=profiles[player]; if not d then return end
    d.day+=1; d.phase="morning"; d.workDone=0; d.shopDone=false; d.totalMinutes+=10
    player:SetAttribute("LifeState","morning"); Lighting.ClockTime=7.5
    say(player,"Новое утро. День "..d.day.."."); cutscene:FireClient(player,"morning",d.day); sync(player)
    task.spawn(function() savePlayer(player) end)
end

prompt(desk,"Работать","Рабочее место",function(player)
    local d=profiles[player]
    if not d or d.phase~="work" then say(player,"Сначала начни рабочий день."); return end
    if d.workDone>=3 then say(player,"Работа на сегодня закончена."); return end
    d.workDone+=1; say(player,"Задача выполнена: "..d.workDone.."/3")
    if d.workDone==3 then d.money+=45; say(player,"Рабочий день закончен. +45 монет."); setPhase(player,"after_work") end
    sync(player)
end)

prompt(food,"Купить еду (10)","Еда",function(player)
    local d=profiles[player]; if d and d.money>=10 then d.money-=10; d.food+=2; say(player,"Куплено 2 еды."); sync(player) else say(player,"Не хватает денег.") end
end)
prompt(water,"Купить воду (5)","Вода",function(player)
    local d=profiles[player]; if d and d.money>=5 then d.money-=5; say(player,"Ты купил воду."); sync(player) else say(player,"Не хватает денег.") end
end)
prompt(book,"Купить книгу (15)","Книга",function(player)
    local d=profiles[player]; if d and d.money>=15 then d.money-=15; d.books+=1; say(player,"Книга добавлена в коллекцию."); sync(player) else say(player,"Не хватает денег.") end
end)

prompt(house:FindFirstChild("Bed"),"Лечь спать","Кровать",function(player)
    local d=profiles[player]; if not d then return end
    if d.phase=="morning" then say(player,"Ещё слишком рано спать."); return end
    if d.phase=="work" then say(player,"Ты ещё на работе."); return end
    if d.phase=="after_work" and not d.shopDone then say(player,"Ты забыл зайти в магазин."); return end
    setPhase(player,"sleeping"); cutscene:FireClient(player,"sleep",d.day)
    task.delay(3,function() if player.Parent then nextDay(player) end end)
end)

prompt(shop:FindFirstChild("Counter"),"Отметиться","Список покупок",function(player)
    local d=profiles[player]; if not d then return end
    if d.phase~="after_work" then say(player,"Сейчас магазин тебе не нужен."); return end
    d.shopDone=true; say(player,"Покупки отмечены. Теперь возвращайся домой."); sync(player)
end)

prompt(house:FindFirstChild("Table"),"Начать день","Пора на работу",function(player)
    local d=profiles[player]; if not d then return end
    if d.phase=="morning" then
        d.phase="work"; player:SetAttribute("LifeState","work"); Lighting.ClockTime=9
        say(player,"Пора на работу. Выполни 3 задачи."); cutscene:FireClient(player,"leave_work",d.day); sync(player)
    end
end)

-- СТРАННОСТИ ПОСЛЕ РАБОТЫ
local rng=Random.new()
local function anomaly(player)
    local d=profiles[player]; if not d then return end
    d.anomalies+=1
    local n=rng:NextInteger(1,7)
    if n==1 then local t=house:FindFirstChild("Table"); if t then t.Position+=Vector3.new(rng:NextNumber(-3,3),0,rng:NextNumber(-2,2)) end; say(player,"Стол опять оказался не там.")
    elseif n==2 then setDoor(true); say(player,"На секунду показалось, что дверь была открыта.")
    elseif n==3 then local oldTime=Lighting.ClockTime; for _=1,8 do Lighting.ClockTime=rng:NextNumber(0,24); task.wait(.08) end; Lighting.ClockTime=oldTime; say(player,"Часы мигнули. Ты точно видел это?")
    elseif n==4 then local tv=house:FindFirstChild("TV"); if tv then tv.Position+=Vector3.new(0,1,0) end; say(player,"Телевизор стал немного выше.")
    elseif n==5 then say(player,"Кто-то только что прошёл за дверью.")
    elseif n==6 then local bed=house:FindFirstChild("Bed"); if bed then bed.Size=Vector3.new(9,1.5,5) end; say(player,"Кровать стала длиннее. Почему?")
    else say(player,"Дом сегодня будто пытается что-то вспомнить.") end
    sync(player)
end

task.spawn(function()
    while true do
        task.wait(60)
        for player,d in pairs(profiles) do
            if player.Parent then
                d.totalMinutes+=1
                if d.phase=="morning" then Lighting.ClockTime=Lighting.ClockTime+0.12
                elseif d.phase=="work" then Lighting.ClockTime=Lighting.ClockTime+0.18
                elseif d.phase=="after_work" then Lighting.ClockTime=Lighting.ClockTime+0.12; if rng:NextInteger(1,4)==1 then anomaly(player) end end
                sync(player)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(rng:NextInteger(35,60))
        for player,d in pairs(profiles) do
            if player.Parent and d.phase=="after_work" and d.shopDone and rng:NextInteger(1,3)==1 then anomaly(player) end
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    local d=loadPlayer(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(.2)
        local pos=Vector3.new(0,3,8)
        if d.phase=="work" or (d.phase=="after_work" and not d.shopDone) then pos=Vector3.new(70,3,8)
        elseif d.phase=="after_work" then pos=Vector3.new(0,3,50) end
        character:PivotTo(CFrame.new(pos)); sync(player)
    end)
    task.delay(2,function() if player.Parent then say(player,"С возвращением. День "..d.day.." • сохранение загружено."); sync(player) end end)
end)
Players.PlayerRemoving:Connect(function(player) savePlayer(player); profiles[player]=nil end)
game:BindToClose(function() for player in pairs(profiles) do savePlayer(player) end task.wait(2) end)

Lighting.ClockTime=7.5; Lighting.Brightness=1.6; Lighting.FogEnd=220
