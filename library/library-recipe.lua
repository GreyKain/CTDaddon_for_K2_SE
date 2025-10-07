-- ##############################################################################################
if not CTDmod.lib.recipe then CTDmod.lib.recipe = {} end
-- ##############################################################################################
--- Добавление ингредиента в рецепт:
-- @param recipe_name Название рецепта (string)
-- @param ingredient ингридиенты (table/string)
function CTDmod.lib.recipe.add_ingredient(recipe_name, ingredient)
    -- Проверка существования рецепта
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    -- Нормализация ингредиента (поддержка как таблицы, так и строки)
    local normalized_ingredient
    if type(ingredient) == "string" then
        normalized_ingredient = {
            type = "item",
            name = ingredient,
            amount = 1
        }
    else
        normalized_ingredient = {
            type = ingredient.type or "item",
            name = ingredient.name or ingredient[1],
            amount = ingredient.amount or ingredient[2] or 1
        }
    end

    if not normalized_ingredient.name then
        error("Не указано имя ингредиента!")
        return false
    end

    -- Функция добавления в конкретную часть рецепта
    local function add_to_recipe_part(recipe_part)
        if not recipe_part.ingredients then
            recipe_part.ingredients = {}
        end

        -- Проверяем, нет ли уже такого ингредиента
        for _, existing in ipairs(recipe_part.ingredients) do
            if (existing.name and existing.name == normalized_ingredient.name) or
               (existing[1] and existing[1] == normalized_ingredient.name) then
                log("Ингредиент '"..normalized_ingredient.name.."' уже есть в рецепте")
                return false
            end
        end

        -- Добавляем ингредиент в современном формате
        table.insert(recipe_part.ingredients, {
            type = normalized_ingredient.type,
            name = normalized_ingredient.name,
            amount = normalized_ingredient.amount
        })
        return true
    end

    local added = false

    -- Добавляем в разные варианты рецепта
    if recipe.normal then
        added = add_to_recipe_part(recipe.normal) or added
    end
    if recipe.expensive then
        added = add_to_recipe_part(recipe.expensive) or added
    end
    if not recipe.normal and not recipe.expensive then
        added = add_to_recipe_part(recipe) or added
    end

    if added then
        log("Ингредиент '"..normalized_ingredient.name.."' добавлен в рецепт '"..recipe_name.."'")
    end
    return added
end
-- ##############################################################################################
function CTDmod.lib.recipe.add_ingredient_at_position(recipe_name, ingredient, position)
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then error("Рецепт не найден!") end

    -- Нормализация ингредиента
    local normalized = type(ingredient) == "string" and {type="item", name=ingredient, amount=1} or
                      {type=ingredient.type or "item", name=ingredient.name or ingredient[1], amount=ingredient.amount or ingredient[2] or 1}

    -- Проверка на дубликаты
    for _, existing in ipairs(recipe.ingredients or {}) do
        if (existing.name or existing[1]) == normalized.name then
            log("Ингредиент уже есть: " .. normalized.name)
            return false
        end
    end

    -- Вставка на указанную позицию (если position=1 — в начало)
    table.insert(recipe.ingredients, position or #recipe.ingredients + 1, normalized)
    return true
end
-- ##############################################################################################
--- Замена ингредиента в рецепте:
function CTDmod.lib.recipe.replace_ingredient(recipe_name, old_ingredient, new_ingredient)
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    local replaced = false

    -- Функция замены в конкретной части рецепта
    local function replace_in_recipe_part(recipe_part)
        if not recipe_part.ingredients then return false end

        for _, ing in ipairs(recipe_part.ingredients) do
            -- Обрабатываем разные форматы ингредиентов
            if (ing.name and ing.name == old_ingredient) or
               (ing[1] and ing[1] == old_ingredient) then

                -- Сохраняем количество из старого ингредиента
                local amount = ing.amount or ing[2] or 1

                -- Заменяем ингредиент
                if ing.name then -- Современный формат
                    ing.name = new_ingredient.name or new_ingredient
                    ing.type = new_ingredient.type or "item"
                    ing.amount = new_ingredient.amount or amount
                else -- Старый формат [name, amount]
                    ing[1] = new_ingredient.name or new_ingredient
                    ing[2] = new_ingredient.amount or amount
                end

                return true
            end
        end
        return false
    end

    -- Заменяем в разных вариантах рецепта
    if recipe.normal then
        replaced = replace_in_recipe_part(recipe.normal) or replaced
    end
    if recipe.expensive then
        replaced = replace_in_recipe_part(recipe.expensive) or replaced
    end
    if not recipe.normal and not recipe.expensive then
        replaced = replace_in_recipe_part(recipe) or replaced
    end

    if replaced then
        log("В рецепте '"..recipe_name.."' ингредиент '"..old_ingredient.."' заменён на '"..(new_ingredient.name or new_ingredient).."'")
    else
        log("Ингредиент '"..old_ingredient.."' не найден в рецепте '"..recipe_name.."'")
    end
    return replaced
end
-- ##############################################################################################
--- Удаление ингредиента из рецепта:
function CTDmod.lib.recipe.remove_ingredient(recipe_name, ingredient_name)
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    local removed = false

    -- Функция удаления из конкретной части рецепта
    local function remove_from_recipe_part(recipe_part)
        if not recipe_part.ingredients then return false end

        for i = #recipe_part.ingredients, 1, -1 do
            local ing = recipe_part.ingredients[i]
            if (ing.name and ing.name == ingredient_name) or
               (ing[1] and ing[1] == ingredient_name) then
                table.remove(recipe_part.ingredients, i)
                return true
            end
        end
        return false
    end

    -- Удаляем из разных вариантов рецепта
    if recipe.normal then
        removed = remove_from_recipe_part(recipe.normal) or removed
    end
    if recipe.expensive then
        removed = remove_from_recipe_part(recipe.expensive) or removed
    end
    if not recipe.normal and not recipe.expensive then
        removed = remove_from_recipe_part(recipe) or removed
    end

    if removed then
        log("Ингредиент '"..ingredient_name.."' удалён из рецепта '"..recipe_name.."'")
    else
        log("Ингредиент '"..ingredient_name.."' не найден в рецепте '"..recipe_name.."'")
    end
    return removed
end
-- ##############################################################################################
--- Изменение количества ингредиента:
function CTDmod.lib.recipe.change_ingredient_amount(recipe_name, ingredient_name, new_amount)
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    local changed = false

    -- Функция изменения в конкретной части рецепта
    local function change_in_recipe_part(recipe_part)
        if not recipe_part.ingredients then return false end

        for _, ing in ipairs(recipe_part.ingredients) do
            if (ing.name and ing.name == ingredient_name) or
               (ing[1] and ing[1] == ingredient_name) then

                if ing.amount then -- Современный формат
                    ing.amount = new_amount
                else -- Старый формат
                    ing[2] = new_amount
                end

                return true
            end
        end
        return false
    end

    -- Изменяем в разных вариантах рецепта
    if recipe.normal then
        changed = change_in_recipe_part(recipe.normal) or changed
    end
    if recipe.expensive then
        changed = change_in_recipe_part(recipe.expensive) or changed
    end
    if not recipe.normal and not recipe.expensive then
        changed = change_in_recipe_part(recipe) or changed
    end

    if changed then
        log("Количество ингредиента '"..ingredient_name.."' в рецепте '"..recipe_name.."' изменено на "..new_amount)
    else
        log("Ингредиент '"..ingredient_name.."' не найден в рецепте '"..recipe_name.."'")
    end
    return changed
end
-- ##############################################################################################
--- Добавляет технологическую зависимость для рецепта
function CTDmod.lib.recipe.add_tech_unlock(recipe_name, technology_name)
    -- Проверяем существование рецепта
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    -- Проверяем существование технологии
    if not data.raw.technology[technology_name] then
        error("Технология '"..technology_name.."' не найдена!")
        return false
    end

    -- Функция для установки зависимости в конкретной части рецепта
    local function set_tech_dependency(recipe_part)
        recipe_part.enabled = false  -- Рецепт теперь требует технологию
        recipe_part.technology = technology_name
    end

    -- Обрабатываем разные форматы рецептов
    if recipe.normal then
        set_tech_dependency(recipe.normal)
    end
    if recipe.expensive then
        set_tech_dependency(recipe.expensive)
    end
    if not recipe.normal and not recipe.expensive then
        set_tech_dependency(recipe)
    end

    -- Добавляем разблокировку рецепта в технологию
    if not data.raw.technology[technology_name].effects then
        data.raw.technology[technology_name].effects = {}
    end

    table.insert(data.raw.technology[technology_name].effects, {
        type = "unlock-recipe",
        recipe = recipe_name
    })

    log("Рецепт '"..recipe_name.."' теперь требует технологию '"..technology_name.."'")
    return true
end
-- ##############################################################################################
--- Функция для замены технологии разблокировки конкретного рецепта
function CTDmod.lib.recipe.change_tech_unlock(recipe_name, old_tech, new_tech)
    -- Получаем рецепт из данных игры
    local recipe = data.raw.recipe[recipe_name]

    if not recipe then
        error("Рецепт '" .. recipe_name .. "' не найден!")
        return
    end

    -- Обрабатываем разные форматы рецептов (нормальный/дорогой/простой)
    if recipe.normal then
        if recipe.normal.prerequisites == old_tech then
            recipe.normal.prerequisites = new_tech
        end
    end

    if recipe.expensive then
        if recipe.expensive.prerequisites == old_tech then
            recipe.expensive.prerequisites = new_tech
        end
    end

    -- Для простого рецепта (без нормального/дорогого вариантов)
    if not recipe.normal and not recipe.expensive then
        if recipe.prerequisites == old_tech then
            recipe.prerequisites = new_tech
        end
    end

    -- Дополнительно обновляем технологию, если рецепт в её эффектах
    for _, tech in pairs(data.raw.technology) do
        if tech.effects then
            for _, effect in ipairs(tech.effects) do
                if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
                    if tech.name == old_tech then
                        -- Создаём эффект в новой технологии
                        table.insert(data.raw.technology[new_tech].effects, {
                            type = "unlock-recipe",
                            recipe = recipe_name
                        })
                        -- Удаляем эффект из старой технологии
                        for i, eff in ipairs(tech.effects) do
                            if eff.type == "unlock-recipe" and eff.recipe == recipe_name then
                                table.remove(tech.effects, i)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end
-- ##############################################################################################
-- ##############################################################################################
--- Удаляет технологическую зависимость для рецепта
function CTDmod.lib.recipe.remove_tech_unlock(recipe_name, technology_name)
    -- Проверяем существование рецепта
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    local removed_from_recipe = false
    local removed_from_tech = false

    -- Функция для удаления зависимости из конкретной части рецепта
    local function remove_tech_dependency(recipe_part)
        if recipe_part and recipe_part.technology == technology_name then
            recipe_part.technology = nil
            recipe_part.enabled = true  -- Делаем рецепт доступным по умолчанию
            removed_from_recipe = true
        end
    end

    -- Обрабатываем разные форматы рецептов
    if recipe.normal then
        remove_tech_dependency(recipe.normal)
    end
    if recipe.expensive then
        remove_tech_dependency(recipe.expensive)
    end
    if not recipe.normal and not recipe.expensive then
        remove_tech_dependency(recipe)
    end

    -- Удаляем разблокировку рецепта из технологии
    if data.raw.technology[technology_name] and data.raw.technology[technology_name].effects then
        local tech = data.raw.technology[technology_name]
        for i = #tech.effects, 1, -1 do
            local effect = tech.effects[i]
            if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
                table.remove(tech.effects, i)
                removed_from_tech = true
            end
        end

        -- Если эффектов не осталось, удаляем пустую таблицу
        if tech.effects and #tech.effects == 0 then
            tech.effects = nil
        end
    end

    if removed_from_recipe or removed_from_tech then
        log("Удалена технологическая зависимость: рецепт '"..recipe_name.."' больше не требует технологию '"..technology_name.."'")
        return true
    else
        log("Технологическая зависимость не найдена: рецепт '"..recipe_name.."' не связан с технологией '"..technology_name.."'")
        return false
    end
end
-- ##############################################################################################

-- ##############################################################################################
--- Полностью удаляет все технологические зависимости рецепта
function CTDmod.lib.recipe.remove_all_tech_unlocks(recipe_name)
    -- Проверяем существование рецепта
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    local removed_count = 0
    local technologies_found = {}

    -- Функция для сбора информации о технологиях из рецепта
    local function collect_tech_from_recipe(recipe_part)
        if recipe_part and recipe_part.technology then
            table.insert(technologies_found, recipe_part.technology)
            recipe_part.technology = nil
            recipe_part.enabled = true
        end
    end

    -- Собираем технологии из всех частей рецепта
    if recipe.normal then
        collect_tech_from_recipe(recipe.normal)
    end
    if recipe.expensive then
        collect_tech_from_recipe(recipe.expensive)
    end
    if not recipe.normal and not recipe.expensive then
        collect_tech_from_recipe(recipe)
    end

    -- Удаляем рецепт из всех технологий
    for _, tech_name in ipairs(technologies_found) do
        if data.raw.technology[tech_name] and data.raw.technology[tech_name].effects then
            local tech = data.raw.technology[tech_name]
            for i = #tech.effects, 1, -1 do
                local effect = tech.effects[i]
                if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
                    table.remove(tech.effects, i)
                    removed_count = removed_count + 1
                end
            end

            -- Если эффектов не осталось, удаляем пустую таблицу
            if tech.effects and #tech.effects == 0 then
                tech.effects = nil
            end
        end
    end

    -- Также проверяем все технологии на случай если рецепт есть в технологии, но не указан в recipe.technology
    for tech_name, tech in pairs(data.raw.technology) do
        if tech.effects then
            for i = #tech.effects, 1, -1 do
                local effect = tech.effects[i]
                if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
                    table.remove(tech.effects, i)
                    removed_count = removed_count + 1
                    table.insert(technologies_found, tech_name)
                end
            end

            if tech.effects and #tech.effects == 0 then
                tech.effects = nil
            end
        end
    end

    if removed_count > 0 then
        log("Удалены все технологические зависимости рецепта '"..recipe_name.."' из "..removed_count.." технологий")
        return true
    else
        log("У рецепта '"..recipe_name.."' не найдено технологических зависимостей")
        return false
    end
end
-- ##############################################################################################

-- ##############################################################################################
--- Получает список технологий, которые разблокируют рецепт
function CTDmod.lib.recipe.get_tech_unlocks(recipe_name)
    -- Проверяем существование рецепта
    if not data.raw.recipe[recipe_name] then
        error("Рецепт '"..recipe_name.."' не найден!")
        return nil
    end

    local technologies = {}

    -- Проверяем технологии, указанные в рецепте
    local recipe = data.raw.recipe[recipe_name]

    local function check_recipe_part(recipe_part)
        if recipe_part and recipe_part.technology then
            table.insert(technologies, recipe_part.technology)
        end
    end

    if recipe.normal then
        check_recipe_part(recipe.normal)
    end
    if recipe.expensive then
        check_recipe_part(recipe.expensive)
    end
    if not recipe.normal and not recipe.expensive then
        check_recipe_part(recipe)
    end

    -- Проверяем все технологии на наличие разблокировки рецепта
    for tech_name, tech in pairs(data.raw.technology) do
        if tech.effects then
            for _, effect in ipairs(tech.effects) do
                if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
                    if not table.contains(technologies, tech_name) then
                        table.insert(technologies, tech_name)
                    end
                end
            end
        end
    end

    return technologies
end
-- ##############################################################################################

-- ##############################################################################################
--- Проверяет, требует ли рецепт определенную технологию
function CTDmod.lib.recipe.requires_technology(recipe_name, technology_name)
    local unlocks = CTDmod.lib.recipe.get_tech_unlocks(recipe_name)
    if not unlocks then return false end

    return table.contains(unlocks, technology_name)
end
-- ##############################################################################################

-- ##############################################################################################
--- Функция для замены ингредиента во всех рецептах
function CTDmod.lib.recipe.replace_ingredient_everywhere(old_item, new_item)
    -- Перебираем все рецепты в игре
    for _, recipe in pairs(data.raw.recipe) do
        -- Проверяем обычные ингредиенты
        if recipe.ingredients then
            for _, ingredient in pairs(recipe.ingredients) do
                -- Обрабатываем разные форматы ингредиентов
                if ingredient.name and ingredient.name == old_item then
                    ingredient.name = new_item
                elseif ingredient[1] and ingredient[1] == old_item then
                    ingredient[1] = new_item
                end
            end
        end

        -- Проверяем дорогие рецепты (expensive)
        if recipe.expensive and recipe.expensive.ingredients then
            for _, ingredient in pairs(recipe.expensive.ingredients) do
                if ingredient.name and ingredient.name == old_item then
                    ingredient.name = new_item
                elseif ingredient[1] and ingredient[1] == old_item then
                    ingredient[1] = new_item
                end
            end
        end

        -- Проверяем нормальные рецепты (normal)
        if recipe.normal and recipe.normal.ingredients then
            for _, ingredient in pairs(recipe.normal.ingredients) do
                if ingredient.name and ingredient.name == old_item then
                    ingredient.name = new_item
                elseif ingredient[1] and ingredient[1] == old_item then
                    ingredient[1] = new_item
                end
            end
        end
    end

    -- Также проверяем технологии, которые могут требовать предмет для исследования
    for _, tech in pairs(data.raw.technology) do
        if tech.unit and tech.unit.ingredients then
            for _, ingredient in pairs(tech.unit.ingredients) do
                if ingredient.name and ingredient.name == old_item then
                    ingredient.name = new_item
                elseif ingredient[1] and ingredient[1] == old_item then
                    ingredient[1] = new_item
                end
            end
        end
    end
end
-- ##############################################################################################
--- Функция клонирования рецепта с заменой параметров:
function CTDmod.lib.recipe.duplicate(original_name, new_name, params)
    -- Проверка существования оригинального рецепта
    local original = data.raw.recipe[original_name]
    if not original then
        error("Рецепт '"..original_name.."' не найден!")
        return false
    end

    -- Проверка на существование нового рецепта
    if data.raw.recipe[new_name] then
        error("Рецепт '"..new_name.."' уже существует!")
        return false
    end

    -- 1. Автоматическое создание категории (если указана и не существует)
    if params and params.category and not data.raw["recipe-category"][params.category] then
        data:extend({{
            type = "recipe-category",
            name = params.category
        }})
    end

    -- 2. Глубокое копирование рецепта
    local copy = table.deepcopy(original)
    copy.name = new_name

    -- 3. Обновление параметров
    if params then
        -- Категория
        if params.category then
            copy.category = params.category
            if copy.normal then
                copy.normal.category = params.category
            end
            if copy.expensive then
                copy.expensive.category = params.category
            end
        end

        -- Основные параметры
        if params.ingredients then
            copy.ingredients = params.ingredients
        end
        if params.result then
            copy.result = params.result
        end
        if params.results then
            copy.results = params.results
        end
        if params.energy_required then
            copy.energy_required = params.energy_required
        end
        if params.enabled then
            copy.enabled = params.enabled
        end
        if params.main_product then
            copy.main_product = params.main_product
        end

        -- Для рецептов с normal/expensive версиями
        if copy.normal then
            if params.ingredients then
                copy.normal.ingredients = params.ingredients
            end
            if params.results then
                copy.normal.results = params.results
            end
            if params.energy_required then
                copy.normal.energy_required = params.energy_required
            end
            if params.main_product then
                copy.normal.main_product = params.main_product
            end
        end

        if copy.expensive then
            if params.ingredients then
                copy.expensive.ingredients = params.ingredients
            end
            if params.results then
                copy.expensive.results = params.results
            end
            if params.energy_required then
                copy.expensive.energy_required = params.energy_required
            end
            if params.main_product then
                copy.expensive.main_product = params.main_product
            end
        end
    end

    -- 4. Добавление рецепта в игру
    data:extend({copy})

    -- 5. Поиск и копирование привязки к технологии
    for _, tech in pairs(data.raw.technology) do
        if tech.effects then
            for _, effect in ipairs(tech.effects) do
                if effect.type == "unlock-recipe" and effect.recipe == original_name then
                    -- Добавляем новый рецепт в ту же технологию
                    table.insert(tech.effects, {
                        type = "unlock-recipe",
                        recipe = new_name
                    })
                    log("Добавлен рецепт '"..new_name.."' в технологию '"..tech.name.."'")
                    break
                end
            end
        end
    end

    log("Создан рецепт '"..new_name.."' на основе '"..original_name.."'")
    return true
end
-- ##############################################################################################
--- Функция клонирования рецепта с заменой параметров и скрытием старого:
function CTDmod.lib.recipe.duplicate_with_hide(original_name, new_name, params)
    -- Проверка существования оригинального рецепта
    local original = data.raw.recipe[original_name]
    if not original then
        error("Рецепт '"..original_name.."' не найден!")
        return false
    end

    -- Проверка на существование нового рецепта
    if data.raw.recipe[new_name] then
        error("Рецепт '"..new_name.."' уже существует!")
        return false
    end

    -- 1. Автоматическое создание категории (если указана и не существует)
    if params and params.category and not data.raw["recipe-category"][params.category] then
        data:extend({{
            type = "recipe-category",
            name = params.category
        }})
    end

    -- 2. Глубокое копирование рецепта
    local copy = table.deepcopy(original)
    copy.name = new_name

    -- 3. Обновление параметров
    if params then
        -- Категория
        if params.category then
            copy.category = params.category
            if copy.normal then
                copy.normal.category = params.category
            end
            if copy.expensive then
                copy.expensive.category = params.category
            end
        end

        -- Другие параметры (опционально)
        if params.ingredients then
            copy.ingredients = params.ingredients
        end
        if params.result then
            copy.result = params.result
        end
        if params.results then
            copy.results = params.results
        end
        if params.energy_required then
            copy.energy_required = params.energy_required
        end
        if params.enabled then
            copy.enabled = params.enabled
        end
    end

    -- 4. Добавление рецепта в игру
    data:extend({copy})

    -- 5. Скрываем оригинальный рецепт от игрока
    original.hide_from_player_crafting = true
    if original.normal then
        original.normal.hide_from_player_crafting = true
    end
    if original.expensive then
        original.expensive.hide_from_player_crafting = true
    end

    -- 6. Поиск и копирование привязки к технологии
    for _, tech in pairs(data.raw.technology) do
        if tech.effects then
            for _, effect in ipairs(tech.effects) do
                if effect.type == "unlock-recipe" and effect.recipe == original_name then
                    -- Добавляем новый рецепт в ту же технологию
                    table.insert(tech.effects, {
                        type = "unlock-recipe",
                        recipe = new_name
                    })
                    log("Добавлен рецепт '"..new_name.."' в технологию '"..tech.name.."'")
                    break
                end
            end
        end
    end

    return true
end
-- Пример использования:
-- Создаёт копию рецепта с новыми параметрами, сохраняя привязку к технологии и скрывает старый рецеп из ручного крафта
-- CTDmod.lib.recipe.duplicate_with_hide(
--     "small-electric-pole", 
--     "CTD-small-electric-pole-handmade", 
--     {
--         category = "CTD-handmade",  -- Автоматически создаст категорию
--         energy_required = 2.0        -- Можно изменить параметры
--     }
-- )
-- ##############################################################################################

-- ##############################################################################################
--- Создание копии рецепта с добавлением побочного продукта
function CTDmod.lib.recipe.duplicate_with_byproduct(original_name, new_name, byproduct_item, byproduct_amount, byproduct_probability)
    -- Проверка существования оригинального рецепта
    local original = data.raw.recipe[original_name]
    if not original then
        error("Рецепт '"..original_name.."' не найден!")
        return false
    end

    -- Проверка существования побочного предмета
    if not data.raw.item[byproduct_item] then
        error("Побочный предмет '"..byproduct_item.."' не найден!")
        return false
    end

    -- Проверка на существование нового рецепта
    if data.raw.recipe[new_name] then
        error("Рецепт '"..new_name.."' уже существует!")
        return false
    end

    -- Глубокое копирование рецепта
    local copy = table.deepcopy(original)
    copy.name = new_name
    byproduct_amount = byproduct_amount or 1
    byproduct_probability = byproduct_probability or 1.0

    -- Функция для добавления побочного продукта к результатам
    local function add_byproduct_to_results(results)
        if not results then return nil end

        local new_results = table.deepcopy(results)
        table.insert(new_results, {
            type = "item",
            name = byproduct_item,
            amount = byproduct_amount,
            probability = byproduct_probability
        })
        return new_results
    end

    -- Обрабатываем разные форматы рецептов
    if copy.normal or copy.expensive then
        -- Рецепт с normal/expensive версиями
        if copy.normal then
            copy.normal.results = add_byproduct_to_results(copy.normal.results)
        end
        if copy.expensive then
            copy.expensive.results = add_byproduct_to_results(copy.expensive.results)
        end
    else
        -- Обычный рецепт
        copy.results = add_byproduct_to_results(copy.results)
    end

    -- Добавляем рецепт в игру
    data:extend({copy})

    -- Копируем привязку к технологиям
    for _, tech in pairs(data.raw.technology) do
        if tech.effects then
            for _, effect in ipairs(tech.effects) do
                if effect.type == "unlock-recipe" and effect.recipe == original_name then
                    table.insert(tech.effects, {
                        type = "unlock-recipe",
                        recipe = new_name
                    })
                    log("Добавлен рецепт '"..new_name.."' в технологию '"..tech.name.."'")
                    break
                end
            end
        end
    end

    log("Создан рецепт '"..new_name.."' с побочным продуктом '"..byproduct_item.."'")
    return true
end
-- ##############################################################################################
--- Функция клонирования параметров из одного рецепта в другой:
function CTDmod.lib.recipe.copy_parameters(source_name, target_name, parameters_to_copy)
    -- Проверка существования рецептов
    local source = data.raw.recipe[source_name]
    if not source then
        error("Исходный рецепт '"..source_name.."' не найден!")
        return false
    end

    local target = data.raw.recipe[target_name]
    if not target then
        error("Целевой рецепт '"..target_name.."' не найден!")
        return false
    end

    -- Проверка параметров для копирования
    if type(parameters_to_copy) ~= "table" then
        error("Параметры для копирования должны быть таблицей!")
        return false
    end

    -- Функция для копирования параметров между частями рецепта
    local function copy_params(src, dst)
        for _, param in ipairs(parameters_to_copy) do
            if src[param] ~= nil then
                dst[param] = table.deepcopy(src[param])
                log("Скопирован параметр '"..param.."'")
            end
        end
    end

    -- Копируем основные параметры
    copy_params(source, target)

    -- Обрабатываем варианты сложности (normal/expensive)
    if source.normal and target.normal then
        copy_params(source.normal, target.normal)
    end

    if source.expensive and target.expensive then
        copy_params(source.expensive, target.expensive)
    end

    log("Параметры успешно скопированы из '"..source_name.."' в '"..target_name.."'")
    return true
end
-- ##############################################################################################
--- Функция для удаления рецепта из игры:
function CTDmod.lib.recipe.completely_remove(recipe_name)
    -- Проверяем существование рецепта
    if not data.raw.recipe[recipe_name] then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    -- 1. Удаляем из технологий (эффекты разблокировки)
    for _, tech in pairs(data.raw.technology) do
        if tech.effects then
            for i = #tech.effects, 1, -1 do
                local effect = tech.effects[i]
                if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
                    table.remove(tech.effects, i)
                end
            end
        end
    end

    -- 2. Удаляем из ингредиентов других рецептов
    for _, recipe in pairs(data.raw.recipe) do
        -- Обрабатываем обычные ингредиенты
        if recipe.ingredients then
            for i = #recipe.ingredients, 1, -1 do
                local ing = recipe.ingredients[i]
                if (ing.name and ing.name == recipe_name) or
                   (ing[1] and ing[1] == recipe_name) then
                    table.remove(recipe.ingredients, i)
                end
            end
        end

        -- Обрабатываем дорогие рецепты (expensive)
        if recipe.expensive and recipe.expensive.ingredients then
            for i = #recipe.expensive.ingredients, 1, -1 do
                local ing = recipe.expensive.ingredients[i]
                if (ing.name and ing.name == recipe_name) or
                   (ing[1] and ing[1] == recipe_name) then
                    table.remove(recipe.expensive.ingredients, i)
                end
            end
        end

        -- Обрабатываем нормальные рецепты (normal)
        if recipe.normal and recipe.normal.ingredients then
            for i = #recipe.normal.ingredients, 1, -1 do
                local ing = recipe.normal.ingredients[i]
                if (ing.name and ing.name == recipe_name) or
                   (ing[1] and ing[1] == recipe_name) then
                    table.remove(recipe.normal.ingredients, i)
                end
            end
        end
    end

    -- 3. Делаем рецепт полностью недоступным
    local recipe = data.raw.recipe[recipe_name]
    recipe.enabled = false
    recipe.hidden = true
    recipe.hide_from_player_crafting = true
    recipe.hide_from_stats = true

    -- Для рецептов с разными сложностями
    if recipe.normal then
        recipe.normal.enabled = false
        recipe.normal.hidden = true
        recipe.normal.hide_from_player_crafting = true
    end
    if recipe.expensive then
        recipe.expensive.enabled = false
        recipe.expensive.hidden = true
        recipe.expensive.hide_from_player_crafting = true
    end

    log("Рецепт '"..recipe_name.."' полностью удалён из игры")
    return true
end

-- --- Версия с полным удалением объекта:
-- function CTDmod.lib.recipe.completely_delete(recipe_name)
--     CTDmod.lib.recipe.completely_remove(recipe_name)
--     data.raw.recipe[recipe_name] = nil
-- end
function CTDmod.lib.recipe.completely_delete(recipe_name)
    if not data.raw.recipe[recipe_name] then return false end

    -- 1. Собираем все предметы из результатов рецепта
    local result_items = {}
    local recipe = data.raw.recipe[recipe_name]

    local function collect_results(r)
        if r.result then
            result_items[r.result] = true
        end
        if r.results then
            for _, res in ipairs(r.results) do
                result_items[res.name or res[1]] = true
            end
        end
    end

    collect_results(recipe)
    if recipe.normal then collect_results(recipe.normal) end
    if recipe.expensive then collect_results(recipe.expensive) end

    -- 2. Обрабатываем предметы и связанные сущности
    for item_name, _ in pairs(result_items) do
        -- Находим предмет
        local item = data.raw.item[item_name] or data.raw.tool[item_name] or
                    data.raw.ammo[item_name] or data.raw.capsule[item_name] or
                    data.raw.module[item_name] or data.raw.gun[item_name] or
                    data.raw.armor[item_name]

        if item then
            -- Сначала обрабатываем связанные сущности (если есть place_result)
            if item.place_result then
                for _, entity_type in ipairs({
                    "inserter", "assembling-machine", "furnace", "mining-drill",
                    "lab", "transport-belt", "container", "wall", "reactor",
                    "boiler", "generator", "solar-panel", "accumulator",
                    "radar", "beacon", "roboport", "turret", "car", "locomotive"
                }) do
                    local entity = data.raw[entity_type] and data.raw[entity_type][item.place_result]
                    if entity then
                        -- Критически важная последовательность:
                        -- 1. Сначала убираем mining result если он ссылается на наш предмет
                        if entity.mineable and (entity.mineable.result == item_name or
                           (entity.mineable.results and #entity.mineable.results > 0)) then
                            entity.mineable = nil -- Полностью отключаем добычу
                        end

                        -- 2. Затем удаляем цепочку апгрейдов
                        entity.next_upgrade = nil

                        -- 3. Только потом скрываем сущность
                        entity.hidden = true
                        entity.hidden_in_factoriopedia = true
                    end
                end
            end

            -- Скрываем сам предмет
            item.hidden = true
            item.hidden_in_factoriopedia = true
        end
    end

    -- 3. Удаляем сам рецепт и все его упоминания
    data.raw.recipe[recipe_name] = nil

    -- 4. Чистим упоминания в технологиях
    for _, tech in pairs(data.raw.technology) do
        if tech.effects then
            for i = #tech.effects, 1, -1 do
                if tech.effects[i].type == "unlock-recipe" and tech.effects[i].recipe == recipe_name then
                    table.remove(tech.effects, i)
                end
            end
        end
    end

    -- 5. Чистим упоминания в ингредиентах других рецептов
    for _, other_recipe in pairs(data.raw.recipe) do
        local function clean_ingredients(ingredients)
            if not ingredients then return end
            for i = #ingredients, 1, -1 do
                local ing = ingredients[i]
                if (ing.name and ing.name == recipe_name) or (ing[1] and ing[1] == recipe_name) then
                    table.remove(ingredients, i)
                end
            end
        end

        clean_ingredients(other_recipe.ingredients)
        if other_recipe.normal then clean_ingredients(other_recipe.normal.ingredients) end
        if other_recipe.expensive then clean_ingredients(other_recipe.expensive.ingredients) end
    end

    log("Рецепт '"..recipe_name.."' и связанные объекты полностью удалены")
    return true
end
-- ##############################################################################################
--- Полностью удаляет рецепт (оригинальная функция с улучшениями)
-- @param recipe_name string - Название рецепта для удаления
-- @return boolean - Успешно ли выполнено удаление
function CTDmod.lib.recipe.completely_delete_2(recipe_name)
    -- Проверяем существование рецепта
    if not data.raw.recipe[recipe_name] then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    -- 1. Удаляем рецепт из технологий разблокировки
    for tech_name, tech in pairs(data.raw.technology) do
        if tech.effects then
            for i = #tech.effects, 1, -1 do
                local effect = tech.effects[i]
                if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
                    table.remove(tech.effects, i)
                end
            end

            -- Удаляем пустые таблицы effects
            if tech.effects and #tech.effects == 0 then
                tech.effects = nil
            end
        end
    end

    -- 2. Полностью удаляем рецепт
    data.raw.recipe[recipe_name] = nil

    log("Рецепт '"..recipe_name.."' полностью удален из игры")
    return true
end
-- ##############################################################################################
-- ##############################################################################################
--- Функция для изменения параметров рецепта с учетом normal/expensive версий
-- @param recipe_name Название рецепта (string)
-- @param changes Таблица изменений (table)
function CTDmod.lib.recipe.modify(recipe_name, changes)
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then
        log("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    -- Функция для применения изменений к конкретной версии рецепта
    local function apply_changes(recipe_table)
        for key, value in pairs(changes) do
            -- Особые случаи для ingredients и results
            if key == "ingredients" or key == "results" then
                if type(value) == "function" then
                    -- Если передана функция-обработчик
                    recipe_table[key] = value(recipe_table[key] or {})
                else
                    -- Если переданы готовые значения
                    recipe_table[key] = value
                end
            else
                -- Обычные параметры
                recipe_table[key] = value
            end
        end
    end

    -- Применяем изменения к основной версии (если не сложный рецепт)
    if not (recipe.normal or recipe.expensive) then
        apply_changes(recipe)
    else
        -- Обрабатываем normal версию
        if recipe.normal then
            apply_changes(recipe.normal)
        end

        -- Обрабатываем expensive версию
        if recipe.expensive then
            apply_changes(recipe.expensive)
        end

        -- Общие параметры (если нужно изменить что-то для всех версий)
        if changes.category or changes.main_product then
            apply_changes(recipe)
        end
    end

    log("Рецепт '"..recipe_name.."' успешно изменен")
    return true
end
-- ##############################################################################################
--- Устанавливает время крафта для рецепта (energy_required)
-- @param recipe_name Название рецепта (string)
-- @param new_energy Новое значение времени крафта (number)
function CTDmod.lib.recipe.set_energy_required(recipe_name, new_energy)
    -- Проверяем существование рецепта
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then
        log("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    -- Проверяем корректность нового значения
    if type(new_energy) ~= "number" or new_energy <= 0 then
        log("Некорректное значение energy_required: "..tostring(new_energy))
        return false
    end

    -- Функция для изменения конкретной версии рецепта
    local function modify_energy(recipe_table)
        recipe_table.energy_required = new_energy
    end

    -- Обычный рецепт
    if not (recipe.normal or recipe.expensive) then
        modify_energy(recipe)
    else
        -- Рецепт с normal/expensive версиями
        if recipe.normal then
            modify_energy(recipe.normal)
        end
        if recipe.expensive then
            modify_energy(recipe.expensive)
        end
    end

    log("Время крафта для '"..recipe_name.."' установлено в "..new_energy)
    return true
end
-- ##############################################################################################

-- ##############################################################################################
--- Безопасно удаляет рецепт, сохраняя сигнал предмета в игре
-- @param recipe_name string - Название рецепта для удаления
-- @return boolean - Успешно ли выполнено удаление
function CTDmod.lib.recipe.safely_delete(recipe_name)
    -- Проверяем существование рецепта
    if not data.raw.recipe[recipe_name] then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    local recipe = data.raw.recipe[recipe_name]
    local result_item = nil
    local result_amount = 1

    -- Определяем какой предмет производит рецепт и его количество
    if recipe.result then
        result_item = recipe.result
        result_amount = recipe.result_count or 1
    elseif recipe.results then
        for _, result in ipairs(recipe.results) do
            if result.type == "item" then
                result_item = result.name
                result_amount = result.amount or 1
                break
            elseif type(result) == "table" and result[1] then
                result_item = result[1]
                result_amount = result[2] or 1
                break
            end
        end
    end

    -- Если не удалось определить предмет - обычное удаление
    if not result_item then
        log("Не удалось определить предмет рецепта '"..recipe_name.."', выполняется обычное удаление")
        return CTDmod.lib.recipe.completely_delete(recipe_name)
    end

    -- 1. Удаляем рецепт из технологий разблокировки
    for tech_name, tech in pairs(data.raw.technology) do
        if tech.effects then
            for i = #tech.effects, 1, -1 do
                local effect = tech.effects[i]
                if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
                    table.remove(tech.effects, i)
                    log("Удален эффект разблокировки рецепта '"..recipe_name.."' из технологии '"..tech_name.."'")
                end
            end

            -- Удаляем пустые таблицы effects
            if tech.effects and #tech.effects == 0 then
                tech.effects = nil
            end
        end
    end

    -- 2. Создаем виртуальный рецепт для сохранения сигнала (современный формат)
    if not data.raw.recipe["CTD-virtual-"..recipe_name] then
        data:extend({
            {
                type = "recipe",
                name = "CTD-virtual-"..recipe_name,
                localised_name = {"recipe-name."..recipe_name},
                category = "crafting",
                hidden = true,
                enabled = false,
                energy_required = 0.1,
                ingredients = {},
                results = {
                    {
                        type = "item",
                        name = result_item,
                        amount = result_amount
                    }
                },
                subgroup = "virtual-signal",
                order = "z[virtual]"
            }
        })
        log("Создан виртуальный рецепт для сохранения сигнала: CTD-virtual-"..recipe_name)
    end

    -- 3. Полностью удаляем оригинальный рецепт
    data.raw.recipe[recipe_name] = nil

    log("Рецепт '"..recipe_name.."' безопасно удален, сигнал предмета сохранен")
    return true
end
-- ##############################################################################################

-- ##############################################################################################
--- Создает виртуальный сигнал для предмета (современный формат)
-- @param item_name string - Название предмета
-- @return boolean - Успешно ли создан сигнал
function CTDmod.lib.recipe.create_virtual_signal(item_name)
    if not data.raw.item[item_name] then
        error("Предмет '"..item_name.."' не найден!")
        return false
    end

    -- Создаем виртуальный рецепт для сигнала
    if not data.raw.recipe["CTD-virtual-signal-"..item_name] then
        data:extend({
            {
                type = "recipe",
                name = "CTD-virtual-signal-"..item_name,
                localised_name = {"item-name."..item_name},
                category = "crafting",
                hidden = true,
                enabled = false,
                energy_required = 0.1,
                ingredients = {},
                results = {
                    {
                        type = "item",
                        name = item_name,
                        amount = 1
                    }
                },
                subgroup = "virtual-signal",
                order = "z[virtual]"
            }
        })
        log("Создан виртуальный сигнал для предмета: CTD-virtual-signal-"..item_name)
        return true
    end

    return false
end
-- ##############################################################################################

-- ##############################################################################################
--- Удаляет ingredient2 из рецептов, которые содержат и ingredient1 и ingredient2
-- @param item1 string - Первый предмет (условие поиска)
-- @param item2 string - Второй предмет (который нужно удалить)
-- @return table - Список измененных рецептов
function CTDmod.lib.recipe.remove_ingredient_if_another_exists(item1, item2)
    local modified_recipes = {}

    -- Проверяем что оба предмета существуют
    if not data.raw.item[item1] and not data.raw.fluid[item1] and not data.raw.tool[item1] then
        log("Предмет '"..item1.."' не найден среди items, fluids или tools!")
        return modified_recipes
    end

    if not data.raw.item[item2] and not data.raw.fluid[item2] and not data.raw.tool[item2] then
        log("Предмет '"..item2.."' не найден среди items, fluids или tools!")
        return modified_recipes
    end

    -- Функция для проверки наличия предмета в списке ингредиентов
    local function contains_ingredient(ingredients, item_name)
        for _, ingredient in ipairs(ingredients) do
            local ing_name = nil

            if type(ingredient) == "string" then
                ing_name = ingredient
            elseif type(ingredient) == "table" then
                ing_name = ingredient[1] or ingredient.name
            end

            if ing_name == item_name then
                return true
            end
        end
        return false
    end

    -- Функция для удаления предмета из списка ингредиентов
    local function remove_ingredient(ingredients, item_name)
        local new_ingredients = {}
        local removed = false

        for _, ingredient in ipairs(ingredients) do
            local keep_ingredient = true
            local ing_name = nil

            if type(ingredient) == "string" then
                ing_name = ingredient
                keep_ingredient = (ing_name ~= item_name)
            elseif type(ingredient) == "table" then
                ing_name = ingredient[1] or ingredient.name
                keep_ingredient = (ing_name ~= item_name)
            end

            if keep_ingredient then
                table.insert(new_ingredients, ingredient)
            else
                removed = true
            end
        end

        return new_ingredients, removed
    end

    -- Проходим по всем рецептам
    for recipe_name, recipe in pairs(data.raw.recipe) do
        local recipe_modified = false

        -- Обычные рецепты
        if recipe.ingredients then
            local has_item1 = contains_ingredient(recipe.ingredients, item1)
            local has_item2 = contains_ingredient(recipe.ingredients, item2)

            if has_item1 and has_item2 then
                local new_ingredients, removed = remove_ingredient(recipe.ingredients, item2)
                if removed then
                    recipe.ingredients = new_ingredients
                    recipe_modified = true
                    log("Удален '"..item2.."' из рецепта '"..recipe_name.."' (найден '"..item1.."')")
                end
            end
        end

        -- Рецепты с нормальной/дорогой версией
        if recipe.normal and recipe.normal.ingredients then
            local has_item1 = contains_ingredient(recipe.normal.ingredients, item1)
            local has_item2 = contains_ingredient(recipe.normal.ingredients, item2)

            if has_item1 and has_item2 then
                local new_ingredients, removed = remove_ingredient(recipe.normal.ingredients, item2)
                if removed then
                    recipe.normal.ingredients = new_ingredients
                    recipe_modified = true
                    log("Удален '"..item2.."' из normal версии рецепта '"..recipe_name.."' (найден '"..item1.."')")
                end
            end
        end

        if recipe.expensive and recipe.expensive.ingredients then
            local has_item1 = contains_ingredient(recipe.expensive.ingredients, item1)
            local has_item2 = contains_ingredient(recipe.expensive.ingredients, item2)

            if has_item1 and has_item2 then
                local new_ingredients, removed = remove_ingredient(recipe.expensive.ingredients, item2)
                if removed then
                    recipe.expensive.ingredients = new_ingredients
                    recipe_modified = true
                    log("Удален '"..item2.."' из expensive версии рецепта '"..recipe_name.."' (найден '"..item1.."')")
                end
            end
        end

        if recipe_modified then
            table.insert(modified_recipes, recipe_name)
        end
    end

    log("Обработано рецептов: "..#modified_recipes..", удален '"..item2.."' где присутствует '"..item1.."'")
    return modified_recipes
end
-- ##############################################################################################

-- ##############################################################################################
--- Добавляет новый предмет к результатам существующего рецепта
-- @param recipe_name string - Название рецепта
-- @param new_item string - Название предмета для добавления
-- @param amount number - Количество предмета (по умолчанию 1)
-- @param probability number - Вероятность выпадения (по умолчанию 1.0)
-- @return boolean - Успешно ли выполнено добавление
function CTDmod.lib.recipe.add_result(recipe_name, new_item, amount, probability, main_product)
    -- Проверяем существование рецепта
    if not data.raw.recipe[recipe_name] then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    -- Проверяем существование предмета
    if not data.raw.item[new_item] and
       not data.raw.fluid[new_item] and
       not data.raw.tool[new_item] then
        error("Предмет '"..new_item.."' не найден!")
        return false
    end

    local recipe = data.raw.recipe[recipe_name]
    amount = amount or 1
    probability = probability or 1.0
    main_product = main_product or recipe_name

    -- Безопасная конвертация в новый формат с сохранением всех полей
    local function safe_convert_to_results(recipe_part)
        if recipe_part.result and not recipe_part.results then
            -- Сохраняем все существующие поля кроме result и result_count
            local new_results = {
                {
                    type = "item",
                    name = recipe_part.result,
                    amount = recipe_part.result_count or 1
                }
            }

            -- Копируем все остальные поля
            local converted_part = table.deepcopy(recipe_part)
            converted_part.result = nil
            converted_part.result_count = nil
            converted_part.results = new_results

            return converted_part
        end
        return recipe_part
    end

    -- Обрабатываем разные форматы рецептов
    if recipe.normal or recipe.expensive then
        -- Рецепт с нормальной/дорогой версией

        -- Нормальная версия
        if recipe.normal then
            recipe.normal = safe_convert_to_results(recipe.normal)

            if not recipe.normal.results then
                recipe.normal.results = {}
            end

            -- Добавляем новый предмет
            table.insert(recipe.normal.results, {
                type = "item",
                name = new_item,
                amount = amount,
                probability = probability
            })
        end

        -- Дорогая версия
        if recipe.expensive then
            recipe.expensive = safe_convert_to_results(recipe.expensive)

            if not recipe.expensive.results then
                recipe.expensive.results = {}
            end

            table.insert(recipe.expensive.results, {
                type = "item",
                name = new_item,
                amount = amount,
                probability = probability
            })
        end

    else
        -- Обычный рецепт
        recipe = safe_convert_to_results(recipe)

        if not recipe.results then
            recipe.results = {}
        end

        -- Добавляем новый предмет
        table.insert(recipe.results, {
            type = "item",
            name = new_item,
            amount = amount,
            probability = probability
        })
    end

    log("Добавлен предмет '"..new_item.."' (количество: "..amount..", вероятность: "..probability..") к рецепту '"..recipe_name.."'")
    return true
end
-- ##############################################################################################

-- ##############################################################################################
--- Безопасное добавление предмета к результатам рецепта (без конвертации формата)
function CTDmod.lib.recipe.safe_add_result(recipe_name, new_item, amount, probability)
    if not data.raw.recipe[recipe_name] then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    if not data.raw.item[new_item] then
        error("Предмет '"..new_item.."' не найден!")
        return false
    end

    local recipe = data.raw.recipe[recipe_name]
    amount = amount or 1
    probability = probability or 1.0

    -- Функция для добавления к существующим results
    local function add_to_existing_results(results)
        if not results then
            return {{type = "item", name = new_item, amount = amount, probability = probability}}
        end

        table.insert(results, {
            type = "item",
            name = new_item,
            amount = amount,
            probability = probability
        })
        return results
    end

    -- Обрабатываем разные форматы рецептов
    if recipe.normal or recipe.expensive then
        -- Рецепт с нормальной/дорогой версией

        if recipe.normal then
            if recipe.normal.result and not recipe.normal.results then
                -- Создаем новый формат results на основе старого
                recipe.normal.results = {
                    {
                        type = "item",
                        name = recipe.normal.result,
                        amount = recipe.normal.result_count or 1
                    }
                }
                -- Не удаляем старые поля чтобы не сломать рецепт
            end
            recipe.normal.results = add_to_existing_results(recipe.normal.results)
        end

        if recipe.expensive then
            if recipe.expensive.result and not recipe.expensive.results then
                recipe.expensive.results = {
                    {
                        type = "item",
                        name = recipe.expensive.result,
                        amount = recipe.expensive.result_count or 1
                    }
                }
            end
            recipe.expensive.results = add_to_existing_results(recipe.expensive.results)
        end

    else
        -- Обычный рецепт
        if recipe.result and not recipe.results then
            recipe.results = {
                {
                    type = "item",
                    name = recipe.result,
                    amount = recipe.result_count or 1
                }
            }
            -- Сохраняем старые поля для совместимости
        end
        recipe.results = add_to_existing_results(recipe.results)
    end

    log("Безопасно добавлен предмет '"..new_item.."' к рецепту '"..recipe_name.."'")
    return true
end
-- ##############################################################################################

-- ##############################################################################################
--- Создание нового рецепта с побочным продуктом на основе существующего
function CTDmod.lib.recipe.create_new_with_byproduct(original_recipe_name, new_recipe_name, byproduct_item, amount, probability)
    if not data.raw.recipe[original_recipe_name] then
        error("Исходный рецепт '"..original_recipe_name.."' не найден!")
        return false
    end

    if not data.raw.item[byproduct_item] then
        error("Побочный предмет '"..byproduct_item.."' не найден!")
        return false
    end

    -- Создаем глубокую копию исходного рецепта
    local original_recipe = data.raw.recipe[original_recipe_name]
    local new_recipe = table.deepcopy(original_recipe)

    -- Устанавливаем новое имя
    new_recipe.name = new_recipe_name

    -- Добавляем локализацию для нового рецепта
    new_recipe.localised_name = {"recipe-name."..new_recipe_name}
    new_recipe.localised_description = {"recipe-description."..new_recipe_name}

    -- Обрабатываем результаты рецепта
    amount = amount or 1
    probability = probability or 1.0

    -- Функция для добавления побочного продукта к результатам
    local function add_byproduct_to_results(results)
        if not results then
            return {{type = "item", name = byproduct_item, amount = amount, probability = probability}}
        end

        -- Создаем новую таблицу результатов
        local new_results = table.deepcopy(results)
        table.insert(new_results, {
            type = "item",
            name = byproduct_item,
            amount = amount,
            probability = probability
        })
        return new_results
    end

    -- Обрабатываем разные форматы рецептов
    if new_recipe.normal or new_recipe.expensive then
        -- Рецепт с нормальной/дорогой версией

        if new_recipe.normal then
            if new_recipe.normal.result and not new_recipe.normal.results then
                -- Конвертируем старый формат в новый
                new_recipe.normal.results = {
                    {
                        type = "item",
                        name = new_recipe.normal.result,
                        amount = new_recipe.normal.result_count or 1
                    }
                }
                new_recipe.normal.result = nil
                new_recipe.normal.result_count = nil
            end
            new_recipe.normal.results = add_byproduct_to_results(new_recipe.normal.results)
        end

        if new_recipe.expensive then
            if new_recipe.expensive.result and not new_recipe.expensive.results then
                new_recipe.expensive.results = {
                    {
                        type = "item",
                        name = new_recipe.expensive.result,
                        amount = new_recipe.expensive.result_count or 1
                    }
                }
                new_recipe.expensive.result = nil
                new_recipe.expensive.result_count = nil
            end
            new_recipe.expensive.results = add_byproduct_to_results(new_recipe.expensive.results)
        end

    else
        -- Обычный рецепт
        if new_recipe.result and not new_recipe.results then
            new_recipe.results = {
                {
                    type = "item",
                    name = new_recipe.result,
                    amount = new_recipe.result_count or 1
                }
            }
            new_recipe.result = nil
            new_recipe.result_count = nil
        end
        new_recipe.results = add_byproduct_to_results(new_recipe.results)
    end

    -- Добавляем новый рецепт в игру
    data:extend({new_recipe})

    log("Создан новый рецепт '"..new_recipe_name.."' на основе '"..original_recipe_name.."' с побочным продуктом '"..byproduct_item.."'")
    return true
end
-- ##############################################################################################

-- ##############################################################################################
--- Простое создание нового рецепта с побочным продуктом
function CTDmod.lib.recipe.simple_create_with_byproduct(original_recipe_name, new_recipe_name, byproduct_item, amount, probability)
    if not data.raw.recipe[original_recipe_name] then
        error("Исходный рецепт '"..original_recipe_name.."' не найден!")
        return false
    end

    -- Создаем копию рецепта
    local new_recipe = table.deepcopy(data.raw.recipe[original_recipe_name])
    new_recipe.name = new_recipe_name

    -- Убеждаемся что results существует
    if not new_recipe.results then
        if new_recipe.result then
            new_recipe.results = {
                {
                    type = "item",
                    name = new_recipe.result,
                    amount = new_recipe.result_count or 1
                }
            }
            new_recipe.result = nil
            new_recipe.result_count = nil
        else
            new_recipe.results = {}
        end
    end

    -- Добавляем побочный продукт
    table.insert(new_recipe.results, {
        type = "item",
        name = byproduct_item,
        amount = amount or 1,
        probability = probability or 1.0
    })

    -- Добавляем в игру
    data:extend({new_recipe})

    log("Создан рецепт: " .. new_recipe_name)
    return true
end
-- ##############################################################################################

-- ##############################################################################################
--- Заменяет оригинальный рецепт новым с побочным продуктом
function CTDmod.lib.recipe.replace_with_byproduct(recipe_name, byproduct_item, amount, probability)
    if not data.raw.recipe[recipe_name] then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    local recipe = data.raw.recipe[recipe_name]
    amount = amount or 1
    probability = probability or 1.0

    -- Убеждаемся что results существует
    if not recipe.results then
        if recipe.result then
            recipe.results = {
                {
                    type = "item",
                    name = recipe.result,
                    amount = recipe.result_count or 1
                }
            }
            recipe.result = nil
            recipe.result_count = nil
        else
            recipe.results = {}
        end
    end

    -- Добавляем побочный продукт
    table.insert(recipe.results, {
        type = "item",
        name = byproduct_item,
        amount = amount,
        probability = probability
    })

    log("Добавлен побочный продукт '"..byproduct_item.."' к рецепту '"..recipe_name.."'")
    return true
end
-- ##############################################################################################

-- ##############################################################################################
--- Добавляет несколько предметов к результатам рецепта
-- @param recipe_name string - Название рецепта
-- @param items_to_add table - Таблица предметов для добавления в формате:
-- {
--     {item = "item-name", amount = 1, probability = 1.0},
--     {item = "other-item", amount = 2, probability = 0.5}
-- }
-- @return boolean - Успешно ли выполнено добавление
function CTDmod.lib.recipe.add_results(recipe_name, items_to_add)
    if not data.raw.recipe[recipe_name] then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    for _, item_data in ipairs(items_to_add) do
        local success = CTDmod.lib.recipe.add_result(
            recipe_name,
            item_data.item,
            item_data.amount,
            item_data.probability
        )
        if not success then
            return false
        end
    end

    log("Добавлено "..#items_to_add.." предметов к рецепту '"..recipe_name.."'")
    return true
end
-- ##############################################################################################

-- ##############################################################################################
--- Заменяет один предмет на другой в результатах рецепта
-- @param recipe_name string - Название рецепта
-- @param old_item string - Старый предмет для замены
-- @param new_item string - Новый предмет
-- @param new_amount number - Новое количество (опционально)
-- @param new_probability number - Новая вероятность (опционально)
-- @return boolean - Успешно ли выполнена замена
function CTDmod.lib.recipe.replace_result(recipe_name, old_item, new_item, new_amount, new_probability)
    if not data.raw.recipe[recipe_name] then
        error("Рецепт '"..recipe_name.."' не найден!")
        return false
    end

    if not data.raw.item[new_item] then
        error("Новый предмет '"..new_item.."' не найден!")
        return false
    end

    local recipe = data.raw.recipe[recipe_name]
    local replaced = false

    local function replace_in_results(results)
        if not results then return false end

        for _, result in ipairs(results) do
            local result_name = result.name or result[1]
            if result_name == old_item then
                result.name = new_item
                if result[1] then result[1] = new_item end
                if new_amount then result.amount = new_amount end
                if new_probability then result.probability = new_probability end
                return true
            end
        end
        return false
    end

    -- Обрабатываем разные форматы рецептов
    if recipe.normal or recipe.expensive then
        if recipe.normal then
            replaced = replace_in_results(recipe.normal.results) or replaced
        end
        if recipe.expensive then
            replaced = replace_in_results(recipe.expensive.results) or replaced
        end
    else
        replaced = replace_in_results(recipe.results) or replaced
    end

    if replaced then
        log("Заменен предмет '"..old_item.."' на '"..new_item.."' в рецепте '"..recipe_name.."'")
        return true
    else
        error("Предмет '"..old_item.."' не найден в результатах рецепта '"..recipe_name.."'")
        return false
    end
end
-- ##############################################################################################