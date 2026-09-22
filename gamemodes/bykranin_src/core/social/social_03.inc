//>> Файл: bykranin_src/core/social/social_03.inc  (760 строк)
//>> Тема: телефон, чаты, объявления, справка
//>> Внутри: /pay, /agm, /debug, /givecase, /givecoins, /topmoney, TopMoney
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:pay(playerid, params[])
{
	extract params -> new to_player, cash; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /pay [id игрока] [сумма]");

	

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0x999999FF, ""USC"Игрок находится далеко от Вас");

	new fmt_text[75],
		max_money = 50000;

	if(!(1 <= cash <= max_money))
	{
		format(fmt_text, sizeof fmt_text, ""USC"Сумма должна быть от 1 до %d рублей", max_money);

		SendClientMessage(playerid, 0xCECECEFF, fmt_text);
		return 1;
	}

	format(fmt_text, sizeof fmt_text, "+%d", cash);
	SetPlayerChatBubble(to_player, fmt_text, 0x00CC00FF, 10.0, 5000);

	format(fmt_text, sizeof fmt_text, "-%d", cash);
	SetPlayerChatBubble(playerid, fmt_text, 0xFF6600FF, 10.0, 5000);

	format(fmt_text, sizeof fmt_text, "Передача денег от %s", GetPlayerNameEx(playerid));
	GivePlayerMoneyEx(to_player, cash, fmt_text, true, true);

	format(fmt_text, sizeof fmt_text, "Передача денег игроку %s", GetPlayerNameEx(to_player));
	GivePlayerMoneyEx(playerid, -cash, fmt_text, true, true);

	format(fmt_text, sizeof fmt_text, "%s передал Вам деньги %d руб", GetPlayerNameEx(playerid), cash);
	SendClientMessage(to_player, 0x3399FFFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "Вы передали игроку %s деньги %d руб", GetPlayerNameEx(to_player), cash);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

	Action(playerid, "достал кошелёк и передал деньги", _, false);

	return 1;
}

CMD:agm(playerid, params[])
{
	if(GetPlayerAdminEx(playerid)< 1 && GetPlayerYouTubeEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
    if(GetPVarInt(playerid,"agm") == 0)
    {
        new fmt_msg[999];
        SetPVarInt(playerid,"agm", 1);
        SetPlayerHealth(playerid, 0x7F800000);
        SendClientMessage(playerid, -1, ""SC"Вы успешно {FFFF00}включили {FFFFFF}административное бессмертие");
        format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] включил административное бессмертие", GetPlayerNameEx(playerid), playerid);
        SendMessageToAdmins(fmt_msg, 0x999999FF);
    }
					else
    {
        new fmt_msg[999];
        SetPVarInt(playerid,"agm", 0);
        SetPlayerHealth(playerid, 100.0);
        SendClientMessage(playerid, -1, ""SC"Вы успешно {FFFF00}выключили {FFFFFF}административное бессмертие");
        format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] выключил административное бессмертие", GetPlayerNameEx(playerid), playerid);
        SendMessageToAdmins(fmt_msg, 0x999999FF);
    }
    return 1;
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
	
	format(fmt_text, sizeof fmt_text, "~b~+%d case", give);
	GameTextForPlayer(to_player, fmt_text, 4000, 1);

	format(fmt_text, sizeof fmt_text, "Вы передали донат кейсы игроку %s в количестве %d", GetPlayerNameEx(to_player), give);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

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
	
	format(fmt_text, sizeof fmt_text, "~b~+%d coins", give);
	GameTextForPlayer(to_player, fmt_text, 4000, 1);

	format(fmt_text, sizeof fmt_text, "Вы передали монеты игроку %s в количестве %d", GetPlayerNameEx(to_player), give);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

	format(fmt_text, sizeof fmt_text, "Администратор %s передал Вам монеты в количестве %d", GetPlayerNameEx(playerid), give);
	SendClientMessage(to_player, 0x3399FFFF, fmt_text);

	return 1;
}

CMD:topmoney(playerid)
{
	new string[256];
	format(string, 256, "SELECT * FROM `accounts` ORDER BY money DESC LIMIT 10");
	mysql_tquery(mysql, string, "TopMoney", "d",playerid);

	return 1;
}

public: TopMoney(playerid)
{
	new name[24], cash,rows,fields, string[2000];
	cache_get_data(rows, fields);
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			name[0] = EOS;
			cash = 0;
			cache_get_field_content(i, "name", name, mysql);
			cash = cache_get_field_content_int(i, "money", mysql);
			format(string, sizeof(string), "%s\n"c_b"Ник: "c_server"%s\t "c_b"| \t"c_b"Денег: "c_server"%d", string, name, cash);
			strcat(string, string, 0);
		}
	}

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Топ 10 игроков по деньгам", string, "Закрыть", "");

	return 1;
}

CMD:history(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /history [имя игрока]");

	if(!(3 <= strlen(params) <= 20))
		return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

	extract params -> new string: name[21];

	new query[128];
	new Cache: result, user_id;

	mysql_format(mysql, query, sizeof query, "SELECT id FROM accounts WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows(result))
		user_id = cache_get_row_int(0, 0);

	cache_delete(result);

	if(!user_id)
		return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

	format(query, sizeof query, "SELECT name FROM change_names WHERE owner_id=%d ORDER BY id DESC LIMIT 45", user_id);
	mysql_tquery(mysql, query, "ShowChangeNameHistory", "is", playerid, name);

	return 1;
}

CMD:call(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0x999999FF, "У Вас нет телефона. Его можно купить в 24/7");

	if(GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER) != INVALID_PLAYER_ID || GetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER) != INVALID_PLAYER_ID)
		return SendClientMessage(playerid, 0x999999FF, "Закончите текущий разговор");

	if(!GetPlayerPhoneCall(playerid, PC_ENABLED))
		return SendClientMessage(playerid, 0x999999FF, "Ваш телефон отключен");

	if(GetPlayerData(playerid, P_PHONE_BALANCE) >= 5)
	{
		new number;
		if(sscanf(params, "d", number))
		{
			Dialog
			(
				playerid, DIALOG_PHONE_CALL, DIALOG_STYLE_INPUT,
				"{FFCD00}Наберите номер",
				"{6699CC}Номера государственных служб:\n\n\
				{FFFFFF}Полиция\t\t\t{66CC00}02\n\
				{FFFFFF}Скорая помощь\t\t{66CC00}03\n\
				{FFFFFF}Такси\t\t\t\t{66CC00}555\n\
				{FFFFFF}Механик\t\t\t{66CC00}090\n\
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
			case 111:
			{
				new fmt_str[175];
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
				Dialog(playerid, DIALOG_PHONE_CALL_BALANCE, DIALOG_STYLE_MSGBOX, "{FFCD00}Оператор сотовой связи", fmt_str, "Ок", "Отмена");
			}

			default:
			{
				new subscriber = GetPlayerIDByPhone(number);

				if(number < 1)
					return SendClientMessage(playerid, 0x999999FF, "Данный номер не обслуживается");

				if(subscriber == INVALID_PLAYER_ID)
					return SendClientMessage(playerid, 0xCECECEFF, "Набранный Вами номер не обслуживается");

				if(subscriber == playerid || GetPlayerPhoneCall(subscriber, PC_INCOMING_PLAYER) != INVALID_PLAYER_ID || GetPlayerPhoneCall(subscriber, PC_OUTCOMING_PLAYER) != INVALID_PLAYER_ID)
					return SendClientMessage(playerid, 0x999999FF, "Абонент занят");

				if(!GetPlayerPhoneCall(subscriber, PC_ENABLED))
					return SendClientMessage(playerid, 0x999999FF, "Телефон абонента вне зоны доступа");

				SetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER, subscriber);
				SetPlayerPhoneCall(subscriber, PC_INCOMING_PLAYER, playerid);

				new fmt_str[90];

				format(fmt_str, sizeof fmt_str, "{FFFFFF}Исходящий звонок | Номер:{ffff00}%d {FFFFFF}| Ожидание ответа от %s", number, GetPlayerNameEx(subscriber));
				SendClientMessage(playerid, 0x66CC00FF, fmt_str);

				format(fmt_str, sizeof fmt_str, "{FFFFFF}Входящий звонок | Номер:{ffff00}%d {FFFFFF}| Вызывает{ffff00} %s", GetPlayerPhone(playerid), GetPlayerNameEx(playerid));
				SendClientMessage(subscriber, 0x3399FFFF, fmt_str);

				SendClientMessage(subscriber, 0xFFFFFFFF, "Используйте {ffff00}/p {FFFFFF}чтобы ответить или {ffff00}/h {FFFFFF}чтобы отклонить вызов.");
				SetPlayerPhoneUseState(playerid, true);
			}
		}
	}
					else
	{
		SendClientMessage(playerid, 0xCECECEFF, "На счету недостаточно средств");
		SendClientMessage(playerid, 0xCECECEFF, "Пополнить мобильный телефон можно в любом банкомате");
	}

	return 1;
}
alias:call("c")

CMD:p(playerid, params[])
{
	if(GetPlayerPhoneCall(playerid, PC_TIME) != -1) return 1;

	new caller = GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER);
	if(caller != INVALID_PLAYER_ID)
	{
		SetPlayerPhoneCall(caller, PC_TIME, 0);
		SetPlayerPhoneCall(playerid, PC_TIME, 0);

		new fmt_str[64];
		format(fmt_str, sizeof fmt_str, "{FFFFFF}Вы ответили на звонок {ffff00} %s", GetPlayerNameEx(caller));
		SendClientMessage(playerid, 0xDD90FFFF, fmt_str);

		format(fmt_str, sizeof fmt_str, "{ffff00} %s {FFFFFF}ответил на Ваш звонок", GetPlayerNameEx(playerid));
		SendClientMessage(caller, 0xDD90FFFF, fmt_str);

		SetPlayerPhoneUseState(playerid, true, false);
	}
					else SendClientMessage(playerid, 0xCECECEFF, "Нет входящих вызовов");

	return 1;
}

CMD:h(playerid, params[])
{
	new caller = GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER);
	new call_to = GetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER);

	if(call_to != INVALID_PLAYER_ID)
	{
		if(GetPlayerPhoneCall(call_to, PC_INCOMING_PLAYER) == playerid)
		{
			ClearPlayerPhoneCall(call_to);
			SendClientMessage(call_to, 0xFF9944FF, "{ffff00}| {FFFFFF}Звонок окончен");

			SetPlayerPhoneUseState(call_to, false);
		}
		SendClientMessage(playerid, 0xFF9944FF, "{ffff00}| {FFFFFF}Звонок окончен");
	}
					else if(caller != INVALID_PLAYER_ID)
	{
		if(GetPlayerPhoneCall(caller, PC_OUTCOMING_PLAYER) == playerid)
		{
			ClearPlayerPhoneCall(caller);
			SendClientMessage(caller, 0xFF9944FF, "{ffff00}| {FFFFFF}Звонок окончен");

			SetPlayerPhoneUseState(caller, false);
		}
		if(GetPlayerPhoneCall(playerid, PC_TIME) != -1)
		{
			SendClientMessage(playerid, 0xFF9944FF, "{ffff00}| {FFFFFF}Звонок окончен");
		}
					else SendClientMessage(playerid, 0xFF9944FF, "{ffff00}| {FFFFFF}Вы отклонили входящий вызов");
	}
					else return 1;

	ClearPlayerPhoneCall(playerid);
	SetPlayerPhoneUseState(playerid, false);

	return 1;
}
stock ShowPlayerPropertySelectDialog(playerid)
{
    new accid = GetPlayerAccountID(playerid);
    new fmt_str[4096];
    new count = 0;

    fmt_str[0] = EOS;
    gPlayerPropertyCount[playerid] = 0;

    for (new i = 0; i < HOUSES_FOR_SALE_COUNT; i++)
    {
        if (gHouseOwned[i] && gHouseOwnerID[i] == accid)
        {
            format(fmt_str, sizeof(fmt_str), "%sДом №%d\n", fmt_str, i + 3000);
            if(count < MAX_PLAYER_PROPERTIES)
            {
                gPlayerPropertyType[playerid][count] = 0;
                gPlayerPropertyID[playerid][count] = i;
            }
            count++;
        }
    }

    for (new i = 0; i < 200000; i++)
    {
        if (gFlatOwned[i] && gFlatOwnerID[i] == accid)
        {
            new real_flatid = g_flat_real_id[i];
            new houseid = real_flatid / 1000;
            new floor = (real_flatid % 1000) / 10;
            new flatidx = (real_flatid % 10) + (4 * (floor - 1));

            format(fmt_str, sizeof(fmt_str), "%sКвартира №%d-%d\n", fmt_str, houseid + 100, flatidx);
            if(count < MAX_PLAYER_PROPERTIES)
            {
                gPlayerPropertyType[playerid][count] = 1;
                gPlayerPropertyID[playerid][count] = i;
            }
            count++;
        }
    }

    if(count > MAX_PLAYER_PROPERTIES) count = MAX_PLAYER_PROPERTIES;
    gPlayerPropertyCount[playerid] = count;

    if (count < 2)
        return SendClientMessage(playerid, -1, "У вас менее двух недвижимостей.");

    Dialog(playerid, DIALOG_SELECT_PLAYER_PROPERTY, DIALOG_STYLE_LIST,
        "{3A94AE}Выбор дома/квартиры",
        fmt_str,
        "Выбрать", "Назад");
    return 1;
}
CMD:sms(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0x999999FF, "У Вас нет телефона. Его можно купить в 24/7");

	if(!GetPlayerPhoneCall(playerid, PC_ENABLED))
		return SendClientMessage(playerid, 0x999999FF, "Ваш телефон отключен");

	if(GetPlayerData(playerid, P_PHONE_BALANCE) >= 5)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sms [номер телефона] [сообщение]");

		extract params -> new number, string:message[66];

		if(IsAIP(message))
		{
	   		SendClientMessage(playerid, -1, "Подозрения в рекламе!");
	       	return false;
	    }

		if(number < 550)
			return SendClientMessage(playerid, 0x999999FF, "Данный номер не обслуживается");

		new subscriber = GetPlayerIDByPhone(number);

		if(subscriber != INVALID_PLAYER_ID)
		{
			if(!GetPlayerPhoneCall(subscriber, PC_ENABLED))
				return SendClientMessage(playerid, 0x999999FF, "Не удается отправить сообщение. Телефон абонента недоступен");

			if(!strlen(message))
				return SendClientMessage(playerid, 0xCECECEFF, "Введите сообщение для отправки");

			if(strlen(message) > 64)
				return SendClientMessage(playerid, 0xCECECEFF, "Слишком длинное сообщение");

			AddPlayerData(playerid, P_PHONE_BALANCE, -, 5);
			GameTextForPlayer(playerid, "SMS ~n~~y~-5 rub", 4000, 1);

			new fmt_str[128];

			format(fmt_str, sizeof fmt_str, "SMS: %s | Отправитель: %s [т.%d]", message, GetPlayerNameEx(playerid), GetPlayerPhone(playerid));
			SendClientMessage(subscriber, 0xFFFF00FF, fmt_str);
			SetPlayerChatBubble(subscriber, "SMS <<", 0xFFFF00FF, 5.0, 1500);

			format(fmt_str, sizeof fmt_str, "SMS: %s | Получатель: %s [т.%d]", message, GetPlayerNameEx(subscriber), GetPlayerPhone(subscriber));
			SendClientMessage(playerid, 0xFFFF00FF, fmt_str);
			SetPlayerChatBubble(playerid, "SMS >>", 0xFFFF00FF, 5.0, 1500);

			format(fmt_str, sizeof fmt_str, "UPDATE accounts SET phone_balance=%d WHERE id=%d LIMIT 1", GetPlayerData(playerid, P_PHONE_BALANCE), GetPlayerAccountID(playerid));
			mysql_tquery(mysql, fmt_str, "", "");

			if(g_admin_ears)
			{
				format(fmt_str, sizeof fmt_str, "[A] SMS: %s | от %s[%d] к %s[%d]", message, GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(subscriber), subscriber);
				SendMessageToAdmins(fmt_str, 0xFFFF00FF);
			}

			format(fmt_str, sizeof fmt_str, "Для %s[acc:%d]: %s", GetPlayerNameEx(subscriber), GetPlayerAccountID(subscriber), message);
			SendLog(playerid, LOG_TYPE_SMS_CHAT, fmt_str);
		}
					else SendClientMessage(playerid, 0x999999FF, "Телефон находится вне зоны доступа");
	}
					else
	{
		SendClientMessage(playerid, 0xCECECEFF, "На счету недостаточно средств");
		SendClientMessage(playerid, 0xCECECEFF, "Пополнить мобильный телефон можно в любом банкомате");
	}
	return 1;
}

CMD:eject(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || !IsPlayerDriver(playerid))
		return SendClientMessage(playerid, 0x999999FF, "Вы должны сидеть за рулем транспорта");

	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "Используйте: /eject [id игрока]");

	extract params -> new to_player;

	if(vehicleid != GetPlayerVehicleID(to_player) || playerid == to_player)
		return SendClientMessage(playerid, 0x999999FF, "Игрок должен сидеть в Вашем транспорте");

	RemovePlayerFromVehicle(to_player);

	new fmt_str[64];
	format(fmt_str, sizeof fmt_str, "%s выкинул Вас из своего транспорта", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, 0x3399FFFF, fmt_str);

	format(fmt_str, sizeof fmt_str, "Вы выкинули %s из своего транспорта", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, 0x3399FFFF, fmt_str);

	return 1;
}

CMD:book(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0x999999FF, "У Вас нет телефона. Его можно купить в 24/7");

	return ShowPlayerPhoneBook(playerid);
}

CMD:add(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0x999999FF, "У Вас нет телефона. Его можно купить в 24/7");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /add [id игрока] [номер телефона]");

	extract params -> new to_player, string: number[10];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!IsPlayerPhoneBookInit(playerid))
		InitPlayerPhoneBook(playerid);

	if(GetPlayerPhoneBookContacts(playerid) >= MAX_PHONE_BOOK_CONTACTS)
		return SendClientMessage(playerid, 0xCECECEFF, "Записная книжка заполнена. Удалите ненужные контакты");

	if((3 <= strlen(number) <= 9) && IsNumeric(number) && strval(number) > 0)
		return AddPhoneBookContact(playerid, GetPlayerNameEx(to_player), number);

	SetPVarString(playerid, "add_contact_name", GetPlayerNameEx(to_player));
	new fmt_str[64 + 1];

	format(fmt_str, sizeof fmt_str, "{FFFFFF}Введите номер телефона для контакта %s", GetPlayerNameEx(to_player));
	return Dialog(playerid, DIALOG_PHONE_BOOK_ADD_CONTACT, DIALOG_STYLE_INPUT, "{FFCD00}Добавление нового контакта", fmt_str, "Добавить", "Отмена");
}

CMD:buyfuelst(playerid, params[])
{
	if(GetPlayerFuelStation(playerid) != -1)
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас уже есть заправка. Чтобы купить другую необходимо продать старую");

	new stationid = GetNearestFuelStation(playerid, 10.0);
	if(stationid != -1)
	{

//		if(!PlayerTotalOnline(playerid, 5))
//			return SendClientMessage(playerid, 0x999999FF, "Для покупки бизнеса необходимо отыграть 5 часов");

		SetPVarInt(playerid, "buy_fuel_st", stationid);

		new fmt_str[256];
		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Название:\t\t\t{339999}%s\n"\
			"{FFFFFF}Стоимость:\t\t\t{6699FF}%d руб\n"\
			"{FFFFFF}Плата за аренду:\t\t{6699FF}%d руб в день\n\n"\
			"{669966}Вы уверены что хотите купить эту заправку?",
			GetFuelStationData(stationid, FS_NAME),
			GetFuelStationData(stationid, FS_PRICE),
			GetFuelStationData(stationid, FS_RENT_PRICE)
		);
		Dialog(playerid, DIALOG_FUEL_STATION_BUY, DIALOG_STYLE_MSGBOX, "{33AACC}Покупка заправочной станции", fmt_str, "Да", "Нет");
	}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны быть рядом с заправкой, которую хотите купить");

	return 1;
}

CMD:fuelst(playerid, params[])
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		new fmt_str[1024];
		new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
		GetCityName(GetFuelStationData(stationid, FS_POS_X), GetFuelStationData(stationid, FS_POS_Y), city);
		GetAreaName(GetFuelStationData(stationid, FS_POS_X), GetFuelStationData(stationid, FS_POS_Y), area);
		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Название:\t\t\t\t{339999}%s\n"\
			"{FFFFFF}Номер заправки:\t\t\t%d\n"\
			"Владелец:\t\t\t\t%s\n"\
			"Город / область:\t\t\t%s\n"\
			"Район:\t\t\t\t\t%s\n"\
			"Уровень улучшений:\t\t\t%d\n"\
			"Количество топлива:\t\t\t{66CC00}%d {FFFFFF}из {FFFF00}%d\n"\
			"{FFFFFF}Цена топлива:\t\t\t92:50|95:50|98:50|100:50|ДТ:50\n"\
			"Закупочная цена:\t\t\t%d руб за 1 л\n"\
			"Баланс АЗС:\t\t\t%d руб\n"\
			"АЗС арендована на:\t\t\t{66CC00}%d {FFFFFF}из {FFFF00}30 {FFFFFF}дней\n"\
			"Гос. стоимость:\t\t\t%d руб\n"\
			"Аренда территории:\t\t\t%d руб в день\n"\
			"Акцизный сбор:\t\t\t%s\n"\
			"Статус:\t\t\t\t\t%s\n\n"\
			"{669966}Для открытия панели управления заправочной станцией\n"\
			"нажмите кнопку \"Изменить\"",
			GetFuelStationData(stationid, FS_NAME),
			stationid,
			GetFuelStationData(stationid, FS_OWNER_NAME),
			city,
			area,
			GetFuelStationData(stationid, FS_IMPROVEMENTS),
			GetFuelStationData(stationid, FS_FUELS),
			GetFuelStationMaxFuel(stationid),
			GetFuelStationData(stationid, FS_BUY_FUEL_PRICE),
			GetFuelStationData(stationid, FS_BALANCE),
			GetFuelStationData(stationid, FS_RENT_DATE) <= gettime() ? 0 :
			GetElapsedTime(GetFuelStationData(stationid, FS_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
			GetFuelStationData(stationid, FS_PRICE),
			GetFuelStationData(stationid, FS_IMPROVEMENTS) < 4 ? GetFuelStationData(stationid, FS_RENT_PRICE) : GetFuelStationData(stationid, FS_RENT_PRICE) / 2,
			GetFuelStationData(stationid, FS_IMPROVEMENTS) < 4 ? ("Взымается") : ("Не взымается"),
			GetFuelStationData(stationid, FS_LOCK_STATUS) ? ("{CC3333}Станция закрыта") : ("{66CC33}Станция открыта")
		);
		Dialog(playerid, DIALOG_FUEL_STATION_INFO, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} -> Информация о заправке", fmt_str, "Изменить", "Отмена");
	}
					else SendClientMessage(playerid, 0x999999FF, "У Вас нет заправки");

	return 1;
}

CMD:sellfuelst(playerid, params[])
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		Dialog
		(
			playerid, DIALOG_FUEL_STATION_SELL, DIALOG_STYLE_MSGBOX,
			"{FFCD00}Продажа заправочной станции",
			"{FFFFFF}Вы уверены что хотите продать свою заправочную станцию государству?\n\n"\
			"Вам будет возвращена ее стоимость за вычитом 30%\n"\
			"Также будет возвращено 60% от стоимости купленных улучшений\n\n"\
			"Если Вы хотите продать заправочную станцию другому игроку,\n"\
			"используйте команду /sellmyfuelst",
			"Да", "Нет"
		);
	}
					else SendClientMessage(playerid, 0x999999FF, "У Вас нет заправки");

	return 1;
}

CMD:sellmyfuelst(playerid, params[])
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sellmyfuelst [id игрока] [стоимость]");

		extract params -> new to_player, price;

		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
			return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

		if(price < 1)
			return SendClientMessage(playerid, 0xCECECEFF, "Укажите стоимость продажи");

		new Float: f_pos_x = GetFuelStationData(stationid, FS_POS_X);
		new Float: f_pos_y = GetFuelStationData(stationid, FS_POS_Y);
		new Float: f_pos_z = GetFuelStationData(stationid, FS_POS_Z);

		if(GetPlayerMoneyEx(to_player) < price)
			return SendClientMessage(playerid, 0xCECECEFF, "У покупателя нет такого количества средств");

		if(!(IsPlayerInRangeOfPoint(playerid, 10.0, f_pos_x, f_pos_y, f_pos_z) && IsPlayerInRangeOfPoint(to_player, 10.0, f_pos_x, f_pos_y, f_pos_z)))
			SendClientMessage(playerid, 0xCECECEFF, "Вы и покупатель должны находиться рядом с заправкой которую хотите продать");

		SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_FUEL_ST, stationid);
	}
					else SendClientMessage(playerid, 0x999999FF, "У Вас нет заправки");

	return 1;
}

CMD:fuel(playerid, params[])
{
	new fmt_str[41];
	new string[40 * (MAX_FUEL_STATIONS+2) + 1] = "№ АЗС\t\tСтоимость 1 л\t\tВ наличии\t\tНазвание АЗС\n\n{FFFFFF}";

	for(new idx; idx < g_fuel_station_loaded; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "%d\t\t\t%d руб\t\t%d л\t\t%s\n", idx, GetFuelStationData(idx, FS_FUEL_PRICE), GetFuelStationData(idx, FS_FUELS), GetFuelStationData(idx, FS_NAME));
		strcat(string, fmt_str);
	}
	return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{FFCD00}Заправочные станции", string, "Закрыть", "");
}

/*CMD:buyrepaircar(playerid)
{
    ShowPlayerBuyRepairCar(playerid);
}

stock ShowPlayerBuyRepairCar(playerid)
{
	new stationid = GetPVarInt(playerid, "buy_jerrican_in_fuelst");
	DeletePVar(playerid, "buy_jerrican_in_fuelst");

	if(IsPlayerInRangeOfPoint(playerid, 10.0, GetFuelStationData(stationid, FS_POS_X), GetFuelStationData(stationid, FS_POS_Y), GetFuelStationData(stationid, FS_POS_Z)))
	{
		new price = 100000;
		if(GetPlayerMoneyEx(playerid) >= price)
		{
			new query[150];

			if(IsFuelStationOwned(stationid))
			{

				AddFuelStationData(stationid, FS_FUELS, -, 15);
				AddFuelStationData(stationid, FS_BALANCE, +, 100000);

				format(query, sizeof query, "UPDATE accounts a,fuel_stations f SET a.money=%d,f.fuels=%d,f.balance=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-price, GetFuelStationData(stationid, FS_FUELS), GetFuelStationData(stationid, FS_BALANCE), GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
			}
					else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));

			mysql_query(mysql, query, false);
			if(!mysql_errno())
			{
				new buy_fuel_pay = GetPVarInt(playerid, "buy_fuel_pay_j");
				SetPVarInt(playerid, "buy_fuel_pay_j", buy_fuel_pay + 100000);

				GivePlayerMoneyEx(playerid, 100000, "Покупка канистры на АЗС", false, true);

				SetPVarInt(playerid, "have_jerrican", 1);
			//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 1650, A_OBJECT_BONE_LEFT_HAND, 0.15, 0.0, 0.0, 0.0, -90.0, 180.0, 1.0, 1.0, 1.0, 0);
			
			    AddPlayerData(playerid, P_REPCARID, +, 1);
				UpdatePlayerDatabaseInt(playerid, "repcarid",GetPlayerData(playerid, P_REPCARID));

				SendClientMessage(playerid, 0x66CC00FF, "Вы купили рем. комплекс");
				SendClientMessage(playerid, 0x3399FFFF, "введите /repaircar чтобы починить машину");
				//SendClientMessage(playerid, 0xCECECEFF, "Примечание: Вы не должны двигаться во время заправки. ПКМ - правая кнопка мышки");
			}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 19)");
		}
					else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег для покупки канистры");
	}
}*/

CMD:buyrepaircar(playerid, params[])
{
    ShowPlayerBuyRepairCarDialog(playerid, GetNearestFuelStation(playerid, 10.0));
}

CMD:buyfuel(playerid, params[])
{
	ShowPlayerBuyJerricanDialog(playerid, GetNearestFuelStation(playerid, 10.0));

	return 1;
}

