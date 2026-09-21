// ================== ЗАГОЛОВОЧНЫЕ ДАННЫЕ ==================
new Text:larek_TD[27];
new PlayerText:larek_PTD[MAX_PLAYERS][7];

new Float:larek_default[11][3] =
{
    {2744.392333,-2429.169677,21.7},
    {1889.020263,-2243.588134,11.0},
    {1912.404785,-2266.849121,11.0},
    {847.117126,802.560485,13.3750},
    {1801.615356,2531.533203,14.60},
    {-1760.908569,790.954895,35.70},
    {-2402.363525,194.538864,26.00},
    {-111.869384,905.176818,12.210},
    {-113.259536,942.282653,12.210},
    {-256.006896,573.983764,12.19},
    {-1777.695312,817.128906,35.5}
};

new status_object_larek[2][] = 
{
    "txd:larek_select_no",
    "txd:larek_select_yes"
};

new player_larek[MAX_PLAYERS][7];
new player_satiety[MAX_PLAYERS] = 100;

new food_larek[6][2] =
{
    {30, 2},    // Чай
    {580, 20},  // Сосиска в тесте
    {80, 3},    // Кофе
    {320, 15},  // Пирожок
    {120, 5},   // Хот-дог
    {230, 10}   // Чебурек
};

// ================== КОНСТАНТЫ ==================
#define BUSINESS_TYPE_LAREK 11

// ================== ИНИЦИАЛИЗАЦИЯ ЛАРЬКОВ В БД ==================
public: CREATE_LAREK()
{
    mysql_query(mysql, "SELECT * FROM accounts WHERE satiety", true);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD `satiety` INT NOT NULL DEFAULT '100' AFTER `money`", false);

        if(mysql_errno()) printf("%d error alter satiety", mysql_errno());
    }

    new string[684];
    format(string, sizeof string, "SELECT * FROM business WHERE type = %d", BUSINESS_TYPE_LAREK);
    new Cache:cache = mysql_query(mysql, string);

    if(!cache_num_rows()) 
    {
        for(new i = 0, s = sizeof larek_default; i < s; i++) 
        {
            mysql_format(mysql, string, sizeof string, 
                "INSERT INTO `business` (`owner_id`, `name`, `improvements`, `products`, `prod_price`, `balance`, `rent_time`, `price`, `rent_price`, `type`, `interior`, `enter_price`, `enter_music`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `eviction`) \
                VALUES ('0', 'Ларёк', '0', '0', '0', '0', '0', '500000', '2500', '%d', '11', '0', '0', '0', '%.2f', '%.2f', '%.2f', '0.0', '0.0', '0.0', '0.0', '0')", 
                BUSINESS_TYPE_LAREK,    
                larek_default[i][0],
                larek_default[i][1],
                larek_default[i][2]
            );
            mysql_query(mysql, string, false);

            if(mysql_errno()) 
            {
                printf("CREATE Business LAREK number %d error: %d", i, mysql_errno());
                return 1;
            }
        }

        SendRconCommand("gmx"); // Перезапуск сервера после создания ларьков
    }

    cache_delete(cache);
    return 1;
}

// ================== ОБНОВЛЕНИЕ СЫТОСТИ ==================
public:UpdateSatiety()
{
    new Float:health, Float:health_n, string[144];

    foreach(new i : Player) 
    {
        if(!IsPlayerLogged(i)) continue;

        health = GetPlayerHealthEx(i);
        
        switch(player_satiety[i])
        {
            case 25..50:
            {
                format(string, sizeof string, "Уровень сытости ниже 50%% (%d%%). Рекомендуем подкрепиться в ближайшем ларьке", player_satiety[i]);
                SendClientMessage(i, 0xF3D80CFF, string);
                player_satiety[i] -= random(5) + 1;
            }
            case 5..24:
            {
                format(string, sizeof string, "Уровень сытости ниже 25%% (%d%%)", player_satiety[i]);
                SendClientMessage(i, 0xF3D80CFF, "Вы голодны! Подкрепитесь в ближайшем ларьке, иначе здоровье ухудшится!");
                SendClientMessage(i, 0xF3D80CFF, string);
                
                player_satiety[i] -= random(6) + 3;
                health_n = health - random(8);

                if(health_n <= 0) 
                {
                    SendClientMessage(i, -1, "Вы потеряли сознание от голода!");
                    SetPlayerHealthEx(i, 0);
                }
                else SetPlayerHealthEx(i, health - random(5));
            }
            case 0..4:
            {
                player_satiety[i] = 25;
                SetPlayerHealthEx(i, 0);
                SendClientMessage(i, -1, "Вы потеряли сознание от голода!");
            }
        }

        UpdatePlayerDatabaseInt(i, "satiety", player_satiety[i]);
    }

    return 1;
}

// ================== OnGameModeInit ==================
public OnGameModeInit()
{
    SetTimer("CREATE_LAREK", 4000, false);
    SetTimer("UpdateSatiety", 1000 * 300, true);
    TextDrawLarek();
    
    #if defined larekk_OnGameModeInit
        return larekk_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit larekk_OnGameModeInit
#if defined larekk_OnGameModeInit
    forward larekk_OnGameModeInit();
#endif

// ================== СОЗДАНИЕ ТЕКСТДРАВОВ ==================
stock TextDrawLarek()
{
    new string[64];

    larek_TD[0] = TextDrawCreate(60.0000, 75.6666, "txd:larek_bg");
    TextDrawTextSize(larek_TD[0], 524.0000, 326.0000);
    TextDrawAlignment(larek_TD[0], 1);
    TextDrawColor(larek_TD[0], -61);
    TextDrawBackgroundColor(larek_TD[0], 255);
    TextDrawFont(larek_TD[0], 4);
    TextDrawSetProportional(larek_TD[0], 0);
    TextDrawSetShadow(larek_TD[0], 0);

    larek_TD[1] = TextDrawCreate(558.3334, 81.3703, "txd:ic_close_single");
    TextDrawTextSize(larek_TD[1], 17.0000, 24.0000);
    TextDrawAlignment(larek_TD[1], 1);
    TextDrawColor(larek_TD[1], -1);
    TextDrawBackgroundColor(larek_TD[1], 255);
    TextDrawFont(larek_TD[1], 4);
    TextDrawSetProportional(larek_TD[1], 0);
    TextDrawSetShadow(larek_TD[1], 0);
    TextDrawSetSelectable(larek_TD[1], true);

    larek_TD[2] = TextDrawCreate(106.6666, 271.1482, "txd:larek_img_sausage");
    TextDrawTextSize(larek_TD[2], 60.0000, 65.0000);
    TextDrawAlignment(larek_TD[2], 1);
    TextDrawColor(larek_TD[2], -1);
    TextDrawBackgroundColor(larek_TD[2], 255);
    TextDrawFont(larek_TD[2], 4);
    TextDrawSetProportional(larek_TD[2], 0);
    TextDrawSetShadow(larek_TD[2], 0);

    larek_TD[3] = TextDrawCreate(180.4167, 279.1853, "Сосиска в тесте");
    TextDrawLetterSize(larek_TD[3], 0.1650, 1.3148);
    TextDrawAlignment(larek_TD[3], 1);
    TextDrawColor(larek_TD[3], -1641274881);
    TextDrawBackgroundColor(larek_TD[3], 255);
    TextDrawFont(larek_TD[3], 1);
    TextDrawSetProportional(larek_TD[3], 1);
    TextDrawSetShadow(larek_TD[3], 0);

    format(string, 64, "Стоимость: %dP", food_larek[1][0]);
    larek_TD[4] = TextDrawCreate(180.4169, 293.7038, string);
    TextDrawLetterSize(larek_TD[4], 0.1433, 1.0140);
    TextDrawAlignment(larek_TD[4], 1);
    TextDrawColor(larek_TD[4], -1);
    TextDrawBackgroundColor(larek_TD[4], 255);
    TextDrawFont(larek_TD[4], 1);
    TextDrawSetProportional(larek_TD[4], 1);
    TextDrawSetShadow(larek_TD[4], 0);

    format(string, 64, "Сытость: %d ед.", food_larek[1][1]);
    larek_TD[5] = TextDrawCreate(180.4169, 303.0372, string);
    TextDrawLetterSize(larek_TD[5], 0.1433, 1.0140);
    TextDrawAlignment(larek_TD[5], 1);
    TextDrawColor(larek_TD[5], -1);
    TextDrawBackgroundColor(larek_TD[5], 255);
    TextDrawFont(larek_TD[5], 1);
    TextDrawSetProportional(larek_TD[5], 1);
    TextDrawSetShadow(larek_TD[5], 0);

    larek_TD[6] = TextDrawCreate(431.6665, 255.0742, "txd:larek_img_tea");
    TextDrawTextSize(larek_TD[6], 62.0000, 90.0000);
    TextDrawAlignment(larek_TD[6], 1);
    TextDrawColor(larek_TD[6], -1);
    TextDrawBackgroundColor(larek_TD[6], 255);
    TextDrawFont(larek_TD[6], 4);
    TextDrawSetProportional(larek_TD[6], 0);
    TextDrawSetShadow(larek_TD[6], 0);

    larek_TD[7] = TextDrawCreate(504.5832, 279.1854, "Чай");
    TextDrawLetterSize(larek_TD[7], 0.1650, 1.3148);
    TextDrawAlignment(larek_TD[7], 1);
    TextDrawColor(larek_TD[7], -1641274881);
    TextDrawBackgroundColor(larek_TD[7], 255);
    TextDrawFont(larek_TD[7], 1);
    TextDrawSetProportional(larek_TD[7], 1);
    TextDrawSetShadow(larek_TD[7], 0);

    format(string, 64, "Стоимость: %dP", food_larek[0][0]);
    larek_TD[8] = TextDrawCreate(504.5834, 293.7040, string);
    TextDrawLetterSize(larek_TD[8], 0.1433, 1.0140);
    TextDrawAlignment(larek_TD[8], 1);
    TextDrawColor(larek_TD[8], -1);
    TextDrawBackgroundColor(larek_TD[8], 255);
    TextDrawFont(larek_TD[8], 1);
    TextDrawSetProportional(larek_TD[8], 1);
    TextDrawSetShadow(larek_TD[8], 0);

    format(string, 64, "Сытость: %d ед.", food_larek[0][1]);
    larek_TD[9] = TextDrawCreate(504.5834, 303.0373, string);
    TextDrawLetterSize(larek_TD[9], 0.1433, 1.0140);
    TextDrawAlignment(larek_TD[9], 1);
    TextDrawColor(larek_TD[9], -1);
    TextDrawBackgroundColor(larek_TD[9], 255);
    TextDrawFont(larek_TD[9], 1);
    TextDrawSetProportional(larek_TD[9], 1);
    TextDrawSetShadow(larek_TD[9], 0);

    larek_TD[10] = TextDrawCreate(277.9162, 272.7038, "txd:larek_img_coffe");
    TextDrawTextSize(larek_TD[10], 48.0000, 54.0000);
    TextDrawAlignment(larek_TD[10], 1);
    TextDrawColor(larek_TD[10], -1);
    TextDrawBackgroundColor(larek_TD[10], 255);
    TextDrawFont(larek_TD[10], 4);
    TextDrawSetProportional(larek_TD[10], 0);
    TextDrawSetShadow(larek_TD[10], 0);

    larek_TD[11] = TextDrawCreate(342.4995, 279.1853, "Кофе");
    TextDrawLetterSize(larek_TD[11], 0.1650, 1.3148);
    TextDrawAlignment(larek_TD[11], 1);
    TextDrawColor(larek_TD[11], -1641274881);
    TextDrawBackgroundColor(larek_TD[11], 255);
    TextDrawFont(larek_TD[11], 1);
    TextDrawSetProportional(larek_TD[11], 1);
    TextDrawSetShadow(larek_TD[11], 0);

    format(string, 64, "Стоимость: %dP", food_larek[2][0]);
    larek_TD[12] = TextDrawCreate(342.4997, 293.7039, string);
    TextDrawLetterSize(larek_TD[12], 0.1433, 1.0140);
    TextDrawAlignment(larek_TD[12], 1);
    TextDrawColor(larek_TD[12], -1);
    TextDrawBackgroundColor(larek_TD[12], 255);
    TextDrawFont(larek_TD[12], 1);
    TextDrawSetProportional(larek_TD[12], 1);
    TextDrawSetShadow(larek_TD[12], 0);

    format(string, 64, "Сытость: %d ед.", food_larek[2][1]);
    larek_TD[13] = TextDrawCreate(342.4997, 303.0372, string);
    TextDrawLetterSize(larek_TD[13], 0.1433, 1.0140);
    TextDrawAlignment(larek_TD[13], 1);
    TextDrawColor(larek_TD[13], -1);
    TextDrawBackgroundColor(larek_TD[13], 255);
    TextDrawFont(larek_TD[13], 1);
    TextDrawSetProportional(larek_TD[13], 1);
    TextDrawSetShadow(larek_TD[13], 0);

    larek_TD[14] = TextDrawCreate(110.4166, 159.1481, "txd:larek_img_hotdog");
    TextDrawTextSize(larek_TD[14], 55.0000, 58.0000);
    TextDrawAlignment(larek_TD[14], 1);
    TextDrawColor(larek_TD[14], -1);
    TextDrawBackgroundColor(larek_TD[14], 255);
    TextDrawFont(larek_TD[14], 4);
    TextDrawSetProportional(larek_TD[14], 0);
    TextDrawSetShadow(larek_TD[14], 0);

    larek_TD[15] = TextDrawCreate(180.4166, 167.1852, "Хот-дог");
    TextDrawLetterSize(larek_TD[15], 0.1650, 1.3148);
    TextDrawAlignment(larek_TD[15], 1);
    TextDrawColor(larek_TD[15], -1641274881);
    TextDrawBackgroundColor(larek_TD[15], 255);
    TextDrawFont(larek_TD[15], 1);
    TextDrawSetProportional(larek_TD[15], 1);
    TextDrawSetShadow(larek_TD[15], 0);

    format(string, 64, "Стоимость: %dP", food_larek[4][0]);
    larek_TD[16] = TextDrawCreate(180.4168, 181.7037, string);
    TextDrawLetterSize(larek_TD[16], 0.1433, 1.0140);
    TextDrawAlignment(larek_TD[16], 1);
    TextDrawColor(larek_TD[16], -1);
    TextDrawBackgroundColor(larek_TD[16], 255);
    TextDrawFont(larek_TD[16], 1);
    TextDrawSetProportional(larek_TD[16], 1);
    TextDrawSetShadow(larek_TD[16], 0);

    format(string, 64, "Сытость: %d ед.", food_larek[4][1]);
    larek_TD[17] = TextDrawCreate(180.4169, 191.0370, string);
    TextDrawLetterSize(larek_TD[17], 0.1433, 1.0140);
    TextDrawAlignment(larek_TD[17], 1);
    TextDrawColor(larek_TD[17], -1);
    TextDrawBackgroundColor(larek_TD[17], 255);
    TextDrawFont(larek_TD[17], 1);
    TextDrawSetProportional(larek_TD[17], 1);
    TextDrawSetShadow(larek_TD[17], 0);

    larek_TD[18] = TextDrawCreate(431.2500, 151.8890, "txd:larek_img_pie");
    TextDrawTextSize(larek_TD[18], 77.0000, 82.0000);
    TextDrawAlignment(larek_TD[18], 1);
    TextDrawColor(larek_TD[18], -1);
    TextDrawBackgroundColor(larek_TD[18], 255);
    TextDrawFont(larek_TD[18], 4);
    TextDrawSetProportional(larek_TD[18], 0);
    TextDrawSetShadow(larek_TD[18], 0);

    larek_TD[19] = TextDrawCreate(504.5834, 167.1853, "Пирожок");
    TextDrawLetterSize(larek_TD[19], 0.1650, 1.3148);
    TextDrawAlignment(larek_TD[19], 1);
    TextDrawColor(larek_TD[19], -1641274881);
    TextDrawBackgroundColor(larek_TD[19], 255);
    TextDrawFont(larek_TD[19], 1);
    TextDrawSetProportional(larek_TD[19], 1);
    TextDrawSetShadow(larek_TD[19], 0);

    format(string, 64, "Стоимость: %dP", food_larek[3][0]);
    larek_TD[20] = TextDrawCreate(504.5835, 181.7039, string);
    TextDrawLetterSize(larek_TD[20], 0.1433, 1.0140);
    TextDrawAlignment(larek_TD[20], 1);
    TextDrawColor(larek_TD[20], -1);
    TextDrawBackgroundColor(larek_TD[20], 255);
    TextDrawFont(larek_TD[20], 1);
    TextDrawSetProportional(larek_TD[20], 1);
    TextDrawSetShadow(larek_TD[20], 0);
    
    format(string, 64, "Сытость: %d ед.", food_larek[3][1]);
    larek_TD[21] = TextDrawCreate(504.5835, 191.0372, string);
    TextDrawLetterSize(larek_TD[21], 0.1433, 1.0140);
    TextDrawAlignment(larek_TD[21], 1);
    TextDrawColor(larek_TD[21], -1);
    TextDrawBackgroundColor(larek_TD[21], 255);
    TextDrawFont(larek_TD[21], 1);
    TextDrawSetProportional(larek_TD[21], 1);
    TextDrawSetShadow(larek_TD[21], 0);

    larek_TD[22] = TextDrawCreate(261.6665, 143.5925, "txd:larek_img_cheburek");
    TextDrawTextSize(larek_TD[22], 74.0000, 82.0000);
    TextDrawAlignment(larek_TD[22], 1);
    TextDrawColor(larek_TD[22], -1);
    TextDrawBackgroundColor(larek_TD[22], 255);
    TextDrawFont(larek_TD[22], 4);
    TextDrawSetProportional(larek_TD[22], 0);
    TextDrawSetShadow(larek_TD[22], 0);

    larek_TD[23] = TextDrawCreate(342.4997, 167.1852, "Чебурек");
    TextDrawLetterSize(larek_TD[23], 0.1650, 1.3148);
    TextDrawAlignment(larek_TD[23], 1);
    TextDrawColor(larek_TD[23], -1641274881);
    TextDrawBackgroundColor(larek_TD[23], 255);
    TextDrawFont(larek_TD[23], 1);
    TextDrawSetProportional(larek_TD[23], 1);
    TextDrawSetShadow(larek_TD[23], 0);

    format(string, 64, "Стоимость: %dP", food_larek[5][0]);
    larek_TD[24] = TextDrawCreate(342.4998, 181.7038, string);
    TextDrawLetterSize(larek_TD[24], 0.1433, 1.0140);
    TextDrawAlignment(larek_TD[24], 1);
    TextDrawColor(larek_TD[24], -1);
    TextDrawBackgroundColor(larek_TD[24], 255);
    TextDrawFont(larek_TD[24], 1);
    TextDrawSetProportional(larek_TD[24], 1);
    TextDrawSetShadow(larek_TD[24], 0);

    format(string, 64, "Сытость: %d ед.", food_larek[5][1]);
    larek_TD[25] = TextDrawCreate(342.4999, 191.0371, string);
    TextDrawLetterSize(larek_TD[25], 0.1433, 1.0140);
    TextDrawAlignment(larek_TD[25], 1);
    TextDrawColor(larek_TD[25], -1);
    TextDrawBackgroundColor(larek_TD[25], 255);
    TextDrawFont(larek_TD[25], 1);
    TextDrawSetProportional(larek_TD[25], 1);
    TextDrawSetShadow(larek_TD[25], 0);

    larek_TD[26] = TextDrawCreate(387.0835, 357.7406, "txd:larek_buy");
    TextDrawTextSize(larek_TD[26], 173.0000, 31.0000);
    TextDrawAlignment(larek_TD[26], 1);
    TextDrawColor(larek_TD[26], -1);
    TextDrawBackgroundColor(larek_TD[26], 255);
    TextDrawFont(larek_TD[26], 4);
    TextDrawSetProportional(larek_TD[26], 0);
    TextDrawSetShadow(larek_TD[26], 0);
    TextDrawSetSelectable(larek_TD[26], true);
}

// ================== СОЗДАНИЕ PLAYER ТЕКСТДРАВОВ ==================
stock PlayerTextDrawLarek(playerid)
{
    larek_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 401.6667, 244.7037, "txd:larek_select_no");
    PlayerTextDrawTextSize(playerid, larek_PTD[playerid][0], 159.0000, 109.0000);
    PlayerTextDrawAlignment(playerid, larek_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, larek_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, larek_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, larek_PTD[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, larek_PTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, larek_PTD[playerid][0], 0);
    PlayerTextDrawSetSelectable(playerid, larek_PTD[playerid][0], true);

    larek_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 77.4998, 244.7036, "txd:larek_select_no");
    PlayerTextDrawTextSize(playerid, larek_PTD[playerid][1], 159.0000, 109.0000);
    PlayerTextDrawAlignment(playerid, larek_PTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, larek_PTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, larek_PTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, larek_PTD[playerid][1], 4);
    PlayerTextDrawSetProportional(playerid, larek_PTD[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, larek_PTD[playerid][1], 0);
    PlayerTextDrawSetSelectable(playerid, larek_PTD[playerid][1], true);

    larek_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 239.5834, 244.7036, "txd:larek_select_no");
    PlayerTextDrawTextSize(playerid, larek_PTD[playerid][2], 159.0000, 109.0000);
    PlayerTextDrawAlignment(playerid, larek_PTD[playerid][2], 1);
    PlayerTextDrawColor(playerid, larek_PTD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, larek_PTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, larek_PTD[playerid][2], 4);
    PlayerTextDrawSetProportional(playerid, larek_PTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, larek_PTD[playerid][2], 0);
    PlayerTextDrawSetSelectable(playerid, larek_PTD[playerid][2], true);

    larek_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 401.6669, 132.7037, "txd:larek_select_no");
    PlayerTextDrawTextSize(playerid, larek_PTD[playerid][3], 159.0000, 109.0000);
    PlayerTextDrawAlignment(playerid, larek_PTD[playerid][3], 1);
    PlayerTextDrawColor(playerid, larek_PTD[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, larek_PTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, larek_PTD[playerid][3], 4);
    PlayerTextDrawSetProportional(playerid, larek_PTD[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, larek_PTD[playerid][3], 0);
    PlayerTextDrawSetSelectable(playerid, larek_PTD[playerid][3], true);

    larek_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 77.4999, 132.7036, "txd:larek_select_no");
    PlayerTextDrawTextSize(playerid, larek_PTD[playerid][4], 159.0000, 109.0000);
    PlayerTextDrawAlignment(playerid, larek_PTD[playerid][4], 1);
    PlayerTextDrawColor(playerid, larek_PTD[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, larek_PTD[playerid][4], 255);
    PlayerTextDrawFont(playerid, larek_PTD[playerid][4], 4);
    PlayerTextDrawSetProportional(playerid, larek_PTD[playerid][4], 0);
    PlayerTextDrawSetShadow(playerid, larek_PTD[playerid][4], 0);
    PlayerTextDrawSetSelectable(playerid, larek_PTD[playerid][4], true);

    larek_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 239.5833, 132.7036, "txd:larek_select_no");
    PlayerTextDrawTextSize(playerid, larek_PTD[playerid][5], 159.0000, 109.0000);
    PlayerTextDrawAlignment(playerid, larek_PTD[playerid][5], 1);
    PlayerTextDrawColor(playerid, larek_PTD[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, larek_PTD[playerid][5], 255);
    PlayerTextDrawFont(playerid, larek_PTD[playerid][5], 4);
    PlayerTextDrawSetProportional(playerid, larek_PTD[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, larek_PTD[playerid][5], 0);
    PlayerTextDrawSetSelectable(playerid, larek_PTD[playerid][5], true);

    larek_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 222.4999, 365.7778, "Общая стоимость: 0 рублей");
    PlayerTextDrawLetterSize(playerid, larek_PTD[playerid][6], 0.2312, 1.7192);
    PlayerTextDrawAlignment(playerid, larek_PTD[playerid][6], 2);
    PlayerTextDrawColor(playerid, larek_PTD[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, larek_PTD[playerid][6], 255);
    PlayerTextDrawFont(playerid, larek_PTD[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, larek_PTD[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, larek_PTD[playerid][6], 0);
}

// ================== ПОКАЗ ЛАРЬКА ==================
stock ShowPlayerLarek(playerid)
{
    TogglePlayerControllable(playerid, false);

    for(new i = 0; i < sizeof(larek_TD); i++)
        TextDrawShowForPlayer(playerid, larek_TD[i]);
    
    for(new i = 0; i < sizeof(larek_PTD[]); i++)
        PlayerTextDrawShow(playerid, larek_PTD[playerid][i]);

    for(new i = 0; i < 6; i++) 
        player_larek[playerid][i] = 0;

    UpdatePlayerLarek(playerid);
    player_larek[playerid][6] = GetPlayerInBiz(playerid);
    
    return 1;
}

// ================== СКРЫТИЕ ЛАРЬКА ==================
stock HidePlayerLarek(playerid)
{
    TogglePlayerControllable(playerid, true);

    for(new i = 0; i < sizeof(larek_TD); i++)
        TextDrawHideForPlayer(playerid, larek_TD[i]);
    
    for(new i = 0; i < sizeof(larek_PTD[]); i++)
        PlayerTextDrawHide(playerid, larek_PTD[playerid][i]);

    player_larek[playerid][6] = -1;
    
    return 1;
}

// ================== ОБНОВЛЕНИЕ ЛАРЬКА ==================
stock UpdatePlayerLarek(playerid) 
{
    new price;

    for(new i = 0; i < 6; i++)
    {
        if(player_larek[playerid][i]) 
        {
            PlayerTextDrawSetString(playerid, larek_PTD[playerid][i], status_object_larek[1]);
            price += food_larek[i][0];
        }
        else 
        {
            PlayerTextDrawSetString(playerid, larek_PTD[playerid][i], status_object_larek[0]);
        }
    }

    new string[68]; 
    format(string, sizeof string, "Общая стоимость: %d рублей", price);
    PlayerTextDrawSetString(playerid, larek_PTD[playerid][6], string);
}

// ================== КОМАНДА LAREK ==================
CMD:larek(playerid, params[])
{
    if(!IsPlayerLogged(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не авторизованы");
    
    if(player_larek[playerid][6] != 0 && player_larek[playerid][6] != -1)
        return SendClientMessage(playerid, 0xCECECEFF, "Вы уже открыли меню ларька");
    
    new businessid = GetPlayerInBiz(playerid);
    
    if(businessid == 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не находитесь в ларьке");
    
    if(GetBusinessData(businessid, B_TYPE) != BUSINESS_TYPE_LAREK)
        return SendClientMessage(playerid, 0xCECECEFF, "Это не ларёк");
    
    if(GetBusinessData(businessid, B_PRODS) <= 0)
        return SendClientMessage(playerid, 0xCECECEFF, "В этом ларьке закончились продукты");
    
    ShowPlayerLarek(playerid);
    return 1;
}

// ================== OnPlayerClickPlayerTextDraw ==================
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid >= larek_PTD[playerid][0] && playertextid <= larek_PTD[playerid][5])
    {
        new food = -1;
        for(new i = 0; i < 6; i++) 
        {
            if(larek_PTD[playerid][i] == playertextid) 
            { 
                food = i; 
                break; 
            }
        }

        if(food == -1) 
            return SendClientMessage(playerid, -1, "Ошибка выбора товара");

        player_larek[playerid][food] = !player_larek[playerid][food];
        UpdatePlayerLarek(playerid);
        
        return 1;
    }
    
    #if defined larekk_OnPlayerClickPlayerTextD
        return larekk_OnPlayerClickPlayerTextD(playerid, playertextid);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnPlayerClickPlayerTextD
    #undef OnPlayerClickPlayerTextDraw
#else
    #define _ALS_OnPlayerClickPlayerTextD
#endif
#if defined larekk_OnPlayerClickPlayerTextD
    forward larekk_OnPlayerClickPlayerTextD(playerid, PlayerText:playertextid);
#endif
#define OnPlayerClickPlayerTextDraw larekk_OnPlayerClickPlayerTextD

// ================== OnPlayerClickTextDraw ==================
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == larek_TD[1]) 
    {
        HidePlayerLarek(playerid);
        return 1;
    }

    if(clickedid == larek_TD[26]) 
    {
        if(player_larek[playerid][6] == -1 || player_larek[playerid][6] == 0) 
        {
            SendClientMessage(playerid, -1, "Ошибка: бизнес не найден");
            HidePlayerLarek(playerid);
            return 1;
        }
        
        new price, satiety, take_prods;
       
        for(new i = 0; i < 6; i++) 
        {
            if(player_larek[playerid][i]) 
            {
                price += food_larek[i][0];
                satiety += food_larek[i][1];
                take_prods++;
            }
        }

        if(!take_prods) 
            return SendClientMessage(playerid, -1, "Вы ничего не выбрали");

        if(GetPlayerMoneyEx(playerid) < price)
            return SendClientMessage(playerid, -1, "У вас не хватает денег");
            
        if(player_satiety[playerid] >= 100) 
            return SendClientMessage(playerid, -1, "Вы полностью сыты!");

        new businessid = player_larek[playerid][6];
        new string[528];
        
        // ИСПРАВЛЕНО: B_PRODS вместо B_PRODUCTS
        if(GetBusinessData(businessid, B_PRODS) >= take_prods)
        {
            format(string, sizeof string, "UPDATE business SET products=%d, balance=%d WHERE id=%d", 
                GetBusinessData(businessid, B_PRODS) - take_prods, 
                GetBusinessData(businessid, B_BALANCE) + price, 
                GetBusinessData(businessid, B_SQL_ID));
            mysql_query(mysql, string, false);

            if(!mysql_errno())
            {
                AddBusinessData(businessid, B_PRODS, -, take_prods);
                AddBusinessData(businessid, B_BALANCE, +, price);

                mysql_format(mysql, string, sizeof string, 
                    "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", 
                    GetBusinessData(businessid, B_SQL_ID), 
                    GetPlayerAccountID(playerid), 
                    GetPlayerIpEx(playerid), 
                    gettime(), 
                    price, 
                    IsBusinessOwned(businessid));
                mysql_query(mysql, string, false);
                
                GivePlayerMoneyEx(playerid, -price);

                new satiety_player = player_satiety[playerid] + satiety;
                if(satiety_player > 100) satiety_player = 100;
                
                player_satiety[playerid] = satiety_player;

                format(string, sizeof string, "Вы успешно подкрепились в ларьке на %d рублей и %d%% сытости!", price, satiety);
                SendClientMessage(playerid, -1, string);
                format(string, sizeof string, "Текущий процент сытости: %d%%", satiety_player);
                SendClientMessage(playerid, -1, string);

                UpdatePlayerDatabaseInt(playerid, "satiety", player_satiety[playerid]);
                
                // Сброс выбора после покупки
                for(new i = 0; i < 6; i++) 
                    player_larek[playerid][i] = 0;
                UpdatePlayerLarek(playerid);
            }
        }
        else
        {
            SendClientMessage(playerid, -1, "В этом ларьке недостаточно товаров");
        }
        
        return 1;
    }
    
    #if defined larekk_OnPlayerClickTextDraw
        return larekk_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw larekk_OnPlayerClickTextDraw
#if defined larekk_OnPlayerClickTextDraw
    forward larekk_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

// ================== OnPlayerConnect ==================
public OnPlayerConnect(playerid)
{
    PlayerTextDrawLarek(playerid);
    
    #if defined larekk_OnPlayerConnect
        return larekk_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect larekk_OnPlayerConnect
#if defined larekk_OnPlayerConnect
    forward larekk_OnPlayerConnect(playerid);
#endif