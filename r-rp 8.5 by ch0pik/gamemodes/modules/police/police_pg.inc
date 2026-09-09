#if defined _police_pg_included
    #endinput
#endif
#define _police_pg_included

enum E_PLAYER_PURSUIT_STRUCT
{
    bool: E_ACTIVE,
    E_TARGET_ID,
}
new player_pursuit[MAX_PLAYERS][E_PLAYER_PURSUIT_STRUCT];

CMD:pg(playerid, params[])
{
    if(GetPlayerTeamEx(playerid) != TEAM_MVD) return SendClientMessage(playerid, 0xCECECEFF, "Вам не доступна данная функция");
    if(player_pursuit[playerid][E_ACTIVE] == false)
    {
        extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "{FFAF00}Используйте:{FFFFFF} /pg [ID игрока]");
        if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
        if(!IsPlayerInRangeOfPlayer(playerid, to_player, 30.0)) return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");
        if(GetPlayerSuspect(to_player) == 0) return SendClientMessage(playerid, 0xCECECEFF, "* Данный человек не находится в розыске");
        player_pursuit[to_player][E_ACTIVE] = true;
        player_pursuit[playerid][E_ACTIVE] = true;
        player_pursuit[playerid][E_TARGET_ID] = to_player;
        player_pursuit[to_player][E_TARGET_ID] = playerid;
        SCMF(playerid, 0xe57738FF, "[Полицейская погоня] {FFFFFF}Вы начали погоню за игроком %s", GetPlayerNameEx(to_player));
        SCMF(to_player, 0xe57738FF, "[Полицейская погоня] {FFFFFF}Игрок %s начал за вами погоню", GetPlayerNameEx(playerid));
        new Float: x, Float: y, Float: z;
        GetPlayerPos(to_player, x, y, z);
        SetPlayerRaceCheckpoint
        (
            playerid,
            0,
            x, y, z,
            0.0, 0.0, 0.0,
            10.0,
            RCP_ACTION_TYPE_POLICE
        );
    }
    else if(player_pursuit[playerid][E_ACTIVE] == true)
    {
        STRING_GLOBAL[0] = EOS;
        format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Вы действительно хотите окончить погоню за %s", GetPlayerNameEx(player_pursuit[playerid][E_TARGET_ID]));
        Dialog
        (
            playerid, DIALOG_END_PURSUIT, DIALOG_STYLE_MSGBOX,
            "Подтверждение",
            STRING_GLOBAL,
            "Да", "Нет"
        );
    }
    return 1;
}

CMD:escort(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid) && GetPlayerAdminEx(playerid) == 0) return SendClientMessage(playerid, 0x999999FF, "Вы не работник правоохранительных органов");
	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "{FFAF00}Используйте:{FFFFFF} /escort [id игрока]");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");
    if(!GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0x999999FF, "Игрок не закован в наручники");
	if(GetPlayerData(to_player, P_ESCORTE))
	{
	    Action(playerid, "Ведёт человека за собой", _, false);
        SetPlayerData(to_player, P_ESCORTE, false);
        TogglePlayerControllable(to_player,true);
	}
	else
	{
	    Action(playerid, "Перестал вести человека за собой", _, false);
	    SetPlayerData(to_player, P_ESCORTE, true);
	    Escorte(to_player, playerid);
	}
	return 1;
}

forward Escorte(playerid, cufferid);
public Escorte(playerid, cufferid)
{
    if(!GetPlayerData(playerid, P_ESCORTE) || !IsPlayerConnected(cufferid)) return 1;
	new Float:x;
	new Float:y;
	new Float:distance;
	GetPlayerPos(cufferid, x, y, distance);
	if(distance <= 1.0 && GetPlayerData(playerid, P_ESCORTE) == true)
	{
		ClearAnimations(playerid, 1);
	    TogglePlayerControllable(playerid, 0);
	    SetPlayerLook(playerid, x, y);
	}
	else if(distance > 1.5)
	{
        TogglePlayerControllable(playerid, 1);
		ApplyAnimation(playerid, "ped",
			(distance < 3.0) ? ("WALK_player") : ("run_player"),
			4.1, 1, 1, 1, 0, 0, 1);
	    SetPlayerLook(playerid, x, y);
	}
	SetTimerEx("Escorte",500, 0,"dd", playerid, cufferid);
	return 1;
}

stock SetPlayerLook(playerid, Float:x, Float:y)
{
	new Float:pos_x;
	new Float:pos_y;
	new Float:angle;
	GetPlayerPos(playerid, pos_x, pos_y, angle);
	angle = atan2(y-pos_y, x-pos_x)-90.0;
	SetPlayerFacingAngle(playerid, angle);
	return 1;
}