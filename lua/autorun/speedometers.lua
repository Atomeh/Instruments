AddCSLuaFile()
//sbox_max convar is defined in dashboards.lua
local SpeedometerTable = {}

local vaz = {
	name 		= "VAZ-2103",
	category 	= "Speedometers",
	entity  	= "sent_dashboard",
	speedometer	= true,
	tachometer	= false,
	model 		= "models/instruments/gauges/speedo_vaz2103.mdl",
	description = "Has two skins: simple and self-illuminated.\nMax. speed - 180 km/h",
	maxspeed	= 180}
SpeedometerTable["speedo-vaz2103"] = vaz

local URAL = {
	name 		= "URAL",
	category 	= "Speedometers",
	entity  	= "sent_dashboard",
	speedometer	= true,
	tachometer	= false,
	model 		= "models/instruments/gauges/speedo_ural.mdl",
	description = "Has two skins: simple and self-illuminated.\nMax. speed - 120 km/h",
	maxspeed	= 120}
SpeedometerTable["speedo-ural"] = URAL


for key, value in pairs(SpeedometerTable) do
	list.Set("VehicleInstruments", key, value)
	/*
	MsgC(Color(30,225,65),
	"Adding ", key, " as ", value.entity, "\n")
	*/
end