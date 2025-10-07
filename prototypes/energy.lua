-- ##############################################################################################
local burner_generator = data.raw["burner-generator"]
local generator = data.raw["generator"]
local boiler = data.raw["boiler"]
local reactor = data.raw["reactor"]
local assembler = data.raw["assembling-machine"]
local radar = data.raw["radar"]
local pump = data.raw["offshore-pump"]
local lab = data.raw["lab"]
-- ##############################################################################################

-- ##############################################################################################
if settings.startup["CTD-efficiency"].value == "standard" then
		-- теплоёмкость
	data.raw.fluid["water"].heat_capacity = "2kJ" -- вода
	data.raw.fluid["steam"].heat_capacity = "0.2kJ" -- пар
		-- КПД паровых движков
	generator["steam-engine"].effectivity = 0.7
	generator["steam-engine"].fluid_usage_per_tick = 0.5
	generator["steam-engine"].max_power_output = nil
		-- КПД бойлеров
	boiler["boiler"].energy_source.effectivity = 0.7
	boiler["boiler"].energy_consumption = "1.8MW"
	boiler["boiler"].energy_source.emissions_per_minute = { pollution = 30 }
	if mods ["aai-industry"] then
		-- КПД Твердотопливной турбины-генератора
		burner_generator["burner-turbine"].burner.effectivity = 0.45
		burner_generator["burner-turbine"].max_power_output = "800kW"

		pump["offshore-pump"].energy_usage = "60kW"
		pump["offshore-pump"].pumping_speed = 2	-- 120л/сек

		assembler["burner-assembling-machine"].energy_source.effectivity = 0.45
		assembler["burner-assembling-machine"].crafting_speed = 0.25
	end

	lab["burner-lab"].energy_source.effectivity = 0.45
	lab["burner-lab"].researching_speed = 0.5

end
-- ##############################################################################################

-- ##############################################################################################
if settings.startup["CTD-efficiency"].value == "hardcore" then
		-- КПД паровых движков
	generator["steam-engine"].effectivity = 0.25
		-- КПД бойлеров
	boiler["boiler"].energy_source.effectivity = 0.55
	if mods ["aai-industry"] then
			-- КПД Твердотопливной турбины-генератора
		burner_generator["burner-turbine"].burner.effectivity = 0.1
		burner_generator["burner-turbine"].max_power_output = "800kW"

		pump["offshore-pump"].energy_usage = "60kW"
		pump["offshore-pump"].pumping_speed = 120/60

		assembler["burner-assembling-machine"].energy_source.effectivity = 0.45
		assembler["burner-assembling-machine"].crafting_speed = 0.25
	end
	lab["burner-lab"].energy_source.effectivity = 0.45
	lab["burner-lab"].researching_speed = 0.5

end
-- ##############################################################################################

-- ##############################################################################################
	-- увеличение потребления эл.энергии радарами х3
-- radar["radar"].energy_usage = "900kW"

-- if mods ["bobwarfare"] then
-- 	radar["bob-radar-2"].energy_usage = "1.35MW"
-- 	radar["bob-radar-3"].energy_usage = "1.8MW"
-- 	radar["bob-radar-4"].energy_usage = "2.25MW"
-- 	radar["bob-radar-5"].energy_usage = "2.7MW"
-- end
-- ##############################################################################################

-- ##############################################################################################
-- reactor["burner-reactor"].energy_source.effectivity = 0.75
-- reactor["burner-reactor-2"].energy_source.effectivity = 0.85

-- reactor["fluid-reactor"].energy_source.effectivity = 0.8
-- reactor["fluid-reactor-2"].energy_source.effectivity = 0.9
-- ##############################################################################################

-- ##############################################################################################
-- 	reactor["burner-reactor"].energy_source.effectivity = 0.75
-- 	reactor["burner-reactor-2"].energy_source.effectivity = 0.87

-- 	reactor["fluid-reactor"].energy_source.effectivity = 0.76
-- 	reactor["fluid-reactor-2"].energy_source.effectivity = 0.88
-- ##############################################################################################