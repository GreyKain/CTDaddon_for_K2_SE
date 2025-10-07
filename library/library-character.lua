-- ##############################################################################################
if not CTDmod.lib.character then
    CTDmod.lib.character = {}
end
-- ##############################################################################################
--- Функция для изменения категорий крафта у всех персонажей
function CTDmod.lib.character.update_all_crafting(categories)
    -- Обрабатываем всех персонажей из всех модов
    for _, char in pairs(data.raw["character"]) do
        -- Проверяем, что это действительно персонаж
        if char.crafting_categories then
            -- Полная замена категорий (если нужно добавить, а не заменить - см. альтернативный вариант ниже)
            char.crafting_categories = table.deepcopy(categories)

            -- Альтернатива: добавить категории, не удаляя существующие
            -- for _, category in ipairs(categories) do
            --     char.crafting_categories[category] = true
            -- end
        end
    end
end
-- Пример использования:
-- CTDmod.lib.character.update_all_crafting({
--     "CTD-handmade",      -- Ваша новая категория
--     "crafting",          -- Стандартная категория ручного крафта
--     "advanced-crafting"  -- Дополнительные категории по необходимости
-- })
-- ##############################################################################################