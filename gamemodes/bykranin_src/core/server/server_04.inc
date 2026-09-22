//>> Файл: bykranin_src/core/server/server_04.inc  (634 строк)
//>> Тема: инфраструктура: таймеры, сохранение, MySQL, утилиты
//>> Внутри: /house, /biz, /fuelstation, /inter, /world, /vw, /setvw
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:house(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;

	extract params -> new house_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /house [номер дома]");

	if(!(0 <= house_id <= g_house_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "Данного дома не существует на сервере");

	new Float: x,
		Float: y,
		Float: z,
		Float: angle;

	if(GetHouseData(house_id, H_ENTRACE) != -1)
	{
		EnterPlayerToEntrance(playerid, GetHouseData(house_id, H_ENTRACE));

		x = GetHouseData(house_id, H_POS_X);
		y = GetHouseData(house_id, H_POS_Y);
		z = GetHouseData(house_id, H_POS_Z);
	}
					else
	{
		x = GetHouseData(house_id, H_EXIT_POS_X);
		y = GetHouseData(house_id, H_EXIT_POS_Y);
		z = GetHouseData(house_id, H_EXIT_POS_Z);
		angle = GetHouseData(house_id, H_EXIT_ANGLE);
	}
	SetPlayerPosEx(playerid, x, y, z, angle);

	new fmt_text[35];

	format(fmt_text, sizeof fmt_text, "Вы телепортировались к дому №%d", house_id);
	SendClientMessage(playerid, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, " к дому %d", house_id);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:biz(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;

	extract params -> new biz_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /biz [номер бизнеса]");

	if(!(0 <= biz_id <= g_business_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "Данного бизнеса не существует на сервере");

	SetPlayerPosEx
	(
		playerid,
		GetBusinessData(biz_id, B_EXIT_POS_X),
		GetBusinessData(biz_id, B_EXIT_POS_Y),
		GetBusinessData(biz_id, B_EXIT_POS_Z),
		GetBusinessData(biz_id, B_EXIT_ANGLE)
	);

	new fmt_text[35];

	format(fmt_text, sizeof fmt_text, "Вы телепортировались к бизнесу №%d", biz_id);
	SendClientMessage(playerid, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "Телепортировался к бизнесу %d", biz_id);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:fuelstation(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;

	extract params -> new fs_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /fuelstation [номер АЗС]");

	if(!(0 <= fs_id <= g_fuel_station_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "Данной АЗС не существует на сервере");

	SetPlayerPosEx
	(
		playerid,
		GetFuelStationData(fs_id, FS_POS_X),
		GetFuelStationData(fs_id, FS_POS_Y),
		GetFuelStationData(fs_id, FS_POS_Z),
		0.0
	);

	new fmt_text[35];

	format(fmt_text, sizeof fmt_text, "Вы телепортировались к АЗС №%d", fs_id);
	SendClientMessage(playerid, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "Телепортировался к АЗС %d", fs_id);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:inter(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	extract params -> new to_player, interior; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /inter [id игрока] [интерьер]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");
	if(TEST_SERVER == 1)
	{
	    if(playerid != to_player) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Данную команду можно использовать на ТЕСТ СЕРВЕРЕ только по отношению к себе!");
	}

	SetPlayerInterior(to_player, interior);

	new fmt_msg[999];
	
	new fmt_text[999];
	
	format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] установил %s[%d] интерьер %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, interior);
	SendMessageToAdmins(fmt_msg, 0x999999FF);
		
    format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы установили %s[%d] интерьер %d", GetPlayerNameEx(to_player), to_player, interior);
    SendClientMessage(playerid, 0x66CC00FF, fmt_msg);	

	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Администратор %s[%d] установил вам интерьер %d", GetPlayerNameEx(playerid), playerid, interior);
	SendClientMessage(to_player, 0x66CC00FF, fmt_msg);	

	LinkVehicleToInterior(GetPlayerData(to_player, P_BUY_CAR), interior);

	format(fmt_text, sizeof fmt_text, "Установил %s[acc:%d] интерьер %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), interior);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:world(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1) return 1;

	extract params -> new to_player, world; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /world [id игрока] [вирт.мир]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
	if(TEST_SERVER == 1)
	{
	    if(playerid != to_player) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Данную команду можно использовать на ТЕСТ СЕРВЕРЕ только по отношению к себе!");
	}

	SetPlayerVirtualWorld(to_player, world);

	new fmt_text[110];

	format(fmt_text, sizeof fmt_text, "Вы установили %s[%d] вирт.мир %d", GetPlayerNameEx(to_player), to_player, world);
	SendClientMessage(playerid, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s[%d] установил Вам вирт.мир %d", GetPlayerNameEx(playerid), playerid, world);
	SendClientMessage(to_player, -1, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] установил %s[%d] вирт.мир №%d", GetPlayerNameEx(playerid), playerid,
		GetPlayerNameEx(to_player), to_player, world);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	format(fmt_text, sizeof fmt_text, "Установил %s[acc:%d] вирт.мир %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), world);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:vw(playerid, params[])
{
    return callcmd::world(playerid, params);
}

CMD:setvw(playerid, params[])
{
    return callcmd::world(playerid, params);
}

// Integration templates, not a standalone include.
CMD:warn(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 2)) return 1;
    new targetid, reason[65], count;
    if(sscanf(params, "dS(Без причины)[65]", targetid, reason)) return SendClientMessage(playerid, -1, "Используйте: /warn [id] [причина]");
    if(!SRAdmin_Target(playerid, targetid, 2)) return 1;
    if(AntiSliv(playerid, "/warn")) return 1;
    if(!SRAdmin_SaveWarning(playerid, targetid, 0, count)) return SendClientMessage(playerid, -1, "Предупреждение не подтверждено БД. Проверьте серверный журнал.");
    new message[192];
    format(message, sizeof message, "Администратор %s выдал предупреждение %s [%d/3]. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), count, reason);
    SendClientMessageToAll(0xFF5533FF, message);
    SRAdmin_WriteLog(playerid, LOG_TYPE_ADMIN_ACTION, message);
    if(count >= 3) SendClientMessage(targetid, 0xFF5533FF, "Аккаунт заблокирован на 10 дней: получено 3 предупреждения.");
    return SRAdmin_SafeKick(targetid);
}

CMD:unwarn(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 2)) return 1;
    new targetid, reason[65], count;
    if(sscanf(params, "dS(Без причины)[65]", targetid, reason)) return SendClientMessage(playerid, -1, "Используйте: /unwarn [id] [причина]");
    if(!SRAdmin_Target(playerid, targetid, 2)) return 1;
    if(!SRAdmin_SaveWarning(playerid, targetid, 1, count)) return SendClientMessage(playerid, -1, "Снятие предупреждений не подтверждено БД.");
    new message[192];
    format(message, sizeof message, "Администратор %s снял все предупреждения с %s. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason);
    SendClientMessageToAll(0xFF5533FF, message);
    SRAdmin_WriteLog(playerid, LOG_TYPE_ADMIN_ACTION, message);
    return 1;
}


stock ShowAdminSpawnSelection(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    if(GetPlayerData(playerid, P_HOSPITAL))
        return SendClientMessage(playerid, 0xCECECEFF, "Нельзя менять место появления, находясь в больнице.");

    // A normal login leaves this guard set after the first selection. Reset it
    // before reopening GUI 50, otherwise its response is discarded as duplicate.
    DeletePVar(playerid, "spawn_select_once");
    DeletePVar(playerid, "spawn_select_id");
    DeletePVar(playerid, "spawn_select_int");
    DeletePVar(playerid, "spawn_select_vw");
    g_spawn_request_block_tick[playerid] = 0;

	new JSON:json_spawn = JSON_Object();
	new JSON:json_spawn_array = JSON_Array();
	json_spawn_array = JSON_Append(json_spawn_array, JSON_Array(JSON_Int(1)));

    if(HasRecentSpawnState(GetPlayerAccountID(playerid)))
        json_spawn_array = JSON_Append(json_spawn_array, JSON_Array(JSON_Int(2)));

	if(GetPlayerTeamEx(playerid))
		json_spawn_array = JSON_Append(json_spawn_array, JSON_Array(JSON_Int(0)));

	if(GetHouseNewByOwner(GetPlayerAccountID(playerid), playerid) != -1 ||
       GetFlatNewByOwner(GetPlayerAccountID(playerid), playerid) != -1)
		json_spawn_array = JSON_Append(json_spawn_array, JSON_Array(JSON_Int(4)));

    new family_id = GetPlayerIdFamily(playerid);
    if(family_id != -1 && GetFamily(family_id, family_house) != -1)
        json_spawn_array = JSON_Append(json_spawn_array, JSON_Array(JSON_Int(6)));

	JSON_SetArray(json_spawn, "m", json_spawn_array);
	ShowPlayerGUI(playerid, GUISpawnLocation, json_spawn);
	JSON_Cleanup(json_spawn_array);
	JSON_Cleanup(json_spawn);
	return 1;
}
CMD:spawn(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2)
		return ShowNotificationNew(playerid, 2, 3, 0, 0, "У Вас нет доступа к использованию данной команды", "");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Использование: /spawn [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Игрок не найден", "");

	ShowAdminSpawnSelection(to_player);

	new fmt_msg[144];
	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Администратор %s[%d] предложил Вам выбрать место появления", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, 0x66CC00FF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы предложили %s[%d] выбрать место появления", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, 0x66CC00FF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] открыл выбор спавна для %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
	SendMessageToAdmins(fmt_msg, 0x999999FF);

	format(fmt_msg, sizeof fmt_msg, "Открыл выбор спавна для %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
	return 1;
}

CMD:aspawn(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
	
	extract params -> new to_player, string: reason[30]; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /aspawn [id игрока] [Причина]");
	
	if(TEST_SERVER == 1)
	{
	    if(playerid != to_player) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}На ТЕСТ СЕРВЕРЕ данную команду можно использовать только по отношению к себе!");
	}
	
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	SetPlayerSpawnInit(to_player);
	SpawnPlayer(to_player);

	new fmt_msg[999];
	//format(fmt_msg, sizeof fmt_msg, "Администратор %s заспавнил %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));

	if(strlen(reason))
		format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);
	
		format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] заспавнил %s[%d]. Причина: %s ", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, reason);
		SendMessageToAdmins(fmt_msg, 0x999999FF);
		
    	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы заспавнили %s[%d]. Причина: %s ", GetPlayerNameEx(to_player), to_player, reason);
    	SendClientMessage(playerid, 0x66CC00FF, fmt_msg);	

	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы были заспавнены администратором %s[%d]. Причина: %s ", GetPlayerNameEx(playerid), playerid, reason);
	SendClientMessage(to_player, 0x66CC00FF, fmt_msg);
	
	InfoAstats[3] += 1;

	format(fmt_msg, sizeof fmt_msg, "Заспавнил %s[acc:%d]. Причина: %s",
	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), reason);
	return 1;
}

CMD:tplist(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 1)) return 1;
    return SRAdmin_ShowTeleports(playerid);
}

CMD:tp(playerid, params[])
{
    return SRAdmin_ShowTeleports(playerid);
}


// ===== [ ADMIN ZONE /az | V16 ] =====
// Отдельный virtual world использует интерьер домов на Рублёвке (house type 4),
// поэтому игроки в обычных домах не пересекаются с администраторами.
#define ADMIN_ZONE_VW       (65000)
#define ADMIN_ZONE_INTERIOR (1)
#define ADMIN_ZONE_X        (7.3987)
#define ADMIN_ZONE_Y        (503.3117)
#define ADMIN_ZONE_Z        (1381.0022)
#define ADMIN_ZONE_A        (180.0)

CMD:az(playerid, params[])
{
    #pragma unused params

    // Повторный /az всегда выпускает игрока из зоны, чтобы он не мог
    // застрять там даже если админ-уровень был изменён во время нахождения.
    if(GetPVarInt(playerid, "AZ_ACTIVE"))
    {
        new Float:x = GetPVarFloat(playerid, "AZ_BACK_X");
        new Float:y = GetPVarFloat(playerid, "AZ_BACK_Y");
        new Float:z = GetPVarFloat(playerid, "AZ_BACK_Z");
        new Float:a = GetPVarFloat(playerid, "AZ_BACK_A");
        new interior = GetPVarInt(playerid, "AZ_BACK_INT");
        new virtual_world = GetPVarInt(playerid, "AZ_BACK_VW");

        if(IsPlayerInAnyVehicle(playerid))
            RemovePlayerFromVehicle(playerid);

        SetPlayerPosEx(playerid, x, y, z, a, interior, virtual_world);
        Streamer_Update(playerid);

        DeletePVar(playerid, "AZ_ACTIVE");
        DeletePVar(playerid, "AZ_BACK_X");
        DeletePVar(playerid, "AZ_BACK_Y");
        DeletePVar(playerid, "AZ_BACK_Z");
        DeletePVar(playerid, "AZ_BACK_A");
        DeletePVar(playerid, "AZ_BACK_INT");
        DeletePVar(playerid, "AZ_BACK_VW");

        SendClientMessage(playerid, 0x66CCFFFF, "[AZ] Вы вышли из админ-зоны и возвращены на прежнее место.");
        SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Вышел из админ-зоны /az");
        return 1;
    }

    if(!SRAdmin_Require(playerid, 1)) return 1;

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    SetPVarFloat(playerid, "AZ_BACK_X", x);
    SetPVarFloat(playerid, "AZ_BACK_Y", y);
    SetPVarFloat(playerid, "AZ_BACK_Z", z);
    SetPVarFloat(playerid, "AZ_BACK_A", a);
    SetPVarInt(playerid, "AZ_BACK_INT", GetPlayerInterior(playerid));
    SetPVarInt(playerid, "AZ_BACK_VW", GetPlayerVirtualWorld(playerid));
    SetPVarInt(playerid, "AZ_ACTIVE", 1);

    if(IsPlayerInAnyVehicle(playerid))
        RemovePlayerFromVehicle(playerid);

    SetPlayerPosEx(playerid,
        ADMIN_ZONE_X, ADMIN_ZONE_Y, ADMIN_ZONE_Z, ADMIN_ZONE_A,
        ADMIN_ZONE_INTERIOR, ADMIN_ZONE_VW);
    Streamer_Update(playerid);

    SendClientMessage(playerid, 0x66CCFFFF, "[AZ] Вы вошли в админ-зону. Для выхода используйте /az ещё раз.");
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Вошел в админ-зону /az");
    return 1;
}

CMD:vtp(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;

	extract params -> new to_vehicleid; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /vtp [id транспорта]");
	if(!IsValidVehicle(to_vehicleid)) return SendClientMessage(playerid, 0xCECECEFF, "Данного транспорта не существует на сервере");

	new Float: x, Float: y, Float: z;
	GetVehiclePos(to_vehicleid, x, y, z);

	SetPlayerPosEx(playerid, x + 1, y + 1, z, 0.0, false);

	SendClientMessage(playerid, -1, "Вы были телепортированы");

	new fmt_msg[105];

	format(fmt_msg, sizeof fmt_msg, "Телепортировался к авто №%d", to_vehicleid);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] телепортировался к авто №%d", GetPlayerNameEx(playerid), playerid, to_vehicleid);
		SendMessageToAdmins(fmt_msg, 0x999999FF);
	}

	return 1;
}
alias:vtp("tpv")

CMD:getv(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;

	extract params -> new to_vehicleid; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /getv [id транспорта]");
	if(!IsValidVehicle(to_vehicleid)) return SendClientMessage(playerid, 0xCECECEFF, "Данного транспорта не существует на сервере");

	new Float: x, Float: y, Float: z, Float: a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	SetVehiclePos(to_vehicleid, x + 2.0, y + 2.0, z);
	SetVehicleZAngle(to_vehicleid, a);
	SetVehicleVelocity(to_vehicleid, 0.0, 0.0, 0.0);

	SendClientMessage(playerid, -1, "{1E90FF}Вы телепортировали транспорт к себе");

	new fmt_msg[105];

	format(fmt_msg, sizeof fmt_msg, "Телепортировал к себе тс №%d", to_vehicleid);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] телепортировал к себе тс №%d", GetPlayerNameEx(playerid), playerid, to_vehicleid);
		SendMessageToAdmins(fmt_msg, 0x999999FF);
	}

	return 1;
}

CMD:vget(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /vget [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	new vehicleid = INVALID_VEHICLE_ID;

	if(IsPlayerInAnyVehicle(to_player))
		vehicleid = GetPlayerVehicleID(to_player);
	else
		vehicleid = GetPlayerOwnableCar(to_player);

	if(vehicleid == INVALID_VEHICLE_ID)
		return SendClientMessage(playerid, 0x999999FF, "У этого игрока нет транспорта, который можно телепортировать");

	new Float: x, Float: y, Float: z;
	GetPlayerPos(playerid, x, y, z);
	SetVehiclePos(vehicleid, x + 2.0, y + 2.0, z);
	SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);

	new fmt_text[128];

	format(fmt_text, sizeof fmt_text, "{1E90FF}Вы телепортировали к себе транспорт игрока %s[%d]", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "Телепортировал к себе транспорт игрока %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "[A] %s[%d] телепортировал к себе транспорт игрока %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	return 1;
}

CMD:fixcar(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /fixcar [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	if(!IsPlayerInAnyVehicle(to_player))
		return SendClientMessage(playerid, 0x999999FF, ""SC"Игрок должен находиться в транспорте");

	new fmt_text[999],
		vehicleid = GetPlayerVehicleID(to_player);

	RepairVehicle(vehicleid);
	if(IsAOwnableCar(vehicleid)) SetVehicleData(vehicleid, V_HEALTH, 1000.0);

	format(fmt_text, sizeof fmt_text, ""SC"Вы починили транспорт игрока %s", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "{1E90FF}Администратор %s починил Ваш транспорт", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] починил транспорт игрока %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	format(fmt_text, sizeof fmt_text, "Починил транспорт %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:setfuel(playerid, params[])
{
    if (GetPlayerAdminEx(playerid) < 3)
        return 1;

    new vehicleid, Float:fuel;
    if (sscanf(params, "if", vehicleid, fuel))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setfuel [id транспорта] [кол-во топлива]");

    if (!IsValidVehicle(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "Данного транспорта не существует на сервере");

    if (fuel < 0.0 || fuel > 150.0)
        return SendClientMessage(playerid, 0x999999FF, "Количество топлива от 0 до 150");

    // Устанавливаем новое количество топлива, сохраняя текущий пробег
    new Float:mileage = GetVehicleData(vehicleid, V_MILEAGE);
    SetVehicleSpeedometerInfo(vehicleid, fuel, mileage);

    new fmt_text[128];
    format(fmt_text, sizeof(fmt_text), "Вы установили %.1f топлива в ТС №%d", fuel, vehicleid);
    SendClientMessage(playerid, -1, fmt_text);

    if (GetPlayerAdminEx(playerid) >= 5)
    {
        format(fmt_text, sizeof(fmt_text), "[A] %s[%d] установил %.1f топлива в ТС №%d",
            GetPlayerNameEx(playerid), playerid, fuel, vehicleid);
        SendMessageToAdmins(fmt_text, 0x999999FF);
    }

    format(fmt_text, sizeof(fmt_text), "Установил %.1f топлива в авто №%d", fuel, vehicleid);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

    return 1;
}


CMD:settime(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "" );

	new time;
	if(sscanf(params, "d", time))
		return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /settime [время (0-23)]");

	if(time < 0 || time > 23)
		return SendClientMessage(playerid, 0x999999FF, ""SC"Время от 0 до 23 часов");

	SetPlayerTime(playerid, time, 0);

	new fmt_text[144];
	format(fmt_text, sizeof(fmt_text), "{1E90FF}Вы успешно установили локальное время на %02d:00", time);
	SendClientMessage(playerid, -1, fmt_text);

	return 1;
}

CMD:setweather(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	extract params -> new weather; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /setweather [погода (0-20)]");

	if(!(-1 <= weather <= 20))
	{
		SendClientMessage(playerid, 0x999999FF, ""SC"Погода от 0 до 20");
		SendClientMessage(playerid, 0x999999FF, ""SC"Рекомендовано: 1, 3, 8, 9, 18");

		return 1;
	}
	
	if(weather != -1)
		SetWeather(weather);	

	new fmt_text[999];

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил погоду на сервере на %d", GetPlayerNameEx(playerid), playerid, weather);
	SendMessageToAdmins(fmt_text, 0x999999FF);
	
	format(fmt_text, sizeof fmt_text, "{1E90FF}Вы успешно установили погоду на сервере на %d", weather);
	SendClientMessage(playerid, -1, fmt_text);

	return 1;
}

CMD:payday(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;

	OnPayDay();

	new fmt_text[50];

	SendClientMessage(playerid, -1, "Вы включили PayDay");

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] инициировал PayDay", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Инициировал PayDay");

	return 1;
}

