CMD:veh(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	extract params -> new model_id, color_1, color_2; else return SendClientMessage(playerid, 0xCECECEFF, "{FF5252}|{ffffff} Используйте: /veh [id модели] [цвет 1] [цвет 2] [доступ для игроков (не обязательно)]");

	if(!(400 <= model_id <= 30000)) return SendClientMessage(playerid, 0xCECECEFF, "{FF5252}|{ffffff}Используйте модель от 400 до 2591");

	new status;

	sscanf(params, "{d}{d}{d}d", status);

	if(!(0 <= status <= 1))
		return SendClientMessage(playerid, 0x999999FF, "{FF5252}|{ffffff}Доступ игроков к транспорту: 0 - Нет доступа, 1 - Доступно любому игроку");

	new Float: x,
		Float: y,
		Float: z,
		Float: a;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	new vehicleid = CreateVehicle(model_id, x, y, z, a, color_1, color_2, -1, 0, VEHICLE_ACTION_TYPE_ADMIN_CAR, status);

	SetTimerEx("DelayedPutPlayerInVehicle", 150, false, "ii", playerid, vehicleid);
	new plate[32];
	RandomNumberPlate(1, plate, sizeof(plate));
	SetVehicleNumberPlateEx(vehicleid, 1, plate, "52");
	new fmt_text[999];
	ChangeVehicleColor(vehicleid, color_1, color_2);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал транспорт (%d, %d, %d)",
	GetPlayerNameEx(playerid), playerid, model_id, color_1, color_2);
    SendMessageToAdmins(fmt_text, 0x999999FF);

	format(fmt_text, sizeof fmt_text, "Создал транспорт (%d, %d, %d)", model_id, color_1, color_2);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:pos(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	new Float: x, Float: y, Float: z, interior, virtual_world;

	if(sscanf(params, "P<,>fff", x, y, z))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /pos [x y z]");

	sscanf(params, "P<,>{fff}dd", interior, virtual_world);

	return SetPlayerPosEx(playerid, x, y, z, interior, virtual_world);
}

CMD:banip(playerid, params[])
{

	if (GetPlayerAdminEx(playerid) < 13)
		return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	new to_player, reason[128];
	if (sscanf(params, "us[128]", to_player, reason))
		return SendClientMessage(playerid, -1, ""SC"Используйте: /banip [id игрока] [причина]");

	if (!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationSander(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");

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

	if (GetPlayerAdminEx(playerid) < 13)
		return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	new target_name[24], reason[128];
	if (sscanf(params, "s[24]s[128]", target_name, reason))
		return SendClientMessage(playerid, -1, ""SC"Используйте: /banipoff [ник] [причина]");

	new query[128];
	mysql_format(mysql, query, sizeof query, "SELECT last_ip FROM accounts WHERE name='%e'", target_name);

	new Cache: result = mysql_query(mysql, query, true);
	if (cache_num_rows() == 0)
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

	if (GetPlayerAdminEx(playerid) < 13)
		return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

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

CMD:ban(playerid, params[])
{
	if (GetPlayerAdminEx(playerid) < 3)
		return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	if (!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /ban [id игрока] [время] [причина]");

	extract params -> new to_player, ban_time, string:reason[64];

	if (!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationSander(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");

	new max_days = GetPlayerAdminEx(playerid) > 4 ? 90 : 30;

	if (!(1 <= ban_time <= max_days))
	{
		new msg[128];
		format(msg, sizeof msg, ""SC"Срок бана может быть от 1 до %d дней", max_days);
		return SendClientMessage(playerid, 0xCECECEFF, msg);
	}

	if (GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя забанить администратора выше по рангу");

	if (AntiSliv(playerid, "/ban"))
		return true;

	new announce[256];
	format(announce, sizeof announce, "Администратор %s заблокировал игрока %s на %d дней", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), ban_time);
	if (strlen(reason)) format(announce, sizeof announce, "%s. Причина: %s", announce, reason);
	SendClientMessageToAll(0xFF5533FF, announce);

	InfoAstats[1] += 1;

	if (!strlen(reason)) reason = "Без причины";

	new log_msg[256];
	format(log_msg, sizeof log_msg, "Забанил %s[acc:%d] на %d дней. Причина: %s", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), ban_time, reason);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, log_msg);

	AddBan(GetPlayerAccountID(to_player), gettime(), ban_time, GetPlayerIpEx(to_player), reason, GetPlayerNameEx(playerid));

	Kick(to_player);

	return 1;
}

CMD:unban(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 3) return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	extract params -> new string: player_name[21];

	if(!strlen(player_name)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /unban [ник игрока]");

	new query[80],
		Cache: result,
		rows,
		uid,
		uip[16];

	mysql_format(mysql, query, sizeof query, "SELECT id, last_ip FROM accounts WHERE name='%s'", player_name);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		uid = cache_get_row_int(0, 0);
		cache_get_row(0, 1, uip);
	}

	cache_delete(result);

	if(!rows || !uid) return SendClientMessage(playerid, 0x999999FF, ""SC"Игрок с таким именем не найден");

	mysql_format(mysql, query, sizeof query, "SELECT * FROM ban_list WHERE user_id=%d", uid);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	cache_delete(result);

	if(!rows) return SendClientMessage(playerid, 0x999999FF, ""SC"Аккаунт игрока не заблокирован");

	mysql_format(mysql, query, sizeof query, "DELETE FROM ban_list WHERE user_id=%d", uid);
	mysql_query(mysql, query, false);

	format(query, sizeof query, "unbanip %s", uip);
	SendRconCommand(query);

	SendRconCommand("reloadbans");

	format(query, sizeof query, "Администратор %s разблокировал игрока %s", GetPlayerNameEx(playerid), player_name);

	SendClientMessageToAll(0xFF5533FF, query);

	format(query, sizeof query, "Разбанил %s[acc:%d]", player_name, uid);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, query);

	return 1;
}

CMD:setskin(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 12) return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	extract params -> new to_player, skin_id; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /setskin [id игрока] [id скина]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationSander(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");
	if(TEST_SERVER == 1)
	{
	    if(playerid != to_player) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Данную команду можно использовать на ТЕСТ СЕРВЕРЕ только по отношению к себе!");
	}

	if(GetPlayerTeamEx(to_player)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя сменить скин игроку, находящемуся в организации");

	if(!(1 <= skin_id <= 6500046)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"ID скина от 1 до 20000");

	SetPlayerData(to_player, P_SKIN, skin_id);
	UpdatePlayerDatabaseInt(to_player, "skin", skin_id);

	SetPlayerSkinInit(to_player);

	new fmt_text[999];

    format(fmt_text, sizeof fmt_text, "{1E90FF}Вы выдали скин №%d игроку %s[%d]", skin_id, GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "{1E90FF}Вам был выдан скин №%d администратором %s[%d]", skin_id, GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "{FF5533}[A] %s[%d] выдал %s[%d] скин №%d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, skin_id);
	SendMessageToAdmins(fmt_text, 0xCECECEFF);

	format(fmt_text, sizeof fmt_text, "Установил %s[acc:%d] скин %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), skin_id);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:myskin(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;

	ShowPlayerDialog(playerid,DLG_MYSKIN,DIALOG_STYLE_INPUT,"Мой скин","Введите ID скина от 1 до 600","Применить","Отмена");

	return 1;
}

CMD:offban(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 3) return 1;

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /offban [ник игрока] [кол-во дней] [причина]");

	extract params -> new string: player_name[21], days, string: reason[30];

	if(!(1 <= days <= 90)) return SendClientMessage(playerid, 0x999999FF, "Количество дней от 1 до 90");

	if(IsPlayerConnected(GetPlayerID(player_name))) return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем находится на сервере");

	new query[144],
		Cache: result,
		rows,
		uid,
		admin,
		uip[16];

	mysql_format(mysql, query, sizeof query, "SELECT id, admin, last_ip FROM accounts WHERE name='%s'", player_name);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		uid = cache_get_row_int(0, 0);
		admin = cache_get_row_int(0, 1);
		cache_get_row(0, 2, uip);
	}

	cache_delete(result);

	if(!rows || !uid) return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

	if(GetPlayerAdminEx(playerid) < admin) return SendClientMessage(playerid, 0x999999FF, "Нельзя забанить администратора выше по рангу");

	mysql_format(mysql, query, sizeof query, "SELECT * FROM ban_list WHERE user_id=%d", uid);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	cache_delete(result);

	if(rows) return SendClientMessage(playerid, 0x999999FF, "Аккаунт игрока уже заблокирован");

	if(AntiSliv(playerid, "/offban")) return true;

	format(query, sizeof query, "Администратор %s заблокировал игрока %s на %d дней", GetPlayerNameEx(playerid), player_name, days);

	if(strlen(reason) > 0)
		format(query, sizeof query, "%s. Причина: %s", query, reason);

	if(!strlen(reason)) reason = "None";

	SendClientMessageToAll(0xFF5533FF, query);

	format(query, sizeof query, "Оффлайн забанил %s[acc:%d] на %d дней. Причина: %s", player_name, uid, days, reason);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, query);

	format(reason, sizeof reason, "s", reason);

	AddBan(uid, gettime(), days, uip, reason, GetPlayerNameEx(playerid));

	return 1;
}

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
		GetBusinessData(biz_id, B_POS_X),
		GetBusinessData(biz_id, B_POS_Y),
		GetBusinessData(biz_id, B_POS_Z) + 1.0,
		0.0
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
	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	extract params -> new to_player, interior; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /inter [id игрока] [интерьер]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationSander(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");
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

CMD:warn(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 2) return 1;

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /warn [id игрока] [причина (необязательно)]");

	extract params -> new to_player, string:reason[66];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Нельзя выдать предупреждение админу выше по рангу");

	if(AntiSliv(playerid, "/warn")) return true;

	AddPlayerData(to_player, P_WARN, +, 1);
	SetPlayerData(to_player, P_WARN_TIME, gettime() + (86400 * 10));

	new fmt_msg[128];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал предупреждение игроку %s [%d|3]", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), GetPlayerData(to_player, P_WARN));

	if(strlen(reason) > 0)
		format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

	SendClientMessageToAll(0xFF5533FF, fmt_msg);

	InvitePlayer(to_player, 0, 0, true);

	new uid = GetPlayerAccountID(to_player);
	new warns = GetPlayerData(to_player, P_WARN);
	new warns_time = GetPlayerData(to_player, P_WARN_TIME);

	format(fmt_msg, sizeof fmt_msg, "Выдал варн %s[acc:%d] (%d/3). Причина: %d", GetPlayerNameEx(to_player), uid, warns, reason);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	if(warns >= 3)
	{
		SendClientMessage(to_player, 0xFF5533FF, "Аккаунт заблокирован на 10 дней");

		warns =
		warns_time = 0;

		AddBan(uid, gettime(), 10, GetPlayerIpEx(to_player), "получено 3 варна", GetPlayerNameEx(playerid));
		BanEx(to_player, "получено 3 варна");
	}
	else Kick:(to_player);

	format(fmt_msg, sizeof fmt_msg, "UPDATE accounts SET warn=%d,warn_time=%d WHERE id=%d", warns, warns_time, uid);
	mysql_query(mysql, fmt_msg, false);

	return 1;
}

CMD:unwarn(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 2) return 1;
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /warn [id игрока] [причина (необязательно)]");

	extract params -> new to_player, string: reason[66];
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	SetPlayerData(to_player, P_WARN, 		0);
	SetPlayerData(to_player, P_WARN_TIME, 	0);

	UpdatePlayerDatabaseInt(to_player, "warn", 		0);
	UpdatePlayerDatabaseInt(to_player, "warn_time", 	0);

	new fmt_msg[128];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s снял все предупреждения с игрока %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));

	if(strlen(reason) > 0)
		format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

	SendClientMessageToAll(0xFF5533FF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Снял все варны %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

CMD:spawn(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	extract params -> new to_player, string: reason[30]; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /spawn [id игрока] [Причина]");

	if(TEST_SERVER == 1)
	{
	    if(playerid != to_player) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}На ТЕСТ СЕРВЕРЕ данную команду можно использовать только по отношению к себе!");
	}

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return ShowNotificationSander(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");

	SetPlayerSpawnInit(to_player);
	SpawnPlayer(to_player);

	new fmt_msg[999];

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

CMD:spcar(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3) return 1;

	extract params -> new vehicleid; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /spcar [id авто]");

	if(IsPlayerInAnyVehicle(playerid) && vehicleid == 0) vehicleid = GetPlayerVehicleID(playerid);

	if(!IsValidVehicle(vehicleid)) return SendClientMessage(playerid, 0xCECECEFF, "Данного транспорта не существует на сервере");

	SetVehicleToRespawn(vehicleid);

	new fmt_msg[100];

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_msg, sizeof fmt_msg, "[A] Администратор %s[%d] зареспавнил авто [№%d]", GetPlayerNameEx(playerid), playerid, vehicleid);
		SendMessageToAdmins(fmt_msg, 0x999999FF);
	}

	format(fmt_msg, sizeof fmt_msg, "Зареспавнил авто №%d", vehicleid);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

CMD:tplist(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1) return 1;

	ShowTeleportList(playerid);

	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Использует меню телепортов");

	return 1;
}

CMD:tp(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1)
	return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команды", " ");

	ShowTeleportList(playerid);

	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Использует меню телепортов");

	return 1;
}

alias:goto("g")

CMD:goto(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1)
    return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команды", " ");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /goto [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationSander(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");

    if(GetPlayerSecretEx(to_player) >= 1)
	    return SendClientMessage(playerid, 0xCECECEFF, "У игрока есть привелегия скрытность");

	new Float: x, Float: y, Float: z, interior, virtual_world;
	GetPlayerPos(to_player, x, y, z);
	interior = GetPlayerInterior(to_player);
	virtual_world = GetPlayerVirtualWorld(to_player);

	SetPlayerPosEx(playerid, x + 1, y + 1, z, 0.0, interior, virtual_world, false);

	SetPlayerInHouse(playerid, GetPlayerInHouse(to_player));
	SetPlayerInBiz(playerid, GetPlayerInBiz(to_player));

	new fmt_msg[999];
    format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] телепортировался к %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
    SendMessageToAdmins(fmt_msg, 0x999999FF);

	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы успешно телепортировались к игроку %s[%d]", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, 0x66CC00FF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Администратор %s[%d] успешно к Вам телепортировался.", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, 0x66CC00FF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Телепортировался к %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

alias:gethere("gh")

CMD:gethere(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 2)
    return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /gethere [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationSander(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");

	if(GetPlayerSecretEx(to_player) >= 1)
		return SendClientMessage(playerid, 0xCECECEFF, "У игрока есть привелегия скрытность");

	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
	{
		SendClientMessage(playerid, 0x66CC33FF, "Вы пытаетесь телепортировать к себе администратора Выше рангом, он должен подтвердить Ваше действие");
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_GETHERE);
	}
	else
	{
		new Float: x, Float: y, Float: z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerPosEx(to_player, x + 1, y + 1, z, 0.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), false);

		SetPlayerInHouse(to_player, GetPlayerInHouse(playerid));
		SetPlayerInBiz(to_player, GetPlayerInBiz(playerid));

		new fmt_msg[999];
		format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] телепортировал к себе %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
		SendMessageToAdmins(fmt_msg, 0x999999FF);

		format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы успешно телепортировали %s[%d] к себе", GetPlayerNameEx(to_player), to_player);
		SendClientMessage(playerid, -1, fmt_msg);

	    format(fmt_msg, sizeof fmt_msg, "{1E90FF}Администратор %s[%d] успешно телепортировал Вас к себе.", GetPlayerNameEx(playerid), playerid);
    	SendClientMessage(to_player, 0x66CC00FF, fmt_msg);

		format(fmt_msg, sizeof fmt_msg, "Телепортировал к себе %s[acc:%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
		SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
	}

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

CMD:vget(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	extract params -> new vehicleid; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /vget [id транспорта]");
	if(!IsValidVehicle(vehicleid)) return SendClientMessage(playerid, 0xCECECEFF, "Данного транспорта не существует на сервере");

	new Float: x, Float: y, Float: z;
	GetPlayerPos(playerid, x, y, z);

	SetVehiclePos(vehicleid, x + 2.0, y + 2.0, z);

	new fmt_msg[999];

	format(fmt_msg, sizeof fmt_msg, "Телепортировался к себе авто №%d", vehicleid);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] телепортировал к себе авто №%d", GetPlayerNameEx(playerid), playerid, vehicleid);
	SendMessageToAdmins(fmt_msg, 0x999999FF);

	SendClientMessage(playerid, -1, "{1E90FF}Вы телепортировали авто к себе");

	return 1;
}

CMD:getv(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /getv [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationSander(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");

	if(GetPlayerOwnableCar(to_player) == INVALID_VEHICLE_ID)
		return SendClientMessage(playerid, 0x999999FF, ""SC"У игрока нет личного транспорта");

	new fmt_text[999],
		Float: x,
		Float: y,
		Float: z;

	GetPlayerPos(to_player, x, y, z);

	SetVehiclePos(GetPlayerOwnableCar(to_player), x + 2.0, y + 2.0, z);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] телепортировал к %s[%d] его личный транспорт", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	format(fmt_text, sizeof fmt_text, "{1E90FF}Вы телепортировали к %s[%d] его личный транспорт", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "{1E90FF}Администратор %s[%d] телепортировал к Вам Ваш личный транспорт", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "Телепортировался к %s[acc:%d] его авто", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:fixcar(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /fixcar [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationSander(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");

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
	if(GetPlayerAdminEx(playerid) < 3) return 1;

	extract params -> new vehicleid, fuel; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setfuel [id транспорта] [кол-во топлива]");

	if(!IsValidVehicle(vehicleid)) return SendClientMessage(playerid, 0xCECECEFF, "Данного транспорта не существует на сервере");

	if(!(0 <= fuel <= 150)) return SendClientMessage(playerid, 0x999999FF, "Количество топлива от 0 до 150");

	SetVehicleData(vehicleid, V_FUEL, fuel);

	new fmt_text[80];

	format(fmt_text, sizeof fmt_text, "Вы установили %d топлива в ТС №%d", fuel, vehicleid);
	SendClientMessage(playerid, -1, fmt_text);

	if(GetPlayerAdminEx(playerid) >= 5)
	{
		format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил %d топлива в ТС №%d", GetPlayerNameEx(playerid), playerid, fuel, vehicleid);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	format(fmt_text, sizeof fmt_text, "Установил %d топлива в авто №%d", fuel, vehicleid);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:settime(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;

	extract params -> new time; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /settime [время (0-23)]");

	if(!(0 <= time <= 23)) return SendClientMessage(playerid, 0x999999FF, "Время от 0 до 23 часов");

	SetWorldTime(time);

	new fmt_text[70];

	format(fmt_text, sizeof fmt_text, "Вы установили время %02d:00", time);
	SendClientMessage(playerid, -1, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил время на сервере на %02d:00", GetPlayerNameEx(playerid), playerid, time);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	format(fmt_text, sizeof fmt_text, "Установил время %02d:00 на сервере", time);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:setweather(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;

	extract params -> new weather; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setweather [погода (0-20)]");

	if(!(-1 <= weather <= 20))
	{
		SendClientMessage(playerid, 0x999999FF, "Погода от 0 до 20 (-1 - случайная смена погоды)");
		SendClientMessage(playerid, 0x999999FF, "Рекомендовано: 1, 3, 8, 9, 18");

		return 1;
	}

	if(weather != -1)
		SetWeather(weather);
	else
		SetRandomWeather();

	new fmt_text[70];

	if(weather != -1)
		format(fmt_text, sizeof fmt_text, "Вы установили погоду %d", weather);
	else
		format(fmt_text, sizeof fmt_text, "Вы установили случайную погоду");

	SendClientMessage(playerid, -1, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		if(weather != -1)
			format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил погоду на сервере на %d", GetPlayerNameEx(playerid), playerid, weather);
		else
			format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил случайную погоду на сервере", GetPlayerNameEx(playerid), playerid);

		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	format(fmt_text, sizeof fmt_text, "Установил погоду №%d на сервере", weather);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:payday(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	OnPayDay();

	new fmt_text[50];

	SendClientMessage(playerid, -1, "Вы включили PayDay");

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] инициировал PayDay", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Инициировал PayDay");

	return 1;
}

CMD:gzcolor(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new gang_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /gzcolor [id банды] (0-Свободная зона, 1-Арзамасская ОПГ, 2-Батыревская ОПГ, 3-Лыткаринская ОПГ)");

	if(!(0 <= gang_id <= 3))
		return SendClientMessage(playerid, 0x999999FF, "Банды: 0-Свободная зона, 1-Арзамасская ОПГ, 2-Батыревская ОПГ, 3-Лыткаринская ОПГ");

	new gang_zone_id = -1;

	for(new idx; idx < g_gang_zones_loaded; idx ++)
	{
		if(!IsPlayerInDynamicArea(playerid, GetGangZoneData(idx, GZ_AREA))) continue;

		gang_zone_id = idx;
		break;
	}

	if(gang_zone_id == -1)
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться на нужной территории");

	new fmt_text[75];

	SendClientMessage(playerid, -1, "Вы изменили банду, владеющую данной территорией");

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] изменил банду у территории №%d на %d", GetPlayerNameEx(playerid), playerid, gang_zone_id, gang_id);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	format(fmt_text, sizeof fmt_text, "Изменил банду у территории №%d на %d", gang_zone_id, gang_id);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:sellproperty(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	SellDebtorsProperty();

	new fmt_text[75];

	SendClientMessage(playerid, -1, "Вы инициировали продажу имущества должников");

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] инициировал продажу имущества должников", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Иницировал продажу имущества должников");

	return 1;
}

CMD:sellhotels(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	SellDebtorsHotels();

	new fmt_text[90];

	SendClientMessage(playerid, -1, "Вы инициировали продажу номеров с задолженностью в отеле");

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] инициировал продажу номеров с задолженностью в отеле", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Инициировал продажу номеров в отеле");

	return 1;
}

CMD:setprods(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0 && strcmp(GetPlayerNameEx(playerid), "Majorka_Gromov", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new biz_id, amount; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setprods [id бизнеса] [кол-во]");

	if(!(0 <= amount <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "Количество продуктов от 0 до 10000");

	if(!(0 <= biz_id <= g_business_loaded - 1))
		return SendClientMessage(playerid, 0x999999FF, "Данного бизнеса не существует на сервере");

	SetBusinessData(biz_id, B_PRODS, amount);

	new fmt_text[90];

	format(fmt_text, sizeof fmt_text, "UPDATE business SET products=%d WHERE id=%d", GetBusinessData(biz_id, B_PRODS), GetBusinessData(biz_id, B_SQL_ID));
	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы установили %d продуктов в бизнесе №%d", amount, biz_id);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил %d продуктов в бизнесе №%d", GetPlayerNameEx(playerid), playerid, amount, biz_id);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}

CMD:fullbiz(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0 && strcmp(GetPlayerNameEx(playerid), "Majorka_Gromov", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new amount; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /fullbiz [кол-во]");

	if(!(0 <= amount <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "Количество от 0 до 10000");

	new value[12];
	valstr(value, amount);
	callcmd::fullprods(playerid, value);
	callcmd::fullfuels(playerid, value);

	return 1;
}

CMD:fullprods(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0 && strcmp(GetPlayerNameEx(playerid), "Majorka_Gromov", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new amount; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /fullprods [кол-во]");

	if(!(0 <= amount <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "Количество продуктов от 0 до 10000");

	for(new biz_id; biz_id < g_business_loaded - 1; biz_id ++)
		SetBusinessData(biz_id, B_PRODS, amount);

	new fmt_text[90];

	format(fmt_text, sizeof fmt_text, "UPDATE business SET products=%d", amount);
	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы установили %d продуктов во всех бизнесах", amount);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил %d продуктов во всех бизнесах", GetPlayerNameEx(playerid), playerid, amount);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}

CMD:setfuels(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0 && strcmp(GetPlayerNameEx(playerid), "Majorka_Gromov", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new fs_id, amount; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setfuels [id АЗС] [кол-во]");

	if(!(0 <= amount <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "Количество топлива от 0 до 10000");

	if(!(0 <= fs_id <= g_fuel_station_loaded-1))
		return SendClientMessage(playerid, 0x999999FF, "Данной АЗС не существует на сервере");

	SetFuelStationData(fs_id, FS_FUELS, amount);

	new fmt_text[90];

	format(fmt_text, sizeof fmt_text, "UPDATE fuel_stations SET fuels=%d WHERE id=%d", GetFuelStationData(fs_id, FS_FUELS), GetFuelStationData(fs_id, FS_SQL_ID));
	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы установили %d топлива в АЗС №%d", amount, fs_id);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил %d топлива в АЗС №%d", GetPlayerNameEx(playerid), playerid, amount, fs_id);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}

CMD:fullfuels(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0 && strcmp(GetPlayerNameEx(playerid), "Majorka_Gromov", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new amount; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /fullfuels [кол-во]");

	if(!(0 <= amount <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "Количество топлива от 0 до 10000");

	for(new fs_id; fs_id < g_fuel_station_loaded - 1; fs_id ++)
		SetFuelStationData(fs_id, FS_FUELS, amount);

	new fmt_text[90];

	format(fmt_text, sizeof fmt_text, "UPDATE fuel_stations SET fuels=%d", amount);
	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы установили %d топлива во всех АЗС", amount);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] установил %d топлива во всех АЗС", GetPlayerNameEx(playerid), playerid, amount);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}

CMD:addbiz(playerid, params[])
{
    if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0)
        return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

    new type, price, rent_price, name[64];

    if(sscanf(params, "iiis[64]", type, price, rent_price, name))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addbiz [тип] [стоимость] [цена аренды] [название]");

    new fmt_text[512];

    if(!(1 <= type <= 16))
        return SendClientMessage(playerid, 0x999999FF, "Типы бизнесов: 1-24/7, 2-Клуб, 3-Управление стат., 4-Риэлторск., 5-Одежда, 6-Отель, 7-Авторынок, 8-Казино, 9-Сотовый салон, 10-Тюнинг салон, 11-Магазин оружия");

    if(price < 1)
        return SendClientMessage(playerid, 0x999999FF, "Стоимость бизнеса не может быть меньше 1");

    if(rent_price < 1)
        return SendClientMessage(playerid, 0x999999FF, "Стоимость аренды не может быть меньше 1");

    if(strlen(name) < 3 || strlen(name) > 64)
        return SendClientMessage(playerid, 0x999999FF, "Название бизнеса должно быть от 3 до 64 символов");

    new Cache: result,
        idx = g_business_loaded;

    GetPlayerPos(playerid, g_business[idx][B_POS_X], g_business[idx][B_POS_Y], g_business[idx][B_POS_Z]);

    SetBusinessData(idx, B_PRICE,            price);
    SetBusinessData(idx, B_RENT_PRICE,        rent_price);
    SetBusinessData(idx, B_TYPE,            type);
    SetBusinessData(idx, B_INTERIOR,        type-1);

    format
    (
        fmt_text, sizeof fmt_text,
        "INSERT INTO business \
        (name, type, price, rent_price, x, y, z, interior) \
        VALUES ('%s', '%d', '%d', '%f', '%f', '%f', '%f', '%d')",
        name, type, price, rent_price,
        GetBusinessData(idx, B_POS_X),
        GetBusinessData(idx, B_POS_Y),
        GetBusinessData(idx, B_POS_Z),
        type-1
    );

    result = mysql_query(mysql, fmt_text, true);

    SetBusinessData(idx, B_SQL_ID,         cache_insert_id());

    cache_delete(result);

    g_business_loaded ++;

    CreatePickup(19132, 23, GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), GetBusinessData(idx, B_POS_Z), 0, PICKUP_ACTION_TYPE_BIZ_ENTER, idx);

    UpdateBusinessLabel(idx);

    new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
    GetCityName(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), city);
    GetAreaName(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), area);
    format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал бизнес №%d \"%s\" (%s / %s)",
        GetPlayerNameEx(playerid), playerid, idx, name, city, area);

    SendMessageToAdmins(fmt_text, 0x66CC33FF);

    SendClientMessage(playerid, 0x3399FFFF, "Используйте {FF5252}/bsetexitpos{3399FF}, чтобы завершить создание бизнеса");

    return 1;
}

CMD:delbiz(playerid, params[])
{
    if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

    new bizid;

    if(sscanf(params, "d", bizid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /delbiz [ID бизнеса]");

    if(bizid < 0 || bizid >= g_business_loaded)
        return SendClientMessage(playerid, 0x999999FF, "Неверный ID бизнеса");

    new fmt_text[320];

        DestroyDynamic3DTextLabel(GetBusinessData(bizid, B_LABEL));

    format(fmt_text, sizeof fmt_text, "DELETE FROM business WHERE id = '%d'", GetBusinessData(bizid, B_SQL_ID));
    mysql_query(mysql, fmt_text, false);

    for(new i = 0; i < MAX_BUSINESS; i++)
    {
        SetBusinessData(bizid, i, 0);
    }

    for(new i = bizid + 1; i < g_business_loaded; i++)
    {
        for(new j = 0; j < MAX_BUSINESS; j++)
        {
            SetBusinessData(i - 1, j, GetBusinessData(i, j));
        }
    }

    g_business_loaded--;

    for(new i = 0; i < g_business_loaded; i++)
    {
        UpdateBusinessLabel(i);
    }

    new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
    GetCityName(GetBusinessData(bizid, B_POS_X), GetBusinessData(bizid, B_POS_Y), city);
    GetAreaName(GetBusinessData(bizid, B_POS_X), GetBusinessData(bizid, B_POS_Y), area);
    format(fmt_text, sizeof fmt_text, "[A] %s[%d] удалил бизнес №%d (%s / %s)",
        GetPlayerNameEx(playerid), playerid, bizid, city, area);

    SendMessageToAdmins(fmt_text, 0xFF6666FF);

    SendClientMessage(playerid, 0x3399FFFF, "Бизнес успешно удален!");

    return 1;
}

CMD:bsetexitpos(playerid, params[])
{

	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new biz_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /bsetexitpos [id бизнеса]");

	if(!(0 <= biz_id <= g_business_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "Данного бизнеса не существует на сервере");

	GetPlayerPos(playerid, g_business[biz_id][B_EXIT_POS_X], g_business[biz_id][B_EXIT_POS_Y], g_business[biz_id][B_EXIT_POS_Z]);
	GetPlayerFacingAngle(playerid, g_business[biz_id][B_EXIT_ANGLE]);

	new fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE business SET exit_x='%f', exit_y='%f', exit_z='%f', exit_angle='%f' WHERE id=%d",
		GetBusinessData(biz_id, B_EXIT_POS_X),
		GetBusinessData(biz_id, B_EXIT_POS_Y),
		GetBusinessData(biz_id, B_EXIT_POS_Z),
		GetBusinessData(biz_id, B_EXIT_ANGLE),
		GetBusinessData(biz_id, B_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты выхода у бизнеса №%d", biz_id);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

CMD:bsetpos(playerid, params[])
{

	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new biz_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /bsetpos [id бизнеса]");

	if(!(0 <= biz_id <= g_business_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "Данного бизнеса не существует на сервере");

	GetPlayerPos(playerid, g_business[biz_id][B_POS_X], g_business[biz_id][B_POS_Y], g_business[biz_id][B_POS_Z]);

	new fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE business SET x='%f', y='%f', z='%f' WHERE id=%d",
		GetBusinessData(biz_id, B_POS_X),
		GetBusinessData(biz_id, B_POS_Y),
		GetBusinessData(biz_id, B_POS_Z),
		GetBusinessData(biz_id, B_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты входа у бизнеса №%d (%s)", biz_id, GetBusinessData(biz_id, B_NAME));
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	SendClientMessage(playerid, -1, "Не забудьте использовать /bsetexitpos id Для изменения координат выхода");
	UpdateBusinessLabel(biz_id);
	return 1;
}

CMD:addfuelst(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new price, rent_price; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addfuelst [стоимость] [цена аренды]");

	if(price < 1) return SendClientMessage(playerid, 0xCECECEFF, "Стоимость бензоколонки не может быть меньше 1");

	if(rent_price < 1) return SendClientMessage(playerid, 0xCECECEFF, "Стоимость бензоколонки не может быть меньше 1");

	new Cache: result,
		idx = g_fuel_station_loaded;

	GetPlayerPos(playerid, g_fuel_station[idx][FS_POS_X], g_fuel_station[idx][FS_POS_Y], g_fuel_station[idx][FS_POS_Z]);

	new fmt_text[256];

	format
	(

		fmt_text, sizeof fmt_text,
		"INSERT INTO `fuel_stations`\
		(`price`,`rent_price`,`fuels`, `fuel_price`, `buy_fuel_price`, `balance`, `x`, `y`, `z`)\
		VALUES('%d','%d','100','50','50','100000','%f','%f','%f')",
		price, rent_price,
		GetFuelStationData(idx, FS_POS_X),
		GetFuelStationData(idx, FS_POS_Y),
		GetFuelStationData(idx, FS_POS_Z)
	);

	result = mysql_query(mysql, fmt_text, true);

	SetFuelStationData(idx, FS_SQL_ID, 		cache_insert_id());

	cache_delete(result);

	g_fuel_station_loaded ++;

	SetFuelStationData(idx, FS_LABEL, CreateDynamic3DTextLabel("бензоколонка", 0xFF5252FF, GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z) + 0.3, 6.50));

	UpdateFuelStationLabel(idx);

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал заправку №%d", GetPlayerNameEx(playerid), playerid, idx);

	SendMessageToAdmins(fmt_text, 0x66CC33FF);
	return 1;
}

CMD:delfuelst(playerid, params[])
{
    if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

    new fstid;

    if(sscanf(params, "d", fstid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /delfuelst [ID заправки]");

    if(fstid < 0 || fstid >= g_fuel_station_loaded)
        return SendClientMessage(playerid, 0x999999FF, "Неверный ID заправки");

    new fmt_text[256];

        DestroyDynamic3DTextLabel(GetFuelStationData(fstid, FS_LABEL));

    format(fmt_text, sizeof fmt_text, "DELETE FROM fuel_stations WHERE id = '%d'", GetFuelStationData(fstid, FS_SQL_ID));
    mysql_query(mysql, fmt_text, false);

    for(new i = 0; i < MAX_FUEL_STATIONS; i++)
    {
        SetFuelStationData(fstid, i, 0);
    }

    for(new i = fstid + 1; i < g_fuel_station_loaded; i++)
    {
        for(new j = 0; j < MAX_FUEL_STATIONS; j++)
        {
            SetFuelStationData(i - 1, j, GetFuelStationData(i, j));
        }
    }

    g_fuel_station_loaded--;

    for(new i = 0; i < g_fuel_station_loaded; i++)
    {
        UpdateFuelStationLabel(i);
    }

    format(fmt_text, sizeof fmt_text, "[A] %s[%d] удалил заправку №%d",
        GetPlayerNameEx(playerid), playerid, fstid);

    SendMessageToAdmins(fmt_text, 0xFF6666FF);

    SendClientMessage(playerid, 0x3399FFFF, "Заправка успешно удалена!");

    return 1;
}

CMD:addhouse(playerid, params[])
{

	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new type, price, rent_price; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addhouse [тип] [стоимость] [цена аренды]");

	new fmt_text[300];

	if(!(0 <= type <= sizeof g_house_type - 1))
	{
		SendClientMessage(playerid, 0x999999FF, "Типы домов:");

		for(new i; i < sizeof g_house_type; i ++)
		{
			format(fmt_text, sizeof fmt_text, "%d. %s", i, GetHouseTypeInfo(i, HT_NAME));

			SendClientMessage(playerid, 0xCECECEFF, fmt_text);
		}

		return 1;
	}

	if(price < 1) return SendClientMessage(playerid, 0x999999FF, "Стоимость дома не может быть меньше 1");

	if(rent_price < 1) return SendClientMessage(playerid, 0x999999FF, "Стоимость аренды не может быть меньше 1");

	new Cache: result,
		idx = g_house_loaded;

	GetPlayerPos(playerid, g_house[idx][H_POS_X], g_house[idx][H_POS_Y], g_house[idx][H_POS_Z]);

	SetHouseData(idx, H_PRICE,			price);
	SetHouseData(idx, H_RENT_PRICE,		rent_price);
	SetHouseData(idx, H_TYPE,			type);

	SetHouseData(idx, H_ENTRACE,		-1);

	format
	(
		fmt_text, sizeof fmt_text,
		"INSERT INTO houses \
		(type, price, rent_price, x, y, z)\
		VALUES ('%d', '%d', '%f', '%f', '%f', '%f')",
		type, price, rent_price,
		GetHouseData(idx, H_POS_X),
		GetHouseData(idx, H_POS_Y),
		GetHouseData(idx, H_POS_Z)
	);

	result = mysql_query(mysql, fmt_text, true);

	SetHouseData(idx, H_SQL_ID, 		cache_insert_id());

	cache_delete(result);

	g_house_loaded ++;

	UpdateHouse(idx);

	new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
	GetCityName(GetHouseData(idx, H_POS_X), GetHouseData(idx, H_POS_Y), city);
	GetAreaName(GetHouseData(idx, H_POS_X), GetHouseData(idx, H_POS_Y), area);
	format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал дом №%d (%s / %s)", GetPlayerNameEx(playerid), playerid, idx, city, area);

	SendMessageToAdmins(fmt_text, 0x66CC33FF);

	SendClientMessage(playerid, 0x3399FFFF, "Используйте {FF5252}/setexitpos и /setcarpos{3399FF}, чтобы завершить создание дома");

	return 1;
}

CMD:delhouse(playerid, params[])
{
    if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

    new houseid;

    if(sscanf(params, "d", houseid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /delhouse [ID дома]");

    if(houseid < 0 || houseid >= g_house_loaded)
        return SendClientMessage(playerid, 0x999999FF, "Неверный ID дома");

    new fmt_text[300];

        DestroyPickup(GetHouseData(houseid, H_ENTER_PICKUP));

    format(fmt_text, sizeof fmt_text, "DELETE FROM houses WHERE id = '%d'", GetHouseData(houseid, H_SQL_ID));
    mysql_query(mysql, fmt_text, false);

    format(fmt_text, sizeof fmt_text, "DELETE FROM house_cars WHERE house_id = '%d'", GetHouseData(houseid, H_SQL_ID));
    mysql_query(mysql, fmt_text, false);

    for(new i = 0; i < MAX_HOUSES; i++)
    {
        SetHouseData(houseid, i, 0);
    }

    for(new i = houseid + 1; i < g_house_loaded; i++)
    {
        for(new j = 0; j < MAX_HOUSES; j++)
        {
            SetHouseData(i - 1, j, GetHouseData(i, j));
        }
    }

    g_house_loaded--;

    for(new i = 0; i < g_house_loaded; i++)
    {
        UpdateHouse(i);
    }

    new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
    GetCityName(GetHouseData(houseid, H_POS_X), GetHouseData(houseid, H_POS_Y), city);
    GetAreaName(GetHouseData(houseid, H_POS_X), GetHouseData(houseid, H_POS_Y), area);
    format(fmt_text, sizeof fmt_text, "[A] %s[%d] удалил дом №%d (%s / %s)",
        GetPlayerNameEx(playerid), playerid, houseid, city, area);

    SendMessageToAdmins(fmt_text, 0xFF6666FF);

    SendClientMessage(playerid, -1, "Дом успешно удален!");

    return 1;
}

CMD:setexitpos(playerid, params[])
{
    if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new house_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setexitpos [id дома]");

	if(!(0 <= house_id <= g_house_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "Данного дома не существует на сервере");

	GetPlayerPos(playerid, g_house[house_id][H_EXIT_POS_X], g_house[house_id][H_EXIT_POS_Y], g_house[house_id][H_EXIT_POS_Z]);
	GetPlayerFacingAngle(playerid, g_house[house_id][H_EXIT_ANGLE]);

	new fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE houses SET exit_x='%f', exit_y='%f', exit_z='%f', exit_angle='%f' WHERE id=%d",
		GetHouseData(house_id, H_EXIT_POS_X),
		GetHouseData(house_id, H_EXIT_POS_Y),
		GetHouseData(house_id, H_EXIT_POS_Z),
		GetHouseData(house_id, H_EXIT_ANGLE),
		GetHouseData(house_id, H_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты выхода у дома №%d", house_id);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

CMD:setcarpos(playerid, params[])
{

	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new house_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setcarpos [id дома]");

	if(!(0 <= house_id <= g_house_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "Данного дома не существует на сервере");

	GetPlayerPos(playerid, g_house[house_id][H_CAR_POS_X], g_house[house_id][H_CAR_POS_Y], g_house[house_id][H_CAR_POS_Z]);
	GetPlayerFacingAngle(playerid, g_house[house_id][H_CAR_ANGLE]);

	new fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE houses SET car_x='%f', car_y='%f', car_z='%f', car_angle='%f' WHERE id=%d",
		GetHouseData(house_id, H_CAR_POS_X),
		GetHouseData(house_id, H_CAR_POS_Y),
		GetHouseData(house_id, H_CAR_POS_Z),
		GetHouseData(house_id, H_CAR_ANGLE),
		GetHouseData(house_id, H_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты спавна авто у дома №%d", house_id);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

CMD:getname(playerid, params[])
{
	if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSander(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");

	extract params -> new user_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /getname [номер аккаунта]");

	new name[21],
		fmt_text[120];

	format(name, sizeof name, "%s", GetPlayerNameBySqlID(user_id));

	if(strcmp(name, "none", true))
	{
		format(fmt_text, sizeof fmt_text, "Имя: %s / Номер аккаунта: %d", name, user_id);

		SendClientMessage(playerid, 0x3399FFFF, fmt_text);
	}
	else SendClientMessage(playerid, 0x999999FF, "Данный аккаунт не найден в базе данных");

	return 1;
}

CMD:slap(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;

	extract params -> new to_player, set_code, string: reason[30]; else {

		SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /slap [id игрока] [0 - вверх, 1 - вниз] [причина]");

		return 1;
	}

	new Float: x, Float: y, Float: z, fmt_text[999];
	GetPlayerPos(to_player, x, y, z);

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationSander(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");

	new fmt_msg[999];

	switch(set_code)
	{
		case 0:
		{
			SetPlayerPos(to_player, x, y, z + 5);
			PlayerPlaySound(to_player, 1130, 0.0, 0.0, 0.0);

			format(fmt_text, sizeof fmt_text, "[A] %s[%d] подбросил игрока %s[%d]. Причина: %s ", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, reason);
			SendMessageToAdmins(fmt_text, 0x999999FF);

			format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы подбросили игрока %s[%d]. Причина: %s ", GetPlayerNameEx(to_player), to_player, reason);
			SendClientMessage(playerid, -1, fmt_msg);

			format(fmt_text, sizeof fmt_text, "{1E90FF}Администратор %s[%d] подбросил Вас. Причина: %s ", GetPlayerNameEx(playerid), playerid, reason);
			SendClientMessage(to_player, -1, fmt_text);
		}
		case 1:
		{
			SetPlayerPos(to_player, x, y, z -5);
			PlayerPlaySound(to_player, 1130, 0.0, 0.0, 0.0);

			format(fmt_text, sizeof fmt_text, "[A] %s[%d] подбросил игрока %s[%d]. Причина: %s ", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, reason);
			SendMessageToAdmins(fmt_text, 0x999999FF);

			format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы подбросили игрока %s[%d]. Причина: %s ", GetPlayerNameEx(to_player), to_player, reason);
			SendClientMessage(playerid, -1, fmt_msg);

			format(fmt_text, sizeof fmt_text, "{1E90FF}Администратор %s[%d] подбросил Вас. Причина: %s ", GetPlayerNameEx(playerid), playerid, reason);
			SendClientMessage(to_player, -1, fmt_text);
		}
		default: return SendClientMessage(playerid, 0xFF6600FF, "Ошибка: Неверно введен код");
	}

	return 1;
}

CMD:sethp(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	extract params -> new to_player, health; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /sethp [id игрока] [количество здоровья]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationSander(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");

	else if(GetPlayerAdminEx(playerid) == 1 && to_player != playerid)
		return SendClientMessage(playerid, 0x999999FF, "Администраторам 1-го уровня доступно изменение только своего уровня здоровья");

	else if(!(0 <= health <= 100)) return SendClientMessage(playerid, 0x999999FF, ""SC"Уровень здоровья от 0 до 100");

	SetPlayerData(to_player, P_HEALTH, health);
	SetPlayerHealthEx(to_player, health);

	if(GetPlayerData(to_player, P_HOSPITAL))
		SetPlayerData(to_player, P_HOSPITAL, false);

	new fmt_msg[999];
	format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] изменил уровень здоровья %s[%d] на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, health);
	SendMessageToAdmins(fmt_msg, 0x999999FF);

	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы изменили %s[%d] уровень здоровья", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, -1, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Администратор %s[%d] изменил Вам уровень здоровья", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, -1, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Установил %s[acc:%d] уровень здоровья на %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), health);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

CMD:hp(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	extract params -> new to_player, health; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /sethp [id игрока] [количество здоровья]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationSander(playerid, 2, 4, 0, 0, "Такого игрока нет", " ");

	else if(GetPlayerAdminEx(playerid) == 1 && to_player != playerid)
		return SendClientMessage(playerid, 0x999999FF, "Администраторам 1-го уровня доступно изменение только своего уровня здоровья");

	else if(!(0 <= health <= 100)) return SendClientMessage(playerid, 0x999999FF, ""SC"Уровень здоровья от 0 до 100");

	SetPlayerData(to_player, P_HEALTH, health);
	SetPlayerHealthEx(to_player, health);

	if(GetPlayerData(to_player, P_HOSPITAL))
		SetPlayerData(to_player, P_HOSPITAL, false);

	new fmt_msg[999];
	format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] изменил уровень здоровья %s[%d] на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, health);
	SendMessageToAdmins(fmt_msg, 0x999999FF);

	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Вы изменили %s[%d] уровень здоровья", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, -1, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "{1E90FF}Администратор %s[%d] изменил Вам уровень здоровья", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, -1, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Установил %s[acc:%d] уровень здоровья на %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), health);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

CMD:spcars(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 3) return 1;
    if(g_SpawnCarsPending) return SendClientMessage(playerid, 0xFF4444FF, "[Ошибка] Уже запущен таймер на выгрузку машин.");

    g_SpawnCarsPending = true;

    SendClientMessageToAll(0xFFA500FF, "[Внимание] Через 30 секунд будет выгружен весь незанятый транспорт. Займите свои машины!");

    new msg[90];
    format(msg, sizeof msg, "[A] Администратор %s[%d] запустил таймер на выгрузку машин", GetPlayerNameEx(playerid), playerid);
    SendMessageToAdmins(msg, 0x999999FF);

    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, "Запустил таймер на выгрузку незанятого транспорта");

    SetTimer("ExecuteSpawnCars", 30000, false);

    return 1;
}

CMD:givegun(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3) return 1;
	if(TEST_SERVER == 1) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Данная команда не доступна на ТЕСТ СЕРВЕРЕ!");

	extract params -> new to_player, weapon_id, weapon_ammo; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givegun [id игрока] [id оружия] [кол-во патронов]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!(1 <= weapon_id <= 46) || (19 <= weapon_id <= 21)) return SendClientMessage(playerid, 0x999999FF, "ID оружия от 1 до 46");
	if(!(1 <= weapon_ammo <= 1000)) return SendClientMessage(playerid, 0x999999FF, "Количество патронов от 1 до 1000");

	GivePlayerWeapon(to_player, weapon_id, weapon_ammo);

	new fmt_text[128];

	format(fmt_text, sizeof fmt_text, "Администратор %s[%d] выдал Вам %s и %d патр.", GetPlayerNameEx(playerid), playerid, GetWeaponName(weapon_id), weapon_ammo);
	SendClientMessage(to_player, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "Вы выдали игроку %s[%d] %s и %d патр.", GetPlayerNameEx(to_player), to_player, GetWeaponName(weapon_id), weapon_ammo);
	SendClientMessage(playerid, -1, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] выдал %s[%d] %s [%d патр]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, GetWeaponName(weapon_id), weapon_ammo);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	format(fmt_text, sizeof fmt_text, "Выдал %s[acc:%d] %s[%d патр]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), GetWeaponName(weapon_id), weapon_ammo);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:templeader(playerid)
{
    if(GetPlayerAdminEx(playerid) < 6)
        return SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}| {FFFFFF}Доступно только администраторам 3-его уровня.");

    new sander_title[128];
    format(sander_title, sizeof sander_title, "{FF5252}%s{ffffff} | Меню временного лидерства", NameServer[SANDER_NAME]);

    Dialog
    (
        playerid, 19470, DIALOG_STYLE_LIST,
        sander_title,
        "{F0E68C}| Правительство {008000}Выдать\n\
        {4169E1}| ФСБ {008000}Выдать\n\
        {4169E1}| Отдел полиции №1 (УМВД) {008000}Выдать\n\
        {4169E1}| Отдел полиции №2 (ГИБДД) {008000}Выдать\n\
        {8B4513}| Армия {008000}Выдать\n\
        {FA8072}| Больница {008000}Выдать\n\
        {FF4500}| СМИ {008000}Выдать\n\
        {32CD32}| Арзамасская ОПГ {008000}Выдать\n\
        {7B68EE}| Батыревская ОПГ {008000}Выдать\n\
        {FF5252}| Лыткаринская ОПГ {008000}Выдать\n\
        {FF5252}| ФCИН {008000}Выдать\n\
        {FFFFFF}| Снять с поста",
        "Выбрать",
        "Выход"
    );
    return 1;
}

CMD:agivelic(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new to_player, license; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /agivelic [id игрока] [тип] (1-Базовый уровень 2-Профессиональный уровень 3-На оружие)");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	new fmt_text[144];

	switch(license)
	{
		case 1:
		{
			SetPlayerData(to_player, P_DRIVING_LIC, GetPlayerData(to_player, P_DRIVING_LIC) ^ 1);
			UpdatePlayerDatabaseInt(to_player, "driving_lic", GetPlayerData(to_player, P_DRIVING_LIC));

			format(fmt_text, sizeof fmt_text, "Администратор %s[%d] %s лицензию на вождение Базового уровня", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_DRIVING_LIC) ? "выдал Вам" : "забрал у Вас");
			SendClientMessage(to_player, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "Вы %s %s[%d] лицензию на вождение Базового уровня", GetPlayerData(to_player, P_DRIVING_LIC) ? "выдали" : "забрали у", GetPlayerNameEx(to_player), to_player);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);

			format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] %s %s[%d] лицензию на вождение Базового уровня", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_DRIVING_LIC) ? "выдал" : "забрал у", GetPlayerNameEx(to_player), to_player);
			SendMessageToAdmins(fmt_text, 0x999999FF);
		}
		case 2:
		{
			SetPlayerData(to_player, P_DRIVING_LIC, GetPlayerData(to_player, P_DRIVING_LIC) == 2 ? 0 : 2);
			UpdatePlayerDatabaseInt(to_player, "driving_lic", GetPlayerData(to_player, P_DRIVING_LIC));

			format(fmt_text, sizeof fmt_text, "Администратор %s[%d] %s лицензию на вождение Профессионального уровня", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_DRIVING_LIC) == 2 ? "выдал Вам" : "забрал у Вас");
			SendClientMessage(to_player, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "Вы %s %s[%d] лицензию на вождение Профессионального уровня", GetPlayerData(to_player, P_DRIVING_LIC) == 2 ? "выдали" : "забрали у", GetPlayerNameEx(to_player), to_player);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);

			format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] %s %s[%d] лицензию на вождение Профессионального уровня", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_DRIVING_LIC) == 2 ? "выдал" : "забрал у", GetPlayerNameEx(to_player), to_player);
			SendMessageToAdmins(fmt_text, 0x999999FF);
		}
		case 3:
		{
			SetPlayerData(to_player, P_WEAPON_LIC, GetPlayerData(to_player, P_WEAPON_LIC) ^ 1);
			UpdatePlayerDatabaseInt(to_player, "weapon_lic", GetPlayerData(to_player, P_WEAPON_LIC));

			format(fmt_text, sizeof fmt_text, "Администратор %s[%d] %s лицензию на оружие", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_WEAPON_LIC) ? "выдал Вам" : "забрал у Вас");
			SendClientMessage(to_player, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "Вы %s %s[%d] лицензию на оружие", GetPlayerData(to_player, P_WEAPON_LIC) ? "выдали" : "забрали у", GetPlayerNameEx(to_player), to_player);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);

			format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] %s %s[%d] лицензию на оружие", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_WEAPON_LIC) ? "выдал" : "забрал у", GetPlayerNameEx(to_player), to_player);
			SendMessageToAdmins(fmt_text, 0x999999FF);
		}
		default: return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /agivelic [id игрока] [тип] (1-Базовый уровень 2-Профессиональный уровень 3-На оружие)");
	}

	format(fmt_text, sizeof fmt_text, "Выдал %s[acc:%d] лицензию %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), license);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:setskills(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new to_player, set_code, set_value; else {

	    SendClientMessage(playerid, 0xCECECEFF, "Использование: /setskills [id игрока] [навык] [значение]");
	    SendClientMessage(playerid, 0xCECECEFF, "Коды навыков:");
		SendClientMessage(playerid, 0xCECECEFF, "1 - Colt 45");
	    SendClientMessage(playerid, 0xCECECEFF, "2 - SD Pistol");
	    SendClientMessage(playerid, 0xCECECEFF, "3 - Desert Eagle");
	    SendClientMessage(playerid, 0xCECECEFF, "4 - Shotgun");
	    SendClientMessage(playerid, 0xCECECEFF, "5 - MP5");
	    SendClientMessage(playerid, 0xCECECEFF, "6 - AK47");
	    SendClientMessage(playerid, 0xCECECEFF, "7 - M4");
	    SendClientMessage(playerid, 0xCECECEFF, "8 - Sniper Rifle");
		SendClientMessage(playerid, 0xCECECEFF, "9 - Sawnoff");
		SendClientMessage(playerid, 0xCECECEFF, "10 - Combat SG");
		SendClientMessage(playerid, 0xCECECEFF, "11 - Micro Uzi");
	    SendClientMessage(playerid, 0x999999FF, "12 - Сила");
	    return 1;
	}

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!(0 <= set_value <= 100)) return SendClientMessage(playerid, 0x999999FF, "Значение навыка от 0 до 100");

	new tmp_skill_name[32], query[128];

	switch(set_code)
	{
		case 1:
	    {
	        SetPlayerData(to_player, P_SKILL_COLT, set_value);
			tmp_skill_name = "Colt 45";
			UpdatePlayerDatabaseInt(to_player, "skill_colt", set_value);
	    }
	    case 2:
	    {
	        SetPlayerData(to_player, P_SKILL_SDPISTOL, set_value);
			tmp_skill_name = "SD Pistol";
			UpdatePlayerDatabaseInt(to_player, "skill_sdpistol", set_value);
	    }
	    case 3:
	    {
	        SetPlayerData(to_player, P_SKILL_DEAGLE, set_value);
			tmp_skill_name = "Desert Eagle";
			UpdatePlayerDatabaseInt(to_player, "skill_deagle", set_value);
	    }
	    case 4:
	    {
	        SetPlayerData(to_player, P_SKILL_SHOTGUN, set_value);
			tmp_skill_name = "Shotgun";
			UpdatePlayerDatabaseInt(to_player, "skill_shotgun", set_value);
	    }
	    case 5:
	    {
	        SetPlayerData(to_player, P_SKILL_MP5, set_value);
			tmp_skill_name = "MP5";
			UpdatePlayerDatabaseInt(to_player, "skill_mp5", set_value);
	    }
	    case 6:
	    {
	        SetPlayerData(to_player, P_SKILL_AK47, set_value);
			tmp_skill_name = "AK47";
			UpdatePlayerDatabaseInt(to_player, "skill_ak47", set_value);
	    }
	    case 7:
	    {
	        SetPlayerData(to_player, P_SKILL_M4, set_value);
			tmp_skill_name = "M4";
			UpdatePlayerDatabaseInt(to_player, "skill_m4", set_value);
	    }
	    case 8:
	    {
	        SetPlayerData(to_player, P_SKILL_SNIPER_RIFLE, set_value);
			tmp_skill_name = "Sniper Rifle";
			UpdatePlayerDatabaseInt(to_player, "skill_sniper_rifle", set_value);
	    }
		case 9:
	    {
	        SetPlayerData(to_player, P_SKILL_SAWNOFF, set_value);
			tmp_skill_name = "Sawnoff";
			UpdatePlayerDatabaseInt(to_player, "skill_sawnoff", set_value);
	    }
		case 10:
	    {
	        SetPlayerData(to_player, P_SKILL_COMBAT_SG, set_value);
			tmp_skill_name = "Combat SG";
			UpdatePlayerDatabaseInt(to_player, "skill_combat_sg", set_value);
	    }
		case 11:
	    {
	        SetPlayerData(to_player, P_SKILL_MICRO_UZI, set_value);
			tmp_skill_name = "Micro Uzi";
			UpdatePlayerDatabaseInt(to_player, "skill_micro_uzi", set_value);
	    }
	    case 12:
	    {
	        SetPlayerData(to_player, P_POWER, set_value);
			tmp_skill_name = "Сила";
			UpdatePlayerDatabaseInt(to_player, "power", set_value);
	    }
	    default: return SendClientMessage(playerid, 0x999999FF, "Неверно введен код навыка");
	}

	SetPlayerSkillsInit(to_player);

	format(query, sizeof query, "Администратор %s изменил Вам уровень навыка %s на %d", GetPlayerNameEx(playerid), tmp_skill_name, set_value);
	SendClientMessage(to_player, 0x3399FFFF, query);

	format(query, sizeof query, "Вы изменили игроку %s уровень навыка %s на %d", GetPlayerNameEx(to_player), tmp_skill_name, set_value);
	SendClientMessage(playerid, 0x66CC00FF, query);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(query, sizeof query, "[A] Администратор %s[%d] изменил %s[%d] уровень навыка %s на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, tmp_skill_name, set_value);
		SendMessageToAdmins(query, 0x999999FF);
	}

	format(query, sizeof query, "Изменил %s[acc:%d] уровень навыка %s на %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), tmp_skill_name, set_value);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, query);

	return 1;
}

CMD:tdd(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /td [id игрока] [уровень администратора]");
	return 1;
}

CMD:setadm(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 13) return 1;

	extract params -> new to_player, admin_lvl; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setadm [id игрока] [уровень администратора]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	else if(!(0 <= admin_lvl <= 6)) return SendClientMessage(playerid, 0x999999FF, "Уровень администратора от 0 до 6");
	else if(to_player == playerid) return SendClientMessage(playerid, 0x999999FF, "Вы не можете изменять свой уровень администратора");
	else if(admin_lvl > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы не можете устанавливать уровень больше своего");

	new fmt_msg[144];

	if(GetPlayerAccountID(to_player) == 3)
	{
		format(fmt_msg, sizeof fmt_msg, "Царь, глупый мальчишка %s[%d] попытался изменить твой уровень администратора");
		SendClientMessage(to_player, 0xFF5533FF, fmt_msg);

		return SendClientMessage(playerid, 0xFF5533FF, "ТЫ ОХУЕЛ, СУКА, КОМАРА НЕ ТРОЖЬ!");
	}

	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы не можете изменять уровень администратора выше Вас рангом");

	SetPlayerData(to_player, P_ADMIN, admin_lvl);
	UpdatePlayerDatabaseInt(to_player, "admin", admin_lvl);

	AdminAuthorization(to_player);

	format(fmt_msg, sizeof fmt_msg, "%s[%d] Назначил вас администратором (%d уровня)", GetPlayerNameEx(playerid), admin_lvl);
	SendClientMessage(to_player, 0x3399FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы выдали %s права администратора %d уровня", GetPlayerNameEx(to_player), admin_lvl);
	SendClientMessage(playerid, 0x3399FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] установил %s[%d] уровень администратора %d",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, admin_lvl);

	SendMessageToAdmins(fmt_msg, 0xFF5533FF, 4);

	format(fmt_msg, sizeof fmt_msg, "Установил %s[acc:%d] уровень администратора %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), admin_lvl);
	SendLog(playerid, LOG_TYPE_SET_ADMIN, fmt_msg);

	return 1;
}

CMD:deladmin(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 9) return 1;

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /deladmin [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!GetPlayerAdminEx(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Игрок не администратор");

	if(GetPlayerAdminEx(to_player) >= GetPlayerAdminEx(playerid))
		return SendClientMessage(playerid, 0x999999FF, "Нельзя снять главного администратора");

	SetPlayerData(to_player, P_ADMIN, 0);
	UpdatePlayerDatabaseInt(to_player, "admin", 0);

	new fmt_text[128];

	format(fmt_text, sizeof fmt_text, "Администратор %s[%d] снял Вас с поста администратора", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, 0xFF5533FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] снял %s[%d] с поста администратора",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

	SendMessageToAdmins(fmt_text, 0xFF5533FF);

	format(fmt_text, sizeof fmt_text, "Снял %s[acc:%d] с поста администратора", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_text);

	return 1;
}

CMD:setadmin(playerid, params[])
{
    new P_TARGET_PLAYER_ID;
    if(GetPlayerAdminEx(playerid) < 9)
        return SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}| {FFFFFF}Доступно только администраторам 13-его уровня.");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "{FF5252}| {ffffff}Используйте: {FF5252}/setadmin {ffffff}[id игрока]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
        return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

    g_player[playerid][P_TARGET_PLAYER_ID] = to_player;

    new sander_title[128];
    format(sander_title, sizeof sander_title, "{FF5252}%s{ffffff} | Постановление на администратора", NameServer[SANDER_NAME]);

    Dialog
    (
        playerid, DIALOG_SETADMINS, DIALOG_STYLE_LIST,
        sander_title,
        "{FF5252}1.{FFFFFF}Младший модератор\n\
        {FF5252}2.{FFFFFF}Модератор\n\
        {FF5252}3.{FFFFFF}Старший модератор\n\
        {FF5252}4.{FFFFFF}Администратор\n\
        {FF5252}5.{FFFFFF}Старший администратор\n\
        {FF5252}6.{FFFFFF}ГС/ЗГС\n\
        {FF5252}7.{FFFFFF}Куратор администрации\n\
        {FF5252}8.{FFFFFF}Технический специалист\n\
        {FF5252}9.{FFFFFF}Зам. главного администратора\n\
        {FF5252}10.{FFFFFF}Главный администратор\n\
        {FF5252}11.{FFFFFF}Команда проекта\n\
        {FF5252}12.{FFFFFF}Заместитель основателя\n\
        {FF5252}13.{FFFFFF}Основатель",
        "Выбрать",
        "Закрыть"
    );

    return 1;
}

CMD:sendcmd(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	extract params -> new to_player, string:c_command[20], string:c_params[128]; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sendcmd [id игрока] [команда] [параметры]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	new fmt_text[144];

	if(strfind(c_command, "w        	") != -1
	|| strfind(c_command, "ban") != -1
	|| strfind(c_command, "offban") != -1
	|| strfind(c_command, "warn") != -1)
	{

		SendMessageToAdmins(fmt_text, 0x999999FF, 5);

		return 1;
	}

	format(fmt_text, sizeof fmt_text, "cmd_%s", c_command);

	CallLocalFunction(fmt_text, "is", to_player, c_params);

	format(fmt_text, sizeof fmt_text, "Отправил от имени %s[acc:%d] кмд: /%s %s", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), c_command, c_params);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_text);

	return 1;
}

CMD:td(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 12) return 1;

	extract params -> new to_player, cash; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givecash [id игрока] [cумма]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	if(!(1 <= cash <= 1_000_000)) return SendClientMessage(playerid, 0xCECECEFF, "Можно выдавать от 1 до 1000000 рублей за один раз");

	new reason[144];
	format(reason, sizeof reason, "Выдача денег от админа %s", GetPlayerNameEx(playerid));
	GivePlayerMoneyEx(to_player, cash, reason, true, true);

	format(reason, sizeof reason, "Администратор %s выдал Вам %d рублей", GetPlayerNameEx(playerid), cash);
	SendClientMessage(to_player, 0xFFFFFFFF, reason);

	format(reason, sizeof reason, "[A] %s[%d] выдал деньги %s[%d] кол-во %d руб, в итоге у игрока %d руб", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, cash, GetPlayerMoneyEx(to_player));
	SendMessageToAdmins(reason, 0xFF5252FF);

	format(reason, sizeof reason, "Выдал %s[acc:%d] %d руб", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), cash);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, reason);

	return 1;
}

CMD:givecash(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11) return 1;

    new to_player, cash;
    if(sscanf(params, "ii", to_player, cash))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givecash [id игрока] [cумма]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

    if(!(-500_000_000 <= cash <= 500_000_000))
        return SendClientMessage(playerid, 0xCECECEFF, "Можно выдавать до 500.000.000 рублей за один раз");

    new reason[144];
    format(reason, sizeof reason, "Выдача денег от админа %s", GetPlayerNameEx(playerid));
    GivePlayerMoneyEx(to_player, cash, reason, true, true);

    new msg[64];
    format(msg, sizeof(msg), "Вы получили %d рублей", cash);
    ShowNotificationSander(to_player, 3, 5, 0, 0, msg, " ");

    format(reason, sizeof reason, "Администратор %s выдал Вам %d рублей", GetPlayerNameEx(playerid), cash);
    SendClientMessage(to_player, 0xFFFFFFFF, reason);

    format(reason, sizeof reason, "[A] %s[%d] выдал деньги %s[%d] кол-во %d руб, в итоге у игрока %d руб", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, cash, GetPlayerMoneyEx(to_player));
    SendMessageToAdmins(reason, 0x999999FF);

    format(reason, sizeof reason, "Выдал %s[acc:%d] %d руб", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), cash);
    SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, reason);

    return 1;
}

CMD:giverub(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11) return 1;

    new to_player, donate;
    if(sscanf(params, "ii", to_player, donate))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givedonate [id игрока] [cумма]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

    if(!(-1 <= donate <= 10000))
        return SendClientMessage(playerid, 0xCECECEFF, "Можно выдавать от 1 до 10000 доната за один раз");

    new reason[144];
    format(reason, sizeof reason, "Выдача доната от админа %s", GetPlayerNameEx(playerid));
    GivePlayerDonate(to_player, donate, reason, true);

    new msg[64];
    format(msg, sizeof(msg), "Вы получили %d доната", donate);
    ShowNotificationSander(to_player, 3, 5, 0, 0, msg, " ");

    format(reason, sizeof reason, "Администратор %s выдал Вам %d доната", GetPlayerNameEx(playerid), donate);
    SendClientMessage(to_player, 0xFFFFFFFF, reason);

    format(reason, sizeof reason, "[A] %s[%d] выдал донат %s[%d] кол-во %d руб, в итоге у игрока %d руб",
        GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, donate, GetPlayerDonateMoney(to_player));
    SendMessageToAdmins(reason, 0x999999FF);

    format(reason, sizeof reason, "Выдал %s[acc:%d] %d руб доната", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), donate);
    SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, reason);

    return 1;
}

CMD:givedonate(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11) return 1;

    new to_player, donate;
    if(sscanf(params, "ii", to_player, donate))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /giverub [id игрока] [cумма]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

    if(!(-1 <= donate <= 10_000))
        return SendClientMessage(playerid, 0xCECECEFF, "Можно выдавать от 1 до 10000 доната за один раз");

    new reason[144];
    format(reason, sizeof reason, "Выдача доната от админа %s", GetPlayerNameEx(playerid));
    GivePlayerDonateRub(to_player, donate, reason, true, true);

    format(reason, sizeof reason, "Администратор %s выдал Вам %d доната", GetPlayerNameEx(playerid), donate);
    SendClientMessage(to_player, 0xFFFFFFFF, reason);

    format(reason, sizeof reason, "[A] %s[%d] выдал донат-рубли %s[%d] в кол-во %d руб, в итоге у игрока %d руб",
        GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, donate, GetPlayerDonateRub(to_player));
    SendMessageToAdmins(reason, 0x999999FF);

    format(reason, sizeof reason, "Выдал %s[acc:%d] %d рублей", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), donate);
    SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, reason);

    return 1;
}

CMD:doubling(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	Dialog
	(
		playerid, DIALOG_SET_DOUBLING, DIALOG_STYLE_LIST,
		"{FFCC00}Удвоение",
		"\
		1. Удвоение доната\n\
		2. Удвоение очков опыта\n\
		3. Удвоение зарплаты на подработках\
		",
		"Выбор", "Отмена"
	);

	return 1;
}

CMD:setstats(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 12) return 1;

	extract params -> new to_player, set_code, set_value; else {

		SendClientMessage(playerid, 0xCECECEFF, "Использование: /setstats [id игрока] [код] [значение]");
		SendClientMessage(playerid, 0xCECECEFF, "Код: 1 - Уровень | 2 - Работа");

		return 1;
	}

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	new fmt_msg[128];

	switch(set_code)
	{
		case 1:
		{
			if(!(1 <= set_value <= 25)) return SendClientMessage(playerid, 0xFF6600FF, "Уровень от 1 до 25");

			SetPlayerData(to_player, P_LEVEL, set_value);

			SetPlayerScore(to_player, set_value);

			format(fmt_msg, sizeof fmt_msg, "Администратор %s изменил Вам уровень на %d", GetPlayerNameEx(playerid), set_value);
			SendClientMessage(to_player, 0x3399FFFF, fmt_msg);

			format(fmt_msg, sizeof fmt_msg, "Вы изменили игроку %s уровень на %d", GetPlayerNameEx(to_player), set_value);
			SendClientMessage(playerid, 0x3399FFFF, fmt_msg);
		}
		case 2:
		{

			SetPlayerData(to_player, P_JOB, set_value);

			format(fmt_msg, sizeof fmt_msg, "Администратор %s установил Вам работу %s", GetPlayerNameEx(playerid), GetPlayerJobAndRankName(to_player));
			SendClientMessage(to_player, 0x3399FFFF, fmt_msg);

			format(fmt_msg, sizeof fmt_msg, "Вы установили игроку %s работу %s", GetPlayerNameEx(to_player), GetPlayerJobAndRankName(to_player));
			SendClientMessage(playerid, 0x66CC00FF, fmt_msg);
		}
		default: return SendClientMessage(playerid, 0xFF6600FF, "Ошибка: Неверно введен код");
	}

	mysql_format(mysql, fmt_msg, sizeof fmt_msg, "UPDATE accounts SET level=%d,job=%d WHERE id=%d", GetPlayerLevel(to_player), GetPlayerJob(to_player), GetPlayerAccountID(to_player));
	mysql_query(mysql, fmt_msg, false);

	return 1;
}

CMD:agm(playerid)
{
    if(GetPlayerAdminEx(playerid) < 1)
        return SendClientMessage(playerid, -1, "Ошибка: Недостаточно прав");

    agmtestActive[playerid] = !agmtestActive[playerid];

    if(agmtestActive[playerid])
    {
        SendClientMessage(playerid, -1, ""SC"Вы успешно {FF5252}включили {FFFFFF}административное бессмертие");
        SetPlayerHealth(playerid, 1000);
        SetTimerEx("AGMTestTimer", 10, true, "i", playerid);
    }
    else
    {
        SendClientMessage(playerid, -1, ""SC"Вы успешно {FF5252}выключили {FFFFFF}административное бессмертие");
    }

    return 1;
}

forward AGMTestTimer(playerid);
public AGMTestTimer(playerid)
{
    if(!IsPlayerConnected(playerid) || !agmtestActive[playerid])
        return 0;

    new Float:health;
    GetPlayerHealth(playerid, health);

    if(health < 90.0)
    {
        SetPlayerHealth(playerid, 1000);
    }

    return 1;
}

CMD:az(playerid)
{
    if(GetPlayerAdminEx(playerid) < 1)
    return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

    return TeleportToAdminZone(playerid);
}
CMD:debug(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;
	new string[32];
	format(string, sizeof(string), "Your virtual world: %i, %i", GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid));
	SendClientMessage(playerid, 0xFFFFFFFF, string);
	return 1;
}

CMD:givecase(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

	extract params -> new to_player, give; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /givecase [id игрока] [кол-во]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(give <= 0) return SendClientMessage(playerid, 0x999999FF, "Неверное количество");

	new fmt_text[80];

	AddPlayerData(to_player, P_DONATE_CASE, +, give);
	UpdatePlayerDatabaseInt(to_player, "case", GetPlayerData(to_player, P_DONATE_CASE));

	format(fmt_text, sizeof fmt_text, "~b~+%d case", give);
	GameTextForPlayer(to_player, fmt_text, 4000, 1);

	format(fmt_text, sizeof fmt_text, "Вы передали донат кейсы игроку %s в количестве %d", GetPlayerNameEx(to_player), give);
	SendClientMessage(playerid, 0x3399FFFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "Администратор %s передал Вам донат-кейсы в количестве %d", GetPlayerNameEx(playerid), give);
	SendClientMessage(to_player, 0x3399FFFF, fmt_text);

	return 1;
}

CMD:givecoins(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new to_player, give; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /givecoins [id игрока] [кол-во]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(give <= 0) return SendClientMessage(playerid, 0x999999FF, "Неверное количество");

	new fmt_text[80];

	AddPlayerData(to_player, P_COINS, +, give);
	UpdatePlayerDatabaseInt(to_player, "case", GetPlayerData(to_player, P_COINS));

	format(fmt_text, sizeof fmt_text, "~b~+%d coins", give);
	GameTextForPlayer(to_player, fmt_text, 4000, 1);

	format(fmt_text, sizeof fmt_text, "Вы передали монеты игроку %s в количестве %d", GetPlayerNameEx(to_player), give);
	SendClientMessage(playerid, 0x3399FFFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "Администратор %s передал Вам монеты в количестве %d", GetPlayerNameEx(playerid), give);
	SendClientMessage(to_player, 0x3399FFFF, fmt_text);

	return 1;
}

CMD:apanel(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13)
		return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команды", " ");

	new sander_title[128];
	format(sander_title, sizeof sander_title, "{FF5252}%s{FFFFFF} -> Управление сервером.", NameServer[SANDER_NAME]);

	Dialog
	(
		playerid, DIALOG_ADMIN_PANEL, DIALOG_STYLE_LIST,
		sander_title,
		"\
		{888888}| {FFFFFF} Список администраторов\n\
		{888888}| {FFFFFF} Список лидеров\n\
		{888888}| {FFFFFF} Технический рестарт\t\t\t{FF5252}[1 мин]\n\
		{888888}| {FFFFFF} Whitelist\n\
		{888888}| {FFFFFF} Пополнить бизнесы товаром\t\t{FF5252}[ФУЛЛ]\n\
		{888888}| {FFFFFF} Фулим склад завода(timer)\t\t{FF5252}[Крайний случай]\n\
		{888888}| {FFFFFF}Фулим Заправки\t\t\t{FF5252}[Топливом]",
		"Выбор", "Отмена"
	);

	return 1;
}

CMD:sethelper(playerid, params[])
{

    if(GetPlayerAdminEx(playerid) < 5) return 1;

    extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sethelper [id игрока]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

    if(GetPlayerHelperEx(to_player))
        return SendClientMessage(playerid, 0x999999FF, "Игрок уже стоит на посту хелпера");

    SetPlayerData(to_player, P_HELPER, 1);
    UpdatePlayerDatabaseInt(to_player, "helper", 1);

    new fmt_text[128];

    format(fmt_text, sizeof fmt_text, "{1E90FF}Вы были назначены на пост хелпера 1-го уровня администратором %s[%d] ", GetPlayerNameEx(playerid), playerid);
    SendClientMessage(to_player, 0x999999FF, fmt_text);

    format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] поставил %s[%d] на пост хелпера",
    GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

    SendMessageToAdmins(fmt_text, 0x999999FF);

    format(fmt_text, sizeof fmt_text, "Поставил %s[acc:%d] на пост хелпера", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
    SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_text);

    return 1;
}

CMD:delhelper(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 5) return 1;

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /delhelper [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!GetPlayerHelperEx(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Игрок не хелпер");

	SetPlayerData(to_player, P_HELPER, 0);
	UpdatePlayerDatabaseInt(to_player, "helper", 0);

	new fmt_text[128];

	format(fmt_text, sizeof fmt_text, "Главный администратор %s[%d] снял Вас с поста хелпера", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, 0xFF5533FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] снял %s[%d] с поста хелпера",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

	SendMessageToAdmins(fmt_text, 0xFF5533FF);

	format(fmt_text, sizeof fmt_text, "Снял %s[acc:%d] с поста хелпера", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_text);

	return 1;
}

CMD:offdeladmin(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 9) return 1;

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /offdeladmin [ник игрока]");

	extract params -> new string: player_name[21];

	if(IsPlayerConnected(GetPlayerID(player_name))) return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем находится на сервере");

	new query[144],
		Cache: result,
		rows,
		uid,

		uip[16];

	mysql_format(mysql, query, sizeof query, "SELECT id, admin, last_ip FROM accounts WHERE name='%s'", player_name);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		uid = cache_get_row_int(0, 0);

		cache_get_row(0, 2, uip);
	}

	cache_delete(result);

	if(!rows || !uid) return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

	cache_delete(result);

	format(query, sizeof query, "Администратор %s снял %s с поста администратора[Офлайн]", GetPlayerNameEx(playerid), player_name);

	SendMessageToAdmins(query, 0xFF5533FF);

	new id = GetPlayerID(player_name);
	if (id != INVALID_PLAYER_ID) {
		SetPlayerData(id, P_ADMIN, 0);
		UpdatePlayerDatabaseInt(id, "admin", 0);
	}
	mysql_format(mysql, query, sizeof query, "UPDATE `accounts` SER `admin`=0 WHERE `id`=%i LIMIT 1", uid);
	mysql_query(mysql, query, false);
	return 1;
}

CMD:offdelhelper(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 5) return 1;

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /offdelhelper [ник игрока]");

	extract params -> new string: player_name[21];

	if(IsPlayerConnected(GetPlayerID(player_name))) return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем находится на сервере");

	new query[144],
		Cache: result,
		rows,
		uid,

		uip[16];

	mysql_format(mysql, query, sizeof query, "SELECT id, admin, last_ip FROM accounts WHERE name='%s'", player_name);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		uid = cache_get_row_int(0, 0);

		cache_get_row(0, 2, uip);
	}

	cache_delete(result);

	if(!rows || !uid) return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

	cache_delete(result);

	format(query, sizeof query, "Администратор %s снял %s с поста хелпера[Офлайн]", GetPlayerNameEx(playerid), player_name);

	SendMessageToAdmins(query, 0xFF5533FF);

	new id = GetPlayerID(player_name);
	if (id != INVALID_PLAYER_ID) {
		SetPlayerData(id, P_HELPER, 0);
		UpdatePlayerDatabaseInt(id, "helper", 0);
	}
	mysql_format(mysql, query, sizeof query, "UPDATE `accounts` SER `helper`=0 WHERE `id`=%i LIMIT 1", uid);
	mysql_query(mysql, query, false);
	return 1;
}

CMD:delvehall(playerid)
{
    if(GetPlayerAdminEx(playerid) < 13) return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

    new total_car = 0;
    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_ADMIN_CAR)
        {
            DestroyVehicle(i);
            total_car ++;
        }

    }

    format(sctring, sizeof(sctring), ""SC"Вы удалили {00ff00}%i {FFFFFF}автомобилей созданных на сервере!", total_car);
    SendClientMessage(playerid, -1, sctring);
    format(sctring, sizeof(sctring), "[A] %s[%d] удалил весь созданный транспорт на сервере. (%i шт)",GetPlayerNameEx(playerid), playerid, total_car);
    SendMessageToAdmins(sctring, 0x999999FF);
    return 1;
}

CMD:setlic(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 1) return 1;

	SetPlayerData(playerid, P_DRIVING_LIC, 2);

	SetPlayerData(playerid, P_WEAPON_LIC, 1);

	return 1;
}

CMD:creategift(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 5) return 1;

	new query[196],
		Cache: result,
		Float: X,
		Float: Y,
		Float: Z,
		idx = g_gift_loaded;

	GetPlayerPos(playerid, X, Y, Z);

	mysql_format(mysql, query, sizeof query, "INSERT INTO gift (x, y, z) VALUES (%f, %f, %f)", X, Y, Z);
	result = mysql_query(mysql, query, true);

	SetGiftData(idx, G_SQL_ID, 		cache_insert_id());

	SetGiftData(idx, G_POS_X,		X);
	SetGiftData(idx, G_POS_Y,		Y);
	SetGiftData(idx, G_POS_Z,		Z);

	CreatePickup
	(
		1279,
		23,
		X, Y, Z,
		-1,
		PICKUP_ACTION_TYPE_GIFT,
		idx
	);

	g_gift_loaded++;

	cache_delete(result);

	SendClientMessage(playerid, 0x32a44bFF, "Вы создали подарок!");

	return 1;
}

CMD:setpremium(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new to_player, premium; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setpremium [id игрока] [время (в днях)]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	if(!(0 <= premium <= 30)) return SendClientMessage(playerid, 0xCECECEFF, "Количество дней от 0 до 30");

	new fmt_msg[100];

	SetPlayerData(to_player, P_PREMIUM_DATE, gettime() + premium * 86400);

	UpdatePlayerDatabaseInt(to_player, "premium", GetPlayerData(to_player, P_PREMIUM));

	format(fmt_msg, sizeof fmt_msg, "%s выдал Вам подписку "SERVER_NAME"+ на %d дн.", GetPlayerNameEx(playerid), premium);
	SendClientMessage(to_player, 0x1E90FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы выдали %s подписку "SERVER_NAME"+ на %d дн.", GetPlayerNameEx(to_player), premium);
	SendClientMessage(playerid, 0x1E90FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Установил %s[acc:%d] подписку "SERVER_NAME"+ на %d дн.", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), premium);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

CMD:sptext(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sptext [id игрока] [текст]");

	extract params -> new to_player, string: message[144 + 1];

	if(!IsPlayerConnected(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	OnPlayerText(to_player,message);

	return true;
}

alias:setmedia("setyt")
CMD:setmedia(playerid, params[])
{
    if(!CanManageMediaStaff(playerid))
        return SendClientMessage(playerid, 0xFF5533FF, "Команда доступна только Пиар-менеджеру");

    extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setmedia [id игрока]");
    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
        return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
    if(GetPlayerAdminEx(to_player) > 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Нельзя совмещать обычную администрацию и медиа-должность");
    if(GetPlayerMediaRank(to_player) != MEDIA_RANK_NONE)
        return SendClientMessage(playerid, 0xCECECEFF, "У игрока уже есть медиа-должность");

    ResetMediaRuntime(to_player, true);
    SetPlayerData(to_player, P_YOUTUBE, MEDIA_RANK_ADMIN);
    UpdatePlayerDatabaseInt(to_player, "youtube", MEDIA_RANK_ADMIN);
    SendClientMessage(to_player, 0xFFCC33FF, "Пиар-менеджер выдал Вам права медиа-администратора");
    SendClientMessage(playerid, 0x99CC00FF, "Медиа-администратор назначен");
    return 1;
}

alias:delmedia("delyt")
CMD:delmedia(playerid, params[])
{
    if(!CanManageMediaStaff(playerid))
        return SendClientMessage(playerid, 0xFF5533FF, "Команда доступна только Пиар-менеджеру");

    extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /delmedia [id игрока]");
    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
        return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
    if(GetPlayerMediaRank(to_player) != MEDIA_RANK_ADMIN)
        return SendClientMessage(playerid, 0xCECECEFF, "У игрока нет прав медиа-администратора");

    if(GetPlayerSpectateData(to_player, S_PLAYER) != -1) StopSpectateY(to_player);
    ResetMediaRuntime(to_player, true);
    SetPlayerSkin(to_player, GetPlayerSkinEx(to_player));
    SetPlayerData(to_player, P_YOUTUBE, MEDIA_RANK_NONE);
    UpdatePlayerDatabaseInt(to_player, "youtube", MEDIA_RANK_NONE);
    SendClientMessage(to_player, 0xFF5533FF, "Пиар-менеджер снял с Вас права медиа-администратора");
    SendClientMessage(playerid, 0x99CC00FF, "Права медиа-администратора сняты");
    return 1;
}

CMD:slethouse(playerid)
{

	if(GetPlayerAdminEx(playerid) < 6) return 1;

	SellDebtorsHome();

	return 1;
}

CMD:slet(playerid)
{

	if(GetPlayerAdminEx(playerid) < 6) return 1;

	SellDebtorsHome();
    SellDebtorsFuel();
	SellDebtorsBusiness();

	return 1;
}

CMD:flip(playerid)
{
	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationSander(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", " ");

	new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid == 0)
    {
            SendClientMessage(playerid, -1, ""USC"Вы должны сидеть в транспорте");
            return 0;
    }

    new Float:x, Float:y, Float:z;
    new Float:angle;

    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, angle);

    SetVehiclePos(vehicleid, x, y, z + 1.5);
    SetVehicleZAngle(vehicleid, angle);

    SendClientMessage(playerid, -1, ""SC"Вы успешно поставили транспорт на колёса и починили его");

	RepairVehicle(vehicleid);
	SetVehicleHealth(vehicleid,1000);
	SetVehicleData(vehicleid, V_HEALTH, 1000.0);

	return 1;
}
CMD:setmoney(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	extract params -> new to_player, money; else return SendClientMessage(playerid, -1, "Используйте: /setmoney [id игрока] [количество]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	SetPlayerData(to_player, P_MONEY, money);
	UpdatePlayerDatabaseInt(to_player, "money", money);

	return 1;

}

CMD:setplayerhouse(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new to_player, health; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setplayerhouse [id игрока] [id house]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	else if(!(-1 <= health <= 1000)) return SendClientMessage(playerid, 0xCECECEFF, "Номер дома от -1 до 1000 ( -1 выселить )");

	SetPlayerData(to_player, P_HOUSE, health);
	SetPlayerData(to_player, P_HOUSE_ROOM, -1);
	SetPlayerData(to_player, P_HOUSE_TYPE, HOUSE_TYPE_HOME);
	if(health == -1)
	{
	    SetPlayerData(to_player, P_HOUSE, -1);
		SetPlayerData(to_player, P_HOUSE_ROOM, -1);
		SetPlayerData(to_player, P_HOUSE_TYPE, HOUSE_TYPE_NONE);
	}

	new fmt_msg[105];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s изменил Вам номер дома", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, -1, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы изменили игроку %s номер дома на %d", GetPlayerNameEx(to_player),health);
	SendClientMessage(playerid, -1, fmt_msg);
	new query[90];

	format(query, sizeof query, "UPDATE accounts SET house_type=%d,house=%d, WHERE id=%d LIMIT 1", HOUSE_TYPE_HOME, health, GetPlayerAccountID(playerid));
	mysql_query(mysql, query, false);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] изменил номер дому %s[%d] на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, health);
		SendMessageToAdmins(fmt_msg, 0xCECECEFF);
	}

	format(fmt_msg, sizeof fmt_msg, "Установил %s[acc:%d] номер дома %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), health);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}
CMD:setplayerbiz(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new to_player, health; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setplayerbiz [id игрока] [id biz]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	else if(!(-1 <= health <= 1000)) return SendClientMessage(playerid, 0xCECECEFF, "Номер biz от -1 до 1000 ( -1 выселить )");

	SetPlayerData(to_player, P_BUSINESS, health);

	new fmt_msg[105];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s изменил Вам номер biz", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, -1, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы изменили игроку %s номер biz", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, -1, fmt_msg);
	new query[90];
	mysql_format(mysql, query, sizeof query, "UPDATE accounts SET business=%d WHERE id=%d LIMIT 1", health, GetPlayerAccountID(playerid));
	mysql_query(mysql, query, false);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] изменил номер biz %s[%d] на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, health);
		SendMessageToAdmins(fmt_msg, 0xCECECEFF);
	}

	format(fmt_msg, sizeof fmt_msg, "Установил %s[acc:%d] номер biz %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), health);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}