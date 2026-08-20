// =====================================================================
//  СИСТЕМА "МЕНЮ ОРГАНИЗАЦИИ" (по образцу скриншота из ТЗ, меню фракции)
//  Работает через стандартные SA-MP диалоги.
//  Распространяется на ВСЕ государственные фракции (P_TEAM 1..MAX_ORG-1),
//  использующие существующую систему рангов (rank_names / P_JOB / InvitePlayer).
//
//  Требуемые изменения в БД (выполнить вручную на сервере MySQL):
//
//  ALTER TABLE `accounts` ADD COLUMN `org_reprimand` INT(1) NOT NULL DEFAULT 0;
//
//  CREATE TABLE IF NOT EXISTS `org_rang_access` (
//      `org_id` TINYINT(2) NOT NULL,
//      `rang` TINYINT(2) NOT NULL,
//      `right_id` TINYINT(2) NOT NULL,
//      `value` TINYINT(1) NOT NULL DEFAULT 0,
//      PRIMARY KEY (`org_id`,`rang`,`right_id`)
//  );
//
//  Подключить инклуд в ryzen.pwn (рядом с другими #include "../include/system/..."):
//      #include "../include/system/org_menu.pwn"
//
//  В OnGameModeInit() (там же, где вызывается LoadLeaderList()) добавить:
//      LoadOrgRangAccess();
//
//  В LoadPlayerData() (там же, где грузится P_JOB) добавить:
//      SetPlayerData(playerid, P_ORG_REPRIMAND, cache_get_field_content_int(0, "org_reprimand"));
//
//  Внутри switch(dialogid) { в OnDialogResponse (первая строчка после '{')
//  нужно вставить блок case-ов из файла org_menu_dialogs.inc (см. инструкцию там).
// =====================================================================

#if defined _org_menu_included
	#endinput
#endif
#define _org_menu_included

// ---------------------------------------------------------------------
// ПРАВА РАНГОВ
// ---------------------------------------------------------------------
enum
{
	ORG_RIGHT_PROMOTE,     // повышение в звании
	ORG_RIGHT_DEMOTE,      // понижение в звании
	ORG_RIGHT_FIRE,        // увольнение
	ORG_RIGHT_REPRIMAND,   // выдача/снятие выговора
	ORG_RIGHT_CUFF,        // наручники (/cuff)
	ORG_RIGHT_VEHICLE,     // информация о технике организации
	ORG_RIGHT_STORAGE,     // открытие/закрытие склада
	ORG_RIGHT_TAG,         // установка тега
	ORG_RIGHT_NUM
};

new const g_org_right_name[40][40] = 40,
{
	"Повышать в звании",
	"Понижать в звании",
	"Увольнять из организации",
	"Выдавать / снимать выговор",
	"Надевать наручники (/cuff)",
	"Доступ к технике организации",
	"Открывать / закрывать склад",
	"Устанавливать тег"
};

#define MAX_ORG_REPRIMANDS 3

// [org_id][rang][право] -- индексы rang 1..10 используются напрямую (0 не используется)
new bool: g_org_rang_access[MAX_ORG][11][ORG_RIGHT_NUM];

// открыт ли склад организации (в памяти, т.к. сами организации тоже не хранятся в БД)
new bool: g_org_storage_open[MAX_ORG];

// контекст меню на каждого игрока
new g_orgm_target_acc[40];              // id аккаунта выбранного сотрудника
new g_orgm_target_online[40];            // playerid, если сотрудник онлайн, иначе INVALID_PLAYER_ID
new g_orgm_target_name[40][40];
new g_orgm_target_rang[40];
new g_orgm_edit_rang[40];                // ранг, права которого сейчас настраивает лидер
new g_orgm_list_acc[40][40];            // соответствие "строка списка" -> account_id
new g_orgm_list_name[40][40][40];
new g_orgm_list_rang[40][40];
new g_orgm_list_count[40];               // сколько реально строк в последнем списке

#define DIALOG_ORGMENU_MAIN                90210
#define DIALOG_ORGMENU_MEMBERS             90211
#define DIALOG_ORGMENU_ACTIONS             90212
#define DIALOG_ORGMENU_TAG                 90213
#define DIALOG_ORGMENU_REPRIMAND_REASON    90214
#define DIALOG_ORGMENU_RIGHTS_RANG         90215
#define DIALOG_ORGMENU_RIGHTS_TOGGLE       90216
#define DIALOG_ORGMENU_FIRE_CONFIRM        90217
#define DIALOG_ORGMENU_VEHICLES            90218

// ---------------------------------------------------------------------
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
// ---------------------------------------------------------------------

// лидером считается игрок с максимальным рангом (10) -- так же, как определяет InvitePlayer()
stock bool: IsOrgLeader(playerid)
{
	if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)) return false;
	return bool: (GetPlayerJob(playerid) == 10);
}

stock bool: HasOrgRight(playerid, right)
{
	if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)) return false;
	if(IsOrgLeader(playerid)) return true;

	new team = GetPlayerTeamEx(playerid), rang = GetPlayerJob(playerid);
	if(!(1 <= rang <= 10)) return false;

	return g_org_rang_access[team][rang][right];
}

// загрузка прав рангов из БД при старте сервера
public: LoadOrgRangAccess()
{
	new Cache: result, rows;

	result = mysql_query(mysql, "SELECT * FROM `org_rang_access`", true);
	rows = cache_num_rows();

	for(new i = 0; i < rows; i ++)
	{
		new org_id = cache_get_field_content_int(i, "org_id");
		new rang = cache_get_field_content_int(i, "rang");
		new right_id = cache_get_field_content_int(i, "right_id");
		new value = cache_get_field_content_int(i, "value");

		if(!(1 <= org_id < MAX_ORG)) continue;
		if(!(1 <= rang <= 10)) continue;
		if(!(0 <= right_id < ORG_RIGHT_NUM)) continue;

		g_org_rang_access[org_id][rang][right_id] = bool: value;
	}

	printf("[OrgMenu]: Загружено прав рангов: %d", rows);
	cache_delete(result);
	return 1;
}

stock SaveOrgRight(org_id, rang, right_id)
{
	new query[200];
	mysql_format(mysql, query, sizeof query,
		"INSERT INTO `org_rang_access` (org_id, rang, right_id, value) VALUES (%d, %d, %d, %d) \
ON DUPLICATE KEY UPDATE value = %d",
		org_id, rang, right_id, g_org_rang_access[org_id][rang][right_id],
		g_org_rang_access[org_id][rang][right_id]);
	mysql_query(mysql, query, false);
	return 1;
}

// ищет онлайн-игрока по account_id, возвращает INVALID_PLAYER_ID если не в сети
stock FindOnlinePlayerByAccount(acc_id)
{
	for(new i = 0; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
		if(GetPlayerAccountID(i) == acc_id) return i;
	}
	return INVALID_PLAYER_ID;
}

// ---------------------------------------------------------------------
// ВХОД В МЕНЮ
// ---------------------------------------------------------------------
CMD:forg(playerid, params[1])
{
	new team = GetPlayerTeamEx(playerid);

	if(!(1 <= team < MAX_ORG))
		return SendClientMessage(playerid, 0x999999FF, "Вы не состоите в организации");

	ShowOrgMenuMain(playerid);
	return 1;
}
CMD:orgmenu(playerid, params[1])
{
	return callcmd::forg(playerid, params);
}

// ВАЖНО: список пунктов ВСЕГДА фиксированного размера и порядка (6 пунктов, индексы 0..5),
// чтобы listitem в OnDialogResponse однозначно соответствовал пункту меню.
// Пункты без прав доступа тоже показываются (с пометкой), но при выборе блокируются повторной
// проверкой прав внутри обработчика -- это исключает рассинхронизацию индексов и обход через UI.
stock ShowOrgMenuMain(playerid)
{
	new team = GetPlayerTeamEx(playerid), rang = GetPlayerJob(playerid);

	new caption[128], fmt_rang[50];
	format(fmt_rang, sizeof fmt_rang, rank_names[team - 1][rang - 1]);
	format(caption, sizeof caption, "Организация: %s | Звание: %s", GetPlayerTeamName(playerid), fmt_rang);

	new list[500];
	new veh_line[40], storage_line[60], leader_line[40];

	format(veh_line, sizeof veh_line, "Техника организации%s\n",
		HasOrgRight(playerid, ORG_RIGHT_VEHICLE) ? ("") : (" {999999}(нет доступа)"));

	format(storage_line, sizeof storage_line, "Склад: %s%s\n",
		g_org_storage_open[team] ? ("{00FF00}ОТКРЫТ") : ("{FF0000}ЗАКРЫТ"),
		HasOrgRight(playerid, ORG_RIGHT_STORAGE) ? ("") : (" {999999}(нет доступа)"));

	format(leader_line, sizeof leader_line, "Настройка прав рангов%s\n",
		IsOrgLeader(playerid) ? ("") : (" {999999}(только лидер)"));

	format(list, sizeof list, "Оповещение (мегафон)\nСписок сотрудников\n%s%s%sПокинуть организацию",
		veh_line, storage_line, leader_line);

	Dialog(playerid, DIALOG_ORGMENU_MAIN, DIALOG_STYLE_LIST, caption, list, "Выбрать", "Закрыть");
	return 1;
}

// ---------------------------------------------------------------------
// СПИСОК СОТРУДНИКОВ
// ---------------------------------------------------------------------
stock ShowOrgMenuMembers(playerid)
{
	new team = GetPlayerTeamEx(playerid);
	new query[128];

	mysql_format(mysql, query, sizeof query,
		"SELECT id, name, job, org_reprimand, last_login FROM accounts WHERE team=%d AND id != %d ORDER BY job DESC, name ASC LIMIT 100",
		team, GetPlayerAccountID(playerid));

	new Cache: result = mysql_query(mysql, query, true);
	new rows = cache_num_rows();

	new list[2400], line_str[160];
	format(list, sizeof list, "Ник\tЗвание\tВыговоры\tОнлайн\n");

	for(new i = 0; i < rows && i < 100; i ++)
	{
		new acc_id = cache_get_field_content_int(i, "id");
		new name[MAX_PLAYER_NAME];
		cache_get_field_content(i, "name", name, mysql, MAX_PLAYER_NAME);
		new rang = cache_get_field_content_int(i, "job");
		new reprimand = cache_get_field_content_int(i, "org_reprimand");
		new last_login = cache_get_field_content_int(i, "last_login");

		if(!(1 <= rang <= 10)) rang = 1;

		new fmt_rang[50];
		format(fmt_rang, sizeof fmt_rang, rank_names[team - 1][rang - 1]);

		new online_playerid = FindOnlinePlayerByAccount(acc_id);
		new status[24];
		if(online_playerid != INVALID_PLAYER_ID)
			format(status, sizeof status, "{00FF00}В сети");
		else
		{
			new year, month, day, hour, minute, second;
			timestamp_to_date(last_login, year, month, day, hour, minute, second);
			format(status, sizeof status, "{999999}%02d.%02d.%d", day, month, year);
		}

		g_orgm_list_acc[playerid][i] = acc_id;
		format(g_orgm_list_name[playerid][i], MAX_PLAYER_NAME, "%s", name);
		g_orgm_list_rang[playerid][i] = rang;

		format(line_str, sizeof line_str, "%s\t%s\t%d/%d\t%s\n", name, fmt_rang, reprimand, MAX_ORG_REPRIMANDS, status);
		strcat(list, line_str);
	}

	g_orgm_list_count[playerid] = rows;
	cache_delete(result);

	Dialog(playerid, DIALOG_ORGMENU_MEMBERS, DIALOG_STYLE_TABLIST_HEADERS,
		"Сотрудники организации", list, "Выбрать", "Назад");
	return 1;
}

// ---------------------------------------------------------------------
// ПАНЕЛЬ ДЕЙСТВИЙ НАД СОТРУДНИКОМ
// ---------------------------------------------------------------------
// Фиксированный порядок (индексы 0..5), проверка прав повторяется в обработчике каждого действия.
// "can_manage" (ранг ниже своего, либо лидер) -- базовое условие иерархии, показывается подсказкой.
stock ShowOrgMenuActions(playerid)
{
	new target_rang = g_orgm_target_rang[playerid];
	new my_rang = GetPlayerJob(playerid);

	new caption[100];
	format(caption, sizeof caption, "Действия: %s", g_orgm_target_name[playerid]);

	new bool: can_manage = (my_rang > target_rang) || IsOrgLeader(playerid);
	new hint[24];
	format(hint, sizeof hint, "%s", can_manage ? ("") : (" {999999}(выше ранг)"));

	new list[500];
	format(list, sizeof list,
		"Повысить в звании%s\nПонизить в звании%s\nВыдать выговор%s\nСнять выговор%s\nУстановить тег%s\nУволить%s",
		hint, hint, hint, hint, hint, hint);

	Dialog(playerid, DIALOG_ORGMENU_ACTIONS, DIALOG_STYLE_LIST, caption, list, "Выбрать", "Назад");
	return 1;
}

// ---------------------------------------------------------------------
// ДЕЙСТВИЯ: повышение / понижение / увольнение
// ---------------------------------------------------------------------
// direction: 1 = повысить, -1 = понизить
stock OrgMenuChangeRang(playerid, direction)
{
	new target_rang = g_orgm_target_rang[playerid];
	new my_rang = GetPlayerJob(playerid);
	new bool: can_manage = (my_rang > target_rang) || IsOrgLeader(playerid);

	if(!can_manage)
		return SendClientMessage(playerid, 0x999999FF, "У этого сотрудника ранг не ниже Вашего");

	if(direction == 1)
	{
		if(!HasOrgRight(playerid, ORG_RIGHT_PROMOTE))
			return SendClientMessage(playerid, 0x999999FF, "У Вас нет прав на повышение в звании");
		if(target_rang >= 10 || target_rang >= my_rang)
			return SendClientMessage(playerid, 0x999999FF, "Нельзя повысить сотрудника выше своего звания");
	}
	else
	{
		if(!HasOrgRight(playerid, ORG_RIGHT_DEMOTE))
			return SendClientMessage(playerid, 0x999999FF, "У Вас нет прав на понижение в звании");
		if(target_rang <= 1)
			return SendClientMessage(playerid, 0x999999FF, "Ниже некуда понижать");
	}

	new new_rang = target_rang + direction;

	new acc_id = g_orgm_target_acc[playerid];
	new team = GetPlayerTeamEx(playerid);
	new online_id = g_orgm_target_online[playerid];

	if(online_id != INVALID_PLAYER_ID)
	{
		InvitePlayer(online_id, team, new_rang, true);

		new fmt_rang[50];
		format(fmt_rang, sizeof fmt_rang, rank_names[team - 1][new_rang - 1]);

		new msg[128];
		format(msg, sizeof msg, "%s изменил Ваше звание на \"%s\"", GetPlayerNameEx(playerid), fmt_rang);
		SendClientMessage(online_id, 0x3399FFFF, msg);
	}
	else
	{
		new query[128];
		mysql_format(mysql, query, sizeof query, "UPDATE accounts SET job=%d WHERE id=%d", new_rang, acc_id);
		mysql_query(mysql, query, false);
	}

	new fmt_msg[128];
	format(fmt_msg, sizeof fmt_msg, "Изменил звание %s на \"%s\"", g_orgm_target_name[playerid], rank_names[team - 1][new_rang - 1]);
	SendLog(playerid, LOG_TYPE_FRACTION, fmt_msg);

	SendClientMessage(playerid, 0x3399FFFF, "Звание сотрудника изменено");
	return 1;
}

stock OrgMenuFire(playerid)
{
	new target_rang = g_orgm_target_rang[playerid];
	new my_rang = GetPlayerJob(playerid);
	new bool: can_manage = (my_rang > target_rang) || IsOrgLeader(playerid);

	if(!can_manage)
		return SendClientMessage(playerid, 0x999999FF, "У этого сотрудника ранг не ниже Вашего");
	if(!HasOrgRight(playerid, ORG_RIGHT_FIRE))
		return SendClientMessage(playerid, 0x999999FF, "У Вас нет прав на увольнение");

	new acc_id = g_orgm_target_acc[playerid];
	new online_id = g_orgm_target_online[playerid];

	if(online_id != INVALID_PLAYER_ID)
	{
		UnInvite(playerid, online_id, "Уволен через меню организации");
	}
	else
	{
		// оффлайн-сотрудника увольняем напрямую в БД
		new query[128];
		mysql_format(mysql, query, sizeof query, "UPDATE accounts SET team=0, job=0, org_reprimand=0 WHERE id=%d", acc_id);
		mysql_query(mysql, query, false);

		new fmt_msg[128];
		format(fmt_msg, sizeof fmt_msg, "Уволил %s [оффлайн] из организации", g_orgm_target_name[playerid]);
		SendLog(playerid, LOG_TYPE_FRACTION, fmt_msg);
	}

	SendClientMessage(playerid, 0xFF0000FF, "Сотрудник уволен из организации");
	return 1;
}

// ---------------------------------------------------------------------
// ВЫГОВОРЫ
// ---------------------------------------------------------------------
stock OrgMenuGiveReprimand(playerid, reason[])
{
	new target_rang = g_orgm_target_rang[playerid];
	new my_rang = GetPlayerJob(playerid);
	new bool: can_manage = (my_rang > target_rang) || IsOrgLeader(playerid);

	if(!can_manage)
		return SendClientMessage(playerid, 0x999999FF, "У этого сотрудника ранг не ниже Вашего");
	if(!HasOrgRight(playerid, ORG_RIGHT_REPRIMAND))
		return SendClientMessage(playerid, 0x999999FF, "У Вас нет прав на выдачу выговоров");

	new acc_id = g_orgm_target_acc[playerid];
	new online_id = g_orgm_target_online[playerid];
	new team = GetPlayerTeamEx(playerid);

	new query[128];
	mysql_format(mysql, query, sizeof query, "SELECT org_reprimand FROM accounts WHERE id=%d LIMIT 1", acc_id);
	new Cache: result = mysql_query(mysql, query, true);

	new current = 0;
	if(cache_num_rows())
		current = cache_get_field_content_int(0, "org_reprimand");
	cache_delete(result);

	current ++;

	if(current >= MAX_ORG_REPRIMANDS)
	{
		// автоматическое увольнение при достижении лимита
		if(online_id != INVALID_PLAYER_ID)
		{
			SendClientMessage(online_id, 0xFF0000FF, "Вы получили 3-й выговор и автоматически уволены из организации");
			UnInvite(playerid, online_id, "Автоувольнение: 3 выговора");
		}
		else
		{
			mysql_format(mysql, query, sizeof query, "UPDATE accounts SET team=0, job=0, org_reprimand=0 WHERE id=%d", acc_id);
			mysql_query(mysql, query, false);
		}

		new fmt_msg[150];
		format(fmt_msg, sizeof fmt_msg, "Выдал выговор %s (3/3) -> автоувольнение. Причина: %s", g_orgm_target_name[playerid], reason);
		SendLog(playerid, LOG_TYPE_FRACTION, fmt_msg);

		SendClientMessage(playerid, 0xFF0000FF, "Сотрудник получил 3-й выговор и автоматически уволен");
	}
	else
	{
		mysql_format(mysql, query, sizeof query, "UPDATE accounts SET org_reprimand=%d WHERE id=%d", current, acc_id);
		mysql_query(mysql, query, false);

		if(online_id != INVALID_PLAYER_ID)
		{
			SetPlayerData(online_id, P_ORG_REPRIMAND, current);

			new msg[150];
			format(msg, sizeof msg, "%s выдал Вам выговор (%d/%d). Причина: %s", GetPlayerNameEx(playerid), current, MAX_ORG_REPRIMANDS, reason);
			SendClientMessage(online_id, 0xFF6600FF, msg);
		}

		new fmt_msg[150];
		format(fmt_msg, sizeof fmt_msg, "Выдал выговор %s (%d/%d). Причина: %s", g_orgm_target_name[playerid], current, MAX_ORG_REPRIMANDS, reason);
		SendLog(playerid, LOG_TYPE_FRACTION, fmt_msg);

		new fmt_pl[100];
		format(fmt_pl, sizeof fmt_pl, "Выговор выдан (%d/%d)", current, MAX_ORG_REPRIMANDS);
		SendClientMessage(playerid, 0x3399FFFF, fmt_pl);
	}

	#pragma unused team
	return 1;
}

stock OrgMenuRemoveReprimand(playerid)
{
	new target_rang = g_orgm_target_rang[playerid];
	new my_rang = GetPlayerJob(playerid);
	new bool: can_manage = (my_rang > target_rang) || IsOrgLeader(playerid);

	if(!can_manage)
		return SendClientMessage(playerid, 0x999999FF, "У этого сотрудника ранг не ниже Вашего");
	if(!HasOrgRight(playerid, ORG_RIGHT_REPRIMAND))
		return SendClientMessage(playerid, 0x999999FF, "У Вас нет прав на снятие выговоров");

	new acc_id = g_orgm_target_acc[playerid];
	new online_id = g_orgm_target_online[playerid];

	new query[128];
	mysql_format(mysql, query, sizeof query, "SELECT org_reprimand FROM accounts WHERE id=%d LIMIT 1", acc_id);
	new Cache: result = mysql_query(mysql, query, true);

	new current = 0;
	if(cache_num_rows())
		current = cache_get_field_content_int(0, "org_reprimand");
	cache_delete(result);

	if(current <= 0)
	{
		SendClientMessage(playerid, 0x999999FF, "У сотрудника нет выговоров");
		return 1;
	}

	current --;

	mysql_format(mysql, query, sizeof query, "UPDATE accounts SET org_reprimand=%d WHERE id=%d", current, acc_id);
	mysql_query(mysql, query, false);

	if(online_id != INVALID_PLAYER_ID)
	{
		SetPlayerData(online_id, P_ORG_REPRIMAND, current);

		new msg[100];
		format(msg, sizeof msg, "%s снял с Вас выговор (осталось %d/%d)", GetPlayerNameEx(playerid), current, MAX_ORG_REPRIMANDS);
		SendClientMessage(online_id, 0x00FF00FF, msg);
	}

	new fmt_msg[128];
	format(fmt_msg, sizeof fmt_msg, "Снял выговор с %s (осталось %d/%d)", g_orgm_target_name[playerid], current, MAX_ORG_REPRIMANDS);
	SendLog(playerid, LOG_TYPE_FRACTION, fmt_msg);

	SendClientMessage(playerid, 0x3399FFFF, "Выговор снят");
	return 1;
}

// ---------------------------------------------------------------------
// ТЕГ
// ---------------------------------------------------------------------
stock OrgMenuSetTag(playerid, tag[])
{
	new target_rang = g_orgm_target_rang[playerid];
	new my_rang = GetPlayerJob(playerid);
	new bool: can_manage = (my_rang > target_rang) || IsOrgLeader(playerid);

	if(!can_manage)
		return SendClientMessage(playerid, 0x999999FF, "У этого сотрудника ранг не ниже Вашего");
	if(!HasOrgRight(playerid, ORG_RIGHT_TAG))
		return SendClientMessage(playerid, 0x999999FF, "У Вас нет прав на установку тега");
	if(strlen(tag) > 15)
		return SendClientMessage(playerid, 0x999999FF, "Тег не может быть длиннее 15 символов");

	new acc_id = g_orgm_target_acc[playerid];
	new online_id = g_orgm_target_online[playerid];

	if(online_id != INVALID_PLAYER_ID)
	{
		format(GetPlayerData(online_id, P_PREFIX), 15, "%s", tag);
		UpdatePlayerDatabaseString(online_id, "prefix", GetPlayerData(online_id, P_PREFIX));
		SendClientMessage(online_id, 0x3399FFFF, "Вам установлен новый тег организации");
	}
	else
	{
		new query[150];
		mysql_format(mysql, query, sizeof query, "UPDATE accounts SET prefix='%e' WHERE id=%d", tag, acc_id);
		mysql_query(mysql, query, false);
	}

	SendClientMessage(playerid, 0x3399FFFF, "Тег сотруднику установлен");
	return 1;
}

// ---------------------------------------------------------------------
// СКЛАД (тумблер)
// ---------------------------------------------------------------------
stock OrgMenuToggleStorage(playerid)
{
	if(!HasOrgRight(playerid, ORG_RIGHT_STORAGE))
		return SendClientMessage(playerid, 0x999999FF, "У Вас нет прав на управление складом");

	new team = GetPlayerTeamEx(playerid);
	g_org_storage_open[team] = !g_org_storage_open[team];

	new fmt_msg[100];
	format(fmt_msg, sizeof fmt_msg, "%s %s склад организации", GetPlayerNameEx(playerid),
		g_org_storage_open[team] ? ("открыл") : ("закрыл"));
	SendMessageInLocal(playerid, fmt_msg, 0xFFCC00FF, 30.0);

	return 1;
}

// используйте эту функцию в проверке доступа к физической точке склада/оружейки организации,
// если такая точка привязана к конкретной фракции: if(!IsOrgStorageOpen(team)) return ...;
stock bool: IsOrgStorageOpen(org_id)
{
	if(!(1 <= org_id < MAX_ORG)) return false;
	return g_org_storage_open[org_id];
}

// ---------------------------------------------------------------------
// ТЕХНИКА ОРГАНИЗАЦИИ (информация + GPS до точки, спавн остаётся через существующий пикап)
// ---------------------------------------------------------------------
stock ShowOrgMenuVehicles(playerid)
{
	if(!HasOrgRight(playerid, ORG_RIGHT_VEHICLE))
		return SendClientMessage(playerid, 0x999999FF, "У Вас нет доступа к технике организации");

	new team = GetPlayerTeamEx(playerid);
	new list[600];
	new found = false;

	format(list, sizeof list, "Модель\n");

	for(new i = 0; i < sizeof g_org_car; i ++)
	{
		if(g_org_car[i][O_FRAC_ID] != team) continue;

		found = true;
		new model_name[64], line_str[80];

		for(new m = 0; m < 4; m ++)
		{
			if(g_org_car[i][O_MODEL][m] == 0) continue;
			GetVehicleModelName(g_org_car[i][O_MODEL][m], model_name, sizeof model_name);
			format(line_str, sizeof line_str, "%s\n", model_name);
			strcat(list, line_str);
		}

		EnablePlayerGPS(playerid, 56, g_org_car[i][O_PICKUP][0], g_org_car[i][O_PICKUP][1], g_org_car[i][O_PICKUP][2],
			"На карте отмечена точка получения техники организации");
	}

	if(!found)
	{
		SendClientMessage(playerid, 0x999999FF, "У Вашей организации нет привязанной техники");
		return 1;
	}

	// MSGBOX, т.к. это только информация: не требует отдельного listitem-обработчика,
	// "Назад" (response == 0) обрабатывается в org_menu_dialogs.inc
	Dialog(playerid, DIALOG_ORGMENU_VEHICLES, DIALOG_STYLE_MSGBOX, "Техника организации", list, "Ок", "Назад");
	return 1;
}

// ---------------------------------------------------------------------
// НАСТРОЙКА ПРАВ РАНГОВ (только лидер)
// ---------------------------------------------------------------------
stock ShowOrgMenuRangSelect(playerid)
{
	if(!IsOrgLeader(playerid))
		return SendClientMessage(playerid, 0x999999FF, "Настройка прав доступна только лидеру организации");

	new team = GetPlayerTeamEx(playerid);
	new list[300], line_str[60];

	for(new r = 1; r <= 9; r ++) // 10-й ранг -- сам лидер, ему права не нужны
	{
		format(line_str, sizeof line_str, "%s\n", rank_names[team - 1][r - 1]);
		strcat(list, line_str);
	}

	Dialog(playerid, DIALOG_ORGMENU_RIGHTS_RANG, DIALOG_STYLE_LIST, "Выберите ранг", list, "Выбрать", "Назад");
	return 1;
}

stock ShowOrgMenuRightsToggle(playerid)
{
	if(!IsOrgLeader(playerid))
		return SendClientMessage(playerid, 0x999999FF, "Настройка прав доступна только лидеру организации");

	new team = GetPlayerTeamEx(playerid);
	new rang = g_orgm_edit_rang[playerid];

	new list[500], line_str[80];

	for(new r = 0; r < ORG_RIGHT_NUM; r ++)
	{
		format(line_str, sizeof line_str, "[%s] %s\n", g_org_rang_access[team][rang][r] ? ("X") : (" "), g_org_right_name[r]);
		strcat(list, line_str);
	}

	new caption[80];
	format(caption, sizeof caption, "Права: %s", rank_names[team - 1][rang - 1]);

	Dialog(playerid, DIALOG_ORGMENU_RIGHTS_TOGGLE, DIALOG_STYLE_LIST, caption, list, "Переключить", "Назад");
	return 1;
}
