/*
    Fresh GUI tuning module for Sander Russia.
    Active path: gamemodes/sander/gui/tuning/tuning.pwn.
    The old br_tuning folder is not used.
*/


// Fresh GUI tuning adapted for g_ownable_car + vInfo structure.
new bool:InStailing[MAX_PLAYERS];

#define TUNING_SHOP_STYLING   0
#define TUNING_SHOP_TIRES     2
#define TUNING_SHOP_TECH      3
#define TUNING_WRONG_STYLING   -1
#define TUNING_WRONG_TIRES     -2
#define TUNING_WRONG_TECH      -3

stock bool:Tuning_IsTechDetail(detal_id)
{
    switch(detal_id)
    {
        case 0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 16, 17, 19, 20, 21, 22, 24, 25, 26, 27: return true;
    }
    return false;
}

stock bool:Tuning_IsStylingDetail(detal_id)
{
    switch(detal_id)
    {
        case 13, 28, 29, 30, 31, 32, 130: return true;
    }
    return false;
}

stock Tuning_NormalizeDetailID(detal_id)
{
    // High-beam can come from different GUI builds as 13, 130 or 334.
    // Keep 13 as client id so GUI 28 marks it as installed correctly.
    switch(detal_id)
    {
        case 130, 334: return 13;
    }
    return detal_id;
}

stock Tuning_SendWrongShop(playerid, shop_type)
{
    switch(shop_type)
    {
        case TUNING_SHOP_STYLING: ShowNotificationSander(playerid, 2, 4, 1, 1, "Эта деталь доступна в стайлинг-центре!", "");
        case TUNING_SHOP_TIRES: ShowNotificationSander(playerid, 2, 4, 1, 1, "Эта деталь доступна в шиномонтажке!", "");
        case TUNING_SHOP_TECH: ShowNotificationSander(playerid, 2, 4, 1, 1, "Эта деталь доступна в техническом центре!", "");
    }
    return 1;
}

stock Tuning_GetWrongShopFromResult(result)
{
    switch(result)
    {
        case TUNING_WRONG_STYLING: return TUNING_SHOP_STYLING;
        case TUNING_WRONG_TIRES: return TUNING_SHOP_TIRES;
        case TUNING_WRONG_TECH: return TUNING_SHOP_TECH;
    }
    return -1;
}

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

// Current selection inside BR styling GUI 28.
// These values are previewed immediately and are committed to DB only on purchase packets.
new g_BRStylePreviewBody[MAX_PLAYERS];
new g_BRStylePreviewDisk[MAX_PLAYERS];
new g_BRStylePreviewTonerFront[MAX_PLAYERS];
new g_BRStylePreviewTonerRear[MAX_PLAYERS];
new g_BRStylePreviewNeonMain[MAX_PLAYERS];
new g_BRStylePreviewNeonLeft[MAX_PLAYERS];
new g_BRStylePreviewNeonRight[MAX_PLAYERS];
new g_BRStylePreviewLight[MAX_PLAYERS];
new g_BRStylePreviewVinyl[MAX_PLAYERS];
new g_BRStylePreviewHigh[MAX_PLAYERS];
new g_BRStylePreviewStrob[MAX_PLAYERS];

stock Tuning_ResetStylePreview(playerid, slot)
{
    if(slot == -1) return 0;

    g_BRStylePreviewBody[playerid] = GetOwnableCarData(slot, OC_TUNE_BODY_COLOR);
    g_BRStylePreviewDisk[playerid] = GetOwnableCarData(slot, OC_TUNE_DISK_COLOR);
    g_BRStylePreviewTonerFront[playerid] = GetOwnableCarData(slot, OC_TUNE_WIND_FRONT);
    g_BRStylePreviewTonerRear[playerid] = GetOwnableCarData(slot, OC_TUNE_WIND_REAR);
    g_BRStylePreviewNeonMain[playerid] = GetOwnableCarData(slot, OC_TUNE_NEON_MAIN);
    g_BRStylePreviewNeonLeft[playerid] = GetOwnableCarData(slot, OC_TUNE_NEON_1);
    g_BRStylePreviewNeonRight[playerid] = GetOwnableCarData(slot, OC_TUNE_NEON_2);
    g_BRStylePreviewLight[playerid] = GetOwnableCarData(slot, OC_TUNE_LIGHTS_COLOR);
    g_BRStylePreviewVinyl[playerid] = GetOwnableCarData(slot, OC_TUNE_VINYL);
    g_BRStylePreviewHigh[playerid] = GetOwnableCarData(slot, OC_TUNE_DALNIYSVET);
    g_BRStylePreviewStrob[playerid] = GetOwnableCarData(slot, OC_TUNE_STROB);
    return 1;
}

stock Tuning_GetPreviewBodyColorForRPC(playerid, slot)
{
    if(g_BRStylePreviewBody[playerid] != 0) return g_BRStylePreviewBody[playerid];
    return Tuning_GetOwnableBodyColorForRPC(slot);
}

stock Tuning_GetPreviewDiskColorForRPC(playerid, slot)
{
    if(g_BRStylePreviewDisk[playerid] != 0) return g_BRStylePreviewDisk[playerid];
    return Tuning_GetOwnableDiskColorForRPC(slot);
}

stock Tuning_ParseStyleColor(Node:JSONObject, &color_val)
{
    new color[32];
    color_val = 0;

    JSON_GetString(JSONObject, "co", color, sizeof(color));
    if(strlen(color) == 0) JSON_GetString(JSONObject, "d", color, sizeof(color));

    if(strlen(color) > 0)
    {
        if(color[0] == '#') strdel(color, 0, 1);
        if(strlen(color) > 1 && color[0] == '0' && (color[1] == 'x' || color[1] == 'X')) strdel(color, 0, 2);
        sscanf(color, "h", color_val);
        if(color_val >= 0 && color_val <= 0xFFFFFF) color_val = (color_val << 8) | 0xFF;
        return 1;
    }

    JSON_GetInt(JSONObject, "co", color_val);
    if(color_val == 0) JSON_GetInt(JSONObject, "d", color_val);
    if(color_val >= 0 && color_val <= 0xFFFFFF) color_val = (color_val << 8) | 0xFF;
    return 1;
}

stock Tuning_FindVinylID(const texture[])
{
    if(strlen(texture) == 0) return -1;
    for(new i = 0; i < sizeof(VinylNames); i++)
    {
        if(strlen(VinylNames[i]) == 0) continue;
        if(!strcmp(VinylNames[i], texture, true)) return i;
    }
    return -1;
}

stock Tuning_SetStylePreviewValue(playerid, color_type, color_val)
{
    switch(color_type)
    {
        case 0: g_BRStylePreviewBody[playerid] = color_val;
        case 1: g_BRStylePreviewDisk[playerid] = color_val;
        case 3: g_BRStylePreviewTonerFront[playerid] = color_val;
        case 4: g_BRStylePreviewTonerRear[playerid] = color_val;
        case 10: g_BRStylePreviewLight[playerid] = color_val;
        case 11: g_BRStylePreviewNeonMain[playerid] = color_val;
        case 12: g_BRStylePreviewNeonLeft[playerid] = color_val;
        case 13: g_BRStylePreviewNeonRight[playerid] = color_val;
        default: return 0;
    }
    return 1;
}

stock Tuning_ApplyStylePreview(playerid, vehicleid, slot)
{
    if(vehicleid == INVALID_VEHICLE_ID || slot == -1) return 0;

    new vinyl_id = g_BRStylePreviewVinyl[playerid];
    vInfo[vehicleid][viVinyl] = vinyl_id;

    vInfo[vehicleid][viBodyColor] = g_BRStylePreviewBody[playerid];
    vInfo[vehicleid][viDiskColor] = g_BRStylePreviewDisk[playerid];
    vInfo[vehicleid][vBodyColor] = vInfo[vehicleid][viBodyColor];
    vInfo[vehicleid][vDiskColor] = vInfo[vehicleid][viDiskColor];

    SetVehicleColor(vehicleid, Tuning_GetPreviewBodyColorForRPC(playerid, slot), Tuning_GetPreviewDiskColorForRPC(playerid, slot), 1);

    if(vinyl_id >= 0 && vinyl_id < sizeof(VinylNames) && strlen(VinylNames[vinyl_id]) > 0)
    {
        SetVehicleVinyl(vehicleid, VinylNames[vinyl_id], 1);
    }
    else
    {
        format(vInfo[vehicleid][viVinylTexture], 16, "");
        SetVehicleVinyl(vehicleid, "remapvehicles", 1);
    }

    vInfo[vehicleid][viTonerFront] = g_BRStylePreviewTonerFront[playerid];
    vInfo[vehicleid][viTonerRear] = g_BRStylePreviewTonerRear[playerid];
    vInfo[vehicleid][viTonerFrontSide] = g_BRStylePreviewTonerFront[playerid];
    vInfo[vehicleid][viTonerRearSide] = g_BRStylePreviewTonerRear[playerid];
    vInfo[vehicleid][vWindFront] = g_BRStylePreviewTonerFront[playerid];
    vInfo[vehicleid][vWindRear] = g_BRStylePreviewTonerRear[playerid];
    SetVehicleTonerRPC(vehicleid, g_BRStylePreviewTonerFront[playerid], g_BRStylePreviewTonerRear[playerid], g_BRStylePreviewTonerFront[playerid], g_BRStylePreviewTonerRear[playerid], 1);

    vInfo[vehicleid][viLightColor] = g_BRStylePreviewLight[playerid];
    vInfo[vehicleid][vLightColor] = g_BRStylePreviewLight[playerid];
    SetVehicleLightColor(vehicleid, g_BRStylePreviewLight[playerid], 1);

    vInfo[vehicleid][viNeon1] = g_BRStylePreviewNeonMain[playerid];
    vInfo[vehicleid][viNeon2] = g_BRStylePreviewNeonLeft[playerid];
    vInfo[vehicleid][viNeon3] = g_BRStylePreviewNeonRight[playerid];
    vInfo[vehicleid][vNeonMain] = g_BRStylePreviewNeonMain[playerid];
    vInfo[vehicleid][vNeon1] = g_BRStylePreviewNeonLeft[playerid];
    vInfo[vehicleid][vNeon2] = g_BRStylePreviewNeonRight[playerid];
    SetVehicleLightingColor(vehicleid, g_BRStylePreviewNeonMain[playerid], g_BRStylePreviewNeonLeft[playerid], g_BRStylePreviewNeonRight[playerid], 1);

    if(g_BRStylePreviewHigh[playerid] > 0) SetVehicleHighLight(vehicleid, g_BRStylePreviewHigh[playerid]);
    if(g_BRStylePreviewStrob[playerid] >= 0 && g_BRStylePreviewStrob[playerid] <= 4) SetVehicleStroboscope(vehicleid, g_BRStylePreviewStrob[playerid]);
    return 1;
}

stock Tuning_ProcessStylePreview(playerid, Node:JSONObject, Node:tuning_response, type)
{
    if(g_TuningType[playerid] != TUNING_SHOP_STYLING) return TUNING_WRONG_STYLING;

    new vehicleid = GetPlayerVehicleID(playerid);
    new slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;

    new selector_id, data_value = -1, color_val, texture[32];
    JSON_GetInt(JSONObject, "m", selector_id);
    JSON_GetInt(JSONObject, "d", data_value);
    if(data_value == -1) JSON_GetInt(JSONObject, "p", data_value);
    JSON_GetString(JSONObject, "v", texture, sizeof(texture));

    if(type == 26 || strlen(texture) > 0)
    {
        new vinyl_id = Tuning_FindVinylID(texture);
        if(vinyl_id == -1 && data_value >= 0 && data_value < sizeof(VinylNames)) vinyl_id = data_value;
        if(vinyl_id != -1) g_BRStylePreviewVinyl[playerid] = vinyl_id;
        Tuning_ApplyStylePreview(playerid, vehicleid, slot);

        JSON_SetInt(tuning_response, "t", type);
        JSON_SetInt(tuning_response, "s", 1);
        JSON_SetInt(tuning_response, "d", g_BRStylePreviewVinyl[playerid]);
        if(g_BRStylePreviewVinyl[playerid] >= 0 && g_BRStylePreviewVinyl[playerid] < sizeof(VinylNames))
        {
            new preview_vinyl_name[32];
            format(preview_vinyl_name, sizeof(preview_vinyl_name), "%s", VinylNames[g_BRStylePreviewVinyl[playerid]]);
            JSON_SetString(tuning_response, "v", preview_vinyl_name);
        }
        return 1;
    }

    if(type == 28)
    {
        data_value = Tuning_NormalizeDetailID(data_value);
        if(data_value == 13) g_BRStylePreviewHigh[playerid] = 1;
        else if(data_value >= 28 && data_value <= 31) g_BRStylePreviewStrob[playerid] = data_value - 28;
        else if(data_value == 32) g_BRStylePreviewStrob[playerid] = 4;
        Tuning_ApplyStylePreview(playerid, vehicleid, slot);

        JSON_SetInt(tuning_response, "t", type);
        JSON_SetInt(tuning_response, "s", 1);
        JSON_SetInt(tuning_response, "d", data_value);
        return 1;
    }

    Tuning_ParseStyleColor(JSONObject, color_val);
    if(!Tuning_SetStylePreviewValue(playerid, selector_id, color_val)) return 0;
    Tuning_ApplyStylePreview(playerid, vehicleid, slot);

    new color_string[16];
    format(color_string, sizeof(color_string), "%06x", (color_val >> 8) & 0xFFFFFF);
    JSON_SetInt(tuning_response, "t", type);
    JSON_SetInt(tuning_response, "s", 1);
    JSON_SetInt(tuning_response, "m", selector_id);
    JSON_SetString(tuning_response, "co", color_string);
    return 1;
}

stock GetTuningPrice(gosCost, tuneId)
{
    new Float:percent;
    new addedValue;

    switch(tuneId)
    {
        case 0: { percent = 4.0; addedValue = 15000; } // Comfort
        case 1: { percent = 7.0; addedValue = 15000; } // Sport
        case 2: { percent = 5.0; addedValue = 15000; } // Drift
        case 3: { percent = 0.005; addedValue = 20; }  // Sport+ donate rub
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

stock GetBodyPaintCost(price) return (price / 100) + 10000;
stock GetUnivCost(price) return (price / 100) + 50000;
stock GetDalniyCost(price) return (price / 1000) + 10000;
stock GetDoubleCost(price) return ((price / 100) + 10000) * 2;
stock GetExtraCost(price) return (price / 100) + 20000;
stock GetDonatCost(price) return (((price / 100) + 50000) * 3) / 1000;

stock GetShinaPrice(price, type)
{
    switch(type)
    {
        case 0: return (price / 200) + 5000;
        case 1: return (price / 200) + 8000;
        case 2: return (price / 200) + 7000;
        case 3: return (price / 200) + 6000;
        case 4: return (price / 150) + 10000;
        case 5: return (price / 100) + 50000;
        case 6: return (price / 100) + 80000;
    }
    return 1000;
}

stock IsPartInstalled(value, part)
{
    if(value <= 0) return 0;
    new temp_val = value;
    while(temp_val > 0)
    {
        if(temp_val % 10 == part) return 1;
        temp_val /= 10;
    }
    return 0;
}

stock IsFullSetInstalled(value)
{
    return (IsPartInstalled(value, 1) && IsPartInstalled(value, 2) && IsPartInstalled(value, 3) && IsPartInstalled(value, 4) && IsPartInstalled(value, 5));
}

stock Tuning_GetVehiclePrice(vehicleid)
{
    new price;
    new modelid = GetVehicleModel(vehicleid);
    if(GetVehicleJsonCostByModelId(modelid, price)) return price;
    return GetVehicleMarketPriceByModel(modelid);
}

stock Tuning_GetVehicleName(vehicleid, name[], size)
{
    new modelid = GetVehicleModel(vehicleid);
    GetVehicleModelName(modelid, name, size);
    return 1;
}

stock Tuning_ParseHexColor(Node:JSONObject, color_key[], &color_val)
{
    new color[32];
    color_val = 0;

    JSON_GetString(JSONObject, color_key, color, sizeof(color));

    if(strlen(color) > 0)
    {
        if(color[0] == '#') strdel(color, 0, 1);
        if(strlen(color) > 1 && color[0] == '0' && (color[1] == 'x' || color[1] == 'X')) strdel(color, 0, 2);

        sscanf(color, "h", color_val);
    }
    else
    {
        JSON_GetInt(JSONObject, color_key, color_val);
    }

    if(color_val >= 0 && color_val <= 0xFFFFFF)
    {
        color_val = (color_val << 8) | 0xFF;
    }
    return 1;
}

stock Tuning_SendNoMoney(playerid)
{
    ShowNotificationSander(playerid, 2, 4, 1, 1, "Недостаточно средств для покупки детали!", "");
    return 1;
}

stock Tuning_SendNoDonate(playerid)
{
    ShowNotificationSander(playerid, 2, 4, 1, 1, "Недостаточно донат-рублей для покупки детали!", "");
    return 1;
}

stock bool:Tuning_IsDonateOnlyDetail(detal_id)
{
    detal_id = Tuning_NormalizeDetailID(detal_id);
    switch(detal_id)
    {
        case 7, 12, 17, 22, 27, 32: return true;
    }
    return false;
}

stock Tuning_GetDetailServerPrice(vehicleid, detal_id)
{
    detal_id = Tuning_NormalizeDetailID(detal_id);
    new model_price = Tuning_GetVehiclePrice(vehicleid);

    switch(detal_id)
    {
        case 4, 9, 14, 19, 24: return GetTuningPrice(model_price, 0);
        case 5, 10, 15, 20, 25: return GetTuningPrice(model_price, 1);
        case 6, 11, 16, 21, 26: return GetTuningPrice(model_price, 2);
        case 7, 12, 17, 22, 27: return GetDonatCost(model_price);
        case 0, 1, 2: return GetNitroPrice(model_price, detal_id);
        case 3: return GetUnivCost(model_price);
        case 13: return GetDalniyCost(model_price);
        case 28, 29, 30, 31: return GetUnivCost(model_price);
        case 32: return GetDonatCost(model_price);
    }
    return GetUnivCost(model_price);
}

stock Tuning_GetStyleServerPrice(vehicleid, color_type)
{
    new model_price = Tuning_GetVehiclePrice(vehicleid);

    if(color_type == 10) return GetDoubleCost(model_price);
    if(color_type == 3 || color_type == 4) return GetExtraCost(model_price);
    if(color_type >= 11 && color_type <= 13) return GetUnivCost(model_price);
    return GetBodyPaintCost(model_price);
}

stock Tuning_GetRawPacketPrice(vehicleid, packet_type, selector_id, data_value)
{
    new model_price = Tuning_GetVehiclePrice(vehicleid);

    switch(packet_type)
    {
        case 1: return Tuning_GetStyleServerPrice(vehicleid, selector_id);
        case 3: return GetDonatCost(model_price);
        case 7:
        {
            if(data_value == 33) return GetShinaPrice(model_price, 5);
            if(data_value == 90) return GetUnivCost(model_price);
            if(data_value >= 93 && data_value <= 98) return GetUnivCost(model_price);
            if(data_value >= 28 && data_value <= 31) return GetUnivCost(model_price);
            if(data_value == 32) return GetDonatCost(model_price);
            if(data_value == 299) return GetDalniyCost(model_price);
            if(data_value == 35) return GetUnivCost(model_price);
            if(data_value >= 4 && data_value <= 6) return GetTuningPrice(model_price, data_value - 4);
            if(data_value == 7) return GetDonatCost(model_price);
        }
        case 11: return GetUnivCost(model_price);
    }
    return 0;
}

stock bool:Tuning_IsRawPacketDonateOnly(packet_type, data_value)
{
    if(packet_type == 3) return true;
    if(packet_type == 7 && (data_value == 7 || data_value == 32)) return true;
    return false;
}

stock Tuning_CaptureRuntimeStateToOwnable(vehicleid)
{
    if(!IsValidVehicle(vehicleid)) return 0;
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR) return 0;

    new idx = GetVehicleData(vehicleid, V_ACTION_ID);
    if(idx < 0 || idx >= MAX_OWNABLE_CARS) return 0;

    if(vInfo[vehicleid][viBodyColor] != 0 || vInfo[vehicleid][vBodyColor] != 0)
        SetOwnableCarData(idx, OC_TUNE_BODY_COLOR, vInfo[vehicleid][viBodyColor] ? vInfo[vehicleid][viBodyColor] : vInfo[vehicleid][vBodyColor]);
    if(vInfo[vehicleid][viDiskColor] != 0 || vInfo[vehicleid][vDiskColor] != 0)
        SetOwnableCarData(idx, OC_TUNE_DISK_COLOR, vInfo[vehicleid][viDiskColor] ? vInfo[vehicleid][viDiskColor] : vInfo[vehicleid][vDiskColor]);

    SetOwnableCarData(idx, OC_TUNE_LIGHTS_COLOR, vInfo[vehicleid][viLightColor] ? vInfo[vehicleid][viLightColor] : vInfo[vehicleid][vLightColor]);
    SetOwnableCarData(idx, OC_TUNE_WIND_FRONT, vInfo[vehicleid][viTonerFront] ? vInfo[vehicleid][viTonerFront] : vInfo[vehicleid][vWindFront]);
    SetOwnableCarData(idx, OC_TUNE_WIND_REAR, vInfo[vehicleid][viTonerRear] ? vInfo[vehicleid][viTonerRear] : vInfo[vehicleid][vWindRear]);
    SetOwnableCarData(idx, OC_TUNE_NEON_MAIN, vInfo[vehicleid][viNeon1] ? vInfo[vehicleid][viNeon1] : vInfo[vehicleid][vNeonMain]);
    SetOwnableCarData(idx, OC_TUNE_NEON_1, vInfo[vehicleid][viNeon2] ? vInfo[vehicleid][viNeon2] : vInfo[vehicleid][vNeon1]);
    SetOwnableCarData(idx, OC_TUNE_NEON_2, vInfo[vehicleid][viNeon3] ? vInfo[vehicleid][viNeon3] : vInfo[vehicleid][vNeon2]);

    if(vInfo[vehicleid][viHighLights] || vInfo[vehicleid][vHighLights])
        SetOwnableCarData(idx, OC_TUNE_DALNIYSVET, vInfo[vehicleid][viHighLights] ? vInfo[vehicleid][viHighLights] : vInfo[vehicleid][vHighLights]);
    if(vInfo[vehicleid][viStrob] >= 0) SetOwnableCarData(idx, OC_TUNE_STROB, vInfo[vehicleid][viStrob]);
    else if(vInfo[vehicleid][vStrob] > 0) SetOwnableCarData(idx, OC_TUNE_STROB, vInfo[vehicleid][vStrob] - 1);

    SetOwnableCarData(idx, OC_TUNE_DALNIYSVET_STATE, bool:vInfo[vehicleid][vEnableHighLights]);
    SetOwnableCarData(idx, OC_TUNE_STROB_STATE, bool:vInfo[vehicleid][vEnableStrob]);
    SetOwnableCarData(idx, OC_TUNE_COMFORT_ACTIVE, bool:vInfo[vehicleid][vEnableComfort]);
    SetOwnableCarData(idx, OC_TUNE_SPORT_ACTIVE, bool:vInfo[vehicleid][vEnableSport]);
    SetOwnableCarData(idx, OC_TUNE_SPORT_PLUS_ACTIVE, bool:vInfo[vehicleid][vEnableSportPlus]);
    SetOwnableCarData(idx, OC_TUNE_DRIFT_ACTIVE, bool:vInfo[vehicleid][vEnableDrift]);

    if(vInfo[vehicleid][viNitro] > 0) SetOwnableCarData(idx, OC_TUNE_NITRO, vInfo[vehicleid][viNitro]);
    if(vInfo[vehicleid][viLaunchControl] > 0) SetOwnableCarData(idx, OC_TUNE_LAUNCH_CONTROL, vInfo[vehicleid][viLaunchControl]);
    else if(vInfo[vehicleid][vLaunchControl] > 0) SetOwnableCarData(idx, OC_TUNE_LAUNCH_CONTROL, vInfo[vehicleid][vLaunchControl]);
    if(vInfo[vehicleid][viHydraulics] > 0 || vInfo[vehicleid][vHydraulics] > 0)
        SetOwnableCarData(idx, OC_TUNE_HYDRA, vInfo[vehicleid][viHydraulics] ? vInfo[vehicleid][viHydraulics] : vInfo[vehicleid][vHydraulics]);
    if(vInfo[vehicleid][viVinyl] >= 0) SetOwnableCarData(idx, OC_TUNE_VINYL, vInfo[vehicleid][viVinyl]);

    if(vInfo[vehicleid][vRadius] != 0.0) SetOwnableCarData(idx, OC_TUNE_WHEEL_RADIUS, vInfo[vehicleid][vRadius]);
    if(vInfo[vehicleid][vWidthP] != 0.0) SetOwnableCarData(idx, OC_TUNE_WHEEL_WIDTH_FRONT, vInfo[vehicleid][vWidthP]);
    if(vInfo[vehicleid][vWidthZ] != 0.0) SetOwnableCarData(idx, OC_TUNE_WHEEL_WIDTH_REAR, vInfo[vehicleid][vWidthZ]);
    if(vInfo[vehicleid][vDepartureP] != 0.0) SetOwnableCarData(idx, OC_TUNE_OFFSET_FRONT, vInfo[vehicleid][vDepartureP]);
    if(vInfo[vehicleid][vDepartureZ] != 0.0) SetOwnableCarData(idx, OC_TUNE_OFFSET_REAR, vInfo[vehicleid][vDepartureZ]);
    if(vInfo[vehicleid][vAlignmentP] != 0.0) SetOwnableCarData(idx, OC_TUNE_CAMBER_FRONT, vInfo[vehicleid][vAlignmentP]);
    if(vInfo[vehicleid][vAlignmentZ] != 0.0) SetOwnableCarData(idx, OC_TUNE_CAMBER_REAR, vInfo[vehicleid][vAlignmentZ]);
    if(vInfo[vehicleid][vClearance] != 0.0) SetOwnableCarData(idx, OC_TUNE_CLEARANCE, vInfo[vehicleid][vClearance]);
    if(vInfo[vehicleid][viClearance] != 0.0) SetOwnableCarData(idx, OC_TUNE_CLEARANCE, vInfo[vehicleid][viClearance]);
    if(vInfo[vehicleid][viSeparate] != 0.0) SetOwnableCarData(idx, OC_TUNE_CLEARANCE_FRONT, vInfo[vehicleid][viSeparate]);

    if(vInfo[vehicleid][viHornSound] > 0 || vInfo[vehicleid][viHornRPC] > 0)
        SetOwnableCarData(idx, OC_TUNE_HORN_SOUND, vInfo[vehicleid][viHornSound] ? vInfo[vehicleid][viHornSound] : vInfo[vehicleid][viHornRPC]);
    if(vInfo[vehicleid][viExhaustSound] > 0 || vInfo[vehicleid][viExhaustRPC] > 0)
        SetOwnableCarData(idx, OC_TUNE_EXHAUST_SOUND, vInfo[vehicleid][viExhaustSound] ? vInfo[vehicleid][viExhaustSound] : vInfo[vehicleid][viExhaustRPC]);
    if(vInfo[vehicleid][viLaunchMode] > 0)
        SetOwnableCarData(idx, OC_FIRMWARE, vInfo[vehicleid][viLaunchMode]);

    SaveFreshVehicleTuning(vehicleid);
    return 1;
}

stock Tuning_SaveAndSyncRuntimeVehicle(vehicleid)
{
    if(!IsValidVehicle(vehicleid)) return 0;

    Tuning_CaptureRuntimeStateToOwnable(vehicleid);

    foreach(new playerid: Player)
    {
        if(IsVehicleStreamedIn(vehicleid, playerid)) SyncVehicleTuningForPlayer(playerid, vehicleid);
    }
    return 1;
}


stock Tuning_GetClientDetailID(detal_id)
{
    if(detal_id == 130 || detal_id == 334) return 13;
    return detal_id;
}

stock bool:Tuning_IsDetailInstalled(slot, detal_id)
{
    detal_id = Tuning_NormalizeDetailID(detal_id);

    switch(detal_id)
    {
        case 4:  return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_COMFORT), 1) ? true : false;
        case 9:  return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_COMFORT), 2) ? true : false;
        case 14: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_COMFORT), 3) ? true : false;
        case 19: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_COMFORT), 4) ? true : false;
        case 24: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_COMFORT), 5) ? true : false;

        case 5:  return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_SPORT), 1) ? true : false;
        case 10: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_SPORT), 2) ? true : false;
        case 15: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_SPORT), 3) ? true : false;
        case 20: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_SPORT), 4) ? true : false;
        case 25: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_SPORT), 5) ? true : false;

        case 6:  return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_DRIFT), 1) ? true : false;
        case 11: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_DRIFT), 2) ? true : false;
        case 16: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_DRIFT), 3) ? true : false;
        case 21: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_DRIFT), 4) ? true : false;
        case 26: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_DRIFT), 5) ? true : false;

        case 7:  return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_SPORT_PLUS), 1) ? true : false;
        case 12: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_SPORT_PLUS), 2) ? true : false;
        case 17: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_SPORT_PLUS), 3) ? true : false;
        case 22: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_SPORT_PLUS), 4) ? true : false;
        case 27: return IsPartInstalled(GetOwnableCarData(slot, OC_TUNE_SPORT_PLUS), 5) ? true : false;

        case 0: return (GetOwnableCarData(slot, OC_TUNE_NITRO) == 1) ? true : false;
        case 1: return (GetOwnableCarData(slot, OC_TUNE_NITRO) == 2) ? true : false;
        case 2: return (GetOwnableCarData(slot, OC_TUNE_NITRO) == 3) ? true : false;
        case 3: return (GetOwnableCarData(slot, OC_TUNE_LAUNCH_CONTROL) > 0) ? true : false;
        case 13: return (GetOwnableCarData(slot, OC_TUNE_DALNIYSVET) > 0) ? true : false;
        case 28, 29, 30, 31: return (GetOwnableCarData(slot, OC_TUNE_STROB) == (detal_id - 28)) ? true : false;
        case 32: return (GetOwnableCarData(slot, OC_TUNE_STROB) == 4) ? true : false;
    }
    return false;
}

stock Tuning_UpdateSportPlusRuntime(vehicleid, value)
{
    vInfo[vehicleid][vSportP1] = IsPartInstalled(value, 1);
    vInfo[vehicleid][vSportP2] = IsPartInstalled(value, 2);
    vInfo[vehicleid][vSportP3] = IsPartInstalled(value, 3);
    vInfo[vehicleid][vSportP4] = IsPartInstalled(value, 4);
    vInfo[vehicleid][vSportP5] = IsPartInstalled(value, 5);
    return 1;
}

stock Tuning_SendInstalledNotification(playerid, detal_id, bool:already_installed = false)
{
    new msg[96];
    detal_id = Tuning_NormalizeDetailID(detal_id);

    if(already_installed)
    {
        switch(detal_id)
        {
            case 0: format(msg, sizeof(msg), "Нитро X2 уже установлено");
            case 1: format(msg, sizeof(msg), "Нитро X5 уже установлено");
            case 2: format(msg, sizeof(msg), "Нитро X10 уже установлено");
            case 3: format(msg, sizeof(msg), "Launch Control уже установлен");
            case 13: format(msg, sizeof(msg), "Дальний свет уже установлен");
            case 28, 29, 30, 31, 32: format(msg, sizeof(msg), "Стробоскопы уже установлены");
            case 4, 9, 14, 19, 24: format(msg, sizeof(msg), "Прошивка Comfort уже установлена");
            case 5, 10, 15, 20, 25: format(msg, sizeof(msg), "Прошивка Sport уже установлена");
            case 6, 11, 16, 21, 26: format(msg, sizeof(msg), "Прошивка Drift уже установлена");
            case 7, 12, 17, 22, 27: format(msg, sizeof(msg), "Прошивка Sport+ уже установлена");
            default: format(msg, sizeof(msg), "Деталь уже установлена");
        }
    }
    else
    {
        switch(detal_id)
        {
            case 0: format(msg, sizeof(msg), "Нитро X2 установлено");
            case 1: format(msg, sizeof(msg), "Нитро X5 установлено");
            case 2: format(msg, sizeof(msg), "Нитро X10 установлено");
            case 3: format(msg, sizeof(msg), "Launch Control установлен");
            case 13: format(msg, sizeof(msg), "Дальний свет установлен");
            case 28, 29, 30, 31, 32: format(msg, sizeof(msg), "Стробоскопы установлены");
            case 4, 9, 14, 19, 24: format(msg, sizeof(msg), "Прошивка Comfort установлена");
            case 5, 10, 15, 20, 25: format(msg, sizeof(msg), "Прошивка Sport установлена");
            case 6, 11, 16, 21, 26: format(msg, sizeof(msg), "Прошивка Drift установлена");
            case 7, 12, 17, 22, 27: format(msg, sizeof(msg), "Прошивка Sport+ установлена");
            default: format(msg, sizeof(msg), "Деталь установлена");
        }
    }

    ShowNotificationSander(playerid, 1, 4, 1, 1, msg, "");
    return 1;
}

stock Tuning_OpenCommon(playerid, window_type)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{FF0000}Вы должны быть в машине!");

    g_TuningLastVehicle[playerid] = vehicleid;

    new slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return SendClientMessage(playerid, -1, "{FF0000}Это не ваш личный транспорт!");

    new price = Tuning_GetVehiclePrice(vehicleid);
    new Node:tuning_json = JSON_Object();
    new name[64];
    Tuning_GetVehicleName(vehicleid, name, sizeof(name));

    InStailing[playerid] = (window_type == TUNING_SHOP_STYLING);
    g_TuningType[playerid] = window_type;

    if(window_type == TUNING_SHOP_STYLING)
    {
        Tuning_ResetStylePreview(playerid, slot);
        Tuning_ApplyStylePreview(playerid, vehicleid, slot);
    }

    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", window_type);
    JSON_SetInt(tuning_json, "j", price);
    JSON_SetInt(tuning_json, "s", 5);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", name);
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(tuning_json, "r", GetPlayerMoneyEx(playerid));

    if(window_type == TUNING_SHOP_STYLING)
    {
        new Node:styling_k_array = JSON_Array();

        if(GetOwnableCarData(slot, OC_TUNE_DALNIYSVET) > 0)
        {
            styling_k_array = Tuning_AppendInstalledState(styling_k_array, 13);
        }

        new vinyl_val = GetOwnableCarData(slot, OC_TUNE_VINYL);
        if(vinyl_val >= 0 && vinyl_val < sizeof(VinylNames))
        {
            styling_k_array = Tuning_AppendInstalledState(styling_k_array, vinyl_val);
        }

        new strob_val = GetOwnableCarData(slot, OC_TUNE_STROB);
        if(strob_val >= 0 && strob_val <= 4)
        {
            styling_k_array = Tuning_AppendInstalledState(styling_k_array, (strob_val == 4) ? 32 : (28 + strob_val));
        }

        JSON_SetArray(tuning_json, "k", styling_k_array);
    }

    if(window_type == TUNING_SHOP_TIRES)
    {
        JSON_SetFloat(tuning_json, "wh_rad", GetOwnableCarData(slot, OC_TUNE_WHEEL_RADIUS));
        JSON_SetFloat(tuning_json, "wh_wf", GetOwnableCarData(slot, OC_TUNE_WHEEL_WIDTH_FRONT));
        JSON_SetFloat(tuning_json, "wh_wr", GetOwnableCarData(slot, OC_TUNE_WHEEL_WIDTH_REAR));
        JSON_SetFloat(tuning_json, "wh_of", GetOwnableCarData(slot, OC_TUNE_OFFSET_FRONT));
        JSON_SetFloat(tuning_json, "wh_or", GetOwnableCarData(slot, OC_TUNE_OFFSET_REAR));
        JSON_SetFloat(tuning_json, "wh_cf", GetOwnableCarData(slot, OC_TUNE_CAMBER_FRONT));
        JSON_SetFloat(tuning_json, "wh_cr", GetOwnableCarData(slot, OC_TUNE_CAMBER_REAR));
        JSON_SetFloat(tuning_json, "wh_clr", GetOwnableCarData(slot, OC_TUNE_CLEARANCE));
        JSON_SetInt(tuning_json, "hydra", GetOwnableCarData(slot, OC_TUNE_HYDRA));
        JSON_SetInt(tuning_json, "pnevmo", GetOwnableCarData(slot, OC_TUNE_PNEVMO));
    }

    if(window_type == TUNING_SHOP_TECH)
    {
        new Node:k_array = JSON_Array();
        static const part_ids[4][5] = {
            {4, 9, 14, 19, 24},
            {5, 10, 15, 20, 25},
            {7, 12, 17, 22, 27},
            {6, 11, 16, 21, 26}
        };
        new part_values[4];
        part_values[0] = GetOwnableCarData(slot, OC_TUNE_COMFORT);
        part_values[1] = GetOwnableCarData(slot, OC_TUNE_SPORT);
        part_values[2] = GetOwnableCarData(slot, OC_TUNE_SPORT_PLUS);
        part_values[3] = GetOwnableCarData(slot, OC_TUNE_DRIFT);

        for(new i = 0; i < 4; i++)
        {
            for(new p = 1; p <= 5; p++)
            {
                if(IsPartInstalled(part_values[i], p))
                {
                    k_array = Tuning_AppendInstalledState(k_array, part_ids[i][p - 1]);
                }
            }
        }

        new nitro_val = GetOwnableCarData(slot, OC_TUNE_NITRO);
        if(nitro_val >= 1 && nitro_val <= 3)
        {
            k_array = Tuning_AppendInstalledState(k_array, nitro_val - 1);
        }

        if(GetOwnableCarData(slot, OC_TUNE_LAUNCH_CONTROL) > 0)
        {
            k_array = Tuning_AppendInstalledState(k_array, 3);
        }

        JSON_SetArray(tuning_json, "k", k_array);
    }

    if(window_type == TUNING_SHOP_TIRES)
    {
        SetPlayerInterior(playerid, TUNING_TIRES_INTERIOR);
        SetPlayerVirtualWorld(playerid, TUNING_TIRES_WORLD);
        SetVehicleVirtualWorld(vehicleid, TUNING_TIRES_WORLD);
        LinkVehicleToInterior(vehicleid, TUNING_TIRES_INTERIOR);
    }
    else
    {
        SetPlayerInterior(playerid, 1);
        SetVehicleVirtualWorld(vehicleid, playerid + 1000);
        SetPlayerVirtualWorld(playerid, playerid + 1000);
        LinkVehicleToInterior(vehicleid, 1);
    }

    switch(window_type)
    {
        case 0:
        {
            SetVehiclePos(vehicleid, 1000.0, 1500.0, 1498.0);
            SetVehicleZAngle(vehicleid, 180.0);
            SetPlayerCameraPos(playerid, 1003.9196, 1493.9724, 1499.7500);
            SetPlayerCameraLookAt(playerid, 1003.3480, 1494.7935, 1499.5002);
        }
        case 2:
        {
            new tire_entry = random(sizeof(g_TuningEnter2));
            SetVehiclePos(vehicleid, g_TuningEnter2[tire_entry][0], g_TuningEnter2[tire_entry][1], g_TuningEnter2[tire_entry][2]);
            SetVehicleZAngle(vehicleid, g_TuningEnter2[tire_entry][3]);
            SetPlayerCameraPos(playerid, 1732.500000, 2447.500000, 16.200000);
            SetPlayerCameraLookAt(playerid, g_TuningEnter2[tire_entry][0], g_TuningEnter2[tire_entry][1], g_TuningEnter2[tire_entry][2]);
        }
        case 3:
        {
            SetVehiclePos(vehicleid, 996.1070, 999.4791, 1000.5);
            SetVehicleZAngle(vehicleid, -90.0);
            SetPlayerCameraPos(playerid, 1001.1626, 1002.8044, 1000.9689);
            SetPlayerCameraLookAt(playerid, 1000.3796, 1002.1858, 1001.0136);
        }
    }

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

CMD:tungui(playerid, params[])
{
    #pragma unused params
    return Tuning_OpenCommon(playerid, 0);
}

CMD:shinka(playerid, params[])
{
    #pragma unused params
    return Tuning_OpenCommon(playerid, 2);
}

CMD:techcentergui(playerid, params[])
{
    #pragma unused params
    return Tuning_OpenCommon(playerid, 3);
}

CMD:tungui1(playerid, params[])
{
    #pragma unused params
    return Tuning_OpenCommon(playerid, 0);
}

stock ShowTuningStylingGUI(playerid)
{
    return Tuning_OpenCommon(playerid, 0);
}


stock Node:Tuning_AppendInstalledState(Node:k_array, detail_id)
{
    k_array = JSON_Append(k_array, JSON_Array(JSON_Int(detail_id)));
    k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2)));
    return k_array;
}

stock Tuning_SetDetailResponse(Node:tuning_response, playerid, detal_id)
{
    new client_detail = Tuning_GetClientDetailID(detal_id);

    JSON_SetInt(tuning_response, "t", 7);
    JSON_SetInt(tuning_response, "w", g_TuningType[playerid]);
    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
    JSON_SetInt(tuning_response, "p", client_detail);
    JSON_SetInt(tuning_response, "d", client_detail);
    JSON_SetInt(tuning_response, "v", 2);
    JSON_SetInt(tuning_response, "s", 1);

    new Node:k_array = JSON_Array();
    k_array = Tuning_AppendInstalledState(k_array, client_detail);
    JSON_SetArray(tuning_response, "k", k_array);
    return 1;
}

stock Tuning_ApplyNitroComponent(vehicleid, nitro_type)
{
    if(!IsValidVehicle(vehicleid)) return 0;

    // Nitro is a normal GTA component. Re-apply only this component and do not touch
    // neon/high-light/stroboscope RPCs, otherwise lights could appear after nitro install.
    RemoveVehicleComponent(vehicleid, 1008);
    RemoveVehicleComponent(vehicleid, 1009);
    RemoveVehicleComponent(vehicleid, 1010);

    switch(nitro_type)
    {
        case 1: AddVehicleComponent(vehicleid, 1009);
        case 2: AddVehicleComponent(vehicleid, 1008);
        case 3: AddVehicleComponent(vehicleid, 1010);
    }
    return 1;
}

stock Tuning_ApplyRealtimePaintAndVinyl(playerid, vehicleid, slot)
{
    #pragma unused playerid
    if(vehicleid == INVALID_VEHICLE_ID || slot == -1) return 0;

    new body_color = Tuning_GetOwnableBodyColorForRPC(slot);
    new disk_color = Tuning_GetOwnableDiskColorForRPC(slot);
    new vinyl_id = GetOwnableCarData(slot, OC_TUNE_VINYL);

    // Set vinyl id BEFORE the color RPC. SetVehicleColorForPlayer uses viVinyl
    // to keep vinyl remap colors neutral and prevents blue/black tinting.
    vInfo[vehicleid][viVinyl] = vinyl_id;
    vInfo[vehicleid][viBodyColor] = GetOwnableCarData(slot, OC_TUNE_BODY_COLOR);
    vInfo[vehicleid][viDiskColor] = GetOwnableCarData(slot, OC_TUNE_DISK_COLOR);
    vInfo[vehicleid][vBodyColor] = vInfo[vehicleid][viBodyColor];
    vInfo[vehicleid][vDiskColor] = vInfo[vehicleid][viDiskColor];

    SetVehicleColor(vehicleid, body_color, disk_color, 1);

    if(vinyl_id >= 0 && vinyl_id < sizeof(VinylNames) && strlen(VinylNames[vinyl_id]) > 0)
    {
        SetVehicleVinyl(vehicleid, VinylNames[vinyl_id], 1);
    }
    else
    {
        format(vInfo[vehicleid][viVinylTexture], 16, "");
        SetVehicleVinyl(vehicleid, "remapvehicles", 1);
    }
    return 1;
}
stock Tuning_ApplyRealtimeToner(vehicleid, slot)
{
    if(vehicleid == INVALID_VEHICLE_ID || slot == -1) return 0;

    vInfo[vehicleid][viTonerFront] = GetOwnableCarData(slot, OC_TUNE_WIND_FRONT);
    vInfo[vehicleid][viTonerRear] = GetOwnableCarData(slot, OC_TUNE_WIND_REAR);
    vInfo[vehicleid][viTonerFrontSide] = GetOwnableCarData(slot, OC_TUNE_WIND_FRONT);
    vInfo[vehicleid][viTonerRearSide] = GetOwnableCarData(slot, OC_TUNE_WIND_REAR);
    vInfo[vehicleid][vWindFront] = vInfo[vehicleid][viTonerFront];
    vInfo[vehicleid][vWindRear] = vInfo[vehicleid][viTonerRear];

    SetVehicleTonerRPC(vehicleid, vInfo[vehicleid][viTonerFront], vInfo[vehicleid][viTonerRear], vInfo[vehicleid][viTonerFrontSide], vInfo[vehicleid][viTonerRearSide], 1);
    return 1;
}

stock Tuning_ApplyRealtimeNeon(vehicleid, slot)
{
    if(vehicleid == INVALID_VEHICLE_ID || slot == -1) return 0;

    vInfo[vehicleid][viNeon1] = GetOwnableCarData(slot, OC_TUNE_NEON_MAIN);
    vInfo[vehicleid][viNeon2] = GetOwnableCarData(slot, OC_TUNE_NEON_1);
    vInfo[vehicleid][viNeon3] = GetOwnableCarData(slot, OC_TUNE_NEON_2);
    vInfo[vehicleid][vNeonMain] = vInfo[vehicleid][viNeon1];
    vInfo[vehicleid][vNeon1] = vInfo[vehicleid][viNeon2];
    vInfo[vehicleid][vNeon2] = vInfo[vehicleid][viNeon3];

    SetVehicleLightingColor(vehicleid, vInfo[vehicleid][viNeon1], vInfo[vehicleid][viNeon2], vInfo[vehicleid][viNeon3], 1);
    return 1;
}

stock Tuning_ApplyRealtimeLightColor(vehicleid, slot)
{
    if(vehicleid == INVALID_VEHICLE_ID || slot == -1) return 0;

    vInfo[vehicleid][viLightColor] = GetOwnableCarData(slot, OC_TUNE_LIGHTS_COLOR);
    vInfo[vehicleid][vLightColor] = vInfo[vehicleid][viLightColor];
    SetVehicleLightColor(vehicleid, vInfo[vehicleid][viLightColor], 1);
    return 1;
}

stock Tuning_ApplyRealtimeStyling(playerid, vehicleid, slot)
{
    if(vehicleid == INVALID_VEHICLE_ID || slot == -1) return 0;

    Tuning_ApplyRealtimePaintAndVinyl(playerid, vehicleid, slot);
    Tuning_ApplyRealtimeToner(vehicleid, slot);
    Tuning_ApplyRealtimeNeon(vehicleid, slot);
    Tuning_ApplyRealtimeLightColor(vehicleid, slot);

    vInfo[vehicleid][viHighLights] = GetOwnableCarData(slot, OC_TUNE_DALNIYSVET);
    vInfo[vehicleid][vHighLights] = vInfo[vehicleid][viHighLights];
    vInfo[vehicleid][viStrob] = GetOwnableCarData(slot, OC_TUNE_STROB);
    vInfo[vehicleid][vStrob] = (vInfo[vehicleid][viStrob] >= 0) ? (vInfo[vehicleid][viStrob] + 1) : 0;

    // Do not force-enable high beam or stroboscope after buying. They are toggled from radial menu.
    if(!GetOwnableCarData(slot, OC_TUNE_DALNIYSVET_STATE)) SetVehicleHighLight(vehicleid, 0);
    if(!GetOwnableCarData(slot, OC_TUNE_STROB_STATE)) SetVehicleStroboscope(vehicleid, 5);
    return 1;
}

stock Tuning_ApplyRealtimeTech(playerid, vehicleid, slot)
{
    #pragma unused playerid
    if(vehicleid == INVALID_VEHICLE_ID || slot == -1) return 0;

    Tuning_ApplyNitroComponent(vehicleid, GetOwnableCarData(slot, OC_TUNE_NITRO));

    vInfo[vehicleid][viLaunchControl] = GetOwnableCarData(slot, OC_TUNE_LAUNCH_CONTROL);
    vInfo[vehicleid][vLaunchControl] = (vInfo[vehicleid][viLaunchControl] > 0);
    // Лаунч-контроль не включается при загрузке машины, а только через старую радиалку.

    Tuning_UpdateSportPlusRuntime(vehicleid, GetOwnableCarData(slot, OC_TUNE_SPORT_PLUS));

    if(GetOwnableCarData(slot, OC_TUNE_COMFORT_ACTIVE)) SetVehicleAccelerationBR(vehicleid, 31.8);
    else if(GetOwnableCarData(slot, OC_TUNE_SPORT_ACTIVE)) SetVehicleAccelerationBR(vehicleid, 35.0);
    else if(GetOwnableCarData(slot, OC_TUNE_SPORT_PLUS_ACTIVE)) SetVehicleAccelerationBR(vehicleid, 36.0);
    else SetVehicleAccelerationBR(vehicleid, 0.0);

    SetVehicleDrift(vehicleid, bool:GetOwnableCarData(slot, OC_TUNE_DRIFT_ACTIVE));
    return 1;
}

stock Tuning_SaveAndSyncVehicle(playerid, vehicleid, slot)
{
    if(vehicleid == INVALID_VEHICLE_ID || slot == -1) return 0;

    Tuning_CaptureRuntimeStateToOwnable(vehicleid);
    SaveFreshVehicleTuning(vehicleid);
    Tuning_ApplyRealtimeStyling(playerid, vehicleid, slot);
    Tuning_ApplyRealtimeTech(playerid, vehicleid, slot);
    Tuning_SaveAndSyncRuntimeVehicle(vehicleid);
    return 1;
}

stock CloseTuningGUI(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        vehicleid = g_TuningLastVehicle[playerid];
    }

    if(IsValidVehicle(vehicleid))
    {
        new slot = GetOwnableCarIDByVehicleID(vehicleid);
        if(g_TuningType[playerid] == TUNING_SHOP_STYLING && slot != -1)
        {
            // Возвращаем неоплаченный предпросмотр, но купленные значения сохраняем.
            Tuning_ResetStylePreview(playerid, slot);
            Tuning_ApplyRealtimeStyling(playerid, vehicleid, slot);
        }
        Tuning_CaptureRuntimeStateToOwnable(vehicleid);
        SaveVehicleTuning(vehicleid);
        Tuning_SaveAndSyncRuntimeVehicle(vehicleid);
    }

    new Float:x, Float:y, Float:z, Float:a;

    switch(g_TuningType[playerid])
    {
        case TUNING_SHOP_TECH:
        {
            x = g_TechCenterExit[0][0];
            y = g_TechCenterExit[0][1];
            z = g_TechCenterExit[0][2];
            a = g_TechCenterExit[0][3];
        }
        case TUNING_SHOP_TIRES:
        {
            x = TUNING_TIRES_EXIT_X;
            y = TUNING_TIRES_EXIT_Y;
            z = TUNING_TIRES_EXIT_Z;
            a = TUNING_TIRES_EXIT_A;
        }
        default:
        {
            x = 2296.146240;
            y = -2613.668457;
            z = 21.829063;
            a = 90.0;
        }
    }

    TogglePlayerControllable(playerid, 1);
    SetCameraBehindPlayer(playerid);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);

    if(IsValidVehicle(vehicleid))
    {
        SetVehicleVirtualWorld(vehicleid, 0);
        LinkVehicleToInterior(vehicleid, 0);
        SetVehiclePos(vehicleid, x, y, z);
        SetVehicleZAngle(vehicleid, a);
        PutPlayerInVehicle(playerid, vehicleid, 0);
        SyncVehicleTuningForPlayer(playerid, vehicleid);
    }
    else
    {
        SetPlayerPos(playerid, x, y, z);
        SetPlayerFacingAngle(playerid, a);
    }

    g_TuningType[playerid] = 0;
    InStailing[playerid] = false;
    g_TuningLastVehicle[playerid] = INVALID_VEHICLE_ID;
    return 1;
}

stock BuyPart(playerid, vehicleid, detal_id)
{
    new slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;

    detal_id = Tuning_NormalizeDetailID(detal_id);

    new type, part_num, add_val, current_val;
    switch(detal_id)
    {
        case 4:  { type = 3; part_num = 1; add_val = 1; }
        case 9:  { type = 3; part_num = 2; add_val = 20; }
        case 14: { type = 3; part_num = 3; add_val = 300; }
        case 19: { type = 3; part_num = 4; add_val = 4000; }
        case 24: { type = 3; part_num = 5; add_val = 50000; }
        case 5:  { type = 1; part_num = 1; add_val = 1; }
        case 10: { type = 1; part_num = 2; add_val = 20; }
        case 15: { type = 1; part_num = 3; add_val = 300; }
        case 20: { type = 1; part_num = 4; add_val = 4000; }
        case 25: { type = 1; part_num = 5; add_val = 50000; }
        case 6:  { type = 2; part_num = 1; add_val = 1; }
        case 11: { type = 2; part_num = 2; add_val = 20; }
        case 16: { type = 2; part_num = 3; add_val = 300; }
        case 21: { type = 2; part_num = 4; add_val = 4000; }
        case 26: { type = 2; part_num = 5; add_val = 50000; }
        case 7:  { type = 4; part_num = 1; add_val = 1; }
        case 12: { type = 4; part_num = 2; add_val = 20; }
        case 17: { type = 4; part_num = 3; add_val = 300; }
        case 22: { type = 4; part_num = 4; add_val = 4000; }
        case 27: { type = 4; part_num = 5; add_val = 50000; }
        case 0..2: { type = 5; part_num = detal_id; add_val = detal_id + 1; }
        default: return 0;
    }

    new col_name[20];
    if(type == 1) { current_val = GetOwnableCarData(slot, OC_TUNE_SPORT); format(col_name, sizeof(col_name), "sport"); }
    else if(type == 2) { current_val = GetOwnableCarData(slot, OC_TUNE_DRIFT); format(col_name, sizeof(col_name), "drift"); }
    else if(type == 3) { current_val = GetOwnableCarData(slot, OC_TUNE_COMFORT); format(col_name, sizeof(col_name), "comfort"); }
    else if(type == 4) { current_val = GetOwnableCarData(slot, OC_TUNE_SPORT_PLUS); format(col_name, sizeof(col_name), "sport_plus"); }
    else if(type == 5) { current_val = GetOwnableCarData(slot, OC_TUNE_NITRO); format(col_name, sizeof(col_name), "nitro"); }

    new new_val;
    if(type == 5)
    {
        if(current_val == add_val) return 2; // already installed, do not charge again
        new_val = add_val;
        SetOwnableCarData(slot, OC_TUNE_NITRO, new_val);
        vInfo[vehicleid][viNitro] = new_val;
    }
    else
    {
        if(IsPartInstalled(current_val, part_num)) return 2; // already installed, do not charge again
        new_val = current_val + add_val;
        if(type == 1) SetOwnableCarData(slot, OC_TUNE_SPORT, new_val);
        else if(type == 2) SetOwnableCarData(slot, OC_TUNE_DRIFT, new_val);
        else if(type == 3) SetOwnableCarData(slot, OC_TUNE_COMFORT, new_val);
        else if(type == 4)
        {
            SetOwnableCarData(slot, OC_TUNE_SPORT_PLUS, new_val);
            Tuning_UpdateSportPlusRuntime(vehicleid, new_val);
        }
    }

    new query[160];
    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `%s`='%d' WHERE `id`='%d'", col_name, new_val, GetOwnableCarData(slot, OC_SQL_ID));
    mysql_tquery(mysql, query);
    return 1;
}

stock Tuning_ProcessColor(playerid, Node:JSONObject, Node:tuning_response)
{
    if(g_TuningType[playerid] != TUNING_SHOP_STYLING) return TUNING_WRONG_STYLING;

    new vehicleid = GetPlayerVehicleID(playerid);
    new slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;

    new color_type, color_val;
    JSON_GetInt(JSONObject, "m", color_type);

    // Purchase packet commits the value that player currently sees in GUI.
    // If GUI sends a fresh color in this same packet, refresh preview first.
    Tuning_ParseStyleColor(JSONObject, color_val);
    if(color_val != 0) Tuning_SetStylePreviewValue(playerid, color_type, color_val);

    switch(color_type)
    {
        case 0: color_val = g_BRStylePreviewBody[playerid];
        case 1: color_val = g_BRStylePreviewDisk[playerid];
        case 3: color_val = g_BRStylePreviewTonerFront[playerid];
        case 4: color_val = g_BRStylePreviewTonerRear[playerid];
        case 10: color_val = g_BRStylePreviewLight[playerid];
        case 11: color_val = g_BRStylePreviewNeonMain[playerid];
        case 12: color_val = g_BRStylePreviewNeonLeft[playerid];
        case 13: color_val = g_BRStylePreviewNeonRight[playerid];
        default: return 0;
    }

    new price = Tuning_GetVehiclePrice(vehicleid), cost, query[512];
    if(color_type == 10) cost = GetDoubleCost(price);
    else if(color_type == 3 || color_type == 4) cost = GetExtraCost(price);
    else if(color_type >= 11 && color_type <= 13) cost = GetUnivCost(price);
    else cost = GetBodyPaintCost(price);

    if(GetPlayerMoneyEx(playerid) < cost) return 0;
    GivePlayerMoneyEx(playerid, -cost);

    switch(color_type)
    {
        case 0:
        {
            SetOwnableCarData(slot, OC_TUNE_BODY_COLOR, color_val);
            mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_body_color`=%d,`body_color`=%d,`color_1`=%d WHERE `id`=%d", color_val, color_val, color_val, GetOwnableCarData(slot, OC_SQL_ID));
        }
        case 1:
        {
            SetOwnableCarData(slot, OC_TUNE_DISK_COLOR, color_val);
            mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_disk_color`=%d,`disk_color`=%d,`color_2`=%d WHERE `id`=%d", color_val, color_val, color_val, GetOwnableCarData(slot, OC_SQL_ID));
        }
        case 10:
        {
            SetOwnableCarData(slot, OC_TUNE_LIGHTS_COLOR, color_val);
            mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_lights_color`=%d,`l_color`=%d WHERE `id`=%d", color_val, color_val, GetOwnableCarData(slot, OC_SQL_ID));
        }
        case 3:
        {
            SetOwnableCarData(slot, OC_TUNE_WIND_FRONT, color_val);
            mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_toner_front`=%d,`tuning_toner_front_side`=%d,`pered_windcolor`=%d WHERE `id`=%d", color_val, color_val, color_val, GetOwnableCarData(slot, OC_SQL_ID));
        }
        case 4:
        {
            SetOwnableCarData(slot, OC_TUNE_WIND_REAR, color_val);
            mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_toner_rear`=%d,`tuning_toner_rear_side`=%d,`zadni_windcolor`=%d WHERE `id`=%d", color_val, color_val, color_val, GetOwnableCarData(slot, OC_SQL_ID));
        }
        case 11, 12, 13:
        {
            if(color_type == 11) SetOwnableCarData(slot, OC_TUNE_NEON_MAIN, color_val);
            else if(color_type == 12) SetOwnableCarData(slot, OC_TUNE_NEON_1, color_val);
            else SetOwnableCarData(slot, OC_TUNE_NEON_2, color_val);

            mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_neon1`=%d,`tuning_neon2`=%d,`tuning_neon3`=%d,`neon_main`=%d,`neon1`=%d,`neon2`=%d WHERE `id`=%d",
                GetOwnableCarData(slot, OC_TUNE_NEON_MAIN),
                GetOwnableCarData(slot, OC_TUNE_NEON_1),
                GetOwnableCarData(slot, OC_TUNE_NEON_2),
                GetOwnableCarData(slot, OC_TUNE_NEON_MAIN),
                GetOwnableCarData(slot, OC_TUNE_NEON_1),
                GetOwnableCarData(slot, OC_TUNE_NEON_2),
                GetOwnableCarData(slot, OC_SQL_ID));
        }
    }

    mysql_tquery(mysql, query);
    Tuning_ResetStylePreview(playerid, slot);
    Tuning_ApplyStylePreview(playerid, vehicleid, slot);
    SaveFreshVehicleTuning(vehicleid);

    JSON_SetInt(tuning_response, "t", 1);
    JSON_SetInt(tuning_response, "s", 1);
    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
    return 1;
}
stock Tuning_ProcessWheel(playerid, Node:JSONObject, Node:tuning_response, type)
{
    if(g_TuningType[playerid] != TUNING_SHOP_TIRES) return TUNING_WRONG_TIRES;

    new vehicleid = GetPlayerVehicleID(playerid);
    new slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;

    new Float:fval, ival, bool:is_float = true, col_name[32], price;
    new model_price = Tuning_GetVehiclePrice(vehicleid);

    switch(type)
    {
        case 20: { JSON_GetFloat(JSONObject, "v", fval); format(col_name, sizeof(col_name), "wheel_radius"); price = GetShinaPrice(model_price, 0); }
        case 21: { JSON_GetFloat(JSONObject, "v", fval); format(col_name, sizeof(col_name), "wheel_width_front"); price = GetShinaPrice(model_price, 1); }
        case 22: { JSON_GetFloat(JSONObject, "v", fval); format(col_name, sizeof(col_name), "wheel_width_rear"); price = GetShinaPrice(model_price, 1); }
        case 23: { JSON_GetFloat(JSONObject, "v", fval); format(col_name, sizeof(col_name), "offset_front"); price = GetShinaPrice(model_price, 2); }
        case 24: { JSON_GetFloat(JSONObject, "v", fval); format(col_name, sizeof(col_name), "offset_rear"); price = GetShinaPrice(model_price, 2); }
        case 25: { JSON_GetFloat(JSONObject, "v", fval); format(col_name, sizeof(col_name), "camber_front"); price = GetShinaPrice(model_price, 3); }
        case 26: { JSON_GetFloat(JSONObject, "v", fval); format(col_name, sizeof(col_name), "camber_rear"); price = GetShinaPrice(model_price, 3); }
        case 27: { JSON_GetFloat(JSONObject, "v", fval); format(col_name, sizeof(col_name), "clearance"); price = GetShinaPrice(model_price, 4); }
        case 28: { JSON_GetInt(JSONObject, "v", ival); is_float = false; format(col_name, sizeof(col_name), "hydra"); price = GetShinaPrice(model_price, 5); }
        case 29: { JSON_GetInt(JSONObject, "v", ival); is_float = false; format(col_name, sizeof(col_name), "pnevmo"); price = GetShinaPrice(model_price, 6); }
        default: return 0;
    }

    if(GetPlayerMoneyEx(playerid) < price) return 0;
    GivePlayerMoneyEx(playerid, -price);

    new query[160];
    if(is_float)
    {
        mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `%s`=%f WHERE `id`=%d", col_name, fval, GetOwnableCarData(slot, OC_SQL_ID));
        if(type == 20) { SetOwnableCarData(slot, OC_TUNE_WHEEL_RADIUS, fval); vInfo[vehicleid][vRadius] = fval; SetVehicleWheelRadius(vehicleid, fval, 1); }
        else if(type == 21) { SetOwnableCarData(slot, OC_TUNE_WHEEL_WIDTH_FRONT, fval); vInfo[vehicleid][vWidthP] = fval; SetVehicleWheelWidth(vehicleid, fval, GetOwnableCarData(slot, OC_TUNE_WHEEL_WIDTH_REAR), 1); }
        else if(type == 22) { SetOwnableCarData(slot, OC_TUNE_WHEEL_WIDTH_REAR, fval); vInfo[vehicleid][vWidthZ] = fval; SetVehicleWheelWidth(vehicleid, GetOwnableCarData(slot, OC_TUNE_WHEEL_WIDTH_FRONT), fval, 1); }
        else if(type == 23) { SetOwnableCarData(slot, OC_TUNE_OFFSET_FRONT, fval); vInfo[vehicleid][vDepartureP] = fval; SetVehicleWheelDeparture(vehicleid, fval, GetOwnableCarData(slot, OC_TUNE_OFFSET_REAR), 1); }
        else if(type == 24) { SetOwnableCarData(slot, OC_TUNE_OFFSET_REAR, fval); vInfo[vehicleid][vDepartureZ] = fval; SetVehicleWheelDeparture(vehicleid, GetOwnableCarData(slot, OC_TUNE_OFFSET_FRONT), fval, 1); }
        else if(type == 25) { SetOwnableCarData(slot, OC_TUNE_CAMBER_FRONT, fval); vInfo[vehicleid][vAlignmentP] = fval; SetVehicleWheelAlignment(vehicleid, fval, GetOwnableCarData(slot, OC_TUNE_CAMBER_REAR), 1); }
        else if(type == 26) { SetOwnableCarData(slot, OC_TUNE_CAMBER_REAR, fval); vInfo[vehicleid][vAlignmentZ] = fval; SetVehicleWheelAlignment(vehicleid, GetOwnableCarData(slot, OC_TUNE_CAMBER_FRONT), fval, 1); }
        else if(type == 27) { SetOwnableCarData(slot, OC_TUNE_CLEARANCE, fval); vInfo[vehicleid][vClearance] = fval; SetVehicleClearance(vehicleid, fval, 1); }
    }
    else
    {
        mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `%s`=%d WHERE `id`=%d", col_name, ival, GetOwnableCarData(slot, OC_SQL_ID));
        if(type == 28) { SetOwnableCarData(slot, OC_TUNE_HYDRA, ival); vInfo[vehicleid][vHydraulics] = ival; SetVehicleHydraulics(vehicleid, ival, 1); }
        else if(type == 29) SetOwnableCarData(slot, OC_TUNE_PNEVMO, ival);
    }
    mysql_tquery(mysql, query);
    SaveFreshVehicleTuning(vehicleid);

    // Shinka values must be visible immediately, but should not re-send neon/high-light/strobe.
    switch(type)
    {
        case 20: SetVehicleWheelRadius(vehicleid, GetOwnableCarData(slot, OC_TUNE_WHEEL_RADIUS), 1);
        case 21, 22: SetVehicleWheelWidth(vehicleid, GetOwnableCarData(slot, OC_TUNE_WHEEL_WIDTH_FRONT), GetOwnableCarData(slot, OC_TUNE_WHEEL_WIDTH_REAR), 1);
        case 23, 24: SetVehicleWheelDeparture(vehicleid, GetOwnableCarData(slot, OC_TUNE_OFFSET_FRONT), GetOwnableCarData(slot, OC_TUNE_OFFSET_REAR), 1);
        case 25, 26: SetVehicleWheelAlignment(vehicleid, GetOwnableCarData(slot, OC_TUNE_CAMBER_FRONT), GetOwnableCarData(slot, OC_TUNE_CAMBER_REAR), 1);
        case 27: SetVehicleClearance(vehicleid, GetOwnableCarData(slot, OC_TUNE_CLEARANCE), 1);
        case 28: SetVehicleHydraulics(vehicleid, GetOwnableCarData(slot, OC_TUNE_HYDRA), 1);
    }

    JSON_SetInt(tuning_response, "t", type);
    JSON_SetInt(tuning_response, "s", 1);
    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
    return 1;
}

stock Tuning_ProcessDetail(playerid, Node:tuning_response, detal_id)
{
    detal_id = Tuning_NormalizeDetailID(detal_id);

    if(Tuning_IsStylingDetail(detal_id) && g_TuningType[playerid] != TUNING_SHOP_STYLING) return TUNING_WRONG_STYLING;
    if(Tuning_IsTechDetail(detal_id) && g_TuningType[playerid] != TUNING_SHOP_TECH) return TUNING_WRONG_TECH;

    new vehicleid = GetPlayerVehicleID(playerid);
    new slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;

    new bool:already_installed = Tuning_IsDetailInstalled(slot, detal_id);
    new price = Tuning_GetVehiclePrice(vehicleid), cost, ok;

    if(already_installed)
    {
        ok = 1;
    }
    else
    {
        switch(detal_id)
        {
            case 4, 9, 14, 19, 24:
            {
                cost = Tuning_GetDetailServerPrice(vehicleid, detal_id);
                if(GetPlayerMoneyEx(playerid) >= cost)
                {
                    new buy_result = BuyPart(playerid, vehicleid, detal_id);
                    if(buy_result)
                    {
                        if(buy_result == 1) GivePlayerMoneyEx(playerid, -cost);
                        ok = 1;
                    }
                }
            }
            case 5, 10, 15, 20, 25:
            {
                cost = Tuning_GetDetailServerPrice(vehicleid, detal_id);
                if(GetPlayerMoneyEx(playerid) >= cost)
                {
                    new buy_result = BuyPart(playerid, vehicleid, detal_id);
                    if(buy_result)
                    {
                        if(buy_result == 1) GivePlayerMoneyEx(playerid, -cost);
                        ok = 1;
                    }
                }
            }
            case 6, 11, 16, 21, 26:
            {
                cost = Tuning_GetDetailServerPrice(vehicleid, detal_id);
                if(GetPlayerMoneyEx(playerid) >= cost)
                {
                    new buy_result = BuyPart(playerid, vehicleid, detal_id);
                    if(buy_result)
                    {
                        if(buy_result == 1) GivePlayerMoneyEx(playerid, -cost);
                        ok = 1;
                    }
                }
            }
            case 7, 12, 17, 22, 27:
            {
                // Sport+ является донатной веткой: рубли тут не принимаются.
                cost = Tuning_GetDetailServerPrice(vehicleid, detal_id);
                if(GetPlayerDonateRub(playerid) >= cost)
                {
                    new buy_result = BuyPart(playerid, vehicleid, detal_id);
                    if(buy_result)
                    {
                        if(buy_result == 1) GivePlayerDonateRub(playerid, -cost, "Покупка Sport+ тюнинга", true, true);
                        ok = 1;
                    }
                }
                else Tuning_SendNoDonate(playerid);
            }
            case 0, 1, 2:
            {
                cost = Tuning_GetDetailServerPrice(vehicleid, detal_id);
                if(GetPlayerMoneyEx(playerid) >= cost)
                {
                    new buy_result = BuyPart(playerid, vehicleid, detal_id);
                    if(buy_result)
                    {
                        // Component is applied once in the final nitro-only sync block.
                        if(buy_result == 1) GivePlayerMoneyEx(playerid, -cost);
                        ok = 1;
                    }
                }
            }
            case 3:
            {
                cost = Tuning_GetDetailServerPrice(vehicleid, detal_id);
                if(GetPlayerMoneyEx(playerid) >= cost)
                {
                    GivePlayerMoneyEx(playerid, -cost);
                    SetOwnableCarData(slot, OC_TUNE_LAUNCH_CONTROL, 1);
                    vInfo[vehicleid][viLaunchControl] = 1;
                    vInfo[vehicleid][vLaunchControl] = 1;
                    vInfo[vehicleid][vEnableLaunchControl] = false;
                    // После покупки лаунч не включаем автоматически.

                    new query[128];
                    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_launch_control`=1,`launch`=1 WHERE `id`=%d", GetOwnableCarData(slot, OC_SQL_ID));
                    mysql_tquery(mysql, query);
                    ok = 1;
                }
            }
            case 28, 29, 30, 31:
            {
                cost = Tuning_GetDetailServerPrice(vehicleid, detal_id);
                if(GetPlayerMoneyEx(playerid) >= cost)
                {
                    GivePlayerMoneyEx(playerid, -cost);
                    new strobLevel = detal_id - 28;
                    SetOwnableCarData(slot, OC_TUNE_STROB, strobLevel);
                    vInfo[vehicleid][viStrob] = strobLevel;
                    vInfo[vehicleid][vStrob] = strobLevel + 1;
                    SetVehicleStroboscope(vehicleid, strobLevel, 1);
                    ok = 1;
                }
            }
            case 32:
            {
                cost = Tuning_GetDetailServerPrice(vehicleid, detal_id);
                if(GetPlayerDonateRub(playerid) >= cost)
                {
                    GivePlayerDonateRub(playerid, -cost, "Strob tuning", true, true);
                    SetOwnableCarData(slot, OC_TUNE_STROB, 4);
                    vInfo[vehicleid][viStrob] = 4;
                    vInfo[vehicleid][vStrob] = 5;
                    SetVehicleStroboscope(vehicleid, 4, 1);
                    ok = 1;
                }
            }
            case 13:
            {
                cost = Tuning_GetDetailServerPrice(vehicleid, detal_id);
                if(GetPlayerMoneyEx(playerid) >= cost)
                {
                    GivePlayerMoneyEx(playerid, -cost);
                    SetOwnableCarData(slot, OC_TUNE_DALNIYSVET, 1);
                    SetOwnableCarData(slot, OC_TUNE_DALNIYSVET_STATE, false);
                    vInfo[vehicleid][viHighLights] = 1;
                    vInfo[vehicleid][vHighLights] = 1;
                    vInfo[vehicleid][vEnableHighLights] = false;
                    SetVehicleHighLight(vehicleid, 1, 1);

                    new query[160];
                    mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_dalniysvet`=1,`fars`=1 WHERE `id`=%d", GetOwnableCarData(slot, OC_SQL_ID));
                    mysql_tquery(mysql, query);
                    ok = 1;
                }
            }
        }
    }

    if(ok)
    {
        Tuning_SetDetailResponse(tuning_response, playerid, detal_id);
        Tuning_SendInstalledNotification(playerid, detal_id, already_installed);

        SaveFreshVehicleTuning(vehicleid);

        if(detal_id >= 0 && detal_id <= 2)
        {
            // Nitro purchase/restore: only re-apply nitro component, no visual RPCs.
            Tuning_ApplyNitroComponent(vehicleid, GetOwnableCarData(slot, OC_TUNE_NITRO));
        }
        else if(detal_id == 13)
        {
            vInfo[vehicleid][viHighLights] = GetOwnableCarData(slot, OC_TUNE_DALNIYSVET);
            vInfo[vehicleid][vHighLights] = vInfo[vehicleid][viHighLights];
            if(g_TuningType[playerid] == TUNING_SHOP_STYLING) SetVehicleHighLight(vehicleid, 1);
            else if(!GetOwnableCarData(slot, OC_TUNE_DALNIYSVET_STATE)) SetVehicleHighLight(vehicleid, 0);
        }
        else if(detal_id >= 28 && detal_id <= 32)
        {
            vInfo[vehicleid][viStrob] = GetOwnableCarData(slot, OC_TUNE_STROB);
            vInfo[vehicleid][vStrob] = (vInfo[vehicleid][viStrob] >= 0) ? (vInfo[vehicleid][viStrob] + 1) : 0;
            if(g_TuningType[playerid] == TUNING_SHOP_STYLING && vInfo[vehicleid][viStrob] >= 0) SetVehicleStroboscope(vehicleid, vInfo[vehicleid][viStrob]);
            else if(!GetOwnableCarData(slot, OC_TUNE_STROB_STATE)) SetVehicleStroboscope(vehicleid, 5);
        }
        else if(Tuning_IsStylingDetail(detal_id))
        {
            Tuning_ApplyRealtimeStyling(playerid, vehicleid, slot);
        }
        else
        {
            Tuning_ApplyRealtimeTech(playerid, vehicleid, slot);
        }
    }
    return ok;
}

stock ShowTuneTest(playerid, value, const tune_name[])
{
    if(IsFullSetInstalled(value))
    {
        new msg[64];
        format(msg, sizeof(msg), "{00FF00}%s включен", tune_name);
        SendClientMessage(playerid, -1, msg);
    }
    else
    {
        new missing[64], msg[128];
        for(new p = 1; p <= 5; p++) if(!IsPartInstalled(value, p)) format(missing, sizeof(missing), "%s%d ", missing, p);
        format(msg, sizeof(msg), "{FF0000}%s не включен. Нет деталей: %s", tune_name, missing);
        SendClientMessage(playerid, -1, msg);
    }
    return 1;
}

CMD:comforton(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1 || !IsFullSetInstalled(GetOwnableCarData(slot, OC_TUNE_COMFORT))) return 0;
    SetVehicleAccelerationBR(vehicleid, 31.8);
    VehSetFlag(playerid, slot, VF_COMFORTA, true);
    VehSetFlag(playerid, slot, VF_SPORTA, false);
    VehSetFlag(playerid, slot, VF_SPORTPLUSA, false);
    return 1;
}

CMD:comfortoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;
    SetVehicleAccelerationBR(vehicleid, 0.0);
    VehSetFlag(playerid, slot, VF_COMFORTA, false);
    return 1;
}

CMD:sporton(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1 || !IsFullSetInstalled(GetOwnableCarData(slot, OC_TUNE_SPORT))) return 0;
    SetVehicleAccelerationBR(vehicleid, 35.0);
    VehSetFlag(playerid, slot, VF_SPORTA, true);
    VehSetFlag(playerid, slot, VF_COMFORTA, false);
    VehSetFlag(playerid, slot, VF_SPORTPLUSA, false);
    return 1;
}

CMD:sportoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;
    SetVehicleAccelerationBR(vehicleid, 0.0);
    VehSetFlag(playerid, slot, VF_SPORTA, false);
    return 1;
}

CMD:sportpluson(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1 || !IsFullSetInstalled(GetOwnableCarData(slot, OC_TUNE_SPORT_PLUS))) return 0;
    SetVehicleAccelerationBR(vehicleid, 36.0);
    VehSetFlag(playerid, slot, VF_SPORTPLUSA, true);
    VehSetFlag(playerid, slot, VF_COMFORTA, false);
    VehSetFlag(playerid, slot, VF_SPORTA, false);
    return 1;
}

CMD:sportplusoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;
    SetVehicleAccelerationBR(vehicleid, 0.0);
    VehSetFlag(playerid, slot, VF_SPORTPLUSA, false);
    return 1;
}

CMD:drifton(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1 || !IsFullSetInstalled(GetOwnableCarData(slot, OC_TUNE_DRIFT))) return 0;
    SetVehicleDrift(vehicleid, true);
    VehSetFlag(playerid, slot, VF_DRIFTA, true);
    return 1;
}

CMD:driftoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    if(slot == -1) return 0;
    SetVehicleDrift(vehicleid, false);
    VehSetFlag(playerid, slot, VF_DRIFTA, false);
    return 1;
}

CMD:tuningoff(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicleSlot(playerid, vehicleid);
    SetVehicleAccelerationBR(vehicleid, 0.0);
    SetVehicleDrift(vehicleid, false);
    if(slot != -1)
    {
        VehSetFlag(playerid, slot, VF_SPORTA, false);
        VehSetFlag(playerid, slot, VF_DRIFTA, false);
        VehSetFlag(playerid, slot, VF_COMFORTA, false);
        VehSetFlag(playerid, slot, VF_SPORTPLUSA, false);
    }
    return 1;
}


// Helpers required by imported BR GUI 27/28 packet handlers.
#if !defined BR_IMPORTED_GUI_PACKET_HELPERS
#define BR_IMPORTED_GUI_PACKET_HELPERS

stock TeleportToExit(playerid)
{
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, 1);
    DeletePVar(playerid, "gui_variant");
    return 1;
}

stock GetVehiclePriceByModel(modelid)
{
    new price;
    if(GetVehicleJsonCostByModelId(modelid, price)) return price;
    return GetVehicleMarketPriceByModel(modelid);
}

stock StreamingToner(playerid, vehicleid)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 0x00, PR_UINT32, vInfo[vehicleid][vWindFront], PR_UINT32, vInfo[vehicleid][vWindRear], PR_UINT32, vInfo[vehicleid][vWindFront], PR_UINT32, vInfo[vehicleid][vWindRear]);
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock StreamingVehicleColors(playerid, vehicleid)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 0x12, PR_UINT32, vInfo[vehicleid][vBodyColor], PR_UINT32, vInfo[vehicleid][vDiskColor], PR_UINT32, vInfo[vehicleid][vDiskColor], PR_UINT32, vInfo[vehicleid][vDiskColor]);
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock StreamingNeon(playerid, vehicleid)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 0x09, PR_UINT32, vInfo[vehicleid][vNeonMain], PR_UINT32, vInfo[vehicleid][vNeon2], PR_UINT32, vInfo[vehicleid][vNeon1]);
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock StreamingLighColor(playerid, vehicleid)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 0x08, PR_UINT32, vInfo[vehicleid][vLightColor]);
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SetVehicleAccelerationSander(vehicleid, Float:accel, setvalue = 0)
{
    if(setvalue) vInfo[vehicleid][vAccel] = accel;
    SetVehicleAccelerationBR(vehicleid, accel);
    return 1;
}

#endif
