//>> Файл: bykranin_src/core/vehicle/autosalon_01.inc  (234 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: SendAutosalonPreviewColor, AutosalonApplyPreviewColorDelayed, SyncAutosalonSelectedColors, ApplyAutosalonPreviewColor, GetAutosalonTestDrivePrice, StopAutosalonTestDriveMonitor, StartAutosalonTestDriveMonitor
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock SendAutosalonPreviewColor(playerid, vehicleid, body_color, wheel_color)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 1;
    if(!(0 <= body_color < sizeof(VehicleColoursTableRGBA))) return 1;
    if(!(0 <= wheel_color < sizeof(VehicleColoursTableRGBA))) return 1;

    vInfo[vehicleid][vColorBody] = VehicleColoursTableRGBA[body_color];
    vInfo[vehicleid][vColorWheels] = VehicleColoursTableRGBA[wheel_color];
    SetVehicleColorForPlayer(playerid, vehicleid, RGBA_to_ARGB(vInfo[vehicleid][vColorBody]), RGBA_to_ARGB(vInfo[vehicleid][vColorWheels]));
    return 1;
}

forward AutosalonApplyPreviewColorDelayed(playerid, vehicleid, body_color, wheel_color);
public AutosalonApplyPreviewColorDelayed(playerid, vehicleid, body_color, wheel_color)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(GetPlayerData(playerid, P_BUY_CAR) != vehicleid) return 1;
    return SendAutosalonPreviewColor(playerid, vehicleid, body_color, wheel_color);
}

stock SyncAutosalonSelectedColors(playerid)
{
    new body_color = buy_car_select_color[playerid][0];
    new wheel_color = buy_car_select_color[playerid][1];

    if(!(0 <= body_color <= MAX_COLOR_ID)) body_color = GetPlayerData(playerid, P_AUTOSALON_COLOR1);
    if(!(0 <= wheel_color <= MAX_COLOR_ID)) wheel_color = GetPlayerData(playerid, P_AUTOSALON_COLOR2);
    if(!(0 <= body_color <= MAX_COLOR_ID)) body_color = 1;
    if(!(0 <= wheel_color <= MAX_COLOR_ID)) wheel_color = 1;

    buy_car_select_color[playerid][0] = body_color;
    buy_car_select_color[playerid][1] = wheel_color;
    SetPlayerData(playerid, P_AUTOSALON_COLOR1, body_color);
    SetPlayerData(playerid, P_AUTOSALON_COLOR2, wheel_color);
    return 1;
}

stock ApplyAutosalonPreviewColor(playerid)
{
	new vehicleid = GetPlayerData(playerid, P_BUY_CAR);
	if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 1;

    SyncAutosalonSelectedColors(playerid);
	new body_color = GetPlayerData(playerid, P_AUTOSALON_COLOR1);
	new wheel_color = GetPlayerData(playerid, P_AUTOSALON_COLOR2);

    SendAutosalonPreviewColor(playerid, vehicleid, body_color, wheel_color);
    SetTimerEx("AutosalonApplyPreviewColorDelayed", 80, false, "iiii", playerid, vehicleid, body_color, wheel_color);
    SetTimerEx("AutosalonApplyPreviewColorDelayed", 250, false, "iiii", playerid, vehicleid, body_color, wheel_color);
    SetTimerEx("AutosalonApplyPreviewColorDelayed", 600, false, "iiii", playerid, vehicleid, body_color, wheel_color);
	return 1;
}

stock GetAutosalonTestDrivePrice(playerid)
{
	new biz_id = GetPlayerInBiz(playerid);
	if(biz_id == -1) return 2500;

	switch(GetCarMarketIdByBizId(biz_id))
	{
		case MOTO_SALON_MARKET_ID: return 5000;
		case 2: return 15000;
		case 3: return 7500;
		case TRUCK_SALON_MARKET_ID: return 3500;
	}
	return 2500;
}

forward AutosalonTestDriveFinishMessage(playerid);
forward AutosalonTestDriveMonitor(playerid);

stock StopAutosalonTestDriveMonitor(playerid)
{
	new timerid = GetPVarInt(playerid, "autosalon_testdrive_timer");
	if(timerid)
	{
		KillTimer(timerid);
		DeletePVar(playerid, "autosalon_testdrive_timer");
	}
	return 1;
}

stock StartAutosalonTestDriveMonitor(playerid)
{
	StopAutosalonTestDriveMonitor(playerid);
	SetPVarInt(playerid, "autosalon_testdrive_timer", SetTimerEx("AutosalonTestDriveMonitor", 1000, false, "i", playerid));
	return 1;
}

public AutosalonTestDriveFinishMessage(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	ShowNotificationNew(playerid, 2, 6, 0, 0, "Мы очень надеемся, что нам удалось Вам определиться с выбором транспорта!", " ");
	return 1;
}

public AutosalonTestDriveMonitor(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	DeletePVar(playerid, "autosalon_testdrive_timer");

	if(!GetPVarInt(playerid, "autosalon_testdrive_active"))
		return 1;

	new vehicleid = GetPlayerData(playerid, P_BUY_CAR);
	if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
		return ReturnPlayerToAutosalonPreview(playerid, 1);

	new Float:x, Float:y, Float:z;
	if(IsPlayerInVehicle(playerid, vehicleid))
		GetVehiclePos(vehicleid, x, y, z);
	else
		GetPlayerPos(playerid, x, y, z);

	if(!IsPointInSphere(x, y, z, -1569.918945, 1620.401245, 36.440906, 350.0))
	{
		if(IsPlayerInVehicle(playerid, vehicleid))
			RemovePlayerFromVehicle(playerid);
		return ReturnPlayerToAutosalonPreview(playerid, 2);
	}

	return StartAutosalonTestDriveMonitor(playerid);
}

stock ReturnPlayerToAutosalonPreview(playerid, finish_reason = 1)
{
	new return_lock = GetPVarInt(playerid, "autosalon_preview_return_lock");
	if(return_lock > GetTickCount())
	{
		return 1;
	}
	SetPVarInt(playerid, "autosalon_preview_return_lock", GetTickCount() + 1500);

	new vehicleid = GetPlayerData(playerid, P_BUY_CAR);
	new biz_id = GetPlayerInBiz(playerid);
	if(biz_id == -1) return 1;

	new car_market_id = GetCarMarketIdByBizId(biz_id);
	if(car_market_id == -1) return 1;
	new select_car = buy_car_select_car[playerid];

	StopAutosalonTestDriveMonitor(playerid);
	DeletePVar(playerid, "autosalon_testdrive_active");
	DeletePVar(playerid, "autosalon_testdrive_price");

	if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
	{
		vehicleid = CreateVehicle
		(
			car_market_data[car_market_id][select_car][CM_MODELID],
			1149.8434, 226.0655, 995.1953, 67.6542,
			1,
			1,
			1
		);
		SetPlayerData(playerid, P_BUY_CAR, vehicleid);
		SetVehicleNumberPlateEx(vehicleid, TYPE_RU, "", "");
	}

	ApplyCarMarketPreviewScene(playerid, vehicleid, car_market_id);
	ApplyAutosalonPreviewColor(playerid);

	CreateAutosalonTextDraws(playerid);
	HideHud(playerid);
	SelectTextDraw(playerid, 0xFFFFFFFF);
	RefreshAutosalonChat(playerid);

	switch(finish_reason)
	{
		case 1:
		{
			ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы покинули транспортное средство, тест-драйв был закончен.", " ");
			SetTimerEx("AutosalonTestDriveFinishMessage", 1500, false, "i", playerid);
		}
		case 2:
		{
			ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы покинули поле для тест-драйва, он был закончен.", " ");
			SetTimerEx("AutosalonTestDriveFinishMessage", 1500, false, "i", playerid);
		}
	}
	return 1;
}

stock StartAutosalonTestDrive(playerid)
{
	new vehicleid = GetPlayerData(playerid, P_BUY_CAR);
	if(vehicleid == INVALID_VEHICLE_ID) return 1;
	DeletePVar(playerid, "autosalon_preview_return_lock");

	new price = GetAutosalonTestDrivePrice(playerid);
	if(GetPlayerMoneyEx(playerid) < price)
	{
		ShowNotificationNew(playerid, 2, 6, 0, 0, "Недостаточно средств для оплаты тест-драйва", " ");
		return 1;
	}

	GivePlayerMoneyEx(playerid, -price, "Тест-драйв", true, true);

	new spend_str[64];
	format(spend_str, sizeof spend_str, "Вы потратили %d рублей", price);
	ShowNotificationNew(playerid, 2, 6, 0, 0, spend_str, " ");

	HideAutosalonTextDraws(playerid);
	ShowHud(playerid);

	SetPVarInt(playerid, "autosalon_testdrive_active", 1);
	SetPVarInt(playerid, "autosalon_testdrive_price", price);
	BlackPass_OnTestDriveStarted(playerid);

	TogglePlayerControllable(playerid, true);
	SetPlayerCleanChat(playerid, 0);
	SetPlayerVirtualWorld(playerid, playerid + 5000);
	SetPlayerInterior(playerid, 0);
	SetPlayerPosEx(playerid, -1569.918945, 1620.401245, 36.440906, 178.751403, 0, playerid + 5000, false);

	SetVehiclePos(vehicleid, -1569.918945, 1620.401245, 36.440906);
	SetVehicleZAngle(vehicleid, 178.751403);
	SetVehicleVirtualWorld(vehicleid, playerid + 5000);
	LinkVehicleToInterior(vehicleid, 0);
	SetVehicleNumberPlateEx(vehicleid, TYPE_RU, "", "");
	ApplyAutosalonPreviewColor(playerid);
	PutPlayerInVehicle(playerid, vehicleid, 0);

	SetVehicleParamsEx(vehicleid, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF);
	ShowNotificationNew(playerid, 4, 6, 0, 0, "Двигатель автомобиля выключен.", " ");
	StartAutosalonTestDriveMonitor(playerid);
	return 1;
}
public: ChangeColorPTDUpdate(playerid)
{
	return 1;
}
