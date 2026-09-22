//>> Файл: bykranin_src/core/property/property_13.inc  (518 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: GetHouseNewByOwner, GetFlatNewByOwner, FamilySpawnEncodeNewHouse, FamilySpawnEncodeNewFlat, FamilySpawnIsNewFlat, FamilySpawnDecodeNewFlat, FamilySpawnIsNewHouse
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock GetHouseNewByOwner(accountsid, playerid)
{
    new selected = GetPlayerData(playerid, P_HOUSE_SELECTED);
    new bool:is_flat;
    new property_id = DecodeSelectedHouseProperty(selected, is_flat);

    if(!is_flat && 0 <= property_id < HOUSES_FOR_SALE_COUNT)
    {
        if(gHouseOwned[property_id] && gHouseOwnerID[property_id] == accountsid)
            return property_id;
    }

    for(new i = 0; i < HOUSES_FOR_SALE_COUNT; i++)
    {
        if(!gHouseOwned[i]) continue;
        if(gHouseOwnerID[i] != accountsid) continue;

        SetPlayerData(playerid, P_HOUSE_SELECTED, EncodeSelectedHouseProperty(false, i));
        return i;
    }

    return -1;
}
stock GetFlatNewByOwner(accountsid, playerid)
{
    new selected = GetPlayerData(playerid, P_HOUSE_SELECTED);
    new bool:is_flat;
    new property_id = DecodeSelectedHouseProperty(selected, is_flat);

    if(is_flat && 0 <= property_id < 200000)
    {
        if(gFlatOwned[property_id] && gFlatOwnerID[property_id] == accountsid)
            return property_id;
    }

    for(new i = 0; i < 200000; i++)
    {
        if(!gFlatOwned[i]) continue;
        if(gFlatOwnerID[i] != accountsid) continue;

        SetPlayerData(playerid, P_HOUSE_SELECTED, EncodeSelectedHouseProperty(true, i));
        return i;
    }

    return -1;
}

stock FamilySpawnEncodeNewHouse(houseid)
{
    return -(houseid + 2);
}

#define FAMILY_SPAWN_FLAT_BASE (1000000)

stock FamilySpawnEncodeNewFlat(flatid)
{
    return -(FAMILY_SPAWN_FLAT_BASE + flatid + 2);
}

stock bool:FamilySpawnIsNewFlat(value)
{
    return value <= -(FAMILY_SPAWN_FLAT_BASE + 2);
}

stock FamilySpawnDecodeNewFlat(value)
{
    return -value - FAMILY_SPAWN_FLAT_BASE - 2;
}

stock bool:FamilySpawnIsNewHouse(value)
{
    return value <= -2 && !FamilySpawnIsNewFlat(value);
}

stock FamilySpawnFindFlatByRealId(real_flat_id)
{
    for(new flatid; flatid < 200000; flatid++)
    {
        if(gFlatOwned[flatid] && g_flat_real_id[flatid] == real_flat_id) return flatid;
    }
    return -1;
}

stock FamilySpawnDecodeNewHouse(value)
{
    return -value - 2;
}

stock ApplyDefaultSpawnSelection(playerid)
{
	new Float:case_1_spawns[][4] =
	{
		{846.602600, 796.555847, 13.400512, 69.896881},
		{2740.712158, -2441.565185, 21.774286, 269.248382},
		{-2429.236083, 203.175277, 26.096101, 176.712112},
		{1801.694091, 2523.137695, 14.602633, 109.981643},
		{-2667.526611, 2006.567016, 11.197804, 176.496978},
		{-2159.371093, 1558.103271, 9.840852, 84.519485}
	};
	new spawn_index = random(sizeof(case_1_spawns));

	SetPlayerSpawnSetting(playerid, 0);
	UpdatePlayerDatabaseInt(playerid, "setting_spawn", 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetSpawnInfo(
		playerid,
		0,
		GetPlayerSkinEx(playerid),
		case_1_spawns[spawn_index][0],
		case_1_spawns[spawn_index][1],
		case_1_spawns[spawn_index][2],
		case_1_spawns[spawn_index][3],
		0, 0, 0, 0, 0, 0
	);
	return 1;
}

stock SRAdmin_OpenAfterSpawnSelection(playerid)
{
	if(!IsPlayerLogged(playerid)) return 0;
	if(GetPlayerAdminEx(playerid) <= 0 || GetPlayerData(playerid, P_ADMIN_LOGGED)) return 1;
	printf("[ADMIN] Opening PIN after spawn selection player=%d account=%d", playerid, GetPlayerAccountID(playerid));
	return AdminAuthorization(playerid);
}


stock SellPlayerHouseNew(playerid, houseid)
{
    if (!gHouseOwned[houseid])
        return SendClientMessage(playerid, -1, "Этот дом никому не принадлежит!");

    new accid = GetPlayerAccountID(playerid);
    if (gHouseOwnerID[houseid] != accid)
        return SendClientMessage(playerid, -1, "Это не ваш дом!");

    new h = GetHouseData(gHouseType[houseid]);
    new sell_price = (HouseData[h][hPrice] * 2) / 3; // 66.6% of price without float bug

    SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) + sell_price);
    UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
    GivePlayerMoney(playerid, sell_price);

    gHouseOwned[houseid] = false;
    gHouseOwnerID[houseid] = 0;
    gHouseRentTime[houseid] = 0;
    format(gHouseOwner[houseid], 24, "Nobody");
	new prices = 0;
	if (g_house_new_apt[houseid]){
		prices += 33000;
	}
	if (g_house_new_remont[houseid]){
		prices += 6000000;
	}
	if (g_house_new_shkaf[houseid]){
		prices += 36000;
	}
	SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) + prices);
    UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
    GivePlayerMoney(playerid, prices);
	g_house_new_apt[houseid] = 0;
	g_house_new_remont[houseid] = 0;
	g_house_new_shkaf[houseid] = 0;
	SetPlayerData(playerid, P_HOUSE_SELECTED, 0); 
	UpdatePlayerDatabaseInt(playerid, "house_selected", GetPlayerData(playerid, P_HOUSE_SELECTED));
    new query[256];
    format(query, sizeof(query),
        "DELETE FROM bought_houses WHERE house_id = %d AND account_id = %d",
        houseid, accid
    );
    mysql_tquery(mysql, query);

    DestroyPickup(gHouseSalePickup[houseid]);
    gHouseSalePickup[houseid] = CreatePickup(
        1273,
        PICKUP_TYPE_DEFAULT,
        gHousesForSale[houseid][0],
        gHousesForSale[houseid][1],
        gHousesForSale[houseid][2],
        0,
        PICKUP_ACTION_TYPE_HOUSE_NEW,
        houseid
    );

    new fmt[1024];
    format(fmt, sizeof fmt, "Налог за продажу дома составил 30 процентов от его стоимости {40ad58}(%d руб)", HouseData[h][hPrice]/3);
    SendClientMessage(playerid, -1, fmt);
	format(fmt, sizeof fmt, "Вам было возвращено 60 процентов от стоимости купленных улучшений: {8de645}%d руб", prices);
    SendClientMessage(playerid, -1, fmt);
    return 1;
}

stock BuyHouse(playerid, houseid)
{
    if (gHouseOwned[houseid])
        return SendClientMessage(playerid, -1, "Дом уже куплен!");
	new h = GetHouseData(gHouseType[houseid]);

	if(GetPlayerMoneyEx(playerid) < HouseData[h][hPrice])
	{
		new fmt[128];
		format(fmt, sizeof fmt, "Недостаточно денег для покупки. Нужно: %d руб", HouseData[h][hPrice]);
		return SendClientMessage(playerid, -1, fmt);
	}

	
    new accid = GetPlayerAccountID(playerid);

	if (!CanPlayerBuyProperty(playerid))
	    return 0;
	
	SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - HouseData[h][hPrice]);
    UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
				
    GivePlayerMoney(playerid, -HouseData[h][hPrice]);
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));


    gHouseOwned[houseid] = true;
    gHouseOwnerID[houseid] = accid;
    gHouseRentTime[houseid] = GetNewPropertyStartRentTime();
    format(gHouseOwner[houseid], 24, "%s", name);

    // Новый купленный дом сразу становится выбранной недвижимостью.
    SetPlayerData(playerid, P_HOUSE_SELECTED, EncodeSelectedHouseProperty(false, houseid));
    UpdatePlayerDatabaseInt(playerid, "house_selected", GetPlayerData(playerid, P_HOUSE_SELECTED));

    new query[256];
    format(query, sizeof(query),
        "INSERT INTO bought_houses (house_id, account_id, owner_name, is_open, remont, apt, shkaf, kv, rent_time) VALUES (%d, %d, '%s', 1, 0, 0, 0, 0, %d)",
        houseid, accid, name, gHouseRentTime[houseid]
    );
    mysql_tquery(mysql, query);
	DestroyPickup(gHouseSalePickup[houseid]);
    gHouseSalePickup[houseid] = CreatePickup(
        (gHouseOwned[houseid] ? 1272 : 1273),
        PICKUP_TYPE_DEFAULT,
        gHousesForSale[houseid][0],
        gHousesForSale[houseid][1],
        gHousesForSale[houseid][2],
        0,
        PICKUP_ACTION_TYPE_HOUSE_NEW,
        houseid
    );
	ShowNewPropertyPurchaseSuccess(playerid, HouseData[h][hPrice]);

    return EnterPlayerToHouseNew(playerid, houseid);
}

stock CreateSaleHousePickups(worldid = -1)
{
	CreateDynamic3DTextLabel("{3399ff}Подойдите ближе для\n взаимодействия c выходом", 0x3399FFFF, 294.716125,2139.311523,1765.464111 - 0.8, 8.0);
	CreateDynamic3DTextLabel("{3399ff}Подойдите ближе для\n взаимодействия c выходом", 0x3399FFFF, 994.7635,2021.9585,1561.0112 - 0.8, 8.0);
	CreateDynamic3DTextLabel("{3399ff}Подойдите ближе для\n взаимодействия c выходом", 0x3399FFFF,  2491.4910,1003.5193,1499.5813 - 0.8, 8.0);
	
	for (new i = 0; i < HOUSES_FOR_SALE_COUNT; i++)
    {
		
        
		gHouseType[i] = 0;

        if (gHousesForSale[i][0] < -194.0 && gHousesForSale[i][0] > -493.0 &&
            gHousesForSale[i][1] > 1214.0 && gHousesForSale[i][1] < 1631.0)
        {
            gHouseType[i] = 1;
        }
        else if (gHousesForSale[i][0] < 594.0 && gHousesForSale[i][0] > 255.0 &&
                 gHousesForSale[i][1] > 228.0 && gHousesForSale[i][1] < 404.0)
        {
            gHouseType[i] = 2;
        }
        else if (gHousesForSale[i][0] < -2604.0 && gHousesForSale[i][0] > -2802.0 &&
                 gHousesForSale[i][1] > -1246.0 && gHousesForSale[i][1] < -534.0)
        {
            gHouseType[i] = 3;
        }
        else if (gHousesForSale[i][0] < -859.0 && gHousesForSale[i][0] > -2237.0 &&
                 gHousesForSale[i][1] > 35.0 && gHousesForSale[i][1] < 857.0)
        {
            gHouseType[i] = 4;
        }
        

		new h = GetHouseData(gHouseType[i]);
		
		CreatePickup(
            1,
            PICKUP_TYPE_DEFAULT,
            HouseData[h][hEnterX],
            HouseData[h][hEnterY],
            HouseData[h][hEnterZ],
            i,
            PICKUP_ACTION_TYPE_EXIT_HOME,
            i
        );
		CreatePickup(
            19198,
            PICKUP_TYPE_DEFAULT,
            499.776550, 2496.206298, 1503.646240,
            i,
            PICKUP_ACTION_TYPE_EXIT_BASEMENT,
            i
        );
        gHouseSalePickup[i] = CreatePickup(
            (gHouseOwned[i] ? 1272 : 1273),
            PICKUP_TYPE_DEFAULT,
            gHousesForSale[i][0],
            gHousesForSale[i][1],
            gHousesForSale[i][2],
            0,
            PICKUP_ACTION_TYPE_HOUSE_NEW,
            i
        );
		if (g_house_new_apt[i]){
            CreatePickup(
                1240,
                PICKUP_TYPE_DEFAULT,
                HouseData[h][hMedX],
                HouseData[h][hMedY],
                HouseData[h][hMedZ],
                i,
                PICKUP_ACTION_TYPE_HOUSE_MED,
                i
            );
		}
		if (g_house_new_shkaf[i]){
			CreateDynamic3DTextLabel("{DFB941}Шкаф", 0xDFB941FF,
                               HouseData[h][hWardrobeX],
                               HouseData[h][hWardrobeY],
                               HouseData[h][hWardrobeZ],
                               10.0,
                               INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, i, 1
                           );
		}
		
    }
    return 1;
}
stock ShowPlayerLiftInfo(playerid, houseid)
{
    new fmt_str[2024], status_line[1024], floor_line[1024];

    format(status_line, sizeof(status_line), "{FFFF00}Выберите этаж");
    fmt_str[0] = '\0';

    new currentFloor = (GetPlayerVirtualWorld(playerid) - houseid) / (FLATS_FOR_SALE_COUNT + 1) + 1;

    if (GetPlayerVirtualWorld(playerid) == 0)
    {
        currentFloor = 0;
    }

    for (new i = 1; i <= gFlatFloors[houseid]; i++)
    {
        if (i == currentFloor) continue;

        format(floor_line, sizeof(floor_line), "{FFFFFF}%d этаж\n", i);
        strcat(fmt_str, floor_line);
    }

    SetPVarInt(playerid, "lift_dialog_active", 1);
    SetPVarInt(playerid, "hnew_pickup_id", houseid);
    SetPVarInt(playerid, "hnew_current_floor", currentFloor);

    Dialog(playerid, DIALOG_FLAT_CHOOSE_FLOOR, DIALOG_STYLE_LIST, status_line, fmt_str, "Выбрать", "Отмена");
    return 1;
}

stock ShowPlayerHouseExitPickupDialog(playerid, houseid)
{
	new fmt_str[640], type_name[32], owner_str[40], status_line[48], rooms;
	new h = GetHouseData(gHouseType[houseid]);

	
	format(status_line, sizeof status_line, "{E0584B}{SERVER_NAME} -> {ffffff}Выберите");
	format(fmt_str, sizeof fmt_str,
	    "{FFFFFF}Выйти на улицу"
	);
	if (gHouseType[houseid] == 0){
		format(fmt_str, sizeof fmt_str,
	        "{FFFFFF}Выйти на улицу\n" \
	    	"{FFFFFF}Спуститься в подвал"
	    );
	}
	SetPVarInt(playerid, "hnew_pickup_id", houseid);
	Dialog(playerid, DIALOG_HOUSE_NEW_PICKUPS, DIALOG_STYLE_LIST, status_line, fmt_str, "Выбрать", "Отмена");
	
   
	return 1;
}
stock HandleExitPlayerFlatNewPickup(playerid, houseid){
	new currentFloor = (GetPlayerVirtualWorld(playerid) - houseid) / (FLATS_FOR_SALE_COUNT + 1) + 1;
	if (currentFloor > 1){
		if (GetPVarInt(playerid, "lift_dialog_active")) return 1;
		if (GetTickCount() < gPlayerPickupCooldowns[playerid]) return 1;
		ShowPlayerLiftInfo(playerid, houseid);
		return 1;
	}
	SetPlayerPosEx(
	 	playerid,
	 	gFlatsForSale[houseid][0],
		gFlatsForSale[houseid][1],
		gFlatsForSale[houseid][2],
	 	90,
	 	0,
	 	0
	);
	Streamer_Update(playerid);
}
stock ShowPlayerBasementExitPickupDialog(playerid, houseid)
{
	new fmt_str[640], type_name[32], owner_str[40], status_line[48], rooms;
	new h = GetHouseData(gHouseType[houseid]);

	
	format(status_line, sizeof status_line, "{E0584B}{SERVER_NAME} -> {ffffff}Выберите");
	format(fmt_str, sizeof fmt_str,
	    "{FFFFFF}Выйти в дом"
	);
	
	SetPVarInt(playerid, "hnew_pickup_id", houseid);
	Dialog(playerid, DIALOG_HOUSE_NEW_PICKUPSS, DIALOG_STYLE_LIST, status_line, fmt_str, "Выбрать", "Отмена");
	
   
	return 1;
}

stock ShowPlayerHouseNewPickupDialog(playerid, houseid)
{
	new fmt_str[640], type_name[32], owner_str[40], status_line[48], rooms;
	new h = GetHouseData(gHouseType[houseid]);
	if(gHouseOwned[houseid])
	{
		format(owner_str, sizeof owner_str, "{00CC66}%s", gHouseOwner[houseid]);
		format(status_line, sizeof status_line, "{E0584B}Дом занят");
		format(fmt_str, sizeof fmt_str,
		    "{FFFFFF}Название\t{FFFFFF}Информация\n"\
		    "{FFFFFF}Владелец:\t%s\n"\
		    "{FFFFFF}Тип:\t{00CC66}%s\n"\
		    "{FFFFFF}Номер дома:\t{00CC66}%d\n"\
		    "{FFFFFF}Количество комнат:\t{00CC66}%d\n"\
		    "{FFFFFF}Стоимость:\t{00CC66}%d руб\n"\
		    "{FFFFFF}Ежедневная квартплата:\t{00CC66}%d руб",
		    owner_str,
		    HouseData[h][hName],
		    houseid + 3000,
		    HouseData[h][hRooms],
		    HouseData[h][hPrice],
			HouseData[h][hPriceP]
	    );
		SetPVarInt(playerid, "hnew_pickup_id", houseid);
	    Dialog(playerid, DIALOG_HOUSE_NEW_PICKUP, DIALOG_STYLE_TABLIST_HEADERS, status_line, fmt_str, "Войти", "Отмена");
	}
    else
	{
		format(status_line, sizeof status_line, "{66CC66}Дом свободен");
		format(fmt_str, sizeof fmt_str,
		    "{FFFFFF}Название\t{FFFFFF}Информация\n"\
		    "{FFFFFF}Тип:\t{00CC66}%s\n"\
		    "{FFFFFF}Номер дома:\t{00CC66}%d\n"\
		    "{FFFFFF}Количество комнат:\t{00CC66}%d\n"\
		    "{FFFFFF}Стоимость:\t{00CC66}%d руб\n"\
		    "{FFFFFF}Ежедневная квартплата:\t{00CC66}%d руб",
		    HouseData[h][hName],
		    houseid + 3000,
		    HouseData[h][hRooms],
		    HouseData[h][hPrice],
			HouseData[h][hPriceP]
	    );
		SetPVarInt(playerid, "hnew_pickup_id", houseid);
	    Dialog(playerid, DIALOG_HOUSE_NEW_PICKUP, DIALOG_STYLE_TABLIST_HEADERS, status_line, fmt_str, "Купить", "Отмена");
	}
	return 1;
}


stock CreateAllSaleRealtyPickups(worldid = -1)
{
    
    CreateSaleHousePickups(worldid);
	CreateSaleFlatPickups(worldid);
    return 1;
}

stock DestroySaleFlatPickups()
{
    for (new i = 0; i < FLATS_FOR_SALE_COUNT; i++)
    {
        if (gFlatSalePickup[i] != 0)
        {
            DestroyPickup(gFlatSalePickup[i]);
            gFlatSalePickup[i] = 0;
        }
    }
    return 1;
}

stock DestroySaleHousePickups()
{
    for (new i = 0; i < HOUSES_FOR_SALE_COUNT; i++)
    {
        if (gHouseSalePickup[i] != 0)
        {
            DestroyPickup(gHouseSalePickup[i]);
            gHouseSalePickup[i] = 0;
        }
    }
    return 1;
}

stock DestroyAllSaleRealtyPickups()
{
    DestroySaleHousePickups();
    return 1;
}

