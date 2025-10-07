-- ##############################################################################################
if not CTDmod.lib.resource then CTDmod.lib.resource = {} end
-- ##############################################################################################

-- ##############################################################################################
--- Создает валидную пустую спецификацию autoplace для ресурса
function CTDmod.lib.resource.create_valid_autoplace(resource_name)
    if not data.raw.resource[resource_name] then
        return false
    end

    local resource = data.raw.resource[resource_name]

    -- Создаем минимальную валидную спецификацию autoplace
    resource.autoplace = {
        control = "stone",  -- Используем существующий контроль
        order = "z",        -- Низкий приоритет
        probability_expression = "0",
        richness_expression = "0",

        -- Минимальные настройки для валидности
        sharpness = 1,
        richness_multiplier = 0,
        richness_base = 0,
        size_control_multiplier = 0,
        coverage = 0,  -- 0% покрытия = не генерируется

        peaks = {
            {
                influence = 0,  -- Влияние = 0 = не генерируется
                noise_layer = "stone",
                noise_octaves_difference = -0.5,
                noise_persistence = 0.3
            }
        }
    }

    log("Создана валидная autoplace спецификация для '"..resource_name.."'")
    return true
end
-- ##############################################################################################

-- ##############################################################################################
--- Настраивает ресурс так, чтобы он не генерировался на карте, но был валидным
function CTDmod.lib.resource.disable_resource_generation(resource_name)
    if not data.raw.resource[resource_name] then
        log("Ресурс '"..resource_name.."' не найден")
        return false
    end

    local resource = data.raw.resource[resource_name]

    -- Создаем валидную autoplace спецификацию
    CTDmod.lib.resource.create_valid_autoplace(resource_name)

    -- Настраиваем добычу так, чтобы ресурс нельзя было добыть напрямую
    -- resource.minable = {
    --     mining_time = 999,  -- Очень долгая добыча
    --     results = {}        -- Пустые результаты
    -- }

    -- Скрываем в интерфейсе
    resource.hidden = true

    log("Генерация ресурса '"..resource_name.."' на карте отключена")
    return true
end
-- ##############################################################################################

-- ##############################################################################################
--- Добавляет побочные предметы при добыче ресурсов с корректировкой вероятностей основных продуктов
function CTDmod.lib.resource.add_mining_byproducts(byproducts_config)
    local stats = {
        resources_modified = 0,
        byproducts_added = 0,
        main_products_adjusted = 0,
        errors = {}
    }

    if not byproducts_config or type(byproducts_config) ~= "table" then
        table.insert(stats.errors, "Неверная конфигурация byproducts_config")
        return stats
    end

    for resource_name, byproducts in pairs(byproducts_config) do
        local resource = data.raw.resource[resource_name]

        if not resource then
            table.insert(stats.errors, "Ресурс '"..resource_name.."' не найден")
            goto continue
        end

        -- Инициализируем minable если нужно
        if not resource.minable then
            resource.minable = {
                hardness = 0.9,
                mining_time = 2,
                results = {}
            }
        end
        
        -- Убедимся, что results существует
        if not resource.minable.results then
            if resource.minable.result then
                -- Конвертируем старый формат в новый
                resource.minable.results = {
                    {
                        type = "item",
                        name = resource.minable.result,
                        amount = resource.minable.count or 1,
                        probability = 1.0  -- Основной продукт имеет 100% вероятность
                    }
                }
                resource.minable.result = nil
                resource.minable.count = nil
            else
                resource.minable.results = {}
            end
        end

        -- Рассчитываем общую вероятность побочных продуктов
        local total_byproduct_probability = 0
        for _, byproduct in ipairs(byproducts) do
            if byproduct.probability then
                total_byproduct_probability = total_byproduct_probability + byproduct.probability
            end
        end

        -- Корректируем вероятности основных продуктов
        if total_byproduct_probability > 0 and total_byproduct_probability <= 1 then
            local main_product_adjusted = false
            
            for _, result in ipairs(resource.minable.results) do
                if result.probability and result.probability == 1.0 then
                    -- Основной продукт с 100% вероятностью
                    result.probability = 1.0 - total_byproduct_probability
                    main_product_adjusted = true
                    stats.main_products_adjusted = stats.main_products_adjusted + 1
                    log("Скорректирована вероятность основного продукта для '"..resource_name.."' с 1.0 до "..(1.0 - total_byproduct_probability))
                elseif result.probability then
                    -- Продукт с уже установленной вероятностью - уменьшаем пропорционально
                    local new_probability = result.probability * (1.0 - total_byproduct_probability)
                    if new_probability > 0 then
                        result.probability = new_probability
                        main_product_adjusted = true
                        stats.main_products_adjusted = stats.main_products_adjusted + 1
                        log("Скорректирована вероятность продукта для '"..resource_name.."' с "..result.probability.." до "..new_probability)
                    end
                end
            end

            -- Если не нашли продуктов с явной вероятностью, добавляем корректировку к первому продукту
            if not main_product_adjusted and #resource.minable.results > 0 then
                local first_result = resource.minable.results[1]
                if not first_result.probability then
                    first_result.probability = 1.0 - total_byproduct_probability
                    stats.main_products_adjusted = stats.main_products_adjusted + 1
                    log("Установлена вероятность первого продукта для '"..resource_name.."' на "..(1.0 - total_byproduct_probability))
                end
            end
        elseif total_byproduct_probability > 1 then
            table.insert(stats.errors, "Суммарная вероятность побочных продуктов превышает 100% для ресурса '"..resource_name.."'")
            goto continue
        end

        -- Добавляем побочные продукты
        for _, byproduct in ipairs(byproducts) do
            if not data.raw.item[byproduct.item] then
                table.insert(stats.errors, "Предмет '"..byproduct.item.."' не найден")
                goto next_byproduct
            end

            if not byproduct.probability or byproduct.probability < 0 or byproduct.probability > 1 then
                table.insert(stats.errors, "Неверная вероятность для '"..byproduct.item.."' в ресурсе '"..resource_name.."'")
                goto next_byproduct
            end

            -- Добавляем побочный продукт
            table.insert(resource.minable.results, {
                type = "item",
                name = byproduct.item,
                amount_min = byproduct.amount_min or 1,
                amount_max = byproduct.amount_max or 1,
                probability = byproduct.probability
            })

            stats.byproducts_added = stats.byproducts_added + 1
            log("Добавлен побочный продукт '"..byproduct.item.."' (вероятность: "..(byproduct.probability * 100).."%) для ресурса '"..resource_name.."'")

            ::next_byproduct::
        end

        stats.resources_modified = stats.resources_modified + 1
        ::continue::
    end

    log("Модифицировано ресурсов: "..stats.resources_modified..", добавлено побочных продуктов: "..stats.byproducts_added..", скорректировано основных продуктов: "..stats.main_products_adjusted)
    return stats
end
-- ##############################################################################################

-- ##############################################################################################
--- Удаляет рецепты прямой добычи ресурса
function CTDmod.lib.resource.remove_mining_recipes(resources)
    local stats = {
        recipes_removed = 0,
        errors = {}
    }

    for _, resource_name in ipairs(resources) do
        -- Удаляем рецепт добычи если есть
        if data.raw.recipe[resource_name] then
            data.raw.recipe[resource_name] = nil
            stats.recipes_removed = stats.recipes_removed + 1
            log("Рецепт добычи '"..resource_name.."' удален")
        end

        -- Скрываем технологию если есть
        local tech_name = resource_name .. "-mining"
        if data.raw.technology[tech_name] then
            data.raw.technology[tech_name].hidden = true
            data.raw.technology[tech_name].enabled = false
            log("Технология '"..tech_name.."' скрыта")
        end
    end

    return stats
end
-- ##############################################################################################

-- ##############################################################################################
--- Создает виртуальный рецепт для предмета
function CTDmod.lib.recipe.create_virtual_recipe(item_name, subgroup, order)
    if not data.raw.item[item_name] then
        log("Предмет '"..item_name.."' не найден для виртуального рецепта")
        return false
    end

    local recipe_name = "CTD-virtual-" .. item_name

    if not data.raw.recipe[recipe_name] then
        data:extend({
            {
                type = "recipe",
                name = recipe_name,
                localised_name = {"recipe-name." .. item_name},
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
                subgroup = subgroup or "other",
                order = order or "z[virtual]"
            }
        })
        log("Создан виртуальный рецепт для: " .. item_name)
        return true
    end

    return false
end
-- ##############################################################################################

-- ##############################################################################################
--- Полная настройка системы побочных продуктов добычи
function CTDmod.lib.resource.setup_mining_system(full_config)
    local total_stats = {}

    -- 1. Отключаем генерацию ресурса на карте (с созданием валидной autoplace)
    if full_config.disable_generation then
        for _, resource_name in ipairs(full_config.disable_generation) do
            CTDmod.lib.resource.disable_resource_generation(resource_name)
        end
    end

    -- 2. Удаляем рецепты прямой добычи
    if full_config.remove_recipes then
        total_stats.recipes = CTDmod.lib.resource.remove_mining_recipes(full_config.remove_recipes)
    end

    -- 3. Добавляем побочные продукты
    if full_config.byproducts then
        total_stats.byproducts = CTDmod.lib.resource.add_mining_byproducts(full_config.byproducts)
    end

    -- 4. Создаем виртуальные рецепты
    if full_config.virtual_recipes then
        for _, recipe_config in ipairs(full_config.virtual_recipes) do
            CTDmod.lib.recipe.create_virtual_recipe(
                recipe_config.item,
                recipe_config.subgroup,
                recipe_config.order
            )
        end
    end

    log("Система добычи с побочными продуктами настроена")
    return total_stats
end
-- ##############################################################################################