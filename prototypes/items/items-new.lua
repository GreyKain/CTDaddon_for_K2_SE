-- ##############################################################################################
local item_sounds = require("__base__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")
-- ##############################################################################################

-- ##############################################################################################
require("prototypes.buildings.ore-crusher")                     -- Дробилки руды
require("prototypes.buildings.boiler")                          -- Бойлеры
require("prototypes.buildings.steam-engine")                    -- Паровые генераторы
require("crushed-stone")                                        -- Щебень
require("slag")                                                 -- Шлак
require("crushed-iron-ore")                                     -- Дробленная железная руда
require("crushed-copper-ore")                                   -- Дробленная медная руда
require("sifted-crushed-iron-ore")                              -- Просеянная железная руда
require("sifted-crushed-copper-ore")                            -- Просеянная медная руда
if settings.startup["CTD-new-tree-recipes"].value then
    require("new-tree")                                         -- Деревья, брёвна
end
-- ##############################################################################################