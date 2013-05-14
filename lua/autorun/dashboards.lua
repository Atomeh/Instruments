AddCSLuaFile()
CreateConVar("sbox_max_vehicle_instruments", 72, 
	{ FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, 
	"Maximum vehicle instruments a single player can create"
)

local DashboardTable = {}

local lada = {
	name 		= "VAZ-2103",
	category 	= "Dashboards",
	entity  	= "sent_dashboard",
	model 		= "models/instruments/dashboards/vaz2103.mdl",
	speedometer	= true,
	tachometer	= true,
	description = "Dashboard from Soviet VAZ-2103 also known as Lada 1500.\nMax. r/min - 7500\nMax. speed - 180 km/h",
	maxrpm 		= 7500,
	maxspeed	= 180}
DashboardTable["dash-vaz2103"] = lada

for key, value in pairs(DashboardTable) do
	list.Set("VehicleInstruments", key, value)
	/*
	MsgC(Color(30,225,65),
	"Adding ", key, " as ", value.entity, "\n")
	*/
end