LoadArendsVehicle(idx)
{
    new biz_id = idx - 116, vehicleid;
    for(new i = 0; i < MAX_ARENDS_VEHICLE; i++)
    {
        if(ArendsVehicleCoords[biz_id][i][0] == 0.0) continue;
        vehicleid = CreateVehicleVEx(NPO_ARENDCAR, NPO_NONE, GetVehicleArendsVehicleIDx(b_info[idx][b_upgrade_class]), ArendsVehicleCoords[biz_id][i][0], ArendsVehicleCoords[biz_id][i][1], ArendsVehicleCoords[biz_id][i][2], ArendsVehicleCoords[biz_id][i][3], -1, -1, 600);
        CreateDynamic3DTextLabel("<< Транспорт для аренды >>", COLOR_MAIN, 0.0, 0.0, 1.5, 10.0, INVALID_PLAYER_ID, vehicleid, streamer_TESTLOL);
        veh_info[vehicleid][v_arends_vehicle_idx] = idx;
        LinkVehicleToInterior(vehicleid, 0);
        SetVehicleVirtualWorld(vehicleid, 0);
    }
    return 1;
}

GetVehicleArendsVehicleIDx(class)
{
    new idx = 0;
    for(new i = 0; i < 212; i++)
    {
        idx = random(212);
        if(GetVehicleData(idx, E_VD_TYPE) > VEHICLE_STATE_CAR) continue;
        if(GetVehicleData(idx, E_VD_CLASS) != class) continue;
        if(GetVehicleData(idx, E_VD_CLASS) == VEHICLE_CLASS_UNIQUE) continue;
        if(GetVehicleData(idx, E_VD_PRICE) > 5000000) continue;
        return GetVehicleData(idx, E_VD_ID);
    }
    return GetVehicleData(idx, E_VD_ID);
}