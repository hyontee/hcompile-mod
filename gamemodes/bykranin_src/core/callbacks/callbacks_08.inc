//>> Файл: bykranin_src/core/callbacks/callbacks_08.inc  (259 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: /veh, OnPlayerNotificationClick, /pos, /d, /dd, /r
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:veh(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 4 && GetPlayerYouTubeEx(playerid) < 1) 
        return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

    new model_id, color_1 = 1, color_2 = 1, status = 0;
    if(sscanf(params, "iI(1)I(1)I(0)", model_id, color_1, color_2, status))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Используйте: /veh [id модели] [цвет 1] [цвет 2] [доступ для игроков: 0 - нет, 1 - да]");

    if(!(400 <= model_id <= 25000000))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff}Используйте модель от 400 до 2591");
    if(!(0 <= status <= 1))
        return SendClientMessage(playerid, 0x999999FF, "{ffff00}|{ffffff}Доступ игроков к транспорту: 0 - Нет доступа, 1 - Доступно любому игроку");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    // Проверяем находится ли игрок в запрещенной зоне
    if(IsPlayerInRestrictedArea(x, y, z))
    {
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Вы находитесь в запрещенной для создания транспорта зоне! Отойдите подальше от спавна.");
    }

    // Генерация случайного количества топлива
    new Float:fuel = 10.0 + (float(random(900)) / 10.0);

    // Генерация номера
    new number_plate[16], region[8];
    new letters[] = "ABEKMHOPCTYX";
    new letter1 = letters[random(sizeof(letters))];
    new letter2 = letters[random(sizeof(letters))];
    new letter3 = letters[random(sizeof(letters))];
    format(number_plate, sizeof(number_plate), "%c%03d%c%c", letter1, random(1000), letter2, letter3);
    format(region, sizeof(region), "%d", random(1000));

    new vehicleid = CreateVehicle(model_id, x, y, z, a, color_1, color_2, -1, 0, VEHICLE_ACTION_TYPE_ADMIN_CAR, status);
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid < 1 || vehicleid >= MAX_VEHICLES)
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Не удалось создать транспорт (неверная модель или лимит транспорта сервера SA-MP).");

    // Запоминаем создателя - лимита на количество машин больше нет
    g_AdminVehOwner[vehicleid] = playerid + 1;

    // Сохранение номера и региона
    format(g_VehicleNumberPlate[vehicleid], sizeof(g_VehicleNumberPlate[]), "%s", number_plate);
    format(g_VehicleRegion[vehicleid], sizeof(g_VehicleRegion[]), "%s", region);
    
    SetVehicleNumberPlateEx(vehicleid, TYPE_RU, number_plate, region);
    SetVehicleData(vehicleid, V_FUEL, fuel);
    SetVehicleData(vehicleid, V_MILEAGE, 0.0);
    SetVehicleSpeedometerInfo(vehicleid, fuel, 0.0);
    SetVehicleSpeedometerInfoFP(playerid, vehicleid, fuel, 0.0);

    PutPlayerInVehicle(playerid, vehicleid, 0);

    if(GetVehicleData(vehicleid, V_FUEL) <= 0.0)
    {
        GameTextForPlayer(playerid, "~r~no fuel", 4000, 1);
    }
    else
    {
        SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_ON);
    }

    new fmt_text[256];
    format(fmt_text, sizeof(fmt_text), "[A] %s[%d] создал транспорт [ID %d] (модель %d, цвета %d/%d, доступ игрокам: %d, топливо: %.1f, номер: %s %s)",
        GetPlayerNameEx(playerid), playerid, vehicleid, model_id, color_1, color_2, status, fuel, number_plate, region);
    SendMessageToAdmins(fmt_text, 0x999999FF);

    format(fmt_text, sizeof(fmt_text), "Создал транспорт [ID %d] (%d, %d, %d, доступ: %d, топливо: %.1f, номер: %s %s)", 
        vehicleid, model_id, color_1, color_2, status, fuel, number_plate, region);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

    format(fmt_text, sizeof(fmt_text), "{ffff00}|{ffffff} Вы создали транспорт. ID транспорта: {ffff00}%d{ffffff}. Удалить: /delveh %d", vehicleid, vehicleid);
    SendClientMessage(playerid, 0xCECECEFF, fmt_text);

    return 1;
}
// Callback для обработки нажатия кнопки уведомления
public OnPlayerNotificationClick(playerid, notificationid, actionid, vehicleid)
{
    if(actionid == 1 && vehicleid != INVALID_VEHICLE_ID)
    {
        
            if(!IsPlayerDriver(playerid))
            {
                SendClientMessage(playerid, 0xCECECEFF, "Вы не за рулем");
                return 1;
            }

            if(GetVehicleData(vehicleid, V_FUEL) <= 0.0)
            {
                GameTextForPlayer(playerid, "~r~no fuel", 4000, 1);
                return 1;
            }
			
            new engine = (GetVehicleParam(vehicleid, V_ENGINE) ^ VEHICLE_PARAM_ON);
            SetVehicleParam(vehicleid, V_ENGINE, engine);
			new i = GetVehicleData(vehicleid, V_ACTION_ID);
			if(i < 0 || i >= sizeof(vInfo)) return 1;
			if (vInfo[i][vHornSound] != 0){
                // Horn configuration is independent from engine state and is synchronized on StreamIn.
	
			if (vInfo[i][vExhaustSound] != 0)
			  SetVehicleExhaust(vehicleid, vInfo[i][vExhaustSound]-1, 1);
	    	switch (vInfo[i][vFstate]){
	    	    case FSTATE_DRIFT:
	    	       SetVehicleDriftForPlayer(playerid, vehicleid, 1);
	    	    case FSTATE_COMFORT:
	    	        SendCarFirmware(playerid, FSTATE_COMFORT);
	    	    case FSTATE_SPORT:
	    	        SendCarFirmware(playerid, FSTATE_SPORT);
	    	    case FSTATE_SPORT_PLUS:
	    	        SendCarFirmware(playerid, FSTATE_SPORT_PLUS);
	    	       
	        }
			if(vInfo[i][IsHydroActive]){
                SetVehicleHydraulics(vehicleid, 1, 0);
			}
			if(vInfo[i][IsFarLightActive]){
		SetVehicleFarLight(playerid, vehicleid, 1);
	 }
			if(vInfo[i][vEnableNeon])
    {
		SetVehicleNeonForPlayer(playerid, GetPlayerVehicleID(playerid), vInfo[i][underlights_color], vInfo[i][underlights_color_lf], vInfo[i][underlights_color_rt]);
	}
			switch (vInfo[i][SelectedPnevmo]){
	        	case 1:
	        	  SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.55);
	        	case 2:
	        	  SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.35);
	        	case 3:
	        	  SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.2);
	        }
			if (vInfo[i][percentofclirness] > 0 && vInfo[i][SelectedPnevmo] == 0){
		new Float:suspension = max(vInfo[i][percentofclirness] / 50.0, 0.2);
        SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, suspension);
	}
if (vInfo[i][percentofclirnessz] > 0){
		new suspension = min(max(vInfo[i][percentofclirnessz] / 100.0, 0.1), 0.9);
		
        SetVehicleSuspensionBiasFor(playerid, vehicleid, suspension);
	}
	
            ApplyOwnableVehicleNitro(playerid, vehicleid, vInfo[i][vNitro]);
        }
    }
    return 1;
}
/*CMD:coord(playerid)
{
	new Float:x, Float:y, Float:z; // generated
	GetPlayerPos(playerid, x, y, z); // generated
	printf("%f,%f,%f.", x, y, z);
	return true;
}*/
CMD:pos(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) == 0) return 1;

	new Float: x, Float: y, Float: z, interior, virtual_world;

	if(sscanf(params, "P<,>fff", x, y, z))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /pos [x y z]");

	sscanf(params, "P<,>{fff}dd", interior, virtual_world);

	return SetPlayerPosEx(playerid, x, y, z, interior, virtual_world);
}

CMD:d(playerid, params[])
{
	if(!GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в организациях");
	else if(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(playerid) <= TEAM_OPG_LYTKARINSKAYA) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна для сотрудников гос. организаций");
	else if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	else if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /d [текст]");

	new fmt_msg[144];

	format(fmt_msg, sizeof fmt_msg, "[D] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);

	if(IsAIP(params))
	{
      	SendClientMessage(playerid, -1, "Подозрения в рекламе!");
       	return false;
    }

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(!GetPlayerTeamEx(i)) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		SendClientMessage(i, 0xFF9999FF, fmt_msg);
	}

	SetPlayerChatBubble(playerid, "сказал(а) что-то в рацию организаций", 0xDD99FFAA, 10.0, 4000);

	return 1;
}

CMD:dd(playerid, params[])
{
	if(!GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в организациях");
	else if(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(playerid) <= TEAM_OPG_LYTKARINSKAYA) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна для сотрудников гос. организаций");
	else if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xFF6600FF, "Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	else if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /dd [текст]");

	new fmt_msg[144];

	format(fmt_msg, sizeof fmt_msg, "(( [D] %s %s[%d]: %s ))", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);

	if(IsAIP(params))
	{
      	SendClientMessage(playerid, -1, "Подозрения в рекламе!");
       	return false;
    }

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(!GetPlayerTeamEx(i)) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		SendClientMessage(i, 0xFF9999FF, fmt_msg);
	}

	SetPlayerChatBubble(playerid, "сказал(а) что-то в рацию организаций", 0xDD99FFAA, 10.0, 4000);

	return 1;
}

CMD:r(playerid, params[])
{
	if(!(GetPlayerTeamEx(playerid) || GetPlayerJob(playerid))) return SendClientMessage(playerid, 0xCECECEFF, "Вы нигде не работаете/не состоите в организациях");
	else if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xCECECEFF, "Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	else if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /r [текст]");

	new fmt_msg[144];

	format(fmt_msg, sizeof fmt_msg, "[R] %s %s[%d]: %s", GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, params);

	if(!GetPlayerTeamEx(playerid))
		SendMessageToJob(GetPlayerJob(playerid), fmt_msg), SendClientMessage(playerid,-1,"Работаит");//	SendMessageToJob(GetPlayerJob(playerid), fmt_msg, 0x33CC66FF, _, true);
	else
	    SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_msg, 0x33CC66FF);

	SetPlayerChatBubble(playerid, "сказал(а) что-то в рацию", 0xDD99FFAA, 10.0, 4000);
	return 1;
}

