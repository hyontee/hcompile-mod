// —лежка администратора (/sp): синхронизаци€ интерьера/VW, авто-переключение, корректный выход
#if defined _ADMIN_SPECTATE_INC
	#endinput
#endif
#define _ADMIN_SPECTATE_INC

forward ShowSpectateGUI(playerid, targetid);
forward Admin_DelayedSpectateResync(adminid, targetid);

stock bool:Admin_IsSpectating(playerid)
{
	return (GetPVarType(playerid, "IsSpectating") != PLAYER_VARTYPE_NONE && GetPVarInt(playerid, "IsSpectating") != 0);
}

stock bool:Admin_CanSpectateTarget(adminid, targetid)
{
	if(!IsPlayerConnected(targetid)) return false;
	if(targetid == adminid) return false;
	if(IsPlayerNPC(targetid)) return false;
	if(Admin_IsSpectating(targetid)) return false;
	if(Player[targetid][pID] <= 0) return false;
	return true;
}

stock Admin_SpectateResync(adminid, targetid)
{
	if(!Admin_IsSpectating(adminid)) return 0;
	if(GetPVarInt(adminid, "SpectatingID") != targetid) return 0;
	if(!IsPlayerConnected(targetid)) return 0;

	SetPlayerInterior(adminid, GetPlayerInterior(targetid));
	SetPlayerVirtualWorld(adminid, GetPlayerVirtualWorld(targetid));

	if(IsPlayerInAnyVehicle(targetid))
	{
		new veh = GetPlayerVehicleID(targetid);
		if(veh != INVALID_VEHICLE_ID)
			PlayerSpectateVehicle(adminid, veh);
		else
			PlayerSpectatePlayer(adminid, targetid);
	}
	else
		PlayerSpectatePlayer(adminid, targetid);

	return 1;
}

stock Admin_SpectateResyncAllFor(targetid)
{
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!Admin_IsSpectating(i)) continue;
		if(GetPVarInt(i, "SpectatingID") != targetid) continue;

		Admin_SpectateResync(i, targetid);
		SetTimerEx("Admin_DelayedSpectateResync", 200, false, "ii", i, targetid);
	}
	return 1;
}

public Admin_DelayedSpectateResync(adminid, targetid)
{
	if(!IsPlayerConnected(adminid) || !IsPlayerConnected(targetid)) return 0;
	return Admin_SpectateResync(adminid, targetid);
}

stock Admin_SpectateFindNext(adminid, after_id)
{
	new pool = GetPlayerPoolSize();
	new start = (after_id >= 0 && after_id < pool) ? (after_id + 1) : 0;

	for(new i = start; i <= pool; i++)
	{
		if(Admin_CanSpectateTarget(adminid, i)) return i;
	}
	for(new i = 0; after_id > 0 && i < after_id; i++)
	{
		if(Admin_CanSpectateTarget(adminid, i)) return i;
	}
	return INVALID_PLAYER_ID;
}

stock Admin_StartSpectate(adminid, targetid)
{
	if(Player[adminid][pAdminLvl] < 1) return 0;
	if(!Player[adminid][pAdminAuth]) return 0;
	if(!Admin_CanSpectateTarget(adminid, targetid)) return 0;

	if(!Admin_IsSpectating(adminid))
	{
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(adminid, x, y, z);
		GetPlayerFacingAngle(adminid, a);
		SetPVarFloat(adminid, "AdminPosX", x);
		SetPVarFloat(adminid, "AdminPosY", y);
		SetPVarFloat(adminid, "AdminPosZ", z);
		SetPVarFloat(adminid, "AdminPosA", a);
		SetPVarInt(adminid, "AdminPosInt", GetPlayerInterior(adminid));
		SetPVarInt(adminid, "AdminPosVW", GetPlayerVirtualWorld(adminid));
		TogglePlayerSpectating(adminid, true);
	}

	SetPVarInt(adminid, "IsSpectating", 1);
	SetPVarInt(adminid, "SpectatingID", targetid);
	Admin_SpectateResync(adminid, targetid);
	SetTimerEx("Admin_DelayedSpectateResync", 150, false, "ii", adminid, targetid);
	ShowSpectateGUI(adminid, targetid);
	return 1;
}

stock Admin_StopSpectate(adminid)
{
	if(!Admin_IsSpectating(adminid)) return 0;

	TogglePlayerSpectating(adminid, false);

	new Float:x = GetPVarFloat(adminid, "AdminPosX");
	new Float:y = GetPVarFloat(adminid, "AdminPosY");
	new Float:z = GetPVarFloat(adminid, "AdminPosZ");
	new Float:a = GetPVarFloat(adminid, "AdminPosA");
	new interior = GetPVarInt(adminid, "AdminPosInt");
	new vw = GetPVarInt(adminid, "AdminPosVW");

	SetPlayerPosEx(adminid, x, y, z, a, interior, vw, false);
	SetPlayerSkin(adminid, Player[adminid][pSkin]);
	SetCameraBehindPlayer(adminid);
	TogglePlayerControllable(adminid, true);

	new Node:close_json = JSON_Object();
	JSON_SetInt(close_json, "c", 1);
	OnPacketIncoming(adminid, 66, close_json);
	JSON_Cleanup(close_json);

	DeletePVar(adminid, "IsSpectating");
	DeletePVar(adminid, "SpectatingID");
	DeletePVar(adminid, "AdminPosX");
	DeletePVar(adminid, "AdminPosY");
	DeletePVar(adminid, "AdminPosZ");
	DeletePVar(adminid, "AdminPosA");
	DeletePVar(adminid, "AdminPosInt");
	DeletePVar(adminid, "AdminPosVW");
	return 1;
}

stock Admin_HandleSpectateTargetLeave(targetid)
{
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!Admin_IsSpectating(i)) continue;
		if(GetPVarInt(i, "SpectatingID") != targetid) continue;

		new nextid = Admin_SpectateFindNext(i, targetid);
		if(nextid != INVALID_PLAYER_ID)
		{
			Admin_StartSpectate(i, nextid);
			new msg[96];
			format(msg, sizeof msg, "[A] »грок вышел. —лежка переключена на %s[%d].", Player[nextid][pName], nextid);
			SendClientMessage(i, 0xFFAA00FF, msg);
		}
		else
		{
			Admin_StopSpectate(i);
			SendClientMessage(i, 0xFFAA00FF, "[A] »грок вышел. ƒругих целей дл€ слежки нет Ч режим наблюдени€ выключен.");
		}
	}
	return 1;
}

stock Admin_Spectate_OnInteriorChange(playerid)
{
	return Admin_SpectateResyncAllFor(playerid);
}

stock Admin_Spectate_OnStateChange(playerid, newstate)
{
	#pragma unused newstate
	return Admin_SpectateResyncAllFor(playerid);
}

stock Admin_Spectate_OnPlayerDisconnect(playerid)
{
	return Admin_HandleSpectateTargetLeave(playerid);
}
