-- ##############################################################################################
-----------------------------------------НАСТРОЙКИ CTD-------------------------------------------
data:extend(
	{
		{
			type = "string-setting",
			name = "CTD-hand-crafting",
			setting_type = "startup",
			allowed_values = {
				"allowed",
				"slowing-down",
				"forbidden",
				"forbidden-and-hidden"
			},
			default_value = "forbidden",
			order = "0000"
		},
		{
			type = "bool-setting",
			name = "CTD-new-tree-recipes",
			setting_type ="startup",
			default_value = false,
			order = "0001"
		},
		{
			type = "bool-setting",
			name = "CTD-crafting-time",
			setting_type = "startup",
			default_value = true,
			order = "0002"
		},
		{
			type = "string-setting",
			name = "CTD-efficiency",
			setting_type = "startup",
			allowed_values = {
				"off",
				"standard",
				"hardcore"
			},
			default_value = "standard",
			order = "0003"
		},
		{
			type = "int-setting",
			name = "CTD-player-corpse-life",
			default_value = 180,
			minimum_value = 0,
			maximum_value = 1440,
			setting_type = "startup",
			order = "9997"
		},
		{
			type = "double-setting",
			name = "CTD-healing-per-second",
			default_value = 1,
			minimum_value = 0,
			maximum_value = 20,
			setting_type = "startup",
			order = "9998"
		},
		{
			type = "int-setting",
			name = "CTD-seconds-to-stay-in-combat",
			default_value = 30,
			minimum_value = 0,
			maximum_value = 180,
			setting_type = "startup",
			order = "9999"
		},
		{
			type = "string-setting",
			name = "CTD-main-menu-music",
			setting_type = "startup",
			allowed_values = {
				"Default",
				"All in one",
				"Falconshield -The Factory Must Grow",
				"Niovel - The Factory Must Grow",
				"Kuroi Riquid, Factorio Fan Song - I live here now",
				"Kuroi Riquid, Factorio Fan Song - Beautiful Disaster",
				"Kuroi Riquid, Factorio Fan Song - Inserter Dance",
				"QWC - The Factory must grow!"

			},
			default_value = "All in one",
			order = "99999"
		},
		-- {
		-- 	type = "bool-setting",
		-- 	name = "new-icons",
		-- 	setting_type = "startup",
		-- 	default_value = true,
		-- 	order = "0400"
		-- },
		-- {
		-- 	type = "bool-setting",
		-- 	name = "pollution-causes-damage",
		-- 	setting_type = "startup",
		-- 	default_value = true,
		-- 	order = "0500"
		-- },
	}
)
-- ##############################################################################################

-- ##############################################################################################
if mods ["boblogistics"] then
	data:extend({
	{
		type = "string-setting",
		name = "CTD-start-loot",
		setting_type = "startup",
		allowed_values = {
			"with_Bob"
		},
		default_value = "with_Bob",
		forced_value = "with_Bob",
		order = "99999999",
		hidden = true
	}

	})
else
	data:extend({
	{
		type = "string-setting",
		name = "CTD-start-loot",
		setting_type = "startup",
		allowed_values = {
			"without_Bob"
		},
		default_value = "without_Bob",
		forced_value = "without_Bob",
		order = "99999999",
		hidden = true
	}

	})
end
-- ##############################################################################################
if mods ["aai-industry"] and mods ["bobassembly"] and mods ["reskins-compatibility"] then
	data:extend(
		{
			{
			type = "string-setting",
			name = "CTD-size-burner-assembler",
			setting_type = "startup",
			default_value = "3x3",
			allowed_values = {"2x2", "3x3"},
			order = "0600"
			}
		}
	)
end