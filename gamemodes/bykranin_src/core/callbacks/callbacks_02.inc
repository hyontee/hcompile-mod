//>> Файл: bykranin_src/core/callbacks/callbacks_02.inc  (204 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerExitVehicleEx, OnPlayerStateChange, OnVehicleDamageStatusUpdate
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: OnPlayerExitVehicleEx(playerid, vehicleid, is_driver)
{
	StopPlayerStt(playerid);

	StopAudioStreamForPlayer(playerid);
	
	//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} OnPlayerExitVehicle");

	SetPlayerData(playerid, P_LAST_VEHICLE, INVALID_VEHICLE_ID);
	
	//ShowNotification(playerid, 5, "Закрыть двери автомобиля", 7, "/lk", ">>");

	if(is_driver)
	{
		SetPVarInt(playerid, PVAR_CARLOCK_EXIT_TICK, GetTickCount());
		SetPVarInt(playerid, PVAR_TRUNKTEST_EXIT_TICK, GetTickCount());
		DeletePVar(playerid, "car_autolock_by_speed");

		SetVehicleData(vehicleid, V_DRIVER_ID, INVALID_PLAYER_ID);

		/*if(!IsABike(vehicleid))
			SpeedometrHideForPlayer(playerid);*/

		if(GetPlayerDrivingExamInfo(playerid, DE_POINTS) >= 9)
		{
			DisablePlayerRaceCheckpoint(playerid);

			if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_DRIVING_SCH)
			{
				SetVehicleToRespawn(vehicleid);
			}
			SetPlayerData(playerid, P_DRIVING_LIC, 0);
			ClearPlayerDrivingExamInfo(playerid);

			SendClientMessage(playerid, 0xFF6600FF, "Вы покинули учебный автомобиль");
			SendClientMessage(playerid, 0xFF0000FF, "Экзамен провален!");

			DeletePVar(playerid, "car_damage");
		}

        if(GetPVarInt(playerid, "autosalon_testdrive_active") && vehicleid == GetPlayerData(playerid, P_BUY_CAR))
        {
            ReturnPlayerToAutosalonPreview(playerid, true);
            return 1;
        }

        switch(GetVehicleData(vehicleid, V_ACTION_TYPE))
		{
		    case VEHICLE_ACTION_TYPE_RENT_BIKE:
            {
                if(GetPlayerData(playerid, P_RENT_BIKE) != vehicleid) return 1;
                //SendClientMessage(playerid, 0xCECECEFF, "У Вас есть 40 сек чтобы вернуться в транспорт , после чего он будет удален");
            }
			case VEHICLE_ACTION_TYPE_FACTORY:
			{
				if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY_TRUCKER)
				{
					if(GetPlayerJobCar(playerid) == vehicleid)
					{
						StartEndJobTimer(playerid);
						SendClientMessage(playerid, 0xFF6600FF, "У Вас есть 15 секунд чтобы вернуться в транспорт");
					}
				}
			}
			case VEHICLE_ACTION_TYPE_BUS_DRIVER:
			{
				if(GetPlayerJob(playerid) == JOB_BUS_DRIVER)
				{
					if(IsPlayerInJob(playerid))
					{
						if(GetPlayerJobCar(playerid) == vehicleid)
						{
							StartEndJobTimer(playerid);
							SendClientMessage(playerid, 0xFF6600FF, "У Вас есть 15 секунд чтобы вернуться в автобус");
						}
					}
				}
			}
			case VEHICLE_ACTION_TYPE_TAXI_DRIVER:
			{
				if(GetPlayerJob(playerid) == 6)
				{
					if(IsPlayerInJob(playerid))
					{
						if(GetPlayerJobCar(playerid) == vehicleid)
						{
							StartEndJobTimer(playerid);
							SendClientMessage(playerid, 0xFF6600FF, "У Вас есть 15 секунд чтобы вернуться в транспорт");
						}
					}
				}
			}
			case VEHICLE_ACTION_TYPE_UNUSED_1:
			{
				if(GetPlayerJob(playerid) == JOB_UNUSED_3)
				{
					if(IsPlayerInJob(playerid))
					{
						if(GetPlayerJobCar(playerid) == vehicleid)
						{
							StartEndJobTimer(playerid);
							SendClientMessage(playerid, 0xFF6600FF, "У Вас есть 15 секунд чтобы вернуться в транспорт");
						}
					}
				}
			}
			case VEHICLE_ACTION_TYPE_TRUCKER:
			{
				if(GetPlayerJob(playerid) == JOB_TRUCKER)
				{
					if(IsPlayerInJob(playerid))
					{
						if(GetPlayerJobCar(playerid) == vehicleid)
						{
							StartEndJobTimer(playerid);
							SendClientMessage(playerid, 0xFF6600FF, "У Вас есть 15 секунд чтобы вернуться в транспорт");
						}
					}
				}
			}
		}
	}
					else
	{
		if(GetPlayerData(playerid, P_CUFFED)) TogglePlayerControllable(playerid, true);
	}
	//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} OnPlayerExitVehicle");
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(FsinFull_OnPlayerStateChange(playerid,newstate,oldstate)) return 1;
    if(newstate == PLAYER_STATE_DRIVER)
    {
        new entered_vehicle = GetPlayerVehicleID(playerid);
        if(entered_vehicle > 0 && entered_vehicle < MAX_VEHICLES && IsValidVehicle(entered_vehicle))
        {
            SetVehicleParam(entered_vehicle, V_ALARM, VEHICLE_PARAM_OFF);
            SyncVehicleHornForPlayer(playerid, entered_vehicle);
        }
    }

    if(oldstate == PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_DRIVER)
    {
        StopPlayerVehicleTurnSignal(playerid);
    }
	if
	(
		GetPVarInt(playerid, "autosalon_testdrive_active")
		&& oldstate == PLAYER_STATE_DRIVER
		&& newstate == PLAYER_STATE_ONFOOT
	)
	{
		ReturnPlayerToAutosalonPreview(playerid, true);
		return 1;
	}
	return 1;
}
public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	if(TC_IsGuardedVehicle(vehicleid))
	{
		SetVehicleHealth(vehicleid, 100000.0);
		UpdateVehicleDamageStatus(vehicleid, 0, 0, 0, 0);
		return 1;
	}

	if(GetVehicleParam(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON && GetPlayerData(playerid, P_IMPROVEMENTS) < 4)
	{
		//SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
		//GameTextForPlayer(playerid, "~r~~h~engine off", 4000, 6);
		ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы попали в дтп, впредь будьте окуратнее", "");

		new Float: veh_health;

		GetVehicleHealth(vehicleid, veh_health);

		if(IsAOwnableCar(vehicleid))
		{
			SetVehicleData(vehicleid, V_HEALTH, veh_health);

			if(veh_health < 300.0)
			{
				SetVehicleData(vehicleid, V_HEALTH, 300.0);
			}
		}

		switch(GetVehicleData(vehicleid, V_ACTION_TYPE))
		{
			case VEHICLE_ACTION_TYPE_DRIVING_SCH, VEHICLE_ACTION_TYPE_BUS_DRIVER:
			{
				new Float: health = GetPVarFloat(playerid, "car_damage");

				health -= floatabs((health - veh_health));

				SetPVarFloat(playerid, "car_damage", health);
			}
		}
	}
    return 1;
}

