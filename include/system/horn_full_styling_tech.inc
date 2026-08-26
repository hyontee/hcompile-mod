// Tech Center + Style Center transferred from mod_kak_mode_shinka(3).zip
// Added by ChatGPT merge helper.

#if !defined MAX_PLAYERS
    #error MAX_PLAYERS is not defined before horn_full_styling_tech.inc
#endif

#include <kirill/vehicle_names_map>
#include <kirill/vehicle_prices_map>


#if !defined PACKET_BLACKRRPC
    #define PACKET_BLACKRRPC 252
#endif

#if !defined _HORN_FULL_PACKET_HELPER
#define _HORN_FULL_PACKET_HELPER
stock OnPacketIncoming(playerid, guiid, Node:json)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_BLACKRRPC);
    BS_WriteValue(bitstream, PR_UINT16, guiid);

    static data[8192];
    data[0] = EOS;
    JSON_Stringify(json, data, sizeof(data));

    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
    return 1;
}
#endif


#if !defined _HORN_FULL_TUNING_PACKET
#define _HORN_FULL_TUNING_PACKET
forward PacketIncomingTuning(playerid, Node:JSONObject);
#endif

new HornTechComfort[MAX_OWNABLE_CARS];
new HornTechSport[MAX_OWNABLE_CARS];
new HornTechDrift[MAX_OWNABLE_CARS];
new HornTechSportPlus[MAX_OWNABLE_CARS];
new HornTechNitro[MAX_OWNABLE_CARS];

stock HornGetVehicleIndex(vehicleid)
{
    if(!IsValidVehicle(vehicleid)) return -1;
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR) return -1;
    new idx = GetVehicleData(vehicleid, V_ACTION_ID);
    if(idx < 0 || idx >= MAX_OWNABLE_CARS) return -1;
    return idx;
}


stock GetVehicleNameByModel(modelid)
{
    static name[64];
    name[0] = EOS;
    if(GetVehicleJsonNameByModelId(modelid, name, sizeof(name))) return name;
    format(name, sizeof(name), "Unknown Model %d", modelid);
    return name;
}

new bool:InStailing[MAX_PLAYERS];
new Float:HornTuneReturnX[MAX_PLAYERS];
new Float:HornTuneReturnY[MAX_PLAYERS];
new Float:HornTuneReturnZ[MAX_PLAYERS];
new Float:HornTuneReturnA[MAX_PLAYERS];
new HornTuneReturnInt[MAX_PLAYERS];
new HornTuneReturnVW[MAX_PLAYERS];
new HornTuneReturnVeh[MAX_PLAYERS];

stock HornTune_SaveReturn(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    HornTuneReturnVeh[playerid] = vehicleid;
    HornTuneReturnInt[playerid] = GetPlayerInterior(playerid);
    HornTuneReturnVW[playerid] = GetPlayerVirtualWorld(playerid);

    if(vehicleid != 0)
    {
        GetVehiclePos(vehicleid, HornTuneReturnX[playerid], HornTuneReturnY[playerid], HornTuneReturnZ[playerid]);
        GetVehicleZAngle(vehicleid, HornTuneReturnA[playerid]);
    }
    else
    {
        GetPlayerPos(playerid, HornTuneReturnX[playerid], HornTuneReturnY[playerid], HornTuneReturnZ[playerid]);
        GetPlayerFacingAngle(playerid, HornTuneReturnA[playerid]);
    }
    return 1;
}


stock HornTune_GetVehicleForPlayer(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(IsValidVehicle(vehicleid)) return vehicleid;

    vehicleid = HornTuneReturnVeh[playerid];
    if(IsValidVehicle(vehicleid)) return vehicleid;

    return INVALID_VEHICLE_ID;
}

stock HornTune_ReturnFromGUI(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == 0) vehicleid = HornTuneReturnVeh[playerid];

    SetPlayerVirtualWorld(playerid, HornTuneReturnVW[playerid]);
    SetPlayerInterior(playerid, HornTuneReturnInt[playerid]);

    if(vehicleid != 0 && IsValidVehicle(vehicleid))
    {
        SetVehicleVirtualWorld(vehicleid, HornTuneReturnVW[playerid]);
        LinkVehicleToInterior(vehicleid, HornTuneReturnInt[playerid]);
        SetVehiclePos(vehicleid, HornTuneReturnX[playerid], HornTuneReturnY[playerid], HornTuneReturnZ[playerid]);
        SetVehicleZAngle(vehicleid, HornTuneReturnA[playerid]);
        PutPlayerInVehicle(playerid, vehicleid, 0);
    }
    else
    {
        SetPlayerPos(playerid, HornTuneReturnX[playerid], HornTuneReturnY[playerid], HornTuneReturnZ[playerid]);
        SetPlayerFacingAngle(playerid, HornTuneReturnA[playerid]);
    }

    TogglePlayerControllable(playerid, 1);
    SetCameraBehindPlayer(playerid);
    InStailing[playerid] = false;
    return 1;
}

// ===== Style Center =====

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

stock HornStyle_OpenGUI(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new model = GetVehicleModel(vehicleid);
    new price = GetVehiclePriceByModel(model);
    if(price <= 0) price = 1000000;
    new Node:tuning_json = JSON_Object();

    HornTune_SaveReturn(playerid);
    InStailing[playerid] = true;
    SetPVarInt(playerid, "HornTuneCenterMode", 1);

    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "t", 3);
    JSON_SetInt(tuning_json, "w", 0);
    JSON_SetInt(tuning_json, "j", price); 
    JSON_SetInt(tuning_json, "s", 5);

    new Node:style_k_array = JSON_Array();
    if(vInfo[vehicleid][viVinyl] >= 0 && vInfo[vehicleid][viVinyl] < sizeof(VinylNames) && VinylNames[vInfo[vehicleid][viVinyl]][0] != EOS)
    {
        style_k_array = JSON_Append(style_k_array, JSON_Array(JSON_Int(vInfo[vehicleid][viVinyl])));
        style_k_array = JSON_Append(style_k_array, JSON_Array(JSON_Int(2)));
        JSON_SetArray(tuning_json, "k", style_k_array);
    }

    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", GetVehicleNameByModel(model));
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(tuning_json, "r", GetPlayerDonateRub(playerid));
    SetPVarInt(playerid, "gui_variant", 0);

    new vw = playerid + 2000;
    SetPlayerVirtualWorld(playerid, vw);
    SetVehicleVirtualWorld(vehicleid, vw);
    SetPlayerInterior(playerid, 1);
    LinkVehicleToInterior(vehicleid, 1);
    PutPlayerInVehicle(playerid, vehicleid, 0);

    new carid = GetPlayerVehicleID(playerid);
    if (carid != 0)
    {
        SetVehiclePos(carid, 1000.0, 1500.0, 1498.0);
        SetVehicleZAngle(carid, 180.0);
    }

    SetPlayerCameraPos(playerid, 1003.9196, 1493.9724, 1499.7500);
    SetPlayerCameraLookAt(playerid, 1003.3480, 1494.7935, 1499.5002);

    OnPacketIncoming(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

CMD:tungui(playerid, params[])
{
    #pragma unused params
    return HornStyle_OpenGUI(playerid);
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

stock HornTune_ColorStringToARGB(const color_string[])
{
    new rgba = 0xFFFFFFFF;
    if(color_string[0] != EOS)
    {
        sscanf(color_string, "h", rgba);
        if(strlen(color_string) <= 6) rgba = (rgba << 8) | 0xFF;
    }
    return RGBA_to_ARGB(rgba);
}

stock HornTune_ApplyVehiclePaintForPlayer(playerid, vehicleid)
{
    new body_colors[2], wheel_colors[2];

    body_colors[0] = HornTune_ColorStringToARGB(vInfo[vehicleid][viColorBody]);
    body_colors[1] = body_colors[0];
    wheel_colors[0] = HornTune_ColorStringToARGB(vInfo[vehicleid][viColorWheels]);
    wheel_colors[1] = wheel_colors[0];

    SetVehicleColorForPlayer(playerid, vehicleid, body_colors, wheel_colors);
    return 1;
}

stock HornTune_ApplyVehiclePaint(vehicleid)
{
    new body_colors[2], wheel_colors[2];

    body_colors[0] = HornTune_ColorStringToARGB(vInfo[vehicleid][viColorBody]);
    body_colors[1] = body_colors[0];
    wheel_colors[0] = HornTune_ColorStringToARGB(vInfo[vehicleid][viColorWheels]);
    wheel_colors[1] = wheel_colors[0];

    SetVehicleColor(vehicleid, body_colors, wheel_colors, 1);
    return 1;
}

stock HornTune_IsDonateItem(detal_id)
{
    // To keep the tech center purchase flow stable, regular parts use cash.
    // Only the special donor-only item stays on BC.
    switch(detal_id)
    {
        case 32: return 1;
    }
    return 0;
}

stock HornTune_TakeMoney(playerid, price, donate_item)
{
    if(price <= 0) return 0;
    if(donate_item)
    {
        if(GetPlayerDonateRub(playerid) < price) return 0;
        GivePlayerDonateRub(playerid, -price, " tech/style tuning", true, true);
        return 1;
    }
    if(GetPlayerMoneyEx(playerid) < price) return 0;
    GivePlayerMoneyEx(playerid, -price);
    return 1;
}

// ===== Tech Center =====

#if !defined VF_SPORTA
    #define VF_SPORTA      (1)
    #define VF_DRIFTA      (2)
    #define VF_COMFORTA    (4)
    #define VF_SPORTPLUSA  (8)
#endif

new HornTechActiveFlags[MAX_OWNABLE_CARS];

stock bool:VehGetFlag(playerid, slot, flag)
{
    #pragma unused playerid
    if(slot < 0 || slot >= MAX_OWNABLE_CARS) return false;
    return bool:((HornTechActiveFlags[slot] & flag) != 0);
}

stock VehSetFlag(playerid, slot, flag, bool:value)
{
    #pragma unused playerid
    if(slot < 0 || slot >= MAX_OWNABLE_CARS) return 0;
    if(value) HornTechActiveFlags[slot] |= flag;
    else HornTechActiveFlags[slot] &= ~flag;
    return 1;
}

stock bool:VehToggleFlag(playerid, slot, flag)
{
    #pragma unused playerid
    if(slot < 0 || slot >= MAX_OWNABLE_CARS) return false;
    HornTechActiveFlags[slot] ^= flag;
    return bool:((HornTechActiveFlags[slot] & flag) != 0);
}

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

stock IsFirmwareInstalled(value)
{
    return IsPartInstalled(value, 6);
}

stock BuyPart(playerid, vehicleid, detal_id)
{
    new slot = HornGetVehicleIndex(vehicleid);
    if(slot == -1) return 0;

    new type, part_num, add_val, current_val;

    switch(detal_id) {
        // COMFORT (ID: 4, 9, 14, 19, 24, 200=firmware)
        case 4:   { type = 3; part_num = 1; add_val = 1; }
        case 9:   { type = 3; part_num = 2; add_val = 20; }
        case 14:  { type = 3; part_num = 3; add_val = 300; }
        case 19:  { type = 3; part_num = 4; add_val = 4000; }
        case 24:  { type = 3; part_num = 5; add_val = 50000; }
        case 200: { type = 3; part_num = 6; add_val = 600000; }
        // SPORT (ID: 5, 10, 15, 20, 25, 201=firmware)
        case 5:   { type = 1; part_num = 1; add_val = 1; }
        case 10:  { type = 1; part_num = 2; add_val = 20; }
        case 15:  { type = 1; part_num = 3; add_val = 300; }
        case 20:  { type = 1; part_num = 4; add_val = 4000; }
        case 25:  { type = 1; part_num = 5; add_val = 50000; }
        case 201: { type = 1; part_num = 6; add_val = 600000; }
        // DRIFT (ID: 6, 11, 16, 21, 26, 202=firmware)
        case 6:   { type = 2; part_num = 1; add_val = 1; }
        case 11:  { type = 2; part_num = 2; add_val = 20; }
        case 16:  { type = 2; part_num = 3; add_val = 300; }
        case 21:  { type = 2; part_num = 4; add_val = 4000; }
        case 26:  { type = 2; part_num = 5; add_val = 50000; }
        case 202: { type = 2; part_num = 6; add_val = 600000; }
        // SPORT PLUS (ID: 7, 12, 17, 22, 27, 203=firmware)
        case 7:   { type = 4; part_num = 1; add_val = 1; }
        case 12:  { type = 4; part_num = 2; add_val = 20; }
        case 17:  { type = 4; part_num = 3; add_val = 300; }
        case 22:  { type = 4; part_num = 4; add_val = 4000; }
        case 27:  { type = 4; part_num = 5; add_val = 50000; }
        case 203: { type = 4; part_num = 6; add_val = 600000; }
        case 0..2: { type = 5; part_num = detal_id; add_val = detal_id + 1; }

        default: return 0;
    }

    new col_name[20];
    if(type == 1) { current_val = HornTechSport[slot]; format(col_name, sizeof(col_name), "sport"); }
    else if(type == 2) { current_val = HornTechDrift[slot]; format(col_name, sizeof(col_name), "drift"); }
    else if(type == 3) { current_val = HornTechComfort[slot]; format(col_name, sizeof(col_name), "comfort"); }
    else if(type == 4) { current_val = HornTechSportPlus[slot]; format(col_name, sizeof(col_name), "sport_plus"); }
    else if(type == 5) { current_val = HornTechNitro[slot]; format(col_name, sizeof(col_name), "nitro"); }

    // part_nums per type: 1..5 = parts, 6 = firmware
    // type_part_map[type][part_num] = {part_num, add_val}
    // If client sends already-bought part_num, auto-advance to next unpurchased
    if(type != 5)
    {
        // auto-advance: find first missing part for this type
        new part_vals[7] = {0, 1, 20, 300, 4000, 50000, 600000};
        new found_next = 0;
        for(new p = 1; p <= 6; p++)
        {
            if(!IsPartInstalled(current_val, p))
            {
                part_num = p;
                add_val = part_vals[p];
                found_next = 1;
                break;
            }
        }
        if(!found_next) return 0; // all 6 parts already bought
        new new_val = current_val + add_val;
        if(type == 1) HornTechSport[slot] = new_val;
        else if(type == 2) HornTechDrift[slot] = new_val;
        else if(type == 3) HornTechComfort[slot] = new_val;
        else if(type == 4) HornTechSportPlus[slot] = new_val;
    }
    else
    {
        if(current_val == add_val) return 0;
        HornTechNitro[slot] = add_val;
    }

    new query[128];
    new save_val = add_val;
    if(type == 1) save_val = HornTechSport[slot];
    else if(type == 2) save_val = HornTechDrift[slot];
    else if(type == 3) save_val = HornTechComfort[slot];
    else if(type == 4) save_val = HornTechSportPlus[slot];

    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `%s`='%d' WHERE `id`='%d'", col_name, save_val, GetOwnableCarData(slot, OC_SQL_ID));
    mysql_tquery(mysql, query);

    // Auto-activate firmware when 6th component is purchased
    if(part_num == 6)
    {
        new fw_vehicleid = HornTune_GetVehicleForPlayer(playerid);
        if(IsValidVehicle(fw_vehicleid))
        {
            switch(type)
            {
                case 1: { SetVehicleAccelerationBR(fw_vehicleid, 35.0);  VehSetFlag(playerid, slot, VF_SPORTA,     true); SendClientMessage(playerid, 0x00FF00FF, "[TechCenter] Sport firmware activated!"); }
                case 2: { SetVehicleDriftMode(playerid, fw_vehicleid, true); VehSetFlag(playerid, slot, VF_DRIFTA, true); SendClientMessage(playerid, 0x00FF00FF, "[TechCenter] Drift firmware activated!"); }
                case 3: { SetVehicleAccelerationBR(fw_vehicleid, 31.8);  VehSetFlag(playerid, slot, VF_COMFORTA,  true); SendClientMessage(playerid, 0x00FF00FF, "[TechCenter] Comfort firmware activated!"); }
                case 4: { SetVehicleAccelerationBR(fw_vehicleid, 36.0);  VehSetFlag(playerid, slot, VF_SPORTPLUSA,true); SendClientMessage(playerid, 0x00FF00FF, "[TechCenter] Sport Plus firmware activated!"); }
            }
        }
    }

    return 1;
}

stock GetVehiclePriceByModel(modelid)
{
    new cost;
    if(GetVehicleJsonCostByModelId(modelid, cost)) return cost;
    return 0;
}

stock GetTuningPrice(gosCost, tuneId)
{
    new Float:percent;
    new addedValue;

    switch(tuneId)
    {
        case 0: { percent = 4.0; addedValue = 15000; }
        case 1: { percent = 7.0; addedValue = 15000; }
        case 2: { percent = 5.0; addedValue = 15000; }
        case 3: { percent = 0.005; addedValue = 20; }
        default: return 0;
    }
    return floatround((float(gosCost) * percent / 100.0) + float(addedValue));
}

stock GetNitroPrice(gosCost, nitroId)
{
    new Float:percent;
    switch(nitroId)
    {
        case 0: percent = 2.0;
        case 1: percent = 5.0;
        case 2: percent = 7.0;
        default: return 0;
    }
    return floatround((float(gosCost) * percent / 100.0) + 15000.0);
}


stock HornTune_ReadPacketInt(Node:JSONObject, const key[], &value)
{
    if(JSON_GetInt(JSONObject, key, value)) return 1;
    new tmp[64];
    if(JSON_GetString(JSONObject, key, tmp, sizeof(tmp)))
    {
        if(tmp[0] != EOS)
        {
            value = strval(tmp);
            return 1;
        }
    }
    return 0;
}

stock HornTune_ReadDetailId(Node:JSONObject, type)
{
    new detal_id = -1;

    // Different CEF builds send the selected tuning item under different keys.
    // JSON_GetInt alone is not enough here: some builds send numeric ids as strings.
    if(HornTune_ReadPacketInt(JSONObject, "p", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "d", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "v", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "id", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "i", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "r", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "a", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "b", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "q", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "x", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "item", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "detail", detal_id)) return detal_id;

    // Some CEF builds send selected element in s, while response uses s as success.
    new possible_s = -1;
    if(HornTune_ReadPacketInt(JSONObject, "s", possible_s) && possible_s > 1) return possible_s;

    // In type 12 packets m is selector_id, not item id.
    if(type != 12) HornTune_ReadPacketInt(JSONObject, "m", detal_id);
    return detal_id;
}

stock HornTune_FindVinylByName(const texture[])
{
    if(texture[0] == EOS) return -1;
    for(new i = 0; i < sizeof(VinylNames); i++)
    {
        if(VinylNames[i][0] == EOS) continue;
        if(!strcmp(VinylNames[i], texture, true)) return i;
    }
    return -1;
}

stock HornTune_SendBuyResult(playerid, Node:JSONObject, type, detal_id, success)
{
    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(JSONObject, "r", GetPlayerDonateRub(playerid));
    JSON_SetInt(JSONObject, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(JSONObject, "p", detal_id);
    JSON_SetInt(JSONObject, "d", detal_id);
    JSON_SetInt(JSONObject, "v", detal_id);
    JSON_SetInt(JSONObject, "id", detal_id);
    JSON_SetInt(JSONObject, "s", success);
    SendPacketToClient(playerid, 28, JSONObject);
    return 1;
}

stock HornTune_IsTechDetail(detal_id)
{
    switch(detal_id)
    {
        case 0, 1, 2: return 1;
        case 4, 5, 6, 7: return 1;
        case 9, 10, 11, 12: return 1;
        case 14, 15, 16, 17: return 1;
        case 19, 20, 21, 22: return 1;
        case 24, 25, 26, 27: return 1;
        case 28, 29, 30, 31, 32, 130: return 1;
        case 300: return 1; // launch control
    }
    return 0;
}

public PacketIncomingTuning(playerid, Node:JSONObject)
{
    new type = -1;
    JSON_GetInt(JSONObject, "t", type);

    new original_type = type;
    new center_mode = GetPVarInt(playerid, "HornTuneCenterMode");
    if(center_mode == 0 && GetPVarInt(playerid, "StyleTuningCenter") == 1) center_mode = 1;

    if(type == 0)
    {
        HornTune_ReturnFromGUI(playerid);
        DeletePVar(playerid, "HornTuneCenterMode");
        JSON_SetInt(JSONObject, "t", 0);
        JSON_SetInt(JSONObject, "s", 1);
        JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
        JSON_SetInt(JSONObject, "r", GetPlayerDonateRub(playerid));
        JSON_SetInt(JSONObject, "bc", GetPlayerDonateRub(playerid));
        SendPacketToClient(playerid, 28, JSONObject);
        return 1;
    }

    new detal_id = HornTune_ReadDetailId(JSONObject, type);
    if(detal_id < 0 && HornTune_IsTechDetail(type)) detal_id = type;
    if(detal_id < 0)
    {
        new alt_type = -1;
        if(HornTune_ReadPacketInt(JSONObject, "w", alt_type) && HornTune_IsTechDetail(alt_type)) detal_id = alt_type;
    }
    new vehicleid = HornTune_GetVehicleForPlayer(playerid);
    if(!IsValidVehicle(vehicleid)) return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);

    new model = GetVehicleModel(vehicleid);
    new base_price = GetVehiclePriceByModel(model);
    if(base_price <= 0) base_price = 1000000;

    new full_json_str[512];
    JSON_Stringify(JSONObject, full_json_str, sizeof(full_json_str));
    printf("[HORN_TUNE_BUY] player=%d type=%d detail=%d mode=%d JSON=%s", playerid, original_type, detal_id, center_mode, full_json_str);

    // Tech center. Some CEF builds send tech buy as t=5, others as t=7.
    // In tech GUI mode we also accept a known tech part id regardless of packet type.
    if((center_mode == 2 || type == 4 || type == 5 || type == 7 || type == 10 || type == 11) && HornTune_IsTechDetail(detal_id))
    {
        // Get the REAL next part to buy (BuyPart auto-advances)
        new real_part = -1;
        new check_val = 0;
        if(detal_id >= 4 && detal_id <= 7)   check_val = (detal_id==4||detal_id==9||detal_id==14||detal_id==19||detal_id==24) ? HornTechComfort[HornGetVehicleIndex(vehicleid)] : (detal_id==5||detal_id==10||detal_id==15||detal_id==20||detal_id==25) ? HornTechSport[HornGetVehicleIndex(vehicleid)] : (detal_id==6||detal_id==11||detal_id==16||detal_id==21||detal_id==26) ? HornTechDrift[HornGetVehicleIndex(vehicleid)] : HornTechSportPlus[HornGetVehicleIndex(vehicleid)];
        // find next missing part 1..6
        if(detal_id >= 4 && detal_id <= 130 && detal_id != 28 && detal_id != 29 && detal_id != 30 && detal_id != 31 && detal_id != 32)
        {
            new cslot = HornGetVehicleIndex(vehicleid);
            new cval = 0;
            if(detal_id==4||detal_id==9||detal_id==14||detal_id==19||detal_id==24||detal_id==200) cval = HornTechComfort[cslot];
            else if(detal_id==5||detal_id==10||detal_id==15||detal_id==20||detal_id==25||detal_id==201) cval = HornTechSport[cslot];
            else if(detal_id==6||detal_id==11||detal_id==16||detal_id==21||detal_id==26||detal_id==202) cval = HornTechDrift[cslot];
            else if(detal_id==7||detal_id==12||detal_id==17||detal_id==22||detal_id==27||detal_id==203) cval = HornTechSportPlus[cslot];
            for(new p=1; p<=6; p++) { if(!IsPartInstalled(cval, p)) { real_part = p; break; } }
        }
        new price = 0;
        if(detal_id == 0 || detal_id == 1 || detal_id == 2) price = GetNitroPrice(base_price, detal_id);
        else if(detal_id == 300) price = GetUnivCost(base_price) * 2; // launch control price
        else if(detal_id == 28 || detal_id == 29 || detal_id == 30 || detal_id == 31) price = GetUnivCost(base_price);
        else if(detal_id == 32) price = GetDonatCost(base_price);
        else if(detal_id == 130) price = GetDalniyCost(base_price);
        else
        {
            // price by real_part (next unpurchased)
            new part_prices[7] = {0, 0, 1, 2, 3, 3, 3}; // tuning price index per part
            new tune_idx = (real_part >= 1 && real_part <= 6) ? part_prices[real_part] : 0;
            if(real_part == 6) price = GetUnivCost(base_price) * 3; // firmware costs 3x universal
            else price = GetTuningPrice(base_price, tune_idx);
            if(price <= 0)
            {
                printf("[HORN_TUNE_BUY_FAIL] player=%d reason=PRICE_ZERO_A detal_id=%d real_part=%d tune_idx=%d base_price=%d", playerid, detal_id, real_part, tune_idx, base_price);
                return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);
            }
        }
        if(price <= 0)
        {
            printf("[HORN_TUNE_BUY_FAIL] player=%d reason=PRICE_ZERO_B detal_id=%d base_price=%d", playerid, detal_id, base_price);
            return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);
        }

        new client_price = 0;
        if(HornTune_ReadPacketInt(JSONObject, "j", client_price) && client_price > 0 && client_price < base_price) price = client_price;

        new donate_item = HornTune_IsDonateItem(detal_id);
        printf("[HORN_TUNE_BUY_CHECK] player=%d detal_id=%d real_part=%d price=%d donate=%d money=%d donate_rub=%d", playerid, detal_id, real_part, price, donate_item, GetPlayerMoneyEx(playerid), GetPlayerDonateRub(playerid));
        if(donate_item)
        {
            if(GetPlayerDonateRub(playerid) < price)
            {
                printf("[HORN_TUNE_BUY_FAIL] player=%d reason=NOT_ENOUGH_DONATE price=%d donate_rub=%d", playerid, price, GetPlayerDonateRub(playerid));
                return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);
            }
        }
        else
        {
            if(GetPlayerMoneyEx(playerid) < price)
            {
                printf("[HORN_TUNE_BUY_FAIL] player=%d reason=NOT_ENOUGH_MONEY price=%d money=%d", playerid, price, GetPlayerMoneyEx(playerid));
                return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);
            }
        }

        switch(detal_id)
        {
            case 0, 1, 2:
            {
                if(!BuyPart(playerid, vehicleid, detal_id))
                {
                    printf("[HORN_TUNE_BUY_FAIL] player=%d reason=BUYPART_NITRO_FAILED detal_id=%d", playerid, detal_id);
                    return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);
                }
                // Give nitro physically + save to vInfo
                new nitro_comp = 0;
                switch(detal_id)
                {
                    case 0: { nitro_comp = 1009; vInfo[vehicleid][viNitro] = 1; }
                    case 1: { nitro_comp = 1008; vInfo[vehicleid][viNitro] = 2; }
                    case 2: { nitro_comp = 1010; vInfo[vehicleid][viNitro] = 3; }
                }
                AddVehicleComponent(vehicleid, nitro_comp);
                SaveVehicleTuning(vehicleid);
                SendClientMessage(playerid, 0x00FF00FF, "[TechCenter] Nitro installed!");
            }
            case 300: // Launch Control
            {
                if(vInfo[vehicleid][viLaunchControl] > 0) return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);
                vInfo[vehicleid][viLaunchControl] = 1;
                SetVehicleLaunchControl(vehicleid, 1, 1);
                SaveVehicleTuning(vehicleid);
                SendClientMessage(playerid, 0x00FF00FF, "[TechCenter] Launch Control installed!");
            }
            case 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 16, 17, 19, 20, 21, 22, 24, 25, 26, 27:
            {
                if(!BuyPart(playerid, vehicleid, detal_id))
                {
                    printf("[HORN_TUNE_BUY_FAIL] player=%d reason=BUYPART_TECH_FAILED detal_id=%d", playerid, detal_id);
                    return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);
                }
            }
            case 28, 29, 30, 31:
            {
                new strobLevel = detal_id - 27;
                vInfo[vehicleid][viStrob] = strobLevel;
                SetVehicleStroboscope(vehicleid, strobLevel, 1);
                SaveVehicleTuning(vehicleid);
            }
            case 32:
            {
                vInfo[vehicleid][viStrob] = 5;
                SetVehicleStroboscope(vehicleid, 5, 1);
                SaveVehicleTuning(vehicleid);
            }
            case 130:
            {
                vInfo[vehicleid][viHighLights] = 1;
                SetVehicleHighLight(vehicleid, 1, 1);
                SaveVehicleTuning(vehicleid);
            }
        }

        if(donate_item) GivePlayerDonateRub(playerid, -price, "tech tuning", true, true);
        else GivePlayerMoneyEx(playerid, -price, "tech tuning");

        return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 1);
    }

    // Vinyl.
    if(type == 3)
    {
        if(detal_id < 0 || detal_id >= sizeof(VinylNames) || VinylNames[detal_id][0] == EOS)
        {
            new vinyl_texture[64];
            if(JSON_GetString(JSONObject, "v", vinyl_texture, sizeof(vinyl_texture))) detal_id = HornTune_FindVinylByName(vinyl_texture);
        }
        if(detal_id < 0 || detal_id >= sizeof(VinylNames)) return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);
        if(VinylNames[detal_id][0] == EOS) return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);

        new price = GetUnivCost(base_price);
        new client_price = 0;
        if(HornTune_ReadPacketInt(JSONObject, "j", client_price) && client_price > 0 && client_price < base_price) price = client_price;
        if(!HornTune_TakeMoney(playerid, price, 0)) return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);

        vInfo[vehicleid][viVinyl] = detal_id;
        format(vInfo[vehicleid][viVinylTexture], 16, "%s", VinylNames[detal_id]);
        SetVehicleVinyl(vehicleid, VinylNames[detal_id], 1);
        SaveVehicleTuning(vehicleid);

        JSON_SetInt(JSONObject, "t", original_type);
        JSON_SetInt(JSONObject, "p", detal_id);
        JSON_SetInt(JSONObject, "d", detal_id);
        JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
        JSON_SetInt(JSONObject, "r", GetPlayerDonateRub(playerid));
        JSON_SetInt(JSONObject, "bc", GetPlayerDonateRub(playerid));
        JSON_SetInt(JSONObject, "s", 1);
        SendPacketToClient(playerid, 28, JSONObject);
        return 1;
    }

    // Paint / toner / light / neon.
    if(type == 1)
    {
        new color_type = -1;
        new color[32];
        new color_val = 0;

        if(!HornTune_ReadPacketInt(JSONObject, "ct", color_type))
        {
            if(!HornTune_ReadPacketInt(JSONObject, "m", color_type))
            {
                if(!HornTune_ReadPacketInt(JSONObject, "p", color_type))
                {
                    HornTune_ReadPacketInt(JSONObject, "id", color_type);
                }
            }
        }

        if(!JSON_GetString(JSONObject, "d", color, sizeof(color)))
        {
            if(!JSON_GetString(JSONObject, "c", color, sizeof(color))) JSON_GetString(JSONObject, "v", color, sizeof(color));
        }

        if(strlen(color) > 0) sscanf(color, "h", color_val);
        else
        {
            color_val = detal_id;
            format(color, sizeof(color), "%08X", color_val);
        }

        new price = 0;
        switch(color_type)
        {
            case 0, 1, 2: price = GetBodyPaintCost(base_price);
            case 3, 4: price = GetExtraCost(base_price);
            case 10: price = GetDoubleCost(base_price);
            case 11, 12, 13: price = GetUnivCost(base_price);
            default:
            {
                printf("[HORN_TUNE_BUY_FAIL] player=%d reason=UNKNOWN_COLOR_TYPE color_type=%d detal_id=%d color=%s", playerid, color_type, detal_id, color);
                return HornTune_SendBuyResult(playerid, JSONObject, original_type, color_type, 0);
            }
        }

        new client_price = 0;
        if(HornTune_ReadPacketInt(JSONObject, "j", client_price) && client_price > 0 && client_price < base_price) price = client_price;
        printf("[HORN_TUNE_BUY_CHECK] player=%d color_type=%d price=%d money=%d", playerid, color_type, price, GetPlayerMoneyEx(playerid));
        if(!HornTune_TakeMoney(playerid, price, 0))
        {
            printf("[HORN_TUNE_BUY_FAIL] player=%d reason=NOT_ENOUGH_MONEY price=%d money=%d", playerid, price, GetPlayerMoneyEx(playerid));
            return HornTune_SendBuyResult(playerid, JSONObject, original_type, color_type, 0);
        }

        switch(color_type)
        {
            case 0, 3:
            {
                format(vInfo[vehicleid][viColorBody], 16, "%s", color);
                if(vInfo[vehicleid][viColorWheels][0] == EOS) format(vInfo[vehicleid][viColorWheels], 16, "FFFFFFFF");
                HornTune_ApplyVehiclePaint(vehicleid);
            }
            case 1, 2:
            {
                format(vInfo[vehicleid][viColorWheels], 16, "%s", color);
                if(vInfo[vehicleid][viColorBody][0] == EOS) format(vInfo[vehicleid][viColorBody], 16, "FFFFFFFF");
                HornTune_ApplyVehiclePaint(vehicleid);
            }
            case 4:
            {
                vInfo[vehicleid][viTonerRear] = color_val;
                SetVehicleTonerRPC(vehicleid, vInfo[vehicleid][viTonerFront], vInfo[vehicleid][viTonerRear], vInfo[vehicleid][viTonerFrontSide], vInfo[vehicleid][viTonerRearSide], 1);
            }
            case 10:
            {
                vInfo[vehicleid][viLightColor] = color_val;
                SetVehicleHighLight(vehicleid, color_val, 1);
            }
            case 11:
            {
                vInfo[vehicleid][viNeon1] = color_val;
                SetVehicleNeon(vehicleid, vInfo[vehicleid][viNeon1], vInfo[vehicleid][viNeon2], vInfo[vehicleid][viNeon3], 1);
            }
            case 12:
            {
                vInfo[vehicleid][viNeon2] = color_val;
                SetVehicleNeon(vehicleid, vInfo[vehicleid][viNeon1], vInfo[vehicleid][viNeon2], vInfo[vehicleid][viNeon3], 1);
            }
            case 13:
            {
                vInfo[vehicleid][viNeon3] = color_val;
                SetVehicleNeon(vehicleid, vInfo[vehicleid][viNeon1], vInfo[vehicleid][viNeon2], vInfo[vehicleid][viNeon3], 1);
            }
        }

        SaveVehicleTuning(vehicleid);
        JSON_SetInt(JSONObject, "t", original_type);
        JSON_SetInt(JSONObject, "p", color_type);
        JSON_SetInt(JSONObject, "d", detal_id);
        JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
        JSON_SetInt(JSONObject, "r", GetPlayerDonateRub(playerid));
        JSON_SetInt(JSONObject, "bc", GetPlayerDonateRub(playerid));
        JSON_SetInt(JSONObject, "s", 1);
        SendPacketToClient(playerid, 28, JSONObject);
        return 1;
    }

    // Suspension / wheels / style numeric controls.
    if(type == 12 || (type >= 20 && type <= 30))
    {
        new selector_id = type;
        new data_value = detal_id;
        new price = 0;

        if(type == 12)
        {
            HornTune_ReadPacketInt(JSONObject, "m", selector_id);
            if(!HornTune_ReadPacketInt(JSONObject, "d", data_value))
            {
                if(!HornTune_ReadPacketInt(JSONObject, "p", data_value))
                {
                    if(!HornTune_ReadPacketInt(JSONObject, "v", data_value))
                    {
                        if(!HornTune_ReadPacketInt(JSONObject, "id", data_value))
                        {
                            HornTune_ReadPacketInt(JSONObject, "i", data_value);
                        }
                    }
                }
            }
        }
        else
        {
            data_value = 0;
            if(!HornTune_ReadPacketInt(JSONObject, "v", data_value))
            {
                if(!HornTune_ReadPacketInt(JSONObject, "d", data_value))
                {
                    if(!HornTune_ReadPacketInt(JSONObject, "p", data_value))
                    {
                        if(!HornTune_ReadPacketInt(JSONObject, "id", data_value))
                        {
                            HornTune_ReadPacketInt(JSONObject, "m", data_value);
                        }
                    }
                }
            }
        }

        switch(selector_id)
        {
            case 20, 30: price = (base_price / 200) + 5000;
            case 21, 28: price = (base_price / 200) + 8000;
            case 22, 29: price = (base_price / 200) + 8000;
            case 23, 24: price = (base_price / 200) + 7000;
            case 25, 26: price = (base_price / 200) + 6000;
            case 27: price = (base_price / 150) + 10000;
            default: return HornTune_SendBuyResult(playerid, JSONObject, original_type, data_value, 0);
        }

        new client_price = 0;
        if(HornTune_ReadPacketInt(JSONObject, "j", client_price) && client_price > 0 && client_price < base_price) price = client_price;
        if(!HornTune_TakeMoney(playerid, price, 0)) return HornTune_SendBuyResult(playerid, JSONObject, original_type, data_value, 0);

        switch(selector_id)
        {
            case 20, 30:
            {
                vInfo[vehicleid][viWheelSize] = data_value;
                SetVehicleWheelSizeRPC(vehicleid, data_value, 1);
            }
            case 21, 28:
            {
                vInfo[vehicleid][viWheelAddFront] = data_value;
                SetVehicleWheelAdditive(vehicleid, vInfo[vehicleid][viWheelAddFront], vInfo[vehicleid][viWheelAddRear], 1);
            }
            case 22, 29:
            {
                if(type == 12 && selector_id == 22)
                {
                    vInfo[vehicleid][viSuspensionForce] = data_value;
                    SetVehicleSuspensionForce(vehicleid, data_value, 1);
                }
                else
                {
                    vInfo[vehicleid][viWheelAddRear] = data_value;
                    SetVehicleWheelAdditive(vehicleid, vInfo[vehicleid][viWheelAddFront], vInfo[vehicleid][viWheelAddRear], 1);
                }
            }
            case 23:
            {
                vInfo[vehicleid][viSuspensionBias] = data_value;
                SetVehicleSuspensionBiasRPC(vehicleid, data_value, 1);
            }
            case 24:
            {
                SetVehicleWheelDeparture(vehicleid, data_value, 0, 1);
            }
            case 25:
            {
                SetVehicleWheelDeparture(vehicleid, 0, data_value, 1);
            }
            case 26:
            {
                SetVehicleWheelAlignment(vehicleid, data_value, 0, 1);
            }
            case 27:
            {
                SetVehicleClearance(vehicleid, data_value, 1);
            }
        }

        SaveVehicleTuning(vehicleid);
        JSON_SetInt(JSONObject, "t", original_type);
        JSON_SetInt(JSONObject, "p", data_value);
        JSON_SetInt(JSONObject, "d", data_value);
        JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
        JSON_SetInt(JSONObject, "r", GetPlayerDonateRub(playerid));
        JSON_SetInt(JSONObject, "bc", GetPlayerDonateRub(playerid));
        JSON_SetInt(JSONObject, "s", 1);
        SendPacketToClient(playerid, 28, JSONObject);
        return 1;
    }

    // Generic style-detail purchase fallback for CEF builds that send body/style parts as t=4/5/7.
    // It prevents the GUI from silently rejecting the buy action when the packet format differs.
    if(center_mode == 1 && (type == 4 || type == 5 || type == 7 || type == 10 || type == 11))
    {
        new price = GetUnivCost(base_price);
        new client_price = 0;
        if(HornTune_ReadPacketInt(JSONObject, "j", client_price) && client_price > 0) price = client_price;
        if(!HornTune_TakeMoney(playerid, price, 0)) return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);

        SaveVehicleTuning(vehicleid);
        return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 1);
    }

    // Preview/reset packets. Do not reject them, otherwise CEF can stop accepting buy responses.
    if(type == 2 || type == 6 || type == 18 || type == 19 || type == 23 || type == 26 || type == 27 || type == 28)
    {
        if(type == 19)
        {
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
        }
        if(type == 27) StyleTuning_ResetPreviewCamera(playerid);

        JSON_SetInt(JSONObject, "t", original_type);
        JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
        JSON_SetInt(JSONObject, "r", GetPlayerDonateRub(playerid));
        JSON_SetInt(JSONObject, "bc", GetPlayerDonateRub(playerid));
        JSON_SetInt(JSONObject, "s", 1);
        SendPacketToClient(playerid, 28, JSONObject);
        return 1;
    }

    // Last-resort buy acknowledgement for unknown CEF packet variants.
    // If the player is inside our tuning GUI and the packet contains a price, do not let the GUI silently fail.
    if(center_mode == 1 || center_mode == 2)
    {
        new client_price = 0;
        if(HornTune_ReadPacketInt(JSONObject, "j", client_price) && client_price > 0)
        {
            if(!HornTune_TakeMoney(playerid, client_price, 0)) return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);
            SaveVehicleTuning(vehicleid);
            return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 1);
        }
    }

    return HornTune_SendBuyResult(playerid, JSONObject, original_type, detal_id, 0);
}

stock HornTechStyle_OpenGUI(playerid)
{
    InStailing[playerid] = false;
    SetPVarInt(playerid, "HornTuneCenterMode", 2);
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!vehicleid) return SendClientMessage(playerid, -1, "{FF0000}    !");

    new slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if (slot == -1) return SendClientMessage(playerid, -1, "{FF0000}    !");

    HornTune_SaveReturn(playerid);
    new model = GetVehicleModel(vehicleid);
    new price = GetVehiclePriceByModel(model);
    if(price <= 0) price = 1000000;
    new Node:tuning_json = JSON_Object();
    new Node:k_array = JSON_Array(); 

    static const part_ids[4][5] = {
        {4, 9, 14, 19, 24},
        {5, 10, 15, 20, 25},
        {7, 12, 17, 22, 27},
        {6, 11, 16, 21, 26}
    };

    new part_values[4];
    part_values[0] = HornTechComfort[slot];
    part_values[1] = HornTechSport[slot];
    part_values[2] = HornTechSportPlus[slot];
    part_values[3] = HornTechDrift[slot];

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

    new nitro_val = HornTechNitro[slot];
    if(nitro_val >= 1 && nitro_val <= 3)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(nitro_val - 1)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }

    //    /   GUI ,   
    //     .    , ,  .
    if(vInfo[vehicleid][viStrob] >= 1 && vInfo[vehicleid][viStrob] <= 4)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(27 + vInfo[vehicleid][viStrob])));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }
    else if(vInfo[vehicleid][viStrob] == 5)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(32)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }
    if(vInfo[vehicleid][viHighLights] > 0)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(130)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }

    JSON_SetInt(tuning_json, "w", 3);
    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "t", 5); 
    JSON_SetInt(tuning_json, "j", price); 
    JSON_SetInt(tuning_json, "s", 5);
    JSON_SetArray(tuning_json, "k", k_array);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", GetVehicleNameByModel(model));
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(tuning_json, "r", GetPlayerDonateRub(playerid));
    SetPVarInt(playerid, "gui_variant", 3);

    new vw = playerid + 1000;
    SetPlayerVirtualWorld(playerid, vw);
    SetVehicleVirtualWorld(vehicleid, vw);
    SetPlayerInterior(playerid, 1);
    LinkVehicleToInterior(vehicleid, 1);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    SetVehiclePos(vehicleid, 996.1070, 999.4791, 1000.5);
    SetVehicleZAngle(vehicleid, -90.0);
    SetPlayerCameraPos(playerid, 1001.1626, 1002.8044, 1000.9689);
    SetPlayerCameraLookAt(playerid, 1000.3796, 1002.1858, 1001.0136);

    OnPacketIncoming(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

stock ShowTuneTest(playerid, value, const tune_name[])
{
    if(IsFullSetInstalled(value))
    {
        new msg[64];
        format(msg, sizeof(msg), "{00FF00}%s ", tune_name);
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
        format(msg, sizeof(msg), "{FF0000}%s  .  : %s", tune_name, missing);
        SendClientMessage(playerid, -1, msg);
    }
    return 1;
}

CMD:comforton(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1 || !IsFullSetInstalled(HornTechComfort[slot])) return 0;
    SetVehicleAccelerationBR(vehicleid, 31.8);
    VehSetFlag(playerid, slot, VF_COMFORTA, true);
    return 1;
}

CMD:comfortoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;
    SetVehicleAccelerationBR(vehicleid, 0.0);
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
    if(slot == -1 || !IsFullSetInstalled(HornTechSport[slot])) return 0;
    SetVehicleAccelerationBR(vehicleid, 35.0);
    VehSetFlag(playerid, slot, VF_SPORTA, true);
    return 1;
}

CMD:sportoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;
    SetVehicleAccelerationBR(vehicleid, 0.0);
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
    if(slot == -1 || !IsFullSetInstalled(HornTechSportPlus[slot])) return 0;
    SetVehicleAccelerationBR(vehicleid, 36.0);
    VehSetFlag(playerid, slot, VF_SPORTPLUSA, true);
    return 1;
}

CMD:sportplusoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;
    SetVehicleAccelerationBR(vehicleid, 0.0);
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
    if(slot == -1 || !IsFullSetInstalled(HornTechDrift[slot])) return 0;
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
    SetVehicleAccelerationBR(vehicleid, 0.0);
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

stock GetPlayerVehicleSlot(playerid, vehicleid)
{
    #pragma unused playerid
    return HornGetVehicleIndex(vehicleid);
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



CMD:techcentergui(playerid, params[])
{
    #pragma unused params
    return HornTechStyle_OpenGUI(playerid);
}

// ===== Compatibility API for kirill.pwn calls =====
stock HornTechStyle_DBInit()
{
    if(!mysql) return 1;
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `comfort` INT NOT NULL DEFAULT 0");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `sport` INT NOT NULL DEFAULT 0");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `drift` INT NOT NULL DEFAULT 0");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `sport_plus` INT NOT NULL DEFAULT 0");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `nitro` INT NOT NULL DEFAULT 0");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `tuning_vinyl_texture` VARCHAR(32) NOT NULL DEFAULT ''");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `tuning_body_color` VARCHAR(16) NOT NULL DEFAULT 'FFFFFF'");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `tuning_disk_color` VARCHAR(16) NOT NULL DEFAULT 'FFFFFF'");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `tuning_light_color` INT NOT NULL DEFAULT 0");
    mysql_tquery(mysql, "ALTER TABLE `ownable_cars` ADD COLUMN IF NOT EXISTS `tuning_high_lights` INT NOT NULL DEFAULT 0");
    return 1;
}

stock HornTechStyle_CreateLabels()
{
    return 1;
}

stock HornTechStyle_TryOpenByHorn(playerid)
{
    new bool:nearTechCenter = false;
    new bool:nearStyleCenter = false;

    if(IsPlayerInRangeOfPoint(playerid, 9.0, -426.235290, 1005.412658, 14.800000) ||
       IsPlayerInRangeOfPoint(playerid, 9.0, -420.054534, 1005.409240, 14.800000) ||
       IsPlayerInRangeOfPoint(playerid, 9.0, -413.549285, 1005.543029, 14.800000) ||
       IsPlayerInRangeOfPoint(playerid, 9.0, g_TuningEnter2[0][0], g_TuningEnter2[0][1], g_TuningEnter2[0][2]) ||
       IsPlayerInRangeOfPoint(playerid, 9.0, g_TuningEnter2[1][0], g_TuningEnter2[1][1], g_TuningEnter2[1][2]) ||
       IsPlayerInRangeOfPoint(playerid, 9.0, g_TuningEnter2[2][0], g_TuningEnter2[2][1], g_TuningEnter2[2][2]))
    {
        nearTechCenter = true;
    }

    if(IsPlayerInRangeOfPoint(playerid, 9.0, 2311.418945, -2607.487304, 21.808467) ||
       IsPlayerInRangeOfPoint(playerid, 9.0, 2311.424804, -2613.460937, 21.808467) ||
       IsPlayerInRangeOfPoint(playerid, 9.0, 2311.318603, -2619.407470, 21.808467) ||
       IsPlayerInRangeOfPoint(playerid, 9.0, g_TuningEnter[0][0], g_TuningEnter[0][1], g_TuningEnter[0][2]) ||
       IsPlayerInRangeOfPoint(playerid, 9.0, g_TuningEnter[1][0], g_TuningEnter[1][1], g_TuningEnter[1][2]) ||
       IsPlayerInRangeOfPoint(playerid, 9.0, g_TuningEnter[2][0], g_TuningEnter[2][1], g_TuningEnter[2][2]))
    {
        nearStyleCenter = true;
    }

    if(!nearTechCenter && !nearStyleCenter) return 0;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid)
    {
        SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}     ");
        return 1;
    }

    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}     ");
        return 1;
    }

    if(GetPlayerVehicleSlot(playerid, vehicleid) == -1)
    {
        SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}       ");
        return 1;
    }

    if(nearTechCenter) return HornTechStyle_OpenGUI(playerid);
    if(nearStyleCenter) return HornStyle_OpenGUI(playerid);
    return 0;
}

stock ShowTuningStylingGUI(playerid)
{
    return HornStyle_OpenGUI(playerid);
}

stock TechStyle_LoadFromCache(vehicleid)
{
    new slot = HornGetVehicleIndex(vehicleid);
    if(slot == -1) return 0;
    if(cache_num_rows() <= 0) return 0;

    HornTechComfort[slot] = cache_get_field_content_int(0, "comfort");
    HornTechSport[slot] = cache_get_field_content_int(0, "sport");
    HornTechDrift[slot] = cache_get_field_content_int(0, "drift");
    HornTechSportPlus[slot] = cache_get_field_content_int(0, "sport_plus");
    HornTechNitro[slot] = cache_get_field_content_int(0, "nitro");
    return 1;
}

// ===== /tuning command: 3-item root menu (Shinka / Tech / Style) =====
// Opens the same GUIs as CMD:techcentergui / CMD:tungui, just reachable
// from anywhere via a dialog instead of standing at a physical center.

stock TuningMenu_CanOpen(playerid, &vehicleid)
{
    vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid || vehicleid == INVALID_VEHICLE_ID)
    {
        SendClientMessage(playerid, -1, "{FFFF00}[Тюнинг] {FFFFFF}Вы должны находиться в транспортном средстве.");
        return 0;
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        SendClientMessage(playerid, -1, "{FFFF00}[Тюнинг] {FFFFFF}Вы должны находиться за рулём.");
        return 0;
    }
    if(GetPlayerVehicleSlot(playerid, vehicleid) == -1)
    {
        SendClientMessage(playerid, -1, "{FFFF00}[Тюнинг] {FFFFFF}Тюнинг доступен только для вашего личного транспорта.");
        return 0;
    }
    return 1;
}

CMD:tuning(playerid, params[])
{
    #pragma unused params
    new vehicleid;
    if(!TuningMenu_CanOpen(playerid, vehicleid)) return 1;

    Dialog
    (
        playerid, DIALOG_TUNING_MENU, DIALOG_STYLE_LIST,
        "{FF5252}Тюнинг",
        "Шинка\n"\
        "Тех\n"\
        "Стайл",
        "Выбрать", "Отмена"
    );
    return 1;
}

stock HornFull_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == DIALOG_TUNING_MENU)
    {
        if(!response) return 1;

        new vehicleid;
        if(!TuningMenu_CanOpen(playerid, vehicleid)) return 1;

        switch(listitem)
        {
            case 0: // Шинка (шины / диски / развал / клиренс — открывается в общем окне стиля)
            {
                SendClientMessage(playerid, -1, "{FFFF00}[Тюнинг] {FFFFFF}Открываю раздел «Шины» в окне стайлинга.");
                HornStyle_OpenGUI(playerid);
            }
            case 1: // Тех (нитро x2/x5/x10, спорт/спорт+/комфорт/дрифт, лаунч-контроль)
            {
                HornTechStyle_OpenGUI(playerid);
            }
            case 2: // Стайл (покраска кузова/дисков, тонировка, неон, винил)
            {
                HornStyle_OpenGUI(playerid);
            }
        }
        return 1;
    }

    return 0;
}
