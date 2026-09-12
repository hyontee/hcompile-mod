new bool:VehicleSirenActive[MAX_VEHICLES];

forward OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (IsPlayerInAnyVehicle(playerid)) {
        new vehicleid = GetPlayerVehicleID(playerid);
        //printf("DEBUG RAW KEYSTATE: VehicleID: %d, NewKeys: %d, OldKeys: %d, vEnableSiren: %d", vehicleid, newkeys, oldkeys, vInfo[vehicleid][vEnableSiren]);
    }

    if (IsPlayerInAnyVehicle(playerid) && (newkeys & KEY_CROUCH) && !(oldkeys & KEY_CROUCH))
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        if(vInfo[vehicleid][vEnableSiren] == 1)
        {
            if(VehicleSirenActive[vehicleid] == true)
            {
                VehicleSirenActive[vehicleid] = false;
                SetVehicleStroboscope(vehicleid, 0, 1);
            }
            else
            {
                VehicleSirenActive[vehicleid] = true;
                SetVehicleStroboscope(vehicleid, 4, 1);
				SetTimerEx("SetVehicleStrobFix", 200, false, "ii", vehicleid, 4);
                SetTimerEx("SetVehicleStrobFix", 400, false, "ii", vehicleid, 4);
            }
        }
    }
    #if defined fixstrob_OnPlayerKeyStateChange
        return fixstrob_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange fixstrob_OnPlayerKeyStateChange
#if defined fixstrob_OnPlayerKeyStateChange
    forward fixstrob_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

forward SetVehicleStrobFix(vehicleid, type);
public SetVehicleStrobFix(vehicleid, type)
{
    SetVehicleStroboscope(vehicleid, type, 1);
    return 1;
}