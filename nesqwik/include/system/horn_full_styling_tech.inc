// Tech Center + Style Center transferred from mod_kak_mode_shinka(3).zip
// Added by ChatGPT merge helper.

#if !defined MAX_PLAYERS
    #error MAX_PLAYERS is not defined before horn_full_styling_tech.inc
#endif

#include <sile/vehicle_names_map>
#include <sile/vehicle_prices_map>


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
    JSON_SetInt(tuning_json, "t", 0);
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
    JSON_SetInt(tuning_json, "d", GetPlayerDonateRub(playerid));
    JSON_SetInt(tuning_json, "bc", GetPlayerDonateRub(playerid));
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

stock BuyPart(playerid, vehicleid, detal_id)
{
    new slot = HornGetVehicleIndex(vehicleid);
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
    if(type == 1) { current_val = HornTechSport[slot]; format(col_name, sizeof(col_name), "sport"); }
    else if(type == 2) { current_val = HornTechDrift[slot]; format(col_name, sizeof(col_name), "drift"); }
    else if(type == 3) { current_val = HornTechComfort[slot]; format(col_name, sizeof(col_name), "comfort"); }
    else if(type == 4) { current_val = HornTechSportPlus[slot]; format(col_name, sizeof(col_name), "sport_plus"); }
    else if(type == 5) { current_val = HornTechNitro[slot]; format(col_name, sizeof(col_name), "nitro"); }

    if(type == 5) {
        if(current_val == add_val) {
            return 0;
        }
        HornTechNitro[slot] = add_val;
    }
    else {
        if(IsPartInstalled(current_val, part_num)) {
            return 0;
        }
        new new_val = current_val + add_val;
        if(type == 1) HornTechSport[slot] = new_val;
        else if(type == 2) HornTechDrift[slot] = new_val;
        else if(type == 3) HornTechComfort[slot] = new_val;
        else if(type == 4) HornTechSportPlus[slot] = new_val;
    }

    new query[128];
    new save_val = add_val;
    if(type == 1) save_val = HornTechSport[slot];
    else if(type == 2) save_val = HornTechDrift[slot];
    else if(type == 3) save_val = HornTechComfort[slot];
    else if(type == 4) save_val = HornTechSportPlus[slot];

    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `%s`='%d' WHERE `id`='%d'", col_name, save_val, GetOwnableCarData(slot, OC_SQL_ID));
    mysql_tquery(mysql, query);
    
    return 1;
}


stock HornTune_GetStrobRpcType(strob_value)
{
    // Stored values:
    // 1..4  - normal strobes, RPC 0..3
    // 6     - donor strobe, RPC 5
    // 0     - not installed
    if(strob_value >= 1 && strob_value <= 4) return strob_value - 1;
    if(strob_value >= 6) return 5;
    return 5;
}

stock HornTune_ApplyTechToVehicle(vehicleid)
{
    new slot = HornGetVehicleIndex(vehicleid);
    if(slot == -1) return 0;

    new nitro_value = HornTechNitro[slot];
    if(nitro_value <= 0 && vInfo[vehicleid][viNitro] > 0) nitro_value = vInfo[vehicleid][viNitro];
    switch(nitro_value)
    {
        case 1: AddVehicleComponent(vehicleid, 1009);
        case 2: AddVehicleComponent(vehicleid, 1008);
        case 3: AddVehicleComponent(vehicleid, 1010);
    }

    if(vInfo[vehicleid][viHighLights] > 0)
    {
        SetVehicleHighLight(vehicleid, vInfo[vehicleid][viHighLights], 0);
    }

    if(vInfo[vehicleid][viStrob] > 0)
    {
        SetVehicleStroboscope(vehicleid, HornTune_GetStrobRpcType(vInfo[vehicleid][viStrob]), 0);
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
    /* Incoming field p is player id in this client, not detail id. */
    if(HornTune_ReadPacketInt(JSONObject, "d", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "v", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "id", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "i", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "q", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "x", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "item", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "detail", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "detal", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "part", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "button", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "bid", detal_id)) return detal_id;
    if(HornTune_ReadPacketInt(JSONObject, "slot", detal_id)) return detal_id;

    // Some CEF builds send selected element in s, while response uses s as success.
    new possible_s = -1;
    if(HornTune_ReadPacketInt(JSONObject, "s", possible_s) && possible_s > 1) return possible_s;

    // Felix GUI often sends category in m and real selected detail in mt.
    // This was the reason the button visually clicked, but buy was rejected by the server.
    new mt_detail = -1;
    if(HornTune_ReadPacketInt(JSONObject, "mt", mt_detail) && mt_detail >= 0) return mt_detail;

    // Field m is selector/category in Felix GUI, not a real detail id.
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

    // Client GUI builds use different names for balances.
    // r/d are used by the original Felix GUI responses, while m/bc are used by the BR GUI header.
    JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(JSONObject, "r", GetPlayerMoneyEx(playerid));
    JSON_SetInt(JSONObject, "rub", GetPlayerMoneyEx(playerid));
    /* Do not overwrite field d here: Felix GUI uses d as purchased detail id. */
    JSON_SetInt(JSONObject, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(JSONObject, "donate", GetPlayerDonateRub(playerid));

    JSON_SetInt(JSONObject, "p", detal_id);
    JSON_SetInt(JSONObject, "v", detal_id);
    JSON_SetInt(JSONObject, "id", detal_id);
    JSON_SetInt(JSONObject, "detail", detal_id);
    JSON_SetInt(JSONObject, "item", detal_id);
    JSON_SetInt(JSONObject, "s", success);

    if(success && detal_id >= 0)
    {
        new Node:k_array = JSON_Array();
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(detal_id)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
        JSON_SetArray(JSONObject, "k", k_array);
    }

    SendPacketToClient(playerid, 28, JSONObject);
    return 1;
}

stock HornTune_IsTechPartAlreadyInstalled(playerid, vehicleid, detal_id)
{
    #pragma unused playerid
    new slot = HornGetVehicleIndex(vehicleid);
    if(slot == -1) return 0;

    switch(detal_id)
    {
        case 0, 1, 2: return (HornTechNitro[slot] == detal_id + 1);
        case 3: return (vInfo[vehicleid][viLaunchControl] > 0);
        case 4, 9, 14, 19, 24: return IsPartInstalled(HornTechComfort[slot], ((detal_id - 4) / 5) + 1);
        case 5, 10, 15, 20, 25: return IsPartInstalled(HornTechSport[slot], ((detal_id - 5) / 5) + 1);
        case 6, 11, 16, 21, 26: return IsPartInstalled(HornTechDrift[slot], ((detal_id - 6) / 5) + 1);
        case 7, 12, 17, 22, 27: return IsPartInstalled(HornTechSportPlus[slot], ((detal_id - 7) / 5) + 1);
        case 28, 29, 30, 31: return (vInfo[vehicleid][viStrob] == detal_id - 27);
        case 32: return (vInfo[vehicleid][viStrob] >= 6);
        case 130: return (vInfo[vehicleid][viHighLights] > 0);
    }
    return 0;
}


stock HornTune_IsTechDetail(detal_id)
{
    switch(detal_id)
    {
        case 0, 1, 2, 3: return 1;
        case 4, 5, 6, 7: return 1;
        case 9, 10, 11, 12: return 1;
        case 14, 15, 16, 17: return 1;
        case 19, 20, 21, 22: return 1;
        case 24, 25, 26, 27: return 1;
        case 28, 29, 30, 31, 32, 130: return 1;
    }
    return 0;
}



stock HornTune_GetTechBundleDetail(group, index)
{
    switch(group)
    {
        case 0: // Differential
        {
            switch(index)
            {
                case 0: return 6;
                case 1: return 11;
                case 2: return 16;
                case 3: return 21;
                case 4: return 26;
            }
        }
        case 1: // Brakes
        {
            switch(index)
            {
                case 0: return 4;
                case 1: return 9;
                case 2: return 14;
                case 3: return 19;
                case 4: return 24;
            }
        }
        case 2: // Turbo
        {
            switch(index)
            {
                case 0: return 7;
                case 1: return 12;
                case 2: return 17;
                case 3: return 22;
                case 4: return 27;
            }
        }
        case 3: // Engine
        {
            switch(index)
            {
                case 0: return 5;
                case 1: return 10;
                case 2: return 15;
                case 3: return 20;
                case 4: return 25;
            }
        }
        case 4: // Supercharger / special tech
        {
            switch(index)
            {
                case 0: return 2; // Nitro x10
                case 1: return 3; // Launch Control
            }
        }
    }
    return -1;
}

stock HornTune_DetectTechGroup(type, selector_id, data_value, mt_value)
{
    if(selector_id >= 0 && selector_id <= 4) return selector_id;
    if(mt_value >= 0 && mt_value <= 4) return mt_value;
    if((type == 5 || type == 6 || type == 11 || type == 28) && data_value >= 0 && data_value <= 4) return data_value;
    return -1;
}

stock HornTune_InstallTechDetailNoCharge(vehicleid, detail_id)
{
    if(!HornTune_IsTechDetail(detail_id)) return 0;

    switch(detail_id)
    {
        case 0, 1, 2:
        {
            BuyPart(INVALID_PLAYER_ID, vehicleid, detail_id);
            vInfo[vehicleid][viNitro] = detail_id + 1;
            switch(detail_id)
            {
                case 0: AddVehicleComponent(vehicleid, 1009);
                case 1: AddVehicleComponent(vehicleid, 1008);
                case 2: AddVehicleComponent(vehicleid, 1010);
            }
        }
        case 3:
        {
            vInfo[vehicleid][viLaunchControl] = 1;
            SetVehicleLaunchControl(vehicleid, 1, 1);
        }
        case 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 16, 17, 19, 20, 21, 22, 24, 25, 26, 27:
        {
            BuyPart(INVALID_PLAYER_ID, vehicleid, detail_id);
        }
        case 28, 29, 30, 31:
        {
            vInfo[vehicleid][viStrob] = detail_id - 27;
            vInfo[vehicleid][vStrob] = 1;
            SetVehicleStroboscope(vehicleid, HornTune_GetStrobRpcType(vInfo[vehicleid][viStrob]), 0);
        }
        case 32:
        {
            vInfo[vehicleid][viStrob] = 6;
            vInfo[vehicleid][vStrob] = 1;
            SetVehicleStroboscope(vehicleid, HornTune_GetStrobRpcType(vInfo[vehicleid][viStrob]), 0);
        }
        case 130:
        {
            vInfo[vehicleid][viHighLights] = 1;
            SetVehicleHighLight(vehicleid, 1, 1);
        }
    }
    return 1;
}

stock HornTune_AddInstalledTechStateToJson(vehicleid, Node:json)
{
    new Node:k_array = JSON_Array();
    new slot = HornGetVehicleIndex(vehicleid);

    if(slot != -1)
    {
        for(new group = 0; group <= 4; group++)
        {
            for(new i = 0; i < 5; i++)
            {
                new detail_id = HornTune_GetTechBundleDetail(group, i);
                if(detail_id < 0) continue;
                if(HornTune_IsTechPartAlreadyInstalled(INVALID_PLAYER_ID, vehicleid, detail_id))
                {
                    k_array = JSON_Append(k_array, JSON_Array(JSON_Int(detail_id)));
                    k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
                }
            }
        }
    }

    if(vInfo[vehicleid][viStrob] >= 1 && vInfo[vehicleid][viStrob] <= 4)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(27 + vInfo[vehicleid][viStrob])));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }
    else if(vInfo[vehicleid][viStrob] >= 6)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(32)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }
    if(vInfo[vehicleid][viHighLights] > 0)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(130)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }

    JSON_SetArray(json, "k", k_array);
    return 1;
}

stock HornTune_BuyTechBundle(playerid, vehicleid, group, Node:JSONObject, type, selector_id, mt_id)
{
    new total_price = 0;
    new buy_count = 0;
    new last_detail = -1;
    new model = GetVehicleModel(vehicleid);
    new base_price = GetVehiclePriceByModel(model);
    if(base_price <= 0) base_price = 1000000;

    new start_group = group;
    new end_group = group;
    if(group < 0 || group > 4)
    {
        start_group = 0;
        end_group = 4;
    }

    for(new g = start_group; g <= end_group; g++)
    {
        for(new i = 0; i < 5; i++)
        {
            new detail_id = HornTune_GetTechBundleDetail(g, i);
            if(detail_id < 0) continue;
            if(!HornTune_IsTechPartAlreadyInstalled(playerid, vehicleid, detail_id))
            {
                total_price += HornTune_GetTechDetailPrice(base_price, detail_id);
                buy_count++;
                last_detail = detail_id;
            }
        }
    }

    if(buy_count <= 0)
    {
        HornTune_ApplyTechToVehicle(vehicleid);
        return HornTune_Response(playerid, type, 1, selector_id, last_detail, mt_id, "", "");
    }

    if(!HornTune_TakeMoney(playerid, total_price, 0))
    {
        return HornTune_Response(playerid, type, 0, selector_id, last_detail, mt_id, "", "");
    }

    for(new g = start_group; g <= end_group; g++)
    {
        for(new i = 0; i < 5; i++)
        {
            new detail_id = HornTune_GetTechBundleDetail(g, i);
            if(detail_id < 0) continue;
            if(!HornTune_IsTechPartAlreadyInstalled(playerid, vehicleid, detail_id))
            {
                HornTune_InstallTechDetailNoCharge(vehicleid, detail_id);
            }
        }
    }

    HornTune_ApplyTechToVehicle(vehicleid);
    SaveVehicleTuning(vehicleid);
    printf("[FELIX_TUNING_BUY] player=%d vehicle=%d bundle_group=%d price=%d count=%d strob=%d", playerid, vehicleid, group, total_price, buy_count, vInfo[vehicleid][viStrob]);
    #pragma unused JSONObject
    return HornTune_Response(playerid, type, 1, selector_id, last_detail, mt_id, "", "");
}

stock HornTune_Response(playerid, type, success, selector_id, detail_id, mt_id, const color[], const vinyl[])
{
    new Node:resp = JSON_Object();

    JSON_SetInt(resp, "t", type);
    JSON_SetInt(resp, "s", success);

    // In GUI 28 field "m" is NOT a money balance in responses.
    // It is a selector/category id. Sending money here breaks Felix CEF clicks,
    // so balance goes only to r/rub/bc/d fields below.
    if(selector_id >= 0) JSON_SetInt(resp, "m", selector_id);

    if(detail_id >= 0)
    {
        JSON_SetInt(resp, "d", detail_id);
        JSON_SetInt(resp, "p", detail_id);
        JSON_SetInt(resp, "v", detail_id);
        JSON_SetInt(resp, "id", detail_id);
        JSON_SetInt(resp, "detail", detail_id);
        JSON_SetInt(resp, "item", detail_id);
    }

    if(mt_id >= 0) JSON_SetInt(resp, "mt", mt_id);

    // JSON_SetString in this build requires a mutable string buffer,
    // so const function arguments are copied before sending to GUI.
    if(color[0] != EOS)
    {
        new color_buffer[32];
        format(color_buffer, sizeof color_buffer, "%s", color);
        JSON_SetString(resp, "co", color_buffer, strlen(color_buffer));
    }
    if(vinyl[0] != EOS)
    {
        new vinyl_buffer[64];
        format(vinyl_buffer, sizeof vinyl_buffer, "%s", vinyl);
        JSON_SetString(resp, "v", vinyl_buffer, strlen(vinyl_buffer));
    }

    JSON_SetInt(resp, "r", GetPlayerMoneyEx(playerid));
    JSON_SetInt(resp, "rub", GetPlayerMoneyEx(playerid));
    JSON_SetInt(resp, "money", GetPlayerMoneyEx(playerid));
    /* Do not overwrite field d here: Felix GUI uses d as purchased detail id. */
    JSON_SetInt(resp, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(resp, "donate", GetPlayerDonateRub(playerid));

    if(success)
    {
        new vehicleid = HornTune_GetVehicleForPlayer(playerid);
        if(IsValidVehicle(vehicleid)) HornTune_AddInstalledTechStateToJson(vehicleid, resp);
    }

    OnPacketIncoming(playerid, 28, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock HornTune_GetPacketPrice(Node:JSONObject, fallback)
{
    new price = fallback;
    new client_price = 0;

    /*
        In Felix CEF field "j" is often the vehicle price, not item price.
        The old handler accepted it directly, so purchases could cost the whole car.
        Now client price is accepted only when it is close to the server-calculated fallback.
    */
    if(HornTune_ReadPacketInt(JSONObject, "j", client_price) && client_price > 0)
    {
        if(fallback > 0 && client_price <= fallback * 3)
        {
            price = client_price;
        }
    }
    if(price <= 0) price = 1000;
    return price;
}

stock HornTune_GetStageGroupByDetail(detail_id)
{
    switch(detail_id)
    {
        case 4, 9, 14, 19, 24: return 0; // Comfort+
        case 5, 10, 15, 20, 25: return 1; // Sport
        case 7, 12, 17, 22, 27: return 2; // Sport+
        case 6, 11, 16, 21, 26: return 3; // Drift
    }
    return -1;
}

stock HornTune_GetStageTotalPrice(base_price, group)
{
    if(base_price <= 0) base_price = 1000000;
    switch(group)
    {
        case 0: return base_price * 6 / 100;
        case 1: return base_price * 12 / 100;
        case 2: return base_price * 24 / 100;
        case 3: return base_price * 5 / 100;
    }
    return 10000;
}

stock HornTune_GetTechDetailPrice(base_price, detail_id)
{
    if(base_price <= 0) base_price = 1000000;

    switch(detail_id)
    {
        case 0, 1, 2: return GetNitroPrice(base_price, detail_id);
        case 3: return GetTuningPrice(base_price, 3);
        case 28, 29, 30, 31: return 50000;
        case 32: return 300; // donor strobe, paid with BC
        case 130: return 75000;
    }

    new group = HornTune_GetStageGroupByDetail(detail_id);
    if(group != -1)
    {
        new part_price = HornTune_GetStageTotalPrice(base_price, group) / 5;
        if(part_price < 5000) part_price = 5000;
        return part_price;
    }
    return 1000;
}

stock HornTune_GetStylePrice(base_price, type, selector_id)
{
    if(base_price <= 0) base_price = 1000000;
    switch(type)
    {
        case 1, 2:
        {
            switch(selector_id)
            {
                case 10, 11, 12, 13: return GetExtraCost(base_price);
                default: return GetBodyPaintCost(base_price);
            }
        }
        case 3: return GetUnivCost(base_price);
        case 7, 10: return GetExtraCost(base_price);
        case 8: return GetExtraCost(base_price);
        case 12, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30: return GetExtraCost(base_price);
    }
    return 1000;
}

stock HornTune_BuyTechDetail(playerid, vehicleid, detail_id, price, Node:JSONObject, type, selector_id, mt_id)
{
    if(!HornTune_IsTechDetail(detail_id)) return HornTune_Response(playerid, type, 0, selector_id, detail_id, mt_id, "", "");

    // Do not charge twice if this detail is already installed. Just confirm it to GUI.
    if(HornTune_IsTechPartAlreadyInstalled(playerid, vehicleid, detail_id))
    {
        HornTune_ApplyTechToVehicle(vehicleid);
        return HornTune_Response(playerid, type, 1, selector_id, detail_id, mt_id, "", "");
    }

    new donate_item = HornTune_IsDonateItem(detail_id);
    if(!HornTune_TakeMoney(playerid, price, donate_item)) return HornTune_Response(playerid, type, 0, selector_id, detail_id, mt_id, "", "");

    switch(detail_id)
    {
        case 0, 1, 2:
        {
            BuyPart(playerid, vehicleid, detail_id);
            vInfo[vehicleid][viNitro] = detail_id + 1;
            switch(detail_id)
            {
                case 0: AddVehicleComponent(vehicleid, 1009);
                case 1: AddVehicleComponent(vehicleid, 1008);
                case 2: AddVehicleComponent(vehicleid, 1010);
            }
        }
        case 3:
        {
            vInfo[vehicleid][viLaunchControl] = 1;
            SetVehicleLaunchControl(vehicleid, 1, 1);
        }
        case 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 16, 17, 19, 20, 21, 22, 24, 25, 26, 27:
        {
            BuyPart(playerid, vehicleid, detail_id);
        }
        case 28, 29, 30, 31:
        {
            vInfo[vehicleid][viStrob] = detail_id - 27;
            vInfo[vehicleid][vStrob] = 1;
            SetVehicleStroboscope(vehicleid, HornTune_GetStrobRpcType(vInfo[vehicleid][viStrob]), 0);
        }
        case 32:
        {
            // Donor strobe is stored as 6, but RPC type is 5.
            // It is enabled immediately after purchase and also works from radial menu.
            vInfo[vehicleid][viStrob] = 6;
            vInfo[vehicleid][vStrob] = 1;
            SetVehicleStroboscope(vehicleid, HornTune_GetStrobRpcType(vInfo[vehicleid][viStrob]), 0);
        }
        case 130:
        {
            vInfo[vehicleid][viHighLights] = 1;
            SetVehicleHighLight(vehicleid, 1, 1);
        }
    }

    HornTune_ApplyTechToVehicle(vehicleid);
    SaveVehicleTuning(vehicleid);
    printf("[FELIX_TUNING_BUY] player=%d vehicle=%d detail=%d price=%d donate=%d strob=%d comfort=%d sport=%d drift=%d sport_plus=%d nitro=%d", playerid, vehicleid, detail_id, price, donate_item, vInfo[vehicleid][viStrob], HornTechComfort[HornGetVehicleIndex(vehicleid)], HornTechSport[HornGetVehicleIndex(vehicleid)], HornTechDrift[HornGetVehicleIndex(vehicleid)], HornTechSportPlus[HornGetVehicleIndex(vehicleid)], HornTechNitro[HornGetVehicleIndex(vehicleid)]);
    #pragma unused JSONObject
    return HornTune_Response(playerid, type, 1, selector_id, detail_id, mt_id, "", "");
}

stock HornTune_RememberTechDetail(playerid, detail_id)
{
    if(!HornTune_IsTechDetail(detail_id)) return 0;
    SetPVarInt(playerid, "HornTuneLastTechDetail", detail_id);
    SetPVarInt(playerid, "HornTuneLastTechDetailSet", 1);
    return 1;
}

stock HornTune_GetRememberedTechDetail(playerid)
{
    if(GetPVarInt(playerid, "HornTuneLastTechDetailSet") != 1) return -1;
    new detail_id = GetPVarInt(playerid, "HornTuneLastTechDetail");
    if(!HornTune_IsTechDetail(detail_id)) return -1;
    return detail_id;
}



// ===== KMonarch Style Center replacement =====
// Source: uploaded style.txt. The uploaded snippet was a raw case 28 block,
// so it is wrapped here as a safe packet handler and adapted to this mod's vInfo fields.

stock StyleCenterKMonarch_GetVehicle(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid != 0 && vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid)) return vehicleid;

    vehicleid = HornTuneReturnVeh[playerid];
    if(vehicleid != 0 && vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid)) return vehicleid;

    vehicleid = g_TuningReturnVehicle[playerid];
    if(vehicleid != 0 && vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid)) return vehicleid;

    return INVALID_VEHICLE_ID;
}

stock StyleCenterKMonarch_GetColor(Node:JSONObject, color[], color_size, &color_val)
{
    color[0] = EOS;
    JSON_GetString(JSONObject, "d", color, color_size);
    if(color[0] == EOS) JSON_GetString(JSONObject, "co", color, color_size);
    if(color[0] == EOS) JSON_GetString(JSONObject, "color", color, color_size);

    if(color[0] != EOS)
    {
        sscanf(color, "h", color_val);
    }
    else
    {
        if(!HornTune_ReadPacketInt(JSONObject, "d", color_val)) color_val = 0;
        if(color_val < 0) color_val = 0;
        format(color, color_size, "%06X", color_val);
    }
    return 1;
}

stock StyleCenterKMonarch_ReadDetail(Node:JSONObject, type)
{
    new d = -1, p = -1, v = -1, id = -1, mt = -1, item = -1;

    HornTune_ReadPacketInt(JSONObject, "d", d);
    HornTune_ReadPacketInt(JSONObject, "p", p);
    HornTune_ReadPacketInt(JSONObject, "v", v);
    HornTune_ReadPacketInt(JSONObject, "id", id);
    HornTune_ReadPacketInt(JSONObject, "mt", mt);
    HornTune_ReadPacketInt(JSONObject, "item", item);

    // Vinyl usually arrives in d. Do not overwrite it with p, because some CEF
    // builds send playerid/status in p.
    if(type == 3)
    {
        if(d >= 0 && d < sizeof(VinylNames)) return d;
        if(p >= 0 && p < sizeof(VinylNames)) return p;
        if(v >= 0 && v < sizeof(VinylNames)) return v;
        if(id >= 0 && id < sizeof(VinylNames)) return id;
        if(item >= 0 && item < sizeof(VinylNames)) return item;
        return d;
    }

    // Wheels/sounds/strobes in uploaded style.txt use p as detail id.
    if(type == 7 || type == 10)
    {
        if(p >= 0) return p;
        if(d >= 0) return d;
        if(v >= 0) return v;
        if(id >= 0) return id;
        if(mt >= 0) return mt;
        if(item >= 0) return item;
        return -1;
    }

    if(p >= 0) return p;
    if(d >= 0) return d;
    if(v >= 0) return v;
    if(id >= 0) return id;
    if(mt >= 0) return mt;
    if(item >= 0) return item;
    return -1;
}

stock StyleCenterKMonarch_Response(playerid, type, success, detail_id = -1, selector_id = -1)
{
    new Node:resp = JSON_Object();

    JSON_SetInt(resp, "t", type);
    JSON_SetInt(resp, "s", success);
    JSON_SetInt(resp, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(resp, "r", GetPlayerMoneyEx(playerid));
    JSON_SetInt(resp, "rub", GetPlayerMoneyEx(playerid));
    JSON_SetInt(resp, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(resp, "donate", GetPlayerDonateRub(playerid));

    if(selector_id >= 0) JSON_SetInt(resp, "ct", selector_id);

    if(detail_id >= 0)
    {
        JSON_SetInt(resp, "p", detail_id);
        JSON_SetInt(resp, "d", detail_id);
        JSON_SetInt(resp, "v", detail_id);
        JSON_SetInt(resp, "id", detail_id);
    }

    if(success && detail_id >= 0)
    {
        new Node:k_array = JSON_Array();
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(detail_id)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
        JSON_SetArray(resp, "k", k_array);
    }

    OnPacketIncoming(playerid, 28, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock StyleCenterKMonarch_TakeMoney(playerid, price)
{
    if(price <= 0) return 1;
    if(GetPlayerMoneyEx(playerid) < price) return 0;
    GivePlayerMoneyEx(playerid, -price);
    return 1;
}

stock StyleCenterKMonarch_Save(vehicleid)
{
    if(IsValidVehicle(vehicleid)) SaveVehicleTuning(vehicleid);
    return 1;
}

stock StyleCenterKMonarch_Close(playerid)
{
    new vehicleid = StyleCenterKMonarch_GetVehicle(playerid);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 0);
    JSON_SetInt(json, "s", 1);
    JSON_SetInt(json, "m", GetPlayerMoneyEx(playerid));
    OnPacketIncoming(playerid, 28, json);
    JSON_Cleanup(json);

    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, 1);

    new Float:exit_x = 2296.146240;
    new Float:exit_y = -2613.668457;
    new Float:exit_z = 21.829063;
    new Float:exit_a = 90.0;

    if(g_TuningType[playerid] == 1)
    {
        exit_x = 1742.453979;
        exit_y = 2465.383544;
        exit_z = 14.454860;
        exit_a = 285.0;
    }

    // V11 hard exit fix: always move BOTH player and vehicle out of interior.
    // Previous version only moved the vehicle when it was detected, so the player
    // could stay in interior 1 if GetPlayerVehicleID returned 0 after GUI close.
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    SetPlayerPos(playerid, exit_x, exit_y, exit_z);
    SetPlayerFacingAngle(playerid, exit_a);

    if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
    {
        SetVehicleVirtualWorld(vehicleid, 0);
        LinkVehicleToInterior(vehicleid, 0);
        SetVehiclePos(vehicleid, exit_x, exit_y, exit_z);
        SetVehicleZAngle(vehicleid, exit_a);
        PutPlayerInVehicle(playerid, vehicleid, 0);
    }

    DeletePVar(playerid, "HornTuneCenterMode");
    DeletePVar(playerid, "StyleTuningCenter");
    DeletePVar(playerid, "StyleTuningIgnoreClose");
    DeletePVar(playerid, "HornTuneLastTechDetail");
    DeletePVar(playerid, "HornTuneLastTechDetailSet");
    DeletePVar(playerid, "HornTuneLastTechGroup");
    DeletePVar(playerid, "HornTuneLastTechGroupSet");

    g_TuningType[playerid] = 0;
    InStailing[playerid] = false;
    HornTuneReturnVeh[playerid] = INVALID_VEHICLE_ID;
    g_TuningReturnVehicle[playerid] = INVALID_VEHICLE_ID;

    printf("[STYLE_V11] close player=%d veh=%d -> exterior", playerid, vehicleid);
    return 1;
}

stock StyleCenterKMonarch_Packet(playerid, Node:JSONObject)
{
    new type = -1, detail_id = -1, color_type = -1, status = 0;
    new color[32], color_val = 0;

    HornTune_ReadPacketInt(JSONObject, "t", type);
    HornTune_ReadPacketInt(JSONObject, "m", color_type);
    HornTune_ReadPacketInt(JSONObject, "s", status);
    detail_id = StyleCenterKMonarch_ReadDetail(JSONObject, type);
    StyleCenterKMonarch_GetColor(JSONObject, color, sizeof(color), color_val);

    static raw_packet[512];
    raw_packet[0] = EOS;
    JSON_Stringify(JSONObject, raw_packet, sizeof(raw_packet));
    printf("[STYLE_V11] packet 28: player=%d type=%d detail=%d color_type=%d color=%s raw=%s", playerid, type, detail_id, color_type, color, raw_packet);

    if(type == 0)
    {
        return StyleCenterKMonarch_Close(playerid);
    }

    new vehicleid = StyleCenterKMonarch_GetVehicle(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        return StyleCenterKMonarch_Response(playerid, type, 0, detail_id, color_type);
    }

    // Open/balance/preview/category packets. They must not charge money.
    switch(type)
    {
        case 5, 6, 9, 11, 12, 18, 19, 20, 23, 26, 27, 28:
        {
            return StyleCenterKMonarch_Response(playerid, type, 1, detail_id, color_type);
        }
    }

    new price = 50;

    switch(type)
    {
        case 1, 2:
        {
            if(!StyleCenterKMonarch_TakeMoney(playerid, price))
            {
                return StyleCenterKMonarch_Response(playerid, type, 0, detail_id, color_type);
            }

            switch(color_type)
            {
                case 0:
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
                case 3:
                {
                    vInfo[vehicleid][viTonerFront] = color_val;
                    vInfo[vehicleid][viTonerFrontSide] = color_val;
                    SetVehicleTonerRPC(vehicleid, vInfo[vehicleid][viTonerFront], vInfo[vehicleid][viTonerRear], vInfo[vehicleid][viTonerFrontSide], vInfo[vehicleid][viTonerRearSide], 1);
                }
                case 4:
                {
                    vInfo[vehicleid][viTonerRear] = color_val;
                    vInfo[vehicleid][viTonerRearSide] = color_val;
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
                default:
                {
                    ChangeVehicleColor(vehicleid, color_val, color_val);
                }
            }

            SaveVehicleTuning(vehicleid);
            SetPVarInt(playerid, "StyleTuningIgnoreClose", gettime() + 2);
            return StyleCenterKMonarch_Response(playerid, type, 1, detail_id, color_type);
        }
        case 3:
        {
            new vinyl_id = detail_id;
            if(vinyl_id < 0 || vinyl_id >= sizeof(VinylNames) || VinylNames[vinyl_id][0] == EOS)
            {
                return StyleCenterKMonarch_Response(playerid, 3, 0, detail_id, color_type);
            }

            if(!StyleCenterKMonarch_TakeMoney(playerid, price))
            {
                return StyleCenterKMonarch_Response(playerid, 3, 0, vinyl_id, color_type);
            }

            vInfo[vehicleid][viVinyl] = vinyl_id;
            format(vInfo[vehicleid][viVinylTexture], 16, "%s", VinylNames[vinyl_id]);
            SetVehicleVinyl(vehicleid, VinylNames[vinyl_id], 1);
            SaveVehicleTuning(vehicleid);
            SetPVarInt(playerid, "StyleTuningIgnoreClose", gettime() + 2);
            return StyleCenterKMonarch_Response(playerid, 3, 1, vinyl_id, color_type);
        }
        case 7, 10:
        {
            switch(detail_id)
            {
                case 99:
                {
                    if(!StyleCenterKMonarch_TakeMoney(playerid, price)) return StyleCenterKMonarch_Response(playerid, type, 0, detail_id, color_type);
                    new exhaust_id = 14;
                    vInfo[vehicleid][viExhaustSound] = exhaust_id;
                    SetVehicleExhaust(vehicleid, exhaust_id, 1);
                    SaveVehicleTuning(vehicleid);
                    return StyleCenterKMonarch_Response(playerid, type, 1, detail_id, color_type);
                }
                case 100, 101:
                {
                    if(!StyleCenterKMonarch_TakeMoney(playerid, price)) return StyleCenterKMonarch_Response(playerid, type, 0, detail_id, color_type);
                    new horn_id = (detail_id == 100) ? 15 : 16;
                    vInfo[vehicleid][viHornSound] = horn_id;
                    SetVehicleHornSound(vehicleid, horn_id, 1);
                    SaveVehicleTuning(vehicleid);
                    return StyleCenterKMonarch_Response(playerid, type, 1, detail_id, color_type);
                }
                case 29, 30, 31, 32:
                {
                    if(!StyleCenterKMonarch_TakeMoney(playerid, price)) return StyleCenterKMonarch_Response(playerid, type, 0, detail_id, color_type);
                    new strob_level = 32 - detail_id;
                    if(strob_level < 1) strob_level = 1;
                    if(strob_level > 4) strob_level = 4;
                    vInfo[vehicleid][viStrob] = strob_level;
                    SetVehicleStroboscope(vehicleid, strob_level, 1);
                    SaveVehicleTuning(vehicleid);
                    return StyleCenterKMonarch_Response(playerid, type, 1, detail_id, color_type);
                }
                default:
                {
                    // Wheel/component buttons can send the component id in d/p/v/id/mt.
                    if(detail_id > 0)
                    {
                        if(!StyleCenterKMonarch_TakeMoney(playerid, price)) return StyleCenterKMonarch_Response(playerid, type, 0, detail_id, color_type);
                        AddVehicleComponent(vehicleid, detail_id);
                        SaveVehicleTuning(vehicleid);
                        return StyleCenterKMonarch_Response(playerid, type, 1, detail_id, color_type);
                    }
                }
            }
            return StyleCenterKMonarch_Response(playerid, type, 0, detail_id, color_type);
        }
        case 8:
        {
            if(!StyleCenterKMonarch_TakeMoney(playerid, price)) return StyleCenterKMonarch_Response(playerid, type, 0, detail_id, color_type);
            vInfo[vehicleid][viNeon1] = color_val;
            vInfo[vehicleid][viNeon2] = color_val;
            vInfo[vehicleid][viNeon3] = color_val;
            SetVehicleNeon(vehicleid, color_val, color_val, color_val, 1);
            SaveVehicleTuning(vehicleid);
            return StyleCenterKMonarch_Response(playerid, type, 1, detail_id, color_type);
        }
        case 21..30:
        {
            if(!StyleCenterKMonarch_TakeMoney(playerid, price)) return StyleCenterKMonarch_Response(playerid, type, 0, detail_id, color_type);
            new value = detail_id;
            if(value < 0) value = color_type;
            if(value < 0) value = 0;

            switch(type)
            {
                case 21, 28:
                {
                    vInfo[vehicleid][viWheelAddFront] = value;
                    SetVehicleWheelAdditive(vehicleid, vInfo[vehicleid][viWheelAddFront], vInfo[vehicleid][viWheelAddRear], 1);
                }
                case 22, 29:
                {
                    vInfo[vehicleid][viWheelAddRear] = value;
                    SetVehicleWheelAdditive(vehicleid, vInfo[vehicleid][viWheelAddFront], vInfo[vehicleid][viWheelAddRear], 1);
                }
                case 23:
                {
                    vInfo[vehicleid][viSuspensionBias] = value;
                    SetVehicleSuspensionBiasRPC(vehicleid, value, 1);
                }
                case 24:
                {
                    SetVehicleWheelDeparture(vehicleid, value, 0, 1);
                }
                case 25:
                {
                    SetVehicleWheelDeparture(vehicleid, 0, value, 1);
                }
                case 26:
                {
                    SetVehicleWheelAlignment(vehicleid, value, 0, 1);
                }
                case 27:
                {
                    SetVehicleClearance(vehicleid, value, 1);
                }
                case 30:
                {
                    vInfo[vehicleid][viWheelSize] = value;
                    SetVehicleWheelSizeRPC(vehicleid, value, 1);
                }
            }
            SaveVehicleTuning(vehicleid);
            return StyleCenterKMonarch_Response(playerid, type, 1, value, color_type);
        }
    }

    // Purchase fallback for extra KMonarch buttons: charge only when packet has a price
    // or a positive detail id, then send success so CEF unlocks the selected item.
    new packet_price = 0;
    if(HornTune_ReadPacketInt(JSONObject, "j", packet_price) && packet_price > 0) price = packet_price;

    if(type > 0 && detail_id > 0)
    {
        if(!StyleCenterKMonarch_TakeMoney(playerid, price)) return StyleCenterKMonarch_Response(playerid, type, 0, detail_id, color_type);
        SaveVehicleTuning(vehicleid);
        return StyleCenterKMonarch_Response(playerid, type, 1, detail_id, color_type);
    }

    return StyleCenterKMonarch_Response(playerid, type, 1, detail_id, color_type);
}

public PacketIncomingTuning(playerid, Node:JSONObject)
{
    new type = -1, selector_id = -1, data_value = -1, mt_value = -1, status = 0, sound_id = 0;
    new color[32], vinyl[64];

    HornTune_ReadPacketInt(JSONObject, "t", type);
    HornTune_ReadPacketInt(JSONObject, "m", selector_id);
    HornTune_ReadPacketInt(JSONObject, "d", data_value);
    HornTune_ReadPacketInt(JSONObject, "mt", mt_value);
    HornTune_ReadPacketInt(JSONObject, "s", status);
    HornTune_ReadPacketInt(JSONObject, "h", sound_id);
    JSON_GetString(JSONObject, "co", color, sizeof(color));
    JSON_GetString(JSONObject, "v", vinyl, sizeof(vinyl));

    new center_mode = GetPVarInt(playerid, "HornTuneCenterMode");
    if(center_mode == 0 && GetPVarInt(playerid, "StyleTuningCenter") == 1) center_mode = 1;
    if(center_mode == 0 && InStailing[playerid]) center_mode = 1;

    // V11: GUI 28 is used by both style and tech. Only tech center keeps the
    // old tech branch. Every other GUI 28 packet is forced into the new
    // KMonarch style handler, otherwise style buttons were silently handled
    // by the old/fallback branch and purchases/exit did not change anything.
    if(center_mode != 2)
    {
        return StyleCenterKMonarch_Packet(playerid, JSONObject);
    }

    new vehicleid = HornTune_GetVehicleForPlayer(playerid);

    static raw_packet[512];
    raw_packet[0] = EOS;
    JSON_Stringify(JSONObject, raw_packet, sizeof(raw_packet));
    printf("[FELIX_TUNING] p=%d type=%d m=%d d=%d mt=%d mode=%d raw=%s", playerid, type, selector_id, data_value, mt_value, center_mode, raw_packet);

    if(type == 0)
    {
        HornTune_ReturnFromGUI(playerid);
        DeletePVar(playerid, "HornTuneCenterMode");
        DeletePVar(playerid, "HornTuneLastTechDetail");
        DeletePVar(playerid, "HornTuneLastTechDetailSet");
        DeletePVar(playerid, "HornTuneLastTechGroup");
        DeletePVar(playerid, "HornTuneLastTechGroupSet");
        return HornTune_Response(playerid, 0, 1, selector_id, data_value, mt_value, color, vinyl);
    }

    if(!IsValidVehicle(vehicleid))
    {
        return HornTune_Response(playerid, type, 0, selector_id, data_value, mt_value, color, vinyl);
    }

    new model = GetVehicleModel(vehicleid);
    new base_price = GetVehiclePriceByModel(model);
    if(base_price <= 0) base_price = 1000000;

    new detail_id = HornTune_ReadDetailId(JSONObject, type);
    if(!HornTune_IsTechDetail(detail_id) && mt_value >= 0 && HornTune_IsTechDetail(mt_value)) detail_id = mt_value;

    new tech_group = HornTune_DetectTechGroup(type, selector_id, data_value, mt_value);
    if(center_mode == 2 && tech_group >= 0)
    {
        SetPVarInt(playerid, "HornTuneLastTechGroup", tech_group);
        SetPVarInt(playerid, "HornTuneLastTechGroupSet", 1);
    }

    // Tech GUI often sends the selected detail in a preview packet first,
    // then the buy button sends only t=7/t=10 without m/d/mt.
    // Remember the last real detail and use it for the following buy packet.
    if(center_mode == 2)
    {
        if(HornTune_IsTechDetail(mt_value) && mt_value > 4) HornTune_RememberTechDetail(playerid, mt_value);
        else if(HornTune_IsTechDetail(data_value) && data_value > 4) HornTune_RememberTechDetail(playerid, data_value);
    }

    /* Preview / selector packets. They must return success, otherwise CEF stops reacting. */
    switch(type)
    {
        case 5:
        {
            return HornTune_Response(playerid, type, 1, selector_id, data_value, mt_value, color, vinyl);
        }
        case 6, 9, 11, 20, 26, 28:
        {
            return HornTune_Response(playerid, type, 1, selector_id, data_value, mt_value, color, vinyl);
        }
    }

    // Full Tech purchase packets. Do this after preview/selector packets,
    // otherwise category clicks can be charged as purchases.
    if(center_mode == 2)
    {
        if(!HornTune_IsTechDetail(detail_id)) detail_id = HornTune_GetRememberedTechDetail(playerid);

        if(HornTune_IsTechDetail(detail_id))
        {
            new tech_price = HornTune_GetTechDetailPrice(base_price, detail_id);
            return HornTune_BuyTechDetail(playerid, vehicleid, detail_id, tech_price, JSONObject, type, selector_id, mt_value);
        }

        /*
            Felix Tech sometimes sends only t=7/t=10/t=12 on the buy button,
            without m/d/mt. In that case buy the selected bundle; if the client
            did not send the selected tile at all, buy all missing tech bundles
            so every firmware tile becomes installed instead of only the first one.
        */
        if(type == 7 || type == 10 || type == 12)
        {
            new bundle_group = -1;
            if(GetPVarInt(playerid, "HornTuneLastTechGroupSet") == 1) bundle_group = GetPVarInt(playerid, "HornTuneLastTechGroup");
            return HornTune_BuyTechBundle(playerid, vehicleid, bundle_group, JSONObject, type, selector_id, mt_value);
        }
    }

    /* Donor/normal strobes can be bought from style GUI too. */
    if(center_mode == 1)
    {
        new strobe_detail = -1;
        if(detail_id >= 28 && detail_id <= 32) strobe_detail = detail_id;
        if(strobe_detail == -1 && mt_value >= 28 && mt_value <= 32) strobe_detail = mt_value;
        if(strobe_detail == -1 && data_value >= 28 && data_value <= 32) strobe_detail = data_value;
        if(strobe_detail == -1 && selector_id >= 28 && selector_id <= 32) strobe_detail = selector_id;

        /*
            On the Felix Style donor-strobe button the client can send only
            t=7 with no component id. If there is no valid wheel component,
            treat it as donor strobe instead of silently confirming a preview.
        */
        if(strobe_detail == -1 && type == 7 && data_value <= 0 && mt_value <= 0) strobe_detail = 32;

        if(strobe_detail >= 28 && strobe_detail <= 32)
        {
            new strob_price = HornTune_GetTechDetailPrice(base_price, strobe_detail);
            return HornTune_BuyTechDetail(playerid, vehicleid, strobe_detail, strob_price, JSONObject, type, selector_id, mt_value);
        }
    }

    /* Full Style: body/wheel colors. */
    if(type == 1 || type == 2)
    {
        new color_type = selector_id;
        new color_val = data_value;
        if(color[0] != EOS) sscanf(color, "h", color_val);
        else format(color, sizeof(color), "%06X", color_val);

        new price = HornTune_GetPacketPrice(JSONObject, HornTune_GetStylePrice(base_price, type, selector_id));
        if(!HornTune_TakeMoney(playerid, price, 0)) return HornTune_Response(playerid, type, 0, selector_id, data_value, mt_value, color, vinyl);

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
            default:
            {
                ChangeVehicleColor(vehicleid, color_val, color_val);
            }
        }

        SaveVehicleTuning(vehicleid);
        return HornTune_Response(playerid, type, 1, selector_id, data_value, mt_value, color, vinyl);
    }

    /* Vinyl. */
    if(type == 3)
    {
        new vinyl_id = data_value;
        if(vinyl_id < 0 && detail_id >= 0) vinyl_id = detail_id;
        if((vinyl_id < 0 || vinyl_id >= sizeof(VinylNames) || VinylNames[vinyl_id][0] == EOS) && vinyl[0] != EOS)
        {
            vinyl_id = HornTune_FindVinylByName(vinyl);
        }
        if(vinyl_id < 0 || vinyl_id >= sizeof(VinylNames) || VinylNames[vinyl_id][0] == EOS)
        {
            return HornTune_Response(playerid, type, 0, selector_id, data_value, mt_value, color, vinyl);
        }

        new price = HornTune_GetPacketPrice(JSONObject, HornTune_GetStylePrice(base_price, type, selector_id));
        if(!HornTune_TakeMoney(playerid, price, 0)) return HornTune_Response(playerid, type, 0, selector_id, vinyl_id, mt_value, color, vinyl);

        vInfo[vehicleid][viVinyl] = vinyl_id;
        format(vInfo[vehicleid][viVinylTexture], 16, "%s", VinylNames[vinyl_id]);
        SetVehicleVinyl(vehicleid, VinylNames[vinyl_id], 1);
        SaveVehicleTuning(vehicleid);
        return HornTune_Response(playerid, type, 1, selector_id, vinyl_id, mt_value, color, VinylNames[vinyl_id]);
    }

    /* Wheels. Some client clicks on category send only t=7/10 without component id.
       This is a preview/category packet, not a purchase, so just confirm it. */
    if(type == 7 || type == 10)
    {
        new component = data_value;
        if(component <= 0 && detail_id > 0 && center_mode != 2) component = detail_id;
        if(component <= 0) return HornTune_Response(playerid, type, 1, selector_id, data_value, mt_value, color, vinyl);

        new price = HornTune_GetPacketPrice(JSONObject, HornTune_GetStylePrice(base_price, type, selector_id));
        if(!HornTune_TakeMoney(playerid, price, 0)) return HornTune_Response(playerid, type, 0, selector_id, component, mt_value, color, vinyl);

        AddVehicleComponent(vehicleid, component);
        SaveVehicleTuning(vehicleid);
        return HornTune_Response(playerid, type, 1, selector_id, component, mt_value, color, vinyl);
    }

    /* Neon by color. */
    if(type == 8)
    {
        new neon_color = data_value;
        if(color[0] != EOS) sscanf(color, "h", neon_color);
        new price = HornTune_GetPacketPrice(JSONObject, HornTune_GetStylePrice(base_price, type, selector_id));
        if(!HornTune_TakeMoney(playerid, price, 0)) return HornTune_Response(playerid, type, 0, selector_id, data_value, mt_value, color, vinyl);
        vInfo[vehicleid][viNeon1] = neon_color;
        vInfo[vehicleid][viNeon2] = neon_color;
        vInfo[vehicleid][viNeon3] = neon_color;
        SetVehicleNeon(vehicleid, neon_color, neon_color, neon_color, 1);
        SaveVehicleTuning(vehicleid);
        return HornTune_Response(playerid, type, 1, selector_id, data_value, mt_value, color, vinyl);
    }

    /* Tint / suspension / wheel numeric controls. */
    if(type == 12 || (type >= 21 && type <= 30))
    {
        new control = selector_id;
        new value = data_value;
        if(type != 12)
        {
            control = type;
            if(value < 0) value = selector_id;
        }
        if(value < 0) value = 0;

        new price = HornTune_GetPacketPrice(JSONObject, HornTune_GetStylePrice(base_price, type, control));
        if(!HornTune_TakeMoney(playerid, price, 0)) return HornTune_Response(playerid, type, 0, control, value, mt_value, color, vinyl);

        switch(control)
        {
            case 12:
            {
                SetVehicleTint(vehicleid, value, 1);
            }
            case 20, 30:
            {
                vInfo[vehicleid][viWheelSize] = value;
                SetVehicleWheelSizeRPC(vehicleid, value, 1);
            }
            case 21, 28:
            {
                vInfo[vehicleid][viWheelAddFront] = value;
                SetVehicleWheelAdditive(vehicleid, vInfo[vehicleid][viWheelAddFront], vInfo[vehicleid][viWheelAddRear], 1);
            }
            case 22, 29:
            {
                vInfo[vehicleid][viWheelAddRear] = value;
                SetVehicleWheelAdditive(vehicleid, vInfo[vehicleid][viWheelAddFront], vInfo[vehicleid][viWheelAddRear], 1);
            }
            case 23:
            {
                vInfo[vehicleid][viSuspensionBias] = value;
                SetVehicleSuspensionBiasRPC(vehicleid, value, 1);
            }
            case 24:
            {
                SetVehicleWheelDeparture(vehicleid, value, 0, 1);
            }
            case 25:
            {
                SetVehicleWheelDeparture(vehicleid, 0, value, 1);
            }
            case 26:
            {
                SetVehicleWheelAlignment(vehicleid, value, 0, 1);
            }
            case 27:
            {
                SetVehicleClearance(vehicleid, value, 1);
            }
        }

        SaveVehicleTuning(vehicleid);
        return HornTune_Response(playerid, type, 1, control, value, mt_value, color, vinyl);
    }

    /* Final fallback: if GUI sent a price, treat it as a style purchase instead of silently rejecting. */
    new fallback_price = 0;
    if(HornTune_ReadPacketInt(JSONObject, "j", fallback_price) && fallback_price > 0)
    {
        if(!HornTune_TakeMoney(playerid, HornTune_GetPacketPrice(JSONObject, 1000), 0)) return HornTune_Response(playerid, type, 0, selector_id, detail_id, mt_value, color, vinyl);
        SaveVehicleTuning(vehicleid);
        return HornTune_Response(playerid, type, 1, selector_id, detail_id, mt_value, color, vinyl);
    }

    return HornTune_Response(playerid, type, 0, selector_id, detail_id, mt_value, color, vinyl);
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

    if(vInfo[vehicleid][viLaunchControl] > 0)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(3)));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }

    //    /   GUI ,   
    //     .    , ,  .
    if(vInfo[vehicleid][viStrob] >= 1 && vInfo[vehicleid][viStrob] <= 4)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(27 + vInfo[vehicleid][viStrob])));
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    }
    else if(vInfo[vehicleid][viStrob] >= 6)
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
    JSON_SetInt(tuning_json, "t", 0); 
    JSON_SetInt(tuning_json, "j", price); 
    JSON_SetInt(tuning_json, "s", 5);
    JSON_SetArray(tuning_json, "k", k_array);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", GetVehicleNameByModel(model));
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(tuning_json, "r", GetPlayerDonateRub(playerid));
    JSON_SetInt(tuning_json, "d", GetPlayerDonateRub(playerid));
    JSON_SetInt(tuning_json, "bc", GetPlayerDonateRub(playerid));
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

// ===== Compatibility API for laird.pwn calls =====
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
    vInfo[vehicleid][viNitro] = HornTechNitro[slot];
    HornTune_ApplyTechToVehicle(vehicleid);
    return 1;
}
