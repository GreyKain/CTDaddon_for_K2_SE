-- ##############################################################################################
-- local assembler = data.raw["assembling-machine"]
-- local burner_assembler = assembler["burner-assembling-machine"]
local hand_crafting = settings.startup["CTD-hand-crafting"].value
-- local lab = data.raw["lab"]
local shortcut = data.raw["shortcut"]
-- ##############################################################################################

-- ##############################################################################################
require("prototypes.prorotypes-data-final-fix")

if hand_crafting == "forbidden" or hand_crafting == "forbidden-and-hidden" then
	require("prototypes.mods.prohibition_manual_crafting")	-- мод на запрет ручного крафта (для мазохистов)
end
-- ##############################################################################################

-- ##############################################################################################
--- для скрытия ярлыков зелёных/красных проводов:
if not mods ["GetWiresBack"] then
	if mods ["aai-industry"] then
		shortcut["give-copper-wire"].technology_to_unlock = "electricity"
	end
	shortcut["give-copper-wire"].unavailable_until_unlocked = true
	shortcut["give-red-wire"].unavailable_until_unlocked = true
	shortcut["give-green-wire"].unavailable_until_unlocked = true
end
-- ##############################################################################################