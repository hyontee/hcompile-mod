#define CLIENTSIDE

#define MAX_TUNING_MODELS				10

#define SetVehicleTuning(%0,%1,%2)			g_vehicle_tuning[%0][%1] = %2
#define GetVehicleTuning(%0,%1)				g_vehicle_tuning[%0][%1]

#define SetVehicleTuningTemp(%0,%1,%2)		g_vehicle_tuning_temp[%0][%1] = %2
#define GetVehicleTuningTemp(%0,%1)			g_vehicle_tuning_temp[%0][%1]

#define MAX_AUDIO_STREM_URL_LENGHT			300

const VEHICLE_AUDIO_STREAM_ATTACH = 0;
const VEHICLE_AUDIO_STREAM_DETACH = 1;

const SPEEDOMETER_STATUS_SHOW = 1;
const SPEEDOMETER_STATUS_HIDE = 0;

enum
{
	SPEEDOMETER_ELEMENT_ID_FUEL = 2,
	SPEEDOMETER_ELEMENT_ID_DOORS,
	SPEEDOMETER_ELEMENT_ID_LIGHTS,
	SPEEDOMETER_ELEMENT_ID_ENGINE
}

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

new Text: tuning_menu_td[5];

enum E_HUD_VALUES_STRUCT
{
	HV_WEAPON_ID,
	HV_PATRONS_COUNT,
	HV_MONEY[100],
	HV_EURO,
	Float: HV_HEALTH,
	Float: HV_ARMOUR,
	HV_WANTED,
	
	HV_FUEL_COUNT,
	HV_SPEED_COUNT,
	bool: HV_VEH_LOCKED
}

new g_hud_value[MAX_PLAYERS][E_HUD_VALUES_STRUCT];

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
	VT_NEON_ALPHA,
	VT_MIGLO,
	VT_MIGLO_OBJECT,
	Float: VT_MIGLO_POS_X,
	Float: VT_MIGLO_POS_Y,
	Float: VT_MIGLO_POS_Z,
	VT_MODELS_STATUS[MAX_TUNING_MODELS],
	VT_NUMBER_PLATE_TYPE,
	VT_AUDIO_STREAM_URL[MAX_AUDIO_STREM_URL_LENGHT]
}

new g_vehicle_tuning[MAX_VEHICLES][E_VEHICLE_TUNING_STRUCT];
new g_vehicle_tuning_temp[MAX_VEHICLES][E_VEHICLE_TUNING_STRUCT];

new g_tuning_select[MAX_PLAYERS];

const RPC_VehicleTining = 192;
const RPC_VehicleTurnLight = 193;
const RPC_VehicleWheelsSettings = 194;
const RPC_VehicleLights = 195;
const RPC_VehicleNeon = 196;
const RPC_VehicleColor = 197;

const RPC_RemoveSync = 247;

const RPC_ColorPeekerStatus = 248;
const RPC_ColorPeekerCallback = 249;
const RPC_ColorPeekerClose = 250;

const RPC_VEHICLE_AUDIO_STREAM = 230;

const RPC_SPEEDOMETER = 240;

stock UpdatePlayerSpeedometerData(playerid, element_id, Float: temp)
{
	printf("[debug] UpdatePlayerSpeedometerData -> element_id: %d | temp float: %f | temp int: %d", element_id, temp, floatround(temp));

	new BitStream: bs = BS_New();

	switch(element_id)
	{
		case SPEEDOMETER_ELEMENT_ID_FUEL:
		{
			BS_WriteValue
			(
				bs,
				PR_UINT8, element_id,
				PR_FLOAT, temp
			);
		}

		default:
		{
			BS_WriteValue
			(
				bs,
				PR_UINT8, element_id,
				PR_UINT8, floatround(temp)
			);
		}
	}
	
	PR_SendRPC(bs, playerid, RPC_SPEEDOMETER);
	BS_Delete(bs);
}

stock ShowPlayerSpeedometer(playerid)
{
	printf("[debug] ShowPlayerSpeedometer (rpc_id: %d)", SPEEDOMETER_STATUS_SHOW);

	new BitStream: bs = BS_New();
	
	BS_WriteValue
	(
		bs,
		PR_UINT8, SPEEDOMETER_STATUS_SHOW
	);
	
	PR_SendRPC(bs, playerid, RPC_SPEEDOMETER);
	BS_Delete(bs);
}

stock HidePlayerSpeedometer(playerid)
{
	new BitStream: bs = BS_New();
	
	BS_WriteValue
	(
		bs,
		PR_UINT8, SPEEDOMETER_STATUS_HIDE
	);
	
	PR_SendRPC(bs, playerid, RPC_SPEEDOMETER);
	BS_Delete(bs);
}

stock CreateVehicleAudioStream(playerid, vehicleid, Float: max_distance, const url[])
{
	new BitStream: bs = BS_New();
	
	BS_WriteValue
	(
		bs,
		PR_UINT8, VEHICLE_AUDIO_STREAM_ATTACH,
		PR_INT16, vehicleid,
		PR_FLOAT, max_distance,
		PR_UINT16, strlen(url),
		PR_STRING, url
	);
	
	PR_SendRPC(bs, playerid, RPC_VEHICLE_AUDIO_STREAM);
	BS_Delete(bs);

	format(g_vehicle_tuning[vehicleid][VT_AUDIO_STREAM_URL], MAX_AUDIO_STREM_URL_LENGHT, "%s", url);
}

stock DestroyVehicleAudioStream(playerid, vehicleid)
{
	new BitStream: bs = BS_New();
	
	BS_WriteValue
	(
		bs,
		PR_UINT8, VEHICLE_AUDIO_STREAM_DETACH,
		PR_INT16, vehicleid
	);
	
	PR_SendRPC(bs, playerid, RPC_VEHICLE_AUDIO_STREAM);
	BS_Delete(bs);

	SetVehicleTuning(vehicleid, VT_AUDIO_STREAM_URL, EOS);
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

enum E_TUNING_MODELS_STRUCT
{
	TM_MODEL_ID,
	TM_ITEM_ID[MAX_TUNING_MODELS]
}

new g_tuning_models[][E_TUNING_MODELS_STRUCT] = 
{
	{411, 			{1196, 1201, -1, -1, -1, -1, -1, -1, -1, -1}},
	{15131, 		{2740, 2741, 2742, 2743, 2744, -1, -1, -1, -1, -1}},
	{15120, 		{2707, 2708, 2709, 2710, 2711, -1, -1, -1, -1, -1}},
	{15142, 		{2778, 2779, 2780, 2781, 2782, -1, -1, -1, -1, -1}},
	{15126, 		{2719, 2720, 2721, 2722, 2723, -1, -1, -1, -1, -1}},
	{15144, 		{2759, 2760, 2761, -1, -1, -1, -1, -1, -1, -1}},
	{15121, 		{1205, 1206, 2652, -1, -1, -1, -1, -1, -1, -1}},
	{15125, 		{2724, 2725, 2726, 2727, -1, -1, -1, -1, -1, -1}},
	{15141, 		{2772, 2773, 2774, 2775, 2776, 2777, -1, -1, -1, -1}},
	{549, 			{2712, 2713, 2714, 2715, 2716, 2717, -1, -1, -1, -1}},
	{15128, 		{2735, 2736, 2737, 2738, 2739, -1, -1, -1, -1, -1}},
	{613, 			{1202, 1203, 1204, 2641, 2642, 2643, 2644, -1, -1, -1}},
	{534, 			{2728, 2729, 2730, 2731, 2732, 2733, 2734, -1, -1, -1}},
	{558, 			{1088, 1089, 1091, 1163, 1164, 1165, 1166, 1168, -1, -1}},
	{559, 			{1159, 1160, -1, -1, -1, -1, -1, -1, -1, -1}},
	{536, 			{1104, 1105, 1182, 1181, 1184, -1, -1, -1, -1, -1}},
	{15166, 		{3924, 3925, 3926, 3927, 3928, 3929, 3931, 3932, 3933, 3934}},
	{15080, 		{2680, 2681, 2682, 2683, 2684, 2685, 2686, 2687, 2688, 2689}},
	//{1524, 			{1573, 1699, 2634, 2649, 2650, 2653, 2654, 2655, 2656, 2657}},
	{562, 			{1035, 1171, 1172, 1148, 1149, 1036, 1038, 1039, 1146, 1147}},
	{15119, 		{2695, 2697, 2698, 2699, 2700, 2701, 2702, 2704, 2706, -1}},
	{15115, 		{2661, 2662, 2663, 2664, 2665, 2666, 2673, 2674, 2675, -1}},
	{15140, 		{2762, 2763, 2764, 2765, 2766, 2767, 2768, 2769, 2770, 2771}},
	{565, 			{1138, 1150, 1151, 1152, 1153, -1, -1, -1, -1, -1}},
	{579, 			{1194, 1195, 2635, 2636, -1, -1, -1, -1, -1, -1}},
	{567, 			{1129, 1132, 1189, 1188, 1187, 1186, 1130, 1102, -1, -1}},
	{796, 			{2637, 2638, 2639, 2640, 2646, 2647, 2648, 2651, -1, -1}},
	{15107, 		{2667, 2668, 2669, 2670, 2671, 2672, -1, -1, -1, -1}},
	{585, 			{2658, 2659, 2660, -1, -1, -1, -1, -1, -1, -1}},
	{15114, 		{2676, 2678, 2679, -1, -1, -1, -1, -1, -1, -1}},
	{560, 			{1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, -1, -1}},
	{562, 			{1034, 1035, 1036, 1037, 1038, 1039, 1040, 1041, -1, -1}}
	//{15164, 		{2802, 2803, 2804, 2805, 2806, 2807, -1, -1, -1, -1}},
	//{15185, 		{2797, 2798, 2799, 2800, 2801, -1, -1, -1, -1, -1}}
};

new tuning_external_status[MAX_PLAYERS];

#define CLIENT_EVENT_RPC 215

enum E_CLIENT_EVENTS_STRUCT 
{
	CE_NONE,
	CE_INTERFACE = 2,
	CE_HANDLING = 7,
 	CE_NUMBER_PLATE = 32,
	CE_TINING = 12,
	CE_TURN_LIGHTS = 15,
	CE_TUNING = 17
};

enum E_CLIENT_EVENTS_TYPE_STRUCT 
{
	CET_NONE,
	CET_UPDATE = 2,
	CET_SHOW = 4,
	CET_HIDE,
	CET_NUMBER = 6
};

stock SendClientEvent(playerid, E_CLIENT_EVENTS_STRUCT:style, E_CLIENT_EVENTS_TYPE_STRUCT:type, const event[])
{
    new BitStream: bs = BS_New();

    BS_WriteValue(bs, PR_UINT8, CLIENT_EVENT_RPC);
    BS_WriteValue(bs, PR_UINT16, _:style);
	BS_WriteValue(bs, PR_UINT32, _:type);
	BS_WriteValue(bs, PR_UINT8, 1);
	
	BS_WriteValue
	(
		bs,
		PR_UINT32, strlen(event),
		PR_STRING, event, strlen(event)
	);

    PR_SendPacket(bs, playerid);
    BS_Delete(bs);
	
	return 1;
}

stock CreateVehicleNumberPlate(playerid, vehicleid, type, number[], region[])
{
    new BitStream: bs = BS_New();

    BS_WriteValue(bs, PR_UINT8, CLIENT_EVENT_RPC);
    BS_WriteValue(bs, PR_UINT16, _:CE_NUMBER_PLATE);
	BS_WriteValue(bs, PR_UINT32, vehicleid);

	BS_WriteValue(bs, PR_UINT32, 0);
	BS_WriteValue(bs, PR_UINT16, 256);

	BS_WriteValue(bs, PR_UINT32, type);
	
	BS_WriteValue
	(
		bs,
		PR_UINT32, strlen(number),
		PR_STRING, number, strlen(number)
	);
	
	BS_WriteValue
	(
		bs,
		PR_UINT32, strlen(region),
		PR_STRING, region, strlen(region)
	);

    PR_SendPacket(bs, playerid);
    BS_Delete(bs);
}

stock EnableVehicleTurnLights(playerid, vehicleid, id, status)
{
    new BitStream: bs = BS_New();

    BS_WriteValue(bs, PR_UINT8, CLIENT_EVENT_RPC);
    BS_WriteValue(bs, PR_UINT16, _:CE_TURN_LIGHTS);
	BS_WriteValue(bs, PR_UINT32, vehicleid);
	BS_WriteValue(bs, PR_UINT8, id);
    BS_WriteValue(bs, PR_UINT8, status);

    PR_SendPacket(bs, playerid);
    BS_Delete(bs);
}

stock CreateVehicleTuning(playerid, vehicleid, id)
{
    new BitStream: bs = BS_New();

    BS_WriteValue(bs, PR_UINT8, CLIENT_EVENT_RPC);
    BS_WriteValue(bs, PR_UINT16, _:CE_TUNING);
	BS_WriteValue(bs, PR_UINT32, vehicleid);
	BS_WriteValue(bs, PR_UINT32, id);
	BS_WriteValue(bs, PR_UINT32, 0);

    PR_SendPacket(bs, playerid);
    BS_Delete(bs);
}

stock SetVehicleTining(playerid, vehicleid, id_glass, color, color1, color2, procent)
{
    new BitStream: bs = BS_New();

    BS_WriteValue(bs, PR_UINT8, CLIENT_EVENT_RPC);
    BS_WriteValue(bs, PR_UINT16, _:CE_TINING);
	BS_WriteValue(bs, PR_UINT32, vehicleid);
	BS_WriteValue(bs, PR_UINT32, id_glass);
    BS_WriteValue(bs, PR_UINT8, color);
    BS_WriteValue(bs, PR_UINT8, color1);
    BS_WriteValue(bs, PR_UINT8, color2);
    BS_WriteValue(bs, PR_UINT8, procent);

    PR_SendPacket(bs, playerid);
    BS_Delete(bs);
}

new _info[4096];
new _format[4096];

stock client_Dialog(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
    _info[0] = '\0';
	strcat(_info, info);
	
	for (new i = strfind(_info, "\n", true); i != -1; i = strfind(_info, "\n", true, i)) {
		strdel(_info, i, i + 1);
		strins(_info, "<n>", i);
	}
	
	for (new i = strfind(_info, "\t", true); i != -1; i = strfind(_info, "\t", true, i)) {
		strdel(_info, i, i + 1);
		strins(_info, "<t>", i);
	}
	
	ReplaceString(_info, "\"", "&quot;", _, true);
	printf("%d %d %s %s %s %s", dialogid, style, caption, _info, button1, button2);
    format(_format, sizeof _format, "window.addDialogInQueue([%i,%i,\"%s\",\"%s\",\"%s\",\"%s\"])", dialogid, style, caption, _info, button1, button2);
    SendClientEvent(playerid, CE_INTERFACE, CET_UPDATE, _format);

    return 1;
}

stock ShowPlayerChat(playerid)
{
	SendClientEvent(playerid, CE_INTERFACE, CET_UPDATE, "window.interface(\"Hud\").setChatStatus(!0)");
}

stock HidePlayerChat(playerid)
{
	SendClientEvent(playerid, CE_INTERFACE, CET_UPDATE, "window.interface(\"Hud\").setChatStatus(!1)");
}

stock ShowPlayerGameHUD(playerid)
{
	SendClientEvent(playerid, CE_INTERFACE, CET_UPDATE, "client.setHudStatus(true)");
}

stock HidePlayerGameHUD(playerid)
{
	SendClientEvent(playerid, CE_INTERFACE, CET_UPDATE, "client.setHudStatus(false)");
}

stock ShowPlayerCursor(playerid)
{
	SendClientEvent(playerid, CE_INTERFACE, CET_UPDATE, "client.setCursorStatus(true)");
	
	HidePlayerGameHUD(playerid);
	HidePlayerChat(playerid);
}

stock HidePlayerCursor(playerid)
{
	SendClientEvent(playerid, CE_INTERFACE, CET_UPDATE, "client.setCursorStatus(false)");
	
	ShowPlayerGameHUD(playerid);
	ShowPlayerChat(playerid);
}

stock ShowPlayerGameText(playerid, const text[], time, style)
{
	STRING_GLOBAL[0] = EOS;
	
	format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "interface('GameText').add('[%d,\"%s\",%d,0,-1,1]')", style, text, time);
	
	SendClientEvent(playerid, CE_INTERFACE, CET_UPDATE, STRING_GLOBAL);
 	return SendClientEvent(playerid, CE_INTERFACE, CET_UPDATE, "GameText");	
}

stock ReplaceString(inputvar[], const searchstring[], const replacestring[], bool: ignorecase = true, bool: replaceall = false) 
{
	if(strfind(replacestring, searchstring, ignorecase) != -1) return -1;
	
	new pos = strfind(inputvar, searchstring, ignorecase);
	
	if(pos == -1) return 0;
	
	if(replaceall == true)
	{
		while(strfind(inputvar, searchstring, ignorecase) != -1)
		{
			pos = strfind(inputvar, searchstring, ignorecase);
			
			strdel(inputvar, pos, pos + strlen(searchstring));
			strins(inputvar, replacestring, pos, strlen(inputvar));
		}
	}
		
	else 
	{
		strdel(inputvar, pos, pos+strlen(searchstring));
		strins(inputvar, replacestring, pos, strlen(inputvar));
	}
	
	return 1;
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
	ShowPlayerColorPeeker(playerid);
	
	/*for(new i = 0; i != 11; i ++)
		TextDrawShowForPlayer(playerid, sto_td_global[i]);
	
	for(new i = 0; i != 2; i ++)
		PlayerTextDrawShow(playerid, sto_td_player[playerid][i]);*/
	
	for(new idx; idx < 43; idx ++)
		TextDrawShowForPlayer(playerid, td_sto[idx]);
	
	for(new i = 0; i != sizeof tuning_menu_td; i ++)
		TextDrawShowForPlayer(playerid, tuning_menu_td[i]);
	
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

stock SetModelHandling(playerid, vehicleid, handling_int, const handling_string[])
{
	new BitStream: bs = BS_New();
	
	BS_WriteValue(bs, PR_UINT8, CLIENT_EVENT_RPC);
	BS_WriteValue(bs, PR_UINT16, _:CE_HANDLING);
	BS_WriteValue(bs, PR_UINT32, vehicleid);
	BS_WriteValue(bs, PR_UINT32, handling_int, PR_STRING, handling_string);
	PR_SendPacket(bs, playerid);
	
	BS_Delete(bs);
}

const RPC_ShowBrowser = 220;

stock ShowPlayerBrowser(playerid, const url[])
{
	new BitStream: bs = BS_New();
	
	BS_WriteValue
	(
		bs,
		PR_STRING, url
	);
	
	PR_SendRPC(bs, playerid, RPC_ShowBrowser);
	BS_Delete(bs);	
}

const MAIN_DLL_PACKET_ID = 245;

const RPC_SNOW_ENABLE = 12;
const RPC_SNOW_DISABLE = 13;

const RPC_TUNING_LIGHTS = 7;
const RPC_TUNING_WHEELS = 10;
const RPC_TUNING_DRIFT = 14;
const RPC_TUNING_ENGINE = 15;
const RPC_TUNING_TURN_LIGHTS = 9;
const RPC_TUNING_NEON = 8;
const RPC_TUNING_COLOR = 6;
const RPC_TUNING_TINING = 11;

const RPC_COLOR_PEEKER_SHOW = 16;

stock EnablePlayerSnow(playerid, type)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT8, MAIN_DLL_PACKET_ID,
		PR_UINT8, RPC_SNOW_ENABLE,
		PR_UINT8, type
	);

	PR_SendPacket(bs, playerid);
}

stock DisablePlayerSnow(playerid)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT8, MAIN_DLL_PACKET_ID,
		PR_UINT8, RPC_SNOW_DISABLE
	);

	PR_SendPacket(bs, playerid);

	return 1;
}

stock EnableVehicleLights(playerid, vehicleid, r, g, b)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT8, 	MAIN_DLL_PACKET_ID,
		PR_UINT8, 	RPC_TUNING_LIGHTS,
		PR_UINT16, 	vehicleid,
		PR_UINT8, 	r,
		PR_UINT8, 	g,
		PR_UINT8, 	b
	);

  	PR_SendPacket(bs, playerid);
	BS_Delete(bs);
}

stock ChangeVehicleWheels(playerid, vehicleid, front_wheels_collapse, back_wheels_collapse, front_wheels_width, back_wheels_width, front_wheels_rise, back_wheels_rise)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT8, 	MAIN_DLL_PACKET_ID,
		PR_UINT8, 	RPC_TUNING_WHEELS,
		PR_UINT16, 	vehicleid,
		PR_UINT8, 	front_wheels_collapse,
		PR_UINT8, 	back_wheels_collapse,
		PR_UINT8, 	front_wheels_width,
		PR_UINT8, 	back_wheels_width,
		PR_UINT8, 	front_wheels_rise,
		PR_UINT8, 	back_wheels_rise
	);

	PR_SendPacket(bs, playerid);
	BS_Delete(bs);
}

stock ChangeVehiclePhysicsParams(playerid, vehicleid, multi, loss)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT8, 	MAIN_DLL_PACKET_ID,
		PR_UINT8, 	RPC_TUNING_DRIFT,
		PR_UINT16, 	vehicleid,
		PR_FLOAT, 	multi,
		PR_FLOAT, 	loss
	);

	PR_SendPacket(bs, playerid);
	BS_Delete(bs);
}

stock ChangeVehicleEngineParams(playerid, vehicleid, drag_multipliyer, engine_acceleration, engine_intia, max_velocity)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT8, 	MAIN_DLL_PACKET_ID,
		PR_UINT8, 	RPC_TUNING_ENGINE,
		PR_UINT16, 	vehicleid,
		PR_FLOAT, 	drag_multipliyer,
		PR_FLOAT, 	engine_acceleration,
		PR_FLOAT, 	engine_intia,
		PR_FLOAT, 	max_velocity
	);

	PR_SendPacket(bs, playerid);
	BS_Delete(bs);
}

stock EnableVehicleNeon(playerid, vehicleid, r, g, b, alpha)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT8,	MAIN_DLL_PACKET_ID,
		PR_UINT8,	RPC_TUNING_NEON,
		PR_UINT16, 	vehicleid,
		PR_UINT8, 	r,
		PR_UINT8, 	g,
		PR_UINT8,	b,
		PR_UINT8, 	alpha
	);

	PR_SendPacket(bs, playerid);
	BS_Delete(bs);
}

stock EnableVehicleColor(playerid, vehicleid, r, g, b)
{
	new BitStream: bs = BS_New();

	BS_WriteValue
	(
		bs,
		PR_UINT8,	MAIN_DLL_PACKET_ID,
		PR_UINT8,	RPC_TUNING_COLOR,
		PR_UINT16, 	vehicleid,
		PR_UINT8, 	r,
		PR_UINT8, 	g,
		PR_UINT8, 	b
	);

	PR_SendPacket(bs, playerid);
	BS_Delete(bs);
}

stock ShowPlayerColorPeeker(playerid)
{
	new id = 0;
	
	new BitStream: bs = BS_New();
		
	BS_WriteValue
	(
		bs,
		PR_UINT8,	MAIN_DLL_PACKET_ID,
		PR_UINT8,	RPC_COLOR_PEEKER_SHOW,
		PR_UINT8, 	id
	);
	
	PR_SendPacket(bs, playerid);
	BS_Delete(bs);
}