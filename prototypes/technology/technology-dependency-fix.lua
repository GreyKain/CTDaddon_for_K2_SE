-- ##############################################################################################
local add_dependency = CTDmod.lib.tech.add_dependency
local add_science_pack = CTDmod.lib.tech.add_science_pack
local completely_delete = CTDmod.lib.tech.completely_delete
local disable = CTDmod.lib.tech.disable
local get_recipe_effects = CTDmod.lib.tech.get_recipe_effects
local mass_add_dependencies = CTDmod.lib.tech.mass_add_dependencies
local remove_dependency = CTDmod.lib.tech.remove_dependency
local remove_recipe_effect = CTDmod.lib.tech.remove_recipe_effect
local remove_recipe_effects = CTDmod.lib.tech.remove_recipe_effects
local remove_science_pack = CTDmod.lib.tech.remove_science_pack_if_another_exists
local replace_dependency = CTDmod.lib.tech.replace_dependency
local replace_or_remove_dependencies = CTDmod.lib.tech.replace_or_remove_dependencies
local replace_science_pack_globally = CTDmod.lib.tech.replace_science_pack_globally
local transfer_effects = CTDmod.lib.tech.transfer_effects
local assembler = data.raw["assembling-machine"]
local furnace = data.raw.furnace
local item = data.raw.item
local recipe = data.raw.recipe
local tech = data.raw.technology
-- ##############################################################################################

-- ##############################################################################################
add_dependency("advanced-combinators", "chemical-science-pack")
add_dependency("advanced-oil-processing", "chemical-science-pack")
add_dependency("advanced-oil-processing", "oil-processing")
add_dependency("electric-energy-distribution-2", "chemical-science-pack")
add_dependency("gun-turret", "kr-automation-core")
add_dependency("inserter-stack-size-bonus-2", "chemical-science-pack")
add_dependency("kr-atmosphere-condensation", "chemical-science-pack")
add_dependency("kr-electric-mining-drill-mk2", "chemical-science-pack")
add_dependency("kr-reinforced-plates", "chemical-science-pack")
add_dependency("laser", "chemical-science-pack")
add_dependency("low-density-structure", "chemical-science-pack")
add_dependency("radar", "chemical-science-pack")
add_dependency("rocket-control-unit", "chemical-science-pack")
add_dependency("se-adaptive-armour-1", "chemical-science-pack")
add_dependency("se-heat-shielding", "chemical-science-pack")
add_dependency("toolbelt-2", "chemical-science-pack")
if mods ["robot_attrition"] then
	add_dependency("robot-attrition-explosion-safety", "utility-science-pack")
end
if mods ["boblogistics"] then
	add_dependency("bob-armoured-fluid-wagon", "chemical-science-pack")
	add_dependency("bob-armoured-railway", "chemical-science-pack")
	add_dependency("bob-express-inserter", "chemical-science-pack")
	add_dependency("bob-repair-pack-3", "chemical-science-pack")
end
if assembler["CTD-burner-ore-crusher"] then
	replace_dependency("kr-stone-processing", "kr-crusher", "kr-automation-core")
	remove_dependency("kr-crusher", "kr-automation-core")
	completely_delete("kr-crusher")
	recipe["kr-crusher"].hidden = true
	item["kr-crusher"].hidden = true
	furnace["kr-crusher"].hidden = true
end
if tech["ducts"] then
	add_dependency("ducts", "chemical-science-pack")
end
-- ##############################################################################################

-- ##############################################################################################
if mods ["Smart_Inserters"] then
	add_dependency("si-unlock-cross", "automation-science-pack")
	add_dependency("si-unlock-offsets", "automation-science-pack")
	add_dependency("si-unlock-x-diagonals", "logistic-science-pack")
end
-- ##############################################################################################