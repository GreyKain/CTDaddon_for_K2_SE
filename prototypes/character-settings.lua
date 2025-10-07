-- ##############################################################################################
-----------------------------------------НАСТРОЙКИ ПЕРСОНАЖА-------------------------------------
local player_corpse_time = settings.startup["CTD-player-corpse-life"].value * 60 * 60
local healing_per_second = settings.startup["CTD-healing-per-second"].value / 60
local stay_in_combat_time = settings.startup["CTD-seconds-to-stay-in-combat"].value * 60

data.raw["character-corpse"]["character-corpse"].time_to_live = player_corpse_time

local character = data.raw.character["character"]
if character["healing_per_tick"] then
	character["healing_per_tick"] = healing_per_second
end

if character["ticks_to_stay_in_combat"] then
    character["ticks_to_stay_in_combat"] = stay_in_combat_time
end
-- ##############################################################################################