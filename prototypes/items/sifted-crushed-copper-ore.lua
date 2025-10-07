-- ##############################################################################################
local item_sounds = require("__base__.prototypes.item_sounds")
local add_tech_unlock = CTDmod.lib.recipe.add_tech_unlock
local tech = data.raw.technology
-- ##############################################################################################
-- 
-- ##############################################################################################
data:extend(
{
    {
        type = "item",
        name = "CTD-sifted-crushed-copper-ore",
        icon = "__CTDaddon_for_K2_SE__/graphics/icons/sifted-crushed-copper-ore-1.png",
        subgroup = "copper",
        order = "a[copper]-a[CTD-purified-crushed-copper-ore]",
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
        name = "CTD-sifted-crushed-copper-ore",
        category = "crafting",
        energy_required = 1,
        enabled = true,
        ingredients = {{type = "item", name = "CTD-crushed-copper-ore", amount = 10}},
        results = {
            {type="item", name="CTD-sifted-crushed-copper-ore", amount = 9},
            {type="item", name="CTD-crushed-stone", amount = 1},
        },
        main_product = "CTD-sifted-crushed-copper-ore",
        allow_productivity = true
    }
})
-- ##############################################################################################

-- ##############################################################################################
-- if tech["burner-mechanics"] then
--     add_tech_unlock("CTD-sifted-crushed-copper-ore", "burner-mechanics")
-- end
-- ##############################################################################################