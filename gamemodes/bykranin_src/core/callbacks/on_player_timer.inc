//>> Файл: bykranin_src/core/callbacks/on_player_timer.inc  (417 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerTimer
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: OnPlayerTimer(playerid)
{
	Larek_OnPlayerTimer(playerid);
	CoordsHud_Update(playerid);
    
	if(GetPlayerAdminEx(playerid) && GetPlayerData(playerid, P_ADMIN_LOGGED))
	{
		TextDrawShowForPlayer(playerid, report_edit_TD);
		TextDrawShowForPlayer(playerid, admin_datetime_TD);
	}
	else
	{
		TextDrawHideForPlayer(playerid, report_edit_TD);
		TextDrawHideForPlayer(playerid, admin_datetime_TD);
	}
	
	
	if(IsPlayerLogged(playerid))
	{
		new fmt_str[128];
		new speed = GetPlayerSpeed(playerid);

		AddPlayerData(playerid, P_AFK_TIME, +, 1);
		if(IsPlayerAFK(playerid))
		{
			new afk_minutes = ConvertUnixTime(GetPlayerAFKTime(playerid), CONVERT_TIME_TO_MINUTES);
			new afk_seconds = ConvertUnixTime(GetPlayerAFKTime(playerid));

			if(afk_minutes > 0)
			{
				format(fmt_str, sizeof fmt_str, "На паузе %d:%02d", afk_minutes, afk_seconds);
			}
					else format(fmt_str, sizeof fmt_str, "На паузе %d сек.", afk_seconds);

			SetPlayerChatBubble(playerid, fmt_str, 0xFF0000FF, 7.0, 1500);

		/*	if(afk_minutes >= MAX_AFK_TIME && GetPlayerAdminEx(playerid) < 5)
				Kick:(playerid, "Превышено максимально допустимое время паузы");
				*/
		}
					else
		{
			AddPlayerData(playerid, P_GAME_FOR_HOUR, +, 1);
			AddPlayerData(playerid, P_GAME_FOR_DAY, +, 1);

			UpdatePlayerDatabaseInt(playerid, "game_for_hour", GetPlayerData(playerid, P_GAME_FOR_HOUR));
            UpdatePlayerDatabaseInt(playerid, "game_for_day", GetPlayerData(playerid, P_GAME_FOR_DAY));
		}

		if(GetPlayerData(playerid, P_MUTE) > 0)
		{
			AddPlayerData(playerid, P_MUTE, -, 1);
			UpdatePlayerDatabaseInt(playerid, "mute", GetPlayerData(playerid, P_MUTE));
			if(GetPlayerData(playerid, P_MUTE) <= 0)
				SendClientMessage(playerid, 0x66CC00FF, "Срок действия бана чата закончился");
		}
		if(GetPlayerData(playerid, P_FMUTE) > 0)
		{
			AddPlayerData(playerid, P_FMUTE, -, 1);
			UpdatePlayerDatabaseInt(playerid, "fmute", GetPlayerData(playerid, P_FMUTE));
			if(GetPlayerData(playerid, P_FMUTE) <= 0)
				SendClientMessage(playerid, 0x32a44bFF, "Срок действия бана семейного чата закончился");
		}

		if(GetPlayerData(playerid, P_JAIL) > 0)
		{
			AddPlayerData(playerid, P_JAIL, -, 1);
			UpdatePlayerDatabaseInt(playerid, "jail", GetPlayerData(playerid, P_JAIL));
			if(GetPlayerData(playerid, P_JAIL) <= 0)
				SendClientMessage(playerid, 0x66CC00FF, "Срок заключения закончился"),
				UnjailPlayer(playerid);
		}

		if(GetPlayerData(playerid, P_MASK) >= 2)
		{
			AddPlayerData(playerid, P_MASK, -, 1);
			if(GetPlayerData(playerid, P_MASK) <= 2)
			{
				GameTextForPlayer(playerid, "~y~invisible off", 2500, 4);

				SetPlayerColorInit(playerid);
				SetPlayerData(playerid, P_MASK, 0);
			}
		}

		if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_ON)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPlayerGPSInfo(playerid, G_POS_X), GetPlayerGPSInfo(playerid, G_POS_Y), GetPlayerGPSInfo(playerid, G_POS_Z)))
			{
				DisablePlayerGPS(playerid);
			}
		}

		new Float: player_health;

		GetPlayerHealth(playerid, player_health);

		if(player_health > GetPlayerHealthEx(playerid))
		{
			if(GetPVarInt(playerid, "anti_health_cheat") >= 10)
			{
				SendClientMessage(playerid, 0xFF6600FF, "Вы кикнуты по подозрению в читерстве {FF0000}(gac-code 01)");
				Kick:(playerid);
			}
		}
					else
		{
			SetPlayerData(playerid, P_HEALTH, player_health);
		}

	/*	if(GetPlayerData(playerid, P_JAIL) > 0 && !IsPlayerInRangeOfPoint(playerid, 70.0, 2035.7643,1416.3625,999.7344))
		{

		}
*/
		if(GetPlayerData(playerid, P_OCCUPIED_BED) != -1)
		{
			if(!MedBed_IsPlayerInHospitalArea(playerid))
			{
				ClearMedBed(playerid, GetPlayerData(playerid, P_OCCUPIED_BED));
			}
					else if(GetPlayerHealthEx(playerid) >= 95.0)
			{
				SetPlayerData(playerid, P_HOSPITAL, false);
				UpdatePlayerDatabaseInt(playerid, "hospital", 0);

				SendClientMessage(playerid, 0x66CC00FF, "Курс лечения пройден");
				SendClientMessage(playerid, -1, "Вы были выписаны из больницы");

				ClearMedBed(playerid, GetPlayerData(playerid, P_OCCUPIED_BED));

				SetPlayerChatBubble(playerid, "Выписан", 0x66CC00FF, 10.0, 2000);
			}
		}

		if(GetPlayerTeamEx(playerid) == TEAM_RADIO)
			TextDrawShowForPlayer(playerid, radio_edit_TD);

		else
			TextDrawHideForPlayer(playerid, radio_edit_TD);

		if(IsPlayerDriver(playerid))
		{
			//new Float: health;
			new vehicleid = GetPlayerVehicleID(playerid);
			if(!IsABike(vehicleid))
			{
				new	Float: fuels = GetVehicleData(vehicleid, V_FUEL),
					Float: health,
					Float:new_mileage = GetVehicleData(vehicleid, V_MILEAGE) + (float(speed) / 3600.0);

				GetVehicleHealth(vehicleid, health);

				SetVehicleParamsInit(vehicleid);
				fuels = GetVehicleData(vehicleid, V_FUEL);
				SetVehicleData(vehicleid, V_MILEAGE, new_mileage);

                if(GetVehicleParamEx(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON)
                {
                    if(speed > 0 && fuels > 0.0)
                    {
                        fuels -= (0.003 + (float(speed) / 12000.0));
                        if(fuels < 0.0) fuels = 0.0;
                        SetVehicleData(vehicleid, V_FUEL, fuels);
                    }

                    if(fuels <= 0.0)
                    {
                        SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
                        ShowNotificationNew(playerid, 2, 5, 0, 0, "Бензин в автомобиле закончился", " ");
                    }
                }

				SetVehicleSpeedometerInfoFP(playerid, vehicleid, fuels, new_mileage);
				vInfo[vehicleid][vFuel] = fuels;
				vInfo[vehicleid][vMileage] = new_mileage;

				if(IsAOwnableCar(vehicleid))
				{

					if
					(
						(gettime() - g_ownable_mileage_sync_time[vehicleid]) >= 5
						&& floatabs(new_mileage - g_ownable_mileage_saved[vehicleid]) >= 0.01
					)
					{
						SaveOwnableCarMileage(vehicleid);
						g_ownable_mileage_saved[vehicleid] = new_mileage;
						g_ownable_mileage_sync_time[vehicleid] = gettime();
					}

					if
					(
						(gettime() - g_ownable_fuel_sync_time[vehicleid]) >= 5
						&& floatabs(fuels - g_ownable_fuel_saved[vehicleid]) >= 0.01
					)
					{
						SaveOwnableCarFuel(vehicleid);
						g_ownable_fuel_saved[vehicleid] = fuels;
						g_ownable_fuel_sync_time[vehicleid] = gettime();
					}
				}

					//new modelid = GetVehicleModel(vehicleid) - 400;

				/*format(fmt_str, sizeof fmt_str, "%03i", speed);
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][1], fmt_str);

				format(fmt_str, sizeof fmt_str, "%d L", floatround(fuels));
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][2], fmt_str);

				format(fmt_str, sizeof fmt_str, "%d %", floatround(health / 10));
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][3], fmt_str);
				
				format(fmt_str, sizeof fmt_str, "%s", GetVehicleInfo(modelid, VI_NAME));
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][0], fmt_str);

				format
				(
					fmt_str, sizeof fmt_str,
					"%s.",
					GetVehicleParamEx(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON ? ("") : ("~r~")
				);
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][6], fmt_str);

				format
				(
					fmt_str, sizeof fmt_str,
					"%s.",
					GetVehicleParamEx(vehicleid, V_LIGHTS) == VEHICLE_PARAM_ON ? ("") : ("~r~")
				);
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][5], fmt_str);

				format
				(
					fmt_str, sizeof fmt_str,
					"%s.",
					GetVehicleParamEx(vehicleid, V_LOCK) == VEHICLE_PARAM_ON ? ("") : ("~r~")
				);
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][4], fmt_str);

				format(fmt_str, sizeof fmt_str, " %05ikm", floatround(GetVehicleData(vehicleid, V_MILEAGE)));
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][7], fmt_str);
				
				format(fmt_str, sizeof fmt_str, "%03i", speed);
				PlayerTextDrawSetString(playerid, speedometr02_PTD[playerid][1], fmt_str);

				format(fmt_str, sizeof fmt_str, "%dL", floatround(fuels));
				PlayerTextDrawSetString(playerid, speedometr02_PTD[playerid][6], fmt_str);

				format(fmt_str, sizeof fmt_str, "%d%", floatround(health / 10));
				PlayerTextDrawSetString(playerid, speedometr02_PTD[playerid][7], fmt_str);

				format(fmt_str, sizeof fmt_str, "%s", GetVehicleInfo(modelid, VI_NAME));
				PlayerTextDrawSetString(playerid, speedometr02_PTD[playerid][0], fmt_str);

				format
				(
					fmt_str, sizeof fmt_str,
					"%s.",
					GetVehicleParamEx(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON ? ("") : ("~r~")
				);
				PlayerTextDrawSetString(playerid, speedometr02_PTD[playerid][5], fmt_str);

				format
				(
					fmt_str, sizeof fmt_str,
					"%s.",
					GetVehicleParamEx(vehicleid, V_LIGHTS) == VEHICLE_PARAM_ON ? ("") : ("~r~")
				);
				PlayerTextDrawSetString(playerid, speedometr02_PTD[playerid][4], fmt_str);

				format
				(
					fmt_str, sizeof fmt_str,
					"%s.",
					GetVehicleParamEx(vehicleid, V_LOCK) == VEHICLE_PARAM_ON ? ("") : ("~r~")
				);
				PlayerTextDrawSetString(playerid, speedometr02_PTD[playerid][3], fmt_str);



				format(fmt_str, sizeof fmt_str, "%05ikm", floatround(GetVehicleData(vehicleid, V_MILEAGE)));
				PlayerTextDrawSetString(playerid, speedometr02_PTD[playerid][2], fmt_str);*/
				
				//

//				CheckRadars(playerid);

			}
		}
					else if(IsPlayerPassenger(playerid))
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			new driver = GetVehicleData(vehicleid, V_DRIVER_ID);

			if(driver != INVALID_PLAYER_ID && IsPlayerInJob(driver) && IsPlayerDriver(driver))
			{
				if(GetPlayerJobCar(driver) == vehicleid && IsPlayerInVehicle(driver, vehicleid))
				{
					if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_TAXI_DRIVER)
					{
						g_taxi_mileage[playerid] += (float(speed) / 3600.0);
						if(g_taxi_mileage[playerid] > 0.1)
						{
							g_taxi_mileage[playerid] = 0.0;

							new tariff = GetPlayerData(driver, P_JOB_TARIFF);
							if(GetPlayerMoneyEx(playerid) >= tariff)
							{
								GivePlayerMoneyEx(driver, tariff, "- Оплата тарифа такси", false, true);
								GivePlayerMoneyEx(playerid, -tariff, "+ Оплата тарифа такси", false, true);

								AddPlayerData(playerid, P_JOB_WAGE, +, tariff);

								format(fmt_str, sizeof fmt_str, "~r~-%d rub~n~~b~+100 m", tariff);
								GameTextForPlayer(playerid, fmt_str, 4000, 1);

								format(fmt_str, sizeof fmt_str, "~g~+%d rub~n~~b~+100 m", tariff);
								GameTextForPlayer(driver, fmt_str, 4000, 1);
							}
					else
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xFF6600FF, "Недостаточно денег для дальнейшей оплаты тарифа");
							}
						}
					}
				}
			}
		}

		if(GetPlayerTempJob(playerid) != TEMP_JOB_NONE)
		{
			CheckPlayerTempJobState(playerid);
		}

		if(GetPVarInt(playerid, "player_in_ammo_cp"))
		{
			new army_ammo = GetRepositoryData(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_AMMO, R_AMOUNT),
				rand_ammo = random(4)+1,
				soldiers_count;

			foreach(new i : Player)
			{
				if(!IsPlayerConnected(i)) continue;
				else if(!IsPlayerLogged(i)) continue;
				else if(GetPlayerTeamEx(i) != TEAM_ARMY) continue;

				soldiers_count++;
			}

			/*if(soldiers_count < 3 && GetPlayerTeamEx(playerid) != TEAM_ARMY)
				SendClientMessage(playerid, 0x999999FF, "Чтобы воровать Патроны со склада, должно быть хотя бы 3 военнослужащих в сети");

			else
			{*/
				if(army_ammo == 0)
					GameTextForPlayer(playerid, "~g~loading...", 1100, 6);
				else
				{
					if(!IsPlayerAFK(playerid))
					{
						if((army_ammo - rand_ammo) < 0)
							rand_ammo = 200000 - army_ammo;

						if((GetPlayerData(playerid, P_AMMO) + rand_ammo) > 350)
							SendClientMessage(playerid, 0x66CC33FF, "Взять больше патронов не получается");
						else
						{
							AddPlayerData(playerid, P_AMMO, +, rand_ammo);
							UpdatePlayerDatabaseInt(playerid, "ammo", GetPlayerData(playerid, P_AMMO));

							SetRepositoryData(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_AMMO, R_AMOUNT, army_ammo - rand_ammo);

							new fmt_text[128];

							format(fmt_text, sizeof fmt_text, "~g~+%d patr.~n~~b~total %d patr.", rand_ammo, GetPlayerData(playerid, P_AMMO));
							GameTextForPlayer(playerid, fmt_text, 1100, 6);

							format(fmt_text, sizeof fmt_text, "+%d шт.", rand_ammo);
							SetPlayerChatBubble(playerid, fmt_text, 0xFFCD00FF, 10.0, 1100);

							UpdateRepository(REPOSITORY_TYPE_ARMY, REPOSITORY_ACTION_ARMY_AMMO);
						}
					}
				//}
			}
		}
		/*
		if(GetPlayerSurfingVehicleID(playerid) != INVALID_VEHICLE_ID)
		{
			new Float: x,
				Float: y,
				Float: z;

			GetPlayerPos(playerid, x, y, z);
			SetPlayerPos(playerid, x + 1.0, y + 1.0, z);
		}
		*/
	}
					else
	{
		if(GetPlayerData(playerid, P_AUTH_TIME) >= 0)
		{
			if(GetPlayerData(playerid, P_AUTH_TIME) >= MAX_AUTHORIZATION_TIME)
			{
				HidePlayerDialog(playerid);

				SendClientMessage(playerid, 0xFF6600FF, "Время на авторизацию ограничено");
				Kick:(playerid);
			}
					else AddPlayerData(playerid, P_AUTH_TIME, +, 1);
		}
	}
}

