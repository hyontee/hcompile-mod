//>> Файл: bykranin_src/core/callbacks/callbacks_01.inc  (1472 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnGameModeExit, OnPlayerRequestClass, OnPlayerRequestSpawn, jonny, ResetPlayerData, OnPlayerConnect, OnPlayerDisconnect
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).

// Определена позже в core/combat/combat_01.inc; вызывается из OnPlayerDeath ниже,
// поэтому нужен прототип (Pawn однопроходный, вызов раньше определения требует объявления).
stock ApplyPlayerHospitalSpawn(playerid);
public OnGameModeExit()
{
	StopCont();
	SaveRepository();
	DestroyAllSaleRealtyPickups();
    if (gstream) SvDeleteStream(gstream);
	mysql_close(mysql);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, FLOOD_RATE_INC, FLOOD_RATE_KICK);

	if(IsPlayerLogged(playerid))
	{
		//SetPlayerSpawnInit(playerid);
	}
	//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} OnPlayerRequestClass");
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    new now_tick = GetTickCount();
    new delta_tick = now_tick - g_spawn_request_block_tick[playerid];
    if(g_spawn_request_block_tick[playerid] != 0 && delta_tick >= 0 && delta_tick < 1000 && GetPVarInt(playerid, "spawn_select_once") == 1)
    {
        printf("[SPAWN][DUP_REQUEST] blocked player=%d dt=%d state=%d", playerid, delta_tick, GetPlayerState(playerid));
        return 0;
    }

	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, FLOOD_RATE_INC, FLOOD_RATE_KICK);

	if(!IsPlayerLogged(playerid))
	{
		new a_state = GetPlayerData(playerid, P_ACCOUNT_STATE);
		if(a_state != ACCOUNT_STATE_REG_SKIN)
		{
			new fmt_str[64];
			format(fmt_str, sizeof fmt_str, "{FFFFFF}Для игры на сервере Вы должны %s", a_state == ACCOUNT_STATE_REGISTER ? ("пройти регистрацию") : ("авторизироваться"));

			Dialog
			(
				playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
				"{FF6600}Ошибка",
				fmt_str,
				"Закрыть", ""
			);
			Kick:(playerid);
			SendClientMessage(playerid, 0xFF6600FF, fmt_str[8]);
		}
	}
					else if(IsPlayerLogged(playerid))
	{
		//SetPlayerSpawnInit(playerid);
		//SpawnPlayer(playerid);

//		SendClientMessage(playerid, 0xFFFF00FF, "Для смены внешности посетите любой магазин одежды");
	}

	return 1;
}

/*forward jonny();
public jonny()
{
	new string[50];
	new string2[50];
	
	format(string, sizeof(string), "X%d", Config[sDonPower]);
	format(string2, sizeof(string2), "%d/1000",Iter_Count(Player));

	for(new i=0;i<MAX_PLAYERS;i++)
	{
	    TextDrawSetString(logo_TD[1],string);
	    TextDrawSetString(logo_TD[2],string2);

	    TextDrawShowForPlayer(i,logo_TD[1]);
	    TextDrawShowForPlayer(i,logo_TD[2]);
	}
	return 1;
}*/
stock ResetPlayerData(playerid)
{
    for(new i = 0; i < sizeof(g_player[]); i++)
        g_player[playerid][i] = 0;

    for(new i = 0; i < sizeof(g_player_case[]); i++)
        g_player_case[playerid][i] = 0;

    for(new i = 0; i < sizeof(g_player_case_bonus[]); i++)
        g_player_case_bonus[playerid][i] = 0;

    for(new i = 0; i < sizeof(g_player_case_rewards[]); i++)
        g_player_case_rewards[playerid][i] = 0;

    for(new i = 0; i < sizeof(g_player_case_rewards_bonus[]); i++)
        g_player_case_rewards_bonus[playerid][i] = 0;
}

public OnPlayerConnect(playerid)
{
    if(g_teleport_freeze_timer[playerid]) KillTimer(g_teleport_freeze_timer[playerid]);
    g_teleport_freeze_timer[playerid] = 0;
    g_teleport_freeze_epoch[playerid]++;
    g_vehicle_stream_refresh_epoch[playerid]++;
    g_sync_update_tick[playerid] = GetTickCount();
    g_sync_passenger_tick[playerid] = 0;
    g_sync_passenger_bits[playerid] = 0;
    g_admin_badge[playerid] = Text3D:INVALID_3DTEXT_ID;
	SRAdmin_Reset(playerid);
	Larek_OnPlayerConnect(playerid);
	CoordsHud_OnConnect(playerid);
	g_stability_logo_online[playerid] = -1;
	g_stability_logo_power[playerid] = -1;
	g_stability_hint_tick[playerid] = GetTickCount() - 500;
	g_stability_visual_timer[playerid] = 0;
	g_tuning_additive_replay[playerid] = false;
	g_tuning_stream_watch_init[playerid] = false;
	g_tuning_stream_watch_interior[playerid] = 0;
	g_tuning_stream_watch_world[playerid] = 0;
	g_tuning_stream_watch_tick[playerid] = 0;
	g_tuning_stream_reconcile_tick[playerid] = 0;
	g_tuning_stream_watch_x[playerid] = 0.0;
	g_tuning_stream_watch_y[playerid] = 0.0;
	g_tuning_stream_watch_z[playerid] = 0.0;

	logo_PTD[playerid][0] = PlayerText:INVALID_TEXT_DRAW;
	logo_PTD[playerid][1] = PlayerText:INVALID_TEXT_DRAW;
	TC_OnPlayerConnect(playerid);
	Mine_ClearCarry(playerid);
	BRAuth_Reset(playerid);
	// Клиенту нужен номер поддерживаемой прошивки независимо от удалённой системы ключей.
	SendCarFirmware(playerid, 1030);
	new query[256];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(query, sizeof(query),
        "DELETE FROM accessories_players WHERE player_id = %d AND (bone = 0 OR slot = 0 OR scale <= 0.0)",
        GetPlayerAccountID(playerid)
    );

	if (gWhitelist)
    {
        // printf("[DEBUG] Вайтлист включён. Проверяется: %s", name);

        new query[128];
        mysql_format(mysql, query, sizeof(query), "SELECT * FROM whitelist WHERE name='%e'", name);
        mysql_tquery(mysql, query, "OnWhitelistCheck", "ii", playerid, g_BRAuthEpoch[playerid]);

        return 1; // ЖДЁМ ответ из MySQL
    }
	
    mysql_query(mysql, query, false);
	format(query, sizeof(query),
        "DELETE FROM accessories WHERE account_id = %d AND (bone = 0 OR modelid = 0)",
        GetPlayerAccountID(playerid)
    );
    mysql_query(mysql, query, false);
    ResetPlayerData(playerid);
    Market_ResetPlayer(playerid);
    Inv11Trade_ResetPlayer(playerid);
    gPlayerCountry[playerid] = -1;
    DeletePVar(playerid, PVAR_PLATE_BUY_ACCESS);
    DeletePVar(playerid, PVAR_PLATE_CONFIRM_SLOT);
    DeletePVar(playerid, PVAR_PLATE_CONFIRM_ITEM);
    DeletePVar(playerid, PVAR_PLATE_BC_PRICE);

    pInfo[playerid][BetUseCont] = 0;
    pInfo[playerid][BuyUseCont] = 0;
    pInfo[playerid][CasinoDiceBet] = 1000;
    pInfo[playerid][CasinoDiceTable] = 0;
    pInfo[playerid][CasinoDiceUiOpen] = false;
    pInfo[playerid][CasinoDealerJob] = false;
    pInfo[playerid][CasinoManagerJob] = false;
    pInfo[playerid][CasinoDiceBetPaid] = false;
    pInfo[playerid][CasinoDiceBetPaidTable] = 0;
    ContNewSystem_ResetPlayer(playerid);
    SetPlayerPos(playerid, 846.602600, 796.555847, 13.400512);
    SetPlayerFacingAngle(playerid, 69.896881);

    format(GetPlayerData(playerid, P_NAME), MAX_PLAYER_NAME, "%s", name);

    new query_ban[256];
    mysql_format(mysql, query_ban, sizeof(query_ban),
        "SELECT lb.admin_name, lb.reason, lb.ban_time, lb.unban_time FROM accounts a INNER JOIN listban lb ON lb.acc_id = a.id WHERE a.name='%e' LIMIT 1",
        name
    );
    new Cache:ban_result = mysql_query(mysql, query_ban, true);

    if(!mysql_errno() && cache_num_rows() > 0)
    {
        new unban_time = cache_get_field_content_int(0, "unban_time");
        if(unban_time <= 0 || unban_time > gettime())
        {
            new ban_time = cache_get_field_content_int(0, "ban_time");
            new ban_admin[24] = "";
            new ban_reason[128] = "";
            new fmt_ban[1600];
            new ban_date[32];
            new unban_date[32];
            new year, month, day, hour, minute, second;

            cache_get_field_content(0, "admin_name", ban_admin, mysql, sizeof(ban_admin));
            cache_get_field_content(0, "reason", ban_reason, mysql, sizeof(ban_reason));

            if(!strlen(ban_reason)) format(ban_reason, sizeof(ban_reason), "Не указана");
            if(!strlen(ban_admin)) format(ban_admin, sizeof(ban_admin), "Неизвестно");

            if(ban_time > 0)
            {
                timestamp_to_date(ban_time + 10800, year, month, day, hour, minute, second);
                format(ban_date, sizeof(ban_date), "%02d.%02d.%04d-%02d:%02d:%02d", day, month, year, hour, minute, second);
            }
            else format(ban_date, sizeof(ban_date), "Неизвестно");

            if(unban_time > 0)
            {
                timestamp_to_date(unban_time + 10800, year, month, day, hour, minute, second);
                format(unban_date, sizeof(unban_date), "%02d.%02d.%04d-%02d:%02d:%02d", day, month, year, hour, minute, second);
            }
            else format(unban_date, sizeof(unban_date), "никогда");

            format(fmt_ban, sizeof fmt_ban,
                "{FFFFFF}Ваш игровой аккаунт был заблокирован администрацией за нарушение\n"\
                "правил сервера. Вы не можете играть на своем аккаунте во время\n"\
                "действия блокировки.\n\n"\
                "{FFFF00}| {FFFFFF}Ваш никнейм: {FFFF00}%s\n"\
                "{FFFF00}| {FFFFFF}Никнейм администратора: {FFFF00}%s\n"\
                "{FFFF00}| {FFFFFF}Дата выданной блокировки: {FFFF00}%s\n"\
                "{FFFF00}| {FFFFFF}Дата разблокировки аккаунта: {FFFF00}%s\n"\
                "{FFFF00}| {FFFFFF}Причина блокировки: {FFFF00}%s\n\n"\
                "{FFFFFF}Вы не согласны с решением администратора и считаете, что наказание\n"\
                "было выдано несправедливо или ошибочно? В таком случае,\n"\
                "необходимо обратиться в специальный раздел с жалобой на\n"\
                "официальную тех.поддержку проекта: {FFFF00}@brbonussupport_bot{FFFFFF}.\n\n"\
                "Не забудьте прикрепить скриншот данного окна в жалобу.",
                name,
                ban_admin,
                ban_date,
                unban_date,
                ban_reason
            );

            cache_delete(ban_result);
            ShowPlayerDialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{E0584B}{SERVER_NAME} {FFFFFF}| Аккаунт заблокирован", fmt_ban, "Закрыть", "");
            SetTimerEx("KickBannedPlayer", 1500, false, "i", playerid);
            return 1;
        }
    }
    cache_delete(ban_result);

    PlayAuthorizationMusic(playerid);
	

    printf("[DEBUG] Инициализация игрока %d (%s)", playerid, name);
    InitPlayer(playerid);
    casino_dice_balance[playerid] = CreatePlayerTextDraw(playerid, 550.999755, 185.186706, "Баланс: 1000000");
    PlayerTextDrawLetterSize(playerid, casino_dice_balance[playerid], 0.357998, 1.405866);
    PlayerTextDrawAlignment(playerid, casino_dice_balance[playerid], 2);
    PlayerTextDrawColor(playerid, casino_dice_balance[playerid], -1);
    PlayerTextDrawSetShadow(playerid, casino_dice_balance[playerid], 0);
    PlayerTextDrawSetOutline(playerid, casino_dice_balance[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, casino_dice_balance[playerid], 51);
    PlayerTextDrawFont(playerid, casino_dice_balance[playerid], 1);
    PlayerTextDrawSetProportional(playerid, casino_dice_balance[playerid], 1);
    UpdateCasinoDiceBalancePTD(playerid);

    return 1;
}


public OnPlayerDisconnect(playerid, reason)
{
    if(Construction_IsWorking(playerid)) Construction_ResetPlayer(playerid, false);
    FsinFull_OnDisconnect(playerid);
    Blogger_OnPlayerDisconnect(playerid, reason);
    if(g_teleport_freeze_timer[playerid]) KillTimer(g_teleport_freeze_timer[playerid]);
    g_teleport_freeze_timer[playerid] = 0;
    g_teleport_freeze_epoch[playerid]++;
    g_vehicle_stream_refresh_epoch[playerid]++;
    GarageSys_OnPlayerDisconnect(playerid);
    FireExtVisual_Stop(playerid);
    DestroyAdminBadge(playerid);
    SRAdmin_Reset(playerid);
    Market_ResetPlayer(playerid);
    if(g_stability_visual_timer[playerid])
    {
        KillTimer(g_stability_visual_timer[playerid]);
        g_stability_visual_timer[playerid] = 0;
    }
	TC_OnPlayerDisconnect(playerid);
	Mine_ClearCarry(playerid);
    if(IsPlayerLogged(playerid))
    {
        new disconnect_reason[32];
        format(disconnect_reason, sizeof disconnect_reason, "reason=%d", reason);
        printf("[NET][DISCONNECT] player=%d account=%d name=%s reason=%d", playerid, GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), reason);
    }
    StopPlayerVehicleTurnSignal(playerid);
    StopPlayerStt(playerid);
    StopPlayerBegging(playerid);
	Larek_OnPlayerDisconnect(playerid);
    ContNewSystem_ResetPlayer(playerid);
    Inv11Trade_OnDisconnect(playerid);
    if(g_golod_timer[playerid] != 0)
    {
        KillTimer(g_golod_timer[playerid]);
        g_golod_timer[playerid] = 0;
    }

    DeletePVar(playerid, PVAR_PLATE_BUY_ACCESS);
    DeletePVar(playerid, PVAR_PLATE_CONFIRM_SLOT);
    DeletePVar(playerid, PVAR_PLATE_CONFIRM_ITEM);
    DeletePVar(playerid, PVAR_PLATE_BC_PRICE);
    new vehicleid = GetPVarInt(playerid, "ownable_vehicle_id");
    if(vehicleid != 0 && vehicleid != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(vehicleid);
        DeletePVar(playerid, "ownable_vehicle_id");
    }

    ReportGUI_OnPlayerDisconnect(playerid);

    // Удаляем весь транспорт, созданный этим админом через /veh (лимита нет)
    for(new v = 1; v < MAX_VEHICLES; v++)
    {
        if(g_AdminVehOwner[v] != playerid + 1) continue;
        g_AdminVehOwner[v] = 0;
        if(IsValidVehicle(v) && GetVehicleData(v, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_ADMIN_CAR)
            DestroyVehicle(v);
    }

    HideCasinoDiceUi(playerid);
    pInfo[playerid][CasinoDiceUiOpen] = false;
    pInfo[playerid][CasinoDealerJob] = false;
    pInfo[playerid][CasinoManagerJob] = false;
    pInfo[playerid][CasinoDiceBetPaid] = false;
    pInfo[playerid][CasinoDiceBetPaidTable] = 0;


    for(new idx = 0; idx < sizeof g_casino_table_dealer; idx++)
    {
        if(g_casino_table_dealer[idx] != playerid) continue;

        g_casino_table_dealer[idx] = INVALID_PLAYER_ID;
        if(g_casino_round_active[idx]) StopCasinoDiceRound(idx);
    }
    if(IsPlayerLogged(playerid))
    {
        SaveRecentSpawnState(playerid);
    }

    for(new idx = g_report_created - 1; idx >= 0; idx --)
	{
		if(GetReportData(idx, REP_CREATOR) != playerid) continue;

		DeleteReport(idx);
	}
	
    if (lstream[playerid])
    {
        SvDeleteStream(lstream[playerid]);
        lstream[playerid] = SV_NULL;
    }
    //SaveAdminPrefix(playerid);
    //vehidtun[playerid] = 0;
    launch[playerid] = 0;
    nitro[playerid] = 0;
    
    if(GetPVarType(playerid, "PlacedBB"))
    {
        //DestroyDynamicObject(GetPVarInt(playerid, "PlacedBB"));
    	DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "BBLabel"));
        if(GetPVarType(playerid, "BBArea"))
        {
            foreach(Player,i)
            {
                if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
                {
                    StopAudioStreamForPlayer(i);
                    SendClientMessage(i, COLOR_LIGHTBLUE, "Владелец бумбокса отключился от сервера.");
                }
            }
        }
    }

	new buffer = GetPlayerLastVehicle(playerid);
	
    /*if(DuelOffer[playerid] != -1)
	{
		new id = DuelOffer[playerid];
		SendClientMessage(id, -1, "Игрок вышел!");
		KillTimer(DuelTimer[playerid]);
		timeduel[playerid] = 11;
		DuelOffer[playerid] = -1;
		DuelOffer[id] = -1;
		DuelCash[id] = 0;
		DuelCash[playerid] = 0;
	}
*/
	if(buffer != INVALID_VEHICLE_ID)
	{
		if(GetVehicleData(buffer, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_DRIVING_SCH)
		{
			if(GetPlayerDrivingExamInfo(playerid, DE_POINTS) >= 9)
			{
				SetVehicleToRespawn(buffer);
			}
		}
	}
	if(IsPlayerInJob(playerid))
	{
		buffer = GetPlayerJobCar(playerid);
		if(buffer != INVALID_VEHICLE_ID)
		{
			SetVehicleToRespawn(buffer);
		}

		if(GetPlayerData(playerid, P_ORDER) != -1)
			SetOrderData(GetPlayerData(playerid, P_ORDER), O_USED, false);
	}
	KillEndJobTimer(playerid);

	buffer = GetPlayerData(playerid, P_FACTORY_USE_DESK);
	SetPlayerFactoryDeskUse(playerid, buffer, false);

	if(GetPlayerData(playerid, P_OCCUPIED_BED) != -1)
	{
		ClearMedBed(playerid, GetPlayerData(playerid, P_OCCUPIED_BED));
	}

	if(GetPlayerData(playerid, P_FRACTION_CAR) != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(GetPlayerData(playerid, P_FRACTION_CAR));
        SetPlayerData(playerid, P_FRACTION_CAR, INVALID_VEHICLE_ID);
    }

    if(GetPlayerData(playerid, P_BUY_CAR) != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(GetPlayerData(playerid, P_BUY_CAR));
        SetPlayerData(playerid, P_BUY_CAR, INVALID_VEHICLE_ID);
    }

	if(GetPlayerTeamEx(playerid) == TEAM_GOVERNMENT && IsValidDynamic3DTextLabel(GetPlayerData(playerid, P_ADVISOR_LABEL)))
	{
		DestroyDynamic3DTextLabel(GetPlayerData(playerid, P_ADVISOR_LABEL));
		SetPlayerData(playerid, P_ADVISOR_LABEL, Text3D: -1);
	}

	if(IsValidDynamic3DTextLabel(GetPlayerData(playerid, P_ADMIN_LABEL)))
	{
		DestroyDynamic3DTextLabel(GetPlayerData(playerid, P_ADMIN_LABEL));
		SetPlayerData(playerid, P_ADMIN_LABEL, Text3D: -1);
	}

	if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
	{
		if(SaveOwnableCar(GetPlayerOwnableCar(playerid)) != -1)
			UnloadPlayerOwnableCar(playerid, true);
	}

	if(GetPlayerRentCar(playerid) != INVALID_VEHICLE_ID)
	{
		SetVehicleToRespawn(GetPlayerRentCar(playerid));
	}
	if(GetPlayerData(playerid, P_RENT_BIKE) != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(GetPlayerData(playerid, P_RENT_BIKE));
        SetPlayerData(playerid,  P_RENT_BIKE, INVALID_VEHICLE_ID);
    }

	new fmt_text[95];

	if(GetPlayerData(playerid, P_CUFFED) && reason != 2)
	{
		new jail_time = (GetPlayerSuspect(playerid) * 5 + 30) * 60;

		SetPlayerData(playerid, P_JAIL, jail_time);
		UpdatePlayerDatabaseInt(playerid, "jail", jail_time);

		SetPlayerData(playerid, P_SUSPECT, 0);
		UpdatePlayerDatabaseInt(playerid, "suspect", 0);

		format(fmt_text, sizeof fmt_text, "%s выходит при аресте (+30 минут заключения)", GetPlayerNameEx(playerid));
		SendClientMessageToAll(0xFF5533FF, fmt_text);
	}

	for(new idx = g_advert_created - 1; idx >= 0; idx --)
	{
		if(GetAdvertData(idx, A_CREATOR) != playerid) continue;

		DeleteAdvert(idx);
	}

	if(!server_restart)
	{

		SetPlayerData(playerid, P_ADMIN_LOGGED, 0);
	}

	SavePlayerAccount(playerid);
	ClearPlayerInfo(playerid);

	UpdateSpectate(playerid, true);
	return 1;
}

// ====== [ {SERVER_NAME} | Система аренды ] ======
#define DIALOG_RENT_MAIN 1000
#define DIALOG_RENT_PERSONAL 1001

ShowRentMenu(playerid)
{
    new fmt_text[640], Cache:result;
    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM ownable_cars WHERE owner_id='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);
    
    new rows = cache_num_rows(result);
    new dialog_content[256];
    
    format(dialog_content, sizeof(dialog_content), "##\tНазвание\tНомер\tДействие\n1.\tСкутер\t[-----]\tАрендовать\n");
   
    if(rows > 0)
    {
        new query[60], model_id, car_number[7];
        
        for(new i = 0; i < rows; i++)
        {
            model_id = cache_get_field_content_int(i, "model_id") - 400;
            cache_get_field_content(i, "number", car_number);
            
            format(query, sizeof(query), "%d.\t%s\t[%s]\tАрендовать\n", 
                i+2, 
                GetVehicleInfo(model_id, VI_NAME), 
                car_number);
                
            strcat(dialog_content, query);
            SetPlayerListitemValue(playerid, i+1, cache_get_field_content_int(i, "id"));
        }
    }
    
    cache_delete(result);
    
    ShowPlayerDialog(playerid, DIALOG_RENT_MAIN, DIALOG_STYLE_TABLIST_HEADERS,
        "{SERVER_NAME} | Аренда транспорта",
        dialog_content,
        "Выбрать", "Закрыть");
}

RentScooter(playerid)
{
    if(GetPlayerMoney(playerid) >= 250) // Стоимость аренды скутера - 250 рублей
    {
        GivePlayerMoney(playerid, -250);
        
        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        
        new vehicleid = CreateVehicle(462, x+2.0, y+2.0, z, a+90.0, -1, -1, 60000);
        PutPlayerInVehicle(playerid, vehicleid, 0);
        
        SendClientMessage(playerid, 0x00FF00AA, "Вы арендовали скутер за 250 рублей!");
    }
					else
    {
        SendClientMessage(playerid, 0xFF0000AA, "У вас недостаточно денег для аренды скутера! Нужно 250 рублей.");
    }
}

RentPersonalVehicle(playerid, vehicle_id)
{
    if(GetPlayerMoney(playerid) >= 1000) // Стоимость аренды личного транспорта - 1000 рублей
    {
        GivePlayerMoney(playerid, -1000);
        
        new fmt_text[128], Cache:result;
        mysql_format(mysql, fmt_text, sizeof(fmt_text), "SELECT * FROM ownable_cars WHERE id='%d'", vehicle_id);
        result = mysql_query(mysql, fmt_text, true);
        
        if(cache_num_rows(result) > 0)
        {
            new model_id = cache_get_field_content_int(0, "model_id");
            new Float:x, Float:y, Float:z, Float:a;
            
            GetPlayerPos(playerid, x, y, z);
            GetPlayerFacingAngle(playerid, a);
            
            new vehicleid = CreateVehicle(model_id, x+2.0, y+2.0, z, a+90.0, -1, -1, 60000);
            PutPlayerInVehicle(playerid, vehicleid, 0);
            
            SendClientMessage(playerid, 0x00FF00AA, "Ваш личный транспорт успешно создан! С вас списано 1000 рублей.");
        }
					else
        {
            SendClientMessage(playerid, 0xFF0000AA, "Ошибка: транспорт не найден в базе данных.");
        }
        
        cache_delete(result);
    }
					else
    {
        SendClientMessage(playerid, 0xFF0000AA, "У вас недостаточно денег для аренды личного транспорта! Нужно 1000 рублей.");
    }
}

public: SavePlayerAccount(playerid)
{
	new query[370];

	mysql_format
	(
		mysql, query, sizeof query,
		"UPDATE accounts SET last_login=%d,game_for_hour=%d,game_for_day=%d,game_for_day_prev=%d,\
		exp=%d,health=%f,hospital=%d,mute=%d,jail=%d,fmute=%d, online = 0 WHERE id=%d LIMIT 1",
		gettime(),
		GetPlayerData(playerid, P_GAME_FOR_HOUR),
		GetPlayerData(playerid, P_GAME_FOR_DAY),
		GetPlayerData(playerid, P_GAME_FOR_DAY_PREV),
		GetPlayerData(playerid, P_EXP),
		GetPlayerData(playerid, P_HEALTH),
		GetPlayerData(playerid, P_HOSPITAL),
		GetPlayerData(playerid, P_MUTE),
		GetPlayerData(playerid, P_JAIL),
		GetPlayerData(playerid, P_FMUTE),
		GetPlayerAccountID(playerid)
	);

	mysql_tquery(mysql, query);

	return 1;
}


forward RegCamFadeOut(playerid);
public RegCamFadeOut(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	SetPlayerInterior(playerid, 0);
	SetCameraBehindPlayer(playerid);
	return 1;
}

public Case1SecondSpawnTimer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(GetPlayerData(playerid, P_HOSPITAL))
    {
        ApplyPlayerHospitalSpawn(playerid);
        return 1;
    }
    SpawnPlayer(playerid);
    return 1;
}

public SpawnSetVWZero(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(GetPlayerData(playerid, P_HOSPITAL))
    {
        SetPlayerInterior(playerid, 1);
        SetPlayerVirtualWorld(playerid, 1);
        Streamer_Update(playerid);
        return 1;
    }
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    GarageSys_OnPlayerSpawn(playerid);
    FsinFull_OnPlayerSpawn(playerid);
	StopAudioStream(playerid);
	Mine_ClearCarry(playerid);
    // Accessory state is loaded once later in this spawn callback.

    // A death-respawn must always land in the normal exterior world even if
    // the player died inside an interior or virtual world. SetSpawnInfo()
    // already supplies the regular spawn coordinates; this only normalizes
    // world/interior after the spawn has actually completed.
    if(GetPVarInt(playerid, "death_to_regular_spawn") == 1)
    {
        DeletePVar(playerid, "death_to_regular_spawn");
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        Streamer_Update(playerid);
    }

    SafeSetPlayerData(playerid, P_ONLINE_TODAY, GetPlayerDatabaseInt(playerid, "online_today"));
    CreateAcs(playerid);
    if(GetPVarInt(playerid, "spawn_case1_twice") == 1)
    {
        SetPVarInt(playerid, "spawn_case1_twice", 2);
        SetSpawnInfo(playerid, 0, GetPlayerSkinEx(playerid), 846.602600, 796.555847, 13.400512, 50.0, 0, 0, 0, 0, 0, 0);
        SetTimerEx("Case1SecondSpawnTimer", 150, false, "i", playerid);
    }
    if(GetPlayerMoney(playerid)!= 0)
    if(TEST_SERVER == 1) SendClientMessage(playerid, -1, "{ffff00}| {ffffff}Вы находитесь на ТЕСТ СЕРВЕРЕ. Введите {ffff00}/test{ffffff} для получения админки");
    PlayerPlayStream(playerid, "");
	ShowCredits(playerid);
    DestroyAdminBadge(playerid);
    AdminNickRainbowApply(playerid);

    if(!IsValidDynamic3DTextLabel(g_player[playerid][P_ADMIN_LABEL]) && GetPlayerData(playerid, P_3D_PREFIX))
	{
		g_player[playerid][P_ADMIN_LABEL] = CreateDynamic3DTextLabel("Администратор", 0xFFCC33FF, 0.0, 0.0, 0.3, 10.0, playerid);
		Attach3DTextLabelToPlayer(g_player[playerid][P_ADMIN_LABEL], playerid, 0.0, 0.0, -0.8);
	}

	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);


   //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} OnPlayerSpawn");

	SetPlayerData(playerid, P_IN_HOUSE, 		-1);
	SetPlayerData(playerid, P_IN_BUSINESS, 		-1);
	SetPlayerData(playerid, P_IN_HOTEL_FLOOR, 	-1);
	SetPlayerData(playerid, P_IN_HOTEL_ROOM, 	-1);
	SetPlayerData(playerid, P_IN_ENTRANCE,		-1);
	SetPlayerData(playerid, P_IN_ENTRANCE_FLOOR,-1);

	SetPlayerSkillsInit(playerid);

    if(IsPlayerLogged(playerid))
    {
        // Hospital spawn must use the last skin model that was actually rendered.
        // Do not blindly resend a stale P_SKIN (for example broken model 413).
        if(GetPlayerData(playerid, P_HOSPITAL))
            SetPlayerSkin(playerid, GetPlayerHospitalSpawnSkin(playerid));
        else
            SetPlayerSkinInit(playerid);

        // SetPlayerSkin clears attached objects on SA-MP/mobile clients, so
        // equipped accessories must be restored only after the skin is set.
        Inventory11_NormalizeLegacyAccessorySlots(playerid);
        LoadAccessory(playerid);
        SetTimerEx("AccessorySpawnReapply", 400, false, "ii", playerid, mysql_race[playerid]);
        SetTimerEx("AccessorySpawnReapply", 1300, false, "ii", playerid, mysql_race[playerid]);
    }

    if(g_golod_timer[playerid] != 0)
    {
        KillTimer(g_golod_timer[playerid]);
        g_golod_timer[playerid] = 0;
    }
    if(GetPVarType(playerid, "spawn_safe_until")) DeletePVar(playerid, "spawn_safe_until");
    golod[playerid] = 100;
// выбор скинаааааааааааааааааааа камерааааа
if(!IsPlayerLogged(playerid))
{
	if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_REG_SKIN)
	{
		BRAuth_Camera(playerid);
	}
}

					else
	{
		
        if(GetPlayerData(playerid, P_HOSPITAL))
        {
            ApplyPlayerHospitalSpawn(playerid);
        }
        else
        {
            SetPlayerHealthEx(playerid, 100.0);
        }

		if(!GetPlayerData(playerid, P_ANIMS_INIT))
		{
			PreLoadPlayerAnims(playerid);
			SetPlayerData(playerid, P_ANIMS_INIT, true);
		}

if(GetPlayerAdminEx(playerid) && GetPlayerData(playerid, P_ADMIN_LOGGED))
{
    TextDrawShowForPlayer(playerid, report_edit_TD);
    TextDrawShowForPlayer(playerid, admin_datetime_TD);
}
else
{
    TextDrawHideForPlayer(playerid, report_edit_TD);
    TextDrawHideForPlayer(playerid, admin_datetime_TD);
}
	
		if(GetPlayerData(playerid, P_MASK) >= 2)
		{
			SetPlayerColorInit(playerid);
			SetPlayerData(playerid, P_MASK, 0);
		}
	}

    return 1;
}

forward AccessorySpawnReapply(playerid, race);
public AccessorySpawnReapply(playerid, race)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
    if(mysql_race[playerid] != race) return 1;

    LoadAccessory(playerid);
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    GarageSys_OnPlayerDeath(playerid);
    FireExtVisual_Stop(playerid);
    new fmt_text[700];

    // Preserve the model that was really visible before any death/spawn logic.
    // It is used only if a hospital spawn path is entered later.
    new death_live_skin = GetPlayerSkin(playerid);
    if(Hospital_IsUsableSpawnSkin(death_live_skin))
        SetPVarInt(playerid, "hospital_spawn_skin", death_live_skin + 1);

	TC_OnPlayerDeath(playerid);
	Mine_ClearCarry(playerid);

    if(g_golod_timer[playerid] != 0)
    {
        KillTimer(g_golod_timer[playerid]);
        g_golod_timer[playerid] = 0;
    }
    
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);
	
    if(!IsPlayerLogged(playerid))
	{
		return Kick:(playerid, " ");
	}
	if(IsPlayerInJob(playerid))
	{
		EndPlayerJob(playerid);
	}
	if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
	{
		TogglePlayerDynamicCP(playerid, help_info_CP, true);
	}
	if(GetPlayerData(playerid, P_OCCUPIED_BED) != -1)
	{
		ClearMedBed(playerid, GetPlayerData(playerid, P_OCCUPIED_BED));
	}
	SetPlayerData(playerid, P_JOB_CAR, INVALID_VEHICLE_ID);

	SetPlayerDrivingExamInfo(playerid, DE_POINTS, 0);
	SetPlayerFactoryDeskUse(playerid, GetPlayerData(playerid, P_FACTORY_USE_DESK), false);

	SetPlayerData(playerid, P_IN_HOUSE, 		-1);
	SetPlayerData(playerid, P_IN_BUSINESS, 		-1);
	SetPlayerData(playerid, P_IN_HOTEL_FLOOR, 	-1);
	SetPlayerData(playerid, P_IN_HOTEL_ROOM, 	-1);
	SetPlayerData(playerid, P_IN_ENTRANCE,		-1);
	SetPlayerData(playerid, P_IN_ENTRANCE_FLOOR,-1);

	

	// A valid killer is never a suicide. Weapon 0 is Fist and must still
	// be credited to the attacker. Reasons outside weapon_names[] are logged
	// without indexing the 0..46 weapon-name table.
	if(GetPVarInt(playerid, "wound_hospital_transfer"))
	{
		// раненый сам выбрал ЦБ / потерял сознание: это не самоубийство
		DeletePVar(playerid, "wound_hospital_transfer");
	}
	else if(killerid == INVALID_PLAYER_ID || killerid == playerid)
	{
		format(fmt_text, sizeof fmt_text, "[A] %s[%d] убил себя", GetPlayerNameEx(playerid), playerid);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}
	else if(reason >= 0 && reason < 47)
	{
		format(fmt_text, sizeof fmt_text, "[A] %s[%d] убил %s[%d] (%s)", GetPlayerNameEx(killerid), killerid, GetPlayerNameEx(playerid), playerid, GetWeaponName(reason));
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}
	else
	{
		format(fmt_text, sizeof fmt_text, "[A] %s[%d] убил %s[%d] (причина %d)", GetPlayerNameEx(killerid), killerid, GetPlayerNameEx(playerid), playerid, reason);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	if(killerid != INVALID_PLAYER_ID)
	{
		if(GetPlayerSuspect(playerid) && IsPlayerInPoliceTeam(killerid))
		{
			format(fmt_text, sizeof fmt_text, "[Всем постам] %s %s нейтрализовал преступника %s", GetPlayerJobAndRankName(killerid), GetPlayerNameEx(killerid), GetPlayerNameEx(playerid));
			SendMessageToPoliceTeam(fmt_text, 0x00CCFFFF);

			JailPlayer(playerid, GetPlayerSuspect(playerid) * 5);

			SetPlayerData(playerid, P_SUSPECT, 0);
			UpdatePlayerDatabaseInt(playerid, "suspect", 0);

			SetPlayerSuspectInit(playerid);

			SendClientMessage(playerid, 0x66CC33FF, "Вы были нейтрализованы сотрудником правоохранительных органов");
			SendClientMessage(playerid, 0xCECECEFF, "Время до окончания заключения: {CCCC00}/time");
		}

		if(g_capture[C_STATUS])
		{
			if(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(killerid) <= TEAM_OPG_LYTKARINSKAYA)
			{
				new area_id = GetGangZoneData(g_capture[C_GANG_ZONE], GZ_AREA);

				if(IsPlayerInDynamicArea(killerid, area_id) && IsPlayerInDynamicArea(playerid, area_id))
				{
					new gang_id[2];

					gang_id[0] = (GetPlayerTeamEx(killerid) - TEAM_OPG_ARZAMASKAYA) + 1;
					gang_id[1] = (GetPlayerTeamEx(playerid) - TEAM_OPG_ARZAMASKAYA) + 1;

					if(gang_id[0] == g_capture[C_ATTACK_TEAM] && gang_id[1] == g_capture[C_PROTECT_TEAM])
						g_capture[C_ATTACKER_KILLS] ++;

					else if(gang_id[0] == g_capture[C_PROTECT_TEAM] && gang_id[1] == g_capture[C_ATTACK_TEAM])
						g_capture[C_PROTECTOR_KILLS] ++;
						
						
					AddPlayerData(killerid, P_CAPT_KILL, +, 1);
	    			UpdatePlayerDatabaseInt(killerid, "capt_kills", GetPlayerData(killerid, P_CAPT_KILL));
	    			
	    			AddPlayerData(killerid, P_F_QUEST_EXP_2, +, 1);
					UpdatePlayerDatabaseInt(killerid, "FracQuestExp2", GetPlayerData(killerid, P_F_QUEST_EXP_2));

					if(GetPlayerData(killerid, P_F_QUEST_EXP_2) == 30)
					{
					    SendClientMessage(playerid, COR_SERVER, "{ffffff}Вы успешно выполнили квест {009900}'Могу стрелять!'. {ffffff}Ваша награда: {009900}5000 руб, 1exp");
				                                SendClientMessage(playerid, COR_SERVER, "{ffffff}Введите {009900}/quest{ffffff},для подробной информации по Вашим квестам");

                        AddPlayerData(killerid, P_DONATE_CASE, +, 1);
						

					    SetPlayerData(killerid, P_F_QUEST_2, 1);
					    UpdatePlayerDatabaseInt(killerid, "FracQuest2", 1);
					    
					    AddPlayerData(killerid, P_TOP_5, +, 1);
						UpdatePlayerDatabaseInt(killerid, "TOP_Quest", GetPlayerData(killerid, P_TOP_5));
					}
				}
			}
		}
	}

	if(GetPlayerData(playerid, P_BUY_CAR) != INVALID_VEHICLE_ID)
	{
		DestroyVehicle(GetPlayerData(playerid, P_BUY_CAR));
		SetPlayerData(playerid, P_BUY_CAR, INVALID_VEHICLE_ID);

		//BuyCarTDsHideForPlayer(playerid);
		//HidePlayerSelectPanel(playerid);
		
		HideAutosalonTextDraws(playerid);
	}

	if(GetPlayerRentCar(playerid) != INVALID_VEHICLE_ID)
	{
		new vehicleid = GetPlayerRentCar(playerid);
		new rent_index = GetRentCarDataIndex(vehicleid);

		if(rent_index != -1) rent_cars_data[rent_index][rent_car_tenant_id] = INVALID_PLAYER_ID;

		SetVehicleToRespawn(vehicleid);

		//SendClientMessage(playerid, 0xFF5533FF, "Арендованный транспорт уничтожен. Договор аренды расторгнут");

		SetPlayerData(playerid, P_RENT_CAR, INVALID_VEHICLE_ID);
	}

	SetPlayerJobLoadItems(playerid, 0);
	SetPlayerTempJob(playerid, TEMP_JOB_NONE);

	if(GetPlayerData(playerid, P_JAIL) > 0)
	{
		SetPlayerSpawnInit(playerid);
	}
	else
	{
        // Hospital death session. Reuse the hardened hospital spawn pipeline:
        // one token/one room, no normal spawn selector and no stale callbacks
        // from an older death/login session.
        new hospital_token = GetPVarInt(playerid, "hospital_spawn_token") + 1;
        if(hospital_token <= 0) hospital_token = 1;
        SetPVarInt(playerid, "hospital_spawn_token", hospital_token);
        SetPVarInt(playerid, "hospital_spawn_state", 0);
        DeletePVar(playerid, "hospital_spawn_room");
        DeletePVar(playerid, "death_to_regular_spawn");
        DeletePVar(playerid, "spawn_case1_twice");

		SetPlayerData(playerid, P_HOSPITAL, true);
		UpdatePlayerDatabaseInt(playerid, "hospital", 1);

        // SetSpawnInfo uses the skin captured at the beginning of OnPlayerDeath,
        // so hospital admission does not replace the player's current skin.
		SetPlayerHospitalSpawnInit(playerid);

        // death_manual_call выставляется в Wounded_ToHospital/Wounded_Finish/
        // ApplyServerPlayerDamage непосредственно перед их собственным
        // CallLocalFunction("OnPlayerDeath", ...) - там реальной смерти клиента
        // не было (HP не падал до 0), поэтому ждать нечего: переносим сразу.
        //
        // Если же это настоящая смерть (упал, утонул, взорвалась машина и т.п.),
        // клиент уже показывает свою локальную анимацию гибели/wasted-камеру.
        // Раньше перенос в ЦБ для таких смертей запускался только из
        // естественного OnPlayerSpawn, который мобильный клиент присылал не
        // сразу и мог продублировать - отсюда и "сначала кидает в ЦБ, потом
        // засчитывается смерть", и слетающий интерьер при повторном спавне.
        // Теперь перенос всегда планируется здесь, из одного места, один раз,
        // с задержкой - чтобы не обрывать анимацию гибели телепортом посреди неё.
        // (hospital_token уже объявлена и заполнена чуть выше)
        if(GetPVarInt(playerid, "death_manual_call"))
        {
            DeletePVar(playerid, "death_manual_call");
            ApplyPlayerHospitalSpawn(playerid);
        }
        else
        {
            SetTimerEx("HospitalDeathTransfer", 2500, false, "iii", playerid, hospital_token, mysql_race[playerid]);
        }
	}

	return 1;
}

// Задержанный перенос в ЦБ после настоящей смерти (см. OnPlayerDeath выше) - даём клиенту
// доиграть локальную анимацию гибели, потом один раз переносим. hospital_token/session не
// дают сработать для другой, более поздней смерти/сессии того же слота.
forward HospitalDeathTransfer(playerid, token, session);
public HospitalDeathTransfer(playerid, token, session)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    if(mysql_race[playerid] != session) return 0;
    if(!GetPlayerData(playerid, P_HOSPITAL)) return 0;
    if(GetPVarInt(playerid, "hospital_spawn_token") != token) return 0;

    ApplyPlayerHospitalSpawn(playerid);
    return 1;
}

stock bool:IsPlayerInGovernmentInteriorGreenZone(playerid)
{
	if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return false;
	if(GetPlayerInterior(playerid) != 1) return false;

	new world = GetPlayerVirtualWorld(playerid);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	for(new org_id = TEAM_GOVERNMENT; org_id <= TEAM_FBI; org_id++)
	{
		if(g_organization[org_id][O_SPAWN_INT] != 1 || g_organization[org_id][O_SPAWN_VW] != world) continue;

		if(VectorSize(x - g_organization[org_id][O_SPAWN][0], y - g_organization[org_id][O_SPAWN][1], z - g_organization[org_id][O_SPAWN][2]) <= 350.0)
			return true;

		if(VectorSize(x - g_organization[org_id][O_REPOSITORY_POS][0], y - g_organization[org_id][O_REPOSITORY_POS][1], z - g_organization[org_id][O_REPOSITORY_POS][2]) <= 350.0)
			return true;
	}
	return false;
}
stock HandleServerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	new bool:government_safe_zone = issuerid != INVALID_PLAYER_ID &&
		(IsPlayerInGovernmentInteriorGreenZone(playerid) || IsPlayerInGovernmentInteriorGreenZone(issuerid));
	new bool:police_baton = issuerid != INVALID_PLAYER_ID && IsPlayerInPoliceTeam(issuerid) && weaponid == WEAPON_NITESTICK;
	if(government_safe_zone && !police_baton)
	{
		ClearPlayerAnim(issuerid);
		SetPlayerArmedWeapon(issuerid, 0);
		SendClientMessage(issuerid, 0x66CC33FF, "В интерьерах государственных организаций действует зелёная зона. Нанесение урона запрещено.");
		return 0;
	}




    new fmt_text[700];

    //format(fmt_text, sizeof fmt_text, "{8A2BE2}[ANTI-DM]: Игрок %s[%d] атакует игрока %s[%d] без причины.", GetPlayerNameEx(issuerid), issuerid, GetPlayerNameEx(playerid), playerid);
	//SendMessageToAdmins(fmt_text, 0x009900FF);













	/*

	if(IsPlayerFly(playerid))
	{
		GetPlayerHealth(playerid, health);
		SetPlayerHealth(playerid, health + amount);
	}

	*/
	
	
	if(issuerid != INVALID_PLAYER_ID && GetPVarInt(playerid, "player_in_green_zone"))
	{
		new green_zone_id = GetPVarInt(playerid, "player_in_green_zone") - 1;

		if(g_green_zones[green_zone_id][GZ_NO_WEAPON] || !(TEAM_DPS <= GetPlayerTeamEx(issuerid) <= TEAM_FBI))
		{
			ClearPlayerAnim(issuerid);

			new fmt_text[220];

			format
			(
				fmt_text, sizeof fmt_text,
				"{FFFFFF}"\
				"Предупреждение:\n\n"\
				"Игрок находится в зеленой зоне '{66CC33}%s{FFFFFF}'\n"\
				"Нанесение урона запрещено. При повторных попытках Вы будете кикнуты.",
				g_green_zones[green_zone_id][GZ_NAME]
			);

			ShowPlayerDialog(issuerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF5533}Зеленая зона", fmt_text, "Закрыть", "");

			format(fmt_text, sizeof fmt_text, "[SYSTEM] %s[%d] попытался ударить %s[%d] в зеленой зоне %s", GetPlayerNameEx(issuerid), issuerid, GetPlayerNameEx(playerid), playerid, g_green_zones[green_zone_id][GZ_NAME]);
			SendMessageToAdmins(fmt_text, 0xFF5533FF);

			return 0;
		}
	}
	

	if(issuerid == INVALID_PLAYER_ID) return 1;

	if(issuerid != INVALID_PLAYER_ID && GetPVarInt(playerid, "player_in_green_zone"))
	{
		new green_zone_id = GetPVarInt(playerid, "player_in_green_zone") - 1;

		if(g_green_zones[green_zone_id][GZ_NO_WEAPON] || !(TEAM_DPS <= GetPlayerTeamEx(issuerid) <= TEAM_FBI))
		{
			ClearPlayerAnim(issuerid);

			new fmt_text[220];

			format
			(
				fmt_text, sizeof fmt_text,
				"{FFFFFF}"\
				"Предупреждение:\n\n"\
				"Игрок находится в зеленой зоне '{66CC33}%s{FFFFFF}'\n"\
				"Нанесение урона запрещено. При повторных попытках Вы будете кикнуты.",
				g_green_zones[green_zone_id][GZ_NAME]
			);

			ShowPlayerDialog(issuerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF5533}Зеленая зона", fmt_text, "Закрыть", "");

			format(fmt_text, sizeof fmt_text, "[A] %s[%d] попытался ударить %s[%d] в зеленой зоне %s", GetPlayerNameEx(issuerid), issuerid, GetPlayerNameEx(playerid), playerid, g_green_zones[green_zone_id][GZ_NAME]);
			SendMessageToAdmins(fmt_text, 0xFF5533FF);

			return 0;
		}
	}

	if(TEAM_DPS <= GetPlayerTeamEx(issuerid) <= TEAM_FBI)
	{
		if(weaponid == WEAPON_NITESTICK)
		{
			SetPlayerAnimation(playerid, 21);
			TogglePlayerControllable(playerid, false);

			new baton_stun_token = GetPVarInt(playerid, "baton_stun_token") + 1;
			SetPVarInt(playerid, "baton_stun_token", baton_stun_token);
			SetTimerEx("UnfreezePlayer", 15000, false, "ii", playerid, baton_stun_token);

			new fmt_text[90];

			format(fmt_text, sizeof fmt_text, "Вы оглушили %s на 15 секунд", GetPlayerNameEx(playerid));
			SendClientMessage(issuerid, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "%s оглушил Вас на 15 секунд", GetPlayerNameEx(issuerid));
			SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

			CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);
			if(government_safe_zone) return 0;
		}
	}

	new Float:power_bonus = 0.0;
	if(GetPlayerData(issuerid, P_POWER) && !weaponid)
	{
		power_bonus = GetPlayerData(issuerid, P_POWER) * 0.05;
	}

	ApplyServerPlayerDamage(playerid, issuerid, amount + power_bonus, weaponid);

	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	return HandleServerTakeDamage(playerid, issuerid, amount, weaponid, bodypart);
}

public: UnfreezePlayer(playerid, baton_stun_token)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(GetPVarInt(playerid, "baton_stun_token") != baton_stun_token) return 0;

	SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE);
	SetPlayerData(playerid, P_USE_ANIM, false);
	HideAnimTD(playerid);
	ClearPlayerAnim(playerid);
	ClearAnimations(playerid, 1);
	TogglePlayerControllable(playerid, true);
	DeletePVar(playerid, "baton_stun_token");

	return 1;
}

// Per-vehicle generation cancels superseded suspension replays.
new g_StylingSuspensionTimer[MAX_VEHICLES];
new g_StylingSuspensionToken[MAX_VEHICLES];

public OnVehicleSpawn(vehicleid)
{
    // A freshly spawned vehicle has no client-side turn-signal entity yet.
    // Broadcasting packet 12 here can poison mobile vehicle state before StreamIn.
    ResetVehicleTurnSignalData(vehicleid);
	TC_OnVehicleSpawn(vehicleid);
	SetVehicleData(vehicleid, V_DRIVER_ID, INVALID_PLAYER_ID);

	if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_ADMIN_CAR || GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_ORG_CAR)
    {
        if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_ORG_CAR)
        SetPlayerData(GetVehicleData(vehicleid, V_ACTION_OWNER), P_FRACTION_CAR, INVALID_VEHICLE_ID);

        DestroyVehicle(vehicleid);
    }
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_GIFT_CAR)
    {
        new Float: x,
		Float: y,
		Float: z,
		Float: angle;
		
		GetVehiclePos(vehicleid, x, y, z); // узнаем координаты авто
        GetVehicleZAngle(vehicleid, angle); // узнаем угол поворота авто
    }
	if(IsAOwnableCar(vehicleid))
	{
		new index = GetVehicleData(vehicleid, V_ACTION_ID);

		SetVehiclePos
		(
			vehicleid,
			GetOwnableCarData(index, OC_POS_X),
			GetOwnableCarData(index, OC_POS_Y),
			GetOwnableCarData(index, OC_POS_Z)
		);
		SetVehicleZAngle(vehicleid, GetOwnableCarData(index, OC_ANGLE));
		Styling_QueueSuspension(vehicleid);
	}
	if(IsAFamilyCar(vehicleid))
    {
        new index = GetVehicleData(vehicleid, V_ACTION_ID);
        if(index >= 0 && index < MAX_OWNABLE_CARS && GetCarFamily(index, CAR_F_database) > 0)
        {
            SetVehiclePos(vehicleid, GetCarFamily(index, V_F_SPAWN_X), GetCarFamily(index, V_F_SPAWN_Y), GetCarFamily(index, V_F_SPAWN_Z));
            SetVehicleZAngle(vehicleid, GetCarFamily(index, V_F_SPAWN_A));
            FT55_Queue(vehicleid);
        }
        else if(index >= 0 && index < sizeof g_family_car)
        {
            SetVehiclePos(vehicleid, GetFamilyCarData(index, F_POS_X), GetFamilyCarData(index, F_POS_Y), GetFamilyCarData(index, F_POS_Z));
            SetVehicleZAngle(vehicleid, GetFamilyCarData(index, F_ANGLE));
        }
    }
					else if(!IsAOwnableCar(vehicleid))
	{
		DestroyVehicleLabel(vehicleid);
		SetVehicleData(vehicleid, V_FUEL, 40.0);
	}
	SetVehicleData(vehicleid, V_LIMIT, true);
	SetVehicleParamsEx(vehicleid, IsABike(vehicleid) ? VEHICLE_PARAM_ON : VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF);

	if(IsAOwnableCar(vehicleid)) SetVehicleHealth(vehicleid, GetVehicleData(vehicleid, V_HEALTH));

	switch(GetVehicleData(vehicleid, V_ACTION_TYPE))
	{
		case
			VEHICLE_ACTION_TYPE_FACTORY,
			VEHICLE_ACTION_TYPE_BUS_DRIVER,
			VEHICLE_ACTION_TYPE_TAXI_DRIVER,
			VEHICLE_ACTION_TYPE_UNUSED_1,
			VEHICLE_ACTION_TYPE_TRUCKER:
		{
			SetVehicleData(vehicleid, V_ACTION_ID, VEHICLE_ACTION_ID_NONE);

			foreach(new i : Player)
			{
				if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
				if(GetPlayerJobCar(i) != vehicleid) continue;

				SetPlayerData(i, P_JOB_CAR, INVALID_VEHICLE_ID);
				SetPlayerData(i, P_RENT_BIKE, INVALID_VEHICLE_ID);
			}
		}
		case VEHICLE_ACTION_TYPE_RENT_BIKE:
        {
            foreach(new i : Player)
            {
                if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
                if(GetPlayerData(i, P_RENT_BIKE) != vehicleid) continue;
                DestroyVehicle(vehicleid);
                SetPlayerData(i,  P_RENT_BIKE, 0);
                //SendClientMessage(i,-1,"Арендованный Т/С был возвращен на стоянку, договор аренды расторгнут!");
            }
        }


	}
    
	
    
	return 1;
}

public OnTrailerUpdate(playerid, vehicleid)
{
	TC_OnTrailerUpdate(playerid, vehicleid);
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    // The entity is being destroyed; reset server state silently.
    ResetVehicleTurnSignalData(vehicleid);
	if(TC_OnVehicleDeath(vehicleid)) return 1;
	new rent_index = GetRentCarDataIndex(vehicleid);
	if(rent_index != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_RENT_CAR)
		rent_cars_data[rent_index][rent_car_tenant_id] = INVALID_PLAYER_ID;

	if(IsAOwnableCar(vehicleid)) SetVehicleData(vehicleid, V_HEALTH, 300.0);

	return 1;
}

public OnPlayerText(playerid, text[])
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, FLOOD_RATE_INC);

	if(!IsPlayerLogged(playerid)) return 0;

	if(GetPlayerData(playerid, P_MUTE))
	{
		ShowNotificationNew(playerid,  2, 6, 0, 0, "Вы не можете использовать чат во время мута", "qq"); // вызов уведомление

		SetPlayerChatBubble(playerid, "У игрока мут: не может писать и говорить", 0xFF5533FF, 10.5, 2000);

		return 0;
	}
 	if(strcmp(text, "q", true) == 0)
    {
 	}
	if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE)
	{
		ShowNotificationNew(playerid,  2, 6, 0, 0, "Не флудите", "qq"); // вызов уведомление

		if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE + 500)
			SendClientMessage(playerid, 0x6B6B6BFF, "Пожалуйста, подождите несколько секунд...");

		return 0;
	}
	if(strlen(text) > 90) return 0;

	if(IsAIP(text))
	{

SendClientMessage(playerid, -1, "{FFFF00}[СРОЧНО-СМОТРИ]{FFFF00}Test_Test[321]подозревается в рекламе");
       	return false;
    }


	if(GetPlayerPhoneCall(playerid, PC_TIME) != -1)
	{
		new caller = GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER);
		new call_to = GetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER);

		new fmt_str[128];
		format(fmt_str, sizeof fmt_str, "[Тел] %s: %s", GetPlayerNameEx(playerid), text);

		if(call_to != INVALID_PLAYER_ID && playerid == GetPlayerPhoneCall(call_to, PC_INCOMING_PLAYER))
		{
			SendClientMessage(call_to, 0xFFFF00FF, fmt_str);
		}
					else if(caller != INVALID_PLAYER_ID && playerid == GetPlayerPhoneCall(caller, PC_OUTCOMING_PLAYER))
		{
			SendClientMessage(caller, 0xFFFF00FF, fmt_str);
		}
		SendMessageInLocal(playerid, fmt_str, 0x999999FF, 25.0);

		return 0;
	}
					else if(!strcmp(text, "(", true))
	{
		Action(playerid, "расстроился", _, false);
	}
					else if(!strcmp(text, "((", true))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			ApplyAnimationEx(playerid, "GRAVEYARD", "mrnF_loop", 4.1, false, 0, 0, 0, 0, 0);

		Action(playerid, "сильно расстроился", _, false);
	}
					else if(!strcmp(text, ")", true))
	{
		Action(playerid, "улыбается", _, false);
	}
					else if(!strcmp(text, "))", true))
	{
		Action(playerid, "смеётся", _, false);
	}
					else if(!strcmp(text, "=0", true))
	{
		Action(playerid, "удивился", _, false);
	}
					else
	{
		new in_biz = GetPlayerInBiz(playerid);
		if(in_biz != -1 && GetBusinessData(in_biz, B_TYPE) == BUSINESS_TYPE_CASINO && pInfo[playerid][CasinoDiceUiOpen])
		{
			if(SendMessageInCasinoTableChat(playerid, text)) return 0;
		}

		SendMessageInChat(playerid, text);
	}

	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/myacs", true) || !strcmp(cmdtext, "/acss", true)) return AccessoryShowInventory(playerid);
    return 0;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    // Ваш существующий код диалога подарка автомобиля
    new vehicle_type = GetVehicleData(vehicleid, V_ACTION_TYPE);

    if(vehicle_type == VEHICLE_ACTION_TYPE_GIFT_CAR)
    {
        ShowPlayerDialog(playerid, 8987, DIALOG_STYLE_MSGBOX,
            "{00FFFF}"SERVER_NAME"{FFFFFF} | Получение транспорта",
            "Вы уверены что хотите получить транспорт,\nв котором Вы сейчас находитесь?",
            "Да", "Нет");
        return 1;
    }

    //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} OnPlayerEnterVehicle ");

    if(CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, FLOOD_RATE_INC, FLOOD_RATE_KICK))
    {
        SendClientMessage(playerid, 0x6B6B6BFF, "При продолжении Вы будете отключены от сервера");

        if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE + 500)
            SendClientMessage(playerid, 0x6B6B6BFF, "Пожалуйста, подождите несколько секунд...");
            
        return 0;
    }
    
    if(!ispassenger)
    {


        if(GetPlayerData(playerid, P_CUFFED))
        {
            ClearAnimations(playerid);

            new Float: x, Float: y, Float: z;
            GetPlayerPos(playerid, x, y, z);
            SetPlayerPos(playerid, x, y, z);

            return SendClientMessage(playerid, 0x999999FF, "Вы закованы в наручники");
        }

        if(IsPlayerInVehicle(GetVehicleData(vehicleid, V_DRIVER_ID), vehicleid) && GetPlayerState(GetVehicleData(vehicleid, V_DRIVER_ID)) == PLAYER_STATE_DRIVER)
        {
            ClearAnimations(playerid);

            new Float: x, Float: y, Float: z;
            GetPlayerPos(playerid, x, y, z);
            SetPlayerPos(playerid, x, y, z);

            return GameTextForPlayer(playerid, "~r~~h~car is used", 1000, 4);
        }
        
        new Float:currentFuel = GetVehicleData(vehicleid, V_FUEL);
        new Float:currentMileage = GetVehicleData(vehicleid, V_MILEAGE);

        if(currentFuel < 0.0) currentFuel = 40.0;
        SetVehicleSpeedometerInfo(vehicleid, currentFuel, currentMileage);
        SetVehicleSpeedometerInfoFP(playerid, vehicleid, currentFuel, currentMileage);
    }
    
    return 1;
}

