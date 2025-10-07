-- ##############################################################################################
local function hide_setting(s_type, s_name, f_value)
    local object = data.raw[s_type][s_name]
    if data.raw[s_type] and object then
        object.hidden = true
        if s_type ~= "bool-setting" then
            if f_value ~= nil then
                object.default_value = f_value
                object.allowed_values = {f_value}
            else
                object.default_value = object.default_value
                object.allowed_values = object.allowed_values
            end
        else
            if f_value ~= nil then
                object.forced_value = f_value
            else
                object.forced_value = object.forced_value
            end
        end
    else
        log({"Настройка '".. s_type .."' / '".. s_name .."' не найдена!"})
    end
end
-- ##############################################################################################

-- ##############################################################################################
if mods ["Krastorio2"] then
    hide_setting("bool-setting", "kr-main-menu-song", false)
end
-- ##############################################################################################

-- ##############################################################################################
-- ------------------------------------НАСТРОЙКИ СТОРОНИХ МОДОВ-------------------------------------
-- if mods ["aai-industry"] then
--     hide_setting("bool-setting", "aai-fast-motor-crafting", false)
--     hide_setting("bool-setting", "aai-wide-drill")
--     hide_setting("int-setting", "aai-burner-turbine-efficiency", 45)
--     hide_setting("int-setting", "aai-fuel-processor-efficiency", 5)
--     hide_setting("bool-setting", "aai-fuel-processor", true)
--     hide_setting("bool-setting", "aai-stone-path", true)
-- end
-- -- ##############################################################################################
-- if mods ["aai-loaders"] then
--     hide_setting("bool-setting", "aai-loaders-fit-assemblers", true)
-- end
-- -- ##############################################################################################
-- if mods ["bobassembly"] then
--     hide_setting("bool-setting", "bobmods-assembly-limits", true)
-- end
-- -- ##############################################################################################
-- if mods ["bobenemies"] then
--     hide_setting("bool-setting", "bobmods-enemies-enableartifacts", false)
--     hide_setting("bool-setting", "bobmods-enemies-enablesmallartifacts", false)
--     hide_setting("bool-setting", "bobmods-enemies-enablenewartifacts", false)
--     hide_setting("bool-setting", "bobmods-enemies-aliensdropartifacts", false)
-- end
-- -- ##############################################################################################
-- if mods ["bobmining"] then
--     hide_setting("bool-setting", "bobmods-mining-areadrills", false)
--     if mods ["aai-industry"] then
--         hide_setting("bool-setting", "bobmods-mining-steamminingdrills", false)
--     end
-- end
-- -- ##############################################################################################
-- if mods ["bobores"] then
--     hide_setting("bool-setting", "bobmods-ores-infiniteore", false)
--     hide_setting("bool-setting", "bobmods-ores-enablecobaltore", false)
--     hide_setting("bool-setting", "bobmods-ores-enablesulfur", false)
--     hide_setting("bool-setting", "bobmods-ores-enablewaterores", true)
--     hide_setting("bool-setting", "bobmods-ores-startinggroundwater", false)
--     hide_setting("bool-setting", "bobmods-ores-leadgivesnickel", false)
--     hide_setting("double-setting", "bobmods-ores-leadnickelratio")
--     hide_setting("bool-setting", "bobmods-ores-nickelgivescobalt", true)
--     hide_setting("double-setting", "bobmods-ores-nickelcobaltratio", 0.05)
--     hide_setting("bool-setting", "bobmods-ores-gemsfromotherores", true)
--     hide_setting("bool-setting", "bobmods-ores-unsortedgemore", true)
--     hide_setting("double-setting", "bobmods-ores-gemprobability", 0.01)
--     hide_setting("double-setting", "bobmods-gems-rubyratio")
--     hide_setting("double-setting", "bobmods-gems-sapphireratio")
--     hide_setting("double-setting", "bobmods-gems-emeraldratio")
--     hide_setting("double-setting", "bobmods-gems-amethystratio")
--     hide_setting("double-setting", "bobmods-gems-topazratio")
--     hide_setting("double-setting", "bobmods-gems-diamondratio")
-- end
-- -- ##############################################################################################
-- if mods ["bobplates"] then
--     hide_setting("bool-setting", "bobmods-plates-cheapersteel", false)
--     hide_setting("bool-setting", "bobmods-plates-bluedeuterium", true)
-- end
-- -- ##############################################################################################