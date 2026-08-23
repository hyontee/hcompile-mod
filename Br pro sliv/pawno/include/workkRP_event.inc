// Автор Riven (Workk [@Dmitry_codin]
// postav codirovku nd cirilica windows 1251

#if defined _WorkkRP_event_included
    #endinput
#endif
#define _WorkkRP_event_included

#include <a_samp>

#define DIALOG_WORKKRP_TALK      (20860)
#define DIALOG_WORKKRP_OFFER     (20861)
#define DIALOG_WORKKRP_WIN       (20862)
#define DIALOG_WORKKRP_FAIL      (20863)

#define WORKKRP_SEMEN_ACTOR_MODEL   (208)
#define WORKKRP_GHOST_ACTOR_MODEL   (175)
#define WORKKRP_INTERACT_RADIUS     (1.8)
#define WORKKRP_CHECK_INTERVAL      (800)
#define WORKKRP_COUNTDOWN_START     (5)
#define WORKKRP_TARGET_SCORE        (10)
#define WORKKRP_ATTACK_TIMEOUT      (3500)
#define WORKKRP_REWARD_MONEY        (50000)
#define WORKKRP_WEAPON_ID           (24)
#define WORKKRP_WEAPON_AMMO         (1000)

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

enum enum_WorkkRPPlayerData
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

new g_WorkkRPPlayer[MAX_PLAYERS][enum_WorkkRPPlayerData];

new Text:TD_WorkkRPStatus[MAX_PLAYERS] = {Text:INVALID_TEXT_DRAW, ...};

forward WorkkRP_OnCountdown(playerid);
forward WorkkRP_OnGhostAttackTimeout(playerid);
forward WorkkRP_CheckPlayersNearSemen();

public WorkkRP_CheckPlayersNearSemen()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(g_WorkkRPPlayer[i][pQuestActive])
        {
            g_WorkkRPPlayer[i][pNearSemenNPC] = false;
            continue;
        }

        new bool:found = false;

        for(new s = 0; s < sizeof(g_SemenSpawns); s++)
        {
            if(IsPlayerInRangeOfPoint(i, WORKKRP_INTERACT_RADIUS, g_SemenSpawns[s][0], g_SemenSpawns[s][1], g_SemenSpawns[s][2]))
            {
                found = true;

                if(!g_WorkkRPPlayer[i][pNearSemenNPC])
                {
                    g_WorkkRPPlayer[i][pCurrentSemenID] = s;

                    ShowPlayerDialog(i, DIALOG_WORKKRP_TALK, DIALOG_STYLE_MSGBOX,
                        "{FF9900}Workk RP | Осеннее событие",
                        "{FFFFFF}Дядюшка Семен:\nНа заброшке завелись люди в масках Крика! Помоги прогнать их!",
                        "Далее", "Отмена"
                    );
                }
                break;
            }
        }

        g_WorkkRPPlayer[i][pNearSemenNPC] = found;
    }
    return 1;
}

stock WorkkRP_StartMission(playerid)
{
    g_WorkkRPPlayer[playerid][pQuestActive] = true;
    g_WorkkRPPlayer[playerid][pScore] = 0;
    g_WorkkRPPlayer[playerid][pCountdown] = WORKKRP_COUNTDOWN_START;

    GivePlayerWeapon(playerid, WORKKRP_WEAPON_ID, WORKKRP_WEAPON_AMMO);

    SetPlayerPos(playerid, QUEST_START_POS[0], QUEST_START_POS[1], QUEST_START_POS[2]);
    SetPlayerFacingAngle(playerid, QUEST_START_POS[3]);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, 0);

    SendClientMessage(playerid, 0xFF9900FF, "[WORKK] {FFFFFF}ВНИМАНИЕ! ПРИЗРАКИ ПОЯВЛЯЮТСЯ НА ЗАБРОШКЕ!");

    if(TD_WorkkRPStatus[playerid] != Text:INVALID_TEXT_DRAW)
    {
        TextDrawDestroy(TD_WorkkRPStatus[playerid]);
    }

    TD_WorkkRPStatus[playerid] = TextDrawCreate(240.0, 140.0, "~g~5");
    TextDrawLetterSize(TD_WorkkRPStatus[playerid], 0.65, 2.6);
    TextDrawAlignment(TD_WorkkRPStatus[playerid], 2);
    TextDrawSetOutline(TD_WorkkRPStatus[playerid], 2);
    TextDrawShowForPlayer(playerid, TD_WorkkRPStatus[playerid]);

    g_WorkkRPPlayer[playerid][pTimerCD] = SetTimerEx("WorkkRP_OnCountdown", 1000, true, "i", playerid);
    return 1;
}

public WorkkRP_OnCountdown(playerid)
{
    g_WorkkRPPlayer[playerid][pCountdown]--;

    if(g_WorkkRPPlayer[playerid][pCountdown] > 0)
    {
        new str[16];
        format(str, sizeof(str), "~g~%d", g_WorkkRPPlayer[playerid][pCountdown]);
        TextDrawSetString(TD_WorkkRPStatus[playerid], str);
    }
    else
    {
        KillTimer(g_WorkkRPPlayer[playerid][pTimerCD]);
        TogglePlayerControllable(playerid, 1);
        TextDrawSetString(TD_WorkkRPStatus[playerid], "0/10");
        WorkkRP_SpawnNextGhost(playerid);
    }
    return 1;
}

stock WorkkRP_SpawnNextGhost(playerid)
{
    if(g_WorkkRPPlayer[playerid][pGhostActor] != INVALID_ACTOR_ID)
    {
        DestroyActor(g_WorkkRPPlayer[playerid][pGhostActor]);
        g_WorkkRPPlayer[playerid][pGhostActor] = INVALID_ACTOR_ID;
    }

    new rand = random(sizeof(GHOST_SPAWNS));
    g_WorkkRPPlayer[playerid][pGhostActor] = CreateActor(WORKKRP_GHOST_ACTOR_MODEL, GHOST_SPAWNS[rand][0], GHOST_SPAWNS[rand][1], GHOST_SPAWNS[rand][2], GHOST_SPAWNS[rand][3]);

    if(g_WorkkRPPlayer[playerid][pTimerAttack]) KillTimer(g_WorkkRPPlayer[playerid][pTimerAttack]);
    g_WorkkRPPlayer[playerid][pTimerAttack] = SetTimerEx("WorkkRP_OnGhostAttackTimeout", WORKKRP_ATTACK_TIMEOUT, false, "i", playerid);
    return 1;
}

public WorkkRP_OnGhostAttackTimeout(playerid)
{
    if(!g_WorkkRPPlayer[playerid][pQuestActive]) return 1;

    WorkkRP_CleanupMission(playerid);

    ShowPlayerDialog(playerid, DIALOG_WORKKRP_FAIL, DIALOG_STYLE_MSGBOX,
        "{FF9900}Workk RP | Неудача",
        "{FFFFFF}К сожелению вы проиграли, Хотите попробовать ещо раз ?",
        "Да", "Нет, вернутся назад"
    );
    return 1;
}

stock WorkkRP_CleanupMission(playerid)
{
    g_WorkkRPPlayer[playerid][pQuestActive] = false;

    if(g_WorkkRPPlayer[playerid][pTimerCD]) KillTimer(g_WorkkRPPlayer[playerid][pTimerCD]);
    if(g_WorkkRPPlayer[playerid][pTimerAttack]) KillTimer(g_WorkkRPPlayer[playerid][pTimerAttack]);

    if(g_WorkkRPPlayer[playerid][pGhostActor] != INVALID_ACTOR_ID)
    {
        DestroyActor(g_WorkkRPPlayer[playerid][pGhostActor]);
        g_WorkkRPPlayer[playerid][pGhostActor] = INVALID_ACTOR_ID;
    }

    if(TD_WorkkRPStatus[playerid] != Text:INVALID_TEXT_DRAW)
    {
        TextDrawDestroy(TD_WorkkRPStatus[playerid]);
        TD_WorkkRPStatus[playerid] = Text:INVALID_TEXT_DRAW;
    }

    ResetPlayerWeapons(playerid);
    return 1;
}

stock WorkkRP_ReturnToSemen(playerid)
{
    new id = g_WorkkRPPlayer[playerid][pCurrentSemenID];
    SetPlayerPos(playerid, g_SemenSpawns[id][0] + 1.2, g_SemenSpawns[id][1], g_SemenSpawns[id][2]);
    SetPlayerFacingAngle(playerid, g_SemenSpawns[id][3]);
    SetCameraBehindPlayer(playerid);
    g_WorkkRPPlayer[playerid][pNearSemenNPC] = false;
    return 1;
}

public OnPlayerGiveDamageActor(playerid, damaged_actorid, Float:amount, weaponid, bodypart)
{
    if(g_WorkkRPPlayer[playerid][pQuestActive] && damaged_actorid == g_WorkkRPPlayer[playerid][pGhostActor])
    {
        KillTimer(g_WorkkRPPlayer[playerid][pTimerAttack]);

        g_WorkkRPPlayer[playerid][pScore]++;

        new str[16];
        format(str, sizeof(str), "%d/10", g_WorkkRPPlayer[playerid][pScore]);
        TextDrawSetString(TD_WorkkRPStatus[playerid], str);

        if(g_WorkkRPPlayer[playerid][pScore] >= WORKKRP_TARGET_SCORE)
        {
            WorkkRP_CleanupMission(playerid);

            ShowPlayerDialog(playerid, DIALOG_WORKKRP_WIN, DIALOG_STYLE_MSGBOX,
                "{FF9900}Workk RP | Осенняя миссия",
                "{FFFFFF}Поздровляю! Вы прошли мисию и получили свой заслуженный приз:\n\n{00FF7F}50 000 руб.\n5 xp",
                "Вернутся назад", ""
            );
        }
        else
        {
            WorkkRP_SpawnNextGhost(playerid);
        }
        return 1;
    }
    return 0;
}

stock WorkkRPEvent_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused listitem
    #pragma unused inputtext

    if(dialogid == DIALOG_WORKKRP_TALK)
    {
        if(response)
        {
            ShowPlayerDialog(playerid, DIALOG_WORKKRP_OFFER, DIALOG_STYLE_MSGBOX,
                "{FF9900}Workk RP | Осеннее событие",
                "{FFFFFF}Согласен ли ты помочь дяде Семёну ?",
                "Да", "Нет"
            );
        }
        return 1;
    }

    if(dialogid == DIALOG_WORKKRP_OFFER)
    {
        if(response) WorkkRP_StartMission(playerid);
        return 1;
    }

    if(dialogid == DIALOG_WORKKRP_WIN)
    {
        GivePlayerMoney(playerid, WORKKRP_REWARD_MONEY);
        WorkkRP_ReturnToSemen(playerid);
        return 1;
    }

    if(dialogid == DIALOG_WORKKRP_FAIL)
    {
        if(response)
        {
            WorkkRP_StartMission(playerid);
        }
        else
        {
            WorkkRP_ReturnToSemen(playerid);
        }
        return 1;
    }

    return 0;
}

stock WorkkRPEvent_OnGameModeInit()
{
    for(new i = 0; i < sizeof(g_SemenSpawns); i++)
    {
        g_SemenActors[i] = CreateActor(WORKKRP_SEMEN_ACTOR_MODEL, g_SemenSpawns[i][0], g_SemenSpawns[i][1], g_SemenSpawns[i][2], g_SemenSpawns[i][3]);

        Create3DTextLabel(
            "{FF9900}Дядюшка Семен\n{FFFFFF}Подойдите ближе для {FFFF00}взаимодействия",
            0xFFFFFFFF, g_SemenSpawns[i][0], g_SemenSpawns[i][1], g_SemenSpawns[i][2] + 1.15, 10.0, 0, 0
        );
    }

    SetTimer("WorkkRP_CheckPlayersNearSemen", WORKKRP_CHECK_INTERVAL, true);

    printf("[WORKK] Осеннее событие загружено!");
    return 1;
}

stock WorkkRPEvent_OnPlayerConnect(playerid)
{
    g_WorkkRPPlayer[playerid][pQuestActive] = false;
    g_WorkkRPPlayer[playerid][pCurrentSemenID] = 0;
    g_WorkkRPPlayer[playerid][pScore] = 0;
    g_WorkkRPPlayer[playerid][pGhostActor] = INVALID_ACTOR_ID;
    g_WorkkRPPlayer[playerid][pNearSemenNPC] = false;
    return 1;
}

stock WorkkRPEvent_OnPlayerDisconnect(playerid)
{
    WorkkRP_CleanupMission(playerid);
    return 1;
}
