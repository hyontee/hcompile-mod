// ==========================================
//          СИСТЕМА ТК (БАТ) - ИСПРАВЛЕННАЯ
// ==========================================

#if defined _tc_system_included
    #endinput
#endif
#define _tc_system_included

#include <a_samp>

// ---------- УБИРАЕМ extern, ИСПОЛЬЗУЕМ forward ----------
// ВСЕ ФУНКЦИИ С mysql ЗАМЕНЯЕМ НА ЗАГЛУШКИ

// ---------- КОНСТАНТЫ ----------
enum {
    DLG_TC_HIRE = 1050,
    DLG_TC_RENT,
    DLG_TC_ZAKAZ
}

#define DLG_TC_MENU     1007
#define DLG_TC_SELL_GS  1008
#define DLG_TC_PAY      1009
#define DLG_TC_BUY      1004
#define DLG_TC_OWNER    1005
#define DLG_TC_WITHDRAW 1006

// ---------- ПЕРЕМЕННЫЕ ----------
new TCOverdue;
new LastSpawnTime[3];
new TCOwner[MAX_PLAYER_NAME] = "None";
new TCBalance;
new TCBuyPickup;
static bool:IsJobTC[MAX_PLAYERS];
static bool:IsLoading[MAX_PLAYERS];
static ZakazID[MAX_PLAYERS];
static TC_Vehicle[MAX_PLAYERS];
static TC_Checkpoint[MAX_PLAYERS];
static pInTC, pOutTC, pHireTC, pRentTC;

// ==========================================
//          ONGAMEMODEINIT
// ==========================================

public OnGameModeInit()
{
    // УБИРАЕМ mysql_tquery, ИСПОЛЬЗУЕМ ОБЫЧНЫЙ ВЫЗОВ
    // mysql_tquery(mysql, "SELECT * FROM `trucking_company` LIMIT 1", "LoadTCData");
    // ВРЕМЕННО ЗАГРУЖАЕМ ДАННЫЕ ВРУЧНУЮ
    format(TCOwner, MAX_PLAYER_NAME, "None");
    TCBalance = 0;
    TCOverdue = 0;
    
    SetTimer("CheckTCOverdue", 60000, true);

    TCBuyPickup = CreatePickup(1274, 23, 1.0810, 2508.8562, 2011.0451, 0);
    pInTC = CreatePickup(19130, 23, 2327.743164, 2009.634887, 16.660203, -1);
    pOutTC = CreatePickup(19130, 23, -0.200575, 2500.248291, 2011.045166, -1);
    pHireTC = CreatePickup(1239, 23, 2.011036, 2503.443603, 2011.045166, -1);
    pRentTC = CreatePickup(19134, 23, 2316.708007, 2012.259277, 16.161876, -1);

    Create3DTextLabel("{ffcc00}Вход в офис", 0xFFFFFFFF, 2327.743164, 2009.634887, 16.660203, 10.0, 0, 1);
    Create3DTextLabel("{ffcc00}Выход", 0xFFFFFFFF, -0.200575, 2500.248291, 2011.045166, 10.0, 0, 1);
    Create3DTextLabel("{ffcc00}Трудоустройство", 0xFFFFFFFF, 2.011036, 2503.443603, 2011.045166, 10.0, 0, 1);
    Create3DTextLabel("{ffcc00}Автопарк", 0xFFFFFFFF, 2316.708007, 2012.259277, 16.161876, 10.0, 0, 1);
    Create3DTextLabel("{ffcc00}Покупка транспортной компании", 0xFFFFFFFF, 1.0810, 2508.8562, 2011.0451, 10.0, 0, 1);

    #if defined tc_OnGameModeInit
        return tc_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit tc_OnGameModeInit
#if defined tc_OnGameModeInit
    forward tc_OnGameModeInit();
#endif

// ==========================================
//          КОМАНДЫ
// ==========================================

CMD:zakaz(playerid)
{
    if(!IsJobTC[playerid]) return SendClientMessage(playerid, -1, "Вы не работаете дальнобойщиком!");
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleID(playerid) != TC_Vehicle[playerid]) 
        return SendClientMessage(playerid, -1, "Вы должны быть в рабочем транспорте ТК!");
    
    ShowPlayerDialog(playerid, DLG_TC_ZAKAZ, DIALOG_STYLE_LIST, "Выбор заказа", "ТОПЛИВО (10кк)\nМЕТАЛЛ (10кк)\nАРБУЗЫ (5кк)", "Взять", "Отмена");
    return 1;
}

CMD:zakazinfo(playerid)
{
    if(!IsJobTC[playerid]) return SendClientMessage(playerid, -1, "Вы не работаете дальнобойщиком!");
    if(ZakazID[playerid] == 0) return SendClientMessage(playerid, -1, "У вас нет активного заказа.");

    new str[144], cargo_name[16], location[32], Float:tX, Float:tY, Float:tZ;
    switch(ZakazID[playerid]) {
        case 1: cargo_name = "ТОПЛИВО";
        case 2: cargo_name = "МЕТАЛЛ";
        case 3: cargo_name = "АРБУЗЫ";
    }

    if(TC_Checkpoint[playerid] == 1) {
        switch(ZakazID[playerid]) {
            case 1: { tX = 1735.4753; tY = 2258.5187; tZ = 15.4875; location = "Шахта"; }
            case 2: { tX = 2381.7846; tY = 1728.0380; tZ = 13.2791; location = "Нефтебаза"; }
            case 3: { tX = 1661.1229; tY = 1330.0316; tZ = 12.3625; location = "Ферма"; }
        }
    } else {
        switch(ZakazID[playerid]) {
            case 1: { tX = 2276.2939; tY = -739.6619; tZ = 12.9967; location = "Завод"; }
            case 2: { tX = -992.3968; tY = 2151.2387; tZ = 44.1668; location = "АЗС"; }
            case 3: { tX = -1327.7851; tY = -1545.6258; tZ = 60.4284; location = "Склад"; }
        }
    }
    format(str, sizeof(str), "[ТК] Груз: %s | Цель: %s | Дистанция: %.0f м.", cargo_name, location, GetPlayerDistanceFromPoint(playerid, tX, tY, tZ));
    SendClientMessage(playerid, 0x33CCFFFF, str);
    return 1;
}

CMD:tcompany(playerid)
{
    new pName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pName, sizeof(pName));

    if(strcmp(TCOwner, pName, true) != 0) 
        return SendClientMessage(playerid, 0xFF0000FF, "[Ошибка] Вы не владелец этой ТК!");

    new str[256];
    format(str, sizeof(str), "1. Снять прибыль\n2. Продлить аренду\n3. Продать бизнес государству");
    ShowPlayerDialog(playerid, DLG_TC_MENU, DIALOG_STYLE_LIST, "Управление ТК", str, "Выбрать", "Закрыть");
    return 1;
}

// ==========================================
//          ОБРАБОТКА ДИАЛОГОВ
// ==========================================

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DLG_TC_MENU: {
            if(response) {
                switch(listitem) {
                    case 0: {
                        if(TCBalance <= 0) 
                            return SendClientMessage(playerid, 0xFF0000FF, "[Ошибка] На балансе ТК нет денег!");
                        
                        new str[128];
                        format(str, sizeof(str), "На балансе предприятия: %d Руб.\nВведите сумму, которую хотите снять:", TCBalance);
                        ShowPlayerDialog(playerid, DLG_TC_WITHDRAW, DIALOG_STYLE_INPUT, "Снятие прибыли", str, "Снять", "Назад");
                    }
                    case 1: {
                        new days = (TCOverdue - gettime()) / 86400; 
                        if(days < 0) days = 0;
                        
                        new str[256];
                        format(str, sizeof(str), 
                            "Ваша ТК оплачена еще на: %d дн.\n\
                            Стоимость оплаты 1 дня - 1.000.000 Руб.\n\n\
                            Введите количество дней для продления (макс. до 7 дней всего):", days);
                        
                        ShowPlayerDialog(playerid, DLG_TC_PAY, DIALOG_STYLE_INPUT, "Оплата аренды", str, "Оплатить", "Назад");
                    }
                    case 2: {
                        new str[128];
                        format(str, sizeof(str), "Вы уверены, что хотите продать ТК в гос. за 250.000.000 Руб.?");
                        ShowPlayerDialog(playerid, DLG_TC_SELL_GS, DIALOG_STYLE_MSGBOX, "Продажа бизнеса", str, "Продать", "Отмена");
                    }
                }
            }
            return 1;
        }

        case DLG_TC_PAY: {
            if(response) {
                new days = strval(inputtext);
                if(days < 1 || days > 7) return SendClientMessage(playerid, -1, "Можно продлить от 1 до 7 дней!");
                
                new current_days = (TCOverdue - gettime()) / 86400;
                if(current_days + days > 7) return SendClientMessage(playerid, -1, "Максимальный срок аренды — 7 дней!");

                new price = days * 1000000;
                if(GetPlayerMoney(playerid) < price) return SendClientMessage(playerid, -1, "У вас недостаточно денег!");

                GivePlayerMoney(playerid, -price);
                
                if(TCOverdue < gettime()) TCOverdue = gettime() + (days * 86400);
                else TCOverdue += (days * 86400);

                // УБИРАЕМ mysql запросы
                // new query[128];
                // mysql_format(mysql, query, sizeof(query), "UPDATE trucking_company SET overdue = %d", TCOverdue);
                // mysql_tquery(mysql, query);

                new str[128];
                format(str, sizeof(str), "Вы продлили аренду на %d дн. за %d Рублей.", days, price);
                SendClientMessage(playerid, 0x00FF00FF, str);
            }
            return 1;
        }

        case DLG_TC_SELL_GS: {
            if(response) {
                GivePlayerMoney(playerid, 250000000);
                format(TCOwner, MAX_PLAYER_NAME, "None");
                TCBalance = 0;
                
                SendClientMessage(playerid, 0xFFFF00FF, "Вы успешно продали бизнес государству.");

                // УБИРАЕМ mysql запросы
                // new query[128];
                // mysql_format(mysql, query, sizeof(query), "UPDATE trucking_company SET owner = 'None', balance = 0");
                // mysql_tquery(mysql, query);
            }
            return 1;
        }

        case DLG_TC_BUY: {
            if(response) {
                if(GetPlayerMoney(playerid) < 500000000) 
                    return SendClientMessage(playerid, 0xFF0000FF, "[Ошибка] У вас нет 500.000.000 Рублей!");

                GivePlayerMoney(playerid, -500000000);
                GetPlayerName(playerid, TCOwner, MAX_PLAYER_NAME);
                TCBalance = 0;
                
                SendClientMessage(playerid, 0x00FF00FF, "Вы купили транспортную компанию! Открыть меню управления можно через /tcompany");
                
                // УБИРАЕМ mysql запросы
                // new query[128];
                // mysql_format(mysql, query, sizeof(query), "UPDATE trucking_company SET owner = '%e', balance = 0", TCOwner);
                // mysql_tquery(mysql, query);
            }
            return 1;
        }

        case DLG_TC_WITHDRAW: {
            if(!response) return 1;

            new amount = strval(inputtext);
            if(amount <= 0 || amount > TCBalance) {
                new str[150];
                format(str, sizeof(str), "[Ошибка] Неверная сумма! Доступно: %d Руб.", TCBalance);
                return SendClientMessage(playerid, 0xFF0000FF, str);
            }
            
            TCBalance -= amount;
            GivePlayerMoney(playerid, amount);
            
            new str[128];
            format(str, sizeof(str), "Вы успешно сняли %d Руб. Остаток на балансе ТК: %d Руб.", amount, TCBalance);
            SendClientMessage(playerid, 0x00FF00FF, str);

            // УБИРАЕМ mysql запросы
            // new query[128];
            // mysql_format(mysql, query, sizeof(query), "UPDATE trucking_company SET balance = %d", TCBalance);
            // mysql_tquery(mysql, query);
            return 1;
        }

        case DLG_TC_HIRE: {
            if(response) {
                IsJobTC[playerid] = true;
                SendClientMessage(playerid, 0xFFFF00FF, "Вы устроились в ТК. Возьмите транспорт на улице.");
            }
            return 1;
        }

        case DLG_TC_RENT: {
            if(response) {
                if(TC_Vehicle[playerid]) DestroyVehicle(TC_Vehicle[playerid]);
                
                new Float:x, Float:y, Float:z, model, spawnIdx = -1;
                new currentTime = gettime();

                switch(listitem) {
                    case 0: model = 403;
                    case 1: model = 440;
                    case 2: model = 418;
                }

                if(currentTime - LastSpawnTime[0] > 60) spawnIdx = 0;
                else if(currentTime - LastSpawnTime[1] > 60) spawnIdx = 1;
                else if(currentTime - LastSpawnTime[2] > 60) spawnIdx = 2;

                if(spawnIdx == -1) return SendClientMessage(playerid, -1, "[Ошибка] Все площадки заняты. Подождите немного.");

                switch(spawnIdx) {
                    case 0: { x = 2298.9230; y = 1994.5795; z = 15.1256; }
                    case 1: { x = 2311.4670; y = 1994.7589; z = 15.0179; }
                    case 2: { x = 2306.4670; y = 1994.7589; z = 15.0179; }
                }

                LastSpawnTime[spawnIdx] = currentTime;
                
                TC_Vehicle[playerid] = CreateVehicle(model, x, y, z, 138.0, -1, -1, 60000);
                SetVehicleZAngle(TC_Vehicle[playerid], 138.0);
                
                SetPlayerCheckpoint(playerid, x, y, z, 3.0);
                SetTimerEx("CheckPlayerInVehicle", 20000, false, "ii", playerid, TC_Vehicle[playerid]);
                
                SendClientMessage(playerid, -1, "Вы арендовали фуру! Она отмечена красным маркером на карте.");
                SendClientMessage(playerid, -1, "У вас есть 20 секунд, чтобы занять рабочее место.");
            }
            return 1;
        }

        case DLG_TC_ZAKAZ: {
            if(response) {
                ZakazID[playerid] = listitem + 1;
                TC_Checkpoint[playerid] = 1; 
                switch(listitem) {
                    case 0: { SetPlayerRaceCheckpoint(playerid, 2, 1735.4753, 2258.5187, 15.4875, 0.0, 0.0, 0.0, 5.0); }
                    case 1: { SetPlayerRaceCheckpoint(playerid, 2, 2381.7846, 1728.0380, 13.2791, 0.0, 0.0, 0.0, 5.0); }
                    case 2: { SetPlayerRaceCheckpoint(playerid, 2, 1661.1229, 1330.0316, 12.3625, 0.0, 0.0, 0.0, 5.0); }
                }
                SendClientMessage(playerid, -1, "Вы успешно взяли заказ! Отправляйтесь на загрузку (GPS маршрут установлен).");
            }
            return 1;
        }
    }

    #if defined tc_OnDialogResponse
        return tc_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse tc_OnDialogResponse
#if defined tc_OnDialogResponse
    forward tc_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

// ==========================================
//          ОБРАБОТКА ЧЕКПОИНТОВ
// ==========================================

public OnPlayerEnterRaceCheckpoint(playerid)
{
    if(IsLoading[playerid]) return 1;

    if(TC_Checkpoint[playerid] == 1) { 
        IsLoading[playerid] = true; 
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("TCLoading", 2500, false, "ii", playerid, 25);
    }
    else if(TC_Checkpoint[playerid] == 2) { 
        IsLoading[playerid] = true; 
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("TCLoading", 2500, false, "ii", playerid, 125); 
    }

    #if defined tc_OnPlayerEnterRaceCheckpoint
        return tc_OnPlayerEnterRaceCheckpoint(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerEnterRaceCheckpoint
    #undef OnPlayerEnterRaceCheckpoint
#else
    #define _ALS_OnPlayerEnterRaceCheckpoint
#endif
#define OnPlayerEnterRaceCheckpoint tc_OnPlayerEnterRaceCheckpoint
#if defined tc_OnPlayerEnterRaceCheckpoint
    forward tc_OnPlayerEnterRaceCheckpoint(playerid);
#endif

// ==========================================
//          ТАЙМЕР ЗАГРУЗКИ/РАЗГРУЗКИ
// ==========================================

forward TCLoading(playerid, percent);
public TCLoading(playerid, percent)
{
    new str[128]; 
    if(percent <= 100) {
        format(str, sizeof(str), "Загрузка: %d/100", percent);
        SendClientMessage(playerid, 0x00FF00FF, str);
        if(percent == 100) {
            IsLoading[playerid] = false; 
            TogglePlayerControllable(playerid, 1); 
            DisablePlayerRaceCheckpoint(playerid);
            TC_Checkpoint[playerid] = 2;
            
            if(ZakazID[playerid] == 1) { SetPlayerRaceCheckpoint(playerid, 2, 2276.2939, -739.6619, 12.9967, 0.0, 0.0, 0.0, 5.0); }
            else if(ZakazID[playerid] == 2) { SetPlayerRaceCheckpoint(playerid, 2, -992.3968, 2151.2387, 44.1668, 0.0, 0.0, 0.0, 5.0); }
            else if(ZakazID[playerid] == 3) { SetPlayerRaceCheckpoint(playerid, 2, -1327.7851, -1545.6258, 60.4284, 0.0, 0.0, 0.0, 5.0); }
            SendClientMessage(playerid, -1, "Загрузка завершена! Маршрут в GPS обновлен.");
        } else SetTimerEx("TCLoading", 2500, false, "ii", playerid, percent + 25);
    } 
    else {
        new r_percent = percent - 100;
        format(str, sizeof(str), "Разгрузка: %d/100", r_percent);
        SendClientMessage(playerid, 0xFFFF00FF, str);
        
        if(r_percent == 100) {
            IsLoading[playerid] = false; 
            TogglePlayerControllable(playerid, 1); 
            DisablePlayerRaceCheckpoint(playerid);
            DisablePlayerCheckpoint(playerid); 
            
            new money, money_text[32];
            if(ZakazID[playerid] == 3) {
                money = 5000000;
                money_text = "5.000.000 Рублей";
            } else {
                money = 10000000;
                money_text = "10.000.000 Рублей";
            }
            
            GivePlayerMoney(playerid, money);
            format(str, sizeof(str), "Зарплата получена + %s", money_text);
            SendClientMessage(playerid, 0x00FF00FF, str);
            SendClientMessage(playerid, 0x00FF00FF, "Разгрузка завершена! Вы получили оплату.");

            if(strcmp(TCOwner, "None", true) != 0) 
            {
                new commission = money / 10;
                TCBalance += commission;

                // УБИРАЕМ mysql запросы
                // new query[128];
                // mysql_format(mysql, query, sizeof(query), "UPDATE trucking_company SET balance = %d", TCBalance);
                // mysql_tquery(mysql, query);

                for(new i = GetPlayerPoolSize(); i >= 0; i--)
                {
                    if(!IsPlayerConnected(i)) continue;
                    new pName[MAX_PLAYER_NAME];
                    GetPlayerName(i, pName, sizeof(pName));
                    if(strcmp(pName, TCOwner, true) == 0)
                    {
                        new msg[144];
                        format(msg, sizeof(msg), "[Бизнес] Сотрудник завершил заказ. На баланс ТК зачислено: %d Рублей", commission);
                        SendClientMessage(i, -1, msg);
                        break; 
                    }
                }
            }

            TC_Checkpoint[playerid] = 0; 
            ZakazID[playerid] = 0;
        } else SetTimerEx("TCLoading", 2500, false, "ii", playerid, percent + 25);
    }
    return 1;
}

// ==========================================
//          ОБРАБОТКА ПИКАПОВ
// ==========================================

public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
    if(pickupid == pInTC) {
        SetPlayerPos(playerid, -0.0430, 2503.9396, 2011.0451);
        SetPlayerFacingAngle(playerid, 352.3894); 
        SetPlayerInterior(playerid, 1);
    }
    else if(pickupid == pOutTC) {
        SetPlayerPos(playerid, 2327.4177, 2013.0018, 16.1618);
        SetPlayerFacingAngle(playerid, 357.8269); 
        SetPlayerInterior(playerid, 0);
    }
    else if(pickupid == pHireTC) {
        ShowPlayerDialog(playerid, DLG_TC_HIRE, DIALOG_STYLE_MSGBOX, "Трудоустройство", "Вы действительно хотите начать работу в ТК?", "Да", "Нет");
    }
    else if(pickupid == pRentTC) {
        if(!IsJobTC[playerid]) return SendClientMessage(playerid, -1, "Вы не работаете дальнобойщиком!");
        ShowPlayerDialog(playerid, DLG_TC_RENT, DIALOG_STYLE_LIST, "Аренда транспорта ТК", "1. Фура (403)\n2. Бусик Мерс (440)\n3. Бусик Фольксваген (418)", "Выбрать", "Отмена");
    }
    
    if(pickupid == TCBuyPickup)
    {
        if(strcmp(TCOwner, "None", true) == 0)
        {
            ShowPlayerDialog(playerid, DLG_TC_BUY, DIALOG_STYLE_MSGBOX, "Покупка ТК", 
                "Вы действительно хотите приобрести ТК за 500.000.000 Рублей?", 
                "Купить", "Отмена");
        }
        else
        {
            new str[128];
            format(str, sizeof(str), "Транспортная компания уже куплена!\nВладелец: %s", TCOwner);
            ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Транспортная компания", str, "Закрыть", "");
        }
    }

    #if defined tc_OnPlayerPickUpPickupEx
        return tc_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerPickUpPickupEx
    #undef OnPlayerPickUpPickupEx
#else
    #define _ALS_OnPlayerPickUpPickupEx
#endif
#define OnPlayerPickUpPickupEx tc_OnPlayerPickUpPickupEx
#if defined tc_OnPlayerPickUpPickupEx
    forward tc_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
#endif

// ==========================================
//          ТАЙМЕРЫ
// ==========================================

forward CheckPlayerInVehicle(playerid, vehicleid);
public CheckPlayerInVehicle(playerid, vehicleid)
{
    if(!IsValidVehicle(vehicleid)) return 1;
    if(GetPlayerVehicleID(playerid) != vehicleid)
    {
        DestroyVehicle(vehicleid);
        TC_Vehicle[playerid] = 0;
        SendClientMessage(playerid, 0xFF0000FF, "Фура была удалена, так как вы в неё не сели.");
    }
    return 1;
}

forward CheckTCOverdue();
public CheckTCOverdue()
{
    if(TCOverdue != 0 && TCOverdue < gettime() && strcmp(TCOwner, "None", true) != 0) 
    {
        format(TCOwner, MAX_PLAYER_NAME, "None");
        TCBalance = 0;
        TCOverdue = 0;
        // mysql_tquery(mysql, "UPDATE trucking_company SET owner = 'None', balance = 0, overdue = 0");
        SendClientMessageToAll(0xFFCC00FF, "[Новости] Транспортная компания была освобождена за неуплату!");
    }
    return 1;
}

// ==========================================
//          ОБРАБОТКА СОСТОЯНИЯ ИГРОКА
// ==========================================

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER) 
    {
        if(TC_Vehicle[playerid] != INVALID_VEHICLE_ID && GetPlayerVehicleID(playerid) == TC_Vehicle[playerid])
        {
            DisablePlayerCheckpoint(playerid);
            SendClientMessage(playerid, -1, "Приятной поездки! Используйте /zakaz для работы.");
        }
    }

    #if defined tc_OnPlayerStateChange
        return tc_OnPlayerStateChange(playerid, newstate, oldstate);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerStateChange
    #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange tc_OnPlayerStateChange
#if defined tc_OnPlayerStateChange
    forward tc_OnPlayerStateChange(playerid, newstate, oldstate);
#endif

// ==========================================
//          ЗАГРУЗКА ДАННЫХ (ЗАГЛУШКА)
// ==========================================

forward LoadTCData();
public LoadTCData()
{
    // ВРЕМЕННАЯ ЗАГРУЗКА
    format(TCOwner, MAX_PLAYER_NAME, "None");
    TCBalance = 0;
    TCOverdue = 0;
    printf("[Система ТК] Данные загружены (заглушка).");
    return 1;
}