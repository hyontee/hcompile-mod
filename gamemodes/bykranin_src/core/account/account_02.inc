//>> Файл: bykranin_src/core/account/account_02.inc  (226 строк)
//>> Тема: аккаунт: вход, регистрация, пин-код, спавн
//>> Внутри: ShowPlayerPinCodePTD, HidePlayerPinCodePTD, ShowCurrentTime, GetDayOfWeek, UpdateCharity, Dialog, abs
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock ShowPlayerPinCodePTD(playerid, s_state)
{
	if(GetPlayerPinCodeState(playerid) != PIN_CODE_STATE_NONE) return ;
	pin_code_input[playerid][0] = 0;

	switch(s_state)
	{
		case PIN_CODE_STATE_SET:
			SendClientMessage(playerid, 0x3399FFFF, "Придумайте свой PIN-код и наберите его");

		case PIN_CODE_STATE_CHECK:
			SendClientMessage(playerid, 0xFFFF00FF, "Наберите Ваш текущий PIN-код");

		case PIN_CODE_STATE_CHANGE:
			SendClientMessage(playerid, 0xFFFF00FF, "Наберите новый PIN-код");

		case PIN_CODE_STATE_LOGIN_CHECK:
			SendClientMessage(playerid, 0xFFFFFFFF, "Система безопасности запрашивает ввод Вашего случайного PIN-кода");

		default:
			return ;

	}

	new values[10] = {0, 1, ...};
	new ch[2];
	Shuffle(values);

	new Float: add_pos_x, Float: add_pos_y;
	for(new idx = 0; idx < 10; idx ++)
	{
		add_pos_x = ((idx % 3) * 40.0);
		add_pos_y = ((idx / 3) * 40.0);

		if(idx == 9)
			add_pos_x += 40.0;

		valstr(ch, values[idx]);
		SetPlayerPinCodeValue(playerid, idx, values[idx]);

		pin_code_PTD[playerid][idx] = CreatePlayerTextDraw(playerid, 420.0 + add_pos_x, 170.0 + add_pos_y, ch);
		PlayerTextDrawTextSize(playerid, pin_code_PTD[playerid][idx], 445.0 + add_pos_x, 25.0);
		PlayerTextDrawLetterSize(playerid, pin_code_PTD[playerid][idx], 1.0, 3.0);
		PlayerTextDrawAlignment(playerid, pin_code_PTD[playerid][idx], 1);
		PlayerTextDrawBackgroundColor(playerid, pin_code_PTD[playerid][idx], 0x000000FF);
		PlayerTextDrawBoxColor(playerid, pin_code_PTD[playerid][idx], 0x80808080);
		PlayerTextDrawColor(playerid, pin_code_PTD[playerid][idx], 0xFFFFFFFF);
		PlayerTextDrawFont(playerid, pin_code_PTD[playerid][idx], 1);
		PlayerTextDrawSetOutline(playerid, pin_code_PTD[playerid][idx], 1);
		PlayerTextDrawSetProportional(playerid, pin_code_PTD[playerid][idx], 1);
		PlayerTextDrawSetShadow(playerid, pin_code_PTD[playerid][idx], 2);
		PlayerTextDrawUseBox(playerid, pin_code_PTD[playerid][idx], 1);
		PlayerTextDrawSetSelectable(playerid, pin_code_PTD[playerid][idx], 1);

		PlayerTextDrawShow(playerid, pin_code_PTD[playerid][idx]);
	}
	SelectTextDraw(playerid, 0x0066FFFF);

	SetPlayerPinCodeState(playerid, s_state);
}

stock HidePlayerPinCodePTD(playerid, bool: canel_select = true)
{
	if(GetPlayerPinCodeState(playerid) != PIN_CODE_STATE_NONE)
	{
		SetPlayerPinCodeState(playerid, PIN_CODE_STATE_NONE);

		if(canel_select)
			CancelSelectTextDraw(playerid);

		for(new idx = 0; idx < 10; idx ++)
		{
			PlayerTextDrawHide(playerid, pin_code_PTD[playerid][idx]);
			PlayerTextDrawDestroy(playerid, pin_code_PTD[playerid][idx]);
		}
	}
}

stock ShowCurrentTime(playerid)
{
	new
		hour, minute,
		year, month, day;

	gettime(hour, minute);
	getdate(year, month, day);

	SetPlayerChatBubble(playerid, "посмотрел(а) на время", 0xDD90FFFF, 25.0, 7000);


	new fmt_str[350];

	format(fmt_str, sizeof fmt_str, "~y~%d:%02d~n~~b~~h~%02d.%02d.%d", hour, minute, day, month, year);
	GameTextForPlayer(playerid, fmt_str, 3000, 1);

	format
	(
		fmt_str, sizeof fmt_str,
		"Сегодняшняя дата:\t\t{ffff00}%d %s %d г.\n"\
		"{FFFFFF}День недели:\t\t\t{ffff00}%s\n"\
		"{FFFFFF}Текущее время:\t\t{ffff00}%d:%02d\n\n"\
		"{FFFFFF}Время в игре за час:\t\t{ffff00}%d мин\n"\
		"{FFFFFF}Время в игре сегодня:\t{ffff00}%d ч %d мин\n"\
		"{FFFFFF}Время в игре вчера:\t\t{ffff00}%d ч %d мин",
		day,
		GetMonthName(month),
		year,
		GetDayName(GetDayOfWeek(year, month, day)),
		hour,
		minute,
		ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_HOUR), CONVERT_TIME_TO_MINUTES),
		ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY), CONVERT_TIME_TO_HOURS),
		ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY), CONVERT_TIME_TO_MINUTES),
		ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY_PREV), CONVERT_TIME_TO_HOURS),
		ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY_PREV), CONVERT_TIME_TO_MINUTES)
	);
	Action(playerid, "посмотрел(a) на время");

	return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{00FFFF}"SERVER_NAME" {ffffff}| Точное время", fmt_str, "Закрыть", "");
}

stock GetDayOfWeek(year, month, day)
{
    new a = (14 - month) / 12;
    new y = year + 4800 - a;
	new m = month + 12 * a - 3;
	new c_date = day + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045;
	new day_of_week = c_date % 7 + 1;

    return day_of_week;
}

stock UpdateCharity()
{
	if(cache_is_valid(charity_cache_data))
	{
		cache_delete(charity_cache_data);
	}
	new Cache: result;

	result = mysql_query(mysql, "SELECT (SELECT a.name FROM accounts a WHERE a.id = c.uid) as name, SUM(c.money) as total FROM charity c GROUP BY c.uid ORDER BY total DESC LIMIT 25", true);
	charity_cache_data = result;
}

stock Dialog(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	SetPlayerData(playerid, P_LAST_DIALOG, dialogid);

	return ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
}

stock abs(value)
{
	return value = -value;
}

stock IsNumeric(const dest[], pos=0)
{
	new is_numeric = true;
	do
	{
		switch(dest[pos])
		{
			case '0'..'9': continue;
			default:
			{
				is_numeric = false;
				break;
			}
		}
	}
	while(dest[++pos]);

	return is_numeric;
}

stock valfmt(dest[], value, size = sizeof dest)
{
	new buffer[15 + 1];
	valstr(buffer, value);

	new pos = strlen(buffer);
	while((pos -= 3) > 0)
	{
		strins(buffer, ".", pos);
	}
	format(dest, size, "%s", buffer);
}

stock GetSubnet(dest[], ip[], size = sizeof dest)
{
	new pos, dots;
	do
	{
		if(ip[pos] == '.')
		{
			if(++dots == 2)
			{
				ip[pos] = 0;
				break;
			}
		}
	}
	while(ip[++pos]);

	format(dest, size, "%s", ip);
}

stock GetFamilyChatID(team)
{
	if(TEAM_GOVERNMENT <= team <= TEAM_RADIO)
	{
		return 1;
	}
					else if(TEAM_DPS <= team <= TEAM_FBI)
	{
		return 2;
	}
					else if(TEAM_OPG_ARZAMASKAYA <= team <= TEAM_OPG_LYTKARINSKAYA)
	{
		return team;
	}
	return 0;
}

