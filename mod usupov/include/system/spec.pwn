new Text:wertonsp_TD[17];
new PlayerText:wertonsp_PTD[MAX_PLAYERS][8]; 
new UpdateSpec[MAX_PLAYERS];

public OnGameModeInit()
{
    printf("[WERTON_SYSTEM] Система слежки загружена");
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
    
    // пинг
    wertonsp_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 610.4500, 87.0000, "48");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][1], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][1], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][1], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][1], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][1], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][1], 0);
    
    // потери
    wertonsp_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 610.4500, 107.5500, "0");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][2], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][2], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][2], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][2], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][2], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][2], 0);
    
    // скорость
    wertonsp_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 610.4500, 119.0000, "2");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][3], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][3], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][3], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][3], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][3], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][3], 0);
    
    // здоровье
    wertonsp_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 610.4500, 136.0000, "100");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][4], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][4], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][4], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][4], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][4], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][4], 0);
    
    // броня
    wertonsp_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 610.4500, 150.0000, "0");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][5], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][5], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][5], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][5], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][5], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][5], 0);
    
    // баланс
    wertonsp_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 610.4500, 168.0000, "1000000");
    PlayerTextDrawLetterSize(playerid, wertonsp_PTD[playerid][6], 0.255000, 0.855000);
    PlayerTextDrawAlignment(playerid, wertonsp_PTD[playerid][6], 3);
    PlayerTextDrawColor(playerid, wertonsp_PTD[playerid][6], -1);
    PlayerTextDrawSetOutline(playerid, wertonsp_PTD[playerid][6], 1);
    PlayerTextDrawBackgroundColor(playerid, wertonsp_PTD[playerid][6], 0);
    PlayerTextDrawFont(playerid, wertonsp_PTD[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, wertonsp_PTD[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, wertonsp_PTD[playerid][6], 0);
    
    // уровень
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
    wertonsp_TD[0] = TextDrawCreate(-2.2000, 0.0000, "txd:sp_main"); // пусто 
    TextDrawTextSize(wertonsp_TD[0], 644.0000, 448.0000); 
    TextDrawAlignment(wertonsp_TD[0], 1); 
    TextDrawColor(wertonsp_TD[0], -1); 
    TextDrawBackgroundColor(wertonsp_TD[0], 255); 
    TextDrawFont(wertonsp_TD[0], 4); 
    TextDrawSetProportional(wertonsp_TD[0], 0); 
    TextDrawSetShadow(wertonsp_TD[0], 0); 

    //в лево
    wertonsp_TD[1] = TextDrawCreate(108.0000, 394.0000, "txd:transparent"); // пусто
    TextDrawTextSize(wertonsp_TD[1], 42.0000, 32.0000);
    TextDrawAlignment(wertonsp_TD[1], 1);
    TextDrawColor(wertonsp_TD[1], -1);
    TextDrawBackgroundColor(wertonsp_TD[1], 255);
    TextDrawFont(wertonsp_TD[1], 4);
    TextDrawSetProportional(wertonsp_TD[1], 0);
    TextDrawSetShadow(wertonsp_TD[1], 0);
    TextDrawSetSelectable(wertonsp_TD[1], true);
    
    //в право
    wertonsp_TD[2] = TextDrawCreate(480.0000, 394.0000, "txd:transparent"); // пусто
    TextDrawTextSize(wertonsp_TD[2], 42.0000, 32.0000);
    TextDrawAlignment(wertonsp_TD[2], 1);
    TextDrawColor(wertonsp_TD[2], -1);
    TextDrawBackgroundColor(wertonsp_TD[2], 255);
    TextDrawFont(wertonsp_TD[2], 4);
    TextDrawSetProportional(wertonsp_TD[2], 0);
    TextDrawSetShadow(wertonsp_TD[2], 0);
    TextDrawSetSelectable(wertonsp_TD[2], true);
    
    //выход
    wertonsp_TD[3] = TextDrawCreate(374.0000, 338.0000, "txd:transparent"); // пусто
    TextDrawTextSize(wertonsp_TD[3], 54.0000, 37.0000);
    TextDrawAlignment(wertonsp_TD[3], 1);
    TextDrawColor(wertonsp_TD[3], -1);
    TextDrawBackgroundColor(wertonsp_TD[3], 255);
    TextDrawFont(wertonsp_TD[3], 4);
    TextDrawSetProportional(wertonsp_TD[3], 0);
    TextDrawSetShadow(wertonsp_TD[3], 0);
    TextDrawSetSelectable(wertonsp_TD[3], true);
    
    //обновить
    wertonsp_TD[4] = TextDrawCreate(212.0000, 335.0000, "txd:transparent"); // пусто
    TextDrawTextSize(wertonsp_TD[4], 31.0000, 41.0000);
    TextDrawAlignment(wertonsp_TD[4], 1);
    TextDrawColor(wertonsp_TD[4], -1);
    TextDrawBackgroundColor(wertonsp_TD[4], 255);
    TextDrawFont(wertonsp_TD[4], 4);
    TextDrawSetProportional(wertonsp_TD[4], 0);
    TextDrawSetShadow(wertonsp_TD[4], 0);
    TextDrawSetSelectable(wertonsp_TD[4], true);
	
	wertonsp_TD[5] = TextDrawCreate(152.5556, 386.9643, "txd:transparent"); // kick
TextDrawTextSize(wertonsp_TD[5], 55.0000, 47.0000);
TextDrawAlignment(wertonsp_TD[5], 1);
TextDrawColor(wertonsp_TD[5], -1);
TextDrawBackgroundColor(wertonsp_TD[5], 255);
TextDrawFont(wertonsp_TD[5], 4);
TextDrawSetProportional(wertonsp_TD[5], 0);
TextDrawSetShadow(wertonsp_TD[5], 0);
TextDrawSetSelectable(wertonsp_TD[5], true);

wertonsp_TD[6] = TextDrawCreate(207.2222, 386.9644, "txd:transparent"); // mute
TextDrawTextSize(wertonsp_TD[6], 54.0000, 47.0000);
TextDrawAlignment(wertonsp_TD[6], 1);
TextDrawColor(wertonsp_TD[6], -1);
TextDrawBackgroundColor(wertonsp_TD[6], 255);
TextDrawFont(wertonsp_TD[6], 4);
TextDrawSetProportional(wertonsp_TD[6], 0);
TextDrawSetShadow(wertonsp_TD[6], 0);
TextDrawSetSelectable(wertonsp_TD[6], true);

wertonsp_TD[7] = TextDrawCreate(261.0000, 386.9643, "txd:transparent"); // jail
TextDrawTextSize(wertonsp_TD[7], 54.0000, 47.0000);
TextDrawAlignment(wertonsp_TD[7], 1);
TextDrawColor(wertonsp_TD[7], -1);
TextDrawBackgroundColor(wertonsp_TD[7], 255);
TextDrawFont(wertonsp_TD[7], 4);
TextDrawSetProportional(wertonsp_TD[7], 0);
TextDrawSetShadow(wertonsp_TD[7], 0);
TextDrawSetSelectable(wertonsp_TD[7], true);

wertonsp_TD[8] = TextDrawCreate(314.7777, 386.9644, "txd:transparent"); // warn
TextDrawTextSize(wertonsp_TD[8], 54.0000, 47.0000);
TextDrawAlignment(wertonsp_TD[8], 1);
TextDrawColor(wertonsp_TD[8], -1);
TextDrawBackgroundColor(wertonsp_TD[8], 255);
TextDrawFont(wertonsp_TD[8], 4);
TextDrawSetProportional(wertonsp_TD[8], 0);
TextDrawSetShadow(wertonsp_TD[8], 0);
TextDrawSetSelectable(wertonsp_TD[8], true);

wertonsp_TD[9] = TextDrawCreate(368.5553, 386.9644, "txd:transparent"); // slap
TextDrawTextSize(wertonsp_TD[9], 53.0000, 47.0000);
TextDrawAlignment(wertonsp_TD[9], 1);
TextDrawColor(wertonsp_TD[9], -1);
TextDrawBackgroundColor(wertonsp_TD[9], 255);
TextDrawFont(wertonsp_TD[9], 4);
TextDrawSetProportional(wertonsp_TD[9], 0);
TextDrawSetShadow(wertonsp_TD[9], 0);
TextDrawSetSelectable(wertonsp_TD[9], true);

wertonsp_TD[10] = TextDrawCreate(421.4442, 386.9644, "txd:transparent"); // ban
TextDrawTextSize(wertonsp_TD[10], 53.0000, 47.0000);
TextDrawAlignment(wertonsp_TD[10], 1);
TextDrawColor(wertonsp_TD[10], -1);
TextDrawBackgroundColor(wertonsp_TD[10], 255);
TextDrawFont(wertonsp_TD[10], 4);
TextDrawSetProportional(wertonsp_TD[10], 0);
TextDrawSetShadow(wertonsp_TD[10], 0);
TextDrawSetSelectable(wertonsp_TD[10], true);

wertonsp_TD[11] = TextDrawCreate(517.4443, 205.7733, "txd:transparent"); //      статистика     
TextDrawTextSize(wertonsp_TD[11], 84.0000, 25.0000);
TextDrawAlignment(wertonsp_TD[11], 1);
TextDrawColor(wertonsp_TD[11], -1);
TextDrawBackgroundColor(wertonsp_TD[11], 255);
TextDrawFont(wertonsp_TD[11], 4);
TextDrawSetProportional(wertonsp_TD[11], 0);
TextDrawSetShadow(wertonsp_TD[11], 0);
TextDrawSetSelectable(wertonsp_TD[11], true);

wertonsp_TD[12] = TextDrawCreate(516.5553, 252.0667, "txd:transparent"); //         подать форму   
TextDrawTextSize(wertonsp_TD[12], 83.0000, 30.0000);
TextDrawAlignment(wertonsp_TD[12], 1);
TextDrawColor(wertonsp_TD[12], -1);
TextDrawBackgroundColor(wertonsp_TD[12], 255);
TextDrawFont(wertonsp_TD[12], 4);
TextDrawSetProportional(wertonsp_TD[12], 0);
TextDrawSetShadow(wertonsp_TD[12], 0);
TextDrawSetSelectable(wertonsp_TD[12], true);
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
         callcmd::spoff(playerid, "");
    }
// Обработчик для wertonsp_TD[7] - джаил
if(clickedid == wertonsp_TD[7])
{
    new targetid = GetPlayerSpectateData(playerid, S_PLAYER);
    
    if(!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
        return SendClientMessage(playerid, -1, "{FF0000}Ошибка: {FFFFFF}Не выбран игрок для наказания или игрок отключился.");
    
    if(!IsPlayerLogged(targetid))
        return SendClientMessage(playerid, -1, "{FF0000}Ошибка: {FFFFFF}Игрок не авторизован.");
    SetPVarInt(playerid, "punish_target", targetid);
    
    new dialogStr[1024];
    
    format(dialogStr, sizeof(dialogStr),
        "1\tNonRP поведение\tПосадить в деморган за NonRP поведение\n"\
        "2\tNonRP вождение\tПосадить в деморган за NonRP вождение\n"\
        "3\tDrive By (DB)\tПосадить в деморган за Drive By\n"\
        "4\tRevenge Kill (RK)\tПосадить в деморган за Revenge Kill\n"\
        "5\tSpawn Kill (SK)\tПосадить в деморган за Spawn Kill\n"\
        "6\tTeam Kill (TK)\tПосадить в деморган за Team Kill\n"\
        "7\tPower Gaming (PG)\tПосадить в деморган за Power Gaming\n"\
        "8\tDeath Match (DM)\tПосадить в деморган за Death Match\n"\
        "9\tNonRP вождение фура/инкас\tПосадить в деморган за NonRP вождение фура/инкас"
    );

    new title[128];
    format(title, sizeof(title), "{CA5757}"SERVER_NAME" {FFFFFF}| Выбор наказания для %s", GetPlayerNameEx(targetid));
    
    Dialog(playerid, DIALOG_PUNISH_SELECT, DIALOG_STYLE_TABLIST_HEADERS,
        title,
        dialogStr,
        "Выбрать", "Закрыть"
    );
    return 1;
}
    
    // Подать форму
    if(clickedid == wertonsp_TD[12])
    {
        new targetid = GetPlayerSpectateData(playerid, S_PLAYER);
        if(IsPlayerConnected(targetid)) 
        {
            new param[12];
            format(param, sizeof(param), "%d", targetid);
            SendClientMessage(playerid, -1, "af добавить над");
        }
        return 1;
    }
    
    // Slap (вверх/вниз)
    if(clickedid == wertonsp_TD[9])
    {
        new targetid = GetPlayerSpectateData(playerid, S_PLAYER);
        if(IsPlayerConnected(targetid))
        {
            Dialog(playerid, DIALOG_SLAP, DIALOG_STYLE_LIST,
                "Выбор действия",
                "Подкинуть вверх\nОпустить вниз",
                "Выбрать", "Отмена");
        }
        return 1;
    }
if(clickedid == wertonsp_TD[6])
{
    new targetid = GetPlayerSpectateData(playerid, S_PLAYER);
    
    if(!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
        return SendClientMessage(playerid, -1, "{FF0000}Ошибка: {FFFFFF}Не выбран игрок для мута или игрок отключился.");
    
    if(!IsPlayerLogged(targetid))
        return SendClientMessage(playerid, -1, "{FF0000}Ошибка: {FFFFFF}Игрок не авторизован.");
    
    // Сохраняем ID игрока для использования в диалоге
    SetPVarInt(playerid, "mute_target", targetid);
    
    new dialogStr[1024];
    
    format(dialogStr, sizeof(dialogStr),
        "1\tОскорбление администрации\tВыдать мут за оскорбление администрации\n"\
        "2\tУпоминание родных\tВыдать мут за упоминание родных\n"\
        "3\tMeta Gaming (MG)\tВыдать мут за Meta Gaming\n"\
        "4\tCapsLock\tВыдать мут за CapsLock\n"\
        "5\tРеклама в гос.орг\tВыдать мут за объявления на территории гос. орг.\n"\
        "6\tОскорбление\tВыдать мут за оскорбление\n"\
        "7\tФлуд\tВыдать мут за флуд\n"\
        "8\tМат в VIP чат\tВыдать мут за мат в VIP чат"
    );

    new title[128];
    format(title, sizeof(title), "{CA5757}"SERVER_NAME" {FFFFFF}| Выбор мута для %s", GetPlayerNameEx(targetid));
    
    Dialog(playerid, DIALOG_MUTE_SELECT, DIALOG_STYLE_TABLIST_HEADERS,
        title,
        dialogStr,
        "Выбрать", "Закрыть"
    );
    return 1;
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
	if(GetPlayerAdminEx(playerid) < 1) return 1;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(GetPlayerSecretEx(to_player) >= 1)
		return SendClientMessage(playerid, 0xCECECEFF, "У игрока есть привелегия скрытность");

	if(GetPlayerSpectateData(playerid, S_PLAYER) == -1)
	{
		new Float: x,
			Float: y,
			Float: z,
			Float: a,
			skin = GetPlayerSkin(playerid);

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		SetPlayerSpectateData(playerid, S_START_POS_X, x);
		SetPlayerSpectateData(playerid, S_START_POS_Y, y);
		SetPlayerSpectateData(playerid, S_START_POS_Z, z);
		SetPlayerSpectateData(playerid, S_START_ANGLE, a);

		SetPlayerSpectateData(playerid, S_START_INTERIOR, GetPlayerInterior(playerid));
		SetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));

		SetSpawnInfo(playerid, 0, skin, x, y, z, a, 0, 0, 0, 0, 0, 0);
	}

	StartSpectateWerton(playerid, to_player);

	new fmt_text[90];

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] следит за %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
		SendMessageToAdmins(fmt_text, 0x999999FF);
        
	}

	format(fmt_text, sizeof fmt_text, "Следит за %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);
	new playername[100];
	format(playername, sizeof playername, "%s", GetPlayerNameEx(to_player));

	return 1;
}

stock StartSpectateWerton(playerid, for_player)
{
	if(GetPlayerAdminEx(playerid) < 1) return 1;

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
	if(GetPlayerAdminEx(playerid) < 1) return 1;
	if(GetPlayerSpectateData(playerid, S_PLAYER) == -1) return 1;

	TogglePlayerSpectating(playerid, false);

	SetPlayerSpectateData(playerid, S_PLAYER, -1);

	SetPlayerPosEx
	(
		playerid,
		GetPlayerSpectateData(playerid, S_START_POS_X),
		GetPlayerSpectateData(playerid, S_START_POS_Y),
		GetPlayerSpectateData(playerid, S_START_POS_Z),
		GetPlayerSpectateData(playerid, S_START_ANGLE),
		GetPlayerSpectateData(playerid, S_START_INTERIOR),
		GetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD)
	);
	
	for(new t;t < sizeof wertonsp_TD;t++)
	{
	    TextDrawHideForPlayer(playerid, wertonsp_TD[t]);
	}
	for(new t;t < sizeof wertonsp_TD;t++)
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
	if(GetPlayerAdminEx(playerid) < 1) return 1;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(GetPlayerSecretEx(to_player) >= 1)
		return SendClientMessage(playerid, 0xCECECEFF, "У игрока есть привелегия скрытность");

	if(GetPlayerSpectateData(playerid, S_PLAYER) == -1)
	{
		new Float: x,
			Float: y,
			Float: z,
			Float: a,
			skin = GetPlayerSkin(playerid);

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		SetPlayerSpectateData(playerid, S_START_POS_X, x);
		SetPlayerSpectateData(playerid, S_START_POS_Y, y);
		SetPlayerSpectateData(playerid, S_START_POS_Z, z);
		SetPlayerSpectateData(playerid, S_START_ANGLE, a);

		SetPlayerSpectateData(playerid, S_START_INTERIOR, GetPlayerInterior(playerid));
		SetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));

		SetSpawnInfo(playerid, 0, skin, x, y, z, a, 0, 0, 0, 0, 0, 0);
	}

	StartSpectateWerton(playerid, to_player);

	new fmt_text[90];

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] следит за %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	format(fmt_text, sizeof fmt_text, "Следит за %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);
	new playername[100];
	format(playername, sizeof playername, "%s", GetPlayerNameEx(to_player));

	return 1;
}

stock PrevSpecNew(playerid, splayerid)
{
	new to_player = splayerid - 1;
	if(splayerid != 0)
	{
	if(GetPlayerAdminEx(playerid) < 1) return 1;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(GetPlayerSecretEx(to_player) >= 1)
		return SendClientMessage(playerid, 0xCECECEFF, "У игрока есть привелегия скрытность");

	if(GetPlayerSpectateData(playerid, S_PLAYER) == -1)
	{
		new Float: x,
			Float: y,
			Float: z,
			Float: a,
			skin = GetPlayerSkin(playerid);

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		SetPlayerSpectateData(playerid, S_START_POS_X, x);
		SetPlayerSpectateData(playerid, S_START_POS_Y, y);
		SetPlayerSpectateData(playerid, S_START_POS_Z, z);
		SetPlayerSpectateData(playerid, S_START_ANGLE, a);

		SetPlayerSpectateData(playerid, S_START_INTERIOR, GetPlayerInterior(playerid));
		SetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));

		SetSpawnInfo(playerid, 0, skin, x, y, z, a, 0, 0, 0, 0, 0, 0);
	}

	StartSpectateWerton(playerid, to_player);

	new fmt_text[90];

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] следит за %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	format(fmt_text, sizeof fmt_text, "Следит за %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);
	new playername[100];
	format(playername, sizeof playername, "%s", GetPlayerNameEx(to_player));

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
    new spec_name[28];

    new spec_ping[28];
    
    new spec_speed[28];
    
    new Float: health;
    GetPlayerHealth(for_player, health);
    new spec_health[28];
    
    new Float: armour;
    GetPlayerArmour(for_player, armour);
    new spec_armor[28];
    
    new spec_money[28];
    
    new spec_level[28];
    
    format(spec_name, sizeof spec_name, "[%d]_%s", for_player, GetPlayerNameEx(for_player));
    PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][0], spec_name);
    
    format(spec_ping, sizeof spec_ping, "%d", GetPlayerPing(for_player));
    PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][1], spec_ping);

    //format(spec_speed, sizeof spec_speed, "%d", GetPlayerPing(for_player));
    //PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][3], spec_speed);
    
    format(spec_health, sizeof spec_health, "%f", health);
    PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][4], spec_health);
    
    format(spec_armor, sizeof spec_armor, "%f", armour);
    PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][5], spec_armor);
    
    format(spec_money, sizeof spec_money, "%d", GetPlayerMoneyEx(for_player));
    PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][6], spec_money);
    
    format(spec_level, sizeof spec_level, "%d", GetPlayerLevel(for_player));
    PlayerTextDrawSetString(playerid, wertonsp_PTD[playerid][7], spec_level);
    
    for(new t; t < sizeof wertonsp_PTD; t++)
    {
        if (t < 8)
        {
            PlayerTextDrawShow(playerid, wertonsp_PTD[playerid][t]);
        }
    }
}