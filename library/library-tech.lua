-- ##############################################################################################
if not CTDmod.lib.tech then CTDmod.lib.tech = {} end
-- ##############################################################################################
--- Функция добавления зависимости технологии:
function CTDmod.lib.tech.add_dependency(tech_name, dependency)
    -- Проверяем существование технологии
    if not data.raw.technology[tech_name] then
        error("Технология '"..tech_name.."' не найдена!")
        return false
    end

    -- Проверяем существование зависимости
    if not data.raw.technology[dependency] then
        error("Технология-зависимость '"..dependency.."' не найдена!")
        return false
    end

    -- Инициализируем prerequisites если нет
    local tech = data.raw.technology[tech_name]
    if not tech.prerequisites then
        tech.prerequisites = {}
    end

    -- Проверяем, нет ли уже такой зависимости
    for _, prereq in ipairs(tech.prerequisites) do
        if prereq == dependency then
            log("Технология '"..tech_name.."' уже зависит от '"..dependency.."'")
            return true
        end
    end

    -- Добавляем зависимость
    table.insert(tech.prerequisites, dependency)
    log("Добавлена зависимость: '"..tech_name.."' теперь требует '"..dependency.."'")
    return true
end
-- ##############################################################################################
--- Функция замены зависимости технологии:
function CTDmod.lib.tech.replace_dependency(tech_name, old_dependency, new_dependency)
    -- Проверяем существование технологий
    if not data.raw.technology[tech_name] then
        error("Технология '"..tech_name.."' не найдена!")
        return false
    end
    if not data.raw.technology[new_dependency] then
        error("Новая технология-зависимость '"..new_dependency.."' не найдена!")
        return false
    end

    local tech = data.raw.technology[tech_name]
    if not tech.prerequisites then
        error("У технологии '"..tech_name.."' нет зависимостей!")
        return false
    end

    -- Ищем и заменяем зависимость
    local found = false
    for i, prereq in ipairs(tech.prerequisites) do
        if prereq == old_dependency then
            tech.prerequisites[i] = new_dependency
            found = true
        end
    end

    if not found then
        error("Технология '"..tech_name.."' не зависит от '"..old_dependency.."'")
        return false
    end

    log("Зависимость заменена: '"..tech_name.."' теперь требует '"..new_dependency.."' вместо '"..old_dependency.."'")
    return true
end
-- ##############################################################################################
--- Заменяет или удаляет зависимости технологий
-- @param old_tech string - Исходная технология (например "electronics")
-- @param new_tech string - Новая технология (например "CTD-electronics")
function CTDmod.lib.tech.replace_or_remove_dependencies(old_tech, new_tech)
    -- Проверяем существование новой технологии
    local new_tech_exists = data.raw.technology[new_tech]
    local replacements = 0
    local removals = 0

    -- Проходим по всем технологиям
    for _, tech in pairs(data.raw.technology) do
        -- Обрабатываем прямые зависимости (prerequisites)
        if tech.prerequisites then
            local has_new_tech = false
            -- local to_remove = {}

            -- Сначала проверяем наличие новой зависимости
            for i, prereq in ipairs(tech.prerequisites) do
                if prereq == new_tech then
                    has_new_tech = true
                    break
                end
            end

            -- Затем обрабатываем старые зависимости
            for i = #tech.prerequisites, 1, -1 do
                local prereq = tech.prerequisites[i]
                if prereq == old_tech then
                    if new_tech_exists and not has_new_tech then
                        tech.prerequisites[i] = new_tech
                        replacements = replacements + 1
                    else
                        table.remove(tech.prerequisites, i)
                        removals = removals + 1
                    end
                end
            end
        end
    end

    -- Формируем отчет
    local report = ""
    if replacements > 0 then
        report = report.."Заменено "..replacements.." зависимостей"
    end
    if removals > 0 then
        if report ~= "" then report = report..", " end
        report = report.."удалено "..removals.." зависимостей"
    end

    log(report.." от '"..old_tech.."'")
    return true
end
-- ##############################################################################################
--- Функция удаления зависимости технологии:
function CTDmod.lib.tech.remove_dependency(tech_name, dependency)
    -- Проверяем существование технологии
    if not data.raw.technology[tech_name] then
        error("Технология '"..tech_name.."' не найдена!")
        return false
    end

    local tech = data.raw.technology[tech_name]
    if not tech.prerequisites then
        error("У технологии '"..tech_name.."' нет зависимостей!")
        return false
    end

    -- Удаляем зависимость
    local found = false
    for i = #tech.prerequisites, 1, -1 do
        if tech.prerequisites[i] == dependency then
            table.remove(tech.prerequisites, i)
            found = true
        end
    end

    if not found then
        error("Технология '"..tech_name.."' не зависит от '"..dependency.."'")
        return false
    end

    -- Удаляем пустые таблицы зависимостей
    if #tech.prerequisites == 0 then
        tech.prerequisites = nil
    end

    log("Зависимость удалена: '"..tech_name.."' больше не требует '"..dependency.."'")
    return true
end
-- ##############################################################################################
--- Массовое добавление зависимостей:
function CTDmod.lib.tech.mass_add_dependencies(tech_name, dependencies)
    for _, dep in ipairs(dependencies) do
        CTDmod.lib.tech.add_dependency(tech_name, dep)
    end
end
-- ##############################################################################################
--- Функция для полного удаления технологии:
function CTDmod.lib.tech.completely_delete(tech_name)
    -- Проверяем существование технологии
    if not data.raw.technology[tech_name] then
        error("Технология '"..tech_name.."' не найдена!")
        return false
    end

    -- 1. Удаляем технологию из зависимостей других технологий
    for _, tech in pairs(data.raw.technology) do
        if tech.prerequisites then
            for i = #tech.prerequisites, 1, -1 do
                if tech.prerequisites[i] == tech_name then
                    table.remove(tech.prerequisites, i)
                end
            end

            -- Удаляем пустые таблицы prerequisites
            if tech.prerequisites and #tech.prerequisites == 0 then
                tech.prerequisites = nil
            end
        end
    end

    -- 2. Обрабатываем связанные рецепты
    local tech = data.raw.technology[tech_name]
    if tech.effects then
        for _, effect in ipairs(tech.effects) do
            if effect.type == "unlock-recipe" then
                local recipe = data.raw.recipe[effect.recipe]
                if recipe then
                    -- Удаляем привязку к технологии в рецепте
                    if recipe.technology == tech_name then
                        recipe.technology = nil
                        recipe.enabled = false -- Делаем рецепт недоступным
                    end

                    -- Для рецептов с разной сложностью
                    if recipe.normal and recipe.normal.technology == tech_name then
                        recipe.normal.technology = nil
                        recipe.normal.enabled = false
                    end
                    if recipe.expensive and recipe.expensive.technology == tech_name then
                        recipe.expensive.technology = nil
                        recipe.expensive.enabled = false
                    end
                end
            end
        end
    end

    -- 3. Полностью удаляем технологию
    data.raw.technology[tech_name] = nil

    log("Технология '"..tech_name.."' полностью удалена из игры")
    return true
end
-- ##############################################################################################
--- Функция для отключения (но не удаления) технологии:
function CTDmod.lib.tech.disable(tech_name)
    if not data.raw.technology[tech_name] then
        error("Технология '"..tech_name.."' не найдена!")
        return false
    end

    data.raw.technology[tech_name].enabled = false
    data.raw.technology[tech_name].hidden = true

    log("Технология '"..tech_name.."' отключена и скрыта")
    return true
end
-- ##############################################################################################
--- Функция для переноса всех разблокируемых рецептов:
function CTDmod.lib.tech.transfer_effects(source_tech, target_tech)
    if not data.raw.technology[source_tech] then
        error("Исходная технология '"..source_tech.."' не найдена!")
        return false
    end
    if not data.raw.technology[target_tech] then
        error("Целевая технология '"..target_tech.."' не найдена!")
        return false
    end

    local source = data.raw.technology[source_tech]
    local target = data.raw.technology[target_tech]

    if source.effects then
        -- Инициализируем effects если нет
        if not target.effects then
            target.effects = {}
        end

        -- Переносим все эффекты
        for _, effect in ipairs(source.effects) do
            if effect.type == "unlock-recipe" then
                table.insert(target.effects, effect)
            end
        end

        -- Очищаем исходные эффекты
        source.effects = nil
    end

    log("Все эффекты технологии '"..source_tech.."' перенесены в '"..target_tech.."'")
    return true
end
-- ##############################################################################################
--- Функция для пееименования технологии с возможностью подставления параметров в описание:
function CTDmod.lib.tech.rename(tech_name, tech_new_name, params)
    -- Проверяем существование технологии
    if not data.raw.technology[tech_name] then
        log("Технология '"..tech_name.."' не найдена!")
        return false
    end

    -- Если новое имя не указано - только обновляем локализацию
    if not tech_new_name or tech_new_name == tech_name then
        data.raw.technology[tech_name].localised_name = {"technology-name."..tech_name}
        if params ~= nil then
            data.raw.technology[tech_name].localised_description = {"technology-description."..tech_name, params}
        else
            data.raw.technology[tech_name].localised_description = {"technology-description."..tech_name}
        end
        return true
    end

    -- 1. Создаем полную копию технологии
    local tech = table.deepcopy(data.raw.technology[tech_name])
    tech.name = tech_new_name
    tech.localised_name = {"technology-name."..tech_new_name}
    if params ~= nil then
        tech.localised_description = {"technology-description."..tech_new_name, params}
    else
        tech.localised_description = {"technology-description."..tech_new_name}
    end

    -- 2. Обновляем все зависимости в других технологиях
    for _, other_tech in pairs(data.raw.technology) do
        if other_tech.prerequisites then
            for i, prereq in ipairs(other_tech.prerequisites) do
                if prereq == tech_name then
                    other_tech.prerequisites[i] = tech_new_name
                end
            end
        end
    end

    -- 3. Обновляем рецепты (разблокировку технологий)
    for _, recipe in pairs(data.raw.recipe) do
        -- Обычные рецепты
        if recipe.enabled == false and not recipe.normal then
            if recipe.technology == tech_name then
                recipe.technology = tech_new_name
            end
        end

        -- Рецепты с нормальной/дорогой версией
        if recipe.normal then
            if recipe.normal.enabled == false and recipe.normal.technology == tech_name then
                recipe.normal.technology = tech_new_name
            end
            if recipe.expensive and recipe.expensive.enabled == false and recipe.expensive.technology == tech_name then
                recipe.expensive.technology = tech_new_name
            end
        end
    end

    -- 4. Обновляем эффекты технологий
    if tech.effects then
        for _, effect in ipairs(tech.effects) do
            if effect.type == "unlock-recipe" and effect.recipe then
                local recipe = data.raw.recipe[effect.recipe]
                if recipe then
                    recipe.technology = tech_new_name
                end
            end
        end
    end

    -- 5. Добавляем новую технологию перед удалением старой
    data.raw.technology[tech_new_name] = tech
    data.raw.technology[tech_name] = nil

    log("Технология '"..tech_name.."' переименована в '"..tech_new_name.."' со всеми связями")
    return true
end
-- ##############################################################################################
--- Добавляем научный пакет к технологии
-- @param tech_name Название технологии
-- @param science_pack Название научного пакета
-- @param amount Количество (по умолчанию 1)
function CTDmod.lib.tech.add_science_pack(tech_name, science_pack, amount)
    amount = amount or 1
    local tech = data.raw.technology[tech_name]
    if not tech then return false end

    tech.unit = tech.unit or {}
    tech.unit.ingredients = tech.unit.ingredients or {}

    -- Проверяем, есть ли уже такой пакет
    for _, ingredient in pairs(tech.unit.ingredients) do
        if (ingredient[1] or ingredient.name) == science_pack then
            ingredient.amount = (ingredient.amount or 1) + amount
            return true
        end
    end

    -- Добавляем новый пакет
    table.insert(tech.unit.ingredients, {science_pack, amount})
    return true
end

--- Удаляем научный пакет из технологии
-- @param tech_name Название технологии
-- @param science_pack Название научного пакета
-- @param remove_all Полностью удалить (true) или уменьшить количество (false)
-- @param amount Количество для удаления (по умолчанию 1)
function CTDmod.lib.tech.remove_science_pack(tech_name, science_pack, remove_all, amount)
    amount = amount or 1
    local tech = data.raw.technology[tech_name]
    if not tech or not tech.unit or not tech.unit.ingredients then return false end

    for i, ingredient in pairs(tech.unit.ingredients) do
        local pack_name = ingredient[1] or ingredient.name
        if pack_name == science_pack then
            if remove_all then
                table.remove(tech.unit.ingredients, i)
            else
                local new_amount = (ingredient.amount or 1) - amount
                if new_amount <= 0 then
                    table.remove(tech.unit.ingredients, i)
                else
                    ingredient.amount = new_amount
                end
            end
            return true
        end
    end
    return false
end

--- Заменяем один научный пакет на другой
-- @param tech_name Название технологии
-- @param old_pack Название заменяемого пакета
-- @param new_pack Название нового пакета
-- @param new_amount Количество нового пакета (nil = сохранить старое количество)
function CTDmod.lib.tech.replace_science_pack(tech_name, old_pack, new_pack, new_amount)
    local tech = data.raw.technology[tech_name]
    if not tech or not tech.unit or not tech.unit.ingredients then return false end

    local found = false
    local new_ingredients = {}

    for _, ingredient in pairs(tech.unit.ingredients) do
        local pack_name = ingredient[1] or ingredient.name
        local amount = ingredient.amount or ingredient[2] or 1

        if pack_name == old_pack then
            -- Заменяем пакет
            local new_amount_value = new_amount or amount
            table.insert(new_ingredients, {new_pack, new_amount_value})
            found = true
        else
            -- Сохраняем старый ингредиент
            table.insert(new_ingredients, {pack_name, amount})
        end
    end

    if found then
        tech.unit.ingredients = new_ingredients
    end

    return found
end

--- Полностью заменяем все научные пакеты технологии
-- @param tech_name Название технологии
-- @param new_ingredients Таблица новых ингредиентов в формате {{"pack1", amount}, {"pack2", amount}}
function CTDmod.lib.tech.set_science_packs(tech_name, new_ingredients)
    local tech = data.raw.technology[tech_name]
    if not tech then return false end

    tech.unit = tech.unit or {}
    tech.unit.ingredients = {}

    for _, pack in pairs(new_ingredients) do
        table.insert(tech.unit.ingredients, {pack[1], pack[2]})
    end
    return true
end

--- Получаем список научных пакетов технологии
-- @param tech_name Название технологии
-- @return Таблица пакетов или nil
function CTDmod.lib.tech.get_science_packs(tech_name)
    local tech = data.raw.technology[tech_name]
    if not tech or not tech.unit or not tech.unit.ingredients then return nil end

    local result = {}
    for _, ingredient in pairs(tech.unit.ingredients) do
        table.insert(result, {
            name = ingredient[1] or ingredient.name,
            amount = ingredient.amount or 1
        })
    end
    return result
end
-- -- ##############################################################################################

-- ##############################################################################################
--- Полная замена научного пакета во всей игре с дублированием рецепта и скрытием старого
-- @param old_pack string - Название заменяемого пакета ("automation-science-pack")
-- @param new_pack string - Название нового пакета ("CTD-science-pack-grey")
function CTDmod.lib.tech.replace_science_pack_globally(old_pack, new_pack)
    local replacements = 0

    -- 0. Проверяем что новый пакет существует
    if not data.raw.tool[new_pack] then
        error("Новый научный пакет '"..new_pack.."' не найден!")
        return false
    end

    -- 0.1. Дублируем рецепт старого пакета для нового (совместимый формат)
    local old_recipe = data.raw.recipe[old_pack]
    if old_recipe and not data.raw.recipe[new_pack] then
        local new_recipe = table.deepcopy(old_recipe)
        new_recipe.name = new_pack

        -- Полностью пересоздаем результаты рецепта для нового пакета
        new_recipe.result = nil
        new_recipe.result_count = nil

        -- Создаем правильную структуру results для нового пакета
        if old_recipe.results then
            -- Копируем структуру results, но заменяем имя продукта
            new_recipe.results = {}
            for _, result in ipairs(old_recipe.results) do
                local new_result = table.deepcopy(result)
                if new_result.name == old_pack then
                    new_result.name = new_pack
                elseif type(new_result) == "table" and new_result[1] == old_pack then
                    new_result[1] = new_pack
                end
                table.insert(new_recipe.results, new_result)
            end
        else
            -- Создаем простой результат для нового пакета
            new_recipe.results = {{type = "item", name = new_pack, amount = 1}}
        end

        -- Убедимся, что нет конфликтующих полей
        new_recipe.main_product = nil

        -- Обновляем локализацию
        new_recipe.localised_name = {"recipe-name."..new_pack}
        new_recipe.localised_description = {"recipe-description."..new_pack}

        -- Обновляем технологию разблокировки если есть
        if new_recipe.technology == old_pack then
            new_recipe.technology = new_pack
        end

        data:extend({new_recipe})
        log("Создан рецепт для '"..new_pack.."' на основе '"..old_pack.."'")
    end

    -- 0.2. Дублируем технологию разблокировки если нужно
    local old_tech = data.raw.technology[old_pack]
    if old_tech and not data.raw.technology[new_pack] then
        local new_tech = table.deepcopy(old_tech)
        new_tech.name = new_pack
        new_tech.localised_name = {"technology-name."..new_pack}
        new_tech.localised_description = {"technology-description."..new_pack}

        -- Обновляем эффекты разблокировки
        if new_tech.effects then
            for _, effect in ipairs(new_tech.effects) do
                if effect.type == "unlock-recipe" and effect.recipe == old_pack then
                    effect.recipe = new_pack
                end
            end
        end

        data:extend({new_tech})
        log("Создана технология для '"..new_pack.."' на основе '"..old_pack.."'")
    end

    -- 0.3. Правильно скрываем старый пакет, рецепт и технологию
    if data.raw.tool[old_pack] then
        data.raw.tool[old_pack].subgroup = "hidden"
        data.raw.tool[old_pack].hidden = true
        data.raw.tool[old_pack].order = "zzz"
    end

    if data.raw.recipe[old_pack] then
        data.raw.recipe[old_pack].enabled = false
        data.raw.recipe[old_pack].hidden = true
        data.raw.recipe[old_pack].subgroup = "hidden"
        data.raw.recipe[old_pack].order = "zzz"
    end

    if data.raw.technology[old_pack] then
        data.raw.technology[old_pack].hidden = true
        data.raw.technology[old_pack].enabled = false
    end

    local function replace_in_ingredient(ingredient)
        local ing_name = nil
        local ing_amount = nil

        -- Определяем формат ингредиента
        if type(ingredient) == "string" then
            ing_name = ingredient
            ing_amount = 1
        elseif type(ingredient) == "table" then
            if ingredient[1] then
                ing_name = ingredient[1]
                ing_amount = ingredient[2] or 1
            elseif ingredient.name then
                ing_name = ingredient.name
                ing_amount = ingredient.amount or ingredient.count or 1
            elseif ingredient[1] == nil and ingredient.name == nil then
                if ingredient.type == "item" and ingredient.name then
                    ing_name = ingredient.name
                    ing_amount = ingredient.amount or 1
                end
            end
        end

        -- Если нашли нужный пакет - заменяем
        if ing_name == old_pack then
            if type(ingredient) == "string" then
                return new_pack
            elseif type(ingredient) == "table" then
                if ingredient[1] then
                    ingredient[1] = new_pack
                end
                if ingredient.name then
                    ingredient.name = new_pack
                end
                replacements = replacements + 1
                return ingredient
            end
        end

        return ingredient
    end

    -- 1. Замена в технологиях
    for tech_name, tech in pairs(data.raw.technology) do
        if tech.unit and tech.unit.ingredients then
            local new_ingredients = {}
            for _, ingredient in ipairs(tech.unit.ingredients) do
                local new_ingredient = replace_in_ingredient(ingredient)
                table.insert(new_ingredients, new_ingredient)
            end
            tech.unit.ingredients = new_ingredients
        end

        -- Заменяем в зависимостях технологий
        if tech.prerequisites then
            for i, prereq in ipairs(tech.prerequisites) do
                if prereq == old_pack then
                    tech.prerequisites[i] = new_pack
                    replacements = replacements + 1
                end
            end
        end
    end

    -- 2. Замена в рецептах (только как ингредиенты)
    for recipe_name, recipe in pairs(data.raw.recipe) do
        -- Пропускаем рецепты, которые производят научные пакеты
        if recipe_name ~= old_pack and recipe_name ~= new_pack then
            -- Обычные рецепты
            if recipe.ingredients then
                local new_ingredients = {}
                for _, ingredient in ipairs(recipe.ingredients) do
                    local new_ingredient = replace_in_ingredient(ingredient)
                    table.insert(new_ingredients, new_ingredient)
                end
                recipe.ingredients = new_ingredients
            end

            -- Рецепты с нормальной/дорогой версией
            if recipe.normal and recipe.normal.ingredients then
                local new_ingredients = {}
                for _, ingredient in ipairs(recipe.normal.ingredients) do
                    local new_ingredient = replace_in_ingredient(ingredient)
                    table.insert(new_ingredients, new_ingredient)
                end
                recipe.normal.ingredients = new_ingredients
            end

            if recipe.expensive and recipe.expensive.ingredients then
                local new_ingredients = {}
                for _, ingredient in ipairs(recipe.expensive.ingredients) do
                    local new_ingredient = replace_in_ingredient(ingredient)
                    table.insert(new_ingredients, new_ingredient)
                end
                recipe.expensive.ingredients = new_ingredients
            end
        end

        -- Заменяем технологию разблокировки
        if recipe.technology == old_pack then
            recipe.technology = new_pack
            replacements = replacements + 1
        end

        if recipe.normal and recipe.normal.technology == old_pack then
            recipe.normal.technology = new_pack
            replacements = replacements + 1
        end

        if recipe.expensive and recipe.expensive.technology == old_pack then
            recipe.expensive.technology = new_pack
            replacements = replacements + 1
        end
    end

    -- 3. Замена в лабораториях
    for lab_name, lab in pairs(data.raw["lab"]) do
        if lab.inputs then
            local new_inputs = {}
            for _, input in ipairs(lab.inputs) do
                local new_input = replace_in_ingredient(input)
                table.insert(new_inputs, new_input)
            end
            lab.inputs = new_inputs
        end
    end

    -- 4. Замена в других сущностях
    for category_name, category in pairs(data.raw) do
        for entity_name, entity in pairs(category) do
            if entity.ingredient then
                entity.ingredient = replace_in_ingredient(entity.ingredient)
            end

            if entity.ingredients then
                local new_ingredients = {}
                for _, ingredient in ipairs(entity.ingredients) do
                    local new_ingredient = replace_in_ingredient(ingredient)
                    table.insert(new_ingredients, new_ingredient)
                end
                entity.ingredients = new_ingredients
            end
        end
    end

    -- 5. Замена в эффектах технологий
    for tech_name, tech in pairs(data.raw.technology) do
        if tech.effects then
            for _, effect in ipairs(tech.effects) do
                if effect.type == "unlock-recipe" and effect.recipe == old_pack then
                    effect.recipe = new_pack
                    replacements = replacements + 1
                end
            end
        end
    end

    -- 6. Создаем подгруппу "hidden" если ее нет
    if not data.raw["item-subgroup"]["hidden"] then
        data:extend({
            {
                type = "item-subgroup",
                name = "hidden",
                group = "other",
                order = "zzz"
            }
        })
    end

    log("Заменено "..replacements.." вхождений научного пакета '"..old_pack.."' на '"..new_pack.."'")
    return true
end
-- ##############################################################################################

-- ##############################################################################################
--- Удаляет эффект разблокировки конкретного рецепта из технологии
-- @param tech_name string - Название технологии
-- @param recipe_name string - Название рецепта для удаления из эффектов
-- @return boolean - Успешно ли выполнено удаление
function CTDmod.lib.tech.remove_recipe_effect(tech_name, recipe_name)
    -- Проверяем существование технологии
    if not data.raw.technology[tech_name] then
        error("Технология '"..tech_name.."' не найдена!")
        return false
    end

    local tech = data.raw.technology[tech_name]

    -- Проверяем наличие эффектов
    if not tech.effects then
        log("У технологии '"..tech_name.."' нет эффектов для удаления")
        return false
    end

    -- Ищем и удаляем эффект разблокировки указанного рецепта
    local found = false
    for i = #tech.effects, 1, -1 do
        local effect = tech.effects[i]
        if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
            table.remove(tech.effects, i)
            found = true
            log("Удален эффект разблокировки рецепта '"..recipe_name.."' из технологии '"..tech_name.."'")
        end
    end

    -- Если эффектов не осталось, удаляем пустую таблицу
    if #tech.effects == 0 then
        tech.effects = nil
        log("Все эффекты удалены из технологии '"..tech_name.."'")
    end

    if not found then
        log("Эффект разблокировки рецепта '"..recipe_name.."' не найден в технологии '"..tech_name.."'")
        return false
    end

    return true
end
-- ##############################################################################################

-- ##############################################################################################
--- Удаляет несколько эффектов разблокировки рецептов из технологии
-- @param tech_name string - Название технологии
-- @param recipe_names table - Таблица названий рецептов для удаления
-- @return boolean - Успешно ли выполнено удаление
function CTDmod.lib.tech.remove_recipe_effects(tech_name, recipe_names)
    if not data.raw.technology[tech_name] then
        error("Технология '"..tech_name.."' не найдена!")
        return false
    end

    local tech = data.raw.technology[tech_name]
    local removed_count = 0

    if not tech.effects then
        log("У технологии '"..tech_name.."' нет эффектов для удаления")
        return false
    end

    -- Создаем таблицу для быстрого поиска
    local recipes_to_remove = {}
    for _, recipe_name in ipairs(recipe_names) do
        recipes_to_remove[recipe_name] = true
    end

    -- Удаляем эффекты
    for i = #tech.effects, 1, -1 do
        local effect = tech.effects[i]
        if effect.type == "unlock-recipe" and recipes_to_remove[effect.recipe] then
            table.remove(tech.effects, i)
            removed_count = removed_count + 1
            log("Удален эффект разблокировки рецепта '"..effect.recipe.."' из технологии '"..tech_name.."'")
        end
    end

    -- Если эффектов не осталось, удаляем пустую таблицу
    if tech.effects and #tech.effects == 0 then
        tech.effects = nil
    end

    log("Удалено "..removed_count.." эффектов из технологии '"..tech_name.."'")
    return removed_count > 0
end
-- ##############################################################################################

-- ##############################################################################################
--- Получает все эффекты разблокировки рецептов из технологии
-- @param tech_name string - Название технологии
-- @return table - Таблица рецептов или nil
function CTDmod.lib.tech.get_recipe_effects(tech_name)
    if not data.raw.technology[tech_name] then
        error("Технология '"..tech_name.."' не найдена!")
        return nil
    end

    local tech = data.raw.technology[tech_name]
    local recipes = {}

    if tech.effects then
        for _, effect in ipairs(tech.effects) do
            if effect.type == "unlock-recipe" then
                table.insert(recipes, effect.recipe)
            end
        end
    end

    return recipes
end
-- ##############################################################################################

-- ##############################################################################################
--- Проверяет содержит ли технология эффект разблокировки конкретного рецепта
-- @param tech_name string - Название технологии
-- @param recipe_name string - Название рецепта
-- @return boolean - Содержит ли технология эффект
function CTDmod.lib.tech.has_recipe_effect(tech_name, recipe_name)
    if not data.raw.technology[tech_name] then
        error("Технология '"..tech_name.."' не найдена!")
        return false
    end

    local tech = data.raw.technology[tech_name]

    if tech.effects then
        for _, effect in ipairs(tech.effects) do
            if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
                return true
            end
        end
    end

    return false
end
-- ##############################################################################################
--- Удаляет научный пакет 2 из технологий, где присутствует научный пакет 1
-- @param search_pack string - Научный пакет для поиска (если найден, удаляем remove_pack)
-- @param remove_pack string - Научный пакет для удаления
-- @return table - Список технологий, где была выполнена замена
function CTDmod.lib.tech.remove_science_pack_if_another_exists(search_pack, remove_pack)
    local modified_techs = {}

    -- Проверяем что оба пакета существуют
    if not data.raw.tool[search_pack] then
        error("Научный пакет для поиска '"..search_pack.."' не найден!")
        return modified_techs
    end

    if not data.raw.tool[remove_pack] then
        error("Научный пакет для удаления '"..remove_pack.."' не найден!")
        return modified_techs
    end

    -- Проходим по всем технологиям
    for tech_name, tech in pairs(data.raw.technology) do
        if tech.unit and tech.unit.ingredients then
            local has_search_pack = false
            local has_remove_pack = false

            -- Проверяем наличие обоих пакетов
            for _, ingredient in ipairs(tech.unit.ingredients) do
                local pack_name = nil

                -- Определяем имя пакета в зависимости от формата
                if type(ingredient) == "string" then
                    pack_name = ingredient
                elseif type(ingredient) == "table" then
                    pack_name = ingredient[1] or ingredient.name
                end

                if pack_name == search_pack then
                    has_search_pack = true
                end

                if pack_name == remove_pack then
                    has_remove_pack = true
                end

                -- Если оба найдены, выходим из цикла
                if has_search_pack and has_remove_pack then
                    break
                end
            end

            -- Если найден search_pack И присутствует remove_pack - удаляем remove_pack
            if has_search_pack and has_remove_pack then
                local new_ingredients = {}
                local removed = false

                -- Создаем новый список ингредиентов без remove_pack
                for _, ingredient in ipairs(tech.unit.ingredients) do
                    local pack_name = nil
                    local should_keep = true

                    if type(ingredient) == "string" then
                        pack_name = ingredient
                        should_keep = (pack_name ~= remove_pack)
                    elseif type(ingredient) == "table" then
                        pack_name = ingredient[1] or ingredient.name
                        should_keep = (pack_name ~= remove_pack)
                    end

                    if should_keep then
                        table.insert(new_ingredients, ingredient)
                    else
                        removed = true
                    end
                end

                -- Если что-то удалили, обновляем ingredients
                if removed then
                    tech.unit.ingredients = new_ingredients
                    table.insert(modified_techs, tech_name)
                    log("Удален пакет '"..remove_pack.."' из технологии '"..tech_name.."' (найден пакет '"..search_pack.."')")
                end
            end
        end
    end

    log("Обработано технологий: "..#modified_techs..", удален пакет '"..remove_pack.."' где присутствует '"..search_pack.."'")
    return modified_techs
end
-- ##############################################################################################

-- ##############################################################################################
--- Удаляет научный пакет 2 из технологий, где НЕ присутствует научный пакет 1
-- @param search_pack string - Научный пакет для поиска (если НЕ найден, удаляем remove_pack)
-- @param remove_pack string - Научный пакет для удаления
-- @return table - Список технологий, где была выполнена замена
function CTDmod.lib.tech.remove_science_pack_if_another_not_exists(search_pack, remove_pack)
    local modified_techs = {}

    -- Проверяем что оба пакета существуют
    if not data.raw.tool[search_pack] then
        error("Научный пакет для поиска '"..search_pack.."' не найден!")
        return modified_techs
    end

    if not data.raw.tool[remove_pack] then
        error("Научный пакет для удаления '"..remove_pack.."' не найден!")
        return modified_techs
    end

    -- Проходим по всем технологиям
    for tech_name, tech in pairs(data.raw.technology) do
        if tech.unit and tech.unit.ingredients then
            local has_search_pack = false
            local has_remove_pack = false

            -- Проверяем наличие пакетов
            for _, ingredient in ipairs(tech.unit.ingredients) do
                local pack_name = nil

                if type(ingredient) == "string" then
                    pack_name = ingredient
                elseif type(ingredient) == "table" then
                    pack_name = ingredient[1] or ingredient.name
                end

                if pack_name == search_pack then
                    has_search_pack = true
                end

                if pack_name == remove_pack then
                    has_remove_pack = true
                end
            end

            -- Если НЕ найден search_pack И присутствует remove_pack - удаляем remove_pack
            if not has_search_pack and has_remove_pack then
                local new_ingredients = {}
                local removed = false

                -- Создаем новый список ингредиентов без remove_pack
                for _, ingredient in ipairs(tech.unit.ingredients) do
                    local pack_name = nil
                    local should_keep = true

                    if type(ingredient) == "string" then
                        pack_name = ingredient
                        should_keep = (pack_name ~= remove_pack)
                    elseif type(ingredient) == "table" then
                        pack_name = ingredient[1] or ingredient.name
                        should_keep = (pack_name ~= remove_pack)
                    end

                    if should_keep then
                        table.insert(new_ingredients, ingredient)
                    else
                        removed = true
                    end
                end

                -- Если что-то удалили, обновляем ingredients
                if removed then
                    tech.unit.ingredients = new_ingredients
                    table.insert(modified_techs, tech_name)
                    log("Удален пакет '"..remove_pack.."' из технологии '"..tech_name.."' (отсутствует пакет '"..search_pack.."')")
                end
            end
        end
    end

    log("Обработано технологий: "..#modified_techs..", удален пакет '"..remove_pack.."' где отсутствует '"..search_pack.."'")
    return modified_techs
end
-- ##############################################################################################

-- ##############################################################################################
--- Заменяет научный пакет 2 на пакет 3 в технологиях, где присутствует научный пакет 1
-- @param search_pack string - Научный пакет для поиска (условие)
-- @param old_pack string - Научный пакет для замены
-- @param new_pack string - Новый научный пакет
-- @return table - Список технологий, где была выполнена замена
function CTDmod.lib.tech.replace_science_pack_if_another_exists(search_pack, old_pack, new_pack)
    local modified_techs = {}

    -- Проверяем что все пакеты существуют
    if not data.raw.tool[search_pack] then
        error("Научный пакет для поиска '"..search_pack.."' не найден!")
        return modified_techs
    end

    if not data.raw.tool[old_pack] then
        error("Научный пакет для замены '"..old_pack.."' не найден!")
        return modified_techs
    end

    if not data.raw.tool[new_pack] then
        error("Новый научный пакет '"..new_pack.."' не найден!")
        return modified_techs
    end

    -- Проходим по всем технологиям
    for tech_name, tech in pairs(data.raw.technology) do
        if tech.unit and tech.unit.ingredients then
            local has_search_pack = false
            local has_old_pack = false

            -- Проверяем наличие пакетов
            for _, ingredient in ipairs(tech.unit.ingredients) do
                local pack_name = nil

                if type(ingredient) == "string" then
                    pack_name = ingredient
                elseif type(ingredient) == "table" then
                    pack_name = ingredient[1] or ingredient.name
                end

                if pack_name == search_pack then
                    has_search_pack = true
                end

                if pack_name == old_pack then
                    has_old_pack = true
                end

                if has_search_pack and has_old_pack then
                    break
                end
            end

            -- Если найден search_pack И присутствует old_pack - заменяем old_pack на new_pack
            if has_search_pack and has_old_pack then
                local new_ingredients = {}
                local replaced = false

                -- Создаем новый список ингредиентов с заменой
                for _, ingredient in ipairs(tech.unit.ingredients) do
                    local new_ingredient = ingredient

                    if type(ingredient) == "string" then
                        if ingredient == old_pack then
                            new_ingredient = new_pack
                            replaced = true
                        end
                    elseif type(ingredient) == "table" then
                        local pack_name = ingredient[1] or ingredient.name
                        if pack_name == old_pack then
                            -- Сохраняем количество, меняем только имя
                            if ingredient[1] then
                                ingredient[1] = new_pack
                            end
                            if ingredient.name then
                                ingredient.name = new_pack
                            end
                            replaced = true
                        end
                    end

                    table.insert(new_ingredients, new_ingredient)
                end

                -- Если что-то заменили, обновляем ingredients
                if replaced then
                    tech.unit.ingredients = new_ingredients
                    table.insert(modified_techs, tech_name)
                    log("Заменен пакет '"..old_pack.."' на '"..new_pack.."' в технологии '"..tech_name.."' (найден пакет '"..search_pack.."')")
                end
            end
        end
    end

    log("Обработано технологий: "..#modified_techs..", заменен пакет '"..old_pack.."' на '"..new_pack.."' где присутствует '"..search_pack.."'")
    return modified_techs
end
-- ##############################################################################################