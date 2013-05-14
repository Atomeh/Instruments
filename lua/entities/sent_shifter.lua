AddCSLuaFile()
ENT.PrintName				= "Shifter Base"
ENT.Author					= "Atomeh"
ENT.Category				= "Vehicle instruments"
ENT.Base 					= "base_gmodentity"  
ENT.Editable				= false
ENT.Spawnable				= false
ENT.AdminOnly				= false
ENT.RenderGroup 			= RENDERGROUP_OPAQUE
ENT.AutomaticFrameAdvance 	= true


if CLIENT then
	language.Add("Undone_Shifter", "Removed shifter")
end


function ENT:Initialize()
	if not SERVER then return end
	self.Inputs = Wire_CreateInputs(self, {"Gear"})
	self.WireDebugName = "Gear shifter"
end


function MakeShifter(Player, Pos, Ang, id, scale)
	if not Player:CheckLimit("_vehicle_instruments") then return false end

	local Shifter 	= ents.Create("sent_shifter")
	local Settings  = list.Get("VehicleInstruments")[id]
	if not Shifter:IsValid() then return false end
	
	//A shitload of shit that'll probably never be shitted. Again.
	if not util.IsValidModel(Settings.model) then
		//function is defined in autorun/achtung.lua
		VehicleInstrumentMissingModel(Player, "Shifter", Settings.model, Settings.name, id)
		return false
	end

	Shifter:SetAngles(Ang)
	Shifter:SetPos(Pos)
	Shifter:Spawn()
	Shifter:Activate()
	Shifter:SetPlayer(Player)

	Shifter.id 			= id
	Shifter.scale 		= scale
	Shifter.Model 		= Model(Settings["model"])
	Shifter.Owner 		= Player

	Shifter:SetModel(Shifter.Model)
	Shifter:PhysicsInit(SOLID_VPHYSICS)      	
	Shifter:SetMoveType(MOVETYPE_VPHYSICS)     	
	Shifter:SetSolid(SOLID_VPHYSICS)

	Shifter:SetModelScale(Shifter.scale, 0)
	Shifter:SetPos(Pos + Vector(0,0,scale*2.2))

	local physics = Shifter:GetPhysicsObject()
	if physics:IsValid() then
		physics:EnableMotion(false)					//This entity most likely will be parented, better freeze it.
	end

	undo.Create("Shifter")
		undo.AddEntity(Shifter)
		undo.SetPlayer(Player)
	undo.Finish()

	Player:AddCount("_vehicle_instruments", Shifter)
	Player:AddCleanup("vehicle_instruments", Shifter)

	return Shifter
end
duplicator.RegisterEntityClass("sent_shifter", MakeShifter, "Pos", "Ang", "id")


function ENT:Think()
	if not SERVER then return end
	self:SetPoseParameter("gear", self.Inputs.Gear.Value)
	self:NextThink(CurTime() + 0.2)
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