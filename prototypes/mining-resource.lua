-- ##############################################################################################
local chance = 0.15
-- ##############################################################################################
local mining_config = {
    disable_generation = {"stone"},  -- Отключаем генерацию
    remove_recipes = {"stone"},      -- Удаляем рецепты добычи

    byproducts = {
        ["iron-ore"] = {
            {item = "stone", probability = chance, amount_min = 1, amount_max = 1}
        },
        ["copper-ore"] = {
            {item = "stone", probability = chance, amount_min = 1, amount_max = 1}
        },
        ["uranium-ore"] = {
            {item = "stone", probability = chance, amount_min = 1, amount_max = 1}
        },
        ["kr-rare-metal-ore"] = {
            {item = "stone", probability = chance, amount_min = 1, amount_max = 1}
        },
        ["coal"] = {
            {item = "stone", probability = 0.05, amount_min = 1, amount_max = 1}
        },
    },

    virtual_recipes = {
        {item = "stone", subgroup = "raw-resource", order = "d[stone]-a[virtual]"}
    }
}

CTDmod.lib.resource.setup_mining_system(mining_config)
-- ##############################################################################################