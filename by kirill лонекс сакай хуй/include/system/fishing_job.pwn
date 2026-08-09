#if defined _FISHING_JOB_INCLUDED
    #endinput
#endif
#define _FISHING_JOB_INCLUDED

/*
    Fishing job / minigame for mobile client.
    Сделано без пересборки APK: интерфейс собран через PlayerTextDraw.
    Подключение в laird.pwn:
        #include "../include/system/fishing_job.pwn"
        Fishing_InitWorld();
        Fishing_OnPlayerDisconnect(playerid);
        if(Fishing_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)) return 1;
        if(Fishing_OnPlayerCommandText(playerid, cmdtext)) return 1;
*/

#if !defined COLOR_WHITE
    #define COLOR_WHITE 0xFFFFFFFF
#endif
#if !defined COLOR_YELLOW
    #define COLOR_YELLOW 0xFFD84DFF
#endif
#if !defined COLOR_GREEN
    #define COLOR_GREEN 0x35D66BFF
#endif
#if !defined COLOR_RED
    #define COLOR_RED 0xFF5252FF
#endif
#if !defined COLOR_GREY
    #define COLOR_GREY 0xAFAFAFFF
#endif

#define FISHING_ATTACH_SLOT          (8)
#define FISHING_ROD_MODEL            (18632)
#define FISHING_MAP_ICON_SLOT        (84)
#define FISHING_NEAR_RADIUS          (28.0)
#define FISHING_ACTION_RADIUS        (7.0)
#define FISHING_CAPTAIN_RADIUS       (4.5)
#define FISHING_CAPTAIN_X            (-2531.592285)
#define FISHING_CAPTAIN_Y            (343.215637)
#define FISHING_CAPTAIN_Z            (2.100287)
#define FISHING_CAPTAIN_A            (1.617361)
#define FISHING_CAPTAIN_SKIN         (111)
#define DIALOG_FISHING_CAPTAIN       (29126)
#define FISHING_NOTIFY_CAPTAIN      (23201)
#define FISHING_NOTIFY_CAST         (23202)
#define FISHING_BAG_LIMIT            (50)
#define FISHING_GAME_INTERVAL        (90)
#define FISHING_WAIT_MIN_MS          (3000)
#define FISHING_WAIT_RAND_MS         (5000)

#define FISH_TD_BG                   (0)
#define FISH_TD_TITLE                (1)
#define FISH_TD_HINT                 (2)
#define FISH_TD_BAR_BACK             (3)
#define FISH_TD_TARGET               (4)
#define FISH_TD_MARKER               (5)
#define FISH_TD_PERCENT              (6)
#define FISH_TD_INFO                 (7)
#define FISH_TD_ARC_LEFT             (8)
#define FISH_TD_ARC_LEFT_TOP         (9)
#define FISH_TD_ARC_CENTER           (10)
#define FISH_TD_ARC_RIGHT_TOP        (11)
#define FISH_TD_ARC_RIGHT            (12)
#define FISH_TD_PROGRESS_BACK        (13)
#define FISH_TD_PROGRESS_FILL        (14)
#define FISH_TD_COUNT                (15)

#define FISH_BAR_X                   (210.0)
#define FISH_BAR_Y                   (339.0)
#define FISH_BAR_W                   (220.0)
#define FISH_BAR_H                   (1.20)

#define FISH_PROGRESS_X              (245.0)
#define FISH_PROGRESS_Y              (379.0)
#define FISH_PROGRESS_W              (150.0)
#define FISH_PROGRESS_H              (1.10)

#define FISH_STATE_NONE              (0)
#define FISH_STATE_WAIT              (1)
#define FISH_STATE_GAME              (2)

new Float:gFishingSpots[][3] =
{
    { -2553.6206, 372.0039, 2.1016 },
    { -2558.2000, 374.9000, 2.1000 },
    { -2548.9000, 374.4500, 2.1000 },
    { -2556.6000, 366.3000, 2.1000 },
    { -2550.1500, 366.7500, 2.1000 },
    { -2562.8000, 370.1000, 2.1000 },
    { -2544.7000, 370.6500, 2.1000 },
    { -2553.1000, 380.3000, 2.1000 }
};

new gFishingState[MAX_PLAYERS];
new gFishingWaitTimer[MAX_PLAYERS];
new gFishingGameTimer[MAX_PLAYERS];
new gFishingSpot[MAX_PLAYERS];
new gFishingProgress[MAX_PLAYERS];
new Float:gFishingMarker[MAX_PLAYERS];
new gFishingDirection[MAX_PLAYERS];
new gFishingTargetMin[MAX_PLAYERS];
new gFishingTargetMax[MAX_PLAYERS];
new gFishingBagCount[MAX_PLAYERS];
new gFishingBagMoney[MAX_PLAYERS];
new gFishingTotalCaught[MAX_PLAYERS];
new bool:gFishingHasRod[MAX_PLAYERS];
new bool:gFishingTDCreated[MAX_PLAYERS];
new PlayerText:gFishingTD[MAX_PLAYERS][FISH_TD_COUNT];
new bool:gFishingTargetTDShown[MAX_PLAYERS];
new bool:gFishingMarkerTDShown[MAX_PLAYERS];
new bool:gFishingCaptainHintShown[MAX_PLAYERS];
new bool:gFishingSpotHintShown[MAX_PLAYERS];

forward Fishing_WaitBiteTimer(playerid);
forward Fishing_GameProcessTimer(playerid);
forward Fishing_HintTimer();

stock Fishing_InitWorld()
{
    // На месте рыбалки пикапы больше не создаются.
    // Игрок получает удочку у капитана, едет на метку и сам забрасывает удочку через Y.
    CreateActorEx("{FAD201}Капитан пирса", "{FFFFFF}Подойдите ближе. {FAD201}Нажмите уведомление для диалога", FISHING_CAPTAIN_SKIN, FISHING_CAPTAIN_X, FISHING_CAPTAIN_Y, FISHING_CAPTAIN_Z, FISHING_CAPTAIN_A);

    SetTimer("Fishing_HintTimer", 1200, true);
    print("[Fishing] Система рыбалки с капитаном пирса загружена без пикапов на местах рыбалки.");
    return 1;
}

public Fishing_HintTimer()
{
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(!IsPlayerConnected(playerid)) continue;

        if(Fishing_IsNearCaptain(playerid))
        {
            if(!gFishingCaptainHintShown[playerid])
            {
                ShowNotificationSile(playerid, 4, 6, FISHING_NOTIFY_CAPTAIN, 0, "Нажмите на уведомление, чтобы поговорить с капитаном пирса", ">>");
                GameTextForPlayer(playerid, "~y~CAPTAIN ~w~- нажмите уведомление", 2200, 3);
                gFishingCaptainHintShown[playerid] = true;
            }
        }
        else gFishingCaptainHintShown[playerid] = false;

        if(gFishingHasRod[playerid] && gFishingState[playerid] == FISH_STATE_NONE && Fishing_GetNearestSpot(playerid, FISHING_ACTION_RADIUS) != -1)
        {
            if(!gFishingSpotHintShown[playerid])
            {
                ShowNotificationSile(playerid, 4, 6, FISHING_NOTIFY_CAST, 0, "Нажмите на уведомление, чтобы забросить удочку", ">>");
                GameTextForPlayer(playerid, "~y~FISHING ~w~- нажмите уведомление", 2200, 3);
                gFishingSpotHintShown[playerid] = true;
            }
        }
        else gFishingSpotHintShown[playerid] = false;
    }
    return 1;
}

stock Fishing_OnPlayerDisconnect(playerid)
{
    Fishing_Stop(playerid, false);
    gFishingBagCount[playerid] = 0;
    gFishingBagMoney[playerid] = 0;
    gFishingTotalCaught[playerid] = 0;
    gFishingHasRod[playerid] = false;
    gFishingCaptainHintShown[playerid] = false;
    gFishingSpotHintShown[playerid] = false;
    return 1;
}

stock Fishing_OnNotificationClick(playerid, id, sub_id)
{
    if(id == FISHING_NOTIFY_CAPTAIN)
    {
        if(!Fishing_IsNearCaptain(playerid))
        {
            SendClientMessage(playerid, COLOR_YELLOW, "Подойдите ближе к капитану пирса.");
            Fishing_SetCaptainRoute(playerid);
            return 1;
        }

        Fishing_OpenCaptainMenu(playerid);
        return 1;
    }

    if(id == FISHING_NOTIFY_CAST)
    {
        if(!gFishingHasRod[playerid])
        {
            SendClientMessage(playerid, COLOR_YELLOW, "Сначала получите удочку у капитана пирса.");
            Fishing_SetCaptainRoute(playerid);
            return 1;
        }

        if(Fishing_GetNearestSpot(playerid, FISHING_ACTION_RADIUS) == -1)
        {
            SendClientMessage(playerid, COLOR_YELLOW, "Вы отошли от места рыбалки. Метка поставлена снова.");
            Fishing_SetNearestRoute(playerid);
            return 1;
        }

        Fishing_Start(playerid);
        return 1;
    }

    return 0;
}

stock Fishing_OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/fish", true) || !strcmp(cmdtext, "/fishing", true) || !strcmp(cmdtext, "/rybalka", true) ||
       !strcmp(cmdtext, "/fishstop", true) || !strcmp(cmdtext, "/stopfish", true) ||
       !strcmp(cmdtext, "/sellfish", true) || !strcmp(cmdtext, "/fishsell", true) ||
       !strcmp(cmdtext, "/fishstats", true) || !strcmp(cmdtext, "/fishbag", true) ||
       !strcmp(cmdtext, "/fishgps", true) || !strcmp(cmdtext, "/fishroute", true) ||
       !strcmp(cmdtext, "/fishhelp", true))
    {
        SendClientMessage(playerid, COLOR_YELLOW, "Рыбалка теперь работает через капитана пирса. Метка поставлена на капитана.");
        Fishing_SetCaptainRoute(playerid);
        return 1;
    }
    return 0;
}

stock Fishing_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(gFishingState[playerid] == FISH_STATE_GAME)
    {
        if(((newkeys & KEY_FIRE) && !(oldkeys & KEY_FIRE)) || ((newkeys & KEY_YES) && !(oldkeys & KEY_YES)) || ((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK)))
        {
            Fishing_PlayerHook(playerid);
            return 1;
        }
    }

    if(((newkeys & KEY_YES) && !(oldkeys & KEY_YES)) || ((newkeys & KEY_WALK) && !(oldkeys & KEY_WALK)) || ((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK)))
    {
        if(Fishing_IsNearCaptain(playerid))
        {
            Fishing_OpenCaptainMenu(playerid);
            return 1;
        }

        if(Fishing_GetNearestSpot(playerid, FISHING_ACTION_RADIUS) != -1)
        {
            if(!gFishingHasRod[playerid])
            {
                SendClientMessage(playerid, COLOR_YELLOW, "Сначала получите удочку у капитана пирса. Метка поставлена.");
                Fishing_SetCaptainRoute(playerid);
                return 1;
            }
            Fishing_Start(playerid);
            return 1;
        }
    }
    return 0;
}

stock Fishing_IsNearCaptain(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, FISHING_CAPTAIN_RADIUS, FISHING_CAPTAIN_X, FISHING_CAPTAIN_Y, FISHING_CAPTAIN_Z)) return 1;
    return 0;
}


stock Fishing_GiveRod(playerid)
{
    gFishingHasRod[playerid] = true;

    if(IsPlayerAttachedObjectSlotUsed(playerid, FISHING_ATTACH_SLOT))
    {
        RemovePlayerAttachedObject(playerid, FISHING_ATTACH_SLOT);
    }

    // Видимая удочка в правой руке. Старые координаты могли прятать модель в теле игрока.
    SetPlayerAttachedObject(playerid, FISHING_ATTACH_SLOT, FISHING_ROD_MODEL, 6,
        0.0900, 0.0200, 0.0200,
        -75.0000, 25.0000, 12.0000,
        1.1200, 1.1200, 1.1200
    );

    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    return 1;
}

stock Fishing_OpenCaptainMenu(playerid)
{
    if(!gFishingHasRod[playerid])
    {
        Fishing_GiveRod(playerid);
        SendClientMessage(playerid, COLOR_GREEN, "Капитан выдал вам удочку. Теперь езжайте к воде и забрасывайте её через уведомление.");
        ShowNotificationSile(playerid, 3, 5, -1, -1, "Капитан выдал вам удочку. Метка на место рыбалки поставлена.", " ");
        Fishing_SetNearestRoute(playerid);
    }

    new menu[256];
    strcat(menu, "Поставить метку на место рыбалки\n");
    strcat(menu, "Продать улов\n");
    strcat(menu, "Мой садок\n");
    strcat(menu, "Сдать удочку и завершить рыбалку");
    ShowPlayerDialog(playerid, DIALOG_FISHING_CAPTAIN, DIALOG_STYLE_LIST, "Капитан пирса", menu, "Выбрать", "Закрыть");
    return 1;
}

stock Fishing_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid != DIALOG_FISHING_CAPTAIN) return 0;
    if(!response) return 1;

    if(!Fishing_IsNearCaptain(playerid))
    {
        SendClientMessage(playerid, COLOR_RED, "Вы отошли от капитана пирса.");
        return 1;
    }

    switch(listitem)
    {
        case 0:
        {
            Fishing_GiveRod(playerid);
            ShowNotificationSile(playerid, 3, 5, -1, -1, "Удочка выдана. Метка на место рыбалки поставлена.", " ");
            SendClientMessage(playerid, COLOR_GREEN, "Удочка выдана. Доезжайте до пирса и нажмите уведомление у воды, чтобы забросить.");
            Fishing_SetNearestRoute(playerid);
        }
        case 1:
        {
            Fishing_SellFish(playerid);
        }
        case 2:
        {
            Fishing_ShowStats(playerid);
        }
        case 3:
        {
            Fishing_Stop(playerid, false);
            gFishingHasRod[playerid] = false;
            if(IsPlayerAttachedObjectSlotUsed(playerid, FISHING_ATTACH_SLOT)) RemovePlayerAttachedObject(playerid, FISHING_ATTACH_SLOT);
            ShowNotificationSile(playerid, 3, 5, -1, -1, "Вы сдали удочку капитану и завершили рыбалку.", " ");
            SendClientMessage(playerid, COLOR_GREY, "Вы сдали удочку капитану и завершили рыбалку.");
        }
    }
    return 1;
}

stock Fishing_SetCaptainRoute(playerid)
{
    SetPlayerCheckpoint(playerid, FISHING_CAPTAIN_X, FISHING_CAPTAIN_Y, FISHING_CAPTAIN_Z, 3.0);
    SetPlayerMapIcon(playerid, FISHING_MAP_ICON_SLOT, FISHING_CAPTAIN_X, FISHING_CAPTAIN_Y, FISHING_CAPTAIN_Z, 9, 0x35D66BFF, 0);
    SendClientMessage(playerid, COLOR_YELLOW, "Метка поставлена на капитана пирса.");
    return 1;
}

stock Fishing_Start(playerid)
{
    if(!gFishingHasRod[playerid])
    {
        SendClientMessage(playerid, COLOR_YELLOW, "Сначала получите удочку у капитана пирса. Метка поставлена.");
        Fishing_SetCaptainRoute(playerid);
        return 1;
    }

    if(gFishingState[playerid] != FISH_STATE_NONE)
        return SendClientMessage(playerid, COLOR_GREY, "Вы уже рыбачите. Дождитесь поклёвки или сдайте удочку капитану."), 1;

    if(IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_RED, "Для рыбалки нужно выйти из транспорта."), 1;

    new spotid = Fishing_GetNearestSpot(playerid, FISHING_NEAR_RADIUS);
    if(spotid == -1)
    {
        SendClientMessage(playerid, COLOR_YELLOW, "Вы далеко от воды. Капитан отметил ближайшее место рыбалки.");
        Fishing_SetNearestRoute(playerid);
        return 1;
    }

    gFishingState[playerid] = FISH_STATE_WAIT;
    gFishingSpot[playerid] = spotid;
    gFishingProgress[playerid] = 40 + random(16);
    gFishingMarker[playerid] = float(random(100));
    gFishingDirection[playerid] = 1;
    Fishing_RandomTarget(playerid);

    Fishing_GiveRod(playerid);
    ApplyAnimation(playerid, "SWORD", "sword_block", 4.1, 0, 0, 0, 1, 0, 1);

    SendClientMessage(playerid, COLOR_YELLOW, "Вы забросили удочку. Ждите поклевку...");
    gFishingWaitTimer[playerid] = SetTimerEx("Fishing_WaitBiteTimer", FISHING_WAIT_MIN_MS + random(FISHING_WAIT_RAND_MS), false, "i", playerid);
    return 1;
}

public Fishing_WaitBiteTimer(playerid)
{
    gFishingWaitTimer[playerid] = 0;
    if(!IsPlayerConnected(playerid) || gFishingState[playerid] != FISH_STATE_WAIT) return 1;

    if(Fishing_GetNearestSpot(playerid, FISHING_NEAR_RADIUS) == -1 || IsPlayerInAnyVehicle(playerid))
    {
        Fishing_Stop(playerid, false);
        SendClientMessage(playerid, COLOR_RED, "Рыбалка отменена: вы отошли от воды или сели в транспорт.");
        return 1;
    }

    gFishingState[playerid] = FISH_STATE_GAME;
    Fishing_CreateInterface(playerid);
    gFishingGameTimer[playerid] = SetTimerEx("Fishing_GameProcessTimer", FISHING_GAME_INTERVAL, true, "i", playerid);
    SendClientMessage(playerid, COLOR_GREEN, "Поклевка! Нажимайте кнопку удара/Y, когда маркер попадает в зеленую зону.");
    return 1;
}

public Fishing_GameProcessTimer(playerid)
{
    if(!IsPlayerConnected(playerid) || gFishingState[playerid] != FISH_STATE_GAME)
    {
        if(gFishingGameTimer[playerid]) KillTimer(gFishingGameTimer[playerid]);
        gFishingGameTimer[playerid] = 0;
        return 1;
    }

    if(Fishing_GetNearestSpot(playerid, FISHING_NEAR_RADIUS) == -1 || IsPlayerInAnyVehicle(playerid))
    {
        Fishing_Stop(playerid, false);
        SendClientMessage(playerid, COLOR_RED, "Рыба сорвалась: вы отошли от места рыбалки.");
        return 1;
    }

    new Float:speed = 4.5 + float(random(24)) / 10.0;
    if(gFishingDirection[playerid] > 0) gFishingMarker[playerid] += speed;
    else gFishingMarker[playerid] -= speed;

    if(gFishingMarker[playerid] >= 100.0)
    {
        gFishingMarker[playerid] = 100.0;
        gFishingDirection[playerid] = -1;
    }
    else if(gFishingMarker[playerid] <= 0.0)
    {
        gFishingMarker[playerid] = 0.0;
        gFishingDirection[playerid] = 1;
    }

    if(random(10) == 0 && gFishingProgress[playerid] > 3)
        gFishingProgress[playerid]--;

    Fishing_UpdateInterface(playerid);
    return 1;
}

stock Fishing_PlayerHook(playerid)
{
    if(gFishingState[playerid] != FISH_STATE_GAME) return 0;

    new marker = floatround(gFishingMarker[playerid]);
    if(marker >= gFishingTargetMin[playerid] && marker <= gFishingTargetMax[playerid])
    {
        gFishingProgress[playerid] += 12 + random(9);
        Fishing_RandomTarget(playerid);
        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    }
    else
    {
        gFishingProgress[playerid] -= 10 + random(8);
        PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
    }

    if(gFishingProgress[playerid] >= 100)
    {
        Fishing_CatchFish(playerid);
        return 1;
    }
    if(gFishingProgress[playerid] <= 0)
    {
        Fishing_Stop(playerid, false);
        SendClientMessage(playerid, COLOR_RED, "Рыба сорвалась. Попробуйте еще раз.");
        return 1;
    }

    Fishing_UpdateInterface(playerid);
    return 1;
}

stock Fishing_CatchFish(playerid)
{
    new fishid = Fishing_GetRandomFishId();
    new fishname[32];
    Fishing_GetFishName(fishid, fishname, sizeof fishname);
    new price = Fishing_GetFishPrice(fishid) + random(350);

    if(gFishingBagCount[playerid] >= FISHING_BAG_LIMIT)
    {
        Fishing_Stop(playerid, false);
        SendClientMessage(playerid, COLOR_RED, "Садок переполнен. Вернитесь к капитану пирса и продайте улов.");
        return 1;
    }

    gFishingBagCount[playerid]++;
    gFishingBagMoney[playerid] += price;
    gFishingTotalCaught[playerid]++;

    new msg[144];
    format(msg, sizeof msg, "Вы поймали: %s. Оценка: %d руб. В садке: %d/%d.", fishname, price, gFishingBagCount[playerid], FISHING_BAG_LIMIT);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    PlayerPlaySound(playerid, 5201, 0.0, 0.0, 0.0);

    Fishing_Stop(playerid, false);
    return 1;
}

stock Fishing_Stop(playerid, bool:message)
{
    if(gFishingWaitTimer[playerid])
    {
        KillTimer(gFishingWaitTimer[playerid]);
        gFishingWaitTimer[playerid] = 0;
    }
    if(gFishingGameTimer[playerid])
    {
        KillTimer(gFishingGameTimer[playerid]);
        gFishingGameTimer[playerid] = 0;
    }
    Fishing_DestroyInterface(playerid);
    if(IsPlayerAttachedObjectSlotUsed(playerid, FISHING_ATTACH_SLOT)) RemovePlayerAttachedObject(playerid, FISHING_ATTACH_SLOT);
    ClearAnimations(playerid);
    gFishingState[playerid] = FISH_STATE_NONE;
    gFishingSpot[playerid] = -1;
    if(message) SendClientMessage(playerid, COLOR_GREY, "Рыбалка остановлена.");
    return 1;
}

stock Fishing_SellFish(playerid)
{
    if(!Fishing_IsNearCaptain(playerid))
    {
        SendClientMessage(playerid, COLOR_YELLOW, "Продать улов можно только капитану пирса. Метка поставлена.");
        Fishing_SetCaptainRoute(playerid);
        return 1;
    }

    if(gFishingBagCount[playerid] <= 0)
        return SendClientMessage(playerid, COLOR_GREY, "У вас нет рыбы для продажи."), 1;

    new money = gFishingBagMoney[playerid];
    new count = gFishingBagCount[playerid];
    gFishingBagMoney[playerid] = 0;
    gFishingBagCount[playerid] = 0;

    GivePlayerMoneyEx(playerid, money, "Продажа рыбы", true, true);

    new msg[128];
    format(msg, sizeof msg, "Вы продали рыбу: %d шт. Получено: %d руб.", count, money);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

stock Fishing_ShowStats(playerid)
{
    new msg[144];
    format(msg, sizeof msg, "Рыбалка: в садке %d/%d, стоимость %d руб., всего поймано %d.", gFishingBagCount[playerid], FISHING_BAG_LIMIT, gFishingBagMoney[playerid], gFishingTotalCaught[playerid]);
    SendClientMessage(playerid, COLOR_YELLOW, msg);
    return 1;
}

stock Fishing_SetNearestRoute(playerid)
{
    new spotid = Fishing_GetNearestSpot(playerid, 999999.0);
    if(spotid == -1) return 1;

    SetPlayerCheckpoint(playerid, gFishingSpots[spotid][0], gFishingSpots[spotid][1], gFishingSpots[spotid][2], 3.0);
    SetPlayerMapIcon(playerid, FISHING_MAP_ICON_SLOT, gFishingSpots[spotid][0], gFishingSpots[spotid][1], gFishingSpots[spotid][2], 9, 0x35D66BFF, 0);
    SendClientMessage(playerid, COLOR_YELLOW, "Метка на ближайшее место рыбалки установлена.");
    return 1;
}

stock Fishing_GetNearestSpot(playerid, Float:radius)
{
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    new nearest = -1;
    new Float:best = radius;
    for(new i = 0; i < sizeof(gFishingSpots); i++)
    {
        new Float:dx = px - gFishingSpots[i][0];
        new Float:dy = py - gFishingSpots[i][1];
        new Float:dz = pz - gFishingSpots[i][2];
        new Float:dist = floatsqroot(dx * dx + dy * dy + dz * dz);
        if(dist <= best)
        {
            best = dist;
            nearest = i;
        }
    }
    return nearest;
}

stock Fishing_RandomTarget(playerid)
{
    gFishingTargetMin[playerid] = 18 + random(58);
    gFishingTargetMax[playerid] = gFishingTargetMin[playerid] + 22;
    if(gFishingTargetMax[playerid] > 98)
    {
        gFishingTargetMax[playerid] = 98;
        gFishingTargetMin[playerid] = 76;
    }
    if(gFishingTDCreated[playerid]) Fishing_UpdateTargetTD(playerid);
    return 1;
}

stock Fishing_GetRandomFishId()
{
    new rand = random(100);
    if(rand < 35) return 0;
    if(rand < 60) return 1;
    if(rand < 78) return 2;
    if(rand < 91) return 3;
    if(rand < 98) return 4;
    return 5;
}

stock Fishing_GetFishName(fishid, name[], len)
{
    switch(fishid)
    {
        case 0: format(name, len, "Карась");
        case 1: format(name, len, "Окунь");
        case 2: format(name, len, "Карп");
        case 3: format(name, len, "Щука");
        case 4: format(name, len, "Сом");
        case 5: format(name, len, "Золотая рыба");
        default: format(name, len, "Рыба");
    }
    return 1;
}

stock Fishing_GetFishPrice(fishid)
{
    switch(fishid)
    {
        case 0: return 800;
        case 1: return 1100;
        case 2: return 1700;
        case 3: return 2600;
        case 4: return 4500;
        case 5: return 10000;
    }
    return 500;
}

stock Fishing_CreateInterface(playerid)
{
    Fishing_DestroyInterface(playerid);

    // Мини-игра под вид со скрина: без старого диалогового окна, только дуга, шарик, процент и нижняя шкала.
    gFishingTD[playerid][FISH_TD_BG] = CreatePlayerTextDraw(playerid, 190.0000, 260.0000, "_");
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_BG], 0.0000, 11.0000);
    PlayerTextDrawTextSize(playerid, gFishingTD[playerid][FISH_TD_BG], 450.0000, 0.0000);
    PlayerTextDrawUseBox(playerid, gFishingTD[playerid][FISH_TD_BG], 1);
    PlayerTextDrawBoxColor(playerid, gFishingTD[playerid][FISH_TD_BG], 0x00000000);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_BG], 1);

    gFishingTD[playerid][FISH_TD_TITLE] = CreatePlayerTextDraw(playerid, 320.0000, 265.0000, "");
    PlayerTextDrawAlignment(playerid, gFishingTD[playerid][FISH_TD_TITLE], 2);
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_TITLE], 0.2200, 0.8000);
    PlayerTextDrawColor(playerid, gFishingTD[playerid][FISH_TD_TITLE], COLOR_WHITE);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_TITLE], 1);

    gFishingTD[playerid][FISH_TD_HINT] = CreatePlayerTextDraw(playerid, 320.0000, 407.0000, "");
    PlayerTextDrawAlignment(playerid, gFishingTD[playerid][FISH_TD_HINT], 2);
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_HINT], 0.2000, 0.8000);
    PlayerTextDrawColor(playerid, gFishingTD[playerid][FISH_TD_HINT], COLOR_WHITE);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_HINT], 1);

    // Серая левая часть дуги.
    gFishingTD[playerid][FISH_TD_ARC_LEFT] = CreatePlayerTextDraw(playerid, 206.0000, 333.0000, "_");
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_ARC_LEFT], 0.0000, 5.2000);
    PlayerTextDrawTextSize(playerid, gFishingTD[playerid][FISH_TD_ARC_LEFT], 229.0000, 0.0000);
    PlayerTextDrawUseBox(playerid, gFishingTD[playerid][FISH_TD_ARC_LEFT], 1);
    PlayerTextDrawBoxColor(playerid, gFishingTD[playerid][FISH_TD_ARC_LEFT], 0x2C2C2CD0);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_ARC_LEFT], 1);

    // Зелёная дуга, разбита на сегменты, чтобы визуально была похожа на арку.
    gFishingTD[playerid][FISH_TD_ARC_LEFT_TOP] = CreatePlayerTextDraw(playerid, 224.0000, 306.0000, "_");
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_ARC_LEFT_TOP], 0.0000, 2.7000);
    PlayerTextDrawTextSize(playerid, gFishingTD[playerid][FISH_TD_ARC_LEFT_TOP], 276.0000, 0.0000);
    PlayerTextDrawUseBox(playerid, gFishingTD[playerid][FISH_TD_ARC_LEFT_TOP], 1);
    PlayerTextDrawBoxColor(playerid, gFishingTD[playerid][FISH_TD_ARC_LEFT_TOP], 0x35D66BEE);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_ARC_LEFT_TOP], 1);

    gFishingTD[playerid][FISH_TD_ARC_CENTER] = CreatePlayerTextDraw(playerid, 274.0000, 285.0000, "_");
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_ARC_CENTER], 0.0000, 2.7000);
    PlayerTextDrawTextSize(playerid, gFishingTD[playerid][FISH_TD_ARC_CENTER], 366.0000, 0.0000);
    PlayerTextDrawUseBox(playerid, gFishingTD[playerid][FISH_TD_ARC_CENTER], 1);
    PlayerTextDrawBoxColor(playerid, gFishingTD[playerid][FISH_TD_ARC_CENTER], 0x35D66BEE);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_ARC_CENTER], 1);

    gFishingTD[playerid][FISH_TD_ARC_RIGHT_TOP] = CreatePlayerTextDraw(playerid, 364.0000, 306.0000, "_");
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_ARC_RIGHT_TOP], 0.0000, 2.7000);
    PlayerTextDrawTextSize(playerid, gFishingTD[playerid][FISH_TD_ARC_RIGHT_TOP], 416.0000, 0.0000);
    PlayerTextDrawUseBox(playerid, gFishingTD[playerid][FISH_TD_ARC_RIGHT_TOP], 1);
    PlayerTextDrawBoxColor(playerid, gFishingTD[playerid][FISH_TD_ARC_RIGHT_TOP], 0x35D66BEE);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_ARC_RIGHT_TOP], 1);

    // Серая правая часть дуги.
    gFishingTD[playerid][FISH_TD_ARC_RIGHT] = CreatePlayerTextDraw(playerid, 411.0000, 333.0000, "_");
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_ARC_RIGHT], 0.0000, 5.2000);
    PlayerTextDrawTextSize(playerid, gFishingTD[playerid][FISH_TD_ARC_RIGHT], 434.0000, 0.0000);
    PlayerTextDrawUseBox(playerid, gFishingTD[playerid][FISH_TD_ARC_RIGHT], 1);
    PlayerTextDrawBoxColor(playerid, gFishingTD[playerid][FISH_TD_ARC_RIGHT], 0x2C2C2CD0);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_ARC_RIGHT], 1);

    // Нижняя тёмная шкала под проценты.
    gFishingTD[playerid][FISH_TD_BAR_BACK] = CreatePlayerTextDraw(playerid, FISH_BAR_X, FISH_BAR_Y, "_");
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_BAR_BACK], 0.0000, FISH_BAR_H);
    PlayerTextDrawTextSize(playerid, gFishingTD[playerid][FISH_TD_BAR_BACK], FISH_BAR_X + FISH_BAR_W, 0.0000);
    PlayerTextDrawUseBox(playerid, gFishingTD[playerid][FISH_TD_BAR_BACK], 1);
    PlayerTextDrawBoxColor(playerid, gFishingTD[playerid][FISH_TD_BAR_BACK], 0x2C2C2CD0);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_BAR_BACK], 1);

    // Процент поверх нижней шкалы.
    gFishingTD[playerid][FISH_TD_PERCENT] = CreatePlayerTextDraw(playerid, 320.0000, 352.0000, "44%");
    PlayerTextDrawAlignment(playerid, gFishingTD[playerid][FISH_TD_PERCENT], 2);
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_PERCENT], 0.4700, 1.8500);
    PlayerTextDrawColor(playerid, gFishingTD[playerid][FISH_TD_PERCENT], COLOR_WHITE);
    PlayerTextDrawSetOutline(playerid, gFishingTD[playerid][FISH_TD_PERCENT], 1);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_PERCENT], 2);

    // Жёлтый прогресс как на скрине.
    gFishingTD[playerid][FISH_TD_PROGRESS_BACK] = CreatePlayerTextDraw(playerid, FISH_PROGRESS_X, FISH_PROGRESS_Y, "_");
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_PROGRESS_BACK], 0.0000, FISH_PROGRESS_H);
    PlayerTextDrawTextSize(playerid, gFishingTD[playerid][FISH_TD_PROGRESS_BACK], FISH_PROGRESS_X + FISH_PROGRESS_W, 0.0000);
    PlayerTextDrawUseBox(playerid, gFishingTD[playerid][FISH_TD_PROGRESS_BACK], 1);
    PlayerTextDrawBoxColor(playerid, gFishingTD[playerid][FISH_TD_PROGRESS_BACK], 0x2C2C2CD0);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_PROGRESS_BACK], 1);

    gFishingTD[playerid][FISH_TD_PROGRESS_FILL] = CreatePlayerTextDraw(playerid, FISH_PROGRESS_X, FISH_PROGRESS_Y, "_");
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_PROGRESS_FILL], 0.0000, FISH_PROGRESS_H);
    PlayerTextDrawTextSize(playerid, gFishingTD[playerid][FISH_TD_PROGRESS_FILL], FISH_PROGRESS_X + 60.0000, 0.0000);
    PlayerTextDrawUseBox(playerid, gFishingTD[playerid][FISH_TD_PROGRESS_FILL], 1);
    PlayerTextDrawBoxColor(playerid, gFishingTD[playerid][FISH_TD_PROGRESS_FILL], 0xFAD201EE);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_PROGRESS_FILL], 1);

    gFishingTD[playerid][FISH_TD_INFO] = CreatePlayerTextDraw(playerid, 320.0000, 391.0000, "");
    PlayerTextDrawAlignment(playerid, gFishingTD[playerid][FISH_TD_INFO], 2);
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_INFO], 0.2100, 0.9000);
    PlayerTextDrawColor(playerid, gFishingTD[playerid][FISH_TD_INFO], COLOR_WHITE);
    PlayerTextDrawSetOutline(playerid, gFishingTD[playerid][FISH_TD_INFO], 1);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_INFO], 1);

    gFishingTDCreated[playerid] = true;

    for(new i = 0; i < FISH_TD_COUNT; i++)
    {
        if(i == FISH_TD_TARGET || i == FISH_TD_MARKER) continue;
        PlayerTextDrawShow(playerid, gFishingTD[playerid][i]);
    }

    Fishing_UpdateTargetTD(playerid);
    Fishing_UpdateMarkerTD(playerid);
    Fishing_UpdateInterface(playerid);
    return 1;
}

stock Fishing_UpdateInterface(playerid)
{
    if(!gFishingTDCreated[playerid]) return 1;

    new text[80];
    format(text, sizeof text, "%d%%", gFishingProgress[playerid]);
    PlayerTextDrawSetString(playerid, gFishingTD[playerid][FISH_TD_PERCENT], text);

    new Float:fill_x = FISH_PROGRESS_X + (float(gFishingProgress[playerid]) / 100.0) * FISH_PROGRESS_W;
    if(fill_x < FISH_PROGRESS_X + 3.0000) fill_x = FISH_PROGRESS_X + 3.0000;
    if(fill_x > FISH_PROGRESS_X + FISH_PROGRESS_W) fill_x = FISH_PROGRESS_X + FISH_PROGRESS_W;
    PlayerTextDrawTextSize(playerid, gFishingTD[playerid][FISH_TD_PROGRESS_FILL], fill_x, 0.0000);
    PlayerTextDrawShow(playerid, gFishingTD[playerid][FISH_TD_PROGRESS_FILL]);

    format(text, sizeof text, "Садок: %d/%d | продажа у капитана", gFishingBagCount[playerid], FISHING_BAG_LIMIT);
    PlayerTextDrawSetString(playerid, gFishingTD[playerid][FISH_TD_INFO], text);

    Fishing_UpdateMarkerTD(playerid);
    return 1;
}

stock Fishing_UpdateTargetTD(playerid)
{
    if(!gFishingTDCreated[playerid]) return 1;

    if(gFishingTargetTDShown[playerid])
    {
        PlayerTextDrawDestroy(playerid, gFishingTD[playerid][FISH_TD_TARGET]);
        gFishingTargetTDShown[playerid] = false;
    }

    new Float:x1 = FISH_BAR_X + (float(gFishingTargetMin[playerid]) / 100.0) * FISH_BAR_W;
    new Float:x2 = FISH_BAR_X + (float(gFishingTargetMax[playerid]) / 100.0) * FISH_BAR_W;

    gFishingTD[playerid][FISH_TD_TARGET] = CreatePlayerTextDraw(playerid, x1, FISH_BAR_Y, "_");
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_TARGET], 0.0000, FISH_BAR_H);
    PlayerTextDrawTextSize(playerid, gFishingTD[playerid][FISH_TD_TARGET], x2, 0.0000);
    PlayerTextDrawUseBox(playerid, gFishingTD[playerid][FISH_TD_TARGET], 1);
    PlayerTextDrawBoxColor(playerid, gFishingTD[playerid][FISH_TD_TARGET], 0x35D66BEE);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_TARGET], 1);
    PlayerTextDrawShow(playerid, gFishingTD[playerid][FISH_TD_TARGET]);
    gFishingTargetTDShown[playerid] = true;
    return 1;
}

stock Fishing_UpdateMarkerTD(playerid)
{
    if(!gFishingTDCreated[playerid]) return 1;

    if(gFishingMarkerTDShown[playerid])
    {
        PlayerTextDrawDestroy(playerid, gFishingTD[playerid][FISH_TD_MARKER]);
        gFishingMarkerTDShown[playerid] = false;
    }

    // Двигаем белый шарик по условной дуге, а не по простой прямой линии.
    new Float:x = 210.0000 + (gFishingMarker[playerid] / 100.0) * 220.0000;
    new Float:offset = (gFishingMarker[playerid] - 50.0) / 50.0;
    new Float:y = 337.0000 - (1.0 - (offset * offset)) * 54.0000;

    gFishingTD[playerid][FISH_TD_MARKER] = CreatePlayerTextDraw(playerid, x - 4.0000, y - 8.0000, "O");
    PlayerTextDrawLetterSize(playerid, gFishingTD[playerid][FISH_TD_MARKER], 0.3600, 1.4000);
    PlayerTextDrawColor(playerid, gFishingTD[playerid][FISH_TD_MARKER], 0xFFFFFFFF);
    PlayerTextDrawSetOutline(playerid, gFishingTD[playerid][FISH_TD_MARKER], 1);
    PlayerTextDrawFont(playerid, gFishingTD[playerid][FISH_TD_MARKER], 2);
    PlayerTextDrawShow(playerid, gFishingTD[playerid][FISH_TD_MARKER]);
    gFishingMarkerTDShown[playerid] = true;
    return 1;
}

stock Fishing_DestroyInterface(playerid)
{
    if(!gFishingTDCreated[playerid]) return 1;

    for(new i = 0; i < FISH_TD_COUNT; i++)
    {
        PlayerTextDrawHide(playerid, gFishingTD[playerid][i]);
        PlayerTextDrawDestroy(playerid, gFishingTD[playerid][i]);
        gFishingTD[playerid][i] = PlayerText:0;
    }
    gFishingTargetTDShown[playerid] = false;
    gFishingMarkerTDShown[playerid] = false;
    gFishingTDCreated[playerid] = false;
    return 1;
}
