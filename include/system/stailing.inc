
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