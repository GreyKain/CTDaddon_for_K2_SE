-- ##############################################################################################
local music = settings.startup["CTD-main-menu-music"].value
-- ##############################################################################################

-- ##############################################################################################
-------------------------------ИЗМЕНЕНИЕ ГЛАВНОЙ МУЗЫКАЛЬНОЙ ТЕМЫ--------------------------------
if music == "Niovel - The Factory Must Grow" then
    data.raw["ambient-sound"]["main-menu"].sound = "__CTDaddon_for_K2_SE__/prototypes/music/The_Factory_Must_Grow.ogg"
elseif music == "Falconshield -The Factory Must Grow" then
    data.raw["ambient-sound"]["main-menu"].sound = "__CTDaddon_for_K2_SE__/prototypes/music/THE-FACTORY-MUST-GROW-Falconshield.ogg"
elseif music == "Kuroi Riquid, Factorio Fan Song - I live here now" then
    data.raw["ambient-sound"]["main-menu"].sound = "__CTDaddon_for_K2_SE__/prototypes/music/Factorio-Fan-Song-I-live-here-now.ogg"
elseif music == "Kuroi Riquid, Factorio Fan Song - Beautiful Disaster" then
    data.raw["ambient-sound"]["main-menu"].sound = "__CTDaddon_for_K2_SE__/prototypes/music/Factorio-Fan-Song-Beautiful-Disaster.ogg"
elseif music == "Kuroi Riquid, Factorio Fan Song - Inserter Dance" then
    data.raw["ambient-sound"]["main-menu"].sound = "__CTDaddon_for_K2_SE__/prototypes/music/Factorio-Fan-Song-Inserter-Dance.ogg"
elseif music == "QWC - The Factory must grow!" then
    data.raw["ambient-sound"]["main-menu"].sound = "__CTDaddon_for_K2_SE__/prototypes/music/QWC-_Factorio_-The-Factory-must-grow_-A-Factorio-Fan-Song.ogg"
elseif music == "All in one" then
    data.raw["ambient-sound"]["main-menu"].sound = "__CTDaddon_for_K2_SE__/prototypes/music/All-in-one.ogg"
elseif music == "Default" then
end
-- ##############################################################################################