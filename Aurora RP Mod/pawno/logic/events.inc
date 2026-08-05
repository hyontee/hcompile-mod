#if defined _events_inc
	#endinput
#endif
#define _events_inc

#define MAX_EVENT_COUNT	(10) // Количестве евентов

new EventPayDay = 0;

CMD:eventinfo(playerid) {
	ShowPlayerDialog(playerid, D_EVENT_INFO, DIALOG_STYLE_LIST, ""P"Информация о мероприятиях", "\
		"P"1."W" Преданный игрок\n\
		"P"2."W" Гроза района\n\
		"P"3."W" Крёстный отец\n\
		"P"4."W" Настоящий дальнобойщик\n\
		"P"5."W" Садовник\n\
		"P"6."W" Лучший в сборе оружия\n\
		"P"7."W" Заядлый нефтяник\n\
		"P"8."W" Отъявленный рыбак\n\
		"P"9."W" Лесопилка\n\
		"P"10."W" Удача в придачу\n\
		"P"11."W" Призы и призовые места", "Принять", "Отмена"
	);
	return true;
}
CMD:event(playerid) {
	ShowPlayerDialog(playerid, D_EVENT_MENU, DIALOG_STYLE_TABLIST, ""P"Event Menu", "\
		"P"1."W" Преданный игрок\n\
		"P"2."W" Гроза района\n\
		"P"3."W" Крёстный отец\n\
		"P"4."W" Настоящий дальнобойщик\n\
		"P"5."W" Садовник\n\
		"P"6."W" Лучший в сборе оружия\n\
		"P"7."W" Лесопилка\n\
		"P"8."W" Заядлый нефтяник\n\
		"P"9."W" Отъявленный рыбак", "Принять", "Отмена"
	);
	return 0x1;
}
CMD:eventpiar(playerid, params[]) {
	if(PI[playerid][pAdmin] < 3 || dostup[playerid] == 0) return true;
	if(GetSVarInt("event_timer") > gettime())
	{
		new year, month, day, hour, minute, second;
		timestamp_to_date(GetSVarInt("event_timer") - unix, year, month, day, hour, minute, second);
		new string[128];
		format(string, sizeof(string), "Пользоваться данной командой можно через: "W"%02d:%02d", minute, second);
		ErrorMessage(playerid, string);
		return 1;
	}
	SendClientMessageToAll(COLOR_YELLOW, "Интересует информация о мероприятиях? Прочитай о них всю информацию - /eventinfo");
	SetSVarInt("event_timer", gettime() + 60 * 5);
	return 1;
}

ConvertEvent(number)
{
	new hours = 0, mins = 0, secs = 0, str[100];
	hours = floatround(number / 3600);
	mins = floatround((number / 60) - (hours * 60));
	secs = floatround(number - ((hours * 3600) + (mins * 60)));
	if(hours > 0) format(str, 100, "%02d:%02d:%02d", hours, mins, secs);
	else format(str, 100, "00:%02d:%02d", mins, secs);
	return str;
}
stock event_timer()
{
	new query[256];
	foreach(new playerid : Player)
	{
		if(TI[playerid][tLogin] == true && gOnlinePlayer[playerid][0] > 1)
		{
			format(query, 256, "SELECT * FROM online_player WHERE date >= CURDATE() AND accountid = %d", PI[playerid][pID]);
			new Cache: result = mysql_query(connects, query);
			new rows = cache_num_rows();
			if(!rows)
			{
				format(query, sizeof(query), "INSERT INTO online_player (accountid,date,online_sec,afk_sec,user_name) VALUES (%d, CURDATE(), %d, %d, '%s')", PI[playerid][pID], gOnlinePlayer[playerid][0], gOnlinePlayerAFK[playerid][0], player_name[playerid]);
				mysql_tquery(connects, query);
			}
			else
			{
				format(query, sizeof(query), "UPDATE online_player SET online_sec = %d, afk_sec = %d, user_name = '%s' WHERE accountid = %d AND date >= CURDATE()", gOnlinePlayer[playerid][0], gOnlinePlayerAFK[playerid][0], player_name[playerid], PI[playerid][pID]);
				mysql_tquery(connects, query);
			}
			if (cache_is_valid(result)) cache_delete(result);
		}
	}
	return 0x1;
}
stock OnPlayerClearMemoryEvent(PlayerID)
{
	MYSQL_GLOBAL[0] = EOS;
	mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventTrucker` = '0', `EventApple` = '0', `EventGun` = '0', `EventLes` = '0', `EventNeft` = '0', `EventFish` = '0', `EventCapt` = '0', `EventBizWar` = '0' WHERE `pID` = '%d'", PlayerID);
	mysql_tquery(connects, MYSQL_GLOBAL, "", "");
	return 0x1;
}
events_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	#pragma unused inputtext
	switch (dialogid) {
		case D_EVENT_FULL_INFO: {
			pc_cmd_eventinfo(playerid);
			return true;
		}
		case D_EVENT_INFO: {
			if(!response) {
				return true;
			}
			switch(listitem) {
				case 0: ShowPlayerDialog(playerid, D_EVENT_FULL_INFO, DIALOG_STYLE_MSGBOX, ""P"Преданный игрок", "Это мероприятие с тремя призовыми местами среди всех игроков.\nКоторые отыграли больше всех часов за день.", "Назад", "");
				case 1: ShowPlayerDialog(playerid, D_EVENT_FULL_INFO, DIALOG_STYLE_MSGBOX, ""P"Гроза района", "Это мероприятие с тремя призовыми местами среди всех игроков\nКоторые сделали больше всех убийств на капте за день", "Назад", "");
				case 2: ShowPlayerDialog(playerid, D_EVENT_FULL_INFO, DIALOG_STYLE_MSGBOX, ""P"Крёстный отец", "Это мероприятие с тремя призовыми местами среди всех игроков\nКоторые сделали больше всех убийств на стрелах за день.", "Назад", "");
				case 3: ShowPlayerDialog(playerid, D_EVENT_FULL_INFO, DIALOG_STYLE_MSGBOX, ""P"Настоящий дальнобойщик", "Это мероприятие с тремя призовыми местами среди всех игроков\nКоторые перевезли больше всех груза за день.", "Назад", "");
				case 4: ShowPlayerDialog(playerid, D_EVENT_FULL_INFO, DIALOG_STYLE_MSGBOX, ""P"Садовник", "Это мероприятие с тремя призовыми местами среди всех игроков\nКоторые сорвали с деревьев больше всех яблок за день.", "Назад", "");
				case 5: ShowPlayerDialog(playerid, D_EVENT_FULL_INFO, DIALOG_STYLE_MSGBOX, ""P"Лучший в сборе оружия", "Это мероприятие с тремя призовыми местами среди всех игроков\nКоторые перенесли больше всех ящиков на оружейном заводе за день.", "Назад", "");
				case 6: ShowPlayerDialog(playerid, D_EVENT_FULL_INFO, DIALOG_STYLE_MSGBOX, ""P"Заядлый нефтяник", "Это мероприятие с тремя призовыми местами среди всех игроков\nКоторые перенесли больше всех бочек на нефтезаводе за день.", "Назад", "");
				case 7: ShowPlayerDialog(playerid, D_EVENT_FULL_INFO, DIALOG_STYLE_MSGBOX, ""P"Отъявленный рыбак", "Это мероприятие с тремя призовыми местами среди всех игроков\nКоторые выловили больше всего рыбы.", "Назад", "");
				case 8: ShowPlayerDialog(playerid, D_EVENT_FULL_INFO, DIALOG_STYLE_MSGBOX, ""P"Лесопилка", "Это мероприятие с тремя призовыми местами среди всех игроков\nКоторые перенесли больше всех древесины на лесопилке за день.", "Назад", "");
				case 9: ShowPlayerDialog(playerid, D_EVENT_FULL_INFO, DIALOG_STYLE_MSGBOX, ""P"Удача в придачу", "Это мероприятие с одним призовым местом.\nПри котором случайным образом каждый PayDay выдаёт любому игроку Donat Coin.", "Назад", "");
				case 10: ShowPlayerDialog(playerid, D_EVENT_FULL_INFO, DIALOG_STYLE_MSGBOX, ""P"Призовые места и призы", "Каждое мероприятие работает с 5:05 до 4:55 по московскому времени\nВ каждом пероприятие имеется 3 призовых места\n\n"P"Призы:\n"W"1 место - 60 Coins\n2 место - 55 Coins\n3 место - 50 Coins", "Назад", "");
			}
			return true;
		}
		case D_EVENT_MENU: {
			if(!response) {
				return true;
			}
			switch(listitem) {
				case 0: mysql_tquery(connects, "SELECT `accountid`, `online_sec`, `afk_sec`, `user_name` FROM `online_player` WHERE date >= CURDATE() ORDER BY `online_sec`-`afk_sec` DESC LIMIT 10", "OnMemoryLoadEventTime", "dd", playerid, 1);
				case 1: mysql_tquery(connects, "SELECT `pID`, `Name`, `EventCapt` FROM `accounts` WHERE `pMember` >= 18 AND `pMember` <= 22 ORDER BY `EventCapt` DESC LIMIT 10", "OnMemoryLoadEventCapt", "dd", playerid, 1);
				case 2: mysql_tquery(connects, "SELECT `pID`, `Name`, `EventBizWar` FROM `accounts` WHERE `pMember` >= 15 AND `pMember` <= 17 ORDER BY `EventBizWar` DESC LIMIT 10", "OnMemoryLoadEventBizWar", "dd", playerid, 1);
				case 3: mysql_tquery(connects, "SELECT `pID`, `Name`, `EventTrucker` FROM `accounts` WHERE `EventTrucker` != '0' ORDER BY `EventTrucker` DESC LIMIT 10", "OnMemoryLoadEventTrucker", "dd", playerid, 1);
				case 4: mysql_tquery(connects, "SELECT `pID`, `Name`, `EventApple` FROM `accounts` WHERE `EventApple` != '0' ORDER BY `EventApple` DESC LIMIT 10", "OnMemoryLoadEventApple", "dd", playerid, 1);
				case 5: mysql_tquery(connects, "SELECT `pID`, `Name`, `EventGun` FROM `accounts` WHERE `EventGun` != '0' ORDER BY `EventGun` DESC LIMIT 10", "OnMemoryLoadEventGun", "dd", playerid, 1);
				case 6: mysql_tquery(connects, "SELECT `pID`, `Name`, `EventLes` FROM `accounts` WHERE `EventLes` != '0' ORDER BY `EventLes` DESC LIMIT 10", "OnMemoryLoadEventLes", "dd", playerid, 1);
				case 7: mysql_tquery(connects, "SELECT `pID`, `Name`, `EventNeft` FROM `accounts` WHERE `EventNeft` != '0' ORDER BY `EventNeft` DESC LIMIT 10", "OnMemoryLoadEventNeft", "dd", playerid, 1);
				case 8: mysql_tquery(connects, "SELECT `pID`, `Name`, `EventFish` FROM `accounts` WHERE `EventFish` != '0' ORDER BY `EventFish` DESC LIMIT 10", "OnMemoryLoadEventFish", "dd", playerid, 1);
			}
			return true;
		}
	}
	return false;
}
CB:OnMemoryLoadEventDonate(playerid, type)
{
	new string;
	cache_get_row_count(string);
	if(!string) return print("[EVENT DONATE]: Произошла ошибка при выдаче призов");

	new PlayerDonate;
	new PlayerName[MAX_PLAYER_NAME];

	STRING_GLOBAL[0] = EOS;
	STRING_GLOBAL = "Номер\tНик\tРублей\n";

	for(new i = 0; i != string; i ++)
	{
		cache_get_value_name(i,         "account", PlayerName, MAX_PLAYER_NAME);
		cache_get_value_name_int(i,     "sum", PlayerDonate);

		if(type == 0)
		{
			switch(i)
			{
			case 0: {
				new PlayerOnline = GetPlayerID(PlayerName);
				new TotalMoney = ((PlayerDonate * 3200) / 2);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					STRING_GLOBAL[0] = EOS;
					format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "Вы выйграли Event Donate и получаете %d вирт на свой счет", TotalMoney);
					SendOk(PlayerOnline, STRING_GLOBAL);
					GiveMoney(PlayerOnline, TotalMoney, "Победа Event Donate");
				}

				STRING_GLOBAL[0] = EOS;
				format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "В мероприятии топ донат побеждает игрок %s и получает %d вирт на свой аккаунт", PlayerName, TotalMoney);
				SendClientMessageToAll(0xFFFF00FF, STRING_GLOBAL);

				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `pCash` = `pCash`+'%d' WHERE `Name` = '%d'", TotalMoney, PlayerName);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			}
		}
	}
	return 0x1;
}
CB:OnMemoryLoadEventFish(playerid, type)
{
	new string;
	cache_get_row_count(string);
	if(playerid != -1 && string == 0)
	{
		ErrorMessage(playerid, "Данная таблица покуда пуста");
		pc_cmd_event(playerid);
		return 0x1;
	}
	if(!string) return print("[EVENT FISH]: Произошла ошибка при выдаче призов");

	new PlayerID;
	new Float: PlayerKill;
	new PlayerName[MAX_PLAYER_NAME];

	STRING_GLOBAL[0] = EOS;
	STRING_GLOBAL = "Номер\tНик\tКилограмм\n";

	for(new i = 0; i != string; i ++)
	{
		cache_get_value_name_int(i,     "pID", PlayerID);
		cache_get_value_name(i,         "Name", PlayerName, MAX_PLAYER_NAME);
		cache_get_value_name_float(i,   "EventFish", PlayerKill);

		if(type == 0)
		{
			switch(i)
			{
			case 0: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 1 место в мероприятие отъявленный рыбак и получили 60 донат рублей");
					PI[PlayerOnline][pRouble] += 60;
					PI[PlayerOnline][EventFish] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventFish` = '0', `donatemoney` = `donatemoney`+'60' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 1: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 1 место в мероприятие отъявленный рыбак и получили 55 донат рублей");
					PI[PlayerOnline][pRouble] += 55;
					PI[PlayerOnline][EventFish] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventFish` = '0', `donatemoney` = `donatemoney`+'55' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 2: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 1 место в мероприятие отъявленный рыбак и получили 50 донат рублей");
					PI[PlayerOnline][pRouble] += 50;
					PI[PlayerOnline][EventFish] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventFish` = '0', `donatemoney` = `donatemoney`+'50' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			}
			OnPlayerClearMemoryEvent(PlayerID);
		}
		else
		{
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"%d\t"W"%s\t"P"%.02f\n", STRING_GLOBAL, i + 1, PlayerName, PlayerKill);
		}
	}
	if(type == 1) ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, ""P"Мероприятие отъявленный рыбак", STRING_GLOBAL, "Закрыть", "");
	return 0x1;
}
CB:OnMemoryLoadEventNeft(playerid, type)
{
	new string;
	cache_get_row_count(string);
	if(playerid != -1 && string == 0)
	{
		ErrorMessage(playerid, "Данная таблица покуда пуста");
		pc_cmd_event(playerid);
		return 0x1;
	}
	if(!string) return print("[EVENT NEFT]: Произошла ошибка при выдаче призов");

	new PlayerID;
	new PlayerKill;
	new PlayerName[MAX_PLAYER_NAME];

	STRING_GLOBAL[0] = EOS;
	STRING_GLOBAL = "Номер\tНик\tБочек\n";

	for(new i = 0; i != string; i ++)
	{
		cache_get_value_name_int(i,     "pID", PlayerID);
		cache_get_value_name(i,         "Name", PlayerName, MAX_PLAYER_NAME);
		cache_get_value_name_int (i,    "EventNeft", PlayerKill);

		if(type == 0)
		{
			switch(i)
			{
			case 0: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 1 место в мероприятие заядлый нефтяник и получили 60 донат рублей");
					PI[PlayerOnline][pRouble] += 60;
					PI[PlayerOnline][EventNeft] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventNeft` = '0', `donatemoney` = `donatemoney`+'60' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 1: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 2 место в мероприятие заядлый нефтяник и получили 55 донат рублей");
					PI[PlayerOnline][pRouble] += 55;
					PI[PlayerOnline][EventNeft] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventNeft` = '0', `donatemoney` = `donatemoney`+'55' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 2: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 3 место в мероприятие заядлый нефтяник и получили 50 донат рублей");
					PI[PlayerOnline][pRouble] += 50;
					PI[PlayerOnline][EventNeft] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventNeft` = '0', `donatemoney` = `donatemoney`+'50' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			}
			OnPlayerClearMemoryEvent(PlayerID);
		}
		else
		{
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"%d\t"W"%s\t"P"%d\n", STRING_GLOBAL, i + 1, PlayerName, PlayerKill);
		}
	}
	if(type == 1) ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, ""P"Мероприятие заядлый нефтяник", STRING_GLOBAL, "Закрыть", "");
	return 0x1;
}
CB:OnMemoryLoadEventLes(playerid, type)
{
	new string;
	cache_get_row_count(string);
	if(playerid != -1 && string == 0)
	{
		ErrorMessage(playerid, "Данная таблица покуда пуста");
		pc_cmd_event(playerid);
		return 0x1;
	}
	if(!string) return print("[EVENT LES]: Произошла ошибка при выдаче призов");

	new PlayerID;
	new PlayerKill;
	new PlayerName[MAX_PLAYER_NAME];

	STRING_GLOBAL[0] = EOS;
	STRING_GLOBAL = "Номер\tНик\tДерева\n";

	for(new i = 0; i != string; i ++)
	{
		cache_get_value_name_int(i,     "pID", PlayerID);
		cache_get_value_name(i,         "Name", PlayerName, MAX_PLAYER_NAME);
		cache_get_value_name_int (i,    "EventLes", PlayerKill);

		if(type == 0)
		{
			switch(i)
			{
			case 0: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 1 место в мероприятие лесопилка  и получили 60 донат рублей");
					PI[PlayerOnline][pRouble] += 60;
					PI[PlayerOnline][EventLes] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventLes` = '0', `donatemoney` = `donatemoney`+'60' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 1: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 2 место в мероприятие лесопилка и получили 55 донат рублей");
					PI[PlayerOnline][pRouble] += 55;
					PI[PlayerOnline][EventLes] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventLes` = '0', `donatemoney` = `donatemoney`+'55' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 2: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 3 место в мероприятие лесопилка и получили 50 донат рублей");
					PI[PlayerOnline][pRouble] += 50;
					PI[PlayerOnline][EventLes] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventLes` = '0', `donatemoney` = `donatemoney`+'50' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			}
			OnPlayerClearMemoryEvent(PlayerID);
		}
		else
		{
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"%d\t"W"%s\t"P"%d\n", STRING_GLOBAL, i + 1, PlayerName, PlayerKill);
		}
	}
	if(type == 1) ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, ""P"Мероприятие лесопилка", STRING_GLOBAL, "Закрыть", "");
	return 0x1;
}
CB:OnMemoryLoadEventGun(playerid, type)
{
	new string;
	cache_get_row_count(string);
	if(playerid != -1 && string == 0)
	{
		ErrorMessage(playerid, "Данная таблица покуда пуста");
		pc_cmd_event(playerid);
		return 0x1;
	}
	if(!string) return print("[EVENT GUN]: Произошла ошибка при выдаче призов");

	new PlayerID;
	new PlayerKill;
	new PlayerName[MAX_PLAYER_NAME];

	STRING_GLOBAL[0] = EOS;
	STRING_GLOBAL = "Номер\tНик\tЕдиниц оружия\n";

	for(new i = 0; i != string; i ++)
	{
		cache_get_value_name_int(i,     "pID", PlayerID);
		cache_get_value_name(i,         "Name", PlayerName, MAX_PLAYER_NAME);
		cache_get_value_name_int (i,    "EventGun", PlayerKill);

		if(type == 0)
		{
			switch(i)
			{
			case 0: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 1 место в мероприятие лучший в сборе оружия и получили 60 донат рублей");
					PI[PlayerOnline][pRouble] += 60;
					PI[PlayerOnline][EventGun] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventGun` = '0', `donatemoney` = `donatemoney`+'60' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 1: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 2 место в мероприятие лучший в сборе оружия и получили 55 донат рублей");
					PI[PlayerOnline][pRouble] += 55;
					PI[PlayerOnline][EventGun] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventGun` = '0', `donatemoney` = `donatemoney`+'55' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 2: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 3 место в мероприятие лучший в сборе оружия и получили 50 донат рублей");
					PI[PlayerOnline][pRouble] += 50;
					PI[PlayerOnline][EventGun] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventGun` = '0', `donatemoney` = `donatemoney`+'50' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			}
			OnPlayerClearMemoryEvent(PlayerID);
		}
		else
		{
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"%d\t"W"%s\t"P"%d\n", STRING_GLOBAL, i + 1, PlayerName, PlayerKill);
		}
	}
	if(type == 1) ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, ""P"Мероприятие лучший в сборе оружия", STRING_GLOBAL, "Закрыть", "");
	return 0x1;
}
CB:OnMemoryLoadEventApple(playerid, type)
{
	new string;
	cache_get_row_count(string);
	if(playerid != -1 && string == 0)
	{
		ErrorMessage(playerid, "Данная таблица покуда пуста");
		pc_cmd_event(playerid);
		return 0x1;
	}
	if(!string) return print("[EVENT APPLE]: Произошла ошибка при выдаче призов");

	new PlayerID;
	new PlayerKill;
	new PlayerName[MAX_PLAYER_NAME];

	STRING_GLOBAL[0] = EOS;
	STRING_GLOBAL = "Номер\tНик\tКилограмм\n";

	for(new i = 0; i != string; i ++)
	{
		cache_get_value_name_int(i,     "pID", PlayerID);
		cache_get_value_name(i,         "Name", PlayerName, MAX_PLAYER_NAME);
		cache_get_value_name_int (i,    "EventApple", PlayerKill);

		if(type == 0)
		{
			switch(i)
			{
			case 0: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 1 место в мероприятие садовник и получили 60 донат рублей");
					PI[PlayerOnline][pRouble] += 60;
					PI[PlayerOnline][EventApple] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventApple` = '0', `donatemoney` = `donatemoney`+'60' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 1: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 2 место в мероприятие садовник и получили 55 донат рублей");
					PI[PlayerOnline][pRouble] += 55;
					PI[PlayerOnline][EventApple] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventApple` = '0', `donatemoney` = `donatemoney`+'55' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 2: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 3 место в мероприятие садовник и получили 50 донат рублей");
					PI[PlayerOnline][pRouble] += 50;
					PI[PlayerOnline][EventApple] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventApple` = '0', `donatemoney` = `donatemoney`+'50' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			}
			OnPlayerClearMemoryEvent(PlayerID);
		}
		else
		{
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"%d\t"W"%s\t"P"%d\n", STRING_GLOBAL, i + 1, PlayerName, PlayerKill);
		}
	}
	if(type == 1) ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, ""P"Мероприятие садовник", STRING_GLOBAL, "Закрыть", "");
	return 0x1;
}
CB:OnMemoryLoadEventTrucker(playerid, type)
{
	new string;
	cache_get_row_count(string);
	if(playerid != -1 && string == 0)
	{
		ErrorMessage(playerid, "Данная таблица покуда пуста");
		pc_cmd_event(playerid);
		return 0x1;
	}
	if(!string) return print("[EVENT TRUCKER]: Произошла ошибка при выдаче призов");

	new PlayerID;
	new PlayerKill;
	new PlayerName[MAX_PLAYER_NAME];

	STRING_GLOBAL[0] = EOS;
	STRING_GLOBAL = "Номер\tНик\tТонн\n";

	for(new i = 0; i != string; i ++)
	{
		cache_get_value_name_int(i,     "pID", PlayerID);
		cache_get_value_name(i,         "Name", PlayerName, MAX_PLAYER_NAME);
		cache_get_value_name_int (i,    "EventTrucker", PlayerKill);

		if(type == 0)
		{
			switch(i)
			{
			case 0: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 1 место в мероприятии настоящий дальнобойщик и получили 60 донат рублей");
					PI[PlayerOnline][pRouble] += 60;
					PI[PlayerOnline][EventTrucker] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventTrucker` = '0', `donatemoney` = `donatemoney`+'60' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 1: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 2 место в мероприятии настоящий дальнобойщик и получили 55 донат рублей");
					PI[PlayerOnline][pRouble] += 55;
					PI[PlayerOnline][EventTrucker] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventTrucker` = '0', `donatemoney` = `donatemoney`+'55' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 2: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 3 место в мероприятии настоящий дальнобойщик и получили 50 донат рублей");
					PI[PlayerOnline][pRouble] += 50;
					PI[PlayerOnline][EventTrucker] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventTrucker` = '0', `donatemoney` = `donatemoney`+'50' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			}
			OnPlayerClearMemoryEvent(PlayerID);
		}
		else
		{
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"%d\t"W"%s\t"P"%d\n", STRING_GLOBAL, i + 1, PlayerName, PlayerKill);
		}
	}
	if(type == 1) ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, ""P"Мероприятие настоящий дальнобойщик", STRING_GLOBAL, "Закрыть", "");
	return 0x1;
}
CB:OnMemoryLoadEventBizWar(playerid, type)
{
	new string;
	cache_get_row_count(string);
	if(!string) return print("[EVENT BIZWAR]: Произошла ошибка при выдаче призов");

	new PlayerID;
	new PlayerKill;
	new PlayerName[MAX_PLAYER_NAME];

	STRING_GLOBAL[0] = EOS;
	STRING_GLOBAL = "Номер\tНик\tУбийств\n";

	for(new i = 0; i != string; i ++)
	{
		cache_get_value_name_int(i,     "pID", PlayerID);
		cache_get_value_name(i,         "Name", PlayerName, MAX_PLAYER_NAME);
		cache_get_value_name_int (i,    "EventBizWar", PlayerKill);

		if(type == 0)
		{
			switch(i)
			{
			case 0: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 1 место в мероприятие крестый отец и получили 60 донат рублей");
					PI[PlayerOnline][pRouble] += 60;
					PI[PlayerOnline][EventBizWar] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventBizWar` = '0', `donatemoney` = `donatemoney`+'60' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 1: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 2 место в мероприятие крестый отец и получили 55 донат рублей");
					PI[PlayerOnline][pRouble] += 55;
					PI[PlayerOnline][EventBizWar] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventBizWar` = '0', `donatemoney` = `donatemoney`+'55' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 2: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 3 место в мероприятие крестый отец и получили 50 донат рублей");
					PI[PlayerOnline][pRouble] += 50;
					PI[PlayerOnline][EventBizWar] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventBizWar` = '0', `donatemoney` = `donatemoney`+'50' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			}
			OnPlayerClearMemoryEvent(PlayerID);
		}
		else
		{
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"%d\t"W"%s\t"P"%d\n", STRING_GLOBAL, i + 1, PlayerName, PlayerKill);
		}
	}
	if(type == 1) ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, ""P"Мероприятие крёстный отец", STRING_GLOBAL, "Закрыть", "");
	return 0x1;
}
CB:OnMemoryLoadEventCapt(playerid, type)
{
	new string;
	cache_get_row_count(string);
	if(!string) return print("[EVENT CAPT]: Произошла ошибка при выдаче призов");

	new PlayerID;
	new PlayerKill;
	new PlayerName[MAX_PLAYER_NAME];

	STRING_GLOBAL[0] = EOS;
	STRING_GLOBAL = "Номер\tНик\tУбийств\n";

	for(new i = 0; i != string; i ++)
	{
		cache_get_value_name_int(i,     "pID", PlayerID);
		cache_get_value_name(i,         "Name", PlayerName, MAX_PLAYER_NAME);
		cache_get_value_name_int (i,    "EventCapt", PlayerKill);

		if(type == 0)
		{
			switch(i)
			{
			case 0: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 1 место в мероприятии гроза района и получили 60 донат рублей");
					PI[PlayerOnline][pRouble] += 60;
					PI[PlayerOnline][EventCapt] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventCapt` = '0', `donatemoney` = `donatemoney`+'60' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 1: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 2 место в мероприятии гроза района и получили 55 донат рублей");
					PI[PlayerOnline][pRouble] += 55;
					PI[PlayerOnline][EventCapt] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventCapt` = '0', `donatemoney` = `donatemoney`+'55' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 2: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 3 место в мероприятии гроза района и получили 50 донат рублей");
					PI[PlayerOnline][pRouble] += 50;
					PI[PlayerOnline][EventCapt] = 0;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `EventCapt` = '0', `donatemoney` = `donatemoney`+'50' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			}
			OnPlayerClearMemoryEvent(PlayerID);
		}
		else
		{
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"%d\t"W"%s\t"P"%d\n", STRING_GLOBAL, i + 1, PlayerName, PlayerKill);
		}
	}
	if(type == 1) ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, ""P"Мероприятие гроза района", STRING_GLOBAL, "Закрыть", "");
	return 0x1;
}
CB:OnMemoryLoadEventTime(playerid, type)
{
	new string;
	cache_get_row_count(string);
	if(!string) return print("[EVENT TIME]: Произошла ошибка при выдаче призов");

	new PlayerID;
	new PlayerTime;
	new PlayerAfkSecond;
	new PlayerName[MAX_PLAYER_NAME];

	STRING_GLOBAL[0] = EOS;
	STRING_GLOBAL = "Номер\tНик\tВремя\n";

	for(new i = 0; i != string; i ++)
	{
		cache_get_value_name_int(i, "accountid", PlayerID);
		cache_get_value_name_int(i, "online_sec", PlayerTime);
		cache_get_value_name_int (i, "afk_sec", PlayerAfkSecond);
		cache_get_value_name(i,     "user_name", PlayerName, MAX_PLAYER_NAME);

		if(type == 0)
		{
			switch(i)
			{
			case 0: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 1 место в мероприятии преданный игрок и получили 60 донат рублей");
					PI[PlayerOnline][pRouble] += 60;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `donatemoney` = `donatemoney`+'60' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 1: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 2 место в мероприятии преданный игрок и получили 55 донат рублей");
					PI[PlayerOnline][pRouble] += 55;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `donatemoney` = `donatemoney`+'55' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			case 2: {
				new PlayerOnline = GetPlayerID(PlayerName);
				if(IsPlayerConnected(PlayerOnline) && TI[PlayerOnline][tLogin] == true)
				{
					SendOk(PlayerOnline, "Поздравляем вы заняли 3 место в мероприятии преданный игрок и получили 50 донат рублей");
					PI[PlayerOnline][pRouble] += 50;
				}
				MYSQL_GLOBAL[0] = EOS;
				mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET `donatemoney` = `donatemoney`+'50' WHERE `pID` = '%d'", PlayerID);
				mysql_tquery(connects, MYSQL_GLOBAL);
			}
			}
			OnPlayerClearMemoryEvent(PlayerID);
		}
		else
		{
			format(STRING_GLOBAL, sizeof(STRING_GLOBAL), "%s"P"%d\t"W"%s\t"P"%s\n", STRING_GLOBAL, i + 1, PlayerName, ConvertEvent((PlayerTime - PlayerAfkSecond)));
		}
	}
	if(type == 1) ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, ""P"Мероприятие преданный игрок", STRING_GLOBAL, "Закрыть", "");
	return 0x1;
}