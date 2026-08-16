#if defined _TOP_BR_FISHING_INCLUDED
    #endinput
#endif
#define _TOP_BR_FISHING_INCLUDED

#define TOP_FISH_SPOTS 6
static Float:g_TopFishingSpots[TOP_FISH_SPOTS][3] = {
    {1500.0, -1500.0, 13.0},
    {1520.0, -1490.0, 13.0},
    {1480.0, -1510.0, 13.0},
    {1460.0, -1520.0, 13.0},
    {1540.0, -1510.0, 13.0},
    {1560.0, -1490.0, 13.0}
};
static g_TopFishingCount[MAX_PLAYERS];
static g_TopFishingTimer[MAX_PLAYERS];
static bool:g_TopFishingBusy[MAX_PLAYERS];
static g_TopFishingPickup[TOP_FISH_SPOTS];

forward TOP_FishingFinish(playerid);

stock TOP_Fishing_Init()
{
    for(new i = 0; i < TOP_FISH_SPOTS; i++)
    {
        g_TopFishingPickup[i] = CreateDynamicPickup(1274, 1,
            g_TopFishingSpots[i][0], g_TopFishingSpots[i][1], g_TopFishingSpots[i][2], -1);
    }
    return 1;
}

stock TOP_Fishing_Start(playerid)
{
    if(!IsPlayerLogged(playerid)) return 0;
    if(g_TopFishingBusy[playerid]) return 1;
    new started = 0;
    for(new i = 0; i < TOP_FISH_SPOTS; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 4.0, g_TopFishingSpots[i][0], g_TopFishingSpots[i][1], g_TopFishingSpots[i][2]))
        {
            started = 1;
            break;
        }
    }
    if(!started) return SendClientMessage(playerid, 0xFFAA33FF, "{FFFFFF}  .");

    g_TopFishingBusy[playerid] = true;
    g_TopFishingTimer[playerid] = SetTimerEx("TOP_FishingFinish", 5000, false, "i", playerid);
    SendClientMessage(playerid, 0x66CCFFFF, "{FFFFFF}  .  5 .");
    return 1;
}

CMD:fishing(playerid, params[])
{
    #pragma unused params
    return TOP_Fishing_Start(playerid);
}

stock TOP_Fishing_GetName(type, dest[], size)
{
    static const names[][] = {"", "", "", "", ""};
    if(type < 0 || type >= sizeof(names)) type = 0;
    format(dest, size, "%s", names[type]);
    return 1;
}

public TOP_FishingFinish(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    g_TopFishingTimer[playerid] = 0;
    if(!IsPlayerConnected(playerid) || !g_TopFishingBusy[playerid]) return 0;
    g_TopFishingBusy[playerid] = false;
    new fish = random(5);
    new name[32];
    TOP_Fishing_GetName(fish, name, sizeof(name));
    g_TopFishingCount[playerid]++;
    GivePlayerMoneyEx(playerid, 100 + random(401), " ", true, false);
    new msg[144];
    format(msg, sizeof(msg), "{66FF66} %s! {FFFFFF} : %d.", name, g_TopFishingCount[playerid]);
    SendClientMessage(playerid, 0xFFFFFFFF, msg);
    return 1;
}

CMD:fishingstats(playerid, params[])
{
    #pragma unused params
    new msg[96];
    format(msg, sizeof(msg), "{FFFFFF} : {66CCFF}%d", g_TopFishingCount[playerid]);
    SendClientMessage(playerid, 0xFFFFFFFF, msg);
    return 1;
}
