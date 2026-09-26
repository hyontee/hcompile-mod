cmd:teststo(playerid, params[])
{
    new vehicleID = GetPlayerVehicleID(playerid);
    if (!vehicleID) return 1;
    
    new model = GetVehicleModel(vehicleID);
    new Node:tuning_json = JSON_Object();
    
    // Базовые настройки
    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 1);
    JSON_SetInt(tuning_json, "a", 0);
    JSON_SetInt(tuning_json, "j", 300000);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", GetVehicleNameByModel(model));
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));
    JSON_SetArray(tuning_json, "d", JSON_Array(JSON_Int(22), JSON_Int(99), JSON_Int(52)));
    
    // Настройки в зависимости от модели
    switch(model)
    {
        case 466:
        {
            JSON_SetInt(tuning_json, "s", 67);
            JSON_SetArray(tuning_json, "k", JSON_Array(
                JSON_Int(454), JSON_Int(0), JSON_Int(455), JSON_Int(0), 
                JSON_Int(456), JSON_Int(0), JSON_Int(457), JSON_Int(0), 
                JSON_Int(458), JSON_Int(0), JSON_Int(459), JSON_Int(0), 
                JSON_Int(460), JSON_Int(0), JSON_Int(461), JSON_Int(0), 
                JSON_Int(462), JSON_Int(0), JSON_Int(463), JSON_Int(0)
            ));
        }
        case 28752:
        {
            JSON_SetInt(tuning_json, "s", 546);
            JSON_SetArray(tuning_json, "k", JSON_Array(
                JSON_Int(2531), JSON_Int(0), JSON_Int(2532), JSON_Int(0), 
                JSON_Int(2533), JSON_Int(0), JSON_Int(2534), JSON_Int(0), 
                JSON_Int(2535), JSON_Int(0)
            ));
        }
        default: JSON_SetInt(tuning_json, "s", 0);
    }
    
    // Настройка позиции и камеры
    SetVehiclePos(vehicleID, 2508.3931, 1504.2278, 1497.5);
    SetVehicleZAngle(vehicleID, 0.0);
    SetPlayerCameraPos(playerid, 2501.2969, 1511.0194, 1500.2665);
    SetPlayerCameraLookAt(playerid, 2502.0427, 1510.3536, 1500.0214);
    SetPlayerInterior(playerid, 1);
    LinkVehicleToInterior(vehicleID, 1);
    SetPVarInt(playerid, "gui_variant", 1);
    
    ShowPlayerGUI(playerid, 28, tuning_json);
    return 1;
}


stock SaveTuningPart(playerid, partIndex, value)
{
    new vehicleid = GetPlayerOwnableCar(playerid);
    new idx = GetPVarInt(playerid, "ownablecar_id");
    new query[128];
    new field[64];
    
    switch(partIndex)
    {
        case vBumpPered: field = "bumper_pered";
        case vBumpZad: field = "bumper_zad";
        case vSpoiler: field = "spoiler";
        case vVihlop: field = "obves_vihlop";
        case vKapot: field = "kapot";
        case vBagazh: field = "bagaznhik";
        case vPeredArki: field = "arki_pered";
        case vZadArki: field = "arki_zad";
        case vPeredNaklad: field = "nakladki_pered";
        case vZadNaklad: field = "nakladki_zad";
        case vPorogi: field = "porogi";
        case vReshetka: field = "reshetka";
        case vKrisha: field = "krisha";
        case vRashirenie_dverey_zad_rear: field = "rashirenie_dverey_zad_rear";
        case vRashirenie_dverey_zad_left: field = "rashirenie_dverey_zad_left";
        default: return 0;
    }
    vInfo[vehicleid][partIndex] = value;
    
    mysql_format(mysql, query, sizeof(query), 
        "UPDATE ownable_cars SET %s = %d WHERE id = %d", 
        field, 
        value, 
        idx);
    
    mysql_tquery(mysql, query, "", "");
    return 1;
}

stock SetVehicleBodyKits(playerid, vehicleid)
{
    if(vInfo[vehicleid][vBumpPered] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vBumpPered]);
    if(vInfo[vehicleid][vBumpZad] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vBumpZad]);
    if(vInfo[vehicleid][vSpoiler] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vSpoiler]);
    if(vInfo[vehicleid][vVihlop] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vVihlop]);
    if(vInfo[vehicleid][vKapot] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vKapot]);
    if(vInfo[vehicleid][vBagazh] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vBagazh]);
    if(vInfo[vehicleid][vPeredArki] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vPeredArki]);
    if(vInfo[vehicleid][vZadArki] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vZadArki]);
    if(vInfo[vehicleid][vPeredNaklad] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vPeredNaklad]);
    if(vInfo[vehicleid][vZadNaklad] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vZadNaklad]);
    if(vInfo[vehicleid][vPorogi] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vPorogi]);
    if(vInfo[vehicleid][vReshetka] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vReshetka]);
    if(vInfo[vehicleid][vKrisha] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vKrisha]);
    if(vInfo[vehicleid][vRashirenie_dverey_zad_rear] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vRashirenie_dverey_zad_rear]);
    if(vInfo[vehicleid][vRashirenie_dverey_zad_left] > 0) SetVehicleComponentFP(playerid, vehicleid, vInfo[vehicleid][vRashirenie_dverey_zad_left]);
    
    return 1;
}

stock LoadBodyKits(playerid)
{
    LoadTuningPart(playerid, "bumper_pered", vBumpPered);
    LoadTuningPart(playerid, "bumper_zad", vBumpZad);
    LoadTuningPart(playerid, "spoiler", vSpoiler);
    LoadTuningPart(playerid, "obves_vihlop", vVihlop);
    LoadTuningPart(playerid, "kapot", vKapot);
    LoadTuningPart(playerid, "bagaznhik", vBagazh);
    LoadTuningPart(playerid, "arki_pered", vPeredArki);
    LoadTuningPart(playerid, "arki_zad", vZadArki);
    LoadTuningPart(playerid, "nakladki_pered", vPeredNaklad);
    LoadTuningPart(playerid, "nakladki_zad", vZadNaklad);
    LoadTuningPart(playerid, "porogi", vPorogi);
    LoadTuningPart(playerid, "reshetka", vReshetka);
    LoadTuningPart(playerid, "krisha", vKrisha);
    LoadTuningPart(playerid, "rashirenie_dverey_zad_rear", vRashirenie_dverey_zad_rear);
    LoadTuningPart(playerid, "rashirenie_dverey_zad_left", vRashirenie_dverey_zad_left);
    
    return 1;
}

stock LoadTuningPart(playerid, const field[], partIndex)
{
    new vehicleid = GetPlayerOwnableCar(playerid);
    new idx = GetPVarInt(playerid, "ownablecar_id");
    new Cache: result;
    new query[128];
    
    mysql_format(mysql, query, sizeof(query), "SELECT %s FROM ownable_cars WHERE id='%d'", field, idx);
    result = mysql_query(mysql, query, true);
    
    if(cache_num_rows())
    {
        vInfo[vehicleid][partIndex] = cache_get_field_content_int(0, field);
    }
    
    cache_delete(result);
    return 1;
}