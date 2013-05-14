AddCSLuaFile()
//sbox_max convar is defined in dashboards.lua
local ShifterTable = {}

local test = {
	name 		= "The Incredible Shifter",
	category 	= "Shifters",
	entity  	= "sent_shifter",
	model 		= "models/instruments/shifters/manual_test.mdl",
	description = "Manual transmission.\n7 positions.\nInput: from 0 to 6\n\nIt has an enormously big texture and bends like a rubber penis."
	}
ShifterTable["shift-auto-test"] = test

local test = {
	name 		= "The Incredible Shifter Returns",
	category 	= "Shifters",
	entity  	= "sent_shifter",
	model 		= "models/instruments/shifters/automatic_test.mdl",
	description = "Automatic transmission.\n4 positions(Park-Reverse-Neutral-Drive)\nInput: from 0 to 3\n\nThis one also has an enormously huge extra large 16385KB texture and an ERGONOMIC HANDLE."
	}
ShifterTable["shift-manual-test"] = test


for key, value in pairs(ShifterTable) do
	list.Set("VehicleInstruments", key, value)
	/*
	MsgC(Color(30,225,65),
	"Adding ", key, " as ", value.entity, "\n")
	*/
end