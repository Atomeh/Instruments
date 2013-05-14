AddCSLuaFile()
ENT.PrintName				= "Instrument Cluster Base"
ENT.Author					= "Atomeh"
ENT.Category				= "Vehicle instruments"
ENT.Base 					= "base_gmodentity"  
ENT.Editable				= false
ENT.Spawnable				= false
ENT.AdminOnly				= false
ENT.RenderGroup 			= RENDERGROUP_OPAQUE
ENT.AutomaticFrameAdvance 	= true


if CLIENT then
	language.Add("Undone_Dashboard", "Removed dashboard")
end



function ENT:Initialize()
	if not SERVER then return end
	self.Inputs = Wire_CreateInputs(self, {"Speed", "RPM", "Active"})
	self.WireDebugName = "Dashboard"
end



function ENT:Setup(speedometer, tachometer)
	if speedometer and not tachometer then
		Wire_AdjustInputs(self, {"Speed"})
		self.WireDebugName = "Speedometer"
	elseif not speedometer and tachometer then
		Wire_AdjustInputs(self, {"RPM", "Active"})
		self.WireDebugName = "Tachometer"
	elseif speedometer and tachometer then
		Wire_AdjustInputs(self, {"Speed", "RPM", "Active"})
		self.WireDebugName = "Dashboard"
	end
end



function ENT:Think()
	if not SERVER then return end

	if self.Inputs.Active then self.Active = self.Inputs.Active.Value
	else self.Active = 1 end

	if self.Active != 0 then
		local magic 	= 0.06858			//Snort-snort. Actually this is [36 * 0.00254 * 0.75], but shorter.
		//normal = (value - minimum)/maximum-minimum

		//Speed
		if self.HasSpeedo then
			local speedLink	= self.Inputs.Speed.Src
			local wireSpeed	= self.Inputs.Speed.Value

			if speedLink == nil or speedLink == NULL then
				if self:GetParent():IsValid() then
					self.Speed = self:GetParent():GetVelocity():Length()
				else
					self.Speed = self:GetVelocity():Length()
				end
			else 
				self.Speed = wireSpeed
			end
				self:SetPoseParameter("Speed", ((self.Speed*magic)/self.MaxSpeed)*100)
		end
		
		//RPM
		if self.HasTacho then
			local RPM 		= self.Inputs.RPM.Value
			self:SetPoseParameter("RPM", RPM/self.MaxRPM*100)
		end
		self:NextThink(CurTime() + 0.1)
	else
		//Looks like this doesn't have any visible improvements in bandwidth usage, but I want this to be here.
		if self:GetPoseParameter("RPM") > 0.5 and self.HasTacho then self:SetPoseParameter("RPM", 0) end  												
		if self:GetPoseParameter("Speed") > 0.5 and self.HasSpeedo then self:SetPoseParameter("Speed", 0) end
		self:NextThink(CurTime() + 0.75)
	end

	return true
end



//Duplicating wire inputs
function ENT:BuildDupeInfo()
	return WireLib.BuildDupeInfo(self)
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	WireLib.ApplyDupeInfo( ply, ent, info, GetEntByID )
end

function ENT:PreEntityCopy()
	local DupeInfo = self:BuildDupeInfo()
	if DupeInfo then
		duplicator.StoreEntityModifier(self,"WireDupeInfo",DupeInfo)
	end
end

function ENT:PostEntityPaste(Player,Ent,CreatedEntities)
	if Ent.EntityMods and Ent.EntityMods.WireDupeInfo then
		Ent:ApplyDupeInfo(Player, Ent, Ent.EntityMods.WireDupeInfo, function(id) return CreatedEntities[id] end)
	end
end



function MakeDashboard(Player, Pos, Ang, id, scale)
	if not Player:CheckLimit("_vehicle_instruments") then return false end

	local Dashboard 	= ents.Create("sent_dashboard")
	local Settings  	= list.Get("VehicleInstruments")[id]
	if not Dashboard:IsValid() then return false end
	
	//A shitload of shit that'll probably never be shitted.
	if not util.IsValidModel(Settings.model) then
		//function is defined in autorun/achtung.lua
		VehicleInstrumentMissingModel(Player, "Dashboard", Settings.model, Settings.name, id)
		return false
	end

	Dashboard:SetAngles(Ang)
	Dashboard:SetPos(Pos)
	Dashboard:Spawn()
	Dashboard:Activate()
	Dashboard:SetPlayer(Player)

	Dashboard.id 		= id
	Dashboard.scale 	= scale
	Dashboard.Model 	= Model(Settings["model"])
	Dashboard.MaxRPM   	= Settings["maxrpm"]
	Dashboard.MaxSpeed 	= Settings["maxspeed"]
	Dashboard.HasSpeedo	= Settings["speedometer"]
	Dashboard.HasTacho 	= Settings["tachometer"]
	Dashboard.Owner 	= Player
	Dashboard.Speed 	= Player
	Dashboard.Active 	= 0

	Dashboard:SetModel(Dashboard.Model)
	Dashboard:PhysicsInit(SOLID_VPHYSICS)      	
	Dashboard:SetMoveType(MOVETYPE_VPHYSICS)     	
	Dashboard:SetSolid(SOLID_VPHYSICS)
	Dashboard:Setup(Dashboard.HasSpeedo, Dashboard.HasTacho)
	
	Dashboard:SetModelScale(Dashboard.scale, 0)
	//Dashboard:SetPos(Pos + Vector(0,0,scale*2.2))

	local physics = Dashboard:GetPhysicsObject()
	if physics:IsValid() then
		physics:EnableMotion(false)					//This entity most likely will be parented, better freeze it.
	end

	undo.Create("Dashboard")
		undo.AddEntity(Dashboard)
		undo.SetPlayer(Player)
	undo.Finish()

	Player:AddCount("_vehicle_instruments", Dashboard)
	Player:AddCleanup("vehicle_instruments", Dashboard)

	return Dashboard
end
duplicator.RegisterEntityClass("sent_dashboard", MakeDashboard, "Pos", "Ang", "id", "scale")
