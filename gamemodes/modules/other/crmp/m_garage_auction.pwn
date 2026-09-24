/*

	Цвета аукциона

*/

#define col_all			CC9900
#define col_content		99CC00
#define col_end			FF9945

#define MAX_FIRST_PORT 8
#define MAX_TWO_PORT 12

#define MAX_AUCTION_GARAGES 12
#define MAX_AUCTION_GARAGES_SLOT 10

enum _g_auction
{
	g_id,
	g_object,
	g_bet,
	g_bet_id,
	g_bet_name [ MAX_PLAYER_NAME ],
	g_type,
	g_slot [ MAX_AUCTION_GARAGES_SLOT ],
	g_slot_type [ MAX_AUCTION_GARAGES_SLOT ],
	g_time,
	g_pickup,
	Text3D: g_text,
	g_status
} ;
new g_auction_info [ MAX_AUCTION_GARAGES ] [ _g_auction ] ;

#define DEF_GARAGE_TIME 300
#define GARAGE_AUCTION_TIME 3600
new garage_war_time [ 2 ] = { 0, ... } ;
new garage_war_status [ 2 ] = { 0, ... } ;
new garage_auction_name [ 5 ] [ 16 ] =
{
	"Низкий",
	"Средний",
	"Высокий",
	"Премиум",
	"Автомобильный"
} ;

new Float: g_auction_position_pickup [ MAX_AUCTION_GARAGES ] [ 3 ] =
{
	{ 2380.8559, 297.4514, 29.4920 },
	{ 2389.6755, 290.0859, 29.4920 },
	{ 2392.5207, 280.0070, 29.4973 },
	{ 2466.7275, 262.3147, 29.4973 },
	{ 2478.3859, 262.0137, 29.4973 },
	{ 2489.8085, 261.7113, 29.4973 },
	{ 2507.7463, 272.7805, 29.4973 },
	{ 2504.1711, 283.9044, 29.4973 },
	
	{ -2508.4565, 812.8374, 9.2506 },
	{ -2506.8076, 819.8941, 9.2506 },
	{ -2474.8937, 810.1723, 9.2506 },
	{ -2477.0541, 803.4845, 9.2506 }
} ;

new Float: g_auction_position_cont [ MAX_AUCTION_GARAGES ] [ 6 ] =
{
	{ 2387.48633, 285.41785, 29.94858,   0.00000, 0.00000, -24.78000 },
	{ 2380.90088, 292.36130, 29.94858,   0.00000, 0.00000, 0.00000 },
	{ 2466.75122, 257.62976, 29.94858,   0.00000, 0.00000, 0.00000 },
	{ 2478.38037, 257.61111, 29.94858,   0.00000, 0.00000, 0.00000 },
	{ 2492.91040, 258.57932, 29.94858,   0.00000, 0.00000, 44.16000 },
	{ 2503.09961, 272.59543, 29.94858,   0.00000, 0.00000, -87.47997 },
	{ 2499.42773, 283.68039, 29.94858,   0.00000, 0.00000, -87.47997 },
	{ 2392.52393, 274.77420, 29.94858,   0.00000, 0.00000, 0.00000 },
	
	{ -2504.18530, 811.72522, 9.71216,   0.00000, 0.00000, 73.08001 },
	{ -2502.59497, 818.72089, 9.71216,   0.00000, 0.00000, 73.08001 },
	{ -2479.22437, 811.63629, 9.71220,   0.00000, 0.00000, 73.08000 },
	{ -2481.35059, 805.04614, 9.71220,   0.00000, 0.00000, 73.08000 }
} ;

enum
{
	GAR_ITEM_COMMON = 0,
	GAR_ITEM_RARE,
	GAR_ITEM_EPIC,
	GAR_ITEM_LEGENDARY
} ;

enum
{
	GARAGE_NO_RENDER = -1,
	GARAGE_RENDER_OBJECT = 0,
	GARAGE_RENDER_CAR = 1,
	GARAGE_RENDER_SKIN = 2
} ;

enum _garage_item
{
	gar_type,
	gar_rare,
	gar_model,
	gar_name [ 24 ],
	Float: gar_rotX,
	Float: gar_rotY,
	Float: gar_rotZ,
	Float: gar_angle
} ;

#define MAX_GARAGE_AUCTION_ITEM 84
new garage_item [ MAX_GARAGE_AUCTION_ITEM ] [ _garage_item ] =
{
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1212, "Деньги", -25.0000, 0.0000, 35.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 1274, ""donate_title"", 0.0000, 0.0000, 180.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1582, "Сытость", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 348, "Навыки оружия", -10.0000, 0.0000, 0.0000, 1.2999 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 2684, "Лицензии", 0.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 11738, "Аптечки", -15.0000, 0.0000, 180.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1575, "Материалы", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 2061, "Боеприпасы", -30.0000, 0.0000, -30.0000, 1.0000 }, // 8

	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1242, "Бронежилет (1 уровень)", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 905, "Камень", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 19941, "Золото", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1463, "Древесина", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 2684, "Хлопок", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 1080, "Колесо", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 1018, "Выхлопная труба", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 1038, "Элемент крыши", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 1140, "Бампер", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 1165, "Задний бампер", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 19773, "Фрагмент ключа", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 11746, "Ключ от тюрьмы", -30.0000, 0.0000, -30.0000, 1.0000 }, // 14
	
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 11775, "Бананка (Синяя)", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 11774, "Бананка (Красная)", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 11773, "Бананка (Красная)", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12610, "Очки Leps", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12609, "Очки Oculus", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 12608, "Очки Orange", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 12091, "Рюкзак Kitty", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 12090, "Рюкзак Mike", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 5032, "Шлем PUBG #3", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 5033, "Шлем PUBG #4", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 5068, "Рюкзак Bumble Bee", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 5069, "Голова Bumble Bee", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 5070, "Голова Optimus Prime", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 5071, "Маленький Optimus Prime", 20.0, 180.0, 45.0, 0.78 }, // 14

	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 83, "Одежда #83", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 86, "Одежда #86", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 107, "Одежда #107", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 164, "Одежда #164", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 294, "Одежда #294", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 68, "Одежда #68", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 104, "Одежда #104", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 32, "Одежда #32", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 35, "Одежда #35", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 43, "Одежда #43", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 302, "Одежда #302", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 304, "Одежда #304", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 142, "Одежда #142", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 143, "Одежда #143", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 4551, "Одежда #4551", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 4552, "Одежда #4552", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 4656, "Одежда #4656", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 4680, "Одежда #4680", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 4681, "Одежда #4681", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 4691, "Одежда #4691", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 4730, "Одежда #4730", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 4731, "Одежда #4371", 20.0, 180.0, 45.0, 0.78 }, // 22
	
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 405, "BMW M5 E60", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 426, "Mercedes-Benz S600", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 436, "Volkswagen Golf", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 445, "Mercedes-Benz CLS63", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 470, "Volvo XC90", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 475, "Mercedes-Benz 230 CE", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 480, "Lexus LFA", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 502, "Subaru Impreza STI", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 507, "Audi S4", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 516, "Audi RS4", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 540, "Mercedes-Benz C63S", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 547, "Audi RS7", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 550, "Mercedes-Benz E63", 20.0, 180.0, 45.0, 0.78 }, // 13
	
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 559, "Audi RS6", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 566, "Mercedes-Benz C63", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 567, "Toyota Camry XV50", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 600, "BMW M2 F87", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 602, "BMW M3", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 604, "Mercedes-Benz E420", 20.0, 180.0, 45.0, 0.78 }, // 6

	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 555, "Jaguar F-Type", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3280, "Mercedes Benz S65", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3303, "Kia K5", 20.0, 180.0, 45.0, 0.78 }, // 3
	
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 466, "Tesla Model S", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3258, "Nissan 370z", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3259, "Toyota Supra", 20.0, 180.0, 45.0, 0.78 }, // 3
	
	{ ROULETTE_RENDER_CAR, ROU_ITEM_LEGENDARY, 3263, "Porsche Boxter", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_LEGENDARY, 3276, "Chrysler 300C", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_LEGENDARY, 3368, "X-Peng", 20.0, 180.0, 45.0, 0.78 } // 3
} ;

new Float: garage_war_info [ 2 ] [ 3 ] =
{
	{ 2483.8608, 289.8796, 29.4973 },
	{ -2568.3605, 753.7822, 9.2506 }
} ;
new garage_war_pickup [ 2 ] ;
new bool: player_auction_bet [ MAX_PLAYERS ] = { false, ... } ;
new player_container_id [ MAX_PLAYERS ] = { -1, ... } ;

stock garage_auction_OnGameModeInit ( )
{
	garage_war_time [ 0 ] = GARAGE_AUCTION_TIME ;
	garage_war_time [ 1 ] = GARAGE_AUCTION_TIME * 2 ;
	for ( new i = 0 ; i < MAX_AUCTION_GARAGES ; i ++ )
	{
		g_auction_info [ i ] [ g_object ] = CreateDynamicObject ( 2935, g_auction_position_cont [ i ] [ 0 ], g_auction_position_cont [ i ] [ 1 ], g_auction_position_cont [ i ] [ 2 ], g_auction_position_cont [ i ] [ 3 ], g_auction_position_cont [ i ] [ 4 ], g_auction_position_cont [ i ] [ 5 ] ) ;

		g_auction_info [ i ] [ g_pickup ] = CreateDynamicPickup ( 1239, 23, g_auction_position_pickup [ i ] [ 0 ], g_auction_position_pickup [ i ] [ 1 ], g_auction_position_pickup [ i ] [ 2 ], 0, 0 ) ;
		pick_info [ g_auction_info [ i ] [ g_pickup ] ] [ pick_type ] = pick_type_garage_auction ;
		pick_info [ g_auction_info [ i ] [ g_pickup ] ] [ pick_item ] = i ;

		g_auction_info [ i ] [ g_text ] = CreateDynamic3DTextLabel ( "** Контейнер **\n\n{"#cRD"}Аукцион не начат", col_blue, g_auction_position_pickup [ i ] [ 0 ], g_auction_position_pickup [ i ] [ 1 ], g_auction_position_pickup [ i ] [ 2 ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1 );
			
		g_auction_info [ i ] [ g_status ] =
		g_auction_info [ i ] [ g_time ] = 0 ;
		g_auction_info [ i ] [ g_bet_id ] = -1 ;
	}
	
	new text_label [ 27 + 2 ] ;
	for ( new i = 0 ; i < 2 ; i ++ )
	{
		format ( text_label, sizeof text_label, "** Городской порт №%d **", i + 1 ) ;
		CreateDynamic3DTextLabel ( text_label, col_blue, garage_war_info [ i ] [ 0 ], garage_war_info [ i ] [ 1 ], garage_war_info [ i ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1 );
		garage_war_pickup [ i ] = CreateDynamicPickup ( 1239, 23, garage_war_info [ i ] [ 0 ], garage_war_info [ i ] [ 1 ], garage_war_info [ i ] [ 2 ], 0, 0 ) ;
		pick_info [ garage_war_pickup [ i ] ] [ pick_type ] = pick_type_garage_info ;
	}
	return 1 ;
}

stock garage_auction_second_timer ( )
{
	if ( garage_war_time [ 0 ] > 0 )
	{
	    garage_war_time [ 0 ] -- ;
	    if ( garage_war_time [ 0 ] == 5400 ) SendClientMessageToAll ( col_yellow, !"* Через 60 минут начнётся аукцион контейнеров. (/gps > Прочее > Городской порт №1)");
	    else if ( garage_war_time [ 0 ] == 2700 ) SendClientMessageToAll ( col_yellow, !"* Через 30 минут начнётся аукцион контейнеров. (/gps > Прочее > Городской порт №1)");
	    else if ( garage_war_time [ 0 ] == 1500 ) SendClientMessageToAll ( col_yellow, !"* Через 10 минут начнётся аукцион контейнеров. (/gps > Прочее > Городской порт №1)");
	    else if ( garage_war_time [ 0 ] == 900 )
	    {
			new con_string [ 122 + 16 + 9 + 9 ] ;
	        for ( new i = 0 ; i < MAX_FIRST_PORT ; i ++ )
		    {
				switch ( random ( 11 ) )
				{
					case 0,1,2,3: g_auction_info [ i ] [ g_type ] = 0 ;
					case 4,5,6: g_auction_info [ i ] [ g_type ] = 1 ;
					case 7,8: g_auction_info [ i ] [ g_type ] = 2 ;
					case 9: g_auction_info [ i ] [ g_type ] = 3 ;
					case 10: g_auction_info [ i ] [ g_type ] = 4 ;
				}
				
				new _g_type = g_auction_info [ i ] [ g_type ] ;
	            if ( _g_type == 0 ) g_auction_info [ i ] [ g_bet ] = random ( 250000 ) + 150000 ;
	            else if ( _g_type == 1 ) g_auction_info [ i ] [ g_bet ] = random ( 500000 ) + 150000 ;
	            else if ( _g_type == 2 ) g_auction_info [ i ] [ g_bet ] = random ( 1000000 ) + 1500000 ;
	            else if ( _g_type == 3 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;
	            else if ( _g_type == 4 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;

	            for ( new c = 0 ; c < MAX_AUCTION_GARAGES_SLOT ; c ++ )
	            {
	                g_auction_info [ i ] [ g_slot ] [ c ] = -1 ;
	            }

	            g_auction_info [ i ] [ g_bet_id ] = -1 ;
	            g_auction_info [ i ] [ g_time ] = DEF_GARAGE_TIME ;
	            g_auction_info [ i ] [ g_status ] = 0 ;

	            create_g_auction_slot ( i ) ;
	            garage_war_status [ 0 ] = 1 ;

				format ( con_string, sizeof con_string, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Начальная ставка: {"#col_all"}%s"valute_title_"\n{"#cWH"}До конца торгов: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ), g_auction_info [ i ] [ g_time ] ) ;
				UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, con_string ) ;
			}
	    }
	    else if ( garage_war_time [ 0 ] == 1 )
	    {
	        garage_war_status [ 0 ] = 0 ;
	        garage_war_time [ 0 ] = random ( GARAGE_AUCTION_TIME ) + ( GARAGE_AUCTION_TIME * 2 ) ;
	    }
	}
	
	if ( garage_war_status [ 0 ] == 1 )
    {
		new con_string [ 227 + MAX_PLAYER_NAME ] ;
		for ( new i = 0 ; i < MAX_FIRST_PORT ; i ++ )
	    {
	        if ( g_auction_info [ i ] [ g_time ] > 1 )
	        {
	            g_auction_info [ i ] [ g_time ] -- ;

	            if ( g_auction_info [ i ] [ g_status ] )
	            {
	                if ( g_auction_info [ i ] [ g_time ] == 1 )
	                {
						UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, "** Контейнер **\n\n{"#cRD"}Аукцион не начат" ) ;

						g_auction_info [ i ] [ g_time ] =
						g_auction_info [ i ] [ g_status ] = 0 ;
						g_auction_info [ i ] [ g_bet_id ] = -1 ;
						continue ;
	                }

					format ( con_string, 170, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Победитель: {"#col_all"}%s\n{"#cWH"}До закрытия: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], g_auction_info [ i ] [ g_bet_name ], g_auction_info [ i ] [ g_time ] ) ;
					UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, con_string ) ;
	                continue ;
	            }
	            else
	            {
		            if ( g_auction_info [ i ] [ g_time ] == 1 )
		            {
		                if ( g_auction_info [ i ] [ g_bet_id ] == -1 )
						{
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, "** Контейнер **\n\n{"#cRD"}Аукцион не начат" ) ;

							g_auction_info [ i ] [ g_time ] =
							g_auction_info [ i ] [ g_status ] = 0 ;
							g_auction_info [ i ] [ g_bet_id ] = -1 ;
							continue ;
		                }
		                else
		                {
		                    new player_id = g_auction_info [ i ] [ g_bet_id ] ;
							if ( p_info [ player_id ] [ money ] < g_auction_info [ i ] [ g_bet ] )
							{
							    g_auction_info [ i ] [ g_bet_id ] = -1 ;
							    g_auction_info [ i ] [ g_status ] = 0 ;
								g_auction_info [ i ] [ g_time ] = DEF_GARAGE_TIME ;
								continue ;
							}

			                g_auction_info [ i ] [ g_status ] = 1 ;
							g_auction_info [ i ] [ g_time ] = DEF_GARAGE_TIME ;

							give_money ( player_id, -g_auction_info [ i ] [ g_bet ] ) ;
		            		insert_money_log ( player_id, INVALID_PLAYER_ID, -g_auction_info [ i ] [ g_bet ], "аукцион контейнеров" ) ;

							format ( con_string, 170, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Победитель: {"#col_all"}%s\n{"#cWH"}До закрытия: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], g_auction_info [ i ] [ g_bet_name ], g_auction_info [ i ] [ g_time ] ) ;
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, con_string ) ;

							format ( con_string, 90, "Вы выйграли контейнер на аукционе. Ваша ставка: {"#col_all"}%s"valute_title"{"#cOR"}.", GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ) ) ;
							SendClientMessage ( player_id, col_orange, con_string ) ;
							
							give_global_quest ( player_id, 1, 1 ) ;
							
							foreach(new p: logged_players)
							{
								if ( player_container_id [ p ] != i ) continue ;
								
								show_packet_container ( p, 1, 0, 0 ) ;
							}
							continue ;
						}
		            }
					else
					{
						if ( g_auction_info [ i ] [ g_bet_id ] != -1 )
						{
							format ( con_string, sizeof con_string, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Последняя ставка: {"#col_all"}%s"valute_title_"\n{"#cWH"}Ставка от: {"#col_all"}%s\n{"#cWH"}До конца торгов: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ), g_auction_info [ i ] [ g_bet_name ], g_auction_info [ i ] [ g_time ] ) ;
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, con_string ) ;
						}
						else
						{
							format ( con_string, 160, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Начальная ставка: {"#col_all"}%s"valute_title_"\n{"#cWH"}До конца торгов: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ), g_auction_info [ i ] [ g_time ] ) ;
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, con_string ) ;
						}
					}
				}
	        }
	    }
	}
	
	if ( garage_war_time [ 1 ] > 0 )
	{
	    garage_war_time [ 1 ] -- ;
	    if ( garage_war_time [ 1 ] == 5400 ) SendClientMessageToAll ( col_yellow, !"* Через 60 минут начнётся аукцион контейнеров. (/gps > Прочее > Городской порт №2)");
	    else if ( garage_war_time [ 1 ] == 2700 ) SendClientMessageToAll ( col_yellow, !"* Через 30 минут начнётся аукцион контейнеров. (/gps > Прочее > Городской порт №2)");
	    else if ( garage_war_time [ 1 ] == 1500 ) SendClientMessageToAll ( col_yellow, !"* Через 10 минут начнётся аукцион контейнеров. (/gps > Прочее > Городской порт №2)");
	    else if ( garage_war_time [ 1 ] == 900 )
	    {
			new con_string [ 122 + 16 + 9 + 9 ] ;
	        for ( new i = MAX_FIRST_PORT ; i < MAX_TWO_PORT ; i ++ )
		    {
				switch ( random ( 11 ) )
				{
					case 0,1,2,3: g_auction_info [ i ] [ g_type ] = 0 ;
					case 4,5,6: g_auction_info [ i ] [ g_type ] = 1 ;
					case 7,8: g_auction_info [ i ] [ g_type ] = 2 ;
					case 9: g_auction_info [ i ] [ g_type ] = 3 ;
					case 10: g_auction_info [ i ] [ g_type ] = 4 ;
				}
				
				new _g_type = g_auction_info [ i ] [ g_type ] ;
	            if ( _g_type == 0 ) g_auction_info [ i ] [ g_bet ] = random ( 250000 ) + 150000 ;
	            else if ( _g_type == 1 ) g_auction_info [ i ] [ g_bet ] = random ( 500000 ) + 150000 ;
	            else if ( _g_type == 2 ) g_auction_info [ i ] [ g_bet ] = random ( 1000000 ) + 1500000 ;
	            else if ( _g_type == 3 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;
	            else if ( _g_type == 4 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;

	            for ( new c = 0 ; c < MAX_AUCTION_GARAGES_SLOT ; c ++ )
	            {
	                g_auction_info [ i ] [ g_slot ] [ c ] = -1 ;
	            }

	            g_auction_info [ i ] [ g_bet_id ] = -1 ;
	            g_auction_info [ i ] [ g_time ] = DEF_GARAGE_TIME ;
	            g_auction_info [ i ] [ g_status ] = 0 ;

	            create_g_auction_slot ( i ) ;
	            garage_war_status [ 1 ] = 1 ;

				format ( con_string, sizeof con_string, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Начальная ставка: {"#col_all"}%s"valute_title_"\n{"#cWH"}До конца торгов: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ), g_auction_info [ i ] [ g_time ] ) ;
				UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, con_string ) ;
			}
	    }
	    else if ( garage_war_time [ 1 ] == 1 )
	    {
	        garage_war_status [ 1 ] = 0 ;
	        garage_war_time [ 1 ] = random ( GARAGE_AUCTION_TIME ) + ( GARAGE_AUCTION_TIME * 2 ) ;
	    }
	}
	
	if ( garage_war_status [ 1 ] == 1 )
    {
		new con_string [ 227 + MAX_PLAYER_NAME ] ;
		for ( new i = MAX_FIRST_PORT ; i < MAX_TWO_PORT ; i ++ )
	    {
	        if ( g_auction_info [ i ] [ g_time ] > 1 )
	        {
	            g_auction_info [ i ] [ g_time ] -- ;

	            if ( g_auction_info [ i ] [ g_status ] )
	            {
	                if ( g_auction_info [ i ] [ g_time ] == 1 )
	                {
						UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, "** Контейнер **\n\n{"#cRD"}Аукцион не начат" ) ;

						g_auction_info [ i ] [ g_time ] =
						g_auction_info [ i ] [ g_status ] = 0 ;
						g_auction_info [ i ] [ g_bet_id ] = -1 ;
						continue ;
	                }

					format ( con_string, 170, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Победитель: {"#col_all"}%s\n{"#cWH"}До закрытия: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], g_auction_info [ i ] [ g_bet_name ], g_auction_info [ i ] [ g_time ] ) ;
					UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, con_string ) ;
	                continue ;
	            }
	            else
	            {
		            if ( g_auction_info [ i ] [ g_time ] == 1 )
		            {
		                if ( g_auction_info [ i ] [ g_bet_id ] == -1 )
						{
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, "** Контейнер **\n\n{"#cRD"}Аукцион не начат" ) ;

							g_auction_info [ i ] [ g_time ] =
							g_auction_info [ i ] [ g_status ] = 0 ;
							g_auction_info [ i ] [ g_bet_id ] = -1 ;
							continue ;
		                }
		                else
		                {
		                    new player_id = g_auction_info [ i ] [ g_bet_id ] ;
							if ( p_info [ player_id ] [ money ] < g_auction_info [ i ] [ g_bet ] )
							{
							    g_auction_info [ i ] [ g_bet_id ] = -1 ;
							    g_auction_info [ i ] [ g_status ] = 0 ;
								g_auction_info [ i ] [ g_time ] = DEF_GARAGE_TIME ;
								continue ;
							}

			                g_auction_info [ i ] [ g_status ] = 1 ;
							g_auction_info [ i ] [ g_time ] = DEF_GARAGE_TIME ;

							give_money ( player_id, -g_auction_info [ i ] [ g_bet ] ) ;
		            		insert_money_log ( player_id, INVALID_PLAYER_ID, -g_auction_info [ i ] [ g_bet ], "аукцион контейнеров" ) ;

							format ( con_string, 170, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Победитель: {"#col_all"}%s\n{"#cWH"}До закрытия: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], g_auction_info [ i ] [ g_bet_name ], g_auction_info [ i ] [ g_time ] ) ;
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, con_string ) ;

							format ( con_string, 90, "Вы выйграли контейнер на аукционе. Ваша ставка: {"#col_all"}%s"valute_title"{"#cOR"}.", GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ) ) ;
							SendClientMessage ( player_id, col_orange, con_string ) ;
							continue ;
						}
		            }
					else
					{
						if ( g_auction_info [ i ] [ g_bet_id ] != -1 )
						{
							format ( con_string, sizeof con_string, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Последняя ставка: {"#col_all"}%s"valute_title_"\n{"#cWH"}Ставка от: {"#col_all"}%s\n{"#cWH"}До конца торгов: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ), g_auction_info [ i ] [ g_bet_name ], g_auction_info [ i ] [ g_time ] ) ;
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, con_string ) ;
						}
						else
						{
							format ( con_string, 160, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Начальная ставка: {"#col_all"}%s"valute_title_"\n{"#cWH"}До конца торгов: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ), g_auction_info [ i ] [ g_time ] ) ;
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, con_string ) ;
						}
					}
				}
	        }
	    }
	}
	return 1 ;
}

stock show_g_auction_item ( playerid, item_id )
{
    new con_id = player_container_id [ playerid ],
		_price = 0,
		_price_old = 0 ;
		
	new _slot = g_auction_info [ con_id ] [ g_slot ] [ item_id ] ;
	if ( garage_item [ _slot ] [ gar_type ] == GARAGE_RENDER_SKIN ) _price = item_price ( garage_item [ _slot ] [ gar_model ] + skin_cross ), _price_old = floatround ( ( item_price ( garage_item [ _slot ] [ gar_model ] + skin_cross ) * sell_percent ) / 100 ) ;
	else _price = item_price ( garage_item [ _slot ] [ gar_model ] ), _price_old = floatround ( ( item_price ( garage_item [ _slot ] [ gar_model ] ) * sell_percent ) / 100 ) ;

	new con_string [ 172 + 9 + 9 ] ;
	format ( con_string, sizeof con_string, "- Государственная стоимость: {"#cGN"}%s"valute_title_"\n{"#cWH"}- Стоимость на складах: {"#cGN"}%s"valute_title_" (-%d проц.)\n \n{"#cBL"}1. {"#cWH"}Продать складу\n{"#cBL"}2. {"#cWH"}Оставить себе", GetPlayerCashValueToSmile ( _price ), GetPlayerCashValueToSmile ( _price_old ), 100 - sell_percent ) ;
	show_dialog ( playerid, d_g_auction_item_select, DIALOG_STYLE_LIST, "{"#cBHD"}Контейнер", con_string, "Далее", "Закрыть" ) ;
	SetPVarInt ( playerid, "price_old", _price_old ) ;
	SetPVarInt ( playerid, "slot_id", item_id ) ;
	return 1 ;
}

stock show_g_auction ( playerid, i )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 200, "{FFFFFF}За данный контейнер сейчас проходят торги, предложите свою цену\n\
								которая будет превышать предыдущую.\n\n\
								Текущая цена контейнера на торгах: {"#col_all"}%s"valute_title_"", GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ) ) ;
   	show_dialog ( playerid, d_g_auction, DIALOG_STYLE_INPUT, "{"#cBHD"}Контейнер", global_string, "Далее", "Закрыть" ) ;
	return 1 ;
}

stock show_g_auction_accept ( playerid, _value )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 200, "{FFFFFF}Ваша ставка: {"#col_all"}%s"valute_title_"\n\
								{FFFFFF}Текущая цена контейнера на торгах: {"#col_all"}%s"valute_title_"", GetPlayerCashValueToSmile ( _value ), GetPlayerCashValueToSmile ( g_auction_info [ player_container_id [ playerid ] ] [ g_bet ] ) ) ;
   	show_dialog ( playerid, d_g_auction_sucess, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Контейнер", global_string, "Принять", "Закрыть" ) ;
	return 1 ;
}

stock show_g_auction_winner_dialog ( playerid, i )
{
	global_string [ 0 ] = EOS ;
    new line_string [ 64 ], count_con = 0, _slot, _item ;
	for ( new c = 0 ; c < MAX_AUCTION_GARAGES_SLOT ; c ++ )
	{
		_slot = g_auction_info [ i ] [ g_slot ] [ c ] ;
		if ( _slot == -1 ) continue ;

		set_player_listitem_values ( playerid, count_con, c ) ;

		count_con ++ ;

		_item = garage_item [ _slot ] [ gar_model ] ;
		if ( garage_item [ _slot ] [ gar_type ] == GARAGE_RENDER_SKIN ) format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s\n", count_con, item_name ( _item + skin_cross ) ) ;
		else format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s\n", count_con, item_name ( _item ) ) ;
		strcat ( global_string, line_string ) ;
	}
	if ( count_con == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Контейнер пуст." ) ;
	show_dialog ( playerid, d_g_auction_item, DIALOG_STYLE_LIST, "{"#cBHD"}Контейнер", global_string, "Далее", "Закрыть" ) ;
	return 1 ;
}

stock quit_g_auction ( playerid )
{
	player_auction_bet [ playerid ] = false ;
	player_container_id [ playerid ] = -1 ;
	
	new bool: _ins_mes = false ;
	for ( new i = 0 ; i < MAX_AUCTION_GARAGES ; i ++ )
	{
    	if ( g_auction_info [ i ] [ g_bet_id ] == playerid )
        {
            if ( g_auction_info [ i ] [ g_status ] )
            {
				new _g_item, _inv_item, _give_item ;
				for ( new item_id = 0 ; item_id < MAX_AUCTION_GARAGES_SLOT ; item_id ++ )
				{
					_g_item = g_auction_info [ i ] [ g_slot ] [ item_id ] ;
					if ( _g_item == -1 ) continue ;
					
					_inv_item = garage_item [ _g_item ] [ gar_model ] ;
					if ( garage_item [ _g_item ] [ gar_type ] == GARAGE_RENDER_SKIN ) 
					{
						_give_item = _inv_item + skin_cross ;
						give_player_item_prise ( playerid, _inv_item + skin_cross, 1 ) ;
					}
					else
					{
						if ( _inv_item == 1212 )
						{
							new _random = RandomEx ( 4, 9 ) ;
							_give_item = _random ;
							give_player_item_prise ( playerid, _give_item, 1 ) ;
						}
						else if ( _inv_item == 1274 )
						{
							new _random = RandomEx ( 15, 23 ) ;
							_give_item = _random ;
							give_player_item_prise ( playerid, RandomEx ( 15, 23 ), 1 ) ;
						}
						else if ( _inv_item == 1582 )
						{
							new _random = RandomEx ( 40, 45 ) ;
							_give_item = _random ;
							give_player_item_prise ( playerid, RandomEx ( 40, 45 ), 1 ) ;
						}
						else if ( _inv_item == 348 )
						{
							new _random = RandomEx ( 88, 94 ) ;
							_give_item = _random ;
							give_player_item_prise ( playerid, RandomEx ( 88, 94 ), 1 ) ;
						}
						else if ( _inv_item == 2684 )
						{
							new _random = RandomEx ( 84, 87 ) ;
							_give_item = _random ;
							give_player_item_prise ( playerid, RandomEx ( 84, 87 ), 1 ) ;
						}
						else if ( _inv_item == 11738 )
						{
							_give_item = 145 ;
							give_player_item_prise ( playerid, 145, RandomEx ( 1, 3 ) ) ;
						}
						else if ( _inv_item == 1575 || _inv_item == 2061 )
						{
							new drugs_count = RandomEx ( 5, 100 ) ;
							_give_item = 153 ;
							give_player_item_prise ( playerid, 153, drugs_count ) ;
							give_player_item_prise ( playerid, 154, drugs_count ) ;
						}
						else _give_item = _inv_item, give_player_item_prise ( playerid, _inv_item, 1 ) ;
					}

					if ( _give_item != -1 )
					{
						global_string [ 0 ] = EOS ;
						format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _give_item ) ) ;
						SendClientMessage ( playerid, col_yellow, global_string ) ;
					}
					
					g_auction_info [ i ] [ g_slot ] [ item_id ] = -1 ;
				}
				
				if ( _ins_mes == false )
				{
					insert_debtor_message ( "Порт", "{"#cGInfo"}* {"#cWH"}Весь выйгрыш с контейнера перенесён в подарочный инвентарь (/mm - Инвентарь)", p_info [ playerid ] [ id ] ) ;
					
					_ins_mes = true ;
				}
			
            	UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, "** Контейнер **\n\n{"#cRD"}Аукцион не начат" ) ;

				g_auction_info [ i ] [ g_time ] =
				g_auction_info [ i ] [ g_status ] = 0 ;
				g_auction_info [ i ] [ g_bet_id ] = -1 ;
				continue ;
            }
            else
            {
				new _g_type = g_auction_info [ i ] [ g_type ] ;
                if ( _g_type == 0 ) g_auction_info [ i ] [ g_bet ] = random ( 250000 ) + 150000 ;
	            else if ( _g_type == 1 ) g_auction_info [ i ] [ g_bet ] = random ( 500000 ) + 150000 ;
	            else if ( _g_type == 2 ) g_auction_info [ i ] [ g_bet ] = random ( 1000000 ) + 1500000 ;
	            else if ( _g_type == 3 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;
	            else if ( _g_type == 4 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;
	            
	            g_auction_info [ i ] [ g_status ] = 0 ;
				g_auction_info [ i ] [ g_time ] = DEF_GARAGE_TIME ;
				g_auction_info [ i ] [ g_bet_id ] = -1 ;

	           	new con_string [ 122 + 16 + 9 + 9 ] ;
				format ( con_string, sizeof con_string, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#cLY"}%s\n{"#cWH"}Начальная ставка: {"#cGN"}%s"valute_title_"\n{"#cWH"}До конца торгов: {"#cRD"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ), g_auction_info [ i ] [ g_time ] ) ;
				UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, con_string ) ;
				continue ;
			}
        }
	}
	return 1 ;
}

stock create_g_auction_slot ( _con_id )
{
	new _g_type = g_auction_info [ _con_id ] [ g_type ] ;
	if ( _g_type == 0 )
	{
	    g_auction_info [ _con_id ] [ g_slot ] [ 0 ] = g_auction_random_item ( 0, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 1 ] = g_auction_random_item ( 1, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 2 ] = g_auction_random_item ( 2, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 3 ] = g_auction_random_item ( 3, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 4 ] = g_auction_random_item ( 4, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 5 ] = g_auction_random_item ( 5, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 6 ] = g_auction_random_item ( 6, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 7 ] = g_auction_random_item ( 7, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 8 ] = g_auction_random_item ( 8, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 9 ] = g_auction_random_item ( 9, 1 ) ;
	}
	else if ( _g_type == 1 )
	{
	    g_auction_info [ _con_id ] [ g_slot ] [ 0 ] = g_auction_random_item ( 0, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 1 ] = g_auction_random_item ( 1, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 2 ] = g_auction_random_item ( 2, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 3 ] = g_auction_random_item ( 3, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 4 ] = g_auction_random_item ( 4, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 5 ] = g_auction_random_item ( 5, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 6 ] = g_auction_random_item ( 6, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 7 ] = g_auction_random_item ( 7, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 8 ] = g_auction_random_item ( 8, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 9 ] = g_auction_random_item ( 9, 1 ) ;
	}
	else if ( _g_type == 2 )
	{
	    g_auction_info [ _con_id ] [ g_slot ] [ 0 ] = g_auction_random_item ( 0, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 1 ] = g_auction_random_item ( 1, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 2 ] = g_auction_random_item ( 2, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 3 ] = g_auction_random_item ( 3, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 4 ] = g_auction_random_item ( 4, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 5 ] = g_auction_random_item ( 5, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 6 ] = g_auction_random_item ( 6, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 7 ] = g_auction_random_item ( 7, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 8 ] = g_auction_random_item ( 8, 2 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 9 ] = g_auction_random_item ( 9, 2 ) ;
	}
	else if ( _g_type == 3 )
	{
	    g_auction_info [ _con_id ] [ g_slot ] [ 0 ] = g_auction_random_item ( 0, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 1 ] = g_auction_random_item ( 1, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 2 ] = g_auction_random_item ( 2, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 3 ] = g_auction_random_item ( 3, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 4 ] = g_auction_random_item ( 4, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 5 ] = g_auction_random_item ( 5, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 6 ] = g_auction_random_item ( 6, 2 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 7 ] = g_auction_random_item ( 7, 2 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 8 ] = g_auction_random_item ( 8, 2 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 9 ] = g_auction_random_item ( 9, 2 ) ;
	}
	else if ( _g_type == 4 )
	{
		new _prise_id = -1, donate_count = random ( 50000 ), random_item, _count = 0 ;
		if ( donate_count >= 0 && donate_count <= 30000 )random_item = 0 ;
		else if ( donate_count >= 30001 && donate_count <= 42000 )random_item = 1 ;
		else if ( donate_count >= 42001 && donate_count <= 46000 )random_item = 2 ;
		else if ( donate_count >= 46001 && donate_count <= 50000 )random_item = 3 ;
		
		_retry_garage_random:
		for ( new i = 0 ; i < MAX_GARAGE_AUCTION_ITEM ; i ++ )
		{
			if ( garage_item [ i ] [ gar_type ] != GARAGE_RENDER_CAR ) continue ;
			
			if ( random_item == 0 )
			{
				if ( garage_item [ i ] [ gar_rare ] != GAR_ITEM_COMMON ) continue ;
			
				if ( random ( 5 ) == 1 )
				{
					_prise_id = i ;
				}
			}
			else if ( random_item == 1 )
			{
				if ( garage_item [ i ] [ gar_rare ] != GAR_ITEM_RARE ) continue ;
			
				if ( random ( 5 ) == 1 )
				{
					_prise_id = i ;
				}
			}
			else if ( random_item == 2 )
			{
				if ( garage_item [ i ] [ gar_rare ] != GAR_ITEM_EPIC ) continue ;
			
				if ( random ( 5 ) == 1 )
				{
					_prise_id = i ;
				}
			}
			else if ( random_item == 3 )
			{
				if ( garage_item [ i ] [ gar_rare ] != GAR_ITEM_LEGENDARY ) continue ;
			
				if ( random ( 5 ) == 1 )
				{
					_prise_id = i ;
				}
			}
		}
		
		if ( _count >= 10 )
		{
			for ( new i = 0 ; i < MAX_GARAGE_AUCTION_ITEM ; i ++ )
			{
				if ( garage_item [ i ] [ gar_type ] != GARAGE_RENDER_CAR ) continue ;
				
				_prise_id = i ;
				break ;
			}
		}
		
		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_garage_random ;
		}
		
		for ( new i = 0 ; i < MAX_AUCTION_GARAGES_SLOT ; i ++ )
		{
			if ( g_auction_info [ _con_id ] [ g_slot ] [ i ] != -1 ) continue ;
			
			g_auction_info [ _con_id ] [ g_slot ] [ i ] = _prise_id ;
			break ;
		}
		
		if ( random ( 3 ) == 1 )
		{
			_prise_id = -1 ;
			donate_count = random ( 50000 ) ;
			_count = 0 ;
			if ( donate_count >= 0 && donate_count <= 30000 )random_item = 0 ;
			else if ( donate_count >= 30001 && donate_count <= 42000 )random_item = 1 ;
			else if ( donate_count >= 42001 && donate_count <= 46000 )random_item = 2 ;
			else if ( donate_count >= 46001 && donate_count <= 50000 )random_item = 3 ;
			goto _retry_garage_random ;
		}
	}
	return 1 ;
}

stock g_auction_random_item ( _slot_container, _type )
{
	if ( _slot_container >= 4 && _slot_container <= 7 )
	{
		if ( random ( 3 ) != 1 ) return 0 ;
	}
	else if ( _slot_container > 7 )
	{
		if ( random ( 5 ) != 1 ) return 0 ;
	}
	
	new _prise_id = -1, donate_count = random ( 50000 ), random_item, _count = 0 ;
	if ( _type == 0 )
	{
		if ( donate_count >= 0 && donate_count <= 40000 )random_item = 0 ;
		else if ( donate_count >= 40001 && donate_count <= 42000 )random_item = 1 ;
		else if ( donate_count >= 42001 && donate_count <= 46000 )random_item = 2 ;
		else if ( donate_count >= 46001 && donate_count <= 50000 )random_item = 3 ;
	}
	else if ( _type == 1 )
	{
		if ( donate_count >= 0 && donate_count <= 35000 )random_item = 0 ;
		else if ( donate_count >= 35001 && donate_count <= 42000 )random_item = 1 ;
		else if ( donate_count >= 42001 && donate_count <= 46000 )random_item = 2 ;
		else if ( donate_count >= 46001 && donate_count <= 50000 )random_item = 3 ;
	}
	else
	{
		if ( donate_count >= 0 && donate_count <= 30000 )random_item = 0 ;
		else if ( donate_count >= 30001 && donate_count <= 42000 )random_item = 1 ;
		else if ( donate_count >= 42001 && donate_count <= 46000 )random_item = 2 ;
		else if ( donate_count >= 46001 && donate_count <= 50000 )random_item = 3 ;
	}
		
	_retry_garage_random:
	for ( new i = 0 ; i < MAX_GARAGE_AUCTION_ITEM ; i ++ )
	{
		if ( random_item == 0 )
		{
			if ( garage_item [ i ] [ gar_rare ] != GAR_ITEM_COMMON ) continue ;
			
			if ( random ( 5 ) == 1 )
			{
				_prise_id = i ;
			}
		}
		else if ( random_item == 1 )
		{
			if ( garage_item [ i ] [ gar_rare ] != GAR_ITEM_RARE ) continue ;
			
			if ( random ( 5 ) == 1 )
			{
				_prise_id = i ;
			}
		}
		else if ( random_item == 2 )
		{
			if ( garage_item [ i ] [ gar_rare ] != GAR_ITEM_EPIC ) continue ;
			
			if ( random ( 5 ) == 1 )
			{
				_prise_id = i ;
			}
		}
		else if ( random_item == 3 )
		{
			if ( garage_item [ i ] [ gar_rare ] != GAR_ITEM_LEGENDARY ) continue ;
			
			if ( random ( 5 ) == 1 )
			{
				_prise_id = i ;
			}
		}
	}
		
	if ( _count >= 10 )
	{
		_prise_id = 0 ;
	}
		
	if ( _prise_id == -1 && _count < 10 )
	{
		_count ++ ;
		goto _retry_garage_random ;
	}

	return _prise_id ;
}

CMD:garage_wars ( playerid, params [ ] )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	if ( ! GetString ( p_info [ playerid ] [ name ], founder_name ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, Вам данная функция не доступна." ) ;
	if ( sscanf ( params, "d", params [ 0 ] ) ) return SendClientMessage(playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}Используйте: /garage_wars [id]");
	if ( params [ 0 ] != -1 && params [ 0 ] > MAX_AUCTION_GARAGES - 1 ) return SendClientMessage(playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}Не правильно указана нумерация.");
	if ( params [ 0 ] == -1 )
	{
	    for ( new i = 0 ; i < MAX_AUCTION_GARAGES ; i ++ )
	    {
	        if ( g_auction_info [ i ] [ g_time ] ) continue ;

            g_auction_info [ i ] [ g_type ] = random ( 5 ) ;

            if ( g_auction_info [ i ] [ g_type ] == 0 ) g_auction_info [ i ] [ g_bet ] = random ( 250000 ) + 150000 ;
            else if ( g_auction_info [ i ] [ g_type ] == 1 ) g_auction_info [ i ] [ g_bet ] = random ( 500000 ) + 150000 ;
            else if ( g_auction_info [ i ] [ g_type ] == 2 ) g_auction_info [ i ] [ g_bet ] = random ( 1000000 ) + 1500000 ;
            else if ( g_auction_info [ i ] [ g_type ] == 3 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;
            else if ( g_auction_info [ i ] [ g_type ] == 4 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;

            for ( new c = 0 ; c < MAX_AUCTION_GARAGES_SLOT ; c ++ )
            {
                g_auction_info [ i ] [ g_slot ] [ c ] = -1 ;
            }

            g_auction_info [ i ] [ g_bet_id ] = -1 ;
            g_auction_info [ i ] [ g_time ] = DEF_GARAGE_TIME ;
            g_auction_info [ i ] [ g_status ] = 0 ;

            create_g_auction_slot ( i ) ;
            if ( i < MAX_FIRST_PORT ) 
			{
				garage_war_status [ 0 ] = 1 ;
				garage_war_time [ 0 ] = ( random ( GARAGE_AUCTION_TIME ) * 2 ) + GARAGE_AUCTION_TIME ;
			}
			else 
			{
				garage_war_status [ 1 ] = 1 ;
				garage_war_time [ 1 ] = random ( GARAGE_AUCTION_TIME ) + ( GARAGE_AUCTION_TIME * 2 ) ;
			}

			new con_string [ 122 + 16 + 9 + 9 ] ;
			format ( con_string, sizeof con_string, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#cLY"}%s\n{"#cWH"}Начальная ставка: {"#cGN"}%s"valute_title_"\n{"#cWH"}До конца торгов: {"#cRD"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ), g_auction_info [ i ] [ g_time ] ) ;
			UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_blue, con_string ) ;
		}
	}
	else
	{
	    if ( g_auction_info [ params [ 0 ] ] [ g_time ] ) return SendClientMessage ( playerid, col_gray, "{"#cRD"}* {"#cGRInfo"}Данный контейнер уже заспавнен." ) ;

        g_auction_info [ params [ 0 ] ] [ g_type ] = random ( 5 ) ;

        if ( g_auction_info [ params [ 0 ] ] [ g_type ] == 0 ) g_auction_info [ params [ 0 ] ] [ g_bet ] = random ( 250000 ) + 150000 ;
        else if ( g_auction_info [ params [ 0 ] ] [ g_type ] == 1 ) g_auction_info [ params [ 0 ] ] [ g_bet ] = random ( 500000 ) + 150000 ;
        else if ( g_auction_info [ params [ 0 ] ] [ g_type ] == 2 ) g_auction_info [ params [ 0 ] ] [ g_bet ] = random ( 1000000 ) + 1500000 ;
        else if ( g_auction_info [ params [ 0 ] ] [ g_type ] == 3 ) g_auction_info [ params [ 0 ] ] [ g_bet ] = random ( 5000000 ) + 1500000 ;
        else if ( g_auction_info [ params [ 0 ] ] [ g_type ] == 4 ) g_auction_info [ params [ 0 ] ] [ g_bet ] = random ( 5000000 ) + 1500000 ;

        for ( new c = 0 ; c < MAX_AUCTION_GARAGES_SLOT ; c ++ )
        {
        	g_auction_info [ params [ 0 ] ] [ g_slot ] [ c ] = -1 ;
        }

        g_auction_info [ params [ 0 ] ] [ g_bet_id ] = -1 ;
        g_auction_info [ params [ 0 ] ] [ g_time ] = DEF_GARAGE_TIME ;
        g_auction_info [ params [ 0 ] ] [ g_status ] = 0 ;

        create_g_auction_slot ( params [ 0 ] ) ;
        if ( params [ 0 ] < MAX_FIRST_PORT ) garage_war_status [ 0 ] = 1 ;
		else garage_war_status [ 1 ] = 1 ;

		new con_string [ 122 + 16 + 9 + 9 ] ;
		format ( con_string, sizeof con_string, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#cLY"}%s\n{"#cWH"}Начальная ставка: {"#cGN"}%s"valute_title_"\n{"#cWH"}До конца торгов: {"#cRD"}%d сек.", params [ 0 ], garage_auction_name [ g_auction_info [ params [ 0 ] ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ params [ 0 ] ] [ g_bet ] ), g_auction_info [ params [ 0 ] ] [ g_time ] ) ;
		UpdateDynamic3DTextLabelText ( g_auction_info [ params [ 0 ] ] [ g_text ], col_blue, con_string ) ;
	}
	return 1 ;
}

stock garage_auction_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_g_auction:
	    {
	        if ( ! response ) return 1 ;
	        
	        new con_id = player_container_id [ playerid ],
				value = strval ( inputtext ),
				con_bet = g_auction_info [ con_id ] [ g_bet ] ;

			if ( g_auction_info [ con_id ] [ g_status ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Битва за контейнер уже окончена." ) ;
			if ( value <= con_bet )
	        {
	            show_g_auction ( playerid, con_id ) ;
	            SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ставка не может быть меньше текущей." ) ;
	            return 1 ;
	        }
	        if ( p_info [ playerid ] [ money ] < con_bet || p_info [ playerid ] [ money ] < value )
	        {
	            show_g_auction ( playerid, con_id ) ;
	            SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас не достаточно средств для повышение ставки." ) ;
	            return 1 ;
	        }
	        
			show_g_auction_accept ( playerid, value ) ;
			SetPVarInt ( playerid, "d_g_auction", value ) ;
			return 1 ;
	    }
		case d_g_auction_sucess:
		{
	        if ( ! response )
			{
				DeletePVar ( playerid, "d_g_auction" ) ;
				return 1 ;
			}
	        
	        new con_id = player_container_id [ playerid ],
				value = GetPVarInt ( playerid, "d_g_auction" ),
				con_bet = g_auction_info [ con_id ] [ g_bet ] ;

			if ( g_auction_info [ con_id ] [ g_status ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Битва за контейнер уже окончена." ) ;
			if ( value <= con_bet )
	        {
	            show_g_auction ( playerid, con_id ) ;
	            SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ставка не может быть меньше текущей." ) ;
	            return 1 ;
	        }
	        if ( p_info [ playerid ] [ money ] < con_bet || p_info [ playerid ] [ money ] < value )
	        {
	            show_g_auction ( playerid, con_id ) ;
	            SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас не достаточно средств для повышение ставки." ) ;
	            return 1 ;
	        }
			
			new _count = 0 ;
			for ( new i = 0 ; i < MAX_AUCTION_GARAGES ; i ++ )
			{
				if ( g_auction_info [ i ] [ g_bet_id ] == -1 ) continue ;
				if ( g_auction_info [ i ] [ g_bet_id ] != playerid ) continue ;
				
				_count ++ ;
			}
			if ( _count >= 2 )
	        {
	            show_g_auction ( playerid, con_id ) ;
	            SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Поставить можно максимум на 2 контейнера одновременно." ) ;
	            return 1 ;
	        }

			if ( g_auction_info [ con_id ] [ g_time ] < 30 ) g_auction_info [ con_id ] [ g_time ] += 15 ;
	        g_auction_info [ con_id ] [ g_bet_id ] = playerid ;
	        g_auction_info [ con_id ] [ g_bet ] = value ;
			format ( g_auction_info [ con_id ] [ g_bet_name ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;
			
			new scm_string [ 128 ] ;
			format ( scm_string, sizeof ( scm_string ), "%s назначил цену в {"#col_all"}%s"valute_title_" {"#cOR"}за %d контейнер.", p_info [ playerid ] [ name ], GetPlayerCashValueToSmile ( value ), con_id + 1 ) ;
			send_world_message ( playerid, 20.0, scm_string, col_orange, col_orange, col_orange, false ) ;
			
			/*foreach(new i: streamed_players[playerid])
			{
				if ( p_t_info [ i ] [ p_dialog ] != d_g_auction ) continue ;
				if ( con_id != GetPVarInt ( i, "con_id" ) ) continue ;
				
				show_g_auction ( i, con_id ) ;
			}*/
			
			give_event_progress ( playerid, THE_GARAGE_WARS, value ) ;
			DeletePVar ( playerid, "d_g_auction" ) ;
			return 1 ;
		}
	    case d_g_auction_item:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
		        return 1 ;
		    }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			
			clear_player_listitem_values ( playerid ) ;
		    
		    SetPVarInt ( playerid, "slot_id", select_id ) ;
		    show_g_auction_item ( playerid, select_id ) ;
			return 1 ;
	    }
	    case d_g_auction_item_select:
	    {
	        if ( ! response )
	        {
	            new con_id = player_container_id [ playerid ] ;
	            
	            DeletePVar ( playerid, "slot_id" ) ;
	            DeletePVar ( playerid, "price_old" ) ;
	            
	            show_g_auction_winner_dialog ( playerid, con_id ) ;
	            return 1 ;
	        }
	        
	        if ( listitem < 3 )
	        {
	            new con_id = player_container_id [ playerid ] ;
	            
	            DeletePVar ( playerid, "slot_id" ) ;
	            DeletePVar ( playerid, "price_old" ) ;

	            show_g_auction_winner_dialog ( playerid, con_id ) ;
	            return 1 ;
	        }
	        
	        if ( listitem == 3 )
	        {
	        	new _price = GetPVarInt ( playerid, "price_old" ),
					item_id = GetPVarInt ( playerid, "slot_id" ),
					con_id = player_container_id [ playerid ] ;
	        	
	        	DeletePVar ( playerid, "slot_id" ) ;
				DeletePVar ( playerid, "price_old" ) ;
				
				g_auction_info [ con_id ] [ g_slot ] [ item_id ] = -1 ;
	        	
	        	give_money ( playerid, _price ) ;
            	insert_money_log ( playerid, INVALID_PLAYER_ID, _price, "продажа с контейнера" ) ;
				
				if ( player_device { playerid } == 2 ) show_packet_container ( playerid, 2, 2, 0 ) ;
            	return 1 ;
	        }
	        else if ( listitem == 4 )
	        {
	            new item_id = GetPVarInt ( playerid, "slot_id" ),
					con_id = player_container_id [ playerid ],
					_g_item = g_auction_info [ con_id ] [ g_slot ] [ item_id ],
					_inv_item = garage_item [ _g_item ] [ gar_model ],
					_give_item ;
	            
	            DeletePVar ( playerid, "slot_id" ) ;

				if ( garage_item [ _g_item ] [ gar_type ] == GARAGE_RENDER_SKIN ) 
				{
					_give_item = _inv_item + skin_cross ;
					give_player_item_prise ( playerid, _inv_item + skin_cross, 1 ) ;
				}
				else
				{
					if ( _inv_item == 1212 )
					{
						new _random = RandomEx ( 4, 9 ) ;
						_give_item = _random ;
						give_player_item_prise ( playerid, _give_item, 1 ) ;
					}
					else if ( _inv_item == 1274 )
					{
						new _random = RandomEx ( 15, 23 ) ;
						_give_item = _random ;
						give_player_item_prise ( playerid, RandomEx ( 15, 23 ), 1 ) ;
					}
					else if ( _inv_item == 1582 )
					{
						new _random = RandomEx ( 40, 45 ) ;
						_give_item = _random ;
						give_player_item_prise ( playerid, RandomEx ( 40, 45 ), 1 ) ;
					}
					else if ( _inv_item == 348 )
					{
						new _random = RandomEx ( 88, 94 ) ;
						_give_item = _random ;
						give_player_item_prise ( playerid, RandomEx ( 88, 94 ), 1 ) ;
					}
					else if ( _inv_item == 2684 )
					{
						new _random = RandomEx ( 84, 87 ) ;
						_give_item = _random ;
						give_player_item_prise ( playerid, RandomEx ( 84, 87 ), 1 ) ;
					}
					else if ( _inv_item == 11738 )
					{
						_give_item = 145 ;
						give_player_item_prise ( playerid, 145, RandomEx ( 1, 3 ) ) ;
					}
					else if ( _inv_item == 1575 || _inv_item == 2061 )
					{
						new drugs_count = RandomEx ( 5, 100 ) ;
						_give_item = 153 ;
						give_player_item_prise ( playerid, 153, drugs_count ) ;
						give_player_item_prise ( playerid, 154, drugs_count ) ;
					}
					else _give_item = _inv_item, give_player_item_prise ( playerid, _inv_item, 1 ) ;
				}

				if ( _give_item != -1 )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _give_item ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}

				g_auction_info [ con_id ] [ g_slot ] [ item_id ] = -1 ;
				if ( player_device { playerid } == 2 ) show_packet_container ( playerid, 2, 2, 0 ) ;
	        }
	    }
	}
	return 0 ;
}

stock garage_auction_DynamicPickup ( playerid, pickupid )
{
	switch ( pick_info [ pickupid ] [ pick_type ] )
	{
		case pick_type_garage_auction:
		{
			new i = pick_info [ pickupid ] [ pick_item ] ;
			if ( g_auction_info [ i ] [ g_time ] < 1 ) return 1 ;
			if ( g_auction_info [ i ] [ g_status ] )
			{
				if ( g_auction_info [ i ] [ g_bet_id ] == playerid )
				{
					player_container_id [ playerid ] = i ;
					SetPVarInt ( playerid, "tp_area_used", 1 ) ;
					
					if ( player_device { playerid } == 2 )
					{
						new _count = 0 ;
						for ( new q = 0 ; q < MAX_AUCTION_GARAGES_SLOT ; q ++ )
						{
							if ( g_auction_info [ i ] [ g_slot ] [ q ] == -1 ) continue ;
							
							_count ++ ;
						}
						
						if ( ! _count )
						{
							send_check_cinfo ( playerid, "В контейнере нет предметов!", 0, 300, CINFO_GARAGE_AUCTION_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
							return 1 ;
						}
						
						new _str [ 24 ] ;
						format ( _str, sizeof _str, " %d предметов", _count ) ;
						containerPrizeShow ( playerid, _str ) ;
						containerPrizeAddItem ( playerid, _count, i ) ;
						toggle_controlable ( playerid, false ) ;
				
						TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
						TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
						TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
						TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
						TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
						TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
					}
					else show_g_auction_winner_dialog ( playerid, i ) ;
					return 1 ;
				}
			}
			else
			{
				player_container_id [ playerid ] = i ;
				SetPVarInt ( playerid, "tp_area_used", 1 ) ;
				
				if ( player_device { playerid } == 2 )
				{
					containerShow ( playerid ) ;
					containerAddItem ( playerid ) ;
					
					new _str2 [ 32 ], _str3 [ 12 ] ;
					format ( _str2, sizeof _str2, "%s"valute_title_"", GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ) ) ;
					format ( _str3, sizeof _str3, "%d", g_auction_info [ i ] [ g_time ] ) ;
					if ( g_auction_info [ i ] [ g_bet_id ] == -1 ) containerUpdateData ( playerid, " ", _str2, _str3, "-", _str2 ) ;
					else containerUpdateData ( playerid, " ", _str2, _str3, g_auction_info [ i ] [ g_bet_name ], _str2 ) ;
					
					toggle_controlable ( playerid, false ) ;
				
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
					TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
				}
				else show_g_auction ( playerid, i ) ;
			}
			return 1 ;
		}
		case pick_type_garage_info:
		{
			for ( new i = 0 ; i < sizeof garage_war_pickup ; i ++ )
			{
				if ( pickupid != garage_war_pickup [ i ] ) continue ;
	
				new garagewars_string [ 68 ] ;
				if ( garage_war_time [ i ] > 900 ) format ( garagewars_string, sizeof garagewars_string, "До начала гаражного аукциона {"#cLY"}%s", convert_time ( garage_war_time [ i ] - 900, TYPE_TIME_SECOND ) ) ;
				else format ( garagewars_string, sizeof garagewars_string, "Гаражный аукцион уже проходит" ) ;
					
				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "\
				{"#cBL"}** Городской порт №%d **\n\n\
				{"#cWH"}%s.\n\n\
				{"#cGRDialog"}* Если Вы выиграете ставку за контейнер и покините игру\n\
				{"#cGRDialog"}* предметы будут отправлены к Вам в инвентарь автоматически.", i + 1, garagewars_string ) ;
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Городской порт", global_string, "Закрыть", "" ) ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

#include <custom/garage_auction>
stock show_packet_container ( playerid, _param, _param2, _param3 )
{
	if ( _param == 1 )
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				containerShowInput ( playerid, false, " ", " ", " " ) ;
				containerHide ( playerid ) ;
				toggle_controlable ( playerid, true ) ;
		
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
				
				player_auction_bet [ playerid ] = false ;
			}
			else if ( _param3 == 1 )
			{
				containerShowInput ( playerid, false, " ", " ", " " ) ;
				player_auction_bet [ playerid ] = false ;
			}
		}
		else if ( _param2 == 1 )
		{
			new _id = player_container_id [ playerid ], _str [ 32 ], _str2 [ 32 ] ;
			format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( g_auction_info [ _id ] [ g_bet ] ) ) ;
			format ( _str2, sizeof _str2, "%s"valute_title_"", GetPlayerCashValueToSmile ( g_auction_info [ _id ] [ g_bet ] + 5000 ) ) ;
			if ( g_auction_info [ _id ] [ g_bet_id ] == -1 ) containerShowInput ( playerid, true, "-", _str, _str2 ) ;
			else containerShowInput ( playerid, true, g_auction_info [ _id ] [ g_bet_name ], _str, _str2 ) ;
			
			player_auction_bet [ playerid ] = true ;
		}
		else if ( _param2 == 2 )
		{
			if ( _param3 < 1 || _param3 > p_info [ playerid ] [ money ] )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 300, CINFO_GARAGE_AUCTION_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			new _id = player_container_id [ playerid ] ;
			if ( g_auction_info [ _id ] [ g_bet ] >= _param3 )
			{
				send_check_cinfo ( playerid, "Сумма должна быть больше текущей ставки!", 0, 300, CINFO_GARAGE_AUCTION_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( g_auction_info [ _id ] [ g_time ] < 30 ) g_auction_info [ _id ] [ g_time ] += 15 ;
			g_auction_info [ _id ] [ g_bet ] = _param3 ;
	        g_auction_info [ _id ] [ g_bet_id ] = playerid ;
			format ( g_auction_info [ _id ] [ g_bet_name ], 32, "%s", p_info [ playerid ] [ name ] ) ;
			containerShowInput ( playerid, false, " ", " ", " " ) ;
			
			new _str2 [ 32 ], _str3 [ 12 ] ;
			format ( _str2, sizeof _str2, "%s"valute_title_"", GetPlayerCashValueToSmile ( g_auction_info [ _id ] [ g_bet ] ) ) ;
			format ( _str3, sizeof _str3, "%d", g_auction_info [ _id ] [ g_time ] ) ;
			containerUpdateData ( playerid, " ", _str2, _str3, g_auction_info [ _id ] [ g_bet_name ], _str2 ) ;
			
			foreach(new i: streamed_players[playerid])
			{
				if ( player_container_id [ i ] != _id ) continue ;

				containerUpdateData ( i, " ", _str2, _str3, g_auction_info [ _id ] [ g_bet_name ], _str2 ) ;
				
				if ( player_auction_bet [ i ] == true )
				{
					containerShowInput ( i, true, g_auction_info [ _id ] [ g_bet_name ], _str2, " " ) ;
				}
			}
		}
	}
	else if ( _param == 2 )
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				containerPrizeHide ( playerid ) ;
				toggle_controlable ( playerid, true ) ;
		
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
			}
		}
		else if ( _param2 == 1 )
		{
			new _id = player_container_id [ playerid ], bool: status = false ;
			for ( new i = 0 ; i < MAX_AUCTION_GARAGES_SLOT ; i ++ )
			{
				new _item = g_auction_info [ _id ] [ g_slot ] [ i ] ;
				if ( _item == -1 ) continue ;
				if ( garage_item [ _item ] [ gar_model ] != _param3 ) continue ;
				
				show_g_auction_item ( playerid, i ) ;
				status = true ;
				break ;
			}
			
			if ( ! status )
			{
				containerPrizeHide ( playerid ) ;
				toggle_controlable ( playerid, true ) ;
		
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
			}
		}
		else if ( _param2 == 2 )
		{
			containerPrizeClear ( playerid ) ;
			
			new _id = player_container_id [ playerid ], _count = 0 ;
			for ( new i = 0 ; i < MAX_AUCTION_GARAGES_SLOT ; i ++ )
			{
				if ( g_auction_info [ _id ] [ g_slot ] [ i ] == -1 ) continue ;
				
				_count ++ ;
			}
			
			if ( ! _count )
			{
				send_check_cinfo ( playerid, "В контейнере нет предметов!", 0, 300, CINFO_GARAGE_AUCTION_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				
				containerPrizeHide ( playerid ) ;
				toggle_controlable ( playerid, true ) ;
		
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
				return 1 ;
			}

			new _str [ 24 ] ;
			format ( _str, sizeof _str, " %d предметов", _count ) ;
			containerPrizeShow ( playerid, _str ) ;
			containerPrizeAddItem ( playerid, _count, _id ) ;
		}
	}
	return 1 ;
}