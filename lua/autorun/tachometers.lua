AddCSLuaFile()
//sbox_max convar is defined in dashboards.lua
local TachometerTable = {}

local ural = {
	name 		= "VAZ-2103",
	category 	= "Tachometers",
	entity  	= "sent_dashboard",
	speedometer	= false,
	tachometer	= true,
	model 		= "models/instruments/gauges/tacho_vaz2103.mdl",
	description = "Has two skins: simple and self-illuminated.\n\nMax. r/min - 7500",
	maxrpm		= 7500}
TachometerTable["tacho-vaz2103"] = ural

local ural = {
	name 		= "URAL",
	category 	= "Tachometers",
	entity  	= "sent_dashboard",
	speedometer	= false,
	tachometer	= true,
	model 		= "models/instruments/gauges/tacho_ural.mdl",
	description = "Has two skins: simple and self-illuminated.\n\nMax. r/min - 4000",
	maxrpm		= 4000}
TachometerTable["tacho-ural"] = ural


for key, value in pairs(TachometerTable) do
	list.Set("VehicleInstruments", key, value)
end