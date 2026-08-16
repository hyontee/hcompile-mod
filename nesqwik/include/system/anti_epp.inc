//Авторы @dev_romka и @HET_HOMEP или же @romchik_studio и @rcdDRIFTOVICH

new Float:gZones[][4] = {
    {1382.442260,2881.183593, 1606.746093,2033.361450},
    {933.657226,2659.333740, 1249.810791,2293.971435},
    {-96.441497,2086.502441, -1013.546264,2938.241210},
    {-1145.937377,1945.899414, -1280.855590,2941.296142},
    {-2308.980712,2948.393798, -1250.316406,2575.966552},
    {-2441.303710,2393.833496, -1615.155273,1919.067749},
    {-872.737365,1828.511596, -234.932327,1571.372802},
    {988.516845,817.940979, 1793.711303,562.819641},
    {1693.834106,1526.535034, 357.874969,1508.871215},
    {-2141.107910,-2823.238037, -2942.751708,-2036.712158},
    {2226.085693,1285.212402, 2515.600585,498.982513},
    {989.922485,718.339355, 1184.941284,267.574707},
    {1539.029052,750.749572, 1790.809082,300.317016}
};

new
	Float: g_jail_positions_old[4][4] =
{
	{-953.60,-460.61,592.72, 180.0},
	{-948.36,-419.05,592.67, 180.0},
	{-982.61,-412.27,592.72, 180.0},
	{-956.22,-470.59,592.72, 180.0}
};

// список разрешённых авто
new const AllowedVehicles[] = {
    468, 400, 475, 489, 490, 413, 433, 418, 432, 440, 456, 
    461, 463, 468, 470, 475, 495, 505, 521, 522, 523, 553, 
    554, 444, 579, 581, 586
};

new gZoneID[sizeof(gZones)];

new gSpeedTimerID[MAX_PLAYERS];
new bool:gInEPPZone[MAX_PLAYERS];
new gTimerID[MAX_PLAYERS];

public OnGameModeInit()
{
    for(new i = 0; i < sizeof(gZones); i++) gZoneID[i] = CreateDynamicRectangle(gZones[i][0], gZones[i][1], gZones[i][2], gZones[i][3]);

    #if defined epp_OnGameModeInit
        return epp_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit epp_OnGameModeInit
#if defined epp_OnGameModeInit
    forward epp_OnGameModeInit();
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    for(new i = 0; i < sizeof(gZoneID); i++)
    {
        if(areaid == gZoneID[i])
        {
            if(IsPlayerInAnyVehicle(playerid))
            {
                new vehicleid = GetPlayerVehicleID(playerid);
                new modelid = GetVehicleModel(vehicleid);

                if(IsAllowedVehicle(modelid)) return 1;

                SendClientMessage(playerid, -1, "{FFFF00}|{FFFFFF} Вы были замечены камерами движения. В течении {FFFF00}30 секунд {FFFFFF}вам необходимо выехать на дорогу или Вы будете посажены.");

                gInEPPZone[playerid] = true;
                gTimerID[playerid] = SetTimerEx("CheckPlayerEPPZone", 30000, false, "ii", playerid, modelid);
            }
        }
    }
    #if defined epp_OnPlayerEnterDynamicArea
        return epp_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea epp_OnPlayerEnterDynamicArea
#if defined epp_OnPlayerEnterDynamicArea
    forward epp_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    for(new i = 0; i < sizeof(gZoneID); i++)
    {
        if(areaid == gZoneID[i])
        {
            if(gTimerID[playerid] != 0)
            {
                KillTimer(gTimerID[playerid]);
                gTimerID[playerid] = 0;
            }
            gInEPPZone[playerid] = false;
        }
    }
    #if defined epp_OnPlayerLeaveDynamicArea
        return epp_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerLeaveDynamicArea
    #undef OnPlayerLeaveDynamicArea
#else
    #define _ALS_OnPlayerLeaveDynamicArea
#endif
#define OnPlayerLeaveDynamicArea epp_OnPlayerLeaveDynamicArea
#if defined epp_OnPlayerLeaveDynamicArea
    forward epp_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

forward CheckPlayerEPPZone(playerid, modelid);
public CheckPlayerEPPZone(playerid, modelid)
{
    gTimerID[playerid] = 0;

    if(!IsPlayerConnected(playerid)) return 1;
    if(gInEPPZone[playerid] == false) return 1;

    if(gInEPPZone[playerid] == true)
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            gSpeedTimerID[playerid] = SetTimerEx("LimitPlayerVehicleSpeed", 1000, true, "ii", playerid, vehicleid);
        }
        else 
        {
            KillTimer(gSpeedTimerID[playerid]);
            gSpeedTimerID[playerid] = 0;
        }

        ShowPlayerBackground(playerid, 1000, 1000, 1000);

        new jail_time = 10, fmt_msg[228];
        SetPlayerData(playerid, P_JAIL, jail_time * 10);
        UpdatePlayerDatabaseInt(playerid, "jail", jail_time * 10);

        SendClientMessage(playerid, 0xCECECEFF, ""SC"Время до окончания заключения: {CCCC00}/time");
        SendClientMessage(playerid, 0xCECECEFF, ""SC"Советуем ознакомится с правилами сервера, чтобы не получать подобных наказаний.");

        format(fmt_msg, sizeof fmt_msg, "[A] Игрок %s был посажен в деморган на 10 минут за ЕПП на автомобиле %s(#%d)", 
            GetPlayerNameEx(playerid), 
            GetPlayerAccountID(playerid), 
            jail_time, 
            GetVehicleInfo(modelid - 400, VI_NAME), 
            modelid
        );
        SendMessageToAdmins(fmt_msg, 0x999999FF);

        JailPlayerOld(playerid, jail_time);
    }
    return 1;
}

stock bool:IsAllowedVehicle(modelid)
{
    for(new i = 0; i < sizeof(AllowedVehicles); i++)
    {
        if(modelid == AllowedVehicles[i]) return true;
    }
    return false;
}

stock JailPlayerOld(playerid, jail_time)
{
    KillTimer(gSpeedTimerID[playerid]);
    gSpeedTimerID[playerid] = 0;

	new jail_pos_old = random(sizeof g_jail_positions_old);

	SetPlayerPosEx
	(
		playerid,
		g_jail_positions_old[jail_pos_old][0],
		g_jail_positions_old[jail_pos_old][1],
		g_jail_positions_old[jail_pos_old][2],
		g_jail_positions_old[jail_pos_old][3],
		1, 6
	);
}

stock GetSpeedEpp(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
    {
        GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
    }
    else 
    {
        GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    }

    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 100.3;

    if(IsPlayerInAnyVehicle(playerid))
    {
        new current_speed_kph = floatround(ST[3]);
        if(current_speed_kph >= 50 && current_speed_kph <= 99) return current_speed_kph + 20;
        else if(current_speed_kph >= 100 && current_speed_kph <= 199) return current_speed_kph + 50;
        else if(current_speed_kph >= 200 && current_speed_kph <= 299) return current_speed_kph + 116;
        else if(current_speed_kph >= 300 && current_speed_kph <= 399) return current_speed_kph + 132;
    }
    return floatround(ST[3]);
}

forward LimitPlayerVehicleSpeed(playerid, vehicleid);
public LimitPlayerVehicleSpeed(playerid, vehicleid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!IsPlayerInAnyVehicle(playerid)) return 0;

    new vehid = GetPlayerVehicleID(playerid);
    if(vehid != vehicleid) return 0;

    new speed = GetSpeedEpp(playerid);
    if(speed > 7) SetVehicleSpeed(vehid, 7);
    return 1;
}