#if defined _bp_rewards_included
    #endinput
#endif
#define _bp_rewards_included

#include "../include/a_mysql.inc"
#include <json>

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
static g_BpUserRewards[MAX_PLAYERS][500][E_BPR_USER_REWARD];
static g_BpUserRewardsCount[MAX_PLAYERS];
static g_BpRewardsFilter[MAX_PLAYERS];
static g_BpRewardsOffset[MAX_PLAYERS];

static const g_BpAwardsDefaultId[] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31};

static const g_BpAwardsDefaultName[31][] = {
    "Скин","Валюта","Чёрные монеты","Кейс","Автомобиль","Набор","Токены",
    "Купон X2","VIP","Сезонные очки","Инвентарь","Оружие","Сабля",
    "Билет","Слот","Лицензии","Медицина","E-Очки","Купон","Скидка",
    "Спрей","Закон","Звезды","Звук","Категория B","Аватар","Рамка","Тема",
    "Билет","Оружие","Боеприпасы"
};

static const g_BpAwardsDefaultImageCount[] = {1,1,1,19,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};

forward SendPacketToClientString(playerid, guiid, const data[]);
forward HidePlayerGUI(playerid, guiid);

// === ОСНОВНЫЕ ФУНКЦИИ ===
stock BPR_Init(MySQL:handle)
{
    mysql = handle;
    printf("[BPR] Инициализация системы BP Rewards...");
    BPR_CreateUserTable();
    BPR_LoadAwardTypes();
    printf("[BPR] Система BP Rewards инициализирована");
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
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;"
    );
    printf("[BPR] Таблица пользовательских наград создана/проверена");
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
            printf("[BPR] awards.json не найден, используются значения по умолчанию");
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
        printf("[BPR] awards.json пуст, используются значения по умолчанию");
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
    printf("[BPR] Загружено %d типов наград из JSON", g_BpAwardsCount);
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
    printf("[BPR] Инициализировано %d типов наград по умолчанию", g_BpAwardsCount);
    return 1;
}

stock BPR_LoadUserRewards(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id)
    {
        printf("[BPR] Ошибка: не удалось получить ID аккаунта игрока %d", playerid);
        return 0;
    }
    
    printf("[BPR] Загружаем награды для игрока %d (аккаунт: %d)", playerid, account_id);
    
    g_BpUserRewardsCount[playerid] = 0;
    for(new i = 0; i < 500; i++)
    {
        g_BpUserRewards[playerid][i][bpr_loaded] = false;
    }
    
    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "SELECT * FROM bpr_user_rewards WHERE user_id = %d AND is_taken = 0 ORDER BY received_date DESC LIMIT %d",
        account_id, 500
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
        printf("[BPR] Нет сохранённых наград для игрока %d", playerid);
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
        
        printf("[BPR] Загружена награда для игрока %d: ID=%d, Тип=%d, Название=%s", 
            playerid,
            g_BpUserRewards[playerid][i][bpr_user_reward_id],
            g_BpUserRewards[playerid][i][bpr_reward_type],
            g_BpUserRewards[playerid][i][bpr_reward_name]);
    }
    
    printf("[BPR] Загружено %d наград для игрока %d", rows, playerid);
}

stock BPR_GiveReward(playerid, type, image_id, const name[], rarity = 1, quantity = 1, days_left = 30, spray_price = 0, skin_model_id = -1)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id)
    {
        printf("[BPR] Ошибка: не удалось получить ID аккаунта игрока %d", playerid);
        return 0;
    }
    
    if(g_BpUserRewardsCount[playerid] >= 500)
    {
        printf("[BPR] У игрока %d достигнут максимум наград", playerid);
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
    
    printf("[BPR] Награда сохранена и добавлена в массив для игрока %d: [DB ID=%d] %s", playerid, reward_id, name);
    
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
    return BPR_GiveReward(playerid, type_id, 0, name, 1, quantity, days_left, 0, -1);
}

stock BPR_GivePlate(playerid, plate_type, const plate_text[], const name[] = "Number plate", rarity = 2, days_left = 365)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id) return 0;
    
    if(g_BpUserRewardsCount[playerid] >= 500)
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
    format(g_BpUserRewards[playerid][idx][bpr_reward_plate_text_0], 8, "Номер");
    
    g_BpUserRewardsCount[playerid]++;
    
    printf("[BPR] Номерной знак сохранён и добавлен в массив для игрока %d: [DB ID=%d]", playerid, reward_id);
    
    if(g_BpRewardsFilter[playerid] >= BPR_FILTER_MIN)
        BPR_RefreshPlayerGUI(playerid);
}

stock BPR_TakeReward(playerid, user_reward_id)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id) return 0;
    
    for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
    {
        if(g_BpUserRewards[playerid][i][bpr_user_reward_id] == user_reward_id)
        {
            new type = g_BpUserRewards[playerid][i][bpr_reward_type];
            new image_id = g_BpUserRewards[playerid][i][bpr_reward_image_id];
            new skin_model = g_BpUserRewards[playerid][i][bpr_reward_skin_model_id];
            new name[48];
            format(name, sizeof(name), "%s", g_BpUserRewards[playerid][i][bpr_reward_name]);
            
            printf("[BPR] Игрок %d получил награду: %s (Тип=%d)", playerid, name, type);
            
            if(type == BPR_TYPE_INVENTORY)
            {
                new game_id = image_id;
                
                if(image_id == BPR_SKIN_EL)
                {
                    game_id = skin_model;
                    printf("[BPR] Это скин: game_id = %d", game_id);
                    new freeSlot = Inventory_GetFreeSlot(playerid);
                    if(freeSlot == -1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "Нет свободных слотов в инвентаре", "");
                        return 1;
                    }
                    Inventory_AddItem(playerid, 134, freeSlot, game_id, name);
                    SaveInventoryItem(playerid, freeSlot);
                }
                else
                {
                    printf("[BPR] Это аксессуар: game_id = %d", game_id);
                    new freeSlot = Inventory_GetFreeSlot(playerid);
                    if(freeSlot == -1)
                    {
                        ShowNotificationSile(playerid, 2, 7, -1, -1, "Нет свободных слотов в инвентаре", "");
                        return 1;
                    }
                    Inventory_AddItem(playerid, game_id, freeSlot, 1, name);
                    SaveInventoryItem(playerid, freeSlot);
                }
                ShowNotificationSile(playerid, 3, 7, -1, -1, "Предмет добавлен в инвентарь!", "");
            }
            else if(type == BPR_TYPE_CAR)
            {
                if(image_id == -1) return 1;
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
                strmid(g_ownable_car[free_car_id][OC_NUMBER], "none", 0, 32, 32);
                SetOwnableCarData(free_car_id, OC_ALARM, false);
                SetOwnableCarData(free_car_id, OC_KEY_IN, false);
                SetOwnableCarData(free_car_id, OC_CREATE, gettime());
                format(g_ownable_car[free_car_id][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));
                
                new database_query[256];
                format(database_query, sizeof database_query, "INSERT INTO ownable_cars (owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) VALUES ('%d','%d','%d','%d','%f','%f','%f','%f','%d')", GetPlayerAccountID(playerid), image_id, color, 0, pos_x, pos_y, pos_z, angle, gettime());
                mysql_query(mysql, database_query, true);
                
                printf("[BPR] Машина выдана с image_id = %d", image_id);
                SendClientMessage(playerid, -1, "Вы получили машину в личный автопарк!");
            }
            else if(type == BPR_TYPE_VIP)
            {
                new vip_type = g_BpUserRewards[playerid][i][bpr_reward_quantity];
                new vip_days = g_BpUserRewards[playerid][i][bpr_reward_days_left];
                if(vip_type < 1) vip_type = 1;
                if(vip_days < 1) vip_days = 1;
                if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                {
                    SetPlayerData(playerid, P_PREMIUM_DATE, gettime());
                }
                SetPlayerData(playerid, P_PREMIUM, vip_type);
                AddPlayerData(playerid, P_PREMIUM_DATE, +, vip_days * 86400);
                UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                printf("[BPR] VIP выдан: тип=%d на %d дней", vip_type, vip_days);
                SendClientMessage(playerid, -1, "VIP активирован!");
            }
            else if(type == BPR_TYPE_CASES)
            {
                new case_count = g_BpUserRewards[playerid][i][bpr_reward_quantity];
                if(case_count < 1) case_count = 1;
                if(Cases_GivePlayerCaseById(playerid, image_id, case_count))
                {
                    printf("[BPR] Кейс выдан: id=%d quantity=%d", image_id, case_count);
                    SendClientMessage(playerid, -1, "Кейс добавлен!");
                }
                else
                {
                    printf("[BPR] Не удалось выдать кейс id=%d quantity=%d", image_id, case_count);
                    SendClientMessage(playerid, -1, "Не удалось добавить кейс.");
                }
            }
            else if((type >= 1 && type <= 3) || type == 7 || type == 10 || type == 18 || type == 19)
            {
                new quantity = g_BpUserRewards[playerid][i][bpr_reward_quantity];
                if(type == 2 || type == 1)
                {
                    AddPlayerData(playerid, P_MONEY, +, quantity);
                    UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
                    printf("[BPR] Деньги зачислены: %d", quantity);
                    SendClientMessage(playerid, -1, "Деньги зачислены!");
                }
                else if(type == 3)
                {
                    AddPlayerData(playerid, P_DONATE_MONEY, +, quantity);
                    UpdatePlayerDatabaseInt(playerid, "donate_current", GetPlayerData(playerid, P_DONATE_MONEY));
                    printf("[BPR] Чёрные монеты зачислены: %d", quantity);
                    SendClientMessage(playerid, -1, "Black-Coins зачислены!");
                }
                else
                {
                    printf("[BPR] Валюта type=%d, quantity=%d", type, quantity);
                    SendClientMessage(playerid, -1, "Валюта зачислена!");
                }
            }
            
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
            JSON_SetString(response, "fl", g_BpRewardsAlarmsBuf);
            
            BPR_AppendAlarmsToJSON(response, playerid);
            
            SendPacketToClient(playerid, GUI_BP_REWARDS, response);
            JSON_Cleanup(response, true);
        }
    }
    return 1;
}

stock BPR_SprayReward(playerid, user_reward_id, reward_value)
{
    new account_id = GetPlayerAccountID(playerid);
    if(!account_id) return 0;
    
    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE bpr_user_rewards SET is_taken = 1, alarm_state = 0 WHERE id = %d AND user_id = %d",
        user_reward_id, account_id
    );
    mysql_tquery(mysql, query, "", "");
    printf("[BPR] Игрок %d распылил награду ID %d на значение %d", playerid, user_reward_id, reward_value);
    
    for(new i = 0; i < g_BpUserRewardsCount[playerid]; i++)
    {
        if(g_BpUserRewards[playerid][i][bpr_user_reward_id] == user_reward_id)
        {
            new name[48];
            format(name, sizeof(name), "%s", g_BpUserRewards[playerid][i][bpr_reward_name]);
            
            printf("[BPR] Игрок %d распылил награду: %s (Значение=%d)", playerid, name, reward_value);
            
            g_BpUserRewards[playerid][i][bpr_is_taken] = 1;
            g_BpUserRewards[playerid][i][bpr_alarm_state] = 0;
            SetPlayerData(playerid, P_DUST, GetPlayerData(playerid, P_DUST) + reward_value);
            UpdatePlayerDatabaseInt(playerid, "dust", GetPlayerData(playerid, P_DUST));
            
            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 4);
            JSON_SetInt(response, "id", user_reward_id);
            JSON_SetInt(response, "s", 3);
            JSON_SetString(response, "fl", g_BpRewardsAlarmsBuf);
            
            BPR_AppendAlarmsToJSON(response, playerid);
            
            SendPacketToClientString(playerid, GUI_BP_REWARDS, BPR_JSONToString(response));
            JSON_Cleanup(response, true);
            
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

stock BPR_AppendItemJson(playerid, rewardIndex, dest[], destSize)
{
    new type = g_BpUserRewards[playerid][rewardIndex][bpr_reward_type];
    new image_id = g_BpUserRewards[playerid][rewardIndex][bpr_reward_image_id];
    new skin_model = g_BpUserRewards[playerid][rewardIndex][bpr_reward_skin_model_id];
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
        id, name, type, alarm, image_id, skin_model,
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
    printf("[BPR] Запрос открытия от игрока %d", playerid);
    
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
            Cases_ShowGUI(playerid);
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
            SendClientMessage(playerid, -1, "case 5");
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
    format(dest, destSize, "Награда %d", awardId);
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
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, -1, "Использование: /rgivecar [id игрока]");
        return 1;
    }
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, -1, "Игрок не в сети");
        return 1;
    }
    BPR_GiveCar(targetid, 2555, "Lada Granta", 2, 365, 500);
    new msg[128];
    format(msg, sizeof(msg), "Машина выдана игроку %d", targetid);
    SendClientMessage(playerid, -1, msg);
    return 1;
}

CMD:rgiveskin(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, -1, "Использование: /rgiveskin [id игрока]");
        return 1;
    }
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, -1, "Игрок не в сети");
        return 1;
    }
    BPR_GiveSkin(targetid, 6871, "Maslennikov", 3, 365, 500);
    new msg[128];
    format(msg, sizeof(msg), "Скин выдан игроку %d", targetid);
    SendClientMessage(playerid, -1, msg);
    return 1;
}

CMD:rgiveacc(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, -1, "Использование: /rgiveacc [id игрока]");
        return 1;
    }
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, -1, "Игрок не в сети");
        return 1;
    }
    BPR_GiveAccessory(targetid, 918, 677, "Советская шляпа", 2, 365, 300);
    new msg[128];
    format(msg, sizeof(msg), "Аксессуар выдан игроку %d", targetid);
    SendClientMessage(playerid, -1, msg);
    return 1;
}



CMD:rgiveplate(playerid, params[])
{
    new targetid, plate_type;
    new plate_text[16];
    if(sscanf(params, "uis[16]", targetid, plate_type, plate_text))
    {
        SendClientMessage(playerid, -1, "Использование: /rgiveplate [id игрока] [тип(59/81/82/83)] [текст]");
        return 1;
    }
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, -1, "Игрок не в сети");
        return 1;
    }
    if(plate_type != 59 && plate_type != 81 && plate_type != 82 && plate_type != 83)
    {
        SendClientMessage(playerid, -1, "Неверный тип номера. Используйте: 59(RU), 81(UA), 82(BY), 83(KZ)");
        return 1;
    }
    BPR_GivePlate(targetid, plate_type, plate_text, "Номерной знак", 2, 365);
    new msg[128];
    format(msg, sizeof(msg), "Номер выдан игроку %d", targetid);
    SendClientMessage(playerid, -1, msg);
    return 1;
}

CMD:loadrewards(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, -1, "Использование: /loadrewards [id игрока]");
        return 1;
    }
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, -1, "Игрок не в сети");
        return 1;
    }
    BPR_LoadUserRewards(targetid);
    new msg[128];
    format(msg, sizeof(msg), "Загружаем награды для игрока %d из базы данных", targetid);
    SendClientMessage(playerid, -1, msg);
    return 1;
}

CMD:rgivereward(playerid, params[]) 
{
    new to_player, type, image_id, name[64], rarity, quantity, days_left, spray_price, skin_model_id;
    if(sscanf(params, "idds[64]ddddd", to_player, type, image_id, name, rarity, quantity, days_left, spray_price, skin_model_id))
        return SendClientMessage(playerid, -1, "Использование: /rgivereward [id игрока] [type] [image_id] [name] [rarity] [quantity] [days] [spray_price] [skin_model]");
    BPR_GiveReward(to_player, type, image_id, name, rarity, quantity, days_left, spray_price, skin_model_id);
    return 1;
}