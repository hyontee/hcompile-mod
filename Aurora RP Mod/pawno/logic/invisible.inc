
#if defined _invisible_inc
	#endinput
#endif
#define _invisible_inc

new Text:InvisibleInfoTD;
static bool:TPI_IsInvisible[MAX_PLAYERS char];

stock TogglePlayerInvisibility(playerid, bool:toggle) {
	TPI_IsInvisible{playerid} = toggle;
	
	if (toggle) {
		new BitStream:tpi_bs = BS_New();
		
		BS_WriteValue(
			tpi_bs,
			PR_UINT16, playerid
		);

		BS_RPC(tpi_bs, -1, 0xA3);
		BS_Delete(tpi_bs);
		TextDrawShowForPlayer(playerid, InvisibleInfoTD);
	} else {
		new
			BitStream:tpi_bs = BS_New(),
			Float:tpi_pos_x,
			Float:tpi_pos_y,
			Float:tpi_pos_z,
			Float:tpi_angle;
		
		GetPlayerPos(playerid, tpi_pos_x, tpi_pos_y, tpi_pos_z);
		GetPlayerFacingAngle(playerid, tpi_angle);

		BS_WriteValue(
			tpi_bs,
			PR_UINT16, playerid,
			PR_UINT8, GetPlayerTeam(playerid),
			PR_UINT32, GetPlayerSkin(playerid),
			PR_FLOAT, tpi_pos_x,
			PR_FLOAT, tpi_pos_y,
			PR_FLOAT, tpi_pos_z,
			PR_FLOAT, tpi_angle,
			PR_UINT32, GetPlayerColor(playerid),
			PR_UINT8, GetPlayerFightingStyle(playerid)
		);
		BS_RPC(tpi_bs, -1, 0x20);
		BS_Delete(tpi_bs);
		TextDrawHideForPlayer(playerid, InvisibleInfoTD);
	}
}

stock IsPlayerInvisible(playerid)
	return TPI_IsInvisible{playerid};

/*OnPlayerConnect*/
public OnPlayerConnect(playerid) {
	TPI_IsInvisible{playerid} = false;
	
	#if defined TPI_OnPlayerConnect
		return TPI_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
alias:invis("inviz");
CMD:invis(playerid) {
	if (PI[playerid][pAdmin] < 2 || dostup[playerid] == 0) 
		return true;
	if (IsPlayerInAnyVehicle(playerid)) {
		ErrorMessage(playerid, "Нельзя использовать в транспорте!");
		return true;
	}
	if (IsPlayerInvisible(playerid)) {
		TogglePlayerInvisibility(playerid, false);
		SendOk(playerid, "Вы теперь видимы для игроков!");
		// GameTextForPlayer(playerid, "~w~INVISIBLE MODE ~r~OFF", 500, 1);
	} else {
		TogglePlayerInvisibility(playerid, true);
		SendOk(playerid, "Вы теперь невидимы для игроков!");
		// GameTextForPlayer(playerid, "~w~INVISIBLE MODE ~g~ON", 500, 1);
	}
	return true;
}
alias:invislist("invizlist");
CMD:invislist(playerid) {
	if (PI[playerid][pAdmin] < 2 || dostup[playerid] == 0) return true;
	new idx = 0;
	STRING_GLOBAL[0] = EOS;

	foreach(new i: Player) {
		if (!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) 
			continue;
		if (!IsPlayerInvisible(i)) 
			continue;
		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s\
			"YELLOW"%d. "ORANGE"%s"W" | ID: "P"%d"W"\n", STRING_GLOBAL,
			++idx, player_name[i], i
		);
	}
	if (idx == 0) return ErrorMessage(playerid, "Нет администрации в режиме невидимки!");
	ShowPlayerDialog(playerid, DIALOG_NONE, DSM, ""P"Режим невидимки", STRING_GLOBAL, "Закрыть", "");

	STRING_GLOBAL[0] = EOS;
	return true;
}
public OnOutcomingRPC(playerid, rpcid, BitStream:bs) {
	if (rpcid == 0x20) {
	    new tpi_playerid;
	    BS_ReadValue(bs, PR_UINT16, tpi_playerid);
		if (TPI_IsInvisible{tpi_playerid}) return 0;
	}
	#if defined TPI_OnOutcomingRPC
		return TPI_OnOutcomingRPC(playerid, rpcid, bs);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnOutcomingRPC
	#undef OnOutcomingRPC
#else
#define _ALS_OnOutcomingRPC
	#endif
#define OnOutcomingRPC TPI_OnOutcomingRPC

#if defined TPI_OnOutcomingRPC
	forward TPI_OnOutcomingRPC(playerid, rpcid, BitStream:bs);
#endif

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
#define _ALS_OnPlayerConnect
	#endif
#define OnPlayerConnect TPI_OnPlayerConnect

#if defined TPI_OnPlayerConnect
	forward TPI_OnPlayerConnect(playerid);
#endif