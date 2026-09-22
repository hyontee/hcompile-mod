#if !defined RACE_SHINKA_CENTER
#define RACE_SHINKA_CENTER

stock ShowRaceShinkaGUI(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0)
        return RaceNotifyError(playerid, "�� ������ ���� � ������!");

    if(Race_GetOwnedVehicleIndex(playerid, vehicleid) == -1)
        return RaceNotifyError(playerid, "��� �� ��� ������ ���������!");

    new price = Race_GetVehiclePrice(vehicleid);
    new name[64];
    Race_GetVehicleName(vehicleid, name, sizeof(name));

    InStailing[playerid] = false;
    RaceStyle_SaveReturn(playerid, vehicleid);

    new Node:tuning_json = JSON_Object();
    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 2);
    JSON_SetInt(tuning_json, "t", 2);
    JSON_SetInt(tuning_json, "j", price);
    JSON_SetInt(tuning_json, "s", 5);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", name);
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    JSON_SetFloat(tuning_json, "wh_rad", float(vInfo[vehicleid][vWheelSize]));
    JSON_SetFloat(tuning_json, "wh_wf", float(vInfo[vehicleid][vWheelAddFront]));
    JSON_SetFloat(tuning_json, "wh_wr", float(vInfo[vehicleid][vWheelAddRear]));
    JSON_SetFloat(tuning_json, "wh_of", 0.0);
    JSON_SetFloat(tuning_json, "wh_or", 0.0);
    JSON_SetFloat(tuning_json, "wh_cf", 0.0);
    JSON_SetFloat(tuning_json, "wh_cr", 0.0);
    JSON_SetFloat(tuning_json, "wh_clr", float(vInfo[vehicleid][vSuspensionForce]));
    JSON_SetInt(tuning_json, "hydra", vInfo[vehicleid][viHydraulics]);
    JSON_SetInt(tuning_json, "pnevmo", 0);

    // Use the same interior/world/vehicle position as the existing tuning system.
    // The old 1499 Z coordinate had no floor in this interior, so the vehicle fell down.
    MovePlayersAndVehicle(playerid, vehicleid, 1);
    TogglePlayerControllable(playerid, false);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

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

#endif
