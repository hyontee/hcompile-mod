#include <a_samp>

#define S_PLAYER 0
#define S_START_POS_X 1
#define S_START_POS_Y 2
#define S_START_POS_Z 3
#define S_START_ANGLE 4
#define S_START_INTERIOR 5
#define S_START_VIRTUAL_WORLD 6

new PlayerSpectateData[MAX_PLAYERS][7];

new Text:wertonsp_TD[5];
new PlayerText:wertonsp_PTD[MAX_PLAYERS][8];

stock SetPlayerSpectateData(playerid, index, value) 
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(index < 0 || index >= sizeof(PlayerSpectateData[])) return 0;
    
    PlayerSpectateData[playerid][index] = value;
    return 1;
}

stock GetPlayerSpectateData(playerid, index) 
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return -1;
    if(index < 0 || index >= sizeof(PlayerSpectateData[])) return -1;
    
    return PlayerSpectateData[playerid][index];
}

public OnGameModeInit()
{
    SpMenu();
    #if defined spec_OnGameModeInit
        return spec_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit spec_OnGameModeInit
#if defined spec_OnGameModeInit
    forward spec_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
    CreatePlayerTextDrawSpMenu(playerid);
    #if defined spec_OnPlayerConnect
        return spec_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect spec_OnPlayerConnect
#if defined spec_OnPlayerConnect
    forward spec_OnPlayerConnect(playerid);
#endif

stock CreatePlayerTextDrawSpMenu(playerid)
{
    wertonsp_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 308.0000, 347.3025, "[0]_Nick_Name");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][0], 0.400000, 1.600000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][0], 2);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][0], 0);
    
    wertonsp_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 610.4500, 87.0000, "48");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][1], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][1], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][1], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][1], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][1], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][1], 0);
    
    wertonsp_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 610.4500, 107.5500, "0");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][2], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][2], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][2], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][2], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][2], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][2], 0);
    
    wertonsp_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 610.4500, 119.0000, "2");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][3], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][3], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][3], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][3], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][3], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][3], 0);
    
    wertonsp_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 610.4500, 136.0000, "100");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][4], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][4], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][4], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][4], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][4], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][4], 0);
    
    wertonsp_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 610.4500, 150.0000, "0");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][5], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][5], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][5], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][5], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][5], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][5], 0);
    
    wertonsp_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 610.4500, 168.0000, "1000000");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][6], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][6], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][6], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][6], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][6], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][6], 0);
    
    wertonsp_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 610.4500, 186.0000, "13");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][7], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][7], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][7], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][7], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][7], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][7], 0);
}

stock SpMenu()
{
    wertonsp_TD[0] = TextDrawCreate(-2.2000, 0.0000, "txd:sp_main");
    TextDrawTextSize(wertonsp_TD[0], 644.0000, 448.0000);
    TextDrawAlignment(wertonsp_TD[0], 1);
    TextDrawColor(wertonsp_TD[0], -1);
    TextDrawBackgroundColor(wertonsp_TD[0], 255);
    TextDrawFont(wertonsp_TD[0], 4);
    TextDrawSetProportional(wertonsp_TD[0], 0);
    TextDrawSetShadow(wertonsp_TD[0], 0);

    wertonsp_TD[1] = TextDrawCreate(108.0000, 394.0000, "txd:transparent");
    TextDrawTextSize(wertonsp_TD[1], 42.0000, 32.0000);
    TextDrawAlignment(wertonsp_TD[1], 1);
    TextDrawColor(wertonsp_TD[1], -1);
    TextDrawBackgroundColor(wertonsp_TD[1], 255);
    TextDrawFont(wertonsp_TD[1], 4);
    TextDrawSetProportional(wertonsp_TD[1], 0);
    TextDrawSetShadow(wertonsp_TD[1], 0);
    TextDrawSetSelectable(wertonsp_TD[1], true);
    
    wertonsp_TD[2] = TextDrawCreate(480.0000, 394.0000, "txd:transparent");
    TextDrawTextSize(wertonsp_TD[2], 42.0000, 32.0000);
    TextDrawAlignment(wertonsp_TD[2], 1);
    TextDrawColor(wertonsp_TD[2], -1);
    TextDrawBackgroundColor(wertonsp_TD[2], 255);
    TextDrawFont(wertonsp_TD[2], 4);
    TextDrawSetProportional(wertonsp_TD[2], 0);
    TextDrawSetShadow(wertonsp_TD[2], 0);
    TextDrawSetSelectable(wertonsp_TD[2], true);
    
    wertonsp_TD[3] = TextDrawCreate(374.0000, 338.0000, "txd:transparent");
    TextDrawTextSize(wertonsp_TD[3], 54.0000, 37.0000);
    TextDrawAlignment(wertonsp_TD[3], 1);
    TextDrawColor(wertonsp_TD[3], -1);
    TextDrawBackgroundColor(wertonsp_TD[3], 255);
    TextDrawFont(wertonsp_TD[3], 4);
    TextDrawSetProportional(wertonsp_TD[3], 0);
    TextDrawSetShadow(wertonsp_TD[3], 0);
    TextDrawSetSelectable(wertonsp_TD[3], true);
    
    wertonsp_TD[4] = TextDrawCreate(212.0000, 335.0000, "txd:transparent");
    TextDrawTextSize(wertonsp_TD[4], 31.0000, 41.0000);
    TextDrawAlignment(wertonsp_TD[4], 1);
    TextDrawColor(wertonsp_TD[4], -1);
    TextDrawBackgroundColor(wertonsp_TD[4], 255);
    TextDrawFont(wertonsp_TD[4], 4);
    TextDrawSetProportional(wertonsp_TD[4], 0);
    TextDrawSetShadow(wertonsp_TD[4], 0);
    TextDrawSetSelectable(wertonsp_TD[4], true);
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == wertonsp_TD[1])
    {
         new splayerid = GetPlayerSpectateData(playerid, S_PLAYER);
         PrevSpecNew(playerid, splayerid);
    }
    if(clickedid == wertonsp_TD[2])
    {
         new splayerid = GetPlayerSpectateData(playerid, S_PLAYER);
         NextSpecNew(playerid, splayerid);
    }
    if(clickedid == wertonsp_TD[3])
    {
         CMD:spoff(playerid, "");
    }
    if(clickedid == wertonsp_TD[4])
    {
         new splayerid = GetPlayerSpectateData(playerid, S_PLAYER);
         UpdateSpecNew(playerid, splayerid);
    }
    #if defined spec_OnPlayerClickTextDraw
        return spec_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw spec_OnPlayerClickTextDraw
#if defined spec_OnPlayerClickTextDraw
    forward spec_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

stock UpdateSpecNew(playerid, to_player)
{
	if(GetPlayerAdminLevel(playerid) < 1) return 1;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(GetPlayerSecretLevel(to_player) >= 1)
		return SendClientMessage(playerid, 0xCECECEFF, "У игрока есть привелегия скрытность");

	if(GetPlayerSpectateData(playerid, S_PLAYER) == -1)
	{
		new Float: x, Float: y, Float: z, Float: a, skin = GetPlayerSkin(playerid);
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		SetPlayerSpectateData(playerid, S_START_POS_X, _:x);
		SetPlayerSpectateData(playerid, S_START_POS_Y, _:y);
		SetPlayerSpectateData(playerid, S_START_POS_Z, _:z);
		SetPlayerSpectateData(playerid, S_START_ANGLE, _:a);
		SetPlayerSpectateData(playerid, S_START_INTERIOR, GetPlayerInterior(playerid));
		SetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));
		SetSpawnInfo(playerid, 0, skin, x, y, z, a, 0, 0, 0, 0, 0, 0);
	}

	StartSpectateWerton(playerid, to_player);

	new fmt_text[90];
	if(GetPlayerAdminLevel(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] следит за %s[%d]", GetPlayerName(playerid), playerid, GetPlayerName(to_player), to_player);
		SendClientMessageToAll(0x999999FF, fmt_text);
	}

	format(fmt_text, sizeof fmt_text, "Следит за %s[acc:%d]", GetPlayerName(to_player), GetPlayerAccountID(to_player));
	printf("LOG: %s", fmt_text);
	return 1;
}

stock StartSpectateWerton(playerid, for_player)
{
	if(GetPlayerAdminLevel(playerid) < 1) return 1;

	SetPlayerSpectateData(playerid, S_PLAYER, for_player);
	SetPlayerInterior(playerid, GetPlayerInterior(for_player));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(for_player));
	TogglePlayerSpectating(playerid, true);

    SelectTextDraw(playerid, -1);
    for(new t;t < sizeof wertonsp_TD;t++)
	{
		TextDrawShowForPlayer(playerid, wertonsp_TD[t]);
	}
    
    UpdateSpecInfo(playerid, for_player);

	if(IsPlayerInAnyVehicle(for_player))
	{
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(for_player));
	}
	else PlayerSpectatePlayer(playerid, for_player);
	
	TogglePlayerControllable(playerid, true);
}

stock StopSpectateWerton(playerid)
{
	if(GetPlayerAdminLevel(playerid) < 1) return 1;
	if(GetPlayerSpectateData(playerid, S_PLAYER) == -1) return 1;

	TogglePlayerSpectating(playerid, false);
	SetPlayerSpectateData(playerid, S_PLAYER, -1);

	SetPlayerPos(playerid, Float:GetPlayerSpectateData(playerid, S_START_POS_X), Float:GetPlayerSpectateData(playerid, S_START_POS_Y), Float:GetPlayerSpectateData(playerid, S_START_POS_Z));
	SetPlayerFacingAngle(playerid, Float:GetPlayerSpectateData(playerid, S_START_ANGLE));
	SetPlayerInterior(playerid, GetPlayerSpectateData(playerid, S_START_INTERIOR));
	SetPlayerVirtualWorld(playerid, GetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD));
	
	for(new t;t < sizeof wertonsp_TD;t++)
	{
	    TextDrawHideForPlayer(playerid, wertonsp_TD[t]);
	}
	for(new t;t < 8;t++)
	{
        PlayerTextDrawHide(playerid, wertonsp_PTD[playerid][t]);
    }
	CancelSelectTextDraw(playerid);
	TogglePlayerControllable(playerid, true);
	return 1;
}

stock NextSpecNew(playerid, splayerid)
{
	new to_player = splayerid + 1;
	if(GetPlayerAdminLevel(playerid) < 1) return 1;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(GetPlayerSecretLevel(to_player) >= 1)
		return SendClientMessage(playerid, 0xCECECEFF, "У игрока есть привелегия скрытность");

	if(GetPlayerSpectateData(playerid, S_PLAYER) == -1)
	{
		new Float: x, Float: y, Float: z, Float: a, skin = GetPlayerSkin(playerid);
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		SetPlayerSpectateData(playerid, S_START_POS_X, _:x);
		SetPlayerSpectateData(playerid, S_START_POS_Y, _:y);
		SetPlayerSpectateData(playerid, S_START_POS_Z, _:z);
		SetPlayerSpectateData(playerid, S_START_ANGLE, _:a);
		SetPlayerSpectateData(playerid, S_START_INTERIOR, GetPlayerInterior(playerid));
		SetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));
		SetSpawnInfo(playerid, 0, skin, x, y, z, a, 0, 0, 0, 0, 0, 0);
	}

	StartSpectateWerton(playerid, to_player);

	new fmt_text[90];
	if(GetPlayerAdminLevel(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] следит за %s[%d]", GetPlayerName(playerid), playerid, GetPlayerName(to_player), to_player);
		SendClientMessageToAll(0x999999FF, fmt_text);
	}

	format(fmt_text, sizeof fmt_text, "Следит за %s[acc:%d]", GetPlayerName(to_player), GetPlayerAccountID(to_player));
	printf("LOG: %s", fmt_text);
	return 1;
}

stock PrevSpecNew(playerid, splayerid)
{
	new to_player = splayerid - 1;
	if(splayerid != 0)
	{
	if(GetPlayerAdminLevel(playerid) < 1) return 1;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(GetPlayerSecretLevel(to_player) >= 1)
		return SendClientMessage(playerid, 0xCECECEFF, "У игрока есть привелегия скрытность");

	if(GetPlayerSpectateData(playerid, S_PLAYER) == -1)
	{
		new Float: x, Float: y, Float: z, Float: a, skin = GetPlayerSkin(playerid);
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		SetPlayerSpectateData(playerid, S_START_POS_X, _:x);
		SetPlayerSpectateData(playerid, S_START_POS_Y, _:y);
		SetPlayerSpectateData(playerid, S_START_POS_Z, _:z);
		SetPlayerSpectateData(playerid, S_START_ANGLE, _:a);
		SetPlayerSpectateData(playerid, S_START_INTERIOR, GetPlayerInterior(playerid));
		SetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));
		SetSpawnInfo(playerid, 0, skin, x, y, z, a, 0, 0, 0, 0, 0, 0);
	}

	StartSpectateWerton(playerid, to_player);

	new fmt_text[90];
	if(GetPlayerAdminLevel(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] следит за %s[%d]", GetPlayerName(playerid), playerid, GetPlayerName(to_player), to_player);
		SendClientMessageToAll(0x999999FF, fmt_text);
	}

	format(fmt_text, sizeof fmt_text, "Следит за %s[acc:%d]", GetPlayerName(to_player), GetPlayerAccountID(to_player));
	printf("LOG: %s", fmt_text);
	return 1;
	}
	else
	{
		return NextSpecNew(playerid, splayerid);
	}
}

forward UpdateSpecInfo(playerid, for_player);
public UpdateSpecInfo(playerid, for_player)
{
    new spec_name[28], spec_ping[28], spec_health[28], spec_armor[28], spec_money[28], spec_level[28];
    new Float: health, Float: armour;
    
    GetPlayerHealth(for_player, health);
    GetPlayerArmour(for_player, armour);
    
    format(spec_name, sizeof spec_name, "[%d]_%s", for_player, GetPlayerName(for_player));
    PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][0], spec_name);
    
    format(spec_ping, sizeof spec_ping, "%d", GetPlayerPing(for_player));
    PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][1], spec_ping);

    format(spec_health, sizeof spec_health, "%.0f", health);
    PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][4], spec_health);
    
    format(spec_armor, sizeof spec_armor, "%.0f", armour);
    PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][5], spec_armor);
    
    format(spec_money, sizeof spec_money, "%d", GetPlayerMoney(for_player));
    PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][6], spec_money);
    
    format(spec_level, sizeof spec_level, "%d", GetPlayerScore(for_player));
    PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][7], spec_level);
    
    for(new t; t < 8; t++)
    {
        PlayerTextDrawShow(playerid, wertonsp_PTD[playerid][t]);
    }
}

stock IsPlayerLogged(playerid) return true;
stock GetPlayerAdminLevel(playerid) return IsPlayerAdmin(playerid) ? 1 : 0;
stock GetPlayerSecretLevel(playerid) return 0;
stock GetPlayerAccountID(playerid) return playerid;

stock isnull(const string[])
{
    return string[0] == 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/sp", true, 3))
    {
        CMD:sp(playerid, cmdtext[4]);
        return 1;
    }
    if(!strcmp(cmdtext, "/spoff", true, 6))
    {
        CMD:spoff(playerid, cmdtext[7]);
        return 1;
    }
    return 0;
}

CMD:sp(playerid, params[])
{
    if(GetPlayerAdminLevel(playerid) < 1) return SendClientMessage(playerid, 0xFF0000FF, "У вас нет доступа к этой команде");
    
    if(isnull(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sp [id игрока]");
    
    new to_player = strval(params);
    if(to_player < 0 || to_player >= MAX_PLAYERS) return SendClientMessage(playerid, 0xFF0000FF, "Неверный ID игрока");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0xFF0000FF, "Такого игрока нет");

    if(GetPlayerSecretLevel(to_player) >= 1)
        return SendClientMessage(playerid, 0xCECECEFF, "У игрока есть привелегия скрытность");

    if(GetPlayerSpectateData(playerid, S_PLAYER) == -1)
    {
        new Float: x, Float: y, Float: z, Float: a, skin = GetPlayerSkin(playerid);
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);

        SetPlayerSpectateData(playerid, S_START_POS_X, _:x);
        SetPlayerSpectateData(playerid, S_START_POS_Y, _:y);
        SetPlayerSpectateData(playerid, S_START_POS_Z, _:z);
        SetPlayerSpectateData(playerid, S_START_ANGLE, _:a);
        SetPlayerSpectateData(playerid, S_START_INTERIOR, GetPlayerInterior(playerid));
        SetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));
        SetSpawnInfo(playerid, 0, skin, x, y, z, a, 0, 0, 0, 0, 0, 0);
    }

    StartSpectateWerton(playerid, to_player);
    new fmt_text[80];
    format(fmt_text, sizeof fmt_text, "[A] %s[%d] следит за %s[%d]", GetPlayerName(playerid), playerid, GetPlayerName(to_player), to_player);
    SendClientMessageToAll(0x999999FF, fmt_text);
    SendClientMessage(playerid, 0x999999FF, "[A] Используйте команду \"/spoff\", чтобы прекратить слежку за игроком.");
    return 1;
}

CMD:spoff(playerid, params[])
{
    if(GetPlayerAdminLevel(playerid) < 1) return SendClientMessage(playerid, 0xFF0000FF, "У вас нет доступа к этой команде");
    
    if(GetPlayerSpectateData(playerid, S_PLAYER) != -1)
    {
        StopSpectateWerton(playerid);
        SendClientMessage(playerid, 0x999999FF, "[A] Вы прекратили слежку за игроком.");
    }
    return 1;
}
