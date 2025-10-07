-- ##############################################################################################
-- НОВЫЕ РЕЦЕПТЫ ЖЕЛЕЗНЫХ СЛИТКОВ
-- ##############################################################################################
local remove_all_tech_unlocks = CTDmod.lib.recipe.remove_all_tech_unlocks
local add_tech_unlock = CTDmod.lib.recipe.add_tech_unlock
local tech = data.raw.technology
local item = data.raw.item
local recipe = data.raw.recipe
-- ##############################################################################################

-- ##############################################################################################
if item["CTD-sifted-crushed-copper-ore"] then
    data:extend({
        {
            type = "recipe",
            name = "CTD-copper-ingot",
            category = "smelting",
            energy_required = 32,
            enabled = true,
            ingredients = {{ type = "item", name = "CTD-sifted-crushed-copper-ore", amount = 12 }},
            results = {
                { type = "item", name = "se-copper-ingot", amount = 1 },
                { type = "item", name = "CTD-slag", amount = 2 }
            },
            main_product = "se-copper-ingot",
            allow_productivity = true
        }
    })
    recipe["se-copper-ingot-to-plate"].enabled = true
    remove_all_tech_unlocks("se-copper-ingot-to-plate")
    recipe["copper-plate"].hidden = true
end
-- ##############################################################################################