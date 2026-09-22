//>> Файл: bykranin_src/core/vehicle/ownable_13.inc  (335 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: GiveAllPlayersMoney, OnWhitelistCheck, KickPlayerDelayed, KickBannedPlayer, SetVehicleWheelOffsetForPlayer, SetVehicleWheelAlignForPlayer, SetVehicleWheelAddForPlayer
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock GiveAllPlayersMoney(playerid, count, bool:isDonate = false)
{
    if (!GetPlayerAdminEx(playerid)) return 0;
    if (GetPlayerAdminEx(playerid) < 12)
        return SendClientMessage(playerid, -1, "{FF0000}Ошибка:{FFFFFF} Доступно с 12 уровня.");

    if (count <= 0)
        return SendClientMessage(playerid, -1, "{FF0000}Ошибка:{FFFFFF} Количество должно быть больше 0.");

    if (!isDonate && count > 100000000)
        return SendClientMessage(playerid, -1, "{FF0000}Ошибка:{FFFFFF} Лимит: максимум 100.000.000 руб.");
    if (isDonate && count > 100000)
        return SendClientMessage(playerid, -1, "{FF0000}Ошибка:{FFFFFF} Лимит: максимум 100.000 донат-руб.");

    new text[64], razdacha[192];
    format(text, sizeof text, "Раздача от %s", GetPlayerNameEx(playerid));

    
    foreach (new i : Player)
    {
        if (!IsPlayerLogged(i)) continue;

        if (!isDonate)
            GivePlayerMoneyEx(i, count, text);
        else
            GivePlayerDonateRub(i, count, text);
    }

    
    format(razdacha, sizeof razdacha,
        "{FF4500}[РАЗДАЧА]{FFFFFF} Администратор {00BFFF}%s {FFFFFF}выдал всем игрокам по {FFD700}%d %s!",
        GetPlayerNameEx(playerid), count, isDonate ? "донат-руб." : "руб.");
    SendClientMessageToAll(-1, razdacha);

    
    printf("[РАЗДАЧА] %s выдал всем игрокам по %d %s",
        GetPlayerNameEx(playerid), count, isDonate ? "донат-руб." : "руб.");

    return 1;
}

public OnWhitelistCheck(playerid, auth_epoch)
{
    if (!IsPlayerConnected(playerid)) return 1;
    if(auth_epoch != g_BRAuthEpoch[playerid]) return 1;
    if (!gWhitelist) return 1;

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    if (cache_num_rows())
    {
        SCM(playerid, -1, "{00FF00}[WHITELIST] {FFFFFF}Вы в списке допуска. Доступ разрешён.");
        // printf("[DEBUG] %s прошёл вайтлист. Запуск.", name);
        InitPlayer(playerid);
    }
    else
    {
        SCM(playerid, -1, "{FF0000}[WHITELIST] {FFFFFF}Вы не в списке доступа. Подключение будет завершено.");
		//SCM(playerid, -1, "{FFFFFF}Открытие сервера — {00FF00}01.08.2025 в 12:00 по МСК. {FFFFFF}Подробности: {00BFFF}t.me/l4ird");
        // printf("[DEBUG] %s НЕ найден в вайтлисте. Игрок будет кикнут.", name);
        SetTimerEx("BRAuth_KickStaleSafe", 1000, false, "ii", playerid, g_BRAuthEpoch[playerid]);
    }
    return 1;
}

forward KickPlayerDelayed(playerid);
public KickPlayerDelayed(playerid)
{
    if (IsPlayerConnected(playerid))
    {
        new name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, sizeof(name));
        printf("[DEBUG] Kick: %s был кикнут из-за отсутствия в вайтлисте.", name);
        Kick(playerid);
    }
    return 1;
}

forward KickBannedPlayer(playerid);
public KickBannedPlayer(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        Kick(playerid);
    }
    return 1;
}

stock SetVehicleWheelOffsetForPlayer(playerid, vehicleid, front, rear) 
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, 16); 
	
		BS_WriteValue(bs, PR_UINT32, (front));
	
		BS_WriteValue(bs, PR_UINT32, (rear));
	
    
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

stock SetVehicleWheelAlignForPlayer(playerid, vehicleid, front, rear) 
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, 10); 
	
		BS_WriteValue(bs, PR_UINT32, (front));
	
		BS_WriteValue(bs, PR_UINT32, (rear));
	
    
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

stock SetVehicleWheelAddForPlayer(playerid, vehicleid, front, rear) 
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, 17); 

	
		BS_WriteValue(bs, PR_UINT32, (front));
	
	
		BS_WriteValue(bs, PR_UINT32, (rear));
	
    
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

stock SetVehicleWheelRadForPlayer(playerid, vehicleid, front) 
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, 3); 

	
	BS_WriteValue(bs, PR_UINT32, (front));
    
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}
stock PlayAuthorizationMusic(playerid)
{
    new len = strlen(AudioURL);
    if(len <= 0 || len >= 255)
    {
        printf("[AUTH][AUDIO] audio_url is empty or too long; login music disabled for player %d", playerid);
        return 0;
    }

    // Keep both audio paths because this CRMP client has a custom stream RPC
    // while desktop/legacy clients can use the normal SA-MP audio RPC.
    PlayAudioStreamURL(playerid, AudioURL);
    PlayerPlayStream(playerid, AudioURL);
    return 1;
}

InitPlayer(playerid)
{
    TogglePlayerAllDynamicCPs(playerid, false);

    if (SvGetVersion(playerid) == SV_NULL)
    {
        // ...
    }
					else if (SvHasMicro(playerid) == SV_FALSE)
    {
        SendClientMessage(playerid, -1, "The microphone could not be found.");
    }
					else if ((lstream[playerid] = SvCreateDLStreamAtPlayer(40.0, SV_INFINITY, playerid, 0xff0000ff, "Local")))
    {
        SendClientMessage(playerid, -1, "Press Z to talk to global chat and B to talk to local chat.");
        if (gstream) SvAttachListenerToStream(gstream, playerid);
        SvAddKey(playerid, 0x5A);
    }

    timeduel[playerid] = 11;
    CreateAvtosalonTextDraws(playerid);

    SendClientMessage(playerid, 0xFFFF00FF, "{34C924}| {FFFFFF}Добро пожаловать на {00FFFF}"SERVER_NAME"!");

    new hour, minute, seconds;
    gettime(hour, minute, seconds);
    times[playerid] = true;
	player_sell_ownable_car[playerid] = false;

    SetPlayerTime(playerid, hour, minute);

    SetPlayerColor(playerid, 0x999999FF);
    SetPlayerVirtualWorld(playerid, playerid + 0xFF);
    ClearPlayerInfo(playerid);

    GetPlayerName(playerid, g_player[playerid][P_NAME], MAX_PLAYER_NAME);
    GetPlayerIp(playerid, g_player[playerid][P_IP], 16);

    InitFly(playerid);
    SetTimerEx("CheckPlayerAccount", 1000, false, "ii", playerid, mysql_race[playerid]);
	//if(random(100) == 50) {
}

CMD:ssp(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 5 && GetPlayerYouTubeEx(playerid) < 1) return 1;

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /ssp [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	if(!Spectate_CanWatchPlayer(playerid, to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Вы не можете следить за этим игроком");

	if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && GetPlayerSpectateData(playerid, S_PLAYER) != -1)
	{
		printf("[SP][CMD] stale spectate reset /ssp admin=%d old_target=%d state=%d", playerid, GetPlayerSpectateData(playerid, S_PLAYER), GetPlayerState(playerid));
		SetPlayerSpectateData(playerid, S_PLAYER, -1);
	}

	printf("[SP][CMD] /ssp admin=%d target=%d state=%d", playerid, to_player, GetPlayerState(playerid));
	StartSpectate(playerid, to_player);

	new fmt_text[999];
	
	SendClientMessage(playerid, 0x999999FF, "[A] Используйте команду \"/spoff\", чтобы прекратить слежку за игроком.");

	return 1;
}
CMD:banip(playerid, params[])
{
	//if (TEST_SERVER == 1)
		//return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Данная команда не доступна на ТЕСТ СЕРВЕРЕ!");
	if (GetPlayerAdminEx(playerid) < 13)
		return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	new to_player, reason[128];
	if (sscanf(params, "us[128]", to_player, reason))
		return SendClientMessage(playerid, -1, ""SC"Используйте: /banip [id игрока] [причина]");

	if (!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	new ip[16];
	GetPlayerIp(to_player, ip, sizeof(ip));

	new cmd[64];
	format(cmd, sizeof(cmd), "banip %s", ip);
	SendRconCommand(cmd);

	new msg[256];
	format(msg, sizeof(msg), "[A] Администратор %s заблокировал IP игрока %s (скрыто). Причина: %s",
		GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), reason);
	SendClientMessageToAll(0xFF5533FF, msg);

	new log[256];
	format(log, sizeof(log), "Заблокировал IP %s (%s). Причина: %s", ip, GetPlayerNameEx(to_player), reason);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, log);

	Kick(to_player);

	return 1;
}
CMD:banipoff(playerid, params[])
{
	//if (TEST_SERVER == 1)
		//return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Данная команда не доступна на ТЕСТ СЕРВЕРЕ!");
	if (GetPlayerAdminEx(playerid) < 13)
		return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	new target_name[24], reason[128];
	if (sscanf(params, "s[24]s[128]", target_name, reason))
		return SendClientMessage(playerid, -1, ""SC"Используйте: /banipoff [ник] [причина]");

	new query[128];
	mysql_format(mysql, query, sizeof query, "SELECT last_ip FROM accounts WHERE name='%e'", target_name);

	new Cache: result = mysql_query(mysql, query, true);
	if (cache_num_rows(result) == 0)
	{
		cache_delete(result);
		return SendClientMessage(playerid, 0xFF5533FF, ""SC"Игрок с таким именем не найден в базе данных.");
	}

	new ip[16];
	cache_get_row(0, 0, ip, sizeof(ip));
	cache_delete(result);

	new cmd[64];
	format(cmd, sizeof(cmd), "banip %s", ip);
	SendRconCommand(cmd);

	new msg[256];
	format(msg, sizeof(msg), "[A] Администратор %s заблокировал IP оффлайн игрока %s (скрыто). Причина: %s",
		GetPlayerNameEx(playerid), target_name, reason);
	SendClientMessageToAll(0xFF5533FF, msg);

	new log[256];
	format(log, sizeof(log), "Заблокировал IP %s (%s - оффлайн). Причина: %s", ip, target_name, reason);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, log);

	return 1;
}


CMD:unbanip(playerid, params[])
{
	//if (TEST_SERVER == 1)
		//return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Данная команда не доступна на ТЕСТ СЕРВЕРЕ!");
	if (GetPlayerAdminEx(playerid) < 13)
		return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	new ip[32];
	if (sscanf(params, "s[32]", ip))
		return SendClientMessage(playerid, -1, ""SC"Используйте: /unbanip [ip]");

	new string[256], log_msg[256];

	format(string, sizeof(string), "unbanip %s", ip);
	SendRconCommand(string);

	format(string, sizeof(string), "{33FF55}[A] Администратор %s разблокировал IP: [скрыто]", GetPlayerNameEx(playerid));
	SendClientMessageToAll(-1, string);

	format(log_msg, sizeof(log_msg), "Разблокировал IP %s", ip);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, log_msg);

	return 1;
}
