#if defined _bp_rewards_included
    #endinput
#endif
#define _bp_rewards_included

#include "../include/a_mysql.inc"
#include <json>

// === НАСТРОЙКИ ОПТИМИЗАЦИИ ===
#define MAX_REWARDS_PER_USER    20
#define MAX_BPR_ITEM_NAME       64
#define BPR_JSON_BUF_SIZE       4096
#define MAX_BPR_AWARD_TYPES     32
#define MAX_BPR_AWARD_NAME      64
#define MAX_BPR_PLATE_TEXT_LEN  8

#define REWARD_TYPE_SKIN        1
#define REWARD_TYPE_VIP         2
#define REWARD_TYPE_ACCESSORY   3
#define REWARD_TYPE_CAR         4
#define REWARD_TYPE_CURRENCY    5
#define REWARD_TYPE_OTHER       6

#define ITEM_ALARM_NONE         0
#define ITEM_ALARM_NEW          1

#define CLICK_TAKE              1
#define CLICK_ITEM              2
#define CLICK_SPRAY             3

#define ITEMS_PER_PAGE          9
#define GUI_BP_REWARDS          74

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
#define BPR_TAKE_COOLDOWN 5
#define BPR_FILTER_MIN          (1)
#define BPR_FILTER_MAX          (7)

#define BPR_TYPE_CASES      (4)
#define BPR_TYPE_CAR        (5)
#define BPR_TYPE_VIP        (9)
#define BPR_TYPE_INVENTORY  (11)

#define BPR_PLATE_RU    (59)
#define BPR_PLATE_UA    (81)
#define BPR_PLATE_BY    (82)
#define BPR_PLATE_KZ    (83)
#define BPR_SKIN_EL     (134)

#define BPR_PAGE_SIZE (12)
#define MAX_BPR_PLATE_TEXT      (4)
#define MAX_BPR_AWARD_IMAGES    (8)
#define MAX_BPR_AWARD_IMAGE_NAME (32)

// === ОПТИМИЗИРОВАННЫЙ ENUM (packed) ===
enum E_BPR_AWARD_TYPE 
{
    bpr_award_id,
    bpr_award_name[32],
    bpr_award_image_count
}

enum E_BPR_USER_REWARD
{
    bpr_user_reward_id,
    bpr_user_id,
    bpr_reward_type,
    bpr_reward_image_id,
    bpr_reward_skin_model_id,
    bpr_reward_name[48],
    bpr_reward_rarity,
    bpr_reward_quantity,
    bpr_reward_days_left,
    bpr_reward_spray_price,
    bpr_reward_plate_text_0[8],
    bpr_reward_plate_text_1[8],
    bpr_reward_plate_text_2[8],
    bpr_reward_plate_text_3[8],
    bpr_reward_plate_count,
    bpr_received_date,
    bpr_expire_date,
    bpr_is_taken,
    bpr_alarm_state,
    bool:bpr_loaded
}

static MySQL:mysql = MySQL:1;
static g_BpAwards[MAX_BPR_AWARD_TYPES][E_BPR_AWARD_TYPE];
static g_BpAwardsCount;
static g_BpAwardImages[MAX_BPR_AWARD_TYPES][MAX_BPR_AWARD_IMAGES][MAX_BPR_AWARD_IMAGE_NAME];
static g_BpRewardsJsonBuf[BPR_JSON_BUF_SIZE];
static g_BpRewardsItemsBuf[BPR_JSON_BUF_SIZE];
static g_BpRewardsAlarmsBuf[256];
static g_BpUserRewards[MAX_PLAYERS][MAX_REWARDS_PER_USER][E_BPR_USER_REWARD];
static g_BpUserRewardsCount[MAX_PLAYERS];
static g_BpRewardsFilter[MAX_PLAYERS];
static g_BpRewardsOffset[MAX_PLAYERS];

static const g_BpAwardsDefaultId[] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31};

static const g_BpAwardsDefaultName[31][] = {
    "Skin","Currency","Black Coins","Case","Transport","Set","Tokens",
    "X2 Coupon","VIP","Season Points","Inventory","Weapon","Sabre",
    "Ticket","Slot","Licenses","Medical","E-Points","Coupon","Discount",
    "Spray","Law","Stars","Sound","Category B","Avatar","Frame","Theme",
    "Ticket","Weapon","Ammo"
};

static const g_BpAwardsDefaultImageCount[] = {1,1,1,19,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};

forward SendPacketToClientString(playerid, guiid, const data[]);
forward HidePlayerGUI(playerid, guiid);

// === ОСНОВНЫЕ ФУНКЦИИ ===
stock BPR_Init(MySQL:handle)
{
    mysql = handle;
    printf("[BPR] Initializing BP Rewards system...");
    BPR_CreateUserTable();
    BPR_LoadAwardTypes();
    printf("[BPR] BP Rewards system initialized");
    return 1;
}

stock BPR_CreateUserTable()
{
    mysql_tquery(mysql,
        "CREATE TABLE IF NOT EXISTS `bpr_user_rewards` ( \
         `id` INT AUTO_INCREMENT PRIMARY KEY, \
         `user_id` INT NOT NULL, \
         `reward_type` INT NOT NULL, \
         `image_id` INT DEFAULT 0, \
         `skin_model_id` INT DEFAULT -1, \
         `name` VARCHAR(64) NOT NULL, \
         `rarity` INT DEFAULT 1, \
         `quantity` INT DEFAULT 1, \
         `days_left` INT DEFAULT 30, \
         `spray_price` INT DEFAULT 0, \
         `plate_text_0` VARCHAR(8) DEFAULT '', \
         `plate_text_1` VARCHAR(8) DEFAULT '', \
         `plate_text_2` VARCHAR(8) DEFAULT '', \
         `plate_text_3` VARCHAR(8) DEFAULT '', \
         `plate_count` INT DEFAULT 0, \
         `received_date` INT NOT NULL, \
         `expire_date` INT NOT NULL, \
         `is_taken` TINYINT DEFAULT 0, \
         `alarm_state` TINYINT DEFAULT 1, \
         INDEX(`user_id`), \
         INDEX(`is_taken`) \
        ) ENGINE=InnoDB DEFAULT CHARSET=cp1251;"
    );
    printf("[BPR] User rewards table created/checked");
    return 1;
}

stock BPR_LoadAwardTypes()
{
    g_BpAwardsCount = 0;
    
    new Node:root;
    if (JSON_ParseFile("awards.json", root) == 0)
    {
        if (JSON_ParseFile("../awards.json", root) == 0)
        {
            printf("[BPR] awards.json not found, using defaults");
            BPR_InitDefaults();
            return 1;
        }
    }
    
    new Node:types;
    JSON_GetArray(root, "awardsTypes", types);
    
    new len;
    JSON_ArrayLength(types, len);
    
    if (len <= 0)
    {
        JSON_Cleanup(root);
        printf("[BPR] awards.json empty, using defaults");
        BPR_InitDefaults();
        return 1;
    }
    
    for (new i = 0; i < len && g_BpAwardsCount < MAX_BPR_AWARD_TYPES; i++)
    {
        new Node:item;
        JSON_ArrayObject(types, i, item);
        
        new awardId;
        JSON_GetInt(item, "id", awardId);
        
        new awardName[MAX_BPR_AWARD_NAME];
        JSON_GetString(item, "name", awardName, sizeof(awardName));
        
        g_BpAwards[g_BpAwardsCount][bpr_award_id] = awardId;
        format(g_BpAwards[g_BpAwardsCount][bpr_award_name], 32, "%s", awardName);
        
        new Node:images;
        JSON_GetArray(item, "image", images);
        
        new imgLen;
        JSON_ArrayLength(images, imgLen);
        if (imgLen > MAX_BPR_AWARD_IMAGES) imgLen = MAX_BPR_AWARD_IMAGES;
        g_BpAwards[g_BpAwardsCount][bpr_award_image_count] = imgLen;
        
        for (new j = 0; j < imgLen; j++)
        {
            new Node:imgNode;
            JSON_ArrayObject(images, j, imgNode);
            JSON_GetNodeString(imgNode, g_BpAwardImages[g_BpAwardsCount][j], MAX_BPR_AWARD_IMAGE_NAME);
        }
        
        g_BpAwardsCount++;
    }
    
    JSON_Cleanup(root);
    printf("[BPR] Loaded %d award types from JSON", g_BpAwardsCount);
    return 1;
}

stock BPR_InitDefaults()
{
    g_BpAwardsCount = 0;
    for (new i = 0; i < sizeof(g_BpAwardsDefaultId) && g_BpAwardsCount < MAX_BPR_AWARD_TYPES; i++)
    {
        g_BpAwards[g_BpAwardsCount][bpr_award_id] = g_BpAwardsDefaultId[i];
        format(g_BpAwards[g_BpAwardsCount][bpr_award_name], 32, "%s", g_BpAwardsDefaultName[i]);
        g_BpAwards[g_BpAwardsCount][bpr_award_image_count] = g_BpAwardsDefaultImageCount[i];
        g_BpAwardsCount++;
    }
    printf("[BPR] Initialized %d default award types", g_BpAwardsCount);
    return 1;
}

stock BPR_LoadUserRewards(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id)
    {
        printf("[BPR] Error: Cannot get account ID for player %d", playerid);
        return 0;
    }
    
    printf("[BPR] Loading rewards for player %d (account: %d)", playerid, account_id);
    
    g_BpUserRewardsCount[playerid] = 0;
    for(new i = 0; i < MAX_REWARDS_PER_USER; i++)
    {
        g_BpUserRewards[playerid][i][bpr_loaded] = false;
    }
    
    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "SELECT * FROM bpr_user_rewards WHERE user_id = %d AND is_taken = 0 ORDER BY received_date DESC LIMIT %d",
        account_id, MAX_REWARDS_PER_USER
    );
    
    mysql_tquery(mysql, query, "BPR_OnUserRewardsLoaded", "d", playerid);
    return 1;
}

forward BPR_OnUserRewardsLoaded(playerid);
public BPR_OnUserRewardsLoaded(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields);
    
    if(rows == 0)
    {
        printf("[BPR] No saved rewards for player %d", playerid);
        return;
    }
    
    g_BpUserRewardsCount[playerid] = rows;
    
    for(new i = 0; i < rows; i++)
    {
        g_BpUserRewards[playerid][i][bpr_user_reward_id] = cache_get_field_content_int(i, "id");
        g_BpUserRewards[playerid][i][bpr_user_id] = cache_get_field_content_int(i, "user_id");
        g_BpUserRewards[playerid][i][bpr_reward_type] = cache_get_field_content_int(i, "reward_type");
        g_BpUserRewards[playerid][i][bpr_reward_image_id] = cache_get_field_content_int(i, "image_id");
        g_BpUserRewards[playerid][i][bpr_reward_skin_model_id] = cache_get_field_content_int(i, "skin_model_id");
        cache_get_field_content(i, "name", g_BpUserRewards[playerid][i][bpr_reward_name], mysql, 48);
        g_BpUserRewards[playerid][i][bpr_reward_rarity] = cache_get_field_content_int(i, "rarity");
        g_BpUserRewards[playerid][i][bpr_reward_quantity] = cache_get_field_content_int(i, "quantity");
        g_BpUserRewards[playerid][i][bpr_reward_days_left] = cache_get_field_content_int(i, "days_left");
        g_BpUserRewards[playerid][i][bpr_reward_spray_price] = cache_get_field_content_int(i, "spray_price");
        g_BpUserRewards[playerid][i][bpr_reward_plate_count] = cache_get_field_content_int(i, "plate_count");
        g_BpUserRewards[playerid][i][bpr_received_date] = cache_get_field_content_int(i, "received_date");
        g_BpUserRewards[playerid][i][bpr_expire_date] = cache_get_field_content_int(i, "expire_date");
        g_BpUserRewards[playerid][i][bpr_is_taken] = cache_get_field_content_int(i, "is_taken");
        g_BpUserRewards[playerid][i][bpr_alarm_state] = cache_get_field_content_int(i, "alarm_state");
        
        cache_get_field_content(i, "plate_text_0", g_BpUserRewards[playerid][i][bpr_reward_plate_text_0], mysql, 8);
        cache_get_field_content(i, "plate_text_1", g_BpUserRewards[playerid][i][bpr_reward_plate_text_1], mysql, 8);
        cache_get_field_content(i, "plate_text_2", g_BpUserRewards[playerid][i][bpr_reward_plate_text_2], mysql, 8);
        cache_get_field_content(i, "plate_text_3", g_BpUserRewards[playerid][i][bpr_reward_plate_text_3], mysql, 8);
        
        g_BpUserRewards[playerid][i][bpr_loaded] = true;
        
        printf("[BPR] Loaded reward for player %d: ID=%d, Type=%d, Name=%s", 
            playerid,
            g_BpUserRewards[playerid][i][bpr_user_reward_id],
            g_BpUserRewards[playerid][i][bpr_reward_type],
            g_BpUserRewards[playerid][i][bpr_reward_name]);
    }
    
    printf("[BPR] Loaded %d rewards for player %d", rows, playerid);
}

stock BPR_GiveReward(playerid, type, image_id, const name[], rarity = 1, quantity = 1, days_left = 30, spray_price = 0, skin_model_id = -1)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id)
    {
        printf("[BPR] Error: Cannot get account ID for player %d", playerid);
        return 0;
    }
    
    if(g_BpUserRewardsCount[playerid] >= MAX_REWARDS_PER_USER)
    {
        printf("[BPR] Player %d has reached max rewards", playerid);
        return 0;
    }
    
    new current_time = gettime();
    new expire_time = current_time + (days_left * 86400);
    
    new query[512];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO bpr_user_rewards \
        (user_id, reward_type, image_id, skin_model_id, name, rarity, quantity, days_left, spray_price, \
         received_date, expire_date, is_taken, alarm_state) \
        VALUES (%d, %d, %d, %d, '%e', %d, %d, %d, %d, %d, %d, 0, 1)",
        account_id, type, image_id, skin_model_id, name, rarity, quantity, days_left, spray_price,
        current_time, expire_time
    );
    
    mysql_tquery(mysql, query, "BPR_OnRewardSaved", "dsiiiiiii", 
        playerid, name, type, image_id, skin_model_id, rarity, quantity, days_left, spray_price);
    
    return 1;
}

forward BPR_OnRewardSaved(playerid, const name[], type, image_id, skin_model_id, rarity, quantity, days_left, spray_price);
public BPR_OnRewardSaved(playerid, const name[], type, image_id, skin_model_id, rarity, quantity, days_left, spray_price)
{
    new reward_id = cache_insert_id();
    new account_id = GetPlayerAccountID(playerid);
    new current_time = gettime();
    new expire_time = current_time + (days_left * 86400);
    
    new idx = g_BpUserRewardsCount[playerid];
    
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
    
    format(g_BpUserRewards[playerid][idx][bpr_reward_name], 48, "%s", name);
    
    g_BpUserRewardsCount[playerid]++;
    
    printf("[BPR] Reward saved and added to array for player %d: [DB ID=%d] %s", playerid, reward_id, name);
    if(g_BpRewardsFilter[playerid] >= BPR_FILTER_MIN)
    {
        BPR_RefreshPlayerGUI(playerid);
    }
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

stock BPR_GiveCase(playerid, image_id, const name[], rarity = 2, quantity = 1)
{
    return BPR_GiveReward(playerid, BPR_TYPE_CASES, image_id, name, rarity, quantity, 0, 0, -1);
}

stock BPR_GiveCurrency(playerid, type_id, const name[], quantity, days_left = 0)
{
    new image_id = 1;

    switch(type_id)
    {
        case 1: image_id = 1;   // EXP texture
        case 2: image_id = 1;   // Money texture
        case 3: image_id = 1;   // BC texture
        case 10: image_id = 1;  // Battle Pass EXP texture
        case 21: image_id = 1;  // Dust/Spray texture
        case 23: image_id = 1;  // Event resource texture
        default: image_id = 1;
    }

    return BPR_GiveReward(playerid, type_id, image_id, name, 1, quantity, days_left, 0, -1);
}

stock BPR_GivePlate(playerid, plate_type, const plate_text[], const name[] = "Number plate", rarity = 2, days_left = 365)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id) return 0;
    
    if(g_BpUserRewardsCount[playerid] >= MAX_REWARDS_PER_USER)
        return 0;
    
    new current_time = gettime();
    new expire_time = current_time + (days_left * 86400);
    
    new query[512];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO bpr_user_rewards \
        (user_id, reward_type, image_id, skin_model_id, name, rarity, quantity, days_left, spray_price, \
         plate_text_0, plate_count, received_date, expire_date, is_taken, alarm_state) \
        VALUES (%d, %d, %d, %d, '%e', %d, 1, %d, 0, '%e', 1, %d, %d, 0, 1)",
        account_id, BPR_TYPE_INVENTORY, plate_type, -1, name, rarity, days_left, plate_text, current_time, expire_time
    );
    
    mysql_tquery(mysql, query, "BPR_OnPlateSaved", "ddsii", playerid, name, plate_type, rarity, days_left);
    
    return 1;
}

forward BPR_OnPlateSaved(playerid, const name[], plate_type, rarity, days_left);
public BPR_OnPlateSaved(playerid, const name[], plate_type, rarity, days_left)
{
    new reward_id = cache_insert_id();
    new account_id = GetPlayerAccountID(playerid);
    new current_time = gettime();
    new expire_time = current_time + (days_left * 86400);
    
    new idx = g_BpUserRewardsCount[playerid];
    
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
    
    format(g_BpUserRewards[playerid][idx][bpr_reward_name], 48, "%s", name);
    format(g_BpUserRewards[playerid][idx][bpr_reward_plate_text_0], 8, "Plate");
    
    g_BpUserRewardsCount[playerid]++;
    
    printf("[BPR] Plate saved and added to array for player %d: [DB ID=%d]", playerid, reward_id);
    
    if(g_BpRewardsFilter[playerid] >= BPR_FILTER_MIN)
        BPR_RefreshPlayerGUI(playerid);
}



stock BPR_Notify(playerid, type, text[], subtext[] = "")
{
    ShowNotificationSile(playerid, type, 7, -1, -1, text, subtext);
    return 1;
}


stock BPR_NotifyName(playerid, type, text[], const name[])
{
    new notifyText[128];
    format(notifyText, sizeof(notifyText), "%s: %s", text, name);
    ShowNotificationSile(playerid, type, 7, -1, -1, notifyText, "");
    return 1;
}

stock BPR_GetStoredRewardName(playerid, idx, dest[], destSize)
{
    format(dest, destSize, "%s", g_BpUserRewards[playerid][idx][bpr_reward_name]);
    if(strlen(dest) <= 0)
        format(dest, destSize, "Награда");
    return 1;
}

stock BPR_GiveStoredRewardToPlayer(playerid, type, image_id, skin_model, quantity, const name[])
{
    if(quantity <= 0) quantity = 1;

    switch(type)
    {
        case BPR_TYPE_INVENTORY:
        {
            new freeSlot = Inventory_GetFreeSlot(playerid);
            if(freeSlot == -1)
            {
                BPR_Notify(playerid, 2, "Нет свободных слотов в инвентаре", "");
                return 0;
            }

            if(image_id == BPR_SKIN_EL)
            {
                Inventory_AddItem(playerid, BPR_SKIN_EL, freeSlot, skin_model, name);
                SaveInventoryItem(playerid, freeSlot);
                BPR_NotifyName(playerid, 3, "Вы получили скин", name);
                return 1;
            }

            Inventory_AddItem(playerid, image_id, freeSlot, quantity, name);
            SaveInventoryItem(playerid, freeSlot);
            BPR_NotifyName(playerid, 3, "Вы получили предмет", name);
            return 1;
        }
        case BPR_TYPE_CASES:
        {
            AddPlayerCaseCountByType(playerid, image_id, quantity);
            BPR_NotifyName(playerid, 3, "Вы получили кейс", name);
            return 1;
        }
        case BPR_TYPE_CAR:
        {
            if(image_id == -1) return 0;

            new vehicleName[32];
            GetVehicleModelName(image_id, vehicleName, sizeof(vehicleName));

            new free_car_id = GetFreeOwnableCarID();
            new Float: pos_x = 2498.205810;
            new Float: pos_y = -742.256042;
            new Float: pos_z = 12.164166;
            new Float: angle = 356.240051;
            new color = 1;

            SetOwnableCarData(free_car_id, OC_OWNER_ID, GetPlayerAccountID(playerid));
            SetOwnableCarData(free_car_id, OC_MODEL_ID, image_id);
            SetOwnableCarData(free_car_id, OC_COLOR_1, color);
            SetOwnableCarData(free_car_id, OC_COLOR_2, 0);
            SetOwnableCarData(free_car_id, OC_POS_X, pos_x);
            SetOwnableCarData(free_car_id, OC_POS_Y, pos_y);
            SetOwnableCarData(free_car_id, OC_POS_Z, pos_z);
            SetOwnableCarData(free_car_id, OC_ANGLE, angle);
            strmid(g_ownable_car[free_car_id][OC_NUMBER], "", 0, 8, 8);
            SetOwnableCarData(free_car_id, OC_ALARM, false);
            SetOwnableCarData(free_car_id, OC_KEY_IN, false);
            SetOwnableCarData(free_car_id, OC_CREATE, gettime());
            format(g_ownable_car[free_car_id][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));

            new database_query[256];
            format(database_query, sizeof database_query, "INSERT INTO ownable_cars (owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) VALUES ('%d','%d','%d','%d','%f','%f','%f','%f','%d')", GetPlayerAccountID(playerid), image_id, color, 0, pos_x, pos_y, pos_z, angle, gettime());
            mysql_query(mysql, database_query, true);

            BPR_NotifyName(playerid, 3, "Вы получили машину", vehicleName);
            return 1;
        }
        case BPR_TYPE_VIP:
        {
            BPR_NotifyName(playerid, 3, "Вы получили VIP", name);
            return 1;
        }
    }

    switch(type)
    {
        case 1:
        {
            SetPlayerData(playerid, P_EXP, GetPlayerData(playerid, P_EXP) + quantity);
            UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
            BPR_NotifyName(playerid, 3, "Вы получили опыт", name);
            return 1;
        }
        case 2:
        {
            GivePlayerMoneyEx(playerid, quantity);
            BPR_NotifyName(playerid, 3, "Вы получили деньги", name);
            return 1;
        }
        case 3:
        {
            GivePlayerDonateRub(playerid, quantity, "Reward", true, true);
            BPR_NotifyName(playerid, 3, "Вы получили BC", name);
            return 1;
        }
        case 10:
        {
            BPR_NotifyName(playerid, 3, "Вы получили опыт Battle Pass", name);
            return 1;
        }
        case 21:
        {
            pCasesDust[playerid] += quantity;
            Cases_CheckDustReward(playerid);
            Cases_SavePlayer(playerid);
            BPR_NotifyName(playerid, 3, "Вы получили пыль", name);
            return 1;
        }
        default:
        {
            BPR_NotifyName(playerid, 3, "Вы получили награду", name);
            return 1;
        }
    }
}

stock BPR_TakeReward(playerid, user_reward_id)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id) return 0;

    if(GetPVarInt(playerid, "bpr_take_wait") > gettime())
    {
        BPR_Notify(playerid, 2, "Подождите 5 секунд", "");
        return 1;
    }

    for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
    {
        if(g_BpUserRewards[playerid][i][bpr_user_reward_id] == user_reward_id && g_BpUserRewards[playerid][i][bpr_is_taken] == 0)
        {
            new type = g_BpUserRewards[playerid][i][bpr_reward_type];
            new image_id = g_BpUserRewards[playerid][i][bpr_reward_image_id];
            new skin_model = g_BpUserRewards[playerid][i][bpr_reward_skin_model_id];
            new quantity = g_BpUserRewards[playerid][i][bpr_reward_quantity];
            new name[48];
            format(name, sizeof(name), "%s", g_BpUserRewards[playerid][i][bpr_reward_name]);

            if(!BPR_GiveStoredRewardToPlayer(playerid, type, image_id, skin_model, quantity, name))
                return 1;

            SetPVarInt(playerid, "bpr_take_wait", gettime() + BPR_TAKE_COOLDOWN);

            new query[256];
            mysql_format(mysql, query, sizeof(query),
                "UPDATE bpr_user_rewards SET is_taken = 1, alarm_state = 0 WHERE id = %d AND user_id = %d",
                user_reward_id, account_id
            );
            mysql_tquery(mysql, query, "", "");

            g_BpUserRewards[playerid][i][bpr_is_taken] = 1;
            g_BpUserRewards[playerid][i][bpr_alarm_state] = 0;

            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 4);
            JSON_SetInt(response, "id", user_reward_id);
            JSON_SetInt(response, "s", 1);
            BPR_AppendAlarmsToJSON(response, playerid);
            SendPacketToClient(playerid, GUI_BP_REWARDS, response);
            JSON_Cleanup(response, true);

            BPR_RefreshPlayerGUI(playerid);
            return 1;
        }
    }
    return 0;
}

stock BPR_SprayReward(playerid, user_reward_id, reward_value)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id) return 0;

    for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
    {
        if(g_BpUserRewards[playerid][i][bpr_user_reward_id] == user_reward_id && g_BpUserRewards[playerid][i][bpr_is_taken] == 0)
        {
            if(reward_value <= 0)
                reward_value = g_BpUserRewards[playerid][i][bpr_reward_spray_price];

            if(reward_value <= 0)
                reward_value = 1;

            pCasesDust[playerid] += reward_value;
            Cases_CheckDustReward(playerid);
            Cases_SavePlayer(playerid);

            new query[256];
            mysql_format(mysql, query, sizeof(query),
                "UPDATE bpr_user_rewards SET is_taken = 1, alarm_state = 0 WHERE id = %d AND user_id = %d",
                user_reward_id, account_id
            );
            mysql_tquery(mysql, query, "", "");

            g_BpUserRewards[playerid][i][bpr_is_taken] = 1;
            g_BpUserRewards[playerid][i][bpr_alarm_state] = 0;

            new msg[96];
            format(msg, sizeof(msg), "Получено пыли: %d", reward_value);
            BPR_Notify(playerid, 3, msg, "");

            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 4);
            JSON_SetInt(response, "id", user_reward_id);
            JSON_SetInt(response, "s", 3);
            BPR_AppendAlarmsToJSON(response, playerid);
            SendPacketToClient(playerid, GUI_BP_REWARDS, response);
            JSON_Cleanup(response, true);

            BPR_RefreshPlayerGUI(playerid);
            return 1;
        }
    }
    return 0;
}

stock BPR_BuildItemsArray(playerid, filterState, startIndex, limit, &added)
{
    g_BpRewardsItemsBuf[0] = '\0';
    strcat(g_BpRewardsItemsBuf, "[", sizeof(g_BpRewardsItemsBuf));
    
    added = 0;
    new skipped = 0;
    
    for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
    {
        if(g_BpUserRewards[playerid][i][bpr_is_taken] != 0)
            continue;
        
        if(!BPR_ItemMatchesFilter(playerid, i, filterState))
            continue;
        
        if(skipped < startIndex)
        {
            skipped++;
            continue;
        }
        
        if(added > 0)
            strcat(g_BpRewardsItemsBuf, ",", sizeof(g_BpRewardsItemsBuf));
        
        BPR_AppendItemJson(playerid, i, g_BpRewardsItemsBuf, sizeof(g_BpRewardsItemsBuf));
        
        added++;
        if(added >= limit)
            break;
    }
    
    strcat(g_BpRewardsItemsBuf, "]", sizeof(g_BpRewardsItemsBuf));
    return 1;
}

stock BPR_BuildAlarmsArray(playerid)
{
    g_BpRewardsAlarmsBuf[0] = '\0';
    strcat(g_BpRewardsAlarmsBuf, "[", sizeof(g_BpRewardsAlarmsBuf));
    
    for(new filterState = BPR_FILTER_MIN; filterState <= BPR_FILTER_MAX; filterState++)
    {
        new alarmCount = 0;
        
        for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
        {
            if(g_BpUserRewards[playerid][i][bpr_is_taken] != 0)
                continue;
            
            if(BPR_ItemMatchesFilter(playerid, i, filterState) &&
               g_BpUserRewards[playerid][i][bpr_alarm_state] > 0)
            {
                alarmCount++;
            }
        }
        
        if(filterState > BPR_FILTER_MIN)
            strcat(g_BpRewardsAlarmsBuf, ",", sizeof(g_BpRewardsAlarmsBuf));
        
        new tmp[16];
        format(tmp, sizeof(tmp), "%d", alarmCount);
        strcat(g_BpRewardsAlarmsBuf, tmp, sizeof(g_BpRewardsAlarmsBuf));
    }
    
    strcat(g_BpRewardsAlarmsBuf, "]", sizeof(g_BpRewardsAlarmsBuf));
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
            if(g_BpUserRewards[playerid][i][bpr_is_taken] != 0)
                continue;
            
            if(BPR_ItemMatchesFilter(playerid, i, filterState) &&
               g_BpUserRewards[playerid][i][bpr_alarm_state] > 0)
            {
                alarmCount++;
            }
        }
        
        JSON_ArrayAppend(obj, BPR_KEY_ALARMS, JSON_Int(alarmCount));
    }
}


stock BPR_GetRewardVisual(type, image_id, &displayType, &displayImage)
{
    displayType = type;
    displayImage = image_id;

    if(displayImage <= 0)
        displayImage = 1;

    switch(type)
    {
        case 1: // exp
        {
            displayType = 10; // Season Points / EXP visual group
            displayImage = 1;
        }
        case 2: // money
        {
            displayType = 2; // Currency texture
            displayImage = 1;
        }
        case 3: // BC
        {
            displayType = 3; // Black Coins texture
            displayImage = 1;
        }
        case 4: // cases
        {
            displayType = 4;
            if(image_id <= 0) displayImage = 1;
            else displayImage = image_id;
        }
        case 5: // vehicle
        {
            displayType = 5;
            if(image_id > 0) displayImage = image_id;
            else displayImage = 411;
        }
        case 9: // VIP
        {
            displayType = 9;
            if(image_id <= 0) displayImage = 1;
        }
        case 10: // BP EXP
        {
            displayType = 10;
            displayImage = 1;
        }
        case 11: // inventory/accessory
        {
            displayType = 11;
            if(image_id <= 0) displayImage = 1;
            else displayImage = image_id;
        }
        case 21: // dust / spray
        {
            displayType = 21;
            displayImage = 1;
        }
        case 23: // event resource / e-points
        {
            displayType = 18;
            displayImage = 1;
        }
    }
    return 1;
}

stock BPR_AppendItemJson(playerid, rewardIndex, dest[], destSize)
{
    new type = g_BpUserRewards[playerid][rewardIndex][bpr_reward_type];
    new image_id = g_BpUserRewards[playerid][rewardIndex][bpr_reward_image_id];
    new skin_model = g_BpUserRewards[playerid][rewardIndex][bpr_reward_skin_model_id];
    new displayType, displayImage;
    BPR_GetRewardVisual(type, image_id, displayType, displayImage);
    new alarm = g_BpUserRewards[playerid][rewardIndex][bpr_alarm_state];
    new id = g_BpUserRewards[playerid][rewardIndex][bpr_user_reward_id];
    new name[64];
    format(name, sizeof(name), "%s", g_BpUserRewards[playerid][rewardIndex][bpr_reward_name]);
    
    new plate_count = g_BpUserRewards[playerid][rewardIndex][bpr_reward_plate_count];
    new plate_str[64] = "";
    
    if(plate_count > 0)
    {
        strcat(plate_str, ",\"els\":[");
        for(new p = 0; p < plate_count; p++)
        {
            if(p > 0) strcat(plate_str, ",");
            strcat(plate_str, "\"");
            
            switch(p)
            {
                case 0: strcat(plate_str, g_BpUserRewards[playerid][rewardIndex][bpr_reward_plate_text_0]);
                case 1: strcat(plate_str, g_BpUserRewards[playerid][rewardIndex][bpr_reward_plate_text_1]);
                case 2: strcat(plate_str, g_BpUserRewards[playerid][rewardIndex][bpr_reward_plate_text_2]);
                case 3: strcat(plate_str, g_BpUserRewards[playerid][rewardIndex][bpr_reward_plate_text_3]);
            }
            
            strcat(plate_str, "\"");
        }
        strcat(plate_str, "]");
    }
    else
    {
        strcat(plate_str, ",\"els\":[]");
    }
    
    new tmp[256];
    format(tmp, sizeof(tmp),
        "{\"id\":%d,\"n\":\"%s\",\"td\":%d,\"st\":%d,\"el\":%d,\"c\":%d,\"ds\":%d,\"sp\":%d,\"r\":%d,\"ct\":%d%s}",
        id, name, displayType, alarm, displayImage, skin_model,
        g_BpUserRewards[playerid][rewardIndex][bpr_reward_days_left],
        g_BpUserRewards[playerid][rewardIndex][bpr_reward_spray_price],
        g_BpUserRewards[playerid][rewardIndex][bpr_reward_rarity],
        g_BpUserRewards[playerid][rewardIndex][bpr_reward_quantity],
        plate_str
    );
    
    strcat(dest, tmp, destSize);
}

stock BPR_JSONToString(Node:obj)
{
    JSON_Stringify(obj, g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf));
    return g_BpRewardsJsonBuf;
}

stock BPR_RefreshPlayerGUI(playerid)
{
    new filterState = g_BpRewardsFilter[playerid];
    if(filterState < BPR_FILTER_MIN || filterState > BPR_FILTER_MAX)
        filterState = BPR_FILTER_ALL;
    
    new added;
    BPR_BuildItemsArray(playerid, filterState, 0, BPR_PAGE_SIZE, added);
    BPR_BuildAlarmsArray(playerid);
    
    format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
        "{\"t\":1,\"tn\":0,\"pr\":%s,\"fl\":%s}",
        g_BpRewardsItemsBuf,
        g_BpRewardsAlarmsBuf
    );
    
    SendPacketToClientString(playerid, GUI_BP_REWARDS, g_BpRewardsJsonBuf);
    return 1;
}

stock bool:BPR_ItemMatchesFilter(playerid, rewardIndex, filterState)
{
    if(filterState == BPR_FILTER_ALL)
        return true;
    
    new type = g_BpUserRewards[playerid][rewardIndex][bpr_reward_type];
    new image_id = g_BpUserRewards[playerid][rewardIndex][bpr_reward_image_id];
    
    switch(filterState)
    {
        case BPR_FILTER_SKINS:
            return (type == BPR_TYPE_INVENTORY && image_id == BPR_SKIN_EL);
        case BPR_FILTER_VIP:
            return (type == BPR_TYPE_VIP);
        case BPR_FILTER_ACCESSORIES:
            return (type == BPR_TYPE_INVENTORY && image_id != BPR_SKIN_EL);
        case BPR_FILTER_CARS:
            return (type == BPR_TYPE_CAR);
        case BPR_FILTER_CURRENCIES:
            return (type >= 1 && type <= 3) || type == 7 || type == 10 || type == 18 || type == 19;
        case BPR_FILTER_OTHER:
            return (type != BPR_TYPE_CAR && type != BPR_TYPE_VIP && type != BPR_TYPE_INVENTORY &&
                    !((type >= 1 && type <= 3) || type == 7 || type == 10 || type == 18 || type == 19));
    }
    return false;
}


stock BPR_SendRewardButtonPulse(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 6);
    JSON_SetInt(json, "s", 1);
    JSON_SetInt(json, "alarm", 1);
    BPR_AppendAlarmsToJSON(json, playerid);
    SendPacketToClient(playerid, GUI_BP_REWARDS, json);
    JSON_Cleanup(json, true);
    return 1;
}

stock BPR_Open(playerid)
{
    printf("[BPR] Open request from player %d", playerid);
    
    g_BpRewardsFilter[playerid] = BPR_FILTER_ALL;
    g_BpRewardsOffset[playerid] = 0;
    
    new added;
    BPR_BuildItemsArray(playerid, g_BpRewardsFilter[playerid], g_BpRewardsOffset[playerid], BPR_PAGE_SIZE, added);
    g_BpRewardsOffset[playerid] += added;
    BPR_BuildAlarmsArray(playerid);
    
    format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
        "{\"o\":1,\"t\":0,\"tn\":0,\"pr\":%s,\"fl\":%s}",
        g_BpRewardsItemsBuf,
        g_BpRewardsAlarmsBuf
    );
    
    SendPacketToClientString(playerid, GUI_BP_REWARDS, g_BpRewardsJsonBuf);
    return 1;
}

stock BPR_SendFilterUpdate(playerid, filterState)
{
    g_BpRewardsFilter[playerid] = filterState;
    g_BpRewardsOffset[playerid] = 0;
    
    new added;
    BPR_BuildItemsArray(playerid, filterState, 0, BPR_PAGE_SIZE, added);
    g_BpRewardsOffset[playerid] = added;
    BPR_BuildAlarmsArray(playerid);
    
    format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
        "{\"t\":1,\"tn\":0,\"pr\":%s,\"fl\":%s}",
        g_BpRewardsItemsBuf,
        g_BpRewardsAlarmsBuf
    );
    
    SendPacketToClientString(playerid, GUI_BP_REWARDS, g_BpRewardsJsonBuf);
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
        format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
            "{\"t\":2,\"tn\":0,\"pr\":%s,\"fl\":%s,\"s\":-1}",
            g_BpRewardsItemsBuf,
            g_BpRewardsAlarmsBuf
        );
    }
    else
    {
        g_BpRewardsOffset[playerid] += added;
        format(g_BpRewardsJsonBuf, sizeof(g_BpRewardsJsonBuf),
            "{\"t\":2,\"tn\":0,\"pr\":%s,\"fl\":%s}",
            g_BpRewardsItemsBuf,
            g_BpRewardsAlarmsBuf
        );
    }
    
    SendPacketToClientString(playerid, GUI_BP_REWARDS, g_BpRewardsJsonBuf);
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
            if(filterState < BPR_FILTER_MIN || filterState > BPR_FILTER_MAX)
                filterState = BPR_FILTER_ALL;
            return BPR_SendFilterUpdate(playerid, filterState);
        }
        case 2:
        {
            return BPR_SendNextPage(playerid);
        }
        case 3:
        {
            return 1;
        }
        case 4:
        {
            new itemId, clickType;
            JSON_GetInt(JSONObject, BPR_KEY_ID, itemId);
            JSON_GetInt(JSONObject, BPR_KEY_CLICK_TYPE, clickType);
            
            if(clickType == CLICK_TAKE)
            {
                BPR_TakeReward(playerid, itemId);
            }
            else if(clickType == CLICK_SPRAY)
            {
                new sprayPrice;
                JSON_GetInt(JSONObject, BPR_KEY_SPRAY, sprayPrice);
                BPR_SprayReward(playerid, itemId, sprayPrice);
            }
            return 1;
        }
        case 5:
        {
            return 1;
        }
    }
    return 1;
}

stock BPR_GetAwardTypeName(awardId, dest[], destSize)
{
    for(new i = 0; i < g_BpAwardsCount; i++)
    {
        if(g_BpAwards[i][bpr_award_id] == awardId)
        {
            format(dest, destSize, "%s", g_BpAwards[i][bpr_award_name]);
            return 1;
        }
    }
    format(dest, destSize, "Reward %d", awardId);
    return 0;
}

// === КОМАНДЫ ===
CMD:reward(playerid, params[])
{
    BPR_Open(playerid);
    return 1;
}


CMD:givereward(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13)
        return SendClientMessage(playerid, -1, "{FFCC00}У Вас нет доступа.");

    new to_player, type, value, count;
    if(sscanf(params, "uddd", to_player, type, value, count))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /givereward [id] [type] [value] [count]");

    if(!IsPlayerConnected(to_player))
        return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");

    new name[64];
    format(name, sizeof(name), "Награда #%d", value);

    switch(type)
    {
        case 1:
        {
            format(name, sizeof(name), "Опыт: %d", count);
            BPR_GiveCurrency(to_player, type, name, count, 0);
        }
        case 2:
        {
            format(name, sizeof(name), "Деньги: %d", count);
            BPR_GiveCurrency(to_player, type, name, count, 0);
        }
        case 3:
        {
            format(name, sizeof(name), "BC: %d", count);
            BPR_GiveCurrency(to_player, type, name, count, 0);
        }
        case 4:
        {
            switch(value)
            {
                case 1: format(name, sizeof(name), "Ежедневный кейс");
                case 2: format(name, sizeof(name), "Кейс бомжа");
                case 3: format(name, sizeof(name), "Стандартный кейс");
                case 4: format(name, sizeof(name), "Авто-кейс");
                case 5: format(name, sizeof(name), "Особый кейс");
                case 6: format(name, sizeof(name), "Драйв кейс");
                default: format(name, sizeof(name), "Кейс #%d", value);
            }
            BPR_GiveCase(to_player, value, name, 2, count);
        }
        case 5:
        {
            GetVehicleModelName(value, name, sizeof(name));
            BPR_GiveCar(to_player, value, name, 3, 365, 500);
        }
        case 9:
        {
            format(name, sizeof(name), "VIP на %d дн.", count);
            BPR_GiveReward(to_player, BPR_TYPE_VIP, value, name, 3, count, count, 0, -1);
        }
        case 10:
        {
            format(name, sizeof(name), "Опыт Battle Pass: %d", count);
            BPR_GiveCurrency(to_player, type, name, count, 0);
        }
        case 11:
        {
            GetItemName(value, name, sizeof(name));
            if(strlen(name) <= 0) format(name, sizeof(name), "Предмет #%d", value);
            if(value >= 19000 && value <= 19999)
            {
                new accName[64];
                format(accName, sizeof(accName), "Аксессуар: %s", name);
                BPR_GiveAccessory(to_player, value, count, accName, 2, 365, 300);
            }
            else
            {
                BPR_GiveAccessory(to_player, value, count, name, 2, 365, 300);
            }
        }
        case 21:
        {
            format(name, sizeof(name), "Пыль: %d", count);
            BPR_GiveCurrency(to_player, type, name, count, 0);
        }
        default:
        {
            BPR_GiveCurrency(to_player, type, name, count, 0);
        }
    }

    BPR_NotifyName(playerid, 3, "Награда выдана в reward", name);
    BPR_NotifyName(to_player, 3, "Вам пришла награда", name);
    return 1;
}

CMD:rgivecar(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, -1, "Usage: /rgivecar [playerid]");
        return 1;
    }
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, -1, "Player not connected");
        return 1;
    }
    BPR_GiveCar(targetid, 2555, "Lada Granta", 2, 365, 500);
    new msg[128];
    format(msg, sizeof(msg), "Car given to player %d", targetid);
    SendClientMessage(playerid, -1, msg);
    return 1;
}

CMD:rgiveskin(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, -1, "Usage: /rgiveskin [playerid]");
        return 1;
    }
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, -1, "Player not connected");
        return 1;
    }
    BPR_GiveSkin(targetid, 6871, "Maslennikov", 3, 365, 500);
    new msg[128];
    format(msg, sizeof(msg), "Skin given to player %d", targetid);
    SendClientMessage(playerid, -1, msg);
    return 1;
}

CMD:rgiveacc(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, -1, "Usage: /rgiveacc [playerid]");
        return 1;
    }
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, -1, "Player not connected");
        return 1;
    }
    BPR_GiveAccessory(targetid, 918, 677, "Soviet Hat", 2, 365, 300);
    new msg[128];
    format(msg, sizeof(msg), "Accessory given to player %d", targetid);
    SendClientMessage(playerid, -1, msg);
    return 1;
}



CMD:rgiveplate(playerid, params[])
{
    new targetid, plate_type;
    new plate_text[16];
    if(sscanf(params, "uis[16]", targetid, plate_type, plate_text))
    {
        SendClientMessage(playerid, -1, "Usage: /rgiveplate [playerid] [type(59/81/82/83)] [text]");
        return 1;
    }
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, -1, "Player not connected");
        return 1;
    }
    if(plate_type != 59 && plate_type != 81 && plate_type != 82 && plate_type != 83)
    {
        SendClientMessage(playerid, -1, "Invalid plate type. Use: 59(RU), 81(UA), 82(BY), 83(KZ)");
        return 1;
    }
    BPR_GivePlate(targetid, plate_type, plate_text, "Number plate", 2, 365);
    new msg[128];
    format(msg, sizeof(msg), "Plate given to player %d", targetid);
    SendClientMessage(playerid, -1, msg);
    return 1;
}

CMD:loadrewards(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, -1, "Usage: /loadrewards [playerid]");
        return 1;
    }
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, -1, "Player not connected");
        return 1;
    }
    BPR_LoadUserRewards(targetid);
    new msg[128];
    format(msg, sizeof(msg), "Loading rewards for player %d from database", targetid);
    SendClientMessage(playerid, -1, msg);
    return 1;
}

CMD:rgivereward(playerid, params[]) 
{
    new to_player, type, image_id, name[64], rarity, quantity, days_left, spray_price, skin_model_id;
    if(sscanf(params, "idds[64]ddddd", to_player, type, image_id, name, rarity, quantity, days_left, spray_price, skin_model_id))
        return SendClientMessage(playerid, -1, "Usage: /rgivereward [player] [type] [image_id] [name] [rarity] [quantity] [days] [spray_price] [skin_model]");
    BPR_GiveReward(to_player, type, image_id, name, rarity, quantity, days_left, spray_price, skin_model_id);
    return 1;
}