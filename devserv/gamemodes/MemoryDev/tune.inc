#define MenuComposeGUIFragment 14
#define GUIRadialMenuForCar 27
#define GUITuning 28

#define vDifferential       17
#define vVinyl             9
#define vTint              3

#define VF_SPORTA      (1)
#define VF_DRIFTA      (2)
#define VF_COMFORTA    (4)
#define VF_SPORTPLUSA  (8)
#define VF_STROB_ON    (16)
#define VF_DALNIY_ON   (32)

new g_VehicleNumberPlate[MAX_VEHICLES][8];
new g_VehicleRegion[MAX_VEHICLES][4];

new Iterator:streamed_players_in_veh[MAX_VEHICLES]<MAX_PLAYERS-1>;
new Iterator:vehicle_in_stream[MAX_PLAYERS]<MAX_VEHICLES-1>;
new streamed_players_in_veh_count[MAX_VEHICLES];
new streamed_players_in_veh_list[MAX_VEHICLES][MAX_PLAYERS];

enum Wheel_Properties
{
 Radius,
 Width[2],
 Alignment[2],
 Departure[2],
}

enum NumberPlate_Info
{
 Type,
 Number[12],
 Region[4],
}

enum Veh_Info
{
    Float:vFuel,
    Float:vMileage,
    vLightColor,
    vHighLights,
	vSQLID,
	vModelID,
    vNeon[3],
	vFstate,
    vColorBody,
    vColorWheels,
    vWheel[Wheel_Properties],
	IsHydroBought,
	IsFarLightBought,
	IsFarLightActive,
	IsHydroActive,
	IsPnevmoBought,
	SelectedPnevmo,
    vClearance,
    vSeparate,
    vHydraulics,
    vTonerFront,
    vTonerRear,
    vTonerFrontSide,
    vTonerRearSide,
    vNitro,
    vNumber[NumberPlate_Info],
	vinil_current,
	exhsuast_current,
	strab_current,
	horn_current,
    vLaunchControl,
	vLaunchControls,
    vHornSound,
    vExhaustSound,
    vComfort1,
    vSport1,
    vDrift1,
    vSportPlus1,
    vComfort,
    vSport,
    vDrift,
    vSportPlus,
    vComfort2,
    vSport2,
    vDrift2,
    vSportPlus2,  
    vComfort3,
    vSport3,
    vDrift3, vSportPlus3,    
    vComfort4,
    vSport4,
    vDrift4,
    vSportPlus4,
	vynil_name[32],
    vVinylTexture[16],
    vFirmware,
    vSiren,
    vStrob,
    vTurnSiren,
    vEnableHydraulics[MAX_PLAYERS], vEnableNeon, vEnableStrob[MAX_PLAYERS], vEnableHighLights[MAX_PLAYERS], pdvradar, percentofclirness, iscase, percentofclirnessz, wheel_offset_ft, wheel_offset_rr, align_ft, align_rr, width_ft, width_rr, wheel_radius, wheel_colors, lights_color, underlights_color, underlights_color_lf, underlights_color_rt, body_colors, tonir_ft, tonir_rr, wheel_comp, Float:vMaxSpeed, Float:vBrakePower, Float:vAccelerationBonus
};
new vInfo[MAX_VEHICLES][Veh_Info];

new const VinylNames[][] = {
    "remapbody8", "remapbody5", "remapbody32", "remapbody40", "remapbody21", "remapbody29",
    "remapbody41", "remapbody6", "remapbody31", "remapbody19", "remapbody28", "remapbody30",
    "remapbody11", "remapbody12", "remapbody15", "remapbody26", "remapbody16", "remapbody13",
    "remapbody18", "remapbody35", "remapbody10", "remapbody17", "remapbody38", "remapbody2",
    "remapbody23", "remapbody36", "remapbody4", "remapbody14", "remapbody37", "remapbody20",
    "remapbody7", "remapbody25", "remapbody39", "remapbody1", "remapbody33", "remapbody9",
    "remapbody22", "remapbody24", "remapbody34", "remapbody42", "remapbody47", "remapbody48",
    "remapbody43", "remapbody44", "remapbody49", "remapbody51", "remapbody45", "remapbody46",
    "remaphbody1", "remaphbody2", "remaphbody3", "remaphbody4", "remaphbody5", "remaphbody6",
    "remaphbody7", "remaphbody8", "remaphbody9", "remaphbody10", "remaphbody11", "remapnbody1",
    "remapnbody2", "remapnbody3", "remapnbody4", "remapnbody5", "remapnbody6", "remapnbody7",
    "remapnbody8", "remapnbody9", "remapnbody10", "remapnbody11", "remapnbody12", "remapnbody13",
    "remapnbody14", "remapnbody15", "remapnbody16", "remapnbody17", "remapmbody1", "remapmbody2",
    "remapmbody3", "remapmbody4", "remapmbody5", "remapmbody6", "remapmbody7", "remapmbody8",
    "remapmbody9", "remapmbody10", "remapmbody11", "remapmbody12", "remapmbody13", "remapmbody14",
    "remapmbody15", "remapmbody16", "remapmbody17", "", "", "", "", "", "", "", "", "", "", 
    "", "", "", "", "", "", "", "remapnbody18", "remapnbody19", "remapnbody20", "remapnbody21", 
    "remapnbody22", "remapnbody23", "remapnbody24", "remapnbody25", "remapnbody26", "remapnbody27"
};

forward bool:VehGetFlag(playerid, slot, flag);
forward VehSetFlag(playerid, slot, flag, bool:value);
forward bool:VehToggleFlag(playerid, slot, flag);

stock IsPartInstalled(value, part)
{
    if (value <= 0) return 0;
    
    new temp_val = value;
    while (temp_val > 0)
    {
        if (temp_val % 10 == part) return 1;
        temp_val /= 10;
    }
    return 0;
}

stock IsFullSetInstalled(value)
{
    return (IsPartInstalled(value, 1) && IsPartInstalled(value, 2) && 
            IsPartInstalled(value, 3) && IsPartInstalled(value, 4) && 
            IsPartInstalled(value, 5));
}

stock BuyPart(playerid, vehicleid, detal_id)
{
    new slot = -1;
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) {
        if(VehicleInfo[playerid][i][vID] == vehicleid) { slot = i; break; }
    }
    if(slot == -1) return 0;

    new type, part_num, add_val, current_val;

    switch(detal_id) {
        // COMFORT (ID: 4, 9, 14, 19, 24)
        case 4:  { type = 3; part_num = 1; add_val = 1; }
        case 9:  { type = 3; part_num = 2; add_val = 20; }
        case 14: { type = 3; part_num = 3; add_val = 300; }
        case 19: { type = 3; part_num = 4; add_val = 4000; }
        case 24: { type = 3; part_num = 5; add_val = 50000; }
        // SPORT (ID: 5, 10, 15, 20, 25)
        case 5:  { type = 1; part_num = 1; add_val = 1; }
        case 10: { type = 1; part_num = 2; add_val = 20; }
        case 15: { type = 1; part_num = 3; add_val = 300; }
        case 20: { type = 1; part_num = 4; add_val = 4000; }
        case 25: { type = 1; part_num = 5; add_val = 50000; }
        // DRIFT (ID: 6, 11, 16, 21, 26)
        case 6:  { type = 2; part_num = 1; add_val = 1; }
        case 11: { type = 2; part_num = 2; add_val = 20; }
        case 16: { type = 2; part_num = 3; add_val = 300; }
        case 21: { type = 2; part_num = 4; add_val = 4000; }
        case 26: { type = 2; part_num = 5; add_val = 50000; }
        // SPORT PLUS (ID: 7, 12, 17, 22, 27)
        case 7:  { type = 4; part_num = 1; add_val = 1; }
        case 12: { type = 4; part_num = 2; add_val = 20; }
        case 17: { type = 4; part_num = 3; add_val = 300; }
        case 22: { type = 4; part_num = 4; add_val = 4000; }
        case 27: { type = 4; part_num = 5; add_val = 50000; }
        case 0..2: { type = 5; part_num = detal_id; add_val = detal_id + 1; } 
        
        default: return 0;
    }

    new col_name[20];
    if(type == 1) { current_val = VehicleInfo[playerid][slot][vSport]; col_name = "sport"; }
    else if(type == 2) { current_val = VehicleInfo[playerid][slot][vDrift]; col_name = "drift"; }
    else if(type == 3) { current_val = VehicleInfo[playerid][slot][vComfort]; col_name = "comfort"; }
    else if(type == 4) { current_val = VehicleInfo[playerid][slot][vSportPlus]; col_name = "sport_plus"; }
    else if(type == 5) { current_val = VehicleInfo[playerid][slot][vNitro]; col_name = "nitro"; }

    if(type == 5) {
        if(current_val == add_val) {
            return 0;
        }
        VehicleInfo[playerid][slot][vNitro] = add_val;
    }
    else {
        if(IsPartInstalled(current_val, part_num)) {
            return 0;
        }
        new new_val = current_val + add_val;
        if(type == 1) VehicleInfo[playerid][slot][vSport] = new_val;
        else if(type == 2) VehicleInfo[playerid][slot][vDrift] = new_val;
        else if(type == 3) VehicleInfo[playerid][slot][vComfort] = new_val;
        else if(type == 4) VehicleInfo[playerid][slot][vSportPlus] = new_val;
    }

    new query[128];
    mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `%s`='%d' WHERE `id`='%d'", col_name, (type == 5 ? add_val : VehicleInfo[playerid][slot][(type==1?vSport:type==2?vDrift:type==3?vComfort:vSportPlus)]), VehicleInfo[playerid][slot][vDBID]);
    mysql_tquery(db_handle, query);
    
    return 1;
}

stock GetVehiclePriceByModel(modelid)
{
    for(new i = 0; i < sizeof(LowSalonCars); i++) {
        if(LowSalonCars[i][sModel] == modelid) return LowSalonCars[i][sPrice];
    }
    for(new i = 0; i < sizeof(MediumSalonCars); i++) {
        if(MediumSalonCars[i][sModel] == modelid) return MediumSalonCars[i][sPrice];
    }
    for(new i = 0; i < sizeof(SalonCars); i++) {
        if(SalonCars[i][sModel] == modelid) return SalonCars[i][sPrice];
    }
    return 0; 
}

stock ShowTuneTest(playerid, value, const tune_name[])
{
    if(IsFullSetInstalled(value))
    {
        new msg[64];
        format(msg, sizeof(msg), "{00FF00}%s ВКЛЮЧЕН", tune_name);
        SendClientMessage(playerid, -1, msg);
    }
    else
    {
        new missing[64], msg[128];
        for(new p = 1; p <= 5; p++)
        {
            if(!IsPartInstalled(value, p))
            {
                format(missing, sizeof(missing), "%s%d ", missing, p);
            }
        }
        format(msg, sizeof(msg), "{FF0000}%s НЕ ВКЛЮЧЕН. Нет деталей: %s", tune_name, missing);
        SendClientMessage(playerid, -1, msg);
    }
    return 1;
}

stock SetVehicleAcceleration(vehicleid, Float:accel)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i)) 
        {
            SetVehicleAccelerationForPlayer(i, vehicleid, accel);
        }
    }
}

stock SetVehicleAccelerationForPlayer(playerid, vehicleid, Float:accel)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, 5);
    BS_WriteValue(bs, PR_FLOAT, accel);

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

stock GetPlayerVehicleSlot(playerid, vehicleid)
{
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) {
        if(VehicleInfo[playerid][i][vSpawned] && VehicleInfo[playerid][i][vID] == vehicleid) return i;
    }
    return -1;
}

stock SetVehicleDriftMode(playerid, vehicleid, bool:status)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT8, 5);
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, (status) ? 1 : 0);
    PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);

    BS_Delete(bs);
    return 1;
}

stock GetBodyPaintCost(price)
{
    return (price / 100) + 10000;
}

stock GetUnivCost(price)
{
    return (price / 100) + 10000 + 40000;
}

stock GetDalniyCost(price)
{
    return (price / 1000) + 10000;
}
stock GetDoubleCost(price)
{
    return ((price / 100) + 10000) * 2;
}

stock GetExtraCost(price)
{
    return (price / 100) + 10000 + 10000;
}

stock GetDonatCost(price)
{
    return (((price / 100) + 10000 + 40000) * 3) / 1000;
}

CMD:techcentergui(playerid, params[])
{
    InStailing[playerid] = false;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!vehicleid) return SendClientMessage(playerid, -1, "{FF0000}Вы должны быть в машине!");

    new slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if (slot == -1) return SendClientMessage(playerid, -1, "{FF0000}Это не ваш личный транспорт!");

    new model = GetVehicleModel(vehicleid);
    new price = GetVehiclePriceByModel(model);
    new Node:tuning_json = JSON_Object();
    new Node:k_array = JSON_Array(); 

    static const part_ids[4][5] = {
        {4, 9, 14, 19, 24},
        {5, 10, 15, 20, 25},
        {7, 12, 17, 22, 27},
        {6, 11, 16, 21, 26}
    };

    new part_values[4];
    part_values[0] = VehicleInfo[playerid][slot][vComfort];
    part_values[1] = VehicleInfo[playerid][slot][vSport];
    part_values[2] = VehicleInfo[playerid][slot][vSportPlus];
    part_values[3] = VehicleInfo[playerid][slot][vDrift];

    for(new i = 0; i < 4; i++)
    {
        for(new p = 1; p <= 5; p++)
        {
            if(IsPartInstalled(part_values[i], p))
            {
                k_array = JSON_Append(k_array, JSON_Array(JSON_Int(part_ids[i][p-1])));
                k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
            }
        }
    }

    new nitro_val = VehicleInfo[playerid][slot][vNitro];
    if(nitro_val >= 1 && nitro_val <= 3)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(nitro_val - 1)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }

    JSON_SetInt(tuning_json, "w", 3);
    JSON_SetInt(tuning_json, "o", 1); 
    JSON_SetInt(tuning_json, "j", price); 
    JSON_SetInt(tuning_json, "s", 5);
    JSON_SetArray(tuning_json, "k", k_array);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", GetVehicleNameByModel(model));
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    new vw = playerid + 1000;
    SetPlayerVirtualWorld(playerid, vw);
    SetVehicleVirtualWorld(vehicleid, vw);
    SetPlayerInterior(playerid, 1);
    SetVehiclePos(vehicleid, 996.1070, 999.4791, 1000.5);
    SetVehicleZAngle(vehicleid, -90.0);
    SetPlayerCameraPos(playerid, 1001.1626, 1002.8044, 1000.9689);
    SetPlayerCameraLookAt(playerid, 1000.3796, 1002.1858, 1001.0136);

    OnPacketIncoming(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

CMD:tungui(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new model = GetVehicleModel(vehicleid);
    new price = GetVehiclePriceByModel(model);
    new Node:tuning_json = JSON_Object();

    InStailing[playerid] = true;

    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 0);
    JSON_SetInt(tuning_json, "j", price); 
    JSON_SetInt(tuning_json, "s", 5);

    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", GetVehicleNameByModel(model));
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    SetPlayerInterior(playerid, 1);

    new carid = GetPlayerVehicleID(playerid);
    if (carid != 0)
    {
        SetVehiclePos(carid, 1000.0, 1500.0, 1498.0);
        SetVehicleZAngle(carid, 180.0);
    }

    SetPlayerCameraPos(playerid, 1003.9196, 1493.9724, 1499.7500);
    SetPlayerCameraLookAt(playerid, 1003.3480, 1494.7935, 1499.5002);

    OnPacketIncoming(playerid, 28, tuning_json);

    return 1;
}

CMD:shinka(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new model = GetVehicleModel(vehicleid);
    new price = GetVehiclePriceByModel(model);
    new Node:tuning_json = JSON_Object();

    InStailing[playerid] = true;

    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 2);
    JSON_SetInt(tuning_json, "j", price); 
    JSON_SetInt(tuning_json, "s", 5);

    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", GetVehicleNameByModel(model));
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    SetPlayerInterior(playerid, 1);

    new Float:x = 998.23653, Float:y = 1499.67341, Float:z = 1499.66617;
    SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
    SetVehicleZAngle(GetPlayerVehicleID(playerid), 270.0);

    new interior = 1;

    SetPlayerInterior(playerid, interior);

    SetPlayerInterior(playerid, interior);
    
    new carid = GetPlayerVehicleID(playerid); 

    if (carid != 0)
    {
       SetVehiclePos(carid, 995.7154, 1000.5235, 1500.1683);
    }

    SetVehiclePos(carid, 995.7154, 1000.5235, 1500.1683);
    SetVehicleZAngle(carid, 180.0);
    SetPlayerCameraPos(playerid, 999.1838, 995.9953, 1501.7263);
    SetPlayerCameraLookAt(playerid, 998.5103, 996.7333, 1501.5776);

    OnPacketIncoming(playerid, 28, tuning_json);

    return 1;
}

CMD:comforton(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1 || !IsFullSetInstalled(VehicleInfo[playerid][slot][vComfort])) return 0;
    SetVehicleAcceleration(vehicleid, 31.8);
    VehSetFlag(playerid, slot, VF_COMFORTA, true);
    return 1;
}

CMD:comfortoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;
    SetVehicleAcceleration(vehicleid, 0.0);
    VehSetFlag(playerid, slot, VF_COMFORTA, false);
    new Node:json_radial_data = JSON_Object();
    JSON_SetInt(json_radial_data, "s", 0);
    OnPacketIncoming(playerid, 27, json_radial_data);
    JSON_Cleanup(json_radial_data);
    return 1;
}

CMD:sporton(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1 || !IsFullSetInstalled(VehicleInfo[playerid][slot][vSport])) return 0;
    SetVehicleAcceleration(vehicleid, 35.0);
    VehSetFlag(playerid, slot, VF_SPORTA, true);
    return 1;
}

CMD:sportoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;
    SetVehicleAcceleration(vehicleid, 0.0);
    VehSetFlag(playerid, slot, VF_SPORTA, false);
    new Node:json_radial_data = JSON_Object();
    JSON_SetInt(json_radial_data, "s", 0);
    OnPacketIncoming(playerid, 27, json_radial_data);
    JSON_Cleanup(json_radial_data);
    return 1;
}

CMD:sportpluson(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1 || !IsFullSetInstalled(VehicleInfo[playerid][slot][vSportPlus])) return 0;
    SetVehicleAcceleration(vehicleid, 36.0);
    VehSetFlag(playerid, slot, VF_SPORTPLUSA, true);
    return 1;
}

CMD:sportplusoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;
    SetVehicleAcceleration(vehicleid, 0.0);
    VehSetFlag(playerid, slot, VF_SPORTPLUSA, false);
    new Node:json_radial_data = JSON_Object();
    JSON_SetInt(json_radial_data, "s", 0);
    OnPacketIncoming(playerid, 27, json_radial_data);
    JSON_Cleanup(json_radial_data);
    return 1;
}

CMD:drifton(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1 || !IsFullSetInstalled(VehicleInfo[playerid][slot][vDrift])) return 0;
    SetVehicleDriftMode(playerid, vehicleid, true);
    VehSetFlag(playerid, slot, VF_DRIFTA, true);
    return 1;
}

CMD:driftoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;
    SetVehicleDriftMode(playerid, vehicleid, false);
    VehSetFlag(playerid, slot, VF_DRIFTA, false);
    new Node:json_radial_data = JSON_Object();
    JSON_SetInt(json_radial_data, "s", 0);
    OnPacketIncoming(playerid, 27, json_radial_data);
    JSON_Cleanup(json_radial_data);
    return 1;
}

CMD:tuningoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    SetVehicleAcceleration(vehicleid, 0.0);
    SetVehicleDriftMode(playerid, vehicleid, false);
    if(slot != -1)
    {
        VehSetFlag(playerid, slot, VF_SPORTA, false);
        VehSetFlag(playerid, slot, VF_DRIFTA, false);
        VehSetFlag(playerid, slot, VF_COMFORTA, false);
        VehSetFlag(playerid, slot, VF_SPORTPLUSA, false);
    }
    new Node:json_radial_data = JSON_Object();
    JSON_SetInt(json_radial_data, "s", 0);
    OnPacketIncoming(playerid, 27, json_radial_data);
    JSON_Cleanup(json_radial_data);
    return 1;
}