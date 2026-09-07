Вставлять "../include/system/redadmin.inc" 
После строки "../include/system/pay.inc"
#if defined _redadmin_included
	#endinput
#endif
#define _redadmin_included

// Цвет ника для админов, залогиненных в админ-режим (RRGGBBAA)
#define ADMIN_NAME_COLOR (0xFF0000FF)

stock SetPlayerColorEx(playerid, color)
{
	SetPlayerData(playerid, P_COLOR, color);
	return SetPlayerColor(playerid, color);
}

stock SetPlayerColorInit(playerid)
{
	if(GetPlayerData(playerid, P_ADMIN_LOGGED))
		return SetPlayerColorEx(playerid, ADMIN_NAME_COLOR);

	return SetPlayerColorEx(playerid, GetPlayerTeamColor(playerid));
}
