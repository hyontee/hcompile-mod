//>> Файл: bykranin_src/core/vehicle/tuning_02.inc  (295 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: ResetCarModes, CheckFirmwareLine, TechCenter_SetFirmwareItemOwned, TechCenter_SyncFirmwareRuntime, TechCenter_GetFirmwareLineByItem, TechCenter_ActivateFirmwareIfComplete, GetFirmwarePrice
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock ResetCarModes(playerid, vehicleid)
{
    if(!IsAOwnableCar(vehicleid)) return 0;
    static const modes[] = { 8, 9, 10, 11 };

    new JSON:tmp = JSON_Object();

    for (new i = 0; i < sizeof(modes); i++)
    {
        JSON_SetInt(tmp, "t", modes[i]);
        JSON_SetInt(tmp, "s", 0);
        OnPacketIncoming(playerid, GUIRadialMenuForCar, tmp);
    }

    JSON_Cleanup(tmp);
	new i = GetVehicleData(vehicleid, V_ACTION_ID);
    if(i < 0 || i >= sizeof(vInfo) || i >= MAX_OWNABLE_CARS) return 0;
    vInfo[i][vFstate] = FSTATE_NONE;
    vInfo[vehicleid][vFstate] = FSTATE_NONE;
    SetOwnableCarData(i, OC_FSTATE, FSTATE_NONE);
	SendCarFirmware(playerid, FSTATE_NONE);
    SetVehicleDriftForPlayer(playerid, vehicleid, 0);
	new query[75], Cache: result;
	new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
	mysql_format(mysql, query, sizeof query,
        "UPDATE ownable_cars SET f_state = %d WHERE id = %d",
        FSTATE_NONE, database_id
    );
	mysql_query(mysql, query, false);
	printf("%d", database_id);
    TechCenter_ApplyPerformance(vehicleid);
    return 1;
}
stock CheckFirmwareLine(index, firmware_line)
{
    if(index < 0 || index >= MAX_OWNABLE_CARS) return 0;

    // g_ownable_car is the authoritative runtime mirror of ownable_cars.
    // Purchases now update it immediately, so checks no longer depend on a
    // stale vInfo copy that can be overwritten on exit/stream replay.
    switch (firmware_line)
    {
        case FSTATE_COMFORT:
            return GetOwnableCarData(index, OC_COMFORT_PL) && GetOwnableCarData(index, OC_COMFORT1) && GetOwnableCarData(index, OC_COMFORT2) && GetOwnableCarData(index, OC_COMFORT3) && GetOwnableCarData(index, OC_COMFORT4);
        case FSTATE_SPORT:
            return GetOwnableCarData(index, OC_SPORT) && GetOwnableCarData(index, OC_SPORT1) && GetOwnableCarData(index, OC_SPORT2) && GetOwnableCarData(index, OC_SPORT3) && GetOwnableCarData(index, OC_SPORT4);
        case FSTATE_DRIFT:
            return GetOwnableCarData(index, OC_DRIFT) && GetOwnableCarData(index, OC_DRIFT1) && GetOwnableCarData(index, OC_DRIFT2) && GetOwnableCarData(index, OC_DRIFT3) && GetOwnableCarData(index, OC_DRIFT4);
        case FSTATE_SPORT_PLUS:
            return GetOwnableCarData(index, OC_SPORT_PL) && GetOwnableCarData(index, OC_SPORT_PL1) && GetOwnableCarData(index, OC_SPORT_PL2) && GetOwnableCarData(index, OC_SPORT_PL3) && GetOwnableCarData(index, OC_SPORT_PL4);
    }
    return 0;
}

stock TechCenter_SetFirmwareItemOwned(index, data_value)
{
    if(index < 0 || index >= MAX_OWNABLE_CARS) return 0;

    // Keep both runtime views synchronized immediately after a purchase.
    // SQL alone is not enough: LoadTuning/stream replay copies these values
    // back from g_ownable_car and used to erase a freshly bought firmware part.
    switch(data_value)
    {
        case 4:  { vInfo[index][vComfort] = 1;    SetOwnableCarData(index, OC_COMFORT_PL, 1); }
        case 5:  { vInfo[index][vSport] = 1;      SetOwnableCarData(index, OC_SPORT, 1); }
        case 6:  { vInfo[index][vDrift] = 1;      SetOwnableCarData(index, OC_DRIFT, 1); }
        case 7:  { vInfo[index][vSportPlus] = 1;  SetOwnableCarData(index, OC_SPORT_PL, 1); }

        case 9:  { vInfo[index][vComfort1] = 1;   SetOwnableCarData(index, OC_COMFORT1, 1); }
        case 10: { vInfo[index][vSport1] = 1;     SetOwnableCarData(index, OC_SPORT1, 1); }
        case 11: { vInfo[index][vDrift1] = 1;     SetOwnableCarData(index, OC_DRIFT1, 1); }
        case 12: { vInfo[index][vSportPlus1] = 1; SetOwnableCarData(index, OC_SPORT_PL1, 1); }

        case 14: { vInfo[index][vComfort2] = 1;   SetOwnableCarData(index, OC_COMFORT2, 1); }
        case 15: { vInfo[index][vSport2] = 1;     SetOwnableCarData(index, OC_SPORT2, 1); }
        case 16: { vInfo[index][vDrift2] = 1;     SetOwnableCarData(index, OC_DRIFT2, 1); }
        case 17: { vInfo[index][vSportPlus2] = 1; SetOwnableCarData(index, OC_SPORT_PL2, 1); }

        case 19: { vInfo[index][vComfort3] = 1;   SetOwnableCarData(index, OC_COMFORT3, 1); }
        case 20: { vInfo[index][vSport3] = 1;     SetOwnableCarData(index, OC_SPORT3, 1); }
        case 21: { vInfo[index][vDrift3] = 1;     SetOwnableCarData(index, OC_DRIFT3, 1); }
        case 22: { vInfo[index][vSportPlus3] = 1; SetOwnableCarData(index, OC_SPORT_PL3, 1); }

        case 24: { vInfo[index][vComfort4] = 1;   SetOwnableCarData(index, OC_COMFORT4, 1); }
        case 25: { vInfo[index][vSport4] = 1;     SetOwnableCarData(index, OC_SPORT4, 1); }
        case 26: { vInfo[index][vDrift4] = 1;     SetOwnableCarData(index, OC_DRIFT4, 1); }
        case 27: { vInfo[index][vSportPlus4] = 1; SetOwnableCarData(index, OC_SPORT_PL4, 1); }
        default: return 0;
    }
    return 1;
}

stock TechCenter_SyncFirmwareRuntime(index)
{
    if(index < 0 || index >= MAX_OWNABLE_CARS) return 0;

    vInfo[index][vComfort]    = GetOwnableCarData(index, OC_COMFORT_PL);
    vInfo[index][vSport]      = GetOwnableCarData(index, OC_SPORT);
    vInfo[index][vDrift]      = GetOwnableCarData(index, OC_DRIFT);
    vInfo[index][vSportPlus]  = GetOwnableCarData(index, OC_SPORT_PL);

    vInfo[index][vComfort1]   = GetOwnableCarData(index, OC_COMFORT1);
    vInfo[index][vSport1]     = GetOwnableCarData(index, OC_SPORT1);
    vInfo[index][vDrift1]     = GetOwnableCarData(index, OC_DRIFT1);
    vInfo[index][vSportPlus1] = GetOwnableCarData(index, OC_SPORT_PL1);

    vInfo[index][vComfort2]   = GetOwnableCarData(index, OC_COMFORT2);
    vInfo[index][vSport2]     = GetOwnableCarData(index, OC_SPORT2);
    vInfo[index][vDrift2]     = GetOwnableCarData(index, OC_DRIFT2);
    vInfo[index][vSportPlus2] = GetOwnableCarData(index, OC_SPORT_PL2);

    vInfo[index][vComfort3]   = GetOwnableCarData(index, OC_COMFORT3);
    vInfo[index][vSport3]     = GetOwnableCarData(index, OC_SPORT3);
    vInfo[index][vDrift3]     = GetOwnableCarData(index, OC_DRIFT3);
    vInfo[index][vSportPlus3] = GetOwnableCarData(index, OC_SPORT_PL3);

    vInfo[index][vComfort4]   = GetOwnableCarData(index, OC_COMFORT4);
    vInfo[index][vSport4]     = GetOwnableCarData(index, OC_SPORT4);
    vInfo[index][vDrift4]     = GetOwnableCarData(index, OC_DRIFT4);
    vInfo[index][vSportPlus4] = GetOwnableCarData(index, OC_SPORT_PL4);
    vInfo[index][vFstate]     = GetOwnableCarData(index, OC_FSTATE);
    return 1;
}

stock TechCenter_GetFirmwareLineByItem(data_value)
{
    switch(data_value)
    {
        case 4, 9, 14, 19, 24:  return FSTATE_COMFORT;
        case 5, 10, 15, 20, 25: return FSTATE_SPORT;
        case 6, 11, 16, 21, 26: return FSTATE_DRIFT;
        case 7, 12, 17, 22, 27: return FSTATE_SPORT_PLUS;
    }
    return FSTATE_NONE;
}

stock TechCenter_ActivateFirmwareIfComplete(playerid, vehicleid, database_id, data_value)
{
    if(!IsAOwnableCar(vehicleid)) return 0;
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || index >= MAX_OWNABLE_CARS) return 0;

    new firmware_line = TechCenter_GetFirmwareLineByItem(data_value);
    if(firmware_line == FSTATE_NONE || !CheckFirmwareLine(index, firmware_line)) return 0;

    vInfo[index][vFstate] = firmware_line;
    vInfo[vehicleid][vFstate] = firmware_line;
    SetOwnableCarData(index, OC_FSTATE, firmware_line);

    new query[96];
    mysql_format(mysql, query, sizeof query,
        "UPDATE ownable_cars SET f_state = %d WHERE id = %d", firmware_line, database_id);
    mysql_query(mysql, query, false);

    SetVehicleDriftForPlayer(playerid, vehicleid, firmware_line == FSTATE_DRIFT);
    switch(firmware_line)
    {
        case FSTATE_COMFORT:    SendCarFirmware(playerid, FSTATE_COMFORT);
        case FSTATE_SPORT:      SendCarFirmware(playerid, FSTATE_SPORT);
        case FSTATE_SPORT_PLUS: SendCarFirmware(playerid, FSTATE_SPORT_PLUS);
    }

    TechCenter_ApplyPerformance(vehicleid);
    printf("[TECHCENTER][FIRMWARE] activated player=%d vehicle=%d car=%d item=%d state=%d", playerid, vehicleid, database_id, data_value, firmware_line);
    return 1;
}

#define PERCENT_COMFORT   4.25
#define PERCENT_SPORT     7.25
#define PERCENT_DRIFT     5.25
#define PERCENT_SPORTPLUS 0.53
stock GetFirmwarePrice(vehicleID, Float:percent)
{
    new car_price = GetVehiclePriceByModel(vInfo[vehicleID][vModelID]);
	printf("carprice %d", car_price);
	printf("carpriceper %d", floatround(car_price * (percent / 100.0)));
    return floatround(car_price * (percent / 100.0));
}

stock SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, bias) 
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, 1); 
	new packed = _:bias; // reinterpret float bits
BS_WriteValue(bs, PR_UINT32, packed);
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}
stock SetVehicleSuspensionBiasFor(playerid, vehicleid, bias) 
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, 2); 
	new packed = _:bias; // reinterpret float bits
BS_WriteValue(bs, PR_UINT32, packed);
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}
new bool:CarLights[MAX_VEHICLES];
new bool:CarLock[MAX_VEHICLES];
new bool:CarEngine[MAX_VEHICLES];
new bool:CarKey[MAX_VEHICLES];

// V11 NETWORK CRASH HARDFIX:
// Do not parse or rewrite incoming PLAYER_SYNC (207), VEHICLE_SYNC (200) or
// PASSENGER_SYNC (211) packets. Rewriting a live sync BitStream in-place can
// corrupt key/velocity/state fields on mobile clients when packet layouts differ,
// which manifests as stuck forward input, dead touch buttons and random crashes
// for nearby players. Damage remains server-authoritative through RPC 115.

// V11.2 SAFE: outgoing player sync hooks removed.
// Do not rewrite server -> client PLAYER/VEHICLE/PASSENGER sync here;
// altering those packets caused remote position/nametag desynchronization.

// Native SA-MP GiveTakeDamage RPC. Returning 0 blocks the default path because
// this mode keeps health server-authoritative in DamageRpc_Handle115.
IRPC:115(playerid, BitStream:bs)
{
    new bool:take_damage;
    new targetid;
    new Float:damage;
    new weaponid;
    new bodypart;

    if(!BS_ReadBool(bs, take_damage)) return 0;
    if(!BS_ReadUint16(bs, targetid)) return 0;
    if(!BS_ReadFloat(bs, damage)) return 0;
    if(!BS_ReadUint32(bs, weaponid)) return 0;
    if(!BS_ReadUint32(bs, bodypart)) return 0;

    DamageRpc_Handle115(playerid, take_damage, targetid, damage, weaponid, bodypart);
    return 0;
}

enum E_RADIO_STATION
{
    RADIO_STATION_KEY[32],
    RADIO_STATION_NAME[40],
    RADIO_STATION_URL[160]
};

new const g_radio_stations[][E_RADIO_STATION] =
{
    {"gangster_music",  "GANGSTER MUSIC",   "http://radio.blackrussia.online/listen/gangster_music_[uncensored]/radio"},
    {"dnb_nation",      "DNB NATION",       "http://radio.blackrussia.online/listen/dnb_nation_[uncensored]/radio"},
    {"high_head",       "HIGH HEAD",        "http://radio.blackrussia.online/listen/high_head_radio_[uncensored]/radio"},
    {"phonk_city_radio", "PHONK CITY RADIO", "http://radio.blackrussia.online/listen/phonk_city_radio_[uncensored]/radio"},
    {"alt_fm",          "ALT FM",           "https://radio.blackrussia.online/listen/alt_fm_[uncensored]/radio"},
    {"radio_drive",     "DRIVE",            "https://radio.blackrussia.online/listen/radio_drive_[uncensored]/radio"}
};

stock Radio_HandlePacket(playerid, Node:json)
{
    new action_type = 0;
    if(!JSON_GetInt(json, "t", action_type) || action_type != 1) return 1;

    new radio_type[32];
    if(!JSON_GetString(json, "r", radio_type, sizeof(radio_type))) return 1;

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", 1);

    if(!strcmp(radio_type, "off", true))
    {
        StopAudioStream(playerid);
        JSON_SetString(response, "r", "off");
        ShowNotificationNew(playerid, 3, 6, 0, 0, "Музыка отключена", " ");
        OnPacketIncoming(playerid, 112, response);
        JSON_Cleanup(response);
        return 1;
    }

    for(new i = 0; i < sizeof(g_radio_stations); i++)
    {
        if(strcmp(radio_type, g_radio_stations[i][RADIO_STATION_KEY], true)) continue;

        new message[96];
        format(message, sizeof(message), "Включена радиостанция - %s", g_radio_stations[i][RADIO_STATION_NAME]);
        PlayAudioStreamURL(playerid, g_radio_stations[i][RADIO_STATION_URL]);
        ShowNotificationNew(playerid, 3, 6, 0, 0, message, " ");
        JSON_SetString(response, "r", g_radio_stations[i][RADIO_STATION_KEY]);
        OnPacketIncoming(playerid, 112, response);
        JSON_Cleanup(response);
        return 1;
    }

    JSON_SetString(response, "r", "off");
    ShowNotificationNew(playerid, 2, 6, 0, 0, "Неизвестная радиостанция", " ");
    OnPacketIncoming(playerid, 112, response);
    JSON_Cleanup(response);
    return 1;
}

