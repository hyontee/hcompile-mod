#if defined _bp_rewards_included
    #endinput
#endif
#define _bp_rewards_included

#include "../include/a_mysql.inc"
#include <json>

#define CLICK_TAKE              (1)
#define CLICK_ITEM              (2)
#define CLICK_SPRAY             (3)

#define MAX_REWARDS_PER_USER    (50)

#if !defined GUI_BP_REWARDS
    #define GUI_BP_REWARDS          (74)
#endif
#if !defined GUIOpenURL
    #define GUIOpenURL              (51)
#endif


#define BPR_KEY_T           "t"
#define BPR_KEY_CLOSE       "c"
#define BPR_KEY_LIST        "pr"
#define BPR_KEY_ALARMS      "fl"
#define BPR_KEY_ID          "id"
#define BPR_KEY_NAME        "n"
#define BPR_KEY_TYPE        "td"
#define BPR_KEY_ALARM       "st"
#define BPR_KEY_IMAGE_ID    "el"
#define BPR_KEY_SKIN_MODEL  "c"
#define BPR_KEY_DAYS        "ds"
#define BPR_KEY_SPRAY       "sp"
#define BPR_KEY_PLATE       "els"
#define BPR_KEY_RARITY      "r"
#define BPR_KEY_COUNT       "ct"
#define BPR_KEY_TANPIN      "tn"
#define BPR_KEY_CLICK_TYPE  "s"

#define BPR_FILTER_ALL          (1)
#define BPR_FILTER_SKINS        (2)
#define BPR_FILTER_VIP          (3)
#define BPR_FILTER_ACCESSORIES  (4)
#define BPR_FILTER_CARS         (5)
#define BPR_FILTER_CURRENCIES   (6)
#define BPR_FILTER_OTHER        (7)
#define BPR_FILTER_MIN          (1)
#define BPR_FILTER_MAX          (7)

#define BPR_TYPE_CASES      (4)
#define BPR_TYPE_CAR        (5)
#define BPR_TYPE_VIP        (9)
#define BPR_TYPE_INVENTORY  (11)
#define BPR_TYPE_EXP        (1)
#define BPR_TYPE_MONEY      (2)
#define BPR_TYPE_BC         (3)
#define BPR_TYPE_BP_EXP     (10)
#define BPR_TYPE_DUST       (21)
#define BPR_TYPE_EVENT      (23)

#define BPR_PLATE_RU    (59)
#define BPR_PLATE_UA    (81)
#define BPR_PLATE_BY    (82)
#define BPR_PLATE_KZ    (83)
#define BPR_SKIN_EL     (134)

#define ITEM_ALARM_NEW          (1)
#define BPR_PAGE_SIZE           (12)
#define MAX_BPR_ITEM_NAME       (128)
#define MAX_BPR_PLATE_TEXT_LEN  (16)
#define BPR_JSON_BUF_SIZE       (2800)

#if !defined GM_MAX_PLAYERS
    #define GM_MAX_PLAYERS MAX_PLAYERS
#endif
#define MOD_MAX_PLAYERS GM_MAX_PLAYERS

enum E_BPR_USER_REWARD
{
    bpr_user_reward_id,
    bpr_user_id,
    bpr_reward_type,
    bpr_reward_image_id,
    bpr_reward_skin_model_id,
    bpr_reward_name[MAX_BPR_ITEM_NAME],
    bpr_reward_rarity,
    bpr_reward_quantity,
    bpr_reward_days_left,
    bpr_reward_spray_price,
    bpr_reward_plate_text_0[MAX_BPR_PLATE_TEXT_LEN],
    bpr_reward_plate_text_1[MAX_BPR_PLATE_TEXT_LEN],
    bpr_reward_plate_text_2[MAX_BPR_PLATE_TEXT_LEN],
    bpr_reward_plate_text_3[MAX_BPR_PLATE_TEXT_LEN],
    bpr_reward_plate_count,
    bpr_received_date,
    bpr_expire_date,
    bpr_is_taken,
    bpr_alarm_state,
    bool:bpr_loaded
};

static MySQL:g_BPR_MySQL = MySQL:1;
static g_BprJsonBuf[BPR_JSON_BUF_SIZE];
static g_BprItemsBuf[BPR_JSON_BUF_SIZE];
static g_BprAlarmsBuf[256];
static g_BpUserRewards[MOD_MAX_PLAYERS][MAX_REWARDS_PER_USER][E_BPR_USER_REWARD];
static g_BpUserRewardsCount[MOD_MAX_PLAYERS];
static g_BpRewardsFilter[MOD_MAX_PLAYERS];
static g_BpRewardsOffset[MOD_MAX_PLAYERS];

forward ShowPlayerGUI(playerid, guiid, Node:json);
forward OnPacketIncoming(playerid, guiid, Node:json);
forward HidePlayerGUI(playerid, guiid);
forward UpdatePlayerDatabaseInt(playerid, const field_name[], value);
forward GetPlayerAccountID(playerid);
forward Inventory_GetFreeSlot(playerid);
forward Inventory_AddItemToSlot(playerid, item_id, slot, count, const plate[] = "");
forward bool:Inventory_AddItem(playerid, item_id, count);
forward bool:Inventory_AddSkinItems(playerid, skinModel, amount);
forward Cases_GiveCase(playerid, caseId, amount);
forward Cases_AddBC(playerid, amount);
forward Cases_AddDust(playerid, amount);
forward bool:Cases_GetNameByRewardData(rewardType, internalId, count, dest[], size);
forward Donate_FindInternalIdByModel(modelId);
forward Donate_SetVehicleSlots(playerid, slots);
forward Vehicle_GetOwnedCount(playerid);

forward BPR_OnUserRewardsLoaded(playerid);
forward BPR_OnRewardSaved(playerid, const name[], type, image_id, skin_model_id, rarity, quantity, days_left, spray_price);
forward BPR_OnPlateSaved(playerid, const name[], plate_type, rarity, days_left, const plate_text[]);

stock BPR_Init(MySQL:handle)
{
    g_BPR_MySQL = handle;
    BPR_CreateUserTable();
    printf("[BPR] Initialized");
    return 1;
}

stock BPR_CreateUserTable()
{
    mysql_tquery(g_BPR_MySQL,
        "CREATE TABLE IF NOT EXISTS `bpr_user_rewards` ( \
         `id` INT AUTO_INCREMENT PRIMARY KEY, \
         `user_id` INT NOT NULL, \
         `reward_type` INT NOT NULL, \
         `image_id` INT DEFAULT 0, \
         `skin_model_id` INT DEFAULT -1, \
         `name` VARCHAR(128) NOT NULL, \
         `rarity` INT DEFAULT 1, \
         `quantity` INT DEFAULT 1, \
         `days_left` INT DEFAULT 30, \
         `spray_price` INT DEFAULT 0, \
         `plate_text_0` VARCHAR(16) DEFAULT '', \
         `plate_text_1` VARCHAR(16) DEFAULT '', \
         `plate_text_2` VARCHAR(16) DEFAULT '', \
         `plate_text_3` VARCHAR(16) DEFAULT '', \
         `plate_count` INT DEFAULT 0, \
         `received_date` INT NOT NULL, \
         `expire_date` INT NOT NULL, \
         `is_taken` TINYINT DEFAULT 0, \
         `alarm_state` TINYINT DEFAULT 1, \
         INDEX(`user_id`), \
         INDEX(`is_taken`) \
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;"
    );
    return 1;
}

stock BPR_ResetPlayer(playerid)
{
    g_BpUserRewardsCount[playerid] = 0;
    g_BpRewardsFilter[playerid] = BPR_FILTER_ALL;
    g_BpRewardsOffset[playerid] = 0;

    for(new i = 0; i < MAX_REWARDS_PER_USER; i++)
    {
        g_BpUserRewards[playerid][i][bpr_loaded] = false;
        g_BpUserRewards[playerid][i][bpr_is_taken] = 0;
        g_BpUserRewards[playerid][i][bpr_alarm_state] = 0;
    }
    return 1;
}

stock BPR_LoadUserRewards(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    BPR_ResetPlayer(playerid);

    new query[256];
    mysql_format(g_BPR_MySQL, query, sizeof(query),
        "SELECT * FROM bpr_user_rewards WHERE user_id = %d AND is_taken = 0 ORDER BY received_date DESC LIMIT %d",
        account_id, MAX_REWARDS_PER_USER);
    mysql_tquery(g_BPR_MySQL, query, "BPR_OnUserRewardsLoaded", "d", playerid);
    return 1;
}

public BPR_OnUserRewardsLoaded(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields);

    if(rows <= 0) return 1;
    if(rows > MAX_REWARDS_PER_USER) rows = MAX_REWARDS_PER_USER;

    g_BpUserRewardsCount[playerid] = rows;

    for(new i = 0; i < rows; i++)
    {
        g_BpUserRewards[playerid][i][bpr_user_reward_id] = cache_get_field_content_int(i, "id", g_BPR_MySQL);
        g_BpUserRewards[playerid][i][bpr_user_id] = cache_get_field_content_int(i, "user_id", g_BPR_MySQL);
        g_BpUserRewards[playerid][i][bpr_reward_type] = cache_get_field_content_int(i, "reward_type", g_BPR_MySQL);
        g_BpUserRewards[playerid][i][bpr_reward_image_id] = cache_get_field_content_int(i, "image_id", g_BPR_MySQL);
        g_BpUserRewards[playerid][i][bpr_reward_skin_model_id] = cache_get_field_content_int(i, "skin_model_id", g_BPR_MySQL);
        cache_get_field_content(i, "name", g_BpUserRewards[playerid][i][bpr_reward_name], g_BPR_MySQL, MAX_BPR_ITEM_NAME);
        g_BpUserRewards[playerid][i][bpr_reward_rarity] = cache_get_field_content_int(i, "rarity", g_BPR_MySQL);
        g_BpUserRewards[playerid][i][bpr_reward_quantity] = cache_get_field_content_int(i, "quantity", g_BPR_MySQL);
        g_BpUserRewards[playerid][i][bpr_reward_days_left] = cache_get_field_content_int(i, "days_left", g_BPR_MySQL);
        g_BpUserRewards[playerid][i][bpr_reward_spray_price] = cache_get_field_content_int(i, "spray_price", g_BPR_MySQL);
        g_BpUserRewards[playerid][i][bpr_reward_plate_count] = cache_get_field_content_int(i, "plate_count", g_BPR_MySQL);
        g_BpUserRewards[playerid][i][bpr_received_date] = cache_get_field_content_int(i, "received_date", g_BPR_MySQL);
        g_BpUserRewards[playerid][i][bpr_expire_date] = cache_get_field_content_int(i, "expire_date", g_BPR_MySQL);
        g_BpUserRewards[playerid][i][bpr_is_taken] = cache_get_field_content_int(i, "is_taken", g_BPR_MySQL);
        g_BpUserRewards[playerid][i][bpr_alarm_state] = cache_get_field_content_int(i, "alarm_state", g_BPR_MySQL);

        cache_get_field_content(i, "plate_text_0", g_BpUserRewards[playerid][i][bpr_reward_plate_text_0], g_BPR_MySQL, MAX_BPR_PLATE_TEXT_LEN);
        cache_get_field_content(i, "plate_text_1", g_BpUserRewards[playerid][i][bpr_reward_plate_text_1], g_BPR_MySQL, MAX_BPR_PLATE_TEXT_LEN);
        cache_get_field_content(i, "plate_text_2", g_BpUserRewards[playerid][i][bpr_reward_plate_text_2], g_BPR_MySQL, MAX_BPR_PLATE_TEXT_LEN);
        cache_get_field_content(i, "plate_text_3", g_BpUserRewards[playerid][i][bpr_reward_plate_text_3], g_BPR_MySQL, MAX_BPR_PLATE_TEXT_LEN);

        g_BpUserRewards[playerid][i][bpr_loaded] = true;
    }
    return 1;
}

stock BPR_GiveReward(playerid, type, image_id, const name[], rarity = 1, quantity = 1, days_left = 30, spray_price = 0, skin_model_id = -1)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;
    if(g_BpUserRewardsCount[playerid] >= MAX_REWARDS_PER_USER) return 0;

    new current_time = gettime();
    new expire_time = current_time + (days_left * 86400);

    new query[1024];
    mysql_format(g_BPR_MySQL, query, sizeof(query),
        "INSERT INTO bpr_user_rewards \
        (user_id, reward_type, image_id, skin_model_id, name, rarity, quantity, days_left, spray_price, \
         plate_text_0, plate_text_1, plate_text_2, plate_text_3, plate_count, received_date, expire_date, is_taken, alarm_state) \
        VALUES (%d, %d, %d, %d, '%e', %d, %d, %d, %d, '', '', '', '', 0, %d, %d, 0, 1)",
        account_id, type, image_id, skin_model_id, name, rarity, quantity, days_left, spray_price,
        current_time, expire_time);

    mysql_tquery(g_BPR_MySQL, query, "BPR_OnRewardSaved", "dsiiiiiii",
        playerid, name, type, image_id, skin_model_id, rarity, quantity, days_left, spray_price);
    return 1;
}

public BPR_OnRewardSaved(playerid, const name[], type, image_id, skin_model_id, rarity, quantity, days_left, spray_price)
{
    new reward_id = cache_insert_id();
    if(reward_id <= 0) return 0;

    new idx = g_BpUserRewardsCount[playerid];
    if(idx >= MAX_REWARDS_PER_USER) return 0;

    new account_id = GetPlayerAccountID(playerid);
    new current_time = gettime();
    new expire_time = current_time + (days_left * 86400);

    g_BpUserRewards[playerid][idx][bpr_user_reward_id] = reward_id;
    g_BpUserRewards[playerid][idx][bpr_user_id] = account_id;
    g_BpUserRewards[playerid][idx][bpr_reward_type] = type;
    g_BpUserRewards[playerid][idx][bpr_reward_image_id] = image_id;
    g_BpUserRewards[playerid][idx][bpr_reward_skin_model_id] = skin_model_id;
    g_BpUserRewards[playerid][idx][bpr_reward_rarity] = rarity;
    g_BpUserRewards[playerid][idx][bpr_reward_quantity] = quantity;
    g_BpUserRewards[playerid][idx][bpr_reward_days_left] = days_left;
    g_BpUserRewards[playerid][idx][bpr_reward_spray_price] = spray_price;
    g_BpUserRewards[playerid][idx][bpr_reward_plate_count] = 0;
    g_BpUserRewards[playerid][idx][bpr_received_date] = current_time;
    g_BpUserRewards[playerid][idx][bpr_expire_date] = expire_time;
    g_BpUserRewards[playerid][idx][bpr_is_taken] = 0;
    g_BpUserRewards[playerid][idx][bpr_alarm_state] = ITEM_ALARM_NEW;
    g_BpUserRewards[playerid][idx][bpr_loaded] = true;

    format(g_BpUserRewards[playerid][idx][bpr_reward_name], MAX_BPR_ITEM_NAME, "%s", name);
    g_BpUserRewards[playerid][idx][bpr_reward_plate_text_0][0] = '\0';
    g_BpUserRewards[playerid][idx][bpr_reward_plate_text_1][0] = '\0';
    g_BpUserRewards[playerid][idx][bpr_reward_plate_text_2][0] = '\0';
    g_BpUserRewards[playerid][idx][bpr_reward_plate_text_3][0] = '\0';

    g_BpUserRewardsCount[playerid]++;

    if(g_BpRewardsFilter[playerid] >= BPR_FILTER_MIN)
    {
        BPR_RefreshPlayerGUI(playerid);
    }
    return 1;
}

stock BPR_GiveCar(playerid, image_id, const name[], rarity = 3, days_left = 365, spray_price = 0)
{
    return BPR_GiveReward(playerid, BPR_TYPE_CAR, image_id, name, rarity, 1, days_left, spray_price, -1);
}

stock BPR_GiveAccessory(playerid, image_id, skin_model_id, const name[], rarity = 2, days_left = 365, spray_price = 0)
{
    return BPR_GiveReward(playerid, BPR_TYPE_INVENTORY, image_id, name, rarity, 1, days_left, spray_price, skin_model_id);
}

stock BPR_GiveSkin(playerid, skin_model_id, const name[], rarity = 3, days_left = 365, spray_price = 0)
{
    return BPR_GiveReward(playerid, BPR_TYPE_INVENTORY, BPR_SKIN_EL, name, rarity, 1, days_left, spray_price, skin_model_id);
}

stock BPR_GiveVIP(playerid, days_left = 30, rarity = 4)
{
    return BPR_GiveReward(playerid, BPR_TYPE_VIP, 0, "VIP", rarity, 1, days_left, 0, -1);
}

stock BPR_GiveCase(playerid, image_id, const name[], rarity = 2, quantity = 1)
{
    return BPR_GiveReward(playerid, BPR_TYPE_CASES, image_id, name, rarity, quantity, 0, 0, -1);
}

stock BPR_GiveCurrency(playerid, type_id, image_id, const name[], quantity, days_left = 0)
{
    return BPR_GiveReward(playerid, type_id, image_id, name, 1, quantity, days_left, 0, -1);
}

stock BPR_GivePlate(playerid, plate_type, const plate_text[], const name[] = "Plate", rarity = 2, days_left = 365)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;
    if(g_BpUserRewardsCount[playerid] >= MAX_REWARDS_PER_USER) return 0;

    new current_time = gettime();
    new expire_time = current_time + (days_left * 86400);

    new query[1024];
    mysql_format(g_BPR_MySQL, query, sizeof(query),
        "INSERT INTO bpr_user_rewards \
        (user_id, reward_type, image_id, skin_model_id, name, rarity, quantity, days_left, spray_price, \
         plate_text_0, plate_text_1, plate_text_2, plate_text_3, plate_count, received_date, expire_date, is_taken, alarm_state) \
        VALUES (%d, %d, %d, -1, '%e', %d, 1, %d, 0, '%e', '', '', '', 1, %d, %d, 0, 1)",
        account_id, BPR_TYPE_INVENTORY, plate_type, name, rarity, days_left, plate_text, current_time, expire_time);

    mysql_tquery(g_BPR_MySQL, query, "BPR_OnPlateSaved", "dsiiis", playerid, name, plate_type, rarity, days_left, plate_text);
    return 1;
}

public BPR_OnPlateSaved(playerid, const name[], plate_type, rarity, days_left, const plate_text[])
{
    new reward_id = cache_insert_id();
    if(reward_id <= 0) return 0;

    new idx = g_BpUserRewardsCount[playerid];
    if(idx >= MAX_REWARDS_PER_USER) return 0;

    new account_id = GetPlayerAccountID(playerid);
    new current_time = gettime();
    new expire_time = current_time + (days_left * 86400);

    g_BpUserRewards[playerid][idx][bpr_user_reward_id] = reward_id;
    g_BpUserRewards[playerid][idx][bpr_user_id] = account_id;
    g_BpUserRewards[playerid][idx][bpr_reward_type] = BPR_TYPE_INVENTORY;
    g_BpUserRewards[playerid][idx][bpr_reward_image_id] = plate_type;
    g_BpUserRewards[playerid][idx][bpr_reward_skin_model_id] = -1;
    g_BpUserRewards[playerid][idx][bpr_reward_rarity] = rarity;
    g_BpUserRewards[playerid][idx][bpr_reward_quantity] = 1;
    g_BpUserRewards[playerid][idx][bpr_reward_days_left] = days_left;
    g_BpUserRewards[playerid][idx][bpr_reward_spray_price] = 0;
    g_BpUserRewards[playerid][idx][bpr_reward_plate_count] = 1;
    g_BpUserRewards[playerid][idx][bpr_received_date] = current_time;
    g_BpUserRewards[playerid][idx][bpr_expire_date] = expire_time;
    g_BpUserRewards[playerid][idx][bpr_is_taken] = 0;
    g_BpUserRewards[playerid][idx][bpr_alarm_state] = ITEM_ALARM_NEW;
    g_BpUserRewards[playerid][idx][bpr_loaded] = true;

    format(g_BpUserRewards[playerid][idx][bpr_reward_name], MAX_BPR_ITEM_NAME, "%s", name);
    format(g_BpUserRewards[playerid][idx][bpr_reward_plate_text_0], MAX_BPR_PLATE_TEXT_LEN, "%s", plate_text);
    g_BpUserRewards[playerid][idx][bpr_reward_plate_text_1][0] = '\0';
    g_BpUserRewards[playerid][idx][bpr_reward_plate_text_2][0] = '\0';
    g_BpUserRewards[playerid][idx][bpr_reward_plate_text_3][0] = '\0';

    g_BpUserRewardsCount[playerid]++;

    if(g_BpRewardsFilter[playerid] >= BPR_FILTER_MIN)
    {
        BPR_RefreshPlayerGUI(playerid);
    }
    return 1;
}

stock BPR_MarkTaken(playerid, rewardIndex)
{
    g_BpUserRewards[playerid][rewardIndex][bpr_is_taken] = 1;
    g_BpUserRewards[playerid][rewardIndex][bpr_alarm_state] = 0;
    return 1;
}

stock BPR_SetTakenInDB(playerid, user_reward_id)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new query[192];
    mysql_format(g_BPR_MySQL, query, sizeof(query),
        "UPDATE bpr_user_rewards SET is_taken = 1, alarm_state = 0 WHERE id = %d AND user_id = %d",
        user_reward_id, account_id);
    mysql_tquery(g_BPR_MySQL, query, "", "");
    return 1;
}

stock BPR_SendTakeResult(playerid, user_reward_id, clickType)
{
    new Node:response = JSON_Object();
    JSON_SetInt(response, BPR_KEY_T, 4);
    JSON_SetInt(response, BPR_KEY_ID, user_reward_id);
    JSON_SetInt(response, BPR_KEY_CLICK_TYPE, clickType);
    BPR_AppendAlarmsToJSON(response, playerid);
    OnPacketIncoming(playerid, GUI_BP_REWARDS, response);
    JSON_Cleanup(response);
    return 1;
}

stock BPR_TakeReward(playerid, user_reward_id)
{
    for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
    {
        if(g_BpUserRewards[playerid][i][bpr_user_reward_id] != user_reward_id) continue;
        if(g_BpUserRewards[playerid][i][bpr_is_taken] != 0) return 0;

        new type = g_BpUserRewards[playerid][i][bpr_reward_type];
        new image_id = g_BpUserRewards[playerid][i][bpr_reward_image_id];
        new skin_model = g_BpUserRewards[playerid][i][bpr_reward_skin_model_id];
        new quantity = g_BpUserRewards[playerid][i][bpr_reward_quantity];
        if(quantity <= 0) quantity = 1;

        if(type == BPR_TYPE_INVENTORY)
        {
            if(image_id == BPR_SKIN_EL)
            {
                if(skin_model <= 0 || !Inventory_AddSkinItems(playerid, skin_model, quantity))
                {
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Inventory full", "");
                    return 0;
                }
            }
            else if(image_id == BPR_PLATE_RU || image_id == BPR_PLATE_UA || image_id == BPR_PLATE_BY || image_id == BPR_PLATE_KZ)
            {
                for(new p = 0; p < quantity; p++)
                {
                    new freeSlot = Inventory_GetFreeSlot(playerid);
                    if(freeSlot == -1 || !Inventory_AddItemToSlot(playerid, image_id, freeSlot, 1, g_BpUserRewards[playerid][i][bpr_reward_plate_text_0]))
                    {
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Inventory full", "");
                        return 0;
                    }
                }
            }
            else
            {
                if(!Inventory_AddItem(playerid, image_id, quantity))
                {
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Inventory full", "");
                    return 0;
                }
            }
        }
        else if(type == BPR_TYPE_CAR)
        {
            if(pInfo[playerid][pVehicleSlots] < 2)
                pInfo[playerid][pVehicleSlots] = 2;

            while(Vehicle_GetOwnedCount(playerid) >= pInfo[playerid][pVehicleSlots] && pInfo[playerid][pVehicleSlots] < MAX_PLAYER_VEHICLES)
            {
                Donate_SetVehicleSlots(playerid, pInfo[playerid][pVehicleSlots] + 1);
            }

            if((skin_model > 0 ? skin_model : image_id) <= 0 || !Vehicle_GiveToPlayer(playerid, (skin_model > 0 ? skin_model : image_id), 1, 1))
            {
                ShowNotificationNew(playerid, 2, 6, 0, 0, "No free car slot", "");
                return 0;
            }
        }
        else if(type == BPR_TYPE_VIP)
        {
            new vipLevel = image_id;
            if(vipLevel < VIP_SILVER || vipLevel > VIP_PLATINUM)
                vipLevel = VIP_PLATINUM;

            new vipDays = g_BpUserRewards[playerid][i][bpr_reward_days_left];
            if(vipDays <= 0) vipDays = 1;

            if(!VIP_Give(playerid, vipLevel, vipDays))
                return 0;

            new vipName[24], vipMsg[96];
            VIP_GetName(vipLevel, vipName, sizeof(vipName));
            format(vipMsg, sizeof(vipMsg), "%s àêòèâèðîâàí íà %d ä.", vipName, vipDays);
            ShowNotificationNew(playerid, 1, 6, 0, 0, vipMsg, "");
        }
        else if(type == BPR_TYPE_CASES)
        {
            if(!Cases_GiveCase(playerid, image_id, quantity))
            {
                SendClientMessage(playerid, 0xFF0000FF, "Failed to add case");
                return 0;
            }
            SendClientMessage(playerid, -1, "Case added");
        }
        else if(type == BPR_TYPE_EXP)
        {
            PayDay_AddExp(playerid, quantity);
        }
        else if(type == BPR_TYPE_MONEY)
        {
            pInfo[playerid][pMoney] += quantity;
            GivePlayerMoney(playerid, quantity);
            UpdatePlayerDatabaseInt(playerid, "Money", pInfo[playerid][pMoney]);
        }
        else if(type == BPR_TYPE_BC)
        {
            Cases_AddBC(playerid, quantity);
        }
        else if(type == BPR_TYPE_BP_EXP)
        {
            SendClientMessage(playerid, -1, "BP EXP added");
        }
        else if(type == BPR_TYPE_DUST)
        {
            Cases_AddDust(playerid, quantity);
        }
        else if(type == BPR_TYPE_EVENT)
        {
            SendClientMessage(playerid, -1, "Event resource added");
        }
        else
        {
            SendClientMessage(playerid, -1, "Reward claimed");
        }

        BPR_SetTakenInDB(playerid, user_reward_id);
        BPR_MarkTaken(playerid, i);
        BPR_SendTakeResult(playerid, user_reward_id, CLICK_TAKE);
        BPR_RefreshPlayerGUI(playerid);
        return 1;
    }
    return 0;
}

stock BPR_SprayReward(playerid, user_reward_id, reward_value)
{
    for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
    {
        if(g_BpUserRewards[playerid][i][bpr_user_reward_id] != user_reward_id) continue;
        if(g_BpUserRewards[playerid][i][bpr_is_taken] != 0) return 0;

        if(reward_value > 0)
        {
            pInfo[playerid][pMoney] += reward_value;
            GivePlayerMoney(playerid, reward_value);
            UpdatePlayerDatabaseInt(playerid, "Money", pInfo[playerid][pMoney]);
        }

        BPR_SetTakenInDB(playerid, user_reward_id);
        BPR_MarkTaken(playerid, i);
        BPR_SendTakeResult(playerid, user_reward_id, CLICK_SPRAY);
        BPR_RefreshPlayerGUI(playerid);
        return 1;
    }
    return 0;
}

stock bool:BPR_GetAccessoryNameByItem(itemId, dest[], size)
{
    for(new i = 0; i < sizeof(accessory); i++)
    {
        if(Accessory_GetInventoryItemId(i) != itemId) continue;
        format(dest, size, "%s", accessory[i][NAME_ACCESSORY]);
        return true;
    }
    return false;
}

stock bool:BPR_IsPlaceholderName(const value[])
{
    if(!strlen(value)) return true;
    if(strfind(value, "ACCESSORY", true) != -1) return true;
    return false;
}

stock BPR_EscapeJsonString(const src[], dest[], size)
{
    if(size <= 0) return 0;

    new d = 0;
    dest[0] = '\0';

    for(new i = 0; src[i] != '\0' && d < size - 1; i++)
    {
        new ch = src[i];
        switch(ch)
        {
            case '\\':
            {
                if(d + 2 >= size) break;
                dest[d++] = '\\';
                dest[d++] = '\\';
            }
            case '\"':
            {
                if(d + 2 >= size) break;
                dest[d++] = '\\';
                dest[d++] = '\"';
            }
            case 13:
            {
                if(d + 2 >= size) break;
                dest[d++] = '\\';
                dest[d++] = 'r';
            }
            case 10:
            {
                if(d + 2 >= size) break;
                dest[d++] = '\\';
                dest[d++] = 'n';
            }
            case 9:
            {
                if(d + 2 >= size) break;
                dest[d++] = '\\';
                dest[d++] = 't';
            }
            default:
            {
                dest[d++] = ch;
            }
        }
    }

    dest[d] = '\0';
    return 1;
}

stock BPR_AppendItemJson(playerid, rewardIndex, dest[], destSize)
{
    new plate_count = g_BpUserRewards[playerid][rewardIndex][bpr_reward_plate_count];
    new plate_str[96] = "";
    new reward_type = g_BpUserRewards[playerid][rewardIndex][bpr_reward_type];
    new image_id = g_BpUserRewards[playerid][rewardIndex][bpr_reward_image_id];
    new skin_model = g_BpUserRewards[playerid][rewardIndex][bpr_reward_skin_model_id];
    new client_image_id = image_id;
    new client_name[MAX_BPR_ITEM_NAME];
    format(client_name, sizeof(client_name), "%s", g_BpUserRewards[playerid][rewardIndex][bpr_reward_name]);

    if(reward_type == BPR_TYPE_CAR)
    {
        new carModel = (skin_model > 0 ? skin_model : image_id);
        client_image_id = carModel;

        // For custom vehicles, try donate internal icon id first.
        if(carModel > 611)
        {
            new donateInternalId = Donate_FindInternalIdByModel(carModel);
            if(donateInternalId > 0)
                client_image_id = donateInternalId;
        }
    }

    if(reward_type == BPR_TYPE_MONEY || reward_type == BPR_TYPE_BC)
    {
        if(client_image_id <= 0)
            client_image_id = 1;
    }
    else if((reward_type >= BPR_TYPE_EXP && reward_type <= BPR_TYPE_BC) || reward_type == BPR_TYPE_BP_EXP || reward_type == BPR_TYPE_DUST || reward_type == BPR_TYPE_EVENT)
    {
        if(client_image_id <= 0)
            client_image_id = reward_type;
    }

    if(reward_type == BPR_TYPE_INVENTORY && image_id != BPR_SKIN_EL && BPR_IsPlaceholderName(client_name))
    {
        if(!BPR_GetAccessoryNameByItem(image_id, client_name, sizeof(client_name)))
            format(client_name, sizeof(client_name), "ÐÐºÑÐµÑÑÑƒÐ°Ñ€ #%d", image_id);
    }

    if(reward_type == BPR_TYPE_INVENTORY && image_id == BPR_SKIN_EL && strfind(client_name, "SKIN #", true) == 0)
    {
        if(!Cases_GetNameByRewardData(BPR_TYPE_INVENTORY, BPR_SKIN_EL, (skin_model > 0 ? skin_model : 0), client_name, sizeof(client_name)))
        {
            format(client_name, sizeof(client_name), "Ð¡ÐºÐ¸Ð½ #%d", (skin_model > 0 ? skin_model : 0));
        }
    }

    if(reward_type == BPR_TYPE_INVENTORY && image_id == BPR_SKIN_EL && strfind(client_name, "Ð¡ÐºÐ¸Ð½ #", true) == 0)
    {
        if(!Cases_GetNameByRewardData(BPR_TYPE_INVENTORY, BPR_SKIN_EL, (skin_model > 0 ? skin_model : 0), client_name, sizeof(client_name)))
        {
            format(client_name, sizeof(client_name), "Ð¡ÐºÐ¸Ð½ #%d", (skin_model > 0 ? skin_model : 0));
        }
    }

    if(reward_type == BPR_TYPE_CAR && (strfind(client_name, "#", true) != -1 || !strlen(client_name)))
    {
        Cases_GetNameByRewardData(BPR_TYPE_CAR, (skin_model > 0 ? skin_model : image_id), 0, client_name, sizeof(client_name));
    }

    new escaped_name[MAX_BPR_ITEM_NAME * 2];
    BPR_EscapeJsonString(client_name, escaped_name, sizeof(escaped_name));

    if(plate_count > 0)
    {
        new escaped_plate[MAX_BPR_PLATE_TEXT_LEN * 2];
        BPR_EscapeJsonString(g_BpUserRewards[playerid][rewardIndex][bpr_reward_plate_text_0], escaped_plate, sizeof(escaped_plate));
        format(plate_str, sizeof(plate_str), ",\"els\":[\"%s\"]", escaped_plate);
    }
    else
    {
        format(plate_str, sizeof(plate_str), ",\"els\":[]");
    }

    new tmp[420];
    format(tmp, sizeof(tmp),
        "{\"id\":%d,\"n\":\"%s\",\"td\":%d,\"st\":%d,\"el\":%d,\"c\":%d,\"ds\":%d,\"sp\":%d,\"r\":%d,\"ct\":%d%s}",
        g_BpUserRewards[playerid][rewardIndex][bpr_user_reward_id],
        escaped_name,
        reward_type,
        g_BpUserRewards[playerid][rewardIndex][bpr_alarm_state],
        client_image_id,
        skin_model,
        g_BpUserRewards[playerid][rewardIndex][bpr_reward_days_left],
        g_BpUserRewards[playerid][rewardIndex][bpr_reward_spray_price],
        g_BpUserRewards[playerid][rewardIndex][bpr_reward_rarity],
        g_BpUserRewards[playerid][rewardIndex][bpr_reward_quantity],
        plate_str
    );

    strcat(dest, tmp, destSize);
    return 1;
}

stock bool:BPR_ItemMatchesFilter(playerid, rewardIndex, filterState)
{
    if(filterState == BPR_FILTER_ALL) return true;

    new type = g_BpUserRewards[playerid][rewardIndex][bpr_reward_type];
    new image_id = g_BpUserRewards[playerid][rewardIndex][bpr_reward_image_id];

    switch(filterState)
    {
        case BPR_FILTER_SKINS: return (type == BPR_TYPE_INVENTORY && image_id == BPR_SKIN_EL);
        case BPR_FILTER_VIP: return (type == BPR_TYPE_VIP);
        case BPR_FILTER_ACCESSORIES: return (type == BPR_TYPE_INVENTORY && image_id != BPR_SKIN_EL);
        case BPR_FILTER_CARS: return (type == BPR_TYPE_CAR);
        case BPR_FILTER_CURRENCIES: return (type >= 1 && type <= 3) || type == 7 || type == 10 || type == 18 || type == 19 || type == 21 || type == 23;
        case BPR_FILTER_OTHER:
        {
            return (type != BPR_TYPE_CAR && type != BPR_TYPE_VIP && type != BPR_TYPE_INVENTORY && !((type >= 1 && type <= 3) || type == 7 || type == 10 || type == 18 || type == 19 || type == 21 || type == 23));
        }
    }

    return false;
}

stock BPR_BuildItemsArray(playerid, filterState, startIndex, limit, &added)
{
    g_BprItemsBuf[0] = '\0';
    strcat(g_BprItemsBuf, "[", sizeof(g_BprItemsBuf));

    added = 0;
    new skipped = 0;

    for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
    {
        if(g_BpUserRewards[playerid][i][bpr_is_taken] != 0) continue;
        if(!BPR_ItemMatchesFilter(playerid, i, filterState)) continue;

        if(skipped < startIndex)
        {
            skipped++;
            continue;
        }

        if(added > 0) strcat(g_BprItemsBuf, ",", sizeof(g_BprItemsBuf));
        BPR_AppendItemJson(playerid, i, g_BprItemsBuf, sizeof(g_BprItemsBuf));

        added++;
        if(added >= limit) break;
    }

    strcat(g_BprItemsBuf, "]", sizeof(g_BprItemsBuf));
    return 1;
}

stock BPR_BuildAlarmsArray(playerid)
{
    g_BprAlarmsBuf[0] = '\0';
    strcat(g_BprAlarmsBuf, "[", sizeof(g_BprAlarmsBuf));

    for(new filterState = BPR_FILTER_MIN; filterState <= BPR_FILTER_MAX; filterState++)
    {
        new alarmCount = 0;

        for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
        {
            if(g_BpUserRewards[playerid][i][bpr_is_taken] != 0) continue;
            if(BPR_ItemMatchesFilter(playerid, i, filterState) && g_BpUserRewards[playerid][i][bpr_alarm_state] > 0)
            {
                alarmCount++;
            }
        }

        if(filterState > BPR_FILTER_MIN) strcat(g_BprAlarmsBuf, ",", sizeof(g_BprAlarmsBuf));

        new tmp[16];
        format(tmp, sizeof(tmp), "%d", alarmCount);
        strcat(g_BprAlarmsBuf, tmp, sizeof(g_BprAlarmsBuf));
    }

    strcat(g_BprAlarmsBuf, "]", sizeof(g_BprAlarmsBuf));
    return 1;
}

stock BPR_AppendAlarmsToJSON(Node:obj, playerid)
{
    JSON_SetArray(obj, BPR_KEY_ALARMS, JSON_Array());

    for(new filterState = BPR_FILTER_MIN; filterState <= BPR_FILTER_MAX; filterState++)
    {
        new alarmCount = 0;

        for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
        {
            if(g_BpUserRewards[playerid][i][bpr_is_taken] != 0) continue;
            if(BPR_ItemMatchesFilter(playerid, i, filterState) && g_BpUserRewards[playerid][i][bpr_alarm_state] > 0)
            {
                alarmCount++;
            }
        }

        JSON_ArrayAppend(obj, BPR_KEY_ALARMS, JSON_Int(alarmCount));
    }

    return 1;
}

stock BPR_SendOpen(playerid)
{
    new added;
    BPR_BuildItemsArray(playerid, g_BpRewardsFilter[playerid], g_BpRewardsOffset[playerid], BPR_PAGE_SIZE, added);
    g_BpRewardsOffset[playerid] += added;
    BPR_BuildAlarmsArray(playerid);

    format(g_BprJsonBuf, sizeof(g_BprJsonBuf),
        "{\"o\":1,\"t\":0,\"tn\":0,\"pr\":%s,\"fl\":%s}",
        g_BprItemsBuf,
        g_BprAlarmsBuf
    );

    new Node:obj = JSON_Object();
    JSON_Parse(g_BprJsonBuf, obj);
    ShowPlayerGUI(playerid, GUI_BP_REWARDS, obj);
    JSON_Cleanup(obj);
    return 1;
}

stock BPR_SendUpdate(playerid, t, bool:appendFlag = false)
{
    if(appendFlag)
    {
        format(g_BprJsonBuf, sizeof(g_BprJsonBuf),
            "{\"t\":%d,\"tn\":0,\"pr\":%s,\"fl\":%s,\"s\":-1}",
            t, g_BprItemsBuf, g_BprAlarmsBuf
        );
    }
    else
    {
        format(g_BprJsonBuf, sizeof(g_BprJsonBuf),
            "{\"t\":%d,\"tn\":0,\"pr\":%s,\"fl\":%s}",
            t, g_BprItemsBuf, g_BprAlarmsBuf
        );
    }

    new Node:obj = JSON_Object();
    JSON_Parse(g_BprJsonBuf, obj);
    OnPacketIncoming(playerid, GUI_BP_REWARDS, obj);
    JSON_Cleanup(obj);
    return 1;
}

stock BPR_RefreshPlayerGUI(playerid)
{
    new filterState = g_BpRewardsFilter[playerid];
    if(filterState < BPR_FILTER_MIN || filterState > BPR_FILTER_MAX) filterState = BPR_FILTER_ALL;

    new added;
    BPR_BuildItemsArray(playerid, filterState, 0, BPR_PAGE_SIZE, added);
    BPR_BuildAlarmsArray(playerid);
    BPR_SendUpdate(playerid, 1);
    return 1;
}

stock BPR_Open(playerid)
{
    g_BpRewardsFilter[playerid] = BPR_FILTER_ALL;
    g_BpRewardsOffset[playerid] = 0;
    return BPR_SendOpen(playerid);
}

stock BPR_SendFilterUpdate(playerid, filterState)
{
    if(filterState < BPR_FILTER_MIN || filterState > BPR_FILTER_MAX) filterState = BPR_FILTER_ALL;

    g_BpRewardsFilter[playerid] = filterState;
    g_BpRewardsOffset[playerid] = 0;

    new added;
    BPR_BuildItemsArray(playerid, filterState, 0, BPR_PAGE_SIZE, added);
    g_BpRewardsOffset[playerid] = added;
    BPR_BuildAlarmsArray(playerid);

    BPR_SendUpdate(playerid, 1);
    return 1;
}

stock BPR_SendNextPage(playerid)
{
    new filterState = g_BpRewardsFilter[playerid];
    new startIndex = g_BpRewardsOffset[playerid];

    new added;
    BPR_BuildItemsArray(playerid, filterState, startIndex, BPR_PAGE_SIZE, added);
    BPR_BuildAlarmsArray(playerid);

    if(added == 0)
    {
        BPR_SendUpdate(playerid, 2, true);
        return 1;
    }

    g_BpRewardsOffset[playerid] += added;
    BPR_SendUpdate(playerid, 2);
    return 1;
}

stock BPR_OnPacket(playerid, Node:JSONObject)
{
    new closeValue;
    JSON_GetInt(JSONObject, BPR_KEY_CLOSE, closeValue);
    if(closeValue == 1)
    {
        HidePlayerGUI(playerid, GUI_BP_REWARDS);
        return 1;
    }

    new t;
    JSON_GetInt(JSONObject, BPR_KEY_T, t);

    switch(t)
    {
        case 1:
        {
            new filterState = BPR_FILTER_ALL;
            JSON_GetInt(JSONObject, BPR_KEY_ALARMS, filterState);
            return BPR_SendFilterUpdate(playerid, filterState);
        }
        case 2:
        {
            return BPR_SendNextPage(playerid);
        }
        case 4:
        {
            new itemId, clickType;
            JSON_GetInt(JSONObject, BPR_KEY_ID, itemId);
            JSON_GetInt(JSONObject, BPR_KEY_CLICK_TYPE, clickType);

            if(clickType == CLICK_TAKE)
            {
                return BPR_TakeReward(playerid, itemId);
            }

            if(clickType == CLICK_SPRAY)
            {
                new sprayPrice;
                JSON_GetInt(JSONObject, BPR_KEY_SPRAY, sprayPrice);
                return BPR_SprayReward(playerid, itemId, sprayPrice);
            }
        }
    }

    return 1;
}

CMD:reward(playerid, params[])
{
    #pragma unused params
    BPR_Open(playerid);
    return 1;
}

CMD:loadrewards(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, -1, "Usage: /loadrewards [playerid]"), 1;

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Player not connected"), 1;

    BPR_LoadUserRewards(targetid);
    return 1;
}

CMD:givereward(playerid, params[])
{
    new to_player, type, image_id, name[64], rarity, quantity, days_left, spray_price, skin_model_id;
    if(sscanf(params, "idds[64]ddddd", to_player, type, image_id, name, rarity, quantity, days_left, spray_price, skin_model_id))
        return SendClientMessage(playerid, -1, "Usage: /givereward [id] [type] [image] [name] [rarity] [qty] [days] [spray] [skin]"), 1;

    BPR_GiveReward(to_player, type, image_id, name, rarity, quantity, days_left, spray_price, skin_model_id);
    return 1;
}




