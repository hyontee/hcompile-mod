//>> Файл: bykranin_src/core/callbacks/callbacks_03.inc  (291 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerLeaveCheckpoint, OnPlayerEnterRaceCheckpoint, OnPlayerLeaveRaceCheckpoint, OnRconCommand, OnObjectMoved, OnPlayerObjectMoved, Hospital_IsUsableSpawnSkin
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);

	new action_type = GetPlayerRaceCPInfo(playerid, RCP_ACTION_TYPE);
	new vehicleid = GetPlayerVehicleID(playerid);
	
	
	if(IsPlayerInRaceCheckpoint(playerid))
	{
		switch(action_type)
		{
			case RCP_ACTION_TYPE_DRIVING_EXAM:
			{
				if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_DRIVING_SCH)
				{
					new step = GetPlayerDrivingExamInfo(playerid, DE_ROUTE_STEP);

					if(step >= sizeof driving_exam_route - 1)
					{
						ClearPlayerDrivingExamInfo(playerid);
						DisablePlayerRaceCheckpoint(playerid);

						new Float: health = GetPVarFloat(playerid, "car_damage");
						SetVehicleToRespawn(vehicleid);

						if(health < 900.0)
						{
							SetPlayerData(playerid, P_DRIVING_LIC, 0);

							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{FF9900}Экзамен провален",
								"{FFFFFF}К сожалению, Вам не удалось справиться с практической частью экзамена.\n"\
								"Уровень повреждений машины слишком высокий.\n\n"\
								"В сдедующий раз постарайтесь ехать аккуратнее, соблюдая ПДД.\n"\
								"Ждем Вас на пересдаче!",
								"Ок", ""
							);
						}
					else
						{
							new query[64];
							format(query, sizeof query, "UPDATE accounts SET driving_lic=%d WHERE id=%d LIMIT 1", GetPlayerData(playerid, P_DRIVING_LIC), GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);

							if(!mysql_errno())
							{
								Dialog
								(
									playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
									"{66CC00}Экзамен пройден успешно",
									"{FFFFFF}Вы успешно сдали практическую часть экзамена по вождению\n"\
									"и получаете водительское удостоверение!\n"\
									"{9999FF}На Вашей машине не обнаружено никаких повреждений, либо\n"\
									"они незначительны.\n"\
									"{FFFFFF}Не забывайте клавиши управления транспортом, а также\n"\
									"правила дорожного движения. Они будут постоянно нужны\n"\
									"Вам на дороге. Обучающий раздел в автошколе будет все\n"\
									"время доступен если понадобится какая-либо помощь.",
									"Ок", ""
								);
							}
					else
							{
								SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, обратитесь к администрации {FF0000}(equ-code 07)");
							}
						}
					}
					else if(step >= 0)
					{
						NextDrivingExamRouteCP(playerid);
					}
				}
			}
			case RCP_ACTION_TYPE_BUS_ROUTE:
			{
				if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_BUS_DRIVER)
				{
					if(IsPlayerInJob(playerid))
					{
						new route_id = GetPlayerData(playerid, P_BUS_ROUTE);
						new route_step = GetPlayerData(playerid, P_BUS_ROUTE_STEP);

						if(g_bus_route[route_id][route_step][BRS_POS_X] == 0.0)
						{
							SetPlayerData(playerid, P_BUS_ROUTE_STEP, 0);
						}

						if(g_bus_route[route_id][route_step - 1][BRS_STOP])
						{
							new fmt_str[90];
							DisablePlayerRaceCheckpoint(playerid);

							GameTextForPlayer(playerid, "~r~Stop", 4000, 1);
							SendClientMessage(playerid, 0x66CC00FF, "Остановка. Ждите пассажиров");

							format(fmt_str, sizeof fmt_str, "Автобус по маршруту %s отправляется через 10 секунд", g_bus_routes[route_id][BR_NAME]);
							SendMessageInLocal(playerid, fmt_str, 0x669999FF, 45.0);

							SetTimerEx("NextBusRouteCP", 10_000, false, "i", playerid);
						}
					else
						{
							AddPlayerData(playerid, P_JOB_WAGE, +, random(30) + 20);
							NextBusRouteCP(playerid);
						}
					}
				}
			}
			case RCP_ACTION_TYPE_ORDER:
			{
				if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_TRUCKER)
				{
					new order_id = GetPlayerData(playerid, P_ORDER);

					if(IsPlayerInJob(playerid) && order_id != -1)
					{
						if(!GetTruckIndex(vehicleid))
						{
							new biz_id = GetOrderData(order_id, O_COMPANY_ID);

							if(!IsPlayerInRangeOfPoint(playerid, 4.5, GetBusinessData(biz_id, B_EXIT_POS_X), GetBusinessData(biz_id, B_EXIT_POS_Y), GetBusinessData(biz_id, B_EXIT_POS_Z))) return 1;

							if(!GetPlayerJobLoadItems(playerid))
								return SendClientMessage(playerid, 0xCECECEFF, "В Вашем транспорте нет продуктов");

							new fmt_msg[90];

							if(GetPlayerJobLoadItems(playerid) < GetOrderData(order_id, O_AMOUNT))
							{
								SendClientMessage(playerid, 0xFF9933FF, "Недостаточно продуктов для выполнения заказа");
								format(fmt_msg, sizeof fmt_msg, "Вы загрузили %d шт., а требуется %d шт.", GetPlayerJobLoadItems(playerid), GetOrderData(order_id, O_AMOUNT));
								SendClientMessage(playerid, 0xCECECEFF, fmt_msg);
							}
					else
							{
								SetBusinessData(biz_id, B_PRODS, 10_000);

								mysql_format(mysql, fmt_msg, sizeof fmt_msg, "UPDATE business SET products=%d WHERE id=%d", GetBusinessData(biz_id, B_PRODS), GetBusinessData(biz_id, B_SQL_ID));
								mysql_query(mysql, fmt_msg, false);

								SetPlayerData(playerid, P_ORDER, -1);
								DisablePlayerRaceCheckpoint(playerid);

								new salary = GetOrderData(order_id, O_AMOUNT) * GetOrderData(order_id, O_PRICE);

								new income = salary - (GetOrderData(order_id, O_AMOUNT) * 24);

								SendClientMessage(playerid, 0xFFFF00FF, "Заказ выполнен!");

								format(fmt_msg, sizeof fmt_msg, "Вы продали предприятию \"%s\" %d продуктов на сумму %d рублей", GetBusinessData(biz_id, B_NAME), GetOrderData(order_id, O_AMOUNT), salary);
								SendClientMessage(playerid, 0x3399FFFF, fmt_msg);

								format(fmt_msg, sizeof fmt_msg, "Чистая прибыль от этой продажи составляет %d рублей", income);
								SendClientMessage(playerid, 0x66CC00FF, fmt_msg);

								AddPlayerData(playerid, P_JOB_WAGE, +, income);

								SetPlayerJobLoadItems(playerid, GetPlayerJobLoadItems(playerid) - GetOrderData(order_id, O_AMOUNT));
								DeleteOrder(order_id);
							}
						}
					else
						{
							new fs_id = GetOrderData(order_id, O_COMPANY_ID);

							if(!IsPlayerInRangeOfPoint(playerid, 4.5, GetFuelStationData(fs_id, FS_POS_X), GetFuelStationData(fs_id, FS_POS_Y), GetFuelStationData(fs_id, FS_POS_Z))) return 1;

							if(!GetPlayerJobLoadItems(playerid))
								return SendClientMessage(playerid, 0xCECECEFF, "В Вашем транспорте нет топлива");

							new fmt_msg[90];

							if(GetPlayerJobLoadItems(playerid) < GetOrderData(order_id, O_AMOUNT))
							{
								SendClientMessage(playerid, 0xFF9933FF, "Недостаточно топлива для выполнения заказа");
								format(fmt_msg, sizeof fmt_msg, "Вы загрузили %d л., а требуется %d л.", GetPlayerJobLoadItems(playerid), GetOrderData(order_id, O_AMOUNT));
								SendClientMessage(playerid, 0xCECECEFF, fmt_msg);
							}
					else
							{
								AddFuelStationData(fs_id, FS_FUELS, +, GetOrderData(order_id, O_AMOUNT));

								mysql_format(mysql, fmt_msg, sizeof fmt_msg, "UPDATE fuel_stations SET fuels=%d WHERE id=%d", GetFuelStationData(fs_id, FS_FUELS), GetFuelStationData(fs_id, FS_SQL_ID));
								mysql_query(mysql, fmt_msg, false);

								SetPlayerData(playerid, P_ORDER, -1);
								DisablePlayerRaceCheckpoint(playerid);

								new salary = GetOrderData(order_id, O_AMOUNT) * GetOrderData(order_id, O_PRICE);

								new income = salary - (GetOrderData(order_id, O_AMOUNT) * 24);

								SendClientMessage(playerid, 0xFFFF00FF, "Заказ выполнен!");

								format(fmt_msg, sizeof fmt_msg, "Вы продали АЗС \"%s\" %d л. топлива на сумму %d рублей", GetFuelStationData(fs_id, FS_NAME), GetOrderData(order_id, O_AMOUNT), salary);
								SendClientMessage(playerid, 0x3399FFFF, fmt_msg);

								format(fmt_msg, sizeof fmt_msg, "Чистая прибыль от этой продажи составляет %d рублей", income);
								SendClientMessage(playerid, 0x66CC00FF, fmt_msg);

								AddPlayerData(playerid, P_JOB_WAGE, +, income);

								SetPlayerJobLoadItems(playerid, GetPlayerJobLoadItems(playerid) - GetOrderData(order_id, O_AMOUNT));
								DeleteOrder(order_id);
							}
						}
					}
				}
			}

			default:
			{

			}
		}

	}
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

stock bool:Hospital_IsUsableSpawnSkin(skinid)
{
    // Model 413 is confirmed missing in this client build ("Can't find skin Model Info Id 413").
    // Do not change the account skin here: hospital spawn must never corrupt/save a fallback.
    if(skinid == 413) return false;
    return (skinid >= 0);
}

stock GetPlayerHospitalSpawnSkin(playerid)
{
    // Prefer the skin that is actually rendered on the player before the hospital
    // respawn. P_SKIN can contain a stale/internal id while the live ped is valid.
    if(GetPlayerState(playerid) != PLAYER_STATE_NONE)
    {
        new live_skin = GetPlayerSkin(playerid);
        if(Hospital_IsUsableSpawnSkin(live_skin))
        {
            SetPVarInt(playerid, "hospital_spawn_skin", live_skin + 1);
            return live_skin;
        }
    }

    // SpawnPlayer temporarily puts the player in NONE state, so keep the last
    // working live model across that transition. +1 lets model 0 be stored too.
    new saved_skin = GetPVarInt(playerid, "hospital_spawn_skin") - 1;
    if(saved_skin >= 0 && Hospital_IsUsableSpawnSkin(saved_skin))
        return saved_skin;

    new account_skin = GetPlayerSkinEx(playerid);
    if(Hospital_IsUsableSpawnSkin(account_skin))
    {
        SetPVarInt(playerid, "hospital_spawn_skin", account_skin + 1);
        return account_skin;
    }

    // Last-resort hospital-only fallback. Never write it to P_SKIN/database.
    new fallback_skin = reg_skin_data[GetPlayerSex(playerid)][0];
    SetPVarInt(playerid, "hospital_spawn_skin", fallback_skin + 1);
    printf("[HOSPITAL][SKIN] invalid account skin=%d player=%d, temporary fallback=%d", account_skin, playerid, fallback_skin);
    return fallback_skin;
}

