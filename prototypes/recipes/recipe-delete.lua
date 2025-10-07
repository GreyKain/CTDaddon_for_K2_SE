-- ##############################################################################################
local remove = CTDmod.lib.recipe.completely_remove
local delete = CTDmod.lib.recipe.completely_delete
local safely_delete = CTDmod.lib.recipe.safely_delete
local remove_tech_unlock = CTDmod.lib.recipe.remove_tech_unlock
local recipe = data.raw.recipe
local item = data.raw.item
-- ##############################################################################################

-- ##############################################################################################
if mods ["boblogistics"] then
    delete("bob-steam-inserter")
    remove_tech_unlock("bob-oil-processing", "oil-processing")
    recipe["bob-oil-processing"] = nil
end
if item["CTD-burner-ore-crusher"] then
    remove_tech_unlock("kr-sand", "se-pulveriser")
    recipe["kr-sand"] = nil
end
-- ##############################################################################################