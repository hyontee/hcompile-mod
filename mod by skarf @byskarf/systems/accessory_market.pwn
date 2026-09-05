new bool:create_player_btn[MAX_PLAYERS];

// Глобальные текстдравы
new Text:acsmagaz_button_TD[5];

new Text: acss_fix_TD[26];
new PlayerText: acss_coords_fix_PTD[MAX_PLAYERS][1];

// Текстдравы для игроков
new PlayerText:acsmagaz_price_PTD[MAX_PLAYERS][1];
new player_select_accessory[MAX_PLAYERS];

enum ACCESSORY_M_STRCT
{
    ID_ACCESSORY,
    BONE_ACCESSORY,
    NAME_ACCESSORY[32],
    PRICE_ACCESSORY,
    
};
new pl_accessory[MAX_PLAYERS];
new pl_id_accessory[MAX_PLAYERS];


//1 - Спина 
//2 - Голова 
//3 - Плечо левой руки 
//4 - Плечо правой руки 
//5 - Левая рука 
//6 - Правая рука 
//7 - Левое бедро 
//8 - Правое бедро 
//9 - Левая нога 
//10 - Правая нога 
//11 - Правая голень
//12 - Левая голень
//13 - Левое предплечье 
//14 - Правое предплечье 
//15 - Левая ключица 
//16 - Правая ключица 
//17 - Шея 
//18 - Челюстьщас


new accessory[][ACCESSORY_M_STRCT] =
{
    {4196 , 1,"Крылья бабочки"                        ,15000000},
    {4197 , 2,"Маска пчелы"                           ,10000000},
    {4198 , 2,"Кленовая корона"                       ,7000000},
    {4199 , 1,"Рюкзак - реактивный ранец"             ,5000000},
    {4200 , 1,"Кленовая сумка"                        ,5000000},
    {4201 , 1,"Метла"                                 ,1000000},
    {4203 , 1,"Рюкзак с овощами"                      ,3000000},
    {4204 , 1,"Школьный рюкзак"                       ,3000000},
    {4205 , 2,"Шапка - подсолнух"                     ,2500000},
    {4206 , 1,"Черный зонт"                           ,1500000},
    {4207 , 1,"Зонт с листьями"                       ,1000000},
    {4208 , 1,"Розовый зонт"                          ,900000},
    {14574, 1,"Крылья демона"                         ,15000000},
    {14575, 1,"Крылья ангела"                         ,15000000},
    {14593, 1,"Карамельные крылья"                    ,15000000},
    {15134, 1,"Рюкзак инопланетянин"                  ,12000000},
    {15135, 2,"Шляпа ведьмы"                          ,2000000},
    {15136, 2,"Шляпа ведьмы"                          ,2000000},
    {15137, 2,"Шляпа ведьмы"                          ,2000000},
    {15138, 2,"Шляпа звезды"                          ,2000000},
    {15139, 2,"Красная шляпа ведьмы"                  ,2500000}, 
    {15140, 2,"Шляпа ведьмы"                          ,2000000},
    {15141, 2,"Шляпа ведьмы"                          ,2000000},
    {15142, 1,"Железная коса"                         ,2000000},
    {15143, 1,"Металлическая коса"                    ,1500000},
    {15144, 2,"Светящиеся красная маска"              ,500000},
    {15145, 2,"Маска маньяка"                         ,500000},
    {15146, 2,"Плачущая маска"                        ,500000},
    {15147, 2,"Страшная маска"                        ,700000},
    {15149, 1,"Метла"                                 ,1000000},
    {15150, 1,"Рюкзак FnaF"                           ,1500000},
    {15151, 2,"Маска ведущего"                        ,3000000},
    {15152, 2,"Светящиеся синяя маска"                ,500000},
    {15153, 2,"Светящиеся фиолетовая маска"           ,500000},
    {7329 , 2,"Красная повязка"                       ,300000},
    {7330 , 2,"Красная повязка"                       ,300000},
    {7331 , 2,"Военная каска 2"                       ,500000},
    {7332 , 2,"Черная шапка"                          ,300000},
    {7333 , 2,"Белая шапка"                           ,300000},
    {7334 , 2,"Синяя шапка"                           ,300000},
    {7336 , 2,"Синяя кепка 2"                         ,300000},
    {7337 , 2,"Синяя кепка 3"                         ,300000},
    {7338 , 2,"Разноцветная кепка"                    ,300000},
    {7339 , 2,"Черная кепка"                          ,300000},
    {7341 , 2,"Кепка (NY)"                            ,400000},
    {7342 , 2,"Шапка (Шерлок)"                        ,400000},
    {7343 , 2,"Панама №1 супе"                        ,300000},
    {7344 , 2,"Панама №2 (StoneIS)"                   ,300000},
    {7345 , 2,"Панама №3"                             ,300000},
    {7346 , 2,"Панана №4"                             ,300000},
    {7347 , 2,"Панама №5"                             ,300000},
    {7348 , 2,"Панама №6"                             ,300000},
    {7349 , 2,"Панама №7"                             ,300000},
    {7350 , 2,"Панама №8 (БП)"                        ,300000},
    {18377, 2,"Очки сердечки"                         ,7000000},
    {18386, 2,"Очки глаза"                            ,7000000},
    {18389, 2,"Шапочка с оленьями рожками"            ,300000},
    {18390, 2,"Очки матрица"                          ,6000000},
    {18391, 2,"Очки огонь"                            ,7000000},
    {18392, 2,"Очки огонь прямые"                     ,8000000},
    {18396, 2,"Маска гнома"                           ,2500000},
    {18397, 2,"Маска гринча"                          ,2000000},
    {18399, 2,"Рожки"                                 ,1000000},
    {18400, 2,"Рожки 2"                               ,100000},
    {18401, 2,"Очки салют"                            ,7000000},
    {18402, 2,"Маска котика"                          ,3000000},
    {18403, 2,"Маска тигра"                           ,3000000},
    {18404, 2,"Очки глюки"                            ,7000000},
    {18409, 2,"Очки снежинки"                         ,7000000},
    {7351 , 2,"Кепка"                                 ,300000},
    {7352 , 2,"Кепка 2"                               ,300000},
    {7353 , 2,"Кепка"                                 ,300000},
    {7354 , 2,"Кепка"                                 ,300000},
    {7355 , 2,"Шляпа №1"                              ,400000},
    {7356 , 2,"Шляпа №2"                              ,450000},
    {7357 , 2,"Шляпа №3 (New)"                        ,450000},
    {7358 , 2,"Шляпа №4"                              ,500000},
    {7359 , 2,"Шляпа №5"                              ,500000},
    {7360 , 2,"Шляпа №6"                              ,500000},
    {7362 , 2,"Синяя шапка"                           ,350000},
    {7364 , 1,"Зонт (Разноцветный)"                   ,8000000},
    {7367 , 6,"Кожаный кейс"                          ,5000000},
    {7368 , 6,"Кейс (2)"                              ,10000000},
    {7369 , 6,"Черный кейс"                           ,12000000},
    {7370 , 2,"Маска петуха"                          ,5000000},
    {7371 , 2,"Маска голубя"                          ,5000000},
    {7372 , 2,"Маска зелёная"                         ,3000000},
    {7374 , 2,"Маска медведя"                         ,4000000},
    {7375 , 2,"Маска самурай"                         ,5000000},
    {7376 , 2,"Маска самурай"                         ,5000000},
    {7377 , 1,"Катана"                                ,1000000},
    {7378 , 1,"Катана"                                ,1000000},
    {7379 , 2,"Шляпа самурая №1"                      ,1500000},
    {7380 , 2,"Шляпа самурая №2"                      ,1500000},
    {7381 , 2,"Шляпа самурая №3"                      ,1500000},
    {7382 , 2,"Шляпа индейца"                         ,1500000},
    {7383 , 1,"Доска для серфинга №1"                 ,500000},
    {7384 , 1,"Доска для серфинга №2"                 ,500000},
    {7385 , 1,"Доска для серфинга №3"                 ,500000},
    {7386 , 1,"Доска для серфинга №4"                 ,500000},
    {7387 , 1,"Акула"                                 ,750000},
    {7390 , 1,"Гитара №1"                             ,700000},
    {7391 , 1,"Гитара №2"                             ,700000},
    {7392 , 1,"Гитара №3"                             ,700000},
    {7393 , 1,"Гитара №4"                             ,700000},
    {7394 , 1,"Скейт №1"                              ,750000},
    {7395 , 1,"Скейт №2"                              ,750000},
    {790 ,  1,"Новогодний Дракон"                     ,4000000},
    {787 ,  2,"Маска Дракона"                         ,7000000},
    {9824 , 1,"Весёлая тыква"                         ,5000000},
    {9825 , 1,"Хеллоуинские ночи"                     ,3000000},
    {9827 , 1,"Кукла Вуду"                            ,5000000},
    {9828 , 1,"Призрачный портал"                     ,4000000},
    {11919, 2,"Акула на голову"                       ,6000000},
    {11923, 1,"Рюкзак Мопс на спину"                  ,5000000},
    {14589, 1,"Маска Оленя"                           ,6000000},
    {31949, 6,"Берет 80"                              ,13800000},
    {677  , 1,"Советская"                             ,100000},
    {676  , 2,"Очки"                                  ,13000000},
    {2655 , 1,"Шлем"                                  ,200000},
    {2656 , 1,"Надувной"                              ,11400000},
    {2657 , 2,"Очки"                                  ,6200000},
    {16055, 2,"Лапка"                                 ,700000},
    {9826 , 2,"Маска"                                 ,6600000},
    {11922, 1,"ГеймБой"                               ,7200000},
    {11925, 6,"Летняя доска"                          ,2800000},
    {13801, 6,"Катюша"                                ,4200000},
    {13803, 1,"Рюкзак"                                ,5200000},
    {14591, 2,"Белые рога"                            ,200000},
    {14592, 6,"Уши эльфа"                             ,1300000},
    {14596, 2,"Маска елочки"                          ,800000},
    {14597, 2,"Рождественские рога"                   ,2900000},
    {14598, 2,"Маска Деда Мороза"                     ,600000},
    {14603, 6,"Шапка-Ушанка"                          ,2900000},
    {4160 , 6,"Новогодний кекс"                       ,3100000},
    {4161 , 6,"Новогодний мишка"                      ,1100000},
    {4162 , 2,"Маска Снегурочка"                      ,6500000},
    {4163 , 2,"Маска Снеговика"                       ,200000},
    {4165 , 1,"Сумка Снеговика"                       ,12900000},
    {13883, 2,"Корона демона"                         ,100000},
    {18509, 6,"Кейс"                                  ,100000},
    {18510, 6,"Кейс черный"                           ,800000},
    {18511, 6,"Кейс серый"                            ,600000},
    {18512, 2,"Золотая корона"                        ,12300000},
    {18513, 2,"Корона короля"                         ,300000},
    {18514, 2,"Серебряная корона"                     ,4600000},
    {18515, 6,"Лавровый венец"                        ,800000},
    {18516, 2,"Диадема"                               ,500000},
    {18517, 2,"Очки Доллар"                           ,600000},
    {18518, 2,"Очки День рождения"                    ,300000},
    {18519, 2,"Праздничный колпак"                    ,600000},
    {18520, 2,"Неоновые очки"                         ,11200000},
    {18521, 2,"Неоновые очки"                         ,1500000},
    {18522, 2,"Неоновые очки"                         ,12300000},
    {18523, 2,"Неоновые очки"                         ,12100000},
    {18524, 2,"Неоновые очки"                         ,2200000},
    {18525, 2,"Неоновые очки"                         ,1300000},
    {18526, 2,"Очки пиксели"                          ,4900000},
    {18527, 2,"Шар"                                   ,3300000},
    {18528, 1,"Шар"                                   ,2900000},
    {18529, 1,"Шар"                                   ,8500000},
    {18530, 2,"Шар"                                   ,6200000},
    {18497, 2,"Шарик"                                 ,800000},
    {18498, 2,"Очки 'Выпуклые глаза'"                 ,600000},
    {18499, 2,"Очки 'Обычные глаза'"                  ,100000},
    {18500, 2,"Маска клоуна"                          ,1600000},
    {18501, 2,"Маска клоуна"                          ,3300000},
    {18502, 2,"Лицо тролля"                           ,2400000},
    {18503, 6,"Инопланетянин"                         ,4500000},
    {18504, 2,"Тролль с париком"                      ,14300000},
    {18505, 6,"Инопланетянин с париком"               ,14500000},
    {18506, 2,"Очки с носом"                          ,100000},
    {18507, 1,"Нос клоуна"                            ,10700000},
    {18508, 1,"Парик клоуна"                          ,100000},
    {18233, 1,"Деревянный"                            ,1600000},
    {18232, 6,"Берет"                                 ,900000},
    {18243, 2,"Карамельная конфета"                   ,600000},
    {18250, 1,"Белая панама"                          ,6900000},
    {18383, 6,"Черная панама"                         ,6900000},
    {18384, 6,"Серая панама"                          ,2500000},
    {18385, 2,"Темная панама"                         ,3000000},
    {18263, 6,"Белая панама"                          ,5500000},
    {18264, 6,"Черная панама"                         ,13000000},
    {18273, 2,"Высокая панама"                        ,600000},
    {18279, 2,"Черная шапка"                          ,100000},
    {18285, 6,"Посох-зонт"                            ,1800000},
    {18286, 2,"Кандибобер"                            ,1600000},
    {18346, 6,"Синий посох"                           ,10400000},
    {18347, 6,"Синий посох"                           ,2300000},
    {18348, 6,"Голубой посох"                         ,7100000},
    {18369, 2,"Новогодний топорик"                    ,1300000},
    {18375, 6,"Новогодняя палочка"                    ,2100000},
    {18378, 1,"Рюкзак 'Котик'"                        ,5300000},
    {18379, 1,"Рюкзак 'Санта-Клауса'"                 ,11800000},
    {18410, 2,"Очки"                                  ,1500000},
    {18411, 6,"Голубой посох"                         ,100000},
    {18412, 2,"Очки"                                  ,1000000},
    {18414, 2,"Прямые очки"                           ,4200000},
    {15158, 6,"Кепка"                                 ,2800000},
    {15154, 2,"Неоновая маска"                        ,9900000},
    {15155, 2,"Неоновая маска"                        ,2200000},
    {15157, 1,"Рюкзак"                                ,6500000},
    {15148, 2,"Маска Дали"                            ,900000},
    {15160, 2,"Маска круга"                           ,9300000},
    {15161, 2,"Маска треугольника"                    ,200000},
    {15159, 2,"Маска квадрата"                        ,8400000}
};

stock ConvertMoneyACS(money, string[], length = sizeof string)
{
    format(string, length, "%d", money < 0 ? -money : money);
    for(new i = strlen(string); (i -= 3) > 0;)
    {
        if(string[i] != '\0' && '0' <= string[i] <= '9')
        {
            strins(string, ".", i, length);
        }
        else
        {
            return;
        }
    }
    if(money < 0)
    {
        strins(string, "-", 0, length);
    }
}

stock CreatePlTDButtonBR(playerid)
{
    acsmagaz_price_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 319.7778, 373.6799, "100.000_p."); // пусто
    PlayerTextDrawLetterSize(playerid, acsmagaz_price_PTD[playerid][0], 0.2531, 1.3509);
    PlayerTextDrawTextSize(playerid, acsmagaz_price_PTD[playerid][0], 0.0000, -17.0000);
    PlayerTextDrawAlignment(playerid, acsmagaz_price_PTD[playerid][0], 2);
    PlayerTextDrawColor(playerid, acsmagaz_price_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, acsmagaz_price_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, acsmagaz_price_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, acsmagaz_price_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, acsmagaz_price_PTD[playerid][0], 1);
    create_player_btn[playerid] = true;
    return 1;
}

stock CreateTextDrawButtonBR()
{
    acsmagaz_button_TD[0] = TextDrawCreate(69.0000, 202.0000, "txd:brrainleft"); // влево
    TextDrawTextSize(acsmagaz_button_TD[0], 27.0000, 43.0000);
    TextDrawAlignment(acsmagaz_button_TD[0], 1);
    TextDrawColor(acsmagaz_button_TD[0], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[0], 255);
    TextDrawFont(acsmagaz_button_TD[0], 4);
    TextDrawSetProportional(acsmagaz_button_TD[0], 0);
    TextDrawSetShadow(acsmagaz_button_TD[0], 0);
    TextDrawSetSelectable(acsmagaz_button_TD[0], true);

    acsmagaz_button_TD[1] = TextDrawCreate(542.0000, 202.0000, "txd:brrainright"); // вправо
    TextDrawTextSize(acsmagaz_button_TD[1], 27.0000, 43.0000);
    TextDrawAlignment(acsmagaz_button_TD[1], 1);
    TextDrawColor(acsmagaz_button_TD[1], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[1], 255);
    TextDrawFont(acsmagaz_button_TD[1], 4);
    TextDrawSetProportional(acsmagaz_button_TD[1], 0);
    TextDrawSetShadow(acsmagaz_button_TD[1], 0);
    TextDrawSetSelectable(acsmagaz_button_TD[1], true);

    acsmagaz_button_TD[2] = TextDrawCreate(234.7776, 371.0354, "txd:brtuning4nstage2"); // фон для текста
    TextDrawTextSize(acsmagaz_button_TD[2], 171.0000, 21.0000);
    TextDrawAlignment(acsmagaz_button_TD[2], 1);
    TextDrawColor(acsmagaz_button_TD[2], -12705281);
    TextDrawBackgroundColor(acsmagaz_button_TD[2], 255);
    TextDrawFont(acsmagaz_button_TD[2], 4);
    TextDrawSetProportional(acsmagaz_button_TD[2], 0);
    TextDrawSetShadow(acsmagaz_button_TD[2], 0);

    acsmagaz_button_TD[3] = TextDrawCreate(240.4443, 384.0000, "txd:braucubuy"); // купить
    TextDrawTextSize(acsmagaz_button_TD[3], 78.0000, 58.0000);
    TextDrawAlignment(acsmagaz_button_TD[3], 1);
    TextDrawColor(acsmagaz_button_TD[3], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[3], 255);
    TextDrawFont(acsmagaz_button_TD[3], 4);
    TextDrawSetProportional(acsmagaz_button_TD[3], 0);
    TextDrawSetShadow(acsmagaz_button_TD[3], 0);
    TextDrawSetSelectable(acsmagaz_button_TD[3], true);

    acsmagaz_button_TD[4] = TextDrawCreate(320.2221, 382.5065, "txd:braucexit"); // выход
    TextDrawTextSize(acsmagaz_button_TD[4], 83.0000, 60.0000);
    TextDrawAlignment(acsmagaz_button_TD[4], 1);
    TextDrawColor(acsmagaz_button_TD[4], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[4], 255);
    TextDrawFont(acsmagaz_button_TD[4], 4);
    TextDrawSetProportional(acsmagaz_button_TD[4], 0);
    TextDrawSetShadow(acsmagaz_button_TD[4], 0);
    TextDrawSetSelectable(acsmagaz_button_TD[4], true);

    return 1;
}


public OnPlayerSpawn(playerid)
{
    LoadAccessory(playerid);
    #if defined name_OnPlayerSpawn
        return name_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn name_OnPlayerSpawn
#if defined name_OnPlayerSpawn
    forward name_OnPlayerSpawn(playerid);
#endif


public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == acsmagaz_button_TD[1]) //вперед
    {
        new acs = pl_accessory[playerid];
        if(acs < sizeof accessory-1)
        {
            DestroyPlayerObject(playerid, pl_id_accessory[playerid]);

            pl_id_accessory[playerid] = CreatePlayerObject(playerid, accessory[acs+1][ID_ACCESSORY], 
            2899.104980,1503.386230,2499.062500, 0.0, 0.0, 0.0);

            pl_accessory[playerid] = acs+1;
            SetPriceAccesory(playerid, acs+1);
        }
    }
    if(clickedid == acsmagaz_button_TD[0]) //назад
    {
        new acs = pl_accessory[playerid];
        if(acs > 0)
        {
            DestroyPlayerObject(playerid, pl_id_accessory[playerid]);

            pl_id_accessory[playerid] = CreatePlayerObject(playerid, accessory[acs-1][ID_ACCESSORY], 
            2899.104980,1503.386230,2499.062500, 0.0, 0.0, 0.0);

            pl_accessory[playerid] = acs-1;

            SetPriceAccesory(playerid, acs-1);
        }
    }
    if(clickedid == acsmagaz_button_TD[4]) //выход
    {
        DestroyPlayerObject(playerid, pl_id_accessory[playerid]);
        pl_id_accessory[playerid] = -1;

        pl_accessory[playerid] = -1;

        for(new i;i < sizeof acsmagaz_button_TD;i++) TextDrawHideForPlayer(playerid, acsmagaz_button_TD[i]);
        PlayerTextDrawHide(playerid, acsmagaz_price_PTD[playerid][0]);

        new in_biz = GetPlayerInBiz(playerid);
        SetPlayerPosEx
        (
            playerid,
            GetBusinessData(in_biz, B_EXIT_POS_X),
            GetBusinessData(in_biz, B_EXIT_POS_Y),
            GetBusinessData(in_biz, B_EXIT_POS_Z),
            GetBusinessData(in_biz, B_EXIT_ANGLE),
            0,
            0
        );
        SetPlayerInBiz(playerid, -1);
        CancelSelectTextDraw(playerid);
        TogglePlayerControllable(playerid, 1);
        ShowHud(playerid);

        SetPlayerCleanChat(playerid, false);
    }
    if(clickedid == acsmagaz_button_TD[3]) // купить
    {
        new acs = pl_accessory[playerid], price = accessory[acs][PRICE_ACCESSORY], query[128], biz_price = price * 20 / 100;
        if(GetPlayerMoneyEx(playerid) >= price)
        {
            new businessid = GetPlayerInBiz(playerid), take_prods = random(4) + 6;
            if(GetBusinessData(businessid, B_PRODS) >= take_prods)
            {
                format(query, sizeof query, "UPDATE business SET products=%d, balance=%d WHERE id=%d", GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+biz_price, GetBusinessData(businessid, B_SQL_ID));
                mysql_query(mysql, query, false);
            }

            if(!mysql_errno())
            {
                if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                {
                    AddBusinessData(businessid, B_PRODS, -, take_prods);
                    AddBusinessData(businessid, B_BALANCE, +, biz_price);
                }

                mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
                mysql_query(mysql, query, false);
                GivePlayerMoneyEx(playerid, -price);
                

                GiveAccessory(playerid, acs);
            }
        }
        else SendClientMessage(playerid, -1, "У вас недостаточно денег.");

    }
	if(clickedid == acss_fix_TD[1])
	{
	    for(new i; i < sizeof acss_fix_TD; i++)
	    {
	    	TextDrawHideForPlayer(playerid, acss_fix_TD[i]);
		}

        SetPlayerCleanChat(playerid, false);

		DeletePVar(playerid, "acs_use");
		DeletePVar(playerid, "acss_fix_TD_use");
		DeletePVar(playerid, "slot");
		DeletePVar(playerid, "acs_id");
		DeletePVar(playerid, "bone");

		DeletePVar(playerid, "edit_y");
		DeletePVar(playerid, "edit_z");
		DeletePVar(playerid, "edit_x");
		DeletePVar(playerid, "edit_rX");
		DeletePVar(playerid, "edit_rY");
		DeletePVar(playerid, "edit_rZ");
		DeletePVar(playerid, "edit_scale");

		PlayerTextDrawHide(playerid, acss_coords_fix_PTD[playerid][0]);
        CancelSelectTextDraw(playerid);
        
		TogglePlayerControllable(playerid, true);
		TogglePlayerAllHudElements(playerid, HUD_ELEMENT_SHOW);
	}
	if(clickedid == acss_fix_TD[2])
	{
		for(new i; i < sizeof acss_fix_TD; i++)
	    {
	    	TextDrawHideForPlayer(playerid, acss_fix_TD[i]);
		}

        SetPlayerCleanChat(playerid, false);

		new query[220], Cache: result;

        format
        (
            query, sizeof query,
            "UPDATE accessories_players SET acs_id=%d, bone=%d, x=%f, y=%f, z=%f, rX=%f, rY=%f, rZ=%f, scale=%f WHERE player_id=%d AND slot=%d",
            GetPVarInt(playerid, "acs_id"),
            GetPVarInt(playerid, "bone"),
            GetPVarFloat(playerid, "edit_x"),
            GetPVarFloat(playerid, "edit_y"),
            GetPVarFloat(playerid, "edit_z"),
            GetPVarFloat(playerid, "edit_rX"),
            GetPVarFloat(playerid, "edit_rY"),
            GetPVarFloat(playerid, "edit_rZ"),
            GetPVarFloat(playerid, "edit_scale"),
            GetPlayerAccountID(playerid),
            GetPVarInt(playerid, "slot")
        );

		result = mysql_query(mysql, query, true);

		cache_delete(result);

		DeletePVar(playerid, "acs_use");
		DeletePVar(playerid, "acss_fix_TD_use");
		DeletePVar(playerid, "slot");
		DeletePVar(playerid, "acs_id");
		DeletePVar(playerid, "bone");

		DeletePVar(playerid, "edit_y");
		DeletePVar(playerid, "edit_z");
		DeletePVar(playerid, "edit_x");
		DeletePVar(playerid, "edit_rX");
		DeletePVar(playerid, "edit_rY");
		DeletePVar(playerid, "edit_rZ");
		DeletePVar(playerid, "edit_scale");

		PlayerTextDrawHide(playerid, acss_coords_fix_PTD[playerid][0]);
        CancelSelectTextDraw(playerid);

		TogglePlayerControllable(playerid, true);
		TogglePlayerAllHudElements(playerid, HUD_ELEMENT_SHOW);
		SendClientMessage(playerid, -1, "Аксессуар успешно сохранен.");
		ShowHud(playerid);
	}
	if(acss_fix_TD[3] <= clickedid <= acss_fix_TD[9])
	{
		new TD;
		for(new i = 3; i < 10;i++) if(clickedid == acss_fix_TD[i]) TD = i;
		new td_use = GetPVarInt(playerid, "acss_fix_TD_use"), count_TD = TD - 3, Float:float_count;
		TextDrawHideForPlayer(playerid, acss_fix_TD[9 + td_use]);
		TextDrawShowForPlayer(playerid, acss_fix_TD[2 + td_use]);
		TextDrawHideForPlayer(playerid, acss_fix_TD[16 + td_use]);
		TextDrawHideForPlayer(playerid, acss_fix_TD[3 + count_TD]);
		TextDrawShowForPlayer(playerid, acss_fix_TD[10 + count_TD]);
		TextDrawShowForPlayer(playerid, acss_fix_TD[17 + count_TD]);
		SetPVarInt(playerid, "acss_fix_TD_use", count_TD+1);

		switch(TD)
		{
			case 3:float_count = GetPVarFloat(playerid, "edit_x");
			case 4:float_count = GetPVarFloat(playerid, "edit_y");
			case 5:float_count = GetPVarFloat(playerid, "edit_z");
			case 6:float_count = GetPVarFloat(playerid, "edit_scale");
			case 7:float_count = GetPVarFloat(playerid, "edit_rX");
			case 8:float_count = GetPVarFloat(playerid, "edit_rY");
			case 9:float_count = GetPVarFloat(playerid, "edit_rZ");
		}
		
		new acs_coords[11];
		format(acs_coords, sizeof acs_coords, "%f", float_count);
		PlayerTextDrawSetString(playerid, acss_coords_fix_PTD[playerid][0], acs_coords);
	}
	if(clickedid == acss_fix_TD[24] || clickedid == acss_fix_TD[25])
	{
		new Float: x, Float: y, Float: z, Float: scale, Float: Rx, Float: Ry, Float: Rz, acs_coords[11];

		switch(GetPVarInt(playerid, "acss_fix_TD_use"))
	    {
	        case 1:
	        {
				//-влево/вправо
				if(clickedid == acss_fix_TD[24])
				{
					if(GetPVarFloat(playerid, "edit_x") >= 0.500000) return 1;
	        		x += 0.01;
				}
				else
				{
				    if(GetPVarFloat(playerid, "edit_x") <= -0.500000) return 1;
				    x -= 0.01;
				}

				format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "edit_x") + x);
	        }
			case 2:
			{
				//-вверх/вниз
				if(clickedid == acss_fix_TD[24])
				{
					if(GetPVarFloat(playerid, "edit_y") >= 1.000000) return 1;
					y += 0.01;
				}
				else
				{
					if(GetPVarFloat(playerid, "edit_y") <= -1.000000) return 1;
					y -= 0.01;
				}

				format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "edit_y") + y);
			}
			case 3:
			{
			    //-от себя/на себя
			    if(clickedid == acss_fix_TD[24])
				{
					if(GetPVarFloat(playerid, "edit_z") >= 0.500000) return 1;
					z += 0.01;
				}
				else
				{
					if(GetPVarFloat(playerid, "edit_z") <= -0.500000) return 1;
					z -= 0.01;
				}

				format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "edit_z") + z);
			}
			case 4:
			{
			    //-масштаб
			    if(clickedid == acss_fix_TD[24])
				{
					if(GetPVarFloat(playerid, "edit_scale") >= 2.000000) return 1;
					scale += 0.1;
				}
				else
				{
					if(GetPVarFloat(playerid, "edit_scale") <= 0.100000) return 1;
					scale -= 0.1;
				}

			    format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "edit_scale") + scale);
			}
			case 5:
			{
			    //-поворот по X
			    if(clickedid == acss_fix_TD[24])
				{
					if(GetPVarFloat(playerid, "edit_rX") >= 360.000000) SetPVarFloat(playerid, "edit_rX", -5.000000);
					Rx += 5.0;
				}
				else
				{
					if(GetPVarFloat(playerid, "edit_rX") <= -360.000000) SetPVarFloat(playerid, "edit_rX", 5.000000);
					Rx -= 5.0;
				}

			    format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "edit_rX") + Rx);
			}
			case 6:
			{
				//-поворот по Y
				if(clickedid == acss_fix_TD[24])
				{
					if(GetPVarFloat(playerid, "edit_rY") >= 360.000000) SetPVarFloat(playerid, "edit_rY", -5.000000);
					Ry += 5.0;
				}
				else
				{
					if(GetPVarFloat(playerid, "edit_rY") <= -360.000000) SetPVarFloat(playerid, "edit_rY", 5.000000);
					Ry -= 5.0;
				}

			    format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "edit_rY") + Ry);
			}
			case 7:
			{
				//-поворот по Z
				if(clickedid == acss_fix_TD[24])
				{
					if(GetPVarFloat(playerid, "edit_rZ") >= 360.000000) SetPVarFloat(playerid, "edit_rZ", -5.000000);
					Rz += 5.0;
				}
				else
				{
					if(GetPVarFloat(playerid, "edit_rZ") <= -360.000000) SetPVarFloat(playerid, "edit_rZ", 5.000000);
					Rz -= 5.0;
				}

			    format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "edit_rZ") + Rz);
			}
	    }

		PlayerTextDrawHide(playerid, acss_coords_fix_PTD[playerid][0]);
		PlayerTextDrawSetString(playerid, acss_coords_fix_PTD[playerid][0], acs_coords);
		PlayerTextDrawShow(playerid, acss_coords_fix_PTD[playerid][0]);

		SetPVarFloat(playerid, "edit_x", GetPVarFloat(playerid, "edit_x") + x);
		SetPVarFloat(playerid, "edit_y", GetPVarFloat(playerid, "edit_y") + y);
		SetPVarFloat(playerid, "edit_z", GetPVarFloat(playerid, "edit_z") + z);
		SetPVarFloat(playerid, "edit_rX", GetPVarFloat(playerid, "edit_rX") + Rx);
		SetPVarFloat(playerid, "edit_rY", GetPVarFloat(playerid, "edit_rY") + Ry);
		SetPVarFloat(playerid, "edit_rZ", GetPVarFloat(playerid, "edit_rZ") + Rz);
		SetPVarFloat(playerid, "edit_scale", GetPVarFloat(playerid, "edit_scale") + scale);

		SetPlayerAttachedObject
		(
			playerid,
			GetPVarInt(playerid, "slot"),
			accessory[GetPVarInt(playerid, "acs_id")][ID_ACCESSORY],
			GetPVarInt(playerid, "bone"),
			GetPVarFloat(playerid, "edit_x"),
			GetPVarFloat(playerid, "edit_y"),
			GetPVarFloat(playerid, "edit_z"),
			GetPVarFloat(playerid, "edit_rX"),
			GetPVarFloat(playerid, "edit_rY"),
			GetPVarFloat(playerid, "edit_rZ"),
			GetPVarFloat(playerid, "edit_scale"),
			GetPVarFloat(playerid, "edit_scale"),
			GetPVarFloat(playerid, "edit_scale")
		);
	}
    #if defined btn_OnPlayerClickTextDraw
        return btn_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw btn_OnPlayerClickTextDraw
#if defined btn_OnPlayerClickTextDraw
    forward btn_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

public OnGameModeInit()
{
    print("[W_SYSTEM] Система аксессуаров загружена.");
    CreateTextDrawButtonBR();
	CreateEditAccessoryTD();
	SetTimer("CREATE_TABLIST_ACCESSORY", 4500, false);
    #if defined acs_OnGameModeInit
        return acs_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit acs_OnGameModeInit
#if defined acs_OnGameModeInit
    forward acs_OnGameModeInit();
#endif

stock EntryAccessoryMarket(playerid)
{
    pl_accessory[playerid] = 0;
    SetPlayerPosEx(playerid, 2896.610839,1496.067871,2499.343750,355.015014, 1, playerid+1);
    HideHud(playerid);
    TogglePlayerControllable(playerid, false);

   // SetPlayerCameraLookAt(playerid, 2899.593261,1499.915283,2499.343750);

    for(new a;a < 12;a++)  SendClientMessage(playerid, 0xFFFFFFFF, "");
    
    InterpolateCameraPos(playerid, 2901.951660,1498.124877,2499.343750, 2900.450927,1500.220703,2499.363750, 2000, CAMERA_MOVE);
    InterpolateCameraLookAt(playerid, 2903.739257,1499.161499,2499.343750, 2899.104980,1503.386230,2499.562500, 2000, CAMERA_MOVE);

    pl_id_accessory[playerid] = CreatePlayerObject(playerid, accessory[0][ID_ACCESSORY], 2899.104980,1503.386230,2499.062500, 0.0, 0.0, 0.0);
        
    CreatePlTDButtonBR(playerid);

    SetPriceAccesory(playerid, 0);
	TogglePlayerControllable(playerid, 0);

    SelectTextDraw(playerid, 0xFF5252FF);
    for(new i;i < sizeof acsmagaz_button_TD;i++) TextDrawShowForPlayer(playerid, acsmagaz_button_TD[i]);
    PlayerTextDrawShow(playerid, acsmagaz_price_PTD[playerid][0]);

    new Float:x, Float:y, Float:z, string[124];
    GetPlayerCameraPos(playerid, x, y, z);
    TogglePlayerControllable(playerid, false);
    return 1;
}

stock SetPriceAccesory(playerid, acs)
{
    new string[24], moneyStringAcs[15];

    ConvertMoney(accessory[acs][PRICE_ACCESSORY], moneyStringAcs);
    format(string, sizeof string, "%s_p.", moneyStringAcs);
    PlayerTextDrawSetString(playerid, acsmagaz_price_PTD[playerid][0], string);

    return 1;
}


stock myacs(playerid)
{
    new fmt_text[2048],
        Cache: result,
        id;

    mysql_format(mysql, fmt_text, sizeof(fmt_text), "SELECT * FROM accessory_inventory WHERE player_id='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);

    new rows = cache_num_rows();

    if(!rows) 
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "У вас нет аксессуаров!", "");
        cache_delete(result);
        return 1;
    }
    
    new query[128],
        acs, use, acs_use[70];

    format(fmt_text, sizeof(fmt_text), "№\tНазвание\tСтатус\n");

    for(new i = 0; i < rows; i++)
    {
        id = cache_get_field_content_int(i, "id");
        acs = cache_get_field_content_int(i, "acs_id");
        use = cache_get_field_content_int(i, "use");

        if(use > 0) 
            format(acs_use, sizeof(acs_use), "{8EF674}[ надет ]");
        else 
            format(acs_use, sizeof(acs_use), "{BEBEBE}[ можно надеть ]");

        format(query, sizeof(query), "{CA5757}%d\t{FFD700}%s\t%s\n",
            i + 1, 
            accessory[acs][NAME_ACCESSORY], 
            acs_use
        );
        strcat(fmt_text, query);
        
        SetPlayerListitemValue(playerid, i, id);

        format(query, sizeof(query), "acsuse%d", i);
        SetPVarInt(playerid, query, use);
    }

    Dialog(playerid, 1190, DIALOG_STYLE_TABLIST_HEADERS,
        "{CA5757}BEST RUSSIA {FFFFFF}| Выберите акссесуар из списка ниже",
        fmt_text,
        "Выбрать", "Закрыть"
    );

    cache_delete(result);

    return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
if(dialogid == 1190)
{
    if(response)
    {
        new idx = GetPlayerListitemValue(playerid, listitem), string[24];
        SetPVarInt(playerid, "acs_id_sql", idx);

        format(string, sizeof string, "acsuse%d", listitem);

        if(!GetPVarInt(playerid, string))
        {
            Dialog
            (
                playerid, 1191, DIALOG_STYLE_TABLIST_HEADERS,
                "{CA5757}Управление аксессуаром {FFFFFF}| Выберите действие",
                "№\tДействие\tТип\tСтатус\n"\
                "{CA5757}1\t{FFFFFF}Использовать\t{FFFFFF}Надеть\t{8EF674}Доступно\n"\
                "{CA5757}2\t{FFFFFF}Продать игроку\t{FFFFFF}Обмен\t{8EF674}Доступно\n"\
                "{CA5757}3\t{FFFFFF}Удалить\t{FFFFFF}Выбросить\t{CA5757}Не вернуть",
                "Выбрать", "Закрыть"
            );
            SetPVarInt(playerid, "acs_use", 0);
        }
        else
        {
            Dialog
            (
                playerid, 1191, DIALOG_STYLE_TABLIST_HEADERS,
                "{CA5757}Управление аксессуаром {FFFFFF}| Выберите действие",
                "№\tДействие\tТип\tСтатус\n"\
                "{CA5757}1\t{FFFFFF}Снять\t{FFFFFF}Снятие\t{8EF674}Доступно\n"\
                "{CA5757}1\t{FFFFFF}Редактировать\t{FFFFFF}Настройки\t{FFD700}Изменить",
                "Выбрать", "Закрыть"
            );
            SetPVarInt(playerid, "acs_use", 1);
        }
    }
}
    if(dialogid == 1191)
    {
        if(response)
        {
            new id = GetPVarInt(playerid, "acs_id_sql");
           if(!GetPVarInt(playerid, "acs_use"))
            {
                switch(listitem)
                {
                    case 0:UseAccessory(playerid, id);
                    case 1:SellAccessory(playerid, id);
                    case 2:DeleteAccessory(playerid, id);
                }
            } else{
                switch(listitem)
                {
                    case 0:TakeOffAccessory(playerid, id);
                    case 1:EditAccessory(playerid, id);
                }      
            }
        }
    }
    if(dialogid == 1192)
    {
        if(response)
        {
            new player, price;
            if(sscanf(inputtext, "P<,>dd", player, price)) return SendClientMessage(playerid, -1, "Вы не правильно ввели данные.");

            if(player == playerid || !IsPlayerLogged(player) || !IsPlayerConnected(player))
                return SendClientMessage(playerid, -1, "Данного игрока не существует.");

			if(price >= 1_000_000_000 || price <= -1) return SendClientMessage(playerid, -1, "Цена должна быть меньше 1.000.000.000 руб.");


            SetPVarInt(playerid, "owner_accept_acs_sql", GetPVarInt(playerid, "acs_id_sql"));
            SetPVarInt(playerid, "owner_accept_price", price);
            
   //         SendPlayerOffer(playerid, player, OFFER_TYPE_ACCESSORY);
        }
    }
    #if defined acs_OnDialogResponse
return acs_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse acs_OnDialogResponse
#if defined acs_OnDialogResponse
forward acs_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif



stock UseAccessory(playerid, database)
{
    new string[124], Cache:cache;

    mysql_format(mysql, string, sizeof string, "SELECT * FROM accessory_inventory WHERE id = %d", database);
    cache = mysql_query(mysql, string);

    new id_acs = cache_get_field_content_int(0, "acs_id"), bone = accessory[id_acs][BONE_ACCESSORY], slot; 
    
    switch(bone)
    {
        case 1:slot = 1;
        case 2:slot = 2;
        case 3:slot = 3;
        case 4:slot = 4;
        case 5:slot = 5;
        case 6:slot = 6;
        case 7:slot = 6;
        case 8:slot = 7;
        case 9:slot = 7;
        case 10:slot  = 8;
        case 11:slot  = 8;
        case 12:slot  = 9;
        case 13:slot  = 9;
    }

    cache_delete(cache);
    new rows;

    mysql_format(mysql, string, sizeof string, "SELECT * FROM accessories_players WHERE `player_id` = %d AND `slot` = %d", GetPlayerAccountID(playerid), slot);
    cache = mysql_query(mysql, string, true);


    
        mysql_format(mysql, string, sizeof string, "INSERT INTO accessories_players (player_id,slot,bone,acs_id) VALUES (%d,%d,%d,%d)", GetPlayerAccountID(playerid), slot, bone, id_acs);
        mysql_query(mysql, string, false);
		
        mysql_format(mysql, string, sizeof string, "UPDATE accessory_inventory SET `use` = 1 WHERE `id`=%d", database);
        mysql_query(mysql, string, false);
        SCM(playerid, -1, "Вы успешно надели аксессуар");
        new obj = accessory[id_acs][ID_ACCESSORY];
        SetPlayerAttachedObject(playerid, slot, obj, bone);
    

    cache_delete(cache);
    return 1;
}

stock TakeOffAccessory(playerid, database)
{
    new slot = -1, string[184];
	mysql_format(mysql, string, sizeof string, "SELECT * FROM accessory_inventory WHERE id = %d",database);
	new Cache:cache = mysql_query(mysql, string, true);

	new acs_id = cache_get_field_content_int(0, "acs_id");

	cache_delete(cache);
    if(!mysql_errno())
    {
        mysql_format(mysql, string, sizeof string, "SELECT slot FROM accessories_players WHERE player_id = %d AND acs_id = %d", GetPlayerAccountID(playerid), acs_id);
        cache = mysql_query(mysql, string, true);

        if(cache_num_rows()) slot = cache_get_row_int(0, 0);

        cache_delete(cache);

        mysql_format(mysql, string, sizeof string, "DELETE FROM accessories_players WHERE player_id = %d AND acs_id = %d", GetPlayerAccountID(playerid), acs_id);
        mysql_query(mysql, string, false);

		mysql_format(mysql, string, sizeof string, "UPDATE accessory_inventory SET `use` = 0 WHERE `id`=%d", database);
    	mysql_query(mysql, string, false);


        if(slot != -1)
        {           
            RemovePlayerAttachedObject(playerid, slot);
            ShowNewNotification(playerid, 3, 6, 0, 0, "Аксессуар снят", "");
        }
    }

    return 1;
}

stock SellAccessory(playerid, database)
{
    new string[124], Cache:cache;

    mysql_format(mysql,string, sizeof string, "SELECT acs_id FROM accessory_inventory WHERE id = %d", database);
    cache = mysql_query(mysql, string);

    SetPVarInt(playerid, "acs_id", cache_get_row_int(0, 0));

    cache_delete(cache);

    Dialog(
        playerid, 1192, DIALOG_STYLE_INPUT, 
        "{FF0000}Введите данные",
        "Напишите ID-игрока и цену за аксессуар\n"\
        "Пример: 0, 100000 (id, цена)\n"\
        "\nЕсли вы хотите передать — пишите цену «0»",
        "Далее", "Выйти"
    );
    
    return 1;
}

stock DeleteAccessory(playerid, database)
{
    new string[124], Cache:cache;

    mysql_format(mysql,string, sizeof string, "DELETE FROM accessory_inventory WHERE id = %d", database);
    mysql_query(mysql, string, false);

    if(!mysql_errno()) SendClientMessage(playerid, -1, "Аксессуар удалён.");
    else SendClientMessage(playerid, -1, "Ошибка в удалении аксессуара");

    return 1;
}

stock EditAccessory(playerid, database)
{
    new query[220], rows, Cache: result;

    for(new a;a < 12;a++)  SendClientMessage(playerid, 0xFFFFFFFF, "");
    SetPlayerCleanChat(playerid, true);

	format(query, sizeof query, "SELECT acs_id FROM accessory_inventory WHERE id=%d", database);
	result = mysql_query(mysql, query, true);

	new acs_id = cache_get_row_int(0, 0);

	cache_delete(result);

	format(query, sizeof query, "SELECT * FROM accessories_players WHERE player_id=%d AND acs_id=%d", GetPlayerAccountID(playerid), acs_id);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		new 
		bone = cache_get_field_content_int(0, "bone"),
		slot = cache_get_field_content_int(0, "slot"),
		Float: x =  cache_get_field_content_float(0, "x"),
		Float: y =  cache_get_field_content_float(0, "y"),
		Float: z =  cache_get_field_content_float(0, "z"),
		Float: rX = cache_get_field_content_float(0, "rX"),
		Float: rY = cache_get_field_content_float(0, "rY"),
		Float: rZ = cache_get_field_content_float(0, "rZ"),
		Float: scale =  cache_get_field_content_float(0, "scale");

       	SetPVarInt(playerid, "slot", slot);
		SetPVarInt(playerid, "acs_id", acs_id);
		SetPVarInt(playerid, "bone", bone);
		SetPVarFloat(playerid, "edit_y", y);
		SetPVarFloat(playerid, "edit_z", z);
		SetPVarFloat(playerid, "edit_x", x);
		SetPVarFloat(playerid, "edit_rX", rX);
		SetPVarFloat(playerid, "edit_rY", rY);
		SetPVarFloat(playerid, "edit_rZ", rZ);
		SetPVarFloat(playerid, "edit_scale", scale);

		RemovePlayerAttachedObject(playerid, slot);

		SetPlayerAttachedObject
		(
			playerid,
			GetPVarInt(playerid, "slot"),
			accessory[GetPVarInt(playerid, "acs_id")][ID_ACCESSORY],
			GetPVarInt(playerid, "bone"),
			GetPVarFloat(playerid, "edit_x"),
			GetPVarFloat(playerid, "edit_y"),
   			GetPVarFloat(playerid, "edit_z"),
      		GetPVarFloat(playerid, "edit_rX"),
			GetPVarFloat(playerid, "edit_rY"),
			GetPVarFloat(playerid, "edit_rZ"),
			GetPVarFloat(playerid, "edit_scale"),
			GetPVarFloat(playerid, "edit_scale"),
			GetPVarFloat(playerid, "edit_scale")
		);

		SelectTextDraw(playerid, -1);

		for(new i; i < 11; i ++) TextDrawShowForPlayer(playerid, acss_fix_TD[i]);
		TextDrawShowForPlayer(playerid, acss_fix_TD[17]);
		TextDrawShowForPlayer(playerid, acss_fix_TD[24]);
		TextDrawShowForPlayer(playerid, acss_fix_TD[25]);

		new acs_coords[18];
		format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "edit_x"));

		acss_coords_fix_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 521.3996, 292.8998, acs_coords);
		PlayerTextDrawLetterSize(playerid, acss_coords_fix_PTD[playerid][0], 0.3000, 1.6000);
		PlayerTextDrawAlignment(playerid, acss_coords_fix_PTD[playerid][0], 2);
		PlayerTextDrawColor(playerid, acss_coords_fix_PTD[playerid][0], 0xFFFFFFFF);
		PlayerTextDrawBackgroundColor(playerid, acss_coords_fix_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, acss_coords_fix_PTD[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, acss_coords_fix_PTD[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, acss_coords_fix_PTD[playerid][0], 0);

		PlayerTextDrawShow(playerid, acss_coords_fix_PTD[playerid][0]);

		SetPVarInt(playerid, "acss_fix_TD_use", 1);
		// TogglePlayerControllable(playerid, false); фу не удобно ыелси жепете кодер
		TogglePlayerAllHudElements(playerid, HUD_ELEMENT_HIDE);
        TogglePlayerControllable(playerid, true);
		TogglePlayerControllable(playerid, 0);
        //SetPlayerFrozen(playerid, true);
	}

	cache_delete(result);
}

stock GiveAccessory(playerid, acs)
{
    new string[178];

    mysql_format(mysql, string, sizeof string, "INSERT INTO accessory_inventory (player_id, acs_id) VALUES (%d, %d)", GetPlayerAccountID(playerid), acs);
    mysql_query(mysql, string, false);
    
    if(!mysql_errno())
    {
        format(string, sizeof string, "Получен {FFFF00}«%s»", accessory[acs][NAME_ACCESSORY]);
        ShowNewNotification(playerid, 3, 6, 0, 0, string, "");
    }
    return 1;
}

public:LoadAccessory(playerid)
{
	new query[220], rows, Cache: result;

	format(query, sizeof query, "SELECT * FROM accessories_players WHERE player_id= %d", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

    if(rows)
    {
        new slot, acs, bone, Float:x, Float:y, Float:z, 
        Float:rZ, Float:rY, Float:rX, Float:scale;

        for(new i; i < rows; i++)
        {
            slot = cache_get_field_content_int(i, "slot"),
            acs = cache_get_field_content_int(i, "acs_id"),
            bone = cache_get_field_content_int(i, "bone"),
            Float: x = cache_get_field_content_float(i, "x"),
            Float: y = cache_get_field_content_float(i, "y"),
            Float: z = cache_get_field_content_float(i, "z"),
            Float: rX = cache_get_field_content_float(i, "rX"),
            Float: rY = cache_get_field_content_float(i, "rY"),
            Float: rZ = cache_get_field_content_float(i, "rZ"),
            Float: scale = cache_get_field_content_float(i, "scale");

            SetPlayerAttachedObject(playerid, slot, accessory[acs][ID_ACCESSORY], bone, x, y, z, rX, rY, rZ, scale, scale, scale);
        }
    }

	cache_delete(result);

    return 1;
}


stock CreateEditAccessoryTD()//автор редактора не welsi
{
    	//ТЕКСТ  "РЕЖИМ КАСТОМИЗАЦИЙ"
	acss_fix_TD[0] = TextDrawCreate(35.0000, 18.0000, "txd:bracstext");
	TextDrawTextSize(acss_fix_TD[0], 127.0000, 45.0000);
	TextDrawAlignment(acss_fix_TD[0], 1);
	TextDrawColor(acss_fix_TD[0], -1);
	TextDrawBackgroundColor(acss_fix_TD[0], 255);
	TextDrawFont(acss_fix_TD[0], 4);

	//КНОПКА "ВЫХОД"
	acss_fix_TD[1] = TextDrawCreate(600.0000, 0.1, "txd:bracsbtnexit");
	TextDrawTextSize(acss_fix_TD[1], 45.0000, 50.0000);
	TextDrawAlignment(acss_fix_TD[1], 1);
	TextDrawColor(acss_fix_TD[1], -1);
	TextDrawBackgroundColor(acss_fix_TD[1], 255);
	TextDrawFont(acss_fix_TD[1], 4);
	TextDrawSetSelectable(acss_fix_TD[1], true);

	//КНОПКА "СОХРАНИТЬ"
	acss_fix_TD[2] = TextDrawCreate(453.0000, 355.0000, "txd:bracssave");
	TextDrawTextSize(acss_fix_TD[2], 130.0000, 40.0000);
	TextDrawAlignment(acss_fix_TD[2], 1);
	TextDrawColor(acss_fix_TD[2], -1);
	TextDrawBackgroundColor(acss_fix_TD[2], 255);
	TextDrawFont(acss_fix_TD[2], 4);
	TextDrawSetSelectable(acss_fix_TD[2], true);

//-НЕ НАЖАТЫЕ КНОПКИ
   	//КНОПКА "ВЛЕВО/ВПРАВО"
	acss_fix_TD[3] = TextDrawCreate(35.0000, 65.0000, "txd:bracsn1");
	TextDrawTextSize(acss_fix_TD[3], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[3], 1);
	TextDrawColor(acss_fix_TD[3], -1);
	TextDrawBackgroundColor(acss_fix_TD[3], 255);
	TextDrawFont(acss_fix_TD[3], 4);
	TextDrawSetSelectable(acss_fix_TD[3], true);

	//КНОПКА "ВВЕРХ/ВНИЗ"
	acss_fix_TD[4] = TextDrawCreate(35.0000, 110.0000, "txd:bracsn2");
	TextDrawTextSize(acss_fix_TD[4], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[4], 1);
	TextDrawColor(acss_fix_TD[4], -1);
	TextDrawBackgroundColor(acss_fix_TD[4], 255);
	TextDrawFont(acss_fix_TD[4], 4);
	TextDrawSetSelectable(acss_fix_TD[4], true);

	//КНОПКА "ОТ СЕБЯ/НА СЕБЯ"
	acss_fix_TD[5] = TextDrawCreate(35.0000, 155.0000, "txd:bracsn3");
	TextDrawTextSize(acss_fix_TD[5], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[5], 1);
	TextDrawColor(acss_fix_TD[5], -1);
	TextDrawBackgroundColor(acss_fix_TD[5], 255);
	TextDrawFont(acss_fix_TD[5], 4);
	TextDrawSetSelectable(acss_fix_TD[5], true);

	//КНОПКА "МАСШТАБ"
	acss_fix_TD[6] = TextDrawCreate(35.0000, 200.0000, "txd:bracsn4");
	TextDrawTextSize(acss_fix_TD[6], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[6], 1);
	TextDrawColor(acss_fix_TD[6], -1);
	TextDrawBackgroundColor(acss_fix_TD[6], 255);
	TextDrawFont(acss_fix_TD[6], 4);
	TextDrawSetSelectable(acss_fix_TD[6], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ X"
	acss_fix_TD[7] = TextDrawCreate(35.0000, 245.0000, "txd:bracsn5");
	TextDrawTextSize(acss_fix_TD[7], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[7], 1);
	TextDrawColor(acss_fix_TD[7], -1);
	TextDrawBackgroundColor(acss_fix_TD[7], 255);
	TextDrawFont(acss_fix_TD[7], 4);
	TextDrawSetSelectable(acss_fix_TD[7], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ Y"
	acss_fix_TD[8] = TextDrawCreate(35.0000, 290.0000, "txd:bracsn6");
	TextDrawTextSize(acss_fix_TD[8], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[8], 1);
	TextDrawColor(acss_fix_TD[8], -1);
	TextDrawBackgroundColor(acss_fix_TD[8], 255);
	TextDrawFont(acss_fix_TD[8], 4);
	TextDrawSetSelectable(acss_fix_TD[8], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ Z"
	acss_fix_TD[9] = TextDrawCreate(35.0000, 335.0000, "txd:bracsn7");
	TextDrawTextSize(acss_fix_TD[9], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[9], 1);
	TextDrawColor(acss_fix_TD[9], -1);
	TextDrawBackgroundColor(acss_fix_TD[9], 255);
	TextDrawFont(acss_fix_TD[9], 4);
	TextDrawSetSelectable(acss_fix_TD[9], true);

//-НАЖАТЫЕ КНОПКИ
	//КНОПКА "ВЛЕВО/ВПРАВО"
	acss_fix_TD[10] = TextDrawCreate(35.0000, 65.0000, "txd:bracsa1");
	TextDrawTextSize(acss_fix_TD[10], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[10], 1);
	TextDrawColor(acss_fix_TD[10], -1);
	TextDrawBackgroundColor(acss_fix_TD[10], 255);
	TextDrawFont(acss_fix_TD[10], 4);

	//КНОПКА "ВВЕРХ/ВНИЗ"
	acss_fix_TD[11] = TextDrawCreate(35.0000, 110.0000, "txd:bracsa2");
	TextDrawTextSize(acss_fix_TD[11], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[11], 1);
	TextDrawColor(acss_fix_TD[11], -1);
	TextDrawBackgroundColor(acss_fix_TD[11], 255);
	TextDrawFont(acss_fix_TD[11], 4);

	//КНОПКА "ОТ СЕБЯ/НА СЕБЯ"
	acss_fix_TD[12] = TextDrawCreate(35.0000, 155.0000, "txd:bracsa3");
	TextDrawTextSize(acss_fix_TD[12], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[12], 1);
	TextDrawColor(acss_fix_TD[12], -1);
	TextDrawBackgroundColor(acss_fix_TD[12], 255);
	TextDrawFont(acss_fix_TD[12], 4);

	//КНОПКА "МАСШТАБ"
	acss_fix_TD[13] = TextDrawCreate(35.0000, 200.0000, "txd:bracsa4");
	TextDrawTextSize(acss_fix_TD[13], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[13], 1);
	TextDrawColor(acss_fix_TD[13], -1);
	TextDrawBackgroundColor(acss_fix_TD[13], 255);
	TextDrawFont(acss_fix_TD[13], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ X"
	acss_fix_TD[14] = TextDrawCreate(35.0000, 245.0000, "txd:bracsa5");
	TextDrawTextSize(acss_fix_TD[14], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[14], 1);
	TextDrawColor(acss_fix_TD[14], -1);
	TextDrawBackgroundColor(acss_fix_TD[14], 255);
	TextDrawFont(acss_fix_TD[14], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ Y"
	acss_fix_TD[15] = TextDrawCreate(35.0000, 290.0000, "txd:bracsa6");
	TextDrawTextSize(acss_fix_TD[15], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[15], 1);
	TextDrawColor(acss_fix_TD[15], -1);
	TextDrawBackgroundColor(acss_fix_TD[15], 255);
	TextDrawFont(acss_fix_TD[15], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ Z"
	acss_fix_TD[16] = TextDrawCreate(35.0000, 335.0000, "txd:bracsa7");
	TextDrawTextSize(acss_fix_TD[16], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[16], 1);
	TextDrawColor(acss_fix_TD[16], -1);
	TextDrawBackgroundColor(acss_fix_TD[16], 255);
	TextDrawFont(acss_fix_TD[16], 4);

	//РЕДАКТОР "ВЛЕВО/ВПРАВО"
	acss_fix_TD[17] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm1");
	TextDrawTextSize(acss_fix_TD[17], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[17], 1);
	TextDrawColor(acss_fix_TD[17], -1);
	TextDrawBackgroundColor(acss_fix_TD[17], 255);
	TextDrawFont(acss_fix_TD[17], 4);
	TextDrawSetProportional(acss_fix_TD[17], 0);
	TextDrawSetShadow(acss_fix_TD[17], 0);

	//РЕДАКТОР "ВВЕРХ/ВНИЗ"
	acss_fix_TD[18] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm2");
	TextDrawTextSize(acss_fix_TD[18], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[18], 1);
	TextDrawColor(acss_fix_TD[18], -1);
	TextDrawBackgroundColor(acss_fix_TD[18], 255);
	TextDrawFont(acss_fix_TD[18], 4);
	TextDrawSetProportional(acss_fix_TD[18], 0);
	TextDrawSetShadow(acss_fix_TD[18], 0);

	//РЕДАКТОР "ОТ СЕБЯ/НА СЕБЯ"
	acss_fix_TD[19] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm3");
	TextDrawTextSize(acss_fix_TD[19], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[19], 1);
	TextDrawColor(acss_fix_TD[19], -1);
	TextDrawBackgroundColor(acss_fix_TD[19], 255);
	TextDrawFont(acss_fix_TD[19], 4);
	TextDrawSetProportional(acss_fix_TD[19], 0);
	TextDrawSetShadow(acss_fix_TD[19], 0);

	//РЕДАКТОР "МАСШТАБ"
	acss_fix_TD[20] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm4");
	TextDrawTextSize(acss_fix_TD[20], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[20], 1);
	TextDrawColor(acss_fix_TD[20], -1);
	TextDrawBackgroundColor(acss_fix_TD[20], 255);
	TextDrawFont(acss_fix_TD[20], 4);
	TextDrawSetProportional(acss_fix_TD[20], 0);
	TextDrawSetShadow(acss_fix_TD[20], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ X"
	acss_fix_TD[21] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm5");
	TextDrawTextSize(acss_fix_TD[21], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[21], 1);
	TextDrawColor(acss_fix_TD[21], -1);
	TextDrawBackgroundColor(acss_fix_TD[21], 255);
	TextDrawFont(acss_fix_TD[21], 4);
	TextDrawSetProportional(acss_fix_TD[21], 0);
	TextDrawSetShadow(acss_fix_TD[21], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ Y"
	acss_fix_TD[22] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm6");
	TextDrawTextSize(acss_fix_TD[22], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[22], 1);
	TextDrawColor(acss_fix_TD[22], -1);
	TextDrawBackgroundColor(acss_fix_TD[22], 255);
	TextDrawFont(acss_fix_TD[22], 4);
	TextDrawSetProportional(acss_fix_TD[22], 0);
	TextDrawSetShadow(acss_fix_TD[22], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ Z"
	acss_fix_TD[23] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm7");
	TextDrawTextSize(acss_fix_TD[23], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[23], 1);
	TextDrawColor(acss_fix_TD[23], -1);
	TextDrawBackgroundColor(acss_fix_TD[23], 255);
	TextDrawFont(acss_fix_TD[23], 4);
	TextDrawSetProportional(acss_fix_TD[23], 0);
	TextDrawSetShadow(acss_fix_TD[23], 0);

	acss_fix_TD[24] = TextDrawCreate(460.0000, 205.0000, "txd:transparent");
	TextDrawTextSize(acss_fix_TD[24], 50.0000, 50.0000);
	TextDrawAlignment(acss_fix_TD[24], 1);
	TextDrawColor(acss_fix_TD[24], 0x00000000);
	TextDrawBackgroundColor(acss_fix_TD[24], 255);
	TextDrawFont(acss_fix_TD[24], 4);
	TextDrawSetProportional(acss_fix_TD[23], 0);
	TextDrawSetShadow(acss_fix_TD[24], 0);
	TextDrawSetSelectable(acss_fix_TD[24], true);

	acss_fix_TD[25] = TextDrawCreate(530.0000, 205.0000, "txd:transparent");
	TextDrawTextSize(acss_fix_TD[25], 50.0000, 50.0000);
	TextDrawAlignment(acss_fix_TD[25], 1);
	TextDrawColor(acss_fix_TD[25], 0x00000000);
	TextDrawBackgroundColor(acss_fix_TD[23], 255);
	TextDrawFont(acss_fix_TD[25], 4);
	TextDrawSetProportional(acss_fix_TD[23], 0);
	TextDrawSetShadow(acss_fix_TD[25], 0);
	TextDrawSetSelectable(acss_fix_TD[25], true);
}

public: CREATE_TABLIST_ACCESSORY()
{
	mysql_query(mysql, "SELECT * FROM accessories_players");

	if(mysql_errno())
	{
		mysql_query(mysql, 
			"CREATE TABLE `accessories_players` (\
		`id` INT NOT NULL AUTO_INCREMENT , PRIMARY KEY (`id`),\
		`player_id` int(11) NOT NULL,\
		`slot` int(11) NOT NULL,\
		`bone` int(11) NOT NULL,\
		`acs_id` int(11) NOT NULL,\
		`x` float NOT NULL DEFAULT 0.01,\
		`y` float NOT NULL DEFAULT 0.01,\
		`z` float NOT NULL DEFAULT 0.01,\
		`rX` float NOT NULL DEFAULT 0.01,\
		`rY` float NOT NULL DEFAULT 0.01,\
		`rZ` float NOT NULL DEFAULT 0.01,\
		`scale` float NOT NULL DEFAULT 1.01) ENGINE=InnoDB DEFAULT CHARSET=utf8;", false);

		if(mysql_errno()) return printf("ERROR CREATE TABLE accessories_players");
	}

	mysql_query(mysql, "SELECT * FROM accessory_inventory");

	if(mysql_errno())
	{
		mysql_query(mysql, 
			"CREATE TABLE `accessory_inventory` ( `id` INT NOT NULL AUTO_INCREMENT , \
			`player_id` INT NOT NULL , \
			`acs_id` INT NOT NULL , \
			`use` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;", false);

		if(mysql_errno()) return printf("ERROR CREATE TABLE accessory_inventory");
	}

	return 1;
}

CMD:myacs(playerid)
{
    new fmt_text[640], Cache: result, id;
    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM accessory_inventory WHERE player_id='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);
    new rows = cache_num_rows();
    if(!rows) SendClientMessage(playerid, 0x999999FF, "У Вас нет аксессуаров");
    else
    {
        new query[78], acs, use, acs_use[24];
        format(fmt_text, sizeof fmt_text, "");
        for(new i = 0; i < rows; i ++)
        {
            id = cache_get_field_content_int(i, "id");
            acs = cache_get_field_content_int(i, "acs_id");
            use = cache_get_field_content_int(i, "use");
            if(use > 0) acs_use = "{636363}[используется]";
            else acs_use = "";
            format(query, sizeof query, "{FFFFFF}%d. %s %s\n", i + 1, accessory[acs][NAME_ACCESSORY], acs_use);
            strcat(fmt_text, query);
            SetPlayerListitemValue(playerid, i, id);
            format(query, sizeof query, "acsuse%d", i);
            SetPVarInt(playerid, query, use);
        }
        Dialog(playerid, 1190, DIALOG_STYLE_LIST, "{FFCD00}Выберите акссесуар", fmt_text, "Выбрать", "Закрыть");
    }
    cache_delete(result);
    return 1;
}