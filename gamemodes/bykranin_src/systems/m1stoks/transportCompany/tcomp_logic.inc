//>> Файл: bykranin_src/systems/m1stoks/transportCompany/tcomp_logic.inc  (2729 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: TC_SyncPlayerCompanyBinding, TC_RequestAdminCompanyList, TC_OnAdminCompanyListRefreshed, TC_LogFinance, TC_InstallSchema, TC_Init, TC_TrailerLinkTimer
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: modules/m1stoks/transportCompany/tcomp_logic.inc
#if defined _tcomp_logic_included
	#endinput
#endif
#define _tcomp_logic_included

forward TC_OnAdminCompanyListRefreshed(playerid);

stock TC_SyncPlayerCompanyBinding(playerid)
{
	new owned_idx = TC_GetOwnedCompanyIndex(playerid);
	if(owned_idx != -1)
	{
		p_tc_company[playerid] = owned_idx;
		new sql_id = g_tc_companies[owned_idx][TC_SQL_ID];
		if(GetPlayerData(playerid, P_TC_COMPANY_ID) != sql_id)
		{
			SetPlayerData(playerid, P_TC_COMPANY_ID, sql_id);
			UpdatePlayerDatabaseInt(playerid, "tc_company_id", sql_id);
		}
		return 1;
	}

	p_tc_company[playerid] = TC_GetCompanyIndexBySqlId(GetPlayerData(playerid, P_TC_COMPANY_ID));
	return 1;
}

stock TC_RequestAdminCompanyList(playerid)
{
	if(!GetPlayerAdminEx(playerid)) return 0;
	mysql_tquery(mysql,
		"SELECT tc.id, tc.owner_id, IFNULL(a.name,'') AS owner_name \
		FROM tc_companies tc LEFT JOIN accounts a ON a.id=tc.owner_id \
		ORDER BY tc.office ASC, tc.slot ASC",
		"TC_OnAdminCompanyListRefreshed", "d", playerid);
	return 1;
}

public TC_OnAdminCompanyListRefreshed(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	new rows = cache_num_rows();
	for(new r = 0; r < rows; r++)
	{
		new sql_id = cache_get_field_content_int(r, "id");
		new idx = TC_GetCompanyIndexBySqlId(sql_id);
		if(idx == -1) continue;

		g_tc_companies[idx][TC_OWNER_ID] = cache_get_field_content_int(r, "owner_id");
		cache_get_field_content(r, "owner_name", g_tc_owner_name[idx], mysql, 24);
		if(g_tc_companies[idx][TC_OWNER_ID] == -1)
			format(g_tc_owner_name[idx], 24, "Свободна");
	}

	TC_ShowAdminCompanyList(playerid);
	return 1;
}

forward TC_OnCompaniesSeeded();
forward TC_OnCompaniesLoaded();
forward TC_OnFleetLoaded();
forward TC_RentTimerTick(playerid);
forward TC_PrivateWaitTick(rt_idx);
forward TC_PrivateAutoDeliver(rt_idx);

stock TC_LogFinance(company_sql_id, type, amount, const note[])
{
	new query[192];
	mysql_format(mysql, query, sizeof query,
		"INSERT INTO tc_finance (company_id, type, amount, note, created_at) VALUES (%d, %d, %d, '%e', %d)",
		company_sql_id, type, amount, note, gettime());
	mysql_query(mysql, query, false);
}

stock TC_InstallSchema()
{
	mysql_query(mysql,
		"CREATE TABLE IF NOT EXISTS `tc_companies` (\
		`id` INT NOT NULL AUTO_INCREMENT,\
		`office` TINYINT NOT NULL DEFAULT 0,\
		`slot` TINYINT NOT NULL DEFAULT 0,\
		`name` VARCHAR(48) NOT NULL DEFAULT '',\
		`owner_id` INT NOT NULL DEFAULT -1,\
		`balance` BIGINT NOT NULL DEFAULT 0,\
		`commission` TINYINT NOT NULL DEFAULT 10,\
		`last_rename` INT NOT NULL DEFAULT 0,\
		`created_at` INT NOT NULL DEFAULT 0,\
		PRIMARY KEY (`id`), UNIQUE KEY `office_slot` (`office`,`slot`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", false);

	mysql_query(mysql,
		"CREATE TABLE IF NOT EXISTS `tc_fleet` (\
		`id` INT NOT NULL AUTO_INCREMENT,\
		`company_id` INT NOT NULL,\
		`model_id` INT NOT NULL DEFAULT 403,\
		`name` VARCHAR(32) NOT NULL DEFAULT '',\
		`rent_price` INT NOT NULL DEFAULT 1000,\
		`trips_left` INT NOT NULL DEFAULT 50,\
		`trips_max` INT NOT NULL DEFAULT 50,\
		`broken` TINYINT NOT NULL DEFAULT 0,\
		`rented_account_id` INT NOT NULL DEFAULT -1,\
		`created_at` INT NOT NULL DEFAULT 0,\
		PRIMARY KEY (`id`), KEY `company_id` (`company_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", false);

	mysql_query(mysql,
		"CREATE TABLE IF NOT EXISTS `tc_employees` (\
		`id` INT NOT NULL AUTO_INCREMENT,\
		`company_id` INT NOT NULL,\
		`account_id` INT NOT NULL,\
		`hired_at` INT NOT NULL DEFAULT 0,\
		`orders_done` INT NOT NULL DEFAULT 0,\
		`earned` BIGINT NOT NULL DEFAULT 0,\
		PRIMARY KEY (`id`), UNIQUE KEY `company_account` (`company_id`,`account_id`), KEY `account_id` (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", false);

	mysql_query(mysql,
		"CREATE TABLE IF NOT EXISTS `tc_finance` (\
		`id` INT NOT NULL AUTO_INCREMENT,\
		`company_id` INT NOT NULL,\
		`type` TINYINT NOT NULL DEFAULT 0,\
		`amount` BIGINT NOT NULL DEFAULT 0,\
		`note` VARCHAR(64) NOT NULL DEFAULT '',\
		`created_at` INT NOT NULL DEFAULT 0,\
		PRIMARY KEY (`id`), KEY `company_id` (`company_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", false);

	mysql_query(mysql,
		"CREATE TABLE IF NOT EXISTS `tc_orders` (\
		`id` INT NOT NULL AUTO_INCREMENT,\
		`office` TINYINT NOT NULL DEFAULT 0,\
		`type` TINYINT NOT NULL DEFAULT 0,\
		`from_point` TINYINT NOT NULL DEFAULT 0,\
		`to_point` TINYINT NOT NULL DEFAULT 0,\
		`business_id` INT NOT NULL DEFAULT -1,\
		`amount` INT NOT NULL DEFAULT 0,\
		`total_pay` INT NOT NULL DEFAULT 0,\
		`min_rating` INT NOT NULL DEFAULT 0,\
		`status` TINYINT NOT NULL DEFAULT 0,\
		`taken_by` INT NOT NULL DEFAULT -1,\
		`created_at` INT NOT NULL DEFAULT 0,\
		PRIMARY KEY (`id`), KEY `business_id` (`business_id`), KEY `status` (`status`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251", false);

	mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN `tc_company_id` INT NOT NULL DEFAULT 0", false);
	mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN `tc_rating` INT NOT NULL DEFAULT 0", false);
	mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN `tc_rating_day` INT NOT NULL DEFAULT 0", false);
	mysql_query(mysql, "ALTER TABLE `accounts` ADD COLUMN `tc_rating_week` INT NOT NULL DEFAULT 0", false);
	mysql_query(mysql, "ALTER TABLE `tc_companies` ADD COLUMN `upgrade_office` TINYINT NOT NULL DEFAULT 0", false);
	mysql_query(mysql, "ALTER TABLE `tc_companies` ADD COLUMN `upgrade_garage` TINYINT NOT NULL DEFAULT 0", false);
	mysql_query(mysql, "ALTER TABLE `tc_companies` ADD COLUMN `upgrade_licenses` TINYINT NOT NULL DEFAULT 0", false);

	mysql_query(mysql, "ALTER TABLE `tc_companies` MODIFY `name` VARCHAR(48) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT ''", false);
}

stock TC_Init()
{
	static bool:initialized;
	if(initialized) return 1;
	initialized = true;
	printf("[TransportCompany] build 2026-09-03 cargo-finalcp-v13");
	mysql_set_charset("cp1251");
	mysql_query(mysql, "SET NAMES cp1251", false);
	SetTimer("TC_TrailerLinkTimer", TC_TRAILER_LINK_MS, true);
	g_tc_companies_loaded = 0;
	g_tc_fleet_loaded = 0;
	g_tc_rt_orders_count = 0;
	TC_InstallSchema();
	TC_CreateWorldPickups();
	mysql_tquery(mysql, "SELECT COUNT(*) AS cnt FROM tc_companies", "TC_OnCompaniesSeeded", "");
	return 1;
}

forward TC_TrailerLinkTimer();
public TC_TrailerLinkTimer()
{
	foreach(new i : Player)
	{
		if(!IsPlayerLogged(i)) continue;
		if(p_tc_order_progress[i] == 1)
			TC_TryDetectTrailerLink(i);
		else if(p_tc_order_progress[i] >= 2)
		{
			TC_ForceTrailerLock(i, true);
			TC_MaintainTrailerOnRoute(i);

			// Mobile fallback: OnPlayerEnterCheckpoint can be missed after a large
			// vehicle/trailer sync correction. The visible route checkpoint is 15m,
			// so poll the final unload radius as well and start the same unload flow.
			if(p_tc_order_progress[i] == 3 && !p_tc_operation_timer[i] &&
				TC_IsPlayerInRentTruck(i) && p_tc_active_order[i] != -1 &&
				TC_IsAtUnloadPoint(i, p_tc_active_order[i]))
			{
				TC_LogTrailerServer(i, "unload_proximity_fallback");
				TC_StartLoadUnloadOperation(i, false);
			}
		}
	}
	return 1;
}

public TC_OnCompaniesSeeded()
{
	new count = cache_get_field_content_int(0, "cnt");
	if(count < TC_COMPANIES_TOTAL)
	{
		new query[192];
		for(new office = 0; office < 2; office++)
		{
			for(new slot = 0; slot < TC_COMPANIES_PER_OFFICE; slot++)
			{
				new display_num = office * TC_COMPANIES_PER_OFFICE + slot + 1;
				mysql_format(mysql, query, sizeof query,
					"INSERT IGNORE INTO tc_companies (office, slot, name, commission, owner_id, created_at) VALUES (%d, %d, 'N%d', 10, -1, %d)",
					office, slot, display_num, gettime());
				mysql_query(mysql, query, false);
			}
		}
	}
	TC_LoadCompanies();
	return 1;
}

stock TC_LoadCompanies()
{
	mysql_tquery(mysql,
		"SELECT tc.*, IFNULL(a.name,'') AS owner_name, \
		IFNULL((SELECT SUM(ac.tc_rating) FROM accounts ac WHERE ac.tc_company_id=tc.id),0) AS company_rating \
		FROM tc_companies tc LEFT JOIN accounts a ON a.id=tc.owner_id \
		ORDER BY tc.office ASC, tc.slot ASC",
		"TC_OnCompaniesLoaded", "");
}

public TC_OnCompaniesLoaded()
{
	g_tc_companies_loaded = cache_num_rows();
	if(g_tc_companies_loaded > TC_COMPANIES_TOTAL)
		g_tc_companies_loaded = TC_COMPANIES_TOTAL;

	for(new i = 0; i < g_tc_companies_loaded; i++)
	{
		g_tc_companies[i][TC_SQL_ID] = cache_get_field_content_int(i, "id");
		g_tc_companies[i][TC_OFFICE] = cache_get_field_content_int(i, "office");
		g_tc_companies[i][TC_SLOT] = cache_get_field_content_int(i, "slot");
		g_tc_companies[i][TC_OWNER_ID] = cache_get_field_content_int(i, "owner_id");
		cache_get_field_content(i, "name", g_tc_company_name[i], mysql, 48);
		g_tc_companies[i][TC_BALANCE] = cache_get_field_content_int(i, "balance");
		g_tc_companies[i][TC_COMMISSION] = cache_get_field_content_int(i, "commission");
		g_tc_companies[i][TC_LAST_RENAME] = cache_get_field_content_int(i, "last_rename");
		g_tc_companies[i][TC_UPG_OFFICE] = cache_get_field_content_int(i, "upgrade_office");
		g_tc_companies[i][TC_UPG_GARAGE] = cache_get_field_content_int(i, "upgrade_garage");
		g_tc_companies[i][TC_UPG_LICENSE] = cache_get_field_content_int(i, "upgrade_licenses");
		cache_get_field_content(i, "owner_name", g_tc_owner_name[i], mysql, 24);
		g_tc_company_rating[i] = cache_get_field_content_int(i, "company_rating");
	}

	TC_LoadFleet();
	TC_CreateWorldPickups();
	printf("[TransportCompany]: Загружено компаний: %d", g_tc_companies_loaded);

	foreach(new i : Player)
	{
		if(IsPlayerLogged(i))
			TC_SyncPlayerCompanyBinding(i);
	}
	return 1;
}

stock TC_LoadFleet()
{
	// Sprinter-only fleet: preserve existing fleet slots, but migrate every legacy
	// tractor/truck to the single supported company vehicle. No schema changes.
	mysql_query(mysql, "UPDATE tc_fleet SET model_id=498, name='Mercedes-Benz Sprinter' WHERE model_id<>498", false);
	mysql_tquery(mysql, "SELECT * FROM tc_fleet ORDER BY company_id ASC, id ASC", "TC_OnFleetLoaded", "");
}

public TC_OnFleetLoaded()
{
	g_tc_fleet_loaded = cache_num_rows();
	if(g_tc_fleet_loaded > MAX_TC_FLEET)
		g_tc_fleet_loaded = MAX_TC_FLEET;

	for(new i = 0; i < g_tc_fleet_loaded; i++)
	{
		g_tc_fleet[i][TF_SQL_ID] = cache_get_field_content_int(i, "id");
		g_tc_fleet[i][TF_COMPANY_ID] = cache_get_field_content_int(i, "company_id");
		g_tc_fleet[i][TF_MODEL_ID] = cache_get_field_content_int(i, "model_id");
		cache_get_field_content(i, "name", g_tc_fleet_name[i], mysql, 32);
		// Runtime hard guard for old/stale DB rows: TC fleet is Sprinter-only.
		if(g_tc_fleet[i][TF_MODEL_ID] != TC_VAN_MODEL_DEFAULT)
		{
			g_tc_fleet[i][TF_MODEL_ID] = TC_VAN_MODEL_DEFAULT;
			format(g_tc_fleet_name[i], 32, "Mercedes-Benz Sprinter");
		}
		g_tc_fleet[i][TF_RENT_PRICE] = cache_get_field_content_int(i, "rent_price");
		g_tc_fleet[i][TF_TRIPS_LEFT] = cache_get_field_content_int(i, "trips_left");
		g_tc_fleet[i][TF_TRIPS_MAX] = cache_get_field_content_int(i, "trips_max");
		if(g_tc_fleet[i][TF_TRIPS_MAX] <= 0) g_tc_fleet[i][TF_TRIPS_MAX] = TC_FLEET_TRIPS_MAX;
		g_tc_fleet[i][TF_BROKEN] = bool:cache_get_field_content_int(i, "broken");
		g_tc_fleet[i][TF_RENTED_ACCOUNT_ID] = cache_get_field_content_int(i, "rented_account_id");
	}

	printf("[TransportCompany]: Загружено ТС в автопарках: %d", g_tc_fleet_loaded);
	TC_ClearOrphanFleetRents();
	TC_GenerateGovOrders();
	return 1;
}

stock TC_GetFleetIndexBySqlId(sql_id)
{
	for(new i = 0; i < g_tc_fleet_loaded; i++)
		if(g_tc_fleet[i][TF_SQL_ID] == sql_id)
			return i;
	return -1;
}

stock TC_FindFreeOrderSlot()
{
	for(new i = 0; i < g_tc_rt_orders_count; i++)
		if(!g_tc_rt_orders[i][RT_USED])
			return i;
	if(g_tc_rt_orders_count < MAX_TC_RUNTIME_ORDERS)
		return g_tc_rt_orders_count++;
	return -1;
}

stock TC_GenerateGovOrders()
{
	g_tc_rt_orders_count = 0;

	new routes[][2] =
	{
		{TC_POINT_MINE, TC_POINT_WAREHOUSE},
		{TC_POINT_WAREHOUSE, TC_POINT_PORT},
		{TC_POINT_MINE, TC_POINT_PORT}
	};
	new cargos[][24] = {"Металл", "Уголь", "Контейнеры"};

	for(new office = 0; office < 2; office++)
	{
		for(new r = 0; r < sizeof routes; r++)
		{
			new idx = TC_FindFreeOrderSlot();
			if(idx == -1) return 1;

			g_tc_rt_orders[idx][RT_USED] = 1;
			g_tc_rt_orders[idx][RT_OFFICE] = office;
			g_tc_rt_orders[idx][RT_TYPE] = TC_ORDER_GOV;
			g_tc_rt_orders[idx][RT_FROM] = routes[r][0];
			g_tc_rt_orders[idx][RT_TO] = routes[r][1];
			g_tc_rt_orders[idx][RT_MIN_RATING] = 0;
			g_tc_rt_orders[idx][RT_TRAILER_MODEL] = 435;
			g_tc_rt_orders[idx][RT_BUSINESS_ID] = -1;
			g_tc_rt_orders[idx][RT_AMOUNT] = 0;
			g_tc_rt_orders[idx][RT_SQL_ID] = -1;
			format(g_tc_rt_orders[idx][RT_CARGO_NAME], 24, "%s", cargos[r % sizeof(cargos)]);
			format(g_tc_rt_orders[idx][RT_TYPE_NAME], 16, "Гос.");

			new Float:km = TC_GetPointsDistanceKm(routes[r][0], routes[r][1]);
			g_tc_rt_orders[idx][RT_TOTAL_PAY] = floatround(km * 10000.0) + random(5000) + 30000;
		}
	}
	return 1;
}

stock TC_AddGovPlusOrder(office)
{
	new idx = TC_FindFreeOrderSlot();
	if(idx == -1) return -1;

	new routes[][2] =
	{
		{TC_POINT_MINE, TC_POINT_WAREHOUSE},
		{TC_POINT_WAREHOUSE, TC_POINT_PORT},
		{TC_POINT_MINE, TC_POINT_PORT}
	};
	new r = random(sizeof routes);

	g_tc_rt_orders[idx][RT_USED] = 1;
	g_tc_rt_orders[idx][RT_OFFICE] = office;
	g_tc_rt_orders[idx][RT_TYPE] = TC_ORDER_GOV_PLUS;
	g_tc_rt_orders[idx][RT_FROM] = routes[r][0];
	g_tc_rt_orders[idx][RT_TO] = routes[r][1];
	g_tc_rt_orders[idx][RT_MIN_RATING] = 10;
	g_tc_rt_orders[idx][RT_TRAILER_MODEL] = 435;
	g_tc_rt_orders[idx][RT_BUSINESS_ID] = -1;
	g_tc_rt_orders[idx][RT_AMOUNT] = 0;
	g_tc_rt_orders[idx][RT_SQL_ID] = -1;
	format(g_tc_rt_orders[idx][RT_CARGO_NAME], 24, "Спецгруз");
	format(g_tc_rt_orders[idx][RT_TYPE_NAME], 16, "Гос+");
	g_tc_rt_orders[idx][RT_TOTAL_PAY] = TC_GOV_PLUS_PAY_MIN + random(TC_GOV_PLUS_PAY_MAX - TC_GOV_PLUS_PAY_MIN + 1);
	return idx;
}

stock TC_GetOfficeForBusiness(businessid)
{

	new Float:bx = GetBusinessData(businessid, B_POS_X);
	new Float:by = GetBusinessData(businessid, B_POS_Y);
	new Float:d0 = floatabs(bx - g_tc_building_enter[0][0]) + floatabs(by - g_tc_building_enter[0][1]);
	new Float:d1 = floatabs(bx - g_tc_building_enter[1][0]) + floatabs(by - g_tc_building_enter[1][1]);
	return (d1 < d0) ? 1 : 0;
}

stock TC_CreatePrivateOrder(businessid, amount)
{
	if(businessid < 0 || businessid >= MAX_BUSINESS) return -1;
	if(g_tc_private_business[businessid] != -1) return -2;

	new idx = TC_FindFreeOrderSlot();
	if(idx == -1) return -1;

	new office = TC_GetOfficeForBusiness(businessid);

	g_tc_rt_orders[idx][RT_USED] = 1;
	g_tc_rt_orders[idx][RT_OFFICE] = office;
	g_tc_rt_orders[idx][RT_TYPE] = TC_ORDER_PRIVATE;
	g_tc_rt_orders[idx][RT_FROM] = TC_POINT_WAREHOUSE;
	g_tc_rt_orders[idx][RT_TO] = TC_POINT_PORT;
	g_tc_rt_orders[idx][RT_MIN_RATING] = 0;
	g_tc_rt_orders[idx][RT_TRAILER_MODEL] = 435;
	g_tc_rt_orders[idx][RT_BUSINESS_ID] = businessid;
	g_tc_rt_orders[idx][RT_AMOUNT] = amount;
	g_tc_rt_orders[idx][RT_SQL_ID] = -1;
	format(g_tc_rt_orders[idx][RT_CARGO_NAME], 24, "Продукты");
	format(g_tc_rt_orders[idx][RT_TYPE_NAME], 16, "Частный");
	g_tc_rt_orders[idx][RT_TOTAL_PAY] = amount * 25 + 5000;

	g_tc_private_business[businessid] = idx;

	new query[160];
	mysql_format(mysql, query, sizeof query,
		"INSERT INTO tc_orders (office, type, from_point, to_point, business_id, amount, total_pay, status, created_at) \
		VALUES (%d, %d, %d, %d, %d, %d, %d, 0, %d)",
		office, TC_ORDER_PRIVATE, TC_POINT_WAREHOUSE, TC_POINT_PORT, businessid, amount,
		g_tc_rt_orders[idx][RT_TOTAL_PAY], gettime());
	mysql_query(mysql, query, false);

	SetTimerEx("TC_PrivateWaitTick", TC_PRIVATE_ORDER_WAIT_SEC * 1000, false, "i", idx);
	return idx;
}

stock TC_IsOrderActiveForAnyPlayer(rt_idx)
{
	if(rt_idx < 0 || rt_idx >= MAX_TC_RUNTIME_ORDERS) return 0;
	foreach(new i : Player)
	{
		if(!IsPlayerLogged(i)) continue;
		if(p_tc_active_order[i] == rt_idx) return 1;
	}
	return 0;
}

public TC_PrivateWaitTick(rt_idx)
{
	if(rt_idx < 0 || rt_idx >= MAX_TC_RUNTIME_ORDERS) return 0;
	if(!g_tc_rt_orders[rt_idx][RT_USED]) return 0;
	if(g_tc_rt_orders[rt_idx][RT_TYPE] != TC_ORDER_PRIVATE) return 0;

	new businessid = g_tc_rt_orders[rt_idx][RT_BUSINESS_ID];
	if(businessid < 0 || g_tc_private_business[businessid] != rt_idx) return 0;

	// Do not tell the business owner that nobody accepted the order when a
	// real player is already driving it. The watchdog is still armed so an
	// abandoned order can be auto-delivered later.
	if(!TC_IsOrderActiveForAnyPlayer(rt_idx))
	{
		new owner_acc = GetBusinessData(businessid, B_OWNER_ID);
		foreach(new i : Player)
		{
			if(IsPlayerLogged(i) && GetPlayerAccountID(i) == owner_acc)
			{
				SendClientMessage(i, TC_COLOR_MSG, TC_MSG"Никто из дальнобойщиков не взял заказ продуктов.");
				SendClientMessage(i, TC_COLOR_MSG, TC_MSG"Система имитирует доставку — продукты пополнятся через 5 минут.");
			}
		}
	}
	SetTimerEx("TC_PrivateAutoDeliver", TC_PRIVATE_AUTO_DELIVER_SEC * 1000, false, "i", rt_idx);
	return 1;
}

public TC_PrivateAutoDeliver(rt_idx)
{
	if(rt_idx < 0 || rt_idx >= MAX_TC_RUNTIME_ORDERS) return 0;
	if(!g_tc_rt_orders[rt_idx][RT_USED]) return 0;
	if(g_tc_rt_orders[rt_idx][RT_TYPE] != TC_ORDER_PRIVATE) return 0;

	new businessid = g_tc_rt_orders[rt_idx][RT_BUSINESS_ID];
	if(businessid < 0 || g_tc_private_business[businessid] != rt_idx) return 0;

	// Critical: an old auto-delivery timer must never invalidate an order that
	// a real driver has already accepted. Recheck later while the route is active.
	if(TC_IsOrderActiveForAnyPlayer(rt_idx))
	{
		SetTimerEx("TC_PrivateAutoDeliver", 60000, false, "i", rt_idx);
		return 1;
	}

	new amount = g_tc_rt_orders[rt_idx][RT_AMOUNT];
	AddBusinessData(businessid, B_PRODS, +, amount);

	new query[160];
	mysql_format(mysql, query, sizeof query,
		"UPDATE business SET products=%d WHERE id=%d LIMIT 1",
		GetBusinessData(businessid, B_PRODS), GetBusinessData(businessid, B_SQL_ID));
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_orders SET status=4 WHERE business_id=%d AND status IN (0,1) ORDER BY id DESC LIMIT 1", businessid);
	mysql_query(mysql, query, false);

	new owner_acc = GetBusinessData(businessid, B_OWNER_ID);
	foreach(new i : Player)
		if(IsPlayerLogged(i) && GetPlayerAccountID(i) == owner_acc)
			SendClientMessage(i, TC_COLOR_MSG, TC_MSG"Продукты вашего бизнеса автоматически пополнены.");

	g_tc_private_business[businessid] = -1;
	g_tc_rt_orders[rt_idx][RT_USED] = 0;
	return 1;
}

stock TC_ReleaseFleetRentSlot(fleet_idx)
{
	if(fleet_idx < 0 || fleet_idx >= g_tc_fleet_loaded) return 0;
	if(g_tc_fleet[fleet_idx][TF_RENTED_ACCOUNT_ID] == -1) return 0;

	g_tc_fleet[fleet_idx][TF_RENTED_ACCOUNT_ID] = -1;
	new query[128];
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_fleet SET rented_account_id=-1 WHERE id=%d LIMIT 1",
		g_tc_fleet[fleet_idx][TF_SQL_ID]);
	mysql_query(mysql, query, false);
	return 1;
}

stock TC_ReleaseAccountFleetRents(account_id)
{
	if(account_id <= 0) return 0;

	new released;
	for(new i = 0; i < g_tc_fleet_loaded; i++)
	{
		if(g_tc_fleet[i][TF_RENTED_ACCOUNT_ID] == account_id)
		{
			TC_ReleaseFleetRentSlot(i);
			released++;
		}
	}
	return released;
}

stock TC_ClearOrphanFleetRents()
{
	for(new i = 0; i < g_tc_fleet_loaded; i++)
	{
		new acc = g_tc_fleet[i][TF_RENTED_ACCOUNT_ID];
		if(acc == -1) continue;

		new bool:has_active_rent;
		foreach(new p : Player)
		{
			if(!IsPlayerLogged(p)) continue;
			if(GetPlayerAccountID(p) != acc) continue;
			if(p_tc_rent_vehicle[p] != -1 && p_tc_rent_fleet_idx[p] == i)
			{
				has_active_rent = true;
				break;
			}
		}
		if(!has_active_rent)
			TC_ReleaseFleetRentSlot(i);
	}
	return 1;
}

stock TC_ResetPlayerWork(playerid)
{
	if(p_tc_rent_timer[playerid])
	{
		KillTimer(p_tc_rent_timer[playerid]);
		p_tc_rent_timer[playerid] = 0;
	}
	if(p_tc_trailer_watch_timer[playerid])
	{
		KillTimer(p_tc_trailer_watch_timer[playerid]);
		p_tc_trailer_watch_timer[playerid] = 0;
	}
	if(p_tc_operation_timer[playerid])
	{
		KillTimer(p_tc_operation_timer[playerid]);
		p_tc_operation_timer[playerid] = 0;
	}
	if(p_tc_operation_watch_timer[playerid])
	{
		KillTimer(p_tc_operation_watch_timer[playerid]);
		p_tc_operation_watch_timer[playerid] = 0;
	}
	p_tc_operation_loading[playerid] = false;
	p_tc_trailer_detach_misses[playerid] = 0;
	if(p_tc_rent_vehicle[playerid] != -1 && IsValidVehicle(p_tc_rent_vehicle[playerid]))
		TC_ForceDestroyVehicle(p_tc_rent_vehicle[playerid]);
	if(p_tc_trailer_vehicle[playerid] != -1 && IsValidVehicle(p_tc_trailer_vehicle[playerid]))
		TC_ForceDestroyVehicle(p_tc_trailer_vehicle[playerid]);
	else if(p_tc_trailer_vehicle[playerid] != -1)
		TC_ClearGuardedVehicle(p_tc_trailer_vehicle[playerid]);

	p_tc_rent_vehicle[playerid] = -1;
	p_tc_rent_fleet_idx[playerid] = -1;
	p_tc_trailer_vehicle[playerid] = -1;
	p_tc_active_order[playerid] = -1;
	p_tc_order_progress[playerid] = 0;
	p_tc_trailer_detached[playerid] = false;
	p_tc_trailer_was_attached[playerid] = false;
	p_tc_trailer_detach_misses[playerid] = 0;
	p_tc_trailer_last_recover_ms[playerid] = 0;
	p_tc_trailer_lock_fail_since_ms[playerid] = 0;
	p_tc_trailer_has_last_pos[playerid] = false;
	p_tc_dest_port_dock[playerid] = -1;
	p_tc_mine_load_dock[playerid] = -1;
	p_tc_rent_sec_left[playerid] = 0;
	TC_ClearRouteMarker(playerid);
}

stock TC_EndRent(playerid, bool:return_payment)
{
	#pragma unused return_payment

	new fleet_idx = p_tc_rent_fleet_idx[playerid];
	if(fleet_idx >= 0 && fleet_idx < g_tc_fleet_loaded)
		TC_ReleaseFleetRentSlot(fleet_idx);
	else if(IsPlayerLogged(playerid))
		TC_ReleaseAccountFleetRents(GetPlayerAccountID(playerid));

	TC_ResetPlayerWork(playerid);
	return 1;
}

stock TC_RestoreActiveCheckpoint(playerid)
{
	if(p_tc_active_order[playerid] == -1)
	{
		if(p_tc_rent_vehicle[playerid] != -1 && IsValidVehicle(p_tc_rent_vehicle[playerid]))
		{
			if(GetPlayerVehicleID(playerid) != p_tc_rent_vehicle[playerid])
			{
				new Float:x, Float:y, Float:z;
				GetVehiclePos(p_tc_rent_vehicle[playerid], x, y, z);
				TC_RememberRouteMarkerPos(playerid, x, y, z);
				SetPlayerCheckpoint(playerid, x, y, z, 5.0);
			}
		}
		return 1;
	}

	new order_idx = p_tc_active_order[playerid];
	new Float:x, Float:y, Float:z;

	if(p_tc_order_progress[playerid] == 1)
	{
		if(p_tc_trailer_vehicle[playerid] != -1 && IsValidVehicle(p_tc_trailer_vehicle[playerid]))
		{
			GetVehiclePos(p_tc_trailer_vehicle[playerid], x, y, z);
			TC_RememberRouteMarkerPos(playerid, x, y, z);
			SetPlayerCheckpoint(playerid, x, y, z, 6.0);
		}
		return 1;
	}
	if(p_tc_order_progress[playerid] == 2)
	{
		if(g_tc_rt_orders[order_idx][RT_FROM] == TC_POINT_MINE)
			TC_SelectMineLoadDock(playerid);
		TC_SetRouteCheckpoint(playerid, order_idx, true, TC_ROUTE_CHECKPOINT_SIZE, false);
		return 1;
	}
	if(p_tc_order_progress[playerid] == 3)
	{
		TC_SetUnloadCheckpoint(playerid, order_idx, false);
		return 1;
	}
	return 1;
}

stock TC_EnterOffice(playerid, office)
{
	if(office < 0 || office > 1) return 0;
	p_tc_office[playerid] = office;
	return 1;
}

stock TC_ExitOffice(playerid, office)
{
	#pragma unused office
	p_tc_office[playerid] = -1;
	TC_RestoreActiveCheckpoint(playerid);
	return 1;
}

stock TC_OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	#pragma unused oldinteriorid
	if(newinteriorid == g_tc_interior_id)
	{
		new vw = GetPlayerVirtualWorld(playerid);
		if(vw == g_tc_interior_vw[0]) { TC_EnterOffice(playerid, TC_OFFICE_BATUREVO); return 1; }
		if(vw == g_tc_interior_vw[1]) { TC_EnterOffice(playerid, TC_OFFICE_BUSAEVO); return 1; }
	}
	else if(p_tc_office[playerid] != -1)
	{
		TC_ExitOffice(playerid, p_tc_office[playerid]);
		return 1;
	}
	return 0;
}

stock TC_StartRent(playerid, fleet_idx)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1) return 0;

	if(p_tc_rent_vehicle[playerid] != -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"У вас уже есть арендованный транспорт.");
		return 0;
	}
	if(fleet_idx < 0 || fleet_idx >= g_tc_fleet_loaded) return 0;
	if(g_tc_fleet[fleet_idx][TF_COMPANY_ID] != g_tc_companies[company_idx][TC_SQL_ID]) return 0;
	if(g_tc_fleet[fleet_idx][TF_MODEL_ID] != TC_VAN_MODEL_DEFAULT)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"В автопарке ТК разрешен только Mercedes-Benz Sprinter.");
		return 0;
	}

	if(g_tc_fleet[fleet_idx][TF_BROKEN] || g_tc_fleet[fleet_idx][TF_TRIPS_LEFT] <= 0)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Это ТС на техобслуживании.");
		return 0;
	}
	if(g_tc_fleet[fleet_idx][TF_RENTED_ACCOUNT_ID] != -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Это ТС уже арендовано.");
		return 0;
	}

	new price = g_tc_fleet[fleet_idx][TF_RENT_PRICE];
	if(GetPlayerMoneyEx(playerid) < price)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Недостаточно денег для аренды.");
		return 0;
	}

	new office = g_tc_companies[company_idx][TC_OFFICE];
	new slot = TC_GetRandomTruckParkingSlot(office);
	new Float:x, Float:y, Float:z, Float:a;
	if(!TC_GetTruckParkingPos(office, slot, x, y, z, a)) return 0;

	GivePlayerMoneyEx(playerid, -price, "Аренда ТК", true, true);

	new vehicleid = CreateVehicle(g_tc_fleet[fleet_idx][TF_MODEL_ID], x, y, z, a, random(126), random(126), -1, 0, VEHICLE_ACTION_TYPE_TC, playerid);
	TC_RegisterGuardedVehicle(vehicleid, playerid);
	p_tc_rent_vehicle[playerid] = vehicleid;
	p_tc_rent_fleet_idx[playerid] = fleet_idx;
	g_tc_fleet[fleet_idx][TF_RENTED_ACCOUNT_ID] = GetPlayerAccountID(playerid);

	new query[160];
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_fleet SET rented_account_id=%d WHERE id=%d LIMIT 1",
		GetPlayerAccountID(playerid), g_tc_fleet[fleet_idx][TF_SQL_ID]);
	mysql_query(mysql, query, false);

	g_tc_companies[company_idx][TC_BALANCE] += price;
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_companies SET balance=balance+%d WHERE id=%d LIMIT 1", price, g_tc_companies[company_idx][TC_SQL_ID]);
	mysql_query(mysql, query, false);
	TC_LogFinance(g_tc_companies[company_idx][TC_SQL_ID], TC_FIN_RENT, price, "Аренда ТС");

	if(TC_CanShowWorldCheckpoint(playerid))
		SetPlayerCheckpoint(playerid, x, y, z, 5.0);
	p_tc_rent_sec_left[playerid] = TC_RENT_OCCUPY_SEC;
	if(p_tc_rent_timer[playerid]) KillTimer(p_tc_rent_timer[playerid]);
	p_tc_rent_timer[playerid] = SetTimerEx("TC_RentTimerTick", 1000, true, "i", playerid);

	new price_msg[192];
	format(price_msg, sizeof price_msg, "Списано {FFFF24}%d{FFFFFF} руб. за аренду.", price);
	TC_Send(playerid, price_msg);
	TC_Send(playerid, "Транспорт отмечен на карте.");
	TC_Send(playerid, "У вас 2 минуты, чтобы занять машину.");
	return 1;
}

public TC_RentTimerTick(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(p_tc_rent_sec_left[playerid] <= 0) return 0;

	if(p_tc_office[playerid] != -1) return 1;

	if(p_tc_rent_vehicle[playerid] != -1 && GetPlayerVehicleID(playerid) == p_tc_rent_vehicle[playerid])
	{
		KillTimer(p_tc_rent_timer[playerid]);
		p_tc_rent_timer[playerid] = 0;
		p_tc_rent_sec_left[playerid] = 0;
		if(p_tc_active_order[playerid] == -1)
			DisablePlayerCheckpoint(playerid);
		else
			TC_RestoreActiveCheckpoint(playerid);
		return 1;
	}

	p_tc_rent_sec_left[playerid]--;

	if(p_tc_rent_sec_left[playerid] <= 0)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Время аренды истекло — вы не заняли транспорт.");
		TC_EndRent(playerid, false);
		return 1;
	}

	new sec_msg[48];
	format(sec_msg, sizeof sec_msg, "~y~%d~w~ сек.", p_tc_rent_sec_left[playerid]);
	GameTextForPlayer(playerid, sec_msg, 1100, 3);
	return 1;
}

stock TC_IsTrailerLinked(playerid)
{
	if(p_tc_rent_vehicle[playerid] == -1 || p_tc_trailer_vehicle[playerid] == -1)
		return 0;
	if(!IsValidVehicle(p_tc_rent_vehicle[playerid]) || !IsValidVehicle(p_tc_trailer_vehicle[playerid]))
		return 0;

	new truck = p_tc_rent_vehicle[playerid];
	new trailer = p_tc_trailer_vehicle[playerid];

	if(!IsTrailerAttachedToVehicle(truck))
		return 0;

	new linked = GetVehicleTrailer(truck);
	if(linked == trailer)
		return 1;

	if(linked == 0)
	{
		new Float:dist;
		if(TC_GetTrailerDistance(playerid, dist) && dist < 20.0)
			return 1;
	}
	return 0;
}

stock TC_GetTrailerDistance(playerid, &Float:dist)
{
	new truck = p_tc_rent_vehicle[playerid];
	new trailer = p_tc_trailer_vehicle[playerid];
	if(truck == -1 || trailer == -1) return 0;

	new Float:tx, Float:ty, Float:tz, Float:px, Float:py, Float:pz;
	GetVehiclePos(trailer, tx, ty, tz);
	GetVehiclePos(truck, px, py, pz);
	new Float:dx = tx - px, Float:dy = ty - py, Float:dz = tz - pz;
	dist = floatsqroot(dx * dx + dy * dy + dz * dz);
	return 1;
}

stock TC_IsTrailerNearTruck(playerid, Float:max_dist)
{
	new Float:dist;
	if(!TC_GetTrailerDistance(playerid, dist)) return 0;
	return dist <= max_dist;
}

stock TC_LogTrailerServer(playerid, const tag[])
{
	#if !TC_TRAILER_DEBUG
		#pragma unused tag
		return 0;
	#endif
	new tid = p_tc_trailer_vehicle[playerid];
	new truck = p_tc_rent_vehicle[playerid];
	new linked = -1;
	if(truck != -1 && IsValidVehicle(truck))
		linked = GetVehicleTrailer(truck);
	printf("[TC trailer] %s | p=%d tid=%d truck=%d link=%d prog=%d",
		tag, playerid, tid, truck, linked, p_tc_order_progress[playerid]);
	return 1;
}

stock TC_LogTrailerDebug(playerid, const tag[])
{
	return TC_LogTrailerServer(playerid, tag);
}

stock TC_OnTrailerLinked(playerid)
{
	if(p_tc_trailer_was_attached[playerid])
		return 1;

	p_tc_trailer_was_attached[playerid] = true;
	p_tc_trailer_detached[playerid] = false;
	p_tc_trailer_detach_misses[playerid] = 0;
	p_tc_trailer_lock_fail_since_ms[playerid] = 0;
	TC_OnTrailerAttached(playerid);
	return 1;
}

stock TC_TryDetectTrailerLink(playerid)
{
	if(p_tc_active_order[playerid] == -1 || p_tc_trailer_vehicle[playerid] == -1) return 0;
	if(p_tc_order_progress[playerid] < 1) return 0;

	new truck = p_tc_rent_vehicle[playerid];
	if(truck == -1 || GetPlayerVehicleID(playerid) != truck) return 0;
	if(!IsValidVehicle(truck)) return 0;

	new trailer = p_tc_trailer_vehicle[playerid];
	if(!IsValidVehicle(trailer)) return 0;

	if(TC_IsTrailerLinked(playerid))
		return TC_OnTrailerLinked(playerid);

	if(p_tc_order_progress[playerid] == 1 && TC_IsTrailerNearTruck(playerid, 22.0))
	{
		AttachTrailerToVehicle(trailer, truck);
		if(TC_IsTrailerLinked(playerid))
		{
			TC_LogTrailerServer(playerid, "link_detect_p1");
			return TC_OnTrailerLinked(playerid);
		}
	}
	return 0;
}

stock TC_EnsureTrailerForCargo(playerid)
{
	new model_id = TC_GetRentModelId(playerid);
	if(!TC_ModelNeedsTrailer(model_id)) return 1;

	// On an accepted route the assigned trailer is hard-locked. Never let the
	// old tolerant "near truck == linked" shortcut bypass a real re-attachment.
	if(p_tc_order_progress[playerid] >= 2)
	{
		if(TC_ForceTrailerLock(playerid, true)) return 1;
		TC_RecoverTrailerForActiveCargo(playerid, true);
		return p_tc_trailer_vehicle[playerid] != -1;
	}

	// Before the first coupling keep the old mobile-friendly detection.
	if(TC_IsTrailerLinked(playerid)) return 1;

	new truck = p_tc_rent_vehicle[playerid];
	new trailer = p_tc_trailer_vehicle[playerid];
	if(truck == -1 || trailer == -1 || !IsValidVehicle(truck) || !IsValidVehicle(trailer))
		return 0;
	if(GetPlayerVehicleID(playerid) != truck)
		return 0;

	SetVehicleVirtualWorld(trailer, GetVehicleVirtualWorld(truck));
	LinkVehicleToInterior(trailer, GetPlayerInterior(playerid));
	AttachTrailerToVehicle(trailer, truck);
	TC_LogTrailerServer(playerid, "reattach_before_cargo");
	if(TC_IsTrailerLinked(playerid))
	{
		p_tc_trailer_was_attached[playerid] = true;
		return 1;
	}
	return 0;
}

stock bool:TC_IsTrailerPhysicallyLinked(playerid)
{
	new truck = p_tc_rent_vehicle[playerid];
	new trailer = p_tc_trailer_vehicle[playerid];
	if(truck == -1 || trailer == -1 || !IsValidVehicle(truck) || !IsValidVehicle(trailer))
		return false;
	return IsTrailerAttachedToVehicle(truck) && GetVehicleTrailer(truck) == trailer;
}

// Hard lock for an accepted TC route. Once the driver has attached the assigned
// trailer (progress >= 2), the route must never remain in a detached state.
// Do NOT use TC_IsTrailerLinked() here: that helper intentionally treats a nearby
// trailer as linked for mobile tolerance and used to leave a detached trailer loose.
stock TC_ForceTrailerLock(playerid, bool:allow_snap = true)
{
	if(p_tc_active_order[playerid] == -1 || p_tc_order_progress[playerid] < 2)
		return 0;
	if(!TC_ModelNeedsTrailer(TC_GetRentModelId(playerid)))
		return 1;

	new truck = p_tc_rent_vehicle[playerid];
	new trailer = p_tc_trailer_vehicle[playerid];
	if(truck == -1 || trailer == -1 || !IsValidVehicle(truck) || !IsValidVehicle(trailer))
		return 0;

	TC_RegisterGuardedVehicle(trailer, playerid);
	SetVehicleHealth(trailer, 100000.0);
	SetVehicleVirtualWorld(trailer, GetVehicleVirtualWorld(truck));
	LinkVehicleToInterior(trailer, GetPlayerInterior(playerid));

	if(TC_IsTrailerPhysicallyLinked(playerid))
	{
		p_tc_trailer_lock_fail_since_ms[playerid] = 0;
		p_tc_trailer_detach_misses[playerid] = 0;
		p_tc_trailer_detached[playerid] = false;
		p_tc_trailer_was_attached[playerid] = true;
		GetVehiclePos(trailer,
			p_tc_trailer_last_x[playerid],
			p_tc_trailer_last_y[playerid],
			p_tc_trailer_last_z[playerid]);
		p_tc_trailer_has_last_pos[playerid] = true;
		return 1;
	}

	// If some foreign/stale trailer id is linked to our truck, discard that link.
	new linked = GetVehicleTrailer(truck);
	if(linked != 0 && linked != trailer)
		DetachTrailerFromVehicle(truck);

	// Immediate hard re-link. There is deliberately no distance/angle gate here:
	// the assigned cargo trailer belongs to this route and must stay on this truck.
	AttachTrailerToVehicle(trailer, truck);
	p_tc_trailer_detached[playerid] = false;
	p_tc_trailer_was_attached[playerid] = true;
	p_tc_trailer_detach_misses[playerid] = 0;
	p_tc_trailer_last_recover_ms[playerid] = 0;

	if(TC_IsTrailerPhysicallyLinked(playerid))
	{
		p_tc_trailer_lock_fail_since_ms[playerid] = 0;
		return 1;
	}

	// Some mobile clients can keep a stale trailer transform after a severe jackknife.
	// Keep re-sending attach every update; only if the strict link still cannot be
	// restored for a short period, snap the same trailer behind the truck once.
	new now = GetTickCount();
	if(p_tc_trailer_lock_fail_since_ms[playerid] == 0)
		p_tc_trailer_lock_fail_since_ms[playerid] = now;

	if(allow_snap && now - p_tc_trailer_lock_fail_since_ms[playerid] >= TC_TRAILER_FORCE_SNAP_MS)
	{
		new Float:x, Float:y, Float:z, Float:a;
		if(TC_GetTrailerRecoveryPos(playerid, x, y, z, a))
		{
			SetVehiclePos(trailer, x, y, z);
			SetVehicleZAngle(trailer, a);
			SetVehicleVirtualWorld(trailer, GetVehicleVirtualWorld(truck));
			LinkVehicleToInterior(trailer, GetPlayerInterior(playerid));
			AttachTrailerToVehicle(trailer, truck);
			p_tc_trailer_lock_fail_since_ms[playerid] = now;
			p_tc_trailer_last_x[playerid] = x;
			p_tc_trailer_last_y[playerid] = y;
			p_tc_trailer_last_z[playerid] = z;
			p_tc_trailer_has_last_pos[playerid] = true;
			TC_LogTrailerServer(playerid, "hard_lock_snap");
		}
	}
	return 1;
}

stock TC_GetTrailerRecoveryPos(playerid, &Float:x, &Float:y, &Float:z, &Float:a)
{
	new truck = p_tc_rent_vehicle[playerid];
	if(truck == -1 || !IsValidVehicle(truck)) return 0;
	GetVehiclePos(truck, x, y, z);
	GetVehicleZAngle(truck, a);

	// Put the recovered trailer behind the truck, not inside the cab.
	x += 8.0 * floatsin(-a + 180.0, degrees);
	y += 8.0 * floatcos(-a + 180.0, degrees);
	z += 0.25;
	return 1;
}

stock TC_RecoverTrailerForActiveCargo(playerid, bool:allow_recreate = true)
{
	if(p_tc_active_order[playerid] == -1 || p_tc_order_progress[playerid] < 2) return 0;
	if(!TC_ModelNeedsTrailer(TC_GetRentModelId(playerid))) return 1;

	new truck = p_tc_rent_vehicle[playerid];
	if(truck == -1 || !IsValidVehicle(truck)) return 0;
	if(GetPlayerVehicleID(playerid) != truck) return 0;

	new now = GetTickCount();
	if(p_tc_trailer_last_recover_ms[playerid] != 0 &&
		now - p_tc_trailer_last_recover_ms[playerid] < TC_TRAILER_RECOVER_COOLDOWN_MS)
		return 0;
	p_tc_trailer_last_recover_ms[playerid] = now;

	new trailer = p_tc_trailer_vehicle[playerid];
	if(trailer != -1 && IsValidVehicle(trailer))
	{
		// A valid route trailer is hard-locked regardless of current angle/distance.
		// This replaces the old wait-for-misses behavior for normal detach/desync.
		if(TC_ForceTrailerLock(playerid, true))
			return 1;

		TC_RegisterGuardedVehicle(trailer, playerid);
		SetVehicleHealth(trailer, 100000.0);
		SetVehicleVirtualWorld(trailer, GetVehicleVirtualWorld(truck));
		LinkVehicleToInterior(trailer, GetPlayerInterior(playerid));

		new Float:dist = 99999.0;
		TC_GetTrailerDistance(playerid, dist);

		// First recovery is non-destructive: only ask SA-MP to re-link the
		// existing trailer. No teleport while a normal sync recovery is possible.
		if(dist <= TC_TRAILER_RELINK_DISTANCE)
		{
			AttachTrailerToVehicle(trailer, truck);
			if(TC_IsTrailerLinked(playerid))
			{
				p_tc_trailer_detached[playerid] = false;
				p_tc_trailer_was_attached[playerid] = true;
				p_tc_trailer_detach_misses[playerid] = 0;
				GetVehiclePos(trailer, p_tc_trailer_last_x[playerid], p_tc_trailer_last_y[playerid], p_tc_trailer_last_z[playerid]);
				p_tc_trailer_has_last_pos[playerid] = true;
				TC_LogTrailerServer(playerid, "recover_relink");
				return 1;
			}
		}

		// After a sustained desync the server-side position can be stale forever.
		// Move only the tracked TC trailer behind its own truck and keep progress.
		if(p_tc_trailer_detach_misses[playerid] >= TC_TRAILER_HARD_RECOVER_MISSES || dist > TC_TRAILER_HARD_DISTANCE)
		{
			new Float:x, Float:y, Float:z, Float:a;
			if(TC_GetTrailerRecoveryPos(playerid, x, y, z, a))
			{
				SetVehiclePos(trailer, x, y, z);
				SetVehicleZAngle(trailer, a);
				SetVehicleVirtualWorld(trailer, GetVehicleVirtualWorld(truck));
				LinkVehicleToInterior(trailer, GetPlayerInterior(playerid));
				AttachTrailerToVehicle(trailer, truck);
				p_tc_trailer_detached[playerid] = false;
				p_tc_trailer_was_attached[playerid] = true;
				p_tc_trailer_detach_misses[playerid] = 0;
				p_tc_trailer_last_x[playerid] = x;
				p_tc_trailer_last_y[playerid] = y;
				p_tc_trailer_last_z[playerid] = z;
				p_tc_trailer_has_last_pos[playerid] = true;
				TC_LogTrailerServer(playerid, "recover_reposition");
				return 1;
			}
		}
		return 0;
	}

	if(!allow_recreate) return 0;

	// Vehicle id can be lost after OnVehicleDeath/stream glitches. Recreate the
	// trailer, but DO NOT change p_tc_order_progress: loaded cargo stays loaded.
	new order_idx = p_tc_active_order[playerid];
	if(order_idx < 0 || order_idx >= MAX_TC_RUNTIME_ORDERS) return 0;
	new trailer_model = g_tc_rt_orders[order_idx][RT_TRAILER_MODEL];
	new Float:x, Float:y, Float:z, Float:a;
	if(!TC_GetTrailerRecoveryPos(playerid, x, y, z, a)) return 0;

	new trailerid = CreateVehicle(trailer_model, x, y, z, a, random(126), random(126), -1, 0, VEHICLE_ACTION_TYPE_TC, playerid);
	if(trailerid == INVALID_VEHICLE_ID) return 0;

	p_tc_trailer_vehicle[playerid] = trailerid;
	TC_RegisterGuardedVehicle(trailerid, playerid);
	SetVehicleHealth(trailerid, 100000.0);
	SetVehicleVirtualWorld(trailerid, GetVehicleVirtualWorld(truck));
	LinkVehicleToInterior(trailerid, GetPlayerInterior(playerid));
	AttachTrailerToVehicle(trailerid, truck);

	p_tc_trailer_detached[playerid] = false;
	p_tc_trailer_was_attached[playerid] = true;
	p_tc_trailer_detach_misses[playerid] = 0;
	p_tc_trailer_last_x[playerid] = x;
	p_tc_trailer_last_y[playerid] = y;
	p_tc_trailer_last_z[playerid] = z;
	p_tc_trailer_has_last_pos[playerid] = true;
	TC_LogTrailerServer(playerid, "recover_recreate");

	// Restore the marker for the stage that was active before recovery.
	TC_RestoreActiveCheckpoint(playerid);
	return 1;
}

forward TC_RecoverTrailerDelayed(playerid, order_idx, progress, epoch);
public TC_RecoverTrailerDelayed(playerid, order_idx, progress, epoch)
{
	if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
	if(g_BRAuthEpoch[playerid] != epoch) return 0;
	if(p_tc_active_order[playerid] != order_idx || p_tc_order_progress[playerid] != progress) return 0;
	if(progress < 2) return 0;
	return TC_RecoverTrailerForActiveCargo(playerid, true);
}

stock TC_MaintainTrailerOnRoute(playerid)
{
	if(p_tc_active_order[playerid] == -1 || p_tc_order_progress[playerid] < 2)
		return 0;

	new model_id = TC_GetRentModelId(playerid);
	if(!TC_ModelNeedsTrailer(model_id)) return 1;

	new truck = p_tc_rent_vehicle[playerid];
	if(truck == -1 || !IsValidVehicle(truck)) return 0;

	new trailer = p_tc_trailer_vehicle[playerid];
	if(trailer == -1 || !IsValidVehicle(trailer))
	{
		if(trailer != -1) TC_ClearGuardedVehicle(trailer);
		p_tc_trailer_vehicle[playerid] = -1;
		p_tc_trailer_last_recover_ms[playerid] = 0;
		p_tc_trailer_lock_fail_since_ms[playerid] = 0;

		// Real entity loss is the only case where recovery/recreation is needed.
		// Cargo/order progress is preserved; no "detached for 10 seconds" state.
		if(GetPlayerVehicleID(playerid) == truck)
			TC_RecoverTrailerForActiveCargo(playerid, true);
		return p_tc_trailer_vehicle[playerid] != -1;
	}

	// A valid assigned trailer is never allowed to remain detached. This call has
	// no angle or distance restriction and is repeated by OnPlayerUpdate + timer.
	return TC_ForceTrailerLock(playerid, true);
}

stock TC_SpawnTrailerForPlayer(playerid, bool:respawn_detach)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || p_tc_rent_vehicle[playerid] == -1) return 0;

	if(p_tc_active_order[playerid] == -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Сначала возьмите заказ у путевых листов.");
		return 0;
	}

	new order_idx = p_tc_active_order[playerid];
	new model_id = g_tc_fleet[p_tc_rent_fleet_idx[playerid]][TF_MODEL_ID];

	if(!TC_ModelNeedsTrailer(model_id))
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Для этого транспорта прицеп не нужен.");
		return 0;
	}

	if(p_tc_trailer_vehicle[playerid] != -1 && IsValidVehicle(p_tc_trailer_vehicle[playerid]))
	{
		if(!respawn_detach && !p_tc_trailer_detached[playerid])
		{
			SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Прицеп уже создан. Подцепите его к фуре.");
			return 0;
		}
		TC_ForceDestroyVehicle(p_tc_trailer_vehicle[playerid]);
		p_tc_trailer_vehicle[playerid] = -1;
	}

	p_tc_trailer_detached[playerid] = false;
	p_tc_trailer_was_attached[playerid] = false;
	p_tc_trailer_detach_misses[playerid] = 0;
	p_tc_trailer_last_recover_ms[playerid] = 0;
	p_tc_trailer_lock_fail_since_ms[playerid] = 0;
	p_tc_order_progress[playerid] = 1;

	new office = g_tc_companies[company_idx][TC_OFFICE];
	new slot = TC_GetRandomTrailerParkingSlot(office);
	new Float:x, Float:y, Float:z, Float:a;
	if(!TC_GetTrailerParkingPos(office, slot, x, y, z, a)) return 0;

	new trailer_model = g_tc_rt_orders[order_idx][RT_TRAILER_MODEL];

	new trailerid = CreateVehicle(trailer_model, x, y, z, a, random(126), random(126), -1, 0, VEHICLE_ACTION_TYPE_TC, playerid);
	if(trailerid == INVALID_VEHICLE_ID)
		return 0;

	p_tc_trailer_vehicle[playerid] = trailerid;
	TC_RegisterGuardedVehicle(trailerid, playerid);
	SetVehicleHealth(trailerid, 100000.0);

	SetVehicleVirtualWorld(trailerid, GetVehicleVirtualWorld(p_tc_rent_vehicle[playerid]));

	p_tc_trailer_last_x[playerid] = x;
	p_tc_trailer_last_y[playerid] = y;
	p_tc_trailer_last_z[playerid] = z;
	p_tc_trailer_has_last_pos[playerid] = true;

	SendClientMessage(playerid, TC_COLOR_GOOD, TC_MSG"Прицеп подготовлен. Подцепите его к фуре.");
	TC_LogTrailerServer(playerid, "spawn");

	if(TC_CanShowWorldCheckpoint(playerid))
	{
		TC_RememberRouteMarkerPos(playerid, x, y, z);
		SetPlayerCheckpoint(playerid, x, y, z, 6.0);
	}
	TC_Send(playerid, "Подъедьте к прицепу и подцепите его к фуре.");
	return 1;
}

stock TC_OnTrailerAttached(playerid)
{
	if(p_tc_active_order[playerid] == -1) return 0;

	new order_idx = p_tc_active_order[playerid];

	if(p_tc_order_progress[playerid] == 1)
	{
		TC_ClearRouteMarker(playerid);
		p_tc_order_progress[playerid] = 2;
		if(g_tc_rt_orders[order_idx][RT_FROM] == TC_POINT_MINE)
			TC_SelectMineLoadDock(playerid);
		TC_SetRouteCheckpoint(playerid, order_idx, true, TC_ROUTE_CHECKPOINT_SIZE);
		TC_LogTrailerServer(playerid, "attached_route_cp");
	}
	return 1;
}

stock TC_SetUnloadCheckpoint(playerid, order_idx, bool:notify = true)
{
	new Float:x, Float:y, Float:z;
	new to_point = g_tc_rt_orders[order_idx][RT_TO];

	if(g_tc_rt_orders[order_idx][RT_TYPE] == TC_ORDER_PRIVATE && g_tc_rt_orders[order_idx][RT_BUSINESS_ID] >= 0)
	{
		new bid = g_tc_rt_orders[order_idx][RT_BUSINESS_ID];
		x = GetBusinessData(bid, B_POS_X);
		y = GetBusinessData(bid, B_POS_Y);
		z = GetBusinessData(bid, B_POS_Z);
		p_tc_dest_port_dock[playerid] = -1;
	}
	else if(to_point == TC_POINT_PORT)
	{
		p_tc_dest_port_dock[playerid] = TC_GetRandomPortDock(x, y, z);
	}
	else
	{
		p_tc_dest_port_dock[playerid] = -1;
		TC_GetRoutePointPos(order_idx, false, x, y, z, playerid);
	}

	if(notify)
		TC_SendRouteMessage(playerid, order_idx, false);
	TC_PlaceRouteCheckpoint(playerid, x, y, z, TC_ROUTE_CHECKPOINT_SIZE);
	return 1;
}

stock TC_ShowReturnRentDialog(playerid)
{
	if(p_tc_rent_vehicle[playerid] == -1)
	{
		TC_ShowRentList(playerid, 0);
		return 0;
	}

	new fmt_str[256];
	if(p_tc_active_order[playerid] != -1)
		format(fmt_str, sizeof fmt_str,
			"{FFFFFF}У вас арендован транспорт и активный заказ.\n\
Сдать Sprinter сейчас — заказ будет отменён.\n\n\
Сдать транспорт?");
	else
		format(fmt_str, sizeof fmt_str,
			"{FFFFFF}У вас уже арендован транспорт.\n\
Сдать Sprinter и завершить аренду?");

	Dialog(playerid, DIALOG_TC_RETURN_RENT, DIALOG_STYLE_MSGBOX,
		"{FFFF24}Сдача транспорта", fmt_str, "Сдать", "Отмена");
	return 1;
}

stock TC_ReturnRentedTruck(playerid)
{
	if(p_tc_rent_vehicle[playerid] == -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"У вас нет арендованного транспорта.");
		return 0;
	}

	if(p_tc_active_order[playerid] != -1)
	{
		new order_idx = p_tc_active_order[playerid];
		if(order_idx >= 0 && g_tc_rt_orders[order_idx][RT_TYPE] == TC_ORDER_PRIVATE)
		{
			new bid = g_tc_rt_orders[order_idx][RT_BUSINESS_ID];
			if(bid >= 0) g_tc_private_business[bid] = -1;
		}
		if(order_idx >= 0 && g_tc_rt_orders[order_idx][RT_TYPE] != TC_ORDER_GOV)
			g_tc_rt_orders[order_idx][RT_USED] = 0;
	}

	TC_EndRent(playerid, false);
	SendClientMessage(playerid, TC_COLOR_GOOD, TC_MSG"Транспорт сдан. Аренда завершена.");
	return 1;
}

stock TC_GetRentModelId(playerid)
{
	if(p_tc_rent_fleet_idx[playerid] >= 0 && p_tc_rent_fleet_idx[playerid] < g_tc_fleet_loaded)
		return g_tc_fleet[p_tc_rent_fleet_idx[playerid]][TF_MODEL_ID];
	if(p_tc_rent_vehicle[playerid] != -1 && IsValidVehicle(p_tc_rent_vehicle[playerid]))
		return GetVehicleModel(p_tc_rent_vehicle[playerid]);
	return TC_VAN_MODEL_DEFAULT;
}

stock TC_AcceptOrder(playerid, order_idx)
{
	if(order_idx < 0 || order_idx >= MAX_TC_RUNTIME_ORDERS) return 0;
	if(!g_tc_rt_orders[order_idx][RT_USED]) return 0;
	if(p_tc_active_order[playerid] != -1)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Сначала завершите текущий заказ.");
		return 0;
	}
	if(g_tc_rt_orders[order_idx][RT_TYPE] != TC_ORDER_GOV && TC_IsOrderActiveForAnyPlayer(order_idx))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Этот заказ уже взял другой водитель.");
		return 0;
	}

	new company_idx = p_tc_company[playerid];
	if(g_tc_rt_orders[order_idx][RT_TYPE] == TC_ORDER_PRIVATE)
	{
		if(company_idx == -1 || !TC_CompanyHasTransportLicense(company_idx))
		{
			SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Частные заказы доступны после покупки лицензии на перевозку.");
			return 0;
		}
	}

	p_tc_active_order[playerid] = order_idx;

	if(g_tc_rt_orders[order_idx][RT_TYPE] == TC_ORDER_PRIVATE)
	{
		new bid = g_tc_rt_orders[order_idx][RT_BUSINESS_ID];
		new query[128];
		mysql_format(mysql, query, sizeof query,
			"UPDATE tc_orders SET status=1, taken_by=%d WHERE business_id=%d AND status=0 ORDER BY id DESC LIMIT 1",
			GetPlayerAccountID(playerid), bid);
		mysql_query(mysql, query, false);
	}

	new model_id = TC_GetRentModelId(playerid);
	if(TC_ModelNeedsTrailer(model_id))
	{
		if(TC_IsTrailerLinked(playerid))
		{
			p_tc_order_progress[playerid] = 2;
			if(g_tc_rt_orders[order_idx][RT_FROM] == TC_POINT_MINE)
				TC_SelectMineLoadDock(playerid);
			TC_SetRouteCheckpoint(playerid, order_idx, true, TC_ROUTE_CHECKPOINT_SIZE);
		}
		else
		{
			p_tc_order_progress[playerid] = 0;
			TC_Send(playerid, "Введите {FFFF24}/cargo{FFFFFF} для получения прицепа.");
		}
	}
	else
	{
		p_tc_order_progress[playerid] = 2;
		if(g_tc_rt_orders[order_idx][RT_FROM] == TC_POINT_MINE)
			TC_SelectMineLoadDock(playerid);
		TC_SetRouteCheckpoint(playerid, order_idx, true, TC_ROUTE_CHECKPOINT_SIZE);
	}

	return 1;
}

stock TC_CompleteOrder(playerid)
{
	new order_idx = p_tc_active_order[playerid];
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(order_idx < 0 || company_idx < 0) return 0;

	new total_pay = g_tc_rt_orders[order_idx][RT_TOTAL_PAY];
	new commission = g_tc_companies[company_idx][TC_COMMISSION];
	new driver_pay = TC_GetDriverPay(total_pay, commission);
	new company_take = total_pay - driver_pay;
	new order_type = g_tc_rt_orders[order_idx][RT_TYPE];

	GivePlayerMoneyEx(playerid, driver_pay, "Заказ ТК", true, true);
	TC_SetPlayerRating(playerid, p_tc_rating[playerid] + 1);

	new query[192];
	new acc_id = GetPlayerAccountID(playerid);
	mysql_format(mysql, query, sizeof query,
		"UPDATE accounts SET tc_rating_day=tc_rating_day+1, tc_rating_week=tc_rating_week+1 WHERE id=%d LIMIT 1", acc_id);
	mysql_query(mysql, query, false);

	g_tc_companies[company_idx][TC_BALANCE] += company_take;
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_companies SET balance=balance+%d WHERE id=%d LIMIT 1",
		company_take, g_tc_companies[company_idx][TC_SQL_ID]);
	mysql_query(mysql, query, false);
	TC_LogFinance(g_tc_companies[company_idx][TC_SQL_ID], 0, company_take, "Комиссия с заказа");

	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_employees SET orders_done=orders_done+1, earned=earned+%d WHERE company_id=%d AND account_id=%d LIMIT 1",
		driver_pay, g_tc_companies[company_idx][TC_SQL_ID], GetPlayerAccountID(playerid));
	mysql_query(mysql, query, false);

	new fleet_idx = p_tc_rent_fleet_idx[playerid];
	if(fleet_idx >= 0 && fleet_idx < g_tc_fleet_loaded)
	{
		g_tc_fleet[fleet_idx][TF_TRIPS_LEFT]--;
		if(g_tc_fleet[fleet_idx][TF_TRIPS_LEFT] <= 0)
			g_tc_fleet[fleet_idx][TF_BROKEN] = true;

		mysql_format(mysql, query, sizeof query,
			"UPDATE tc_fleet SET trips_left=%d, broken=%d WHERE id=%d LIMIT 1",
			g_tc_fleet[fleet_idx][TF_TRIPS_LEFT], g_tc_fleet[fleet_idx][TF_BROKEN], g_tc_fleet[fleet_idx][TF_SQL_ID]);
		mysql_query(mysql, query, false);

		if(g_tc_fleet[fleet_idx][TF_BROKEN])
		{
			SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Транспорт требует техобслуживания. Аренда завершена.");
			TC_EndRent(playerid, false);
			return 1;
		}
	}

	if(order_type == TC_ORDER_PRIVATE)
	{
		new bid = g_tc_rt_orders[order_idx][RT_BUSINESS_ID];
		if(bid >= 0 && bid < MAX_BUSINESS)
		{
			AddBusinessData(bid, B_PRODS, +, g_tc_rt_orders[order_idx][RT_AMOUNT]);
			mysql_format(mysql, query, sizeof query,
				"UPDATE business SET products=%d WHERE id=%d LIMIT 1",
				GetBusinessData(bid, B_PRODS), GetBusinessData(bid, B_SQL_ID));
			mysql_query(mysql, query, false);

			mysql_format(mysql, query, sizeof query,
				"UPDATE tc_orders SET status=2 WHERE business_id=%d AND status=1 ORDER BY id DESC LIMIT 1", bid);
			mysql_query(mysql, query, false);

			g_tc_private_business[bid] = -1;
		}
	}

	new done_msg[96];
	format(done_msg, sizeof done_msg, TC_MSG"Заказ выполнен. Вы получили {FFFF24}%d{FFFFFF} руб.", driver_pay);
	SendClientMessage(playerid, TC_COLOR_MSG, done_msg);

	if(p_tc_trailer_vehicle[playerid] != -1 && IsValidVehicle(p_tc_trailer_vehicle[playerid]))
	{
		DetachTrailerFromVehicle(p_tc_rent_vehicle[playerid]);
		TC_ForceDestroyVehicle(p_tc_trailer_vehicle[playerid]);
	}
	else if(p_tc_trailer_vehicle[playerid] != -1)
		TC_ClearGuardedVehicle(p_tc_trailer_vehicle[playerid]);

	if(order_type != TC_ORDER_GOV)
		g_tc_rt_orders[order_idx][RT_USED] = 0;

	p_tc_trailer_vehicle[playerid] = -1;
	p_tc_active_order[playerid] = -1;
	p_tc_order_progress[playerid] = 0;
	p_tc_trailer_detached[playerid] = false;
	p_tc_trailer_was_attached[playerid] = false;
	p_tc_trailer_lock_fail_since_ms[playerid] = 0;
	p_tc_dest_port_dock[playerid] = -1;
	p_tc_mine_load_dock[playerid] = -1;
	TC_ClearRouteMarker(playerid);
	return 1;
}

stock TC_IsAtLoadPoint(playerid, order_idx)
{
	if(g_tc_rt_orders[order_idx][RT_FROM] == TC_POINT_MINE)
		return TC_IsAtMineLoadPoint(playerid, TC_LOAD_POINT_RANGE);

	new Float:fx, Float:fy, Float:fz;
	TC_GetRoutePointPos(order_idx, true, fx, fy, fz, playerid);
	return IsPlayerInRangeOfPoint(playerid, TC_LOAD_POINT_RANGE, fx, fy, fz);
}

stock TC_IsAtUnloadPoint(playerid, order_idx)
{
	if(g_tc_rt_orders[order_idx][RT_TYPE] == TC_ORDER_PRIVATE && g_tc_rt_orders[order_idx][RT_BUSINESS_ID] >= 0)
	{
		new bid = g_tc_rt_orders[order_idx][RT_BUSINESS_ID];
		return IsPlayerInRangeOfPoint(playerid, TC_UNLOAD_POINT_RANGE,
			GetBusinessData(bid, B_POS_X), GetBusinessData(bid, B_POS_Y), GetBusinessData(bid, B_POS_Z));
	}
	if(g_tc_rt_orders[order_idx][RT_TO] == TC_POINT_PORT)
	{
		if(p_tc_dest_port_dock[playerid] >= 0 && p_tc_dest_port_dock[playerid] < sizeof g_tc_port_docks)
		{
			new d = p_tc_dest_port_dock[playerid];
			if(IsPlayerInRangeOfPoint(playerid, TC_UNLOAD_POINT_RANGE,
				g_tc_port_docks[d][0], g_tc_port_docks[d][1], g_tc_port_docks[d][2]))
				return 1;
		}
		return TC_IsNearAnyPortDock(playerid, TC_UNLOAD_POINT_RANGE);
	}

	new Float:dx, Float:dy, Float:dz;
	TC_GetRoutePointPos(order_idx, false, dx, dy, dz, playerid);
	return IsPlayerInRangeOfPoint(playerid, TC_UNLOAD_POINT_RANGE, dx, dy, dz);
}

stock TC_IsPlayerInRentTruck(playerid)
{
	if(p_tc_rent_vehicle[playerid] == -1) return 0;
	if(!IsValidVehicle(p_tc_rent_vehicle[playerid])) return 0;
	return GetPlayerVehicleID(playerid) == p_tc_rent_vehicle[playerid];
}

stock TC_CancelLoadUnloadOperation(playerid)
{
	if(p_tc_operation_timer[playerid])
	{
		KillTimer(p_tc_operation_timer[playerid]);
		p_tc_operation_timer[playerid] = 0;
	}
	if(p_tc_operation_watch_timer[playerid])
	{
		KillTimer(p_tc_operation_watch_timer[playerid]);
		p_tc_operation_watch_timer[playerid] = 0;
	}
	p_tc_operation_loading[playerid] = false;
	if(IsPlayerConnected(playerid))
		TogglePlayerControllable(playerid, true);
	return 1;
}

stock TC_StartLoadUnloadOperation(playerid, bool:loading)
{
	if(p_tc_operation_timer[playerid]) return 1;

	if(!TC_IsPlayerInRentTruck(playerid))
	{
		if(loading)
			TC_ShowNotify(playerid, TC_NOTIFY_ERROR, TC_NOTIFY_DUR, "Для загрузки нужно быть в арендованном Sprinter.", "OK");
		else
			TC_ShowNotify(playerid, TC_NOTIFY_ERROR, TC_NOTIFY_DUR, "Для разгрузки нужно быть в арендованном Sprinter.", "OK");
		return 1;
	}

	TogglePlayerControllable(playerid, false);
	p_tc_operation_loading[playerid] = loading;

	if(loading)
		TC_ShowNotify(playerid, TC_NOTIFY_INFO, TC_NOTIFY_DUR_LOAD, "Идёт загрузка груза...", "");
	else
		TC_ShowNotify(playerid, TC_NOTIFY_INFO, TC_NOTIFY_DUR_LOAD, "Идёт разгрузка груза...", "");

	p_tc_operation_watch_timer[playerid] = SetTimerEx("TC_LoadUnloadWatch", TC_LOAD_UNLOAD_WATCH_MS, true, "i", playerid);
	p_tc_operation_timer[playerid] = SetTimerEx("TC_OnLoadUnloadDone", TC_LOAD_UNLOAD_FREEZE_MS, false, "i", playerid);
	return 1;
}

forward TC_LoadUnloadWatch(playerid);
public TC_LoadUnloadWatch(playerid)
{
	if(!p_tc_operation_timer[playerid])
	{
		if(p_tc_operation_watch_timer[playerid])
		{
			KillTimer(p_tc_operation_watch_timer[playerid]);
			p_tc_operation_watch_timer[playerid] = 0;
		}
		return 0;
	}

	if(TC_IsPlayerInRentTruck(playerid)) return 1;

	new bool:loading = p_tc_operation_loading[playerid];
	TC_CancelLoadUnloadOperation(playerid);

	if(loading)
		TC_ShowNotify(playerid, TC_NOTIFY_ERROR, TC_NOTIFY_DUR, "Загрузка прервана — оставайтесь в арендованном Sprinter.", "OK");
	else
		TC_ShowNotify(playerid, TC_NOTIFY_ERROR, TC_NOTIFY_DUR, "Разгрузка прервана — оставайтесь в арендованном Sprinter.", "OK");
	return 1;
}

forward TC_OnLoadUnloadDone(playerid);
public TC_OnLoadUnloadDone(playerid)
{
	if(p_tc_operation_watch_timer[playerid])
	{
		KillTimer(p_tc_operation_watch_timer[playerid]);
		p_tc_operation_watch_timer[playerid] = 0;
	}
	p_tc_operation_timer[playerid] = 0;

	if(!IsPlayerConnected(playerid)) return 0;

	TogglePlayerControllable(playerid, true);

	if(p_tc_active_order[playerid] == -1) return 0;

	new order_idx = p_tc_active_order[playerid];
	new bool:loading = p_tc_operation_loading[playerid];
	p_tc_operation_loading[playerid] = false;

	if(!TC_IsPlayerInRentTruck(playerid))
	{
		if(loading)
			TC_ShowNotify(playerid, TC_NOTIFY_ERROR, TC_NOTIFY_DUR, "Загрузка прервана — оставайтесь в арендованном Sprinter.", "OK");
		else
			TC_ShowNotify(playerid, TC_NOTIFY_ERROR, TC_NOTIFY_DUR, "Разгрузка прервана — оставайтесь в арендованном Sprinter.", "OK");
		return 1;
	}

	if(loading)
	{
		if(p_tc_order_progress[playerid] != 2 || !TC_IsAtLoadPoint(playerid, order_idx))
		{
			TC_ShowNotify(playerid, TC_NOTIFY_ERROR, TC_NOTIFY_DUR, "Загрузка прервана — оставайтесь в точке.", "OK");
			return 1;
		}

		if(!TC_EnsureTrailerForCargo(playerid))
		{
			TC_ShowNotify(playerid, TC_NOTIFY_ERROR, TC_NOTIFY_DUR, "Сначала подцепите прицеп к фуре.", "OK");
			return 1;
		}

		TC_ClearRouteMarker(playerid);
		p_tc_order_progress[playerid] = 3;
		TC_SetUnloadCheckpoint(playerid, order_idx, true);
		TC_ShowNotify(playerid, TC_NOTIFY_SUCCESS, TC_NOTIFY_DUR, "Груз загружен.", "OK");
		return 1;
	}

	if(p_tc_order_progress[playerid] != 3 || !TC_IsAtUnloadPoint(playerid, order_idx))
	{
		TC_ShowNotify(playerid, TC_NOTIFY_ERROR, TC_NOTIFY_DUR, "Разгрузка прервана — оставайтесь в точке.", "OK");
		return 1;
	}

	if(!TC_EnsureTrailerForCargo(playerid))
	{
		TC_ShowNotify(playerid, TC_NOTIFY_ERROR, TC_NOTIFY_DUR, "Для разгрузки нужен прицеп. Введите /cargo.", "OK");
		return 1;
	}

	TC_ClearRouteMarker(playerid);
	TC_ShowNotify(playerid, TC_NOTIFY_SUCCESS, TC_NOTIFY_DUR, "Груз разгружен.", "OK");
	TC_CompleteOrder(playerid);
	return 1;
}

stock TC_OnTrailerUpdate(playerid, vehicleid)
{
	if(p_tc_active_order[playerid] == -1 || p_tc_trailer_vehicle[playerid] == -1) return 0;
	if(vehicleid != p_tc_trailer_vehicle[playerid]) return 0;
	if(GetPlayerVehicleID(playerid) != p_tc_rent_vehicle[playerid]) return 0;

	TC_LogTrailerServer(playerid, "OnTrailerUpdate");

	// After the first successful coupling, reject the idea of a detached route:
	// immediately restore the strict trailer->truck link on every trailer sync.
	if(p_tc_order_progress[playerid] >= 2)
	{
		TC_ForceTrailerLock(playerid, true);
		return 1;
	}

	if(!TC_IsTrailerLinked(playerid)) return 0;
	p_tc_trailer_detach_misses[playerid] = 0;
	p_tc_trailer_detached[playerid] = false;
	p_tc_trailer_was_attached[playerid] = true;
	p_tc_trailer_last_recover_ms[playerid] = 0;
	p_tc_trailer_lock_fail_since_ms[playerid] = 0;

	if(p_tc_order_progress[playerid] == 1)
		TC_OnTrailerLinked(playerid);
	return 1;
}

stock TC_OnPlayerEnterCheckpoint(playerid)
{
	if(p_tc_active_order[playerid] == -1) return 0;

	new order_idx = p_tc_active_order[playerid];

	if(p_tc_order_progress[playerid] == 2)
	{
		if(TC_IsAtLoadPoint(playerid, order_idx))
		{
			if(!TC_IsPlayerInRentTruck(playerid))
			{
				TC_ShowNotify(playerid, TC_NOTIFY_ERROR, TC_NOTIFY_DUR, "Для загрузки нужно быть в арендованном Sprinter.", "OK");
				return 1;
			}

			if(!TC_EnsureTrailerForCargo(playerid))
			{
				TC_LogTrailerDebug(playerid, "not_linked_at_load");
				SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Сначала подцепите прицеп к фуре.");
				return 1;
			}

			TC_StartLoadUnloadOperation(playerid, true);
			return 1;
		}
	}

	if(p_tc_order_progress[playerid] == 3)
	{
		if(TC_IsAtUnloadPoint(playerid, order_idx))
		{
			if(!TC_IsPlayerInRentTruck(playerid))
			{
				TC_ShowNotify(playerid, TC_NOTIFY_ERROR, TC_NOTIFY_DUR, "Для разгрузки нужно быть в арендованном Sprinter.", "OK");
				return 1;
			}

			if(!TC_EnsureTrailerForCargo(playerid))
			{
				TC_LogTrailerDebug(playerid, "not_linked_at_unload");
				SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Для разгрузки нужен прицеп. Введите {FFFF24}/cargo{FFFFFF}.");
				return 1;
			}

			TC_StartLoadUnloadOperation(playerid, false);
			return 1;
		}
	}

	if(p_tc_order_progress[playerid] == 1)
	{
		if(TC_IsTrailerLinked(playerid) || TC_IsTrailerNearTruck(playerid, 22.0))
		{
			TC_TryDetectTrailerLink(playerid);
			return 1;
		}

		new office = TC_GetOfficeByPlayer(playerid);
		new slot = TC_GetRandomTrailerParkingSlot(office);
		new Float:tx, Float:ty, Float:tz, Float:ta;
		if(TC_GetTrailerParkingPos(office, slot, tx, ty, tz, ta))
		{
			if(IsPlayerInRangeOfPoint(playerid, 8.0, tx, ty, tz))
			{
				DisablePlayerCheckpoint(playerid);
				SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Подцепите прицеп к фуре.");
				return 1;
			}
		}
	}
	return 0;
}

stock TC_JoinCompany(playerid, company_idx)
{
	if(company_idx < 0 || company_idx >= g_tc_companies_loaded) return 0;
	if(!TC_CheckEmploymentRequirements(playerid)) return 0;
	if(g_tc_companies[company_idx][TC_OWNER_ID] == -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"У этой компании нет владельца.");
		return 0;
	}
	if(TC_PlayerHasTcCompany(playerid))
	{
		if(TC_GetOwnedCompanyIndex(playerid) != -1)
			SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Вы владелец транспортной компании. Сначала продайте её.");
		else
			SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Вы уже состоите в транспортной компании.");
		return 0;
	}

	new company_sql = g_tc_companies[company_idx][TC_SQL_ID];
	new emp_cnt = TC_CountEmployeesSync(company_sql);
	if(emp_cnt >= TC_GetMaxEmployees(company_idx))
	{
		new msg[128];
		if(TC_CompanyHasUpgrade(company_idx, TC_UPGRADE_OFFICE))
			format(msg, sizeof msg, TC_MSG"В компании достигнут лимит сотрудников ({FFFF24}%d{FFFFFF}).", TC_EMPLOYEE_LIMIT_OFFICE);
		else
			format(msg, sizeof msg, TC_MSG"Лимит сотрудников ({FFFF24}%d{FFFFFF}). Купите улучшение офиса в меню компании.", TC_EMPLOYEE_LIMIT_BASE);
		SendClientMessage(playerid, TC_COLOR_ERROR, msg);
		return 0;
	}

	new account_id = GetPlayerAccountID(playerid);
	new query[256];

	mysql_format(mysql, query, sizeof query,
		"UPDATE accounts SET tc_company_id=%d WHERE id=%d LIMIT 1", company_sql, account_id);
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query,
		"INSERT IGNORE INTO tc_employees (company_id, account_id, hired_at) VALUES (%d, %d, %d)",
		company_sql, account_id, gettime());
	mysql_query(mysql, query, false);

	p_tc_company[playerid] = company_idx;
	SetPlayerData(playerid, P_TC_COMPANY_ID, company_sql);
	UpdatePlayerDatabaseInt(playerid, "tc_company_id", company_sql);
	SendClientMessage(playerid, TC_COLOR_GOOD, TC_MSG"Вы устроились в транспортную компанию.");
	return 1;
}

stock TC_LeaveCompany(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Вы не состоите в компании.");
		return 0;
	}
	if(TC_IsCompanyOwner(playerid, company_idx))
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Владелец не может покинуть компанию. Продайте её в меню «Управление».");
		return 0;
	}

	new account_id = GetPlayerAccountID(playerid);
	new company_sql = g_tc_companies[company_idx][TC_SQL_ID];
	new query[160];

	mysql_format(mysql, query, sizeof query,
		"DELETE FROM tc_employees WHERE company_id=%d AND account_id=%d", company_sql, account_id);
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query,
		"UPDATE accounts SET tc_company_id=0 WHERE id=%d LIMIT 1", account_id);
	mysql_query(mysql, query, false);

	TC_EndRent(playerid, false);
	p_tc_company[playerid] = -1;
	SetPlayerData(playerid, P_TC_COMPANY_ID, 0);
	UpdatePlayerDatabaseInt(playerid, "tc_company_id", 0);
	SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Вы покинули транспортную компанию.");
	return 1;
}

stock TC_ShowDepositDialog(playerid)
{
	if(!IsPlayerLogged(playerid)) return 0;
	new idx = TC_GetPlayerCompanyIndex(playerid);
	if(idx == -1 || g_tc_companies[idx][TC_OWNER_ID] <= 0) return 0;
	SetPVarInt(playerid, "TCDepositCompany", g_tc_companies[idx][TC_SQL_ID]);
	new body[256];
	format(body, sizeof body, "{FFFFFF}Введите сумму пополнения из денег на руках.\nБез комиссии.\nВаш баланс: %d руб.\nБаланс компании: %d руб.",
		GetPlayerMoneyEx(playerid), g_tc_companies[idx][TC_BALANCE]);
	Dialog(playerid, DIALOG_TC_DEPOSIT, DIALOG_STYLE_INPUT, "Пополнение компании", body, "Пополнить", "Назад");
	return 1;
}

stock TC_DepositMoney(playerid, company_sql, const input[])
{
	if(!IsPlayerLogged(playerid)) return 0;
	new idx = TC_GetPlayerCompanyIndex(playerid);
	if(idx == -1 || company_sql <= 0 || g_tc_companies[idx][TC_SQL_ID] != company_sql) return 0;
	if(g_tc_companies[idx][TC_OWNER_ID] <= 0) return 0;
	new amount, len = strlen(input);
	if(len < 1 || len > 10)
		return SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Введите целую положительную сумму цифрами.");
	for(new i; i < len; i++)
	{
		if(input[i] < '0' || input[i] > '9')
			return SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Допустимы только цифры.");
		new digit = input[i] - '0';
		if(amount > (2147483647 - digit) / 10)
			return SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Слишком большая сумма.");
		amount = amount * 10 + digit;
	}
	new cash = GetPlayerMoneyEx(playerid), balance = g_tc_companies[idx][TC_BALANCE];
	if(amount <= 0 || cash < amount)
		return SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Неверная сумма или недостаточно денег на руках.");
	if(balance < 0 || balance > 2147483647 - amount)
		return SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Достигнут лимит баланса компании.");

	// One atomic multi-table UPDATE; refuse nontransactional installations.
	new Cache:result = mysql_query(mysql, "SELECT COUNT(*) AS n FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('accounts','tc_companies') AND ENGINE='InnoDB'");
	new err = mysql_errno(mysql), engines;
	if(!err && cache_num_rows() == 1) engines = cache_get_field_content_int(0, "n");
	cache_delete(result);
	if(err || engines != 2)
	{
		printf("[TRUCK_COMPANY] Deposit refused player=%d company=%d errno=%d reason=transactional_tables_required", playerid, company_sql, err);
		return SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Пополнение недоступно: требуется проверка БД администратором. Деньги не списаны.");
	}
	new query[768], account = GetPlayerAccountID(playerid);
	mysql_format(mysql, query, sizeof query,
		"UPDATE accounts a JOIN tc_companies c ON c.id=%d SET a.money=a.money-%d,c.balance=c.balance+%d WHERE a.id=%d AND a.money=%d AND a.money>=%d AND c.balance=%d AND c.owner_id=%d AND c.owner_id>0 AND (c.owner_id=a.id OR (a.tc_company_id=c.id AND EXISTS (SELECT 1 FROM tc_employees e WHERE e.company_id=c.id AND e.account_id=a.id)))",
		company_sql, amount, amount, account, cash, amount, balance, g_tc_companies[idx][TC_OWNER_ID]);
	result = mysql_query(mysql, query);
	err = mysql_errno(mysql);
	new affected;
	if(!err) affected = cache_affected_rows();
	cache_delete(result);
	if(err || affected != 2)
	{
		printf("[TRUCK_COMPANY] Deposit failed player=%d account=%d company=%d amount=%d errno=%d affected=%d", playerid, account, company_sql, amount, err, affected);
		return SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Перевод не подтверждён: проверьте членство и баланс, откройте меню повторно.");
	}
	// SQL already saved both balances. Keep the existing wallet/HUD/log API, without a second account UPDATE.
	GivePlayerMoneyEx(playerid, -amount, "Пополнение ТК", false, true);
	g_tc_companies[idx][TC_BALANCE] += amount;
	TC_LogFinance(company_sql, TC_FIN_DEPOSIT, amount, "Пополнение участником");
	printf("[TRUCK_COMPANY] Deposit success player=%d account=%d company=%d amount=%d balance=%d", playerid, account, company_sql, amount, g_tc_companies[idx][TC_BALANCE]);
	new message[128];
	format(message, sizeof message, TC_MSG"Баланс компании пополнен на %d руб. Теперь в кассе: %d руб.", amount, g_tc_companies[idx][TC_BALANCE]);
	SendClientMessage(playerid, TC_COLOR_MSG, message);
	return 1;
}

stock TC_WithdrawMoney(playerid, amount)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	if(amount <= 0)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Неверная сумма.");
		return 0;
	}
	if(amount > g_tc_companies[company_idx][TC_BALANCE])
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"В кассе компании недостаточно денег.");
		return 0;
	}

	new fee = amount * TC_WITHDRAW_FEE_PERCENT / 100;
	new gain = amount - fee;

	g_tc_companies[company_idx][TC_BALANCE] -= amount;
	new query[160];
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_companies SET balance=balance-%d WHERE id=%d LIMIT 1", amount, g_tc_companies[company_idx][TC_SQL_ID]);
	mysql_query(mysql, query, false);
	TC_LogFinance(g_tc_companies[company_idx][TC_SQL_ID], 1, amount, "Снятие из кассы");

	GivePlayerMoneyEx(playerid, gain, "Снятие из кассы ТК", true, true);

	new msg[128];
	format(msg, sizeof msg, TC_MSG"Снято {FFFF24}%d{FFFFFF} руб. (комиссия %d%%: %d руб.). На руки: {FFFF24}%d{FFFFFF} руб.",
		amount, TC_WITHDRAW_FEE_PERCENT, fee, gain);
	SendClientMessage(playerid, TC_COLOR_MSG, msg);
	return 1;
}

stock TC_RenameCompany(playerid, const newname[])
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	new len = strlen(newname);
	if(len < 2 || len > 32)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Название должно быть от 2 до 32 символов.");
		return 0;
	}

	if(!TC_IsValidCompanyName(newname))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Название только на английском: буквы A-Z, цифры, пробел и _.");
		return 0;
	}

	new elapsed = gettime() - g_tc_companies[company_idx][TC_LAST_RENAME];
	if(g_tc_companies[company_idx][TC_LAST_RENAME] > 0 && elapsed < TC_RENAME_COOLDOWN_DAYS * 86400)
	{
		new days_left = (TC_RENAME_COOLDOWN_DAYS * 86400 - elapsed) / 86400 + 1;
		new msg[128];
		format(msg, sizeof msg, TC_MSG"Менять название можно раз в 7 дней. Осталось дней: {FFFF24}%d{FFFFFF}.", days_left);
		SendClientMessage(playerid, TC_COLOR_ERROR, msg);
		return 0;
	}

	if(GetPlayerMoneyEx(playerid) < TC_RENAME_PRICE)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Недостаточно денег для смены названия (100000).");
		return 0;
	}

	GivePlayerMoneyEx(playerid, -TC_RENAME_PRICE, "Смена названия ТК", true, true);

	new clean_name[48];
	format(clean_name, sizeof clean_name, "%s", newname);
	format(g_tc_company_name[company_idx], 48, "%s", clean_name);
	g_tc_companies[company_idx][TC_LAST_RENAME] = gettime();

	new query[160];
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_companies SET name='%e', last_rename=%d WHERE id=%d LIMIT 1",
		clean_name, gettime(), g_tc_companies[company_idx][TC_SQL_ID]);
	mysql_query(mysql, query, false);

	new msg[96];
	format(msg, sizeof msg, TC_MSG"Название изменено: {FFFF24}%s", clean_name);
	SendClientMessage(playerid, TC_COLOR_GOOD, msg);
	return 1;
}

stock TC_SetCommission(playerid, percent)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	if(percent < TC_COMMISSION_MIN || percent > TC_COMMISSION_MAX)
	{
		new msg[96];
		format(msg, sizeof msg, TC_MSG"Комиссия должна быть от %d%% до %d%%.", TC_COMMISSION_MIN, TC_COMMISSION_MAX);
		SendClientMessage(playerid, TC_COLOR_ERROR, msg);
		return 0;
	}

	g_tc_companies[company_idx][TC_COMMISSION] = percent;
	new query[128];
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_companies SET commission=%d WHERE id=%d LIMIT 1", percent, g_tc_companies[company_idx][TC_SQL_ID]);
	mysql_query(mysql, query, false);

	new msg[96];
	format(msg, sizeof msg, TC_MSG"Комиссия компании установлена на {FFFF24}%d%%{FFFFFF}.", percent);
	SendClientMessage(playerid, TC_COLOR_GOOD, msg);
	return 1;
}

stock TC_PrepareFireTarget(playerid, inputtext[])
{
	if(isnull(inputtext))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Введите ID или имя сотрудника.");
		return 0;
	}

	p_tc_fire_target[playerid][0] = 0;

	if(IsNumeric(inputtext))
	{
		new pid = strval(inputtext);
		if(!IsPlayerConnected(pid) || !IsPlayerLogged(pid))
		{
			SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Игрок с таким ID не в сети.");
			return 0;
		}
		GetPlayerName(pid, p_tc_fire_target[playerid], 24);
		return 1;
	}

	format(p_tc_fire_target[playerid], 24, "%s", inputtext);
	return 1;
}

stock TC_FireEmployee(playerid, targetname[])
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	new company_sql = g_tc_companies[company_idx][TC_SQL_ID];
	new targetid = GetPlayerID(targetname);

	if(targetid != INVALID_PLAYER_ID && IsPlayerLogged(targetid))
	{
		new acc = GetPlayerAccountID(targetid);
		if(acc == g_tc_companies[company_idx][TC_OWNER_ID])
		{
			SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Нельзя уволить владельца.");
			return 0;
		}
		new query[160];
		mysql_format(mysql, query, sizeof query,
			"DELETE FROM tc_employees WHERE company_id=%d AND account_id=%d LIMIT 1", company_sql, acc);
		mysql_query(mysql, query, false);
		mysql_format(mysql, query, sizeof query, "UPDATE accounts SET tc_company_id=0 WHERE id=%d LIMIT 1", acc);
		mysql_query(mysql, query, false);

		p_tc_company[targetid] = -1;
		SetPlayerData(targetid, P_TC_COMPANY_ID, 0);
		UpdatePlayerDatabaseInt(targetid, "tc_company_id", 0);
		TC_EndRent(targetid, false);
		SendClientMessage(targetid, TC_COLOR_MSG, TC_MSG"Вас уволили из транспортной компании.");
		SendClientMessage(playerid, TC_COLOR_GOOD, TC_MSG"Сотрудник уволен.");
		return 1;
	}

	new query[192];
	mysql_format(mysql, query, sizeof query,
		"UPDATE accounts SET tc_company_id=0 WHERE name='%e' AND tc_company_id=%d LIMIT 1", targetname, company_sql);
	mysql_query(mysql, query, false);
	mysql_format(mysql, query, sizeof query,
		"DELETE te FROM tc_employees te JOIN accounts a ON a.id=te.account_id WHERE a.name='%e' AND te.company_id=%d LIMIT 1",
		targetname, company_sql);
	mysql_query(mysql, query, false);
	SendClientMessage(playerid, TC_COLOR_GOOD, TC_MSG"Сотрудник уволен (оффлайн).");
	return 1;
}

stock TC_SellCompany(playerid)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	new company_sql = g_tc_companies[company_idx][TC_SQL_ID];
	new refund = g_tc_companies[company_idx][TC_BALANCE] * TC_SELL_REFUND_PERCENT / 100;
	if(refund > 0)
		GivePlayerMoneyEx(playerid, refund, "Закрытие ТК", true, true);

	new query[160];

	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_companies SET owner_id=-1, balance=0, upgrade_office=0, upgrade_garage=0, upgrade_licenses=0 WHERE id=%d LIMIT 1", company_sql);
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query, "UPDATE accounts SET tc_company_id=0 WHERE tc_company_id=%d", company_sql);
	mysql_query(mysql, query, false);
	mysql_format(mysql, query, sizeof query, "DELETE FROM tc_employees WHERE company_id=%d", company_sql);
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query, "DELETE FROM tc_fleet WHERE company_id=%d", company_sql);
	mysql_query(mysql, query, false);

	g_tc_companies[company_idx][TC_OWNER_ID] = -1;
	g_tc_companies[company_idx][TC_BALANCE] = 0;
	g_tc_companies[company_idx][TC_UPG_OFFICE] = 0;
	g_tc_companies[company_idx][TC_UPG_GARAGE] = 0;
	g_tc_companies[company_idx][TC_UPG_LICENSE] = 0;
	format(g_tc_owner_name[company_idx], 24, "Свободна");

	foreach(new i : Player)
	{
		if(IsPlayerLogged(i) && p_tc_company[i] == company_idx)
		{
			p_tc_company[i] = -1;
			SetPlayerData(i, P_TC_COMPANY_ID, 0);
			TC_EndRent(i, false);
		}
	}

	new msg[128];
	format(msg, sizeof msg, TC_MSG"Компания закрыта. Возврат из кассы: {FFFF24}%d{FFFFFF} руб.", refund);
	SendClientMessage(playerid, TC_COLOR_MSG, msg);
	TC_LoadFleet();
	return 1;
}

stock TC_BuyFleet(playerid, model_type)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	// Fleet purchase is Sprinter-only. Reject legacy truck/DAF dialog values too,
	// so old clients cannot buy them by sending a stale listitem/model type.
	if(model_type != TC_BUY_TYPE_VAN) return 0;

	new price = TC_BUY_VAN_PRICE;
	new model = TC_VAN_MODEL_DEFAULT;
	new name[32];
	format(name, sizeof name, "Mercedes-Benz Sprinter");

	if(g_tc_companies[company_idx][TC_BALANCE] < price)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"В кассе компании недостаточно денег на покупку.");
		return 0;
	}

	new fleet_cnt = TC_GetFleetCountForCompany(g_tc_companies[company_idx][TC_SQL_ID]);
	if(fleet_cnt >= TC_GetMaxFleetSlots(company_idx))
	{
		new msg[128];
		if(TC_CompanyHasUpgrade(company_idx, TC_UPGRADE_GARAGE))
			format(msg, sizeof msg, TC_MSG"Лимит автопарка ({FFFF24}%d{FFFFFF} машин).", TC_GetMaxFleetSlots(company_idx));
		else
			format(msg, sizeof msg, TC_MSG"Лимит автопарка ({FFFF24}%d{FFFFFF}). Купите улучшение гаража.", TC_FLEET_LIMIT_BASE);
		SendClientMessage(playerid, TC_COLOR_ERROR, msg);
		return 0;
	}

	g_tc_companies[company_idx][TC_BALANCE] -= price;
	new query[256];
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_companies SET balance=balance-%d WHERE id=%d LIMIT 1", price, g_tc_companies[company_idx][TC_SQL_ID]);
	mysql_query(mysql, query, false);
	TC_LogFinance(g_tc_companies[company_idx][TC_SQL_ID], 2, price, "Покупка ТС");

	mysql_format(mysql, query, sizeof query,
		"INSERT INTO tc_fleet (company_id, model_id, name, rent_price, trips_left, trips_max, broken, rented_account_id, created_at) \
		VALUES (%d, %d, '%e', 1000, %d, %d, 0, -1, %d)",
		g_tc_companies[company_idx][TC_SQL_ID], model, name, TC_FLEET_TRIPS_MAX, TC_FLEET_TRIPS_MAX, gettime());
	mysql_query(mysql, query, false);

	SendClientMessage(playerid, TC_COLOR_GOOD, TC_MSG"Транспорт добавлен в автопарк.");
	TC_LoadFleet();
	return 1;
}

stock TC_RepairFleet(playerid, fleet_idx)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;
	if(fleet_idx < 0 || fleet_idx >= g_tc_fleet_loaded) return 0;
	if(g_tc_fleet[fleet_idx][TF_COMPANY_ID] != g_tc_companies[company_idx][TC_SQL_ID]) return 0;

	if(!g_tc_fleet[fleet_idx][TF_BROKEN] && g_tc_fleet[fleet_idx][TF_TRIPS_LEFT] > 0)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Этому ТС не требуется обслуживание.");
		return 0;
	}
	if(g_tc_companies[company_idx][TC_BALANCE] < TC_REPAIR_PRICE)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"В кассе недостаточно денег на Т/О.");
		return 0;
	}

	g_tc_companies[company_idx][TC_BALANCE] -= TC_REPAIR_PRICE;
	g_tc_fleet[fleet_idx][TF_BROKEN] = false;
	g_tc_fleet[fleet_idx][TF_TRIPS_LEFT] = g_tc_fleet[fleet_idx][TF_TRIPS_MAX];

	new query[160];
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_companies SET balance=balance-%d WHERE id=%d LIMIT 1", TC_REPAIR_PRICE, g_tc_companies[company_idx][TC_SQL_ID]);
	mysql_query(mysql, query, false);
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_fleet SET broken=0, trips_left=%d WHERE id=%d LIMIT 1",
		g_tc_fleet[fleet_idx][TF_TRIPS_MAX], g_tc_fleet[fleet_idx][TF_SQL_ID]);
	mysql_query(mysql, query, false);
	TC_LogFinance(g_tc_companies[company_idx][TC_SQL_ID], 2, TC_REPAIR_PRICE, "Техобслуживание");

	SendClientMessage(playerid, TC_COLOR_GOOD, TC_MSG"Техобслуживание выполнено.");
	return 1;
}

stock TC_SellFleetVehicle(playerid, fleet_idx)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;
	if(fleet_idx < 0 || fleet_idx >= g_tc_fleet_loaded) return 0;
	if(g_tc_fleet[fleet_idx][TF_COMPANY_ID] != g_tc_companies[company_idx][TC_SQL_ID]) return 0;

	if(g_tc_fleet[fleet_idx][TF_RENTED_ACCOUNT_ID] != -1)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Нельзя продать арендованный транспорт.");
		return 0;
	}

	new refund = TC_GetFleetSellRefund(g_tc_fleet[fleet_idx][TF_MODEL_ID]);
	g_tc_companies[company_idx][TC_BALANCE] += refund;

	new query[160];
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_companies SET balance=balance+%d WHERE id=%d LIMIT 1",
		refund, g_tc_companies[company_idx][TC_SQL_ID]);
	mysql_query(mysql, query, false);
	mysql_format(mysql, query, sizeof query,
		"DELETE FROM tc_fleet WHERE id=%d LIMIT 1", g_tc_fleet[fleet_idx][TF_SQL_ID]);
	mysql_query(mysql, query, false);
	TC_LogFinance(g_tc_companies[company_idx][TC_SQL_ID], 0, refund, "Продажа ТС");

	new msg[96];
	format(msg, sizeof msg, TC_MSG"Транспорт продан. В кассу зачислено {FFFF24}%d{FFFFFF} руб.", refund);
	SendClientMessage(playerid, TC_COLOR_GOOD, msg);
	TC_LoadFleet();
	return 1;
}

stock TC_SetFleetRentPrice(playerid, fleet_idx, price)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;
	if(fleet_idx < 0 || fleet_idx >= g_tc_fleet_loaded) return 0;
	if(g_tc_fleet[fleet_idx][TF_COMPANY_ID] != g_tc_companies[company_idx][TC_SQL_ID]) return 0;
	if(price < TC_RENT_PRICE_MIN || price > TC_RENT_PRICE_MAX)
	{
		new msg[96];
		format(msg, sizeof msg, TC_MSG"Стоимость аренды: от %d до %d руб.", TC_RENT_PRICE_MIN, TC_RENT_PRICE_MAX);
		SendClientMessage(playerid, TC_COLOR_ERROR, msg);
		return 0;
	}

	g_tc_fleet[fleet_idx][TF_RENT_PRICE] = price;
	new query[128];
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_fleet SET rent_price=%d WHERE id=%d LIMIT 1", price, g_tc_fleet[fleet_idx][TF_SQL_ID]);
	mysql_query(mysql, query, false);
	SendClientMessage(playerid, TC_COLOR_GOOD, TC_MSG"Стоимость аренды обновлена.");
	return 1;
}

stock TC_AdminSetCompanyName(company_sql, const newname[])
{
	new idx = TC_GetCompanyIndexBySqlId(company_sql);
	if(idx == -1) return 0;

	new clean_name[48];
	format(clean_name, sizeof clean_name, "%s", newname);
	format(g_tc_company_name[idx], 48, "%s", clean_name);
	new query[160];
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_companies SET name='%e' WHERE id=%d LIMIT 1", clean_name, company_sql);
	mysql_query(mysql, query, false);
	return 1;
}

stock TC_AdminResetRenameCooldown(company_sql)
{
	new idx = TC_GetCompanyIndexBySqlId(company_sql);
	if(idx == -1) return 0;

	g_tc_companies[idx][TC_LAST_RENAME] = 0;
	new query[96];
	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_companies SET last_rename=0 WHERE id=%d LIMIT 1", company_sql);
	mysql_query(mysql, query, false);
	return 1;
}

stock TC_AdminGiveCompany(playerid, company_idx, targetid)
{
	if(company_idx < 0 || company_idx >= g_tc_companies_loaded) return 0;
	if(targetid == INVALID_PLAYER_ID || !IsPlayerLogged(targetid)) return 0;

	if(TC_PlayerHasTcCompany(targetid, company_idx))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"У игрока уже есть транспортная компания.");
		return 0;
	}

	new account_id = GetPlayerAccountID(targetid);
	new company_sql = g_tc_companies[company_idx][TC_SQL_ID];
	new prev_owner = g_tc_companies[company_idx][TC_OWNER_ID];
	new query[192];

	if(prev_owner != -1 && prev_owner != account_id)
	{
		mysql_format(mysql, query, sizeof query,
			"DELETE FROM tc_employees WHERE company_id=%d AND account_id=%d",
			company_sql, prev_owner);
		mysql_query(mysql, query, false);

		mysql_format(mysql, query, sizeof query,
			"UPDATE accounts SET tc_company_id=0 WHERE id=%d AND tc_company_id=%d LIMIT 1",
			prev_owner, company_sql);
		mysql_query(mysql, query, false);

		foreach(new i : Player)
		{
			if(!IsPlayerLogged(i)) continue;
			if(GetPlayerAccountID(i) != prev_owner) continue;
			p_tc_company[i] = -1;
			SetPlayerData(i, P_TC_COMPANY_ID, 0);
			TC_EndRent(i, false);
			SendClientMessage(i, TC_COLOR_MSG, TC_MSG"С вас снято владение транспортной компанией.");
			break;
		}
	}

	mysql_format(mysql, query, sizeof query,
		"UPDATE tc_companies SET owner_id=%d WHERE id=%d LIMIT 1", account_id, company_sql);
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query,
		"UPDATE accounts SET tc_company_id=%d WHERE id=%d LIMIT 1", company_sql, account_id);
	mysql_query(mysql, query, false);

	g_tc_companies[company_idx][TC_OWNER_ID] = account_id;
	GetPlayerName(targetid, g_tc_owner_name[company_idx], 24);
	p_tc_company[targetid] = company_idx;
	SetPlayerData(targetid, P_TC_COMPANY_ID, company_sql);
	UpdatePlayerDatabaseInt(targetid, "tc_company_id", company_sql);

	SendClientMessage(playerid, TC_COLOR_GOOD, TC_MSG"Компания выдана игроку.");
	SendClientMessage(targetid, TC_COLOR_GOOD, TC_MSG"Вам выдана транспортная компания!");
	TC_RequestAdminCompanyList(playerid);
	return 1;
}

stock TC_BuyCompanyUpgrade(playerid, upgrade_type)
{
	new company_idx = TC_GetPlayerCompanyIndex(playerid);
	if(company_idx == -1 || !TC_IsCompanyOwner(playerid, company_idx)) return 0;

	if(TC_CompanyHasUpgrade(company_idx, upgrade_type))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Это улучшение уже приобретено.");
		return 0;
	}

	new price, note[48], msg[128];
	switch(upgrade_type)
	{
		case TC_UPGRADE_OFFICE:
		{
			price = TC_UPGRADE_OFFICE_PRICE;
			format(note, sizeof note, "Покупка офиса");
			format(msg, sizeof msg, TC_MSG"Куплено улучшение: {FFFF24}150 рабочих мест{FFFFFF}.");
		}
		case TC_UPGRADE_GARAGE:
		{
			price = TC_UPGRADE_GARAGE_PRICE;
			format(note, sizeof note, "Места в гараже");
			format(msg, sizeof msg, TC_MSG"Куплено улучшение: {FFFF24}+20 мест{FFFFFF} в автопарке.");
		}
		case TC_UPGRADE_LICENSE:
		{
			price = TC_UPGRADE_LICENSE_PRICE;
			format(note, sizeof note, "Лицензии перевозки");
			format(msg, sizeof msg, TC_MSG"Приобретены лицензии на перевозку {FFFF24}продуктов, топлива, оружия{FFFFFF}.");
		}
		default: return 0;
	}

	if(g_tc_companies[company_idx][TC_BALANCE] < price)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"В кассе компании недостаточно денег.");
		return 0;
	}

	g_tc_companies[company_idx][TC_BALANCE] -= price;
	switch(upgrade_type)
	{
		case TC_UPGRADE_OFFICE: g_tc_companies[company_idx][TC_UPG_OFFICE] = 1;
		case TC_UPGRADE_GARAGE: g_tc_companies[company_idx][TC_UPG_GARAGE] = 1;
		case TC_UPGRADE_LICENSE: g_tc_companies[company_idx][TC_UPG_LICENSE] = 1;
	}

	new query[192];
	switch(upgrade_type)
	{
		case TC_UPGRADE_OFFICE:
			mysql_format(mysql, query, sizeof query,
				"UPDATE tc_companies SET balance=balance-%d, upgrade_office=1 WHERE id=%d LIMIT 1",
				price, g_tc_companies[company_idx][TC_SQL_ID]);
		case TC_UPGRADE_GARAGE:
			mysql_format(mysql, query, sizeof query,
				"UPDATE tc_companies SET balance=balance-%d, upgrade_garage=1 WHERE id=%d LIMIT 1",
				price, g_tc_companies[company_idx][TC_SQL_ID]);
		case TC_UPGRADE_LICENSE:
			mysql_format(mysql, query, sizeof query,
				"UPDATE tc_companies SET balance=balance-%d, upgrade_licenses=1 WHERE id=%d LIMIT 1",
				price, g_tc_companies[company_idx][TC_SQL_ID]);
	}
	mysql_query(mysql, query, false);
	TC_LogFinance(g_tc_companies[company_idx][TC_SQL_ID], TC_FIN_EXPENSE, price, note);
	SendClientMessage(playerid, TC_COLOR_GOOD, msg);
	return 1;
}

stock TC_SendChatMessage(playerid, message[])
{
	if(p_tc_company[playerid] == -1) return 0;
	if(isnull(message)) return 0;

	new company_idx = p_tc_company[playerid];
	new cname[48], pname[24], text[128];
	TC_GetCompanyDisplayName(company_idx, cname, sizeof cname);
	format(pname, sizeof pname, "%s", GetPlayerNameEx(playerid));
	format(text, sizeof text, "%s", message);

	new chat_line[192];
	chat_line[0] = 0;
	strcat(chat_line, "{FFFF24}[", sizeof chat_line);
	strcat(chat_line, cname, sizeof chat_line);
	strcat(chat_line, "]{FFFFFF} ", sizeof chat_line);

	new part[96];
	format(part, sizeof part, "%s [%d]: ", pname, playerid);
	strcat(chat_line, part, sizeof chat_line);
	strcat(chat_line, text, sizeof chat_line);

	foreach(new i : Player)
	{
		if(!IsPlayerLogged(i)) continue;
		if(p_tc_company[i] == -1) continue;
		SendClientMessage(i, TC_COLOR_MSG, chat_line);
	}
	return 1;
}

stock TC_SetPlayerRating(playerid, rating)
{
	p_tc_rating[playerid] = rating;
	SetPlayerData(playerid, P_TC_RATING, rating);
	UpdatePlayerDatabaseInt(playerid, "tc_rating", rating);
}

stock TC_OnPlayerDataLoaded(playerid)
{
	new query[128];
	mysql_format(mysql, query, sizeof query, "SELECT tc_company_id,tc_rating FROM accounts WHERE id=%d LIMIT 1", GetPlayerAccountID(playerid));
	mysql_tquery(mysql, query, "TC_OnPlayerBindingLoaded", "iii", playerid, GetPlayerAccountID(playerid), g_BRAuthEpoch[playerid]);
	return 1;
}

forward TC_OnPlayerBindingLoaded(playerid, accountid, epoch);
public TC_OnPlayerBindingLoaded(playerid, accountid, epoch)
{
	if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
	if(GetPlayerAccountID(playerid) != accountid || g_BRAuthEpoch[playerid] != epoch) return 1;
	if(!cache_num_rows()) return 1;
	SetPlayerData(playerid, P_TC_COMPANY_ID, cache_get_field_content_int(0, "tc_company_id"));
	SetPlayerData(playerid, P_TC_RATING, cache_get_field_content_int(0, "tc_rating"));
	p_tc_rating[playerid] = GetPlayerData(playerid, P_TC_RATING);
	TC_SyncPlayerCompanyBinding(playerid);

	if(p_tc_rent_vehicle[playerid] == -1)
		TC_ReleaseAccountFleetRents(GetPlayerAccountID(playerid));
	return 1;
}

stock TC_OnPlayerDeath(playerid)
{
	if(p_tc_rent_vehicle[playerid] != -1 || p_tc_rent_fleet_idx[playerid] != -1)
		TC_EndRent(playerid, false);
	return 1;
}

stock TC_OnVehicleSpawn(vehicleid)
{
	new bool:handled;

	if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_TC)
	{
		TC_GuardVehicle(vehicleid, true);
		SetVehicleHealth(vehicleid, 100000.0);
		handled = true;
	}

	foreach(new i : Player)
	{
		if(p_tc_trailer_vehicle[i] != vehicleid)
			continue;

		TC_RegisterGuardedVehicle(vehicleid, i);
		if(p_tc_rent_vehicle[i] != -1 && IsValidVehicle(p_tc_rent_vehicle[i]))
			SetVehicleVirtualWorld(vehicleid, GetVehicleVirtualWorld(p_tc_rent_vehicle[i]));
		TC_LogTrailerDebug(i, "respawn");
		handled = true;
		break;
	}

	return handled ? 1 : 0;
}

stock TC_OnVehicleDeath(vehicleid)
{
	foreach(new i : Player)
	{
		if(p_tc_rent_vehicle[i] == vehicleid)
		{
			TC_EndRent(i, false);
			return 1;
		}
		if(p_tc_trailer_vehicle[i] == vehicleid)
		{
			printf("[TC_TRAILER_GUARD] OnVehicleDeath player=%d trailer=%d progress=%d", i, vehicleid, p_tc_order_progress[i]);
			TC_LogTrailerDebug(i, "death");
			TC_ClearGuardedVehicle(vehicleid);

			new saved_order = p_tc_active_order[i];
			new saved_progress = p_tc_order_progress[i];
			p_tc_trailer_vehicle[i] = -1;
			p_tc_trailer_last_recover_ms[i] = 0;
			p_tc_trailer_lock_fail_since_ms[i] = 0;
			p_tc_trailer_detach_misses[i] = TC_TRAILER_SOFT_RECOVER_MISSES;
			p_tc_trailer_detached[i] = true;
			p_tc_trailer_has_last_pos[i] = false;

			// Loaded cargo is logical route state, not the lifetime of one vehicle id.
			// Recreate only the trailer and keep the accepted order/progress intact.
			if(saved_order != -1 && saved_progress >= 2 && p_tc_rent_vehicle[i] != -1)
				SetTimerEx("TC_RecoverTrailerDelayed", 700, false, "iiii", i, saved_order, saved_progress, g_BRAuthEpoch[i]);
			return 1;
		}
	}
	return 0;
}

#include "../include/tc_purchase_v56.inc"

stock TC_OnPlayerConnect(playerid)
{
	TC56_Reset(playerid);
	p_tc_company[playerid] = -1;
	p_tc_rating[playerid] = 0;
	p_tc_office[playerid] = -1;
	p_tc_fleet_page[playerid] = 0;
	p_tc_admin_company[playerid] = -1;
	p_tc_join_company[playerid] = -1;
	p_tc_pick_order[playerid] = -1;
	p_tc_fleet_sel[playerid] = -1;
	p_tc_rent_timer[playerid] = 0;
	p_tc_trailer_watch_timer[playerid] = 0;
	TC_ResetPlayerWork(playerid);
}

stock TC_OnPlayerDisconnect(playerid)
{
	TC56_Reset(playerid);
	TC_EndRent(playerid, false);
	p_tc_company[playerid] = -1;
	p_tc_admin_company[playerid] = -1;
}

stock TC_CreateWorldPickups()
{
	static bool:created;
	if(created) return 1;
	created = true;
	TC56_CreateMarker();
	for(new office = 0; office < 2; office++)
	{
		CreateDynamic3DTextLabel("{FFFF24}Транспортная компания\n{FFFFFF}Вход в офис",
			-1, g_tc_building_enter[office][0], g_tc_building_enter[office][1],
			g_tc_building_enter[office][2] + 0.6, 20.0,
			INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
		CreatePickup(19135, 23,
			g_tc_building_enter[office][0], g_tc_building_enter[office][1], g_tc_building_enter[office][2],
			0, PICKUP_ACTION_TYPE_TC_OFFICE_ENTER, office);

		CreatePickup(19135, 23,
			g_tc_interior_exit[0], g_tc_interior_exit[1], g_tc_interior_exit[2],
			g_tc_interior_vw[office], PICKUP_ACTION_TYPE_TC_OFFICE_EXIT, office);

		CreatePickup(1274, 23,
			g_tc_marker_order[0], g_tc_marker_order[1], g_tc_marker_order[2],
			g_tc_interior_vw[office], PICKUP_ACTION_TYPE_TC_ORDER, office);

		CreatePickup(1239, 23,
			g_tc_marker_company_list[0], g_tc_marker_company_list[1], g_tc_marker_company_list[2],
			g_tc_interior_vw[office], PICKUP_ACTION_TYPE_TC_COMPANY_LIST, office);

		CreateDynamic3DTextLabel("{FFFF24}Устройство в транспортную компанию",
			-1,
			g_tc_marker_company_list[0], g_tc_marker_company_list[1], g_tc_marker_company_list[2] + 0.3,
			12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, g_tc_interior_vw[office], g_tc_interior_id);

		CreatePickup(1239, 23,
			g_tc_marker_rent[office][0], g_tc_marker_rent[office][1], g_tc_marker_rent[office][2],
			0, PICKUP_ACTION_TYPE_TC_RENT, office);

		CreateDynamic3DTextLabel("{FFFF24}Аренда / сдача Sprinter",
			-1,
			g_tc_marker_rent[office][0], g_tc_marker_rent[office][1], g_tc_marker_rent[office][2] + 0.5,
			20.0);
	}
	print("[TransportCompany] World entrances created: Baturevo / Busaevo");
	return 1;
}
// END INLINED: modules/m1stoks/transportCompany/tcomp_logic.inc
