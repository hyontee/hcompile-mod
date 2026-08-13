new bool:InStailing[MAX_PLAYERS];

CMD:shinka(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid == 0)
        return SendClientMessage(playerid, -1, "Вы должны находиться в автомобиле.");

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

    SetVehiclePos(
        vehicleid,
        995.7154,
        1000.5235,
        1500.1683
    );

    SetVehicleZAngle(vehicleid, 180.0);

    SetPlayerCameraPos(
        playerid,
        999.1838,
        995.9953,
        1501.7263
    );

    SetPlayerCameraLookAt(
        playerid,
        998.5103,
        996.7333,
        1501.5776
    );

    OnPacketIncoming(playerid, 28, tuning_json);

    return 1;
}