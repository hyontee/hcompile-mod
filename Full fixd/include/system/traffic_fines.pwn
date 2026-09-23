// ============================================================================
// SAME RUSSIA - traffic lights + automatic red-light fines
// Runtime-safe extension of the existing tickets/ATM system.
// ============================================================================

#if defined _TRAFFIC_FINES_INCLUDED
    #endinput
#endif
#define _TRAFFIC_FINES_INCLUDED

#define TRAFFIC_LIGHT_RED               (1)
#define TRAFFIC_LIGHT_YELLOW            (2)
#define TRAFFIC_LIGHT_GREEN             (3)

// Existing client build uses these three objects as the light overlays.
#define TRAFFIC_LIGHT_MODEL_RED          (930)
#define TRAFFIC_LIGHT_MODEL_YELLOW       (928)
#define TRAFFIC_LIGHT_MODEL_GREEN        (929)

#define TRAFFIC_RED_FINE_EXPIRE          (86400) // 24 hours
#define TRAFFIC_FINE_COOLDOWN            (8)
#define TRAFFIC_PROCESS_INTERVAL         (50)
#define TRAFFIC_FINE_MIN_SPEED           (8)

new gTrafficLightState[sizeof SvetforsPos];
new bool:gTrafficPrevPosValid[MAX_PLAYERS];
new Float:gTrafficPrevX[MAX_PLAYERS];
new Float:gTrafficPrevY[MAX_PLAYERS];
new Float:gTrafficPrevZ[MAX_PLAYERS];
new gTrafficFineCooldown[MAX_PLAYERS];
new gTrafficExpiryCheckedAccount[MAX_PLAYERS];
new gTrafficProcessTimer = -1;
new gTrafficExpiryTimer = -1;

forward TrafficSystem_Process();
forward TrafficSystem_MinuteTick();
forward TrafficSystem_OnExpireCheck(playerid, accountid);

stock TrafficSystem_GetFineAmount(speed)
{
    // Project economy tiers requested for the red-light violation.
    if(speed >= 150) return 150000;
    if(speed >= 120) return 100000;
    if(speed >= 90)  return 80000;
    if(speed >= 60)  return 60000;
    return 35000;
}

stock TrafficSystem_EnsureSchema()
{
    // Existing police fines keep issued_at/expire_at at 0 and are not affected.
    mysql_query(mysql, "ALTER TABLE tickets ADD COLUMN IF NOT EXISTS issued_at INT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE tickets ADD COLUMN IF NOT EXISTS expire_at INT NOT NULL DEFAULT 0", false);
    mysql_query(mysql, "ALTER TABLE tickets ADD COLUMN IF NOT EXISTS auto_penalty TINYINT NOT NULL DEFAULT 0", false);
    return 1;
}

stock TrafficSystem_Init()
{
    TrafficSystem_EnsureSchema();

    // Red-light crossing is processed directly from OnPlayerUpdate, so the fine
    // is issued on the same sync packet that crosses the stop line.
    if(gTrafficProcessTimer != -1)
    {
        KillTimer(gTrafficProcessTimer);
        gTrafficProcessTimer = -1;
    }
    if(gTrafficExpiryTimer != -1) KillTimer(gTrafficExpiryTimer);
    gTrafficExpiryTimer = SetTimer("TrafficSystem_MinuteTick", 60000, true);
    return 1;
}

stock TrafficSystem_SetLightState(index, light_state)
{
    if(index < 0 || index >= sizeof SvetforsPos) return 0;
    gTrafficLightState[index] = light_state;
    return 1;
}

stock TrafficSystem_GetLightModel(light_state)
{
    switch(light_state)
    {
        case TRAFFIC_LIGHT_RED: return TRAFFIC_LIGHT_MODEL_RED;
        case TRAFFIC_LIGHT_YELLOW: return TRAFFIC_LIGHT_MODEL_YELLOW;
        case TRAFFIC_LIGHT_GREEN: return TRAFFIC_LIGHT_MODEL_GREEN;
    }
    return TRAFFIC_LIGHT_MODEL_RED;
}

stock TrafficSystem_CreateFine(playerid, speed)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    new accountid = GetPlayerAccountID(playerid);
    if(accountid <= 0) return 0;

    new amount = TrafficSystem_GetFineAmount(speed);
    new now = gettime();
    new expire_at = now + TRAFFIC_RED_FINE_EXPIRE;

    new issuer[32] = "\xd1\xe8\xf1\xf2\xe5\xec\xe0\x20\xc3\xc8\xc1\xc4\xc4";
    new description[80];
    format(description, sizeof description, "\xcf\xf0\xee\xe5\xe7\xe4\x20\xed\xe0\x20\xea\xf0\xe0\xf1\xed\xfb\xe9\x20\xf1\xe2\xe5\xf2\x2c\x20\xf1\xea\xee\xf0\xee\xf1\xf2\xfc %d \xea\xec\x2f\xf7", speed);

    new query[384];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO tickets (uid,amount,description,issuer,status,issued_at,expire_at,auto_penalty) VALUES (%d,%d,'%e','%e',0,%d,%d,1)",
        accountid, amount, description, issuer, now, expire_at);
    mysql_query(mysql, query, false);
    if(mysql_errno()) return 0;

    // Match the original project chat presentation from the reference screenshot.
    new message[256];
    format(message, sizeof message,
        "{FFFFFF}\xc2\xfb\x20\xef\xee\xeb\xf3\xf7\xe8\xeb\xe8\x20\xf8\xf2\xf0\xe0\xf4\x20\xe2\x20\xf0\xe0\xe7\xec\xe5\xf0\xe5 {FF0000}%d \xf0\xf3\xe1\xeb\xe5\xe9{FFFFFF} \xe7\xe0\x20\xef\xf0\xee\xe5\xe7\xe4\x20\xed\xe0 {FF0000}\xca\xf0\xe0\xf1\xed\xfb\xe9{FFFFFF} \xf1\xe8\xe3\xed\xe0\xeb\x20\xf1\xe2\xe5\xf2\xee\xf4\xee\xf0\xe0\x2e ",
        amount);
    SendClientMessage(playerid, -1, message);

    new unpaid = 1;
    mysql_format(mysql, query, sizeof query,
        "SELECT COUNT(*) AS c FROM tickets WHERE uid=%d AND status=0", accountid);
    new Cache:count_result = mysql_query(mysql, query, true);
    if(cache_num_rows() > 0) unpaid = cache_get_field_content_int(0, "c");
    cache_delete(count_result);

    format(message, sizeof message,
        "{FFFFFF}\xca\xee\xeb\xe8\xf7\xe5\xf1\xf2\xe2\xee\x20\xed\xe5\xee\xef\xeb\xe0\xf7\xe5\xed\xed\xfb\xf5\x20\xf8\xf2\xf0\xe0\xf4\xee\xe2\x20\xed\xe0\x20\xe4\xe0\xed\xed\xfb\xe9\x20\xec\xee\xec\xe5\xed\xf2\x3a{FF0000}%d{FFFFFF}. \xce\xf2\xef\xf0\xe0\xe2\xeb\xff\xe9\xf2\xe5\xf1\xfc\x20\xe2\x20\xe1\xe0\xed\xea\x2c\x20\xf7\xf2\xee\xe1\xfb\x20\xee\xef\xeb\xe0\xf2\xe8\xf2\xfc\x20\xf8\xf2\xf0\xe0\xf4 (/gps > 10)",
        unpaid);
    SendClientMessage(playerid, -1, message);

    return 1;
}

stock TrafficSystem_CheckExpiredPlayer(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    new accountid = GetPlayerAccountID(playerid);
    if(accountid <= 0) return 0;

    new query[250];
    mysql_format(mysql, query, sizeof query,
        "SELECT COUNT(*) AS c FROM tickets WHERE uid=%d AND status=0 AND auto_penalty=1 AND expire_at>0 AND expire_at<=%d",
        accountid, gettime());
    mysql_tquery(mysql, query, "TrafficSystem_OnExpireCheck", "dd", playerid, accountid);
    return 1;
}

public TrafficSystem_OnExpireCheck(playerid, accountid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
    if(GetPlayerAccountID(playerid) != accountid) return 1;
    if(cache_num_rows() < 1) return 1;

    new expired = cache_get_field_content_int(0, "c");
    if(expired <= 0) return 1;

    if(GetPlayerData(playerid, P_DRIVING_LIC) != 0)
    {
        SetPlayerData(playerid, P_DRIVING_LIC, 0);
        UpdatePlayerDatabaseInt(playerid, "driving_lic", 0);

        SendClientMessage(playerid, 0xFF4444FF,
            "Срок оплаты автоматического штрафа истёк. Все водительские права аннулированы.");
        SendClientMessage(playerid, 0xFFD34EFF,
            "Чтобы снова управлять транспортом, получите права заново в автошколе или воспользуйтесь соответствующей донат-услугой.");
        ShowNotificationLaird(playerid, 2, 9, 0, 0,
            "Неоплаченный штраф просрочен: водительские права аннулированы.", " ");
    }

    new query[250];
    mysql_format(mysql, query, sizeof query,
        "UPDATE tickets SET auto_penalty=2 WHERE uid=%d AND status=0 AND auto_penalty=1 AND expire_at>0 AND expire_at<=%d",
        accountid, gettime());
    mysql_query(mysql, query, false);
    return 1;
}

public TrafficSystem_MinuteTick()
{
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) continue;
        TrafficSystem_CheckExpiredPlayer(playerid);
    }
    return 1;
}

stock bool:TrafficSystem_CrossedStopLine(index,
    Float:px, Float:py, Float:pz,
    Float:cx, Float:cy, Float:cz)
{
    if(index < 0 || index >= sizeof SvetforsPos) return false;

    // Ignore teleports/other worlds vertically far away from the light.
    if(floatabs(cz - SvetforsPos[index][2]) > 4.5) return false;

    new Float:dx = cx - SvetforsPos[index][0];
    new Float:dy = cy - SvetforsPos[index][1];
    if((dx*dx + dy*dy) > 400.0) return false; // 20 m around the signal

    new Float:angle = SvetforsPos[index][3];
    new Float:fx = -floatsin(angle, degrees);
    new Float:fy =  floatcos(angle, degrees);
    new Float:lx =  floatcos(angle, degrees);
    new Float:ly =  floatsin(angle, degrees);

    new Float:pdx = px - SvetforsPos[index][0];
    new Float:pdy = py - SvetforsPos[index][1];

    new Float:prev_long = pdx * fx + pdy * fy;
    new Float:curr_long = dx  * fx + dy  * fy;
    new Float:prev_lat  = floatabs(pdx * lx + pdy * ly);
    new Float:curr_lat  = floatabs(dx  * lx + dy  * ly);

    // Traffic-light object is normally on the side of the road; 12 m catches
    // the driven lanes while rejecting unrelated roads/pedestrians nearby.
    if(prev_lat > 12.0 && curr_lat > 12.0) return false;

    // Crossing the signal plane between two 250 ms samples.
    if((prev_long > 0.0 && curr_long <= 0.0) || (prev_long < 0.0 && curr_long >= 0.0))
    {
        if(floatabs(prev_long - curr_long) >= 0.20) return true;
    }
    return false;
}

stock TrafficSystem_ProcessPlayer(playerid)
{
    if(!IsPlayerConnected(playerid))
    {
        gTrafficPrevPosValid[playerid] = false;
        gTrafficExpiryCheckedAccount[playerid] = 0;
        return 0;
    }

    if(!IsPlayerLogged(playerid))
    {
        gTrafficPrevPosValid[playerid] = false;
        return 0;
    }

    new accountid = GetPlayerAccountID(playerid);
    if(accountid > 0 && gTrafficExpiryCheckedAccount[playerid] != accountid)
    {
        gTrafficExpiryCheckedAccount[playerid] = accountid;
        TrafficSystem_CheckExpiredPlayer(playerid);
    }

    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        gTrafficPrevPosValid[playerid] = false;
        return 0;
    }

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new now = gettime();
    if(gTrafficPrevPosValid[playerid] && now >= gTrafficFineCooldown[playerid])
    {
        new speed = GetPlayerSpeed(playerid);
        if(speed >= TRAFFIC_FINE_MIN_SPEED)
        {
            for(new i = 0; i < sizeof SvetforsPos; i++)
            {
                if(gTrafficLightState[i] != TRAFFIC_LIGHT_RED) continue;

                if(TrafficSystem_CrossedStopLine(i,
                    gTrafficPrevX[playerid], gTrafficPrevY[playerid], gTrafficPrevZ[playerid],
                    x, y, z))
                {
                    if(TrafficSystem_CreateFine(playerid, speed))
                        gTrafficFineCooldown[playerid] = now + TRAFFIC_FINE_COOLDOWN;
                    break;
                }
            }
        }
    }

    gTrafficPrevX[playerid] = x;
    gTrafficPrevY[playerid] = y;
    gTrafficPrevZ[playerid] = z;
    gTrafficPrevPosValid[playerid] = true;
    return 1;
}

public TrafficSystem_Process()
{
    // Fallback/manual pass. Normal driving uses OnPlayerUpdate for immediate fines.
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
        TrafficSystem_ProcessPlayer(playerid);
    return 1;
}
