-- ##############################################################################################
local add_science_pack = CTDmod.lib.tech.add_science_pack
local raw_tech = data.raw.technology
local remove_science_pack = CTDmod.lib.tech.remove_science_pack_if_another_exists
local replace_science_pack = CTDmod.lib.tech.replace_science_pack
local replace_science_pack_globally = CTDmod.lib.tech.replace_science_pack_globally
-- ##############################################################################################

-- ##############################################################################################
raw_tech["steam-power"].unit =
	{
		count = 50,
		ingredients =
		{
			{"kr-basic-tech-card", 1},
			{"automation-science-pack", 1}
		},
		time = 30
	}
-- ##############################################################################################

-- ##############################################################################################
add_science_pack("kr-fluids-chemistry", "logistic-science-pack")
-- ##############################################################################################