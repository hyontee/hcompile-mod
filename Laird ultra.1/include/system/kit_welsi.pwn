//Подпишись на канал автора: t.me/welsistudio





enum STRUCT_KIT
{
    KIT_Name[24],
    KIT_SQL,
    KIT_TypePrice,
    KIT_Price,
    bool:KIT_Promotion,
    KIT_Discount //%
}

#define kc "{E84934}| {FFFFFF}"
#define MAX_KIT 15

new kit[MAX_KIT][STRUCT_KIT];
new kit_item[MAX_KIT][10][2];

#define KIT_NONE 0
#define KIT_EXP 1
#define KIT_MONEY 2
#define KIT_DONATE 3
#define KIT_BVIP 4
#define KIT_SVIP 5
#define KIT_GVIP 6
#define KIT_CAR 7
#define KIT_SKIN 8
#define KIT_SLOT 9
//Telegram: t.me/welsistudio

new p_createkit[MAX_PLAYERS][2];


public OnGameModeInit()
{
    print("[W_SYSTEM] Система Наборов загружена.");

    SetTimer("LOADKITDATABASE", 1700, false);
    SetTimer("load_kit", 2500, false);
    #if defined name_OnGameModeInit
        return name_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit name_OnGameModeInit
#if defined name_OnGameModeInit
    forward name_OnGameModeInit();
#endif

public:LOADKITDATABASE()
{
    mysql_query(mysql, "SELECT * FROM kit", false);

    if(mysql_errno())
    {
        mysql_query(mysql, "CREATE TABLE `kit` (`id` INT NOT NULL AUTO_INCREMENT , `name` VARCHAR(24) NOT NULL , `typeprice` INT NOT NULL , `price` INT NOT NULL , `promotion` INT NOT NULL , `discount` INT NOT NULL , `items` VARCHAR(124) NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB", false);
        if(mysql_errno()) printf("error sql kit");
    }
    
}

public: load_kit()
{
    new Cache: author_welsi = mysql_query(mysql, "SELECT * FROM kit", true);

    new rows = cache_num_rows();

    if(rows)
    {
        new item_list[124];

        if(rows > MAX_KIT) {
            printf("[W_SYSTEM] KIT SYSTEM: Количество наборов (%d) превышает максимальное количество (%d).", rows, MAX_KIT);
            rows = MAX_KIT;
        }
//Telegram: t.me/welsistudio
        for(new i, ar[20]; i < rows; i++)
        {
            cache_get_field_content(i, "name", kit[i][KIT_Name]);
            kit[i][KIT_SQL] = cache_get_field_content_int(i, "id");
            kit[i][KIT_TypePrice] = cache_get_field_content_int(i, "typeprice");
            kit[i][KIT_Price] = cache_get_field_content_int(i, "price");
            kit[i][KIT_Promotion] = cache_get_field_content_int(i, "promotion") ? true : false; //акция
            kit[i][KIT_Discount] = cache_get_field_content_int(i, "discount"); //процент скидки
            if(!(1 <= kit[i][KIT_Discount] <= 99)) kit[i][KIT_Discount] = 0;
            
            cache_get_field_content(i, "items", item_list);
            sscanf(item_list, "p<,>a<i>[20]", ar);

            for(new w, IamStupid; w < 20; w ++)
            {
                if(!(w % 2))
                {
                    kit_item[i][w / 2][0] = ar[w]; printf("1: %d", w);
                }
                else { kit_item[i][IamStupid][1] = ar[w]; IamStupid++; printf("2: %d", w);}
                
            }

            for(new e; e < 10 ;e ++)  
            {
                printf("kit_item[%d][%d][0] = %d", i, e, kit_item[i][e][0]);
                printf("kit_item[%d][%d][1] = %d", i, e, kit_item[i][e][1]);
            }
        }


    }
    else printf("[W_SYSTEM] KIT SYSTEM: Наборы не найдены.");
}

stock FreeIdKit()
{
    for(new i; i < MAX_KIT; i++)
    {
        if(kit_item[i][0][0] != 0 ) continue;

        return i;
    }

    return -1;//Telegram: t.me/welsistudio
}

stock ClearKit(id)
{
    printf("%d count", sizeof kit_item[]);

    for(new i, s = sizeof kit_item[] ; i < s; i ++)
    {
        kit_item[id][i][0] = 0;
        kit_item[id][i][1] = 0;
    }

    kit[id][KIT_Name][0] = '\0';
    kit[id][KIT_Discount] = 0;
    kit[id][KIT_TypePrice] = -1;
    kit[id][KIT_Price] = 0;
    kit[id][KIT_Promotion] = false;

    return 1;
}

cmd:deletekit(playerid)
{
    new s, string[94], dialog[MAX_KIT * sizeof string], promotion[24], price[48];

    for(new i, count; i < MAX_KIT; i ++)
    {
        if(kit_item[i][0][0] == 0) continue;

        format(string, sizeof string, "{FFFFFF}%s\n", kit[i][KIT_Name]);
        strcat(dialog, string);
        SetPlayerListitemValue(playerid, s, i);
        s ++;
    }
    
    if(!s) return SendClientMessage(playerid, -1, ""kc"Наборы не найдены.");

    p_createkit[playerid][0] = -1;
    p_createkit[playerid][1] = 0;
    
    Dialog
    (
        playerid, 5387, DIALOG_STYLE_LIST, 
        "{E84934}Выберите набор для удаления",
        dialog, "Удалить", "Выйти"
    );

    return 1;
}

cmd:createkit(playerid)
{
    if(GetPlayerAdminEx(playerid) < 7) return 0; //поменяйте 7 на уровень админа с которого будет доступна команда

    new id = FreeIdKit();

    if(id == -1) return SendClientMessage(playerid, -1, "Достигнуто максимальное количество наборов. Удалите (/deletekit) один набор для создания нового");
   
    p_createkit[playerid][0] = id;
    ShowCDialogKit(playerid, 0);
    return 1;
}

stock ShowCDialogKit(playerid, type)
{
    p_createkit[playerid][1] = type;

    switch(type)
    {
        case 0:
        {
            Dialog
            (
                playerid, 5384, DIALOG_STYLE_INPUT,
                "{E84934}Создание набора {FFFFFF}| Название набора",
                "Введите название для будущего набора\n"\
                ""kc"Например: Набор Администратора",
                "Назвать", "Выйти"
            );
        }
        case 1:
        {
            Dialog//Telegram: t.me/welsistudio
            (
                playerid, 5384, DIALOG_STYLE_LIST,
                "{E84934}Создание набора {FFFFFF}| Выберите валюту",
                "Покупка набора за {E84934}игровую {FFFFFF}валюту\n"\
                "Покупка набора за {E84934}донат {FFFFFF}валюту",
                "Выбрать", "Назад"
            );
        }
        case 2:
        {
            Dialog
            (
                playerid, 5384, DIALOG_STYLE_INPUT,
                "{E84934}Создание набора {FFFFFF}| Стоимость",
                "Введите стоимость набора\n"\
                ""kc"Например: 1000000",
                "Выбрать", "Назад"
            );
        }
        case 3:
        {
            new string[1024];
            format(string, sizeof string, "%s", StringItemKit(p_createkit[playerid][0], _, true));

            DeletePVar(playerid, "itemid");
            DeletePVar(playerid, "itemtype");
            Dialog
            (
                playerid, 5384, DIALOG_STYLE_LIST,
                "{E84934}Создание набора {FFFFFF}| Предметы",
                string,
                "Выбрать", "Назад"
            );
        }
        case 4:{
            new string[124];

            switch(GetPVarInt(playerid, "itemtype"))
            {
                case KIT_EXP:format(string, sizeof string, "Введите количество опыта\n"kc"Примечание: количество от 1 до 100");
                case KIT_MONEY:format(string, sizeof string, "Введите количество игровой валюты\n"kc"Примечание: количество от 1 до 1.000.000");
                case KIT_DONATE:format(string, sizeof string, "Введите количество донат валюты\n"kc"Примечание: количество от 1 до 10.000");
                case KIT_BVIP..KIT_GVIP:format(string, sizeof string, "Введите количество дней\n"kc"Примечание: количество от 1 до 365");
                case KIT_CAR:format(string, sizeof string, "Введите ID транспорта\n"kc"Примечание: ID от 400 до %d", sizeof g_vehicle_info + 399);
                case KIT_SKIN:format(string, sizeof string, "Введите ID одежды (скина)\n"kc"Примечание: ID от 1 до 311");
                case KIT_SLOT:format(string, sizeof string, "Введите количество слотов\n"kc"Примечание: количество от 1 до 30");
            }
            
            Dialog(playerid, 5384, DIALOG_STYLE_INPUT, "{E84934}Создание набора {FFFFFF}| Настройка предмета", string, "Сохранить", "Назад");
        }
    }
}




stock WELLSI_AUTHOOOR(playerid, exp)
{
    AddPlayerData(playerid, P_EXP, +, exp);
    UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));

    if(GetPlayerExp(playerid) > GetExpToNextLevel(playerid))
    {
        SetPlayerData(playerid, P_EXP, 0);
        AddPlayerData(playerid, P_LEVEL, +, 1);

        SetPlayerLevelInit(playerid);
        SendClientMessage(playerid, -1, ""kc"Поздравляем! Ваш уровень повышен");
    }
}
//Telegram: t.me/welsistudio
stock StringItemKit(id, item_id = 0, bool:dialog = false){

    new List[68], String[sizeof List * sizeof kit_item[] + 18] = ""kc"Сохранить предметы набора\n";
    if(dialog)
    {
        for(new i, s = sizeof kit_item[]; i < s; i++)
        {
            switch(kit_item[id][i][0])
            {
                case KIT_NONE:format(List, sizeof List, "%d. Не выбран\n", i + 1);
                case KIT_EXP:format(List, sizeof List, "%d. Игровой опыт - %d опыта\n", i + 1, kit_item[id][i][1]);
                case KIT_MONEY:format(List, sizeof List, "%d. Игровая валюта (Деньги) - %d р.\n", i + 1, kit_item[id][i][1]);
                case KIT_DONATE:format(List, sizeof List, "%d. Игровой донат - %d д.\n", i + 1, kit_item[id][i][1]);
                case KIT_BVIP:format(List, sizeof List, "%d. Bronze VIP на %d дней\n", i + 1, kit_item[id][i][1]);
                case KIT_SVIP:format(List, sizeof List, "%d. Silver VIP на %d дней\n", i + 1, kit_item[id][i][1]);
                case KIT_GVIP:format(List, sizeof List, "%d. Gold VIP на %d дней\n", i + 1, kit_item[id][i][1]);
                case KIT_CAR:format(List, sizeof List, "%d. %s\n", i + 1, GetVehicleInfo(kit_item[id][i][1]-400, VI_NAME));
                case KIT_SKIN:format(List, sizeof List, "%d. Одежда - %d ID\n", i + 1, kit_item[id][i][1]);
                case KIT_SLOT:format(List, sizeof List, "%d. Слот на транспорт - %d слотов\n", i + 1, kit_item[id][i][1]);
            }

            strcat(String, List);
        }
    }
    else {
        switch(kit_item[id][item_id][0])
        {
            case KIT_NONE:format(String, sizeof String, "Не выбран");
            case KIT_EXP:format(String, sizeof String, "Игровой опыт - %d опыта" ,  kit_item[id][item_id][1]);
            case KIT_MONEY:format(String, sizeof String, "Игровая валюта (Деньги) - %d р." ,  kit_item[id][item_id][1]);
            case KIT_DONATE:format(String, sizeof String, "Игровой донат - %d д.", kit_item[id][item_id][1]);
            case KIT_BVIP:format(String, sizeof String, "Bronze VIP на %d дней" ,  kit_item[id][item_id][1]);
            case KIT_SVIP:format(String, sizeof String, "Silver VIP на %d дней" ,  kit_item[id][item_id][1]);
            case KIT_GVIP:format(String, sizeof String, "Gold VIP на %d дней" ,  kit_item[id][item_id][1]);
            case KIT_CAR:format(String, sizeof String, "%s" ,  GetVehicleInfo(kit_item[id][item_id][1]-400, VI_NAME));
            case KIT_SKIN:format(String, sizeof String, "Одежда - %d ID" ,  kit_item[id][item_id][1]);
            case KIT_SLOT:format(String, sizeof String, "Слот на транспорт - %d слотов" ,  kit_item[id][item_id][1]);
        }
    }

    return String;
}



public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 5384)
    {
        new id = p_createkit[playerid][0];
        if(response)
        {
            new string[284];

            switch(p_createkit[playerid][1])
            {
                case 0:{ 
                    new name[24];

                    if(sscanf(inputtext, "s[24]", name)) {
                        ShowCDialogKit(playerid, 0);
                        return SendClientMessage(playerid, -1, ""kc"Вы ввели не правильные параметры");
                    }

                    format(kit[id][KIT_Name], 24, name); 
                    format(string, sizeof string, ""kc"Вы ввели название для набора: %s", name);
                }
                case 1:{ 
                    kit[id][KIT_TypePrice] = listitem;

                    format(string, sizeof string, ""kc"Вы выбрали покупка за %s", listitem ? ("донат валюту") : ("игровую валюту"));
                }
                case 2: {
                    new count;//Telegram: t.me/welsistudio

                    if(sscanf(inputtext, "d", count)) {
                        ShowCDialogKit(playerid, 0);
                        return SendClientMessage(playerid, -1, ""kc"Вы ввели не правильные параметры");
                    }

                    if(!(1 <= count <= 1_000_000_000))
                    {
                        ShowCDialogKit(playerid, 0);
                        return SendClientMessage(playerid, -1, ""kc"Стоимость должно быть от 1 до 1.000.000.000");
                    }

                    kit[id][KIT_Price] = count;
                    format(string, sizeof string, ""kc"Вы ввели стоимость набора: %d %s", count, kit[id][KIT_TypePrice] ? ("донат. в.") : ("игр. в."));
                }
                case 3..4:{

                        if(!listitem && !GetPVarInt(playerid, "itemid")) {

                        new bool:welsi_author;
                    
                        for(new i, s = sizeof kit_item[]; i < s; i++)
                        {
                            if(kit_item[id][i][0] != 0) { welsi_author = true; break;}
                        }

                        if(!welsi_author) {
                            SendClientMessage(playerid, -1, ""kc"Минимальное количество предметов в наборе - один");
                            ShowCDialogKit(playerid, 3);
                            return 1;
                        }

                        new item[32], items_kit[sizeof item * sizeof kit_item[]];

                        for(new i, s= sizeof kit_item[]; i < s; i ++)
                        {
                            format(item, 8, "%d,%d%s", kit_item[id][i][0], kit_item[id][i][1], i+1 == s ? ("") : (", "));
                            strcat(items_kit, item);
                        }

                        mysql_format(mysql, string, sizeof string, "INSERT INTO kit (name, typeprice, price, items) \
                        VALUES ('%s', %d, %d, '%s')", kit[id][KIT_Name], kit[id][KIT_TypePrice], kit[id][KIT_Price], items_kit);
                        new Cache:cache = mysql_query(mysql, string, true);

                        if(mysql_errno()) {
                            printf("[W_SYSTEM] [ERROR-SQL] QUERY : %s ", string);
                            return SendClientMessage(playerid, -1, ""kc"Ошибка в базе данных");
                        }

                        kit[id][KIT_SQL] =  cache_insert_id();

                        cache_delete();
                        SendClientMessage(playerid, -1, ""kc"Вы создали набор");
                        return 1;
                    }

                    if(GetPVarInt(playerid, "itemid"))
                    {
                        new itemid = GetPVarInt(playerid, "itemid") - 1, itemtype = GetPVarInt(playerid, "itemtype");

                        if(!itemtype) { SetPVarInt(playerid, "itemtype", listitem + 1); ShowCDialogKit(playerid, 4);}
                        else {
                            new count;

                            if(sscanf(inputtext, "d", count)) ShowCDialogKit(playerid, 3);
                            else {
                                switch(itemtype)
                                {
                                    case 1: if(!(1 <= count <= 100)) format(string, sizeof string, ""kc"Количество опыта должно быть от 1 до 100");
                                    case 2: if(!(1 <= count <= 1000000)) format(string, sizeof string, ""kc"Количество игр. валюты должно быть от 1 до 1.000.000");
                                    case 3: if(!(1 <= count <= 10000)) format(string, sizeof string, ""kc"Количество донат валюты должно быть от 1 до 10.000");
                                    case 4..6: if(!(1 <= count <= 365)) format(string, sizeof string, ""kc"Количество дней должно быть от 1 до 365");
                                    case 7: if(!(400 <= count <= sizeof g_vehicle_info + 399)) format(string, sizeof string, ""kc"ID транспорта должно быть от 400 до %d", sizeof g_vehicle_info + 399);
                                    case 8: if(!(1 <= count <= 311)) format(string, sizeof string, "vID одежды должно быть от 1 до 311");
                                    case 9: if(!(1 <= count <= 30)) format(string, sizeof string, ""kc"Количество слотов должно быть от 1 до 30");
                                }

                                if(string[0] != '\0') {

                                    SendClientMessage(playerid, -1, string);
                                    //DeletePVar(playerid, "itemid");
                                    DeletePVar(playerid, "itemtype");


                                    Dialog
                                    (
                                        playerid, 5384, DIALOG_STYLE_LIST, 
                                        "{E84934}Создание набора {FFFFFF}| Тип предметов",
                                        ""kc"Опыт\n"kc"Игровая валюта\n"kc"Донат валюта\n"kc"Bronze Vip\n\
                                        "kc"Silver Vip\n"kc"Gold Vip\n"kc"Транспорт\n"kc"Одежда\n"kc"Слот на транспорт",
                                        "Выбрать", "Назад"
                                    );
                                }
                                else {
                                    kit_item[id][itemid][0] = itemtype;
                                    kit_item[id][itemid][1] = count;
                                    printf("[%d] %d", id, kit_item[id][itemid][1]);
                                    
                                    format(string, sizeof string, "Вы выдали набору предмет: %s", StringItemKit(id, itemid));
                                    SendClientMessage(playerid, -1, string);

                                    ShowCDialogKit(playerid, 3);
                                }
                            }
                        }
                        return 1;//Telegram: t.me/welsistudio
                    }

                    new item_id = listitem;

                    for(new i, s = sizeof kit_item[]; i < s; i++)
                    {
                        if(kit_item[id][i][0] == 0) { item_id = i; break; }
                    }

                    SetPVarInt(playerid, "itemid", item_id + 1);

                    Dialog
                    (
                        playerid, 5384, DIALOG_STYLE_LIST, 
                        "{E84934}Создание набора {FFFFFF}| Тип предметов",
                        ""kc"Опыт\n"kc"Игровая валюта\n"kc"Донат валюта\n"kc"Bronze Vip\n\
                        "kc"Silver Vip\n"kc"Gold Vip\n"kc"Транспорт\n"kc"Одежда\n"kc"Слот на транспорт",
                        "Выбрать", "Назад"
                    );

                }
            }

            if(p_createkit[playerid][ 1 ] < 3)
            {
                SendClientMessage(playerid, -1, string);
                p_createkit[playerid][1] ++; 
                ShowCDialogKit(playerid, p_createkit[playerid][1]);
            }
        }
        else {
            switch(p_createkit[playerid][1])
            {
                case 0:ClearKit(p_createkit[playerid][0]);
                case 1..4:ShowCDialogKit(playerid, p_createkit[playerid][1]-1);
            }
        }

    }

    if(dialogid == 5385)
    {
        if(response)
        {
            new id = p_createkit[playerid][0], string[284];

            switch(p_createkit[playerid][1]) {
                case -1:
                {
                    p_createkit[playerid][0] = GetPlayerListitemValue(playerid, listitem);

                    ShowEDialogKit(playerid, 0);
                }
                case 0:{
                    if(5 <= listitem + 1 <= 6) listitem++;
                    
                    ShowEDialogKit(playerid, listitem + 1);
                }
                case 1:
                {
                    new name[24];

                    if(sscanf(inputtext, "s[24]", name)) {
                        ShowEDialogKit(playerid, 1);
                        return SendClientMessage(playerid, -1, ""kc"Вы ввели не правильные параметры");
                    }

                    format(kit[id][KIT_Name], 24, name); 
                    format(string, sizeof string, ""kc"Вы ввели название для набора: %s", name); 
            
                    UpdateKit(id);
                    ShowEDialogKit(playerid, 0);
                }
                case 2://Telegram: t.me/welsistudio
                {
                    kit[id][KIT_TypePrice] = listitem;

                    format(string, sizeof string, ""kc"Вы выбрали покупка за %s", listitem ? ("донат валюту") : ("игровую валюту"));
                    UpdateKit(id);
                    ShowEDialogKit(playerid, 0);
                }
                case 3:
                {
                    new count;

                    if(sscanf(inputtext, "d", count)) {
                        ShowEDialogKit(playerid, 0);
                        return SendClientMessage(playerid, -1, ""kc"Вы ввели не правильные параметры");
                    }
                    
                    if(!(1 <= count <= 1_000_000_000))
                    {
                        ShowCDialogKit(playerid, 0);
                        return SendClientMessage(playerid, -1, ""kc"Стоимость должно быть от 1 до 1.000.000.000");
                    }


                    kit[id][KIT_Price] = count;
                    format(string, sizeof string, ""kc"Вы ввели стоимость набора: %d %s", count, kit[id][KIT_TypePrice] ? ("донат. в.") : ("игр. в."));
                    UpdateKit(id);
                    ShowEDialogKit(playerid, 0);
                }
                case 4..5:
                {

                    if(GetPVarInt(playerid, "itemid"))
                    {
                        new itemid = GetPVarInt(playerid, "itemid") - 1, itemtype = GetPVarInt(playerid, "itemtype");

                        if(!itemtype && listitem != 9) { SetPVarInt(playerid, "itemtype", listitem + 1); ShowEDialogKit(playerid, 5);}
                        else {
                            new count;

                            if(sscanf(inputtext, "d", count)) ShowEDialogKit(playerid, 4);
                            else {
                                switch(itemtype)
                                {
                                    case 1: if(!(1 <= count <= 100)) format(string, sizeof string, ""kc"Количество опыта должно быть от 1 до 100");
                                    case 2: if(!(1 <= count <= 1000000)) format(string, sizeof string, ""kc"Количество игр. валюты должно быть от 1 до 1.000.000");
                                    case 3: if(!(1 <= count <= 10000)) format(string, sizeof string, ""kc"Количество донат валюты должно быть от 1 до 10.000");
                                    case 4..6: if(!(1 <= count <= 365)) format(string, sizeof string, ""kc"Количество дней должно быть от 1 до 365");
                                    case 7: if(!(400 <= count <= sizeof g_vehicle_info + 399)) format(string, sizeof string, ""kc"ID транспорта должно быть от 400 до %d", sizeof g_vehicle_info + 399);
                                    case 8: if(!(1 <= count <= 311)) format(string, sizeof string, ""kc"ID одежды должно быть от 1 до 311");
                                    case 9: if(!(1 <= count <= 30)) format(string, sizeof string, ""kc"Количество слотов должно быть от 1 до 30");
                                }

                                if(string[0] != '\0') {
                                    SendClientMessage(playerid, -1, string);
                                    DeletePVar(playerid, "itemtype");
                                    Dialog
                                    (
                                        playerid, 5385, DIALOG_STYLE_LIST, 
                                        "{E84934}Создание набора {FFFFFF}| Тип предметов",
                                        ""kc"Опыт\n"kc"Игровая валюта\n"kc"Донат валюта\n"kc"Bronze Vip\n\
                                        "kc"Silver Vip\n"kc"Gold Vip\n"kc"Транспорт\n"kc"Одежда\n"kc"Слот на транспорт\n"kc"Удалить",
                                        "Выбрать", "Назад"
                                    );
                                }//Telegram: t.me/welsistudio
                                else {
                                    if(itemtype == 10) {
                                        new bool:welsi_author;
                                    
                                        for(new i, s = sizeof kit_item[]; i < s; i++)
                                        {
                                            if(kit_item[id][i][0] != 0) { welsi_author = true; break;}
                                        }

                                        if(!welsi_author) {
                                            SendClientMessage(playerid, -1, ""kc"Минимальное количество предметов в наборе - один");
                                            ShowEDialogKit(playerid, 4);
                                            return 1;
                                        }

                                        kit_item[id][itemid][0] = 0;
                                        kit_item[id][itemid][1] = 0;
                                        
                                        format(string, sizeof string, "Вы удалили набору предмет");
                                    }
                                    else {
                                        kit_item[id][itemid][0] = itemtype;
                                        kit_item[id][itemid][1] = count;
                                        
                                        format(string, sizeof string, "Вы выдали набору предмет: %s", StringItemKit(id, itemid));
                                    }
                                    SendClientMessage(playerid, -1, string);
                                    UpdateKit(id);
                                    ShowEDialogKit(playerid, 4);
                                }
                            }
                        }
                        return 1;
                    }

                    new item_id = listitem;

                    if(kit_item[id][listitem][0] == 0)
                    {
                        for(new i, s = sizeof kit_item[]; i < s; i++)
                        {
                            if(kit_item[id][i][0] == 0) { item_id = i; break; }
                        }
                    }

                    SetPVarInt(playerid, "itemid", item_id + 1);

                    Dialog
                    (
                        playerid, 5385, DIALOG_STYLE_LIST, 
                        "{E84934}Редактирование набора {FFFFFF}| Тип предметов",
                        ""kc"Опыт\n"kc"Игровая валюта\n"kc"Донат валюта\n"kc"Bronze Vip\n\
                        "kc"Silver Vip\n"kc"Gold Vip\n"kc"Транспорт\n"kc"Одежда\n"kc"Слот на транспорт\n"kc"Удалить",
                        "Выбрать", "Назад"
                    );
                }

                case 7:
                {//Telegram: t.me/welsistudio
                    new count;

                    if(sscanf(inputtext, "d", count) || !(1 <= count <= 99)) {
                        ShowEDialogKit(playerid, 0);
                        return SendClientMessage(playerid, -1, ""kc"Вы ввели не правильные параметры");
                    }

                    kit[id][KIT_Discount] = count;
                    format(string, sizeof string, ""kc"Вы ввели скидку набора: %d%", count);

                    UpdateKit(id);
                    ShowEDialogKit(playerid, 0);
                }
            }

            if(string[0] != '\0') SendClientMessage(playerid, -1, string);

        }
    }
    if(dialogid == 5386)
    {
        if(response)
        {
            new id = p_createkit[playerid][0];
            
            if(id != -1) {
                if(kit[id][KIT_TypePrice] && GetPlayerDonateRub(playerid) < kit[id][KIT_Price] ||
                !kit[id][KIT_TypePrice] && GetPlayerMoneyEx(playerid) < kit[id][KIT_Price]
                )
                return SendClientMessage(playerid, -1, ""kc"У вас не хватает валюты для покупки набора");     
            
                new count = kit[id][KIT_Price];

                if(kit[id][KIT_Discount]) count = count - (count * kit[id][KIT_Discount] / 100);//Telegram: t.me/welsistudio

                if(kit[id][KIT_TypePrice]) GivePlayerDonateRub(playerid, -count);
                else GivePlayerMoneyEx(playerid, -count);
                new string[84];

                format(string, sizeof string, ""kc"Вы успешно приобрели набор {F7654B}\"%s\"", kit[id][KIT_Name]);
                SendClientMessage(playerid, -1, string);

                for(new i, s = sizeof kit_item[], List[94]; i < s; i++)
                {
                    printf("[%d][%d] %d", id, i, kit_item[id][i][1]);
                    switch(kit_item[id][i][0])
                    {
                        case KIT_NONE:continue;
                        case KIT_EXP:WELLSI_AUTHOOOR(playerid, kit_item[id][i][1]); //sorry
                        case KIT_MONEY:GivePlayerMoneyEx(playerid, kit_item[id][i][1]);
                        case KIT_DONATE:GivePlayerDonateRub(playerid, kit_item[id][i][1]);
                        case KIT_BVIP:SetVIP(playerid, 1, kit_item[id][i][1]);
                        case KIT_SVIP:SetVIP(playerid, 2, kit_item[id][i][1]);
                        case KIT_GVIP:SetVIP(playerid, 3, kit_item[id][i][1]);
                        case KIT_CAR:GiveCarKit(playerid, kit_item[id][i][1]);
                        case KIT_SKIN:{
                            SetPlayerData(playerid, P_SKIN, kit_item[id][i][1]);
                            UpdatePlayerDatabaseInt(playerid, "skin", kit_item[id][i][1]);

                            SetPlayerSkinInit(playerid);
                        }
                        case KIT_SLOT:
                        {
                            AddPlayerData(playerid, P_CAR_SLOTS, +, kit_item[id][i][1]);
						    UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                        }
                    }

                }

                return 1;
            }

            new items[412], price[68]; //ne menyai avtorstvo :)
            id = p_createkit[playerid][0] = GetPlayerListitemValue(playerid, listitem);

            if(kit[id][KIT_Discount]) {
                new count = kit[id][KIT_Price];

                count = count - (count * kit[id][KIT_Discount] / 100);

                if(kit[id][KIT_TypePrice]) format(price, 68, "{E0E869}%d{FFFFFF} донат. руб. (Скидка %d%)", count,  kit[id][KIT_Discount]);
                else {
                    format(price, 68, "{6DE869}%d{FFFFFF} руб. (Скидка %d%)", count,  kit[id][KIT_Discount]);
                }
            }
            else
            {
                if(kit[id][KIT_TypePrice]) format(price, 48, "{E0E869}%d{FFFFFF} донат. руб.", kit[id][KIT_Price]);
                else {
                    format(price, 48, "{6DE869}%d{FFFFFF} руб.", kit[id][KIT_Price]);
                }
            }

            new List[94];
            for(new i, s = sizeof kit_item[]; i < s; i++)
            {
                switch(kit_item[id][i][0])
                {
                    case KIT_NONE:continue;
                    case KIT_EXP:format(List, sizeof List, "Игровой опыт - %d опыта\n", kit_item[id][i][1]);
                    case KIT_MONEY:format(List, sizeof List, "Игровая валюта (Деньги) - %d р.\n", kit_item[id][i][1]);
                    case KIT_DONATE:format(List, sizeof List, "Игровой донат - %d д.\n", kit_item[id][i][1]);
                    case KIT_BVIP:format(List, sizeof List, "Bronze VIP на %d дней\n", kit_item[id][i][1]);
                    case KIT_SVIP:format(List, sizeof List, "Silver VIP на %d дней\n", kit_item[id][i][1]);
                    case KIT_GVIP:format(List, sizeof List, "Gold VIP на %d дней\n", kit_item[id][i][1]);
                    case KIT_CAR:format(List, sizeof List, "%s\n", GetVehicleInfo(kit_item[id][i][1]-400, VI_NAME));
                    case KIT_SKIN:format(List, sizeof List, "Одежда - %d ID\n", kit_item[id][i][1]);
                    case KIT_SLOT:format(List, sizeof List, "Слот на транспорт - %d слотов\n", kit_item[id][i][1]);
                }

                strcat(items, List);
            }

            new dialog[1024];

            format
            (
                dialog, sizeof dialog, 
                ""kc"Название набора: %s{FFFFFF}\n\n"kc"Содержимое набора:\n %s\n\nСтоимость: %s\n\nВы действительно хотите приобрести набор?", kit[id][KIT_Name], items, price
            );

            Dialog
            (
                playerid, 5386, DIALOG_STYLE_MSGBOX, 
                "{E84934}Описание набора",
                dialog, "Купить", "Выйти"
            );
        }
    }

    if(dialogid == 5387)
    {
        if(response)//Telegram: t.me/welsistudio
        {
            new string[128];
            if(p_createkit[playerid][1])
            {
                new kit_id = p_createkit[playerid][ 0 ];

                mysql_format(mysql, string, sizeof string, "DELETE FROM kit WHERE id = %d", kit[kit_id][KIT_SQL]);
                mysql_query(mysql, string, false);

                if(!mysql_errno())
                {
                    ClearKit(kit_id);
                    SendClientMessage(playerid, -1, ""kc"Вы удалили набор.");
                }
                else SendClientMessage(playerid, -1, ""kc"Ошибка в базе данных (удаление набора)");

                return 1;
            }

            new id = GetPlayerListitemValue(playerid, listitem);
            p_createkit[playerid][0] = id;
            p_createkit[playerid][1] = 1;

            format(string, sizeof string, "Вы действительно хотите удалить набор %s?", kit[id][KIT_Name]);
            Dialog
            (
                playerid, 5387, DIALOG_STYLE_MSGBOX, 
                "{E84934}Подтверждение удаления",
                string, "Удалить", "Выйти"
            );

        }
    }
    #if defined kit_OnDialogResponse
    return kit_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}//Telegram: t.me/welsistudio
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse kit_OnDialogResponse
#if defined kit_OnDialogResponse
forward kit_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif
//Telegram: t.me/welsistudio
cmd:editkit(playerid)
{
    new s, dialog[MAX_KIT * 64];

    for(new i,string[84]; i < MAX_KIT; i++)
    {
        if(kit_item[i][0][0] == 0) continue;

        format(string, sizeof string, "{FFFFFF}%d. %s\n", i+1, kit[i][KIT_Name]);
        strcat(dialog, string);
        SetPlayerListitemValue(playerid, s, i);
        s++;
    }
    if(!s) return SendClientMessage(playerid, -1, ""kc"Наборы не найдены.");

    p_createkit[playerid][0] = -1;
    p_createkit[playerid][1] = -1;

    Dialog
    (
        playerid, 5385, DIALOG_STYLE_LIST, 
        "{E84934}Редактирование набора",
        dialog, "Выбрать", "Выйти"
    );

    return 1;
}
//Telegram: t.me/welsistudio
stock ShowEDialogKit(playerid, type)
{
    new string[284];


    p_createkit[playerid][ 1 ] = type;

    printf("%d", type);
    switch(type)
    {
        case 0:{
            format(string, sizeof string,
            "1. Изменить название\n"\
            "2. Изменить тип стоимости\n"\
            "3. Изменить стоимость\n"\
            "4. Изменить предмет\n"\
            "5. %s {EB2E2E}[АКЦИЯ]\n"\
            "{FFFFFF}6. Установить скидку", kit[p_createkit[playerid][0]][KIT_Promotion] ? ("Убрать") : ("Добавить")
            );

            Dialog
            ( 
                playerid, 5385, DIALOG_STYLE_LIST, "{E84934}Редактирование набора", 
                string, "Выбрать", "Выйти"
            );
        }
        case 1:
        {
            Dialog
            (
                playerid, 5385, DIALOG_STYLE_INPUT,
                "{E84934}Редактирование набора {FFFFFF}| Название набора",
                "Введите название для набора\n"\
                ""kc"Например: Набор Администратора",
                "Назвать", "Выйти"
            );
        }
        case 2:
        {
            Dialog
            (
                playerid, 5385, DIALOG_STYLE_LIST,
                "{E84934}Редактирование набора {FFFFFF}| Выберите валюту",
                "Покупка набора за {E84934}игровую {FFFFFF}валюту\n"\
                "Покупка набора за {E84934}донат {FFFFFF}валюту",
                "Выбрать", "Назад"
            );
        }
        case 3:
        {
            Dialog
            (
                playerid, 5385, DIALOG_STYLE_INPUT,
                "{E84934}Редактирование набора {FFFFFF}| Стоимость",
                "Введите стоимость набора\n"\
                ""kc"Например: 1000000",
                "Выбрать", "Назад"
            );
        }
        case 4:
        {
            new list[84], String[sizeof list * sizeof kit_item[]], id = p_createkit[playerid][0];

            for(new i, s = sizeof kit_item[]; i < s; i++)
            {
                switch(kit_item[id][i][0])
                {
                    case KIT_NONE:format(list, sizeof list, "%d. Не выбран\n", i + 1);
                    case KIT_EXP:format(list, sizeof list, "%d. Игровой опыт - %d опыта\n", i + 1, kit_item[id][i][1]);
                    case KIT_MONEY:format(list, sizeof list, "%d. Игровая валюта (Деньги) - %d р.\n", i + 1, kit_item[id][i][1]);
                    case KIT_DONATE:format(list, sizeof list, "%d. Игровой донат - %d д.\n", i + 1, kit_item[id][i][1]);
                    case KIT_BVIP:format(list, sizeof list, "%d. Bronze VIP на %d дней\n", i + 1, kit_item[id][i][1]);
                    case KIT_SVIP:format(list, sizeof list, "%d. Silver VIP на %d дней\n", i + 1, kit_item[id][i][1]);
                    case KIT_GVIP:format(list, sizeof list, "%d. Gold VIP на %d дней\n", i + 1, kit_item[id][i][1]);
                    case KIT_CAR:format(list, sizeof list, "%d. %s\n", i + 1, GetVehicleInfo(kit_item[id][i][1]-400, VI_NAME));
                    case KIT_SKIN:format(list, sizeof list, "%d. Одежда - %d ID\n", i + 1, kit_item[id][i][1]);
                    case KIT_SLOT:format(list, sizeof list, "%d. Слот на транспорт - %d слотов\n", i + 1, kit_item[id][i][1]);
                }

                strcat(String, list);
            }

            DeletePVar(playerid, "itemid");
            DeletePVar(playerid, "itemtype");
            Dialog
            (
                playerid, 5385, DIALOG_STYLE_LIST,
                "{E84934}Редактирование набора {FFFFFF}| Предметы",
                String,
                "Выбрать", "Назад"
            );
        }
        case 5:{

            switch(GetPVarInt(playerid, "itemtype"))
            {
                case KIT_EXP:format(string, sizeof string, "Введите количество опыта\n"kc"Примечание: количество от 1 до 100");
                case KIT_MONEY:format(string, sizeof string, "Введите количество игровой валюты\n"kc"Примечание: количество от 1 до 1.000.000");
                case KIT_DONATE:format(string, sizeof string, "Введите количество донат валюты\n"kc"Примечание: количество от 1 до 10.000");
                case KIT_BVIP..KIT_GVIP:format(string, sizeof string, "Введите количество дней\n"kc"Примечание: количество от 1 до 365");
                case KIT_CAR:format(string, sizeof string, "Введите ID транспорта\n"kc"Примечание: ID от 400 до %d", sizeof g_vehicle_info + 399);
                case KIT_SKIN:format(string, sizeof string, "Введите ID одежды (скина)\n"kc"Примечание: ID от 1 до 311");
                case KIT_SLOT:format(string, sizeof string, "Введите количество слотов\n"kc"Примечание: количество от 1 до 30");
            }
            
            Dialog(playerid, 5385, DIALOG_STYLE_INPUT, "{E84934}Редактирование набора {FFFFFF}| Настройка предмета", string, "Сохранить", "Назад");
        }//Telegram: t.me/welsistudio
        case 6:
        {   
            new id = p_createkit[playerid][0];

            kit[id][KIT_Promotion] = kit[id][KIT_Promotion] ? false : true;

            format(string, sizeof string, ""kc"Вы %s Акцию", kit[id][KIT_Promotion] ? ("добавили") : ("убрали"));
            SendClientMessage(playerid, -1, string);
            
            UpdateKit(id);
            ShowEDialogKit(playerid, 0); 
        }
        case 7:{
            Dialog
            (
                playerid, 5385, DIALOG_STYLE_INPUT, 
                "{E84934}Редактирование набора {FFFFFF}| Скидка",
                "Введите скидку (в процентах)\n"kc"Примечание: процент от 1 до 99",
                "Выдать", "Назад"
            );
        }//Telegram: t.me/welsistudio
    }
}

cmd:kit(playerid)//Telegram: t.me/welsistudio
{
    new s, string[144], dialog[MAX_KIT * sizeof string], promotion[78], price[48];

    for(new i, count; i < MAX_KIT; i ++)
    {
        if(kit_item[i][0][0] == 0) continue;

        count = kit[i][KIT_Price];
    
        promotion[0] = '\0';

        if(kit[i][KIT_Promotion])
        {
            format(promotion, 24, " {EB2E2E}[АКЦИЯ] ");
        }
        else { promotion[0] = ' '; promotion[1] = '\0'; }

        if(kit[i][KIT_Discount]) {
            count = count - (count * kit[i][KIT_Discount] / 100);

            format(string, sizeof string, " {FFFF00}[Скидка %d%]{FFFFFF} ", kit[i][KIT_Discount]);
            strcat(promotion, string);
        }
    

        if(kit[i][KIT_TypePrice]) format(price, 48, "{E0E869}%d{FFFFFF} донат. руб.", count);
        else {
            format(price, 48, "{6DE869}%d{FFFFFF} руб.", count);
        }

        //if(kit[i][KIT[]])

        format(string, sizeof string, "{FFFFFF}%s%s— %s\n", kit[i][KIT_Name], promotion, price);
        strcat(dialog, string);
        SetPlayerListitemValue(playerid, s, i);
        s ++;
    }
    
    if(!s) return SendClientMessage(playerid, -1, ""kc"Наборы не найдены.");

    p_createkit[playerid][0] = -1;
    
    Dialog
    (
        playerid, 5386, DIALOG_STYLE_LIST, 
        "{E84934}Наборы",
        dialog, "Выбрать", "Выйти"
    );

    return 1;
}
//Telegram: t.me/welsistudio
stock SetVIP(playerid, vip, day)
{
    new prem_day,prem_month,prem_year,premium = GetPlayerPremium(playerid);

    if(!premium)
    {
        SetPlayerData(playerid, P_PREMIUM, vip);
        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + day * 86400);
    }
    else
    {
        AddPlayerData(playerid, P_PREMIUM_DATE, +, day * 86400);
    }

    timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year, prem_month, prem_day);

    UpdatePlayerDatabaseInt(playerid, "premium", vip);
    UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));

    return 1;

}

stock GiveCarKit(playerid, modelid)
{
		new to_player = playerid;
		new Float:POS[3];
		GetPlayerPos(to_player, POS[0],POS[1],POS[2]);
		new Float: pos_x = POS[0];
		new Float: pos_y = POS[1];
		new Float: pos_z = POS[2];
		new Float: angle = 356.7986;
		new query[220],
			Cache: result,
			idx;

		format
		(
			query, sizeof query,
			"INSERT INTO ownable_cars \
			(owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) \
			VALUES \
			('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
			GetPlayerAccountID(to_player),
			modelid,
			0,
			0,
			pos_x,
			pos_y,
			pos_z,
			angle,
			gettime()
		);
		result = mysql_query(mysql, query, true);
		cache_delete(result);
}
//Telegram: t.me/welsistudio
stock UpdateKit(id)
{
    new string[324], item[32], items_kit[sizeof item * sizeof kit_item[]];

    for(new i, s= sizeof kit_item[]; i < s; i ++)
    {
        format(item, 8, "%d,%d%s", kit_item[id][i][0], kit_item[id][i][1], i+1 == s ? ("") : (", "));
        strcat(items_kit, item);
    }

    mysql_format(mysql, string, sizeof string, "UPDATE kit SET name = '%s', typeprice=%d, price = %d, promotion = %d, discount = %d, items = '%s' \
    WHERE id = %d", kit[id][KIT_Name], kit[id][KIT_TypePrice], kit[id][KIT_Price], kit[id][KIT_Promotion], kit[id][KIT_Discount], items_kit, kit[id][KIT_SQL]);
    mysql_query(mysql, string, false);//Telegram: t.me/welsistudio

    if(mysql_errno()) printf("ERROR UPDATE KIT (%s)", string);
}

//Telegram: t.me/welsistudio