//>> Файл: bykranin_src/core/world/world_01.inc  (673 строк)
//>> Тема: мир: пикапы, чекпоинты, зоны, области, GPS
//>> Внутри: ShowPlayerFuelStationDialog, ShowFuelStationProfit, PresentFlowersToPlayer, ShowPlayerLotteryDialog, CheckNearestGate, OnGateOpened, UpdateFactoryDesk
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: ShowPlayerFuelStationDialog(playerid, operationid)
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		switch(operationid)
		{
			case FUEL_ST_OPERATION_PARAMS:
			{
				Dialog
				(
					playerid, DIALOG_FUEL_STATION_PARAMS, DIALOG_STYLE_LIST,
					"{33AACC}Параметры заправочной станции",
					"1. {669966}Открыть {FFFFFF}или {CC3333}закрыть {FFFFFF}заправочную станцию\n"\
					"2. Новое название\n"\
					"3. Изменить цену на топливо\n"\
					"4. Установить закупочную цену\n"\
					"5. Заказать топливо\n"\
					"6. Отменить заказ\n"\
					"7. Финансовая статистика\n"\
					"8. Улучшить заправочную станцию",
					"Выбрать", "Назад"
				);
			}
			case FUEL_ST_OPERATION_LOCK:
			{
				if(GetFuelStationData(stationid, FS_LOCK_STATUS))
				{
					SetFuelStationData(stationid, FS_LOCK_STATUS, false);
					SendClientMessage(playerid, 0x66CC00FF, "Заправочная станция открыта");
				}
					else
				{
					SetFuelStationData(stationid, FS_LOCK_STATUS, true);
					SendClientMessage(playerid, 0xFF6600FF, "Заправочная станция закрыта");
				}
				UpdateFuelStationLabel(stationid);

				new query[75];
				mysql_format(mysql, query, sizeof query, "UPDATE `fuel_stations` SET `lock`=%d WHERE `id`=%d LIMIT 1", GetFuelStationData(stationid, FS_LOCK_STATUS), GetFuelStationData(stationid, FS_SQL_ID));
				mysql_query(mysql, query, false);

				CallLocalFunction("ShowPlayerFuelStationDialog", "ii", playerid, FUEL_ST_OPERATION_PARAMS);
			}
			case FUEL_ST_OPERATION_NEW_NAME:
			{
				Dialog
				(
					playerid, DIALOG_FUEL_STATION_NAME, DIALOG_STYLE_INPUT,
					"{33AACC}Смена названия",
					"{FFFFFF}Введите новое название для заправочной станции\n\n"\
					"Требования:\n"\
					"- Длина от 3-х до 15-ти символов\n"\
					"- Название не должно противоречить правилам сервера\n"\
					"- Название должно ассоциироваться с заправочными станциями\n\n"\
					"{CC3333}ПРИМЕЧАНИЕ: Новое название не сохранится после рестарта сервера",
					"Сменить", "Назад"
				);
			}
			case FUEL_ST_OPERATION_FUEL_PRICE:
			{
				Dialog
				(
					playerid, DIALOG_FUEL_STATION_PRICE_FUEL, DIALOG_STYLE_INPUT,
					"Цена топлива",
					"{FFFFFF}Укажите отпускную цену за 1 литр\n"\
					"топлива в пределах от 2 до 10 руб.",
					"Готово", "Назад"
				);
			}
			case FUEL_ST_OPERATION_FUEL_ORDER:
			{
				Dialog
				(
					playerid, DIALOG_FUEL_STATION_ORDER_FUELS, DIALOG_STYLE_INPUT,
					"Заказ топлива",
					"{FFFFFF}Сколько литров топлива Вы хотите заказать?",
					"Заказать", "Назад"
				);
			}
			case FUEL_ST_OPERATION_FUEL_ORDER_CA:
			{
				new order_id = GetFuelStationData(stationid, FS_ORDER_ID);

				if(order_id != -1)
				{
					new fmt_str[128];
					format
					(
						fmt_str, sizeof fmt_str,
						"{FFFFFF}Вы действительно хотите отменить заказ?\n"\
						"На счет заправочной станции будет возвращено {FFCD00}%d руб",
						GetOrderData(order_id, O_AMOUNT) * GetOrderData(order_id, O_PRICE)
					);
					Dialog(playerid, DIALOG_FUEL_STATION_ORDER_CANCE, DIALOG_STYLE_MSGBOX, "{33AADD}Отмена заказа", fmt_str, "Да", "Нет");
				}
					else
				{
					SendClientMessage(playerid, 0xFF6600FF, "Вы не оформляли заказ топлива для своей АЗС");
					CallLocalFunction("ShowPlayerFuelStationDialog", "ii", playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case FUEL_ST_OPERATION_PROFIT_STATS:
			{
				new query[256];

				new time = gettime();
				new cur_day = time - (time % 86400);
				new start_day = cur_day - (86400 * 20);

				format(query, sizeof query, "SELECT FROM_UNIXTIME(time, '%%Y-%%m-%%d') AS date, SUM(money) as total FROM fuel_stations_profit WHERE fid=%d AND view=1 AND time >= %d AND time < %d GROUP BY time ORDER BY time DESC LIMIT 20", GetFuelStationData(stationid, FS_SQL_ID), start_day, cur_day);
				mysql_tquery(mysql, query, "ShowFuelStationProfit", "ii", playerid, ++ mysql_race[playerid]);
			}
			case FUEL_ST_OPERATION_IMPROVEMENTS:
			{
				new fmt_str[75];
				new string[300];

				new str_numeric[14 + 1];
				new i_level = GetFuelStationData(stationid, FS_IMPROVEMENTS);

				for(new idx; idx < sizeof(g_fuel_station_improvements); idx ++)
				{
					format(fmt_str, sizeof fmt_str, "%d уровень:\t%s\t", idx + 1, g_fuel_station_improvements[idx][I_NAME]);

					if(idx != 2)
						strcat(fmt_str, "\t");

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

						valfmt(str_numeric, g_fuel_station_improvements[idx][I_PRICE]);
						format(fmt_str, sizeof fmt_str, "%s руб", str_numeric);

						if(i_level == idx)
							strins(fmt_str, "{66CC33}", 0, sizeof fmt_str);
					}
					strcat(fmt_str, "\n");
					strcat(string, fmt_str);
				}
				Dialog(playerid, DIALOG_FUEL_STATION_IMPROVEMENT, DIALOG_STYLE_LIST, "{33AADD}Улучшения для заправочной станции", string, "Купить", "Назад");
			}
		}
	}
	return 1;
}

public: ShowFuelStationProfit(playerid, race)
{
	if(race != mysql_race[playerid])
	{
		new string[600];
		new fmt_str[32];
		new rows = cache_num_rows();

		if(rows)
		{
			string = "Дата\t\t\tПрибыль\n\n{FFFFFF}";
		}
					else string = "{FFFFFF}Финансовая статистика Вашей заправочной станции еще не сформирована";

		for(new idx; idx < rows; idx ++)
		{
			cache_get_row(idx, 0, fmt_str, mysql, sizeof fmt_str);
			strcat(string, fmt_str);

			format(fmt_str, sizeof fmt_str, "\t\t%d руб\n", cache_get_row_int(idx, 1));
			strcat(string, fmt_str);
		}
		Dialog(playerid, DIALOG_FUEL_STATION_INFO, DIALOG_STYLE_MSGBOX, "{33AADD}Доход АЗС за 20 дней", string, "<< Назад", "Закрыть");
	}
}

public: PresentFlowersToPlayer(playerid, to_player)
{
	SetPlayerAmmo(playerid, WEAPON_FLOWER, 0);
	GivePlayerWeapon(to_player, WEAPON_FLOWER, 1);
}

public: ShowPlayerLotteryDialog(playerid)
{
	if(GetPlayerData(playerid, P_LOTTERY) >= 100)
	{
		new hour;
		new fmt_str[632];

		gettime(hour);
		format
		(
			fmt_str, sizeof fmt_str,
			"Ваше счастливое число: {FFCD00}%d\n\n"\
			"{FFFFFF}Вы зарегистрированы в лотерее, результат будет известен во\n"\
			"время ближайшего розыгрыша, который пройдёт в %d:02\n"\
			"Не выходите из игры чтобы принять в нём участие.\n\n"\
			"Выигрыш будет зависеть от того, сколько чисел совпало в\n"\
			"вашем счастливом числе и в числе, которое выпадет во\n"\
			"время розыгрыша (по порядку слева направо):\n\n"\
			"Нет совпадений:\t{FF6633}0 руб\n"\
			"{FFFFFF}1 число:\t\t{66FF00}2000 руб\n"\
			"{FFFFFF}2 числа:\t\t{66FF00}15000 руб\n"\
			"{FFFFFF}Все числа:\t\t{66FF00}50000 руб\n\n"\
			"{FFFFFF}Если Вы хотите изменить счастливое число, введите новые\n"\
			"3 цифры. В противном случае просто нажмите \"Ок\"",
			GetPlayerData(playerid, P_LOTTERY),
			GetElapsedTime(gettime(), g_last_lottery_time) >= 1 ? hour : hour+1
		);
		Dialog(playerid, DIALOG_BIZ_LOTTERY, DIALOG_STYLE_INPUT, "{66CC00}Лотерея", fmt_str, "Ок", "");
	}
}

/*public: SetGateStatus(gateid, bool: status, open_time)
{
	if(open_time != -1)
		SetTimerEx("SetGateStatus", open_time * 1000, false, "iii", gateid, status ^ GATE_STATUS_OPEN, -1);

	switch(GetGateData(gateid, G_TYPE))
	{
		case
			GATE_TYPE_BARRIER,
			GATE_TYPE_BARRIER_MSG,
			GATE_TYPE_BARRIER_BUTTON:
		{
			MoveDynamicObject(g_gate[gateid][G_OBJECT_ID][1], GetGateData(gateid, G_POS_X) + (status == GATE_STATUS_CLOSE ? 0.01 : -0.01), GetGateData(gateid, G_POS_Y), GetGateData(gateid, G_POS_Z) + 0.8, 0.01, 0.0, status == GATE_STATUS_CLOSE ? -90.0 : -10.0, GetGateData(gateid, G_ANGLE));
		}
		case GATE_TYPE_NORMAL:
		{

		}
	}
	SetGateData(gateid, G_STATUS, status);
}

public: CheckNearestGate(playerid)
{
	new gateid = GetNearestGate(playerid, 10.0);
	if(gateid != -1)
	{
		new open_time = 8;
		new bool: access = false;

		switch(gateid)
		{
			case GATE_ID_DRIVING_SCHOOL:
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				new type = GetVehicleData(vehicleid, V_ACTION_TYPE);

				if(type == VEHICLE_ACTION_TYPE_DRIVING_SCH)
				{
					if(GetPlayerDrivingExamInfo(playerid, DE_POINTS) >= 9)
					{
						access = true;
					}
				}
			}
			default:
				access = true;
		}

		if(access)
		{
			OnGateOpened(playerid, gateid, open_time);
		}
		return 1;
	}
	return 0;
}

public: OnGateOpened(playerid, gateid, open_time)
{
	new type = GetGateData(gateid, G_TYPE);
	new bool: status = GetGateData(gateid, G_STATUS);

	switch(type)
	{
		case GATE_TYPE_BARRIER, GATE_TYPE_BARRIER_MSG:
		{
			if(status == GATE_STATUS_OPEN) return 0;

			if(type == GATE_TYPE_BARRIER_MSG)
			{
				new fmt_str[64];

				if(strlen(GetGateData(gateid, G_DESCRIPTION)))
				{
					format(fmt_str, sizeof fmt_str, "[%s] Шлагбаум закроется через %d секунд", GetGateData(gateid, G_DESCRIPTION), open_time - 3);
				}
					else format(fmt_str, sizeof fmt_str, "Шлагбаум закроется через %d секунд", open_time - 3);
				SendClientMessage(playerid, 0x66CC00FF, fmt_str);
			}
		}
		case GATE_TYPE_BARRIER_BUTTON:
		{
			open_time = -1;
		}
		case GATE_TYPE_NORMAL:
		{

		}
	}
	SetGateStatus(gateid, status ^ GATE_STATUS_OPEN, open_time);

	return 1;
}*/

public: UpdateFactoryDesk(deskid)
{
	new fmt_str[64];

	format(fmt_str, sizeof fmt_str, "Рабочее место №%d\n%s", deskid + 1, factory_desk[deskid][FD_USED] ? ("{FF6600}Занято") : ("{33CC00}Свободно"));
	UpdateDynamic3DTextLabelText(factory_desk[deskid][FD_LABEl], 0xFFFFFFEE, fmt_str);
}

/*public: T_RemovePlayerAttachedObject(playerid, slot)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
	{
		RemovePlayerAttachedObject(playerid, slot);
	}
}*/

#if defined RAND_WEATHER
public: SetRandomWeather()
{
	/*new fmt_str[64];
	new rand = random(sizeof g_weather);

	SendClientMessageToAll(0x3399FFFF, "[Прогноз погоды]");

	format(fmt_str, sizeof fmt_str, "В области ожидается %s {99CC00}(+%d °С)", g_weather[rand][W_NAME], g_weather[rand][W_DEGREES]);
	SendClientMessageToAll(0xFFFFFFFF, fmt_str);

	SetWeather(g_weather[rand][W_ID]);*/
	SetWeather(11);
	return true;
}
#endif

public: ClearBanList()
{
	new query[64];
	new time = gettime();

	format(query, sizeof query, "SELECT ip FROM ban_list WHERE ban_time <= %d", time);
	mysql_tquery(mysql, query, "UnBanIPs", "i", time);

	return 1;
}

public: UnBanIPs(time)
{
	new ip[16];
	new query[64];
	new rows = cache_num_rows();

	if(rows)
	{
		for(new idx; idx < rows; idx ++)
		{
			cache_get_row(idx, 0, ip);

			format(query, sizeof query, "unbanip %s", ip);
			SendRconCommand(query);
		}
		SendRconCommand("reloadbans");

		format(query, sizeof query, "DELETE FROM ban_list WHERE ban_time <= %d", time);
		mysql_query(mysql, query, false);
	}
	return 1;
}

public: PlayerOwnableCarInit(playerid)
{
	new index;
	new vehicleid = -1;

	while(vehicleid < MAX_VEHICLES-1)
	{
		vehicleid ++;
		index = GetVehicleData(vehicleid, V_ACTION_ID);

		if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR) continue;
		if(GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid)) continue;

		SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);
		break;
	}
}

public: SaveOwnableCar(vehicleid)
{
	if(IsAOwnableCar(vehicleid))
	{
		new query[360];
		new index = GetVehicleData(vehicleid, V_ACTION_ID);

		new Float: health;

		GetVehicleHealth(vehicleid, health);

		format
		(
			query, sizeof query,
			"UPDATE ownable_cars SET "\
			"pos_x=%f,"\
			"pos_y=%f,"\
			"pos_z=%f,"\
			"angle=%f,"\
			"status=%d,"\
			"alarm=%d,"\
			"key_in=%d,"\
			"mileage=%f,"\
			"fuel=%f,"\
			"health=%f,"\
			"number='%s'"\
			" WHERE id=%d LIMIT 1",
			GetOwnableCarData(index, OC_POS_X),
			GetOwnableCarData(index, OC_POS_Y),
			GetOwnableCarData(index, OC_POS_Z),
			GetOwnableCarData(index, OC_ANGLE),
			GetVehicleParam(vehicleid, V_LOCK),
			VEHICLE_PARAM_OFF, // active GTA alarm is never persisted across spawns
			GetOwnableCarData(index, OC_KEY_IN),
			GetVehicleData(vehicleid, V_MILEAGE),
			GetVehicleData(vehicleid, V_FUEL),
			GetVehicleData(vehicleid, V_HEALTH),
			GetOwnableCarData(index, OC_NUMBER),
			GetOwnableCarData(index, OC_SQL_ID)
		);
		mysql_query(mysql, query, false);

		g_ownable_mileage_saved[vehicleid] = GetVehicleData(vehicleid, V_MILEAGE);
		g_ownable_mileage_sync_time[vehicleid] = gettime();
        g_ownable_fuel_saved[vehicleid] = GetVehicleData(vehicleid, V_FUEL);
        g_ownable_fuel_sync_time[vehicleid] = gettime();

		return mysql_errno();
	}
	return -1;
}

stock SaveOwnableCarMileage(vehicleid)
{
	if(!IsAOwnableCar(vehicleid)) return 0;

	new index = GetVehicleData(vehicleid, V_ACTION_ID);
	if(index < 0) return 0;

	new sql_id = GetOwnableCarData(index, OC_SQL_ID);
	if(sql_id <= 0) return 0;

	new query[128];
	mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET mileage=%f WHERE id=%d LIMIT 1", GetVehicleData(vehicleid, V_MILEAGE), sql_id);
	mysql_tquery(mysql, query);

	return 1;
}
stock SaveOwnableCarFuel(vehicleid)
{
	if(!IsAOwnableCar(vehicleid)) return 0;

	new index = GetVehicleData(vehicleid, V_ACTION_ID);
	if(index < 0) return 0;

	new sql_id = GetOwnableCarData(index, OC_SQL_ID);
	if(sql_id <= 0) return 0;

	new query[128];
	mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET fuel=%f WHERE id=%d LIMIT 1", GetVehicleData(vehicleid, V_FUEL), sql_id);
	mysql_tquery(mysql, query);

	return 1;
}


public: ShowTrunkDialog(playerid, vehicleid, view)
{
	new count, type;

	new fmt_str[36];
	new string[(sizeof fmt_str) * MAX_VEHICLE_TRUNK_SLOTS + 1];

	ClearPlayerListitemValues(playerid);
	for(new idx; idx < MAX_VEHICLE_TRUNK_SLOTS; idx ++)
	{
		if(IsTrunkFreeSlot(vehicleid, idx)) continue;

		type = GetTrunkData(vehicleid, idx, VT_ITEM_TYPE);

		format(fmt_str, sizeof fmt_str, "%d. %s:\t{66CC00}%d %s\n", count + 1, GetItemInfo(type, I_NAME), GetTrunkData(vehicleid, idx, VT_ITEM_AMOUNT), GetItemInfo(type, I_NAME_COUNT));
		strcat(string, fmt_str);

		SetPlayerListitemValue(playerid, count ++, idx);
	}

	if(!view)
	{
		SetPlayerListitemValue(playerid, count, -1);
		SetPlayerUseTrunk(playerid, vehicleid);

		format(fmt_str, sizeof fmt_str, "{888888}%d. Положить", count + 1);
		strcat(string, fmt_str);

		Dialog(playerid, DIALOG_VEHICLE_TRUNK, DIALOG_STYLE_LIST, "{0099FF}Содержимое багажника", string, "Выбрать", "Закрыть");
	}
					else
	{
		if(!count)
			strcat(string, "{888888}Пусто");

		SetPlayerUseTrunk(playerid, INVALID_VEHICLE_ID);
		Dialog(playerid, DIALOG_VEHICLE_TRUNK, DIALOG_STYLE_LIST, "{0099FF}Содержимое багажника", string, "Закрыть", "");
	}
	return 1;
}

// ------------------------------------------
stock GetTrunkFreeSlot(vehicleid, item_type)
{
	new free_slot = -1, comb_slot = -1;
	new bool: comb = GetItemInfo(item_type, I_COMBINATION);

	for(new idx; idx < MAX_VEHICLE_TRUNK_SLOTS; idx ++)
	{
		if(GetTrunkData(vehicleid, idx, VT_ITEM_TYPE) == item_type && comb)
		{
			comb_slot = idx;
		}
					else if(free_slot == -1 && IsTrunkFreeSlot(vehicleid, idx))
		{
			free_slot = idx;
		}
					else continue;
	}
	return comb_slot != -1 ? comb_slot : free_slot;
}

stock GetTrunkBusySlot(vehicleid, item_type)
{
	new busy_slot = -1;

	for(new idx; idx < MAX_VEHICLE_TRUNK_SLOTS; idx ++)
	{
		if(GetTrunkData(vehicleid, idx, VT_ITEM_TYPE) == item_type)
		{
			busy_slot = idx;
		}
					else continue;
	}
	return busy_slot;
}

stock AddTrunkItem(vehicleid, item_id, amount, value = 0)
{
	if(1 <= item_id <= sizeof(g_item_type)-1)
	{
		new free_slot = GetTrunkFreeSlot(vehicleid, item_id);
		if(free_slot != -1)
		{
			SetTrunkData(vehicleid, free_slot, VT_SQL_ID, 1);

			SetTrunkData(vehicleid, free_slot, VT_ITEM_TYPE, item_id);
			SetTrunkData(vehicleid, free_slot, VT_ITEM_VALUE, value);

			new query[100],
				index,
				oc_id;

			index = GetVehicleData(vehicleid, V_ACTION_ID);
			oc_id = GetOwnableCarData(index, OC_SQL_ID);

			if(!IsTrunkFreeSlot(vehicleid, free_slot))
			{
				AddTrunkData(vehicleid, free_slot, VT_ITEM_AMOUNT, +, amount);

				if((GetTrunkData(vehicleid, free_slot, VT_ITEM_AMOUNT) - amount) == 0)
				{
					mysql_format(mysql, query, sizeof query, "INSERT INTO trunks (oc_id,item_id,amount,value) VALUES (%d,%d,%d,%d)", oc_id, item_id, amount, value);
					mysql_query(mysql, query, false);
				}
					else
				{
					mysql_format(mysql, query, sizeof query, "UPDATE trunks SET amount='%d' WHERE item_id='%d' AND oc_id='%d' LIMIT 1", GetTrunkData(vehicleid, free_slot, VT_ITEM_AMOUNT), item_id, oc_id);
					mysql_query(mysql, query, false);
				}
			}
					else
			{
				SetTrunkData(vehicleid, free_slot, VT_ITEM_AMOUNT, amount);

				mysql_format(mysql, query, sizeof query, "INSERT INTO trunks (oc_id,item_id,amount,value) VALUES (%d,%d,%d,%d)", oc_id, item_id, amount, value);
				mysql_query(mysql, query, false);
			}

			return 1;
		}
		return -1;
	}
	return 0;
}


stock TakeTrunkItem(vehicleid, item_id, amount)
{
	if(1 <= item_id <= sizeof(g_item_type)-1)
	{
		new busy_slot = GetTrunkBusySlot(vehicleid, item_id);

		new query[100],
			index,
			oc_id;

		index = GetVehicleData(vehicleid, V_ACTION_ID);
		oc_id = GetOwnableCarData(index, OC_SQL_ID);

		if(!IsTrunkFreeSlot(vehicleid, busy_slot))
		{
			AddTrunkData(vehicleid, busy_slot, VT_ITEM_AMOUNT, -, amount);

			if(GetTrunkData(vehicleid, busy_slot, VT_ITEM_AMOUNT) >= 0)
			{
				if(!GetTrunkData(vehicleid, busy_slot, VT_ITEM_AMOUNT))
				{
					mysql_format(mysql, query, sizeof query, "DELETE FROM trunks WHERE item_id='%d' AND oc_id='%d'", item_id, oc_id);
					mysql_query(mysql, query, false);

					RemoveTrunkItem(vehicleid, busy_slot);
				}
					else
				{
					mysql_format(mysql, query, sizeof query, "UPDATE trunks SET amount='%d' WHERE item_id='%d' AND oc_id='%d' LIMIT 1", GetTrunkData(vehicleid, busy_slot, VT_ITEM_AMOUNT), item_id, oc_id);
					mysql_query(mysql, query, false);
				}
				return 1;
			}
					else
			{
				AddTrunkData(vehicleid, busy_slot, VT_ITEM_AMOUNT, +, amount);
				return -1;
			}
		}
		return -1;
	}
	return 0;
}

stock RemoveTrunkItem(vehicleid, item_slot)
{
	if(!IsTrunkFreeSlot(vehicleid, item_slot))
	{
		SetTrunkData(vehicleid, item_slot, VT_SQL_ID,	0);

		SetTrunkData(vehicleid, item_slot, VT_ITEM_TYPE, 	0);
		SetTrunkData(vehicleid, item_slot, VT_ITEM_AMOUNT, 	0);
		SetTrunkData(vehicleid, item_slot, VT_ITEM_VALUE, 	0);

		return 1;
	}
	return 0;
}

