if SERVER then
	AddCSLuaFile("cl_passive_footvision.lua")
	resource.AddFile("materials/vgui/ttt/icon_footvision.vtf")
	resource.AddFile("materials/ttt/footprint.vtf")
end

-- 2048 choosen to prevent any conflicts.
EQUIP_FOOTVISION = 2048

hook.Add("Initialize", "Setup Passive FootVision", function()
	local detectiveItems = EquipmentItems[ROLE_DETECTIVE]
	for k, v in pairs(detectiveItems) do
		if istable(v) and v.id == EQUIP_FOOTVISION then
			table.RemoveByValue(detectiveItems, v)
			break
		end
	end

	table.insert(detectiveItems, {
		id       = EQUIP_FOOTVISION,
		type     = "item_passive",
		material = "vgui/ttt/icon_footvision",
		name     = "Foot Vision",
		desc     = "Allows you see footprints."
	})
	
	if CLIENT then
		include("cl_passive_footvision.lua")
	end
end)
