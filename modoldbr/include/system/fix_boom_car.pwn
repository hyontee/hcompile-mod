new checkTimer[MAX_PLAYERS];
new bool:checkMessage[MAX_PLAYERS];

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
    {
        checkTimer[playerid] = SetTimerEx("CheckPlayerVehicle", 1000, true, "i", playerid);
    }
    else if(oldstate == PLAYER_STATE_DRIVER)
    {
        KillTimer(checkTimer[playerid]);
    }

    #if defined fixboom_OnPlayerStateChange
        return fixboom_OnPlayerStateChange(playerid, newstate, oldstate);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerStateChange
    #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange fixboom_OnPlayerStateChange
#if defined fixboom_OnPlayerStateChange
    forward fixboom_OnPlayerStateChange(playerid, newstate, oldstate);
#endif

forward CheckPlayerVehicle(playerid);
public CheckPlayerVehicle(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        new Float:health;
                GetVehicleHealth(vehicleid, health);

        if(health < 279.0)
        {
            SetVehicleHealth(vehicleid, 270.0);
            if(checkMessage[playerid] == false)
            {
                ShowNewNotification(playerid, 2, 5, 1, 10, "{868641}Ваш транспорт сломался, вызовите механика ((/call 090))", "");
                checkMessage[playerid] = true;
            }

            new speed = GetSpeedKMHboom(playerid);
            // бля ну сервер немного по другому считывает скорость, поэтому 7
            if(speed > 7)
            {
                SetVehicleSpeed(vehicleid, 7);
            }
        }
        if(health >= 285.0) return checkMessage[playerid] = false;
    }
}

stock GetSpeedKMHboom(playerid)
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