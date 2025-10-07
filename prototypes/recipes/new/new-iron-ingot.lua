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
if item["CTD-sifted-crushed-iron-ore"] then
    data:extend({
        {
            type = "recipe",
            name = "CTD-iron-ingot",
            category = "smelting",
            energy_required = 32,
            enabled = true,
            ingredients = {{ type = "item", name = "CTD-sifted-crushed-iron-ore", amount = 12 }},
            results = {
                { type = "item", name = "se-iron-ingot", amount = 1 },
                { type = "item", name = "CTD-slag", amount = 2 }
            },
            main_product = "se-iron-ingot",
            allow_productivity = true
        }
    })
    recipe["se-iron-ingot-to-plate"].enabled = true
    remove_all_tech_unlocks("se-iron-ingot-to-plate")
    recipe["iron-plate"].hidden = true
end
-- ##############################################################################################