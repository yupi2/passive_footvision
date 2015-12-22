local LocalPlayer = LocalPlayer

local footprints_max      = 20
local footprints_interval = 1.5

local ttt_enable_footvision = CreateClientConVar("ttt_enable_footvision", "1", true, true)

local toggleDisguise = concommand.GetTable()["ttt_toggle_disguise"]
concommand.GetTable()["ttt_toggle_disguise"] = function(plr)
	if plr:IsDetective() then
		RunConsoleCommand("ttt_enable_footvision", ttt_enable_footvision:GetBool() and "0" or "1")
	else
		toggleDisguise(plr)
	end
end


hook.Add("TTTSettingsTabs", "Footvision thing", function(dtabs)
	local dsettings = dtabs.Items[2].Panel
	local dgui = vgui.Create("DForm", dsettings)
	dgui:SetName("Draw Foot-vision when bought.")

	if tttCustomSettings then
		dgui:TTTCustomUI_FormatForm()
	end

	dgui:CheckBox("Enable Drawing", "ttt_enable_footvision")
	dsettings:AddItem(dgui)

	if tttCustomSettings then
		for k, v in pairs(dgui.Items) do
			for i, j in pairs(v:GetChildren()) do
				j.Label:TTTCustomUI_FormatLabel()
			end
		end
	end
end)

local footprints = {}
for i = 1, footprints_max do
	table.insert(footprints, {})
end

local footprintTexturedQuad = {
	texture = surface.GetTextureID("ttt/footprint"),
	color   = Color(255, 255, 255),
	x = -10,
	y = -10,
	w =  20,
	h =  20	
}

local colour_modification = {
	["$pp_colour_addr"]       = 0,
	["$pp_colour_addr"]       = 0,
	["$pp_colour_addb"]       = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"]   = 1,
	["$pp_colour_colour"]     = 0.1,
	["$pp_colour_mulr"]       = 0,
	["$pp_colour_mulg"]       = 0,
	["$pp_colour_mulb"]       = 0,
}

local function drawFootprint(footprint)
	cam.Start3D2D(footprint.pos + upvec, Angle(0, (footprint.ang - 90), 0), 1)
		render.SuppressEngineLighting(true)
		render.SetColorModulation(1, 0, 0)
		footprintTexturedQuad.color = Color(255, 0, 0, k * (250 / footprints_max))
		draw.TexturedQuad(footprintTexturedQuad)
		render.SuppressEngineLighting(false)
		render.SetColorModulation(1, 1, 1)
	cam.End3D2D()
end

hook.Add("PostDrawOpaqueRenderables", "Render Footvision footprints", function()
	local lp = LocalPlayer()
	if not lp:IsActive() then return end

	if lp:HasEquipmentItem(EQUIP_FOOTVISION) and ttt_enable_footvision:GetBool() then	
		local upvec = Vector(0, 0, 2)

		-- Set the screen to black and white.
		DrawColorModify(colour_modification)
			
		for k, frame in ipairs(footprints) do
			for i, footprint in ipairs(frame) do
				drawFootprint(footprint)
			end
		end
	end
end)

if timer.Exists("FootprintTimer") then
	timer.Remove("FootprintTimer")
end

-- Place all player positions into a table.
timer.Create("FootprintTimer", 1, 0, function()
	local currentFrame = {}
	for k, plr in ipairs(player.GetAll()) do
		if plr:IsActive() and (IsValid(plr:GetGroundEntity()) or plr:GetGroundEntity():IsWorld()) then
			table.insert(currentFrame, {
				pos = plr:GetPos(),
				ang = plr:GetAngles().y
			})
		end
	end

	table.insert(footprints, currentFrame)
	if #footprints >= footprints_max then
		table.remove(footprints, 1)
	end
end)