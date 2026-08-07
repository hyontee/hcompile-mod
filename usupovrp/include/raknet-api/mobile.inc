#define IsPlayerFromThePhone(%0) 	is_mobile[%0]

new bool: is_mobile[MAX_PLAYERS] = false;

const PACKET_CUSTOM_RPC = 251;

//const RPC_HUD_DATA = 0x16;
//const RPC_SPEEDOMETER_DATA = 0x17;

//const RPC_HUD_STATUS_DATA = 0x18;
//const RPC_SPEEDOMETER_STATUS_DATA = 0x19;

//const RPC_SHOW_NOTIFICATION = 0x23;

const RPC_CLIENT_JOIN = 25;

new hud_show_status = 0;

new crash_status[MAX_PLAYERS];

enum E_CLIENT_STRUCT
{
	iVersion, 						// - INT32
	byteMod, 						// - UINT8
	byteNicknameLen, 				// - UINT8
	NickName[MAX_PLAYER_NAME], 		// - char
	uiClientChallengeResponse, 		// - UINT32
	byteAuthKeyLen, 				// - UINT8
	auth_key[64], 					// - char
	iClientVerLen, 					// - UINT8
	ClientVersion[12] 				// - char
};

IRPC:RPC_CLIENT_JOIN(playerid, BitStream: bs)
{
	if(playerid == -1 || playerid < 0 || playerid > 1000) return 1;
	
	new client_data[E_CLIENT_STRUCT];
	
	BS_ReadValue
	(
		bs,
		PR_INT32, client_data[iVersion],
		PR_UINT8, client_data[byteMod],
		PR_UINT8, client_data[byteNicknameLen],
		PR_STRING, client_data[NickName], client_data[byteNicknameLen],
		PR_UINT32, client_data[uiClientChallengeResponse],
		PR_UINT8, client_data[byteAuthKeyLen],
		PR_STRING, client_data[auth_key], client_data[byteAuthKeyLen],
		PR_UINT8, client_data[iClientVerLen],
		PR_STRING, client_data[ClientVersion], client_data[iClientVerLen]
	);
	
	if(GetString(client_data[auth_key], "E02262CF28BC542486C558D4BE9EFB716592AFAF8B"))
	{
		is_mobile[playerid] = true;

		printf("(MOBILE CONNECT) PLAYERID: %d", playerid);
	}
	
	return 1;
}

/*stock SendPlayerHudData(playerid, server_online, green_zone_status, euro_count)
{
	if(!hud_show_status) return 1;
	
	new BitStream: bs = BS_New();
	
	BS_WriteValue(bs, PR_UINT8, PACKET_CUSTOM_RPC);
	//BS_WriteValue(bs, PR_UINT32, RPC_HUD_DATA);
	
	BS_WriteValue
	(
		bs,
		PR_INT32, server_online,
		PR_INT32, green_zone_status,
		PR_INT32, euro_count
	);

	PR_SendPacket(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
	BS_Delete(bs);
	
	return 1;
}

stock SendPlayerSpeedometerData(playerid, engine_status, lights_status, is_locked, fuel_count)
{
	if(!IsPlayerInAnyVehicle(playerid)) return 1;
	
	new BitStream: bs = BS_New();
	
	BS_WriteValue(bs, PR_UINT8, PACKET_CUSTOM_RPC);
	//BS_WriteValue(bs, PR_UINT32, RPC_SPEEDOMETER_DATA);
	
	BS_WriteValue
	(
		bs,
		PR_INT32, engine_status,
		PR_INT32, lights_status,
		PR_INT32, is_locked,
		PR_INT32, fuel_count
	);

	PR_SendPacket(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
	BS_Delete(bs);
	
	return 1;
}

stock ShowPlayerHud(playerid)
{
	hud_show_status = 1;
	
	new BitStream: bs = BS_New();
	
	BS_WriteValue(bs, PR_UINT8, PACKET_CUSTOM_RPC);
	//BS_WriteValue(bs, PR_UINT32, RPC_HUD_STATUS_DATA);
	
	BS_WriteValue
	(
		bs,
		PR_INT32, 1
	);

	PR_SendPacket(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
	BS_Delete(bs);
}

stock HidePlayerHud(playerid)
{
	hud_show_status = 0;
	
	new BitStream: bs = BS_New();
	
	BS_WriteValue(bs, PR_UINT8, PACKET_CUSTOM_RPC);
	//BS_WriteValue(bs, PR_UINT32, RPC_HUD_STATUS_DATA);
	
	BS_WriteValue
	(
		bs,
		PR_INT32, 0
	);

	PR_SendPacket(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
	BS_Delete(bs);
}

stock ShowPlayerSpeedometer(playerid)
{
	new BitStream: bs = BS_New();
	
	BS_WriteValue(bs, PR_UINT8, PACKET_CUSTOM_RPC);
	//BS_WriteValue(bs, PR_UINT32, RPC_SPEEDOMETER_STATUS_DATA);
	
	BS_WriteValue
	(
		bs,
		PR_INT32, 1
	);

	PR_SendPacket(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
	BS_Delete(bs);
}

stock HidePlayerSpeedometer(playerid)
{
	new BitStream: bs = BS_New();
	
	BS_WriteValue(bs, PR_UINT8, PACKET_CUSTOM_RPC);
	//BS_WriteValue(bs, PR_UINT32, RPC_SPEEDOMETER_STATUS_DATA);
	
	BS_WriteValue
	(
		bs,
		PR_INT32, 0
	);

	PR_SendPacket(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
	BS_Delete(bs);
}

const PACKET_GAME_CRASHED = 246;

IPacket:PACKET_GAME_CRASHED(playerid, BitStream: bs)
{
	if(!IsPlayerFromThePhone(playerid)) return 1;
	if(crash_status[playerid] > GetTickCount()) return 1;
	
	crash_status[playerid] = GetTickCount() + 30000;
 
	new Float: x, Float: y, Float: z;
	GetPlayerPos(playerid, x, y, z);
	
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	
	printf("[DE-BUG] Player %s [%d] has been crashed (M) (%f, %f, %f)", name, playerid, x, y, z);
	
	AddToWarningPanel(playerid, "Обрыв связи (M)", 3);
 
	return 1;
}

stock ShowNotification(playerid, type, const text[], time, const actionforFirstBtn[] = "null", const textFirstBtn[] = "null", const actionforSecondBtn[] = "null", const textSecondBtn[] = "null")
{
   new BitStream: bs = BS_New();
	
    BS_WriteValue(bs, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bs, PR_UINT32, RPC_SHOW_NOTIFICATION);
    
    BS_WriteValue(bs, PR_INT32, type);
    
    BS_WriteValue(bs, PR_UINT16, strlen(text));
    BS_WriteValue(bs, PR_STRING, text);
    
    BS_WriteValue(bs, PR_INT32, time);
    
    BS_WriteValue(bs, PR_UINT16, strlen(actionforFirstBtn));
    BS_WriteValue(bs, PR_STRING, actionforFirstBtn);
    
    BS_WriteValue(bs, PR_UINT16, strlen(textFirstBtn));
    BS_WriteValue(bs, PR_STRING, textFirstBtn);
	
	BS_WriteValue(bs, PR_UINT16, strlen(actionforSecondBtn));
    BS_WriteValue(bs, PR_STRING, actionforSecondBtn);
    
    BS_WriteValue(bs, PR_UINT16, strlen(textSecondBtn));
    BS_WriteValue(bs, PR_STRING, textSecondBtn);
    
    PR_SendPacket(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bs);

	return 1;
}

const PACKET_MENU_BUTTON = 247;

IPacket:PACKET_MENU_BUTTON(playerid, BitStream: bs)
{
	if(!IsPlayerFromThePhone(playerid)) return 1;
	
	return callcmd::menu(playerid);
}*/