-- ##############################################################################################
local item_sounds = require("__base__.prototypes.item_sounds")
-- ##############################################################################################

-- ##############################################################################################
data:extend(
{
    {
        type = "item",
        name = "CTD-slag",
        icons = {
            {
                icon = "__CTDaddon_for_K2_SE__/graphics/icons/slag.png",
                icon_size = 64,
                icon_mipmaps = 4
            }
        },
        subgroup = "stone",
        order = "a[stone]-c[CTD-slag]",
        inventory_move_sound = item_sounds.resource_inventory_move,
        pick_sound = item_sounds.resource_inventory_pickup,
        drop_sound = item_sounds.resource_inventory_move,
        stack_size = 100,
        weight = 1 * kg
    },
})
-- ##############################################################################################