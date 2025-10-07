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
        name = "CTD-crushed-stone",
        icon = "__CTDaddon_for_K2_SE__/graphics/icons/crushed-stone.png",
        subgroup = "stone",
        order = "a[stone]-c[CTD-crushed-stone]",
        inventory_move_sound = item_sounds.resource_inventory_move,
        pick_sound = item_sounds.resource_inventory_pickup,
        drop_sound = item_sounds.resource_inventory_move,
        stack_size = 100,
        weight = 1 * kg
    },
-- ##############################################################################################

-- ##############################################################################################
    {
        type = "recipe",
        name = "CTD-crushed-stone",
        category = "CTD-ore-refining-t1",
        energy_required = 2,
        enabled = true,
        ingredients = {{type = "item", name = "stone", amount = 1}},
        results = {{type="item", name="CTD-crushed-stone", amount=2}},
        allow_productivity = true
    }
})
-- ##############################################################################################

-- ##############################################################################################
-- if tech["burner-mechanics"] then
--     add_tech_unlock("CTD-crushed-stone", "burner-mechanics")
-- end
-- ##############################################################################################