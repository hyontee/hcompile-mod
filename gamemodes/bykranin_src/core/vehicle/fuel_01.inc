//>> Файл: bykranin_src/core/vehicle/fuel_01.inc  (669 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: GetFreeHousesCount, ShowHouseRenterInfo, AddHouseRenter, EvictHouseRenter, GetHouseIndexBySQLID, GetHouseFreeRoom, LotteryBuyTicketCount
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock GetFreeHousesCount()
{
	new count;
	for(new idx; idx < g_house_loaded; idx ++)
	{
		if(IsHouseOwned(idx)) continue;

		count ++;
	}
	return count;
}

stock ShowHouseRenterInfo(playerid, houseid, roomid)
{
	if(GetPlayerHouse(playerid, HOUSE_TYPE_HOME) == houseid)
	{
		if(0 <= roomid <= MAX_HOUSE_ROOMS-1)
		{
			if(IsHouseRoomOwned(houseid, roomid))
			{
				SetPlayerUseListitem(playerid, roomid);

				new string[144];
				new time = gettime();

				new s_year, s_month, s_day; // поселение
				timestamp_to_date(GetHouseRenterInfo(houseid, roomid, HR_RENT_TIME), s_year, s_month, s_day);

				//new e_year, e_month, e_day;	// выселение
				//timestamp_to_date(GetHouseRoomInfo(houseid, roomid, HR_RENT_DATE), e_year, e_month, e_day);

				format
				(
					string, sizeof string,
					"1. Арендатор\t\t\t{CCCC00}%s\n"\
					"2. Поселился\t\t\t%02d-%02d-%d\n"\
					"3. Проживает\t\t\t{66BB33}%d дней\n"\
					"{888888}4. Выселить",
					GetHouseRenterInfo(houseid, roomid, HR_OWNER_NAME),
					s_day, s_month, s_year,
					GetElapsedTime(time, GetHouseRenterInfo(houseid, roomid, HR_RENT_TIME), CONVERT_TIME_TO_DAYS)
				);
				Dialog(playerid, DIALOG_HOUSE_RENTER_INFO, DIALOG_STYLE_LIST, "{33AACC}Информация о арендаторе", string, "Действие", "Назад");
			}
					else SendClientMessage(playerid, 0x999999FF, "В этой комнате уже никто не проживает");
		}
	}
}

stock AddHouseRenter(houseid, roomid, playerid)
{
	if(!IsHouseRoomOwned(houseid, roomid))
	{
		new query[128];
		new Cache: result;

		new time = gettime();

		format(query, sizeof query, "UPDATE accounts SET house_type=%d,house_room=%d,house=%d WHERE id=%d LIMIT 1", HOUSE_TYPE_ROOM, roomid, houseid, GetPlayerAccountID(playerid));
		mysql_query(mysql, query, false);

		format(query, sizeof query, "INSERT INTO houses_renters (owner_id,house_id,room_id,rent_time,time) VALUES (%d,%d,%d,%d,%d)", GetPlayerAccountID(playerid), GetHouseData(houseid, H_SQL_ID), roomid, 0, time);
		result = mysql_query(mysql, query, true);

		SetHouseRenterInfo(houseid, roomid, HR_SQL_ID, 		cache_insert_id());
		SetHouseRenterInfo(houseid, roomid, HR_OWNER_ID,	GetPlayerAccountID(playerid));
		SetHouseRenterInfo(houseid, roomid, HR_RENT_DATE,	0);
		SetHouseRenterInfo(houseid, roomid, HR_RENT_TIME,	time);

		format(GetHouseRenterInfo(houseid, roomid, HR_OWNER_NAME), 21, GetPlayerNameEx(playerid));

		SetPlayerData(playerid, P_HOUSE, 		houseid);
		SetPlayerData(playerid, P_HOUSE_TYPE, 	HOUSE_TYPE_ROOM);
		SetPlayerData(playerid, P_HOUSE_ROOM, 	roomid);

		AddHouseRentersCount(houseid, +, 1);

		cache_delete(result);
	}
}

stock EvictHouseRenter(houseid, roomid, renter_id = INVALID_PLAYER_ID, ownerid = INVALID_PLAYER_ID)
{
	if(IsHouseRoomOwned(houseid, roomid))
	{
		new query[90];

		format(query, sizeof query, "DELETE FROM houses_renters WHERE owner_id=%d AND house_id=%d", GetHouseRenterInfo(houseid, roomid, HR_OWNER_ID), GetHouseData(houseid, H_SQL_ID));
		mysql_query(mysql, query, false);

		format(query, sizeof query, "UPDATE accounts SET house_type=-1,house_room=-1,house=-1 WHERE id=%d LIMIT 1", GetHouseRenterInfo(houseid, roomid, HR_OWNER_ID));
		mysql_query(mysql, query, false);

		if(!mysql_errno())
		{
			if(renter_id == INVALID_PLAYER_ID)
				renter_id = GetPlayerID(GetHouseRenterInfo(houseid, roomid, HR_OWNER_NAME));

			if(renter_id != INVALID_PLAYER_ID)
			{
				if(GetPlayerHouse(renter_id, HOUSE_TYPE_ROOM) == houseid)
				{
					if(ownerid != INVALID_PLAYER_ID)
					{
						format(query, sizeof query, "%s выселил Вас из своего дома", GetPlayerNameEx(ownerid));
						SendClientMessage(renter_id, 0x3399FFFF, query);
					}

					SetPlayerData(renter_id, P_HOUSE, -1);
					SetPlayerData(renter_id, P_HOUSE_TYPE, -1);
					SetPlayerData(renter_id, P_HOUSE_ROOM, -1);
				}
			}

			SetHouseRenterInfo(houseid, roomid, HR_SQL_ID, 	0);
			SetHouseRenterInfo(houseid, roomid, HR_OWNER_ID,	0);
			SetHouseRenterInfo(houseid, roomid, HR_RENT_DATE,	0);
			SetHouseRenterInfo(houseid, roomid, HR_RENT_TIME,	0);

			AddHouseRentersCount(houseid, -, 1);
			return 1;
		}
		return -1;
	}
	return 0;
}

stock GetHouseIndexBySQLID(sql_id)
{
	new index = -1;

	for(new idx; idx < MAX_HOUSES; idx ++)
	{
		if(GetHouseData(idx, H_SQL_ID) != sql_id) continue;

		index = idx;
		break;
	}
	return index;
}

stock GetHouseFreeRoom(houseid)
{
	new roomid = -1;

	for(new idx; idx < MAX_HOUSE_ROOMS; idx ++)
	{
		if(IsHouseRoomOwned(houseid, idx)) continue;

		roomid = idx;
		break;
	}
	return roomid;
}

stock LotteryBuyTicketCount()
{
	new count;
	foreach(new playerid : Player)
	{
		if(!IsPlayerLogged(playerid)) continue;
		if(!GetPlayerData(playerid, P_LOTTERY)) continue;

		count ++;
	}
	return count;
}



stock ShowPlayerSelectPanel(playerid, type)
{
	if(GetPlayerData(playerid, P_USE_SELECT_PANEL) == SELECT_PANEL_TYPE_NONE)
	{
		for(new idx; idx < sizeof select_TD; idx ++)
		{
			TextDrawShowForPlayer(playerid, select_TD[idx]);
		}
		SetPlayerData(playerid, P_USE_SELECT_PANEL, type);

		SelectTextDraw(playerid, 0x009900FF);
	}
}

stock HidePlayerSelectPanel(playerid)
{
	if(GetPlayerData(playerid, P_USE_SELECT_PANEL) != SELECT_PANEL_TYPE_NONE)
	{
		CancelSelectTextDraw(playerid);

		for(new idx; idx < sizeof select_TD; idx ++)
		{
			TextDrawHideForPlayer(playerid, select_TD[idx]);
		}
		SetPlayerData(playerid, P_USE_SELECT_PANEL, SELECT_PANEL_TYPE_NONE);
	}
}

stock IsPlayerHaveWeapon(playerid, weaponid)
{
	new weapon, ammo;
	new bool: is_have = false;

	for(new idx; idx <= 12; idx ++)
	{
		GetPlayerWeaponData(playerid, idx, weapon, ammo);
		if(weapon != weaponid) continue;

		is_have = true;
		break;
	}
	return is_have;
}

stock IsAJobCar(vehicleid)
{
	switch(GetVehicleData(vehicleid, V_ACTION_TYPE))
	{
		case
			VEHICLE_ACTION_TYPE_BUS_DRIVER,
			VEHICLE_ACTION_TYPE_TAXI_DRIVER,
			VEHICLE_ACTION_TYPE_UNUSED_1,
			VEHICLE_ACTION_TYPE_TRUCKER:
		{
			return 1;
		}
	}
	return 0;
}

stock GetNearestVehicleID(playerid, Float: radius = 0.0)
{
	if(radius == 0.0)
		radius = FLOAT_INFINITY;

	new vehicleid = INVALID_VEHICLE_ID;

	new Float: dist;
	new Float: pos_x, Float: pos_y, Float: pos_z;

	GetPlayerPos(playerid, pos_x, pos_y, pos_z);
	for(new idx; idx < MAX_VEHICLES; idx ++)
	{
		if(!IsValidVehicle(idx)) continue;
		if(!IsVehicleStreamedIn(idx, playerid)) continue;

		dist = GetVehicleDistanceFromPoint(idx, pos_x, pos_y, pos_z);
		if(dist < radius)
		{
			radius = dist,
			vehicleid = idx;
		}
	}
	return vehicleid;
}

stock ShowPlayerBuyRepairCarDialog(playerid, stationid)
{
	if(stationid != -1)
	{
		SetPVarInt(playerid, "buy_jerrican_in_fuelst", stationid);

		new fmt_str[70];
		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Рем. комплекс стоит 100.000$\n"\
			"Вы хотите купить ее?"
		);
		Dialog(playerid, DIALOG_FUEL_STATION_BUY_REPAIR, DIALOG_STYLE_MSGBOX, "АЗС", fmt_str, "Да", "Нет");
	}
					else SendClientMessage(playerid, 0xCECECEFF, "Рем комплекс можно купить на любой АЗС");
}

stock ShowPlayerBuyJerricanDialog(playerid, stationid)
{
	if(stationid != -1)
	{
		SetPVarInt(playerid, "buy_jerrican_in_fuelst", stationid);

		new fmt_str[70];
		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Канистра на этой заправке стоит %d руб\n"\
			"Вы хотите купить ее?",
			GetFuelStationData(stationid, FS_FUEL_PRICE) * 15
		);
		Dialog(playerid, DIALOG_FUEL_STATION_BUY_JERRICA, DIALOG_STYLE_MSGBOX, "{FFCD00}Покупка канистры", fmt_str, "Да", "Нет");
	}
					else SendClientMessage(playerid, 0xCECECEFF, "Канистру с топливом можно купить на любой АЗС");
}

stock LoadOrders()
{
	new Cache: result, rows;

	result = mysql_query(mysql, "SELECT * FROM orders");
	rows = cache_num_rows(result);

	if(rows > sizeof g_order)
		rows = sizeof g_order;

	new buffer;
	for(new idx; idx < rows; idx ++)
	{
		SetOrderData(idx, O_SQL_ID,		cache_get_field_content_int(idx, "id"));
		SetOrderData(idx, O_TYPE,		cache_get_field_content_int(idx, "type"));
		SetOrderData(idx, O_COMPANY_ID,		cache_get_field_content_int(idx, "company"));
		SetOrderData(idx, O_AMOUNT,		cache_get_field_content_int(idx, "amount"));
		SetOrderData(idx, O_PRICE,		cache_get_field_content_int(idx, "price"));
		SetOrderData(idx, O_TIME,		cache_get_field_content_int(idx, "time"));
		SetOrderData(idx, O_USED, 		false);

		buffer = GetOrderData(idx, O_COMPANY_ID);
		switch(GetOrderData(idx, O_TYPE))
		{
			case ORDER_TYPE_FUEL_STATION:
			{
				SetFuelStationData(buffer, FS_ORDER_ID, idx);
			}
			case ORDER_TYPE_BUSINESS:
			{
				SetBusinessData(buffer, B_ORDER_ID, idx);
			}
		}
	}
	cache_delete(result);

	printf("[Orders]: Заказов загружено: %d", rows);
}

stock CreateOrder(type, company, amount, price, description[] = "")
{

	new order_id = GetOrderFreeSlot();
	if(order_id != -1)
	{
		new query[128];
		new Cache: result;
		new time = gettime();

		format(query, sizeof query, "INSERT INTO orders (type,company,amount,price,time) VALUES (%d,%d,%d,%d,%d)", type, company, amount, price, time);
		result = mysql_query(mysql, query, true);

		if(!mysql_errno())
		{
			new year, month, day;
			getdate(year, month, day);

			SetOrderData(order_id, O_TYPE, type);
			SetOrderData(order_id, O_COMPANY_ID, company);
			SetOrderData(order_id, O_AMOUNT, amount);
			SetOrderData(order_id, O_PRICE, price);
			SetOrderData(order_id, O_TIME, time);
			SetOrderData(order_id, O_USED, false);

			SetOrderData(order_id, O_SQL_ID, cache_insert_id());

			switch(type)
			{
				case ORDER_TYPE_FUEL_STATION:
				{
					SetFuelStationData(company, FS_ORDER_ID, order_id);
				}
				case ORDER_TYPE_BUSINESS:
				{
					SetBusinessData(company, B_ORDER_ID, order_id);
				}
			}
		}
					else order_id = -1;

		cache_delete(result);
	}
	return order_id;
}

stock DeleteOrder(orderid)
{
	if(GetOrderData(orderid, O_SQL_ID) > 0)
	{
		new query[64];
		new company = GetOrderData(orderid, O_COMPANY_ID);

		switch(GetOrderData(orderid, O_TYPE))
		{
			case ORDER_TYPE_FUEL_STATION:
			{
				SetFuelStationData(company, FS_ORDER_ID, -1);
			}
			case ORDER_TYPE_BUSINESS:
			{
				SetBusinessData(company, B_ORDER_ID, -1);
			}
		}

		format(query, sizeof query, "DELETE FROM orders WHERE type=%d AND company=%d", GetOrderData(orderid, O_TYPE), GetOrderData(orderid, O_COMPANY_ID));
		mysql_query(mysql, query, false);

		SetOrderData(orderid, O_SQL_ID, 0);
		SetOrderData(orderid, O_PRICE,  0);
		SetOrderData(orderid, O_AMOUNT, 0);
	}
}

stock GetOrderFreeSlot()
{
	new slot = -1;

	for(new idx; idx < sizeof g_order; idx ++)
	{
		if(GetOrderData(idx, O_SQL_ID) > 0) continue;

		slot = idx;
		break;
	}
	return slot;
}

stock SellFuelStation(playerid, to_player = INVALID_PLAYER_ID, price = 0)
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		new fuel_st_price = GetFuelStationData(stationid, FS_PRICE);
		new fuel_st_percent = (fuel_st_price * 30) / 100;
		new fuel_st_improvemnts_price = FuelStationImprovementsPrice(stationid);

		if(fuel_st_improvemnts_price)
			fuel_st_improvemnts_price = (fuel_st_improvemnts_price * 60) / 100;

		new query[170];
		new return_money = (fuel_st_price - fuel_st_percent) + fuel_st_improvemnts_price;

		SetPlayerData(playerid, P_FUEL_ST, -1);

		SetFuelStationData(stationid, FS_OWNER_ID, 0);

		if(to_player == INVALID_PLAYER_ID)
		{
			AddPlayerData(playerid, P_BANK, +, return_money);

			BankLog(playerid, return_money, "Продажа АЗС");

			SetFuelStationData(stationid, FS_IMPROVEMENTS, 0);

			SetFuelStationData(stationid, FS_FUELS, 		1000);
			SetFuelStationData(stationid, FS_FUEL_PRICE,	3);
			SetFuelStationData(stationid, FS_BUY_FUEL_PRICE,0);

			SetFuelStationData(stationid, FS_BALANCE,		0);
			SetFuelStationData(stationid, FS_RENT_DATE,		0);
			SetFuelStationData(stationid, FS_LOCK_STATUS,	false);

			format(query, sizeof query, "UPDATE accounts a,fuel_stations f SET a.bank=%d,a.fuel_st=-1,f.owner_id=0,f.fuels=1000,f.fuel_price=3,f.lock=0 WHERE a.id=%d AND f.id=%d", GetPlayerData(playerid, P_BANK), GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
			mysql_query(mysql, query, false);

			//format(query, sizeof query, "UPDATE fuel_stations_profit SET view=0 WHERE fid=%d AND view=1",  GetFuelStationData(stationid, FS_SQL_ID));
			//mysql_query(mysql, query, false);

			GivePlayerMoneyEx(playerid, 0, "Продажа заправочной станции государству", false, false);
			CallLocalFunction("UpdateFuelStationLabel", "i", stationid);

			SendClientMessage(playerid, 0x66CC00FF, "Вы продали свою заправочную станцию!");

			format(query, sizeof query, "Налог за продажу заправочной станции составил 30 процентов от ее стоимости {99CC00}(%d руб)", fuel_st_percent);
			SendClientMessage(playerid, 0xCECECEFF, query);

			format(query, sizeof query, "Вам было возвращено 60 процентов от стоимости купленных улучшений: {CCFF00}%d руб", fuel_st_improvemnts_price);
			SendClientMessage(playerid, 0xCECECEFF, query);

			format(query, sizeof query, "Итого на банковский счет перечислено: {3399FF}%d руб", return_money);
			SendClientMessage(playerid, 0xFFFFFFFF, query);

		}
					else
		{
			if(BuyPlayerFuelStation(to_player, stationid, true, price) == 1)
			{
				new total_price = price + fuel_st_improvemnts_price;

				format(query, sizeof query, "Вам было возвращено 60 процентов от стоимости купленных улучшений: {CCFF00}%d руб", fuel_st_improvemnts_price);
				SendClientMessage(playerid, 0xCECECEFF, query);

				format(query, sizeof query, "UPDATE accounts SET money=%d,fuel_st=-1 WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)+total_price, GetPlayerAccountID(playerid));
				mysql_query(mysql, query, false);

				GivePlayerMoneyEx(playerid, total_price, "Продажа заправочной станции игроку", false, false);

				fuel_st_price = price;
				fuel_st_percent = 0;
			}
					else return ;
		}
		format(query, sizeof query, "~g~+%d rub~n~+%d rub", (fuel_st_price - fuel_st_percent), fuel_st_improvemnts_price);
		GameTextForPlayer(playerid, query, 4000, 1);
	}
}

stock BuyPlayerFuelStation(playerid, stationid, bool: buy_from_owner = false, price = -1)
{
	if(!IsFuelStationOwned(stationid) && GetPlayerFuelStation(playerid) == -1)
	{
		if(price <= 0)
			price = GetFuelStationData(stationid, FS_PRICE);

		if(GetPlayerMoneyEx(playerid) >= price)
		{
			new query[256];

			format(query, sizeof query, "UPDATE accounts a, fuel_stations f SET a.money=%d,a.fuel_st=%d,f.owner_id=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-price, stationid, GetPlayerAccountID(playerid), GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
			mysql_query(mysql, query, false);

			if(!mysql_errno())
			{
				SetPlayerData(playerid, P_FUEL_ST, stationid);

				SetFuelStationData(stationid, FS_OWNER_ID, 		GetPlayerAccountID(playerid));
				SetFuelStationData(stationid, FS_IMPROVEMENTS, 0);

				new time = gettime();
				new rent_time = (time - (time % 86400)) + 86400;

				if(!buy_from_owner)
				{
					SetFuelStationData(stationid, FS_FUELS, 		50);
					SetFuelStationData(stationid, FS_FUEL_PRICE,	3);
					SetFuelStationData(stationid, FS_BUY_FUEL_PRICE,0);

					SetFuelStationData(stationid, FS_BALANCE,		0);
					SetFuelStationData(stationid, FS_RENT_DATE,		rent_time);
					SetFuelStationData(stationid, FS_LOCK_STATUS,	false);
				}
					else
				{
					if(GetElapsedTime(GetFuelStationData(stationid, FS_RENT_DATE), time, CONVERT_TIME_TO_DAYS) <= 0)
					{
						SetFuelStationData(stationid, FS_RENT_DATE, rent_time);
					}
				}
				format(g_fuel_station[stationid][FS_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
				CallLocalFunction("UpdateFuelStationLabel", "i", stationid);

				GivePlayerMoneyEx(playerid, -price, "Покупка заправочной станции", false, true);
				SendClientMessage(playerid, 0x66CC00FF, "Напишите {3399FF}/fuelst {66CC00}чтобы узнать о возможностях");

				format(query, sizeof query, "UPDATE fuel_stations SET improvements=0,fuels=%d,fuel_price=%d,buy_fuel_price=%d,balance=%d,rent_time=%d,`lock`=%d WHERE id=%d LIMIT 1", GetFuelStationData(stationid, FS_FUELS), GetFuelStationData(stationid, FS_FUEL_PRICE), GetFuelStationData(stationid, FS_BUY_FUEL_PRICE), GetFuelStationData(stationid, FS_BALANCE), GetFuelStationData(stationid, FS_RENT_DATE), GetFuelStationData(stationid, FS_LOCK_STATUS), GetFuelStationData(stationid, FS_SQL_ID));
				mysql_query(mysql, query, false);

				format(query, sizeof query, "UPDATE fuel_stations_profit SET view=0 WHERE fid=%d AND view=1",  GetFuelStationData(stationid, FS_SQL_ID));
				mysql_query(mysql, query, false);

				return 1;
			}

			SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 16)");
			return 0;
		}
		return 0;
	}
	return -1;
}

stock FuelStationFillCar(playerid, vehicleid, stationid)
{
	if(IsPlayerDriver(playerid) && IsPlayerInVehicle(playerid, vehicleid))
	{
		if(0 <= stationid <= g_fuel_station_loaded)
		{
			if(!GetFuelStationData(stationid, FS_LOCK_STATUS))
			{
				new fmt_str[150];

				new buy_fuel_pay = GetPVarInt(playerid, "buy_fuel_pay");
				new buy_fuel_count = GetPVarInt(playerid, "buy_fuel_count");

				new price = GetFuelStationData(stationid, FS_FUEL_PRICE) * 10;

				if(GetPlayerMoneyEx(playerid) >= price)
				{
					if((GetVehicleData(vehicleid, V_FUEL) + 10.0) <= 150.0)
					{
						if(GetFuelStationData(stationid, FS_FUELS) >= 10)
						{
							if(IsFuelStationOwned(stationid))
							{
								AddFuelStationData(stationid, FS_FUELS, -, 10);
								AddFuelStationData(stationid, FS_BALANCE, +, price);
							}
							SetVehicleData(vehicleid, V_FUEL, GetVehicleData(vehicleid, V_FUEL) + 10);

							buy_fuel_count += 10;
							buy_fuel_pay += price;

							SetPVarInt(playerid, "buy_fuel_pay", buy_fuel_pay);
							SetPVarInt(playerid, "buy_fuel_count", buy_fuel_count);

							format(fmt_str, sizeof fmt_str, "UPDATE accounts a,fuel_stations f SET a.money=%d,f.fuels=%d,f.balance=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-price, GetFuelStationData(stationid, FS_FUELS), GetFuelStationData(stationid, FS_BALANCE), GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
							mysql_query(mysql, fmt_str, false);

							fmt_str = "";
							GivePlayerMoneyEx(playerid, -price, "Покупка топлива на заправке", false, false);
						}
					else strcat(fmt_str, "~n~~r~~h~no fuel");
					}
					else strcat(fmt_str, "~n~~r~~h~benzobak full");

					format(fmt_str, sizeof fmt_str, "~w~summa: ~g~~h~%d rub~n~~w~litres: ~b~%d%s", buy_fuel_pay, buy_fuel_count, fmt_str);
					GameTextForPlayer(playerid, fmt_str, 3000, 4);
				}
					else SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег для заправки");
			}
					else
			{
				GameTextForPlayer(playerid, "~w~fuel station~n~~r~~h~is closed", 3000, 4);
				//SendClientMessage(playerid, 0xFF6600FF, "Заправочная станция закрыта");
			}
		}
	}
}

stock GetFuelStationMaxFuel(stationid)
{
	new max_fuels = 2500;
	new i_level = GetFuelStationData(stationid, FS_IMPROVEMENTS);

	if(i_level > 3)
		i_level = 3;

	max_fuels += i_level * 2500;
	return max_fuels;
}

stock GetNearestFuelStation(playerid, Float: dist = 15.0)
{
	if(dist == 0.0)
		dist = FLOAT_INFINITY;

	new stationid = -1;
	new Float: my_dist;

	for(new idx; idx < g_fuel_station_loaded; idx ++)
	{
		my_dist = GetPlayerDistanceFromPoint(playerid, GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z));
		if(my_dist < dist)
		{
			dist = my_dist,
			stationid = idx;
		}
	}
	return stationid;
}

stock GetPlayerFuelStation(playerid)
{
	new stationid = GetPlayerData(playerid, P_FUEL_ST);

	if(stationid != -1)
	{
		if(GetFuelStationData(stationid, FS_OWNER_ID) == GetPlayerAccountID(playerid))
		{
			return stationid;
		}
	}
	return -1;
}

