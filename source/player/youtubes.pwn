

#define TABLE_YOUTUBES      "s_youtube"    

enum E_YOUTUBES_PLAYER {
    sReport,
    bool: yDuty
};
new YoutubeInfo[MAX_PLAYERS][E_YOUTUBES_PLAYER];

new defaultYoutubeInfo[E_YOUTUBES_PLAYER] = {
	0,// sReport,
    false// bool: yDuty
};
stock GetPlayerYoutubeSearch(playerid)
{
	new 
        query_[84];
	format(query_, sizeof query_,"SELECT * FROM "TABLE_YOUTUBES" WHERE sName = '%s' LIMIT 1", pInfo[playerid][pName]);
	new Cache: result = mysql_query(dbHandle, query_); 
    new 
        value = cache_num_rows();
	if (cache_is_valid(result)) cache_delete(result);
	return value;
}

stock GetNameYoutubeSearch(const name_player[])
{
	new 
        query_[84];
	format(query_, sizeof query_,"SELECT * FROM "TABLE_YOUTUBES" WHERE sName = '%s' LIMIT 1", name_player);
	new Cache: result = mysql_query(dbHandle, query_); 
    new 
        value = cache_num_rows();
	if (cache_is_valid(result)) cache_delete(result);
	return value;
}
CMD:yduty(playerid) {
    if (GetPlayerYoutubeSearch(playerid) == 0) return 1;  
    new query_[128];
    if (!YoutubeInfo[playerid][yDuty]) {  
        mysql_format(dbHandle, query_, sizeof query_, "SELECT * FROM "TABLE_YOUTUBES" WHERE `sName` = '%s'", pInfo[playerid][pName]);
        mysql_tquery(dbHandle, query_, "SetLoadYoutubes", "i", playerid); 
    } else {
        Iter_Remove(YoutubesTeam, playerid); 
        YoutubeInfo[playerid][yDuty] = false;
        SendClientMessage(playerid, COLOR_WHITE, !"Рабочий день завершен"); 
 	   new str_[100];
		format(str_, sizeof str_, "[A] Ютубер %s завершил рабочий день.", pInfo[playerid][pName]);
		SendAdminMessage(COLOR_GREY, str_); 		 
     }
    return 1;   
}

publics: SetLoadYoutubes(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if (!rows) { 
		return 1;
	} 
	new player_ip[16];
    GetPlayerIp(playerid, player_ip, sizeof player_ip);
  
	YoutubeInfo[playerid][yDuty] = true;  
    Iter_Add(YoutubesTeam, playerid);
    SendClientMessage(playerid, COLOR_WHITE, !"Рабочий день начат");
    new str_[100];
	format(str_, sizeof str_, "[A] Ютубер %s начал рабочий день.", pInfo[playerid][pName]);
	SendAdminMessage(COLOR_GREY, str_); 	
	return 1;
}
CMD:yc(playerid, params[])
{
    if (!YoutubeInfo[playerid][yDuty] && !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна эта команда");
    if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /yc [текст]");
    new 
        string_[180];
	format(string_, sizeof string_, "<YOUTUBES-CHAT> %s[%d]: %s", pInfo[playerid][pName], playerid, params[0]);
	SendYoutubeMessage(0xF4B800AA, string_);
	return 1;
}
CMD:youtubes(playerid)
{
	SendClientMessage(playerid, COLOR_YELLOW, !"Ютуберы Online:");
	foreach(new i: YoutubesTeam) {
		if (!IsPlayerConnected(i)) continue;
		if (!YoutubeInfo[i][yDuty]) continue;
		if (pTemp[i][PlayerAFK] > 2) {
			SendMes(playerid, COLOR_YELLOW2, "%s[ID: %d] [AFK: %s сек]",pInfo[i][pName],i, ConvertSeconds(pTemp[i][PlayerAFK]-2));
		} else {
			SendMes(playerid, COLOR_YELLOW2, "%s[ID: %d]",pInfo[i][pName], i);
		}
	}
    SendMes(playerid, COLOR_YELLOW, "Всего в сети: %d %s", Iter_Count(YoutubesTeam), Declension_ReturnWord(Iter_Count(YoutubesTeam), "ютубер", "ютубера", "ютуберов"));
	return 1;
}
CMD:yhelp(playerid)
{
    if (!YoutubeInfo[playerid][yDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не ютубер");
    else{
        t_string[0] = EOS;
        strcat(t_string, ""collime"/yduty - "colwhi"Начать рабочий день\n");
        strcat(t_string, ""collime"/yc - "colwhi"Чат менеджеров\n");
        strcat(t_string, ""collime"/youtubes - "colwhi"Ютуберы онлайн\n");
        //strcat(t_string, ""collime"/ymp(yevent) - "colwhi"Меню мероприятия\n");   
        strcat(t_string, ""collime"/ytp - "colwhi"Меню телепорта\n"); 
        //strcat(t_string, ""collime"/yplveh - "colwhi"Создать машину\n");                    
        ShowPlayerDialog(playerid, D_NULL, 0, ""colserver"Команды ютубера", t_string, "Назад", "");        
        return 1;
    }
} 

CMD:ytp(playerid)
{
	if (!YoutubeInfo[playerid][yDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не ютубер");
	ShowPlayerDialog(playerid, D_ADMIN_FUNC_7, 2, ""colserver"Телепорт меню",
		"[0] Работы Новичков\n\
		[1] Гос. Работы\n\
		[2] Организации\n\
		[3] Развлекательные места\n\
		[4] Точки в городах\n\
		[5] Людные места\n\
		[6] Админ места\n\
		[7] Нелегальные организации\n\
		[8]	Mafia War",

		"Выбрать", "Отмена"
	);
	return 1;
}

/*alias:ymp("yevent");
CMD:ymp(playerid)
{
	if (!YoutubeInfo[playerid][yDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не ютубер");
	t_string[0] = EOS;
	if (gEventSetting[eLaunched]) {
		new 
			string_[145];
		format(string_, sizeof string_, "Мероприятие создано: Создатель %s | Название: %s", gEventSetting[eOwner], gEventSetting[eName]);
		SendClientMessage(playerid, COLOR_WHITE, string_);
	}
	format(t_string, sizeof t_string, 
		"[0] Создать мероприятие (с 3 уровня)\n\
		[1] Раздать оружие в районе 50 метров (с 4 уровня)\n\
		[2] Раздать жизни (с 1 уровня)\n\
		[3] Забрать оружие у всех в районе 50 метров (с 1 уровня)\n\
		[4] Раздать красный цвет ника в районе 10 метров\n\
		[5] Раздать зеленый цвет ника в районе 10 метров\n\
		[6] Заморозить в районе 10 метров\n\
		[7] Разморозить в районе 15 метров\n\
		[8] %s телепорт\n\
		[9] Завершить МП и отправить на ReSpawn\n\
		[10] Завершить МП без ReSpawna", (gEventSetting[eTeleport]) ? (""colwarn"Закрыть"colwhi"") : (""collime"Открыть"colwhi"")
	);
	ShowPlayerDialog(playerid, D_ADMIN_FUNC_24, DIALOG_STYLE_LIST,""colserver"Панель управления мероприятиями", t_string, "Выбрать", "Отмена"), t_string[0] = EOS;
	return 1;
}*/

stock SendYoutubeMessage(color, const str[]) {
    foreach(new i: YoutubesTeam) { 
       if ((!YoutubeInfo[i][yDuty] && !pTemp[i][PlayerADostup]) || !YoutubeInfo[i][yDuty]) continue;
       SendClientMessage(i, color, str);
    }
    return 1;
}