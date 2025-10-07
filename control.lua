-- ##############################################################################################
-- ПРИВЕТСТВЕННОЕ СООБЩЕНИЕ
-- ##############################################################################################
-- Инициализация
script.on_init(function()
    global = global or {}
    global.players_seen = global.players_seen or {}
end)

script.on_configuration_changed(function()
    global = global or {}
    global.players_seen = global.players_seen or {}
end)

-- Функция отправки сообщения
local function send_welcome(player)
    -- Создаем цветной текст через Rich Text
    local message = {"", "[color=green]", {"CTD.CTD-welcome", player.name}, "[/color]"}
    player.print(message)
end

-- Обработчики событий
script.on_event(defines.events.on_player_created, function(event)
    local player = game.players[event.player_index]
    if not global.players_seen[player.index] then
        send_welcome(player)
        global.players_seen[player.index] = true
    end
end)

script.on_event(defines.events.on_player_joined_game, function(event)
    global = global or {}
    global.players_seen = global.players_seen or {}

    local player = game.players[event.player_index]
    if not global.players_seen[player.index] then
        send_welcome(player)
        global.players_seen[player.index] = true
    end
end)
-- ##############################################################################################
-- ЗАМЕДЛЕНИЕ СКОРОСТИ РУЧНОГО КРАФТА (ОПЦИОНАЛЬНО)
-- ##############################################################################################
local modifier = -0.9835  -- 1.0 → 0.0165
local function apply_crafting_speed()
    if settings.startup["CTD-hand-crafting"].value == "slowing-down" then
        for _, player in pairs(game.players) do
            if player.character then
                player.character_crafting_speed_modifier = modifier
            end
        end
        log("Скорость крафта замедленна для всех игроков")
    end
end

-- Обработчики событий
script.on_init(apply_crafting_speed)
script.on_configuration_changed(apply_crafting_speed)

-- Для новых игроков
script.on_event(defines.events.on_player_created, function(event)
    if settings.startup["CTD-hand-crafting"].value == "slowing-down" then
        local player = game.players[event.player_index]
        if player.character then
            player.character_crafting_speed_modifier = modifier
        end
    end
end)
-- ##############################################################################################
-- ДОПОЛНЕНИЕ СТАРТОВОГО ЛУТА
-- ##############################################################################################
if settings.startup["CTD-start-loot"].value == "with_Bob" then
    CTD_StartConfig = {                 -- предметы в упавшем корабле
        ship_items = {
            {"burner-inserter", 5},
            {"CTD-burner-ore-crusher", 2},
            {"burner-mining-drill", 2},
            {"burner-assembling-machine", 3},

        },
        debris_items = {                -- предметы в обломках
            {"burner-inserter", 2},
            {"burner-inserter", 2},
            {"burner-inserter", 1},
        },
        created_items = {               -- предметы уже созданные у игрока
            -- {"firearm-magazine", 10}
        }
    }
else
    CTD_StartConfig = {                 -- предметы в упавшем корабле
        ship_items = {
            {"burner-inserter", 5},
            {"CTD-burner-ore-crusher", 2},
            {"burner-mining-drill", 2},
            {"burner-assembling-machine", 3},

        },
        debris_items = {                -- предметы в обломках
            {"burner-inserter", 2},
            {"burner-inserter", 2},
            {"burner-inserter", 1},
        },
        created_items = {               -- предметы уже созданные у игрока
            -- {"pistol", 1}  
        }
    }
end

local function add_items_to_collection(collection, item_list)
    for _, item_data in ipairs(item_list) do
        local item_name = item_data[1]
        local item_count = item_data[2]
        collection[item_name] = (collection[item_name] or 0) + item_count
    end
end

local function setup_starting_items()
    if not remote.interfaces.freeplay then return end

    local ship_items = remote.call("freeplay", "get_ship_items") or {}
    local debris_items = remote.call("freeplay", "get_debris_items") or {}
    local created_items = remote.call("freeplay", "get_created_items") or {}

    add_items_to_collection(ship_items, CTD_StartConfig.ship_items)
    add_items_to_collection(debris_items, CTD_StartConfig.debris_items)
    add_items_to_collection(created_items, CTD_StartConfig.created_items)

    remote.call("freeplay", "set_ship_items", ship_items)
    remote.call("freeplay", "set_debris_items", debris_items)
    remote.call("freeplay", "set_created_items", created_items)

    log("Стартовые предметы настроены")
end

script.on_init(function()
    setup_starting_items()
end)

script.on_configuration_changed(function(data)
    if data.mod_changes and data.mod_changes["CTDaddon"] then
        setup_starting_items()
    end
end)
-- ##############################################################################################