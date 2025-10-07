-- ##############################################################################################
-- НОВЫЕ РЕЦЕПТЫ ЖЕЛЕЗНЫХ СЛИТКОВ
-- ##############################################################################################
local remove_all_tech_unlocks = CTDmod.lib.recipe.remove_all_tech_unlocks
local add_tech_unlock = CTDmod.lib.recipe.add_tech_unlock
local change_tech_unlock = CTDmod.lib.recipe.change_tech_unlock
local tech = data.raw.technology
local item = data.raw.item
local recipe = data.raw.recipe
-- ##############################################################################################

-- ##############################################################################################
if recipe["CTD-iron-ingot"] then
    data:extend({
        {
            type = "recipe",
            name = "CTD-steel-ingot",
            category = "smelting",
            energy_required = 32,
            enabled = true,
            ingredients = {
                { type = "item", name = "se-iron-ingot", amount = 3 },
                { type = "item", name = "kr-coke", amount = 6 }
            },
            results = {
                { type = "item", name = "se-steel-ingot", amount = 1 },
                { type = "item", name = "CTD-slag", amount = 2 }
            },
            main_product = "se-steel-ingot",
            allow_productivity = true
        }
    })
    add_tech_unlock("CTD-steel-ingot", "steel-processing")
    change_tech_unlock("se-steel-ingot-to-plate", "se-pyroflux-smelting", "steel-processing")
    remove_all_tech_unlocks("steel-plate")
    recipe["steel-plate"].hidden = true
end
-- ##############################################################################################