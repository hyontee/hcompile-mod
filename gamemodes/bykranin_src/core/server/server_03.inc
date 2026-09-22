//>> Файл: bykranin_src/core/server/server_03.inc  (741 строк)
//>> Тема: инфраструктура: таймеры, сохранение, MySQL, утилиты
//>> Внутри: AdminStats_Init, AdminStats_AddReportAnswer, AdminStats_GetLastAction, AdminStats_FormatTime, /astats, /techinfo, /get
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock AdminStats_Init()
{
	mysql_tquery(mysql,
		"ALTER TABLE accounts ADD COLUMN IF NOT EXISTS admin_reports INT NOT NULL DEFAULT 0");
	mysql_tquery(mysql,
		"CREATE TABLE IF NOT EXISTS admin_stats_online (" \
		"account_id INT NOT NULL," \
		"stat_date DATE NOT NULL," \
		"seconds INT NOT NULL DEFAULT 0," \
		"PRIMARY KEY(account_id,stat_date)," \
		"INDEX idx_stat_date(stat_date)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
	return 1;
}

stock AdminStats_AddReportAnswer(playerid)
{
	if(!IsPlayerConnected(playerid) || GetPlayerAdminEx(playerid) < 1 || GetPlayerAccountID(playerid) <= 0)
		return 0;

	new query[160];
	mysql_format(mysql, query, sizeof query,
		"UPDATE accounts SET admin_reports=admin_reports+1 WHERE id=%d LIMIT 1",
		GetPlayerAccountID(playerid));
	mysql_tquery(mysql, query);
	return 1;
}

stock AdminStats_GetLastAction(account_id, const pattern[], output[], size)
{
	format(output, size, "—");
	new query[256];
	mysql_format(mysql, query, sizeof query,
		"SELECT description FROM action_log WHERE acc_id=%d AND description LIKE '%e' ORDER BY time DESC LIMIT 1",
		account_id, pattern);
	new Cache:result = mysql_query(mysql, query, true);
	if(cache_num_rows(result))
		cache_get_field_content(0, "description", output, mysql, size);
	cache_delete(result);
	return 1;
}

stock AdminStats_FormatTime(seconds, output[], size)
{
	if(seconds < 0) seconds = 0;
	format(output, size, "%d:%02d:%02d", seconds / 3600, (seconds / 60) % 60, seconds % 60);
	return 1;
}

CMD:astats(playerid, params[])
{
	#pragma unused params
	if(GetPlayerAdminEx(playerid) < 1)
		return SendClientMessage(playerid, 0x999999FF, "У вас нет доступа к этой команде.");

	new account_id = GetPlayerAccountID(playerid);
	new query[1024];
	mysql_format(mysql, query, sizeof query,
		"SELECT " \
		"SUM(description LIKE 'Кикнул %%' OR description LIKE 'Без шума кикнул %%') AS kicks," \
		"SUM(description LIKE 'BAN: %%' OR description LIKE 'Оффлайн забанил %%') AS bans," \
		"SUM(description LIKE 'Выдал варн %%') AS warns," \
		"SUM(description LIKE 'Выдал %% блокировку чата %%') AS mutes," \
		"SUM(description LIKE 'Посадил в тюрьму %%') AS jails " \
		"FROM action_log WHERE acc_id=%d",
		account_id);
	new Cache:result = mysql_query(mysql, query, true);
	if(mysql_errno() || !cache_num_rows(result))
	{
		cache_delete(result);
		return SendClientMessage(playerid, 0xFF5533FF, "Не удалось загрузить статистику администратора.");
	}

	new kicks = cache_get_field_content_int(0, "kicks");
	new bans = cache_get_field_content_int(0, "bans");
	new warns = cache_get_field_content_int(0, "warns");
	new mutes = cache_get_field_content_int(0, "mutes");
	new jails = cache_get_field_content_int(0, "jails");
	cache_delete(result);

	mysql_format(mysql, query, sizeof query,
		"SELECT admin_reports FROM accounts WHERE id=%d LIMIT 1", account_id);
	result = mysql_query(mysql, query, true);
	new reports = cache_num_rows(result) ? cache_get_field_content_int(0, "admin_reports") : 0;
	cache_delete(result);

	new last_kick[48], last_ban[48], last_warn[48], last_mute[48], last_jail[48];
	AdminStats_GetLastAction(account_id, "Кикнул %", last_kick, sizeof last_kick);
	if(!strcmp(last_kick, "—")) AdminStats_GetLastAction(account_id, "Без шума кикнул %", last_kick, sizeof last_kick);
	AdminStats_GetLastAction(account_id, "BAN: %", last_ban, sizeof last_ban);
	if(!strcmp(last_ban, "—")) AdminStats_GetLastAction(account_id, "Оффлайн забанил %", last_ban, sizeof last_ban);
	AdminStats_GetLastAction(account_id, "Выдал варн %", last_warn, sizeof last_warn);
	AdminStats_GetLastAction(account_id, "Выдал % блокировку чата %", last_mute, sizeof last_mute);
	AdminStats_GetLastAction(account_id, "Посадил в тюрьму %", last_jail, sizeof last_jail);

	new week_seconds[7];
	mysql_format(mysql, query, sizeof query,
		"SELECT WEEKDAY(stat_date) AS week_day,seconds FROM admin_stats_online " \
		"WHERE account_id=%d AND YEARWEEK(stat_date,1)=YEARWEEK(CURDATE(),1)",
		account_id);
	result = mysql_query(mysql, query, true);
	for(new i; i < cache_num_rows(result); i++)
	{
		new day = cache_get_field_content_int(i, "week_day");
		if(0 <= day <= 6) week_seconds[day] = cache_get_field_content_int(i, "seconds");
	}
	cache_delete(result);

	mysql_format(mysql, query, sizeof query,
		"SELECT IFNULL(SUM(seconds),0) AS total FROM admin_stats_online WHERE account_id=%d",
		account_id);
	result = mysql_query(mysql, query, true);
	new total_online = cache_num_rows(result) ? cache_get_field_content_int(0, "total") : 0;
	cache_delete(result);

	static const day_name[7][16] =
	{
		"Понедельник", "Вторник", "Среда", "Четверг",
		"Пятница", "Суббота", "Воскресенье"
	};
	new body[4096], row[256], time_text[24], total_time_text[24];
	format(body, sizeof body,
		"\
		{E8E8E8}Общая статистика администратора {D7D729}%s {E8E8E8}(%d уровень):\n\n\
		{FFFFFF}- Назначил: {FFFF00}Администрация {FFFFFF}| Дата: {FFFF00}—\n\
		{FFFFFF}- Кикнул: {FFFF00}%d {FFFFFF}| Посл. причина: {AAAAAA}%s\n\
		{FFFFFF}- Забанил: {FFFF00}%d {FFFFFF}| Посл. причина: {AAAAAA}%s\n\
		{FFFFFF}- Выдал варн: {FFFF00}%d {FFFFFF}| Посл. причина: {AAAAAA}%s\n\
		{FFFFFF}- Ответов: {FFFF00}%d\n\
		{FFFFFF}- Мутов: {FFFF00}%d {FFFFFF}| Посл. причина: {AAAAAA}%s\n\
		{FFFFFF}- Посажено в тюрьму: {FFFF00}%d {FFFFFF}| Посл. причина: {AAAAAA}%s\n\n\
		{FFFFFF}- Выговоров: {FF5533}%d\n\n\
		{FFFFFF}Статистика онлайна администратора:\n\n",
		GetPlayerNameEx(playerid), GetPlayerAdminEx(playerid),
		kicks, last_kick, bans, last_ban, warns, last_warn,
		reports, mutes, last_mute, jails, last_jail,
		GetPlayerAdminWarn(playerid));

	for(new day; day < 7; day++)
	{
		AdminStats_FormatTime(week_seconds[day], time_text, sizeof time_text);
		format(row, sizeof row,
			"{FFFFFF}- %s: {FFFF00}%s {FFFFFF}| Норма онлайна: %s%s\n",
			day_name[day], time_text,
			week_seconds[day] >= 10800 ? "{33CC33}" : "{FF5533}",
			week_seconds[day] >= 10800 ? "Выполнена" : "Не выполнена");
		strcat(body, row, sizeof body);
	}
	AdminStats_FormatTime(total_online, total_time_text, sizeof total_time_text);
	format(row, sizeof row, "{FFFFFF}- Актив за всё время: {FFFF00}%s", total_time_text);
	strcat(body, row, sizeof body);

	new title[128];
	format(title, sizeof title, "{D7D729}Статистика администратора %s", GetPlayerNameEx(playerid));
	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, title, body, "Закрыть", "");
	return 1;
}

CMD:techinfo(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 8)
		return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к команде технического специалиста", "");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /techinfo [ник игрока]");

	extract params -> new string:name[24];
	if(!(3 <= strlen(name) <= 24))
		return SendClientMessage(playerid, 0x999999FF, "Некорректный ник игрока");

	new query[512];
	new Cache:result;
	new rows;
	mysql_format(mysql, query, sizeof query,
		"SELECT id,name,level,money,bank,wage,admin,phone,reg_ip,last_ip,reg_time,last_login,game_for_hour,donate_current,donate_total FROM accounts WHERE name='%e' LIMIT 1",
		name);
	result = mysql_query(mysql, query, true);
	rows = cache_num_rows(result);
	if(!rows)
	{
		cache_delete(result);
		return SendClientMessage(playerid, 0x999999FF, "Аккаунт с таким ником не найден");
	}

	new account_id = cache_get_field_content_int(0, "id");
	new account_name[25];
	new reg_ip[17];
	new last_ip[17];
	new reg_date[6];
	new last_date[6];
	new reg_time = cache_get_field_content_int(0, "reg_time");
	new last_login = cache_get_field_content_int(0, "last_login");
	new dialog_text[4096];
	new tech_line[256];

	cache_get_field_content(0, "name", account_name, mysql, sizeof account_name);
	cache_get_field_content(0, "reg_ip", reg_ip, mysql, sizeof reg_ip);
	cache_get_field_content(0, "last_ip", last_ip, mysql, sizeof last_ip);
	timestamp_to_date(reg_time, reg_date[2], reg_date[1], reg_date[0], reg_date[3], reg_date[4], reg_date[5]);
	timestamp_to_date(last_login, last_date[2], last_date[1], last_date[0], last_date[3], last_date[4], last_date[5]);

	format(dialog_text, sizeof dialog_text,
		"\
		{FFD700}ОСНОВНАЯ ИНФОРМАЦИЯ\n\
		{FFFFFF}Ник:\t%s\n\
		ID аккаунта:\t%d\n\
		Статус:\t%s\n\
		Уровень:\t%d\n\
		Уровень администратора:\t%d\n\
		Телефон:\t%d\n\
		Дата регистрации:\t%02d.%02d.%d %02d:%02d:%02d\n\
		Последний вход:\t%02d.%02d.%d %02d:%02d:%02d\n\
		Общее время в игре:\t%d ч.\n\n\
		{FFD700}СЕТЕВЫЕ ДАННЫЕ\n\
		{FFFFFF}IP регистрации:\t%s\n\
		Последний IP:\t%s\n\n\
		{FFD700}ФИНАНСЫ\n\
		{FFFFFF}Наличные:\t%d руб.\n\
		Основной банк:\t%d руб.\n\
		Счёт зарплаты:\t%d руб.\n\
		Донат:\t%d (всего: %d)\n",
		account_name,
		account_id,
		IsPlayerConnected(GetPlayerID(account_name)) ? ("{66CC33}Online{FFFFFF}") : ("{FF5533}Offline{FFFFFF}"),
		cache_get_field_content_int(0, "level"),
		cache_get_field_content_int(0, "admin"),
		cache_get_field_content_int(0, "phone"),
		reg_date[0], reg_date[1], reg_date[2], reg_date[3], reg_date[4], reg_date[5],
		last_date[0], last_date[1], last_date[2], last_date[3], last_date[4], last_date[5],
		ConvertUnixTime(cache_get_field_content_int(0, "game_for_hour"), CONVERT_TIME_TO_HOURS),
		reg_ip, last_ip,
		cache_get_field_content_int(0, "money"),
		cache_get_field_content_int(0, "bank"),
		cache_get_field_content_int(0, "wage"),
		cache_get_field_content_int(0, "donate_current"),
		cache_get_field_content_int(0, "donate_total"));
	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "SELECT IFNULL(SUM(balance),0) AS total FROM bank_accounts WHERE uid=%d", account_id);
	result = mysql_query(mysql, query, true);
	format(tech_line, sizeof tech_line, "Дополнительные счета:\t%d руб.\n\n", cache_get_field_content_int(0, "total"));
	strcat(dialog_text, tech_line, sizeof dialog_text);
	cache_delete(result);

	strcat(dialog_text, "{FFD700}ТРАНСПОРТ\n", sizeof dialog_text);
	mysql_format(mysql, query, sizeof query,
		"SELECT id,model_id,number,mileage,health FROM ownable_cars WHERE owner_id=%d ORDER BY id LIMIT 20", account_id);
	result = mysql_query(mysql, query, true);
	rows = cache_num_rows(result);
	if(!rows) strcat(dialog_text, "{AAAAAA}Нет личного транспорта\n", sizeof dialog_text);
	for(new i; i < rows; i++)
	{
		new vehicle_number[8];
		cache_get_field_content(i, "number", vehicle_number, mysql, sizeof vehicle_number);
		format(tech_line, sizeof tech_line, "{FFFFFF}ID %d: модель %d, номер %s, пробег %.1f, HP %.0f\n",
			cache_get_field_content_int(i, "id"),
			cache_get_field_content_int(i, "model_id"),
			vehicle_number,
			cache_get_field_content_float(i, "mileage"),
			cache_get_field_content_float(i, "health"));
		strcat(dialog_text, tech_line, sizeof dialog_text);
	}
	cache_delete(result);

	strcat(dialog_text, "\n{FFD700}НЕДВИЖИМОСТЬ И БИЗНЕС\n", sizeof dialog_text);
	mysql_format(mysql, query, sizeof query, "SELECT id,price FROM houses WHERE owner_id=%d ORDER BY id LIMIT 10", account_id);
	result = mysql_query(mysql, query, true);
	rows = cache_num_rows(result);
	for(new i; i < rows; i++)
	{
		format(tech_line, sizeof tech_line, "{FFFFFF}Дом: ID %d, цена %d руб.\n",
			cache_get_field_content_int(i, "id"), cache_get_field_content_int(i, "price"));
		strcat(dialog_text, tech_line, sizeof dialog_text);
	}
	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "SELECT id,price,type FROM housesnew WHERE accounts_id=%d ORDER BY id LIMIT 10", account_id);
	result = mysql_query(mysql, query, true);
	rows += cache_num_rows(result);
	for(new i; i < cache_num_rows(result); i++)
	{
		format(tech_line, sizeof tech_line, "{FFFFFF}Новый дом: ID %d, тип %d, цена %d руб.\n",
			cache_get_field_content_int(i, "id"),
			cache_get_field_content_int(i, "type"),
			cache_get_field_content_int(i, "price"));
		strcat(dialog_text, tech_line, sizeof dialog_text);
	}
	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "SELECT id,name,type,balance,products FROM business WHERE owner_id=%d ORDER BY id LIMIT 10", account_id);
	result = mysql_query(mysql, query, true);
	new property_rows = cache_num_rows(result);
	for(new i; i < property_rows; i++)
	{
		new business_name[32];
		cache_get_field_content(i, "name", business_name, mysql, sizeof business_name);
		format(tech_line, sizeof tech_line, "{FFFFFF}Бизнес: ID %d, %s, тип %d, баланс %d, товары %d\n",
			cache_get_field_content_int(i, "id"), business_name,
			cache_get_field_content_int(i, "type"),
			cache_get_field_content_int(i, "balance"),
			cache_get_field_content_int(i, "products"));
		strcat(dialog_text, tech_line, sizeof dialog_text);
	}
	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "SELECT id,name,balance FROM fuel_stations WHERE owner_id=%d ORDER BY id LIMIT 10", account_id);
	result = mysql_query(mysql, query, true);
	property_rows += cache_num_rows(result);
	for(new i; i < cache_num_rows(result); i++)
	{
		new station_name[32];
		cache_get_field_content(i, "name", station_name, mysql, sizeof station_name);
		format(tech_line, sizeof tech_line, "{FFFFFF}АЗС: ID %d, %s, баланс %d руб.\n",
			cache_get_field_content_int(i, "id"), station_name,
			cache_get_field_content_int(i, "balance"));
		strcat(dialog_text, tech_line, sizeof dialog_text);
	}
	cache_delete(result);
	if(!rows && !property_rows)
		strcat(dialog_text, "{AAAAAA}Недвижимость и бизнес отсутствуют\n", sizeof dialog_text);

	strcat(dialog_text, "\n{FFD700}ТВИНКИ ПО IP\n", sizeof dialog_text);
	mysql_format(mysql, query, sizeof query,
		"SELECT id,name,level,admin,last_ip FROM accounts WHERE id<>%d AND (last_ip='%e' OR reg_ip='%e' OR last_ip='%e' OR reg_ip='%e') ORDER BY last_login DESC LIMIT 30",
		account_id, last_ip, last_ip, reg_ip, reg_ip);
	result = mysql_query(mysql, query, true);
	rows = cache_num_rows(result);
	if(!rows) strcat(dialog_text, "{AAAAAA}Других аккаунтов на этих IP не найдено\n", sizeof dialog_text);
	for(new i; i < rows; i++)
	{
		new twin_name[25], twin_ip[17];
		cache_get_field_content(i, "name", twin_name, mysql, sizeof twin_name);
		cache_get_field_content(i, "last_ip", twin_ip, mysql, sizeof twin_ip);
		format(tech_line, sizeof tech_line, "{FFFFFF}%s [acc:%d] — LVL %d, ADM %d, IP %s\n",
			twin_name,
			cache_get_field_content_int(i, "id"),
			cache_get_field_content_int(i, "level"),
			cache_get_field_content_int(i, "admin"),
			twin_ip);
		strcat(dialog_text, tech_line, sizeof dialog_text);
	}
	cache_delete(result);

	format(tech_line, sizeof tech_line, "{FFD700}Техническая проверка: %s", account_name);
	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, tech_line, dialog_text, "Закрыть", "");

	format(tech_line, sizeof tech_line, "TECHINFO: проверил аккаунт %s[acc:%d], IP %s", account_name, account_id, last_ip);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, tech_line);
	return 1;
}

CMD:get(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 8) return 1;

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /get [имя игрока]");

	if(!(3 <= strlen(params) <= 20))
		return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

	extract params -> new string: name[21];

	new query[100];
	new Cache: result, user_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM accounts WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows(result))
		user_id = cache_get_field_content_int(0, "id");

	if(!cache_num_rows(result) || !user_id)
		return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден"), cache_delete(result);

	new reg_ip[16],
		last_ip[16],
		reg_date[6],
		reg_time = cache_get_field_content_int(0, "reg_time"),
		game_for_day = cache_get_field_content_int(0, "game_for_day"),
		game_for_day_prev = cache_get_field_content_int(0, "game_for_day_prev"),
		car_slots = cache_get_field_content_int(0, "car_slots");

	cache_get_field_content(0, "reg_ip", reg_ip);
	cache_get_field_content(0, "last_ip", last_ip);

	timestamp_to_date(reg_time, reg_date[2], reg_date[1], reg_date[0], reg_date[3], reg_date[4], reg_date[5]);

	new fmt_text[256];

	format
	(
		fmt_text, sizeof fmt_text,
		"\
		Номер аккаунта:\t\t%d\n\
		Наличные:\t\t\t%d\n\
		Осн. банк счет:\t\t%d\n\
		Уровень:\t\t\t%d\n\
		IP адрес (регистр.):\t\t%s\n\
		IP адрес (послед.):\t\t%s\n\
		Дата и время регистрации:\t\%02d.%02d.%d в %02d:%02d:%02d\n\
		Донат:\t\t\t\t%d (Всего: %d)\n\
		В игре сегодня:\t\t%d ч %d мин\n\
		В игре вчера:\t\t\t%d ч %d мин\n\n\
		Слоты для транспорта:\t%d\n\
		",
		user_id,
		cache_get_field_content_int(0, "money"),
		cache_get_field_content_int(0, "bank"),
		cache_get_field_content_int(0, "level"),
		reg_ip,
		last_ip,
		reg_date[0], reg_date[1], reg_date[2],
		reg_date[3], reg_date[4], reg_date[5],
		cache_get_field_content_int(0, "donate_current"),
		cache_get_field_content_int(0, "donate_total"),
		ConvertUnixTime(game_for_day, CONVERT_TIME_TO_HOURS),
		ConvertUnixTime(game_for_day, CONVERT_TIME_TO_MINUTES),
		ConvertUnixTime(game_for_day_prev, CONVERT_TIME_TO_HOURS),
		ConvertUnixTime(game_for_day_prev, CONVERT_TIME_TO_MINUTES),
		car_slots
	);

	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "SELECT * FROM ownable_cars WHERE owner_id=%d", user_id);
	result = mysql_query(mysql, query, true);

	if(cache_num_rows(result))
	{
		for(new idx; idx < cache_num_rows(result); idx ++)
		{
			new id = cache_get_field_content_int(idx, "id"),
				modelid = cache_get_field_content_int(idx, "model_id"),
				Float: x = cache_get_field_content_float(idx, "pos_x"),
				Float: y = cache_get_field_content_float(idx, "pos_y"),
				Float: z = cache_get_field_content_float(idx, "pos_z"),
				Float: health = cache_get_field_content_float(idx, "health"),
				number[7];

			cache_get_field_content(idx, "number", number);

			format(query, sizeof query, "\n%s [%d] - %s (%.1f, %.1f, %.1f) HP: %.1f", GetVehicleInfo(modelid - 400, VI_NAME), id, number, x, y, z, health);
			strcat(fmt_text, query);
		}
	}

	cache_delete(result);

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, name, fmt_text, "Закрыть", "");

	format(fmt_text, sizeof fmt_text, "Смотрит информацию об аккаунте %s[acc:%d]", name, user_id);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_text);

	return 1;
}

CMD:money(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 3) return 1;

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /money [имя игрока]");

	if(!(3 <= strlen(params) <= 20))
		return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

	extract params -> new string: name[21];

	new query[90];
	new Cache: result, user_id;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM accounts WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	if(cache_num_rows(result))
		user_id = cache_get_field_content_int(0, "id");

	if(!cache_num_rows(result) || !user_id)
		return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден"), cache_delete(result);

	new player_cash = cache_get_field_content_int(0, "money"),
		player_bank = cache_get_field_content_int(0, "bank"),
		player_wage = cache_get_field_content_int(0, "wage"),
		player_business = cache_get_field_content_int(0, "business"),
		player_fuel_st = cache_get_field_content_int(0, "fuel_st"),
		bank_accounts_money,
		fmt_text[310];

	cache_delete(result);

	mysql_format(mysql, query, sizeof query, "SELECT * FROM bank_accounts WHERE uid='%d'", user_id);
	result = mysql_query(mysql, query);

	if(cache_num_rows(result))
	{
		for(new i = 0; i < cache_num_rows(result); i++)
			bank_accounts_money += cache_get_field_content_int(i, "balance");
	}

	cache_delete(result);

	format
	(
		fmt_text, sizeof fmt_text,
		"\
		Наличные деньги:\t\t\t%d руб\n\
		Осн.банковский счёт:\t\t\t%d руб\n\
		Временный З/П счёт:\t\t\t%d руб\n\n\
		На всех доп. банк. счетах:\t\t%d руб\n\n\
		",
		player_cash, player_bank, player_wage, bank_accounts_money
	);

	if(player_business != -1)
	{
		mysql_format(mysql, query, sizeof query, "SELECT balance FROM business WHERE owner_id='%d' LIMIT 1", user_id);
		result = mysql_query(mysql, query);

		format(query, sizeof query, "На счету бизнеса:\t\t\t%d руб\n", cache_get_row_int(0, 0));
		strcat(fmt_text, query);

		cache_delete(result);
	}
					else strcat(fmt_text, "Нет бизнеса\n");
	cache_delete(result);
	if(player_fuel_st != -1)
	{
		mysql_format(mysql, query, sizeof query, "SELECT balance FROM fuel_stations WHERE owner_id='%d' LIMIT 1", user_id);
		result = mysql_query(mysql, query);

		format(query, sizeof query, "На счету АЗС:\t\t\t\t%d руб", cache_get_row_int(0, 0));
		strcat(fmt_text, query);

		cache_delete(result);
	}
					else strcat(fmt_text, "Нет АЗС");

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, name, fmt_text, "Закрыть", "");

	format(fmt_text, sizeof fmt_text, "Смотрит информацию о деньгах %s[acc:%d]", params, user_id);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_text);

	return 1;
}

CMD:getlog(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 12) return 1;

	if(!strlen(params))
	{
		SendClientMessage(playerid, 0xCECECEFF, "Используйте: /getlog [имя игрока] [идентификатор лога] [кол-во дней]");
		SendClientMessage(playerid, 0xCECECEFF, "Идентификаторы:");
		SendClientMessage(playerid, 0xCECECEFF, "1 - Администраторский чат");
		SendClientMessage(playerid, 0xCECECEFF, "2 - Ответы на репорты");
		SendClientMessage(playerid, 0xCECECEFF, "3 - Администраторские действия");
		SendClientMessage(playerid, 0xCECECEFF, "4 - Выдача администраторских прав");
		SendClientMessage(playerid, 0xCECECEFF, "5 - Выдача лидерских прав");
		SendClientMessage(playerid, 0xCECECEFF, "6 - СМС сообщения");
		SendClientMessage(playerid, 0xCECECEFF, "7 - Сообщения в общий чат");
		SendClientMessage(playerid, 0xCECECEFF, "8 - Вопросы/жалобы в репорт");
		SendClientMessage(playerid, 0xCECECEFF, "9 - Действия на посту лидера/заместителя");
		SendClientMessage(playerid, 0xCECECEFF, "10 - Действия главного администратора");

		return 1;
	}

	extract params -> new string:name[21], log_id, time_limit;

	if(!(LOG_TYPE_ADMIN_CHAT <= log_id <= LOG_TYPE_SUPERADMIN_ACTION))
		return SendClientMessage(playerid, 0x999999FF, "Неверный идентификатор");

	if(!(0 <= time_limit <= 30))
		return SendClientMessage(playerid, 0x999999FF, "Количество дней от 1 до 30. Используйте 0 для отображения всех действий");

	if(!(3 <= strlen(name) <= 20))
		return SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

	new query[144];
	new Cache: result,
		rows,
		user_id,
		admin;

	mysql_format(mysql, query, sizeof query, "SELECT id, admin FROM accounts WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);

	rows = cache_num_rows(result);

	if(rows)
	{
		user_id = cache_get_row_int(0, 0);
		admin = cache_get_row_int(0, 1);
	}

	cache_delete(result);

	if(rows && user_id)
	{
		if(GetPlayerAdminEx(playerid) >= admin)
		{
			mysql_format(mysql, query, sizeof query, "SELECT * FROM action_log WHERE acc_id=%d AND type=%d", user_id, log_id);

			new fmt_text[35];

			if(time_limit)
			{
				format(fmt_text, sizeof fmt_text, " AND time >= %d", gettime() - (time_limit * 86400));
				strcat(query, fmt_text);
			}

			result = mysql_query(mysql, query, true);

			rows = cache_num_rows(result);

			if(rows)
			{
				new log_name[10][37] =
				{
					"Администраторский чат",
					"Ответы на репорты",
					"Администраторские действия",
					"Выдача администраторских прав",
					"Выдача лидерских прав",
					"СМС сообщения",
					"Сообщения в общий чат",
					"Вопросы/жалобы в репорт",
					"Действия на посту лидера/заместителя",
					"Действия главного администратора"
				};

				format(query, sizeof query, "Найденные записи по параметру \"%s\" для игрока %s", log_name[log_id - 1], name);

				if(time_limit)
				{
					format(fmt_text, sizeof fmt_text, " за последние %d дн.", time_limit);
					strcat(query, fmt_text);
				}

				SendClientMessage(playerid, 0x66CC33FF, query);

				for(new idx; idx < rows; idx ++)
				{
					new desc[144],
						time[6],
						uip[17];

					cache_get_field_content(idx, "description", desc);
					cache_get_field_content(idx, "uip", uip);

					timestamp_to_date(cache_get_field_content_int(idx, "time"), time[2], time[1], time[0], time[3], time[4], time[5]);

					format
					(
						query, sizeof query,
						"#%d | %02d.%02d.%d в %02d:%02d:%02d | %s | %s",
						cache_get_field_content_int(idx, "id"),
						time[0], time[1], time[2], time[3], time[4], time[5],
						uip, desc
					);

					SendClientMessage(playerid, 0xFFCD00FF, query);
				}

				format(query, sizeof query, "Общее количество записей: %d", rows);
				SendClientMessage(playerid, 0x66CC33FF, query);
			}
					else SendClientMessage(playerid, 0x999999FF, "Записи в базе данных по данным параметрам не найдены");

			cache_delete(result);
		}
					else SendClientMessage(playerid, 0x999999FF, "Вы не можете просматривать логи администратора выше Вас рангом");
	}
					else SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

	return 1;
}

CMD:lip(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 8) return 1;

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /lip [IP адрес]");

	new query[130],
		fmt_text[2300],
		Cache: result,
		rows;

	mysql_format(mysql, query, sizeof query, "SELECT name, reg_ip FROM accounts WHERE reg_ip = '%s' OR last_ip = '%s'", params, params);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);

	if(rows)
	{
		new l_acc_count;

		format(fmt_text, sizeof fmt_text, "IP: %s\n", params);

		for(new idx; idx < rows; idx ++)
		{
			new name[21],
				ip[17];

			cache_get_row(idx, 0, name);
			cache_get_row(idx, 1, ip);

			new bool: is_reg = false;

			if(!strcmp(ip, params, true))
				is_reg = true;

			else
				l_acc_count ++;

			format
			(
				query, sizeof query,
				"\n{FFFFFF}%d. %s - %s %s",
				idx + 1,
				name,
				is_reg ? "Reg" : "Last",
				IsPlayerConnected(GetPlayerID(name)) ? "{66CC33}[online]" : "{888888}[offline]"
			);

			strcat(fmt_text, query);
		}

		format(query, sizeof query, "{FF9900}Найдено аккаунтов: %d / %d", l_acc_count, rows);

		Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, query, fmt_text, "Закрыть", "");
	}
					else SendClientMessage(playerid, 0x999999FF, "Данный IP адрес не найден в базе данных");

	cache_delete(result);

	return 1;
}

