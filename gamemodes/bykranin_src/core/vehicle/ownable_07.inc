//>> Файл: bykranin_src/core/vehicle/ownable_07.inc  (415 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: HouseImprovementsPrice, IsPlayerInRangeOfHouse, BuyOwnableCarFamily, BuyOwnableCar
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock HouseImprovementsPrice(houseid)
{
	new price;
	new level = GetHouseData(houseid, H_IMPROVEMENTS);

	if(1 <= level <= sizeof g_house_improvements)
	{
		for(new idx; idx < level; idx ++)
		{
			price += g_house_improvements[idx][I_PRICE];
		}
	}
	return price;
}

stock IsPlayerInRangeOfHouse(playerid, houseid, Float: radius = 10.0)
{
	new result;
	if(GetHouseData(houseid, H_ENTRACE) != -1)
	{
		new flatid = GetHouseData(houseid, H_FLAT_ID) % 4;
		result = IsPlayerInRangeOfPoint(playerid, radius, g_entrance_flat_pos[flatid][0], g_entrance_flat_pos[flatid][1], g_entrance_flat_pos[flatid][2]);
	}
					else result = IsPlayerInRangeOfPoint(playerid, radius, GetHouseData(houseid, H_POS_X), GetHouseData(houseid, H_POS_Y), GetHouseData(houseid, H_POS_Z));

	return result;
}

stock BuyOwnableCarFamily(playerid, marketid, ownablecar)
{
	new color_1 = GetPlayerData(playerid, P_AUTOSALON_COLOR1);
	new color_2 = GetPlayerData(playerid, P_AUTOSALON_COLOR2);
	
    HideAutosalonTextDraws(playerid);
	RemovePlayerFromVehicle(playerid);
    new modelid, vehicle_price, query[256];
 	printf("player_cars: %d / player_slots: %d", GetPlayerOwnableCars(playerid), GetPlayerCarSlots(playerid));

	printf("BuyOwnableCar(%d, %d, %d, %d, %d)", playerid, marketid, ownablecar, color_1, color_2);

	if(ownablecar < 1000)
	{
		modelid = car_market_data[marketid][ownablecar][CM_MODELID];
		vehicle_price = car_market_data[marketid][ownablecar][CM_COST];
	}
	else
		modelid = ownablecar - 1000;
	if(!vehicle_price) vehicle_price = GetVehicleInfo(modelid - 400, VI_PRICE);

/*	if(marketid != 0 && marketid != 2)
	{
		if(GetPlayerHouse(playerid, HOUSE_TYPE_HOME) == -1 &&
		GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == -1 &&
		GetPlayerHouse(playerid, HOUSE_TYPE_ROOM) == -1)
		{
			SendClientMessage(playerid, 0xCECECEFF, "Для покупки транспорта этого класса нужно иметь недвижимость");
			return -1;
		}
	}

	if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
	{
		SendClientMessage(playerid, 0xCECECEFF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
		return -1;
	}
	*/
	
	new fam = GetPlayerData(playerid, P_FAMILY) + 1;
	if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в семье");
	
	if(GetPlayerData(playerid, P_FAMILY_RANK) != 10)
		return SendClientMessage(playerid, 0x999999FF, "Вы не глава семьи");
	
	if(GetFamilyData(fam, F_FAMILY_CARS) >= 5) return Send(playerid, -1, "В семье уже нет места для транспорта");
	
	if(GetPlayerMoneyEx(playerid) < vehicle_price)
	{
		SendClientMessage(playerid, 0x999999FF, "Недостаточно денег для покупки транспорта");
		return -1;
	}
	new biz_id;
	if(!AutosalonHasBusinessProducts(playerid, marketid, biz_id)) return -1;

	GivePlayerMoneyEx(playerid, -vehicle_price, "Покупка семейного транспорта", true, true);
	AutosalonUseBusinessProducts(biz_id, playerid, vehicle_price);

  	//TransferCoffersMoney((vehicle_price), "Покупка авто", "", false);

	new buy_cars_count = cars_after_purchase_count[marketid]++;

	new fam_id = GetPlayerData(playerid, P_FAMILY);

	new vehicleid = GetPlayerVehicleID(playerid);

	if(buy_cars_count >= cars_after_purchase_limit[marketid] - 1)
		cars_after_purchase_count[marketid] = 0;

	new Float: pos_x = cars_pos_after_purchase[marketid][buy_cars_count][0];
	new Float: pos_y = cars_pos_after_purchase[marketid][buy_cars_count][1];
	new Float: pos_z = cars_pos_after_purchase[marketid][buy_cars_count][2];
	new Float: angle = cars_pos_after_purchase[marketid][buy_cars_count][3];

	new Cache: result,
		idx;

	idx = GetFreeFamilyCarID();

    SetFamilyCarData(idx, F_OWNER_ID,     GetPlayerAccountID(playerid));

    SetFamilyCarData(idx, F_MODEL_ID,     modelid);
    SetFamilyCarData(idx, F_COLOR_1,      color_1);
    SetFamilyCarData(idx, F_COLOR_2,      color_2);

    SetFamilyCarData(idx, F_POS_X,        pos_x);
    SetFamilyCarData(idx, F_POS_Y,        pos_y);
    SetFamilyCarData(idx, F_POS_Z,        pos_z);
    SetFamilyCarData(idx, F_ANGLE,        angle);

    SetOwnableCarData(idx, OC_KEY_IN,       false);

    SetOwnableCarData(idx, OC_CREATE,       gettime());

    // ----------------------------------------------------------------------------------------

    g_family_car[idx][F_CAR_ID] = CreateVehicle
    (
        GetFamilyCarData(idx, F_MODEL_ID),
        GetFamilyCarData(idx, F_POS_X),
        GetFamilyCarData(idx, F_POS_Y),
        GetFamilyCarData(idx, F_POS_Z),
        GetFamilyCarData(idx, F_ANGLE),
        GetFamilyCarData(idx, F_COLOR_1),
        GetFamilyCarData(idx, F_COLOR_2),
        -1,
        0,
        VEHICLE_ACTION_TYPE_FAMILY_CAR,
        idx
    );
    if(GetFamilyCarData(idx, F_CAR_ID) != INVALID_VEHICLE_ID)
    {
        CreateVehicleLabel(GetFamilyCarData(idx, F_CAR_ID), GetFamilyData(fam_id, F_NAME), 0x6666CCEE, 0.0, 0.0, 1.3, 20.0);
        SetVehicleParam(GetFamilyCarData(idx, F_CAR_ID), V_LOCK, false);

        SetVehicleData(GetFamilyCarData(idx, F_CAR_ID), V_MILEAGE, 0.0);
        SetVehicleData(GetFamilyCarData(idx, F_CAR_ID), V_FUEL, 50.0);
    }
    format
    (
        query, sizeof query,
        "INSERT INTO family_cars \
        (owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) \
        VALUES \
        ('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
        fam_id,
        GetFamilyCarData(idx, F_MODEL_ID),
        GetFamilyCarData(idx, F_COLOR_1),
        GetFamilyCarData(idx, F_COLOR_2),
        GetFamilyCarData(idx, F_POS_X),
        GetFamilyCarData(idx, F_POS_Y),
        GetFamilyCarData(idx, F_POS_Z),
        GetFamilyCarData(idx, F_ANGLE),
        gettime()
    );

    result = mysql_query(mysql, query, true);
    printf("%s",query);

    SetFamilyCarData(idx, F_SQL_ID, cache_insert_id());
    cache_delete(result);

	SaveFamilyCar(vehicleid);
	
	fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
	new fmt_text[120];
	
	AddFamilyData(fam_id,F_FAMILY_CARS,+,1);
	
	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET family_cars='%d' WHERE id='%d' LIMIT 1", GetFamilyData(fam_id, F_FAMILY_CARS), fam_id);
 	mysql_query(mysql, fmt_text, false);

	SendClientMessage(playerid, 0x32a44bFF, "Поздравляем с покупкой нового транспорта в семью!");
    SendClientMessage(playerid, 0x1E90FFFF, "Документы на транспорт будут оформлены в течении нескольких минут");

    return 1;
}

stock BuyOwnableCar(playerid, marketid, ownablecar)
{
    if(GetPVarInt(playerid, "autosalon_buy_lock") > gettime())
        return 1;
    SetPVarInt(playerid, "autosalon_buy_lock", gettime() + 2);

    SyncAutosalonSelectedColors(playerid);
    new color_1 = buy_car_select_color[playerid][0];
    new color_2 = buy_car_select_color[playerid][1];
    if(!(0 <= color_1 <= MAX_COLOR_ID)) color_1 = GetPlayerData(playerid, P_AUTOSALON_COLOR1);
    if(!(0 <= color_2 <= MAX_COLOR_ID)) color_2 = GetPlayerData(playerid, P_AUTOSALON_COLOR2);
    SetPlayerData(playerid, P_AUTOSALON_COLOR1, color_1);
    SetPlayerData(playerid, P_AUTOSALON_COLOR2, color_2);
    buy_car_select_color[playerid][0] = color_1;
    buy_car_select_color[playerid][1] = color_2;

	printf("player_cars: %d / player_slots: %d", GetPlayerOwnableCars(playerid), GetPlayerCarSlots(playerid));

	printf("BuyOwnableCar(%d, %d, %d, %d, %d)", playerid, marketid, ownablecar, color_1, color_2);

	if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
	{
		SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
		return -1;
	}
	
	if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
	{
		SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
		return -1;
	}
	
	new modelid, vehicle_price;

	if(ownablecar < 1000)
	{
		modelid = car_market_data[marketid][ownablecar][CM_MODELID];
		vehicle_price = car_market_data[marketid][ownablecar][CM_COST];
	}
	else
		modelid = ownablecar - 1000;
	if(!vehicle_price) vehicle_price = GetVehicleInfo(modelid - 400, VI_PRICE);

	printf("modelid = %d | ownablecar = %d", modelid, ownablecar);

	if(modelid <= 0)
		return -1;

	if(!AutosalonHasVehicleSlots(marketid, modelid))
	{
		ShowNotificationNew(playerid, 2, 6, 0, 0, "Данной машины нет в наличии", " ");
		return -1;
	}
/*if(marketid != 0 && marketid != 2)
	{
		if(GetPlayerHouse(playerid, HOUSE_TYPE_HOME) == -1 &&
		GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == -1 &&
		GetPlayerHouse(playerid, HOUSE_TYPE_ROOM) == -1)
		{
			SendClientMessage(playerid, 0x999999FF, "Для покупки транспорта этого класса нужно иметь недвижимость");
			return -1;
		}
	}*/


	if(GetPlayerMoneyEx(playerid) < vehicle_price)
	{
		SendClientMessage(playerid, -1, "{E0584B} {FFFFFF} У вас недостаточно денежных средств для покупки данного транспортного средства.");
		return -1;
	}
	new biz_id;
	if(!AutosalonHasBusinessProducts(playerid, marketid, biz_id)) return -1;

	new idx = GetFreeOwnableCarID();
	if(idx == -1)
	{
		SendClientMessage(playerid, 0x999999FF, "Нет свободных слотов транспорта на сервере");
		return -1;
	}

	new autosalon_slot_modelid;
	if(!AutosalonTakeVehicleSlot(marketid, modelid, autosalon_slot_modelid))
	{
		ShowNotificationNew(playerid, 2, 6, 0, 0, "Данной машины нет в наличии", " ");
		return -1;
	}
    HideAutosalonTextDraws(playerid);
	ExitPlayerBuyCarMarket(playerid);
	GivePlayerMoneyEx(playerid, -vehicle_price, "Покупка ТС в автосалоне", true, true);
	AutosalonUseBusinessProducts(biz_id, playerid, vehicle_price);

	new buy_cars_count = cars_after_purchase_count[marketid]++;

	if(buy_cars_count >= cars_after_purchase_limit[marketid] - 1)
		cars_after_purchase_count[marketid] = 0;

	new Float: pos_x = cars_pos_after_purchase[marketid][buy_cars_count][0];
	new Float: pos_y = cars_pos_after_purchase[marketid][buy_cars_count][1];
	new Float: pos_z = cars_pos_after_purchase[marketid][buy_cars_count][2];
	new Float: angle = cars_pos_after_purchase[marketid][buy_cars_count][3];

	new query[512],
		Cache: result;

	SetOwnableCarData(idx, OC_OWNER_ID, 	GetPlayerAccountID(playerid));

	SetOwnableCarData(idx, OC_MODEL_ID, 	modelid);
	SetOwnableCarData(idx, OC_COLOR_1, 		color_1);
	SetOwnableCarData(idx, OC_COLOR_2, 		color_2);
    SetOwnableCarData(idx, OC_body_colors,     0);
    SetOwnableCarData(idx, OC_wheelcolors,     0);

	SetOwnableCarData(idx, OC_POS_X, 		pos_x);
	SetOwnableCarData(idx, OC_POS_Y, 		pos_y);
	SetOwnableCarData(idx, OC_POS_Z, 		pos_z);
	SetOwnableCarData(idx, OC_ANGLE, 		angle);

	strmid(g_ownable_car[idx][OC_NUMBER], "------", 0, 8, 8);

	SetOwnableCarData(idx, OC_ALARM, 		false);
	SetOwnableCarData(idx, OC_KEY_IN, 		false);

	SetOwnableCarData(idx, OC_CREATE, 		gettime());

	format(g_ownable_car[idx][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));
	// ----------------------------------------------------------------------------------------

	new vehicleid = CreateVehicle
	(
		GetOwnableCarData(idx, OC_MODEL_ID),
		GetOwnableCarData(idx, OC_POS_X),
		GetOwnableCarData(idx, OC_POS_Y),
		GetOwnableCarData(idx, OC_POS_Z),
		GetOwnableCarData(idx, OC_ANGLE),
		GetOwnableCarData(idx, OC_COLOR_1),
		GetOwnableCarData(idx, OC_COLOR_2),
		-1,
		0,
		VEHICLE_ACTION_TYPE_OWNABLE_CAR,
		idx
	);
	if(vehicleid != INVALID_VEHICLE_ID)
	{
		//CreateVehicleLabel(vehicleid, GetOwnableCarData(idx, OC_NUMBER), 0xFFFF00EE, 0.0, 0.0, 1.3, 20.0);
		//index = GetVehicleData(vehicleid, V_ACTION_ID);
        format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
        SetVehicleColor(vehicleid, GetVehicleRGBAColorById(color_1), GetVehicleRGBAColorById(color_2), 1);
        ChangeVehicleColor(vehicleid, color_1, color_2);
        ApplyOwnableCarStoredPlate(vehicleid, idx);
		SetVehicleParam(vehicleid, V_LOCK, false);

		SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
	}

	SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);

	format
	(
		query, sizeof query,
		"INSERT INTO ownable_cars \
		(owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time,body_colors,wheel_colors) \
		VALUES \
		('%d','%d','%d','%d','%f','%f','%f','%f','%d','0','0')",
		GetPlayerAccountID(playerid),
		modelid,
		color_1,
		color_2,
		pos_x,
		pos_y,
		pos_z,
		angle,
		gettime()
	);
	result = mysql_query(mysql, query, true);

		if(mysql_errno())
	{
		AutosalonAddVehicleSlot(marketid, autosalon_slot_modelid, 1);
		GivePlayerMoneyEx(playerid, vehicle_price, "Возврат за покупку ТС", true, true);
		if(vehicleid != INVALID_VEHICLE_ID)
			DestroyVehicle(vehicleid);

		SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
		SetOwnableCarData(idx, OC_OWNER_ID, 0);
		SetOwnableCarData(idx, OC_MODEL_ID, 0);
		SetOwnableCarData(idx, OC_COLOR_1, 0);
		SetOwnableCarData(idx, OC_COLOR_2, 0);
		SetOwnableCarData(idx, OC_POS_X, 0.0);
		SetOwnableCarData(idx, OC_POS_Y, 0.0);
		SetOwnableCarData(idx, OC_POS_Z, 0.0);
		SetOwnableCarData(idx, OC_ANGLE, 0.0);
		SetOwnableCarData(idx, OC_CREATE, 0);
		cache_delete(result);
		return SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения транспорта в базу данных");
	}
SetOwnableCarData(idx, OC_SQL_ID, cache_insert_id());

	cache_delete(result);

    ShowHud(playerid);
    launch[playerid] = 0;
    diski[playerid] = 0;
    fars[playerid] = 0;
    nitro[playerid] = 0;
	SendClientMessage(playerid, 0x66CC00FF, "{FFFFFF}Для загрузки транспорта воспользуйтесь{ffff00} Меню - Транспорт.");
	SendClientMessage(playerid, 0x66CC00FF, "{FFFFFF}Или воспользуйтесь{ffff00} парковкой.");
	UnloadPlayerOwnableCar(playerid);

	AddPlayerData(playerid, P_QUEST_EXP_5, +, 1);
	UpdatePlayerDatabaseInt(playerid, "quest_exp_5", GetPlayerData(playerid, P_QUEST_EXP_5));

	if(GetPlayerData(playerid, P_QUEST_EXP_5) == 1)
	{
	    SendClientMessage(playerid, COR_SERVER, "{ffffff}Вы успешно выполнили квест {009900}'Первый транспорт'. {ffffff}Ваша награда: {009900}5000 руб, 1exp");
        SendClientMessage(playerid, COR_SERVER, "{ffffff}Введите {009900}/quest{ffffff},для подробной информации по Вашим квестам");
	    GivePlayerMoneyEx(playerid, 10000, "Выполнение квеста");

	    SetPlayerData(playerid, P_QUEST_5, 1);
	    UpdatePlayerDatabaseInt(playerid, "quest_5", 1);
	    
	    AddPlayerData(playerid, P_TOP_5, +, 1);
		UpdatePlayerDatabaseInt(playerid, "TOP_Quest", GetPlayerData(playerid, P_TOP_5));
	}

	return 1;
}

