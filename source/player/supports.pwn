

#define TABLE_SUPPORTS      "s_supports"    

enum E_SUPPORTS_PLAYER {
    sReport,
    sTempReport,
    sOnline,
    bool: sDuty
};
new SupportInfo[MAX_PLAYERS][E_SUPPORTS_PLAYER];

new defaultSupportInfo[E_SUPPORTS_PLAYER] = {
	0,// sReport,
    0, // sTempReport,
    0,//sOnline
    false// bool: sDuty
};
Support_OnPlayerDisconnect(playerid) {
    if (SupportInfo[playerid][sDuty]) {
        new 
            query_[128];
		mysql_format(dbHandle, query_, sizeof query_,
			"UPDATE "TABLE_SUPPORTS" SET sRep = %d, sOnline = %d WHERE sName = '%e' LIMIT 1", SupportInfo[playerid][sReport], SupportInfo[playerid][sOnline], pInfo[playerid][pName]);
 		mysql_tquery(dbHandle, query_, "", "");
        Iter_Remove(SupportsTeam, playerid);
        SupportInfo[playerid][sDuty] = false;
	} 
} 
stock GetPlayerSupportSearch(playerid)
{
	new 
        query_[84];
	format(query_, sizeof query_,"SELECT * FROM "TABLE_SUPPORTS" WHERE sName = '%s' LIMIT 1", pInfo[playerid][pName]);
	new Cache: result = mysql_query(dbHandle, query_); 
    new 
        value = cache_num_rows();
	if (cache_is_valid(result)) cache_delete(result);
	return value;
}

stock GetNameSupportSearch(const name_player[])
{
	new 
        query_[84];
	format(query_, sizeof query_,"SELECT * FROM "TABLE_SUPPORTS" WHERE sName = '%s' LIMIT 1", name_player);
	new Cache: result = mysql_query(dbHandle, query_); 
    new 
        value = cache_num_rows();
	if (cache_is_valid(result)) cache_delete(result);
	return value;
}
CMD:offsupport(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new giveplayerid = INVALID_PLAYER_ID, nickname[MAX_PLAYER_NAME];
	if (sscanf(params,"s[24]", nickname)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /offsupport [имя игрока]");
	sscanf(nickname,"u",giveplayerid);
	if (IsPlayerConnected(giveplayerid)) return SendMes(playerid, COLOR_ORANGE, "Игрок %s[%d] на сервере (( Используйте /setsupport ))", pInfo[giveplayerid][pName], giveplayerid);
    if (!GetNameSupportSearch(nickname)) {
        SendClientMessage(playerid, COLOR_GREY, !"[Ошибка] Данный саппорт не найден в базе!");
    } else {
        new
            query_[100];
        format(query_, sizeof query_, "DELETE FROM "TABLE_SUPPORTS" WHERE `sName`= '%s' LIMIT 1", nickname);
        mysql_tquery(dbHandle, query_, "", ""), query_[0] = EOS;    
        format(query_, sizeof query_, "Администратор: %s[%d] снял саппорт оффлайн: %s", pInfo[playerid][pName], playerid, nickname);
	    ABroadCast(COLOR_YELLOW, query_, 1);
    }
	return 1;
}
CMD:setsupport(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    new 
		targetid,
		param_sett;
    if (sscanf(params, "ud", targetid, param_sett)) return SendClientMessage(playerid, COLOR_GRAD2, !"Введите: /setsupport [playerid] [0 снять - 1 назначить]");
    if (param_sett > 1 || param_sett < 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы сделали ошибку");  
    if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
    if (param_sett == 0) {
        SupportInfo[targetid][sOnline]      =
        SupportInfo[targetid][sTempReport]  = 0;  
        SupportInfo[targetid][sDuty]        = false;
        SendClientMessage(targetid, COLOR_LIGHTBLUE, !"Вас сняли саппорта.");
        SendMes(playerid, COLOR_LIGHTBLUE,  "Вы сняли саппорта %s",pInfo[targetid][pName]);
    } else {
        SupportInfo[targetid][sOnline]      =
        SupportInfo[targetid][sTempReport]  = 0;  
        SupportInfo[targetid][sDuty]        = false;
        SendClientMessage(targetid, COLOR_LIGHTBLUE, !"Вас назначили саппортом.((Чтобы начать рабочий день /sduty)) (( /shelp - команды для саппортов ))");
        SendMes(playerid, COLOR_LIGHTBLUE,  "Вы назначили саппорта %s",pInfo[targetid][pName]);
        new 
            query_[128];
        mysql_format(dbHandle, query_, sizeof query_, "INSERT INTO "TABLE_SUPPORTS" (`sName`) VALUES ('%s')", pInfo[targetid][pName]);
        mysql_tquery(dbHandle, query_);
    } 
	return 1;
}   
CMD:sduty(playerid) {
    if (pInfo[playerid][pAdmin] > 0 ) {
        if (SupportInfo[playerid][sDuty] == false) {
            SupportInfo[playerid][sDuty] = true;
            Iter_Add(SupportsTeam, playerid);
            SendClientMessage(playerid, COLOR_WHITE, !"Рабочий день начат");
        } else {
            Iter_Remove(SupportsTeam, playerid);
            SupportInfo[playerid][sDuty] = false;
            SendClientMessage(playerid, COLOR_WHITE, !"Рабочий день завершен"); 
        }
        return 1;
    }
    else {
        if (GetPlayerSupportSearch(playerid) == 0) return 1;  
        new 
            query_[128];
        if (!SupportInfo[playerid][sDuty]) {  
            mysql_format(dbHandle, query_, sizeof query_, "SELECT * FROM "TABLE_SUPPORTS" WHERE `sName` = '%s'", pInfo[playerid][pName]);
            mysql_tquery(dbHandle, query_, "SetLoadSupports", "i", playerid); 
        } else {
            Iter_Remove(SupportsTeam, playerid); 
            SupportInfo[playerid][sDuty] = false;
            SendClientMessage(playerid, COLOR_WHITE, !"Рабочий день завершен");  
            mysql_format(dbHandle, query_, sizeof query_, 
                "UPDATE "TABLE_SUPPORTS" SET sRep = %d, sOnline = %d WHERE sName = '%e' LIMIT 1", 
                SupportInfo[playerid][sReport], SupportInfo[playerid][sOnline], pInfo[playerid][pName]
            ); 
            mysql_tquery(dbHandle, query_, "", ""); 
        }
    }
    
	return 1;
}
publics: SetLoadSupports(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if (!rows) { 
		return 1;
	} 
	cache_get_value_int(0, "sRep", SupportInfo[playerid][sReport]);  
    cache_get_value_int(0, "sOnline", SupportInfo[playerid][sOnline]);  
	new 
        player_ip[16],
        query_[128];
    GetPlayerIp(playerid, player_ip, sizeof player_ip);
    mysql_format(dbHandle, query_, sizeof query_, "UPDATE "TABLE_SUPPORTS" SET sLastCon = NOW(), sLastIP = '%s' WHERE sName = '%d' LIMIT 1", 
        player_ip, pInfo[playerid][pName]
    );
    mysql_tquery(dbHandle, query_, "", ""); 
  
	SupportInfo[playerid][sDuty] = true;  
    Iter_Add(SupportsTeam, playerid);
    SendClientMessage(playerid, COLOR_WHITE, !"Рабочий день начат");
	return 1;
}
CMD:sc(playerid, params[])
{
    if (!SupportInfo[playerid][sDuty] && !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна эта команда");
    if (strlen(params[0]) >= 128) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "s[128]",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /sc [текст]");
    new 
        string_[180];
	format(string_, sizeof string_, "<SUPPORTS-CHAT> %s[%d]: %s", pInfo[playerid][pName], playerid, params[0]);
	SendHelperMessage(0xF4B800AA, string_);
	return 1;
}
CMD:supports(playerid)
{
	SendClientMessage(playerid, COLOR_YELLOW, !"Саппорты Online:");
	foreach(new i: SupportsTeam) {
		if (!IsPlayerConnected(i)) continue;
		if (!SupportInfo[i][sDuty]) continue;
		if (pTemp[i][PlayerAFK] > 2) {
			SendMes(playerid, COLOR_YELLOW2, "%s[ID: %d] [AFK: %s сек][Ответов: %d]",pInfo[i][pName],i, ConvertSeconds(pTemp[i][PlayerAFK]-2), SupportInfo[i][sTempReport]);
		} else {
			SendMes(playerid, COLOR_YELLOW2, "%s[ID: %d][Ответов: %d]",pInfo[i][pName], i, SupportInfo[i][sTempReport]);
		}
	}
    SendMes(playerid, COLOR_YELLOW, "Всего в сети: %d %s", Iter_Count(SupportsTeam), Declension_ReturnWord(Iter_Count(SupportsTeam), "саппорт", "саппорта", "саппортов"));
	return 1;
}
CMD:sstats(playerid, params[])
{
    if (pInfo[playerid][pAdmin] == 0 && !SupportInfo[playerid][sDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не администратор / Или не начали рабочий день");
    new string_[256];
    if (sscanf(params, "u",params[0]))
	{
    	if (SupportInfo[playerid][sDuty]) {
			format(string_, sizeof string_, "Имя:  %s\nКоличество ответов за сессию:  %d\nКоличество ответов за все время:  %d\nОтыгранно за сессию: %s", 
                pInfo[playerid][pName], SupportInfo[playerid][sTempReport], SupportInfo[playerid][sReport], Convert(SupportInfo[playerid][sOnline])
            );
			ShowPlayerDialog(playerid, D_NULL, 0, ""colserver"Статистика: "colwhi"Саппорта", string_, "Закрыть", "");
		}
		else SendClientMessage(playerid, COLOR_WHITE, !"Введите: /sstats [ид]");
        return 1;
	}
    if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!SupportInfo[params[0]][sDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Саппорт не начал рабочий день!");
	format(string_, sizeof string_, "Имя:  %s\nКоличество ответов за сессию:  %d\nКоличество ответов за все время:  %d\nОтыгранно за сессию: %s", 
        pInfo[params[0]][pName], SupportInfo[params[0]][sTempReport], SupportInfo[params[0]][sReport], Convert(SupportInfo[params[0]][sOnline])
    );
	ShowPlayerDialog(playerid, D_NULL, 0, ""colserver"Статистика: "colwhi"Саппорта", string_, "Закрыть", "");
	return 1;
}
CMD:shelp(playerid)
{
    if (!SupportInfo[playerid][sDuty]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не саппорт");
    else{
        SendClientMessage(playerid, COLOR_WHITE, !"<SUPPORTS> /sduty - Начать работу саппорта");
        SendClientMessage(playerid, COLOR_WHITE, !"<SUPPORTS> /sstats - Статистика саппорта");
        SendClientMessage(playerid, COLOR_WHITE, !"<SUPPORTS> /sc - Чат саппортов");
        return SendClientMessage(playerid, COLOR_WHITE, !"<SUPPORTS> /supports - саппорты онлайн");
    }
} 

stock SendHelperMessage(color, const str[]) {
    foreach(new i: SupportsTeam) { 
       if ((!SupportInfo[i][sDuty] && !pTemp[i][PlayerADostup]) || !SupportInfo[i][sDuty]) continue;
       SendClientMessage(i, color, str);
    }
    return 1;
}

stock GameTextForSupport(const string[]) {
    foreach(new i: SupportsTeam) {
		if (!pInfo[i][pLogin]) continue;
		if (pTemp[i][tAdminInfoReport]) {
			GameTextForPlayer(i, string, 2000, 1);
		}
    }
    return 1; 
}