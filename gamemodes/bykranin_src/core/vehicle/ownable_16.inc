//>> Файл: bykranin_src/core/vehicle/ownable_16.inc  (1841 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: IsPlayerNearMotoSalonRange, ToggleInteractionWindow, SendDestroyWayPoint, SendCreateWayPoint, /testsettings, SetVehicleSportForPlayerr, /zsport
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock IsPlayerNearMotoSalonRange(playerid)
{
	if(moto_salon_range_area == -1) return 0;
	if(GetPlayerInBiz(playerid) != STATIC_BIZ_ID_MOTO_SALON) return 0;
	if(GetPlayerData(playerid, P_BUY_CAR) != INVALID_VEHICLE_ID) return 0;

	return IsPlayerInDynamicArea(playerid, moto_salon_range_area);
}

stock ToggleInteractionWindow(playerid, bool:toggle)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT8, 2);
    BS_WriteValue(bs, PR_UINT8, toggle);

    PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SendDestroyWayPoint(playerid, waypoint_id)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, waypoint_id);
    PR_SendRPC(bs, playerid, 170, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}
stock SendCreateWayPoint(playerid, waypoint_id, Float:x, Float:y, Float:z, icon_id, color, Float:dist, interior)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(
        bs,
        PR_UINT16, waypoint_id,
        PR_FLOAT, x,
        PR_FLOAT, y,
        PR_FLOAT, z,
        PR_UINT32, icon_id,
        PR_UINT32, color,
        PR_FLOAT, dist,
        PR_UINT8, interior
    );
    PR_SendRPC(bs, playerid, 169, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

CMD:testsettings(playerid)
{
    new JSON:json = JSON_Object();

    // системные
    JSON_SetInt(json, "b", 1); // изменение из настроек

    // камера
    JSON_SetFloat(json, "camSensX", 1.0);
    JSON_SetFloat(json, "camSensY", 1.0);
    JSON_SetFloat(json, "aimCamSensX", 1.0);
    JSON_SetFloat(json, "aimCamSensY", 1.0);

    // управление
    JSON_SetInt(json, "joysens", 100);
    JSON_SetInt(json, "carcontrols", 0);
    JSON_SetInt(json, "lookbehind", 1);
    JSON_SetInt(json, "vibration", 1);

    // графика
    JSON_SetInt(json, "dd", 100);      // дальность прорисовки
    JSON_SetInt(json, "effect", 2);    // эффекты
    JSON_SetInt(json, "shad", 2);      // тени
    JSON_SetInt(json, "water", 2);     // вода
    JSON_SetInt(json, "refl", 1);      // отражения
    JSON_SetInt(json, "ssaa", 0);      // сглаживание
    JSON_SetInt(json, "res", 100);     // разрешение
    JSON_SetInt(json, "maxFps", 60);   // лимит FPS
    JSON_SetInt(json, "fps", 1);       // показывать FPS

    // звук
    JSON_SetInt(json, "effvolume", 100);
    JSON_SetInt(json, "speakervol", 100);
    JSON_SetInt(json, "mutemicro", 0);
    JSON_SetInt(json, "notOffMicro", 1);
    JSON_SetInt(json, "censoredRadio", 0);

    // интерфейс
    JSON_SetInt(json, "hudStyle", 0);
    JSON_SetInt(json, "hudVersion", 1);
    JSON_SetInt(json, "chatVersion", 1);
    JSON_SetInt(json, "keyboardVersion", 1);

    JSON_SetInt(json, "showspeakers", 1);
    JSON_SetInt(json, "showvoicechat", 1);

    // зима
    JSON_SetInt(json, "snowIntensity", 0);
    JSON_SetInt(json, "winterSlip", 0);

    ShowPlayerGUI(playerid, 47, json);

    ~json;
    return 1;
}

stock SetVehicleSportForPlayerr(playerid, vehicleid, value)
{
 new BitStream:bitstream = BS_New();
 BS_WriteValue(bitstream, PR_UINT8, 6);

 BS_WriteValue(bitstream, PR_UINT16, vehicleid);
 BS_WriteValue(bitstream, PR_UINT8, value);

 PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
 BS_Delete(bitstream);
}


CMD:zsport(playerid)
{

   SendClientMessage(playerid, -1, "SPORT+ вкл");

   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleSportForPlayerr(playerid, vehicleid, 1);
}
CMD:zsportoff(playerid)
{

   SendClientMessage(playerid, -1, "SPORT+ выкл");

   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleSportForPlayerr(playerid, vehicleid, 0);
}

stock SetPlayerCleanChat(playerid, clean)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 0); 
	 
	BS_WriteValue(bitstream, PR_UINT8, clean);   

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}
CMD:waypoint(playerid)
{
    SendCreateWayPoint(playerid, 0, 1000.0, 1000.0, 10.0, 85, 27, 5000.0, 0);
    return 1;
}

stock Adselox(playerid){

}

stock ResetCaseBonusStatesForCase(bonusStr[], size, caseIndex)
{
    for (new btn = 1; btn <= 5; btn++)
    {
        SetCaseBonusState(bonusStr, size, caseIndex, btn, CASE_BONUS_STATE_LOCKED);
    }
}

stock ProcessCaseBonusCycle(playerid, caseIndex, &openedCount)
{
    // каждые 40 открытий
    while (openedCount >= 41)
    {
        // проверяем все 5 бонусов
        for (new btn = 1; btn <= 5; btn++)
        {
            new states = GetCaseBonusState(g_player_case_bonus[playerid], caseIndex, btn);

            // если доступен, но не забран — выдаем автоматически
            if (states == CASE_BONUS_STATE_AVAILABLE)
            {
                printf("[CASE BONUS AUTO] player %d case %d button %d", playerid, caseIndex, btn);

                if (!SavePlayerCaseBonusReward(playerid, caseIndex, btn))
                {
                    printf("[CASE BONUS] Не удалось сохранить бонус: player=%d case=%d button=%d",
                    playerid, caseIndex, btn);
                }
            }
        }

        openedCount -= 40;

        ResetCaseBonusStatesForCase(
            g_player_case_bonus[playerid],
            sizeof(g_player_case_bonus[]),
            caseIndex
        );

        printf("[CASE BONUS RESET] player %d case %d", playerid, caseIndex);
    }
}
stock SendVehicleTurnLight(playerid, vehicleid, status)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return 0;
    if(status < 0 || status > 3) return 0;

    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT8, 12);
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, status);
    PR_SendPacket(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SendVehicleTurnLightForAll(vehicleid, status)
{
    for(new i = 0, lastPlayerId = GetPlayerPoolSize(); i <= lastPlayerId; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        SendVehicleTurnLight(i, vehicleid, status);
    }
    return 1;
}

stock ResetVehicleTurnSignalData(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 1;
    TurnSignalState[vehicleid] = 0;
    TurnSignalBlinkOn[vehicleid] = false;
    TurnSignalDriver[vehicleid] = INVALID_PLAYER_ID;
    TurnSignalModel[vehicleid] = 0;
    return 1;
}

stock StopVehicleTurnSignal(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 1;
    if(IsValidVehicle(vehicleid)) SendVehicleTurnLightForAll(vehicleid, 0);
    return ResetVehicleTurnSignalData(vehicleid);
}

stock StartVehicleTurnSignal(playerid, vehicleid, status)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 1;
    TurnSignalState[vehicleid] = status;
    TurnSignalBlinkOn[vehicleid] = true;
    TurnSignalDriver[vehicleid] = playerid;
    TurnSignalModel[vehicleid] = GetVehicleModel(vehicleid);
    SendVehicleTurnLightForAll(vehicleid, status);
    return 1;
}

stock StopPlayerVehicleTurnSignal(playerid)
{
    for(new vehicleid = 1, lastVehicleId = GetVehiclePoolSize(); vehicleid <= lastVehicleId; vehicleid++)
    {
        if(TurnSignalDriver[vehicleid] != playerid) continue;
        StopVehicleTurnSignal(vehicleid);
    }
    return 1;
}

forward UpdateVehicleTurnSignals();
public UpdateVehicleTurnSignals()
{
    for(new vehicleid = 1, lastVehicleId = GetVehiclePoolSize(); vehicleid <= lastVehicleId; vehicleid++)
    {
        if(TurnSignalState[vehicleid] < 1 || TurnSignalState[vehicleid] > 3) continue;

        if(!IsValidVehicle(vehicleid))
        {
            ResetVehicleTurnSignalData(vehicleid);
            continue;
        }

        new driverid = TurnSignalDriver[vehicleid];
        if(driverid == INVALID_PLAYER_ID || !IsPlayerConnected(driverid)
            || GetPlayerState(driverid) != PLAYER_STATE_DRIVER
            || GetPlayerVehicleID(driverid) != vehicleid
            || GetVehicleModel(vehicleid) != TurnSignalModel[vehicleid])
        {
            StopVehicleTurnSignal(vehicleid);
            continue;
        }

        if(TurnSignalBlinkOn[vehicleid])
        {
            TurnSignalBlinkOn[vehicleid] = false;
            SendVehicleTurnLightForAll(vehicleid, 0);
        }
        else
        {
            TurnSignalBlinkOn[vehicleid] = true;
            SendVehicleTurnLightForAll(vehicleid, TurnSignalState[vehicleid]);
        }
    }
    return 1;
}

stock LoadMySQLSettings()
{
    new FileID = ini_openFile("bykranin_mysql_settings.ini"),errCode;
    if(FileID < 0)
    {
        printf("Error while opening MySQL settings file. Error code: %d",FileID);
        return 0;
    }
    errCode = ini_getString(FileID,"host",MySQLSettings[KRANIN_HOST]);
    if(errCode < 0) printf("Error while reading MySQL settings file (host). Error code: %d",errCode);
    errCode = ini_getString(FileID,"username",MySQLSettings[KRANIN_USERNAME]);
    if(errCode < 0) printf("Error while reading MySQL settings file (username). Error code: %d",errCode);
    errCode = ini_getString(FileID,"password",MySQLSettings[KRANIN_PASSWORD]);
    if(errCode < 0) printf("Error while reading MySQL settings file (password). Error code: %d",errCode);
    errCode = ini_getString(FileID,"database",MySQLSettings[KRANIN_DATABASE]);
    if(errCode < 0) printf("Error while reading MySQL settings file (database). Error code: %d",errCode);
    ini_closeFile(FileID);
    return 1;
}

stock LoadNEWSettings()
{
    new FileID = ini_openFile("bykranin_server_settings.ini"),errCode;
    if(FileID < 0)
    {
        printf("Error while opening settings file. Error code: %d",FileID);
        return 0;
    }

    errCode = ini_getInteger(FileID,"donate",bonus_donate);
    errCode = ini_getInteger(FileID,"money",bonus_money);
    errCode = ini_getInteger(FileID,"vip",vip_type);
    errCode = ini_getInteger(FileID,"lvl",bonus_lvl);
	errCode = ini_getInteger(FileID,"whitelist", gWhitelist);
    errCode = ini_getString(FileID,"nameserver",NameServer[KRANIN_NAME]);
    if(errCode < 0) printf("Settings: failed to read nameserver (%d)", errCode);
    errCode = ini_getString(FileID,"tg",NameServer[KRANIN_TG]);
    if(errCode < 0) printf("Settings: failed to read tg (%d)", errCode);
    errCode = ini_getString(FileID,"vk",NameServer[KRANIN_VK]);
    if(errCode < 0) printf("Settings: failed to read vk (%d)", errCode);
    errCode = ini_getString(FileID,"site",NameServer[KRANIN_SITE]);
    if(errCode < 0) printf("Settings: failed to read site (%d)", errCode);
    errCode = ini_getString(FileID,"audio_url",AudioURL);
    if(errCode < 0) printf("Settings: failed to read audio_url (%d)", errCode);
    errCode = ini_getString(FileID,"cc_message",CCMessage);
    if(errCode < 0) printf("Settings: failed to read cc_message (%d)", errCode);

    ini_closeFile(FileID);
    return 1;
}

CMD:whitelist(playerid, params[])
{
    if (GetPlayerAdminEx(playerid) < 13)
        return SendClientMessage(playerid, 0xFF0000FF, "У вас нет доступа к этой команде.");

    new subcmd[32], name[MAX_PLAYER_NAME];
    if (sscanf(params, "s[32]S()[24]", subcmd, name))
    {
        SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /whitelist [on/off/add/remove] [ник (для add/remove)]");
        return 1;
    }

    if (!strcmp(subcmd, "on", true))
    {
        gWhitelist = true;
        SendClientMessage(playerid, 0x00FF00FF, ""SC"Вайтлист включён.");
        printf("[WHITELIST] Вайтлист включён администратором %s", GetPlayerNameEx(playerid));
        
        new announce[128];
        format(announce, sizeof(announce), "Администратор %s включил вайтлист", GetPlayerNameEx(playerid));
        SendClientMessageToAll(0x3399FFFF, announce);
    }
    else if (!strcmp(subcmd, "off", true))
    {
        gWhitelist = false;
        SendClientMessage(playerid, 0xFF5252FF, ""SC"Вайтлист выключён.");
        printf("[WHITELIST] Вайтлист выключён администратором %s", GetPlayerNameEx(playerid));
        
        new announce[128];
        format(announce, sizeof(announce), "Администратор %s выключил вайтлист", GetPlayerNameEx(playerid));
        SendClientMessageToAll(0x3399FFFF, announce);
    }
    else if (!strcmp(subcmd, "add", true))
    {
        if (!name[0])
            return SendClientMessage(playerid, 0xCECECEFF, ""SC"Укажите ник: /whitelist add [ник]");

        new query[128];
        mysql_format(mysql, query, sizeof(query), "INSERT IGNORE INTO whitelist (name) VALUES ('%e')", name);
        mysql_tquery(mysql, query, "", "");

        new msg[128];
        format(msg, sizeof(msg), ""SC"Игрок %s добавлен в вайтлист.", name);
        SendClientMessage(playerid, 0x00FF00FF, msg);
        printf("[WHITELIST] Админ %s добавил %s в вайтлист.", GetPlayerNameEx(playerid), name);
        
        new announce[128];
        format(announce, sizeof(announce), "Администратор %s добавил игрока %s в вайтлист", GetPlayerNameEx(playerid), name);
        SendClientMessageToAll(0x3399FFFF, announce);
    }
    else if (!strcmp(subcmd, "remove", true))
    {
        if (!name[0])
            return SendClientMessage(playerid, 0xCECECEFF, ""SC"Укажите ник: /whitelist remove [ник]");

        new query[128];
        mysql_format(mysql, query, sizeof(query), "DELETE FROM whitelist WHERE name='%e'", name);
        mysql_tquery(mysql, query, "", "");

        new msg[128];
        format(msg, sizeof(msg), ""SC"Игрок %s удалён из вайтлиста.", name);
        SendClientMessage(playerid, 0xFF5252FF, msg);
        printf("[WHITELIST] Админ %s удалил %s из вайтлиста.", GetPlayerNameEx(playerid), name);
        
        new announce[128];
        format(announce, sizeof(announce), "Администратор %s удалил игрока %s из вайтлиста", GetPlayerNameEx(playerid), name);
        SendClientMessageToAll(0x3399FFFF, announce);
    }
    else
    {
        SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /whitelist [on/off/add/remove] [ник]");
    }

    return 1;
}


// ============================================================================
// GARAGE SYSTEM (optimized integration of garages.pwn)
// - isolated runtime state (does not extend P_* player enum)
// - dedicated virtual-world range, so house garages at VW 2000+ cannot collide
// - no custom packet/RPC sync and no repeated vehicle-transform timers
// - accounts.garage is a persistence mirror; garages.owner_id is authoritative
// ============================================================================
#define GARAGE_SYS_MAX                         (500)
#define GARAGE_SYS_VW_BASE                     (700000)
#define GARAGE_SYS_PICKUP_ENTER                (222)
#define GARAGE_SYS_PICKUP_EXIT                 (221)
#define GARAGE_SYS_SAFE_EXIT_DISTANCE          (3.0)
#define GARAGE_SYS_SAFE_EXIT_Z_OFFSET          (0.30)
#define GARAGE_SYS_UPGRADE_PRICE               (5000000)
#define GARAGE_SYS_RENT_PRICE                  (5000)
#define GARAGE_SYS_MAX_RENT_DAYS               (30)

#define DIALOG_GS_INFO                         (22313)
#define DIALOG_GS_SETTINGS                     (22323)
#define DIALOG_GS_SELL_STATE                   (22333)
#define DIALOG_GS_BUY                          (22343)
#define DIALOG_GS_ENTER                        (22353)
#define DIALOG_GS_CAR_SELECT                   (22373)
#define DIALOG_GS_UPGRADE                      (22383)
#define DIALOG_GS_PAY_RENT                     (22393)

#define GARAGE_SYS_MAPICON_TYPE 27 // 27 = mod garage icon
enum E_GARAGE_SYS_DATA
{
    GS_DB_ID,
    GS_OWNER_ID,
    GS_PRICE,
    GS_LOCKED,
    Float:GS_X,
    Float:GS_Y,
    Float:GS_Z,
    Float:GS_EXIT_X,
    Float:GS_EXIT_Y,
    Float:GS_EXIT_Z,
    Float:GS_EXIT_A,
    Float:GS_SPAWN_X,
    Float:GS_SPAWN_Y,
    Float:GS_SPAWN_Z,
    Float:GS_SPAWN_A,
    Float:GS_SAFE_EXIT_X,
    Float:GS_SAFE_EXIT_Y,
    Float:GS_SAFE_EXIT_Z,
    Float:GS_SAFE_EXIT_A,
    Float:GS_CAR_EXIT_X,
    Float:GS_CAR_EXIT_Y,
    Float:GS_CAR_EXIT_Z,
    Float:GS_CAR_EXIT_A,
    GS_IMPROVEMENT,
    GS_RENT_DATE,
    GS_ENTER_PICKUP,
    GS_EXIT_PICKUP,
    GS_MAPICON,
    Text3D:GS_LABEL,
    GS_OWNER_NAME[21]
};

new g_gs_garage[GARAGE_SYS_MAX][E_GARAGE_SYS_DATA];
new g_gs_loaded = 0;
new bool:g_gs_ready = false;
new g_gs_player_owned[MAX_PLAYERS] = {-1, ...};
new g_gs_player_inside[MAX_PLAYERS] = {-1, ...};
new g_gs_dialog_garage[MAX_PLAYERS] = {-1, ...};
new g_gs_vehicle_garage[MAX_VEHICLES] = {-1, ...};
new g_gs_vehicle_slot[MAX_VEHICLES] = {-1, ...};

// One-shot CreateVehicle transform used only by /garage remote delivery.
new bool:g_gs_spawn_override_active = false;
new g_gs_spawn_override_sql_id = 0;
new Float:g_gs_spawn_override_x = 0.0;
new Float:g_gs_spawn_override_y = 0.0;
new Float:g_gs_spawn_override_z = 0.0;
new Float:g_gs_spawn_override_a = 0.0;

new Float:g_gs_small_slots[][4] =
{
    {-0.053077, 2001.108886, 1554.203125, 178.020202}
};

new Float:g_gs_large_slots[][4] =
{
    {498.1144, 2011.4840, 1546.8634, 224.0546},
    {497.7579, 2007.0754, 1546.8634, 240.1091},
    {497.7836, 2001.9765, 1546.8635, 237.4816},
    {497.8058, 1997.0471, 1546.8635, 234.7068},
    {505.7543, 2011.5400, 1546.8635, 141.9996},
    {505.8538, 2006.7685, 1546.8643, 122.1908},
    {505.2553, 2001.4718, 1546.8635, 120.4099},
    {505.3285, 1997.3212, 1546.8635, 128.2902},
    {505.1429, 1993.1505, 1546.8635, 122.1363},
    {505.2163, 1989.4876, 1546.8635, 118.6312}
};

stock GarageSys_GetWorld(garage_idx)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return -1;
    return GARAGE_SYS_VW_BASE + g_gs_garage[garage_idx][GS_DB_ID];
}

stock GarageSys_GetIndexByDbId(db_id)
{
    if(db_id <= 0) return -1;
    for(new garage_idx = 0; garage_idx < g_gs_loaded; garage_idx++)
    {
        if(g_gs_garage[garage_idx][GS_DB_ID] == db_id) return garage_idx;
    }
    return -1;
}

stock GarageSys_GetPlayerGarage(playerid)
{
    new garage_idx = g_gs_player_owned[playerid];
    if(garage_idx >= 0 && garage_idx < g_gs_loaded &&
       g_gs_garage[garage_idx][GS_OWNER_ID] == GetPlayerAccountID(playerid))
        return garage_idx;

    new account_id = GetPlayerAccountID(playerid);
    for(garage_idx = 0; garage_idx < g_gs_loaded; garage_idx++)
    {
        if(g_gs_garage[garage_idx][GS_OWNER_ID] == account_id)
        {
            g_gs_player_owned[playerid] = garage_idx;
            return garage_idx;
        }
    }
    g_gs_player_owned[playerid] = -1;
    return -1;
}

stock GarageSys_ResolveInside(playerid)
{
    new garage_idx = g_gs_player_inside[playerid];
    if(garage_idx >= 0 && garage_idx < g_gs_loaded &&
       GetPlayerInterior(playerid) == 1 &&
       GetPlayerVirtualWorld(playerid) == GarageSys_GetWorld(garage_idx))
        return garage_idx;

    if(GetPlayerInterior(playerid) != 1)
    {
        g_gs_player_inside[playerid] = -1;
        return -1;
    }

    new db_id = GetPlayerVirtualWorld(playerid) - GARAGE_SYS_VW_BASE;
    garage_idx = GarageSys_GetIndexByDbId(db_id);
    if(garage_idx != -1)
    {
        g_gs_player_inside[playerid] = garage_idx;
        return garage_idx;
    }

    g_gs_player_inside[playerid] = -1;
    return -1;
}

stock GarageSys_GetPlayerSpawn(garage_idx, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    if(floatabs(g_gs_garage[garage_idx][GS_SPAWN_Z]) > 0.001)
    {
        x = g_gs_garage[garage_idx][GS_SPAWN_X];
        y = g_gs_garage[garage_idx][GS_SPAWN_Y];
        z = g_gs_garage[garage_idx][GS_SPAWN_Z];
        a = g_gs_garage[garage_idx][GS_SPAWN_A];
        return 1;
    }
    if(g_gs_garage[garage_idx][GS_IMPROVEMENT] >= 2)
    {
        x = 500.4164; y = 1983.3029; z = 1547.7197; a = 3.5827;
    }
    else
    {
        x = 2.5793; y = 2001.3175; z = 1554.2431; a = 95.4341;
    }
    return 1;
}

stock GarageSys_GetSafeExit(garage_idx, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    if(floatabs(g_gs_garage[garage_idx][GS_SAFE_EXIT_Z]) > 0.001)
    {
        x = g_gs_garage[garage_idx][GS_SAFE_EXIT_X];
        y = g_gs_garage[garage_idx][GS_SAFE_EXIT_Y];
        z = g_gs_garage[garage_idx][GS_SAFE_EXIT_Z];
        a = g_gs_garage[garage_idx][GS_SAFE_EXIT_A];
        return 1;
    }

    new Float:gate_x = g_gs_garage[garage_idx][GS_X];
    new Float:gate_y = g_gs_garage[garage_idx][GS_Y];
    new Float:legacy_x = g_gs_garage[garage_idx][GS_EXIT_X];
    new Float:legacy_y = g_gs_garage[garage_idx][GS_EXIT_Y];
    new Float:dx = legacy_x - gate_x;
    new Float:dy = legacy_y - gate_y;
    new Float:dist_len = floatsqroot(dx * dx + dy * dy);
    a = g_gs_garage[garage_idx][GS_EXIT_A];

    if(dist_len > 0.05)
    {
        dx /= dist_len;
        dy /= dist_len;
        x = legacy_x + dx * GARAGE_SYS_SAFE_EXIT_DISTANCE;
        y = legacy_y + dy * GARAGE_SYS_SAFE_EXIT_DISTANCE;

        new Float:front_x = floatsin(-a, degrees);
        new Float:front_y = floatcos(-a, degrees);
        if(front_x * dx + front_y * dy < 0.0)
        {
            a += 180.0;
            if(a >= 360.0) a -= 360.0;
        }
    }
    else
    {
        x = legacy_x + floatsin(-a, degrees) * GARAGE_SYS_SAFE_EXIT_DISTANCE;
        y = legacy_y + floatcos(-a, degrees) * GARAGE_SYS_SAFE_EXIT_DISTANCE;
    }
    z = g_gs_garage[garage_idx][GS_EXIT_Z] + GARAGE_SYS_SAFE_EXIT_Z_OFFSET;
    return 1;
}

stock GarageSys_GetVehicleExit(garage_idx, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    if(floatabs(g_gs_garage[garage_idx][GS_CAR_EXIT_Z]) > 0.001)
    {
        x = g_gs_garage[garage_idx][GS_CAR_EXIT_X];
        y = g_gs_garage[garage_idx][GS_CAR_EXIT_Y];
        z = g_gs_garage[garage_idx][GS_CAR_EXIT_Z];
        a = g_gs_garage[garage_idx][GS_CAR_EXIT_A];
        return 1;
    }
    return GarageSys_GetSafeExit(garage_idx, x, y, z, a);
}

stock GarageSys_GetSlotTransform(garage_idx, slot_id, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    if(g_gs_garage[garage_idx][GS_IMPROVEMENT] >= 2)
    {
        if(slot_id < 0 || slot_id >= sizeof(g_gs_large_slots)) return 0;
        x = g_gs_large_slots[slot_id][0]; y = g_gs_large_slots[slot_id][1];
        z = g_gs_large_slots[slot_id][2]; a = g_gs_large_slots[slot_id][3];
        return 1;
    }
    if(slot_id < 0 || slot_id >= sizeof(g_gs_small_slots)) return 0;
    x = g_gs_small_slots[slot_id][0]; y = g_gs_small_slots[slot_id][1];
    z = g_gs_small_slots[slot_id][2]; a = g_gs_small_slots[slot_id][3];
    return 1;
}

stock GarageSys_IsSlotOccupied(garage_idx, Float:x, Float:y, Float:z, ignore_vehicle = INVALID_VEHICLE_ID)
{
    new garage_world = GarageSys_GetWorld(garage_idx);
    new Float:vx, Float:vy, Float:vz;
    for(new vehicleid = 1; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        if(vehicleid == ignore_vehicle || !IsValidVehicle(vehicleid)) continue;
        if(GetVehicleVirtualWorld(vehicleid) != garage_world) continue;
        GetVehiclePos(vehicleid, vx, vy, vz);
        if(VectorSize(vx - x, vy - y, vz - z) < 3.25) return 1;
    }
    return 0;
}

stock GarageSys_GetFreeSlot(garage_idx, ignore_vehicle = INVALID_VEHICLE_ID)
{
    new Float:x, Float:y, Float:z, Float:a;
    new max_slots = (g_gs_garage[garage_idx][GS_IMPROVEMENT] >= 2) ? sizeof(g_gs_large_slots) : sizeof(g_gs_small_slots);
    for(new slot_id = 0; slot_id < max_slots; slot_id++)
    {
        if(!GarageSys_GetSlotTransform(garage_idx, slot_id, x, y, z, a)) continue;
        if(!GarageSys_IsSlotOccupied(garage_idx, x, y, z, ignore_vehicle)) return slot_id;
    }
    return -1;
}

stock GarageSys_IsVehicleStored(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return 0;
    new garage_idx = g_gs_vehicle_garage[vehicleid];
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    if(GetVehicleVirtualWorld(vehicleid) != GarageSys_GetWorld(garage_idx))
    {
        g_gs_vehicle_garage[vehicleid] = -1;
        g_gs_vehicle_slot[vehicleid] = -1;
        return 0;
    }
    return 1;
}

stock GarageSys_HasVehicles(garage_idx)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    new garage_world = GarageSys_GetWorld(garage_idx);
    for(new vehicleid = 1; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        if(IsValidVehicle(vehicleid) && GetVehicleVirtualWorld(vehicleid) == garage_world) return 1;
    }
    return 0;
}

stock GarageSys_VehicleHasOccupants(vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    foreach(new playerid : Player)
    {
        if(IsPlayerInVehicle(playerid, vehicleid)) return 1;
    }
    return 0;
}

stock GarageSys_ArmSpawnOverride(sql_id, garage_idx, slot_id)
{
    new Float:x, Float:y, Float:z, Float:a;
    if(sql_id <= 0 || !GarageSys_GetSlotTransform(garage_idx, slot_id, x, y, z, a)) return 0;
    g_gs_spawn_override_active = true;
    g_gs_spawn_override_sql_id = sql_id;
    g_gs_spawn_override_x = x; g_gs_spawn_override_y = y; g_gs_spawn_override_z = z; g_gs_spawn_override_a = a;
    return 1;
}

stock GarageSys_ClearSpawnOverride()
{
    g_gs_spawn_override_active = false;
    g_gs_spawn_override_sql_id = 0;
    g_gs_spawn_override_x = 0.0; g_gs_spawn_override_y = 0.0; g_gs_spawn_override_z = 0.0; g_gs_spawn_override_a = 0.0;
    return 1;
}

stock GarageSys_ConsumeOwnableSpawnOverride(sql_id, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(!g_gs_spawn_override_active || g_gs_spawn_override_sql_id != sql_id) return 0;
    x = g_gs_spawn_override_x; y = g_gs_spawn_override_y; z = g_gs_spawn_override_z; a = g_gs_spawn_override_a;
    GarageSys_ClearSpawnOverride();
    return 1;
}

stock GarageSys_UpdateExitPickup(garage_idx)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    if(g_gs_garage[garage_idx][GS_EXIT_PICKUP] > 0)
        DestroyPickup(g_gs_garage[garage_idx][GS_EXIT_PICKUP]);

    new Float:x, Float:y, Float:z;
    if(g_gs_garage[garage_idx][GS_IMPROVEMENT] >= 2)
    {
        x = 492.912048; y = 1991.464599; z = 1547.679687;
    }
    else
    {
        x = 1.2011; y = 1994.7356; z = 1554.2031;
    }
    g_gs_garage[garage_idx][GS_EXIT_PICKUP] = CreatePickup(1318, 23, x, y, z, GarageSys_GetWorld(garage_idx), GARAGE_SYS_PICKUP_EXIT, garage_idx);
    return 1;
}

stock GarageSys_UpdateLabel(garage_idx)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    new label_text[320];
    if(g_gs_garage[garage_idx][GS_OWNER_ID] > 0)
    {
        format(label_text, sizeof label_text,
            "{FFFFFF}Гараж «{FFA500}№%d{FFFFFF}»\n{FFFFFF}Владелец: {FF5252}%s\n{FFFFFF}Дверь: %s\n{FFFFFF}Цена: {FFA500}%d{FFFFFF} руб.\n{FFFFFF}Въезд на авто: {FFA500}гудок",
            g_gs_garage[garage_idx][GS_DB_ID], g_gs_garage[garage_idx][GS_OWNER_NAME],
            g_gs_garage[garage_idx][GS_LOCKED] ? "{FF5252}закрыта" : "{66CC33}открыта",
            g_gs_garage[garage_idx][GS_PRICE]);
    }
    else
    {
        format(label_text, sizeof label_text,
            "{FFFFFF}Гараж «{FFA500}№%d{FFFFFF}»\n{FFFFFF}Владелец: {FF5252}Отсутствует\n{FFFFFF}Дверь: {66CC33}открыта\n{FFFFFF}Цена: {FFA500}%d{FFFFFF} руб.",
            g_gs_garage[garage_idx][GS_DB_ID], g_gs_garage[garage_idx][GS_PRICE]);
    }
    if(IsValidDynamic3DTextLabel(g_gs_garage[garage_idx][GS_LABEL]))
        UpdateDynamic3DTextLabelText(g_gs_garage[garage_idx][GS_LABEL], 0xFAF2F6AA, label_text);
    return 1;
}

stock GarageSys_DestroyRuntime()
{
    for(new garage_idx = 0; garage_idx < g_gs_loaded; garage_idx++)
    {
        if(g_gs_garage[garage_idx][GS_ENTER_PICKUP] > 0) DestroyPickup(g_gs_garage[garage_idx][GS_ENTER_PICKUP]);
        if(g_gs_garage[garage_idx][GS_EXIT_PICKUP] > 0) DestroyPickup(g_gs_garage[garage_idx][GS_EXIT_PICKUP]);
        if(IsValidDynamic3DTextLabel(g_gs_garage[garage_idx][GS_LABEL])) DestroyDynamic3DTextLabel(g_gs_garage[garage_idx][GS_LABEL]);
        if(g_gs_garage[garage_idx][GS_MAPICON] > 0 && IsValidDynamicMapIcon(g_gs_garage[garage_idx][GS_MAPICON])) DestroyDynamicMapIcon(g_gs_garage[garage_idx][GS_MAPICON]);
        g_gs_garage[garage_idx][GS_MAPICON] = -1;
        g_gs_garage[garage_idx][GS_ENTER_PICKUP] = -1;
        g_gs_garage[garage_idx][GS_EXIT_PICKUP] = -1;
        g_gs_garage[garage_idx][GS_LABEL] = Text3D:-1;
    }
    g_gs_loaded = 0;
    return 1;
}

stock GarageSys_Load()
{
    GarageSys_DestroyRuntime();
    new Cache:result = mysql_query(mysql, "SELECT g.*,IFNULL(a.name,'') AS owner_name FROM garages g LEFT JOIN accounts a ON a.id=g.owner_id ORDER BY g.id ASC", true);
    if(mysql_errno() != 0)
    {
        printf("[GARAGES][ERROR] load failed errno=%d", mysql_errno());
        if(result) cache_delete(result);
        return 0;
    }

    new rows = cache_num_rows();
    if(rows > GARAGE_SYS_MAX) rows = GARAGE_SYS_MAX;
    for(new garage_idx = 0; garage_idx < rows; garage_idx++)
    {
        g_gs_garage[garage_idx][GS_DB_ID] = cache_get_field_content_int(garage_idx, "id");
        g_gs_garage[garage_idx][GS_OWNER_ID] = cache_get_field_content_int(garage_idx, "owner_id");
        g_gs_garage[garage_idx][GS_PRICE] = cache_get_field_content_int(garage_idx, "price");
        if(g_gs_garage[garage_idx][GS_PRICE] <= 0) g_gs_garage[garage_idx][GS_PRICE] = 30000000;
        g_gs_garage[garage_idx][GS_LOCKED] = cache_get_field_content_int(garage_idx, "lock");
        g_gs_garage[garage_idx][GS_X] = cache_get_field_content_float(garage_idx, "x");
        g_gs_garage[garage_idx][GS_Y] = cache_get_field_content_float(garage_idx, "y");
        g_gs_garage[garage_idx][GS_Z] = cache_get_field_content_float(garage_idx, "z");
        g_gs_garage[garage_idx][GS_EXIT_X] = cache_get_field_content_float(garage_idx, "exit_x");
        g_gs_garage[garage_idx][GS_EXIT_Y] = cache_get_field_content_float(garage_idx, "exit_y");
        g_gs_garage[garage_idx][GS_EXIT_Z] = cache_get_field_content_float(garage_idx, "exit_z");
        g_gs_garage[garage_idx][GS_EXIT_A] = cache_get_field_content_float(garage_idx, "exit_angle");
        g_gs_garage[garage_idx][GS_SPAWN_X] = cache_get_field_content_float(garage_idx, "spawn_x");
        g_gs_garage[garage_idx][GS_SPAWN_Y] = cache_get_field_content_float(garage_idx, "spawn_y");
        g_gs_garage[garage_idx][GS_SPAWN_Z] = cache_get_field_content_float(garage_idx, "spawn_z");
        g_gs_garage[garage_idx][GS_SPAWN_A] = cache_get_field_content_float(garage_idx, "spawn_angle");
        g_gs_garage[garage_idx][GS_SAFE_EXIT_X] = cache_get_field_content_float(garage_idx, "safe_exit_x");
        g_gs_garage[garage_idx][GS_SAFE_EXIT_Y] = cache_get_field_content_float(garage_idx, "safe_exit_y");
        g_gs_garage[garage_idx][GS_SAFE_EXIT_Z] = cache_get_field_content_float(garage_idx, "safe_exit_z");
        g_gs_garage[garage_idx][GS_SAFE_EXIT_A] = cache_get_field_content_float(garage_idx, "safe_exit_angle");
        g_gs_garage[garage_idx][GS_CAR_EXIT_X] = cache_get_field_content_float(garage_idx, "vehicle_exit_x");
        g_gs_garage[garage_idx][GS_CAR_EXIT_Y] = cache_get_field_content_float(garage_idx, "vehicle_exit_y");
        g_gs_garage[garage_idx][GS_CAR_EXIT_Z] = cache_get_field_content_float(garage_idx, "vehicle_exit_z");
        g_gs_garage[garage_idx][GS_CAR_EXIT_A] = cache_get_field_content_float(garage_idx, "vehicle_exit_angle");
        g_gs_garage[garage_idx][GS_IMPROVEMENT] = cache_get_field_content_int(garage_idx, "improvements");
        if(g_gs_garage[garage_idx][GS_IMPROVEMENT] < 1) g_gs_garage[garage_idx][GS_IMPROVEMENT] = 1;
        g_gs_garage[garage_idx][GS_RENT_DATE] = cache_get_field_content_int(garage_idx, "rent_time");
        cache_get_field_content(garage_idx, "owner_name", g_gs_garage[garage_idx][GS_OWNER_NAME], mysql, 21);

        // Orphan ownership must not leave an unbuyable garage.
        if(g_gs_garage[garage_idx][GS_OWNER_ID] > 0 && !strlen(g_gs_garage[garage_idx][GS_OWNER_NAME]))
        {
            new repair_query[160];
            mysql_format(mysql, repair_query, sizeof repair_query, "UPDATE garages SET owner_id=0,`lock`=0 WHERE id=%d LIMIT 1", g_gs_garage[garage_idx][GS_DB_ID]);
            mysql_query(mysql, repair_query, false);
            g_gs_garage[garage_idx][GS_OWNER_ID] = 0;
            g_gs_garage[garage_idx][GS_LOCKED] = 0;
        }
        if(!strlen(g_gs_garage[garage_idx][GS_OWNER_NAME])) format(g_gs_garage[garage_idx][GS_OWNER_NAME], 21, "None");

        g_gs_garage[garage_idx][GS_ENTER_PICKUP] = CreatePickup(19134, 23,
            g_gs_garage[garage_idx][GS_X], g_gs_garage[garage_idx][GS_Y], g_gs_garage[garage_idx][GS_Z],
            0, GARAGE_SYS_PICKUP_ENTER, garage_idx);

        new label_text[320];
        format(label_text, sizeof label_text, "Garage #%d", g_gs_garage[garage_idx][GS_DB_ID]);
        g_gs_garage[garage_idx][GS_LABEL] = CreateDynamic3DTextLabel(label_text, 0xFAF2F6AA,
            g_gs_garage[garage_idx][GS_X], g_gs_garage[garage_idx][GS_Y], g_gs_garage[garage_idx][GS_Z] + 1.0, 15.0);
        g_gs_garage[garage_idx][GS_MAPICON] = CreateDynamicMapIcon(
            g_gs_garage[garage_idx][GS_X], g_gs_garage[garage_idx][GS_Y], g_gs_garage[garage_idx][GS_Z],
            GARAGE_SYS_MAPICON_TYPE, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
        g_gs_garage[garage_idx][GS_EXIT_PICKUP] = -1;
    }
    g_gs_loaded = rows;
    cache_delete(result);

    for(new garage_idx = 0; garage_idx < g_gs_loaded; garage_idx++)
    {
        GarageSys_UpdateExitPickup(garage_idx);
        GarageSys_UpdateLabel(garage_idx);
    }
    printf("[GARAGES] loaded=%d vw_base=%d", g_gs_loaded, GARAGE_SYS_VW_BASE);
    return 1;
}

stock GarageSys_Init()
{
    new query[4096];
    format(query, sizeof query,
        "CREATE TABLE IF NOT EXISTS `garages` ("\
        "`id` INT NOT NULL AUTO_INCREMENT,"\
        "`owner_id` INT NOT NULL DEFAULT 0,"\
        "`price` INT NOT NULL DEFAULT 30000000,"\
        "`lock` INT NOT NULL DEFAULT 0,"\
        "`x` FLOAT NOT NULL DEFAULT 0,`y` FLOAT NOT NULL DEFAULT 0,`z` FLOAT NOT NULL DEFAULT 0,"\
        "`exit_x` FLOAT NOT NULL DEFAULT 0,`exit_y` FLOAT NOT NULL DEFAULT 0,`exit_z` FLOAT NOT NULL DEFAULT 0,`exit_angle` FLOAT NOT NULL DEFAULT 0,"\
        "`spawn_x` FLOAT NOT NULL DEFAULT 0,`spawn_y` FLOAT NOT NULL DEFAULT 0,`spawn_z` FLOAT NOT NULL DEFAULT 0,`spawn_angle` FLOAT NOT NULL DEFAULT 0,"\
        "`safe_exit_x` FLOAT NOT NULL DEFAULT 0,`safe_exit_y` FLOAT NOT NULL DEFAULT 0,`safe_exit_z` FLOAT NOT NULL DEFAULT 0,`safe_exit_angle` FLOAT NOT NULL DEFAULT 0,"\
        "`vehicle_exit_x` FLOAT NOT NULL DEFAULT 0,`vehicle_exit_y` FLOAT NOT NULL DEFAULT 0,`vehicle_exit_z` FLOAT NOT NULL DEFAULT 0,`vehicle_exit_angle` FLOAT NOT NULL DEFAULT 0,"\
        "`improvements` INT NOT NULL DEFAULT 1,`rent_time` INT NOT NULL DEFAULT 0,PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8");
    mysql_query(mysql, query, false);
    if(mysql_errno() != 0) return printf("[GARAGES][ERROR] create table errno=%d", mysql_errno()), 0;

    // Upgrade old garages.pwn databases in-place. Current project already uses this MariaDB/MySQL syntax.
    mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `garage` INT NOT NULL DEFAULT -1", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `price` INT NOT NULL DEFAULT 30000000", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `spawn_x` FLOAT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `spawn_y` FLOAT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `spawn_z` FLOAT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `spawn_angle` FLOAT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `safe_exit_x` FLOAT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `safe_exit_y` FLOAT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `safe_exit_z` FLOAT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `safe_exit_angle` FLOAT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `vehicle_exit_x` FLOAT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `vehicle_exit_y` FLOAT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `vehicle_exit_z` FLOAT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `vehicle_exit_angle` FLOAT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `improvements` INT NOT NULL DEFAULT 1", false);
    mysql_query(mysql, "ALTER TABLE `garages` ADD COLUMN IF NOT EXISTS `rent_time` INT NOT NULL DEFAULT 0", false);

    new Cache:count_result = mysql_query(mysql, "SELECT COUNT(*) AS cnt FROM garages", true);
    new garage_count = 0;
    if(!mysql_errno() && cache_num_rows() > 0) garage_count = cache_get_field_content_int(0, "cnt");
    cache_delete(count_result);

    if(garage_count == 0)
    {
        format(query, sizeof query,
            "INSERT INTO `garages` (`id`,`owner_id`,`price`,`lock`,`x`,`y`,`z`,`exit_x`,`exit_y`,`exit_z`,`exit_angle`,`improvements`) VALUES "\
            "(1,0,30000000,0,353.404,800.074,12.0,350.682,800.797,12.0,69.381,1),"\
            "(2,0,30000000,0,354.905,804.006,12.0,352.324,804.991,12.0,66.7752,1),"\
            "(3,0,30000000,0,356.451,808.065,12.0073,353.898,808.920,12.0073,66.5632,1),"\
            "(4,0,30000000,0,357.905,811.891,12.0073,355.276,813.422,12.0073,67.9254,1),"\
            "(5,0,30000000,0,359.422,815.865,12.0,356.466,816.753,12.0073,65.2152,1),"\
            "(6,0,30000000,0,360.909,819.765,12.0,358.047,820.573,12.0,72.5789,1),"\
            "(7,0,30000000,0,362.431,823.763,12.0,360.489,824.517,12.0,64.0241,1),"\
            "(8,0,30000000,0,363.940,827.730,12.0,361.112,828.732,12.0,71.2634,1),"\
            "(9,0,30000000,0,365.421,831.631,12.0085,362.630,832.608,12.0,70.8588,1)");
        mysql_query(mysql, query, false);
        if(mysql_errno() != 0) printf("[GARAGES][ERROR] default insert errno=%d", mysql_errno());
    }

    g_gs_ready = bool:GarageSys_Load();
    return g_gs_ready;
}

stock GarageSys_SyncPlayer(playerid)
{
    g_gs_player_owned[playerid] = -1;
    if(!g_gs_ready || !IsPlayerConnected(playerid)) return 0;
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new chosen_idx = -1;
    for(new garage_idx = 0; garage_idx < g_gs_loaded; garage_idx++)
    {
        if(g_gs_garage[garage_idx][GS_OWNER_ID] != account_id) continue;
        if(chosen_idx == -1)
        {
            chosen_idx = garage_idx;
            continue;
        }

        // One account can own one garage. Repair duplicates left by old builds.
        new fix_query[160];
        mysql_format(mysql, fix_query, sizeof fix_query, "UPDATE garages SET owner_id=0,`lock`=0 WHERE id=%d LIMIT 1", g_gs_garage[garage_idx][GS_DB_ID]);
        mysql_query(mysql, fix_query, false);
        g_gs_garage[garage_idx][GS_OWNER_ID] = 0;
        g_gs_garage[garage_idx][GS_LOCKED] = 0;
        format(g_gs_garage[garage_idx][GS_OWNER_NAME], 21, "None");
        GarageSys_UpdateLabel(garage_idx);
    }

    g_gs_player_owned[playerid] = chosen_idx;
    new db_id = -1;
    if(chosen_idx != -1) db_id = g_gs_garage[chosen_idx][GS_DB_ID];
    new query[128];
    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET garage=%d WHERE id=%d LIMIT 1", db_id, account_id);
    mysql_query(mysql, query, false);
    return 1;
}

stock GarageSys_SyncAllPlayers()
{
    foreach(new playerid : Player)
    {
        if(IsPlayerLogged(playerid)) GarageSys_SyncPlayer(playerid);
    }
    return 1;
}

stock GarageSys_IsAccessAllowed(playerid, garage_idx)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    if(g_gs_garage[garage_idx][GS_OWNER_ID] == GetPlayerAccountID(playerid)) return 1;
    return !g_gs_garage[garage_idx][GS_LOCKED];
}

stock GarageSys_GetNearestEntrance(playerid, Float:range = 12.0)
{
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return -1;
    for(new garage_idx = 0; garage_idx < g_gs_loaded; garage_idx++)
    {
        if(IsPlayerInRangeOfPoint(playerid, range, g_gs_garage[garage_idx][GS_X], g_gs_garage[garage_idx][GS_Y], g_gs_garage[garage_idx][GS_Z]))
            return garage_idx;
    }
    return -1;
}

stock GarageSys_GetNearestVehicleEntrance(playerid, Float:range = 18.0)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return -1;
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return -1;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return -1;

    new Float:x, Float:y, Float:z;
    GetVehiclePos(vehicleid, x, y, z);
    for(new garage_idx = 0; garage_idx < g_gs_loaded; garage_idx++)
    {
        new Float:dx = x - g_gs_garage[garage_idx][GS_X];
        new Float:dy = y - g_gs_garage[garage_idx][GS_Y];
        new Float:dz = z - g_gs_garage[garage_idx][GS_Z];
        if((dx * dx + dy * dy + dz * dz) <= (range * range)) return garage_idx;
    }
    return -1;
}

stock GarageSys_EnterPlayer(playerid, garage_idx)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    if(!GarageSys_IsAccessAllowed(playerid, garage_idx)) return 0;
    new Float:x, Float:y, Float:z, Float:a;
    if(!GarageSys_GetPlayerSpawn(garage_idx, x, y, z, a)) return 0;
    g_gs_player_inside[playerid] = garage_idx;
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, GarageSys_GetWorld(garage_idx));
    SetPlayerPos(playerid, x, y, z);
    SetPlayerFacingAngle(playerid, a);
    SetCameraBehindPlayer(playerid);
    Streamer_Update(playerid);
    return 1;
}

stock GarageSys_ExitPlayer(playerid, garage_idx)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    if(IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Для выезда на машине используйте гудок у ворот внутри гаража."), 1;
    new Float:x, Float:y, Float:z, Float:a;
    if(!GarageSys_GetSafeExit(garage_idx, x, y, z, a)) return 0;
    g_gs_player_inside[playerid] = -1;
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    SetPlayerPos(playerid, x, y, z);
    SetPlayerFacingAngle(playerid, a);
    SetCameraBehindPlayer(playerid);
    Streamer_Update(playerid);
    return 1;
}

stock GarageSys_MoveVehicleInside(vehicleid, garage_idx)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    new slot_id = GarageSys_GetFreeSlot(garage_idx, vehicleid);
    if(slot_id == -1) return 0;
    new Float:x, Float:y, Float:z, Float:a;
    if(!GarageSys_GetSlotTransform(garage_idx, slot_id, x, y, z, a)) return 0;

    new garage_world = GarageSys_GetWorld(garage_idx);
    SetVehicleVirtualWorld(vehicleid, garage_world);
    LinkVehicleToInterior(vehicleid, 1);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehiclePos(vehicleid, x, y, z);
    SetVehicleZAngle(vehicleid, a);
    SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
    g_gs_vehicle_garage[vehicleid] = garage_idx;
    g_gs_vehicle_slot[vehicleid] = slot_id;

    foreach(new targetid : Player)
    {
        if(!IsPlayerInVehicle(targetid, vehicleid)) continue;
        SetPlayerInterior(targetid, 1);
        SetPlayerVirtualWorld(targetid, garage_world);
        g_gs_player_inside[targetid] = garage_idx;
        SetCameraBehindPlayer(targetid);
    }
    return 1;
}

stock GarageSys_ExitVehicle(playerid, garage_idx)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    new Float:x, Float:y, Float:z, Float:a;
    if(!GarageSys_GetVehicleExit(garage_idx, x, y, z, a)) return 0;

    g_gs_vehicle_garage[vehicleid] = -1;
    g_gs_vehicle_slot[vehicleid] = -1;
    SetVehicleVirtualWorld(vehicleid, 0);
    LinkVehicleToInterior(vehicleid, 0);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehiclePos(vehicleid, x, y, z);
    SetVehicleZAngle(vehicleid, a);

    foreach(new targetid : Player)
    {
        if(!IsPlayerInVehicle(targetid, vehicleid)) continue;
        SetPlayerVirtualWorld(targetid, 0);
        SetPlayerInterior(targetid, 0);
        g_gs_player_inside[targetid] = -1;
        SetCameraBehindPlayer(targetid);
    }
    return 1;
}

stock GarageSys_ShowEntrance(playerid, garage_idx)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    g_gs_dialog_garage[playerid] = garage_idx;
    new dialog_text[512];
    if(g_gs_garage[garage_idx][GS_OWNER_ID] <= 0)
    {
        format(dialog_text, sizeof dialog_text,
            "{FFFFFF}Гараж №{FFFF00}%d{FFFFFF} свободен.\n\nСтоимость: {66CC33}%d руб.\nВместимость: 1 автомобиль.\nПосле покупки гараж можно улучшить до 10 мест.",
            g_gs_garage[garage_idx][GS_DB_ID], g_gs_garage[garage_idx][GS_PRICE]);
        Dialog(playerid, DIALOG_GS_BUY, DIALOG_STYLE_MSGBOX, "{FFFF00}Покупка гаража", dialog_text, "Купить", "Закрыть");
        return 1;
    }

    if(!GarageSys_IsAccessAllowed(playerid, garage_idx))
    {
        format(dialog_text, sizeof dialog_text, "Гараж №%d закрыт. Владелец: %s", g_gs_garage[garage_idx][GS_DB_ID], g_gs_garage[garage_idx][GS_OWNER_NAME]);
        return SendClientMessage(playerid, 0xCC3333FF, dialog_text), 1;
    }

    format(dialog_text, sizeof dialog_text,
        "{FFFFFF}Гараж №{FFFF00}%d\n{FFFFFF}Владелец: {FFFF00}%s\n{FFFFFF}Статус: %s\n\nВойти в гараж?",
        g_gs_garage[garage_idx][GS_DB_ID], g_gs_garage[garage_idx][GS_OWNER_NAME],
        g_gs_garage[garage_idx][GS_LOCKED] ? "{FF5252}закрыт" : "{66CC33}открыт");
    Dialog(playerid, DIALOG_GS_ENTER, DIALOG_STYLE_MSGBOX, "{FFFF00}Гараж", dialog_text, "Войти", "Закрыть");
    return 1;
}

stock GarageSys_ShowInfo(playerid)
{
    new garage_idx = GarageSys_GetPlayerGarage(playerid);
    if(garage_idx == -1) return SendClientMessage(playerid, 0x999999FF, "У Вас нет гаража"), 1;
    new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1], dialog_text[800];
    GetCityName(g_gs_garage[garage_idx][GS_X], g_gs_garage[garage_idx][GS_Y], city);
    GetAreaName(g_gs_garage[garage_idx][GS_X], g_gs_garage[garage_idx][GS_Y], area);
    new slots_count = (g_gs_garage[garage_idx][GS_IMPROVEMENT] >= 2) ? 10 : 1;
    format(dialog_text, sizeof dialog_text,
        "{FFFFFF}Номер гаража:\t{FFFF00}%d\n"\
        "{FFFFFF}Владелец:\t%s\n"\
        "{FFFFFF}Город / область:\t%s\n"\
        "{FFFFFF}Район:\t%s\n"\
        "{FFFFFF}Гос. стоимость:\t%d руб.\n"\
        "{FFFFFF}Вместимость:\t%d авто\n"\
        "{FFFFFF}Статус:\t%s",
        g_gs_garage[garage_idx][GS_DB_ID], g_gs_garage[garage_idx][GS_OWNER_NAME], city, area,
        g_gs_garage[garage_idx][GS_PRICE], slots_count,
        g_gs_garage[garage_idx][GS_LOCKED] ? "{CC3333}закрыт" : "{66CC33}открыт");
    Dialog(playerid, DIALOG_GS_INFO, DIALOG_STYLE_MSGBOX, "{33AACC}Информация о гараже", dialog_text, "Управление", "Закрыть");
    return 1;
}

stock GarageSys_ShowSettings(playerid)
{
    new garage_idx = GarageSys_GetPlayerGarage(playerid);
    if(garage_idx == -1) return 0;
    new menu_text[600];
    format(menu_text, sizeof menu_text,
        "%s гараж\n"\
        "Продать гараж государству\n"\
        "Улучшить гараж до 10 мест\n"\
        "Доставить личный транспорт в гараж\n"\
        "Отметить гараж на GPS\n"\
        "Продать гараж другому игроку",
        g_gs_garage[garage_idx][GS_LOCKED] ? "Открыть" : "Закрыть");
    Dialog(playerid, DIALOG_GS_SETTINGS, DIALOG_STYLE_LIST, "{FFFF00}Управление гаражем", menu_text, "Выбрать", "Назад");
    return 1;
}

stock GarageSys_ShowCarList(playerid)
{
    new garage_idx = GarageSys_GetPlayerGarage(playerid);
    if(garage_idx == -1) return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет гаража"), 1;
    new query[160];
    mysql_format(mysql, query, sizeof query, "SELECT id,model_id,number FROM ownable_cars WHERE owner_id=%d ORDER BY id ASC", GetPlayerAccountID(playerid));
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno() != 0)
    {
        cache_delete(result);
        return SendClientMessage(playerid, 0xCECECEFF, "Ошибка БД при загрузке транспорта"), 1;
    }
    new rows = cache_num_rows();
    if(rows <= 0)
    {
        cache_delete(result);
        return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет личного транспорта"), 1;
    }

    ClearPlayerListitemValues(playerid);
    new list_text[4096], row_text[128], model_name[32], plate[32];
    format(list_text, sizeof list_text, "Авто\tНомер\n");
    new shown = 0;
    for(new row_id = 0; row_id < rows && shown < 40; row_id++)
    {
        new sql_id = cache_get_field_content_int(row_id, "id");
        new model_id = cache_get_field_content_int(row_id, "model_id");
        cache_get_field_content(row_id, "number", plate, mysql, sizeof plate);
        GetVehicleModelName(model_id, model_name, sizeof model_name);
        format(row_text, sizeof row_text, "%s\t%s\n", model_name, plate);
        strcat(list_text, row_text);
        SetPlayerListitemValue(playerid, shown, sql_id);
        shown++;
    }
    cache_delete(result);
    SetPVarInt(playerid, "gs_delivery_garage", garage_idx);
    Dialog(playerid, DIALOG_GS_CAR_SELECT, DIALOG_STYLE_TABLIST_HEADERS, "{FFFF00}Доставка транспорта", list_text, "Доставить", "Назад");
    return 1;
}

stock GarageSys_DeliverCar(playerid, sql_id, garage_idx)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded || g_gs_garage[garage_idx][GS_OWNER_ID] != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Гараж не найден или больше Вам не принадлежит"), 1;
    if(sql_id <= 0) return 1;

    new query[160];
    mysql_format(mysql, query, sizeof query, "SELECT id FROM ownable_cars WHERE id=%d AND owner_id=%d LIMIT 1", sql_id, GetPlayerAccountID(playerid));
    new Cache:result = mysql_query(mysql, query, true);
    new bool:owned_car = (!mysql_errno() && cache_num_rows() > 0);
    cache_delete(result);
    if(!owned_car) return SendClientMessage(playerid, 0xCECECEFF, "Этот транспорт Вам не принадлежит"), 1;

    new vehicleid = GetOwnableCarBySqlID(sql_id);
    if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
    {
        if(GarageSys_VehicleHasOccupants(vehicleid))
            return SendClientMessage(playerid, 0xCECECEFF, "Выбранный транспорт занят. Сначала выйдите из него."), 1;
        if(UnloadOwnableCarBySqlID(playerid, sql_id) != 1)
            return SendClientMessage(playerid, 0xCECECEFF, "Не удалось выгрузить выбранный транспорт."), 1;
    }

    new current_vehicle = GetPlayerOwnableCar(playerid);
    if(current_vehicle != INVALID_VEHICLE_ID && IsValidVehicle(current_vehicle))
    {
        if(GarageSys_VehicleHasOccupants(current_vehicle))
            return SendClientMessage(playerid, 0xCECECEFF, "Ваш загруженный транспорт занят. Сначала выйдите из него."), 1;
        if(UnloadPlayerOwnableCar(playerid, true) != 1)
            return SendClientMessage(playerid, 0xCECECEFF, "Не удалось выгрузить текущий транспорт."), 1;
    }

    new slot_id = GarageSys_GetFreeSlot(garage_idx, INVALID_VEHICLE_ID);
    if(slot_id == -1) return SendClientMessage(playerid, 0xCECECEFF, "В гараже нет свободного места."), 1;
    if(!GarageSys_ArmSpawnOverride(sql_id, garage_idx, slot_id)) return 1;
    new load_result = LoadOwnableCar(sql_id);
    GarageSys_ClearSpawnOverride();
    if(load_result == -1) return SendClientMessage(playerid, 0xCECECEFF, "Ошибка загрузки транспорта."), 1;

    vehicleid = GetOwnableCarBySqlID(sql_id);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "Транспорт не был создан."), 1;

    new Float:x, Float:y, Float:z, Float:a;
    GarageSys_GetSlotTransform(garage_idx, slot_id, x, y, z, a);
    LinkVehicleToInterior(vehicleid, 1);
    SetVehicleVirtualWorld(vehicleid, GarageSys_GetWorld(garage_idx));
    SetVehiclePos(vehicleid, x, y, z);
    SetVehicleZAngle(vehicleid, a);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
    g_gs_vehicle_garage[vehicleid] = garage_idx;
    g_gs_vehicle_slot[vehicleid] = slot_id;
    SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);
    SetPVarInt(playerid, "ownable_vehicle_id", vehicleid);

    // Performance is server-side. Visual tuning is left to the existing safe
    // OnVehicleStreamIn path when the player actually enters this garage world.
    TechCenter_ApplyPerformance(vehicleid);
    printf("[GARAGES][DELIVERY] player=%d garage_db=%d car_sql=%d vehicle=%d slot=%d", playerid, g_gs_garage[garage_idx][GS_DB_ID], sql_id, vehicleid, slot_id);
    return SendClientMessage(playerid, 0x66CC33FF, "Транспорт доставлен в Ваш гараж."), 1;
}

stock GarageSys_Buy(playerid, garage_idx)
{
    if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 0;
    if(g_gs_garage[garage_idx][GS_OWNER_ID] > 0) return SendClientMessage(playerid, 0xCECECEFF, "Этот гараж уже куплен."), 1;
    if(GarageSys_GetPlayerGarage(playerid) != -1) return SendClientMessage(playerid, 0xCECECEFF, "У Вас уже есть гараж."), 1;
    new price = g_gs_garage[garage_idx][GS_PRICE];
    if(GetPlayerMoneyEx(playerid) < price) return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег для покупки гаража."), 1;

    new query[256];
    new rent_time = (gettime() - (gettime() % 86400)) + 86400;
    mysql_query(mysql, "START TRANSACTION", false);
    if(mysql_errno()) return SendClientMessage(playerid, 0xFF5252FF, "Ошибка БД при покупке гаража."), 1;
    mysql_format(mysql, query, sizeof query,
        "UPDATE garages SET owner_id=%d,`lock`=0,rent_time=%d WHERE id=%d AND owner_id=0 LIMIT 1",
        GetPlayerAccountID(playerid), rent_time, g_gs_garage[garage_idx][GS_DB_ID]);
    if(!AuctionDatabaseExecuteAffected(query))
    {
        mysql_query(mysql, "ROLLBACK", false);
        return SendClientMessage(playerid, 0xFF5252FF, "Гараж уже куплен либо не удалось сохранить владельца."), 1;
    }
    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET garage=%d WHERE id=%d LIMIT 1", g_gs_garage[garage_idx][GS_DB_ID], GetPlayerAccountID(playerid));
    if(!AuctionDatabaseExecuteAffected(query))
    {
        mysql_query(mysql, "ROLLBACK", false);
        return SendClientMessage(playerid, 0xFF5252FF, "Не удалось сохранить гараж в аккаунте."), 1;
    }
    mysql_query(mysql, "COMMIT", false);
    if(mysql_errno()) return SendClientMessage(playerid, 0xFF5252FF, "Ошибка завершения покупки гаража."), 1;

    GivePlayerMoneyEx(playerid, -price, "Покупка гаража", false, true);
    g_gs_garage[garage_idx][GS_OWNER_ID] = GetPlayerAccountID(playerid);
    g_gs_garage[garage_idx][GS_LOCKED] = 0;
    g_gs_garage[garage_idx][GS_RENT_DATE] = rent_time;
    format(g_gs_garage[garage_idx][GS_OWNER_NAME], 21, "%s", GetPlayerNameEx(playerid));
    g_gs_player_owned[playerid] = garage_idx;
    GarageSys_UpdateLabel(garage_idx);
    SendClientMessage(playerid, 0x66CC33FF, "Поздравляем! Вы купили гараж. Управление: /garage");
    GarageSys_EnterPlayer(playerid, garage_idx);
    return 1;
}

stock GarageSys_SellToState(playerid)
{
    new garage_idx = GarageSys_GetPlayerGarage(playerid);
    if(garage_idx == -1) return 0;
    if(GarageSys_HasVehicles(garage_idx)) return SendClientMessage(playerid, 0xCECECEFF, "Сначала выведите или выгрузите весь транспорт из гаража."), 1;
    new refund = (g_gs_garage[garage_idx][GS_PRICE] * 70) / 100;
    AddPlayerData(playerid, P_BANK, +, refund);
    UpdatePlayerDatabaseInt(playerid, "bank", GetPlayerData(playerid, P_BANK));
    BankLog(playerid, refund, "Продажа гаража государству");

    new query[256];
    mysql_format(mysql, query, sizeof query, "UPDATE garages SET owner_id=0,`lock`=0,improvements=1 WHERE id=%d LIMIT 1", g_gs_garage[garage_idx][GS_DB_ID]);
    mysql_query(mysql, query, false);
    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET garage=-1 WHERE id=%d LIMIT 1", GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);

    g_gs_garage[garage_idx][GS_OWNER_ID] = 0;
    g_gs_garage[garage_idx][GS_LOCKED] = 0;
    g_gs_garage[garage_idx][GS_IMPROVEMENT] = 1;
    format(g_gs_garage[garage_idx][GS_OWNER_NAME], 21, "None");
    g_gs_player_owned[playerid] = -1;
    GarageSys_UpdateExitPickup(garage_idx);
    GarageSys_UpdateLabel(garage_idx);
    new msg[160];
    format(msg, sizeof msg, "Гараж продан государству. На банковский счёт зачислено %d руб. (70%% стоимости).", refund);
    SendClientMessage(playerid, 0x66CC33FF, msg);
    return 1;
}

stock GarageSys_TransferGarage(sellerid, buyerid, garage_db_id, price)
{
    new garage_idx = GarageSys_GetIndexByDbId(garage_db_id);
    if(garage_idx == -1 || !IsPlayerConnected(sellerid) || !IsPlayerConnected(buyerid)) return 0;
    if(g_gs_garage[garage_idx][GS_OWNER_ID] != GetPlayerAccountID(sellerid))
        return SendClientMessage(buyerid, 0xCECECEFF, "Продавец больше не владеет этим гаражом."), 0;
    if(GarageSys_GetPlayerGarage(buyerid) != -1)
        return SendClientMessage(buyerid, 0xCECECEFF, "У Вас уже есть гараж."), 0;
    if(price < 1 || GetPlayerMoneyEx(buyerid) < price)
        return SendClientMessage(buyerid, 0xCECECEFF, "Недостаточно денег для покупки гаража."), 0;
    if(GarageSys_HasVehicles(garage_idx))
        return SendClientMessage(buyerid, 0xCECECEFF, "В гараже остался транспорт. Сделка отменена."), 0;
    if(!IsPlayerInRangeOfPoint(sellerid, 8.0, g_gs_garage[garage_idx][GS_X], g_gs_garage[garage_idx][GS_Y], g_gs_garage[garage_idx][GS_Z]) ||
       !IsPlayerInRangeOfPoint(buyerid, 8.0, g_gs_garage[garage_idx][GS_X], g_gs_garage[garage_idx][GS_Y], g_gs_garage[garage_idx][GS_Z]))
        return SendClientMessage(buyerid, 0xCECECEFF, "Вы оба должны находиться рядом с продаваемым гаражом."), 0;

    new query[320];
    mysql_format(mysql, query, sizeof query, "UPDATE garages SET owner_id=%d WHERE id=%d AND owner_id=%d LIMIT 1", GetPlayerAccountID(buyerid), garage_db_id, GetPlayerAccountID(sellerid));
    mysql_query(mysql, query, false);
    if(mysql_errno() != 0) return SendClientMessage(buyerid, 0xFF5252FF, "Ошибка БД при продаже гаража."), 0;
    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET garage=-1 WHERE id=%d LIMIT 1", GetPlayerAccountID(sellerid));
    mysql_query(mysql, query, false);
    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET garage=%d WHERE id=%d LIMIT 1", garage_db_id, GetPlayerAccountID(buyerid));
    mysql_query(mysql, query, false);

    GivePlayerMoneyEx(buyerid, -price, "Покупка гаража у игрока", false, true);
    GivePlayerMoneyEx(sellerid, price, "Продажа гаража игроку", false, false);
    g_gs_garage[garage_idx][GS_OWNER_ID] = GetPlayerAccountID(buyerid);
    format(g_gs_garage[garage_idx][GS_OWNER_NAME], 21, "%s", GetPlayerNameEx(buyerid));
    g_gs_player_owned[sellerid] = -1;
    g_gs_player_owned[buyerid] = garage_idx;
    GarageSys_UpdateLabel(garage_idx);
    SendClientMessage(sellerid, 0x66CC33FF, "Сделка завершена: гараж продан игроку.");
    SendClientMessage(buyerid, 0x66CC33FF, "Сделка завершена: теперь гараж принадлежит Вам. /garage");
    return 1;
}

stock GarageSys_Upgrade(playerid)
{
    new garage_idx = GarageSys_GetPlayerGarage(playerid);
    if(garage_idx == -1) return 0;
    if(g_gs_garage[garage_idx][GS_IMPROVEMENT] >= 2) return SendClientMessage(playerid, 0x999999FF, "Гараж уже улучшен до 10 мест."), 1;
    if(GarageSys_ResolveInside(playerid) != -1) return SendClientMessage(playerid, 0xCECECEFF, "Для ремонта выйдите из гаража на улицу."), 1;
    if(GarageSys_HasVehicles(garage_idx)) return SendClientMessage(playerid, 0xCECECEFF, "Перед ремонтом уберите весь транспорт из гаража."), 1;
    if(GetPlayerMoneyEx(playerid) < GARAGE_SYS_UPGRADE_PRICE) return SendClientMessage(playerid, 0xCECECEFF, "Для улучшения нужно 5.000.000 руб."), 1;

    GivePlayerMoneyEx(playerid, -GARAGE_SYS_UPGRADE_PRICE, "Улучшение гаража", false, true);
    g_gs_garage[garage_idx][GS_IMPROVEMENT] = 2;
    new query[128];
    mysql_format(mysql, query, sizeof query, "UPDATE garages SET improvements=2 WHERE id=%d LIMIT 1", g_gs_garage[garage_idx][GS_DB_ID]);
    mysql_query(mysql, query, false);
    GarageSys_UpdateExitPickup(garage_idx);
    SendClientMessage(playerid, 0x66CC33FF, "Гараж улучшен. Теперь в нём 10 парковочных мест.");
    return 1;
}

stock GarageSys_OnPickup(playerid, pickupid, action_type, action_id)
{
    #pragma unused pickupid
    if(action_type == GARAGE_SYS_PICKUP_ENTER)
    {
        if(action_id < 0 || action_id >= g_gs_loaded) return 1;
        return GarageSys_ShowEntrance(playerid, action_id);
    }
    if(action_type == GARAGE_SYS_PICKUP_EXIT)
    {
        new garage_idx = GarageSys_ResolveInside(playerid);
        if(garage_idx == -1 || garage_idx != action_id) return 1;
        return GarageSys_ExitPlayer(playerid, garage_idx);
    }
    return 0;
}

stock GarageSys_OnKeyStateChange(playerid, newkeys, oldkeys)
{
    #pragma unused oldkeys
    // Mobile clients may report the horn as an already-held key, so an edge-only
    // check misses it. A short cooldown still makes one horn press one action.
    if(!(newkeys & KEY_CROUCH)) return 0;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
    if(GetPVarInt(playerid, "garage_horn_cd") > GetTickCount()) return 0;

    new garage_idx = GarageSys_ResolveInside(playerid);
    if(garage_idx != -1)
    {
        new bool:near_exit = false;
        if(g_gs_garage[garage_idx][GS_IMPROVEMENT] >= 2)
            near_exit = bool:IsPlayerInRangeOfPoint(playerid, 9.0, 492.663848, 1988.835205, 1548.586645);
        else
            near_exit = bool:IsPlayerInRangeOfPoint(playerid, 9.0, -0.2940, 2006.1188, 1554.2031);
        if(near_exit)
        {
            SetPVarInt(playerid, "garage_horn_cd", GetTickCount() + 800);
            return GarageSys_ExitVehicle(playerid, garage_idx);
        }
        return 0;
    }

    garage_idx = GarageSys_GetNearestVehicleEntrance(playerid);
    if(garage_idx == -1 || g_gs_garage[garage_idx][GS_OWNER_ID] <= 0) return 0;
    if(!GarageSys_IsAccessAllowed(playerid, garage_idx))
        return SendClientMessage(playerid, 0xCC3333FF, "Гараж закрыт. Въезд разрешён только владельцу."), 1;
    if(!GarageSys_MoveVehicleInside(GetPlayerVehicleID(playerid), garage_idx))
        return SendClientMessage(playerid, 0xCECECEFF, "В гараже нет свободного парковочного места."), 1;
    SetPVarInt(playerid, "garage_horn_cd", GetTickCount() + 800);
    return 1;
}

stock GarageSys_ShowPayRent(playerid)
{
    new garage_idx = GarageSys_GetPlayerGarage(playerid);
    if(garage_idx == -1) return SendClientMessage(playerid, 0x999999FF, "У Вас нет гаража"), 1;

    new rent_time = g_gs_garage[garage_idx][GS_RENT_DATE];
    if(rent_time < gettime()) rent_time = gettime();
    new rent_days = GetElapsedTime(rent_time, gettime(), CONVERT_TIME_TO_DAYS);
    new dialog_text[192];
    format(dialog_text, sizeof dialog_text,
        "{FFFFFF}Гараж №%d оплачен ещё на {66CC33}%d дней.\nСтоимость одного дня: {FFFF00}%d руб.\n\nВведите количество дней (не более %d):",
        g_gs_garage[garage_idx][GS_DB_ID], rent_days, GARAGE_SYS_RENT_PRICE, GARAGE_SYS_MAX_RENT_DAYS);
    return Dialog(playerid, DIALOG_GS_PAY_RENT, DIALOG_STYLE_INPUT, "{FFCD00}Оплата гаража", dialog_text, "Оплатить", "Назад");
}

stock GarageSys_PayRent(playerid, days)
{
    new garage_idx = GarageSys_GetPlayerGarage(playerid);
    if(garage_idx == -1) return SendClientMessage(playerid, 0x999999FF, "У Вас нет гаража"), 1;
    if(days < 1 || days > GARAGE_SYS_MAX_RENT_DAYS) return GarageSys_ShowPayRent(playerid);

    new rent_time = g_gs_garage[garage_idx][GS_RENT_DATE];
    if(rent_time < gettime()) rent_time = gettime();
    new rent_days = GetElapsedTime(rent_time, gettime(), CONVERT_TIME_TO_DAYS);
    if(rent_days + days > GARAGE_SYS_MAX_RENT_DAYS)
        return SendClientMessage(playerid, 0xB5B500FF, "Гараж нельзя оплатить больше чем на 30 дней"), GarageSys_ShowPayRent(playerid);

    new total_price = GARAGE_SYS_RENT_PRICE * days;
    if(GetPlayerBankMoney(playerid) < total_price)
        return SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счёте недостаточно денег"), GarageSys_ShowPayRent(playerid);

    rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);
    new query[256];
    mysql_query(mysql, "START TRANSACTION", false);
    if(mysql_errno()) return SendClientMessage(playerid, 0xFF5252FF, "Ошибка БД при оплате гаража"), 1;

    mysql_format(mysql, query, sizeof query,
        "UPDATE accounts SET bank=bank-%d WHERE id=%d AND bank>=%d LIMIT 1",
        total_price, GetPlayerAccountID(playerid), total_price);
    if(!AuctionDatabaseExecuteAffected(query))
    {
        mysql_query(mysql, "ROLLBACK", false);
        return SendClientMessage(playerid, 0xFF5252FF, "Не удалось списать оплату гаража"), 1;
    }
    mysql_format(mysql, query, sizeof query,
        "UPDATE garages SET rent_time=%d WHERE id=%d AND owner_id=%d LIMIT 1",
        rent_time, g_gs_garage[garage_idx][GS_DB_ID], GetPlayerAccountID(playerid));
    if(!AuctionDatabaseExecuteAffected(query))
    {
        mysql_query(mysql, "ROLLBACK", false);
        return SendClientMessage(playerid, 0xFF5252FF, "Не удалось сохранить срок оплаты гаража"), 1;
    }
    mysql_query(mysql, "COMMIT", false);
    if(mysql_errno()) return SendClientMessage(playerid, 0xFF5252FF, "Ошибка завершения оплаты гаража"), 1;

    AddPlayerData(playerid, P_BANK, -, total_price);
    g_gs_garage[garage_idx][GS_RENT_DATE] = rent_time;
    BankLog(playerid, -total_price, "Оплата гаража");
    format(query, sizeof query, "Гараж оплачен на %d дней. С банковского счёта снято %d руб.", days, total_price);
    SendClientMessage(playerid, 0x66CC33FF, query);
    return 1;
}

stock GarageSys_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_GS_PAY_RENT)
    {
        if(!response) return ShowPlayerPayForRentDialog(playerid);
        if(!strlen(inputtext) || !IsNumeric(inputtext)) return GarageSys_ShowPayRent(playerid);
        return GarageSys_PayRent(playerid, strval(inputtext));
    }
    if(dialogid == DIALOG_GS_BUY)
    {
        if(!response) return 1;
        return GarageSys_Buy(playerid, g_gs_dialog_garage[playerid]);
    }
    if(dialogid == DIALOG_GS_ENTER)
    {
        if(!response) return 1;
        new garage_idx = g_gs_dialog_garage[playerid];
        if(garage_idx < 0 || garage_idx >= g_gs_loaded) return 1;
        if(!GarageSys_IsAccessAllowed(playerid, garage_idx)) return SendClientMessage(playerid, 0xCC3333FF, "Гараж закрыт."), 1;
        return GarageSys_EnterPlayer(playerid, garage_idx);
    }
    if(dialogid == DIALOG_GS_INFO)
    {
        if(response) return GarageSys_ShowSettings(playerid);
        return 1;
    }
    if(dialogid == DIALOG_GS_SETTINGS)
    {
        if(!response) return GarageSys_ShowInfo(playerid);
        new garage_idx = GarageSys_GetPlayerGarage(playerid);
        if(garage_idx == -1) return 1;
        switch(listitem)
        {
            case 0:
            {
                new new_lock = g_gs_garage[garage_idx][GS_LOCKED] ? 0 : 1;
                g_gs_garage[garage_idx][GS_LOCKED] = new_lock;
                new query[128];
                mysql_format(mysql, query, sizeof query, "UPDATE garages SET `lock`=%d WHERE id=%d LIMIT 1", new_lock, g_gs_garage[garage_idx][GS_DB_ID]);
                mysql_query(mysql, query, false);
                GarageSys_UpdateLabel(garage_idx);
                return GarageSys_ShowSettings(playerid);
            }
            case 1:
            {
                Dialog(playerid, DIALOG_GS_SELL_STATE, DIALOG_STYLE_MSGBOX, "{FFCD00}Продажа гаража",
                    "{FFFFFF}Продать гараж государству?\n\nНа банковский счёт вернётся 70% государственной стоимости.", "Продать", "Отмена");
                return 1;
            }
            case 2:
            {
                if(g_gs_garage[garage_idx][GS_IMPROVEMENT] >= 2) return SendClientMessage(playerid, 0x999999FF, "Улучшение уже установлено."), 1;
                Dialog(playerid, DIALOG_GS_UPGRADE, DIALOG_STYLE_MSGBOX, "{FFCD00}Улучшение гаража",
                    "{FFFFFF}Улучшить гараж до 10 парковочных мест?\n\nСтоимость: {FFFF00}5.000.000 руб.", "Улучшить", "Отмена");
                return 1;
            }
            case 3: return GarageSys_ShowCarList(playerid);
            case 4:
            {
                if(GetPlayerGPSInfo(playerid, G_ENABLED) != GPS_STATUS_OFF) return SendClientMessage(playerid, 0xCECECEFF, "На GPS уже отмечено место."), 1;
                if(GetPlayerMoneyEx(playerid) < 300) return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег (300 руб.)."), 1;
                GivePlayerMoneyEx(playerid, -300, "Метка гаража на GPS", true, true);
                EnablePlayerGPS(playerid, 55, g_gs_garage[garage_idx][GS_X], g_gs_garage[garage_idx][GS_Y], g_gs_garage[garage_idx][GS_Z], "Ваш гараж отмечен на GPS");
                return 1;
            }
            case 5: return SendClientMessage(playerid, 0xFFFFFFFF, "Используйте: {FFFF00}/sellmygarage [id игрока] [цена]"), 1;
        }
        return 1;
    }
    if(dialogid == DIALOG_GS_SELL_STATE)
    {
        if(response) return GarageSys_SellToState(playerid);
        return 1;
    }
    if(dialogid == DIALOG_GS_UPGRADE)
    {
        if(response) return GarageSys_Upgrade(playerid);
        return 1;
    }
    if(dialogid == DIALOG_GS_CAR_SELECT)
    {
        if(!response) return GarageSys_ShowSettings(playerid);
        new sql_id = GetPlayerListitemValue(playerid, listitem);
        new garage_idx = GetPVarInt(playerid, "gs_delivery_garage");
        DeletePVar(playerid, "gs_delivery_garage");
        return GarageSys_DeliverCar(playerid, sql_id, garage_idx);
    }
    return 0;
}

stock GarageSys_OnPlayerSpawn(playerid)
{
    // Garage is never allowed to override login/hospital spawn state.
    g_gs_player_inside[playerid] = -1;
    g_gs_dialog_garage[playerid] = -1;
    return 1;
}

stock GarageSys_OnPlayerDeath(playerid)
{
    g_gs_player_inside[playerid] = -1;
    g_gs_dialog_garage[playerid] = -1;
    DeletePVar(playerid, "gs_delivery_garage");
    return 1;
}

stock GarageSys_OnPlayerDisconnect(playerid)
{
    g_gs_player_inside[playerid] = -1;
    g_gs_player_owned[playerid] = -1;
    g_gs_dialog_garage[playerid] = -1;
    DeletePVar(playerid, "gs_delivery_garage");
    return 1;
}

CMD:garage(playerid, params[])
{
    #pragma unused params
    return GarageSys_ShowInfo(playerid);
}

CMD:sellgarage(playerid, params[])
{
    #pragma unused params
    if(GarageSys_GetPlayerGarage(playerid) == -1) return SendClientMessage(playerid, 0x999999FF, "У Вас нет гаража"), 1;
    Dialog(playerid, DIALOG_GS_SELL_STATE, DIALOG_STYLE_MSGBOX, "{FFCD00}Продажа гаража",
        "{FFFFFF}Продать гараж государству?\n\nНа банковский счёт вернётся 70% государственной стоимости.", "Продать", "Отмена");
    return 1;
}

CMD:sellmygarage(playerid, params[])
{
    new garage_idx = GarageSys_GetPlayerGarage(playerid);
    if(garage_idx == -1) return SendClientMessage(playerid, 0x999999FF, "У Вас нет гаража"), 1;
    new buyerid, price;
    if(sscanf(params, "dd", buyerid, price)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sellmygarage [id игрока] [цена]"), 1;
    if(!IsPlayerConnected(buyerid) || !IsPlayerLogged(buyerid) || buyerid == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет."), 1;
    if(price < 1) return SendClientMessage(playerid, 0xCECECEFF, "Укажите корректную цену."), 1;
    if(GarageSys_GetPlayerGarage(buyerid) != -1) return SendClientMessage(playerid, 0xCECECEFF, "У покупателя уже есть гараж."), 1;
    if(GetPlayerMoneyEx(buyerid) < price) return SendClientMessage(playerid, 0xCECECEFF, "У покупателя недостаточно денег."), 1;
    if(GarageSys_HasVehicles(garage_idx)) return SendClientMessage(playerid, 0xCECECEFF, "Сначала выведите весь транспорт из гаража."), 1;
    if(!IsPlayerInRangeOfPoint(playerid, 8.0, g_gs_garage[garage_idx][GS_X], g_gs_garage[garage_idx][GS_Y], g_gs_garage[garage_idx][GS_Z]) ||
       !IsPlayerInRangeOfPoint(buyerid, 8.0, g_gs_garage[garage_idx][GS_X], g_gs_garage[garage_idx][GS_Y], g_gs_garage[garage_idx][GS_Z]))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы и покупатель должны находиться рядом с этим гаражом."), 1;
    SendPlayerOffer(playerid, buyerid, OFFER_TYPE_SELL_GARAGE, g_gs_garage[garage_idx][GS_DB_ID], price);
    return 1;
}

CMD:gotogarage(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return SendClientMessage(playerid, 0x999999FF, "У Вас нет доступа к этой команде."), 1;
    new db_id;
    if(sscanf(params, "d", db_id)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /gotogarage [DB ID]"), 1;
    new garage_idx = GarageSys_GetIndexByDbId(db_id);
    if(garage_idx == -1) return SendClientMessage(playerid, 0xCECECEFF, "Гараж с таким DB ID не загружен."), 1;
    g_gs_player_inside[playerid] = -1;
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, g_gs_garage[garage_idx][GS_X], g_gs_garage[garage_idx][GS_Y], g_gs_garage[garage_idx][GS_Z] + 1.0);
    SetCameraBehindPlayer(playerid);
    return 1;
}

CMD:addgarage(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return SendClientMessage(playerid, 0x999999FF, "У Вас нет доступа к этой команде."), 1;
    new price = 30000000;
    if(strlen(params) && sscanf(params, "d", price)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addgarage [цена, необязательно]"), 1;
    if(price < 1) price = 30000000;
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
    new query[512];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO garages (owner_id,price,`lock`,x,y,z,exit_x,exit_y,exit_z,exit_angle,improvements) VALUES (0,%d,0,%f,%f,%f,%f,%f,%f,%f,1)",
        price, x, y, z, x, y, z, a);
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno() != 0) { cache_delete(result); return SendClientMessage(playerid, 0xFF5252FF, "Ошибка MySQL при создании гаража."), 1; }
    new db_id = cache_insert_id();
    cache_delete(result);
    GarageSys_Load(); GarageSys_SyncAllPlayers();
    new msg[160]; format(msg, sizeof msg, "Гараж создан. DB ID: %d. Телепорт: /gotogarage %d", db_id, db_id);
    SendClientMessage(playerid, 0x66CC33FF, msg);
    return 1;
}

CMD:creategarage(playerid, params[])
{
    return callcmd::addgarage(playerid, params);
}

CMD:delgarage(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return SendClientMessage(playerid, 0x999999FF, "У Вас нет доступа к этой команде."), 1;
    new db_id;
    if(sscanf(params, "d", db_id)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /delgarage [DB ID]"), 1;
    new garage_idx = GarageSys_GetIndexByDbId(db_id);
    if(garage_idx == -1) return SendClientMessage(playerid, 0xCECECEFF, "Гараж не найден."), 1;
    if(g_gs_garage[garage_idx][GS_OWNER_ID] > 0) return SendClientMessage(playerid, 0xFF5252FF, "Сначала освободите гараж через /asellgarage."), 1;
    if(GarageSys_HasVehicles(garage_idx)) return SendClientMessage(playerid, 0xFF5252FF, "В гараже находится транспорт."), 1;
    new query[128]; mysql_format(mysql, query, sizeof query, "DELETE FROM garages WHERE id=%d LIMIT 1", db_id); mysql_query(mysql, query, false);
    GarageSys_Load(); GarageSys_SyncAllPlayers();
    return SendClientMessage(playerid, 0x66CC33FF, "Гараж удалён."), 1;
}

CMD:setedit(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return SendClientMessage(playerid, 0x999999FF, "Нет доступа."), 1;
    new section_name[16], action_name[16], db_id;
    if(sscanf(params, "s[16]s[16]d", section_name, action_name, db_id) || strcmp(section_name, "pos", true) || strcmp(action_name, "spawn", true))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setedit pos spawn [DB ID гаража]"), 1;
    new garage_idx = GarageSys_GetIndexByDbId(db_id);
    if(garage_idx == -1) return SendClientMessage(playerid, 0xCECECEFF, "Гараж не найден."), 1;
    new Float:x, Float:y, Float:z, Float:a; GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
    g_gs_garage[garage_idx][GS_SPAWN_X] = x; g_gs_garage[garage_idx][GS_SPAWN_Y] = y; g_gs_garage[garage_idx][GS_SPAWN_Z] = z; g_gs_garage[garage_idx][GS_SPAWN_A] = a;
    new query[320]; mysql_format(mysql, query, sizeof query, "UPDATE garages SET spawn_x=%f,spawn_y=%f,spawn_z=%f,spawn_angle=%f WHERE id=%d LIMIT 1", x,y,z,a,db_id); mysql_query(mysql, query, false);
    return SendClientMessage(playerid, 0x66CC33FF, "Точка появления внутри гаража сохранена."), 1;
}

CMD:gexitsetpos(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return SendClientMessage(playerid, 0x999999FF, "Нет доступа."), 1;
    new db_id; if(sscanf(params, "d", db_id)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /gexitsetpos [DB ID]"), 1;
    new garage_idx = GarageSys_GetIndexByDbId(db_id); if(garage_idx == -1) return SendClientMessage(playerid, 0xCECECEFF, "Гараж не найден."), 1;
    new Float:x, Float:y, Float:z, Float:a; GetPlayerPos(playerid,x,y,z); GetPlayerFacingAngle(playerid,a);
    g_gs_garage[garage_idx][GS_SAFE_EXIT_X]=x; g_gs_garage[garage_idx][GS_SAFE_EXIT_Y]=y; g_gs_garage[garage_idx][GS_SAFE_EXIT_Z]=z; g_gs_garage[garage_idx][GS_SAFE_EXIT_A]=a;
    new query[320]; mysql_format(mysql, query, sizeof query, "UPDATE garages SET safe_exit_x=%f,safe_exit_y=%f,safe_exit_z=%f,safe_exit_angle=%f WHERE id=%d LIMIT 1",x,y,z,a,db_id); mysql_query(mysql,query,false);
    return SendClientMessage(playerid,0x66CC33FF,"Точка выхода игрока сохранена."),1;
}

CMD:gexitsetposcar(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return SendClientMessage(playerid, 0x999999FF, "Нет доступа."), 1;
    new db_id; if(sscanf(params, "d", db_id)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /gexitsetposcar [DB ID]"), 1;
    new garage_idx = GarageSys_GetIndexByDbId(db_id); if(garage_idx == -1) return SendClientMessage(playerid, 0xCECECEFF, "Гараж не найден."), 1;
    new Float:x, Float:y, Float:z, Float:a; GetPlayerPos(playerid,x,y,z); GetPlayerFacingAngle(playerid,a);
    g_gs_garage[garage_idx][GS_CAR_EXIT_X]=x; g_gs_garage[garage_idx][GS_CAR_EXIT_Y]=y; g_gs_garage[garage_idx][GS_CAR_EXIT_Z]=z; g_gs_garage[garage_idx][GS_CAR_EXIT_A]=a;
    new query[320]; mysql_format(mysql, query, sizeof query, "UPDATE garages SET vehicle_exit_x=%f,vehicle_exit_y=%f,vehicle_exit_z=%f,vehicle_exit_angle=%f WHERE id=%d LIMIT 1",x,y,z,a,db_id); mysql_query(mysql,query,false);
    return SendClientMessage(playerid,0x66CC33FF,"Точка выезда автомобиля сохранена."),1;
}

CMD:asellgarage(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return SendClientMessage(playerid, 0x999999FF, "У Вас нет доступа."), 1;
    new db_id; if(sscanf(params, "d", db_id)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /asellgarage [DB ID]"), 1;
    new garage_idx = GarageSys_GetIndexByDbId(db_id); if(garage_idx == -1) return SendClientMessage(playerid, 0xCECECEFF, "Гараж не найден."), 1;
    new old_owner = g_gs_garage[garage_idx][GS_OWNER_ID];
    new query[256];
    mysql_format(mysql, query, sizeof query, "UPDATE garages SET owner_id=0,`lock`=0,improvements=1 WHERE id=%d LIMIT 1", db_id); mysql_query(mysql,query,false);
    if(old_owner > 0) { mysql_format(mysql, query, sizeof query, "UPDATE accounts SET garage=-1 WHERE id=%d LIMIT 1", old_owner); mysql_query(mysql,query,false); }
    g_gs_garage[garage_idx][GS_OWNER_ID]=0; g_gs_garage[garage_idx][GS_LOCKED]=0; g_gs_garage[garage_idx][GS_IMPROVEMENT]=1; format(g_gs_garage[garage_idx][GS_OWNER_NAME],21,"None");
    GarageSys_UpdateExitPickup(garage_idx); GarageSys_UpdateLabel(garage_idx); GarageSys_SyncAllPlayers();
    return SendClientMessage(playerid,0x66CC33FF,"Гараж принудительно освобождён."),1;
}

// Read-only diagnostics: no packets, positions, skins or vehicle seats are changed.
IPacket:211(playerid, BitStream:bs)
{
    BS_GetNumberOfBitsUsed(bs, g_sync_passenger_bits[playerid]);
    g_sync_passenger_tick[playerid] = GetTickCount();
    return 1;
}

CMD:syncdiag(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1) return 1;
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, -1, "Используйте /syncdiag [ID невидимого игрока]");
    if(targetid < 0 || targetid >= MAX_PLAYERS || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Игрок не подключён");
    new vehicleid = GetPlayerVehicleID(targetid);
    new vehicle_stream = 0;
    if(vehicleid > 0 && vehicleid < MAX_VEHICLES && IsValidVehicle(vehicleid))
        vehicle_stream = IsVehicleStreamedIn(vehicleid, playerid);
    new sync_text[144];
    new Float:sync_x;
    new Float:sync_y;
    new Float:sync_z;
    GetPlayerPos(targetid, sync_x, sync_y, sync_z);
    format(sync_text, sizeof sync_text, "[SYNC] observer=%d target=%d state=%d car=%d seat=%d ped_stream=%d car_stream=%d",
        playerid, targetid, GetPlayerState(targetid), vehicleid, GetPlayerVehicleSeat(targetid),
        IsPlayerStreamedIn(targetid, playerid), vehicle_stream);
    SendClientMessage(playerid, -1, sync_text);
    printf("%s", sync_text);
    format(sync_text, sizeof sync_text, "[SYNC] target xyz=%.2f,%.2f,%.2f world=%d interior=%d ping=%d update_age=%dms",
        sync_x, sync_y, sync_z, GetPlayerVirtualWorld(targetid), GetPlayerInterior(targetid), GetPlayerPing(targetid),
        GetTickCount() - g_sync_update_tick[targetid]);
    SendClientMessage(playerid, -1, sync_text);
    printf("%s", sync_text);
    new packet_age = -1;
    if(g_sync_passenger_bits[targetid]) packet_age = GetTickCount() - g_sync_passenger_tick[targetid];
    format(sync_text, sizeof sync_text, "[SYNC] observer world=%d interior=%d passenger_bits=%d passenger_age=%dms",
        GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), g_sync_passenger_bits[targetid], packet_age);
    SendClientMessage(playerid, -1, sync_text);
    printf("%s", sync_text);
    return 1;
}
