TOOL.Category        	= "Construction"
TOOL.Name            	= "Vehicle instruments"
TOOL.Command			= nil
TOOL.ConfigName			= ""
TOOL.ClientConVar["id"]	= ""
TOOL.ClientConVar["scale"]	= 1

cleanup.Register("vehicle_instruments")

if CLIENT then
	local mode = TOOL:GetMode()
    language.Add("Tool." .. mode .. ".name", "Instruments")
    language.Add("Tool." .. mode .. ".desc", "Instrument clusters, gauges, gear sticks, levers and so on.")
    language.Add("Tool." .. mode .. ".0", "Left click to spawn stuff.")
       
    language.Add("Cleanup_vehicle_instruments", "Instruments")
    language.Add("Cleaned_vehicle_instruments", "No more vehicle instruments")
end


function TOOL:LeftClick(trace)
	if CLIENT then return true end
	
	if not trace.Hit then return end
	local owner 	= self:GetOwner()
	if not owner:CheckLimit("_vehicle_instruments") then return false end

	local spawnPos 	= trace.HitPos + trace.HitNormal * 4
	local spawnAng 	= trace.HitNormal:Angle():Up():Angle()
	local id 		= self:GetClientInfo("id")
	local scale 	= tonumber(self:GetClientInfo("scale"))
	local settings 	= list.Get("VehicleInstruments")
	local class 	= settings[id].entity
	local dupe  	= duplicator.FindEntityClass(class)
	local entity 	= dupe.Func(owner, spawnPos, spawnAng, id, scale)

	return true
end


local function UpdateParams(preview, description, id)
	local table 	= list.Get("VehicleInstruments")
	local item 		= table[id]
	local text 		= item.description
	local model 	= item.model

	preview:SetModel(model)
	local entity 	= preview:GetEntity()
	local min, max 	= entity:GetRenderBounds()
	local camera 	= min:Distance(max) * Vector(1.2,1.2,1.2)
	preview:SetCamPos(camera)

	description:SetText(text)
	description:SizeToContents()	//This is called twice because of SetAutoStretchVertical, I know.

	RunConsoleCommand("vehiculeinstruments_id", id)
end



function TOOL.BuildCPanel(ControlPanel)
	//Create item tree
	local menu = vgui.Create("DTree")
 	menu:SetSize(256, 256)

 	//Preview
	local icon = vgui.Create("DModelPanel", ControlPanel)
    icon:SetSize(200,200)
    icon:SetCamPos(Vector(-20,-30,30))
    icon:SetLookAt(Vector(0, 0, 0))
    icon:SetFOV(40)	

    //Text description
    local description = vgui.Create("DLabel", ControlPanel)
    description:SetColor(Color(40,40,40))
    description:SetWrap(true)
    description:SetAutoStretchVertical(true)
    
 	//Populate item tree with stuff from tables
 	local instruments 	= list.Get("VehicleInstruments")
 	local subcats 		= {}

 	for id, settings in pairs(instruments) do
 		if not subcats[settings.category] then
 			folder = menu:AddNode(settings.category)
 			subcats[settings.category] = folder	
 		else
 			folder = subcats[settings.category]
 		end

 		local item = folder:AddNode(settings.name)
 			item.Icon:SetImage("gui/silkicons/newspaper")
 			item.DoClick = function()
 				UpdateParams(icon, description, id)
 			end
 	end


 	//Scale slider
 	local slider = vgui.Create("DNumSlider")
 	//slider:SetPos( t.x, t.y )
	//slider:SetWide( t.w or 100 )
	slider:SetTall(20)
	slider:SetText("Scale")
	slider:SetMinMax(0,2)
	slider:SetDecimals(2)
	slider:SetValue(1)
	slider:SetConVar("vehiculeinstruments_scale")
	slider.TextArea:SetDrawBackground(true)
	slider.Label:SetTextColor(SKIN.text_dark)
	slider.Label:SizeToContents()
 	slider:SizeToContents()

 	//Add all controls to panel
	ControlPanel:AddItem(menu)
    ControlPanel:AddItem(icon)
    ControlPanel:AddItem(slider)
    ControlPanel:AddItem(description)

 	//Setup default params, this should only be called once.
 	UpdateParams(icon, description, table.GetFirstKey(instruments))
end