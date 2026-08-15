#if defined _BR_DEATH_PASS_LIC_EARLY_INC_
    #endinput
#endif
#define _BR_DEATH_PASS_LIC_EARLY_INC_

#if !defined PASS_LIC_SHOW_RANGE
    #define PASS_LIC_SHOW_RANGE (5.0)
#endif

stock Pass_FindNearestPlayer(playerid, Float:range)
{
    new targetid = -1;
    new Float:best = range;
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(i == playerid || !IsPlayerConnected(i) || Player[i][pID] <= 0) continue;
        if(GetPlayerInterior(playerid) != GetPlayerInterior(i)) continue;
        if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(i)) continue;

        new Float:dist = GetPlayerDistanceFromPoint(i, px, py, pz);
        if(dist <= best)
        {
            best = dist;
            targetid = i;
        }
    }
    return targetid;
}

stock Pass_IsPlayerNear(playerid, targetid, Float:range = PASS_LIC_SHOW_RANGE)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;
    if(GetPlayerInterior(playerid) != GetPlayerInterior(targetid)) return 0;
    if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(targetid)) return 0;

    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    if(GetPlayerDistanceFromPoint(targetid, px, py, pz) > range) return 0;
    return 1;
}

stock Pass_SendOffer(playerid, targetid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;
    if(Player[playerid][pID] <= 0 || Player[targetid][pID] <= 0) return 0;

    if(playerid != targetid && !Pass_IsPlayerNear(playerid, targetid))
    {
        SendClientMessage(playerid, COLOR_GREY, "Игрок слишком далеко.");
        return 0;
    }

    new msg[144];
    if(playerid == targetid)
        format(msg, sizeof(msg), "Просмотр собственного паспорта.");
    else
        format(msg, sizeof(msg), "Игрок %s[%d] хочет показать вам паспорт.", Player[playerid][pName], playerid);
    ShowNotification(targetid, 4, 15, NOTIFY_PASSPORT_OFFER, playerid, msg, ">>");

    if(playerid == targetid)
        SendClientMessage(playerid, COLOR_WHITE, "Примите уведомление (>>), чтобы открыть свой паспорт.");
    else
    {
        format(msg, sizeof(msg), "Вы предложили показать паспорт игроку %s[%d].", Player[targetid][pName], targetid);
        SendClientMessage(playerid, COLOR_WHITE, msg);
    }
    return 1;
}

stock Lic_SendOffer(playerid, targetid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;
    if(Player[playerid][pID] <= 0 || Player[targetid][pID] <= 0) return 0;

    if(playerid != targetid && !Pass_IsPlayerNear(playerid, targetid))
    {
        SendClientMessage(playerid, COLOR_GREY, "Игрок слишком далеко.");
        return 0;
    }

    new msg[144];
    if(playerid == targetid)
        format(msg, sizeof(msg), "Просмотр собственных лицензий.");
    else
        format(msg, sizeof(msg), "Игрок %s[%d] хочет показать вам лицензии.", Player[playerid][pName], playerid);
    ShowNotification(targetid, 4, 15, NOTIFY_LICENSE_OFFER, playerid, msg, ">>");

    if(playerid == targetid)
        SendClientMessage(playerid, COLOR_WHITE, "Примите уведомление (>>), чтобы открыть свои лицензии.");
    else
    {
        format(msg, sizeof(msg), "Вы предложили показать лицензии игроку %s[%d].", Player[targetid][pName], targetid);
        SendClientMessage(playerid, COLOR_WHITE, msg);
    }
    return 1;
}
