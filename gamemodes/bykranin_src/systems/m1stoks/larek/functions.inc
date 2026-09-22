//>> Файл: bykranin_src/systems/m1stoks/larek/functions.inc  (696 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: Larek_IsBusinessLarek, Larek_ResetPlayer, Larek_DestroyAllAreas, Larek_CreateArea, Larek_FindStaticBusiness, Larek_ApplyStaticBusinessData, Larek_InitStaticBusinesses
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: modules/m1stoks/larek/functions.inc
#if defined _m1stoks_functions_included
	#endinput
#endif
#define _m1stoks_functions_included

stock Larek_IsBusinessLarek(biz_id)
{
	if(biz_id < 0 || biz_id >= g_business_loaded) return 0;
	return GetBusinessData(biz_id, B_TYPE) == BUSINESS_TYPE_LAREK;
}

stock Larek_ResetPlayer(playerid)
{
	p_larek_biz_id[playerid] = -1;
	p_larek_notify_biz[playerid] = -1;
	p_larek_last_check_ms[playerid] = 0;
	return 1;
}

stock Larek_DestroyAllAreas()
{
	for(new i; i < MAX_BUSINESS; i++)
	{
		if(g_larek_area[i] == STREAMER_TAG_AREA:-1) continue;
		if(IsValidDynamicArea(g_larek_area[i]))
			DestroyDynamicArea(g_larek_area[i]);

		g_larek_area[i] = STREAMER_TAG_AREA:-1;
	}
	return 1;
}

stock Larek_CreateArea(biz_id)
{
	if(biz_id < 0 || biz_id >= MAX_BUSINESS) return 0;
	if(!Larek_IsBusinessLarek(biz_id)) return 0;

	if(g_larek_area[biz_id] != STREAMER_TAG_AREA:-1 && IsValidDynamicArea(g_larek_area[biz_id]))
		DestroyDynamicArea(g_larek_area[biz_id]);

	new STREAMER_TAG_AREA:areaid = CreateDynamicSphere(
		GetBusinessData(biz_id, B_POS_X),
		GetBusinessData(biz_id, B_POS_Y),
		GetBusinessData(biz_id, B_POS_Z),
		LAREK_AREA_RANGE
	);

	g_larek_area[biz_id] = areaid;
	Streamer_SetIntData(STREAMER_TYPE_AREA, _:areaid, E_STREAMER_EXTRA_ID, biz_id);
	return 1;
}

stock Larek_FindStaticBusiness(Float:x, Float:y, Float:z)
{
	for(new i; i < g_business_loaded; i++)
	{
		new Float:dx = x - GetBusinessData(i, B_POS_X);
		new Float:dy = y - GetBusinessData(i, B_POS_Y);
		new Float:dz = z - GetBusinessData(i, B_POS_Z);

		if(floatsqroot((dx * dx) + (dy * dy) + (dz * dz)) <= LAREK_STATIC_FIND_RANGE)
			return i;
	}
	return -1;
}

stock Larek_ApplyStaticBusinessData(businessid, pos_idx, bool:is_new)
{
	new Float:x = g_larek_static_positions[pos_idx][0];
	new Float:y = g_larek_static_positions[pos_idx][1];
	new Float:z = g_larek_static_positions[pos_idx][2];

	if(is_new)
	{
		SetBusinessData(businessid, B_OWNER_ID, 0);
		SetBusinessData(businessid, B_IMPROVEMENTS, 0);
		SetBusinessData(businessid, B_BALANCE, 0);
		SetBusinessData(businessid, B_RENT_DATE, 0);
		SetBusinessData(businessid, B_LOCK_STATUS, false);
		SetBusinessData(businessid, B_EVICTION, 0);
		format(g_business[businessid][B_OWNER_NAME], 21, "None");
	}
	else if(!IsBusinessOwned(businessid))
	{
		SetBusinessData(businessid, B_LOCK_STATUS, false);
		format(g_business[businessid][B_OWNER_NAME], 21, "None");
	}

	SetBusinessData(businessid, B_ENTER_PRICE, 0);
	SetBusinessData(businessid, B_ENTER_MUSIC, 0);
	SetBusinessData(businessid, B_PRODS, LAREK_STATIC_PRODUCTS);
	SetBusinessData(businessid, B_PROD_PRICE, 0);
	SetBusinessData(businessid, B_PRICE, LAREK_STATIC_PRICE);
	SetBusinessData(businessid, B_RENT_PRICE, LAREK_STATIC_RENT_PRICE);
	SetBusinessData(businessid, B_TYPE, BUSINESS_TYPE_LAREK);
	SetBusinessData(businessid, B_INTERIOR, LAREK_STATIC_INTERIOR);
	SetBusinessData(businessid, B_POS_X, x);
	SetBusinessData(businessid, B_POS_Y, y);
	SetBusinessData(businessid, B_POS_Z, z);
	SetBusinessData(businessid, B_EXIT_POS_X, x);
	SetBusinessData(businessid, B_EXIT_POS_Y, y);
	SetBusinessData(businessid, B_EXIT_POS_Z, z);
	SetBusinessData(businessid, B_EXIT_ANGLE, 0.0);
	SetBusinessData(businessid, B_ORDER_ID, -1);

	if(GetBusinessData(businessid, B_HEALTH_PICKUP))
	{
		DestroyPickup(GetBusinessData(businessid, B_HEALTH_PICKUP));
		SetBusinessData(businessid, B_HEALTH_PICKUP, 0);
	}

	format(g_business[businessid][B_NAME], 24, "Ларёк #%d", businessid + 1);
	return 1;
}

stock Larek_InitStaticBusinesses()
{
	new query[512];
	new created_count, updated_count, skipped_count;
	new Cache:insert_result;

	for(new pos_idx; pos_idx < sizeof g_larek_static_positions; pos_idx++)
	{
		new Float:x = g_larek_static_positions[pos_idx][0];
		new Float:y = g_larek_static_positions[pos_idx][1];
		new Float:z = g_larek_static_positions[pos_idx][2];
		new businessid = Larek_FindStaticBusiness(x, y, z);

		if(businessid != -1)
		{
			Larek_ApplyStaticBusinessData(businessid, pos_idx, false);

			if(GetBusinessData(businessid, B_SQL_ID) > 0)
			{
				mysql_format(mysql, query, sizeof query,
					"UPDATE business SET type=%d,interior=%d,name='%e',price=%d,rent_price=%d,x='%f',y='%f',z='%f',exit_x='%f',exit_y='%f',exit_z='%f',exit_angle='%f' WHERE id=%d LIMIT 1",
					BUSINESS_TYPE_LAREK,
					LAREK_STATIC_INTERIOR,
					g_business[businessid][B_NAME],
					LAREK_STATIC_PRICE,
					LAREK_STATIC_RENT_PRICE,
					x, y, z,
					x, y, z,
					0.0,
					GetBusinessData(businessid, B_SQL_ID)
				);
				mysql_query(mysql, query, false);
			}

			RecreateBusinessEnterPickup(businessid);
			Larek_CreateArea(businessid);
			Larek_UpdateLabel(businessid);
			updated_count++;
			continue;
		}

		if(g_business_loaded >= MAX_BUSINESS)
		{
			skipped_count++;
			continue;
		}

		businessid = g_business_loaded++;
		SetBusinessData(businessid, B_SQL_ID, 0);
		SetBusinessData(businessid, B_LABEL, Text3D:-1);
		Larek_ApplyStaticBusinessData(businessid, pos_idx, true);

		mysql_format(mysql, query, sizeof query,
			"INSERT INTO business (type, price, rent_price, x, y, z, interior, name, exit_x, exit_y, exit_z, exit_angle) VALUES (%d, %d, %d, '%f', '%f', '%f', %d, '%e', '%f', '%f', '%f', '%f')",
			BUSINESS_TYPE_LAREK,
			LAREK_STATIC_PRICE,
			LAREK_STATIC_RENT_PRICE,
			x, y, z,
			LAREK_STATIC_INTERIOR,
			g_business[businessid][B_NAME],
			x, y, z,
			0.0
		);
		insert_result = mysql_query(mysql, query, true);
		SetBusinessData(businessid, B_SQL_ID, cache_insert_id());
		cache_delete(insert_result);

		RecreateBusinessEnterPickup(businessid);
		CreateDynamicMapIcon(x, y, z, 52, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
		Larek_CreateArea(businessid);
		Larek_UpdateLabel(businessid);
		created_count++;
	}

	printf("[Larek]: Static businesses init: created=%d updated=%d skipped=%d loaded=%d", created_count, updated_count, skipped_count, g_business_loaded);
	return 1;
}
stock Larek_InitAreas()
{
	Larek_DestroyAllAreas();

	for(new i; i < g_business_loaded; i++)
	{
		if(Larek_IsBusinessLarek(i))
			Larek_CreateArea(i);
	}
	return 1;
}

stock Larek_GetBizByArea(STREAMER_TAG_AREA:areaid)
{
	new biz_id;
	biz_id = Streamer_GetIntData(STREAMER_TYPE_AREA, _:areaid, E_STREAMER_EXTRA_ID);
	if(0 <= biz_id < MAX_BUSINESS)
	{
		if(Larek_IsBusinessLarek(biz_id) && g_larek_area[biz_id] == areaid)
			return biz_id;
	}

	for(new i; i < g_business_loaded; i++)
	{
		if(!Larek_IsBusinessLarek(i)) continue;
		if(g_larek_area[i] == areaid) return i;
	}
	return -1;
}

stock Larek_ShowInteractNotification(playerid, biz_id)
{
	if(!IsPlayerLogged(playerid)) return 0;
	if(!Larek_IsBusinessLarek(biz_id)) return 0;
	if(GetBusinessData(biz_id, B_LOCK_STATUS)) return 0;

	p_larek_biz_id[playerid] = biz_id;

	if(p_larek_notify_biz[playerid] == biz_id) return 1;

	ShowNotificationNew(playerid, 4, 7, LAREK_NOTIFY_ID, 1, "Взаимодействовать", ">>");

	p_larek_notify_biz[playerid] = biz_id;
	return 1;
}

stock Larek_OpenFromNotify(playerid)
{
	new biz_id = p_larek_biz_id[playerid];

	if(biz_id == -1 || !Larek_IsBusinessLarek(biz_id))
		biz_id = Larek_GetNearest(playerid, LAREK_INTERACT_RANGE);

	if(biz_id == -1)
		return SendClientMessage(playerid, 0x999999FF, "Рядом нет ларька."), 0;

	return Larek_OpenJsonShop(playerid, biz_id);
}

public Larek_OpenFromNotifyPublic(playerid)
{
	return Larek_OpenFromNotify(playerid);
}

public Larek_HandleNotificationClickPublic(playerid, notif_id)
{
	if(notif_id != LAREK_NOTIFY_ID) return 0;
	return Larek_OpenFromNotify(playerid);
}

stock Larek_OpenJsonShop(playerid, biz_id)
{
	if(!IsPlayerLogged(playerid)) return 0;
	if(!Larek_IsBusinessLarek(biz_id)) return 0;

	if(GetBusinessData(biz_id, B_LOCK_STATUS))
		return SendClientMessage(playerid, 0x999999FF, "Ларёк закрыт."), 0;

	p_larek_biz_id[playerid] = biz_id;

	new Node:json = JSON_Object();
	JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
	ShowPlayerGUI(playerid, BrDialogDiner, json);
	JSON_Cleanup(json);
	return 1;
}

stock Larek_RefreshJsonShop(playerid)
{
	if(p_larek_biz_id[playerid] < 0) return 0;

	new Node:json = JSON_Object();
	JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
	ShowPlayerGUI(playerid, BrDialogDiner, json);
	JSON_Cleanup(json);
	return 1;
}

stock Larek_CreditBusiness(playerid, biz_id, price)
{
	if(!IsBusinessOwned(biz_id)) return 0;

	AddBusinessData(biz_id, B_BALANCE, +, price);

	new query[160];
	mysql_format(mysql, query, sizeof query, "UPDATE business SET balance=%d WHERE id=%d LIMIT 1",
		GetBusinessData(biz_id, B_BALANCE),
		GetBusinessData(biz_id, B_SQL_ID));
	mysql_query(mysql, query, false);

	mysql_format(mysql, query, sizeof query,
		"INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,1)",
		GetBusinessData(biz_id, B_SQL_ID),
		GetPlayerAccountID(playerid),
		GetPlayerIpEx(playerid),
		gettime(),
		price
	);
	mysql_query(mysql, query, false);
	return 1;
}

stock Larek_TryBuyOrder(playerid, order)
{
	new biz_id = p_larek_biz_id[playerid];
	if(biz_id < 0 || !Larek_IsBusinessLarek(biz_id))
		return SendClientMessage(playerid, 0x999999FF, "Вы не у ларька."), 0;

	new item[LAREK_ITEM_COUNT], price, satiety;

	for(new i; i < LAREK_ITEM_COUNT; i++)
		item[i] = (order >> i) & 1;

	for(new i; i < LAREK_ITEM_COUNT; i++)
	{
		if(item[i])
		{
			price += g_larek_item_price[i];
			satiety += g_larek_item_satiety[i];
		}
	}

	if(price <= 0)
		return SendClientMessage(playerid, 0x999999FF, "Выберите товар."), 0;

	if(GetPlayerMoneyEx(playerid) < price)
		return SendClientMessage(playerid, 0x999999FF, "Недостаточно денег."), 0;

	GivePlayerMoneyEx(playerid, -price, "Покупка еды в ларьке", true, true);
	Larek_CreditBusiness(playerid, biz_id, price);

	new msg[128];
	format(msg, sizeof msg,
		"{FFFFFF}Вы успешно приобрели еды на {FFFF00}%d{FFFFFF} рублей, вам добавлено {FFFF00}%d{FFFFFF} сытости.",
		price, satiety
	);
	SendClientMessage(playerid, -1, msg);
	return 1;
}

stock Larek_HandleJsonPacket(playerid, Node:json)
{
	new type;
	JSON_GetInt(json, "t", type);

	switch(type)
	{
		case 0:
		{
			p_larek_biz_id[playerid] = -1;
		}
		case 1:
		{
			new order;
			JSON_GetInt(json, "r", order);

			if(Larek_TryBuyOrder(playerid, order))
				Larek_RefreshJsonShop(playerid);
		}
	}
	return 1;
}

stock Larek_EnsureBusinessName(biz_id)
{
	if(!Larek_IsBusinessLarek(biz_id)) return 0;

	if(!strlen(g_business[biz_id][B_NAME]))
		format(g_business[biz_id][B_NAME], 24, "Ларёк #%d", biz_id + 1);

	new query[128];
	mysql_format(mysql, query, sizeof query,
		"UPDATE business SET name='%e' WHERE id=%d LIMIT 1",
		g_business[biz_id][B_NAME],
		GetBusinessData(biz_id, B_SQL_ID));
	mysql_query(mysql, query, false);
	return 1;
}

public Larek_EnsureBusinessNamePublic(biz_id)
{
	return Larek_EnsureBusinessName(biz_id);
}

stock Larek_FormatOwnerName(biz_id, output[], size = sizeof output)
{
	if(IsBusinessOwned(biz_id) && strlen(g_business[biz_id][B_OWNER_NAME]) && strcmp(g_business[biz_id][B_OWNER_NAME], "None", true))
		format(output, size, "%s", g_business[biz_id][B_OWNER_NAME]);
	else
		format(output, size, "Государство");
	return 1;
}

stock Larek_BuildLabelText(biz_id, output[], size)
{
	new owner_display[24];
	Larek_FormatOwnerName(biz_id, owner_display);

	format(output, size,
		"{FFFF00}Ларёк (%d)\n\
		{FFFF00}Крыша: Арзамасская ОПГ\n\
		{FFFFFF}Владелец: {0099CC}%s\n\
		{FFFF00}Подойдите для выбора товара",
		GetBusinessData(biz_id, B_SQL_ID),
		owner_display
	);

	if(g_business[biz_id][B_LOCK_STATUS])
		strcat(output, "\n{FF6600}Закрыто", size);

	return 1;
}

stock Larek_UpdateLabel(biz_id)
{
	if(biz_id < 0 || biz_id >= g_business_loaded) return 0;
	if(!Larek_IsBusinessLarek(biz_id)) return 0;

	Larek_EnsureBusinessName(biz_id);

	new label_text[256];
	Larek_BuildLabelText(biz_id, label_text, sizeof label_text);

	if(IsValidDynamic3DTextLabel(Text3D:g_business[biz_id][B_LABEL]))
		DestroyDynamic3DTextLabel(Text3D:g_business[biz_id][B_LABEL]);

	g_business[biz_id][B_LABEL] = CreateDynamic3DTextLabel(
		label_text,
		0xFFFF00FF,
		GetBusinessData(biz_id, B_POS_X),
		GetBusinessData(biz_id, B_POS_Y),
		GetBusinessData(biz_id, B_POS_Z) + 1.0,
		6.50
	);
	return 1;
}

public Larek_UpdateLabelPublic(biz_id)
{
	return Larek_UpdateLabel(biz_id);
}

stock Larek_RefreshAllLabels()
{
	for(new i; i < g_business_loaded; i++)
	{
		if(Larek_IsBusinessLarek(i))
			Larek_UpdateLabel(i);
	}
	return 1;
}

stock Larek_OnBusinessCreated(biz_id, type)
{
	if(type != BUSINESS_TYPE_LAREK) return 0;

	format(g_business[biz_id][B_NAME], 24, "Ларёк #%d", biz_id + 1);
	Larek_EnsureBusinessName(biz_id);
	Larek_CreateArea(biz_id);
	Larek_UpdateLabel(biz_id);
	return 1;
}

public Larek_OnBusinessCreatedPublic(biz_id, type)
{
	return Larek_OnBusinessCreated(biz_id, type);
}

stock Float:Larek_GetDistanceToBiz(playerid, biz_id)
{
	new Float:px, Float:py, Float:pz;
	GetPlayerPos(playerid, px, py, pz);

	new Float:dx = px - GetBusinessData(biz_id, B_POS_X);
	new Float:dy = py - GetBusinessData(biz_id, B_POS_Y);

	return floatsqroot((dx * dx) + (dy * dy));
}

stock Larek_GetNearest(playerid, Float:range = LAREK_INTERACT_RANGE)
{
	new nearest = -1;
	new Float:best_dist = range;

	for(new i; i < g_business_loaded; i++)
	{
		if(!Larek_IsBusinessLarek(i)) continue;

		new Float:dist = Larek_GetDistanceToBiz(playerid, i);
		if(dist <= best_dist)
		{
			best_dist = dist;
			nearest = i;
		}
	}
	return nearest;
}

stock Larek_ProcessProximity(playerid)
{
	if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
		return 0;

	new biz_id = Larek_GetNearest(playerid, LAREK_INTERACT_RANGE);

	if(biz_id == -1)
	{
		p_larek_notify_biz[playerid] = -1;
		p_larek_biz_id[playerid] = -1;
		return 0;
	}

	if(GetBusinessData(biz_id, B_LOCK_STATUS))
		return 0;

	p_larek_biz_id[playerid] = biz_id;

	if(p_larek_notify_biz[playerid] != biz_id)
		Larek_ShowInteractNotification(playerid, biz_id);

	return 1;
}

stock Larek_OnPlayerTimer(playerid)
{
	return Larek_ProcessProximity(playerid);
}

stock Larek_OnPlayerUpdate(playerid)
{
	new tick = GetTickCount();

	if(tick - p_larek_last_check_ms[playerid] < LAREK_NOTIFY_COOLDOWN_MS)
		return 0;

	p_larek_last_check_ms[playerid] = tick;
	return Larek_ProcessProximity(playerid);
}

public Larek_OnPlayerUpdatePublic(playerid)
{
	return Larek_OnPlayerUpdate(playerid);
}

public Larek_OnPlayerTimerPublic(playerid)
{
	return Larek_OnPlayerTimer(playerid);
}

stock Larek_ShowBusinessInfo(playerid)
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid == -1 || !Larek_IsBusinessLarek(businessid)) return 0;

	new fmt_str[768], city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
	GetCityName(GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), city);
	GetAreaName(GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), area);

	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Название:\t\t\t\t{339999}%s\n"\
		"{FFFFFF}Номер бизнеса:\t\t\t%d\n"\
		"Владелец:\t\t\t\t%s\n"\
		"Город / область:\t\t\t%s\n"\
		"Район:\t\t\t\t\t%s\n"\
		"Баланс предприятия:\t\t\t%d руб\n"\
		"Бизнес арендован на:\t\t{66CC00}%d {FFFFFF}из {FFFF00}30 {FFFFFF}дней\n"\
		"{FFFFFF}Гос. стоимость:\t\t\t%d руб\n"\
		"Аренда помещения:\t\t\t%d руб в день\n"\
		"Тип аренды:\t\t\t\t%s\n"\
		"Статус:\t\t\t\t\t%s\n\n"\
		"{669966}Цены на товары фиксированы.\n"\
		"100%% выручки от продаж поступает на баланс бизнеса.\n\n"\
		"{669966}Для открытия панели управления\n"\
		"нажмите кнопку \"Изменить\"",
		GetBusinessData(businessid, B_NAME),
		businessid,
		GetBusinessData(businessid, B_OWNER_NAME),
		city,
		area,
		GetBusinessData(businessid, B_BALANCE),
		GetBusinessData(businessid, B_RENT_DATE) <= gettime() ? 0 :
		GetElapsedTime(GetBusinessData(businessid, B_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
		GetBusinessData(businessid, B_PRICE),
		GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? (GetBusinessData(businessid, B_RENT_PRICE)) : (GetBusinessData(businessid, B_RENT_PRICE) / 2),
		GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? ("Полная") : ("Льготная"),
		GetBusinessData(businessid, B_LOCK_STATUS) ? ("{CC3333}Ларёк закрыт") : ("{66CC33}Ларёк открыт")
	);

	Dialog(playerid, DIALOG_BIZ_INFO, DIALOG_STYLE_LIST,
		"{00FFFF}"SERVER_NAME"{ffffff} -> Информация о ларьке",
		fmt_str, "Изменить", "Отмена"
	);
	return 1;
}

public Larek_ShowBusinessInfoPublic(playerid)
{
	return Larek_ShowBusinessInfo(playerid);
}

stock Larek_ShowBusinessDialog(playerid, operationid)
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid == -1 || !Larek_IsBusinessLarek(businessid)) return 0;

	switch(operationid)
	{
		case 0:
		{
			Dialog(playerid, DIALOG_BIZ_PARAMS, DIALOG_STYLE_LIST,
				"{33AACC}Управление ларьком",
				"1. {669966}Открыть {FFFFFF}или {CC3333}закрыть {FFFFFF}ларёк\n"\
				"2. Финансовая статистика",
				"Выбрать", "Назад"
			);
		}
		case 1:
		{
			if(GetBusinessData(businessid, B_LOCK_STATUS))
			{
				SetBusinessData(businessid, B_LOCK_STATUS, false);
				SendClientMessage(playerid, 0x66CC00FF, "Ларёк открыт");
			}
			else
			{
				SetBusinessData(businessid, B_LOCK_STATUS, true);
				SendClientMessage(playerid, 0xFF6600FF, "Ларёк закрыт");
			}

			Larek_UpdateLabel(businessid);

			new query[75];
			mysql_format(mysql, query, sizeof query,
				"UPDATE business SET `lock`=%d WHERE `id`=%d LIMIT 1",
				GetBusinessData(businessid, B_LOCK_STATUS),
				GetBusinessData(businessid, B_SQL_ID)
			);
			mysql_query(mysql, query, false);

			Dialog(playerid, DIALOG_BIZ_PARAMS, DIALOG_STYLE_LIST,
				"{33AACC}Larek management",
				"1. Open or close the kiosk\n2. Financial statistics",
				"Select", "Back"
			);
		}
		case 6:
		{
			new query[256];
			new time = gettime();
			new cur_day = time - (time % 86400);
			new start_day = cur_day - (86400 * 20);

			mysql_format(mysql, query, sizeof query,
				"SELECT FROM_UNIXTIME(time, '%%Y-%%m-%%d') AS date, SUM(money) as total FROM business_profit WHERE bid=%d AND view=1 AND time >= %d AND time < %d GROUP BY time ORDER BY time DESC LIMIT 20",
				GetBusinessData(businessid, B_SQL_ID), start_day, cur_day
			);
			mysql_tquery(mysql, query, "ShowBusinessProfit", "ii", playerid, ++ mysql_race[playerid]);
		}
	}
	return 1;
}

public Larek_ShowBusinessDialogPublic(playerid, operationid)
{
	return Larek_ShowBusinessDialog(playerid, operationid);
}

stock Larek_OnBizParamsList(playerid, listitem)
{
	switch(listitem)
	{
		case 0: Larek_ShowBusinessDialog(playerid, 1);
		case 1: Larek_ShowBusinessDialog(playerid, 6);
	}
	return 1;
}

public Larek_OnBizParamsListPublic(playerid, listitem)
{
	return Larek_OnBizParamsList(playerid, listitem);
}
// END INLINED: modules/m1stoks/larek/functions.inc
