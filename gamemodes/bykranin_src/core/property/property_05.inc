//>> Файл: bykranin_src/core/property/property_05.inc  (579 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: GetOwnableCarBySqlID, SaveOwnableCarUnloadPosition, GetOwnableCarUnloadPosition, ResetOwnableCarUnloadPosition, GetOwnableCarParkPosition, ResetOwnableCarParkPosition, GetPlayerIDBySqlID
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock GetOwnableCarBySqlID(sql_id, buffer[] = {0, 0, 0})
{
	buffer[2] = INVALID_VEHICLE_ID;
	for(buffer[0] = 1; buffer[0] < MAX_VEHICLES; buffer[0] ++)
	{
		if(!IsAOwnableCar(buffer[0])) continue;
		buffer[1] = GetVehicleData(buffer[0], V_ACTION_ID);

		if(GetOwnableCarData(buffer[1], OC_SQL_ID) != sql_id) continue;

		buffer[2] = buffer[0];
		break;
	}
	return buffer[2];
}

stock SaveOwnableCarUnloadPosition(sql_id, Float:x, Float:y, Float:z, Float:a)
{
    if(sql_id <= 0) return 0;

    new slot = -1;
    for(new i = 0; i < MAX_OWNABLE_CARS; i++)
    {
        if(!g_ownable_unload_pos_set[i])
        {
            if(slot == -1) slot = i;
            continue;
        }

        if(g_ownable_unload_sql[i] == sql_id)
        {
            slot = i;
            break;
        }
    }

    if(slot == -1) slot = sql_id % MAX_OWNABLE_CARS;

    g_ownable_unload_pos_set[slot] = true;
    g_ownable_unload_sql[slot] = sql_id;
    g_ownable_unload_pos[slot][0] = x;
    g_ownable_unload_pos[slot][1] = y;
    g_ownable_unload_pos[slot][2] = z;
    g_ownable_unload_pos[slot][3] = a;
    return 1;
}

stock bool:GetOwnableCarUnloadPosition(sql_id, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(sql_id <= 0) return false;

    for(new i = 0; i < MAX_OWNABLE_CARS; i++)
    {
        if(!g_ownable_unload_pos_set[i]) continue;
        if(g_ownable_unload_sql[i] != sql_id) continue;

        x = g_ownable_unload_pos[i][0];
        y = g_ownable_unload_pos[i][1];
        z = g_ownable_unload_pos[i][2];
        a = g_ownable_unload_pos[i][3];
        return true;
    }
    return false;
}

stock ResetOwnableCarUnloadPosition(sql_id)
{
    if(sql_id <= 0) return 0;

    for(new i = 0; i < MAX_OWNABLE_CARS; i++)
    {
        if(!g_ownable_unload_pos_set[i]) continue;
        if(g_ownable_unload_sql[i] != sql_id) continue;

        g_ownable_unload_pos_set[i] = false;
        g_ownable_unload_sql[i] = 0;
        g_ownable_unload_pos[i][0] = 0.0;
        g_ownable_unload_pos[i][1] = 0.0;
        g_ownable_unload_pos[i][2] = 0.0;
        g_ownable_unload_pos[i][3] = 0.0;
        return 1;
    }
    return 0;
}

stock bool:GetOwnableCarParkPosition(sql_id, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(sql_id <= 0) return false;

    new vehicleid = GetOwnableCarBySqlID(sql_id);
    if(vehicleid != INVALID_VEHICLE_ID)
    {
        new index = GetVehicleData(vehicleid, V_ACTION_ID);
        if(index >= 0)
        {
            x = GetOwnableCarData(index, OC_POS_X);
            y = GetOwnableCarData(index, OC_POS_Y);
            z = GetOwnableCarData(index, OC_POS_Z);
            a = GetOwnableCarData(index, OC_ANGLE);
            return true;
        }
    }

    new query[96], Cache:result;
    mysql_format(mysql, query, sizeof query, "SELECT pos_x, pos_y, pos_z, angle FROM ownable_cars WHERE id=%d LIMIT 1", sql_id);
    result = mysql_query(mysql, query, true);

    if(!cache_num_rows(result))
    {
        cache_delete(result);
        return false;
    }

    x = cache_get_row_float(0, 0);
    y = cache_get_row_float(0, 1);
    z = cache_get_row_float(0, 2);
    a = cache_get_row_float(0, 3);
    cache_delete(result);
    return true;
}

stock ResetOwnableCarParkPosition(playerid, sql_id)
{
    if(sql_id <= 0) return 0;

    new query[180];
    mysql_format(mysql, query, sizeof query,
        "UPDATE ownable_cars SET pos_x=%f,pos_y=%f,pos_z=%f,angle=%f WHERE id=%d AND owner_id=%d LIMIT 1",
        g_ownable_default_park_pos[0],
        g_ownable_default_park_pos[1],
        g_ownable_default_park_pos[2],
        g_ownable_default_park_pos[3],
        sql_id,
        GetPlayerAccountID(playerid)
    );
    mysql_query(mysql, query, false);
    if(mysql_errno()) return 0;

    new vehicleid = GetOwnableCarBySqlID(sql_id);
    if(vehicleid != INVALID_VEHICLE_ID)
    {
        new index = GetVehicleData(vehicleid, V_ACTION_ID);
        if(index >= 0)
        {
            SetOwnableCarData(index, OC_POS_X, g_ownable_default_park_pos[0]);
            SetOwnableCarData(index, OC_POS_Y, g_ownable_default_park_pos[1]);
            SetOwnableCarData(index, OC_POS_Z, g_ownable_default_park_pos[2]);
            SetOwnableCarData(index, OC_ANGLE, g_ownable_default_park_pos[3]);
        }
    }

    ResetOwnableCarUnloadPosition(sql_id);
    return 1;
}

stock GetPlayerIDBySqlID(sql_id)
{
	new playerid = INVALID_PLAYER_ID;

	foreach(new idx : Player)
	{
		if(!IsPlayerLogged(idx)) continue;
		if(GetPlayerAccountID(idx) != sql_id) continue;

		playerid = idx;
		break;
	}
	return playerid;
}

stock GetPlayerID(const name[], playerid=INVALID_PLAYER_ID)
{
	sscanf(name, "u", playerid);

	return playerid;
}

stock GetPlayerSqlIDByName(name[])
{
	new sql_id,
		query[80],
		Cache: result;

	mysql_format(mysql, query, sizeof query, "SELECT id FROM `accounts` WHERE name = '%s' LIMIT 1", name);
	result = mysql_query(mysql, query, true);

	sql_id = cache_num_rows(result) ? cache_get_row_int(0, 0) : -1;

	cache_delete(result);

	return sql_id;
}

stock GetPlayerNameBySqlID(sql_id)
{
	new name[21] = "none",
		query[80],
		Cache: result;

	mysql_format(mysql, query, sizeof query, "SELECT name FROM `accounts` WHERE id = '%e' LIMIT 1", sql_id);
	result = mysql_query(mysql, query, true);

	if(cache_num_rows(result))
		cache_get_row(0, 0, name);

	cache_delete(result);

	return name;
}

stock UpdateHouse(houseid)
{
	if(GetHouseData(houseid, H_ENTRACE) == -1)
	{
		if(GetHouseData(houseid, H_ENTER_PICKUP))
			DestroyPickup(GetHouseData(houseid, H_ENTER_PICKUP));

		if(IsValidDynamicMapIcon(GetHouseData(houseid, H_MAP_ICON)))
			DestroyDynamicMapIcon(GetHouseData(houseid, H_MAP_ICON));

		SetHouseData(houseid, H_ENTER_PICKUP, CreatePickup((IsHouseOwned(houseid) ? 1272 : 1273), 23, GetHouseData(houseid, H_POS_X), GetHouseData(houseid, H_POS_Y), GetHouseData(houseid, H_POS_Z), 0, PICKUP_ACTION_TYPE_HOUSE, houseid));
		SetHouseData(houseid, H_MAP_ICON, CreateDynamicMapIcon(GetHouseData(houseid, H_POS_X), GetHouseData(houseid, H_POS_Y), GetHouseData(houseid, H_POS_Z), (IsHouseOwned(houseid) ? 32 : 31), 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL));
	}
}

stock HouseHealthInit(houseid, type = -1)
{
	if(GetHouseData(houseid, H_IMPROVEMENTS) >= 2)
	{
		if(!GetHouseData(houseid, H_HEALTH_PICKUP))
		{
			type = GetHouseData(houseid, H_TYPE);
			SetHouseData(houseid, H_HEALTH_PICKUP, CreatePickup(1240, 23, GetHouseTypeInfo(type, HT_HEALTH_POS_X), GetHouseTypeInfo(type, HT_HEALTH_POS_Y), GetHouseTypeInfo(type, HT_HEALTH_POS_Z), houseid + 2000, PICKUP_ACTION_TYPE_HOUSE_HEALTH, houseid));
		}
	}
					else
	{
		if(GetHouseData(houseid, H_HEALTH_PICKUP))
		{
			DestroyPickup(GetHouseData(houseid, H_HEALTH_PICKUP));
			SetHouseData(houseid, H_HEALTH_PICKUP, 0);
		}
	}
}

stock HouseStoreInit(houseid, type = -1)
{
	if(GetHouseData(houseid, H_IMPROVEMENTS) >= 5)
	{
		if(GetHouseData(houseid, H_STORE_LABEL) == Text3D:-1)
		{
			if(GetHouseData(houseid, H_STORE_X) == 0.0 && GetHouseData(houseid, H_STORE_Y) == 0.0 && GetHouseData(houseid, H_STORE_Z) == 0.0)
			{
				type = GetHouseData(houseid, H_TYPE);

				SetHouseData(houseid, H_STORE_X, GetHouseTypeInfo(type, HT_STORE_POS_X));
				SetHouseData(houseid, H_STORE_Y, GetHouseTypeInfo(type, HT_STORE_POS_Y));
				SetHouseData(houseid, H_STORE_Z, GetHouseTypeInfo(type, HT_STORE_POS_Z));
			}
			SetHouseData(houseid, H_STORE_LABEL, CreateDynamic3DTextLabel("Шкаф", 0xFFFF00FF, GetHouseData(houseid, H_STORE_X), GetHouseData(houseid, H_STORE_Y), GetHouseData(houseid, H_STORE_Z) + 0.5, 6.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, houseid + 2000, -1, -1, 50.0));

			CallLocalFunction("UpdateHouseStore", "i", houseid);
		}
	}
					else
	{
		if(GetHouseData(houseid, H_STORE_LABEL) != Text3D:-1)
		{
			if(IsValidDynamic3DTextLabel(GetHouseData(houseid, H_STORE_LABEL)))
			{
				DestroyDynamic3DTextLabel(GetHouseData(houseid, H_STORE_LABEL));
				SetHouseData(houseid, H_STORE_LABEL, Text3D:-1);
			}
		}
	}
}

stock SellHouse(playerid, to_player = INVALID_PLAYER_ID, price = 0)
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		new house_price = GetHouseData(houseid, H_PRICE);
		new house_percent = (house_price * 30) / 100;
		new house_improvemnts_price = HouseImprovementsPrice(houseid);

		if(house_improvemnts_price)
			house_improvemnts_price = (house_improvemnts_price * 60) / 100;

		new query[200];
		new return_money = (house_price - house_percent) + house_improvemnts_price;

		CallLocalFunction("EvictHouseRentersAll", "i", houseid);

		SetPlayerData(playerid, P_HOUSE, -1);
		SetPlayerData(playerid, P_HOUSE_TYPE, HOUSE_TYPE_NONE);

		SetHouseData(houseid, H_OWNER_ID, 0);

		if(to_player == INVALID_PLAYER_ID)
		{
			AddPlayerData(playerid, P_BANK, +, return_money);

			BankLog(playerid, return_money, "Продажа дома");

			SetHouseData(houseid, H_IMPROVEMENTS,	0);

			SetHouseData(houseid, H_RENT_DATE,		0);
			SetHouseData(houseid, H_LOCK_STATUS,	false);

			format(query, sizeof query, "UPDATE accounts a,houses h SET a.bank=%d,a.house_type=-1,a.house=-1,h.owner_id=0,h.lock=0 WHERE a.id=%d AND h.id=%d", GetPlayerData(playerid, P_BANK), GetPlayerAccountID(playerid), GetHouseData(houseid, H_SQL_ID));
			mysql_query(mysql, query, false);

			UpdateHouse(houseid);

			HouseHealthInit(houseid);
			HouseStoreInit(houseid);

			GivePlayerMoneyEx(playerid, 0, "Продажа дома государству", false, false);

			format(query, sizeof query, "Налог за продажу дома составил 30 процентов от его стоимости {99CC00}(%d руб)", house_percent);
			SendClientMessage(playerid, 0xCECECEFF, query);

			format(query, sizeof query, "Вам было возвращено 60 процентов от стоимости купленных улучшений: {CCFF00}%d руб", house_improvemnts_price);
			SendClientMessage(playerid, 0xCECECEFF, query);
			
			format(query, sizeof query, "Вам было возвращено 60 процентов от стоимости купленных улучшений подвала: {CCFF00}%d руб", house_improvemnts_price);
			SendClientMessage(playerid, 0xCECECEFF, query);

			format(query, sizeof query, "Итого на банковский счет перечислено: {3399FF}%d руб", return_money);
			SendClientMessage(playerid, 0xFFFFFFFF, query);

			new entranceid = GetHouseData(houseid, H_ENTRACE);
			if(entranceid != -1)
			{
				CallLocalFunction("EntranceStatusInit", "i", entranceid);
			}
		}
					else
		{
			if(BuyPlayerHouse(to_player, houseid, true, price) == 1)
			{
				new total_price = price + house_improvemnts_price;

				format(query, sizeof query, "Вам было возвращено 60 процентов от стоимости купленных улучшений: {CCFF00}%d руб", house_improvemnts_price);
				SendClientMessage(playerid, 0xCECECEFF, query);

				format(query, sizeof query, "UPDATE accounts SET money=%d,house=-1 WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)+total_price, GetPlayerAccountID(playerid));
				mysql_query(mysql, query, false);

				GivePlayerMoneyEx(playerid, total_price, "Продажа дома игроку", false, false);

				house_price = price;
				house_percent = 0;
			}
					else return ;
		}
		format(query, sizeof query, "~g~+%d rub~n~+%d rub", (house_price - house_percent), house_improvemnts_price);
		GameTextForPlayer(playerid, query, 4000, 1);
	}
}

stock BuyPlayerHouse(playerid, houseid, bool: buy_from_owner = false, price = -1)
{
	if(!IsHouseOwned(houseid) && GetPlayerHouse(playerid) == -1)
	{
		if(price <= 0)
			price = GetHouseData(houseid, H_PRICE);

		if(GetPlayerMoneyEx(playerid) >= price)
		{
			new query[256];

			format(query, sizeof query, "UPDATE accounts a, houses h SET a.money=%d,a.house_type=%d,a.house=%d,h.owner_id=%d WHERE a.id=%d AND h.id=%d", GetPlayerMoneyEx(playerid)-price, HOUSE_TYPE_HOME, houseid, GetPlayerAccountID(playerid), GetPlayerAccountID(playerid), GetHouseData(houseid, H_SQL_ID));
			mysql_query(mysql, query, false);
			printf("sql %s", query);

			if(!mysql_errno())
			{
				SetPlayerData(playerid, P_HOUSE, 		houseid);
				SetPlayerData(playerid, P_HOUSE_TYPE, 	HOUSE_TYPE_HOME);

				SetHouseData(houseid, H_OWNER_ID, GetPlayerAccountID(playerid));
				SetHouseData(houseid, H_IMPROVEMENTS, 	0);

				SetHouseData(houseid, H_STORE_X, 0.0);
				SetHouseData(houseid, H_STORE_Y, 0.0);
				SetHouseData(houseid, H_STORE_Z, 0.0);

				new time = gettime();
				new rent_time = (time - (time % 86400)) + 86400;

				if(!buy_from_owner)
				{
					SetHouseData(houseid,	H_RENT_DATE,	rent_time);
					SetHouseData(houseid,	H_LOCK_STATUS,	false);

					new entranceid = GetHouseData(houseid, H_ENTRACE);
					if(entranceid != -1)
					{
						CallLocalFunction("EntranceStatusInit", "i", entranceid);
					}
				}
					else
				{
					if(GetElapsedTime(GetHouseData(houseid, H_RENT_DATE), time, CONVERT_TIME_TO_DAYS) <= 0)
					{
						SetHouseData(houseid, H_RENT_DATE, rent_time);
					}
				}
				format(g_house[houseid][H_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);

				UpdateHouse(houseid);

				HouseHealthInit(houseid);
				HouseStoreInit(houseid);

				GivePlayerMoneyEx(playerid, -price, "Покупка дома", false, true);
				SendClientMessage(playerid, 0x66CC00FF, "{FFFFFF}Поздравляем с успешным приобретением нового дома / квартиры.");
				SendClientMessage(playerid, 0xFFCC00FF, "{FFFFFF}Чтобы сменить место своего появления воспользуйтесь командой: {ffff00} /setspawn.");

				format(query, sizeof query, "UPDATE houses SET improvements=0,rent_time=%d,`lock`=%d,store_x=0.0,store_y=0.0,store_z=0.0 WHERE id=%d LIMIT 1", GetHouseData(houseid, H_RENT_DATE), GetHouseData(houseid, H_LOCK_STATUS), GetHouseData(houseid, H_SQL_ID));
				mysql_query(mysql, query, false);

				return 1;
			}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 34)");

			return 0;
		}
		return 0;
	}
	return -1;
}

stock EnterPlayerToHouse(playerid, houseid)
{
	if(GetPlayerInHouse(playerid) == -1)
	{
		new type = GetHouseData(houseid, H_TYPE);

		SetPlayerPosEx
		(
			playerid,
			GetHouseTypeInfo(type, HT_ENTER_POS_X),
			GetHouseTypeInfo(type, HT_ENTER_POS_Y),
			GetHouseTypeInfo(type, HT_ENTER_POS_Z),
			GetHouseTypeInfo(type, HT_ENTER_POS_ANGLE),
			GetHouseTypeInfo(type, HT_INTERIOR),
			houseid + 2000
		);
		SetPlayerInHouse(playerid, houseid);
	}
}

stock ExitPlayerFromHouse(playerid, Float: radius = 3.0, pos = 0)
{
	new houseid = GetPlayerInHouse(playerid);
	if(houseid != -1)
	{
		new type = GetHouseData(houseid, H_TYPE);
		if(IsPlayerInRangeOfPoint(playerid, radius, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z)) || IsPlayerInRangeOfPoint(playerid, radius, 1.2011, 1994.7356, 1554.2031))
		{
			switch(pos)
			{
				case 0:
				{
					SetPlayerInHouse(playerid, -1);

					new entranceid = GetHouseData(houseid, H_ENTRACE);
					if(entranceid != -1)
					{
						new floor = GetHouseData(houseid, H_FLAT_ID) / 4 + 1;
						type = GetHouseData(houseid, H_FLAT_ID) % 4;

						SetPlayerInEntrance(playerid, entranceid);
						SetPlayerInEntranceFloor(playerid, floor);

						SetPlayerPosEx
						(
							playerid,
							g_entrance_flat_pos[type][3],
							g_entrance_flat_pos[type][4],
							g_entrance_flat_pos[type][2],
							g_entrance_flat_pos[type][5],
							floor + 1,
							(entranceid * 100) + floor
						);
					}
					else
					{
						SetPlayerPosEx
						(
							playerid,
							GetHouseData(houseid, H_EXIT_POS_X),
							GetHouseData(houseid, H_EXIT_POS_Y),
							GetHouseData(houseid, H_EXIT_POS_Z),
							GetHouseData(houseid, H_EXIT_ANGLE),
							0,
							0
						);
					}
				}
				case 1:
				{
					
					SetPlayerPosEx
					(
						playerid,
						1.2011,
						1994.7356,
						1554.2031,
						353.9531,
						GetHouseTypeInfo(type, HT_INTERIOR),
						houseid + 2000
					);
					
				}
			}
			
			return 1;
		}
	}
	return 0;
}

stock GetPlayerHouse(playerid, type = -1)
{
	new houseid = GetPlayerData(playerid, P_HOUSE);
	if(houseid != -1)
	{
		switch(type)
		{
			case HOUSE_TYPE_HOME:
			{
				if(GetPlayerData(playerid, P_HOUSE_TYPE) == HOUSE_TYPE_HOME)
				{
					if(GetHouseData(houseid, H_OWNER_ID) == GetPlayerAccountID(playerid))
					{
						return houseid;
					}
				}
			}
			case HOUSE_TYPE_ROOM:
			{
				if(GetPlayerData(playerid, P_HOUSE_TYPE) == HOUSE_TYPE_ROOM)
				{
					new room = GetPlayerData(playerid, P_HOUSE_ROOM);
					if(room != -1)
					{
						if(GetHouseRenterInfo(houseid, room, HR_OWNER_ID) == GetPlayerAccountID(playerid))
						{
							return houseid;
						}
					}
				}
			}
			case HOUSE_TYPE_HOTEL:
			{
				if(GetPlayerData(playerid, P_HOUSE_TYPE) == HOUSE_TYPE_HOTEL)
				{
					new room = GetPlayerData(playerid, P_HOUSE_ROOM);
					if(room != -1)
					{
						if(GetHotelData(houseid, room, H_OWNER_ID) == GetPlayerAccountID(playerid))
						{
							return houseid;
						}
					}
				}
			}
			default:
				return houseid;
		}
	}
	return -1;
}

