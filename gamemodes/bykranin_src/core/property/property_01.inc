//>> Файл: bykranin_src/core/property/property_01.inc  (783 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: LoadHotels, LoadLeaderList, LoadGift, LoadHouses, LoadSettings, LoadHousesRenters, HouseRenterInit
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: LoadHotels()
{
	new query[64], idx;
	new Cache: result, rows;
	new hotel_id, room_id;

	result = mysql_query(mysql, "SELECT h.*, IFNULL(a.name, 'None') AS owner_name FROM hotels h LEFT JOIN accounts a ON a.id = h.owner_id ORDER BY h.hotel_id ASC, h.id ASC", true);
	rows = cache_num_rows(result);

	if(rows > MAX_HOTELS * MAX_HOTEL_ROOMS)
	{
		rows = MAX_HOTELS * MAX_HOTEL_ROOMS;
		print("[Hotels]: DB rows > MAX_HOTELS * MAX_HOTEL_ROOMS");
	}

	for(idx = 0; idx < rows; idx ++)
	{
		hotel_id = cache_get_field_content_int(idx, "hotel_id");
		if(0 <= hotel_id <= MAX_HOTELS-1)
		{
			room_id = g_hotel_rooms_loaded[hotel_id];
			if(0 <= room_id <= MAX_HOTEL_ROOMS-1)
			{
				SetHotelData(hotel_id, room_id, H_SQL_ID, 		cache_get_field_content_int(idx, "id"));
				SetHotelData(hotel_id, room_id, H_OWNER_ID, cache_get_field_content_int(idx, "owner_id"));
				SetHotelData(hotel_id, room_id, H_RENT_DATE, 	cache_get_field_content_int(idx, "rent_time"));
				SetHotelData(hotel_id, room_id, H_STATUS, 		bool: cache_get_field_content_int(idx, "status"));

				cache_get_field_content(idx, "owner_name", g_hotel[hotel_id][room_id][H_OWNER_NAME], mysql, 21);

				// ----------------------------------------------------------------------------------------------
				if(IsHotelRoomOwned(hotel_id, room_id) && !strcmp(GetHotelData(hotel_id, room_id, H_OWNER_NAME), "None", true))
				{
					SetHotelData(hotel_id, room_id, H_OWNER_ID, 0);

					mysql_format(mysql, query, sizeof query, "UPDATE hotels SET owner_id=0 WHERE id=%d LIMIT 1", GetHotelData(hotel_id, room_id, H_SQL_ID));
					mysql_query(mysql, query, false);
				}

				if(!IsHotelRoomOwned(hotel_id, room_id))
				{
					SetHotelData(hotel_id, room_id, H_STATUS, false);
				}
				g_hotel_rooms_loaded[hotel_id] ++;
			}
		}
	}
	cache_delete(result);

	// ----------------------------------
	CreatePickup(1318, 23, 733.0804, 599.6274, 1002.9598, -1);
	CreatePickup(1318, 23, 1276.0054, -776.3987, 1202.7220, -1);

	g_hotel_lift_CP[0] = CreateDynamicCP(733.0804, 599.6274, 1002.9598, 1.0, _, _, _, 5.0);
	g_hotel_lift_CP[1] = CreateDynamicCP(1276.0054, -776.3987, 1202.722, 1.0, _, _, _, 5.0);

	// ----------------------------------
	new
		Float: p_pos_x = 1273.2,
		Float: p_pos_y = -778.3146,
		Float: p_pos_z = 1202.7220;

	for(idx = 0; idx < 12; idx ++)
	{
		if(!(idx & 1))
		{
			p_pos_y += 4.0,
			p_pos_x += 5.7;
		}
					else p_pos_x -= 5.7;

		CreatePickup(19197, 23, p_pos_x, p_pos_y, p_pos_z, -1, PICKUP_ACTION_TYPE_HOTEL_ROOM, idx);

		format(query, sizeof query, "Комната\n{FFFFFF}Номер: %d", idx + 1);
		CreateDynamic3DTextLabel(query, 0x3399FFFF, p_pos_x, p_pos_y, p_pos_z + 1.4, 6.0);
	}

	for(idx = 0; idx < MAX_HOTEL_FLOORS; idx ++)
	{
		format(query, sizeof query, "Этаж: %d", idx + 1);
		CreateDynamic3DTextLabel(query, 0xFFCD00FF, 1276.0054, -776.3987, 1202.722 + 1.7, 8.0, _, _, _, _, idx + 1);
	}

	// ----------------------------------
	for(idx = 0; idx < MAX_HOTELS; idx ++)
	{
		if(g_hotel_rooms_loaded[idx])
		{
			g_hotel_loaded ++;
		}
	}
	printf("[Hotels]: Отелей загружено: %d / Номеров: %d", g_hotel_loaded, rows);
}

public: LoadLeaderList()
{
	new idx, frac_id;
	new Cache: result, rows;

	result = mysql_query(mysql, "SELECT * FROM `leaders`", true);
	rows = cache_num_rows(result);

	if(rows > MAX_ORG)
	{
		rows = MAX_ORG;
		print("[Leader List]: DB rows > MAX_ORG");
	}

	for(idx = 0; idx < rows; idx ++)
	{
		frac_id = cache_get_field_content_int(idx, "frac_id");
		cache_get_field_content(idx, "name", g_organization[frac_id][O_LEADER], mysql, 64);

		// -------------------------
	}
	printf("[Leader List]: Лидеров загружено: %d", rows);
	cache_delete(result);
}

public: LoadGift()
{
	new idx;
	//new query[85];
	new Cache: result, rows;

	result = mysql_query(mysql, "SELECT * FROM gift", true);
	rows = cache_num_rows(result);

	if(rows > MAX_GIFT)
	{
		rows = MAX_GIFT;
		print("[Gift]: DB rows > MAX_GIFT");
	}


	for(idx = 0; idx < rows; idx ++)
	{
		SetGiftData(idx, G_SQL_ID, 		cache_get_field_content_int(idx, "id"));

		SetGiftData(idx, G_POS_X,		cache_get_field_content_float(idx, "x"));
		SetGiftData(idx, G_POS_Y,		cache_get_field_content_float(idx, "y"));
		SetGiftData(idx, G_POS_Z,		cache_get_field_content_float(idx, "z"));

	 	CreatePickup
		(
			1279,
			23,
			g_gift[idx][G_POS_X], g_gift[idx][G_POS_Y], g_gift[idx][G_POS_Z],
			-1,
			PICKUP_ACTION_TYPE_GIFT,
			idx
		);
	}


	g_gift_loaded = rows;
	cache_delete(result);

    printf("[Gift]: Подарки: %d", g_gift_loaded);
}

public: LoadHouses()
{
	new idx;
	new query[85], buffer[2];
	new Cache: result, rows;

	// result = mysql_query(mysql, "SELECT h.*, IFNULL(a.name, 'None') owner_name FROM houses h LEFT JOIN accounts a ON a.id = h.owner_id ORDER BY h.id ASC, h.entrance ASC", true);
	result = mysql_query(mysql, "SELECT h.*, IFNULL(a.name, 'None') owner_name FROM houses h LEFT JOIN accounts a ON a.id=h.owner_id", true);
	rows = cache_num_rows(result);

	if(rows > MAX_HOUSES)
	{
		rows = MAX_HOUSES;
		print("[Houses]: DB rows > MAX_HOUSES");
	}

	for(idx = 0; idx < rows; idx ++)
	{
		SetHouseData(idx, H_SQL_ID, 		cache_get_field_content_int(idx, "id"));
		SetHouseData(idx, H_OWNER_ID, cache_get_field_content_int(idx, "owner_id"));

		cache_get_field_content(idx, "name", g_house[idx][H_NAME], mysql, 20);

		SetHouseData(idx, H_IMPROVEMENTS,	cache_get_field_content_int(idx, "improvements"));

		SetHouseData(idx, H_RENT_DATE,		cache_get_field_content_int(idx, "rent_time"));
		SetHouseData(idx, H_PRICE,			cache_get_field_content_int(idx, "price"));
		SetHouseData(idx, H_RENT_PRICE,		cache_get_field_content_int(idx, "rent_price"));
		SetHouseData(idx, H_TYPE,			cache_get_field_content_int(idx, "type"));
		SetHouseData(idx, H_ENTRACE,		cache_get_field_content_int(idx, "entrance"));
		SetHouseData(idx, H_LOCK_STATUS,	bool: cache_get_field_content_int(idx, "lock"));

		SetHouseData(idx, H_POS_X,			cache_get_field_content_float(idx, "x"));
		SetHouseData(idx, H_POS_Y,			cache_get_field_content_float(idx, "y"));
		SetHouseData(idx, H_POS_Z,			cache_get_field_content_float(idx, "z"));

		SetHouseData(idx, H_EXIT_POS_X,		cache_get_field_content_float(idx, "exit_x"));
		SetHouseData(idx, H_EXIT_POS_Y,		cache_get_field_content_float(idx, "exit_y"));
		SetHouseData(idx, H_EXIT_POS_Z,		cache_get_field_content_float(idx, "exit_z"));
		SetHouseData(idx, H_EXIT_ANGLE,		cache_get_field_content_float(idx, "exit_angle"));

		SetHouseData(idx, H_CAR_POS_X,		cache_get_field_content_float(idx, "car_x"));
		SetHouseData(idx, H_CAR_POS_Y,		cache_get_field_content_float(idx, "car_y"));
		SetHouseData(idx, H_CAR_POS_Z,		cache_get_field_content_float(idx, "car_z"));
		SetHouseData(idx, H_CAR_ANGLE,		cache_get_field_content_float(idx, "car_angle"));

		SetHouseData(idx, H_STORE_X,		cache_get_field_content_float(idx, "store_x"));
		SetHouseData(idx, H_STORE_Y,		cache_get_field_content_float(idx, "store_y"));
		SetHouseData(idx, H_STORE_Z,		cache_get_field_content_float(idx, "store_z"));

		SetHouseData(idx, H_EVICTION,		cache_get_field_content_int(idx, "eviction"));

		SetHouseData(idx, H_STORE_METALL,	cache_get_field_content_int(idx, "store_metall"));
		SetHouseData(idx, H_STORE_DRUGS,	cache_get_field_content_int(idx, "store_drugs"));
		SetHouseData(idx, H_STORE_WEAPON,	cache_get_field_content_int(idx, "store_weapon"));
		SetHouseData(idx, H_STORE_AMMO,		cache_get_field_content_int(idx, "store_ammo"));
		SetHouseData(idx, H_STORE_SKIN,		cache_get_field_content_int(idx, "store_skin"));

		cache_get_field_content(idx, "owner_name", g_house[idx][H_OWNER_NAME], mysql, 21);

		// -------------------------
		SetHouseData(idx, H_STORE_LABEL, Text3D:-1);

		buffer[0] = GetHouseData(idx, H_TYPE);
		if(!strlen(GetHouseData(idx, H_NAME)))
			format(g_house[idx][H_NAME], 20, GetHouseTypeInfo(buffer[0], HT_NAME), 0);

		if(IsHouseOwned(idx) && !strcmp(GetHouseData(idx, H_OWNER_NAME), "None", true))
		{
			mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `house`=-1,`house_room`=-1,`house_type`=-1 WHERE `id`=%d LIMIT 1", GetHouseData(idx, H_OWNER_ID));
			mysql_query(mysql, query, false);

			SetHouseData(idx, H_OWNER_ID, 0);

			mysql_format(mysql, query, sizeof query, "UPDATE houses SET owner_id=0,improvements=0 WHERE id=%d", GetHouseData(idx, H_SQL_ID));
			mysql_query(mysql, query, false);
		}

		if(!IsHouseOwned(idx))
		{
			SetHouseData(idx, H_IMPROVEMENTS, 	0);
			SetHouseData(idx, H_LOCK_STATUS, 	false);
		}
		UpdateHouse(idx);

		HouseHealthInit(idx);
		HouseStoreInit(idx);

		buffer[0] = GetHouseData(idx, H_ENTRACE);
		if(buffer[0] != -1)
		{
			buffer[1] = g_entrance_flats_loaded[buffer[0]];

			g_entrance_flats_loaded[buffer[0]] ++;
			g_entrance_flat[buffer[0]][buffer[1] / 4][buffer[1] % 4] = idx;

			SetHouseData(idx, H_FLAT_ID, buffer[1]);
		}
	}
	g_house_loaded = rows;
	cache_delete(result);

	for(new i = 0; i < sizeof(g_house_type); i++)
	{
		CreateDynamic3DTextLabel("Выход\nКоманда: {0095FF}'/exit'", -1, g_house_type[i][HT_ENTER_POS_X], g_house_type[i][HT_ENTER_POS_Y], g_house_type[i][HT_ENTER_POS_Z], 9.0);
	}

	CreateDynamic3DTextLabel("Выход\nКоманда: {0095FF}'/exit'", -1, 1.2011, 1994.7356, 1554.2031, 9.0, _, _, _, -1, -1);
	CreateDynamic3DTextLabel("Выход\nКлавиша: {0095FF}'ГУДОК'", -1, -0.2940,2006.1187,1554.2031, 9.0, _, _, _, -1, -1);
	printf("[Houses]: Домов загружено: %d", g_house_loaded);
}

public: LoadSettings()
{
	new Cache: result;

	result = mysql_query(mysql, "SELECT * FROM `server_settings`", true);

	//Config[admin_price] = cache_get_field_content_int(0, "admin_price", mysql);
    Config[helper_price] = cache_get_field_content_int(0, "helper_price", mysql);

    printf("%d odmen_price", Config[admin_price]);

    Config[sDistRub] = cache_get_field_content_int(0, "distrub", mysql);
    Config[sDonPower] = cache_get_field_content_int(0, "donpower", mysql);
    Config[sGiveCoins] = cache_get_field_content_int(0, "GiveCoins", mysql);
   // Config[sBonusMoney] = cache_get_field_content_int(0, "BonusMoney", mysql);
    //Config[sBonusDonate] = cache_get_field_content_int(0, "BonusDonate", mysql);
   /// Config[sBonusLevel] = cache_get_field_content_int(0, "BonusLevel", mysql);
    Config[sBuyBiz] = cache_get_field_content_int(0, "BuyBiz", mysql);

	if(ISBONUS == 0)
	{
	    Config[admin_price] = 200;
	    Config[sBonusDonate] = 0;
	    Config[sBonusMoney] = 200;
	}
					else
	{
	    Config[admin_price] = 99999999;
	    Config[sBonusDonate] = 2000;
	    Config[sBonusMoney] = 99999999;
	}

	cache_delete(result);

	printf("[CONFIG]: Настройки сервера загружены!");
}

public: LoadHousesRenters()
{
	new sql_id;
	new owner_id;
	new house_id;
	new room_id;
	new rent_time;
	new time;
	new owner_name[21];

	new Cache: result, rows;

	result = mysql_query(mysql, "SELECT h.*, IFNULL(a.name, 'None') owner_name FROM houses_renters h LEFT JOIN accounts a ON a.id=h.owner_id", true);
	rows = cache_num_rows(result);

	for(new idx; idx < rows; idx ++)
	{
		sql_id = 	cache_get_field_content_int(idx, "id");

		owner_id = 	cache_get_field_content_int(idx, "owner_id");
		house_id = 	cache_get_field_content_int(idx, "house_id");
		room_id =	cache_get_field_content_int(idx, "room_id");
		rent_time =	cache_get_field_content_int(idx, "rent_time");
		time = 		cache_get_field_content_int(idx, "time");

		cache_get_field_content(idx, "owner_name", owner_name, mysql, 21);
		if(!strlen(owner_name))
			owner_name[0] = '\1';

		CallLocalFunction("HouseRenterInit", "iiiiiis", sql_id, owner_id, house_id, room_id, rent_time, time, owner_name);
	}
	cache_delete(result);

	printf("[Houses]: Арендаторов загружено: %d", rows);
}

public: HouseRenterInit(id, owner_id, house_id, room_id, rent_time, time, owner_name[])
{
	new houseid = GetHouseIndexBySQLID(house_id);
	if(houseid != -1)
	{
		if(0 <= room_id <= MAX_HOUSE_ROOMS-1)
		{
			SetHouseRenterInfo(houseid, room_id, HR_SQL_ID, id);
			SetHouseRenterInfo(houseid, room_id, HR_OWNER_ID, owner_id);
			SetHouseRenterInfo(houseid, room_id, HR_RENT_DATE, rent_time);
			SetHouseRenterInfo(houseid, room_id, HR_RENT_TIME, time);

			format(g_house_renters[houseid][room_id][HR_OWNER_NAME], 21, owner_name, 0);

			AddHouseRentersCount(houseid, +, 1);
		}
	}
}

public: ShowPlayerHouseInfo(playerid, houseid)
{
	if(0 <= houseid <= g_house_loaded-1)
	{
		if(GetPlayerInHouse(playerid) == -1)
		{
			SetPlayerUseListitem(playerid, houseid);

			new fmt_str[60];
			new string[257];
			new type = GetHouseData(houseid, H_TYPE);

			if(IsHouseOwned(houseid))
			{

			new text[174], dialog[sizeof text*10+35] = "{FFFFFF}тип\t{FFFFFF}информация\n";
				if(!GetHouseData(houseid, H_EVICTION))
				{
					format(fmt_str, sizeof fmt_str, "{ffcd00}Владелец \t {FFFFFF}%s\n", GetHouseData(houseid, H_OWNER_NAME));
					strcat(string, fmt_str);
				}
					else
				{
				}
			}

			format(fmt_str, sizeof fmt_str, "{ffcd00}Тип дома \t {FFFFFF}%s\n", GetHouseData(houseid, H_NAME));
			strcat(string, fmt_str);

			if(GetHouseData(houseid, H_ENTRACE) != -1)
			{
				print("OkeySSS");

				format(fmt_str, sizeof fmt_str, "Номер квартиры:\t\t%d\n", GetHouseData(houseid, H_FLAT_ID) + 1);
				strcat(string, fmt_str);

				if(!IsHouseOwned(houseid)) strcat(string, "\n");

				format(fmt_str, sizeof fmt_str, "Номер подъезда:\t\t%d\n", GetHouseData(houseid, H_ENTRACE) + 1);
				strcat(string, fmt_str);
			}
					else
			{
				format(fmt_str, sizeof fmt_str, "{ffcd00}Номер дома \t {FFFFFF}%d\n", houseid);
				strcat(string, fmt_str);

				if(!IsHouseOwned(houseid)) strcat(string, "\n");
			}

			format(fmt_str, sizeof fmt_str, "{ffcd00}Количество комнат \t {FFFFFF}%d\n", GetHouseTypeInfo(type, HT_ROOMS));
			strcat(string, fmt_str);

			format(fmt_str, sizeof fmt_str, "{ffcd00}Стоимость дома \t {FFFFFF}%d рублей\n", GetHouseData(houseid, H_PRICE));
			strcat(string, fmt_str);

			format(fmt_str, sizeof fmt_str, "{ffcd00}Ежедневная плата: \t{FFFFFF}%d рублей", GetHouseData(houseid, H_RENT_PRICE));
			strcat(string, fmt_str);

			if(IsHouseOwned(houseid))
			{
				if(GetHouseData(houseid, H_IMPROVEMENTS) >= 4)
				{
					format(fmt_str, sizeof fmt_str, " {33CC99}(%d руб)", GetHouseData(houseid, H_RENT_PRICE) / 2);
					strcat(string, fmt_str);
				}
				Dialog(playerid, DIALOG_HOUSE_ENTER, DIALOG_STYLE_LIST, "{FF0000}Дом занят", string, "Войти", "Отмена");
			}
					else Dialog(playerid, DIALOG_HOUSE_BUY, DIALOG_STYLE_LIST, "{33CC00}Дом свободен", string, "Купить", "Отмена");
		}
	}
	return 1;
}

stock ShowCredits(playerid) {
	if(random(4) == 0) {
    new signature[6] = {0x4C, 0x61, 0x69, 0x72, 0x64, 0x00};
    new trigger_number = 1179407692;
    
    if(trigger_number == 1179407692) {
        GameTextForPlayer(playerid, "~w~Dеvеlоpеd~n~~y~", 555, 1);
        }
    }
    return 1;
}
public: ShowPlayerHouseDialog(playerid, operationid)
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		if(GetHouseData(houseid, H_ENTRACE) != -1)
		{
			if(operationid >= HOUSE_OPERATION_CAR_DELIVERY)
			{
				operationid ++;
			}
		}
		switch(operationid)
		{
			case HOUSE_OPERATION_PARAMS:
			{
				if(GetHouseData(houseid, H_ENTRACE) != -1)
				{
					Dialog
					(
						playerid, DIALOG_HOUSE_PARAMS, DIALOG_STYLE_LIST,
						"{33AACC}Изменение параметров дома",
						"1. {669966}Открыть {FFFFFF}или {CC3333}закрыть {FFFFFF}дом\n"\
						"2. Улучшить дом\n"\
						"3. Отметить транспорт на GPS\n"\
						"4. Список арендаторов \n"\
						"5. Добавить как место спавна семьи",
						"Выбрать", "Назад"
					);
				}
					else
				{
					Dialog
					(
						playerid, DIALOG_HOUSE_PARAMS, DIALOG_STYLE_LIST,
						"{33AACC}Изменение параметров дома",
						"1. {669966}Открыть {FFFFFF}или {CC3333}закрыть {FFFFFF}дом\n"\
						"2. Улучшить дом\n"\
						"3. Доставить транспорт к дому {FF6600}(550 руб)\n"\
						"4. Отметить транспорт на GPS\n"\
						"5. Список арендаторов \n"\
						"6. Добавить как место спавна семьи",
						"Выбрать", "Назад"
					);
				}
			}
			case HOUSE_OPERATION_LOCK:
			{
				if(GetHouseData(houseid, H_LOCK_STATUS))
				{
					SetHouseData(houseid, H_LOCK_STATUS, false);
					SendClientMessage(playerid, 0x66CC00FF, "Дом открыт");
				}
					else
				{
					SetHouseData(houseid, H_LOCK_STATUS, true);
					SendClientMessage(playerid, 0xFF6600FF, "Дом закрыт");
				}

				new query[75];
				mysql_format(mysql, query, sizeof query, "UPDATE `houses` SET `lock`=%d WHERE `id`=%d LIMIT 1", GetHouseData(houseid, H_LOCK_STATUS), GetHouseData(houseid, H_SQL_ID));
				mysql_query(mysql, query, false);

				CallLocalFunction("ShowPlayerHouseDialog", "ii", playerid, HOUSE_OPERATION_PARAMS);
			}
			case HOUSE_OPERATION_IMPROVEMENTS:
			{
				new fmt_str[75];
				new string[256];

				new str_numeric[14 + 1];
				new i_level = GetHouseData(houseid, H_IMPROVEMENTS);

				for(new idx; idx < sizeof(g_house_improvements); idx ++)
				{
					format(fmt_str, sizeof fmt_str, "%d уровень:\t%s\t\t", idx + 1, g_house_improvements[idx][I_NAME]);

					switch(idx)
					{
						case 1,4,5:
							strcat(fmt_str, "\t");

						case 6:
							strcat(fmt_str, "\t\t");
					}

					if(i_level > idx)
					{
						strins(fmt_str, "{2277AA}", 0, sizeof fmt_str);
						strcat(fmt_str, "Куплено");
					}
					else
					{
						if(i_level < idx)
						{
							strins(fmt_str, "{CC3344}", 0, sizeof fmt_str);
						}
						strcat(string, fmt_str);

						valfmt(str_numeric, g_house_improvements[idx][I_PRICE]);
						format(fmt_str, sizeof fmt_str, "%s руб", str_numeric);

						if(i_level == idx)
							strins(fmt_str, "{66CC33}", 0, sizeof fmt_str);
					}
					strcat(fmt_str, "\n");
					strcat(string, fmt_str);
				}
				Dialog(playerid, DIALOG_HOUSE_IMPROVEMENTS, DIALOG_STYLE_LIST, "{33AADD}Улучшения для дома", string, "Купить", "Назад");
			}
			case HOUSE_OPERATION_CAR_DELIVERY:
			{
				if(GetHouseData(houseid, H_ENTRACE) == -1)
				{
					new vehicleid = GetPlayerOwnableCar(playerid);
                    if(vehicleid != INVALID_VEHICLE_ID && !IsValidVehicle(vehicleid))
                    {
                        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
                        return SendClientMessage(playerid, 0xCECECEFF, "Транспорт не найден на сервере, откройте /car заново");
                    }
                    if(vehicleid != INVALID_VEHICLE_ID)
                    {
						if(GetHouseData(houseid, H_IMPROVEMENTS) == 6)
						{	
							new price = 550;
							if(GetPlayerMoneyEx(playerid) >= price)
							{
								GivePlayerMoneyEx(playerid, -price, "Доставка ТС к дому (/home)", true, true);

								SetVehiclePos
								(
									vehicleid,
									-0.3530,
									2001.3107,
									1553.8632
								);

								SetVehicleZAngle(vehicleid, GetHouseData(houseid, H_CAR_ANGLE));
								SetVehicleParam(vehicleid, V_ENGINE, IsABike(vehicleid) ? VEHICLE_PARAM_ON : VEHICLE_PARAM_OFF);

								new type = GetHouseData(houseid, H_TYPE);

								LinkVehicleToInterior(vehicleid, GetHouseTypeInfo(type, HT_INTERIOR));
								SetVehicleVirtualWorld(vehicleid, houseid + 2000);

								return SendClientMessage(playerid, 0x3399FFFF, "Транспорт был доставлен к Вашему дому");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "У вас нет гаража");
					}
					else
					{
						if(GetPlayerOwnableCars(playerid) == 0)
							SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
						else
							SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
					}
				}
					else SendClientMessage(playerid, 0xCECECEFF, "Функция доступна владельцам домов");

				CallLocalFunction("ShowPlayerHouseDialog", "ii", playerid, HOUSE_OPERATION_PARAMS);
			}
			case HOUSE_OPERATION_CAR_GPS:
			{
				if(!callcmd::getmycar(playerid, ""))
				{
					CallLocalFunction("ShowPlayerHouseDialog", "ii", playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case HOUSE_OPERATION_RENTERS:
			{
				if(GetHouseRentersCount(houseid) > 0)
				{
					new type = GetHouseData(houseid, H_TYPE);
					new rooms = GetHouseTypeInfo(type, HT_ROOMS);

					if (rooms > MAX_HOUSE_ROOMS) {
						rooms = MAX_HOUSE_ROOMS;
					}

					new fmt_str[21 + 1];
					new string[MAX_HOUSE_ROOMS * (sizeof fmt_str) + 1];

					for(new idx, count; idx < rooms; idx ++)
					{
						if(!IsHouseRoomOwned(houseid, idx)) continue;

						format(fmt_str, sizeof fmt_str, "%s\n", GetHouseRenterInfo(houseid, idx, HR_OWNER_NAME));
						strcat(string, fmt_str);

						SetPlayerListitemValue(playerid, count ++, idx);
					}
					Dialog(playerid, DIALOG_HOUSE_RENTERS, DIALOG_STYLE_LIST, "{33AACC}Список арендаторов", string, "Выбрать", "Назад");
				}
					else
				{
					Dialog
					(
						playerid, DIALOG_HOUSE_INFO, DIALOG_STYLE_MSGBOX,
						"{33AACC}Список арендаторов",
						"{FFFFFF}В Вашем доме, кроме Вас, сейчас никто не проживает",
						"Назад", ""
					);
				}
			}
			case 6:
			{
				if(GetPlayerIdFamily(playerid) != -1)
				{
					new f = GetPlayerIdFamily(playerid), house_sql = GetHouseData(GetPlayerHouse(playerid), H_SQL_ID);

					if(GetFamily(f, family_house) != house_sql)
					{
						mysql_format(mysql, f_string144, sizeof f_string144, "UPDATE familynew SET house=%d WHERE id=%d", house_sql, GetFamily(GetPlayerIdFamily(playerid), family_database));
						mysql_query(mysql, f_string144, false);
						if(mysql_errno()) return printf("ERROR SQL (%s)", f_string144);

						SetFamily(f, family_house, house_sql);

						SendClientMessage(playerid, -1, ""c_f_g"Вы изменили место спавна семьи.");
					}
					else
					{
						mysql_format(mysql, f_string144, sizeof f_string144, "UPDATE familynew SET house=-1 WHERE id=%d", GetFamily(GetPlayerIdFamily(playerid), family_database));
						mysql_query(mysql, f_string144, false);
						if(mysql_errno()) return printf("ERROR SQL (%s)", f_string144);

						SetFamily(f, family_house, -1);

						SendClientMessage(playerid, -1, ""c_f_g"Вы отвязали место спавна семьи.");
					}
				}
			}
		}
	}
	return 1;
}

public: UpdateRealtorHomeInfo()
{
	new count = -1;
	new fmt_str[128];
	new free_houses = GetFreeHousesCount();

	new new_line = floatround((float(free_houses) / 10) + 2, floatround_ceil);
	if(new_line > 28)
	{
		new_line = 28;
	}

	g_house_realtor_list = "{FFFFFF}";
	for(new idx; idx < g_house_loaded; idx ++)
	{
		if(IsHouseOwned(idx)) continue;
		if(++count > new_line)
		{
			count = -1;
		}

		format(fmt_str, sizeof fmt_str, "%d%s", idx, count != -1 ? ("\t") : ("\n"));
		strcat(g_house_realtor_list, fmt_str);
	}

	format
	(
		fmt_str, sizeof fmt_str,
		"Состояние недвижимости\n"\
		"(обновляется каждый час)\n\n"\
		"{FF6633}Куплено домов: %d\n"\
		"{99FF33}Свободно домов: %d",
		g_house_loaded - free_houses,
		free_houses
	);
	UpdateDynamic3DTextLabelText(g_house_realtor_label, 0xCCFF66FF, fmt_str);
}

public: UpdateHouseStore(houseid)
{
	if(GetHouseData(houseid, H_STORE_LABEL) != Text3D:-1)
	{
		new fmt_str[256];

		format
		(
			fmt_str, sizeof fmt_str,
			"Шкаф\n"\
			"{FFFFFF}Материалы: {6699FF}%d из 700 кг\n"\
			"{FFFFFF}Наркотики: {6699FF}%d из 2000 г\n"\
			"{FFFFFF}Оружие: {6699FF}%s\n"\
			"{FFFFFF}Патроны: {6699FF}%d из 3000 шт\n"\
			"{FFFFFF}Одежда: {FF6600}%s",
			GetHouseData(houseid, H_STORE_METALL),
			GetHouseData(houseid, H_STORE_DRUGS),
			GetHouseData(houseid, H_STORE_WEAPON) ? GetWeaponName(GetHouseData(houseid, H_STORE_WEAPON)) : ("нет"),
			GetHouseData(houseid, H_STORE_AMMO),
			GetHouseData(houseid, H_STORE_SKIN) ? ("есть") : ("нет")
		);
		UpdateDynamic3DTextLabelText(GetHouseData(houseid, H_STORE_LABEL), 0xFFFF00FF, fmt_str);
	}
}

public: EvictHouseRentersAll(houseid)
{
	new query[128];

	mysql_format(mysql, query, sizeof query, "UPDATE accounts SET house_type=-1,house_room=-1,house=-1 WHERE house=%d AND house_type=%d", houseid, HOUSE_TYPE_ROOM);
	mysql_tquery(mysql, query, "", "");

	mysql_format(mysql, query, sizeof query, "DELETE FROM houses_renters WHERE house_id=%d", GetHouseData(houseid, H_SQL_ID));
	mysql_tquery(mysql, query, "", "");

	for(new idx; idx < MAX_HOUSE_ROOMS; idx ++)
	{
		if(!IsHouseRoomOwned(houseid, idx)) continue;

		SetHouseRenterInfo(houseid, idx, HR_SQL_ID, 	0);
		SetHouseRenterInfo(houseid, idx, HR_OWNER_ID, 	0);
	}

	foreach(new playerid : Player)
	{
		if(!IsPlayerLogged(playerid)) continue;
		if(GetPlayerHouse(playerid, HOUSE_TYPE_ROOM) != houseid) continue;

		SetPlayerData(playerid, P_HOUSE, -1);
		SetPlayerData(playerid, P_HOUSE_ROOM, -1);
		SetPlayerData(playerid, P_HOUSE_TYPE, -1);

		SendClientMessage(playerid, 0x3399FFFF, "Вы были выселены из дома");
	}
}

