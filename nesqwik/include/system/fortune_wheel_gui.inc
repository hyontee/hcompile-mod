/*
    PRO GUI-колесо фортуны для laird.pwn

    Версия: GTA/CSGO style
    Что изменено:
    - ровная сетка секторов без прыгающих TextDraw;
    - честный прокрут: приз выбирается заранее, а анимация докручивается именно до него;
    - выдача награды только после полной остановки;
    - обновляются только старые/новые сектора и соседи, а не весь интерфейс;
    - псевдо-3D эффект через TD + preview model в центре;
    - звук щелчков при прокруте и звук выигрыша;
    - VIP-режим с отдельными шансами и ультра-джекпотом;
    - лёгкая анимация камеры при открытии.
*/

#if defined _fortune_wheel_gui_included
    #endinput
#endif
#define _fortune_wheel_gui_included

#define FORTUNE_PRIZES                 (9)
#define FORTUNE_TD_BG                  (0)
#define FORTUNE_TD_TITLE               (1)
#define FORTUNE_TD_SUBTITLE            (2)
#define FORTUNE_TD_ARROW               (3)
#define FORTUNE_TD_MODEL               (4)
#define FORTUNE_TD_CENTER              (5)
#define FORTUNE_TD_SPIN                (6)
#define FORTUNE_TD_CLOSE               (7)
#define FORTUNE_TD_HINT                (8)
#define FORTUNE_TD_PRIZE_START         (9)
#define FORTUNE_TD_COUNT               (18)

#define FORTUNE_SPIN_PRICE             (50000)
#define FORTUNE_MIN_ROTATIONS          (5)
#define FORTUNE_MAX_EXTRA_ROTATIONS    (3)
#define FORTUNE_PREVIEW_MODEL_ID       (1080)
#define FORTUNE_USE_CAMERA             (1)
#define FORTUNE_USE_SOUNDS             (1)

#define FORTUNE_COLOR_MAIN             (0xFFCD00FF)
#define FORTUNE_COLOR_WHITE            (0xFFFFFFFF)
#define FORTUNE_COLOR_GRAY             (0xCECECEFF)
#define FORTUNE_COLOR_DARK_GRAY        (0x8E8E8EFF)
#define FORTUNE_COLOR_RED              (0xFF5252FF)
#define FORTUNE_COLOR_GREEN            (0x66CC33FF)
#define FORTUNE_COLOR_BG               (0x070707E8)
#define FORTUNE_COLOR_BOX              (0x1B1B1BDD)
#define FORTUNE_COLOR_NEAR             (0x333333DD)
#define FORTUNE_COLOR_HILITE           (0xFFCD00EE)
#define FORTUNE_COLOR_VIP              (0xB45CFFFF)

#define FORTUNE_SOUND_CLICK_FAST       (1057)
#define FORTUNE_SOUND_CLICK_SLOW       (1137)
#define FORTUNE_SOUND_WIN              (5203)

#if !defined CAMERA_MOVE
    #define CAMERA_MOVE                (1)
#endif

enum E_FORTUNE_REWARD_TYPE
{
    FORTUNE_REWARD_MONEY = 1,
    FORTUNE_REWARD_EXP,
    FORTUNE_REWARD_DONATE,
    FORTUNE_REWARD_CASE,
    FORTUNE_REWARD_VIP
};

enum E_FORTUNE_PRIZE
{
    FORTUNE_PRIZE_NAME[36],
    FORTUNE_PRIZE_TYPE,
    FORTUNE_PRIZE_VALUE,
    FORTUNE_PRIZE_CHANCE,
    FORTUNE_PRIZE_VIP_CHANCE
};

new const g_fortune_prize[][E_FORTUNE_PRIZE] =
{
    {"10 000 руб.",          FORTUNE_REWARD_MONEY,   10000, 260, 180},
    {"35 000 руб.",          FORTUNE_REWARD_MONEY,   35000, 190, 170},
    {"75 000 руб.",          FORTUNE_REWARD_MONEY,   75000, 115, 140},
    {"150 000 руб.",         FORTUNE_REWARD_MONEY,  150000,  55,  85},
    {"10 EXP",               FORTUNE_REWARD_EXP,        10, 155, 135},
    {"25 донат-монет",       FORTUNE_REWARD_DONATE,     25,  75, 105},
    {"1 кейс",               FORTUNE_REWARD_CASE,        1,  65,  90},
    {"ДЖЕКПОТ 500 000",      FORTUNE_REWARD_MONEY,  500000,  18,  35},
    {"VIP ДЖЕКПОТ 1 000 000",FORTUNE_REWARD_MONEY, 1000000,   0,  12}
};

new Float:g_fortune_pos_x[FORTUNE_PRIZES] =
{
    320.0, 382.0, 424.0, 405.0, 352.0, 288.0, 235.0, 216.0, 258.0
};

new Float:g_fortune_pos_y[FORTUNE_PRIZES] =
{
    114.0, 136.0, 190.0, 248.0, 282.0, 282.0, 248.0, 190.0, 136.0
};

new PlayerText:g_fortune_td[MAX_PLAYERS][FORTUNE_TD_COUNT];
new bool:g_fortune_created[MAX_PLAYERS];
new bool:g_fortune_open[MAX_PLAYERS];
new bool:g_fortune_spinning[MAX_PLAYERS];
new bool:g_fortune_camera[MAX_PLAYERS];
new g_fortune_timer[MAX_PLAYERS];
new g_fortune_index[MAX_PLAYERS];
new g_fortune_prev_index[MAX_PLAYERS];
new g_fortune_tick[MAX_PLAYERS];
new g_fortune_total_ticks[MAX_PLAYERS];
new g_fortune_target[MAX_PLAYERS];
new Float:g_fortune_model_rot[MAX_PLAYERS];

stock Fortune_IsVip(playerid)
{
    if(GetPlayerPremium(playerid) > 0) return 1;
    if(GetPlayerData(playerid, P_PREMIUM_DATE) > gettime()) return 1;
    return 0;
}

stock Fortune_WrapSlot(slotid)
{
    while(slotid < 0) slotid += FORTUNE_PRIZES;
    while(slotid >= FORTUNE_PRIZES) slotid -= FORTUNE_PRIZES;
    return slotid;
}

stock Fortune_Distance(slotid, active)
{
    new dist = slotid - active;
    if(dist < 0) dist = -dist;
    if(dist > (FORTUNE_PRIZES / 2)) dist = FORTUNE_PRIZES - dist;
    return dist;
}

stock Fortune_CreateBox(playerid, idx, Float:x, Float:y, Float:w, Float:h, const text[], color, box_color, selectable = 0)
{
    new td_text[96];
    format(td_text, sizeof td_text, "%s", text);

    g_fortune_td[playerid][idx] = CreatePlayerTextDraw(playerid, x, y, td_text);
    PlayerTextDrawLetterSize(playerid, g_fortune_td[playerid][idx], 0.230000, 1.080000);
    PlayerTextDrawTextSize(playerid, g_fortune_td[playerid][idx], x + w, h);
    PlayerTextDrawAlignment(playerid, g_fortune_td[playerid][idx], 2);
    PlayerTextDrawColor(playerid, g_fortune_td[playerid][idx], color);
    PlayerTextDrawUseBox(playerid, g_fortune_td[playerid][idx], 1);
    PlayerTextDrawBoxColor(playerid, g_fortune_td[playerid][idx], box_color);
    PlayerTextDrawSetShadow(playerid, g_fortune_td[playerid][idx], 0);
    PlayerTextDrawSetOutline(playerid, g_fortune_td[playerid][idx], 1);
    PlayerTextDrawBackgroundColor(playerid, g_fortune_td[playerid][idx], 0x000000FF);
    PlayerTextDrawFont(playerid, g_fortune_td[playerid][idx], 1);
    PlayerTextDrawSetProportional(playerid, g_fortune_td[playerid][idx], 1);
    PlayerTextDrawSetSelectable(playerid, g_fortune_td[playerid][idx], selectable);
    return 1;
}

stock Fortune_CreatePlain(playerid, idx, Float:x, Float:y, const text[], Float:letter_x, Float:letter_y, color, alignment = 2)
{
    new td_text[128];
    format(td_text, sizeof td_text, "%s", text);

    g_fortune_td[playerid][idx] = CreatePlayerTextDraw(playerid, x, y, td_text);
    PlayerTextDrawLetterSize(playerid, g_fortune_td[playerid][idx], letter_x, letter_y);
    PlayerTextDrawAlignment(playerid, g_fortune_td[playerid][idx], alignment);
    PlayerTextDrawColor(playerid, g_fortune_td[playerid][idx], color);
    PlayerTextDrawSetShadow(playerid, g_fortune_td[playerid][idx], 0);
    PlayerTextDrawSetOutline(playerid, g_fortune_td[playerid][idx], 1);
    PlayerTextDrawBackgroundColor(playerid, g_fortune_td[playerid][idx], 0x000000FF);
    PlayerTextDrawFont(playerid, g_fortune_td[playerid][idx], 1);
    PlayerTextDrawSetProportional(playerid, g_fortune_td[playerid][idx], 1);
    PlayerTextDrawSetSelectable(playerid, g_fortune_td[playerid][idx], 0);
    return 1;
}

stock Fortune_CreateTextDraws(playerid)
{
    if(g_fortune_created[playerid]) return 1;

    g_fortune_td[playerid][FORTUNE_TD_BG] = CreatePlayerTextDraw(playerid, 320.0, 75.0, "_");
    PlayerTextDrawLetterSize(playerid, g_fortune_td[playerid][FORTUNE_TD_BG], 0.0, 27.0);
    PlayerTextDrawTextSize(playerid, g_fortune_td[playerid][FORTUNE_TD_BG], 520.0, 0.0);
    PlayerTextDrawAlignment(playerid, g_fortune_td[playerid][FORTUNE_TD_BG], 2);
    PlayerTextDrawColor(playerid, g_fortune_td[playerid][FORTUNE_TD_BG], FORTUNE_COLOR_WHITE);
    PlayerTextDrawUseBox(playerid, g_fortune_td[playerid][FORTUNE_TD_BG], 1);
    PlayerTextDrawBoxColor(playerid, g_fortune_td[playerid][FORTUNE_TD_BG], FORTUNE_COLOR_BG);
    PlayerTextDrawSetShadow(playerid, g_fortune_td[playerid][FORTUNE_TD_BG], 0);
    PlayerTextDrawSetOutline(playerid, g_fortune_td[playerid][FORTUNE_TD_BG], 0);
    PlayerTextDrawBackgroundColor(playerid, g_fortune_td[playerid][FORTUNE_TD_BG], 0x000000FF);
    PlayerTextDrawFont(playerid, g_fortune_td[playerid][FORTUNE_TD_BG], 1);
    PlayerTextDrawSetProportional(playerid, g_fortune_td[playerid][FORTUNE_TD_BG], 1);
    PlayerTextDrawSetSelectable(playerid, g_fortune_td[playerid][FORTUNE_TD_BG], 0);

    Fortune_CreatePlain(playerid, FORTUNE_TD_TITLE, 320.0, 84.0, "КОЛЕСО ФОРТУНЫ", 0.390000, 1.650000, FORTUNE_COLOR_MAIN, 2);
    Fortune_CreatePlain(playerid, FORTUNE_TD_SUBTITLE, 320.0, 103.0, "GTA / CS:GO STYLE", 0.220000, 1.050000, FORTUNE_COLOR_GRAY, 2);
    Fortune_CreatePlain(playerid, FORTUNE_TD_ARROW, 320.0, 124.0, "V", 0.440000, 2.050000, FORTUNE_COLOR_MAIN, 2);

    g_fortune_td[playerid][FORTUNE_TD_MODEL] = CreatePlayerTextDraw(playerid, 267.0, 141.0, "_");
    PlayerTextDrawTextSize(playerid, g_fortune_td[playerid][FORTUNE_TD_MODEL], 106.0, 94.0);
    PlayerTextDrawAlignment(playerid, g_fortune_td[playerid][FORTUNE_TD_MODEL], 1);
    PlayerTextDrawColor(playerid, g_fortune_td[playerid][FORTUNE_TD_MODEL], FORTUNE_COLOR_WHITE);
    PlayerTextDrawBackgroundColor(playerid, g_fortune_td[playerid][FORTUNE_TD_MODEL], 0x00000000);
    PlayerTextDrawFont(playerid, g_fortune_td[playerid][FORTUNE_TD_MODEL], 5);
    PlayerTextDrawSetProportional(playerid, g_fortune_td[playerid][FORTUNE_TD_MODEL], 1);
    PlayerTextDrawSetSelectable(playerid, g_fortune_td[playerid][FORTUNE_TD_MODEL], 0);
    PlayerTextDrawSetPreviewModel(playerid, g_fortune_td[playerid][FORTUNE_TD_MODEL], FORTUNE_PREVIEW_MODEL_ID);
    PlayerTextDrawSetPreviewRot(playerid, g_fortune_td[playerid][FORTUNE_TD_MODEL], -15.0, 0.0, 0.0, 1.75);

    Fortune_CreateBox(playerid, FORTUNE_TD_CENTER, 320.0, 197.0, 92.0, 28.0, "ЖМИ~n~ПРОКРУТ", FORTUNE_COLOR_WHITE, 0x000000DD, 0);
    Fortune_CreateBox(playerid, FORTUNE_TD_SPIN, 266.0, 350.0, 106.0, 23.0, "ПРОКРУТ", FORTUNE_COLOR_WHITE, 0x2E8B57DD, 1);
    Fortune_CreateBox(playerid, FORTUNE_TD_CLOSE, 374.0, 350.0, 106.0, 23.0, "ЗАКРЫТЬ", FORTUNE_COLOR_WHITE, 0x8B0000DD, 1);
    Fortune_CreatePlain(playerid, FORTUNE_TD_HINT, 320.0, 322.0, "Цена: 50000 руб. | VIP: повышенный шанс джекпота", 0.215000, 1.020000, FORTUNE_COLOR_GRAY, 2);

    for(new i; i < FORTUNE_PRIZES; i++)
    {
        Fortune_CreateBox(playerid,
            FORTUNE_TD_PRIZE_START + i,
            g_fortune_pos_x[i],
            g_fortune_pos_y[i],
            98.0,
            20.0,
            g_fortune_prize[i][FORTUNE_PRIZE_NAME],
            FORTUNE_COLOR_WHITE,
            FORTUNE_COLOR_BOX,
            0
        );
    }

    g_fortune_created[playerid] = true;
    return 1;
}

stock Fortune_ShowTD(playerid, idx)
{
    PlayerTextDrawShow(playerid, g_fortune_td[playerid][idx]);
    return 1;
}

stock Fortune_StartCamera(playerid)
{
    if(!FORTUNE_USE_CAMERA) return 1;

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    new Float:sx = floatsin(-a, degrees);
    new Float:sy = floatcos(-a, degrees);

    InterpolateCameraPos(playerid,
        x - sx * 1.5, y - sy * 1.5, z + 1.2,
        x - sx * 4.0, y - sy * 4.0, z + 2.0,
        1200,
        CAMERA_MOVE
    );
    InterpolateCameraLookAt(playerid,
        x + sx * 1.0, y + sy * 1.0, z + 1.0,
        x, y, z + 1.0,
        1200,
        CAMERA_MOVE
    );
    g_fortune_camera[playerid] = true;
    return 1;
}

stock Fortune_StopCamera(playerid)
{
    if(g_fortune_camera[playerid])
    {
        SetCameraBehindPlayer(playerid);
        g_fortune_camera[playerid] = false;
    }
    return 1;
}

stock Fortune_Show(playerid)
{
    if(g_fortune_spinning[playerid]) return SendClientMessage(playerid, FORTUNE_COLOR_GRAY, "[Колесо] Дождитесь окончания текущего прокрута.");

    Fortune_CreateTextDraws(playerid);

    for(new i; i < FORTUNE_TD_COUNT; i++)
    {
        Fortune_ShowTD(playerid, i);
    }

    g_fortune_open[playerid] = true;
    g_fortune_index[playerid] = 0;
    g_fortune_prev_index[playerid] = 0;
    g_fortune_model_rot[playerid] = 0.0;

    if(Fortune_IsVip(playerid))
        PlayerTextDrawSetString(playerid, g_fortune_td[playerid][FORTUNE_TD_HINT], "Цена: 50000 руб. | VIP-рулетка активна: шанс джекпота выше");
    else
        PlayerTextDrawSetString(playerid, g_fortune_td[playerid][FORTUNE_TD_HINT], "Цена: 50000 руб. | VIP получает повышенный шанс джекпота");

    Fortune_RedrawAllSlots(playerid);
    Fortune_StartCamera(playerid);
    SelectTextDraw(playerid, FORTUNE_COLOR_MAIN);
    return 1;
}

stock Fortune_Hide(playerid)
{
    if(!g_fortune_created[playerid]) return 1;

    for(new i; i < FORTUNE_TD_COUNT; i++)
    {
        PlayerTextDrawHide(playerid, g_fortune_td[playerid][i]);
    }

    g_fortune_open[playerid] = false;
    Fortune_StopCamera(playerid);
    CancelSelectTextDraw(playerid);
    return 1;
}

stock Fortune_Destroy(playerid)
{
    if(g_fortune_timer[playerid])
    {
        KillTimer(g_fortune_timer[playerid]);
        g_fortune_timer[playerid] = 0;
    }

    if(g_fortune_created[playerid])
    {
        for(new i; i < FORTUNE_TD_COUNT; i++)
        {
            PlayerTextDrawDestroy(playerid, g_fortune_td[playerid][i]);
        }
    }

    g_fortune_created[playerid] = false;
    g_fortune_open[playerid] = false;
    g_fortune_spinning[playerid] = false;
    g_fortune_camera[playerid] = false;
    return 1;
}

stock Fortune_RedrawSlot(playerid, slotid)
{
    slotid = Fortune_WrapSlot(slotid);

    new td = FORTUNE_TD_PRIZE_START + slotid;
    new dist = Fortune_Distance(slotid, g_fortune_index[playerid]);

    new color = FORTUNE_COLOR_DARK_GRAY;
    new box = FORTUNE_COLOR_BOX;
    new Float:lx = 0.205000;
    new Float:ly = 0.960000;

    if(slotid == 8 && Fortune_IsVip(playerid))
    {
        color = FORTUNE_COLOR_VIP;
        box = 0x24132DDD;
    }

    if(dist == 0)
    {
        color = FORTUNE_COLOR_WHITE;
        box = FORTUNE_COLOR_HILITE;
        lx = 0.255000;
        ly = 1.180000;
    }
    else if(dist == 1)
    {
        if(slotid != 8 || !Fortune_IsVip(playerid)) color = FORTUNE_COLOR_GRAY;
        box = FORTUNE_COLOR_NEAR;
        lx = 0.225000;
        ly = 1.030000;
    }

    PlayerTextDrawColor(playerid, g_fortune_td[playerid][td], color);
    PlayerTextDrawBoxColor(playerid, g_fortune_td[playerid][td], box);
    PlayerTextDrawLetterSize(playerid, g_fortune_td[playerid][td], lx, ly);
    PlayerTextDrawHide(playerid, g_fortune_td[playerid][td]);
    PlayerTextDrawShow(playerid, g_fortune_td[playerid][td]);
    return 1;
}

stock Fortune_RedrawAllSlots(playerid)
{
    for(new i; i < FORTUNE_PRIZES; i++) Fortune_RedrawSlot(playerid, i);
    return 1;
}

stock Fortune_RedrawChangedSlots(playerid, old_slot, new_slot)
{
    Fortune_RedrawSlot(playerid, old_slot - 1);
    Fortune_RedrawSlot(playerid, old_slot);
    Fortune_RedrawSlot(playerid, old_slot + 1);
    Fortune_RedrawSlot(playerid, new_slot - 1);
    Fortune_RedrawSlot(playerid, new_slot);
    Fortune_RedrawSlot(playerid, new_slot + 1);
    return 1;
}

stock Fortune_SelectPrize(playerid)
{
    new is_vip = Fortune_IsVip(playerid);
    new total_chance;

    for(new i; i < FORTUNE_PRIZES; i++)
    {
        if(is_vip) total_chance += g_fortune_prize[i][FORTUNE_PRIZE_VIP_CHANCE];
        else total_chance += g_fortune_prize[i][FORTUNE_PRIZE_CHANCE];
    }

    new random_value = random(total_chance);
    new current_sum;

    for(new i; i < FORTUNE_PRIZES; i++)
    {
        if(is_vip) current_sum += g_fortune_prize[i][FORTUNE_PRIZE_VIP_CHANCE];
        else current_sum += g_fortune_prize[i][FORTUNE_PRIZE_CHANCE];

        if(random_value < current_sum) return i;
    }

    return 0;
}

stock Fortune_GetNextDelay(playerid)
{
    new left = g_fortune_total_ticks[playerid] - g_fortune_tick[playerid];

    if(left > 30) return 58;
    if(left > 22) return 72 + (30 - left) * 5;
    if(left > 14) return 112 + (22 - left) * 10;
    if(left > 7)  return 192 + (14 - left) * 22;

    new delay = 346 + (7 - left) * 28;
    if(delay > 520) delay = 520;
    return delay;
}

stock Fortune_ClickSound(playerid, delay)
{
    if(!FORTUNE_USE_SOUNDS) return 1;

    if(delay >= 190) PlayerPlaySound(playerid, FORTUNE_SOUND_CLICK_SLOW, 0.0, 0.0, 0.0);
    else PlayerPlaySound(playerid, FORTUNE_SOUND_CLICK_FAST, 0.0, 0.0, 0.0);
    return 1;
}

stock Fortune_UpdateModel(playerid)
{
    g_fortune_model_rot[playerid] += 34.0;
    if(g_fortune_model_rot[playerid] >= 360.0) g_fortune_model_rot[playerid] -= 360.0;

    PlayerTextDrawSetPreviewRot(playerid, g_fortune_td[playerid][FORTUNE_TD_MODEL], -15.0, 0.0, g_fortune_model_rot[playerid], 1.75);
    return 1;
}

stock Fortune_GiveReward(playerid, prizeid)
{
    new reward_text[160];

    switch(g_fortune_prize[prizeid][FORTUNE_PRIZE_TYPE])
    {
        case FORTUNE_REWARD_MONEY:
        {
            GivePlayerMoneyEx(playerid, g_fortune_prize[prizeid][FORTUNE_PRIZE_VALUE], "Колесо фортуны", true, true);
        }
        case FORTUNE_REWARD_EXP:
        {
            AddPlayerData(playerid, P_EXP, +, g_fortune_prize[prizeid][FORTUNE_PRIZE_VALUE]);
            UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
        }
        case FORTUNE_REWARD_DONATE:
        {
            GivePlayerDonate(playerid, g_fortune_prize[prizeid][FORTUNE_PRIZE_VALUE], "Колесо фортуны", true);
        }
        case FORTUNE_REWARD_CASE:
        {
            AddPlayerData(playerid, P_DONATE_CASE, +, g_fortune_prize[prizeid][FORTUNE_PRIZE_VALUE]);
            UpdatePlayerDatabaseInt(playerid, "case", GetPlayerData(playerid, P_DONATE_CASE));
        }
        case FORTUNE_REWARD_VIP:
        {
            if(!GetPlayerPremium(playerid)) SetPlayerData(playerid, P_PREMIUM, 1);

            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + g_fortune_prize[prizeid][FORTUNE_PRIZE_VALUE] * 86400);
            else
                AddPlayerData(playerid, P_PREMIUM_DATE, +, g_fortune_prize[prizeid][FORTUNE_PRIZE_VALUE] * 86400);

            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
        }
    }

#if FORTUNE_USE_SOUNDS
    PlayerPlaySound(playerid, FORTUNE_SOUND_WIN, 0.0, 0.0, 0.0);
#endif

    format(reward_text, sizeof reward_text, "[Колесо] Поздравляем! Ваш приз: %s.", g_fortune_prize[prizeid][FORTUNE_PRIZE_NAME]);
    SendClientMessage(playerid, FORTUNE_COLOR_GREEN, reward_text);

    format(reward_text, sizeof reward_text, "Выпало: %s~n~Визуал и приз совпали. Можно крутить ещё раз.", g_fortune_prize[prizeid][FORTUNE_PRIZE_NAME]);
    PlayerTextDrawSetString(playerid, g_fortune_td[playerid][FORTUNE_TD_HINT], reward_text);
    PlayerTextDrawSetString(playerid, g_fortune_td[playerid][FORTUNE_TD_CENTER], "ПРИЗ~n~ВЫДАН");
    return 1;
}

stock Fortune_StartSpin(playerid)
{
    if(!g_fortune_open[playerid]) return 1;
    if(g_fortune_spinning[playerid]) return SendClientMessage(playerid, FORTUNE_COLOR_GRAY, "[Колесо] Прокрут уже идёт.");

    if(GetPlayerMoneyEx(playerid) < FORTUNE_SPIN_PRICE)
    {
        new msg[128];
        format(msg, sizeof msg, "[Колесо] Для прокрута нужно %d руб.", FORTUNE_SPIN_PRICE);
        return SendClientMessage(playerid, FORTUNE_COLOR_RED, msg);
    }

    GivePlayerMoneyEx(playerid, -FORTUNE_SPIN_PRICE, "Прокрут колеса фортуны", true, true);

    g_fortune_spinning[playerid] = true;
    g_fortune_target[playerid] = Fortune_SelectPrize(playerid);
    g_fortune_tick[playerid] = 0;
    g_fortune_prev_index[playerid] = g_fortune_index[playerid];

    new rotations = FORTUNE_MIN_ROTATIONS + random(FORTUNE_MAX_EXTRA_ROTATIONS + 1);
    new distance = g_fortune_target[playerid] - g_fortune_index[playerid];
    if(distance < 0) distance += FORTUNE_PRIZES;

    g_fortune_total_ticks[playerid] = rotations * FORTUNE_PRIZES + distance;
    if(g_fortune_total_ticks[playerid] < 36) g_fortune_total_ticks[playerid] += FORTUNE_PRIZES;

    PlayerTextDrawSetString(playerid, g_fortune_td[playerid][FORTUNE_TD_CENTER], "КРУТИМ~n~КОЛЕСО");
    PlayerTextDrawSetString(playerid, g_fortune_td[playerid][FORTUNE_TD_HINT], "Колесо крутится...~n~Приз уже выбран, визуал докручивается именно до него.");

    if(g_fortune_timer[playerid]) KillTimer(g_fortune_timer[playerid]);
    g_fortune_timer[playerid] = SetTimerEx("Fortune_SpinTick", 58, false, "i", playerid);
    return 1;
}

forward Fortune_SpinTick(playerid);
public Fortune_SpinTick(playerid)
{
    if(!IsPlayerConnected(playerid) || !g_fortune_spinning[playerid]) return 1;

    new old_slot = g_fortune_index[playerid];
    g_fortune_index[playerid] = Fortune_WrapSlot(g_fortune_index[playerid] + 1);
    g_fortune_tick[playerid]++;

    Fortune_RedrawChangedSlots(playerid, old_slot, g_fortune_index[playerid]);
    Fortune_UpdateModel(playerid);

    new delay = Fortune_GetNextDelay(playerid);
    Fortune_ClickSound(playerid, delay);

    if(g_fortune_tick[playerid] >= g_fortune_total_ticks[playerid])
    {
        g_fortune_timer[playerid] = 0;
        g_fortune_spinning[playerid] = false;
        g_fortune_index[playerid] = g_fortune_target[playerid];
        Fortune_RedrawAllSlots(playerid);
        Fortune_GiveReward(playerid, g_fortune_target[playerid]);
        return 1;
    }

    g_fortune_timer[playerid] = SetTimerEx("Fortune_SpinTick", delay, false, "i", playerid);
    return 1;
}

stock Fortune_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(!g_fortune_open[playerid]) return 0;

    if(playertextid == g_fortune_td[playerid][FORTUNE_TD_SPIN])
    {
        Fortune_StartSpin(playerid);
        return 1;
    }

    if(playertextid == g_fortune_td[playerid][FORTUNE_TD_CLOSE])
    {
        if(g_fortune_spinning[playerid])
        {
            SendClientMessage(playerid, FORTUNE_COLOR_GRAY, "[Колесо] Нельзя закрыть меню во время прокрута.");
            return 1;
        }
        Fortune_Hide(playerid);
        return 1;
    }

    return 0;
}

stock Fortune_Cleanup(playerid)
{
    return Fortune_Destroy(playerid);
}

CMD:wheel(playerid, params[])
{
    #pragma unused params
    return Fortune_Show(playerid);
}

CMD:fortune(playerid, params[])
{
    #pragma unused params
    return Fortune_Show(playerid);
}

CMD:fortuna(playerid, params[])
{
    #pragma unused params
    return Fortune_Show(playerid);
}

CMD:koleso(playerid, params[])
{
    #pragma unused params
    return Fortune_Show(playerid);
}
