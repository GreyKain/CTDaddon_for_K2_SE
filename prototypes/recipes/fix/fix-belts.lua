-- ##############################################################################################
local recipe = data.raw.recipe
local replace_ingredient = CTDmod.lib.recipe.replace_ingredient
local change_ingredient_amount = CTDmod.lib.recipe.change_ingredient_amount
-- ##############################################################################################
-- ИЗМЕНЕНИЕ РЕЦЕПТА КОНВЕЙРА
-- ##############################################################################################
if mods["boblogistics"] then
    replace_ingredient("transport-belt", "iron-gear-wheel", "motor")
    change_ingredient_amount("transport-belt", "motor", 1)
    recipe["transport-belt"].energy_required = 1
end
-- ##############################################################################################