// ==========================================
// СИСТЕМА ГАРАЖЕЙ (ПОЛНАЯ ВЕРСИЯ)
// ==========================================

#if defined _garages_included
    #endinput
#endif
#define _garages_included

#include <a_samp>

// ==========================================
// КОНСТАНТЫ
// ==========================================

#define MAX_GARAGES             100
#define MAX_GARAGE_SLOTS        5

#define GARAGE_INTERIOR_NORMAL  1
#define GARAGE_INTERIOR_ELITE   2

#define PICKUP_ACTION_GARAGE_ENTER   250
#define PICKUP_ACTION_GARAGE_EXIT    251

#define DIALOG_GARAGE_MAIN       22500
#define DIALOG_GARAGE_BUY        22501
#define DIALOG_GARAGE_ENTER      22502
#define DIALOG_GARAGE_SELL       22503
#define DIALOG_GARAGE_UPGRADE    22504
#define DIALOG_GARAGE_UPGRADE_CONFIRM 22505
#define DIALOG_GARAGE_LOAD_CAR   22506
#define DIALOG_GARAGE_GPS        22507

// ==========================================
// СТРУКТУРЫ
// ==========================================

enum E_GARAGE_DATA
{
    G_SQL_ID,
    G_OWNER_ID,
    G_OWNER_NAME[24],
    G_PRICE,
    G_LOCKED,
    G_LEVEL,                // 1 - обычный, 2 - элитный
    Float: G_ENTER_X,
    Float: G_ENTER_Y,
    Float: G_ENTER_Z,
    Float: G_EXIT_X,
    Float: G_EXIT_Y,
    Float: G_EXIT_Z,
    Float: G_EXIT_ANGLE,
    G_PICKUP_ENTER,
    G_PICKUP_EXIT,
    Text3D: G_LABEL,
    G_LAST_LOAD_TIME,
    G_CARS_LOADED
};

// ==========================================
// ПЕРЕМЕННЫЕ
// ==========================================

static g_GarageData[MAX_GARAGES][E_GARAGE_DATA];
static g_GarageCount = 0;
static g_PlayerGarageSlot[MAX_PLAYERS] = {0, ...};

// ==========================================
// FORWARD ОБЪЯВЛЕНИЯ
// ==========================================

forward LoadGarages();
forward SaveGarage(garageid);
forward UpdateGarageLabel(garageid);
forward ShowGarageMenu(playerid);
forward EnterGarage(playerid, garageid);
forward ExitGarage(playerid);
forward BuyGarage(playerid, garageid);
forward SellGarage(playerid);
forward UpgradeGarage(playerid);
forward CreateGarageImmediate(playerid, Float:x, Float:y, Float:z, price);
forward OnGarageCreated(playerid, Float:x, Float:y, Float:z);

// ==========================================
// ИНИЦИАЛИЗАЦИЯ
// ==========================================

public OnGameModeInit()
{
    print("[GARAGE] Система гаражей загружается...");
    
    // Создаём таблицы если их нет
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `garages` (`id` INT(11) NOT NULL AUTO_INCREMENT, `owner_id` INT(11) NOT NULL DEFAULT 0, `owner_name` VARCHAR(24) NOT NULL DEFAULT 'None', `price` INT(11) NOT NULL DEFAULT 500000, `locked` TINYINT(1) NOT NULL DEFAULT 0, `level` TINYINT(1) NOT NULL DEFAULT 1, `enter_x` FLOAT NOT NULL DEFAULT 0, `enter_y` FLOAT NOT NULL DEFAULT 0, `enter_z` FLOAT NOT NULL DEFAULT 0, `exit_x` FLOAT NOT NULL DEFAULT 0, `exit_y` FLOAT NOT NULL DEFAULT 0, `exit_z` FLOAT NOT NULL DEFAULT 0, `exit_angle` FLOAT NOT NULL DEFAULT 0, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;");
    
    // Загружаем гаражи через 2 секунды
    SetTimer("LoadGarages", 2000, false);
    
    #if defined gar_OnGameModeInit
        return gar_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit gar_OnGameModeInit

#if defined gar_OnGameModeInit
    forward gar_OnGameModeInit();
#endif

// ==========================================
// ЗАГРУЗКА ГАРАЖЕЙ
// ==========================================

public LoadGarages()
{
    new Cache:result = mysql_query(mysql, "SELECT * FROM `garages` ORDER BY `id` ASC", true);
    new rows = cache_num_rows();
    
    if(rows > 0)
    {
        for(new i = 0; i < rows && i < MAX_GARAGES; i++)
        {
            g_GarageData[i][G_SQL_ID] = cache_get_field_content_int(i, "id");
            g_GarageData[i][G_OWNER_ID] = cache_get_field_content_int(i, "owner_id");
            cache_get_field_content(i, "owner_name", g_GarageData[i][G_OWNER_NAME], mysql, 24);
            g_GarageData[i][G_PRICE] = cache_get_field_content_int(i, "price");
            g_GarageData[i][G_LOCKED] = cache_get_field_content_int(i, "locked");
            g_GarageData[i][G_LEVEL] = cache_get_field_content_int(i, "level");
            
            g_GarageData[i][G_ENTER_X] = cache_get_field_content_float(i, "enter_x");
            g_GarageData[i][G_ENTER_Y] = cache_get_field_content_float(i, "enter_y");
            g_GarageData[i][G_ENTER_Z] = cache_get_field_content_float(i, "enter_z");
            
            g_GarageData[i][G_EXIT_X] = cache_get_field_content_float(i, "exit_x");
            g_GarageData[i][G_EXIT_Y] = cache_get_field_content_float(i, "exit_y");
            g_GarageData[i][G_EXIT_Z] = cache_get_field_content_float(i, "exit_z");
            g_GarageData[i][G_EXIT_ANGLE] = cache_get_field_content_float(i, "exit_angle");
            
            // Создаём пикапы и 3D текст
            CreateGaragePickups(i);
            UpdateGarageLabel(i);
        }
        
        g_GarageCount = rows;
        printf("[GARAGE] Загружено гаражей: %d", g_GarageCount);
    }
    else
    {
        // Если гаражей нет - создаём дефолтные
        CreateDefaultGarages();
    }
    
    cache_delete(result);
    return 1;
}

// ==========================================
// СОЗДАНИЕ ДЕФОЛТНЫХ ГАРАЖЕЙ
// ==========================================

stock CreateDefaultGarages()
{
    new Float:default_garages[][9] = {
        {353.404, 800.074, 12.0, 350.682, 800.797, 12.0, 69.381, 500000},
        {354.905, 804.006, 12.0, 352.324, 804.991, 12.0, 66.775, 500000},
        {356.451, 808.065, 12.0, 353.898, 808.920, 12.0, 66.563, 500000},
        {357.905, 811.891, 12.0, 355.276, 813.422, 12.0, 67.925, 500000},
        {359.422, 815.865, 12.0, 356.466, 816.753, 12.0, 65.215, 500000},
        {360.909, 819.765, 12.0, 358.047, 820.573, 12.0, 72.579, 500000},
        {362.431, 823.763, 12.0, 360.489, 824.517, 12.0, 64.024, 500000},
        {363.940, 827.730, 12.0, 361.112, 828.732, 12.0, 71.263, 500000},
        {365.421, 831.631, 12.0, 362.630, 832.608, 12.0, 70.859, 500000}
    };
    
    for(new i = 0; i < sizeof(default_garages); i++)
    {
        new query[512];
        mysql_format(mysql, query, sizeof(query),
            "INSERT INTO `garages` (`price`, `enter_x`, `enter_y`, `enter_z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`) VALUES \
            (%d, %f, %f, %f, %f, %f, %f, %f)",
            floatround(default_garages[i][8]),
            default_garages[i][0], default_garages[i][1], default_garages[i][2],
            default_garages[i][3], default_garages[i][4], default_garages[i][5],
            default_garages[i][6]
        );
        mysql_tquery(mysql, query);
    }
    
    printf("[GARAGE] Создано %d дефолтных гаражей", sizeof(default_garages));
    SetTimer("LoadGarages", 1000, false);
}

// ==========================================
// СОЗДАНИЕ ПИКАПОВ
// ==========================================

stock CreateGaragePickups(garageid)
{
    // Удаляем старые пикапы
    if(g_GarageData[garageid][G_PICKUP_ENTER] != 0)
        DestroyPickup(g_GarageData[garageid][G_PICKUP_ENTER]);
    if(g_GarageData[garageid][G_PICKUP_EXIT] != 0)
        DestroyPickup(g_GarageData[garageid][G_PICKUP_EXIT]);
    
    // Создаём пикап входа
    g_GarageData[garageid][G_PICKUP_ENTER] = CreatePickup(
        19134, 23,
        g_GarageData[garageid][G_ENTER_X],
        g_GarageData[garageid][G_ENTER_Y],
        g_GarageData[garageid][G_ENTER_Z],
        0,
        PICKUP_ACTION_GARAGE_ENTER,
        garageid
    );
    
    // Создаём пикап выхода (внутри гаража)
    new Float:exit_x = g_GarageData[garageid][G_EXIT_X];
    new Float:exit_y = g_GarageData[garageid][G_EXIT_Y];
    new Float:exit_z = g_GarageData[garageid][G_EXIT_Z];
    
    g_GarageData[garageid][G_PICKUP_EXIT] = CreatePickup(
        1318, 23,
        exit_x, exit_y, exit_z,
        -1,
        PICKUP_ACTION_GARAGE_EXIT,
        garageid
    );
}

// ==========================================
// ОБНОВЛЕНИЕ 3D ТЕКСТА
// ==========================================

stock UpdateGarageLabel(garageid)
{
    if(g_GarageData[garageid][G_LABEL] != Text3D:-1)
        DestroyDynamic3DTextLabel(g_GarageData[garageid][G_LABEL]);
    
    new label[128];
    if(g_GarageData[garageid][G_OWNER_ID] > 0)
    {
        format(label, sizeof(label),
            "{FF5252}Гараж №%d\n\
            {FFFFFF}Владелец: {FF5252}%s\n\
            {FFFFFF}Статус: %s\n\
            {DCDCDC}[ Подойдите для взаимодействия ]",
            g_GarageData[garageid][G_SQL_ID],
            g_GarageData[garageid][G_OWNER_NAME],
            g_GarageData[garageid][G_LOCKED] ? ("{FF0000}Закрыт") : ("{00FF00}Открыт")
        );
    }
    else
    {
        format(label, sizeof(label),
            "{FF5252}Гараж №%d\n\
            {FFFFFF}Свободен\n\
            {FFFFFF}Цена: {FF5252}%d руб.\n\
            {DCDCDC}[ Подойдите для взаимодействия ]",
            g_GarageData[garageid][G_SQL_ID],
            g_GarageData[garageid][G_PRICE]
        );
    }
    
    g_GarageData[garageid][G_LABEL] = CreateDynamic3DTextLabel(
        label, 0xFFFFFFFF,
        g_GarageData[garageid][G_ENTER_X],
        g_GarageData[garageid][G_ENTER_Y],
        g_GarageData[garageid][G_ENTER_Z] + 0.8,
        10.0
    );
}

// ==========================================
// СОЗДАНИЕ ГАРАЖА СРАЗУ С ПИКАПОМ
// ==========================================

stock CreateGarageImmediate(playerid, Float:x, Float:y, Float:z, price)
{
    new query[512];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO `garages` (`price`, `enter_x`, `enter_y`, `enter_z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`) VALUES \
        (%d, %f, %f, %f, %f, %f, %f, %f)",
        price, x, y, z, 1.2011, 1994.7356, 1554.2031, 0.0
    );
    mysql_tquery(mysql, query, "OnGarageCreated", "ifff", playerid, x, y, z);
    
    return 1;
}

// ==========================================
// КОЛБЭК ПОСЛЕ СОЗДАНИЯ ГАРАЖА
// ==========================================

public OnGarageCreated(playerid, Float:x, Float:y, Float:z)
{
    new Cache:result = mysql_query(mysql, "SELECT `id` FROM `garages` ORDER BY `id` DESC LIMIT 1", true);
    
    if(cache_num_rows() > 0)
    {
        new garageid = cache_get_field_content_int(0, "id");
        new idx = g_GarageCount;
        new price = GetPVarInt(playerid, "garage_price");
        
        // Заполняем данные
        g_GarageData[idx][G_SQL_ID] = garageid;
        g_GarageData[idx][G_OWNER_ID] = 0;
        format(g_GarageData[idx][G_OWNER_NAME], 24, "None");
        g_GarageData[idx][G_PRICE] = price;
        g_GarageData[idx][G_LOCKED] = 0;
        g_GarageData[idx][G_LEVEL] = 1;
        g_GarageData[idx][G_ENTER_X] = x;
        g_GarageData[idx][G_ENTER_Y] = y;
        g_GarageData[idx][G_ENTER_Z] = z;
        g_GarageData[idx][G_EXIT_X] = 1.2011;
        g_GarageData[idx][G_EXIT_Y] = 1994.7356;
        g_GarageData[idx][G_EXIT_Z] = 1554.2031;
        g_GarageData[idx][G_EXIT_ANGLE] = 0.0;
        
        // СОЗДАЁМ ПИКАП ВХОДА СРАЗУ
        g_GarageData[idx][G_PICKUP_ENTER] = CreatePickup(
            19134, 23,
            x, y, z,
            0,
            PICKUP_ACTION_GARAGE_ENTER,
            idx
        );
        
        // СОЗДАЁМ 3D ТЕКСТ СРАЗУ
        new label[128];
        format(label, sizeof(label),
            "{FF5252}Гараж №%d\n\
            {FFFFFF}Свободен\n\
            {FFFFFF}Цена: {FF5252}%d руб.\n\
            {DCDCDC}[ Подойдите для взаимодействия ]",
            garageid, price
        );
        
        g_GarageData[idx][G_LABEL] = CreateDynamic3DTextLabel(
            label, 0xFFFFFFFF,
            x, y, z + 0.8,
            10.0
        );
        
        // СОЗДАЁМ ПИКАП ВЫХОДА (ВНУТРИ ГАРАЖА)
        g_GarageData[idx][G_PICKUP_EXIT] = CreatePickup(
            1318, 23,
            1.2011, 1994.7356, 1554.2031,
            -1,
            PICKUP_ACTION_GARAGE_EXIT,
            idx
        );
        
        g_GarageCount++;
        
        DeletePVar(playerid, "garage_price");
        
        SendClientMessage(playerid, 0x00FF00FF, "Гараж успешно создан! Пикап и 3D текст добавлены.");
        
        new msg[128];
        format(msg, sizeof(msg), "ID гаража: %d | Цена: %d руб.", garageid, price);
        SendClientMessage(playerid, 0xFFFFFFFF, msg);
        
        // Обновляем глобальный счётчик
        printf("[GARAGE] Создан новый гараж ID: %d, Всего: %d", garageid, g_GarageCount);
    }
    
    cache_delete(result);
    return 1;
}

// ==========================================
// ПОЛУЧЕНИЕ ГАРАЖА ИГРОКА
// ==========================================

stock GetPlayerGarageID(playerid)
{
    new accid = GetPlayerAccountID(playerid);
    if(accid <= 0) return -1;
    
    for(new i = 0; i < g_GarageCount; i++)
    {
        if(g_GarageData[i][G_OWNER_ID] == accid)
            return i;
    }
    return -1;
}

stock IsGarageOwned(garageid)
{
    return (g_GarageData[garageid][G_OWNER_ID] > 0);
}

stock IsGarageOwner(playerid, garageid)
{
    if(garageid < 0 || garageid >= g_GarageCount) return 0;
    return (g_GarageData[garageid][G_OWNER_ID] == GetPlayerAccountID(playerid));
}

// ==========================================
// СОХРАНЕНИЕ ГАРАЖА
// ==========================================

public SaveGarage(garageid)
{
    new query[512];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE `garages` SET \
        `owner_id` = %d, \
        `owner_name` = '%s', \
        `locked` = %d, \
        `level` = %d \
        WHERE `id` = %d",
        g_GarageData[garageid][G_OWNER_ID],
        g_GarageData[garageid][G_OWNER_NAME],
        g_GarageData[garageid][G_LOCKED],
        g_GarageData[garageid][G_LEVEL],
        g_GarageData[garageid][G_SQL_ID]
    );
    mysql_tquery(mysql, query);
}

// ==========================================
// ПОКАЗ МЕНЮ ГАРАЖА
// ==========================================

public ShowGarageMenu(playerid)
{
    new garageid = GetPlayerGarageID(playerid);
    if(garageid == -1)
        return SendClientMessage(playerid, 0x999999FF, "У вас нет гаража!");
    
    new str[512];
    format(str, sizeof(str),
        "{FFFFFF}1. Информация о гараже\n\
        2. {669966}Открыть {FFFFFF}или {CC3333}закрыть {FFFFFF}гараж\n\
        3. Улучшить гараж\n\
        4. Загрузить транспорт\n\
        5. Отметить на GPS\n\
        6. Продать гараж"
    );
    
    Dialog(playerid, DIALOG_GARAGE_MAIN, DIALOG_STYLE_LIST,
        "{FF5252}Управление гаражем", str,
        "Выбрать", "Закрыть"
    );
}

// ==========================================
// ВХОД В ГАРАЖ
// ==========================================

public EnterGarage(playerid, garageid)
{
    if(g_GarageData[garageid][G_LOCKED] && !IsGarageOwner(playerid, garageid))
        return SendClientMessage(playerid, 0xE74C3CFF, "Гараж закрыт!");
    
    new interior = (g_GarageData[garageid][G_LEVEL] == 2) ? GARAGE_INTERIOR_ELITE : GARAGE_INTERIOR_NORMAL;
    new Float:exit_x = g_GarageData[garageid][G_EXIT_X];
    new Float:exit_y = g_GarageData[garageid][G_EXIT_Y];
    new Float:exit_z = g_GarageData[garageid][G_EXIT_Z];
    new Float:exit_angle = g_GarageData[garageid][G_EXIT_ANGLE];
    new vw = garageid + 2000;
    
    SetPlayerPosEx(playerid, exit_x, exit_y, exit_z, exit_angle, interior, vw);
    PlayerInfo[playerid][P_IN_GARAGE] = garageid;
    
    SendClientMessage(playerid, 0x00FF00FF, "Вы вошли в гараж. Для выхода нажмите на пикап или используйте /exitgarage");
    return 1;
}

// ==========================================
// ВЫХОД ИЗ ГАРАЖА
// ==========================================

public ExitGarage(playerid)
{
    new garageid = PlayerInfo[playerid][P_IN_GARAGE];
    if(garageid == -1)
        return SendClientMessage(playerid, 0x999999FF, "Вы не в гараже!");
    
    new Float:enter_x = g_GarageData[garageid][G_ENTER_X];
    new Float:enter_y = g_GarageData[garageid][G_ENTER_Y];
    new Float:enter_z = g_GarageData[garageid][G_ENTER_Z];
    
    SetPlayerPosEx(playerid, enter_x, enter_y, enter_z, 0.0, 0, 0);
    PlayerInfo[playerid][P_IN_GARAGE] = -1;
    
    SendClientMessage(playerid, 0x00FF00FF, "Вы вышли из гаража!");
    return 1;
}

// ==========================================
// ПОКУПКА ГАРАЖА
// ==========================================

public BuyGarage(playerid, garageid)
{
    if(IsGarageOwned(garageid))
        return SendClientMessage(playerid, 0xE74C3CFF, "Этот гараж уже куплен!");
    
    if(GetPlayerGarageID(playerid) != -1)
        return SendClientMessage(playerid, 0xE74C3CFF, "У вас уже есть гараж!");
    
    if(GetPlayerMoneyEx(playerid) < g_GarageData[garageid][G_PRICE])
        return SendClientMessage(playerid, 0xE74C3CFF, "Недостаточно денег!");
    
    // Покупка
    GivePlayerMoneyEx(playerid, -g_GarageData[garageid][G_PRICE], "Покупка гаража", true, true);
    
    g_GarageData[garageid][G_OWNER_ID] = GetPlayerAccountID(playerid);
    GetPlayerName(playerid, g_GarageData[garageid][G_OWNER_NAME], 24);
    g_GarageData[garageid][G_LOCKED] = 0;
    
    PlayerInfo[playerid][P_GARAGE] = garageid;
    
    SaveGarage(garageid);
    UpdateGarageLabel(garageid);
    
    SendClientMessage(playerid, 0x00FF00FF, "Поздравляем! Вы купили гараж!");
    SendClientMessage(playerid, 0xFFFFFFFF, "Используйте {FF5252}/garage {FFFFFF}для управления гаражем.");
    
    EnterGarage(playerid, garageid);
    return 1;
}

// ==========================================
// ПРОДАЖА ГАРАЖА
// ==========================================

public SellGarage(playerid)
{
    new garageid = GetPlayerGarageID(playerid);
    if(garageid == -1)
        return SendClientMessage(playerid, 0x999999FF, "У вас нет гаража!");
    
    new return_money = g_GarageData[garageid][G_PRICE] * 70 / 100;
    
    // Возврат денег
    GivePlayerMoneyEx(playerid, return_money, "Продажа гаража", true, true);
    
    // Очистка данных
    g_GarageData[garageid][G_OWNER_ID] = 0;
    format(g_GarageData[garageid][G_OWNER_NAME], 24, "None");
    g_GarageData[garageid][G_LOCKED] = 0;
    g_GarageData[garageid][G_LEVEL] = 1;
    
    PlayerInfo[playerid][P_GARAGE] = -1;
    PlayerInfo[playerid][P_IN_GARAGE] = -1;
    
    SaveGarage(garageid);
    UpdateGarageLabel(garageid);
    
    new msg[128];
    format(msg, sizeof(msg), "Вы продали гараж за %d руб. (70%% от стоимости)", return_money);
    SendClientMessage(playerid, 0x00FF00FF, msg);
    
    SetPlayerPosEx(playerid, g_GarageData[garageid][G_ENTER_X], g_GarageData[garageid][G_ENTER_Y], g_GarageData[garageid][G_ENTER_Z], 0.0, 0, 0);
    return 1;
}

// ==========================================
// УЛУЧШЕНИЕ ГАРАЖА
// ==========================================

public UpgradeGarage(playerid)
{
    new garageid = GetPlayerGarageID(playerid);
    if(garageid == -1)
        return SendClientMessage(playerid, 0x999999FF, "У вас нет гаража!");
    
    if(g_GarageData[garageid][G_LEVEL] >= 2)
        return SendClientMessage(playerid, 0x999999FF, "Ваш гараж уже улучшен до элитного!");
    
    if(GetPlayerMoneyEx(playerid) < 5000000)
        return SendClientMessage(playerid, 0xE74C3CFF, "Для улучшения гаража нужно 5.000.000 рублей!");
    
    // Улучшение
    GivePlayerMoneyEx(playerid, -5000000, "Улучшение гаража", true, true);
    g_GarageData[garageid][G_LEVEL] = 2;
    
    SaveGarage(garageid);
    UpdateGarageLabel(garageid);
    
    SendClientMessage(playerid, 0x00FF00FF, "Ваш гараж улучшен до элитного!");
    SendClientMessage(playerid, 0xFFFFFFFF, "Теперь у вас более просторный интерьер и больше слотов для транспорта.");
    return 1;
}

// ==========================================
// ЗАГРУЗКА ТРАНСПОРТА В ГАРАЖЕ
// ==========================================

stock ShowGarageCarLoadDialog(playerid)
{
    new garageid = GetPlayerGarageID(playerid);
    if(garageid == -1)
        return SendClientMessage(playerid, 0x999999FF, "У вас нет гаража!");
    
    new title[128];
    format(title, sizeof(title), "{FF5252}Загрузка транспорта в гараже");
    
    Dialog(playerid, DIALOG_GARAGE_LOAD_CAR, DIALOG_STYLE_LIST,
        title,
        "1. Отметить транспорт на GPS\n2. Загрузить транспорт",
        "Выбрать", "Закрыть"
    );
}

// ==========================================
// КОМАНДЫ
// ==========================================

CMD:garage(playerid, params[])
{
    return ShowGarageMenu(playerid);
}

CMD:garagehelp(playerid, params[])
{
    new str[512];
    strcat(str, "{FF5252}/garage{FFFFFF} - Открыть меню управления гаражом\n");
    strcat(str, "{FF5252}/exitgarage{FFFFFF} - Выйти из гаража\n");
    strcat(str, "{FF5252}/buygarage{FFFFFF} - Купить гараж (нужно стоять у входа)\n");
    strcat(str, "{FF5252}/sellgarage{FFFFFF} - Продать гараж\n");
    strcat(str, "{FF5252}/upgradegarage{FFFFFF} - Улучшить гараж до элитного\n");
    strcat(str, "{FF5252}/garagegps{FFFFFF} - Отметить гараж на GPS\n");
    
    Dialog(playerid, -1, DIALOG_STYLE_MSGBOX,
        "{FF5252}Помощь по гаражам", str,
        "Закрыть", ""
    );
    return 1;
}

CMD:exitgarage(playerid, params[])
{
    return ExitGarage(playerid);
}

CMD:buygarage(playerid, params[])
{
    new garageid = -1;
    for(new i = 0; i < g_GarageCount; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0,
            g_GarageData[i][G_ENTER_X],
            g_GarageData[i][G_ENTER_Y],
            g_GarageData[i][G_ENTER_Z]))
        {
            garageid = i;
            break;
        }
    }
    
    if(garageid == -1)
        return SendClientMessage(playerid, 0x999999FF, "Вы должны стоять у входа в гараж!");
    
    return BuyGarage(playerid, garageid);
}

CMD:sellgarage(playerid, params[])
{
    return SellGarage(playerid);
}

CMD:upgradegarage(playerid, params[])
{
    return UpgradeGarage(playerid);
}

CMD:garagegps(playerid, params[])
{
    new garageid = GetPlayerGarageID(playerid);
    if(garageid == -1)
        return SendClientMessage(playerid, 0x999999FF, "У вас нет гаража!");
    
    if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_ON)
        return SendClientMessage(playerid, 0x999999FF, "На GPS уже отмечено место!");
    
    if(GetPlayerMoneyEx(playerid) < 300)
        return SendClientMessage(playerid, 0xE74C3CFF, "Недостаточно денег! Нужно 300 руб.");
    
    GivePlayerMoneyEx(playerid, -300, "GPS метка гаража", true, true);
    EnablePlayerGPS(playerid, 55,
        g_GarageData[garageid][G_ENTER_X],
        g_GarageData[garageid][G_ENTER_Y],
        g_GarageData[garageid][G_ENTER_Z],
        "Ваш гараж отмечен на GPS"
    );
    return 1;
}

// ==========================================
// АДМИН-КОМАНДЫ
// ==========================================

CMD:addgarage(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6)
        return SendClientMessage(playerid, 0xE74C3CFF, "У вас нет прав!");
    
    new price;
    if(sscanf(params, "d", price))
        return SendClientMessage(playerid, 0x999999FF, "Используйте: /addgarage [цена]");
    
    if(price < 1)
        return SendClientMessage(playerid, 0xE74C3CFF, "Цена должна быть больше 0!");
    
    if(g_GarageCount >= MAX_GARAGES)
        return SendClientMessage(playerid, 0xE74C3CFF, "Достигнут лимит гаражей!");
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    // Сохраняем цену в PVar для колбэка
    SetPVarInt(playerid, "garage_price", price);
    
    // Создаём гараж с пикапом
    CreateGarageImmediate(playerid, x, y, z, price);
    
    SendClientMessage(playerid, 0x00FF00FF, "Гараж создаётся... Пикап и 3D текст появятся автоматически.");
    return 1;
}

CMD:setgarageexit(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6)
        return SendClientMessage(playerid, 0xE74C3CFF, "У вас нет прав!");
    
    new garageid;
    if(sscanf(params, "d", garageid))
        return SendClientMessage(playerid, 0x999999FF, "Используйте: /setgarageexit [id гаража]");
    
    if(garageid < 0 || garageid >= g_GarageCount)
        return SendClientMessage(playerid, 0xE74C3CFF, "Гараж с таким ID не найден!");
    
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    
    g_GarageData[garageid][G_EXIT_X] = x;
    g_GarageData[garageid][G_EXIT_Y] = y;
    g_GarageData[garageid][G_EXIT_Z] = z;
    g_GarageData[garageid][G_EXIT_ANGLE] = a;
    
    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE `garages` SET `exit_x` = %f, `exit_y` = %f, `exit_z` = %f, `exit_angle` = %f WHERE `id` = %d",
        x, y, z, a, g_GarageData[garageid][G_SQL_ID]
    );
    mysql_tquery(mysql, query);
    
    // Обновляем пикап выхода
    if(g_GarageData[garageid][G_PICKUP_EXIT] != 0)
        DestroyPickup(g_GarageData[garageid][G_PICKUP_EXIT]);
    
    g_GarageData[garageid][G_PICKUP_EXIT] = CreatePickup(
        1318, 23,
        x, y, z,
        -1,
        PICKUP_ACTION_GARAGE_EXIT,
        garageid
    );
    
    SendClientMessage(playerid, 0x00FF00FF, "Координаты выхода из гаража обновлены!");
    return 1;
}

// ==========================================
// HOOK: ON PLAYER PICKUP PICKUP
// ==========================================

public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
    if(action_type == PICKUP_ACTION_GARAGE_ENTER)
    {
        new garageid = action_id;
        if(garageid < 0 || garageid >= g_GarageCount) return 1;
        
        if(IsGarageOwned(garageid))
        {
            // Гараж занят - показываем меню входа
            new str[256];
            format(str, sizeof(str),
                "{FFFFFF}Гараж №%d\nВладелец: {FF5252}%s\n\n{FFFFFF}Что вы хотите сделать?",
                g_GarageData[garageid][G_SQL_ID],
                g_GarageData[garageid][G_OWNER_NAME]
            );
            
            if(IsGarageOwner(playerid, garageid))
            {
                Dialog(playerid, DIALOG_GARAGE_ENTER, DIALOG_STYLE_LIST,
                    "{FF5252}Ваш гараж", str,
                    "Войти\nУправление", "Закрыть"
                );
            }
            else
            {
                Dialog(playerid, DIALOG_GARAGE_ENTER, DIALOG_STYLE_LIST,
                    "{FF5252}Гараж занят", str,
                    "Войти", "Закрыть"
                );
            }
            SetPVarInt(playerid, "garage_selected", garageid);
        }
        else
        {
            // Гараж свободен - предложить купить
            new str[256];
            format(str, sizeof(str),
                "{FFFFFF}Гараж №%d свободен!\n\nЦена: {FF5252}%d руб.\n\nХотите купить этот гараж?",
                g_GarageData[garageid][G_SQL_ID],
                g_GarageData[garageid][G_PRICE]
            );
            Dialog(playerid, DIALOG_GARAGE_BUY, DIALOG_STYLE_MSGBOX,
                "{FF5252}Покупка гаража", str,
                "Купить", "Отмена"
            );
            SetPVarInt(playerid, "garage_selected", garageid);
        }
        return 1;
    }
    
    if(action_type == PICKUP_ACTION_GARAGE_EXIT)
    {
        return ExitGarage(playerid);
    }
    
    #if defined gar_OnPlayerPickUpPickupEx
        return gar_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerPickUpPickupEx
    #undef OnPlayerPickUpPickupEx
#else
    #define _ALS_OnPlayerPickUpPickupEx
#endif
#define OnPlayerPickUpPickupEx gar_OnPlayerPickUpPickupEx

#if defined gar_OnPlayerPickUpPickupEx
    forward gar_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
#endif

// ==========================================
// HOOK: ON PLAYER KEY STATE CHANGE (ВЫЕЗД ПО ГУДКУ)
// ==========================================

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_CROUCH && IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new garageid = PlayerInfo[playerid][P_IN_GARAGE];
        if(garageid != -1)
        {
            // Выезд из гаража по гудку
            new vehicleid = GetPlayerVehicleID(playerid);
            
            // Проверяем, что это машина игрока
            if(vehicleid == GetPlayerOwnableCar(playerid))
            {
                SetVehiclePos(vehicleid,
                    g_GarageData[garageid][G_EXIT_X],
                    g_GarageData[garageid][G_EXIT_Y],
                    g_GarageData[garageid][G_EXIT_Z]
                );
                SetVehicleZAngle(vehicleid, g_GarageData[garageid][G_EXIT_ANGLE]);
                SetVehicleVirtualWorld(vehicleid, 0);
                LinkVehicleToInterior(vehicleid, 0);
                
                SetPlayerVirtualWorld(playerid, 0);
                SetPlayerInterior(playerid, 0);
                SetCameraBehindPlayer(playerid);
                
                PlayerInfo[playerid][P_IN_GARAGE] = -1;
                SendClientMessage(playerid, 0x00FF00FF, "Вы выехали из гаража!");
                return 1;
            }
        }
    }
    
    #if defined gar_OnPlayerKeyStateChange
        return gar_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange gar_OnPlayerKeyStateChange

#if defined gar_OnPlayerKeyStateChange
    forward gar_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

// ==========================================
// HOOK: ON DIALOG RESPONSE
// ==========================================

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_GARAGE_MAIN:
        {
            if(!response) return 1;
            
            new garageid = GetPlayerGarageID(playerid);
            if(garageid == -1) return 1;
            
            switch(listitem)
            {
                case 0: // Информация
                {
                    new str[512];
                    format(str, sizeof(str),
                        "{FFFFFF}Номер гаража: {FF5252}%d\n\
                        {FFFFFF}Владелец: {FF5252}%s\n\
                        {FFFFFF}Статус: %s\n\
                        {FFFFFF}Уровень: %s\n\
                        {FFFFFF}Цена: {FF5252}%d руб.",
                        g_GarageData[garageid][G_SQL_ID],
                        g_GarageData[garageid][G_OWNER_NAME],
                        g_GarageData[garageid][G_LOCKED] ? ("{FF0000}Закрыт") : ("{00FF00}Открыт"),
                        g_GarageData[garageid][G_LEVEL] == 2 ? ("{FF5252}Элитный") : ("Обычный"),
                        g_GarageData[garageid][G_PRICE]
                    );
                    Dialog(playerid, -1, DIALOG_STYLE_MSGBOX,
                        "{FF5252}Информация о гараже", str,
                        "ОК", ""
                    );
                }
                case 1: // Открыть/Закрыть
                {
                    g_GarageData[garageid][G_LOCKED] = !g_GarageData[garageid][G_LOCKED];
                    SaveGarage(garageid);
                    UpdateGarageLabel(garageid);
                    
                    SendClientMessage(playerid, 0x00FF00FF,
                        g_GarageData[garageid][G_LOCKED] ? "Гараж закрыт!" : "Гараж открыт!"
                    );
                    ShowGarageMenu(playerid);
                }
                case 2: // Улучшить
                {
                    UpgradeGarage(playerid);
                    ShowGarageMenu(playerid);
                }
                case 3: // Загрузить транспорт
                {
                    ShowGarageCarLoadDialog(playerid);
                }
                case 4: // GPS
                {
                    callcmd::garagegps(playerid, "");
                    ShowGarageMenu(playerid);
                }
                case 5: // Продать
                {
                    Dialog(playerid, DIALOG_GARAGE_SELL, DIALOG_STYLE_MSGBOX,
                        "{FF0000}Продажа гаража",
                        "{FFFFFF}Вы уверены, что хотите продать гараж?\n\nВам вернется {00FF00}70%% {FFFFFF}от стоимости.",
                        "Продать", "Отмена"
                    );
                }
            }
            return 1;
        }
        
        case DIALOG_GARAGE_BUY:
        {
            if(!response) return 1;
            
            new garageid = GetPVarInt(playerid, "garage_selected");
            if(garageid == -1) return 1;
            
            return BuyGarage(playerid, garageid);
        }
        
        case DIALOG_GARAGE_ENTER:
        {
            if(!response) return 1;
            
            new garageid = GetPVarInt(playerid, "garage_selected");
            if(garageid == -1) return 1;
            
            if(listitem == 0) // Войти
            {
                return EnterGarage(playerid, garageid);
            }
            else if(listitem == 1 && IsGarageOwner(playerid, garageid)) // Управление
            {
                return ShowGarageMenu(playerid);
            }
            return 1;
        }
        
        case DIALOG_GARAGE_SELL:
        {
            if(response)
                return SellGarage(playerid);
            return 1;
        }
        
        case DIALOG_GARAGE_LOAD_CAR:
        {
            if(!response) return 1;
            
            if(listitem == 0) // GPS
            {
                callcmd::garagegps(playerid, "");
            }
            else if(listitem == 1) // Загрузить
            {
                // Здесь вызывается стандартная система загрузки транспорта
                callcmd::car(playerid, "");
            }
            return 1;
        }
    }
    
    #if defined gar_OnDialogResponse
        return gar_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse gar_OnDialogResponse

#if defined gar_OnDialogResponse
    forward gar_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

// ==========================================
// HOOK: ON PLAYER CONNECT/DISCONNECT
// ==========================================

public OnPlayerConnect(playerid)
{
    g_PlayerGarageSlot[playerid] = 0;
    PlayerInfo[playerid][P_IN_GARAGE] = -1;
    
    #if defined gar_OnPlayerConnect
        return gar_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect gar_OnPlayerConnect

#if defined gar_OnPlayerConnect
    forward gar_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    PlayerInfo[playerid][P_IN_GARAGE] = -1;
    DeletePVar(playerid, "garage_selected");
    DeletePVar(playerid, "garage_price");
    
    #if defined gar_OnPlayerDisconnect
        return gar_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect gar_OnPlayerDisconnect

#if defined gar_OnPlayerDisconnect
    forward gar_OnPlayerDisconnect(playerid, reason);
#endif

// ==========================================
// СПАВН В ГАРАЖЕ
// ==========================================

stock SpawnInGarage(playerid)
{
    new garageid = GetPlayerGarageID(playerid);
    if(garageid != -1)
    {
        if(g_GarageData[garageid][G_LEVEL] == 1)
        {
            SetPlayerPosEx(playerid,
                1.265544, 1996.246215, 1554.203125,
                359.354705, 1, garageid + 2000
            );
        }
        else
        {
            SetPlayerPosEx(playerid,
                499.663299, 1983.485473, 1547.686645,
                358.738708, 1, garageid + 2000
            );
        }
        PlayerInfo[playerid][P_IN_GARAGE] = garageid;
        return 1;
    }
    return 0;
}