#if defined _reports_included
	#endinput
#endif
#define _reports_included

#define REPORT_STATUS_NONE			0
#define REPORT_STATUS_ANSWERED		1
#define REPORT_STATUS_SKIPPED		2
#define REPORT_STATUS_DISCONNECT	3

#define TABLE_REPORTS				"reports_list"

enum TEMP_REPORT_E {
	reportID,
	reportPlayerID,
	reportDate[20],
	reportText[144]
};
new TempReportInfo[MAX_PLAYERS][TEMP_REPORT_E];

stock report_Send(playerid, const text[]) {
	/*mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
		"UPDATE "TABLE_REPORTS" SET status="#REPORT_STATUS_DISCONNECT" WHERE \
		status=0 AND player_name='%e' LIMIT 1", player_name[playerid]
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "", ""), MYSQL_GLOBAL[0] = EOS;*/


	MYSQL_GLOBAL[0] = EOS;
	
	mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), "INSERT INTO "TABLE_REPORTS" \
		(player_name, player_id, text) VALUES ('%e', %i, '%e')", player_name[playerid], playerid, text
	);
	new report_id, Cache:insert_result = mysql_query(connects, MYSQL_GLOBAL);

	MYSQL_GLOBAL[0] = EOS;
	report_id = cache_insert_id();

	if (cache_is_valid(insert_result)) cache_delete(insert_result);

	new Cache:result = mysql_query(connects, "SELECT id FROM "TABLE_REPORTS" WHERE status=0 AND admin=0"), rows;
	rows = cache_num_rows();

	format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), "Ваш запрос #%i успешно отправлен администрации. Вы %i в очереди!", 
		report_id, rows
	);
	SendOk(playerid, COMMAND_GLOBAL), COMMAND_GLOBAL[0] = EOS;

	if (cache_is_valid(result)) cache_delete(result);


	format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), "[PM] %s [%i]: %s (%i в очереди) "W"/reps %i", 
		player_name[playerid], playerid, text, rows, report_id
	);
	SendAdminMessage(0x008e8cff, COMMAND_GLOBAL),  COMMAND_GLOBAL[0] = EOS;

	return true;
}
stock report_Show(playerid) {
	new 
		Cache:result = mysql_query(connects, "SELECT * FROM "TABLE_REPORTS" WHERE status="#REPORT_STATUS_NONE" AND admin=0 LIMIT 1"), 
		report_id, report_status, report_playerid, report_player_name[MAX_PLAYER_NAME + 1], report_date[20], report_text[144];

	MYSQL_GLOBAL[0] = EOS;

	if (!cache_num_rows()) {
		if (cache_is_valid(result)) cache_delete(result);
		ErrorMessage(playerid, "В очереди нет запросов от игроков!");
		return false;
	}
	cache_get_value_name_int(0, "id", report_id);
	cache_get_value_name_int(0, "status", report_status);
	cache_get_value_name_int(0, "player_id", report_playerid);

	cache_get_value_name(0, "player_name", report_player_name, sizeof (report_player_name));

	cache_get_value_name(0, "text", report_text, sizeof (report_text));
	cache_get_value_name(0, "date", report_date, sizeof (report_date));

	mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), "SELECT * FROM "TABLE_REPORTS" WHERE \
		status>"#REPORT_STATUS_NONE" AND player_name='%e' ORDER BY id DESC LIMIT 3", report_player_name
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "report_ShowDialog", "ddsdss", playerid, report_id, report_player_name, report_playerid, report_text, report_date);

	if (cache_is_valid(result)) cache_delete(result);
	return true;
}
CB:report_ShowDialog(playerid, report_id, const report_player_name[], report_playerid, const report_text[], const report_date[]) {
	new rows = cache_num_rows();

	mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
		"UPDATE "TABLE_REPORTS" SET admin=%i WHERE id=%i LIMIT 1", playerid + 1, report_id
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "", ""), MYSQL_GLOBAL[0] = EOS;

	format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"Предыдущие запросы от %s [%i]:\n \n",
		report_player_name, report_playerid
	);
	if (rows) {
		for (new i = 0, id, text[144], date_str[20]; i < rows; i++) {
			cache_get_value_name_int(i, "id", id);
			cache_get_value_name(i, "text", text, sizeof (text));
			cache_get_value_name(i, "date", date_str, sizeof (date_str));

			format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), ""P"#%i "G"[%s] %s\n", id, date_str, text);
			strcat(STRING_GLOBAL, COMMAND_GLOBAL), COMMAND_GLOBAL[0] = EOS;
		}
		strcat(STRING_GLOBAL, " \n");
	}
	format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), "\
		"W"Номер запроса: "P"#%i\n\
		"W"Дата подачи: "G"%s\n\
		"W"Запрос: "P"%s", 
		report_id,
		report_date,
		report_text
	);
	strcat(STRING_GLOBAL, COMMAND_GLOBAL), COMMAND_GLOBAL[0] = EOS;

	TempReportInfo[playerid][reportID] = report_id;
	TempReportInfo[playerid][reportPlayerID] = report_playerid;
	strmid(TempReportInfo[playerid][reportText], report_text, 0, strlen(report_text), 144);
	strmid(TempReportInfo[playerid][reportDate], report_date, 0, strlen(report_date), 20);

	ShowPlayerDialog(playerid, D_REPORT_REPLY, DIALOG_STYLE_INPUT, ""P"Ответ на запрос игрока", STRING_GLOBAL, "Ответить", "Пропустить");

	STRING_GLOBAL[0] = EOS;
}
report_OnGameModeInit() {
	mysql_tquery(connects, "UPDATE "TABLE_REPORTS" SET status="#REPORT_STATUS_SKIPPED" WHERE status=0", "", "");
	mysql_tquery(connects, "TRUNCATE "TABLE_REPORTS"", "", "");
	mysql_tquery(connects, "ALTER TABLE "TABLE_REPORTS" AUTO_INCREMENT=1000", "", "");
}
report_OnPlayerDisconnect(playerid) {
	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
		"UPDATE "TABLE_REPORTS" SET status="#REPORT_STATUS_DISCONNECT" WHERE \
		status=0 AND player_name='%e' LIMIT 1", player_name[playerid]
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "", ""), MYSQL_GLOBAL[0] = EOS;

	if (TempReportInfo[playerid][reportID]) {
		mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
			"UPDATE "TABLE_REPORTS" SET admin=0 WHERE admin=%i LIMIT 1", playerid + 1
		);
		mysql_tquery(connects, MYSQL_GLOBAL, "", ""), MYSQL_GLOBAL[0] = EOS;
		TempReportInfo[playerid][reportID] = 0;
	}
}
