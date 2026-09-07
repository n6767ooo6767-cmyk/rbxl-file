# «Мой дом не мой» — Luau source

Полный набор исходников для сборки прототипа игры в Roblox Studio.

## Структура

```text
scripts/
├── blocks/
│   ├── create_house.luau
│   ├── create_room.luau
│   ├── create_furniture.luau
│   └── create_doors.luau
├── client/
│   └── effects.client.luau
├── server/
│   ├── main.server.luau
│   ├── interactions.server.luau
│   ├── lighting.server.luau
│   └── random_changes.server.luau
└── systems/
    ├── house_events.luau
    └── change_house.luau
```

## Установка

1. `server/main.server.luau` → `ServerScriptService` как `Script`.
2. `systems/house_events.luau` → `ServerScriptService` как `ModuleScript`.
3. Остальные файлы из `server/` → `ServerScriptService` как `Script`.
4. `client/effects.client.luau` → `StarterPlayer > StarterPlayerScripts` как `LocalScript`.
5. Файлы из `blocks/` → серверные `Script`; запускай генераторы один раз, чтобы не получить дубликаты.

Система создаёт дом, мебель и дверь, запускает смену времени, случайные изменения интерьера и клиентские атмосферные события.
