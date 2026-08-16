enum ENUM_CASE_AWARDS {
    aType,
    aInternalID,
    aCount,
    aName[32],
    aSprayPrice
};

#define BP_REWARD_CASE_STANDARD    (90)
#define BP_REWARD_CASE_PREMIUM     (91)
#define BP_REWARD_ROW_STANDARD     (0)
#define BP_REWARD_ROW_PREMIUM      (1)
#define BP_REWARD_MAX_LEVEL        (74)
#define BP_PREMIUM_PRICE           (5000)

forward Accessory_GetAccIdByInvItem(itemId);
forward Accessory_GetIndexByModelId(modelid);
forward Accessory_GetInventoryItemId(accessoryId);
forward SetBPRewardTakenRow(playerid, level, premium, bool:taken);
forward SavePlayerBP(playerid);
#define BP_SPECTRE_MODEL (28731)
#define BP_SPECTRE_VINYL "remapbody47"


stock bool:BP_GetRewardData(row, level, &type, &internal, &count, &spray_price, name[], name_size)
{
    if(level < 1 || level > BP_REWARD_MAX_LEVEL) return false;

    spray_price = 0;
    internal = 1;
    count = 1;

    if(row == BP_REWARD_ROW_PREMIUM)
    {
        switch(level)
        {
            case 1: { type = 2; internal = 1; count = 15000; format(name, name_size, "15000 P"); return true; }
            case 2: { type = 10; internal = 1; count = 10; format(name, name_size, "10 BC"); return true; }
            case 3: { type = 15; internal = 1; count = 10; format(name, name_size, "X10 œ€À‹"); return true; }
            case 4: { type = 16; internal = 1; count = 1; format(name, name_size, "œŒﬂ— NITRO"); return true; }
            case 5: { type = 9; internal = 2; count = 120; format(name, name_size, "GOLD 2˜."); return true; }
            case 6: { type = 2; internal = 1; count = 15000; format(name, name_size, "15000 P"); return true; }
            case 7: { type = 10; internal = 1; count = 10; format(name, name_size, "10 BC"); return true; }
            case 8: { type = 12; internal = 2; count = 1; format(name, name_size, "¡ŒÃ∆ ¿ X1"); return true; }
            case 9: { type = 12; internal = 2; count = 1; format(name, name_size, "¡ŒÃ∆ ¿ X1"); return true; }
            case 10: { type = 5; internal = 743; count = 0; format(name, name_size, "MERCEDES 190 EVO2"); return true; }
            case 11: { type = 9; internal = 2; count = 120; format(name, name_size, "GOLD 2˜."); return true; }
            case 12: { type = 2; internal = 1; count = 15000; format(name, name_size, "15000 P"); return true; }
            case 13: { type = 10; internal = 1; count = 10; format(name, name_size, "10 BC"); return true; }
            case 14: { type = 15; internal = 1; count = 15; format(name, name_size, "X15 œ€À‹"); return true; }
            case 15: { type = 134; internal = 134; count = 6871; format(name, name_size, "œ≈“– “–≈Õ≈–"); return true; }
            case 16: { type = 9; internal = 2; count = 120; format(name, name_size, "GOLD 2˜."); return true; }
            case 17: { type = 2; internal = 1; count = 15000; format(name, name_size, "15000 P"); return true; }
            case 18: { type = 10; internal = 1; count = 10; format(name, name_size, "10 BC"); return true; }
            case 19: { type = 12; internal = 1; count = 1; format(name, name_size, "≈∆≈ƒÕ≈¬Õ€… X1"); return true; }
            case 20: { type = 11; internal = 709; count = 1; format(name, name_size, "Ã¿— ¿"); return true; }
            case 21: { type = 9; internal = 2; count = 120; format(name, name_size, "GOLD 2˜."); return true; }
            case 22: { type = 2; internal = 1; count = 15000; format(name, name_size, "15000 P"); return true; }
            case 23: { type = 10; internal = 1; count = 10; format(name, name_size, "10 BC"); return true; }
            case 24: { type = 15; internal = 1; count = 15; format(name, name_size, "X15 œ€À‹"); return true; }
            case 25: { type = 134; internal = 134; count = 6872; format(name, name_size, " –»—“»Õ¿"); return true; }
            case 26: { type = 9; internal = 2; count = 120; format(name, name_size, "GOLD 2˜."); return true; }
            case 27: { type = 2; internal = 1; count = 15000; format(name, name_size, "15000 P"); return true; }
            case 28: { type = 10; internal = 1; count = 10; format(name, name_size, "10 BC"); return true; }
            case 29: { type = 12; internal = 2; count = 1; format(name, name_size, "¡ŒÃ∆ ¿ X1"); return true; }
            case 30: { type = 5; internal = 744; count = 0; format(name, name_size, "TOYOTA TUNDRA"); return true; }
            case 31: { type = 9; internal = 2; count = 120; format(name, name_size, "GOLD 2˜."); return true; }
            case 32: { type = 2; internal = 1; count = 20000; format(name, name_size, "20000 P"); return true; }
            case 33: { type = 10; internal = 1; count = 10; format(name, name_size, "10 BC"); return true; }
            case 34: { type = 15; internal = 1; count = 20; format(name, name_size, "X20 œ€À‹"); return true; }
            case 35: { type = 11; internal = 914; count = 1; format(name, name_size, "DEATHSNAKE"); return true; }
            case 36: { type = 9; internal = 2; count = 120; format(name, name_size, "GOLD 2˜."); return true; }
            case 37: { type = 2; internal = 1; count = 20000; format(name, name_size, "20000 P"); return true; }
            case 38: { type = 10; internal = 1; count = 10; format(name, name_size, "10 BC"); return true; }
            case 39: { type = 12; internal = 2; count = 1; format(name, name_size, "¡ŒÃ∆ ¿ X1"); return true; }
            case 40: { type = 134; internal = 134; count = 6894; format(name, name_size, "œ–Œƒﬁ—≈–"); return true; }
            case 41: { type = 9; internal = 3; count = 1440; format(name, name_size, "PLATINUM 24˜."); return true; }
            case 42: { type = 2; internal = 1; count = 20000; format(name, name_size, "20000 P"); return true; }
            case 43: { type = 10; internal = 1; count = 20; format(name, name_size, "20 BC"); return true; }
            case 44: { type = 15; internal = 1; count = 20; format(name, name_size, "X20 œ€À‹"); return true; }
            case 45: { type = 12; internal = 3; count = 1; format(name, name_size, "—“¿Õƒ¿–“Õ€… X1"); return true; }
            case 46: { type = 9; internal = 3; count = 1440; format(name, name_size, "PLATINUM 24˜."); return true; }
            case 47: { type = 2; internal = 1; count = 20000; format(name, name_size, "20000 P"); return true; }
            case 48: { type = 10; internal = 1; count = 20; format(name, name_size, "20 BC"); return true; }
            case 49: { type = 12; internal = 2; count = 1; format(name, name_size, "¡ŒÃ∆ ¿ X1"); return true; }
            case 50: { type = 5; internal = 745; count = 0; format(name, name_size, "VIPER GTC"); return true; }
            case 51: { type = 9; internal = 3; count = 1440; format(name, name_size, "PLATINUM 24˜."); return true; }
            case 52: { type = 2; internal = 1; count = 20000; format(name, name_size, "20000 P"); return true; }
            case 53: { type = 10; internal = 1; count = 20; format(name, name_size, "20 BC"); return true; }
            case 54: { type = 15; internal = 1; count = 20; format(name, name_size, "X20 œ€À‹"); return true; }
            case 55: { type = 11; internal = 915; count = 1; format(name, name_size, "Õ¿√–”ƒÕ» "); return true; }
            case 56: { type = 9; internal = 3; count = 1440; format(name, name_size, "PLATINUM 24˜."); return true; }
            case 57: { type = 2; internal = 1; count = 20000; format(name, name_size, "20000 P"); return true; }
            case 58: { type = 10; internal = 1; count = 20; format(name, name_size, "20 BC"); return true; }
            case 59: { type = 12; internal = 2; count = 1; format(name, name_size, "¡ŒÃ∆ ¿ X1"); return true; }
            case 60: { type = 5; internal = 28731; count = 0; format(name, name_size, "ROLLS ROYCE SPECTRE"); return true; }
            case 61: { type = 9; internal = 3; count = 1440; format(name, name_size, "PLATINUM 24˜."); return true; }
            case 62: { type = 2; internal = 1; count = 20000; format(name, name_size, "20000 P"); return true; }
            case 63: { type = 10; internal = 1; count = 20; format(name, name_size, "20 BC"); return true; }
            case 64: { type = 15; internal = 1; count = 20; format(name, name_size, "X20 œ€À‹"); return true; }
            case 65: { type = 11; internal = 916; count = 1; format(name, name_size, "— Œ–Œ—“Õ€≈  –€À‹ﬂ"); return true; }
            case 66: { type = 9; internal = 3; count = 1440; format(name, name_size, "PLATINUM 24˜."); return true; }
            case 67: { type = 2; internal = 1; count = 20000; format(name, name_size, "20000 P"); return true; }
            case 68: { type = 10; internal = 1; count = 20; format(name, name_size, "20 BC"); return true; }
            case 69: { type = 12; internal = 2; count = 1; format(name, name_size, "¡ŒÃ∆ ¿ X1"); return true; }
            case 70: { type = 5; internal = 415; count = 0; format(name, name_size, "LAMBORGHINI"); return true; }
            case 71: { type = 9; internal = 3; count = 1440; format(name, name_size, "PLATINUM 24˜."); return true; }
            case 72: { type = 2; internal = 1; count = 20000; format(name, name_size, "20000 P"); return true; }
            case 73: { type = 10; internal = 1; count = 20; format(name, name_size, "20 BC"); return true; }
            case 74: { type = 12; internal = 3; count = 1; format(name, name_size, "—“¿Õƒ¿–“Õ€… X1"); return true; }
        }
        return false;
    }

    switch(level)
    {
            case 1: { type = 2; internal = 1; count = 5000; format(name, name_size, "5000 P"); return true; }
            case 2: { type = 10; internal = 1; count = 5; format(name, name_size, "5 BC"); return true; }
            case 3: { type = 15; internal = 1; count = 5; format(name, name_size, "X5 œ€À‹"); return true; }
            case 4: { type = 12; internal = 1; count = 1; format(name, name_size, "≈∆≈ƒÕ≈¬Õ€… X1"); return true; }
            case 5: { type = 9; internal = 1; count = 120; format(name, name_size, "SILVER 2˜."); return true; }
            case 6: { type = 2; internal = 1; count = 5000; format(name, name_size, "5000 P"); return true; }
            case 7: { type = 10; internal = 1; count = 5; format(name, name_size, "5 BC"); return true; }
            case 8: { type = 14; internal = 1; count = 24; format(name, name_size, "X2 Õ¿ 24˜."); return true; }
            case 9: { type = 14; internal = 1; count = 24; format(name, name_size, "X2 Õ¿ 24˜."); return true; }
            case 10: { type = 11; internal = 706; count = 1; format(name, name_size, "Œ◊ » STREET"); return true; }
            case 11: { type = 9; internal = 1; count = 120; format(name, name_size, "SILVER 2˜."); return true; }
            case 12: { type = 2; internal = 1; count = 5000; format(name, name_size, "5000 P"); return true; }
            case 13: { type = 1; internal = 1; count = 5; format(name, name_size, "5 EXP"); return true; }
            case 14: { type = 15; internal = 1; count = 5; format(name, name_size, "X5 œ€À‹"); return true; }
            case 15: { type = 12; internal = 1; count = 1; format(name, name_size, "≈∆≈ƒÕ≈¬Õ€… X1"); return true; }
            case 16: { type = 9; internal = 1; count = 120; format(name, name_size, "SILVER 2˜."); return true; }
            case 17: { type = 2; internal = 1; count = 5000; format(name, name_size, "5000 P"); return true; }
            case 18: { type = 10; internal = 1; count = 5; format(name, name_size, "5 BC"); return true; }
            case 19: { type = 14; internal = 1; count = 24; format(name, name_size, "X2 Õ¿ 24˜."); return true; }
            case 20: { type = 11; internal = 705; count = 1; format(name, name_size, "–ﬁ «¿ "); return true; }
            case 21: { type = 9; internal = 1; count = 120; format(name, name_size, "SILVER 2˜."); return true; }
            case 22: { type = 2; internal = 1; count = 5000; format(name, name_size, "5000 P"); return true; }
            case 23: { type = 1; internal = 1; count = 5; format(name, name_size, "5 EXP"); return true; }
            case 24: { type = 15; internal = 1; count = 10; format(name, name_size, "X10 œ€À‹"); return true; }
            case 25: { type = 12; internal = 1; count = 1; format(name, name_size, "≈∆≈ƒÕ≈¬Õ€… X1"); return true; }
            case 26: { type = 9; internal = 1; count = 120; format(name, name_size, "SILVER 2˜."); return true; }
            case 27: { type = 2; internal = 1; count = 5000; format(name, name_size, "5000 P"); return true; }
            case 28: { type = 10; internal = 1; count = 5; format(name, name_size, "5 BC"); return true; }
            case 29: { type = 14; internal = 1; count = 24; format(name, name_size, "X2 Õ¿ 24˜."); return true; }
            case 30: { type = 134; internal = 134; count = 6895; format(name, name_size, "¿«¿–“Õ€…"); return true; }
            case 31: { type = 9; internal = 1; count = 120; format(name, name_size, "SILVER 2˜."); return true; }
            case 32: { type = 2; internal = 1; count = 7500; format(name, name_size, "7500 P"); return true; }
            case 33: { type = 1; internal = 1; count = 10; format(name, name_size, "10 EXP"); return true; }
            case 34: { type = 15; internal = 1; count = 10; format(name, name_size, "X10 œ€À‹"); return true; }
            case 35: { type = 12; internal = 1; count = 1; format(name, name_size, "≈∆≈ƒÕ≈¬Õ€… X1"); return true; }
            case 36: { type = 9; internal = 1; count = 120; format(name, name_size, "SILVER 2˜."); return true; }
            case 37: { type = 2; internal = 1; count = 7500; format(name, name_size, "7500 P"); return true; }
            case 38: { type = 10; internal = 1; count = 5; format(name, name_size, "5 BC"); return true; }
            case 39: { type = 14; internal = 1; count = 24; format(name, name_size, "X2 Õ¿ 24˜."); return true; }
            case 40: { type = 12; internal = 2; count = 1; format(name, name_size, "¡ŒÃ∆ ¿ X1"); return true; }
            case 41: { type = 9; internal = 2; count = 120; format(name, name_size, "GOLD 2˜."); return true; }
            case 42: { type = 2; internal = 1; count = 7500; format(name, name_size, "7500 P"); return true; }
            case 43: { type = 1; internal = 1; count = 10; format(name, name_size, "10 EXP"); return true; }
            case 44: { type = 15; internal = 1; count = 10; format(name, name_size, "X10 œ€À‹"); return true; }
            case 45: { type = 12; internal = 1; count = 1; format(name, name_size, "≈∆≈ƒÕ≈¬Õ€… X1"); return true; }
            case 46: { type = 9; internal = 2; count = 120; format(name, name_size, "GOLD 2˜."); return true; }
            case 47: { type = 2; internal = 1; count = 7500; format(name, name_size, "7500 P"); return true; }
            case 48: { type = 10; internal = 1; count = 10; format(name, name_size, "10 BC"); return true; }
            case 49: { type = 14; internal = 1; count = 24; format(name, name_size, "X2 Õ¿ 24˜."); return true; }
            case 50: { type = 134; internal = 134; count = 6896; format(name, name_size, "¿ÕÕ¿"); return true; }
            case 51: { type = 9; internal = 2; count = 120; format(name, name_size, "GOLD 2˜."); return true; }
            case 52: { type = 2; internal = 1; count = 10000; format(name, name_size, "10000 P"); return true; }
            case 53: { type = 1; internal = 1; count = 10; format(name, name_size, "10 EXP"); return true; }
            case 54: { type = 15; internal = 1; count = 10; format(name, name_size, "X10 œ€À‹"); return true; }
            case 55: { type = 12; internal = 1; count = 1; format(name, name_size, "≈∆≈ƒÕ≈¬Õ€… X1"); return true; }
            case 56: { type = 9; internal = 2; count = 120; format(name, name_size, "GOLD 2˜."); return true; }
            case 57: { type = 2; internal = 1; count = 10000; format(name, name_size, "10000 P"); return true; }
            case 58: { type = 10; internal = 1; count = 10; format(name, name_size, "10 BC"); return true; }
            case 59: { type = 14; internal = 1; count = 24; format(name, name_size, "X2 Õ¿ 24˜."); return true; }
            case 60: { type = 12; internal = 2; count = 2; format(name, name_size, "¡ŒÃ∆ ¿ X2"); return true; }
            case 61: { type = 9; internal = 2; count = 1440; format(name, name_size, "VIP GOLD Õ¿ 24˜."); return true; }
            case 62: { type = 2; internal = 1; count = 10000; format(name, name_size, "10000 P"); return true; }
            case 63: { type = 1; internal = 1; count = 10; format(name, name_size, "10 EXP"); return true; }
            case 64: { type = 15; internal = 1; count = 10; format(name, name_size, "X10 œ€À‹"); return true; }
            case 65: { type = 12; internal = 1; count = 1; format(name, name_size, "≈∆≈ƒÕ≈¬Õ€… X1"); return true; }
            case 66: { type = 9; internal = 3; count = 1440; format(name, name_size, "PLATINUM 24˜."); return true; }
            case 67: { type = 2; internal = 1; count = 10000; format(name, name_size, "10000 P"); return true; }
            case 68: { type = 10; internal = 1; count = 10; format(name, name_size, "10 BC"); return true; }
            case 69: { type = 14; internal = 1; count = 24; format(name, name_size, "X2 Õ¿ 24˜."); return true; }
            case 70: { type = 5; internal = 596; count = 0; format(name, name_size, "BMW 3.5 CSL"); return true; }
            case 71: { type = 9; internal = 3; count = 1440; format(name, name_size, "PLATINUM 24˜."); return true; }
            case 72: { type = 2; internal = 1; count = 10000; format(name, name_size, "10000 P"); return true; }
            case 73: { type = 10; internal = 1; count = 10; format(name, name_size, "10 BC"); return true; }
            case 74: { type = 1; internal = 1; count = 10; format(name, name_size, "10 EXP"); return true; }
    }
    return false;
}

stock BP_AddRewardToRewardList(playerid, level, premium)
{
    if(level < 1 || level > BP_REWARD_MAX_LEVEL) return 0;
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new type, internal, count, spray_price, name[32];
    new row = premium ? BP_REWARD_ROW_PREMIUM : BP_REWARD_ROW_STANDARD;
    if(!BP_GetRewardData(row, level, type, internal, count, spray_price, name, sizeof(name))) return 0;

    new case_id = premium ? BP_REWARD_CASE_PREMIUM : BP_REWARD_CASE_STANDARD;
    new query[512];

    // Queue into /bprewardall. Old bp_reward_sync records must NOT block the queue.
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO `rewards` (`uid`, `award_id`, `case_id`) SELECT %d, %d, %d FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `rewards` WHERE `uid` = %d AND `award_id` = %d AND `case_id` = %d)",
        GetPlayerAccountID(playerid), level, case_id,
        GetPlayerAccountID(playerid), level, case_id);
    mysql_tquery(mysql, query, "", "");

    mysql_format(mysql, query, sizeof(query),
        "INSERT IGNORE INTO `bp_reward_sync` (`user_id`, `level`, `premium`) VALUES (%d, %d, %d)",
        GetPlayerAccountID(playerid), level, premium);
    mysql_tquery(mysql, query, "", "");

    printf("[BP_REWARD_QUEUE_ENSURE] uid=%d level=%d premium=%d case_id=%d", GetPlayerAccountID(playerid), level, premium, case_id);
    return 1;
}

stock Reward_GetDisplayType(type)
{
    switch(type)
    {
        case 12: return 11;
        case 13: return 10;
        case 14: return 11;
        case 15: return 11;
        case 16: return 11;
    }
    return type;
}
