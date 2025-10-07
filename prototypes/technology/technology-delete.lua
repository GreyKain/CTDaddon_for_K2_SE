-- ##############################################################################################
local completely_delete = CTDmod.lib.tech.completely_delete
local disable = CTDmod.lib.tech.disable
local raw_tech = data.raw.technology
local remove_dependency = CTDmod.lib.tech.remove_dependency
local remove_recipe_effect = CTDmod.lib.tech.remove_recipe_effect
local remove_recipe_effects = CTDmod.lib.tech.remove_recipe_effects
-- ##############################################################################################
-- УДАЛЕНИЕ ТЕХНОЛОГИИ "БАЗОВАЯ ЛОГИСТИКА 1" ПРИ АКТИВНОМ МОДЕ "boblogistics"
-- ##############################################################################################
if mods ["boblogistics"] then
	completely_delete("basic-logistics")
end
-- ##############################################################################################