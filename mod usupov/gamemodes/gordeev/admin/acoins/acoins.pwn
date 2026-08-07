#define GetPlayerAdmCoins(%0) 			GetPlayerData(%0, P_ADMIN_COINS) 	// текущий баланс админ-коинов

#if defined _admin_shop_included
    #endinput
#endif
#define _admin_shop_included

#define COLOR_ADMIN_SHOP 0xFFA500FF
#define COLOR_ADMIN_SHOP_RED 0xFF0000FF
#define COLOR_ADMIN_SHOP_GREEN 0x00FF00FF

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    // Админ магазин
    if(dialogid == 11230)
    {
        if(!response) return 1;
        
        switch(listitem)
        {
            case 0: // Донат валюта
            {
                new coins = GetPlayerAdmCoins(playerid);
                new header[128];
                format(header, sizeof header, "{FFFF00}USUPOV RP {FFFFFF}| Донат валюта | Баланс: %d", coins);
                
                Dialog
                (
                    playerid, 11231, DIALOG_STYLE_LIST,
                    header,
                    "1. 100 доната\t\t\t\t\t100 админ-коинов\n\
                     2. 500 доната\t\t\t\t\t500 админ-коинов\n\
                     3. 1000 доната\t\t\t\t1000 админ-коинов\n\
                     4. 5000 доната\t\t\t\t5000 админ-коинов",
                    "Выбрать", "Назад"
                );
            }
            case 1: // Виртуальная валюта
            {
                new coins = GetPlayerAdmCoins(playerid);
                new header[128];
                format(header, sizeof header, "{FFFF00}USUPOV RP {FFFFFF}| Виртуальная валюта | Баланс: %d", coins);
                
                Dialog
                (
                    playerid, 11232, DIALOG_STYLE_LIST,
                    header,
                    "1. 1.000.000 рублей \t\t\t\t\t100 админ-коинов\n\
                     2. 5.000.000 рублей \t\t\t\t\t500 админ-коинов\n\
                     3. 10.000.000 рублей\t\t\t\t1000 админ-коинов\n\
                     4. 50.000.000 рублей\t\t\t\t5000 админ-коинов",
                    "Выбрать", "Назад"
                );
            }
            case 2: // Эсклюзивная одежда
            {
                new coins = GetPlayerAdmCoins(playerid);
                new header[128];
                format(header, sizeof header, "{FFFF00}USUPOV RP {FFFFFF}| Эсклюзивная одежда | Баланс: %d", coins);
                
                Dialog
                (
                    playerid, 11233, DIALOG_STYLE_LIST,
                    header,
                    "1. Вин Дизель\t\t\t\t\t5000 админ-коинов\n\
                     2. Администратор\t\t\t\t\t 3000 админ-коинов\n\
                     3. Пират\t\t\t\t10000 админ-коинов\n\
                     4. Пиратка\t\t\t\t10000 админ-коинов\n\
                     5. Тестеровщик\t\t\t25000 админ-коинов\n\
                     6. Террорист\t\t\t\t10000 админ-коинов\n\
                     7. Колян\t\t\t\t\t2500 админ-коинов\n\
                     8. Антоха\t\t\t\t\t2500 админ-коинов\n\
                     9. Вован\t\t\t\t2500 админ-коинов\n\
                     10. Кирилл Муханов\t\t\t\t5000 админ-коинов",

                    "Выбрать", "Назад"
                );
            }
            case 3: // Эсклюзивные аксессуары
{
    new coins = GetPlayerAdmCoins(playerid);
    new header[128];
    format(header, sizeof header, "{FFFF00}USUPOV RP {FFFFFF}| Эсклюзивные аксессуары | Баланс: %d", coins);
    
    Dialog
    (
        playerid, 11234, DIALOG_STYLE_LIST,
        header,
        "1. Новогодний шарф 1\t\t\t\t\t2500 админ-коинов\n\
         2. Новогодний шарф 2\t\t\t\t\t2500 админ-коинов\n\
         3. Новогодний шарф 3\t\t\t\t\t2500 админ-коинов\n\
         4. Новогодний шарф 4\t\t\t\t\t2500 админ-коинов\n\
         5. Новогодний шарф 5\t\t\t\t\t2500 админ-коинов\n\
         6. Новогодний шарф 6\t\t\t\t\t2500 админ-коинов\n\
         7. Новогодняя маска 1\t\t\t\t1500 админ-коинов\n\
         8. Новогодняя маска 2\t\t\t\t1500 админ-коинов\n\
         9. Новогодняя маска 3\t\t\t\t1500 админ-коинов\n\
         10. Новогодняя маска 4\t\t\t\t1500 админ-коинов\n\
         11. Череп воробья\t\t\t\t\t 10000 админ-коинов\n\
         12. Венок \t\t\t\t\t\t\t\t\t\t\t7000 админ-коинов",
        "Выбрать", "Назад"
    );
}
        }
        return 1;
    }
    
    // Донат валюта
    if(dialogid == 11231 && response)
    {
        new coins = GetPlayerAdmCoins(playerid);
        new price, donate;
        
        switch(listitem)
        {
            case 0: { price = 100; donate = 100; }
            case 1: { price = 500; donate = 500; }
            case 2: { price = 1000; donate = 1000; }
            case 3: { price = 5000; donate = 5000; }
        }
        
        if(coins < price)
        {
            SendClientMessage(playerid, COLOR_ADMIN_SHOP_RED, "У вас недостаточно админ-коинов!");
            return 1;
        }
        
        TakePlayerAdmCoins(playerid, price);
        GivePlayerDonateRub(playerid, donate);
        
        new string[128];
        format(string, sizeof string, "Вы купили %d доната за %d админ-коинов!", donate, price);
        SendClientMessage(playerid, COLOR_ADMIN_SHOP_GREEN, string);
        return 1;
    }
    
    // Виртуальная валюта
    if(dialogid == 11232 && response)
    {
        new coins = GetPlayerAdmCoins(playerid);
        new price, money;
        
        switch(listitem)
        {
            case 0: { price = 100; money = 1000000; }
            case 1: { price = 500; money = 5000000; }
            case 2: { price = 1000; money = 10000000; }
            case 3: { price = 5000; money = 50000000; }
        }
        
        if(coins < price)
        {
            SendClientMessage(playerid, COLOR_ADMIN_SHOP_RED, "У вас недостаточно админ-коинов!");
            return 1;
        }
        
        TakePlayerAdmCoins(playerid, price);
        GivePlayerMoneyEx(playerid, money);
        
        new string[128];
        format(string, sizeof string, "Вы купили %d$ за %d админ-коинов!", money, price);
        SendClientMessage(playerid, COLOR_ADMIN_SHOP_GREEN, string);
        return 1;
    }
    
    // Эсклюзивная одежда
    if(dialogid == 11233 && response)
    {
        new coins = GetPlayerAdmCoins(playerid);
        new price, skin;
        
        switch(listitem)
        {
            case 0: { price = 5000; skin = 25; }      // Вин Дизель
            case 1: { price = 3000; skin = 122; }     // Администратор
            case 2: { price = 10000; skin = 5341; }     // Пират
            case 3: { price = 10000; skin = 5343; }     // Пиратка
            case 4: { price = 25000; skin = 303; }      // Тестеровщик
            case 5: { price = 10000; skin = 18595; }      // Террорист
            case 6: { price = 2500; skin = 18598; }      // Колян
            case 7: { price = 2500; skin = 18597; }      // Антоха
            case 8: { price = 2500; skin = 18599; }      // Вован
            case 9: { price = 5000; skin = 270; }      // Кирилл Муханов
        }

        if(coins < price)
        {
            SendClientMessage(playerid, COLOR_ADMIN_SHOP_RED, "У вас недостаточно админ-коинов!");
            return 1;
        }
        
        TakePlayerAdmCoins(playerid, price);
        GivePlayerOwnableSkin(playerid, skin);
        
        new string[128];
        format(string, sizeof string, "Вы купили эсклюзивную одежду за %d админ-коинов!", price);
        SendClientMessage(playerid, COLOR_ADMIN_SHOP_GREEN, string);
        return 1;
    }
    
    // Эсклюзивные аксессуары
if(dialogid == 11234 && response)
{
    new coins = GetPlayerAdmCoins(playerid);
    new price, accessory_id;
    
    switch(listitem)
    {
        case 0: { price = 2500; accessory_id = 1727; }
        case 1: { price = 2500; accessory_id = 1728; }
        case 2: { price = 2500; accessory_id = 1729; }
        case 3: { price = 2500; accessory_id = 1730; }
        case 4: { price = 2500; accessory_id = 1731; }
        case 5: { price = 2500; accessory_id = 1732; }
        case 6: { price = 1500; accessory_id = 1779; }
        case 7: { price = 1500; accessory_id = 1778; }
        case 8: { price = 1500; accessory_id = 1777; }
        case 9: { price = 1500; accessory_id = 1776; }
        case 10: { price = 10000; accessory_id = 5374; }
        case 11: { price = 7000; accessory_id = 13762; }
    }

    if(coins < price)
    {
        SendClientMessage(playerid, COLOR_ADMIN_SHOP_RED, "У вас недостаточно админ-коинов!");
        return 1;
    }
    
    // Находим индекс аксессуара в массиве accessory_inv
    new inv_index = -1;
    for(new i = 0; i < sizeof(accessory_inv); i++)
    {
        if(accessory_inv[i][ID_ACCESSORY] == accessory_id)
        {
            inv_index = i;
            break;
        }
    }
    
    if(inv_index == -1)
    {
        SendClientMessage(playerid, COLOR_ADMIN_SHOP_RED, "Ошибка: аксессуар не найден!");
        return 1;
    }
    
    TakePlayerAdmCoins(playerid, price);
    GiveAccessory(playerid, inv_index);
    
    new string[128];
    format(string, sizeof string, "Вы купили эсклюзивный аксессуар за %d админ-коинов!", price);
    SendClientMessage(playerid, COLOR_ADMIN_SHOP_GREEN, string);
    return 1;
}
    
   #if defined admin_shop_OnDialogResponse
        return admin_shop_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse admin_shop_OnDialogResponse

#if defined admin_shop_OnDialogResponse
    forward admin_shop_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

CMD:ashop(playerid)
{
    new coins = GetPlayerAdmCoins(playerid);
    new string[128], header[64];

    if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 5, 5, 1, "У вас недостаточно прав", "");

    format(header, sizeof header, "{ffff00}USUPOV RP {ffffff}| Админ магазин | %d coins", coins);
    
    Dialog
    (
        playerid, 11230, DIALOG_STYLE_LIST,
        header,
        "1. \t\tДонат валюта \t\t\t\t\t\t\t\t\t\t\t\t\tНажмите для взаимодействия\n\
         2. \t\tВиртуальная валюта \t\t\t\t\t\t\tНажмите для взаимодействия\n\
         3. \t\tЭсклюзивная одежда \t\t\t\t\t\t\tНажмите для взаимодействия\n\
         4. \t\tЭсклюзивные аксессуары \t\t\tНажмите для взаимодействия",
        "Выбрать", "Закрыть"
    );
    return 1;
}

CMD:givecoins(playerid, params[])
{
    new targetid, amount;
    
    if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 5, 5, 1, "У вас недостаточно прав", "");
    
    if(sscanf(params, "ud", targetid, amount)) return SendClientMessage(playerid, COLOR_WHITE, "{ffff00}| {ffffff}Использование: {ffff00}/giveadcoins {ffffff}[айди игрока] [количество]");
    
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "{ffff00}| {ffffff}Игрок не найден!");
    
    if(amount < 1) return SendClientMessage(playerid, COLOR_RED, "{ffff00}| {ffffff}Сумма должна быть больше 0!");

    GivePlayerAdmCoins(playerid, amount);
    
    new string[128];

    format(string, sizeof string, "[A] %s[%d] выдал %d админ-коинов администратору %s[%d]", GetPlayerNameEx(playerid), playerid, amount, GetPlayerNameEx(targetid), targetid);
    SendMessageToAdmins(string, 0x999999FF);
    
    format(string, sizeof string, "Администратор %s выдал вам %d админ-коинов!", GetPlayerNameEx(playerid), amount);
    ShowNotificationNew(targetid, 3, 5, 5, 1, string, "");
    
    return 1;
}

stock GivePlayerAdmCoins(playerid, amount)
{
    new string[128];
    
    // Обновляем данные игрока
    SetPlayerData(playerid, P_ADMIN_COINS, GetPlayerData(playerid, P_ADMIN_COINS) + amount);
    
    // Запись в БД
    mysql_format(mysql, string, sizeof string, "UPDATE accounts SET adm_coins = adm_coins + %d WHERE id = %d", amount, GetPlayerAccountID(playerid));
    mysql_query(mysql, string, false);
    
    // Лог выдачи
    mysql_format(mysql, string, sizeof string, "INSERT INTO adm_coins_log (player_id, amount, type, date) VALUES (%d, %d, 'give', UNIX_TIMESTAMP())", GetPlayerAccountID(playerid), amount);
    mysql_query(mysql, string, false);
    
    return 1;
}

stock TakePlayerAdmCoins(playerid, amount)
{
    new string[128];
    
    // Обновляем данные игрока
    SetPlayerData(playerid, P_ADMIN_COINS, GetPlayerData(playerid, P_ADMIN_COINS) - amount);
    
    // Запись в БД
    mysql_format(mysql, string, sizeof string, "UPDATE accounts SET adm_coins = adm_coins - %d WHERE id = %d", amount, GetPlayerAccountID(playerid));
    mysql_query(mysql, string, false);
    
    // Лог снятия
    mysql_format(mysql, string, sizeof string, "INSERT INTO adm_coins_log (player_id, amount, type, date) VALUES (%d, %d, 'take', UNIX_TIMESTAMP())", GetPlayerAccountID(playerid), amount);
    mysql_query(mysql, string, false);
    
    return 1;
}