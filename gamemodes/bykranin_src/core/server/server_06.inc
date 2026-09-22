//>> Файл: bykranin_src/core/server/server_06.inc  (687 строк)
//>> Тема: инфраструктура: таймеры, сохранение, MySQL, утилиты
//>> Внутри: SpectateGUI_GetPunishAdminLevel, SpectateGUI_SendPunishTemplates, SpectateGUI_ShowControlPanel, SpectateGUI_ShowCategories, SpectateGUI_ApplyPunish, /ans, report_Send
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock SpectateGUI_GetPunishAdminLevel(category)
{
    switch(category)
    {
        case 3, 4, 5, 7: return 1; // kick, mute, jail, slap
        case 6: return 2;          // warn
        case 8: return 3;          // donor ban level
    }
    return 99;
}

stock SpectateGUI_SendPunishTemplates(playerid, category)
{
    new required_level = SpectateGUI_GetPunishAdminLevel(category);
    if(!SRAdmin_Require(playerid, required_level))
        return ShowNotificationNew(playerid, 2, 3, 0, 0, "Недостаточно прав для этого наказания", "");

    new JSON:response = JSON_Object();
    JSON_SetInt(response, "t", 2);

    switch(category)
    {
        case 3:
        {
            JSON_SetString(response, "bn", "Кик");
            JSON_SetInt(response, "tf", 0);
            new JSON:item1 = JSON_Object("bi", JSON_Int(1), "bn", JSON_String("AFK без ESC"), "be", JSON_String("AFK без ESC"));
            new JSON:item2 = JSON_Object("bi", JSON_Int(2), "bn", JSON_String("Помеха"), "be", JSON_String("Помеха игровому процессу"));
            new JSON:item3 = JSON_Object("bi", JSON_Int(3), "bn", JSON_String("Баг"), "be", JSON_String("Использование бага"));
            JSON_SetArray(response, "bt", JSON_Array(item1, item2, item3));
        }
        case 4:
        {
            JSON_SetString(response, "bn", "Мут");
            JSON_SetInt(response, "tf", 1);
            new JSON:item1 = JSON_Object("bi", JSON_Int(4), "bn", JSON_String("Оскорбление"), "be", JSON_String("Оскорбление игроков"), "br", JSON_Int(30));
            new JSON:item2 = JSON_Object("bi", JSON_Int(5), "bn", JSON_String("Упоминание родни"), "be", JSON_String("Упоминание родни"), "br", JSON_Int(90));
            new JSON:item3 = JSON_Object("bi", JSON_Int(6), "bn", JSON_String("Неуважение к администрации"), "be", JSON_String("Неуважение к администрации"), "br", JSON_Int(90));
            new JSON:item4 = JSON_Object("bi", JSON_Int(7), "bn", JSON_String("CAPS"), "be", JSON_String("Капс в чате"), "br", JSON_Int(30));
            JSON_SetArray(response, "bt", JSON_Array(item1, item2, item3, item4));
        }
        case 5:
        {
            JSON_SetString(response, "bn", "Тюрьма");
            JSON_SetInt(response, "tf", 1);
            new JSON:item1 = JSON_Object("bi", JSON_Int(8), "bn", JSON_String("DM"), "be", JSON_String("Убийство без причины"), "br", JSON_Int(60));
            new JSON:item2 = JSON_Object("bi", JSON_Int(9), "bn", JSON_String("DB"), "be", JSON_String("Убийство транспортом"), "br", JSON_Int(30));
            new JSON:item3 = JSON_Object("bi", JSON_Int(10), "bn", JSON_String("TK"), "be", JSON_String("Убийство союзника"), "br", JSON_Int(60));
            new JSON:item4 = JSON_Object("bi", JSON_Int(11), "bn", JSON_String("Провокация ГОС"), "be", JSON_String("Провокация гос. организаций"), "br", JSON_Int(30));
            JSON_SetArray(response, "bt", JSON_Array(item1, item2, item3, item4));
        }
        case 6:
        {
            JSON_SetString(response, "bn", "Предупреждение");
            JSON_SetInt(response, "tf", 0);
            new JSON:item1 = JSON_Object("bi", JSON_Int(12), "bn", JSON_String("NonRP COP"), "be", JSON_String("Нарушение RP за сотрудника"));
            new JSON:item2 = JSON_Object("bi", JSON_Int(13), "bn", JSON_String("NonRP В/Ч"), "be", JSON_String("Нарушение RP в армии"));
            new JSON:item3 = JSON_Object("bi", JSON_Int(14), "bn", JSON_String("Уход от RP"), "be", JSON_String("Уход от RP процесса"));
            new JSON:item4 = JSON_Object("bi", JSON_Int(15), "bn", JSON_String("Снятие лидера"), "be", JSON_String("Снятие с лидерского поста"));
            JSON_SetArray(response, "bt", JSON_Array(item1, item2, item3, item4));
        }
        case 7:
        {
            JSON_SetString(response, "bn", "Slap");
            JSON_SetInt(response, "tf", 0);
            new JSON:item1 = JSON_Object("bi", JSON_Int(16), "bn", JSON_String("Подбросить вверх"), "be", JSON_String("Поднять игрока на 5 метров"));
            new JSON:item2 = JSON_Object("bi", JSON_Int(17), "bn", JSON_String("Опустить вниз"), "be", JSON_String("Опустить игрока на 5 метров"));
            JSON_SetArray(response, "bt", JSON_Array(item1, item2));
        }
        case 8:
        {
            JSON_SetString(response, "bn", "Бан");
            JSON_SetInt(response, "tf", 1);
            new maximum_days = SRAdmin_Level(playerid) > 4 ? 90 : 30;
            new JSON:item1 = JSON_Object("bi", JSON_Int(18), "bn", JSON_String("Mass DM"), "be", JSON_String("Массовое убийство"), "br", JSON_Int(7));
            new JSON:item2 = JSON_Object("bi", JSON_Int(19), "bn", JSON_String("ППВ"), "be", JSON_String("Передача или продажа аккаунта"), "br", JSON_Int(30));
            new JSON:item3 = JSON_Object("bi", JSON_Int(20), "bn", JSON_String("Оскорбление родни"), "be", JSON_String("Оскорбление родных"), "br", JSON_Int(15));
            new JSON:item4 = JSON_Object("bi", JSON_Int(21), "bn", JSON_String("Читы"), "be", JSON_String("Использование читов"), "br", JSON_Int(maximum_days));
            JSON_SetArray(response, "bt", JSON_Array(item1, item2, item3, item4));
        }
        default:
        {
            JSON_Cleanup(response);
            return 0;
        }
    }

    OnPacketIncoming(playerid, 66, response);
    JSON_Cleanup(response);
    return 1;
}

stock SpectateGUI_ShowControlPanel(playerid)
{
    if(GetPlayerAdminEx(playerid) < 1 || !GetPlayerData(playerid, P_ADMIN_LOGGED)) return 0;

    new JSON:response = JSON_Object();
    JSON_SetInt(response, "t", 6);
    new JSON:item = JSON_Object("bi", JSON_Int(7), "bn", JSON_String("Категории наказаний"), "be", JSON_String("Выбрать действие над игроком"));
    JSON_SetArray(response, "bt", JSON_Array(item));
    OnPacketIncoming(playerid, 66, response);
    JSON_Cleanup(response);
    return 1;
}

stock SpectateGUI_ShowCategories(playerid)
{
    if(GetPlayerAdminEx(playerid) < 1 || !GetPlayerData(playerid, P_ADMIN_LOGGED)) return 0;

    new JSON:response = JSON_Object();
    JSON_SetInt(response, "t", 7);
    new JSON:item1 = JSON_Object("bi", JSON_Int(3), "bn", JSON_String("Кик"), "be", JSON_String("Категория"));
    new JSON:item2 = JSON_Object("bi", JSON_Int(4), "bn", JSON_String("Мут"), "be", JSON_String("Категория"));
    new JSON:item3 = JSON_Object("bi", JSON_Int(5), "bn", JSON_String("Тюрьма"), "be", JSON_String("Категория"));
    new JSON:item4 = JSON_Object("bi", JSON_Int(6), "bn", JSON_String("Предупреждение"), "be", JSON_String("Категория"));
    new JSON:item5 = JSON_Object("bi", JSON_Int(7), "bn", JSON_String("Slap"), "be", JSON_String("Категория"));
    new JSON:item6 = JSON_Object("bi", JSON_Int(8), "bn", JSON_String("Бан"), "be", JSON_String("Категория"));
    JSON_SetArray(response, "bt", JSON_Array(item1, item2, item3, item4, item5, item6));
    OnPacketIncoming(playerid, 66, response);
    JSON_Cleanup(response);
    return 1;
}

stock SpectateGUI_ApplyPunish(playerid, targetid, template_id)
{
    if(!SRAdmin_Target(playerid, targetid, 1)) return 0;
    if(GetPlayerSpectateData(playerid, S_PLAYER) != targetid) return 0;
    if(GetPVarInt(playerid, "SRSpecTargetSession") != SRAdmin_Session(targetid)) return 0;

    new params[160];
    switch(template_id)
    {
        case 1: format(params, sizeof params, "%d AFK без ESC", targetid), callcmd::kick(playerid, params);
        case 2: format(params, sizeof params, "%d Помеха", targetid), callcmd::kick(playerid, params);
        case 3: format(params, sizeof params, "%d Использование бага", targetid), callcmd::kick(playerid, params);
        case 4: format(params, sizeof params, "%d 30 Оскорбление игроков", targetid), callcmd::mute(playerid, params);
        case 5: format(params, sizeof params, "%d 90 Упоминание родни", targetid), callcmd::mute(playerid, params);
        case 6: format(params, sizeof params, "%d 90 Неуважение к администрации", targetid), callcmd::mute(playerid, params);
        case 7: format(params, sizeof params, "%d 30 CAPS", targetid), callcmd::mute(playerid, params);
        case 8: format(params, sizeof params, "%d 60 DM", targetid), callcmd::jail(playerid, params);
        case 9: format(params, sizeof params, "%d 30 DB", targetid), callcmd::jail(playerid, params);
        case 10: format(params, sizeof params, "%d 60 TK", targetid), callcmd::jail(playerid, params);
        case 11: format(params, sizeof params, "%d 30 Провокация ГОС", targetid), callcmd::jail(playerid, params);
        case 12: format(params, sizeof params, "%d NonRP COP", targetid), callcmd::warn(playerid, params);
        case 13: format(params, sizeof params, "%d NonRP В/Ч", targetid), callcmd::warn(playerid, params);
        case 14: format(params, sizeof params, "%d Уход от RP", targetid), callcmd::warn(playerid, params);
        case 15: format(params, sizeof params, "%d Снятие лидера", targetid), callcmd::warn(playerid, params);
        case 16: format(params, sizeof params, "%d 0 GUI /sp", targetid), callcmd::slap(playerid, params);
        case 17: format(params, sizeof params, "%d 1 GUI /sp", targetid), callcmd::slap(playerid, params);
        case 18: format(params, sizeof params, "%d 7 Массовое убийство", targetid), callcmd::ban(playerid, params);
        case 19: format(params, sizeof params, "%d 30 ППВ", targetid), callcmd::ban(playerid, params);
        case 20: format(params, sizeof params, "%d 15 Оскорбление родных", targetid), callcmd::ban(playerid, params);
        case 21: format(params, sizeof params, "%d %d Использование читов", targetid, SRAdmin_Level(playerid) > 4 ? 90 : 30), callcmd::ban(playerid, params);
        default: return 0;
    }
    return 1;
}

CMD:ans(playerid, params[])
{
    #pragma unused params
    if(!ReportGUI_IsAdminAuthorized(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Команда доступна только авторизованной администрации.");
    if(GetPVarInt(playerid, "REPORT_GUI_ACTIVE"))
        return SendClientMessage(playerid, 0xCECECEFF, "Сначала закройте или обработайте текущую жалобу.");

    new targetid, report_text[REPORT_GUI_TEXT_MAX];
    if(!ReportGUI_Dequeue(targetid, report_text, sizeof report_text))
        return SendClientMessage(playerid, 0xCECECEFF, "Очередь жалоб пуста.");

    return ReportGUI_Show(playerid, targetid, report_text);
}

// Старая конфликтующая SQL/диалоговая система репортов отключена.
#if 0
stock report_Send(playerid, const text[])
{
	mysql_query_[0] = EOS;

    new report_id, Cache:insert_result;
	mysql_format(mysql, mysql_query_, sizeof (mysql_query_), "INSERT INTO `"TABLE_REPORTS"` \
		(player_name, player_id, text, date) VALUES ('%e', %d, '%e',NOW())", GetPlayerData(playerid,P_NAME), playerid, text
	);

	insert_result = mysql_query(mysql, mysql_query_);

	mysql_query_[0] = EOS;
	report_id = cache_insert_id();

	cache_delete(insert_result);

	new Cache:result = mysql_query(mysql, "SELECT id FROM `"TABLE_REPORTS"` WHERE status=0 AND admin=0"), rows;
	rows = cache_num_rows(result);

	format(stringer1, sizeof (stringer1), "{afafaf}Ваш запрос №%d успешно отправлен администрации. Вы на %d месте в очереди!",
		report_id, rows
	);
	SendClientMessage(playerid, COLOR_WHITE, stringer1), stringer1[0] = EOS;

	cache_delete(result);

	format(stringer1, sizeof (stringer1), ""c_server"[ANS] %s[%d]: %s (%d в очереди) {FFFFFF}[/reps %d]",GetPlayerData(playerid,P_NAME), playerid, text, rows, report_id);
	
	SendMessageToAdmins(stringer1, COLOR_WHITE)/*, stringer1[0] = EOS*/;

	return true;
}

stock report_Show(playerid) {
	new
		Cache:result, report_id, report_playerid, report_player_name[MAX_PLAYER_NAME + 1], report_date[20], report_text[144];

	result = mysql_query(mysql, "SELECT * FROM "TABLE_REPORTS" WHERE status="#REPORT_STATUS_NONE" AND admin=0 LIMIT 1");

	mysql_query_[0] = EOS;

	new rows = cache_num_rows(result);

	if (!rows) {
		cache_delete(result);
		SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}В очереди нет запросов от игроков!");
		return true;
	}
	report_id = cache_get_field_content_int(0, "id");
	report_playerid = cache_get_field_content_int(0, "player_id");

	cache_get_field_content(0, "player_name", report_player_name, mysql, sizeof(report_player_name));

	cache_get_field_content(0, "text", report_text, mysql, sizeof (report_text));
	cache_get_field_content(0, "date", report_date, mysql, sizeof (report_date));

	mysql_format(mysql, mysql_query_, sizeof (mysql_query_), "SELECT * FROM "TABLE_REPORTS" WHERE \
		status>"#REPORT_STATUS_NONE" AND player_name='%e' ORDER BY id DESC LIMIT 3", report_player_name
	);
	mysql_tquery(mysql, mysql_query_, "report_ShowDialog", "ddsdss", playerid, report_id, report_player_name, report_playerid, report_text, report_date);

	cache_delete(result);
	return true;
}
public: report_ShowDialog(playerid, report_id, const report_player_name[], report_playerid, const report_text[], const report_date[]) {
	new rows = cache_num_rows();

	mysql_format(mysql, mysql_query_, sizeof (mysql_query_),
		"UPDATE "TABLE_REPORTS" SET admin=%d WHERE id=%d LIMIT 1", playerid + 1, report_id
	);
	mysql_tquery(mysql, mysql_query_, "", ""), mysql_query_[0] = EOS;

	format(stringer, sizeof (stringer), ""c_server"Предыдущие запросы от %s[%d]:\n \n",
		report_player_name, report_playerid
	);
	if (rows) {
		for (new i = 0, id, text[144], date_str[20]; i < rows; i++) {
			id = cache_get_field_content_int(i, "id");
			cache_get_field_content(i, "text", text, mysql, sizeof (text));
			cache_get_field_content(i, "date", date_str, mysql, sizeof (date_str));

			format(stringer1, sizeof (stringer1), ""c_server"№%d {afafaf}[%s] %s\n", id, date_str, text);
			strcat(stringer, stringer1), stringer1[0] = EOS;
		}
		strcat(stringer, " \n");
	}
	format(stringer1, sizeof (stringer1), "\
		{FFFFFF}Номер запроса: "c_server"#%i\n\
		{FFFFFF}Дата подачи: {afafaf}%s\n\
		{FFFFFF}Запрос: "c_server"%s",
		report_id,
		report_date,
		report_text
	);
	strcat(stringer, stringer1), stringer1[0] = EOS;

	TempReportInfo[playerid][reportID] = report_id;
	TempReportInfo[playerid][reportPlayerID] = report_playerid;
	strmid(TempReportInfo[playerid][reportText], report_text, 0, strlen(report_text), 144);
	strmid(TempReportInfo[playerid][reportDate], report_date, 0, strlen(report_date), 20);

	Dialog(playerid, 5512, DIALOG_STYLE_INPUT, !""c_server"Ответ на запрос игрока", stringer, !"Ответить", !"Пропустить");

	stringer[0] = EOS;
}

//alias:an("ans", "reps", "pm");
alias:ans("reps", "pm")
CMD:ans(playerid, params[])
{
    if(GetPlayerAdminEx(playerid))
    {
		new targetid, text[81];

		if (sscanf(params, "is[81]", targetid, text) || targetid < 0 ) {
			if (!report_Show(playerid) && strlen(params) > 2) {
				SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}Р?СЃРїРѕР»СЊР·СѓР№С‚Рµ: /ans [playerid / reportid] [С‚РµРєСЃС‚ / РѕС‚РІРµС‚]");
			}
			return true;
		}

		if (strlen(text) > 80)
			return SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}РќРµР»СЊР·СЏ РїРёСЃР°С‚СЊ Р±РѕР»СЊС€Рµ 80 СЃРёРјРІРѕР»РѕРІ!");

		utf8_to_cp1251(text);

		if (targetid >= MAX_PLAYERS) {

			new report_id = targetid, status = REPORT_STATUS_ANSWERED, Cache:result, rows;
			new target_name[MAX_PLAYER_NAME + 1];

			mysql_query_[0] = EOS;

			mysql_format(mysql, mysql_query_, sizeof (mysql_query_), "SELECT * FROM "TABLE_REPORTS" \
				WHERE status=0 AND id=%i", report_id
			);
			result = mysql_query(mysql, mysql_query_, true);

			mysql_query_[0] = EOS;
			rows = cache_num_rows(result);

			if(!rows) {
				cache_delete(result);
				SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}РќР° РґР°РЅРЅС‹Р№ Р·Р°РїСЂРѕСЃ СѓР¶Рµ Р±С‹Р» РґР°РЅ РѕС‚РІРµС‚!");
				return true;
			}

			targetid = cache_get_field_content_int(0, "player_id");
			cache_get_field_content(0, "text", TempReportInfo[playerid][reportText], mysql, 144);
			cache_get_field_content(0, "date", TempReportInfo[playerid][reportDate], mysql, 20);

			mysql_format(mysql, mysql_query_, sizeof (mysql_query_), "UPDATE "TABLE_REPORTS" SET \
				status=%d, answer='%e' WHERE status=0 AND id=%d", status, text, report_id
			);
			mysql_query(mysql, mysql_query_);

			format(stringer1, sizeof (stringer1), "\
				{FFFFFF}Р”Р°С‚Р° Р·Р°РїСЂРѕСЃР°: {afafaf}%s\n \n\
				{FFFFFF}Р’Р°С€ Р·Р°РїСЂРѕСЃ в„–%d:\n\
				{afafaf}| {afafaf}%s\n \n\
				{FFFFFF}РћС‚РІРµС‚ РѕС‚ Р°РґРјРёРЅРёСЃС‚СЂР°С†РёРё:\n\
				{afafaf}| "c_server"%s",
				TempReportInfo[playerid][reportDate], report_id, TempReportInfo[playerid][reportText], text
			);

			if(IsPlayerConnected(targetid))
			{
				Dialog(targetid, 0000, DIALOG_STYLE_MSGBOX, ""c_server"РћС‚РІРµС‚ Р°РґРјРёРЅРёСЃС‚СЂР°С†РёРё", stringer1, !"РЎРїР°СЃРёР±Рѕ", !"");

				format(stringer1, sizeof (stringer1), ""c_server"Р’Р°С€ Р·Р°РїСЂРѕСЃ в„–%d: {FFFFFF}%s", report_id, TempReportInfo[playerid][reportText]);
				SendClientMessage(targetid, COLOR_YELLOW, stringer1);
				format(stringer1, sizeof (stringer1), ""c_server"{8B4513}РћС‚РІРµС‚ РѕС‚ Р°РґРјРёРЅРёСЃС‚СЂР°С‚РѕСЂР° %s[%d]: {CD853F}%s", GetPlayerNameEx(playerid), playerid, text);
				SendClientMessage(targetid, COLOR_YELLOW, stringer1), stringer1[0] = EOS;
				format(target_name, sizeof target_name, "%s", GetPlayerNameEx(targetid));
			}
			else
			{
				SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}Р?РіСЂРѕРє РІС‹С€РµР» СЃ СЃРµСЂРІРµСЂР°, РѕС‚РІРµС‚ СЃРѕС…СЂР°РЅРµРЅ РІ СЃРёСЃС‚РµРјРµ.");
				format(target_name, sizeof target_name, "Offline");
			}

			format(stringer1, sizeof(stringer1), "{CC6633}[A] %s[%d] РѕС‚РІРµС‚РёР» РёРіСЂРѕРєСѓ %s[%i]: %s",
				GetPlayerNameEx(playerid), playerid, target_name, targetid, text
			);
			SendMessageToAdmins(stringer1,0xFfa500AA);
			AdminStats_AddReportAnswer(playerid);
			new report_stat_log[192];
			format(report_stat_log, sizeof report_stat_log, "Ответил на репорт #%d: %s", report_id, text);
			SendLog(playerid, LOG_TYPE_ADMIN_ACTION, report_stat_log);

			cache_delete(result);

		}
		else {
			if (!IsPlayerConnected(targetid))
				return SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}Р?РіСЂРѕРє РЅРµ РЅР°Р№РґРµРЅ");

			if (targetid == playerid)
				return SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}РќРµР»СЊР·СЏ РѕС‚РІРµС‚РёС‚СЊ СЃР°РјРѕРјСѓ СЃРµР±Рµ");

			format(stringer1, sizeof(stringer1), ""c_server"{8B4513}РћС‚РІРµС‚ РѕС‚ Р°РґРјРёРЅРёСЃС‚СЂР°С‚РѕСЂР° %s[%d]: {CD853F}%s",
				GetPlayerNameEx(playerid), playerid, text
			);
			SendClientMessage(targetid, 0xffa141FF, stringer1);

			format(stringer1, sizeof(stringer1), "{afafaf}[A] %s[%d] РѕС‚РІРµС‚РёР» РёРіСЂРѕРєСѓ %s[%d]: %s",
				GetPlayerNameEx(playerid), playerid, GetPlayerData(targetid, P_NAME), targetid, text
			);
			SendMessageToAdmins(stringer1,0xFfa500AA);
			AdminStats_AddReportAnswer(playerid);
			new report_stat_log[192];
			format(report_stat_log, sizeof report_stat_log, "Ответил на репорт игрока %s: %s", GetPlayerNameEx(targetid), text);
			SendLog(playerid, LOG_TYPE_ADMIN_ACTION, report_stat_log);

			stringer1[0] = EOS;
		}
	}
	return true;
}

report_OnGameModeInit() {
	mysql_tquery(mysql, "UPDATE "TABLE_REPORTS" SET status="#REPORT_STATUS_SKIPPED" WHERE status=0", "", "");
	mysql_tquery(mysql, "TRUNCATE "TABLE_REPORTS"", "", "");
	mysql_tquery(mysql, "ALTER TABLE "TABLE_REPORTS" AUTO_INCREMENT=1000", "", "");
}
report_OnPlayerDisconnect(playerid) {
	mysql_query_[0] = EOS;

	mysql_format(mysql, mysql_query_, sizeof (mysql_query_),
		"UPDATE "TABLE_REPORTS" SET status="#REPORT_STATUS_DISCONNECT" WHERE \
		status=0 AND player_name='%e' LIMIT 1", GetPlayerNameEx(playerid)
	);
	mysql_tquery(mysql, mysql_query_, "", ""), mysql_query_[0] = EOS;

	if (TempReportInfo[playerid][reportID]) {
		mysql_format(mysql, mysql_query_, sizeof (mysql_query_),
			"UPDATE "TABLE_REPORTS" SET admin=0 WHERE admin=%d LIMIT 1", playerid + 1
		);
		mysql_tquery(mysql, mysql_query_, "", ""), mysql_query_[0] = EOS;
		TempReportInfo[playerid][reportID] = 0;
	}
}
#endif

stock SpeedometrShowForPlayer(playerid)
{
	/*if(GetPlayerData(playerid, P_SPEEDOMETR) == 0)
	{
	    SpeedometrEnterShowForPlayer(playerid);
	}
	
	if(GetPlayerData(playerid, P_SPEEDOMETR) == 1)
	{
        Speedometr01ShowForPlayer(playerid);
	}
	
	if(GetPlayerData(playerid, P_SPEEDOMETR) == 2)
	{
        Speedometr02ShowForPlayer(playerid);
	}*/
}

stock SpeedometrEnterShowForPlayer(playerid)
{
  /*  SelectTextDraw(playerid, COR_SERVER);
    
    for(new idx; idx < sizeof enter_speedometr_TD; idx ++)
		TextDrawShowForPlayer(playerid, enter_speedometr_TD[idx]);*/
		
}

stock SpeedometrEnterHideForPlayer(playerid)
{
    /*CancelSelectTextDraw(playerid);
    
    for(new idx; idx < sizeof enter_speedometr_TD; idx ++)
		TextDrawHideForPlayer(playerid, enter_speedometr_TD[idx]);*/
		
    RemovePlayerFromVehicle(playerid);
}

CMD:speedometr(playerid)
{
    //SpeedometrEnterShowForPlayer(playerid);
}

stock CreateAnimTD(playerid)
{
    SelectTextDraw(playerid, COR_SERVER);
    
    TextDrawShowForPlayer(playerid, stop_anim_TD[0]);
}

stock HideAnimTD(playerid)
{
    CancelSelectTextDraw(playerid);
    TextDrawHideForPlayer(playerid, stop_anim_TD[0]);
}

new stt_timer[MAX_PLAYERS];
new bool:stt_blue_phase[MAX_PLAYERS];

stock StopPlayerStt(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(stt_timer[playerid] != 0)
    {
        KillTimer(stt_timer[playerid]);
        stt_timer[playerid] = 0;
    }
    stt_blue_phase[playerid] = false;
    return 1;
}

forward Straboscope(playerid);
public Straboscope(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)
        || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        StopPlayerStt(playerid);
        return 0;
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid))
    {
        StopPlayerStt(playerid);
        return 0;
    }

    stt_blue_phase[playerid] = !stt_blue_phase[playerid];
    if(stt_blue_phase[playerid]) SetVehicleLightsColors(vehicleid, 0, 0, 255);
    else SetVehicleLightsColors(vehicleid, 255, 0, 0);
    return 1;
}

CMD:stt(playerid, params[])
{
    #pragma unused params
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не за рулем");

    if(stt_timer[playerid] != 0)
    {
        StopPlayerStt(playerid);
        return 1;
    }

    stt_blue_phase[playerid] = false;
    stt_timer[playerid] = SetTimerEx("Straboscope", 300, true, "i", playerid);
    if(stt_timer[playerid] == 0) return 0;
    Straboscope(playerid);
    return 1;
}


stock CreateActorEx(name[],text[], skinid, Float:posx,Float:posy,Float:posz,Float:rot,virt = 0,inter = 0,inv = 1)
{
    for(new i = 0; i < MAX_ACTORS; i++)
    {
        if(IsValidActor(i)) continue;
        CreateActor(skinid,posx,posy,posz,rot);
        new string[144];
        SetActorVirtualWorld(i,virt);
        SetActorInvulnerable(i,inv);
        if(strlen(name) || strlen(text))
        {
            format(string,sizeof(string),"{FFFFFF}%s\n%s",name,text);
            CreateDynamic3DTextLabel(string,0xFFFF00AA,posx,posy,posz+1.2,10.0,INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, virt, inter);
        }
        return i;
    }
    return -1;
}


CMD:vz(playerid)
{

}

stock IsPlayerInArea(playerid,Float:minx,Float:miny,Float:maxx,Float:maxy)
{
	new Float:X,Float:Z,Float:Y;
 	GetPlayerPos(playerid,X,Y,Z);
	if(X > minx && X < maxx && Y > miny && maxy > Y) return 1;
	return 0;
}

CMD:sv(playerid, params[])
{
        if(GetPlayerAdminEx(playerid) < 6) return 1;
        
        if(sscanf(params,"s[32]",params[0]))
                SendClientMessage(playerid,-1,"крут");

        new File:my_filee,strr[128],
        Float:x,Float:y,Float:z,Float:a;
        GetPlayerPos(playerid,x,y,z);
        GetPlayerFacingAngle(playerid,a);
        my_filee=fopen("savedpositions.txt",io_append);
        format(strr,sizeof(strr),"%f,%f,%f,%f,%d,%d // %s\n\r",x,y,z,a,GetPlayerVirtualWorld(playerid),
		GetPlayerInterior(playerid),params[0]);
  		fwrite(my_filee,strr);
    	fclose(my_filee);
     	SendClientMessage(playerid,-1,"Ваша позиция сохранена в файл");
     	SendClientMessage(playerid,-1,strr);
     	print(#saving in \"savedpositions.txt\");
     	return 1;
}

CMD:coord(playerid)             //команда для координатов
{
	new Float:x,Float:y,Float:z,Float:a,string[90];
	GetPlayerFacingAngle(playerid,a);
	GetPlayerPos(playerid,x,y,z);

	format(string, sizeof(string),"X: %f | Y: %f | Z: %f | A: %f",x,y,z,a);
	SendClientMessage(playerid,0xFFFFFFFF,string);
	return true;
}

CMD:invv(playerid)
{
    

    new fmt_text[256];
    new itemList[256]; 

    itemList[0] = '\0'; 

    if (GetPlayerData(playerid, P_MED_CHEST) > 0)
    {
        format(fmt_text, sizeof(fmt_text), "{FFFF00}| {FFFFFF} Аптечка: {FFFF00} %d шт\n", GetPlayerData(playerid, P_MED_CHEST));
        strcat(itemList, fmt_text); 
    }

    if (GetPlayerData(playerid, P_MASK) > 0)
    {
        format(fmt_text, sizeof(fmt_text), "{FFFF00}| {FFFFFF} Маска: {FFFF00} %d шт\n", GetPlayerData(playerid, P_MASK));
        strcat(itemList, fmt_text);
    }
   
   if (GetPlayerData(playerid, P_DRUGS) > 0)
    {
        format(fmt_text, sizeof(fmt_text), "{FFFF00}| {FFFFFF} Н@ркотики: {FFFF00} %d шт\n", GetPlayerData(playerid, P_DRUGS));
        strcat(itemList, fmt_text);
    }
   
    
    
    strcat(itemList, fmt_text); 
    if (strlen(itemList) == 0)
    {
        format(itemList, sizeof(itemList), "{FFFF00} | {FFFFFF} У вас нет предметов.\n");
    }
  ShowPlayerDialog(playerid, DIALOG_INVENTORYTEST, DIALOG_STYLE_LIST, "{00FFFF}"SERVER_NAME" | {FFFFFF}Инвентарь", itemList, "Закрыть", "Понятно");
   return 1;
}
CMD:oxwjdovke(playerid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
    return ShowRadial(playerid, 0, 0, doors, lights, 0, 0, engine, 0);
}

stock ShowRadial(playerid, park, key, doors, lights, suspension, launch_control, engine, turbo)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x40);

    BS_WriteValue(bitstream, PR_UINT16, park);
    BS_WriteValue(bitstream, PR_UINT16, key);
    BS_WriteValue(bitstream, PR_UINT16, doors);
    BS_WriteValue(bitstream, PR_UINT16, lights);
    BS_WriteValue(bitstream, PR_UINT16, suspension);
    BS_WriteValue(bitstream, PR_UINT16, launch_control);
    BS_WriteValue(bitstream, PR_UINT16, engine);
    BS_WriteValue(bitstream, PR_UINT16, turbo);

    BS_Send(bitstream, playerid);

    BS_Delete(bitstream);

    return true;
}


CMD:turbo(playerid)
{
	return 1;
}

CMD:suspension(playerid)
{
	return 1;
}

CMD:launch_control(playerid)
{
	if(launch[playerid] != 1) return SCM(playerid, -1, ""USC"У вас не установлен лаунч-контроль");
	new car = GetPlayerVehicleID(playerid);
    // if( GetVehicleModel(GetPlayerVehicleID(playerid)) != 546) return SendClientMessage(playerid,0xFFFFFFFF,"{ff0000}[Ошибка]{ffffff}На эту машину нельзя включить лаунч-контроль!");
    //GameTextForPlayer(playerid, "~y~GO! GO! GO!", 2500, 4);
    //SetTimer("car",180000,false);
 	SetVehicleSpeed(car, 80);
 	return 1;
}

