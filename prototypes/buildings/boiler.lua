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
        name = "CTD-energy-boiler",
        group = "production",
        order = "b-a1",
    },
})

data.raw.item["boiler"].order = "b[steam-power]-a[boiler-1]"
data.raw.item["boiler"].subgroup = "CTD-energy-boiler"
data:extend({
    {
        type = "item",
        name = "CTD-boiler-2",
        icon = "__base__/graphics/icons/boiler.png",
        icon_size = 64,
        subgroup = "CTD-energy-boiler",
        order = "b[steam-power]-a[boiler-2]",
        place_result = "CTD-boiler-2",
        stack_size = 50,
        drop_sound = steam_drop_move,
        inventory_move_sound = steam_drop_move,
        pick_sound = steam_pick,
    },
    {
        type = "recipe",
        name = "CTD-boiler-2",
        enabled = false,
        ingredients = {
            { type = "item", name = "boiler", amount = 1 },
            { type = "item", name = "steel-plate", amount = 5 },
        },
        results = { { type = "item", name = "CTD-boiler-2", amount = 1 } },
    },
    util.merge({
        data.raw.boiler["boiler"],
        {
                name = "CTD-boiler-2",
            icon = "__base__/graphics/icons/boiler.png",
            localised_description = { "entity-description.boiler" },
            icon_size = 64,
            minable = { mining_time = 0.5, result = "CTD-boiler-2" },
            -- next_upgrade = "CTD-boiler-3",
            max_health = 250,
            target_temperature = 315,
            energy_consumption = "3.6MW",
            energy_source = {
            emissions_per_minute = { pollution = 30 },
            effectivity = 0.75
            },
        },
    }),
})
-- ##############################################################################################

-- ##############################################################################################
add_tech_unlock("CTD-boiler-2", "kr-steel-fluid-handling")
-- ##############################################################################################