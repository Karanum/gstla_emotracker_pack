Tracker:AddItems("items/items.json")
Tracker:AddItems("items/djinn.json")
Tracker:AddItems("items/progression.json")
Tracker:AddItems("items/settings.json")
Tracker:AddItems("items/characters.json")

ScriptHost:LoadScript("scripts/logic_common.lua")
ScriptHost:LoadScript("scripts/settings.lua")

Tracker:AddMaps("maps/maps.json")
Tracker:AddLocations("locations/locations.json")

Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tracker.json")

--[[===================================================================
	Below are variants for the broadcast layout.
	To use a different one, create an override of this file 
		(Advanced -> Export Overrides -> init.lua)
	and change which of the lines below has no double-dash in front.
--===================================================================]]

Tracker:AddLayouts("layouts/standard_broadcast.json")
--Tracker:AddLayouts("layouts/vertical_broadcast.json")
--Tracker:AddLayouts("layouts/horizontal_broadcast.json")
--Tracker:AddLayouts("layouts/very_horizontal_broadcast.json")

if AUTOTRACKER_TRACK_ITEMS or AUTOTRACKER_TRACK_LOCATIONS then
    ScriptHost:LoadScript("scripts/autotracking_data.lua")
    ScriptHost:LoadScript("scripts/autotracking.lua")
end