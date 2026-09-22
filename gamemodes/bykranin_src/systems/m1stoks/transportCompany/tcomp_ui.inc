//>> Файл: bykranin_src/systems/m1stoks/transportCompany/tcomp_ui.inc  (1144 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: TC_ShowMainMenu, TC_ShowInfo, TC_OnInfoLoaded, TC_ShowFleetList, TC_ShowFleetVehicleMenu, TC_ShowFleetRepairConfirm, TC_ShowFleetRentPriceDialog
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: modules/m1stoks/transportCompany/tcomp_ui.inc
#if defined _tcomp_ui_included
	#endinput
#endif
#define _tcomp_ui_included

forward TC_OnEmployeesLoaded(playerid, mode, page);
forward TC_OnRatingLoaded(playerid, mode);
forward TC_OnPersonalLoaded(playerid);
forward TC_OnFinanceDetailLoaded(playerid, mode);

stock TC_ShowMainMenu(playerid)
{
	DeletePVar(playerid, "TCDepositCompany");
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Вы не состоите в транспортной компании.");
		return 0;
	}

	new fmt_str[512];
	format(fmt_str, sizeof fmt_str,
		"Информация\n\
Автопарк\n\
Управление\n\
Сотрудники\n\
Финансовая статистика\n\
Личная карточка\n\
Улучшение\n\
Помощь");

	if(!TC_IsCompanyOwner(playerid, company_idx))
		strcat(fmt_str, "\n{FFFF24}Покинуть компанию", sizeof fmt_str);
	strcat(fmt_str, "\nПополнить баланс компании", sizeof fmt_str);

	Dialog(playerid, DIALOG_TC_MAIN_MENU, DIALOG_STYLE_LIST, TC_TITLE, fmt_str, "Далее", "Выйти");
	return 1;
}

stock TC_ShowInfo(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	new query[256];
	mysql_format(mysql, query, sizeof query,
		"SELECT (SELECT COUNT(*) FROM tc_employees WHERE company_id=%d) AS emp_cnt, \
		(SELECT IFNULL(SUM(orders_done),0) FROM tc_employees WHERE company_id=%d) AS orders_sum",
		g_tc_companies[company_idx][TC_SQL_ID], g_tc_companies[company_idx][TC_SQL_ID]);
	mysql_tquery(mysql, query, "TC_OnInfoLoaded", "d", playerid);
	return 1;
}

public TC_OnInfoLoaded(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	new emp_cnt, orders_sum;
	if(cache_num_rows())
	{
		emp_cnt = cache_get_field_content_int(0, "emp_cnt");
		orders_sum = cache_get_field_content_int(0, "orders_sum");
	}

	new owner[24];
	TC_GetOwnerDisplayName(company_idx, owner, sizeof owner);

	new fleet_cnt = TC_GetFleetCountForCompany(g_tc_companies[company_idx][TC_SQL_ID]);
	new cname[48];
	TC_GetCompanyDisplayName(company_idx, cname, sizeof cname);

	new fmt_str[640];
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Название компании: {FFFF24}%s{FFFFFF}\n\
Владелец компании: {FFFF24}%s{FFFFFF}\n\
Количество сотрудников: {FFFF24}%d шт.{FFFFFF}\n\
Комиссия компании: {FFFF24}%d процентов{FFFFFF}\n\
Рейтинг компании: {FFFF24}%d шт.{FFFFFF}\n\
Количество выполненных заказов: {FFFF24}%d шт.{FFFFFF}\n\
Количество машин в компании: {FFFF24}%d шт.{FFFFFF}\n\
'Лучшая компания дня': {FFFF24}%d шт.{FFFFFF}\n\
'Лучшая компания недели': {FFFF24}%d шт.",
		cname,
		owner,
		emp_cnt,
		g_tc_companies[company_idx][TC_COMMISSION],
		g_tc_company_rating[company_idx],
		orders_sum,
		fleet_cnt,
		0,
		0);

	Dialog(playerid, DIALOG_TC_INFO, DIALOG_STYLE_MSGBOX, "{FFFF24}Информация", fmt_str, "Назад", "");
	return 1;
}

stock TC_ShowFleetList(playerid, page = 0)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	new company_sql = g_tc_companies[company_idx][TC_SQL_ID];
	new body[1024];
	new row_offset = 0;

	format(body, sizeof body, "{FFFF24}Транспорт\tРейсов до Т/О\tСтоимость аренды\tИспользование\n");

	if(page > 0)
	{
		strcat(body, "{FFFF24}<< Предыдущая страница\n");
		row_offset = 1;
	}

	new shown, skipped;
	new page_start = page * TC_FLEET_PAGE_SIZE;

	for(new i = 0; i < g_tc_fleet_loaded; i++)
	{
		if(g_tc_fleet[i][TF_COMPANY_ID] != company_sql) continue;
		if(skipped < page_start) { skipped++; continue; }
		if(shown >= TC_FLEET_PAGE_SIZE) break;

		new usage[24];
		TC_GetFleetUsageText(i, usage, sizeof usage);

		new tc_line[160];
		format(tc_line, sizeof tc_line, "{FFFFFF}%s\t%d\t%d руб.\t%s\n",
			g_tc_fleet_name[i], g_tc_fleet[i][TF_TRIPS_LEFT], g_tc_fleet[i][TF_RENT_PRICE], usage);
		strcat(body, tc_line);
		SetPlayerListitemValue(playerid, shown + row_offset + 1, i);
		shown++;
	}

	if(shown == 0)
		strcat(body, "{FFFFFF}Автопарк пуст\t-\t-\t-\n");

	new total = TC_GetFleetCountForCompany(company_sql);
	if((page + 1) * TC_FLEET_PAGE_SIZE < total)
		strcat(body, "{FFFF24}Следующая страница >>\n");

	if(TC_IsCompanyOwner(playerid, company_idx))
		strcat(body, "{FFFF24}Купить транспорт\n");

	p_tc_fleet_page[playerid] = page;

	new title[56];
	format(title, sizeof title, "{FFFF24}Список автопарка страница %d", page + 1);
	Dialog(playerid, DIALOG_TC_FLEET_LIST, DIALOG_STYLE_TABLIST_HEADERS, title, body, "Выбрать", "Закрыть");
	return 1;
}

stock TC_ShowFleetVehicleMenu(playerid, fleet_idx)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;
	if(fleet_idx < 0 || fleet_idx >= g_tc_fleet_loaded) return 0;

	p_tc_fleet_sel[playerid] = fleet_idx;

	if(!TC_IsCompanyOwner(playerid, company_idx))
	{
		new usage[24];
		TC_GetFleetUsageText(fleet_idx, usage, sizeof usage);

		new fmt_str[320];
		format(fmt_str, sizeof fmt_str,
			"{FFFFFF}Транспорт: {FFFF24}%s{FFFFFF}\n\
Состояние: {FFFF24}%s{FFFFFF}\n\
Рейсов до Т/О: {FFFF24}%d / %d{FFFFFF}\n\
Стоимость аренды: {FFFF24}%d руб.{FFFFFF}",
			g_tc_fleet_name[fleet_idx], usage,
			g_tc_fleet[fleet_idx][TF_TRIPS_LEFT], g_tc_fleet[fleet_idx][TF_TRIPS_MAX],
			g_tc_fleet[fleet_idx][TF_RENT_PRICE]);

		Dialog(playerid, DIALOG_TC_FLEET_MANAGE, DIALOG_STYLE_MSGBOX, "{FFFF24}Транспорт", fmt_str, "Назад", "");
		return 1;
	}

	new fmt_str[128];
	format(fmt_str, sizeof fmt_str,
		"Провести Т/О\n\
Изменить стоимость аренды\n\
Продажа машины");

	Dialog(playerid, DIALOG_TC_FLEET_MANAGE, DIALOG_STYLE_LIST, "{FFFF24}Меню машины", fmt_str, "Далее", "Назад");
	return 1;
}

stock TC_ShowFleetRepairConfirm(playerid)
{
	new fmt_str[256];
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Чтобы использовать грузовик Вам нужно проводить Т/О.\n\
Стоимость Т/О ровняется {FFFF24}%d{FFFFFF} рублей.",
		TC_REPAIR_PRICE);

	Dialog(playerid, DIALOG_TC_FLEET_REPAIR, DIALOG_STYLE_MSGBOX, "{FFFF24}Техническое обслуживание", fmt_str, "Далее", "Назад");
	return 1;
}

stock TC_ShowFleetRentPriceDialog(playerid)
{
	new fmt_str[320];
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Введите стоимость аренды грузовика которую сотрудник будет оплачивать при каждой аренде:\n\
(мин. {FFFF24}%d{FFFFFF} руб., макс. {FFFF24}%d{FFFFFF} руб.)",
		TC_RENT_PRICE_MIN, TC_RENT_PRICE_MAX);

	Dialog(playerid, DIALOG_TC_FLEET_RENTPRICE, DIALOG_STYLE_INPUT, "{FFFF24}Цена за аренду", fmt_str, "Далее", "Назад");
	return 1;
}

stock TC_ShowFleetSellConfirm(playerid, fleet_idx)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || fleet_idx < 0 || fleet_idx >= g_tc_fleet_loaded) return 0;

	new refund = TC_GetFleetSellRefund(g_tc_fleet[fleet_idx][TF_MODEL_ID]);
	new fmt_str[256];
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Продать {FFFF24}%s{FFFFFF}?\n\
В кассу компании вернётся {FFFF24}%d{FFFFFF} руб.\n\n\
Транспорт нельзя продать, пока он арендован.",
		g_tc_fleet_name[fleet_idx], refund);

	p_tc_fleet_sel[playerid] = fleet_idx;
	Dialog(playerid, DIALOG_TC_FLEET_SELL_VEH, DIALOG_STYLE_MSGBOX, "{FFFF24}Продажа машины", fmt_str, "Далее", "Назад");
	return 1;
}

stock TC_ShowFleetManage(playerid, fleet_idx)
{
	return TC_ShowFleetVehicleMenu(playerid, fleet_idx);
}

stock TC_ShowManageMenu(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;
	if(!TC_IsCompanyOwner(playerid, company_idx))
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Раздел доступен только владельцу компании.");
		return 0;
	}

	new fmt_str[256];
	format(fmt_str, sizeof fmt_str,
		"Снять деньги\n\
Изменить название компании\n\
Изменить процент комиссии\n\
Уволить игрока\n\
{FFFF24}Закрыть компанию");

	Dialog(playerid, DIALOG_TC_MANAGE, DIALOG_STYLE_LIST, "{FFFF24}Управление", fmt_str, "Выбрать", "Назад");
	return 1;
}

stock TC_ShowWithdrawDialog(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	new fmt_str[256];
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Введите число денег, которые вы желаете снять.\n\
Комиссия на снятие: {FFFF24}%d процента{FFFFFF}\n\
Текущее число денег: {FFFF24}%d рублей",
		TC_WITHDRAW_FEE_PERCENT, g_tc_companies[company_idx][TC_BALANCE]);

	Dialog(playerid, DIALOG_TC_WITHDRAW, DIALOG_STYLE_INPUT, "{FFFF24}Снятие денег с компании", fmt_str, "Далее", "Назад");
	return 1;
}

stock TC_ShowRenameDialog(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	new cname[48];
	TC_GetCompanyDisplayName(company_idx, cname, sizeof cname);

	new fmt_str[512];
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Название компании – первое, с чем сталкиваются заказчики.\n\
Текущее название: {FFFF24}%s{FFFFFF}.\n\n\
Менять название можно {FFFF24}1 раз в 7 дней{FFFFFF}, стоимость: {FFFF24}%d рублей{FFFFFF}.\n\n\
{FFFFFF}Только английские буквы (A-Z), цифры, пробел и _.\n\
Введите новое название компании:",
		cname, TC_RENAME_PRICE);

	Dialog(playerid, DIALOG_TC_RENAME, DIALOG_STYLE_INPUT, "{FFFF24}Изменить название", fmt_str, "Далее", "Назад");
	return 1;
}

stock TC_ShowCommissionDialog(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	new fmt_str[256];
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Комиссия – процент, который компания удерживает с заказа водителя.\n\
Текущая комиссия: {FFFF24}%d%%{FFFFFF}\n\n\
Введите новый процент (%d - %d):",
		g_tc_companies[company_idx][TC_COMMISSION], TC_COMMISSION_MIN, TC_COMMISSION_MAX);

	Dialog(playerid, DIALOG_TC_COMMISSION, DIALOG_STYLE_INPUT, "{FFFF24}Процент комиссии", fmt_str, "Далее", "Назад");
	return 1;
}

stock TC_ShowFireDialog(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	Dialog(playerid, DIALOG_TC_FIRE, DIALOG_STYLE_INPUT, "{FFFF24}Увольнение сотрудника",
		"{FFFFFF}Для увольнения сотрудника введите его ID или имя в поле ниже:\n\
Пример: {FFFF24}144{FFFFFF} или {FFFF24}Persona_Persona",
		"Далее", "Назад");
	return 1;
}

stock TC_ShowFireConfirm(playerid)
{
	new fmt_str[128];
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Вы действительно хотите уволить данного игрока из компании??\n\n\
Сотрудник: {FFFF24}%s{FFFFFF}",
		p_tc_fire_target[playerid]);

	Dialog(playerid, DIALOG_TC_FIRE_CONFIRM, DIALOG_STYLE_MSGBOX, "{FFFF24}Увольнение игрока", fmt_str, "Далее", "Назад");
	return 1;
}

stock TC_ShowBuyDialog(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	new fmt_str[192];
	format(fmt_str, sizeof fmt_str,
		"{FFFF24}Транспорт\t{FFFF24}Цена\n\
{FFFFFF}Mercedes-Benz Sprinter\t{FFFFFF}%d\n",
		TC_BUY_VAN_PRICE);

	Dialog(playerid, DIALOG_TC_BUY, DIALOG_STYLE_TABLIST_HEADERS, "{FFFF24}Покупка транспорта", fmt_str, "Купить", "Назад");
	return 1;
}

stock TC_ShowSellConfirm(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	new refund = g_tc_companies[company_idx][TC_BALANCE] * TC_SELL_REFUND_PERCENT / 100;
	new fmt_str[256];
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Вы уверены, что хотите закрыть компанию?\n\
Все сотрудники будут уволены, автопарк удалён.\n\
Возврат из кассы (%d%%): {FFFF24}%d руб.",
		TC_SELL_REFUND_PERCENT, refund);

	Dialog(playerid, DIALOG_TC_SELL, DIALOG_STYLE_MSGBOX, "{FFFF24}Закрытие компании", fmt_str, "Закрыть", "Отмена");
	return 1;
}

stock TC_ShowEmployeesMenu(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	Dialog(playerid, DIALOG_TC_EMPLOYEES, DIALOG_STYLE_LIST, "{FFFF24}Сотрудники",
		"Список сотрудников\nРейтинг сотрудников", "Далее", "Назад");
	return 1;
}

stock TC_ShowEmpListSubmenu(playerid)
{
	Dialog(playerid, DIALOG_TC_EMP_SUBMENU, DIALOG_STYLE_LIST, "{FFFF24}Сотрудники",
		"Список сотрудников в игре\nСписок сотрудников не в игре\nОбщий список", "Далее", "Назад");
	return 1;
}

stock TC_ShowEmpRatingMenu(playerid)
{
	Dialog(playerid, DIALOG_TC_EMP_RATING_MENU, DIALOG_STYLE_LIST, "{FFFF24}Рейтинг сотрудников",
		"Рейтинг сотрудников за день\nРейтинг сотрудников за неделю\nРейтинг сотрудников за все время\nПомощь по рейтингу",
		"Далее", "Назад");
	return 1;
}

stock TC_ShowRatingHelp(playerid)
{
	Dialog(playerid, DIALOG_TC_RATING_HELP, DIALOG_STYLE_MSGBOX, "{FFFF24}Помощь по рейтингу",
		"{FFFFFF}Рейтинг складывается из двух факторов: перевозки и повреждения груза.\n\
За рейс можно получить максимум {FFFF24}10{FFFFFF} баллов.\n\
За доставку: {FFFF24}4{FFFFFF} балла, за отсутствие повреждений: {FFFF24}6{FFFFFF} баллов.\n\
Повреждение груза снижает рейтинг на {FFFF24}1–10{FFFFFF} баллов.\n\n\
Рейтинг за день обнуляется ежедневно в {FFFF24}00:00{FFFFFF} (МСК).\n\
Рейтинг за неделю обнуляется каждое {FFFF24}воскресенье в 00:00{FFFFFF} (МСК).",
		"Назад", "");
	return 1;
}

stock TC_RequestRatingList(playerid, mode)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	p_tc_emp_view_mode[playerid] = mode + 10;

	new query[384];
	new company_sql = g_tc_companies[company_idx][TC_SQL_ID];
	new owner_id = g_tc_companies[company_idx][TC_OWNER_ID];
	new order_field[16];

	switch(mode)
	{
		case 0: format(order_field, sizeof order_field, "tc_rating_day");
		case 1: format(order_field, sizeof order_field, "tc_rating_week");
		default: format(order_field, sizeof order_field, "tc_rating");
	}

	mysql_format(mysql, query, sizeof query,
		"SELECT a.name AS pname, a.%e AS prating FROM tc_employees te \
		JOIN accounts a ON a.id=te.account_id \
		WHERE te.company_id=%d AND te.account_id!=%d \
		ORDER BY prating DESC LIMIT 50",
		order_field, company_sql, owner_id);
	mysql_tquery(mysql, query, "TC_OnRatingLoaded", "dd", playerid, mode);
	return 1;
}

public TC_OnRatingLoaded(playerid, mode)
{
	new body[1536];
	format(body, sizeof body, "{FFFF24}Имя\tРейтинг\n");

	new rows = cache_num_rows();
	if(!rows) strcat(body, "{FFFFFF}Нет данных\t-\n");
	for(new i = 0; i < rows; i++)
	{
		new name[24];
		cache_get_field_content(i, "pname", name, mysql, 24);
		new rating = cache_get_field_content_int(i, "prating");

		new eline[80];
		format(eline, sizeof eline, "{FFFFFF}%s\t%d\n", name, rating);
		strcat(body, eline);
	}

	new title[48];
	switch(mode)
	{
		case 0: format(title, sizeof title, "{FFFF24}Рейтинг игроков за день");
		case 1: format(title, sizeof title, "{FFFF24}Рейтинг игроков за неделю");
		default: format(title, sizeof title, "{FFFF24}Рейтинг игроков за все время");
	}

	Dialog(playerid, DIALOG_TC_EMP_RATING_LIST, DIALOG_STYLE_TABLIST_HEADERS, title, body, "Назад", "");
	return 1;
}

stock TC_ShowEmployeesInGame(playerid, page = 0)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	p_tc_emp_view_mode[playerid] = 0;
	p_tc_emp_page[playerid] = page;

	new owner_id = g_tc_companies[company_idx][TC_OWNER_ID];
	new body[1536];
	format(body, sizeof body, "{FFFF24}Имя сотрудника\tРейтинг\tСтатус\n");

	new shown, skipped;
	new page_start = page * TC_EMPLOYEE_PAGE_SIZE;

	foreach(new i : Player)
	{
		if(!IsPlayerLogged(i)) continue;
		if(p_tc_company[i] != company_idx) continue;
		if(GetPlayerAccountID(i) == owner_id) continue;

		if(skipped < page_start) { skipped++; continue; }
		if(shown >= TC_EMPLOYEE_PAGE_SIZE) break;

		new name[32];
		format(name, sizeof name, "%s[%d]", GetPlayerNameEx(i), i);
		format(p_tc_emp_row_name[playerid][shown], 24, "%s", GetPlayerNameEx(i));
		new status[24];
		format(status, sizeof status, (p_tc_active_order[i] != -1) ? ("На рейсе") : ("Не на рейсе"));

		new eline[128];
		format(eline, sizeof eline, "{FFFFFF}%s\t%d\t%s\n", name, p_tc_rating[i], status);
		strcat(body, eline);
		SetPlayerListitemValue(playerid, shown + 1, shown);
		shown++;
	}
	if(!shown && !page) strcat(body, "{FFFFFF}Нет сотрудников в игре\t-\t-\n");

	new total;
	foreach(new i : Player)
	{
		if(!IsPlayerLogged(i)) continue;
		if(p_tc_company[i] != company_idx) continue;
		if(GetPlayerAccountID(i) == owner_id) continue;
		total++;
	}
	p_tc_emp_list_shown[playerid] = shown;
	p_tc_emp_total[playerid] = total;
	if((page + 1) * TC_EMPLOYEE_PAGE_SIZE < total)
		strcat(body, "{FFFF24}Следующая страница >>\n");

	new title[56];
	format(title, sizeof title, "{FFFF24}Список online игроков страница: %d", page + 1);
	Dialog(playerid, DIALOG_TC_EMP_LIST, DIALOG_STYLE_TABLIST_HEADERS, title, body, "Далее", "Назад");
	return 1;
}

stock TC_ShowEmployeesDB(playerid, mode, page = 0)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	p_tc_emp_view_mode[playerid] = mode;
	p_tc_emp_page[playerid] = page;

	new query[512];
	new company_sql = g_tc_companies[company_idx][TC_SQL_ID];
	new owner_id = g_tc_companies[company_idx][TC_OWNER_ID];

	if(mode == 2)
	{
		mysql_format(mysql, query, sizeof query,
			"SELECT a.name AS pname, a.tc_rating AS prating, IFNULL(a.tc_rating_day,0) AS prday, \
			a.last_login AS plast FROM tc_employees te \
			JOIN accounts a ON a.id=te.account_id \
			WHERE te.company_id=%d AND a.tc_company_id=%d AND te.account_id!=%d \
			ORDER BY a.tc_rating DESC LIMIT 50",
			company_sql, company_sql, owner_id);
	}
	else
	{
		mysql_format(mysql, query, sizeof query,
			"SELECT a.name AS pname, a.tc_rating AS prating, a.last_login AS plast FROM tc_employees te \
			JOIN accounts a ON a.id=te.account_id \
			WHERE te.company_id=%d AND a.tc_company_id=%d AND te.account_id!=%d \
			ORDER BY a.tc_rating DESC LIMIT 50",
			company_sql, company_sql, owner_id);
	}
	mysql_tquery(mysql, query, "TC_OnEmployeesLoaded", "ddd", playerid, mode, page);
	return 1;
}

public TC_OnEmployeesLoaded(playerid, mode, page)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	new rows = cache_num_rows();
	new body[2048];
	new shown, skipped;
	new page_start = page * TC_EMPLOYEE_PAGE_SIZE;

	if(mode == 2)
		format(body, sizeof body, "{FFFF24}Имя\tПоследний вход\tРейтинг\tРейтинг сегодня\n");
	else
		format(body, sizeof body, "{FFFF24}Имя\tРейтинг\n");

	for(new i = 0; i < rows; i++)
	{
		new name[24];
		cache_get_field_content(i, "pname", name, mysql, 24);
		new rating = cache_get_field_content_int(i, "prating");

		new online = (GetPlayerID(name) != INVALID_PLAYER_ID);
		if(mode == 1 && online) continue;

		if(skipped < page_start) { skipped++; continue; }
		if(shown >= TC_EMPLOYEE_PAGE_SIZE) break;

		format(p_tc_emp_row_name[playerid][shown], 24, "%s", name);

		if(mode == 2)
		{
			new last_login = cache_get_field_content_int(i, "plast");
			new rday = cache_get_field_content_int(i, "prday");
			new last_date[6];
			timestamp_to_date(last_login, last_date[2], last_date[1], last_date[0], last_date[3], last_date[4], last_date[5]);

			new date_str[32];
			format(date_str, sizeof date_str, "%02d.%02d.%04d - %02d:%02d:%02d",
				last_date[0], last_date[1], last_date[2], last_date[3], last_date[4], last_date[5]);

			new eline[160];
			format(eline, sizeof eline, "{FFFFFF}%s\t%s\t%d\t%d\n", name, date_str, rating, rday);
			strcat(body, eline);
		}
		else
		{
			new eline[80];
			format(eline, sizeof eline, "{FFFFFF}%s\t%d\n", name, rating);
			strcat(body, eline);
		}
		SetPlayerListitemValue(playerid, shown + 1, shown);
		shown++;
	}

	if(!shown && !page)
	{
		if(mode == 2) strcat(body, "{FFFFFF}Нет записей\t-\t-\t-\n");
		else strcat(body, "{FFFFFF}Нет записей\t-\n");
	}

	new total_off = 0;
	for(new i = 0; i < rows; i++)
	{
		new name[24];
		cache_get_field_content(i, "pname", name, mysql, 24);
		if(mode == 1 && GetPlayerID(name) != INVALID_PLAYER_ID) continue;
		total_off++;
	}
	p_tc_emp_list_shown[playerid] = shown;
	p_tc_emp_total[playerid] = total_off;
	if((page + 1) * TC_EMPLOYEE_PAGE_SIZE < total_off)
		strcat(body, "{FFFF24}Следующая страница >>\n");

	new title[56];
	format(title, sizeof title, "{FFFF24}Список offline игроков страница: %d", page + 1);

	if(mode == 2)
		Dialog(playerid, DIALOG_TC_EMP_LIST, DIALOG_STYLE_TABLIST_HEADERS, title, body, "Выбрать", "Закрыть");
	else
		Dialog(playerid, DIALOG_TC_EMP_LIST, DIALOG_STYLE_TABLIST_HEADERS, title, body, "Выбрать", "Закрыть");
	return 1;
}

stock TC_ShowFinance(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	Dialog(playerid, DIALOG_TC_FINANCE, DIALOG_STYLE_LIST, "{FFFF24}Финансовая статистика",
		"Деньги с аренды\nДеньги с перевозок\nЗатраты\nПополнения участниками", "Далее", "Назад");
	return 1;
}

stock TC_RequestFinanceDetail(playerid, mode)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	p_tc_finance_mode[playerid] = mode;
	new since = gettime() - (TC_FINANCE_DAYS * 86400);
	new query[384];
	mysql_format(mysql, query, sizeof query,
		"SELECT DAY(FROM_UNIXTIME(created_at)) AS d, SUM(amount) AS s FROM tc_finance \
		WHERE company_id=%d AND type=%d AND created_at>=%d \
		GROUP BY DATE(FROM_UNIXTIME(created_at)) ORDER BY created_at DESC LIMIT %d",
		g_tc_companies[company_idx][TC_SQL_ID], mode, since, TC_FINANCE_DAYS);
	mysql_tquery(mysql, query, "TC_OnFinanceDetailLoaded", "dd", playerid, mode);
	return 1;
}

public TC_OnFinanceDetailLoaded(playerid, mode)
{
	new body[2048];
	format(body, sizeof body, "{FFFF24}Дата\tПрибыль\n");

	new rows = cache_num_rows();
	if(!rows)
		strcat(body, "{FFFFFF}-\t0 руб\n");
	for(new i = 0; i < rows; i++)
	{
		new day = cache_get_field_content_int(i, "d");
		new sum = cache_get_field_content_int(i, "s");
		if(mode == TC_FIN_EXPENSE) sum = -sum;

		new eline[64];
		format(eline, sizeof eline, "{FFFFFF}%02d\t%d руб\n", day, sum);
		strcat(body, eline);
	}

	Dialog(playerid, DIALOG_TC_FINANCE_DETAIL, DIALOG_STYLE_TABLIST_HEADERS,
		"{FFFF24}Доход компании за 20 дней", body, "Назад", "Закрыть");
	return 1;
}

stock TC_ShowPersonal(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	new query[320];
	mysql_format(mysql, query, sizeof query,
		"SELECT te.orders_done, IFNULL(a.tc_rating_day,0) AS rday, IFNULL(a.tc_rating_week,0) AS rweek, \
		IFNULL(a.tc_rating,0) AS rt FROM tc_employees te \
		JOIN accounts a ON a.id=te.account_id \
		WHERE te.company_id=%d AND te.account_id=%d LIMIT 1",
		g_tc_companies[company_idx][TC_SQL_ID], GetPlayerAccountID(playerid));
	mysql_tquery(mysql, query, "TC_OnPersonalLoaded", "d", playerid);
	return 1;
}

public TC_OnPersonalLoaded(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	new orders_done, rday, rweek, rt;
	if(cache_num_rows())
	{
		orders_done = cache_get_field_content_int(0, "orders_done");
		rday = cache_get_field_content_int(0, "rday");
		rweek = cache_get_field_content_int(0, "rweek");
		rt = cache_get_field_content_int(0, "rt");
	}

	new name[24];
	GetPlayerName(playerid, name, sizeof name);

	new cname[48];
	TC_GetCompanyDisplayName(company_idx, cname, sizeof cname);

	new fmt_str[640];
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Имя сотрудника: {FFFF24}%s{FFFFFF}\n\
Транспортная компания: {FFFF24}%s{FFFFFF}\n\
Рейтинг сегодня: {FFFF24}%d{FFFFFF}\n\
Рейтинг недельный: {FFFF24}%d{FFFFFF}\n\
Рейтинг за все время: {FFFF24}%d{FFFFFF}\n\
Выполненных рейсов: {FFFF24}%d шт.{FFFFFF}\n\
Лучший водитель дня: {FFFF24}%d шт.{FFFFFF}\n\
Лучший водитель недели: {FFFF24}%d шт.",
		name, cname,
		rday, rweek, rt, orders_done, 0, 0);

	Dialog(playerid, DIALOG_TC_PERSONAL, DIALOG_STYLE_MSGBOX, "{FFFF24}Личная карточка", fmt_str, "Назад", "");
	return 1;
}

stock TC_ShowUpgrade(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;
	if(!TC_IsCompanyOwner(playerid, company_idx))
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Улучшения доступны только владельцу компании.");
		return 0;
	}

	new price_office[16], price_garage[16], price_license[16];
	TC_FormatMoneyBR(TC_UPGRADE_OFFICE_PRICE, price_office, sizeof price_office);
	TC_FormatMoneyBR(TC_UPGRADE_GARAGE_PRICE, price_garage, sizeof price_garage);
	TC_FormatMoneyBR(TC_UPGRADE_LICENSE_PRICE, price_license, sizeof price_license);

	new cost_office[24], cost_garage[24], cost_license[24];
	if(TC_CompanyHasUpgrade(company_idx, TC_UPGRADE_OFFICE))
		format(cost_office, sizeof cost_office, "Куплено");
	else
		format(cost_office, sizeof cost_office, "%s", price_office);
	if(TC_CompanyHasUpgrade(company_idx, TC_UPGRADE_GARAGE))
		format(cost_garage, sizeof cost_garage, "Куплено");
	else
		format(cost_garage, sizeof cost_garage, "%s", price_garage);
	if(TC_CompanyHasUpgrade(company_idx, TC_UPGRADE_LICENSE))
		format(cost_license, sizeof cost_license, "Куплено");
	else
		format(cost_license, sizeof cost_license, "%s", price_license);

	new fmt_str[384];
	format(fmt_str, sizeof fmt_str,
		"{FFFF24}Пункт\t{FFFF24}Стоимость\n\
{FFFFFF}Покупка нового офиса\t{FFFFFF}%s\n\
{FFFFFF}Покупка новых мест в гараже\t{FFFFFF}%s\n\
{FFFFFF}Покупка лицензий на транспортировку\t{FFFFFF}%s",
		cost_office, cost_garage, cost_license);

	Dialog(playerid, DIALOG_TC_UPGRADE, DIALOG_STYLE_TABLIST_HEADERS, "{FFFF24}Улучшения", fmt_str, "Далее", "Назад");
	return 1;
}

stock TC_ShowUpgradeConfirm(playerid, upgrade_type)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	if(TC_CompanyHasUpgrade(company_idx, upgrade_type))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Это улучшение уже приобретено.");
		TC_ShowUpgrade(playerid);
		return 0;
	}

	p_tc_upgrade_sel[playerid] = upgrade_type;
	new fmt_str[768];

	switch(upgrade_type)
	{
		case TC_UPGRADE_OFFICE:
			format(fmt_str, sizeof fmt_str,
				"{FFFFFF}Покупка нового офиса - отличный способ увеличить рабочий персонал Вашей компании!\n\
В новом офисе смогут находиться больше сотрудников, а значит прибыль Вашей компании вырастет.\n\
Конечно, для этого Вам нужны дополнительные фуры, так что не забудьте приобрести и новые места в гараже компании!\n\
Покупая данное улучшение, Вы получите: {FFFF24}150 рабочих мест{FFFFFF} за {FFFF24}50.000{FFFFFF} рублей!");
		case TC_UPGRADE_GARAGE:
			format(fmt_str, sizeof fmt_str,
				"{FFFFFF}Покупка новых мест в гараже - увеличение числа транспорта, работающего на компанию!\n\
Чем больше транспорт - тем активнее идет работа, чем активнее идет работа - тем больше денег получит владелец компании!\n\
Не скупитесь на покупку новых машин для своих сотрудников - они помогут Вам стать богаче!\n\n\
Для покупки этого улучшения Вам понадобится {FFFF24}1.000.000{FFFFFF} рублей\n\n\
Приобретя это улучшение Вы получите дополнительные {FFFF24}20 мест{FFFFFF} в автопарк компании!");
		case TC_UPGRADE_LICENSE:
			format(fmt_str, sizeof fmt_str,
				"{FFFFFF}Покупка новых лицензий для транспортировки - отличное решение, чтобы повысить капитализацию своей компании!\n\
Новые лицензии - новые заказы, новые заказы - больше денег! Всё просто!\n\
Приобретая эти лицензии Вы сможете перевозить {FFFF24}продукты, топливо, оружие{FFFFFF}, всем бизнесам которые только есть!\n\
Для покупки этого улучшения Вам необходимо {FFFF24}2.000.000{FFFFFF} рублей");
		default: return 0;
	}

	new title[48];
	switch(upgrade_type)
	{
		case TC_UPGRADE_OFFICE: format(title, sizeof title, "{FFFF24}Покупка нового офиса");
		case TC_UPGRADE_GARAGE: format(title, sizeof title, "{FFFF24}Улучшение автопарка");
		case TC_UPGRADE_LICENSE: format(title, sizeof title, "{FFFF24}Покупка лицензии");
	}

	Dialog(playerid, DIALOG_TC_UPGRADE_CONFIRM, DIALOG_STYLE_MSGBOX, title, fmt_str, "Далее", "Назад");
	return 1;
}

stock TC_ShowHelp(playerid)
{
	Dialog(playerid, DIALOG_TC_HELP, DIALOG_STYLE_MSGBOX, "{FFFF24}VING RUSSIA | Транспортные компании",
		"{FFFFFF}Команды:\n\
{FFFF24}/company{FFFFFF} — основное меню компании\n\
{FFFF24}/orders{FFFFFF} — список заказов компании\n\
{FFFF24}/cargo{FFFFFF} — прицеп для тягача\n\
{FFFF24}/tc [текст]{FFFFFF} — чат дальнобойщиков\n\n\
{FFFFFF}Описание системы:\n\
Устройство на работу доступно в главных офисах в {FFFF24}пгт. Батурево{FFFFFF} и {FFFF24}п. Бусаево{FFFFFF}.\n\
Для работы нужны уровень, мед. карта и профессиональные лицензии.\n\
Арендуйте фуру на парковке ТК, затем в офисе возьмите заказ.\n\
Заказы делятся на классы: обычные, хрупкие, ценные и нелегальные.\n\
Доступ к заказам зависит от рейтинга — смотрите его в {FFFF24}/company{FFFFFF}.",
		"Назад", "");
	return 1;
}

stock TC_ShowLeaveConfirm(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx != -1 && TC_IsCompanyOwner(playerid, company_idx))
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Владелец не может покинуть компанию. Продайте её в меню «Управление».");
		return 0;
	}

	Dialog(playerid, DIALOG_TC_LEAVE, DIALOG_STYLE_MSGBOX, "{FFFF24}Покинуть компанию",
		"{FFFFFF}Вы уверены, что хотите покинуть транспортную компанию?", "Да", "Нет");
	return 1;
}

stock TC_ShowWorkerCompanyList(playerid, office, page = 0)
{
	if(!TC_CheckEmploymentRequirements(playerid)) return 0;

	if(TC_PlayerHasTcCompany(playerid))
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"У вас уже есть транспортная компания.");
		return 0;
	}

	p_tc_office[playerid] = office;
	p_tc_company_page[playerid] = page;

	new body[1024];
	format(body, sizeof body, "{FFFF24}Название\tРейтинг\tКомиссия\n");

	new shown, skipped;
	new page_start = page * TC_COMPANY_PAGE_SIZE;

	for(new i = 0; i < g_tc_companies_loaded; i++)
	{
		if(g_tc_companies[i][TC_OFFICE] != office) continue;
		if(g_tc_companies[i][TC_OWNER_ID] == -1) continue;
		if(skipped < page_start) { skipped++; continue; }
		if(shown >= TC_COMPANY_PAGE_SIZE) break;

		new cname[48];
		TC_GetCompanyDisplayName(i, cname, sizeof cname);

		new tc_line[96];
		format(tc_line, sizeof tc_line, "{FFFFFF}%s\t%d\t%d%%\n",
			cname, g_tc_company_rating[i], g_tc_companies[i][TC_COMMISSION]);
		strcat(body, tc_line);
		SetPlayerListitemValue(playerid, shown + 1, i);
		shown++;
	}
	if(shown == 0) strcat(body, "{FFFFFF}Нет компаний\t-\t-\n");

	new total;
	for(new i = 0; i < g_tc_companies_loaded; i++)
		if(g_tc_companies[i][TC_OFFICE] == office && g_tc_companies[i][TC_OWNER_ID] != -1)
			total++;
	if((page + 1) * TC_COMPANY_PAGE_SIZE < total)
		strcat(body, "{FFFF24}Далее >>\n");

	Dialog(playerid, DIALOG_TC_COMPANY_LIST, DIALOG_STYLE_TABLIST_HEADERS, "{FFFF24}Список компаний", body, "Выбрать", "Закрыть");
	return 1;
}

stock TC_ShowCompanyJoinConfirm(playerid, company_idx)
{
	if(!TC_CheckEmploymentRequirements(playerid)) return 0;

	if(TC_PlayerHasTcCompany(playerid))
	{
		if(TC_GetOwnedCompanyIndex(playerid) != -1)
			SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Вы владелец транспортной компании. Сначала продайте её.");
		else
			SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Вы уже состоите в транспортной компании.");
		return 0;
	}

	p_tc_join_company[playerid] = company_idx;

	new owner_name[24];
	TC_GetOwnerDisplayName(company_idx, owner_name, sizeof owner_name);

	new cname[48];
	TC_GetCompanyDisplayName(company_idx, cname, sizeof cname);

	new fmt_str[384];
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Название компании: {FFFF24}%s{FFFFFF}\n\
Учредитель: {FFFF24}%s{FFFFFF}\n\
Процентная ставка: {FFFF24}%d%%{FFFFFF}\n\
Рейтинг компании: {FFFF24}%d{FFFFFF}\n\n\
Хотите вступить в данную транспортную компанию?",
		cname, owner_name,
		g_tc_companies[company_idx][TC_COMMISSION], g_tc_company_rating[company_idx]);

	Dialog(playerid, DIALOG_TC_COMPANY_JOIN, DIALOG_STYLE_MSGBOX, "{FFFF24}Информация", fmt_str, "Вступить", "Назад");
	return 1;
}

stock TC_ShowRentList(playerid, page = 0)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Сначала устройтесь в транспортную компанию.");
		return 0;
	}
	if(p_tc_rent_vehicle[playerid] != -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"У вас уже есть арендованный транспорт.");
		return 0;
	}

	new company_sql = g_tc_companies[company_idx][TC_SQL_ID];
	new body[1024];
	format(body, sizeof body, "{FFFF24}Транспорт\tСтоимость аренды\n");

	new shown, skipped;
	new page_start = page * TC_RENT_PAGE_SIZE;
	p_tc_rent_page[playerid] = page;

	for(new i = 0; i < g_tc_fleet_loaded; i++)
	{
		if(g_tc_fleet[i][TF_COMPANY_ID] != company_sql) continue;
		if(g_tc_fleet[i][TF_BROKEN] || g_tc_fleet[i][TF_TRIPS_LEFT] <= 0) continue;
		if(g_tc_fleet[i][TF_RENTED_ACCOUNT_ID] != -1) continue;
		if(skipped < page_start) { skipped++; continue; }
		if(shown >= TC_RENT_PAGE_SIZE) break;

		new tc_line[80];
		format(tc_line, sizeof tc_line, "{FFFFFF}%s\t%d руб.\n", g_tc_fleet_name[i], g_tc_fleet[i][TF_RENT_PRICE]);
		strcat(body, tc_line);
		SetPlayerListitemValue(playerid, shown + 1, i);
		shown++;
	}
	if(shown == 0) strcat(body, "{FFFFFF}Нет свободного транспорта\t-\n");

	new total;
	for(new i = 0; i < g_tc_fleet_loaded; i++)
	{
		if(g_tc_fleet[i][TF_COMPANY_ID] != company_sql) continue;
		if(g_tc_fleet[i][TF_BROKEN] || g_tc_fleet[i][TF_TRIPS_LEFT] <= 0) continue;
		if(g_tc_fleet[i][TF_RENTED_ACCOUNT_ID] != -1) continue;
		total++;
	}
	if((page + 1) * TC_RENT_PAGE_SIZE < total)
		strcat(body, "{FFFF24}Далее >>\n");

	new title[56];
	format(title, sizeof title, "{FFFF24}Аренда транспорта (стр. %d)", page + 1);
	Dialog(playerid, DIALOG_TC_RENT_LIST, DIALOG_STYLE_TABLIST_HEADERS, title, body, "Выбрать", "Закрыть");
	return 1;
}

stock TC_ShowOrdersList(playerid, page = 0)
{
	if(p_tc_company[playerid] == -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Вы не состоите в транспортной компании.");
		return 0;
	}
	if(p_tc_rent_vehicle[playerid] == -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Сначала арендуйте транспорт.");
		return 0;
	}
	if(p_tc_active_order[playerid] != -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Сначала выполните текущий заказ.");
		return 0;
	}

	new office = TC_GetOfficeByPlayer(playerid);
	new company_idx = p_tc_company[playerid];
	new body[1024];
	format(body, sizeof body, "{FFFF24}Название груза\tТип\tДоступность\n");

	new shown, skipped;
	new page_start = page * TC_ORDERS_PAGE_SIZE;
	p_tc_orders_page[playerid] = page;

	for(new i = 0; i < g_tc_rt_orders_count; i++)
	{
		if(!g_tc_rt_orders[i][RT_USED]) continue;
		if(g_tc_rt_orders[i][RT_OFFICE] != office) continue;
		if(g_tc_rt_orders[i][RT_TYPE] != TC_ORDER_GOV && TC_IsOrderActiveForAnyPlayer(i)) continue;
		if(p_tc_rating[playerid] < g_tc_rt_orders[i][RT_MIN_RATING]) continue;
		if(g_tc_rt_orders[i][RT_TYPE] == TC_ORDER_PRIVATE && !TC_CompanyHasTransportLicense(company_idx))
			continue;

		if(skipped < page_start) { skipped++; continue; }
		if(shown >= TC_ORDERS_PAGE_SIZE) break;

		new req[32];
		if(g_tc_rt_orders[i][RT_TYPE] == TC_ORDER_GOV_PLUS)
			format(req, sizeof req, "{FFFF24}3+ ур.");
		else
			format(req, sizeof req, "{FFFFFF}Доступно");

		new tc_line[128];
		format(tc_line, sizeof tc_line, "{FFFFFF}%s\t%s\t%s\n",
			g_tc_rt_orders[i][RT_CARGO_NAME], g_tc_rt_orders[i][RT_TYPE_NAME], req);
		strcat(body, tc_line);
		SetPlayerListitemValue(playerid, shown + 1, i);
		shown++;
	}
	if(shown == 0) strcat(body, "{FFFFFF}Нет заказов\t-\t-\n");

	Dialog(playerid, DIALOG_TC_ORDERS_LIST, DIALOG_STYLE_TABLIST_HEADERS, "{FFFF24}Доступные грузы", body, "Далее", "Выйти");
	return 1;
}

stock TC_ShowOrderInfo(playerid, order_idx)
{
	if(order_idx < 0 || order_idx >= MAX_TC_RUNTIME_ORDERS) return 0;
	if(!g_tc_rt_orders[order_idx][RT_USED]) return 0;

	p_tc_pick_order[playerid] = order_idx;

	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	new commission = g_tc_companies[company_idx][TC_COMMISSION];
	new driver_pay = TC_GetDriverPay(g_tc_rt_orders[order_idx][RT_TOTAL_PAY], commission);
	new Float:km = TC_GetPointsDistanceKm(g_tc_rt_orders[order_idx][RT_FROM], g_tc_rt_orders[order_idx][RT_TO]);
	new weight = floatround(km * 3000.0) + 8000;

	new to_name[32];
	if(g_tc_rt_orders[order_idx][RT_TYPE] == TC_ORDER_PRIVATE && g_tc_rt_orders[order_idx][RT_BUSINESS_ID] >= 0)
		format(to_name, sizeof to_name, "%s", GetBusinessData(g_tc_rt_orders[order_idx][RT_BUSINESS_ID], B_NAME));
	else
		format(to_name, sizeof to_name, "%s", g_tc_point_names[g_tc_rt_orders[order_idx][RT_TO]]);

	new fmt_str[512];
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Название груза: {FFFF24}%s{FFFFFF}\n\
Тип груза: {FFFF24}%s{FFFFFF}\n\
Точка загрузки: {FFFF24}%s{FFFFFF}\n\
Точка разгрузки: {FFFF24}%s{FFFFFF}\n\
Расстояние: {FFFF24}%.1f км.{FFFFFF}\n\
Вес груза: {FFFF24}%d кг.{FFFFFF}\n\
Ваша зарплата: {FFFF24}%d рублей.",
		g_tc_rt_orders[order_idx][RT_CARGO_NAME],
		g_tc_rt_orders[order_idx][RT_TYPE_NAME],
		g_tc_point_names[g_tc_rt_orders[order_idx][RT_FROM]],
		to_name, km, weight, driver_pay);

	Dialog(playerid, DIALOG_TC_ORDER_INFO, DIALOG_STYLE_MSGBOX, "{FFFF24}Информация о грузе", fmt_str, "Взять", "Назад");
	return 1;
}

stock TC_ShowAdminCompanyList(playerid)
{
	if(!GetPlayerAdminEx(playerid)) return 0;

	new body[2048];
	format(body, sizeof(body), "{FFFF24}Компания\tОфис\tСтатус\n");

	for(new i = 0; i < g_tc_companies_loaded; i++)
	{
		new status[32];
		if(g_tc_companies[i][TC_OWNER_ID] == -1)
			format(status, sizeof(status), "{66CC33}Свободна");
		else
			format(status, sizeof(status), "{FFFF24}%s", g_tc_owner_name[i]);

		new cname[48];
		TC_GetCompanyDisplayName(i, cname, sizeof cname);

		new tc_line[96];
		format(tc_line, sizeof tc_line, "{FFFFFF}%s\t%s\t%s\n",
			cname, g_tc_office_names[g_tc_companies[i][TC_OFFICE]], status);
		strcat(body, tc_line);
	}

	Dialog(playerid, DIALOG_TC_ADMIN_LIST, DIALOG_STYLE_TABLIST_HEADERS, "{FFFF24}Выдача транспортной компании", body, "Выбрать", "Отмена");
	return 1;
}

stock TC_ShowAdminGiveInput(playerid, company_idx)
{
	p_tc_admin_company[playerid] = company_idx;

	new cname[48];
	TC_GetCompanyDisplayName(company_idx, cname, sizeof cname);

	new fmt_str[160];
	format(fmt_str, sizeof fmt_str, "{FFFFFF}Компания: {FFFF24}%s{FFFFFF}\n\nВведите никнейм игрока:", cname);
	Dialog(playerid, DIALOG_TC_ADMIN_GIVE, DIALOG_STYLE_INPUT, "{FFFF24}Выдача компании", fmt_str, "Выдать", "Назад");
	return 1;
}
// END INLINED: modules/m1stoks/transportCompany/tcomp_ui.inc
