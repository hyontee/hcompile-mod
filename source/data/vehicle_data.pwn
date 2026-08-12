// link https://github.com/tdworg/samp-include-vehicle

enum E_TDW_MATH_VEHICLE_SPEED_TYPE
{
	EI_MATH_SPEED_KMPH, // kilometers per hour
	EI_MATH_SPEED_MPH // miles per hour
};
#if !defined FLOAT_INFINITY
	#define FLOAT_INFINITY					(Float:0x7F800000)
#endif
#if !defined SPEEDOMETR_TIMER_UPDATE
	#define SPEEDOMETR_TIMER_UPDATE			(950)
#else
	#assert (0 < SPEEDOMETR_TIMER_UPDATE)
#endif
#if !defined TDW_VEHICLE_FUEL_FLOAT
	#define TDW_VEHICLE_FUEL_FLOAT (10000.0)//20000
#endif
#define TDW_VEHICLE_MILEAGE_MILE_FLOAT			(1.609343)


static const Float:TDW_g_sModelMaxFuel[212] =
{
	 70.0,  45.0, 40.0, 298.0,  40.0,  40.0, 200.0, 80.0, 60.0,  40.0,  40.0,
	 40.0,  40.0, 45.0,  45.0,  40.0,  70.0, 100.0, 45.0, 40.0,  40.0,  40.0,
	 45.0,  45.0, 20.0, 200.0,  40.0,  70.0,  70.0, 40.0, 45.0,  60.0,  90.0,
	100.0,  35.0,  0.0,  40.0,  50.0,  40.0,  40.0, 45.0,  5.0,  40.0,  50.0,
	 65.0,  40.0, 35.0,  90.0,  20.0,  60.0,   0.0, 40.0, 20.0,  20.0,  20.0,
	 60.0,  50.0, 20.0,  40.0,  45.0,  90.0,  30.0, 20.0, 35.0,   5.0,   5.0,
	 40.0,  40.0, 20.0,  90.0,  90.0,  20.0,  20.0, 20.0, 40.0,  40.0,  40.0,
	 40.0,  40.0, 45.0,  40.0,   0.0,  45.0,  45.0, 20.0, 20.0,  30.0,  90.0,
	 90.0,  70.0, 70.0,  40.0,  40.0,  20.0,  40.0, 45.0, 40.0,  90.0,  50.0,
	 50.0,  40.0,  5.0,  40.0,  40.0,  40.0,  50.0, 40.0, 40.0,  50.0,   0.0,
	  0.0,  90.0, 90.0,  90.0, 298.0, 298.0,  40.0, 40.0, 40.0, 400.0, 400.0,
	 30.0,  30.0, 30.0,  50.0,  50.0,  40.0,  40.0, 50.0, 40.0,  20.0,  20.0,
	 60.0,  40.0, 40.0,  40.0,  40.0,  50.0,  50.0, 20.0, 40.0,  40.0,  40.0,
	 50.0,  70.0, 40.0,  40.0,  40.0,  90.0,  40.0, 40.0, 40.0,  40.0, 300.0,
	 50.0,  40.0, 80.0,  80.0,  40.0,  40.0,  40.0, 40.0, 40.0,  90.0,  90.0,
	 40.0,  45.0, 45.0,  20.0,   0.0,  50.0,  10.0, 20.0, 50.0,  20.0,  40.0,
	 40.0, 300.0, 50.0,  50.0,  40.0,  30.0,  50.0, 20.0,  0.0,  40.0,  30.0,
	 40.0,  50.0, 40.0,   0.0,   0.0, 300.0, 200.0,  0.0, 20.0,  40.0,  40.0,
	 40.0,  50.0, 40.0,  60.0,  40.0,  40.0,  40.0, 45.0,  0.0,   0.0,   0.0,
	 50.0,   0.0,  0.0
};
 //new MaxSpeedCar[212] = {
	//111, 103, 131, 77, 93, 115, 77, 104, 70, 111, 91, 155, 118, 77, 74,135,108,80,81,105,102,108,98,69,95,135,122,116,110,141,128,91,66,77,117,0,105,111,100,118,95,53,98,89,77,115,162,80,77,0,0,136,118,44,91,110,74,67,110,95,92,113,78,100,0,0,103,98,100,78,110,77,88,75,105,121,141,131,82,98,129,68,110,86,46,70,45,116,104,98,110,105,99,125,151,124,114,114,76,86,98,0,151,151,121,98,126,116,76,73,91,87,90,111,84,100,110,110,115,190,189,112,123,106,91,113,111,105,124,105,42,49,77,117,118,111,121,0,0,70,105,142,115,106,104,103,105,100,86,108,102,110,85,95,101,111,77,77,110,125,119,108,125,85,0,116,112,121,102,0,0,65,42,77,42,111,111,190,91,111,107,106,95,60,0,107,100,116,76,114,0,0,190,100,0,77,123,123,123,111,106,77,119,120,103,106,0,0,0,76,0,0};
static stock const
	TDW_g_sVehicleSpeed[212] =
{
	160, 160, 200, 120, 150, 165, 110, 170, 110, 180, 160, 240, 160, 160, 140,
	230, 155, 200, 150, 160, 180, 180, 165, 145, 170, 200, 200, 170, 170, 200,
	190, 130,  80, 180, 200, 120, 160, 160, 160, 160, 160,  75, 150, 150, 110,
	165, 280, 200, 190, 150, 120, 240, 190, 190, 190, 140, 160, 160, 165, 160,
	200, 190, 190, 190,  75,  75, 160, 160, 190, 200, 170, 160, 190, 190, 160,
	160, 200, 200, 150, 165, 200, 120, 150, 120, 190, 160, 100, 200, 200, 170,
	170, 160, 160, 190, 220, 170, 200, 200, 140, 140, 160,  75, 220, 220, 160,
	170, 230, 165, 140, 120, 140, 200, 200, 200, 120, 120, 165, 165, 160, 330,
	330, 190, 190, 190, 110, 160, 160, 160, 170, 160,  60,  70, 140, 200, 160,
	160, 160, 110, 110, 150, 160, 230, 160, 165, 170, 160, 160, 160, 200, 160,
	160, 165, 160, 200, 170, 180, 110, 110, 200, 200, 200, 200, 200, 200,  75,
	200, 160, 160, 170, 110, 110,  90,  60, 110,  60, 160, 160, 200, 110, 160,
	165, 190, 160, 170, 120, 165, 190, 200, 140, 200, 110, 120, 200, 200,  60,
	190, 200, 200, 200, 160, 165, 110, 200, 200, 160, 165, 160, 160, 160, 140,
	160, 160
};
new VehicleNames[212][] =
{
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perenniel",
	"Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch",
	"Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah",
	"Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi",
	"Creative", "Bobcat", "Mr Whoopee", "BF Injection", "Hunter",
	"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Article Trailer", "Previon",
	"Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero",
	"Packer", "Monster", "Admiral", "Squallo", "Seasparrow", "Pizzaboy",
	"Tram", "Article Trailer 2", "Turismo", "Speeder", "Reefer",
	"Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
	"Topfun Van (Berkley's RC)", "Skimmer", "PCJ-600", "Faggio",
	"Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez",
	"Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes",
	"Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
	"Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick",
	"SAN News Maverick", "Rancher", "FBI Rancher", "Virgo", "Greenwood",
	"Jetmax", "Hotring Racer", "Sandking", "Blista Compact",
	"Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin",
	"Hotring Racer", "Hotring Racer", "Bloodring Banger", "Rancher",
	"Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle",
	"Cropduster", "Stuntplane", "Tanker", "Roadtrain", "Nebula",
	"Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500",
	"HPV1000", "Cement Truck", "Towtruck", "Fortune", "Cadrona",
	"FBI Truck", "Willard", "Forklift", "Tractor", "Combine Harvester",
	"Feltzer", "Remington", "Slamvan", "Blade", "Freight (Train)",
	"Brownstreak (Train)", "Vortex", "Vincent", "Bullet", "Clover",
	"Sadler", "Firetruck LA", "Hustler", "Intruder", "Primo", "Cargobob",
	"Tampa", "Sunrise", "Merit", "Utility Van", "Nevada", "Yosemite",
	"Windsor", "Monster \"A\"", "Monster \"B\"", "Uranus", "Jester",
	"Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash",
	"Tahoma", "Savanna", "Bandito", "Freight Flat Trailer (Train)",
	"Streak Trailer (Train)", "Kart", "Mower", "Dune", "Sweeper",
	"Broadway", "Tornado", "AT400", "DFT-30", "Huntley", "Stafford",
	"BF-400", "Newsvan", "Tug", "Petrol Trailer", "Emperor", "Wayfarer",
	"Euros", "Hotdog", "Club", "Freight Box Trailer (Train)",
	"Article Trailer 3", "Andromada", "Dodo", "RC Cam", "Launch",
	"Police Car (LSPD)", "Police Car (SFPD)", "Police Car (LVPD)",
	"Police Ranger", "Picador", "S.W.A.T.", "Alpha", "Phoenix",
	"Glendale Shit", "Sadler Shit", "Baggage Trailer \"A\"",
	"Baggage Trailer \"B\"", "Tug Stairs Trailer", "Boxville",
	"Farm Trailer", "Utility Trailer"
};
stock Float:GetModelMaxFuel(modelid)
{
	//if (0 == IS_VALID_MODEL(modelid))
	//	return 0.0;

	return TDW_g_sModelMaxFuel[modelid - 400];
}
stock GetModelStaticSpeed(modelid)
{
	/*if (0 == IS_VALID_MODEL(modelid))
		return -1;*/
	return TDW_g_sVehicleSpeed[modelid - 400];
} 
stock Float:GetVehicleSpeedFromVelocity(Float:x, Float:y, Float:z,
	E_TDW_MATH_VEHICLE_SPEED_TYPE:type = EI_MATH_SPEED_MPH)
{
	return floatmul(VectorSize(x, y, z), (type == EI_MATH_SPEED_KMPH
		? 180.0
		: 111.846814));
}

stock Float:GetVehicleSpeed(vehicleid,
	E_TDW_MATH_VEHICLE_SPEED_TYPE:type = EI_MATH_SPEED_MPH)
{
	static
		Float:x,
		Float:y,
		Float:z;

	return GetVehicleVelocity(vehicleid, x, y, z)
		? GetVehicleSpeedFromVelocity(x, y, z, type)
		: FLOAT_INFINITY;
} 
/*tock SetVehicleSpeed(vehicleid, Float:speed)
{
    new Float:_v_velocity[4];
    GetVehicleZAngle(vehicleid, _v_velocity[0] ) ;
    GetVehicleVelocity(vehicleid, _v_velocity[1], _v_velocity[2], _v_velocity[3] ) ;
    SetVehicleVelocity(vehicleid, floatsin(-_v_velocity[0],degrees)*(speed/99), floatcos(-_v_velocity[0],degrees)*(speed/99), _v_velocity[3] ) ;
    return true;
}*/
stock SetVehicleSpeed(vehicleid, Float:speed) {
    if(speed <= 0) return true;
    new Float: speed_X, Float: speed_Y, Float: speed_Z;
    GetVehicleVelocity(vehicleid, speed_X, speed_Y, speed_Z);
  
    new Float:test = floatsqroot(floatadd(floatadd(floatpower(speed_X, 2), floatpower(speed_Y, 2)),  floatpower(speed_Z, 2))) * 100.3;
    new Float:dif =  speed / test;
        
    if(dif != 0 && test != 0) SetVehicleVelocity(vehicleid, speed_X*dif, speed_Y*dif, speed_Z);
    return true;
}
/*stock SetVehicleSpeed(vehicleid, Float:speed,
	E_TDW_MATH_VEHICLE_SPEED_TYPE:type = EI_MATH_SPEED_KMPH)
{
	new
		Float:x,
		Float:y,
		Float:z;

	if (GetVehicleVelocity(vehicleid, x, y, z))
	{
		new
			Float:angle;

		GetVehicleVelocity(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, angle);

		switch (type)
		{
			case EI_MATH_SPEED_KMPH:
				speed = floatdiv(speed, 180.0);
			case EI_MATH_SPEED_MPH:
				speed = floatdiv(speed, 111.846814);
		}

		x = floatmul(speed, floatsin(-angle, degrees));
		y = floatmul(speed, floatcos(-angle, degrees));

		SetVehicleVelocity(vehicleid, x, y, z);
	}
	return 0;
}*/
stock SurfingVehicle(playerid){
	if (pTemp[playerid][PlayerADostup]) return true;
    new 
        vehicleid = GetPlayerSurfingVehicleID(playerid);
    if (vehicleid != INVALID_VEHICLE_ID){
        new
			Float: veh_speed = GetVehicleSpeed(vehicleid),
			veh_model = GetVehicleModel(vehicleid);
        switch(veh_model){
            case 422, 430, 446, 452 .. 453, 454, 472 .. 473, 478, 484, 493, 595, 600:
				return true;
		}
        if (veh_speed > 10){
            new
				Float:p_X,
			 	Float:p_Y,
				Float:p_Z;
            GetPlayerPos(playerid, p_X, p_Y, p_Z);
            SetPlayerPosAC(playerid, p_X+2.5, p_Y+2.5, p_Z-0.5);
        }
    }
    return true;
}
stock SetVehicleMileage(vehicleid, Float:mileage) {
	if (IsValidVehicle(vehicleid))
		VehicleInfo[ vehicleid - 1 ][vMillage] = mileage;

	return 0;
}
stock GetVehicleMileage(vehicleid) {
	return
		IsValidVehicle(vehicleid)
		? floatround(VehicleInfo[ vehicleid - 1 ][vMillage])
		: INVALID_VEHICLE_ID;
}


/*enum E_TDW_NEON_COLOR
{
	// objects
	NEON_COLOR_RED = 18647,
	NEON_COLOR_BLUE,
	NEON_COLOR_GREEN,
	NEON_COLOR_YELLOW,
	NEON_COLOR_PINK,
	NEON_COLOR_WHITE
};

enum E_TDW_NEON_OBJECTS
{
	EI_NEON_LEFT_ID,
	EI_NEON_RIGHT_ID
};

new
	TDW_g_sNeon[MAX_VEHICLES][E_TDW_NEON_OBJECTS],
	bool:TDW_g_sIsNeonAttached[MAX_VEHICLES char];

stock AddNeonToVehicle(vehicleid, E_TDW_NEON_COLOR:color)
{
	new
		vehicle_model;

	if ((vehicle_model = GetVehicleModel(vehicleid)) == 0)
		return 0;
	new
		Float:size_x,
		Float:size_y,
		Float:size_z;

	GetVehicleModelInfo(vehicle_model, VEHICLE_MODEL_INFO_SIZE, size_x, size_y,
		size_z);

	new
		objectid;
	const Float:OFFSET_Z = -0.6;

	objectid = TDW_g_sNeon[vehicleid][EI_NEON_LEFT_ID] = CreateDynamicObject(E_TDW_NEON_COLOR:color,
		0.0, 0.0, 0.0, // Positions
		0.0, 0.0, 0.0, // Rotations
		0.0 // Draw distance
	); 
	AttachDynamicObjectToVehicle(objectid, vehicleid,
		-size_x / 2.8, 0.0, OFFSET_Z, // Positions
		0.0, 0.0, 0.0 // Rotations
	);
	objectid = TDW_g_sNeon[vehicleid][EI_NEON_RIGHT_ID] = CreateDynamicObject(E_TDW_NEON_COLOR:color,
		0.0, 0.0, 0.0, // Positions
		0.0, 0.0, 0.0, // Rotations
		0.0 // Draw distance
	);
	AttachDynamicObjectToVehicle(objectid, vehicleid,
		size_x / 2.8, 0.0, OFFSET_Z, // Positions
		0.0, 0.0, 0.0 // Rotations
	);

	TDW_g_sIsNeonAttached{vehicleid} = true;

	return 1;
}

stock RemoveNeonFromVehicle(vehicleid)
{
	if (IsValidVehicle(vehicleid) == 0)
		return 0;
	if (_:TDW_g_sIsNeonAttached{vehicleid} == 0) {
		DestroyDynamicObject(TDW_g_sNeon[vehicleid][EI_NEON_LEFT_ID]);
		DestroyDynamicObject(TDW_g_sNeon[vehicleid][EI_NEON_RIGHT_ID]);
		TDW_g_sIsNeonAttached{vehicleid} = false;
	}
	return 1;
}
CMD:addneon(playerid) {
	new	
		V_IDX = GetPlayerVehicleID(playerid);
	AddNeonToVehicle(V_IDX, NEON_COLOR_RED);
	return 1;
}*/