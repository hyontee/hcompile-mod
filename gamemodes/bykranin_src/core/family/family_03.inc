//>> Файл: bykranin_src/core/family/family_03.inc  (437 строк)
//>> Тема: семьи / банды / организации
//>> Внутри: /members, /leaders, /admlist, /admlist1
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:members(playerid, params[])
{
    if(GetPlayerTeamEx(playerid) == 1) //правительство
	{
	    new fmt_text[75],
        list[sizeof fmt_text * 10 + 50] = "Никнейм \t \t \t \t \t \t \t \t \t Уровень \t \t \t \t \t \t \t \t \t \t \t Должность{FFFFFF}\n";
	
	
        for(new f; f<MAX_PLAYERS; f++)
        {
	        if(!IsPlayerConnected(f)) continue;
			if(GetPlayerTeamEx(f) == 1)
		    {
		
		
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
					else if(!IsPlayerLogged(i)) continue;
					else if(!GetPlayerTeamEx(i) == 1) continue;

                    format(fmt_text, sizeof fmt_text, "%s[%d] \t \t \t \t \t \t \t \t %d \t \t \t \t \t \t \t \t \t \t \t \t %s\n", GetPlayerNameEx(i), i, GetPlayerJob(i), GetPlayerJobAndRankName(i));
                    strcat(list, fmt_text);
                }
			    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Состав Правительства онлайн", list, "Закрыть", "");
		    }
					else ShowNotificationNew(playerid, 2, 7, 0, 0, "Состав Правительства нет онлайн", ">>");
	    }
	}
	if(GetPlayerTeamEx(playerid) == 2) //вч
	{
	    new fmt_text[75],
        list[sizeof fmt_text * 10 + 50] = "Никнейм \t \t \t \t \t \t \t \t \t Уровень \t \t \t \t \t \t \t \t \t \t \t Должность{FFFFFF}\n";
	
	
        for(new f; f<MAX_PLAYERS; f++)
        {
	        if(!IsPlayerConnected(f)) continue;
	        if(GetPlayerTeamEx(f) == 2)
		    {
		
		
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
					else if(!IsPlayerLogged(i)) continue;
					else if(!GetPlayerTeamEx(i) == 2) continue;

                    format(fmt_text, sizeof fmt_text, "%s[%d] \t \t \t \t \t \t \t \t %d \t \t \t \t \t \t \t \t \t \t \t \t %s\n", GetPlayerNameEx(i), i, GetPlayerJob(i), GetPlayerJobAndRankName(i));
                    strcat(list, fmt_text);
                }
			    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Состав Военной части в сети", list, "Закрыть", "");
		    }
					else ShowNotificationNew(playerid, 2, 7, 0, 0, "Администраторов нет онлайн", ">>");
	    }
	}
	if(GetPlayerTeamEx(playerid) == 3) //болька
	{
	    new fmt_text[75],
        list[sizeof fmt_text * 10 + 50] = "Никнейм \t \t \t \t \t \t \t \t \t Уровень \t \t \t \t \t \t \t \t \t \t \t Должность{FFFFFF}\n";
	
	
        for(new f; f<MAX_PLAYERS; f++)
        {
	        if(!IsPlayerConnected(f)) continue;
	        if(GetPlayerTeamEx(f) == 3)
		    {
		
		
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
					else if(!IsPlayerLogged(i)) continue;
					else if(!GetPlayerTeamEx(i) == 3) continue;

                    format(fmt_text, sizeof fmt_text, "%s[%d] \t \t \t \t \t \t \t \t %d \t \t \t \t \t \t \t \t \t \t \t \t %s\n", GetPlayerNameEx(i), i, GetPlayerJob(i), GetPlayerJobAndRankName(i));
                    strcat(list, fmt_text);
                }
			    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Состав Больницы в сети", list, "Закрыть", "");
		    }
					else ShowNotificationNew(playerid, 2, 7, 0, 0, "Администраторов нет онлайн", ">>");
	    }
	}
	if(GetPlayerTeamEx(playerid) == 4) //сми
	{
	    new fmt_text[75],
        list[sizeof fmt_text * 10 + 50] = "Никнейм \t \t \t \t \t \t \t \t \t Уровень \t \t \t \t \t \t \t \t \t \t \t Должность{FFFFFF}\n";
	
	
        for(new f; f<MAX_PLAYERS; f++)
        {
	        if(!IsPlayerConnected(f)) continue;
	        if(GetPlayerTeamEx(f) == 4)
		    {
		
		
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
					else if(!IsPlayerLogged(i)) continue;
					else if(!GetPlayerTeamEx(i) == 4) continue;

                    format(fmt_text, sizeof fmt_text, "%s[%d] \t \t \t \t \t \t \t \t %d \t \t \t \t \t \t \t \t \t \t \t \t %s\n", GetPlayerNameEx(i), i, GetPlayerJob(i), GetPlayerJobAndRankName(i));
                    strcat(list, fmt_text);
                }
			    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Состав СМИ в сети", list, "Закрыть", "");
		    }
					else ShowNotificationNew(playerid, 2, 7, 0, 0, "Администраторов нет онлайн", ">>");
	    }
	}
	if(GetPlayerTeamEx(playerid) == 5) //гибдд
	{
	    new fmt_text[75],
        list[sizeof fmt_text * 10 + 50] = "Никнейм \t \t \t \t \t \t \t \t \t Уровень \t \t \t \t \t \t \t \t \t \t \t Должность{FFFFFF}\n";
	
	
        for(new f; f<MAX_PLAYERS; f++)
        {
	        if(!IsPlayerConnected(f)) continue;
	        if(GetPlayerTeamEx(f) == 5)
		    {
		
		
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
					else if(!IsPlayerLogged(i)) continue;
					else if(!GetPlayerTeamEx(i) == 5) continue;

                    format(fmt_text, sizeof fmt_text, "%s[%d] \t \t \t \t \t \t \t \t %d \t \t \t \t \t \t \t \t \t \t \t \t %s\n", GetPlayerNameEx(i), i, GetPlayerJob(i), GetPlayerJobAndRankName(i));
                    strcat(list, fmt_text);
                }
			    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Состав ГИБДД в сети", list, "Закрыть", "");
		    }
					else ShowNotificationNew(playerid, 2, 7, 0, 0, "Администраторов нет онлайн", ">>");
	    }
	}
	if(GetPlayerTeamEx(playerid) == 6) //умвд
	{
	    new fmt_text[75],
        list[sizeof fmt_text * 10 + 50] = "Никнейм \t \t \t \t \t \t \t \t \t Уровень \t \t \t \t \t \t \t \t \t \t \t Должность{FFFFFF}\n";
	
	
        for(new f; f<MAX_PLAYERS; f++)
        {
	        if(!IsPlayerConnected(f)) continue;
	        if(GetPlayerTeamEx(f) == 6)
		    {
		
		
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
					else if(!IsPlayerLogged(i)) continue;
					else if(!GetPlayerTeamEx(i) == 6) continue;

                    format(fmt_text, sizeof fmt_text, "%s[%d] \t \t \t \t \t \t \t \t %d \t \t \t \t \t \t \t \t \t \t \t \t %s\n", GetPlayerNameEx(i), i, GetPlayerJob(i), GetPlayerJobAndRankName(i));
                    strcat(list, fmt_text);
                }
			    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Состав УМВД в сети", list, "Закрыть", "");
		    }
					else ShowNotificationNew(playerid, 2, 7, 0, 0, "Администраторов нет онлайн", ">>");
	    }
	}
	if(GetPlayerTeamEx(playerid) == 7) //фсб
	{
	    new fmt_text[75],
        list[sizeof fmt_text * 10 + 50] = "Никнейм \t \t \t \t \t \t \t \t \t Уровень \t \t \t \t \t \t \t \t \t \t \t Должность{FFFFFF}\n";
	
	
        for(new f; f<MAX_PLAYERS; f++)
        {
	        if(!IsPlayerConnected(f)) continue;
	        if(GetPlayerTeamEx(f) == 7)
		    {
		
		
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
					else if(!IsPlayerLogged(i)) continue;
					else if(!GetPlayerTeamEx(i) == 7) continue;

                    format(fmt_text, sizeof fmt_text, "%s[%d] \t \t \t \t \t \t \t \t %d \t \t \t \t \t \t \t \t \t \t \t \t %s\n", GetPlayerNameEx(i), i, GetPlayerJob(i), GetPlayerJobAndRankName(i));
                    strcat(list, fmt_text);
                }
			    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Состав ФСБ в сети", list, "Закрыть", "");
		    }
					else ShowNotificationNew(playerid, 2, 7, 0, 0, "Администраторов нет онлайн", ">>");
	    }
	}
	if(GetPlayerTeamEx(playerid) == 8) //арз опг
	{
	    new fmt_text[75],
        list[sizeof fmt_text * 10 + 50] = "Никнейм \t \t \t \t \t \t \t \t \t Уровень \t \t \t \t \t \t \t \t \t \t \t Должность{FFFFFF}\n";
	
	
        for(new f; f<MAX_PLAYERS; f++)
        {
	        if(!IsPlayerConnected(f)) continue;
	        if(GetPlayerTeamEx(f) == 8)
		    {
		
		
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
					else if(!IsPlayerLogged(i)) continue;
					else if(!GetPlayerTeamEx(i) == 8) continue;

                    format(fmt_text, sizeof fmt_text, "%s[%d] \t \t \t \t \t \t \t \t %d \t \t \t \t \t \t \t \t \t \t \t \t %s\n", GetPlayerNameEx(i), i, GetPlayerJob(i), GetPlayerJobAndRankName(i));
                    strcat(list, fmt_text);
                }
			    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Состав АРЗ ОПГ в сети", list, "Закрыть", "");
		    }
					else ShowNotificationNew(playerid, 2, 7, 0, 0, "Администраторов нет онлайн", ">>");
	    }
	}
	if(GetPlayerTeamEx(playerid) == 9) //бат опг
	{
	    new fmt_text[75],
        list[sizeof fmt_text * 10 + 50] = "Никнейм \t \t \t \t \t \t \t \t \t Уровень \t \t \t \t \t \t \t \t \t \t \t Должность{FFFFFF}\n";
	
	
        for(new f; f<MAX_PLAYERS; f++)
        {
	        if(!IsPlayerConnected(f)) continue;
	        if(GetPlayerTeamEx(f) == 9)
		    {
		
		
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
					else if(!IsPlayerLogged(i)) continue;
					else if(!GetPlayerTeamEx(i) == 9) continue;

                    format(fmt_text, sizeof fmt_text, "%s[%d] \t \t \t \t \t \t \t \t %d \t \t \t \t \t \t \t \t \t \t \t \t %s\n", GetPlayerNameEx(i), i, GetPlayerJob(i), GetPlayerJobAndRankName(i));
                    strcat(list, fmt_text);
                }
			    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | Состав БАТ ОПГ в сети", list, "Закрыть", "");
		    }
					else ShowNotificationNew(playerid, 2, 7, 0, 0, "Администраторов нет онлайн", ">>");
	    }
	}
	if(GetPlayerTeamEx(playerid) == 10) //лыт опг
	{
	    new fmt_text[75],
        list[sizeof fmt_text * 10 + 50] = "Никнейм \t \t \t \t \t \t \t \t \t Уровень \t \t \t \t \t \t \t \t \t \t \t Должность{FFFFFF}\n";
	
	
        for(new f; f<MAX_PLAYERS; f++)
        {
	        if(!IsPlayerConnected(f)) continue;
	        if(GetPlayerTeamEx(f) == 10)
		    {
		
		
                foreach(new i : Player)
                {
                    if(!IsPlayerConnected(i)) continue;
					else if(!IsPlayerLogged(i)) continue;
					else if(!GetPlayerTeamEx(i) == 10) continue;

                    format(fmt_text, sizeof fmt_text, "%s[%d] \t \t \t \t \t \t \t \t %d \t \t \t \t \t \t \t \t \t \t \t \t %s\n", GetPlayerNameEx(i), i, GetPlayerJob(i), GetPlayerJobAndRankName(i));
                    strcat(list, fmt_text);
                }
			    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME"{ffffff} | ЛЫТ ОПГ в сети", list, "Закрыть", "");
		    }
					else ShowNotificationNew(playerid, 2, 7, 0, 0, "Администраторов нет онлайн", ">>");
	    }
	}
	
	
	
	
    


return 1;
}


CMD:leaders(playerid, params[])
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

 Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_LIST, "{FFCD00}Лидеры онлайн", list, "Закрыть", "");

 return 1;
}

CMD:admlist(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;

	new query[115],
		Cache: result,
		rows,
		admin,
		day_prev,
		day_last,
		name[21],
		last_login,
		last_date[6],
		list[sizeof query * 25 + 60] = "Имя\t\t\tРанг\tВ игре вчера\tВ игре сегодня\tСтатус\tПоследний Вход\n{FFFFFF}";

	mysql_format(mysql, query, sizeof query, "SELECT * FROM accounts WHERE admin > 0 ORDER BY last_login ASC");
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);

	for(new i; i < rows; i ++)
	{
		new day_time[4];

		admin = cache_get_field_content_int(i, "admin");
		day_prev = cache_get_field_content_int(i, "game_for_day_prev");
		day_last = cache_get_field_content_int(i, "game_for_day");

		day_time[0] = ConvertUnixTime(day_prev, CONVERT_TIME_TO_HOURS);
		day_time[1] = ConvertUnixTime(day_prev, CONVERT_TIME_TO_MINUTES);

		day_time[2] = ConvertUnixTime(day_last, CONVERT_TIME_TO_HOURS);
		day_time[3] = ConvertUnixTime(day_last, CONVERT_TIME_TO_MINUTES);

		last_login = cache_get_field_content_int(i, "last_login");
		timestamp_to_date(last_login, last_date[2], last_date[1], last_date[0], last_date[3], last_date[4], last_date[5]);


		cache_get_field_content(i, "name", name);

		new fix_tabulation[21] = "                    ";

		format
		(
			query, sizeof query,
			"\n{FFFFFF}%s%s\t%d ур.\t%s%d ч %d мин\t%s%d ч %d мин\t\t%s\t%02d.%02d.%d в %02d:%02d:%02d\n",
			name,
			fix_tabulation[strlen(name)],
			admin,
			day_time[0] >= 3 ? day_time[0] > 3 ? "{66CC33}" : "{FFCD00}" : "{FF5533}",
			day_time[0],
			day_time[1],
			day_time[2] >= 3 ? day_time[0] > 3 ? "{66CC33}" : "{FFCD00}" : "{FF5533}",
			day_time[2],
			day_time[3],
			IsPlayerConnected(GetPlayerID(name)) ? "{66CC33}Online" : "{FF5533}Offline",
			last_date[0], last_date[1], last_date[2],
			last_date[3], last_date[4], last_date[5]
		);

		strcat(list, query);
	}

	cache_delete(result);

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCD00}Список администрации", list, "Закрыть", "");

	return 1;
}

CMD:admlist1(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;

	new query[115],
		Cache: result,
		rows,
		admin,
		day_prev,
		day_last,
		name[21],
		list[sizeof query * 25 + 60] = "Имя\t\t\tРанг\tВ игре вчера\tВ игре сегодня\tСтатус\n{FFFFFF}";

	mysql_format(mysql, query, sizeof query, "SELECT * FROM accounts WHERE admin > 0 ORDER BY admin DESC");
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);

	for(new i; i < rows; i ++)
	{
		new day_time[4];

		admin = cache_get_field_content_int(i, "admin");
		day_prev = cache_get_field_content_int(i, "game_for_day_prev");
		day_last = cache_get_field_content_int(i, "game_for_day");

		day_time[0] = ConvertUnixTime(day_prev, CONVERT_TIME_TO_HOURS);
		day_time[1] = ConvertUnixTime(day_prev, CONVERT_TIME_TO_MINUTES);

		day_time[2] = ConvertUnixTime(day_last, CONVERT_TIME_TO_HOURS);
		day_time[3] = ConvertUnixTime(day_last, CONVERT_TIME_TO_MINUTES);

		cache_get_field_content(i, "name", name);

		new fix_tabulation[21] = "                    ";

		format
		(
			query, sizeof query,
			"\n{FFFFFF}%s%s\t%d ур.\t%s%d ч %d мин\t%s%d ч %d мин\t\t%s",
			name,
			fix_tabulation[strlen(name)],
			admin,
			(day_time[0] >= 3) ? ((day_time[0] > 3) ? ("{66CC33}") : ("")) : ("{FF5533}"),
			day_time[0],
			day_time[1],
			(day_time[2] >= 3) ? ((day_time[2] > 3) ? ("{66CC33}") : ("")) : ("{FF5533}"),
			day_time[2],
			day_time[3],
			IsPlayerConnected(GetPlayerID(name)) ? "{66CC33}Online" : "{FF5533}Offline"
		);

		strcat(list, query);
	}

	cache_delete(result);

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Список администрации", list, "Закрыть", "");

	return 1;
}

