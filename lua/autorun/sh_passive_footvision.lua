if SERVER then
	AddCSLuaFile("cl_passive_footvision.lua")
	resource.AddFile("materials/vgui/ttt/icon_footvision.vtf")
	resource.AddFile("materials/ttt/footprint.vtf")
else
	include("cl_passive_footvision.lua")
end

-- 2048 choosen to prevent any conflicts.
EQUIP_FOOTVISION = 2048

hook.Add("OnGamemodeLoaded", "Setup Passive FootVision", function()
	table.insert(EquipmentItems[ROLE_DETECTIVE], {
		id       = EQUIP_FOOTVISION,
		type     = "item_passive",
		material = "vgui/ttt/icon_footvision",
		name     = "Foot Vision",
		desc     = "Allows you see footprints."
	})
end)
