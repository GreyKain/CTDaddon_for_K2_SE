-- ##############################################################################################
local dubl_hide = CTDmod.lib.recipe.duplicate_with_hide
local update_all_crafting = CTDmod.lib.character.update_all_crafting
local handmade = "CTD-handmade"
-- ##############################################################################################

-- ##############################################################################################
dubl_hide("small-electric-pole", "CTD-small-electric-pole-handmade", {category = handmade, energy_required = 10})
dubl_hide("wooden-chest", "CTD-wooden-chest-handmade", {category = handmade, energy_required = 30})
dubl_hide("stone-furnace", "CTD-stone-furnace-handmade", {category = handmade, energy_required = 45})

if mods ["bobgreenhouse"] then
    dubl_hide("bob-greenhouse", "CTD-bob-greenhouse-handmade", {category = handmade, energy_required = 60})
end

if mods ["space-age"] then
    dubl_hide("scrap-recycling", "CTD-scrap-recycling-handmade", {category = handmade, energy_required = 10})
end

update_all_crafting({handmade})
-- ##############################################################################################

-- ##############################################################################################
if settings.startup["CTD-hand-crafting"].value == "forbidden-and-hidden" then
    for name, recipe in pairs(data.raw["recipe"]) do
        if  data.raw["recipe"][name].category ~= handmade then
            data.raw["recipe"][name].hide_from_player_crafting = true
        end
    end
end
-- ##############################################################################################