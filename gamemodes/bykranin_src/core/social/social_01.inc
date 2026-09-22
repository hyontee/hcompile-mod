//>> Файл: bykranin_src/core/social/social_01.inc  (318 строк)
//>> Тема: телефон, чаты, объявления, справка
//>> Внутри: GetNearestAtm, GetElapsedTime, ConvertUnixTime, CheckPlayerFlood, ShowPhoneBookOperation, AddPhoneBookContact, CheckPhoneBookUsedNumber
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock GetNearestAtm(playerid, Float: dist = 15.0)
{
	if(dist == 0.0)
		dist = FLOAT_INFINITY;

	new atmid = -1;
	new Float: my_dist;

	for(new idx; idx < sizeof(g_atm); idx ++)
	{
		my_dist = GetPlayerDistanceFromPoint(playerid, g_atm[idx][A_POS_X], g_atm[idx][A_POS_Y], g_atm[idx][A_POS_Z]);
		if(my_dist < dist)
		{
			dist = my_dist,
			atmid = idx;
		}
	}
	return atmid;
}

stock GetElapsedTime(time, to_time, type = CONVERT_TIME_TO_HOURS)
{
	new result;

	switch(type)
	{
		case CONVERT_TIME_TO_MINUTES:
		{
			result = ((time - (time % 60)) - (to_time - (to_time % 60))) / 60;
		}
		case CONVERT_TIME_TO_HOURS:
		{
			result = ((time - (time % 3600)) - (to_time - (to_time % 3600))) / 3600;
		}
		case CONVERT_TIME_TO_DAYS:
		{
			result = ((time - (time % 86400)) - (to_time - (to_time % 86400))) / 86400;
		}
		default:
			result = -1;
	}
	return result;
}

stock ConvertUnixTime(unix_time, type = CONVERT_TIME_TO_SECONDS)
{
	switch(type)
	{
		case CONVERT_TIME_TO_SECONDS:
		{
			unix_time %= 60;
		}
		case CONVERT_TIME_TO_MINUTES:
		{
			unix_time = (unix_time / 60) % 60;
		}
		case CONVERT_TIME_TO_HOURS:
		{
			unix_time = (unix_time / 3600) % 24;
		}
		case CONVERT_TIME_TO_DAYS:
		{
			unix_time = (unix_time / 86400) % 30;
		}
		case CONVERT_TIME_TO_MONTHS:
		{
			unix_time = (unix_time / 2629743) % 12;
		}
		case CONVERT_TIME_TO_YEARS:
		{
			unix_time = (unix_time / 31556926) + 1970;
		}
		default:
			unix_time %= 60;
	}
	return unix_time;
}

stock CheckPlayerFlood(playerid, bool:inc = true, max_rate = MAX_FLOOD_RATE, rate_inc = FLOOD_RATE_INC, kick_rate = FLOOD_RATE_KICK)
{
	new tick = GetTickCount();

	AddPlayerAntiFloodData(playerid, AF_RATE, +, inc ? rate_inc : 0);
	AddPlayerAntiFloodData(playerid, AF_RATE, -, (GetTickCount() - GetPlayerAntiFloodData(playerid, AF_LAST_TICK)));
	SetPlayerAntiFloodData(playerid, AF_LAST_TICK, tick);

	if(GetPlayerAntiFloodData(playerid, AF_RATE) < 0)
		SetPlayerAntiFloodData(playerid, AF_RATE, 0);

	if(GetPlayerAntiFloodData(playerid, AF_RATE) >= max_rate)
	{
		if(GetPlayerAntiFloodData(playerid, AF_RATE) >= kick_rate)
		{
			Kick:(playerid, _, 10);
		}
		return 1;
	}
	return 0;
}

stock ShowPhoneBookOperation(playerid, operationid, contactid=0)
{
	switch(operationid)
	{
		case PHONE_BOOK_OPERATION_OPTIONS:
		{
			SetPlayerPhoneBookSelectContact(playerid, GetPlayerListitemValue(playerid, contactid));

			Dialog
			(
				playerid, DIALOG_PHONE_BOOK_OPTION, DIALOG_STYLE_LIST,
				"{FFCD00}Варианты",
				"1. Позвонить\n"\
				"2. Отправить SMS сообщение\n"\
				"3. Изменить имя контакта\n"\
				"4. Изменить номер контакта\n"\
				"5. Удалить контакт",
				"Выбрать", "Назад"
			);
		}
		case PHONE_BOOK_OPERATION_CALL:
		{
			new number[11]; // TODO
			format(number, sizeof number, "%d", GetPlayerPhoneBook(playerid, contactid, PB_NUMBER));
			callcmd::call(playerid, number);
		}
		case PHONE_BOOK_OPERATION_SEND_SMS:
		{
			Dialog
			(
				playerid, DIALOG_PHONE_BOOK_SEND_SMS, DIALOG_STYLE_INPUT,
				"{FFCD00}Отправка SMS сообщения",
				"{FFFFFF}-\t\t\tВведите текст SMS сообщения:\t\t-",
				"Отправить", "Назад"
			);
		}
		case PHONE_BOOK_OPERATION_CHANGE_NAM:
		{
			Dialog
			(
				playerid, DIALOG_PHONE_BOOK_CHANGE_NAME, DIALOG_STYLE_INPUT,
				"{FFCD00}Изменение имени контакта",
				"{FFFFFF}Введите новое имя для контакта:",
				"Изменить", "Назад"
			);
		}
		case PHONE_BOOK_OPERATION_CHANGE_NUM:
		{
			Dialog
			(
				playerid, DIALOG_PHONE_BOOK_CHANGE_NUMBER, DIALOG_STYLE_INPUT,
				"{FFCD00}Изменение номера контакта",
				"{FFFFFF}Введите новый номер для контакта:",
				"Изменить", "Назад"
			);
		}
		case PHONE_BOOK_OPERATION_DELETE_CON:
		{
			if(GetPlayerPhoneBook(playerid, contactid, PB_SQL_ID))
			{
				new query[80];

				format(query, sizeof query, "DELETE FROM phone_books WHERE id=%d LIMIT 1", GetPlayerPhoneBook(playerid, contactid, PB_SQL_ID));
				mysql_query(mysql, query, false);

				SetPlayerPhoneBookInitStatus(playerid, false);
				SendClientMessage(playerid, 0xFF9030FF, "Контакт удален с памяти телефона");
			}
		}
	}
}

stock AddPhoneBookContact(playerid, name[], number[])
{
	if(!IsPlayerPhoneBookInit(playerid))
	{
		InitPlayerPhoneBook(playerid);
	}
	if(GetPlayerPhoneBookContacts(playerid) < MAX_PHONE_BOOK_CONTACTS)
	{
		if(!CheckPhoneBookUsedNumber(playerid, number))
		{
			new fmt_str[128];
			SetPlayerPhoneBookInitStatus(playerid, false);

			format(fmt_str, sizeof fmt_str, "Вы добавили %s (тел. %s) в свой список контактов", name, number);
			SendClientMessage(playerid, 0x33FF66FF, fmt_str);

			mysql_format(mysql, fmt_str, sizeof fmt_str, "INSERT INTO phone_books (owner_id,name,number,time) VALUES (%d,'%e','%e',%d)", GetPlayerAccountID(playerid), name, number, gettime());
			mysql_query(mysql, fmt_str, false);
		}
	}
	return 1;
}

stock CheckPhoneBookUsedNumber(playerid, number[])
{
	for(new idx, len; idx < MAX_PHONE_BOOK_CONTACTS; idx ++)
	{
		if(!GetPlayerPhoneBook(playerid, idx, PB_SQL_ID)) continue;

		len = strlen(GetPlayerPhoneBook(playerid, idx, PB_NUMBER));
		if(len && !strcmp(GetPlayerPhoneBook(playerid, idx, PB_NUMBER), number, true))
		{
			new fmt_str[64];
			format(fmt_str, sizeof fmt_str, "{FFFFFF}Номер %s уже записан для контакта %s", number, GetPlayerPhoneBook(playerid, idx, PB_NAME));
			Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF6633}Ошибка", fmt_str, "Закрыть", "");

			return 1;
		}
	}
	return 0;
}

stock InitPlayerPhoneBook(playerid)
{
	if(!IsPlayerPhoneBookInit(playerid))
	{
		new query[80];
		new Cache: result, rows;

		format(query, sizeof query, "SELECT * FROM phone_books WHERE owner_id=%d ORDER BY id DESC LIMIT %d", GetPlayerAccountID(playerid), MAX_PHONE_BOOK_CONTACTS);
		result = mysql_query(mysql, query);

		rows = cache_num_rows(result);
		for(new idx; idx < MAX_PHONE_BOOK_CONTACTS; idx ++)
		{
			if(idx < rows)
			{
				SetPlayerPhoneBook(playerid, idx, PB_SQL_ID, cache_get_row_int(idx, 0));

				cache_get_row(idx, 2, g_player_phone_book[playerid][idx][PB_NAME], mysql, 21);
				cache_get_row(idx, 3, g_player_phone_book[playerid][idx][PB_NUMBER], mysql, 9);

				SetPlayerPhoneBook(playerid, idx, PB_TIME, cache_get_row_int(idx, 4));
				continue;
			}
			ClearPlayerPhoneBookContact(playerid, idx);
		}
		cache_delete(result);

		SetPlayerPhoneBookContacts(playerid, rows);
		SetPlayerPhoneBookInitStatus(playerid, true);
	}
	return 1;
}

stock ClearPlayerPhoneBookContact(playerid, contactid)
{
	SetPlayerPhoneBook(playerid, contactid, PB_SQL_ID, 	0);
	SetPlayerPhoneBook(playerid, contactid, PB_NAME, 	0);
	SetPlayerPhoneBook(playerid, contactid, PB_NUMBER, 	0);
	SetPlayerPhoneBook(playerid, contactid, PB_TIME, 	0);
}

stock GetPlayerIDByPhone(number)
{
	new playerid = INVALID_PLAYER_ID;

	if(1000 <= number <= 9999999)
	{
		foreach(new i : Player)
		{
			if(!IsPlayerLogged(i)) continue;
			if(number != GetPlayerPhone(i)) continue;

			playerid = i;
			break;
		}
	}
	return playerid;
}

stock CheckPlayerTempJobState(playerid)
{
	new job = GetPlayerTempJob(playerid);
	new j_state = GetPlayerTempJobState(playerid);

	//new s_action = GetPlayerSpecialAction(playerid);

	switch(job)
	{
		case TEMP_JOB_MINER:
		{
			if(j_state == TEMP_JOB_STATE_MINER_DROP_LOAD) // || s_action != SPECIAL_ACTION_NONE
			{
				SetPlayerTempJobCheckAnim(playerid, false);
				SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_LOAD);

				RemovePlayerAttachedObjects(playerid);
				ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 1, 0);

		//tPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 18634, A_OBJECT_BONE_RIGHT_HAND, 0.07, 0.02, 0.04, 0.0, 270.0, 270.0, 1.5, 2.1, 1.8, 0);

				SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE);
				SetPlayerMinerJobLoadCP(playerid);

				SendClientMessage(playerid, 0xFF6600FF, "Вы сломали тележку");
			}
		}
		case TEMP_JOB_FACTORY:
		{
			if(j_state == TEMP_JOB_STATE_FACTORY_DROP_P)
			{
				FactoryPlayerDrop(playerid, false);
			}
		}
		case TEMP_JOB_LUMBERJACK:
		{
			if(j_state == TEMP_JOB_STATE_LUMBERJACK_DROP)
			{
				LumberJackPlayerDrop(playerid, true);
			}
		}
	}
}

