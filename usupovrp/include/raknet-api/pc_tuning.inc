#define SetVehicleTuning(%0,%1,%2)			g_vehicle_tuning[%0][%1] = %2
#define GetVehicleTuning(%0,%1)				g_vehicle_tuning[%0][%1]

#define SetVehicleTuningTemp(%0,%1,%2)		g_vehicle_tuning_temp[%0][%1] = %2
#define GetVehicleTuningTemp(%0,%1)			g_vehicle_tuning_temp[%0][%1]

const NEON_PRICE = 499;
const LIGHTS_PRICE = 499;
const TINING_PRICE = 15_000_000;
const COLOR_PRICE = 3_000_000;

enum
{
	CAR_MODE_TYPE_NEON = 100,
	CAR_MODE_TYPE_LIGHTS,
	CAR_MODE_TYPE_TINING,
	CAR_MODE_TYPE_COLOR
}

new Text: td_sto[43];
new Text: sto_td_global[11];

new Text: tuning_menu_td[5];

new PlayerText: sto_td_player[MAX_PLAYERS][2];

enum E_VEHICLE_TUNING_STRUCT
{
	VT_MAIN_COLOR_R,
	VT_MAIN_COLOR_G,
	VT_MAIN_COLOR_B,
	VT_WHEELS_COLOR_R,
	VT_WHEELS_COLOR_G,
	VT_WHEELS_COLOR_B,
	VT_WHEELS_COLOR_A,
	VT_LIGHTS_COLOR_R,
	VT_LIGHTS_COLOR_G,
	VT_LIGHTS_COLOR_B,
	VT_TINING_TRANSPARENT,
	VT_TINING_COLOR_R,
	VT_TINING_COLOR_G,
	VT_TINING_COLOR_B,
	VT_TURN_LIGHTS_LEFT,
	VT_TURN_LIGHTS_RIGHT,
	VT_TURN_LIGHTS_TWOSIDE,
	VT_PAINTJOB,
	VT_NEON_COLOR_R,
	VT_NEON_COLOR_G,
	VT_NEON_COLOR_B,
	VT_NEON_ALPHA
}

new g_vehicle_tuning[MAX_VEHICLES][E_VEHICLE_TUNING_STRUCT];
new g_vehicle_tuning_temp[MAX_VEHICLES][E_VEHICLE_TUNING_STRUCT];

new g_tuning_select[MAX_PLAYERS];

const RPC_VehicleTining = 241;
const RPC_VehicleTurnLight = 242;
const RPC_VehicleWheelsSettings = 243;
const RPC_VehicleLights = 244;
const RPC_VehicleNeon = 245;
const RPC_VehicleColor = 246;

const RPC_RemoveSync = 247;

const RPC_ColorPeekerStatus = 248;
const RPC_ColorPeekerCallback = 249;
const RPC_ColorPeekerClose = 250;

stock ShowPlayerColorPeeker(playerid)
{
	new id = 0;
	
	new BitStream: bs = BS_New();
	
	BS_WriteValue
	(
		bs,
		PR_UINT8, id
	);
	
	PR_SendRPC(bs, playerid, RPC_ColorPeekerStatus);
	BS_Delete(bs);
}

ICustomRPC:RPC_ColorPeekerCallback(playerid, BitStream: bs)
{
    new r, g, b, alpha;
    new peeker_id;
	new vehicleid = GetPlayerVehicleID(playerid);
    
    BS_ReadUint8(bs, peeker_id);
    BS_ReadUint8(bs, r);
    BS_ReadUint8(bs, g);
    BS_ReadUint8(bs, b);
    BS_ReadUint8(bs, alpha);
	
	switch(g_tuning_select[playerid])
	{
		case 1:
		{
			EnableVehicleNeon(playerid, vehicleid, r, g, b, alpha);
			
			SetVehicleTuningTemp(vehicleid, VT_NEON_COLOR_R, r);
			SetVehicleTuningTemp(vehicleid, VT_NEON_COLOR_G, g);
			SetVehicleTuningTemp(vehicleid, VT_NEON_COLOR_B, b);
		}
		
		case 2:
		{
			EnableVehicleLights(playerid, vehicleid, r, g, b);
			
			SetVehicleTuningTemp(vehicleid, VT_LIGHTS_COLOR_R, r);
			SetVehicleTuningTemp(vehicleid, VT_LIGHTS_COLOR_G, g);
			SetVehicleTuningTemp(vehicleid, VT_LIGHTS_COLOR_B, b);
		}
		
		case 3:
		{
			EnableVehicleTining(playerid, vehicleid, 0, r, g, b, alpha);
			EnableVehicleTining(playerid, vehicleid, 1, r, g, b, alpha);
			EnableVehicleTining(playerid, vehicleid, 2, r, g, b, alpha);
			EnableVehicleTining(playerid, vehicleid, 3, r, g, b, alpha);
			EnableVehicleTining(playerid, vehicleid, 4, r, g, b, alpha);
			
			SetVehicleTuningTemp(vehicleid, VT_TINING_COLOR_R, r);
			SetVehicleTuningTemp(vehicleid, VT_TINING_COLOR_G, g);
			SetVehicleTuningTemp(vehicleid, VT_TINING_COLOR_B, b);
			SetVehicleTuningTemp(vehicleid, VT_TINING_TRANSPARENT, alpha);
		}
		
		case 4:
		{
			EnableVehicleColor(playerid, vehicleid, r, g, b);
			
			SetVehicleTuningTemp(vehicleid, VT_MAIN_COLOR_R, r);
			SetVehicleTuningTemp(vehicleid, VT_MAIN_COLOR_G, g);
			SetVehicleTuningTemp(vehicleid, VT_MAIN_COLOR_B, b);
		}
	}
}

ICustomRPC:RPC_ColorPeekerClose(playerid, BitStream: bs)
{
	new id = 0;
	
	BS_WriteValue
	(
		bs,
		PR_UINT8, id
	);
	
	PR_SendRPC(bs, playerid, RPC_ColorPeekerStatus);
	BS_Delete(bs);
	
	for(new i = 0; i != 11; i ++)
		TextDrawShowForPlayer(playerid, sto_td_global[i]);
	
	for(new i = 0; i != 2; i ++)
		PlayerTextDrawShow(playerid, sto_td_player[playerid][i]);
	
	for(new idx; idx < 43; idx ++)
		TextDrawShowForPlayer(playerid, td_sto[idx]);
	
	/*for(new i = 0; i != sizeof tuning_menu_td; i ++)
		TextDrawShowForPlayer(playerid, tuning_menu_td[i]);*/
	
	SelectTextDraw(playerid, -1);
	
	switch(g_tuning_select[playerid])
	{
		case 1:
		{
			ShowPlayerTuneDraw(playerid, CAR_MODE_TYPE_NEON);
		}
		
		case 2:
		{
			ShowPlayerTuneDraw(playerid, CAR_MODE_TYPE_LIGHTS);
		}
		
		case 3:
		{
			ShowPlayerTuneDraw(playerid, CAR_MODE_TYPE_TINING);
		}
		
		case 4:
		{
			ShowPlayerTuneDraw(playerid, CAR_MODE_TYPE_COLOR);
		}
	}
}

stock ChangeVehicleWheels(playerid, vehicleid, front_wheels_collapse, back_wheels_collapse, front_wheels_width, back_wheels_width, front_wheels_rise, back_wheels_rise)
{
	new BitStream: bs = BS_New();
	
	BS_WriteValue
	(
		bs,
		PR_UINT16, vehicleid,
		PR_UINT8, front_wheels_collapse,
		PR_UINT8, back_wheels_collapse,
		PR_UINT8, front_wheels_width,
		PR_UINT8, back_wheels_width,
		PR_UINT8, front_wheels_rise,
		PR_UINT8, back_wheels_rise
	);
	
	PR_SendRPC(bs, playerid, RPC_VehicleWheelsSettings);
	BS_Delete(bs);
}

stock EnableVehicleLights(playerid, vehicleid, r, g, b)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT16, vehicleid,
		PR_UINT8, r,
		PR_UINT8, g,
		PR_UINT8, b
	);

	PR_SendRPC(bs, playerid, RPC_VehicleLights);
	BS_Delete(bs);
}

stock EnableVehicleNeon(playerid, vehicleid, r, g, b, alpha)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT16, vehicleid,
		PR_UINT8, r,
		PR_UINT8, g,
		PR_UINT8, b,
		PR_UINT8, alpha
	);

	PR_SendRPC(bs, playerid, RPC_VehicleNeon);
	BS_Delete(bs);
}

stock EnableVehicleColor(playerid, vehicleid, r, g, b)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT16, vehicleid,
		PR_UINT8, r,
		PR_UINT8, g,
		PR_UINT8, b
	);

	PR_SendRPC(bs, playerid, RPC_VehicleColor);
	BS_Delete(bs);
	
	//printf("[debug] tuning -> EnableVehicleColor -> r: %d g: %d b: %d", r, g, b);
}

stock EnableVehicleTurnLight(playerid, vehicleid, status)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT16, vehicleid,
		PR_UINT8, status
	);

	PR_SendRPC(bs, playerid, RPC_VehicleTurnLight);
	BS_Delete(bs);
}

stock EnableVehicleTining(playerid, vehicleid, glass_id, r, g, b, alpha)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT16, vehicleid,
		PR_UINT8, glass_id,
		PR_UINT8, r,
		PR_UINT8, g,
		PR_UINT8, b,
		PR_UINT8, alpha
	);

	PR_SendRPC(bs, playerid, RPC_VehicleTining);
	BS_Delete(bs);
}
