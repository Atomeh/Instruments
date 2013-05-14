AddCSLuaFile()
//sbox_max convar is defined in dashboards.lua
local TachometerTable = {}

local ural = {
	name 		= "URAL",
	category 	= "Tachometers",
	entity  	= "sent_dashboard",
	speedometer	= false,
	tachometer	= true,
	model 		= "models/instruments/gauges/tacho_ural.mdl",
	description = "Has two skins: simple and self-illuminated.\nMax. r/min - 4000",
	maxrpm		= 4000}
TachometerTable["tacho-ural"] = ural


for key, value in pairs(TachometerTable) do
	list.Set("VehicleInstruments", key, value)
end