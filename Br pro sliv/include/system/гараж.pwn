в база данных
CREATE TABLE IF NOT EXISTS `garages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `owner_id` int(11) NOT NULL DEFAULT '0',
  `owner_name` varchar(24) NOT NULL DEFAULT 'None',
  `class` int(11) NOT NULL DEFAULT '0',
  `price` int(11) NOT NULL DEFAULT '100000',
  `locked` int(11) NOT NULL DEFAULT '1',
  `max_cars` int(11) NOT NULL DEFAULT '1',
  `wardrobe` int(11) NOT NULL DEFAULT '0',
  `ventilation` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


в пвн

#define MAX_GARAGES             100 // Максимальное количество гаражей на сервере
#define GARAGE_LIMIT_PER_PLAYER 1   // Сколько гаражей может иметь 1 игрок

enum E_GARAGE_CLASS_DATA {
    gcName[24],
    gcInterior,
    Float:gcPlayerX, Float:gcPlayerY, Float:gcPlayerZ, Float:gcPlayerA,
    Float:gcCarX, Float:gcCarY, Float:gcCarZ, Float:gcCarA,
    gcBasePrice,
    gcDefaultSlots
}

// Данные классов гаражей (0 - Низкий, 1 - Средний, 2 - Высокий)
new const GarageClassData[3][E_GARAGE_CLASS_DATA] = {
    // Название, Интерьер, Координаты игрока внутри, Координаты машины внутри, Цена, Слоты по дефолту
    {"Низкий класс", 15, 2224.0, -1153.0, 1025.8, 90.0, 2230.0, -1153.0, 1025.8, 90.0, 150000, 1},
    {"Средний класс", 1, 1415.0, -1480.0, 101.5, 0.0, 1420.0, -1480.0, 101.5, 0.0, 450000, 2},
    {"Высокий класс", 3, 1300.0, -1250.0, 50.5, 180.0, 1310.0, -1250.0, 50.5, 180.0, 1200000, 3}
};

enum E_GARAGE_STRUCT {
    gSQLID,
    Float:gX, Float:gY, Float:gZ,
    gOwnerID,
    gOwnerName[MAX_PLAYER_NAME],
    gClass,
    gPrice,
    gLocked,
    gMaxCars,
    gWardrobe,
    gVentilation,
    // Локальные переменные (не для БД)
    gPickup,
    Text3D:g3DText,
    gAreaID
};

new GarageInfo[MAX_GARAGES][E_GARAGE_STRUCT];
new TotalGarages = 0;

// Переменные для отслеживания нахождения игрока
new PlayerInGarage[MAX_PLAYERS] = {-1, ...}; // ID гаража, в котором находится игрок (-1 - на улице)



Добавь в OnGameModeInit:




public OnGameModeInit()
{
    // Твои инициализации...
    mysql_tquery(mysql, "SELECT * FROM garages", "LoadGarages");
    return 1;
}

forward LoadGarages();
public LoadGarages()
{
    new rows = cache_num_rows();
    if(!rows) return printf("[Garages] Гаражи не найдены в БД.");

    TotalGarages = rows;
    for(new i = 0; i < rows && i < MAX_GARAGES; i++)
    {
        GarageInfo[i][gSQLID] = cache_get_row_int(i, cache_lookup_index("id"));
        GarageInfo[i][gX] = cache_get_row_float(i, cache_lookup_index("x"));
        GarageInfo[i][gY] = cache_get_row_float(i, cache_lookup_index("y"));
        GarageInfo[i][gZ] = cache_get_row_float(i, cache_lookup_index("z"));
        
        GarageInfo[i][gOwnerID] = cache_get_row_int(i, cache_lookup_index("owner_id"));
        cache_get_row_name(i, cache_lookup_index("owner_name"), GarageInfo[i][gOwnerName], MAX_PLAYER_NAME);
        
        GarageInfo[i][gClass] = cache_get_row_int(i, cache_lookup_index("class"));
        GarageInfo[i][gPrice] = cache_get_row_int(i, cache_lookup_index("price"));
        GarageInfo[i][gLocked] = cache_get_row_int(i, cache_lookup_index("locked"));
        GarageInfo[i][gMaxCars] = cache_get_row_int(i, cache_lookup_index("max_cars"));
        GarageInfo[i][gWardrobe] = cache_get_row_int(i, cache_lookup_index("wardrobe"));
        GarageInfo[i][gVentilation] = cache_get_row_int(i, cache_lookup_index("ventilation"));

        // Создаем пикап и 3D Текст у ворот гаража
        UpdateGarageMap(i);
    }
    printf("[Garages] Успешно загружено %d гаражей.", TotalGarages);
    return 1;
}

stock UpdateGarageMap(id)
{
    // Удаляем старые, если были
    if(IsValidDynamicPickup(GarageInfo[id][gPickup])) DestroyDynamicPickup(GarageInfo[id][gPickup]);
    if(IsValidDynamic3DTextLabel(GarageInfo[id][g3DText])) DestroyDynamic3DTextLabel(GarageInfo[id][g3DText]);

    new str[256];
    if(GarageInfo[id][gOwnerID] == 0) // Продается
    {
        // Синий пикап покупки
        GarageInfo[id][gPickup] = CreateDynamicPickup(19134, 23, GarageInfo[id][gX], GarageInfo[id][gY], GarageInfo[id][gZ], -1, -1, -1, 10.0);
        
        format(str, sizeof(str), "[ Гараж Продается ]\n{FFFFFF}Класс: %s\nСтоимость: {33AA33}%d руб.\n{FFFFFF}Для покупки нажмите {FF8C00}H / ALT", GarageClassData[GarageInfo[id][gClass]][gcName], GarageInfo[id][gPrice]);
        GarageInfo[id][g3DText] = CreateDynamic3DTextLabel(str, 0x0080FFFF, GarageInfo[id][gX], GarageInfo[id][gY], GarageInfo[id][gZ] + 0.8, 15.0);
    }
    else // Есть владелец
    {
        // Желтая стрелочка заезда
        GarageInfo[id][gPickup] = CreateDynamicPickup(19191, 23, GarageInfo[id][gX], GarageInfo[id][gY], GarageInfo[id][gZ], -1, -1, -1, 10.0);
        
        format(str, sizeof(str), "[ Гараж ]\n{FFFFFF}Владелец: {FF8C00}%s\n{FFFFFF}Класс: %s\nСостояние: %s\n{FFFFFF}Нажмите {FF8C00}H / ALT {FFFFFF}для взаимодействия", GarageInfo[id][gOwnerName], GarageClassData[GarageInfo[id][gClass]][gcName], (GarageInfo[id][gLocked] ? "{FF3333}Закрыт" : "{33AA33}Открыт"));
        GarageInfo[id][g3DText] = CreateDynamic3DTextLabel(str, 0xFFFF00FF, GarageInfo[id][gX], GarageInfo[id][gY], GarageInfo[id][gZ] + 0.8, 15.0);
    }
}



Шаг 4. Вход и Выход (с поддержкой заезда на машине)

В Black Russia на гаражный маркер можно наехать на машине и заехать внутрь вместе с ней.

Реализуем обработку клавиши H (СИГНАЛ) или ALT у ворот гаража:


public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_CROUCH) || (newkeys & KEY_WALK)) // H (в машине) или ALT (пешком)
    {
        // Игрок у входа в гараж на улице
        for(new i = 0; i < TotalGarages; i++)
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.0, GarageInfo[i][gX], GarageInfo[i][gY], GarageInfo[i][gZ]))
            {
                if(GarageInfo[i][gOwnerID] == 0) // Если гараж продается
                {
                    ShowBuyGarageMenu(playerid, i);
                }
                else // Если у гаража есть владелец
                {
                    if(GarageInfo[i][gLocked] && GarageInfo[i][gOwnerID] != GetPlayerSQLID(playerid))
                    {
                        return SendClientMessage(playerid, 0xFF3333FF, "[Гараж] Этот гараж закрыт владельцем!");
                    }
                    
                    EnterGarage(playerid, i);
                }
                return 1;
            }
        }

        // Игрок находится внутри гаража и хочет выйти
        if(PlayerInGarage[playerid] != -1)
        {
            new id = PlayerInGarage[playerid];
            new class = GarageInfo[id][gClass];
            
            if(IsPlayerInRangeOfPoint(playerid, 4.0, GarageClassData[class][gcPlayerX], GarageClassData[class][gcPlayerY], GarageClassData[class][gcPlayerZ]))
            {
                ExitGarage(playerid, id);
                return 1;
            }
        }
    }
    return 1;
}

stock EnterGarage(playerid, id)
{
    new class = GarageInfo[id][gClass];
    PlayerInGarage[playerid] = id;

    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        
        // Переносим машину внутрь
        SetVehiclePos(vehicleid, GarageClassData[class][gcCarX], GarageClassData[class][gcCarY], GarageClassData[class][gcCarZ]);
        SetVehicleZAngle(vehicleid, GarageClassData[class][gcCarA]);
        LinkVehicleToInterior(vehicleid, GarageClassData[class][gcInterior]);
        SetVehicleVirtualWorld(vehicleid, GarageInfo[id][gSQLID]); // Вирт. мир равен SQL ID гаража
        
        // Сажаем игрока обратно в авто (синхронизация SAMP)
        PutPlayerInVehicle(playerid, vehicleid, 0);
    }
    else // Пешком
    {
        SetPlayerPos(playerid, GarageClassData[class][gcPlayerX], GarageClassData[class][gcPlayerY], GarageClassData[class][gcPlayerZ]);
        SetPlayerFacingAngle(playerid, GarageClassData[class][gcPlayerA]);
    }

    SetPlayerInterior(playerid, GarageClassData[class][gcInterior]);
    SetPlayerVirtualWorld(playerid, GarageInfo[id][gSQLID]);
    
    SendClientMessage(playerid, 0x33AA33FF, "[Гараж] Вы зашли в гараж.");
    return 1;
}

stock ExitGarage(playerid, id)
{
    PlayerInGarage[playerid] = -1;

    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        
        SetVehiclePos(vehicleid, GarageInfo[id][gX] + 2.0, GarageInfo[id][gY], GarageInfo[id][gZ]); // Спавним рядом с воротами
        SetVehicleZAngle(vehicleid, 0.0);
        LinkVehicleToInterior(vehicleid, 0);
        SetVehicleVirtualWorld(vehicleid, 0);
        
        PutPlayerInVehicle(playerid, vehicleid, 0);
    }
    else
    {
        SetPlayerPos(playerid, GarageInfo[id][gX] + 2.0, GarageInfo[id][gY], GarageInfo[id][gZ]);
    }

    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    
    SendClientMessage(playerid, 0x33AA33FF, "[Гараж] Вы вышли на улицу.");
    return 1;
}



stock ShowBuyGarageMenu(playerid, id)
{
    SetPVarInt(playerid, "BuyGarageID", id);
    new str[512];
    format(str, sizeof(str), 
        "{FFFFFF}Вы хотите приобрести этот гараж?\n\n\
        Класс: {FF8C00}%s\n\
        {FFFFFF}Базовые места под авто: {33AA33}%d\n\
        {FFFFFF}Гос. Цена: {33AA33}%d руб.\n\n\
        После покупки вы сможете парковать тут машины, улучшать интерьер и ставить шкаф.",
        GarageClassData[GarageInfo[id][gClass]][gcName],
        GarageClassData[GarageInfo[id][gClass]][gcDefaultSlots],
        GarageInfo[id][gPrice]
    );
    ShowPlayerDialog(playerid, 9920, DIALOG_STYLE_MSGBOX, "{FF8C00}Покупка Гаража", str, "Купить", "Отмена");
}










CMD:gmenu(playerid)
{
    new id = PlayerInGarage[playerid];
    if(id == -1) return SendClientMessage(playerid, -1, "Вы должны быть внутри своего гаража!");

    if(GarageInfo[id][gOwnerID] != GetPlayerSQLID(playerid))
        return SendClientMessage(playerid, -1, "Вы не владелец этого гаража!");

    new str[512];
    format(str, sizeof(str), 
        "1. Замок: %s\n\
        2. Улучшения гаража (Шкаф, Вентиляция)\n\
        3. Управление местами под авто (%d/%d)\n\
        4. Продать гараж государству ({FF3333}%d руб.{FFFFFF})",
        (GarageInfo[id][gLocked] ? "{FF3333}[Закрыт]" : "{33AA33}[Открыт]"),
        GarageInfo[id][gMaxCars], // Текущий лимит
        10, // Макс. предел
        floatround(GarageInfo[id][gPrice] * 0.5) // Госс возврат 50%
    );

    ShowPlayerDialog(playerid, 9921, DIALOG_STYLE_LIST, "{FF8C00}Панель управления Гаражом", str, "Выбрать", "Закрыть");
    return 1;
}





в пвн (OnDialogResponse)




public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    // 1. ПОКУПКА ГАРАЖА
    if(dialogid == 9920)
    {
        if(!response) return DeletePVar(playerid, "BuyGarageID");
        new id = GetPVarInt(playerid, "BuyGarageID");
        DeletePVar(playerid, "BuyGarageID");

        if(GetPlayerMoneyEx(playerid) < GarageInfo[id][gPrice]) 
            return SendClientMessage(playerid, 0xFF3333FF, "У вас недостаточно денег!");

        // Проверка на лимит владений
        // (Реализуй проверку по своей базе данных или переменным аккаунта)

        GivePlayerMoneyEx(playerid, -GarageInfo[id][gPrice]);
        
        GarageInfo[id][gOwnerID] = GetPlayerSQLID(playerid);
        GetPlayerName(playerid, GarageInfo[id][gOwnerName], MAX_PLAYER_NAME);
        GarageInfo[id][gLocked] = 1;
        GarageInfo[id][gMaxCars] = GarageClassData[GarageInfo[id][gClass]][gcDefaultSlots];

        // Сохраняем в БД
        new query[256];
        mysql_format(mysql, query, sizeof(query), "UPDATE garages SET owner_id = %d, owner_name = '%e', locked = 1, max_cars = %d WHERE id = %d", GarageInfo[id][gOwnerID], GarageInfo[id][gOwnerName], GarageInfo[id][gMaxCars], GarageInfo[id][gSQLID]);
        mysql_tquery(mysql, query);

        UpdateGarageMap(id);
        SendClientMessage(playerid, 0x33AA33FF, "[Гараж] Поздравляем! Вы успешно приобрели этот гараж.");
        return 1;
    }

    // 2. УПРАВЛЕНИЕ ГАРАЖОМ
    if(dialogid == 9921)
    {
        if(!response) return 1;
        new id = PlayerInGarage[playerid];
        if(id == -1) return 1;

        switch(listitem)
        {
            case 0: // Замок
            {
                GarageInfo[id][gLocked] = !GarageInfo[id][gLocked];
                SendClientMessage(playerid, 0xFFFF00FF, (GarageInfo[id][gLocked] ? "[Гараж] Вы закрыли ворота." : "[Гараж] Вы открыли ворота для всех."));
                
                new query[128];
                mysql_format(mysql, query, sizeof(query), "UPDATE garages SET locked = %d WHERE id = %d", GarageInfo[id][gLocked], GarageInfo[id][gSQLID]);
                mysql_tquery(mysql, query);
                
                UpdateGarageMap(id);
            }
            case 1: // Меню прокачки
            {
                new str[256];
                format(str, sizeof(str), 
                    "Улучшение\tСтатус\tЦена\n\
                    Шкаф одежды\t%s\t{33AA33}150,000 руб.\n\
                    Система вентиляции\t%s\t{33AA33}80,000 руб.",


                    (GarageInfo[id][gWardrobe] ? "{33AA33}Куплено" : "{FF3333}Отсутствует"),
                    (GarageInfo[id][gVentilation] ? "{33AA33}Куплено" : "{FF3333}Отсутствует")
                );
                ShowPlayerDialog(playerid, 9922, DIALOG_STYLE_TABLIST_HEADERS, "{FF8C00}Улучшение Гаража", str, "Купить", "Назад");
            }
            case 2: // Расширение мест
            {
                new cost = GarageInfo[id][gMaxCars] * 100000; // Цена прогрессивная
                new str[256];
                format(str, sizeof(str), "{FFFFFF}Ваш текущий лимит мест: {FF8C00}%d авто{FFFFFF}.\n\nЖелаете докупить 1 дополнительное парковочное место?\nСтоимость улучшения: {33AA33}%d рублей.", GarageInfo[id][gMaxCars], cost);
                ShowPlayerDialog(playerid, 9923, DIALOG_STYLE_MSGBOX, "{FF8C00}Покупка мест", str, "Купить", "Назад");
            }
            case 3: // Слив в гос
            {
                new sell_price = floatround(GarageInfo[id][gPrice] * 0.5);
                new str[256];
                format(str, sizeof(str), "{FFFFFF}Вы уверены, что хотите продать гараж государству за {FF3333}%d рублей{FFFFFF}?\nВсе купленные улучшения будут аннулированы!", sell_price);
                ShowPlayerDialog(playerid, 9924, DIALOG_STYLE_MSGBOX, "{FF3333}Продажа государству", str, "Продать", "Назад");
            }
        }
        return 1;
    }

    // 3. ПОКУПКА УЛУЧШЕНИЙ
    if(dialogid == 9922)
    {
        if(!response) return cmd_gmenu(playerid);
        new id = PlayerInGarage[playerid];
        if(id == -1) return 1;

        if(listitem == 0) // Шкаф
        {
            if(GarageInfo[id][gWardrobe]) return SendClientMessage(playerid, -1, "Шкаф уже установлен!");
            if(GetPlayerMoneyEx(playerid) < 150000) return SendClientMessage(playerid, -1, "Недостаточно денег!");

            GivePlayerMoneyEx(playerid, -150000);
            GarageInfo[id][gWardrobe] = 1;
            
            mysql_tquery(mysql, "UPDATE garages SET wardrobe = 1 WHERE id = ...");// Сохрани в БД
            SendClientMessage(playerid, 0x33AA33FF, "Вы установили шкаф! Теперь вы можете менять скины в гараже.");
        }
        if(listitem == 1) // Вентиляция
        {
            if(GarageInfo[id][gVentilation]) return SendClientMessage(playerid, -1, "Вентиляция уже установлена!");
            if(GetPlayerMoneyEx(playerid) < 80000) return SendClientMessage(playerid, -1, "Недостаточно денег!");

            GivePlayerMoneyEx(playerid, -80000);
            GarageInfo[id][gVentilation] = 1;
            
            mysql_tquery(mysql, "UPDATE garages SET ventilation = 1 WHERE id = ...");// Сохрани в БД
            SendClientMessage(playerid, 0x33AA33FF, "Вы установили вентиляцию! Снижен налог на гараж.");
        }
        return 1;
    }
    return 0;
}







