

#define TABLE_MANAGERS      "s_manager"    

enum E_MANAGERS_PLAYER {
    mLvl,
    bool: mDuty
};
new ManagerInfo[MAX_PLAYERS][E_MANAGERS_PLAYER];

new defaultManagerInfo[E_MANAGERS_PLAYER] = {
	0,// mLvl,
    false// bool: mDuty
};
stock GetPlayerManagerSearch(playerid)
{
	new 
        query_[84];
	format(query_, sizeof query_,"SELECT * FROM "TABLE_MANAGERS" WHERE mName = '%s' LIMIT 1", pInfo[playerid][pName]);
	new Cache: result = mysql_query(dbHandle, query_); 
    new 
        value = cache_num_rows();
	if (cache_is_valid(result)) cache_delete(result);
	return value;
}

stock GetNameManagerSearch(const name_player[])
{
	new 
        query_[84];
	format(query_, sizeof query_,"SELECT * FROM "TABLE_MANAGERS" WHERE mName = '%s' LIMIT 1", name_player);
	new Cache: result = mysql_query(dbHandle, query_); 
    new 
        value = cache_num_rows();
	if (cache_is_valid(result)) cache_delete(result);
	return value;
}
CMD:offmanager(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new giveplayerid = INVALID_PLAYER_ID, nickname[MAX_PLAYER_NAME];
	if (sscanf(params,"s[24]", nickname)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /offmanager [имя игрока]");
	sscanf(nickname,"u",giveplayerid);
	if (IsPlayerConnected(giveplayerid)) return SendMes(playerid, COLOR_ORANGE, "Игрок %s[%d] на сервере (( Используйте /setmanager ))", pInfo[giveplayerid][pName], giveplayerid);
    if (!GetNameManagerSearch(nickname)) {
        SendClientMessage(playerid, COLOR_GREY, !"[Ошибка] Данный менеджер не найден в базе!");
    } else {
        new
            query_[100];
        format(query_, sizeof query_, "DELETE FROM "TABLE_MANAGERS" WHERE `mName`= '%s' LIMIT 1", nickname);
        mysql_tquery(dbHandle, query_, "", ""), query_[0] = EOS;    
        format(query_, sizeof query_, "Администратор: %s[%d] снял менеджера оффлайн: %s", pInfo[playerid][pName], playerid, nickname);
	    ABroadCast(COLOR_YELLOW, query_, 1);
    }
	return 1;
}
CMD:setmanager(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new 
		targetid,
        query_[128],
		param_sett;
    if (sscanf(params, "ud", targetid, param_sett)) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /setmanager [playerid] [0 снять - 1 назначить]");
    if (param_sett > 1 || param_sett < 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы сделали ошибку");  
    if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
    if (param_sett == 0) {
        ManagerInfo[targetid][mDuty]        = false;	
        SendClientMessage(targetid, COLOR_LIGHTBLUE, !"Вас сняли с менеджера.");	
        format(query_, sizeof query_, "DELETE FROM "TABLE_MANAGERS" WHERE `mName`= '%s' LIMIT 1", pInfo[playerid][pName]);
        mysql_tquery(dbHandle, query_, "", ""), query_[0] = EOS;  		
        SendMes(playerid, COLOR_LIGHTBLUE,  "Вы сняли менеджера %s",pInfo[targetid][pName]);
    } else {
        ManagerInfo[targetid][mDuty]        = false;
        SendClientMessage(targetid, COLOR_LIGHTBLUE, !"Вас назначили менеджером. (( Чтобы начать рабочий день /mduty, /mhelp - команды для менеджеров ))");
        SendMes(playerid, COLOR_LIGHTBLUE,  "Вы назначили менеджера %s",pInfo[targetid][pName]);
        mysql_format(dbHandle, query_, sizeof query_, "INSERT INTO "TABLE_MANAGERS" (`mName`) VALUES ('%s')", pInfo[targetid][pName]);
        mysql_tquery(dbHandle, query_);
    } 
	return 1;
}   

CMD:createfamily(playerid, params[])
{
    if (!ManagerInfo[playerid][mDuty]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /createfamily [playerid]");
	if (pInfo[params[0]][pFamily] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок уже состоит в семье");

	ShowPlayerDialog(params[0], D_FAMILY_FUNC_63, DIALOG_STYLE_INPUT, ""colwhi"Создание семьи", 
		""colwhi"Название семьи не может быть менее 4 символов или превышать 32 символа\n\nВведите название своей семьи:", 
		"Создать", "Назад"
	);

	return 1;
}

CMD:offyoutube(playerid, params[])
{
    if (!ManagerInfo[playerid][mDuty]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new giveplayerid = INVALID_PLAYER_ID, nickname[MAX_PLAYER_NAME];
	if (sscanf(params,"s[24]", nickname)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /offyoutube [имя игрока]");
	sscanf(nickname,"u",giveplayerid);
	if (IsPlayerConnected(giveplayerid)) return SendMes(playerid, COLOR_ORANGE, "Игрок %s[%d] на сервере (( Используйте /setyoutube ))", pInfo[giveplayerid][pName], giveplayerid);
    if (!GetNameYoutubeSearch(nickname)) {
        SendClientMessage(playerid, COLOR_GREY, !"[Ошибка] Данный ютубер не найден в базе!");
    } else {
        new
            query_[100];
        format(query_, sizeof query_, "DELETE FROM "TABLE_YOUTUBES" WHERE `mName`= '%s' LIMIT 1", nickname);
        mysql_tquery(dbHandle, query_, "", ""), query_[0] = EOS;    
        format(query_, sizeof query_, "Администратор: %s[%d] снял ютубера оффлайн: %s", pInfo[playerid][pName], playerid, nickname);
	    ABroadCast(COLOR_YELLOW, query_, 1);
    }
	return 1;
}

CMD:setyoutube(playerid, params[])
{
    if (!ManagerInfo[playerid][mDuty]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new 
		targetid,
        query_[128],
		param_sett;
    if (sscanf(params, "ud", targetid, param_sett)) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /setyoutube [playerid] [0 снять - 1 назначить]");
    if (param_sett > 1 || param_sett < 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы сделали ошибку");  
    if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
    if (param_sett == 0) {
        YoutubeInfo[targetid][yDuty]        = false;		
        format(query_, sizeof query_, "DELETE FROM "TABLE_YOUTUBES" WHERE `sName`= '%s' LIMIT 1", pInfo[playerid][pName]);
        mysql_tquery(dbHandle, query_, "", ""), query_[0] = EOS;  		
        SendClientMessage(targetid, COLOR_LIGHTBLUE, !"Вас сняли с ютубера.");
        SendMes(playerid, COLOR_LIGHTBLUE,  "Вы сняли ютубера %s",pInfo[targetid][pName]);
    } else {
        YoutubeInfo[targetid][yDuty]        = false;
        SendClientMessage(targetid, COLOR_LIGHTBLUE, !"Вас назначили ютубером.((Чтобы начать рабочий день /yduty)) (( /yhelp - команды для ютуберов ))");
        SendMes(playerid, COLOR_LIGHTBLUE,  "Вы назначили ютубера %s",pInfo[targetid][pName]);
        mysql_format(dbHandle, query_, sizeof query_, "INSERT INTO "TABLE_YOUTUBES" (`sName`) VALUES ('%s')", pInfo[targetid][pName]);
        mysql_tquery(dbHandle, query_);
    } 
	return 1;
}   

CMD:mgetstats(playerid, params[])
{
    if (!ManagerInfo[playerid][mDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна эта команда");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /mgetstats [playerid]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден! / Или Вы указали свой ID");
	ShowStats(playerid,params[0]);
	return 1;
}

CMD:mduty(playerid) {
    if (GetPlayerManagerSearch(playerid) == 0) return 1;  
    new query_[128];
    if (!ManagerInfo[playerid][mDuty]) {  
        mysql_format(dbHandle, query_, sizeof query_, "SELECT * FROM "TABLE_MANAGERS" WHERE `mName` = '%s'", pInfo[playerid][pName]);
        mysql_tquery(dbHandle, query_, "SetLoadManagers", "i", playerid); 
    } else {
        Iter_Remove(ManagersTeam, playerid); 
        ManagerInfo[playerid][mDuty] = false;		
        SendClientMessage(playerid, COLOR_WHITE, !"Рабочий день завершен");
        new str_[100];
    	format(str_, sizeof str_, "[A] Менеджер %s завершил рабочий день.", pInfo[playerid][pName]);
    	SendAdminMessage(COLOR_GREY, str_);          
     }
    return 1;   
}

publics: SetLoadManagers(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if (!rows) { 
		return 1;
	} 
	new player_ip[16];
    GetPlayerIp(playerid, player_ip, sizeof player_ip);
  
	ManagerInfo[playerid][mDuty] = true;  
    Iter_Add(ManagersTeam, playerid);
    SendClientMessage(playerid, COLOR_WHITE, !"Рабочий день начат");
    new str_[100];
	format(str_, sizeof str_, "[A] Менеджер %s начал рабочий день.", pInfo[playerid][pName]);
	SendAdminMessage(COLOR_GREY, str_); 
	return 1;
}
CMD:mc(playerid, params[])
{
    if (!ManagerInfo[playerid][mDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна эта команда");
    if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /mc [текст]");
    new 
        string_[180];
	format(string_, sizeof string_, "<MANAGERS-CHAT> %s[%d]: %s", pInfo[playerid][pName], playerid, params[0]);
	SendManagerMessage(0xF4B800AA, string_);
	return 1;
}
CMD:mdl(playerid)
{
	SendClientMessage(playerid, COLOR_YELLOW, !"Менеджеры Online:");
	foreach(new i: ManagersTeam) {
		if (!IsPlayerConnected(i)) continue;
		if (!ManagerInfo[i][mDuty]) continue;
		if (pTemp[i][PlayerAFK] > 2) {
			SendMes(playerid, COLOR_YELLOW2, "%s[ID: %d] [AFK: %s сек]",pInfo[i][pName],i, ConvertSeconds(pTemp[i][PlayerAFK]-2));
		} else {
			SendMes(playerid, COLOR_YELLOW2, "%s[ID: %d]",pInfo[i][pName], i);
		}
	}
    SendMes(playerid, COLOR_YELLOW, "Всего в сети: %d %s", Iter_Count(ManagersTeam), Declension_ReturnWord(Iter_Count(ManagersTeam), "менеджер", "менеджера", "менеджеров"));
	return 1;
}
CMD:agivepack(playerid, params[])
{
    if (!ManagerInfo[playerid][mDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не менеджер");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /agivepack [ид]");
	if (!IsPlayerConnected(params[0])) return 1;
	pInfo[params[0]][pDrugs] += 50000;
	SavePlayerInteger(params[0], "pDrugs", pInfo[params[0]][pDrugs]);
	pInfo[params[0]][pMats] += 50000;
	SavePlayerInteger(params[0], "pMats", pInfo[params[0]][pMats]);
	SendClientMessage(params[0], COLOR_WHITE, "Вам Выдано 50к - Нарко, 50к - Матов!");
	new str_[100];
	format(str_, sizeof str_, "[A] %s выдал 50к Матов и Нарко игроку %s", pInfo[playerid][pName], pInfo[params[0]][pName]);
	SendAdminMessage(COLOR_GREY, str_);    
	LogingAdmins(playerid, pInfo[params[0]][pName], "2 Give Pack", params[1], "/agivepack");
	return 1;
}
CMD:givepack(playerid, params[])
{
    if (!ManagerInfo[playerid][mDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не менеджер");
	if (sscanf(params, "u",params[0])) return	SendClientMessage(playerid, COLOR_WHITE, !"Введите: /givepack [ид]");
	if (!IsPlayerConnected(params[0])) return 1;
	if (pInfo[params[0]][pLevel] > 3) return SendClientMessage ( playerid, COLOR_WHITE, "{FF0000}[Подсказка] {FFFFFF}У игрока уже есть 3 lvl используйте /agivepack" ) ;
	pInfo[params[0]][pLevel] = 3;
	SetPlayerScore(params[0], pInfo[params[0]][pLevel]);
	SavePlayerInteger(params[0], "pLevel", pInfo[params[0]][pLevel]);
	
	GivePlayerLicense(playerid, DRIVE_LIC, 30);
	
	
	kLibGivePlayerMoney(params[0], 100000, "/givepack");
	
	pInfo[params[0]][pDrugs] += 50000;
	SavePlayerInteger(params[0], "pDrugs", pInfo[params[0]][pDrugs]);
	pInfo[params[0]][pMats] += 50000;
	SavePlayerInteger(params[0], "pMats", pInfo[params[0]][pMats]);

	pInfo[params[0]][pGunSkill][1] = 100;
	pInfo[params[0]][pGunSkill][2] = 100;
	pInfo[params[0]][pGunSkill][5] = 100; 
	SetPlayerSkills(params[0]);
	
	SendClientMessage(params[0], COLOR_WHITE, "Вам Выдан стартовый пакет!");
	new str_[100];
	format(str_, sizeof str_, "[A] %s выдал стартовый пакет игроку %s", pInfo[playerid][pName], pInfo[params[0]][pName]);
	SendAdminMessage(COLOR_GREY, str_);
	LogingAdmins(playerid, pInfo[params[0]][pName], "Give Pack", params[1], "/givepack");
	return 1;
} 
CMD:setpromo(playerid) 
{
    if (!ManagerInfo[playerid][mDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не менеджер");
    showPlayerDialogAdminPromo(playerid);
    return 1;
}
CMD:mhelp(playerid)
{
    if (!ManagerInfo[playerid][mDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не менеджер");
    else{
        t_string[0] = EOS;
        strcat(t_string, ""collime"/mduty - "colwhi"Начать рабочий день\n");
        strcat(t_string, ""collime"/mc - "colwhi"Чат менеджеров\n");
        strcat(t_string, ""collime"/givepack - "colwhi"Выдать стартовый пакет\n");
        strcat(t_string, ""collime"/agivepack - "colwhi"Выдать нарко и материалы\n");
        strcat(t_string, ""collime"/setpromo - "colwhi"Управление промокодами\n");
        strcat(t_string, ""collime"/mgetstats - "colwhi"Посмотреть статистику аккаунта\n");
        strcat(t_string, ""collime"/mdl - "colwhi"Менеджеры онлайн\n");
        ShowPlayerDialog(playerid, D_NULL, 0, ""colserver"Команды менеджера", t_string, "Назад", "");
        return 1;
    }
} 

stock SendManagerMessage(color, const str[]) {
    foreach(new i: ManagersTeam) { 
       if ((!ManagerInfo[i][mDuty] && !pTemp[i][PlayerADostup]) || !ManagerInfo[i][mDuty]) continue;
       SendClientMessage(i, color, str);
    }
    return 1;
}