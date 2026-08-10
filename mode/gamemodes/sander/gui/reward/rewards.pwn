#if defined _bp_rewards_included
    #endinput
#endif
#define _bp_rewards_included

#include "../include/a_mysql.inc"
#include <json>

// === НАСТРОЙКИ ОПТИМИЗАЦИИ ===
#define MAX_REWARDS_PER_USER    50
#define MAX_BPR_ITEM_NAME       64
#define BPR_JSON_BUF_SIZE       4096
#define MAX_BPR_AWARD_TYPES     32
#define MAX_BPR_AWARD_NAME      64
#define MAX_BPR_PLATE_TEXT_LEN  8

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
#define BPR_FILTER_MIN          (1)
#define BPR_FILTER_MAX          (7)

#define BPR_TYPE_EXP        (1)
#define BPR_TYPE_MONEY      (2)
#define BPR_TYPE_BC         (3)
#define BPR_TYPE_CASES      (4)
#define BPR_TYPE_CAR        (5)
#define BPR_TYPE_VIP        (9)
#define BPR_TYPE_BP_EXP     (10)
#define BPR_TYPE_INVENTORY  (11)
#define BPR_TYPE_DUST       (21)
#define BPR_TYPE_EVENT_RES  (23)

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

static MySQL:g_BPRMySQL = MySQL:1;
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
static g_BpRewardsPending[MAX_PLAYERS];
static bool:g_BpRewardsLoaded[MAX_PLAYERS];

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

stock BPR_ResetPlayer(playerid)
{
    SetPVarInt(playerid, REWARD_GUI_MODE_PVAR, REWARD_GUI_MODE_NONE);
    g_BpUserRewardsCount[playerid] = 0;
    g_BpRewardsFilter[playerid] = 0;
    g_BpRewardsOffset[playerid] = 0;
    g_BpRewardsPending[playerid] = 0;
    g_BpRewardsLoaded[playerid] = false;

    for(new i = 0; i < MAX_REWARDS_PER_USER; i++)
    {
        g_BpUserRewards[playerid][i][bpr_loaded] = false;
        g_BpUserRewards[playerid][i][bpr_is_taken] = 1;
    }
    return 1;
}

stock BPR_IsReady(playerid)
{
    return g_BpRewardsLoaded[playerid];
}

stock BPR_GetActiveCount(playerid)
{
    new count = 0;
    for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
    {
        if(g_BpUserRewards[playerid][i][bpr_loaded] && g_BpUserRewards[playerid][i][bpr_is_taken] == 0)
            count++;
    }
    return count;
}

stock BPR_FindFreeMemorySlot(playerid)
{
    for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
    {
        if(!g_BpUserRewards[playerid][i][bpr_loaded] || g_BpUserRewards[playerid][i][bpr_is_taken] != 0)
            return i;
    }
    if(g_BpUserRewardsCount[playerid] < MAX_REWARDS_PER_USER)
        return g_BpUserRewardsCount[playerid];
    return -1;
}

stock BPR_GetFreeSlots(playerid)
{
    if(!g_BpRewardsLoaded[playerid]) return 0;
    new free_slots = MAX_REWARDS_PER_USER - BPR_GetActiveCount(playerid) - g_BpRewardsPending[playerid];
    if(free_slots < 0) free_slots = 0;
    return free_slots;
}

stock BPR_CanAcceptRewards(playerid, amount)
{
    if(amount <= 0) return 1;
    return BPR_GetFreeSlots(playerid) >= amount;
}

// === ОСНОВНЫЕ ФУНКЦИИ ===
stock BPR_Init(MySQL:handle)
{
    g_BPRMySQL = handle;
    printf("[BPR] Initializing BP Rewards system...");
    BPR_CreateUserTable();
    BPR_LoadAwardTypes();
    printf("[BPR] BP Rewards system initialized");
    return 1;
}

stock BPR_CreateUserTable()
{
    mysql_tquery(g_BPRMySQL,
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
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;"
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

    BPR_ResetPlayer(playerid);
    printf("[BPR] Loading rewards for player %d (account: %d)", playerid, account_id);

    new query[256];
    mysql_format(g_BPRMySQL, query, sizeof(query),
        "SELECT * FROM bpr_user_rewards WHERE user_id = %d AND is_taken = 0 ORDER BY received_date DESC LIMIT %d",
        account_id, MAX_REWARDS_PER_USER
    );

    mysql_tquery(g_BPRMySQL, query, "BPR_OnUserRewardsLoaded", "dd", playerid, account_id);
    return 1;
}

forward BPR_OnUserRewardsLoaded(playerid, expected_account_id);
public BPR_OnUserRewardsLoaded(playerid, expected_account_id)
{
    if(!IsPlayerConnected(playerid) || GetPlayerAccountID(playerid) != expected_account_id)
        return 0;

    new rows, fields;
    cache_get_data(rows, fields);
    if(rows > MAX_REWARDS_PER_USER) rows = MAX_REWARDS_PER_USER;

    g_BpUserRewardsCount[playerid] = rows;

    for(new i = 0; i < rows; i++)
    {
        g_BpUserRewards[playerid][i][bpr_user_reward_id] = cache_get_field_content_int(i, "id");
        g_BpUserRewards[playerid][i][bpr_user_id] = cache_get_field_content_int(i, "user_id");
        g_BpUserRewards[playerid][i][bpr_reward_type] = cache_get_field_content_int(i, "reward_type");
        g_BpUserRewards[playerid][i][bpr_reward_image_id] = cache_get_field_content_int(i, "image_id");
        g_BpUserRewards[playerid][i][bpr_reward_skin_model_id] = cache_get_field_content_int(i, "skin_model_id");
        cache_get_field_content(i, "name", g_BpUserRewards[playerid][i][bpr_reward_name], g_BPRMySQL, 48);
        g_BpUserRewards[playerid][i][bpr_reward_rarity] = cache_get_field_content_int(i, "rarity");
        g_BpUserRewards[playerid][i][bpr_reward_quantity] = cache_get_field_content_int(i, "quantity");
        g_BpUserRewards[playerid][i][bpr_reward_days_left] = cache_get_field_content_int(i, "days_left");
        g_BpUserRewards[playerid][i][bpr_reward_spray_price] = cache_get_field_content_int(i, "spray_price");
        g_BpUserRewards[playerid][i][bpr_reward_plate_count] = cache_get_field_content_int(i, "plate_count");
        g_BpUserRewards[playerid][i][bpr_received_date] = cache_get_field_content_int(i, "received_date");
        g_BpUserRewards[playerid][i][bpr_expire_date] = cache_get_field_content_int(i, "expire_date");
        g_BpUserRewards[playerid][i][bpr_is_taken] = cache_get_field_content_int(i, "is_taken");
        g_BpUserRewards[playerid][i][bpr_alarm_state] = cache_get_field_content_int(i, "alarm_state");

        cache_get_field_content(i, "plate_text_0", g_BpUserRewards[playerid][i][bpr_reward_plate_text_0], g_BPRMySQL, 8);
        cache_get_field_content(i, "plate_text_1", g_BpUserRewards[playerid][i][bpr_reward_plate_text_1], g_BPRMySQL, 8);
        cache_get_field_content(i, "plate_text_2", g_BpUserRewards[playerid][i][bpr_reward_plate_text_2], g_BPRMySQL, 8);
        cache_get_field_content(i, "plate_text_3", g_BpUserRewards[playerid][i][bpr_reward_plate_text_3], g_BPRMySQL, 8);
        g_BpUserRewards[playerid][i][bpr_loaded] = true;
    }

    g_BpRewardsLoaded[playerid] = true;
    printf("[BPR] Loaded %d rewards for player %d", rows, playerid);
    return 1;
}

stock BPR_GiveReward(playerid, type, image_id, const name[], rarity = 1, quantity = 1, days_left = 30, spray_price = 0, skin_model_id = -1)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id || !g_BpRewardsLoaded[playerid])
    {
        printf("[BPR] Reward rejected: player=%d account=%d loaded=%d", playerid, account_id, g_BpRewardsLoaded[playerid]);
        return 0;
    }

    if(!BPR_CanAcceptRewards(playerid, 1))
    {
        ShowNotificationSander(playerid, 2, 7, -1, -1, "Хранилище /reward заполнено", "Заберите или распылите часть наград.");
        return 0;
    }

    if(quantity <= 0) quantity = 1;
    if(rarity < 1) rarity = 1;
    if(days_left < 0) days_left = 0;
    if(spray_price < 0) spray_price = 0;

    new current_time = gettime();
    new expire_time = (days_left > 0) ? current_time + (days_left * 86400) : 0;

    new query[512];
    mysql_format(g_BPRMySQL, query, sizeof(query),
        "INSERT INTO bpr_user_rewards (user_id,reward_type,image_id,skin_model_id,name,rarity,quantity,days_left,spray_price,received_date,expire_date,is_taken,alarm_state) VALUES (%d,%d,%d,%d,'%e',%d,%d,%d,%d,%d,%d,0,1)",
        account_id, type, image_id, skin_model_id, name, rarity, quantity, days_left, spray_price,
        current_time, expire_time
    );

    g_BpRewardsPending[playerid]++;
    mysql_tquery(g_BPRMySQL, query, "BPR_OnRewardSaved", "dsdiiiiiiii",
        playerid, name, account_id, type, image_id, skin_model_id, rarity, quantity, days_left, spray_price, current_time);
    return 1;
}

forward BPR_OnRewardSaved(playerid, const name[], expected_account_id, type, image_id, skin_model_id, rarity, quantity, days_left, spray_price, received_time);
public BPR_OnRewardSaved(playerid, const name[], expected_account_id, type, image_id, skin_model_id, rarity, quantity, days_left, spray_price, received_time)
{
    if(IsPlayerConnected(playerid) && g_BpRewardsPending[playerid] > 0)
        g_BpRewardsPending[playerid]--;

    new reward_id = cache_insert_id();
    if(reward_id <= 0)
    {
        printf("[BPR] Failed to save reward for account=%d name=%s", expected_account_id, name);
        return 0;
    }

    if(!IsPlayerConnected(playerid) || GetPlayerAccountID(playerid) != expected_account_id || !g_BpRewardsLoaded[playerid])
        return 1;

    new idx = BPR_FindFreeMemorySlot(playerid);
    if(idx == -1)
    {
        printf("[BPR] Reward saved in DB but RAM list is full: player=%d reward=%d", playerid, reward_id);
        return 1;
    }

    new bool:append_slot = (idx == g_BpUserRewardsCount[playerid]);
    new expire_time = (days_left > 0) ? received_time + (days_left * 86400) : 0;

    g_BpUserRewards[playerid][idx][bpr_user_reward_id] = reward_id;
    g_BpUserRewards[playerid][idx][bpr_user_id] = expected_account_id;
    g_BpUserRewards[playerid][idx][bpr_reward_type] = type;
    g_BpUserRewards[playerid][idx][bpr_reward_image_id] = image_id;
    g_BpUserRewards[playerid][idx][bpr_reward_skin_model_id] = skin_model_id;
    g_BpUserRewards[playerid][idx][bpr_reward_rarity] = rarity;
    g_BpUserRewards[playerid][idx][bpr_reward_quantity] = quantity;
    g_BpUserRewards[playerid][idx][bpr_reward_days_left] = days_left;
    g_BpUserRewards[playerid][idx][bpr_reward_spray_price] = spray_price;
    g_BpUserRewards[playerid][idx][bpr_reward_plate_count] = 0;
    g_BpUserRewards[playerid][idx][bpr_received_date] = received_time;
    g_BpUserRewards[playerid][idx][bpr_expire_date] = expire_time;
    g_BpUserRewards[playerid][idx][bpr_is_taken] = 0;
    g_BpUserRewards[playerid][idx][bpr_alarm_state] = ITEM_ALARM_NEW;
    g_BpUserRewards[playerid][idx][bpr_loaded] = true;
    format(g_BpUserRewards[playerid][idx][bpr_reward_name], 48, "%s", name);

    if(append_slot) g_BpUserRewardsCount[playerid]++;
    printf("[BPR] Reward queued: player=%d dbid=%d type=%d name=%s", playerid, reward_id, type, name);

    if(g_BpRewardsFilter[playerid] >= BPR_FILTER_MIN)
        BPR_RefreshPlayerGUI(playerid);
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

stock BPR_GiveCase(playerid, image_id, const name[], rarity = 2, quantity = 1)
{
    return BPR_GiveReward(playerid, BPR_TYPE_CASES, image_id, name, rarity, quantity, 0, 0, -1);
}

stock BPR_GiveCurrency(playerid, type_id, const name[], quantity, days_left = 0)
{
    return BPR_GiveReward(playerid, type_id, 0, name, 1, quantity, days_left, 0, -1);
}

stock BPR_GivePlate(playerid, plate_type, const plate_text[], const name[] = "Number plate", rarity = 2, days_left = 365)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id) return 0;
    
    if(!g_BpRewardsLoaded[playerid] || !BPR_CanAcceptRewards(playerid, 1))
        return 0;
    
    new current_time = gettime();
    new expire_time = current_time + (days_left * 86400);
    
    new query[512];
    mysql_format(g_BPRMySQL, query, sizeof(query),
        "INSERT INTO bpr_user_rewards \
        (user_id, reward_type, image_id, skin_model_id, name, rarity, quantity, days_left, spray_price, \
         plate_text_0, plate_count, received_date, expire_date, is_taken, alarm_state) \
        VALUES (%d, %d, %d, %d, '%e', %d, 1, %d, 0, '%e', 1, %d, %d, 0, 1)",
        account_id, BPR_TYPE_INVENTORY, plate_type, -1, name, rarity, days_left, plate_text, current_time, expire_time
    );
    
    mysql_tquery(g_BPRMySQL, query, "BPR_OnPlateSaved", "dsiii", playerid, name, plate_type, rarity, days_left);
    
    return 1;
}

forward BPR_OnPlateSaved(playerid, const name[], plate_type, rarity, days_left);
public BPR_OnPlateSaved(playerid, const name[], plate_type, rarity, days_left)
{
    new reward_id = cache_insert_id();
    new account_id = GetPlayerAccountID(playerid);
    new current_time = gettime();
    new expire_time = current_time + (days_left * 86400);
    
    new idx = BPR_FindFreeMemorySlot(playerid);
    if(idx == -1) return 0;
    new bool:append_slot = (idx == g_BpUserRewardsCount[playerid]);
    
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
    
    if(append_slot) g_BpUserRewardsCount[playerid]++;
    
    printf("[BPR] Plate saved and added to array for player %d: [DB ID=%d]", playerid, reward_id);
    
    if(g_BpRewardsFilter[playerid] >= BPR_FILTER_MIN)
        BPR_RefreshPlayerGUI(playerid);
}

stock BPR_TakeReward(playerid, user_reward_id)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id || !g_BpRewardsLoaded[playerid]) return 0;

    for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
    {
        if(g_BpUserRewards[playerid][i][bpr_user_reward_id] != user_reward_id ||
           g_BpUserRewards[playerid][i][bpr_is_taken] != 0)
            continue;

        new type = g_BpUserRewards[playerid][i][bpr_reward_type];
        new image_id = g_BpUserRewards[playerid][i][bpr_reward_image_id];
        new skin_model = g_BpUserRewards[playerid][i][bpr_reward_skin_model_id];
        new quantity = g_BpUserRewards[playerid][i][bpr_reward_quantity];
        new days_left = g_BpUserRewards[playerid][i][bpr_reward_days_left];
        new name[48];
        format(name, sizeof(name), "%s", g_BpUserRewards[playerid][i][bpr_reward_name]);
        if(quantity <= 0) quantity = 1;

        new success = 0;
        switch(type)
        {
            case BPR_TYPE_EXP:
            {
                AddPlayerData(playerid, P_EXP, +, quantity);
                while(GetPlayerExp(playerid) >= GetExpToNextLevel(playerid))
                {
                    AddPlayerData(playerid, P_EXP, -, GetExpToNextLevel(playerid));
                    AddPlayerData(playerid, P_LEVEL, +, 1);
                    SetPlayerLevelInit(playerid);
                }
                UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
                UpdatePlayerDatabaseInt(playerid, "level", GetPlayerLevel(playerid));
                success = 1;
            }
            case BPR_TYPE_MONEY:
            {
                GivePlayerMoneyEx(playerid, quantity, "Reward storage", true, true);
                success = 1;
            }
            case BPR_TYPE_BC:
            {
                GivePlayerDonateRub(playerid, quantity, "Reward storage");
                success = 1;
            }
            case BPR_TYPE_CASES:
            {
                success = AddPlayerCaseCountByType(playerid, image_id, quantity);
                if(success) Cases_SavePlayer(playerid);
            }
            case BPR_TYPE_CAR:
            {
                if(image_id > 0 && GetFreeOwnableCarID() != -1)
                {
                    BuyPlayerCar(playerid, image_id, image_id, 1);
                    success = 1;
                }
            }
            case BPR_TYPE_VIP:
            {
                new vip_level = image_id;
                if(vip_level < 1) vip_level = 1;
                new vip_hours = quantity;
                if(vip_hours <= 1 && days_left > 0) vip_hours = days_left * 24;

                new expires_at = GetPlayerData(playerid, P_PREMIUM_DATE);
                if(expires_at < gettime()) expires_at = gettime();
                expires_at += vip_hours * 3600;
                if(GetPlayerPremium(playerid) < vip_level)
                    SetPlayerData(playerid, P_PREMIUM, vip_level);
                SetPlayerData(playerid, P_PREMIUM_DATE, expires_at);
                UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerPremium(playerid));
                UpdatePlayerDatabaseInt(playerid, "premium_date", expires_at);
                success = 1;
            }
            case BPR_TYPE_BP_EXP:
            {
                success = BlackPass_GrantExperience(playerid, quantity);
            }
            case BPR_TYPE_INVENTORY:
            {
                new free_slot = Inventory_GetFreeSlot(playerid);
                if(free_slot == -1)
                {
                    ShowNotificationSander(playerid, 2, 7, -1, -1, "Нет свободного места в инвентаре", "Освободите слот и повторите получение.");
                    return 0;
                }

                if(image_id == BPR_SKIN_EL)
                {
                    new skin_id = skin_model;
                    if(skin_id <= 0) skin_id = quantity;
                    success = Inventory_AddItem(playerid, BPR_SKIN_EL, free_slot, skin_id, "");
                }
                else
                {
                    success = Inventory_AddItem(playerid, image_id, free_slot, quantity, "");
                }
            }
            case BPR_TYPE_DUST:
            {
                success = Cases_GiveDust(playerid, quantity);
            }
            case BPR_TYPE_EVENT_RES:
            {
                success = BlackPass_AddDust(playerid, quantity);
            }
        }

        if(!success)
        {
            ShowNotificationSander(playerid, 2, 7, -1, -1, "Награду пока нельзя забрать", "Проверьте свободные слоты и лимит транспорта.");
            return 0;
        }

        new query[256];
        mysql_format(g_BPRMySQL, query, sizeof(query),
            "UPDATE bpr_user_rewards SET is_taken=1,alarm_state=0 WHERE id=%d AND user_id=%d AND is_taken=0",
            user_reward_id, account_id
        );
        mysql_tquery(g_BPRMySQL, query, "", "");

        g_BpUserRewards[playerid][i][bpr_is_taken] = 1;
        g_BpUserRewards[playerid][i][bpr_alarm_state] = 0;

        BPR_BuildAlarmsArray(playerid);
        new Node:response = JSON_Object();
        JSON_SetInt(response, "t", 4);
        JSON_SetInt(response, "id", user_reward_id);
        JSON_SetInt(response, "s", 1);
        BPR_AppendAlarmsToJSON(response, playerid);
        SendPacketToClient(playerid, GUI_BP_REWARDS, response);
        JSON_Cleanup(response, true);

        ShowNotificationSander(playerid, 3, 7, -1, -1, "Награда получена", name);
        return 1;
    }
    return 0;
}

stock BPR_SprayReward(playerid, user_reward_id, reward_value)
{
    #pragma unused reward_value
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id || !g_BpRewardsLoaded[playerid]) return 0;

    for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
    {
        if(g_BpUserRewards[playerid][i][bpr_user_reward_id] != user_reward_id ||
           g_BpUserRewards[playerid][i][bpr_is_taken] != 0)
            continue;

        new spray_price = g_BpUserRewards[playerid][i][bpr_reward_spray_price];
        if(spray_price <= 0)
        {
            ShowNotificationSander(playerid, 2, 7, -1, -1, "Эту награду нельзя распылить", "");
            return 0;
        }

        if(!Cases_GiveDust(playerid, spray_price)) return 0;

        new query[256];
        mysql_format(g_BPRMySQL, query, sizeof(query),
            "UPDATE bpr_user_rewards SET is_taken=1,alarm_state=0 WHERE id=%d AND user_id=%d AND is_taken=0",
            user_reward_id, account_id
        );
        mysql_tquery(g_BPRMySQL, query, "", "");

        g_BpUserRewards[playerid][i][bpr_is_taken] = 1;
        g_BpUserRewards[playerid][i][bpr_alarm_state] = 0;
        BPR_BuildAlarmsArray(playerid);

        new Node:response = JSON_Object();
        JSON_SetInt(response, "t", 4);
        JSON_SetInt(response, "id", user_reward_id);
        JSON_SetInt(response, "s", 3);
        BPR_AppendAlarmsToJSON(response, playerid);
        SendPacketToClientString(playerid, GUI_BP_REWARDS, BPR_JSONToString(response));
        JSON_Cleanup(response, true);

        new notify_text[96];
        format(notify_text, sizeof(notify_text), "Получено пыли: %d", spray_price);
        ShowNotificationSander(playerid, 3, 7, -1, -1, notify_text, "");
        return 1;
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

stock BPR_EscapeJSONString(const source[], dest[], destSize)
{
    new pos = 0;
    for(new i = 0; source[i] != EOS && pos < destSize - 1; i++)
    {
        if(source[i] == '\\' || source[i] == '"')
        {
            if(pos >= destSize - 2) break;
            dest[pos++] = '\\';
        }
        if(source[i] == '\n' || source[i] == '\r' || source[i] == '\t')
        {
            if(pos >= destSize - 2) break;
            dest[pos++] = ' ';
            continue;
        }
        dest[pos++] = source[i];
    }
    dest[pos] = EOS;
    return 1;
}

stock BPR_AppendItemJson(playerid, rewardIndex, dest[], destSize)
{
    new type = g_BpUserRewards[playerid][rewardIndex][bpr_reward_type];
    new image_id = g_BpUserRewards[playerid][rewardIndex][bpr_reward_image_id];
    new skin_model = g_BpUserRewards[playerid][rewardIndex][bpr_reward_skin_model_id];
    new alarm = g_BpUserRewards[playerid][rewardIndex][bpr_alarm_state];
    new id = g_BpUserRewards[playerid][rewardIndex][bpr_user_reward_id];
    new name[64], escaped_name[128];
    format(name, sizeof(name), "%s", g_BpUserRewards[playerid][rewardIndex][bpr_reward_name]);
    BPR_EscapeJSONString(name, escaped_name, sizeof(escaped_name));
    
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
        id, escaped_name, type, alarm, image_id, skin_model,
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

stock BPR_Open(playerid)
{
    printf("[BPR] Open request from player %d", playerid);
    if(!g_BpRewardsLoaded[playerid])
    {
        BPR_LoadUserRewards(playerid);
        ShowNotificationSander(playerid, 2, 7, -1, -1, "Награды загружаются", "Повторите /reward через секунду.");
        return 0;
    }
    
    SetPVarInt(playerid, REWARD_GUI_MODE_PVAR, REWARD_GUI_MODE_BPR);
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
        SetPVarInt(playerid, REWARD_GUI_MODE_PVAR, REWARD_GUI_MODE_NONE);
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

CMD:rgivecar(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 12) return 1;
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
    if(GetPlayerAdminEx(playerid) < 12) return 1;
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
    if(GetPlayerAdminEx(playerid) < 12) return 1;
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
    if(GetPlayerAdminEx(playerid) < 12) return 1;
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
    if(GetPlayerAdminEx(playerid) < 12) return 1;
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
    if(GetPlayerAdminEx(playerid) < 12) return 1;
    new to_player, type, image_id, name[64], rarity, quantity, days_left, spray_price, skin_model_id;
    if(sscanf(params, "idds[64]ddddd", to_player, type, image_id, name, rarity, quantity, days_left, spray_price, skin_model_id))
        return SendClientMessage(playerid, -1, "Usage: /rgivereward [player] [type] [image_id] [name] [rarity] [quantity] [days] [spray_price] [skin_model]");
    if(!IsPlayerConnected(to_player)) return SendClientMessage(playerid, -1, "Player not connected");
    BPR_GiveReward(to_player, type, image_id, name, rarity, quantity, days_left, spray_price, skin_model_id);
    return 1;
}