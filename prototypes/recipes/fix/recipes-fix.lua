-- ##############################################################################################
local remove_ingredient_if_another_exists = CTDmod.lib.recipe.remove_ingredient_if_another_exists
-- ##############################################################################################
-- ИСПРАВЛЕНИЕ "КОСЯКОВ" С МЕДНОЙ ПРОВОЛОКОЙ ПРИ МОДЕ "GetWiresBack"
-- ##############################################################################################
if mods ["GetWiresBack"] then
    remove_ingredient_if_another_exists("copper-wire", "copper-cable")
end
-- ##############################################################################################
require("fix-sand")                     -- песок
require("fix-stone-brick")              -- каменные блоки
require("fix-concrete")                 -- бетон
require("fix-kr-iron-beam")             -- железные балки
require("fix-kr-steel-beam")            -- стальные балки
require("fix-wood-mining")              -- добыча древесины
require("fix-belts")                    -- конвейры
require("fix-splitters")                -- разделители
require("fix-gun-turret")               -- турели
require("fix-steel-pipe")               -- стальные трубы
-- ##############################################################################################