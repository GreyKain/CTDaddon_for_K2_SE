-- ##############################################################################################
local item_sounds = require("__base__.prototypes.item_sounds")
local add_tech_unlock = CTDmod.lib.recipe.add_tech_unlock
local tech = data.raw.technology
-- ##############################################################################################

-- ##############################################################################################
data:extend(
{
    {
        type = "item",
        name = "CTD-crushed-copper-ore",
        icon = "__CTDaddon_for_K2_SE__/graphics/icons/crushed-copper-ore-1.png",
        subgroup = "copper",
        order = "a[copper]-a[CTD-crushed-copper-ore]",
        inventory_move_sound = item_sounds.resource_inventory_move,
        pick_sound = item_sounds.resource_inventory_pickup,
        drop_sound = item_sounds.resource_inventory_move,
        stack_size = 100,
        weight = 2 * kg
    },
-- ##############################################################################################

-- ##############################################################################################
    {
        type = "recipe",
        name = "CTD-crushed-copper-ore",
        category = "CTD-ore-refining-t1",
        energy_required = 1,
        enabled = true,
        ingredients = {{type = "item", name = "copper-ore", amount = 10}},
        results = {{type = "item", name = "CTD-crushed-copper-ore", amount = 10}},
        allow_productivity = true
    }
})
-- ##############################################################################################

-- ##############################################################################################
-- if tech["burner-mechanics"] then
--     add_tech_unlock("CTD-crushed-copper-ore", "burner-mechanics")
-- end
-- ##############################################################################################