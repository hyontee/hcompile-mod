//>> Файл: bykranin_src/core/property/property_14.inc  (976 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: /testmusic, Spectate_HideSkin, Spectate_RestoreSkin, ResetHouseNewData, IsHouseNewOwned, GetFreeHouseNewSlot, UpdateHouseNewVisual
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:testmusic(playerid)
{
    new JSON:json = JSON_Object();

    JSON_SetInt(json, "t", 1);          // вкладка: библиотека
    JSON_SetString(json, "n", "Музыка");

    JSON_SetInt(json, "c", 4);          // количество треков

    JSON_SetString(json, "m0", "Midnight City");
    JSON_SetString(json, "m1", "Neon Lights");
    JSON_SetString(json, "m2", "Cold Street");
    JSON_SetString(json, "m3", "Last Ride");

    JSON_SetInt(json, "r0", 0);
    JSON_SetInt(json, "r1", 0);
    JSON_SetInt(json, "r2", 0);
    JSON_SetInt(json, "r3", 0);

    ShowPlayerGUI(playerid, 9, json);
    ~json;
    return 1;
}
stock Spectate_HideSkin(playerid)
{
    if(g_SpecSkinHidden[playerid]) return 1;

    g_SpecSavedSkin[playerid] = GetPlayerSkin(playerid);
    g_SpecSkinHidden[playerid] = true;

    SetPlayerHealth(playerid, 100.0);    
    return 1;
}

stock Spectate_RestoreSkin(playerid)
{
    if(!g_SpecSkinHidden[playerid]) return 1;

    g_SpecSkinHidden[playerid] = false;

    
    return 1;
}


stock ResetHouseNewData(houseid)
{
	g_house_new[houseid][HN_SQL_ID] = 0;
	g_house_new[houseid][HN_ACCOUNTS_ID] = 0;
	g_house_new[houseid][HN_PRICE] = 0;
	g_house_new[houseid][HN_TYPE] = 0;

	g_house_new[houseid][HN_X] = 0.0;
	g_house_new[houseid][HN_Y] = 0.0;
	g_house_new[houseid][HN_Z] = 0.0;
	g_house_new[houseid][HN_ANGLE] = 0.0;

	g_house_new[houseid][HN_INT_X] = HNEW_INT_X;
	g_house_new[houseid][HN_INT_Y] = HNEW_INT_Y;
	g_house_new[houseid][HN_INT_Z] = HNEW_INT_Z;
	g_house_new[houseid][HN_INT_A] = HNEW_INT_A;
	g_house_new[houseid][HN_INT_INTERIOR] = HNEW_INT_INTERIOR;

	g_house_new[houseid][HN_WORLD] = 5000 + houseid;

	g_house_new[houseid][HN_PICKUP_EXT] = -1;
	g_house_new[houseid][HN_PICKUP_INT] = -1;
	g_house_new[houseid][HN_LABEL] = Text3D: -1;

	g_house_new[houseid][HN_OWNER_NAME][0] = EOS;
	g_house_new[houseid][HN_CREATED] = false;

	return 1;
}

stock bool:IsHouseNewOwned(houseid)
{
	return (g_house_new[houseid][HN_ACCOUNTS_ID] > 0);
}



stock GetFreeHouseNewSlot()
{
	for(new i = 0; i < MAX_HOUSES_NEW; i++)
	{
		if(!g_house_new[i][HN_CREATED]) return i;
	}
	return -1;
}

stock UpdateHouseNewVisual(houseid)
{
	/*
	if(!g_house_new[houseid][HN_CREATED]) return 1;

	if(g_house_new[houseid][HN_PICKUP_EXT] != -1)
	{
		DestroyPickup(g_house_new[houseid][HN_PICKUP_EXT]);
		g_house_new[houseid][HN_PICKUP_EXT] = -1;
	}

	if(g_house_new[houseid][HN_PICKUP_INT] != -1)
	{
		DestroyPickup(g_house_new[houseid][HN_PICKUP_INT]);
		g_house_new[houseid][HN_PICKUP_INT] = -1;
	}

	if(IsValidDynamic3DTextLabel(g_house_new[houseid][HN_LABEL]))
	{
		DestroyDynamic3DTextLabel(g_house_new[houseid][HN_LABEL]);
		g_house_new[houseid][HN_LABEL] = Text3D: -1;
	}

	g_house_new[houseid][HN_PICKUP_EXT] = CreatePickup(
		(IsHouseNewOwned(houseid) ? 1272 : 1273),
		23,
		g_house_new[houseid][HN_X],
		g_house_new[houseid][HN_Y],
		g_house_new[houseid][HN_Z],
		0,
		PICKUP_ACTION_TYPE_HOUSE_NEW,
		houseid
	);

	g_house_new[houseid][HN_PICKUP_INT] = CreatePickup(
		1318,
		23,
		g_house_new[houseid][HN_INT_X],
		g_house_new[houseid][HN_INT_Y],
		g_house_new[houseid][HN_INT_Z],
		g_house_new[houseid][HN_WORLD],
		PICKUP_ACTION_TYPE_HOUSE_NEW,
		houseid
	);

	new label_text[256];
	if(IsHouseNewOwned(houseid))
	{
		format(label_text, sizeof label_text,
			"{33CC66}Дом #%d\n{FFFFFF}Владелец: {FFFF00}%s\n{AAAAAA}Войдите в пикап",
			houseid,
			g_house_new[houseid][HN_OWNER_NAME]);
	}
					else
	{
		format(label_text, sizeof label_text,
			"{33CC66}Дом #%d\n{FFFFFF}Цена: {66CCFF}%d руб\n{AAAAAA}Войдите в пикап для покупки",
			houseid,
			g_house_new[houseid][HN_PRICE]);
	}

	g_house_new[houseid][HN_LABEL] = CreateDynamic3DTextLabel(
		label_text,
		0xFFFFFFFF,
		g_house_new[houseid][HN_X],
		g_house_new[houseid][HN_Y],
		g_house_new[houseid][HN_Z] + 0.9,
		12.0,
		INVALID_PLAYER_ID,
		INVALID_VEHICLE_ID,
		0,
		0
	);
	*/
	return 1;
}

stock EnterPlayerToHouseNew(playerid, houseid)
{
	
	new h = GetHouseData(gHouseType[houseid]);
	new Float:enter_x = HouseData[h][hEnterX];
	new Float:enter_y = HouseData[h][hEnterY];
	new Float:enter_z = HouseData[h][hEnterZ];
	new Float:enter_a = HouseData[h][hEnterA];
	new Float:house_new_enter_offset = 2.0;

	// Move player slightly away from exit pickup to avoid instant re-exit.
	
	SetPlayerPosEx(
		playerid,
		enter_x,
		enter_y,
		enter_z,
		enter_a,
		1,
		houseid
	);
	SetPVarInt(playerid, "house_new_id", houseid);
	return 1;
}

stock EnterPlayerToFlatNew(playerid, flatid)
{
	new houseid = flatid / 1000;
    new floor   = (flatid % 1000) / 10;
    new flatidx = (flatid % 10) + (4*(floor-1));
	new flatids = (houseid * 100) + (floor * 10) + flatidx;
	new h = gFlatType[houseid]-1;
	new Float:enter_x = FlatData[h][hEnterX];
	new Float:enter_y = FlatData[h][hEnterY];
	new Float:enter_z = FlatData[h][hEnterZ];
	new Float:enter_a = FlatData[h][hEnterA];
	new Float:house_new_enter_offset = 2.0;

	// Move player slightly away from exit pickup to avoid instant re-exit.
	
	SetPlayerPosEx(
		playerid,
		enter_x,
		enter_y,
		enter_z,
		enter_a,
		1,
		flatid
	);
	return 1;
}
stock EnterPlayerToFlatNews(playerid, flatid)
{
	new houseid = flatid / 1000;
    new floor   = (flatid % 1000) / 10;
    new flatidx = (flatid % 10) + (4*(floor-1));
	new flatids = (houseid * 100) + (floor * 10) + flatidx;
	new h = 5-1;
	new Float:enter_x = FlatData[h][hEnterX];
	new Float:enter_y = FlatData[h][hEnterY];
	new Float:enter_z = FlatData[h][hEnterZ];
	new Float:enter_a = FlatData[h][hEnterA];
	new Float:house_new_enter_offset = 2.0;

	// Move player slightly away from exit pickup to avoid instant re-exit.
	
	SetPlayerPosEx(
		playerid,
		enter_x,
		enter_y,
		enter_z,
		enter_a,
		1,
		flatid
	);
	return 1;
}

stock ExitPlayerFromHouseNew(playerid, houseid)
{
	SetPlayerPosEx(
		playerid,
		g_house_new[houseid][HN_X],
		g_house_new[houseid][HN_Y],
		g_house_new[houseid][HN_Z],
		g_house_new[houseid][HN_ANGLE],
		0,
		0
	);
	DeletePVar(playerid, "house_new_id");
	return 1;
}

stock ShowPlayerHouseNewInfo(playerid, houseid)
{
	new fmt_str[1024], status_str[40], location_str[80];
	new rent_days = GetNewPropertyRentDaysLeft(gHouseRentTime[houseid]);
	new upgrade_level = GetNewPropertyUpgradeLevel(g_house_new_apt[houseid], g_house_new_shkaf[houseid], g_house_new_remont[houseid]);

	format(status_str, sizeof status_str, "%s", g_house_new_opens[houseid] ? ("{66CC66}Дом открыт") : ("{E0584B}Дом закрыт"));
    new h = GetHouseData(gHouseType[houseid]);
	FormatNewPropertyLocation(gHousesForSale[houseid][0], gHousesForSale[houseid][1], location_str, sizeof location_str);

	format(fmt_str, sizeof fmt_str,
		"{FFFFFF}\t\n"\
		"{FFFFFF}Тип / название:\t{B8B8B8}%s\n"\
		"{FFFFFF}Номер дома:\t%d\n"\
		"{FFFFFF}Город / область:\t%s\n"\
		"{FFFFFF}Стоимость:\t{B8B8B8}%d {ffffff}руб\n"\
		"{FFFFFF}Дом оплачен на:\t{66CC66}%d {FFFFFF}из {66CC66}30 {FFFFFF}дней\n"\
		"{FFFFFF}Количество комнат:\t{E0584B}%d\n"\
		"{FFFFFF}Уровень улучшений:\t{CC3333}%d\n"\
		"{FFFFFF}Уровень улучшений подвала:\t{CC3333}0\n"\
		"{FFFFFF}Квартплата:\t{66CC66}%d {ffffff}руб в день\n"\
		"{FFFFFF}Тип квартплаты:\t{FFFFFF}Обычная\n"\
		"{FFFFFF}Статус:\t%s",
		HouseData[h][hName],
		houseid + 3000,
		location_str,
		HouseData[h][hPrice],
		rent_days,
		HouseData[h][hRooms],
		upgrade_level,
		HouseData[h][hPriceP],
		status_str
	);

	Dialog(playerid, DIALOG_HOUSE_NEW_INFO, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}{SERVER_NAME} {FFFFFF}| Информация о доме", fmt_str, "Изменить", "Отмена");
	return 1;
}

stock BuyPlayerHouseNew(playerid, houseid)
{
	new account_id = GetPlayerAccountID(playerid);
	if(account_id <= 0) return SendClientMessage(playerid, -1, "Ошибка аккаунта. Перезайдите на сервер");

	if(GetHouseNewByOwner(account_id, playerid) != -1)
		return SendClientMessage(playerid, -1, "У вас уже есть дом в новой системе");

	if(GetPlayerMoneyEx(playerid) < g_house_new[houseid][HN_PRICE])
	{
		new fmt[128];
		format(fmt, sizeof fmt, "Недостаточно денег для покупки. Нужно: %d руб", g_house_new[houseid][HN_PRICE]);
		return SendClientMessage(playerid, -1, fmt);
	}

	new owner_name[21], query[256];
	format(owner_name, sizeof owner_name, "%s", GetPlayerNameEx(playerid));

	GivePlayerMoneyEx(playerid, -g_house_new[houseid][HN_PRICE], "Покупка дома (housesnew)", false, true);

	g_house_new[houseid][HN_ACCOUNTS_ID] = account_id;
	g_house_new_open[houseid] = false;
	format(g_house_new[houseid][HN_OWNER_NAME], 21, "%s", owner_name);

	if(g_house_new[houseid][HN_SQL_ID] > 0)
	{
		mysql_format(mysql, query, sizeof query,
			"UPDATE housesnew SET accounts_id=%d, owner_name='%e' WHERE id=%d LIMIT 1",
			account_id,
			owner_name,
			g_house_new[houseid][HN_SQL_ID]);
	}
					else
	{
		mysql_format(mysql, query, sizeof query,
			"UPDATE housesnew SET accounts_id=%d, owner_name='%e' WHERE accounts_id=0 AND x=%f AND y=%f AND z=%f ORDER BY id DESC LIMIT 1",
			account_id,
			owner_name,
			g_house_new[houseid][HN_X],
			g_house_new[houseid][HN_Y],
			g_house_new[houseid][HN_Z]);
	}
	mysql_query(mysql, query, false);
	new mysql_error_id = mysql_errno();
	if(mysql_error_id != 0)
	{
		printf("[HousesNew][Buy] MYSQL ERROR %d | houseid=%d sql_id=%d account_id=%d | query: %s", mysql_error_id, houseid, g_house_new[houseid][HN_SQL_ID], account_id, query);
	}

	UpdateHouseNewVisual(houseid);
	SendClientMessage(playerid, -1, "Поздравляем, вы купили дом" );
	return EnterPlayerToHouseNew(playerid, houseid);
}

stock ProcessPlayerFlatNewPickupEnter(playerid, flatid)
{
	new account_id = GetPlayerAccountID(playerid);
	if(account_id <= 0) return SendClientMessage(playerid, -1, "Ошибка аккаунта. Перезайдите на сервер");
	new houseid = flatid / 1000;
    new floor   = (flatid % 1000) / 10;
    new flatidx = (flatid % 10) + (4*(floor-1));
	new flatids = (houseid * 100) + (floor * 10) + flatidx;
	new h = gFlatType[houseid]-1;
	
	if (!g_flat_new_opens[flatids]){
		if (gFlatOwnerID[flatids] != account_id){
			SendClientMessage(playerid, -1, "{c71010}Дом закрыт");
			return 1;
		}
	}
	if (g_flat_new_remont[flatids]){
		return EnterPlayerToFlatNews(playerid, flatid);
	}
	return EnterPlayerToFlatNew(playerid, flatid);
}
stock ProcessPlayerHouseNewPickupEnter(playerid, houseid)
{
	new account_id = GetPlayerAccountID(playerid);
	if(account_id <= 0) return SendClientMessage(playerid, -1, "Ошибка аккаунта. Перезайдите на сервер");
	new h = GetHouseData(gHouseType[houseid]);
	
	if(!gHouseOwned[houseid])
	{
		return BuyHouse(playerid, houseid);
	}
	if (!g_house_new_opens[houseid]){
		if (gHouseOwnerID[houseid] != account_id){
			SendClientMessage(playerid, -1, "{c71010}Дом закрыт");
			return 1;
		}
	}
	return EnterPlayerToHouseNew(playerid, houseid);
}

stock ProcessPlayerFlatMoveFloor(playerid, houseid, listitem)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return SendClientMessage(playerid, -1, "Ошибка аккаунта. Перезайдите на сервер");

    if (gFlatEnTypes[houseid] == 0)
    {
        new currentFloor = GetPVarInt(playerid, "hnew_current_floor");
        new selectedFloor = listitem + 1;
        if (currentFloor > 0 && selectedFloor >= currentFloor)
        {
            selectedFloor++;
        }

        new worldid = houseid + ((selectedFloor - 1) * (FLATS_FOR_SALE_COUNT + 1));

        SetPlayerPosEx(
            playerid,
            560.43,
            25.09,
            1049.31,
            0,
            1,
            worldid
        );
    }
    return 1;
}

stock ProcessPlayerFlatMoveFloors(playerid, houseid, listitem)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return SendClientMessage(playerid, -1, "Ошибка аккаунта. Перезайдите на сервер");

    if (gFlatEnTypes[houseid] == 1)
    {
        new currentFloor = GetPVarInt(playerid, "hnew_current_floor");
        new selectedFloor = listitem + 1;
		
		if (currentFloor != 1 && selectedFloor == 1){
			new worldid = houseid + (0 * (FLATS_FOR_SALE_COUNT + 1));
            SetPlayerPosEx(
                playerid,
                -500.62,
                1001.09,
                1499.17,
                180,
                1,
                worldid
            );
			return 1;
		}
        if (currentFloor > 0 && selectedFloor >= currentFloor)
        {
            selectedFloor++;
        }

        new worldid = houseid + ((selectedFloor - 1) * (FLATS_FOR_SALE_COUNT + 1));

        SetPlayerPosEx(
            playerid,
            -493.17,
            1003.76,
            1499.17,
            180,
            1,
            worldid
        );
    }
    return 1;
}

stock ProcessPlayerHouseNewPickupExit(playerid, houseid, listitem)
{
	new account_id = GetPlayerAccountID(playerid);
	if(account_id <= 0) return SendClientMessage(playerid, -1, "Ошибка аккаунта. Перезайдите на сервер");
	new h = GetHouseData(gHouseType[houseid]);
	
	if(listitem == 0)
	{
		new h = GetHouseData(gHouseType[houseid]);

	    SetPlayerPosEx(
	    	playerid,
	    	gHousesForSale[houseid][0],
			gHousesForSale[houseid][1],
			gHousesForSale[houseid][2],
	    	90,
	    	0,
	    	0
	    );
		return 1;
	}

	if(listitem == 1)
	{
		SetPlayerPosEx(
	    	playerid,
	    	498.552,
			2497.555,
			1501.7,
	    	90,
	    	1,
	    	houseid
	    );
	}
	return 1;
}



stock ProcessPlayerBasementNewPickupExit(playerid, houseid, listitem)
{
	new account_id = GetPlayerAccountID(playerid);
	if(account_id <= 0) return SendClientMessage(playerid, -1, "Ошибка аккаунта. Перезайдите на сервер");
	new h = GetHouseData(gHouseType[houseid]);
	
	if(listitem == 0)
	{
	new Float:enter_x = HouseData[h][hEnterX];
	new Float:enter_y = HouseData[h][hEnterY];
	new Float:enter_z = HouseData[h][hEnterZ];
	new Float:enter_a = HouseData[h][hEnterA];
	new Float:house_new_enter_offset = 2.0;

	// Move player slightly away from exit pickup to avoid instant re-exit.
	
	SetPlayerPosEx(
		playerid,
		enter_x,
		enter_y,
		enter_z,
		enter_a,
		1,
		houseid
	);
		return 1;
	}
	return 1;
}

stock HandlePlayerHouseNewPickup(playerid, houseid)
{
	if(!(0 <= houseid < HOUSES_FOR_SALE_COUNT)) return 1;

	return ShowPlayerHouseNewPickupDialog(playerid, houseid);
}
stock HandlePlayerHouseNewPickupb(playerid, houseid)
{

	if (gFlatEnTypes[houseid] == 0){
	    SetPlayerPosEx(
	    	playerid,
	    	558.45,
			24.08,
			1049.31,
	    	0,
	    	1,
	    	houseid
	    );
	}
	if (gFlatEnTypes[houseid] == 1){
		SetPlayerPosEx(
	    	playerid,
	    	-500.13,
			1000.92,
			1499.17,
	    	0,
	    	1,
	    	houseid
	    );
	}
	if (gFlatEnTypes[houseid] == 2){
		SetPlayerPosEx(
	    	playerid,
	    	-508.65,
			488.20,
			1501.04,
	    	270,
	    	1,
	    	houseid
	    );
	}

}

stock CreateHouseATMpickups()
{
    ATMHousePickup[0] = CreateDynamicPickup(
        1,
        23,
        2880.384277,
        2511.058349,
        1051.044799,
        -1,
        -1
    );

    ATMHousePickup[1] = CreateDynamicPickup(
        1,
        23,
        2880.439941,
        2508.445800,
        1051.044799,
        -1,
        -1
    );

    ATMHousePickup[2] = CreateDynamicPickup(
        1,
        23,
        2880.091796,
        2505.942626,
        1051.044799,
        -1,
        -1
    );

    ATMHousePickup[3] = CreateDynamicPickup(
        1,
        23,
        2880.289794,
        2503.570312,
        1051.044799,
        -1,
        -1
    );

    ATMHousePickup[4] = CreateDynamicPickup(
        1,
        23,
        2880.124511,
        2501.125244,
        1051.044799,
        -1,
        -1
    );

    ATMHousePickup[5] = CreateDynamicPickup(
        1,
        23,
        2880.246337,
        2498.662597,
        1051.044799,
        -1,
        -1
    );

    return 1;
}
stock HandleExitPlayerHouseNewPickup(playerid, houseid){
	if(!(0 <= houseid < HOUSES_FOR_SALE_COUNT)) return 1;
	ShowNotificationNew(playerid, 5, 7, 9119, houseid, "Выход из дома", "ВЫЙТИ");
	return 1;
	//return ShowPlayerHouseExitPickupDialog(playerid, houseid);
}

stock HandleExitPlayerBasement(playerid, houseid){
	if(!(0 <= houseid < HOUSES_FOR_SALE_COUNT)) return 1;
	
    return ShowPlayerBasementExitPickupDialog(playerid, houseid);
}
public: LoadHousesNew()
{
	/*
	new Cache: result;
	new rows;

	for(new i = 0; i < MAX_HOUSES_NEW; i++)
	{
		ResetHouseNewData(i);
	}

	result = mysql_query(mysql, "SELECT * FROM housesnew ORDER BY id ASC", true);
	rows = cache_num_rows(result);
	if(rows > MAX_HOUSES_NEW) rows = MAX_HOUSES_NEW;

	for(new i = 0; i < rows; i++)
	{
		g_house_new[i][HN_SQL_ID] = cache_get_field_content_int(i, "id");
		g_house_new[i][HN_ACCOUNTS_ID] = cache_get_field_content_int(i, "accounts_id");
		g_house_new[i][HN_PRICE] = cache_get_field_content_int(i, "price");
		g_house_new[i][HN_TYPE] = cache_get_field_content_int(i, "type");

		g_house_new[i][HN_X] = cache_get_field_content_float(i, "x");
		g_house_new[i][HN_Y] = cache_get_field_content_float(i, "y");
		g_house_new[i][HN_Z] = cache_get_field_content_float(i, "z");
		g_house_new[i][HN_ANGLE] = cache_get_field_content_float(i, "angle");

		g_house_new[i][HN_INT_X] = cache_get_field_content_float(i, "int_x");
		g_house_new[i][HN_INT_Y] = cache_get_field_content_float(i, "int_y");
		g_house_new[i][HN_INT_Z] = cache_get_field_content_float(i, "int_z");
		g_house_new[i][HN_INT_A] = cache_get_field_content_float(i, "int_a");
		g_house_new[i][HN_INT_INTERIOR] = cache_get_field_content_int(i, "int_interior");

		if(g_house_new[i][HN_INT_X] == 0.0 && g_house_new[i][HN_INT_Y] == 0.0 && g_house_new[i][HN_INT_Z] == 0.0)
		{
			g_house_new[i][HN_INT_X] = HNEW_INT_X;
			g_house_new[i][HN_INT_Y] = HNEW_INT_Y;
			g_house_new[i][HN_INT_Z] = HNEW_INT_Z;
			g_house_new[i][HN_INT_A] = HNEW_INT_A;
			g_house_new[i][HN_INT_INTERIOR] = HNEW_INT_INTERIOR;
		}

		cache_get_field_content(i, "owner_name", g_house_new[i][HN_OWNER_NAME], mysql, 21);
		if(!strlen(g_house_new[i][HN_OWNER_NAME])) format(g_house_new[i][HN_OWNER_NAME], 21, "None");

		g_house_new[i][HN_WORLD] = 5000 + i;
		g_house_new[i][HN_CREATED] = true;
		g_house_new[i][HN_PICKUP_EXT] = -1;
		g_house_new[i][HN_PICKUP_INT] = -1;
		g_house_new[i][HN_LABEL] = Text3D: -1;

		UpdateHouseNewVisual(i);
	}

	g_house_new_loaded = rows;
	cache_delete(result);

	printf("[HousesNew]: Домов загружено: %d", g_house_new_loaded);
	
	*/
	return 1;
}

CMD:addhouse(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;

	extract params -> new price; else return SendClientMessage(playerid, -1, "Используйте: /addhouse [price]");
	if(price < 1) return SendClientMessage(playerid, -1, "Цена должна быть больше 0");

	if(GetFreeHouseNewSlot() == -1)
		return SendClientMessage(playerid, -1, "Достигнут лимит MAX_HOUSES_NEW");

	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	SetPVarInt(playerid, "hnew_create_price", price);
	SetPVarFloat(playerid, "hnew_create_x", x);
	SetPVarFloat(playerid, "hnew_create_y", y);
	SetPVarFloat(playerid, "hnew_create_z", z);
	SetPVarFloat(playerid, "hnew_create_a", a);

	new class_list[256];
	class_list[0] = EOS;
	for(new i = 0; i < sizeof g_house_type; i++)
	{
		new class_row[64];
		format(class_row, sizeof class_row, "%d. %s\n", i, GetHouseTypeInfo(i, HT_NAME));
		strcat(class_list, class_row);
	}

	Dialog(playerid, DIALOG_HOUSE_NEW_CLASS, DIALOG_STYLE_LIST, "Выбор класса дома", class_list, "Выбрать", "Отмена");
	return 1;
}
CMD:testhouses(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	extract params -> new mode;
	if(!(1 <= mode <= 2))
		return SendClientMessage(playerid, -1, "Используйте: /testhouses [1-высокий | 2-деревенский]");

	new created_count = 0;
	new fail_count = 0;

	if(mode == 1)
	{
		new premium_type = 4;
		for(new i = 0; i < sizeof g_test_house_coords_premium; i++)
		{
			new houseid = GetFreeHouseNewSlot();
			if(houseid == -1)
			{
				fail_count += (sizeof g_test_house_coords_premium - i);
				break;
			}

			g_house_new[houseid][HN_SQL_ID] = 0;
			g_house_new[houseid][HN_ACCOUNTS_ID] = 0;
			g_house_new[houseid][HN_PRICE] = 10000000;
			g_house_new[houseid][HN_TYPE] = premium_type;
			g_house_new[houseid][HN_X] = g_test_house_coords_premium[i][0];
			g_house_new[houseid][HN_Y] = g_test_house_coords_premium[i][1];
			g_house_new[houseid][HN_Z] = g_test_house_coords_premium[i][2];
			g_house_new[houseid][HN_ANGLE] = 0.0;
			g_house_new[houseid][HN_INT_X] = GetHouseTypeInfo(premium_type, HT_ENTER_POS_X);
			g_house_new[houseid][HN_INT_Y] = GetHouseTypeInfo(premium_type, HT_ENTER_POS_Y);
			g_house_new[houseid][HN_INT_Z] = GetHouseTypeInfo(premium_type, HT_ENTER_POS_Z);
			g_house_new[houseid][HN_INT_A] = GetHouseTypeInfo(premium_type, HT_ENTER_POS_ANGLE);
			g_house_new[houseid][HN_INT_INTERIOR] = GetHouseTypeInfo(premium_type, HT_INTERIOR);
			g_house_new[houseid][HN_WORLD] = 5000 + houseid;
			g_house_new[houseid][HN_CREATED] = true;
			g_house_new[houseid][HN_PICKUP_EXT] = -1;
			g_house_new[houseid][HN_PICKUP_INT] = -1;
			g_house_new[houseid][HN_LABEL] = Text3D: -1;
			format(g_house_new[houseid][HN_OWNER_NAME], 21, "None");

			new query[512], Cache:result;
			mysql_format(mysql, query, sizeof query,
				"INSERT INTO housesnew (accounts_id, owner_name, type, price, x, y, z, angle, int_x, int_y, int_z, int_a, int_interior) VALUES (0, '', %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %d)",
				g_house_new[houseid][HN_TYPE],
				g_house_new[houseid][HN_PRICE],
				g_house_new[houseid][HN_X],
				g_house_new[houseid][HN_Y],
				g_house_new[houseid][HN_Z],
				g_house_new[houseid][HN_ANGLE],
				g_house_new[houseid][HN_INT_X],
				g_house_new[houseid][HN_INT_Y],
				g_house_new[houseid][HN_INT_Z],
				g_house_new[houseid][HN_INT_A],
				g_house_new[houseid][HN_INT_INTERIOR]
			);

			result = mysql_query(mysql, query, true);
			g_house_new[houseid][HN_SQL_ID] = cache_insert_id();
			cache_delete(result);

			if(g_house_new[houseid][HN_SQL_ID] <= 0)
			{
				printf("[HousesNew][Test] premium insert failed | idx=%d slot=%d", i, houseid);
				ResetHouseNewData(houseid);
				fail_count++;
				continue;
			}

			UpdateHouseNewVisual(houseid);
			if(g_house_new_loaded < houseid + 1) g_house_new_loaded = houseid + 1;
			created_count++;
		}
	}
					else
	{
		new village_type = 0;
		for(new i = 0; i < sizeof g_test_house_coords_village; i++)
		{
			new houseid = GetFreeHouseNewSlot();
			if(houseid == -1)
			{
				fail_count += (sizeof g_test_house_coords_village - i);
				break;
			}

			g_house_new[houseid][HN_SQL_ID] = 0;
			g_house_new[houseid][HN_ACCOUNTS_ID] = 0;
			g_house_new[houseid][HN_PRICE] = 1000000;
			g_house_new[houseid][HN_TYPE] = village_type;
			g_house_new[houseid][HN_X] = g_test_house_coords_village[i][0];
			g_house_new[houseid][HN_Y] = g_test_house_coords_village[i][1];
			g_house_new[houseid][HN_Z] = g_test_house_coords_village[i][2];
			g_house_new[houseid][HN_ANGLE] = 0.0;
			g_house_new[houseid][HN_INT_X] = GetHouseTypeInfo(village_type, HT_ENTER_POS_X);
			g_house_new[houseid][HN_INT_Y] = GetHouseTypeInfo(village_type, HT_ENTER_POS_Y);
			g_house_new[houseid][HN_INT_Z] = GetHouseTypeInfo(village_type, HT_ENTER_POS_Z);
			g_house_new[houseid][HN_INT_A] = GetHouseTypeInfo(village_type, HT_ENTER_POS_ANGLE);
			g_house_new[houseid][HN_INT_INTERIOR] = GetHouseTypeInfo(village_type, HT_INTERIOR);
			g_house_new[houseid][HN_WORLD] = 5000 + houseid;
			g_house_new[houseid][HN_CREATED] = true;
			g_house_new[houseid][HN_PICKUP_EXT] = -1;
			g_house_new[houseid][HN_PICKUP_INT] = -1;
			g_house_new[houseid][HN_LABEL] = Text3D: -1;
			format(g_house_new[houseid][HN_OWNER_NAME], 21, "None");

			new query[512], Cache:result;
			mysql_format(mysql, query, sizeof query,
				"INSERT INTO housesnew (accounts_id, owner_name, type, price, x, y, z, angle, int_x, int_y, int_z, int_a, int_interior) VALUES (0, '', %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %d)",
				g_house_new[houseid][HN_TYPE],
				g_house_new[houseid][HN_PRICE],
				g_house_new[houseid][HN_X],
				g_house_new[houseid][HN_Y],
				g_house_new[houseid][HN_Z],
				g_house_new[houseid][HN_ANGLE],
				g_house_new[houseid][HN_INT_X],
				g_house_new[houseid][HN_INT_Y],
				g_house_new[houseid][HN_INT_Z],
				g_house_new[houseid][HN_INT_A],
				g_house_new[houseid][HN_INT_INTERIOR]
			);

			result = mysql_query(mysql, query, true);
			g_house_new[houseid][HN_SQL_ID] = cache_insert_id();
			cache_delete(result);

			if(g_house_new[houseid][HN_SQL_ID] <= 0)
			{
				printf("[HousesNew][Test] village insert failed | idx=%d slot=%d", i, houseid);
				ResetHouseNewData(houseid);
				fail_count++;
				continue;
			}

			UpdateHouseNewVisual(houseid);
			if(g_house_new_loaded < houseid + 1) g_house_new_loaded = houseid + 1;
			created_count++;
		}
	}

	new fmt[144];
	format(fmt, sizeof fmt, "[HousesNew] testhouses mode=%d: создано %d, ошибок %d", mode, created_count, fail_count);
	SendClientMessage(playerid, -1, fmt);
	return 1;
}

stock ContForNewCreate()
{
	for(new cont = 1; cont <= MAX_CONT; cont++)
    {
        cInfo[cont][BetedId] = INVALID_PLAYER_ID;
        ContsText[cont] = CreateDynamic3DTextLabel("", CLR_WHITE, ContBuyTextPos[cont-1][0], ContBuyTextPos[cont-1][1], ContBuyTextPos[cont-1][2], 4.0);
        ContsZone[cont] = CreateDynamicCircle(ContBuyTextPos[cont-1][0], ContBuyTextPos[cont-1][1], 3.0, 0, 0, -1);
    }
}

stock LoadTextDraw()
{
    cont_fon = TextDrawCreate(190.000198, 109.013328, "txd:brcontosnova");
    TextDrawLetterSize(cont_fon, 0.000000, 0.000000);
    TextDrawTextSize(cont_fon, 237.999938, 237.937759);
    TextDrawAlignment(cont_fon, 1);
    TextDrawColor(cont_fon, -1);
    TextDrawSetShadow(cont_fon, 0);
    TextDrawSetOutline(cont_fon, 0);
    TextDrawFont(cont_fon, 4);

    cont_take = TextDrawCreate(190.800003, 349.937774, "txd:brconttake");
    TextDrawLetterSize(cont_take, 0.000000, 0.000000);
    TextDrawTextSize(cont_take, 132.400009, 36.835563);
    TextDrawAlignment(cont_take, 1);
    TextDrawColor(cont_take, -1);
    TextDrawFont(cont_take, 4);
    TextDrawSetSelectable(cont_take, true);

    cont_sell = TextDrawCreate(324.800170, 349.937957, "txd:brcontsell");
    TextDrawLetterSize(cont_sell, 0.000000, 0.000000);
    TextDrawTextSize(cont_sell, 103.600006, 36.337799);
    TextDrawAlignment(cont_sell, 1);
    TextDrawColor(cont_sell, -1);
    TextDrawFont(cont_sell, 4);
    TextDrawSetSelectable(cont_sell, true);

    cont_close = TextDrawCreate(395.600006, 108.515548, "txd:brcontclose");
    TextDrawLetterSize(cont_close, 0.000000, 0.000000);
    TextDrawTextSize(cont_close, 31.199993, 37.333328);
    TextDrawAlignment(cont_close, 1);
    TextDrawColor(cont_close, -1);
    TextDrawFont(cont_close, 4);
    TextDrawSetSelectable(cont_close, true);
    
    for(new cont = 1; cont <= MAX_CONT; cont++) // Цикл для создания текстдравов для каждого контейнера
    {
        cont_name[cont] = TextDrawCreate(294.799987, 121.457778, "by werton");
        TextDrawLetterSize(cont_name[cont], 0.327599, 1.321245);
        TextDrawAlignment(cont_name[cont], 2);
        TextDrawColor(cont_name[cont], -1);
        TextDrawSetOutline(cont_name[cont], 1);
        TextDrawBackgroundColor(cont_name[cont], 51);
        TextDrawFont(cont_name[cont], 1);
        TextDrawSetProportional(cont_name[cont], 1);
        cont_price[cont] = TextDrawCreate(374.399963, 323.057739, "9.999.999 РУБ");
        TextDrawLetterSize(cont_price[cont], 0.307599, 1.236622);
        TextDrawAlignment(cont_price[cont], 2);
        TextDrawColor(cont_price[cont], -1);
        TextDrawSetShadow(cont_price[cont], 0);
        TextDrawSetOutline(cont_price[cont], 1);
        TextDrawBackgroundColor(cont_price[cont], 51);
        TextDrawFont(cont_price[cont], 1);
        TextDrawSetProportional(cont_price[cont], 1);
        
        cont_model[cont] = TextDrawCreate(226.399902, 149.333343, "");
        TextDrawTextSize(cont_model[cont], 175.599990, 165.804412);
        TextDrawColor(cont_model[cont], -1);
        TextDrawUseBox(cont_model[cont], true);
        TextDrawFont(cont_model[cont], 5);
        TextDrawSetPreviewModel(cont_model[cont], 18639);
        TextDrawBackgroundColor(cont_model[cont], 0x00000000);
        TextDrawSetPreviewRot(cont_model[cont], 0.000000, 0.000000, -30.000000, 1.000000);
    }
    return 1;
}

