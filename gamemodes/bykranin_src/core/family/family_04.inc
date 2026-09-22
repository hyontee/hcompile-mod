//>> Файл: bykranin_src/core/family/family_04.inc  (520 строк)
//>> Тема: семьи / банды / организации
//>> Внутри: /rn, /gnews, /invite, /uninvite, /rang, /changeskin, /showall
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:rn(playerid, params[])
{
	if(!(GetPlayerTeamEx(playerid) || GetPlayerJob(playerid))) return SendClientMessage(playerid, 0xCECECEFF, "Вы нигде не работаете/не состоите в организациях");
	// else if(TEAM_GANG_GROVE <= GetPlayerTeamEx(playerid) <= TEAM_GANG_AZTECAS) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна для сотрудников гос. организаций");
	else if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xCECECEFF, "Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	else if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /rn [текст]");

	new fmt_msg[144];

	format(fmt_msg, sizeof fmt_msg, "(( OOC: [R] %s %s[%d]: %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);

	if(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)
		SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_msg, 0x33CC66FF);
	else
		SendMessageToJob(GetPlayerJob(playerid), fmt_msg, 0x33CC66FF, _);

	SetPlayerChatBubble(playerid, "сказал(а) что-то в рацию", 0xDD99FFAA, 10.0, 4000);
	return 1;
}

/*CMD:ff(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)) return SendClientMessage(playerid, 0x999999FF, "Вы не состоите в организациях");
	if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /ff [текст]");

	new fmt_msg[144];
	format(fmt_msg, sizeof fmt_msg, "(( [F] %s %s[%d]: %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);

	if(IsAIP(params))
	{
      	SendClientMessage(playerid, -1, "Подозрения в рекламе!");
       	return false;
    }

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
}*/

/*CMD:r(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)) return SendClientMessage(playerid, 0x999999FF, "Вы не состоите в организациях");
	if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /f [текст]");

	new fmt_msg[144];
	format(fmt_msg, sizeof fmt_msg, "[F] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);

	if(IsAIP(params))
	{
      	SendClientMessage(playerid, -1, "Подозрения в рекламе!");
       	return false;
    }

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
}*/

CMD:gnews(playerid, params[])
{
	if(!(TEAM_GOVERNMENT <= GetPlayerTeamEx(playerid) <= TEAM_FBI)) return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");
	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам организации и их заместителям");
	if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /gnews [текст]");

	if(IsAIP(params))
	{
      	SendClientMessage(playerid, -1, "Подозрения в рекламе!");
       	return false;
    }

	new fmt_msg[170 + 1];
	format(fmt_msg, sizeof fmt_msg, "Гос.новости: %s[%d]: %s", GetPlayerNameEx(playerid), playerid, params);
	SendClientMessageToAll(0x4466CCFF,  fmt_msg);

	return 1;
}
alias:gnews("gov")

CMD:invite(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)) return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");
	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам организации и их заместителям");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /invite [id игрока]");

	extract params -> new to_player;
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
	if(1 <= GetPlayerTeamEx(to_player) < MAX_ORG) return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок уже состоит в организации");
	if(GetPlayerData(to_player, P_WARN)) return SendClientMessage(playerid, 0xCECECEFF, "У игрока есть предупреждения");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 10.0)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок находится слишком далеко");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_INVITE);
	return 1;
}

CMD:uninvite(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)) return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");
	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам организации и их заместителям");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /uninvite [id игрока] [причина]");

	extract params -> new to_player, string:reason[32];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	if(!(1 <= strlen(reason) <= 32))
		return SendClientMessage(playerid, 0xCECECEFF, "Введите причину увольнения");
	/*
	if(GetPlayerTeamEx(playerid) == TEAM_GOVERNMENT && GetPlayerJob(playerid) >= 10)
	{
		if(!(1 <= GetPlayerTeamEx(to_player) <= TEAM_PPS) || GetPlayerJob(to_player) == 10)
			return SendClientMessage(playerid, 0xCECECEFF, "Вы можете уволить любого сотрудника гос. организации, кроме ФСБ");
	}
					else
	{*/

	if(GetPlayerTeamEx(to_player) != GetPlayerTeamEx(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок не состоит в Вашей организации");

	if(GetPlayerJob(to_player) >= GetPlayerJob(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Нельзя уволить уволить заместителя/лидера организации");

	// }

	UnInvite(playerid, to_player, reason);

	return 1;
}

CMD:rang(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)) return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");
	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам организации и их заместителям");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /rang [id игрока] [+/-]");
	extract params -> new to_player, string:give_rang[2];
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(GetPlayerTeamEx(to_player) != GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0x999999FF, "Этот игрок не состоит в Вашей организации");
	if(GetPlayerJob(to_player) >= 10) return SendClientMessage(playerid, 0x999999FF, "Нельзя повысить или понизить лидера организации");

	new current_rang = GetPlayerJob(to_player);

	new fmt_msg[75];
	if(give_rang[0] == '+')
	{
		if((current_rang + 1) >= GetPlayerJob(playerid)) return SendClientMessage(playerid, 0x999999FF, "Нельзя повысить больше своего ранга");

		GetPlayerJob(to_player)++;
		format(fmt_msg, sizeof fmt_msg, "Ваш ранг в организации был повышен до %d (%s)", GetPlayerJob(to_player), GetPlayerJobAndRankName(to_player));
		SendClientMessage(to_player, 0x3399FFFF, fmt_msg);
	}
					else if(give_rang[0] == '-')
	{
		if((current_rang - 1) < 1) return SendClientMessage(playerid, 0x999999FF, "Нельзя понизить ниже 1 ранга");

		GetPlayerJob(to_player)--;
		format(fmt_msg, sizeof fmt_msg, "Ваш ранг в организации был понижен до %d (%s)", GetPlayerJob(to_player), GetPlayerJobAndRankName(to_player));
		SendClientMessage(to_player, 0x3399FFFF, fmt_msg);
	}
					else return SendClientMessage(playerid, 0xCECECEFF, "Введите действие: '+' чтобы повысить или '-' чтобы понизить");

	if(GetPlayerTeamEx(to_player) == TEAM_GOVERNMENT && IsValidDynamic3DTextLabel(GetPlayerData(to_player, P_ADVISOR_LABEL)))
	{
		DestroyDynamic3DTextLabel(GetPlayerData(to_player, P_ADVISOR_LABEL));
		SetPlayerData(to_player, P_ADVISOR_LABEL, Text3D: -1);
	}

	if(!GetPlayerSex(to_player))
	{
		SetPlayerData(playerid, P_OSKIN, GetTeamData(GetPlayerTeamEx(to_player), O_SKINS)[GetPlayerJob(to_player)-1]);
		ResetSkin(to_player);
	}

	format(fmt_msg, sizeof fmt_msg, "Вы %s ранг %s[%d] до %d (%s)", (give_rang[0] == '+') ? ("повысили") : ("понизили"),  GetPlayerNameEx(to_player), to_player, GetPlayerJob(to_player), GetPlayerJobAndRankName(to_player));
	SendClientMessage(playerid, 0x3399FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "UPDATE accounts SET org_skin=%d,job=%d WHERE id=%d", GetPlayerData(to_player, P_OSKIN), GetPlayerJob(to_player), GetPlayerAccountID(to_player));
	mysql_query(mysql, fmt_msg, false);

	format(fmt_msg, sizeof fmt_msg, "%s %s[acc:%d] до %d (%s)", (give_rang[0] == '+') ? ("Повысил") : ("Понизил"),  GetPlayerNameEx(to_player), to_player, GetPlayerJob(to_player), GetPlayerJobAndRankName(to_player));

	SendLog(playerid, LOG_TYPE_FRACTION, fmt_msg);

	return 1;
}

CMD:changeskin(playerid, params[])
{
    if(GetPlayerTeamEx(playerid) < 1 || GetPlayerTeamEx(playerid) >= MAX_ORG)
        return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");

    if(GetPlayerJob(playerid) < 9 || GetPlayerJob(playerid) > 10)
        return SendClientMessage(playerid, 0x999999FF, "Функция доступна лидерам организации и их заместителям");

    if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /changeskin [id игрока]");
    extract params -> new to_player;

    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

    if(GetPlayerTeamEx(to_player) != GetPlayerTeamEx(playerid))
        return SendClientMessage(playerid, 0x999999FF, "Этот игрок не состоит в Вашей организации");

    if(GetPlayerSex(to_player))
        return SendClientMessage(playerid, 0x999999FF, "Нельзя изменить внешность игрокам с женским полом");

    new team_id = GetPlayerTeamEx(playerid);

    new fmt_str[50];
    new text[256];
    new count;

    SetPVarInt(playerid, "change_team_skin_playerid", to_player);

    for(new i; i < 10; i++)
    {
        new skin_id = GetTeamData(team_id, O_SKINS)[i];

        if(skin_id == 0) continue; 

        
        SetPlayerListitemValue(playerid, count, i);
        format(fmt_str, sizeof fmt_str, "Скин %d (ID: %d)\n", count + 1, skin_id);
        strcat(text, fmt_str);

        count++;
    }

    if(count == 0)
        return SendClientMessage(playerid, 0x999999FF, "Нет доступных скинов для этой организации");

    Dialog(playerid, DIALOG_TEAM_CHANGE_SKIN, DIALOG_STYLE_LIST, 
        "Выберите внешность для игрока:", text, "Ок", "Отмена");

    return 1;
}



CMD:showall(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)) return SendClientMessage(playerid, 0xCECECEFF, "Вам недоступна данная функция");
	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам организации и их заместителям");

	new query[75];
	format(query, sizeof query, "SELECT name, score, job FROM accounts WHERE team = %d ORDER BY job DESC", GetPlayerTeamEx(playerid));
	mysql_tquery(mysql, query, "ShowOrgAllPlayers", "i", playerid);
	return 1;
}

public: ShowOrgAllPlayers(playerid)
{
	new rows = cache_num_rows();

	new p_name[21];
	new lvl, rang;

	new fmt_str[33];
	new text[1290] = "Уровень\tРанг\tИмя\n\n{FFFFFF}";

	new idx, j = rows;
	if(j > 45)
		j = 45;

	for(idx = 0; idx < j; idx ++)
	{
		cache_get_row(idx, 0, p_name);
		lvl = cache_get_row_int(idx, 1);
		rang = cache_get_row_int(idx,2);

		format(fmt_str, sizeof fmt_str, "%d\t%d\t%s\n", lvl, rang, p_name);
		strcat(text, fmt_str);
	}

	format(fmt_str, sizeof fmt_str, "{00CC00}Показаны %d/%d игроков", idx, rows);
	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, fmt_str, text, "Закрыть", "");
	return 1;
}

CMD:find(playerid, params[])
{
	if(!(GetPlayerTeamEx(playerid) || GetPlayerJob(playerid))) return SendClientMessage(playerid, 0xCECECEFF, "Вы нигде не работаете/не состоите в организациях");

	ShowTeamStructureDialog(playerid, GetPlayerTeamEx(playerid));
	return 1;
}

stock ShowTeamStructureDialog(playerid, teamid)
{
	new string[1500];
	new fmt_str[40];

	if(teamid)
	{
		string = "Уровень\tРанг\tТелефон\tИмя\n\n{FFFFFF}";

		for(new i; i < MAX_PLAYERS; i ++)
		{
			if(!IsPlayerConnected(i)) continue;
			else if(!IsPlayerLogged(i)) continue;
			else if(GetPlayerTeamEx(i) != teamid) continue;

			format(fmt_str, sizeof fmt_str, "%d\t\t%d\t%d\t\t%s", GetPlayerLevel(i), GetPlayerJob(i), GetPlayerPhone(i), GetPlayerNameEx(i));
			strcat(string, fmt_str);

			if(IsPlayerAFK(i))
				strcat(string, "-AFK");

			strcat(string, "\n");
		}

		if(IsTeamSubdivision(teamid))
			Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCC00}Члены подразделения online", string, "Закрыть", "");
		else
			Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCC00}Члены организации online", string, "Закрыть", "");
	}
					else
	{
		string = "Уровень\tТелефон\tИмя\n\n{FFFFFF}";

		for(new i; i < MAX_PLAYERS; i ++)
		{
			if(!IsPlayerConnected(i)) continue;
			else if(!IsPlayerLogged(i)) continue;
			else if(GetPlayerJob(i) != GetPlayerJob(playerid)) continue;

			format(fmt_str, sizeof fmt_str, "%d\t%d%s%s", GetPlayerLevel(i), GetPlayerPhone(i), GetPlayerPhone(i) > 0 ? ("\t") : ("\t\t"), GetPlayerNameEx(i));
			strcat(string, fmt_str);

			if(IsPlayerAFK(i))
				strcat(string, "-AFK");

			if(IsPlayerInJob(i))
				strcat(string, " *");

			strcat(string, "\n");
		}

		Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCC00}Сотрудники online", string, "Закрыть", "");
	}
	return 1;
}

CMD:leadersooooooooold(playerid, params[])
{
	new fmt_text[75],
		list[sizeof fmt_text * 10 + 50] = "Организация - Должность - Имя - Телефон{FFFFFF}\n";

	foreach(new i : Player)
	{
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;
		else if(!GetPlayerTeamEx(i)) continue;
		else if(GetPlayerJob(i) != 10) continue;

		format(fmt_text, sizeof fmt_text, "\n%s - %s - %s[%d] - %d", GetTeamName(GetPlayerTeamEx(i)), GetPlayerJobAndRankName(i), GetPlayerNameEx(i), i, GetPlayerPhone(i));
		strcat(list, fmt_text);
	}

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCD00}Лидеры онлайн", list, "Закрыть", "");

	return 1;
}

CMD:liclist(playerid, params[])
{
 new fmt_text[78],
  list[sizeof fmt_text * 10 + 50] = "Организация - Должность - Имя - Телефон{FFFFFF}\n";

 foreach(new i : Player)
 {
  if(!IsPlayerConnected(i)) continue;
  else if(!IsPlayerLogged(i)) continue;
  else if(GetPlayerTeamEx(i) != TEAM_GOVERNMENT) continue;
  else if(GetPlayerJob(i) != 6) continue;

  format(fmt_text, sizeof fmt_text, "\nПравительство - Лицензёр - %s[%d] - тел. %d", GetPlayerNameEx(i), i, GetPlayerPhone(i));
  strcat(list, fmt_text);
 }

 Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{FFCD00}Лицензёры онлайн", list, "Закрыть", "");

 return 1;
}

CMD:debtorsell(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT) return SendClientMessage(playerid, 0x999999FF, "Функция доступна сотрудникам правительства");
	if(GetPlayerJob(playerid) < 4) return SendClientMessage(playerid, 0xCECECEFF, "Команда доступна сотрудникам правительства с 4 ранга");

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

CMD:debtorlist(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT) return SendClientMessage(playerid, 0x999999FF, "Функция доступна сотрудникам правительства");
	if(GetPlayerJob(playerid) < 3) return SendClientMessage(playerid, 0xCECECEFF, "Команда доступна сотрудникам правительства с 3 ранга");

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

stock ShowDebtorListDialog(playerid, type)
{
	new
		fmt_str[36 + 1],
		text[((sizeof fmt_str) * 20) + 1],
		cur_time = gettime(),
		idx,
		count;

	if(type == 0)
	{
		for(idx = 0, count = 0; idx < g_house_loaded; idx ++)
		{
			if(count > 20) break;
			if(GetHouseData(idx, H_OWNER_ID) < 1) continue;
			if((((GetHouseData(idx, H_RENT_DATE) - cur_time) / 86400) + 1) > 0) continue;
			if(GetHouseData(idx, H_EVICTION)) continue;

			SetPlayerListitemValue(playerid, count, idx);
			count ++;

			if(GetHouseData(idx, H_TYPE))
			{
				format(fmt_str, sizeof fmt_str, "кв. %d под. %d (%s)\n", idx % 6 + 1, GetHouseData(idx, H_ENTRACE) + 1, "Нижегородская обл.");
			}
					else
			{
				format(fmt_str, sizeof fmt_str, "%d (%s)\n", idx, "Нижегородская обл.");
			}
			strcat(text, fmt_str);
		}
		if(!count) return SendClientMessage(playerid, 0xCECECEFF, "Должников по оплате аренды за жилье нет");

		Dialog(playerid, DIALOG_DEBTORLIST_HOUSE, DIALOG_STYLE_LIST, "{FFCC00}Жилье должников", text, "Отметить", "Назад");
	}
					else if(type == 1)
	{
		for(idx = 0, count = 0; idx < g_business_loaded; idx ++)
		{
			if(count > 20) break;
			if(GetBusinessData(idx, B_OWNER_ID) < 1) continue;
			if((((GetBusinessData(idx, B_RENT_DATE) - cur_time) / 86400) + 1) > 0) continue;
			if(GetBusinessData(idx, B_EVICTION)) continue;

			SetPlayerListitemValue(playerid, count, idx);
			count ++;

			format(fmt_str, sizeof fmt_str, "%d (%s)\n", idx, "Нижегородская обл.");
			strcat(text, fmt_str);
		}
		if(!count) return SendClientMessage(playerid, 0xCECECEFF, "Должников по оплате аренды за предприятия нет");

		Dialog(playerid, DIALOG_DEBTORLIST_BIZ, DIALOG_STYLE_LIST, "{FFCC00}Предприятия должников", text, "Отметить", "Назад");
	}
					else
	{
		for(idx = 0, count = 0; idx < g_fuel_station_loaded; idx ++)
		{
			if(count > 20) break;
			if(GetFuelStationData(idx, FS_OWNER_ID) < 1) continue;
			if((((GetFuelStationData(idx, FS_RENT_DATE) - cur_time) / 86400) + 1) > 0) continue;
			if(GetFuelStationData(idx, FS_EVICTION)) continue;

			SetPlayerListitemValue(playerid, count, idx);
			count ++;

			format(fmt_str, sizeof fmt_str, "%d (%s)\n", idx, "Нижегородская обл.");
			strcat(text, fmt_str);
		}
		if(!count) return SendClientMessage(playerid, 0xCECECEFF, "Должников по оплате аренды за АЗС нет");

		Dialog(playerid, DIALOG_DEBTORLIST_FUEL_ST, DIALOG_STYLE_LIST, "{FFCC00}Заправочные станции должников", text, "Отметить", "Назад");
	}

	return 1;
}

