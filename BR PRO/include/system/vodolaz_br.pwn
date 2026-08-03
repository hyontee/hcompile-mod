//Автор данной системы VVEEZ STUDIO, Владимир)
#define VODOLAZ_OFFER 10
#define VODOLAZKA_OFFER 7
new kapitanp1;
new kapitanp2;
new kapitanp3;
new kapitanp4;
new yg_areas[6]; // для test 2 yg
new bat_areas1[7]; // для test 1 bat
new bat_areas2[6]; // для test 2 bat
new lit_areas1[6]; // для test 1 lit
new lit_areas2[6]; // для test 2 lit
new yzka_areas[7]; // для yzka
new PlayerBoatID[MAX_PLAYERS];
new gBoatPrices[] = {
    7000,   // Цена для "Гидроцикл" (ID в массиве: 0)
    15000,  // Цена для "Моторная лодка" (ID: 1)
    17000,  // Цена для "Speedy Yacht" (ID: 2)
    20000,  // Цена для "Marine Yacht" (ID: 3)
    45000,  // Цена для "Sea Yacht" (ID: 4)
    100000  // Цена для "Ocean Yacht" (ID: 5)
};
enum E_PLAYER_VODO_ITEMS {
    yg_collected[6],      // test 2 yg (6 предметов)
    bat1_collected[7],    // test 1 bat (7 предметов)
    bat2_collected[6],    // test 2 bat (6 предметов)
    lit1_collected[6],    // test 1 lit (6 предметов)
    lit2_collected[6],    // test 2 lit (6 предметов)
    yzka_collected[7]     // yzka (7 предметов)
}
new PlayerVodoItems[MAX_PLAYERS][E_PLAYER_VODO_ITEMS];
new VodolazItemNames[][64] = {
    "Стиральная машина",
    "Колесо внедорожника", 
    "Старинная ваза",
    "Якорь корабля",
    "Мотор лодочный",
    "Золотая цепь"
};

// Массив цен предметов (от 20000 до 25000)
new VodolazItemPrices[] = {
    21000,  // Стиральная машина
    22000,  // Колесо внедорожника
    24000,  // Старинная ваза
    23000,  // Якорь корабля
    20000,  // Мотор лодочный
    25000   // Золотая цепь
};
// 3. Массив для названий лодок (опционально)
new gBoatNames[][32] = {
    "Гидроцикл",
    "Моторная лодка",
    "Speedy Yacht",
    "Marine Yacht",
    "Sea Yacht",
    "Ocean Yacht"
};
new gBoatCarID[] = {
    473,  // Dinghy (Гидроцикл)
    472,  // Coastguard (Моторная лодка)
    493,  // Jetmax (Speedy Yacht)
    452,  // Speeder (Marine Yacht)
    453,  // Reefer (Sea Yacht)
    454  // Tropic (Ocean Yacht)
};
new Float:vodovedisyda[6][3] = {
    {-2469.009277, 579.343261, -0.550000},
    {-1897.012817, -513.759460, -0.550000},
    {1459.005371, -1838.905883, -0.550000},
    {2739.108886, 224.467178, -0.550000},
    {1514.171020, 129.642410, -0.550000},
    {2861.607910, -1165.949462, -0.550000}
};
enum E_POSITIONVODO {
    Float:posX,
    Float:posY,
    Float:posZ,
    Float:posAngle
};
new lodkaPositions[][E_POSITIONVODO] = {
    {2484.252197, -1235.883178, -0.800403, 36.087886},    // yzka lodka1
    {2499.357177, -1228.727783, -0.544732, 6.103890},     // yzka lodka1
    {2514.747070, -1229.557250, -0.544732, 351.048431},   // yzka lodka1
    {2528.980712, -1235.333496, -0.544748, 321.481231},   // yzka lodka1
    {2537.453857, -1243.588989, -0.801097, 323.264831}    // yzka lodka1
};

new lodkaPositionsA[][E_POSITIONVODO] = {
    {681.311767,155.555221,-0.168156,184.687622},    // yzka lodka1
    {670.662048,157.195251,-0.032777,174.723907,},     // yzka lodka1
    {660.937194,157.427490,-0.032965,188.136123},   // yzka lodka1
    {650.579589,157.222229,-0.206876,187.75630},   // yzka lodka1
    {640.811462,155.052581,-0.032689,181.975753}    // yzka lodka1
};
new lodkaPositionsB[][E_POSITIONVODO] = {
    {2367.010253,289.144042,1.262846,186.726348},    // yzka lodka1
    {2352.787353,284.411468,-0.167348,193.099563},     // yzka lodka1
    {2340.795410,284.272491,-0.169282,189.794570},   // yzka lodka1
    {2316.613525,287.917694,-0.032778,179.226531},   // yzka lodka1
    {2302.809570,288.758605,-0.170388,184.518768}    // yzka lodka1
};
new lodkaPositionsL[][E_POSITIONVODO] = {
    {-2519.548339,363.730804,-0.032780,268.533996},    // yzka lodka1
    {-2520.387451,377.281982,-0.165156,274.241729},     // yzka lodka1
    {-2521.538574,390.698913,-0.166875,260.146026},   // yzka lodka1
    {-2539.335937,363.776123,-0.034559,88.848045},   // yzka lodka1
    {-2541.254394,377.489624,-0.162565,89.772666}    // yzka lodka1
};


public OnPlayerConnect(playerid)
{
    for(new i = 0; i < 6; i++) PlayerVodoItems[playerid][yg_collected][i] = 0;
    for(new i = 0; i < 7; i++) PlayerVodoItems[playerid][bat1_collected][i] = 0;
    for(new i = 0; i < 6; i++) PlayerVodoItems[playerid][bat2_collected][i] = 0;
    for(new i = 0; i < 6; i++) PlayerVodoItems[playerid][lit1_collected][i] = 0;
    for(new i = 0; i < 6; i++) PlayerVodoItems[playerid][lit2_collected][i] = 0;
    for(new i = 0; i < 7; i++) PlayerVodoItems[playerid][yzka_collected][i] = 0;
    #if defined vodo_OnPlayerConnect
        return vodo_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect vodo_OnPlayerConnect
#if defined vodo_OnPlayerConnect
    forward vodo_OnPlayerConnect(playerid);
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
for(new i = 0; i < sizeof(yg_areas); i++)
    {
        if(areaid == yg_areas[i])
        {
            // Проверяем, был ли уже собран этот предмет
            if(PlayerVodoItems[playerid][yg_collected][i] == 0)
            {
                ShowClientNotification(playerid, 4, 6, VODOLAZ_OFFER, 0, "Взаимодействовать", ">>");
                return 1;
            }
            else
            {
                ShowClientNotification(playerid, 4, 6, VODOLAZ_OFFER, 0, "Предмет уже собран", " ");
                return 1;
            }
        }
    }
    
    // Проверка для test 1 bat
    for(new i = 0; i < sizeof(bat_areas1); i++)
    {
        if(areaid == bat_areas1[i])
        {
            // Проверяем, был ли уже собран этот предмет
            if(PlayerVodoItems[playerid][bat1_collected][i] == 0)
            {
                ShowClientNotification(playerid, 4, 6, VODOLAZ_OFFER, 0, "Взаимодействовать", ">>");
                return 1;
            }
            else
            {
                ShowClientNotification(playerid, 4, 6, VODOLAZ_OFFER, 0, "Предмет уже собран", " ");
                return 1;
            }
        }
    }
    
    // Проверка для test 2 bat
    for(new i = 0; i < sizeof(bat_areas2); i++)
    {
        if(areaid == bat_areas2[i])
        {
            // Проверяем, был ли уже собран этот предмет
            if(PlayerVodoItems[playerid][bat2_collected][i] == 0)
            {
                ShowClientNotification(playerid, 4, 6, VODOLAZ_OFFER, 0, "Взаимодействовать", ">>");
                return 1;
            }
            else
            {
                ShowClientNotification(playerid, 4, 6, VODOLAZ_OFFER, 0, "Предмет уже собран", " ");
                return 1;
            }
        }
    }
    
    // Проверка для test 1 lit
    for(new i = 0; i < sizeof(lit_areas1); i++)
    {
        if(areaid == lit_areas1[i])
        {
            // Проверяем, был ли уже собран этот предмет
            if(PlayerVodoItems[playerid][lit1_collected][i] == 0)
            {
                ShowClientNotification(playerid, 4, 6, VODOLAZ_OFFER, 0, "Взаимодействовать", ">>");
                return 1;
            }
            else
            {
                ShowClientNotification(playerid, 4, 6, VODOLAZ_OFFER, 0, "Предмет уже собран", " ");
                return 1;
            }
        }
    }
    
    // Проверка для test 2 lit
    for(new i = 0; i < sizeof(lit_areas2); i++)
    {
        if(areaid == lit_areas2[i])
        {
            // Проверяем, был ли уже собран этот предмет
            if(PlayerVodoItems[playerid][lit2_collected][i] == 0)
            {
                ShowClientNotification(playerid, 4, 6, VODOLAZ_OFFER, 0, "Взаимодействовать", ">>");
                return 1;
            }
            else
            {
                ShowClientNotification(playerid, 4, 6, VODOLAZ_OFFER, 0, "Предмет уже собран", " ");
                return 1;
            }
        }
    }
    
    // Проверка для yzka
    for(new i = 0; i < sizeof(yzka_areas); i++)
    {
        if(areaid == yzka_areas[i])
        {
            // Проверяем, был ли уже собран этот предмет
            if(PlayerVodoItems[playerid][yzka_collected][i] == 0)
            {
                ShowClientNotification(playerid, 4, 6, VODOLAZ_OFFER, 0, "Взаимодействовать", ">>");
                return 1;
            }
            else
            {
                ShowClientNotification(playerid, 4, 6, VODOLAZ_OFFER, 0, "Предмет уже собран", " ");
                return 1;
            }
        }
    }
    if(areaid == kapitanp1 || areaid == kapitanp2 || areaid == kapitanp3 || areaid == kapitanp4)
	{
	ShowClientNotification(playerid, 4, 6, VODOLAZKA_OFFER, 0, "Взаимодействовать", ">>");
	}
    #if defined vodo_OnPlayerEnterDynamicArea
        return vodo_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea vodo_OnPlayerEnterDynamicArea
#if defined vodo_OnPlayerEnterDynamicArea
    forward vodo_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif


public OnGameModeInit()
{
  kapitanp1 = CreateDynamicSphere(-2528.527832,357.601684,2.100287, 2.0);
    kapitanp2 = CreateDynamicSphere(652.959899,173.051406,2.081145, 2.0);
    kapitanp3 = CreateDynamicSphere(2273.179443,310.147216,4.03999, 2.0);
    kapitanp4 = CreateDynamicSphere(2501.043701,-1253.509033,1.436212, 2.0);
    yg_areas[0] = CreateDynamicSphere(1466.904296, -1824.186645, -17.164403, 3.0);
    yg_areas[1] = CreateDynamicSphere(1472.079833, -1834.940795, -19.254344, 3.0);
    yg_areas[2] = CreateDynamicSphere(1472.845581, -1845.868530, -18.554044, 3.0);
    yg_areas[3] = CreateDynamicSphere(1462.724609, -1837.813354, -19.553617, 3.0);
    yg_areas[4] = CreateDynamicSphere(1446.883789, -1842.590576, -16.100713, 3.0);
    yg_areas[5] = CreateDynamicSphere(1454.368652, -1851.529296, -15.718278, 3.0);
    
    // test 1 bat (7 областей)
    bat_areas1[0] = CreateDynamicSphere(2752.146972, 221.677474, -23.452600, 3.0);
    bat_areas1[1] = CreateDynamicSphere(2760.477783, 245.626312, -25.607845, 3.0);
    bat_areas1[2] = CreateDynamicSphere(2748.700439, 238.873016, -23.258836, 3.0);
    bat_areas1[3] = CreateDynamicSphere(2719.258544, 236.032180, -23.346479, 3.0);
    bat_areas1[4] = CreateDynamicSphere(2718.580810, 232.052291, -25.169128, 3.0);
    bat_areas1[5] = CreateDynamicSphere(2711.500244, 210.675140, -24.449611, 3.0);
    bat_areas1[6] = CreateDynamicSphere(2716.578369, 209.340133, -20.733572, 3.0);
    
    // test 2 bat (6 областей)
    bat_areas2[0] = CreateDynamicSphere(1520.854614, 139.562210, -39.823081, 3.0);
    bat_areas2[1] = CreateDynamicSphere(1509.491699, 141.896606, -40.452293, 3.0);
    bat_areas2[2] = CreateDynamicSphere(1516.119995, 142.102798, -40.669239, 3.0);
    bat_areas2[3] = CreateDynamicSphere(1518.225463, 133.190155, -40.942207, 3.0);
    bat_areas2[4] = CreateDynamicSphere(1512.053833, 135.413940, -40.162685, 3.0);
    bat_areas2[5] = CreateDynamicSphere(1506.213867, 119.769546, -36.237327, 3.0);
    
    // test 1 lit (6 областей)
    lit_areas1[0] = CreateDynamicSphere(-2468.029052, 586.753845, -46.060962, 3.0);
    lit_areas1[1] = CreateDynamicSphere(-2463.144531, 575.098999, -45.783679, 3.0);
    lit_areas1[2] = CreateDynamicSphere(-2469.093505, 572.723022, -46.698123, 3.0);
    lit_areas1[3] = CreateDynamicSphere(-2472.774414, 579.592773, -46.421581, 3.0);
    lit_areas1[4] = CreateDynamicSphere(-2490.635009, 571.858337, -43.316829, 3.0);
    lit_areas1[5] = CreateDynamicSphere(-2488.437011, 570.524291, -40.731388, 3.0);
    
    // test 2 lit (6 областей)
    lit_areas2[0] = CreateDynamicSphere(-1917.172607, -518.188293, -23.232200, 3.0);
    lit_areas2[1] = CreateDynamicSphere(-1910.247558, -527.531066, -22.862688, 3.0);
    lit_areas2[2] = CreateDynamicSphere(-1908.961303, -522.390319, -27.755836, 3.0);
    lit_areas2[3] = CreateDynamicSphere(-1899.620727, -515.446289, -28.269762, 3.0);
    lit_areas2[4] = CreateDynamicSphere(-1894.446044, -518.390930, -28.755828, 3.0);
    lit_areas2[5] = CreateDynamicSphere(-1901.051513, -507.493560, -28.172092, 3.0);
    
    // yzka (7 областей)
    yzka_areas[0] = CreateDynamicSphere(2894.851074, -1164.413574, -20.902873, 3.0);
    yzka_areas[1] = CreateDynamicSphere(2878.929931, -1150.683471, -17.238021, 3.0);
    yzka_areas[2] = CreateDynamicSphere(2873.409667, -1147.650268, -9.720733, 3.0);
    yzka_areas[3] = CreateDynamicSphere(2845.903076, -1154.326904, -9.028607, 3.0);
    yzka_areas[4] = CreateDynamicSphere(2839.530517, -1165.238403, -9.042394, 3.0);
    yzka_areas[5] = CreateDynamicSphere(2859.249511, -1172.719604, -5.868109, 3.0);
    yzka_areas[6] = CreateDynamicSphere(2870.954833, -1173.163452, -9.505463, 3.0);
    #if defined vodo_OnGameModeInit
        return vodo_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit vodo_OnGameModeInit
#if defined vodo_OnGameModeInit
    forward vodo_OnGameModeInit();
#endif
public OnPlayerUpdate(playerid)
{

#if defined vodo_OnPlayerUpdate
        return vodo_OnPlayerUpdate(playerid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate vodo_OnPlayerUpdate
#if defined vodo_OnPlayerUpdate
    forward vodo_OnPlayerUpdate(playerid);
#endif
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
if(dialogid == 58909) // Диалог продажи предметов
{
    if(response)
    {
        new items_count = GetPVarInt(playerid, "Vodolaz_ItemsCount");
        
        if(items_count <= 0 || listitem < 0 || listitem >= items_count)
        {
            Send(playerid, -1, "Ошибка: выбран неверный предмет!");
            DeletePVar(playerid, "Vodolaz_ItemsCount");
            return 1;
        }
        
        // Получаем данные о предмете с использованием циклического индекса
        new item_name[64], item_price;
        new item_index = listitem % sizeof(VodolazItemNames);
        new price_index = listitem % sizeof(VodolazItemPrices);
        
        format(item_name, sizeof(item_name), "%s", VodolazItemNames[item_index]);
        item_price = VodolazItemPrices[price_index];
        
        // Выдаем деньги игроку
        GivePlayerMoneyEx(playerid, item_price, "Продажа предмета водолаза", true, true);
        
        // Уменьшаем количество предметов
        AddPlayerData(playerid, P_VODORPEDM, -, 1);
        UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
        
        // Отправляем сообщение игроку
        new msg[128];
        format(msg, sizeof(msg), "Вы продали {FF9900}%s {FFFFFF}за {00FF00}%dрублей{FFFFFF}!", 
            item_name, item_price);
        Send(playerid, -1, msg);
        
        format(msg, sizeof(msg), "Осталось предметов: {FF9900}%d", 
            GetPlayerData(playerid, P_VODORPEDM));
        Send(playerid, -1, msg);
        
        // Удаляем временную переменную
        DeletePVar(playerid, "Vodolaz_ItemsCount");
    }
    return 1;
}
// В обработчике OnDialogResponse добавьте:
if(dialogid == 58911) // Диалог продажи предметов
{
    if(response)
    {
        new items_count = GetPVarInt(playerid, "vodo_items_count");
        
        if(items_count <= 0)
        {
            Send(playerid, -1, "Ошибка: предметы не найдены!");
            DeletePVar(playerid, "vodo_items_count");
            return 1;
        }
        
        // Рассчитываем количество уникальных предметов в списке
        new max_items_in_list = min(items_count, 6);
        
        // Если выбрана опция "Продать все предметы" (последняя в списке)
        if(listitem == max_items_in_list)
        {
            // Продажа всех предметов
            new total_price = 0;
            
            // Генерируем случайные цены для каждого предмета
            for(new i = 0; i < items_count; i++)
            {
                total_price += (20000 + random(5001)); // от 20000 до 25000 за предмет
            }
            
            // Выдаем деньги игроку
            GivePlayerMoneyEx(playerid, total_price, "Продажа всех предметов водолаза", true, true);
            
            // Обнуляем количество предметов
            AddPlayerData(playerid, P_VODORPEDM, =, 0);
            UpdatePlayerDatabaseInt(playerid, "vodopr", 0);
            
            // Сообщение игроку
            new msg[128];
            format(msg, sizeof(msg), "Вы продали все предметы ({FF9900}%d{FFFFFF} шт.) за {00FF00}%dрублей{FFFFFF}!", 
                items_count, total_price);
            Send(playerid, -1, msg);
        }
        else
        {
            // Продажа одного выбранного предмета
            if(items_count <= 0)
            {
                Send(playerid, -1, "У вас больше нет предметов для продажи!");
                DeletePVar(playerid, "vodo_items_count");
                return 1;
            }
            
            // Генерируем случайную цену для предмета
            new price = 20000 + random(5001); // от 20000 до 25000
            
            // Выдаем деньги игроку
            GivePlayerMoneyEx(playerid, price, "Продажа предмета водолаза", true, true);
            
            // Уменьшаем количество предметов на 1
            AddPlayerData(playerid, P_VODORPEDM, -, 1);
            UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
            
            // Сообщение игроку
            new msg[128];
            format(msg, sizeof(msg), "Вы продали один предмет за {00FF00}%dрублей{FFFFFF}! Осталось предметов: {FF9900}%d", 
                price, GetPlayerData(playerid, P_VODORPEDM));
            Send(playerid, -1, msg);
        }
        
        // Удаляем временную переменную
        DeletePVar(playerid, "vodo_items_count");
    }
    return 1;
}
if(dialogid == 58904)
{
    if(response)
    {
        new text[686];

        switch(listitem)
        {
            case 0:
            {
                if(PlayerBoatID[playerid] == INVALID_VEHICLE_ID) 
                    return Send(playerid, -1, "Арендуйте лодку!");
                
                // ПРАВИЛЬНАЯ ПРОВЕРКА: получаем значение ИЗ GetPlayerData, затем сравниваем с gettime()
                if(GetPlayerData(playerid, P_VODO_TIME) <= gettime())
                {
                    new rand = random(sizeof(vodovedisyda));
                    EnablePlayerGPS(playerid, 0, vodovedisyda[rand][0], vodovedisyda[rand][1], vodovedisyda[rand][2]);
                    SetPVarInt(playerid, "vodomesto", rand);
                    SetPlayerSkin(playerid, 5344);
                    // Устанавливаем новое время ограничения (на 1 час)
                    GPSPoint(playerid, vodovedisyda[rand][0], vodovedisyda[rand][1], vodovedisyda[rand][2]);
                    SetPlayerData(playerid, P_VODO_TIME, 0);
                    UpdatePlayerDatabaseInt(playerid, "vodotime", 0);
                    
                    Send(playerid, -1, "Место крушения отмечено у вас на gps!");
                }
                else 
                {
                    
                    new message[128];
                    format(message, sizeof(message), "Не более 2-ух раз в час! ");
                    ShowNewNotification(playerid, 2, 5, 1, 10, message, "");
                }  
            }
        }         
    }     
}
    if(dialogid == 58902)
    {
        if(response)
        {
            new text[686];

            switch(listitem)
            {
            
            case 0,1,2,3,4,5:
            {
            SetPVarInt(playerid, "vodocar", listitem);
            format(text, sizeof text,"Вы действительно желаете взять в аренду {f0de41}%s {ffffff}за {f0de41}%d {ffffff}рублей на {f0de41}1час?\n\n{ffffff}Вы сможете продлить аренду лодки на любом причале.\nВ случае, если Вы не успеете сдать лодку вовремя, аренда измениться на полуминутную (1000р/минута)", gBoatNames[listitem], gBoatPrices[listitem]);
            ShowPlayerDialog(playerid, 58903, DIALOG_STYLE_MSGBOX, "{ed4b00}Капитан пирса{fff7fc} | Аренда", text,"Выбрать","Назад");
            }
            }
            
         }
         else {
        ShowPlayerDialog(playerid, 58901, DIALOG_STYLE_LIST, "{ed4b00}Капитан пирса", "{ed4b00}1.{fff7fc}Арендовать лодку \t\t\t\t{dbd5d9}Нажмите для аренды\n{ed4b00}2.{fff7fc}Посмотреть список заданий \t\t\t\t{dbd5d9}Нажмите для просмотра\n{ed4b00}3.{fff7fc}Продажа найденных предметов  \t\t\t\t{dbd5d9}Нажмите для продажи","Выбрать","Закрыть");
        }
     }
if(dialogid == 58903)
    {
        if(response)
        {
            new text[286];
CreateLoadkaVodolaz(playerid);
            
        }
        else {
        ShowPlayerDialog(playerid, 58901, DIALOG_STYLE_LIST, "{ed4b00}Капитан пирса", "{ed4b00}1.{fff7fc}Арендовать лодку \t\t\t\t{dbd5d9}Нажмите для аренды\n{ed4b00}2.{fff7fc}Посмотреть список заданий \t\t\t\t{dbd5d9}Нажмите для просмотра\n{ed4b00}3.{fff7fc}Продажа найденных предметов  \t\t\t\t{dbd5d9}Нажмите для продажи","Выбрать","Закрыть");
        }
  }
if(dialogid == 58901)
    {
        if(response)
        {
            new text[286];

            switch(listitem +1)
            {
            case 1:
            {
            ShowPlayerDialog(playerid, 58902, DIALOG_STYLE_TABLIST_HEADERS, "{ed4b00}Капитан пирса{fff7fc} | Аренда",
"№ Название\tСтоимость\tДействие\n\
{ed4b00}1.{fff7fc}Гидроцикл\t7000руб.\t{dbd5d9}Нажмите для аренды\n\
{ed4b00}2.{fff7fc}Моторная лодка\t15000руб\t{dbd5d9}Нажмите для аренды\n\
{ed4b00}3.{fff7fc}Speedy Yacht\t17000руб.\t{dbd5d9}Нажмите для аренды\n\
{ed4b00}4.{fff7fc}Marine Yacht\t20000руб\t{dbd5d9}Нажмите для аренды\n\
{ed4b00}5.{fff7fc}Sea Yacht\t45000руб.\t{dbd5d9}Нажмите для аренды\n\
{ed4b00}6.{fff7fc}Ocean Yacht\t100000руб.\t{dbd5d9}Нажмите для аренды", // и т.д.
"Выбор", "Отмена");
            }
            case 2:
            {
            

            ShowPlayerDialog(playerid, 58904, DIALOG_STYLE_LIST, "{ed4b00}Капитан пирса{fff7fc} | Список заданий", "{ed4b00}1.{ffffff}Добыча предметов(водолаз)","Выбрать","Назад");
            
            }
            case 3:
            {
            callcmd::vodopredmpokaz(playerid, "");
            }
            }
          }
     }
    #if defined vodo_OnDialogResponse
    return vodo_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse vodo_OnDialogResponse
#if defined vodo_OnDialogResponse
forward vodo_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif
stock CreateLoadkaVodolaz(playerid)
{

    new vehicleid = INVALID_VEHICLE_ID;
    new modelid;
    new rand;
    new Float:spawnX, Float:spawnY, Float:spawnZ, Float:spawnAngle;
    new message[128];
    
    // Проверяем, есть ли уже лодка у игрока
    if(PlayerBoatID[playerid] != INVALID_VEHICLE_ID)
    {
        if(IsValidVehicle(PlayerBoatID[playerid]))
        {
            DestroyVehicle(PlayerBoatID[playerid]);
        }
        PlayerBoatID[playerid] = INVALID_VEHICLE_ID;
    }
    
    // Получаем модель лодки
    modelid = gBoatCarID[GetPVarInt(playerid, "vodocar")];
    
    // Проверяем корректность модели
    if(modelid <= 0)
    {
        SendClientMessage(playerid, -1, "Ошибка: неверная модель лодки!");
        return 0;
    }
    GivePlayerMoneyEx(playerid, -gBoatPrices[GetPVarInt(playerid, "vodocar")], "Аренда лодки", true, true);
    // Создаем лодку в зависимости от местоположения игрока
    if(IsPlayerInRangeOfPoint(playerid, 50.0, 2501.043701, -1253.509033, 1.436212))
    {
        rand = random(sizeof(lodkaPositions));
        spawnX = lodkaPositions[rand][posX];
        spawnY = lodkaPositions[rand][posY];
        spawnZ = lodkaPositions[rand][posZ];
        spawnAngle = lodkaPositions[rand][posAngle];
        
        vehicleid = CreateVehicle(modelid, spawnX, spawnY, spawnZ, spawnAngle, -1, -1, -1, 1);
        SetPlayerCheckpoint(playerid, spawnX, spawnY, spawnZ, 5.0);
        
        // Выводим координаты в чат
        format(message, sizeof(message), "Лодка создана на координатах: X=%.6f, Y=%.6f, Z=%.6f, Угол=%.6f", 
            spawnX, spawnY, spawnZ, spawnAngle);
    //    SendClientMessage(playerid, 0x00FF00AA, message);
    }
    else if(IsPlayerInRangeOfPoint(playerid, 50.0, -2528.527832, 357.601684, 2.100287))
    {
        rand = random(sizeof(lodkaPositionsL));
        spawnX = lodkaPositionsL[rand][posX];
        spawnY = lodkaPositionsL[rand][posY];
        spawnZ = lodkaPositionsL[rand][posZ];
        spawnAngle = lodkaPositionsL[rand][posAngle];
        
        vehicleid = CreateVehicle(modelid, spawnX, spawnY, spawnZ, spawnAngle, -1, -1, -1, 1);
        SetPlayerCheckpoint(playerid, spawnX, spawnY, spawnZ, 5.0);
        
        format(message, sizeof(message), "Лодка создана на координатах: X=%.6f, Y=%.6f, Z=%.6f, Угол=%.6f", 
            spawnX, spawnY, spawnZ, spawnAngle);
      //  SendClientMessage(playerid, 0x00FF00AA, message);
    }
    else if(IsPlayerInRangeOfPoint(playerid, 50.0, 652.959899, 173.051406, 2.08114))
    {
        rand = random(sizeof(lodkaPositionsA));
        spawnX = lodkaPositionsA[rand][posX];
        spawnY = lodkaPositionsA[rand][posY];
        spawnZ = lodkaPositionsA[rand][posZ];
        spawnAngle = lodkaPositionsA[rand][posAngle];
        
        vehicleid = CreateVehicle(modelid, spawnX, spawnY, spawnZ, spawnAngle, -1, -1, -1, 1);
        SetPlayerCheckpoint(playerid, spawnX, spawnY, spawnZ, 5.0);
        
        format(message, sizeof(message), "Лодка создана на координатах: X=%.6f, Y=%.6f, Z=%.6f, Угол=%.6f", 
            spawnX, spawnY, spawnZ, spawnAngle);
     //   SendClientMessage(playerid, 0x00FF00AA, message);
    }
    else if(IsPlayerInRangeOfPoint(playerid, 50.0, 2273.179443, 310.147216, 4.03999))
    {
        rand = random(sizeof(lodkaPositionsB));
        spawnX = lodkaPositionsB[rand][posX];
        spawnY = lodkaPositionsB[rand][posY];
        spawnZ = lodkaPositionsB[rand][posZ];
        spawnAngle = lodkaPositionsB[rand][posAngle];
        
        vehicleid = CreateVehicle(modelid, spawnX, spawnY, spawnZ, spawnAngle, -1, -1, -1, 1);
        SetPlayerCheckpoint(playerid, spawnX, spawnY, spawnZ, 5.0);
        
        format(message, sizeof(message), "Лодка создана на координатах: X=%.6f, Y=%.6f, Z=%.6f, Угол=%.6f", 
            spawnX, spawnY, spawnZ, spawnAngle);
      //  SendClientMessage(playerid, 0x00FF00AA, message);
    }
    else
    {
        SendClientMessage(playerid, -1, "Вы не находитесь рядом с точкой создания лодки!");
        return 0;
    }
    
    // Проверяем, создался ли транспорт
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        SendClientMessage(playerid, -1, "Ошибка создания транспорта!");
        return 0;
    }
    
    // Сохраняем ID транспорта
    PlayerBoatID[playerid] = vehicleid;
    
    // Помещаем игрока в транспорт
    //PutPlayerInVehicle(playerid, vehicleid, 0);
    
    // Дополнительное сообщение
   // SendClientMessage(playerid, -1, "Лодка создана! Следуйте к чекпоинту.");
    return 1;
}
public OnPlayerSpawn(playerid)
{
    PlayerBoatID[playerid] = INVALID_VEHICLE_ID;

    #if defined vodo_OnPlayerSpawn
        return vodo_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn vodo_OnPlayerSpawn
#if defined vodo_OnPlayerSpawn
    forward vodo_OnPlayerSpawn(playerid);
#endif



public OnPlayerEnterCheckpoint(playerid)
{ 
    //DisablePlayerCheckpoint(playerid);
	#if defined vodo_OnPlayerEnterCheckpoint
		return vodo_OnPlayerEnterCheckpoint(playerid);
	#else
	    return 1;
	#endif
}
   #if defined _ALS_OnPlayerEnterCheckpoint
    #undef OnPlayerEnterCheckpoint
#else
    #define _ALS_OnPlayerEnterCheckpoint
#endif
#define OnPlayerEnterCheckpoint vodo_OnPlayerEnterCheckpoint
#if defined vodo_OnPlayerEnterCheckpoint
    forward vodo_OnPlayerEnterCheckpoint(playerid);
#endif

CMD:vodogo(playerid)
{

if(GetPlayerLevel(playerid)<18) return ShowClientNotification(playerid, 2, 6, 0, 0, "Для работы требуется 18 уровень!", "");
ShowPlayerDialog(playerid, 58901, DIALOG_STYLE_LIST, "{ed4b00}Капитан пирса", "{ed4b00}1.{fff7fc}Арендовать лодку \t\t\t\t{dbd5d9}Нажмите для аренды\n{ed4b00}2.{fff7fc}Посмотреть список заданий \t\t\t\t{dbd5d9}Нажмите для просмотра\n{ed4b00}3.{fff7fc}Продажа найденных предметов  \t\t\t\t{dbd5d9}Нажмите для продажи","Выбрать","Закрыть");
}
/*
CMD:vodopremd(playerid)
{
    new rand = GetPVarInt(playerid, "vodomesto");
    
    if(IsPlayerInRangeOfPoint(playerid, 200.0, vodovedisyda[rand][0], vodovedisyda[rand][1], vodovedisyda[rand][2]))
    {
        // Определяем, в какой зоне находится игрок
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        
        // Проверяем все зоны предметов
        for(new i = 0; i < sizeof(yg_areas); i++)
        {
            if(IsPlayerInDynamicArea(playerid, yg_areas[i]))
            {
                // Если предмет еще не собран
                if(PlayerVodoItems[playerid][yg_collected][i] == 0)
                {
                    AddPlayerData(playerid, P_VODORPEDM, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
                    PlayerVodoItems[playerid][yg_collected][i] = 1; // Помечаем как собранный
                    Send(playerid, -1, "Вы подняли предмет");
                    return 1;
                }
                else
                {
                    Send(playerid, -1, "Вы уже собирали этот предмет!");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(bat_areas1); i++)
        {
            if(IsPlayerInDynamicArea(playerid, bat_areas1[i]))
            {
                if(PlayerVodoItems[playerid][bat1_collected][i] == 0)
                {
                    AddPlayerData(playerid, P_VODORPEDM, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
                    PlayerVodoItems[playerid][bat1_collected][i] = 1;
                    Send(playerid, -1, "Вы подняли предмет");
                    return 1;
                }
                else
                {
                    Send(playerid, -1, "Вы уже собирали этот предмет!");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(bat_areas2); i++)
        {
            if(IsPlayerInDynamicArea(playerid, bat_areas2[i]))
            {
                if(PlayerVodoItems[playerid][bat2_collected][i] == 0)
                {
                    AddPlayerData(playerid, P_VODORPEDM, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
                    PlayerVodoItems[playerid][bat2_collected][i] = 1;
                    Send(playerid, -1, "Вы подняли предмет");
                    return 1;
                }
                else
                {
                    Send(playerid, -1, "Вы уже собирали этот предмет!");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(lit_areas1); i++)
        {
            if(IsPlayerInDynamicArea(playerid, lit_areas1[i]))
            {
                if(PlayerVodoItems[playerid][lit1_collected][i] == 0)
                {
                    AddPlayerData(playerid, P_VODORPEDM, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
                    PlayerVodoItems[playerid][lit1_collected][i] = 1;
                    Send(playerid, -1, "Вы подняли предмет");
                    return 1;
                }
                else
                {
                    Send(playerid, -1, "Вы уже собирали этот предмет!");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(lit_areas2); i++)
        {
            if(IsPlayerInDynamicArea(playerid, lit_areas2[i]))
            {
                if(PlayerVodoItems[playerid][lit2_collected][i] == 0)
                {
                    AddPlayerData(playerid, P_VODORPEDM, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
                    PlayerVodoItems[playerid][lit2_collected][i] = 1;
                    Send(playerid, -1, "Вы подняли предмет");
                    return 1;
                }
                else
                {
                    Send(playerid, -1, "Вы уже собирали этот предмет!");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(yzka_areas); i++)
        {
            if(IsPlayerInDynamicArea(playerid, yzka_areas[i]))
            {
                if(PlayerVodoItems[playerid][yzka_collected][i] == 0)
                {
                    AddPlayerData(playerid, P_VODORPEDM, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
                    PlayerVodoItems[playerid][yzka_collected][i] = 1;
                    Send(playerid, -1, "Вы подняли предмет");
                    return 1;
                }
                else
                {
                    Send(playerid, -1, "Вы уже собирали этот предмет!");
                    return 1;
                }
            }
        }
        
        Send(playerid, -1, "Вы не находитесь рядом с предметом для поднятия!");
        return 1;
    }
    else return Send(playerid, -1,"Отправляйтесь на место крушения\nОно отмечено у вас в навигаторе!");
}*/
CMD:vodopremd(playerid)
{
    new rand = GetPVarInt(playerid, "vodomesto");
    
    if(IsPlayerInRangeOfPoint(playerid, 200.0, vodovedisyda[rand][0], vodovedisyda[rand][1], vodovedisyda[rand][2]))
    {
        // Определяем, в какой зоне находится игрок
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        
        // Проверяем все зоны предметов
        for(new i = 0; i < sizeof(yg_areas); i++)
        {
            if(IsPlayerInDynamicArea(playerid, yg_areas[i]))
            {
                // Если предмет еще не собран
                if(PlayerVodoItems[playerid][yg_collected][i] == 0)
                {
                    AddPlayerData(playerid, P_VODORPEDM, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
                    PlayerVodoItems[playerid][yg_collected][i] = 1; // Помечаем как собранный
                    Send(playerid, -1, "Вы подняли предмет");
                    
                    // Проверяем, собраны ли все предметы в этой зоне
                    CheckAllItemsCollected(playerid, "yg", i);
                    return 1;
                }
                else
                {
                    Send(playerid, -1, "Вы уже собирали этот предмет!");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(bat_areas1); i++)
        {
            if(IsPlayerInDynamicArea(playerid, bat_areas1[i]))
            {
                if(PlayerVodoItems[playerid][bat1_collected][i] == 0)
                {
                    AddPlayerData(playerid, P_VODORPEDM, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
                    PlayerVodoItems[playerid][bat1_collected][i] = 1;
                    Send(playerid, -1, "Вы подняли предмет");
                    
                    // Проверяем, собраны ли все предметы в этой зоне
                    CheckAllItemsCollected(playerid, "bat1", i);
                    return 1;
                }
                else
                {
                    Send(playerid, -1, "Вы уже собирали этот предмет!");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(bat_areas2); i++)
        {
            if(IsPlayerInDynamicArea(playerid, bat_areas2[i]))
            {
                if(PlayerVodoItems[playerid][bat2_collected][i] == 0)
                {
                    AddPlayerData(playerid, P_VODORPEDM, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
                    PlayerVodoItems[playerid][bat2_collected][i] = 1;
                    Send(playerid, -1, "Вы подняли предмет");
                    
                    // Проверяем, собраны ли все предметы в этой зоне
                    CheckAllItemsCollected(playerid, "bat2", i);
                    return 1;
                }
                else
                {
                    Send(playerid, -1, "Вы уже собирали этот предмет!");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(lit_areas1); i++)
        {
            if(IsPlayerInDynamicArea(playerid, lit_areas1[i]))
            {
                if(PlayerVodoItems[playerid][lit1_collected][i] == 0)
                {
                    AddPlayerData(playerid, P_VODORPEDM, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
                    PlayerVodoItems[playerid][lit1_collected][i] = 1;
                    Send(playerid, -1, "Вы подняли предмет");
                    
                    // Проверяем, собраны ли все предметы в этой зоне
                    CheckAllItemsCollected(playerid, "lit1", i);
                    return 1;
                }
                else
                {
                    Send(playerid, -1, "Вы уже собирали этот предмет!");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(lit_areas2); i++)
        {
            if(IsPlayerInDynamicArea(playerid, lit_areas2[i]))
            {
                if(PlayerVodoItems[playerid][lit2_collected][i] == 0)
                {
                    AddPlayerData(playerid, P_VODORPEDM, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
                    PlayerVodoItems[playerid][lit2_collected][i] = 1;
                    Send(playerid, -1, "Вы подняли предмет");
                    
                    // Проверяем, собраны ли все предметы в этой зоне
                    CheckAllItemsCollected(playerid, "lit2", i);
                    return 1;
                }
                else
                {
                    Send(playerid, -1, "Вы уже собирали этот предмет!");
                    return 1;
                }
            }
        }
        
        for(new i = 0; i < sizeof(yzka_areas); i++)
        {
            if(IsPlayerInDynamicArea(playerid, yzka_areas[i]))
            {
                if(PlayerVodoItems[playerid][yzka_collected][i] == 0)
                {
                    AddPlayerData(playerid, P_VODORPEDM, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "vodopr", GetPlayerData(playerid, P_VODORPEDM));
                    PlayerVodoItems[playerid][yzka_collected][i] = 1;
                    Send(playerid, -1, "Вы подняли предмет");
                    
                    // Проверяем, собраны ли все предметы в этой зоне
                    CheckAllItemsCollected(playerid, "yzka", i);
                    return 1;
                }
                else
                {
                    Send(playerid, -1, "Вы уже собирали этот предмет!");
                    return 1;
                }
            }
        }
        
        Send(playerid, -1, "Вы не находитесь рядом с предметом для поднятия!");
        return 1;
    }
    else return Send(playerid, -1,"Отправляйтесь на место крушения\nОно отмечено у вас в навигаторе!");
}
// Функция для проверки сбора всех предметов в зоне
CheckAllItemsCollected(playerid, zone_name[], collected_index)
{
    // Проверяем, все ли предметы собраны в этой зоне
    new all_collected = 1;
    
    if(strcmp(zone_name, "yg") == 0)
    {
        for(new i = 0; i < sizeof(yg_areas); i++)
        {
            if(PlayerVodoItems[playerid][yg_collected][i] == 0)
            {
                all_collected = 0;
                break;
            }
        }
    }
    else if(strcmp(zone_name, "bat1") == 0)
    {
        for(new i = 0; i < sizeof(bat_areas1); i++)
        {
            if(PlayerVodoItems[playerid][bat1_collected][i] == 0)
            {
                all_collected = 0;
                break;
            }
        }
    }
    else if(strcmp(zone_name, "bat2") == 0)
    {
        for(new i = 0; i < sizeof(bat_areas2); i++)
        {
            if(PlayerVodoItems[playerid][bat2_collected][i] == 0)
            {
                all_collected = 0;
                break;
            }
        }
    }
    else if(strcmp(zone_name, "lit1") == 0)
    {
        for(new i = 0; i < sizeof(lit_areas1); i++)
        {
            if(PlayerVodoItems[playerid][lit1_collected][i] == 0)
            {
                all_collected = 0;
                break;
            }
        }
    }
    else if(strcmp(zone_name, "lit2") == 0)
    {
        for(new i = 0; i < sizeof(lit_areas2); i++)
        {
            if(PlayerVodoItems[playerid][lit2_collected][i] == 0)
            {
                all_collected = 0;
                break;
            }
        }
    }
    else if(strcmp(zone_name, "yzka") == 0)
    {
        for(new i = 0; i < sizeof(yzka_areas); i++)
        {
            if(PlayerVodoItems[playerid][yzka_collected][i] == 0)
            {
                all_collected = 0;
                break;
            }
        }
    }
    
    // Если все предметы собраны
    if(all_collected == 1)
    {
        // Получаем текущие координаты игрока
        new Float:player_x, Float:player_y, Float:player_z;
        GetPlayerPos(playerid, player_x, player_y, player_z);
        
        // Координаты капитанов
        new Float:kapitan_coords[4][3] = {
            {-2528.527832, 357.601684, 2.100287},    // kapitanp1
            {652.959899, 173.051406, 2.081145},      // kapitanp2
            {2273.179443, 310.147216, 4.03999},      // kapitanp3
            {2501.043701, -1253.509033, 1.436212}    // kapitanp4
        };
        
        // Находим ближайшего капитана
        new closest_kapitan = 0;
        new Float:closest_distance = Float:0x7F800000; // максимальное значение float
        
        for(new i = 0; i < 4; i++)
        {
            new Float:distance = GetPlayerDistanceFromPoint(playerid, 
                kapitan_coords[i][0], 
                kapitan_coords[i][1], 
                kapitan_coords[i][2]);
            
            if(distance < closest_distance)
            {
                closest_distance = distance;
                closest_kapitan = i;
            }
        }
        
        // Отправляем игрока к ближайшему капитану
        new kapitan_name[32];
        switch(closest_kapitan)
        {
            case 0: kapitan_name = "Первому капитану";
            case 1: kapitan_name = "Второму капитану";
            case 2: kapitan_name = "Третьему капитану";
            case 3: kapitan_name = "Четвертому капитану";
        }
        
        // Устанавливаем маршрут на GPS
        EnablePlayerGPS(playerid, 0, 
            kapitan_coords[closest_kapitan][0], 
            kapitan_coords[closest_kapitan][1], 
            kapitan_coords[closest_kapitan][2]);
        
        // Сообщаем игроку
        new msg[128];
        format(msg, sizeof(msg), "Вы собрали все предметы в этой зоне! Отправляйтесь к {FF9900}%s {FFFFFF}для продажи.", kapitan_name);
        Send(playerid, -1, msg);
        Send(playerid, -1, "Маршрут установлен на ваш GPS.");
        AddPlayerData(playerid, P_ZADANIE_VODO, +, 1);
        UpdatePlayerDatabaseInt(playerid, "vodozadanie", GetPlayerData(playerid, P_ZADANIE_VODO));
        if(GetPlayerData(playerid, P_ZADANIE_VODO)==2)
        {
 SetPlayerData(playerid, P_ZADANIE_VODO, 0);
        UpdatePlayerDatabaseInt(playerid, "vodozadanie", GetPlayerData(playerid, P_ZADANIE_VODO));       
 new time = gettime();
new stop_time = time + 3600; // 3600 секунд = 1 час
SetPlayerData(playerid, P_VODO_TIME, stop_time);
UpdatePlayerDatabaseInt(playerid, "vodotime", GetPlayerData(playerid, P_VODO_TIME));
        }
        // Сохраняем информацию о том, что зона полностью собрана
        SetPVarInt(playerid, "Vodolaz_ZoneCompleted", 1);
        SetPVarInt(playerid, "Closest_Kapitan", closest_kapitan);
    }
    else
    {
        // Если еще не все предметы собраны, показываем сколько осталось
        new items_left = 0;
        
        if(strcmp(zone_name, "yg") == 0)
        {
            for(new i = 0; i < sizeof(yg_areas); i++)
            {
                if(PlayerVodoItems[playerid][yg_collected][i] == 0) items_left++;
            }
        }
        else if(strcmp(zone_name, "bat1") == 0)
        {
            for(new i = 0; i < sizeof(bat_areas1); i++)
            {
                if(PlayerVodoItems[playerid][bat1_collected][i] == 0) items_left++;
            }
        }
        else if(strcmp(zone_name, "bat2") == 0)
        {
            for(new i = 0; i < sizeof(bat_areas2); i++)
            {
                if(PlayerVodoItems[playerid][bat2_collected][i] == 0) items_left++;
            }
        }
        else if(strcmp(zone_name, "lit1") == 0)
        {
            for(new i = 0; i < sizeof(lit_areas1); i++)
            {
                if(PlayerVodoItems[playerid][lit1_collected][i] == 0) items_left++;
            }
        }
        else if(strcmp(zone_name, "lit2") == 0)
        {
            for(new i = 0; i < sizeof(lit_areas2); i++)
            {
                if(PlayerVodoItems[playerid][lit2_collected][i] == 0) items_left++;
            }
        }
        else if(strcmp(zone_name, "yzka") == 0)
        {
            for(new i = 0; i < sizeof(yzka_areas); i++)
            {
                if(PlayerVodoItems[playerid][yzka_collected][i] == 0) items_left++;
            }
        }
        
        new msg[64];
        format(msg, sizeof(msg), "Осталось собрать предметов в этой зоне: {FF9900}%d", items_left);
        Send(playerid, -1, msg);
    }
}

// Вспомогательная функция для получения дистанции до точки

CMD:vodopredmpokaz(playerid)
{
    new items_count = GetPlayerData(playerid, P_VODORPEDM);
    
    if(items_count <= 0)
    {
        Send(playerid, -1, "У вас нет предметов для продажи!");
        return 1;
    }
    
    new query[256];
    new listed = 0;
    new dialog_text[1024] = "№\tНазвание\tСтоимость\n";
    
    // Используем остаток от деления для циклического использования названий
    for (new i = 0; i < items_count; i++)
    {
        new item_index = i % sizeof(VodolazItemNames); // Циклический индекс
        new price_index = i % sizeof(VodolazItemPrices); // Циклический индекс для цен
        
        format(query, sizeof query, "%d\t%s\tрублей%d\n", 
            listed + 1, 
            VodolazItemNames[item_index], 
            VodolazItemPrices[price_index]
        );
        strcat(dialog_text, query);
        listed++;
    }
    
    // Сохраняем информацию для обработки диалога
    SetPVarInt(playerid, "Vodolaz_ItemsCount", listed);
    
    ShowPlayerDialog(playerid, 58909, DIALOG_STYLE_TABLIST_HEADERS, 
        "{ed4b00}Капитан пирса{fff7fc} | Продажа предметов",
        dialog_text,
        "Выбрать", "Закрыть"
    );
    
    return 1;
}
stock GPSPoint(playerid, Float:x, Float:y, Float:z, color = 0xFF0000FF) 
{
    new BitStream:bs = BS_New();

    BS_WriteValue(bs, PR_UINT8, 0x1A);

    BS_WriteValue(bs, PR_UINT32, color);

    BS_WriteValue(bs, PR_FLOAT, x);
    BS_WriteValue(bs, PR_FLOAT, y);
    BS_WriteValue(bs, PR_FLOAT, z);

    PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED); 
    BS_Delete(bs);

    return 1;
} 