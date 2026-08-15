#if defined _BR_DEATH_EARLY_API_INC_

    #endinput

#endif

#define _BR_DEATH_EARLY_API_INC_



#if !defined _BR_SCOOTER_RENT_VEH_EARLY_

    #define _BR_SCOOTER_RENT_VEH_EARLY_

    new gScooterRentVehicle[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};

#endif



stock SetVehicleSpeedometerInfoFP(playerid, vehicleid, Float:fuel = 52.0, Float:mileage = 1488.0)

{

    new BitStream:bitstream = BS_New();

    if(!bitstream) return 0;

    BS_WriteValue(bitstream, PR_UINT16, vehicleid);

    BS_WriteValue(bitstream, PR_UINT8, 14);

    BS_WriteValue(bitstream, PR_UINT32, _:fuel);

    BS_WriteValue(bitstream, PR_UINT32, _:mileage);

    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);

    BS_Delete(bitstream);

    return 1;

}



stock GetPlayerVehicleSlot(playerid, vehicleid)

{

    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)

    {

        if(VehicleInfo[playerid][i][vID] == vehicleid) return i;

    }

    return -1;

}



stock InvalidateVehicleOwnerCache(vehicleid)

{

    if(vehicleid < 0 || vehicleid >= MAX_VEHICLES) return 0;

    gVehOwnerCache[vehicleid] = -1;

    gVehSlotCache[vehicleid] = -1;

    return 1;

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



stock GetVehiclePriceByModel(modelid)

{

    for(new i = 0; i < sizeof(LowSalonCars); i++)

    {

        if(LowSalonCars[i][sModel] == modelid) return LowSalonCars[i][sPrice];

    }

    for(new i = 0; i < sizeof(MediumSalonCars); i++)

    {

        if(MediumSalonCars[i][sModel] == modelid) return MediumSalonCars[i][sPrice];

    }

    for(new i = 0; i < sizeof(SalonCars); i++)

    {

        if(SalonCars[i][sModel] == modelid) return SalonCars[i][sPrice];

    }

    return 0;

}



stock PV_ApplyVehiclePaintPlrValues(forplayerid, vehicleid, body, disk)

{

    if(!IsPlayerConnected(forplayerid)) return 0;

    if(vehicleid == INVALID_VEHICLE_ID || !GetVehicleModel(vehicleid)) return 0;

    if(body == 0 && disk == 0) return 0;



    new BitStream:bs = BS_New();

    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 0x12,

        PR_UINT32, body, PR_UINT32, disk, PR_UINT32, disk, PR_UINT32, disk);

    PR_SendRPC(bs, forplayerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);

    BS_Delete(bs);

    return 1;

}



stock UpdateVehicleTint(playerid, vehicleid, front, rear)

{

    if(!IsPlayerConnected(playerid)) return 0;

    new BitStream:bs = BS_New();

    BS_WriteValue(bs,

        PR_UINT16, vehicleid,

        PR_UINT8,  0x00,

        PR_UINT32, front,

        PR_UINT32, rear,

        PR_UINT32, front,

        PR_UINT32, rear

    );

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);

    BS_Delete(bs);

    return 1;

}



stock PlayAudioStreamURL(playerid, const url[])

{

    new BitStream:bs = BS_New();

    new len = strlen(url);



    BS_WriteValue(bs, PR_INT32, 1);

    BS_WriteValue(bs, PR_UINT8, len);

    BS_WriteValue(bs, PR_STRING, url);

    BS_WriteValue(bs, PR_INT32, 0);

    BS_WriteValue(bs, PR_FLOAT, 1.0);

    BS_WriteValue(bs, PR_UINT8, 0);



    PR_SendRPC(bs, playerid, 41, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);

    BS_Delete(bs);

    return 1;

}



stock bool:ScooterRent_IsPlayerVehicle(playerid, vehicleid)

{

    if(playerid < 0 || playerid >= MAX_PLAYERS) return false;

    if(vehicleid == INVALID_VEHICLE_ID || vehicleid <= 0) return false;

    if(gScooterRentVehicle[playerid] != vehicleid) return false;

    return GetVehicleModel(vehicleid) != 0;

}

#if !defined GPS_WAYPOINT_ID
    #define GPS_WAYPOINT_ID       (0)
    #define GPS_WAYPOINT_ICON     (85)
    #define GPS_WAYPOINT_COLOR    (27)
    #define GPS_WAYPOINT_DIST     (30000.0)
    #define GPS_POINT_COLOR       (0xFF5252FF)
    #define GPS_MAP_ICON_SLOT     (50)
#endif

forward SendCreateWayPoint(playerid, waypoint_id, Float:x, Float:y, Float:z, icon_id, color, Float:dist, interior);
forward SendDestroyWayPoint(playerid, waypoint_id);

stock GPS_SetDestination(playerid, Float:x, Float:y, Float:z, icon_id = 85, interior = 0)
{
    if(!IsPlayerConnected(playerid)) return 0;

    SendDestroyWayPoint(playerid, GPS_WAYPOINT_ID);
    SendCreateWayPoint(playerid, GPS_WAYPOINT_ID, x, y, z, icon_id, GPS_WAYPOINT_COLOR, GPS_WAYPOINT_DIST, interior);

    RemovePlayerMapIcon(playerid, GPS_MAP_ICON_SLOT);
    SetPlayerMapIcon(playerid, GPS_MAP_ICON_SLOT, x, y, z, 41, 0xFF5252FF, MAPICON_GLOBAL);

    ShowGPS(playerid);
    SetPlayerGPSPoint(playerid, x, y, z, GPS_POINT_COLOR);
    SetPlayerCheckpoint(playerid, x, y, z, 4.0);
    ShowNotification(playerid, 3, 5, 0, 1, "Место отмечено на GPS", "");
    return 1;
}

forward PV_SendVehVisPlr(forplayerid, vehicleid, ownerid, slot);

stock BroadcastPersonalVehicleVisuals(vehicleid, ownerid, slot)
{
    for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++)
    {
        if(!IsPlayerConnected(p)) continue;
        PV_SendVehVisPlr(p, vehicleid, ownerid, slot);
    }
    return 1;
}

stock House_StreamerRefreshAllPlayers()
{
    for(new p; p < MAX_PLAYERS; p++)
    {
        if(!IsPlayerConnected(p)) continue;
        if(GetPlayerState(p) == PLAYER_STATE_NONE) continue;
        new Float:x, Float:y, Float:z;
        GetPlayerPos(p, x, y, z);
        Streamer_UpdateEx(p, x, y, z, 0, 0, -1, -1, 0);
    }
    return 1;
}
