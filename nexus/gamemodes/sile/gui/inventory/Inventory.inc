#define MAX_INVENTORY_SLOTS 40
#define MAX_ACTIVE_SLOTS 8

#define SIM_SLOT 0
#define SKIN_SLOT 6

#define ITEM_ID_SIM       58
#define ITEM_ID_PHONE     60

#define ITEM_TYPE_OTHER 0
#define ITEM_TYPE_SKIN 1
#define ITEM_TYPE_SIM 2
#define ITEM_TYPE_PLATE 3
#define ITEM_TYPE_FOOD 4
#define ITEM_TYPE_MEDICAL 5
#define ITEM_TYPE_ACCESSORY 6

enum E_INVENTORY_ITEM
{
    inv_itemId,
    inv_itemCount,
    inv_itemSlot,
    inv_itemPlate[32],
    inv_itemType,
    inv_itemWeight,
    inv_itemName[64],
    bool:inv_itemActive,
    inv_activeSlot
}

new g_PlayerInventory[MAX_PLAYERS][MAX_INVENTORY_SLOTS][E_INVENTORY_ITEM];
new g_PlayerActiveSlots[MAX_PLAYERS][MAX_ACTIVE_SLOTS][E_INVENTORY_ITEM];
new g_PlayerWeight[MAX_PLAYERS];
new g_PlayerMaxWeight[MAX_PLAYERS] = {150, ...};
new g_LastDeleteAttempt[MAX_PLAYERS] = {0, ...};
new g_DeleteCount[MAX_PLAYERS] = {0, ...};

new const SkinMapping[][2] = {
    {134, 0},     {134, 1},     {134, 2},     {134, 3},     {134, 4},     {134, 5},     {134, 6},     {134, 7},     {134, 8},     {134, 9},
    {134, 10},    {134, 11},    {134, 12},    {134, 13},    {134, 14},    {134, 15},    {134, 16},    {134, 17},    {134, 18},    {134, 19},
    {134, 20},    {134, 21},    {134, 22},    {134, 23},    {134, 24},    {134, 25},    {134, 26},    {134, 27},    {134, 28},    {134, 29},
    {134, 30},    {134, 31},    {134, 32},    {134, 33},    {134, 34},    {134, 35},    {134, 36},    {134, 37},    {134, 38},    {134, 39},
    {134, 40},    {134, 41},    {134, 42},    {134, 43},    {134, 44},    {134, 45},    {134, 46},    {134, 47},    {134, 48},    {134, 49},
    {134, 50},    {134, 51},    {134, 52},    {134, 53},    {134, 54},    {134, 55},    {134, 56},    {134, 57},    {134, 58},    {134, 59},
    {134, 60},    {134, 61},    {134, 62},    {134, 63},    {134, 64},    {134, 65},    {134, 66},    {134, 67},    {134, 68},    {134, 69},
    {134, 70},    {134, 71},    {134, 72},    {134, 73},    {134, 75},    {134, 76},    {134, 77},    {134, 78},    {134, 79},    {134, 80},
    {134, 81},    {134, 82},    {134, 83},    {134, 84},    {134, 85},    {134, 86},    {134, 87},    {134, 88},    {134, 89},    {134, 90},
    {134, 91},    {134, 92},    {134, 93},    {134, 94},    {134, 95},    {134, 96},    {134, 97},    {134, 98},    {134, 99},    {134, 100},
    {134, 101},   {134, 102},   {134, 103},   {134, 104},   {134, 105},   {134, 106},   {134, 107},   {134, 108},   {134, 109},   {134, 110},
    {134, 111},   {134, 112},   {134, 113},   {134, 114},   {134, 115},   {134, 116},   {134, 117},   {134, 118},   {134, 119},   {134, 120},
    {134, 121},   {134, 122},   {134, 123},   {134, 124},   {134, 125},   {134, 126},   {134, 127},   {134, 128},   {134, 129},   {134, 130},
    {134, 131},   {134, 132},   {134, 133},   {134, 134},   {134, 135},   {134, 136},   {134, 137},   {134, 138},   {134, 139},   {134, 140},
    {134, 141},   {134, 142},   {134, 143},   {134, 144},   {134, 145},   {134, 146},   {134, 147},   {134, 148},   {134, 149},   {134, 150},
    {134, 151},   {134, 152},   {134, 153},   {134, 154},   {134, 155},   {134, 156},   {134, 157},   {134, 158},   {134, 159},   {134, 160},
    {134, 161},   {134, 162},   {134, 163},   {134, 164},   {134, 165},   {134, 166},   {134, 167},   {134, 168},   {134, 169},   {134, 170},
    {134, 171},   {134, 172},   {134, 173},   {134, 174},   {134, 175},   {134, 176},   {134, 177},   {134, 178},   {134, 179},   {134, 180},
    {134, 181},   {134, 182},   {134, 183},   {134, 184},   {134, 185},   {134, 186},   {134, 187},   {134, 188},   {134, 189},   {134, 190},
    {134, 191},   {134, 192},   {134, 193},   {134, 194},   {134, 195},   {134, 196},   {134, 197},   {134, 198},   {134, 199},   {134, 200},
    {134, 201},   {134, 202},   {134, 203},   {134, 204},   {134, 205},   {134, 206},   {134, 207},   {134, 208},   {134, 209},   {134, 210},
    {134, 211},   {134, 212},   {134, 213},   {134, 214},   {134, 215},   {134, 216},   {134, 217},   {134, 218},   {134, 219},   {134, 220},
    {134, 221},   {134, 222},   {134, 223},   {134, 224},   {134, 225},   {134, 226},   {134, 227},   {134, 228},   {134, 229},   {134, 230},
    {134, 231},   {134, 232},   {134, 233},   {134, 234},   {134, 235},   {134, 236},   {134, 237},   {134, 238},   {134, 239},   {134, 240},
    {134, 241},   {134, 242},   {134, 243},   {134, 244},   {134, 245},   {134, 246},   {134, 247},   {134, 248},   {134, 249},   {134, 250},
    {134, 251},   {134, 252},   {134, 253},   {134, 254},   {134, 255},   {134, 256},   {134, 257},   {134, 258},   {134, 259},   {134, 260},
    {134, 261},   {134, 262},   {134, 263},   {134, 264},   {134, 265},   {134, 266},   {134, 267},   {134, 268},   {134, 269},   {134, 270},
    {134, 271},   {134, 272},   {134, 274},   {134, 275},   {134, 276},   {134, 277},   {134, 278},   {134, 279},   {134, 280},   {134, 281},
    {134, 282},   {134, 283},   {134, 284},   {134, 285},   {134, 286},   {134, 287},   {134, 288},   {134, 289},   {134, 290},   {134, 291},
    {134, 292},   {134, 293},   {134, 294},   {134, 295},   {134, 296},   {134, 297},   {134, 298},   {134, 299},   {134, 300},   {134, 301},
    {134, 302},   {134, 303},   {134, 304},   {134, 305},   {134, 306},   {134, 307},   {134, 308},   {134, 309},   {134, 310},   {134, 311},
    {134, 5321},  {134, 5322},  {134, 5323},  {134, 5324},  {134, 5325},  {134, 5326},  {134, 5327},  {134, 5341},  {134, 5342},  {134, 5343},
    {134, 5344},  {134, 5345},  {134, 5346},  {134, 5347},  {134, 5348},  {134, 5349},  {134, 5350},  {134, 5351},  {134, 5352},  {134, 5353},
    {134, 5354},  {134, 5355},  {134, 5356},  {134, 5357},  {134, 5358},  {134, 5359},  {134, 5360},  {134, 5361},  {134, 5362},  {134, 5363},
    {134, 5364},  {134, 5365},  {134, 5366},  {134, 5367},  {134, 5368},  {134, 5369},  {134, 5370},  {134, 6774},  {134, 6775},  {134, 6776},
    {134, 6777},  {134, 6778},  {134, 6779},  {134, 6780},  {134, 6781},  {134, 6782},  {134, 6783},  {134, 6784},  {134, 6785},  {134, 6786},
    {134, 6787},  {134, 6788},  {134, 6789},  {134, 6790},  {134, 6791},  {134, 6792},  {134, 6793},  {134, 6794},  {134, 6795},  {134, 6796},
    {134, 6797},  {134, 6798},  {134, 6799},  {134, 6800},  {134, 6801},  {134, 6802},  {134, 6803},  {134, 6804},  {134, 6805},  {134, 6806},
    {134, 6807},  {134, 6808},  {134, 6809},  {134, 6810},  {134, 6811},  {134, 6812},  {134, 6813},  {134, 6814},  {134, 6815},  {134, 6816},
    {134, 6817},  {134, 6818},  {134, 6819},  {134, 6820},  {134, 6821},  {134, 6822},  {134, 6823},  {134, 6824},  {134, 6825},  {134, 6826},
    {134, 6827},  {134, 6828},  {134, 6829},  {134, 6830},  {134, 6831},  {134, 6832},  {134, 6835},  {134, 6836},  {134, 6837},  {134, 6838},
    {134, 6839},  {134, 6840},  {134, 6841},  {134, 6842},  {134, 6843},  {134, 6844},  {134, 6858},  {134, 6859},  {134, 6860},  {134, 6861},
    {134, 6862},  {134, 6863},  {134, 6864},  {134, 6865},  {134, 6866},  {134, 6867},  {134, 6868},  {134, 6869},  {134, 6870},  {134, 6871},
    {134, 6872},  {134, 6873},  {134, 6874},  {134, 6875},  {134, 6876},  {134, 6877},  {134, 6878},  {134, 6879},  {134, 6880},  {134, 6881},
    {134, 6884},  {134, 6885},  {134, 6886},  {134, 6887},  {134, 6888},  {134, 6889},  {134, 6890},  {134, 6891},  {134, 6892},  {134, 6893},
    {134, 6894},  {134, 6895},  {134, 6896},  {134, 6897},  {134, 6898},  {134, 6899},  {134, 6900},  {134, 6901},  {134, 6902},  {134, 7770},
    {134, 7771},  {134, 7772},  {134, 7773},  {134, 7774},  {134, 11588}, {134, 11589}, {134, 11590}, {134, 11591}, {134, 11592}, {134, 11593},
    {134, 11915}, {134, 11916}, {134, 11917}, {134, 11918}, {134, 11926}, {134, 11927}, {134, 11928}, {134, 11929}, {134, 11930}, {134, 11931},
    {134, 11932}, {134, 11933}, {134, 11934}, {134, 11935}, {134, 11936}, {134, 11937}, {134, 11938}, {134, 11939}, {134, 11940}, {134, 11941},
    {134, 11942}, {134, 11943}, {134, 11944}, {134, 11945}, {134, 11946}, {134, 11947}, {134, 11948}, {134, 11949}, {134, 11950}, {134, 11951},
    {134, 11952}, {134, 11953}, {134, 11954}, {134, 11955}, {134, 11956}, {134, 11957}, {134, 11958}, {134, 11959}, {134, 11960}, {134, 11961},
    {134, 11962}, {134, 11963}, {134, 11964}, {134, 11965}, {134, 11966}, {134, 11967}, {134, 11968}, {134, 11969}, {134, 11970}, {134, 12291},
    {134, 12293}, {134, 13725}, {134, 13726}, {134, 13727}, {134, 13728}, {134, 13729}, {134, 13730}, {134, 13817}, {134, 13818}, {134, 13819},
    {134, 13820}, {134, 13821}, {134, 13822}, {134, 13823}, {134, 13824}, {134, 14386}, {134, 14387}, {134, 14388}, {134, 18589}, {134, 18590},
    {134, 18591}, {134, 18592}, {134, 18593}, {134, 18594}, {134, 18595}, {134, 18596}, {134, 18597}, {134, 18598}, {134, 18599}, {134, 18600},
    {134, 18601}, {134, 18602}, {134, 18603}, {134, 18604}, {134, 18605}, {134, 18606}, {134, 18607}, {134, 18608}, {134, 18609}, {134, 18610},
    {134, 18611}, {134, 18612}, {134, 18613}, {134, 18614}, {134, 18615}, {134, 18616}, {134, 18617}, {134, 18618}, {134, 18619}, {134, 18620},
    {134, 18621}, {134, 18622}, {134, 18623}, {134, 18624}, {134, 18625}, {134, 18626}, {134, 18627}, {134, 18628}, {134, 18629}, {134, 18630},
    {134, 18860}, {134, 18861}, {134, 19199}, {134, 19260}, {134, 19261}, {134, 19262}, {134, 19263}, {134, 19264}, {134, 19265}, {134, 19266},
    {134, 19267}, {134, 19268}, {134, 19269}, {134, 19270}, {134, 19271}, {134, 19272}, {134, 19273}, {134, 19274}, {134, 19275}, {134, 19276},
    {134, 19596}, {134, 19901}, {134, 19902}, {134, 5882},  {134, 5883},  {134, 5884},  {134, 5885},  {134, 5886},  {134, 5887},  {134, 5888},
    {134, 5889},  {134, 5890},  {134, 5891},  {134, 5892},  {134, 5893},  {134, 5894},  {134, 5895},  {134, 5896},  {134, 5897},  {134, 5898},
    {134, 5899},  {134, 5900},  {134, 5901},  {134, 5902},  {134, 5903},  {134, 5500001}
};

stock Inventory_Init(MySQL:connection)
{
    mysql = connection;
    
    mysql_tquery(mysql, "SELECT * FROM `items_data`", "OnItemsDataLoaded");
    
    return 1;
}

forward OnItemsDataLoaded();
public OnItemsDataLoaded()
{
    new rows, fields;
    cache_get_data(rows, fields);
    
    
}

stock Inventory_Load(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        printf("[ERROR] Cannot load inventory for player %d: invalid account ID", playerid);
        return 0;
    }
    
    // Сбрасываем инвентарь перед загрузкой
    ResetPlayerInventory(playerid);
    
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "SELECT * FROM `player_inventory` WHERE `player_id` = %d ORDER BY `is_active` ASC, `slot` ASC", 
        account_id);
    
    
    mysql_tquery(mysql, query, "OnInventoryLoad", "ii", playerid, account_id);
    
    return 1;
}

forward OnInventoryLoad(playerid, account_id);
public OnInventoryLoad(playerid, account_id)
{
    // Проверяем, что игрок все еще онлайн
    if(!IsPlayerConnected(playerid))
    {
        
        return 0;
    }
    
    // Проверяем, что account_id соответствует текущему игроку
    if(GetPlayerAccountID(playerid) != account_id)
    {
        printf("[ERROR] Account ID mismatch for player %d: expected %d, got %d", 
            playerid, account_id, GetPlayerAccountID(playerid));
        return 0;
    }
    
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    
    
    if(rows > 0)
    {
        new loaded_count = 0;
        new active_loaded = 0;
        
        for(new i = 0; i < rows; i++)
        {
            // Проверяем, что данные соответствуют игроку (дополнительная проверка)
            new db_player_id = cache_get_field_content_int(i, "player_id", mysql);
            if(db_player_id != account_id)
            {
                printf("[WARNING] Skipping item with wrong player_id: %d (expected: %d)", 
                    db_player_id, account_id);
                continue;
            }
            
            new slot = cache_get_field_content_int(i, "slot", mysql);
            new itemId = cache_get_field_content_int(i, "item_id", mysql);
            new count = cache_get_field_content_int(i, "item_count", mysql);
            new isActive = cache_get_field_content_int(i, "is_active", mysql);
            new activeSlot = cache_get_field_content_int(i, "active_slot", mysql);
            
            new plate[32];
            cache_get_field_content(i, "item_plate", plate, mysql, 32);
            
            LoadPlayerAccessoriesToActiveSlots(playerid);
            
            if(!isActive)
            {
                if(slot >= 0 && slot < MAX_INVENTORY_SLOTS)
                {
                    if(g_PlayerInventory[playerid][slot][inv_itemId] == 0)
                    {
                        Inventory_SetItem(playerid, slot, itemId, count, plate);
                        
                        loaded_count++;
                        
                    }
                    else
                    {
                        // Слот занят, ищем свободный
                        new freeSlot = Inventory_GetFreeSlot(playerid);
                        if(freeSlot != -1)
                        {
                            Inventory_SetItem(playerid, freeSlot, itemId, count, plate);
                            
                            new weight = GetItemWeight(itemId) * count;
                            SetPlayerWeight(playerid, GetPlayerWeight(playerid) + weight);
                            
                            loaded_count++;
                            
                        }
                        else
                        {
                            printf("[ERROR] No free slots for item %d", itemId);
                        }
                    }
                }
            }
            else
            {
                if(activeSlot >= 0 && activeSlot < MAX_ACTIVE_SLOTS)
                {
                    if(g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] == 0)
                    {
                        Inventory_SetActiveItem(playerid, activeSlot, itemId, count, plate);
                        active_loaded++;
                        
                        
                        // Обновляем данные игрока
                        if(itemId == ITEM_ID_SIM && activeSlot == SIM_SLOT)
                        {
                            new phone_number = strval(plate);
                            if(phone_number > 0)
                            {
                                SetPlayerData(playerid, P_PHONE, phone_number);
                                
                            }
                        }
                        
                        if(itemId == 134 && activeSlot == SKIN_SLOT)
                        {
                            if(IsValidSkinModel(count))
                            {
                                // Скин хранится в item_count
                                SetPlayerData(playerid, P_SKIN, count);
                                
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    else
    {
        
        new default_skin = GetPlayerData(playerid, P_SKIN);
        if(default_skin <= 0 || !IsValidSkinModel(default_skin))
            default_skin = 60;
        
        Inventory_SetActiveItem(playerid, SKIN_SLOT, 134, default_skin, "");
        
        // Сохраняем
        Inventory_Save(playerid);
    }
    
    return 1;
}

stock GetPlayerPhoneFromActiveSIM(playerid)
{
    if(g_PlayerActiveSlots[playerid][0][inv_itemId] == 58)
    {
        return g_PlayerActiveSlots[playerid][0][inv_itemCount];
    }
    return 0;
}

stock Inventory_UpdateActiveSkin(playerid)
{
    new current_skin = GetPlayerSkin(playerid);
    
    g_PlayerActiveSlots[playerid][6][inv_itemId] = 134;
    g_PlayerActiveSlots[playerid][6][inv_itemCount] = current_skin;
    g_PlayerActiveSlots[playerid][6][inv_itemActive] = true;
    g_PlayerActiveSlots[playerid][6][inv_activeSlot] = 6;
    
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "UPDATE `player_inventory` SET `item_count` = %d WHERE `player_id` = %d AND `active_slot` = 6 AND `is_active` = 1",
        current_skin, GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query);
}

stock Inventory_Save(playerid)
{
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "DELETE FROM `player_inventory` WHERE `player_id` = %d", 
        GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query);
    
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] > 0)
        {
            SaveInventoryItem(playerid, i);
        }
    }
    
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            SaveActiveSlotItem(playerid, i);
        }
    }
}

stock SaveInventoryItem(playerid, slot)
{
    if(g_PlayerInventory[playerid][slot][inv_itemId] == 0) return 0;
    
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
        GetPlayerAccountID(playerid), slot);
    mysql_tquery(mysql, query);
    
    mysql_format(mysql, query, sizeof(query), 
        "INSERT INTO `player_inventory` (`player_id`, `slot`, `item_id`, `item_count`, `item_plate`, `is_active`, `active_slot`) VALUES (%d, %d, %d, %d, '%e', 0, -1)",
        GetPlayerAccountID(playerid),
        slot,
        g_PlayerInventory[playerid][slot][inv_itemId],
        g_PlayerInventory[playerid][slot][inv_itemCount],
        g_PlayerInventory[playerid][slot][inv_itemPlate]);
    
    mysql_tquery(mysql, query);
    return 1;
}

stock SaveActiveSlotItem(playerid, activeSlot)
{
    new query[512];
    mysql_format(mysql, query, sizeof(query), 
        "INSERT INTO `player_inventory` (`player_id`, `slot`, `item_id`, `item_count`, `item_plate`, `is_active`, `active_slot`) VALUES (%d, %d, %d, %d, '%e', 1, %d)",
        GetPlayerAccountID(playerid),
        activeSlot,
        g_PlayerActiveSlots[playerid][activeSlot][inv_itemId],
        g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount],
        g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate],
        activeSlot);
    
    mysql_tquery(mysql, query);
}



// Применяет серверное название к предметам водолаза после загрузки из БД.
stock Inventory_ApplyVodoTaggedName(item_id, const plate[], name[], len)
{
    if(!strcmp(plate, "VODO:0", true) && item_id == 486) { format(name, len, "Стиральная машина"); return 1; }
    if(!strcmp(plate, "VODO:1", true) && item_id == 784) { format(name, len, "Колесо внедорожника"); return 1; }
    if(!strcmp(plate, "VODO:2", true) && item_id == 478) { format(name, len, "Старинная ваза"); return 1; }
    if(!strcmp(plate, "VODO:3", true) && item_id == 482) { format(name, len, "Якорь корабля"); return 1; }
    if(!strcmp(plate, "VODO:4", true) && item_id == 905) { format(name, len, "Мотор лодочный"); return 1; }
    if(!strcmp(plate, "VODO:5", true) && item_id == 990) { format(name, len, "Золотая цепь"); return 1; }
    return 0;
}

stock Inventory_SetItem(playerid, slot, item_id, count, const plate[] = "")
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    
    g_PlayerInventory[playerid][slot][inv_itemId] = item_id;
    g_PlayerInventory[playerid][slot][inv_itemCount] = count;
    g_PlayerInventory[playerid][slot][inv_itemSlot] = slot;
    strcpy(g_PlayerInventory[playerid][slot][inv_itemPlate], plate, 32);
    g_PlayerInventory[playerid][slot][inv_itemActive] = false;
    g_PlayerInventory[playerid][slot][inv_activeSlot] = -1;
    
    g_PlayerInventory[playerid][slot][inv_itemType] = GetItemType(item_id);
    g_PlayerInventory[playerid][slot][inv_itemWeight] = GetItemWeight(item_id);
    GetItemName(item_id, g_PlayerInventory[playerid][slot][inv_itemName], 64);
    Inventory_ApplyVodoTaggedName(item_id, plate, g_PlayerInventory[playerid][slot][inv_itemName], 64);
    
    return 1;
}

stock Inventory_SetActiveItem(playerid, activeSlot, item_id, count, const plate[] = "")
{
    if(activeSlot < 0 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;
    
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] = item_id;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount] = count;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemSlot] = activeSlot;
    strcpy(g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate], plate, 32);
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemActive] = true;
    g_PlayerActiveSlots[playerid][activeSlot][inv_activeSlot] = activeSlot;
    
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemType] = GetItemType(item_id);
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemWeight] = GetItemWeight(item_id);
    GetItemName(item_id, g_PlayerActiveSlots[playerid][activeSlot][inv_itemName], 64);
    
    return 1;
}

stock Inventory_AddItem(playerid, item_id, slot, count, const plate[] = "")
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] > 0) return 0;
    
    Inventory_SetItem(playerid, slot, item_id, count, plate);
    SaveInventoryItem(playerid, slot);
    
    return 1;
}

stock GetSkinModelFromItemID(item_id)
{
    for(new i = 0; i < sizeof(SkinMapping); i++)
    {
        if(SkinMapping[i][0] == item_id)
        {
            return SkinMapping[i][1];
        }
    }
    return -1;
}

stock Inventory_RemoveOneItem(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] == 0) return 0;
    
    new item_id = g_PlayerInventory[playerid][slot][inv_itemId];
    new current_count = g_PlayerInventory[playerid][slot][inv_itemCount];
    
    new itemWeight = GetItemWeight(item_id);
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) - itemWeight);
    
    if(current_count <= 1)
    {
        g_PlayerInventory[playerid][slot][inv_itemId] = 0;
        g_PlayerInventory[playerid][slot][inv_itemCount] = 0;
        g_PlayerInventory[playerid][slot][inv_itemSlot] = slot;
        g_PlayerInventory[playerid][slot][inv_itemPlate][0] = 0;
        g_PlayerInventory[playerid][slot][inv_itemType] = 0;
        g_PlayerInventory[playerid][slot][inv_itemWeight] = 0;
        g_PlayerInventory[playerid][slot][inv_itemName][0] = 0;
        g_PlayerInventory[playerid][slot][inv_itemActive] = false;
        
        new query[256];
        mysql_format(mysql, query, sizeof(query), 
            "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
            GetPlayerAccountID(playerid), slot);
        mysql_tquery(mysql, query);
    }
    else
    {
        new new_count = current_count - 1;
        g_PlayerInventory[playerid][slot][inv_itemCount] = new_count;
        
        new query[256];
        mysql_format(mysql, query, sizeof(query), 
            "UPDATE `player_inventory` SET `item_count` = %d WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
            new_count, GetPlayerAccountID(playerid), slot);
        mysql_tquery(mysql, query);
    }
    
    return 1;
}

stock Inventory_RemoveItem(playerid, slot, count)
{
    if(count == 1)
    {
        return Inventory_RemoveOneItem(playerid, slot);
    }
    else
    {
        for(new i = 0; i < count; i++)
        {
            if(!Inventory_RemoveOneItem(playerid, slot))
                return 0;
        }
        return 1;
    }
}

stock Inventory_DeleteItem(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] == 0) return 0;
    
    new item_id = g_PlayerInventory[playerid][slot][inv_itemId];
    new count = g_PlayerInventory[playerid][slot][inv_itemCount];
    
    new itemWeight = GetItemWeight(item_id) * count;
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) - itemWeight);
    
    g_PlayerInventory[playerid][slot][inv_itemId] = 0;
    g_PlayerInventory[playerid][slot][inv_itemCount] = 0;
    g_PlayerInventory[playerid][slot][inv_itemSlot] = slot;
    g_PlayerInventory[playerid][slot][inv_itemPlate][0] = 0;
    g_PlayerInventory[playerid][slot][inv_itemType] = 0;
    g_PlayerInventory[playerid][slot][inv_itemWeight] = 0;
    g_PlayerInventory[playerid][slot][inv_itemName][0] = 0;
    g_PlayerInventory[playerid][slot][inv_itemActive] = false;
    
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
        GetPlayerAccountID(playerid), slot);
    mysql_tquery(mysql, query);
    
    return 1;
}

forward OnItemDeleted(playerid, slot, item_id, count, weight);
public OnItemDeleted(playerid, slot, item_id, count, weight)
{
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "SELECT COUNT(*) FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
        GetPlayerAccountID(playerid), slot);
    mysql_tquery(mysql, query, "OnVerifyDelete", "dddd", playerid, slot, item_id, count);
}

forward OnVerifyDelete(playerid, slot, item_id, count);
public OnVerifyDelete(playerid, slot, item_id, count)
{
    new rows;
    cache_get_data(rows);
    
    if(rows == 0) return;
    
    new db_count;
    cache_get_field_content_int(0, "COUNT(*)", db_count);
    
    if(db_count > 0)
    {
        new query[256];
        mysql_format(mysql, query, sizeof(query), 
            "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
            GetPlayerAccountID(playerid), slot);
        mysql_tquery(mysql, query);
    }
}

stock Inventory_DeleteItemCompletely(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] == 0) return 0;
    
    new item_id = g_PlayerInventory[playerid][slot][inv_itemId];
    new count = g_PlayerInventory[playerid][slot][inv_itemCount];
    
    new itemWeight = GetItemWeight(item_id) * count;
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) - itemWeight);
    
    g_PlayerInventory[playerid][slot][inv_itemId] = 0;
    g_PlayerInventory[playerid][slot][inv_itemCount] = 0;
    g_PlayerInventory[playerid][slot][inv_itemSlot] = slot;
    g_PlayerInventory[playerid][slot][inv_itemPlate][0] = 0;
    g_PlayerInventory[playerid][slot][inv_itemType] = 0;
    g_PlayerInventory[playerid][slot][inv_itemWeight] = 0;
    g_PlayerInventory[playerid][slot][inv_itemName][0] = 0;
    g_PlayerInventory[playerid][slot][inv_itemActive] = false;
    
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
        GetPlayerAccountID(playerid), slot);
    mysql_tquery(mysql, query);
    
    return 1;
}

stock Inventory_MoveItem(playerid, oldSlot, newSlot)
{
    if(oldSlot < 0 || oldSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(newSlot < 0 || newSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(oldSlot == newSlot) return 1;
    
    new tempItem[E_INVENTORY_ITEM];
    
    tempItem = g_PlayerInventory[playerid][oldSlot];
    
    if(g_PlayerInventory[playerid][newSlot][inv_itemId] > 0)
    {
        g_PlayerInventory[playerid][oldSlot] = g_PlayerInventory[playerid][newSlot];
        g_PlayerInventory[playerid][oldSlot][inv_itemSlot] = oldSlot;
        
        g_PlayerInventory[playerid][newSlot] = tempItem;
        g_PlayerInventory[playerid][newSlot][inv_itemSlot] = newSlot;
        
        SaveInventoryItem(playerid, oldSlot);
        SaveInventoryItem(playerid, newSlot);
    }
    else
    {
        g_PlayerInventory[playerid][newSlot] = tempItem;
        g_PlayerInventory[playerid][newSlot][inv_itemSlot] = newSlot;
        
        g_PlayerInventory[playerid][oldSlot][inv_itemId] = 0;
        g_PlayerInventory[playerid][oldSlot][inv_itemCount] = 0;
        
        SaveInventoryItem(playerid, newSlot);
        
        new query[256];
        mysql_format(mysql, query, sizeof(query), 
            "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
            GetPlayerAccountID(playerid), oldSlot);
        mysql_tquery(mysql, query);
    }
    
    return 1;
}

stock Inventory_EquipItem(playerid, item_id, invSlot, &activeSlot)
{
    if(invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][invSlot][inv_itemId] != item_id) return 0;
    
    new itemType = g_PlayerInventory[playerid][invSlot][inv_itemType];
    new targetSlot = -1;
    
    switch(itemType)
    {
        case ITEM_TYPE_SKIN: targetSlot = 6;
        case ITEM_TYPE_SIM: targetSlot = 0;
        default: return 0;
    }
    
    if(g_PlayerActiveSlots[playerid][targetSlot][inv_itemId] > 0) return 0;
    
    Inventory_SetActiveItem(playerid, targetSlot, 
        g_PlayerInventory[playerid][invSlot][inv_itemId],
        g_PlayerInventory[playerid][invSlot][inv_itemCount],
        g_PlayerInventory[playerid][invSlot][inv_itemPlate]);
    
    Inventory_DeleteItem(playerid, invSlot);
    
    activeSlot = targetSlot;
    return 1;
}

stock Inventory_UnequipItem(playerid, activeSlot, invSlot)
{
    if(activeSlot < 0 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] == 0) return 0;
    if(g_PlayerInventory[playerid][invSlot][inv_itemId] > 0) return 0;
    
    Inventory_SetItem(playerid, invSlot,
        g_PlayerActiveSlots[playerid][activeSlot][inv_itemId],
        g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount],
        g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate]);
    
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate][0] = 0;
    
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 1 AND `active_slot` = %d",
        GetPlayerAccountID(playerid), activeSlot, activeSlot);
    mysql_tquery(mysql, query);
    
    return 1;
}

stock Inventory_SwapSkin(playerid, target_slot)
{
    if(target_slot < 0 || target_slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][target_slot][inv_itemId] != 134) return 0;
    
    new current_skin_model = GetPlayerSkin(playerid);
    new new_skin_model = g_PlayerInventory[playerid][target_slot][inv_itemCount];
    
    if(!IsValidSkinModel(new_skin_model)) return 0;
    
    g_PlayerInventory[playerid][target_slot][inv_itemCount] = current_skin_model;
    
    SetPlayerSkin(playerid, new_skin_model);
    
    g_PlayerActiveSlots[playerid][6][inv_itemId] = 134;
    g_PlayerActiveSlots[playerid][6][inv_itemCount] = new_skin_model;
    g_PlayerActiveSlots[playerid][6][inv_itemType] = ITEM_TYPE_SKIN;
    g_PlayerActiveSlots[playerid][6][inv_itemWeight] = GetItemWeight(134);
    GetItemName(134, g_PlayerActiveSlots[playerid][6][inv_itemName], 64);
    g_PlayerActiveSlots[playerid][6][inv_itemActive] = true;
    g_PlayerActiveSlots[playerid][6][inv_activeSlot] = 6;
    
    SaveInventoryItem(playerid, target_slot);
    
    new query[256];
    
    mysql_format(mysql, query, sizeof(query), 
        "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `active_slot` = 6 AND `is_active` = 1",
        GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query);
    
    mysql_format(mysql, query, sizeof(query), 
        "INSERT INTO `player_inventory` (`player_id`, `slot`, `item_id`, `item_count`, `item_plate`, `is_active`, `active_slot`) VALUES (%d, 6, 134, %d, '', 1, 6)",
        GetPlayerAccountID(playerid), new_skin_model);
    mysql_tquery(mysql, query);
    
    SetPlayerData(playerid, P_SKIN, new_skin_model);
    UpdatePlayerDatabaseInt(playerid, "skin", new_skin_model);
    
    return 1;
}

stock Inventory_SendSkinUpdatePacket(playerid, modelid)
{
    new JSON:skin_response = JSON_Object();
    JSON_SetInt(skin_response, "t", 33);
    JSON_SetInt(skin_response, "s", 1);
    JSON_SetInt(skin_response, "ps", modelid);

    new Node:aiResponse = JSON_Array(
        JSON_Int(134), JSON_Int(modelid), JSON_Int(6), JSON_Int(0), JSON_Int(0)
    );
    JSON_SetArray(skin_response, "ai", aiResponse);

    SendPacketToClient(playerid, 33, skin_response);
    JSON_Cleanup(skin_response);
    return 1;
}

forward OnCheckActiveSlot(playerid, modelid, activeSlot);
public OnCheckActiveSlot(playerid, modelid, activeSlot)
{
    new count;
    cache_get_field_content_int(0, "COUNT(*)", count);
    
    new query[256];
    
    if(count > 0)
    {
        mysql_format(mysql, query, sizeof(query), 
            "UPDATE `player_inventory` SET `item_count` = %d WHERE `player_id` = %d AND `active_slot` = %d AND `is_active` = 1",
            modelid, GetPlayerAccountID(playerid), activeSlot);
    }
    else
    {
        mysql_format(mysql, query, sizeof(query), 
            "INSERT INTO `player_inventory` (`player_id`, `slot`, `item_id`, `item_count`, `item_plate`, `is_active`, `active_slot`) VALUES (%d, %d, 134, %d, '', 1, %d)",
            GetPlayerAccountID(playerid), activeSlot, modelid, activeSlot);
    }
    
    mysql_tquery(mysql, query);
}

stock Inventory_SendSkinUpdate(playerid, modelid)
{
    new Node:skin_response = JSON_Object();
    JSON_SetInt(skin_response, "t", 33);
    JSON_SetInt(skin_response, "s", 1);
    JSON_SetInt(skin_response, "ps", modelid);
    
    new Node:aiResponse = JSON_Array(
        JSON_Int(134), JSON_Int(modelid), JSON_Int(6), JSON_Int(0)
    );
    JSON_SetArray(skin_response, "ai", aiResponse);
    
    SendPacketToClient(playerid, 33, skin_response);
    JSON_Cleanup(skin_response);
    
    return 1;
}

stock Inventory_GetItemID(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return -1;
    return g_PlayerInventory[playerid][slot][inv_itemId];
}

stock Inventory_GetItemCount(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    return g_PlayerInventory[playerid][slot][inv_itemCount];
}

stock Inventory_GetFreeSlot(playerid)
{
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] == 0)
        {
            return i;
        }
    }
    return -1;
}

stock Inventory_GetFreeActiveSlot(playerid)
{
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] == 0)
        {
            return i;
        }
    }
    return -1;
}

stock GetItemType(itemId)
{
    if(itemId == 134) return ITEM_TYPE_SKIN;
    if(itemId == 58) return ITEM_TYPE_SIM;
    if(itemId == 22) return ITEM_TYPE_MEDICAL;
    if(itemId == 135) return ITEM_TYPE_FOOD;
    if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83) return ITEM_TYPE_PLATE;
    return ITEM_TYPE_OTHER;
}

stock GetItemWeight(itemId)
{
    if(itemId == 134) return 5;
    if(itemId == 58) return 1;
    if(itemId == 22) return 2;
    if(itemId == 135) return 1;
    if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83) return 3;
    return 1;
}

stock GetItemName(itemId, name[], len = sizeof(name))
{
    switch(itemId)
    {
        case 1: format(name, len, "Аптечка");
        case 22: format(name, len, "Бинты");
        case 58: format(name, len, "SIM-карта");
        case 59: format(name, len, "Автомобильный номер");
        case 81: format(name, len, "Автомобильный номер (временный)");
        case 82: format(name, len, "Автомобильный номер (аренда)");
        case 83: format(name, len, "Автомобильный номер (учет)");
        case 134: format(name, len, "Скин");
        case 135: format(name, len, "Еда");
        default: format(name, len, "Предмет %d", itemId);
    }
    return 1;
}

stock GetPlayerWeight(playerid)
{
    return g_PlayerWeight[playerid];
}

stock SetPlayerWeight(playerid, weight)
{
    if(weight < 0) weight = 0;
    g_PlayerWeight[playerid] = weight;
}

stock GetPlayerMaxWeight(playerid)
{
    return g_PlayerMaxWeight[playerid];
}

stock GetPlayerActiveSlots(playerid)
{
    new count = 0;
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            count++;
        }
    }
    return count;
}

stock Inventory_HasSIMCard(playerid)
{
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] == ITEM_ID_SIM)
        {
            return 1;
        }
    }
    return 0;
}

stock GetPlayerPhoneNumber(playerid)
{
    return GetPlayerData(playerid, P_PHONE);
}

stock SetPlayerPhoneNumber(playerid, number)
{
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] == 58)
        {
            format(g_PlayerActiveSlots[playerid][i][inv_itemPlate], 32, "%d", number);
            
            new query[256];
            mysql_format(mysql, query, sizeof(query), 
                "UPDATE `player_inventory` SET `item_plate` = '%e' WHERE `player_id` = %d AND `active_slot` = %d AND `is_active` = 1",
                number, GetPlayerAccountID(playerid), i);
            mysql_tquery(mysql, query);
            
            return 1;
        }
    }
    return 0;
}

stock GetItemSlotPosition(item_id)
{
    new itemType = GetItemType(item_id);
    
    switch(itemType)
    {
        case ITEM_TYPE_SKIN: return 6;
        case ITEM_TYPE_SIM: return 0;
        case ITEM_TYPE_PLATE: return 2;
        default: return -1;
    }
}

stock Inventory_MoveFromSlotToInv(playerid, item_id, oldSlot, newSlot)
{
    if(oldSlot < 0 || oldSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(newSlot < 0 || newSlot >= MAX_INVENTORY_SLOTS) return 0;
    
    if(g_PlayerActiveSlots[playerid][oldSlot][inv_itemId] != item_id) return 0;
    if(g_PlayerInventory[playerid][newSlot][inv_itemId] > 0) return 0;
    
    Inventory_SetItem(playerid, newSlot,
        g_PlayerActiveSlots[playerid][oldSlot][inv_itemId],
        g_PlayerActiveSlots[playerid][oldSlot][inv_itemCount],
        g_PlayerActiveSlots[playerid][oldSlot][inv_itemPlate]);
    
    g_PlayerActiveSlots[playerid][oldSlot][inv_itemId] = 0;
    g_PlayerActiveSlots[playerid][oldSlot][inv_itemCount] = 0;
    g_PlayerActiveSlots[playerid][oldSlot][inv_itemPlate][0] = 0;
    
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `active_slot` = %d AND `is_active` = 1",
        GetPlayerAccountID(playerid), oldSlot);
    mysql_tquery(mysql, query);
    
    return 1;
}

stock SyncPlayerPhoneFromInventory(playerid)
{
    new phone_number = 0;
    
    if(g_PlayerActiveSlots[playerid][0][inv_itemId] == 58)
    {
        phone_number = strval(g_PlayerActiveSlots[playerid][0][inv_itemPlate]);
    }
    
    SetPlayerData(playerid, P_PHONE, phone_number);
    
    return phone_number;
}

stock UpdateInventoryPhoneFromPlayerData(playerid)
{
    new phone_number = GetPlayerData(playerid, P_PHONE);
    
    if(g_PlayerActiveSlots[playerid][0][inv_itemId] == 58)
    {
        format(g_PlayerActiveSlots[playerid][0][inv_itemPlate], 32, "%d", phone_number);
        
        new query[256];
        mysql_format(mysql, query, sizeof(query), 
            "UPDATE `player_inventory` SET `item_plate` = '%d' WHERE `player_id` = %d AND `active_slot` = 0 AND `is_active` = 1",
            phone_number, GetPlayerAccountID(playerid));
        mysql_tquery(mysql, query);
        
        return 1;
    }
    
    return 0;
}

stock Inventory_EquipSIM(playerid, invSlot)
{
    if(invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][invSlot][inv_itemId] != 58) return 0;
    if(g_PlayerActiveSlots[playerid][0][inv_itemId] > 0) return 0;
    
    new activeSlot;
    return Inventory_EquipItem(playerid, 58, invSlot, activeSlot);
}

stock ResetPlayerInventory(playerid)
{
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        g_PlayerInventory[playerid][i][inv_itemId] = 0;
        g_PlayerInventory[playerid][i][inv_itemCount] = 0;
        g_PlayerInventory[playerid][i][inv_itemSlot] = i;
        g_PlayerInventory[playerid][i][inv_itemPlate][0] = 0;
        g_PlayerInventory[playerid][i][inv_itemType] = 0;
        g_PlayerInventory[playerid][i][inv_itemWeight] = 0;
        g_PlayerInventory[playerid][i][inv_itemName][0] = 0;
        g_PlayerInventory[playerid][i][inv_itemActive] = false;
        g_PlayerInventory[playerid][i][inv_activeSlot] = -1;
    }
    
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        g_PlayerActiveSlots[playerid][i][inv_itemId] = 0;
        g_PlayerActiveSlots[playerid][i][inv_itemCount] = 0;
        g_PlayerActiveSlots[playerid][i][inv_itemSlot] = i;
        g_PlayerActiveSlots[playerid][i][inv_itemPlate][0] = 0;
        g_PlayerActiveSlots[playerid][i][inv_itemType] = 0;
        g_PlayerActiveSlots[playerid][i][inv_itemWeight] = 0;
        g_PlayerActiveSlots[playerid][i][inv_itemName][0] = 0;
        g_PlayerActiveSlots[playerid][i][inv_itemActive] = false;
        g_PlayerActiveSlots[playerid][i][inv_activeSlot] = -1;
    }
    
    g_PlayerWeight[playerid] = 0; 
}

/*stock strcpy(dest[], const source[], len = sizeof(dest))
{
    dest[0] = 0;
    strcat(dest, source, len);
}*/

stock FindSIMCardInInventory(playerid)
{
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] == 58)
        {
            return i;
        }
    }
    return -1;
}

stock Inventory_AddSIM(playerid, slot, phoneNumber)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    
    g_PlayerInventory[playerid][slot][inv_itemId] = 58;
    g_PlayerInventory[playerid][slot][inv_itemCount] = phoneNumber;
    g_PlayerInventory[playerid][slot][inv_itemSlot] = slot;
    g_PlayerInventory[playerid][slot][inv_itemPlate][0] = 0;
    g_PlayerInventory[playerid][slot][inv_itemType] = ITEM_TYPE_SIM;
    g_PlayerInventory[playerid][slot][inv_itemWeight] = GetItemWeight(58);
    GetItemName(58, g_PlayerInventory[playerid][slot][inv_itemName], 64);
    g_PlayerInventory[playerid][slot][inv_itemActive] = false;
    
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "INSERT INTO `player_inventory` (`player_id`, `slot`, `item_id`, `item_count`, `item_plate`, `is_active`, `active_slot`) VALUES (%d, %d, 58, %d, '', 0, -1)",
        GetPlayerAccountID(playerid), slot, phoneNumber);
    mysql_tquery(mysql, query);
    
    return 1;
}

stock Inventory_AddNumberPlate(playerid, slot, item_id, const plate_text[])
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    
    new plate_number = 0;
    for(new i = 0; plate_text[i] != EOS; i++)
    {
        plate_number = (plate_number * 37) + plate_text[i];
    }
    
    g_PlayerInventory[playerid][slot][inv_itemId] = item_id;
    g_PlayerInventory[playerid][slot][inv_itemCount] = plate_number;
    g_PlayerInventory[playerid][slot][inv_itemSlot] = slot;
    g_PlayerInventory[playerid][slot][inv_itemActive] = false;
    g_PlayerInventory[playerid][slot][inv_activeSlot] = -1;
    
    strcpy(g_PlayerInventory[playerid][slot][inv_itemPlate], plate_text, 32);
    
    g_PlayerInventory[playerid][slot][inv_itemType] = GetItemType(item_id);
    g_PlayerInventory[playerid][slot][inv_itemWeight] = GetItemWeight(item_id);
    GetItemName(item_id, g_PlayerInventory[playerid][slot][inv_itemName], 64);
    
    new itemWeight = GetItemWeight(item_id);
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + itemWeight);
    
    return 1;
}

// Проверка, занят ли слот аксессуара
stock IsAccessorySlotUsed(playerid, slot)
{
    return IsPlayerAttachedObjectSlotUsed(playerid, slot);
}

// Получение информации о предмете из инвентаря по item_id и слоту
stock Inventory_GetItemInfo(playerid, slot, &item_id, &count, item_plate[], plate_size = sizeof(item_plate))
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] == 0) return 0;
    
    item_id = g_PlayerInventory[playerid][slot][inv_itemId];
    count = g_PlayerInventory[playerid][slot][inv_itemCount];
    strcpy(item_plate, g_PlayerInventory[playerid][slot][inv_itemPlate], plate_size);
    
    return 1;
}

// Удаление предмета из инвентаря при использовании аксессуара
stock Inventory_RemoveAccessoryItem(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] == 0) return 0;
    
    new item_id = g_PlayerInventory[playerid][slot][inv_itemId];
    new count = g_PlayerInventory[playerid][slot][inv_itemCount];
    
    // Уменьшаем вес
    new itemWeight = GetItemWeight(item_id) * count;
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) - itemWeight);
    
    // Очищаем слот
    g_PlayerInventory[playerid][slot][inv_itemId] = 0;
    g_PlayerInventory[playerid][slot][inv_itemCount] = 0;
    g_PlayerInventory[playerid][slot][inv_itemSlot] = slot;
    g_PlayerInventory[playerid][slot][inv_itemPlate][0] = 0;
    g_PlayerInventory[playerid][slot][inv_itemType] = 0;
    g_PlayerInventory[playerid][slot][inv_itemWeight] = 0;
    g_PlayerInventory[playerid][slot][inv_itemName][0] = 0;
    g_PlayerInventory[playerid][slot][inv_itemActive] = false;
    
    // Удаляем из базы данных
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
        GetPlayerAccountID(playerid), slot);
    mysql_tquery(mysql, query);
    
    return 1;
}

stock GetAccessoryBoneByItemId(item_id)
{
    
    switch(item_id)
    {
        // ШЛЕМЫ (все на голову)
        case 383, 426, 427, 440, 601, 610, 612, 686, 730, 732, 750, 757, 914, 919, 923, 939,
        942, 950, 954, 998, 491, 8, 9, 10, 11, 12, 60, 61, 62,13, 14, 15, 16, 17, 289, 292, 293, 294, 298, 299, 300, 302, 303, 304, 305, 306,
        307, 313, 321, 322, 324, 326, 327, 348, 349, 367, 368, 370, 371, 372, 373, 374, 375,
        376, 425, 429, 430, 542, 543, 546, 547, 548, 581, 609, 611, 703, 706, 717, 883, 884,
        887, 889, 916, 917, 926, 928, 964, 986, 990, 992, 994, 1004, 1034, 
        48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78,
        79, 111, 112, 113, 114, 115, 145, 146, 147, 148, 149, 151, 152, 153, 154, 156, 157,
        158, 159, 161, 314, 315, 350, 351, 352, 353, 354, 355, 356, 357, 358, 391, 392, 393,
        394, 395, 396, 397, 398, 434, 435, 436, 437, 438, 439, 461, 466, 467, 471, 503, 504,
        505, 506, 507, 513, 514, 519, 520, 521, 522, 523, 524, 529, 530, 531, 532, 533, 534,
        551, 561, 563, 564, 567, 583, 587, 589, 590, 591, 647, 648, 649, 650, 651, 652, 653,
        655, 656, 660, 662, 663, 672, 673, 674, 675, 676, 677, 682, 690, 691, 695, 696, 707,
        710, 722, 736, 746, 747, 748, 753, 890, 930, 936, 946, 949, 953, 960, 965, 968,
        971, 988, 1000, 1002, 1027, 1043, 1044, 1046, 1050, 1051, 1058, 1062, 1067, 
        66, 67, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 102, 103, 104, 105, 106, 107,
        108, 109, 110, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 163, 164, 165, 166,
        167, 168, 169, 171, 172, 173, 174, 175, 176, 177, 178, 179, 181, 182, 183, 184, 185,
        186, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209,
        210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 221, 222, 223, 224, 225, 226, 250,
        251, 252, 253, 254, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278,
        279, 280, 282, 283, 284, 285, 286, 288, 295, 296, 297, 301, 308, 310, 311, 312, 319,
        325, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343,
        344, 362, 363, 364, 365, 366, 369, 384, 385, 386, 387, 388, 389, 399, 400, 401, 402,
        403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 419, 420, 421, 422, 423,
        424, 428, 443, 444, 445, 446, 463, 464, 465, 475, 496, 508, 526, 527, 528, 579, 580,
        584, 597, 599, 687, 694, 699, 720, 723, 725, 726, 731, 734, 735, 739, 740, 743, 751,
        755, 758, 759, 913, 918, 922, 958, 967, 977, 979, 982, 983, 984, 1013, 1019, 1023, 1069:
        {
            
            return 2;
        }
    }
    
    
    switch(item_id)
    {
        // СКЕЙТЫ (все на спину)
        case 38, 39, 40, 41, 458, 459, 460, 1, 2, 3, 6, 63, 64, 65, 135, 155, 160, 188, 189, 190, 191, 192, 193, 290, 291, 317,
        318, 447, 448, 449, 450, 490, 493, 494, 497, 498, 499, 500, 501, 502, 509, 511, 512,
        517, 518, 525, 536, 537, 538, 540, 541, 544, 545, 549, 550, 552, 553, 554, 555, 556,
        557, 560, 562, 565, 566, 568, 569, 570, 571, 572, 573, 574, 575, 578, 584, 588, 598,
        602, 603, 604, 605, 606, 607, 647, 657, 658, 659, 661, 664, 668, 669, 670, 678, 679,
        680, 683, 684, 685, 688, 689, 692, 693, 697, 700, 702, 704, 705, 708, 709, 711, 715,
        716, 719, 721, 728, 729, 733, 756, 877, 879, 880, 881, 886, 888, 891, 903, 912, 915,
        920, 924, 925, 927, 931, 932, 933, 937, 943, 944, 945, 948, 955, 956, 962, 963, 966,
        969, 970, 975, 976, 980, 981, 985, 987, 991, 995, 997, 999, 1001, 1003, 1014, 1015,
        1017, 1018, 1020, 1021, 1022, 1024, 1025, 1028, 1031, 1032, 1033, 1049, 1053, 1054,
        1056, 1057, 1063, 1065, 1066, 1068, 1073:
        {
            
            return 1;
        }
    }
    
    // =================================================================
    // КОСТЬ 6 - ПРАВАЯ РУКА (КЕЙСЫ и другие предметы в руке)
    // =================================================================
    switch(item_id)
    {
        // КЕЙСЫ (все в правую руку)
        case 359, 360, 361, 431, 432, 433, 518, 555, 557, 560, 716, 35, 36, 37, 150, 170, 220, 263, 264, 265, 281, 287, 323, 345, 346, 347,
        381, 382, 390, 441, 442, 451, 452, 453, 454, 455, 456, 457, 468, 469, 470,
        472, 473, 474, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 495,
        510, 538, 558, 559, 576, 577, 586, 595, 596, 600, 608, 631, 632, 633, 634, 635, 636,
        642, 643, 644, 645, 646, 654, 698, 713, 718, 724, 727, 741, 742, 745, 752, 754, 760,
        761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 773, 774, 775, 776, 777,
        778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791, 792, 793, 794,
        795, 796, 797, 798, 799, 800, 801, 802, 803, 804, 878, 882, 885, 892, 905, 906, 907,
        908, 909, 910, 911, 921, 934, 938, 940, 941, 950, 951, 952, 957, 959, 961, 972, 973,
        974, 978, 989, 993, 996, 1005, 1006, 1007, 1008, 1009, 1010, 1045, 1047, 1052, 1064,
        1075:
        {
            
            return 6;
        }
    }
    
    // =================================================================
    // КОСТЬ 5 - ЛЕВАЯ РУКА (Часы, браслеты)
    // =================================================================
    switch(item_id)
    {
        case 30, 31, 32, 33, 34:
        {
            
            return 5;
        }
    }
    
    // =================================================================
    // КОСТЬ 17 - ШЕЯ (Ожерелья, шарфы)
    // =================================================================
    switch(item_id)
    {
        // Шарфы и ожерелья
        case 96, 97, 98, 99, 100, 101, 255, 256, 257, 258, 259, 260, 261, 262, 320, 535,
        671, 935, 938, 941, 947, 990, 1030:
        {
            
            return 17;
        }
    }
    
    // =================================================================
    // КОСТЬ 4 - ПРАВОЕ ПЛЕЧО (Попугаи, животные)
    // =================================================================
    switch(item_id)
    {
        // Попугаи, совы на плечо
        case 960, 988, 1048, 377, 378, 379, 380:
        {
            
            return 4;
        }
    }
    
    // =================================================================
    // ПОЯСНЫЕ СУМКИ - на торс (кости 15/16 - ключицы/торс)
    // =================================================================
    switch(item_id)
    {
        // Поясные сумки (те, что на пояс/торс)
        case 4, 5, 7, 18, 19, 20, 42, 43, 44, 45, 46, 47, 550, 552, 553, 554, 556, 571,
        572, 575, 592, 593, 920, 952:
        {
            
            return 15;
        }
    }
    
    // =================================================================
    // КОСТЬ 8 - ПРАВОЕ БЕДРО
    // =================================================================
    switch(item_id)
    {
        // Колчан на ногу
        case 959:
        {
            
            return 8;
        }
    }
    
    
    return 1;
}

// Снятие аксессуара - перемещение из активного слота в обычный инвентарь
stock Inventory_UnequipAccessory(playerid, activeSlot, invSlot)
{
    if(activeSlot < 0 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS) return 0;
    
    // Проверяем, что в активном слоте есть предмет
    if(g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] == 0) return 0;
    
    // Проверяем, что целевой слот инвентаря свободен
    if(g_PlayerInventory[playerid][invSlot][inv_itemId] > 0) return 0;
    
    // Получаем данные аксессуара
    new item_id = g_PlayerActiveSlots[playerid][activeSlot][inv_itemId];
    new bone = g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount]; // Здесь хранится кость
    new plate[32];
    strcpy(plate, g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate], 32);
    
    
    
    // 1. Снимаем аксессуар с игрока (удаляем прикрепленный объект)
    RemovePlayerAttachedObject(playerid, activeSlot);
    
    // 2. Добавляем предмет в обычный инвентарь
    Inventory_SetItem(playerid, invSlot, item_id, 1, plate); // count = 1 для аксессуаров
    
    // 3. Очищаем активный слот
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemSlot] = activeSlot;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate][0] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemActive] = false;
    g_PlayerActiveSlots[playerid][activeSlot][inv_activeSlot] = -1;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemType] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemWeight] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemName][0] = 0;
    
    // 4. Удаляем из БД активного инвентаря
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `active_slot` = %d AND `is_active` = 1",
        GetPlayerAccountID(playerid), activeSlot);
    mysql_tquery(mysql, query);
    
    // 5. Сохраняем предмет в обычный инвентарь
    SaveInventoryItem(playerid, invSlot);
    
    // 6. Удаляем из таблицы аксессуаров (полностью удаляем запись)
    mysql_format(mysql, query, sizeof(query), 
        "DELETE FROM `accessories` WHERE `id` = %d AND `slot` = %d",
        GetPlayerAccountID(playerid), activeSlot);
    mysql_tquery(mysql, query);
    
    // 7. Добавляем вес предмета обратно в инвентарь
    new itemWeight = GetItemWeight(item_id);
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) + itemWeight);
    
    
    return 1;
}

stock GetBoneName(bone_id)
{
    switch(bone_id)
    {
        case 1: return "спине";
        case 2: return "голове";
        case 3: return "левом плече";
        case 4: return "правом плече";
        case 5: return "левой руке";
        case 6: return "правой руке";
        case 7: return "левом бедре";
        case 8: return "правом бедре";
        case 9: return "левой ноге";
        case 10: return "правой ноге";
        case 11: return "правой голени";
        case 12: return "левой голени";
        case 13: return "левом предплечье";
        case 14: return "правом предплечье";
        case 15: return "левой ключице";
        case 16: return "правой ключице";
        case 17: return "шее";
        case 18: return "лице";
        default: return "неизвестном месте";
    }
    return "";
}

stock GetItemNameById(item_id, name[], len = sizeof(name))
{
    switch(item_id)
    {
        case 1: format(name, len, "Рюкзак LV");
        case 2: format(name, len, "Рюкзак Puma");
        case 3: format(name, len, "Рюкзак Nike");
        case 4: format(name, len, "Поясная сумка Gucci");
        case 5: format(name, len, "Спортивная сумка Supreme");
        case 6: format(name, len, "Рюкзак Gucci");
        case 7: format(name, len, "Сумка Gucci");
        case 8: format(name, len, "Кепка Gucci");
        case 9: format(name, len, "Кепка Россия");
        case 10: format(name, len, "Кепка Спартак");
        case 11: format(name, len, "Кепка BlackRussia");
        case 12: format(name, len, "Кепка ЦСКА");
        case 13: format(name, len, "Авиаторы");
        case 14: format(name, len, "Маленькие авиаторы");
        case 15: format(name, len, "Черные очки");
        case 16: format(name, len, "Маленькие авиаторы черные");
        case 17: format(name, len, "Черные очки прозрачные");
        case 18: format(name, len, "Поясная сумка Nike");
        case 19: format(name, len, "Поясная сумка TheNorthFace");
        case 20: format(name, len, "Поясная сумка LV");
        default: format(name, len, "Аксессуар %d", item_id);
    }
    return 1;
}

stock ReloadPlayerAccessories(playerid)
{
    // Удаляем все текущие аксессуары
    for(new slot = 0; slot < 10; slot++)
    {
        RemovePlayerAttachedObject(playerid, slot);
    }
    
    // Загружаем заново из базы
    CreateAcs(playerid);
}

// Добавьте в Inventory.inc
stock Inventory_GetFreeAccessorySlot(playerid)
{
    // Ищем свободный активный слот (пропускаем SIM_SLOT=0 и SKIN_SLOT=6)
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(i == SKIN_SLOT) continue; // Пропускаем слот для скина
        
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] == 0)
        {
            return i;
        }
    }
    return -1;
}

// Проверка, можно ли надеть аксессуар (сначала определяем его кость, потом проверяем занята ли)
stock CanEquipAccessory(playerid, item_id)
{
    // 1. Сначала определяем, на какую кость надевается этот аксессуар
    new required_bone = GetAccessoryBoneByItemId(item_id);
    
    if(required_bone <= 0)
    {
        
        return 0;
    }
    
    
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;
    
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "SELECT COUNT(*) FROM `accessories` WHERE `id` = %d AND `bone` = %d", 
        account_id, required_bone);
    
    new Cache:result = mysql_query(mysql, query);
    new count = 0;
    
    if(cache_num_rows() > 0)
    {
        count = cache_get_field_content_int(0, "COUNT(*)");
    }
    cache_delete(result);
    
    if(count > 0)
    {
        
        return -1; // Кость занята
    }
    
    
    return required_bone; // Возвращаем номер кости, если свободна
}

stock LoadPlayerAccessoriesToActiveSlots(playerid)
{
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "SELECT * FROM `accessories` WHERE `id` = %d", 
        GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "OnLoadAccessoriesToActive", "i", playerid);
}

forward OnLoadAccessoriesToActive(playerid);
public OnLoadAccessoriesToActive(playerid)
{
    new rows = cache_num_rows();
    
    for(new i = 0; i < rows; i++)
    {
        new slot = cache_get_field_content_int(i, "slot");
        new modelid = cache_get_field_content_int(i, "modelid");
        new bone = cache_get_field_content_int(i, "bone");
        new Float:x = cache_get_field_content_float(i, "x");
        new Float:y = cache_get_field_content_float(i, "y");
        new Float:z = cache_get_field_content_float(i, "z");
        new Float:rX = cache_get_field_content_float(i, "rX");
        new Float:rY = cache_get_field_content_float(i, "rY");
        new Float:rZ = cache_get_field_content_float(i, "rZ");
        new Float:scale = cache_get_field_content_float(i, "scale");
        
        // Надеваем аксессуар с сохраненными координатами
        SetPlayerAttachedObject(playerid, slot, modelid, bone, x, y, z, rX, rY, rZ, scale, scale, scale, 0);
        
        // Находим item_id по model_id
        new item_id = Accessory_GetItemIdByModel(modelid);
        if(item_id != -1)
        {
            // БАГФИКС: слот крепления аксессуара (0-9) и функциональные активные слоты инвентаря (SIM_SLOT=0, SKIN_SLOT=6) - разные пространства индексов, которые тут случайно совпадали. Аксессуар в слоте 0 или 6 затирал данные симки/скина (item_id, count, type), из-за чего маркет путал скин с аксессуаром. В эти зарезервированные слоты аксессуары больше не пишутся (визуально они всё равно прикреплены выше через SetPlayerAttachedObject).
            if(slot == SIM_SLOT || slot == SKIN_SLOT)
            {
                continue;
            }

            if(slot >= 0 && slot < MAX_ACTIVE_SLOTS)
            {
                g_PlayerActiveSlots[playerid][slot][inv_itemId] = item_id;
                g_PlayerActiveSlots[playerid][slot][inv_itemCount] = bone; // В count храним кость
                g_PlayerActiveSlots[playerid][slot][inv_itemSlot] = slot;
                g_PlayerActiveSlots[playerid][slot][inv_itemPlate][0] = 0;
                g_PlayerActiveSlots[playerid][slot][inv_itemActive] = true;
                g_PlayerActiveSlots[playerid][slot][inv_activeSlot] = slot;
                g_PlayerActiveSlots[playerid][slot][inv_itemType] = ITEM_TYPE_ACCESSORY;
                g_PlayerActiveSlots[playerid][slot][inv_itemWeight] = GetItemWeight(item_id);
                GetItemNameById(item_id, g_PlayerActiveSlots[playerid][slot][inv_itemName], 64);
            }
        }
    }
    
    
}

stock ShowPlayerInventory(playerid)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
   	ShowNotificationSile(playerid, 2, 5, -1, -1, "Вы в транспорте.", "");
	   return 1;
	}
	
    new Node:itemsArray = JSON_Array();
    new Node:activeSlotsArray = JSON_Array();
    new Node:JSONObject = JSON_Object();
    new Node:tempArray;
    
    new skinid = GetPlayerSkin(playerid);
    new weight = GetPlayerWeight(playerid);
    new maxWeight = GetPlayerMaxWeight(playerid);
    new money = GetPlayerMoney(playerid);
    new level = GetPlayerLevel(playerid);
    new phoneNumber = GetPlayerPhone(playerid);
    
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] > 0)
        {
            new itemId = g_PlayerInventory[playerid][i][inv_itemId];
            
            if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83)
            {
                tempArray = JSON_Array(
                    JSON_Int(itemId),
                    JSON_String(g_PlayerInventory[playerid][i][inv_itemPlate]),
                    JSON_Int(i),
                    JSON_Int(0)
                );
            }
            else
            {
                tempArray = JSON_Array(
                    JSON_Int(itemId),
                    JSON_Int(g_PlayerInventory[playerid][i][inv_itemCount]), 
                    JSON_Int(i),
                    JSON_Int(0)
                );
            }
            
            if(strfind(g_PlayerInventory[playerid][i][inv_itemPlate], "VODO:", true) == 0)
            {
                JSON_SetString(tempArray, "nt", g_PlayerInventory[playerid][i][inv_itemName]);
            }
            
            itemsArray = JSON_Append(itemsArray, tempArray);
        }
    }
    
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            new itemId = g_PlayerActiveSlots[playerid][i][inv_itemId];
            new itemCount = g_PlayerActiveSlots[playerid][i][inv_itemCount];
            
            if(itemId == 134)
            {
                tempArray = JSON_Array(
                    JSON_Int(134),
                    JSON_Int(GetPlayerSkin(playerid)),
                    JSON_Int(6),
                    JSON_Int(0)
                );
            }
            else
            {
                tempArray = JSON_Array(
                    JSON_Int(itemId),
                    JSON_Int(itemCount),
                    JSON_Int(i),
                    JSON_Int(0)
                );
            }
            
            if(strlen(g_PlayerActiveSlots[playerid][i][inv_itemPlate]) > 0)
            {
                JSON_SetString(tempArray, "nt", g_PlayerActiveSlots[playerid][i][inv_itemPlate]);
            }
            
            activeSlotsArray = JSON_Append(activeSlotsArray, tempArray);
        }
    }
    
    JSONObject = JSON_Object
    (
        "o", JSON_Int(1),
        "i", JSON_Int(0),
        "n", JSON_String(GetPlayerNameEx(playerid)),
        "lv", JSON_Int(level),
        "id", JSON_Int(playerid),
        "v", JSON_Int(3),
        "ps", JSON_Int(skinid),
        "m", JSON_Int(money),
        "s", JSON_Int(79),
        "w", JSON_Int(weight),
        "mw", JSON_Int(maxWeight),
        "sl", JSON_Int(MAX_INVENTORY_SLOTS),
        "nm", JSON_Int(phoneNumber),
        "en", JSON_String(""),
        "it", itemsArray,
        "ai", activeSlotsArray
    );
    
    SendPacketToClient(playerid, 33, JSONObject);
    
    JSON_Cleanup(itemsArray);
    JSON_Cleanup(activeSlotsArray);
    JSON_Cleanup(JSONObject);
    
    return 1;
}

CMD:inv(playerid, params[])
{
    ShowPlayerInventory(playerid);
    return 1;
} 

stock ShowPlayerNewInventory(playerid)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
   	ShowNotificationSile(playerid, 2, 5, -1, -1, "Вы в транспорте.", "");
	   return 1;
	}
	
    new Node:itemsArray = JSON_Array();
    new Node:activeSlotsArray = JSON_Array();
    new Node:JSONObject = JSON_Object();
    new Node:tempArray;
    
    new skinid = GetPlayerSkin(playerid);
    new weight = GetPlayerWeight(playerid);
    new maxWeight = GetPlayerMaxWeight(playerid);
    new money = GetPlayerMoney(playerid);
    new level = GetPlayerLevel(playerid);
    new phoneNumber = GetPlayerPhone(playerid);
    
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] > 0)
        {
            new itemId = g_PlayerInventory[playerid][i][inv_itemId];
            
            if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83)
            {
                tempArray = JSON_Array(
                    JSON_Int(itemId),
                    JSON_String(g_PlayerInventory[playerid][i][inv_itemPlate]),
                    JSON_Int(i),
                    JSON_Int(0)
                );
            }
            else
            {
                tempArray = JSON_Array(
                    JSON_Int(itemId),
                    JSON_Int(g_PlayerInventory[playerid][i][inv_itemCount]), 
                    JSON_Int(i),
                    JSON_Int(0)
                );
            }
            
            if(strfind(g_PlayerInventory[playerid][i][inv_itemPlate], "VODO:", true) == 0)
            {
                JSON_SetString(tempArray, "nt", g_PlayerInventory[playerid][i][inv_itemName]);
            }
            
            itemsArray = JSON_Append(itemsArray, tempArray);
        }
    }
    
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            new itemId = g_PlayerActiveSlots[playerid][i][inv_itemId];
            new itemCount = g_PlayerActiveSlots[playerid][i][inv_itemCount];
            
            if(itemId == 134)
            {
                tempArray = JSON_Array(
                    JSON_Int(134),
                    JSON_Int(GetPlayerSkin(playerid)),
                    JSON_Int(6),
                    JSON_Int(0)
                );
            }
            else
            {
                tempArray = JSON_Array(
                    JSON_Int(itemId),
                    JSON_Int(itemCount),
                    JSON_Int(i),
                    JSON_Int(0)
                );
            }
            
            if(strlen(g_PlayerActiveSlots[playerid][i][inv_itemPlate]) > 0)
            {
                JSON_SetString(tempArray, "nt", g_PlayerActiveSlots[playerid][i][inv_itemPlate]);
            }
            
            activeSlotsArray = JSON_Append(activeSlotsArray, tempArray);
        }
    }
    
    JSONObject = JSON_Object
    (
        "o", JSON_Int(1),
        "i", JSON_Int(0),
        "n", JSON_String(GetPlayerNameEx(playerid)),
        "lv", JSON_Int(level),
        "id", JSON_Int(playerid),
        "v", JSON_Int(3),
        "ps", JSON_Int(skinid),
        "m", JSON_Int(money),
        "s", JSON_Int(79),
        "w", JSON_Int(weight),
        "mw", JSON_Int(maxWeight),
        "sl", JSON_Int(MAX_INVENTORY_SLOTS),
        "nm", JSON_Int(phoneNumber),
        "en", JSON_String(""),
        "it", itemsArray,
        "ai", activeSlotsArray
    );
    
    SendPacketToClient(playerid, 33, JSONObject);
    
    JSON_Cleanup(itemsArray);
    JSON_Cleanup(activeSlotsArray);
    JSON_Cleanup(JSONObject);
    
    return 1;
}

CMD:invnew(playerid, params[])
{
    ShowPlayerNewInventory(playerid);
    return 1;
} 

CMD:giveitem(playerid, params[])
{
if(strcmp(GetPlayerNameEx(playerid), "Danya_Coder", true) != 0) return ShowNotificationSile(playerid, 2, 6, -1, -1, "Введенная вами команда не найдена", "");
    new to_player, item_id, count;
    
    if(sscanf(params, "uii", to_player, item_id, count))
    {
        SendClientMessage(playerid, -1, "Использование: /giveitem [playerid] [item_id] [count]");
        return 1;
    }
    
    if(!IsPlayerConnected(to_player))
    {
        SendClientMessage(playerid, -1, "Игрок не найден");
        return 1;
    }
    
    if(item_id == 134)
    {
        if(!IsValidSkinModel(count))
        {
            new msg[128];
            format(msg, sizeof(msg), "Модель скина %d не найдена в базе", count);
            SendClientMessage(playerid, -1, msg);
            return 1;
        }
    }
    
    new freeSlot = Inventory_GetFreeSlot(to_player);
    if(freeSlot == -1)
    {
        SendClientMessage(playerid, -1, "У игрока нет свободных слотов");
        return 1;
    }
    
    new plate[32] = "";
    
    if(item_id == 59 || item_id == 81 || item_id == 82 || item_id == 83)
    {
        format(plate, sizeof(plate), "a777aa 777");
    }
    
    if(item_id == 58)
    {
        new phoneNumber = 1000000 + random(9000000);
        format(plate, sizeof(plate), "%d", phoneNumber);
    }
    
    Inventory_AddItem(to_player, item_id, freeSlot, count, plate);
    
    new itemName[64];
    GetItemName(item_id, itemName);
    
    new msg[128];
    format(msg, sizeof(msg), "Вы выдали %s предмет %s (слот %d)", 
        GetPlayerNameEx(to_player), itemName, freeSlot);
    
    if(item_id == 134)
    {
        format(msg, sizeof(msg), "Вы выдали %s скин с моделью %d (слот %d)", 
            GetPlayerNameEx(to_player), count, freeSlot);
    }
    
    SendClientMessage(playerid, -1, msg);
    
    return 1;
}

stock SplitString(const source[], delimiter, output[][], output_size, max_part_len = 32)
{
    new part_count = 0;
    new start = 0;
    new end = -1;
    new len = strlen(source);
  
    new delim_str[2];
    delim_str[0] = delimiter;
    delim_str[1] = '\0';
    
    while(part_count < output_size && start < len)
    {
        end = strfind(source, delim_str, start);
        
        if(end == -1)
        {
            strmid(output[part_count], source, start, len, max_part_len);
            part_count++;
            break;
        }
        if(end > start)
        {
            strmid(output[part_count], source, start, end, max_part_len);
            part_count++;
        }
        
        start = end + 1;
    }
    
    return part_count;
}

stock SplitStringManual(const source[], delimiter, output[][], output_size, max_part_len = 32)
{
    new part_count = 0;
    new start = 0;
    new len = strlen(source);
    new idx = 0;
    
    while(part_count < output_size && start < len)
    {
        new end = -1;
        for(new i = start; i < len; i++)
        {
            if(source[i] == delimiter)
            {
                end = i;
                break;
            }
        }
        
        if(end == -1)
        {
            strmid(output[part_count], source, start, len, max_part_len);
            part_count++;
            break;
        }
    
        if(end > start)
        {
            strmid(output[part_count], source, start, end, max_part_len);
            part_count++;
        }
        
        start = end + 1;
    }
    
    return part_count;
}
stock SplitPlate(const plate[], plate_text[], plate_text_len, plate_region[], plate_region_len)
{
    new parts[2][32];
    new count = SplitStringManual(plate, ' ', parts, 2);
    
    if(count >= 1)
    {
        strcpy(plate_text, parts[0], plate_text_len);
        
        if(count >= 2)
        {
            strcpy(plate_region, parts[1], plate_region_len);
        }
        else
        {
            plate_region[0] = '\0';
        }
        
        return count;
    }
    
    plate_text[0] = '\0';
    plate_region[0] = '\0';
    return 0;
}

stock JoinPlate(const plate_text[], plate_number[], output[], output_len)
{
    format(output, output_len, "%s %s", plate_text, plate_number);
    return 1;
}

// ==================== ТРЕЙД МЕЖДУ ИГРОКАМИ (Inv11Trade) ====================
// Перенесено из black-russia.pwn (система Inv11Trade_*) и адаптировано под
// инвентарь этого проекта (Inventory_* / g_PlayerInventory, MAX_INVENTORY_SLOTS)
// и GUI-протокол этого проекта: клиент -> сервер приходит опкодом 34
// (см. nexus.pwn, case 34 в IPacket:253), сервер -> клиент уходит через
// SendPacketToClient(playerid, 33, ...) — тем же каналом, которым уже
// отправляется обычный снапшот инвентаря (см. ShowPlayerNewInventory).
//
// Точки подключения в nexus.pwn:
//   - case 34 (IPacket:253): Inv11Trade_OnGuiPacket(playerid, JSONObject)
//   - case 13 (notify-клики): Inv11Trade_HandleNotifyClick(playerid, id, sub_id)
//   - OnDialogResponse: Inv11Trade_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)
//   - OnPlayerDisconnect: Inv11Trade_OnDisconnect(playerid)

#define DIALOG_INV11_TRADE_SELECT 34110
#define DIALOG_INV11_TRADE_CONFIRM 34111

#define INV11_TRADE_NEARBY_MAX 64
#define INV11_TRADE_NEAR_RANGE (5.0)
#define INV11_TRADE_INVITE_TIMEOUT 30
#define INV11_TRADE_MAX_MONEY 20000000
#define INV11_TRADE_CLOSE_GRACE 3

enum E_INV11_TRADE_OFFER
{
    INV11_TRADE_OFFER_USED,
    INV11_TRADE_OFFER_ITEM_ID,
    INV11_TRADE_OFFER_AMOUNT,
    INV11_TRADE_OFFER_PLATE[32]
}

new g_inv11_trade_dialog_count[MAX_PLAYERS];
new g_inv11_trade_dialog_target[MAX_PLAYERS][INV11_TRADE_NEARBY_MAX];

new g_inv11_trade_invite_from[MAX_PLAYERS] = {-1, ...};
new g_inv11_trade_invite_to[MAX_PLAYERS] = {-1, ...};
new g_inv11_trade_invite_time[MAX_PLAYERS];

new g_inv11_trade_partner[MAX_PLAYERS] = {-1, ...};
new bool:g_inv11_trade_active[MAX_PLAYERS];
new bool:g_inv11_trade_starting[MAX_PLAYERS];
new bool:g_inv11_trade_apply[MAX_PLAYERS];
new bool:g_inv11_trade_confirm[MAX_PLAYERS];
new g_inv11_trade_money[MAX_PLAYERS];
new g_inv11_trade_offer[MAX_PLAYERS][MAX_INVENTORY_SLOTS][E_INV11_TRADE_OFFER];
new g_inv11_trade_started_at[MAX_PLAYERS];

// ---------- сброс состояния ----------

stock Inv11Trade_ResetOfferSlot(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;

    g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_USED] = 0;
    g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_ITEM_ID] = 0;
    g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT] = 0;
    g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_PLATE][0] = 0;
    return 1;
}

stock Inv11Trade_ClearOffers(playerid)
{
    for(new slot = 0; slot < MAX_INVENTORY_SLOTS; slot++)
    {
        Inv11Trade_ResetOfferSlot(playerid, slot);
    }
    return 1;
}

stock Inv11Trade_ResetInvite(playerid)
{
    g_inv11_trade_invite_from[playerid] = -1;
    g_inv11_trade_invite_to[playerid] = -1;
    g_inv11_trade_invite_time[playerid] = 0;

    g_inv11_trade_dialog_count[playerid] = 0;
    for(new i = 0; i < INV11_TRADE_NEARBY_MAX; i++)
    {
        g_inv11_trade_dialog_target[playerid][i] = -1;
    }
    return 1;
}

stock Inv11Trade_ResetSession(playerid)
{
    g_inv11_trade_active[playerid] = false;
    g_inv11_trade_starting[playerid] = false;
    g_inv11_trade_apply[playerid] = false;
    g_inv11_trade_confirm[playerid] = false;
    g_inv11_trade_money[playerid] = 0;
    g_inv11_trade_partner[playerid] = -1;
    g_inv11_trade_started_at[playerid] = 0;
    Inv11Trade_ClearOffers(playerid);
    return 1;
}

stock Inv11Trade_ResetPlayer(playerid)
{
    Inv11Trade_ResetInvite(playerid);
    Inv11Trade_ResetSession(playerid);
    return 1;
}

// ---------- вспомогательные проверки ----------

stock bool:Inv11Trade_IsTradeItem(item_id)
{
    return (item_id > 0);
}

stock bool:Inv11Trade_IsStackableItem(item_id)
{
    if(item_id <= 0) return false;
    if(item_id == 58 || item_id == 134) return false; // SIM-карта / скин — уникальный предмет
    new type = GetItemType(item_id);
    if(type == ITEM_TYPE_PLATE || type == ITEM_TYPE_ACCESSORY) return false;
    return true;
}

stock Float:Inv11Trade_GetDistance(playerid, targetid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    return GetPlayerDistanceFromPoint(targetid, x, y, z);
}

stock bool:Inv11Trade_IsNear(playerid, targetid, Float:range = INV11_TRADE_NEAR_RANGE)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return false;
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || GetPlayerState(targetid) != PLAYER_STATE_ONFOOT) return false;
    return (Inv11Trade_GetDistance(playerid, targetid) <= range);
}

// В этом инвентаре "count" уже хранит значение, которое клиенту нужно
// показать вместо количества (модель скина для item_id 134, номер телефона
// для SIM-карты и т.д.) — см. ShowPlayerNewInventory. Поэтому для трейда
// достаточно переносить это значение как есть.
stock Inv11Trade_GetExchangeValue(item_id, count)
{
    #pragma unused item_id
    return count;
}

// ---------- чтение слотов инвентаря / офферов ----------

stock bool:Inv11Trade_InventorySlotMatches(playerid, item_id, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return false;
    return (Inventory_GetItemID(playerid, slot) == item_id);
}

stock Inv11Trade_ResolveInventorySlot(playerid, item_id, raw_s, raw_os, raw_sl)
{
    if(raw_os >= 0 && Inv11Trade_InventorySlotMatches(playerid, item_id, raw_os)) return raw_os;
    if(raw_sl >= 0 && Inv11Trade_InventorySlotMatches(playerid, item_id, raw_sl)) return raw_sl;
    if(raw_s >= 0 && Inv11Trade_InventorySlotMatches(playerid, item_id, raw_s)) return raw_s;

    // Совместимость со старыми пакетами клиента — ищем по всему инвентарю.
    for(new slot = 0; slot < MAX_INVENTORY_SLOTS; slot++)
    {
        if(Inv11Trade_InventorySlotMatches(playerid, item_id, slot)) return slot;
    }
    return -1;
}

stock bool:Inv11Trade_OfferSlotMatches(playerid, item_id, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return false;
    if(!g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_USED]) return false;
    return (g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_ITEM_ID] == item_id);
}

stock Inv11Trade_ResolveOfferSlot(playerid, item_id, raw_s, raw_os, raw_sl)
{
    if(raw_os >= 0 && Inv11Trade_OfferSlotMatches(playerid, item_id, raw_os)) return raw_os;
    if(raw_sl >= 0 && Inv11Trade_OfferSlotMatches(playerid, item_id, raw_sl)) return raw_sl;
    if(raw_s >= 0 && Inv11Trade_OfferSlotMatches(playerid, item_id, raw_s)) return raw_s;

    for(new slot = 0; slot < MAX_INVENTORY_SLOTS; slot++)
    {
        if(Inv11Trade_OfferSlotMatches(playerid, item_id, slot)) return slot;
    }
    return -1;
}

// ---------- пакеты к клиенту (канал 33, как и обычный снапшот инвентаря) ----------

stock Inv11Trade_SendStatus(playerid, status)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new Node:resp = JSON_Object();
    JSON_SetInt(resp, "t", 7);
    JSON_SetInt(resp, "s", status);
    SendPacketToClient(playerid, 33, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock Inv11Trade_SendBothApplied(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new Node:resp = JSON_Object();
    JSON_SetInt(resp, "t", 26);
    SendPacketToClient(playerid, 33, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock Inv11Trade_SendOpenExchange(playerid, targetid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;

    new Node:resp = JSON_Object();
    JSON_SetInt(resp, "t", 17);
    JSON_SetString(resp, "en", GetPlayerNameEx(targetid));
    SendPacketToClient(playerid, 33, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock Inv11Trade_SendPartnerItem(playerid, packet_type, item_id, item_value, const plate_text[])
{
    if(!IsPlayerConnected(playerid)) return 0;

    new Node:resp = JSON_Object();
    JSON_SetInt(resp, "t", packet_type);
    JSON_SetInt(resp, "ga", item_id);
    JSON_SetInt(resp, "s", item_value);
    if(strlen(plate_text))
    {
        new plate[32];
        strcpy(plate, plate_text, 32);
        JSON_SetString(resp, "nt", plate);
    }
    SendPacketToClient(playerid, 33, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock Inv11Trade_SendPartnerMoney(playerid, money_value)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new Node:resp = JSON_Object();
    JSON_SetInt(resp, "t", 3);
    JSON_SetInt(resp, "gm", money_value);
    SendPacketToClient(playerid, 33, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock Inv11Trade_ResetApplyState(playerid, targetid)
{
    new had_apply = 0;
    if(g_inv11_trade_apply[playerid] || g_inv11_trade_apply[targetid] || g_inv11_trade_confirm[playerid] || g_inv11_trade_confirm[targetid])
    {
        had_apply = 1;
    }

    g_inv11_trade_apply[playerid] = false;
    g_inv11_trade_apply[targetid] = false;
    g_inv11_trade_confirm[playerid] = false;
    g_inv11_trade_confirm[targetid] = false;

    if(had_apply)
    {
        Inv11Trade_SendStatus(playerid, 2);
        Inv11Trade_SendStatus(targetid, 2);
    }
    return 1;
}

stock Inv11Trade_EndSession(playerid, targetid, status_player = 4, status_target = 4)
{
    if(IsPlayerConnected(playerid)) Inv11Trade_SendStatus(playerid, status_player);
    if(IsPlayerConnected(targetid)) Inv11Trade_SendStatus(targetid, status_target);

    Inv11Trade_ResetSession(playerid);
    Inv11Trade_ResetSession(targetid);
    return 1;
}

forward Inv11Trade_DelayedOpenExchange(playerid, targetid);
public Inv11Trade_DelayedOpenExchange(playerid, targetid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid))
    {
        if(IsPlayerConnected(playerid)) Inv11Trade_ResetSession(playerid);
        if(IsPlayerConnected(targetid)) Inv11Trade_ResetSession(targetid);
        return 1;
    }

    if(!g_inv11_trade_active[playerid] || !g_inv11_trade_active[targetid] ||
        g_inv11_trade_partner[playerid] != targetid || g_inv11_trade_partner[targetid] != playerid)
    {
        g_inv11_trade_starting[playerid] = false;
        g_inv11_trade_starting[targetid] = false;
        return 1;
    }

    // GUI инвентаря ещё может открываться на клиенте — небольшая пауза перед
    // отправкой t=17, иначе некоторые сборки клиента теряют этот пакет.
    Inv11Trade_SendOpenExchange(playerid, targetid);
    Inv11Trade_SendOpenExchange(targetid, playerid);

    g_inv11_trade_starting[playerid] = false;
    g_inv11_trade_starting[targetid] = false;

    printf("[TRADE] exchange gui opened: %d <-> %d", playerid, targetid);
    return 1;
}

stock bool:Inv11Trade_StartSession(playerid, targetid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return false;
    if(g_inv11_trade_active[playerid] || g_inv11_trade_active[targetid]) return false;

    Inv11Trade_ResetSession(playerid);
    Inv11Trade_ResetSession(targetid);

    g_inv11_trade_invite_from[playerid] = -1;
    g_inv11_trade_invite_from[targetid] = -1;
    g_inv11_trade_invite_to[playerid] = -1;
    g_inv11_trade_invite_to[targetid] = -1;
    g_inv11_trade_invite_time[playerid] = 0;
    g_inv11_trade_invite_time[targetid] = 0;

    g_inv11_trade_active[playerid] = true;
    g_inv11_trade_active[targetid] = true;
    g_inv11_trade_partner[playerid] = targetid;
    g_inv11_trade_partner[targetid] = playerid;
    g_inv11_trade_started_at[playerid] = gettime();
    g_inv11_trade_started_at[targetid] = g_inv11_trade_started_at[playerid];
    g_inv11_trade_starting[playerid] = true;
    g_inv11_trade_starting[targetid] = true;

    ShowPlayerNewInventory(playerid);
    ShowPlayerNewInventory(targetid);

    SetTimerEx("Inv11Trade_DelayedOpenExchange", 250, false, "ii", playerid, targetid);
    return true;
}

// ---------- перенос предметов между "моя сторона" / "витрина обмена" ----------
// Предмет физически остаётся в инвентаре игрока, пока сделка не подтверждена
// обеими сторонами — g_inv11_trade_offer лишь помечает, сколько из слота
// выставлено на обмен. Реальный перенос происходит в Inv11Trade_Finalize.

stock bool:Inv11Trade_MoveInvToExchange(playerid, item_id, slot, req_amount, Node:response)
{
    JSON_SetInt(response, "t", 5);
    JSON_SetInt(response, "w", GetPlayerWeight(playerid));

    if(!g_inv11_trade_active[playerid])
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    new targetid = g_inv11_trade_partner[playerid];
    if(targetid == -1 || !IsPlayerConnected(targetid))
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS)
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    new inv_item_id, inv_count;
    new plate[32];
    if(!Inventory_GetItemInfo(playerid, slot, inv_item_id, inv_count, plate))
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    if(inv_item_id != item_id || !Inv11Trade_IsTradeItem(inv_item_id))
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    new send_value = inv_count;
    new bool:stackable = Inv11Trade_IsStackableItem(inv_item_id);

    if(stackable)
    {
        new already_offered = g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_USED] ? g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT] : 0;
        new move_amount = req_amount;
        if(move_amount <= 0) move_amount = 1;
        if(move_amount > inv_count - already_offered) move_amount = inv_count - already_offered;

        if(move_amount <= 0)
        {
            JSON_SetInt(response, "s", 0);
            return false;
        }

        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_USED] = 1;
        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_ITEM_ID] = inv_item_id;
        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT] = already_offered + move_amount;
        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_PLATE][0] = 0;

        send_value = move_amount;
    }
    else
    {
        if(g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_USED])
        {
            JSON_SetInt(response, "s", 0);
            return false;
        }

        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_USED] = 1;
        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_ITEM_ID] = inv_item_id;
        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT] = 1;
        strcpy(g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_PLATE], plate, 32);

        send_value = Inv11Trade_GetExchangeValue(inv_item_id, inv_count);
    }

    JSON_SetInt(response, "s", 1);
    Inv11Trade_SendPartnerItem(targetid, 0, inv_item_id, send_value, plate);
    Inv11Trade_ResetApplyState(playerid, targetid);

    printf("[TRADE] inv->exchange: player=%d target=%d slot=%d item=%d val=%d", playerid, targetid, slot, inv_item_id, send_value);
    return true;
}

stock bool:Inv11Trade_MoveExchangeToInv(playerid, item_id, slot, req_amount, Node:response)
{
    JSON_SetInt(response, "t", 24);
    JSON_SetInt(response, "w", GetPlayerWeight(playerid));

    if(!g_inv11_trade_active[playerid])
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    new targetid = g_inv11_trade_partner[playerid];
    if(targetid == -1 || !IsPlayerConnected(targetid))
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS || !g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_USED] ||
        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_ITEM_ID] != item_id)
    {
        JSON_SetInt(response, "s", 0);
        return false;
    }

    new send_value;
    new plate[32];
    strcpy(plate, g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_PLATE], 32);

    if(Inv11Trade_IsStackableItem(item_id))
    {
        new offered = g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT];
        new move_amount = req_amount;
        if(move_amount <= 0 || move_amount > offered) move_amount = offered;

        g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT] = offered - move_amount;
        if(g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT] <= 0)
        {
            Inv11Trade_ResetOfferSlot(playerid, slot);
        }

        send_value = move_amount;
    }
    else
    {
        send_value = Inv11Trade_GetExchangeValue(item_id, g_inv11_trade_offer[playerid][slot][INV11_TRADE_OFFER_AMOUNT]);
        Inv11Trade_ResetOfferSlot(playerid, slot);
    }

    JSON_SetInt(response, "s", 1);
    Inv11Trade_SendPartnerItem(targetid, 1, item_id, send_value, plate);
    Inv11Trade_ResetApplyState(playerid, targetid);

    printf("[TRADE] exchange->inv: player=%d target=%d slot=%d item=%d val=%d", playerid, targetid, slot, item_id, send_value);
    return true;
}

// ---------- завершение сделки ----------

stock bool:Inv11Trade_TransferDirection(fromid, toid)
{
    for(new slot = 0; slot < MAX_INVENTORY_SLOTS; slot++)
    {
        if(!g_inv11_trade_offer[fromid][slot][INV11_TRADE_OFFER_USED]) continue;

        new item_id = g_inv11_trade_offer[fromid][slot][INV11_TRADE_OFFER_ITEM_ID];
        new offer_amount = g_inv11_trade_offer[fromid][slot][INV11_TRADE_OFFER_AMOUNT];

        new cur_item_id, cur_count;
        new cur_plate[32];
        if(!Inventory_GetItemInfo(fromid, slot, cur_item_id, cur_count, cur_plate) || cur_item_id != item_id || cur_count < offer_amount)
        {
            printf("[TRADE][ERROR] TransferDirection desync: player=%d slot=%d item=%d", fromid, slot, item_id);
            return false;
        }

        new free_slot = Inventory_GetFreeSlot(toid);
        if(free_slot == -1)
        {
            printf("[TRADE][ERROR] TransferDirection no free slot: from=%d to=%d item=%d", fromid, toid, item_id);
            return false;
        }

        new itemWeight = GetItemWeight(item_id) * offer_amount;
        if(GetPlayerWeight(toid) + itemWeight > GetPlayerMaxWeight(toid))
        {
            printf("[TRADE][ERROR] TransferDirection overweight: from=%d to=%d item=%d", fromid, toid, item_id);
            return false;
        }

        new plate[32];
        strcpy(plate, g_inv11_trade_offer[fromid][slot][INV11_TRADE_OFFER_PLATE], 32);

        if(Inv11Trade_IsStackableItem(item_id))
        {
            if(!Inventory_RemoveItem(fromid, slot, offer_amount))
            {
                printf("[TRADE][ERROR] TransferDirection remove failed: player=%d slot=%d item=%d", fromid, slot, item_id);
                return false;
            }
            Inventory_AddItem(toid, item_id, free_slot, offer_amount, "");
        }
        else
        {
            Inventory_DeleteItem(fromid, slot);
            Inventory_AddItem(toid, item_id, free_slot, cur_count, plate);
        }

        SetPlayerWeight(toid, GetPlayerWeight(toid) + itemWeight);
        SaveInventoryItem(toid, free_slot);

        Inv11Trade_ResetOfferSlot(fromid, slot);
    }

    return true;
}

stock bool:Inv11Trade_Finalize(playerid, targetid)
{
    new money_player = g_inv11_trade_money[playerid];
    new money_target = g_inv11_trade_money[targetid];

    if(money_player > 0 && GetPlayerMoneyEx(playerid) < money_player) return false;
    if(money_target > 0 && GetPlayerMoneyEx(targetid) < money_target) return false;

    if(!Inv11Trade_TransferDirection(playerid, targetid)) return false;
    if(!Inv11Trade_TransferDirection(targetid, playerid)) return false;

    if(money_player > 0)
    {
        GivePlayerMoneyEx(playerid, -money_player, "Трейд", true, false);
        GivePlayerMoneyEx(targetid, money_player, "Трейд", true, false);
    }
    if(money_target > 0)
    {
        GivePlayerMoneyEx(targetid, -money_target, "Трейд", true, false);
        GivePlayerMoneyEx(playerid, money_target, "Трейд", true, false);
    }

    return true;
}

// ---------- отключение / клик по уведомлению / диалог приглашения ----------

stock Inv11Trade_OnDisconnect(playerid)
{
    new partner = g_inv11_trade_partner[playerid];
    if(partner != -1 && g_inv11_trade_active[playerid])
    {
        if(IsPlayerConnected(partner))
        {
            Inv11Trade_SendStatus(partner, 4);
            Inv11Trade_ResetSession(partner);
        }
    }

    new invite_to = g_inv11_trade_invite_to[playerid];
    if(invite_to != -1 && IsPlayerConnected(invite_to) && g_inv11_trade_invite_from[invite_to] == playerid)
    {
        g_inv11_trade_invite_from[invite_to] = -1;
        g_inv11_trade_invite_time[invite_to] = 0;
    }

    new invite_from = g_inv11_trade_invite_from[playerid];
    if(invite_from != -1 && IsPlayerConnected(invite_from) && g_inv11_trade_invite_to[invite_from] == playerid)
    {
        g_inv11_trade_invite_to[invite_from] = -1;
    }

    Inv11Trade_ResetPlayer(playerid);
    return 1;
}

stock bool:Inv11Trade_OpenNearbyDialog(playerid)
{
    if(g_inv11_trade_active[playerid])
    {
        ShowNotificationSile(playerid, 2, 6, 0, 0, "Вы уже участвуете в трейде", " ");
        return false;
    }

    g_inv11_trade_dialog_count[playerid] = 0;
    for(new i = 0; i < INV11_TRADE_NEARBY_MAX; i++)
    {
        g_inv11_trade_dialog_target[playerid][i] = -1;
    }

    new list_text[4096];
    list_text[0] = 0;

    new count = 0;
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(i == playerid) continue;
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        if(g_inv11_trade_active[i]) continue;

        new Float:dist = Inv11Trade_GetDistance(playerid, i);
        if(dist > INV11_TRADE_NEAR_RANGE) continue;

        if(count >= INV11_TRADE_NEARBY_MAX) break;

        g_inv11_trade_dialog_target[playerid][count] = i;

        new line_text[128];
        format(line_text, sizeof(line_text), "%d. %s[%d] - %.1f м.\n", count + 1, GetPlayerNameEx(i), i, dist);
        strcat(list_text, line_text, sizeof(list_text));

        count++;
    }

    g_inv11_trade_dialog_count[playerid] = count;

    if(count <= 0)
    {
        ShowNotificationSile(playerid, 2, 6, 0, 0, "Подходящих игроков для трейда поблизости - нет.", " ");
        return false;
    }

    ShowPlayerDialog(playerid, DIALOG_INV11_TRADE_SELECT, DIALOG_STYLE_LIST, "{FF0000}Трейд", list_text, "Далее", "Выйти");
    return true;
}

stock bool:Inv11Trade_HandleNotifyClick(playerid, notify_id, notify_sub_id)
{
    new inviter = g_inv11_trade_invite_from[playerid];
    printf("[TRADE DEBUG] NotifyClick: playerid=%d notify_id=%d notify_sub_id=%d inviter=%d", playerid, notify_id, notify_sub_id, inviter);
    if(inviter == -1) return false;

    if(inviter != notify_id && inviter != notify_sub_id) return false;

    if(!IsPlayerConnected(inviter) || !IsPlayerLogged(inviter))
    {
        Inv11Trade_ResetInvite(playerid);
        ShowNotificationSile(playerid, 2, 6, 0, 0, "Игрок недоступен", " ");
        return true;
    }

    if(gettime() - g_inv11_trade_invite_time[playerid] > INV11_TRADE_INVITE_TIMEOUT)
    {
        Inv11Trade_ResetInvite(playerid);
        ShowNotificationSile(playerid, 2, 6, 0, 0, "Предложение трейда устарело", " ");
        return true;
    }

    new dialog_text[144];
    format(dialog_text, sizeof(dialog_text), "Игрок %s предлагает Вам трейд, Вы согласны?", GetPlayerNameEx(inviter));
    ShowPlayerDialog(playerid, DIALOG_INV11_TRADE_CONFIRM, DIALOG_STYLE_MSGBOX, "{FF0000}Трейд", dialog_text, "Далее", "Отмена");
    return true;
}

// Общая логика отправки приглашения на трейд (используется и списком рядом стоящих, и командой /trade)
stock bool:Inv11Trade_SendInvite(playerid, targetid)
{
    if(targetid == -1 || !IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
    {
        ShowNotificationSile(playerid, 2, 6, 0, 0, "Игрок недоступен", " ");
        return false;
    }

    if(targetid == playerid)
    {
        ShowNotificationSile(playerid, 2, 6, 0, 0, "Нельзя предложить трейд самому себе", " ");
        return false;
    }

    if(!Inv11Trade_IsNear(playerid, targetid, INV11_TRADE_NEAR_RANGE))
    {
        ShowNotificationSile(playerid, 2, 6, 0, 0, "Игрок слишком далеко для трейда", " ");
        return false;
    }

    if(g_inv11_trade_active[playerid] || g_inv11_trade_active[targetid])
    {
        ShowNotificationSile(playerid, 2, 6, 0, 0, "Один из игроков уже в трейде", " ");
        return false;
    }

    if(g_inv11_trade_invite_from[targetid] != -1 && g_inv11_trade_invite_from[targetid] != playerid && gettime() - g_inv11_trade_invite_time[targetid] <= INV11_TRADE_INVITE_TIMEOUT)
    {
        ShowNotificationSile(playerid, 2, 6, 0, 0, "Игрок уже получил другое предложение", " ");
        return false;
    }

    g_inv11_trade_invite_from[targetid] = playerid;
    g_inv11_trade_invite_time[targetid] = gettime();
    g_inv11_trade_invite_to[playerid] = targetid;

    printf("[TRADE DEBUG] SendInvite OK: playerid=%d targetid=%d, invite_from[target]=%d", playerid, targetid, g_inv11_trade_invite_from[targetid]);

    new wait_msg[128];
    format(wait_msg, sizeof(wait_msg), "Ожидайте принятия трейда от %s", GetPlayerNameEx(targetid));
    SendClientMessage(playerid, 0xFFFFFFFF, wait_msg);

    new incoming_msg[128];
    format(incoming_msg, sizeof(incoming_msg), "Игрок %s предлагает вам трейд", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, 0x55CCFFFF, incoming_msg);

    new notify_text[96];
    format(notify_text, sizeof(notify_text), "Предложение от %s", GetPlayerNameEx(playerid));
    ShowNotificationSile(targetid, 4, 6, playerid, 0, notify_text, ">>");

    new dialog_text[144];
    format(dialog_text, sizeof(dialog_text), "Игрок %s предлагает Вам трейд, Вы согласны?", GetPlayerNameEx(playerid));
    ShowPlayerDialog(targetid, DIALOG_INV11_TRADE_CONFIRM, DIALOG_STYLE_MSGBOX, "{FF0000}Трейд", dialog_text, "Далее", "Отмена");

    return true;
}

stock bool:Inv11Trade_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == DIALOG_INV11_TRADE_SELECT)
    {
        if(!response) return true;

        if(listitem < 0 || listitem >= g_inv11_trade_dialog_count[playerid])
        {
            return true;
        }

        new targetid = g_inv11_trade_dialog_target[playerid][listitem];
        Inv11Trade_SendInvite(playerid, targetid);
        return true;
    }

    if(dialogid == DIALOG_INV11_TRADE_CONFIRM)
    {
        new inviter = g_inv11_trade_invite_from[playerid];
        if(inviter == -1)
        {
            ShowNotificationSile(playerid, 2, 6, 0, 0, "Предложение не найдено", " ");
            return true;
        }

        if(!response)
        {
            if(IsPlayerConnected(inviter) && g_inv11_trade_invite_to[inviter] == playerid)
            {
                SendClientMessage(inviter, 0xFFFFFFFF, "Игрок отклонил предложение трейда.");
                g_inv11_trade_invite_to[inviter] = -1;
            }
            Inv11Trade_ResetInvite(playerid);
            return true;
        }

        if(!IsPlayerConnected(inviter) || !IsPlayerLogged(inviter))
        {
            ShowNotificationSile(playerid, 2, 6, 0, 0, "Игрок недоступен", " ");
            Inv11Trade_ResetInvite(playerid);
            return true;
        }

        if(gettime() - g_inv11_trade_invite_time[playerid] > INV11_TRADE_INVITE_TIMEOUT)
        {
            ShowNotificationSile(playerid, 2, 6, 0, 0, "Предложение трейда устарело", " ");
            if(g_inv11_trade_invite_to[inviter] == playerid) g_inv11_trade_invite_to[inviter] = -1;
            Inv11Trade_ResetInvite(playerid);
            return true;
        }

        if(!Inv11Trade_IsNear(playerid, inviter, INV11_TRADE_NEAR_RANGE))
        {
            ShowNotificationSile(playerid, 2, 6, 0, 0, "Подойдите ближе к игроку", " ");
            if(g_inv11_trade_invite_to[inviter] == playerid) g_inv11_trade_invite_to[inviter] = -1;
            Inv11Trade_ResetInvite(playerid);
            return true;
        }

        if(g_inv11_trade_invite_to[inviter] == playerid) g_inv11_trade_invite_to[inviter] = -1;
        Inv11Trade_ResetInvite(playerid);

        printf("[TRADE DEBUG] Calling StartSession: inviter=%d playerid=%d", inviter, playerid);
        if(!Inv11Trade_StartSession(inviter, playerid))
        {
            printf("[TRADE DEBUG] StartSession FAILED");
            ShowNotificationSile(playerid, 2, 6, 0, 0, "Не удалось начать трейд", " ");
            if(IsPlayerConnected(inviter))
            {
                ShowNotificationSile(inviter, 2, 6, 0, 0, "Не удалось начать трейд", " ");
            }
            return true;
        }
        printf("[TRADE DEBUG] StartSession OK");

        SendClientMessage(inviter, 0xFFFFFFFF, "Игрок принял предложение трейда.");
        SendClientMessage(playerid, 0xFFFFFFFF, "Вы приняли предложение трейда.");
        return true;
    }

    return false;
}

// ---------- входящие GUI-пакеты (opcode 34) ----------

stock bool:Inv11Trade_OnGuiPacket(playerid, Node:json)
{
    new type = -1;
    JSON_GetInt(json, "t", type);

    printf("[TRADE DEBUG] OnGuiPacket: playerid=%d type=%d active=%d partner=%d", playerid, type, g_inv11_trade_active[playerid], g_inv11_trade_partner[playerid]);

    if(type != 5 && type != 6 && type != 7 && type != 8 && type != 9 && type != 16 && type != 24 && type != 25 && type != 31)
    {
        printf("[TRADE DEBUG] OnGuiPacket: unhandled type=%d, ignored", type);
        return false;
    }

    new Node:response = JSON_Object();
    new send_response = 1;
    new targetid = g_inv11_trade_partner[playerid];

    switch(type)
    {
        case 25:
        {
            new ok = Inv11Trade_OpenNearbyDialog(playerid);
            JSON_SetInt(response, "t", 25);
            JSON_SetInt(response, "s", ok ? 1 : 0);
        }

        case 31:
        {
            send_response = 0;
            if(g_inv11_trade_active[playerid] && targetid != -1 && IsPlayerConnected(targetid))
            {
                new tx[144];
                JSON_GetString(json, "tx", tx, sizeof(tx));
                if(strlen(tx))
                {
                    new text[192];
                    format(text, sizeof(text), "%s: %s", GetPlayerNameEx(playerid), tx);

                    new Node:packet = JSON_Object();
                    JSON_SetInt(packet, "t", 31);
                    JSON_SetString(packet, "tx", text);
                    SendPacketToClient(playerid, 33, packet);
                    SendPacketToClient(targetid, 33, packet);
                    JSON_Cleanup(packet);
                }
            }
        }

        case 16, 7:
        {
            send_response = 0;

            if(g_inv11_trade_starting[playerid])
            {
                // GUI ещё открывается — игнорируем закрытие в этот момент.
            }
            else if(g_inv11_trade_active[playerid] && targetid != -1)
            {
                new started_at = g_inv11_trade_started_at[playerid];
                new since_start = (started_at > 0) ? (gettime() - started_at) : 9999;
                if(started_at > 0 && since_start <= INV11_TRADE_CLOSE_GRACE)
                {
                    // в пределах "grace"-периода после старта — игнорируем.
                }
                else
                {
                    if(type == 7)
                    {
                        ShowNotificationSile(playerid, 2, 6, 0, 0, "Вы отменили обмен", " ");
                        if(IsPlayerConnected(targetid))
                        {
                            ShowNotificationSile(targetid, 2, 6, 0, 0, "Игрок отменил обмен", " ");
                        }
                    }
                    Inv11Trade_EndSession(playerid, targetid, 4, 4);
                }
            }
            else if(g_inv11_trade_active[playerid])
            {
                Inv11Trade_ResetSession(playerid);
            }
            else
            {
                JSON_SetInt(response, "t", type);
                JSON_SetInt(response, "s", (type == 16) ? 1 : 4);
                send_response = 1;
            }
        }

        case 6:
        {
            JSON_SetInt(response, "t", 6);

            if(!g_inv11_trade_active[playerid] || targetid == -1 || !IsPlayerConnected(targetid))
            {
                JSON_SetInt(response, "s", 0);
            }
            else
            {
                new money_offer = 0;
                JSON_GetInt(json, "em", money_offer);
                if(money_offer < 0) money_offer = 0;

                if(money_offer > INV11_TRADE_MAX_MONEY || money_offer > GetPlayerMoneyEx(playerid))
                {
                    JSON_SetInt(response, "s", 0);
                }
                else
                {
                    if(g_inv11_trade_money[playerid] != money_offer)
                    {
                        g_inv11_trade_money[playerid] = money_offer;
                        Inv11Trade_ResetApplyState(playerid, targetid);
                    }

                    Inv11Trade_SendPartnerMoney(targetid, money_offer);
                    JSON_SetInt(response, "s", 1);
                }
            }
        }

        case 5:
        {
            new item_id = 0;
            new raw_s = -1, raw_os = -1, raw_sl = -1, raw_i = 0, raw_a = 0;
            JSON_GetInt(json, "ga", item_id);
            JSON_GetInt(json, "s", raw_s);
            JSON_GetInt(json, "os", raw_os);
            JSON_GetInt(json, "sl", raw_sl);
            JSON_GetInt(json, "i", raw_i);
            JSON_GetInt(json, "a", raw_a);

            new slot = Inv11Trade_ResolveInventorySlot(playerid, item_id, raw_s, raw_os, raw_sl);

            new req_amount = raw_i;
            if(req_amount <= 0) req_amount = raw_a;
            if(req_amount <= 0) req_amount = 1;

            Inv11Trade_MoveInvToExchange(playerid, item_id, slot, req_amount, response);
        }

        case 24:
        {
            new item_id = 0;
            new raw_s = -1, raw_os = -1, raw_sl = -1, raw_i = 0, raw_a = 0;
            JSON_GetInt(json, "ga", item_id);
            JSON_GetInt(json, "s", raw_s);
            JSON_GetInt(json, "os", raw_os);
            JSON_GetInt(json, "sl", raw_sl);
            JSON_GetInt(json, "i", raw_i);
            JSON_GetInt(json, "a", raw_a);

            new slot = Inv11Trade_ResolveOfferSlot(playerid, item_id, raw_s, raw_os, raw_sl);

            new req_amount = raw_i;
            if(req_amount <= 0) req_amount = raw_a;
            if(req_amount <= 0) req_amount = 1;

            Inv11Trade_MoveExchangeToInv(playerid, item_id, slot, req_amount, response);
        }

        case 8:
        {
            JSON_SetInt(response, "t", 8);

            if(!g_inv11_trade_active[playerid] || targetid == -1 || !IsPlayerConnected(targetid))
            {
                JSON_SetInt(response, "s", 0);
            }
            else
            {
                g_inv11_trade_apply[playerid] = true;
                g_inv11_trade_confirm[playerid] = false;
                JSON_SetInt(response, "s", 1);

                if(g_inv11_trade_apply[targetid])
                {
                    JSON_SetInt(response, "t", 26);
                    Inv11Trade_SendBothApplied(targetid);
                    ShowNotificationSile(targetid, 3, 6, 0, 0, "Теперь нужно нажать кнопку Подтвердить", " ");
                }
                else
                {
                    ShowNotificationSile(playerid, 3, 6, 0, 0, "Вам нужно подождать пока другой игрок подтвердит трейд", " ");
                }
            }
        }

        case 9:
        {
            JSON_SetInt(response, "t", 9);

            if(!g_inv11_trade_active[playerid] || targetid == -1 || !IsPlayerConnected(targetid) || !g_inv11_trade_apply[playerid] || !g_inv11_trade_apply[targetid])
            {
                JSON_SetInt(response, "s", 0);
            }
            else
            {
                g_inv11_trade_confirm[playerid] = true;
                JSON_SetInt(response, "s", 1);

                if(g_inv11_trade_confirm[targetid])
                {
                    if(Inv11Trade_Finalize(playerid, targetid))
                    {
                        Inv11Trade_EndSession(playerid, targetid, 4, 4);
                        ShowPlayerNewInventory(playerid);
                        ShowPlayerNewInventory(targetid);
                        ShowNotificationSile(playerid, 3, 6, 0, 0, "Обмен прошел успешно", " ");
                        ShowNotificationSile(targetid, 3, 6, 0, 0, "Обмен прошел успешно", " ");
                    }
                    else
                    {
                        Inv11Trade_ResetApplyState(playerid, targetid);
                        ShowNotificationSile(playerid, 2, 6, 0, 0, "Не удалось завершить трейд", " ");
                        ShowNotificationSile(targetid, 2, 6, 0, 0, "Не удалось завершить трейд", " ");
                        JSON_SetInt(response, "s", 0);
                    }
                }
            }
        }
    }

    if(send_response && IsPlayerConnected(playerid))
    {
        SendPacketToClient(playerid, 33, response);
    }
    JSON_Cleanup(response);
    return true;
}

CMD:trade(playerid, params[])
{
    new targetid;

    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, -1, "Использование: /trade [id игрока]");
        return 1;
    }

    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
    {
        ShowNotificationSile(playerid, 2, 6, 0, 0, "Игрок недоступен", " ");
        return 1;
    }

    Inv11Trade_SendInvite(playerid, targetid);
    return 1;
}
