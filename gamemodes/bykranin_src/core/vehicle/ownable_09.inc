//>> Файл: bykranin_src/core/vehicle/ownable_09.inc  (282 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: /gps, /help, /anim, animsss, SetVehicleColorHexForPlayers, ddSetVehicleColorHexForPlayers, SetVehicleColorTonrrHexForPlayers
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:gps(playerid, params[])
{
	DisablePlayerGPS(playerid);

	Dialog
	(
		playerid, DIALOG_GPS, DIALOG_STYLE_LIST,
		"{00FFFF}"SERVER_NAME"{ffffff} | GPS",
		""c_server"1. "c_b"Важные места\n"\
		""c_server"2. "c_b"Работы для новичков\n"\
		""c_server"3. "c_b"Основные работы\n"\
		""c_server"4. "c_b"Государственные организации\n"\
		""c_server"5. "c_b"Преступные группировки\n"\
		""c_server"6. "c_b"Транспортные компании\n"\
		""c_server"7. "c_b"Строительные компании\n"\
		""c_server"8. "c_b"Таксопарки\n"\
		""c_server"9. "c_b"Развлечения\n"\
		""c_server"10. "c_b"Банки\n"\
		""c_server"11. "c_b"Причалы\n"\
		""c_server"12. "c_b"Автосалоны\n"\
		""c_server"13. "c_b"Тюнинг ателье\n"\
		""c_server"14. "c_b"Города и населенные пункты\n"\
		""c_server"15. "c_b"Вокзалы\n"\
		""c_server"16. "c_b"Поиск ближайших мест",
		"Выбрать", "Закрыть"
	);
	return 1;
}

CMD:help(playerid, params[])
{
	Dialog
	(
		playerid, DIALOG_HELP, DIALOG_STYLE_LIST,
		"{00CC33}Помощь по игре",
		help_info_items,
		"Выбрать", "Закрыть"
	);

	return 1;
}


CMD:anim(playerid, params[])
{
    if(GetPVarInt(playerid, "anim_command_active") == 1)
    {
        ClearAnimations(playerid, 1);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        SetPlayerData(playerid, P_USE_ANIM, false);
        DeletePVar(playerid, "anim_command_active");
        SendClientMessage(playerid, 0xCECECEFF, "Анимация остановлена");
        return 1;
    }

    if(strlen(params))
    {
        extract params -> new animid;
        if(!(1 <= animid <= sizeof anim_list))
        {
            return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /anim [номер анимации]");
        }

        if(!SetPlayerAnimation(playerid, animid - 1))
        {
            return SendClientMessage(playerid, 0x999999FF, "Анимация с таким номером не найдена");
        }
        SetPVarInt(playerid, "anim_command_active", 1);
        return 1;
    }

    Dialog
    (
        playerid, DIALOG_ANIM_LIST, DIALOG_STYLE_LIST,
        "{9966FF}Анимации",
        anim_list_items,
        "Выбрать", "Закрыть"
    );
    return 1;
}
stock animsss(playerid)
{
	Dialog
	(
		playerid, DIALOG_ANIM_LIST, DIALOG_STYLE_LIST,
		"{9966FF}Анимации",
		anim_list_items,
		"Выбрать", "Закрыть"
	);
	return 1;
}

alias:anim("animlist")
alias:e("en")


stock SetVehicleColorHexForPlayers(playerid, vehicleid, body, wheel)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 18);
	BS_WriteValue(bitstream, PR_UINT32, body);
	BS_WriteValue(bitstream, PR_UINT32, wheel);
	BS_WriteValue(bitstream, PR_UINT32, wheel);
	BS_WriteValue(bitstream, PR_UINT32, body); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}

stock ddSetVehicleColorHexForPlayers(playerid, vehicleid, light)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 8);
	BS_WriteValue(bitstream, PR_UINT32, light); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}
stock SetVehicleColorTonrrHexForPlayers(playerid, vehicleid, ft, rr)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 0);
	BS_WriteValue(bitstream, PR_UINT32, ft);
	BS_WriteValue(bitstream, PR_UINT32, rr);
	BS_WriteValue(bitstream, PR_UINT32, ft);
	BS_WriteValue(bitstream, PR_UINT32, rr); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}


stock AddComponent(playerid, compIndex)
{
    if (!IsPlayerInAnyVehicle(playerid))
        return 0;

    new vehicleid = GetPlayerVehicleID(playerid);

    // Базовый ID компонентов (SA-MP)
    new componentid = 1872 + compIndex;

    printf("[AddComponent] player=%d veh=%d compIndex=%d compID=%d",
        playerid, vehicleid, compIndex, componentid);

    AddToVehicleComponentForPlayer(playerid, vehicleid, componentid);
    return 1;
}

stock ToggleVehicleEngineSafe(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerInAnyVehicle(playerid) || !IsPlayerDriver(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не за рулем");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return 1;
    if(IsABike(vehicleid)) return 1;

    if(GetVehicleData(vehicleid, V_FUEL) <= 0.0)
    {
        GameTextForPlayer(playerid, "~r~no fuel", 4000, 1);
        return 1;
    }

    new engine_state = GetVehicleParam(vehicleid, V_ENGINE) ^ VEHICLE_PARAM_ON;
    SetVehicleParam(vehicleid, V_ENGINE, engine_state);
    return 1;
}

CMD:e(playerid, params[])
{
    #pragma unused params
    return ToggleVehicleEngineSafe(playerid);
}

stock engineon(playerid)
{
    return ToggleVehicleEngineSafe(playerid);
}
stock lightss(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == 0) return 1;

    if(IsABike(vehicleid)) return 1;

    if(!IsPlayerDriver(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не за рулем");

    new lights = GetVehicleParam(vehicleid, V_LIGHTS) ^ VEHICLE_PARAM_ON;
    SetVehicleParam(vehicleid, V_LIGHTS, lights);

    return 1;
}

alias:l("lights")
CMD:l(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "Вы не за рулем");

		lights = (GetVehicleParam(vehicleid, V_LIGHTS) ^ VEHICLE_PARAM_ON);
		SetVehicleParam(vehicleid, V_LIGHTS, lights);
	
	return 1;
}

CMD:sl(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsABike(vehicleid))
	{
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "Вы не за рулем");

		new limit = (GetVehicleData(vehicleid, V_LIMIT) ^ VEHICLE_PARAM_ON);
		SetVehicleData(vehicleid, V_LIMIT, limit);
	}
	return 1;
}

CMD:b(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(IsModelHasBootAndBonnet(GetVehicleModel(vehicleid)))
	{
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "Вы не за рулем");

		Dialog
		(
			playerid, DIALOG_OPEN_HOOD_OR_TRUNK, DIALOG_STYLE_MSGBOX,
			" ",
			"\t{CC9900}Управления авто",
			"Капот", "Багажник"
		);
	}
	return 1;
}

CMD:i(playerid, params[])
{
	#pragma unused params
	return Fuel_HandleRefuelCommand(playerid);
}

CMD:alarm(playerid, params[])
{
	#pragma unused params

	if(!IsPlayerDriver(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Вы не за рулем");

	new vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return 1;
	if(IsABike(vehicleid)) return 1;

	new alarm_state = GetVehicleParam(vehicleid, V_ALARM) ^ VEHICLE_PARAM_ON;
	SetVehicleParam(vehicleid, V_ALARM, alarm_state);

	if(IsAOwnableCar(vehicleid))
	{
		new index = GetVehicleData(vehicleid, V_ACTION_ID);
		if(0 <= index < g_ownable_car_loaded)
		{
			// Alarm is an active GTA state (horn + flashing), not an installed option.
			// Keep it session-only so respawning/reloading the car cannot start an endless horn.
			SetOwnableCarData(index, OC_ALARM, false);
		}
	}
	return 1;
}

