-- ##############################################################################################
-- НОВЫЕ РЕЦЕПТЫ ПЕСКА
-- ##############################################################################################
local add_tech_unlock = CTDmod.lib.recipe.add_tech_unlock
local tech = data.raw.technology
local item = data.raw.item
local recipe = data.raw.recipe
-- ##############################################################################################
-- РЕЦЕПТ ПЕСКА ИЗ ЩЕБНЯ
-- ##############################################################################################
if item["CTD-crushed-stone"] then
    data:extend({
        {
            type = "recipe",
            name = "CTD-sand-from-crushed-stone",
            category = "CTD-ore-refining-t1",
            energy_required = 1,
            enabled = true,
            ingredients = {{type = "item", name = "CTD-crushed-stone", amount = 1}},
            results = {{type = "item", name = "kr-sand", amount = 1}},
            allow_productivity = true
        }
    })
end
-- ##############################################################################################
-- РЕЦЕПТ ПЕСКА ИЗ ШЛАКА
-- ##############################################################################################
if item["CTD-slag"] then
    data:extend({
        {
            type = "recipe",
            name = "CTD-sand-from-slag",
            category = "CTD-ore-refining-t1",
            energy_required = 3,
            enabled = false,
            ingredients = {{type = "item", name = "CTD-slag", amount = 1}},
            results = {{type = "item", name = "kr-sand", amount = 2}},
            allow_productivity = true
        }
    })
end
-- ##############################################################################################
-- ДОБАВЛЕНИЕ ТЕХ ЗАВИСИМОСТЕЙ ДЛЯ РЕЦЕПТОВ
-- ##############################################################################################
if tech["burner-mechanics"] then
    if recipe["CTD-sand-from-crushed-stone"] then
        add_tech_unlock("CTD-sand-from-crushed-stone", "burner-mechanics")
    end
    if recipe["CTD-sand-from-slag"] then
        add_tech_unlock("CTD-sand-from-slag", "burner-mechanics")
    end
end
-- ##############################################################################################