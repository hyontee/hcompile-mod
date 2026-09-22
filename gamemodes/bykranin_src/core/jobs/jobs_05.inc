//>> Файл: bykranin_src/core/jobs/jobs_05.inc  (371 строк)
//>> Тема: работы и заработок
//>> Внутри: CreateQuestPickup, GromovLohAndPidr, ShowPlayerQuest23, ShowPlayerQuestMenuFrac, ShowPlayerQuestMenu, /quest, /vleave
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock CreateQuestPickup()
{
	for(new idx; idx < sizeof quest_pos; idx ++)
	{
		CreatePickup(1276, 23, quest_pos[idx][0], quest_pos[idx][1], quest_pos[idx][2], -1, PICKUP_ACTION_QUEST_MENU, idx);
		CreateDynamic3DTextLabel(""c_i"Квесты", COR_SERVER, quest_pos[idx][0], quest_pos[idx][1], quest_pos[idx][2] + 0.7, 9.5);
	}
}
stock GromovLohAndPidr(playerid)
{
	Dialog(playerid,0,DIALOG_STYLE_MSGBOX,"","Пусть удача не подводит,\nЗа тобою следом ходит,\nНе теряй в глазах огня!\nС 23 Февраля!","Принять","");
	return 1;
}
stock ShowPlayerQuest23(playerid)
{
	Dialog(playerid,0,DIALOG_STYLE_MSGBOX,"","Здравия желаю боец,\nУ меня для тебя есть пару вопросов для проверки твоих знаний.\n\nЕсли ответишь на них правильно то получишь приз\nНаграда: 15 DRUB","Принять","Отмена");
	return 1;
}

stock ShowPlayerQuestMenuFrac(playerid)
{
	new fmt_text[700];

	format
	(
		fmt_text,
		sizeof fmt_text,
		""c_server"[1] "c_b"Невиновные люди должный быть на свободе| %s\n"\
		""c_server"[2] "c_b"Мы лучще всех | %s\n"\
		""c_server"[3] "c_b"Преступники должный быть в тюрьме | %s\n"\
		""c_server"[4] "c_b"Радиостанция на связи | %s\n"\
		""c_server"[5] "c_b"Люди должный жить | %s",
		GetPlayerData(playerid, P_F_QUEST_1) ? ("{32CD32}Выполнено") : ("{F81414}Не выполнено"),
		GetPlayerData(playerid, P_F_QUEST_2) ? ("{32CD32}Выполнено") : ("{F81414}Не выполнено"),
		GetPlayerData(playerid, P_F_QUEST_3) ? ("{32CD32}Выполнено") : ("{F81414}Не выполнено"),
		GetPlayerData(playerid, P_F_QUEST_4) ? ("{32CD32}Выполнено") : ("{F81414}Не выполнено"),
		GetPlayerData(playerid, P_F_QUEST_5) ? ("{32CD32}Выполнено") : ("{F81414}Не выполнено")
	);

	Dialog
	(
		playerid, DIALOG_ACTION_F_QUEST, DIALOG_STYLE_LIST,
		"Квесты",
		fmt_text,
		"Выбрать", "Закрыть"
	);

	return 1;
}
stock ShowPlayerQuestMenu(playerid)
{
    new fmt_text[1024];

    format(
        fmt_text, sizeof fmt_text,
        ""c_server"1. "c_b"Первые деньги\t\t\t\t%s\n"\
        ""c_server"2. "c_b"Получить водительские права\t\t\t\t%s\n"\
        ""c_server"3. "c_b"Приобрести телефон\t\t\t\t%s\n"\
        ""c_server"4. "c_b"Тяжелая профессия\t\t\t\t%s\n"\
        ""c_server"5. "c_b"Устроиться на официальную работу\t\t\t\t%s\n"\
        ""c_server"6. "c_b"Вступить во фракцию\t\t\t\t%s\n"\
        ""c_server"7. "c_b"Вступить в семью\t\t\t\t%s\n"\
        ""c_server"8. "c_b"Приобрести первый автомобиль\t\t\t\t%s\n",
        GetPlayerData(playerid, P_QUEST_1) ? "{FFFF00}Выполнено" : "{32CD32}Доступно",
        GetPlayerData(playerid, P_QUEST_2) ? "{FFFF00}Выполнено" : "{32CD32}Доступно",
        GetPlayerData(playerid, P_QUEST_3) ? "{FFFF00}Выполнено" : "{32CD32}Доступно",
        GetPlayerData(playerid, P_QUEST_4) ? "{FFFF00}Выполнено" : "{32CD32}Доступно",
        GetPlayerData(playerid, P_QUEST_5) ? "{FFFF00}Выполнено" : "{32CD32}Доступно",
        GetPlayerData(playerid, P_QUEST_6) ? "{FFFF00}Выполнено" : "{32CD32}Доступно",
        GetPlayerData(playerid, P_QUEST_7) ? "{FFFF00}Выполнено" : "{32CD32}Доступно",
        GetPlayerData(playerid, P_QUEST_8) ? "{FFFF00}Выполнено" : "{32CD32}Доступно"
    );

    Dialog(
        playerid, DIALOG_ACTION_QUEST, DIALOG_STYLE_LIST,
        "{FFFF00}" SERVER_NAME "{ffffff} | Квесты",
        fmt_text,
        "Выбрать", "Закрыть"
    );

    return 1;
}

CMD:quest(playerid)
{
	ShowPlayerQuestMenu(playerid);
}

CMD:vleave(playerid, params[])
{
	if(GetPlayerData(playerid, P_IMPROVEMENTS) < 2) return SendClientMessage(playerid, 0x999999FF, "Приобретите улучшение \"Решительность\", чтобы уволиться по собственному желанию");

	if(!GetPlayerTeamEx(playerid)) return ShowNotificationNew(playerid, 2, 3, 0, 0, "Вы не состоите в организации", "");

	new fmt_text[999];

	format
	(
		fmt_text, sizeof fmt_text,
		""SC"Ваша организация{ffff00}: \"%s\".\n\n"\
		"{ffffff}Вы действительно хотите покинуть данную организацию по\n"\
		"{ffffff}собственному желанию?",
		GetTeamName(GetPlayerTeamEx(playerid))
	);

	Dialog(playerid, DIALOG_TEAM_LEAVE, DIALOG_STYLE_MSGBOX, "{00FFFF}"SERVER_NAME" {ffffff}| Подтверждение", fmt_text, "Далее", "Отмена");

	return 1;
}

CMD:unj(playerid)
{
	if(!GetPlayerPremium(playerid) || GetPlayerData(playerid, P_UNJ)) return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет VIP, или вы уже воспользовались командой ранее");
    if(GetPlayerPremium(playerid) == 2)
	{
		SetPlayerData(playerid, P_JAIL ,GetPlayerData(playerid, P_JAIL) / 2);
	}
					else if(GetPlayerPremium(playerid) == 3)
	{
		SetPlayerData(playerid, P_JAIL ,GetPlayerData(playerid, P_JAIL) / 3);
	}
    SetPlayerData(playerid, P_UNJ, 1);
    UpdatePlayerDatabaseInt(playerid, "unj", GetPlayerData(playerid, P_UNJ));
    SendClientMessage(playerid, 0xCECECEFF, "Вы уменьшили срок тюрьмы!");
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

	SetPlayerData(to_player, P_PREMIUM, gettime() + premium * 86400);

	UpdatePlayerDatabaseInt(to_player, "premium", GetPlayerData(to_player, P_PREMIUM));

	format(fmt_msg, sizeof fmt_msg, "%s выдал Вам подписку "SERVER_NAME"+ на %d дн.", GetPlayerNameEx(playerid), premium);
	SendClientMessage(to_player, 0x1E90FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы выдали %s подписку "SERVER_NAME"+ на %d дн.", GetPlayerNameEx(to_player), premium);
	SendClientMessage(playerid, 0x1E90FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Установил %s[acc:%d] подписку "SERVER_NAME"+ на %d дн.", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), premium);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

CMD:togphone(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет телефона. Его можно купить в 24/7");
	if(!GetPlayerPremium(playerid))
	    return   SendClientMessage(playerid, 0xCECECEFF, "У Вас нет VIP аккаунта.");

	if(GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER) != INVALID_PLAYER_ID || GetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER) != INVALID_PLAYER_ID)
		return SendClientMessage(playerid, 0xCECECEFF, "Закончите текущий разговор");

	if(GetPlayerPhoneCall(playerid, PC_ENABLED))
	{
		SetPlayerPhoneCall(playerid, PC_ENABLED, false);
		SendClientMessage(playerid, 0xCECECEFF, "Телефон отключен");
	}
					else
	{
		SetPlayerPhoneCall(playerid, PC_ENABLED, true);
		SendClientMessage(playerid, 0x32a44bFF, "Телефон включен");
	}
	return 1;
}

stock bool:IsPlayerVipActive(playerid)
{
    if(!IsPlayerConnected(playerid)) return false;
    if(GetPlayerPremium(playerid) < 1) return false;

    new premium_date = GetPlayerData(playerid, P_PREMIUM_DATE);
    new premium_time = GetPlayerData(playerid, P_PREMIUM_TIME);

    if(premium_date <= 0 && premium_time <= 0) return true;
    if(premium_date > gettime()) return true;
    if(premium_time > gettime()) return true;

    return false;
}
CMD:v(playerid, params[])
{
    if(GetPlayerPremium(playerid) < 1)
        return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет VIP аккаунта ");
    else if(IsPlayerMuted(playerid) > 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
    else if(!strlen(params))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /v [текст]");

    new fmt_msg[144];
    new prefix[32];

    switch(GetPlayerPremium(playerid))
    {
        case 1: format(prefix, sizeof prefix, "[VIP Silver]");
        case 2: format(prefix, sizeof prefix, "[VIP Gold]");
        case 3: format(prefix, sizeof prefix, "[VIP Platinum]");
        default: format(prefix, sizeof prefix, "[VIP]");
    }

    format(fmt_msg, sizeof fmt_msg, "%s %s[%d]: %s", prefix, GetPlayerNameEx(playerid), playerid, params);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!IsPlayerLogged(i)) continue;
        if(!GetPlayerPremium(i)) continue;
        if(!GetPlayerData(i, P_PREMIUM_CHAT)) continue;

        SendClientMessage(i, COLOR_YELLOW, fmt_msg);
    }
    return 1;
}

CMD:voff(playerid, params[])
{
	if(!IsPlayerVipActive(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет VIP аккаунта ");
	if(GetPlayerData(playerid, P_PREMIUM_CHAT))
	{
		SendClientMessage(playerid,-1,"Вы отключили VIP чат");
		SetPlayerData(playerid, P_PREMIUM_CHAT, 0);
		return 1;
	}
	if(!GetPlayerData(playerid, P_PREMIUM_CHAT))
	{
		SendClientMessage(playerid,-1,"Вы включили VIP чат");
		SetPlayerData(playerid, P_PREMIUM_CHAT, 1);
		return 1;
	}
	return 1;
}

/*public AntiBH(playerid)
{
	ApplyAnimation(playerid,"PED","getup_front",4.0,0,0,0,0,0);
	times[playerid] = false;

	SetTimerEx("AntiBH1",1500,false,"i",playerid);

	return 1;
}
public AntiBH1(playerid)
{
	times[playerid] = true;
}
*/

CMD:rub(playerid)
{
	if(!GetPlayerAdminEx(playerid))
	{
		new status;
		status = (GetPlayerData(playerid, P_GET_RUB) ^ VEHICLE_PARAM_ON);

		SetPlayerData(playerid, P_GET_RUB, status);

		format(stringer, sizeof(stringer), "{FF9A30}Вы успешно %s функцию '+%d руб каждый час'", GetPlayerData(playerid, P_GET_RUB) ? ("{32CD32}включили{FFFFFF}") : ("{FF0000}выключили{FFFFFF}"), Config[sDistRub]);
        SendClientMessage(playerid, 0xB8FF1AFF, stringer);
        return 1;
	}
	return SendClientMessage(playerid, -1, "Данная функция недоступна администраторам!");
}

stock FD(playerid)
{
    mysql_format(mysql, str, 250, "SELECT * FROM `full_dostup` WHERE name = '%s'", GetPlayerNameEx(playerid));
    mysql_query(mysql, str, true);

    if(cache_num_rows(result))
    	return 1;
    else
    	return 0;
}

CMD:so(playerid, params[])
{
	if(GetPlayerHelperEx(playerid) >= 1)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /so [текст]");

		new fmt_str[128];

		format(fmt_str, sizeof fmt_str, "[S] Хелпер %s[%d]: %s", GetPlayerNameEx(playerid), playerid, params);
		SendMessageToHelpers(fmt_str, 0x99CC00FF);

	}

	return 1;
}

stock ShowPlayerReportMenuDialog(playerid)
{
    if(AntiTimerReport(playerid)) return true;
    new fmt_text[50];

    format
    (
        fmt_text,
        sizeof fmt_text,
        "{B5A8FF}Отправить жалобу\n"\
        "{B5A8FF}Отправить вопрос\n"
    );

    Dialog
    (
        playerid, DIALOG_ADMINCALL_MENU, DIALOG_STYLE_LIST,
        "{6666CC}Связь с администрацией",
        fmt_text,
        "Выбрать", "Закрыть"
    );

    return 1;
}

CMD:vipad(playerid, params[])
{
    if(GetPlayerPremium(playerid) < 1) return Send(playerid,-1,"У вас нет VIP Аккаунта");
    

    if(AntiTimerVipad(playerid)) return true;

    if(GetPlayerPhone(playerid) != 0)
	{
		if(GetPlayerMoneyEx(playerid) >= 50000)
		{
			if(!strlen(params))
				return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /vipad [текст]");

			extract params -> new string: message[144 + 1];

			if(IsAIP(message))
			{
	       		SendClientMessage(playerid, -1, "Подозрения в рекламе!");
	        	return false;
	    	}

			new fmt_str[128];

			GivePlayerMoneyEx(playerid, -50000, "vip объява", true, true);

			format(fmt_str, sizeof fmt_str, "VING RUSSIA | "c_b"%s[%d]: %s Тел: %d", GetPlayerNameEx(playerid), playerid, message, GetPlayerPhone(playerid));
			SendClientMessageToAll(0xFF9945FF, fmt_str);
			PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);



		}
					else
			return SendClientMessage(playerid, -1, "У Вас недостаточно денег, нужно 50.000$");
		
    }
					else SendClientMessage(playerid, 0x999999FF, "У Вас нет телефона. Его можно купить в 24/7");

	return 1;
}

