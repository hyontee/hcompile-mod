//>> Файл: bykranin_src/core/property/property_09.inc  (300 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: SellDebtorsProperty, SellDebtorsHotels, /smenu, /givelic, /setlic, /free, /medhelp
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock SellDebtorsProperty()
{
	new cur_time = gettime(),
		query[180];

	for(new i; i < g_house_loaded; i ++)
	{
		if(!GetHouseData(i, H_EVICTION)) continue;
		if(GetHouseData(i, H_RENT_DATE) < cur_time) continue;

		format(query, sizeof query, "UPDATE houses SET owner_id='0',lock='0',eviction='0' WHERE id='%d'", GetHouseData(i, H_SQL_ID));
		mysql_query(mysql, query, false);

		new owner_player = GetPlayerIDBySqlID(GetHouseData(i, H_OWNER_ID));
		if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player)) {
			SetPlayerData(owner_player, P_HOUSE, -1);
			SetPlayerData(owner_player, P_HOUSE_ROOM, -1);
			SetPlayerData(owner_player, P_HOUSE_TYPE, -1);
			mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `house`=-1,`house_room`=-1,`house_type`=-1 WHERE `id`=%d LIMIT 1", GetPlayerAccountID(owner_player));
			mysql_query(mysql, query, false);
		}
					else {
			mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `house`=-1,`house_room`=-1,`house_type`=-1 WHERE `id`=%d LIMIT 1", GetHouseData(i, H_OWNER_ID));
			mysql_query(mysql, query, false);
		}
		SetHouseData(i, H_OWNER_ID, 0);
		SetHouseData(i, H_IMPROVEMENTS,		0);

		SetHouseData(i, H_EVICTION, 0);

		SetHouseData(i, H_RENT_DATE,		0);
		SetHouseData(i, H_LOCK_STATUS,		false);

		UpdateHouse(i);

		HouseHealthInit(i);
		HouseStoreInit(i);
	}

	for(new i; i < g_business_loaded; i ++)
	{
		if(!GetBusinessData(i, B_EVICTION)) continue;
		if(GetBusinessData(i, B_RENT_DATE) < cur_time) continue;

		format(query, sizeof query, "UPDATE business SET owner_id='0',products='0',prod_price='0',lock='0',eviction='0' WHERE id='%d'", GetBusinessData(i, B_SQL_ID));
		mysql_query(mysql, query, false);

		new owner_player = GetPlayerIDBySqlID(GetBusinessData(i, B_OWNER_ID));
		if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player)) {
			SetPlayerData(owner_player, P_BUSINESS, -1);
			mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `business`=-1 WHERE `id`=%d LIMIT 1", GetPlayerAccountID(owner_player));
			mysql_query(mysql, query, false);
		}
					else {
			mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `business`=-1 WHERE `id`=%d LIMIT 1", GetBusinessData(i, B_OWNER_ID));
			mysql_query(mysql, query, false);
		}

		SetBusinessData(i, B_OWNER_ID, 0);
		SetBusinessData(i, B_IMPROVEMENTS, 		0);

		SetBusinessData(i, B_EVICTION, 0);

		SetBusinessData(i, B_PRODS, 			0);
		SetBusinessData(i, B_PROD_PRICE,		0);

		SetBusinessData(i, B_BALANCE,			0);
		SetBusinessData(i, B_RENT_DATE,			0);
		SetBusinessData(i, B_ENTER_MUSIC,		0);
		SetBusinessData(i, B_LOCK_STATUS,		false);

		BusinessHealthPickupInit(i);

		format(query, sizeof query, "DELETE FROM business_gps WHERE bid=%d", i);
		mysql_query(mysql, query, false);

		g_business_gps_init = false;

		//format(query, sizeof query, "UPDATE business_profit SET view=0 WHERE bid=%d AND view=1", GetBusinessData(i, B_SQL_ID));
		//mysql_query(mysql, query, false);

		CallLocalFunction("UpdateBusinessLabel", "i", i);
	}

	for(new i; i < g_fuel_station_loaded; i ++)
	{
		if(!GetFuelStationData(i, FS_EVICTION)) continue;
		if(GetFuelStationData(i, FS_RENT_DATE) < cur_time) continue;

		format(query, sizeof query, "UPDATE fuel_stations SET owner_id='0',fuels='1000',fuel_price='3',lock='0',eviction='0' WHERE id='%d'", GetFuelStationData(i, FS_SQL_ID));
		mysql_query(mysql, query, false);

		new owner_player = GetPlayerIDBySqlID(GetFuelStationData(i, FS_OWNER_ID));
		if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player)) {
			SetPlayerData(owner_player, P_FUEL_ST, -1);
			format(query, sizeof query, "UPDATE accounts SET `fuel_st`=-1 WHERE `id`=%d LIMIT 1", GetPlayerAccountID(owner_player));
			mysql_query(mysql, query, false);
		}
					else {
			format(query, sizeof query, "UPDATE accounts SET `fuel_st`=-1 WHERE `id`=%d LIMIT 1", GetFuelStationData(i, FS_OWNER_ID));
			mysql_query(mysql, query, false);
		}

		SetFuelStationData(i, FS_OWNER_ID, 0);
		SetFuelStationData(i, FS_IMPROVEMENTS, 0);

		SetFuelStationData(i, FS_EVICTION, 0);

		SetFuelStationData(i, FS_FUELS, 		1000);
		SetFuelStationData(i, FS_FUEL_PRICE,	3);
		SetFuelStationData(i, FS_BUY_FUEL_PRICE,0);

		SetFuelStationData(i, FS_BALANCE,		0);
		SetFuelStationData(i, FS_RENT_DATE,		0);
		SetFuelStationData(i, FS_LOCK_STATUS,	false);

		//format(query, sizeof query, "UPDATE fuel_stations_profit SET view=0 WHERE fid=%d AND view=1",  GetFuelStationData(i, FS_SQL_ID));
		//mysql_query(mysql, query, false);

		CallLocalFunction("UpdateFuelStationLabel", "i", i);
	}

	return 1;
}

stock SellDebtorsHotels()
{
	new cur_time = gettime();
	new query[200];

	mysql_format(mysql, query, sizeof query, "UPDATE accounts a,hotels h SET a.house=-1,a.house_room=0,a.house_type=-1,h.owner_id=0,h.rent_time=0,h.status=1 WHERE a.id=h.owner_id AND h.rent_time < %d", cur_time);
	mysql_query(mysql, query, false);

	new hotel_owner_playerid;

	for(new h_id, r_id; h_id < MAX_HOTELS; h_id ++)
	{
		for(r_id = 0; r_id < MAX_HOTEL_ROOMS; r_id ++)
		{
			if(GetHotelData(h_id, r_id, H_RENT_DATE) < cur_time) continue;

			GetPlayerID(GetHotelData(h_id, r_id, H_OWNER_NAME), hotel_owner_playerid);

			SetHotelData(h_id, r_id, H_OWNER_ID, 0);
			SetHotelData(h_id, r_id, H_RENT_DATE, 0);

			if(IsPlayerConnected(hotel_owner_playerid) && IsPlayerLogged(hotel_owner_playerid))
			{
				if(GetPlayerHouse(hotel_owner_playerid, HOUSE_TYPE_HOTEL) == h_id)
				{
					SetPlayerData(hotel_owner_playerid, P_HOUSE, 		-1);
					SetPlayerData(hotel_owner_playerid, P_HOUSE_ROOM, 	-1);
					SetPlayerData(hotel_owner_playerid, P_HOUSE_TYPE, 	-1);

					SendClientMessage(hotel_owner_playerid, 0xFF6600FF, "Вы были выселены из гостиницы за неуплату услуг");
				}
			}
		}
	}
	return 1;
}

CMD:smenu(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJob(playerid) != 5) return SendClientMessage(playerid, 0x999999FF, "Функция доступна советникам правительства");

	Dialog
	(
		playerid, DIALOG_ADVISOR_MENU, DIALOG_STYLE_LIST,
		"{33CC66}Меню советника",
		"1. Показать/скрыть бейджик\n\
		2. Показать/скрыть рацию организации\n\
		3. Показать состав организации",
		"Выбрать", "Закрыть"
	);
	return 1;
}

CMD:givelic(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJob(playerid) != 6) return SendClientMessage(playerid, 0x999999FF, "Функция доступна только лицензерам");

	if(!strlen(params))
	{
		SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givelic [id игрока] [идентификатор лицензии] [цена]");
		SendClientMessage(playerid, 0x999999FF, "Индификаторы лицензий: 1 - Вод. права базового уровня | 2 - Вод. права профессионального уровня | 3 - На оружие");
		return 1;
	}

	extract params -> new to_player, lic_id, price;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0x999999FF, "Игрок слишком далеко");

	if(!(1 <= lic_id <= 3)) return SendClientMessage(playerid, 0x999999FF, "Неверный идентификатор лицензии");

	switch(lic_id)
	{
		case 1:
		{
			if(GetPlayerData(to_player, P_DRIVING_LIC) >= 1)
				return SendClientMessage(playerid, 0x999999FF, "У игрока уже есть лицензия на вождение базового уровня");
		}
		case 2:
		{
			if(GetPlayerData(to_player, P_DRIVING_LIC) == 2)
				return SendClientMessage(playerid, 0x999999FF, "У игрока уже есть лицензия на вождение профессионального уровня");
		}
		case 3:
		{
			if(GetPlayerData(to_player, P_WEAPON_LIC) == 1)
				return SendClientMessage(playerid, 0x999999FF, "У игрока уже есть лицензия на оружие");
		}
	}
    
	new lic_price_limits[3][2] =
	{
		{1000, 	10000},
		{10000, 30000},
		{30000, 50000}
	};

	if(!(lic_price_limits[lic_id - 1][0] <= price <= lic_price_limits[lic_id - 1][1]))
	{
		new fmt_text[60];

		format(fmt_text, sizeof fmt_text, "Стоимость лицензии должна быть от %d до %d рублей",
		lic_price_limits[lic_id - 1][0], lic_price_limits[lic_id - 1][1]);

		SendClientMessage(playerid, 0x999999FF, fmt_text);

		return 1;
	}

	if(GetPlayerMoneyEx(to_player) < price)
		return SendClientMessage(playerid, 0x999999FF, "У игрока нет такой суммы денег");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_GIVE_LIC, lic_id, price);

	return 1;
}

CMD:setlic(playerid, params[])
{
     
	if(GetPlayerAdminEx(playerid) < 1) return 1;
	
	SetPlayerData(playerid, P_DRIVING_LIC, 2);
				
	SetPlayerData(playerid, P_WEAPON_LIC, 1);
				

	return 1;
}

CMD:free(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJob(playerid) != 7) return SendClientMessage(playerid, 0x999999FF, "Функция доступна только адвокатам");

	extract params -> new to_player, price; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /free [id игрока] [цена]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0x999999FF, "Игрок слишком далеко");

	if(!GetPlayerData(to_player, P_JAIL))
		return SendClientMessage(playerid, 0x999999FF, "Игрок не находится в тюрьме");

	if(!(500 <= price <= 50000))
		return SendClientMessage(playerid, 0x999999FF, "Стоимость должна быть от 500 до 50.000 рублей");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_JAIL_FREE, price);

	return 1;
}

CMD:medhelp(playerid, params[])
{
	if(GetPlayerTeamEx(playerid) != TEAM_HOSPITAL) return SendClientMessage(playerid, 0x999999FF, "Вы не медицинский работник");
	if(!IsPlayerInRangeOfPoint(playerid, 99.0, 1497.072631,2500.594726,2501.000000)) return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в больнице");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Использование: /medhelp [id игрока] [стоимость лечения]");
	extract params -> new to_player, price;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0)) return SendClientMessage(playerid, 0x999999FF, "Пациент слишком далеко");
	if(GetPlayerData(to_player, P_OCCUPIED_BED) == -1) return SendClientMessage(playerid, 0x999999FF, "Этот игрок не лежит в больнице");
	if(!(100 <= price <= 5000)) return SendClientMessage(playerid, 0xCECECEFF, "Стоимость лечения должна быть от 100 до 5000 рублей");
	if(GetPlayerMoneyEx(to_player) < price) return SendClientMessage(playerid, 0x999999FF, "У пациента нет с собой столько денег");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_MEDHELP, price);
	return 1;
}

