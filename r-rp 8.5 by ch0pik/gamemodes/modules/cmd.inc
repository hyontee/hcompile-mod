cmd:givetokenhorror(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false) return 1;

	if(GetPlayerData(playerid, P_BUYADMIN) == 1)
		return SCM(playerid, 0x999999FF, "Покупным администраторам недоступна данная функция");

	new to_player, count;
	if(sscanf(params, "ii", to_player, count))
		return SCM(playerid, 0xCECECEFF, "* Используйте: /givehorrortoken [ид игрока] [кол-во]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SCM(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(count < 1 || count > 5000)
		return SCM(playerid, 0xCECECEFF, "* Нельзя выдавать менее 1 или более 5000 жетонов ужаса за раз!");

	AddPlayerData(to_player, P_TOKEN_HORROR, +, count);
	UpdatePlayerDatabaseInt(to_player, "token_horror", GetPlayerData(to_player, P_TOKEN_HORROR));

	static msg[144];
	format(msg, sizeof msg, "A: %s выдал Вам предмет 'Жетон ужаса' в количестве %d шт", GetPlayerNameEx(playerid), count);
	SendClientMessage(to_player, 0xFFFF00FF, msg);

	format(msg, sizeof msg, "A: %s[%d] выдал предмет 'Жетон ужаса' игроку %s[%d] в количестве %d шт", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, count);
	SendMessageToAdmins(msg, 0xFFFF00FF);

	return 1;
}
cmd:add_rchannel(playerid)
{
	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам организации и их заместителям");
	if(!GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в организации");

	Dialog(playerid, DIALOG_RCHANNEL_CREATE, DIALOG_STYLE_INPUT, "Создание канала", "Введите название канала:", "Создать", "Отмена");
	return 1;
}

cmd:r_channel(playerid)
{
	if(!GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в организации");

	static query[256];
	mysql_format(mysql, query, sizeof(query), "SELECT id, channel_name, created_at FROM rchannels WHERE organ_id = %d ORDER BY id ASC", GetPlayerTeamEx(playerid));
	mysql_tquery(mysql, query, "OnLoadRChannels", "d", playerid);
	return 1;
}
cmd:inactive(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 5) return 1;
	
	Dialog(playerid, DIALOG_INACTIVE_MAIN, DIALOG_STYLE_LIST, "Список неактивных предметов", "1. Сим-карты\n2. Автомобильные номера", "Выбрать", "Отмена");
	return 1;
}

cmd:sellinactive(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 5) return 1;
	
	Dialog(playerid, DIALOG_SELL_INACTIVE_MAIN, DIALOG_STYLE_LIST, "Продажа имущества", "1. Сим-карты\n2. Автомобильные номера", "Выбрать", "Отмена");
	return 1;
}
cmd:acceptadmin(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 7) return 1;
	else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "Вы не авторизированы, используйте /alogin");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /acceptadmin [id администратора]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");


	static fmt_msg[144];
	format(fmt_msg, sizeof fmt_msg, "{F50202}[A] ВНИМАНИЕ! Администратор %s подтвердил аккаунт администратора %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageToAdmins(fmt_msg, -1);

	static query[500];

	mysql_format(mysql, query, sizeof query, "UPDATE `PlayersMorallwens` SET `last_ip` = REPLACE(last_ip, 'last_ip', 'reg_ip') WHERE id=%d LIMIT 1", to_player);
	mysql_tquery(mysql, query);


	SendClientMessage(to_player, 0x66CC00FF, "Доступ разблокирован");

	format(fmt_msg, sizeof fmt_msg, "%s Выдал одобрение игроку %s[acc:%d]", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_SETADMIN, fmt_msg);

	return 1;
}
cmd:proslyshnumber(playerid, params[])
{
   if(GetPlayerTeamEx(playerid) != TEAM_FSB)
        return SendClientMessage(playerid, 0x999999FF, "* Команда доступна только сотрудникам ФСБ");

    Dialog(playerid, DIALOG_SMSFSB, DIALOG_STYLE_INPUT, 
        "ПРОСЛУШКА ТЕЛЕФОНА", 
        "Укажите номер телефона, который вы хотите прослушивать:",
        "Принять", "Отмена");
    return 1;
}

cmd:strob(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	
	STRING_GLOBAL[0] = EOS;

	if(stroboskopes[vehicleid] == 0)
	{
		if(GetVehicleModel(vehicleid) == 17439) format(STRING_GLOBAL, sizeof STRING_GLOBAL, "addStroboscopes(\"[[%d,0,-0.31,-0.36,0.74,150.00,200,%d,-1,45.00,%d],[%d,1,0.31,-0.36,0.74,150.00,400,%d,-1,45.00,%d]]\")", vehicleid,vehicleid, vehicleid * 2, vehicleid * 2, vehicleid, vehicleid);
		if(GetVehicleModel(vehicleid) == 17446) format(STRING_GLOBAL, sizeof STRING_GLOBAL, "addStroboscopes(\"[[%d,0,-0.31,-0.38,0.95,150.00,200,%d,-1,45.00,%d],[%d,1,0.31,-0.38,0.95,150.00,400,%d,-1,45.00,%d]]\")", vehicleid,vehicleid, vehicleid * 2, vehicleid * 2, vehicleid, vehicleid);
		
		foreach(new i : Player)
		{
			if(!IsPlayerLogged(i)) continue;

			MoralPacket_1(i, s_CefInterface, t_CefUpdate, STRING_GLOBAL);
		}
		stroboskopes[vehicleid] = 1;
		return 1;
	}
	if(stroboskopes[vehicleid] == 1)
	{
		format(STRING_GLOBAL, sizeof STRING_GLOBAL, "delStroboscopes(\"[[%d],[%d]]\")", vehicleid, vehicleid * 2);

		foreach(new i : Player)
		{
			if(!IsPlayerLogged(i)) continue;

			MoralPacket_1(i, s_CefInterface, t_CefUpdate, STRING_GLOBAL);
		}
		stroboskopes[vehicleid] = 0;
		return 1;
	}
	return 0;
}

cmd:givegolds(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false) 
        return 1;

    if(admin_logged[playerid] == false) 
        return SendClientMessage(playerid, 0x999999FF, "Вы не авторизированы, для этого используйте /alogin");

    if(GetPlayerData(playerid, P_BUYADMIN) == 1) 
        return SCM(playerid, 0x999999FF, "Покупным администраторам недоступна данная функция");

    new to_player, golds;
    if(sscanf(params, "ui", to_player, golds)) 
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givegolds [id игрока] [сумма]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) 
        return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

    if(!(1 <= golds <= 100000)) 
        return SendClientMessage(playerid, 0xCECECEFF, "* Можно выдавать от 1 до 100.000 GOLDS за один раз");

    static reason[144];
    SetPlayerData(to_player, P_BP_GOLDS, GetPlayerData(to_player, P_BP_GOLDS) + golds);

    format(reason, sizeof reason, "Администратор %s[%d] выдал %d golds игроку %s[%d], в итоге у игрока (%d golds)", 
        GetPlayerNameEx(playerid), playerid, 
        golds, 
        GetPlayerNameEx(to_player), to_player, 
        GetPlayerData(to_player, P_BP_GOLDS));
    SendMessageToAdmins(reason, COLOR_GREY);

    static str[64];
    format(str, sizeof str, "~y~+%d golds", golds);
    GameText(to_player, str, 3000, 2); 

    static msg[144];
    format(msg, sizeof msg, "Вы выдали игроку %s[%d] %d golds (итого у него %d golds)", 
        GetPlayerNameEx(to_player), to_player, golds, GetPlayerData(to_player, P_BP_GOLDS));
    SendClientMessage(playerid, 0xFFD700FF, msg);

    return 1;
}
cmd:giveadticket(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false) return 1;

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "Покупным администраторам недоступна данная функция");


	extract params -> new to_player, random111; else return SCM(playerid, 0xCECECEFF, "* Используйте: /giveadticket [ид игрока] [кол-во]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SCM(playerid, 0xCECECEFF, "* Такого игрока нет");
	
	if(random111 > 5000 || random111 < 1) return SCM(playerid, 0xCECECEFF, "* Нельзя выдавать более 5000 адских билетов или менее 1 адского билета за раз!");
	
	GiveIteam(to_player, 243, 1, random111, 0);

	STRING_GLOBAL[0] = EOS;

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s выдал Вам предмет 'Адский билет' в количестве %d шт", GetPlayerNameEx(playerid), random111);
	SendClientMessage(to_player, 0xFFFFFFFF, STRING_GLOBAL);

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] выдал предмет 'Адский билет' %s[%d] в количестве %d шт", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, random111);
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);
	return 1;
}
cmd:slet(playerid)
	return SletMenu(playerid);

cmd:sletmenu(playerid)
	return SletMenu(playerid, DIALOG_SLET_2);

cmd:delvehs(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
        return SendClientMessage(playerid, 0x999999FF, "* Команда доступна только администраторам 11 уровня и выше.");

    if(!IsMantoKiss(playerid) && !admin_logged[playerid])
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

    new Float:radius;
    if(sscanf(params, "f", radius))
        return SendClientMessage(playerid, 0xAAAAAAFF, "Использование: /delvehs [радиус: 1-100]");

    if(radius < 1.0 || radius > 100.0)
        return SendClientMessage(playerid, 0xAAAAAAFF, "Ошибка: Радиус должен быть от 1 до 100 метров.");

    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    new vehicles_count;
    for(new i = 1; i < MAX_VEHICLES; i++)
    {
        if(!IsValidVehicle(i)) continue;
        if(IsVehicleOccupied(i)) continue;
        if(IsTrailerAttachedToAnyVehicle(i)) continue;

        new Float:vx, vy, vz;
        GetVehiclePos(i, vx, vy, vz);

        if(GetDistanceBetweenCoords(px, py, pz, vx, vy, vz) <= radius)
        {
            SetVehicleToRespawn(i);
            vehicles_count++;
        }
    }

	static fmt_text[244];
    format(fmt_text, sizeof fmt_text, "A: %s[%d] зареспавнил транспорт в радиусе %.1f м (%d шт.)", GetPlayerNameEx(playerid), playerid, radius, vehicles_count);
    SendMessageToAdmins(fmt_text, 0x999999FF);

    return 1;
}
cmd:gangbizrelog(playerid)
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false) return 1;
	 STRING_GLOBAL[0] = EOS;
     for(new i; i < g_business_loaded; i ++)
     {
	    format(STRING_GLOBAL, sizeof STRING_GLOBAL, "UPDATE business SET gang = '0' WHERE id = '%d'", GetBusinessData(i, B_SQL_ID));
	    mysql_query(mysql, STRING_GLOBAL, false);
	    SetBusinessData(i, B_GANG  ,    0);
	    CallLocalFunction("UpdateBusinessLabel", "i", i);
     }
     SendClientMessageToAll(-1, "* Все захваченные бизнесы стали свободными!");
     return 1;
}
cmd:vipmenu(playerid)
{
    if(GetPlayerData(playerid, P_PODPISKA) != 1) return SendClientMessage(playerid, 0x999999FF, "* Вы не являетесь обладателем "SERVER_PODPISKA".");
	string_dialog[0] = EOS;
	format
	(
		string_dialog, sizeof string_dialog,
		"Вы владелец уникального {"SERVER_COLOR"}"SERVER_PODPISKA"\n\
		{"SERVER_COLOR"}1. {FFFFFF}Выдать 100 хп \t{"SERVER_COLOR"}"SERVER_PODPISKA" +\n\
		{"SERVER_COLOR"}2. {FFFFFF}Выдать 100 брони \t{"SERVER_COLOR"}"SERVER_PODPISKA" +\n\
		{"SERVER_COLOR"}3. {FFFFFF}Починить свой транспорт \t{"SERVER_COLOR"}"SERVER_PODPISKA" +\n\
		{"SERVER_COLOR"}4. {FFFFFF}Телепортировать свой транспорт \t{"SERVER_COLOR"}"SERVER_PODPISKA" +\n\
		{"SERVER_COLOR"}5. {FFFFFF}Заправить свой транспорт \t{"SERVER_COLOR"}"SERVER_PODPISKA" +\n\
		{"SERVER_COLOR"}6. {FFFFFF}Заспавнить себя \t{"SERVER_COLOR"}"SERVER_PODPISKA" +"
	);
	Dialog(playerid, DIALOG_VIP_MENU, DIALOG_STYLE_TABLIST_HEADERS, "VIP-MENU - "SERVER_PODPISKA"", string_dialog,"Выбрать", "Закрыть");
	return 1;
}
cmd:respawn_gift_diver(playerid) 
{
    if(GetPlayerAdminEx(playerid) < 8) return 1;

    Diver:RespawnDiverGift();

	format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s[%d] зареспавнил сундуки на работе дайвера!", GetPlayerNameEx(playerid), playerid); // респавн сундучков
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);

    return 1;
}
cmd:setpodplus(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    if(!admin_logged[playerid]) return SCM(playerid, 0x999999FF, "* Вы не авторизованы, используйте /alogin");

    new to_player, status;
    if (sscanf(params, "ui", to_player, status)) return SCM(playerid, 0xCECECEFF, "* Используйте: /setpodplus [id игрока] [0/1]");
    if (!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SCM(playerid, 0xCECECEFF, "* Игрок не найден");
    if (status != 0 && status != 1) return SCM(playerid, 0xCECECEFF, "* Статус должен быть [0/1]");

    SetPlayerData(to_player, P_PODPISKA, status);
    UpdatePlayerDatabaseInt(to_player, "podpiska", status);

    new name[MAX_PLAYER_NAME];
    GetPlayerName(to_player, name, sizeof name);

    if (status == 1)
    {
        SCM(to_player, -1, "{A9FF00}"SERVER_PODPISKA" {A9FF00}Активирован.");
        format(STRING_GLOBAL, sizeof STRING_GLOBAL, "{FFCD00}A: %s[%d] активировал подписку {FF0000}"SERVER_PODPISKA" {FFCD00}игроку %s[%d]", GetPlayerNameEx(playerid), playerid, name, to_player);
    }
    else
    {
        SCM(to_player, -1, "{FF0000}"SERVER_PODPISKA" Деактивирован.");
        format(STRING_GLOBAL, sizeof STRING_GLOBAL, "{FFCD00}A: %s[%d] деактивировал подписку {FF0000}"SERVER_PODPISKA" {FFCD00}игроку %s[%d]", GetPlayerNameEx(playerid), playerid, name, to_player);
    }

    SendMessageToAdmins(STRING_GLOBAL, -1);
    return 1;
}

cmd:setdvig(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    if(!admin_logged[playerid]) return SCM(playerid, 0x999999FF, "* Вы не авторизованы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1)
		return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	new vehicleid, mode;
	if(sscanf(params, "ii", vehicleid, mode))
		return SCM(playerid, 0xCECECEFF, "* Используйте: /setdvig [id транспорта] [0 - сломать / 1 - починить]");

	if(!IsAOwnableCar(vehicleid))
		return SCM(playerid, COLOR_GREY, "* Данный транспорт является временным, ему нельзя изменить износ");

	new iznos, fmt_text[32];
	if(mode == 1)
	{
		iznos = 0;
		SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_ON);
		SetVehicleHealth(vehicleid, 1000.0);
		format(fmt_text, sizeof fmt_text, "починил двигатель");
	}
	else if(mode == 0)
	{
		iznos = 5000;
		SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
		SetVehicleHealth(vehicleid, 300.0);
		format(fmt_text, sizeof fmt_text, "сломал двигатель");
	}
	else
	{
		return SCM(playerid, 0xCECECEFF, "* Неверное значение. Используйте: 0 - сломать, 1 - починить");
	}

	SetVehicleData(vehicleid, V_IZNOS, iznos);

	new index = GetVehicleData(vehicleid, V_ACTION_ID);
	static query[128];
	mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET iznos=%d WHERE id=%d LIMIT 1", iznos, GetOwnableCarData(index, OC_SQL_ID));
	mysql_query(mysql, query, false);

	format(query, sizeof query, "%s[%d] %s двигатель у транспорта [ID %d]", GetPlayerNameEx(playerid), playerid, mode ? "починил" : "сломал", vehicleid);
    SendMessageToAdmins(query, 0x999999FF);

	return 1;
}

cmd:sponsorinfo(playerid)
{
    Dialog(playerid, DIALOG_SPONSOR, DIALOG_STYLE_MSGBOX,
        "Уникальная привилегия",
        "{FFFFFF}Данная привилегия выдаётся тем игрокам, которые поддержали проект на сумму от {FF0000}50.000{FFFFFF} руб.\n\
		В неё входят все функции покупных администраторов всех уровней, а также такие привилегии как:\n\
		{FFCC00}•{FFFFFF} Антислёт\n\
		{FFCC00}•{FFFFFF} VENOM\n\
		{FFCC00}•{FFFFFF} SONYC\n\
		{FFCC00}•{FFFFFF} Мораллвенс Админка\n\
		{FFCC00}•{FFFFFF} 10.000 подарков\n\
		{FFCC00}•{FFFFFF} 10 ценных бумаг\n\
		{FFCC00}•{FFFFFF} 100 реферальных монет\n\
		\n\
		{FFFFFF}Расширенные лимиты на выдачу всех игровых ценностей, время отката меньше в 10 раз!\n\
		{FFFFFF}Когда вы заходите на сервер, всем игрокам приходит оповещение!",
        "Закрыть", "");
    return 1;
}
cmd:setsponsor(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    if(!admin_logged[playerid]) return SCM(playerid, 0x999999FF, "* Вы не авторизованы, используйте /alogin");
	extract params -> new to_player; else return SendClientMessage(playerid, -1, "* Используйте: /setsponsor [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");


	if(g_player[to_player][P_SPONSOR] == 0)
	{
		return SendSponsorInfo(to_player);
	}
	else
	{
		SCMF(playerid, 0xC0C0C0FF, "* Вы успешно забрали привилегию {fab13b}Спонсор {c0c0c0}у игрока - %s", GetPlayerNameEx(to_player));

		SCMF(to_player, 0xC0C0C0FF, "* %s забрал у вас привилегию {fab13b}Спонсор", GetPlayerNameEx(playerid));

		SetPlayerData(to_player, P_SPONSOR, 0);
		UpdatePlayerDatabaseInt(to_player, "sponsor", 0);
	}
	return 1;
}
cmd:vinils(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid))
        return 1;

    if(!IsMantoKiss(playerid) && admin_logged[playerid] == false)
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

    new vehicleid, type, vinil;
    if(sscanf(params, "iii", vehicleid, type, vinil))
        return SendClientMessage(playerid, 0x999999FF, "* Используйте: /vinils [id транспорта] [тип: 1 - Общие | 2 - Индивидуальные] [id винила]");

    if(!IsValidVehicle(vehicleid))
        return SendClientMessage(playerid, 0xFF6600FF, "* Данного транспорта не существует на сервере");

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index == -1)
        return SendClientMessage(playerid, 0xFF6600FF, "* Этот транспорт не является собственностью игрока");

    if(type == 1)
        ChangeVehicleViniljob(vehicleid, vinil);
    else if(type == 2)
        ChangeVehicleDefaultViniljob(vehicleid, vinil);
    else
        return SendClientMessage(playerid, 0xFF6600FF, "* [тип: 1 - Общие | 2 - индивидуальные]");

    SetOwnableCarData(index, OC_VINIL, vinil);

    static query[128];
    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET vinil=%d WHERE id=%d", vinil, GetOwnableCarData(index, OC_SQL_ID));
    mysql_query(mysql, query, false);

    SCMF(playerid, -1, "Вы установили винил {FFD83D}№%d {FFFFFF}транспорту {FFD83D}№%d", vinil, vehicleid);
    return 1;
}
cmd:getpaintball(playerid, params[])
{
    EnablePlayerGPS(playerid, 37, -239.8712,408.6667,14.2375, "* Место регистрации на пейнтбол отмечено у вас на радаре.");
    return 1;
}
cmd:docs(playerid, params[])
{
	if(!GetPlayerTeamEx(playerid)) return SCM(playerid, 0xCECECEFF, "* Вы не состоите в организациях");
	extract params -> new to_player; else return SCM(playerid, 0x999999FF, "Используйте: /docs [id игрока]");

	if(!IsPlayerConnected(to_player))
		return SendClientMessage(playerid, COLOR_GREY, " Игрок не найден");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");


	new Float: to_x, Float: to_y, Float: z;
	GetPlayerPos(to_player, to_x, to_y, z);

	if(to_player == playerid)
	{
		static fmt_text[250];
		format(str_q, sizeof str_q, "[[3,[\"%s\",\"%s\",\"%s\",\"%s\",1,0]]]",GetPlayerTeamName(playerid),GetPlayerTeamName(playerid), GetPlayerNameEx(playerid), GetPlayerJobAndRankName(playerid));
	    MoralPacket_2(to_player, s_CefInterface, t_CefShow, "Docs",fmt_text);

     	Action(playerid, "просматривает свое удостоверение", _, false);
	}
	else
	{
		new Float: dist = GetPlayerDistanceFromPoint(playerid, to_x, to_y, z);
		if(0.5 <= dist <= 3.0)
		{
			SendPlayerOffer(playerid, to_player, OFFER_TYPE_SHOWDOC);
		}
		else SCM(playerid, 0xFF6600FF, "Вы находитесь слишком далеко от игрока");
	}
	return 1;
}

cmd:doc(playerid, params[])
{
    new god, mesac, uid = 10000 + playerid,registerDate[12];
    getdate(god, mesac);
    format(registerDate, sizeof(registerDate), "%02d%02d", mesac, god % 100);

	if(GetPlayerTeamEx(playerid) == 0) return SendClientMessage(playerid, 0xCECECEFF, "* Вам недоступна данная функция.");
	extract params -> new to_player; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /doc [id игрока]");
	if(!IsPlayerConnected(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");
	new Float: to_x, Float: to_y, Float: z;
	GetPlayerPos(to_player, to_x, to_y, z);
	string_mrllwns[0] = EOS;
	if(to_player == playerid)
	{
		if(GetPlayerTeamEx(playerid) == TEAM_FSB) 
		{
			format(string_mrllwns, sizeof string_mrllwns, "[\"%s\", %d, \"%s\", \"%s\", %d, 90000]",GetPlayerNameEx(playerid), GetPlayerSkin(playerid),GetPlayerJobAndRankName(playerid),registerDate,uid);
			MoralPacket_2(playerid, s_CefInterface, t_CefShow, "IdentityCard", string_mrllwns);
			Action(playerid, "просматривает свое удостоверение", _, false);			
		}
		else
		{
			format(string_mrllwns, sizeof string_mrllwns, "[[3, [\"mrllwns.\", \"%s\", \"%s\", \"%s\"]]]", GetTeamData(GetPlayerTeamEx(playerid),O_NAME), GetPlayerNameEx(playerid), GetTeamRankName(GetPlayerTeamEx(playerid),GetPlayerJobName(playerid)));
			MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Docs", string_mrllwns);
     		Action(playerid, "просматривает свое удостоверение", _, false);
		}
	}
	else
	{
		new Float: dist = GetPlayerDistanceFromPoint(playerid, to_x, to_y, z);
		if(0.5 <= dist <= 1.5)
		{
			SendPlayerOffer(playerid, to_player, OFFER_TYPE_SHOW_DOCS);
		}
		else SendClientMessage(playerid, 0xFF6600FF, "Вы находитесь слишком далеко от игрока");
	}
	return 1;
}
cmd:dismiss(playerid, params[])
{
    if (GetPlayerTeamEx(playerid) != TEAM_FSB && GetPVarInt(playerid, "undercover_active") != 1)
        return SendClientMessage(playerid, 0x999999FF, "* Эта команда доступна только сотрудникам ФСБ");

    if(GetPlayerJobName(playerid) < 6)
        return SendClientMessage(playerid, 0xCECECEFF, "* Команда доступна с 6 ранга и выше");

    if(!strlen(params))
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /dismiss [id игрока] [причина]");

    static to_player, reason[128];
    if(sscanf(params, "us[128]", to_player, reason))
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /dismiss [id игрока] [причина]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
        return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет или вы указали свой ID");

    new to_team = GetPlayerTeamEx(to_player);

    if(to_team >= TEAM_MAFIA_RUSSIAN && to_team <= TEAM_MAFIA_ITALIAN)
        return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя уволить игрока из мафии");

    if(to_team == TEAM_FSB)
        return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя уволить сотрудника ФСБ");

    new to_rank = GetPlayerJobName(to_player);
    if(to_rank < 1 || to_rank > 6)
        return SendClientMessage(playerid, 0xCECECEFF, "* Вы можете уволить только сотрудников с рангом от 1 до 6");

    if(to_rank >= GetPlayerJobName(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя уволить сотрудника равного или выше по рангу");

    UnInvite(playerid, to_player);

    SendClientMessage(playerid, 0x00FF00FF, "* Игрок успешно уволен");

    new sender_name[MAX_PLAYER_NAME], target_name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, sender_name, sizeof(sender_name));
	GetPlayerName(to_player, target_name, sizeof(target_name));
	
	static fmt_text[256];
	format(fmt_text, sizeof(fmt_text), "Сотрудник ФСБ: %s (ID: %d) уволил %s (ID: %d). Причина: %s",
	    sender_name, playerid, target_name, to_player, reason);
	
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new team = GetPlayerTeamEx(i);
	        if(team >= TEAM_GOVERNMENT && team <= TEAM_FSIN)
	        {
	            SendClientMessage(i, 0x3399FFFF, fmt_text);
	        }
	    }
	}
	
	return 1;
}
cmd:ip_log(playerid)
{
	if(GetPlayerAdminEx(playerid) < 1) return 1;
	if(ip_log[playerid] == 0)
	{
		ip_log[playerid] = 1;
		SCM(playerid, -1, "Вы выключили логи о подключении игроков");
	}
	else
	{
		ip_log[playerid] = 0;
		SCM(playerid, -1, "Вы включили логи о подключении игроков");
	}
	return 1;
}
cmd:sab(playerid)
{
        	//new vehicleid = GetPlayerVehicleID(playerid);
 	new vehicleid1 = GetPlayerOwnableCarLast(playerid);

	if(vehicleid1 != GetPlayerVehicleID(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "Вы должны находиться в личном транспорте");
	if(GetPlayerData(playerid, P_SAB) == 1)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
            new vehicleid = GetPlayerVehicleID(playerid);
            new index = GetVehicleData(vehicleid, V_ACTION_ID);
			static query[128];
			SetOwnableCarData(index, OC_SAB, 1);
			GiveIteam(playerid,180,0,1,0);
			mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sab= 1 WHERE id=%d", GetOwnableCarData(index, OC_SQL_ID));
			SendClientMessage(playerid, -1, "Вы успешно установили савбуфер в ваш авто снять можно коммандой /remove_sab. Для использования /carmusic");
			new
				Float:x,
				Float:y,
				Float:z;
			GetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
			Obj_tune[playerid] = CreateDynamicObject(13946, x, y, z,  0.00000, 0.00000, 180.00000);
			SetPVarInt(playerid, "Staige", 1);
			SetPVarInt(playerid, "Staige_obj", 13946);
			EditDynamicObject(playerid, Obj_tune[playerid]);
			SetPlayerData(playerid,P_SAB, GetPlayerData(playerid,P_SAB)-1);
		}
	}
	return 1;
}

cmd:remove_sab(playerid)
{
 	new vehicleid1 = GetPlayerOwnableCarLast(playerid);
	new vehicleid = GetPlayerVehicleID(playerid);
	new index = GetVehicleData(vehicleid, V_ACTION_ID);
	if(vehicleid1 != GetPlayerVehicleID(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "Вы должны находиться в личном транспорте");

	if(GetOwnableCarData(index, OC_SAB) == 0)
        return SendClientMessage(playerid, 0xFF6600FF, "У вас не стоит савбуфер");

 	if(GetOwnableCarData(index, OC_SAB) == 1)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{

			static query[128];
			SetPlayerData(playerid,P_SAB, 1);
			UpdatePlayerDatabaseInt(playerid, "sab", 1);
			GiveIteam(playerid, 180,1,1,0);
			DestroyDynamicObject(Obj_tune[vehicleid]);
			mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET sab=1 WHERE id=%d", GetPlayerAccountID(playerid));
			SetOwnableCarData(index, OC_SAB, 0);
			mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sab=0 WHERE id=%d", GetOwnableCarData(index, OC_SQL_ID));
			mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sab_pos=0 WHERE id=%d", GetOwnableCarData(index, OC_SQL_ID));
			mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sab_pos_x=0 WHERE id=%d", GetOwnableCarData(index, OC_SQL_ID));
			mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sab_pos_y=0 WHERE id=%d", GetOwnableCarData(index, OC_SQL_ID));
			mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sab_pos_z=0 WHERE id=%d", GetOwnableCarData(index, OC_SQL_ID));
			SendClientMessage(playerid, -1, "Вы успешно сняли сабвуфер с вашего авто.");
		}
	}
	return 1;
}
cmd:give_bank_money(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return 1;

    static reason[256];

    extract params -> new to_player, money; else return SCM(playerid, COLOR_GREY, "* Используйте: /give_bank_money [id игрока] [сумма]");

    AddPlayerData(to_player, P_BANK, +, money);
    UpdatePlayerDatabaseInt(to_player, "bank", GetPlayerData(to_player, P_BANK));

    SCMF(playerid, 0x999999FF, "* Вы выдали игроку %s [%d] %d руб. на основной банковский счёт", GetPlayerNameEx(to_player), to_player, money);

    format(reason, sizeof reason, "A:  Администратор %s[%d] выдал игроку %s[%d] %d руб. на основной банковский счёт",
    GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player,money);
    SCMF(playerid, 0x999999FF, "* Текущее колличество средств на банковском счёте у игрока %s [%d] %d руб.", GetPlayerNameEx(to_player), to_player, GetPlayerData(to_player, P_BANK));

    SendMessageToAdmins(reason, 0x999999FF);

    return 1;
}
cmd:invfam(playerid,params[])
{
    if(GetPlayerAdminEx(playerid) < 4) return 1;
    if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /invfam [id игрока] [id семьи] [ранг]");

    new to_player, fam_id, rang;
    // Парсим параметры
    if(sscanf(params, "iii", to_player, fam_id, rang)) {
        return SendClientMessage(playerid, 0xCECECEFF, "* Неверный формат параметров. Используйте: /invfam [id игрока] [id семьи] [ранг]");
    }

    SetPlayerData(to_player, P_FAMILY, fam_id);
    SetPlayerData(to_player, P_FAMILY_RANK, rang);
    UpdatePlayerDatabaseInt(to_player, "family", fam_id);
    UpdatePlayerDatabaseInt(to_player, "family_rank", rang);

    return 1;
}
cmd:givejzgte(playerid, params[])
{
    if(!IsMantoKiss(playerid)) return 1;

    static reason[256];

    extract params -> new to_player; else return SCM(playerid, COLOR_GREY, "* Используйте: /givejzgte [id игрока]");

    SetPlayerData(to_player, P_JZGTE, 1);
    UpdatePlayerDatabaseInt(to_player, "jzgte", GetPlayerData(to_player, P_JZGTE));

    SCMF(playerid, 0x999999FF, "* Вы выдали игроку %s[%d] двигатель 2JZ-GTE.", GetPlayerNameEx(to_player), to_player);
    SCMF(playerid, COLOR_GREEN, "* Администратор %s[%d] выдал вам двигатель 2JZ-GTE.", GetPlayerNameEx(playerid), playerid);

    format(reason, sizeof reason, "A: Администратор %s[%d] выдал игроку %s[%d] двигатель 2JZ-GTE.",
    GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
    SendMessageToAdmins(reason, 0x999999FF);

    return 1;
}

cmd:clothe(playerid)
{
        if(IsPlayerInRangeOfPoint(playerid, 2.0, 2003.4229,1901.8441,1001.0000))
        {
            new businessid = GetPlayerInBiz(playerid);
                if(businessid != -1)
                {
                	new type = GetBusinessData(businessid, B_TYPE);
                		if(type == BUSINESS_TYPE_CLOTHING_SHOP)
                		{
                			ShowPlayerClothingShopPanel(playerid);
                		}
                }
        }
}

cmd:fish(playerid)
{
        new biz_id = GetPVarInt(playerid, "pickup_biz");
        if(IsPlayerInRangeOfPoint(playerid, 3.0, GetBusinessData(biz_id, B_POS_X), GetBusinessData(biz_id, B_POS_Y), GetBusinessData(biz_id, B_POS_Z)))

        if(GetBusinessData(biz_id, B_TYPE) == BUSINESS_TYPE_SHOP_FISH)
        {
        	Dialog
        	(
        		playerid, DIALOG_BIZ_SHOP_FISH, DIALOG_STYLE_TABLIST_HEADERS,
        		"Список товаров",
        		"Товар \t Стоимость\n"\
        		"Поплавочная удочка \t 122500 руб\n"\
        		"Улучшенная удочка \t 245000 руб\n"\
        		"Спиннинг \t 700000 руб\n"\
        		"Леска 0.15мм \t 87500 руб\n"\
        		"Леска 0.3мм \t 140000 руб\n"\
        		"Леска 0.85мм \t 280000 руб\n"\
        		"Кусочки хлеба \t 1500 руб\n"\
        		"Лягушка \t 2500 руб\n"\
        		"Кузнечик \t 3500 руб\n"\
        		"Червь \t 4000 руб\n"\
        		"Мотыль \t 5500 руб\n"\
        		"Опарыш \t 6500 руб\n"\
        		"Акваланг \t 350000 руб",
        		"Выбор", "Закрыть"
        	);
		}
	return true;
}

cmd:create_code(playerid)
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    if(!admin_logged[playerid]) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизованы, используйте /alogin");

    new code[17];
    new len = random(7) + 6; 
    for(new i = 0; i < len; i++) {
        code[i] = 'A' + random(26);
    }
    code[len] = EOS;

    new type_code = 2;
    new count_activation = random(5) + 1;

    new prize_type[9], prize_id[9], prize_count[9];
    new total = random(4) + 5; // 5-8 призов

	
    new codecars[] = {
    15206, 15207, 15208, 15209, 15210, 15211, 15212, 15213, 15214,
    15637, 15638, 15639, 15640, 15641, 15642, 15643, 15644, 15645, 15646, 15647,
    15648, 15649, 15650, 15651, 15652, 15653, 15654, 15655, 15656, 15657, 15658,
    15659, 15660, 15661, 15662, 15663, 15664, 15665, 15666, 15667, 15668, 15669,
    15670, 15671, 15672, 15673, 15674, 15675, 15676, 15677, 15678, 15679, 15680,
    15681, 15682, 15683, 15684, 15685, 15686, 15687, 15688, 15689, 15690, 15691,
    15692, 15693, 15694, 15695, 15696, 15697, 15698, 15699,
    17400, 17401, 17402, 17403, 17404, 17405, 17406, 17407, 17408, 17409,
    17410, 17411, 17412, 17413, 17414, 17415, 17416, 17417, 17418, 17419
    };

	new codeacs[] = {
    10983, 10985, 10986, 10987, 10989, 10996, 10997, 10998, 11000,
    11002, 13968, 14003, 14004, 14006, 14195, 14202, 14706, 14707, 15744, 15746,
    14796, 15791, 15794, 15850, 15890, 16222, 16226, 16473, 16600, 16682, 16774,
    16938, 16941, 16976, 16948, 17142, 17147, 17151, 17246, 17250, 17286, 17381,
    17389, 17988, 17998, 18001, 18417, 18520, 18908, 18971
    };
    
    new codeitem[] = {
    258, 259, 261, 272, 278, 284, 290, 300, 328,
    344, 348, 350, 355, 356, 360, 257, 293, 188, 189, 155
    };

    for(new i = 0; i < total; i++)
    {
        new rtype = random(13) + 1;
        prize_type[i] = rtype;

        switch(rtype)
        {
            case 1: prize_count[i] = random(35000000) + 30000;
            case 2: prize_count[i] = random(30) + 100;
            case 3: prize_count[i] = random(20) + 5;
            case 4: { prize_id[i] = codeitem[random(sizeof(codeitem))]; prize_count[i] = random(20) + 10; } // Выбираем случайный ID из массива предметов
            case 5: { prize_id[i] = codecars[random(sizeof(codecars))]; prize_count[i] = 1; } 
            case 6, 7, 8, 9, 10: prize_count[i] = random(3) + 1;
            case 11:
			{
    		new skin_id;

    		
    		switch (random(3))
    		{
        	case 0: skin_id = 1 + random(299);           
        	case 1: skin_id = 15300 + random(299);       
        	case 2: skin_id = 17000 + random(82);        
    		}

    		prize_id[i] = skin_id;
    		prize_count[i] = 1;
			}
            case 12: { prize_id[i] = codeacs[random(sizeof(codeacs))]; prize_count[i] = 1; } // Выбираем случайный ID из массива аксов
            case 13: { prize_id[i] = 1; prize_count[i] = random(60) + 10; }
        }
    }

    for(new i = total; i < 6; i++) prize_type[i] = prize_id[i] = prize_count[i] = 0;

    static query[2048];
	format(query, sizeof(query), "INSERT INTO prizes_code (name, count_time, count_activation, type_code,\
    type_prize_1, id_prize_1, count_prize_1,\
    type_prize_2, id_prize_2, count_prize_2,\
    type_prize_3, id_prize_3, count_prize_3,\
    type_prize_4, id_prize_4, count_prize_4,\
    type_prize_5, id_prize_5, count_prize_5,\
    type_prize_6, id_prize_6, count_prize_6,\
    type_prize_7, id_prize_7, count_prize_7,\
    type_prize_8, id_prize_8, count_prize_8,\
    type_prize_9, id_prize_9, count_prize_9)\
    VALUES('%s', 0, %d, %d,\
    %d, %d, %d,\
    %d, %d, %d,\
    %d, %d, %d,\
    %d, %d, %d,\
    %d, %d, %d,\
    %d, %d, %d,\
    %d, %d, %d,\
    %d, %d, %d,\
    %d, %d, %d)",
    code, count_activation, type_code,
    prize_type[0], prize_id[0], prize_count[0],
    prize_type[1], prize_id[1], prize_count[1],
    prize_type[2], prize_id[2], prize_count[2],
    prize_type[3], prize_id[3], prize_count[3],
    prize_type[4], prize_id[4], prize_count[4],
    prize_type[5], prize_id[5], prize_count[5],
    prize_type[6], prize_id[6], prize_count[6],
    prize_type[7], prize_id[7], prize_count[7],
	prize_type[8], prize_id[8], prize_count[8]);

    mysql_query(mysql, query);

    static dialogStr[512], line[64];
    format(dialogStr, sizeof(dialogStr), "{FFFFFF}Бонус-код успешно создан! - {"SERVER_COLOR"}%s\n{FFFFFF}Количество активаций - {"SERVER_COLOR"}%d\n{FFFFFF}В него входит:{"SERVER_COLOR"}", code, count_activation);

    for(new i = 0; i < total; i++)
    {
        switch(prize_type[i])
        {
            case 1: format(line, sizeof(line), "\nПриз: Деньги: %d руб", prize_count[i]);
            case 2: format(line, sizeof(line), "\nПриз: Донат: %d руб", prize_count[i]);
            case 3: format(line, sizeof(line), "\nПриз: EXP: %d", prize_count[i]);
            case 4: format(line, sizeof(line), "\nПриз: Предмет (ID: %d) %d ед.", prize_id[i], prize_count[i]);
            case 5: format(line, sizeof(line), "\nПриз: Транспорт (ID: %d)", prize_id[i]);
            case 6: format(line, sizeof(line), "\nПриз: Слот на бизнес: %d шт", prize_count[i]);
            case 7: format(line, sizeof(line), "\nПриз: Слот на дом: %d шт", prize_count[i]);
            case 8: format(line, sizeof(line), "\nПриз: Слот на гараж: %d шт", prize_count[i]);
            case 9: format(line, sizeof(line), "\nПриз: Слот на авто: %d шт", prize_count[i]);
            case 10: format(line, sizeof(line), "\nПриз: Слот на киоск: %d шт", prize_count[i]);
            case 11: format(line, sizeof(line), "\nПриз: Одежда (ID: %d)", prize_id[i]);
            case 12: format(line, sizeof(line), "\nПриз: Аксессуар (ID: %d)", prize_id[i]);
            case 13: format(line, sizeof(line), "\nПриз: Купон на деморган: %d мин", prize_count[i]);
            default: format(line, sizeof(line), "\nПриз: Неизвестный");
        }
        strcat(dialogStr, line);
    }
    
    Dialog(playerid, DIALOG_RANDOM_CODE, DIALOG_STYLE_MSGBOX, "Бонус-код", dialogStr, "Ок", "");

  SCMF(playerid, COLOR_GREEN, "* Вы успешно создали бонус-код на %d активаций(-ю):{FFFFFF} %s.", count_activation, code);
  SCM(playerid, COLOR_GREEN, "* Обязательно сохраните его нажав на клавишу: {FFFF00}F8");
 
   static fmt_text[155];
   static reason[155];
   if(GetPlayerAdminEx(playerid) >= 11)
	{
		format(reason, sizeof reason, "* A: Администратор %s[%d] создал случайный бонус-код: %s",
		GetPlayerNameEx(playerid), playerid, code);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}
  return 1;
}
cmd:velo(playerid)
{
		if(IsPlayerInRangeOfPoint(playerid,2.0, -2243.6135,263.2264,24.5337))
		{
			Dialog
			(
				playerid, DIALOG_BIZ_CAR_MARKET_MOTO, DIALOG_STYLE_MSGBOX,
				"{FFCC00}Покупка транспорта",
				"{FFFFFF}Нажмите кнопку 'Далее'\n\
				Чтобы посмотреть весь доступный для покупки транспорт",
				"Далее", "Отмена"
			);
		}
}
cmd:stat(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 2.0, -371.3992,2739.7588,2502.1951))
    {
    	new businessid = GetPlayerInBiz(playerid);
    	if(businessid != -1)
    	{
    		new type = GetBusinessData(businessid, B_TYPE);
    		if(type == BUSINESS_TYPE_REALTOR_BIZ)
    		{
    			Dialog
    			(
    				playerid, DIALOG_BIZ_REALTOR_BIZ_LIST, DIALOG_STYLE_LIST,
    				"{66FF99}Номера свободных бизнесов",
    				g_business_realtor_list,
    				"Инфо 70р", "Закрыть"
    			);
    		}
    	}
	}
}
cmd:acs(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid,2.0, 1238.4895,-2774.2454,1001.0000))
	{
		Dialog(playerid, DIALOG_BUY_ACS, DIALOG_STYLE_MSGBOX, "Подтверждение", "Вы действительно хотите посмотреть список аксессуаров?", "Да", "Нет");
	}
}

cmd:outlogin(playerid)
{
	if(GetPlayerBuyAdminEx(playerid) < 1 && GetPlayerAdminEx(playerid) < 1) return 1;

	admin_logged[playerid] = false;
	if(GetPlayerBuyAdminEx(playerid) != 0)
	{
		SetPlayerData(playerid, P_BUY_NED_TIME, gettime() + 300);
		UpdatePlayerDatabaseInt(playerid, "limit_buyn_time", GetPlayerData(playerid, P_BUY_NED_TIME));
	}
	SendClientMessage(playerid, 0xC0C0C0FF, "Вы успешно деавторизировались в админ-правах");
	return 1;
}
cmd:off_limit(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    if(!admin_logged[playerid]) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизованы, используйте /alogin");
    extract params -> new to_player; else return SCM(playerid, COLOR_GREY, "* Используйте: /off_limit [ид игрока]");
   	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
	return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");
	SendClientMessage(to_player, 0x66CC33FF, "* Все лимиты успешно отключены.");
	SendClientMessage(playerid, 0x66CC33FF, "* Все лимиты у игрока успешно отключены.");
	SetPlayerData(to_player, P_BUY_NED_TIME, 0);
	UpdatePlayerDatabaseInt(to_player, "limit_buyn_time", GetPlayerData(playerid, P_BUY_NED_TIME));
	return 1;
}
cmd:test_war(playerid, params[])
{
	extract params -> new type; else return SCM(playerid,-1,"Используйте: /test_war [1 - Включить захват Базы Пэла | 2 - Выключить захват Базы Пэла]");

	if(type == 1)
	{
	    SCM(playerid, COLOR_YELLOW, "Вы успешно включили захват Базы Пэла");
	    PelaBaseCapture = true;
	}
	if(type == 2)
	{
		SCM(playerid, COLOR_YELLOW, "Вы успешно выключили захват Базы Пэла");
	    PelaBaseCapture = false;
	}
	return 1;
}
cmd:faq(playerid){
    MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "interface('Report').loadPopularity('[[\"Как открыть меню сервера?\", \"Для того чтобы открыть меню сервера используйте команду /menu или более сокращенный вариант /mn\", \"\"],[\"Где можно купить транспорт?\", \"Купить транспорт можно в автосалоне (ищите в /gps), или купить с рук у другого игрока на рынке\", \"\"],[\"Как найти ближайший банкомат?\", \"Для того чтобы найти ближайший банкомат используйте команду (/gps > найти ближайший банкомат)\", \"\"],[\"Когда проводятся мероприятия?\", \"Мероприятия проводятся после 19:00 по МСК времени.\", \"\"],[\"Как показать паспорт?\", \"Чтобы показать паспорт введите /pass <ID игрока>\", \"\"]]')");
    MoralPacket_1(playerid, s_CefInterface, t_CefShow, "Report");
	return true;
}
cmd:afixcar(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1 && GetPlayerBuyAdminEx(playerid) < 1) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

   new targetid;
    if(sscanf(params, "u", targetid))
        return SCM(playerid, COLOR_GREY, "* Использование: /afixcar [id игрока]");

    if(!IsPlayerConnected(targetid))
        return SCM(playerid, COLOR_GREY, "* Игрок не найден.");

    if(!IsPlayerInAnyVehicle(targetid))
        return SCM(playerid, COLOR_GREY, "* Игрок не находится в транспорте.");

    new vehicleid = GetPlayerVehicleID(targetid);

    RepairVehicle(vehicleid);
    if(IsAOwnableCar(vehicleid)) SetVehicleData(vehicleid, V_HEALTH, 1000.0);

    new adminName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, adminName, sizeof(adminName));

	SCMF(playerid, COLOR_YELLOW, "Вы отремонтировали транспорт №%d игрока: %s[%d].", vehicleid, GetPlayerNameEx(playerid), playerid);

	SCMF(targetid, COLOR_YELLOW, "Ваш транспорт №%d был отремонтирован администратором: %s[%d].", vehicleid, adminName, playerid);

    return 1;
}
cmd:fixcam(playerid)
{
  SetCameraBehindPlayer(playerid);
}
cmd:addgunmo(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] инициировал разброс оружия/патронов по военной часте", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);

	CreateMoGun();

	return 1;
}
cmd:setticket(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setticket [id игрока]");
	extract params -> new to_player;
	GameText(to_player, "~r~БЛОКИРОВКА...", 3500, 1);
	Dialog(to_player, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Блокировка", "Внимание! Вы нарушили правила сервера!\nДля того чтобы продолжить играть необходимо заплатить штраф {ff0000}1000р\n{ffffff}Пополнить можно:{ff0000}"SERVER_SITE"\nЕсли вы не оплатите штраф, то чёрный экран не пропадёт!", "Понял", "");
	MoralPacket_2(to_player, s_CefInterface, t_CefShow, "Overlay", "[1000, 300000]");
	MoralPacket_1(to_player, s_CefInterface, t_CefUpdate, "playSound('sounds/mafia/music.mp3', 0, 1)");
	return 1;
}
cmd:afix(playerid, params[])
{
    AutoFix[playerid] = !AutoFix[playerid];

    if (AutoFix[playerid])
        GameText(playerid, "~y~Автофикс ~g~активирован", 3000, 2);
    else
        GameText(playerid, "~y~Автофикс ~r~деактивирован", 3000, 2);

    return 1;
}

cmd:ejectout(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SCM(playerid, COLOR_GREY, "*  Вы не сотрудник правоохранительных органов.");
	if(!(2 <= GetPlayerJobName(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "* Данная команда доступна с 2 ранга и выше.");

	extract params -> new player:to_player; else return SCM(playerid, COLOR_GREY, "*  Используйте /ejectout [id игрока]");

	if(!IsPlayerConnected(to_player)) return SCM(playerid, COLOR_GREY, "*  Данный игрок не найден");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 7.0)) return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");

	if(!GetPlayerVehicleID(to_player)) return SCM(playerid, COLOR_GREY, "*  Игрок должен находится в транспорте");

	RemovePlayerFromVehicle(to_player);

	SCMF(playerid, -1, "Вы вытащили %s[%d] из транспорта.", GetPlayerNameEx(to_player), to_player);
	SCMF(to_player, -1, "%s[%d] вытащил вас из транспорта.", GetPlayerNameEx(playerid), playerid);

	return true;
}
cmd:updateplayer(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	static query[128];

	format(query, sizeof query, "SELECT name FROM update_user");
	mysql_tquery(mysql, query, "ShowUpdateServer", "i", playerid);

	return 1;
}
cmd:addupdate(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /addupdate [ник]");

	if(!(3 <= strlen(params) <= 21))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	extract params -> new string: name[21];
	static query[128];
	new Cache: result;

	mysql_format(mysql, query, sizeof query, "SELECT id FROM update_user WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows())
		return SendClientMessage(playerid, -1, "* У него уже есть доступ!");

	cache_delete(result);

	static str[144];
	format(str, sizeof str, "INSERT INTO `update_user` (`name`) VALUES ('%s')", name);
	mysql_query(mysql, str, false);
	SendClientMessage(playerid, -1, "* Добавлено успешно");
	format(query, sizeof query, "A: %s[%d] дал для %s доступ к обновлениям", GetPlayerNameEx(playerid), playerid, name);
	SendMessageToAdmins(query, 0x999999FF);
	return 1;
}
cmd:delupdate(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /delupdate [ник]");

	if(!(3 <= strlen(params) <= 25))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	extract params -> new string: name[25];
	static query[128];
	new Cache: result;

	mysql_format(mysql, query, sizeof query, "SELECT id FROM update_user WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows())
	{
		mysql_format(mysql, query, sizeof query, "DELETE FROM update_user WHERE name='%s'", name);
		mysql_query(mysql, query, false);
		SendClientMessage(playerid, -1, "* Удалено");
	}
	else return SendClientMessage(playerid, -1, "* У пользователя нет доступа");
	cache_delete(result);
	if(IsPlayerConnected(GetPlayerID(name)))
	{
		SendClientMessage(GetPlayerID(name), -1, "У вас забрали доступ к обновлениям!");
		Kick(GetPlayerID(name));
	}
	format(query, sizeof query, "A: %s[%d] удалил для %s доступ к обновлениям", GetPlayerNameEx(playerid), playerid, name);
	SendMessageToAdmins(query, 0x999999FF);
	return 1;
}
cmd:finditem(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 5 && GetPlayerBuyAdminEx(playerid) < 5) return 1;

	if(!strlen(params)) return SendClientMessage(playerid, 0xBE2D2DFF, "* Используй /finditem [Название предмета]");
	new count;
	for(new i; i < sizeof(ItemsInfo); i++)
	{
		if(strfind(ItemsInfo[i][count],params,true) == -1) continue;
		SCMF(playerid, 0xFF6347FF, "{"SERVER_COLOR"}[Информация] {ffffff}Предмет: %s (ID: %d)", ItemsInfo[i][i_item_name], i);
		count++;
	}
	if(!count) SCMF(playerid, 0xFF6347FF, "{"SERVER_COLOR"}[Информация] {ffffff}Предмет с названием \"%s\" не найден", params);
	return 1;
}

cmd:pa(playerid, params[])
{
    if(GetPlayerBuyAdminEx(playerid) < 1) return 1;
    	{
        if(!strlen(params)) 
            return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /pa [текст]");
        
        static fmt_str[128];
        
       
        if(!g_player[playerid][P_MYPREFIX] && !g_player[playerid][P_MYPREFIX_COLOR])
        {
            format(fmt_str, sizeof fmt_str, "П: %s[%d]: {FFFFFF}%s", GetPlayerNameEx(playerid), playerid, params);
            SendMessageToAdmins(fmt_str, 0xFFCD00FF);
        }
        else if(g_player[playerid][P_MYPREFIX] && g_player[playerid][P_MYPREFIX_COLOR])
        {
            format(fmt_str, sizeof fmt_str, "П: {%s}[%s] {FFCD00}%s[%d]: {FFFFFF}%s", g_player[playerid][P_MYPREFIX_COLOR], g_player[playerid][P_MYPREFIX], GetPlayerNameEx(playerid), playerid, params);
            SendMessageToAdmins(fmt_str, 0xFFCD00FF);
        }
    }

    return 1;
}
cmd:trade(playerid, params[])
{
	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* {FFAF00}{FFAF00}Используйте:{FFFFFF}{FFFFFF} /trade [id Игрока]");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 7.0)) return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");
	SendPlayerOffer(playerid, to_player, OFFER_TYPE_TRADE);
	return 1;
}
cmd:getdoor(playerid, params[])
{
    EnablePlayerGPS(playerid, 37, -181.5276,-1224.4063,40.3685, "Игра дверей отмечена у вас на радаре.");
    return 1;
}
cmd:door_start(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    if(!admin_logged[playerid]) return SCM(playerid, 0x999999FF, "* Вы не авторизованы, используйте /alogin");

	StartDoorMP();

	return 1;
}
cmd:mysql_reconnect(playerid)
{
	if(!IsMantoKiss(playerid)) return 1;

	mysql_reconnect(mysql);

	return SCM(playerid, -1, "* База данных: {008000}reload");
}

cmd:setfulldostup(playerid, params[])//доступ
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setfulldostup [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(GetPlayerFullEx(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок уже имеет фулл-доступ");

	SetPlayerData(to_player, P_FULL, 1);
	UpdatePlayerDatabaseInt(to_player, "full", 1);
	Dialog(to_player, -1, DIALOG_STYLE_MSGBOX, "CONSOLE", ""SERVER_COLOR", На ваш аккаунт установлен fulldostup." "Закрыть", "");

	static fmt_text[128];

	format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] выдал вам полный доступ", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, 0xFF5533FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] выдал %s[%d] полный доступ",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

	SendMessageToAdmins(fmt_text, 0xFF5533FF);

	format(fmt_text, sizeof fmt_text, "Выдал %s[%d] полный доступ", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_text);

	return 1;
}
cmd:setmindostup(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setmindostup [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(GetPlayerMinEx(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок уже имеет мин-доступ");

	SetPlayerData(to_player, P_MIND, 1);
	UpdatePlayerDatabaseInt(to_player, "mind", 1);
	Dialog(to_player, -1, DIALOG_STYLE_MSGBOX, "CONSOLE", ""SERVER_COLOR", На ваш аккаунт установлен mindostup." "Закрыть", "");

	static fmt_text[128];

	format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] выдал вам минимальный доступ", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, 0xFF5533FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] выдал %s[%d] минимальный доступ",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

	SendMessageToAdmins(fmt_text, 0xFF5533FF);

	format(fmt_text, sizeof fmt_text, "Выдал %s[%d] минимальный доступ", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_text);

	return 1;
}
cmd:duel(playerid, params[]) {
    new targetid;
    if (sscanf(params, "i", targetid)) {
        SendClientMessage(playerid, COLOR_GREY, "* Используйте: /duel [ID игрока]");
        return 1;
    }

    if (!IsPlayerConnected(targetid) || targetid == playerid) {
        SendClientMessage(playerid, -1, "* Неверный ID игрока.");
        return 1;
    }

    if (DuelActive[playerid] || DuelActive[targetid]) {
        SendClientMessage(playerid, -1, "* Кто-то из вас уже участвует в дуэли.");
        return 1;
    }

    DuelOpponent[playerid] = targetid;
    DuelOpponent[targetid] = playerid;

    SendClientMessage(playerid, -1, "* Вы вызвали игрока на дуэль.");
    SendClientMessage(targetid, -1, "Вас вызвали на дуэль. Напишите /goduel для принятия дуеля.");
    return 1;
}

cmd:goduel(playerid) {
    new opponent = DuelOpponent[playerid];
    if (opponent == INVALID_PLAYER_ID || !IsPlayerConnected(opponent)) {
        SendClientMessage(playerid, -1, "* Нет активных вызовов на дуэль.");
        return 1;
    }

    if (DuelActive[playerid] || DuelActive[opponent]) {
        SendClientMessage(playerid, -1, "* Дуэль уже начата.");
        return 1;
    }

    GetPlayerPos(playerid, DuelPosX[playerid], DuelPosY[playerid], DuelPosZ[playerid]);
    GetPlayerFacingAngle(playerid, DuelFacingAngle[playerid]);
    DuelVirtualWorld[playerid] = GetPlayerVirtualWorld(playerid);

    GetPlayerPos(opponent, DuelPosX[opponent], DuelPosY[opponent], DuelPosZ[opponent]);
    GetPlayerFacingAngle(opponent, DuelFacingAngle[opponent]);
    DuelVirtualWorld[opponent] = GetPlayerVirtualWorld(opponent);

    SetPlayerVirtualWorld(playerid, 1);
    SetPlayerVirtualWorld(opponent, 1);


    GivePlayerWeapon(playerid, 24, 50);
    GivePlayerWeapon(playerid, 31, 100);
    GivePlayerWeapon(opponent, 24, 50);
    GivePlayerWeapon(opponent, 31, 100);

    DuelActive[playerid] = 1;
    DuelActive[opponent] = 1;

    SendClientMessage(playerid, -1, "* Дуэль началась!");
    SendClientMessage(opponent, -1, "Дуэль началась!");
    return 1;
}
cmd:take_duck(playerid)
{
	for(new i; i < 6; i++)
	{
				if(IsPlayerInRangeOfPoint(playerid, 3.5, -164.471,2519.11,-0.20415))
				{
					Dialog(playerid, DIALOG_DUCK, DIALOG_STYLE_MSGBOX, "Охота на уток", "Вы действительно хотите взять мёртвую утку?", "Да", "Нет");
				}
				if(IsPlayerInRangeOfPoint(playerid, 13.5, -136.487, 2502.84, -0.1893))
				{
					Dialog(playerid, DIALOG_DUCK, DIALOG_STYLE_MSGBOX, "Охота на уток", "Вы действительно хотите взять мёртвую утку?", "Да", "Нет");
				}
				if(IsPlayerInRangeOfPoint(playerid, 3.5, -136.959,2514.65,-0.128582))
				{
					Dialog(playerid, DIALOG_DUCK, DIALOG_STYLE_MSGBOX, "Охота на уток", "Вы действительно хотите взять мёртвую утку?", "Да", "Нет");
				}
				if(IsPlayerInRangeOfPoint(playerid, 3.5, -154.598, 2525.09, -0.189611))
				{
					Dialog(playerid, DIALOG_DUCK, DIALOG_STYLE_MSGBOX, "Охота на уток", "Вы действительно хотите взять мёртвую утку?", "Да", "Нет");
				}
				if(IsPlayerInRangeOfPoint(playerid, 3.5, -145.975, 2463.3, -0.159682))
				{
					Dialog(playerid, DIALOG_DUCK, DIALOG_STYLE_MSGBOX, "Охота на уток", "Вы действительно хотите взять мёртвую утку?", "Да", "Нет");
				}
				if(IsPlayerInRangeOfPoint(playerid, 3.5, -137.928,2472.88, -0.082577))
				{
					Dialog(playerid, DIALOG_DUCK, DIALOG_STYLE_MSGBOX, "Охота на уток", "Вы действительно хотите взять мёртвую утку?", "Да", "Нет");
				}
	}
}
cmd:test_wheels(playerid, const params[])
{
	extract params -> new front_wheels_collapse, back_wheels_collapse, front_wheels_width, back_wheels_width, front_wheels_rise, back_wheels_rise; else
		return SendClientMessage(playerid, COLOR_GREY, "* Используйте: /test_wheels [front_wheels_collapse], [back_wheels_collapse], [front_wheels_width], [back_wheels_width], [front_wheels_rise], [back_wheels_rise]");

	new vehicleid = GetPlayerVehicleID(playerid);

	SetVehicleHandling(playerid, vehicleid, front_wheels_collapse, back_wheels_collapse, front_wheels_width, back_wheels_width, front_wheels_rise, back_wheels_rise);

	return 1;
}
cmd:spcars(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 5) return 1;

    SendClientMessageToAll(0xFAAC58FF, "Через 52 секунды произойдёт респавн незанятого транспорта! Успей занять свой транспорт");

    for(new i; i < MAX_PLAYERS; i++)
    {
        static fmt[500];
        format(fmt, sizeof fmt, "[\"РВС\",%d]", 52);
        MoralPacket_2(i, s_CefInterface, t_CefShow, "InformationTimer", fmt);
    }

    SetTimerEx("Rwsss", 52000, false, "i", playerid); 
    return true;
}
cmd:news(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) >= 8)
    {
        extract params -> new type, string:text[256];
        if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /news [Типы: 1 - Информация; 2 - Мероприятие] [текст]");

        static fmt_tt[128];

        if(type == 1) format(fmt_tt, sizeof fmt_tt, "interface('ScreenNotification').add('[1, \"Информация\", \"%s\", \"F1FF1F\", 10000]')", text);
        else if(type == 2) format(fmt_tt, sizeof fmt_tt, "interface('ScreenNotification').add('[1, \"Мероприятие\", \"%s\", \"F1FF1F\", 10000]')", text);
        else SCM(playerid, 0xCECECEFF, "* Типы: 1 - Информация; 2 - Мероприятие");
        foreach(new i: Player)
        {
            MoralPacket_1(i, s_CefInterface, t_CefUpdate, fmt_tt);
            MoralPacket_1(i, s_CefInterface, t_CefUpdate, "playSound('sounds/easter/buy.mp3', 0, 1)");
        }
    }
    return 1;
}
cmd:carmusic(playerid)
{
	MusicCarPlayer(playerid);
}
cmd:admin_panel(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	Dialog
	(
		playerid, DIALOG_ADMIN_PANEL, DIALOG_STYLE_LIST,
		"{FFD83D}Панель управления",
		"\
		1. {FFFFFF}Список - {FF0000}администраторов\n\
		2. {FFFFFF}Список - {FF0000}лидеров\n\
		3. {FFFFFF}Бейджик - {FF0000}для администраторы - [Над ником]\n\
		",
		"Выбрать", "Отменить"
	);
	Dialog
	(
		playerid, DIALOG_ADMIN_PANEL, DIALOG_STYLE_LIST,
		"{FFD83D}Панель управления",
		"\
		1. {FFFF00}Список - {FF0000}администраторов\n\
		2. {FFFF00}Список - {FF0000}лидеров\n\
		3. {FFFF00}Бейджик - {FF0000}для администраторы - [Над ником]\n\
		4. {FFFF00}Респавн - {FF0000}всех машин на сервере\n\
		5. {FFFF00}Список - {FF0000}администраторов с максимальным доступом",
		"Выбрать", "Отменить"
	);
	return 1;
}

cmd:adminstage(playerid)
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
    if(!IsPlayerInAnyVehicle(playerid))
     return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться в транспорте");
    new vehicleid = GetPlayerVehicleID(playerid);
	SetVehicleHandling(playerid, vehicleid, 900);
	return 1;
}

cmd:fixcar(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться в транспорте");

    if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 500000))
        return SCM(playerid, COLOR_GREY, "* Недостаточно средств.");

    new vehicleid = GetPlayerVehicleID(playerid);

    if(IsAOwnableCar(vehicleid))
        SetVehicleData(vehicleid, V_HEALTH, 1000.0);

    GivePlayerMoneyEx(playerid, -500000, "Починил транспорт");

    RepairVehicle(vehicleid);

    if(IsAOwnableCar(vehicleid))
        SetVehicleData(vehicleid, V_HEALTH, 1000.0);

    static fmt_msg[128];
    format(fmt_msg, sizeof(fmt_msg), "Транспорт №%d отремонтирован", vehicleid);
    SendClientMessage(playerid, 0xCECECEFF, fmt_msg);

    format(fmt_msg, sizeof(fmt_msg), "Игрок %s[%d] починил своё авто через /fixcar", GetPlayerNameEx(playerid), playerid);
    SendMessageToAdmins(fmt_msg, 0xFFFF00FF); 

    return 1;
}
cmd:contdel(playerid)
{
	for(new i; i < MAX_CONTAINERS; i++)
	{
		DellContainers(i);
	}
}
cmd:world_info(playerid, params[])
{
	static string[32];
	format(string, sizeof(string), "Ваш виртуальный мир: %d", GetPlayerVirtualWorld(playerid));
	SendClientMessage(playerid,0xFFFFFFFF,string);
	return 1;
}
cmd:getcamera(playerid)
{
	if(GetPlayerAdminEx(playerid) < 9) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	new
	Float:fPX, Float:fPY, Float:fPZ,
	Float:fVX, Float:fVY, Float:fVZ,
	Float:object_x, Float:object_y, Float:object_z;

	const
		Float:fScale = 5.0;

	GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
	GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);

	object_x = fPX + floatmul(fVX, fScale);
	object_y = fPY + floatmul(fVY, fScale);
	object_z = fPZ + floatmul(fVZ, fScale);

	printf("CameraPos: %f,%f,%f | LookAt: %f,%f,%f",fPX,fPY,fPZ,object_x,object_y,object_z);
	return 1;
}
cmd:reset_donate(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;

	extract params -> new to_player, cash; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /reset_donate [id игрока] [cумма]");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	static reason[144];
	format(reason, sizeof reason, "Обнуление доната админом %s", GetPlayerNameEx(playerid));
	GivePlayerDonate(to_player, -cash, reason, true, true);

	format(reason, sizeof reason, "Вы обнулили игроку %s %d доната", GetPlayerNameEx(to_player), cash);
	SendClientMessage(playerid, 0x66CC00FF, reason);

	return 1;
}

cmd:givefishki(playerid,params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	extract params -> new to_player, count; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givefishki [id игрока] [кол-во]");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");
	GiveIteam(to_player, 293, 1, count, 0);
	static reason[144];
	format(reason, sizeof reason, "Выдача денег от админа %s", GetPlayerNameEx(playerid));
	format(reason, sizeof reason, "Администратор %s выдал Вам %d фишек", GetPlayerNameEx(playerid), count);
	SendClientMessage(to_player, 0xFFFFFFFF, reason);
	return 1;
}
cmd:givefishkiall(playerid,params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	extract params -> new count; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givechip [кол-во]");
	for(new i = 0; i<MAX_PLAYERS; i++)
	{
		GiveIteam(i, 293, 1, count, 10);
		static reason[144];
		format(reason, sizeof reason, "Выдача денег от админа %s", GetPlayerNameEx(playerid));
		format(reason, sizeof reason, "Администратор %s выдал Вам %d фишек", GetPlayerNameEx(playerid), count);
		SendClientMessage(i, 0xFFFFFFFF, reason);
	}
	return 1;
}

cmd:frac_info(playerid)
{
    if(GetPlayerAdminEx(playerid) < 3) return 1;
    else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	static fmt_text[777];

	format
	(
		fmt_text, sizeof fmt_text,
		"{"#cGold"}Фракция\t\t\tОнлайн\tОбщий состав\n\n\
		{"#cW"}Правительство\t\t{"#cGold"}%d чел.\t\t{"#cGold"}%d чел.\n\
		{"#cW"}Министерство обороны\t\t\t{"#cGold"}%d чел.\t\t{"#cGold"}%d чел.\n\
		{"#cW"}Министерство Здравоохранения\t\t\t{"#cGold"}%d чел.\t\t{"#cGold"}%d чел.\n\
		{"#cW"}Радио Арзамас\t\t\t{"#cGold"}%d чел.\t\t{"#cGold"}%d чел.\n\
		{"#cW"}Дорожно-Патрульная Служба №1 [ДПС]\t\t{"#cGold"}%d чел.\t\t{"#cGold"}%d чел.\n\
		{"#cW"}Мин. Чрез. Ситуаций\t\t{"#cGold"}%d чел.\t\t{"#cGold"}%d чел.\n\n\
		{"#cW"}База Пела\t\t{"#cGold"}%d чел.\t\t{"#cGold"}%d чел.\n\
		{"#cW"}Русская Мафия\t\t{"#cGold"}%d чел.\t\t{"#cGold"}%d чел.\n\
		{"#cW"}Японская Мафия\t\t{"#cGold"}%d чел.\t\t{"#cGold"}%d чел.\n\
		{"#cW"}Итальянская Мафия\t\t{"#cGold"}%d чел.\t\t{"#cGold"}%d чел.",
		GetCountFracMembersOnline(1),
		GetCountFracMembers(1),
		GetCountFracMembersOnline(2),
		GetCountFracMembers(2),
		GetCountFracMembersOnline(3),
		GetCountFracMembers(3),
		GetCountFracMembersOnline(4),
		GetCountFracMembers(4),
		GetCountFracMembersOnline(5),
		GetCountFracMembers(5),
		GetCountFracMembersOnline(6),
		GetCountFracMembers(6),
		GetCountFracMembersOnline(7),
		GetCountFracMembers(7),
		GetCountFracMembersOnline(8),
		GetCountFracMembers(8),
		GetCountFracMembersOnline(9),
		GetCountFracMembers(9),
		GetCountFracMembersOnline(10),
		GetCountFracMembers(10)
	);

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{"#cGold"}Статистика организаций", fmt_text, "Закрыть", "");
	{
        format(fmt_text, sizeof fmt_text, "A: %s[%d] Смотрит информацию о фракциях", GetPlayerNameEx(playerid), playerid);
        SendMessageToAdmins(fmt_text, 0x999999FF);
    }

	return 1;
}
cmd:exitsto(playerid)
{
	if(gPlayerTuningMenu[playerid] == 1)
		{
			new sto_exit_1 = GetPVarInt(playerid, "sto_id_exit_1");
			new sto_exit_2 = GetPVarInt(playerid, "sto_id_exit_2");

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				new vehicleid = GetPlayerOwnableCarLast(playerid);

				TogglePlayerControllable(playerid, true);
				SetCameraBehindPlayer(playerid);

				SetVehiclePos(vehicleid, g_exit_sto_garage[sto_exit_1][sto_exit_2][0], g_exit_sto_garage[sto_exit_1][sto_exit_2][1], g_exit_sto_garage[sto_exit_1][sto_exit_2][2]);
				SetVehicleZAngle(vehicleid, g_exit_sto_garage[sto_exit_1][sto_exit_2][3]);

				UpdateStoGarage(sto_exit_1, sto_exit_2, 0);

				SetPVarInt(playerid, "sto_id_exit_1", 0);
				SetPVarInt(playerid, "sto_id_exit_2", 0);

				SetPlayerInterior(playerid, 0);

				gPlayerTuningMenu[playerid] = 0;

				SetVehicleVirtualWorld(vehicleid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				LinkVehicleToInterior(vehicleid, 0);
			}
			MoralPacket_1(playerid, s_CefInterface, t_CefHide, "TuningMenu");
		}
	return OnPlayerKeyStateChange(playerid, KEY_WALK, 0);
}
cmd:givesyndkey(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1)
		return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new to_player, count; else
		return SCM(playerid, 0xCECECEFF, "* Используйте: /givesyndkey [ид игрока] [кол-во]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SCM(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(count > 100 || count < 1)
		return SCM(playerid, 0xCECECEFF, "* Нельзя выдавать более 100 ключей или менее 1 ключа за раз!");

	AddPlayerData(to_player, P_NEWKEY, +, count);
	UpdatePlayerDatabaseInt(to_player, "newkey", GetPlayerData(to_player, P_NEWKEY)); 

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Администратор %s выдал Вам %d ключ(ей) от кейсов (у Вас теперь %d ключ(ей))", GetPlayerNameEx(playerid), count, GetPlayerData(to_player, P_NEWKEY));
	SendClientMessage(to_player, 0xFFFFFFFF, STRING_GLOBAL);

	
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] выдал ключи от кейсов %s[%d] в кол-ве %d шт (теперь у игрока %d ключ(ей))",
	GetPlayerNameEx(playerid), playerid,
	GetPlayerNameEx(to_player), to_player,
	count, GetPlayerData(to_player, P_NEWKEY));
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);

	return 1;
}
cmd:armour(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerYAdminEx(playerid) < 2) return 1;

	extract params -> new to_player, armour; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /armour [id игрока] [количество бронежилета]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	else if(GetPlayerAdminEx(playerid) == 1 && to_player != playerid)
		return SendClientMessage(playerid, 0x999999FF, "* Администраторам 1-го уровня доступно изменение только своего уровня бронежилета");

	else if(!(0 <= armour <= 100)) return SendClientMessage(playerid, 0x999999FF, "* Уровень бронежилета от 0 до 100");
	
	SetPlayerArmour(to_player, armour);

	static fmt_msg[105];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s изменил Вам уровень бронежилета", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, -1, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы изменили %s уровень бронежилета", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, -1, fmt_msg);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_msg, sizeof fmt_msg, "A: Администратор %s[%d] изменил уровень бронежилета %s[%d] на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, armour);
		SendMessageToAdmins(fmt_msg, 0x999999FF);
	}
	return 1;
}
cmd:armourall(playerid,params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	new Float:ps;

	if(sscanf(params, "fi", ps)) SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /armourall [радиус]");

	if(ps < 20 || ps > 100000) return SendClientMessage(playerid, 0xFF6600FF, "* Радиус от 20 до 100000");

	new Float:pos[3];

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	foreach(new i : Player)
	{
		if(!IsPlayerInRangeOfPoint(i, ps, pos[0], pos[1], pos[2])) continue;
		SetPlayerArmour(i, 100);
		SendClientMessage(i, COLOR_WHITE, "[Мероприятие] Администратор изменил Вам уровень здоровья");
	}

	SendClientMessage(playerid, COLOR_WHITE, "Вы успешно изменили HP игрокам в радиусе");

	return 1;
}
cmd:getadm(playerid, params[])
{
	extract params -> new to_player;
	SendClientMessage(playerid, 0xFFFFFFAA, "{2E8B57}[Информация]{FFFFFF} Вы успешно отправили запрос администрации. Ожидайте, в течении нескольких минут администратор телепортируется к Вам");

	if(GetPlayerAdminEx(playerid) <= 999)
	{
	static fmt_msg[260];
	format(fmt_msg, sizeof fmt_msg, "Игрок {7fff00}%s[%d] {FFFFFF}запрашивает связь с администрацией. Для телепорта - {7fff00}/goto [%d]", GetPlayerNameEx(playerid), playerid, playerid);
	SendMessageToAdmins(fmt_msg, -1);
	}
	return 1;
}

cmd:vmute(playerid, params[])
{
    static fmt_str[128];
	if(GetPlayerAdminEx(playerid) < 3) return 1;
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /vmute [id игрока] [время в минутах] [причина (необязательно)]");
    extract params -> new player;
	CallRemoteFunction("OnPlayerChangeStatusVoice", "ii", player, 0);
	format(fmt_str, sizeof fmt_str, "Выдал блокировку голосового чата игроку %s", GetPlayerNameEx(player));
	SendMessageToAdmins(fmt_str, 0x858585);
	return 1;

}
cmd:unvmute(playerid, params[])
{
	static fmt_str[128];
	if(GetPlayerAdminEx(playerid) < 3) return 1;
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /unvmute [id игрока]");
	extract params -> new player;
	CallRemoteFunction("OnPlayerChangeStatusVoice", "ii", player, 0);
	format(fmt_str, sizeof fmt_str, "Убрал блокировку голосового чата игроку %s", GetPlayerNameEx(player));
	SendMessageToAdmins(fmt_str, 0x858585);
	return 1;
}
cmd:alt(playerid)
{
	return OnPlayerKeyStateChange(playerid, KEY_WALK, 0);
}
cmd:stage(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 10, 258.8138,703.6974,11.9849) || IsPlayerInRangeOfPoint(playerid, 10, 2345.3701,-2610.1836,21.7953))
		{
			new vehicleid = GetPlayerVehicleID(playerid);
   			new md = GetVehicleData(vehicleid, V_MODELID);

			if(md == 424 || md == 461 || md == 462 || md == 463 || md == 468 || md == 471 || md == 481 || md == 510 || md == 521 || md == 522
			|| md == 581 || md == 586 || md == 15127 || md == 15129 || md == 15130 || md == 15132 || md == 15133 || md == 15134 || md == 15135 || md == 15136 || md == 15139 || md == 15245)
			return SCM(playerid, COLOR_GREY, "* Данный транспорт недоступен для установки stage.");

			if(GetVehicleHandlingID(md) == -1) return GameText(playerid, "~r~На данный транспорт невозможно установить stage", 3000, 1);

			new vehicleid1 = GetPlayerOwnableCarLast(playerid);
			if(vehicleid1 != GetPlayerVehicleID(playerid)) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в личном транспорте");

			foreach(new i: Player){
				if(i == playerid) continue;
				if(IsPlayerInVehicle(i, vehicleid)) return SendClientMessage(playerid, 0x3399FFFF, "* Вы не можете заехать сюда пока в нём кто-то сидит");
				break;
			}
			MoralPacket_2(playerid, s_CefInterface, t_CefShow, "TuningStage", "[[70,1.350000],[[\"Уровень 1\",7000000,10,10.000000],[\"Уровень 2\",20000000,20,20.000000],[\"Уровень 3\",40000000,30,30.000000]]]");
			SpeedometrHideForPlayer(playerid);
			if(IsPlayerInRangeOfPoint(playerid, 10, 258.8138,703.6974,11.9849)) stagest[playerid] = 2;
			if(IsPlayerInRangeOfPoint(playerid, 10, 2345.3701,-2610.1836,21.7953)) stagest[playerid] = 1;
			SetVehiclePos(vehicleid, 2339.8787,-2612.8870,1002.2754);
			SetVehicleZAngle(vehicleid, 0);
			TogglePlayerControllable(playerid, 0);
			stagestats[playerid] = 1;
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, playerid + 1);

			LinkVehicleToInterior(vehicleid, 0);
			SetVehicleVirtualWorld(vehicleid, playerid + 1);

			SetPlayerCameraPos(playerid,2342.3635,-2606.8323,1002.6982);
			SetPlayerCameraLookAt(playerid,2339.8787,-2611.8870,1002.2754);
		}
	return OnPlayerKeyStateChange(playerid, KEY_WALK, 0);
}
cmd:space(playerid)
{
	return OnPlayerKeyStateChange(playerid, KEY_JUMP, 0);
}
cmd:pnewma(playerid)
{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, -397.3741,1009.9180,12.1382))
	    {
			if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в транспорте");

			new vehicleid = GetPlayerVehicleID(playerid);
			new vehicleid1 = GetPlayerOwnableCarLast(playerid);
			new index = GetVehicleData(vehicleid, V_ACTION_ID);

			if(vehicleid1 != vehicleid) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в личном транспорте");

			SetVehiclePos(vehicleid, -313.3054,355.2758,12.9868);
			SetVehicleZAngle(vehicleid, 169.9994);

			SetPlayerCameraPos(playerid,-311.7177,348.9213,14.1133);
			SetPlayerCameraLookAt(playerid,-313.3054,355.2758,12.9868);

			SetPlayerVirtualWorld(playerid, playerid + 1);
			SetVehicleVirtualWorld(vehicleid, playerid + 1);

			if(GetOwnableCarData(index, OC_PNEWMA) == 0) MoralPacket_2(playerid, s_CefInterface, t_CefShow, "TuningPneuma", "[0, [100000000]]");
			else MoralPacket_2(playerid, s_CefInterface, t_CefShow, "TuningPneuma", "[1]");
		}
		return OnPlayerKeyStateChange(playerid, KEY_WALK, 0);
}

cmd:sto(playerid)
{
	for(new i; i < sizeof g_load_sto_garage; i++)
		{
			for(new idx; idx < 4; idx++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 5.0, g_load_sto_garage[i][idx][0], g_load_sto_garage[i][idx][1], g_load_sto_garage[i][idx][2]))
				{
					if(sto_garage_status[i][idx] == 1) return SCM(playerid, COLOR_GREY, "* Данный гараж используется игроком.");

					new vehicleid = GetPlayerVehicleID(playerid);

					new vehicleid1 = GetPlayerOwnableCarLast(playerid);

					if(vehicleid1 != GetPlayerVehicleID(playerid))
						return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в личном транспорте");

					foreach(new idxx: Player)
					{
						if(!IsPlayerConnected(idxx)) continue;
						if(!IsPlayerLogged(idxx)) continue;
						if(idxx == playerid) continue;
						if(IsPlayerInVehicle(idxx, vehicleid)) return SendClientMessage(playerid, 0x3399FFFF, "* Вы не можете заехать сюда пока в нём кто-то сидит");
						break;
					}

					SetVehiclePos(vehicleid, -2498.8906, -597.7437, 1001.0588);
					GameText(playerid,"~n~~p~MOBILE: /exitsto(ВЫЕЗД ИЗ СТО)",10000,0);
					SetVehicleZAngle(vehicleid, 89.6331);
					TogglePlayerControllable(playerid, 0);

					SetPlayerInterior(playerid, 4);
					SetPlayerVirtualWorld(playerid, playerid + 1);

					LinkVehicleToInterior(vehicleid, 4);
					SetVehicleVirtualWorld(vehicleid, playerid + 1);

					SetPlayerCameraPos(playerid, -2502.4258, -601.2964, 1004.5900);
					SetPlayerCameraLookAt(playerid, -2498.8938, -597.7574, 1001.0900);

					UpdateStoGarage(i, idx, 1);

					SetPVarInt(playerid, "sto_id", GetNearestBusiness(playerid, 50.0));
					SetPVarInt(playerid, "sto_id_exit_1", i);
					SetPVarInt(playerid, "sto_id_exit_2", idx);
					SetPVarInt(playerid, "cl1", 1);
					SetPVarInt(playerid, "diski", -1);
					SetPVarInt(playerid, "vinil", -2);
					SetPVarInt(playerid, "color_id", -1);
					SetPVarInt(playerid, "color_id1", -1);

					gPlayerTuningMenu[playerid] = 1;

					MoralPacket_2(playerid, s_CefInterface, t_CefShow, "TuningMenu", "[11298, []]");
					MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "interface('TuningMenu').setItems('[3500, -1, -1]')");
					break;
				}
			}
		}
	return OnPlayerKeyStateChange(playerid, KEY_WALK, 0);
}
cmd:setvehnumber(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    extract params -> new vehicleid, plateType, string:number[150], string:region[150]; else return SendClientMessage(playerid, 0xCECECEFF, "* Use: /setvehnumber [vehicle id] [type] [number] [region]");
    SetVehicleNumber(vehicleid, plateType, number, region);

	SendPacket_Plate(playerid, vehicleid, plateType, number , region);

	new index = GetVehicleData(vehicleid, V_ACTION_ID);

	SetOwnableCarData(index, OC_NUMBERTYPE, plateType);

	format(g_ownable_car[index][OC_NUMBER], 10, number);
	format(g_ownable_car[index][OC_REGION], 10, region);
	SetVehicleNumber(vehicleid, plateType, number, region);

	SendPacket_Plate(playerid, vehicleid, plateType, number, region);

	static fmt_text[144];
	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET number='%s', region='%s', typenumber='%d' WHERE id=%d LIMIT 1", GetOwnableCarData(index, OC_NUMBER), GetOwnableCarData(index, OC_REGION), plateType, GetOwnableCarData(index, OC_SQL_ID));
	mysql_query(mysql, fmt_text, false);

    return 1;
}
cmd:market(playerid) return LoadMarket(playerid,3,1);
cmd:neon(playerid)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
     	SendClientMessage(playerid,COLOR_RED,"Вы должны находиться в транспортном средстве!");
  	 	return true;
    }
	Dialog
	(
		playerid, neondialog, DIALOG_STYLE_LIST,
		"{FFFF00}Меню неона",
		"1. Голубой неон\n"\
		"2. Красный неон\n"\
		"3. Зелёный неон\n"\
		"4. Белый неон\n"\
		"5. Розовый неон\n"\
		"6. Жёлтый неон\n"\
		"7. Удалить неон",
		"Выбрать", "Закрыть"
	);
	return 1;
}
cmd:battlepas(playerid, params[]) //ВРЕМЯ БАТЛ
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false) return 1;

	if(GetPlayerData(playerid, P_BUYADMIN) == 1)
		return SCM(playerid, 0x999999FF, "Покупным администраторам недоступна данная функция");

    new days, hours;
    if(sscanf(params, "dd", days, hours) || days < 0 || hours < 0 || hours >= 24)
        return SendClientMessage(playerid, COLOR_LIGHTRED, "Использование: /battlepass_settime [дней] [часов]");

    new totalSeconds = (days * 86400) + (hours * 3600);
    new timestamp = gettime() + totalSeconds;

    static query[128];
    format(query, sizeof(query), "UPDATE server_config SET time_battlepass = %d", timestamp);
    mysql_tquery(mysql, query, "LoadBattlePassTimer", "");

    static msg[96];
    format(msg, sizeof(msg), "Время окончания BattlePass установлено на %d дней и %d часов вперёд.", days, hours);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}
cmd:buypack1(playerid)
{
	Pack1(playerid);
}
cmd:buypack2(playerid)
{
	Pack2(playerid);
}
cmd:buypack3(playerid)
{
	Pack3(playerid);
}
cmd:forbes(playerid)
{
	Dialog
	(
		playerid, DIALOG_FORBES_TYPE, DIALOG_STYLE_LIST,
		"Выберите категорию топ-игроков",
		"1. Деньги\n"\
		"2. Уровень",
		"Выбрать", "Закрыть"
	);
}
cmd:end(playerid)
{
	if(GetPlayerTempJob(playerid) == TEMP_JOB_INKAS)

	PlayerIsInkasator[playerid]=0;
	new vehicleid = GetPlayerVehicleID(playerid);
	RemovePlayerFromVehicle(playerid);
	SetVehicleToRespawn(vehicleid);
	SetPlayerData(playerid, P_JOB_CAR, INVALID_VEHICLE_ID);
	ResetPlayerWeapons(playerid);
	SetPlayerArmour(playerid, 0);
	EndPlayerTempJob(playerid, TEMP_JOB_INKAS);
	return 1;
}
cmd:bankmenu(playerid, params[])
{
    if (
        IsPlayerInRangeOfPoint(playerid, 2.0, 300.5571, 304.2417, 1001.0000) ||
        IsPlayerInRangeOfPoint(playerid, 2.0, 294.5605, 304.2592, 1001.0000) ||
        IsPlayerInRangeOfPoint(playerid, 2.0, 418.3971, 572.8312, -36.6100) ||
        IsPlayerInRangeOfPoint(playerid, 2.0, 412.5228, 574.4662, -36.6100)
    )
    {
        ShowPlayerPayForRentDialog(playerid);
    }
    else
    {
        SendClientMessage(playerid, -1, "* Вы должны находиться в банке, чтобы использовать эту команду.");
    }
    return true;
}
cmd:coins(playerid) return callcmd::donatemenu(playerid);
cmd:rub(playerid) return callcmd::donatemenu(playerid);
cmd:adm(playerid) return callcmd::donatemenu(playerid);
cmd:donat(playerid) return callcmd::donatemenu(playerid);
cmd:donatmenu(playerid) return callcmd::donatemenu(playerid);
cmd:mcoins(playerid) return callcmd::donatemenu(playerid);
cmd:donatemenu(playerid)
{
	static string[256];
	format
	(
		string, sizeof(string),
		"{FFFFFF}1. %s | Баланс: {33CC66}%d {FFFFFF}%s\n{FFCD00}Информация о покупке коинов",
		SERVER_COINS_NAME,
		GetPlayerCoins(playerid),
		SERVER_COINS_NAME
	);

	Dialog
	(
		playerid, DIALOG_OPEN_MENU, DIALOG_STYLE_LIST,
		"ВЫБОР МАГАЗИНА",
		string,
		"Далее", "Закрыть"
	);

	return true;
}
cmd:createcoinsitem(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	    else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	g_donate_create[playerid][DC_TYPE] = 0;
	g_donate_create[playerid][DC_ITEM_ID] = 0;
	g_donate_create[playerid][DC_PRICE] = 0;
	g_donate_create[playerid][DC_COUNT] = 1;
	g_donate_create[playerid][DC_INDX] = 0;

	Dialog(playerid, DIALOG_CREATE_DONATE_1, DIALOG_STYLE_LIST,"{FFCD00}Создание предмета в меню "SERVER_COINS_NAME"","{AFAFAF}Выберите тип предмета\n{FFFFFF}Транспорт\nОдежда\nАксессуар\nПредмет", "Выбрать", "Закрыть");
	return 1;
}
cmd:givecoins(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new to_player, donate; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givecoins [id игрока] [cумма]");
	
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(!(-100000000 <= donate <= 100_000_000)) return SendClientMessage(playerid, 0xCECECEFF, "* Можно выдавать от 1 до 100.000.000 "SERVER_COINS_NAME" за один раз");

	static reason[144];
	
	GivePlayerCoins(to_player, donate);
	if(donate > 0) DLGF(to_player, -1, DIALOG_STYLE_MSGBOX, "Пополнение баланса", "{FFFF00}Ваш баланс успешно пополнен на %d "SERVER_COINS_NAME".", "Закрыть", "", donate);
	format(reason, sizeof reason, "Администратор %s[%d] выдал %d "SERVER_COINS_NAME" игроку %s[%d], в итоге у игрока %d "SERVER_COINS_NAME"", GetPlayerNameEx(playerid), playerid, donate, GetPlayerNameEx(to_player), to_player, GetPlayerCoins(to_player));
	SendMessageToAdmins(reason, COLOR_GREY);

	SCMF(to_player, COLOR_GREY, "* Администратор %s[%d] выдал вам %d "SERVER_COINS_NAME", в итоге у вас %d "SERVER_COINS_NAME"", GetPlayerNameEx(playerid), playerid, donate, GetPlayerCoins(to_player));

	return 1;
}
cmd:bugreport(playerid)
{
	Dialog
	(
		playerid, DIALOG_BUG_REPORT, DIALOG_STYLE_INPUT,
		"{FFD83D}Связь с разработчиком",
		"{FFFFFF}Введите свое сообщение для {FAAC58}разработчика проекта{FFFFFF}.\n"\
		"{FFFFFF}Оно должно быть {FAAC58}подробным{FFFFFF} и {FAAC58}ясным{FFFFFF}.\n\n"\
		"{FAAC58}Внимание! {FFFFFF}После рассмотрения вашей проблемы, вы можете\n"\
		"{FFFFFF}получить {FAAC58}бонус {FFFFFF}если ваше сообщение принесет пользу.\n"\
		"{FAAC58}(вам придет уведомление на аккаунт)",
		"Отправить", "Закрыть"
	);

	return true;
}

cmd:bugreportlist(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	page_cars[playerid] = 1;
	type_page_cars[playerid] = 16;
	ShowBugReportList(playerid, 1);

	return true;
}
cmd:plist(playerid)
{
    string_dialog = "Промокод\tНаграда\tДоступность\tДо выполнения\n";
    for(new i, count; i < MAX_PROMOCODE_ACTIVATION; i ++)
	{
		if(GetPlayerPromo(i, PA_OWNER_ID) != GetPlayerAccountID(playerid)) continue;

        static query[124];

        if(GetPlayerPromo(i, PA_TIME) > 3600) format(query, sizeof query, "{ffffff}%s\tПредмет\tбез ограничений\t{d8d0ab}%2d часов\n", GetPlayerPromo(i, PA_NAME), GetPlayerPromo(i, PA_TIME) / 3600);
        else if(GetPlayerPromo(i, PA_TIME) > 60) format(query, sizeof query, "{ffffff}%s\tПредмет\tбез ограничений\t{d8d0ab}%2d минут\n", GetPlayerPromo(i, PA_NAME), GetPlayerPromo(i, PA_TIME) / 60);
        else if(GetPlayerPromo(i, PA_TIME) > 0) format(query, sizeof query, "{ffffff}%s\tПредмет\tбез ограничений\t{d8d0ab}%d секунд\n", GetPlayerPromo(i, PA_NAME), GetPlayerPromo(i, PA_TIME));
        else format(query, sizeof query, "{ffffff}%s\tПредмет\tбез ограничений\t{d8d0ab}готов к получению\n", GetPlayerPromo(i, PA_NAME));
        strcat(string_dialog, query);
        
        SetPlayerListitemValue(playerid, count ++, i);
    }
    Dialog(playerid, DIALOG_PROMO_LIST, DIALOG_STYLE_TABLIST_HEADERS,"{FFFFFF}Активированные промокоды",string_dialog,"", "Закрыть", 0, 0, "Нажмите на выполненный промокод для получения награды");

    return true;
}
cmd:hangl(playerid, params[]) callcmd::sethandling(playerid, params);
cmd:sethandling(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)  && GetPlayerData(playerid, P_SONYC) == 0) return 1;
	else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

    extract params -> new model; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /sethandling [id handling`a]");

    if(!IsPlayerInAnyVehicle(playerid))
			return SendClientMessage(playerid, 0x999999FF, "* Вы должены находиться в транспорте");

    new vehicleid = GetPlayerVehicleID(playerid);

    SetVehicleHandling(playerid, vehicleid, model, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

    return 1;
}
cmd:craft(playerid)
{
	static query[364],
		fmt_text[364];

	STRING_GLOBAL[0] = EOS;
	for(new i; i < sizeof g_craft_prize; i++)
	{
		fmt_text = "";
		for(new idx; idx < sizeof g_craft_details; idx++)
		{
			if(i != g_craft_details[idx][CRAFT_DETAILS_ID]) continue;

			if(g_craft_details[idx][CRAFT_DETAILS_TYPE] == 0)
			{
				if(g_craft_details[idx][CRAFT_DETAILS_ITEM_ID] <= sizeof ItemsInfo)
				{
					format
					(
						query, sizeof query, "[%d,%d,%d,%d],",
						g_craft_details[idx][CRAFT_DETAILS_TYPE],
						g_craft_details[idx][CRAFT_DETAILS_ITEM_ID],
						g_craft_details[idx][CRAFT_DETAILS_COUNT],
						GetIteam(playerid, g_craft_details[idx][CRAFT_DETAILS_ITEM_ID])
					);
				}
				else
				{
					format
					(
						query, sizeof query, "[%d,%d,%d,%d],",
						g_craft_details[idx][CRAFT_DETAILS_TYPE],
						g_craft_details[idx][CRAFT_DETAILS_ITEM_ID],
						g_craft_details[idx][CRAFT_DETAILS_COUNT],
						GetCar(playerid, g_craft_details[idx][CRAFT_DETAILS_ITEM_ID])
					);
				}
				strcat(fmt_text, query);
			}
			if(g_craft_details[idx][CRAFT_DETAILS_TYPE] == 3)
			{
				
				format
				(
					query, sizeof query, "[%d,%d,%d,%d,\"%s\"],",
					g_craft_details[idx][CRAFT_DETAILS_TYPE],
					g_craft_details[idx][CRAFT_DETAILS_ITEM_ID],
					g_craft_details[idx][CRAFT_DETAILS_COUNT],
					GetAcs(playerid, g_craft_details[idx][CRAFT_DETAILS_ITEM_ID]),
					g_craft_details[idx][CRAFT_DETAILS_NAME]
				);
				strcat(fmt_text, query);
			}
			if(g_craft_details[idx][CRAFT_DETAILS_TYPE] == 1)
			{
				format
				(
					query, sizeof query, "[%d,%d,%d,%d],",
					g_craft_details[idx][CRAFT_DETAILS_TYPE],
					g_craft_details[idx][CRAFT_DETAILS_ITEM_ID],
					g_craft_details[idx][CRAFT_DETAILS_COUNT],
					GetSkin(playerid, g_craft_details[idx][CRAFT_DETAILS_ITEM_ID])
				);
				strcat(fmt_text, query);
			}
		}
		new str_len = strlen(fmt_text);
		strdel(fmt_text, str_len - 1, str_len);

		format
		(
			query, sizeof query, "[%d,%d,%d,\"%s\",%d,%d,%d,%d,[%s]],",
			g_craft_prize[i][CRAFT_PRIZE_ID], 
			g_craft_prize[i][CRAFT_PRIZE_EVENT], 
			g_craft_prize[i][CRAFT_PRIZE_ITEM_ID], 
			g_craft_prize[i][CRAFT_PRIZE_NAME],
			g_craft_prize[i][CRAFT_PRIZE_TYPE],
			g_craft_prize[i][CRAFT_PRIZE_IF],
			g_craft_prize[i][CRAFT_PRIZE_CHANCE],
			g_craft_prize[i][CRAFT_PRIZE_PRICE],
			fmt_text
		);
		strcat(STRING_GLOBAL, query);
	}
	new str_len = strlen(STRING_GLOBAL);
	strdel(STRING_GLOBAL, str_len - 1, str_len);

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[3000,[%s]]", STRING_GLOBAL);
	MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Craft", STRING_GLOBAL);

	return true;
}
cmd:auction(playerid)
{
    if(!IsPlayerInRangeOfPoint(playerid, 50.0, -137.6529,2426.3170,1001.2500)) return true;
    
    page_auction[playerid] = 1;
    event_auction[playerid] = 0;
    pred_auction[playerid][0] = 1;
	pred_auction[playerid][1] = 4;
    
    static query[348], 
		rowss,
        count_item = GetIteam(playerid, 293);

	STRING_GLOBAL[0] = EOS;

    for(new i; i < MAX_AUCTION; i++)
    {
        if(GetAuctionData(i, A_SQL_ID) == 0) continue;
        if(GetAuctionData(i, A_TYPE) != 0) continue;

        rowss++;

        if(1 <= rowss <= 4)
		{
            new id = GetAuctionData(i, A_SQL_ID);
            new id_im = GetAuctionData(i, A_ID_IM);
            new stavka = GetAuctionData(i, A_BET);

            new bet = GetPlayerAuctionBet(playerid, id);
            
            format(query, sizeof query, "[%d,0,\"Жильё\",\"Дом (№ %d)\",\"ГОСУДАРСТВО\",%d,%d,%d,[\"-\", \"-\", \"-\"],0,%d],", i, id_im, stavka, count_item, bet, (stavka + (stavka / 100 * 10)) - bet);

            strcat(STRING_GLOBAL, query);
        }
    }

	new str_len;
	str_len = strlen(STRING_GLOBAL);
	strdel(STRING_GLOBAL, str_len - 1, str_len);

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[[%s],%d]", STRING_GLOBAL, page_auction[playerid]);
	MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Auction", STRING_GLOBAL);

    GameText(playerid, "Аукцион принимает только~n~~r~фишки", 3000, 1);

    open_auction[playerid] = 1;

    return true;
}

cmd:auction_slot(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

    if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


 	extract params -> new to_player, slots; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /auction_slot [id игрока] [кол-во слотов]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!(1 <= slots <= 15)) return SendClientMessage(playerid, 0xCECECEFF, "* от 1 до 15");

	AddPlayerData(to_player, P_AUCTION_SLOTS, +, slots);
	UpdatePlayerDatabaseInt(to_player, "auction_slots", GetPlayerData(to_player, P_AUCTION_SLOTS));

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "A: Администратор %s[%d] добавил игроку %s[%d] %d слотов для ставок в аукционе", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, slots);
	SendMessageToAdmins(STRING_GLOBAL, 0x999999FF);

	format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "A: Администратор %s[%d] добавил вам %d слотов для ставок в аукционе", GetPlayerNameEx(playerid), playerid, slots);
	SendClientMessage(to_player, -1, STRING_GLOBAL);

	return 1;
}

cmd:addauctionlot(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false) return true;

    if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


    extract params -> new id_im, stavka, type; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /addauctionlot [id имущества] [ставка] [тип имущества (0 - жилье | 1 - бизнес | 2 - гараж)]");

    if(type > 2 || 0 > type) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /addauctionlot [id имущества] [ставка] [тип имущества (0 - жилье | 1 - бизнес | 2 - гараж)]");

    if(type == 0)
    {
        if(IsHouseOwned(id_im)) return SCM(playerid, COLOR_GREY, "* Данный дом пренадлежит игроку.");
        if(GetOwnableAuction(0, GetHouseData(id_im, H_SQL_ID)) > 0) return SCM(playerid, COLOR_GREY, "*  Данный дом уже выставлен на аукцион");
        AddAuctionLot(id_im, stavka, type);
    }
    if(type == 1)
    {
        if(IsBusinessOwned(id_im)) return SCM(playerid, COLOR_GREY, "* Данный бизнес пренадлежит игроку.");
        if(GetOwnableAuction(1, GetBusinessData(id_im, B_SQL_ID)) > 0) return SCM(playerid, COLOR_GREY, "*  Данный бизнес уже выставлен на аукцион");
        AddAuctionLot(id_im, stavka, type);
    }
    if(type == 2)
    {
        if(IsGarageOwned(id_im)) return SCM(playerid, COLOR_GREY, "* Данный гараж пренадлежит игроку.");
        if(GetOwnableAuction(2, GetGarageData(id_im, G_SQL_ID)) > 0) return SCM(playerid, COLOR_GREY, "*  Данный гараж уже выставлен на аукцион");
        AddAuctionLot(id_im, stavka, type);
    }
    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] создал лот для аукциона (№%d)", GetPlayerNameEx(playerid), playerid, id_im);
	SendMessageToAdmins(STRING_GLOBAL, 0x999999FF);
    return true;
}
cmd:proslyshka(playerid)
{
	if(GetPlayerTeamEx(playerid) != 5) return 1;
 	Dialog(playerid, DIALOG_FEDERAL_PROSLYSH, DIALOG_STYLE_LIST, "Режим прослушивания фракций",
	"Активировать прослушку\n"\
	"Остановить прослушку",
	"Далее", "Отмена");
	return 1;
}
cmd:glush(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) 
		return SCM(playerid, COLOR_RED, "Для использования данной функции вы должны находиться в служебном Т/С");

	new vehicleid = GetPlayerVehicleID(playerid);
	new modelid = GetVehicleData(vehicleid, V_MODELID);

	if(modelid != 416 && modelid != 599) 
		return SCM(playerid, COLOR_RED, "Для использования данной функции вы должны находиться в служебном Т/С");

	Dialog(playerid, DIALOG_GLUSH, DIALOG_STYLE_LIST, 
	"Система подавления связи",
	"Активировать глушилку связи\nДеактивировать глушилку",
	"Выбрать", "Отмена");
	return 1;
}
cmd:lift(playerid, params[])
{
	new entranceid = GetPlayerInEntrance(playerid);
	if(entranceid != -1)
	{
		new floor = GetPlayerInEntranceFloor(playerid);
		if(floor != -1)
		{
			if(!floor)
			{
				if(!IsPlayerInRangeOfPoint(playerid, 1.5, 30.5405, 1403.6593, 1508.4163))
					return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться около лифта");
			}
			else
			{
				if(!IsPlayerInRangeOfPoint(playerid, 1.5, 11.1776, 1377.5216, 1508.4163))
					return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться около лифта");		
			}
			ShowPlayerEntranceFloorsLift(playerid, entranceid, floor);
		}
	}
	else SendClientMessage(playerid, 0xCECECEFF, "* Вы не в подъезде");
	
	return 1;
}


cmd:set_e_exit_pos(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;

	extract params -> new house_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /set_e_exit_pos [id подъезда]");

	if(!(0 <= house_id <= g_entrance_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "* Данного подъезда не существует на сервере");

	GetPlayerPos(playerid, g_entrance[house_id][E_EXIT_POS_X], g_entrance[house_id][E_EXIT_POS_Y], g_entrance[house_id][E_EXIT_POS_Z]);
	GetPlayerFacingAngle(playerid, g_entrance[house_id][E_EXIT_ANGLE]);

	static fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE entrances SET exit_x='%f', exit_y='%f', exit_z='%f', exit_angle='%f' WHERE id=%d",
		GetEntranceData(house_id, E_EXIT_POS_X),
		GetEntranceData(house_id, E_EXIT_POS_Y),
		GetEntranceData(house_id, E_EXIT_POS_Z),
		GetEntranceData(house_id, E_EXIT_ANGLE),
		GetEntranceData(house_id, E_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты выхода у подэезда №%d", house_id);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}
cmd:addenter(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;

	extract params -> new type, price, rent_price, enter; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /addenter [тип] [стоимость кв] [Ежедневаня плата] [Этажей]");

	static fmt_text[400];

	if(!(0 <= type <= sizeof g_house_type - 1))
	{
		SendClientMessage(playerid, 0x999999FF, "* Типы домов:");

		for(new i; i < sizeof g_house_type; i ++)
		{
			format(fmt_text, sizeof fmt_text, "%d. %s", i, GetHouseTypeInfo(i, HT_NAME));

			SendClientMessage(playerid, 0xCECECEFF, fmt_text);
		}

		return 1;
	}

	if(price < 1) return SendClientMessage(playerid, 0x999999FF, "* Стоимость дома не может быть меньше 1");

	if(rent_price < 1) return SendClientMessage(playerid, 0x999999FF, "* Стоимость ежедневной платы не может быть меньше 1");

	if(enter < 2 || enter > MAX_ENTRANCE_FLOORS) return SendClientMessage(playerid, 0x999999FF, "* Минимум 2 этажа. Максимум 5");

	new Cache: result,
		idx = g_entrance_loaded;

	GetPlayerPos(playerid, g_entrance[idx][E_POS_X], g_entrance[idx][E_POS_Y], g_entrance[idx][E_POS_Z]);

	new buffer[2];
	new idxs;

	buffer[0] = Get2DCity(GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y));
	buffer[1] = Get2DZone(GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y));

	SetEntranceData(idx, E_CITY,			buffer[0]);
	SetEntranceData(idx, E_ZONE,			buffer[1]);

	SetEntranceData(idx, E_FLOORS,			enter);

	format
	(
		fmt_text, sizeof fmt_text,
		"INSERT INTO entrances \
		(city, zone, floors, pos_x, pos_y, pos_z)\
		VALUES ('%d', '%d', '%d', '%f', '%f', '%f')",
		GetEntranceData(idx, E_CITY),
		GetEntranceData(idx, E_ZONE),
		enter,
		GetEntranceData(idx, E_POS_X),
		GetEntranceData(idx, E_POS_Y),
		GetEntranceData(idx, E_POS_Z)
	);

	result = mysql_query(mysql, fmt_text, true);

	SetEntranceData(idx, E_SQL_ID, 		cache_insert_id());

	cache_delete(result);

	g_entrance_loaded ++;

	new kv = 4 * enter;

	for(idxs = 0; idxs < kv; idxs ++)
	{
		format
		(
			fmt_text, sizeof fmt_text,
			"INSERT INTO houses \
			(city, zone, type, price, rent_price, x, y, z, entrance)\
			VALUES ('-1', '-1', '%d', '%d', '%d', '0.0', '0.0', '0.0', '%d')", type, price, rent_price, idx
		);
		mysql_query(mysql, fmt_text, true);
	}

	format(fmt_text, sizeof fmt_text, "%s[ID: %d] создал подъезд №%d (City - %s / [Zone - %s])", GetPlayerNameEx(playerid), playerid, idx, GetCityName(GetEntranceData(idx, E_CITY)), GetZoneName(GetEntranceData(idx, E_ZONE)));

	SendMessageToAdmins(fmt_text, 0x66CC33FF);
	SendClientMessage(playerid, 0x999999FF, "* Не забудьте поставить координаты выхода: {66CC33} /set_e_exit_pos");

	CreatePickup(19134, 23,GetEntranceData(idx, E_POS_X),GetEntranceData(idx, E_POS_Y),GetEntranceData(idx, E_POS_Z), -1);


	return 1;
}
cmd:setspawn(playerid, params[])
{
	SelectSpawn(playerid);
}
cmd:unmeshok(playerid, params[])
{
    extract params -> new to_player; else return SCM(playerid, 0xCECECEFF, !"Используйте: /unmeshok [ID игрока]");
    if(GetPlayerData(to_player, P_MESHOKK) == 0) return SCM(playerid, 0xFF6600FF, !"У данного игрока нет мешка");
    if(!(TEAM_MAFIA_RUSSIAN <= GetPlayerTeamEx(playerid) <= TEAM_MAFIA_ITALIAN))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SCM(playerid, 0xFF6600FF, !"Такого игрока нет");

	SetPlayerData(to_player, P_MESHOKK, 0);
    RemovePlayerAttachedObject(playerid, 3);
    new Float: x, Float: y, Float: z;
	GetPlayerPos(playerid, x, y, z);
	StopSpectatee(to_player);
	SetPlayerPos(to_player, -2625.7275,2181.0483,995.7933);
    GameText(to_player, "~g~С вас сняли мешок", 1000, 3);
    ClearAnimations(playerid);
    SetPlayerVirtualWorld(to_player, 0);
    SetPlayerInterior(to_player, 4);
    return 1;
}

cmd:meshok(playerid, params[])
{
    extract params -> new to_player; else return SCM(playerid, 0xCECECEFF, !"Используйте: /meshok [ID игрока]");
    if(GetPlayerData(to_player, P_MESHOKK) == 1) return SCM(playerid, 0xFF6600FF, !"У данного игрока уже надет мешок");
    if(GetPlayerData(to_player, P_OGLOX) == 0) return SCM(playerid, 0xFF6600FF, !"Данный игрок не оглушен");
    if(!(TEAM_MAFIA_RUSSIAN <= GetPlayerTeamEx(playerid) <= TEAM_MAFIA_ITALIAN))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SCM(playerid, 0xFF6600FF, !"Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SCM(playerid, 0xFF6600FF, !"Игрок находится слишком далеко");

	SetPlayerData(to_player, P_MESHOK, 1);
	UpdatePlayerDatabaseInt(to_player, "meshok", 1);
	SetPlayerData(to_player, P_MESHOKK, 1);
    SetPlayerAttachedObject(playerid, 3, 14350, 1);
    GameText(to_player, "~r~Вас положили в мешок", 1000, 3);
    ClearAnimations(playerid);
    MoralPacket_1(to_player, s_CefInterface, t_CefHide, "Stun");
	SetPlayerData(to_player, P_OGLOX, 0);

    return 1;
}

cmd:stune(playerid, params[])
{
    if(!(TEAM_MAFIA_RUSSIAN <= GetPlayerTeamEx(playerid) <= TEAM_MAFIA_ITALIAN))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");
	extract params -> new to_player; else return SCM(playerid, 0xCECECEFF, !"Используйте: /stune [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SCM(playerid, 0xFF6600FF, !"Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SCM(playerid, 0xFF6600FF, !"Игрок находится слишком далеко");

	SetPlayerData(to_player, P_OGLOX, 1);
	MoralPacket_1(to_player, s_CefInterface, t_CefShow, "Stun");
	//GivePlayerMoneyEx(playerid, -10000000, "");
	GameText(to_player, "~r~Вас Оглушили", 1000, 3);
	SendClientMessage(playerid, 0x999999FF, "* разбудить /stuneo!");
	ApplyAnimation(to_player, "CRACK","crckdeth2",4.0, false,1, 1, 1, 1);
	return 1;
}

cmd:stuneo(playerid, params[])
{
    if(!(TEAM_MAFIA_RUSSIAN <= GetPlayerTeamEx(playerid) <= TEAM_MAFIA_ITALIAN))
					return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");
	extract params -> new to_player; else return SCM(playerid, 0xCECECEFF, !"Используйте: /stuneo [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SCM(playerid, 0xFF6600FF, !"Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SCM(playerid, 0xFF6600FF, !"Игрок находится слишком далеко");

	MoralPacket_1(to_player, s_CefInterface, t_CefHide, "Stun");
	SetPlayerData(to_player, P_OGLOX, 0);
    GameText(to_player, "~g~Вас Разбудили", 1000, 3);
	ClearAnimations(playerid);
	return 1;
}

cmd:block(playerid)
{
    if(!IsPlayerInPoliceTeam(playerid))
        return SendClientMessage(playerid, -1, "");
    if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0)
        return SendClientMessage(playerid, -1, "* Нельзя стваить шипы в интерьере.");
    if(IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "* Нельзя ставить шипы, находясь в машине.");
    if(spike_objects[playerid] == 0)
    {
        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        SetPVarInt(playerid,"spikespawnn",1);
        SetPVarInt(playerid,"spikespawn",1);
        spike_objects[playerid] = CreateDynamicObject(2899, x, y+1.0, z-0.8, 0, 0, a+90);
        spike_areas[playerid] = CreateDynamicSphere(x, y+1.0, z, 3.0, -1, -1, -1);
        ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 1, 1);
        SendClientMessage(playerid, 0x0bda51FF, "Вы установили шипы.");
        SetPVarInt(playerid, "ship", 1);
        return SendClientMessage(playerid, 0x0bda51FF, "");
    }
    else
    {
        if(GetPVarInt(playerid,"spikespawnn") == 1)
		{
	        DestroyDynamicObject(spike_objects[playerid]);
	        spike_objects[playerid] = 0;
	        SetPVarInt(playerid,"spikespawn",0);
	        SetPVarInt(playerid,"spikespawnn",0);
	        DestroyDynamicArea(spike_areas[playerid]);
	        SetPVarInt(playerid, "ship", 0);
	        MoralPacket_2(playerid, s_CefInterface, t_CefHide, "Interactions","[[1, \"Убрать шипы\"]]");
	        return SendClientMessage(playerid, COLOR_GREY, "* Шипы дезактивированы.");
		}
    }
    return 1;
}
cmd:radar111111(playerid)
{
	if(!IsPlayerInPoliceTeam(playerid))
    	return SendClientMessage(playerid, -1, "");
    if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0)
    	return SendClientMessage(playerid, -1, "* Нельзя брать радар в интерьере.");
    if(IsPlayerInAnyVehicle(playerid))
    	return SendClientMessage(playerid, -1, "* Нельзя брать радар, находясь в машине.");
	{
	    SetPVarInt(playerid,"radarspawn",1);
		SetPVarInt(playerid,"radarspawnn",1);
		MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Interactions","[[1, \"Установить радар\"]]");
	    SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 14775, A_OBJECT_BONE_RIGHT_HAND, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0);
		return 1;
	}
}

cmd:alogin(playerid)
{
	if(!IsMantoKiss(playerid))
	{
		if(Iter_Contains(DmZonePlayers, playerid)) return 1;
	}
	if(GetPlayerAdminEx(playerid) < 1 && GetPlayerBuyAdminEx(playerid) < 1) return 1;
	if(admin_logged[playerid] == true) return 1;

	if(!strcmp(g_player[playerid][P_ADMIN_PASSWORD], "999999", true)) Dialog(playerid, DIALOG_ADMIN_CREATE, DIALOG_STYLE_PASSWORD,"{FFD83D}Система безопасности","{FFFFFF}Создайте свой личный пароль для авторизации как администратор","Далее", "Закрыть");
	else Dialog(playerid, DIALOG_ADMIN_PASS, DIALOG_STYLE_PASSWORD,"{FFD83D}Система безопасности","Вы пытаетесь авторизоваться как администратор.\nСистема безопасности запрашивает ввод пароля от админ-прав.\n\n{FFFFFF}Введите пароль:","Далее", "Закрыть");

	return 1;
}

cmd:radar22(playerid)
{
    if(!IsPlayerInPoliceTeam(playerid)) return 1;

    if(GetPVarInt(playerid,"radarspawn") == 1)
	{
		if(GetPVarInt(playerid,"radarspawnn") == 1)
		{
		    if(radar_objects[playerid] == 0)
		    {
		        new Float:x, Float:y, Float:z, Float:a;
		        GetPlayerPos(playerid, x, y, z);
		        GetPlayerFacingAngle(playerid, a);
		        radar_objects[playerid] = CreateDynamicObject(14775, x+0.8, y, z-1.0, 0, 0, a+180.0);
		        radar_objects1[playerid] = CreateDynamic3DTextLabel("{ffa500}Допустимая скорость \n {ffa500}До {FFFFFF}100 км/ч", 0xFFFFFFFF, x+0.8, y, z+0.3, 7.0);
		        radar_areas[playerid] = CreateDynamicSphere(x, y+1.5, z, 7.0, -1, -1, -1);
		        RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
		        ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
		        SendClientMessage(playerid, 0x0bda51FF, "Вы установили радар.");
		        SetPVarInt(playerid,"radarspawnn",0);
		        MoralPacket_2(playerid, s_CefInterface, t_CefHide, "Interactions","[[1, \"Установить радар\"]]");
		        return SendClientMessage(playerid, 0x0bda51FF, "Чтобы убрать радар, нужно подойти к нему.");
			}
		    else
		    {
		        if(GetPVarInt(playerid,"radarspawnnn") == 1)
				{
			        DestroyDynamicObject(radar_objects[playerid]);
			        DestroyDynamic3DTextLabel(radar_objects1[playerid]);
			        radar_objects[playerid] = 0;
			        DestroyDynamicArea(radar_areas[playerid]);
			        SetPVarInt(playerid,"radarspawn",0);
			        return SendClientMessage(playerid, COLOR_GREY, "* Вы убрали радар");
		    	}
			}
		}
	}
	return 1;
}

cmd:house_slot(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


 	extract params -> new to_player, slots; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /house_slot [id игрока] [кол-во слотов]");
	static string[148], str[148];
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!(0 <= slots <= 15)) return SendClientMessage(playerid, 0xCECECEFF, "* от 0 до 15");

	AddPlayerData(to_player, P_HOUSE_SLOTS, +, slots);
	UpdatePlayerDatabaseInt(to_player, "house_slots", GetPlayerData(to_player, P_HOUSE_SLOTS));

	format(string, sizeof(string), "A: Адмнистратор %s[%d] добавил игроку %s[%d] %d слотов под дом", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, slots);
	SendMessageToAdmins(string, 0xFFFF00FF);

	format(str, sizeof(str), "A: Адмнистратор %s[%d] добавил вам %d слотов под дом", GetPlayerNameEx(playerid), playerid, slots);
	SendClientMessage(to_player, -1, str);
	return 1;
}
cmd:garage_slot(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


 	extract params -> new to_player, slots; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /garage_slot [id игрока] [кол-во слотов]");
	static string[148], str[148];
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!(0 <= slots <= 15)) return SendClientMessage(playerid, 0xCECECEFF, "* от 0 до 15");

	AddPlayerData(to_player, P_GARAGE_SLOTS, +, slots);
	UpdatePlayerDatabaseInt(to_player, "garage_slots", GetPlayerData(to_player, P_GARAGE_SLOTS));

	format(string, sizeof(string), "A: Адмнистратор %s[%d] добавил игроку %s[%d] %d слотов под гараж", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, slots);
	SendMessageToAdmins(string, 0xFFFF00FF);

	format(str, sizeof(str), "A: Адмнистратор %s[%d] добавил вам %d слотов под гараж", GetPlayerNameEx(playerid), playerid, slots);
	SendClientMessage(to_player, -1, str);
	return 1;
}
cmd:biz_slot(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


 	extract params -> new to_player, slots; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /biz_slot [id игрока] [кол-во слотов]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!(0 <= slots <= 15)) return SendClientMessage(playerid, 0xCECECEFF, "* Уровень от 0 до 15");

	AddPlayerData(to_player, P_BIZ_SLOTS, +, slots);
	UpdatePlayerDatabaseInt(to_player, "biz_slots", GetPlayerData(to_player, P_BIZ_SLOTS));

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "A: Адмнистратор %s[%d] добавил игроку %s[%d] %d слотов под бизнес", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, slots);
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);

	format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "A: Адмнистратор %s[%d] добавил вам %d слотов под бизнес", GetPlayerNameEx(playerid), playerid, slots);
	SendClientMessage(to_player, -1, STRING_GLOBAL);

	return 1;
}

cmd:information(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 10) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new string: message[144 + 1];
	if(strfind(message,"|") != -1 || strfind(message,"&") != -1 || strfind(message,"#") != -1 || strfind(message,"@") != -1 || strfind(message,"%") != -1) return SCM(playerid, COLOR_RED, "* Хуй крашнешь сын потаскухи иди на нубо рп");
	
	foreach(new i : Player)
	{
		if(!IsPlayerLogged(i)) continue;

		STRING_GLOBAL[0] = EOS;
		format(STRING_GLOBAL, 82 + strlen(message), "interface('ScreenNotification').add('[1,\"Информация\",\"%s\",\"ffffff\",10000]')", message);
		MoralPacket_1(i, s_CefInterface, t_CefUpdate, STRING_GLOBAL);
	}
	return 1;
}


cmd:setfuels(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new amount; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setfuels [кол-во]");

	static fmt_text[90];

	if(!(0 <= amount <= 10000)) return SendClientMessage(playerid, 0x999999FF, "* Количество топлива от 0 до 10000");

	for(new i; i < g_business_loaded; i++)
	{
		if(GetBusinessData(i, B_TYPE) == 37)
		SetBusinessData(i, B_PRODS, amount);

		format(fmt_text, sizeof fmt_text, "UPDATE business SET products=%d WHERE id=%d", GetBusinessData(i, B_PRODS), GetBusinessData(i, B_SQL_ID));
		mysql_query(mysql, fmt_text, false);
	}
	format(fmt_text, sizeof fmt_text, "Вы установили %d топлива во всех АЗС", amount);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "A: %s[%d] установил %d топлива во всех АЗС", GetPlayerNameEx(playerid), playerid, amount);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}
cmd:add_tplist(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 8) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");


	extract params -> new string: name[24]; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /add_tplist [название точки]");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /add_tplist [название точки]");

    new Float:x, Float:y, Float:z, query[144];
	GetPlayerPos(playerid, x, y, z);
	
	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Вы создали точку телепорта %s", name);
	SCM(playerid, -1, STRING_GLOBAL);

	mysql_format(mysql, query, sizeof query, "INSERT INTO mytplist (owner_id, name, x, y, z) VALUES (%d,'%s',%f,%f,%f)", GetPlayerAccountID(playerid), name, x, y, z);
	mysql_query(mysql, query, false);
	return 1;
}

cmd:pj(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	
	 

	extract params -> new vehicleid, type, vinil; else return SendClientMessage(playerid, 0x999999FF, "* Используйте: /pj [id транспорта] [тип: 1 - Общие | 2 - индивидуальные] [id винила]");

	 

	if(!IsValidVehicle(vehicleid)) return SendClientMessage(playerid, 0xFF6600FF, "* Данного транспорта не существует на сервере");

    new index = GetVehicleData(vehicleid, V_ACTION_ID);

	if(type == 1) ChangeVehicleViniljob(vehicleid, vinil);
	if(type == 2) ChangeVehicleDefaultViniljob(vehicleid, vinil);

	SetOwnableCarData(index, OC_VINIL, vinil);
	
	static queryy[312];

	mysql_format(mysql, queryy, sizeof queryy, "UPDATE ownable_cars SET vinil=%d WHERE id=%d", vinil, GetOwnableCarData(index, OC_SQL_ID));
	mysql_query(mysql, queryy, false);

	SCMF(playerid, -1, "Вы установили винил {FFD83D}№%d {FFFFFF}транспорту {FFD83D}№%d", vinil, vehicleid);
	return 1;
}

cmd:gmx(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 12 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new type; else return SCM(playerid,-1,"Используйте: /gmx [1 - временный рестарт | 2 - мгновенный рестарт]");

	if(type == 1)
	{
		SendClientMessageToAll(COLOR_RED, "* {FF0000}Внимание!");
		SendClientMessageToAll(0xFAAC58FF, "Через 2 минут(ы) будет произведена перезагрузка сервера!");
		SendClientMessageToAll(COLOR_RED, "* {FF0000}Внимание!");
		SendClientMessageToAll(0xFAAC58FF, "Через 2 минут(ы) будет произведена перезагрузка сервера!");

		STRING_GLOBAL[0] = EOS;

		for(new i; i < MAX_PLAYERS; i++)
    	{
    	    static fmt[500];
    	    format(fmt, sizeof fmt, "[\"ДО ПЕРЕЗАПУСКА СЕРВЕРА\",%d]", 120);
    	    MoralPacket_2(i, s_CefInterface, t_CefShow, "InformationTimer", fmt);

			GameText(i, "~w~Сервер будет~r~перезагружен~n~в течении 2 минут", 4000, 0);
		}

		SetTimer("ServerRestart", 2000*60, false);
	}
	else ServerRestart();

	return 1;
}

cmd:selldebtorsproperty(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	SellDebtorsProperty();
	return 1;
}

cmd:givefish(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false) return true;

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


    extract params -> new to_player, count; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givefish [id игрока] [кол-во]");

    if(1 >= count >= 100_000) return SendClientMessage(playerid, 0xCECECEFF, "* Можно выдавать от 1 до 100.000 фишек за один раз");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Администратор %s[%d] выдал игроку %s[%d] %s фишек", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, formatInt(count));
    SendMessageToAdmins(STRING_GLOBAL, 0xFFFFFFFF);

    SCMF(to_player, -1, "Администратор %s[%d] выдал вам %s фишек", GetPlayerNameEx(playerid), playerid, formatInt(count));

    GiveIteam(to_player, 293, 1, count, 0, "Выдано администратором [А]");

    return true;
}

cmd:give_item(playerid, params[])
{
	return SCM(playerid, -1, "* Недоступно");
	/*if(GetPlayerLevel(playerid) < 3) return SendClientMessage(playerid, 0xFF6600FF, "* Этим можно пользоваться с 3 уровня");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /give_item [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(playerid == to_player) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не можете предлагать обмен самому себе");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(to_player, x, y, z);

	if(!IsPlayerInRangeOfPoint(playerid, 7.0, x, y, z)) return SendClientMessage(playerid, COLOR_GREY, "* Игрок должен находится радом с вами");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_GIVE_ITEM);

	return true;*/
}

cmd:yrangoff(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	extract params -> new string: name[21], lvl; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /yrangoff [ник игрока] [уровень]");

	if(!(0 <= lvl <= 3)) return SendClientMessage(playerid, 0xFF6600FF, "* Неверный идентификатор. Уровень от 0 до 3");

    static query[400];
    new Cache: result, user_id;

    mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE name='%e' LIMIT 1", name);
    result = mysql_query(mysql, query);

    if(cache_num_rows()) user_id = cache_get_field_content_int(0, "id");

    if(!cache_num_rows() || !user_id) return SendClientMessage(playerid, 0xFF6600FF, "* Аккаунт с таким именем не найден"), cache_delete(result);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s [%d] оффлайн назначил игрока %s ютубером %d уровня", GetPlayerNameEx(playerid), playerid, name, lvl);
    SendMessageToAdmins(STRING_GLOBAL, 0xCECECEFF);

    mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET yadmin=%d WHERE id=%d LIMIT 1", lvl, user_id);
    mysql_query(mysql, query, false);

	cache_delete(result);
    return 1;
}

cmd:createcode(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	    else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	for(new i; i < MAX_PRIZES_CODE; i++)
	{
		code_additionally[i] = 0;
		code_additionally_type[i] = 0;
		code_additionally_id[i] = 0;
		code_additionally_count[i] = 0;
	}

	Dialog(playerid, DIALOG_CREATE_CODE, DIALOG_STYLE_LIST,"{99cc00}Создание бонусных кодов","{FFFFFF}1. Промокод \t {999999}Активно\n{FFFFFF}2. Бонус-код \t {999999}Активно","Выбрать", "Закрыть");
	return 1;
}

cmd:return_items(playerid)
{
	for(new i; i < MAX_PLAYER_ITEMS; i++)
	{
		if(GetPlayerItem(i, PI_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
		if(GetPlayerItem(i, PI_RETURN_ITEMS) != 1) continue;

		if(GetInventorySlots(playerid) == -1) return GameText(playerid, "~r~В вашем инвентаре~n~нет свободного места", 3000, 2);

		new typeitem = GetPlayerItem(i, PI_TYPE_ITEM);
		new count = GetPlayerItem(i, PI_COUNT);

		new id = GetPlayerItem(i, PI_SQL_ID);

		if(GetPlayerItem(i, PI_RETURN_ITEMS) == 1)
		{
			if(typeitem == 0) SCMF(playerid, COLOR_GREEN, "Ваш товар: {FFFFFF}\"Предмет\" (%d ед.) {42B02C}снят с продажи владельцем киоска.", count);
			else if(typeitem == 1) SCM(playerid, COLOR_GREEN, "Ваш товар: {FFFFFF}\"Автомобильный номер\" (1 ед.) {42B02C}снят с продажи владельцем киоска.");
			else if(typeitem == 2) SCM(playerid, COLOR_GREEN, "Ваш товар: {FFFFFF}\"Аксессуар\" (1 ед.) {42B02C}снят с продажи владельцем киоска.");
			else if(typeitem == 3) SCM(playerid, COLOR_GREEN, "Ваш товар: {FFFFFF}\"Одежда\" (1 ед.) {42B02C}снят с продажи владельцем киоска.");
		}
	
		static query[365];
		format(query, sizeof query, "UPDATE items SET return_items=0, type=1, slots=%d WHERE id=%d", GetInventorySlots(playerid), id);
		mysql_query(mysql, query, false);

		SetPlayerItem(i, PI_SLOTS, GetInventorySlots(playerid));
		SetPlayerItem(i, PI_TYPE, 1);
		SetPlayerItem(i, PI_RETURN_ITEMS, 0);
	}

	return 1;
}

cmd:get_car_market(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 8) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new veh_id; else return SCM(playerid, 0xFFA500FF, "* Используйте: /get_car_market [vehid]");
	static fmt_str[128 + 1];
	format(fmt_str, sizeof fmt_str, "%s (%d) - %d", GetVehicleInfo(veh_id, VI_NAME), veh_id, GetCarMarket(veh_id));
	Dialog(playerid, 0, DIALOG_STYLE_LIST, "{FFA500}Количество в автосалоне", fmt_str, "Закрыть", "");

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] посмотрел количество модели [№%d] в автосалоне", GetPlayerNameEx(playerid), playerid, veh_id);
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);
	return 1;
}

cmd:set_car_market_all(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new count; else return SCM(playerid, COLOR_GREY, "* Используйте: /set_car_market_all [количество]");
	static query[32 + 1];
	mysql_format(mysql, query, sizeof query, "UPDATE car_market SET count=%d", count);
	mysql_query(mysql, query, false);

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] изменил количество всех моделей в автосалонах на %d шт.", GetPlayerNameEx(playerid), playerid, count);
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);
	return 1;
}

cmd:set_car_market(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new vehicleid, count; else return SCM(playerid, COLOR_GREY, "* Используйте: /set_car_market [id транспорта] [количество]");
	static query[52 + 1];
	mysql_format(mysql, query, sizeof query, "UPDATE car_market SET count=%d WHERE modelid=%d", count, vehicleid);
	mysql_query(mysql, query, false);

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] изменил количество модели [№%d] в автосалоне на %d шт.", GetPlayerNameEx(playerid), playerid, vehicleid, count);
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);
	return 1;
}

cmd:report(playerid, params[])
{
 	if(IsPlayerRMuted(playerid) > 0) return SCM(playerid, 0xFF6600FF, "* У Вас заблокирован доступ к репорту. Используйте: /time");

	if(GetPVarInt(playerid, "antifloodrep") > gettime())
        return SCMF(playerid, 0xFF6600FF, "* Вы недавно отправляли жалобу. Подождите %d {FF6600}сек.", GetPVarInt(playerid, "antifloodrep") - gettime());
	
    if(!strlen(params)) 
    {
        Dialog
        (
            playerid, DIALOG_REPORT_1, DIALOG_STYLE_INPUT,
            "{FFD83D}Связь с администрацией",
            "{FFFFFF}Введите свое сообщение для администрации сервера\n"\
            "{FFFFFF}Оно должно быть кратким и ясным\n\n"\
            "{99FF99}Если вы хотите подать жалобу на игрока,\n"\
            "{99FF99}обязательно укажите его ID и причину жалобу",
            "Отправить", "Назад"
        );
    }
    else
    {
        format(report_message[playerid], sizeof report_message, "%s", params);

        if(strfind(report_message[playerid], "%~%k%~%~SWITCH_DEBUG_CAM_ON%~") != -1 || strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
            return SCM(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
        
        if(strfind(report_message[playerid], "~k~~SWITCH_DEBUG_CAM_ON~") != -1 || strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
            return SCM(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
        
        if(strfind(report_message[playerid], "~k~~TAKE_SCREEN_SHOT~") != -1 || strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
            return SCM(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
        
        if(strfind(report_message[playerid], "%~%k%~%~SWITCH_DEBUG_CAM_ON%~") != -1 || strfind(report_message[playerid],"|") != -1 || strfind(report_message[playerid],"}") != -1 || strfind(report_message[playerid],"{") != -1 || strfind(report_message[playerid],"&") != -1 || strfind(report_message[playerid],"#") != -1 || strfind(report_message[playerid],"@") != -1 || strfind(report_message[playerid],"%") != -1)
            return SCM(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
        
        if(strfind(report_message[playerid],"%s") != -1) return SCM(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
        
        if(strfind(report_message[playerid],"%ss") != -1) return SCM(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
        
        Dialog(playerid, DIALOG_REPORT_2, DIALOG_STYLE_LIST, "Выберите действие", "1. Жалоба на игрока\n2. Задать вопрос", "Далее", "Закрыть");
    }
	return 1;
}
cmd:a_atinfo(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return 1;
	if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	extract params -> new to_player; else return SCM(playerid, COLOR_GREY, "* Используйте: /a_atinfo [id игрока]");

    new hour, minute,second, day, month, year,report,mute,jail,kick,warn,ban,query[144],time[6], 
		Cache: result;

    mysql_format(mysql, query, sizeof query, "SELECT * FROM action_log WHERE acc_id=%d", GetPlayerAccountID(to_player));
    result = mysql_query(mysql, query, true);

    new rows = cache_num_rows();

    gettime(hour, minute,second);
    getdate(year, month, day);

    if(rows)
    {
        for(new idx; idx < rows; idx ++)
        {
            timestamp_to_date(cache_get_field_content_int(idx, "time"), time[2], time[1], time[0], time[3], time[4], time[5]);
            if(time[0] == day)
            {
                new type = cache_get_field_content_int(idx, "type");
                if(type == 1) mute ++;
                if(type == 2) report ++;
                if(type == 3) jail++;
                if(type == 4) kick++;
                if(type == 5) warn++;
                if(type == 6) ban++;
             }
        }
    }
    cache_delete(result);

	string_dialog[0] = EOS;

    format
    (
        string_dialog, sizeof string_dialog,
        "{FFFFFF}Здесь отображается информация о выполненных действиях игрока\n\
		{FFFFFF}на посту администратора за этот день\n\n\
		{FAAC58}Название команды\tКоличество использований\n\
		{FFFFFF}/pm\t{FAAC58}%d (всего %d)\n\
        {FFFFFF}/jail\t{FAAC58}%d\n\
        {FFFFFF}/mute(/unmute)\t{FAAC58}%d\n\
        {FFFFFF}/kick\t{FAAC58}%d\n\
        {FFFFFF}/warn\t{FAAC58}%d\n\
        {FFFFFF}/ban\t{FAAC58}%d\n\n\
		{FFFFFF}Имя игрока\t{FAAC58}%s\n\
		{FFFFFF}Уровень администратора\t{FAAC58}%d ур.\n\
        {FFFFFF}Текущее время\t{FAAC58}%02d ч. %02d мин. %02d сек.\n\
        {FFFFFF}Текущая дата\t{FAAC58}%d %s %d г.",
        report, GetPlayerData(to_player, P_ADMREP), jail, mute, kick, warn, ban, GetPlayerNameEx(to_player), GetPlayerAdminEx(to_player), hour, minute, second, day, month_name[month-1], year
    );
    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Статистика администратора", string_dialog, "", "Закрыть");

	format(string_dialog, sizeof string_dialog, "A: Администратор %s[%d] посмотрел статистику /a_atinfo игрока %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player));
	SendMessageToAdmins(string_dialog, 0x999999FF);
    return 1;
}
cmd:atinfo(playerid)
{
	if(GetPlayerAdminEx(playerid) < 1 && GetPlayerBuyAdminEx(playerid) < 1) return 1;
	if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

    new hour, minute,second, day, month, year,report,mute,jail,kick,warn,ban,query[144],time[6], 
		Cache: result;

    mysql_format(mysql, query, sizeof query, "SELECT * FROM action_log WHERE acc_id=%d", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);

    new rows = cache_num_rows();

    gettime(hour, minute,second);
    getdate(year, month, day);

    if(rows)
    {
        for(new idx; idx < rows; idx ++)
        {
            timestamp_to_date(cache_get_field_content_int(idx, "time"), time[2], time[1], time[0], time[3], time[4], time[5]);
            if(time[0] == day)
            {
                new type = cache_get_field_content_int(idx, "type");
                if(type == 1) mute ++;
                if(type == 2) report ++;
                if(type == 3) jail++;
                if(type == 4) kick++;
                if(type == 5) warn++;
                if(type == 6) ban++;
             }
        }
    }
    cache_delete(result);

	string_dialog[0] = EOS;

    format
    (
        string_dialog, sizeof string_dialog,
        "{FFFFFF}Здесь отображается информация о ваших выполненных действиях\n\
		{FFFFFF}на посту администратора за этот день\n\n\
		{FAAC58}Название команды\tКоличество использований\n\
		{FFFFFF}/pm\t{FAAC58}%d (всего %d)\n\
        {FFFFFF}/jail\t{FAAC58}%d\n\
        {FFFFFF}/mute(/unmute)\t{FAAC58}%d\n\
        {FFFFFF}/kick\t{FAAC58}%d\n\
        {FFFFFF}/warn\t{FAAC58}%d\n\
        {FFFFFF}/ban\t{FAAC58}%d\n\n\
		{FFFFFF}Ваше имя\t{FAAC58}%s\n\
		{FFFFFF}Ваш уровень администратора\t{FAAC58}%d ур.\n\
        {FFFFFF}Текущее время\t{FAAC58}%02d ч. %02d мин. %02d сек.\n\
        {FFFFFF}Текущая дата\t{FAAC58}%d %s %d г.",
        report, GetPlayerData(playerid, P_ADMREP), jail, mute, kick, warn, ban, GetPlayerNameEx(playerid), GetPlayerAdminEx(playerid), hour, minute, second, day, month_name[month-1], year
    );
    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Статистика администратора", string_dialog, "", "Закрыть");

	format(string_dialog, sizeof string_dialog, "A: Администратор %s[%d] посмотрел информацию /atinfo", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(string_dialog, 0x999999FF);
    return 1;
}
cmd:pm(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1) return 1;
		else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	extract params -> new to_player, string: message[144 + 1]; else return SCM(playerid, 0xCECECEFF, "* Используйте: /pm [id игрока] [текст]");
	static fmt_str[128];

	if(!IsPlayerConnected(to_player)) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!strlen(message)) return SendClientMessage(playerid, 0x999999FF, "* Введите сообщение");

	if(GetString(GetPlayerNameEx(to_player), "R") || GetString(GetPlayerNameEx(to_player), "mrllwnsdev") || GetString(GetPlayerNameEx(to_player), "S"))
	{
	SendClientMessage(playerid, 0x999999FF, "* Вы не можете написать этому игроку.");
	SendClientMessage(playerid, 0x999999FF, "* За использование данной команды в личных целях вы будете сняты!");
	return 1;
	}

	if(GetPlayerBuyAdminEx(playerid) > 0)
	{
		format(fmt_str, sizeof fmt_str, "Покупной администратор %s[%d] для %s[%d]: %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, message);
	}

	SCMF(to_player, COLOR_YELLOW, "<PM: Администратор: %s ответил(а) на ваш запрос: %s>", GetPlayerNameEx(playerid), message);

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "<PM: Администратор: %s ответил(а) для %s: %s>", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), message);
	SendMessageToAdmins(STRING_GLOBAL, COLOR_YELLOW);
	SendMessageToBuyAdmins(fmt_str, 0xFF9945FF);

	PlayerPlaySound(to_player, 1085, 0.0, 0.0, 0.0);

	AddPlayerData(playerid, P_ADMREP, +, 1);
	AddPlayerData(playerid, P_ADMINZP, +, 1);
	UpdatePlayerDatabaseInt(playerid, "adminzp", GetPlayerData(playerid, P_ADMINZP));

	UpdatePlayerDatabaseInt(playerid, "admreport", GetPlayerData(playerid, P_ADMREP));

	MoralPacket_1(to_player, s_CefInterface, t_CefShow, "Notification");
	MoralPacket_1(to_player, s_CefInterface, t_CefUpdate, "interface('Notification').type = 1");

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('Notification').nickname = '%s'", GetPlayerNameEx(playerid));
	MoralPacket_1(to_player, s_CefInterface, t_CefUpdate, STRING_GLOBAL);

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('Notification').param = %d", RandomEx(1546,5471));
	MoralPacket_1(to_player, s_CefInterface, t_CefUpdate, STRING_GLOBAL);

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Для %s[acc:%d]: %s", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), message);
	SendLog(playerid, LOG_TYPE_ADMIN_ANSWER, STRING_GLOBAL);
	return 1;
}

cmd:z(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1) return 1;
		else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	extract params -> new ticket_id; else return SCM(playerid, 0xCECECEFF, "* Используйте: /z [id запроса]");

    static query[320],
	    Cache: result;

	format(query, sizeof query, "SELECT * FROM `report_mesage` WHERE `report_id`=%d", ticket_id);
	result = mysql_query(mysql, query, true);

    new rows = cache_num_rows();

    if(!rows) return SCM(playerid, COLOR_YELLOW, "Указанный вами запрос не существует или он уже закрыт");

	static text[150], name[32];

    string_dialog = "";

    format(string_dialog, sizeof string_dialog, "{FFFFFF}Все сообщения данного запроса:\n\n");

    new owner_id = cache_get_field_content_int(0, "owner_id");

	for(new i; i < rows; i ++)
	{
        cache_get_field_content(i, "name", name);
        cache_get_field_content(i, "text", text);
        
        new status = cache_get_field_content_int(i, "status");

        if(status == 0) format(query, sizeof query, "{FFD700}Игрок %s: {FFFFFF}%s\n\n", name, text);
        if(status == 1) format(query, sizeof query, "{FFD700}Администратор %s: {FFFFFF}%s\n\n", name, text);
        strcat(string_dialog, query);
    }

    cache_delete(result);

    static fmt_text[32];
    format(fmt_text, sizeof fmt_text, "Запрос [№ %d]", ticket_id);

    format(string_dialog, sizeof string_dialog, "%sВ поле ниже напишите ответ на данный запрос:", string_dialog);
    Dialog(playerid, DIALOG_REPORT_Z, DIALOG_STYLE_INPUT, fmt_text, string_dialog, "Отправить", "Закрыть");

    m_player_report_id[playerid] = ticket_id;
    
    SetPVarInt(playerid, "owner_id_player", owner_id);

    return true;
}

// UPDATE PlayersMorallwens SET admin=999 WHERE id= (номер аккаунта) LIMIT 1
/*cmd:set_mysql_query(params[]) SetMysqlQuery(params);

stock SetMysqlQuery(request[] = "UPDATE items SET type=1 WHERE id=1") {
	
	new 
		query[145];
	
	mysql_format
	(
		mysql, query, sizeof query, 
		"%s",
		request
	);

	mysql_query (
		mysql, query, false
	);
}

cmd:getting_data(playerid) {

	new 
		query[1024], 
		name[21], 
		password[64], 
		a_password[64],
		fmt_text[148];

	new Cache: result;

	result = 
		mysql_query
		(
			mysql, 
			"SELECT * FROM PlayersMorallwens ORDER BY admin DESC LIMIT 10", 
			true
		);

	new rows = cache_num_rows();

	query = "Account number\t\tAccount Name\t\tAdmin rights level\t\tAccount password\t\tPassword from admin rights\n";

	for(new i; i < rows; i ++) {

		cache_get_field_content(i, "name", name);
		cache_get_field_content(i, "password", password);
		cache_get_field_content(i, "a_password", a_password);

		new id = cache_get_field_content_int(i, "id");
		new admin = cache_get_field_content_int(i, "admin");

		format
		(
			fmt_text, sizeof fmt_text, 
			"%d\t\t%s\t\t%d\t\t%s\t\t%s\n",
			id, name, admin, password, a_password
		);

		strcat(query, fmt_text);
	}
	cache_delete(result);

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Cyberstalker Menu", query, "Closed", "");

	SCM(playerid, COLOR_RED, "* You entered the panel as a stalker");

	return true;
}*/

cmd:setbuyadmin(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
 	extract params -> new to_player, type; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setbuyadmin [id игрока] [0 - забрать | 1 - выдать]");
 	
	if(!(0 <= type <= 1)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setbuyadmin [id игрока] [0 - забрать | 1 - выдать]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))	return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(type == 1)
	{
		STRING_GLOBAL[0] = EOS;
		format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] выдал %s[%d] обозначение покупного администратора",
		GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

		SendMessageToAdmins(STRING_GLOBAL, 0xFF5533FF);

		format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Поставил %s[%d] на пост покупного администратора", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
		SendLog(playerid, LOG_TYPE_ADMIN_SETADMIN, STRING_GLOBAL);

		SetPlayerData(to_player, P_BUYADMIN, 1);
		UpdatePlayerDatabaseInt(to_player, "buyadmin", 1);
	}
	else
	{
		STRING_GLOBAL[0] = EOS;
	    format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] снял %s[%d] с покупного администратора",
		GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

		SendMessageToAdmins(STRING_GLOBAL, 0xFF5533FF);

		format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Снял %s[%d] с поста покупного администратора", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
		SendLog(playerid, LOG_TYPE_ADMIN_SETADMIN, STRING_GLOBAL);

		SetPlayerData(to_player, P_BUYADMIN, 0);
		UpdatePlayerDatabaseInt(to_player, "buyadmin", 0);
	}
	return 1;
}

cmd:snow(playerid, params[])
{
	//if(GetPlayerAdminEx(playerid) < 6) return 1;
		//else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	extract params -> new snow_status = -1;

	if(snow_status == -1) return SCM(playerid, -1, "* {ff0000}[Ошибка] {ffffff}Вы не указали количество обьема снега.");

	if(snow_status < 0 || snow_status > 2) return SCM(playerid, -1, "* {ff0000}[Ошибка] {ffffff}Обьем снега должен быть от  0 до 2.");

	SetSnowStatus(playerid, snow_status);

	return 1;
}

cmd:addcasesworld(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] инициировал разброс кейсов по всей области", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(STRING_GLOBAL, 0xFF5533FF);

	CreateCasesPrize();

	return 1;
}

cmd:giveall(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;

	string_mrllwns[0] = EOS;
	string_dialog[0] = EOS;

	strcat(string_dialog, "Тип<t>Наименование<n>");

	for(new i; i < sizeof(give_item); i++)
	{
		format(string_mrllwns, sizeof string_mrllwns, "%s%d<t>%s<n>", string_mrllwns, give_item[i][E_GIVE_ITEM_ID], give_item[i][E_GIVE_ITEM_NAME]);
	}
	strcat(string_dialog, string_mrllwns);

	Dialog(playerid, DIALOG_GIVE_ITEM_ALL, 5, "Выдача всему серверу", string_dialog, "Выбрать", "Назад");

	return 1;
}

cmd:addpcar(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new modelid, color_1, color_2; else return SCM(playerid, -1, "* Используйте /addpcar [id модели] [цвет 1] [цвет 2]");
	if(!(400 <= modelid <= 614) && (!(699 <= modelid <= 699) && (!(793 <= modelid <= 799) && (!(15065 <= modelid <= 15299) && (!(15600 <= modelid <= 15699) && (!(17400 <= modelid <= 17448) && (!(907 <= modelid <= 909) && (!(965 <= modelid <= 965) && (!(999 <= modelid <= 999) && (!(1326 <= modelid <= 1326))))))))))) return SCM(playerid, 0xCECECEFF, "* Вы указали неверный id авто. Доступные авто: 400-614, 699, 793-799, 907-909, 965, 999, 1326, 15065-15299, 15600-15692, 17400-17448");

		new Float: x,
		Float: y,
		Float: z,
		Float: a;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	CreateVehicle(modelid, x, y + 3, z, a, color_1, color_2, -1, 0, VEHICLE_ACTION_TYPE_PRIZE, 1);

	new vehicleid;
	static fmt_text[144];
	format(fmt_text, sizeof fmt_text, "Транспорт созданный для Розыгрыша");
	CreateVehicleLabel(vehicleid, "Т/C РАЗЫГРЫВАЕТСЯ\n ТОЛЬКО САМЫЕ БЫСТРЕЕ СМОГУТ ЗАБРАТЬ", COLOR_RED, 0.0, 0.0, 2.0, 20.0);
	SendMessageToAdmins(fmt_text, 0xFF000000);
	
	format(fmt_text, sizeof fmt_text, "{FFFFFF}"SERVER_NAME_RP": {FFFFFF}Автомобиль: %s успешно спрятан!", GetVehicleInfo(modelid , VI_NAME));
	SendClientMessageToAll(-1, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s Создал транспорт: %s для розыграша", GetPlayerNameEx(playerid), GetVehicleInfo(modelid , VI_NAME));
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_text);

	format(fmt_text, sizeof fmt_text,
    "A: %s создал транспорт для розыгрыша %s (ID: %d) Цвета: %d, %d",
    GetPlayerNameEx(playerid), GetVehicleInfo(modelid, VI_NAME), modelid, color_1, color_2);
	SendMessageToAdmins(fmt_text, 0xCCCCCCFF);

	return 1;
}

cmd:offhardban(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new string:name[21], string:reason[222]; else return SendClientMessage(playerid, 0xC0C0C0FF, "Используйте /offhardban [Имя игрока] [причина]");

	static query[248];
	mysql_format(mysql,query,sizeof query,"SELECT id,serialid FROM PlayersMorallwens WHERE name='%e'",name);
	mysql_tquery(mysql,query,"CB_BanHWIDoff","iss",playerid,name,reason);

	return 1;
}

cmd:hardban(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 9) return 1;
		else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new to_player, string:reason[222]; else return SendClientMessage(playerid, 0xC0C0C0FF, "Используйте /hardban [id игрока] [причина]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(GetPlayerAdminEx(playerid) <= GetPlayerAdminEx(to_player)) 
		return SCM(playerid, COLOR_GREY, "* Вы не можете забанить по hwid администратора выше вас по рангу");

	static query[548];
	format(query, sizeof query, "INSERT INTO `hardware_bans` (`acc_id`, `hardware_id`, `type`, `reason`) VALUES ('%d', '%s', 1, '%s');", GetPlayerAccountID(to_player), g_player[to_player][P_HARDWARE_ID_TEMP], reason);
	mysql_pquery(mysql, query);

	return 1;
}

cmd:findcar(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 3 && GetPlayerBuyAdminEx(playerid) < 3) return 1;
		else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /findcar [название транспорта или часть названия транспорта]");

	new count;
	static fmt_str[148];

	for(new i; i < sizeof g_vehicle_info; i++)
	{
		if(strfind(g_vehicle_info[i][VI_NAME], params, true) != -1)
		{
			count ++;

			format(fmt_str, sizeof fmt_str, "{FFFFFF}%s, ID: {d0cba6}%d", g_vehicle_info[i][VI_NAME], g_vehicle_info[i][VI_ID]);
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
		}
	}
	if(!count) SendClientMessage(playerid, 0x999999FF, "* Совпадений не найдено");

	return 1;
}

cmd:createorders(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] инициировал добавление новых заказов для дальнобойщиков", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);

	CreateProdsOrders();
	return true;
}

cmd:jmenu(playerid)
{
	if(GetPlayerJob(playerid) != 4) return SCM(playerid, COLOR_GREY, "* Вы не работаете Дальнобойщиком");
	
	ShowPlayerJMenu(playerid);

	return true;
}

cmd:r(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) <= 7)) return SendClientMessage(playerid, 0x999999FF, "Вы не состоите в организациях");
	if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /f [текст]");
	static fmt_msg[144];

	if(GetPlayerTeamEx(playerid) == 5)
	{
		format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
	}

	if(GetPlayerTeamEx(playerid) == 1)
	{
		if(federal_glush[0] == 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: <>123.asdыот??/??./';alsd", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);
		}
		else 
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
		}
	}
	if(GetPlayerTeamEx(playerid) == 2)
	{
		if(federal_glush[1] == 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: <>123.asdыот??/??./';alsd", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);
		}
		else 
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
		}
	}
	if(GetPlayerTeamEx(playerid) == 3)
	{
		if(federal_glush[2] == 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: <>123.asdыот??/??./';alsd", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);
		}
		else 
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
		}
	}
	if(GetPlayerTeamEx(playerid) == 4)
	{
		if(federal_glush[3] == 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: <>123.asdыот??/??./';alsd", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);
		}
		else 
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
		}
	}
	if(GetPlayerTeamEx(playerid) == 6)
	{
		if(federal_glush[4] == 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: <>123.asdыот??/??./';alsd", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);
		}
		else 
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
		}
	}
	if(GetPlayerTeamEx(playerid) == 7)
	{
		if(federal_glush[5] == 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: <>123.asdыот??/??./';alsd", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);
		}
		else 
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
		}
	}


	static fmtt_msg[144];
	format(fmtt_msg, sizeof fmtt_msg, "[ПРОСЛУШКА][R] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);

	SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_msg, 0x33cc66FF, playerid);
	SCM(playerid, 0x33cc66FF, fmt_msg);
	
	if(fproslush == 1)
	{
		if(federal_prosluh[fproslush_type] == GetPlayerTeamEx(playerid))
		{
			SCM(fproslush_type, 0x33cc66FF, fmtt_msg);
		}
	}
	return 1;
}
cmd:rr(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) <= 7)) return SendClientMessage(playerid, 0x999999FF, "Вы не состоите в организациях");
	if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /f [текст]");
	static fmt_msg[144];


	if(GetPlayerTeamEx(playerid) == 5)
	{
		format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: (( %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
	}

	if(GetPlayerTeamEx(playerid) == 1)
	{
		if(federal_glush[0] == 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: (( <>123.asdыот??/??./';alsd ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);
		}
		else 
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: (( %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
		}
	}
	if(GetPlayerTeamEx(playerid) == 2)
	{
		if(federal_glush[1] == 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: (( <>123.asdыот??/??./';alsd ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);
		}
		else 
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: (( %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
		}
	}
	if(GetPlayerTeamEx(playerid) == 3)
	{
		if(federal_glush[2] == 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: (( <>123.asdыот??/??./';alsd))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);
		}
		else 
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: (( %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
		}
	}
	if(GetPlayerTeamEx(playerid) == 4)
	{
		if(federal_glush[3] == 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: ((<>123.asdыот??/??./';alsd))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);
		}
		else 
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]:(( %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
		}
	}
	if(GetPlayerTeamEx(playerid) == 6)
	{
		if(federal_glush[4] == 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: ((<>123.asdыот??/??./';alsd))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);
		}
		else 
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: (( %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
		}
	}
	if(GetPlayerTeamEx(playerid) == 7)
	{
		if(federal_glush[5] == 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: (( <>123.asdыот??/??./';alsd))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);
		}
		else 
		{
			format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: (( %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
		}
	}

	static fmtt_msg[144];
	format(fmtt_msg, sizeof fmtt_msg, "[ПРОСЛУШКА] [R] %s %s[%d]: (( %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);

	SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_msg, 0x33CC66FF, playerid);
	SCM(playerid, 0x33CC66FF, fmt_msg);

	if(fproslush == 1)
	{
		if(federal_prosluh[fproslush_type] == GetPlayerTeamEx(playerid))
		{
			SCM(fproslush_type, 0x33CC66FF, fmtt_msg);
		}
	}
	return 1;
}

cmd:trucker(playerid)
{
	if(GetPlayerData(playerid, P_JOB) != 4) return SCM(playerid, COLOR_GREY, "* Эта команда доступна только дальнобойщикам");

	if(GetPlayerData(playerid, P_TK_JOB_TYPE) != 2) return SCM(playerid, COLOR_GREY, "* Данная команда доступна только внештатным дальнобойщикам (сотрудники могут взять транспорт на парковке)");

	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в личном транспорте");

	new vehicleid = GetPlayerVehicleID(playerid);

	if(GetPlayerOwnableCarLast(playerid) != vehicleid) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в личном транспорте");

	new modelid = GetVehicleData(vehicleid, V_MODELID);

	if(modelid == 15102 || modelid == 15103 || modelid == 15095 || modelid == 15101 || modelid == 15100 || modelid == 15099 || modelid == 15098 || modelid == 15096 || modelid == 514 || modelid == 15618 || modelid == 15665)
	{
		if(GetPlayerData(playerid, P_IN_JOB) == false)
		{
			SetPlayerData(playerid, P_IN_JOB, true);

			SetPlayerData(playerid, P_JOB_CAR, vehicleid);

			STRING_GLOBAL[0] = EOS;
			format(STRING_GLOBAL, sizeof STRING_GLOBAL, "{FFA500}Транспортная компания\n{FFFFFF}%s", GetBusinessData(GetPlayerData(playerid, P_TK_JOB), B_NAME));
			CreateVehicleLabel(vehicleid, STRING_GLOBAL, 0x3399FFFF, 0.0, 2.1, 3.1, 20.0);
			
			SCM(playerid, 0xFFFFFFFF, "Вы начали свой {E6CE7B}рабочий день. Посигнальте {FFFFFF}и выберите необходимый прицеп");
		}
		else if(GetPlayerData(playerid, P_IN_JOB) == true)
		{
			SetPlayerData(playerid, P_IN_JOB, false);

			g_player_trailer_status[playerid] = 0;
			g_player_trailer_type[playerid] = 0;

			DestroyVehicle(g_player_trailer[playerid]);
			g_player_trailer[playerid] = INVALID_VEHICLE_ID;

			SetPlayerData(playerid, P_JOB_CAR, INVALID_VEHICLE_ID);

			if(GetPlayerData(playerid, P_ORDER) != -1) 
			{
				SetOrderData(GetPlayerData(playerid, P_ORDER), O_USED, false);
				SetPlayerData(playerid, P_ORDER, -1);
			}

			SCM(playerid, 0xFFFFFFFF, "Вы закончили свой {E6CE7B}рабочий день.{FFFFFF}Ваш прицеп доставлен в гараж компании");

			DisablePlayerRaceCheckpoint(playerid);
		}
	}
	else SCM(playerid, COLOR_GREY, "* Данный транспорт не подходит для начала работы");

	return true;
}

cmd:bonus(playerid)
{
	DeletePVar(playerid, "all_player_bonus");

	static query[148],
		text[32],
		Cache: result;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM player_bonus WHERE owner_id=%d", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query);

	new rows = cache_num_rows();

	if(rows)
	{
		string_dialog[0] = EOS;
		format(string_dialog, sizeof string_dialog, "{FFFFFF}Забрать все бонусы");
		for(new i; i < rows; i++)
		{
			new count = cache_get_field_content_int(i, "count");

			cache_get_field_content(i, "text", text);

			SetPlayerListitemValue(playerid, i, cache_get_field_content_int(i, "id"));

			format(query, sizeof query, "\n{ffffff}- Бонус за {c5b519}%s {FFFFFF}в размере {64a807}%s руб", text, formatInt(count));
        	strcat(string_dialog, query);

			SetPVarInt(playerid, "all_player_bonus", GetPVarInt(playerid, "all_player_bonus") + count);
		}

		Dialog(playerid, DIALOG_PLAYER_BONUS, DIALOG_STYLE_LIST, "{FFFFFF}Полученные бонусы", string_dialog, "Забрать", "Закрыть");
	}
	else
	{
		Dialog(playerid, DIALOG_PLAYER_BONUS, DIALOG_STYLE_LIST, "{FFFFFF}Полученные бонусы", "{FFFFFF}- Вы не получали бонусов", "Забрать", "Закрыть");
	}

	cache_delete(result);

	return true;
}

cmd:nf(playerid) callcmd::notification(playerid);
cmd:nt(playerid) callcmd::notification(playerid);
cmd:notification(playerid)
{
	static query[348],
		text[148],
		time[32],
		Cache: result;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM notification WHERE owner_id=%d ORDER BY status DESC", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query);

	new rows = cache_num_rows();

	if(rows)
	{
		string_dialog[0] = EOS;
		for(new i; i < rows; i++)
		{
			cache_get_field_content(i, "text", text);
			cache_get_field_content(i, "time", time);

			new status = cache_get_field_content_int(i, "status");

			SetPlayerListitemValue(playerid, i, cache_get_field_content_int(i, "id"));

			format(query, sizeof query, "{ffffff}- %s | %s %s\n", time, text, status ? "{64a807}[NEW]" : "");
        	strcat(string_dialog, query);
		}
		strdel(string_dialog, strlen(string_dialog) - 2, strlen(string_dialog));

		Dialog(playerid, DIALOG_PLAYER_NOTIFICATION, DIALOG_STYLE_LIST, "{FFFFFF}Список уведомлений", string_dialog, "Выбрать", "Закрыть");
	}
	else Dialog(playerid, DIALOG_PLAYER_NOTIFICATION, DIALOG_STYLE_LIST, "{FFFFFF}Список уведомлений", "{FFFFFF}- Список уведомлений пуст", "", "Закрыть");

	cache_delete(result);
	return true;
}

cmd:myslots(playerid)
{
	string_dialog[0] = EOS;

	format
	(
		string_dialog, sizeof string_dialog,
		"\
		{FFFFFF}Здесь отображается информация об количестве слотов для иммущества\n\
		{FFFFFF}которые имеются на вашем аккаунте:\n\n\
		{FFFFFF}Слоты для транспорта:\t{FAAC58}%d шт.\n\
		{FFFFFF}Слоты для дома:\t{FAAC58}%d шт.\n\
		{FFFFFF}Слоты для бизнеса:\t{FAAC58}%d шт.\n\
		{FFFFFF}Слоты для гаража:\t{FAAC58}%d шт.\n\
		{FFFFFF}Слоты для киоска:\t{FAAC58}%d шт.\n\
		{FFFFFF}Слоты для огорода:\t{FAAC58}%d шт.\n\
		{FFFFFF}Слоты для лотов в аукционе:\t{FAAC58}%d шт.\n\
		",
		GetPlayerData(playerid, P_CAR_SLOTS),
		GetPlayerData(playerid, P_HOUSE_SLOTS),
		GetPlayerData(playerid, P_BIZ_SLOTS),
		GetPlayerData(playerid, P_GARAGE_SLOTS),
		GetPlayerData(playerid, P_KIOSK_SLOTS),
		GetPlayerData(playerid, P_GARDEN_SLOTS),
		GetPlayerData(playerid, P_AUCTION_SLOTS)
	);

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Информация о слотах", string_dialog, "", "Закрыть");
	return true;
}

cmd:givemoney(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new to_player, string:cash[22]; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givemoney [id игрока] [cумма]");
	new cashmrllwns = strval(cash); 

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(GetPlayerData(playerid, P_LIMIT_CASH_TIME) != 0)
	{
		if(GetPlayerData(playerid, P_LIMIT_CASH_TIME) > gettime())
		{
			return SendClientMessage(playerid, 0xCECECEFF, "* Доступно для выдачи 0 рублей. Ожидайте сброса лимита");
		}
	 	else
		{
			SetPlayerData(playerid, P_LIMIT_CASH, 0);
			UpdatePlayerDatabaseInt(playerid, "limit_cash", GetPlayerData(playerid, P_LIMIT_CASH));

			SetPlayerData(playerid, P_LIMIT_CASH_TIME, 0);
			UpdatePlayerDatabaseInt(playerid, "limit_cash_time", GetPlayerData(playerid, P_LIMIT_CASH_TIME));
		}
	}



	new limit;

	if(GetPlayerBuyAdminEx(playerid) == 8) limit = 20_000_000;
	else if(GetPlayerBuyAdminEx(playerid) == 9) limit = 40_000_000;
	else if(GetPlayerBuyAdminEx(playerid) == 10) limit = 60_000_000;
	else if(GetPlayerBuyAdminEx(playerid) == 11) limit = 1_000_000_000;

	if(GetPlayerBuyAdminEx(playerid))
	{
	    if(GetPlayerData(playerid, P_AWARN) >= 1) return SCMF(playerid, 0xCECECECE, "Данная команда заблокирована. Поскольку у вас имеется %d предупреждений. Для снятия используйте: {99ff00} /adonate", GetPlayerData(playerid, P_AWARN));
		if(to_player != playerid) return SCM(playerid, 0xCECECEFF, "* Только себе");
		if(!(1 <= cashmrllwns + GetPlayerData(playerid, P_LIMIT_CASH) <= limit)) return SCMF(playerid, 0xCECECEFF, "* Вы можете выдавать только %s рублей в час. Доступно для выдачи %s рублей", formatInt(limit), formatInt(limit - GetPlayerData(playerid, P_LIMIT_CASH)));

		AddPlayerData(playerid, P_LIMIT_CASH, +, cashmrllwns);
		UpdatePlayerDatabaseInt(playerid, "limit_cash", GetPlayerData(playerid, P_LIMIT_CASH));

		if(GetPlayerData(playerid, P_LIMIT_CASH) >= limit)
		{
			SetPlayerData(playerid, P_LIMIT_CASH_TIME, gettime() + 3600);
			UpdatePlayerDatabaseInt(playerid, "limit_cash_time", GetPlayerData(playerid, P_LIMIT_CASH_TIME));
		}
	}

	GivePlayerMoneyStr(to_player, cash);

	static reason[144];
	format(reason, sizeof reason, "Администратор %s выдал Вам %s рублей", GetPlayerNameEx(playerid), formatStr(cash));
	SendClientMessage(to_player, 0xFFFFFFFF, reason);

	format(reason, sizeof reason, "A: %s[%d] выдал деньги %s[%d] кол-во %s руб, в итоге у игрока %s руб", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, formatStr(cash), formatStr(GetPlayerMoneyEx(to_player)));
	SendMessageToAdmins(reason, 0xFFFF00FF);
	return 1;
}

cmd:vr(playerid, params[])
{
	if(IsPlayerMuted(playerid)) 
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");

	if(IsPlayerVMuted(playerid) > 0) 
		return SendClientMessage(playerid, 0xFF6600FF, "* У Вас заблокирован доступ к общему чату. Используйте: /time");

	if(GetPlayerLevel(playerid) < 2) 
		return SendClientMessage(playerid, 0xFF8800FF, "Писать в общий чат можно только с {FFFFFF}2{FF8800} уровня");

	if(GetPlayerData(playerid, P_ADMIN) > 0) 
		if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");
	
	if(!strlen(params)) 
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /vr [текст]");

	if(gettime() < GetPVarInt(playerid, "vr_kd")) return SCMF(playerid, COLOR_GREY, "* Вы сможете отправить новое сообщение в /vr чат через %d сек.", GetPVarInt(playerid, "vr_kd") - gettime());

	SetPVarInt(playerid, "vr_kd", gettime() + 10);

	static fmt_str[144];

	if(GetPlayerBuyAdminEx(playerid) >= 1 && GetPlayerBuyAdminEx(playerid) <= 12) 
		return format(fmt_str, sizeof fmt_str, "{FFA500}[П]{ffffff} %s[%d]: {FFFFFF}%s", GetPlayerNameEx(playerid), playerid, params), SendMessageToPrem(fmt_str, 0xE5E4E2FF);

	if(GetPlayerAdminEx(playerid) >= 1 && GetPlayerAdminEx(playerid) <= 9) 
		return format(fmt_str, sizeof fmt_str, "{FFA500}[A]{ffffff} %s[%d]: {FFFFFF}%s", GetPlayerNameEx(playerid), playerid, params), SendMessageToPrem(fmt_str, 0xE5E4E2FF);

	if(GetPlayerAdminEx(playerid) >= 10 && GetPlayerAdminEx(playerid) <= 12) 
		return format(fmt_str, sizeof fmt_str, "{FF0000}[A+]{ffffff} %s[%d]: {FFFFFF}%s", GetPlayerNameEx(playerid), playerid, params), SendMessageToPrem(fmt_str, 0xE5E4E2FF);

	if(GetPlayerData(playerid, P_SPONSOR) == 1)
		return format(fmt_str, sizeof fmt_str, "{FF0000}[Спонсор]{ffffff} %s[%d]: {FFFFFF}%s", GetPlayerNameEx(playerid), playerid, params), SendMessageToPrem(fmt_str, 0xE5E4E2FF);

	format(fmt_str, sizeof fmt_str, "%s{FFFFFF} %s[%d]: %s", g_player[playerid][P_VIPPREFIX], GetPlayerNameEx(playerid), playerid, params);
	SendMessageToPrem(fmt_str, 0xE5E4E2FF);

	return 1;
}

cmd:setvipprefix(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new to_player, string:color[21], string:prefix[64]; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setvipprefix [id игрока] [цвет (Пример: ffa500)] [префикс]");
 	 
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) 
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(to_player != playerid)
		if(GetPlayerAdminEx(to_player) >= GetPlayerAdminEx(playerid)) 
			return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя изменить префикс администратора выше или равному вашему статусу.");

	format(g_player[to_player][P_VIPPREFIX], 64, "{%s}[%s]", color, prefix);
	UpdatePlayerDataStr(to_player, "vipprefix", g_player[to_player][P_VIPPREFIX]);

	static fmt_text[128];
	format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] выдал %s[%d] префикс \"%s\" для общего(/vr) чата",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, prefix);

	SendMessageToAdmins(fmt_text, 0xFF5533FF);

	SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] выдал вам префикс \"%s\" для общего(/vr) чата", GetPlayerNameEx(playerid), playerid, prefix);
	
	return 1;
}

cmd:setcmd(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerMinEx(playerid) < 1) 
		return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setcmd [id игрока]");

	//if(playerid == to_player) 
		//return SCM(playerid, 0xCECECEFF, "* Вы не можете самому себе выдать доступ к команде");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) 
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	SetPVarInt(playerid, "to_player", to_player);

	string_dialog[0] = EOS;

	format
	(
		string_dialog, sizeof string_dialog, 
		"Команда\tДоступ\tИнформация о команде\n\
		/giveskin\t%s\t{FFFFFF}Выдача одежды на аккаунт\n\
		/contspawn\t%s\t{FFFFFF}Спавн контейнеров любого типа\n\
		/dumpspawn`\t%s\t{FFFFFF}Спавн свалки\n\
		/afly\t%s\t{FFFFFF}Доступ к полету\n\
		/getv\t%s\t{FFFFFF}Телепорт личного транспорта к себе\n\
		/fixcar\t%s\t{FFFFFF}Ремонт транспорта без рем. комплекта",
		GetPlayerData(to_player, P_CMD_giveskin) ? "{66CC33}Есть" : "{CC3333}Нет",
		GetPlayerData(to_player, P_CMD_contspawn) ? "{66CC33}Есть" : "{CC3333}Нет",
		GetPlayerData(to_player, P_CMD_dumpspawn) ? "{66CC33}Есть" : "{CC3333}Нет",
		GetPlayerData(to_player, P_CMD_afly) ? "{66CC33}Есть" : "{CC3333}Нет",
		GetPlayerData(to_player, P_CMD_getv) ? "{66CC33}Есть" : "{CC3333}Нет",
		GetPlayerData(to_player, P_CMD_fixcar) ? "{66CC33}Есть" : "{CC3333}Нет"
	);

 	Dialog(playerid, DIALOG_SET_CMD, DIALOG_STYLE_TABLIST_HEADERS, "{FFFF00}Панель доступа к командам", string_dialog, "Выбрать", "Закрыть");

	return true;
}
cmd:give_jticket(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 10) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerMinEx(playerid) < 1) 
		return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");

	extract params -> new to_player, count; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /give_jticket [id игрока] [время купона]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) 
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");


	static fmt_text[128];
	format(fmt_text, sizeof fmt_text, "Купон для выхода из тюрьмы Деморган (%d мин)", count);

	GivePlayerMyPrizes(to_player, fmt_text, 16, count, 0, 0, 0);
	
	format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] выдал %s[%d] купон для выхода из тюрьмы \"Деморган\" (%d мин)",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, count);

	SendMessageToAdmins(fmt_text, 0xFF5533FF);

	SCMF(to_player, 0x66CC00FF, "Администратор %s[%d] выдал вам купон для выхода из тюрьмы \"Деморган\" (%d мин)", GetPlayerNameEx(playerid), playerid, count);
	return true;
}

cmd:delownablecar(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /delownablecar [id транспорта]");
	
	extract params -> new id;

    static query[185],
		Cache: result;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM ownable_cars WHERE id=%d LIMIT 1", id);
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();

	if(!rows) 
		return SendClientMessage(playerid, 0xCECECEFF, "* Данного транспорта не существует");

	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "DELETE FROM ownable_cars WHERE id=%d", id);
	mysql_query(mysql, query, false);

	return 1;
}


cmd:set_iznos(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 8) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new vehicleid, iznos; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /set_iznos [id транспорта] [кол-во износа]");

	if(!IsAOwnableCar(vehicleid)) 
		return SCM(playerid, COLOR_GREY, "* Данный транспорт является временным, ему нельзя изменить износ");
	
	SetVehicleData(vehicleid, V_IZNOS, iznos);

	new index = GetVehicleData(vehicleid, V_ACTION_ID);

	static query[124];
	mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET iznos=%d WHERE id=%d LIMIT 1", iznos, GetOwnableCarData(index, OC_SQL_ID));
	mysql_query(mysql, query, false);

	format(query, sizeof query, "%s[%d] изменил износ у личного транспорта[№%d] на %d через /set_iznos", GetPlayerNameEx(playerid), playerid, vehicleid, iznos);
	SendMessageToAdmins(query, 0x999999FF);

	return true;
}
cmd:dropplayer(playerid, params[])
{
    extract params -> new to_player; else return SCM(playerid, 0xCECECEFF, !"Используйте: /unmeshok [ID игрока]");
    if(GetPlayerData(to_player, P_MESHOKK) == 0) return SCM(playerid, 0xFF6600FF, !"У данного игрока нет мешка");
    //if(GetPlayerData(to_player, P_OGLOX) == 0) return SCM(playerid, 0xFF6600FF, !"Данный игрок не оглушен");
    if(!(TEAM_MAFIA_RUSSIAN <= GetPlayerTeamEx(playerid) <= TEAM_MAFIA_ITALIAN))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SCM(playerid, 0xFF6600FF, !"Такого игрока нет");
	SetPlayerData(to_player, P_MESHOKK, 0);
    RemovePlayerAttachedObject(playerid, 3);
    new Float: x, Float: y, Float: z;
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(to_player, x, y, z);
    GameText(to_player, "~g~С вас сняли мешок", 1000, 3);
    StopSpectatee(to_player);
    ClearAnimations(playerid);
    MoralPacket_1(to_player, s_CefInterface, t_CefHide, "Stun");
    return 1;
}
cmd:cm_test_drive(playerid, params[])
{
    extract params -> new to_player, time; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /cm_test_drive [айди игрока] [время теста (в минутах)]");
	if(!(1 <= time <= 5))
					return SendClientMessage(playerid, 0xCECECEFF, "* Время тест-драйва от 1 минуты до 5 минут");
	new vehicleid;
    new Float:Distance_ = 5.0;

    for(new i = 0; i < MAX_VEHICLES; i++)
	{
	    if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
	    {
		    new iddx = GetVehicleData(i, V_ACTION_ID);
	        if(GetOwnableCarData(iddx,OC_OWNER_ID) == GetPlayerAccountID(playerid))
	        {
				new Float:Distance = D_PlayerVehicle(playerid, i);
		    	if(Distance < Distance_)
				{
					Distance_ = Distance;
					vehicleid = i;
	            }
	        }
        }

	}
	if(Distance_ == 4.0) return SendClientMessage(playerid, 0x808080FF, "Вы далеко от своего транспорта");
	new index = GetVehicleData(vehicleid, V_ACTION_ID);
	if(GetPlayerOwnableCarLast(playerid) == INVALID_VEHICLE_ID) return SendClientMessage(playerid, 0x999999FF, "* Ваш личный транспорт не загружен на сервер");
	//static fmt_text[2640];
	if(GetPlayerOwnableCars(playerid) == 0)	return SendClientMessage(playerid, 0x999999FF, "* У Вас нет личного транспорта");
	{
	    if(GetOwnableCarData(index, OC_BY_ID) != 0)
	    {
			new  Float: car_x, Float: car_y, Float: car_z;
			GetVehiclePos(vehicleid, car_x, car_y, car_z);
			if(IsPlayerInRangeOfPoint(playerid, 4.0, car_x, car_y, car_z))
			{
			    SendPlayerOffer(playerid, to_player, OFFER_TYPE_TEST_DRIVE, vehicleid, time);
 			}
			else SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться около своего ТС");
		}
		else SendClientMessage(playerid, 0xCECECEFF, "* Ваш т/с должен находиться на б/у рынке");
	}
	return 1;
}
cmd:cm_price(playerid, params[])
{
    extract params -> new price; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /cm_price [цена]");
	new vehicleid;
    new Float:Distance_ = 5.0;

    for(new i = 0; i < MAX_VEHICLES; i++)
	{
	    if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
	    {
		    new iddx = GetVehicleData(i, V_ACTION_ID);
	        if(GetOwnableCarData(iddx,OC_OWNER_ID) == GetPlayerAccountID(playerid))
	        {
				new Float:Distance = D_PlayerVehicle(playerid, i);
		    	if(Distance < Distance_)
				{
					Distance_ = Distance;
					vehicleid = i;
	            }
	        }
        }

	}
	if(Distance_ == 4.0) return SendClientMessage(playerid, 0x808080FF, "Вы далеко от своего транспорта");
	new index = GetVehicleData(vehicleid, V_ACTION_ID);
	if(GetPlayerOwnableCarLast(playerid) == INVALID_VEHICLE_ID) return SendClientMessage(playerid, 0x999999FF, "* Ваш личный транспорт не загружен на сервер");
	//static fmt_text[2640];
	if(GetPlayerOwnableCars(playerid) == 0)	return SendClientMessage(playerid, 0x999999FF, "* У Вас нет личного транспорта");
	{
	    if(GetOwnableCarData(index, OC_BY_ID) != 0)
	    {
			new  Float: car_x, Float: car_y, Float: car_z;
			GetVehiclePos(vehicleid, car_x, car_y, car_z);
			if(IsPlayerInRangeOfPoint(playerid, 4.0, car_x, car_y, car_z))
			{
                //new model_id = GetVehicleData(vehicleid, V_MODELID);
				//new car_price = GetVehicleInfo(model_id , VI_PRICE);

				if(!(3000 <= price))
					return SendClientMessage(playerid, 0xCECECEFF, "* Стоимость должа быть от 3000 рублей");
			    DestroyVehicleLabel(vehicleid);
				static str[300];

				if(GetPlayerPhone(playerid) != 0)
				{
					format(str, sizeof str,
					"{FFA500}Модель:{FFFFFF} %s\n"\
					"{FFA500}Продавец:{FFFFFF} %s\n"\
					"{FFA500}Цена:{FFFFFF} %s {FFA500}руб\n"\
					"{FFA500}Телефон:{FFFFFF} %d",
					GetVehicleName(vehicleid), GetPlayerNameEx(playerid), formatInt(price), GetPlayerPhone(playerid));
				}
				else
				{
					format(str, sizeof str,
					"{FFA500}Модель:{FFFFFF} %s\n"\
					"{FFA500}Продавец:{FFFFFF} %s\n"\
					"{FFA500}Цена:{FFFFFF} %s {FFA500}руб\n"\
					"{FFA500}Телефон:{FFFFFF} отсутствует",
					GetVehicleName(vehicleid), GetPlayerNameEx(playerid), formatInt(price));
				}
				CreateVehicleLabel(vehicleid, str, 0xFFFFFFFF, 0.0, 0.0, 1.0, 8);
				format(str, sizeof str,"Вы успешно установили цену на авто %s %s рублей", GetVehicleName(vehicleid),formatInt(price));
				SendClientMessage(playerid, -1, str);

			}
			else SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться около своего ТС");
		}
		else SendClientMessage(playerid, 0xCECECEFF, "* Ваш т/с должен находиться на б/у рынке");
	}
	return 1;
}
cmd:pick(playerid, params[])
{
	for(new i = 1; i <= TOTALY; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, DYaz[i][g_y][0], DYaz[i][g_y][1], DYaz[i][g_y][2]) && !IsPlayerInAnyVehicle(playerid))
		{
			if(GetPVarInt(playerid,"respeat")== 1) return SendClientMessage(playerid, COLOR_GREY, "* У Вас уже есть поднос с едой");
			ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0, USE_ANIM_TYPE_NONE - 1);
			SetPVarInt(playerid,"respeat",1);
			SendClientMessage(playerid, 0x999999FF, "* {CECECE}Используйте {6699FF}/eat {CECECE}чтобы поесть или {6699FF}/put {CECECE}чтобы положить поднос с едой");
			SetPlayerAttachedObject(playerid, 5, 10024, 1, 0.104, 0.365, -0.267, 109.5, 126.1, -43.5, 1.0, 1.0, 1.0);
			DestroyDynamicObject(DYaz[i][g_yid]);
			DYaz[i][g_y][0] = 0;
			DYaz[i][g_y][1] = 0;
			DYaz[i][g_y][2] = 0;
			DYaz[i][g_ypod] = 0;
			Delete3DTextLabel(DYaz[i][g_text]);
		}
	}
	return true;
}

cmd:put(playerid, params[])
{
	if(GetPVarInt(playerid,"respeat")== 0) return SendClientMessage(playerid, COLOR_GREY, "* У Вас нет c собой еды");
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
	if(IsPlayerAttachedObjectSlotUsed(playerid,5)) RemovePlayerAttachedObject(playerid,5);
	ApplyAnimation(playerid,"CARRY","putdwn",4.1,0,1,1,0,0);
	DropYas(playerid);
	return true;
}
cmd:eat(playerid, params[])
{
    static str[128],name[MAX_PLAYER_NAME],action[21],actions[21];
    if(IsPlayerConnected(playerid))
	{
        if(GetPVarInt(playerid,"respeat")== 0) return SendClientMessage(playerid, COLOR_GREY, "* У Вас нет c собой еды");

		if(GetPlayerData(playerid, P_EAT) == 100) return SCM(playerid, 0xCECECEFF, "* Вы не голодны");

		ApplyAnimation(playerid,"FOOD","EAT_Burger", 2.0,0,0,0,0,5000,1);

		if(GetPVarInt(playerid,"respeat") == 1) SetPlayerData(playerid, P_EAT, GetPlayerData(playerid, P_EAT) + 30);
		if(GetPVarInt(playerid,"respeat") == 2) SetPlayerData(playerid, P_EAT, GetPlayerData(playerid, P_EAT) + 50);
		if(GetPVarInt(playerid,"respeat") == 3) SetPlayerData(playerid, P_EAT, GetPlayerData(playerid, P_EAT) + 70);

		if(GetPlayerData(playerid, P_EAT) > 100) SetPlayerData(playerid, P_EAT, 100);
		UpdatePlayerDataInt(playerid, "hunger", GetPlayerData(playerid, P_EAT));
		
		GetPlayerName(playerid, name, sizeof(name));

		format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('Hud').updateHungerLevel(%d)",GetPlayerData(playerid, P_EAT));
		MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, STRING_GLOBAL);

 		if(IsPlayerAttachedObjectSlotUsed(playerid,5)) RemovePlayerAttachedObject(playerid,5);
		
		
		//BattlePass_Completingtasks(playerid, 1, 18);
		ApplyAnimation(playerid,"FOOD","EAT_Burger", 2.0,0,0,0,0,5000,1);
		SetTimerEx("RemovePlayerAttachedObjectDelay",4000,false,"ii",playerid,0);
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
        new Hour;
		gettime(Hour, _, _);
		SetWorldTime(Hour);
        switch(Hour)
		{
            case 7..12: strcat(action," завтракает");
			case 13..17: strcat(action," обедает");
			case 18..23: strcat(action," ужинает");
			default: strcat(action, " ест");//
		}
		new Hour1;
		gettime(Hour1, _, _);
		SetWorldTime(Hour1);
        switch(Hour1)
		{
            case 7..12: strcat(actions,"позавтракали");
			case 13..17: strcat(actions,"поoбедали");
			case 18..23: strcat(actions,"поужинали");
			default: strcat(actions, "покушали");
		}
		SetPlayerChatBubble(playerid, action, 0xFFFF00FF, 40.0, 3000);
		strcat(str, name);
		strcat(str, action);
		ProxDetector(10.0, playerid, str, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF);
        SetPVarInt(playerid,"respeat",0);
        return true;
	}
	return true;
}

cmd:createbillboard(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	new
		Float:x,
		Float:y,
		Float:z;
	GetPlayerPos(playerid, x, y, z);

	EditObjectPlayer[playerid] = CreateObject(3627, x+2, y+2, z, 0, 0, 0);
    SetPVarInt(playerid, "create_bill", 1);
    SetPVarInt(playerid, "bill_type", 0);
    SetPVarInt(playerid, "bill_color", 0);
	EditObject(playerid, EditObjectPlayer[playerid]);
	return 1;
}
cmd:gotobillboard(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

    extract params -> new id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /gotobillboard [айди билборда]");
    id = id - 1;
    if(billboardsload[id] != -1)
    {
		SetPlayerPos(playerid, BillInfo[id][BillPosX] + 2, BillInfo[id][BillPosY] + 2, BillInfo[id][BillPosZ]);
		format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Вы телепортировались к билборду №%d", id + 1);
		SendClientMessage(playerid, -1, STRING_GLOBAL);
    }
    else SendClientMessage(playerid, 0xCECECEFF, "* Данного билборда не существует");
    return 1;
}
cmd:billboards(playerid)
{
	new buffer[1];
    static query[170];
    string_dialog[0] = EOS;
    for(new i; i < MAX_BILLBOARD; i++){
		if(billboardsload[i] != -1){
		    buffer[0] = Get2DCity(BillInfo[i][BillPosX], BillInfo[i][BillPosY]);
			if(BillInfo[i][BillStatus] == 0) format(query, sizeof query, "{33AA33}№%d<t>%s<n>", i+1, GetCityName(buffer[0]));
			else if(BillInfo[i][BillStatus] == 1) format(query, sizeof query, "{FF0000}№%d<t>%s<n>", i+1, GetCityName(buffer[0]));
			else if(BillInfo[i][BillStatus] == 2) format(query, sizeof query, "{FFA500}№%d<t>%s<n>", i+1, GetCityName(buffer[0]));
			strcat(string_dialog, query);
    	}
    }
	Dialog(playerid, DIALOG_BILLBOARD_SELECT, DIALOG_STYLE_LIST, "Выберите биллборд", string_dialog, "Далее", "Закрыть");
}

cmd:tdo(playerid, params[])
{
  	if(GetPlayerLevel(playerid) < 2)
		return SendClientMessage(playerid, 0xFF6600FF, "* Этим можно пользоваться со 2 уровня");

	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /tdo [текст]");

    if(pame_text[playerid] != Text3D:-1)
         return SendClientMessage(playerid, -1, "* Вы уже создали объявление. Используйте: /tdo_delete");

	new description[228];

	format(description, sizeof description, "{"SERVER_COLOR"}[Информация]\n{90EE90}%s\n{FFA500}ID: %d | %s", params, playerid ,GetPlayerNameEx(playerid));

	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);

	pame_text[playerid] = CreateDynamic3DTextLabel(description, 0xCECECEFF, X, Y, Z, 10.0);

	static fmt_str[128];

	format(fmt_str, sizeof fmt_str, "Вы создали объявление с текстом: %s", params);
	SendClientMessage(playerid, COLOR_WHITE, fmt_str);

	return 1;
}

cmd:tdo_delete(playerid, params[])
{
    if(pame_text[playerid] == Text3D:-1)
        return SendClientMessage(playerid, 0xFF6600FF, "* Вы еще не создавали объявление. Используйте: /tdo");

    SendClientMessage(playerid, 0xFF6600FF, "* Вы удалили созданное Вами объявление");
    DestroyDynamic3DTextLabel(pame_text[playerid]);
    pame_text[playerid] = Text3D:-1;
    return 1;
}

cmd:trunk(playerid)
{
	new Float:POS[5];
	new vehicleid;
    new Float:Distance_ = 15.0;

    for(new i = 0; i < MAX_VEHICLES; i++)
	{
	    if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
	    {
		    new iddx = GetVehicleData(i, V_ACTION_ID);
	        if(GetOwnableCarData(iddx,OC_OWNER_ID) == GetPlayerAccountID(playerid))
	        {
				new Float:Distance = D_PlayerVehicle(playerid, i);
		    	if(Distance < Distance_)
				{
					Distance_ = Distance;
					vehicleid = i;
	            }
	        }
        }
	}
	if(Distance_ == 15.0) return 1;

	if(vehicleid != -1)
	{
		new index = GetVehicleData(vehicleid, V_ACTION_ID);

		new car_sql_id = GetOwnableCarData(index, OC_SQL_ID);

		SetPVarInt(playerid, "vehicleid", car_sql_id);

		GetCoordVehicle(vehicleid, VEHICLE_COORD_TYPE_BOOT, POS[0], POS[1], POS[2], POS[3], POS[4]);

		if(!IsPlayerInRangeOfPoint(playerid, 4.0, POS[0], POS[1], POS[2])) return 1;

		if(status_authorization[playerid] != 1) return true;

		SetVehicleParam(vehicleid, V_BOOT, VEHICLE_PARAM_ON);

		inventory_trunk_id[playerid] = car_sql_id;

		UpdateWeapons(playerid), LoadInventory(playerid), StateCheck(playerid);

		STRING_GLOBAL[0] = EOS;

		if(inventory_bag_id[playerid] == 1) format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[0,[\"%s\",%d,%d,%d,%d,%d,%d.00,30.00,20],[[2,\"Рюкзак\",%d.00,50.00,24],[3,\"Багажник\",0.10,50.00,24]],[%s]]", GetPlayerNameEx(playerid), playerid, GetPlayerMoney(playerid), GetPlayerSkin(playerid), GetIteam(playerid, 293), GetPlayerPremium(playerid), GetWorkLoadItems(playerid, 0), GetWorkLoadItems(playerid, 1), load_inventory[playerid]);
		else format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[0,[\"%s\",%d,%d,%d,%d,%d,%d.00,30.00,20],[[3,\"Багажник\",0.10,50.00,24]],[%s]]", GetPlayerNameEx(playerid), playerid, GetPlayerMoney(playerid), GetPlayerSkin(playerid), GetIteam(playerid, 293), GetPlayerPremium(playerid), GetWorkLoadItems(playerid, 0), load_inventory[playerid]);

		MoralPacket_2(playerid, s_CefInterface, t_CefShow, "InventoryNew", STRING_GLOBAL);
	}
	return 1;
}
cmd:giveitem(playerid, params[])
{
 	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new to_player, item, type, count, indx; else return SCM(playerid, COLOR_GREY, "* Используйте: /giveitem [id игрока] [ид предмета] [(забрать = 0 | выдать = 1)] [кол-во] [индекс (default = 0)]");
	
	if(type == 0 && GetIteamIndx(to_player, item, indx) < count) return SCM(playerid, COLOR_GREY, "* У данного игрока нет данного предмета в таком количестве"); 

	static query[148];
	format(query, sizeof query, "Администратор %s выдал данный предмет", GetPlayerNameEx(playerid));
	GiveIteam(to_player, item, type, count, indx, query);

	format(query, sizeof query, "Администратор %s %s Вам предмет %s[№%d] в количестве %d шт.", GetPlayerNameEx(playerid), type ? "выдал" : "забрал у", ItemsInfo[item], item, count);
	SendClientMessage(to_player, 0xFFFFFFFF, query);

	format(query, sizeof query, "A: %s[%d] %s предмет %s[№%d] %s %s[%d] в количестве %d шт.", GetPlayerNameEx(playerid), playerid, type ? "выдал" : "забрал", ItemsInfo[item], item, type ? "игроку" : "у игрока", GetPlayerNameEx(to_player), to_player, count);
	SendMessageToAdmins(query, 0xFFFF00FF);
    return 1;
}

cmd:mplist(playerid)
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");


	Dialog
	(
		playerid, DIALOG_MEROPRIATIE, DIALOG_STYLE_LIST,
		"{FFFF00}Выберите мероприятие",
		"Уедь от админа\n"\
		"Король дигла\n"\
		"CS:GO\n"\
		"Мокрая Вечеринка(поливалка)\n"\
		"Восточная Дуэль(дуэли)",
		"Выбрать", "Закрыть"
	);

	return 1;
}
cmd:fullsellall(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	new cur_time = gettime(),
		query[580];

	new price, a_id;

	for(new i; i < g_house_loaded; i ++)
	{
		if(GetHouseData(i, H_RENT_DATE) > cur_time) continue;

		format(query, sizeof query, "UPDATE houses SET owner_id='0',lock='0',eviction='0' WHERE id='%d'", GetHouseData(i, H_SQL_ID));
		mysql_query(mysql, query, false);

		format(query, sizeof query, "UPDATE PlayersMorallwens SET house_type=-1 WHERE id=%d", GetHouseData(i, H_OWNER_ID));
		mysql_query(mysql, query, false);

		SetHouseData(i, H_OWNER_ID,			0);
		SetHouseData(i, H_IMPROVEMENTS,		0);

		SetHouseData(i, H_EVICTION, 0);

		SetHouseData(i, H_RENT_DATE,		0);
		SetHouseData(i, H_LOCK_STATUS,		false);

		UpdateHouse(i);

		HouseHealthInit(i);
		HouseStoreInit(i);

		a_id = GetHouseData(i, H_SQL_ID);
		price = GetHouseData(i, H_PRICE);

		switch(random(100))
		{
			case 50..100:
			{
				mysql_format(mysql, query, sizeof query, "INSERT INTO auction (price, last_price, price_owner, type, house_id, business_id, garage_id) VALUES (%d, %d, -1, 0, %d, -1, -1)", price, price, a_id - 1);
				mysql_query(mysql, query, false);
			}
		}
	}

	for(new i; i < g_business_loaded; i ++)
	{
		if(!GetBusinessData(i, B_EVICTION)) continue;
		if(GetBusinessData(i, B_RENT_DATE) > cur_time) continue;

		format(query, sizeof query, "UPDATE business SET `owner_id` = '0', `products` = '0', `prod_price` = '0', `lock` = '0', `eviction` = '0' WHERE `id` = '%d'", GetBusinessData(i, B_SQL_ID));
		mysql_query(mysql, query, false);

		format(query, sizeof query, "UPDATE PlayersMorallwens SET business=-1 WHERE id=%d", GetBusinessData(i, B_OWNER_ID));
		mysql_query(mysql, query, false);

		SetBusinessData(i, B_OWNER_ID, 			0);
		SetBusinessData(i, B_IMPROVEMENTS, 		0);

		SetBusinessData(i, B_EVICTION, 0);

		SetBusinessData(i, B_PRODS, 			0);
		SetBusinessData(i, B_PROD_PRICE,		0);

		SetBusinessData(i, B_BALANCE,			0);
		SetBusinessData(i, B_RENT_DATE,			0);
		SetBusinessData(i, B_ENTER_MUSIC,		0);
		SetBusinessData(i, B_LOCK_STATUS,		false);

		format(query, sizeof query, "DELETE FROM business_gps WHERE bid=%d", i);
		mysql_query(mysql, query, false);

		g_business_gps_init = false;

		CallLocalFunction("UpdateBusinessLabel", "i", i);

		a_id = GetBusinessData(i, B_SQL_ID);
		price = GetBusinessData(i, B_PRICE);

		switch(random(101))
		{
			case 50..100:
			{
				mysql_format(mysql, query, sizeof query, "INSERT INTO auction (price, last_price, price_owner, type, house_id, business_id, garage_id) VALUES (%d, %d, -1, 1, 0, 0, %d, -1)", price, price, a_id - 1);
				mysql_query(mysql, query, false);
			}
		}
	}

	for(new i; i < g_garage_loaded; i ++)
	{
		if(!GetGarageData(i, G_EVICTION)) continue;
		if(GetGarageData(i, G_RENT_DATE) < cur_time) continue;

		format(query, sizeof query, "UPDATE garage SET owner_id='0',lock='0',eviction='0' WHERE id='%d'", GetGarageData(i, G_SQL_ID));
		mysql_query(mysql, query, false);

		SetGarageData(i, G_OWNER_ID,			0);
		SetGarageData(i, G_IMPROVEMENTS,		0);

		SetGarageData(i, G_EVICTION, 0);

		SetGarageData(i, G_RENT_DATE,		0);
		SetGarageData(i, G_LOCK_STATUS,		false);


		CallLocalFunction("UpdateGarageLabel", "i", i);
		UpdateGarage(i);

		a_id = GetGarageData(i, G_SQL_ID);
		price = GetGarageData(i, G_PRICE);

		switch(random(101))
		{
			case 50..100:
			{
				mysql_format(mysql, query, sizeof query, "INSERT INTO auction (price, last_price, price_owner, type, house_id, business_id, garage_id) VALUES (%d, %d, -1, 2, -1, -1, %d)", price, price, a_id - 1);
				mysql_query(mysql, query, false);
			}
		}
	}
	SCM(playerid, 0xCECECEFF, "* Всё неоплаченное имущество слетело!");
	SendClientMessageToAll(0xCECECEFF, "* Всё неоплаченное имущество слетело!");

	return 1;
}
cmd:charity(playerid, params[])
{
	new Cache: result;
	new rows;
	new money;
	static fmt_str[75];
	static string[850];

	cache_set_active(charity_cache_data);
	rows = cache_num_rows();

	string = "Сумма\t\tИмя\n\n{FFFFFF}";
	for(new idx; idx < rows; idx ++)
	{
		cache_get_row(idx, 0, fmt_str);
		money = cache_get_row_int(idx, 1);

		format(fmt_str, sizeof fmt_str, "%d руб\t\t%s\n", money, fmt_str);
  		strcat(string, fmt_str);
	}
	cache_set_active(Cache:0); //unset active cache

	format(fmt_str, sizeof fmt_str, "SELECT SUM(money) as money FROM charity WHERE uid=%d LIMIT 1", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, fmt_str, true);

	money = cache_get_row_int(0, 0);
	cache_delete(result);

	format(fmt_str, sizeof fmt_str, "\n{999999}Сумма Ваших пожертвований: %d руб", money);
	strcat(string, fmt_str);

	return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{00CC00}Топ 25 благотворителей", string, "Закрыть", "");
}

cmd:varkanarkoti(playerid){Dialog(playerid, DIALOG_VARKA_DRUGS, DIALOG_STYLE_MSGBOX,"{"#cW"}Варка наркотиков","{"#cW"}Вы хотите сварить наркотики?\n\n{"#cW"}Стоимость: {FAAC58}100.000 руб\n{"#cW"}Количество наркотиков: {FFFF00}10.","Далее", "Закрыть");}

cmd:showmc(playerid, params[])
{
    if(GetPlayerData(playerid, P_MEDCARD) == 0) return SCM(playerid, 0xFF6600FF, !"У вас нет мед карты");

	extract params -> new to_player; else return SCM(playerid, 0xCECECEFF, !"Используйте: /showmc [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SCM(playerid, 0xFF6600FF, !"Такого игрока нет");

	new Float: to_x, Float: to_y, Float: z;
	GetPlayerPos(to_player, to_x, to_y, z);

	if(to_player == playerid)
	{
	    static fmt_text[200];

		new name_mc[144];

		switch(GetPlayerData(playerid, P_MEDCARD_STATUS))
		{
		    case 0: name_mc = "Не установлен";
		    case 1: name_mc = "Болен(а)";
		    case 2: name_mc = "Имеются психические отклонения";
		    case 3: name_mc = "Полностью здоров(а)";
		}

		new stat_mc[85];
		switch(GetPlayerData(playerid, P_MEDCARD))
		{
		    case 0: stat_mc = "{FF5533}Отсутствует";
		    case 1: stat_mc = "Есть";
		}

		format(fmt_text, sizeof fmt_text, "[[2,[66322,\"%s\",\"%s\",\"%s\",\"Валерий\"]]]",
		GetPlayerNameEx(playerid), name_mc), gettime();
        MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Docs", fmt_text);
		Action(playerid, "просмотривает свою мед. карту", _, false);
	}
	else{
		new Float: dist = GetPlayerDistanceFromPoint(playerid, to_x, to_y, z);
		if(0.5 <= dist <= 1.5) SendPlayerOffer(playerid, to_player, OFFER_TYPE_SHOWMC);
		else SCM(playerid, 0xFF6600FF, !"Вы находитесь слишком далеко от игрока");
	}
	return 1;
}

cmd:steal_cars(playerid)
{
	if(!(TEAM_MAFIA_RUSSIAN <= GetPlayerTeamEx(playerid) <= TEAM_MAFIA_ITALIAN))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вам не доступна данная функция");
    if(!IsPlayerInRangeOfPoint(playerid, 2.0, -2674.4509,2189.0325,1000.9988)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться у компьютера на базе");
	if(GetPVarInt(playerid,"ygnal1") == 1) MoralPacket_2(playerid, s_CefInterface, t_CefShow, "TransportOrder", "[[\"BMW\", 2,\"BMW M8 F92\",1664827000,145000], [\"Mercedes\", 3,\"Mercedes W124 C\",1664827000,250000], [\"Lexus\", 3,\"Lexus IS200\",1664827000,24000], [\"Lamborghini\", 3,\"Lamborghini Uru\",1664827000,115000], [\"Tayota\", 3,\"Tayota Hachirok\",1664827000,18000], [\"UAZ\", 3,\"UAZ Хантер\",1664827000,14000]]");
	else MoralPacket_2(playerid, s_CefInterface, t_CefShow, "TransportOrder", "[[\"BMW\", 2,\"BMW M8 F92\",1664827000,145000], [\"Mercedes\", 3,\"Mercedes W124 C\",1664827000,250000], [\"Lexus\", 3,\"Lexus IS200\",1664827000,24000], [\"Lamborghini\", 3,\"Lamborghini Uru\",1664827000,115000], [\"Tayota\", 3,\"Tayota Hachirok\",1664827000,18000], [\"UAZ\", 3,\"UAZ Хантер\",1664827000,14000]]");
	return 1;
}

cmd:lottery(playerid)
{
    if(GetIteam(playerid, 257) < 1) return SendClientMessage(playerid, 0xFF6600FF, "* У Вас нет лотерейного билета");
	
	//BattlePass_Completingtasks(playerid, 1, 19);
    MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Lottery", "[1, \"Лотерея\"]");
    return 1;
}

cmd:antisklad(playerid){Dialog(playerid, DIALOG_ANTISKLAD, DIALOG_STYLE_MSGBOX,"{"#cW"}Выбор действия","{"#cW"}Вы хотите сдать оружие?\n\n{"#cW"}Вы получите:\n{"#cW"}1. {FFFF00}150.000 рублей\n{"#cW"}2. {FFFF00}Кейс Темные дела","Далее", "Закрыть");}


cmd:attach(playerid, params[])
{
	if(GetIteam(playerid, 4) < 1) return SCM(playerid, 0xCECECEFF, "* У вас нет буксировочного троса. Купить его можно в любом супермаркете!");

	if(!IsPlayerInAnyVehicle(playerid))
	return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в транспорте");
	{
		new Float:pX,Float:pY,Float:pZ;
		GetPlayerPos(playerid,pX,pY,pZ);
		new Float:vX,Float:vY,Float:vZ;
		new Found=0;
		new vid=0;
		GiveIteam(playerid, 4, 0, 1, 0);
		while((vid<MAX_VEHICLES)&&(!Found))
		{
			vid++;
			GetVehiclePos(vid,vX,vY,vZ);
			if((floatabs(pX-vX)<6.0)&&(floatabs(pY-vY)<6.0)&&(floatabs(pZ-vZ)<6.0)&&(vid!=GetPlayerVehicleID(playerid)))
			{
				Found=1;
				if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))) DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
				AttachTrailerToVehicle(vid,GetPlayerVehicleID(playerid));
			}
		}

		if(!Found)
		{
		}
  	}
	return 1;
}

cmd:fcuff(playerid, params[])
{
    if(GetPlayerTeamEx(playerid) != TEAM_FSIN) return SendClientMessage(playerid, 0xFF6600FF, "* Вы не сотрудник ФСИН");
	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /cuff [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок находится слишком далеко");

	if(GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок уже закован в наручники");

	SetPlayerSpecialAction(to_player, SPECIAL_ACTION_CUFFED);
	SetPlayerAttachedObject(to_player, A_OBJECT_SLOT_HAND, 19418, A_OBJECT_BONE_RIGHT_HAND, -0.011, 0.028, -0.022, -15.600012, -33.699977, -81.700035, 0.891999, 1.00, 1.168);
	SetPlayerData(to_player, P_CUFFED, true);

	static fmt_str[90];

	format(fmt_str, sizeof fmt_str, "%s %s надел на %s наручники", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}
cmd:funcuff(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_FSIN) return SendClientMessage(playerid, 0xFF6600FF, "* Вы не сотрудник ФСИН");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /uncuff [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок находится слишком далеко");

	if(!GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок не закован в наручники");

	SetPlayerSpecialAction(to_player, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(to_player, A_OBJECT_SLOT_HAND);
	SetPlayerData(to_player, P_CUFFED, false);

	static fmt_str[90];

	format(fmt_str, sizeof fmt_str, "%s %s снял с %s наручники", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

cmd:fputpl(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_FSIN) return SendClientMessage(playerid, 0xFF6600FF, "* Вы не сотрудник ФСИН");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /putpl [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок находится слишком далеко");

	if(!GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок не закован в наручники");

	new vehicle_id = GetPlayerVehicleID(playerid);
	if(!vehicle_id) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в автомобиле");

	if(!IsPlayerInPoliceCar(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в служебном транспорте");

	new bool: is_there_some_free_places;

	for(new i = 2; i < 3; i++)
	{
		if(IsVehicleSeatOccupied(vehicle_id, i)) continue;
		PutPlayerInVehicle(to_player, vehicle_id, i);
		is_there_some_free_places = true;
		break;
	}

	if(!is_there_some_free_places) return SendClientMessage(playerid, 0xFF6600FF, "* Задние места Вашего автомобиля заняты");

	static fmt_str[90];

	format(fmt_str, sizeof fmt_str, "%s %s посадил %s в машину", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

cmd:asellstall(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
 	 
    extract params -> new i; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /asellstall [номер киоска]");

	if(!(0 <= i <= g_kiosk_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного киоска не существует на сервере");
	static query[256];
	format(query, sizeof query, "UPDATE PlayersMorallwens SET kiosk=-1 WHERE id='%d'", GetKioskData(i, K_OWNER_ID));
	mysql_query(mysql, query, false);

    format(query, sizeof query, "UPDATE kiosk SET owner_id=0,improvements=1,rent=0 WHERE id='%d'", GetKioskData(i, K_SQL_ID));
	mysql_query(mysql, query, false);
	return 1;
}

cmd:asellgarage(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
 	 
    extract params -> new i; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /asellgarage [номер гаража]");

	if(!(0 <= i <= g_garage_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного гаража не существует на сервере");

	static query[256];

	if(GetGarageData(i, G_TYPE) == 1)
	{
		format(query, sizeof query, "UPDATE PlayersMorallwens SET car_slots=4 WHERE id='%d'", GetGarageData(i, G_OWNER_ID));
		mysql_query(mysql, query, false);
	}
	else if(GetGarageData(i, G_TYPE) == 2)
	{
		format(query, sizeof query, "UPDATE PlayersMorallwens SET car_slots=4 WHERE id='%d'", GetGarageData(i, G_OWNER_ID));
		mysql_query(mysql, query, false);
	}
	else if(GetGarageData(i, G_TYPE) == 3)
	{
		format(query, sizeof query, "UPDATE PlayersMorallwens SET car_slots=4 WHERE id='%d'", GetGarageData(i, G_OWNER_ID));
		mysql_query(mysql, query, false);
	}

    SetGarageData(i, G_OWNER_ID, 0);
    SetGarageData(i, G_IMPROVEMENTS, 0);
    SetGarageData(i, G_RENT_DATE, 0);
    CallLocalFunction("UpdateGarageLabel", "i", i);

    format(query, sizeof query, "UPDATE garage SET owner_id=0,improvements=0 WHERE id='%d'", GetGarageData(i, G_SQL_ID));
	mysql_query(mysql, query, false);
	return 1;
}
cmd:addcarsharing(playerid,params[])
{
    new vehicleid;
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new model_id, color_1, color_2, price, type; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /addcarcarsharing [id автомобиля] [цвет 1] [цвет 2] [цена при аренде][тип авто]");

	if((!(15195 <= model_id <= 15202)))  return SendClientMessage(playerid, 0xCECECEFF, "* Вы указали неверный id транспорта, используйте: 15195-15202");
    if(!(0 <= type <= 3)) return SendClientMessage(playerid, 0xFF6600FF, "* Типы авто: 0- Бип Драйв 1- Кар Шеринг , 2- Crown Car, 3 - Wow Drive");
	new Float: pos_xp, Float: pos_yp, Float: pos_zp,Float: angle;

	GetPlayerPos(playerid,pos_xp,pos_yp,pos_zp);

	GetPlayerFacingAngle(playerid, angle);


	static query[220],
		Cache: result;

	format
	(
		query, sizeof query,
		"INSERT INTO carsharing_cars \
		(model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,price,vinil,create_time) \
		VALUES \
		('%d','%d','%d','%f','%f','%f','%f','%d','%d', '%d')",
		model_id,
		color_1,
		color_2,
		pos_xp,
		pos_yp,
		pos_zp,
		angle,
		price,
		type,
		gettime()
	);
	result = mysql_query(mysql, query, true);

	new
		idx;

	idx = GetFreeCarshCarID();

	SetCarshCarData(idx, OC_MODEL_ID, 	model_id);
	SetCarshCarData(idx, OC_COLOR_1, 	color_1);
	SetCarshCarData(idx, OC_COLOR_2, 	color_2);
	SetCarshCarData(idx, OC_VINIL, 		type);


	SetCarshCarData(idx, OC_POS_X, 		pos_xp);
	SetCarshCarData(idx, OC_POS_Y, 		pos_yp);
	SetCarshCarData(idx, OC_POS_Z, 		pos_zp);
	SetCarshCarData(idx, OC_ANGLE, 		angle);


    SetCarshCarData(idx, OC_PRICE, 		price);

	SetCarshCarData(idx, OC_CREATE, 		gettime());
    SetCarshCarData(idx, OC_RENT_OWNER, 		-1);

	vehicleid = CreateVehicle
	(
		GetCarshCarData(idx, OC_MODEL_ID),
		GetCarshCarData(idx, OC_POS_X),
		GetCarshCarData(idx, OC_POS_Y),
		GetCarshCarData(idx, OC_POS_Z),
		GetCarshCarData(idx, OC_ANGLE),
		GetCarshCarData(idx, OC_COLOR_1),
		GetCarshCarData(idx, OC_COLOR_2),
		-1,
		0,
		VEHICLE_ACTION_TYPE_CARSH_CAR,
		idx
	);
	new typeauto[24];
    if(GetCarshCarData(idx, OC_VINIL) == 0) format(typeauto, 11, "Бип Drive");
    if(GetCarshCarData(idx, OC_VINIL) == 1) format(typeauto, 12, "Кар Шеринг");
    if(GetCarshCarData(idx, OC_VINIL) == 2) format(typeauto, 12, "Crown Car");
    if(GetCarshCarData(idx, OC_VINIL) == 3) format(typeauto, 12, "WOW Drive");

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "{20B2AA}Аренда авто '%s' \n\n Транспорт {ffffff}%s (№%d) \n {20B2AA}Статус: {ffffff}свободен\n{20B2AA}Цена за минуту: {ffffff}%d рублей\n\n{20B2AA}Для {ffffff}начала аредны {20B2AA}воспользуйтесь\n приложением в {ffffff}телефоне", typeauto,GetVehicleInfo(GetCarshCarData(idx, OC_MODEL_ID)  , VI_NAME), GetCarshCarData(idx, OC_MODEL_ID), GetCarshCarData(idx, OC_PRICE));
    CreateVehicleLabel(vehicleid, STRING_GLOBAL, 0xFFFFFFFF, 0.0, 0.0, 0.5, 5.0);

	SetVehicleParam(vehicleid, V_LOCK, VEHICLE_PARAM_OFF);


	ChangeVehiclePaintjob(vehicleid, GetCarshCarData(idx, OC_VINIL));


    SendClientMessage(playerid, 0x66CC00FF, "* Вы успешно создали транспорт каршеринга!");
	cache_delete(result);
	return 1;
}
cmd:givemed(playerid, params[])
{
    if(GetPlayerTeamEx(playerid) != TEAM_HOSPITAL) return SendClientMessage(playerid, 0x999999FF, "* Вы не работник больницы");

	extract params -> new to_player; else return SendClientMessage(playerid, 0x999999FF, "* Используйте: /givemed [id]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");
		
	if(GetPlayerMedcarta(to_player) == 1) return SendClientMessage(playerid, 0x999999FF, "* У игрока уже есть мед карта.");

	static fmt_text[100];

	format(fmt_text, sizeof fmt_text, "Врач %s[%d] выдал Вам мед карту", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, 0x6495EDFF, fmt_text);
	
    SetPlayerData(to_player, P_MEDCARTA, 1);
    UpdatePlayerDatabaseInt(to_player, "medcarta", 1);

	format(fmt_text, sizeof fmt_text, "Вы выдали мед карту %s[%d]", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, 0x6495EDFF, fmt_text);

	return 1;
}
cmd:agivevb(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new to_player; else return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /agivevb [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	static fmt_text[100];

	format(fmt_text, sizeof fmt_text, "Aдминистратор %s[%d] выдал Вам военный билет", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, 0x6495EDFF, fmt_text);

    SetPlayerData(to_player, P_VOEN, 1);
    UpdatePlayerDatabaseInt(to_player, "voennik", 1);

	format(fmt_text, sizeof fmt_text, "Вы выдали военный билет %s [%d]", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, 0x6495EDFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "[А] Администратор %s [%d] выдал военный билет игроку %s [%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}
cmd:givevb(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_HOSPITAL)
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");

	extract params -> new to_player; else return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /givevb [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	static fmt_text[100];

	format(fmt_text, sizeof fmt_text, "Генерал %s[%d] выдал Вам военный билет", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, 0x6495EDFF, fmt_text);

    SetPlayerData(to_player, P_VOEN, 1);
    UpdatePlayerDatabaseInt(to_player, "voennik", 1);

	format(fmt_text, sizeof fmt_text, "Вы выдали военный билет %s[%d]", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, 0x6495EDFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s выдал военный билет %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}
cmd:takevb(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_HOSPITAL)
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");

	extract params -> new to_player; else return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /takevb [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	static fmt_text[100];

	format(fmt_text, sizeof fmt_text, "Генерал %s[%d] забрал у Вас военный билет", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, 0x6495EDFF, fmt_text);
	
    SetPlayerData(to_player, P_VOEN, 0);
    UpdatePlayerDatabaseInt(playerid, "voennik", 0);

	format(fmt_text, sizeof fmt_text, "Вы забрали военный билет %s[%d]", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, 0x6495EDFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s забрал военный билет %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}
cmd:offawarn(playerid, params[])
{
    if (GetPlayerAdminEx(playerid) < 6) return 1;
    else if (admin_logged[playerid] == false)
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
    if (GetPlayerData(playerid, P_BUYADMIN) == 1) 
        return SendClientMessage(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");
    if (!strlen(params)) 
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /offawarn [ник игрока] [причина]");
    extract params -> new string:player_name[21], string:reason[32]; 
    if (IsPlayerConnected(GetPlayerID(player_name)))
        return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем находится на сервере");
    static query[144],
        Cache: result,
        rows,
        uid,
        admin,
        awarn;
    mysql_format(mysql, query, sizeof query, "SELECT id, admin, awarn FROM PlayersMorallwens WHERE name='%e'", player_name);
    result = mysql_query(mysql, query, true);
    rows = cache_num_rows();
    if (rows) {
        uid = cache_get_row_int(0, 0);
        admin = cache_get_row_int(0, 1);
        awarn = cache_get_row_int(0, 2);
    }
    cache_delete(result);
    if (admin < 1)
    	return SendClientMessage(playerid, COLOR_FAMILY, "* Игрок не является администратором!");
    if (admin >= GetPlayerAdminEx(playerid)) 
        return SendClientMessage(playerid, 0xCECECEFF, "* Данный администратор выше или равен вашему рангу.");
    if (g_AdminWarnTimer[playerid] == 0 || (gettime() - g_AdminWarnedTick[playerid]) >= 10) {
        g_AdminWarnCount[playerid] = 0; 
        g_AdminWarnTimer[playerid] = gettime();
    }
    g_AdminWarnCount[playerid]++; 
    g_AdminWarnedTick[playerid] = gettime(); 
    if (g_AdminWarnCount[playerid] > 3) {
        SetPlayerData(playerid, P_ADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "admin", 0);
		SetPlayerData(playerid, P_BUYADMIN, 0);
		UpdatePlayerDatabaseInt(playerid, "buyadmin", 0);		
        return SendClientMessage(playerid, 0xFF0000AA, "{F81414}[Анти-Слив] {F3FF02}Ваша админка была снята за слишком большое количество выговоров за короткое время!");
    }
    format(query, sizeof query, "UPDATE PlayersMorallwens SET awarn=%d WHERE id=%d", awarn + 1, uid);
    mysql_query(mysql, query, false);
    static string[244];
    format(string, sizeof string, "A: %s[%d] выдал выговор администратору оффлайн %s по причине: %s (%d/3)", 
           GetPlayerNameEx(playerid), playerid, player_name, reason, awarn + 1);
    SendMessageToAdmins(string, 0xFF5533FF);
    if (awarn + 1 > 2) {
        format(string, sizeof string, "A: Администратор %s был снят с должности администратора по причине: 3/3 выговоров", player_name);
        SendMessageToAdmins(string, 0xFF5533FF);
        format(query, sizeof query, "UPDATE PlayersMorallwens SET awarn=0, admin=0 WHERE id=%d", uid);
        mysql_query(mysql, query, false);
    }
    return true;
}
cmd:awarn(playerid, params[])
{
    if (GetPlayerAdminEx(playerid) < 11) return 1;
    if (admin_logged[playerid] == false)
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
    if (GetPlayerData(playerid, P_BUYADMIN) == 1)
        return SendClientMessage(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");
    if (!strlen(params))
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /awarn [id игрока] [причина]");
    extract params -> new to_player, string:reason[32]; 
    if (!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");
    if (GetPlayerAdminEx(playerid) < GetPlayerAdminEx(to_player))
        return SendClientMessage(playerid, 0xCECECEFF, "* Вы пытаетесь выдать выговор администратору выше вас по рангу!");
    if (GetPlayerData(to_player, P_ADMIN) < 1 && GetPlayerData(to_player, P_BUYADMIN) < 1)
   		 return SendClientMessage(playerid, 0xCECECEFF, "* Игрок не является администратором!");
    if (g_AdminWarnTimer[playerid] == 0 || (gettime() - g_AdminWarnedTick[playerid]) >= 10) {
        g_AdminWarnCount[playerid] = 0; 
        g_AdminWarnTimer[playerid] = gettime();
    }
    g_AdminWarnCount[playerid]++; 
    g_AdminWarnedTick[playerid] = gettime(); 
    if (g_AdminWarnCount[playerid] > 3) {
        SetPlayerData(playerid, P_ADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "admin", 0);
		SetPlayerData(playerid, P_BUYADMIN, 0);
		UpdatePlayerDatabaseInt(playerid, "buyadmin", 0);		
        return SendClientMessage(playerid, 0xFF0000AA, "{F81414}[Анти-Слив] {F3FF02}Ваша админка была снята за слишком большое количество выдачи предупреждений за короткое время!");
    }
    SetPlayerData(to_player, P_AWARN, GetPlayerData(to_player, P_AWARN) + 1);
    UpdatePlayerDatabaseInt(to_player, "awarn", GetPlayerData(to_player, P_AWARN));
    static string[244];
    format(string, sizeof(string), "A: %s[%d] выдал выговор администратору %s[%d] по причине: %s (%d/3)",
           GetPlayerNameEx(playerid), playerid,
           GetPlayerNameEx(to_player), to_player, reason, GetPlayerData(to_player, P_AWARN));
    SendMessageToAdmins(string, 0xFF5533FF);
    if (GetPlayerData(to_player, P_AWARN) > 2) {
        SendClientMessage(to_player, COLOR_BLUE, "A: Вы были сняты с поста администратора (3/3)");
        UpdatePlayerDatabaseInt(to_player, "awarn", 0);
        UpdatePlayerDatabaseInt(to_player, "admin", 0);
        SetPlayerData(to_player, P_AWARN, 0);
        SetPlayerData(to_player, P_ADMIN, 0);
    } else {
        SendClientMessage(to_player, COLOR_BLUE, "A: Вы получили выговор администратора!");
    }
    return true;
}

cmd:unawarn(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

    if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /unawarn [id игрока] [причина]");
    extract params -> new to_player, string:reason[32]; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /unawarn [id игрока] [причина]");
    if(GetPlayerData(to_player, P_ADMIN) < 1 && GetPlayerData(to_player, P_BUYADMIN) < 1)
    	return SendClientMessage(playerid, COLOR_FAMILY, "* Игрок не является администратором!");

	if(GetPlayerData(to_player, P_AWARN) < 1) return SendClientMessage(playerid, COLOR_FAMILY, "* У администратора отсутствуют выговоры!");

	if(GetPlayerAdminEx(playerid) < GetPlayerAdminEx(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы пытаетесь выдать выговор администратору выше вас по рангу!");

    SetPlayerData(to_player, P_AWARN, GetPlayerData(to_player, P_AWARN)-1);
    UpdatePlayerDatabaseInt(to_player, "awarn", GetPlayerData(to_player, P_AWARN));

	static string[244];
	format(string, sizeof(string), "A: %s[%d] снял выговор администратору %s[%d] по причине: %s (%d/3)", GetPlayerNameEx(playerid), playerid,
	GetPlayerNameEx(to_player), to_player, reason, GetPlayerData(to_player, P_AWARN));
	SendMessageToAdmins(string, 0xFF5533FF);
 	SendClientMessage(to_player, COLOR_BLUE, "Администратор снял вам один выговор");
    return true;
}

cmd:awarns(playerid, params[])
{
  if(GetPlayerAdminEx(playerid) < 1 && GetPlayerBuyAdminEx(playerid) < 1) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

   static query[250];
   format(query, sizeof query, "Количество предупреждений: %d из 3", GetPlayerData(playerid, P_AWARN));
   SendClientMessage(playerid, 0xFF6600FF, query);
   SendClientMessage(playerid, 0xFF6600FF, "* После 3 предупреждения вас снимут с поста Администратора");
   return 1;
}

cmd:warns(playerid)
{
   static query[250];
   format(query, sizeof query, "Количество предупреждений: %d из 3", GetPlayerData(playerid, P_WARN));
   SendClientMessage(playerid, 0xFF6600FF, query);
   SendClientMessage(playerid, 0xFF6600FF, "* После 3 предупреждения Ваш аккаунт будет забанен на 10 дней");
   return 1;
}

cmd:sscar(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 7) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

   new vehicles_count;

    for(new i = 1; i < MAX_VEHICLES; i++)
    {
        if(!IsValidVehicle(i)) continue;
        else if(IsVehicleOccupied(i)) continue;
        else if(IsTrailerAttachedToAnyVehicle(i)) continue;
        SetVehicleToRespawn(i);
        vehicles_count++;
    }

    static fmt_text[144];
    format(fmt_text, sizeof fmt_text, "{FFFFFF}"SERVER_NAME_RP"{FFFFFF}:Вы зареспавнили весь незанятый транспорт. Всего зареспавнено: %d шт.", vehicles_count);
    SendClientMessage(playerid, -1, fmt_text);

    if(GetPlayerAdminEx(playerid) <= 11)
    {
        format(fmt_text, sizeof fmt_text, "A: %s[%d] зареспавнил весь незанятый транспорт", GetPlayerNameEx(playerid), playerid);
        SendMessageToAdmins(fmt_text, 0x999999FF);
    }
    return 1;
}

cmd:setprefix(playerid, params[])
{
	if(CheckAdmin(playerid, 11)) return 1;

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");
	
	
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, 0xCECECEFF, !"Используйте: /setprefix [id игрока]");
	SetPVarInt(playerid,"PrefixID",params[0]);
	Dialog(playerid, 1234, DIALOG_STYLE_LIST, "Выдача префикс", "Выдать префикс\nЗабрать префикс", "Выбрать", "Закрыть");
	return 1;
}

cmd:spanel(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new index = GetVehicleData(vehicleid, V_ACTION_ID);

	if(GetOwnableCarData(index, OC_PNEWMA) != 1 || !IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "* У Вас не установлена пневматическая подвеска.");
	
	MoralPacket_1(playerid, s_CefInterface, t_CefShow,"TuningPlayerPneuma");

	return 1;
}
cmd:ytskin(playerid, params[])
{
    if(GetPlayerYAdminEx(playerid) < 1) return 1;

	extract params -> new to_player, skin_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /skin [id игрока] [id скина]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(skin_id != -1)
		SetPlayerSkin(to_player, skin_id);
	else
		SetPlayerSkin(to_player, GetPlayerSkinEx(to_player));

	static fmt_text[100];

	format(fmt_text, sizeof fmt_text, "Ютубер %s выдал Вам %s скин", GetPlayerNameEx(playerid), skin_id != -1 ? "временный" : "прежний");
	SendClientMessage(to_player, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "Вы выдали игроку %s %s скин", GetPlayerNameEx(to_player), skin_id != -1 ? "временный" : "прежний");
	SendClientMessage(playerid, -1, fmt_text);

	if(GetPlayerYAdminEx(playerid) >= 1)
	{
		if(skin_id != -1)
			format(fmt_text, sizeof fmt_text, "[YT] Ютубер %s[%d] выдал %s[%d] скин №%d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, skin_id);
		else
			format(fmt_text, sizeof fmt_text, "[YT] Ютубер %s[%d] выдал %s[%d] прежний скин", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	return 1;
}

cmd:kinfo(playerid, params[])
{
	static query[115],
		Cache: result,
		rows,
		balance,
		team,
		list[sizeof query * 25 + 60] = "Организация\t\t\tБаланс\n";


	mysql_format(mysql, query, sizeof query, "SELECT * FROM bank_org");
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	for(new i; i < rows; i ++)
	{

		balance = cache_get_field_content_int(i, "team_bank");
		team = cache_get_field_content_int(i, "team_id");

		format
		(
			query, sizeof query,
			"\n{"#cW"}%s%s{CECECE}%d руб.",
			GetTeamName(team),
			strlen(GetTeamName(team)) > 13 ? "\t" : "\t\t\t",
	        balance
		);

		strcat(list, query);
	}

	cache_delete(result);

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_TABLIST_HEADERS, "{"#cGold"}Баланс организаций", list, "Закрыть", "");

	return 1;
}
cmd:kazna_log(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3) return 1;

	if(!strlen(params))
		return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /kazna_log [id фракции]");

	extract params -> new id;

	static fmt_str[128];
	new Cache: result;
	new rows;

	format(fmt_str, sizeof fmt_str, "SELECT FROM_UNIXTIME(time,'%%Y-%%m-%%d') AS date FROM bank_org_log WHERE team_id=%d ORDER BY id DESC LIMIT 10", id);
	result = mysql_query(mysql, fmt_str);

	rows = cache_num_rows();

	static text[900] = "{"#cW"}";
	new day, month, year;

	for(new idx; idx < rows; idx ++)
	{
		cache_get_row(idx, 0, fmt_str);
		sscanf(fmt_str, "P<->ddd", year, month, day);

		format(fmt_str, sizeof fmt_str, "%d %s %d г.\t\t%s\n", day, GetMonthName(month), year, fmt_str);
		strcat(text, fmt_str);
	}
	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{"#cGold"}Последние 10 операций", text, "Вернуться", "");

	cache_delete(result);

	return 1;
}

cmd:bank_log(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 5) return 1;

	if(!strlen(params))
		return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /bank_log [id счета]");

	extract params -> new id;

	static fmt_str[128];
	new Cache: result;
	new rows;

	static desc[128];

	format(desc, sizeof desc, "{"#cGold"}История операций счета №%d", id);

	format(fmt_str, sizeof fmt_str, "SELECT FROM_UNIXTIME(time,'%%Y-%%m-%%d') AS date,description FROM bank_accounts_log WHERE acc_id=%d ORDER BY id DESC LIMIT 10", id);
	result = mysql_query(mysql, fmt_str);

	rows = cache_num_rows();

	if(rows)
	{
		static text[900] = "{"#cW"}";
		new day, month, year;

		for(new idx; idx < rows; idx ++)
		{
			cache_get_row(idx, 0, fmt_str);
			sscanf(fmt_str, "P<->ddd", year, month, day);

			cache_get_row(idx, 1, fmt_str);

			format(fmt_str, sizeof fmt_str, "%d %s %d г.\t\t%s\n", day, GetMonthName(month), year, fmt_str);
			strcat(text, fmt_str);
		}
		Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, desc, text, "Закрыть", "");
	}
	else Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, desc, "{"#cW"}История операций счета пуста", "Закрыть", "");

	cache_delete(result);

	return 1;
}
cmd:admins(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1 && GetPlayerYAdminEx(playerid) < 3 && GetPlayerPremium(playerid) < 1) return 1;

	new count;

	SCM(playerid, 0xFFFFFFFF, !"Администрация онлайн:");

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;
		else if(1 > GetPlayerAdminEx(i)) continue;
		else if(IsMantoKiss(i)) continue; 

		if(g_player[i][P_MYPREFIX] && g_player[i][P_MYPREFIX_COLOR])
		{
			if(IsPlayerAFK(i))
				SCMF(playerid, -1, "{%s}[%s] {FFFFFF}%s [%d] (LVL %d) {FFFFFF}AFK [%02d:%02d]", g_player[i][P_MYPREFIX_COLOR], g_player[i][P_MYPREFIX], GetPlayerNameEx(i), i, GetPlayerAdminEx(i), (floatround(GetPlayerData(i, P_AFK_TIME) / 60) % 60), GetPlayerData(i, P_AFK_TIME) % 60);
			
			else if(GetPlayerSpectateData(i, S_PLAYER) != -1)
				SCMF(playerid, -1, "{%s}[%s] {FFFFFF}%s [%d] (LVL %d) {FFFFFF}/sp > %d", g_player[i][P_MYPREFIX_COLOR], g_player[i][P_MYPREFIX], GetPlayerNameEx(i), i, GetPlayerAdminEx(i), GetPlayerSpectateData(i, S_PLAYER));

			else
				SCMF(playerid, -1, "{%s}[%s] {FFFFFF}%s [%d] (LVL %d)", g_player[i][P_MYPREFIX_COLOR], g_player[i][P_MYPREFIX], GetPlayerNameEx(i), i, GetPlayerAdminEx(i));

			count++;
		}
		if(!g_player[i][P_MYPREFIX] && !g_player[i][P_MYPREFIX_COLOR])
		{
			if(IsPlayerAFK(i))
				SCMF(playerid, -1, "{FFFFFF}%s [%d] (LVL %d) {FFFFFF}AFK [%02d:%02d]", GetPlayerNameEx(i), i, GetPlayerAdminEx(i), (floatround(GetPlayerData(i, P_AFK_TIME) / 60) % 60), GetPlayerData(i, P_AFK_TIME) % 60);

			else if(GetPlayerSpectateData(i, S_PLAYER) != -1)
				SCMF(playerid, -1, "{FFFFFF}%s [%d] (LVL %d) {FFFFFF}/sp > %d", GetPlayerNameEx(i), i, GetPlayerAdminEx(i), GetPlayerSpectateData(i, S_PLAYER));

			else
				SCMF(playerid, -1, "{FFFFFF}%s [%d] (LVL %d)", GetPlayerNameEx(i), i, GetPlayerAdminEx(i));

			count++;
		 }
	}
	SCMF(playerid, 0xFFFFFFFF, "Всего администрации в сети: %d", count);
	return 1;
}
cmd:adminlist(playerid)
{
	if(GetPlayerAdminEx(playerid) < 5 && GetPlayerBuyAdminEx(playerid) < 5) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	page_cars[playerid] = 1;
	type_page_cars[playerid] = 7;
	ShowAdminLists(playerid, page_cars[playerid]);
	return true;
}

cmd:aefir(playerid)
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");


    switch(GetPVarInt(playerid, "efir"))
    {
        case 0:
        {
            SetPVarInt(playerid, "efir", 1);
            SendClientMessage(playerid, 0x33FF33AA, "Вы успешно подключились к эфиру");
            SendClientMessage(playerid, 0x33FF33AA, "Отправить сообщение в эфире: {"#cW"}/t");
        }
        case 1:
        {
            SetPVarInt(playerid, "efir", 0);
            SendClientMessage(playerid, 0xFF6666FF, "Вы успешно отключились от эфира");
        }
    }

    return 1;
}
cmd:aedit(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");


	if(!g_advert_created) return SendClientMessage(playerid, 0xCECECEFF, "* Нет объявлений для редактирования");

	static fmt_text[360],
		bool: ad_is_found;

	for(new idx; idx < g_advert_created; idx ++)
	{
		if(GetAdvertData(idx, A_EDIT) || GetAdvertData(idx, A_CREATOR) == INVALID_PLAYER_ID) continue;
		format
		(
			fmt_text, sizeof fmt_text,
			"{FFFFFF}Отправитель: %s\n\nТекст:\n{FFCD00}%s\n\n"\
			"{FFFFFF}Для редактирования объявления введите новый текст и нажмите 'Отправить'.\n"\
			"Если редактирование объявлению не нужно, оставьте поле пустым.",
			GetPlayerNameEx(GetAdvertData(idx, A_CREATOR)), GetAdvertData(idx, A_TEXT)
		);
		Dialog(playerid, DIALOG_ADVERT_EDIT, DIALOG_STYLE_INPUT, "{00CC00}Публикация объявления", fmt_text, "Отправить", "Отклонить");
		SetAdvertData(idx, A_EDIT, true);
		SetPVarInt(playerid, "advert_id", idx);
		ad_is_found = true;
		break;
	}
	if(!ad_is_found) return SendClientMessage(playerid, 0xCECECEFF, "* Нет объявлений для редактирования");
	return 1;
}
cmd:at(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!GetPVarInt(playerid, "efir")) return SendClientMessage(playerid, 0x999999FF, "* Вы не подключены к радио-эфиру");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /at [текст]");

	static fmt_text[144];

	format(fmt_text, sizeof fmt_text, "[ТРК «Ритм»] %s: %s", GetPlayerNameEx(playerid), params);
	SendClientMessageToAll(0x6666FFFF, fmt_text);
	return 1;
}

cmd:stili(playerid)
{
	Dialog(playerid, DIALOG_SHK_ST, DIALOG_STYLE_LIST, "{ffd83d}Выберите стиль",
	"1.Стиль 'Бокс'\t{FF8C00}250.000р\n\
	2.Стиль 'Кунг-фу'\t{FF8C00}150.000р\n\
	3.Стиль 'СКолена'\t{FF8C00}100.000р\n\
	4.Стиль 'Проход в ноги'\t{FF8C00}50.000р\n\
	5.Стиль 'Локтем'\t{FF8C00}200.000р\n\
	6.Удалить стили",
	"Выучить", "Закрыть");
	return 1;
}

cmd:fstyle(playerid)
{
	Dialog(playerid, DIALOG_F_STYLE, DIALOG_STYLE_LIST, "{ffd83d}Выберите стиль",
	"1. Выбрать стиль - {FF8C00}'Бокс'\n"\
	"2. Выбрать стиль - {FF8C00}'Кунгфу'\n"\
	"3. Выбрать стиль - {FF8C00}'СКолена'\n"\
	"4. Выбрать стиль - {FF8C00}'Проход в ноги'\n"\
	"5. Выбрать стиль - {FF8C00}'Локтем'",
	"Выбрать", "Закрыть");
	return 1;
}

cmd:styleremove(playerid)
{
	Dialog(playerid, DIALOG_REMOVE_STYLE, DIALOG_STYLE_LIST, "{ffd83d}Выберите стиль",
	"1. Удалить стиль - {FF8C00}'Бокс'\n"\
	"2. Удалить стиль - {FF8C00}'Кунгфу'\n"\
	"3. Удалить стиль - {FF8C00}'СКолена'\n"\
	"4. Удалить стиль - {FF8C00}'Проход в ноги'\n"\
	"5. Удалить стиль - {FF8C00}'Локтем'",
	"Удалить", "Закрыть");
	return 1;
}
cmd:info_world(playerid)
{
	if(GetPlayerAdminEx(playerid) < 8) return 1;
		else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "Вы не авторизированы, для этого используйте /alogin");

	SCMF(playerid, -1, "world %d, interior %d, business %d, house %d, garage %d", GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), GetPlayerInBiz(playerid), GetPlayerInHouse(playerid), GetPlayerInGarage(playerid));
	return 1;
}
cmd:info_work(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 7 && GetPlayerBuyAdminEx(playerid) < 7) return 1;
	static fmt_msg[148];
	format(fmt_msg, sizeof fmt_msg, "{ffffff}Металла на шахте: {FFD700}%d {ffffff}Руды на шахте: {FFD700}%d {ffffff}Нареплавке на шахте: {FFD700}%d", GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT),GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT),GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI, R_AMOUNT));
	SendClientMessage(playerid, -1, fmt_msg);
	format(fmt_msg, sizeof fmt_msg, "{ffffff}Металла на заводе: {FFD700}%d {ffffff}Топлива на заводе: {FFD700}%d {ffffff}Продуктов на заводе: {FFD700}%d", GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT),GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT),GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT));
	SendClientMessage(playerid, -1, fmt_msg);
	format(fmt_msg, sizeof fmt_msg, "{ffffff}Топлива на нефтезаводе: {FFD700}%d {ffffff}Дерево на лесопилке: {FFD700}%d", GetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_AMOUNT),GetRepositoryData(REPOSITORY_TYPE_SAWMILL, REPOSITORY_ACTION_SAWMILL_WOOD, R_AMOUNT));
	SendClientMessage(playerid, -1, fmt_msg);
	format(fmt_msg, sizeof fmt_msg, "{ffffff}Металла на складе Армии: {FFD700}%d {ffffff}Потрон на складе Армии: {FFD700}%d", GetRepositoryData(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_METAL, R_AMOUNT),GetRepositoryData(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_AMMO, R_AMOUNT));
	SendClientMessage(playerid, -1, fmt_msg);
	return 1;
}

cmd:give_work(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!strlen(params))
	{
		SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /give_work [id склада] [кол-во]");

		SendClientMessage(playerid, 0xCECECEFF, "* 1 - Металл на шахте");
		SendClientMessage(playerid, 0xCECECEFF, "* 2 - Руда на шахте");
		SendClientMessage(playerid, 0xCECECEFF, "* 3 - На переплавке на шахте");
		SendClientMessage(playerid, 0xCECECEFF, "* 4 - Металл на заводе");
		SendClientMessage(playerid, 0xCECECEFF, "* 5 - Топливо на заводе");
		SendClientMessage(playerid, 0xCECECEFF, "* 6 - Продукты на заводе");
		SendClientMessage(playerid, 0xCECECEFF, "* 7 - Топливо на нефтезаводе");
		SendClientMessage(playerid, 0xCECECEFF, "* 8 - Металл на складе Армии");
		SendClientMessage(playerid, 0xCECECEFF, "* 9 - Патроны на складе Армии");
		SendClientMessage(playerid, 0xCECECEFF, "* 10 - Дерево на лесопилке");


		return 1;
	}
	extract params -> new sklad_id, kolvo;
	if(!(1 <= sklad_id <= 10)) return SendClientMessage(playerid, 0x999999FF, "* Неверный идентификатор id склада");
	if(!(1 <= kolvo <= 100000)) return SendClientMessage(playerid, 0x999999FF, "* Неверный идентификатор количества(до 100000)");
	switch(sklad_id)
	{
		case 1:
		{
			SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT, kolvo);
			UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL);
			SaveRepository();
		}
		case 2:
		{
			SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT, kolvo);
			UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE);
			SaveRepository();		}
		case 3:
		{
			SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI, R_AMOUNT, kolvo);
			UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI);
			SaveRepository();
		}
		case 4:
		{
			SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT, kolvo);
			UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL);
			SaveRepository();
		}
		case 5:
		{
			SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT, kolvo);
			UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL);
			SaveRepository();
		}
		case 6:
		{
			SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT, kolvo);
			UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD);
			SaveRepository();
		}
		case 7:
		{
			SetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_AMOUNT, kolvo);
			UpdateRepository(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F);
			SaveRepository();
		}
		case 8:
		{
			SetRepositoryData(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_METAL, R_AMOUNT, kolvo);
			UpdateRepository(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_METAL);
			SaveRepository();
		}
		case 9:
		{
			SetRepositoryData(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_AMMO, R_AMOUNT, kolvo);
			UpdateRepository(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_AMMO);
			SaveRepository();
		}
		case 10:
		{
			SetRepositoryData(REPOSITORY_TYPE_SAWMILL, REPOSITORY_ACTION_SAWMILL_WOOD, R_AMOUNT, kolvo);
			UpdateRepository(REPOSITORY_TYPE_SAWMILL, REPOSITORY_ACTION_SAWMILL_WOOD);
			SaveRepository();
		}
	}
	return 1;

}

cmd:givefstyle(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!strlen(params))
	{
		SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givefstyle [id игрока] [id стиля]");

		SendClientMessage(playerid, 0xCECECEFF, "* 1 - Стиль боя 'Бокс'");
		SendClientMessage(playerid, 0xCECECEFF, "* 2 - Стиль боя 'Кунгфу'");
		SendClientMessage(playerid, 0xCECECEFF, "* 3 - Стиль боя 'СКолена'");
		SendClientMessage(playerid, 0xCECECEFF, "* 4 - Стиль боя 'Проход в ноги'");
		SendClientMessage(playerid, 0xCECECEFF, "* 5 - Стиль боя 'Локтем'");


		return 1;
	}
	extract params -> new to_player, cmd_id;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(playerid)) return SendClientMessage(playerid,0xFF6600FF, "Такого игрока нет");
	if(!(1 <= cmd_id <= 5)) return SendClientMessage(playerid, 0x999999FF, "* Неверный идентификатор стиля боя");
	static fmt_text[200];
	switch(cmd_id)
	{
		case 1:
		{
			SetPlayerData(to_player, P_STYLE_1, GetPlayerData(to_player, P_STYLE_1) ^ 1);
			UpdatePlayerDatabaseInt(to_player, "style1", GetPlayerData(to_player, P_STYLE_1));

			format(fmt_text, sizeof fmt_text, "Администратор %s[%d] %s стиль боя 'Бокс'", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_STYLE_1) ? "выдал Вам" : "забрал у Вас");
			SendClientMessage(to_player, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "Вы %s %s[%d] стиль боя 'Бокс'", GetPlayerData(to_player, P_STYLE_1) ? "выдали" : "забрали у", GetPlayerNameEx(to_player), to_player);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);
		}
		case 2:
		{
			SetPlayerData(to_player, P_STYLE_2, GetPlayerData(to_player, P_STYLE_2) ^ 1);
			UpdatePlayerDatabaseInt(to_player, "style2", GetPlayerData(to_player, P_STYLE_2));

			format(fmt_text, sizeof fmt_text, "Администратор %s[%d] %s стиль боя 'Кунгфу'", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_STYLE_2) ? "выдал Вам" : "забрал у Вас");
			SendClientMessage(to_player, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "Вы %s %s[%d] стиль боя 'Кунгфу'", GetPlayerData(to_player, P_STYLE_2) ? "выдали" : "забрали у", GetPlayerNameEx(to_player), to_player);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);
		}
		case 3:
		{
			SetPlayerData(to_player, P_STYLE_3, GetPlayerData(to_player, P_STYLE_3) ^ 1);
			UpdatePlayerDatabaseInt(to_player, "style3", GetPlayerData(to_player, P_STYLE_3));

			format(fmt_text, sizeof fmt_text, "Администратор %s[%d] %s стиль боя 'СКолена'", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_STYLE_3) ? "выдал Вам" : "забрал у Вас");
			SendClientMessage(to_player, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "Вы %s %s[%d] стиль боя 'СКолена'", GetPlayerData(to_player, P_STYLE_3) ? "выдали" : "забрали у", GetPlayerNameEx(to_player), to_player);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);
		}
		case 4:
		{
			SetPlayerData(to_player, P_STYLE_4, GetPlayerData(to_player, P_STYLE_4) ^ 1);
			UpdatePlayerDatabaseInt(to_player, "style4", GetPlayerData(to_player, P_STYLE_4));

			format(fmt_text, sizeof fmt_text, "Администратор %s[%d] %s стиль боя 'Проход в ноги'", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_STYLE_4) ? "выдал Вам" : "забрал у Вас");
			SendClientMessage(to_player, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "Вы %s %s[%d] стиль боя 'Проход в ноги'", GetPlayerData(to_player, P_STYLE_4) ? "выдали" : "забрали у", GetPlayerNameEx(to_player), to_player);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);
		}
		case 5:
		{
			SetPlayerData(to_player, P_STYLE_5, GetPlayerData(to_player, P_STYLE_5) ^ 1);
			UpdatePlayerDatabaseInt(to_player, "style5", GetPlayerData(to_player, P_STYLE_5));

			format(fmt_text, sizeof fmt_text, "Администратор %s[%d] %s стиль боя 'Локтем'", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_STYLE_5) ? "выдал Вам" : "забрал у Вас");
			SendClientMessage(to_player, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "Вы %s %s[%d] стиль боя 'Локтем'", GetPlayerData(to_player, P_STYLE_5) ? "выдали" : "забрали у", GetPlayerNameEx(to_player), to_player);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);
		}

		default: return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givefstyle [id игрока] [id стиля]");

	}
	return 1;
}
cmd:asellhouse(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
 	 
    extract params -> new houseid; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /asellhouse [номер дома]");

	if(!(0 <= houseid <= g_house_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного дома не существует на сервере");
	static query[256];
	SetHouseData(houseid, H_IMPROVEMENTS,	0);

	SetHouseData(houseid, H_RENT_DATE,		0);
	SetHouseData(houseid, H_LOCK_STATUS,	false);
	SetHouseData(houseid, H_OWNER_ID,	0);
	
	CallLocalFunction("EvictHouseRentersAll", "i", houseid);
	format(query, sizeof query, "UPDATE houses SET owner_id=0 WHERE id = %d", GetHouseData(houseid, H_SQL_ID));
	mysql_query(mysql, query, false);
	

	UpdateHouse(houseid);

	HouseHealthInit(houseid);
	HouseStoreInit(houseid);
	if(houseid != -1)
	{
		CallLocalFunction("EntranceStatusInit", "i", houseid);
	}
	return 1;
}

cmd:asellbiz(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
 	 

    extract params -> new bizid; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /asellbiz [номер бизнеса]");

	if(!(0 <= bizid <= g_business_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного бизнеса не существует на сервере");
	static query[256];

    SetBusinessData(bizid, B_OWNER_ID, 	0);

	SetBusinessData(bizid, B_IMPROVEMENTS, 	0);

	SetBusinessData(bizid, B_PRODS, 			0);
	SetBusinessData(bizid, B_PROD_PRICE,		0);

	SetBusinessData(bizid, B_BALANCE,			0);
	SetBusinessData(bizid, B_RENT_DATE,		0);
	SetBusinessData(bizid, B_ENTER_MUSIC,		0);
	SetBusinessData(bizid, B_LOCK_STATUS,	false);

	format(query, sizeof query, "UPDATE PlayersMorallwens SET business='-1' WHERE id='%d'", GetBusinessData(bizid, B_OWNER_ID));
	mysql_query(mysql, query, false);
	format(query, sizeof query, "UPDATE business SET owner_id = 0 WHERE id = %d", GetBusinessData(bizid, B_SQL_ID));
	mysql_query(mysql, query, false);

	format(query, sizeof query, "DELETE FROM business_gps WHERE bid=%d", bizid);
	mysql_query(mysql, query, false);

	BusinessHealthPickupInit(bizid);
	g_business_gps_init = false;
	CallLocalFunction("UpdateBusinessLabel", "i", bizid);
	return 1;
}
cmd:buypack(playerid)
{
	Pack(playerid);
}
cmd:sellmygarage(playerid, params[])
{
	if(GetPlayerLevel(playerid) < 2)
		return SendClientMessage(playerid, 0xFF6600FF, "* Этим можно пользоваться со 2 уровня");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /sellmygarage [id игрока] [стоимость]");

	extract params -> new to_player, price;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(price < 1)
		return SendClientMessage(playerid, 0xFF6600FF, "* Укажите стоимость продажи");
	
	if((GetPlayerOwnableGarage(to_player) + 1) > GetPlayerGarageSlots(to_player)) 
		return SendClientMessage(playerid, 0x3399FFFF, "* Игрок уже имеете максимально количество гаражей.");

	if(!GetILPlayerInt(GetPlayerMoneyEx(to_player), price))
		return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока нет такой суммы");

	SetPVarInt(playerid, "Sellprice", price);
	SetPVarInt(playerid, "to_player", to_player);

	static query[94],
		Cache: result,
		biz_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM garage WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();

	if(!rows) return SendClientMessage(playerid, 0x999999FF, "* У вас не одного гаража во владении.");

	string_dialog[0] = EOS;
	for(new i = 0; i < rows; i ++)
	{
		biz_id = cache_get_field_content_int(i, "id");

		format(query, sizeof query, "{FFFFFF}-Гараж: %d\n", biz_id);

		strcat(string_dialog, query);
		SetPlayerListitemValue(playerid, i, biz_id-1);
	}

	Dialog
	(
		playerid, DIALOG_SELL_MY_GARAGE_LIST, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите гараж",
		string_dialog,
		"Выбрать", "Закрыть"
	);

	cache_delete(result);
	return 1;
}

cmd:return_acsses(playerid)
{
	RemovePlayerAttachedObjects(playerid);

	new Float:foffset_x, Float:foffset_y, Float:foffset_z, Float:frot_x, Float:frot_y, Float:frot_z, Float:fscale_x, Float:fscale_y, Float:fscale_z;

	for(new i; i < MAX_PLAYER_ITEMS; i++)
	{
		if(GetPlayerItem(i, PI_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
		if(GetPlayerItem(i, PI_STATUS) != 1) continue;
		if(GetPlayerItem(i, PI_TYPE_ITEM) != 2) continue;

		new type;
		new boneid = GetPlayerItem(i, PI_INDX);
		new aks_id = GetPlayerItem(i, PI_AKS_ID);
		new typeacs = GetPlayerItem(i, PI_TYPEACS);
			
		foffset_x = GetPlayerItem(i, PI_FOFFSET_X);
		foffset_y = GetPlayerItem(i, PI_FOFFSET_Y);
		foffset_z = GetPlayerItem(i, PI_FOFFSET_Z);
		frot_x = GetPlayerItem(i, PI_FROT_X);
		frot_y = GetPlayerItem(i, PI_FROT_Y);
		frot_z = GetPlayerItem(i, PI_FROT_Z);
		fscale_x = GetPlayerItem(i, PI_FSCALE_X);
		fscale_y = GetPlayerItem(i, PI_FSCALE_Y);
		fscale_z = GetPlayerItem(i, PI_FSCALE_Z);

		if(typeacs == 222 || typeacs == 219 || typeacs == 220 || typeacs == 246 || typeacs == 263 || typeacs == 287 || typeacs == 324 || typeacs == 291 || typeacs == 277) type = 1;
		if(typeacs == 181 || typeacs == 182 || typeacs == 183 || typeacs == 184 || typeacs == 185) type = 2;
		if(typeacs == 221 || typeacs == 289) type = 6;
		if(typeacs == 275) type = 3;

		SetPlayerAttachedObject(playerid, boneid, aks_id, type, foffset_x, foffset_y, foffset_z, frot_x, frot_y, frot_z, fscale_x, fscale_y, fscale_z, 0);
	}

	return 1;
}

cmd:vipmute(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3) return 1;
 	else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /vipmute [id игрока] [время в минутах] [причина (необязательно)]");

	extract params -> new to_player, mute_time, string: reason[30];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(!(1 <= mute_time <= 5760)) return SendClientMessage(playerid, 0xCECECEFF, "* Время должно быть не меньше 1 и не больше 5760 минут");
	if(GetPlayerData(to_player, P_VMUTE) > 0) return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока уже есть мут");
	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя поставить затычку администратору выше по рангу");

	static fmt_msg[128];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s заблокировал игроку VIP чат %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), mute_time);

	if(strlen(reason))
		format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

	SendClientMessageToAll(0xFF0000AA, fmt_msg);

	SetPlayerData(to_player, P_VMUTE, mute_time * 60);
	UpdatePlayerDatabaseInt(to_player, "vmute", mute_time * 60);

	SendClientMessage(to_player, 0xCECECEFF, "* Время до окончания бана VIP чата: {CCCC00}/time");

	format(fmt_msg, sizeof fmt_msg, "Выдал %s[%d] блокировку вип чата на %d мин. Причина: %s",
	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), mute_time, reason);

	SendLog(playerid, LOG_TYPE_ADMIN_MUTE, fmt_msg);

	return 1;
}

cmd:unvipmute(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3) return 1;
 	else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /unvipmute [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	else if(GetPlayerData(to_player, P_VMUTE) <= 0) return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока нет мута");

	static fmt_msg[126];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s снял блокировку VIP чата с игрока %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendClientMessageToAll(0xFF0000AA, fmt_msg);

	SetPlayerData(to_player, P_VMUTE, 0);
	UpdatePlayerDatabaseInt(to_player, "vmute", 0);

	SendClientMessage(to_player, 0x66CC00FF, "Доступ в VIP чат восстановлен");

	format(fmt_msg, sizeof fmt_msg, "Снял блокировку VIP чата у %s[%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_MUTE, fmt_msg);

	return 1;
}

cmd:car_slot(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


 	extract params -> new to_player, slots; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /car_slot [id игрока] [кол-во слотов]");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!(0 <= slots <= 40)) return SendClientMessage(playerid, 0xCECECEFF, "* Уровень слотов от 0 до 15");

	AddPlayerData(to_player, P_CAR_SLOTS, +, slots);
	UpdatePlayerDatabaseInt(to_player, "car_slots", GetPlayerData(to_player, P_CAR_SLOTS));

	format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s[%d] добавил игроку %s[%d] %d слотов", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, slots);
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);

	format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Администратор %s[%d] добавил вам %d слотов", GetPlayerNameEx(playerid), playerid, slots);
	SendClientMessage(to_player, -1, STRING_GLOBAL);
	return 1;
}

cmd:rem(playerid)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) return SendClientMessage(playerid,COLOR_RED,"Вы не в транспортном средстве!");

    if(remen[playerid] == 0)
	{
		Action(playerid, "пристегнул ремень безопасности");
		GameText(playerid, "~g~Ремень безопасности пристегнут", 4000, 1);
		remen[playerid] = 1;
	}
	else if(remen[playerid] == 1)
	{
		Action(playerid, "отстегнул ремень безопасности");
		GameText(playerid, "~r~Ремень безопасности расстегнут", 4000, 1);
     	remen[playerid] = 0;
	}
    return true;
}
cmd:alist(playerid, params[]) 
{
	static query[100];
	new Cache: result;
	str_q[0] = EOS;
	format(str_q, sizeof str_q, "{CECECE}Тип наказания\t{CECECE}Дата наказания\t\t{CECECE}Ник администратора\t{CECECE}Причина\n");
	cache_delete(result);
	mysql_format(mysql, query, sizeof query, "SELECT * FROM alogs WHERE acc_id=%d LIMIT 10", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);
	if(cache_num_rows())
	{
		for(new idx; idx < cache_num_rows(); idx ++)
		{
			new time = cache_get_field_content_int(idx, "time"),
				reason[32],
				type[32],
				adm_name[32];
 			new year, month, day;
			new hour, minute, second;
			timestamp_to_date(time, year, month, day, hour, minute, second);
			cache_get_field_content(idx, "name_adm", adm_name);
			cache_get_field_content(idx, "type", type);
			cache_get_field_content(idx, "reason", reason);
			format(query, sizeof query, "{"#cW"}%s%s{"#cW"}%02d.%02d.%d %02d:%02d:%02d\t\t{"#cW"}%s\t%s\n", type, strlen(type) > 3 ? "\t\t\t" : "\t\t\t\t", year, month, day, hour - 3, minute, second, adm_name, reason);
			strcat(str_q, query);
			Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{"#cGold"}Последние 10 наказаний за 2 месяца", str_q, "Закрыть", "");
		}
	}
	else
	{
		format(query, sizeof query, "\n{"#cW"}Список наказаний пуст");
		strcat(str_q, query);
		Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF6600}Наказания", str_q, "Закрыть", "");
	}
	cache_delete(result);
	return 1;
}
cmd:a_alist(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return 1;
    extract params -> new to_player; else return SCM(playerid, 0xCECECEFF, "* Используйте: /a_alist [id игрока]");
	static query[100];
	new Cache: result;
	str_q[0] = EOS;
	format(str_q, sizeof str_q, "{CECECE}Тип наказания\t{CECECE}Дата наказания\t\t{CECECE}Ник администратора\t{CECECE}Причина\n");
	cache_delete(result);
	mysql_format(mysql, query, sizeof query, "SELECT * FROM alogs WHERE acc_id=%d LIMIT 10", GetPlayerAccountID(to_player));
	result = mysql_query(mysql, query, true);
	if(cache_num_rows())
	{
		for(new idx; idx < cache_num_rows(); idx ++)
		{
			new time = cache_get_field_content_int(idx, "time"),
				reason[32],
				type[32],
				adm_name[32];
 			new year, month, day;
			new hour, minute, second;
			timestamp_to_date(time, year, month, day, hour, minute, second);
			cache_get_field_content(idx, "name_adm", adm_name);
			cache_get_field_content(idx, "type", type);
			cache_get_field_content(idx, "reason", reason);
			format(query, sizeof query, "{"#cW"}%s%s{"#cW"}%02d.%02d.%d %02d:%02d:%02d\t\t{"#cW"}%s\t%s\n", type, strlen(type) > 3 ? "\t\t\t" : "\t\t\t\t", year, month, day, hour - 3, minute, second, adm_name, reason);
			strcat(str_q, query);
			Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{"#cGold"}Последние 10 наказаний за 2 месяца", str_q, "Закрыть", "");
		}
	}
	else
	{
		format(query, sizeof query, "\n{"#cW"}Список наказаний пуст");
		strcat(str_q, query);
		Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF6600}Наказания", str_q, "Закрыть", "");
	}
	cache_delete(result);
	return 1;
}
cmd:watch(playerid)
{
 	if(GetPlayerWatch(playerid) == 0) return SendClientMessage(playerid, 0x999999FF, "* У Вас нет Apple Watch. Их можно купить в сотовом салоне");
	new hour, minute,
		day, month, year;

	gettime(hour, minute);
	getdate(year, month, day);

	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "openInterface('Watch')");
	static fmt_td_text[300];
	format(fmt_td_text, sizeof fmt_td_text, "interface('Watch').time = '%d:%02d'",hour,minute);
	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_td_text);
	format(fmt_td_text, sizeof fmt_td_text, "interface('Watch').date = '%d %s'",day,GetMonthName(month));
	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_td_text);
	format(fmt_td_text, sizeof fmt_td_text, "interface('Watch').hoursGameTime = '%d мин'",ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_HOUR), CONVERT_TIME_TO_MINUTES));
	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_td_text);
	format(fmt_td_text, sizeof fmt_td_text, "interface('Watch').dayGameTime = '%d ч %d мин'",ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY), CONVERT_TIME_TO_HOURS),ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY), CONVERT_TIME_TO_MINUTES));
	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_td_text);
	format(fmt_td_text, sizeof fmt_td_text, "interface('Watch').yesterdayGameTime = '%d ч %d мин'",ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY_PREV), CONVERT_TIME_TO_HOURS),ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY_PREV), CONVERT_TIME_TO_MINUTES));
	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_td_text);
	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "window.setCursorStatus(1, 1)");
	SCM(playerid, -1, "* {ccccff}Для закрытия часов используйте: {ffffff}/watch_off");
	
	
	//BattlePass_Completingtasks(playerid, 1, 12);
	return 1;
}
//#include "system1337/mrllwns.inc"
cmd:watch_off(playerid)
{
	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "closeInterface('Watch')");
	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "window.setCursorStatus(1, 0)");
	return 1;
}

cmd:setleaderoff(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;

	if(!strlen(params))
		return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /setleaderoff [имя игрока] [ид фракции]");

	extract params -> new string: name[21], org_id;

	if(!(0 <= org_id <= 10)) return SendClientMessage(playerid, 0xFF6600FF, "* Неверный идентификатор фракции.");

	static query[100];
	new Cache: result, user_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows())
		user_id = cache_get_field_content_int(0, "id");

	if(!cache_num_rows() || !user_id)
		return SendClientMessage(playerid, 0xFF6600FF, "* Аккаунт с таким именем не найден"), cache_delete(result);

	static fmt_text[128];

	format(fmt_text, sizeof fmt_text, "A: %s [%d] оффлайн назначил лидером фракции %s игрока %s", GetPlayerNameEx(playerid), playerid, GetTeamName(org_id), name);
	SendMessageToAdmins(fmt_text, COLOR_GREY);

	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET rang=%d WHERE id=%d LIMIT 1", 11, user_id);
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET team=%d WHERE id=%d LIMIT 1", org_id, user_id);
	mysql_query(mysql, query, false);

	return 1;
}
cmd:phonehide(playerid)
{
	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "interface('Phone').hidePhone()");
    MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "window.setCursorStatus(1, 0)");
}
cmd:a_tuning(playerid, params[])
{
 	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;

	extract params -> new component_id; else return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /a_tuning [ID компонента]");

    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны быть в транспорте");

    new vid = GetPlayerVehicleID(playerid);

    Sendpacket_tun(playerid, vid, component_id);

    static msg[64];
    format(msg, sizeof(msg), "Компонент №%d успешно установлен", component_id);
    SendClientMessage(playerid, COLOR_GOLD, msg);

    return true;
}
cmd:sethunger(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 3 && GetPlayerBuyAdminEx(playerid) < 3) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new to_player, hunger; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /sethunger [id игрока] [количество сытости]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	else if(GetPlayerAdminEx(playerid) == 1 && to_player != playerid)
		return SendClientMessage(playerid, 0x999999FF, "* Администраторам 1-го уровня доступно изменение только своего уровня сытости");

	else if(!(0 <= hunger <= 100)) return SendClientMessage(playerid, 0x999999FF, "* Уровень сытости от 0 до 100");

	SetPlayerData(to_player, P_EAT, hunger);
	SetFullness(to_player, hunger);

	static fmt_msg[105];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s изменил Вам уровень сытости", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, -1, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы изменили %s уровень сытости", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, -1, fmt_msg);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_msg, sizeof fmt_msg, " Администратор %s[%d] изменил уровень сытости %s[%d] на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, hunger);
		SendMessageToAdmins(fmt_msg, 0x999999FF);
	}
	format(fmt_msg, sizeof fmt_msg, "Установил %s[%d] уровень сытости на %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), hunger);
	return 1;
}
cmd:addcar(playerid, params[]) callcmd::givecar(playerid, params);
cmd:givecar(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new to_player, modelid, color_1, color_2, vinil, viniltype;

	if(!(400 <= modelid <= 614) && (!(699 <= modelid <= 699) && (!(793 <= modelid <= 799) && (!(15065 <= modelid <= 15299) && (!(15600 <= modelid <= 15699) && (!(17400 <= modelid <= 17448) && (!(907 <= modelid <= 909) && (!(965 <= modelid <= 965) && (!(999 <= modelid <= 999) && (!(1326 <= modelid <= 1326))))))))))) return SCM(playerid, 0xCECECEFF, "* Вы указали неверный id авто. Доступные авто: 400-614, 699, 793-799, 907-909, 965, 999, 1326, 15065-15299, 15600-15699, 17400-17448");

	if((GetPlayerOwnableCars(to_player) + 1) > GetPlayerCarSlots(to_player)) return SendClientMessage(playerid, 0x3399FFFF, "* Все слоты для транспорта заняты.");

 	if(modelid < 400) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givecar [id игрока] [id авто] [цвет 1] [цвет 2] [винил] [тип винила]");

	if((GetPlayerOwnableCars(to_player) + 1) > GetPlayerCarSlots(to_player)) return SCM(playerid, COLOR_GREY, "* У игрока все слоты на транспорт заняты.");
	//if((GetPlayerOwnableCars(to_player)) > 31) return SCM(playerid, COLOR_GREY, "* У игрока достигнут лимит транспорта.");

	GiveCar(to_player, modelid, color_1, color_2, vinil, viniltype, 110.8994,322.3508,11.2202,251.4996, gettime());


	static msg[144];
    format(msg, sizeof msg, "{"SERVER_COLOR"}* Администратор %s выдал вам {FFFFFF}транспорт: %s{"SERVER_COLOR"}, для просмотра пропишите - /car", GetPlayerNameEx(playerid), GetVehicleInfo(modelid, VI_NAME));
    SCM(to_player, -1, msg);

	STRING_GLOBAL[0] = EOS;

    format(STRING_GLOBAL, sizeof STRING_GLOBAL, "{"SERVER_COLOR"}A: Администратор %s выдал игроку %s {FFFFFF}транспорт: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), GetVehicleInfo(modelid, VI_NAME));
   	SendMessageToAdmins(STRING_GLOBAL, -1);
	return 1;
}

cmd:addsklad(playerid, params[])
{
	if(CheckAdmin(playerid, 11)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	new form[256];

	extract params -> new amount; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /addsklad [кол-во]");

	if(!(1 <= amount <= 20000))
		return SendClientMessage(playerid, 0x999999FF, "* Количество материалов от 1 до 20000");

	for(new i; i < 3; i++)
	{
		SetGangRepositoryData(i, GR_AMMO, amount);
		SetGangRepositoryData(i, GR_DRUGS, amount);
		SetGangRepositoryData(i, GR_METALL, amount);
		UpdateGangRepository(i);
	}
	format(form, sizeof(form), "Вы установили всем складам %d материалов", amount);
	scm(playerid, -1, form);

	return 1;
}
cmd:lmenu(playerid,params[])
{
	new repository_id = (GetPlayerTeamEx(playerid) - TEAM_MAFIA_RUSSIAN);
	if(!IsAtGang(playerid))
	{
		if((GetPlayerTeamEx(playerid) > 0 || g_player[playerid][P_RANG] == 9)) return Dialog(playerid,1214,2,"Меню лидера","{AFAFAF}Пригласить в организацию\n{AFAFAF}Игроки онлайн\nУстроить собеседование","Далее","Отмена");
		else SCM(playerid, COLOR_GREY, !"Вы не лидер и не зам. лидера");
	}
	else
	{
		if(GetPlayerTeamEx(playerid) > 0 || g_player[playerid][P_RANG] == 9)
		{
			static str[50];
		    format(str,sizeof(str),"{FFFFFF}Банк: {009327}%dр",GetGangRepositoryData(repository_id, GR_MONEY));
			format(STRING_GLOBAL,sizeof(STRING_GLOBAL),"{AFAFAF}Пригласить в организацию\n{AFAFAF}Игроки онлайн\n{AFAFAF}Общак [%s]\n{AFAFAF}Спавн транспорта [{009327}25 000 рублей{AFAFAF}]\nУстроить собеседование", GetGangRepositoryData(repository_id, GR_LOCK) ? "{33AA33}Открыт" : "{FF6600}Закрыт");
			Dialog(playerid,1214,2,str,STRING_GLOBAL,"Далее","Отмена");
		}
	}
	return 1;
}
cmd:take_number(playerid)
{
	new vehicleid;
   	new Float:Distance_ = 50.0;

    for(new i = 0; i < MAX_VEHICLES; i++)
	{
	    if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
	    {
		    new iddx = GetVehicleData(i, V_ACTION_ID);
	        if(GetOwnableCarData(iddx,OC_OWNER_ID) == GetPlayerAccountID(playerid))
	        {
				new Float:Distance = D_PlayerVehicle(playerid, i);
		    	if(Distance < Distance_)
				{
					Distance_ = Distance;
					vehicleid = i;
	            }
	        }
        }
	}
	if(Distance_ == 50.0) return SendClientMessage(playerid, 0x808080FF, "Вы далеко от своего транспорта");

	new index = GetVehicleData(vehicleid, V_ACTION_ID);
	new Float: POS[5];

	GetCoordVehicle(vehicleid, VEHICLE_COORD_TYPE_BONNET, POS[0], POS[1], POS[2], POS[3], POS[4]);
	if(IsPlayerInRangeOfPoint(playerid, 4.0, POS[0], POS[1], POS[2]))
	{
		if(GetInventorySlots(playerid) == -1) return GameText(playerid, "В вашем инвентаре нет свободного места", 3000, 0);

		static fmt_text[505];

		if(!strcmp(g_ownable_car[index][OC_NUMBER], "------")) return SCM(playerid, 0xCECECEFF, "* На этом т/с нет номеров");
		
		SCM(playerid, -1, "* Вы сняли номера с личного тс");
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);

		CreateItemsCarNumber(GetPlayerAccountID(playerid), 0, 1, GetInventorySlots(playerid), GetOwnableCarData(index, OC_NUMBER), GetOwnableCarData(index, OC_REGION), GetOwnableCarData(index, OC_NUMBERTYPE), -1, -1, 0, 1);

		SetOwnableCarData(index, OC_NUMBERTYPE, 0);
		format(g_ownable_car[index][OC_NUMBER], 10, "------");
		format(g_ownable_car[index][OC_REGION], 10, "0");
		format(g_vehicle_data[vehicleid][V_NUMBER], 10, "------");
		format(g_vehicle_data[vehicleid][V_REGION], 10, "0");

		SetVehicleNumber(vehicleid, 0, "", "");
		SendPacket_Plate(playerid, vehicleid, 0, "", "");

		mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET number='------', region='0', typenumber=0 WHERE id=%d LIMIT 1",GetOwnableCarData(index, OC_SQL_ID));
		mysql_query(mysql, fmt_text, false);
	}
	else return SCM(playerid, -1, "* Вы должны быть возле капота");
	return 1;
}

cmd:spoff(playerid)
{
	if(GetPlayerAdminEx(playerid) < 1) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	HideSpecmenuTD(playerid);
    StopSpectate(playerid);
	SendClientMessage(playerid, 0xB0C4DEFF, "Вы покинули режим зрителя");

	return 1;
}

cmd:alldelveh(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	new vehicles_count;
	for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_ADMIN_CAR)
		{
			DestroyVehicle(i);
		}
	    vehicles_count++;
	}
	static fmt_text[90];
	format(fmt_text, sizeof fmt_text, "A: %s [%d] удалил автомобили созданные администраторами", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(fmt_text, COLOR_GREY);
	return 1;
}
cmd:sban(playerid, params[])
{
    if (GetPlayerAdminEx(playerid) < 6) return 1;
    if (admin_logged[playerid] == false)
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
    if (GetPlayerData(playerid, P_BUYADMIN) == 1) 
        return SendClientMessage(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");
    if (!strlen(params)) 
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /sban [id игрока] [срок в днях или -1] [причина (необязательно)]");
    extract params -> new to_player, ban_time, string:reason[30];
    if (!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");
    if (!(-1 <= ban_time <= 30) || ban_time == 0)
        return SendClientMessage(playerid, 0xFF6600FF, "* Срок бана от 1 до 30 или -1");
    if (GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
        return SendClientMessage(playerid, 0xFF6600FF, "* Нельзя забанить администратора выше по рангу");
    if (g_AdminSbanTimer[playerid] == 0 || (gettime() - g_AdminSbanTick[playerid]) >= 10) {
        g_AdminSbanCount[playerid] = 0; 
        g_AdminSbanTimer[playerid] = gettime();
    }
    g_AdminSbanCount[playerid]++; 
    g_AdminSbanTick[playerid] = gettime(); 
    if (g_AdminSbanCount[playerid] > 3) {
        SetPlayerData(playerid, P_ADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "admin", 0);
        SetPlayerData(playerid, P_BUYADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "buyadmin", 0);		
        return SendClientMessage(playerid, 0xFF0000AA, "{F81414}[Анти-Слив] {F3FF02}Ваша админка была снята за слишком большое количество силовых банов за короткое время!");
    }
    static fmt_text[200];
    format(fmt_text, sizeof fmt_text, "A: %s [%d] забанил игрока %s без лишнего шума. Причина: %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), reason);
    SendMessageToAdmins(fmt_text, COLOR_GREY);
    static query[244];
    SetPlayerData(to_player, P_ADMIN, 0);
    UpdatePlayerDatabaseInt(to_player, "admin", 0);
    mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET a_sban = a_ban+1 WHERE name = '%e'", GetPlayerNameEx(playerid));
    mysql_query(mysql, query, false);
    AddBan(GetPlayerAccountID(to_player), gettime(), ban_time, GetPlayerIpEx(to_player), reason, GetPlayerNameEx(playerid));
    BanEx(to_player, reason);
    return 1;
}
cmd:mp_gun(playerid,params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	new gun, ammo, radius;

	if(sscanf(params, "iii", radius, gun, ammo)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /mp_gun [радиус] [id оружия] [патроны]");
	if(radius < 1 || radius > 200) return SendClientMessage(playerid, 0xFF6600FF, "* Радиус от 20 до 200");

	if(gun < 1 || gun > 46 || gun == 38 || gun == 36 || gun == 35 || gun == 37) return SendClientMessage(playerid, 0xFF6600FF, "* Неверный ID оружия");

	if(gun == 27 || gun == 4 || gun == 19
		|| gun == 20 || gun == 21 || gun == 35 || gun == 36 || gun == 39 || gun == 40 || gun == 44 || gun == 45
		|| gun == 38 || gun == 32 || gun == 28 || gun == 18 || gun == 37 || gun == 16 || gun == 9)
	{
		return SendClientMessage(playerid, 0x999999FF, "* Данный id оружия запрещен для выдачи!");
	}

	if(ammo < 1 || ammo > 999) return SendClientMessage(playerid, 0xFF6600FF, "* Патронов может быть от 1 до 999");

	new Float:pos[3];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	static string[144];
	new players;
	foreach(new i : Player)
	{
		if(!IsPlayerInRangeOfPoint(i, radius, pos[0], pos[1], pos[2])) continue;
		GiveWeapon(i, gun, ammo);
		format(string, sizeof string, "[MP]: Вы получили оружие %s [%d] и %d пт.", GetWeaponName(gun), gun, ammo);
		SendClientMessage(i, 0xCECECEFF, string);
		players++;
	}
	format(string, sizeof string, "Оружие выдано %i игрокам в радиусе %i метров", players, radius);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}
cmd:mp_skin(playerid,params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new skin_id, radius;

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /mp_skin [радиус] [id скина]");
	if(radius < 1 || radius > 200) return SendClientMessage(playerid, 0xFF6600FF, "* Радиус от 20 до 200");

	new Float:pos[3];

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

	static string[144];
	new players;
	foreach(new i : Player)
	{
		if(!IsPlayerInRangeOfPoint(i, radius, pos[0], pos[1], pos[2])) continue;
		SetPlayerSkin(i, skin_id);
	}
	format(string, sizeof string, "Скин выдан %i игрокам в радиусе %i метров", players + 1, radius);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}
cmd:mp_freeze(playerid,params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /mp_freeze [радиус]");

	extract params -> new radius;

	if(radius < 1 || radius > 100) return SendClientMessage(playerid, 0xFF6600FF, "* Радиус от 1 до 100");

	new Float:pos[3];

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	foreach(new i : Player)
	{
		if(!IsPlayerInRangeOfPoint(i, radius, pos[0], pos[1], pos[2])) continue;
		TogglePlayerControllable(i, false);
		SendClientMessage(i, COLOR_WHITE, "Администратор заморозил Вас");
	}
	SendClientMessage(playerid, COLOR_WHITE, "Вы успешно заморозили игроков в радиусе");
	return 1;
}

cmd:mp_unfreeze(playerid,params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /mp_unfreeze [радиус]");

	extract params -> new radius;

	if(radius < 1 || radius > 100) return SendClientMessage(playerid, 0xFF6600FF, "* Радиус от 1 до 100");

	new Float:pos[3];

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	foreach(new i : Player)
	{
		if(!IsPlayerInRangeOfPoint(i, radius, pos[0], pos[1], pos[2])) continue;
		TogglePlayerControllable(i, true);
		SendClientMessage(i, COLOR_WHITE, "Администратор разморозил Вас");
	}

	SendClientMessage(playerid, COLOR_WHITE, "Вы успешно разморозили игроков в радиусе");

	return 1;
}
cmd:agm(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4 && GetPlayerBuyAdminEx(playerid) < 4) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
 	if(GetPVarInt(playerid,"agm") == 0)
    {
        SetPVarInt(playerid,"agm", 1);
		SetPVarInt(playerid, "medhelp", 2);
        SetPlayerHealth(playerid, 0x7F800000);
        SendClientMessage(playerid, -1, "* {ff8c00}Режим бессмертия активирован");
    }
    else
    {
        SetPVarInt(playerid,"agm", 0);
		SetPVarInt(playerid, "medhelp", 0);
        SetPlayerHealth(playerid, 100.0);
        SendClientMessage(playerid, -1, "* {ff8c00}Режим бессмертия деактивирован");
    }
  	return 1;
}
cmd:money_log(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 7 && GetPlayerBuyAdminEx(playerid) < 7) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xFF6600FF, "* Информация: /money_log [имя игрока]");

	if(!(3 <= strlen(params) <= 20))
		return SendClientMessage(playerid, 0xFF6600FF, "* Аккаунт с таким именем не найден");

	extract params -> new string: name[21];

	static query[100];
	new Cache: result, user_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows())
		user_id = cache_get_field_content_int(0, "id");

	if(!cache_num_rows() || !user_id)
		return SendClientMessage(playerid, 0xFF6600FF, "* Аккаунт с таким именем не найден"), cache_delete(result);

	static fmt_text[1512];

	new description[128];

	format(description, sizeof description, "Последние 20 операций денег игрока %s", name);

	format(fmt_text, sizeof fmt_text, "Дата операции\t\tКоличество\tСколько осталось\tПричина\n");

	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "SELECT * FROM money_log WHERE uid=%d LIMIT 20", user_id);
	result = mysql_query(mysql, query, true);

	if(cache_num_rows())
	{
		for(new idx; idx < cache_num_rows(); idx ++)
		{
			new time = cache_get_field_content_int(idx, "time"),
				money = cache_get_field_content_int(idx, "money"),
				last_money = cache_get_field_content_int(idx, "last_money"),
				reg_date[6],
				desc[32];

			cache_get_field_content(idx, "description", desc);

			timestamp_to_date(time, reg_date[2], reg_date[1], reg_date[0], reg_date[3], reg_date[4], reg_date[5]);

			format(query, sizeof query, "\n%02d.%02d.%d %02d:%02d:%02d\t%d\t%d\t\t%s", reg_date[0], reg_date[1], reg_date[2], reg_date[3], reg_date[4], reg_date[5], money, last_money, desc);
			strcat(fmt_text, query);
		}
	}
	cache_delete(result);

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, description, fmt_text, "Закрыть", "");
	return 1;
}

cmd:flip(playerid)
{
    static const	coin_str0[] = "подбросил монетку, выпал",
                    coin_str1[] = "а {66CCFF}\"решка\".", coin_str2[] = " {66CCFF}\"орёл\".";

	new string [MAX_PLAYER_NAME + (sizeof (coin_str0) - 1) + (sizeof (coin_str1) - 1) + 1];

    strcat(string, coin_str0);
    strcat(string, (random(2)) ? (coin_str1) : (coin_str2));

	Action(playerid, string);
    return 1;
}
cmd:idea(playerid, params[])
{
	extract params -> new string: text[144]; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: {ffffff} /idea [текст]");

	SetPlayerChatBubble(playerid, text, 0xcececeFF, 25.0, 7000);

	STRING_GLOBAL[0] = EOS;

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Мысли от %s[%d]: {ffffff}%s", GetPlayerNameEx(playerid), text);
	SendMessageInLocal(playerid, STRING_GLOBAL, 0xcececeFF, 25.0);

	return 1;
}
cmd:svist(playerid, params[])
{
	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: {ffffff} /svist [ID игрока]");

	Action(playerid, "свистнул");

	STRING_GLOBAL[0] = EOS;

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Игрок %s[%d] свистнул Вам", GetPlayerNameEx(playerid), playerid);
	SendClientMessage(to_player, 0xb8e994FF, STRING_GLOBAL);

	return 1;
}

cmd:fight(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid,4,216.4738,837.3892,1000.9922)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться возле ринга");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /fight [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	new Float: to_x, Float: to_y, Float: z;
	GetPlayerPos(to_player, to_x, to_y, z);

	new Float: dist = GetPlayerDistanceFromPoint(playerid, to_x, to_y, z);
	if(0.5 <= dist <= 1.5)
	{
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_FIGHT);
	}
	else SendClientMessage(playerid, 0xFF6600FF, "* Вы находитесь слишком далеко от игрока");

	return 1;
}

cmd:fightloose(playerid)
{
	if(!IsPlayerInRangeOfPoint(playerid,3.5,214.4493,841.5947,1001.695)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться на ринге");

	SetPlayerPos(playerid, 209.7499,844.3637,1001.0000);

	SendClientMessage(playerid, 0xFF6600FF, "* Вы приняли поражение.");

	return 1;
}

cmd:kiss(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "* Нельзя использовать в машине");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /kiss [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	if(GetPlayerSex(playerid) == GetPlayerSex(to_player)) return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете поцеловать игрока того же пола как и Вы");

	new Float: to_x, Float: to_y, Float: z;
	GetPlayerPos(to_player, to_x, to_y, z);

	new Float: dist = GetPlayerDistanceFromPoint(playerid, to_x, to_y, z);
	if(0.5 <= dist <= 1.5)
	{
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_KISS);
	}
	else SendClientMessage(playerid, 0xFF6600FF, "* Вы находитесь слишком далеко от игрока");
	return 1;
}
cmd:sellsim(playerid, params[])
{
    if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, 0x999999FF, "* Вы должны прожить в области минимум 2 года.");
	if(!IsPlayerInRangeOfPoint(playerid, 70.0, -2701.6865,-0.0529,1060.9941)) return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться в сотовом салоне");

	if(!strlen(params)) return SendClientMessage(playerid, COLOR_GOLD, "Команда:{"#cW"} /sellsim [ID игрока] [цена]");

	extract params -> new to_player, price;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	if(price < 1000 || price > 100000000) return SendClientMessage(playerid, 0xFF6600FF, "* Цена от 1.000 до 100.000.000");

	if(GetPlayerMoney(to_player) < price) return SendClientMessage(playerid, 0xFF6600FF, "* У игрока недостаточно средств");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 10.0)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок находится слишком далеко");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELLSIM, price);
	return 1;
}

cmd:rmute(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /rmute [ID игрока] [время в минутах] [причина (необязательно)]");

	extract params -> new to_player, mute_time, string: reason[30];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	if(!(1 <= mute_time <= 5760)) return SendClientMessage(playerid, 0xFF6600FF, "* Время должно быть не меньше 1 и не больше 5760 минут");
	if(GetPlayerData(to_player, P_RMUTE) > 0) return SendClientMessage(playerid, 0xFF6600FF, "* У этого игрока уже блокировка репорта");

	static fmt_msg[128];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s заблокировал репорт игроку %s на %d мин.", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), mute_time);

	if(strlen(reason))
	format(fmt_msg, sizeof fmt_msg, "%s Причина: %s", fmt_msg, reason);

	SendClientMessageToAll(0xFF0000AA, fmt_msg);

	SetPlayerData(to_player, P_RMUTE, mute_time * 60);
	UpdatePlayerDatabaseInt(to_player, "rmute", mute_time * 60);

	SendClientMessage(to_player, 0xFF6600FF, "* Время до окончания блокировки репорта: /time");

	format(fmt_msg, sizeof fmt_msg, "Выдал %s[%d] блокировку репорта на %d мин. Причина: %s",
	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), mute_time, reason);
	SendLog(playerid, LOG_TYPE_ADMIN_MUTE, fmt_msg);
	return 1;
}
cmd:unrmute(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /unrmute [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	else if(GetPlayerData(to_player, P_RMUTE) <= 0) return SendClientMessage(playerid, 0xFF6600FF, "* У этого игрока нет блокировки репорта");

	static fmt_msg[80];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s снял блокировку репорта с игрока %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendClientMessageToAll(0xFF0000AA, fmt_msg);

	SetPlayerData(to_player, P_RMUTE, 0);
	UpdatePlayerDatabaseInt(to_player, "rmute", 0);

	SendClientMessage(to_player, 0xCECECEFF, "* Доступ к репорту восстановлен");

	SetPlayerData(playerid, P_AUNRMUTE, GetPlayerData(playerid, P_AUNRMUTE) + 1);
	UpdatePlayerDatabaseInt(playerid, "a_unrmute", GetPlayerData(playerid, P_AUNRMUTE) + 1);

	format(fmt_msg, sizeof fmt_msg, "Снял блокировку репорта у %s[%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_MUTE, fmt_msg);

	return 1;
}

cmd:fly(playerid,params[])
{
    if(GetPlayerAdminEx(playerid) < 2 && GetPlayerYAdminEx(playerid) < 1) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
		
    SetPVarInt(playerid,"spawn_ac",1);

	if(GetPVarType(playerid, "FlyMode"))
	{
	    new inter, world, Float:X, Float:Y, Float:Z, Float:FA;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, FA);
		inter = GetPlayerInterior(playerid);
		world = GetPlayerVirtualWorld(playerid);
		SetPVarFloat(playerid, "SpecX", X);
		SetPVarFloat(playerid, "SpecY", Y);
		SetPVarFloat(playerid, "SpecZ", Z);
		SetPVarFloat(playerid, "SpecFA", FA);
		SetPVarInt(playerid, "SpecInt", inter);
		SetPVarInt(playerid, "SpecWorld", world);

		if(GetPlayerData(playerid, P_SKIN) > 0) SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));

		DeletePVar(playerid, "FlyMode");
		CancelEdit(playerid);
		TogglePlayerSpectating(playerid, false);

		DestroyPlayerObject(playerid, noclipdata[playerid][fly_object]);
		noclipdata[playerid][camera_mode] = CAMERA_MODE_NONE;
		SetPlayerSpawnInit(playerid);
		SpawnPlayer(playerid);
		SetPlayerPos(playerid, X, Y, Z);
		SetPlayerFacingAngle(playerid, FA);
		SetPlayerVirtualWorld(playerid, world);
		SetPlayerInterior(playerid, inter);
		callcmd::return_acsses(playerid);
		
	}
	else
	{
		SetPVarInt(playerid, "SpecBool", 1);
		FlyMode(playerid);
		SetPlayerSkin(playerid, 78);
  		callcmd::return_acsses(playerid);
		SetPVarFloat(playerid, "FlySpeedMultiplier", 100.0);
	}
	return true;
}
cmd:drugs(playerid, params[])
{
	if(GetIteam(playerid, 25) <= 0) return SendClientMessage(playerid, 0xFF6600FF, "* У Вас нет наркотиков");
	if(GetPVarInt(playerid, "DrugsTime") > gettime()) return SendClientMessage(playerid, 0xFF6600FF, "* Вы недавно употребляли наркотики.. Подождите немного");
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, 0xCECECEFF, "* Информация: /drugs [кол-во грамм]");
	static string[128];
	if(params[0] > 5)
	{
	    format(string, sizeof(string), "Количество от 1 до 5, сейчас У Вас %i грамм", GetIteam(playerid, 25));
		SendClientMessage(playerid, COLOR_GREY, string);
		return 1;
	}

	new Float:health;
	GetPlayerHealth(playerid, health);

	SetPlayerData(playerid, P_HEALTH, health+params[0]*20);
	SetPlayerHealthEx(playerid, health+params[0]*20);

	GetPlayerHealth(playerid, health);
	if(health > 120) return SendClientMessage(playerid, COLOR_GREY, "* Вам плохо от наркотиков, пожалуйста подождите");

	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) ApplyAnimation(playerid,"SMOKING","M_smk_drag",4.1,0,0,0,0,0,1);
	format(string, sizeof(string), "Вы употребили %i гр. наркотиков. Ваше здоровье: %3.1f", params[0], health);
	SendClientMessage(playerid, 0xCECECEFF, string);

	GiveIteam(playerid, 25, 0,params[0],0);

	//drug_effect_gone_timer[playerid] = 6;

	SetPVarInt(playerid, "DrugsTime", gettime() + 60);

	static fmt_str[124];

	format(fmt_str, sizeof fmt_str, "%s употребил(a) %i грамм наркотиков", GetPlayerNameEx(playerid), params[0]);
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	SetPlayerTime(playerid,17,0);
	SetPlayerDrunkLevel(playerid, 3000);
	SetPlayerWeather(playerid, 0);

	return 1;
}

cmd:removegun(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new to_player; else return SendClientMessage(playerid, COLOR_RED, "* Используйте: /removegun [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

    ResetPlayerWeapons(to_player);

	static fmt_text[128];

	format(fmt_text, sizeof fmt_text, "A: %s [%d] отобрал оружие у игрока %s [%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
	SendMessageToAdmins(fmt_text, COLOR_GREY);

	return 1;
}
cmd:carpass(playerid, params[])
{
	new vehicleid = GetPlayerOwnableCarLast(playerid);
	if(vehicleid == INVALID_VEHICLE_ID)
	{
		if(GetPlayerOwnableCars(playerid) == 0)
			return SendClientMessage(playerid, 0xFF6600FF, "* У Вас нет личного транспорта");
		else
			return SendClientMessage(playerid, 0xFF6600FF, "* Ваш личный транспорт не загружен на сервер");
	}

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /carpass [ID игрока]");

	extract params -> new to_player;

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 3.0))
		return SendClientMessage(playerid, 0xCECECEFF, "* Игрок слишком далеко");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	ShowOwnableCarPass(to_player, vehicleid);
	SetPVarInt(to_player, "owenrname", playerid);
	return 1;
}
cmd:gotocar(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerBuyAdminEx(playerid) < 2) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new to_vehicleid; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /gotocar [id транспорта]");
	if(!IsValidVehicle(to_vehicleid)) return SendClientMessage(playerid, 0xFF6600FF, "* Данного транспорта не существует на сервере");

	new Float: x, Float: y, Float: z;
	GetVehiclePos(to_vehicleid, x, y, z);

	SetPlayerPosEx(playerid, x + 1, y + 1, z, 0.0, false);

	SendClientMessage(playerid, -1, "* Вы были телепортированы к авто");

	return 1;
}

cmd:wedding(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 35.0, -1293.4110, 717.4692, 2002.0000)) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в церкви");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /wedding [ID игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	if(GetPlayerBrakEx(playerid) != 0 || GetPlayerBrakEx(to_player) != 0)
	    return SendClientMessage(playerid, 0xFF6600FF, "* Вы уже состоите в браке");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_WEDDING);

	return 1;
}

cmd:divorce(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 35.0, -1293.4110, 717.4692, 2002.0000)) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в церкви");

	if(GetPlayerBrakEx(playerid) < 1)
 		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не состоите в браке");

	static query[144];

	format(query, sizeof query, "Вы развелись своим супругом (супругой)", GetPlayerBrakEx(playerid));
	SendClientMessage(playerid, 0xCECECEFF, query);

  	if(!mysql_errno())
	{
	format(g_player[playerid][P_WIFE_NAME], 61, "", 0);
	}

	mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET brak='' WHERE id=%d LIMIT 1", GetPlayerAccountID(playerid));
	mysql_query(mysql, query, false);

	return 1;
}

cmd:houseinfo(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 7 && GetPlayerBuyAdminEx(playerid) < 7) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /homeinfo [id жилья]");

	extract params -> new houseid;

	if(!(0 <= houseid <= g_house_loaded-1)) return SendClientMessage(playerid, 0xFF6600FF, "* Данного дома не существует на сервере");

	static fmt_str[850];

	static string[44];

	format(string, sizeof string, "{"#cGold"}Дом / Квартирка №%d", houseid);

	format(fmt_str, sizeof fmt_str, "{"#cW"}Тип / название:\t\t\t\t{339999}%s\n", GetHouseData(houseid, H_NAME));

	format
	(
		fmt_str, sizeof fmt_str,
		"%s{"#cW"}Номер дома:\t\t\t\t{AFAFAF}%d\n"\
		"{"#cW"}Город / область:\t\t\t{AFAFAF}%s\n"\
		"{"#cW"}Район:\t\t\t\t\t{AFAFAF}%s\n",
		fmt_str,
		houseid,
		GetCityName(GetHouseData(houseid, H_CITY)),
		GetZoneName(GetHouseData(houseid, H_ZONE))
	);

	format
	(
		fmt_str, sizeof fmt_str,
		"%s{"#cW"}Стоимость:\t\t\t\t{AFAFAF}%s руб\n"\
		"{"#cW"}Дом оплачен на:\t\t\t{AFAFAF}%d/30 дней\n"\
		"{"#cW"}Количество комнат:\t\t\t{AFAFAF}%d\n"\
		"{"#cW"}Уровень улучшений:\t\t\t{AFAFAF}%d\n"\
		"{"#cW"}Квартплата:\t\t\t\t{AFAFAF}%d руб в день\n"\
		"{"#cW"}Тип квартплаты:\t\t\t{AFAFAF}%s\n"\
		"{"#cW"}Статус:\t\t\t\t\t{AFAFAF}%s",
		fmt_str,
		formatInt(GetHouseData(houseid, H_PRICE)),
		GetHouseData(houseid, H_RENT_DATE) <= gettime() ? 0 :
		GetElapsedTime(GetHouseData(houseid, H_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
		GetHouseTypeInfo(GetHouseData(houseid, H_TYPE), HT_ROOMS),
		GetHouseData(houseid, H_IMPROVEMENTS),
		GetHouseData(houseid, H_IMPROVEMENTS) < 3 ? (GetHouseData(houseid, H_RENT_PRICE)) : (GetHouseData(houseid, H_RENT_PRICE) / 2),
		GetHouseData(houseid, H_IMPROVEMENTS) < 3 ? ("Обычная") : ("Пониженная"),
		GetHouseData(houseid, H_LOCK_STATUS) ? ("{CC3333}Дом закрыт") : ("{66CC33}Дом открыт")
	);
	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, string, fmt_str, "Закрыть", "");

	return 1;
}

cmd:bizinfo(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 7 && GetPlayerBuyAdminEx(playerid) < 7) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /bizinfo [id бизнеса]");

	extract params -> new businessid;

	if(!(0 <= businessid <= g_business_loaded-1)) return SendClientMessage(playerid, 0xFF6600FF, "* Данного бизнеса не существует на сервере");

	static const
 	music_name[6][9] = {"Отключен", "Звук 1", "Звук 2", "Звук 3", "Звук 4", "Звук 5"};

	if(GetBusinessData(businessid, B_ENTER_MUSIC) > sizeof music_name - 1)
	{
		SetBusinessData(businessid, B_ENTER_MUSIC, sizeof music_name - 1);
	}

	static string[144];

	format(string, sizeof string, "{"#cGold"}Бизнес №%d", businessid);

	string_dialog[0] = EOS;
	format
	(
		string_dialog, sizeof string_dialog,
		"{"#cW"}Название:\t\t\t\t{AFAFAF}%s\n"\
		"{"#cW"}Номер бизнеса:\t\t\t{AFAFAF}%d\n"\
		"{"#cW"}Владелец:\t\t\t\t{AFAFAF}%s\n"\
		"{"#cW"}Город / область:\t\t\t{AFAFAF}%s\n"\
		"{"#cW"}Район:\t\t\t\t\t{AFAFAF}%s\n"\
		"{"#cW"}Плата за вход:\t\t\t\t{AFAFAF}%d руб\n"\
		"{"#cW"}Количество продуктов:\t\t{AFAFAF}%d из %d\n"\
		"{"#cW"}Стоимость 1 продукта:\t\t\t{AFAFAF}%d руб\n"\
		"{"#cW"}Уровень улучшений:\t\t\t{AFAFAF}%d\n"\
		"{"#cW"}Баланс предприятия:\t\t\t{AFAFAF}%s руб\n"\
		"{"#cW"}Бизнес арендован на:\t\t\t{AFAFAF}%d/30 дней\n"\
		"{"#cW"}Звук при входе:\t\t\t{AFAFAF}{%s}%s\n"\
		"{"#cW"}Гос. стоимость:\t\t\t{AFAFAF}%s руб\n"\
		"{"#cW"}Аренда помещения:\t\t\t{AFAFAF}%d руб в день\n"\
		"{"#cW"}Тип аренды:\t\t\t\t{AFAFAF}%s\n"\
		"{"#cW"}Статус:\t\t\t\t\t{AFAFAF}%s",
		GetBusinessData(businessid, B_NAME),
		businessid,
		GetBusinessData(businessid, B_OWNER_NAME),
		GetCityName(GetBusinessData(businessid, B_CITY)),
		GetZoneName(GetBusinessData(businessid, B_ZONE)),
		GetBusinessData(businessid, B_ENTER_PRICE),
		GetBusinessData(businessid, B_PRODS),
		GetBusinessMaxProd(businessid),
		GetBusinessData(businessid, B_PROD_PRICE),
		GetBusinessData(businessid, B_IMPROVEMENTS),
		formatInt(GetBusinessData(businessid, B_BALANCE)),
		GetBusinessData(businessid, B_RENT_DATE) <= gettime() ? 0 :
		GetElapsedTime(GetBusinessData(businessid, B_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
		!GetBusinessData(businessid, B_ENTER_MUSIC) ? ("FF3333") : ("33CC00"),
		music_name[GetBusinessData(businessid, B_ENTER_MUSIC)],
		formatInt(GetBusinessData(businessid, B_PRICE)),
		GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? (GetBusinessData(businessid, B_RENT_PRICE)) : (GetBusinessData(businessid, B_RENT_PRICE) / 2),
		GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? ("Полная") : ("Льготная"),
		GetBusinessData(businessid, B_LOCK_STATUS) ? ("{CC3333}Бизнес закрыт") : ("{66CC33}Бизнес открыт")
	);
	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, string, string_dialog, "Закрыть", "");

	return 1;
}

cmd:unrent(playerid)
{
	if(GetPlayerData(playerid, P_RENT_CAR) == INVALID_VEHICLE_ID) return SendClientMessage(playerid, -1, "* У вас нет арендованного авто!");
	new veh_id = GetPlayerData(playerid, P_RENT_CAR);
	{
		SetVehicleData(veh_id, V_OWRENT, 0);
		SetVehicleToRespawn(veh_id);
	}
	SetPlayerData(playerid, P_RENT_CAR, INVALID_VEHICLE_ID);
	SendClientMessage(playerid, -1, "* Вы успешно отдали арендованное авто обратно");
	return 1;
}

cmd:phone(playerid){

	new hour, minute,
	day, month, year;

	gettime(hour, minute);
	getdate(year, month, day);
	
	if(!GetPlayerPhone(playerid)) {
		return SendClientMessage(playerid, 0x999999FF, "* У Вас нет телефона. Его можно купить в салоне сотовой связи!");
	}
	 else if(GetPVarInt(playerid, "Phone_open") == 0){
		MoralPacket_1(playerid, s_CefInterface, t_CefShow, "Phone");
		STRING_GLOBAL[0] = EOS;
		format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('Phone').showPhone('[\"%d:%02d\",\"%d %s\",100,1]')",hour,minute, day,GetMonthName(month));
		MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, STRING_GLOBAL);
		MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "interface('Phone').addContact('[[\"Больница\",3,-1,1],[\"Полиция\",2,-1,1],[\"ФСИН\",101,-1,1],[\"Такси\",535,-1,1],[\"Механики\",90,-1,1],[\"Время\",60,-1,1],[\"Баланс\",111,-1,1]]')");
		MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "window.setCursorStatus(1, 1)");
		SetTimerEx("UpdatePhoneTimer", 1000, true, "i", playerid);
		SetPVarInt(playerid, "Phone_open", 1);
		SCM(playerid, 0xFAAC58FF, "{FFA500}Чтобы скрыть {FFA500}/{FFA500} показать курсор, используйте ALT; чтобы скрыть телефон, нажмите стрелочку вниз");
	}
		else
	{
		SetPVarInt(playerid, "Phone_open", 0);
		callcmd::phonehide(playerid);
		KillTimer(timecarsh[playerid]);
	}
	return 0;
}

cmd:getmygarage(playerid, params[])
{
	new garage_id = GetPVarInt(playerid, "ownablegarage_id");
	if(garage_id != -1)
	{
		new price = 300;

		if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_OFF)
		{
			if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price))
			{
				GivePlayerMoneyEx(playerid, -price, "Метка гаража на GPS", true, true);

				EnablePlayerGPS(playerid, 55, GetGarageData(garage_id, G_POS_X), GetGarageData(garage_id, G_POS_Y), GetGarageData(garage_id, G_POS_Z), "Местоположение Вашего гаража отмечено на GPS");
				return 1;
			}
			else SendClientMessage(playerid, 0xFF6600FF, "* Недостаточно средств");
		}
		else SendClientMessage(playerid, 0xFF6600FF, "* На Вашем GPS уже отмечено место");
	}
	else
	{
		SendClientMessage(playerid, 0xFF6600FF, "* У Вас нет гаража");
	}

	return 0;
}

cmd:jetpack(playerid,  params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");


	if(sscanf(params, "d", params[0]))
		return SendClientMessage(playerid, 0xf6e58dAA, "Используйте: {ffffff}Введите: /jetpack [id игрока]");

    SetPlayerSpecialAction(params[0],SPECIAL_ACTION_USEJETPACK);

	SetPVarInt(playerid, "player_have_jetpack", 1);

    return 1;
}

cmd:alock(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 3 && GetPlayerBuyAdminEx(playerid) < 3) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new vehicleid; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /alock [id транспорта]");
	extract params -> new type;

	if(!IsValidVehicle(vehicleid)) return SendClientMessage(playerid, 0xFF6600FF, "* Данного транспорта не существует на сервере");

	new status = GetVehicleParam(vehicleid, V_LOCK);
	if(status)
	{
		if(type == 1)
		{
			Action(playerid, "открыл чужой транспорт", _, true);
		}
	}
	else
	{
		if(type == 1)
		{
			Action(playerid, "закрыл чужой транспорт", _, true);
		}
	}
	SetVehicleParam(vehicleid, V_LOCK, status ^ VEHICLE_PARAM_ON);

	return 1;
}

cmd:delveh(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4 && GetPlayerYAdminEx(playerid) < 1) return 1;

	extract params -> new vehicleid; else return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /delveh [id авто]");

	if(!IsValidVehicle(vehicleid)) return SendClientMessage(playerid, 0xFF6600FF, "* Данного транспорта не существует на сервере");

	DestroyVehicle(vehicleid);

	return 1;
}
cmd:flipveh(playerid) callcmd::flipcar(playerid, "");
cmd:flipcar(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid == 0)
    {
            SendClientMessage(playerid, 0x999999FF, "* Вы должны находится в транспорте!");
            return 0;
    }

    new Float:x, Float:y, Float:z;
    new Float:angle;

    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, angle);

    SetVehiclePos(vehicleid, x, y, z + 1.5);
    SetVehicleZAngle(vehicleid, angle);

	if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), 500000))
        return SCM(playerid, COLOR_GREY, "* Недостаточно средств.");

    GivePlayerMoneyEx(playerid, -500000, "Починил транспорт");

    static fmt_msg[128];
    format(fmt_msg, sizeof(fmt_msg), "Транспорт средство №%d поставлено на колёса", vehicleid);
    SendClientMessage(playerid, 0xCECECEFF, fmt_msg);

    format(fmt_msg, sizeof(fmt_msg), "Игрок %s[%d] флипнул своё авто через /flipcar", GetPlayerNameEx(playerid), playerid);
    SendMessageToAdmins(fmt_msg, 0xFFFF00FF); 

    return 1;
}
cmd:rang(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) <= 10)) return SendClientMessage(playerid, 0x999999FF, "* Вам недоступна данная функция");
	if(!(9 <= GetPlayerJobName(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "* Функция доступна лидерам организации и их заместителям");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /rang [id игрока] [+/-]");
	extract params -> new to_player, string:give_rang[2];
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(GetPlayerTeamEx(to_player) != GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Этот игрок не состоит в Вашей организации");
	if(GetPlayerJobName(to_player) >= 10) return SendClientMessage(playerid, 0x999999FF, "* Нельзя повысить или понизить лидера организации");

	new current_rang = GetPlayerJobName(to_player);

	static fmt_msg[75];
	if(give_rang[0] == '+')
	{
		if((current_rang + 1) >= GetPlayerJobName(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Нельзя повысить больше своего ранга");

		GetPlayerJobName(to_player)++;
		format(fmt_msg, sizeof fmt_msg, "Ваш ранг в организации был повышен до %d (%s)", GetPlayerJobName(to_player), GetPlayerJobAndRankName(to_player));
		SendClientMessage(to_player, 0x3399FFFF, fmt_msg);
	}
	else if(give_rang[0] == '-')
	{
		if((current_rang - 1) < 1) return SendClientMessage(playerid, 0x999999FF, "* Нельзя понизить ниже 1 ранга");

		GetPlayerJobName(to_player)--;
		format(fmt_msg, sizeof fmt_msg, "Ваш ранг в организации был понижен до %d (%s)", GetPlayerJobName(to_player), GetPlayerJobAndRankName(to_player));
		SendClientMessage(to_player, 0x3399FFFF, fmt_msg);
	}
	else return SendClientMessage(playerid, 0xCECECEFF, "* Введите действие: '+' чтобы повысить или '-' чтобы понизить");

	if(GetPlayerTeamEx(to_player) == TEAM_GOVERNMENT && IsValidDynamic3DTextLabel(GetPlayerData(to_player, P_ADVISOR_LABEL)))
	{
		DestroyDynamic3DTextLabel(GetPlayerData(to_player, P_ADVISOR_LABEL));
		SetPlayerData(to_player, P_ADVISOR_LABEL, Text3D: -1);
	}

	if(!GetPlayerSex(to_player))
	{
		SetPlayerData(playerid, P_OSKIN, GetTeamData(GetPlayerTeamEx(to_player), O_SKINS)[GetPlayerJobName(to_player)-1]);
		ResetSkin(to_player);
	}

	format(fmt_msg, sizeof fmt_msg, "Вы %s ранг %s[%d] до %d (%s)", (give_rang[0] == '+') ? ("повысили") : ("понизили"),  GetPlayerNameEx(to_player), to_player, GetPlayerJobName(to_player), GetPlayerJobAndRankName(to_player));
	SendClientMessage(playerid, 0x3399FFFF, fmt_msg);
	SysPogony_LoadPogonyDelayed(to_player);

	format(fmt_msg, sizeof fmt_msg, "UPDATE PlayersMorallwens SET org_skin=%d,rang=%d WHERE id=%d", GetPlayerData(to_player, P_OSKIN), GetPlayerJobName(to_player), GetPlayerAccountID(to_player));
	mysql_query(mysql, fmt_msg, false);
	return 1;
}

cmd:changeskin(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) <= 10)) return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");
	if(!(9 <= GetPlayerJobName(playerid) <= 10)) return SendClientMessage(playerid, 0x999999FF, "Функция доступна лидерам организации и их заместителям");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /changeskin [id игрока]");
	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(GetPlayerTeamEx(to_player) != GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0x999999FF, "Этот игрок не состоит в Вашей организации");
	if(GetPlayerSex(to_player)) return SendClientMessage(playerid, 0x999999FF, "Нельзя изменить внешность игрокам с женским полом");

	new team_id = GetPlayerTeamEx(playerid);

	static fmt_str[30];
	static query[85];
	static text[(sizeof fmt_str) * 10];
	new old_skin;
	new count;

	SetPVarInt(playerid, "change_team_skin_playerid", to_player);

	format(query, sizeof query, "%s {FFFFFF}начал для вас подбор униформы", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, 0xFFFFFFFF, query);

	for(new i; i < 10; i ++)
	{
		if(old_skin == GetTeamData(team_id, O_SKINS)[i]) continue;

		SetPlayerListitemValue(playerid, count, i);
		count ++;
		old_skin = GetTeamData(team_id, O_SKINS)[i];
		format(fmt_str, sizeof fmt_str, "Скин %d (id %d)\n", count, old_skin);
		strcat(text, fmt_str);
	}
	Dialog(playerid, DIALOG_TEAM_CHANGE_SKIN, DIALOG_STYLE_LIST, "Выберите внешность для игрока:", text, "Ок", "Отмена");

	return 1;
}

cmd:showall(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) <= 10)) return SendClientMessage(playerid, 0x999999FF, "* Вам недоступна данная функция");
	if(!(9 <= GetPlayerJobName(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "* Функция доступна лидерам организации и их заместителям");

	static query[75];
	format(query, sizeof query, "SELECT name, level, rang FROM PlayersMorallwens WHERE team = %d ORDER BY rang DESC", GetPlayerTeamEx(playerid));
	mysql_tquery(mysql, query, "ShowOrgAllPlayers", "i", playerid);
	return 1;
}
cmd:find(playerid, params[])
{
	if(!(GetPlayerTeamEx(playerid) || GetPlayerJobName(playerid))) return SendClientMessage(playerid, 0xCECECEFF, "* Вы нигде не работаете/не состоите в организациях");

	ShowTeamStructureDialog(playerid, GetPlayerTeamEx(playerid));
	return 1;
}
cmd:leaders(playerid)
{
    string_dialog[0] = EOS;
    static text[2048]; // Увеличил буфер
    new Cache: result, rows;

    result = mysql_query(mysql, "SELECT * FROM `PlayersMorallwens` WHERE `admin` = 0 AND `rang` = 10 ORDER BY `team` ASC", true);
    rows = cache_num_rows();

    format(text, sizeof text, " -<t>Организация<t>Должность<t>Имя<t>Телефон{FFFFFF}<n><n>");

    for (new i = 0; i < rows; i++)
    {
        new name[24];
        new user_id = cache_get_field_content_int(i, "id");
        new team = cache_get_field_content_int(i, "team");
        new phone = cache_get_field_content_int(i, "phone");

        cache_get_field_content(i, "name", name);

        new is_online = 0, rank_name[64];
        for (new pid = 0; pid < MAX_PLAYERS; pid++)
        {
            if (!IsPlayerConnected(pid)) continue;
            if (GetPlayerAccountID(pid) == user_id)
            {
                is_online = 1;
                format(rank_name, sizeof rank_name, "%s", GetPlayerJobAndRankName(pid));
                break;
            }
        }

        if (!is_online)
        {
            format(rank_name, sizeof rank_name, "Лидер");
        }

        format(string_dialog, sizeof string_dialog,
            "%s<t>{FFFFFF}%s<t>%s<t>%s<t>%d<n>",
            is_online ? "{228B22}[В игре]" : "{DCDCDC}[Не в игре]",
            GetTeamName(team),
            rank_name,
            name,
            phone
        );

        strcat(text, string_dialog);
        SetPlayerListitemValue(playerid, i, user_id);
    }

    cache_delete(result);
    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCD00}Руководители", text, "Закрыть", "");
    return 1;
}

cmd:liclist(playerid)
{
	static fmt_text[78],
		list[sizeof fmt_text * 10 + 50] = "Организация - Должность - Имя - Телефон{FFFFFF}\n";

	foreach(new i : Player)
	{
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;
		else if(GetPlayerTeamEx(i) != TEAM_GOVERNMENT) continue;
		else if(GetPlayerJobName(i) != 6) continue;

		format(fmt_text, sizeof fmt_text, "\nПравительство - Лицензёр - %s[%d] - тел. %d", GetPlayerNameEx(i), i, GetPlayerPhone(i));
		strcat(list, fmt_text);
	}

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCD00}Лицензёры онлайн", list, "Закрыть", "");

	return 1;
}

cmd:adlist(playerid, params[])
{
	static fmt_text[78],
		list[sizeof fmt_text * 10 + 50] = "Организация - Должность - Имя - Телефон{FFFFFF}\n";

	foreach(new i : Player)
	{
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;
		else if(GetPlayerTeamEx(i) != TEAM_GOVERNMENT) continue;
		else if(GetPlayerJobName(i) != 7) continue;

		format(fmt_text, sizeof fmt_text, "\nПравительство - Адвокат - %s[%d] - тел. %d", GetPlayerNameEx(i), i, GetPlayerPhone(i));
		strcat(list, fmt_text);
	}

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCD00}Адвокаты онлайн", list, "Закрыть", "");

	return 1;
}
cmd:debtorsell(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT) return SendClientMessage(playerid, 0x999999FF, "* Функция доступна сотрудникам правительства");
	if(GetPlayerJobName(playerid) < 6) return SendClientMessage(playerid, 0xCECECEFF, "* Команда доступна сотрудникам правительства с 6 ранга");

	Dialog
	(
		playerid, DIALOG_DEBTOR_SELL_LIST, DIALOG_STYLE_LIST,
		"Выберите действие",
		"1. Выселить должника из жилья\n\
		2. Забрать предприятие у должника\n\
		3. Забрать АЗС у должника",
		"Далее", "Закрыть"
	);
	return 1;
}

cmd:debtorlist(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT) return SendClientMessage(playerid, 0x999999FF, "* Функция доступна сотрудникам правительства");
	if(GetPlayerJobName(playerid) < 3) return SendClientMessage(playerid, 0xCECECEFF, "* Команда доступна сотрудникам правительства с 3 ранга");

	Dialog
	(
		playerid, DIALOG_DEBTORLIST, DIALOG_STYLE_LIST,
		"Выберите тип собственности",
		"1. Жилье\n\
		2. Предприятия\n\
		3. Заправочные станции",
		"Выбрать", "Закрыть"
	);
	return 1;
}
cmd:smenu(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJobName(playerid) != 5) return SendClientMessage(playerid, 0x999999FF, "* Функция доступна советникам правительства");

	Dialog
	(
		playerid, DIALOG_ADVISOR_MENU, DIALOG_STYLE_LIST,
		"{33CC66}Меню советника",
		"1. Показать/скрыть бейджик\n\
		2. Показать/скрыть рацию организации\n\
		3. Показать состав организации",
		"Выбрать", "Закрыть"
	);
	return 1;
}

cmd:givelic(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJobName(playerid) != 6) return SendClientMessage(playerid, 0x999999FF, "* Функция доступна только лицензерам");

	if(!strlen(params))
	{
		SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givelic [id игрока] [идентификатор лицензии] [цена]");
		SendClientMessage(playerid, 0x999999FF, "* Индификаторы лицензий: 1 - Вод. права базового уровня | 2 - Вод. права профессионального уровня | 3 - На оружие");
		return 1;
	}

	extract params -> new to_player, lic_id, price;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок слишком далеко");

	if(!(1 <= lic_id <= 3)) return SendClientMessage(playerid, 0x999999FF, "* Неверный идентификатор лицензии");

	switch(lic_id)
	{
		case 1:
		{
			if(GetPlayerData(to_player, P_DRIVING_LIC) >= 1)
				return SendClientMessage(playerid, 0x999999FF, "* У игрока уже есть лицензия на вождение базового уровня");
		}
		case 2:
		{
			if(GetPlayerData(to_player, P_DRIVING_LIC) == 2)
				return SendClientMessage(playerid, 0x999999FF, "* У игрока уже есть лицензия на вождение профессионального уровня");
		}
		case 3:
		{
			if(GetPlayerData(to_player, P_WEAPON_LIC) == 1)
				return SendClientMessage(playerid, 0x999999FF, "* У игрока уже есть лицензия на оружие");
		}
	}

	new lic_price_limits[3][2] =
	{
		{25000000, 	50000000},
		{50000000, 100000000},
		{100000000, 200000000}
	};

	if(!(lic_price_limits[lic_id - 1][0] <= price <= lic_price_limits[lic_id - 1][1]))
	{
		static fmt_text[60];

		format(fmt_text, sizeof fmt_text, "Стоимость лицензии должна быть от %d до %d рублей",
		lic_price_limits[lic_id - 1][0], lic_price_limits[lic_id - 1][1]);

		SendClientMessage(playerid, 0x999999FF, fmt_text);

		return 1;
	}

	if(!GetILPlayerInt(GetPlayerMoneyEx(to_player), price))
		return SendClientMessage(playerid, 0x999999FF, "* У игрока нет такой суммы денег");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_GIVE_LIC, lic_id, price);

	return 1;
}

cmd:free(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJobName(playerid) != 7) return SendClientMessage(playerid, 0x999999FF, "* Функция доступна только адвокатам");

	extract params -> new to_player, price; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /free [id игрока] [цена]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок слишком далеко");

	if(!GetPlayerData(to_player, P_JAIL))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок не находится в тюрьме");

	if(!(500 <= price <= 50000))
		return SendClientMessage(playerid, 0x999999FF, "* Стоимость должна быть от 500 до 50.000 рублей");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_JAIL_FREE, price);

	return 1;
}

cmd:medhelp(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_HOSPITAL) return SendClientMessage(playerid, 0x999999FF, "* Вы не медицинский работник");
	//if(!IsPlayerInRangeOfPoint(playerid, 70.0, 431.3744,1704.7421,1001.0000)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в больнице");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Использование: /medhelp [id игрока] [стоимость лечения]");
	extract params -> new to_player, price;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "* Пациент слишком далеко");
	if(GetPlayerData(to_player, P_OCCUPIED_BED) == -1) return SendClientMessage(playerid, 0x999999FF, "* Этот игрок не лежит в больнице");
	if(!(100 <= price <= 5000)) return SendClientMessage(playerid, 0xCECECEFF, "* Стоимость лечения должна быть от 100 до 5000 рублей");
	if(!GetILPlayerInt(GetPlayerMoneyEx(to_player), price)) return SendClientMessage(playerid, 0x999999FF, "* У пациента нет с собой столько денег");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_MEDHELP, price);
	return 1;
}

cmd:out(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_HOSPITAL) return SendClientMessage(playerid, 0x999999FF, "* Вы не медицинский работник");
	if(!IsPlayerInRangeOfPoint(playerid, 70.0, 431.3744,1704.7421,1001.0000)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в больнице");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /out [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");
	if(GetPlayerData(to_player, P_OCCUPIED_BED) == -1) return SendClientMessage(playerid, 0x999999FF, "* Игрок должен находиться на лечении");

	ClearMedBed(to_player, GetPlayerData(playerid, P_OCCUPIED_BED));
	SetPlayerData(to_player, P_HOSPITAL, false);

	SetPlayerChatBubble(to_player, "Выписан", 0x66CC00FF, 10.0, 2000);

	static fmt_msg[60];
	format(fmt_msg, sizeof fmt_msg, "Медицинский работник %s выписал Вас из больницы", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, 0x3399FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы выписали %s из больницы", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, 0x3399FFFF, fmt_msg);
	return 1;
}

cmd:heal(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_HOSPITAL) return SendClientMessage(playerid, 0x999999FF, "* Вы не медицинский работник");
	//if(!IsPlayerInRangeOfPoint(playerid, 70.0, 431.3744,1704.7421,1001.0000)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в больнице");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Использование: /heal [id игрока] [цена за лечение]");
	extract params -> new to_player, price;

	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	//if(!IsPlayerInRangeOfPoint(to_player, 70.0, 431.3744,1704.7421,1001.0000)) return SendClientMessage(playerid, 0xCECECEFF, "* Вам пациент должег тоже быть в больнице.");
	if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_MED_CAR || GetPlayerVehicleID(to_player) != vehicleid) return SendClientMessage(playerid, 0x999999FF, "* Вы или Ваш пациент находитесь не в машине скорой помощи");
	if(!(0 <= price <= 5000)) return SendClientMessage(playerid, 0xCECECEFF, "* Стоимость лечения должна быть от 0 до 5000 рублей");
	if(!GetILPlayerInt(GetPlayerMoneyEx(to_player), price)) return SendClientMessage(playerid, 0x999999FF, "* У пациента нет с собой столько денег");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_HEAL, price);
	return 1;
}

cmd:changesex(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_HOSPITAL) return SendClientMessage(playerid, 0x999999FF, "* Вы не медицинский работник");
	if(!IsPlayerInRangeOfPoint(playerid, 70.0, 431.3744,1704.7421,1001.0000)) return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться в больнице");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Использование: /changesex [id игрока] [стоимость операции]");
	extract params -> new to_player, price;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");
	if(GetPlayerData(to_player, P_OCCUPIED_BED) == -1) return SendClientMessage(playerid, 0xCECECEFF, "* Игрок должен находиться на стационарном лечении");
	if(!(500000 <= price <= 1000000)) return SendClientMessage(playerid, 0xCECECEFF, "* Стоимость операции должна быть от 500000 до 1000000 рублей");
	if(!GetILPlayerInt(GetPlayerMoneyEx(to_player), price)) return SendClientMessage(playerid, 0x999999FF, "* У пациента нет с собой столько денег");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_CHANGE_SEX, price);
	return 1;
}

cmd:cuff(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Вы не работник правоохранительных органов");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /cuff [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");

	if(GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0x999999FF, "* Игрок уже закован в наручники");

	SetPlayerSpecialAction(to_player, SPECIAL_ACTION_CUFFED);
	SetPlayerAttachedObject(to_player, A_OBJECT_SLOT_HAND, 19418, A_OBJECT_BONE_RIGHT_HAND, -0.011, 0.028, -0.022, -15.600012, -33.699977, -81.700035, 0.891999, 1.00, 1.168);
	SetPlayerData(to_player, P_CUFFED, true);

	static fmt_str[90];

	format(fmt_str, sizeof fmt_str, "%s %s надел на %s наручники", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

cmd:uncuff(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid) && GetPlayerAdminEx(playerid) == 0) return SendClientMessage(playerid, 0x999999FF, "* Вы не работник правоохранительных органов");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /uncuff [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");

	if(!GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0x999999FF, "* Игрок не закован в наручники");

	SetPlayerSpecialAction(to_player, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(to_player, A_OBJECT_SLOT_HAND);
	SetPlayerData(to_player, P_CUFFED, false);

	static fmt_str[90];

	format(fmt_str, sizeof fmt_str, "%s %s снял с %s наручники", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

cmd:putpl(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Вы не работник правоохранительных органов");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /putpl [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");

	if(!GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0x999999FF, "* Игрок не закован в наручники");

	new vehicle_id = GetPlayerVehicleID(playerid);
	if(!vehicle_id) return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться в автомобиле");

	if(!IsPlayerInPoliceCar(playerid))
		return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться в служебном транспорте");

	new bool: is_there_some_free_places;

	for(new i = 2; i < 3; i++)
	{
		if(IsVehicleSeatOccupied(vehicle_id, i)) continue;
		PutPlayerInVehicle(to_player, vehicle_id, i);
		is_there_some_free_places = true;
		break;
	}

	if(!is_there_some_free_places) return SendClientMessage(playerid, 0x999999FF, "* Задние места Вашего автомобиля заняты");

	static fmt_str[90];

	format(fmt_str, sizeof fmt_str, "%s %s посадил %s в машину", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

cmd:su(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Вы не работник правоохранительных органов");

	extract params -> new criminalid, string:message[66]; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /su [id игрока] [причина]");

	if(!IsPlayerConnected(criminalid) || !IsPlayerLogged(criminalid) || criminalid == playerid) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, criminalid, 6.0)) return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");

	if(!strlen(message)) return SendClientMessage(playerid, 0x999999FF, "* Введите причину");

	if(GetPlayerSuspect(criminalid) >= 6) return SendClientMessage(playerid, 0x999999FF, "* Игрок имеет максимальный уровень розыска");

	static fmt_text[255];

	AddPlayerData(criminalid, P_SUSPECT, +, 1);
	SetPlayerSuspectInit(criminalid);
	UpdatePlayerDatabaseInt(criminalid, "suspect", GetPlayerData(criminalid, P_SUSPECT));

	format(fmt_text, sizeof fmt_text, "%s объявил Вас в розыск. Причина: %s. Текущий уровень розыска %d", GetPlayerNameEx(playerid), message, GetPlayerSuspect(criminalid));
	SendClientMessage(criminalid, 0x3399FFFF, fmt_text);
	format(fmt_text, sizeof fmt_text, "Вы объявили %s в розыск. Причина: %s. Текущий уровень розыска %d", GetPlayerNameEx(criminalid), message, GetPlayerSuspect(criminalid));
	SendClientMessage(playerid, 0x3399FFFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s %s[%d] объявил %s[%d] в розыск [%d/6], причина: %s", GetPlayerJobAndRankName(playerid),
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(criminalid), criminalid, GetPlayerSuspect(criminalid), message);

	SendMessageToPoliceTeam(fmt_text, 0x3399FFFF, playerid);

	return 1;
}

cmd:clear(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Вы не работник правоохранительных органов");

	extract params -> new criminalid; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /clear [id игрока]");

	if(!IsPlayerConnected(criminalid) || !IsPlayerLogged(criminalid) || criminalid == playerid) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!GetPlayerSuspect(criminalid)) return SendClientMessage(playerid, 0x999999FF, "* Игрок не имеет розыска");

	static fmt_text[255];

	SetPlayerData(criminalid, P_SUSPECT, 0);
	SetPlayerSuspectInit(criminalid);
	UpdatePlayerDatabaseInt(criminalid, "suspect", 0);

	format(fmt_text, sizeof fmt_text, "%s удалил Вас из базы разыскиваемых", GetPlayerNameEx(playerid));
	SendClientMessage(criminalid, 0x3399FFFF, fmt_text);
	format(fmt_text, sizeof fmt_text, "Вы удалили %s из базы разыскиваемых", GetPlayerNameEx(criminalid));
	SendClientMessage(playerid, 0x3399FFFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s %s[%d] удалил %s[%d] из базы разыскиваемых людей", GetPlayerJobAndRankName(playerid),
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(criminalid), criminalid);

	SendMessageToPoliceTeam(fmt_text, 0xFFC000FF, playerid);

	return 1;
}

cmd:arrest(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Вы не работник правоохранительных органов");

	extract params -> new criminalid; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /arrest [id игрока]");

	if(!IsPlayerConnected(criminalid) || !IsPlayerLogged(criminalid) || criminalid == playerid) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!GetPlayerData(criminalid, P_CUFFED)) return SendClientMessage(playerid, 0x999999FF, "* Игрок не в наручниках");

	if(!IsPlayerInRangeOfPoint(playerid, 50.0, 219.7982,1369.9645,12.1993)) return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться у здания Отделения Полиции");

	ArrestPlayer(criminalid, GetPlayerSuspect(criminalid) * 10);

	SetPlayerData(criminalid, P_SUSPECT, 0);
	UpdatePlayerDatabaseInt(criminalid, "suspect", 0);

	SetPlayerSuspectInit(criminalid);

	static fmt_text[128];

	format(fmt_text, sizeof fmt_text, "Вы задержали преступника %s[%d] и заключили его под стражу", GetPlayerNameEx(criminalid), criminalid);
	SendClientMessage(playerid, 0x3399FFFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s %s[%d] задержал Вас и заключил под стражу", GetPlayerJobAndRankName(playerid),
	GetPlayerNameEx(playerid), playerid);
	SendClientMessage(criminalid, 0x3399FFFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s %s[%d] заключил %s[%d] под стражу", GetPlayerJobAndRankName(playerid),
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(criminalid), criminalid);
	SendMessageToPoliceTeam(fmt_text, 0xFFC000FF, playerid);

	SendClientMessage(criminalid, 0xCECECEFF, "* Время до окончания заключения: {CCCC00}/time");

	SetPlayerSpecialAction(criminalid, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(criminalid, A_OBJECT_SLOT_HAND);
	SetPlayerData(criminalid, P_CUFFED, false);

	return 1;
}

cmd:m(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Вы не работник правоохранительных органов");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /m [текст]");

	static fmt_text[128];

	format(fmt_text, sizeof fmt_text, "<< %s %s[%d]: %s >>", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);
	SendMessageInLocal(playerid, fmt_text, 0xFFFF00FF, 60.0);

	return 1;
}

cmd:takelic(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_MVD) return SendClientMessage(playerid, 0x999999FF, "* Вы не работник МВД");

	extract params -> new to_player, string:message[66]; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /takelic [id игрока] [причина]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");

	if(!strlen(message)) return SendClientMessage(playerid, 0x999999FF, "* Введите причину");

	if(!GetPlayerData(to_player, P_DRIVING_LIC)) return SendClientMessage(playerid, 0x999999FF, "* У игрока нет прав");

	static fmt_text[128];

	format(fmt_text, sizeof fmt_text, "%s[%d] забрал у Вас права. Причина: %s", GetPlayerNameEx(playerid), playerid, message);
	SendClientMessage(to_player, 0x3399FFFF, fmt_text);
	format(fmt_text, sizeof fmt_text, "Вы забрали у %s[%d] права. Причина: %s", GetPlayerNameEx(to_player), to_player, message);
	SendClientMessage(playerid, 0x3399FFFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s %s[%d] забрал у %s[%d] %s права, причина: %s", GetPlayerJobAndRankName(playerid),
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, GetPlayerData(to_player, P_DRIVING_LIC) == 2 ? "проф." : "базовые", message);

	SendMessageToPoliceTeam(fmt_text, 0xFFC000FF, playerid);

	SetPlayerData(to_player, P_DRIVING_LIC, 0);
	UpdatePlayerDatabaseInt(to_player, "driving_lic", 0);

	return 1;
}

cmd:wanted(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Вы не работник правоохранительных органов");

	static fmt_text[40];

	string_dialog = "Розыск\tИмя{FFFFFF}\n";

	foreach(new i : Player)
	{
		if(!GetPlayerSuspect(i)) continue;
		format(fmt_text, sizeof fmt_text, "\n%d\t\t%s", GetPlayerSuspect(i), GetPlayerNameEx(i));
		strcat(string_dialog, fmt_text);
	}

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{ffcd00}Список разыскиваемых", string_dialog, "Закрыть", "");

	return 1;
}

cmd:setmark(playerid, params[])
{
	if(!IsPlayerInPoliceTeam(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Вы не работник правоохранительных органов");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setmark [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!GetPlayerSuspect(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок не в розыске");

	new Float: x,
		Float: y,
		Float: z;

	GetPlayerPos(to_player, x, y, z);

	EnablePlayerGPS(playerid, 37, x, y, z, "{66cc33}В последний раз преступника видели на отмеченном месте");

	return 1;
}

cmd:delticket(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_MVD) return SendClientMessage(playerid, 0x999999FF, "* Вы не сотрудник МВД");

	extract params -> new ticket_id; else return SendClientMessage(playerid, 0xCECECEFF, "* /delticket [номер штрафа]");

	static query[144],
		Cache: result,
		rows,
		uid,
		reason[64],
		player_name[21],
		status,
		amount;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM tickets WHERE id=%d", ticket_id);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	uid = cache_get_field_content_int(0, "uid");
	status = cache_get_field_content_int(0, "status");
	amount = cache_get_field_content_int(0, "amount");

	cache_get_field_content(0, "description", reason);

	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "SELECT name FROM PlayersMorallwens WHERE id=%d", uid);
	result = mysql_query(mysql, query, true);

	cache_get_row(0, 0, player_name);

	cache_delete(result);

	if(!rows) return SendClientMessage(playerid, 0x999999FF, "* Штраф с таким номером не найден");

	if(status) return SendClientMessage(playerid, 0x999999FF, "* Вы не можете удалить уже оплаченный штраф");

	mysql_format(mysql, query, sizeof query, "DELETE FROM tickets WHERE id=%d", ticket_id);
	mysql_query(mysql, query, false);

	format(query, sizeof query, "Вы удалили штраф #%d из базы данных МВД", ticket_id);
	SendClientMessage(playerid, 0x66CC33FF, query);

	format(query, sizeof query, "%s %s[%d] удалил штраф #%d (%s,%s,%d руб) из базы данных МВД", GetPlayerJobAndRankName(playerid),
	GetPlayerNameEx(playerid), playerid, ticket_id, player_name, reason, amount);

	SendMessageToTeam(GetPlayerTeamEx(playerid), query, 0xFFC000FF, playerid);

	return 1;
}

cmd:mytickets(playerid, params[])
{
	type_page_cars[playerid] = 0;
	page_cars[playerid] = 1;
	ShowOwnableTickets(playerid, page_cars[playerid], 1);
	return 1;
}

cmd:buygarage(playerid, params[])
{
	if(GetPlayerOwnableGarage(playerid) + 1 > GetPlayerGarageSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "* Вы уже имеете максимально количество гаражей.");

	new garage_id = GetNearestGarage(playerid, 4.0);

	new houseid = GetNearestHouse(playerid, 40.0);
	if(houseid != -1) if(GetHouseData(houseid, H_OWNER_ID) != GetPlayerAccountID(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не можете купить данный гараж, данный гараж может только купить владелец дома.");

	if(garage_id != -1)
	{
		SetPVarInt(playerid, "buy_garage_id", garage_id);

		static fmt_type[30];
		if(GetGarageData(garage_id, G_TYPE) == 1) format(fmt_type, sizeof fmt_type, "Эконом");
		if(GetGarageData(garage_id, G_TYPE) == 2) format(fmt_type, sizeof fmt_type, "Средний");
		if(GetGarageData(garage_id, G_TYPE) == 3) format(fmt_type, sizeof fmt_type, "Элитный");

		static fmt_str[356];
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffffff}Класс:\t\t\t\t{4C6475}%s\n"\
			"{ffffff}Стоимость:\t\t\t{6A6CAD}%s руб\n"\
			"{ffffff}Плата за аренду:\t\t{6A6CAD}%s руб в день\n\n"\
			"{797B6A}Вы уверены что хотите купить этот гараж?",
			fmt_type,
			formatInt(GetGarageData(garage_id, G_PRICE)),
			formatInt(GetGarageData(garage_id, G_RENT_PRICE))
		);
		Dialog(playerid, DIALOG_GARAGE_BUY, DIALOG_STYLE_MSGBOX, "{FFD83D}Покупка гаража", fmt_str, "Да", "Нет");
	}
	else SendClientMessage(playerid, 0xFF6600FF, "* Вы должны быть рядом с гаражем, который хотите купить");

	return 1;
}

cmd:sellgarage(playerid, params[])
{
	static query[94],
		Cache: result,
		biz_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM garage WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();

	if(!rows) return SendClientMessage(playerid, 0x999999FF, "* У вас не одного гаража во владении.");

	string_dialog[0] = EOS;
	for(new i = 0; i < rows; i ++)
	{
		biz_id = cache_get_field_content_int(i, "id");

		format(query, sizeof query, "{FFFFFF}-Гараж: %d\n", biz_id);

		strcat(string_dialog, query);
		SetPlayerListitemValue(playerid, i, biz_id-1);
	}

	Dialog
	(
		playerid, DIALOG_SELL_GARAGE_LIST, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите гараж",
		string_dialog,
		"Выбрать", "Закрыть"
	);

	cache_delete(result);
	return 1;
}

cmd:garage(playerid, params[])
{
	static query[94],
		Cache: result,
		biz_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM garage WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();

	if(!rows) return SendClientMessage(playerid, 0x999999FF, "* У вас не одного гаража во владении.");

	string_dialog[0] = EOS;
	for(new i = 0; i < rows; i ++)
	{
		biz_id = cache_get_field_content_int(i, "id");

		format(query, sizeof query, "{FFFFFF}-Гараж: %d\n", biz_id);

		strcat(string_dialog, query);
		SetPlayerListitemValue(playerid, i, biz_id-1);
	}

	Dialog
	(
		playerid, DIALOG_INFO_GARAGE_LIST, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите гараж",
		string_dialog,
		"Выбрать", "Закрыть"
	);

	cache_delete(result);

	return 1;
}

cmd:gotogarage(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4 && GetPlayerBuyAdminEx(playerid) < 4) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	extract params -> new garage_id; else return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /togarage [номер гаража]");

	if(!(0 <= garage_id <= g_garage_loaded-1)) return SendClientMessage(playerid, 0xFF6600FF, "* Данного гаража не существует на сервере");

	SetPlayerPosEx
	(
		playerid,
		GetGarageData(garage_id, G_EXIT_POS_X),
		GetGarageData(garage_id, G_EXIT_POS_Y),
		GetGarageData(garage_id, G_EXIT_POS_Z),
		GetGarageData(garage_id, G_EXIT_ANGLE)
	);

	static fmt_text[65];

	format(fmt_text, sizeof fmt_text, "Вы телепортировались к гаражу {FFD83D}№%d", garage_id);
	SendClientMessage(playerid, -1, fmt_text);

	return 1;
}

cmd:addgarage(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	 

	extract params -> new price, rent_price, type; else return SendClientMessage(playerid, COLOR_WHITE, "{FFD83D}Используйте:{"#cW"} /addgarage [стоимость] [Ежедневная плата] [тип]");
	static fmt_text[300];

	if(price < 1) return SendClientMessage(playerid, 0xFF6600FF, "* Стоимость дома не может быть меньше 1");

	if(rent_price < 1) return SendClientMessage(playerid, 0xFF6600FF, "* Стоимость ежедневной платы не может быть меньше 1");

	if(type < 1 || type > 3) return SendClientMessage(playerid, 0xFF6600FF, "* 1 - низкий, 2 - средний, 3 - элитный");

	new Cache: result,
		idx = g_garage_loaded;

	GetPlayerPos(playerid, g_garage[idx][G_POS_X], g_garage[idx][G_POS_Y], g_garage[idx][G_POS_Z]);

	SetGarageData(idx, G_PRICE,			price);
	SetGarageData(idx, G_RENT_PRICE,	rent_price);
	SetGarageData(idx, G_TYPE,	type);

	format
	(
		fmt_text, sizeof fmt_text,
		"INSERT INTO garage \
		(price, rent_price, x, y, z, type)\
		VALUES ('%d', '%d', '%f', '%f', '%f', '%d')",
		price, rent_price,
		GetGarageData(idx, G_POS_X),
		GetGarageData(idx, G_POS_Y),
		GetGarageData(idx, G_POS_Z),
		type
	);

	result = mysql_query(mysql, fmt_text, true);

	SetGarageData(idx, G_SQL_ID,			cache_insert_id());

	cache_delete(result);

	g_garage_loaded ++;

	UpdateGarage(idx);

	SetGarageData(idx, G_LABEL, CreateDynamic3DTextLabel(" - ", 0xFFFF00FF, GetGarageData(idx, G_POS_X), GetGarageData(idx, G_POS_Y), GetGarageData(idx, G_POS_Z) + 0.5, 6.50));

	UpdateGarageLabel(idx);

	format(fmt_text, sizeof fmt_text, "A: %s [%d] создал гараж №%d", GetPlayerNameEx(playerid), playerid, idx);

	SendMessageToAdmins(fmt_text, COLOR_GREY);

	SendClientMessage(playerid, -1, "* {FFD83D}Используйте {"#cW"}/set_garage_exit, чтобы установить точку выхода с гаража");
	SendClientMessage(playerid, -1, "* {FFD83D}Используйте {"#cW"}/set_garage_car, чтобы установить точку выезда в авто с гаража");
	return 1;
}
cmd:set_garage_pick(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new garage_id; else return SendClientMessage(playerid, COLOR_WHITE, "{FFD83D}Используйте:{"#cW"} /set_garage_exit [id гаража]");

	if(!(0 <= garage_id <= g_garage_loaded)) return SendClientMessage(playerid, 0xFF6600FF, "* Данного гаража не существует на сервере");

	new garage = garage_id - 1;


	static fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE garage SET x=1000 WHERE id=%d",
		GetGarageData(garage, G_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты выхода у гаража {FFD83D}№%d", garage + 1);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

cmd:set_garage_exit(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new garage_id; else return SendClientMessage(playerid, COLOR_WHITE, "{FFD83D}Используйте:{"#cW"} /set_garage_exit [id гаража]");

	if(!(0 <= garage_id <= g_garage_loaded)) return SendClientMessage(playerid, 0xFF6600FF, "* Данного гаража не существует на сервере");

	new garage = garage_id;

	GetPlayerPos(playerid, g_garage[garage][G_EXIT_POS_X], g_garage[garage][G_EXIT_POS_Y], g_garage[garage][G_EXIT_POS_Z]);
	GetPlayerFacingAngle(playerid, g_garage[garage][G_EXIT_ANGLE]);

	static fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE garage SET exit_x='%f', exit_y='%f', exit_z='%f', exit_angle='%f' WHERE id=%d",
		GetGarageData(garage, G_EXIT_POS_X),
		GetGarageData(garage, G_EXIT_POS_Y),
		GetGarageData(garage, G_EXIT_POS_Z),
		GetGarageData(garage, G_EXIT_ANGLE),
		GetGarageData(garage, G_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты выхода у гаража {FFD83D}№%d", garage);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

cmd:set_garage_car(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new garage_id; else return SendClientMessage(playerid, COLOR_WHITE, "{FFD83D}Используйте:{"#cW"} /set_garage_car [id гаража]");

	if(!(0 <= garage_id <= g_garage_loaded)) return SendClientMessage(playerid, 0xFF6600FF, "* Данного гаража не существует на сервере");

	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в транспорте");

	new vehicleid = GetPlayerVehicleID(playerid);

	new garage = garage_id;

	GetVehiclePos(vehicleid, g_garage[garage][G_CAR_POS_X], g_garage[garage][G_CAR_POS_Y], g_garage[garage][G_CAR_POS_Z]);
	GetVehicleZAngle(vehicleid, g_garage[garage][G_CAR_ANGLE]);

	static fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE garage SET car_x='%f', car_y='%f', car_z='%f', car_angle='%f' WHERE id=%d",
		GetGarageData(garage, G_CAR_POS_X),
		GetGarageData(garage, G_CAR_POS_Y),
		GetGarageData(garage, G_CAR_POS_Z),
		GetGarageData(garage, G_CAR_ANGLE),
		GetGarageData(garage, G_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты спавна авто у гаража {FFD83D}№%d", garage);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

cmd:ptickets(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_MVD) return SendClientMessage(playerid, 0x999999FF, "* Вы не работник МВД");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /ptickets [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");

	static query[128],
		Cache: result,
		rows;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM tickets WHERE uid=%d", GetPlayerAccountID(to_player));
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	SendClientMessage(playerid, 0x66CC33FF, "Список штрафов:");

	if(!rows)
		SendClientMessage(playerid, 0xFFCD00FF, "Штрафы отсутствуют");

	else
	{
		new paid_tickets;

		for(new idx; idx < rows; idx ++)
		{
			new id = cache_get_field_content_int(idx, "id"),
				amount = cache_get_field_content_int(idx, "amount"),
				status = cache_get_field_content_int(idx, "status"),
				desc[64],
				issuer[32];

			cache_get_field_content(idx, "description", desc);
			cache_get_field_content(idx, "issuer", issuer);

			format(query, sizeof query, "#%d | %d руб | %s | Выдал: %s | %s", id, amount, desc, issuer, status ? "{66CC33}Оплачен" : "{FF5533}Не оплачен");
			SendClientMessage(playerid, 0xFFCD00FF, query);

			if(status) paid_tickets ++;
		}

		format(query, sizeof query, "Общее количество штрафов: %d | Оплачены: %d | Не оплачены: %d", rows, paid_tickets, rows-paid_tickets);
		SendClientMessage(playerid, 0x66CC33FF, query);
	}

	cache_delete(result);

	return 1;
}

cmd:skill(playerid, params[])
{
	extract params -> new to_player; else return SendClientMessage(playerid, 0x999999FF, "* Используйте: /skill [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(to_player == playerid)
	{
		ShowPlayerSkills(playerid);
		return Action(playerid, "просматривает свои навыки владения оружием", _, false);
	}

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_SHOW_SKILL);

	return 1;
}

cmd:diagnostics(playerid)
{
	new Float:POS[5];
	new vehicleid = GetNearestVehicleID(playerid, 6.0);
	if(vehicleid == -1)
		return SCM(playerid, 0xCECECEFF, "* Вы должны находится около Т/С");
	
    GetCoordVehicle(vehicleid, VEHICLE_COORD_TYPE_BOOT, POS[0], POS[1], POS[2], POS[3], POS[4]);
	if(!IsPlayerInRangeOfPoint(playerid, 4.0, POS[0], POS[1], POS[2]))
	    return SCM(playerid, 0xCECECEFF, "* Вы должны находится около капота");

	if(GetIteam(playerid, 254) < 1) return SCM(playerid, 0xCECECEFF, "* У вас нет набора для диагностики. Он есть в магазине 24/7");

	static fmt_text[512];
	
	new model_id = GetVehicleData(vehicleid, V_MODELID);
	new index = GetVehicleData(vehicleid, V_ACTION_ID);
	format(fmt_text, sizeof fmt_text, "[\"%s\", \"\", \"Неопределенный\", %d, \"%s\", %d, \"%s\", 3]", GetVehicleInfo(model_id, VI_NAME), formatInt(GetVehicleInfo(model_id, VI_PRICE)), GetPlayerNameBySqlID(GetOwnableCarData(index, OC_OWNER_ID)), GetVehicleData(vehicleid, V_MILEAGE), GetVehicleInfo(model_id , VI_NAME));

	MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Diagnostics", fmt_text);

    //BattlePass_Completingtasks(playerid, 1, 4);

	GiveIteam(playerid, 254, 0, 1, 0);
	SCM(playerid, 0xCECECEFF, "* Вы начали диагностику автомобиля. С вас было снято 1 использование набора");

	return 1;
}

cmd:ad(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0x999999FF, "* У Вас нет телефона, по которому могут с Вами связаться");

	static fmt_text[144];

	for(new idx; idx < g_advert_created; idx ++)
	{
		if(GetAdvertData(idx, A_CREATOR) != playerid) continue;

		format(fmt_text, sizeof fmt_text, "Ваше объявление уже находится в очереди под {00CC99}номером %d", GetAdvertIndexInQueue(idx));
		SendClientMessage(playerid, 0xCECECEFF, fmt_text);

		return 1;
	}

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /ad [текст объявления]");

	if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), ADVERT_SEND_PRICE))
		return SendClientMessage(playerid, 0x999999FF, "* Для отправки объявления необходимо иметь 2500 руб");

    if(strfind(params,"%s") != -1) return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");
	if(strfind(params,"%ss") != -1) return SendClientMessage(playerid, 0xFF6600FF, "* В сообщение присутствуют запрещеные символы");

	SendAdvert(playerid, params);

	GivePlayerMoneyEx(playerid, -2500, "Отправка объявления", true, true);

	format(fmt_text, sizeof fmt_text, "Текст: %s", params);
	SendClientMessage(playerid, 0x00CC99FF, fmt_text);

	SendClientMessage(playerid, -1, "* Ваше объявление было добавлено в очередь для публикации");
	SendClientMessage(playerid, -1, "* Оставайтесь на связи, в противном случае объявление будет удалено из очереди");
	return 1;
}

cmd:edit(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_RADIO) return SendClientMessage(playerid, 0x999999FF, "* Вам недоступна данная функция");

	if(GetPlayerData(playerid, P_MUTE)) return SendClientMessage(playerid, 0x999999FF, "* Вы не можете использовать данную функцию пока не пройдёт блокировка чата");

	if(!g_advert_created) return SendClientMessage(playerid, 0xCECECEFF, "* Нет объявлений для редактирования");

	static fmt_text[360],
		bool: ad_is_found;

	for(new idx; idx < g_advert_created; idx ++)
	{
		if(GetAdvertData(idx, A_EDIT) || GetAdvertData(idx, A_CREATOR) == INVALID_PLAYER_ID) continue;

		format
		(
			fmt_text, sizeof fmt_text,
			"{FFFFFF}Отправитель: %s\nТекст: {FFCD00}%s\n\n"\
			"{FFFFFF}Введите новый текст для этого объявления или оставьте поле пустым если редактирование не нужно\n"\
			"Вы также можете отклонить объявление с причиной, или использовать замену слов: [old]=[new]",
			GetPlayerNameEx(GetAdvertData(idx, A_CREATOR)), GetAdvertData(idx, A_TEXT)
		);

		Dialog(playerid, DIALOG_ADVERT_EDIT, DIALOG_STYLE_INPUT, "{00CC00}Публикация объявления", fmt_text, "Отправить", "Отклонить");

		SetAdvertData(idx, A_EDIT, true);

		SetPVarInt(playerid, "advert_id", idx);

		ad_is_found = true;

		break;
	}

	if(!ad_is_found) return SendClientMessage(playerid, 0xCECECEFF, "* Нет объявлений для редактирования");

	return 1;
}

cmd:t(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_RADIO) return SendClientMessage(playerid, 0x999999FF, "* Вам недоступна данная функция");
	if(!GetPVarInt(playerid, "efir")) return SendClientMessage(playerid, 0x999999FF, "* Вы не подключены к радио-эфиру");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /t [текст]");

	static fmt_text[144];

	format(fmt_text, sizeof fmt_text, "[ТРК «Ритм»] %s: %s", GetPlayerNameEx(playerid), params);
	SendClientMessageToAll(0x6666FFFF, fmt_text);

	return 1;
}

cmd:u(playerid, params[])
{
	if(!GetPVarInt(playerid, "radio_mic")) return SendClientMessage(playerid, 0x999999FF, "* Вы не подключены к радио-эфиру");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /u [текст]");

	static fmt_text[144];

	format(fmt_text, sizeof fmt_text, "[ТРК «Ритм»] Гость %s: %s", GetPlayerNameEx(playerid), params);
	SendClientMessageToAll(0x6666FFFF, fmt_text);

	return 1;
}

cmd:givemic(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_RADIO) return SendClientMessage(playerid, 0x999999FF, "* Вам недоступна данная функция");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givemic [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!GetPVarInt(to_player, "radio_mic"))
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_GIVE_MIC);

	else
	{
		static fmt_text[128];

		format(fmt_text, sizeof fmt_text, "%s %s[%d] отключил Вас от радио-эфира",
		GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);

		SendClientMessage(to_player, 0xFF5533FF, fmt_text);

		format(fmt_text, sizeof fmt_text, "Вы отключили %s[%d] от радио-эфира", GetPlayerNameEx(to_player), to_player);
		SendClientMessage(playerid, 0x3399FFFF, fmt_text);

		format(fmt_text, sizeof fmt_text, "[СМИ] %s %s[%d] отключил %s[%d] от радио-эфира",
		GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

		SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_text, 0x99CC99FF, playerid);

		SetPVarInt(to_player, "radio_mic", 0);
	}

	return 1;
}

cmd:efir(playerid)
{
    if(GetPlayerTeamEx(playerid) != TEAM_RADIO) return SendClientMessage(playerid, 0xFF6600FF, "* Вам недоступна данная функция");
    if(!(GetPlayerJobName(playerid) > 4)) return SendClientMessage(playerid, 0xFF6600FF, "* Функция доступна с 4 ранга");
    switch(GetPVarInt(playerid, "efir"))
    {
        case 0:
        {
            SetPVarInt(playerid, "efir", 1);
            SendClientMessage(playerid, 0x33FF33AA, "Вы успешно подключились к эфиру");
            SendClientMessage(playerid, 0x33FF33AA, "Отправить сообщение в эфире: {"#cW"}/t");
        }
        case 1:
        {
            SetPVarInt(playerid, "efir", 0);
            SendClientMessage(playerid, 0xFF6666FF, "Вы успешно отключились от эфира");
        }
    }

    return 1;
}

cmd:setspeed(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid) && GetPlayerData(playerid, P_SONYC) == 0) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "* Вы не находитесь в транспорте");

	extract params -> new Float: speed; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setspeed [кол-во скорости]");

	new vehicleid = GetPlayerVehicleID(playerid);

	SetVehicleSpeed(vehicleid, speed);

	SendClientMessage(playerid, 0xCECECEFF, "* Скорость изменена");

	return 1;
}

cmd:bcode(playerid, params[])
{
	Dialog
	(
	playerid, DIALOG_BONUSCODE_ACTIVATE, DIALOG_STYLE_INPUT,"Активация бонус кода","Введите ваш бонус код в поле ниже","Далее", "Отмена"
	);
	return 1;
}
cmd:pcode(playerid, params[])
{
	Dialog
	(
		playerid, DIALOG_PROMO_ACTIVATE, DIALOG_STYLE_INPUT,
		"Промокод",
		"{FFFFFF}Чтобы использовать промокод введите его в поле ниже:\n\n"\
		"{888888}Примечание: Используйте команду /plist чтобы посмотреть\n"\
		"сколько осталось отыграть до получения бонуса",
		"Ввести", "Закрыть"
	);
	return 1;
}

cmd:afly(playerid, params[])
{
	GameText(playerid,"~w~AFLY ~r~OFF",5000,1);
	if(GetPlayerData(playerid, P_CMD_afly) == 0)
	{
    	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerYAdminEx(playerid) < 2) return 1;
	}
	
	static fmt_text[55],
	bool: fly_status;

	if(StartFly(playerid))
	fly_status = true;

	else
	StopFly(playerid);
	GameText(playerid,"~w~AFLY ~g~ON",5000,1);
	format(fmt_text, sizeof fmt_text, "Вы %s Fly-режим", fly_status ? "включили" : "{FF0000}выключили");
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

cmd:mcuff(playerid, params[])
{
    if(GetPlayerTeamEx(playerid) != TEAM_FSIN) return SendClientMessage(playerid, 0xFF6600FF, "* Вы не сотрудник МЧС");
	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /cuff [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок находится слишком далеко");

	if(GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок уже закован в наручники");

	SetPlayerSpecialAction(to_player, SPECIAL_ACTION_CUFFED);
	SetPlayerAttachedObject(to_player, A_OBJECT_SLOT_HAND, 19418, A_OBJECT_BONE_RIGHT_HAND, -0.011, 0.028, -0.022, -15.600012, -33.699977, -81.700035, 0.891999, 1.00, 1.168);
	SetPlayerData(to_player, P_CUFFED, true);

	static fmt_str[90];

	format(fmt_str, sizeof fmt_str, "%s %s надел на %s наручники", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}
cmd:muncuff(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_FSIN) return SendClientMessage(playerid, 0xFF6600FF, "* Вы не сотрудник МЧС");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /uncuff [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок находится слишком далеко");

	if(!GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок не закован в наручники");

	SetPlayerSpecialAction(to_player, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(to_player, A_OBJECT_SLOT_HAND);
	SetPlayerData(to_player, P_CUFFED, false);

	static fmt_str[90];

	format(fmt_str, sizeof fmt_str, "%s %s снял с %s наручники", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

cmd:mputpl(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_FSIN) return SendClientMessage(playerid, 0xFF6600FF, "* Вы не сотрудник МЧС");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /putpl [ID игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок находится слишком далеко");

	if(!GetPlayerData(to_player, P_CUFFED)) return SendClientMessage(playerid, 0xFF6600FF, "* Игрок не закован в наручники");

	new vehicle_id = GetPlayerVehicleID(playerid);
	if(!vehicle_id) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в автомобиле");

	if(!IsPlayerInPoliceCar(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в служебном транспорте");

	new bool: is_there_some_free_places;

	for(new i = 2; i < 3; i++)
	{
		if(IsVehicleSeatOccupied(vehicle_id, i)) continue;
		PutPlayerInVehicle(to_player, vehicle_id, i);
		is_there_some_free_places = true;
		break;
	}

	if(!is_there_some_free_places) return SendClientMessage(playerid, 0xFF6600FF, "* Задние места Вашего автомобиля заняты");

	static fmt_str[90];

	format(fmt_str, sizeof fmt_str, "%s %s посадил %s в машину", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

cmd:down(playerid,params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /down [id игрока]");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

 	new Float: x, Float: y, Float: z;
	GetPlayerPos(to_player, x, y, z);

	SetPlayerPos(to_player, x, y, z - 5);
	PlayerPlaySound(to_player, 1130, 0.0, 0.0, 0.0);
	return true;
}

cmd:tplist(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1 && GetPlayerBuyAdminEx(playerid) < 1) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	ShowTeleportList(playerid);
	return 1;
}
cmd:healme(playerid, params[])
{
	if(Iter_Contains(DmZonePlayers, playerid)) return 1;

	if(GetIteam(playerid, 2) <= 0)
	return SendClientMessage(playerid, 0xFF6600FF, "* У Вас нет с собой аптечки");

	if(GetPlayerHealthEx(playerid) == 100)
	return SendClientMessage(playerid, 0xFF6600FF, "* Вы не нуждаетесь в лечении");

	GiveIteam(playerid, 2,0, 1,0);
	SetPlayerHealthEx(playerid, 60.0, true);
	SendClientMessage(playerid, 0x6495EDFF, "Вы использовали аптечку. Здоровье пополнено на 60 единиц");
	GameText(playerid, "~g~+60 ~b~hp", 3000, 2);
	ApplyAnimation(playerid, "ped", "gum_eat", 4.0, 0, 0, 0, 0, 0, 0);
	return 1;
}

cmd:present(playerid, params[])
{
	if(!IsPlayerHaveWeapon(playerid, WEAPON_FLOWER))
		return SendClientMessage(playerid, 0xCECECEFF, "* У Вас нет цветов");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /present [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 3.0))
		return SendClientMessage(playerid, 0xCECECEFF, "* Игрок слишком далеко");

	if(IsPlayerHaveWeapon(to_player, WEAPON_FLOWER))
		return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока уже есть букет цветов");

	static fmt_str[64];

	new Float: angle;
	new Float: to_x, Float: to_y;
	new Float: x, Float: y, Float: z;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerPos(to_player, to_x, to_y, z);

	angle = GetAngleToPoint(to_x, to_y, x, y);

	SetPlayerFacingAngle(playerid, angle);
	SetPlayerFacingAngle(to_player, angle + 180.0);

	ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0, 0);
	ApplyAnimation(to_player, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0, 0);

	format(fmt_str, sizeof fmt_str, "%s получил(а) от Вас цветы", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, 0x3399FFFF, fmt_str);

	format(fmt_str, sizeof fmt_str, "%s подарил(а) Вам цветы", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, 0x3399FFFF, fmt_str);

	SetTimerEx("PresentFlowersToPlayer", 1500, false, "ii", playerid, to_player);
	return 1;
}

CMD:mask(playerid, params[])
{
    if (boolHasMask[playerid])
    {
        boolHasMask[playerid] = false;
        format(g_player[playerid][P_NAME], 28, "%s", lastnick[playerid]);
        SetPlayerName(playerid, g_player[playerid][P_NAME]);
        SetPlayerColorInit(playerid);
        ClearAnimations(playerid);
        GameText(playerid, "~r~~h~маска снята", 2500, 3);
        SendClientMessage(playerid, 0xCECECEFF, "* Вы сняли маску. Ваше имя и цвет восстановлены.");
        return 1;
    }

    new bool:hasMask = false;
    if (GetPlayerData(playerid, P_MASK) == 1)
    {
        hasMask = true;
    }
    else
    {
        for (new i = 0; i < 10; i++)
        {
            if (GetIteam(playerid, i) == 255)
            {
                hasMask = true;
                break;
            }
        }
    }

    if (!hasMask)
        return SendClientMessage(playerid, 0xCECECEFF, "* У Вас нет с собой маски");

    boolHasMask[playerid] = true;
    format(lastnick[playerid], 28, "%s", g_player[playerid][P_NAME]);
    format(g_player[playerid][P_NAME], 28, "Mask_%d", g_player[playerid][P_ACCOUNT_ID]);
    SetPlayerName(playerid, g_player[playerid][P_NAME]);
    SetPlayerData(playerid, P_MASK, 600 + 1);
    SetPlayerColorEx(playerid, 0x00000000);
    ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0, 0);
    SetPlayerChatBubble(playerid, "Надевает маску", 0xFF9900FF, 15.0, 5000);
    GameText(playerid, "~b~~h~маска одета", 2500, 3);
    SendClientMessage(playerid, 0x3399FFFF, "* Ваше месторасположение на GPS скрыто на 10 минут");

    return 1;
}

CMD:un_maska(playerid, params[])
{
    if (GetPlayerTeamEx(playerid) != TEAM_FSB && GetPVarInt(playerid, "undercover_active") != 1)
        return SendClientMessage(playerid, 0x999999FF, "* Эта команда доступна только сотрудникам ФСБ");

    extract params -> new to_player; else
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /un_maska [id игрока]");

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
        return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

    if(!GetPlayerData(to_player, P_CUFFED))
        return SendClientMessage(playerid, 0x999999FF, "* Игрок не в наручниках");

    if(!boolHasMask[to_player])
        return SendClientMessage(playerid, 0x999999FF, "* У игрока нет надетой маски");

    boolHasMask[to_player] = false;
    format(g_player[to_player][P_NAME], 28, "%s", lastnick[to_player]);
    SetPlayerName(to_player, g_player[to_player][P_NAME]);
    SetPlayerColorInit(to_player);
    ClearAnimations(to_player);
    GameText(to_player, "~r~~h~маска снята ФСБ", 2500, 3);
    SendClientMessage(to_player, 0xCECECEFF, "* Сотрудник ФСБ снял с вас маску. Ваше имя и цвет восстановлены.");
    SendClientMessage(playerid, 0x00FF00FF, "* Вы сняли маску с игрока.");

    return 1;
}

cmd:home(playerid)
{
	static query[94],
		Cache: result,
		biz_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM houses WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();

	if(!rows) return SendClientMessage(playerid, 0x999999FF, "* У вас не одного дома во владении.");

	string_dialog[0] = EOS;
	for(new i = 0; i < rows; i ++)
	{
		biz_id = cache_get_field_content_int(i, "id");
		new entrance = cache_get_field_content_int(i, "entrance");

		if(entrance == -1)
		{
			if(biz_id == GetPlayerData(playerid, P_ID_SPAWN) && GetPlayerData(playerid, P_SPAWN) == 1) format(query, sizeof query, "{FFFFFF}-Дом: %d | (база)\n", biz_id);
			else format(query, sizeof query, "{FFFFFF}-Дом: %d\n", biz_id);
		}
		else
		{
			if(biz_id == GetPlayerData(playerid, P_ID_SPAWN) && GetPlayerData(playerid, P_SPAWN) == 1) format(query, sizeof query, "{FFFFFF}-Квартира: %d | (база)\n", biz_id);
			else format(query, sizeof query, "{FFFFFF}-Квартира: %d\n", biz_id);
		}
		strcat(string_dialog, query);
		SetPlayerListitemValue(playerid, i, biz_id-1);
	}

	Dialog
	(
		playerid, DIALOG_OWNABLE_HOME_LIST, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите дом",
		string_dialog,
		"Выбрать", "Закрыть"
	);

	cache_delete(result);
	return 1;
}
cmd:sellhome(playerid)
{
	static query[94],
		Cache: result,
		biz_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM houses WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();

	if(!rows) return SendClientMessage(playerid, 0x999999FF, "* У вас не одного дома во владении.");

	string_dialog[0] = EOS;
	for(new i = 0; i < rows; i ++)
	{
		biz_id = cache_get_field_content_int(i, "id");
		new entrance = cache_get_field_content_int(i, "entrance");

		if(entrance == -1)
		{
			if(biz_id == GetPlayerData(playerid, P_ID_SPAWN) && GetPlayerData(playerid, P_SPAWN) == 1) format(query, sizeof query, "{FFFFFF}-Дом: %d | (база)\n", biz_id);
			else format(query, sizeof query, "{FFFFFF}-Дом: %d\n", biz_id);
		}
		else
		{
			if(biz_id == GetPlayerData(playerid, P_ID_SPAWN) && GetPlayerData(playerid, P_SPAWN) == 1) format(query, sizeof query, "{FFFFFF}-Квартира: %d | (база)\n", biz_id);
			else format(query, sizeof query, "{FFFFFF}-Квартира: %d\n", biz_id);
		}

		strcat(string_dialog, query);
		SetPlayerListitemValue(playerid, i, biz_id-1);
	}

	Dialog
	(
		playerid, DIALOG_SELL_HOME_LIST, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите дом",
		string_dialog,
		"Выбрать", "Закрыть"
	);

	cache_delete(result);
	return 1;
}
cmd:sellmyhome(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /sellmyhome [id игрока] [стоимость]");

	extract params -> new to_player, price;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(price < 1)
		return SendClientMessage(playerid, 0xFF6600FF, "* Укажите стоимость продажи");
	
	if((GetPlayerOwnableHouse(to_player) + 1) > GetPlayerHouseSlots(to_player)) 
		return SendClientMessage(playerid, 0x3399FFFF, "* Игрок уже имеете максимально количество домов.");

	if(!GetILPlayerInt(GetPlayerMoneyEx(to_player), price))
		return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока нет такой суммы");

	SetPVarInt(playerid, "Sellprice", price);
	SetPVarInt(playerid, "to_player", to_player);

	static query[94],
		Cache: result,
		biz_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM houses WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();

	if(!rows) return SendClientMessage(playerid, 0x999999FF, "* У вас не одного дома во владении.");

	string_dialog[0] = EOS;
	for(new i = 0; i < rows; i ++)
	{
		biz_id = cache_get_field_content_int(i, "id");
		new entrance = cache_get_field_content_int(i, "entrance");

		if(entrance == -1)
		{
			if(biz_id == GetPlayerData(playerid, P_ID_SPAWN) && GetPlayerData(playerid, P_SPAWN) == 1) format(query, sizeof query, "{FFFFFF}-Дом: %d | (база)\n", biz_id);
			else format(query, sizeof query, "{FFFFFF}-Дом: %d\n", biz_id);
		}
		else
		{
			if(biz_id == GetPlayerData(playerid, P_ID_SPAWN) && GetPlayerData(playerid, P_SPAWN) == 1) format(query, sizeof query, "{FFFFFF}-Квартира: %d | (база)\n", biz_id);
			else format(query, sizeof query, "{FFFFFF}-Квартира: %d\n", biz_id);
		}

		strcat(string_dialog, query);
		SetPlayerListitemValue(playerid, i, biz_id-1);
	}

	Dialog
	(
		playerid, DIALOG_SELL_MY_HOME_LIST, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите дом",
		string_dialog,
		"Выбрать", "Закрыть"
	);

	cache_delete(result);
	return 1;
}

cmd:live(playerid, params[])
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		new type = GetHouseData(houseid, H_TYPE);
		new rooms = GetHouseTypeInfo(type, HT_ROOMS);

		if(GetHouseRentersCount(houseid) >= rooms)
			return SendClientMessage(playerid, 0x999999FF, "* Все комнаты Вашего дома уже заняты");

		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /live [id игрока]"); // [кол-во дней] [цена (необязательно)]

		extract params -> new to_player, days, price;

		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
			return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

		if(GetPlayerHouse(to_player) != -1)
			return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока уже есть дом");

		if(!(IsPlayerInRangeOfHouse(playerid, houseid, 10.0) && IsPlayerInRangeOfHouse(to_player, houseid, 10.0)))
			return SendClientMessage(playerid, 0xCECECEFF, "* Вы и арендатор должны находиться около дома который хотите сдать в аренду");

		SendPlayerOffer(playerid, to_player, OFFER_TYPE_HOME_RENT_ROOM, houseid);
	}
	else SendClientMessage(playerid, 0x999999FF, "* У Вас нет дома");

	return 1;
}

cmd:liveout(playerid, params[])
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_ROOM);
	if(houseid != -1)
	{
		Dialog
		(
			playerid, DIALOG_HOUSE_EVICT, DIALOG_STYLE_MSGBOX,
			"{FF9900}Выселение из дома",
			"{FFFFFF}Вы действительно хотите выселиться из дома?",
			"Да", "Нет"
		);
	}
	else SendClientMessage(playerid, 0x999999FF, "* Вы нигде не проживаете");

	return 1;
}

cmd:makestore(playerid, params[])
{
	new houseid = GetPlayerInHouse(playerid);
	if(houseid != -1)
	{
		if(GetHouseData(houseid, H_IMPROVEMENTS) >= 4)
		{
			if(GetPlayerInHouse(playerid) == houseid)
			{
				new type = GetHouseData(houseid, H_TYPE);
				if(IsPlayerInRangeOfPoint(playerid, 50.0, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z)))
				{
					Dialog
					(
						playerid, DIALOG_HOUSE_MOVE_STORE, DIALOG_STYLE_MSGBOX,
						"{FFCD00}Шкаф",
						"{FFFFFF}Вы хотите разместить шкаф в этом месте?",
						"Да", "Нет"
					);
				}
				else SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться у себя в доме");
			}
			else SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться у себя в доме");
		}
		else SendClientMessage(playerid, 0x999999FF, "* Необходим 5 уровень улучшений для дома");
	}
	else SendClientMessage(playerid, 0x999999FF, "* Функция доступна владельцам недвижимости");

	return 1;
}

cmd:use(playerid, params[])
{
	new house_id = GetPlayerInHouse(playerid);

	if(GetHouseData(house_id, H_IMPROVEMENTS) < 4) return SendClientMessage(playerid, 0xFF6600FF, "Необходим 4 уровень улучшений для дома");

	if(!IsPlayerInRangeOfPoint(playerid, 3.0, GetHouseData(house_id, H_STORE_X), GetHouseData(house_id, H_STORE_Y), GetHouseData(house_id, H_STORE_Z))) return SendClientMessage(playerid, 0xFF6600FF, "Вы должны находиться у своего шкафа");

	if(GetHouseData(house_id, H_OWNER_ID) != GetPlayerAccountID(playerid)) return SCM(playerid, COLOR_GREY, "Вы должны находится у шкафа в своем доме");

	if(status_authorization[playerid] != 1) return true;

	inventory_shelf_id[playerid] = house_id;

	UpdateWeapons(playerid), LoadInventory(playerid), StateCheck(playerid);

	if(inventory_bag_id[playerid] == 1) format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[0,[\"%s\",%d,%d,%d,%d,%d,%d.00,30.00,20],[[2,\"Рюкзак\",%d.00,50.00,24],[3,\"Шкаф\",0.10,50.00,24]],[%s]]", GetPlayerNameEx(playerid), playerid, GetPlayerMoney(playerid), GetPlayerSkin(playerid), GetIteam(playerid, 293), GetPlayerPremium(playerid), GetWorkLoadItems(playerid, 0), GetWorkLoadItems(playerid, 1), load_inventory[playerid]);
	else format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[0,[\"%s\",%d,%d,%d,%d,%d,%d.00,30.00,20],[[3,\"Шкаф\",0.10,50.00,24]],[%s]]", GetPlayerNameEx(playerid), playerid, GetPlayerMoney(playerid), GetPlayerSkin(playerid), GetIteam(playerid, 293), GetPlayerPremium(playerid), GetWorkLoadItems(playerid, 0), load_inventory[playerid]);

	MoralPacket_2(playerid, s_CefInterface, t_CefShow, "InventoryNew", STRING_GLOBAL);
	return 1;
}

cmd:homelock(playerid, params[])
{
	new hotel_id = GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL);
	new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);

	if(hotel_id != -1)
	{
		if(GetHotelData(hotel_id, room_id, H_STATUS))
		{
			SetHotelData(hotel_id, room_id, H_STATUS, false);

			GameText(playerid, "~g~~h~ОТКРЫТ", 2000, 3);
			SendClientMessage(playerid, 0x66CC00FF, "* Номер открыт");
		}
		else
		{
			SetHotelData(hotel_id, room_id, H_STATUS, true);

			GameText(playerid, "~r~~h~ЗАКРЫТ", 2000, 3);
			SendClientMessage(playerid, 0xFF6600FF, "* Номер закрыт");
		}

		static query[64];
		format(query, sizeof query, "UPDATE hotels SET status=%d WHERE id=%d LIMIT 1", GetHotelData(hotel_id, room_id, H_STATUS), GetHotelData(hotel_id, room_id, H_SQL_ID));
		mysql_query(mysql, query, false);
	}
	else SendClientMessage(playerid, 0x999999FF, "* Вы не снимаете номер в гостинице");

	return 1;
}
cmd:exit(playerid, params[])
{
	if(Iter_Contains(DmZonePlayers, playerid))
	{
		Iter_Remove(DmZonePlayers, playerid);
  		SetPlayerInterior(playerid, 1);
        SetPlayerArmedWeapon(playerid, 0);
		SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerPos(playerid, DMZONE_REGISTER_POSITION);

        g_player[playerid][P_DM_KILLS] = 0;
        g_player[playerid][P_DM_DEATH] = 0;
        SCM(playerid, 0xFFDE7AFF, "Вы покинули пейнтбол.");
	}
	if(GetPlayerInHouse(playerid) != -1)
	{
		ExitPlayerFromHouse(playerid, 3.0);
	}
	else if(GetPlayerData(playerid, P_IN_HOTEL_ROOM) != -1)
	{
		ExitPlayerFromHotelRoom(playerid);
	}
	else if(!GetPlayerInterior(playerid))
	{
		SendClientMessage(playerid, 0xCECECEFF, "* Вы не в помещении");
	}
	else if(GetPlayerInGarage(playerid) != -1)
	{
	    ExitPlayerFromGarage(playerid, 3.0);
	}

	return 1;
}


cmd:lock(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "* Используйте: /lock [тип] (1-Личный транспорт 2-Арендованная машина 3-Рабочий транспорт 4-Доверенный транспорт)");

	extract params -> new type;

	new Float: radius = 20.0;
	new vehicleid = INVALID_VEHICLE_ID;

	switch(type)
	{
		case 1:
		{
		    new Float:Distance_ = 5.0;

            for(new i = 0; i < MAX_VEHICLES; i++)
			{
			    if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
			    {
				    new iddx = GetVehicleData(i, V_ACTION_ID);
			        if(GetOwnableCarData(iddx,OC_OWNER_ID) == GetPlayerAccountID(playerid))
			        {
						new Float:Distance = D_PlayerVehicle(playerid, i);
				    	if(Distance < Distance_)
						{
							Distance_ = Distance;
							vehicleid = i;
			            }
			        }
		        }

			}

			if(Distance_ == 5.0) return SendClientMessage(playerid, 0x808080FF, "Вы далеко от своего транспорта");

		}
		case 2:
		{
			vehicleid = GetPlayerRentCar(playerid);

			if(vehicleid == INVALID_VEHICLE_ID)	return SendClientMessage(playerid, 0x999999FF, "* У Вас нет арендованной машины");
            new index = GetVehicleData(vehicleid, V_ACTION_ID);
			if(GetRentCarData(index, R_RENT_OWNER) == playerid) SetRentCarData(index, R_RENT_OWNER, -1);
		}
		case 3:
		{
			vehicleid = GetPlayerJobCar(playerid);

			if(vehicleid == INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0x999999FF, "* Вы не можете использовать эту функцию");
		}
		case 4:
		{
			new famid = GetPlayerData(playerid, P_FAMILY);
		    new Float:Distance_ = 5.0;

            for(new i = 0; i < MAX_VEHICLES; i++)
			{
			    if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_FAMILY_CAR)
			    {
				    new iddx = GetVehicleData(i, V_ACTION_ID);
			        if(GetOwnableCarData(iddx,OC_OWNER_ID) == famid)
			        {
						new Float:Distance = D_PlayerVehicle(playerid, i);
				    	if(Distance < Distance_)
						{
							Distance_ = Distance;
							vehicleid = i;
			            }
			        }
		        }
			}
			if(Distance_ == 5.0)
			{

				vehicleid = GetPlayerAllowedCar(playerid);

				if(vehicleid == INVALID_VEHICLE_ID)
					return SendClientMessage(playerid, 0x999999FF, "* У Вас нет доверенного транспорта");
			}
		}
		default:
			return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /lock [тип] (1-Личный транспорт 2-Арендованная машина 3-Рабочий транспорт 4-Доверенный транспорт)");
	}

	new Float: x, Float: y, Float: z;
	GetVehiclePos(vehicleid, x, y, z);
	if(IsPlayerInRangeOfPoint(playerid, radius, x, y, z))
	{
		new status = GetVehicleParam(vehicleid, V_LOCK);
		if(status)
		{
			if(type == 1) Action(playerid, "открыл личный транспорт", _, true);

			if(type == 2) Action(playerid, "открыл арендованый транспорт", _, true);

			if(type == 5) Action(playerid, "открыл семейный транспорт", _, true);
			GameText(playerid, "~w~Транспорт ~g~открыт", 4000, 1);
			SetVehicleParam(vehicleid, V_LOCK, status ^ VEHICLE_PARAM_OFF);
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "playSound('sounds/car/start_engine_car.wav', 0, 1)");
		}
		else
		{
			if(type == 1) Action(playerid, "закрыл личный транспорт", _, true);
			
			if(type == 2) Action(playerid, "закрыл арендованый транспорт", _, true);

			if(type == 5) Action(playerid, "закрыл семейный транспорт", _, true);
			
			GameText(playerid, "~w~Транспорт ~r~закрыт", 4000, 1);
		}
		SetVehicleParam(vehicleid, V_LOCK, status ^ VEHICLE_PARAM_ON);
	}
	else SendClientMessage(playerid, 0x999999FF, "* Вы должны стоять рядом с транспортом");

	return 1;
}

cmd:getmycar(playerid, params[])
{
	new vehicleid = GetPlayerOwnableCarLast(playerid);
	if(GetPVarInt(playerid, "go_list") == 1)
	{
	    SetPVarInt(playerid, "go_list", 0);

		new idx = GetPVarInt(playerid, "ownablecar_id");
		
		for(new i = 0; i < MAX_VEHICLES; i++)
		{
			if(GetVehicleData(i, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
			{
				new iddx = GetVehicleData(i, V_ACTION_ID);
				if(GetOwnableCarData(iddx,OC_SQL_ID) == idx)
				{
					vehicleid = i;
				}
			}

		}
	}

	if(vehicleid != INVALID_VEHICLE_ID)
	{
		new price = 5000;
		new i_have_home = (GetPlayerHouse(playerid, HOUSE_TYPE_HOME) != -1 || GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) != -1);

		if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_OFF)
		{
			if(GetILPlayerInt(GetPlayerMoneyEx(playerid), price) || GetILPlayerInt(GetPlayerMoneyEx(playerid), i_have_home))
			{
				if(!i_have_home)
					GivePlayerMoneyEx(playerid, -price, "Метка ТС на GPS", true, true);

				new Float: x, Float: y, Float: z;
				GetVehiclePos(vehicleid, x, y, z);

				EnablePlayerGPS(playerid, 55, x, y, z, "Местоположение Вашего транспорта отмечено на GPS");
				return 1;
			}
			else SendClientMessage(playerid, 0x999999FF, "* Недостаточно денег");
		}
		else SendClientMessage(playerid, 0xCECECEFF, "* На Вашем GPS уже отмечено место");
	}
	else
	{
		if(GetPlayerOwnableCars(playerid) == 0)
			SendClientMessage(playerid, 0x999999FF, "* У Вас нет личного транспорта");
		else
			SendClientMessage(playerid, 0x999999FF, "* Ваш личный транспорт не загружен на сервер");
	}

	return 0;
}

cmd:sellmycar(playerid, params[])
{
	if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, 0xCECECEFF, "* Продавать транспорт можно только с {99ff00}2{CECECE} уровня");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /sellmycar [id игрока] [стоимость]");
	if(!IsPlayerInRangeOfPoint(playerid,250,-1633.8027,1025.8977,997.7969) && !IsPlayerInRangeOfPoint(playerid,250,2304.5803,1757.3826,1001.0000) && !IsPlayerInRangeOfPoint(playerid,250,1575.7394,1772.4160,996.5703)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться на Б/У рынке");
	extract params -> new to_player, string:price[23];

	if(!IsPlayerConnected(to_player) || to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if((GetPlayerOwnableCars(to_player) + 1) > GetPlayerCarSlots(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока нет свободных слотов для транспорта");

	if(!IsILNumeric(price)) return SCM(playerid, 0xCECECEFF, "* Некорректная стоимость");

	if(!GetILPlayerStr(GetPlayerMoneyEx(to_player), price)) return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока нет такой суммы");

	SetPVarString(playerid, "SellCarPrice", price);
	SetPVarInt(playerid, "SellCarTo_player", to_player);

	page_cars[playerid] = 1;
	type_page_cars[playerid] = 5;
	ShowOwnableCars(playerid, DIALOG_SELL_OWNABLE_CAR, page_cars[playerid]);

	return 1;
}

cmd:allow(playerid, params[])
{
	new vehicleid = GetPlayerOwnableCarLast(playerid);
	if(vehicleid == INVALID_VEHICLE_ID)
	{
		if(GetPlayerOwnableCars(playerid) == 0)
			return SendClientMessage(playerid, 0x999999FF, "* У Вас нет личного транспорта");
		else
			return SendClientMessage(playerid, 0x999999FF, "* Ваш личный транспорт не загружен на сервер");
	}

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /allow [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	static fmt_text[71];

	if(GetPlayerAllowedCar(to_player) == vehicleid)
	{
		format(fmt_text, sizeof fmt_text, "Вы забрали у %s ключи от Вашего личного транспорта", GetPlayerNameEx(to_player));
		SendClientMessage(playerid, 0x3399FFFF, fmt_text);

		format(fmt_text, sizeof fmt_text, "%s забрал у Вас ключи от своего личного транспорта", GetPlayerNameEx(playerid));
		SendClientMessage(to_player, 0xFF5533FF, fmt_text);

		SetPlayerData(to_player, P_ALLOWED_CAR, INVALID_VEHICLE_ID);
	}
	else
	{
		if(!IsPlayerInRangeOfPlayer(playerid, to_player, 10.0)) return SendClientMessage(playerid, 0xCECECEFF, "* Игрок находится слишком далеко");

		SendPlayerOffer(playerid, to_player, OFFER_TYPE_GIVE_CAR_KEY);
	}

	return 1;
}

cmd:park(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в транспорте");
	
	new veh_id = GetPlayerVehicleID(playerid);
	if(IsAOwnableCar(veh_id))
	{
		new vehicleid = GetPlayerOwnableCarLast(playerid);
		if(vehicleid == INVALID_VEHICLE_ID)
		{
			if(GetPlayerOwnableCars(playerid) == 0)
				return SendClientMessage(playerid, 0x999999FF, "* У Вас нет личного транспорта");
			else
				return SendClientMessage(playerid, 0x999999FF, "* Ваш личный транспорт не загружен на сервер");
		}
		if(GetPVarInt(playerid, "in_by") == 1)
		{
			return 1;
		}
		if(vehicleid != GetPlayerVehicleID(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в личном транспорте");

		new index = GetVehicleData(vehicleid, V_ACTION_ID);
		static query[912];

		GetVehiclePos(vehicleid, GetOwnableCarData(index, OC_POS_X), GetOwnableCarData(index, OC_POS_Y), GetOwnableCarData(index, OC_POS_Z));
		GetVehicleZAngle(vehicleid, GetOwnableCarData(index, OC_ANGLE));
		new Float: x, Float: y, Float: z, Float: angle;
		GetVehiclePos(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, angle);
		format(query, sizeof query, "UPDATE ownable_cars SET pos_x=%f,pos_y=%f,pos_z=%f,angle=%f,inter=%d,world=%d WHERE id=%d LIMIT 1", x, y, z, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), GetOwnableCarData(index, OC_SQL_ID));
		mysql_tquery(mysql, query, "", "");

		SaveOwnableCar(vehicleid);
	}
	if(IsAFamilyCar(veh_id))
	{
		if(GetPlayerData(playerid, P_FAMILY_RANK) != 10) return SendClientMessage(playerid, 0xCECECEFF, "* Вам недоступна данная команда!");
	    new vehicleid = GetPlayerVehicleID(playerid);
	    new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

	    if(g_ownable_car[action_id][OC_OWNER_ID] == GetPlayerData(playerid, P_FAMILY)+1)
	        return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в транспорте семьи");

		new index = GetVehicleData(vehicleid, V_ACTION_ID);
		GetVehiclePos(vehicleid, GetOwnableCarData(index, OC_POS_X), GetOwnableCarData(index, OC_POS_Y), GetOwnableCarData(index, OC_POS_Z));
		GetVehicleZAngle(vehicleid, GetOwnableCarData(index, OC_ANGLE));
		SaveFamilyCar(vehicleid);
	}
	return SendClientMessage(playerid, 0x66CC00FF, "* Транспорт припаркован");
}
cmd:car(playerid, params[])
{
	page_cars[playerid] = 1;
	type_page_cars[playerid] = 6;
	ShowOwnableCars(playerid, DIALOG_OWNABLE_CAR_LIST, page_cars[playerid]);
	return 1;
}
cmd:pos(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) == 0) return 1;

	new Float: x, Float: y, Float: z, interior, virtual_world;

	if(sscanf(params, "P<,>fff", x, y, z))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /pos [x y z]");

	sscanf(params, "P<,>{fff}dd", interior, virtual_world);

	return SetPlayerPosEx(playerid, x, y, z, interior, virtual_world);
}

cmd:d(playerid, params[])
{
	if(!GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не состоите в организациях");
	else if(TEAM_MAFIA_RUSSIAN <= GetPlayerTeamEx(playerid) <= TEAM_MAFIA_ITALIAN) return SendClientMessage(playerid, 0xCECECEFF, "* Функция доступна для сотрудников гос. организаций");
	else if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "* Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	else if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /d [текст]");

	static fmt_msg[144];
	format(fmt_msg, sizeof fmt_msg, "[D] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(!GetPlayerTeamEx(i)) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		SendClientMessage(i, 0xFF9999FF, fmt_msg);
	}

	SetPlayerChatBubble(playerid, "сказал(а) что-то в рацию организаций", 0xDD99FFAA, 10.0, 4000);

	return 1;
}

cmd:dd(playerid, params[])
{
	if(!GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не состоите в организациях");
	else if(TEAM_MAFIA_RUSSIAN <= GetPlayerTeamEx(playerid) <= TEAM_MAFIA_ITALIAN) return SendClientMessage(playerid, 0xCECECEFF, "* Функция доступна для сотрудников гос. организаций");
	else if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "* Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	else if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /dd [текст]");

	static fmt_msg[144];
	format(fmt_msg, sizeof fmt_msg, "(( [D] %s %s[%d]: %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(!GetPlayerTeamEx(i)) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		SendClientMessage(i, 0xFF9999FF, fmt_msg);
	}

	SetPlayerChatBubble(playerid, "сказал(а) что-то в рацию организаций", 0xDD99FFAA, 10.0, 4000);

	return 1;
}

cmd:ff(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) <= 10)) return SendClientMessage(playerid, 0x999999FF, "* Вы не состоите в организациях");
	if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "* Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /ff [текст]");

	static fmt_msg[144];
	format(fmt_msg, sizeof fmt_msg, "(( [F] %s %s[%d]: %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(!GetPlayerTeamEx(i)) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetFamilyChatID(GetPlayerTeamEx(i)) != GetFamilyChatID(GetPlayerTeamEx(playerid))) continue;

		SendClientMessage(i, 0x6699CCFF, fmt_msg);
	}
	return 1;
}
cmd:f(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) <= 10)) return SendClientMessage(playerid, 0x999999FF, "* Вы не состоите в организациях");
	if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "* Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /f [текст]");


	static fmt_msg[144];
	format(fmt_msg, sizeof fmt_msg, "[F] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(!GetPlayerTeamEx(i)) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetFamilyChatID(GetPlayerTeamEx(i)) != GetFamilyChatID(GetPlayerTeamEx(playerid))) continue;

		SendClientMessage(i, 0x6699CCFF, fmt_msg);
	}
	return 1;
}

cmd:gov(playerid, params[]) return callcmd::gnews(playerid, params);
cmd:gnews(playerid, params[])
{
	if(!(TEAM_GOVERNMENT <= GetPlayerTeamEx(playerid) <= TEAM_FSIN)) return SendClientMessage(playerid, 0x999999FF, "* Вам недоступна данная функция");
	if(!(9 <= GetPlayerJobName(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "* Функция доступна лидерам организации и их заместителям");
	if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "* Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /gnews [текст]");


	static fmt_msg[170 + 1];
	format(fmt_msg, sizeof fmt_msg, "Гос.новости: %s[%d]: %s", GetPlayerNameEx(playerid), playerid, params);
	SendClientMessageToAll(0x4466CCFF,  fmt_msg);

	return 1;
}
cmd:invite(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) <= 10))
		return SendClientMessage(playerid, 0x999999FF, "* Вам недоступна данная функция");

	if(!(9 <= GetPlayerJobName(playerid) <= 10))
		return SendClientMessage(playerid, 0xCECECEFF, "* Функция доступна лидерам организации и их заместителям");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /invite [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(GetPlayerData(to_player, P_WARN))
		return SendClientMessage(playerid, 0xCECECEFF, "* У игрока есть предупреждения");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 10.0))
		return SendClientMessage(playerid, 0xCECECEFF, "* Игрок находится слишком далеко");

	new from_team = GetPlayerTeamEx(playerid);
	new to_team = GetPlayerTeamEx(to_player);
	new to_rank = GetPlayerJobName(to_player);

	if(from_team == TEAM_FSB)
	{
		if(!((to_team == TEAM_FSIN || to_team == TEAM_MVD) && (to_rank >= 3 && to_rank <= 8) ||
			(to_team == TEAM_ARMY && (to_rank >= 5 && to_rank <= 8))))
		{
			return SendClientMessage(playerid, 0xCECECEFF, "* В ФСБ можно перевестись только из ФСИН/МВД(от 3 ранга) или Армии(от 5  ранга)!");
		}

		SetPlayerData(to_player, P_RANG, 1);
	}
	else
	{
		if(to_team != TEAM_NONE)
			return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок уже состоит в другой организации");

		SetPlayerData(to_player, P_RANG, 1);
	}

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_INVITE);
	return 1;
}

cmd:uninvite(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) <= 10)) return SendClientMessage(playerid, 0x999999FF, "* Вам недоступна данная функция");
	if(!(9 <= GetPlayerJobName(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "* Функция доступна лидерам организации и их заместителям");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /uninvite [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");


	if(GetPlayerTeamEx(to_player) != GetPlayerTeamEx(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок не состоит в Вашей организации");

	if(GetPlayerJobName(to_player) >= GetPlayerJobName(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя уволить уволить заместителя/лидера организации");
	UnInvite(playerid, to_player);

	return 1;
}
cmd:givedonate(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new to_player, donate; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givedonate [id игрока] [cумма]");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(!(-100000000 <= donate <= 100_000_000)) return SendClientMessage(playerid, 0xCECECEFF, "* Можно выдавать от 1 до 100.000.000 рублей за один раз");

	if(GetPlayerData(playerid, P_LIMIT_DONATE_TIME) != 0)
	{
		if(GetPlayerData(playerid, P_LIMIT_DONATE_TIME) > gettime())
		{
			return SendClientMessage(playerid, 0xCECECEFF, "* Доступно для выдачи 0 доната. Ожидайте сброса лимита");
		}
	 	else
		{
			SetPlayerData(playerid, P_LIMIT_DONATE, 0);
			UpdatePlayerDatabaseInt(playerid, "limit_donate", GetPlayerData(playerid, P_LIMIT_DONATE));

			SetPlayerData(playerid, P_LIMIT_DONATE_TIME, 0);
			UpdatePlayerDatabaseInt(playerid, "limit_donate_time", GetPlayerData(playerid, P_LIMIT_DONATE_TIME));
		}
	}



	new limit;

	if(GetPlayerBuyAdminEx(playerid) == 8) limit = 2;
	else if(GetPlayerBuyAdminEx(playerid) == 9) limit = 4;
	else if(GetPlayerBuyAdminEx(playerid) == 10) limit = 6;
	else if(GetPlayerBuyAdminEx(playerid) == 11) limit = 20;

	if(g_player[playerid][P_SPONSOR]) limit = 500;

	if(GetPlayerBuyAdminEx(playerid) || g_player[playerid][P_SPONSOR])
	{
	    if(GetPlayerData(playerid, P_AWARN) >= 1) return SCMF(playerid, 0xCECECECE, "Данная команда заблокирована. Поскольку у вас имеется %d предупреждений. Для снятия используйте: {99ff00} /adonate", GetPlayerData(playerid, P_AWARN));
		if(!g_player[playerid][P_SPONSOR])
		{
			if(to_player != playerid) return SCM(playerid, 0xCECECEFF, "* Только себе");
		}
		if(!(1 <= donate + GetPlayerData(playerid, P_LIMIT_DONATE) <= limit)) return SCMF(playerid, 0xCECECEFF, "* Вы можете выдавать только %s доната в час. Доступно для выдачи %s доната", formatInt(limit), formatInt(limit - GetPlayerData(playerid, P_LIMIT_DONATE)));

		AddPlayerData(playerid, P_LIMIT_DONATE, +, donate);
		UpdatePlayerDatabaseInt(playerid, "limit_donate", GetPlayerData(playerid, P_LIMIT_DONATE));

		if(GetPlayerData(playerid, P_LIMIT_DONATE) >= limit)
		{
			SetPlayerData(playerid, P_LIMIT_DONATE_TIME, gettime() + 3600);
			UpdatePlayerDatabaseInt(playerid, "limit_donate_time", GetPlayerData(playerid, P_LIMIT_DONATE_TIME));
		}
	}

	static reason[144];
	format(reason, sizeof reason, "Выдача Доната от админа %s", GetPlayerNameEx(playerid));
	GivePlayerDonate(to_player, donate, reason, true, true);
 	if(donate > 0)	DLGF(to_player, -1, DIALOG_STYLE_MSGBOX, "Пополнение баланса", "{FFFF00}Ваш баланс успешно пополнен на %d "SERVER_COINS_NAME".", "Закрыть", "", donate, reason);
	SendClientMessage(to_player, 0xFFFFFFFF, reason);

	SCM(playerid, -1, "* {ff8c00}Вы успешно выдали донат");
	format(reason, sizeof reason, "{FFFFFF}["SERVER_NAME_RP"]%s[%d] выдал донат %s[%d] кол-во %d доната, в итоге у игрока: %d доната", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, donate, GetPlayerCurrentDonate(to_player));
	SendMessageToAdmins(reason, -1);
	format(reason, sizeof reason, "Выдал %s[%d] %d Донат", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), donate);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, reason);
	return 1;
}
cmd:giveacs(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new to_player, aksid, type; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /giveacs [id игрока] [id аксессуара] [тип аксессуара]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	GiveAcs(to_player, aksid, type);
	static reason[144];
	format(reason, sizeof reason, "Администратор %s выдал Вам аксессуар", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, 0xFFFFFFFF, reason);

	format(reason, sizeof reason, "A: %s[%d] выдал аксессуар %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
	SendMessageToAdmins(reason, 0xFFFF00FF);

	format(reason, sizeof reason, "Выдал %s[acc:%d] аксессуар", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, reason);

	return 1;
}


cmd:create_x2(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	Dialog
	(
		playerid, DIALOG_SET_DOUBLING, DIALOG_STYLE_LIST,
		"{FFD83D}Удвоение",
		"\
		1. Удвоение доната\n\
		2. Удвоение очков опыта\n\
		3. Удвоение зарплаты на подработках\n\
		4. Включить логотип на сервере при X2\
		",
		"Выбор", "Отмена"
	);
	return 1;
}

cmd:setstats(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new to_player, set_code, set_value; else 
	{
		SendClientMessage(playerid, 0xCECECEFF, "* Использование: /setstats [id игрока] [код] [значение]");
		SendClientMessage(playerid, 0xCECECEFF, "* Код: 1 - Уровень | 2 - Работа");
		return 1;
	}

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	static fmt_msg[128];

	switch(set_code)
	{
		case 1:
		{
			if(set_value > 999) return 1;

			SetPlayerData(to_player, P_LEVEL, set_value);

			SetPlayerScore(to_player, set_value);

			format(fmt_msg, sizeof fmt_msg, "Администратор %s изменил Вам уровень на %d", GetPlayerNameEx(playerid), set_value);
			SendClientMessage(to_player, 0x3399FFFF, fmt_msg);

			format(fmt_msg, sizeof fmt_msg, "Вы изменили игроку %s уровень на %d", GetPlayerNameEx(to_player), set_value);
			SendClientMessage(playerid, 0x66CC00FF, fmt_msg);
		}
		case 2:
		{
			if(!(0 <= set_value <= 9)) return SendClientMessage(playerid, 0xFF6600FF, "* Ид работы от 0 до 9");
			SetPlayerData(to_player, P_JOB, set_value);

			format(fmt_msg, sizeof fmt_msg, "Администратор %s установил Вам работу %s", GetPlayerNameEx(playerid), GetPlayerJobAndRankName(to_player));
			SendClientMessage(to_player, 0x3399FFFF, fmt_msg);

			format(fmt_msg, sizeof fmt_msg, "Вы установили игроку %s работу %s", GetPlayerNameEx(to_player), GetPlayerJobAndRankName(to_player));
			SendClientMessage(playerid, 0x66CC00FF, fmt_msg);
		}
		default: return SendClientMessage(playerid, 0xFF6600FF, "* Ошибка: Неверно введен код");
	}

	mysql_format(mysql, fmt_msg, sizeof fmt_msg, "UPDATE PlayersMorallwens SET level=%d,job=%d WHERE id=%d", GetPlayerLevel(to_player), GetPlayerJob(to_player), GetPlayerAccountID(to_player));
	mysql_query(mysql, fmt_msg, false);

	return 1;
}

cmd:pay(playerid, params[])
{
    if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, 0xCECECEFF, "* Передавать деньги можно только с {99ff00}2{CECECE} уровня");
	
	extract params -> new to_player, cash; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /pay [id игрока] [сумма]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "* Игрок находится далеко от Вас");

	if(playerid == to_player) return SendClientMessage(playerid, 0x999999FF, "* вы не можете передать себе деньги");

	if(!(1 <= cash <= 4000000)) return SCM(playerid, 0xCECECEFF, "* Сумма должна быть от 1 до 4.000.000 рублей");

	if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), cash)) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет столько денег");

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Передача денег игроку %s[%d]", GetPlayerNameEx(to_player), to_player);
	GivePlayerMoneyEx(playerid, -cash, STRING_GLOBAL, true, true);

	static query[144];
	format(query, sizeof(query), "%s передал %d$ игроку %s", GetPlayerNameEx(to_player), cash, playerid);
	SendLog(playerid, LOG_TYPE_ALL, query);

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "+%d", cash);
	SetPlayerChatBubble(to_player, STRING_GLOBAL, 0x00CC00FF, 10.0, 5000);

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "-%d", cash);
	SetPlayerChatBubble(playerid, STRING_GLOBAL, 0xFF6600FF, 10.0, 5000);

	SCMF(to_player, 0x3399FFFF, "* %s передал Вам деньги %d руб", GetPlayerNameEx(playerid), cash);
	SCMF(playerid, 0x3399FFFF, "* Вы передали игроку %s деньги %d руб", GetPlayerNameEx(to_player), cash);

	Action(playerid, "достал кошелёк и передал деньги", _, false);

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Передача денег от игрока %s[%d]", GetPlayerNameEx(playerid), playerid);
	GivePlayerMoneyEx(to_player, cash, STRING_GLOBAL, true, true);

	OnBattlePass_Perfomance(playerid, 10, 1);
	return true;
}

cmd:history(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /history [имя игрока]");

	if(!(3 <= strlen(params) <= 20))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	extract params -> new string: name[21];

	static query[128];
	new Cache: result, user_id;

	mysql_format(mysql, query, sizeof query, "SELECT id FROM PlayersMorallwens WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows())
		user_id = cache_get_row_int(0, 0);

	cache_delete(result);

	if(!user_id)
		return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	format(query, sizeof query, "SELECT name FROM change_names WHERE owner_id=%d ORDER BY id DESC LIMIT 45", user_id);
	mysql_tquery(mysql, query, "ShowChangeNameHistory", "is", playerid, name);

	return 1;
}
cmd:setrates(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new type, count; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setrates [тип (донат, exp, зарплаты)] [множитель]");

	if(!(1 <= count <= 3)) return SCM(playerid, 0xCECECEFF, "* Умножить можно только от 1 до 3");
	if(!(1 <= type <= 3)) return SCM(playerid, 0xCECECEFF, "* Данного типа не существует");

	g_doubling[type - 1] = count;

	SCM(playerid, -1, "* Вы успешно применили изменения");

	SaveServerConfig();
	return true;
}
cmd:serverconfig(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	static string[344];
	format(string, sizeof string,
	"Функция\tСтатус\n"\
	"Умножение доната\tx%d\n"\
	"Умножение EXP\tx%d\n"\
	"Умножение зарплаты\tx%d\n"\
	"Тест/Тех.Работы\t%s\n"\
	"Допущеные до теста\tсписок\n"\
	"Допуск человеку\tдать\n"\
	"Допуск человеку\tзабрать\n"\
	"Загрузка обновления\t%s",
	g_doubling[0], g_doubling[1], g_doubling[2], Test_server ? ("{66CC33}включено") : ("{CC3333}выключено"), Update_server ? ("{66CC33}включено") : ("{CC3333}выключено"));
	Dialog(playerid, DIALOG_CONFIG, DIALOG_STYLE_TABLIST_HEADERS, "Настройки сервера", string, "Далее", "Отмена");
	return 1;
}
cmd:zbtplayer(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	static query[128];

	format(query, sizeof query, "SELECT name FROM test_user");
	mysql_tquery(mysql, query, "ShowTestPlayer", "i", playerid);

	return 1;
}
cmd:addzbtplayer(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /addzbtplayer [ник]");

	if(!(3 <= strlen(params) <= 21))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	extract params -> new string: name[21];
	static query[128];
	new Cache: result;

	mysql_format(mysql, query, sizeof query, "SELECT id FROM test_user WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows())
		return SendClientMessage(playerid, -1, "* У него уже есть доступ!");

	cache_delete(result);

	static str[144];
	format(str, sizeof str, "INSERT INTO `test_user` (`name`) VALUES ('%s')", name);
	mysql_query(mysql, str, false);
	SendClientMessage(playerid, -1, "* Добавлено успешно");
	format(query, sizeof query, "A: %s[%d] дал для %s доступ к тесту", GetPlayerNameEx(playerid), playerid, name);
	SendMessageToAdmins(query, 0x999999FF);
	return 1;
}
cmd:delzbtplayer(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /delzbtplayer [ник]");

	if(!(3 <= strlen(params) <= 25))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	extract params -> new string: name[25];
	static query[128];
	new Cache: result;

	mysql_format(mysql, query, sizeof query, "SELECT id FROM test_user WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows())
	{
		mysql_format(mysql, query, sizeof query, "DELETE FROM test_user WHERE name='%s'", name);
		mysql_query(mysql, query, false);
		SendClientMessage(playerid, -1, "* Удалено");
	}
	else return SendClientMessage(playerid, -1, "* У пользователя нет доступа");
	cache_delete(result);
	if(IsPlayerConnected(GetPlayerID(name)))
	{
		SendClientMessage(GetPlayerID(name), -1, "У вас забрали доступ к тестовому серверу!");
		Kick(GetPlayerID(name));
	}
	format(query, sizeof query, "A: %s[%d] удалил для %s доступ к тесту", GetPlayerNameEx(playerid), playerid, name);
	SendMessageToAdmins(query, 0x999999FF);
	return 1;
}
cmd:c(playerid, params[]) return callcmd::call(playerid, params);
cmd:call(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0x999999FF, "* У Вас нет телефона. Его можно купить в сотовом салоне");

	if(GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER) != INVALID_PLAYER_ID || GetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER) != INVALID_PLAYER_ID)
		return SendClientMessage(playerid, 0x999999FF, "* Закончите текущий разговор");

	if(!GetPlayerPhoneCall(playerid, PC_ENABLED))
		return SendClientMessage(playerid, 0x999999FF, "* Ваш телефон отключен");

	if(GetPlayerData(playerid, P_PHONE_BALANCE) >= 5)
	{
		new number;
		if(sscanf(params, "d", number))
		{
			Dialog
			(
				playerid, DIALOG_PHONE_CALL, DIALOG_STYLE_INPUT,
				"{FFD83D}Наберите номер",
				"{6699CC}Номера государственных служб:\n\n\
				{FFFFFF}Полиция\t\t\t{66CC00}02\n\
				{FFFFFF}Скорая помощь\t\t{66CC00}03\n\
				{FFFFFF}Такси\t\t\t\t{66CC00}555\n\
				{FFFFFF}Механик\t\t\t{66CC00}090\n\
				{FFFFFF}Мэрия\t\t\t\t{66CC00}022\n\
				{FFFFFF}Служба точного времени\t{66CC00}060\n\
				{FFFFFF}Оператор связи\t\t{66CC00}111",
				"Позвонить", "Отмена"
			);
			return 1; // (TODO)
		}

		switch(number)
		{
			case 02: return 1;
			case 03: return 1;
			case 555: return 1;
			case 090: return 1;
			case 022: return 1;

			case 060:
			{
				ShowCurrentTime(playerid);
			}
			case 111:
			{
				static fmt_str[175];
				SetPlayerPhoneUseState(playerid, true);

				format
				(
					fmt_str, sizeof fmt_str,
					"{FFFFFF}Здравствуйте! Вы позвонили оператору.\n"\
					"На счету Вашего мобильного телефона {00FF00}%d руб\n\n"\
					"{FFFFFF}Пополнить его можно в любом банкомате.\n"\
					"Всего доброго!",
					GetPlayerData(playerid, P_PHONE_BALANCE)
				);
				Dialog(playerid, DIALOG_PHONE_CALL_BALANCE, DIALOG_STYLE_MSGBOX, "{FFD83D}Оператор сотовой связи", fmt_str, "Ок", "Отмена");
			}

			default:
			{
				new subscriber = GetPlayerIDByPhone(number);

				if(number < 1)
					return SendClientMessage(playerid, 0x999999FF, "* Данный номер не обслуживается");

				if(subscriber == INVALID_PLAYER_ID)
					return SendClientMessage(playerid, 0xCECECEFF, "* Набранный Вами номер не обслуживается");

				if(subscriber == playerid || GetPlayerPhoneCall(subscriber, PC_INCOMING_PLAYER) != INVALID_PLAYER_ID || GetPlayerPhoneCall(subscriber, PC_OUTCOMING_PLAYER) != INVALID_PLAYER_ID)
					return SendClientMessage(playerid, 0x999999FF, "* Абонент занят");

				if(!GetPlayerPhoneCall(subscriber, PC_ENABLED))
					return SendClientMessage(playerid, 0x999999FF, "* Телефон абонента вне зоны доступа");

				SetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER, subscriber);
				SetPlayerPhoneCall(subscriber, PC_INCOMING_PLAYER, playerid);

				static fmt_str[90];

				format(fmt_str, sizeof fmt_str, "Исходящий звонок | Номер: %d {FFCD00}| Ожидание ответа от %s...", number, GetPlayerNameEx(subscriber));
				SendClientMessage(playerid, 0x66CC00FF, fmt_str);

				format(fmt_str, sizeof fmt_str, "Входящий звонок | Номер: %d {FFCD00}| Вызывает %s", GetPlayerPhone(playerid), GetPlayerNameEx(playerid));
				SendClientMessage(subscriber, 0x3399FFFF, fmt_str);

				SendClientMessage(subscriber, 0xFFFFFFFF, "Используйте {00CC00}/p {FFFFFF}чтобы ответить или {FF6600}/h {FFFFFF}чтобы отклонить вызов");
				SetPlayerPhoneUseState(playerid, true);
			}
		}
	}
	else
	{
		SendClientMessage(playerid, 0xCECECEFF, "* На счету недостаточно средств");
		SendClientMessage(playerid, 0xCECECEFF, "* Пополнить мобильный телефон можно в любом банкомате");
	}

	return 1;
}

cmd:p(playerid, params[])
{
	if(GetPlayerPhoneCall(playerid, PC_TIME) != -1) return 1;

	new caller = GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER);
	//
	if(caller != INVALID_PLAYER_ID)
	{
		SetPlayerPhoneCall(caller, PC_TIME, 0);
		SetPlayerPhoneCall(playerid, PC_TIME, 0);

		static fmt_str[64];
		format(fmt_str, sizeof fmt_str, "Вы ответили на звонок %s", GetPlayerNameEx(caller));
		SendClientMessage(playerid, 0xDD90FFFF, fmt_str);
        //if (caller == GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER) && lstream[caller]) SvDetachSpeakerFromStream(lstream[caller], caller);
		format(fmt_str, sizeof fmt_str, "%s ответил на Ваш звонок", GetPlayerNameEx(playerid));
		SendClientMessage(caller, 0xDD90FFFF, fmt_str);

		SetPlayerPhoneUseState(playerid, true, false);
	}
	else SendClientMessage(playerid, 0xCECECEFF, "* Нет входящих вызовов");

	return 1;
}

cmd:h(playerid, params[])
{
	new caller = GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER);
	new call_to = GetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER);

	if(call_to != INVALID_PLAYER_ID)
	{
		if(GetPlayerPhoneCall(call_to, PC_INCOMING_PLAYER) == playerid)
		{
			ClearPlayerPhoneCall(call_to);
			SendClientMessage(call_to, 0xFF9944FF, "Звонок окончен");

			SetPlayerPhoneUseState(call_to, false);
		}
		SendClientMessage(playerid, 0xFF9944FF, "Звонок окончен");
	}
	else if(caller != INVALID_PLAYER_ID)
	{
		if(GetPlayerPhoneCall(caller, PC_OUTCOMING_PLAYER) == playerid)
		{
			ClearPlayerPhoneCall(caller);
			SendClientMessage(caller, 0xFF9944FF, "Звонок окончен");

			SetPlayerPhoneUseState(caller, false);
		}
		if(GetPlayerPhoneCall(playerid, PC_TIME) != -1)
		{
			SendClientMessage(playerid, 0xFF9944FF, "Звонок окончен");
		}
		else SendClientMessage(playerid, 0xFF9944FF, "Вы отклонили входящий вызов");
	}
	else return 1;

	ClearPlayerPhoneCall(playerid);
	SetPlayerPhoneUseState(playerid, false);

	return 1;
}

cmd:sms(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0x999999FF, "* У Вас нет телефона. Его можно купить в сотовом салоне");

	if(!GetPlayerPhoneCall(playerid, PC_ENABLED))
		return SendClientMessage(playerid, 0x999999FF, "* Ваш телефон отключен");

	if(GetPlayerData(playerid, P_MUTE)) return SendClientMessage(playerid, 0x999999FF, "* Вы не можете использовать данную функцию пока не пройдёт блокировка чата");

	if(GetPlayerData(playerid, P_PHONE_BALANCE) >= 5)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /sms [номер телефона] [сообщение]");

		extract params -> new number, string:message[66];

		if(number < 550)
			return SendClientMessage(playerid, 0x999999FF, "* Данный номер не обслуживается");

		new subscriber = GetPlayerIDByPhone(number);

		if(subscriber != INVALID_PLAYER_ID)
		{
			if(!GetPlayerPhoneCall(subscriber, PC_ENABLED))
				return SendClientMessage(playerid, 0x999999FF, "* Не удается отправить сообщение. Телефон абонента недоступен");

			if(!strlen(message))
				return SendClientMessage(playerid, 0xCECECEFF, "* Введите сообщение для отправки");

			if(strlen(message) > 64)
				return SendClientMessage(playerid, 0xCECECEFF, "* Слишком длинное сообщение");

			AddPlayerData(playerid, P_PHONE_BALANCE, -, 5);
			GameText(playerid, "SMS ~n~~y~-5 рублей", 4000, 2);

			static fmt_str[128];
			new senderPhone = GetPlayerPhone(playerid);
        	new recipientPhone = GetPlayerPhone(subscriber);

            MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "playSound('media/message.603ff8b2.wav', 0, 1)");
			format(fmt_str, sizeof fmt_str, "SMS: %s | Отправитель: %s [т.%d]", message, GetPlayerNameEx(playerid), GetPlayerPhone(playerid));
			SendClientMessage(subscriber, 0xFFFF00FF, fmt_str);
			SetPlayerChatBubble(subscriber, "SMS <<", 0xFFFF00FF, 5.0, 1500);

			format(fmt_str, sizeof fmt_str, "SMS: %s | Получатель: %s [т.%d]", message, GetPlayerNameEx(subscriber), GetPlayerPhone(subscriber));
			SendClientMessage(playerid, 0xFFFF00FF, fmt_str);
			SetPlayerChatBubble(playerid, "SMS >>", 0xFFFF00FF, 5.0, 1500);

			// Прослушка ФСБ
        	new recipientName[24];
        	format(recipientName, sizeof(recipientName), GetPlayerNameEx(subscriber));

        	for(new i = 0; i < MAX_PLAYERS; i++)
        	{
        	    if(!IsPlayerConnected(i)) continue;
        	    if(GetPlayerTeam(i) != TEAM_FSB) continue;
        	    if(listen_number[i] <= 0) continue;

        	    if(listen_number[i] == senderPhone || listen_number[i] == recipientPhone)
        	    {
        	        new spymsg[160];
        	        format(spymsg, sizeof(spymsg),
        	            "ПРОСЛУШКА | SMS: %s | от %s[%d][т.%d] к %s[%d][т.%d]",
        	            message,
        	            GetPlayerNameEx(playerid), playerid, senderPhone,
        	            recipientName, subscriber, recipientPhone);
        	        SendClientMessage(i, 0xFFFF00FF, spymsg);
        	    }
        	}

			format(fmt_str, sizeof fmt_str, "UPDATE PlayersMorallwens SET phone_balance=%d WHERE id=%d LIMIT 1", GetPlayerData(playerid, P_PHONE_BALANCE), GetPlayerAccountID(playerid));
			mysql_tquery(mysql, fmt_str, "", "");

			if(g_admin_ears)
			{
				format(fmt_str, sizeof fmt_str, "A: SMS: %s | от %s[%d] к %s[%d]", message, GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(subscriber), subscriber);
				SendMessageToAdmins(fmt_str, 0xFFFF00FF);
			}

		}
		else
		{
			static query[148],
				Cache: result;

			mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE phone=%d LIMIT 1", number);
			result = mysql_query(mysql, query);

			new rows = cache_num_rows();

			if(rows)
			{
				new name[21];
				cache_get_field_content(0, "name", name);

				static fmt_str[128];
				format(fmt_str, sizeof fmt_str, "SMS: %s | Получатель: %s [т.%d]", message, name, number);
				SendClientMessage(playerid, 0xFFFF00FF, fmt_str);
				SetPlayerChatBubble(playerid, "SMS >>", 0xFFFF00FF, 5.0, 1500);
			}
			else SCM(playerid, COLOR_GREY, "* Данный номер не существует");

			cache_delete(result);
		}
	}
	else
	{
		SendClientMessage(playerid, 0xCECECEFF, "* На счету недостаточно средств");
		SendClientMessage(playerid, 0xCECECEFF, "* Пополнить мобильный телефон можно в любом банкомате");
	}
	return 1;
}

cmd:togphone(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0x999999FF, "* У Вас нет телефона. Его можно купить в сотовом салоне");

	if(GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER) != INVALID_PLAYER_ID || GetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER) != INVALID_PLAYER_ID)
		return SendClientMessage(playerid, 0xCECECEFF, "* Закончите текущий разговор");

	if(GetPlayerPhoneCall(playerid, PC_ENABLED))
	{
		SetPlayerPhoneCall(playerid, PC_ENABLED, false);
		SendClientMessage(playerid, 0xFF6600FF, "* Телефон отключен");
	}
	else
	{
		SetPlayerPhoneCall(playerid, PC_ENABLED, true);
		SendClientMessage(playerid, 0x66CC00FF, "* Телефон включен");
	}
	return 1;
}

cmd:eject(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || !IsPlayerDriver(playerid))
		return SendClientMessage(playerid, 0x999999FF, "* Вы должны сидеть за рулем транспорта");

	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "* Используйте: /eject [id игрока]");

	extract params -> new to_player;

	if(vehicleid != GetPlayerVehicleID(to_player) || playerid == to_player)
		return SendClientMessage(playerid, 0x999999FF, "* Игрок должен сидеть в Вашем транспорте");

	RemovePlayerFromVehicle(to_player);

	static fmt_str[64];
	format(fmt_str, sizeof fmt_str, "%s выкинул Вас из своего транспорта", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, 0x3399FFFF, fmt_str);

	format(fmt_str, sizeof fmt_str, "Вы выкинули %s из своего транспорта", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, 0x3399FFFF, fmt_str);

	return 1;
}

cmd:book(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0x999999FF, "* У Вас нет телефона. Его можно купить в сотовом салоне");

	return ShowPlayerPhoneBook(playerid);
}

cmd:add(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0x999999FF, "* У Вас нет телефона. Его можно купить в сотовом салоне");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /add [id игрока] [номер телефона]");

	extract params -> new to_player, string: number[10];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!IsPlayerPhoneBookInit(playerid))
		InitPlayerPhoneBook(playerid);

	if(GetPlayerPhoneBookContacts(playerid) >= MAX_PHONE_BOOK_CONTACTS)
		return SendClientMessage(playerid, 0xCECECEFF, "* Записная книжка заполнена. Удалите ненужные контакты");

	if((3 <= strlen(number) <= 9) && IsNumeric(number) && strval(number) > 0)
		return AddPhoneBookContact(playerid, GetPlayerNameEx(to_player), number);

	SetPVarString(playerid, "add_contact_name", GetPlayerNameEx(to_player));
	static fmt_str[64 + 1];

	format(fmt_str, sizeof fmt_str, "{FFFFFF}Введите номер телефона для контакта %s", GetPlayerNameEx(to_player));
	return Dialog(playerid, DIALOG_PHONE_BOOK_ADD_CONTACT, DIALOG_STYLE_INPUT, "{FFCD00}Добавление нового контакта", fmt_str, "Добавить", "Отмена");
}

cmd:fill(playerid, params[])
{
	if(GetPlayerJob(playerid) != JOB_RERFECT_DRIVER)
		return SendClientMessage(playerid, 0xCECECEFF, "* Вы не автомеханик");

	if(!IsPlayerInJob(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны работать автомехаником");

	new job_car = GetPlayerJobCar(playerid);
	if(!IsPlayerInVehicle(playerid, job_car) || GetVehicleData(job_car, V_ACTION_ID) == VEHICLE_ACTION_ID_NONE)
		return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны работать автомехаником и находиться в рабочем транспорте");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Использование: /fill [id игрока] [кол-во топлива] [стоимость]");

	extract params -> new to_player, fill_fuel_count, fill_price;

	if(!IsPlayerConnected(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 15.0))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");

	if(!IsPlayerDriver(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Клиент должен находиться за рулем");

	if(1 <= GetPlayerJobLoadItems(playerid) <= fill_fuel_count)
		return SendClientMessage(playerid, 0xCECECEFF, "* У Вас нет такого количества топлива");

	if(!(1 <= fill_price <= 1500))
		return SendClientMessage(playerid, 0xCECECEFF, "* Стоимость должна быть до 1500 рублей");

	if(!GetILPlayerInt(GetPlayerMoneyEx(to_player), fill_price))
		return SendClientMessage(playerid, 0xCECECEFF, "* У клиента нет с собой столько денег");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_FILL_CAR, fill_fuel_count, fill_price);
	return 1;
}

cmd:repair(playerid, params[])
{
	if(GetPlayerJob(playerid) != JOB_RERFECT_DRIVER)
		return SendClientMessage(playerid, 0xCECECEFF, "* Вы не автомеханик");

	if(!IsPlayerInJob(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны работать автомехаником");

	new job_car = GetPlayerJobCar(playerid);
	if(!IsPlayerInVehicle(playerid, job_car) || GetVehicleData(job_car, V_ACTION_ID) == VEHICLE_ACTION_ID_NONE)
		return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны работать автомехаником и находиться в рабочем транспорте");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Использование: /repair [id игрока] [стоимость]");

	extract params -> new to_player, repair_price;

	if(!IsPlayerConnected(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 15.0))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок находится слишком далеко");

	if(!IsPlayerDriver(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Клиент должен находиться за рулем");

	new Float: vehicle_health;
	GetVehicleHealth(GetPlayerVehicleID(to_player), vehicle_health);
	if(vehicle_health < 350.0 && !IsPlayerInRangeOfPoint(playerid, 80.0, 1180.0962,2500.5166,12.4769)) return SendClientMessage(playerid, 0xCECECEFF, "* Транспорт клиента очень сильно поврежден, отвезите его на стоянку автомехаников {CCCC00}(/gps)");

	if(!(1 <= repair_price <= 8000))
		return SendClientMessage(playerid, 0xCECECEFF, "* Стоимость должна быть до 8000 рублей");

	if(!GetILPlayerInt(GetPlayerMoneyEx(to_player), repair_price))
		return SendClientMessage(playerid, 0xCECECEFF, "* У клиента нет с собой столько денег");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_REPAIR_CAR, repair_price);
	return 1;
}

cmd:business(playerid, params[])
{
	static query[94],
		Cache: result,
		biz_id,
		biz_name[64];

	mysql_format(mysql, query, sizeof query, "SELECT * FROM business WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();

	if(!rows)
		return SendClientMessage(playerid, 0x999999FF, "* У вас не одного бизнеса во владении.");

	string_dialog[0] = EOS;
	for(new i = 0; i < rows; i ++)
	{
		biz_id = cache_get_field_content_int(i, "id");
		cache_get_field_content(i, "name", biz_name);

		format(query, sizeof query, "{FFFFFF}%d. - %s (№%d)<t>Владелец\n", i + 1, biz_name, biz_id);
		strcat(string_dialog, query);
		SetPlayerListitemValue(playerid, i, biz_id-1);
	}

	Dialog
	(
		playerid, DIALOG_OWNABLE_BIZ_LIST, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите бизнес",
		string_dialog,
		"Выбрать", "Закрыть"
	);

	cache_delete(result);
	return 1;
}

cmd:buybiz(playerid, params[])
{

    if((GetPlayerOwnableBiz(playerid) + 1) > GetPlayerBizSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "* Вы уже имеете максимально количество бизнес компаний.");

	new businessid = GetNearestBusiness(playerid, 4.0);
	if(businessid != -1)
	{
		if(GetOwnableAuction(1, GetBusinessData(businessid, B_SQL_ID)) > 0) return SCM(playerid, COLOR_GREY, "*  Данный бизнес выставлен на аукцион");

	    SetPVarInt(playerid, "buy_biz_id", businessid);

		static fmt_str[256];
		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Название:\t\t\t{339999}%s\n\
			{FFFFFF}Стоимость:\t\t\t{6699FF}%s руб\n\
			{FFFFFF}Плата за аренду:\t\t{6699FF}%s руб в день\n\
			{669966}Вы уверены что хотите купить этот бизнес?",
			GetBusinessData(businessid, B_NAME),
			formatInt(GetBusinessData(businessid, B_PRICE)),
			formatInt(GetBusinessData(businessid, B_RENT_PRICE))
		);
		Dialog(playerid, DIALOG_BIZ_BUY, DIALOG_STYLE_MSGBOX, "{33AACC}Покупка нового бизнеса", fmt_str, "Да", "Нет");
//		MoralPacket_1(playerid, s_ClientInterface, t_CefShow, "Captcha");
	}
	else SendClientMessage(playerid, 0xCECECEFF, "* Вы должны быть рядом с бизнесом, который хотите купить");


	return 1;
}

cmd:sellbiz(playerid, params[])
{
	static query[94],
		Cache: result,
		biz_id,
		biz_name[64];
	mysql_format(mysql, query, sizeof query, "SELECT * FROM business WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);
	new rows = cache_num_rows();
	if(!rows)
		return SendClientMessage(playerid, 0x999999FF, "* У вас не одного бизнеса во владении.");
	string_dialog[0] = EOS;
	for(new i = 0; i < rows; i ++)
	{
		biz_id = cache_get_field_content_int(i, "id");
		cache_get_field_content(i, "name", biz_name);

		format(query, sizeof query, "{FFFFFF} %s [%d]\n", biz_name, biz_id);
		strcat(string_dialog, query);
		SetPlayerListitemValue(playerid, i, biz_id-1);
	}
	Dialog
	(
		playerid, DIALOG_BIZ_SELL_TEST, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите бизнес, который хотите продать",
		string_dialog,
		"Выбрать", "Закрыть"
	);
	cache_delete(result);
	return 1;
}

cmd:sellmybiz(playerid, params[])
{
	extract params -> new to_player, price;
	if(!strlen(params))
		return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /sellmybiz [ID игрока] [стоимость]");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет!");
	if(price < 1)
		return SendClientMessage(playerid, 0xFF6600FF, "* Укажите стоимость продажи!");
	if(!GetILPlayerInt(GetPlayerMoneyEx(to_player), price))
		return SendClientMessage(playerid, 0xFF6600FF, "* У покупателя нет такого количества средств!");
    if((GetPlayerOwnableBiz(to_player) + 1) > GetPlayerBizSlots(to_player))
		return SendClientMessage(playerid, 0x3399FFFF, "* Игрок имеет максимальное количество бизнесов!");
	static query[94],
		Cache: result,
		biz_id,
		biz_name[64];
	mysql_format(mysql, query, sizeof query, "SELECT * FROM business WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);
	new rows = cache_num_rows();
	if(!rows)
		return SendClientMessage(playerid, 0x999999FF, "* У вас не одного бизнеса во владении.");
    SetPVarInt(playerid, "sellmybiz_to_player", to_player);
    SetPVarInt(playerid, "sellmybiz_money", price);
	string_dialog[0] = EOS;
	for(new i = 0; i < rows; i ++)
	{
		biz_id = cache_get_field_content_int(i, "id");
		cache_get_field_content(i, "name", biz_name);

		format(query, sizeof query, "{FFFFFF} %s [%d]\n", biz_name, biz_id);
		strcat(string_dialog, query);
		SetPlayerListitemValue(playerid, i, biz_id-1);
	}
	Dialog
	(
		playerid, DIALOG_BIZ_SELL_MY_BIZ, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите бизнес, который хотите продать",
		string_dialog,
		"Выбрать", "Закрыть"
	);
	cache_delete(result);
	return 1;
}

cmd:bizmusic(playerid, params[])
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		if(GetBusinessData(businessid, B_IMPROVEMENTS) >= 4)
		{
			static fmt_str[13 + 1];
			static string[(sizeof fmt_str - 1) * (sizeof g_business_sound) + 1];

			string = "1. Отключен\n";
			for(new idx = 1; idx <= sizeof g_business_sound; idx ++)
			{
				format(fmt_str, sizeof fmt_str, "%d. Звук №%d\n", idx + 1, idx);
				strcat(string, fmt_str);
			}
			Dialog(playerid, DIALOG_BIZ_ENTER_MUSIC, DIALOG_STYLE_LIST, "{FFCD00}Звук при входе в бизнес", string, "Выбрать", "Закрыть");
		}
		else SendClientMessage(playerid, 0xCECECEFF, "* Для использование этой функции необходим 4 уровень улучшения бизнеса");
	}
	else SendClientMessage(playerid, 0xCECECEFF, "* У Вас нет бизнеса");

	return 1;
}

cmd:manager(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /manager [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 10.0))
		return SendClientMessage(playerid, 0xCECECEFF, "* Игрок находится слишком далеко");

	//SendPlayerOffer(playerid, to_player, OFFER_TYPE_BUSINESS_MANAGER, businessid);
	static query[94],
		Cache: result,
		biz_id,
		biz_name[64];

	mysql_format(mysql, query, sizeof query, "SELECT * FROM business WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();

	if(!rows)
		return SendClientMessage(playerid, 0x999999FF, "* У вас не одного бизнеса во владении.");

    SetPVarInt(playerid, "manager_to_player", to_player);

	string_dialog[0] = EOS;
	for(new i = 0; i < rows; i ++)
	{
		biz_id = cache_get_field_content_int(i, "id");
		cache_get_field_content(i, "name", biz_name);

		format(query, sizeof query, "{FFFFFF} %s [%d]\n", biz_name, biz_id);
		strcat(string_dialog, query);
		SetPlayerListitemValue(playerid, i, biz_id-1);
	}

	Dialog
	(
		playerid, DIALOG_BIZ_MANAGER, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите бизнес, который хотите продать",
		string_dialog,
		"Выбрать", "Закрыть"
	);
    cache_delete(result);
	return 1;
}

cmd:buy(playerid, params[])
{
	new businessid = GetPlayerInBiz(playerid);
	if(businessid != -1)
	{
		if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7))
		{
			Dialog
			(
				playerid, DIALOG_BIZ_SHOP_24_7, DIALOG_STYLE_TABLIST_HEADERS,
				"Список товаров",
				"Товар \t Стоимость\n"\
				"Прибор для диагностики авто \t 50000 руб\n"\
				"Камера \t 770 руб\n"\
				"Ремкомплект \t (Нету в наличии!))\n"\
				"Топор \t 660 руб\n"\
				"Парашют \t 880 руб\n"\
				"Лотерейный билет \t -\n"\
				"Маска \t 354 руб\n"\
				"Бумбокс \t (Нету в наличии!))",
				"Выбор", "Закрыть"
			);
		}
		else if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_GARDEN))
		{
			Dialog
			(
				playerid, DIALOG_BIZ_SHOP_GARDEN, DIALOG_STYLE_TABLIST_HEADERS,
				"{FFD83D}Список товаров",
				"Товар\tСтоимость\n\
				Семена томата\t300.000 руб\n\
				Семена огурцов\t300.000 руб\n\
				Лейка\t1.500.000 руб\n\
				Семена картофеля\t300.000 руб\n\
				Семена свёклы\t300.000 руб\n\
				Семена перца\t300.000 руб\n\
				Семена баклажана\t300.000 руб\n\
				Семена капусты\t300.000 руб\n\
				Семена моркови\t300.000 руб\n\
				Лопата\t10.000.000 руб",
				"Выбор", "Закрыть"
			);
		}
 		else if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_APTEKA))
		{
			Dialog
			(
				playerid, DIALOG_BIZ_SHOP_APTEKA, DIALOG_STYLE_LIST,
				"{FFD83D}Аптека",
				"Аптечка\t\t 500 руб\n"\
				"Противорвотное\t\t 300 руб",
				"Купить", "Отмена"
			);
		}
 		else if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_ZAKUS))
        {
            Dialog
            (
                playerid, DIALOG_BIZ_SHOP_ZAKUS, DIALOG_STYLE_LIST,
                "{FFFFFF}Закусочная",
                "{FFFFFF}1. Стандартный куриный обед<t><t>{FFA500} 1.000 руб\n"\
                "{FFFFFF}2. Ассорти из курицы<t><t>{FFA500} 1.500 руб\n"\
                "{FFFFFF}3. Королевский обед<t><t>{FFA500} 3.000 руб\n"\
                "{FFFFFF}4. Лимонад<t><t>{FFA500} 200 руб\n"\
                "{FFFFFF}5. Чай<t><t>{FFA500} (Нету в наличии!)",
                "Купить", "Закрыть"
            );
        }
 		else if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_KONDITER))
		{
		    static fmt_str[144];

		    format
			(
				fmt_str, sizeof fmt_str,
				"{FFFFFF}%s",
				GetBusinessData(businessid, B_NAME)
			);
			Dialog
			(
				playerid, DIALOG_BIZ_SHOP_KONDITER, DIALOG_STYLE_LIST,
				fmt_str,
				"{FFFFFF}1. Маленький десерт<t>{CC9900}630 руб\n"\
				"{FFFFFF}2. Средний десерт<t>{CC9900}1120 руб\n"\
				"{FFFFFF}3. Большой десерт<t>{CC9900}1575 руб\n"\
				"{FFFFFF}4. Напиток\t\t{FFA500} 227 руб",
				"Купить", "Отмена"
			);
		}
		else if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CELL_SALON))
		{
			Dialog
			(
				playerid, DIALOG_BIZ_CELL_SALON, DIALOG_STYLE_LIST,
				"{FFD83D}Сотовый салон",
				"1. Мобильный телефон\t{00CC00}7350 руб\n"\
				"2. Планшет\t{00CC00}50000 руб\n"\
				"3. Изменить номер телефона\t{00CC00}1750 руб\n"\
				"4. Изменить цвет телефона\t{00CC00}700 руб\n"\
				"5. Пополнить счёт телефона",
				"Купить", "Отмена"
			);
		}
		else if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_TIR))
		{
			Dialog
			(
				playerid, DIALOG_BIZ_TIR, DIALOG_STYLE_LIST,
				"{FFD83D}Тир 'Radmir'",
				"1. Desert-Eagle\t\t{FFD700}2000 руб\n"\
				"2. ShotGun\t\t\t{FFD700}2000 руб\n"\
				"3. Снайперская винтовка\t{FFD700}2000 руб\n"\
				"4. MP-5\t\t\t\t{FFD700}2000 руб\n"\
				"5. SD-Pistol\t\t\t{FFD700}2000 руб",
				"Купить", "Отмена"
			);
		}
		else if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_AVTOZAP))
    	{
      		Dialog
      	(
        playerid, DIALOG_BIZ_AVTOZAP_1, DIALOG_STYLE_LIST,
        "{ffcd00}Магазин автозапчастей",
        "{ffffff}1. Моторное масло\t{00CC00}200.000 руб\n"\
        "{ffffff}2. Воздушный фильтр\t{00CC00}300.000 руб\n"\
        "{ffffff}3. Масляный фильтр\t{00CC00}100.000 руб\n"\
        "{ffffff}4. Сабвуфер\t\t{00CC00}300.000 руб\n"\
        "{ffffff}5. Автосигнализация\t{00CC00}350.000 руб\n"\
        "{ffffff}6. Рем. комплект\t{00CC00}500.000 руб\n"\
        "{ffffff}7. Домкрат\t{00CC00}125.000 руб",
        "Купить", "Отмена"
      );
    }
  }
  return 1;
}
cmd:yrang(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new to_player, lvl; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /yrang [id игрока] [уровень]");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
    if(!(0 <= lvl <= 3))
        return SendClientMessage(playerid, 0xCECECEFF, "* Вы указали неверный уровень ютуберки. Доступные: 1-3");
	SetPlayerData(to_player, P_YADMIN, lvl);
	UpdatePlayerDatabaseInt(to_player, "yadmin", lvl);

	static fmt_text[128];
 	if(lvl > 0)
	{
		format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] выдал %s[%d] %d уровень ютуберки",
		GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, lvl);

		SendMessageToAdmins(fmt_text, 0x999999FF);

		format(fmt_text, sizeof fmt_text, "Поставил %s[%d] на пост ютубера %d уровня", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), lvl);
		SendLog(playerid, LOG_TYPE_ADMIN_SETADMIN, fmt_text);
	}
	else
	{
		format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] снял %s[%d] с ютубера",
		GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

		SendMessageToAdmins(fmt_text, 0x999999FF);

		format(fmt_text, sizeof fmt_text, "Снял %s[%d] с поста ютубера", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
		SendLog(playerid, LOG_TYPE_ADMIN_SETADMIN, fmt_text);
	}
	return 1;
}
cmd:addbiz(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
	extract params -> new type, price, rent_price; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /addbiz [тип] [стоимость] [цена аренды]");

	static fmt_text[350];

	if(!(1 <= type <= 37))
	{
	    SendClientMessage(playerid, 0x999999FF,"Типы: 1-24/7, 2-Клуб, 3-Управление стат., 4-Риэлторское Агенство., 5-Одежда, 6-Отель, 7-Авторынок, 8-Казино");
		SendClientMessage(playerid, 0x999999FF,"9-Сотовый салон, 11-Магазин оружия,12-Bank,-13 Комп клуб,14-Спортзал");
	    SendClientMessage(playerid, 0x999999FF,"16-Аренда, 17-Новое СТО,18 - ферма, 19 - детейлинг, 20 - бу, 21 - нов бизы, 22- метро, 23 - Шиномонтаж, 24 - Садовод, 25 - Салон Красоты, 26 - Магазин Автозапчастей, 27 - Тир");
   		SendClientMessage(playerid, 0x999999FF,"30 - Прачечная, 31 - Закусочная, 32 - Аптека, 33 - Кондитерская, 36 - Магазин рыболова, 37 - Пес");
		return 1;
	}
	if(price < 1) return SendClientMessage(playerid, 0x999999FF, "* Стоимость бизнеса не может быть меньше 1");

	if(rent_price < 1) return SendClientMessage(playerid, 0x999999FF, "* Стоимость аренды не может быть меньше 1");

	new Cache: result,
		idx = g_business_loaded;

	GetPlayerPos(playerid, g_business[idx][B_POS_X], g_business[idx][B_POS_Y], g_business[idx][B_POS_Z]);

	new buffer[2];

	buffer[0] = Get2DCity(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y));
	buffer[1] = Get2DZone(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y));

	SetBusinessData(idx, B_CITY,			buffer[0]);
	SetBusinessData(idx, B_ZONE,			buffer[1]);

	SetBusinessData(idx, B_PRICE,			price);
	SetBusinessData(idx, B_RENT_PRICE,		rent_price);
	SetBusinessData(idx, B_TYPE,			type);

	format
	(
		fmt_text, sizeof fmt_text,
		"INSERT INTO business \
		(city, zone, type, price, rent_price, x, y, z)\
		VALUES ('%d', '%d', '%d', '%d', '%d', '%f', '%f', '%f')",
		GetBusinessData(idx, B_CITY),
		GetBusinessData(idx, B_ZONE),
		type, price, rent_price,
		GetBusinessData(idx, B_POS_X),
		GetBusinessData(idx, B_POS_Y),
		GetBusinessData(idx, B_POS_Z)
	);

	result = mysql_query(mysql, fmt_text, true);

	SetBusinessData(idx, B_SQL_ID, cache_insert_id());

	cache_delete(result);

	g_business_loaded ++;

	CreatePickup(19132, 23, GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), GetBusinessData(idx, B_POS_Z), 0, PICKUP_ACTION_TYPE_BIZ_ENTER, idx);

	UpdateBusinessLabel(idx);

	STRING_GLOBAL = "";
    format(STRING_GLOBAL, 500, "A: %s [%d] создал бизнес №%d (%s / %s)", GetPlayerNameEx(playerid), playerid, idx, GetCityName(GetBusinessData(idx, B_CITY)), GetZoneName(GetBusinessData(idx, B_ZONE)));
	//format(STRING_GLOBAL, 144, "Вы создали бизнес №%d (City / [Zone])", GetPlayerNameEx(playerid), playerid, idx, GetCityName(GetBusinessData(idx, B_CITY)), GetZoneName(GetBusinessData(idx, B_ZONE)));
	SendMessageToAdmins(STRING_GLOBAL, 0x66CC33FF);
	return 1;
}

cmd:b_set_pick(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
	extract params -> new biz_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /bsetexitpos [id бизнеса]");

	if(!(0 <= biz_id <= g_business_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "* Данного бизнеса не существует на сервере");

	static fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE business SET z=1000 WHERE id=%d",
		GetBusinessData(biz_id, B_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты выхода у бизнеса №%d", biz_id);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

cmd:bsx(playerid, params[]) return callcmd::b_set_exit_pos(playerid, params);
cmd:b_set_exit_pos(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 			else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
	extract params -> new biz_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /bsetexitpos [id бизнеса]");

	if(!(0 <= biz_id <= g_business_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "* Данного бизнеса не существует на сервере");

	GetPlayerPos(playerid, g_business[biz_id][B_EXIT_POS_X], g_business[biz_id][B_EXIT_POS_Y], g_business[biz_id][B_EXIT_POS_Z]);
	GetPlayerFacingAngle(playerid, g_business[biz_id][B_EXIT_ANGLE]);

	static fmt_text[144];

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

cmd:b_set_pos(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 			else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
	extract params -> new biz_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /bsetexitpos [id бизнеса]");

	if(!(0 <= biz_id <= g_business_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "* Данного бизнеса не существует на сервере");

	GetPlayerPos(playerid, g_business[biz_id][B_POS_X], g_business[biz_id][B_POS_Y], g_business[biz_id][B_POS_Z]);
	static fmt_text[144];

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

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты у бизнеса №%d", biz_id);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

cmd:b_set_name(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /b_set_name [id бизнеса][название]");

	extract params -> new biz_id, string: name[30];

	if(!(0 <= biz_id <= g_business_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "* Данного бизнеса не существует на сервере");

    SetBusinessData(biz_id, B_NAME, name);

	static fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE business SET name='%s' WHERE id=%d",
		GetBusinessData(biz_id, B_NAME),
		GetBusinessData(biz_id, B_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);
	format(fmt_text, sizeof fmt_text, "Вы успешно изменили название у бизнеса №%d на %s", biz_id, name);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);
	return 1;
}

cmd:b_set_int(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!strlen(params))
	{
        SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /b_set_int [id бизнеса][инта]");
        SendClientMessage(playerid, 0xCECECEFF, "* Типы бизнесов: 1-24/7, 2-Клуб, 3-Управление стат., 4-Риэлторск., 5-Одежда, 6-Отель, 7-Авторынок, 8-Казино, 9-Сотовый салон 11-Оружейный 12-Bank 13 - Комп клуб 14- Спортзал 15- Детелинг");
	}

	extract params -> new biz_id, inta;

	if(!(0 <= biz_id <= g_business_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "* Данного бизнеса не существует на сервере");

	new inter = inta - 1;

    SetBusinessData(biz_id, B_INTERIOR, inter);

	static fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE business SET interior='%d' WHERE id=%d",
		inter,
		GetBusinessData(biz_id, B_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили инту у бизнеса №%d на %d", biz_id, inta);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

cmd:addhouse(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 			else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
	extract params -> new type, price, rent_price; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /addhouse [тип] [стоимость] [Ежедневная плата]");

	static fmt_text[300];

	if(!(0 <= type <= sizeof g_house_type - 1))
	{
		SendClientMessage(playerid, 0x999999FF, "* Типы домов:");

		for(new i; i < sizeof g_house_type; i ++)
		{
			format(fmt_text, sizeof fmt_text, "%d. %s", i, GetHouseTypeInfo(i, HT_NAME));

			SendClientMessage(playerid, 0xCECECEFF, fmt_text);
		}

		return 1;
	}

	if(price < 1) return SendClientMessage(playerid, 0x999999FF, "* Стоимость дома не может быть меньше 1");

	if(rent_price < 1) return SendClientMessage(playerid, 0x999999FF, "* Стоимость ежедневной платы не может быть меньше 1");

	new Cache: result,
		idx = g_house_loaded;

	GetPlayerPos(playerid, g_house[idx][H_POS_X], g_house[idx][H_POS_Y], g_house[idx][H_POS_Z]);

	new buffer[2];

	buffer[0] = Get2DCity(GetHouseData(idx, H_POS_X), GetHouseData(idx, H_POS_Y));
	buffer[1] = Get2DZone(GetHouseData(idx, H_POS_X), GetHouseData(idx, H_POS_Y));

	SetHouseData(idx, H_CITY,			buffer[0]);
	SetHouseData(idx, H_ZONE,			buffer[1]);

	SetHouseData(idx, H_PRICE,			price);
	SetHouseData(idx, H_RENT_PRICE,		rent_price);
	SetHouseData(idx, H_TYPE,			type);

	SetHouseData(idx, H_ENTRACE,		-1);

	format
	(
		fmt_text, sizeof fmt_text,
		"INSERT INTO houses \
		(city, zone, type, price, rent_price, x, y, z)\
		VALUES ('%d', '%d', '%d', '%d', '%d', '%f', '%f', '%f')",
		GetHouseData(idx, H_CITY),
		GetHouseData(idx, H_ZONE),
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

	format(fmt_text, sizeof fmt_text, "A: %s [%d] создал дом №%d (%s / %s)", GetPlayerNameEx(playerid), playerid, idx, GetCityName(GetHouseData(idx, H_CITY)), GetZoneName(GetHouseData(idx, H_ZONE)));

	SendMessageToAdmins(fmt_text, 0x66CC33FF);
	SendClientMessage(playerid, 0x999999FF, "* Не забудьте поставить координаты выхода: {66CC33} /setexitpos");

	return 1;
}
cmd:set_pick(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
	extract params -> new house_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setexitpos [id дома]");

	if(!(0 <= house_id <= g_house_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "* Данного дома не существует на сервере");

	GetPlayerPos(playerid, g_house[house_id][H_EXIT_POS_X], g_house[house_id][H_EXIT_POS_Y], g_house[house_id][H_EXIT_POS_Z]);
	GetPlayerFacingAngle(playerid, g_house[house_id][H_EXIT_ANGLE]);

	static fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE houses SET x=1000 WHERE id=%d",
		GetHouseData(house_id, H_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты выхода у дома №%d", house_id);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);
	SendClientMessage(playerid, 0xFFFFFFFF, "Вы успешно поставили выход! Не забудьте поставить координаты Т/C:{99ff00} /setcarpos ");

	return 1;
}

cmd:sx(playerid, params[]) return callcmd::setexitpos(playerid, params);
cmd:setexitpos(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
	extract params -> new house_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setexitpos [id дома]");

	if(!(0 <= house_id <= g_house_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "* Данного дома не существует на сервере");

	GetPlayerPos(playerid, g_house[house_id][H_EXIT_POS_X], g_house[house_id][H_EXIT_POS_Y], g_house[house_id][H_EXIT_POS_Z]);
	GetPlayerFacingAngle(playerid, g_house[house_id][H_EXIT_ANGLE]);

	static fmt_text[144];

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
	SendClientMessage(playerid, 0xFFFFFFFF, "Вы успешно поставили выход! Не забудьте поставить координаты Т/C:{99ff00} /setcarpos ");

	return 1;
}
cmd:sc(playerid, params[]) return callcmd::setcarpos(playerid, params);
cmd:setcarpos(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new house_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setcarpos [id дома]");

	if(!(0 <= house_id <= g_house_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "* Данного дома не существует на сервере");

	GetPlayerPos(playerid, g_house[house_id][H_CAR_POS_X], g_house[house_id][H_CAR_POS_Y], g_house[house_id][H_CAR_POS_Z]);
	GetPlayerFacingAngle(playerid, g_house[house_id][H_CAR_ANGLE]);

	static fmt_text[144];

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

cmd:getname(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 9) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new user_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /getname [номер аккаунта]");

	new name[21],
		fmt_text[120];

	format(name, sizeof name, "%s", GetPlayerNameBySqlID(user_id));

	if(strcmp(name, "none", true))
	{
		format(fmt_text, sizeof fmt_text, "Имя: %s / Номер аккаунта: %d", name, user_id);

		SendClientMessage(playerid, 0x3399FFFF, fmt_text);
	}
	else SendClientMessage(playerid, 0x999999FF, "* Данный аккаунт не найден в базе данных");

	return 1;
}

cmd:slap(playerid, params[])
{
    if (GetPlayerAdminEx(playerid) < 2)
        return 1;

    if (!admin_logged[playerid])
        return SCM(playerid, 0x999999FF, "Вы не авторизированы, для этого используйте /alogin");

    if (!strlen(params))
        return SCM(playerid, 0xCECECEFF, "* Используйте: /slap [id игрока] [+/- | + подбросить вверх, - вниз]");

    extract params -> new to_player, string:direction[2];

    if (!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SCM(playerid, 0x999999FF, "Такого игрока нет");

    if (direction[0] != '+' && direction[0] != '-')
        return SCM(playerid, 0xCECECEFF, "* Используйте: /slap [id игрока] [+/- | + подбросить вверх, - вниз]");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(to_player, x, y, z);

    new Float:height = 5.0;

    if (direction[0] == '+')
    {
        SetPlayerPos(to_player, x, y, z + height);
    }
    else if (direction[0] == '-')
    {
        SetPlayerPos(to_player, x, y, z - height);
    }

    PlayerPlaySound(to_player, 1130, 0.0, 0.0, 0.0);

    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Вы подбросили игрока %s", GetPlayerNameEx(to_player));
    SCM(playerid, -1, STRING_GLOBAL);

    format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Администратор %s подбросил Вас", GetPlayerNameEx(playerid));
    SCM(to_player, -1, STRING_GLOBAL);

    format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] подбросил игрока %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
    SendMessageToAdmins(STRING_GLOBAL, 0x999999FF);

    return 1;
}

cmd:hp(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerYAdminEx(playerid) < 2) return 1;

	extract params -> new to_player, health; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /hp [id игрока] [количество здоровья]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	else if(GetPlayerAdminEx(playerid) == 1 && to_player != playerid)
		return SendClientMessage(playerid, 0x999999FF, "* Администраторам 1-го уровня доступно изменение только своего уровня здоровья");

	else if(!(0 <= health <= 100)) return SendClientMessage(playerid, 0x999999FF, "* Уровень здоровья от 0 до 100");
	
	/*if(GetPlayerData(to_player, P_HEALTH) < 1)
	{
        SetPlayerSpawnPos(playerid);
	}*/

	SetPlayerData(to_player, P_HEALTH, health);
	SetPlayerHealthEx(to_player, health);

	if(GetPlayerData(to_player, P_HOSPITAL))
		SetPlayerData(to_player, P_HOSPITAL, false);

	static fmt_msg[105];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s изменил Вам уровень здоровья", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, -1, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы изменили %s уровень здоровья", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, -1, fmt_msg);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_msg, sizeof fmt_msg, "A: Администратор %s[%d] изменил уровень здоровья %s[%d] на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, health);
		SendMessageToAdmins(fmt_msg, 0x999999FF);
	}
	return 1;
}

cmd:freeze(playerid,params[])
{
	if(CheckAdmin(playerid, 4)) return 1;

	if(!strlen(params)) return SendClientMessage(playerid, COLOR_GREY, "* Используйте: /mp_freeze [id player]");

	extract params -> new to_player;

	TogglePlayerControllable(to_player,false);
	SendClientMessage(to_player, COLOR_WHITE, "Администратор заморозил Вас");

	SendClientMessage(playerid, COLOR_WHITE, "Вы успешно заморозили игроков в радиусе");

	return 1;
}

cmd:unfreeze(playerid,params[])
{
	if(CheckAdmin(playerid, 4)) return 1;

	if(!strlen(params)) return SendClientMessage(playerid, COLOR_GREY, "* Используйте: /mp_freeze [id player]");

	extract params -> new to_player;

	TogglePlayerControllable(to_player,true);
	SendClientMessage(to_player, COLOR_WHITE, "Администратор заморозил Вас");

	SendClientMessage(playerid, COLOR_WHITE, "Вы успешно заморозили игроков в радиусе");

	return 1;
}
cmd:plveh(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new to_player, modelid, color_1, color_2; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /plveh [id игрока] [id модели] [цвет 1] [цвет 2]");
	if(!(400 <= modelid <= 614) && (!(699 <= modelid <= 699) && (!(793 <= modelid <= 799) && (!(15065 <= modelid <= 15299) && (!(15600 <= modelid <= 15699) && (!(17400 <= modelid <= 17448) && (!(907 <= modelid <= 909) && (!(965 <= modelid <= 965) && (!(999 <= modelid <= 999) && (!(1326 <= modelid <= 1326))))))))))) return SCM(playerid, 0xCECECEFF, "* Вы указали неверный id авто. Доступные авто: 400-614, 699, 793-799, 907-909, 965, 999, 1326, 15065-15299, 15600-15699, 17400-17448");

	new Float: x,
		Float: y,
		Float: z,
		Float: a;

	GetPlayerPos(to_player, x, y, z);
	GetPlayerFacingAngle(to_player, a);

	new vehicleid = CreateVehicle(modelid, x, y, z, a, color_1, color_2, -1, 0, VEHICLE_ACTION_TYPE_ADMIN_CAR, 1);
	PutPlayerInVehicle(to_player, vehicleid, 0);

	SetVehicleNumber(vehicleid, 5, ""SERVER_NUMBER_CARSH"", "");

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: Администратор %s[%d] создал транспорт для %s[%d] (%d, %d, %d)", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, modelid, color_1, color_2);
	SendMessageToAdmins(STRING_GLOBAL, 0x999999FF);

	SCMF(to_player, 0x999999FF, "Администратор %s[%d] создал транспорт для вас (%d, %d, %d)", GetPlayerNameEx(playerid), playerid, modelid, color_1, color_2);

	SetPVarInt(playerid, "SpawnCar", gettime());
	return 1;
}

cmd:veh(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4 && GetPlayerYAdminEx(playerid) < 2) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new modelid, color_1, color_2; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /veh [id модели] [цвет 1] [цвет 2] [доступ игроков (не обязательно)]");
	if(!(400 <= modelid <= 614) && (!(699 <= modelid <= 699) && (!(793 <= modelid <= 799) && (!(15065 <= modelid <= 15299) && (!(15600 <= modelid <= 15699) && (!(17400 <= modelid <= 17448) && (!(907 <= modelid <= 909) && (!(965 <= modelid <= 965) && (!(999 <= modelid <= 999) && (!(1326 <= modelid <= 1326))))))))))) return SCM(playerid, 0xCECECEFF, "* Вы указали неверный id авто. Доступные авто: 400-614, 699, 793-799, 907-909, 965, 999, 1326, 15065-15299, 15600-15692, 17400-17448");
	new status;

	sscanf(params, "{d}{d}{d}d", status);

	if(!(0 <= status <= 1))
		return SendClientMessage(playerid, 0x999999FF, "* Доступ игроков к транспорту: 0 - Нет доступа, 1 - Доступно любому игроку");

	new Float: x,
		Float: y,
		Float: z,
		Float: a;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	new vehicleid = CreateVehicle(modelid, x, y, z, a, color_1, color_2, VEHICLE_ACTION_TYPE_ADMIN_CAR, status);
	//PutPlayerInVehicle(playerid, vehicleid, 0);

	SetVehicleNumber(vehicleid, 5, ""SERVER_NUMBER_CARSH"", "");

	static fmt_text[100];

	if(GetPlayerAdminEx(playerid) <= 4)
	{
		format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] создал транспорт (%d, %d, %d)",
		GetPlayerNameEx(playerid), playerid, modelid, color_1, color_2);

		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	SetPVarInt(playerid, "SpawnCar", gettime());
	return 1;
}

cmd:add_rentveh(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	if(GetPVarInt(playerid,"SpawnCar") > gettime()) return SCM(playerid,COLOR_RED,"\
	 			    	[Ошибка] {FFFFFF}Спавнить авто можно раз в 1 минуту!");
	extract params -> new model_id, color_1, color_2, status, id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /add_rentveh [id модели] [цвет 1] [цвет 2] [цена] [id аренды]");

	if(!(400 <= model_id <= 611)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте модель от 400 до 611");

	new Float: x,
		Float: y,
		Float: z,
		Float: a;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	SetTimer("CountRentedVehicles", 1000, 0);

	new vehicleid = CreateVehicle(model_id, x, y, z, a, color_1, color_2, -1, 0);

	SetVehicleData(vehicleid, V_RENT, id);
	SetVehicleData(vehicleid, V_RENTP, status);
	SetVehicleData(vehicleid, V_OWRENT, 0);

	static fmt_text[100];

	if(GetPlayerAdminEx(playerid) <= 4)
	{
		format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] создал транспорт (%d, %d, %d)",
		GetPlayerNameEx(playerid), playerid, model_id, color_1, color_2);

		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	SetPVarInt(playerid, "SpawnCar", gettime());
	return 1;
}
cmd:setleader(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 
	if(!strlen(params))
	{
		SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setleader [id игрока] [организация]");

		SendClientMessage(playerid, 0xCECECEFF, "* 1 - Правительство области");
		SendClientMessage(playerid, 0xCECECEFF, "* 2 - Воинская часть");
		SendClientMessage(playerid, 0xCECECEFF, "* 3 - Городская больница");
		SendClientMessage(playerid, 0xCECECEFF, "* 4 - ТРК «Ритм»");
		SendClientMessage(playerid, 0xCECECEFF, "* 5 - ФСБ");
		SendClientMessage(playerid, 0xCECECEFF, "* 6 - Министерство внутренних дел");
		SendClientMessage(playerid, 0xCECECEFF, "* 7 - Фсин");
		SendClientMessage(playerid, 0xCECECEFF, "* 8 - Русская мафия");
		SendClientMessage(playerid, 0xCECECEFF, "* 9 - Японская мафия");
		SendClientMessage(playerid, 0xCECECEFF, "* 10 - Итальянская мафия");
		return 1;
	}
	extract params -> new to_player, org_id;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!( 0 <= org_id <= 10)) return SendClientMessage(playerid, 0x999999FF, "* Неверный идентификатор организации");

	static fmt_msg[155];

	if(!org_id)
	{
	    format(fmt_msg, sizeof fmt_msg, "Администратор %s[%d] снял Вас с должности лидера организации \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerTeamName(to_player));
		SendClientMessage(to_player, 0xFFFF00FF, fmt_msg);
		format(fmt_msg, sizeof fmt_msg, "A: %s[%d] снял %s[%d] с должности лидера организации \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, GetPlayerTeamName(to_player));
		SendMessageToAdmins(fmt_msg, 0x999999FF);
		return InvitePlayer(to_player, 0, 0, true);
	}

	InvitePlayer(to_player, org_id, 10, true);

	if(IsTeamSubdivision(org_id))
		format(fmt_msg, sizeof fmt_msg, "Администратор %s[%d] назначил Вас лидером подразделения \"%s\", организации \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerSubdivisionName(to_player), GetPlayerTeamName(to_player));
	else
		format(fmt_msg, sizeof fmt_msg, "Администратор %s[%d] назначил Вас лидером организации \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerTeamName(to_player));

	SendClientMessage(to_player, 0xFFFF00FF, fmt_msg);

	if(IsTeamSubdivision(org_id))
		format(fmt_msg, sizeof fmt_msg, "A: %s[%d] назначил %s[%d] лидером подразделения \"%s\", организации \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, GetPlayerSubdivisionName(to_player), GetPlayerTeamName(to_player));
	else
		format(fmt_msg, sizeof fmt_msg, "A: %s[%d] назначил %s[%d] лидером организации \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, GetPlayerTeamName(to_player));

	SendMessageToAdmins(fmt_msg, 0x999999FF);

	if(org_id)
		format(fmt_msg, sizeof fmt_msg, "Назначил %s[acc:%d] лидером %s[%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), GetTeamName(org_id), org_id);

	else
		format(fmt_msg, sizeof fmt_msg, "Снял %s[acc:%d] с поста лидера", GetPlayerNameEx(to_player), to_player);

	SendLog(playerid, LOG_TYPE_ADMIN_SETLEADER, fmt_msg);
	SysPogony_LoadPogonyDelayed(playerid);
	return 1;
}

cmd:auninvite(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /auninvite [id игрока]");

	extract params -> new to_player, string:reason[32];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF,"Такого игрока нет");

	if(GetPlayerTeamEx(playerid) == 0) return SendClientMessage(playerid, 0xFF6600FF, "* Данный игрок не состоит в организации");

	static fmt_text[200];

	format(fmt_text,sizeof(fmt_text),"A: %s [%d] уволил игрока %s [%d] из огранизации '%s'", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, GetTeamName(GetPlayerTeamEx(to_player)));
	SendMessageToAdmins(fmt_text, COLOR_GREY);

	static fmt_msg[128];

	format(fmt_msg, sizeof(fmt_msg), "Администратор %s [%d] уволил Вас из фракции %s", GetPlayerNameEx(playerid), playerid, GetTeamName(GetPlayerTeamEx(to_player)));
	SendClientMessage(to_player, 0xFF6600FF, fmt_msg);

	format(fmt_msg, sizeof(fmt_msg),"Вы уволили из фракции игрока {"#cGold"}%s [%d]", GetPlayerNameEx(to_player), to_player);
	SendClientMessage(playerid, -1, fmt_msg);

	UnInvite(playerid, to_player);
	return 1;
}

cmd:givegun(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6 && GetPlayerBuyAdminEx(playerid) < 6) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new to_player, weapon_id, weapon_ammo; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /givegun [id игрока] [id оружия] [кол-во патронов]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!(1 <= weapon_id <= 46) || (19 <= weapon_id <= 21)) return SendClientMessage(playerid, 0x999999FF, "* ID оружия от 1 до 46");
	if(!(1 <= weapon_ammo <= 1000)) return SendClientMessage(playerid, 0x999999FF, "* Количество патронов от 1 до 1000");

	if(weapon_id == 27 || weapon_id == 4 || weapon_id == 19
		|| weapon_id == 20 || weapon_id == 21 || weapon_id == 35 || weapon_id == 36 || weapon_id == 39 || weapon_id == 40 || weapon_id == 44 || weapon_id == 45
		|| weapon_id == 38 || weapon_id == 32 || weapon_id == 28 || weapon_id == 18 || weapon_id == 37 || weapon_id == 16 || weapon_id == 9)
	{
		return SendClientMessage(playerid, 0x999999FF, "* Данный id оружия запрещен для выдачи!");
	}

	GiveWeapon(to_player, weapon_id, weapon_ammo);

	static fmt_text[128];

	format(fmt_text, sizeof fmt_text, "Администратор %s[%d] выдал Вам %s и %d патр.", GetPlayerNameEx(playerid), playerid, GetWeaponName(weapon_id), weapon_ammo);
	SendClientMessage(to_player, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "Вы выдали игроку %s[%d] %s и %d патр.", GetPlayerNameEx(to_player), to_player, GetWeaponName(weapon_id), weapon_ammo);
	SendClientMessage(playerid, -1, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] выдал %s[%d] %s [%d патр]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, GetWeaponName(weapon_id), weapon_ammo);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}
	return 1;
}

cmd:templeader(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	if(!strlen(params))
	{
		SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /templeader [id игрока] [организация]");

		SendClientMessage(playerid, 0xCECECEFF, "* 1 - Правительство области");
		SendClientMessage(playerid, 0xCECECEFF, "* 2 - Воинская часть");
		SendClientMessage(playerid, 0xCECECEFF, "* 3 - Городская больница");
		SendClientMessage(playerid, 0xCECECEFF, "* 4 - ТРК «Ритм»");
		SendClientMessage(playerid, 0xCECECEFF, "* 5 - ФСБ");
		SendClientMessage(playerid, 0xCECECEFF, "* 6 - Министерство внутренних дел");
		SendClientMessage(playerid, 0xCECECEFF, "* 7 - Фсин");
		SendClientMessage(playerid, 0xCECECEFF, "* 8 - Русская мафия");
		SendClientMessage(playerid, 0xCECECEFF, "* 9 - Японская мафия");
		SendClientMessage(playerid, 0xCECECEFF, "* 10 - Итальянская мафия");
		return 1;
	}
	extract params -> new to_player, org_id;

	static fmt_msg[144];
	if(GetPlayerTeamEx(to_player) > 0)
	{
		SendClientMessage(to_player, 0xFF6600FF, "* Вы сняли игрока с временное лидерство");
		format(fmt_msg, sizeof fmt_msg, "A: %s [%d] снял игрока с временного лидерство организации \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerTeamName(to_player));
		SendMessageToAdmins(fmt_msg, COLOR_GREY);
		return InvitePlayer(playerid, 0, 0, true);
	}

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!(0 <= org_id <= 10)) return SendClientMessage(playerid, 0x999999FF, "* Неверный идентификатор организации");

	SetPlayerTeamEx(to_player, org_id);
	SetPlayerData(to_player, P_RANG, 10);

	if(!GetPlayerSex(to_player)) SetPlayerData(to_player, P_OSKIN, g_organization[org_id - 1][O_SKINS][9]);
	else SetPlayerData(to_player, P_OSKIN, g_organization[org_id - 1][O_WOMEN_SKIN]);

	SetPlayerColorEx(to_player, team_colors[org_id]);

	ResetSkin(to_player);

	STRING_GLOBAL[0] = EOS;

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "Вы взяли временное лидерство организации \"%s\"", GetPlayerTeamName(to_player));
	SendClientMessage(to_player, 0xCECECEFF, STRING_GLOBAL);

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s [%d] поставил игрока на временное лидерство организации \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerTeamName(to_player));
	SendMessageToAdmins(STRING_GLOBAL, COLOR_GREY);

	return 1;
}

cmd:agivelic(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 5) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	extract params -> new to_player, license; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /agivelic [id игрока] [тип] (1-Базовый уровень 2-Профессиональный уровень 3-На оружие)");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	static fmt_text[144];

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

			format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] %s %s[%d] лицензию на вождение Базового уровня", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_DRIVING_LIC) ? "выдал" : "забрал у", GetPlayerNameEx(to_player), to_player);
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

			format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] %s %s[%d] лицензию на вождение Профессионального уровня", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_DRIVING_LIC) == 2 ? "выдал" : "забрал у", GetPlayerNameEx(to_player), to_player);
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

			format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] %s %s[%d] лицензию на оружие", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_WEAPON_LIC) ? "выдал" : "забрал у", GetPlayerNameEx(to_player), to_player);
			SendMessageToAdmins(fmt_text, 0x999999FF);
		}
		default: return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /agivelic [id игрока] [тип] (1-Базовый уровень 2-Профессиональный уровень 3-На оружие)");
	}
	return 1;
}

cmd:setnakolka(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new to_player, set_code; else return SendClientMessage(playerid, 0xCECECEFF, "* Использование: /setnakolka [id игрока] [id наколки]");
    if(!(0 <= set_code <= 9)) return SendClientMessage(playerid, 0x999999FF, "* Айди наколки: от 0 до 9");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	static query[128];
    SetPlayerData(to_player, P_NAKOLKA, set_code);
	UpdatePlayerDatabaseInt(to_player, "nakolka", set_code);


	format(query, sizeof query, "Администратор %s Вам выдал наколку %s", GetPlayerNameEx(playerid),nakolka_name[set_code]);
	SendClientMessage(to_player, 0x3399FFFF, query);

	format(query, sizeof query, "Вы выдали игроку %s наколку %s", GetPlayerNameEx(to_player),nakolka_name[set_code]);
	SendClientMessage(playerid, 0x66CC00FF, query);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(query, sizeof query, "A: Администратор %s[%d] выдал %s[%d] наколку %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player,nakolka_name[set_code]);
		SendMessageToAdmins(query, 0x999999FF);
	}
	return 1;
}

cmd:setskills(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 5) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	extract params -> new to_player, set_code, set_value; else {

	    SendClientMessage(playerid, 0xCECECEFF, "* Использование: /setskills [id игрока] [навык] [значение]");
	    SendClientMessage(playerid, 0xCECECEFF, "* Коды навыков:");
		SendClientMessage(playerid, 0xCECECEFF, "* 1 - Colt 45");
	    SendClientMessage(playerid, 0xCECECEFF, "* 2 - SD Pistol");
	    SendClientMessage(playerid, 0xCECECEFF, "* 3 - Desert Eagle");
	    SendClientMessage(playerid, 0xCECECEFF, "* 4 - Shotgun");
	    SendClientMessage(playerid, 0xCECECEFF, "* 5 - MP5");
	    SendClientMessage(playerid, 0xCECECEFF, "* 6 - AK47");
	    SendClientMessage(playerid, 0xCECECEFF, "* 7 - M4");
	    SendClientMessage(playerid, 0xCECECEFF, "* 8 - Sniper Rifle");
		SendClientMessage(playerid, 0xCECECEFF, "* 9 - Sawnoff");
		SendClientMessage(playerid, 0xCECECEFF, "* 10 - Combat SG");
		SendClientMessage(playerid, 0xCECECEFF, "* 11 - Micro Uzi");
	    SendClientMessage(playerid, 0x999999FF, "* 12 - Сила");
	    return 1;
	}

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!(0 <= set_value <= 100)) return SendClientMessage(playerid, 0x999999FF, "* Значение навыка от 0 до 100");

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
	    default: return SendClientMessage(playerid, 0x999999FF, "* Неверно введен код навыка");
	}

	SetPlayerSkillsInit(to_player);

	format(query, sizeof query, "Администратор %s изменил Вам уровень навыка %s на %d", GetPlayerNameEx(playerid), tmp_skill_name, set_value);
	SendClientMessage(to_player, 0x3399FFFF, query);

	format(query, sizeof query, "Вы изменили игроку %s уровень навыка %s на %d", GetPlayerNameEx(to_player), tmp_skill_name, set_value);
	SendClientMessage(playerid, 0x66CC00FF, query);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(query, sizeof query, "A: Администратор %s[%d] изменил %s[%d] уровень навыка %s на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, tmp_skill_name, set_value);
		SendMessageToAdmins(query, 0x999999FF);
	}


	return 1;
}

cmd:setvip(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new to_player, premium, days; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setvip [id игрока] [уровень премиум-аккаунта] [время (в днях)]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!(1 <= premium <= 3)) return SendClientMessage(playerid, 0x999999FF, "* Уровень премиум-аккаунта от 1 до 3 (чтобы отобрать, используйте кол-во дней: 0)");

	if(!(0 <= days <= 30)) return SendClientMessage(playerid, 0x999999FF, "* Количество дней от 0 до 30");

	static fmt_msg[100];

	new premium_rank[3][17] =
	{
		"{C0C0C0}Silver",
		"{FFD700}Gold",
		"{E5E4E2}Platinum"
	};

	SetPlayerData(to_player, P_PREMIUM, premium);
	SetPlayerData(to_player, P_PREMIUM_TIME, gettime() + days * 86400);

	UpdatePlayerDatabaseInt(to_player, "premium", premium);
	UpdatePlayerDatabaseInt(to_player, "premium_time", gettime() + days * 86400);

	format(fmt_msg, sizeof fmt_msg, "%s выдал Вам %s {3399FF}премиум-аккаунт на %d дн.", GetPlayerNameEx(playerid), premium_rank[premium - 1], days);
	SendClientMessage(to_player, 0x3399FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы выдали %s %s {3399FF}премиум-аккаунт на %d дн.", GetPlayerNameEx(to_player), premium_rank[premium - 1], days);
	SendClientMessage(playerid, 0x3399FFFF, fmt_msg);


	return 1;
}

cmd:arang(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new to_player, lvl, type; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /arang [id игрока] [уровень] [тип (1 - штатный | 2 - покупной)]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");
	if(!(0 <= lvl <= 12)) return SendClientMessage(playerid, 0xCECECEFF, "* Уровень от 0 до 12");

	if(GetPlayerAdminEx(to_player) >= GetPlayerAdminEx(playerid) && !IsMantoKiss(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя изменить уровень администрирования человека выше или равному вашему статусу.");
	if(lvl >= GetPlayerAdminEx(playerid) && !IsMantoKiss(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя выдать уровень администратора равный или больше вашего");
	if(lvl >= 11 && !IsMantoKiss(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Только IsMantoKiss может выдавать админ уровень 11 и выше.");

	new old_admin = GetPlayerData(to_player, P_ADMIN); 

	SetPlayerData(to_player, P_ADMIN, lvl);
	UpdatePlayerDatabaseInt(to_player, "admin", lvl);

	static fmt_text[128];
	if(lvl > 0)
	{
		if(type == 2) SetPlayerData(to_player, P_BUYADMIN, 1);
		else SetPlayerData(to_player, P_BUYADMIN, 0);

		UpdatePlayerDatabaseInt(to_player, "buyadmin", GetPlayerData(to_player, P_BUYADMIN));

		if(type != 2)
		{
			format(fmt_text, sizeof fmt_text,
				"{FFFFFF}A: %s [%d] выдал права администратора '%d' уровня игроку %s [%d] (был: %d)",
				GetPlayerNameEx(playerid), playerid, lvl,
				GetPlayerNameEx(to_player), to_player, old_admin
			);
		}
		else
		{
			format(fmt_text, sizeof fmt_text,
				"{FFFFFF}A: %s [%d] выдал права покупного администратора '%d' уровня игроку %s [%d] (был: %d)",
				GetPlayerNameEx(playerid), playerid, lvl,
				GetPlayerNameEx(to_player), to_player, old_admin
			);
		}
		SendMessageToAdmins(fmt_text, -1);

		format(fmt_text, sizeof fmt_text, "Поставил %s[%d] на пост администратора %d уровня", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), lvl);
		SendLog(playerid, LOG_TYPE_ADMIN_SETADMIN, fmt_text);

		//Dialog(playerid, DIALOG_ADMIN_CREATE_2, DIALOG_STYLE_PASSWORD,"{FFD83D}Система безопасности","{FFFFFF}Создайте свой личный пароль для авторизации как администратор","Далее", "Закрыть");
	}
	else
	{
		SetPlayerData(to_player, P_BUYADMIN, 0);
		UpdatePlayerDatabaseInt(to_player, "buyadmin", 0);

		format(fmt_text, sizeof fmt_text, "{FFFFFF}A: Администратор %s[%d] снял %s[%d] с администратора", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
		SendMessageToAdmins(fmt_text, -1);

		format(fmt_text, sizeof fmt_text, "{FFFFFF}Снял %s[%d] с поста администратора", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
		SendLog(playerid, LOG_TYPE_ADMIN_SETADMIN, fmt_text);
	}
	return 1;
}


cmd:offarang(playerid, params[]) callcmd::arangoff(playerid, params);
cmd:arangoff(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /arangoff [ник игрока] [уровень]");

	extract params -> new string: name[21], lvl;

	if(!(0 <= lvl <= 8)) return SendClientMessage(playerid, 0xFF6600FF, "* Неверный идентификатор. Уровень от 0 до 8");
	if(lvl >= GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя выдать уровень администратора равный или больше вашего");

	static query[400];
	new Cache: result, user_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows())
		user_id = cache_get_field_content_int(0, "id");

	if(!cache_num_rows() || !user_id)
		return SendClientMessage(playerid, 0xFF6600FF, "* Аккаунт с таким именем не найден"), cache_delete(result);

	static fmt_text[128];

	format(fmt_text, sizeof fmt_text, "A: %s [%d] оффлайн назначил игрока %s администратором %d уровня", GetPlayerNameEx(playerid), playerid, name, lvl);
	SendMessageToAdmins(fmt_text, 0xCECECEFF);

	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET admin=%d WHERE id=%d LIMIT 1", lvl, user_id);
	mysql_query(mysql, query, false);

	return 1;
}

cmd:photo_screen(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 1) return 1;
	extract params -> new criminalid; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /photo_screen [0 - Выключить / 1 - Включить]");

	switch(criminalid)
	{
		case 0:
		{
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "interface('Hud').showTime()");
		}
		case 1:
		{
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "interface('Hud').hideTime()");
		}
	}
	return 1;
}
cmd:events(playerid)
{
    return Sob_OpenRootMenu(playerid);
}
cmd:st(playerid, params[]) return callcmd::settime(playerid, params);
cmd:settime(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 5) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new time; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /settime [время (0-23)]");

	if(!(0 <= time <= 23)) return SendClientMessage(playerid, 0x999999FF, "* Время от 0 до 23 часов");

	SetWorldTime(time);

	static fmt_text[70];

	format(fmt_text, sizeof fmt_text, "Вы установили время %02d:00", time);
	SendClientMessage(playerid, -1, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "A: %s[%d] установил время на сервере на %02d:00", GetPlayerNameEx(playerid), playerid, time);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}
	return 1;
}
cmd:sw(playerid, params[]) return callcmd::setweather(playerid, params);
cmd:setweather(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 5) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new weather; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setweather [погода (0-20)]");

	if(!(-1 <= weather <= 20))
	{
		SendClientMessage(playerid, 0x999999FF, "* Погода от 0 до 20 (-1 - случайная смена погоды)");
		SendClientMessage(playerid, 0x999999FF, "* Рекомендовано: 1, 3, 8, 9, 18");

		return 1;
	}

	if(weather != -1)
		SetWeather(weather);
	else
		SetRandomWeather();

	static fmt_text[70];

	if(weather != -1)
		format(fmt_text, sizeof fmt_text, "Вы установили погоду %d", weather);
	else
		format(fmt_text, sizeof fmt_text, "Вы установили случайную погоду");

	SendClientMessage(playerid, -1, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		if(weather != -1)
			format(fmt_text, sizeof fmt_text, "A: %s[%d] установил погоду на сервере на %d", GetPlayerNameEx(playerid), playerid, weather);
		else
			format(fmt_text, sizeof fmt_text, "A: %s[%d] установил случайную погоду на сервере", GetPlayerNameEx(playerid), playerid);

		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	return 1;
}

cmd:payday(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");


	OnPayDay();

	static fmt_text[50];
	SendClientMessage(playerid, -1, "* Вы включили PayDay");

	format(fmt_text, sizeof fmt_text, "A: %s[%d] инициировал PayDay", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}

cmd:gzcolor(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new gang_id; else return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /gzcolor [id банды] (0-Свободная зона, 1-- Тамбовская ОПГ, 2-- Ростовская ОПГ)");

	if(!(0 <= gang_id <= 3))
		return SendClientMessage(playerid, COLOR_WHITE, "Банды: 0 - Свободная зона, 1 - - Тамбовская, 2 - - Ростовская ОПГ");

	new gang_zone_id = -1;

	for(new idx; idx < g_gang_zones_loaded; idx ++)
	{
		if(!IsPlayerInDynamicArea(playerid, GetGangZoneData(idx, GZ_AREA))) continue;

		gang_zone_id = idx;
		break;
	}

	if(gang_zone_id == -1)
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться на нужной территории");

	SetGangZoneData(gang_zone_id, GZ_GANG, gang_id);
	SaveGangZone(gang_zone_id);

	GangZoneShowForAll(GetGangZoneData(gang_zone_id, GZ_ZONE), gang_zone_colors[ GetGangZoneData(gang_zone_id, GZ_GANG) ]);

	static fmt_text[75];

	SendClientMessage(playerid, -1, "* Вы изменили банду, владеющую данной территорией");

	format(fmt_text, sizeof fmt_text, "A: %s [%d] изменил банду у территории №%d на %d", GetPlayerNameEx(playerid), playerid, gang_zone_id, gang_id);
	SendMessageToAdmins(fmt_text, COLOR_GREY);


	return 1;
}

cmd:sellproperty(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	SellDebtorsProperty();

	static fmt_text[75];

	SendClientMessage(playerid, -1, "* Вы инициировали продажу имущества должников");

	format(fmt_text, sizeof fmt_text, "A: %s[%d] инициировал продажу имущества должников", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}

cmd:sellhotels(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	SellDebtorsHotels();

	static fmt_text[90];

	SendClientMessage(playerid, -1, "* Вы инициировали продажу номеров с задолженностью в отеле");

	format(fmt_text, sizeof fmt_text, "A: %s[%d] инициировал продажу номеров с задолженностью в отеле", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(fmt_text, 0x999999FF);


	return 1;
}

cmd:setprods(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new biz_id, amount; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setprods [id бизнеса] [кол-во]");

	if(!(0 <= amount <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "* Количество продуктов от 0 до 10000");

	if(!(0 <= biz_id <= g_business_loaded - 1))
		return SendClientMessage(playerid, 0x999999FF, "* Данного бизнеса не существует на сервере");

	SetBusinessData(biz_id, B_PRODS, amount);

	static fmt_text[90];

	format(fmt_text, sizeof fmt_text, "UPDATE business SET products=%d WHERE id=%d", GetBusinessData(biz_id, B_PRODS), GetBusinessData(biz_id, B_SQL_ID));
	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы установили %d продуктов в бизнесе №%d", amount, biz_id);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "A: %s[%d] установил %d продуктов в бизнесе №%d", GetPlayerNameEx(playerid), playerid, amount, biz_id);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}

cmd:fullprods(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new amount; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /fullprods [кол-во]");

	if(!(0 <= amount <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "* Количество продуктов от 0 до 10000");

	for(new biz_id; biz_id < g_business_loaded - 1; biz_id ++)
		SetBusinessData(biz_id, B_PRODS, amount);

	static fmt_text[90];

	format(fmt_text, sizeof fmt_text, "UPDATE business SET products=%d", amount);
	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы установили %d продуктов во всех бизнесах", amount);
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "A: %s[%d] установил %d продуктов во всех бизнесах", GetPlayerNameEx(playerid), playerid, amount);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	return 1;
}
cmd:soffban(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /soffban [ник игрока][причина (необязательно)]");

	extract params -> new string: player_name[21], string: reason[30];

	if(IsPlayerConnected(GetPlayerID(player_name))) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем находится на сервере");

	static query[144],
		Cache: result,
		rows,
		uid,
		admin,
		uip[16];

	mysql_format(mysql, query, sizeof query, "SELECT id, admin, last_ip FROM PlayersMorallwens WHERE name='%e'", player_name);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		uid = cache_get_row_int(0, 0);
		admin = cache_get_row_int(0, 1);
		cache_get_row(0, 2, uip);
	}

	cache_delete(result);

	if(!rows || !uid) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	if(GetPlayerAdminEx(playerid) < admin) return SendClientMessage(playerid, 0x999999FF, "* Нельзя забанить администратора выше по рангу");

	mysql_format(mysql, query, sizeof query, "SELECT * FROM ban_list WHERE user_id=%d", uid);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	cache_delete(result);

	if(rows) return SendClientMessage(playerid, 0x999999FF, "* Аккаунт игрока уже заблокирован");
 	format(query, sizeof query, "A: Администратор %s забанил оффлайн навсегда игрока %s", GetPlayerNameEx(playerid), player_name);

	if(strlen(reason) > 0)
		format(query, sizeof query, "%s. Причина: %s", query, reason);

	if(!strlen(reason)) reason = "None";

	SendMessageToAdmins(query, 0x6b6b6bFF);

	format(query, sizeof query, "Оффлайн забанил %s[%d] навсегда. Причина: %s", player_name, uid, reason);
	SendLog(playerid, LOG_TYPE_ADMIN_BAN, query);
	format(reason, sizeof reason, "%s", reason);
	AddBan(uid, gettime(), 999, uip, reason, GetPlayerNameEx(playerid));
	return 1;
}

cmd:deleteaccount(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
	extract params -> new string:name[21], string:reason[30]; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /delacc [имя игрока] [причина]");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	static query[128],
		Cache: result,
		admin,
		rows;
	mysql_format(mysql, query, sizeof query, "SELECT admin FROM PlayersMorallwens WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query, true);


	rows = cache_num_rows();

	if(rows)
	{
		admin = cache_get_row_int(0, 0);

		if(admin && GetPlayerAdminEx(playerid) < 5)
		{
			SendClientMessage(playerid, 0x999999FF, "* Вы не можете удалить аккаунт администратора выше Вас рангом");

			cache_delete(result);

			format(query, sizeof(query), "A: %s попытался удалить аккаунт %s", GetPlayerNameEx(playerid), name);
			SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, query);

			return 1;
		}
		mysql_format(mysql, query, sizeof query, "DELETE FROM PlayersMorallwens WHERE name='%e' LIMIT 1", name);
		mysql_query(mysql, query, false);

		format(query, sizeof query, "Администратор %s удалил аккаунт игрока %s", GetPlayerNameEx(playerid), name);

		if(strlen(reason) > 0)
		{
			static fmt_text[45];

			format(fmt_text, sizeof fmt_text, ". Причина: %s", reason);
			strcat(query, fmt_text);
		}

		SendClientMessageToAll(0xFF99AADD, query);

		format(query, sizeof query, "Удалил аккаунт %s. Причина: %s", name, reason);
		SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, query);
	}
	else SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");
	cache_delete(result);
	return 1;
}

cmd:setskin(playerid, params[]) callcmd::giveskin(playerid, params);
cmd:giveskin(playerid, params[])
{
	if(GetPlayerData(playerid, P_CMD_giveskin) == 0)
	{
		if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

		if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");
	}
	extract params -> new to_player, skin_id; else return SendClientMessage(playerid, 0x999999FF, "* Используйте: /giveskin [id игрока] [скин]");

	if(GetInventorySlots(to_player) == -1) return GameText(playerid, "У игрока в инвентаре нет свободного места", 3000, 0);

	static fmt_text[100];

	format(fmt_text, sizeof fmt_text, "Администратор %s выдал вам %s скин", GetPlayerNameEx(playerid), skin_id != -1 ? "Постоянный" : "Личный");
	SendClientMessage(to_player, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "Вы выдали %s %s скин", GetPlayerNameEx(to_player), skin_id != -1 ? "Постоянный" : "Личный");
	SendClientMessage(playerid, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "Выдал %s[%d] постоянный скин %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), skin_id);
	SendClientMessage(playerid, -1, fmt_text);

	GiveSkin(to_player, skin_id);
	return 1;
}
cmd:skin(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 3 && GetPlayerYAdminEx(playerid) < 2 &&  GetPlayerBuyAdminEx(playerid) < 3) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new to_player, skin_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /skin [id игрока] [id скина]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(skin_id != -1)
		SetPlayerSkin(to_player, skin_id);
	else
		SetPlayerSkin(to_player, GetPlayerSkinEx(to_player));

	static fmt_text[100];

	format(fmt_text, sizeof fmt_text, "Администратор %s выдал Вам %s скин", GetPlayerNameEx(playerid), skin_id != -1 ? "временный" : "прежний");
	SendClientMessage(to_player, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "Вы выдали игроку %s %s скин", GetPlayerNameEx(to_player), skin_id != -1 ? "временный" : "прежний");
	SendClientMessage(playerid, -1, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		if(skin_id != -1)
			format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] выдал %s[%d] временный скин №%d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, skin_id);
		else
			format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] выдал %s[%d] прежний скин", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	return 1;
}

cmd:house(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 3 && GetPlayerBuyAdminEx(playerid) < 3) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	extract params -> new house_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /house [номер дома]");

	if(!(0 <= house_id <= g_house_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного дома не существует на сервере");

	new Float: x,
		Float: y,
		Float: z,
		Float: angle;

	if(GetHouseData(house_id, H_ENTRACE) == -1)
	{
		x = GetHouseData(house_id, H_EXIT_POS_X);
		y = GetHouseData(house_id, H_EXIT_POS_Y);
		z = GetHouseData(house_id, H_EXIT_POS_Z);
		angle = GetHouseData(house_id, H_EXIT_ANGLE);
	}
	SetPlayerPosEx(playerid, x, y, z, angle);

	static fmt_text[35];

	format(fmt_text, sizeof fmt_text, "Вы телепортировались к дому №%d", house_id);
	SendClientMessage(playerid, -1, fmt_text);
	return 1;
}

cmd:biz(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 3 && GetPlayerBuyAdminEx(playerid) < 3) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");
	 
	extract params -> new biz_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /biz [номер бизнеса]");

	if(!(0 <= biz_id <= g_business_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного бизнеса не существует на сервере");

	SetPlayerPosEx
	(
		playerid,
		GetBusinessData(biz_id, B_EXIT_POS_X),
		GetBusinessData(biz_id, B_EXIT_POS_Y),
		GetBusinessData(biz_id, B_EXIT_POS_Z),
		GetBusinessData(biz_id, B_EXIT_ANGLE)
	);

	static fmt_text[48];

	format(fmt_text, sizeof fmt_text, "Вы телепортировались к бизнесу №%d", biz_id);
	SendClientMessage(playerid, -1, fmt_text);

	return 1;
}

cmd:inter(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6 && GetPlayerBuyAdminEx(playerid) < 6) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new to_player, interior; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /inter [id игрока] [интерьер]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	SetPlayerInterior(to_player, interior);

	static fmt_text[110];

	format(fmt_text, sizeof fmt_text, "Вы установили %s[%d] интерьер %d", GetPlayerNameEx(to_player), to_player, interior);
	SendClientMessage(playerid, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s[%d] установил Вам интерьер %d", GetPlayerNameEx(playerid), playerid, interior);
	SendClientMessage(to_player, -1, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] установил %s[%d] интерьер №%d", GetPlayerNameEx(playerid), playerid,
		GetPlayerNameEx(to_player), to_player, interior);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	return 1;
}

cmd:world(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6 && GetPlayerBuyAdminEx(playerid) < 6) return 1;
 			else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	extract params -> new to_player, world; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /world [id игрока] [вирт.мир]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	SetPlayerVirtualWorld(to_player, world);

	static fmt_text[110];

	format(fmt_text, sizeof fmt_text, "Вы установили %s[%d] вирт.мир %d", GetPlayerNameEx(to_player), to_player, world);
	SendClientMessage(playerid, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "%s[%d] установил Вам вирт.мир %d", GetPlayerNameEx(playerid), playerid, world);
	SendClientMessage(to_player, -1, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] установил %s[%d] вирт.мир №%d", GetPlayerNameEx(playerid), playerid,
		GetPlayerNameEx(to_player), to_player, world);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	return 1;
}

cmd:warn(playerid, params[])
{
    if (GetPlayerAdminEx(playerid) < 4) return 1;
    if (admin_logged[playerid] == false) 
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
    if (!strlen(params)) 
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /warn [id игрока] [причина (необязательно)]");
    extract params -> new to_player, string:reason[66];
    if (!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");
    if (GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя выдать предупреждение админу выше по рангу");
    if (g_AdminWarnTimer[playerid] == 0 || (gettime() - g_AdminWarnTick[playerid]) >= 10) {
        g_AdminWarnCount[playerid] = 0; 
        g_AdminWarnTimer[playerid] = gettime();
    }
    g_AdminWarnCount[playerid]++; 
    g_AdminWarnTick[playerid] = gettime();
    if (g_AdminWarnCount[playerid] > 3) {
        SetPlayerData(playerid, P_ADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "admin", 0);
        SetPlayerData(playerid, P_BUYADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "buyadmin", 0);
        return SendClientMessage(playerid, 0xFF0000AA, "{F81414}[Анти-Слив] {F3FF02}Ваша админка была снята за слишком большое количество предупреждений за короткое время!");
    }
    AddPlayerData(to_player, P_WARN, +, 1);
    SetPlayerData(to_player, P_WARN_TIME, gettime() + (86400 * 10)); 
    static fmt_msg[128];
    format(fmt_msg, sizeof fmt_msg, "A: %s выдал предупреждение игроку %s [%d|3]", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), GetPlayerData(to_player, P_WARN));
    if (strlen(reason) > 0)
        format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);
    SendClientMessageToAll(0xFFCD00FF, fmt_msg);
    new uid = GetPlayerAccountID(to_player);
    new warns = GetPlayerData(to_player, P_WARN);
    format(fmt_msg, sizeof fmt_msg, "Выдал варн %s[%d] (%d/3). Причина: %s", GetPlayerNameEx(to_player), uid, warns, reason);
    SendLog(playerid, LOG_TYPE_ADMIN_WARN, fmt_msg);
    if (warns >= 3) {
        SendClientMessage(to_player, 0xFF5533FF, "Аккаунт заблокирован на 10 дней");
        warns = 0;
        SetPlayerData(to_player, P_WARN, 0);
        SetPlayerData(to_player, P_WARN_TIME, 0);
        AddBan(uid, gettime(), 10, GetPlayerIpEx(to_player), "получено 3 варна", GetPlayerNameEx(playerid));
        BanEx(to_player, "получено 3 варна");
    }
    return 1;
}

cmd:unwarn(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 9) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /unwarn [id игрока] [причина (необязательно)]");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new to_player, string: reason[66];
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	SetPlayerData(to_player, P_WARN, 		0);
	SetPlayerData(to_player, P_WARN_TIME, 	0);

	UpdatePlayerDatabaseInt(to_player, "warn", 		0);
	UpdatePlayerDatabaseInt(to_player, "warn_time", 	0);

	static fmt_msg[128];
	format(fmt_msg, sizeof fmt_msg, "A: %s снял все предупреждения с игрока %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));

	if(strlen(reason) > 0)
		format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

	SendClientMessageToAll(0xFFCD00FF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Снял все варны %s[%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_WARN, fmt_msg);

	return 1;
}

cmd:spawn(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerYAdminEx(playerid) < 2) return 1;
	 

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /spawn [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
	return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(GetPlayerYAdminEx(playerid) >= 2) if(to_player != playerid) return SendClientMessage(playerid, 0xCECECEFF, "* Только себе!");

	SpawnPlayer(to_player);
	SetPlayerSpawnPos(to_player);

	static fmt_text[300];

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "A: %s[%d] заспавнил %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
	}
	if(GetPlayerYAdminEx(playerid) >= 2)
	{
		format(fmt_text, sizeof fmt_text, "[Y] %s[%d] заспавнил %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
	}
	return 1;
}

cmd:spcar(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	 

	extract params -> new vehicleid; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /spcar [id авто]");

	if(IsPlayerInAnyVehicle(playerid) && vehicleid == 0) vehicleid = GetPlayerVehicleID(playerid);

	if(!IsValidVehicle(vehicleid)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного транспорта не существует на сервере");

	if(GetVehicleData(vehicleid, V_OWRENT) != 0)
 	{
  		SetVehicleData(vehicleid, V_OWRENT, 0);
    }

	SetVehicleToRespawn(vehicleid);

	static fmt_msg[100];

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_msg, sizeof fmt_msg, "A: Администратор %s[%d] зареспавнил авто [№%d]", GetPlayerNameEx(playerid), playerid, vehicleid);
		SendMessageToAdmins(fmt_msg, 0x999999FF);
	}


	return 1;
}
cmd:tp(playerid)
{                                  
	if(number_mp_player < 1 || mp_status == 2) return SendClientMessage(playerid, 0x808080FF, "В данный момент точки телепорта нету");
    if(GetPlayerData(playerid, P_JAIL) > 0) return SendClientMessage(playerid, 0xFFFFFFAA, "Заключённым нельзя телепортироваться");
	SendClientMessage(playerid, 0x99CC00FF, "[МП] Вы были телепортированы");
	SetPlayerPos(playerid, mpPos[0], mpPos[1], mpPos[2]);
    SetPlayerInterior(playerid, mpWorld[0]);
	SetPlayerVirtualWorld(playerid, mpWorld[1]);
	number_mp_player--;
	SetPVarInt(playerid, "statusMP", 1);                                
	return 1;
}
cmd:gomp(playerid)
{
	if(GetPlayerData(playerid, P_JAIL) > 0) return SCM(playerid, 0xFFFFFFAA, "Заключённым нельзя телепортироваться");
	if(!Teleport)
		return SCM(playerid, 0x40FF00FF, "[Мероприятие]{ffffff} Телепорт на мероприятие закрыт, лимит игроков закончился.");
	SetPlayerArmour(playerid, MPArmour);
	SetPlayerHealthEx(playerid, MPHealth);
    SetPlayerInterior(playerid, TeleportInfoq[1]);
	SetPlayerVirtualWorld(playerid, TeleportInfoq[0]);
	SetPlayerPos(playerid, TeleportFloat[0], TeleportFloat[1], TeleportFloat[2]);
	SCM(playerid, COLOR_LIGHTBLUE, "[Мероприятие] {FFFFFF}Вы телепортированы на мероприятие.");
	MPPlayersLimit --;
	if(!MPPlayersLimit)
	{
	    SCM(playerid, 0x40FF00FF, "[Мероприятие]{ffffff} Телепорт на мероприятие закрыт, лимит игроков закончился.");
		Teleport = 0;
		MPTime = 500;
	}
	if(MPTeleport == 1)
		MPTeleportPlayer{playerid} = true;

	return 1;
}

cmd:mp_tp(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new to_number, tp_status; else return SendClientMessage(playerid, 0x808080FF, "Используйте: /mp_tp [количество участников] [1 (открыть) / 2 (закрыть)]");
	if(!(1 <= to_number <= 500)) return SendClientMessage(playerid, 0x808080FF, "Вы указали не правильное кол-во участников [Min - 1] [Max - 500]");
	if(!(1 <= tp_status <= 2)) return SendClientMessage(playerid, 0x808080FF, "Укажите 1 - для открытия телепорта | 2 - закрытие");
	if(mp_status == tp_status) return SendClientMessage(playerid, 0x808080FF, "Телепорт на мероприятие уже открыт!");
	new stringMP[150];
	switch(tp_status)
	{
		case 1:
		{
			SendClientMessage(playerid, 0x3399FFFF, "* Точка телепорта установлена");
            format(stringMP, sizeof(stringMP), "{FFFFFF}Максимальное Кол-во игроков %d", to_number);
			number_mp_player = to_number;
			mp_status = 1;
			GetPlayerPos(playerid, mpPos[0], mpPos[1], mpPos[2]);
			mpWorld[0] = GetPlayerInterior(playerid);
			mpWorld[1] = GetPlayerVirtualWorld(playerid);
		}
		case 2:
		{
			format(stringMP, sizeof(stringMP), "{FF4500}Точка телепорта удалена");
			for(new i = 0; i < 3; i++) mpPos[i] = 0;
			for(new i = 0; i < 2; i++) mpWorld[i] = 0;
			number_mp_player = 0;
			mp_status = 2;
			foreach(new i: Player) DeletePVar(i, "statusMP");
		}
		default: Kick(playerid);
	}

	SendClientMessage(playerid, -1, stringMP);
	return 1;
}

alias:goto("g");
cmd:goto(playerid, params[])
{
 	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerYAdminEx(playerid) < 1) return 1;

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /goto [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid) && !IsMantoKiss(playerid))
	{
    	SendClientMessage(playerid, 0x66CC33FF, "Вы пытаетесь телепортироваться к администратору Выше рангом, он должен подтвердить Ваше действие");
    	SendPlayerOffer(playerid, to_player, OFFER_TYPE_GOTO);
	}
	else
	{
		new Float: x, Float: y, Float: z, interior, virtual_world;
		GetPlayerPos(to_player, x, y, z);
		interior = GetPlayerInterior(to_player);
		virtual_world = GetPlayerVirtualWorld(to_player);

		SetPlayerPosEx(playerid, x + 1, y + 1, z, 0.0, interior, virtual_world, false);

		SetPlayerInHouse(playerid, GetPlayerInHouse(to_player));
		SetPlayerInBiz(playerid, GetPlayerInBiz(to_player));

		SendClientMessage(playerid, -1, "* Вы были телепортированы");

		static fmt_msg[105];

		if(GetPlayerAdminEx(playerid) <= 5)
		{
			format(fmt_msg, sizeof fmt_msg, "A: Администратор %s[%d] телепортировался к %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
			SendMessageToAdmins(fmt_msg, 0x999999FF);
		}
		else if(GetPlayerYAdminEx(playerid) >= 1)
		{
			format(fmt_msg, sizeof fmt_msg, "[Y] Ютубер %s[%d] телепортировался к %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
			SendMessageToAdmins(fmt_msg, 0x999999FF);
		}
	}
	return 1;
}
cmd:dellmap(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	new name[30];
	if(sscanf(params, "s[30]", name))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /dellmap [название объекта]");

	if(strlen(name) < 1 || strlen(name) > 30)
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /dellmap [название объекта] (1 - 30)");

	if(GetString(name, "None"))
		return 0;

	new
		obj_id = -1;
	for(new i; i < TOTALOBJECTS; i++)
	{
		if(GetString(ObjInfo[i][objName], name))
		{
			obj_id = i;
			break;
		}
	}

	if(obj_id == -1)
		return SendClientMessage(playerid, COLOR_GREY, "* Объект под данным именем не найден");

	static const
		fmt_str[] = "Вы успешно удалили объект под именем \"%s\"",
		mysql_str[] = "DELETE FROM `create_objects` WHERE `Name` = '%s'";
	new str[sizeof(mysql_str) + (-4 + 52)];

	format(str, sizeof(str), fmt_str, name);
	SendClientMessage(playerid, 0xCECECEFF, str);

	format(str, sizeof(str), mysql_str, name);
	mysql_query(mysql, str, false);

	DestroyDynamicObject(ObjInfo[obj_id][objID]);
	SetString(ObjInfo[obj_id][objName], "None");
	return 1;
}
cmd:editmap(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	new name[30];
	if(sscanf(params, "s[30]", name))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /editmap [название объекта]");

	if(strlen(name) < 1 || strlen(name) > 30)
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /editmap [название объекта] (1 - 30)");

	new
		obj_id = -1;
	for(new i; i < TOTALOBJECTS; i++)
	{
		if(GetString(ObjInfo[i][objName], name))
		{
			obj_id = i;
			break;
		}
	}

	if(obj_id == -1)
		return SendClientMessage(playerid, COLOR_GREY, "* Объект под данным именем не найден.");

	return 1;
}

cmd:map(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");


	new model,
	    name[30];
	if(sscanf(params, "is[30]", model, name))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /map [ID объекта] [название]");

	if(strlen(name) < 1 || strlen(name) > 30)
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /map [ID объекта] [название] (1 - 30)");
    //SendClientMessage(playerid, COLOR_GREY, "* 0");
	if(GetString(name, "None"))
		return 0;
  	//SendClientMessage(playerid, COLOR_GREY, "* 1");
	if(TOTALOBJECTS + 1 > MAX_CREATE_OBJECTS)
		return SendClientMessage(playerid, COLOR_GREY, "* Превышен лимит созданных объектов");
 	//SendClientMessage(playerid, COLOR_GREY, "* 2");

	static const mysql_str[] = "SELECT * FROM `create_objects` WHERE `Name` = '%s'";
	new str[sizeof(mysql_str) + (-2 + 30)];
 	//SendClientMessage(playerid, COLOR_GREY, "* 3");

	format(str, sizeof(str), mysql_str, name);
	mysql_query(mysql, str);
 	//SendClientMessage(playerid, COLOR_GREY, "* 4");
	if(cache_num_rows())
		return SendClientMessage(playerid, COLOR_GREY, "* Данное название объекта уже используется!");
  	//SendClientMessage(playerid, COLOR_GREY, "* 5");
	new
		Float:x,
		Float:y,
		Float:z;
	GetPlayerPos(playerid, x, y, z);
 	
	EditObjectPlayer[playerid] = CreateObject(model, x+2, y+2, z, 0, 0, 0);

	EditObject(playerid, EditObjectPlayer[playerid]);


	SetString(ObjectNamePlayer[playerid], name);
	SetPVarInt(playerid, "obj_edit", 1);
	SetPVarInt(playerid, "obj_model", model);

	return 1;
}
cmd:getcar(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerBuyAdminEx(playerid) < 2) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	  
	extract params -> new vehicleid; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /getcar [id транспорта]");
	if(!IsValidVehicle(vehicleid)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного транспорта не существует на сервере");

	new Float: x, Float: y, Float: z;
	GetPlayerPos(playerid, x, y, z);

	SetVehiclePos(vehicleid, x + 2.0, y + 2.0, z);

	SendClientMessage(playerid, -1, "* Вы телепортировали авто к себе");

	static fmt_msg[105];

	format(fmt_msg, sizeof fmt_msg, "A: %s [%d] телепортировал к себе транспорт: №%d", GetPlayerNameEx(playerid), playerid, vehicleid);
	SendMessageToAdmins(fmt_msg, COLOR_GREY);

	return 1;
}
cmd:getp(playerid, params[]) return callcmd::gethere(playerid, params);
cmd:getplayer(playerid, params[]) return callcmd::gethere(playerid, params);
cmd:gh(playerid, params[]) return callcmd::gethere(playerid, params);
cmd:gethere(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3 && GetPlayerYAdminEx(playerid) < 2) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");


	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /gethere [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

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

		static fmt_msg[105];
		format(fmt_msg, sizeof fmt_msg, "Администратор %s телепортивал Вас к себе", GetPlayerNameEx(playerid));
		SendClientMessage(to_player, -1, fmt_msg);

		format(fmt_msg, sizeof fmt_msg, "Вы телепортивали %s к себе", GetPlayerNameEx(to_player));
		SendClientMessage(playerid, -1, fmt_msg);

		if(GetPlayerAdminEx(playerid) <= 5)
		{
			format(fmt_msg, sizeof fmt_msg, "A: Администратор %s[%d] телепортировал к себе %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
			SendMessageToAdmins(fmt_msg, 0x999999FF);
		}
	}

	return 1;
}

cmd:setfuel(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerBuyAdminEx(playerid) < 2) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");


	extract params -> new vehicleid, fuel; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setfuel [id транспорта] [кол-во топлива]");

	if(!IsValidVehicle(vehicleid)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного транспорта не существует на сервере");

	if(!(0 <= fuel <= 100)) return SendClientMessage(playerid, 0x999999FF, "* Количество топлива от 0 до 100");

	SetVehicleData(vehicleid, V_FUEL, fuel);

	static fmt_text[80];

	format(fmt_text, sizeof fmt_text, "Вы установили %d топлива в ТС №%d", fuel, vehicleid);
	SendClientMessage(playerid, -1, fmt_text);

	if(GetPlayerAdminEx(playerid) >= 5)
	{
		format(fmt_text, sizeof fmt_text, "A: %s[%d] установил %d топлива в ТС №%d", GetPlayerNameEx(playerid), playerid, fuel, vehicleid);
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}

	return 1;
}

cmd:getv(to_player, params[])
{
    if (GetPlayerSkin(to_player) == 50)
    {
        SCM(to_player, COLOR_RED, "Вы не можете этим пользоваться, так как вы недавно совершили побег.");
        return 0; 
    }
    page_cars[to_player] = 1;
    type_page_cars[to_player] = 4;
    SetPVarInt(to_player, "to_player", to_player);
    ShowOwnableCars(to_player, DIALOG_OWNABLE_CAR_SELECT, page_cars[to_player]);
    return 1;
}

cmd:afc(playerid, params[])
{
	if(GetPlayerData(playerid, P_CMD_fixcar) == 0)
	{
    	if(GetPlayerAdminEx(playerid) < 1 && GetPlayerYAdminEx(playerid) < 1) return SCM(playerid, COLOR_GREY, "* Используйте рем.комплект в инвентаре");

	}

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /fixcar [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!IsPlayerInAnyVehicle(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок должен находиться в транспорте");

	static fmt_text[93],
		vehicleid = GetPlayerVehicleID(to_player);

	RepairVehicle(vehicleid);
	if(IsAOwnableCar(vehicleid)) SetVehicleData(vehicleid, V_HEALTH, 1000.0);

	format(fmt_text, sizeof fmt_text, "Вы починили транспорт: №%d", vehicleid);
	SendClientMessage(playerid, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "Администратор %s починил Ваш транспорт", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, -1, fmt_text);

	format(fmt_text, sizeof fmt_text, "A: %s[%d] починил транспорт игрока %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
	SendMessageToAdmins(fmt_text, 0x999999FF);
	return 1;
}
cmd:kick(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 2 && !IsMantoKiss(playerid)) return 1;
    if(Test_server == 1) return SCM(playerid, -1, "* На данный момент сервер находится в Техническом режиме, подобные команды отключены");
    if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
    if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /kick [id игрока] [причина (необязательно)]");
    extract params -> new to_player;
    if(!IsPlayerConnected(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");
	if(IsMantoKiss(to_player))
	{
    SendClientMessage(playerid, 0x999999FF, "* Вы не можете кикнуть этого игрока.");
    SendClientMessage(playerid, 0x999999FF, "* За использование данной команды в личных целях вы будете сняты!");
    return 1;
	}
    else if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя кикнуть администратора выше по рангу");
    if (g_AdminKickTimer[playerid] == 0 || (gettime() - g_AdminKickedTick[playerid]) >= 10) {
        g_AdminKickCount[playerid] = 0; 
        g_AdminKickTimer[playerid] = gettime();
    }
    g_AdminKickCount[playerid]++; 
    g_AdminKickedTick[playerid] = gettime(); 
    if (g_AdminKickCount[playerid] > 3) {
        SetPlayerData(playerid, P_ADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "admin", 0);
		SetPlayerData(playerid, P_BUYADMIN, 0);
		UpdatePlayerDatabaseInt(playerid, "buyadmin", 0);	
        return SendClientMessage(playerid, 0xFFCD00FF, "{F81414}[Анти-Слив] {F3FF02}Ваша админка была снята за слишком большое количество киков за короткое время!");
    }
    static reason[31];
    sscanf(params, "{d}s[30]", reason);
    static fmt_msg[128];
    format(fmt_msg, sizeof fmt_msg, "A: %s кикнул игрока %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
    AddPlayerData(playerid, P_ADMKICK, +, 1);
    UpdatePlayerDatabaseInt(playerid, "admkick", GetPlayerData(playerid, P_ADMKICK));
    if(strlen(reason) > 0)
        format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);
    SendClientMessageToAll(0xFFCD00FF, fmt_msg);
    format(fmt_msg, sizeof fmt_msg, "Кикнул %s[%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
    SendLog(playerid, LOG_TYPE_ADMIN_KICK, fmt_msg);
	new message[324];
	new	year, month, day;
	getdate(year, month, day);
	format
	(
	    message,
	    sizeof(message),
	    "Дата: %i %s %i г.\n\
		Ваш ник: %s\n\
	    Ник администратора: %s\n\
	    Причина: %s\n\n\
	    Если Вы не согласны с наказанием, сделайте скриншот (F8)\n\
	    И оставьте жалобу на форуме\n\
	    ",
   		day,
		GetMonthName(month),
		year,
		GetPlayerNameEx(to_player),
		GetPlayerNameEx(playerid),
		reason
	);
	Dialog(to_player, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF6600}Отключение от сервера", message, "Закрыть", "");
    Kick(to_player);
    return 1;
}
cmd:window(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

    extract params -> new type; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: {ffffff} /window [тип] < Типы: 1 - водительское | 2 - пассажирское (спереди) | 3 - заднее (левое) | 4 - заднее (правое) >");

    new vehicleid = GetPlayerVehicleID(playerid),
        driver,
        passenger,
        backleft,
        backright;

    GetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, backright);

    switch(type)
    {
        case 1: driver = !driver ? (1) : (0);
        case 2: passenger = !passenger ? (1) : (0);
        case 3: backleft = !backleft ? (1) : (0);
        case 4: backright = !backright ? (1) : (0);
    }

    SetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, backright);

    return 1;
}

cmd:skick(playerid, params[])
{
	if(Test_server == 1) return SCM(playerid, -1, "* На данный момент сервер находится в Техническом режиме, подобные команды отключены");

	if(GetPlayerAdminEx(playerid) < 5) return 1;
		 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /skick [id игрока]");

	if(!IsPlayerConnected(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");
	if(IsMantoKiss(to_player))
	{
    SendClientMessage(playerid, 0x999999FF, "* Вы не можете кикнуть этого игрока.");
    SendClientMessage(playerid, 0x999999FF, "* За использование данной команды в личных целях вы будете сняты!");
    return 1;
	}
	else if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя кикнуть администратора выше по рангу");

	static fmt_msg[128];

	if(GetPlayerAdminEx(playerid) < 6)
	{
		format(fmt_msg, sizeof fmt_msg, "A: Администратор %s[%d] кикнул %s[%d] без лишнего шума", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
		SendMessageToAdmins(fmt_msg, 0x999999FF);
	}

	format(fmt_msg, sizeof fmt_msg, "Без шума кикнул %s[%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_KICK, fmt_msg);

	Kick(to_player);
	return 1;
}
cmd:mute(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
	if(Test_server == 1) return SCM(playerid, -1, "* На данный момент сервер находится в Техническом режиме, подобные команды отключены");
 			else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
 
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /mute [id игрока] [время в минутах] [причина (необязательно)]");

	extract params -> new to_player, mute_time, string: reason[30];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(!(1 <= mute_time <= 5760)) return SendClientMessage(playerid, 0xCECECEFF, "* Время должно быть не меньше 1 и не больше 5760 минут");
	if(GetPlayerData(to_player, P_MUTE) > 0) return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока уже есть мут");
	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя поставить затычку администратору выше по рангу");

	static fmt_msg[128];
	format(fmt_msg, sizeof fmt_msg, "A: %s поставил затычку игроку %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), mute_time);
	
	AddPlayerData(playerid, P_ADMMUTE, +, 1);
	UpdatePlayerDatabaseInt(playerid, "admmute", GetPlayerData(playerid, P_ADMMUTE));

	if(strlen(reason))
		format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

	SendClientMessageToAll(0xFFCD00FF, fmt_msg);

	SetPlayerData(to_player, P_MUTE, mute_time * 60);
	UpdatePlayerDatabaseInt(to_player, "mute", mute_time * 60);

	SendClientMessage(to_player, 0xCECECEFF, "* Время до окончания бана чата: {CCCC00}/time");

	format(fmt_msg, sizeof fmt_msg, "Выдал %s[%d] блокировку чата на %d мин. Причина: %s",
	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), mute_time, reason);
	SendLog(playerid, LOG_TYPE_ADMIN_MUTE, fmt_msg);
	return 1;
}
cmd:unmute(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 2) return 1;
  			else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
     

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /unmute [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	else if(GetPlayerData(to_player, P_MUTE) <= 0) return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока нет мута");
	//else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя снять затычку с самого себя");

	static fmt_msg[80];
	format(fmt_msg, sizeof fmt_msg, "A: %s снял затычку с игрока %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendClientMessageToAll(0xFFCD00FF, fmt_msg);

	SetPlayerData(to_player, P_MUTE, 0);
	UpdatePlayerDatabaseInt(to_player, "mute", 0);

	SendClientMessage(to_player, 0x66CC00FF, "Доступ в чат восстановлен");

	format(fmt_msg, sizeof fmt_msg, "Снял блокировку чата у %s[%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_MUTE, fmt_msg);
	return 1;
}

cmd:mutevoice(playerid, params[])
{
	if(Test_server == 1) return SCM(playerid, -1, "* На данный момент сервер находится в Техническом режиме, подобные команды отключены");
	if(GetPlayerAdminEx(playerid) < 4) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new to_player, string:reason[30]; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /mutevoice [id игрока] [причина]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");
	static fmt_msg[128];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s[%d] заблокировал войс игрока %s[%d] Причина:%s", GetPlayerNameEx(playerid),playerid, GetPlayerNameEx(to_player),to_player,reason);
	SendClientMessageToAll(COLOR_RED, fmt_msg);
	return 1;
}
cmd:unmutevoice(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /unmutevoice [id игрока]");

	extract params -> new string:ip[16];
	static query[128];
    format(query, sizeof query, "A: Администратор %s[%d] разблокировал voice игроку %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player),to_player);
	SendClientMessageToAll(COLOR_RED, query);
	return 1;
}
cmd:jaillist(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerBuyAdminEx(playerid) < 2) return 1;
 			else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	static query[115],
		Cache: result,
		rows,
		name[21],
		jail,
		list[sizeof query * 25 + 60] = "   Ник - Время - Причина\n";


	mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE jail > 0 ORDER BY jail DESC");
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	for(new i; i < rows; i ++)
	{
		jail = cache_get_field_content_int(i, "jail");

		cache_get_field_content(i, "name", name);

		format
		(
			query, sizeof query,
			"\n%s - %d мин.",
			name,
			jail / 60
		);

		strcat(list, query);
	}

	cache_delete(result);

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Игроки в деморгане", list, "Закрыть", "");

	return 1;
}

cmd:unturma(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) == TEAM_MAFIA_JAPAN || GetPlayerTeamEx(playerid) == TEAM_MAFIA_RUSSIAN || GetPlayerTeamEx(playerid) == TEAM_MAFIA_ITALIAN)
	{
		extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /unturma [id игрока]");

		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
			return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

		else if(GetPlayerData(to_player, P_TURMA) <= 0) return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок не сидит в подвале");

		UnturmaPlayer(to_player);
	}

	return 1;
}
cmd:jail(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /jail [id игрока] [время в минутах] [причина (необязательно)]");
	extract params -> new to_player, jail_time, string: reason[30];
    if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя выдать джайл админу выше по рангу");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");
	if(!(5 <= jail_time <= 2000)) return SendClientMessage(playerid, 0xCECECEFF, "* Время должно быть не меньше 5 и не больше 2000 минут");
	if(GetPlayerData(to_player, P_JAIL) > 0) return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок уже сидит в тюрьме");
	static fmt_msg[128];
	format(fmt_msg, sizeof fmt_msg, "A: %s посадил в Тюрьму игрока %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), jail_time);
	if(strlen(reason))
		format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);
	SendClientMessageToAll(0xFFCD00FF, fmt_msg);
	SendClientMessage(to_player, 0xCECECEFF, "* Время до окончания заключения: {CCCC00}/time");
	JailPlayer(to_player, jail_time);
	return 1;
}

cmd:unjail(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /unjail [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	else if(GetPlayerData(to_player, P_JAIL) <= 0) return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок не сидит в тюрьме");
	//else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя снять затычку с самого себя");

	static fmt_msg[80];
	format(fmt_msg, sizeof fmt_msg, "A: %s выпустил из тюрьмы игрока %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
	SendClientMessageToAll(0xFFCD00FF, fmt_msg);

	SendClientMessage(to_player, 0x66CC00FF, "Вы были выпущены на свободу");

	UnjailPlayer(to_player);

	format(fmt_msg, sizeof fmt_msg, "Выпустил из тюрьмы %s[%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
	SendLog(playerid, LOG_TYPE_ADMIN_JAIL, fmt_msg);

	return 1;
}

cmd:ban(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 4 && !IsMantoKiss(playerid)) return 1;
	if(Test_server == 1) return SCM(playerid, -1, "* На данный момент сервер находится в Техническом режиме, подобные команды отключены");
    if (admin_logged[playerid] == false) 
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
    if (!strlen(params)) 
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /ban [id игрока] [срок в днях] [причина (необязательно)]");
    extract params -> new to_player, ban_time, string:reason[30];
    if (!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");
	if(IsMantoKiss(to_player))
	{
    SendClientMessage(playerid, 0x999999FF, "* Вы не можете забанить этого игрока.");
    SendClientMessage(playerid, 0x999999FF, "* За использование данной команды в личных целях вы будете сняты!");
    return 1;
	}
    new max_days = GetPlayerAdminEx(playerid) > 4 ? 365 : 30;
    static fmt_msg[128];
    if (!(1 <= ban_time <= max_days)) {
        format(fmt_msg, sizeof fmt_msg, "Срок бана может быть от 1 до %d дней", max_days);
        return SendClientMessage(playerid, 0xCECECEFF, fmt_msg);
    }
    if (GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя забанить администратора выше по рангу");
    if (g_AdminBanTimer[playerid] == 0 || (gettime() - g_AdminBannedTick[playerid]) >= 10) {
        g_AdminBanCount[playerid] = 0;
        g_AdminBanTimer[playerid] = gettime();
    }
    g_AdminBanCount[playerid]++;
    g_AdminBannedTick[playerid] = gettime();
    if (g_AdminBanCount[playerid] > 3) {
        SetPlayerData(playerid, P_ADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "admin", 0);
        SetPlayerData(playerid, P_BUYADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "buyadmin", 0);		
        return SendClientMessage(playerid, 0xFFCD00FF, "{F81414}[Анти-Слив] {FFFFFF}Ваша админка была снята за слишком большое количество банов за короткое время!");
    }
    format(fmt_msg, sizeof fmt_msg, "A: %s забанил игрока %s на %d дней", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), ban_time);
    if (strlen(reason) > 0)
        format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);
    SendClientMessageToAll(0xFFCD00FF, fmt_msg);
    if (!strlen(reason)) reason = "None";
    format(fmt_msg, sizeof fmt_msg, "Забанил %s[%d] на %d дней. Причина: %s", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), reason);
    SendLog(playerid, LOG_TYPE_ADMIN_BAN, fmt_msg);
    SetPlayerData(to_player, P_ADMIN, 0);
    SetPlayerData(to_player, P_MIND, 0);
    UpdatePlayerDatabaseInt(to_player, "admin", 0);
    UpdatePlayerDatabaseInt(to_player, "mind", 0);
    UpdatePlayerDatabaseInt(to_player, "full", 0);
    UpdatePlayerDatabaseInt(to_player, "givefull", 0);
    AddBan(GetPlayerAccountID(to_player), gettime(), ban_time, GetPlayerIpEx(to_player), reason, GetPlayerNameEx(playerid));
    Kick(to_player);
    return 1;
}

cmd:fakeban(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 4 && !IsMantoKiss(playerid)) return 1;
	if(Test_server == 1) return SCM(playerid, -1, "* На данный момент сервер находится в Техническом режиме, подобные команды отключены");
    if (admin_logged[playerid] == false) 
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
    if (!strlen(params)) 
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /fakeban [id игрока] [срок в днях] [причина (необязательно)]");
    extract params -> new to_player, ban_time, string:reason[30];
    if (!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");
	if(IsMantoKiss(to_player))
	{
    SendClientMessage(playerid, 0x999999FF, "* Вы не можете забанить этого игрока.");
    SendClientMessage(playerid, 0x999999FF, "* За использование данной команды в личных целях вы будете сняты!");
    return 1;
	}
    new max_days = GetPlayerAdminEx(playerid) > 4 ? 365 : 30;
    static fmt_msg[128];
    if (!(1 <= ban_time <= max_days)) {
        format(fmt_msg, sizeof fmt_msg, "Срок бана может быть от 1 до %d дней", max_days);
        return SendClientMessage(playerid, 0xCECECEFF, fmt_msg);
    }
    if (GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя забанить администратора выше по рангу");
    format(fmt_msg, sizeof fmt_msg, "A: %s забанил игрока %s на %d дней", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), ban_time);
    if (strlen(reason) > 0)
        format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);
    SendClientMessageToAll(0xFFCD00FF, fmt_msg);
    if (!strlen(reason)) reason = "None";
    format(fmt_msg, sizeof fmt_msg, "Забанил %s[%d] на %d дней. Причина: %s", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), reason);
    Kick(to_player);
    return 1;
}

cmd:unbanip(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /unbanip [ip]");

	extract params -> new string:ip[16];

	static query[140];
	format(query, sizeof query, "DELETE FROM banip_list WHERE ip='%s'", ip);
	mysql_query(mysql, query, false);

    format(query, sizeof query, "A: Администратор %s[%d] разблокировал IP адрес %s", GetPlayerNameEx(playerid), playerid, params);
	SendMessageToAdmins(query, 0x3399FFFF);

	return 1;
}

cmd:banip(playerid, params[])
{
    if (GetPlayerAdminEx(playerid) < 6)
        return 1;
    if (admin_logged[playerid] == false) 
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
    if (GetPlayerData(playerid, P_BUYADMIN) == 1) 
        return SendClientMessage(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");
    if (!strlen(params)) 
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /banip [ip] [причина (необязательно)]");
	if(IsMantoKiss(playerid))
	{
    SendClientMessage(playerid, 0x999999FF, "* Вы не можете забанить этого игрока.");
    SendClientMessage(playerid, 0x999999FF, "* За использование данной команды в личных целях вы будете сняты!");
    return 1;
	}
    extract params -> new string:ip[16], string:reason[32];
    if (g_AdminBanIpTimer[playerid] == 0 || (gettime() - g_AdminBannedIpTick[playerid]) >= 10) {
        g_AdminBanIpCount[playerid] = 0; 
        g_AdminBanIpTimer[playerid] = gettime();
    }
    g_AdminBanIpCount[playerid]++; 
    g_AdminBannedIpTick[playerid] = gettime(); 
    if (g_AdminBanIpCount[playerid] > 3) {
        SetPlayerData(playerid, P_ADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "admin", 0);
        SetPlayerData(playerid, P_BUYADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "buyadmin", 0);
        return SendClientMessage(playerid, 0xFF0000AA, "Ваша админка была снята за слишком большое количество банов по IP за короткое время!");
    }
    static query[148];
    mysql_format(mysql, query, sizeof query, "INSERT INTO banip_list (time,ip,description,admin) VALUES (NOW(),'%e','%e','%e')", ip, reason, GetPlayerNameEx(playerid));
    mysql_query(mysql, query, false);
    if (strlen(reason) > 0) 
        format(query, sizeof query, "Причина: %s", reason);
    format(query, sizeof query, "A: %s[%d] заблокировал IP адрес %s навсегда %s", GetPlayerNameEx(playerid), playerid, ip, query);
    SendMessageToAdmins(query, 0xFFCD00FF);
    return true;
}

cmd:unban(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 10) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new string: player_name[21];

	if(!strlen(player_name)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /unban [ник игрока]");

	static query[80],
		Cache: result,
		rows,
		uid,
		uip[16];

	mysql_format(mysql, query, sizeof query, "SELECT id, last_ip FROM PlayersMorallwens WHERE name='%e'", player_name);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		uid = cache_get_row_int(0, 0);
		cache_get_row(0, 1, uip);
	}

	cache_delete(result);

	if(!rows || !uid) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	mysql_format(mysql, query, sizeof query, "SELECT * FROM ban_list WHERE user_id=%d", uid);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	cache_delete(result);

	if(!rows) return SendClientMessage(playerid, 0x999999FF, "* Аккаунт игрока не заблокирован");

	mysql_format(mysql, query, sizeof query, "DELETE FROM ban_list WHERE user_id=%d", uid);
	mysql_query(mysql, query, false);

	format(query, sizeof query, "A: %s разбанил игрока %s", GetPlayerNameEx(playerid), player_name);

	SendMessageToAdmins(query, 0xFFCD00FF);

	format(query, sizeof query, "Разбанил %s[%d]", player_name, uid);
	SendLog(playerid, LOG_TYPE_ADMIN_BAN, query);

	return 1;
}

cmd:offban(playerid, params[])
{
    if (GetPlayerAdminEx(playerid) < 5) 
        return 1;
    else if (admin_logged[playerid] == false) 
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
    if (!strlen(params)) 
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /offban [ник игрока] [кол-во дней] [причина (необязательно)]");
    extract params -> new string: player_name[21], days, string: reason[30];
    if (!(-1 <= days <= 365)) 
        return SendClientMessage(playerid, 0x999999FF, "* Количество дней от 1 до 365");
    if (days == 0) 
        return SendClientMessage(playerid, 0x999999FF, "* Количество дней от 1 до 365");
    if (days == -1 && GetPlayerAdminEx(playerid) < 5) 
        return SendClientMessage(playerid, 0x999999FF, "* Количество дней от 1 до 365");
    if (IsPlayerConnected(GetPlayerID(player_name))) 
        return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем находится на сервере");
    static query[144],
        Cache: result,
        rows,
        uid,
        admin,
        uip[16];
    mysql_format(mysql, query, sizeof query, "SELECT id, admin, last_ip FROM PlayersMorallwens WHERE name='%e'", player_name);
    result = mysql_query(mysql, query, true);
    rows = cache_num_rows();
    if (rows)
    {
        uid = cache_get_row_int(0, 0);
        admin = cache_get_row_int(0, 1);
        cache_get_row(0, 2, uip);
    }
    cache_delete(result);
    if (!rows || !uid) 
        return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");
    if (GetPlayerAdminEx(playerid) < admin) 
        return SendClientMessage(playerid, 0x999999FF, "* Нельзя забанить администратора выше по рангу");
    mysql_format(mysql, query, sizeof query, "SELECT * FROM ban_list WHERE user_id=%d", uid);
    result = mysql_query(mysql, query, true);
    rows = cache_num_rows();
    cache_delete(result);
    if (rows) 
        return SendClientMessage(playerid, 0x999999FF, "* Аккаунт игрока уже заблокирован");
    if (g_AdminOffBanTimer[playerid] == 0 || (gettime() - g_AdminOffBannedTick[playerid]) >= 10) {
        g_AdminOffBanCount[playerid] = 0; 
        g_AdminOffBanTimer[playerid] = gettime();
    }
    g_AdminOffBanCount[playerid]++; 
    g_AdminOffBannedTick[playerid] = gettime(); 
    if (g_AdminOffBanCount[playerid] > 3) {
        SetPlayerData(playerid, P_ADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "admin", 0);
        SetPlayerData(playerid, P_BUYADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "buyadmin", 0);
        return SendClientMessage(playerid, 0xFF0000AA, "{F81414}[Анти-Слив] {F3FF02}Ваша админка была снята за слишком большое количество банов за короткое время!");
    }
    if (days != -1) 
    {
        format(query, sizeof query, "A: %s забанил оффлайн игрока %s на %d дней", GetPlayerNameEx(playerid), player_name, days);
        if (strlen(reason) > 0)
            format(query, sizeof query, "%s. Причина: %s", query, reason);
        if (!strlen(reason)) reason = "None";
        SendClientMessageToAll(0xFFCD00FF, query);
        format(query, sizeof query, "Оффлайн забанил %s[%d] на %d дней. Причина: %s", player_name, uid, days, reason);
        SendLog(playerid, LOG_TYPE_ADMIN_BAN, query);
        format(reason, sizeof reason, "[OFFLINE]%s", reason);
        AddBan(uid, gettime(), days, uip, reason, GetPlayerNameEx(playerid));
    }
    if (days == -1) 
    {
        format(query, sizeof query, "A: %s забанил оффлайн навсегда игрока %s", GetPlayerNameEx(playerid), player_name);
        if (strlen(reason) > 0)
            format(query, sizeof query, "%s. Причина: %s", query, reason);
        if (!strlen(reason)) reason = "None";
        SendClientMessageToAll(0xFF0000AA, query);
        format(query, sizeof query, "Оффлайн забанил %s[%d] навсегда. Причина: %s", player_name, uid, reason);
        SendLog(playerid, LOG_TYPE_ADMIN_BAN, query);
        format(reason, sizeof reason, "%s", reason);
        AddBan(uid, gettime(), 999, uip, reason, GetPlayerNameEx(playerid));
    }
    return 1;
}

cmd:offwarn(playerid, params[])
{
    if (GetPlayerAdminEx(playerid) < 4) return 1;
    if (admin_logged[playerid] == false)
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
    if (!strlen(params))
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /offwarn [ник игрока] [причина (необязательно)]");
    extract params -> new string: player_name[21], string: reason[30];
    if (IsPlayerConnected(GetPlayerID(player_name)))
        return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем находится на сервере");
    static query[144],
        Cache: result,
        rows,
        uid,
        admin,
        uip[16],
        warn,
        warn_time;
    mysql_format(mysql, query, sizeof query, "SELECT id, admin, last_ip, warn, warn_time FROM PlayersMorallwens WHERE name='%e'", player_name);
    result = mysql_query(mysql, query, true);
    rows = cache_num_rows();
    if (rows)
    {
        uid = cache_get_row_int(0, 0);
        admin = cache_get_row_int(0, 1);
        cache_get_row(0, 2, uip);
        warn = cache_get_row_int(0, 3);
        warn_time = cache_get_row_int(0, 4);
    }
    cache_delete(result);
    if (!rows || !uid) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");
    if (GetPlayerAdminEx(playerid) < admin) 
        return SendClientMessage(playerid, 0x999999FF, "* Нельзя дать варн администратору выше по рангу");
    mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE id=%d", uid);
    result = mysql_query(mysql, query, true);
    rows = cache_num_rows();
    cache_delete(result);
    if (!rows) return SendClientMessage(playerid, 0x999999FF, "* Аккаунт не найден");
    mysql_format(mysql, query, sizeof query, "SELECT * FROM ban_list WHERE user_id=%d", uid);
    result = mysql_query(mysql, query, true);
    rows = cache_num_rows();
    cache_delete(result);
    if (rows) return SendClientMessage(playerid, 0x999999FF, "* Аккаунт игрока находится в бане.");
    if (g_AdminWarningTimer[playerid] == 0 || (gettime() - g_AdminWarnedTick[playerid]) >= 10) {
        g_AdminWarningCount[playerid] = 0; 
        g_AdminWarningTimer[playerid] = gettime();
    }
    g_AdminWarningCount[playerid]++; 
    g_AdminWarnedTick[playerid] = gettime(); 
    if (g_AdminWarningCount[playerid] > 3) {
        SetPlayerData(playerid, P_ADMIN, 0);
        UpdatePlayerDatabaseInt(playerid, "admin", 0);   
		SetPlayerData(playerid, P_BUYADMIN, 0);
		UpdatePlayerDatabaseInt(playerid, "buyadmin", 0);		
        return SendClientMessage(playerid, 0xFF0000AA, "{F81414}[Анти-Слив] {F3FF02}Ваша админка была снята за слишком большое количество предупреждений за короткое время!");
    }
    warn++;
    format(query, sizeof query, "A: %s оффлайн выдал предупреждение игроку %s [%d|3] ", GetPlayerNameEx(playerid), player_name, warn);
    if (strlen(reason) > 0)
        format(query, sizeof query, "%s. Причина: %s", query, reason);
    SendClientMessageToAll(0xFFCD00FF, query);
    format(query, sizeof query, "Оффлайн заварнил %s[%d]. Причина: %s", player_name, uid, reason);
    SendLog(playerid, LOG_TYPE_ADMIN_WARN, query);
    if (warn <= 2)
    {
        warn_time = gettime() + (86400 * 10);
        mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET warn=%d,warn_time=%d WHERE id=%d", warn, warn_time, uid);
        mysql_query(mysql, query, false);
    }
    if (warn == 3)
    {
        mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET warn=0,warn_time=0 WHERE id=%d", uid);
        mysql_query(mysql, query, false);
        AddBan(uid, gettime(), 10, uip, "3/3 предупреждений", GetPlayerNameEx(playerid));
    }
    return 1;
}

cmd:offunwarn(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 7) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /offunwarn [ник игрока]");

	extract params -> new string: player_name[21];


	if(IsPlayerConnected(GetPlayerID(player_name))) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем находится на сервере");

	static query[144],
		Cache: result,
		rows,
		uid,
		warn;

	mysql_format(mysql, query, sizeof query, "SELECT id, warn FROM PlayersMorallwens WHERE name='%e'", player_name);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		uid = cache_get_row_int(0, 0);
		warn = cache_get_row_int(0, 1);
	}

	cache_delete(result);

	if(!rows || !uid) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE id=%d", uid);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	cache_delete(result);

	if(!rows) return SendClientMessage(playerid, 0x999999FF, "* Аккаунт не найден");
	if(warn < 1) return SendClientMessage(playerid, 0x999999FF, "* У игрока нет предупреждений");
	format(query, sizeof query, "A: %s оффлайн снял все предупреждения игроку %s", GetPlayerNameEx(playerid), player_name);

	SendClientMessageToAll(0xFFCD00FF, query);

	format(query, sizeof query, "Оффлайн снял все варны %s[%d]", player_name, uid);
	SendLog(playerid, LOG_TYPE_ADMIN_WARN, query);

	mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET warn=0,warn_time=0 WHERE id=%d",uid);
	mysql_query(mysql, query, false);

	return 1;
}

cmd:offjail(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /offjail [ник игрока] [время] [причина (необязательно)]");

	extract params -> new string: player_name[30], jail_time, string: reason[30];

	if(!(1 <= jail_time <= 360)) return SendClientMessage(playerid, 0xCECECEFF, "* Время должно быть не меньше 1 и не больше 60 минут");

	if(IsPlayerConnected(GetPlayerID(player_name))) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем находится на сервере");

	static query[144],
		Cache: result,
		rows,
		uid,
		admin,
		jail;

	mysql_format(mysql, query, sizeof query, "SELECT id, admin, jail FROM PlayersMorallwens WHERE name='%e'", player_name);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		uid = cache_get_row_int(0, 0);
		admin = cache_get_row_int(0, 1);
		jail = cache_get_row_int(0, 2);
	}

	cache_delete(result);

	if(!rows || !uid) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	if(GetPlayerAdminEx(playerid) < admin) return SendClientMessage(playerid, 0x999999FF, "* Нельзя посадить администратора выше по рангу");

	mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE id=%d", uid);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	cache_delete(result);

	if(!rows) return SendClientMessage(playerid, 0x999999FF, "* Аккаунт не найден");
	if(jail > 0) return SendClientMessage(playerid, 0x999999FF, "* Игрок уже в тюрьме");
	format(query, sizeof query, "A: %s оффлайн посадил игрока %s на %d минут", GetPlayerNameEx(playerid), player_name, jail_time);

	if(strlen(reason) > 0)
	 format(query, sizeof query, "%s. Причина: %s", query, reason);

	SendClientMessageToAll(0xFFCD00FF, query);

	format(query, sizeof query, "Оффлайн посадил %s[%d]. Причина: %s", player_name, uid, reason);
	SendLog(playerid, LOG_TYPE_ADMIN_JAIL, query);

	mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET jail=%d WHERE id=%d", jail_time * 60, uid);
	mysql_query(mysql, query, false);

	return 1;
}

cmd:offunjail(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /offunjail [ник игрока]");

	extract params -> new string: player_name[21], to_player;


	if(IsPlayerConnected(GetPlayerID(player_name))) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем находится на сервере");

	static query[144],
		Cache: result,
		rows,
		uid,
		jail;

	mysql_format(mysql, query, sizeof query, "SELECT id, jail FROM PlayersMorallwens WHERE name='%e'", player_name);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		uid = cache_get_row_int(0, 0);
		jail = cache_get_row_int(0, 1);
	}

	cache_delete(result);

	if(!rows || !uid) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE id=%d", uid);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	cache_delete(result);


	if(!rows) return SendClientMessage(playerid, 0x999999FF, "* Аккаунт не найден");
	if(jail < 1) return SendClientMessage(playerid, 0x999999FF, "* Игрок не в тюрьме!");
	format(query, sizeof query, "A: %s выпустил из тюрьмы игрока %s", GetPlayerNameEx(playerid), player_name);

	SendMessageToAdmins(query, 0xFFCD00FF);

	format(query, sizeof query, "Оффлайн выпустил %s[%d]", player_name, uid);
	SendLog(playerid, LOG_TYPE_ADMIN_JAIL, query);


	mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET jail=0 WHERE id=%d", uid);
	mysql_query(mysql, query, false);

	return 1;
}
cmd:buyf(playerid, params[])
{
	new factory_fuels = GetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_AMOUNT);

	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться на нефтезаводе в рабочем транспорте");

	new modelid;
	new vehicleid = GetPlayerJobCar(playerid);

	if(vehicleid != INVALID_VEHICLE_ID)
		modelid = GetVehicleData(vehicleid, V_MODELID);

	if(IsPlayerInRangeOfPoint(playerid, 20.0, 994.1306, 679.8422, 12.0653))  // для завода
	{
		if(GetPlayerTempJob(playerid) != TEMP_JOB_FACTORY_TRUCKER || modelid != 514)
			return SendClientMessage(playerid, 0xCECECEFF, "* Вы не работаете в отделе доставки завода или заняли не ту линию");
	}
	else if(IsPlayerInRangeOfPoint(playerid, 25.0, 935.9503, 662.1276, 12.0029))  // для азс
	{
		if(GetPlayerJob(playerid) != JOB_TRUCKER || modelid != 514)
			return SendClientMessage(playerid, 0xCECECEFF, "* Вы не работаете развозчиком топлива или заняли не ту линию");
	}
	else
		return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться на нефтезаводе");

	new total_litres = GetPlayerJobLoadItems(playerid);

	if(!IsPlayerInVehicle(playerid, vehicleid))
		return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться на нефтезаводе в рабочем транспорте");

	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "* Используйте: /buyf [кол-во в литрах]");

	if(!IsTrailerAttachedToVehicle(vehicleid))
		return SendClientMessage(playerid, 0xCECECEFF, "* У Вашего транспорта отсутствует цистерна для топлива");

	extract params -> new load_fuel;

	if(!(1 <= load_fuel <= 8000))
		return SendClientMessage(playerid, 0x999999FF, "* Можно загрузить от 1 до 8000 л топлива");

	if(factory_fuels < load_fuel)
		return SendClientMessage(playerid, 0x999999FF, "* На нефтезаводе нет такого количества топлива");

	if((total_litres + load_fuel) > 8000)
		return SendClientMessage(playerid, 0xCECECEFF, "* В цистерну столько не поместится");

	if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), load_fuel * 10))
		return SendClientMessage(playerid, 0x999999FF, "* Недостаточно денег для покупки такого количества топлива");

	GivePlayerMoneyEx(playerid, -(load_fuel * 10), "Покупка топлива (нефтезавод)", true, false);

	SetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_AMOUNT, factory_fuels - load_fuel);
	UpdateRepository(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F);

	SetPlayerJobLoadItems(playerid, total_litres + load_fuel);

	static fmt_str[64];

	format(fmt_str, sizeof fmt_str, "Вы загрузили %d л топлива общей стоимостью %d руб", load_fuel, load_fuel * 10);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_str);

	format(fmt_str, sizeof fmt_str, "~g~+ %d litres~n~~b~total %d litres", load_fuel, total_litres + load_fuel);
	GameText(playerid, fmt_str, 2000, 6);

	format(fmt_str, sizeof fmt_str, "Доставка топлива\n{FFFFFF}Загрузка %d / 8000 л", total_litres + load_fuel);
	UpdateVehicleLabel(vehicleid, 0xFF6600FF, fmt_str);

	return 1;
}

cmd:sellf(playerid, params[])
{
	new modelid;
	new vehicleid = GetPlayerJobCar(playerid);

	if(vehicleid != INVALID_VEHICLE_ID)
		modelid = GetVehicleData(vehicleid, V_MODELID);

	if(GetPlayerTempJob(playerid) != TEMP_JOB_FACTORY_TRUCKER || modelid != 514)
		return SendClientMessage(playerid, 0xCECECEFF, "* Вы не работаете в службе доставки завода");

	if(!IsPlayerInRangeOfPoint(playerid, 10.0, -1111.9989, 2169.4163, 38.0353))
		return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться у склада топлива завода");

	new total_litres = GetPlayerJobLoadItems(playerid);

	new factory_fuels = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT);

	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "* Используйте: /sellf [кол-во в литрах]");

	extract params -> new sell_fuels;

	if(!(1 <= sell_fuels <= 8000))
		return SendClientMessage(playerid, 0x999999FF, "* Можно продать от 1 до 8000 л топлива");

	if(vehicleid == INVALID_VEHICLE_ID || !IsTrailerAttachedToVehicle(vehicleid) || total_litres < sell_fuels)
		return SendClientMessage(playerid, 0x999999FF, "* В Вашей фуре нет такого количества топлива или цистерна не прицеплена");

	if((factory_fuels + sell_fuels) > 1000000)
		return SendClientMessage(playerid, 0x999999FF, "* Склад топлива завода заполнен");

	GivePlayerMoneyEx(playerid, (sell_fuels * 12), "Продажа топлива (завод)", true, true);

	SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT, factory_fuels + sell_fuels);
	UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL);

	SetPlayerJobLoadItems(playerid, total_litres - sell_fuels);
	AddPlayerData(playerid, P_JOB_WAGE, +, sell_fuels * 2);

	static fmt_str[64];

	format(fmt_str, sizeof fmt_str, "Вы продали заводу %d л топлива на сумму %d руб", sell_fuels, sell_fuels * 12);
	SendClientMessage(playerid, 0x66CC00FF, fmt_str);

	format(fmt_str, sizeof fmt_str, "Ваша чистая выручка составляет {FF9900}%d руб", sell_fuels * 2);
	SendClientMessage(playerid, 0x66CC00FF, fmt_str);

	format(fmt_str, sizeof fmt_str, "Доставка топлива\n{FFFFFF}Загрузка %d / 8000 л", total_litres - sell_fuels);
	UpdateVehicleLabel(vehicleid, 0xFF6600FF, fmt_str);

	return 1;
}

cmd:buyprod(playerid, params[])
{
	if(!(GetPlayerJob(playerid) == JOB_TRUCKER && IsPlayerInJob(playerid)))
		return SendClientMessage(playerid, 0x999999FF, "* Вы должны работать дальнобойщиком");

	extract params -> new buy_prod_count; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /buyprod [кол-во]. Стоимость 1 продукта 24 руб.");

	if(!IsPlayerInRangeOfPoint(playerid, 20.0, -1046.5460,2203.9644,38.2055))
		return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться у склада исходных материалов завода");

	else if(!IsPlayerInVehicle(playerid, GetPlayerJobCar(playerid)))
		return SendClientMessage(playerid, 0x999999FF, "* Вы должны находиться у склада исходных материалов завода в рабочем транспорте");

	else if(!(1 <= buy_prod_count <= 10000))
		return SendClientMessage(playerid, 0x999999FF, "* Можно загрузить от 1 до 10000 шт. продуктов");

	else if(GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT) < buy_prod_count)
		return SendClientMessage(playerid, 0x999999FF, "* На складе исходных материалов нет такого количества продуктов");

	else if((buy_prod_count + GetPlayerJobLoadItems(playerid)) > 10000)
		return SendClientMessage(playerid, 0xCECECEFF, "* В фургон столько не поместится, максимум 10000 шт.");

	if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), buy_prod_count * 24))
		return SendClientMessage(playerid, 0xCECECEFF, "* Недостаточно денег для покупки такого количества продуктов");

	GivePlayerMoneyEx(playerid, -(buy_prod_count * 24), "Покупка продуктов (разв. продуктов)", true, true);

	SetPlayerJobLoadItems(playerid, GetPlayerJobLoadItems(playerid) + buy_prod_count);

	SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT, GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT) - buy_prod_count);
	UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD);

	static fmt_msg[64];

	format(fmt_msg, sizeof fmt_msg, "Вы купили %d продуктов на сумму %d руб.", buy_prod_count, buy_prod_count * 24);
	SendClientMessage(playerid, 0x66CC00FF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Текущее кол-во загруженных продуктов: %d из 10000", GetPlayerJobLoadItems(playerid));
	SendClientMessage(playerid, 0xFFFF00FF, fmt_msg);

	return 1;
}

cmd:bizlist(playerid)
{
	if(!(GetPlayerJob(playerid) == JOB_TRUCKER && !GetPlayerTeamEx(playerid)))
		return SendClientMessage(playerid, 0x999999FF, "* Вы должны работать дальнобойщиком");

	new order_id = GetPlayerData(playerid, P_ORDER);

	if(order_id == -1)
	{
		page_cars[playerid] = 1;
		type_page_cars[playerid] = 8;
		ShowBizlist(playerid, page_cars[playerid]);
	}
	else
	{
		string_dialog[0] = EOS;
		format
		(
			string_dialog, sizeof string_dialog, 
			"{FFFFFF}Название предприятия: {f0c94f}%s\n\
			{FFFFFF}Необходимый товар: {f0e94f}Продукты\n\
			{FFFFFF}Длина пути от места загрузки: {f0c94f}Неизвестно.\n\n\
			{FFFFFF}Необходимое количество: {f0c94f}%d {FFFFFF}ед.\n\
			{FFFFFF}Оплата за всю работу: {aef04f}%s {FFFFFF}руб.\n\n\
			{FFFFFF}Комиссия компании составляет: {ffe36c}25%\n\n\
			{FFFFFF}Примерное количество заездов: {f0c94f}%d {FFFFFF}кр.",
			GetBusinessData(GetOrderData(order_id, O_COMPANY_ID), B_NAME), 
			GetOrderData(order_id, O_AMOUNT),
			formatInt(GetOrderData(order_id, O_PRICE)),
			GetOrderData(order_id, O_AMOUNT) / 2500
		);

		Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFFFFF}Подробности о взятом заказе", string_dialog, "", "Закрыть");
	}
	return 1;
}


cmd:o(playerid, params[]) return callcmd::msg(playerid, params);
cmd:msg(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 4) return 1;
    if(admin_logged[playerid] == false) 
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

    if(!strlen(params))
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /msg [А] [текст]");

    static fmt_str[128];

    if(GetString(GetPlayerNameEx(playerid), "R")) return format(fmt_str, sizeof fmt_str, "Основатель %s: %s", GetPlayerNameEx(playerid), params), SendClientMessageToAll(0xFF0000FF, fmt_str);
	if(GetString(GetPlayerNameEx(playerid), "R")) return format(fmt_str, sizeof fmt_str, "Зам.Основателя %s: %s", GetPlayerNameEx(playerid), params), SendClientMessageToAll(0xFF0000FF, fmt_str);
	if(GetString(GetPlayerNameEx(playerid), "mrllwnsdev")) return format(fmt_str, sizeof fmt_str, "Разработчик %s: %s", GetPlayerNameEx(playerid), params), SendClientMessageToAll(0xFF0000FF, fmt_str);
	if(GetPlayerYAdminEx(playerid) >= 5) return format(fmt_str, sizeof fmt_str, "Пиар менеджер %s: %s", GetPlayerNameEx(playerid), params), SendClientMessageToAll(0xFF0000FF, fmt_str);
    {
        format(fmt_str, sizeof(fmt_str), "Администратор %s: %s", GetPlayerNameEx(playerid), params);
        SendClientMessageToAll(0xFFCD00FF, fmt_str);
    }

    SendLog(playerid, LOG_TYPE_ADMIN_MSG, params);

    return 1;
}
cmd:avt(playerid, params[])
{
     if(!IsMantoKiss(playerid)) return 1;

    SendClientMessageToAll(0x999999FF, "АВТОР МОДА: MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: VK.COM/MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: VK.COM/MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: VK.COM/MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: VK.COM/MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: VK.COM/MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: VK.COM/MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: MORALLWENS");
	SendClientMessageToAll(0x999999FF, "АВТОР МОДА: VK.COM/MORALLWENS");

    return 1;
}

cmd:amsg(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 5) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /amsg [текст]");

	static fmt_str[128];

	format(fmt_str, sizeof fmt_str, "A: Администрация сервера: %s", params);
	SendClientMessageToAll(0xFFCD00FF, fmt_str);

	if(!IsMantoKiss(playerid))
	{
	format(fmt_str, sizeof fmt_str, "Nemesis(SERVER): %s", params);
	SendClientMessageToAll(0xFFCD00FF, fmt_str);
	}

	SendLog(playerid, LOG_TYPE_ADMIN_MSG, params);

	return 1;
}

cmd:ears(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	g_admin_ears = g_admin_ears ^ true;

	static fmt_text[70];

	format(fmt_text, sizeof fmt_text, "Вы %s прослушку SMS", g_admin_ears ? "включили" : "выключили");
	SendClientMessage(playerid, 0x3399FFFF, fmt_text);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_text, sizeof fmt_text, "A: Администратор %s[%d] %s прослушку SMS", GetPlayerNameEx(playerid), playerid, g_admin_ears ? "включил" : "выключил");
		SendMessageToAdmins(fmt_text, 0x999999FF);
	}


	return 1;
}


cmd:nokay(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 4) return 1;
		else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	if(GetPlayerAdminEx(playerid) >= 4)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /nokay [ID игрока] [причина (необязательно)]");

		extract params -> new to_player;

		static reason[31];
		sscanf(params, "{d}s[30]", reason);

		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
			return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

		if(!GetPVarInt(to_player, "change_name_status"))
			return SendClientMessage(playerid, 0xFF6600FF, "* Игрок не подавал запрос на смену ника");

		new player_name[20 + 1];
		GetPVarString(to_player, "change_name", player_name, sizeof(player_name));

		static fmt_msg[128];
		format(fmt_msg, sizeof fmt_msg, "A: %s [%d] отменил заявку на смену ника %s [%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

		if(strlen(reason) > 0)
		format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

		SendMessageToAdmins(fmt_msg, COLOR_GREY);

		static fmt_text[175];

		format(fmt_text, sizeof fmt_text, "Администратор %s отменил вашу заявку на смену ника", GetPlayerNameEx(playerid));

		if(strlen(reason) > 0)
		format(fmt_text, sizeof fmt_text, "%s. Причина: %s", fmt_text, reason);

		SendClientMessage(to_player, 0xFF6600FF, fmt_text);

		DeletePVar(to_player, "change_name");
		DeletePVar(to_player, "change_name_status");

	}

	return 1;
}

cmd:okay(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
		else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используй: /okay [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(!GetPVarInt(to_player, "change_name_status"))
		return SendClientMessage(playerid, 0xCECECEFF, "* Игрок не подавал запрос на смену ника");

	new player_name[20 + 1];
	GetPVarString(to_player, "change_name", player_name, sizeof(player_name));

	if(ChangePlayerName(to_player, player_name, true))
	{
		Dialog
		(
			to_player, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
			"{FFD83D}Имя изменено",
			"{66FF00}Заявка на изменение имени одобрена, новое имя установлено.\n\n"\
			"{FFFFFF}В следующий раз при входе в игру используйте свое новое имя. Для\n"\
			"этого нужно изменить его в окне клиента CRMP. Рекомендуем прямо\n"\
			"сейчас свернуть игру и сделать это.",
			"Ок", ""
		);
	}
	else SendClientMessage(playerid, 0xFF6600FF, "* При смене ника произошла ошибка");

	static fmt_text[75];

	format(fmt_text, sizeof fmt_text, "A: %s[%d] одобрил заявку на смену никнейма", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	DeletePVar(to_player, "change_name");
	DeletePVar(to_player, "change_name_status");

	return 1;
}

cmd:cc(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) > 4)
	{
		if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
		 

		for(new i = 0; i < 25; i++)
		{
			SendClientMessageToAll(-1, "");
			SendClientMessageToAll(-1, "");
			SendClientMessageToAll(-1, "");
			SendClientMessageToAll(-1, "");
		}

		SendClientMessage(playerid, 0xFFCD00FF, "Чат был успешно очищен администрацией!");

		STRING_GLOBAL[0] = EOS;
		format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] очистил чат", GetPlayerNameEx(playerid), playerid);
		SendMessageToAdmins(STRING_GLOBAL, 0x999999FF);
	}
	else
	{
		for(new i = 0; i < 25; i++)
		{
			SendClientMessage(playerid, -1, "");
			SendClientMessage(playerid, -1, "");
			SendClientMessage(playerid, -1, "");
			SendClientMessage(playerid, -1, "");
		}

		SendClientMessage(playerid, 0xFFCD00FF, "Чат был успешно очищен администрацией!");
	}
	return 1;
}
cmd:leave(playerid)
{
	if(GetPlayerData(playerid, P_IMPROVEMENTS) < 2) return SendClientMessage(playerid, 0x999999FF, "* Приобретите улучшение \"Решительность\", чтобы уволиться по собственному желанию");

	if(!GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0x999999FF, "* Вы не состоите в организации");

	static fmt_text[210];

	format
	(
		fmt_text, sizeof fmt_text,
		"{FFFFFF}Вы состоите в организации %s.\n"\
		"Если Вы уволитесь, то потеряете все свои достижения в ней, такие как ранг.\n\n"\
		"Вы уверены, что хотите покинуть организацию?",
		GetTeamName(GetPlayerTeamEx(playerid))
	);

	Dialog(playerid, DIALOG_TEAM_LEAVE, DIALOG_STYLE_MSGBOX, "{FF5533}Предупреждение", fmt_text, "Да", "Нет");

	return 1;
}

cmd:yt(playerid, params[])
{
	if(GetPlayerYAdminEx(playerid) < 1) return 1;

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /yt [текст]");

	static fmt_str[128];

	format(fmt_str, sizeof fmt_str, "[YouTube] %s[%d]: %s", GetPlayerNameEx(playerid), playerid, params);
	SendMessageToYAdmins(fmt_str, 0xBE2D2DFF);
	SendMessageToAdmins(fmt_str, 0xdbba00FF);

	return 1;
}
cmd:youtubers(playerid, params[]) callcmd::ytubers(playerid, params);
cmd:ytubers(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerYAdminEx(playerid) < 1) return 1;

	static fmt_text[60],
		count;

	SendClientMessage(playerid, 0xffaa00FF, "Ютуберы в сети:");
	foreach(new i: Player)
	{
		new yt_lvl = GetPlayerYAdminEx(i);

		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(yt_lvl < 1 || yt_lvl > 3) continue;

		format(fmt_text, sizeof fmt_text, "%s[%d] (%d уровень)", GetPlayerNameEx(i), i, yt_lvl);

		if(IsPlayerAFK(i))
			format(fmt_text, sizeof fmt_text, "%s {FF0000}AFK [%02d:%02d]", fmt_text, (floatround(GetPlayerData(i, P_AFK_TIME) / 60) % 60), GetPlayerData(i, P_AFK_TIME) % 60);

		SendClientMessage(playerid, 0xffaa00FF, fmt_text);
		count++;
	}
	if(!count) SendClientMessage(playerid, 0xffaa00FF, "Нет ютуберов в сети");

	return 1;
}
cmd:log(playerid)
{
    if(GetPlayerAdminEx(playerid) < 6)
        return true;

    if(!admin_logged[playerid])
        return SendClientMessage(playerid, 0x999999FF, !"Вы не авторизированы, для этого используйте /alogin");

    g_player_log[playerid] = !g_player_log[playerid];

    SendClientMessage(playerid, COLOR_GREY, g_player_log[playerid] ? "Вы включили логирование онлайна в чате" : "Вы отключили логирование онлайна в чате" );
    SendClientMessage(playerid, COLOR_GREY, g_player_log[playerid] ? "Для того чтобы выключить логирование, еще раз пропишите команду /log" : "Для того чтобы вернуть логирование, еще раз пропишите команду /log");

    return true;
}

cmd:ahelp(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1 && GetPlayerBuyAdminEx(playerid) < 1) return 1;
	else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");
    {
		Dialog(playerid, DIALOG_AHELP, DIALOG_STYLE_LIST, "{FFD83D}Команды администраторов",
		"{"SERVER_COLOR"}1. {ffffff}Команды администратора: {"SERVER_COLOR"}(Уровень 1)\n\
		{"SERVER_COLOR"}2. {ffffff}Команды администратора: {"SERVER_COLOR"}(Уровень 2)\n\
		{"SERVER_COLOR"}3. {ffffff}Команды администратора: {"SERVER_COLOR"}(Уровень 3)\n\
		{"SERVER_COLOR"}4. {ffffff}Команды администратора: {"SERVER_COLOR"}(Уровень 4)\n\
		{"SERVER_COLOR"}5. {ffffff}Команды администратора: {"SERVER_COLOR"}(Уровень 5)\n\
		{"SERVER_COLOR"}6. {ffffff}Команды администратора: {"SERVER_COLOR"}(Уровень 6)\n\
		{"SERVER_COLOR"}7. {ffffff}Команды администратора: {"SERVER_COLOR"}(Уровень 7)\n\
		{"SERVER_COLOR"}8. {ffffff}Команды администратора: {"SERVER_COLOR"}(Уровень 8)\n\
		{"SERVER_COLOR"}9. {ffffff}Команды администратора: {"SERVER_COLOR"}(Уровень 9)\n\
		{"SERVER_COLOR"}10. {ffffff}Команды администратора: {"SERVER_COLOR"}(Уровень 10)\n\
		{"SERVER_COLOR"}11. {ffffff}Команды администратора: {"SERVER_COLOR"}(Уровень 11)",
		"Далее", "Закрыть");
	}
	return 1;
}

cmd:yhelp(playerid, params[])
{
	if(GetPlayerYAdminEx(playerid) >= 1) SendClientMessage(playerid, 0xFFFFFFFF, "{"SERVER_COLOR"}Доступные команды для ютуберов:");
	if(GetPlayerYAdminEx(playerid) >= 1) SendClientMessage(playerid, 0xFFFFFFFF, "{"SERVER_COLOR"}1 уровень: {FFFFFF}/yt /youtubers /fixcar /goto /fly /delveh");
	if(GetPlayerYAdminEx(playerid) >= 2) SendClientMessage(playerid, 0xFFFFFFFF, "{"SERVER_COLOR"}2 уровень: {FFFFFF}/veh /getv /spawn /gethere");
	if(GetPlayerYAdminEx(playerid) >= 3) SendClientMessage(playerid, 0xFFFFFFFF, "{"SERVER_COLOR"}3 уровень: {FFFFFF}/admins");
	return 1;
}

cmd:sp(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
 	else if(admin_logged[playerid] == false) return SCM(playerid, 0x999999FF, "Вы не авторизированы, для этого используйте /alogin");
	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /sp [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

    if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid))
		return SendClientMessage(playerid, 0x999999FF, "За данным игроком следить нельзя");

	if(IsMantoKiss(to_player))
	{
		SendClientMessage(playerid, 0x999999FF, "Вы не можете следить за этим игроком.");
		SendClientMessage(playerid, 0x999999FF, "За использование данной команды в личных целях вы будете сняты!");
		return 1;
	}
	
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
	StartSpectate(playerid, to_player);
	ShowSpectateMenu(playerid, to_player);
	return 1;
}
cmd:offmute(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2) return 1;
	if(Test_server == 1) return SCM(playerid, -1, "* На данный момент сервер находится в Техническом режиме, подобные команды отключены");
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /offmute [никнейм игрока] [время в минутах] [причина (необязательно)]");

	extract params -> new string: player_name[21], mute_time, string: reason[30];


	if(IsPlayerConnected(GetPlayerID(player_name))) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем находится на сервере");

	if(!(1 <= mute_time <= 360)) return SendClientMessage(playerid, 0xCECECEFF, "* Время должно быть не меньше 1 и не больше 360 минут");

	static fmt_msg[128];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s поставил затычку игроку оффлайн %s на %d мин", GetPlayerNameEx(playerid), player_name, mute_time);
	
	AddPlayerData(playerid, P_ADMMUTE, +, 1);
	UpdatePlayerDatabaseInt(playerid, "admmute", GetPlayerData(playerid, P_ADMMUTE));

	if(strlen(reason))
		format(fmt_msg, sizeof fmt_msg, "%s. Причина: %s", fmt_msg, reason);

	SendClientMessageToAll(0xFF0000AA, fmt_msg);

	static query[144],
		Cache: result,
		rows,
		uid,
		uip[16];

	mysql_format(mysql, query, sizeof query, "SELECT id, last_ip FROM PlayersMorallwens WHERE name='%e'", player_name);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		uid = cache_get_row_int(0, 0);
		cache_get_row(0, 2, uip);
	}

	cache_delete(result);

	if(!rows || !uid) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET mute%d WHERE id=%d", mute_time * 60,uid);
	mysql_query(mysql, query, false);

	format(fmt_msg, sizeof fmt_msg, "Выдал %s блокировку чата оффлайн на %d мин. Причина: %s", player_name, mute_time, reason);
	SendLog(playerid, LOG_TYPE_ADMIN_MUTE, fmt_msg);
	return 1;
}

cmd:stats(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerBuyAdminEx(playerid) < 2) return 1;
 			else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /stats [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	ShowPlayerStats(to_player, playerid);
	return 1;
}
cmd:offstats(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerBuyAdminEx(playerid) < 2) return 1;
 			else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /offstats [имя игрока]");

	if(!(3 <= strlen(params) <= 20))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	extract params -> new string: name[21];

	static query[100];
	new Cache: result, user_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows())
		user_id = cache_get_field_content_int(0, "id");

	if(!cache_num_rows() || !user_id)
		return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден"), cache_delete(result);

	ShowPlayerStats(user_id, playerid);
	return 1;
}
cmd:a(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1)
        return 1;

    	{
        if(!strlen(params)) 
            return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /a [текст]");
        
        static fmt_str[128];
        
       
        if(!g_player[playerid][P_MYPREFIX] && !g_player[playerid][P_MYPREFIX_COLOR])
        {
            format(fmt_str, sizeof fmt_str, "A: %s[%d]: {FFFFFF}%s", GetPlayerNameEx(playerid), playerid, params);
            SendMessageToAdmins(fmt_str, 0xFFCD00FF);
        }
        else if(g_player[playerid][P_MYPREFIX] && g_player[playerid][P_MYPREFIX_COLOR])
        {
            format(fmt_str, sizeof fmt_str, "A: {%s}[%s] {FFCD00}%s[%d]: {FFFFFF}%s", g_player[playerid][P_MYPREFIX_COLOR], g_player[playerid][P_MYPREFIX], GetPlayerNameEx(playerid), playerid, params);
            SendMessageToAdmins(fmt_str, 0xFFCD00FF);
        }
		if(GetPlayerAdminEx(playerid) < 1)
		{
			format(fmt_str, sizeof fmt_str, "[S] %s[%d]: %s", GetPlayerNameEx(playerid), playerid, params);
			SendMessageToAdmins(fmt_str, 0x99CC00FF);
		}
    }

    return 1;
}

cmd:achat(playerid, params[])
{
	if(GetPlayerBuyAdminEx(playerid) < 1 && GetPlayerAdminEx(playerid) < 1) return 1;
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /achat [текст]");
		static fmt_str[128];
        static PAdminTag[100];
        static AdminTag[50];

		if(GetPlayerBuyAdminEx(playerid) > 0)
		{
			format(fmt_str, sizeof fmt_str, "{FFCD00}A-BUY: %s: {FFCD00}%s[%d]: {FFFFFF}%s", PAdminTag, GetPlayerNameEx(playerid), playerid, params);
		}
		else if(GetPlayerAdminEx(playerid) > 0)
		{
			format(fmt_str, sizeof fmt_str, "{FFCD00}A: %s: {FFCD00}%s[%d]: {FFFFFF}%s", AdminTag, GetPlayerNameEx(playerid), playerid, params);
		}
		SendMessageToAdmins(fmt_str, -1);
		SendMessageToBuyAdmins(fmt_str, -1);
	}
	return 1;
}
cmd:ytadmins(playerid, params[])
{
	if(GetPlayerYAdminEx(playerid) < 1) return 1;
	 
	static fmt_text[128],
		count;
		
	SendClientMessage(playerid, 0x99CC00FF, !"Админы онлайн:");
	for(new i; i < MAX_PLAYERS; i ++)
	{
		new yt_lvl = GetPlayerAdminEx(i);

		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;
		else if(!(1 <= yt_lvl <= 3)) continue;

		if(g_player[i][P_MYPREFIX] && g_player[i][P_MYPREFIX_COLOR])
		{
			format(fmt_text, sizeof fmt_text, "{%s}[%s] {99CC00}%s [%d] (LVL %d)", g_player[i][P_MYPREFIX_COLOR], g_player[i][P_MYPREFIX], GetPlayerNameEx(i), i, yt_lvl);

			if(IsPlayerAFK(i))
				format(fmt_text, sizeof fmt_text, "{99CC00}%s {FF0000}AFK [%02d:%02d]", fmt_text, (floatround(GetPlayerData(i, P_AFK_TIME) / 60) % 60), GetPlayerData(i, P_AFK_TIME) % 60);

			else if(GetPlayerSpectateData(i, S_PLAYER) != -1)
				format(fmt_text, sizeof fmt_text, "{99CC00}%s {00CC00}/sp > %d", fmt_text, GetPlayerSpectateData(i, S_PLAYER));

			SendClientMessage(playerid, -1, fmt_text);
			count++;
		}
		if(!g_player[i][P_MYPREFIX] && !g_player[i][P_MYPREFIX_COLOR])
		{
			format(fmt_text, sizeof fmt_text, "{99CC00}%s [%d] (LVL %d)", GetPlayerNameEx(i), i, yt_lvl);

			if(IsPlayerAFK(i))
				format(fmt_text, sizeof fmt_text, "{99CC00}%s {FF0000}AFK [%02d:%02d]", fmt_text, (floatround(GetPlayerData(i, P_AFK_TIME) / 60) % 60), GetPlayerData(i, P_AFK_TIME) % 60);

			else if(GetPlayerSpectateData(i, S_PLAYER) != -1)
				format(fmt_text, sizeof fmt_text, "{99CC00}%s {00CC00}/sp > %d", fmt_text, GetPlayerSpectateData(i, S_PLAYER));

			SendClientMessage(playerid, -1, fmt_text);
			count++;
		 }
	}
	return 1;
}

cmd:get(playerid, params[]) callcmd::changeinfo(playerid, params);
cmd:ci(playerid, params[]) callcmd::changeinfo(playerid, params);
cmd:changeinfo(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
 		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /changeinfo [имя игрока]");

	if(!(3 <= strlen(params) <= 20)) return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	extract params -> new string: name[21];

	static query[100];
	new Cache: result, user_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows())
		user_id = cache_get_field_content_int(0, "id");

	if(!cache_num_rows() || !user_id)
		return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден"), cache_delete(result);

	new reg_ip[16],
		last_ip[16],
		reg_date[6],
		login_date[6],
		money[21],
		bank[21],
		reg_time = cache_get_field_content_int(0, "reg_time"),
		last_login = cache_get_field_content_int(0, "last_login"),
		game_for_day = cache_get_field_content_int(0, "game_for_day"),
		game_for_day_prev = cache_get_field_content_int(0, "game_for_day_prev"),
		warn = cache_get_field_content_int(0, "warn"),
		jail = cache_get_field_content_int(0, "jail"),
		car_slots = cache_get_field_content_int(0, "car_slots"),
		garage_slots = cache_get_field_content_int(0, "garage_slots"),
		house_slots = cache_get_field_content_int(0, "house_slots"),
		kiosk_slots = cache_get_field_content_int(0, "kiosk_slots"),
		admin = cache_get_field_content_int(0, "admin"),
		biz_slots = cache_get_field_content_int(0, "biz_slots");

	cache_get_field_content(0, "reg_ip", reg_ip);
	cache_get_field_content(0, "last_ip", last_ip);
	cache_get_field_content(0, "money", money);
	cache_get_field_content(0, "bank", bank);

	timestamp_to_date(reg_time, reg_date[2], reg_date[1], reg_date[0], reg_date[3], reg_date[4], reg_date[5]);
	timestamp_to_date(last_login, login_date[2], login_date[1], login_date[0], login_date[3], login_date[4], login_date[5]);

	string_dialog[0] = EOS;

	format
	(
		string_dialog, sizeof string_dialog,
		"\
		{FFFFFF}Номер аккаунта:\t\t%d\n\
		{FFFFFF}Наличные:\t\t\t%s руб\n\
		{FFFFFF}Осн. банк счет:\t\t%s руб\n\
		{FFFFFF}Баланс [Донат]:\t\t\t\t%s руб (Всего: %s руб)\n\
		{FFFFFF}Уровень:\t\t\t%d\n\
		{FFFFFF}Уровень администратора:\t\t\t%d\n\
		{FFFFFF}IP адрес (регистр.):\t\t%s\n\
		{FFFFFF}IP адрес (послед.):\t\t%s\n\
		{FFFFFF}Дата и время регистрации:\t\%02d.%02d.%d в %02d:%02d:%02d\n\
		{FFFFFF}Дата и время последнего входа:\t\%02d.%02d.%d в %02d:%02d:%02d\n\
		{FFFFFF}В игре сегодня:\t\t%d ч %d мин\n\
		{FFFFFF}В игре вчера:\t\t\t%d ч %d мин\n\n\
		{FFFFFF}Слоты для транспорта:\t%d\n\
		{FFFFFF}Слоты для дома:\t%d\n\
		{FFFFFF}Слоты для бизнеса:\t%d\n\
		{FFFFFF}Слоты для гаража:\t%d\n\
		{FFFFFF}Слоты для киоска:\t%d\n\n\
		{FAAC58}Наказания:{FFFFFF}\n\
		{FFFFFF}Варны: %d\n\
		{FFFFFF}Деморганы: %d\n\n\
		{FAAC58}Транспорт:{FFFFFF}\
		",
		user_id,
		formatStr(money),
		formatStr(bank),
		formatInt(cache_get_field_content_int(0, "donate_current")),
		formatInt(cache_get_field_content_int(0, "donate_total")),
		cache_get_field_content_int(0, "level"),
		admin,
		reg_ip,
		last_ip,
		reg_date[0], reg_date[1], reg_date[2],
		reg_date[3], reg_date[4], reg_date[5],
		login_date[0], login_date[1], login_date[2],
		login_date[3], login_date[4], login_date[5],
		ConvertUnixTime(game_for_day, CONVERT_TIME_TO_HOURS),
		ConvertUnixTime(game_for_day, CONVERT_TIME_TO_MINUTES),
		ConvertUnixTime(game_for_day_prev, CONVERT_TIME_TO_HOURS),
		ConvertUnixTime(game_for_day_prev, CONVERT_TIME_TO_MINUTES),
		car_slots,
		house_slots,
		biz_slots,
		garage_slots,
		kiosk_slots,
		warn,
		jail
	);

	cache_delete(result);

	if(GetPlayerAdminEx(playerid) < admin) 
		return SCM(playerid, COLOR_GREY, "* Вы не можете просматривать информацию об аккаунте выше вас по рангу");

	format(query, sizeof query, "SELECT * FROM ownable_cars WHERE owner_id=%d", user_id);
	result = mysql_query(mysql, query, true);

	if(cache_num_rows())
	{
		for(new idx; idx < cache_num_rows(); idx ++)
		{
			new id = cache_get_field_content_int(idx, "id"),
				modelid = cache_get_field_content_int(idx, "model_id"),
				number[10],
				region[10];

			cache_get_field_content(idx, "number", number);
			cache_get_field_content(idx, "region", region);
			new typenumber = cache_get_field_content_int(idx, "typenumber");

			if(typenumber == 0) format(query, sizeof query, "\n%s [%d]", GetVehicleInfo(modelid, VI_NAME), id);
			else format(query, sizeof query, "\n%s [%d] [%s | %s]", GetVehicleInfo(modelid, VI_NAME), id, number, region);
			strcat(string_dialog, query);
		}
	}
	cache_delete(result);

	strcat(string_dialog, "\n\n{FAAC58}Дома:{FFFFFF}");

	format(query, sizeof query, "SELECT * FROM houses WHERE owner_id=%d", user_id);
	result = mysql_query(mysql, query, true);

	if(cache_num_rows())
	{
		for(new idx; idx < cache_num_rows(); idx ++)
		{
			new id = cache_get_field_content_int(idx, "id");

			format(query, sizeof query, "\nДом [№%d]", id);
			strcat(string_dialog, query);
		}
	}
	cache_delete(result);

	strcat(string_dialog, "\n\n{FAAC58}Бизнесы:{FFFFFF}");

	format(query, sizeof query, "SELECT * FROM business WHERE owner_id=%d", user_id);
	result = mysql_query(mysql, query, true);

	if(cache_num_rows())
	{
		for(new idx; idx < cache_num_rows(); idx ++)
		{
			new id = cache_get_field_content_int(idx, "id"),
				name_e[30];

			cache_get_field_content(idx, "name", name_e);

			format(query, sizeof query, "\n%s [№%d]", name_e, id);
			strcat(string_dialog, query);
		}
	}
	cache_delete(result);

	strcat(string_dialog, "\n\n{FAAC58}Гаражи:{FFFFFF}");

	format(query, sizeof query, "SELECT * FROM garage WHERE owner_id=%d", user_id);
	result = mysql_query(mysql, query, true);

	if(cache_num_rows())
	{
		for(new idx; idx < cache_num_rows(); idx ++)
		{
			new id = cache_get_field_content_int(idx, "id");

			format(query, sizeof query, "\nГараж [№%d]", id);
			strcat(string_dialog, query);
		}
	}
	cache_delete(result);

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, name, string_dialog, "Закрыть", "");

	return 1;
}

cmd:money(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6 && GetPlayerBuyAdminEx(playerid) < 6) return 1;
 			else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /money [имя игрока]");

	if(!(3 <= strlen(params) <= 20))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	extract params -> new string: name[21];

	static query[90];
	new Cache: result, user_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM PlayersMorallwens WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows())
		user_id = cache_get_field_content_int(0, "id");

	if(!cache_num_rows() || !user_id)
		return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден"), cache_delete(result);

	new player_cash = cache_get_field_content_int(0, "money"),
		player_bank = cache_get_field_content_int(0, "bank"),
		player_wage = cache_get_field_content_int(0, "wage"),
		player_business = cache_get_field_content_int(0, "business"),
		player_fuel_st = cache_get_field_content_int(0, "fuel_st"),
		bank_accounts_money,
		fmt_text[310];

	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "SELECT * FROM bank_accounts WHERE uid='%d'", user_id);
	result = mysql_query(mysql, query);

	if(cache_num_rows())
	{
		for(new i = 0; i < cache_num_rows(); i++)
			bank_accounts_money += cache_get_field_content_int(i, "balance");
	}

	cache_delete(result);

	format
	(
		fmt_text, sizeof fmt_text,
		"\
		Наличные деньги:\t\t\t%s руб\n\
		Осн.банковский счёт:\t\t\t%s руб\n\
		Временный З/П счёт:\t\t\t%s руб\n\n\
		На всех доп. банк. счетах:\t\t%s руб\n\n\
		",
		formatInt(player_cash), formatInt(player_bank), formatInt(player_wage), formatInt(bank_accounts_money)
	);

	if(player_business != -1)
	{
		mysql_format(mysql, query, sizeof query, "SELECT balance FROM business WHERE owner_id='%d' LIMIT 1", user_id);
		result = mysql_query(mysql, query);

		format(query, sizeof query, "На счету бизнеса:\t\t\t%d руб\n", cache_get_row_int(0, 0));
		strcat(fmt_text, query);

		cache_delete(result);
	}
	else strcat(fmt_text, "Нет бизнеса\n");

	if(player_fuel_st != -1)
	{
		mysql_format(mysql, query, sizeof query, "SELECT balance FROM fuel_stations WHERE owner_id='%d' LIMIT 1", user_id);
		result = mysql_query(mysql, query);

		format(query, sizeof query, "На счету АЗС:\t\t\t\t%d руб", cache_get_row_int(0, 0));
		strcat(fmt_text, query);

		cache_delete(result);
	}
	else strcat(fmt_text, "Нет АЗС");

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, name, fmt_text, "Закрыть", "");


	return 1;
}

cmd:getlog(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	if(!strlen(params))
	{
		SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /getlog [имя игрока] [идентификатор лога] [кол-во дней]");
		SendClientMessage(playerid, 0xCECECEFF, "* Идентификаторы:");
		SendClientMessage(playerid, 0xCECECEFF, "* 1 - Блокировки чата/Снятие блокировок чата");
		SendClientMessage(playerid, 0xCECECEFF, "* 2 - Ответы на репорты");
		SendClientMessage(playerid, 0xCECECEFF, "* 3 - Деморганы/Снятие деморганов");
		SendClientMessage(playerid, 0xCECECEFF, "* 4 - Кики");
		SendClientMessage(playerid, 0xCECECEFF, "* 5 - Предупреждения/Снятие предупреждений");
		SendClientMessage(playerid, 0xCECECEFF, "* 6 - Блокировки/Снятие блокировок");
		SendClientMessage(playerid, 0xCECECEFF, "* 7 - Поставновление и снятие админки/ютуберки");
		SendClientMessage(playerid, 0xCECECEFF, "* 8 - Поставновление и снятие лидерки");
		SendClientMessage(playerid, 0xCECECEFF, "* 9 - Общий чат /msg");
		SendClientMessage(playerid, 0xCECECEFF, "* 10 - Действия главной администрации");
		SendClientMessage(playerid, 0xCECECEFF, "* 11 - Действия игрока");

		return 1;
	}

	extract params -> new string:name[21], log_id, time_limit;

	if(!(LOG_TYPE_ADMIN_MUTE <= log_id <= LOG_TYPE_ALL))
		return SendClientMessage(playerid, 0x999999FF, "* Неверный идентификатор");

	if(!(0 <= time_limit <= 30))
		return SendClientMessage(playerid, 0x999999FF, "* Количество дней от 1 до 30. Используйте 0 для отображения всех действий");

	if(!(3 <= strlen(name) <= 20))
		return SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	static query[144];
	new Cache: result,
		rows,
		user_id,
		admin;

	mysql_format(mysql, query, sizeof query, "SELECT id, admin FROM PlayersMorallwens WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	rows = cache_num_rows();

	if(rows)
	{
		user_id = cache_get_row_int(0, 0);
		admin = cache_get_row_int(0, 1);
	}

	cache_delete(result);

	if(rows && user_id)
	{
		if(GetPlayerAdminEx(playerid) >= admin)
		{
			mysql_format(mysql, query, sizeof query, "SELECT * FROM action_log WHERE acc_id=%d AND type=%d", user_id, log_id);

			static fmt_text[35];

			if(time_limit)
			{
				format(fmt_text, sizeof fmt_text, " AND time >= %d", gettime() - (time_limit * 86400));
				strcat(query, fmt_text);
			}

			result = mysql_query(mysql, query, true);

			rows = cache_num_rows();

			if(rows)
			{
				new log_name[10][41] =
				{
					"Блокировки/Снятие блокировок чата",
					"Ответы на репорты",
					"Деморганы/Снятие деморганов",
					"Кики",
					"Предупреждения/Снятие предупреждений",
					"Блокировки/Снятие блокировок",
					"Поставновление и снятие админки/ютуберки",
					"Поставновление и снятие лидерки",
					"Общий чат /msg",
					"Действия главной администрации"
				};

				format(query, sizeof query, "Найденные записи по параметру %s для игрока %s", log_name[log_id - 1], name);

				if(time_limit)
				{
					format(fmt_text, sizeof fmt_text, " за последние %d дн.", time_limit);
					strcat(query, fmt_text);
				}

				SendClientMessage(playerid, 0x66CC33FF, query);

				for(new idx; idx < rows; idx ++)
				{
					static desc[244],
						time[6],
						uip[17];

					cache_get_field_content(idx, "description", desc);
					cache_get_field_content(idx, "uip", uip);

					timestamp_to_date(cache_get_field_content_int(idx, "time"), time[2], time[1], time[0], time[3], time[4], time[5]);

					format
					(
						query, sizeof query,
						"#%d | %02d.%02d.%d в %02d:%02d:%02d | %s | %s",
						cache_get_field_content_int(idx, "id"),
						time[0], time[1], time[2], time[3], time[4], time[5],
						uip, desc
					);

					SendClientMessage(playerid, 0xFFCD00FF, query);
				}

				format(query, sizeof query, "Общее количество записей: %d", rows);
				SendClientMessage(playerid, 0x66CC33FF, query);
			}
			else SendClientMessage(playerid, 0x999999FF, "* Записи в базе данных по данным параметрам не найдены");

			cache_delete(result);
		}
		else SendClientMessage(playerid, 0x999999FF, "* Вы не можете просматривать логи администратора выше Вас рангом");
	}
	else SendClientMessage(playerid, 0x999999FF, "* Игрок с таким именем не найден");

	return 1;
}

cmd:lip(playerid, params[])
{
	if(Test_server == 1) return SCM(playerid, -1, "* На данный момент сервер находится в Техническом режиме, подобные команды отключены");
	if(GetPlayerAdminEx(playerid) < 5) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	 

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /lip [IP адрес]");

	static query[130],
		fmt_text[2300],
		Cache: result,
		rows;

	mysql_format(mysql, query, sizeof query, "SELECT name, reg_ip FROM PlayersMorallwens WHERE reg_ip = '%e' OR last_ip = '%e'", params, params);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		new l_acc_count;

		format(fmt_text, sizeof fmt_text, "IP: %s\n", params);

		for(new idx; idx < rows; idx ++)
		{
			new name[21],
				ip[17];

			cache_get_row(idx, 0, name);
			cache_get_row(idx, 1, ip);

			new bool: is_reg = false;

			if(!strcmp(ip, params, true))
				is_reg = true;

			else
				l_acc_count ++;

			format
			(
				query, sizeof query,
				"\n{FFFFFF}%d. %s - %s %s",
				idx + 1,
				name,
				is_reg ? "Reg" : "Last",
				IsPlayerConnected(GetPlayerID(name)) ? "{66CC33}[online]" : "{888888}[offline]"
			);

			strcat(fmt_text, query);
		}

		format(query, sizeof query, "{FF9900}Найдено аккаунтов: %d / %d", l_acc_count, rows);

		Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, query, fmt_text, "Закрыть", "");
	}
	else SendClientMessage(playerid, 0x999999FF, "* Данный IP адрес не найден в базе данных");

	cache_delete(result);

	return 1;
}
cmd:replace_tire(playerid, params[])
{
	if(!GetPVarInt(playerid, "shinomontach")) return SendClientMessage(playerid, -1, "* Вы не работаете в шиномонтаже");
	if(!strlen(params))
		return SendClientMessage(playerid, 0xFFA500FF, "* Используйте: /replace_tire [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 3.0))
		return SendClientMessage(playerid, 0xCECECEFF, "* Игрок слишком далеко от вас");

	new vehicleid3 = GetPlayerOwnableCarLast(to_player);

	if(vehicleid3 != GetPlayerVehicleID(to_player)) return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться в личном транспорте");

	SetPVarInt(playerid, "shinka", GetPlayerVehicleID(to_player));
	SetPVarInt(playerid, "to_player_s", to_player);


	ShowShin(playerid, GetPlayerVehicleID(to_player));

	return 1;
}

cmd:cancel(playerid, params[])
{
	new offer_id = GetPlayerOfferInfo(playerid, O_OUTCOMIG_PLAYER);

	if(offer_id != INVALID_PLAYER_ID)
	{
		if(GetPlayerOfferInfo(offer_id, O_INCOMING_PLAYER) == playerid)
		{
			ClearPlayerOffer(offer_id);

			static fmt_str[64];
			format(fmt_str, sizeof fmt_str, "%s отозвал свое предложение", GetPlayerNameEx(playerid));
			SendClientMessage(offer_id, 0xFF6600FF, fmt_str);

			format(fmt_str, sizeof fmt_str, "Вы отозвали свое предложение для %s", GetPlayerNameEx(offer_id));
			SendClientMessage(playerid, 0xFF6600FF, fmt_str);
		}
		else SendClientMessage(playerid, 0xFF6600FF, "* Вы отозвали свое последнее предложение");

		ClearPlayerOffer(playerid);
	}
	else SendClientMessage(playerid, 0xCECECEFF, "* У Вас нет активных предложений");

	return 1;
}

cmd:hi(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0x999999FF, "* Нельзя использовать в машине");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /hi [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	new Float: to_x, Float: to_y, Float: z;
	GetPlayerPos(to_player, to_x, to_y, z);

	new Float: dist = GetPlayerDistanceFromPoint(playerid, to_x, to_y, z);
	if(0.5 <= dist <= 1.5)
	{
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_HANDSHAKE);
	}
	else if(dist < 20.0)
	{
		static fmt_str[35];

		new Float: x, Float: y;
		new Float: angle;

		GetPlayerPos(playerid, x, y, z);
		angle = GetAngleToPoint(to_x, to_y, x, y);

		SetPlayerFacingAngle(playerid, angle);

		format(fmt_str, sizeof fmt_str,"машет рукой %s", GetPlayerNameEx(to_player));
		Action(playerid, fmt_str, _, false);

		ApplyAnimation(playerid, "PED", "endchat_03", 4.1, 0, 1, 1, 0, -1, 1);
	}
	else SendClientMessage(playerid, 0x999999FF, "* Вы находитесь слишком далеко от игрока");
	return 1;
}

cmd:me(playerid, params[])
{
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /me [текст]");

	return Action(playerid, params);
}

cmd:do(playerid, params[])
{
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /do [текст]");


	static fmt_str[128];
	SetPlayerChatBubble(playerid, params, 0xDD90FFFF, 25.0, 5000);

	format(fmt_str, sizeof fmt_str, "%s (%s)", params, GetPlayerNameEx(playerid));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}

cmd:try(playerid, params[])
{
	if(IsPlayerMuted(playerid))
		return SCM(playerid, 0xFF6600FF, !"Вы не можете использовать это");

	if(!strlen(params))
		return SCM(playerid, 0xCECECEFF, !"Используйте: /try [текст]");

	static fmt_str[128];

	format(fmt_str, sizeof fmt_str, "%s %s %s", GetPlayerNameEx(playerid), params, !random(3) ? ("{66CC00}| Удачно") : ("{FF6600}| Неудачно"));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

	return 1;
}
cmd:viplist(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 2 && GetPlayerPremium(playerid) < 1) return 1;

	static fmt_text[100],
		list[sizeof fmt_text * 10 + 50] = "Имя игрока\tСтатус VIP{FFD83D}\n";

	new premium_rank[3][17] =
	{
		"{C0C0C0}Silver",
		"{FFD700}Gold",
		"{E5E4E2}Platinum"
	};

	foreach(new i : Player)
	{
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;
        else if(!GetPlayerPremium(i)) continue;

		if(i < 0)
		{
			format(fmt_text, sizeof fmt_text, "В данный момент игроков с VIP нет в сети.", GetPlayerNameEx(i), i, premium_rank[GetPlayerPremium(i) - 1]);
			Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_TABLIST_HEADERS, "{FFD83D}Игроки с VIP онлайн", fmt_text, "Закрыть", "");
		}
		else
		{
			format(fmt_text, sizeof fmt_text, "%s [%d]\t%s\n", GetPlayerNameEx(i), i, premium_rank[GetPlayerPremium(i) - 1]);
			strcat(list, fmt_text);
			Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_TABLIST_HEADERS, "{FFD83D}Игроки с VIP онлайн", list, "Закрыть", "");
		}
	}

	return 1;
}

cmd:viphelp(playerid)
{
    Dialog
	(
		playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
		"{FFD700}Информация",
		"{ffffff}Вы можете приобрести себе VIP статус и получить это:\n\n"\
		"{C0C0C0}SILVER VIP\n"\
		"{FFFFFF}- Просмотр администрации online\n"\
		"{FFFFFF}- Дополнительно {FFA500}+2 слот(ов/а){FFFFFF} для покупки личного транспорта\n"\
		"{FFFFFF}- Возможность починить транспорт без механика (/fix)\n"\
		"{FFFFFF}- Общий игровой чат VIP игроков (/vr)\n"\
		"{FFFFFF}- Возможность посмотреть игроков с VIP online (/viplist)\n\n"\
		"{FFD700}GOLD VIP\n"\
		"{FFFFFF}- Просмотр администрации online\n"\
		"{FFFFFF}- Дополнительно {FFA500}+4 слот(ов/а){FFFFFF} для покупки личного транспорта\n"\
		"{FFFFFF}- Каждый PayDay начисляется по 30 донатных рублей\n"\
		"{FFFFFF}- Каждый PayDay начисляется по 575.000 игровых рублей\n"\
		"{FFFFFF}- Каждый PayDay начисляется по 2 опыта\n\n"\
		"{E5E4E2}PLATINUM VIP\n"\
		"{FFFFFF}- Просмотр администрации online\n"\
		"{FFFFFF}- Дополнительно {FFA500}+7 слот(ов/а){FFFFFF} для покупки личного транспорта\n"\
		"{FFFFFF}- Каждый PayDay начисляется по 75 донатных рублей\n"\
		"{FFFFFF}- Каждый PayDay начисляется по 1.450.000 игровых рублей\n"\
		"{FFFFFF}- Каждый PayDay начисляется по 5 опыта\n",
		"Закрыть", ""
	);
	return 1;
}

cmd:w(playerid, params[])
{
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /w [текст]");


	static fmt_str[128];
	SetPlayerChatBubble(playerid, params, 0xACCE90FF, 3.0, 5000);

	format(fmt_str, sizeof fmt_str, "%s шепчет: %s", GetPlayerNameEx(playerid), params);
	SendMessageInLocal(playerid, fmt_str, 0xACCE90FF, 3.0);

	return 1;
}

cmd:faketext(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(sscanf(params, "us[64]", params[0],params[1])) return SendClientMessage(playerid, 0xFFFFFFF, "Введите: /text [id игрока] [текст]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, 0xFFFFFFF, "[Ошибка] Человек не найден!");
	if(params[0] == INVALID_PLAYER_ID) return true;
	OnPlayerText(params[0], params[1]);
	return 1;
}

cmd:s(playerid, params[])
{
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /s [текст]");

	static fmt_str[128];
	SetPlayerChatBubble(playerid, params, 0xFFFFFFFF, 37.0, 5000);

	format(fmt_str, sizeof fmt_str, "%s[%d] крикнул: %s", GetPlayerNameEx(playerid), playerid, params);
	SendMessageInLocal(playerid, fmt_str, 0xFFFFFFFF, 37.0);

	ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.0, 0, 0, 0, 0, 0, 0);
	return 1;
}

cmd:n(playerid, params[])
{
	if(IsPlayerMuted(playerid))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /n [нон-рп сообщение]");

	static fmt_str[128];
	SetPlayerChatBubble(playerid, params, 0x999999FF, 30.0, 5000);
	
    if(GetPlayerAdminEx(playerid) > 1)
    {
      	format(fmt_str, sizeof fmt_str, "A: {CCCC99}(( %s[%d]: %s ))", GetPlayerNameEx(playerid), playerid, params);
	    SendMessageInLocal(playerid, fmt_str, 0xFFA500FF, 30.0);
	}
	
    if(GetPlayerAdminEx(playerid) < 1)
	{
		format(fmt_str, sizeof fmt_str, "(( %s[%d]: %s ))", GetPlayerNameEx(playerid), playerid, params);
		SendMessageInLocal(playerid, fmt_str, 0xCCCC99FF, 30.0);
	}

	return 1;
}

cmd:pass(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /pass [ID игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	new Float: to_x, Float: to_y, Float: z;
	GetPlayerPos(to_player, to_x, to_y, z);

	if(to_player == playerid)
	{
	    static fmt_text[200];

	    format(fmt_text, sizeof fmt_text, "[[0,[\"%s\",%d,\"Дом\",%d,0,%d,%d,%d,\"\"]]]",
		GetPlayerNameEx(playerid), GetPlayerData(playerid, P_SEX) ? 1 : 0, GetPlayerLevel(playerid), GetPlayerSkin(playerid), GetPlayerData(playerid, P_LAW_ABIDING), 0);

		MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Docs", fmt_text);

		Action(playerid, "просмотривает свой паспорт", _, false);
	}
	else
	{
		new Float: dist = GetPlayerDistanceFromPoint(playerid, to_x, to_y, z);
		if(0.5 <= dist <= 1.5)
		{
			SendPlayerOffer(playerid, to_player, OFFER_TYPE_SHOWPASS);
		}
		else SendClientMessage(playerid, 0xFF6600FF, "* Вы находитесь слишком далеко от игрока");
	}
	return 1;
}

cmd:lic(playerid, params[]) return callcmd::showlic(playerid, params);
cmd:showlic(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /lic [ID игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	new Float: to_x, Float: to_y, Float: z;
	GetPlayerPos(to_player, to_x, to_y, z);

	if(to_player == playerid)
	{
	    static fmt_text[200];

		format(fmt_text, sizeof fmt_text, "[[1,[\"%s\",[%d,%d,%d,1,1]]]]",
		GetPlayerNameEx(playerid), GetPlayerData(playerid, P_DRIVING_LIC), GetPlayerData(playerid, P_DRIVING_LIC) - 1, GetPlayerData(playerid, P_WEAPON_LIC));

		MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Docs", fmt_text);

		Action(playerid, "просмотривает свои лицензии", _, false);
	}
	else
	{
		new Float: dist = GetPlayerDistanceFromPoint(playerid, to_x, to_y, z);
		if(0.5 <= dist <= 1.5)
		{
			SendPlayerOffer(playerid, to_player, OFFER_TYPE_SHOWLIC);
		}
		else SendClientMessage(playerid, 0xFF6600FF, "* Вы находитесь слишком далеко от игрока");
	}
	return 1;
}

cmd:admstats(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, COLOR_GOLD, "Используйте:{"#cW"} /admstats [ID админа]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока  нет");

	if(GetPlayerAdminEx(playerid) < 1) return SendClientMessage(playerid, 0xFF6600FF, "* У игрока нет админ прав");
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	new Float: to_x, Float: to_y, Float: z;
	GetPlayerPos(to_player, to_x, to_y, z);

	if(to_player == playerid)
	{
	    static fmt_text[200];

	    format(fmt_text, sizeof fmt_text, "{"#cW"}Репорты:\t\t%d\nДеморганы:\t\t%d\nБаны:\t\t%d\nКики:\t\t%d\nМуты:\t%d",
		GetPlayerAdmRep(playerid), GetPlayerAdmDm(playerid), GetPlayerAdmBan(playerid), GetPlayerAdmKick(playerid), GetPlayerAdmMute(playerid));
	    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{"#cGold"}Ваша Админ Статистика", fmt_text, "Закрыть", "");

		Action(playerid, "просмотривает свою админ статистику", _, false);
	}
	else
	{
		new Float: dist = GetPlayerDistanceFromPoint(playerid, to_x, to_y, z);
		if(0.5 <= dist <= 1.5)
		{
			SendPlayerOffer(playerid, to_player, OFFER_TYPE_SHOWADMSTATS);
		}
		else SendClientMessage(playerid, 0xFF6600FF, "* Вы находитесь слишком далеко от игрока");
	}
	return 1;
}

cmd:mn(playerid) return callcmd::menu(playerid);
cmd:mm(playerid) return callcmd::menu(playerid);
cmd:mainmenu(playerid) return callcmd::menu(playerid);
cmd:menu(playerid) {LoadMainMenu(playerid, MAIN_MENU_STATS); return 1;}

cmd:help(playerid, params[])
{
	Dialog
	(
		playerid, DIALOG_INFO_HELP, DIALOG_STYLE_LIST,
		"Помощь по игре",
		"1. Информация о проекте\n\
		2. Где заработать денег?\n\
		3. Где получить права на вождение?\n\
		4. Как купить жилье?\n\
		5. Как купить бизнес?\n\
		6. Как купить авто?\n\
		7. Как прокачать уровень?\n\
		8. Как вступить в организацию?\n\
		9. Как стать агентом поддержки/лидером?\n\
		10. Как найти нужное мне место?\n\
		11. Где достать оружие?\n\
		12. Где устроиться на работу?\n\
		13. Как посмотреть команды?\n\
		14. Как добраться до работы?\n\
		15. Где купить телефон и SIM-карту?\n\
		16. Как мне уволиться из фракции?\n\
		17. Как узнать номер телефона игрока?",
		"Далее", "Закрыть"
	);
	return 1;
}

cmd:anim(playerid, params[]) return callcmd::animlist(playerid, params);
cmd:animlist(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "* Анимации нельзя использовать в транспорте");

	if(PreLoadPlayerAnimList(playerid))
		return 1;

	if(!strlen(params))
	{
	/*	Dialog
		(
			playerid, DIALOG_ANIM_LIST, DIALOG_STYLE_LIST,
			"{9966FF}Анимации",
			anim_list_items,
			"Выбрать", "Закрыть"
		);*/
		Dialog
		(
			playerid, DIALOG_ANIM_LIST, DIALOG_STYLE_LIST,
			"{9966FF}Анимации",
			"{00ff00}Информация\n"\
			"1. Приветствие/Прощание\n"\
			"2. Танцы\n"\
			"3. Положение\n"\
			"4. Передвижение\n"\
			"5. Стойки\n"\
			"6. Действие\n"\
			"7. Любов 18+\n"\
			"8. Жесты\n"\
			"9. Питание",
			"Выбрать", "Закрыть"
		);
	}
	else
	{
		extract params -> new category, anim_id;

		if(!SetAnimPlayerNew(playerid, category, anim_id))
			return SendClientMessage(playerid, 0xCECECEFF, "* Используйте /anim(list) [номер категории] [номер анимации из списка]");
	}
	return 1;
}

cmd:e(playerid, params[])
{
	if(g_drag_racing_status[playerid] == 1) return 1;

	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsABike(vehicleid))
	{
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "* Вы не за рулем");

		if(IsAOwnableCar(vehicleid))
		{
			new index = GetVehicleData(vehicleid, V_ACTION_ID);
			if(!GetOwnableCarData(index, OC_KEY_IN))
			{
			   return GameText(playerid, "~r~КЛЮЧИ НЕ ВСТАВЛЕНЫ", 1200, 6);
			}
			if(GetOwnableCarData(index, OC_BY_ID) != 0)
			{
			    return 1;
			}
		}
		else if(IsAJobCar(vehicleid))
		{
			if(GetPlayerJobCar(playerid) != vehicleid)
			{
				return RemovePlayerFromVehicle(playerid);
			}
		}

		if(GetVehicleData(vehicleid, V_FUEL) <= 0.0)
           return GameText(playerid, "~r~нет бензина", 4000, 2);

		if(GetVehicleData(vehicleid, V_IZNOS) > 99) return GameText(playerid, "~r~Двигатель изношен~n~завести его не получится", 3000, 3);

		new engine = (GetVehicleParam(vehicleid, V_ENGINE) ^ VEHICLE_PARAM_ON);
		SetVehicleParam(vehicleid, V_ENGINE, engine);

		if(GetVehicleParam(vehicleid, V_ENGINE) ^ VEHICLE_PARAM_OFF)
		{
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "playSound('sounds/car/start_engine_car.wav', 0, 1)");
			GameText(playerid, "~g~ДВИГАТЕЛЬ ЗАВОДИТСЯ...", 1000, 3);
		}
	}
	return 1;
}

cmd:l(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsABike(vehicleid))
	{
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "* Вы не за рулем");

		new lights = (GetVehicleParam(vehicleid, V_LIGHTS) ^ VEHICLE_PARAM_ON);
		SetVehicleParam(vehicleid, V_LIGHTS, lights);
	}
	return 1;
}

cmd:sl(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsABike(vehicleid))
	{
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "* Вы не за рулем");

		new limit = (GetVehicleData(vehicleid, V_LIMIT) ^ VEHICLE_PARAM_ON);
		SetVehicleData(vehicleid, V_LIMIT, limit);
	}
	return 1;
}

cmd:b(playerid, params[])
{
	if(!IsPlayerDriver(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "* Вы не за рулем");

	Dialog
	(
		playerid, DIALOG_OPEN_HOOD_OR_TRUNK, DIALOG_STYLE_MSGBOX,
		" ",
		"\t{CC9900}Управления авто",
		"Капот", "Багажник"
	);
	return 1;
}

cmd:unrentmoto(playerid)
{
	if(GetPlayerData(playerid, P_RENT_MOPED) == INVALID_VEHICLE_ID) return SendClientMessage(playerid, -1, "* У вас нет арендованного мотоцикла!");
	new veh_id = GetPlayerData(playerid, P_RENT_MOPED);
	{
		DestroyVehicle(veh_id);
	}
	SetPlayerData(playerid, P_RENT_MOPED, INVALID_VEHICLE_ID);
	//SendClientMessage(playerid, -1, "* Вы успешно отказались от аренды мотоцикла");
	return 1;
}
cmd:hpall(playerid,params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
 	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	new Float:ps;

	if(sscanf(params, "fi", ps)) SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /hpall [радиус]");

	if(ps < 20 || ps > 100000) return SendClientMessage(playerid, 0xFF6600FF, "* Радиус от 20 до 100000");

	new Float:pos[3];

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	foreach(new i : Player)
	{
		if(!IsPlayerInRangeOfPoint(i, ps, pos[0], pos[1], pos[2])) continue;
		SetPlayerHealthEx(i, 100);
		SetPlayerData(i, P_HEALTH, 100);
		SendClientMessage(i, COLOR_WHITE, "[Мероприятие] Администратор изменил Вам уровень здоровья");
	}

	SendClientMessage(playerid, COLOR_WHITE, "Вы успешно изменили HP игрокам в радиусе");

	return 1;
}
cmd:alarm(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsABike(vehicleid))
	{
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "* Вы не за рулем");

		new alarm = (GetVehicleData(vehicleid, V_ALARM) ^ VEHICLE_PARAM_ON);
		SetVehicleData(vehicleid, V_ALARM, alarm);
	}
	return 1;
}

cmd:bank(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 35.0, 300.5571,304.2417,1001.0000) || IsPlayerInRangeOfPoint(playerid, 35.0, 418.3971,572.8312,-36.6100)) ShowPlayerBankDialog(playerid);
	return 1;
}

cmd:time(playerid, params[])
{
	static fmt_msg[144];
	if(GetPlayerData(playerid, P_WARN_TIME) > 0)
	{
		format(fmt_msg, sizeof fmt_msg, "{"#cW"}Время до снятия предупреждения: %d дней", ((GetPlayerData(playerid, P_WARN_TIME) - gettime()) / 86400) + 1);
		SendClientMessage(playerid, COLOR_GOLD, fmt_msg);
	}

	if(GetPlayerData(playerid, P_MUTE) > 0)
	{
		format(fmt_msg, sizeof fmt_msg, "{"#cW"}Время до разблокировки чата: %d:%02d", floatround(GetPlayerData(playerid, P_MUTE) / 60) /* % 60 */, (GetPlayerData(playerid, P_MUTE) % 60));
		SendClientMessage(playerid, COLOR_GOLD, fmt_msg);
	}

    if(GetPlayerData(playerid, P_VMUTE) > 0)
	{
		format(fmt_msg, sizeof fmt_msg, "Время до разблокировки VIP чата: %d:%02d", floatround(GetPlayerData(playerid, P_VMUTE) / 60) /* % 60 */, (GetPlayerData(playerid, P_VMUTE) % 60));
		SendClientMessage(playerid, 0x66CC00FF, fmt_msg);
	}

	if(GetPlayerData(playerid, P_JAIL) > 0)
	{
		format(fmt_msg, sizeof fmt_msg, "{"#cW"} {7CFC00}Время до выхода на свободу: %d:%02d", floatround(GetPlayerData(playerid, P_JAIL) / 60) /* % 60 */, (GetPlayerData(playerid, P_JAIL) % 60));
		SendClientMessage(playerid, COLOR_GOLD, fmt_msg);
	}
	
	if(GetPlayerData(playerid, P_ARREST) > 0)
	{
		format(fmt_msg, sizeof fmt_msg, "{"#cW"}Время до конца заключения: %d:%02d", floatround(GetPlayerData(playerid, P_ARREST) / 60) /* % 60 */, (GetPlayerData(playerid, P_ARREST) % 60));
		SendClientMessage(playerid, COLOR_GOLD, fmt_msg);
	}

	if(GetPlayerData(playerid, P_RMUTE) > 0)
	{
		format(fmt_msg, sizeof fmt_msg, "{"#cW"}Время до разблокировки репорта: %d:%02d", floatround(GetPlayerData(playerid, P_RMUTE) / 60) /* % 60 */, (GetPlayerData(playerid, P_RMUTE) % 60));
		SendClientMessage(playerid, COLOR_GOLD, fmt_msg);
	}

	return 1;
}

cmd:id(playerid, params[])
{
    if(!strlen(params))
        return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /id [имя или часть имени/id игрока]");

    static fmt_str[200], highlighted_name[96], pname[MAX_PLAYER_NAME];

    if(params[0] >= '0' && params[0] <= '9')
    {
        new targetid = strval(params);

        if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
            return SendClientMessage(playerid, 0x999999FF, "Такого игрока нета");

        GetPlayerName(targetid, pname, sizeof(pname));

        format(fmt_str, sizeof fmt_str, "%s, ID: %d, уровень: %d, PING: %d, клиент: "SERVER_CLIENT"",
            pname, targetid, GetPlayerLevel(targetid), GetPlayerPing(targetid));
        SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

        return 1;
    }
    new count, len = strlen(params);
    foreach(new idx : Player)
    {
        if(!IsPlayerLogged(idx)) continue;

        GetPlayerName(idx, pname, sizeof(pname));

        new match_pos = strfind(pname, params, true);
        if(match_pos != -1)
        {
            highlighted_name[0] = EOS;
            strmid(highlighted_name, pname, 0, match_pos);
            format(highlighted_name, sizeof highlighted_name, "%s{E8D592}%.*s{FFFFFF}", highlighted_name, len, pname[match_pos]);
            format(highlighted_name, sizeof highlighted_name, "%s%s", highlighted_name, pname[match_pos + len]);
            format(fmt_str, sizeof fmt_str, "%d. %s, ID: %d, уровень: %d, PING: %d, клиент: "SERVER_CLIENT"",
                count + 1, highlighted_name, idx, GetPlayerLevel(idx), GetPlayerPing(idx));
            SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

            count ++;
            if(count >= 5)
            {
                SendClientMessage(playerid, 0x999999FF, "Показаны первые 5 совпадений");
                break;
            }
        }
    }

    if(!count) SendClientMessage(playerid, 0x999999FF, "Совпадений не найдено");
    return 1;
}
cmd:no(playerid, params[])
{
	MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Offer");

	new offer_id = GetPlayerOfferInfo(playerid, O_INCOMING_PLAYER);

	if(offer_id != INVALID_PLAYER_ID)
	{
		if(GetPlayerOfferInfo(offer_id, O_OUTCOMIG_PLAYER) == playerid)
		{
			ClearPlayerOffer(offer_id);

			static fmt_str[64];
			format(fmt_str, sizeof fmt_str, "%s отказался от Вашего предложения", GetPlayerNameEx(playerid));
			SendClientMessage(offer_id, 0xFF6600FF, fmt_str);

			format(fmt_str, sizeof fmt_str, "Вы отказались от предложения игрока %s", GetPlayerNameEx(offer_id));
			SendClientMessage(playerid, 0xFF6600FF, fmt_str);

			GameText(offer_id, "~r~нет", 4000, 2);
		}
		else SendClientMessage(playerid, 0xFF6600FF, "* Вы отказались от предложения игрока");
	}
	else SendClientMessage(playerid, 0x999999FF, "* В данный момент Вам ничего не предлагают");

	ClearPlayerOffer(playerid);
	return 1;
}
cmd:exchange(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid,10.0,503.3536,452.3311,1000.9922)) return 1;

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Использовать: /exchange [id игрока]");
	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Введите корректный ид покупателя");

	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(to_player, X, Y, Z);

	if(!IsPlayerInRangeOfPoint(playerid, 10.0, X, Y, Z)) 
		return SCM(playerid, 0xFF5533FF, "Вы должны находиться ближе друг к другу!");

	if(g_player_notary_status[playerid] > 0) 
		return SCM(playerid, 0xFF5533FF, "Вы уже обмениваетесь с кем-то.");

	if(g_player_notary_status[to_player] > 0) 
		return SCM(playerid, 0xFF5533FF, "Игрок уже обменивается с кем-то.");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_EXCHANGE);

	SCM(playerid, 0xf9a118FF, "Уведомление: {FFFFFF}Вы согласились на обмен. Ждём подтверждения второго игрока");

  	return 1;
}
//cmd:start(playerid) return Kick(playerid);

cmd:crash(playerid,params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    	else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");
    
	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	if(sscanf(params,"i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "* Используйте: /crash [id игрока]");
	if(GetPlayerAdminEx(playerid) < GetPlayerAdminEx(params[0])) return SCM(playerid, -1, "* Вы не моежете крашнуть игрока выше вас по рангу");
    ApplyAnimation(params[0], "PAD", "null",6,0,0,0,1,1);
    SendClientMessage(playerid, -1, "* Игрок был успешно крашнут.");
    return 1;
}
cmd:sendvolume(playerid, params[])
{
	extract params -> new volume;

	new
		BitStream:bsn = BS_New();

	BS_WriteValue(bsn, PR_UINT8, 215);
	BS_WriteValue(bsn, PR_UINT16, 6);
	BS_WriteValue(bsn, PR_UINT8, 100);

	PR_SendPacket(bsn, playerid);
	BS_Delete(bsn);
}
cmd:setbizwar(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;

	extract params -> new biz_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /setbizwar [номер бизнеса]");

	if(!(0 <= biz_id <= g_business_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного бизнеса не существует на сервере");

    static query[244];
	format(query, sizeof query, "UPDATE business SET `gang` = '0' WHERE `id` = '%d'", GetBusinessData(biz_id, B_SQL_ID));
	mysql_query(mysql, query, false);
	SetBusinessData(biz_id, B_GANG, 0);
	CallLocalFunction("UpdateBusinessLabel", "i", biz_id);
	SendClientMessage(playerid, 0xCECECEFF, "* Вы убрали крышу у данного биза.");
	return 1;
}
cmd:gang_spawn(playerid)
{
    if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не состоите в семье");
	if(GetPlayerData(playerid, P_FAMILY_RANK) != 10) return SendClientMessage(playerid, 0xCECECEFF, "* Вам недоступна данная функция");
    if(GetPlayerData(playerid, P_NAKOLKA) < 7) return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны иметь ранг-наколку 'Пахан' или выше");
   	
	static fmt_text[2640],
		Cache: result,
		biz_id;

	mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM houses WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, fmt_text, true);

	new rows = cache_num_rows();

	if(!rows) return SendClientMessage(playerid, 0x999999FF, "* У вас не одного дома во владении.");

	static query[256];

	format(fmt_text, sizeof fmt_text, "");
	for(new i = 0; i < rows; i ++)
	{
		biz_id = cache_get_field_content_int(i, "id");

		if(biz_id == GetPlayerData(playerid, P_ID_SPAWN) && GetPlayerData(playerid, P_SPAWN) == 1) format(query, sizeof query, "{FFFFFF}-Дом: %d | (база)\n", biz_id);
		else format(query, sizeof query, "{FFFFFF}-Дом: %d\n", biz_id);

		strcat(fmt_text, query);
		SetPlayerListitemValue(playerid, i, biz_id-1);
	}

	Dialog
	(
		playerid, DIALOG_OWNABLE_HOME_FAMILY, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите дом",
		fmt_text,
		"Выбрать", "Закрыть"
	);

	cache_delete(result);
 	return 1;
}
cmd:gang_create(playerid)
{
	Dialog
	(
	    playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
	    "{FFFF00}Банды теперь нужно создавать на базах Мафии",
 		"\t-{ffffff} Русская Мафия находится около Гарели и Анашана\n\
	    \t-{ffffff} Японская Мафия находится на{ffcc00} Барвихе{ffffff}\n\
		\t-{ffffff} Итальянская Мафия находится в Лыткарино",
		"Закрыть", ""
	);
	return true;
}
cmd:family_delete(playerid)
{
    if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не состоите в семье");
	if(GetPlayerData(playerid, P_FAMILY_RANK) != 10) return SendClientMessage(playerid, 0xCECECEFF, "* Вам недоступна данная функция");
	Dialog(playerid, DIALOG_FAMILY_DELL, DIALOG_STYLE_MSGBOX, "{FFCD00}Подтверждение", "Вы действительно хотите удалить свою семью?", "Да", "Нет");
	return 1;
}

cmd:capture_biz(playerid)
{
	if(GetPlayerFamily(playerid) != 0 && GetPlayerRankFamily(playerid) >= 8)
	{
	    if(kapt == 1) return SendClientMessage(playerid, 0xCECECEFF, "* В данный момент идет борьба за бизнес!");
		new businessid = GetNearestBusiness(playerid, 4.0);
		if(businessid != -1)
		{
		    if(GetFamilyFind(GetPlayerFamily(playerid)) < 3) return SendClientMessage(playerid, 0xCECECEFF, "* Для захвата бизнеса, у вашей банды должно быть 3 человека в сети!");
		    if(g_family[GetPlayerFamily(playerid)][F_GANG] == 0) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет банды, чтобы ее создать подъедьте к одной из особняков мафии");
		    if(g_family[GetPlayerFamily(playerid)][F_KD] == 1) return SendClientMessage(playerid, 0xCECECEFF, "* Недавно у вашей банды был захват бизнеса!");
		    if(GetBusinessData(businessid, B_OWNER_ID) == 0) return SendClientMessage(playerid, 0xCECECEFF, "* Данный бизнес не куплен игроком!");
			if(GetBusinessData(businessid, B_GANG) == GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не можете захватить свой бизнес!");

			if(GetBusinessData(businessid, B_GANG) == 0)
			{
				SetBusinessData(businessid, B_GANG, GetPlayerFamily(playerid));
	            CallLocalFunction("UpdateBusinessLabel", "i", businessid);
				static query[64 + 1];
				format(query, sizeof query, "%s захватили новый бизнес.",g_family[GetPlayerFamily(playerid)][F_NAME]);
				SendFamilysMessage(query);
				format(query, sizeof query, "UPDATE business SET gang=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_GANG), GetBusinessData(businessid, B_SQL_ID));
				mysql_query(mysql, query, false);
				SetFamilyData(GetPlayerFamily(playerid), F_KD,1);
				SetTimerEx("FamilyKaptKd", 1800000, false, "i", GetPlayerFamily(playerid));
			}
			else
			{
			    if(GetFamilyFind(GetBusinessData(businessid, B_GANG)) <= 3) return SendClientMessage(playerid, 0xCECECEFF, "* Для захвата бизнеса, у банды бизнеса должно быть 3 человека в сети!");
			    if(g_family[GetBusinessData(businessid, B_GANG)][F_KD] == 1) return SendClientMessage(playerid, 0xCECECEFF, "* У банды у которой, Вы хотите захватить бизнес недавно был захват!");
			    kapt = 1;
				g_war[W_BIZ] = businessid;
				StartWar(playerid, businessid, GetPlayerFamily(playerid), GetBusinessData(businessid, B_GANG));
			}
		}
	}
	return 1;
}
cmd:gang_car(playerid)
{
    if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не состоите в банде");
	if(GetPlayerData(playerid, P_FAMILY_RANK) != 10) return SendClientMessage(playerid, 0xCECECEFF, "* Вам недоступна данная функция");
	new houseid = g_family[GetPlayerFamily(playerid)][F_HOUSE_ID];
	if(houseid != -1)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 40.0, GetHouseData(houseid, H_POS_X), GetHouseData(houseid, H_POS_Y), GetHouseData(houseid, H_POS_Z)))
	    {
			if(g_family[GetPlayerFamily(playerid)][F_GANG] == 1)
			{
			    new vehicleid1 = GetPlayerOwnableCarLast(playerid);
			    new vehicleid2 = GetFamilyOwnableCarLast(playerid,GetPlayerData(playerid, P_FAMILY));
				new vehicleid = GetPlayerVehicleID(playerid);
    			if(vehicleid == vehicleid1 && vehicleid1 != INVALID_VEHICLE_ID)
				{
				    new fam_id = GetPlayerData(playerid, P_FAMILY);
				    if(GetFamilyCars(fam_id) >= GetFamilyData(fam_id, F_FAMILY_CARS)) return SendClientMessage(playerid, 0xCECECEFF, "* У Вашей банды максимальное кол-во тс.");

				    Dialog(playerid, DIALOG_GANG_CAR_ADD, DIALOG_STYLE_MSGBOX, "{FFCD00}Подтверждение", "Вы действительно хотите использовать данный транспорт для своей банды?", "Да", "Нет");
				}
				else if(vehicleid == vehicleid2 && vehicleid2 != INVALID_VEHICLE_ID)
				{
				    Dialog(playerid, DIALOG_GANG_CAR_DELL, DIALOG_STYLE_MSGBOX, "{FFCD00}Подтверждение", "Вы действительно хотите забрать данный транспорт со своей банды?", "Да", "Нет");
				}
		 	}
		}
		else SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться на базе банды");
	}
	return 1;
}
cmd:fmenu(playerid, params[])
{
	if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не состоите в семье");

	if(g_family[GetPlayerFamily(playerid)][F_GANG] == 0)
	{
	    if(GetPlayerData(playerid, P_FAMILY_RANK) != 10)
	    {
			Dialog
			(
				playerid, DIALOG_FAMILY_MENU, DIALOG_STYLE_LIST,
				"{FFCD00}Меню семьи",
				"1. Состав в игре<n>2. Полный состав<n>3. Информация<n>4. Бюджет<n>",
				"Выбрать", "Закрыть"
			);
		}
		else if(GetPlayerData(playerid, P_FAMILY_RANK) == 10)
		{
			Dialog
			(
				playerid, DIALOG_FAMILY_MENU, DIALOG_STYLE_LIST,
				"{FFCD00}Меню семьи",
				"1. Состав в игре<n>2. Полный состав<n>3. Информация<n>4. Бюджет<n>", //5. Создать банду<n>
				"Выбрать", "Закрыть"
			);
		}
	}
	else
	{
		Dialog
		(
			playerid, DIALOG_GANG_MENU, DIALOG_STYLE_LIST,
			"{FFCD00}Меню банды",
			"1. Состав в игре<n>2. Полный состав<n>3. Информация<n>4. Цвет<n>5. Бизнесы<n>6. Транспорт<n>7. История склада<n>8. Настройка рангов",
			"Выбрать", "Закрыть"
		);
	}
	return 1;
}

cmd:family_leave(playerid, params[])
{
    if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не состоите в семье");
    if(GetPlayerData(playerid, P_FAMILY_RANK) == 10) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не можете покинуть семью, так как вы ее лидер!");
    static fmt_text[215];
    format
    (
        fmt_text, sizeof fmt_text,
        "{FFFFFF}Вы состоите в семье.\n"\
        "Если Вы уволитесь, то потеряете все свои достижения в ней, такие как ранг.\n\n"\
        "Вы уверены, что хотите покинуть семью?"
    );
    Dialog(playerid, DIALOG_FAMILY_LEAVE, DIALOG_STYLE_MSGBOX, "Предупреждение", fmt_text, "Да", "Нет");
    return 1;
}
cmd:fn(playerid, params[])
{
	if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не состоите в семье");
	if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xCECECEFF, "* Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	if(IsPlayerFMuted(playerid) > 0) return SCM(playerid, -1, "* У вас бан семейного чата");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /fn [текст]");

	static fmt_msg[144];

	format(fmt_msg, sizeof fmt_msg, "(( {FF9C18}<%s> %s[%d]: %s {CCCC99}))", GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_NAME), GetPlayerNameEx(playerid), playerid, params);

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, 0xCCCC99FF, fmt_msg);
	}
	return 1;
}
cmd:fm(playerid, params[])
{
	if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не состоите в семье");
	if(IsPlayerFMuted(playerid) > 0) return SCM(playerid, -1, "* У вас бан семейного чата");
	if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xCECECEFF, "* Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /fm [текст]");

	static fmt_msg[144];

	format(fmt_msg, sizeof fmt_msg, "{FF9C18}<%s> %s[%d]: %s", GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_NAME), GetPlayerNameEx(playerid), playerid, params);

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, 0xFFFFFFFF, fmt_msg);
	}
	return 1;
}
cmd:capture(playerid, params[])
{
	if(!(TEAM_MAFIA_RUSSIAN <= GetPlayerTeamEx(playerid) <= TEAM_MAFIA_ITALIAN))
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете использовать это");

	if(GetPlayerJobName(playerid) < 6)
		return SendClientMessage(playerid, 0xFF6600FF, "* Организовывать захват территории можно только с 6-ого ранга");

	if(g_capture[C_STATUS])
		return SendClientMessage(playerid, 0xFF6600FF, "* Дождитесь окончания текущего захвата");

	new gang_id = (GetPlayerTeamEx(playerid) - TEAM_MAFIA_RUSSIAN) + 1;

	if(g_capture[C_WAIT_TIME][gang_id - 1] > gettime())
		return SendClientMessage(playerid, 0xFF6600FF, "* С момента последнего Вашего захвата еще не прошел 1 час");

	new gang_zone_id = -1;

	for(new idx; idx < g_gang_zones_loaded; idx ++)
	{
		if(!IsPlayerInDynamicArea(playerid, GetGangZoneData(idx, GZ_AREA))) continue;

		gang_zone_id = idx;
		break;
	}

	if(gang_zone_id == -1)
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться на захваченной кем-то территории");

	new gang_zone_team = GetGangZoneData(gang_zone_id, GZ_GANG);

	if(!gang_zone_team)
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы должны находиться на захваченной кем-то территории");

	if(gang_zone_team == gang_id)
		return SendClientMessage(playerid, 0xFF6600FF, "* Вы не можете захватить свою территорию");

	if(g_capture[C_WAIT_TIME][gang_zone_team - 1] > gettime())
		return SendClientMessage(playerid, 0xFF6600FF, "* Банда, чью территорию Вы хотите захватить, еще не окрепла с последнего захвата (не прошел 1 час)");

	new gang_players[2];

	foreach(new idx : Player)
	{
		if(GetPlayerTeamEx(idx) == GetPlayerTeamEx(playerid)) gang_players[0] ++;
		else if(GetPlayerTeamEx(idx) == (gang_zone_team - 1) + TEAM_MAFIA_RUSSIAN) gang_players[1] ++;
		else continue;
	}

	if(gang_players[0] < MIN_PLAYERS_FOR_CAPTURE)
		return SendClientMessage(playerid, 0xFF6600FF, "* В Вашей банде должно быть не менее 1-ти людей для захвата");

	if(gang_players[1] < MIN_PLAYERS_FOR_CAPTURE)
		return SendClientMessage(playerid, 0xFF6600FF, "* В банде, территорию которой Вы хотите захватить, должно быть не менее 1-ти людей для захвата");

	StartCapture(playerid, gang_zone_id, gang_id, gang_zone_team);

	return 1;
}
cmd:fwarn(playerid, params[])
{
    new fam_id = fam_id = GetPlayerData(playerid, P_FAMILY),
	    rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

    new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_RANG_WARN);

    if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "* Вам недоступна данная функция");

	if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return SCM(playerid, COR_RED, "[Ошибка]:  У вас не достаточно нужный ранг в семье, чтобы выдавать семейное предупреждение.");

	if(GetPlayerAdminEx(playerid) < 2) return 1;
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /fwarn [id игрока] [причина (необязательно)]");

	extract params -> new to_player, string:reason[66];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

    if(GetPlayerData(to_player, P_FAMILY) != GetPlayerData(playerid, P_FAMILY))
		return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок не состоит в Вашей семье");

	if(GetPlayerData(to_player, P_FAMILY_RANK) >= GetPlayerData(playerid, P_FAMILY_RANK))
		return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя выдать мут заместителю/лидеру семьи");

	AddPlayerData(to_player, P_FWARN, +, 1);

	static fmt_msg[128];

    format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] выдал предупреждение игроку %s [%d|3]. Причина: %s", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), GetPlayerData(to_player, P_FWARN), reason);

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, 0x6699CCFF, fmt_msg);
	}

	new uid = GetPlayerAccountID(to_player);
	new warns = GetPlayerData(to_player, P_FWARN);

	if(warns >= 3)
	{
		SendClientMessage(to_player, 0xFF5533FF, "Вы были исключены из семьи. Причина: 3 варна.");

		format(fmt_msg, sizeof fmt_msg, "UPDATE PlayersMorallwens SET fwarn=0,family=0,family_rank=1 WHERE id=%d", uid);
		mysql_query(mysql, fmt_msg, false);

		SetPlayerData(to_player, P_FWARN, 0);
		SetPlayerData(to_player, P_FAMILY, 0);
	}

	format(fmt_msg, sizeof fmt_msg, "UPDATE PlayersMorallwens SET fwarn=%d WHERE id=%d", warns, uid);
	mysql_query(mysql, fmt_msg, false);

	return 1;
}

cmd:funwarn(playerid, params[])
{
    new fam_id = fam_id = GetPlayerData(playerid, P_FAMILY),
	    rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

    new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_RANG_UNWARN);

    if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "* Вам недоступна данная функция");

	if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return SCM(playerid, COR_RED, "[Ошибка]:  У вас не достаточно нужный ранг в семье, чтобы снимать семейное предупреждение.");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /warn [id игрока] [причина (необязательно)]");

	extract params -> new to_player, string: reason[66];
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(GetPlayerData(to_player, P_FAMILY) != GetPlayerData(playerid, P_FAMILY))
		return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок не состоит в Вашей семье");

    if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя снять варн с самого себя");

	SetPlayerData(to_player, P_FWARN, 		0);
	UpdatePlayerDatabaseInt(to_player, "fwarn", 		0);

	static fmt_msg[128];

    format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] снял все предупреждения с игрока %s. Причина: %s", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), reason);

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, 0x6699CCFF, fmt_msg);
	}

	return 1;
}

cmd:fmute(playerid, params[])
{
	new fam_id = fam_id = GetPlayerData(playerid, P_FAMILY),
	    rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

    new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_RANG_MUTE);

    if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "* Вам недоступна данная функция");

	if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return SCM(playerid, COR_RED, "[Ошибка]:  У вас не достаточно нужный ранг в семье, чтобы выдавать бан семейного чата.");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /fmute [id игрока] [время в минутах] [причина (необязательно)]");

	extract params -> new to_player, mute_time, string: reason[30];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

    if(GetPlayerData(to_player, P_FAMILY) != GetPlayerData(playerid, P_FAMILY))
		return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок не состоит в Вашей семье");

	if(GetPlayerData(to_player, P_FAMILY_RANK) >= GetPlayerData(playerid, P_FAMILY_RANK))
		return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя выдать мут заместителю/лидеру семьи");

	if(!(1 <= mute_time <= 360)) return SendClientMessage(playerid, 0xCECECEFF, "* Время должно быть не меньше 1 и не больше 360 минут");
	if(GetPlayerData(to_player, P_FMUTE) > 0) return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока уже есть мут");

	static fmt_msg[144];

	format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] поставил затычку игроку %s на %d минут. Причина: %s", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), mute_time, reason);

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, 0x6699CCFF, fmt_msg);
	}

	SetPlayerData(to_player, P_FMUTE, mute_time * 60);
	UpdatePlayerDatabaseInt(to_player, "fmute", mute_time * 60);

	SendClientMessage(to_player, 0xCECECEFF, "* Время до окончания бана чата семейного чата: {CCCC00}/time");

	return 1;
}

cmd:funmute(playerid, params[])
{
    new fam_id = fam_id = GetPlayerData(playerid, P_FAMILY),
        rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

    new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_RANG_UNMUTE);

    if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "* Вам недоступна данная функция");

	if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return SCM(playerid, COR_RED, "[Ошибка]:  У вас не достаточно нужный ранг в семье, чтобы снимать бан семейного чата.");


	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /funmute [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

    if(GetPlayerData(to_player, P_FAMILY) != GetPlayerData(playerid, P_FAMILY))
		return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок не состоит в Вашей семье");

    if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя снять затычку с самого себя");

	else if(GetPlayerData(to_player, P_FMUTE) <= 0) return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока нет мута");

	static fmt_msg[144];

	format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] снял затычку с игрока %s", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player));

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, 0x6699CCFF, fmt_msg);
	}

	SetPlayerData(to_player, P_FMUTE, 0);
	UpdatePlayerDatabaseInt(to_player, "fmute", 0);

	SendClientMessage(to_player, 0x32a44bFF, "Доступ в чат восстановлен");

	return 1;
}

cmd:finvite(playerid, params[]) callcmd::invite_gang(playerid, params);
cmd:invite_gang(playerid, params[])
{

	if(GetPlayerData(playerid, P_FAMILY_RANK) < 9) return SCM(playerid, COR_RED, "[Ошибка]:  У вас не достаточно нужный ранг в семье, чтобы приглашать людей в семью.");

	if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "* Вам недоступна данная функция");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /invite_gang [id игрока]");

	extract params -> new to_player;
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");
	if(GetPlayerData(to_player, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок уже состоит в семье");
	if(GetPlayerData(to_player, P_WARN)) return SendClientMessage(playerid, 0xFF6600FF, "* У игрока есть предупреждение");
	if(1 <= GetPlayerTeamEx(to_player) <= 10) return SendClientMessage(playerid, 0xCECECEFF, "* Игрок состоит в организации");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 10.0)) return SendClientMessage(playerid, 0xCECECEFF, "* Игрок находится слишком далеко");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_FINVITE);
	return 1;
}

cmd:funinvite(playerid, params[])
{

	if(GetPlayerData(playerid, P_FAMILY_RANK) < 9) return SCM(playerid, COR_RED, "[Ошибка]:  У вас не достаточно нужный ранг в семье, чтобы увольнять людей с семьи.");

	if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "* Вам недоступна данная функция");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /funinvite [id игрока] [причина]");

	extract params -> new to_player, string:reason[32];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");

	if(!(1 <= strlen(reason) <= 32))
		return SendClientMessage(playerid, 0xCECECEFF, "* Введите причину увольнения");

	if(GetPlayerData(to_player, P_FAMILY) != GetPlayerData(playerid, P_FAMILY))
		return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок не состоит в Вашей семье");

	if(GetPlayerData(to_player, P_FAMILY_RANK) >= GetPlayerData(playerid, P_FAMILY_RANK))
		return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя уволить уволить заместителя/лидера организации");

	FUnInvite(playerid, to_player, reason);

	return 1;
}

cmd:family_rank(playerid, params[]) callcmd::frang(playerid, params);
cmd:frang(playerid, params[])
{
	if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "* Вам недоступна данная функция");

	new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_RANG_GIVER);

	if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return SCM(playerid, COR_RED, "[Ошибка]:  У вас не достаточно нужный ранг в семье, чтобы изменять ранги в семье.");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /frang [id игрока] [ранг]");
	extract params -> new to_player, give_rang;
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "* Такого игрока нет");
	if(GetPlayerData(to_player, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "* Этот игрок не состоит в Вашей семье");
	if(GetPlayerData(to_player, P_FAMILY_RANK) >= GetPlayerData(playerid, P_FAMILY_RANK)) return SendClientMessage(playerid, 0xCECECEFF, "* Нельзя уволить уволить заместителя/лидера организации");
	if(1 > give_rang > 9) return SendClientMessage(playerid, 0xCECECEFF, "* Ранг от 1 до 9");

	static fmt_msg[144];

	SetPlayerData(to_player, P_FAMILY_RANK, give_rang);
	format(fmt_msg, sizeof fmt_msg, "Ваш ранг в семье был изменен на %d (%s)", GetPlayerData(to_player, P_FAMILY_RANK), GetFamilyRang(GetPlayerData(to_player, P_FAMILY), GetPlayerData(to_player, P_FAMILY_RANK)));
	SendClientMessage(to_player, 0x1E90FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы изменили ранг %s[%d] до %d (%s)",  GetPlayerNameEx(to_player), to_player, GetPlayerData(to_player, P_FAMILY_RANK), GetFamilyRang(GetPlayerData(to_player, P_FAMILY), GetPlayerData(to_player, P_FAMILY_RANK)));
	SendClientMessage(playerid, 0x1E90FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "UPDATE PlayersMorallwens SET family_rank=%d WHERE id=%d", GetPlayerData(to_player, P_FAMILY_RANK), GetPlayerAccountID(to_player));
	mysql_query(mysql, fmt_msg, false);

	return 1;
}
cmd:close(playerid, params[])
{
	if(GetPlayerFamily(playerid) != 0 && GetFamilyData(GetPlayerFamily(playerid),F_GANG) == 1)
	{
	    if(GetPlayerRankFamily(playerid) < 9) return SendClientMessage(playerid, 0x999999FF, "* Открывать или закрывать склад можно с 9-ого ранга");
	    new fam_id = GetPlayerFamily(playerid);
	    if(GetFamilyData(fam_id, F_SKLAD_ST) == 0) SetFamilyData(fam_id,F_SKLAD_ST,1);
		else SetFamilyData(fam_id,F_SKLAD_ST,0);
	    static query[60];
        format(query, sizeof query, "UPDATE family SET skladst=%d WHERE id=%d LIMIT 1",GetFamilyData(fam_id, F_SKLAD_ST), g_family[fam_id][F_SQL_ID]);
		mysql_query(mysql, query, false);


		format(query, sizeof query, "%s [%d] %s {66CC00}склад банды", GetPlayerNameEx(playerid),playerid,GetFamilyData(fam_id, F_SKLAD_ST) ? "{FF6600}закрыл" : "{33AA33}открыл");

		foreach(new i: Player)
		{
			if(!IsPlayerConnected(i)) continue;
			if(!IsPlayerLogged(i)) continue;
			if(GetPlayerData(i, P_FAMILY) == 0) continue;
			if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

			if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

			SendClientMessage(i, 0x66CC00FF, query);
		}

		CallLocalFunction("UpdateGangSklad", "i", fam_id);

	}
	else
	{
		if(!(TEAM_MAFIA_RUSSIAN <= GetPlayerTeamEx(playerid) <= TEAM_MAFIA_ITALIAN))
			return SendClientMessage(playerid, 0x999999FF, "* Вы не можете использовать это");

		if(GetPlayerJobName(playerid) < 8)
			return SendClientMessage(playerid, 0x999999FF, "* Открывать или закрывать склад можно с 8-ого ранга");

		new repository = GetPlayerTeamEx(playerid) - TEAM_MAFIA_RUSSIAN,
			fmt_text[70];

		SetGangRepositoryData(repository, GR_LOCK, GetGangRepositoryData(repository, GR_LOCK) ^ true);

		UpdateGangRepository(repository);

		format(fmt_text, sizeof fmt_text, "[Внимание] Склад был %s игроком %s[%d]",
		GetGangRepositoryData(repository, GR_LOCK) ? "открыт" : "закрыт", GetPlayerNameEx(playerid), playerid);

		SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_text, GetGangRepositoryData(repository, GR_LOCK) ? 0x66CC00FF : 0xFF6600FF);
	}

	return 1;
}
cmd:dice(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 203.9476,-288.0615,1011.7900)) DiceTable[playerid] = 1; // 1
	else if(IsPlayerInRangeOfPoint(playerid, 2.5, 204.5841,-282.9256,1011.7900)) DiceTable[playerid] = 2; // 2
	else if(IsPlayerInRangeOfPoint(playerid, 2.5, 201.1470,-277.1536,1011.7900)) DiceTable[playerid] = 3; // 3
	else if(IsPlayerInRangeOfPoint(playerid, 2.5, 197.9208,-280.2674,1011.7900)) DiceTable[playerid] = 4; // 4
	else if(IsPlayerInRangeOfPoint(playerid, 2.5, 198.1707,-285.5460,1011.7900)) DiceTable[playerid] = 5; // 5
	else if(IsPlayerInRangeOfPoint(playerid, 2.5, 197.7222,-291.1371,1011.7900)) DiceTable[playerid] = 6; // 6
	else DiceTable[playerid] = 0;

	if(DiceTable[playerid] == 0) return 1;
	if(s_dice[DiceTable[playerid]][DICE_GAME_STATUS] == 2) return SCM(playerid, COLOR_GREY, "* Игра уже началась. Дождитесь окончания");
	MoralPacket_2(playerid, s_CefInterface, t_CefShow, "CasinoDice", "{\"windows\":{\"queries\":true,\"game\":false,\"action\":false}}");

	DiceTrowPlayerStatus[playerid] = 0;

	return 1;
}
cmd:garden_slot(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


 	extract params -> new to_player, slots; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /garden_slot [id игрока] [кол-во слотов]");
	static string[1024], str[1024];
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!(0 <= slots <= 15)) return SendClientMessage(playerid, 0xCECECEFF, "* Уровень от 0 до 15");

	AddPlayerData(to_player, P_GARDEN_SLOTS, +, slots);
	UpdatePlayerDatabaseInt(to_player, "garden_slots", GetPlayerData(to_player, P_GARDEN_SLOTS));

	format(string, sizeof(string), "A: Адмнистратор %s[%d] добавил игроку %s[%d] %d слотов под огород", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, slots);
	SendMessageToAdmins(string, 0xFFFF00FF);

	format(str, sizeof(str), "A: Адмнистратор %s[%d] добавил вам %d слотов под огород", GetPlayerNameEx(playerid), playerid, slots);
	SendClientMessage(to_player, -1, str);

	return 1;
}
cmd:garden(playerid)
{
	new garden = GetNearestGarden(playerid, 6.0);
	if(garden != -1)
	{
	    if(GetGardenData(garden,G_OWNER_ID) != GetPlayerAccountID(playerid)) return GameText(playerid, "~r~Недоступно", 3000, 2);

		SetPlayerCameraPos(playerid, GetGardenData(garden, G_POS_X) + 3.78888, GetGardenData(garden, G_POS_Y) + 0.41373, GetGardenData(garden, G_POS_Z) + 1);
		SetPlayerCameraLookAt(playerid, GetGardenData(garden, G_POS_X), GetGardenData(garden, G_POS_Y), GetGardenData(garden, G_POS_Z));

		SetPVarInt(playerid, "garden_id",garden);

		new idgarden;
		if(GetGardenData(garden, G_IMPROVEMENTS) < 3) idgarden = 10;
		if(GetGardenData(garden, G_IMPROVEMENTS) == 3) idgarden = 14;
		if(GetGardenData(garden, G_IMPROVEMENTS) == 4) idgarden = 20;

		STRING_GLOBAL[0] = EOS;
		for(new i; i < idgarden; i ++)
		{
			if(G_STATUS_YAM[garden][i] == 0) continue;

			if(G_TYPE_YAM[garden][i] == 1) strcat(STRING_GLOBAL, "[\"Помидоры\", 1],");
			if(G_TYPE_YAM[garden][i] == 2) strcat(STRING_GLOBAL, "[\"Огурцы\", 1],");
			if(G_TYPE_YAM[garden][i] == 3) strcat(STRING_GLOBAL, "[\"Марихуанна\", 1],");
			if(G_TYPE_YAM[garden][i] == 4) strcat(STRING_GLOBAL, "[\"Картофель\", 1],");
			if(G_TYPE_YAM[garden][i] == 5) strcat(STRING_GLOBAL, "[\"Свёкла\", 1],");
			if(G_TYPE_YAM[garden][i] == 6) strcat(STRING_GLOBAL, "[\"Перец\", 1],");
			if(G_TYPE_YAM[garden][i] == 7) strcat(STRING_GLOBAL, "[\"Баклажан\", 1],");
			if(G_TYPE_YAM[garden][i] == 8) strcat(STRING_GLOBAL, "[\"Капуста\", 1],");
			if(G_TYPE_YAM[garden][i] == 9) strcat(STRING_GLOBAL, "[\"Морковь\", 1],");
		}

		strdel(STRING_GLOBAL, strlen(STRING_GLOBAL) - 1, strlen(STRING_GLOBAL));

		format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[%d, [%s], %d, [[0,5000000],[1,15000000],[2,20000000],[3,30000000]]]", GetGardenData(garden, G_LOCK_STATUS), STRING_GLOBAL, GetGardenData(garden, G_IMPROVEMENTS));
		MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Gardens", STRING_GLOBAL);

	}
	else SendClientMessage(playerid, 0xFFDF87FF, "Вы должны находиться возле огорода");

	return true;
}
cmd:asellgarden(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");
	if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");

    extract params -> new garden; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /asellgarden [номер огорода]");

	if(!(0 <= garden <= g_garden_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного огорода не существует на сервере");
	static query[256];
    
	DestroyDynamic3DTextLabel(gardendvlabel[garden]);
	DestroyDynamicObject(gardenobj_1[garden]);
	DestroyDynamic3DTextLabel(gardenobj_1_label[garden]);
	DestroyDynamicObject(gardenobj_2[garden]);
	DestroyDynamicObject(gardendver[garden]);
	DestroyDynamicObject(gardenobj[garden]);

	gardendver[garden] = CreateDynamicObject(16563, GetGardenData(garden, G_POS_X) + 2.97934, GetGardenData(garden, G_POS_Y) + 0.393404, GetGardenData(garden, G_POS_Z) + -0.000461,   0.00000, 0.00000, 0.00000);
	gardenobj[garden] = CreateDynamicObject(16562, GetGardenData(garden, G_POS_X), GetGardenData(garden, G_POS_Y), GetGardenData(garden, G_POS_Z),   0.00000, 0.00000, 0.0);
	gardendvlabel[garden] = CreateDynamic3DTextLabel("{FFA500}Двери теплицы", -1, GetGardenData(garden, G_POS_X) + 2.97934, GetGardenData(garden, G_POS_Y) + 0.393404, GetGardenData(garden, G_POS_Z) + 1, 2.0);

	if(GetGardenData(garden, G_IMPROVEMENTS) == 3)
	{
		for(new i = 0; i < 14; i ++)
		{
			DestroyDynamic3DTextLabel(gardendyamkalab[garden][i]);
		}
		for(new i = 0; i < 10; i ++)
		{
			gardendyamkalab[garden][i] = CreateDynamic3DTextLabel("{FFA500}Свободная ямка\n{FFFFFF}Нажмите {FFA500}ALT {FFFFFF}для посадки", -1, GetGardenData(garden, G_POS_X) + GardenGryadka_1[i][0], GetGardenData(garden, G_POS_Y) + GardenGryadka_1[i][1], GetGardenData(garden, G_POS_Z) + GardenGryadka_1[i][2] + 1, 2.0);
		}
	}
	if(GetGardenData(garden, G_IMPROVEMENTS) == 4)
	{
		for(new i = 0; i < 20; i ++)
		{
			DestroyDynamic3DTextLabel(gardendyamkalab[garden][i]);
		}
		for(new i = 0; i < 10; i ++)
		{
			gardendyamkalab[garden][i] = CreateDynamic3DTextLabel("{FFA500}Свободная ямка\n{FFFFFF}Нажмите {FFA500}ALT {FFFFFF}для посадки", -1, GetGardenData(garden, G_POS_X) + GardenGryadka_1[i][0], GetGardenData(garden, G_POS_Y) + GardenGryadka_1[i][1], GetGardenData(garden, G_POS_Z) + GardenGryadka_1[i][2] + 1, 2.0);
		}
	}

	SetGardenData(garden, G_IMPROVEMENTS,	0);
    SetGardenData(garden, G_OWNER_ID,		0);
	SetGardenData(garden, G_RENT_DATE,		0);
	SetGardenData(garden, G_LOCK_STATUS,	false);
	format(query, sizeof query, "UPDATE gardens SET owner_id=0,g_lock=0,improvements=0,owner_name='None' WHERE id=%d", GetGardenData(garden, G_SQL_ID));
	mysql_query(mysql, query, false);

	format(g_garden[garden][G_OWNER_NAME], 21, "Государство", 0);
	CallLocalFunction("UpdateGardenLabel", "i", garden);
	return 1;
}
cmd:addgarden(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new price, rent_price; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /addgarden [цена] [цена аренды]");
	
	new
		Float:x,
		Float:y,
		Float:z;
	GetPlayerPos(playerid, x, y, z);
	EditObjectPlayer[playerid] = CreateDynamicObject(16562, x, y, z, 0, 0, 0);
	EditDynamicObject(playerid, EditObjectPlayer[playerid]);
	SetPVarInt(playerid, "create_garden", 1);
	SetPVarInt(playerid, "price", price);
	SetPVarInt(playerid, "rent_price", rent_price);
	return 1;
}

cmd:gotogarden(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 3 && GetPlayerBuyAdminEx(playerid) < 3) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new garden; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /togar [номер огорода]");

	if(!(0 <= garden <= g_garden_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного огорода не существует на сервере");

	SetPlayerPos
	(
		playerid,
		GetGardenData(garden, G_POS_X),
		GetGardenData(garden, G_POS_Y),
		GetGardenData(garden, G_POS_Z)+1
	);

	static fmt_text[35];

	format(fmt_text, sizeof fmt_text, "Вы телепортировались к огороду №%d", garden);
	SendClientMessage(playerid, -1, fmt_text);

	return 1;
}

cmd:sellgarden(playerid) SCM(playerid, 0xFFFFFFFF, "Используйте команду /garden для продажи огорода");

cmd:buygarden(playerid, params[])
{
	new garden = GetNearestGarden(playerid, 6.0);
	if(garden != -1)
	{
		if(GetPlayerOwnableGarden(playerid) + 1 > GetPlayerGardenSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "* Вы уже имеете максимально количество огородов.");

	    if(GetGardenData(garden, G_STATUS) == -1)
	    {
			SetPVarInt(playerid, "buy_biz_id", garden);
			static fmt_str[376];

			format
			(
				fmt_str, sizeof fmt_str,
				"{FFFFFF}Огород: {FFA500}№%d\n\
				{FFFFFF}Стоимость: {FFA500}%s {FFFFFF} руб",
				garden,
				formatInt(GetGardenData(garden, G_PRICE))
			);

			Dialog(playerid, DIALOG_GARDEN_BUY, DIALOG_STYLE_MSGBOX, "{33AACC}Покупка огорода", fmt_str, "Купить", "Закрыть");
		}
		else
		{
			new houseid = GetNearestHouse(playerid, 25.0);
			if(houseid != -1) if(GetHouseData(houseid, H_OWNER_ID) != GetPlayerAccountID(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не можете купить данный огород, данный огород может только купить владелец дома.");
			SetPVarInt(playerid, "buy_biz_id", garden);
			static fmt_str[376];

			format
			(
				fmt_str, sizeof fmt_str,
				"{FFFFFF}Огород: {FFA500}№%d\n\
				{FFFFFF}Стоимость: {FFA500}%s {FFFFFF} руб",
				garden,
				formatInt(GetGardenData(garden, G_PRICE))
			);

			Dialog(playerid, DIALOG_GARDEN_BUY, DIALOG_STYLE_MSGBOX, "{33AACC}Покупка огорода", fmt_str, "Купить", "Закрыть");
		}
	}
	else SendClientMessage(playerid, 0xFFDF87FF, "Вы должны находиться на огороде который хотите приобрести");

	return 1;
}

cmd:sellmygarden(playerid,params[])
{
	new garden = GetNearestGarden(playerid, 7.0);
	if(garden != -1)
	{
	    if(GetGardenData(garden,G_OWNER_ID) == GetPlayerAccountID(playerid))
	    {
			if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, 0xCECECEFF, "* Продавать огород можно только с {99ff00}2{CECECE} уровня");
			if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /sellmygarden [id игрока] [стоимость]");
			extract params -> new to_player, price;

			if(!GetILPlayerInt(GetPlayerMoneyEx(to_player), price))
				return SendClientMessage(playerid, 0xCECECEFF, "* У этого игрока нет такой суммы");

			if(GetPlayerOwnableGarden(to_player) + 1 > GetPlayerGardenSlots(to_player)) 
				return SendClientMessage(playerid, 0x3399FFFF, "* Игрок уже имеете максимально количество огородов.");

			if(IsPlayerInRangeOfPoint(playerid, 7.0, GetGardenData(garden, G_POS_X), GetGardenData(garden, G_POS_Y), GetGardenData(garden, G_POS_Z)) && IsPlayerInRangeOfPoint(to_player, 7.0, GetGardenData(garden, G_POS_X), GetGardenData(garden, G_POS_Y), GetGardenData(garden, G_POS_Z)))
			{
				SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_GARDEN,garden, price);
			}
			else SendClientMessage(playerid, 0xCECECEFF, "* Вы и покупатель должны находиться около огорода");
  		}
	}
	else SCM(playerid, COLOR_GREY, "* Вы должны быть возле вашего огорода.");
	
	return 1;
}
cmd:sellmystall(playerid, params[])
{
	if(GetPlayerLevel(playerid) < 2)
		return SendClientMessage(playerid, 0xFF6600FF, "* Этим можно пользоваться со 2 уровня");
		
    if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /sellmystall [id игрока] [стоимость]");

	extract params -> new to_player, price;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xFF6600FF, "* Такого игрока нет");

	if(price < 1)
		return SendClientMessage(playerid, 0xFF6600FF, "* Укажите стоимость продажи");

	if(!GetILPlayerInt(GetPlayerMoneyEx(to_player), price))
		return SendClientMessage(playerid, 0xFF6600FF, "* У покупателя нет такого количества средств");

	static fmt_text[2640],
		Cache: result,
		kiosk_id;

	mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM kiosk WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, fmt_text, true);

	new rows = cache_num_rows();

	if(!rows)
		return SendClientMessage(playerid, 0x999999FF, "* У вас не одного киоска во владении.");

	SetPVarInt(playerid, "to_player", to_player);
	SetPVarInt(playerid, "price", price);
	
	static query[256];
	format(fmt_text, sizeof fmt_text, "");
	for(new i = 0; i < rows; i ++)
	{
		kiosk_id = cache_get_field_content_int(i, "id");

		format(query, sizeof query, "{FFFFFF}Киоск №%d\n", kiosk_id);
		strcat(fmt_text, query);
		SetPlayerListitemValue(playerid, i, kiosk_id-1);
	}
	Dialog
	(
		playerid, DIALOG_SELL_MYSTALL, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите киоск",
		fmt_text,
		"Выбрать", "Закрыть"
	);
	cache_delete(result);
	return 1;
}
cmd:stall(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3 && GetPlayerBuyAdminEx(playerid) < 3) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new kiosk_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /kiosk [номер киоска]");

	if(!(0 <= kiosk_id <= g_kiosk_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного киоска не существует на сервере");

	SetPlayerPos
	(
		playerid,
		GetKioskData(kiosk_id, K_POS_X),
		GetKioskData(kiosk_id, K_POS_Y),
		GetKioskData(kiosk_id, K_POS_Z)
	);

	static fmt_text[35];
	format(fmt_text, sizeof fmt_text, "Вы телепортировались к киоску №%d", kiosk_id);
	SendClientMessage(playerid, -1, fmt_text);
	return 1;
}
cmd:changestallname(playerid)
{
    new kiosk_id = GetNearestKiosk(playerid, 7.0);
	if(kiosk_id == -1) return SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находится возле своего киоска.");

	static fmt[148]; 
	format(fmt, sizeof fmt, "{ffffff}Текущее название: '%s'\nЕсли хотите изменить его, введите новое название в поле ниже.", GetKioskData(kiosk_id, K_NAME));
	Dialog(playerid, DIALOG_KIOSK_NAME, DIALOG_STYLE_INPUT,"Название киоска", fmt,"Готово", "Закрыть");
	return 1;
}

cmd:sellstall(playerid)
{
    static fmt_text[2640],
		Cache: result,
		biz_id;
		
    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM kiosk WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, fmt_text, true);

	new rows = cache_num_rows();

	if(!rows)
		return SendClientMessage(playerid, 0x999999FF, "* У вас не одного киоска во владении.");

	static query[256];
	format(fmt_text, sizeof fmt_text, "");
	for(new i = 0; i < rows; i ++)
	{
		biz_id = cache_get_field_content_int(i, "id");

		format(query, sizeof query, "{FFFFFF}Киоск №%d\n", biz_id);
		strcat(fmt_text, query);
		SetPlayerListitemValue(playerid, i, biz_id-1);
	}
	Dialog
	(
		playerid, DIALOG_KIOSK_SELL_LIST, DIALOG_STYLE_LIST,
		"{FFCD00}Выберите киоск",
		fmt_text,
		"Выбрать", "Закрыть"
	);

	cache_delete(result);
	return 1;
}
cmd:kiosk_slot(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

 	extract params -> new to_player, slots; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /kiosk_slot [id игрока] [кол-во слотов]");
	static string[1024], str[1024];
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "* Такого игрока нет");

	if(!(0 <= slots <= 15)) return SendClientMessage(playerid, 0xCECECEFF, "* Уровень от 0 до 15");

	AddPlayerData(to_player, P_KIOSK_SLOTS, +, slots);
	UpdatePlayerDatabaseInt(to_player, "kiosk_slots", GetPlayerData(to_player, P_KIOSK_SLOTS));

	format(string, sizeof(string), "A: Адмнистратор %s[%d] добавил игроку %s[%d] %d слотов под киоск", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, slots);
	SendMessageToAdmins(string, 0xFFFF00FF);

	format(str, sizeof(str), "A: Адмнистратор %s[%d] добавил вам %d слотов под киоск", GetPlayerNameEx(playerid), playerid, slots);
	SendClientMessage(to_player, -1, str);

	return 1;
}
cmd:givecase(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    	return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) 
		return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new to_player, random111, type;
	if(isnull(params)) return SCM(playerid, 0xCECECEFF, "* /givecase [ид игрока] [кол-во] [тип]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) 
		return SCM(playerid, 0xCECECEFF, "* Такого игрока нет");
	
	if(random111 > 100 || random111 < 1) 
		return SCM(playerid, 0xCECECEFF, "* Нельзя выдавать более 100 кейсов или менее 1 кейса за раз!");
	
	new case_name[32];
	if(type == 1) { GiveIteam(to_player, 258, 1, random111, 0); case_name = "Кейс 'Форсаж'"; }
	else if(type == 2) { GiveIteam(to_player, 261, 1, random111, 0); case_name = "Кейс 'Темные дела'"; }
	else if(type == 3) { GiveIteam(to_player, 272, 1, random111, 0); case_name = "Кейс 'Велесова ночь'"; }
	else if(type == 4) { GiveIteam(to_player, 278, 1, random111, 0); case_name = "Кейс 'Оперской'"; }
	else if(type == 5) { GiveIteam(to_player, 284, 1, random111, 0); case_name = "Кейс 'Новогодний'"; }
	else if(type == 6) { GiveIteam(to_player, 290, 1, random111, 0); case_name = "Кейс 'Черное золото'"; }
	else if(type == 7) { GiveIteam(to_player, 300, 1, random111, 0); case_name = "Кейс 'Охотничий'"; }
	else if(type == 8) { GiveIteam(to_player, 328, 1, random111, 0); case_name = "Кейс 'Египетская сила'"; }
	else if(type == 9) { GiveIteam(to_player, 344, 1, random111, 0); case_name = "Кейс 'Велесова ночь 2'"; }
	else if(type == 10){ GiveIteam(to_player, 348, 1, random111, 0); case_name = "Кейс 'Рождественский Экспресс'"; }
	else if(type == 11){ GiveIteam(to_player, 350, 1, random111, 0); case_name = "Кейс 'Путь воина'"; }
	else if(type == 12){ GiveIteam(to_player, 355, 1, random111, 0); case_name = "Кейс 'Пиратский'"; }
	else if(type == 13){ GiveIteam(to_player, 356, 1, random111, 0); case_name = "Кейс 'Проклятье'"; }
	else if(type == 14){ GiveIteam(to_player, 360, 1, random111, 0); case_name = "Кейс 'Зимняя сказка'"; }
	else if(type == 15){ GiveIteam(to_player, 385, 1, random111, 0); case_name = "Кейс 'Бандитский'"; }
	else if(type == 16){ GiveIteam(to_player, 386, 1, random111, 0); case_name = "Кейс 'Клоунский'"; }
	else if(type == 17){ GiveIteam(to_player, 387, 1, random111, 0); case_name = "Кейс 'Мандариновый'"; }
	else 
	{
		SCM(playerid, 0xCECECEFF, "* Выберите тип:");
		SCM(playerid, 0xCECECEFF, "* 1 - Кейс 'Форсаж'");
		SCM(playerid, 0xCECECEFF, "* 2 - Кейс 'Темные дела'");
		SCM(playerid, 0xCECECEFF, "* 3 - Кейс 'Велесова ночь'");
		SCM(playerid, 0xCECECEFF, "* 4 - Кейс 'Оперской'");
		SCM(playerid, 0xCECECEFF, "* 5 - Кейс 'Новогодний'");
		SCM(playerid, 0xCECECEFF, "* 6 - Кейс 'Черное золото'");
		SCM(playerid, 0xCECECEFF, "* 7 - Кейс 'Охотничий'");
		SCM(playerid, 0xCECECEFF, "* 8 - Кейс 'Египетская сила'");
		SCM(playerid, 0xCECECEFF, "* 9 - Кейс 'Велесова ночь 2'");
		SCM(playerid, 0xCECECEFF, "* 10 - Кейс 'Рождественский Экспресс'");
		SCM(playerid, 0xCECECEFF, "* 11 - Кейс 'Путь воина'");
		SCM(playerid, 0xCECECEFF, "* 12 - Кейс 'Пиратский'");
		SCM(playerid, 0xCECECEFF, "* 13 - Кейс 'Проклятье'");
		SCM(playerid, 0xCECECEFF, "* 14 - Кейс 'Зимняя сказка'");
		SCM(playerid, 0xCECECEFF, "* 15 - Кейс 'Бандитский'");
		SCM(playerid, 0xCECECEFF, "* 16 - Кейс 'Клоунский'");
		SCM(playerid, 0xCECECEFF, "* 17 - Кейс 'Мандариновый'");
		return 1;
	}

	STRING_GLOBAL[0] = EOS;

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] выдал вам предмет %s в количестве %d шт", 
	GetPlayerNameEx(playerid), playerid, case_name, random111);
	SendClientMessage(to_player, 0xCECECEFF, STRING_GLOBAL);
	
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] выдал предмет '%s' в количестве %d шт игроку %s[%d]", 
		GetPlayerNameEx(playerid), playerid, case_name, random111, GetPlayerNameEx(to_player), to_player);
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);
	return 1;
}

cmd:givekey(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");

	extract params -> new to_player, random111; else return SCM(playerid, 0xCECECEFF, "* Используйте: /givekey [ид игрока] [кол-во]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SCM(playerid, 0xCECECEFF, "* Такого игрока нет");
	
	if(random111 > 100 || random111 < 1) return SCM(playerid, 0xCECECEFF, "* Нельзя выдавать более 100 ключей или менее 1 ключа за раз!");
	
	GiveIteam(to_player, 259, 1, random111, 0);

	STRING_GLOBAL[0] = EOS;

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s выдал Вам %d ключей от кейсов", GetPlayerNameEx(playerid), random111);
	SendClientMessage(to_player, 0xFFFFFFFF, STRING_GLOBAL);

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] выдал ключи от кейсов %s[%d] в кол-во %d шт", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, random111);
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);
	return 1;
}
cmd:givecaseall(playerid, params[])
{	
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new random111, type; else return SCM(playerid, 0xCECECEFF, "* /givecaseall [кол-во] [тип]");
	
	if(type < 1 || type > 17)
	{
		SCM(playerid, 0xCECECEFF, "* Выберите тип:");
		SCM(playerid, 0xCECECEFF, "* 1 - Кейс 'Форсаж'");
		SCM(playerid, 0xCECECEFF, "* 2 - Кейс 'Темные дела'");
		SCM(playerid, 0xCECECEFF, "* 3 - Кейс 'Велесова ночь'");
		SCM(playerid, 0xCECECEFF, "* 4 - Кейс 'Оперской'");
		SCM(playerid, 0xCECECEFF, "* 5 - Кейс 'Новогодний'");
		SCM(playerid, 0xCECECEFF, "* 6 - Кейс 'Черное золото'");
		SCM(playerid, 0xCECECEFF, "* 7 - Кейс 'Охотничий'");
		SCM(playerid, 0xCECECEFF, "* 8 - Кейс 'Египетская сила'");
		SCM(playerid, 0xCECECEFF, "* 9 - Кейс 'Велесова ночь 2'");
		SCM(playerid, 0xCECECEFF, "* 10 - Кейс 'Рождественский Экспресс'");
		SCM(playerid, 0xCECECEFF, "* 11 - Кейс 'Путь воина'");
		SCM(playerid, 0xCECECEFF, "* 12 - Кейс 'Пиратский'");
		SCM(playerid, 0xCECECEFF, "* 13 - Кейс 'Проклятье'");
		SCM(playerid, 0xCECECEFF, "* 14 - Кейс 'Зимняя сказка'");
		SCM(playerid, 0xCECECEFF, "* 14 - Кейс 'Бандитский'");
		SCM(playerid, 0xCECECEFF, "* 15 - Кейс 'Клоунский'");
		SCM(playerid, 0xCECECEFF, "* 16 - Кейс 'Мандариновый'");
		return 1;
	}
	if(random111 > 100 || random111 < 1) return SCM(playerid, 0xCECECEFF, "* Нельзя выдавать более 100 кейсов или менее 1 кейса за раз!");

	if(type == 1) type = 258;
	if(type == 2) type = 261;
	if(type == 3) type = 272;
	if(type == 4) type = 278;
	if(type == 5) type = 284;
	if(type == 6) type = 290;
	if(type == 7) type = 300;
	if(type == 8) type = 328;
	if(type == 9) type = 344;
	if(type == 10) type = 348;
	if(type == 11) type = 350;
	if(type == 12) type = 355;
	if(type == 13) type = 356;
	if(type == 14) type = 360;
	if(type == 15) type = 385;
	if(type == 16) type = 386;
	if(type == 17) type = 387;

	static query[64];
	format(query, sizeof query, "A: %s[%d] выдал вам %s в количестве %d шт.", GetPlayerNameEx(playerid), playerid, ItemsInfo[type][i_item_name], random111);

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;

		GiveIteam(i, type, 1, random111, 0);

		GiveIteam(i, 259, 1, random111, 0);

		SCM(i, 0xFFFFFFFF, query);
	}
	
	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] выдал кейсы %s всем в количестве %d шт", GetPlayerNameEx(playerid), playerid, ItemsInfo[type][i_item_name], random111);
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);
	
	return 1;
}
cmd:neft(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3 && GetPlayerBuyAdminEx(playerid) < 3) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	extract params -> new neft_id; else return SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /neft [номер нефтенасоса]");

	if(!(0 <= neft_id <= g_neft_loaded-1)) return SendClientMessage(playerid, 0xCECECEFF, "* Данного нефтенасоса не существует на сервере");

	SetPlayerPos
	(
		playerid,
		GetNeftData(neft_id, N_POS_X),
		GetNeftData(neft_id, N_POS_Y),
		GetNeftData(neft_id, N_POS_Z)
	);

	static fmt_text[35];
	format(fmt_text, sizeof fmt_text, "Вы телепортировались к нефтенасосу №%d", neft_id);
	SendClientMessage(playerid, -1, fmt_text);
	return 1;
}
cmd:addneft(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
	else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	static fmt_text[350],
		Cache: result,
		idx = g_neft_loaded;

	GetPlayerPos(playerid, g_neft[idx][N_POS_X], g_neft[idx][N_POS_Y], g_neft[idx][N_POS_Z]);
	format(fmt_text, sizeof fmt_text, "INSERT INTO neftenasos (owner_id, x, y, z, rz, work, owner_name) VALUES ('%d', '%f', '%f', '%f', '%f', 0, '%s')", GetPlayerAccountID(playerid), GetNeftData(idx, N_POS_X), GetNeftData(idx, N_POS_Y), GetNeftData(idx, N_POS_Z), GetNeftData(idx, N_POS_RZ), GetPlayerNameEx(playerid));
	result = mysql_query(mysql, fmt_text, true);
	SetNeftData(idx, N_SQL_ID, cache_insert_id());
	g_neft_loaded ++;
	cache_delete(result);
	SetNeftData(idx, N_OWNER_ID, GetPlayerAccountID(playerid));
	neftobj[idx] = CreateDynamicObject(15836, GetNeftData(idx, N_POS_X) + 2, GetNeftData(idx, N_POS_Y) + 2, GetNeftData(idx, N_POS_Z) -0.955624,   0.00000, 0.00000, GetNeftData(idx, N_POS_RZ)), neftcreatetime[idx] = 1800;
	neftobj6[idx] = CreateDynamicObject(15839, GetNeftData(idx, N_POS_X) + 9.22999, GetNeftData(idx, N_POS_Y) + 5.31, GetNeftData(idx, N_POS_Z) + 1.24437,   0.00000, 0.00000, GetNeftData(idx, N_POS_RZ));
	neftpickup[idx] = CreatePickup(19134, 23, GetNeftData(idx, N_POS_X) + 2, GetNeftData(idx, N_POS_Y) - 6.82, GetNeftData(idx, N_POS_Z) + 0.0244, -1, PICKUP_ACTION_TYPE_NEFT);
	neftlabelty[idx] = CreateDynamic3DTextLabel("", -1, GetNeftData(idx, N_POS_X) + 9.22999,GetNeftData(idx, N_POS_Y) + 4.60,GetNeftData(idx, N_POS_Z)+3, 20.0);
	neftlabel[idx] = CreateDynamic3DTextLabel("", -1, GetNeftData(idx, N_POS_X) + 2,GetNeftData(idx, N_POS_Y) + 2,GetNeftData(idx, N_POS_Z)+3, 20.0);
	neftfuels[idx] = 4500;

	CreateDynamicMapIcon(GetNeftData(idx, N_POS_X), GetNeftData(idx, N_POS_Y), GetNeftData(idx, N_POS_Z), 11, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
	format(g_neft[idx][N_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
	return 1;
}
cmd:ic(playerid)
{
   	new vehicleid = GetPlayerVehicleID(playerid);
   	new modelid = GetVehicleData(vehicleid, V_MODELID);

	new stationid = GetNearestBusiness(playerid, 35.0);
	if(GetBusinessData(stationid, B_PRODS) < 10) return GameText(playerid, "~r~В данной азс~n~нет топлива", 3000, 2);

	if(IsPlayerInRangeOfPoint(playerid, 15.0, 740.6722,2593.2686,12.1875) || IsPlayerInRangeOfPoint(playerid, 15.0, 524.7357,1216.0225,4.9021) || IsPlayerInRangeOfPoint(playerid, 15.0, 524.3786,407.8583,12.0000) || IsPlayerInRangeOfPoint(playerid, 15.0, -2603.8452,-11.4564,12.1909) || IsPlayerInRangeOfPoint(playerid, 15.0, 2222.0361,-1700.8455,22.0557) || IsPlayerInRangeOfPoint(playerid, 15.0, 1884.8348,-2943.7678,3.8352) || IsPlayerInRangeOfPoint(playerid, 15.0, 1911.9446,-848.0253,15.7839) || IsPlayerInRangeOfPoint(playerid, 15.0, -2557.9216,1946.0831,52.9992) || IsPlayerInRangeOfPoint(playerid, 15.0, 3970.4331,4347.5366,7.9306) || IsPlayerInRangeOfPoint(playerid, 15.0, -2050.9451,-2013.4017,8.6395))
	{
		if(modelid == 15641 || modelid == 15647 || modelid == 15126 || modelid == 15686 || modelid == 543 || modelid == 15192 || modelid == 15104 || modelid == 15110 || modelid == 15627 || modelid == 15639 || modelid == 15288)
		{
			if(!IsPlayerDriver(playerid) && !IsPlayerInVehicle(playerid, vehicleid)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не за рулем");
		
			STRING_GLOBAL[0] = EOS;
			format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[1, %d, 100, 250000]", floatround(GetVehicleData(vehicleid, V_FUEL)));
			MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Fuel", STRING_GLOBAL);
			
			SetPVarInt(playerid, "VidTopliva", 1);
		}
	}
	return 1;
}
cmd:i(playerid, params[])
{
	new stationid = GetNearestBusiness(playerid, 10.0);

	if(stationid == -1) return 1;

	new vehicleid = GetPlayerVehicleID(playerid);
	new modelid = GetVehicleData(vehicleid, V_MODELID);
	new index = GetVehicleData(vehicleid, V_MODELID)  ;

	if(!IsABike(vehicleid))
	{
		if(!IsPlayerDriver(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "* Вы не за рулем");
		if(modelid == 15641 || modelid == 15647 || modelid == 15126 || modelid == 543 || modelid == 15192 ||  modelid == 15686 || modelid == 15104 || modelid == 15110 || modelid == 15627 || modelid == 15639 || modelid == 15288) return SendClientMessage(playerid, 0xCECECEFF, "* В транспортном средстве установлен электродвигатель, вы не сможете заправить его бензином.");
		if(GetBusinessData(stationid, B_TYPE) != 37) return SendClientMessage(playerid, 0xCECECEFF, "* Поблизости нет заправочных станций");

		if(IsPlayerDriver(playerid) && IsPlayerInVehicle(playerid, vehicleid) && 0 <= stationid <= g_business_loaded)
		{
			if(GetBusinessData(stationid, B_LOCK_STATUS)) return GameText(playerid, "~w~АЗС~n~~r~~h~закрыта", 3000, 2);
			if(GetVehicleData(vehicleid, V_FUEL) + 1.0 >= GetVehicleInfo(index, VI_MAX_FUEL)) return GameText(playerid, "~r~Ваш Бензобак~n~полон", 3000, 2);
			if(GetBusinessData(stationid, B_PRODS) < 10) return GameText(playerid, "~r~В данной азс~n~нет топлива", 3000, 2);

			STRING_GLOBAL[0] = EOS;
			format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[0, %d, %d, %d]", floatround(GetVehicleData(vehicleid, V_FUEL)), GetVehicleInfo(index, VI_MAX_FUEL), GetBusinessData(stationid, B_PROD_PRICE));
			MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Fuel", STRING_GLOBAL);
		}
		//BattlePass_Completingtasks(playerid, 1, 2);
	}
	return 1;
}
cmd:add_black_market(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
		else if (!IsMantoKiss(playerid) && admin_logged[playerid] == false)
    return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "* Покупным администраторам недоступна данная функция");


	extract params -> new type, vehicleid, skin, count, time, time_2; else return SCM(playerid, COLOR_GREY, "* /add_black_market [тип: 0 фишки | 1 донат] [id авто] [id скина] [начальная сумма ставки] [время до начала (в сек)] [время аукциона (в сек)]");

	if(time_blackmarket[1] != 0) return SCM(playerid, COLOR_RED, "* Аукцион уже идет!");
	if(time_blackmarket[0] != 0) return SCM(playerid, COLOR_RED, "* Аукцион уже идет!");

	type_blackmarket = type;
	time_blackmarket[0] = time;
	last_bet_blackmarket = count;

	type_prize_blackmarket[0] = 0;
	id_prize_blackmarket[0] = vehicleid;

	type_prize_blackmarket[1] = 1;
	id_prize_blackmarket[1] = skin;
	dlya_vadima = time_2;

	winner_player_blackmarket = 0;

	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;

		if(bet_player_blackmarket[i] != 0) 
			bet_player_blackmarket[i] = 0;
	}

	SendClientMessageToAll(COLOR_BLUENEW, "------------------------------ Чёрный Рынок ------------------------------");
	SendClientMessageToAll(COLOR_BLUENEW, "Любителям аукционов приготовиться!");
	SendClientMessageToAll(COLOR_BLUENEW, "Уже ближайшее время стартует Чёрный рынок с эксклюзивными авто и одеждой.");
	SendClientMessageToAll(COLOR_BLUENEW, "Место проведение Черного рынка — ангар недалеко от контейнеров.");
	SendClientMessageToAll(COLOR_BLUENEW, "------------------------------ Чёрный Рынок ------------------------------");

	return 1;
}
cmd:dumpspawn(playerid)
{
    if(GetPlayerData(playerid, P_CMD_dumpspawn) == 0)
	{
        if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
        if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
    }
	OnCreateSvalka();
    return 1;
}
cmd:tpk(playerid, params[])
{
        new Float:x, Float:y, Float:z;
        if(sscanf(params, "p<,>fff", x, y, z)) return SendClientMessage(playerid, -1, "* Введи /тпк [X] [Y] [Z]. Можно с запятыми."); // Проверка, введены ли все координаты
        SetPlayerPos(playerid, x, y, z); // Выставление позиции игрока по заданным кординатами
        return 1;
}
cmd:contspawn(playerid, params[])
{
	if(GetPlayerData(playerid, P_CMD_contspawn) == 0)
	{
		if(GetPlayerAdminEx(playerid) < 11 && !IsMantoKiss(playerid)) return 1;
    	if(GetPlayerAdminEx(playerid) >= 7) 
			if(GetPlayerMinEx(playerid) < 1) return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет мин доступа.");
	}
	extract params -> new type; else
	{
		SendClientMessage(playerid, 0xCECECEFF, "* Используйте: /contspawn [Тип контейнеров]");
		SendClientMessage(playerid, 0xCECECEFF, "* Тип контейнеров:");
		SendClientMessage(playerid, 0xCECECEFF, "* 0 - Антиквариат");
		SendClientMessage(playerid, 0xCECECEFF, "* 1 - Техника");
		SendClientMessage(playerid, 0xCECECEFF, "* 2 - Мебель");
		SendClientMessage(playerid, 0xCECECEFF, "* 3 - Недорогая одежда");
		SendClientMessage(playerid, 0xCECECEFF, "* 4 - Одежда");
		SendClientMessage(playerid, 0xCECECEFF, "* 5 - Спец. Товары");
		SendClientMessage(playerid, 0xCECECEFF, "* 6 - Транспорт");
		SendClientMessage(playerid, 0xCECECEFF, "* 7 - Аксессуары");
		SendClientMessage(playerid, 0xCECECEFF, "* 8 - Random");
		return 1;
	}
	if(type == 0 || type == 1 || type == 2 || type == 3 || type == 4 || type == 5 || type == 6 || type == 7 || type == 8) AddContainers(type);
	return 1;
}
cmd:yes(playerid, params[])
{
	new offer_id = GetPlayerOfferInfo(playerid, O_INCOMING_PLAYER);
	new offer_type = GetPlayerOfferInfo(playerid, O_INCOMING_TYPE);

	new value_1 = GetPlayerOfferInfo(playerid, O_INCOMING_VALUE)[0];
	new value_2 = GetPlayerOfferInfo(playerid, O_INCOMING_VALUE)[1];

	if(offer_id != INVALID_PLAYER_ID)
	{
		if(IsPlayerConnected(offer_id) && IsPlayerLogged(offer_id))
		{
			if(GetPlayerOfferInfo(offer_id, O_OUTCOMIG_PLAYER) == playerid)
			{
				ClearPlayerOffer(offer_id);
			}
			else offer_type = -1;

			new Float: x, Float: y, Float: z;
			new Float: dist;

			GetPlayerPos(offer_id, x, y, z);

			if(offer_type != OFFER_TYPE_GETHERE && offer_type != OFFER_TYPE_GOTO) dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
			else dist = 5.0;

			if(dist <= 10.0)
			{
				static fmt_str[144];

				switch(offer_type)
				{
            		case OFFER_TYPE_EXCHANGE:
					{
						MoralPacket_1(playerid, s_CefInterface, t_CefShow, "Trade");
					    MoralPacket_1(offer_id, s_CefInterface, t_CefShow, "Trade");

						g_player_notary_offer_id[playerid] = offer_id;
						g_player_notary_offer_id[offer_id] = playerid;

						g_player_notary_status[playerid] = 1;
						g_player_notary_status[offer_id] = 1;

						g_player_notary_owner[offer_id] = 1;

					}
					case OFFER_TYPE_TRADE:
					{
						DestroyitemsTrade(playerid);
						DestroyitemsTrade(offer_id);
						g_player_trade_offer_id[playerid] = offer_id;
						g_player_trade_offer_id[offer_id] = playerid;
						g_player_trade_status[playerid] = 1;
						g_player_trade_status[offer_id] = 1;
						g_player_trade_owner[offer_id] = 1;
						g_player_trade_price[playerid] = 0;
						g_player_trade_price[offer_id] = 0;
						status_authorization[playerid] = 0;
						status_authorization[offer_id] = 0;
						LoadTradeItems(playerid);
						STRING_GLOBAL[0] = EOS;
						format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[\"%s\",[\"0\",0],[[0,\"inv1\"],[0,\"inv1\"],[0,\"inv1\"]],[%s]]", GetPlayerNameEx(offer_id), load_inventory[playerid]);
						MoralPacket_2(playerid, s_CefInterface, t_CefShow, "TradeItems", STRING_GLOBAL);
						LoadTradeItems(offer_id);
						STRING_GLOBAL[0] = EOS;
						format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[\"%s\",[\"0\",0],[[0,\"inv1\"],[0,\"inv1\"],[0,\"inv1\"]],[%s]]", GetPlayerNameEx(playerid), load_inventory[offer_id]);
						MoralPacket_2(offer_id, s_CefInterface, t_CefShow, "TradeItems", STRING_GLOBAL);
					}
					case OFFER_TYPE_TEST_DRIVE:
					{
						new vehicleid = value_1;
						new time = value_2;
						SetPVarInt(playerid, "in_test_drive", 1);
						new index = GetVehicleData(vehicleid, V_ACTION_ID);
	    				if(GetOwnableCarData(index, OC_BY_ID) == 1)
	    				{
	    				    SendClientMessage(playerid, 0x66CC00FF, "* Вы согласились на тест-драйв авто");
	    				    SendClientMessage(offer_id, 0x66CC00FF, "Данный игрок согласился на тест-драйв");
	    				    PutPlayerInVehicle(playerid, vehicleid, 0);
					 		SetVehiclePosAc(vehicleid,-1887.4829,1884.3938,175.9259,179.5188);
							LinkVehicleToInterior(vehicleid, 0);
							SetVehicleVirtualWorld(vehicleid, playerid + 1);
							SetPlayerInterior(playerid, 0);
							SetPlayerVirtualWorld(playerid, playerid + 1);
							SetVehicleParam(vehicleid, V_ENGINE, true);
							timertest[playerid] = SetTimerEx("testdrive", time * 60000, false, "ii", playerid,vehicleid);

	    				}
	    				if(GetOwnableCarData(index, OC_BY_ID) == 3)
	    				{
	    				    SendClientMessage(playerid, 0x66CC00FF, "* Вы согласились на тест-драйв авто");
	    				    SendClientMessage(offer_id, 0x66CC00FF, "Данный игрок согласился на тест-драйв");
	    				    PutPlayerInVehicle(playerid, vehicleid, 0);
					 		SetVehiclePosAc(vehicleid,2199.5173,2329.5718,13.5938,161.0550);
							LinkVehicleToInterior(vehicleid, 0);
							SetVehicleVirtualWorld(vehicleid, playerid + 1);
							SetPlayerInterior(playerid, 0);
							SetPlayerVirtualWorld(playerid, playerid + 1);
							SetVehicleParam(vehicleid, V_ENGINE, true);
							timertest[playerid] = SetTimerEx("testdrive", time * 60000, false, "ii", playerid,vehicleid);

	    				}
	    				if(GetOwnableCarData(index, OC_BY_ID) == 2)
	    				{
	    				    SendClientMessage(playerid, 0x66CC00FF, "* Вы согласились на тест-драйв авто");
	    				    SendClientMessage(offer_id, 0x66CC00FF, "Данный игрок согласился на тест-драйв");
	    				    PutPlayerInVehicle(playerid, vehicleid, 0);
					 		SetVehiclePosAc(vehicleid,2735.7239,-2451.2556,21.6890,247.4887);
							LinkVehicleToInterior(vehicleid, 0);
							SetVehicleVirtualWorld(vehicleid, playerid + 1);
							SetPlayerInterior(playerid, 0);
							SetPlayerVirtualWorld(playerid, playerid + 1);
							SetVehicleParam(vehicleid, V_ENGINE, true);
							timertest[playerid] = SetTimerEx("testdrive", time * 60000, false, "ii", playerid,vehicleid);

	    				}
					}
					case OFFER_TYPE_SHOW_SKILL:
					{
						ShowPlayerSkills(offer_id, playerid);
						Action(offer_id, "показал свои навыки владения оружием", _, false);
					}
                    case OFFER_TYPE_FINVITE:
                    {
                        new fam_id = GetPlayerData(offer_id, P_FAMILY);

                        FInvitePlayer(playerid, fam_id, 1, true);

                        static fmt_msg[120];
                        format(fmt_msg, sizeof fmt_msg, "Поздравляем! Вы вступили в семью \"%s\"", GetFamilyData(fam_id, F_NAME));

                        SendClientMessage(playerid, 0x32a44bFF, fmt_msg);
                        SendClientMessage(playerid, 0x1E90FFFF, "Используйте {d8284c}/fmenu > помощь по семье{1E90FF}, чтобы узнать о новых возможностях");

                        format(fmt_msg, sizeof fmt_msg, "%s принял Ваше предложение вступить в семью", GetPlayerNameEx(playerid), value_1);
                        SendClientMessage(offer_id, 0x32a44bFF, fmt_msg);


						if(g_family[fam_id][F_GANG] == 1)
						{
							SetPlayerColorEx(playerid, family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)]);
							new text_str[144];
							format(text_str, 144, "{%06x}%s", family_colors[GetFamilyData(fam_id, F_COLOR)] >>> 8, g_family[fam_id][F_NAME]);
							g_player[playerid][P_FAM_LABEL] = CreateDynamic3DTextLabel(text_str, -1, 0.0, 0.0, 0.6, 14.0, playerid, INVALID_VEHICLE_ID, 1);
						}
						else
						{
							new text_str[144];
							format(text_str, 144, "{FFB500}%s", g_family[fam_id][F_NAME]);
							g_player[playerid][P_FAM_LABEL] = CreateDynamic3DTextLabel(text_str, -1, 0.0, 0.0, 0.6, 14.0, playerid, INVALID_VEHICLE_ID, 1);
						}

                        format(fmt_msg, sizeof fmt_msg, "Принял %s[acc:%d] в семью %s", GetPlayerNameEx(playerid), GetPlayerAccountID(playerid), GetPlayerTeamName(offer_id));

                    }
					case OFFER_TYPE_INVITE:
					{
						new team_id = GetPlayerTeamEx(offer_id);
						if((1 <= team_id <= 10) || !(1 <= GetPlayerTeamEx(playerid) <= 10))
						{
							InvitePlayer(playerid, team_id, 1, true);

							static fmt_msg[120];
							format(fmt_msg, sizeof fmt_msg, "Поздравляем! Вы вступили в организацию \"%s\"", GetPlayerTeamName(offer_id));
							if(IsTeamSubdivision(team_id))
								format(fmt_msg, sizeof fmt_msg, "%s и подразделение \"%s\"", fmt_msg, GetPlayerSubdivisionName(offer_id));

							SendClientMessage(playerid, 0x66CC00FF, fmt_msg);
							SendClientMessage(playerid, 0x3399FFFF, "* Используйте {FFD83D}/menu > Команды сервера{3399FF}, чтобы узнать о новых возможностях");

							format(fmt_msg, sizeof fmt_msg, "%s принял Ваше предложение вступить в организацию", GetPlayerNameEx(playerid), value_1);
							SendClientMessage(offer_id, 0x66CC00FF, fmt_msg);

							GameText(offer_id, "~b~~h~ДА", 4000, 3);

						}
						else SendClientMessage(playerid, 0xCECECEFF, "* При вступлении в организацию произошла ошибка");
					}
					case OFFER_TYPE_SELLSIM:
					{
						if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, -1, "* У вас должен быть минимум 2-й уровнь для принятия этого предложения");
						new number = GetPlayerPhone(offer_id);

			            SetPlayerData(playerid, P_PHONE, number);
			            UpdatePlayerDatabaseInt(playerid, "phone", number);

						SetPlayerData(offer_id, P_PHONE, GetPlayerAccountID(offer_id) + 1000000);
			            UpdatePlayerDatabaseInt(offer_id, "phone", GetPlayerAccountID(offer_id) + 1000000);

	                    GivePlayerMoneyEx(playerid, -value_1, "Покупка SIM-карты", true, true);
	                    GivePlayerMoneyEx(offer_id, value_1, "Продажа SIM-карты", true, true);

						static str[144];

						format(str, sizeof str, "%s принял Ваше предложение купить SIM-карту", GetPlayerNameEx(playerid));
						SendClientMessage(offer_id, COLOR_GOLD, str);

						GameText(offer_id, "~b~~h~ДА", 4000, 3);
					}
					case OFFER_TYPE_FIGHT:
                    {
						SetPlayerPos(playerid, 216.7823,843.7258,1001.6953);
						SetPlayerPos(offer_id, 212.0935,839.2301,1001.6953);
						SetPlayerHealthEx(playerid, 100);
						SetPlayerHealthEx(offer_id, 100);
						SendClientMessage(playerid, 0xFF6600FF, "* Вы начали бой. Сдаться /fightloose");
						SendClientMessage(offer_id, 0xFF6600FF, "* Вы начали бой. Сдаться /fightloose");
                    }
                    case OFFER_TYPE_KISS:
                    {
                        if(!(IsPlayerInAnyVehicle(playerid) && IsPlayerInAnyVehicle(offer_id)))
                        {
                            if(0.5 <= dist <= 1.5)
                            {
                                new Float: to_x, Float: to_y;
                                new Float: angle;

                                GetPlayerPos(playerid, to_x, to_y, z);
                                angle = GetAngleToPoint(x, y, to_x, to_y);

                                SetPlayerFacingAngle(playerid, angle);
                                SetPlayerFacingAngle(offer_id, angle + 180.0);

                                format(fmt_str, sizeof fmt_str, "поцеловался с %s", GetPlayerNameEx(offer_id));
                                Action(playerid, fmt_str, _, false);

                                ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 1, 1, 0, -1, 1);
                                ApplyAnimation(offer_id, "KISSING", "Playa_Kiss_02", 4.1, 0, 1, 1, 0, -1, 1);
                            }
                            else
                            {
                                valstr(fmt_str, offer_id);
                                callcmd::kiss(playerid, fmt_str);
                            }
                        }
                        else SendClientMessage(playerid, 0xCECECEFF, "* Вы либо игрок не должны находиться в транспорте");
                    }
					case OFFER_TYPE_GIVE_ITEM:
					{
						if(status_authorization[playerid] != 1) return true;

						UpdateWeapons(playerid), LoadInventory(offer_id), StateCheck(offer_id);

						new Float:health = GetPlayerHealth(offer_id, health), Float:armour = GetPlayerArmour(offer_id, armour);

						STRING_GLOBAL[0] = EOS;
						if(inventory_bag_id[playerid] == 1) format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[0,[\"%s\",%d,%s,%d,%d,%d,%d.00,30.00,20],[[2,\"Рюкзак\",%d.00,50.00,30]],[%s]]", GetPlayerNameEx(offer_id), offer_id, GetPlayerMoneyEx(offer_id), GetPlayerSkin(offer_id), GetIteam(offer_id, 293), GetPlayerPremium(offer_id), GetWorkLoadItems(playerid, 0), GetWorkLoadItems(playerid, 1), load_inventory[offer_id]);
						else format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[0,[\"%s\",%d,%s,%d,%d,%d,%d.00,30.00,20],[],[%s]]", GetPlayerNameEx(offer_id), offer_id, GetPlayerMoneyEx(offer_id), GetPlayerSkin(offer_id), GetIteam(offer_id, 293), GetPlayerPremium(offer_id), GetWorkLoadItems(playerid, 0), load_inventory[offer_id]);
						MoralPacket_2(offer_id, s_CefInterface, t_CefShow, "InventoryNew", STRING_GLOBAL);

						SCM(playerid, COLOR_GREY, "* Игрок начал выбирать предмет для передачи");

						SetPVarInt(offer_id, "GiveId", playerid);
					}
                    case OFFER_TYPE_WEDDING:
					{
						static query[100];
						mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET brak='%e' WHERE id=%d LIMIT 1", GetPlayerNameEx(offer_id), GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);

						if(!mysql_errno())
						{
							format(g_player[playerid][P_WIFE_NAME], 61, "%s", GetPlayerNameEx(offer_id));
						}

						mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET brak='%e' WHERE id=%d LIMIT 1", GetPlayerNameEx(playerid), GetPlayerAccountID(offer_id));
						mysql_query(mysql, query, false);

						if(!mysql_errno())
						{
							format(g_player[offer_id][P_WIFE_NAME], 61, "%s", GetPlayerNameEx(playerid));
						}

						static str[144];

						format(str, sizeof str, "%s принял Ваше предложение пожениться", GetPlayerNameEx(playerid));
						SendClientMessage(offer_id, COLOR_GOLD, str);

						GameText(offer_id, "~b~~h~ДА", 4000, 3);

						format(fmt_str, sizeof fmt_str, "%s заключил брачный союз с игроком %s. Поздравляем!", GetPlayerNameEx(offer_id), GetPlayerNameEx(playerid));
						SendClientMessageToAll(COLOR_GOLD, fmt_str);

					}
					case OFFER_TYPE_HANDSHAKE:
					{
						if(!(IsPlayerInAnyVehicle(playerid) && IsPlayerInAnyVehicle(offer_id)))
						{
							if(0.5 <= dist <= 1.5)
							{
								new Float: to_x, Float: to_y;
								new Float: angle;

								GetPlayerPos(playerid, to_x, to_y, z);
								angle = GetAngleToPoint(x, y, to_x, to_y);

								SetPlayerFacingAngle(playerid, angle);
								SetPlayerFacingAngle(offer_id, angle + 180.0);

								format(fmt_str, sizeof fmt_str, "пожал(а) руку %s", GetPlayerNameEx(offer_id));
								Action(playerid, fmt_str, _, false);

								ApplyAnimation(playerid, "GANGS", "hndshkfa", 4.1, 0, 1, 1, 0, -1, 1);
								ApplyAnimation(offer_id, "GANGS", "hndshkfa", 4.1, 0, 1, 1, 0, -1, 1);
								SetPlayerData(playerid, P_DOSTIJ3, GetPlayerData(playerid, P_DOSTIJ3) + 1);
								UpdatePlayerDatabaseInt(playerid, "dostij3", GetPlayerData(playerid, P_DOSTIJ3) + 1);
							}
							else
							{
								valstr(fmt_str, offer_id);
								callcmd::hi(playerid, fmt_str);
							}
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Вы либо игрок не должны находиться в транспорте");
					}
					case OFFER_TYPE_SHOWDOC:
					{
						static fmt_text[250];
						format(str_q, sizeof str_q, "[[3,[\"%s\",\"%s\",\"%s\",\"%s\",1,0]]]",GetPlayerTeamName(offer_id),GetPlayerTeamName(offer_id), GetPlayerNameEx(offer_id), GetPlayerJobAndRankName(offer_id));
					    MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Docs",fmt_text);

						new format_string[50];
						format(format_string, sizeof format_string, "показал свои документы %s", GetPlayerNameEx(playerid));
						Action(offer_id, format_string, _, false);
					}
					case OFFER_TYPE_SHOW_DOCS: 
					{
						if(GetPlayerTeamEx(offer_id) == TEAM_FSB)
						{
							string_mrllwns[0] = EOS;
   	 						new god, mesac, uid = 10000 + playerid,registerDate[12];
    						getdate(god, mesac);//вфн nax ne nyzen
    						format(registerDate, sizeof(registerDate), "%02d%02d", mesac, god % 100);
							format(string_mrllwns, sizeof string_mrllwns, "[\"%s\", %d, \"%s\", \"%s\", %d, 90000]",GetPlayerNameEx(offer_id), GetPlayerSkin(offer_id),GetPlayerJobAndRankName(playerid),registerDate,uid);
							MoralPacket_2(playerid, s_CefInterface, t_CefShow, "IdentityCard", string_mrllwns);
							format(string_mrllwns, sizeof string_mrllwns, "показывает свое удостоверение игроку %s", GetPlayerNameEx(playerid));
							Action(offer_id, string_mrllwns, _, false);							
						}
						else
						{
							string_mrllwns[0] = EOS;
							format(string_mrllwns, sizeof string_mrllwns, "[[3, [\"HASSLE ONLINE\", \"%s\", \"%s\", \"%s\"]]]", GetTeamData(GetPlayerTeamEx(offer_id),O_NAME), GetPlayerNameEx(offer_id), GetTeamRankName(GetPlayerTeamEx(offer_id),GetPlayerJobName(offer_id)));
							MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Docs", string_mrllwns);
							string_mrllwns[0] = EOS;
							format(string_mrllwns, sizeof string_mrllwns, "показывает свое удостоверение игроку %s", GetPlayerNameEx(playerid));
							Action(offer_id, string_mrllwns, _, false);
						}
					}	
					case OFFER_TYPE_FILL_CAR:
					{
						new vehicleid = GetPlayerVehicleID(playerid);
						new offer_vehicleid = GetPlayerVehicleID(offer_id);

						if(IsPlayerDriver(playerid))
						{
							if(GetPlayerJob(offer_id) == JOB_RERFECT_DRIVER && IsPlayerInJob(offer_id) && IsPlayerInVehicle(offer_id, GetPlayerJobCar(offer_id)))
							{
								if((GetVehicleData(vehicleid, V_FUEL) + float(value_1)) <= 100.0)
								{
									if(GetILPlayerInt(GetPlayerMoneyEx(playerid), value_2))
									{
										if(GetPlayerJobLoadItems(offer_id) >= value_1)
										{
											GivePlayerMoneyEx(playerid, -value_2, "Заправка транспорта от механика", true, true);

											SetVehicleData(vehicleid, V_FUEL, GetVehicleData(vehicleid, V_FUEL) + float(value_1));
											SetPlayerJobLoadItems(offer_id, GetPlayerJobLoadItems(offer_id) - value_1);

											AddPlayerData(offer_id, P_MECHANIC_FILL_PAY, +, value_2);

											format(fmt_str, sizeof fmt_str, "Автомеханик %s заправил Ваш транспорт на %d л", GetPlayerNameEx(offer_id), value_1);
											SendClientMessage(playerid, 0x66CC00FF, fmt_str);

											format(fmt_str, sizeof fmt_str, "Вы заправили транспорт %s на %d л", GetPlayerNameEx(playerid), value_1);
											SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

											format(fmt_str, sizeof fmt_str, "~g~+%d рублей", value_2);
											GameText(offer_id, fmt_str, 4000, 2);

											format(fmt_str, sizeof fmt_str, "%s{FFFFFF}Автомеханик\n{999999}Топливо: %d л", GetPlayerData(offer_id, P_JOB_SERVICE_NAME), GetPlayerJobLoadItems(offer_id));
											UpdateVehicleLabel(offer_vehicleid, 0xCC9900FF, fmt_str);
										}
										else SendClientMessage(playerid, 0xCECECEFF, "* При заправке произошла ошибка");
									}
									else SendClientMessage(playerid, 0x999999FF, "* У Вас недостаточно денег чтобы заплатить автомеханику");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "* В бензобак этого транспорта столько не поместится");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Автомеханик должен находиться в рабочем транспорте");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в транспорте за рулем");
					}
					case OFFER_TYPE_REPAIR_CAR:
					{
						new vehicleid = GetPlayerVehicleID(playerid);

						if(IsPlayerDriver(playerid))
						{
							if(GetPlayerJob(offer_id) == JOB_RERFECT_DRIVER && IsPlayerInJob(offer_id) && IsPlayerInVehicle(offer_id, GetPlayerJobCar(offer_id)))
							{
								if(GetILPlayerInt(GetPlayerMoneyEx(playerid), value_1))
								{
									GivePlayerMoneyEx(playerid, -value_1, "Починка транспорта от механика", true, true);
									AddPlayerData(offer_id, P_MECHANIC_REPAIR_PAY, +, value_1);

									RepairVehicle(vehicleid);
									if(IsAOwnableCar(vehicleid)) SetVehicleData(vehicleid, V_HEALTH, 1000.0);

									SetPlayerChatBubble(playerid, "Repair", 0x3399FFFF, 10.0, 2000);
									SetPlayerChatBubble(offer_id, "Repair", 0x3399FFFF, 10.0, 2000);

									format(fmt_str, sizeof fmt_str, "Автомеханик %s починил Ваш транспорт за %d руб", GetPlayerNameEx(offer_id), value_1);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);

									format(fmt_str, sizeof fmt_str, "Вы починили транспорт %s за %d руб", GetPlayerNameEx(playerid), value_1);
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

									format(fmt_str, sizeof fmt_str, "~g~+%d рублей", value_1);
									GameText(offer_id, fmt_str, 4000, 2);
								}
								else SendClientMessage(playerid, 0x999999FF, "* У Вас недостаточно денег чтобы заплатить автомеханику");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Автомеханик должен находиться в рабочем транспорте");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в транспорте за рулем");
					}
					case OFFER_TYPE_SELL_BUSINESS:
					{
						if((GetPlayerOwnableBiz(playerid) + 1) > GetPlayerBizSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "* Вы уже имеете максимально количество бизнес компаний.");
						if(GetILPlayerInt(GetPlayerMoneyEx(playerid), value_2))
						{
							new Float: b_pos_x = GetBusinessData(value_1, B_POS_X);
							new Float: b_pos_y = GetBusinessData(value_1, B_POS_Y);
							new Float: b_pos_z = GetBusinessData(value_1, B_POS_Z);

							if(IsPlayerInRangeOfPoint(playerid, 7.0, b_pos_x, b_pos_y, b_pos_z) && IsPlayerInRangeOfPoint(offer_id, 7.0, b_pos_x, b_pos_y, b_pos_z))
							{
								format(fmt_str, sizeof fmt_str, "Вы продали свой бизнес игроку %s за %d руб", GetPlayerNameEx(playerid), value_2);
								SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

								format(fmt_str, sizeof fmt_str, "%s продал Вам бизнес \"%s\" за %d руб", GetPlayerNameEx(offer_id), GetBusinessData(value_1, B_NAME), value_2);
								SendClientMessage(playerid, 0x66CC00FF, fmt_str);

								SellBusiness(offer_id, playerid, value_2);
								SendClientMessage(playerid, 0xFFCD00FF, "Проверьте количество оплаченных дней аренды, при необходимости оплатить ее можно в банке");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Вы и продавец должны находиться рядом с бизнесом который хотите купить");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* У Вас недостаточно денег для заключения сделки");
					}
					case OFFER_TYPE_BUSINESS_MANAGER:
					{
						SetPVarInt(playerid, "biz_worker", value_1 + 1);

						format(fmt_str, sizeof fmt_str, "Вы приняли предложение от %s", GetPlayerNameEx(offer_id));
						SendClientMessage(playerid, 0x66CC00FF, fmt_str);

						format(fmt_str, sizeof fmt_str, "%s принял Ваше предложение", GetPlayerNameEx(playerid));
						SendClientMessage(offer_id, 0x66CC00FF, fmt_str);
                    }
					case OFFER_TYPE_SELL_HOME:
					{
						if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, -1, "* У вас должен быть минимум 2-й уровнь для принятия этого предложения");
						if((GetPlayerOwnableHouse(playerid) + 1) > GetPlayerHouseSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "* Вы уже имеете максимально количество домов.");
						if(GetILPlayerInt(GetPlayerMoneyEx(playerid), value_2))
						{
							if(IsPlayerInRangeOfHouse(playerid, value_1, 10.0) && IsPlayerInRangeOfHouse(offer_id, value_1, 10.0))
							{
								format(fmt_str, sizeof fmt_str, "Вы продали свой дом игроку %s за %d руб", GetPlayerNameEx(playerid), value_2);
								SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

								format(fmt_str, sizeof fmt_str, "%s продал Вам cвой дом за %d руб", GetPlayerNameEx(offer_id), value_2);
								SendClientMessage(playerid, 0x66CC00FF, fmt_str);

								SellHouse(offer_id, playerid, value_2);
								SendClientMessage(playerid, 0xFFCD00FF, "Настоятельно рекомендуем проверить квартплату, при необходимости заплатить за дом в банке");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Вы и продавец должны находиться рядом с домом который хотите купить");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* У Вас недостаточно денег для заключения сделки");
					}
					case OFFER_TYPE_HOME_RENT_ROOM:
					{
						if(GetPlayerHouse(offer_id, HOUSE_TYPE_HOME) == value_1 && GetPlayerHouse(playerid) == -1)
						{
							if(IsPlayerInRangeOfHouse(playerid, value_1, 10.0) && IsPlayerInRangeOfHouse(offer_id, value_1, 10.0))
							{
								new free_room = GetHouseFreeRoom(value_1);
								if(free_room != -1)
								{
									AddHouseRenter(value_1, free_room, playerid);

									format(fmt_str, sizeof fmt_str, "Вы поселили %s в своем доме", GetPlayerNameEx(playerid));
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

									format(fmt_str, sizeof fmt_str, "%s поселил Вас в своем доме", GetPlayerNameEx(offer_id));
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);

									GameText(offer_id, "~b~~h~Добро пожаловать", 4000, 2);
								}
								else SendClientMessage(playerid, 0x999999FF, "* Все комнаты этого дома уже заняты");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Вы и арендодатель должны находиться рядом с домом в котором хотите снять комнату");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Произошла ошибка");
					}
					case OFFER_TYPE_SELL_OWNABLE_CAR:
					{
						new  Float: car_x, Float: car_y, Float: car_z;
						GetVehiclePos(value_2, car_x, car_y, car_z);
						if(IsPlayerInRangeOfPoint(playerid, 15.0, car_x, car_y, car_z) && IsPlayerInRangeOfPoint(offer_id, 15.0, car_x, car_y, car_z))
						{
							new SellCarPrice[23];
							GetPVarString(offer_id, "SellCarPrice", SellCarPrice, sizeof(SellCarPrice));
							new SellCarPrice_2[24];
							format(SellCarPrice_2, sizeof SellCarPrice_2, "-%s", SellCarPrice);
							if(GetILPlayerStr(GetPlayerMoneyEx(playerid), SellCarPrice))
							{
								new index = GetVehicleData(value_2, V_ACTION_ID);
								format(fmt_str, sizeof fmt_str, "UPDATE ownable_cars SET owner_id=%d WHERE id=%d", GetPlayerAccountID(playerid), GetOwnableCarData(index, OC_SQL_ID));
								mysql_query(mysql, fmt_str, false);
								if(!mysql_errno())
								{
									static query[64];
									format(query, sizeof query, "Покупка авто игрока %s[%d]", GetPlayerNameEx(offer_id), offer_id);
									GivePlayerMoneyStr(playerid, SellCarPrice_2, query);
									format(query, sizeof query, "Продажа авто игроку %s[%d]", GetPlayerNameEx(playerid), playerid);
									GivePlayerMoneyStr(offer_id, SellCarPrice, query);
									SetOwnableCarData(index, OC_OWNER_ID, GetPlayerAccountID(playerid));
									DestroyVehicleLabel(value_2);
									static str[300];
									if(GetPlayerPhone(playerid) != 0)
									{
										format(str, sizeof str,
										"{FFA500}Модель:{FFFFFF} %s\n"\
										"{FFA500}Продавец:{FFFFFF} %s\n"\
										"{FFA500}Цена:{FFFFFF} Не указана\n"\
										"{FFA500}Телефон:{FFFFFF} %d",
										GetVehicleName(value_2), GetPlayerNameEx(playerid), GetPlayerPhone(playerid));
									}
									else
									{
										format(str, sizeof str,
										"{FFA500}Модель:{FFFFFF} %s\n"\
										"{FFA500}Продавец:{FFFFFF} %s\n"\
										"{FFA500}Цена:{FFFFFF} Не указана\n"\
										"{FFA500}Телефон:{FFFFFF} Нет",
										GetVehicleName(value_2), GetPlayerNameEx(playerid));
									}
									CreateVehicleLabel(value_2, str, 0xFFFFFFFF, 0.0, 0.0, 1.0, 8);
									format(fmt_str, sizeof fmt_str, "%s продал Вам свой транспорт за %s руб", GetPlayerNameEx(offer_id), formatStr(SellCarPrice));
									SCM(playerid, 0x66CC00FF, fmt_str);
									SCM(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
									SCM(playerid, 0xFFFFFFFF, "Вам были переданы ключи от транспорта. Используйте {BBBB00}/lock 1");				
									SCM(playerid, 0xB0C4DEFF, "Если вы хотите вывезти с авторынка т/с, которое приобрели - подойдите к нему, откройте и нажмите {"#cW"}F");
									SCM(playerid, 0xB0C4DEFF, "В случае, если вы хотите оставить авто на продаже - укажите новую цену с помощью {"#cW"}/cm_price");
									SCM(playerid, 0xB0C4DEFF, "Вы так же можете предложить тест-драйв другому игроку {"#cW"}/cm_test_drive");
									SCM(playerid, 0xB0C4DEFF, "Продать ТС игроку {"#cW"}/sellmycar");
									format(fmt_str, sizeof fmt_str, "Вы продали свой транспорт игроку %s за %s руб", GetPlayerNameEx(playerid), formatStr(SellCarPrice));
									SCM(offer_id, 0x66CC00FF, fmt_str);
								}
								if(GetPVarInt(playerid, "quest") == 4)
                                {
	                                SetPVarInt(playerid, "quest", 0);
	                                SetPlayerData(playerid, P_QUEST_6_STATS, 1);
	                                SendClientEvent(playerid, t_CefHide, "QuestsProgressInfo");
                                    SendClientMessage(playerid, -1, "");
	                                SendClientMessage(playerid, 0xFFA500FF, "Задание успешно выполнено, Вы получили {"#cGold"}10000 руб {FFA500}и {"#cGold"}3 exp.");
		                            ShowDisplayText(playerid, "Задание выполнено<br><font color=#F1B50C>10000 руб и 3 EXP", 4000);
		                            SendClientMessage(playerid, -1, "");
		                            GivePlayerMoneyEx(playerid, 7500, "выполнение квеста", true, true);
                                    PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
		                            UpdatePlayerDatabaseInt(playerid, "quest_6_stats", GetPlayerData(playerid, P_QUEST_6_STATS));
		                            AddPlayerData(playerid, P_EXP, +, 1);

                                    if(GetPlayerExp(playerid) > GetExpToNextLevel(playerid))
		                            {
	                                    SetPlayerData(playerid, P_EXP, 0);
                                        AddPlayerData(playerid, P_LEVEL, +, 1);
			                            SendClientMessage(playerid, 0xCECECEFF, "* Поздравляем! Ваш уровень повышен");
			                            SetPlayerLevelInit(playerid);
		                            }
								}
								else SCM(playerid, 0xFF6600FF, "Произошла ошибка в базе данных");
							}
							else SCM(playerid, 0xCECECEFF, "* У Вас недостаточно денег для покупки");
						}
						else SCM(playerid, 0xCECECEFF, "* Вы и продавец должны находиться рядом с транспортом который хотите купить");
					}
					case OFFER_TYPE_SELL_NEFTENASOS:
					{
						if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, -1, "* У вас должен быть минимум 2-й уровень для принятия этого предложения");
						if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), value_2)) return SendClientMessage(playerid, 0xCECECEFF, "* У Вас недостаточно денег для заключения сделки");
						format(fmt_str, sizeof fmt_str, "Вы продали свой нефтяной насос игроку %s за %d руб", GetPlayerNameEx(playerid), value_2);
						SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

						format(fmt_str, sizeof fmt_str, "%s продал Вам нефтяной насос \"№%d\" за %d руб", GetPlayerNameEx(offer_id), value_1, value_2);
						SendClientMessage(playerid, 0x66CC00FF, fmt_str);
						static query[144];
						format(query, sizeof query, "UPDATE neftenasos SET owner_id=%d, owner_name='%s' WHERE id=%d LIMIT 1",GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), GetNeftData(value_1, N_SQL_ID));
						mysql_query(mysql, query, false);
						format(g_neft[value_1][N_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
						SetNeftData(value_1, N_OWNER_ID, 	GetPlayerAccountID(playerid));
						GivePlayerMoneyEx(playerid, -value_2, "Продажа нефтяного насоса игроку", true, true);
						GivePlayerMoneyEx(offer_id, value_2, "Продажа нефтяного насоса игроку", true, true);
						CallLocalFunction("UpdateNeftLabel", "i", value_1);
						SendClientMessage(playerid, 0xFFCD00FF, "Проверьте количество оплаченных дней аренды, при необходимости оплатить ее можно в банке");
					}
					case OFFER_TYPE_SELL_KIOSK:
					{
                        if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, -1, "* У вас должен быть минимум 2-й уровень для принятия этого предложения");
                        if((GetPlayerOwnableKiosk(playerid) + 1) > GetPlayerKioskSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "* Вы уже имеете максимально количество киосков.");
						{
							if(GetILPlayerInt(GetPlayerMoneyEx(playerid), value_2))
							{
								new Float: g_pos_x = GetKioskData(value_1, K_POS_X);
								new Float: g_pos_y = GetKioskData(value_1, K_POS_Y);
								new Float: g_pos_z = GetKioskData(value_1, K_POS_Z);

								if(IsPlayerInRangeOfPoint(playerid, 7.0, g_pos_x, g_pos_y, g_pos_z) && IsPlayerInRangeOfPoint(offer_id, 7.0, g_pos_x, g_pos_y, g_pos_z))
								{
									format(fmt_str, sizeof fmt_str, "Вы продали свой киоск игроку %s за %d руб", GetPlayerNameEx(playerid), value_2);
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

									format(fmt_str, sizeof fmt_str, "%s продал Вам киоск \"№%d\" за %d руб", GetPlayerNameEx(offer_id), value_1, value_2);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);
                                    static query[144];
                                    format(query, sizeof query, "UPDATE PlayersMorallwens SET kiosk=-1 WHERE id=%d LIMIT 1", GetPlayerAccountID(offer_id));
									mysql_query(mysql, query, false);

									format(query, sizeof query, "UPDATE PlayersMorallwens SET kiosk=%d WHERE id=%d LIMIT 1",value_1, GetPlayerAccountID(playerid));
									mysql_query(mysql, query, false);
									format(query, sizeof query, "UPDATE kiosk SET owner_id=%d WHERE id=%d LIMIT 1",GetPlayerAccountID(playerid), GetKioskData(value_1, K_SQL_ID));
									mysql_query(mysql, query, false);
                                    format(g_kiosk[value_1][K_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
                                    SetKioskData(value_1, K_OWNER_ID, 	GetPlayerAccountID(playerid));
									GivePlayerMoneyEx(playerid, -value_2, "Продажа киоску государству", true, true);
									GivePlayerMoneyEx(offer_id, value_2, "Продажа киоска государству", true, true);

									SendClientMessage(playerid, 0xFFCD00FF, "Проверьте количество оплаченных дней аренды, при необходимости оплатить ее можно в банке");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "* Вы и продавец должны находиться рядом с киоском который хотите купить");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* У Вас недостаточно денег для заключения сделки");
						}
					}
					case OFFER_TYPE_SELL_GARAGE:
					{
                        if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, -1, "* У вас должен быть минимум 2-й уровень для принятия этого предложения");
						if(GetPlayerOwnableGarage(playerid) + 1 > GetPlayerGarageSlots(playerid)) return SendClientMessage(playerid, 0x3399FFFF, "* Вы уже имеете максимально количество гаражей.");
						
						if(GetILPlayerInt(GetPlayerMoneyEx(playerid), value_2))
						{
							new Float: g_pos_x = GetGarageData(value_1, G_POS_X);
							new Float: g_pos_y = GetGarageData(value_1, G_POS_Y);
							new Float: g_pos_z = GetGarageData(value_1, G_POS_Z);

							if(IsPlayerInRangeOfPoint(playerid, 7.0, g_pos_x, g_pos_y, g_pos_z) && IsPlayerInRangeOfPoint(offer_id, 7.0, g_pos_x, g_pos_y, g_pos_z))
							{
								format(fmt_str, sizeof fmt_str, "Вы продали свой гараж игроку %s за %d руб", GetPlayerNameEx(playerid), value_2);
								SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

								format(fmt_str, sizeof fmt_str, "%s продал Вам гараж \"№%d\" за %d руб", GetPlayerNameEx(offer_id), GetGarageData(value_1, G_SQL_ID), value_2);
								SendClientMessage(playerid, 0x66CC00FF, fmt_str);

								SellGarage(offer_id, playerid, value_2);
								SendClientMessage(playerid, 0xFFCD00FF, "Проверьте количество оплаченных дней аренды, при необходимости оплатить ее можно в банке");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Вы и продавец должны находиться рядом с гаражом который хотите купить");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* У Вас недостаточно денег для заключения сделки");
					}
					case OFFER_TYPE_MEDHELP:
					{
						if(GetPlayerTeamEx(offer_id) == TEAM_HOSPITAL)
						{
							if(IsPlayerInRangeOfPoint(playerid, 70.0, 431.3744,1704.7421,1001.0000))
							{
								if(GetPlayerData(playerid, P_OCCUPIED_BED) != -1)
								{
									if(GetILPlayerInt(GetPlayerMoneyEx(playerid), value_1))
									{
										GivePlayerMoneyEx(playerid, -value_1, "Курс лечения (купил)", true, true);
										GivePlayerMoneyEx(offer_id, value_1, "Курс лечения (провел)", true, true);

										SetPlayerHealthEx(playerid, 100.0);

										static fmt_msg[128];
										format(fmt_msg, sizeof fmt_msg, "Медицинский работник %s провел курс платного лечения", GetPlayerNameEx(offer_id));
										SendClientMessage(playerid, 0x66CC00FF, fmt_msg);

										format(fmt_msg, sizeof fmt_msg, "Вы провели курс платного лечения у пациента %s", GetPlayerNameEx(playerid));
										SendClientMessage(offer_id, 0x66CC00FF, fmt_msg);

										format(fmt_msg, sizeof fmt_msg, "[MED] Медицинский работник %s[%d] провел курс платного лечения у %s[%d] за %d руб.", GetPlayerNameEx(offer_id), offer_id, GetPlayerNameEx(playerid), playerid, value_1);
										SendMessageToTeam(TEAM_HOSPITAL, fmt_msg, 0x99CC99FF, offer_id);

										ClearMedBed(playerid, GetPlayerData(playerid, P_OCCUPIED_BED));
										SetPlayerData(playerid, P_HOSPITAL, false);
									}
									else SendClientMessage(playerid, 0x999999FF, "* У Вас недостаточно денег, чтобы оплатить лечение");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться на стационарном лечении");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в больнице");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Произошла ошибка");
					}
					case OFFER_TYPE_HEAL:
					{
						new vehicleid = GetPlayerVehicleID(offer_id);

						if(GetPlayerTeamEx(offer_id) == TEAM_HOSPITAL)
						{
							if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_MED_CAR && GetPlayerVehicleID(playerid) == vehicleid)
							{
								if(GetILPlayerInt(GetPlayerMoneyEx(playerid), value_1))
								{
									GivePlayerMoneyEx(playerid, -value_1, "Курс лечения (купил) [veh]", true, true);
									GivePlayerMoneyEx(offer_id, value_1, "Курс лечения (провел) [veh]", true, true);

									SetPlayerHealthEx(playerid, 100.0);

									static fmt_msg[50];
									format(fmt_msg, sizeof fmt_msg, "Вы вылечились у медицинского работника %s", GetPlayerNameEx(offer_id));
									SendClientMessage(playerid, 0x66CC00FF, fmt_msg);

									format(fmt_msg, sizeof fmt_msg, "Вы вылечили пациента %s", GetPlayerNameEx(playerid));
									SendClientMessage(offer_id, 0x66CC00FF, fmt_msg);
								}
								else SendClientMessage(playerid, 0x999999FF, "* У Вас недостаточно денег, чтобы оплатить лечение");
							}
							else SendClientMessage(playerid, 0x999999FF, "* Вы или медицинский работник находитесь не в машине скорой помощи");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Произошла ошибка");
					}
					case OFFER_TYPE_CHANGE_SEX:
					{
						if(GetPlayerTeamEx(offer_id) == TEAM_HOSPITAL)
						{
							if(IsPlayerInRangeOfPoint(playerid, 70.0, 431.3744,1704.7421,1001.0000))
							{
								if(GetPlayerData(playerid, P_OCCUPIED_BED) != -1)
								{
									if(GetILPlayerInt(GetPlayerMoneyEx(playerid), value_1))
									{
										GivePlayerMoneyEx(playerid, -value_1, "Смена пола (купил)", true, true);
										GivePlayerMoneyEx(offer_id, value_1, "Смена пола (провел)", true, true);

										SetPlayerData(playerid, P_SEX, GetPlayerData(playerid, P_SEX) ^ 1);
										UpdatePlayerDatabaseInt(playerid, "sex", GetPlayerData(playerid, P_SEX));

										static fmt_msg[70];
										format(fmt_msg, sizeof fmt_msg, "Медработник %s сделал Вам операцию по смене пола", GetPlayerNameEx(offer_id));
										SendClientMessage(playerid, 0x66CC00FF, fmt_msg);

										format(fmt_msg, sizeof fmt_msg, "Операция у пациента %s была проведена успешно", GetPlayerNameEx(playerid));
										SendClientMessage(offer_id, 0x66CC00FF, fmt_msg);
									}
									else SendClientMessage(playerid, 0x999999FF, "* У Вас недостаточно денег чтобы оплатить операцию");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться на стационарном лечении");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "* Вы должны находиться в больнице");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* Произошла ошибка");
					}
					
					case OFFER_TYPE_GETHERE:
					{
						new Float: player_x,
							Float: player_y,
							Float: player_z;

						GetPlayerPos(offer_id, player_x, player_y, player_z);
						SetPlayerPosEx(playerid, player_x + 1, player_y + 1, player_z, 0.0, GetPlayerInterior(offer_id), GetPlayerVirtualWorld(offer_id), false);

						SCMF(playerid, 0x3399FFFF, "* Администратор %s телепортивал Вас к себе", GetPlayerNameEx(offer_id));
						SCMF(offer_id, 0x3399FFFF, "* Вы телепортировали %s к себе", GetPlayerNameEx(playerid));

						STRING_GLOBAL[0] = EOS;
						format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] телепортировал к себе %s[%d]", GetPlayerNameEx(offer_id), offer_id, GetPlayerNameEx(playerid), playerid);
						SendMessageToAdmins(STRING_GLOBAL, 0x999999FF);
					}
					case OFFER_TYPE_GOTO:
					{
						new Float: player_x,
							Float: player_y,
							Float: player_z;

						GetPlayerPos(playerid, player_x, player_y, player_z);
						SetPlayerPosEx(offer_id, player_x + 1, player_y + 1, player_z, 0.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), false);

						SCMF(offer_id, 0x3399FFFF, "* Администратор %s телепортивал Вас к себе", GetPlayerNameEx(playerid));
						SCMF(playerid, 0x3399FFFF, "* Вы телепортировали %s к себе", GetPlayerNameEx(offer_id));

						STRING_GLOBAL[0] = EOS;
						format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] телепортировал к себе %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(offer_id), offer_id);
						SendMessageToAdmins(STRING_GLOBAL, 0x999999FF);
					}
					case OFFER_TYPE_GIVE_CAR_KEY:
					{
						new vehicleid = GetPlayerOwnableCarLast(offer_id);

						if(vehicleid != INVALID_VEHICLE_ID)
						{
							static fmt_text[80];

							format(fmt_text, sizeof fmt_text, "%s выдал Вам ключи от своего транспорта", GetPlayerNameEx(offer_id));
							SendClientMessage(playerid, 0x66CC00FF, fmt_text);

							SendClientMessage(playerid, -1, "* Вам были переданы ключи от транспорта. Используйте {BBBB00}/lock 4");
							SendClientMessage(playerid, 0xCECECEFF, "* После выхода из игры или выгрузки ТС с сервера они пропадут");

							format(fmt_text, sizeof fmt_text, "Вы дали игроку %s ключи от своего транспорта", GetPlayerNameEx(playerid));
							SendClientMessage(offer_id, 0x66CC00FF, fmt_text);

							SetPlayerData(playerid, P_ALLOWED_CAR, vehicleid);
						}
						else
						{
							if(GetPlayerOwnableCars(offer_id) == 0)
								SendClientMessage(playerid, 0x999999FF, "* У игрока нет личного транспорта");
							else
								SendClientMessage(playerid, 0x999999FF, "* Личный транспорт игрока не загружен на сервер");
						}
					}
					case OFFER_TYPE_GIVE_MIC:
					{
						SetPVarInt(playerid, "radio_mic", 1);

						static fmt_text[128];

						format(fmt_text, sizeof fmt_text, "%s дал Вам доступ к радио-эфиру", GetPlayerNameEx(offer_id));
						SendClientMessage(playerid, 0x66CC33FF, fmt_text);

						SendClientMessage(playerid, -1, "* Вам был дан микрофон. Вы имеете доступ к радио-эфиру. Используйте: {BBBB00}/u");

						format(fmt_text, sizeof fmt_text, "Вы дали игроку %s доступ к радио-эфиру", GetPlayerNameEx(playerid));
						SendClientMessage(offer_id, 0x66CC33FF, fmt_text);

						format(fmt_text, sizeof fmt_text, "[СМИ] %s %s[%d] подключил %s[%d] к радио-эфиру",
						GetPlayerJobAndRankName(offer_id), GetPlayerNameEx(offer_id), offer_id, GetPlayerNameEx(playerid), playerid);

						SendMessageToTeam(GetPlayerTeamEx(offer_id), fmt_text, 0x99CC99FF, offer_id);
					}
					case OFFER_TYPE_GIVE_LIC:
					{
						new lic_names[3][34] = {"вождение базового уровня", "вождение профессионального уровня", "оружие"};

						static fmt_text[85];

						switch(value_1)
						{
							case 1..2:
							{
								AddPlayerData(playerid, P_DRIVING_LIC, +, 1);
								UpdatePlayerDatabaseInt(playerid, "driving_lic", GetPlayerData(playerid, P_DRIVING_LIC));
							}
							case 3:
							{
								SetPlayerData(playerid, P_WEAPON_LIC, 1);
								UpdatePlayerDatabaseInt(playerid, "weapon_lic", 1);
							}
						}

						format(fmt_text, sizeof fmt_text, "%s продал Вам лицензию на %s за %d рублей",
						GetPlayerNameEx(offer_id), lic_names[value_1 - 1], value_2);

						SendClientMessage(playerid, 0x3399FFFF, fmt_text);

						format(fmt_text, sizeof fmt_text, "Вы продали %s лицензию на %s за %d рублей",
						GetPlayerNameEx(playerid), lic_names[value_1 - 1], value_2);

						SendClientMessage(offer_id, 0x3399FFFF, fmt_text);
						SendClientMessage(offer_id, 0x3399FFFF, "* К Вашей зарплате добавлено 10% от стоимости лицензии");

						new wage = value_2 / 10;

						format(fmt_text, sizeof fmt_text, "Покупка лицензии на %s у %s", lic_names[value_1 - 1], GetPlayerNameEx(offer_id));

						GivePlayerMoneyEx(playerid, -value_2, fmt_text, true, true);

						AddPlayerData(offer_id, P_WAGE, +, wage);
						UpdatePlayerDatabaseInt(offer_id, "wage", GetPlayerData(offer_id, P_WAGE));

						format(fmt_text, sizeof fmt_text, "~b~~h~+%d рублей", wage);
						GameText(offer_id, fmt_text, 4000, 2);
					}
					case OFFER_TYPE_JAIL_FREE:
					{
						static fmt_text[80];

						format(fmt_text, sizeof fmt_text, "%s помог пересмотреть Ваше дело. Вы выпущены на свободу", GetPlayerNameEx(offer_id));
						SendClientMessage(playerid, 0x66CC33FF, fmt_text);

						format(fmt_text, sizeof fmt_text, "Вы пересмотрели дело %s. Игрок выпущен на свободу", GetPlayerNameEx(playerid));
						SendClientMessage(offer_id, 0x3399FFFF, fmt_text);

						format(fmt_text, sizeof fmt_text, "Стоимость услуги: %d руб. 10% этой суммы добавлено к Вашей зарплате", value_1);
						SendClientMessage(offer_id, 0x3399FFFF, fmt_text);

						GivePlayerMoneyEx(playerid, -value_1, "Оплата адвоката", true, true);

						UnjailPlayer(playerid);

						new wage = value_1 / 10;

						AddPlayerData(offer_id, P_WAGE, +, wage);
						UpdatePlayerDatabaseInt(offer_id, "wage", GetPlayerData(offer_id, P_WAGE));

						format(fmt_text, sizeof fmt_text, "~b~~h~+%d рублей", wage);
						GameText(offer_id, fmt_text, 4000, 2);
					}
					case OFFER_TYPE_SELL_SKIN:
					{
						if(GetPlayerLevel(playerid) < 2) return SendClientMessage(playerid, -1, "* У вас должен быть минимум 2-й уровнь для принятия этого предложения");
                        if(GetILPlayerInt(GetPlayerMoneyEx(playerid), value_1))
						{
                            new skin_sell = GetPlayerSkinEx(offer_id);

                            GivePlayerMoneyEx(playerid, -value_1, "Продажа скина с рук", false, true);

							GivePlayerMoneyEx(offer_id, value_1, "Продажа скина с рук", true, true);

							if(GetPlayerSex(playerid) == 0)
							{
							    SetPlayerData(offer_id, P_SKIN, 45);
								SetPlayerData(playerid, P_SKIN, skin_sell);
							}
							else
							{
							    SetPlayerData(offer_id, P_SKIN, 75);
								SetPlayerData(playerid, P_SKIN, skin_sell);
							}
							UpdatePlayerDatabaseInt(playerid, "skin", GetPlayerSkinEx(playerid));
							UpdatePlayerDatabaseInt(offer_id, "skin", GetPlayerSkinEx(offer_id));
							SetPlayerSkinInit(offer_id);
							SetPlayerSkinInit(playerid);
						}
						else SendClientMessage(playerid, 0xCECECEFF, "* У Вас недостаточно денег для покупки");
					}
					
					case OFFER_TYPE_SHOWPASS:
					{
					    static fmt_text[200];

						format(fmt_text, sizeof fmt_text, "[[0,[\"%s\",%d,\"Дом\",%d,0,%d,%d,%d,\"\"]]]",
						GetPlayerNameEx(offer_id), GetPlayerData(offer_id, P_SEX) ? 1 : 0, GetPlayerLevel(offer_id), GetPlayerSkin(offer_id), GetPlayerData(offer_id, P_LAW_ABIDING), 0);

						MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Docs", fmt_text);

						format(fmt_str, sizeof fmt_str, "показал свой паспорт игроку %s", GetPlayerNameEx(playerid));

						Action(offer_id, fmt_str, _, false);
					}
					case OFFER_TYPE_SHOWLIC:
					{
						static fmt_text[200];

						format(fmt_text, sizeof fmt_text, "[[1,[\"%s\",[%d,%d,%d,1,1]]]]",
						GetPlayerNameEx(offer_id), GetPlayerData(offer_id, P_DRIVING_LIC), GetPlayerData(offer_id, P_DRIVING_LIC), GetPlayerData(offer_id, P_WEAPON_LIC));

						MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Docs", fmt_text);

						format(fmt_str, sizeof fmt_str, "показал свои лицензии игроку %s", GetPlayerNameEx(playerid));

						Action(offer_id, fmt_str, _, false);
					}

					default:
						SendClientMessage(playerid, 0x999999FF, "* В данный момент Вам ничего не предлагают");
				}
			}
			else SendClientMessage(playerid, 0x999999FF, "* Игрок слишком далеко");
		}
		else SendClientMessage(playerid, 0x999999FF, "* Игрок вышел из игры");

		ClearPlayerOffer(playerid);
	}
	else SendClientMessage(playerid, 0x999999FF, "");

	return 1;
}

cmd:train_work(playerid)
{
	if(player_train[playerid])
	{
		str_global_text[0] = EOS;
		STRING_GLOBAL[0] = EOS;
		for(new i;i < number_player_train; i ++)
		{
			format(STRING_GLOBAL,sizeof STRING_GLOBAL, "%s<n>",train_player_list[i]);
			strcat(str_global_text, STRING_GLOBAL);
		}
		strdel(str_global_text, strlen(str_global_text) - 1, strlen(str_global_text));
		Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST,"{FFCD00}Машинист", str_global_text, "Вперед","Назад");
	}
	return 1;
}
cmd:givemandarinki(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11) return 1;
	else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "Покупным администраторам недоступна данная функция");


	extract params -> new to_player, random111; else return SCM(playerid, 0xCECECEFF, "* Используйте: /givemandarinki [ид игрока] [кол-во]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SCM(playerid, 0xCECECEFF, "* Такого игрока нет");
	
	if(random111 > 5000 || random111 < 1) return SCM(playerid, 0xCECECEFF, "* Нельзя выдавать более 5000 Мандаринок или менее 1 Мандаринки за раз!");
	
	GiveIteam(to_player, 347, 1, random111, 0);

	STRING_GLOBAL[0] = EOS;

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s выдал Вам предмет 'Мандаринки' в количестве %d шт", GetPlayerNameEx(playerid), random111);
	SendClientMessage(to_player, 0xFFFFFFFF, STRING_GLOBAL);

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] выдал предмет 'Мандаринки' %s[%d] в количестве %d шт", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, random111);
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);
	return 1;
}