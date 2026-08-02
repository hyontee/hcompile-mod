
#if defined _BR_BP_INCLUDED
    #endinput
#endif
#define _BR_BP_INCLUDED

#define BRBP_DLG_MAIN     56910
#define BRBP_DLG_TIERS    56911
#define BRBP_DLG_TASKS    56912

#define BRBP_MAX_TIERS    (50)
#define BRBP_XP_PER_TIER  (1000)

#define BRBP_RUBLE "\xE2\x82\xBD"

#define BRBP_COLOR_INFO 0x66FF66FF
#define BRBP_COLOR_ERR  0xFF6666FF

#if !defined BRBP_HandlePlayerEnterCheckpoin
    #define BRBP_HandlePlayerEnterCheckpoin BRBP_HandlePlayerEnterCheckpoint
#endif

enum BRBP_E_REWARD {
    r_type,
    r_v1,
    r_v2,
    r_title[32]
};

enum BRBP_E_TASK {
    t_type,
    t_target,
    t_xp,
    t_rub,
    t_title[64]
};

static const BRBP_Rewards[BRBP_MAX_TIERS+1][BRBP_E_REWARD] =
{
    {0,0,0,""},
    {1,5900,0,"Рубли"},
    {2,60,0,"Black Coins"},
    {5,1,0,"Winter Case Key"},
    {2,70,0,"Black Coins"},
    {3,4,0,"Winter Camo"},
    {5,1,0,"Winter Case Key"},
    {1,11300,0,"Рубли"},
    {2,90,0,"Black Coins"},
    {5,1,0,"Winter Case Key"},
    {4,401,0,"VAZ 2101"},
    {1,14900,0,"Рубли"},
    {5,1,0,"Winter Case Key"},
    {1,16700,0,"Рубли"},
    {2,120,0,"Black Coins"},
    {3,7,0,"Army Camo"},
    {2,130,0,"Black Coins"},
    {1,20300,0,"Рубли"},
    {5,1,0,"Winter Case Key"},
    {1,22100,0,"Рубли"},
    {4,404,0,"VAZ 2107"},
    {5,1,0,"Winter Case Key"},
    {2,160,0,"Black Coins"},
    {1,25700,0,"Рубли"},
    {5,1,0,"Winter Case Key"},
    {3,11,0,"Winter Street"},
    {2,180,0,"Black Coins"},
    {5,1,0,"Winter Case Key"},
    {2,190,0,"Black Coins"},
    {1,31100,0,"Рубли"},
    {4,405,0,"Audi RS6"},
    {1,32900,0,"Рубли"},
    {2,210,0,"Black Coins"},
    {5,1,0,"Winter Case Key"},
    {2,220,0,"Black Coins"},
    {3,5,0,"Warm Hoodie"},
    {5,1,0,"Winter Case Key"},
    {1,38300,0,"Рубли"},
    {2,240,0,"Black Coins"},
    {5,1,0,"Winter Case Key"},
    {4,411,0,"Aston Martin DB11"},
    {1,41900,0,"Рубли"},
    {5,1,0,"Winter Case Key"},
    {1,43700,0,"Рубли"},
    {2,270,0,"Black Coins"},
    {3,10,0,"New Year Bunny"},
    {2,280,0,"Black Coins"},
    {1,47300,0,"Рубли"},
    {5,1,0,"Winter Case Key"},
    {1,49100,0,"Рубли"},
    {4,2569,0,"Bugatti La Noire"}
};

static const BRBP_DailyTpl[][BRBP_E_TASK] =
{
    {1,1200,300,3000,"Проведи в игре 20 минут"},
    {2,5000,300,3000,"Проедь 5 км за рулём"},
    {3,15000,300,3000,"Заработай 15 000"}
};

static const BRBP_WeeklyTpl[][BRBP_E_TASK] =
{
    {1,10800,900,20000,"Проведи в игре 3 часа"},
    {2,40000,900,20000,"Проедь 40 км за рулём"},
    {3,120000,900,20000,"Заработай 120 000"}
};

new brbp_xp[MAX_PLAYERS];
new brbp_tier[MAX_PLAYERS];
new brbp_claimed[MAX_PLAYERS][BRBP_MAX_TIERS+1];

new brbp_task_prog_d[MAX_PLAYERS][sizeof(BRBP_DailyTpl)];
new brbp_task_done_d[MAX_PLAYERS][sizeof(BRBP_DailyTpl)];
new brbp_task_prog_w[MAX_PLAYERS][sizeof(BRBP_WeeklyTpl)];
new brbp_task_done_w[MAX_PLAYERS][sizeof(BRBP_WeeklyTpl)];

new brbp_online_ms_acc[MAX_PLAYERS];
new brbp_last_tick[MAX_PLAYERS];

new Float:brbp_last_x[MAX_PLAYERS], Float:brbp_last_y[MAX_PLAYERS];
new bool:brbp_last_pos_ok[MAX_PLAYERS];

new brbp_blackcoins[MAX_PLAYERS];
new brbp_reward_page[MAX_PLAYERS];

new bool:brbp_inited;

stock BRBP_InitOnce()
{
    if (brbp_inited) return 1;
    brbp_inited = true;
    print("[GENERAL] Зимний Battle Pass загружен");
    return 1;
}

stock BRBP_RecalcTier(playerid)
{
    new t = brbp_xp[playerid] / BRBP_XP_PER_TIER;
    if (t < 0) t = 0;
    if (t > BRBP_MAX_TIERS) t = BRBP_MAX_TIERS;
    brbp_tier[playerid] = t;
    return 1;
}

stock BRBP_AddXP(playerid, amount)
{
    if (amount <= 0) return 1;
    brbp_xp[playerid] += amount;
    if (brbp_xp[playerid] < 0) brbp_xp[playerid] = 0;
    new maxxp = BRBP_MAX_TIERS * BRBP_XP_PER_TIER;
    if (brbp_xp[playerid] > maxxp) brbp_xp[playerid] = maxxp;
    BRBP_RecalcTier(playerid);
    return 1;
}

stock BRBP_AddRublesProgress(playerid, amount)
{
    if (amount <= 0) return 1;
    for (new i=0; i<sizeof(BRBP_DailyTpl); i++)
        if (BRBP_DailyTpl[i][t_type] == 3 && !brbp_task_done_d[playerid][i])
            brbp_task_prog_d[playerid][i] += amount;

    for (new j=0; j<sizeof(BRBP_WeeklyTpl); j++)
        if (BRBP_WeeklyTpl[j][t_type] == 3 && !brbp_task_done_w[playerid][j])
            brbp_task_prog_w[playerid][j] += amount;
    return 1;
}
stock BRBP_AddMoneyProgress(playerid, amount) { return BRBP_AddRublesProgress(playerid, amount); }

stock BRBP_AddBlackCoins(playerid, amount)
{
    if (amount <= 0) return 1;
    brbp_blackcoins[playerid] += amount;
    if (brbp_blackcoins[playerid] < 0) brbp_blackcoins[playerid] = 0;
    return 1;
}

stock BRBP_CompleteTask(playerid, bool:isWeekly, idx)
{
    if (!isWeekly)
    {
        if (brbp_task_done_d[playerid][idx]) return 1;
        brbp_task_done_d[playerid][idx] = 1;
        BRBP_AddXP(playerid, BRBP_DailyTpl[idx][t_xp]);
        GivePlayerMoney(playerid, BRBP_DailyTpl[idx][t_rub]);
        return 1;
    }
    if (brbp_task_done_w[playerid][idx]) return 1;
    brbp_task_done_w[playerid][idx] = 1;
    BRBP_AddXP(playerid, BRBP_WeeklyTpl[idx][t_xp]);
    GivePlayerMoney(playerid, BRBP_WeeklyTpl[idx][t_rub]);
    return 1;
}

stock BRBP_CheckTasks(playerid)
{
    for (new i=0; i<sizeof(BRBP_DailyTpl); i++)
    {
        if (brbp_task_done_d[playerid][i]) continue;
        if (brbp_task_prog_d[playerid][i] >= BRBP_DailyTpl[i][t_target]) BRBP_CompleteTask(playerid, false, i);
    }
    for (new j=0; j<sizeof(BRBP_WeeklyTpl); j++)
    {
        if (brbp_task_done_w[playerid][j]) continue;
        if (brbp_task_prog_w[playerid][j] >= BRBP_WeeklyTpl[j][t_target]) BRBP_CompleteTask(playerid, true, j);
    }
    return 1;
}

stock BRBP_RewardText(tier, outStr[], outLen)
{
    new rt = BRBP_Rewards[tier][r_type];
    if (rt == 1) return format(outStr, outLen, "%s%d", BRBP_RUBLE, BRBP_Rewards[tier][r_v1]);
    if (rt == 2) return format(outStr, outLen, "Black Coins x%d", BRBP_Rewards[tier][r_v1]);
    if (rt == 3) return format(outStr, outLen, "Скин: %s (ID %d)", BRBP_Rewards[tier][r_title], BRBP_Rewards[tier][r_v1]);
    if (rt == 4) return format(outStr, outLen, "Авто: %s (ID %d)", BRBP_Rewards[tier][r_title], BRBP_Rewards[tier][r_v1]);
    if (rt == 5) return format(outStr, outLen, "Ключ Winter Case x%d", BRBP_Rewards[tier][r_v1]);
    return format(outStr, outLen, "-");
}

stock BRBP_GiveCar_Temp(playerid, modelid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new Float:a;
    GetPlayerFacingAngle(playerid, a);
    new veh = CreateVehicle(modelid, x+2.0, y, z, a, -1, -1, 600);
    if (veh != INVALID_VEHICLE_ID) PutPlayerInVehicle(playerid, veh, 0);
    return 1;
}

stock BRBP_ApplyReward(playerid, tier)
{
    new rt = BRBP_Rewards[tier][r_type];
    if (rt == 1) GivePlayerMoney(playerid, BRBP_Rewards[tier][r_v1]);
    else if (rt == 2) BRBP_AddBlackCoins(playerid, BRBP_Rewards[tier][r_v1]);
    else if (rt == 3) SetPlayerSkin(playerid, BRBP_Rewards[tier][r_v1]);
    else if (rt == 4) BRBP_GiveCar_Temp(playerid, BRBP_Rewards[tier][r_v1]);

    new msg[160], rtxt[96];
    BRBP_RewardText(tier, rtxt, sizeof rtxt);
    format(msg, sizeof msg, "Награда получена: %s", rtxt);
    SendClientMessage(playerid, BRBP_COLOR_INFO, msg);
    return 1;
}

stock BRBP_ShowMain(playerid)
{
    BRBP_RecalcTier(playerid);
    new prog = brbp_xp[playerid] % BRBP_XP_PER_TIER;
    new body[256];
    format(body, sizeof body, "Уровень: %d/%d\nОпыт: %d/%d\nBlack Coins: %d\n", brbp_tier[playerid], BRBP_MAX_TIERS, prog, BRBP_XP_PER_TIER, brbp_blackcoins[playerid]);
    ShowPlayerDialog(playerid, BRBP_DLG_MAIN, DIALOG_STYLE_LIST, "Зимний Black Pass", "Награды\nЗадания", "ОК", "Закрыть");
    return 1;
}

stock BRBP_ShowTiers(playerid)
{
    new perpage = 15;
    new maxpage = (BRBP_MAX_TIERS + perpage - 1) / perpage;
    if (brbp_reward_page[playerid] < 0) brbp_reward_page[playerid] = 0;
    if (brbp_reward_page[playerid] >= maxpage) brbp_reward_page[playerid] = maxpage - 1;

    new start = brbp_reward_page[playerid] * perpage + 1;
    new end = start + perpage - 1;
    if (end > BRBP_MAX_TIERS) end = BRBP_MAX_TIERS;

    new brbp_list[4096]; brbp_list[0]=0;
    new brbp_line[160], brbp_rtxt[96];

    format(brbp_line, sizeof brbp_line, "Стр. %d/%d (ур. %d-%d)\n", brbp_reward_page[playerid]+1, maxpage, start, end);
    strcat(brbp_list, brbp_line);

    for (new t=start; t<=end; t++)
    {
        BRBP_RewardText(t, brbp_rtxt, sizeof brbp_rtxt);
        if (brbp_claimed[playerid][t]) format(brbp_line, sizeof brbp_line, "%02d. Получено (%s)\n", t, brbp_rtxt);
        else if (t <= brbp_tier[playerid]) format(brbp_line, sizeof brbp_line, "%02d. Доступно (%s)\n", t, brbp_rtxt);
        else format(brbp_line, sizeof brbp_line, "%02d. Закрыто (%s)\n", t, brbp_rtxt);
        strcat(brbp_list, brbp_line);
    }

    strcat(brbp_list, "<<< Предыдущая страница\n>>> Следующая страница\n");
    ShowPlayerDialog(playerid, BRBP_DLG_TIERS, DIALOG_STYLE_LIST, "Награды", brbp_list, "ОК", "Назад");
    return 1;
}

stock BRBP_ShowTasks(playerid)
{
    new brbp_list2[3000]; brbp_list2[0]=0;
    new brbp_line2[140];

    strcat(brbp_list2, "Ежедневные\n");
    for (new i=0; i<sizeof(BRBP_DailyTpl); i++)
    {
        format(brbp_line2, sizeof brbp_line2, "  %d) %s [%d/%d]\n", i+1, BRBP_DailyTpl[i][t_title], brbp_task_prog_d[playerid][i], BRBP_DailyTpl[i][t_target]);
        strcat(brbp_list2, brbp_line2);
    }
    strcat(brbp_list2, "Еженедельные\n");
    for (new j=0; j<sizeof(BRBP_WeeklyTpl); j++)
    {
        format(brbp_line2, sizeof brbp_line2, "  %d) %s [%d/%d]\n", j+1, BRBP_WeeklyTpl[j][t_title], brbp_task_prog_w[playerid][j], BRBP_WeeklyTpl[j][t_target]);
        strcat(brbp_list2, brbp_line2);
    }
    ShowPlayerDialog(playerid, BRBP_DLG_TASKS, DIALOG_STYLE_LIST, "Задания", brbp_list2, "ОК", "Назад");
    return 1;
}

CMD:bp(playerid, params[])
{
    #pragma unused params
    BRBP_InitOnce();
    BRBP_ShowMain(playerid);
    return 1;
}

stock BRBP_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext
    if (dialogid == BRBP_DLG_MAIN)
    {
        if (!response) return 1;
        if (listitem == 0) return BRBP_ShowTiers(playerid);
        if (listitem == 1) return BRBP_ShowTasks(playerid);
        return 1;
    }
    if (dialogid == BRBP_DLG_TIERS)
    {
        if (!response) return BRBP_ShowMain(playerid);

        new perpage = 15;
        new maxpage = (BRBP_MAX_TIERS + perpage - 1) / perpage;

        new start = brbp_reward_page[playerid] * perpage + 1;
        new end = start + perpage - 1;
        if (end > BRBP_MAX_TIERS) end = BRBP_MAX_TIERS;

        new page_items = (end - start + 1);
        new idx_prev = 1 + page_items;
        new idx_next = 2 + page_items;

        if (listitem == idx_prev)
        {
            brbp_reward_page[playerid]--;
            if (brbp_reward_page[playerid] < 0) brbp_reward_page[playerid] = 0;
            return BRBP_ShowTiers(playerid);
        }
        if (listitem == idx_next)
        {
            brbp_reward_page[playerid]++;
            if (brbp_reward_page[playerid] >= maxpage) brbp_reward_page[playerid] = maxpage - 1;
            return BRBP_ShowTiers(playerid);
        }
        if (listitem == 0) return BRBP_ShowTiers(playerid);

        new tier = start + (listitem - 1);
        if (tier < 1 || tier > BRBP_MAX_TIERS) return 1;
        if (tier > brbp_tier[playerid]) return SendClientMessage(playerid, BRBP_COLOR_ERR, "Этот уровень ещё закрыт."), 1;
        if (brbp_claimed[playerid][tier]) return SendClientMessage(playerid, BRBP_COLOR_ERR, "Награда уже получена."), 1;

        brbp_claimed[playerid][tier] = 1;
        BRBP_ApplyReward(playerid, tier);
        return BRBP_ShowTiers(playerid);
    }
    if (dialogid == BRBP_DLG_TASKS)
    {
        if (!response) return BRBP_ShowMain(playerid);
        return 1;
    }
    return 0;
}

stock BRBP_HandlePlayerConnect(playerid)
{
    BRBP_InitOnce();
    brbp_xp[playerid] = 0;
    brbp_tier[playerid] = 0;
    brbp_blackcoins[playerid] = 0;
    brbp_reward_page[playerid] = 0;

    for (new t=1; t<=BRBP_MAX_TIERS; t++) brbp_claimed[playerid][t] = 0;

    for (new i=0; i<sizeof(BRBP_DailyTpl); i++) { brbp_task_prog_d[playerid][i]=0; brbp_task_done_d[playerid][i]=0; }
    for (new j=0; j<sizeof(BRBP_WeeklyTpl); j++) { brbp_task_prog_w[playerid][j]=0; brbp_task_done_w[playerid][j]=0; }

    brbp_online_ms_acc[playerid] = 0;
    brbp_last_tick[playerid] = GetTickCount();
    brbp_last_pos_ok[playerid] = false;
    return 1;
}

stock BRBP_HandlePlayerDisconnect(playerid, reason)
{
    #pragma unused reason
    brbp_last_pos_ok[playerid] = false;
    return 1;
}

stock BRBP_HandlePlayerStateChange(playerid, newstate, oldstate)
{
    #pragma unused newstate, oldstate
    brbp_last_pos_ok[playerid] = false;
    return 1;
}

stock BRBP_HandlePlayerUpdate(playerid)
{
    BRBP_InitOnce();

    new now = GetTickCount();
    new dt = now - brbp_last_tick[playerid];
    if (dt < 0) dt = 0;
    if (dt > 5000) dt = 5000;
    brbp_last_tick[playerid] = now;

    brbp_online_ms_acc[playerid] += dt;
    while (brbp_online_ms_acc[playerid] >= 1000)
    {
        brbp_online_ms_acc[playerid] -= 1000;

        for (new i=0; i<sizeof(BRBP_DailyTpl); i++)
            if (BRBP_DailyTpl[i][t_type] == 1 && !brbp_task_done_d[playerid][i])
                brbp_task_prog_d[playerid][i] += 1;

        for (new j=0; j<sizeof(BRBP_WeeklyTpl); j++)
            if (BRBP_WeeklyTpl[j][t_type] == 1 && !brbp_task_done_w[playerid][j])
                brbp_task_prog_w[playerid][j] += 1;
    }

    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
    {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        if (brbp_last_pos_ok[playerid])
        {
            new Float:dx = x - brbp_last_x[playerid];
            new Float:dy = y - brbp_last_y[playerid];
            new Float:dist = floatsqroot(dx*dx + dy*dy);
            new meters = floatround(dist);
            if (meters > 0 && meters < 250)
            {
                for (new i2=0; i2<sizeof(BRBP_DailyTpl); i2++)
                    if (BRBP_DailyTpl[i2][t_type] == 2 && !brbp_task_done_d[playerid][i2])
                        brbp_task_prog_d[playerid][i2] += meters;

                for (new j2=0; j2<sizeof(BRBP_WeeklyTpl); j2++)
                    if (BRBP_WeeklyTpl[j2][t_type] == 2 && !brbp_task_done_w[playerid][j2])
                        brbp_task_prog_w[playerid][j2] += meters;
            }
        }
        brbp_last_x[playerid]=x; brbp_last_y[playerid]=y;
        brbp_last_pos_ok[playerid]=true;
    }
    else brbp_last_pos_ok[playerid]=false;

    BRBP_CheckTasks(playerid);
    return 1;
}

stock BRBP_HandlePlayerEnterCheckpoint(playerid)
{
    #pragma unused playerid
    return 1;
}