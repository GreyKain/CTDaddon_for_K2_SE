-- ##############################################################################################
local add_tech_unlock = CTDmod.lib.recipe.add_tech_unlock

local steam_drop_move = {
    filename = "__base__/sound/item/steam-inventory-move.ogg",
    volume = 0.6,
}
local steam_pick = {
    filename = "__base__/sound/item/steam-inventory-pickup.ogg",
    volume = 0.4,
}
-- ##############################################################################################

-- ##############################################################################################
data:extend({
    {
        type = "item-subgroup",
        name = "CTD-energy-steam-engine",
        group = "production",
        order = "b-b1",
    },
})

data.raw["item"]["steam-engine"].order = "b[steam-power]-b[steam-engine-1]"
data.raw["item"]["steam-engine"].subgroup = "CTD-energy-steam-engine"

data:extend({
    {
        type = "item",
        name = "CTD-steam-engine-2",
        icon = "__base__/graphics/icons/steam-engine.png",
        icon_size = 64,
        subgroup = "CTD-energy-steam-engine",
        order = "b[steam-power]-b[steam-engine-2]",
        place_result = "CTD-steam-engine-2",
        stack_size = 10,
        drop_sound = steam_drop_move,
        inventory_move_sound = steam_drop_move,
        pick_sound = steam_pick,
    },
    {
        type = "recipe",
        name = "CTD-steam-engine-2",
        enabled = false,
        ingredients = {
            { type = "item", name = "steam-engine", amount = 1 },
            { type = "item", name = "steel-plate", amount = 5 },
            { type = "item", name = "pipe", amount = 5 },
            { type = "item", name = "iron-gear-wheel", amount = 5 },
        },
        results = { { type = "item", name = "CTD-steam-engine-2", amount = 1 } },
    },
    util.merge({
        data.raw.generator["steam-engine"],
        {
            name = "CTD-steam-engine-2",
            icon = "__base__/graphics/icons/steam-engine.png",
            localised_description = { "entity-description.steam-engine" },
            icon_size = 64,
            minable = { mining_time = 1, result = "CTD-steam-engine-2" },
            max_health = 500,
            maximum_temperature = 315,
            -- next_upgrade = "CTD-steam-engine-3",
            effectivity = 0.75
        },
        }),
})
-- ##############################################################################################

-- ##############################################################################################
add_tech_unlock("CTD-steam-engine-2", "kr-steel-fluid-handling")
-- ##############################################################################################
