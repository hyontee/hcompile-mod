#include <a_samp>
#include <sscanf2>
#include <json>
#include <a_mysql>

#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_RED   0xFF0000FF
#define COLOR_GREY  0xAFAFAFFF

// =============================
//   НАСТРОЙКИ / ИНТЕГРАЦИЯ
// =============================
// Этот filterscript НЕ лезет напрямую в Player[][] и VehicleInfo[][] из мода.
// Вместо этого он вызывает forward/natives-обёртки, которые ты должен
// реализовать в основном моде.
//
// Минимум, что нужно сделать в моде:
// 1) вернуть ID аккаунта игрока
// 2) вернуть/изменить количество кейсов
// 3) вернуть/изменить пыль / BC
// 4) выдать награду
// 5) открыть клиентский пакет / уведомление
// 6) сохранить аккаунт
//
// Ниже уже готовы forward-объявления. Просто реализуй их в gamemode.

forward Cases_GetPlayerID(playerid);
forward Cases_GetPlayerName(playerid, name[], len);
forward Cases_GetPlayerAdminLevel(playerid);
forward Cases_IsPlayerAdminAuth(playerid);
forward Cases_SavePlayerAccount(playerid);

forward Cases_GetPlayerBlackCoin(playerid);
forward Cases_GivePlayerBlackCoin(playerid, amount);

forward Cases_GetPlayerDust(playerid);
forward Cases_SetPlayerDust(playerid, amount);

forward Cases_GetPlayerCaseCount(playerid, case_type);
forward Cases_SetPlayerCaseCount(playerid, case_type, value);

forward Cases_ShowNotification(playerid, type, icon, a1, a2, const title[], const text[]);
forward Cases_SendPacket(playerid, packetid, Node:json);

// Награды. Возвращай 1 при успехе, 0 при ошибке.
forward Cases_GiveRewardEXP(playerid, amount);
forward Cases_GiveRewardMoney(playerid, amount);
forward Cases_GiveRewardVehicle(playerid, modelid, const veh_name[]);
forward Cases_GiveRewardVIP(playerid, vip_type, vip_minutes);
forward Cases_GiveRewardItem(playerid, itemid, amount, const item_name[]);
forward Cases_GiveRewardSkin(playerid, skinid, const skin_name[]);

// DB handle должен существовать в моде.
forward MySQL:Cases_GetDBHandle();

// =============================
//   ДАННЫЕ КЕЙСОВ
// =============================
enum ENUM_CASE_AWARDS {
    aType,
    aInternalID,
    aCount,
    aName[32],
    aSprayPrice
};

new CaseDailyAwards[20][ENUM_CASE_AWARDS] = {
    {11, 23, 1, "Рем.комплект", 10},
    {1, 1, 2, "2 EXP", 0},
    {10, 1, 200, "200 BP EXP", 0},
    {11, 21, 1, "Канистра с бензином", 10},
    {2, 1, 4000, "4000 rub", 0},
    {10, 1, 5, "5 BC", 0},
    {2, 1, 8000, "8000 rub", 0},
    {10, 1, 10, "10 BC", 0},
    {9, 1, 2, "VIP SILVER 2ч.", 10},
    {10, 1, 400, "400 BP EXP", 0},
    {1, 1, 4, "4 EXP", 0},
    {5, 462, 0, "RACER SPORT", 20},
    {10, 1, 500, "500 BP EXP", 0},
    {2, 1, 20000, "20000 rub", 0},
    {10, 1, 15, "15 BC", 0},
    {9, 2, 2, "VIP GOLD 2ч.", 10},
    {10, 1, 600, "600 BP EXP", 0},
    {2, 1, 30000, "30000 rub", 0},
    {1, 1, 6, "6 EXP", 0},
    {5, 549, 0, "ВАЗ 1111", 20}
};

new CaseSpecialAwards[20][ENUM_CASE_AWARDS] = {
    {5, 410, 0, "Mercedes-Benz C63s", 230},
    {5, 604, 0, "Porsche Panamera S", 260},
    {5, 2389, 0, "BMW M6 F12", 270},
    {5, 2574, 0, "BMW X7 M50i", 290},
    {5, 2586, 0, "Jaguar XK120", 340},
    {5, 2593, 0, "Lamborghini Gallardo", 340},
    {5, 2585, 0, "Mercedes-Benz 300SL", 340},
    {5, 2551, 0, "Lamborghini Urus", 350},
    {5, 2549, 0, "Lamborghini Huracan", 370},
    {5, 2393, 0, "Corvette C8", 370},
    {5, 579, 0, "Mercedes-Benz G65 AMG", 370},
    {5, 2619, 0, "Ferrari 488 Pista", 460},
    {5, 2583, 0, "Rolls-Royce Wraith", 530},
    {5, 669, 0, "Tesla CyberTruck", 570},
    {5, 2564, 0, "Rolls-Royce Cullinan", 570},
    {5, 2591, 0, "Continental GT", 670},
    {5, 2601, 0, "BUGATTI CHIRON", 800},
    {5, 667, 0, "Koenigsegg Regera", 850},
    {5, 666, 0, "Bugatti Veyron", 900},
    {5, 466, 1, "BMW M5 F90 (ППС)", 900}
};

new CaseDriveAwards[25][ENUM_CASE_AWARDS] = {
    {134, 134, 14386, "Бархатные тяги", 100},
    {11, 360, 1, "Кейс чёрный", 100},
    {11, 946, 1, "Маска Fresh'а", 120},
    {11, 511, 1, "Крылья ангела", 100},
    {11, 945, 1, "Рюкзак Energy", 100},
    {10, 1, 700, "700 BC", 0},
    {10, 1, 7000, "7000 BP EXP", 0},
    {134, 134, 11917, "Хоуми с района", 110},
    {23, 1, 3000, "Ёлочные шары x3000", 0},
    {5, 2568, 0, "BMW X5 E53", 110},
    {11, 944, 1, "Сумка SpeedPack", 140},
    {134, 134, 5885, "Искра", 140},
    {134, 134, 5326, "Снеговик", 130},
    {5, 603, 0, "FORD MUSTANG GT", 140},
    {23, 1, 7500, "Ёлочные шары x7500", 0},
    {5, 442, 0, "Volvo V60", 170},
    {23, 1, 5000, "Ёлочные шары x5000", 0},
    {134, 134, 5884, "Петр Шторм", 160},
    {5, 503, 0, "DODGE DEMON SRT", 230},
    {23, 1, 15000, "Ёлочные шары x15000", 0},
    {5, 2603, 0, "Mercedes E63 W212", 250},
    {5, 502, 0, "Nissan GT-R R35", 260},
    {5, 2599, 0, "BMW 750Li", 340},
    {5, 659, 48, "Renault R5 Turbo", 180},
    {5, 661, 49, "Ferrari 812", 490}
};

new CaseStandartAwards[37][ENUM_CASE_AWARDS] = {
    {11, 362, 1, "Золотая корона", 90},
    {9, 2, 504, "VIP GOLD 21 дн.", 90},
    {2, 1, 600000, "600000 rub", 0},
    {11, 360, 1, "Кейс чёрный", 90},
    {5, 527, 0, "BMW M3 E46", 100},
    {134, 134, 11962, "Рыбак", 90},
    {10, 1, 600, "600 BC", 0},
    {9, 3, 360, "VIP PLATINUM 15 д.", 100},
    {5, 445, 0, "ACURA TSX", 100},
    {11, 583, 1, "Мопс на спину", 100},
    {134, 134, 14388, "Бархатные тяги особые", 100},
    {11, 508, 1, "Корона демона", 100},
    {134, 134, 11917, "Хоуми с района", 110},
    {5, 589, 0, "VOLKSWAGEN GOLF GTI", 110},
    {5, 2568, 0, "BMW X5 E53", 110},
    {5, 2385, 0, "NISSAN QASHQAI", 120},
    {5, 2623, 0, "TOYOTA CAMRY XV55", 120},
    {5, 2627, 0, "NISSAN SILVIA S15", 120},
    {5, 461, 0, "DUCATI SUPERSPORT S", 130},
    {2, 1, 1000000, "1000000 rub", 0},
    {9, 3, 720, "VIP PLATINUM 30 д.", 130},
    {134, 134, 236, "Барыга преступник", 130},
    {5, 2567, 0, "BMW M5 E60", 130},
    {134, 134, 11935, "Мент из клипа", 140},
    {5, 560, 0, "SUBARU WRX STI", 140},
    {134, 134, 5323, "Бурдалаак страшный дед", 140},
    {5, 2584, 0, "KIA K5", 150},
    {5, 2390, 0, "BMW X5M E70", 160},
    {5, 543, 0, "CHEVROLET CAMARO ZL1", 200},
    {5, 2394, 0, "DODGE CHARGER SRT", 200},
    {11, 707, 1, "Маска свина", 220},
    {5, 402, 0, "MERCEDES-BENZ GT63S", 240},
    {5, 2598, 0, "BMW M4 G82", 250},
    {5, 400, 0, "BMW X6M F16", 260},
    {5, 506, 0, "PORSCHE 911 CARRERA S", 270},
    {5, 415, 0, "LAMBORGHINI AVENTADOR S", 400},
    {5, 2543, 0, "TESLA MODEL X", 400}
};

new CaseAutoAwards[31][ENUM_CASE_AWARDS] = {
    {5, 436, 0, "MITSUBISHI LANCER EVO X", 130},
    {5, 2567, 0, "BMW M5 E60", 130},
    {5, 560, 0, "SUBARU WRX STI", 140},
    {5, 550, 0, "TOYOTA CAMRY 3.5", 140},
    {5, 2584, 0, "KIA K5", 150},
    {5, 603, 0, "FORD MUSTANG GT", 150},
    {5, 2552, 0, "TOYOTA SUPRA A80", 150},
    {5, 565, 0, "MERCEDES-BENZ A45 AMG", 150},
    {5, 2609, 0, "MINI COUNTRYMAN", 160},
    {5, 2604, 0, "VOLKSWAGEN PASSAT", 160},
    {5, 551, 0, "ALFA ROMEO GUILIA", 160},
    {5, 2390, 0, "BMW X5M E70", 160},
    {5, 526, 0, "INFINITI Q60S", 160},
    {5, 2620, 0, "LEXUS RCF", 170},
    {5, 2594, 0, "SUBARU BRZ", 180},
    {5, 2621, 0, "XPENG P7", 180},
    {5, 2387, 0, "BMW 3-SERIES G20", 200},
    {5, 480, 0, "BMW Z4 M40I", 200},
    {5, 2394, 0, "DODGE CHARGER SRT", 200},
    {5, 558, 0, "BMW M4 F84", 210},
    {5, 402, 0, "MERCEDES-BENZ GT63S", 240},
    {5, 2598, 0, "BMW M4 G82", 250},
    {5, 502, 0, "NISSAN GT-R R35", 260},
    {5, 2596, 0, "DODGE RAM", 260},
    {5, 400, 0, "BMW X6M F16", 260},
    {5, 604, 0, "PORSCHE PANAMERA S", 260},
    {5, 506, 0, "PORSCHE 911 CARRERA", 270},
    {5, 415, 0, "LAMBORGHINI AVENTADOR S", 400},
    {5, 2543, 0, "TESLA MODEL X", 400},
    {5, 2558, 0, "MERCEDES-BENZ MAYBACH S650", 450},
    {5, 2573, 0, "MERCEDES-BENZ G63 AMG", 430}
};

new CaseBomjAwards[28][ENUM_CASE_AWARDS] = {
    {5, 468, 0, "Aprilla MXV 450", 20},
    {5, 496, 0, "VOLKSWAGEN GOLF GTI 2", 20},
    {2, 1, 75000, "75000 rub", 0},
    {5, 404, 0, "ВАЗ 2107", 20},
    {1, 1, 12, "12 EXP", 0},
    {5, 439, 0, "ВАЗ 2108", 20},
    {2, 1, 90000, "90000 rub", 0},
    {5, 492, 0, "ВАЗ 2109", 20},
    {5, 547, 0, "ВАЗ 2110", 20},
    {5, 458, 0, "ВАЗ 2114", 20},
    {9, 1, 168, "VIP SILVER 7", 20},
    {5, 491, 0, "ВАЗ 2112", 20},
    {5, 585, 0, "ВАЗ 2115", 20},
    {1, 1, 16, "16 EXP", 0},
    {2, 1, 120000, "120000 rub", 0},
    {9, 2, 72, "VIP GOLD 3", 20},
    {5, 536, 0, "VOLVO 242DL", 20},
    {5, 529, 0, "ВАЗ 2170", 20},
    {9, 3, 72, "VIP PLATINUM 3", 20},
    {5, 542, 0, "NIVA URBAN", 20},
    {5, 421, 0, "Mercedes W124", 20},
    {5, 2618, 0, "BMW M3 E36", 20},
    {5, 2548, 0, "LADA VESTA", 30},
    {11, 706, 1, "Glasses", 30},
    {5, 516, 0, "VW POLO", 30},
    {11, 705, 1, "Backpack", 30},
    {134, 134, 252, "Igla", 40},
    {134, 134, 6810, "King", 40}
};

stock Cases_AddPlayerDustValue(playerid, amount)
{
    new dust = Cases_GetPlayerDust(playerid) + amount;
    if(dust < 0) dust = 0;
    Cases_SetPlayerDust(playerid, dust);
    return dust;
}

stock Cases_GetAwardInfo(case_id, a_id, &type, &count, &internal, name[], name_len, &spray_price)
{
    if(case_id == 1 && a_id >= 0 && a_id < 20) {
        type = CaseDailyAwards[a_id][aType];
        count = CaseDailyAwards[a_id][aCount];
        internal = CaseDailyAwards[a_id][aInternalID];
        spray_price = CaseDailyAwards[a_id][aSprayPrice];
        format(name, name_len, "%s", CaseDailyAwards[a_id][aName]);
        return 1;
    }
    if(case_id == 2 && a_id >= 0 && a_id < 28) {
        type = CaseBomjAwards[a_id][aType];
        count = CaseBomjAwards[a_id][aCount];
        internal = CaseBomjAwards[a_id][aInternalID];
        spray_price = CaseBomjAwards[a_id][aSprayPrice];
        format(name, name_len, "%s", CaseBomjAwards[a_id][aName]);
        return 1;
    }
    if(case_id == 3 && a_id >= 0 && a_id < 37) {
        type = CaseStandartAwards[a_id][aType];
        count = CaseStandartAwards[a_id][aCount];
        internal = CaseStandartAwards[a_id][aInternalID];
        spray_price = CaseStandartAwards[a_id][aSprayPrice];
        format(name, name_len, "%s", CaseStandartAwards[a_id][aName]);
        return 1;
    }
    if(case_id == 4 && a_id >= 0 && a_id < 31) {
        type = CaseAutoAwards[a_id][aType];
        count = CaseAutoAwards[a_id][aCount];
        internal = CaseAutoAwards[a_id][aInternalID];
        spray_price = CaseAutoAwards[a_id][aSprayPrice];
        format(name, name_len, "%s", CaseAutoAwards[a_id][aName]);
        return 1;
    }
    if(case_id == 5 && a_id >= 0 && a_id < 20) {
        type = CaseSpecialAwards[a_id][aType];
        count = CaseSpecialAwards[a_id][aCount];
        internal = CaseSpecialAwards[a_id][aInternalID];
        spray_price = CaseSpecialAwards[a_id][aSprayPrice];
        format(name, name_len, "%s", CaseSpecialAwards[a_id][aName]);
        return 1;
    }
    if(case_id == 8 && a_id >= 0 && a_id < 25) {
        type = CaseDriveAwards[a_id][aType];
        count = CaseDriveAwards[a_id][aCount];
        internal = CaseDriveAwards[a_id][aInternalID];
        spray_price = CaseDriveAwards[a_id][aSprayPrice];
        format(name, name_len, "%s", CaseDriveAwards[a_id][aName]);
        return 1;
    }
    return 0;
}

forward FS_OnPlayerRewardsLoad(playerid);
public FS_OnPlayerRewardsLoad(playerid)
{
    new rows, fields;
    new MySQL:db = Cases_GetDBHandle();
    cache_get_data(rows, fields, db);

    if(rows == 0)
    {
        if(GetPVarInt(playerid, "reward_offset") == 0)
        {
            Cases_ShowNotification(playerid, 2, 4, 1, 1, "У вас нет доступных наград!", "");
            new Node:emptyObj = JSON_Object();
            JSON_SetInt(emptyObj, "o", 1);
            JSON_SetInt(emptyObj, "pc", Cases_GetPlayerDust(playerid));
            JSON_SetArray(emptyObj, "pr", JSON_Array());
            Cases_SendPacket(playerid, 74, emptyObj);
            JSON_Cleanup(emptyObj);
        }
        return 1;
    }

    new Node:JSONObject = JSON_Object();
    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "pc", Cases_GetPlayerDust(playerid));
    JSON_SetInt(JSONObject, "next_page", (rows > 18) ? 1 : 0);

    new Node:prArray = JSON_Array();
    new display_rows = (rows > 18) ? 18 : rows;

    for(new j = 0; j < display_rows; j++)
    {
        new a_id = cache_get_field_content_int(j, "award_id", db);
        new db_id = cache_get_field_content_int(j, "id", db);
        new case_id = cache_get_field_content_int(j, "case_id", db);
        new type, count, internal, spray_price, name[32];

        if(Cases_GetAwardInfo(case_id, a_id, type, count, internal, name, sizeof name, spray_price))
        {
            new Node:item = JSON_Object();
            JSON_SetInt(item, "el", internal);
            JSON_SetInt(item, "id", db_id);
            JSON_SetString(item, "n", name);
            JSON_SetInt(item, "st", 1);
            JSON_SetInt(item, "td", type);
            JSON_SetInt(item, "sp", spray_price);

            new Node:tempArray = JSON_Array(item);
            prArray = JSON_Append(prArray, tempArray);
        }
    }

    JSON_SetArray(JSONObject, "pr", prArray);
    Cases_SendPacket(playerid, 74, JSONObject);
    JSON_Cleanup(JSONObject);
    return 1;
}

forward FS_OnRewardDebug(playerid, db_id, reward_action);
public FS_OnRewardDebug(playerid, db_id, reward_action)
{
    new MySQL:db = Cases_GetDBHandle();
    if(cache_num_rows() <= 0) return 1;

    new a_id = cache_get_field_content_int(0, "award_id", db);
    new case_id = cache_get_field_content_int(0, "case_id", db);
    new type, count, internal, spray_price, name[32];

    if(!Cases_GetAwardInfo(case_id, a_id, type, count, internal, name, sizeof name, spray_price))
        return 1;

    new bool:should_delete = true;

    if(reward_action == 3)
    {
        if(spray_price > 0)
        {
            new got_dust = Cases_AddPlayerDustValue(playerid, spray_price);
            new dust_notify[128];
            format(dust_notify, sizeof dust_notify, "Вы распылили награду и получили %d пыли. Всего: %d", spray_price, got_dust);
            Cases_ShowNotification(playerid, 1, 5, 1, 0, dust_notify, "");
        }
        else
        {
            Cases_ShowNotification(playerid, 2, 4, 1, 1, "Эту награду нельзя распылить!", "");
            should_delete = false;
        }
    }
    else
    {
        switch(type)
        {
            case 1: if(!Cases_GiveRewardEXP(playerid, count)) should_delete = false;
            case 2: if(!Cases_GiveRewardMoney(playerid, count)) should_delete = false;
            case 5: if(!Cases_GiveRewardVehicle(playerid, internal, name)) should_delete = false;
            case 9: if(!Cases_GiveRewardVIP(playerid, internal, count * 60)) should_delete = false;
            case 10: if(!Cases_GivePlayerBlackCoin(playerid, count)) should_delete = false;
            case 11: if(!Cases_GiveRewardItem(playerid, internal, count, name)) should_delete = false;
            case 134: if(!Cases_GiveRewardSkin(playerid, count, name)) should_delete = false;
            default: should_delete = false;
        }
    }

    if(should_delete)
    {
        Cases_SavePlayerAccount(playerid);

        new d_query[128];
        mysql_format(db, d_query, sizeof d_query, "DELETE FROM `rewards` WHERE `id` = %d", db_id);
        mysql_tquery(db, d_query, "", "");

        new Node:res = JSON_Object();
        JSON_SetInt(res, "t", 4);
        JSON_SetInt(res, "s", 1);
        JSON_SetInt(res, "id", db_id);
        JSON_SetInt(res, "pc", Cases_GetPlayerDust(playerid));
        Cases_SendPacket(playerid, 74, res);
        JSON_Cleanup(res);
    }
    return 1;
}

// Вызывай это из мода, когда игрок жмёт "получить"/"распылить" по награде.
stock Cases_HandleRewardAction(playerid, db_id, reward_action)
{
    new MySQL:db = Cases_GetDBHandle();
    new query[160];
    mysql_format(db, query, sizeof query,
        "SELECT `award_id`, `case_id` FROM `rewards` WHERE `id` = %d AND `uid` = %d LIMIT 1",
        db_id,
        Cases_GetPlayerID(playerid));
    mysql_tquery(db, query, "FS_OnRewardDebug", "iii", playerid, db_id, reward_action);
    return 1;
}

public OnFilterScriptInit()
{
    print("[cases_fs] loaded");
    return 1;
}

public OnFilterScriptExit()
{
    print("[cases_fs] unloaded");
    return 1;
}


// =============================
//   PUBLIC STUB IMPLEMENTATIONS
// =============================

public Cases_GetPlayerID(playerid) { return playerid; }

public Cases_GetPlayerName(playerid, name[], len)
{
    GetPlayerName(playerid, name, len);
    return 1;
}

public Cases_GetPlayerAdminLevel(playerid) { return 0; }
public Cases_IsPlayerAdminAuth(playerid) { return 1; }

public Cases_SavePlayerAccount(playerid) { return 1; }

public Cases_GetPlayerBlackCoin(playerid) { return 0; }
public Cases_GivePlayerBlackCoin(playerid, amount) { return 1; }

public Cases_GetPlayerDust(playerid) { return 0; }
public Cases_SetPlayerDust(playerid, amount) { return 1; }

public Cases_GetPlayerCaseCount(playerid, case_type) { return 1; }
public Cases_SetPlayerCaseCount(playerid, case_type, value) { return 1; }

public Cases_ShowNotification(playerid, type, icon, a1, a2, const title[], const text[])
{
    new msg[144];
    format(msg,sizeof msg,"%s %s",title,text);
    SendClientMessage(playerid,-1,msg);
    return 1;
}

public Cases_SendPacket(playerid, packetid, Node:json)
{
    // заглушка
    return 1;
}

public Cases_GiveRewardEXP(playerid, amount) { return 1; }

public Cases_GiveRewardMoney(playerid, amount)
{
    GivePlayerMoney(playerid, amount);
    return 1;
}

public Cases_GiveRewardVehicle(playerid, modelid, const veh_name[])
{
    new veh = CreateVehicle(modelid, 0.0,0.0,3.0,0.0, -1,-1, 0);
    PutPlayerInVehicle(playerid, veh, 0);
    return 1;
}

public Cases_GiveRewardVIP(playerid, vip_type, vip_minutes) { return 1; }

public Cases_GiveRewardItem(playerid, itemid, amount, const item_name[]) { return 1; }

public Cases_GiveRewardSkin(playerid, skinid, const skin_name[])
{
    SetPlayerSkin(playerid, skinid);
    return 1;
}

public MySQL:Cases_GetDBHandle()
{
    return MySQL:0;
}



