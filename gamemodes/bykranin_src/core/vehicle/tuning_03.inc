//>> Файл: bykranin_src/core/vehicle/tuning_03.inc  (739 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: SetVehicleLaunchControl, SetVehicleLaunchControlFP, /lc, SetVehicleHighLight, SetVehicleHighLightForPlayer, /hl, SetVehicleSpeedometerInfo
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock SetVehicleLaunchControl(vehicleid, type, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vLaunchControl] = type;
	foreach(new playerid: Player) SetVehicleLaunchControlFP(playerid, vehicleid, type);
}

stock SetVehicleLaunchControlFP(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 23);

	BS_WriteValue(bitstream, PR_UINT8, type);

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}

CMD:lc(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "Вы должны находиться в транспорте!");

    new vehicleid = GetPlayerVehicleID(playerid);

    // type всегда 1
    SetVehicleLaunchControl(vehicleid, 1, 1);

    SendClientMessage(playerid, -1, "launch");

    SendClientMessage(playerid, -1, "launch");

    return 1;
}
stock SetVehicleHighLight(vehicleid, type, setvalue=0)
{
  if(setvalue) vInfo[vehicleid][vHighLights] = type;
  foreach(new playerid: Player) SetVehicleHighLightForPlayer(playerid, vehicleid, type);
}

stock SetVehicleHighLightForPlayer(playerid, vehicleid, type)
{
  new BitStream:bitstream = BS_New();
  BS_WriteValue(bitstream, PR_UINT16, vehicleid);
  BS_WriteValue(bitstream, PR_UINT8, 22);

  BS_WriteValue(bitstream, PR_UINT8, type);

  PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
  BS_Delete(bitstream);
}

CMD:hl(playerid, type)
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (vehicleid == 0) {
        SendClientMessage(playerid, COLOR_RED, "Вы должны находиться в транспортном средстве.");
        return 1;
    }

    // Включаем подсветку с указанным типом
    SetVehicleHighLight(vehicleid, type, 1); // 1 - это значение для установки подсветки

    SendClientMessage(playerid, COLOR_WHITE, "test neon");

    return 1;
}
stock SetVehicleSpeedometerInfo(vehicleid, Float:fuel = 52.0, Float:mileage = 1488.0)
{
	if(!IsValidVehicle(vehicleid)) return 0;

	SetVehicleData(vehicleid, V_FUEL, fuel);
	SetVehicleData(vehicleid, V_MILEAGE, mileage);

	vInfo[vehicleid][vFuel] = fuel;
	vInfo[vehicleid][vMileage] = mileage;

	foreach(new playerid: Player)
	{
		if(GetPlayerVehicleID(playerid) == vehicleid && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehicleSpeedometerInfoFP(playerid, vehicleid, fuel, mileage);
		else continue;
	}
	return 1;
}

stock SetVehicleSpeedometerInfoFP(playerid, vehicleid, Float:fuel = 52.0, Float:mileage = 1488.0)
{
	if(!IsPlayerConnected(playerid) || !IsValidVehicle(vehicleid)) return 0;

	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 14);

	BS_WriteValue(bitstream, PR_UINT32, fuel);
	BS_WriteValue(bitstream, PR_UINT32, mileage);

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
	return 1;
}

CMD:speedo(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
    	return SendClientMessage(playerid, -1, "Вы должны быть в автомобиле!");

	new vehicleid = GetPlayerVehicleID(playerid);

	SetVehicleSpeedometerInfoFP(playerid, vehicleid, 120.0, 130.0);

	return 1;
}
CMD:neon(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);

    // generated
    new center = 0xFF0000FF; // generated
    new right = 0x00FF00FF;  // generated
    new left = 0x0000FFFF;   // generated

    SetVehicleLightingColor(vehicleid, center, right, left, 2);

    return 1;
}
stock SetVehicleLightingColor(vehicleid, center, right, left, setvalue=0)
{
  if(setvalue)
  {
    vInfo[vehicleid][vNeon][0] = center;
    vInfo[vehicleid][vNeon][1] = right;
    vInfo[vehicleid][vNeon][2] = left;
  }

  foreach(new playerid : streamed_players_in_veh[vehicleid]) SetVehicleLightingForPlayer(playerid, vehicleid, RGBA_to_ARGB(center), RGBA_to_ARGB(right), RGBA_to_ARGB(left));
}

stock SetVehicleLightingForPlayer(playerid, vehicleid, center, right, left)
{
  new BitStream:bitstream = BS_New();
  BS_WriteValue(bitstream, PR_UINT16, vehicleid);
  BS_WriteValue(bitstream, PR_UINT8, 9);

  BS_WriteValue(bitstream, PR_UINT32, center);
  BS_WriteValue(bitstream, PR_UINT32, right);
  BS_WriteValue(bitstream, PR_UINT32, left);

  PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
  BS_Delete(bitstream);
}
stock RGBA_to_ARGB(color)
{
    return ((color & 0xffff00 ) >> 24) | (color & 0xffffff);
}
stock HexToInt(const hex[])
{
    new result = 0;
    for (new i = 0; hex[i] != '\0'; i++)
    {
        result *= 16;

        if (hex[i] >= '0' && hex[i] <= '9')
            result += hex[i] - '0';
        else if (hex[i] >= 'A' && hex[i] <= 'F')
            result += hex[i] - 'A' + 10;
        else if (hex[i] >= 'a' && hex[i] <= 'f')
            result += hex[i] - 'a' + 10;
        else
            return 0; // не hex
    }
    return result;
}

// Local helpers for the existing GUI 28 styling purchase branches.
stock bool:Styling_CanEdit(playerid, vehicleid)
{
    if(!IsPlayerLogged(playerid) || !IsValidVehicle(vehicleid) ||
       GetPlayerVehicleID(playerid) != vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER ||
       !IsAOwnableCar(vehicleid)) return false;
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || index >= MAX_OWNABLE_CARS || index >= sizeof(vInfo)) return false;
    return GetOwnableCarData(index, OC_SQL_ID) > 0 &&
        GetOwnableCarData(index, OC_OWNER_ID) == GetPlayerAccountID(playerid);
}

stock Styling_GetServiceBusiness(playerid)
{
    new business_type;
    switch(GetPlayerData(playerid, P_LAST_TUNING))
    {
        case 0: business_type = BUSINESS_TYPE_STYLING_CENTER;
        case 2: business_type = BUSINESS_TYPE_TIRE_CENTER;
        case 3: business_type = BUSINESS_TYPE_TECH_CENTER;
        default: return -1;
    }
    for(new businessid; businessid < g_business_loaded; businessid++)
        if(GetBusinessData(businessid, B_TYPE) == business_type) return businessid;
    return -1;
}

stock bool:Styling_CanCompleteServicePurchase(playerid)
{
    new service_business = Styling_GetServiceBusiness(playerid);
    if(service_business == -1 || !IsBusinessOwned(service_business)) return true;
    if(GetBusinessData(service_business, B_PRODS) > 0) return true;

    SendClientMessage(playerid, -1, "В центре закончились товары. Владелец должен пополнить склад.");
    return false;
}

stock Styling_RegisterServiceSale(playerid, money_cost, donate_cost = 0)
{
    new service_business = Styling_GetServiceBusiness(playerid);
    if(service_business == -1 || !IsBusinessOwned(service_business)) return 1;

    // 5% of rubles; 1 BC is converted to 10 rubles before calculating the share.
    new owner_income = money_cost / 20 + donate_cost / 2;
    AddBusinessData(service_business, B_PRODS, -, 1);
    AddBusinessData(service_business, B_BALANCE, +, owner_income);

    new query[192];
    mysql_format(mysql, query, sizeof query,
        "UPDATE business SET products=%d,balance=%d WHERE id=%d LIMIT 1",
        GetBusinessData(service_business, B_PRODS), GetBusinessData(service_business, B_BALANCE),
        GetBusinessData(service_business, B_SQL_ID));
    mysql_query(mysql, query, false);
    UpdateBusinessLabel(service_business);
    return 1;
}

stock bool:Styling_SavePurchase(playerid, vehicleid, const assignments[], cost, donate_cost = 0)
{
    if(!Styling_CanEdit(playerid, vehicleid) || cost < 0 || donate_cost < 0) return false;
    if(!Styling_CanCompleteServicePurchase(playerid)) return false;
    new money = GetPlayerData(playerid, P_MONEY), donate = GetPlayerDonateRub(playerid);
    if(money < cost || donate < donate_cost)
    {
        SendClientMessage(playerid, -1, "Недостаточно средств для покупки тюнинга.");
        return false;
    }
    new index = GetVehicleData(vehicleid, V_ACTION_ID), query[768];
    // The SET fragment is constructed only by the server, never from a client field name.
    mysql_format(mysql, query, sizeof query,
        "UPDATE ownable_cars AS v INNER JOIN accounts AS a ON a.id=v.owner_id SET %s,a.money=%d,a.rub=%d WHERE v.id=%d AND v.owner_id=%d",
        assignments, money - cost, donate - donate_cost,
        GetOwnableCarData(index, OC_SQL_ID), GetPlayerAccountID(playerid));
    new Cache:saved = mysql_query(mysql, query, true);
    new error = mysql_errno(mysql), affected = cache_affected_rows();
    cache_delete(saved);
    if(error)
    {
        printf("[STYLING][SQL_ERROR] player=%d car=%d errno=%d", playerid,
            GetOwnableCarData(index, OC_SQL_ID), error);
        SendClientMessage(playerid, -1, "Ошибка сохранения тюнинга. Сообщите администрации.");
        return false;
    }
    // A paid purchase must have updated the joined account row.
    if(affected == 0 && (cost || donate_cost)) return false;
    SetPlayerData(playerid, P_MONEY, money - cost);
    SetPlayerData(playerid, P_DONATE_RUB, donate - donate_cost);
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, money - cost);
	Styling_RegisterServiceSale(playerid, cost, donate_cost);
    printf("[STYLING][SAVE] player=%d car=%d cost=%d donate=%d values=%s", playerid,
        GetOwnableCarData(index, OC_SQL_ID), cost, donate_cost, assignments);
    return true;
}

// Wheel shop uses persisted percent+1; zero means stock.
stock Styling_WheelPercent(index, selector)
{
    new value;
    switch(selector)
    {
        case 22: { value = GetOwnableCarData(index, OC_percentofclirness); if(value == 0) return 50; }
        case 23: { value = GetOwnableCarData(index, OC_percentofclirnessZ); if(value == 0) return 50; }
        case 24: { value = GetOwnableCarData(index, OC_wheel_offset_ft); if(value == 0) return 50; }
        case 25: { value = GetOwnableCarData(index, OC_wheel_offset_rr); if(value == 0) return 50; }
        case 26: { value = GetOwnableCarData(index, OC_align_ft); if(value == 0) return 0; }
        case 27: { value = GetOwnableCarData(index, OC_align_rr); if(value == 0) return 0; }
        case 28: { value = GetOwnableCarData(index, OC_width_ft); if(value == 0) return 40; }
        case 29: { value = GetOwnableCarData(index, OC_width_rr); if(value == 0) return 40; }
        case 30: { value = GetOwnableCarData(index, OC_wheel_radius); if(value == 0) return 75; }
        default: return 0;
    }
    return min(100, max(0, value - 1));
}

stock Styling_ApplyWheelShopVisuals(vehicleid)
{
    if(!IsValidVehicle(vehicleid) || !IsAOwnableCar(vehicleid) || !Styling_SyncVisualCache(vehicleid)) return 0;

    new applied;
    foreach(new target: Player)
    {
        if(!IsVehicleStreamedIn(vehicleid, target) && GetPlayerVehicleID(target) != vehicleid) continue;
        Styling_ApplyWheels(target, vehicleid);
        applied++;
    }
    return applied;
}

forward Styling_ReapplyWheelShopDelayed(vehicleid, sqlid, ownerid);
public Styling_ReapplyWheelShopDelayed(vehicleid, sqlid, ownerid)
{
    if(!IsValidVehicle(vehicleid) || !IsAOwnableCar(vehicleid)) return 0;
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || index >= MAX_OWNABLE_CARS || index >= sizeof(vInfo)) return 0;
    if(GetOwnableCarData(index, OC_SQL_ID) != sqlid || GetOwnableCarData(index, OC_OWNER_ID) != ownerid) return 0;
    return Styling_ApplyWheelShopVisuals(vehicleid);
}

stock Styling_ScheduleWheelShopReapply(vehicleid)
{
    if(!IsValidVehicle(vehicleid) || !IsAOwnableCar(vehicleid)) return 0;
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || index >= MAX_OWNABLE_CARS || index >= sizeof(vInfo)) return 0;
    new sqlid = GetOwnableCarData(index, OC_SQL_ID);
    new ownerid = GetOwnableCarData(index, OC_OWNER_ID);
    if(sqlid <= 0 || ownerid <= 0) return 0;

    Styling_ApplyWheelShopVisuals(vehicleid);
    SetTimerEx("Styling_ReapplyWheelShopDelayed", 120, false, "ddd", vehicleid, sqlid, ownerid);
    SetTimerEx("Styling_ReapplyWheelShopDelayed", 450, false, "ddd", vehicleid, sqlid, ownerid);
    return 1;
}

stock bool:Styling_BuyDisk(playerid, vehicleid, item)
{
    if(!Styling_CanEdit(playerid, vehicleid) || GetTuneSelectorFromItem(item) != 31) return false;
    new componentid = GetWheelTuneComponentId(item);
    if(componentid <= 0) return false;
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(GetOwnableCarData(index, OC_wheelcomp) == item) return true;
    new price = GetVehiclePriceByModel(GetVehicleData(vehicleid, V_MODELID)), values[64];
    if(price <= 0) return false;
    format(values, sizeof values, "v.wheel_comp=%d", item);
    if(!Styling_SavePurchase(playerid, vehicleid, values, max(1, floatround(price * 1.1393728 / 100.0)))) return false;
    new old_component = GetWheelTuneComponentId(GetOwnableCarData(index, OC_wheelcomp));
    SetOwnableCarData(index, OC_wheelcomp, item);
    vInfo[index][wheel_comp] = item;
    PermanentTuning_RebuildVehicleState(vehicleid);
    foreach(new target: Player)
    {
        if(!IsVehicleStreamedIn(vehicleid, target) && GetPlayerVehicleID(target) != vehicleid) continue;
        if(old_component > 0) RemoveFromVehicleComponentForPlayer(target, vehicleid, old_component);
        AddToVehicleComponentForPlayer(target, vehicleid, componentid);
    }
    // The mobile styling preview can restore its temporary wheel state after the buy response.
    // Replay the saved server state immediately and twice after the response so the purchased
    // wheels remain visible for the driver and every streamed observer.
    Styling_ScheduleWheelShopReapply(vehicleid);
    return true;
}

stock Styling_WheelState(playerid, vehicleid, JSON:response)
{
    if(!Styling_CanEdit(playerid, vehicleid)) return 0;
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    new JSON:values = JSON_Array();
    for(new selector = 22; selector <= 30; selector++)
        values = JSON_Append(values, JSON_Int(Styling_WheelPercent(index, selector)));
    JSON_SetInt(response, "t", 28);
    JSON_SetArray(response, "u", values);
    JSON_Cleanup(values);
    printf("[STYLING][WHEEL_STATE] player=%d car=%d clearance=%d bias=%d",
        playerid, GetOwnableCarData(index, OC_SQL_ID),
        Styling_WheelPercent(index, 22), Styling_WheelPercent(index, 23));
    return 1;
}

stock bool:Styling_BuyWheelSetting(playerid, vehicleid, selector, percent)
{
    if(!Styling_CanEdit(playerid, vehicleid) || selector < 22 || selector > 30 ||
       percent < 0 || percent > 100)
    {
        printf("[STYLING][WHEEL_REJECT] player=%d selector=%d percent=%d", playerid, selector, percent);
        return false;
    }
    new index = GetVehicleData(vehicleid, V_ACTION_ID), field[32];
    new E_OWNABLE_CAR_STRUCT:slot, Float:rate;
    switch(selector)
    {
        case 22: { format(field, sizeof field, "percentofclirness"); slot = OC_percentofclirness; rate = 10.5574913; }
        case 23: { format(field, sizeof field, "percentofclirnessZ"); slot = OC_percentofclirnessZ; rate = 7.4181185; }
        case 24: { format(field, sizeof field, "wheel_offset_ft"); slot = OC_wheel_offset_ft; rate = 3.5574913; }
        case 25: { format(field, sizeof field, "wheel_offset_rr"); slot = OC_wheel_offset_rr; rate = 3.5574913; }
        case 26: { format(field, sizeof field, "align_ft"); slot = OC_align_ft; rate = 5.5574913; }
        case 27: { format(field, sizeof field, "align_rr"); slot = OC_align_rr; rate = 5.5574913; }
        case 28: { format(field, sizeof field, "width_ft"); slot = OC_width_ft; rate = 5.6968641; }
        case 29: { format(field, sizeof field, "width_rr"); slot = OC_width_rr; rate = 5.6968641; }
        case 30: { format(field, sizeof field, "wheel_radius"); slot = OC_wheel_radius; rate = 8.3937282; }
    }
    new stored = percent + 1;
    if(GetOwnableCarData(index, slot) == stored) return true;
    new model_price = GetVehiclePriceByModel(GetVehicleData(vehicleid, V_MODELID));
    if(model_price <= 0) return false;
    new values[96];
    format(values, sizeof values, "v.`%s`=%d", field, stored);
    if(!Styling_SavePurchase(playerid, vehicleid, values, max(1, floatround(model_price * rate / 100.0)))) return false;
    SetOwnableCarData(index, slot, stored);
    switch(selector)
    {
        case 22: vInfo[index][percentofclirness] = stored;
        case 23: vInfo[index][percentofclirnessz] = stored;
        case 24: vInfo[index][wheel_offset_ft] = stored;
        case 25: vInfo[index][wheel_offset_rr] = stored;
        case 26: vInfo[index][align_ft] = stored;
        case 27: vInfo[index][align_rr] = stored;
        case 28: vInfo[index][width_ft] = stored;
        case 29: vInfo[index][width_rr] = stored;
        case 30: vInfo[index][wheel_radius] = stored;
    }
    printf("[STYLING][WHEEL_SAVE] player=%d car=%d selector=%d percent=%d", playerid,
        GetOwnableCarData(index, OC_SQL_ID), selector, percent);

    // V11 tire-shop fix: saving alone did not change the live vehicle. Apply all persisted
    // wheel geometry now (clearance/bias/offset/camber/width/radius) and replay it after
    // the client closes its temporary preview state.
    Styling_ScheduleWheelShopReapply(vehicleid);
    return true;
}

// Only visual/wheel fields: do not run LoadTuning or reset working firmware.
stock Styling_SyncVisualCache(vehicleid)
{
    if(!IsValidVehicle(vehicleid) || !IsAOwnableCar(vehicleid)) return 0;
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || index >= MAX_OWNABLE_CARS || index >= sizeof(vInfo)) return 0;
    vInfo[index][percentofclirness] = GetOwnableCarData(index, OC_percentofclirness);
    vInfo[index][percentofclirnessz] = GetOwnableCarData(index, OC_percentofclirnessZ);
    vInfo[index][wheel_offset_ft] = GetOwnableCarData(index, OC_wheel_offset_ft);
    vInfo[index][wheel_offset_rr] = GetOwnableCarData(index, OC_wheel_offset_rr);
    vInfo[index][align_ft] = GetOwnableCarData(index, OC_align_ft);
    vInfo[index][align_rr] = GetOwnableCarData(index, OC_align_rr);
    vInfo[index][width_ft] = GetOwnableCarData(index, OC_width_ft);
    vInfo[index][width_rr] = GetOwnableCarData(index, OC_width_rr);
    vInfo[index][wheel_radius] = GetOwnableCarData(index, OC_wheel_radius);
    vInfo[index][body_colors] = GetOwnableCarData(index, OC_body_colors);
    vInfo[index][wheel_colors] = GetOwnableCarData(index, OC_wheelcolors);
    vInfo[index][tonir_ft] = GetOwnableCarData(index, OC_tonir_ft);
    vInfo[index][tonir_rr] = GetOwnableCarData(index, OC_tonir_rr);
    vInfo[index][wheel_comp] = GetOwnableCarData(index, OC_wheelcomp);
    return 1;
}

stock Styling_ApplySavedSuspension(playerid, vehicleid)
{
    if(!IsPlayerConnected(playerid) || !IsValidVehicle(vehicleid) || !IsAOwnableCar(vehicleid)) return 0;
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || index >= MAX_OWNABLE_CARS || index >= sizeof(vInfo)) return 0;
    new pneumatic = GetOwnableCarData(index, OC_PnevmoSelected);
    switch(pneumatic)
    {
        case 1: SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.55);
        case 2: SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.35);
        case 3: SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.2);
    }
    if(pneumatic == 0 && GetOwnableCarData(index, OC_percentofclirness) > 0)
    {
        new Float:height = Styling_WheelPercent(index, 22) / 50.0;
        if(height < 0.2) height = 0.2;
        SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, height);
    }
    if(GetOwnableCarData(index, OC_percentofclirnessZ) > 0)
    {
        new Float:bias = Styling_WheelPercent(index, 23) / 100.0;
        if(bias < 0.1) bias = 0.1;
        if(bias > 0.9) bias = 0.9;
        SetVehicleSuspensionBiasFor(playerid, vehicleid, bias);
    }
    return 1;
}

stock Styling_QueueSuspension(vehicleid)
{
    if(!IsValidVehicle(vehicleid) || !IsAOwnableCar(vehicleid)) return 0;
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || index >= MAX_OWNABLE_CARS) return 0;
    if(!GetOwnableCarData(index, OC_percentofclirness) &&
       !GetOwnableCarData(index, OC_percentofclirnessZ) &&
       !GetOwnableCarData(index, OC_PnevmoSelected)) return 0;
    if(g_StylingSuspensionTimer[vehicleid]) KillTimer(g_StylingSuspensionTimer[vehicleid]);
    new token = ++g_StylingSuspensionToken[vehicleid];
    g_StylingSuspensionTimer[vehicleid] = SetTimerEx("Styling_ReplaySuspension", 500, false, "ddddd",
        vehicleid, GetOwnableCarData(index, OC_SQL_ID), GetOwnableCarData(index, OC_OWNER_ID), token, 0);
    return 1;
}

forward Styling_ReplaySuspension(vehicleid, sqlid, ownerid, token, stage);
public Styling_ReplaySuspension(vehicleid, sqlid, ownerid, token, stage)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || token != g_StylingSuspensionToken[vehicleid]) return 0;
    g_StylingSuspensionTimer[vehicleid] = 0;
    if(!IsValidVehicle(vehicleid) || !IsAOwnableCar(vehicleid)) return 0;
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || index >= MAX_OWNABLE_CARS ||
       GetOwnableCarData(index, OC_SQL_ID) != sqlid || GetOwnableCarData(index, OC_OWNER_ID) != ownerid) return 0;
    new targets;
    foreach(new target: Player)
    {
        if(!IsVehicleStreamedIn(vehicleid, target) && GetPlayerVehicleID(target) != vehicleid) continue;
        // Do not overwrite a native shop preview with a delayed spawn replay.
        if(GetPlayerVehicleID(target) == vehicleid && GetPlayerInterior(target) == 1 &&
           GetPlayerVirtualWorld(target) == vehicleid &&
           (GetPlayerData(target, P_LAST_TUNING) == 0 || GetPlayerData(target, P_LAST_TUNING) == 2)) continue;
        Styling_ApplySavedSuspension(target, vehicleid);
        targets++;
    }
    if(stage == 0)
        g_StylingSuspensionTimer[vehicleid] = SetTimerEx("Styling_ReplaySuspension", 1000, false, "ddddd",
            vehicleid, sqlid, ownerid, token, 1);
    else
        printf("[STYLING][SUSPENSION_LOAD] car=%d vehicle=%d saved_height=%d saved_bias=%d pneumatic=%d viewers=%d",
            sqlid, vehicleid, GetOwnableCarData(index, OC_percentofclirness),
            GetOwnableCarData(index, OC_percentofclirnessZ), GetOwnableCarData(index, OC_PnevmoSelected), targets);
    return 1;
}

stock Styling_ApplyWheels(playerid, vehicleid)
{
    if(!IsPlayerConnected(playerid) || !Styling_SyncVisualCache(vehicleid)) return 0;
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    // Leave cars with no saved wheel-shop settings on their factory geometry.
    if(!GetOwnableCarData(index, OC_wheelcomp) &&
       !GetOwnableCarData(index, OC_percentofclirness) && !GetOwnableCarData(index, OC_percentofclirnessZ) &&
       !GetOwnableCarData(index, OC_wheel_offset_ft) && !GetOwnableCarData(index, OC_wheel_offset_rr) &&
       !GetOwnableCarData(index, OC_align_ft) && !GetOwnableCarData(index, OC_align_rr) &&
       !GetOwnableCarData(index, OC_width_ft) && !GetOwnableCarData(index, OC_width_rr) &&
       !GetOwnableCarData(index, OC_wheel_radius)) return 1;
    SetVehicleWheelOffsetForPlayer(playerid, vehicleid,
        Styling_WheelPercent(index, 24) / 400.0 - 0.125,
        Styling_WheelPercent(index, 25) / 400.0 - 0.125);
    SetVehicleWheelAlignForPlayer(playerid, vehicleid,
        Styling_WheelPercent(index, 26) / -200.0,
        Styling_WheelPercent(index, 27) / -200.0);
    SetVehicleWheelAddForPlayer(playerid, vehicleid,
        Styling_WheelPercent(index, 28) / 80.0 + 0.5,
        Styling_WheelPercent(index, 29) / 80.0 + 0.5);
    SetVehicleWheelRadForPlayer(playerid, vehicleid, Styling_WheelPercent(index, 30) / 250.0 + 0.7);
    Styling_ApplySavedSuspension(playerid, vehicleid);
    new componentid = GetWheelTuneComponentId(GetOwnableCarData(index, OC_wheelcomp));
    if(componentid > 0) AddToVehicleComponentForPlayer(playerid, vehicleid, componentid);
    return 1;
}

forward Styling_ExitReapply(playerid, vehicleid, accountid, sqlid);
public Styling_ExitReapply(playerid, vehicleid, accountid, sqlid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid) ||
       GetPlayerAccountID(playerid) != accountid || !Styling_SyncVisualCache(vehicleid)) return 0;
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(GetOwnableCarData(index, OC_SQL_ID) != sqlid ||
       GetOwnableCarData(index, OC_OWNER_ID) != accountid ||
       GetVehicleVirtualWorld(vehicleid) != 0) return 0;
    ApplyOwnableVehicleColors(vehicleid, index);
    foreach(new target: Player)
    {
        if(!IsVehicleStreamedIn(vehicleid, target) && GetPlayerVehicleID(target) != vehicleid) continue;

        // Replay the complete saved tuning after native preview closes. Additive mode avoids
        // a late REMOVE ALL packet, while still restoring every saved custom component.
        g_tuning_additive_replay[target] = true;
        ApplyVehicleTuning(target, vehicleid);
        g_tuning_additive_replay[target] = false;

        // Geometry can rebuild vehicle materials on mobile, therefore vinyl is ALWAYS last.
        Styling_ApplyWheels(target, vehicleid);
        if(vInfo[index][vynil_name][0] != EOS)
            SetVehicleVinylForPlayer(target, vehicleid, vInfo[index][vynil_name]);
    }
    Styling_QueueSuspension(vehicleid);
    FT55_Queue(vehicleid);
    printf("[STYLING][EXIT_APPLY] player=%d car=%d vehicle=%d vinyl=%s strobe=%d installed=%d",
        playerid, sqlid, vehicleid, vInfo[index][vynil_name], vInfo[index][vStrob], vInfo[index][strab_current]);
    return 1;
}

stock bool:Styling_BuyColor(playerid, vehicleid, selector, const text[])
{
    if(!Styling_CanEdit(playerid, vehicleid)) return false;
    new color;
    if(!ParseTuningColor(text, color)) return false;
    new length = strlen(text), offset;
    if(text[0] == '#') offset = 1;
    else if(text[0] == '0' && (text[1] == 'x' || text[1] == 'X')) offset = 2;
    // lram's GUI constructs AARRGGBB, not RRGGBBAA. Eight digits are already correct.
    if(length - offset == 6) color = (color >>> 8) | 0xFF000000;
    new index = GetVehicleData(vehicleid, V_ACTION_ID), field[32], E_OWNABLE_CAR_STRUCT:slot;
    new Float:percent = 1.1393728;
    switch(selector)
    {
        case 0: { format(field, sizeof field, "body_colors"); slot = OC_body_colors; }
        case 1, 2, 32: { format(field, sizeof field, "wheel_colors"); slot = OC_wheelcolors; }
        case 3: { format(field, sizeof field, "tonir_ft"); slot = OC_tonir_ft; percent = 1.2787456; }
        case 4: { format(field, sizeof field, "tonir_rr"); slot = OC_tonir_rr; percent = 1.2787456; }
        case 10: { format(field, sizeof field, "lights_color"); slot = OC_lights_color; percent = 2.2787456; }
        case 11: { format(field, sizeof field, "underlights_color"); slot = OC_underlights_color; percent = 1.6968641; }
        case 12: { format(field, sizeof field, "underlights_color_rt"); slot = OC_underlights_color_rt; percent = 1.6968641; }
        case 13: { format(field, sizeof field, "underlights_color_lf"); slot = OC_underlights_color_lf; percent = 1.6968641; }
        default: return false;
    }
    new price = GetVehiclePriceByModel(GetVehicleData(vehicleid, V_MODELID));
    if(price <= 0) return false;
    if(GetOwnableCarData(index, slot) == color &&
       (selector < 11 || selector > 13 || GetOwnableCarData(index, OC_EnableNeon)))
    {
        ApplyOwnableVehicleColors(vehicleid, index);
        return true;
    }
    new cost = max(1, floatround(price * percent / 100.0)), values[128];
    format(values, sizeof values, "v.`%s`=%d", field, color);
    if(selector >= 11 && selector <= 13) strcat(values, ",v.EnableNeon=1", sizeof values);
    if(!Styling_SavePurchase(playerid, vehicleid, values, cost)) return false;
    SetOwnableCarData(index, slot, color);
    switch(selector)
    {
        case 0: vInfo[index][body_colors] = color;
        case 1, 2, 32: vInfo[index][wheel_colors] = color;
        case 3: vInfo[index][tonir_ft] = color;
        case 4: vInfo[index][tonir_rr] = color;
        case 10: vInfo[index][lights_color] = color;
        case 11: vInfo[index][underlights_color] = color;
        case 12: vInfo[index][underlights_color_rt] = color;
        case 13: vInfo[index][underlights_color_lf] = color;
    }
    if(selector >= 11 && selector <= 13)
    {
        SetOwnableCarData(index, OC_EnableNeon, 1);
        vInfo[index][vEnableNeon] = 1;
    }
    ApplyOwnableVehicleColors(vehicleid, index);
    return true;
}

stock bool:Styling_IsSafeVinylName(const vinyl[])
{
    new len = strlen(vinyl);
    if(len < 6 || len > 31) return false;
    if(vinyl[0] != 'r' || vinyl[1] != 'e' || vinyl[2] != 'm' || vinyl[3] != 'a' || vinyl[4] != 'p') return false;

    for(new i; i < len; i++)
    {
        new c = vinyl[i];
        if(!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_'))
            return false;
    }
    return true;
}

stock bool:Styling_BuyVinyl(playerid, vehicleid, item, const client_vinyl[], name[], size)
{
    if(!Styling_CanEdit(playerid, vehicleid) || item < 0 || item > MAX_TUNE_ITEM_ID) return false;

    // New client sends the real texture resource in key "v". Use it when sane.
    // The old hand-written ID table is incomplete and caused only part of the vinyl catalogue to work.
    if(Styling_IsSafeVinylName(client_vinyl))
        format(name, size, "%s", client_vinyl);
    else if(!GetVinylNameById(item, name, size))
        return false;

    new values[192], index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(vInfo[index][vinil_current] == item && !strcmp(vInfo[index][vynil_name], name))
    {
        // Re-selecting an already bought vinyl must also repair a lost client visual.
        format(g_ownable_car[index][OC_VINYL], 32, "%s", name);
        vInfo[vehicleid][vinil_current] = item;
        format(vInfo[vehicleid][vynil_name], 32, "%s", name);
        foreach(new target: Player)
            if(IsVehicleStreamedIn(vehicleid, target) || GetPlayerVehicleID(target) == vehicleid)
                SetVehicleVinylForPlayer(target, vehicleid, name);
        return true;
    }
    mysql_format(mysql, values, sizeof values, "v.vinil_current=%d,v.vynil_name='%e'", item, name);
    // Preserve v41's prices, but require BOTH balances before writing either.
    if(!Styling_SavePurchase(playerid, vehicleid, values, 110000, 1000)) return false;

    SetOwnableCarData(index, OC_vinil_current, item);
    format(g_ownable_car[index][OC_VINYL], 32, "%s", name);
    vInfo[index][vinil_current] = item;
    format(vInfo[index][vynil_name], 32, "%s", name);
    // Keep the live vehicle slot coherent too; some old GUI paths still read by vehicleid.
    vInfo[vehicleid][vinil_current] = item;
    format(vInfo[vehicleid][vynil_name], 32, "%s", name);

    foreach(new target: Player)
        if(IsVehicleStreamedIn(vehicleid, target) || GetPlayerVehicleID(target) == vehicleid)
            SetVehicleVinylForPlayer(target, vehicleid, name);

    printf("[STYLING][VINYL_RESOLVE] player=%d vehicle=%d item=%d name=%s client=%s",
        playerid, vehicleid, item, name, client_vinyl);
    return true;
}

stock bool:ParseTuningColor(const value[], &result)
{
    new start, length = strlen(value);
    result = 0;

    if(length > 0 && value[0] == '#')
    {
        start = 1;
    }
    else if(length > 1 && value[0] == '0' && (value[1] == 'x' || value[1] == 'X'))
    {
        start = 2;
    }

    new digits = length - start;
    if(digits != 6 && digits != 8) return false;

    for(new i = start; i < length; i++)
    {
        result *= 16;

        if(value[i] >= '0' && value[i] <= '9') result += value[i] - '0';
        else if(value[i] >= 'A' && value[i] <= 'F') result += value[i] - 'A' + 10;
        else if(value[i] >= 'a' && value[i] <= 'f') result += value[i] - 'a' + 10;
        else return false;
    }

    if(digits == 6)
    {
        result = (result << 8) | 0xFF;
    }
    return true;
}

stock SetPlayerX2(playerid, value, tovalue)
{

}

CMD:x2(playerid, params[])
{
	SetPlayerX2(playerid, 1, 0);
}
