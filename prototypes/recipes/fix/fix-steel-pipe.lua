-- ##############################################################################################
local change_tech_unlock = CTDmod.lib.recipe.change_tech_unlock
local remove_tech_unlock = CTDmod.lib.recipe.remove_tech_unlock
local replace_ingredient_everywhere = CTDmod.lib.recipe.replace_ingredient_everywhere
local recipe = data.raw.recipe
local pipe = data.raw.pipe
local pipeground = data.raw["pipe-to-ground"]
local item = data.raw.item
-- ##############################################################################################
-- ИЗМЕНЕНИЕ СТАЛЬНЫХ ТРУБ
-- ##############################################################################################
if mods ["boblogistics"] then
    change_tech_unlock("kr-steel-pipe", "kr-steel-fluid-handling", "steel-processing")
    change_tech_unlock("kr-steel-pipe-to-ground", "kr-steel-fluid-handling", "steel-processing")
    remove_tech_unlock("bob-steel-pipe", "steel-processing")
    remove_tech_unlock("bob-steel-pipe-to-ground", "steel-processing")
    replace_ingredient_everywhere("bob-steel-pipe", "kr-steel-pipe")
    recipe["bob-steel-pipe"] = nil
    recipe["bob-steel-pipe-to-ground"] = nil
    item["bob-steel-pipe"].hidden = true
    item["bob-steel-pipe-to-ground"].hidden = true
    pipe["bob-steel-pipe"].hidden = true
    pipeground["bob-steel-pipe-to-ground"].hidden = true
end
-- ##############################################################################################