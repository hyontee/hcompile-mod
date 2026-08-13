#if defined _autumn_event_included
    #endinput
#endif
#define _autumn_event_included

#include <a_samp>
#tryinclude <a_actor>

// Предварительное объявление forward для предотвращения ошибки 025
#if !defined OnPlayerGiveDamageActor
forward OnPlayerGiveDamageActor(playerid, actorid, Float:amount, weaponid, bodypart);
#endif

#define DIALOG_AUTUMN_TALK      (20860)
#define DIALOG_AUTUMN_OFFER     (20861)
#define DIALOG_AUTUMN_WIN       (20862)
#define DIALOG_AUTUMN_FAIL      (20863)

#define AUTUMN_SEMEN_ACTOR_MODEL   (208)
#define AUTUMN_GHOST_ACTOR_MODEL   (175)
#define AUTUMN_INTERACT_RADIUS     (1.8)
#define AUTUMN_CHECK_INTERVAL      (800)
#define AUTUMN_COUNTDOWN_START     (5)
#define AUTUMN_TARGET_SCORE        (10)
#define AUTUMN_ATTACK_TIMEOUT      (3500)
#define AUTUMN_REWARD_MONEY        (50000)
#define AUTUMN_WEAPON_ID           (24)
#define AUTUMN_WEAPON_AMMO         (1000)

static const Float:g_SemenSpawns[][4] =
{
    {-2165.647705, 1564.864379, 9.876050, 224.971862},
    {-2655.623535, 1997.030883, 9.979868, 6.456680},
    {1791.581054,  2529.907714, 14.555471, 223.129547},
    {-2430.060791, 187.469757,  26.135101, 359.582702},
    {2753.797607, -2439.395019, 21.813438, 108.323303},
    {831.837097,   800.696899,  13.167908, 245.903869}
};

static const Float:QUEST_START_POS[4] = {-2212.765136, -382.880920, 39.104820, 92.582084};

static const Float:GHOST_SPAWNS[][4] =
{
    {-2222.111816, -382.810638, 39.104820, 262.702545},
    {-2220.990966, -378.230377, 39.104820, 242.103225},
    {-2219.180175, -386.401031, 39.104820, 297.991394},
    {-2218.313232, -378.647155, 39.104820, 238.091537},
    {-2216.941894, -385.152862, 39.104820, 303.956237},
    {-2223.509277, -384.410827, 39.483211, 279.610595},
    {-2221.602783, -381.051391, 39.104820, 256.651092}
};

new g_SemenActors[sizeof(g_SemenSpawns)];

enum enum_AutumnPlayerData
{
    bool:pQuestActive,
    pCurrentSemenID,
    pScore,
    pCountdown,
    pGhostActor,
    pTimerCD,
    pTimerAttack,
    bool:pNearSemenNPC
};

new g_AutumnPlayer[MAX_PLAYERS][enum_AutumnPlayerData];

new Text:TD_AutumnStatus[MAX_PLAYERS] = {Text:INVALID_TEXT_DRAW, ...};

forward Autumn_OnCountdown(playerid);
forward Autumn_OnGhostAttackTimeout(playerid);
forward Autumn_CheckPlayersNearSemen();

public Autumn_CheckPlayersNearSemen()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(g_AutumnPlayer[i][pQuestActive])
        {
            g_AutumnPlayer[i][pNearSemenNPC] = false;
            continue;
        }

        new bool:found = false;

        for(new s = 0; s < sizeof(g_SemenSpawns); s++)
        {
            if(IsPlayerInRangeOfPoint(i, AUTUMN_INTERACT_RADIUS, g_SemenSpawns[s][0], g_SemenSpawns[s][1], g_SemenSpawns[s][2]))
            {
                found = true;

                if(!g_AutumnPlayer[i][pNearSemenNPC])
                {
                    g_AutumnPlayer[i][pCurrentSemenID] = s;

                    ShowPlayerDialog(i, DIALOG_AUTUMN_TALK, DIALOG_STYLE_MSGBOX,
                        "{FF9900}Workk RP | Осеннее событие",
                        "{FFFFFF}Дядюшка Семен:\nНа заброшке завелись люди в масках Крика! Помоги прогнать их!",
                        "Далее", "Отмена"
                    );
                }
                break;
            }
        }

        g_AutumnPlayer[i][pNearSemenNPC] = found;
    }
    return 1;
}

stock Autumn_StartMission(playerid)
{
    g_AutumnPlayer[playerid][pQuestActive] = true;
    g_AutumnPlayer[playerid][pScore] = 0;
    g_AutumnPlayer[playerid][pCountdown] = AUTUMN_COUNTDOWN_START;

    GivePlayerWeapon(playerid, AUTUMN_WEAPON_ID, AUTUMN_WEAPON_AMMO);

    SetPlayerPos(playerid, QUEST_START_POS[0], QUEST_START_POS[1], QUEST_START_POS[2]);
    SetPlayerFacingAngle(playerid, QUEST_START_POS[3]);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, 0);

    SendClientMessage(playerid, 0xFF9900FF, "[WORKK] {FFFFFF}ВНИМАНИЕ! ПРИЗРАКИ ПОЯВЛЯЮТСЯ НА ЗАБРОШКЕ!");

    if(TD_AutumnStatus[playerid] != Text:INVALID_TEXT_DRAW)
    {
        TextDrawDestroy(TD_AutumnStatus[playerid]);
    }

    TD_AutumnStatus[playerid] = TextDrawCreate(240.0, 140.0, "~g~5");
    TextDrawLetterSize(TD_AutumnStatus[playerid], 0.65, 2.6);
    TextDrawAlignment(TD_AutumnStatus[playerid], 2);
    TextDrawSetOutline(TD_AutumnStatus[playerid], 2);
    TextDrawShowForPlayer(playerid, TD_AutumnStatus[playerid]);

    g_AutumnPlayer[playerid][pTimerCD] = SetTimerEx("Autumn_OnCountdown", 1000, true, "i", playerid);
    return 1;
}

public Autumn_OnCountdown(playerid)
{
    g_AutumnPlayer[playerid][pCountdown]--;

    if(g_AutumnPlayer[playerid][pCountdown] > 0)
    {
        new str[16];
        format(str, sizeof(str), "~g~%d", g_AutumnPlayer[playerid][pCountdown]);
        TextDrawSetString(TD_AutumnStatus[playerid], str);
    }
    else
    {
        KillTimer(g_AutumnPlayer[playerid][pTimerCD]);
        TogglePlayerControllable(playerid, 1);
        TextDrawSetString(TD_AutumnStatus[playerid], "0/10");
        Autumn_SpawnNextGhost(playerid);
    }
    return 1;
}

stock Autumn_SpawnNextGhost(playerid)
{
    if(g_AutumnPlayer[playerid][pGhostActor] != INVALID_ACTOR_ID)
    {
        DestroyActor(g_AutumnPlayer[playerid][pGhostActor]);
        g_AutumnPlayer[playerid][pGhostActor] = INVALID_ACTOR_ID;
    }

    new rand = random(sizeof(GHOST_SPAWNS));
    g_AutumnPlayer[playerid][pGhostActor] = CreateActor(AUTUMN_GHOST_ACTOR_MODEL, GHOST_SPAWNS[rand][0], GHOST_SPAWNS[rand][1], GHOST_SPAWNS[rand][2], GHOST_SPAWNS[rand][3]);

    if(g_AutumnPlayer[playerid][pTimerAttack]) KillTimer(g_AutumnPlayer[playerid][pTimerAttack]);
    g_AutumnPlayer[playerid][pTimerAttack] = SetTimerEx("Autumn_OnGhostAttackTimeout", AUTUMN_ATTACK_TIMEOUT, false, "i", playerid);
    return 1;
}

public Autumn_OnGhostAttackTimeout(playerid)
{
    if(!g_AutumnPlayer[playerid][pQuestActive]) return 1;

    Autumn_CleanupMission(playerid);

    ShowPlayerDialog(playerid, DIALOG_AUTUMN_FAIL, DIALOG_STYLE_MSGBOX,
        "{FF9900}Workk RP | Неудача",
        "{FFFFFF}К сожелению вы проиграли, Хотите попробовать ещо раз ?",
        "Да", "Нет, вернутся назад"
    );
    return 1;
}

stock Autumn_CleanupMission(playerid)
{
    g_AutumnPlayer[playerid][pQuestActive] = false;

    if(g_AutumnPlayer[playerid][pTimerCD]) KillTimer(g_AutumnPlayer[playerid][pTimerCD]);
    if(g_AutumnPlayer[playerid][pTimerAttack]) KillTimer(g_AutumnPlayer[playerid][pTimerAttack]);

    if(g_AutumnPlayer[playerid][pGhostActor] != INVALID_ACTOR_ID)
    {
        DestroyActor(g_AutumnPlayer[playerid][pGhostActor]);
        g_AutumnPlayer[playerid][pGhostActor] = INVALID_ACTOR_ID;
    }

    if(TD_AutumnStatus[playerid] != Text:INVALID_TEXT_DRAW)
    {
        TextDrawDestroy(TD_AutumnStatus[playerid]);
        TD_AutumnStatus[playerid] = Text:INVALID_TEXT_DRAW;
    }

    ResetPlayerWeapons(playerid);
    return 1;
}

stock Autumn_ReturnToSemen(playerid)
{
    new id = g_AutumnPlayer[playerid][pCurrentSemenID];
    SetPlayerPos(playerid, g_SemenSpawns[id][0] + 1.2, g_SemenSpawns[id][1], g_SemenSpawns[id][2]);
    SetPlayerFacingAngle(playerid, g_SemenSpawns[id][3]);
    SetCameraBehindPlayer(playerid);
    g_AutumnPlayer[playerid][pNearSemenNPC] = false;
    return 1;
}

public OnPlayerGiveDamageActor(playerid, actorid, Float:amount, weaponid, bodypart)
{
    if(g_AutumnPlayer[playerid][pQuestActive] && actorid == g_AutumnPlayer[playerid][pGhostActor])
    {
        KillTimer(g_AutumnPlayer[playerid][pTimerAttack]);

        g_AutumnPlayer[playerid][pScore]++;

        new str[16];
        format(str, sizeof(str), "%d/10", g_AutumnPlayer[playerid][pScore]);
        TextDrawSetString(TD_AutumnStatus[playerid], str);

        if(g_AutumnPlayer[playerid][pScore] >= AUTUMN_TARGET_SCORE)
        {
            Autumn_CleanupMission(playerid);

            ShowPlayerDialog(playerid, DIALOG_AUTUMN_WIN, DIALOG_STYLE_MSGBOX,
                "{FF9900}Workk RP | Осенняя миссия",
                "{FFFFFF}Поздровляю! Вы прошли мисию и получили свой заслуженный приз:\n\n{00FF7F}50 000 руб.\n5 xp",
                "Вернутся назад", ""
            );
        }
        else
        {
            Autumn_SpawnNextGhost(playerid);
        }

#if defined autumn_OnPlayerGiveDamageActor
        autumn_OnPlayerGiveDamageActor(playerid, actorid, amount, weaponid, bodypart);
#endif
        return 1;
    }

#if defined autumn_OnPlayerGiveDamageActor
    return autumn_OnPlayerGiveDamageActor(playerid, actorid, amount, weaponid, bodypart);
#else
    return 0;
#endif
}
#if defined _ALS_OnPlayerGiveDamageActor
    #undef OnPlayerGiveDamageActor
#else
    #define _ALS_OnPlayerGiveDamageActor
#endif
#define OnPlayerGiveDamageActor autumn_OnPlayerGiveDamageActor
#if defined autumn_OnPlayerGiveDamageActor
forward autumn_OnPlayerGiveDamageActor(playerid, actorid, Float:amount, weaponid, bodypart);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_AUTUMN_TALK)
    {
        if(response)
        {
            ShowPlayerDialog(playerid, DIALOG_AUTUMN_OFFER, DIALOG_STYLE_MSGBOX,
                "{FF9900}Workk RP | Осеннее событие",
                "{FFFFFF}Согласен ли ты помочь дяде Семёну ?",
                "Да", "Нет"
            );
        }
        return 1;
    }

    if(dialogid == DIALOG_AUTUMN_OFFER)
    {
        if(response) Autumn_StartMission(playerid);
        return 1;
    }

    if(dialogid == DIALOG_AUTUMN_WIN)
    {
        GivePlayerMoneyEx(playerid, AUTUMN_REWARD_MONEY, "Осеннее событие Крик", true, true);
        Autumn_ReturnToSemen(playerid);
        return 1;
    }

    if(dialogid == DIALOG_AUTUMN_FAIL)
    {
        if(response)
        {
            Autumn_StartMission(playerid);
        }
        else
        {
            Autumn_ReturnToSemen(playerid);
        }
        return 1;
    }

#if defined autumn_OnDialogResponse
    return autumn_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#else
    return 0;
#endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse autumn_OnDialogResponse
#if defined autumn_OnDialogResponse
forward autumn_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnGameModeInit()
{
    for(new i = 0; i < sizeof(g_SemenSpawns); i++)
    {
        g_SemenActors[i] = CreateActor(AUTUMN_SEMEN_ACTOR_MODEL, g_SemenSpawns[i][0], g_SemenSpawns[i][1], g_SemenSpawns[i][2], g_SemenSpawns[i][3]);

        Create3DTextLabel(
            "{FF9900}Дядюшка Семен\n{FFFFFF}Подойдите ближе для {FFFF00}взаимодействия",
            0xFFFFFFFF, g_SemenSpawns[i][0], g_SemenSpawns[i][1], g_SemenSpawns[i][2] + 1.15, 10.0, 0, 0
        );
    }

    SetTimer("Autumn_CheckPlayersNearSemen", AUTUMN_CHECK_INTERVAL, true);

    printf("[WORKK] Осеннее событие загружено!");

#if defined autumn_OnGameModeInit
    autumn_OnGameModeInit();
#endif
    return 1;
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit autumn_OnGameModeInit
#if defined autumn_OnGameModeInit
forward autumn_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
    g_AutumnPlayer[playerid][pQuestActive] = false;
    g_AutumnPlayer[playerid][pCurrentSemenID] = 0;
    g_AutumnPlayer[playerid][pScore] = 0;
    g_AutumnPlayer[playerid][pGhostActor] = INVALID_ACTOR_ID;
    g_AutumnPlayer[playerid][pNearSemenNPC] = false;

#if defined autumn_OnPlayerConnect
    autumn_OnPlayerConnect(playerid);
#endif
    return 1;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect autumn_OnPlayerConnect
#if defined autumn_OnPlayerConnect
forward autumn_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    Autumn_CleanupMission(playerid);

#if defined autumn_OnPlayerDisconnect
    autumn_OnPlayerDisconnect(playerid, reason);
#endif
    return 1;
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect autumn_OnPlayerDisconnect
#if defined autumn_OnPlayerDisconnect
forward autumn_OnPlayerDisconnect(playerid, reason);
#endif
