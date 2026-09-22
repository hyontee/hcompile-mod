//>> Файл: bykranin_src/core/callbacks/on_player_enter_vehicle_ex.inc  (383 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerEnterVehicleEx
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: OnPlayerEnterVehicleEx(playerid, vehicleid, is_driver)
{
    
	SetPlayerData(playerid, P_LAST_VEHICLE, vehicleid);

	DeletePVar(playerid, PVAR_TRUNKTEST_HINT_SHOWN);
	DeletePVar(playerid, PVAR_TRUNKTEST_HINT_VEHICLE);
	DeletePVar(playerid, PVAR_TRUNKTEST_HINT_TICK);
	DeletePVar(playerid, PVAR_CARLOCK_HINT_SHOWN);
	DeletePVar(playerid, PVAR_CARLOCK_HINT_VEHICLE);
	DeletePVar(playerid, PVAR_CARLOCK_HINT_TICK);
	DeletePVar(playerid, PVAR_CARLOCK_EXIT_TICK);
	DeletePVar(playerid, PVAR_TRUNKTEST_EXIT_TICK);
	DeletePVar(playerid, "car_autolock_by_speed");

	new vehicle_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
	new action_id = GetVehicleData(vehicleid, V_ACTION_ID);


	if(is_driver)
	{

		if(!IsABike(vehicleid))
        {
        	if(!GetVehicleParam(vehicleid, V_ENGINE))
		    {
               ShowNotificationNew(playerid, 4, 7, 1, vehicleid, "Завести двигатель автомобиля", "/e");
			} 
        }
		SetVehicleData(vehicleid, V_DRIVER_ID, playerid);

		if(!GetVehicleParam(vehicleid, V_LOCK))
		{
			if(IsValidVehicle(vehicleid))
			{
				/*if(!IsABike(vehicleid))
					SpeedometrShowForPlayer(playerid);*/

				new Float:currentFuel = GetVehicleData(vehicleid, V_FUEL);
				new Float:currentMileage = GetVehicleData(vehicleid, V_MILEAGE);

				if(currentFuel < 0.0) currentFuel = 40.0;
				SetVehicleSpeedometerInfo(vehicleid, currentFuel, currentMileage);
				SetVehicleSpeedometerInfoFP(playerid, vehicleid, currentFuel, currentMileage);

				switch(vehicle_type)
				{
				case VEHICLE_ACTION_TYPE_GIFT_CAR:
					{
					  ShowPlayerDialog(playerid,8987,DIALOG_STYLE_MSGBOX,"{00FFFF}"SERVER_NAME"{FFFFFF} | Получение транспорта","Вы уверены что хотите получить транспорт,\nв котором Вы сейчас находитесь?","Да","Нет");
					return 1;
					}
					case VEHICLE_ACTION_ORG_CAR:
		            {
		                new frac_id = GetVehicleData(vehicleid, V_ACTION_ID);
		                if(GetPlayerData(playerid, P_TEAM) != frac_id)
		                {
		                    SendClientMessage(playerid, -1, "{808080}Ошибка:{FFFFFF} Вам не доступен данный транспорт [ORG]");
                      ShowNotificationNew(playerid, 2, 5, 0, 0, "Вам не доступен данный транспорт", "");
		                    RemovePlayerFromVehicle(playerid);
		                }
		            }
					case VEHICLE_ACTION_TYPE_DRIVING_SCH:
					{
						if(GetPlayerDrivingExamInfo(playerid, DE_POINTS) >= 9)
						{
							SetPVarFloat(playerid, "car_damage", 1000.0);

							SetVehicleParam(vehicleid, V_LOCK, VEHICLE_PARAM_ON);
							NextDrivingExamRouteCP(playerid);

							SendClientMessage(playerid, 0x66CC00FF, "[Инструктор] Проедьтесь немного по городу");
							SendClientMessage(playerid, 0xFFFF00FF, "Внимание! Если Вы попадете в аварию или выйдете из машины, экзамен будет завершен");
							SendClientMessage(playerid, 0xFFFFFFFF, "Чтобы открыть ворота подайте {0099FF}звуковой сигнал");
						}
					else
						{
							RemovePlayerFromVehicle(playerid);
							//SendClientMessage(playerid, 0xCECECEFF, "Транспорт принадлежит автошколе");
       ShowNotificationNew(playerid, 2, 5, 0, 0, "Вам не доступен данный транспорт", "");
						}
					}
					/*case VEHICLE_ACTION_TYPE_LOADER:
					{
						RemovePlayerFromVehicle(playerid);
						SendClientMessage(playerid, 0xCECECEFF, "Вам недоступен данный транспорт");
						if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
						{
							SetVehicleParam(vehicleid, V_LOCK, true);

							DisablePlayerCheckpoint(playerid);

							SendClientMessage(playerid, 0xFFFFFFFF, "Используйте {00CC00}Num 2 {FFFFFF}и {00CC00}Num 8 {FFFFFF}для управления погрузчиком");
							SendClientMessage(playerid, 0xFFFFFFFF, "Чтобы взять или положить груз можно использовать {3399FF}/take");
						}
					else
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "Вы не грузчик");
						}
					}*/
					case VEHICLE_ACTION_TYPE_FACTORY:
					{
						if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY_TRUCKER)
						{
							new job_car = GetPlayerJobCar(playerid);

							if(job_car == INVALID_VEHICLE_ID && action_id == VEHICLE_ACTION_ID_NONE)
							{
								new bool: take_car = true;
								switch(GetVehicleData(vehicleid, V_MODELID))
								{
									case 514:
									{
										CreateVehicleLabel(vehicleid, "Доставка топлива\n{FFFFFF}Загрузка 0 / 8000 л", 0xFF6600FF, 0.0, 2.1, 2.1, 20.0);

										SendClientMessage(playerid, 0x66CC00FF, "Прицепите цистерну и отправляйтесь на нефтезавод для закупки топлива");
										SendClientMessage(playerid, 0xFFFFFFFF, "Убедитесь, что склад не полон и заводу действительно необходимо топливо");
									}
									case 498:
									{
										CreateVehicleLabel(vehicleid, "Доставка Материалыа\n{FFFFFF}Загрузка 0 / 500 кг", 0x3399FFFF, 0.0, 0.0, 1.8, 20.0);

										SendClientMessage(playerid, 0x66CC00FF, "Отправляйтесь на шахту, чтобы закупить Материалы для завода");
										SendClientMessage(playerid, 0xFFFFFFFF, "Убедитесь, что склад не полон и заводу действительно нужен Материалы");
									}
									default: take_car = false;
								}
								if(take_car)
								{
									SetVehicleData(vehicleid, V_ACTION_ID, true);
									SetPlayerData(playerid, P_JOB_CAR, vehicleid);
								}
							}
					else if(vehicleid != job_car)
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xCECECEFF, "Вы не можете использовать этот транспорт в данный момент");
							}
					else KillEndJobTimer(playerid);
						}
					else
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "Вы не работник службы доставки завода");
						}
					}
					/*case VEHICLE_ACTION_TYPE_BUS_DRIVER: // Водитель автобуса
					{
						if(GetPlayerJob(playerid) == JOB_BUS_DRIVER)
						{
							new job_car = GetPlayerJobCar(playerid);

							if(!IsPlayerInJob(playerid) && job_car != vehicleid && action_id == VEHICLE_ACTION_ID_NONE)
							{
								Dialog
								(
									playerid, DIALOG_BUS_RENT_CAR, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Автобусный парк",
									"{FFFFFF}Чтобы взять машину, необходимо заплатить городскому автопарку 180 рублей\n"\
									"Вы действительно хотите взять автобус в аренду?",
									"Да", "Нет"
								);
							}
					else if(vehicleid != job_car)
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xCECECEFF, "Вы не можете использовать этот транспорт в данный момент");
							}
					else KillEndJobTimer(playerid);
						}
					else
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "Вы не водитель автобуса");
						}
					}*/
					case VEHICLE_ACTION_TYPE_TAXI_DRIVER: // Таксист
					{
						if(GetPlayerJob(playerid) == 6)
						{
							new job_car = GetPlayerJobCar(playerid);

							if(!IsPlayerInJob(playerid) && job_car != vehicleid && action_id == VEHICLE_ACTION_ID_NONE)
							{
								Dialog
								(
									playerid, DIALOG_TAXI_RENT_CAR, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Таксопарк",
									"{FFFFFF}Чтобы взять машину, необходимо заплатить городскому таксопарку 200 рублей\n"\
									"Вы действительно хотите заключить договор аренды?",
									"Да", "Нет"
								);
							}
					else if(vehicleid != job_car)
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xCECECEFF, "Вы не можете использовать этот транспорт в данный момент");
							}
					else KillEndJobTimer(playerid);
						}
					else
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "Вы не таксист");
						}
					}
					/*case VEHICLE_ACTION_TYPE_UNUSED_1: // Автомеханик
					{
						if(GetPlayerJob(playerid) == JOB_UNUSED_3)
						{
							new job_car = GetPlayerJobCar(playerid);

							if(!IsPlayerInJob(playerid) && job_car != vehicleid && action_id == VEHICLE_ACTION_ID_NONE)
							{
								Dialog
								(
									playerid, DIALOG_UNUSED_LEGACY_6, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Автопарк",
									"{FFFFFF}Чтобы взять машину, необходимо заплатить городскому автопарку 180 рублей\n"\
									"Вы действительно хотите заключить договор аренды?",
									"Да", "Нет"
								);
							}
					else if(vehicleid != job_car)
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xCECECEFF, "Вы не можете использовать этот транспорт в данный момент");
							}
					else KillEndJobTimer(playerid);
						}
					else
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "Вы не автомеханик");
						}
					}*/
					case VEHICLE_ACTION_TYPE_TRUCKER: // Дальнобойщик
					{
						if(GetPlayerJob(playerid) == JOB_TRUCKER)
						{
							new job_car = GetPlayerJobCar(playerid);

							if(!IsPlayerInJob(playerid) && job_car != vehicleid && action_id == VEHICLE_ACTION_ID_NONE)
							{
								Dialog
								(
									playerid, DIALOG_TRUCKER_RENT_CAR, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Автопарк",
									"{FFFFFF}Чтобы взять машину, необходимо заплатить городскому автопарку 180 рублей\n"\
									"Вы действительно хотите заключить договор аренды?",
									"Да", "Нет"
								);
							}
					else if(vehicleid != job_car)
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xCECECEFF, "Вы не можете использовать этот транспорт в данный момент");
							}
					else KillEndJobTimer(playerid);
						}
					else
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "Вы не дальнобойщик");
						}
					}
				/*	case VEHICLE_ACTION_TYPE_GOV_CAR..VEHICLE_ACTION_TYPE_LYT_CAR:
					{
						if(GetPlayerTeamEx(playerid) != vehicle_type - 9)
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "Вам недоступен данный транспорт");
						}
					}
					*/
					case VEHICLE_ACTION_TYPE_RENT_CAR:
					{
						new rent_index = GetRentCarDataIndex(vehicleid);
						if(rent_index == -1 || !(playerid == rent_cars_data[rent_index][rent_car_tenant_id] && GetPlayerRentCar(playerid) == vehicleid))
						{
							TogglePlayerControllable(playerid, false);
							CallLocalFunction("ShowBuyCarInfo", "ii", playerid, vehicleid);
						}
					}
					case VEHICLE_ACTION_TYPE_ADMIN_CAR:
					{
						if(action_id != 1)
						{
							if(!GetPlayerAdminEx(playerid))
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xCECECEFF, "Вам недоступен данный транспорт");
							}
						}
					}
					case VEHICLE_ACTION_TYPE_FAMILY_CAR:
                    {
                        //new fam_id = GetPlayerData(playerid, P_FAMILY);
                        action_id = GetVehicleData(vehicleid, V_ACTION_ID);

                        if(action_id < 0 || action_id >= g_family_car_loaded)
                        {
                            RemovePlayerFromVehicle(playerid);
                            return 1;
                        }
                        
                        if(g_family_car[action_id][F_OWNER_ID] != GetPlayerData(playerid, P_FAMILY) + 1)
                        {
                            if(g_family_car[action_id][F_RANG] > GetPlayerData(playerid, P_FAMILY_RANK))
                            {
                                RemovePlayerFromVehicle(playerid);
                                SendClientMessage(playerid, 0xCECECEFF, "Вам недоступен данный транспорт (RANG)");
                            }
                        }
					else
                        {
                            RemovePlayerFromVehicle(playerid);
                            SendClientMessage(playerid, 0xCECECEFF, "Вам недоступен данный транспорт (FAMILY)");
                        }
                    }
				}
			}
		}
					else RemovePlayerFromVehicle(playerid);
	}
					else
	{
		if(GetPlayerData(playerid, P_CUFFED)) TogglePlayerControllable(playerid, false);

		switch(vehicle_type)
		{
			case VEHICLE_ACTION_TYPE_BUS_DRIVER, VEHICLE_ACTION_TYPE_TAXI_DRIVER:
			{
				new driver = GetVehicleData(vehicleid, V_DRIVER_ID);
				if(driver != INVALID_PLAYER_ID && IsPlayerInJob(driver) && IsPlayerDriver(driver))
				{
					if(GetPlayerJobCar(driver) == vehicleid && IsPlayerInVehicle(driver, vehicleid))
					{
						new tariff = GetPlayerData(driver, P_JOB_TARIFF);

						if(vehicle_type == VEHICLE_ACTION_TYPE_TAXI_DRIVER)
						{
							if(GetPlayerMoneyEx(playerid) >= tariff)
							{
								new fmt_str[90];
								g_taxi_mileage[playerid] = 0.0;

								format(fmt_str, sizeof fmt_str, "%s сел в ваше такси. Счетчик включен", GetPlayerNameEx(playerid));
								SendClientMessage(driver, 0x3399FFFF, fmt_str);

								format(fmt_str, sizeof fmt_str, "Вы сели в такси %s. Тариф: %d рублей (оплата за каждые 100 м поездки)", GetPlayerNameEx(driver), tariff);
								SendClientMessage(playerid, 0x3399FFFF, fmt_str);

								AddPlayerData(driver, P_JOB_LOAD_ITEMS, +, 1);
							}
					else
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xFF6600FF, "Недостаточно денег для оплаты тарифа");
							}
						}
					else
						{
							if(GetPlayerMoneyEx(playerid) >= tariff)
							{
								AddPlayerData(driver, P_JOB_LOAD_ITEMS, +, 1);
								GivePlayerMoneyEx(driver, tariff, "+ Оплата проезда в автобусе", true, true);
							}
					else
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xFF6600FF, "Недостаточно денег для оплаты проезда");
							}
						}
					}
				}
			}
		}
	}
	return 1;
}
