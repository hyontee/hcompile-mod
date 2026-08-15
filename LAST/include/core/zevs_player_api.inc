#if defined _BR_DEATH_PLAYER_API_INC_
    #endinput
#endif
#define _BR_DEATH_PLAYER_API_INC_

#include "../include/system/player_satiety.inc"

// Ранняя реализация API игрока (до cases / calendar в death.pwn)
forward OnPacketIncoming(playerid, guiid, Node:json);
forward OnPacketIncomingStr(playerid, guiid, const json_str[]);

stock GetPlayerNameEx(playerid)
{
    new name[MAX_PLAYER_NAME];
    if(IsPlayerConnected(playerid))
        format(name, sizeof(name), "%s", Player[playerid][pName]);
    return name;
}

stock ShowNotification(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));

    OnPacketIncoming(playerid, 13, JSONObject);
    JSON_Cleanup(JSONObject);
    return 1;
}

stock GetPlayerMoneyEx(playerid)
{
    return Player[playerid][pMoney];
}

stock SyncPlayerBlackCoin(playerid)
{
    if(playerid == INVALID_PLAYER_ID) return 0;

    if(Player[playerid][pDonate] > Player[playerid][pBC])
        Player[playerid][pBC] = Player[playerid][pDonate];
    else if(Player[playerid][pBC] > Player[playerid][pDonate])
        Player[playerid][pDonate] = Player[playerid][pBC];

    return Player[playerid][pBC];
}

stock GetPlayerBlackCoin(playerid)
{
    if(playerid == INVALID_PLAYER_ID) return 0;
    return SyncPlayerBlackCoin(playerid);
}

stock Player_ClampVitals(Float:hp, Float:arm, &Float:out_hp, &Float:out_arm)
{
    out_hp = hp;
    out_arm = arm;
    if(out_hp < 1.0) out_hp = 1.0;
    if(out_hp > 100.0) out_hp = 100.0;
    if(out_arm < 0.0) out_arm = 0.0;
    if(out_arm > 100.0) out_arm = 100.0;
    return 1;
}

stock Player_SyncVitalsFromGame(playerid)
{
    if(playerid == INVALID_PLAYER_ID)
        return 0;
    if(Player[playerid][pID] <= 0)
        return 0;
    if(GetPVarInt(playerid, "auth_reg_flow"))
        return 0;
    if(GetPVarInt(playerid, "auth_reg_finish"))
        return 0;
    if(GetPVarInt(playerid, "spawn_gui_active"))
        return 0;
    if(GetPVarInt(playerid, "spawn_resolving"))
        return 0;
    if(GetPVarInt(playerid, "auth_first_play"))
        return 0;

    new Float:hp = Player[playerid][pHealth];
    new Float:arm = Player[playerid][pArmour];
    if(IsPlayerConnected(playerid))
    {
        GetPlayerHealth(playerid, hp);
        GetPlayerArmour(playerid, arm);
    }
    Player_ClampVitals(hp, arm, Player[playerid][pHealth], Player[playerid][pArmour]);
    return 1;
}

stock Player_ApplySavedVitals(playerid)
{
    if(playerid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid))
        return 0;
    if(Player[playerid][pID] <= 0)
        return 0;

    new Float:hp = Player[playerid][pHealth];
    new Float:arm = Player[playerid][pArmour];
    if(GetPVarInt(playerid, "auth_first_play"))
    {
        hp = 100.0;
        arm = 0.0;
        Player[playerid][pHealth] = 100.0;
        Player[playerid][pArmour] = 0.0;
    }
    if(hp < 1.0 && Player[playerid][pHospitalUnfinished] != 1)
        hp = 100.0;
    if(hp > 100.0) hp = 100.0;
    if(arm < 0.0) arm = 0.0;
    if(arm > 100.0) arm = 100.0;

    SetPlayerHealth(playerid, hp);
    SetPlayerArmour(playerid, arm);
    return 1;
}

stock SavePlayerAccount(playerid)
{
    if(Player[playerid][pID] == 0) return 0;

    if(IsPlayerConnected(playerid) && !GetPVarInt(playerid, "auth_first_play"))
        Player_SyncVitalsFromGame(playerid);

    new save_ban_time = 0, save_ban_start = 0, save_ban_days = 0;
    new save_ban_reason[64], save_ban_admin[24];
    save_ban_reason[0] = EOS;
    save_ban_admin[0] = EOS;
    new bt = Player[playerid][pBanTime];
    if(bt > 0 && (bt == 999999 || bt < 1000000000 || gettime() < bt))
    {
        save_ban_time = bt;
        save_ban_start = Player[playerid][pBanStart];
        save_ban_days = Player[playerid][pBanDays];
        format(save_ban_reason, sizeof(save_ban_reason), "%s", Player[playerid][pBanReason]);
        format(save_ban_admin, sizeof(save_ban_admin), "%s", Player[playerid][pBanAdmin]);
    }

    new query[1024];
    mysql_format(db_handle, query, sizeof(query),
        "UPDATE `players` SET \
        `level`=%d, `exp`=%d, `skin`=%d, `money`=%d, `bank`=%d, `donate`=%d, `bc`=%d, `sim_card`=%d, `phone_owned`=%d, \
        `admlvl`=IF(%d>0,%d,`admlvl`), `admpass`=IF(%d>0,%d,`admpass`), \
        `mute_time`=%d, `jail_time`=%d, `warns`=%d, \
        `ban_time`=%d, `ban_start`=%d, `ban_days`=%d, `ban_reason`='%e', `ban_admin`='%e', \
        `vip_type`=%d, `vip_time`=%d, `dust`=%d, `business`=%d, \
        `lic_a`=%d, `lic_b`=%d, `lic_c`=%d, `lic_d`=%d, `lic_weapon`=%d, `lic_water`=%d, \
        `car_extra_slots`=%d, \
        `spawn_last_x`=%f, `spawn_last_y`=%f, `spawn_last_z`=%f, `spawn_last_a`=%f, `spawn_last_valid`=%d, \
        `player_hp`=%f, `player_armour`=%f, \
        `med_card`=%d, `med_card_ready_at`=%d, `med_quiz_fail_until`=%d, \
        `hospital_fast_heal`=%d, `hospital_fast_heal_until`=%d, `hospital_unfinished`=%d, \
        `med_card_issued_at`=%d, `med_card_expires_at`=%d, `med_card_issuer_branch`=%d, \
        `satiety`=%d \
        WHERE `id`=%d",
        Player[playerid][pLevel], Player[playerid][pExp], Player[playerid][pSkin],
        Player[playerid][pMoney], Player[playerid][pBank], GetPlayerBlackCoin(playerid), GetPlayerBlackCoin(playerid), Player[playerid][pSimCard],
        (Player[playerid][pPhoneOwned] ? 1 : 0),
        Player[playerid][pAdminLvl], Player[playerid][pAdminLvl],
        Player[playerid][pAdminLvl], Player[playerid][pAdminPass],
        Player[playerid][pMuteTime], Player[playerid][pJailTime], Player[playerid][pWarns],
        save_ban_time, save_ban_start, save_ban_days, save_ban_reason, save_ban_admin,
        Player[playerid][pVipType], Player[playerid][pVipTime], GetPVarInt(playerid, "player_dust"),
        Player[playerid][pBusiness],
        Player[playerid][pLicA], Player[playerid][pLicB], Player[playerid][pLicC], Player[playerid][pLicD],
        Player[playerid][pLicWeapon], Player[playerid][pLicWater],
        Player[playerid][pCarExtraSlots],
        Player[playerid][pLastSpawnX], Player[playerid][pLastSpawnY], Player[playerid][pLastSpawnZ], Player[playerid][pLastSpawnA],
        (Player[playerid][pLastSpawnValid] ? 1 : 0),
        Player[playerid][pHealth], Player[playerid][pArmour],
        Player[playerid][pMedCard], Player[playerid][pMedCardReadyAt],
        Player[playerid][pMedQuizFailUntil],
        ((Player[playerid][pHospitalFastHealUntil] > gettime()) ? 1 : 0),
        Player[playerid][pHospitalFastHealUntil],
        Player[playerid][pHospitalUnfinished],
        Player[playerid][pMedCardIssuedAt], Player[playerid][pMedCardExpiresAt],
        Player[playerid][pMedCardIssuerBranch],
        Satiety_Get(playerid),
        Player[playerid][pID]
    );
    mysql_tquery(db_handle, query, "", "");
    g_SatietyDbDirty[playerid] = false;

    new case_query[400];
    mysql_format(db_handle, case_query, sizeof(case_query),
        "UPDATE `players` SET `counttodaycases`=%d, `countbomjcases`=%d, `countstandartcases`=%d, \
        `countcarcases`=%d, `countosobiycases`=%d, `giftdelay`=%d WHERE `id`=%d",
        Player[playerid][pCountTodayCases],
        Player[playerid][pCountBomjCases],
        Player[playerid][pCountStandartCases],
        Player[playerid][pCountCarCases],
        Player[playerid][pCountOsobiyCases],
        Player[playerid][pGiftDelay],
        Player[playerid][pID]
    );
    mysql_tquery(db_handle, case_query, "", "");
    return 1;
}

stock GivePlayerMoneyEx(playerid, amount)
{
    Player[playerid][pMoney] += amount;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, Player[playerid][pMoney]);

    new fmt_str[64];
    if(!GetPVarInt(playerid, "tune_skip_money_notify") && !GetPVarInt(playerid, "trade_no_money_notify"))
    {
        if(amount < 0)
        {
            format(fmt_str, sizeof(fmt_str), "Вы потратили %d рублей.", -amount);
            ShowNotification(playerid, 0, 5, 0, 1, fmt_str, "");
        }
        else
        {
            format(fmt_str, sizeof(fmt_str), "Вы получили %d рублей.", amount);
            ShowNotification(playerid, 1, 5, 0, 1, fmt_str, "");
        }
    }

    SavePlayerAccount(playerid);
    return 1;
}

stock GivePlayerBlackCoin(playerid, amount)
{
    if(playerid == INVALID_PLAYER_ID) return 0;

    if(Player[playerid][pDonate] > Player[playerid][pBC])
        Player[playerid][pBC] = Player[playerid][pDonate];

    Player[playerid][pBC] += amount;
    Player[playerid][pDonate] = Player[playerid][pBC];

    new fmt_str[64];
    if(amount < 0)
    {
        if(!GetPVarInt(playerid, "tune_skip_bc_notify"))
        {
            format(fmt_str, sizeof(fmt_str), "Вы потратили %d BC.", -amount);
            ShowNotification(playerid, 0, 5, 0, 1, fmt_str, "");
        }
    }
    else
    {
        format(fmt_str, sizeof(fmt_str), "Вы получили %d BC.", amount);
        ShowNotification(playerid, 1, 5, 0, 1, fmt_str, "");
    }

    new query[128];
    mysql_format(db_handle, query, sizeof(query),
        "UPDATE `players` SET `bc` = %d, `donate` = %d WHERE `id` = %d",
        Player[playerid][pBC], Player[playerid][pBC], Player[playerid][pID]);
    mysql_tquery(db_handle, query, "", "");
    return 1;
}

stock SetPlayerX2(playerid, bool:enable, time)
{
    if(!IsPlayerConnected(playerid) || playerid == INVALID_PLAYER_ID)
        return 0;

    new BitStream:bs = BS_New();
    if(bs == BitStream:0)
        return 0;

    BS_WriteValue(bs, PR_UINT8, 0x18, PR_UINT8, enable, PR_UINT8, time);

    if(IsPlayerConnected(playerid))
        PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);

    BS_Delete(bs);
    return 1;
}

stock Lic_SetPlayerLicense(playerid, lic_type, days)
{
    if(!IsPlayerConnected(playerid) || Player[playerid][pID] <= 0) return 0;
    if(lic_type < 1 || lic_type > 6) return 0;

    new expire = 0;
    if(days > 0) expire = gettime() + (days * 86400);

    switch(lic_type)
    {
        case 1: Player[playerid][pLicA] = expire;
        case 2: Player[playerid][pLicB] = expire;
        case 3: Player[playerid][pLicC] = expire;
        case 4: Player[playerid][pLicD] = expire;
        case 5: Player[playerid][pLicWeapon] = expire;
        case 6: Player[playerid][pLicWater] = expire;
        default: return 0;
    }

    SavePlayerAccount(playerid);
    return 1;
}

stock GetPlayerSimCard(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    return Player[playerid][pSimCard];
}

stock GetExpToNextLevel(playerid)
{
    return 8 + (Player[playerid][pLevel] - 1) * 4;
}

stock SendAdminMessage(color, string[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && Player[i][pAdminAuth])
            SendClientMessage(i, color, string);
    }
    return 1;
}
