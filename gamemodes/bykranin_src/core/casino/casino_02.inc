//>> Файл: bykranin_src/core/casino/casino_02.inc  (328 строк)
//>> Тема: казино (рулетка, блэкджек и т.п.)
//>> Внутри: /dice, /ad, /edit, /t, /u, /givemic
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:dice(playerid, params[])
{
	if(!PlayerTotalOnline(playerid, 1))
	return SendClientMessage(playerid, 0x999999FF, ""USC"Для игры в казино необходимо отыграть 1 часа");

	if(GetPlayerInBiz(playerid) == -1)
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться в казино");

	if(GetBusinessData(GetPlayerInBiz(playerid), B_TYPE) != BUSINESS_TYPE_CASINO)
		return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться в казино");

	if(!IsPlayerInRangeOfAnyCasinoTable(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться возле игрального стола");

	/*if(!PlayerTotalOnline(playerid, 10))
		return SendClientMessage(playerid, 0x999999FF, "Для игры в кости необходимо отыграть 10 часов");*/

	extract params -> new to_player, money; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /dice [id игрока] [сумма]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 4.0))
		return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

	if(!(1 <= money <= 1_000_000))
		return SendClientMessage(playerid, 0x999999FF, "Сумма должна быть не более 1.000.000 рублей");

	if(GetPlayerMoneyEx(playerid) < money)
		return SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества денег");

	if(GetPlayerMoneyEx(to_player) < money)
		return SendClientMessage(playerid, 0x999999FF, "У игрока нет такого количества денег");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_CASINO_DICE, money);

	return 1;
}

CMD:ad(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0x999999FF, "У Вас нет телефона, по которому могут с Вами связаться");

	new fmt_text[144];

	if(IsAIP(params))
	{
   		SendClientMessage(playerid, -1, "Подозрения в рекламе!");
       	return false;
    }

	for(new idx = g_advert_created - 1; idx >= 0; idx --)
	{
		if(GetAdvertData(idx, A_CREATOR) != playerid) continue;

		format(fmt_text, sizeof fmt_text, "Ваше объявление уже находится в очереди под {00CC99}номером %d", GetAdvertIndexInQueue(idx));
		SendClientMessage(playerid, 0xCECECEFF, fmt_text);

		/*
		if(idx)
			SendClientMessage(playerid, 0xCECECEFF, "Вы можете ускорить его публикацию {FF9900}с помощью команды /up. {CECECE}Услуга стоит {33CCFF}2000 руб");
		*/

		return 1;
	}

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /ad [текст объявления]");

	if(GetPlayerMoneyEx(playerid) < ADVERT_SEND_PRICE)
		return SendClientMessage(playerid, 0x999999FF, "Для отправки объявления необходимо иметь 250 руб");

	SendAdvert(playerid, params);

	GivePlayerMoneyEx(playerid, -250, "Отправка объявления", true, true);
	BlackPass_OnAdvertSent(playerid);

	format(fmt_text, sizeof fmt_text, "Текст: %s", params);
	SendClientMessage(playerid, 0x00CC99FF, fmt_text);

	SendClientMessage(playerid, -1, "Ваше объявление было добавлено в очередь для публикации");
	SendClientMessage(playerid, -1, "Оставайтесь на связи, в противном случае объявление будет удалено из очереди");
	// SendClientMessage(playerid, -1, "Вы можете ускорить его публикацию {FF9900}с помощью команды /up. {FFFFFF}Услуга стоит {33CCFF}2000 руб");

	return 1;
}

CMD:edit(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_RADIO) return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");

	if(!g_advert_created) return SendClientMessage(playerid, 0xCECECEFF, "Нет объявлений для редактирования");

	new fmt_text[360],
		bool: ad_is_found;

	for(new idx = g_advert_created - 1; idx >= 0; idx --)
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

	if(!ad_is_found) return SendClientMessage(playerid, 0xCECECEFF, "Нет объявлений для редактирования");

	return 1;
}

CMD:t(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_RADIO) return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /t [текст]");

	new fmt_text[144];

	format(fmt_text, sizeof fmt_text, "[СМИ] %s: %s", GetPlayerNameEx(playerid), params);
	SendClientMessageToAll(0x6666FFFF, fmt_text);

	return 1;
}

CMD:u(playerid, params[])
{
	if(!GetPVarInt(playerid, "radio_mic")) return SendClientMessage(playerid, 0x999999FF, "Вы не подключены к радио-эфиру");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /u [текст]");

	new fmt_text[144];

	format(fmt_text, sizeof fmt_text, "[СМИ] Гость %s: %s", GetPlayerNameEx(playerid), params);
	SendClientMessageToAll(0x6666FFFF, fmt_text);

	return 1;
}

CMD:givemic(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_RADIO) return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givemic [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!GetPVarInt(to_player, "radio_mic"))
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_GIVE_MIC);

	else
	{
		new fmt_text[128];

		format(fmt_text, sizeof fmt_text, "%s %s[%d] отключил Вас от радио-эфира",
		GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);

		SendClientMessage(to_player, 0xFF5533FF, fmt_text);

		format(fmt_text, sizeof fmt_text, "Вы отключили %s[%d] от радио-эфира", GetPlayerNameEx(to_player), to_player);
		SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

		format(fmt_text, sizeof fmt_text, "[СМИ] %s %s[%d] отключил %s[%d] от радио-эфира",
		GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);

		SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_text, 0x99CC99FF, playerid);

		SetPVarInt(to_player, "radio_mic", 0);
	}

	return 1;
}

/*CMD:gangzonegovnozhopa(playerid, params[])
{
	new gang_zone[100][4] =
	{
		{-2667, 149, -2567, 249},
		{-2567, 149, -2467, 249},
		{-2467, 149, -2367, 249},
		{-2367, 149, -2267, 249},
		{-2267, 149, -2167, 249},
		{-2167, 149, -2067, 249},
		{-2167, 49, -2067, 149},
		{-2267, 49, -2167, 149},
		{-2367, 49, -2267, 149},
		{-2467, 49, -2367, 149},
		{-2567, 49, -2467, 149},
		{-2667, 49, -2567, 149},
		{-2667, -51, -2567, 49},
		{-2567, -51, -2467, 49},
		{-2467, -51, -2367, 49},
		{-2367, -51, -2267, 49},
		{-2267, -51, -2167, 49},
		{-2167, -51, -2067, 49},
		{-2167, -151, -2067, -51},
		{-2267, -151, -2167, -51},
		{-2367, -151, -2267, -51},
		{-2467, -151, -2367, -51},
		{-2567, -151, -2467, -51},
		{-2667, -151, -2567, -51},
		{-2667, -251, -2567, -151},
		{-2567, -251, -2467, -151},
		{-2467, -251, -2367, -151},
		{-2367, -251, -2267, -151},
		{-2267, -251, -2167, -151},
		{-2167, -251, -2067, -151},
		{1974, 2007, 2074, 2107},
		{1874, 2007, 1974, 2107},
		{1774, 2007, 1874, 2107},
		{1674, 2007, 1774, 2107},
		{1574, 2007, 1674, 2107},
		{1574, 2107, 1674, 2207},
		{1674, 2107, 1774, 2207},
		{1774, 2107, 1874, 2207},
		{1874, 2107, 1974, 2207},
		{1974, 2107, 2074, 2207},
		{1974, 2207, 2074, 2307},
		{1874, 2207, 1974, 2307},
		{1774, 2207, 1874, 2307},
		{1674, 2207, 1774, 2307},
		{1574, 2207, 1674, 2307},
		{1574, 2307, 1674, 2407},
		{1674, 2307, 1774, 2407},
		{1774, 2307, 1874, 2407},
		{1874, 2307, 1974, 2407},
		{1974, 2307, 2074, 2407},
		{1974, 2407, 2074, 2507},
		{1874, 2407, 1974, 2507},
		{1774, 2407, 1874, 2507},
		{1674, 2407, 1774, 2507},
		{1574, 2407, 1674, 2507},
		{1574, 2507, 1674, 2607},
		{1674, 2507, 1774, 2607},
		{1774, 2507, 1874, 2607},
		{1874, 2507, 1974, 2607},
		{1974, 2507, 2074, 2607},
		{1751, -311, 1851, -211},
		{1751, -411, 1851, -311},
		{1651, -411, 1751, -311},
		{1651, -311, 1751, -211},
		{1551, -311, 1651, -211},
		{1551, -411, 1651, -311},
		{1451, -411, 1551, -311},
		{1451, -311, 1551, -211},
		{981, -265, 1081, -165},
		{981, -365, 1081, -265},
		{981, -465, 1081, -365},
		{881, -465, 981, -365},
		{881, -365, 981, -265},
		{881, -265, 981, -165},
		{781, -265, 881, -165},
		{781, -365, 881, -265},
		{781, -465, 881, -365},
		{681, -465, 781, -365},
		{681, -365, 781, -265},
		{681, -265, 781, -165},
		{581, -265, 681, -165},
		{581, -365, 681, -265},
		{581, -465, 681, -365},
		{481, -465, 581, -365},
		{481, -365, 581, -265},
		{481, -265, 581, -165},
		{381, -265, 481, -165},
		{381, -365, 481, -265},
		{381, -465, 481, -365},
		{281, -365, 381, -265},
		{2401, -330, 2501, -230},
		{2501, -330, 2601, -230},
		{2501, -230, 2601, -130},
		{2501, -130, 2601, -30},
		{2401, -230, 2501, -130},
		{2401, -130, 2501, -30},
		{2301, -230, 2401, -130},
		{2601, -330, 2701, -230},
		{2601, -230, 2701, -130},
		{2201, -230, 2301, -130}
	};

	for(new i; i < sizeof gang_zone; i ++)
	{
		new query[110];

		mysql_format(mysql, query, sizeof query, "INSERT INTO gang_zones (min_x, min_y, max_x, max_y) VALUES (%d, %d, %d, %d)", gang_zone[i][0], gang_zone[i][1], gang_zone[i][2], gang_zone[i][3]);
		mysql_query(mysql, query, false);
	}

	LoadGangZones();

	ShowGangZonesForPlayer(playerid);

	return 1;
}*/

/*stock KickForSoft(playerid)
{
	new fmt_text[80];

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] пытается подключиться с запрещенным софтом", GetPlayerNameEx(playerid), playerid);
	SendMessageToAdmins(fmt_text, 0xFF5533FF);

	SendClientMessage(playerid, 0xFF5533FF, "Вы используете запрещенное программное обеспечение");
	SendClientMessage(playerid, 0xFF6600FF, "Доступ к серверу невозможен. Переустановите игру и подключитесь снова");
	SendClientMessage(playerid, 0xFFFFFFFF, "");

	printf("%s[%d] kicked. Reason: Forbidden software");

	Kick:(playerid, _, 1000);

	return 1;
}*/

