/*Player_GetIDFromName(const name[]) {
    static playerid;
    sscanf(name, "r", playerid);
    return playerid;
}*/
/*
CREATE TABLE IF NOT EXISTS `s_online` (
  `id` int(11) NOT NULL,
  `accountid` int(11) NOT NULL,
  `date` date NOT NULL,
  `online_sec` int(11) NOT NULL DEFAULT '0',
  `afk_sec` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=cp1251;
*/

new gOnlinePlayer[MAX_PLAYERS][2],
	gOnlinePlayerAFK[MAX_PLAYERS][2];
OW_OnPlayerLogin(playerid) {
    LoadPlayerOnlineToday(playerid);
    LoadPlayerOnlineYesterday(playerid);
}  
OW_OnPlayerDisconnect(playerid) {
    new 
        query_[256];
    if (gOnlinePlayer[playerid][0] > 1) {
		format(query_, sizeof query_,"SELECT * FROM s_online WHERE date >= CURDATE() AND accountid = %d", pInfo[playerid][pID]);
		new 
            Cache:result = mysql_query(dbHandle, query_);
		if (!cache_num_rows()) {
			format(query_, sizeof query_, "INSERT INTO s_online (accountid,date,online_sec,afk_sec) VALUES (%d, CURDATE(), %d, %d)", 
                pInfo[playerid][pID], gOnlinePlayer[playerid][0], gOnlinePlayerAFK[playerid][0]
            );
			mysql_tquery(dbHandle, query_);
		}
		else {
			format(query_, sizeof query_,"UPDATE s_online SET online_sec = %d, afk_sec = %d WHERE accountid = %d AND date >= CURDATE()", 
                gOnlinePlayer[playerid][0], gOnlinePlayerAFK[playerid][0], pInfo[playerid][pID]
            );
			mysql_tquery(dbHandle, query_);
		}
        if (cache_is_valid(result)) cache_delete(result); 
	}
}  
stock LoadPlayerOnlineToday(playerid) {
    format(t_string, sizeof (t_string), "SELECT * FROM s_online WHERE date >= CURDATE() AND accountid = %d", pInfo[playerid][pID]);
	new Cache:tempQuery = mysql_query(dbHandle, t_string), rows;
	t_string[0] = EOS;

	cache_get_row_count(rows);
	if (!rows) {
        gOnlinePlayer[playerid][0] = 0;
		gOnlinePlayerAFK[playerid][0] = 0;
		if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
		return;
	}
	cache_get_value_name_int(0, "online_sec", gOnlinePlayer[playerid][0]);
	cache_get_value_name_int(0, "afk_sec", gOnlinePlayerAFK[playerid][0]);  
	if (cache_is_valid(tempQuery)) cache_delete(tempQuery); 
}
stock LoadPlayerOnlineYesterday(playerid) {
    format(t_string, sizeof (t_string), "SELECT * FROM s_online WHERE (date >= (CURDATE()-1) AND date < CURDATE()) AND accountid = %d", pInfo[playerid][pID]);
	new Cache:tempQuery = mysql_query(dbHandle, t_string), rows;
	t_string[0] = EOS;

	cache_get_row_count(rows);
	if (!rows) {
        gOnlinePlayer[playerid][1] = 0;
		gOnlinePlayerAFK[playerid][1] = 0;
		if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
		return;
	}
	cache_get_value_name_int(0, "online_sec", gOnlinePlayer[playerid][1]);
	cache_get_value_name_int(0, "afk_sec", gOnlinePlayerAFK[playerid][1]);  
	if (cache_is_valid(tempQuery)) cache_delete(tempQuery); 
}
CMD:getonline(playerid, const params[])  {
	if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params,"p< >s[24]",params)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /getonline [ник]"); 
	new 
        query_[250], 
        title_[96]; 
    t_string[0] = EOS;
	format(title_, sizeof title_, ""colserver"Результат онлайна: "colwhi"%s", params);
	format(t_string, sizeof t_string, ""colserver"Дата\t"colserver"Онлайн за день\t"colserver"АФК за день\n");
	format(t_string, sizeof t_string, "%s"colserver"Год-Месяц-Число\t"colserver"ЧЧ:ММ:СС\t"colserver"ЧЧ:ММ:СС\n", t_string);

	mysql_format(dbHandle, query_, sizeof query_, 
        "SELECT `date`, SEC_TO_TIME(`online_sec`-`afk_sec`) as online, SEC_TO_TIME(`afk_sec`) as afk FROM `s_online` WHERE `accountid` = (SELECT `pID` FROM `s_users` WHERE `Name` LIKE '%e') ORDER BY `id` DESC LIMIT 7",
        params
    );
	new Cache:result = mysql_query(dbHandle, query_), rows;
	cache_get_row_count(rows);
	if (!rows) {
        SendClientMessage(playerid, COLOR_GREY, !"Данный аккаунт не найден в базе данных!");
        if (cache_is_valid(result)) cache_delete(result);
        return 1;
    } 
    for(new i = 0, afk[16], b_date[15], online[15]; i < rows; i++) {
        cache_get_value_name(i, "date",b_date, sizeof b_date);
        cache_get_value_name(i, "online",online, sizeof online);
        cache_get_value_name(i, "afk",afk, sizeof afk);
        format(t_string, sizeof t_string, "%s"colwhi"%s\t"colwhi"%s\t"colwhi"%s\n", 
            t_string, b_date, online, afk
        );
    }
    ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST_HEADERS, title_, t_string, "Закрыть", ""); 
    if (cache_is_valid(result)) cache_delete(result);
	return 1;
}
CMD:gettime(playerid, params[]) {
	if (pInfo[playerid][pAdmin] < 2 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new 
        targetid;
	if (sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /gettime [ID]");
    if (!PlayerInConnected(targetid) /*|| playerid == params[0]*/) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден! / Вы указали свой ID");
	if (pInfo[targetid][pMuted] > 0) { 
		SendMes(playerid, COLOR_GREY, "Осталось молчать: "colmaline"%d секунд", pInfo[targetid][pMuted]);
	}
	if (pInfo[targetid][pJailTime] > 0) {
		SendMes(playerid, COLOR_GREY, "Осталось сидеть: "colmaline"%d секунд", pInfo[targetid][pJailTime]); 
	}
   // SendMes(playerid, COLOR_GREY, "До бесплатной рулетки осталось: "colmaline"%s", Convert(10800 - pTemp[targetid][gTimeNoAFK])); 
	gettime(hour, minute, second);
	getdate(year, month, day); 
	static const Names_Months[12][12] = {"января","февраля","марта","апреля","мая","июня","июля","августа","сентября","октября","ноября","декабря"};
    static const Names_Days[7][12] = {"суббота","воскресенье","понедельник","вторник","среда","четверг","пятница"};
    format(t_string, sizeof t_string, "\
		"colwhi"Текущее время: "colmaline"%02d:%02d\n\
		"colwhi"Сегодняшняя дата: "colmaline"%s, %d %s %04d г.\n\n\
		"colwhi"Время в игре за час:\t\t"collime"%s\n\
		"colwhi"Время в игре за сегодня:\t"colmaline"%s\n\
		"colwhi"Время в игре за вчера:\t"colmaline"%s\n\n\
		"colwhi"AFK за сегодня:\t\t"C_PODS"%s\n\
		"colwhi"AFK за вчера:\t\t\t"C_PODS"%s",
		hour, minute,
		Names_Days[getDay()], day, Names_Months[month-1], year,
		Convert(pTemp[targetid][tTimeInHour]),
		ConvertsCmdTime(gOnlinePlayer[targetid][0]),
		ConvertsCmdTime(gOnlinePlayer[targetid][1]),
		ConvertsCmdTime(gOnlinePlayerAFK[targetid][0]),
		ConvertsCmdTime(gOnlinePlayerAFK[targetid][1])
    ); 
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, ""colserver"Запрос онлайна", t_string, "Закрыть", ""), t_string[0] = EOS;
	return 1;
}
CMD:timestats(playerid, params[]) {  
	if (pInfo[playerid][pMuted] > 0) { 
		SendMes(playerid, COLOR_GREY, "Осталось молчать: "colmaline"%d секунд", pInfo[playerid][pMuted]);
	}
	if (pInfo[playerid][pJailTime] > 0) {
		SendMes(playerid, COLOR_GREY, "Осталось сидеть: "colmaline"%d секунд", pInfo[playerid][pJailTime]); 
	}
	if (pInfo[playerid][FractionMute] > 0) {
		SendMes(playerid, COLOR_GREY, "Осталось молчать в фракционном чате: "colmaline"%d секунд", pInfo[playerid][FractionMute]);
	}
   	SendMes(playerid, COLOR_GREY, "До бесплатной рулетки осталось: "colmaline"%s", Convert(10800 - pTemp[playerid][gTimeNoAFK])); 
	gettime(hour, minute, second);
	getdate(year, month, day); 
	static const Names_Months[12][12] = {"января","февраля","марта","апреля","мая","июня","июля","августа","сентября","октября","ноября","декабря"};
    static const Names_Days[7][12] = {"суббота","воскресенье","понедельник","вторник","среда","четверг","пятница"};
    format(t_string, sizeof t_string, "\
		"colwhi"Текущее время: "colmaline"%02d:%02d\n\
		"colwhi"Сегодняшняя дата: "colmaline"%s, %d %s %04d г.\n\n\
		"colwhi"Время в игре за час:\t\t"collime"%s\n\
		"colwhi"Время в игре за сегодня:\t"colmaline"%s\n\
		"colwhi"Время в игре за вчера:\t"colmaline"%s\n\n\
		"colwhi"AFK за сегодня:\t\t"C_PODS"%s\n\
		"colwhi"AFK за вчера:\t\t\t"C_PODS"%s",
		hour, minute,
		Names_Days[getDay()], day, Names_Months[month-1], year,
		Convert(pTemp[playerid][tTimeInHour]),
		ConvertsCmdTime(gOnlinePlayer[playerid][0]),
		ConvertsCmdTime(gOnlinePlayer[playerid][1]),
		ConvertsCmdTime(gOnlinePlayerAFK[playerid][0]),
		ConvertsCmdTime(gOnlinePlayerAFK[playerid][1])
    ); 
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, ""colserver"Статистика: "colwhi"Онлайна", t_string, "Закрыть", ""), t_string[0] = EOS;
	return 1;
}