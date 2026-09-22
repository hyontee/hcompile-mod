//>> Файл: bykranin_src/core/server/server_08.inc  (391 строк)
//>> Тема: инфраструктура: таймеры, сохранение, MySQL, утилиты
//>> Внутри: GetVehicleModelName, IsOwnableCarLoaded, utf8_to_cp1251, cp1251_to_utf8, fixspawnwerton, tpplayertex, /lift1
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock GetVehicleModelName(modelid, name[], size = 24)
{
    new left = 0;
    new right = sizeof(g_vehicle_model_name_map) - 1;

    while (left <= right)
    {
        new mid = (left + right) / 2;
        new midId = g_vehicle_model_name_map[mid][VM_ID];

        if (midId == modelid)
            return format(name, size, "%s", g_vehicle_model_name_map[mid][VM_NAME]);

        if (modelid < midId)
            right = mid - 1;
        else
            left = mid + 1;
    }

    if (modelid >= 400 && (modelid - 400) < sizeof(g_vehicle_info) && g_vehicle_info[modelid - 400][VI_NAME][0] != '\0')
        return format(name, size, "%s", g_vehicle_info[modelid - 400][VI_NAME]);

    return format(name, size, "Модель %d", modelid);
}

stock bool:IsOwnableCarLoaded(carid)
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (!IsPlayerConnected(i)) continue;

        if (GetPlayerOwnableCar(i) == carid)
            return true;
    }
    return false;
}

stock utf8_to_cp1251(string[]) {
    new len = strlen(string);
    for (new i = 0; i < len; i++) {
        if (string[i] == 0xD0 && i + 1 < len) {
            if (string[i + 1] >= 0x90 && string[i + 1] <= 0xBF) {
                string[i] = string[i + 1] + 0x30;
                strdel(string, i + 1, i + 2);
                len--;
            }
        }
					else if (string[i] == 0xD1 && i + 1 < len) {
            if (string[i + 1] >= 0x80 && string[i + 1] <= 0x8F) {
                string[i] = string[i + 1] + 0x70;
                strdel(string, i + 1, i + 2);
                len--;
            }
        }
    }
    return 1;
}

stock cp1251_to_utf8(string[]) {
    new len = strlen(string);
    new result[128];
    new i = 0, j = 0;
    while (i < len && j < sizeof(result) - 2) {
        if (string[i] >= 0xC0) {
            result[j++] = 0xD0 + (string[i] >= 0xF0);
            result[j++] = string[i++] - (string[i] >= 0xF0 ? 0x70 : 0x30);
        }
					else {
            result[j++] = string[i++];
        }
    }
    result[j] = 0;
    format(string, 128, "%s", result);
}

stock fixspawnwerton(playerid)
{
SetTimerEx("spawningwerton", 200, false, "d", playerid);
}

public tpplayertex(playerid)
{
SetPlayerPos(playerid, 1002.388488,1004.204162,1001.039978);
			SetPlayerFacingAngle(playerid, 269.952667);
			ShowTuneShowPlayerDialog(playerid);
			return 1;
}

CMD:lift1(playerid)
{
    if(!IsPlayerLogged(playerid)) return 1;
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1467.886962, 2500.300048, 2501.000000))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться у лифта на нижнем этаже");
    if(GetPVarInt(playerid, "lift_pending") != 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Лифт уже движется");

    SetPVarInt(playerid, "lift_pending", 1);
    SetTimerEx("lift1tp", 1850, false, "d", playerid);
    return 1;
}

public lift1tp(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
    if(GetPVarInt(playerid, "lift_pending") != 1) return 1;
    DeletePVar(playerid, "lift_pending");

    SetPlayerPos(playerid, 1467.886962, 2500.300048, 2506.000244);
    SetPlayerFacingAngle(playerid, 268.770874);
    SetCameraBehindPlayer(playerid);
    ShowNotificationNew(playerid, 3, 4, 0, 0, "Вы поднялись наверх", "");
    return 1;
}

CMD:lift2(playerid)
{
    if(!IsPlayerLogged(playerid)) return 1;
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1467.886962, 2500.300048, 2506.000244))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться у лифта на верхнем этаже");
    if(GetPVarInt(playerid, "lift_pending") != 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Лифт уже движется");

    SetPVarInt(playerid, "lift_pending", 2);
    SetTimerEx("lift2tp", 1850, false, "d", playerid);
    return 1;
}

public lift2tp(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
    if(GetPVarInt(playerid, "lift_pending") != 2) return 1;
    DeletePVar(playerid, "lift_pending");

    SetPlayerPos(playerid, 1467.886962, 2500.300048, 2501.000000);
    SetPlayerFacingAngle(playerid, 268.770874);
    SetCameraBehindPlayer(playerid);
    ShowNotificationNew(playerid, 3, 4, 0, 0, "Вы спустились вниз", "");
    return 1;
}

stock GiveDefaultLicenses(playerid)
{
    SetPlayerData(playerid, P_DRIVING_LIC, 1);
    UpdatePlayerDatabaseInt(playerid, "driving_lic", 1);

    SetPlayerData(playerid, P_WEAPON_LIC, 1);
    UpdatePlayerDatabaseInt(playerid, "weapon_lic", 1);

	SendClientMessage(playerid, 0x66CC00FF, "Вы получили стандартные лицензии: водительские права и лицензию на оружие.");
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Игрок получил базовые лицензии при регистрации.");
}
public ExecuteSpawnCars()
{
    g_SpawnCarsPending = false;

    new vehicles_count;

    for(new i = 1; i < MAX_VEHICLES; i++)
    {
        if(!IsValidVehicle(i)) continue;
        if(IsVehicleOccupied(i)) continue;
        if(IsTrailerAttachedToAnyVehicle(i)) continue;

        DestroyVehicle(i);
        vehicles_count++;
    }

    new fmt_text[128];
    format(fmt_text, sizeof fmt_text, "[A] Выгружено незанятых транспортных средств: %d", vehicles_count);
    SendMessageToAdmins(fmt_text, 0x999999FF);

    SendLog(-1, LOG_TYPE_ADMIN_ACTION, "Выгружены незанятые машины по таймеру от /spcars");

    return 1;
}
CMD:uval(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 12) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /uval [id игрока]");

	if(!IsPlayerConnected(params[0]) || !IsPlayerLogged(params[0]))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	if(GetPlayerTeamEx(params[0]) == 0) return SendClientMessage(playerid, 0xFF6600FF, "Данный игрок не состоит в организации");

	new fmt_text[600];

	new fmt_msg[600];

	format(fmt_text, sizeof(fmt_text),"[A] %s[%d] уволил %s[%d] из огранизации \"%s\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(params[0]), params[0], GetTeamName(GetPlayerTeamEx(params[0])));
	SendMessageToAdmins(fmt_text, 0x999999FF);

	format(fmt_msg, sizeof(fmt_msg),"{1E90FF}Вы уволили %s[%d] из организации \"%s\".", GetPlayerNameEx(params[0]), params[0], GetTeamName(GetPlayerTeamEx(params[0])));
	SendClientMessage(playerid, -1, fmt_msg);

	format(fmt_msg, sizeof(fmt_msg), "{1E90FF}Администратор %s[%d] уволил Вас из организации \"%s\".", GetPlayerNameEx(playerid), playerid, GetTeamName(GetPlayerTeamEx(params[0])));
	SendClientMessage(params[0], 0xFF6600FF, fmt_msg);

	UnInvite(playerid, params[0]);

	return 1;
}

CMD:offpermban(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) 
        return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

    if(!strlen(params)) 
        return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /offpermban [ник игрока] [причина]");

    extract params -> new string:player_name[21], string:reason[30];

    if(IsPlayerConnected(GetPlayerID(player_name))) 
        return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем находится на сервере");

    new query[256],
        Cache:result,
        rows,
        uid,
        admin,
        uip[16];

    mysql_format(mysql, query, sizeof(query), "SELECT id, admin, last_ip FROM accounts WHERE name='%s'", player_name);
    result = mysql_query(mysql, query, true);

    rows = cache_num_rows(result);

    if(rows)
    {
        uid = cache_get_row_int(0, 0);
        admin = cache_get_row_int(0, 1);
        cache_get_row(0, 2, uip);
    }
    cache_delete(result);

    if(!rows || !uid) 
        return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

    if(GetPlayerAdminEx(playerid) < admin) 
        return SendClientMessage(playerid, 0x999999FF, "Нельзя забанить администратора выше по рангу");

    mysql_format(mysql, query, sizeof(query), "SELECT * FROM ban_list WHERE user_id=%d", uid);
    result = mysql_query(mysql, query, true);
    rows = cache_num_rows(result);
    cache_delete(result);

    if(rows) 
        return SendClientMessage(playerid, 0x999999FF, "Аккаунт игрока уже заблокирован");

    if(AntiSliv(playerid, "/offpermban")) 
        return true;

    new fmt_msg[256];
    format(fmt_msg, sizeof(fmt_msg), "Администратор %s навсегда заблокировал игрока %s", GetPlayerNameEx(playerid), player_name);

    if(strlen(reason) > 0)
        format(fmt_msg, sizeof(fmt_msg), "%s. Причина: %s", fmt_msg, reason);

    SendClientMessageToAll(0xFF5533FF, fmt_msg);

    if(!strlen(reason)) 
        reason = "None";

    format(fmt_msg, sizeof(fmt_msg), "Оффлайн забанил %s[acc:%d] навсегда. Причина: %s", player_name, uid, reason);
    SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_msg);

    AddBan(uid, gettime(), 9999, uip, reason, GetPlayerNameEx(playerid));
    
    InfoAstats[1] += 1; // Увеличиваем счетчик банов в статистике

    return 1;
}

CMD:getacc(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return 1; // Проверка админки (уровень 8+)

    if(!strlen(params))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /getacc [ID аккаунта]");

    new account_id = strval(params);
    if(account_id <= 0)
        return SendClientMessage(playerid, 0x999999FF, "ID аккаунта должен быть положительным числом");

    new query[384];
    new Cache:result;

    mysql_format(mysql, query, sizeof(query), "SELECT * FROM accounts WHERE id=%d LIMIT 1", account_id);
    result = mysql_query(mysql, query);

    if(!cache_num_rows(result))
        return SendClientMessage(playerid, 0x999999FF, "Аккаунт с таким ID не найден"), cache_delete(result);

    // Получаем данные из БД
    new name[MAX_PLAYER_NAME], reg_ip[16], last_ip[16], reg_date[6];
    new reg_time = cache_get_field_content_int(0, "reg_time");
    new game_for_day = cache_get_field_content_int(0, "game_for_day");
    new game_for_day_prev = cache_get_field_content_int(0, "game_for_day_prev");
    new car_slots = cache_get_field_content_int(0, "car_slots");

    cache_get_field_content(0, "name", name);
    cache_get_field_content(0, "reg_ip", reg_ip);
    cache_get_field_content(0, "last_ip", last_ip);

    timestamp_to_date(reg_time, reg_date[2], reg_date[1], reg_date[0], reg_date[3], reg_date[4], reg_date[5]);

    // Формируем текст информации
    new fmt_text[256], dialog_title[64];
    format(
        fmt_text, sizeof(fmt_text),
        "\
        Никнейм:\t\t\t%s\n\
        Номер аккаунта:\t\t%d\n\
        Наличные:\t\t\t%d\n\
        Осн. банк счет:\t\t%d\n\
        Уровень:\t\t\t%d\n\
        IP адрес (регистр.):\t\t%s\n\
        IP адрес (послед.):\t\t%s\n\
        Дата и время регистрации:\t\%02d.%02d.%d в %02d:%02d:%02d\n\
        Донат:\t\t\t\t%d (Всего: %d)\n\
        В игре сегодня:\t\t%d ч %d мин\n\
        В игре вчера:\t\t\t%d ч %d мин\n\n\
        Слоты для транспорта:\t%d\n\
        ",
        name,
        account_id,
        cache_get_field_content_int(0, "money"),
        cache_get_field_content_int(0, "bank"),
        cache_get_field_content_int(0, "level"),
        reg_ip,
        last_ip,
        reg_date[0], reg_date[1], reg_date[2],
        reg_date[3], reg_date[4], reg_date[5],
        cache_get_field_content_int(0, "donate_current"),
        cache_get_field_content_int(0, "donate_total"),
        ConvertUnixTime(game_for_day, CONVERT_TIME_TO_HOURS),
        ConvertUnixTime(game_for_day, CONVERT_TIME_TO_MINUTES),
        ConvertUnixTime(game_for_day_prev, CONVERT_TIME_TO_HOURS),
        ConvertUnixTime(game_for_day_prev, CONVERT_TIME_TO_MINUTES),
        car_slots
    );

    cache_delete(result);

    // Получаем транспорт игрока
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM ownable_cars WHERE owner_id=%d", account_id);
    result = mysql_query(mysql, query, true);

    if(cache_num_rows(result))
    {
        strcat(fmt_text, "\n\nТранспортные средства:");
        for(new idx; idx < cache_num_rows(result); idx++)
        {
            new id = cache_get_field_content_int(idx, "id"),
                modelid = cache_get_field_content_int(idx, "model_id"),
                Float:x = cache_get_field_content_float(idx, "pos_x"),
                Float:y = cache_get_field_content_float(idx, "pos_y"),
                Float:z = cache_get_field_content_float(idx, "pos_z"),
                Float:health = cache_get_field_content_float(idx, "health"),
                number[7];

            cache_get_field_content(idx, "number", number);

            format(query, sizeof(query), "\n%s [%d] - %s (%.1f, %.1f, %.1f) HP: %.1f", 
                GetVehicleInfo(modelid - 400, VI_NAME), id, number, x, y, z, health);
            strcat(fmt_text, query);
        }
    }

    cache_delete(result);

    // Создаем заголовок диалога
    format(dialog_title, sizeof(dialog_title), "Аккаунт ID: %d", account_id);
    
    // Показываем диалог с информацией
    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, 
        dialog_title, 
        fmt_text, 
        "Закрыть", "");

    // Логируем действие
    new log_msg[128];
    format(log_msg, sizeof(log_msg), "Смотрит информацию об аккаунте %s[ID:%d]", name, account_id);
    SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, log_msg);

    return 1;
}

