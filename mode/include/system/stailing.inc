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

#if !defined RACE_STYLE_CENTER_CORE
#define RACE_STYLE_CENTER_CORE

#if !defined RACE_STYLE_NOTIFY_MACROS
    #define RACE_STYLE_NOTIFY_MACROS
    #define RaceNotifyError(%0,%1) ShowNotificationSander(%0, 2, 5, 0, 0, %1, " ")
    #define RaceNotifySuccess(%0,%1) ShowNotificationSander(%0, 3, 5, 0, 0, %1, " ")
    #define RaceNotifyInfo(%0,%1) ShowNotificationSander(%0, 4, 5, 0, 0, %1, ">>")
#endif

new bool:InStailing[MAX_PLAYERS];
new RaceStyleVehicle[MAX_PLAYERS];
new Float:RaceStyleReturnPos[MAX_PLAYERS][4];
new RaceStyleReturnInterior[MAX_PLAYERS];
new RaceStyleReturnWorld[MAX_PLAYERS];
new bool:RaceStyleReturnSaved[MAX_PLAYERS];
new RaceStyleCenterType[MAX_PLAYERS];

new const Float:RaceTechCenterEnter[3][3] =
{
    {-426.235290, 1005.412658, 12.307508},
    {-420.054534, 1005.409240, 12.307003},
    {-413.549285, 1005.543029, 12.326748}
};

new const Float:RaceStylingEnter[3][3] =
{
    {2311.418945, -2607.487304, 21.808467},
    {2311.424804, -2613.460937, 21.808467},
    {2311.318603, -2619.407470, 21.808467}
};

new const Float:RaceShinkaEnter[3][3] =
{
    {1728.810302, 2462.126220, 14.979245},
    {1729.730712, 2457.556396, 14.979245},
    {1730.881835, 2452.856689, 14.979245}
};
new STREAMER_TAG_CP:RaceShinkaCheckpoint[sizeof(RaceShinkaEnter)];

new const Float:RaceStoEnter[1][4] =
{
    {1867.183593, -119.333526, 14.892340, 34.793312}
};
new STREAMER_TAG_CP:RaceStoCheckpoint[sizeof(RaceStoEnter)];

stock Race_GetOwnedVehicleIndex(playerid, vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0) return -1;
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR) return -1;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0) return -1;
    if(GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid)) return -1;
    return index;
}

stock Race_GetVehiclePrice(vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0) return 500000;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index >= 0 && GetOwnableCarData(index, OC_LAST_PRICE) > 0)
        return GetOwnableCarData(index, OC_LAST_PRICE);

    new modelid = GetVehicleData(vehicleid, V_MODELID);
    if(modelid <= 0) modelid = GetVehicleModel(vehicleid);
    return 500000 + ((modelid - 400) * 2500);
}

stock Race_GetVehicleName(vehicleid, dest[], size = sizeof dest)
{
    new modelid = GetVehicleData(vehicleid, V_MODELID);
    if(modelid <= 0) modelid = GetVehicleModel(vehicleid);
    GetVehicleDataName(modelid, dest, size);
    return 1;
}

stock RaceStyle_SaveReturn(playerid, vehicleid)
{
    RaceStyleVehicle[playerid] = vehicleid;
    RaceStyleReturnSaved[playerid] = true;
    RaceStyleCenterType[playerid] = -1;
    GetVehiclePos(vehicleid, RaceStyleReturnPos[playerid][0], RaceStyleReturnPos[playerid][1], RaceStyleReturnPos[playerid][2]);
    GetVehicleZAngle(vehicleid, RaceStyleReturnPos[playerid][3]);
    RaceStyleReturnInterior[playerid] = GetPlayerInterior(playerid);
    RaceStyleReturnWorld[playerid] = GetPlayerVirtualWorld(playerid);
    return 1;
}

stock RaceStyle_SetOccupantsEnvironment(vehicleid, worldid, interiorid, bool:unfreeze = false)
{
    for(new occupant = 0; occupant < MAX_PLAYERS; occupant++)
    {
        if(!IsPlayerConnected(occupant) || GetPlayerVehicleID(occupant) != vehicleid) continue;
        SetPlayerVirtualWorld(occupant, worldid);
        SetPlayerInterior(occupant, interiorid);
        SetCameraBehindPlayer(occupant);
        if(unfreeze) TogglePlayerControllable(occupant, true);
    }
    return 1;
}

stock RaceStyle_RestoreVehicle(playerid)
{
    new center_type = RaceStyleCenterType[playerid];
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0) vehicleid = RaceStyleVehicle[playerid];

    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, true);
    SetPlayerInterior(playerid, RaceStyleReturnInterior[playerid]);
    SetPlayerVirtualWorld(playerid, RaceStyleReturnWorld[playerid]);

    if(IsValidVehicle(vehicleid))
    {
        SetVehicleVirtualWorld(vehicleid, RaceStyleReturnWorld[playerid]);
        LinkVehicleToInterior(vehicleid, RaceStyleReturnInterior[playerid]);
        RaceStyle_SetOccupantsEnvironment(vehicleid, RaceStyleReturnWorld[playerid], RaceStyleReturnInterior[playerid], true);

        if(RaceStyleReturnSaved[playerid])
        {
            SetVehiclePos(vehicleid,
                RaceStyleReturnPos[playerid][0],
                RaceStyleReturnPos[playerid][1],
                RaceStyleReturnPos[playerid][2]);
            SetVehicleZAngle(vehicleid, RaceStyleReturnPos[playerid][3]);
        }
        PutPlayerInVehicle(playerid, vehicleid, 0);
        SyncVehicleTuningForPlayer(playerid, vehicleid);
    }

    if(center_type == 1)
    {
        SetPVarInt(playerid, "RaceStoEntryBlockUntil", gettime() + 3);
    }
    else if(center_type == 2)
    {
        SetPVarInt(playerid, "RaceShinkaEntryBlockUntil", gettime() + 3);
    }

    InStailing[playerid] = false;
    DeletePVar(playerid, "RaceStoSession");
    DeletePVar(playerid, "RaceStoIgnoreExitUntil");
    DeletePVar(playerid, "RaceStoPendingExit");
    DeletePVar(playerid, "RaceStoUseComponentJsonId");
    RaceStyleReturnSaved[playerid] = false;
    RaceStyleVehicle[playerid] = INVALID_VEHICLE_ID;
    RaceStyleCenterType[playerid] = -1;
    return 1;
}

stock RaceStyle_Create3DLabels()
{
    for(new i = 0; i < sizeof(RaceTechCenterEnter); i++)
    {
        CreateDynamic3DTextLabel(
            "{f6fa05}Технический центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине",
            -1,
            RaceTechCenterEnter[i][0],
            RaceTechCenterEnter[i][1],
            RaceTechCenterEnter[i][2] + 2.45,
            50.0,
            INVALID_PLAYER_ID,
            INVALID_VEHICLE_ID,
            0,
            -1,
            -1
        );
    }

    for(new i = 0; i < sizeof(RaceStylingEnter); i++)
    {
        CreateDynamic3DTextLabel(
            "{f6fa05}Стайлинг центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине",
            -1,
            RaceStylingEnter[i][0],
            RaceStylingEnter[i][1],
            RaceStylingEnter[i][2],
            9.0,
            INVALID_PLAYER_ID,
            INVALID_VEHICLE_ID,
            0,
            -1,
            -1
        );
    }
    for(new i = 0; i < sizeof(RaceShinkaEnter); i++)
    {
        RaceShinkaCheckpoint[i] = CreateDynamicCP(
            RaceShinkaEnter[i][0], RaceShinkaEnter[i][1], RaceShinkaEnter[i][2] - 0.75,
            4.5, 0, 0, -1, 90.0
        );
        CreateDynamicPickup(
            19135, 23,
            RaceShinkaEnter[i][0], RaceShinkaEnter[i][1], RaceShinkaEnter[i][2],
            0, 0
        );
        CreateDynamic3DTextLabel(
            "{f6fa05}Шиномонтажный центр\n{ffffff}Заедьте в маркер или нажмите гудок",
            -1, RaceShinkaEnter[i][0], RaceShinkaEnter[i][1], RaceShinkaEnter[i][2],
            9.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1
        );
    }

    for(new i = 0; i < sizeof(RaceStoEnter); i++)
    {
        RaceStoCheckpoint[i] = CreateDynamicCP(
            RaceStoEnter[i][0], RaceStoEnter[i][1], RaceStoEnter[i][2] - 0.75,
            3.5, 0, 0, -1, 80.0
        );
        CreateDynamicPickup(
            19135, 23,
            RaceStoEnter[i][0], RaceStoEnter[i][1], RaceStoEnter[i][2],
            0, 0
        );
        CreateDynamic3DTextLabel(
            "{f6fa05}СТО / Обвесы\n{ffffff}Заедьте в маркер или нажмите гудок",
            -1,
            RaceStoEnter[i][0], RaceStoEnter[i][1], RaceStoEnter[i][2] + 1.25,
            40.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0
        );
    }
    return 1;
}

stock RaceStyle_IsNearStoEntrance(playerid, Float:range = 12.0)
{
    for(new i = 0; i < sizeof(RaceStoEnter); i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, range,
            RaceStoEnter[i][0], RaceStoEnter[i][1], RaceStoEnter[i][2]))
        {
            return 1;
        }
    }
    return 0;
}

stock RaceStyle_HandleStoCheckpoint(playerid, STREAMER_TAG_CP:checkpointid)
{
    for(new i = 0; i < sizeof(RaceShinkaCheckpoint); i++)
    {
        if(checkpointid != RaceShinkaCheckpoint[i]) continue;
        if(GetPVarInt(playerid, "RaceShinkaEntryBlockUntil") > gettime()) return 1;
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

        callcmd::shinka(playerid, "");
        return 1;
    }

    for(new i = 0; i < sizeof(RaceStoCheckpoint); i++)
    {
        if(checkpointid != RaceStoCheckpoint[i]) continue;

        // После выхода из бокса не открываем его повторно в ту же секунду.
        if(GetPVarInt(playerid, "RaceStoEntryBlockUntil") > gettime()) return 1;
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

        callcmd::stogui(playerid, "");
        return 1;
    }
    return 0;
}

stock RaceStyling_CheckVehicleEntrance(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;

    // Сначала обрабатываем сам заезд. Проверка личного транспорта
    // выполняется внутри GUI и выводит игроку понятное сообщение.
    for(new i = 0; i < sizeof(RaceTechCenterEnter); i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0,
            RaceTechCenterEnter[i][0],
            RaceTechCenterEnter[i][1],
            RaceTechCenterEnter[i][2]))
        {
            callcmd::techcentergui(playerid, "");
            return 1;
        }
    }

    if(RaceStyle_IsNearStoEntrance(playerid, 12.0))
    {
        callcmd::stogui(playerid, "");
        return 1;
    }

    for(new i = 0; i < sizeof(RaceShinkaEnter); i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0,
            RaceShinkaEnter[i][0], RaceShinkaEnter[i][1], RaceShinkaEnter[i][2]))
        {
            callcmd::shinka(playerid, "");
            return 1;
        }
    }

    for(new i = 0; i < sizeof(RaceStylingEnter); i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0,
            RaceStylingEnter[i][0],
            RaceStylingEnter[i][1],
            RaceStylingEnter[i][2]))
        {
            callcmd::tungui(playerid, "");
            return 1;
        }
    }
    return 0;
}

stock ShowRaceStylingGUI(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0)
        return RaceNotifyError(playerid, "Вы должны быть в машине!");

    if(Race_GetOwnedVehicleIndex(playerid, vehicleid) == -1)
        return RaceNotifyError(playerid, "Это не ваш личный транспорт!");

    new price = Race_GetVehiclePrice(vehicleid);
    new name[64];
    Race_GetVehicleName(vehicleid, name, sizeof(name));

    InStailing[playerid] = true;
    RaceStyle_SaveReturn(playerid, vehicleid);
    RaceStyleCenterType[playerid] = 0;

    new Node:tuning_json = JSON_Object();
    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 0);
    JSON_SetInt(tuning_json, "t", 0);
    JSON_SetInt(tuning_json, "j", price);
    JSON_SetInt(tuning_json, "s", 5);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", name);
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    new vw = playerid + 1000;
    SetPlayerVirtualWorld(playerid, vw);
    SetVehicleVirtualWorld(vehicleid, vw);
    LinkVehicleToInterior(vehicleid, 1);
    SetPlayerInterior(playerid, 1);
    RaceStyle_SetOccupantsEnvironment(vehicleid, vw, 1);
    SetVehiclePos(vehicleid, 1000.0, 1500.0, 1498.0);
    SetVehicleZAngle(vehicleid, 180.0);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    TogglePlayerControllable(playerid, false);
    SetPlayerCameraPos(playerid, 1003.9196, 1493.9724, 1499.7500);
    SetPlayerCameraLookAt(playerid, 1003.3480, 1494.7935, 1499.5002);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}


// Compatibility alias for old calls from race/lair.pwn
stock ShowTuningStylingGUI(playerid)
{
    return ShowRaceStylingGUI(playerid);
}

CMD:tungui(playerid, params[])
{
    return ShowRaceStylingGUI(playerid);
}

CMD:tungui1(playerid, params[])
{
    return ShowRaceStylingGUI(playerid);
}

stock GetBodyPaintCost(price) return (price / 100) + 10000;
stock GetUnivCost(price) return (price / 100) + 50000;
stock GetDalniyCost(price) return (price / 1000) + 10000;
stock GetDoubleCost(price) return ((price / 100) + 10000) * 2;
stock GetExtraCost(price) return (price / 100) + 20000;
stock GetDonatCost(price) return (((price / 100) + 50000) * 3) / 1000;

#endif
