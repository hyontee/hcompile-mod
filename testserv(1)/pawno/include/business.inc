// business.inc - Система бизнесов для BETA RUSSIA RP

#if defined _business_included
    #endinput
#endif
#define _business_included

// Типы бизнесов
#define BIZ_TYPE_247         1
#define BIZ_TYPE_WEAPON      2
#define BIZ_TYPE_CAR_LOW     3
#define BIZ_TYPE_CAR_MID     4
#define BIZ_TYPE_CAR_HIGH    5
#define BIZ_TYPE_CASINO      6

// Максимальное количество бизнесов
#define MAX_BIZ              100

// Цвета для системы бизнесов
#define COLOR_BIZ            0x6AF26AFF
#define COLOR_BIZ_ERROR      0xFF6A6AFF
#define COLOR_BIZ_NOTIFY     0xFFD700FF

// Структура бизнеса
enum E_BIZ_DATA
{
    bizID,              // ID в базе данных
    bizType,            // Тип бизнеса
    bizOwner[MAX_PLAYER_NAME], // Владелец
    bizPrice,           // Стоимость
    Float:bizEnterX,    // Вход X
    Float:bizEnterY,    // Вход Y
    Float:bizEnterZ,    // Вход Z
    Float:bizEnterA,    // Угол входа
    Float:bizExitX,     // Выход X
    Float:bizExitY,     // Выход Y
    Float:bizExitZ,     // Выход Z
    Float:bizExitA,     // Угол выхода
    bizIntEnter,        // Интерьер входа
    bizIntExit,         // Интерьер выхода
    bizWorldEnter,      // Виртуальный мир входа
    bizWorldExit,       // Виртуальный мир выхода
    bizPickupID,        // ID пикапа входа
    bizPickupExitID,    // ID пикапа выхода
    Text3D:bizText3D,   // ID 3D текста входа
    Text3D:bizText3DExit, // ID 3D текста выхода
    bool:bizCreated     // Создан ли бизнес
}

// Массив для хранения данных бизнесов
new BizInfo[MAX_BIZ][E_BIZ_DATA];
new Iterator:Businesses<MAX_BIZ>;

// Названия типов бизнесов
new const BizTypeNames[7][32] = 
{
    "Неизвестно",
    "Магазин 24/7",
    "Оружейный магазин",
    "Автосалон (Низкий класс)",
    "Автосалон (Средний класс)",
    "Автосалон (Высокий класс)",
    "Казино"
};

// Интерьеры по умолчанию для разных типов бизнесов
new const BizInteriors[7][6] = 
{
    {0, 0, 0, 0, 0, 0}, // Неизвестно
    {17, 1548, 415, 1001, 248, 1}, // 24/7
    {1, 316, -138, 999, 0, 6}, // Оружейный (аммуниция)
    {0, 0, 0, 0, 0, 0}, // Автосалон низкий (улица)
    {0, 0, 0, 0, 0, 0}, // Автосалон средний (улица)
    {0, 0, 0, 0, 0, 0}, // Автосалон высокий (улица)
    {1, 2160, 1621, 1000, 0, 10} // Казино (Caligula's)
};

// Точка выхода из интерьера по умолчанию
#define DEFAULT_EXIT_X 1544.821655
#define DEFAULT_EXIT_Y 416.395965
#define DEFAULT_EXIT_Z 1001.039306

forward LoadBusinesses();
forward SaveBusiness(bizid);
forward CreateBusinessPickups(bizid);
forward UpdateBusinessLabel(bizid);
forward OnPlayerEnterBusiness(playerid, bizid);
forward OnPlayerExitBusiness(playerid, bizid);
forward OnBusinessCreated(playerid, bizid);
forward OnBusinessesLoaded();

// Загрузка бизнесов из базы данных
public LoadBusinesses()
{
    new query[128];
    mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM businesses ORDER BY ID ASC");
    mysql_function_query(dbHandle, query, true, "OnBusinessesLoaded", "");
    
    printf("[Business System] Загрузка бизнесов...");
    return 1;
}

public OnBusinessesLoaded()
{
    new rows, fields;
    cache_get_data(rows, fields);
    
    if(!rows)
    {
        printf("[Business System] Бизнесы не найдены в базе данных");
        return 1;
    }
    
    // Очищаем существующие данные
    for(new i = 0; i < MAX_BIZ; i++)
    {
        if(BizInfo[i][bizCreated])
        {
            if(BizInfo[i][bizPickupID] != -1) DestroyPickup(BizInfo[i][bizPickupID]);
            if(BizInfo[i][bizPickupExitID] != -1) DestroyPickup(BizInfo[i][bizPickupExitID]);
            if(IsValidDynamic3DTextLabel(BizInfo[i][bizText3D])) DestroyDynamic3DTextLabel(BizInfo[i][bizText3D]);
            if(IsValidDynamic3DTextLabel(BizInfo[i][bizText3DExit])) DestroyDynamic3DTextLabel(BizInfo[i][bizText3DExit]);
            
            BizInfo[i][bizCreated] = false;
        }
    }
    
    Iter_Clear(Businesses);
    
    for(new i = 0; i < rows; i++)
    {
        new bizid = Iter_Free(Businesses);
        if(bizid == -1)
        {
            printf("[Business System] Достигнут лимит бизнесов! (%d)", MAX_BIZ);
            break;
        }
        
        BizInfo[bizid][bizID] = cache_get_field_content_int(i, "ID");
        BizInfo[bizid][bizType] = cache_get_field_content_int(i, "Type");
        cache_get_field_content(i, "Owner", BizInfo[bizid][bizOwner], dbHandle, MAX_PLAYER_NAME);
        BizInfo[bizid][bizPrice] = cache_get_field_content_int(i, "Price");
        
        BizInfo[bizid][bizEnterX] = cache_get_field_content_float(i, "EnterX");
        BizInfo[bizid][bizEnterY] = cache_get_field_content_float(i, "EnterY");
        BizInfo[bizid][bizEnterZ] = cache_get_field_content_float(i, "EnterZ");
        BizInfo[bizid][bizEnterA] = cache_get_field_content_float(i, "EnterA");
        
        BizInfo[bizid][bizExitX] = cache_get_field_content_float(i, "ExitX");
        BizInfo[bizid][bizExitY] = cache_get_field_content_float(i, "ExitY");
        BizInfo[bizid][bizExitZ] = cache_get_field_content_float(i, "ExitZ");
        BizInfo[bizid][bizExitA] = cache_get_field_content_float(i, "ExitA");
        
        BizInfo[bizid][bizIntEnter] = cache_get_field_content_int(i, "IntEnter");
        BizInfo[bizid][bizIntExit] = cache_get_field_content_int(i, "IntExit");
        BizInfo[bizid][bizWorldEnter] = cache_get_field_content_int(i, "WorldEnter");
        BizInfo[bizid][bizWorldExit] = cache_get_field_content_int(i, "WorldExit");
        
        BizInfo[bizid][bizPickupID] = -1;
        BizInfo[bizid][bizPickupExitID] = -1;
        BizInfo[bizid][bizText3D] = Text3D:INVALID_3DTEXT_ID;
        BizInfo[bizid][bizText3DExit] = Text3D:INVALID_3DTEXT_ID;
        BizInfo[bizid][bizCreated] = true;
        
        CreateBusinessPickups(bizid);
        Iter_Add(Businesses, bizid);
    }
    
    printf("[Business System] Загружено %d бизнесов", rows);
    return 1;
}

// Создание пикапов и 3D текстов для бизнеса
stock CreateBusinessPickups(bizid)
{
    if(bizid < 0 || bizid >= MAX_BIZ || !BizInfo[bizid][bizCreated])
        return 0;
    
    // Удаляем старые пикапы и тексты если есть
    if(BizInfo[bizid][bizPickupID] != -1) DestroyPickup(BizInfo[bizid][bizPickupID]);
    if(IsValidDynamic3DTextLabel(BizInfo[bizid][bizText3D])) DestroyDynamic3DTextLabel(BizInfo[bizid][bizText3D]);
    
    // Создаем пикап входа
    BizInfo[bizid][bizPickupID] = CreatePickup(19132, 1, 
        BizInfo[bizid][bizEnterX], 
        BizInfo[bizid][bizEnterY], 
        BizInfo[bizid][bizEnterZ], 
        BizInfo[bizid][bizWorldEnter]);
    
    // Создаем 3D текст входа
    UpdateBusinessLabel(bizid);
    
    // Если есть точка выхода, создаем пикап выхода
    if(BizInfo[bizid][bizExitX] != 0.0 || BizInfo[bizid][bizExitY] != 0.0 || BizInfo[bizid][bizExitZ] != 0.0)
    {
        if(BizInfo[bizid][bizPickupExitID] != -1) DestroyPickup(BizInfo[bizid][bizPickupExitID]);
        if(IsValidDynamic3DTextLabel(BizInfo[bizid][bizText3DExit])) DestroyDynamic3DTextLabel(BizInfo[bizid][bizText3DExit]);
        
        BizInfo[bizid][bizPickupExitID] = CreatePickup(19132, 1, 
            BizInfo[bizid][bizExitX], 
            BizInfo[bizid][bizExitY], 
            BizInfo[bizid][bizExitZ], 
            BizInfo[bizid][bizWorldExit]);
        
        new label_exit[256];
        format(label_exit, sizeof(label_exit), 
            "{FFFFFF}%s\n{6AF26A}Выход из бизнеса", 
            BizTypeNames[BizInfo[bizid][bizType]]);
        
        BizInfo[bizid][bizText3DExit] = CreateDynamic3DTextLabel(label_exit, COLOR_BIZ,
            BizInfo[bizid][bizExitX], 
            BizInfo[bizid][bizExitY], 
            BizInfo[bizid][bizExitZ] + 0.5, 
            15.0, 
            .worldid = BizInfo[bizid][bizWorldExit],
            .interiorid = BizInfo[bizid][bizIntExit]);
    }
    
    return 1;
}

// Обновление 3D текста бизнеса
stock UpdateBusinessLabel(bizid)
{
    if(bizid < 0 || bizid >= MAX_BIZ || !BizInfo[bizid][bizCreated])
        return 0;
    
    if(IsValidDynamic3DTextLabel(BizInfo[bizid][bizText3D]))
        DestroyDynamic3DTextLabel(BizInfo[bizid][bizText3D]);
    
    new label[512];
    new ownerText[64];
    
    if(strlen(BizInfo[bizid][bizOwner]) > 0)
        format(ownerText, sizeof(ownerText), "Владелец: %s", BizInfo[bizid][bizOwner]);
    else
        format(ownerText, sizeof(ownerText), "Цена: {FFD700}%d руб.", BizInfo[bizid][bizPrice]);
    
    format(label, sizeof(label), 
        "{FFFFFF}%s\n{6AF26A}%s\n{FFFFFF}Для входа нажмите {FFFF00}'F'", 
        BizTypeNames[BizInfo[bizid][bizType]],
        ownerText);
    
    BizInfo[bizid][bizText3D] = CreateDynamic3DTextLabel(label, COLOR_BIZ,
        BizInfo[bizid][bizEnterX], 
        BizInfo[bizid][bizEnterY], 
        BizInfo[bizid][bizEnterZ] + 0.5, 
        15.0, 
        .worldid = BizInfo[bizid][bizWorldEnter],
        .interiorid = BizInfo[bizid][bizIntEnter]);
    
    return 1;
}

// Сохранение бизнеса в базу данных
public SaveBusiness(bizid)
{
    if(bizid < 0 || bizid >= MAX_BIZ || !BizInfo[bizid][bizCreated])
        return 0;
    
    new query[1024];
    
    // Экранируем имя владельца для безопасности
    new escapeOwner[MAX_PLAYER_NAME*2+1];
    mysql_escape_string(BizInfo[bizid][bizOwner], escapeOwner, sizeof(escapeOwner));
    
    mysql_format(dbHandle, query, sizeof(query),
        "UPDATE businesses SET \
        Type = %d, \
        Owner = '%s', \
        Price = %d, \
        EnterX = %f, \
        EnterY = %f, \
        EnterZ = %f, \
        EnterA = %f, \
        ExitX = %f, \
        ExitY = %f, \
        ExitZ = %f, \
        ExitA = %f, \
        IntEnter = %d, \
        IntExit = %d, \
        WorldEnter = %d, \
        WorldExit = %d \
        WHERE ID = %d",
        BizInfo[bizid][bizType],
        escapeOwner,
        BizInfo[bizid][bizPrice],
        BizInfo[bizid][bizEnterX],
        BizInfo[bizid][bizEnterY],
        BizInfo[bizid][bizEnterZ],
        BizInfo[bizid][bizEnterA],
        BizInfo[bizid][bizExitX],
        BizInfo[bizid][bizExitY],
        BizInfo[bizid][bizExitZ],
        BizInfo[bizid][bizExitA],
        BizInfo[bizid][bizIntEnter],
        BizInfo[bizid][bizIntExit],
        BizInfo[bizid][bizWorldEnter],
        BizInfo[bizid][bizWorldExit],
        BizInfo[bizid][bizID]);
    
    mysql_function_query(dbHandle, query, false, "", "");
    return 1;
}

// Создание нового бизнеса
stock CreateBusiness(playerid, type, price)
{
    if(type < 1 || type > 6)
    {
        SendClientMessage(playerid, COLOR_BIZ_ERROR, "[Ошибка] Неверный тип бизнеса (1-6)");
        return 0;
    }
    
    new bizid = Iter_Free(Businesses);
    if(bizid == -1)
    {
        SendClientMessage(playerid, COLOR_BIZ_ERROR, "[Ошибка] Достигнут лимит бизнесов!");
        return 0;
    }
    
    // Получаем позицию игрока
    GetPlayerPos(playerid, BizInfo[bizid][bizEnterX], BizInfo[bizid][bizEnterY], BizInfo[bizid][bizEnterZ]);
    GetPlayerFacingAngle(playerid, BizInfo[bizid][bizEnterA]);
    BizInfo[bizid][bizWorldEnter] = GetPlayerVirtualWorld(playerid);
    BizInfo[bizid][bizIntEnter] = GetPlayerInterior(playerid);
    
    // Устанавливаем данные бизнеса
    BizInfo[bizid][bizType] = type;
    BizInfo[bizid][bizPrice] = price;
    BizInfo[bizid][bizOwner][0] = '\0';
    
    // Устанавливаем интерьер входа для типа бизнеса
    BizInfo[bizid][bizIntEnter] = BizInteriors[type][0];
    
    // Точка выхода по умолчанию
    BizInfo[bizid][bizExitX] = DEFAULT_EXIT_X;
    BizInfo[bizid][bizExitY] = DEFAULT_EXIT_Y;
    BizInfo[bizid][bizExitZ] = DEFAULT_EXIT_Z;
    BizInfo[bizid][bizExitA] = 0.0;
    BizInfo[bizid][bizWorldExit] = 0;
    BizInfo[bizid][bizIntExit] = 0;
    
    // Вставляем в базу данных
    new query[1024];
    mysql_format(dbHandle, query, sizeof(query),
        "INSERT INTO businesses \
        (Type, Owner, Price, EnterX, EnterY, EnterZ, EnterA, ExitX, ExitY, ExitZ, ExitA, IntEnter, IntExit, WorldEnter, WorldExit) \
        VALUES (%d, '', %d, %f, %f, %f, %f, %f, %f, %f, %f, %d, %d, %d, %d)",
        type, price,
        BizInfo[bizid][bizEnterX], BizInfo[bizid][bizEnterY], BizInfo[bizid][bizEnterZ], BizInfo[bizid][bizEnterA],
        BizInfo[bizid][bizExitX], BizInfo[bizid][bizExitY], BizInfo[bizid][bizExitZ], BizInfo[bizid][bizExitA],
        BizInfo[bizid][bizIntEnter], BizInfo[bizid][bizIntExit],
        BizInfo[bizid][bizWorldEnter], BizInfo[bizid][bizWorldExit]);
    
    mysql_function_query(dbHandle, query, true, "OnBusinessCreated", "dd", playerid, bizid);
    
    return 1;
}

public OnBusinessCreated(playerid, bizid)
{
    BizInfo[bizid][bizID] = cache_insert_id();
    BizInfo[bizid][bizPickupID] = -1;
    BizInfo[bizid][bizPickupExitID] = -1;
    BizInfo[bizid][bizText3D] = Text3D:INVALID_3DTEXT_ID;
    BizInfo[bizid][bizText3DExit] = Text3D:INVALID_3DTEXT_ID;
    BizInfo[bizid][bizCreated] = true;
    
    CreateBusinessPickups(bizid);
    Iter_Add(Businesses, bizid);
    
    new msg[256];
    format(msg, sizeof(msg),
        "{6AF26A}[BUSINESS] {FFFFFF}Вы создали бизнес: {6AF26A}%s\n\
        {FFFFFF}ID: {6AF26A}%d\n\
        {FFFFFF}Стоимость: {FFD700}%d руб.",
        BizTypeNames[BizInfo[bizid][bizType]],
        BizInfo[bizid][bizID],
        BizInfo[bizid][bizPrice]);
    
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Создание бизнеса", msg, "OK", "");
    
    return 1;
}

// Обработка входа в бизнес
public OnPlayerEnterBusiness(playerid, bizid)
{
    if(bizid < 0 || bizid >= MAX_BIZ || !BizInfo[bizid][bizCreated])
        return 0;
    
    // Телепортируем в интерьер бизнеса
    SetPlayerInterior(playerid, BizInfo[bizid][bizIntEnter]);
    SetPlayerVirtualWorld(playerid, BizInfo[bizid][bizID] + 1000); // Уникальный мир для каждого бизнеса
    
    // Если это автосалон или другой тип с кастомными координатами
    if(BizInfo[bizid][bizType] >= BIZ_TYPE_CAR_LOW && BizInfo[bizid][bizType] <= BIZ_TYPE_CAR_HIGH)
    {
        // Для автосалонов используем специальные координаты
        SetPlayerPos(playerid, 1548.028686, 415.831726, 1001.039306);
        SetPlayerFacingAngle(playerid, 248.229614);
    }
    else
    {
        // Используем стандартные координаты интерьера для типа бизнеса
        SetPlayerPos(playerid, 
            float(BizInteriors[BizInfo[bizid][bizType]][1]),
            float(BizInteriors[BizInfo[bizid][bizType]][2]),
            float(BizInteriors[BizInfo[bizid][bizType]][3]));
        SetPlayerFacingAngle(playerid, float(BizInteriors[BizInfo[bizid][bizType]][4]));
    }
    
    // Сохраняем ID бизнеса в PVar игрока
    SetPVarInt(playerid, "InBusiness", BizInfo[bizid][bizID]);
    SetPVarInt(playerid, "BusinessID", bizid);
    
    new msg[128];
    format(msg, sizeof(msg), "{6AF26A}[BUSINESS] {FFFFFF}Вы вошли в {6AF26A}%s", BizTypeNames[BizInfo[bizid][bizType]]);
    SendClientMessage(playerid, COLOR_BIZ, msg);
    
    return 1;
}

// Обработка выхода из бизнеса
public OnPlayerExitBusiness(playerid, bizid)
{
    if(bizid < 0 || bizid >= MAX_BIZ || !BizInfo[bizid][bizCreated])
        return 0;
    
    // Телепортируем на точку выхода
    SetPlayerInterior(playerid, BizInfo[bizid][bizIntExit]);
    SetPlayerVirtualWorld(playerid, BizInfo[bizid][bizWorldExit]);
    SetPlayerPos(playerid, BizInfo[bizid][bizExitX], BizInfo[bizid][bizExitY], BizInfo[bizid][bizExitZ]);
    SetPlayerFacingAngle(playerid, BizInfo[bizid][bizExitA]);
    
    // Удаляем PVar
    DeletePVar(playerid, "InBusiness");
    DeletePVar(playerid, "BusinessID");
    
    new msg[128];
    format(msg, sizeof(msg), "{6AF26A}[BUSINESS] {FFFFFF}Вы вышли из {6AF26A}%s", BizTypeNames[BizInfo[bizid][bizType]]);
    SendClientMessage(playerid, COLOR_BIZ, msg);
    
    return 1;
}

// Команда для создания бизнеса
CMD:createbiz(playerid, params[])
{
    // Проверка прав администратора
    if(pInfo[playerid][pAdminLevel] < 1)
        return SendClientMessage(playerid, COLOR_BIZ_ERROR, "[Ошибка] Вам недоступна данная команда");
    
    if(!pInfo[playerid][pAdminLogged])
        return SendClientMessage(playerid, COLOR_BIZ_ERROR, "[Ошибка] Вы не авторизованы в админ-панели");
    
    new type, price;
    if(sscanf(params, "ii", type, price))
    {
        SendClientMessage(playerid, COLOR_BIZ, "Используйте: /createbiz [тип] [стоимость]");
        SendClientMessage(playerid, COLOR_BIZ, "Типы: 1-24/7, 2-Оружие, 3-Авто низкий, 4-Авто средний, 5-Авто высокий, 6-Казино");
        return 1;
    }
    
    if(type < 1 || type > 6)
    {
        SendClientMessage(playerid, COLOR_BIZ_ERROR, "[Ошибка] Неверный тип бизнеса (1-6)");
        return 1;
    }
    
    if(price < 1000)
    {
        SendClientMessage(playerid, COLOR_BIZ_ERROR, "[Ошибка] Стоимость бизнеса должна быть не менее 1000 руб.");
        return 1;
    }
    
    CreateBusiness(playerid, type, price);
    return 1;
}

// Команда для установки точки выхода из бизнеса
CMD:setbizexit(playerid, params[])
{
    // Проверка прав администратора
    if(pInfo[playerid][pAdminLevel] < 1)
        return SendClientMessage(playerid, COLOR_BIZ_ERROR, "[Ошибка] Вам недоступна данная команда");
    
    if(!pInfo[playerid][pAdminLogged])
        return SendClientMessage(playerid, COLOR_BIZ_ERROR, "[Ошибка] Вы не авторизованы в админ-панели");
    
    new bizid;
    if(sscanf(params, "i", bizid))
    {
        SendClientMessage(playerid, COLOR_BIZ, "Используйте: /setbizexit [ID бизнеса]");
        return 1;
    }
    
    // Ищем бизнес по ID в базе
    new found = -1;
    foreach(new i : Businesses)
    {
        if(BizInfo[i][bizID] == bizid)
        {
            found = i;
            break;
        }
    }
    
    if(found == -1)
    {
        SendClientMessage(playerid, COLOR_BIZ_ERROR, "[Ошибка] Бизнес с таким ID не найден");
        return 1;
    }
    
    // Получаем текущую позицию игрока
    GetPlayerPos(playerid, BizInfo[found][bizExitX], BizInfo[found][bizExitY], BizInfo[found][bizExitZ]);
    GetPlayerFacingAngle(playerid, BizInfo[found][bizExitA]);
    BizInfo[found][bizWorldExit] = GetPlayerVirtualWorld(playerid);
    BizInfo[found][bizIntExit] = GetPlayerInterior(playerid);
    
    // Создаем пикап выхода если его нет
    if(BizInfo[found][bizPickupExitID] == -1)
    {
        BizInfo[found][bizPickupExitID] = CreatePickup(19132, 1, 
            BizInfo[found][bizExitX], 
            BizInfo[found][bizExitY], 
            BizInfo[found][bizExitZ], 
            BizInfo[found][bizWorldExit]);
        
        new label_exit[256];
        format(label_exit, sizeof(label_exit), 
            "{FFFFFF}%s\n{6AF26A}Выход из бизнеса", 
            BizTypeNames[BizInfo[found][bizType]]);
        
        if(IsValidDynamic3DTextLabel(BizInfo[found][bizText3DExit]))
            DestroyDynamic3DTextLabel(BizInfo[found][bizText3DExit]);
            
        BizInfo[found][bizText3DExit] = CreateDynamic3DTextLabel(label_exit, COLOR_BIZ,
            BizInfo[found][bizExitX], 
            BizInfo[found][bizExitY], 
            BizInfo[found][bizExitZ] + 0.5, 
            15.0, 
            .worldid = BizInfo[found][bizWorldExit],
            .interiorid = BizInfo[found][bizIntExit]);
    }
    
    // Сохраняем в базу
    SaveBusiness(found);
    
    new msg[128];
    format(msg, sizeof(msg), "{6AF26A}[BUSINESS] {FFFFFF}Точка выхода для бизнеса ID %d установлена", bizid);
    SendClientMessage(playerid, COLOR_BIZ, msg);
    
    return 1;
}

// Команда для просмотра списка бизнесов
CMD:bizlist(playerid, params[])
{
    new count = 0;
    new dialog[2048] = "ID\tТип\tВладелец\tЦена\n";
    new temp[256];
    
    foreach(new i : Businesses)
    {
        format(temp, sizeof(temp), "%d\t%s\t%s\t%d руб.\n",
            BizInfo[i][bizID],
            BizTypeNames[BizInfo[i][bizType]],
            (strlen(BizInfo[i][bizOwner]) > 0) ? BizInfo[i][bizOwner] : "Нет владельца",
            BizInfo[i][bizPrice]);
        
        strcat(dialog, temp, sizeof(dialog));
        count++;
    }
    
    if(count == 0)
    {
        SendClientMessage(playerid, COLOR_BIZ, "[BUSINESS] Бизнесы не найдены");
        return 1;
    }
    
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, "Список бизнесов", dialog, "Закрыть", "");
    return 1;
}

// Команда для покупки бизнеса
CMD:buybiz(playerid, params[])
{
    new bizid;
    if(sscanf(params, "i", bizid))
    {
        SendClientMessage(playerid, COLOR_BIZ, "Используйте: /buybiz [ID бизнеса]");
        return 1;
    }
    
    new found = -1;
    foreach(new i : Businesses)
    {
        if(BizInfo[i][bizID] == bizid)
        {
            found = i;
            break;
        }
    }
    
    if(found == -1)
    {
        SendClientMessage(playerid, COLOR_BIZ_ERROR, "[Ошибка] Бизнес с таким ID не найден");
        return 1;
    }
    
    if(strlen(BizInfo[found][bizOwner]) > 0)
    {
        SendClientMessage(playerid, COLOR_BIZ_ERROR, "[Ошибка] Этот бизнес уже имеет владельца");
        return 1;
    }
    
    if(pInfo[playerid][pMoney] < BizInfo[found][bizPrice])
    {
        SendClientMessage(playerid, COLOR_BIZ_ERROR, "[Ошибка] У вас недостаточно средств");
        return 1;
    }
    
    // Списываем деньги
    pInfo[playerid][pMoney] -= BizInfo[found][bizPrice];
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, pInfo[playerid][pMoney]);
    
    // Сохраняем деньги в БД
    new query[128];
    mysql_format(dbHandle, query, sizeof(query), "UPDATE users SET Money = %d WHERE ID = %d", 
        pInfo[playerid][pMoney], pInfo[playerid][pID]);
    mysql_function_query(dbHandle, query, false, "", "");
    
    // Устанавливаем владельца
    format(BizInfo[found][bizOwner], MAX_PLAYER_NAME, "%s", pInfo[playerid][pName]);
    
    // Обновляем 3D текст
    UpdateBusinessLabel(found);
    
    // Сохраняем в базу
    SaveBusiness(found);
    
    new msg[256];
    format(msg, sizeof(msg), 
        "{6AF26A}[BUSINESS] {FFFFFF}Вы успешно приобрели бизнес {6AF26A}%s {FFFFFF}за {FFD700}%d руб.",
        BizTypeNames[BizInfo[found][bizType]],
        BizInfo[found][bizPrice]);
    SendClientMessage(playerid, COLOR_BIZ, msg);
    
    return 1;
}

// Обработка пикапов
public OnPlayerPickUpPickup(playerid, pickupid)
{
    // Проверяем бизнесы
    foreach(new i : Businesses)
    {
        if(BizInfo[i][bizPickupID] == pickupid)
        {
            OnPlayerEnterBusiness(playerid, i);
            return 1;
        }
        
        if(BizInfo[i][bizPickupExitID] == pickupid)
        {
            OnPlayerExitBusiness(playerid, i);
            return 1;
        }
    }
    
    // Вызываем оригинальную функцию если она есть
    #if defined Biz_OnPlayerPickUpPickup
        return Biz_OnPlayerPickUpPickup(playerid, pickupid);
    #endif
    return 1;
}

// Хуки для OnPlayerPickUpPickup
#if defined _ALS_OnPlayerPickUpPickup
    #undef OnPlayerPickUpPickup
#else
    #define _ALS_OnPlayerPickUpPickup
#endif
#define OnPlayerPickUpPickup Biz_OnPlayerPickUpPickup

#if defined Biz_OnPlayerPickUpPickup
    forward Biz_OnPlayerPickUpPickup(playerid, pickupid);
#endif