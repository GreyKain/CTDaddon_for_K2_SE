-- ##############################################################################################
local ammo = data.raw["ammo"]
local turret = data.raw["ammo-turret"]
local item = data.raw["item"]
local assembler = data.raw["assembling-machine"]
-- ##############################################################################################

-- ##############################################################################################
    -- УГОЛЬ
-- item["coal"].icon = "__base__/graphics/icons/coal.png"
-- item["coal"].pictures = {
--     {size = 64, filename = "__base__/graphics/icons/coal.png", scale = 0.5, mipmap_count = 4},
--     {size = 64, filename = "__base__/graphics/icons/coal-1.png", scale = 0.5, mipmap_count = 4},
--     {size = 64, filename = "__base__/graphics/icons/coal-2.png", scale = 0.5, mipmap_count = 4},
--     {size = 64, filename = "__base__/graphics/icons/coal-3.png", scale = 0.5, mipmap_count = 4}
-- }
-- ##############################################################################################
-- ИЗМЕНЕНИЕ СКОРОСТИ КРАФТА РАЗБИТЫХ СБОРЩИКОВ С КОРАБЛЯ
-- ##############################################################################################
if assembler["kr-spaceship-material-fabricator-1"] then
    assembler["kr-spaceship-material-fabricator-1"].crafting_speed = 0.25
end
-- ##############################################################################################
require("fix-pipe")                   -- изменение труб
-- ##############################################################################################