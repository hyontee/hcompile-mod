//>> Файл: bykranin_src/core/property/property_12.inc  (766 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: CreateDynamicActionPickup, ShowPlayerFlatExitPickupDialog, HasAnyHouseOrFlat, GetNearestHouseForPlayerSell, GetNearestFlatForPlayerSell, GetHouseGovPrice, GetFlatGovPrice
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
#define MAX_DYNAMIC_ACTION_PICKUPS 20000

new gDynPickupAction[MAX_DYNAMIC_ACTION_PICKUPS];
new gDynPickupData[MAX_DYNAMIC_ACTION_PICKUPS];
new gDynPickupExtra[MAX_DYNAMIC_ACTION_PICKUPS];
stock CreateDynamicActionPickup(modelid, pickuptype, Float:x, Float:y, Float:z, worldid, actiontype, extraid, interiorid = -1, Float:streamdist = 60.0)
{
    new pickupid = CreateDynamicPickup(
        modelid,
        pickuptype,
        x,
        y,
        z,
        worldid,
        interiorid,
        -1,
        streamdist
    );

    if (pickupid != INVALID_STREAMER_ID)
    {
        gDynPickupAction[pickupid] = actiontype;
        gDynPickupData[pickupid] = extraid;
        gDynPickupExtra[pickupid] = worldid;
    }

    return pickupid;
}
new gPlayerPickupCooldown[MAX_PLAYERS];

stock ShowPlayerFlatExitPickupDialog(playerid, flatid)
{
	new houseid = flatid / 1000;
    new floor   = (flatid % 1000) / 10;
    new flatidx = (flatid % 10) + (4*(floor-1));
	new flatids = (houseid * 100) + (floor * 10) + flatidx;
	new account_id = GetPlayerAccountID(playerid);
	if(account_id <= 0) return SendClientMessage(playerid, -1, "Ошибка аккаунта. Перезайдите на сервер");
	new h = gFlatType[houseid]-1;
	new Float:flatPos[4][3] =
    {
        {552.79, 25.45, 1049.31},
        {554.67, 26.63, 1049.31},
        {565.18, 26.63, 1049.31},
        {567.20, 25.33, 1049.31}
    };
	new Float:flatPoss[4][3] =
    {
        {-491.66, 1004.88, 1499.17},
        {-491.95, 998.40, 1499.17},
        {-494.54, 995.28, 1499.17},
        {-494.45, 1001.47, 1499.17}
    };
	if (gFlatEnTypes[houseid] == 0){
		
	
	
	new worldid = houseid + ((floor - 1) * (FLATS_FOR_SALE_COUNT + 1));
	SetPlayerPosEx(
		playerid,
		flatPos[(flatid % 10)-1][0],
	    flatPos[(flatid % 10)-1][1],
	    flatPos[(flatid % 10)-1][2],
		90,
		1,
		worldid
	);
	}
	if (gFlatEnTypes[houseid] == 1){
		
	
	
	new worldid = houseid + ((floor - 1) * (FLATS_FOR_SALE_COUNT + 1));
	SetPlayerPosEx(
		playerid,
		flatPoss[(flatid % 10)-1][0],
	    flatPoss[(flatid % 10)-1][1],
	    flatPoss[(flatid % 10)-1][2],
		90,
		1,
		worldid
	);
	}
	return 1;
}
stock HasAnyHouseOrFlat(accountid)
{
    for(new i = 0; i < HOUSES_FOR_SALE_COUNT; i++)
    {
        if(gHouseOwned[i] && gHouseOwnerID[i] == accountid)
            return 1;
    }

    for(new i = 0; i < 200000; i++)
    {
        if(gFlatOwned[i] && gFlatOwnerID[i] == accountid)
            return 1;
    }

    return 0;
}

stock GetNearestHouseForPlayerSell(playerid, Float:range = 20.0)
{
    new accid = GetPlayerAccountID(playerid);
    if(accid <= 0) return -1;

    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    new nearest_house = -1;
    new Float:best_dist = range + 1.0;

    for(new i = 0; i < HOUSES_FOR_SALE_COUNT; i++)
    {
        if(!gHouseOwned[i]) continue;
        if(gHouseOwnerID[i] != accid) continue;

        new Float:dist = GetPlayerDistanceFromPoint(playerid,
            gHousesForSale[i][0],
            gHousesForSale[i][1],
            gHousesForSale[i][2]);

        if(dist <= range && dist < best_dist)
        {
            best_dist = dist;
            nearest_house = i;
        }
    }

    return nearest_house;
}

stock GetNearestFlatForPlayerSell(playerid)
{
    new accid = GetPlayerAccountID(playerid);
    if(accid <= 0) return -1;

    new vw = GetPlayerVirtualWorld(playerid);
    if(vw <= 0) return -1;

    for(new i = 0; i < 200000; i++)
    {
        if(!gFlatOwned[i]) continue;
        if(gFlatOwnerID[i] != accid) continue;


       new real_flatid = g_flat_real_id[i];
       new houseid = real_flatid / 1000;
	   new floor   = (real_flatid % 1000) / 10;
	   new worldid = houseid + ((floor - 1) * (FLATS_FOR_SALE_COUNT + 1));
        if(houseid == worldid)
            return i;
    }

    return -1;
}

stock GetHouseGovPrice(houseid)
{
    new h = GetHouseData(gHouseType[houseid]);
    return HouseData[h][hPrice];
}

stock GetFlatGovPrice(flatid)
{
    new real_flatid = g_flat_real_id[flatid];
    new houseid = real_flatid / 1000;
    return gFlatPrice[houseid];
}
stock SellPlayerFlatNew(playerid, flatid)
{
	new houseid = flatid / 1000;
    new floor   = (flatid % 1000) / 10;
    new flatidx = (flatid % 10) + (4*(floor-1));
	new flatids = (houseid * 100) + (floor * 10) + flatidx;
    if (!gFlatOwned[flatids])
        return SendClientMessage(playerid, -1, "Этот дом никому не принадлежит!");

    new accid = GetPlayerAccountID(playerid);
    if (gFlatOwnerID[flatids] != accid)
        return SendClientMessage(playerid, -1, "Это не ваш дом!");

    new h = gFlatType[houseid]-1;
    new sell_price = (gFlatPrice[houseid] * 2) / 3; // 66.6% of price without float bug

    SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) + sell_price);
    UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
    GivePlayerMoney(playerid, sell_price);
	new prices = 0;
	if (g_flat_new_apt[flatids]){
		prices += 33000;
	}
	if (g_flat_new_remont[flatids]){
		prices += 6000000;
	}
	if (g_flat_new_shkaf[flatids]){
		prices += 36000;
	}
	SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) + prices);
    UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
    gFlatOwned[flatids] = false;
    gFlatOwnerID[flatids] = 0;
    gFlatRentTime[flatids] = 0;
    format(gFlatOwner[flatids], 24, "Nobody");
	g_flat_new_apt[flatids] = 0;
	g_flat_new_remont[flatids] = 0;
	g_flat_new_shkaf[flatids] = 0;
	g_flat_real_id[flatids] = 0;
	SetPlayerData(playerid, P_HOUSE_SELECTED, 0); 
	UpdatePlayerDatabaseInt(playerid, "house_selected", GetPlayerData(playerid, P_HOUSE_SELECTED));
    new query[256];
    format(query, sizeof(query),
        "DELETE FROM bought_houses WHERE house_id = %d AND account_id = %d",
        flatid, accid
    );
    mysql_tquery(mysql, query);

    new fmt[1024];
    format(fmt, sizeof fmt, "Налог за продажу дома составил 30 процентов от его стоимости {40ad58}(%d руб)", gFlatPrice[houseid]/3);
    SendClientMessage(playerid, -1, fmt);
	format(fmt, sizeof fmt, "Вам было возвращено 60 процентов от стоимости купленных улучшений: {8de645}%d руб", prices);
	SendClientMessage(playerid, -1, fmt);
    return 1;
}

stock GetNewPropertyUpgradeLevel(bool:has_med, bool:has_wardrobe, bool:has_remont)
{
	if(has_remont) return 6;
	if(has_wardrobe) return 5;
	if(has_med) return 4;
	return 0;
}

enum ePropertyCityAnchor
{
	Float:PCA_X,
	Float:PCA_Y,
	PCA_NAME[24]
};

new const g_property_city_anchors[][ePropertyCityAnchor] =
{
	{-359.5880, 1003.2900, "Арзамас"},
	{121.8040, 919.4350, "Арзамас"},
	{208.5840, 1543.6200, "Арзамас"},
	{-2425.0000, 98.6980, "Лыткарино"},
	{-2315.2700, 173.0900, "Лыткарино"},
	{-2240.2200, -36.4810, "Лыткарино"},
	{1740.2900, -2372.4300, "Южный"},
	{2401.2500, -2083.3400, "Южный"},
	{2505.7100, -2634.6900, "Южный"},
	{-2785.9100, 1102.6300, "Нижегородск"},
	{-2737.0800, 999.3400, "Нижегородск"},
	{1865.8200, 2312.0500, "Батырево"},
	{1764.0700, 1334.1400, "Батырево"},
	{1995.0000, 1746.2400, "Батырево"},
	{2198.4300, -240.1000, "Гарель"},
	{2420.1800, -244.9900, "Гарель"},
	{2658.9900, -164.0000, "Гарель"},
	{304.9200, -1042.9100, "Корякино"},
	{519.6500, -980.4800, "Корякино"},
	{711.1170, -1040.1000, "Корякино"},
	{-956.4580, 193.4960, "Рублевка"},
	{-1360.9200, 348.3670, "Рублевка"},
	{-2000.7400, 613.7450, "Рублевка"}
};

stock FormatNewPropertyLocation(Float:x, Float:y, output[], output_size)
{
	new best_index = -1;
	new Float:best_distance = 999999999.0;

	for(new i = 0; i < sizeof(g_property_city_anchors); i++)
	{
		new Float:dx = x - g_property_city_anchors[i][PCA_X];
		new Float:dy = y - g_property_city_anchors[i][PCA_Y];
		new Float:distance = (dx * dx) + (dy * dy);

		if(best_index == -1 || distance < best_distance)
		{
			best_index = i;
			best_distance = distance;
		}
	}

	if(best_index != -1)
	{
		format(output, output_size, "%s", g_property_city_anchors[best_index][PCA_NAME]);
	}
	else
	{
		format(output, output_size, "Неизвестно");
	}

	return 1;
}

stock ShowNewPropertyPurchaseSuccess(playerid, price)
{
	new fmt_str[160];

	format(fmt_str, sizeof fmt_str, "{FFFF00}{FFFFFF}Поздравляем с успешным приобретением нового дома / квартиры за %d рублей.", price);
	SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
	SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}{FFFFFF}Чтобы сменить место своего появления воспользуйтесь командой: {FFFF00}\"/setspawn\".");

	ShowNotificationNew(playerid, 3, 8, 0, 0,
		"Вы успешно приобрели дом. Используйте /home для управления домом. Чтобы покинуть дом введите /exit.",
		"OK");

	Dialog(playerid, DIALOG_HOUSE_NEW_PURCHASE_HINT, DIALOG_STYLE_MSGBOX,
		"{3399FF}Новый дом",
		"{FFFFFF}Вам нужно заплатить за дом в ближайшем отделении банка {FFCD00}(gps)",
		"Закрыть", "");
	return 1;
}

stock ShowPropertyRentersDialog(playerid, bool:is_flat, property_id)
{
	new title[48], fmt_str[256];

	format(title, sizeof title, "%s", is_flat ? "Список арендаторов квартиры" : "Список арендаторов дома");
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}%s\n\n{B8B8B8}Арендаторов пока нет.",
		is_flat ? "Список арендаторов для квартиры пуст." : "Список арендаторов для дома пуст."
	);

	SetPVarInt(playerid, "hnew_renters_property_id", property_id);
	Dialog(playerid, DIALOG_PROPERTY_RENTERS, DIALOG_STYLE_MSGBOX, title, fmt_str, "Закрыть", "");
	return 1;
}

stock BuyNewPropertyImprovement(playerid, bool:is_flat, property_id, improvement)
{
    if(!(3 <= improvement <= 5)) return 0;

    new accountid = GetPlayerAccountID(playerid);
    if(accountid <= 0) return 0;

    if(is_flat)
    {
        if(!(0 <= property_id < 200000) || !gFlatOwned[property_id] || gFlatOwnerID[property_id] != accountid)
            return SendClientMessage(playerid, 0xCECECEFF, "Эта квартира Вам больше не принадлежит");
    }
    else
    {
        if(!(0 <= property_id < HOUSES_FOR_SALE_COUNT) || !gHouseOwned[property_id] || gHouseOwnerID[property_id] != accountid)
            return SendClientMessage(playerid, 0xCECECEFF, "Этот дом Вам больше не принадлежит");
    }

    new bool:installed;
    switch(improvement)
    {
        case 3: installed = is_flat ? g_flat_new_apt[property_id] : g_house_new_apt[property_id];
        case 4: installed = is_flat ? g_flat_new_shkaf[property_id] : g_house_new_shkaf[property_id];
        case 5: installed = is_flat ? g_flat_new_remont[property_id] : g_house_new_remont[property_id];
    }
    if(installed)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Это улучшение уже приобретено");
        return ShowPropertyImprovementsDialog(playerid, is_flat, property_id);
    }

    if(improvement == 5)
    {
        if(is_flat)
        {
            new real_flatid = g_flat_real_id[property_id], flat_houseid = real_flatid / 1000;
            if(!(0 <= flat_houseid < FLATS_FOR_SALE_COUNT) || !(gFlatType[flat_houseid] == 1 || gFlatType[flat_houseid] == 2))
                return SendClientMessage(playerid, 0xCECECEFF, "Ремонт доступен только для квартир среднего класса");
        }
        else if(gHouseType[property_id] != 6)
            return SendClientMessage(playerid, 0xCECECEFF, "Ремонт недоступен для этого класса дома");
    }

    new price, field[8];
    switch(improvement)
    {
        case 3: { price = 550000; format(field, sizeof field, "apt"); }
        case 4: { price = 600000; format(field, sizeof field, "shkaf"); }
        case 5: { price = 100000000; format(field, sizeof field, "remont"); }
    }
    if(GetPlayerMoneyEx(playerid) < price)
        return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно средств для покупки улучшения");

    new database_property_id = is_flat ? g_flat_real_id[property_id] : property_id;
    new query[384];
    mysql_format(mysql, query, sizeof query,
        "UPDATE accounts a JOIN bought_houses h ON h.account_id=a.id SET a.money=a.money-%d,h.%s=1 WHERE a.id=%d AND a.money>=%d AND h.house_id=%d AND IFNULL(h.kv,0)=%d AND h.%s=0 LIMIT 1",
        price, field, accountid, price, database_property_id, is_flat, field);
    new Cache:result = mysql_query(mysql, query, true);
    new error = mysql_errno(), affected = cache_affected_rows();
    cache_delete(result);
    if(error || affected != 1)
        return SendClientMessage(playerid, 0xFF6600FF, "Не удалось приобрести улучшение. Повторите попытку");

    GivePlayerMoneyEx(playerid, -price, "Покупка улучшения недвижимости", false, true);
    switch(improvement)
    {
        case 3:
        {
            if(is_flat) g_flat_new_apt[property_id] = true;
            else g_house_new_apt[property_id] = true;
        }
        case 4:
        {
            if(is_flat) g_flat_new_shkaf[property_id] = true;
            else g_house_new_shkaf[property_id] = true;
        }
        case 5:
        {
            if(is_flat) g_flat_new_remont[property_id] = true;
            else g_house_new_remont[property_id] = true;
        }
    }

    SendClientMessage(playerid, 0x66CC00FF, "Улучшение недвижимости успешно приобретено");
    return ShowPropertyImprovementsDialog(playerid, is_flat, property_id);
}
stock ShowPropertyImprovementsDialog(playerid, bool:is_flat, property_id)
{
	new fmt_str[2048];

	if(is_flat)
	{
		format(fmt_str, sizeof fmt_str,
			"{FFFFFF}Уровень                 \tНазвание                 \tЦена\n"\
			"{00FF00}1 уровень                 \t{FFFFFF}Автоматические двери                \t8000 руб.\n"\
			"{00FF00}2 уровень                 \t{FFFFFF}Совместное проживание                \t145000 руб.\n"\
			"{00FF00}3 уровень                 \t{FFFFFF}Оформление субсидии                \t200000 руб.\n"\
			"%s                \t{FFFFFF}Домашняя аптечка                \t550000 руб.\n"\
			"%s                \t{FFFFFF}Шкаф для вещей                \t600000 руб.\n"\
			"%s                \t{FFFFFF}Ремонт                \t100000000 руб.\n",
			g_flat_new_apt[property_id] ? ("{00FF00}4 уровень") : ("{FF0000}4 уровень"),
			g_flat_new_shkaf[property_id] ? ("{00FF00}5 уровень") : ("{FF0000}5 уровень"),
			g_flat_new_remont[property_id] ? ("{00FF00}6 уровень") : ("{FF0000}6 уровень")
		);

		Dialog(playerid, DIALOG_FLAT_NEW_INFOS, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}Улучшения для квартиры", fmt_str, "Изменить", "Отмена");
	}
	else
	{
		format(fmt_str, sizeof fmt_str,
			"{FFFFFF}Уровень                 \tНазвание                 \tЦена\n"\
			"{00FF00}1 уровень                 \t{FFFFFF}Автоматические двери                \t8000 руб.\n"\
			"{00FF00}2 уровень                 \t{FFFFFF}Совместное проживание                \t145000 руб.\n"\
			"{00FF00}3 уровень                 \t{FFFFFF}Оформление субсидии                \t200000 руб.\n"\
			"%s                \t{FFFFFF}Домашняя аптечка                \t550000 руб.\n"\
			"%s                \t{FFFFFF}Шкаф для вещей                \t600000 руб.\n"\
			"%s                \t{FFFFFF}Ремонт                \t100000000 руб.\n",
			g_house_new_apt[property_id] ? ("{00FF00}4 уровень") : ("{FF0000}4 уровень"),
			g_house_new_shkaf[property_id] ? ("{00FF00}5 уровень") : ("{FF0000}5 уровень"),
			g_house_new_remont[property_id] ? ("{00FF00}6 уровень") : ("{FF0000}6 уровень")
		);

		Dialog(playerid, DIALOG_HOUSE_NEW_INFOS, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}Улучшения для дома", fmt_str, "Изменить", "Отмена");
	}

	return 1;
}

stock ShowPropertyImprovementTypeDialog(playerid, bool:is_flat)
{
	new title[48], fmt_str[128];

	SetPVarInt(playerid, "hnew_menu_is_flat", is_flat);
	format(title, sizeof title, "%s", is_flat ? "Улучшение квартиры" : "Улучшение дома");
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}1. Улучшения %s\n"\
		"{FFFFFF}2. Улучшения подвала",
		is_flat ? "квартиры" : "дома"
	);

	Dialog(playerid, DIALOG_PROPERTY_IMPROVEMENT_TYPE, DIALOG_STYLE_LIST, title, fmt_str, "Выбрать", "Назад");
	return 1;
}

stock ShowPropertyBasementImprovementsDialog(playerid, bool:is_flat, property_id)
{
	new title[48], fmt_str[256];

	SetPVarInt(playerid, "hnew_basement_property_id", property_id);
	format(title, sizeof title, "%s", is_flat ? "Улучшения подвала квартиры" : "Улучшения подвала дома");
	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}Уровень улучшений подвала:\t{CC3333}0\n\n{B8B8B8}Улучшения подвала пока недоступны."
	);

	Dialog(playerid, DIALOG_PROPERTY_BASEMENT_IMPROVEMENTS, DIALOG_STYLE_MSGBOX, title, fmt_str, "Закрыть", "");
	return 1;
}

stock ShowPlayerFlatNewInfo(playerid, flatid)
{
	new houseid = flatid / 1000;
    new floor   = (flatid % 1000) / 10;
    new flatidx = (flatid % 10) + (4*(floor-1));
	new flatids = (houseid * 100) + (floor * 10) + flatidx;

    if(!(0 <= houseid < FLATS_FOR_SALE_COUNT) || floor < 1 || !(0 <= flatids < 200000))
    {
        printf("[FLATS] Invalid flat info: player=%d flatid=%d houseid=%d floor=%d flatids=%d", playerid, flatid, houseid, floor, flatids);
        return SendClientMessage(playerid, 0x999999FF, "Dannye kvartiry povrezhdeny. Soobshchite administratsii.");
    }
	new fmt_str[1024], status_str[48], location_str[80];
	new rent_days = GetNewPropertyRentDaysLeft(gFlatRentTime[flatids]);
	new upgrade_level = GetNewPropertyUpgradeLevel(g_flat_new_apt[flatids], g_flat_new_shkaf[flatids], g_flat_new_remont[flatids]);

	format(status_str, sizeof status_str, "%s", g_flat_new_opens[flatids] ? ("{66CC66}Квартира открыта") : ("{E0584B}Квартира закрыта"));
    new h = gFlatType[houseid] - 1;
    if(!(0 <= h < sizeof(FlatData)))
    {
        printf("[FLATS] Invalid flat type: player=%d flatid=%d houseid=%d type=%d flatids=%d", playerid, flatid, houseid, gFlatType[houseid], flatids);
        return SendClientMessage(playerid, 0x999999FF, "Tip kvartiry ne nayden. Soobshchite administratsii.");
    }
	FormatNewPropertyLocation(gFlatsForSale[houseid][0], gFlatsForSale[houseid][1], location_str, sizeof location_str);

	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}\t\n"\
		"{FFFFFF}Тип / название:\t{B8B8B8}%s\n"\
		"{FFFFFF}Номер подъезда:\t%d\n"\
		"{FFFFFF}Номер квартиры:\t%d\n"\
		"{FFFFFF}Этаж квартиры:\t%d\n"\
		"{FFFFFF}Город / область:\t%s\n"\
		"{FFFFFF}Стоимость:\t{B8B8B8}%d {ffffff}руб\n"\
		"{FFFFFF}Дом оплачен на:\t{66CC66}%d {FFFFFF}из {66CC66}30 {FFFFFF}дней\n"\
		"{FFFFFF}Количество комнат:\t{E0584B}%d\n"\
		"{FFFFFF}Уровень улучшений:\t{CC3333}%d\n"\
		"{FFFFFF}Уровень улучшений подвала:\t{CC3333}0\n"\
		"{FFFFFF}Квартплата:\t{66CC66}%d {ffffff}руб в день\n"\
		"{FFFFFF}Тип квартплаты:\t{FFFFFF}Обычная\n"\
		"{FFFFFF}Статус:\t%s",
		FlatData[h][hName],
		houseid + 100,
		flatidx,
		floor,
		location_str,
		gFlatPrice[houseid],
		rent_days,
		FlatData[h][hRooms],
		upgrade_level,
		FlatData[h][hPriceP],
		status_str
	);

	Dialog(playerid, DIALOG_FLAT_NEW_INFO, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}{SERVER_NAME} {FFFFFF}| Информация о квартире", fmt_str, "Изменить", "Отмена");
	return 1;
}
stock GetPlayerPropertyCount(accid)
{
    new count = 0;

    for (new i = 0; i < HOUSES_FOR_SALE_COUNT; i++)
    {
        if (gHouseOwned[i] && gHouseOwnerID[i] == accid)
            count++;
    }

    for (new i = 0; i < 200000; i++)
    {
        if (gFlatOwned[i] && gFlatOwnerID[i] == accid)
            count++;
    }

    return count;
}
stock CanPlayerBuyProperty(playerid)
{
    new accid = GetPlayerAccountID(playerid);
    new owned = GetPlayerPropertyCount(accid);
    new maxslots = 1 + GetPlayerData(playerid, P_HOUSE_SLOTS);
    if(maxslots > 2) maxslots = 2;

    if (owned >= maxslots)
    {
        new fmt[128];
        format(fmt, sizeof fmt, "У вас уже максимум недвижимости (%d из %d). Купите еще слот в донате.", owned, maxslots);
        SendClientMessage(playerid, -1, fmt);
        return 0;
    }
    return 1;
}
stock BuyFlat(playerid, flatid){
	new houseid = flatid / 1000;
    new floor   = (flatid % 1000) / 10;
    new flatidx = (flatid % 10) + (4*(floor-1));
	new flatids = (houseid * 100) + (floor * 10) + flatidx;
	if (gFlatOwned[flatids])
        return SendClientMessage(playerid, -1, "Дом уже куплен!");
	
	if(GetPlayerMoneyEx(playerid) < gFlatPrice[houseid])
	{
		new fmt[128];
		format(fmt, sizeof fmt, "Недостаточно денег для покупки. Нужно: %d руб", gFlatPrice[houseid]);
		return SendClientMessage(playerid, -1, fmt);
	}

	
    new accid = GetPlayerAccountID(playerid);

	if (!CanPlayerBuyProperty(playerid))
	    return 0;

	SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - gFlatPrice[houseid]);
    UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
				
    GivePlayerMoney(playerid, -gFlatPrice[houseid]);
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));


    gFlatOwned[flatids] = true;
    gFlatOwnerID[flatids] = accid;
	g_flat_real_id[flatids] = flatid;
	gFlatRentTime[flatids] = GetNewPropertyStartRentTime();
    format(gFlatOwner[flatids], 24, "%s", name);

    // Новая купленная квартира сразу становится выбранной недвижимостью.
    SetPlayerData(playerid, P_HOUSE_SELECTED, EncodeSelectedHouseProperty(true, flatids));
    UpdatePlayerDatabaseInt(playerid, "house_selected", GetPlayerData(playerid, P_HOUSE_SELECTED));

    new query[256];
    format(query, sizeof(query),
        "INSERT INTO bought_houses (house_id, account_id, owner_name, is_open, remont, apt, shkaf, kv, rent_time) VALUES (%d, %d, '%s', 0, 0, 0, 0, 1, %d)",
        flatid, accid, name, gFlatRentTime[flatids]
    );
    mysql_tquery(mysql, query);
	ShowNewPropertyPurchaseSuccess(playerid, gFlatPrice[houseid]);
	CreateDynamicActionPickup(
        1,
        23,
        FlatData[gFlatType[houseid]-1][hEnterX],
        FlatData[gFlatType[houseid]-1][hEnterY],
        FlatData[gFlatType[houseid]-1][hEnterZ],
        flatid,
        PICKUP_ACTION_TYPE_FLAT_EXITS,
        flatid
    );
    return EnterPlayerToFlatNew(playerid, flatid);
}
stock HandlePlayerFlatsNewPickup(playerid, flatid)
{
	new fmt_str[4024], type_name[256], owner_str[40], status_line[48], rooms;
	new houseid = flatid / 1000;
    new floor   = (flatid % 1000) / 10;
    new flatidx = (flatid % 10) + (4*(floor-1));
	new flatids = (houseid * 100) + (floor * 10) + flatidx;
	printf("[FLATS] houseid=%d floor=%d flatidx=%d flattype=%d", houseid, floor, flatidx, gFlatType[houseid]);

	if(gFlatOwned[flatids])
	{
		printf("[FLATS] houseid=%d floor=%d flatidx=%d flattype=%d gg", houseid, floor, flatidx, gFlatType[houseid]);
		format(owner_str, sizeof owner_str, "{00CC66}%s", gFlatOwner[flatids]);
		format(status_line, sizeof status_line, "{E0584B}Дом занят");
		format(fmt_str, sizeof fmt_str,
		    "{FFFFFF}Название\t{FFFFFF}Информация\n"\
		    "{FFFFFF}Владелец:\t%s\n"\
		    "{FFFFFF}Тип:\t{00CC66}%s\n"\
		    "{FFFFFF}Номер квартиры:\t{00CC66}%d\n"\
			"{FFFFFF}Номер подъезда:\t{00CC66}%d\n"\
		    "{FFFFFF}Количество комнат:\t{00CC66}%d\n"\
		    "{FFFFFF}Стоимость:\t{00CC66}%d руб\n"\
		    "{FFFFFF}Ежедневная квартплата:\t{00CC66}%d руб",
		    owner_str,
		    FlatData[gFlatType[houseid]-1][hName],
			flatidx,
			houseid + 100,
		    FlatData[gFlatType[houseid]-1][hRooms],
		    gFlatPrice[houseid],
			FlatData[gFlatType[houseid]-1][hPriceP]
	    );
		SetPVarInt(playerid, "hnew_pickup_id", flatid);
	    Dialog(playerid, DIALOG_HOUSE_NEW_FLATS, DIALOG_STYLE_TABLIST_HEADERS, status_line, fmt_str, "Войти", "Отмена");
	}
    else
	{
		printf("[FLATS] houseid=%d floor=%d flatidx=%d flattype=%d ss", houseid, floor, flatidx, gFlatType[houseid]);
		format(status_line, sizeof status_line, "{66CC66}Дом свободен");
		format(fmt_str, sizeof fmt_str,
		    "{FFFFFF}Название\t{FFFFFF}Информация\n"\
		    "{FFFFFF}Тип:\t{00CC66}%s\n"\
		    "{FFFFFF}Номер квартиры:\t{00CC66}%d\n"\
			"{FFFFFF}Номер подъезда:\t{00CC66}%d\n"\
		    "{FFFFFF}Количество комнат:\t{00CC66}%d\n"\
		    "{FFFFFF}Стоимость:\t{00CC66}%d руб\n"\
		    "{FFFFFF}Ежедневная квартплата:\t{00CC66}%d руб",
		    FlatData[gFlatType[houseid]-1][hName],
			flatidx,
			houseid + 100,
		    FlatData[gFlatType[houseid]-1][hRooms],
		    gFlatPrice[houseid],
			FlatData[gFlatType[houseid]-1][hPriceP]
	    );
		SetPVarInt(playerid, "hnew_pickup_id", flatid);
	    Dialog(playerid, DIALOG_HOUSE_FLATS_BUY, DIALOG_STYLE_TABLIST_HEADERS, status_line, fmt_str, "Купить", "Отмена");
		printf("[FLATS] houseid=%d floor=%d flatidx=%d flattype=%d hd", houseid, floor, flatidx, gFlatType[houseid]);
	}
	return 1;
}

new ATMHousePickup[6];
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if (gPlayerBlockedPickup[playerid] == pickupid) return 1;

    gPlayerBlockedPickup[playerid] = pickupid;
    for(new point; point < sizeof g_TC56_Pickup; point++)
        if(pickupid == _:g_TC56_Pickup[point]) return TC56_Open(playerid);
    
	for(new i = 0; i < sizeof(ATMHousePickup); i++)
    {
        if(pickupid == ATMHousePickup[i])
        {
            ShowNotificationNew(
                playerid,
                5,
                7,
                9201,
                0,
                "Взаимодействие с банкоматом",
                "НАЖАТЬ"
            );
            break;
        }
    }
    switch (gDynPickupAction[pickupid])
    {
        case PICKUP_ACTION_TYPE_HOUSE_NEWS:
        {
            if (GetTickCount() < gPlayerPickupCooldown[playerid]) return 1;
            new flatid = gDynPickupData[pickupid];
            HandlePlayerHouseNewPickupb(playerid, flatid);
        }
        case PICKUP_ACTION_TYPE_HOUSE_LIFT:
        {
            if (GetPVarInt(playerid, "lift_dialog_active")) return 1;
			if (GetTickCount() < gPlayerPickupCooldowns[playerid]) return 1;

            new flatid = gDynPickupData[pickupid];
            ShowPlayerLiftInfo(playerid, flatid);
        }
        case PICKUP_ACTION_TYPE_FLAT_EXIT:
        {
            new flatid = gDynPickupData[pickupid];
            HandleExitPlayerFlatNewPickup(playerid, flatid);
			gPlayerPickupCooldown[playerid] = GetTickCount() + 4000; // 5 секунд
        }
		case PICKUP_ACTION_TYPE_FLAT_ENTER:
		{
			if (GetTickCount() < gPlayerPickupCooldownsV[playerid]) return 1;
			gPlayerPickupCooldownsV[playerid] = GetTickCount() + 7000;
			new flatid = gDynPickupData[pickupid];
			ShowNotificationNew(playerid, 5, 7, 9198, flatid, "Посмотреть информацию о квартире", "ОТКРЫТЬ");
			//HandlePlayerFlatsNewPickup(playerid, flatid);
		}
		case PICKUP_ACTION_TYPE_FLAT_EXITS:
		{
			if (GetTickCount() < gPlayerPickupCooldownsV[playerid]) return 1;
			gPlayerPickupCooldownsV[playerid] = GetTickCount() + 7000;
			new flatid = gDynPickupData[pickupid];
			ShowNotificationNew(playerid, 5, 7, 9120, flatid, "Выход из квартиры", "ВЫЙТИ");
		}
    }
    return 1;
}

