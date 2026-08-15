#if defined _BR_CASES_GUI_INC_
    #endinput
#endif
#define _BR_CASES_GUI_INC_

#define CASE_REWARD_UI_PVAR            ("case_reward_ui")
#define CASE_OPEN_RESULT_TIMER_PVAR    ("case_open_tid")
#define CASE_SPRAY_REPLY_TIMER_PVAR    ("case_spray_tid")
#define CASE_PENDING_PR_COUNT_PVAR     ("case_pr_cnt")
#define CASE_PENDING_OPEN_OK_PVAR      ("case_open_ok")
#define CASE_SPRAY_REWARD_SCR_PVAR     ("case_spray_rscr")
#define CASE_SPRAY_SPECIAL_PVAR        ("case_spray_spec")
#define CASE_SPRAY_BT2_COUNT_PVAR      ("case_spray_bt2n")

#define CASES_OPEN_ANIM_MS_ONE         (520)
#define CASES_OPEN_ANIM_MS_TEN         (1000)
#define CASES_SPRAY_REPLY_DELAY_MS     (240)
#define CASES_DEBUG_PACKET_LOG         (0)

forward CasesDeliverOpenResultTimer(playerid);
forward CasesDeliverSprayResponseTimer(playerid);

// Все исходящие GUI 73 — OnPacketIncomingStr + плоский JSON (cc, pr).

stock Cases_MarkRewardScreenActive(playerid)
{
    SetPVarInt(playerid, CASE_REWARD_UI_PVAR, 1);
    return 1;
}

stock Cases_ClearRewardScreenFlag(playerid)
{
    DeletePVar(playerid, CASE_REWARD_UI_PVAR);
    return 1;
}

stock Cases_BuildIntListJson(const ids[], count, dest[], dest_size)
{
    dest[0] = '\0';
    if(count <= 0) return 0;

    format(dest, dest_size, "%d", ids[0]);
    for(new i = 1; i < count; i++)
    {
        new piece[16];
        format(piece, sizeof piece, ",%d", ids[i]);
        strcat(dest, piece, dest_size);
    }
    return 1;
}

stock Cases_BuildCcJsonString(playerid, dest[], dest_size)
{
    format(dest, dest_size,
        "[{\"id\":1,\"cot\":%d,\"du\":0},{\"id\":2,\"cot\":%d,\"du\":0},{\"id\":3,\"cot\":%d,\"du\":0},{\"id\":4,\"cot\":%d,\"du\":0},{\"id\":5,\"cot\":%d,\"du\":0}]",
        GetPlayerCaseCountByType(playerid, 1),
        GetPlayerCaseCountByType(playerid, 2),
        GetPlayerCaseCountByType(playerid, 3),
        GetPlayerCaseCountByType(playerid, 4),
        GetPlayerCaseCountByType(playerid, 5)
    );
    return 1;
}

stock Cases_BuildPrJsonString(open_count, const reward_ui_ids[], dest[], dest_size)
{
    dest[0] = '\0';
    if(open_count <= 0) return 0;

    format(dest, dest_size, "%d", reward_ui_ids[0]);
    for(new i = 1; i < open_count; i++)
    {
        new piece[16];
        format(piece, sizeof piece, ",%d", reward_ui_ids[i]);
        strcat(dest, piece, dest_size);
    }
    return 1;
}

stock Cases_LogOutgoingPacket(playerid, const tag[], const json_str[])
{
    #if CASES_DEBUG_PACKET_LOG
        printf("[Cases] %s %s[%d] cot5=%d json=%.420s",
            tag, Player[playerid][pName], playerid,
            GetPlayerCaseCountByType(playerid, 5), json_str);
    #else
        #pragma unused json_str
        printf("[Cases] %s %s[%d]", tag, Player[playerid][pName], playerid);
    #endif
    return 1;
}

stock Cases_CancelOpenResultTimer(playerid)
{
    new tid = GetPVarInt(playerid, CASE_OPEN_RESULT_TIMER_PVAR);
    if(tid > 0)
    {
        KillTimer(tid);
        DeletePVar(playerid, CASE_OPEN_RESULT_TIMER_PVAR);
    }
    DeletePVar(playerid, CASE_PENDING_PR_COUNT_PVAR);
    DeletePVar(playerid, CASE_PENDING_OPEN_OK_PVAR);
    for(new i = 0; i < 10; i++)
    {
        new key[20];
        format(key, sizeof key, "case_pr_%d", i);
        DeletePVar(playerid, key);
    }
    return 1;
}

stock Cases_CancelSprayReplyTimer(playerid)
{
    new tid = GetPVarInt(playerid, CASE_SPRAY_REPLY_TIMER_PVAR);
    if(tid > 0)
    {
        KillTimer(tid);
        DeletePVar(playerid, CASE_SPRAY_REPLY_TIMER_PVAR);
    }
    DeletePVar(playerid, CASE_SPRAY_REWARD_SCR_PVAR);
    DeletePVar(playerid, CASE_SPRAY_SPECIAL_PVAR);
    DeletePVar(playerid, CASE_SPRAY_BT2_COUNT_PVAR);
    for(new i = 0; i < 64; i++)
    {
        new key[24];
        format(key, sizeof key, "case_sbt2_%d", i);
        DeletePVar(playerid, key);
    }
    return 1;
}

stock Cases_StorePendingOpenRewards(playerid, open_count, const reward_ui_ids[])
{
    SetPVarInt(playerid, CASE_PENDING_PR_COUNT_PVAR, open_count);
    for(new i = 0; i < open_count && i < 10; i++)
    {
        new key[20];
        format(key, sizeof key, "case_pr_%d", i);
        SetPVarInt(playerid, key, reward_ui_ids[i]);
    }
    return 1;
}

stock Cases_LoadPendingOpenRewards(playerid, reward_ui_ids[], max_count)
{
    new open_count = GetPVarInt(playerid, CASE_PENDING_PR_COUNT_PVAR);
    if(open_count > max_count) open_count = max_count;
    if(open_count < 0) open_count = 0;

    for(new i = 0; i < open_count; i++)
    {
        new key[20];
        format(key, sizeof key, "case_pr_%d", i);
        reward_ui_ids[i] = GetPVarInt(playerid, key);
    }
    return open_count;
}

stock Cases_QueueOpenResult(playerid, bool:success, open_count, const reward_ui_ids[])
{
    Cases_CancelOpenResultTimer(playerid);
    SetPVarInt(playerid, CASE_PENDING_OPEN_OK_PVAR, success ? 1 : 0);

    if(!success || open_count <= 0)
    {
        Cases_SendOpenResultPacket(playerid, false, 0, reward_ui_ids);
        return 1;
    }

    Cases_StorePendingOpenRewards(playerid, open_count, reward_ui_ids);
    new delay_ms = (open_count >= 10) ? CASES_OPEN_ANIM_MS_TEN : CASES_OPEN_ANIM_MS_ONE;
    SetPVarInt(playerid, CASE_OPEN_RESULT_TIMER_PVAR,
        SetTimerEx("CasesDeliverOpenResultTimer", delay_ms, false, "i", playerid));
    return 1;
}

public CasesDeliverOpenResultTimer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    DeletePVar(playerid, CASE_OPEN_RESULT_TIMER_PVAR);

    new reward_ui_ids[10];
    new open_count = Cases_LoadPendingOpenRewards(playerid, reward_ui_ids, sizeof reward_ui_ids);
    new bool:open_ok = (GetPVarInt(playerid, CASE_PENDING_OPEN_OK_PVAR) > 0 && open_count > 0);

    Cases_CancelOpenResultTimer(playerid);

    if(Player[playerid][pID] > 0)
    {
        Cases_SaveCounts(playerid);
        SavePlayerAccount(playerid);
    }

    Cases_SendOpenResultPacket(playerid, open_ok, open_count, reward_ui_ids);
    return 0;
}

stock Cases_StorePendingSprayBt2(playerid, const bt2_ids[], bt2_count)
{
    if(bt2_count > 64) bt2_count = 64;
    SetPVarInt(playerid, CASE_SPRAY_BT2_COUNT_PVAR, bt2_count);
    for(new i = 0; i < bt2_count; i++)
    {
        new key[24];
        format(key, sizeof key, "case_sbt2_%d", i);
        SetPVarInt(playerid, key, bt2_ids[i]);
    }
    return 1;
}

stock Cases_LoadPendingSprayBt2(playerid, bt2_ids[], max_count)
{
    new bt2_count = GetPVarInt(playerid, CASE_SPRAY_BT2_COUNT_PVAR);
    if(bt2_count > max_count) bt2_count = max_count;
    if(bt2_count < 0) bt2_count = 0;

    for(new i = 0; i < bt2_count; i++)
    {
        new key[24];
        format(key, sizeof key, "case_sbt2_%d", i);
        bt2_ids[i] = GetPVarInt(playerid, key);
    }
    return bt2_count;
}

stock Cases_QueueSprayResponse(playerid, bool:from_reward_screen, bool:special_case, const bt2_ids[], bt2_count)
{
    Cases_CancelSprayReplyTimer(playerid);
    SetPVarInt(playerid, CASE_SPRAY_REWARD_SCR_PVAR, from_reward_screen ? 1 : 0);
    SetPVarInt(playerid, CASE_SPRAY_SPECIAL_PVAR, special_case ? 1 : 0);
    Cases_StorePendingSprayBt2(playerid, bt2_ids, bt2_count);

    SetPVarInt(playerid, CASE_SPRAY_REPLY_TIMER_PVAR,
        SetTimerEx("CasesDeliverSprayResponseTimer", CASES_SPRAY_REPLY_DELAY_MS, false, "i", playerid));
    return 1;
}

public CasesDeliverSprayResponseTimer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    DeletePVar(playerid, CASE_SPRAY_REPLY_TIMER_PVAR);

    new bt2_echo[64], bt2_echo_count = Cases_LoadPendingSprayBt2(playerid, bt2_echo, sizeof bt2_echo);
    new bool:from_reward_screen = (GetPVarInt(playerid, CASE_SPRAY_REWARD_SCR_PVAR) > 0);
    new bool:special_case = (GetPVarInt(playerid, CASE_SPRAY_SPECIAL_PVAR) > 0);

    Cases_CancelSprayReplyTimer(playerid);

    if(from_reward_screen)
    {
        Cases_SendSprayResponsePacket(playerid, false, bt2_echo, bt2_echo_count);
        if(special_case)
            ScheduleSpecialCaseFlowAfterSpray(playerid, 900);
    }
    else
        Cases_SendTakeSprayResultPacket(playerid);

    return 0;
}

stock Cases_SendOpenGui(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(Player[playerid][pID] <= 0) return 0;

    Cases_CancelOpenResultTimer(playerid);
    Cases_CancelSprayReplyTimer(playerid);

    static cases_open_buf[768];
    new cc[320];
    Cases_BuildCcJsonString(playerid, cc, sizeof cc);
    format(cases_open_buf, sizeof cases_open_buf,
        "{\"o\":1,\"t\":1,\"s\":false,\"bc\":%d,\"pc\":%d,\"cc\":%s}",
        GetPlayerBlackCoin(playerid), GetPlayerDustValue(playerid), cc);
    Cases_ClearRewardScreenFlag(playerid);
    Cases_LogOutgoingPacket(playerid, "OpenGUI", cases_open_buf);
    OnPacketIncomingStr(playerid, 73, cases_open_buf);
    return 1;
}

stock Cases_SendSelectCasePacket(playerid, case_id)
{
    #pragma unused case_id
    if(!IsPlayerConnected(playerid)) return 0;

    static cases_sel_buf[256];
    format(cases_sel_buf, sizeof cases_sel_buf,
        "{\"t\":1,\"s\":1,\"bc\":%d,\"pc\":%d}",
        GetPlayerBlackCoin(playerid), GetPlayerDustValue(playerid));
    Cases_LogOutgoingPacket(playerid, "SelectCase", cases_sel_buf);
    OnPacketIncomingStr(playerid, 73, cases_sel_buf);
    return 1;
}

stock Cases_SendSyncPacket(playerid, success)
{
    if(!IsPlayerConnected(playerid)) return 0;

    static cases_sync_buf[768];
    new cc[320];
    Cases_BuildCcJsonString(playerid, cc, sizeof cc);
    format(cases_sync_buf, sizeof cases_sync_buf,
        "{\"t\":2,\"s\":%d,\"bc\":%d,\"pc\":%d,\"cc\":%s}",
        (success ? 1 : 0), GetPlayerBlackCoin(playerid), GetPlayerDustValue(playerid), cc);
    OnPacketIncomingStr(playerid, 73, cases_sync_buf);
    return 1;
}

stock Cases_SendOpenResultPacket(playerid, bool:success, open_count, const reward_ui_ids[])
{
    if(!IsPlayerConnected(playerid)) return 0;

    static cases_result_buf[1024];
    new cc[320], pr[128];

    Cases_BuildCcJsonString(playerid, cc, sizeof cc);

    if(success && open_count > 0)
    {
        Cases_BuildPrJsonString(open_count, reward_ui_ids, pr, sizeof pr);
        format(cases_result_buf, sizeof cases_result_buf,
            "{\"t\":2,\"s\":1,\"bc\":%d,\"pc\":%d,\"pr\":[%s],\"cc\":%s}",
            GetPlayerBlackCoin(playerid), GetPlayerDustValue(playerid), pr, cc);
    }
    else
    {
        format(cases_result_buf, sizeof cases_result_buf,
            "{\"t\":2,\"s\":0,\"bc\":%d,\"pc\":%d,\"cc\":%s}",
            GetPlayerBlackCoin(playerid), GetPlayerDustValue(playerid), cc);
    }

    if(success && open_count > 0)
        Cases_MarkRewardScreenActive(playerid);

    Cases_LogOutgoingPacket(playerid, "OpenResult", cases_result_buf);
    OnPacketIncomingStr(playerid, 73, cases_result_buf);
    return 1;
}

stock Cases_SendTakeSprayResultPacket(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    static cases_t3_buf[768];
    new cc[320];
    Cases_BuildCcJsonString(playerid, cc, sizeof cc);
    format(cases_t3_buf, sizeof cases_t3_buf,
        "{\"t\":3,\"s\":1,\"pc\":%d,\"cc\":%s}",
        GetPlayerDustValue(playerid), cc);
    Cases_LogOutgoingPacket(playerid, "TakeSpray", cases_t3_buf);
    OnPacketIncomingStr(playerid, 73, cases_t3_buf);
    return 1;
}

stock Cases_SendSprayResponsePacket(playerid, bool:include_cc, const bt2_ids[], bt2_count)
{
    if(!IsPlayerConnected(playerid)) return 0;

    static cases_spray_buf[1024];
    new cc[320], bt2[192];
    new pc = GetPlayerDustValue(playerid);

    bt2[0] = '\0';
    if(bt2_count > 0)
        Cases_BuildIntListJson(bt2_ids, bt2_count, bt2, sizeof bt2);

    if(include_cc)
    {
        Cases_BuildCcJsonString(playerid, cc, sizeof cc);
        if(bt2[0])
            format(cases_spray_buf, sizeof cases_spray_buf,
                "{\"t\":3,\"s\":1,\"pc\":%d,\"bt2\":[%s],\"cc\":%s}", pc, bt2, cc);
        else
            format(cases_spray_buf, sizeof cases_spray_buf,
                "{\"t\":3,\"s\":1,\"pc\":%d,\"cc\":%s}", pc, cc);
        Cases_LogOutgoingPacket(playerid, "SpraySpecial", cases_spray_buf);
    }
    else
    {
        if(bt2[0])
            format(cases_spray_buf, sizeof cases_spray_buf,
                "{\"t\":3,\"s\":1,\"pc\":%d,\"bt2\":[%s]}", pc, bt2);
        else
            format(cases_spray_buf, sizeof cases_spray_buf,
                "{\"t\":3,\"s\":1,\"pc\":%d}", pc);
        Cases_LogOutgoingPacket(playerid, "SpraySync", cases_spray_buf);
    }

    OnPacketIncomingStr(playerid, 73, cases_spray_buf);
    return 1;
}

stock Cases_SendSpecialCaseAnimPacket(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    static cases_anim_buf[128];
    format(cases_anim_buf, sizeof cases_anim_buf,
        "{\"t\":5,\"s\":1,\"pc\":%d}",
        GetPlayerDustValue(playerid));
    Cases_LogOutgoingPacket(playerid, "SpecialAnim", cases_anim_buf);
    OnPacketIncomingStr(playerid, 73, cases_anim_buf);
    return 1;
}

stock SendCaseCountsSyncPacket(playerid)
{
    return Cases_SendTakeSprayResultPacket(playerid);
}

stock Cases_CloseGui(playerid)
{
    Cases_CancelOpenResultTimer(playerid);
    Cases_CancelSprayReplyTimer(playerid);
    Cases_ClearRewardScreenFlag(playerid);
    OnPacketIncomingStr(playerid, 73, "{\"c\":1}");
    return 1;
}

stock Cases_CancelAllFlowTimers(playerid)
{
    Cases_CancelOpenResultTimer(playerid);
    Cases_CancelSprayReplyTimer(playerid);
    return 1;
}
