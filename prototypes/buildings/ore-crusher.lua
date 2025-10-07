-- ##############################################################################################
--   ore1 = { r = 69 / 255, g = 91 / 255, b = 125 / 255, a = 1 },
--   ore2 = { r = 166 / 255, g = 165 / 255, b = 46 / 255, a = 1 },
--   ore3 = { r = 98 / 255, g = 144 / 255, b = 180 / 255, a = 1 },
--   ore4 = { r = 171 / 255, g = 171 / 255, b = 171 / 255, a = 1 },
--   ore5 = { r = 120 / 255, g = 39 / 255, b = 37 / 255, a = 1 },
--   ore6 = { r = 117 / 255, g = 76 / 255, b = 37 / 255, a = 1 },
-- ##############################################################################################
local add_tech_unlock = CTDmod.lib.recipe.add_tech_unlock
local tech = data.raw.technology
local recipe = data.raw.recipe
-- ##############################################################################################

-- ##############################################################################################
data:extend({
    --Burner-Ore-Crusher
    {
        type = "item",
        name = "CTD-burner-ore-crusher",
        icons = {
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/Angel/ore-crusher-icon-base.png",
                icon_size = 64,
                icon_mipmaps = 4
            },
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/Angel/ore-crusher-icon-mask.png",
                icon_size = 64,
                icon_mipmaps = 4,
                draw_as_glow = true,
                tint = { r = 69 / 255, g = 91 / 255, b = 125 / 255, a = 1 }
            },
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/Angel/ore-crusher-icon-highlights.png",
                icon_size = 64,
                icon_mipmaps = 4,
                draw_as_light = true
            },
        },
        subgroup = "CTD-ore-crusher",
        order = "a[CTD-burner-ore-crusher]",
        place_result = "CTD-burner-ore-crusher",
        stack_size = 10,
    },
    {
        type = "assembling-machine",
        name = "CTD-burner-ore-crusher",
        icons = {
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/Angel/ore-crusher-icon-base.png",
                icon_size = 64,
                icon_mipmaps = 4
            },
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/Angel/ore-crusher-icon-mask.png",
                icon_size = 64,
                icon_mipmaps = 4,
                draw_as_glow = true,
                tint = { r = 69 / 255, g = 91 / 255, b = 125 / 255, a = 1 }
            },
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/Angel/ore-crusher-icon-highlights.png",
                icon_size = 64,
                icon_mipmaps = 4,
                draw_as_light = true
            },
        },
        flags = { "placeable-neutral", "player-creation" },
        minable = { mining_time = 0.5, result = "CTD-burner-ore-crusher" },
        fast_replaceable_group = "CTD-ore-crusher",
        next_upgrade = "CTD-ore-crusher",
        max_health = 300,
        corpse = "big-remnants",
        dying_explosion = "medium-explosion",
        collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        crafting_categories = { "CTD-ore-refining-t1" },
        crafting_speed = 0.5,
        ingredient_count = 1,
        energy_source = {
            type = "burner",
            effectivity = 1,
            fuel_inventory_size = 1,
            emissions_per_minute = { pollution = 0.07 * 60 },
            smoke = {
                {
                    name = "smoke",
                    deviation = { 0.1, 0.1 },
                    frequency = 5,
                    position = util.by_pixel_hr(48, -108),
                    starting_vertical_speed = 0.08,
                    starting_frame_deviation = 60,
                },
            },
        },
        energy_usage = "100kW",
        graphics_set = {
            animation = {
                layers = {
                    {
                        filename = "__CTDaddon_for_K2_SE__/graphics/entity/Angel/ore-crusher/hr-ore-crusher-base.png",
                        priority = "extra-high",
                        width = 189,
                        height = 214,
                        frame_count = 16,
                        line_length = 4,
                        shift = util.by_pixel(-0.5, -5),
                        animation_speed = 0.5,
                        scale = 0.5
                    },
                    {
                        filename = "__CTDaddon_for_K2_SE__/graphics/entity/Angel/ore-crusher/hr-ore-crusher-mask.png",
                        priority = "extra-high",
                        width = 189,
                        height = 214,
                        repeat_count = 16,
                        shift = util.by_pixel(-0.5, -5),
                        draw_as_glow = true,
                        animation_speed = 0.5,
                        scale = 0.5,
                        tint = { r = 69 / 255, g = 91 / 255, b = 125 / 255, a = 1 }
                    },
                    {
                        filename = "__CTDaddon_for_K2_SE__/graphics/entity/Angel/ore-crusher/hr-ore-crusher-highlights.png",
                        priority = "extra-high",
                        width = 189,
                        height = 214,
                        repeat_count = 16,
                        shift = util.by_pixel(-0.5, -5),
                        draw_as_light = true,
                        animation_speed = 0.5,
                        scale = 0.5
                    },
                    {
                        filename = "__CTDaddon_for_K2_SE__/graphics/entity/Angel/ore-crusher/hr-ore-crusher-shadow.png",
                        priority = "extra-high",
                        width = 282,
                        height = 140,
                        repeat_count = 16,
                        shift = util.by_pixel(24, 17.5),
                        draw_as_shadow = true,
                        animation_speed = 0.5,
                        scale = 0.5,
                    },
                },
            },
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        working_sound = {
            sound = { filename = "__CTDaddon_for_K2_SE__/prototypes/sound/Angel/ore-crusher.ogg", volume = 0.6 },
            idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
            audible_distance_modifier = 0.5,
            apparent_volume = 1.25,
        },
    },
    {
        type = "recipe",
        name = "CTD-burner-ore-crusher",
        enabled = false,
        energy_required = 10,
        ingredients =
        {
            { type = "item", name = "stone-furnace", amount = 1 },
            { type = "item", name = "iron-gear-wheel", amount = 2 },
            { type = "item", name = "iron-plate", amount = 10 },
            { type = "item", name = "stone-brick", amount = 10 },
        },
        results = {{type="item", name="CTD-burner-ore-crusher", amount=1}}
    },
    --Ore-Crusher
    {
        type = "item",
        name = "CTD-ore-crusher",
        icons = {
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/Angel/ore-crusher-icon-base.png",
                icon_size = 64,
                icon_mipmaps = 4
            },
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/Angel/ore-crusher-icon-mask.png",
                icon_size = 64,
                icon_mipmaps = 4,
                draw_as_glow = true,
                tint = { r = 166 / 255, g = 165 / 255, b = 46 / 255, a = 1 }
            },
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/Angel/ore-crusher-icon-highlights.png",
                icon_size = 64,
                icon_mipmaps = 4,
                draw_as_light = true
            },
        },
        subgroup = "CTD-ore-crusher",
        order = "b[CTD-ore-crusher]",
        place_result = "CTD-ore-crusher",
        stack_size = 10,
    },
    {
        type = "assembling-machine",
        name = "CTD-ore-crusher",
        icons = {
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/Angel/ore-crusher-icon-base.png",
                icon_size = 64,
                icon_mipmaps = 4
            },
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/Angel/ore-crusher-icon-mask.png",
                icon_size = 64,
                icon_mipmaps = 4,
                draw_as_glow = true,
                tint = { r = 166 / 255, g = 165 / 255, b = 46 / 255, a = 1 }
            },
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/Angel/ore-crusher-icon-highlights.png",
                icon_size = 64,
                icon_mipmaps = 4,
                draw_as_light = true
            }
        },
        flags = { "placeable-neutral", "player-creation" },
        minable = { mining_time = 1, result = "CTD-ore-crusher" },
        fast_replaceable_group = "CTD-ore-crusher",
        -- next_upgrade = "CTD-ore-crusher-2",
        max_health = 300,
        corpse = "big-remnants",
        dying_explosion = "medium-explosion",
        collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        module_specification = {
            module_slots = 1
        },
        allowed_effects = { "consumption", "speed", "pollution", "productivity" },
        crafting_categories = { "CTD-ore-refining-t1" },
        crafting_speed = 1,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { pollution = 0.03 * 60 }
        },
        energy_usage = "100kW",
        ingredient_count = 3,
        graphics_set = {
            animation = {
                layers = {
                    {
                        filename = "__CTDaddon_for_K2_SE__/graphics/entity/Angel/ore-crusher/hr-ore-crusher-base.png",
                        priority = "extra-high",
                        width = 189,
                        height = 214,
                        frame_count = 16,
                        line_length = 4,
                        shift = util.by_pixel(-0.5, -5),
                        animation_speed = 0.5,
                        scale = 0.5,
                    },
                    {
                        filename = "__CTDaddon_for_K2_SE__/graphics/entity/Angel/ore-crusher/hr-ore-crusher-mask.png",
                        priority = "extra-high",
                        width = 189,
                        height = 214,
                        repeat_count = 16,
                        shift = util.by_pixel(-0.5, -5),
                        draw_as_glow = true,
                        animation_speed = 0.5,
                        scale = 0.5,
                        tint = { r = 166 / 255, g = 165 / 255, b = 46 / 255, a = 1 }
                    },
                    {
                        filename = "__CTDaddon_for_K2_SE__/graphics/entity/Angel/ore-crusher/hr-ore-crusher-highlights.png",
                        priority = "extra-high",
                        width = 189,
                        height = 214,
                        repeat_count = 16,
                        shift = util.by_pixel(-0.5, -5),
                        draw_as_light = true,
                        animation_speed = 0.5,
                        scale = 0.5
                    },
                    {
                        filename = "__CTDaddon_for_K2_SE__/graphics/entity/Angel/ore-crusher/hr-ore-crusher-shadow.png",
                        priority = "extra-high",
                        width = 282,
                        height = 140,
                        repeat_count = 16,
                        shift = util.by_pixel(24, 17.5),
                        draw_as_shadow = true,
                        animation_speed = 0.5,
                        scale = 0.5,
                    }
                }
            }
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        working_sound = {
            sound = { filename = "__CTDaddon_for_K2_SE__/prototypes/sound/Angel/ore-crusher.ogg", volume = 0.6 },
            idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
            audible_distance_modifier = 0.5,
            apparent_volume = 1.25,
        },
    },
    {
        type = "recipe",
        name = "CTD-ore-crusher",
        enabled = false,
        energy_required = 20,
        ingredients =
        {
            { type = "item", name = "CTD-burner-ore-crusher", amount = 1 },
            { type = "item", name = "electric-motor", amount = 2 },
            { type = "item", name = "copper-cable", amount = 10 },
        },
        results = {{type="item", name="CTD-ore-crusher", amount=1}}
    },
--     {
--     type = "item",
--     name = "ore-crusher-2",
--     icons = angelsmods.functions.add_number_icon_layer({
--       {
--         icon = "__angelsrefining__/graphics/icons/ore-crusher-base.png",
--         icon_size = 64,
--         icon_mipmaps = 4,
--       },
--     }, 2, angelsmods.refining.number_tint),
--     subgroup = "CTD-ore-crusher",
--     order = "c[ore-crusher-2]",
--     place_result = "ore-crusher-2",
--     stack_size = 10,
--   },
--   {
--     type = "assembling-machine",
--     name = "ore-crusher-2",
--     icons = angelsmods.functions.add_number_icon_layer({
--       {
--         icon = "__angelsrefining__/graphics/icons/ore-crusher-base.png",
--         icon_size = 64,
--         icon_mipmaps = 4,
--       },
--     }, 2, angelsmods.refining.number_tint),
--     flags = { "placeable-neutral", "player-creation" },
--     minable = { mining_time = 1, result = "ore-crusher-2" },
--     fast_replaceable_group = "CTD-ore-crusher",
--     next_upgrade = "ore-crusher-3",
--     max_health = 300,
--     corpse = "big-remnants",
--     dying_explosion = "medium-explosion",
--     collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
--     selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
--     module_specification = {
--       module_slots = 2,
--     },
--     allowed_effects = { "consumption", "speed", "pollution", "productivity" },
--     crafting_categories = { "ore-refining-t1" },
--     crafting_speed = 2,
--     energy_source = {
--       type = "electric",
--       usage_priority = "secondary-input",
--       emissions_per_minute = 0.04 * 60,
--     },
--     energy_usage = "125kW",
--     ingredient_count = 3,
--     animation = {
--       layers = {
--         {
--           filename = "__angelsrefining__/graphics/entity/ore-crusher/ore-crusher-base.png",
--           priority = "extra-high",
--           width = 94,
--           height = 108,
--           frame_count = 16,
--           line_length = 4,
--           shift = util.by_pixel(0, -5),
--           animation_speed = 0.5,
--           hr_version = angelsmods.trigger.enable_hq_graphics and {
--             filename = "__angelsrefining__/graphics/entity/ore-crusher/hr-ore-crusher-base.png",
--             priority = "extra-high",
--             width = 189,
--             height = 214,
--             frame_count = 16,
--             line_length = 4,
--             shift = util.by_pixel(-0.5, -5),
--             animation_speed = 0.5,
--             scale = 0.5,
--           } or nil,
--         },
--         {
--           filename = "__angelsrefining__/graphics/entity/ore-crusher/ore-crusher-shadow.png",
--           priority = "extra-high",
--           width = 141,
--           height = 72,
--           repeat_count = 16,
--           shift = util.by_pixel(25, 17),
--           draw_as_shadow = true,
--           animation_speed = 0.5,
--           hr_version = angelsmods.trigger.enable_hq_graphics and {
--             filename = "__angelsrefining__/graphics/entity/ore-crusher/hr-ore-crusher-shadow.png",
--             priority = "extra-high",
--             width = 282,
--             height = 140,
--             repeat_count = 16,
--             shift = util.by_pixel(24, 17.5),
--             draw_as_shadow = true,
--             animation_speed = 0.5,
--             scale = 0.5,
--           } or nil,
--         },
--       },
--     },
--     vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
--     working_sound = {
--       sound = { filename = "__angelsrefining__/sound/ore-crusher.ogg", volume = 0.6 },
--       idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
--       audible_distance_modifier = 0.5,
--       apparent_volume = 1.25,
--     },
--   },
--   {
--     type = "item",
--     name = "ore-crusher-3",
--     icons = angelsmods.functions.add_number_icon_layer({
--       {
--         icon = "__angelsrefining__/graphics/icons/ore-crusher-base.png",
--         icon_size = 64,
--         icon_mipmaps = 4,
--       },
--     }, 3, angelsmods.refining.number_tint),
--     subgroup = "CTD-ore-crusher",
--     order = "d[ore-crusher-3]",
--     place_result = "ore-crusher-3",
--     stack_size = 10,
--   },
--   {
--     type = "assembling-machine",
--     name = "ore-crusher-3",
--     icons = angelsmods.functions.add_number_icon_layer({
--       {
--         icon = "__angelsrefining__/graphics/icons/ore-crusher-base.png",
--         icon_size = 64,
--         icon_mipmaps = 4,
--       },
--     }, 3, angelsmods.refining.number_tint),
--     flags = { "placeable-neutral", "player-creation" },
--     minable = { mining_time = 1, result = "ore-crusher-3" },
--     fast_replaceable_group = "CTD-ore-crusher",
--     max_health = 300,
--     corpse = "big-remnants",
--     dying_explosion = "medium-explosion",
--     collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
--     selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
--     module_specification = {
--       module_slots = 3,
--     },
--     allowed_effects = { "consumption", "speed", "pollution", "productivity" },
--     crafting_categories = { "ore-refining-t1" },
--     crafting_speed = 3,
--     energy_source = {
--       type = "electric",
--       usage_priority = "secondary-input",
--       emissions_per_minute = 0.05 * 60,
--     },
--     energy_usage = "150kW",
--     ingredient_count = 3,
--     animation = {
--       layers = {
--         {
--           filename = "__angelsrefining__/graphics/entity/ore-crusher/ore-crusher-base.png",
--           priority = "extra-high",
--           width = 94,
--           height = 108,
--           frame_count = 16,
--           line_length = 4,
--           shift = util.by_pixel(0, -5),
--           animation_speed = 0.5,
--           hr_version = angelsmods.trigger.enable_hq_graphics and {
--             filename = "__angelsrefining__/graphics/entity/ore-crusher/hr-ore-crusher-base.png",
--             priority = "extra-high",
--             width = 189,
--             height = 214,
--             frame_count = 16,
--             line_length = 4,
--             shift = util.by_pixel(-0.5, -5),
--             animation_speed = 0.5,
--             scale = 0.5,
--           } or nil,
--         },
--         {
--           filename = "__angelsrefining__/graphics/entity/ore-crusher/ore-crusher-shadow.png",
--           priority = "extra-high",
--           width = 141,
--           height = 72,
--           repeat_count = 16,
--           shift = util.by_pixel(25, 17),
--           draw_as_shadow = true,
--           animation_speed = 0.5,
--           hr_version = angelsmods.trigger.enable_hq_graphics and {
--             filename = "__angelsrefining__/graphics/entity/ore-crusher/hr-ore-crusher-shadow.png",
--             priority = "extra-high",
--             width = 282,
--             height = 140,
--             repeat_count = 16,
--             shift = util.by_pixel(24, 17.5),
--             draw_as_shadow = true,
--             animation_speed = 0.5,
--             scale = 0.5,
--           } or nil,
--         },
--       },
--     },
--     vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
--     working_sound = {
--       sound = { filename = "__angelsrefining__/sound/ore-crusher.ogg", volume = 0.6 },
--       idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
--       audible_distance_modifier = 0.5,
--       apparent_volume = 1.25,
--     },
--   },
})

if tech["burner-mechanics"] then
    add_tech_unlock("CTD-burner-ore-crusher", "burner-mechanics")
end
if tech["automation"] then
    add_tech_unlock("CTD-ore-crusher", "automation")
end
-- ##############################################################################################

-- ##############################################################################################
if recipe["CTD-sand-from-crushed-stone"]  or recipe["CTD-sand-from-slag"] then
    recipe["sand"].enebled = false
    recipe["kr-sand"].enabled = false
end
-- ##############################################################################################