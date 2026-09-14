/*
В enum // типы предложений
OFFER_TYPE_ACCESSORY,

//поменяйте типы бизнесов на те что снизу
enum // типы бизнесов
{
	BUSINESS_TYPE_SHOP_24_7 = 1, 	// магазин 24/7
	BUSINESS_TYPE_CLUB = 2, 		// клуб (алхамбра)
	BUSINESS_TYPE_REALTOR_BIZ = 3, 	// управление статистики (бизнесы)
	BUSINESS_TYPE_REALTOR_HOME = 4,	// риелторское агенство (дома)
	BUSINESS_TYPE_CLOTHING_SHOP = 5,// магазин одежды
	BUSINESS_TYPE_HOTEL = 6,		// отель
	BUSINESS_TYPE_CAR_MARKET = 7,	// авторынок
	BUSINESS_TYPE_CASINO = 8,		// казино
	BUSINESS_TYPE_CELL_SALON = 9,	// сотовый салон
	BUSINESS_TYPE_CAR_TUNING = 10, 	// станция тех. обслуживания
	BUSINESS_TYPE_SHOP_GUN = 11, 	// магазин оружия (либо просто добавьте этот)
	BUSINESS_TYPE_ACCESSORY_SHOP = 13, 	// магазин оружия
};

// в моде найдите 		if(GetBusinessData(action_id, B_TYPE) == BUSINESS_TYPE_CLOTHING_SHOP)
						{
							SetPlayerInBiz(playerid, action_id);
							
							ShowPlayerClothingShopPanel(playerid);
							
							return 1;
						}
ПОСЛЕ НЕГО ДОБАВЬТЕ

						if(GetBusinessData(action_id, B_TYPE) == BUSINESS_TYPE_ACCESSORY_SHOP)
						{
							SetPlayerInBiz(playerid, action_id);
							
							EntryAccessoryMarket(playerid);
							
							return 1;
						}

В CMD:addbiz где if(!(1 <= type <= 11)
поменяйте на if(!(1 <= type <= 11) && type != 13)







В stock SendPlayerOffer(playerid, to_player, type, value_1 = 0, value_2 = 0)

			case OFFER_TYPE_ACCESSORY:
			{
				new price = GetPVarInt(playerid, "owner_accept_price"),
				acs = GetPVarInt(playerid, "acs_id");

				format(fmt_str, sizeof fmt_str, "%s предлагает Вам купить %s за %d руб.", GetPlayerNameEx(playerid), accessory[acs][NAME_ACCESSORY], price);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);

				SendClientMessage(to_player, -1, "Напишите {00CC00}/yes {FFFFFF}чтобы согласиться или {FF6600}/no {FFFFFF}для отказа");

				format(fmt_str, sizeof fmt_str, "Вы предложили %s взять %s за %d руб.", GetPlayerNameEx(to_player), accessory[acs][NAME_ACCESSORY], price);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}

В cmd:yes
					case OFFER_TYPE_ACCESSORY:
					{
						new price = GetPVarInt(offer_id, "owner_accept_price"),
						acs = GetPVarInt(offer_id, "acs_id"), sql = GetPVarInt(offer_id, "owner_accept_acs_sql"), string[124];

						if(price <= GetPlayerMoneyEx(playerid))
						{

							mysql_format(mysql, string, sizeof string, "UPDATE accessory_inventory SET player = %d WHERE id = %d", GetPlayerAccountID(playerid), sql);
							mysql_query(mysql, string, false);

							if(!mysql_errno())
							{
								GivePlayerMoneyEx(playerid, -price);
								GivePlayerMoneyEx(offer_id, price);

								format(fmt_str, sizeof fmt_str, "Вы продали/передали %s аксессуар %s за %d руб.", GetPlayerNameEx(playerid), accessory[acs][NAME_ACCESSORY], price);
								SendClientMessage(offer_id, 0x3399FFFF, fmt_str);
							
								format(fmt_str, sizeof fmt_str, "%s продал Вам %s за %d руб.", GetPlayerNameEx(offer_id), accessory[acs][NAME_ACCESSORY], price);
								SendClientMessage(playerid, 0x3399FFFF, fmt_str);
							}
						}
						else
						{
							SendClientMessage(playerid, -1, ""USC" У Вас недостаточно средств");
							SendClientMessage(offer_id, -1, ""USC" У Игрока недостаточно средств");
						}
					}

*/
new bool:create_player_btn[MAX_PLAYERS];

// Глобальные текстдравы
new Text:button_TD[13];

new Text: acss_TD[26];
new PlayerText: acss_coords_PTD[MAX_PLAYERS][1];

// Текстдравы для игроков
new PlayerText:button_PTD[MAX_PLAYERS][1];
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
//18 - Челюсть

new accessory[116][ACCESSORY_M_STRCT] =
{
    {4196 , 1,"Крылья бабочки "                       ,15000000 },
    {4197 , 2,"Маска пчелы"                       ,10000000},
    {4198 , 2,"Кленовая корона"                       ,7000000},
    {4199 , 1,"Рюкзак - реактивный ранец"                       ,5000000},
    {4200 , 1,"Кленовая сумка "                       ,5000000},
    {4201 , 1,"Метла"                       ,1000000},
    {4203 , 1,"Рюкзак с овощами "                       ,3000000},
    {4204 , 1,"Школьный рюкзак"                       ,3000000},
    {4205 , 2,"Шапка - подсолнух"                       ,2500000},
    {4206 , 1,"Черный зонт"                       ,1500000},
    {4207 , 1,"Зонт с листьями"                       ,1000000},
    {4208 , 1,"Розовый зонт "                       ,900000},
    {14574, 1,"Крылья демона"                       ,15000000},
    {14575, 1,"Крылья ангела"                       ,15000000},
    {14593, 1,"Карамельные крылья "                       ,15000000},
    {15134, 1,"Рюкзак инопланетянин "                       ,12000000},
    {15135, 2,"Шляпа ведьмы "                       ,2000000},
    {15136, 2,"Шляпа ведьмы "                       ,2000000},
    {15137, 2,"Шляпа ведьмы "                       ,2000000},
    {15138, 2,"Шляпа звезды "                       ,2000000},
    {15139, 2,"Красная шляпа ведьмы "                      ,2500000},
    {15140, 2,"Шляпа ведьмы "                       ,2000000},
    {15141, 2,"Шляпа ведьмы "                       ,2000000},
    {15142, 1,"Железная коса"                       ,2000000},
    {15143, 1,"Металлическая коса "                       ,1500000},
    {15144, 2,"Светящиеся красная маска "                       ,500000},
    {15145, 2,"Маска маньяка"                       ,500000},
    {15146, 2,"Плачущая маска "                       ,500000},
    {15147, 2,"Страшная маска "                       ,700000},
    {15149, 1,"Метла"                       ,1000000},
    {15150, 1,"Рюкзак FnaF"                       ,1500000},
    {15151, 2,"Маска ведущего "                       ,3000000},
    {15152, 2,"Светящиеся синяя маска "                       ,500000},
    {15153, 2,"Светящиеся фиолетовая маска"                       ,500000},
    {7329 , 2,"Красная повязка"                        ,300000},
    {7330 , 2,"Красная повязка"                        ,300000},
    {7331 , 2,"Военная каска 2"                        ,500000},
    {7332 , 2,"Черная шапка "                        ,300000},
    {7333 , 2,"Белая шапка"                        ,300000},
    {7334 , 2,"Синяя шапка"                        ,300000},
    {7336 , 2,"Синяя кепка 2"                        ,300000},
    {7337 , 2,"Синяя кепка 3"                        ,300000},
    {7338 , 2,"Разноцветная кепка "                        ,300000},
    {7339 , 2,"Черная кепка "                        ,300000},
    {7341 , 2,"Кепка (NY) "                        ,400000},
    {7342 , 2,"Шапка (Шерлок) "                        ,400000},
    {7343 , 2,"Панама №1 супе"                        ,300000},
    {7344 , 2,"Панама №2 (StoneIS) "                        ,300000},
    {7345 , 2,"Панама №3 "                        ,300000},
    {7346 , 2,"Панана №4 "                        ,300000},
    {7347 , 2,"Панама №5 "                        ,300000},
    {7348 , 2,"Панама №6 "                        ,300000},
    {7349 , 2,"Панама №7 "                        ,300000},
    {7350 , 2,"Панама №8 (БП)"                        ,300000},
    {18377, 2,"Очки сердечки"                       ,7000000},
    {18386, 2,"Очки глаза "                       ,7000000},
    {18389, 2,"Шапочка с оленьями рожками "                       ,300000},
    {18390, 2,"Очки матрица "                       ,6000000},
    {18391, 2,"Очки огонь "                       ,7000000},
    {18392, 2,"Очки огонь прямые"                       ,8000000},
    {18396, 2,"Маска гнома"                       ,2500000},
    {18397, 2,"Маска гринча "                       ,2000000},
    {18399, 2,"Рожки"                       ,1000000},
    {18400, 2,"Рожки 2"                       ,100000},
    {18401, 2,"Очки салют "                       ,7000000},
    {18402, 2,"Маска котика "                       ,3000000},
    {18403, 2,"Маска тигра"                       ,3000000},
    {18404, 2,"Очки глюки "                       ,7000000},
    {18409, 2,"Очки снежинки"                       ,7000000},
    {7351 , 2,"Кепка"                        ,300000},
    {7352 , 2,"Кепка 2"                        ,300000},
    {7353 , 2,"Кепка"                        ,300000},
    {7354 , 2,"Кепка"                        ,300000},
    {7355 , 2,"Шляпа №1"                        ,400000},
    {7356 , 2,"Шляпа №2"                        ,450000},
    {7357 , 2,"Шляпа №3 (New)"                        ,450000},
    {7358 , 2,"Шляпа №4"                        ,500000},
    {7359 , 2,"Шляпа №5"                        ,500000},
    {7360 , 2,"Шляпа №6"                        ,500000},
    {7362 , 2,"Синяя шапка"                        ,350000},
    {7364 , 1,"Зонт (Разноцветный)"                       ,8000000},
    {7367 , 6,"Кожаный кейс "                        ,5000000},
    {7368 , 6,"Кейс (2) "                        ,10000000},
    {7369 , 6,"Черный кейс"                        ,12000000},
    {7370 , 2,"Маска петуха "                        ,5000000},
    {7371 , 2,"Маска голубя "                        ,5000000},
    {7372 , 2,"Маска зелёная"                        ,3000000},
    {7374 , 2,"Маска медведя"                        ,4000000},
    {7375 , 2,"Маска самурай"                        ,5000000},
    {7376 , 2,"Маска самурай"                        ,5000000},
    {7377 , 1,"Катана "                        ,1000000},
    {7378 , 1,"Катана "                        ,1000000},
    {7379 , 2,"Шляпа самурая №1"                        ,1500000},
    {7380 , 2,"Шляпа самурая №2"                        ,1500000},
    {7381 , 2,"Шляпа самурая №3"                        ,1500000},
    {7382 , 2,"Шляпа индейца"                        ,1500000},
    {7383 , 1,"Доска для серфинга №1"                        ,500000},
    {7384 , 1,"Доска для серфинга №2"                        ,500000},
    {7385 , 1,"Доска для серфинга №3"                        ,500000},
    {7386 , 1,"Доска для серфинга №4"                        ,500000},
    {7387 , 1,"Акула"                        ,750000},
    {7390 , 1,"Гитара №1"                        ,700000},
    {7391 , 1,"Гитара №2"                        ,700000},
    {7392 , 1,"Гитара №3"                        ,700000},
    {7393 , 1,"Гитара №4"                        ,700000},
    {7394 , 1,"Скейт №1"                        ,750000},
    {7395 , 1,"Скейт №2"                        ,750000},
    {790,   1,"Новогодний Дракон"                        ,4000000},
    {787,   2,"Маска Дракона"                        ,7000000},
    {9824 , 1,"Весёлая тыква"                        ,5000000},
    {9825 , 1,"Хеллоуинские ночи"                        ,3000000},
    {9827 , 1,"Кукла Вуду "                        ,5000000},
    {9828 , 1,"Призрачный портал"                        ,4000000},
    {11919, 2,"Акула на голову"                       ,6000000},
    {11923, 1,"Рюкзак Мопс на спину"                       ,5000000},
    {14589, 1,"Маска Оленя"                       ,6000000}
};

stock CreatePlTDButtonBR(playerid)
{
    button_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 309.4163, 406.8438, "‰EHA:10000000"); // пусто
    PlayerTextDrawLetterSize(playerid, button_PTD[playerid][0], 0.1466, 0.9860);
    PlayerTextDrawTextSize(playerid, button_PTD[playerid][0], 0.0000, -137.0000);
    PlayerTextDrawAlignment(playerid, button_PTD[playerid][0], 2);
    PlayerTextDrawColor(playerid, button_PTD[playerid][0], -2139062017);
    PlayerTextDrawBackgroundColor(playerid, button_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, button_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, button_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, button_PTD[playerid][0], 0);
    create_player_btn[playerid] = true;
    return 1;
}

stock CreateTextDrawButtonBR()
{
    button_TD[0] = TextDrawCreate(579.1665, 374.5928, "_"); // пусто
    TextDrawLetterSize(button_TD[0], 0.0087, 4.5451);
    TextDrawTextSize(button_TD[0], 615.0000, 0.0000);
    TextDrawAlignment(button_TD[0], 1);
    TextDrawColor(button_TD[0], -1);
    TextDrawUseBox(button_TD[0], 1);
    TextDrawBoxColor(button_TD[0], -1607587841);
    TextDrawBackgroundColor(button_TD[0], 255);
    TextDrawFont(button_TD[0], 1);
    TextDrawSetProportional(button_TD[0], 1);
    TextDrawSetShadow(button_TD[0], 0);

    button_TD[1] = TextDrawCreate(580.8331, 374.5928, "_"); // пусто
    TextDrawLetterSize(button_TD[1], 0.0170, 0.9518);
    TextDrawTextSize(button_TD[1], 614.0000, 0.0000);
    TextDrawAlignment(button_TD[1], 1);
    TextDrawColor(button_TD[1], -1);
    TextDrawUseBox(button_TD[1], 1);
    TextDrawBoxColor(button_TD[1], 255);
    TextDrawBackgroundColor(button_TD[1], 255);
    TextDrawFont(button_TD[1], 1);
    TextDrawSetProportional(button_TD[1], 1);
    TextDrawSetShadow(button_TD[1], 0);

    button_TD[2] = TextDrawCreate(580.4165, 405.7038, "_"); // пусто
    TextDrawLetterSize(button_TD[2], 0.0170, 0.9518);
    TextDrawTextSize(button_TD[2], 614.0000, 0.0000);
    TextDrawAlignment(button_TD[2], 1);
    TextDrawColor(button_TD[2], -1);
    TextDrawUseBox(button_TD[2], 1);
    TextDrawBoxColor(button_TD[2], 255);
    TextDrawBackgroundColor(button_TD[2], 255);
    TextDrawFont(button_TD[2], 1);
    TextDrawSetProportional(button_TD[2], 1);
    TextDrawSetShadow(button_TD[2], 0);

    button_TD[3] = TextDrawCreate(31.6666, 374.5927, "_"); // пусто
    TextDrawLetterSize(button_TD[3], 0.0087, 4.5451);
    TextDrawTextSize(button_TD[3], 68.0000, 0.0000);
    TextDrawAlignment(button_TD[3], 1);
    TextDrawColor(button_TD[3], -1);
    TextDrawUseBox(button_TD[3], 1);
    TextDrawBoxColor(button_TD[3], -1607587841);
    TextDrawBackgroundColor(button_TD[3], 255);
    TextDrawFont(button_TD[3], 1);
    TextDrawSetProportional(button_TD[3], 1);
    TextDrawSetShadow(button_TD[3], 0);

    button_TD[4] = TextDrawCreate(584.9999, 388.0742, ">>>"); // пусто
    TextDrawLetterSize(button_TD[4], 0.4053, 1.5273);
    TextDrawTextSize(button_TD[4], 609.0000, 80.0000);
    TextDrawAlignment(button_TD[4], 1);
    TextDrawColor(button_TD[4], -1);
    TextDrawUseBox(button_TD[4], 1);
    TextDrawBoxColor(button_TD[4], -1607587841);
    TextDrawBackgroundColor(button_TD[4], 255);
    TextDrawFont(button_TD[4], 1);
    TextDrawSetProportional(button_TD[4], 1);
    TextDrawSetShadow(button_TD[4], 0);
    TextDrawSetSelectable(button_TD[4], true);

    button_TD[5] = TextDrawCreate(33.3333, 374.5927, "_"); // пусто
    TextDrawLetterSize(button_TD[5], 0.0170, 0.9518);
    TextDrawTextSize(button_TD[5], 67.0000, 0.0000);
    TextDrawAlignment(button_TD[5], 1);
    TextDrawColor(button_TD[5], -1);
    TextDrawUseBox(button_TD[5], 1);
    TextDrawBoxColor(button_TD[5], 255);
    TextDrawBackgroundColor(button_TD[5], 255);
    TextDrawFont(button_TD[5], 1);
    TextDrawSetProportional(button_TD[5], 1);
    TextDrawSetShadow(button_TD[5], 0);

    button_TD[6] = TextDrawCreate(32.9166, 405.7038, "_"); // пусто
    TextDrawLetterSize(button_TD[6], 0.0170, 0.9518);
    TextDrawTextSize(button_TD[6], 67.0000, 0.0000);
    TextDrawAlignment(button_TD[6], 1);
    TextDrawColor(button_TD[6], -1);
    TextDrawUseBox(button_TD[6], 1);
    TextDrawBoxColor(button_TD[6], 255);
    TextDrawBackgroundColor(button_TD[6], 255);
    TextDrawFont(button_TD[6], 1);
    TextDrawSetProportional(button_TD[6], 1);
    TextDrawSetShadow(button_TD[6], 0);

    button_TD[7] = TextDrawCreate(37.9166, 388.0742, "<<<"); // пусто
    TextDrawLetterSize(button_TD[7], 0.3999, 1.4858);
    TextDrawTextSize(button_TD[7], 64.0000, 80.0000);
    TextDrawAlignment(button_TD[7], 1);
    TextDrawColor(button_TD[7], -1);
    TextDrawUseBox(button_TD[7], 1);
    TextDrawBoxColor(button_TD[7], -1607587841);
    TextDrawBackgroundColor(button_TD[7], 255);
    TextDrawFont(button_TD[7], 1);
    TextDrawSetProportional(button_TD[7], 1);
    TextDrawSetShadow(button_TD[7], 0);
    TextDrawSetSelectable(button_TD[7], true);


    button_TD[8] = TextDrawCreate(257.4165, 378.2438, "_"); // пусто
    TextDrawLetterSize(button_TD[8], 0.0447, 4.2666);
    TextDrawTextSize(button_TD[8], 365.0000, 0.0000);
    TextDrawAlignment(button_TD[8], 1);
    TextDrawColor(button_TD[8], -1);
    TextDrawUseBox(button_TD[8], 1);
    TextDrawBoxColor(button_TD[8], -1607587841);
    TextDrawBackgroundColor(button_TD[8], 255);
    TextDrawFont(button_TD[8], 1);
    TextDrawSetProportional(button_TD[8], 1);
    TextDrawSetShadow(button_TD[8], 0);

    button_TD[9] = TextDrawCreate(259.0829, 380.6067, "_"); // пусто
    TextDrawLetterSize(button_TD[9], 0.0501, 3.8134);
    TextDrawTextSize(button_TD[9], 363.0000, 0.0000);
    TextDrawAlignment(button_TD[9], 1);
    TextDrawColor(button_TD[9], -1);
    TextDrawUseBox(button_TD[9], 1);
    TextDrawBoxColor(button_TD[9], 255);
    TextDrawBackgroundColor(button_TD[9], 255);
    TextDrawFont(button_TD[9], 1);
    TextDrawSetProportional(button_TD[9], 1);
    TextDrawSetShadow(button_TD[9], 0);

    button_TD[10] = TextDrawCreate(258.2500, 388.2810, "_"); // пусто
    TextDrawLetterSize(button_TD[10], 0.0430, 1.8402);
    TextDrawTextSize(button_TD[10], 364.0000, 0.0000);
    TextDrawAlignment(button_TD[10], 1);
    TextDrawColor(button_TD[10], -1);
    TextDrawUseBox(button_TD[10], 1);
    TextDrawBoxColor(button_TD[10], -1607587841);
    TextDrawBackgroundColor(button_TD[10], 255);
    TextDrawFont(button_TD[10], 1);
    TextDrawSetProportional(button_TD[10], 1);
    TextDrawSetShadow(button_TD[10], 0);

    button_TD[11] = TextDrawCreate(321.9993, 391.0805, "‹‘XOѓ"); // пусто
    TextDrawLetterSize(button_TD[11], 0.2726, 1.3414);
    TextDrawTextSize(button_TD[11], 362.0000, 80.0000);
    TextDrawAlignment(button_TD[11], 1);
    TextDrawColor(button_TD[11], -1);
    TextDrawUseBox(button_TD[11], 1);
    TextDrawBoxColor(button_TD[11], 255);
    TextDrawBackgroundColor(button_TD[11], 255);
    TextDrawFont(button_TD[11], 2);
    TextDrawSetProportional(button_TD[11], 1);
    TextDrawSetShadow(button_TD[11], 0);
    TextDrawSetSelectable(button_TD[11], true);

    button_TD[12] = TextDrawCreate(260.1662, 391.0807, "KYЊ…Џ’"); // пусто
    TextDrawLetterSize(button_TD[12], 0.2261, 1.3370);
    TextDrawTextSize(button_TD[12], 296.0000, 80.0000);
    TextDrawAlignment(button_TD[12], 1);
    TextDrawColor(button_TD[12], -1);
    TextDrawUseBox(button_TD[12], 1);
    TextDrawBoxColor(button_TD[12], 255);
    TextDrawBackgroundColor(button_TD[12], 255);
    TextDrawFont(button_TD[12], 2);
    TextDrawSetProportional(button_TD[12], 1);
    TextDrawSetShadow(button_TD[12], 0);
    TextDrawSetSelectable(button_TD[12], true);
    


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
    if(clickedid == button_TD[4]) //вперед
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
    if(clickedid == button_TD[7]) //назад
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
    if(clickedid == button_TD[11]) //выход
    {
        DestroyPlayerObject(playerid, pl_id_accessory[playerid]);
        pl_id_accessory[playerid] = -1;

        pl_accessory[playerid] = -1;

        for(new i;i < sizeof button_TD;i++) TextDrawHideForPlayer(playerid, button_TD[i]);
        PlayerTextDrawHide(playerid, button_PTD[playerid][0]);

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
    }
    if(clickedid == button_TD[12]) // купить
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
                SendClientMessage(playerid, -1, "Вы купили аксессуар. Он был добавлен /myacs");

                GiveAccessory(playerid, acs);
            }
        }
        else SendClientMessage(playerid, -1, "У вас недостаточно денег.");

    }
	if(clickedid == acss_TD[1])
	{
	    for(new i; i < sizeof acss_TD; i++)
	    {
	    	TextDrawHideForPlayer(playerid, acss_TD[i]);
		}

		DeletePVar(playerid, "acs_use");
		DeletePVar(playerid, "acss_TD_use");
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

		PlayerTextDrawHide(playerid, acss_coords_PTD[playerid][0]);
		TogglePlayerControllable(playerid, true);
		TogglePlayerAllHudElements(playerid, HUD_ELEMENT_SHOW);
	}
	if(clickedid == acss_TD[2])
	{
		for(new i; i < sizeof acss_TD; i++)
	    {
	    	TextDrawHideForPlayer(playerid, acss_TD[i]);
		}

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
		DeletePVar(playerid, "acss_TD_use");
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

		PlayerTextDrawHide(playerid, acss_coords_PTD[playerid][0]);
		TogglePlayerControllable(playerid, true);
		TogglePlayerAllHudElements(playerid, HUD_ELEMENT_SHOW);
		SendClientMessage(playerid, -1, "Аксессуар успешно сохранен.");
		
	}
	if(acss_TD[3] <= clickedid <= acss_TD[9])
	{
		new TD;
		for(new i = 3; i < 10;i++) if(clickedid == acss_TD[i]) TD = i;
		new td_use = GetPVarInt(playerid, "acss_TD_use"), count_TD = TD - 3, Float:float_count;
		TextDrawHideForPlayer(playerid, acss_TD[9 + td_use]);
		TextDrawShowForPlayer(playerid, acss_TD[2 + td_use]);
		TextDrawHideForPlayer(playerid, acss_TD[16 + td_use]);
		TextDrawHideForPlayer(playerid, acss_TD[3 + count_TD]);
		TextDrawShowForPlayer(playerid, acss_TD[10 + count_TD]);
		TextDrawShowForPlayer(playerid, acss_TD[17 + count_TD]);
		SetPVarInt(playerid, "acss_TD_use", count_TD+1);

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
		PlayerTextDrawSetString(playerid, acss_coords_PTD[playerid][0], acs_coords);
	}
	if(clickedid == acss_TD[24] || clickedid == acss_TD[25])
	{
		new Float: x, Float: y, Float: z, Float: scale, Float: Rx, Float: Ry, Float: Rz, acs_coords[11];

		switch(GetPVarInt(playerid, "acss_TD_use"))
	    {
	        case 1:
	        {
				//-влево/вправо
				if(clickedid == acss_TD[24])
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
				if(clickedid == acss_TD[24])
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
			    if(clickedid == acss_TD[24])
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
			    if(clickedid == acss_TD[24])
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
			    if(clickedid == acss_TD[24])
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
				if(clickedid == acss_TD[24])
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
				if(clickedid == acss_TD[24])
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

		PlayerTextDrawHide(playerid, acss_coords_PTD[playerid][0]);
		PlayerTextDrawSetString(playerid, acss_coords_PTD[playerid][0], acs_coords);
		PlayerTextDrawShow(playerid, acss_coords_PTD[playerid][0]);

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
    print("[LAIRD_SYSTEM] Система аксессуаров загружена.");
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

    InterpolateCameraPos(playerid, 2901.951660,1498.124877,2499.343750, 2900.450927,1500.220703,2499.363750, 2000, CAMERA_MOVE);
    InterpolateCameraLookAt(playerid, 2903.739257,1499.161499,2499.343750, 2899.104980,1503.386230,2499.562500, 2000, CAMERA_MOVE);

    pl_id_accessory[playerid] = CreatePlayerObject(playerid, accessory[0][ID_ACCESSORY], 2899.104980,1503.386230,2499.062500, 0.0, 0.0, 0.0);
        
    CreatePlTDButtonBR(playerid);

    SetPriceAccesory(playerid, 0);

    SelectTextDraw(playerid, 0xFF5252FF);
    for(new i;i < sizeof button_TD;i++) TextDrawShowForPlayer(playerid, button_TD[i]);
    PlayerTextDrawShow(playerid, button_PTD[playerid][0]);

    new Float:x, Float:y, Float:z, string[124];
    GetPlayerCameraPos(playerid, x, y, z);
    return 1;
}

stock SetPriceAccesory(playerid, acs)
{
    new string[24];
    format(string, sizeof string, "‰EHA:%d", accessory[acs][PRICE_ACCESSORY]);
    PlayerTextDrawSetString(playerid, button_PTD[playerid][0], string);

    return 1;
}


CMD:myacs(playerid)
{
	new fmt_text[640],
	Cache: result,
	id;

    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM accessory_inventory WHERE player_id='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);

    new rows = cache_num_rows();

    if(!rows) SendClientMessage(playerid, 0x999999FF, "У Вас нет аксессуаров");
    else
    {	
            new query[78],
                acs, use, acs_use[24];

            format(fmt_text, sizeof fmt_text, "");

            for(new i = 0; i < rows; i ++)
            {
                id = cache_get_field_content_int(i, "id");
                acs = cache_get_field_content_int(i, "acs_id");
                use = cache_get_field_content_int(i, "use");

                if(use > 0) acs_use = "{636363}[используется]";
                else  acs_use = "";

                format
                (
                    query,
                    sizeof query,
                    "{FFFFFF}%d. %s %s\n",
                    i + 1, 
                    accessory[acs][NAME_ACCESSORY], acs_use
                );
                strcat(fmt_text, query);
                SetPlayerListitemValue(playerid, i, id);

                format(query, sizeof query, "acsuse%d", i);
                SetPVarInt(playerid, query, use);
            }

            Dialog
            (
                playerid, 1190, DIALOG_STYLE_LIST,
                "{FFCD00}Выберите акссесуар",
                fmt_text,
                "Выбрать", "Закрыть"
            );
    }

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
                    playerid, 1191, DIALOG_STYLE_LIST,
                    "{FF0000}Выберите действие",
                    "1. Использoвать\n"\
                    "2. Передать/Продать\n"\
                    "{FF0000}3. Удалить",
                    "Выбрать", "Закрыть"
                );
                SetPVarInt(playerid, "acs_use", 0);
            }
            else
            {
                Dialog
                (
                    playerid, 1191, DIALOG_STYLE_LIST,
                    "{FF0000}Выберите действие",
                    "1. Снять\n"\
                    "2. Редактировать",
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
            
            SendPlayerOffer(playerid, player, OFFER_TYPE_ACCESSORY);
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

    if(cache_num_rows()) return SendClientMessage(playerid, -1, "Слот занят другим аксессуаром.");

    cache_delete(cache);

    mysql_format(mysql, string, sizeof string, "SELECT * FROM accessories_players WHERE `player_id` = %d AND `slot` = %d AND `bone` = %d", GetPlayerAccountID(playerid), slot, bone);
    cache = mysql_query(mysql, string, true);

    rows = cache_num_rows();

	cache_delete(cache);

    if(rows) return SendClientMessage(playerid, -1, "На этой части тела уже есть аксессуар.");
    else
    {
        mysql_format(mysql, string, sizeof string, "INSERT INTO accessories_players (player_id,slot,bone,acs_id) VALUES (%d,%d,%d,%d)", GetPlayerAccountID(playerid), slot, bone, id_acs);
        mysql_query(mysql, string, false);
		
        mysql_format(mysql, string, sizeof string, "UPDATE accessory_inventory SET `use` = 1 WHERE `id`=%d", database);
        mysql_query(mysql, string, false);
        SCM(playerid, -1, "Вы успешно надели аксессуар");
        new obj = accessory[id_acs][ID_ACCESSORY];
        SetPlayerAttachedObject(playerid, slot, obj, bone);
    }

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
            SendClientMessage(playerid, -1, "Вы сняли акссессуар.");
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
        "Пример:0,100000\n"\
        "\nЕсли вы хотите передать пишите цену 0",
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

		for(new i; i < 11; i ++) TextDrawShowForPlayer(playerid, acss_TD[i]);
		TextDrawShowForPlayer(playerid, acss_TD[17]);
		TextDrawShowForPlayer(playerid, acss_TD[24]);
		TextDrawShowForPlayer(playerid, acss_TD[25]);

		new acs_coords[18];
		format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "edit_x"));

		acss_coords_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 521.3996, 292.8998, acs_coords);
		PlayerTextDrawLetterSize(playerid, acss_coords_PTD[playerid][0], 0.3000, 1.6000);
		PlayerTextDrawAlignment(playerid, acss_coords_PTD[playerid][0], 2);
		PlayerTextDrawColor(playerid, acss_coords_PTD[playerid][0], 0xFFFFFFFF);
		PlayerTextDrawBackgroundColor(playerid, acss_coords_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, acss_coords_PTD[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, acss_coords_PTD[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, acss_coords_PTD[playerid][0], 0);

		PlayerTextDrawShow(playerid, acss_coords_PTD[playerid][0]);

		SetPVarInt(playerid, "acss_TD_use", 1);
		TogglePlayerControllable(playerid, false);
		TogglePlayerAllHudElements(playerid, HUD_ELEMENT_HIDE);
	}

	cache_delete(result);
}

stock GiveAccessory(playerid, acs)
{
    new string[148];

    mysql_format(mysql, string, sizeof string, "INSERT INTO accessory_inventory (player_id, acs_id) VALUES (%d, %d)", GetPlayerAccountID(playerid), acs);
    mysql_query(mysql, string, false);
    
    if(!mysql_errno())
    {
        format(string, sizeof string, "В инвентарь был добавлен {FFFF00}\"%s\"{FFFFFF} (/myacs)", accessory[acs][NAME_ACCESSORY]);
        SendClientMessage(playerid, -1, string);
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
	acss_TD[0] = TextDrawCreate(35.0000, 18.0000, "txd:bracstext");
	TextDrawTextSize(acss_TD[0], 127.0000, 45.0000);
	TextDrawAlignment(acss_TD[0], 1);
	TextDrawColor(acss_TD[0], -1);
	TextDrawBackgroundColor(acss_TD[0], 255);
	TextDrawFont(acss_TD[0], 4);

	//КНОПКА "ВЫХОД"
	acss_TD[1] = TextDrawCreate(600.0000, 0.1, "txd:bracsbtnexit");
	TextDrawTextSize(acss_TD[1], 45.0000, 50.0000);
	TextDrawAlignment(acss_TD[1], 1);
	TextDrawColor(acss_TD[1], -1);
	TextDrawBackgroundColor(acss_TD[1], 255);
	TextDrawFont(acss_TD[1], 4);
	TextDrawSetSelectable(acss_TD[1], true);

	//КНОПКА "СОХРАНИТЬ"
	acss_TD[2] = TextDrawCreate(453.0000, 355.0000, "txd:bracssave");
	TextDrawTextSize(acss_TD[2], 130.0000, 40.0000);
	TextDrawAlignment(acss_TD[2], 1);
	TextDrawColor(acss_TD[2], -1);
	TextDrawBackgroundColor(acss_TD[2], 255);
	TextDrawFont(acss_TD[2], 4);
	TextDrawSetSelectable(acss_TD[2], true);

//-НЕ НАЖАТЫЕ КНОПКИ
   	//КНОПКА "ВЛЕВО/ВПРАВО"
	acss_TD[3] = TextDrawCreate(35.0000, 65.0000, "txd:bracsn1");
	TextDrawTextSize(acss_TD[3], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[3], 1);
	TextDrawColor(acss_TD[3], -1);
	TextDrawBackgroundColor(acss_TD[3], 255);
	TextDrawFont(acss_TD[3], 4);
	TextDrawSetSelectable(acss_TD[3], true);

	//КНОПКА "ВВЕРХ/ВНИЗ"
	acss_TD[4] = TextDrawCreate(35.0000, 110.0000, "txd:bracsn2");
	TextDrawTextSize(acss_TD[4], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[4], 1);
	TextDrawColor(acss_TD[4], -1);
	TextDrawBackgroundColor(acss_TD[4], 255);
	TextDrawFont(acss_TD[4], 4);
	TextDrawSetSelectable(acss_TD[4], true);

	//КНОПКА "ОТ СЕБЯ/НА СЕБЯ"
	acss_TD[5] = TextDrawCreate(35.0000, 155.0000, "txd:bracsn3");
	TextDrawTextSize(acss_TD[5], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[5], 1);
	TextDrawColor(acss_TD[5], -1);
	TextDrawBackgroundColor(acss_TD[5], 255);
	TextDrawFont(acss_TD[5], 4);
	TextDrawSetSelectable(acss_TD[5], true);

	//КНОПКА "МАСШТАБ"
	acss_TD[6] = TextDrawCreate(35.0000, 200.0000, "txd:bracsn4");
	TextDrawTextSize(acss_TD[6], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[6], 1);
	TextDrawColor(acss_TD[6], -1);
	TextDrawBackgroundColor(acss_TD[6], 255);
	TextDrawFont(acss_TD[6], 4);
	TextDrawSetSelectable(acss_TD[6], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ X"
	acss_TD[7] = TextDrawCreate(35.0000, 245.0000, "txd:bracsn5");
	TextDrawTextSize(acss_TD[7], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[7], 1);
	TextDrawColor(acss_TD[7], -1);
	TextDrawBackgroundColor(acss_TD[7], 255);
	TextDrawFont(acss_TD[7], 4);
	TextDrawSetSelectable(acss_TD[7], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ Y"
	acss_TD[8] = TextDrawCreate(35.0000, 290.0000, "txd:bracsn6");
	TextDrawTextSize(acss_TD[8], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[8], 1);
	TextDrawColor(acss_TD[8], -1);
	TextDrawBackgroundColor(acss_TD[8], 255);
	TextDrawFont(acss_TD[8], 4);
	TextDrawSetSelectable(acss_TD[8], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ Z"
	acss_TD[9] = TextDrawCreate(35.0000, 335.0000, "txd:bracsn7");
	TextDrawTextSize(acss_TD[9], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[9], 1);
	TextDrawColor(acss_TD[9], -1);
	TextDrawBackgroundColor(acss_TD[9], 255);
	TextDrawFont(acss_TD[9], 4);
	TextDrawSetSelectable(acss_TD[9], true);

//-НАЖАТЫЕ КНОПКИ
	//КНОПКА "ВЛЕВО/ВПРАВО"
	acss_TD[10] = TextDrawCreate(35.0000, 65.0000, "txd:bracsa1");
	TextDrawTextSize(acss_TD[10], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[10], 1);
	TextDrawColor(acss_TD[10], -1);
	TextDrawBackgroundColor(acss_TD[10], 255);
	TextDrawFont(acss_TD[10], 4);

	//КНОПКА "ВВЕРХ/ВНИЗ"
	acss_TD[11] = TextDrawCreate(35.0000, 110.0000, "txd:bracsa2");
	TextDrawTextSize(acss_TD[11], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[11], 1);
	TextDrawColor(acss_TD[11], -1);
	TextDrawBackgroundColor(acss_TD[11], 255);
	TextDrawFont(acss_TD[11], 4);

	//КНОПКА "ОТ СЕБЯ/НА СЕБЯ"
	acss_TD[12] = TextDrawCreate(35.0000, 155.0000, "txd:bracsa3");
	TextDrawTextSize(acss_TD[12], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[12], 1);
	TextDrawColor(acss_TD[12], -1);
	TextDrawBackgroundColor(acss_TD[12], 255);
	TextDrawFont(acss_TD[12], 4);

	//КНОПКА "МАСШТАБ"
	acss_TD[13] = TextDrawCreate(35.0000, 200.0000, "txd:bracsa4");
	TextDrawTextSize(acss_TD[13], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[13], 1);
	TextDrawColor(acss_TD[13], -1);
	TextDrawBackgroundColor(acss_TD[13], 255);
	TextDrawFont(acss_TD[13], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ X"
	acss_TD[14] = TextDrawCreate(35.0000, 245.0000, "txd:bracsa5");
	TextDrawTextSize(acss_TD[14], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[14], 1);
	TextDrawColor(acss_TD[14], -1);
	TextDrawBackgroundColor(acss_TD[14], 255);
	TextDrawFont(acss_TD[14], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ Y"
	acss_TD[15] = TextDrawCreate(35.0000, 290.0000, "txd:bracsa6");
	TextDrawTextSize(acss_TD[15], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[15], 1);
	TextDrawColor(acss_TD[15], -1);
	TextDrawBackgroundColor(acss_TD[15], 255);
	TextDrawFont(acss_TD[15], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ Z"
	acss_TD[16] = TextDrawCreate(35.0000, 335.0000, "txd:bracsa7");
	TextDrawTextSize(acss_TD[16], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[16], 1);
	TextDrawColor(acss_TD[16], -1);
	TextDrawBackgroundColor(acss_TD[16], 255);
	TextDrawFont(acss_TD[16], 4);

	//РЕДАКТОР "ВЛЕВО/ВПРАВО"
	acss_TD[17] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm1");
	TextDrawTextSize(acss_TD[17], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[17], 1);
	TextDrawColor(acss_TD[17], -1);
	TextDrawBackgroundColor(acss_TD[17], 255);
	TextDrawFont(acss_TD[17], 4);
	TextDrawSetProportional(acss_TD[17], 0);
	TextDrawSetShadow(acss_TD[17], 0);

	//РЕДАКТОР "ВВЕРХ/ВНИЗ"
	acss_TD[18] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm2");
	TextDrawTextSize(acss_TD[18], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[18], 1);
	TextDrawColor(acss_TD[18], -1);
	TextDrawBackgroundColor(acss_TD[18], 255);
	TextDrawFont(acss_TD[18], 4);
	TextDrawSetProportional(acss_TD[18], 0);
	TextDrawSetShadow(acss_TD[18], 0);

	//РЕДАКТОР "ОТ СЕБЯ/НА СЕБЯ"
	acss_TD[19] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm3");
	TextDrawTextSize(acss_TD[19], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[19], 1);
	TextDrawColor(acss_TD[19], -1);
	TextDrawBackgroundColor(acss_TD[19], 255);
	TextDrawFont(acss_TD[19], 4);
	TextDrawSetProportional(acss_TD[19], 0);
	TextDrawSetShadow(acss_TD[19], 0);

	//РЕДАКТОР "МАСШТАБ"
	acss_TD[20] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm4");
	TextDrawTextSize(acss_TD[20], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[20], 1);
	TextDrawColor(acss_TD[20], -1);
	TextDrawBackgroundColor(acss_TD[20], 255);
	TextDrawFont(acss_TD[20], 4);
	TextDrawSetProportional(acss_TD[20], 0);
	TextDrawSetShadow(acss_TD[20], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ X"
	acss_TD[21] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm5");
	TextDrawTextSize(acss_TD[21], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[21], 1);
	TextDrawColor(acss_TD[21], -1);
	TextDrawBackgroundColor(acss_TD[21], 255);
	TextDrawFont(acss_TD[21], 4);
	TextDrawSetProportional(acss_TD[21], 0);
	TextDrawSetShadow(acss_TD[21], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ Y"
	acss_TD[22] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm6");
	TextDrawTextSize(acss_TD[22], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[22], 1);
	TextDrawColor(acss_TD[22], -1);
	TextDrawBackgroundColor(acss_TD[22], 255);
	TextDrawFont(acss_TD[22], 4);
	TextDrawSetProportional(acss_TD[22], 0);
	TextDrawSetShadow(acss_TD[22], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ Z"
	acss_TD[23] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm7");
	TextDrawTextSize(acss_TD[23], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[23], 1);
	TextDrawColor(acss_TD[23], -1);
	TextDrawBackgroundColor(acss_TD[23], 255);
	TextDrawFont(acss_TD[23], 4);
	TextDrawSetProportional(acss_TD[23], 0);
	TextDrawSetShadow(acss_TD[23], 0);

	acss_TD[24] = TextDrawCreate(460.0000, 205.0000, "plus");
	TextDrawTextSize(acss_TD[24], 50.0000, 50.0000);
	TextDrawAlignment(acss_TD[24], 1);
	TextDrawColor(acss_TD[24], -1);
	TextDrawBackgroundColor(acss_TD[24], 255);
	TextDrawFont(acss_TD[24], 4);
	TextDrawSetProportional(acss_TD[23], 0);
	TextDrawSetShadow(acss_TD[24], 0);
	TextDrawSetSelectable(acss_TD[24], true);

	acss_TD[25] = TextDrawCreate(530.0000, 205.0000, "minus");
	TextDrawTextSize(acss_TD[25], 50.0000, 50.0000);
	TextDrawAlignment(acss_TD[25], 1);
	TextDrawColor(acss_TD[25], -1);
	TextDrawBackgroundColor(acss_TD[23], 255);
	TextDrawFont(acss_TD[25], 4);
	TextDrawSetProportional(acss_TD[23], 0);
	TextDrawSetShadow(acss_TD[25], 0);
	TextDrawSetSelectable(acss_TD[25], true);
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