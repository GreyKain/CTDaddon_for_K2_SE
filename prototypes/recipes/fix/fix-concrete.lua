-- ##############################################################################################
local recipe = data.raw.recipe
local item = data.raw.item
local replace_ingredient = CTDmod.lib.recipe.replace_ingredient
local change_ingredient_amount = CTDmod.lib.recipe.change_ingredient_amount
-- ##############################################################################################
-- ИЗМЕНЕНИЕ РЕЦЕПТА КАМЕННЫХ БЛОКОВ
-- ##############################################################################################
if item["CTD-crushed-stone"] then
    replace_ingredient("concrete", "stone-brick", "CTD-crushed-stone")
    change_ingredient_amount("concrete", "CTD-crushed-stone", 20)
end
-- ##############################################################################################