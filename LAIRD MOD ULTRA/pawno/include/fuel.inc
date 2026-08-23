#define MAX_FUEL_STATIONS (128)
#define FUEL_MAX_LITERS   (150.0)
/// Расход по километрам снижен: было ~5 л/км (каждые 10 м ? 0.05 л).
#define FUEL_CONSUME_STEP_METERS (40.0)
#define FUEL_CONSUME_PER_STEP    (0.018)
#define PACKET_CUSTOMRPC  251
#define RPC_CUSTOM_SET_FUEL 0x25
#define FUEL_TYPE_AI92  0
#define FUEL_TYPE_AI95  1
#define FUEL_TYPE_AI98  2
#define FUEL_TYPE_AI100 3
#define FUEL_TYPE_DT    4

forward bool:Fuel_GetVehicleOwnerSlot(vehicleid, &owner, &slot);
forward bool:ScooterRent_IsPlayerVehicle(playerid, vehicleid);
forward SetVehicleSpeedometerInfoFP(playerid, vehicleid, Float:fuel = 52.0, Float:mileage = 1488.0);

stock bool:ResolveVehicleOwnerSlot(vehicleid, &owner, &slot)
{
    owner = -1;
    slot = -1;
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || vehicleid == INVALID_VEHICLE_ID) return false;
    if(!GetVehicleModel(vehicleid)) return false;
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
        {
            if(VehicleInfo[i][v][vSpawned] && VehicleInfo[i][v][vID] == vehicleid)
            {
                owner = i;
                slot = v;
                return true;
            }
        }
    }
    return false;
}

enum E_FUEL_STATION_DATA
{
    bool:FuelStationActive,
    FuelStationSqlId,
    Float:FuelStationX,
    Float:FuelStationY,
    Float:FuelStationZ
};

new g_FuelStations[MAX_FUEL_STATIONS][E_FUEL_STATION_DATA];
new STREAMER_TAG_3D_TEXT_LABEL:g_FuelStationLabel[MAX_FUEL_STATIONS];
new g_FuelStationCanisterPickup[MAX_FUEL_STATIONS];
new g_FuelStationCount = 0;
new Float:g_FuelHudLastValue[MAX_PLAYERS];
new g_FuelHudLastTick[MAX_PLAYERS];
new g_FuelSaveTimer[MAX_PLAYERS][MAX_PLAYER_VEHICLES];
new g_FuelSaveLastTick[MAX_PLAYERS][MAX_PLAYER_VEHICLES];
new bool:g_FuelSaveDirty[MAX_PLAYERS][MAX_PLAYER_VEHICLES];
new Float:g_FuelVehLastPosX[MAX_VEHICLES];
new Float:g_FuelVehLastPosY[MAX_VEHICLES];
new Float:g_FuelVehLastPosZ[MAX_VEHICLES];
new Float:g_FuelVehDistAcc[MAX_VEHICLES];
new bool:g_FuelVehPosInited[MAX_VEHICLES];
new gVehicleFuelType[MAX_PLAYERS][MAX_PLAYER_VEHICLES];
#define FUEL_CANISTER_LITERS 15
#define FUEL_CANISTER_PRICE 800
#define FUEL_CANISTER_DIALOG_CD 6
// Как в Laird (laird-252/ipacket.inc) — ID для клиентского gui 13
#define NOTIFY_OFFER_ENGINE       5  // OFFER_ENGINE — «>>» запуск двигателя
#define NOTIFY_OFFER_UNLOCK_CAR   8  // OFFER_UNLOCK_CAR — открыть двери (b = vehicleid)
#define VEH_UI_HINT_REFRESH_MS 5200
// Прочность личного ТС (dtp_vehiclebreak): минимум 27%, при поломке — не выше 60 км/ч
#define VEH_HP_MAX_VALUE         (1000.0)
#define VEH_HP_MIN_PERCENT       (27.0)
#define VEH_HP_MIN_VALUE         (270.0)
#define VEH_BROKEN_MAX_KMH       (60.0)
#define VEH_CRASH_MIN_DROP_KMH   (4.0)
#define VEH_CRASH_PLAYER_CD_MS   (220)
#define VEH_CRASH_VEH_CD_MS      (260)
#define VEH_BROKEN_NOTIFY_MS     (7000)
#define VEH_KMH_PER_VEL          (170.0)
new g_FuelCanPromptStation[MAX_PLAYERS];
new g_FuelCanDialogCooldownUntil[MAX_PLAYERS];
new g_VehUiHintLastMode[MAX_PLAYERS];
new g_VehUiHintLastVeh[MAX_PLAYERS];
new g_VehUiHintLastMs[MAX_PLAYERS];
new bool:g_VehDoorOfferShown[MAX_PLAYERS];
new Float:g_FuelCrashLastKmh[MAX_PLAYERS];
new g_FuelCrashLastTick[MAX_PLAYERS];
new g_VehCrashVehLastTick[MAX_VEHICLES];
new bool:g_VehBrokenAnnounced[MAX_VEHICLES];
new g_VehBrokenLastNotify[MAX_PLAYERS];

stock Float:VehHp_ClampHealth(Float:hp)
{
    if(hp < VEH_HP_MIN_VALUE) return VEH_HP_MIN_VALUE;
    if(hp > VEH_HP_MAX_VALUE) return VEH_HP_MAX_VALUE;
    return hp;
}

stock bool:VehHp_IsBroken(Float:hp)
{
    return (hp <= VEH_HP_MIN_VALUE + 0.05);
}

stock Float:VehHp_SpeedKmh2D(Float:vx, Float:vy)
{
    return floatsqroot(vx * vx + vy * vy) * VEH_KMH_PER_VEL;
}

stock Float:VehHp_RandFloat(Float:minV, Float:maxV)
{
    new Float:t = float(random(1000)) / 999.0;
    return minV + (maxV - minV) * t;
}

stock Float:VehHp_PctFromDrop(Float:dropKmh)
{
    if(dropKmh < 25.0)
    {
        new Float:t = (dropKmh - VEH_CRASH_MIN_DROP_KMH) / (25.0 - VEH_CRASH_MIN_DROP_KMH);
        if(t < 0.0) t = 0.0;
        if(t > 1.0) t = 1.0;
        return VehHp_RandFloat(1.0, 1.0 + t * 3.0);
    }
    if(dropKmh < 60.0)
    {
        new Float:t = (dropKmh - 25.0) / 35.0;
        if(t < 0.0) t = 0.0;
        if(t > 1.0) t = 1.0;
        return VehHp_RandFloat(3.5 + t * 2.0, 8.0);
    }
    new Float:t2 = (dropKmh - 60.0) / 60.0;
    if(t2 < 0.0) t2 = 0.0;
    if(t2 > 1.0) t2 = 1.0;
    return VehHp_RandFloat(8.0, 8.0 + t2 * 2.0);
}

stock VehHp_LimitSpeed(vehicleid, Float:maxKmh)
{
    new Float:vx, Float:vy, Float:vz;
    GetVehicleVelocity(vehicleid, vx, vy, vz);
    new Float:s = floatsqroot(vx * vx + vy * vy);
    if(s <= 0.0001) return 0;
    new Float:curKmh = s * VEH_KMH_PER_VEL;
    if(curKmh <= maxKmh) return 0;
    new Float:targetS = maxKmh / VEH_KMH_PER_VEL;
    new Float:scale = targetS / s;
    SetVehicleVelocity(vehicleid, vx * scale, vy * scale, vz);
    return 1;
}

stock VehHp_ApplyPercentDamage(playerid, vehicleid, owner, slot, Float:pct)
{
    if(pct > 10.0) pct = 10.0;
    new Float:drop = VEH_HP_MAX_VALUE * (pct / 100.0);
    if(drop < 1.5) drop = 1.5;

    new Float:nh = VehicleInfo[owner][slot][vHealth] - drop;
    nh = VehHp_ClampHealth(nh);

    VehicleInfo[owner][slot][vHealth] = nh;
    SetVehicleHealth(vehicleid, nh);
    Fuel_SaveVehicle(owner, slot);

    if(VehHp_IsBroken(nh))
    {
        VehHp_LimitSpeed(vehicleid, VEH_BROKEN_MAX_KMH);
        if(!g_VehBrokenAnnounced[vehicleid])
        {
            g_VehBrokenAnnounced[vehicleid] = true;
            ShowNotification(playerid, 4, 6, 0, 0,
                "Ваш транспорт сломался. Вызовите механика (/call 090).", "");
            SendClientMessage(playerid, 0xF5D400FF,
                "Ваш транспорт сломался. Вызовите механика (/call 090).");
        }
    }
    else if(nh > VEH_HP_MIN_VALUE + 15.0)
    {
        g_VehBrokenAnnounced[vehicleid] = false;
    }
    return 1;
}

stock VehHp_OnFullyRepaired(vehicleid)
{
    if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
        g_VehBrokenAnnounced[vehicleid] = false;
    return 1;
}

stock Fuel_CrashTrackReset(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    g_FuelCrashLastKmh[playerid] = 0.0;
    g_FuelCrashLastTick[playerid] = 0;
    return 1;
}

stock Perf_IncFuelHudSend()
{
    return 1;
}

stock Fuel_ClearCanisterStationLock(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    g_FuelCanPromptStation[playerid] = -1;
    return 1;
}

stock Fuel_InitCanisterPrompt(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    g_FuelCanPromptStation[playerid] = -1;
    g_FuelCanDialogCooldownUntil[playerid] = 0;
    Fuel_CrashTrackReset(playerid);
    g_VehBrokenLastNotify[playerid] = 0;
    VehicleHint_Init(playerid);
    return 1;
}

/// ДТП по падению скорости (dtp_vehiclebreak): урон % от 1000 HP, минимум 27%.
stock Fuel_TickCrashDamage(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !GetVehicleModel(vehicleid)) return 0;

    new owner, slot;
    if(!ResolveVehicleOwnerSlot(vehicleid, owner, slot) || owner != playerid) return 0;

    new Float:vx, Float:vy, Float:vz;
    GetVehicleVelocity(vehicleid, vx, vy, vz);
    new Float:kmh = VehHp_SpeedKmh2D(vx, vy);

    new now = GetTickCount();
    new Float:last = g_FuelCrashLastKmh[playerid];
    g_FuelCrashLastKmh[playerid] = kmh;

    if(now - g_FuelCrashLastTick[playerid] < VEH_CRASH_PLAYER_CD_MS) return 0;
    if(now - g_VehCrashVehLastTick[vehicleid] < VEH_CRASH_VEH_CD_MS) return 0;

    new Float:dropKmh = last - kmh;
    if(dropKmh < VEH_CRASH_MIN_DROP_KMH) return 0;

    g_FuelCrashLastTick[playerid] = now;
    g_VehCrashVehLastTick[vehicleid] = now;

    new Float:pct = VehHp_PctFromDrop(dropKmh);
    return VehHp_ApplyPercentDamage(playerid, vehicleid, owner, slot, pct);
}

/// При HP <= 27% — ограничение 60 км/ч и напоминание (двигатель не глушим).
stock Fuel_TickBrokenVehicle(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !GetVehicleModel(vehicleid)) return 0;

    new owner, slot;
    if(!ResolveVehicleOwnerSlot(vehicleid, owner, slot) || owner != playerid) return 0;

    new Float:hp = VehicleInfo[owner][slot][vHealth];
    if(!VehHp_IsBroken(hp))
    {
        if(hp > VEH_HP_MIN_VALUE + 20.0)
            g_VehBrokenAnnounced[vehicleid] = false;
        return 0;
    }

    VehHp_LimitSpeed(vehicleid, VEH_BROKEN_MAX_KMH);

    new now = GetTickCount();
    if(!g_VehBrokenAnnounced[vehicleid])
    {
        g_VehBrokenAnnounced[vehicleid] = true;
        ShowNotification(playerid, 4, 6, 0, 0,
            "Ваш транспорт сломался. Вызовите механика (/call 090).", "");
        SendClientMessage(playerid, 0xF5D400FF,
            "Ваш транспорт сломался. Вызовите механика (/call 090).");
        g_VehBrokenLastNotify[playerid] = now;
        return 1;
    }

    if(now - g_VehBrokenLastNotify[playerid] >= VEH_BROKEN_NOTIFY_MS)
    {
        g_VehBrokenLastNotify[playerid] = now;
        ShowNotification(playerid, 4, 4, 0, 0, "Двигатель неисправен!", "");
    }
    return 1;
}

stock VehicleHint_Init(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    g_VehUiHintLastMode[playerid] = 0;
    g_VehUiHintLastVeh[playerid] = 0;
    g_VehUiHintLastMs[playerid] = 0;
    g_VehDoorOfferShown[playerid] = false;
    return 1;
}

stock VehicleHint_UnlockOfferVehicle(playerid, vehicleid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !GetVehicleModel(vehicleid)) return 0;
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 0;

    new Float:vx, Float:vy, Float:vz;
    GetVehiclePos(vehicleid, vx, vy, vz);
    if(!IsPlayerInRangeOfPoint(playerid, 5.5, vx, vy, vz)) return 0;

    new bool:can = false;
    if(Player[playerid][pAdminVeh] == vehicleid) can = true;
    if(!can)
    {
        new owner, slot;
        if(ResolveVehicleOwnerSlot(vehicleid, owner, slot) && owner == playerid) can = true;
    }
    if(!can) return 0;

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(!doors) return 0;

    SetVehicleParam(vehicleid, V_LOCK, 0);
    PlayAudioStreamURL(playerid, "vehicle_sound_alarm.mp3");
    return 1;
}

stock VehicleHint_UnlockNearestDoor(playerid)
{
    new closest = GetClosestVehicleToPlayer(playerid, 4.5);
    if(closest <= 0) return 0;
    return VehicleHint_UnlockOfferVehicle(playerid, closest);
}

stock VehicleHint_Tick(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new now = GetTickCount();
    new bool:want_clear = true;

    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vid = GetPlayerVehicleID(playerid);
        if(vid != INVALID_VEHICLE_ID && GetVehicleModel(vid) > 0)
        {
            new m = GetVehicleModel(vid);
            if(m != 481 && m != 509 && m != 510)
            {
                if(!GetVehicleParam(vid, V_ENGINE))
                {
                    want_clear = false;
                    if(g_VehUiHintLastMode[playerid] != 2 || g_VehUiHintLastVeh[playerid] != vid || (now - g_VehUiHintLastMs[playerid] >= VEH_UI_HINT_REFRESH_MS))
                    {
                        ShowNotification(playerid, 4, 6, NOTIFY_OFFER_ENGINE, 0, "Двигатель автомобиля выключен.", ">>");
                        g_VehUiHintLastMode[playerid] = 2;
                        g_VehUiHintLastVeh[playerid] = vid;
                        g_VehUiHintLastMs[playerid] = now;
                    }
                }
            }
        }
    }
    else if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !IsPlayerInAnyVehicle(playerid))
    {
        new closest = GetClosestVehicleToPlayer(playerid, 3.8);
        if(closest > 0)
        {
            new bool:can = false;
            if(Player[playerid][pAdminVeh] == closest) can = true;
            if(!can)
            {
                new owner, slot;
                if(ResolveVehicleOwnerSlot(closest, owner, slot) && owner == playerid) can = true;
            }
            if(can)
            {
                new e, l, al, doors, bn, bt, obj;
                GetVehicleParamsEx(closest, e, l, al, doors, bn, bt, obj);
                if(doors)
                {
                    want_clear = false;
                    if(!g_VehDoorOfferShown[playerid])
                    {
                        ShowNotification(playerid, 4, 6, NOTIFY_OFFER_UNLOCK_CAR, closest, "Двери автомобиля закрыты.", ">>");
                        g_VehDoorOfferShown[playerid] = true;
                        g_VehUiHintLastMode[playerid] = 1;
                        g_VehUiHintLastVeh[playerid] = closest;
                        g_VehUiHintLastMs[playerid] = now;
                    }
                }
                else g_VehDoorOfferShown[playerid] = false;
            }
        }
    }

    if(want_clear)
    {
        g_VehUiHintLastMode[playerid] = 0;
        g_VehUiHintLastVeh[playerid] = 0;
        g_VehDoorOfferShown[playerid] = false;
    }
    return 1;
}

stock Fuel_ShowCanisterBuyDialog(playerid, station_idx)
{
    new now = gettime();
    if(now < g_FuelCanDialogCooldownUntil[playerid])
        return 0;

    g_FuelCanDialogCooldownUntil[playerid] = now + FUEL_CANISTER_DIALOG_CD;
    g_FuelCanPromptStation[playerid] = station_idx;
    new msg[192];
    format(msg, sizeof(msg),
        "%sКанистра с топливом: %s%d л.\n\n%sСтоимость: %s%d руб.\n\n%sКупить?",
        CAR_CLR_WHITE, CAR_CLR_GOLD, FUEL_CANISTER_LITERS,
        CAR_CLR_WHITE, CAR_CLR_GOLD, FUEL_CANISTER_PRICE,
        CAR_CLR_WHITE);
    ShowPlayerDialog(playerid, DIALOG_FUEL_CAN_BUY, DIALOG_STYLE_MSGBOX,
        CAR_DLG_PREFIX "Канистра", msg, "Купить", "Отмена");
    SetPVarInt(playerid, "fuel_can_station_idx", station_idx);
    return 1;
}

stock Fuel_TickCanisterPrompt(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    {
        Fuel_ClearCanisterStationLock(playerid);
        return 1;
    }
    new idx = Fuel_GetNearestStation(playerid, 4.0);
    if(idx == -1)
    {
        Fuel_ClearCanisterStationLock(playerid);
        return 1;
    }
    new now_cd = gettime();
    if(now_cd < g_FuelCanDialogCooldownUntil[playerid])
        return 1;
    if(g_FuelCanPromptStation[playerid] == idx) return 1;

    Fuel_ShowCanisterBuyDialog(playerid, idx);
    return 1;
}

stock bool:Fuel_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused listitem, inputtext
    if(dialogid != DIALOG_FUEL_CAN_BUY) return false;
    new idx = GetPVarInt(playerid, "fuel_can_station_idx");
    DeletePVar(playerid, "fuel_can_station_idx");
    g_FuelCanDialogCooldownUntil[playerid] = gettime() + FUEL_CANISTER_DIALOG_CD;
    if(!response) return true;
    if(idx < 0 || idx >= MAX_FUEL_STATIONS || !g_FuelStations[idx][FuelStationActive])
        return true;
    if(Fuel_GetNearestStation(playerid, 6.0) != idx)
    {
        ShowNotification(playerid, 0, 5, 0, 1, "Вы отошли от заправки.", "");
        return true;
    }
    if(GetPlayerMoneyEx(playerid) < FUEL_CANISTER_PRICE)
    {
        ShowNotification(playerid, 0, 5, 0, 1, "Недостаточно денег.", "");
        return true;
    }
    if(!GivePlayerFuelCanister(playerid, FUEL_CANISTER_LITERS))
    {
        ShowNotification(playerid, 0, 5, 0, 1, "Нет места в инвентаре.", "");
        return true;
    }
    GivePlayerMoneyEx(playerid, -FUEL_CANISTER_PRICE);
    ShowNotification(playerid, 1, 5, 0, 1, "Канистра куплена. Подойдите к авто и используйте предмет в инвентаре.", "");
    return true;
}

stock bool:Fuel_IsCanisterDynamicPickup(pickupid)
{
    for(new i = 0; i < MAX_FUEL_STATIONS; i++)
    {
        if(!g_FuelStations[i][FuelStationActive]) continue;
        if(g_FuelStationCanisterPickup[i] == pickupid) return true;
    }
    return false;
}

stock Fuel_OnCanisterPickup(playerid, pickupid)
{
    if(!Fuel_IsCanisterDynamicPickup(pickupid)) return 0;
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        return 1;
    new idx = Fuel_GetNearestStation(playerid, 6.0);
    if(idx == -1) return 1;
    Fuel_ShowCanisterBuyDialog(playerid, idx);
    return 1;
}

stock Fuel_EnforceDriverNoFuel(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0) return 1;
    new model = GetVehicleModel(vehicleid);
    if(model == 481 || model == 509 || model == 510) return 1;

    new owner, slot;
    if(!Fuel_GetVehicleOwnerSlot(vehicleid, owner, slot)) return 1;
    if(VehicleInfo[owner][slot][vFuel] > 0.05) return 1;

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(engine != VEHICLE_PARAMS_ON) return 1;

    SetVehicleParam(vehicleid, V_ENGINE, 0);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);

    new now = gettime();
    if(GetPVarInt(playerid, "fuel_empty_warn") <= now)
    {
        SetPVarInt(playerid, "fuel_empty_warn", now + 5);
        ShowNotification(playerid, 0, 5, 0, 1, "Топливо закончилось. Двигатель заглушен.", "");
    }
    Fuel_UpdateHudForOccupants(vehicleid, 0.0);
    return 1;
}

stock Float:Fuel_Clamp(Float:value)
{
    if(_:value != _:value) return 0.0; // NaN safety
    if(value < 0.0) return 0.0;
    if(value > FUEL_MAX_LITERS) return FUEL_MAX_LITERS;
    return value;
}

stock Float:Mileage_Clamp(Float:value)
{
    if(_:value != _:value) return 0.0;
    if(value < 0.0) return 0.0;
    return value;
}

stock Fuel_GetAllowedTypeByModel(modelid)
{
    // Diesel group.
    switch(modelid)
    {
        case 403, 406, 408, 414, 431, 437, 443, 455, 456, 486, 498, 499, 514, 515, 524, 578, 588, 609:
            return FUEL_TYPE_DT;
    }

    // Low-power / classic cars.
    switch(modelid)
    {
        case 400, 401, 404, 405, 410, 418, 419, 420, 421, 426, 436, 438, 440, 445, 458, 466, 467, 474, 478, 479, 491, 492, 496, 500, 516, 517, 518, 526, 527, 529, 533, 540, 542, 543, 546, 547, 549, 550, 551, 554, 561, 562, 566, 575, 576, 579, 580, 585, 589, 600, 603, 604, 605:
            return FUEL_TYPE_AI92;
    }

    // Fast / sport cars.
    switch(modelid)
    {
        case 402, 411, 415, 429, 451, 477, 494, 495, 502, 503, 506, 541, 555, 559, 560, 565, 587, 602:
            return FUEL_TYPE_AI98;
    }

    // Premium / hyper.
    switch(modelid)
    {
        case 409, 412, 480, 507, 558:
            return FUEL_TYPE_AI100;
    }

    return FUEL_TYPE_AI95;
}

stock Fuel_GetTypeName(fuel_type, dest[], size = 16)
{
    switch(fuel_type)
    {
        case FUEL_TYPE_AI92: format(dest, size, "АИ-92");
        case FUEL_TYPE_AI95: format(dest, size, "АИ-95");
        case FUEL_TYPE_AI98: format(dest, size, "АИ-98");
        case FUEL_TYPE_AI100: format(dest, size, "АИ-100");
        case FUEL_TYPE_DT: format(dest, size, "ДТ");
        default: format(dest, size, "АИ-95");
    }
    return 1;
}

stock Fuel_DestroyStationVisual(idx)
{
    if(idx < 0 || idx >= MAX_FUEL_STATIONS) return 0;
    if(IsValidDynamic3DTextLabel(g_FuelStationLabel[idx]))
    {
        DestroyDynamic3DTextLabel(g_FuelStationLabel[idx]);
    }
    g_FuelStationLabel[idx] = STREAMER_TAG_3D_TEXT_LABEL:0;
    if(g_FuelStationCanisterPickup[idx] != INVALID_STREAMER_ID)
    {
        DestroyDynamicPickup(g_FuelStationCanisterPickup[idx]);
        g_FuelStationCanisterPickup[idx] = INVALID_STREAMER_ID;
    }
    return 1;
}

stock Fuel_CreateStationVisual(idx)
{
    if(idx < 0 || idx >= MAX_FUEL_STATIONS) return 0;
    Fuel_DestroyStationVisual(idx);
    if(!g_FuelStations[idx][FuelStationActive]) return 1;

    new info[256];
    format(info, sizeof(info),
        "{FFFFFF}Стоимость топлива:\n{55FF55}АИ-92: {FFFFFF}65\n{55FF55}АИ-95: {FFFFFF}69\n{55FF55}АИ-98: {FFFFFF}77\n{55FF55}АИ-100: {FFFFFF}98\n{55FF55}ДТ: {FFFFFF}86\n\n{66CCFFFF}Для заправки введите /i или нажмите гудок");
    g_FuelStationLabel[idx] = CreateDynamic3DTextLabel(
        info, 0xFFFFFFFF,
        g_FuelStations[idx][FuelStationX], g_FuelStations[idx][FuelStationY], g_FuelStations[idx][FuelStationZ] + 1.5,
        28.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1
    );
    g_FuelStationCanisterPickup[idx] = CreateDynamicPickup(
        1650,
        23,
        g_FuelStations[idx][FuelStationX],
        g_FuelStations[idx][FuelStationY],
        g_FuelStations[idx][FuelStationZ] + 0.05
    );
    return 1;
}

stock Fuel_RebuildStationVisuals()
{
    for(new i = 0; i < MAX_FUEL_STATIONS; i++)
    {
        Fuel_CreateStationVisual(i);
    }
    return 1;
}

stock Fuel_ResetStations()
{
    g_FuelStationCount = 0;
    for(new i = 0; i < MAX_FUEL_STATIONS; i++)
    {
        Fuel_DestroyStationVisual(i);
        g_FuelStations[i][FuelStationActive] = false;
        g_FuelStations[i][FuelStationSqlId] = 0;
        g_FuelStations[i][FuelStationX] = 0.0;
        g_FuelStations[i][FuelStationY] = 0.0;
        g_FuelStations[i][FuelStationZ] = 0.0;
    }
    return 1;
}

stock Fuel_AddStationToMemory(sqlid, Float:x, Float:y, Float:z)
{
    for(new i = 0; i < MAX_FUEL_STATIONS; i++)
    {
        if(!g_FuelStations[i][FuelStationActive])
        {
            g_FuelStations[i][FuelStationActive] = true;
            g_FuelStations[i][FuelStationSqlId] = sqlid;
            g_FuelStations[i][FuelStationX] = x;
            g_FuelStations[i][FuelStationY] = y;
            g_FuelStations[i][FuelStationZ] = z;
            g_FuelStationCount++;
            Fuel_CreateStationVisual(i);
            return i;
        }
    }
    return -1;
}

stock Fuel_LoadDefaultStations()
{
    Fuel_AddStationToMemory(0, 2877.87, 541.919, 26.3542);
    Fuel_AddStationToMemory(0, 2674.46, 2616.66, 16.9724);
    Fuel_AddStationToMemory(0, 2245.21, -1784.98, 21.7109);
    Fuel_AddStationToMemory(0, 2368.07, -766.732, 14.0431);
    Fuel_AddStationToMemory(0, -890.503, 1486.84, 27.4242);
    Fuel_AddStationToMemory(0, -537.518, 1315.61, 20.7424);
    Fuel_AddStationToMemory(0, 1600.41, 2898.01, 12.0431);
    Fuel_AddStationToMemory(0, 2276.39, -739.561, 13.4187);
    Fuel_AddStationToMemory(0, 2776.67, 751.794, 31.0258);
    Fuel_AddStationToMemory(0, -2539.23, -695.798, 29.6205);
    Fuel_AddStationToMemory(0, 1016.17, -779.029, 41.165);
    Fuel_AddStationToMemory(0, 2641.88, 2587.0, 16.432);
    Fuel_AddStationToMemory(0, -2069.7, 2464.53, 57.665);
    return 1;
}

forward Fuel_OnStationsLoaded();
public Fuel_OnStationsLoaded()
{
    Fuel_ResetStations();

    new rows, fields;
    cache_get_data(rows, fields, db_handle);

    for(new i = 0; i < rows && i < MAX_FUEL_STATIONS; i++)
    {
        new sqlid = cache_get_field_content_int(i, "id", db_handle);
        new Float:x = cache_get_field_content_float(i, "x", db_handle);
        new Float:y = cache_get_field_content_float(i, "y", db_handle);
        new Float:z = cache_get_field_content_float(i, "z", db_handle);
        Fuel_AddStationToMemory(sqlid, x, y, z);
    }

    if(g_FuelStationCount == 0)
    {
        // Fallback, чтобы /fuelfill работал даже без миграции SQL.
        Fuel_LoadDefaultStations();
    }
    Fuel_RebuildStationVisuals();
    return 1;
}

stock Fuel_LoadStations()
{
    mysql_tquery(db_handle, "SELECT `id`,`x`,`y`,`z` FROM `fuel_stations`", "Fuel_OnStationsLoaded", "");
    return 1;
}

forward Fuel_OnAdminFuelStationInserted(playerid, mem_idx);
public Fuel_OnAdminFuelStationInserted(playerid, mem_idx)
{
    new db_id = cache_insert_id();
    if(mem_idx >= 0 && mem_idx < MAX_FUEL_STATIONS && g_FuelStations[mem_idx][FuelStationActive])
        g_FuelStations[mem_idx][FuelStationSqlId] = db_id;

    if(IsPlayerConnected(playerid))
    {
        new msg[112];
        if(db_id > 0)
            format(msg, sizeof msg, "Заправка создана. SQL ID: %d (слот %d)", db_id, mem_idx);
        else
            format(msg, sizeof msg, "Ошибка БД при создании заправки (слот %d).", mem_idx);
        ShowNotification(playerid, db_id > 0 ? 1 : 0, 5, 0, 1, msg, "");
    }
    return 1;
}

stock Fuel_SaveVehicle(ownerid, slot)
{
    if(ownerid < 0 || ownerid >= MAX_PLAYERS) return 0;
    if(slot < 0 || slot >= MAX_PLAYER_VEHICLES) return 0;
    if(VehicleInfo[ownerid][slot][vDBID] == 0) return 0;

    VehicleInfo[ownerid][slot][vFuel] = Fuel_Clamp(VehicleInfo[ownerid][slot][vFuel]);
    VehicleInfo[ownerid][slot][vHealth] = VehHp_ClampHealth(VehicleInfo[ownerid][slot][vHealth]);

    new now = GetTickCount();
    if((now - g_FuelSaveLastTick[ownerid][slot]) < 2500)
    {
        g_FuelSaveDirty[ownerid][slot] = true;
        if(g_FuelSaveTimer[ownerid][slot] == 0)
        {
            g_FuelSaveTimer[ownerid][slot] = SetTimerEx("Fuel_FlushSave", 2800, false, "ii", ownerid, slot);
        }
        return 1;
    }

    new Float:miles = Mileage_Clamp(gVehicleMileage[ownerid][slot]);

    new query[256];
    mysql_format(db_handle, query, sizeof(query),
        "UPDATE `ownable_cars` SET `fuel`=%f, `health`=%f, `mileage`=%f WHERE `id`=%d LIMIT 1",
        VehicleInfo[ownerid][slot][vFuel],
        VehicleInfo[ownerid][slot][vHealth],
        miles,
        VehicleInfo[ownerid][slot][vDBID]
    );
    mysql_tquery(db_handle, query, "", "");
    g_FuelSaveLastTick[ownerid][slot] = now;
    g_FuelSaveDirty[ownerid][slot] = false;
    return 1;
}

forward Fuel_FlushSave(ownerid, slot);
public Fuel_FlushSave(ownerid, slot)
{
    if(ownerid < 0 || ownerid >= MAX_PLAYERS) return 0;
    if(slot < 0 || slot >= MAX_PLAYER_VEHICLES) return 0;
    g_FuelSaveTimer[ownerid][slot] = 0;
    if(!g_FuelSaveDirty[ownerid][slot]) return 1;
    return Fuel_SaveVehicle(ownerid, slot);
}

stock Fuel_FlushVehicleImmediate(ownerid, slot)
{
    if(ownerid < 0 || ownerid >= MAX_PLAYERS) return 0;
    if(slot < 0 || slot >= MAX_PLAYER_VEHICLES) return 0;
    if(VehicleInfo[ownerid][slot][vDBID] == 0) return 0;

    if(g_FuelSaveTimer[ownerid][slot] != 0)
    {
        KillTimer(g_FuelSaveTimer[ownerid][slot]);
        g_FuelSaveTimer[ownerid][slot] = 0;
    }
    g_FuelSaveDirty[ownerid][slot] = false;

    VehicleInfo[ownerid][slot][vFuel] = Fuel_Clamp(VehicleInfo[ownerid][slot][vFuel]);
    VehicleInfo[ownerid][slot][vHealth] = VehHp_ClampHealth(VehicleInfo[ownerid][slot][vHealth]);
    new Float:miles = Mileage_Clamp(gVehicleMileage[ownerid][slot]);

    new query[256];
    mysql_format(db_handle, query, sizeof(query),
        "UPDATE `ownable_cars` SET `fuel`=%f, `health`=%f, `mileage`=%f WHERE `id`=%d LIMIT 1",
        VehicleInfo[ownerid][slot][vFuel],
        VehicleInfo[ownerid][slot][vHealth],
        miles,
        VehicleInfo[ownerid][slot][vDBID]
    );
    mysql_tquery(db_handle, query, "", "");
    g_FuelSaveLastTick[ownerid][slot] = GetTickCount();
    return 1;
}

stock Fuel_FlushAllPendingForPlayer(ownerid)
{
    if(ownerid < 0 || ownerid >= MAX_PLAYERS) return 0;
    for(new s = 0; s < MAX_PLAYER_VEHICLES; s++)
    {
        if(VehicleInfo[ownerid][s][vDBID] == 0) continue;
        if(g_FuelSaveTimer[ownerid][s] != 0 || g_FuelSaveDirty[ownerid][s])
            Fuel_FlushVehicleImmediate(ownerid, s);
    }
    return 1;
}

stock Fuel_SendHud(playerid, Float:fuel)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(!IsPlayerConnected(playerid)) return 0;

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_SET_FUEL);
    BS_WriteValue(bitstream, PR_FLOAT, fuel);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    Perf_IncFuelHudSend();
    BS_Delete(bitstream);
    return 1;
}

stock Fuel_UpdateHudForPlayer(playerid)
{
    new pstate = GetPlayerState(playerid);
    if(pstate != PLAYER_STATE_DRIVER && pstate != PLAYER_STATE_PASSENGER)
        return 1;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 1;

    new owner, slot;
    if(!Fuel_GetVehicleOwnerSlot(vehicleid, owner, slot))
    {
        if(pstate == PLAYER_STATE_DRIVER)
        {
            if(Player[playerid][pAdminVeh] == vehicleid)
            {
                Fuel_SendHud(playerid, 40.0);
                SetVehicleSpeedometerInfoFP(playerid, vehicleid, 40.0, 0.0);
                return 1;
            }
            if(ScooterRent_IsPlayerVehicle(playerid, vehicleid))
            {
                Fuel_SendHud(playerid, 40.0);
                SetVehicleSpeedometerInfoFP(playerid, vehicleid, 40.0, 0.0);
                return 1;
            }
        }
        return 1;
    }

    new Float:fuel = VehicleInfo[owner][slot][vFuel];
    g_FuelHudLastValue[playerid] = fuel;
    g_FuelHudLastTick[playerid] = GetTickCount();
    SetVehicleSpeedometerInfoFP(playerid, vehicleid, fuel, gVehicleMileage[owner][slot]);
    return Fuel_SendHud(playerid, fuel);
}

stock Fuel_UpdateHudForOccupants(vehicleid, Float:fuel)
{
    new owner, slot;
    new bool:has_owner_slot = Fuel_GetVehicleOwnerSlot(vehicleid, owner, slot);
    new Float:mileage = 0.0;
    if(has_owner_slot) mileage = gVehicleMileage[owner][slot];

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(IsPlayerInVehicle(i, vehicleid))
        {
            Fuel_SendHud(i, fuel);
            if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
            {
                SetVehicleSpeedometerInfoFP(i, vehicleid, fuel, mileage);
            }
        }
    }
    return 1;
}

/// Заглушить двигатель и сбросить накопление пробега для расхода (тюнинг/интерьеры).
stock Fuel_ForceEngineOff(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || vehicleid == INVALID_VEHICLE_ID) return 0;
    if(!GetVehicleModel(vehicleid)) return 0;
    SetVehicleParam(vehicleid, V_ENGINE, 0);
    g_FuelVehPosInited[vehicleid] = false;
    g_FuelVehDistAcc[vehicleid] = 0.0;
    return 1;
}

stock Fuel_HandleConsumptionForPlayer(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 1;

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(engine != VEHICLE_PARAMS_ON)
    {
        g_FuelVehPosInited[vehicleid] = false;
        g_FuelVehDistAcc[vehicleid] = 0.0;
        return 1;
    }

    new owner, slot;
    if(!Fuel_GetVehicleOwnerSlot(vehicleid, owner, slot))
        return 1;

    new Float:x, Float:y, Float:z;
    GetVehiclePos(vehicleid, x, y, z);

    if(!g_FuelVehPosInited[vehicleid])
    {
        g_FuelVehLastPosX[vehicleid] = x;
        g_FuelVehLastPosY[vehicleid] = y;
        g_FuelVehLastPosZ[vehicleid] = z;
        g_FuelVehDistAcc[vehicleid] = 0.0;
        g_FuelVehPosInited[vehicleid] = true;
        return 1;
    }

    new Float:dx = x - g_FuelVehLastPosX[vehicleid];
    new Float:dy = y - g_FuelVehLastPosY[vehicleid];
    new Float:dz = z - g_FuelVehLastPosZ[vehicleid];
    new Float:dist = floatsqroot((dx * dx) + (dy * dy) + (dz * dz));

    g_FuelVehLastPosX[vehicleid] = x;
    g_FuelVehLastPosY[vehicleid] = y;
    g_FuelVehLastPosZ[vehicleid] = z;

    if(dist < 0.01) return 1;

    g_FuelVehDistAcc[vehicleid] += dist;
    if(g_FuelVehDistAcc[vehicleid] < FUEL_CONSUME_STEP_METERS) return 1;

    new consume_steps = floatround(g_FuelVehDistAcc[vehicleid] / FUEL_CONSUME_STEP_METERS, floatround_floor);
    if(consume_steps < 1) return 1;

    g_FuelVehDistAcc[vehicleid] -= float(consume_steps) * FUEL_CONSUME_STEP_METERS;

    new Float:new_fuel = Fuel_Clamp(VehicleInfo[owner][slot][vFuel] - (float(consume_steps) * FUEL_CONSUME_PER_STEP));
    if(floatabs(new_fuel - VehicleInfo[owner][slot][vFuel]) < 0.001) return 1;

    VehicleInfo[owner][slot][vFuel] = new_fuel;
    new Float:mile_add = (dist / 1000.0);
    gVehicleMileage[owner][slot] += mile_add;
    Fuel_SaveVehicle(owner, slot);
    Fuel_UpdateHudForOccupants(vehicleid, new_fuel);

    if(new_fuel <= 0.0)
    {
        SetVehicleParam(vehicleid, V_ENGINE, 0);
        SetVehicleSpeedometerInfoFP(playerid, vehicleid, 0.0, gVehicleMileage[owner][slot]);
        ShowNotification(playerid, 0, 5, 0, 1, "Топливо закончилось. Двигатель заглушен.", "");
    }
    return 1;
}

stock Fuel_SyncDriverVehicleHealth(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || GetVehicleModel(vehicleid) == 0) return 0;

    new owner, slot;
    if(!ResolveVehicleOwnerSlot(vehicleid, owner, slot) || owner != playerid) return 0;

    new Float:vh;
    GetVehicleHealth(vehicleid, vh);
    vh = VehHp_ClampHealth(vh);

    if(floatabs(vh - VehicleInfo[owner][slot][vHealth]) > 1.5)
    {
        VehicleInfo[owner][slot][vHealth] = vh;
        Fuel_SaveVehicle(owner, slot);
    }
    return 1;
}

forward Fuel_HudTick();
public Fuel_HudTick()
{
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        Fuel_HandleConsumptionForPlayer(i);
        Fuel_EnforceDriverNoFuel(i);
        Fuel_SyncDriverVehicleHealth(i);
        Fuel_TickCrashDamage(i);
        Fuel_TickBrokenVehicle(i);
        Fuel_UpdateHudForPlayer(i);
        Fuel_TickCanisterPrompt(i);
        VehicleHint_Tick(i);
        CarSystem_AutoLockTick(i);
    }
    return 1;
}

// Авто-блокировка дверей при скорости > 40 км/ч. Включается через DIALOG_CAR_SETTINGS.
// ВНИМАНИЕ: проверка ТОЛЬКО для владельца. У пассажиров и в чужих машинах не срабатывает.
stock CarSystem_AutoLockTick(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 0;

    new slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;
    if(!VehicleInfo[playerid][slot][vAutoLock]) return 0;

    new Float:vx, Float:vy, Float:vz;
    GetVehicleVelocity(vehicleid, vx, vy, vz);
    // SA-MP velocity * 170 ~= км/ч (как в performance.inc GetVehSpeed)
    new Float:speed_kmh = floatsqroot(vx*vx + vy*vy + vz*vz) * 170.0;

    if(speed_kmh > 40.0 && !GetVehicleParam(vehicleid, V_LOCK))
    {
        SetVehicleParam(vehicleid, V_LOCK, 1);
        // Один краткий feedback — иначе игрок не понимает, что система отработала.
        // Спам не страшен: после первого раза V_LOCK уже = 1 и условие выше не сработает,
        // пока он не разблокирует двери (например, /lk).
        ShowNotification(playerid, 1, 3, 0, 1, "Авто-блокировка: двери заблокированы.", "");
    }
    return 1;
}

stock Fuel_GetNearestStation(playerid, Float:range = 12.0)
{
    new nearest = -1;
    new Float:best = range;

    for(new i = 0; i < MAX_FUEL_STATIONS; i++)
    {
        if(!g_FuelStations[i][FuelStationActive]) continue;
        new Float:dist = GetPlayerDistanceFromPoint(playerid, g_FuelStations[i][FuelStationX], g_FuelStations[i][FuelStationY], g_FuelStations[i][FuelStationZ]);
        if(dist <= best)
        {
            best = dist;
            nearest = i;
        }
    }
    return nearest;
}

stock bool:Fuel_GetVehicleOwnerSlot(vehicleid, &owner, &slot)
{
    return ResolveVehicleOwnerSlot(vehicleid, owner, slot);
}

stock Fuel_ShowGui(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return ShowNotification(playerid, 0, 5, 0, 1, "Вы должны быть водителем транспорта", "");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return ShowNotification(playerid, 0, 5, 0, 1, "Вы должны находиться в транспорте", "");

    new owner, slot;
    if(!Fuel_GetVehicleOwnerSlot(vehicleid, owner, slot))
        return ShowNotification(playerid, 0, 5, 0, 1, "Заправка доступна только для личного транспорта", "");

    new Float:current_fuel = Fuel_Clamp(VehicleInfo[owner][slot][vFuel]);
    new free_liters = floatround(FUEL_MAX_LITERS - current_fuel, floatround_floor);
    if(free_liters <= 0)
        return ShowNotification(playerid, 0, 5, 0, 1, "Бак уже заполнен", "");

    new stationid = Fuel_GetNearestStation(playerid, 18.0);
    if(stationid == -1)
        return ShowNotification(playerid, 0, 5, 0, 1, "Вы не рядом с заправкой", "");

    SetPVarInt(playerid, "fuel_station_id", stationid);

    new Node:root = JSON_Object();
    new Node:prices = JSON_Array(JSON_Int(65), JSON_Int(69), JSON_Int(77), JSON_Int(98), JSON_Int(86));

    JSON_SetInt(root, "o", 1);
    JSON_SetInt(root, "m", free_liters);
    JSON_SetString(root, "h", "Выберите тип топлива");
    JSON_SetArray(root, "ma", prices);
    JSON_SetInt(root, "cf", floatround(current_fuel));

    OnPacketIncoming(playerid, 2, root);

    JSON_Cleanup(prices);
    JSON_Cleanup(root);
    return 1;
}

stock Fuel_HandleGuiPacket(playerid, Node:json)
{
    new action = -1;
    JSON_GetInt(json, "t", action);

    switch(action)
    {
        case 1:
        {
            DeletePVar(playerid, "fuel_station_id");
            return 1;
        }
        case 0:
        {
            if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
                return ShowNotification(playerid, 0, 5, 0, 1, "Вы должны быть за рулем транспорта", "");

            new vehicleid = GetPlayerVehicleID(playerid);
            if(vehicleid == INVALID_VEHICLE_ID)
                return ShowNotification(playerid, 0, 5, 0, 1, "Транспорт не найден", "");

            new stationid = GetPVarInt(playerid, "fuel_station_id");
            if(stationid < 0 || stationid >= MAX_FUEL_STATIONS)
                return ShowNotification(playerid, 0, 5, 0, 1, "Ошибка заправки: станция не выбрана", "");

            if(Fuel_GetNearestStation(playerid, 18.0) == -1)
                return ShowNotification(playerid, 0, 5, 0, 1, "Отъехали слишком далеко от заправки", "");

            new owner, slot;
            if(!Fuel_GetVehicleOwnerSlot(vehicleid, owner, slot))
                return ShowNotification(playerid, 0, 5, 0, 1, "Заправка доступна только для личного транспорта", "");

            new fuel_type = 0, fuel_amount = 0;
            JSON_GetInt(json, "f", fuel_type);
            JSON_GetInt(json, "v", fuel_amount);

            if(fuel_type < 0 || fuel_type > 4)
                return ShowNotification(playerid, 0, 5, 0, 1, "Неверный тип топлива", "");

            new modelid = GetVehicleModel(vehicleid);
            new allowed_type = Fuel_GetAllowedTypeByModel(modelid);
            if(fuel_type != allowed_type)
            {
                new allowed_name[16], err_msg[96];
                Fuel_GetTypeName(allowed_type, allowed_name, sizeof(allowed_name));
                format(err_msg, sizeof(err_msg), "Для этого авто подходит только %s", allowed_name);
                return ShowNotification(playerid, 0, 5, 0, 1, err_msg, "");
            }

            if(fuel_amount <= 0)
                return ShowNotification(playerid, 0, 5, 0, 1, "Введите корректный объем топлива", "");

            new Float:current_fuel = Fuel_Clamp(VehicleInfo[owner][slot][vFuel]);
            new available_liters = floatround(FUEL_MAX_LITERS - current_fuel, floatround_floor);
            if(available_liters <= 0)
                return ShowNotification(playerid, 0, 5, 0, 1, "Бак уже заполнен", "");

            if(fuel_amount > available_liters)
                fuel_amount = available_liters;

            new fuel_prices[5] = {65, 69, 77, 98, 86};
            new total_price = fuel_prices[fuel_type] * fuel_amount;

            if(GetPlayerMoneyEx(playerid) < total_price)
                return ShowNotification(playerid, 0, 5, 0, 1, "Недостаточно денег для заправки", "");

            GivePlayerMoneyEx(playerid, -total_price);

            VehicleInfo[owner][slot][vFuel] = Fuel_Clamp(current_fuel + float(fuel_amount));
            gVehicleFuelType[owner][slot] = fuel_type;
            Fuel_FlushVehicleImmediate(owner, slot);
            Fuel_UpdateHudForOccupants(vehicleid, VehicleInfo[owner][slot][vFuel]);

            new fuel_msg[96];
            format(fuel_msg, sizeof(fuel_msg), "Заправлено %d л. В баке: %d л.", fuel_amount, floatround(VehicleInfo[owner][slot][vFuel]));
            ShowNotification(playerid, 1, 5, 0, 1, fuel_msg, "");

            new Node:close_json = JSON_Object();
            JSON_SetInt(close_json, "c", 1);
            OnPacketIncoming(playerid, 2, close_json);
            JSON_Cleanup(close_json);

            DeletePVar(playerid, "fuel_station_id");
            return 1;
        }
    }
    return 0;
}

CMD:i(playerid, params[])
{
    #pragma unused params
    return Fuel_ShowGui(playerid);
}

CMD:fuelfill(playerid, params[])
{
    #pragma unused params
    return callcmd::i(playerid, "");
}

CMD:fueldebug(playerid, params[])
{
    #pragma unused params
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return ShowNotification(playerid, 0, 5, 0, 1, "Вы не в транспорте", "");

    new owner, slot;
    if(!Fuel_GetVehicleOwnerSlot(vehicleid, owner, slot))
        return ShowNotification(playerid, 0, 5, 0, 1, "Личный транспорт не найден", "");

    new msg[96];
    format(msg, sizeof(msg), "FuelDebug: %.1f л (owner=%d slot=%d)", VehicleInfo[owner][slot][vFuel], owner, slot);
    ShowNotification(playerid, 1, 7, 0, 1, msg, "");
    Fuel_SendHud(playerid, VehicleInfo[owner][slot][vFuel]);
    return 1;
}

CMD:addfuel(playerid, params[])
{
    #pragma unused params
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 6)
        return ShowNotification(playerid, 0, 5, 0, 1, "Команда доступна только администрации", "");

    if(g_FuelStationCount >= MAX_FUEL_STATIONS)
        return ShowNotification(playerid, 0, 5, 0, 1, "Достигнут лимит заправок", "");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new query[512];
    new idx = Fuel_AddStationToMemory(0, x, y, z);
    if(idx == -1) return ShowNotification(playerid, 0, 5, 0, 1, "Не удалось добавить заправку", "");

    mysql_format(db_handle, query, sizeof(query),
        "INSERT INTO `fuel_stations` (`owner_id`,`name`,`improvements`,`fuels`,`fuel_price`,`buy_fuel_price`,`balance`,`rent_time`,`price`,`rent_price`,`lock`,`x`,`y`,`z`,`eviction`) \
        VALUES (0,'Заправочная станция',0,5000,3,0,0,0,90000000,9000,0,%f,%f,%f,0)",
        x, y, z
    );
    mysql_tquery(db_handle, query, "Fuel_OnAdminFuelStationInserted", "ii", playerid, idx);
    return 1;
}

CMD:delfuel(playerid, params[])
{
    #pragma unused params
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 6)
        return ShowNotification(playerid, 0, 5, 0, 1, "Команда доступна только администрации", "");

    new idx = Fuel_GetNearestStation(playerid, 8.0);
    if(idx == -1)
        return ShowNotification(playerid, 0, 5, 0, 1, "Рядом нет заправки для удаления", "");

    if(g_FuelStations[idx][FuelStationSqlId] > 0)
    {
        new query[128];
        mysql_format(db_handle, query, sizeof(query), "DELETE FROM `fuel_stations` WHERE `id`=%d LIMIT 1", g_FuelStations[idx][FuelStationSqlId]);
        mysql_tquery(db_handle, query, "", "");
    }

    g_FuelStations[idx][FuelStationActive] = false;
    Fuel_DestroyStationVisual(idx);
    g_FuelStations[idx][FuelStationSqlId] = 0;
    g_FuelStationCount--;
    if(g_FuelStationCount < 0) g_FuelStationCount = 0;

    ShowNotification(playerid, 1, 5, 0, 1, "Заправка удалена", "");
    return 1;
}

/// Стайлинг / техцентр / шиномонтаж: память топлива при входе; при выходе восстановление + SQL UPDATE (fuel, mileage).
stock Ts_SnapFuelMileage(playerid, vehicleid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(vehicleid == INVALID_VEHICLE_ID || !GetVehicleModel(vehicleid)) return 0;

    new owner, slot;
    if(!ResolveVehicleOwnerSlot(vehicleid, owner, slot)) return 0;
    if(VehicleInfo[owner][slot][vDBID] == 0) return 0;

    SetPVarInt(playerid, "ts_v", 1);
    SetPVarInt(playerid, "ts_dbid", VehicleInfo[owner][slot][vDBID]);
    SetPVarFloat(playerid, "ts_fuel", VehicleInfo[owner][slot][vFuel]);
    SetPVarFloat(playerid, "ts_mile", gVehicleMileage[owner][slot]);
    return 1;
}

stock Ts_RestoreFuelMileage(playerid, vehicleid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(vehicleid == INVALID_VEHICLE_ID || !GetVehicleModel(vehicleid)) return 0;
    if(GetPVarInt(playerid, "ts_v") != 1)
        return 0;

    new owner, slot;
    if(!ResolveVehicleOwnerSlot(vehicleid, owner, slot))
    {
        DeletePVar(playerid, "ts_v");
        DeletePVar(playerid, "ts_dbid");
        DeletePVar(playerid, "ts_fuel");
        DeletePVar(playerid, "ts_mile");
        return 0;
    }
    if(VehicleInfo[owner][slot][vDBID] != GetPVarInt(playerid, "ts_dbid"))
    {
        DeletePVar(playerid, "ts_v");
        DeletePVar(playerid, "ts_dbid");
        DeletePVar(playerid, "ts_fuel");
        DeletePVar(playerid, "ts_mile");
        return 0;
    }

    VehicleInfo[owner][slot][vFuel] = Fuel_Clamp(GetPVarFloat(playerid, "ts_fuel"));
    gVehicleMileage[owner][slot] = Mileage_Clamp(GetPVarFloat(playerid, "ts_mile"));

    DeletePVar(playerid, "ts_v");
    DeletePVar(playerid, "ts_dbid");
    DeletePVar(playerid, "ts_fuel");
    DeletePVar(playerid, "ts_mile");

    Fuel_UpdateHudForOccupants(vehicleid, Fuel_Clamp(VehicleInfo[owner][slot][vFuel]));
    Fuel_FlushVehicleImmediate(owner, slot);
    return 1;
}

stock TuningSession_ClearSnapshot(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    DeletePVar(playerid, "ts_v");
    DeletePVar(playerid, "ts_dbid");
    DeletePVar(playerid, "ts_fuel");
    DeletePVar(playerid, "ts_mile");
    return 1;
}

