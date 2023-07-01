Tracker:AddItems("items/items.json")
Tracker:AddItems("items/djinn.json")
Tracker:AddItems("items/progression.json")
Tracker:AddItems("items/settings.json")

ScriptHost:LoadScript("scripts/logic_common.lua")
ScriptHost:LoadScript("scripts/settings.lua")

Tracker:AddMaps("maps/maps.json")
Tracker:AddLocations("locations/locations.json")

Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/standard_broadcast.json")

if AUTOTRACKER_TRACK_ITEMS or AUTOTRACKER_TRACK_LOCATIONS then
    ScriptHost:LoadScript("scripts/autotracking_data.lua")
    ScriptHost:LoadScript("scripts/autotracking.lua")
end