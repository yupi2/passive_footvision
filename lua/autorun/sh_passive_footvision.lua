if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("cl_passive_footvision.lua")
	resource.AddFile("materials/vgui/ttt/icon_footvision.vtf")
	resource.AddFile("materials/ttt/footprint.vtf")
end

-- 2048 choosen to prevent any conflicts.
EQUIP_FOOTVISION = 2048

local mat_dir = "vgui/ttt/"

local function SetupPassiveFootVision()
	local tbl = EquipmentItems[ROLE_DETECTIVE]
	for k, v in pairs(tbl) do
		if istable(v) and v.id == EQUIP_FOOTVISION then
			table.RemoveByValue(EquipmentItems, v)
			break
		end
	end

	table.insert(EquipmentItems[ROLE_DETECTIVE], {
		id       = EQUIP_FOOTVISION,
		type     = "item_passive",
		material = mat_dir .. "icon_footvision",
		name     = "Foot Vision",
		desc     = "Allows you see footprints."
	})
	
	if CLIENT then
		include("cl_passive_footvision.lua")
	end
end
hook.Add("OnGamemodeLoaded", "SetupPassiveFootVision", SetupPassiveFootVision)

-- If doing a live refresh of the file.
----------asjdfkl jaskld jfklasdj flksomething here