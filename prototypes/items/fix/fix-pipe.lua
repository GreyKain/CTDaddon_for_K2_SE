-- ##############################################################################################
local underpipe = data.raw["pipe-to-ground"]
-- ##############################################################################################
-- ИЗМЕНЕНИЕ РАССТОЯНИЯ ПОДЗЕМНЫХ ТРУБ
-- ##############################################################################################
if mods["boblogistics"] then
    -- Функция для установки расстояния
    local function set_pipe_distance(pipe_name, distance)
        if underpipe[pipe_name] and underpipe[pipe_name].fluid_box then
            -- Способ 1: через прямое обращение к индексу
            if underpipe[pipe_name].fluid_box.pipe_connections[2] then
                underpipe[pipe_name].fluid_box.pipe_connections[2].max_underground_distance = distance
            end

            -- Способ 2: устанавливаем для всех подходящих подключений
            for _, connection in pairs(underpipe[pipe_name].fluid_box.pipe_connections) do
                if connection.max_underground_distance then
                    connection.max_underground_distance = distance
                end
            end

            -- Способ 3: устанавливаем глобально для всей трубы
            underpipe[pipe_name].max_underground_distance = distance
        end
    end

    set_pipe_distance("pipe-to-ground", 11)
    set_pipe_distance("kr-steel-pipe-to-ground", 15)
end
-- ##############################################################################################