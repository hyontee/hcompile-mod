#if defined _BEKON_TAXI_SYSTEM
    #endinput
#endif
#define _BEKON_TAXI_SYSTEM

#define TaxiDialog 10015

new Float:TaxiPos[5][4] =
{
    { 1548.52, -1675.40, 13.56, 90.0 },
    { 1023.18, -1320.44, 13.55, 180.0 },
    { 223.44, -8.77, 1002.21, 0.0 },
    { -1944.71, 305.91, 35.47, 270.0 },
    { 145.16, -100.44, 1.55, 90.0 }
};

stock bool:Taxi_IsNearTaxi(playerid, Float:range = 5.0)
{
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    for(new vehicleid = 1; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        if(!IsValidVehicleID(vehicleid)) continue;
        if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_TAXI_DRIVER) continue;

        new Float:vx, Float:vy, Float:vz;
        GetVehiclePos(vehicleid, vx, vy, vz);

        if(GetPlayerDistanceFromPoint(playerid, vx, vy, vz) <= range)
            return true;
    }

    return false;
}

CMD:taxi(playerid, params[])
{
    #pragma unused params

    if(!Taxi_IsNearTaxi(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Подойдите к такси, чтобы выбрать место назначения."), 1;

    ShowPlayerDialog
    (
        playerid,
        TaxiDialog,
        DIALOG_STYLE_LIST,
        "Такси",
        "Нижегородск\nБатырево\nАрзамас\nЮжный\nЛыткарино",
        "Ехать",
        "Закрыть"
    );

    return 1;
}

stock TaxiMove(playerid, cityid)
{
    if(cityid < 0 || cityid >= sizeof(TaxiPos)) return 0;

    TogglePlayerControllable(playerid, false);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, TaxiPos[cityid][0], TaxiPos[cityid][1], TaxiPos[cityid][2]);
    SetPlayerFacingAngle(playerid, TaxiPos[cityid][3]);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, true);

    return 1;
}

stock Taxi_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid != TaxiDialog)
        return 0;

    if(!response)
        return 1;

    if(listitem < 0 || listitem >= sizeof(TaxiPos))
        return 1;

    TaxiMove(playerid, listitem);

    new message[96];
    static const city_names[][] =
    {
        "Нижегородск",
        "Батырево",
        "Арзамас",
        "Южный",
        "Лыткарино"
    };

    format(message, sizeof(message), "Вы приехали в %s.", city_names[listitem]);
    SendClientMessage(playerid, 0xFFFFFFFF, message);

    return 1;
}
