/*

	Цвета аукциона

*/

#define col_all			CC9900
#define col_content		99CC00
#define col_end			FF9945
 
#define MAX_FIRST_PORT 8
#define MAX_TWO_PORT 12

#define MAX_AUCTION_GARAGES 12
#define MAX_AUCTION_GARAGES_SLOT 6

enum _g_auction
{
	g_id,
	g_object,
	g_start_bet,
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
	"Китай",
	"Германия",
	"Россия",
	"Северная Корея",
	"ОАЭ"
} ;

new Float: g_auction_position_pickup [ MAX_AUCTION_GARAGES ] [ 3 ] =
{
	{ -455.8251, -1751.5906, 44.1259 },
	{ -447.7111, -1756.3820, 44.1259 },
	{ -439.7135, -1762.0918, 44.1259 },
	{ -436.8751, -1751.7883, 44.1259 },
	{ -430.0889, -1739.1133, 44.1259 },
	{ -424.6896, -1731.8083, 44.1259 },
	{ -445.8339, -1746.3409, 44.1259 },
	{ -436.5107, -1731.4907, 44.1259 },
	
	{ -2767.4883, -1008.7625, 10.6484 },
	{ -2767.9280, -1055.1506, 10.6328 },
	{ -2683.8125, -1035.2960, 10.6254 },
	{ -2770.4792, -1106.5927, 10.6410 }
} ;

new Float: g_auction_position_cont [ MAX_AUCTION_GARAGES ] [ 6 ] =
{
	{ -458.166503, -1755.796875, 44.525886, 0.000000, 0.000000, -30.000005 },
	{ -450.060852, -1760.229736, 44.525936, 0.000000, 0.000000, -31.200000 },
	{ -439.731933, -1766.624633, 44.385936, 0.000000, 0.000000, 0.000000 },
	{ -432.697937, -1754.214477, 44.515933, 0.000000, 0.000000, 59.399993 },
	{ -425.950622, -1741.603881, 44.395915, 0.000000, 0.000000, 58.700000 },
	{ -420.965423, -1734.031494, 44.525867, 0.000000, 0.000000, 57.499996 },
	{ -449.429901, -1744.123779, 44.472076, -0.300000, 0.000000, 57.600009 },
	{ -440.311981, -1729.399780, 44.475933, 0.000000, 0.000000, 58.700000 },

	{ -2772.484619, -1008.969543, 11.028445, 0.000000, 0.000000, -88.299964 },
	{ -2772.935058, -1054.952392, 10.632812, 0.000000, 0.000000, -92.799926 },
	{ -2679.666259, -1032.269653, 10.945404, 0.000000, 0.000000, -55.700008 },
	{ -2770.506835, -1111.507080, 10.948444, 0.000000, 0.000000, 0.000000 }
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

#define MAX_GARAGE_AUCTION_ITEM 36
new garage_item [ MAX_GARAGE_AUCTION_ITEM ] [ _garage_item ] =
{
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1212, "Деньги", -25.0000, 0.0000, 35.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_PURPLE, 1274, ""donate_title"", 0.0000, 0.0000, 180.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1582, "Сытость", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 348, "Навыки оружия", -10.0000, 0.0000, 0.0000, 1.2999 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 2684, "Лицензии", 0.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 11738, "Аптечки", -15.0000, 0.0000, 180.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1575, "Материалы", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 2061, "Боеприпасы", -30.0000, 0.0000, -30.0000, 1.0000 }, // 8

	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1242, "Бронежилет (1 уровень)", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 905, "Камень", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_PURPLE, 19941, "Золото", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_GRAY, 1463, "Древесина", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_PURPLE, 2684, "Хлопок", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_PURPLE, 1080, "Колесо", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_PURPLE, 1018, "Выхлопная труба", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_PURPLE, 1038, "Элемент крыши", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_PURPLE, 1140, "Бампер", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_PURPLE, 1165, "Задний бампер", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_PURPLE, 19773, "Фрагмент ключа", -30.0000, 0.0000, -30.0000, 1.0000 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_RED, 11746, "Ключ от тюрьмы", -30.0000, 0.0000, -30.0000, 1.0000 }, // 12
	
	{ RENDER_TYPE_OBJECT, RARE_TYPE_PURPLE, 14398, "Рюкзак (Gold)", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_PURPLE, 14399, "Рюкзак (WhiteAndBlack)", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_OBJECT, RARE_TYPE_RED, 14400, "Рюкзак (GreyAndBlack)", 20.0, 180.0, 45.0, 0.78 }, // 3

	{ RENDER_TYPE_SKINS, RARE_TYPE_PURPLE, 146, "Одежда #146", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_SKINS, RARE_TYPE_PURPLE, 153, "Одежда #153", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_SKINS, RARE_TYPE_RED, 154, "Одежда #154", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_SKINS, RARE_TYPE_RED, 155, "Одежда #155", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_SKINS, RARE_TYPE_RED, 156, "Одежда #156", 20.0, 180.0, 45.0, 0.78 }, // 5

	{ RENDER_TYPE_VEHICLE, RARE_TYPE_PURPLE, 400, "BMW X6 F16", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_VEHICLE, RARE_TYPE_PURPLE, 401, "Alfa Romeo 33", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_VEHICLE, RARE_TYPE_PURPLE, 404, "Lamborghini LM002", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_VEHICLE, RARE_TYPE_PURPLE, 405, "Audi Rs7", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_VEHICLE, RARE_TYPE_PURPLE, 408, "Nissan 240SX", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_VEHICLE, RARE_TYPE_RED, 516, "Audi 100 c4", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_VEHICLE, RARE_TYPE_RED, 518, "Toyota Mark 2", 20.0, 180.0, 45.0, 0.78 },
	{ RENDER_TYPE_VEHICLE, RARE_TYPE_RED, 522, "Ducati 848", 20.0, 180.0, 45.0, 0.78 } // 8
} ;

new Float: garage_war_info [ 2 ] [ 3 ] =
{
	{ 2483.8608, 289.8796, 29.4973 },
	{ -2738.328, -1149.471, 10.543 }
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

		g_auction_info [ i ] [ g_text ] = CreateDynamic3DTextLabel ( "** Контейнер **\n\n{"#cRD"}Аукцион не начат", col_header_3d, g_auction_position_pickup [ i ] [ 0 ], g_auction_position_pickup [ i ] [ 1 ], g_auction_position_pickup [ i ] [ 2 ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1 );
			
		g_auction_info [ i ] [ g_status ] =
		g_auction_info [ i ] [ g_time ] = 0 ;
		g_auction_info [ i ] [ g_bet_id ] = -1 ;
	}
	
	new text_label [ 27 + 2 ] ;
	for ( new i = 0 ; i < 2 ; i ++ )
	{
		format ( text_label, sizeof text_label, "** Склад №%d **", i + 1 ) ;
		CreateDynamic3DTextLabel ( text_label, col_header_3d, garage_war_info [ i ] [ 0 ], garage_war_info [ i ] [ 1 ], garage_war_info [ i ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1 );
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
	    if ( garage_war_time [ 0 ] == 5400 ) SendClientMessageToAll ( col_yellow, !"* Через 60 минут начнётся аукцион контейнеров. (/gps > Прочее > Склад контейнеров)");
	    else if ( garage_war_time [ 0 ] == 2700 ) SendClientMessageToAll ( col_yellow, !"* Через 30 минут начнётся аукцион контейнеров. (/gps > Прочее > Склад контейнеров)");
	    else if ( garage_war_time [ 0 ] == 1500 ) SendClientMessageToAll ( col_yellow, !"* Через 10 минут начнётся аукцион контейнеров. (/gps > Прочее > Склад контейнеров)");
	    else if ( garage_war_time [ 0 ] == 900 )
	    {
			new con_string [ 122 + 16 + 9 + 9 ] ;
	        for ( new i = 0 ; i < MAX_FIRST_PORT ; i ++ )
		    {
				switch ( random ( 11 ) )
				{
					case 0,1,2,3: g_auction_info [ i ] [ g_type ] = 3 ;
					case 4,5,6: g_auction_info [ i ] [ g_type ] = 0 ;
					case 7,8: g_auction_info [ i ] [ g_type ] = 2 ;
					case 9: g_auction_info [ i ] [ g_type ] = 1 ;
					case 10: g_auction_info [ i ] [ g_type ] = 4 ;
				}

				new _g_type = g_auction_info [ i ] [ g_type ] ;
	            if ( _g_type == 3 ) g_auction_info [ i ] [ g_bet ] = random ( 250000 ) + 150000 ;
	            else if ( _g_type == 0 ) g_auction_info [ i ] [ g_bet ] = random ( 500000 ) + 150000 ;
	            else if ( _g_type == 2 ) g_auction_info [ i ] [ g_bet ] = random ( 1000000 ) + 1500000 ;
	            else if ( _g_type == 1 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;
	            else if ( _g_type == 4 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;
				g_auction_info [ i ] [ g_start_bet ] = g_auction_info [ i ] [ g_bet ] ;

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
				UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, con_string ) ;
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
						UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, "** Контейнер **\n\n{"#cRD"}Аукцион не начат" ) ;

						g_auction_info [ i ] [ g_time ] =
						g_auction_info [ i ] [ g_status ] = 0 ;
						g_auction_info [ i ] [ g_bet_id ] = -1 ;
						continue ;
	                }

					format ( con_string, 170, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Победитель: {"#col_all"}%s\n{"#cWH"}До закрытия: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], g_auction_info [ i ] [ g_bet_name ], g_auction_info [ i ] [ g_time ] ) ;
					UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, con_string ) ;
	                continue ;
	            }
	            else
	            {
		            if ( g_auction_info [ i ] [ g_time ] == 1 )
		            {
		                if ( g_auction_info [ i ] [ g_bet_id ] == -1 )
						{
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, "** Контейнер **\n\n{"#cRD"}Аукцион не начат" ) ;

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
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, con_string ) ;

							format ( con_string, 90, "Вы выйграли контейнер на аукционе. Ваша ставка: {"#col_all"}%s"valute_title"{"#cOR"}.", GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ) ) ;
							SendClientMessage ( player_id, col_orange, con_string ) ;
							
							give_global_quest ( player_id, 1, 1 ) ;
							
							foreach(new p: logged_players)
							{
								if ( player_container_id [ p ] != i ) continue ;
								
								show_packet_container ( p, 255, "" ) ;
							}
							continue ;
						}
		            }
					else
					{
						if ( g_auction_info [ i ] [ g_bet_id ] != -1 )
						{
							format ( con_string, sizeof con_string, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Последняя ставка: {"#col_all"}%s"valute_title_"\n{"#cWH"}Ставка от: {"#col_all"}%s\n{"#cWH"}До конца торгов: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ), g_auction_info [ i ] [ g_bet_name ], g_auction_info [ i ] [ g_time ] ) ;
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, con_string ) ;
						}
						else
						{
							format ( con_string, 160, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Начальная ставка: {"#col_all"}%s"valute_title_"\n{"#cWH"}До конца торгов: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ), g_auction_info [ i ] [ g_time ] ) ;
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, con_string ) ;
						}
					}
				}
	        }
	    }
	}
	
	if ( garage_war_time [ 1 ] > 0 )
	{
	    garage_war_time [ 1 ] -- ;
	    if ( garage_war_time [ 1 ] == 5400 ) SendClientMessageToAll ( col_yellow, !"* Через 60 минут начнётся аукцион контейнеров. (/gps > Прочее > Свалка контейнеров)");
	    else if ( garage_war_time [ 1 ] == 2700 ) SendClientMessageToAll ( col_yellow, !"* Через 30 минут начнётся аукцион контейнеров. (/gps > Прочее > Свалка контейнеров)");
	    else if ( garage_war_time [ 1 ] == 1500 ) SendClientMessageToAll ( col_yellow, !"* Через 10 минут начнётся аукцион контейнеров. (/gps > Прочее > Свалка контейнеров)");
	    else if ( garage_war_time [ 1 ] == 900 )
	    {
			new con_string [ 122 + 16 + 9 + 9 ] ;
	        for ( new i = MAX_FIRST_PORT ; i < MAX_TWO_PORT ; i ++ )
		    {
				switch ( random ( 11 ) )
				{
					case 0,1,2,3: g_auction_info [ i ] [ g_type ] = 3 ;
					case 4,5,6: g_auction_info [ i ] [ g_type ] = 0 ;
					case 7,8: g_auction_info [ i ] [ g_type ] = 2 ;
					case 9: g_auction_info [ i ] [ g_type ] = 1 ;
					case 10: g_auction_info [ i ] [ g_type ] = 4 ;
				}
				
				new _g_type = g_auction_info [ i ] [ g_type ] ;
	            if ( _g_type == 3 ) g_auction_info [ i ] [ g_bet ] = random ( 250000 ) + 150000 ;
	            else if ( _g_type == 0 ) g_auction_info [ i ] [ g_bet ] = random ( 500000 ) + 150000 ;
	            else if ( _g_type == 2 ) g_auction_info [ i ] [ g_bet ] = random ( 1000000 ) + 1500000 ;
	            else if ( _g_type == 1 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;
	            else if ( _g_type == 4 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;
				g_auction_info [ i ] [ g_start_bet ] = g_auction_info [ i ] [ g_bet ] ;

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
				UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, con_string ) ;
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
						UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, "** Контейнер **\n\n{"#cRD"}Аукцион не начат" ) ;

						g_auction_info [ i ] [ g_time ] =
						g_auction_info [ i ] [ g_status ] = 0 ;
						g_auction_info [ i ] [ g_bet_id ] = -1 ;
						continue ;
	                }

					format ( con_string, 170, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Победитель: {"#col_all"}%s\n{"#cWH"}До закрытия: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], g_auction_info [ i ] [ g_bet_name ], g_auction_info [ i ] [ g_time ] ) ;
					UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, con_string ) ;
	                continue ;
	            }
	            else
	            {
		            if ( g_auction_info [ i ] [ g_time ] == 1 )
		            {
		                if ( g_auction_info [ i ] [ g_bet_id ] == -1 )
						{
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, "** Контейнер **\n\n{"#cRD"}Аукцион не начат" ) ;

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
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, con_string ) ;

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
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, con_string ) ;
						}
						else
						{
							format ( con_string, 160, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#col_content"}%s\n{"#cWH"}Начальная ставка: {"#col_all"}%s"valute_title_"\n{"#cWH"}До конца торгов: {"#col_end"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ), g_auction_info [ i ] [ g_time ] ) ;
							UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, con_string ) ;
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
	_price = item_price ( garage_item [ _slot ] [ gar_model ] ), _price_old = floatround ( ( item_price ( garage_item [ _slot ] [ gar_model ] ) * sell_percent ) / 100 ) ;

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
		format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s\n", count_con, item_name ( _item ) ) ;
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
					if ( _inv_item == 1212 )
					{
						new _random = RandomEx ( 2004, 2009 ) ;
						_give_item = _random ;
						give_inventory ( playerid, _give_item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					}
					else if ( _inv_item == 1274 )
					{
						new _random = RandomEx ( 2015, 2023 ) ;
						_give_item = _random ;
						give_inventory ( playerid, _random, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					}
					else if ( _inv_item == 1582 )
					{
						new _random = RandomEx ( 2040, 2045 ) ;
						_give_item = _random ;
						give_inventory ( playerid, _random, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					}
					else if ( _inv_item == 348 )
					{
						new _random = RandomEx ( 2088, 2094 ) ;
						_give_item = _random ;
						give_inventory ( playerid, _random, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					}
					else if ( _inv_item == 2684 )
					{
						new _random = RandomEx ( 2084, 2087 ) ;
						_give_item = _random ;
						give_inventory ( playerid, _random, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					}
					else if ( _inv_item == 11738 )
					{
						_give_item = ITEM_AID_KIT ;
						give_inventory ( playerid, ITEM_AID_KIT, RandomEx ( 1, 3 ), 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					}
					else if ( _inv_item == 1575 || _inv_item == 2061 )
					{
						new drugs_count = RandomEx ( 5, 100 ) ;
						_give_item = 2153 ;
						give_inventory ( playerid, 2153, drugs_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
						give_inventory ( playerid, 2154, drugs_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					}
					else _give_item = _inv_item, give_inventory ( playerid, _inv_item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;

					if ( _give_item != -1 )
					{
						global_string [ 0 ] = EOS ;
						format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _give_item ) ) ;
						SendClientMessage ( playerid, col_yellow, global_string ) ;
					}
					
					g_auction_info [ i ] [ g_slot ] [ item_id ] = -1 ;
				}
				
				if ( _ins_mes == false )
				{
					insert_debtor_message ( "Порт", "Весь выйгрыш с контейнера перенесён на почту (/gps - Бизнесы)", p_info [ playerid ] [ id ] ) ;
					_ins_mes = true ;
				}
			
            	UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, "** Контейнер **\n\n{"#cRD"}Аукцион не начат" ) ;

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
				g_auction_info [ i ] [ g_start_bet ] = g_auction_info [ i ] [ g_bet ] ;
	            
	            g_auction_info [ i ] [ g_status ] = 0 ;
				g_auction_info [ i ] [ g_time ] = DEF_GARAGE_TIME ;
				g_auction_info [ i ] [ g_bet_id ] = -1 ;

	           	new con_string [ 122 + 16 + 9 + 9 ] ;
				format ( con_string, sizeof con_string, "** Контейнер №%d **\n\n{"#cWH"}Тип: {"#cLY"}%s\n{"#cWH"}Начальная ставка: {"#cGN"}%s"valute_title_"\n{"#cWH"}До конца торгов: {"#cRD"}%d сек.", i + 1, garage_auction_name [ g_auction_info [ i ] [ g_type ] ], GetPlayerCashValueToSmile ( g_auction_info [ i ] [ g_bet ] ), g_auction_info [ i ] [ g_time ] ) ;
				UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, con_string ) ;
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
	    g_auction_info [ _con_id ] [ g_slot ] [ 0 ] = GetGarageRandomRarity ( 0, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 1 ] = GetGarageRandomRarity ( 1, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 2 ] = GetGarageRandomRarity ( 2, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 3 ] = GetGarageRandomRarity ( 3, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 4 ] = GetGarageRandomRarity ( 4, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 5 ] = GetGarageRandomRarity ( 5, 1 ) ;
	}
	else if ( _g_type == 1 )
	{
	    g_auction_info [ _con_id ] [ g_slot ] [ 0 ] = GetGarageRandomRarity ( 0, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 1 ] = GetGarageRandomRarity ( 1, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 2 ] = GetGarageRandomRarity ( 2, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 3 ] = GetGarageRandomRarity ( 3, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 4 ] = GetGarageRandomRarity ( 4, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 5 ] = GetGarageRandomRarity ( 5, 1 ) ;
	}
	else if ( _g_type == 2 )
	{
	    g_auction_info [ _con_id ] [ g_slot ] [ 0 ] = GetGarageRandomRarity ( 0, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 1 ] = GetGarageRandomRarity ( 1, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 2 ] = GetGarageRandomRarity ( 2, 0 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 3 ] = GetGarageRandomRarity ( 3, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 4 ] = GetGarageRandomRarity ( 4, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 5 ] = GetGarageRandomRarity ( 5, 1 ) ;
	}
	else if ( _g_type == 3 )
	{
	    g_auction_info [ _con_id ] [ g_slot ] [ 0 ] = GetGarageRandomRarity ( 0, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 1 ] = GetGarageRandomRarity ( 1, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 2 ] = GetGarageRandomRarity ( 2, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 3 ] = GetGarageRandomRarity ( 3, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 4 ] = GetGarageRandomRarity ( 4, 1 ) ;
	    g_auction_info [ _con_id ] [ g_slot ] [ 5 ] = GetGarageRandomRarity ( 5, 1 ) ;
	}
	else if ( _g_type == 4 )
	{
		new _count = 0 ;
		
		_retry_garage_random:
		for ( new i = 0 ; i < MAX_AUCTION_GARAGES_SLOT ; i ++ )
		{
			if ( g_auction_info [ _con_id ] [ g_slot ] [ i ] != -1 ) continue ;
			
			g_auction_info [ _con_id ] [ g_slot ] [ i ] = GetGarageVehicleRandomRarity ( ) ;
			break ;
		}
		
		if ( random ( 3 ) == 1 && _count < 4 )
		{
			_count ++ ;
			goto _retry_garage_random ;
		}
	}
	return 1 ;
}

stock GetGarageRandomRarity ( _slot_container, typeChance )
{
	if ( _slot_container >= 4 && _slot_container <= 7 )
	{
		if ( random ( 3 ) != 1 ) return 0 ;
	}
	else if ( _slot_container > 7 )
	{
		if ( random ( 5 ) != 1 ) return 0 ;
	}

	new freeCount = 0,
		freeId [ 40 ] = { -1, ... },
		idx,
		itemRarity ;
	
	if ( typeChance ) itemRarity = GetRandomWeightedNumber ( rarityChanceDefault ) ;
	else itemRarity = GetRandomWeightedNumber ( rarityChanceMedium ) ;

	for ( new i = 0 ; i < MAX_GARAGE_AUCTION_ITEM ; i ++ )
	{
		if ( garage_item [ i ] [ gar_rare ] != itemRarity ) continue ;

		freeId [ freeCount ] = i ;
		freeCount ++ ;
	}

	if ( ! freeCount ) idx = 0 ;
	else if ( freeCount > 0 && freeCount < 2 ) idx = freeId [ freeCount - 1 ] ;
	else idx = freeId [ random ( freeCount ) ] ;

	return idx ;
}

stock GetGarageVehicleRandomRarity ( )
{
	new freeCount = 0,
		freeId [ 40 ] = { -1, ... },
		idx ;
	
	for ( new i = 0 ; i < MAX_GARAGE_AUCTION_ITEM ; i ++ )
	{
		if ( garage_item [ i ] [ gar_type ] != RENDER_TYPE_VEHICLE ) continue ;

		freeId [ freeCount ] = i ;
		freeCount ++ ;
	}

	if ( ! freeCount ) idx = 0 ;
	else if ( freeCount > 0 && freeCount < 2 ) idx = freeId [ freeCount - 1 ] ;
	else idx = freeId [ random ( freeCount ) ] ;

	return idx ;
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

            if ( g_auction_info [ i ] [ g_type ] == 3 ) g_auction_info [ i ] [ g_bet ] = random ( 250000 ) + 150000 ;
            else if ( g_auction_info [ i ] [ g_type ] == 0 ) g_auction_info [ i ] [ g_bet ] = random ( 500000 ) + 150000 ;
            else if ( g_auction_info [ i ] [ g_type ] == 2 ) g_auction_info [ i ] [ g_bet ] = random ( 1000000 ) + 1500000 ;
            else if ( g_auction_info [ i ] [ g_type ] == 1 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;
            else if ( g_auction_info [ i ] [ g_type ] == 4 ) g_auction_info [ i ] [ g_bet ] = random ( 5000000 ) + 1500000 ;
			g_auction_info [ i ] [ g_start_bet ] = g_auction_info [ i ] [ g_bet ] ;

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
			UpdateDynamic3DTextLabelText ( g_auction_info [ i ] [ g_text ], col_header_3d, con_string ) ;
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
		g_auction_info [ params [ 0 ] ] [ g_start_bet ] = g_auction_info [ params [ 0 ] ] [ g_bet ] ;

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
		UpdateDynamic3DTextLabelText ( g_auction_info [ params [ 0 ] ] [ g_text ], col_header_3d, con_string ) ;
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
			
			foreach(new i: streamed_players[playerid])
			{
				if ( player_container_id [ i ] != con_id ) continue ;

				update_container_window ( i ) ;
			}
			update_container_window ( playerid ) ;
			
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

				if ( _inv_item == 1212 )
				{
					new _random = RandomEx ( 2004, 2009 ) ;
					_give_item = _random ;
					give_inventory ( playerid, _give_item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				}
				else if ( _inv_item == 1274 )
				{
					new _random = RandomEx ( 2015, 2023 ) ;
					_give_item = _random ;
					give_inventory ( playerid, _random, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				}
				else if ( _inv_item == 1582 )
				{
					new _random = RandomEx ( 2040, 2045 ) ;
					_give_item = _random ;
					give_inventory ( playerid, _random, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				}
				else if ( _inv_item == 348 )
				{
					new _random = RandomEx ( 2088, 2094 ) ;
					_give_item = _random ;
					give_inventory ( playerid, _random, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				}
				else if ( _inv_item == 2684 )
				{
					new _random = RandomEx ( 2084, 2087 ) ;
					_give_item = _random ;
					give_inventory ( playerid, _random, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				}
				else if ( _inv_item == 11738 )
				{
					_give_item = ITEM_AID_KIT ;
					give_inventory ( playerid, ITEM_AID_KIT, RandomEx ( 1, 3 ), 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				}
				else if ( _inv_item == 1575 || _inv_item == 2061 )
				{
					new drugs_count = RandomEx ( 5, 100 ) ;
					_give_item = 2153 ;
					give_inventory ( playerid, 2153, drugs_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					give_inventory ( playerid, 2154, drugs_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				}
				else _give_item = _inv_item, give_inventory ( playerid, _inv_item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;

				if ( _give_item != -1 )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _give_item ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}

				g_auction_info [ con_id ] [ g_slot ] [ item_id ] = -1 ;
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
					new _count = 0 ;
					for ( new c = 0 ; c < MAX_AUCTION_GARAGES_SLOT ; c ++ )
					{
						if ( g_auction_info [ i ] [ g_slot ] [ c ] < 1 ) continue ;

						_count ++ ;
						break ;
					}

					if ( ! _count )
					{
						send_check_cinfo ( playerid, "Контейнер пуст!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}

					player_container_id [ playerid ] = i ;
					
					if ( player_device { playerid } == 2 ) show_container_winner ( playerid ) ;
					else show_g_auction_winner_dialog ( playerid, i ) ;
					return 1 ;
				}
				else send_check_cinfo ( playerid, "Не Вы победитель за этот контейнер!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else
			{
				player_container_id [ playerid ] = i ;
				
				if ( player_device { playerid } == 2 ) show_container_window ( playerid ) ;
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
				{"#cBL"}** Склад №%d **\n\n\
				{"#cWH"}%s.\n\n\
				{"#cGRDialog"}* Если Вы выиграете ставку за контейнер и покините игру\n\
				{"#cGRDialog"}* предметы будут отправлены к Вам в инвентарь автоматически.", i + 1, garagewars_string ) ;
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Склад контейнеров", global_string, "Закрыть", "" ) ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

stock show_container_window ( playerid )
{
	#if defined debug_packet
		printf ( "[show_container_window] playerid: %d", playerid ) ;
	#endif

	new _container = player_container_id [ playerid ], _model, itemsLoaded = 0 ;
	new Node: node = JSON_Object (
		"container",			JSON_Int ( g_auction_info [ _container ] [ g_type ] ),
		"startBet",				JSON_Int ( g_auction_info [ _container ] [ g_start_bet ] ),
		"lastBet",				JSON_Int ( g_auction_info [ _container ] [ g_bet ] ),
		"lastBetName",			JSON_Int ( g_auction_info [ _container ] [ g_bet_name ] ),
		"containerTime",		JSON_Int ( g_auction_info [ _container ] [ g_time ] )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_CONTAINERS, 0, global_string ) ;

	node = JSON_Array ( ) ;
	for ( new i = 0, Node: garageNode ; i < MAX_GARAGE_AUCTION_ITEM ; i ++ )
	{
		_model = garage_item [ i ] [ gar_model ] ;

		garageNode = JSON_Array (
			JSON_Object (
				"type",			JSON_Int ( garage_item [ i ] [ gar_type ] ),
				"model",		JSON_Int ( garage_item [ i ] [ gar_model ] ),
				"color1",		JSON_Int ( 1 ),
				"color2",		JSON_Int ( 1 ),
				"rotX",			JSON_Float ( garage_item [ i ] [ gar_rotX ] ),
				"rotY",			JSON_Float ( garage_item [ i ] [ gar_rotY ] ),
				"rotZ",			JSON_Float ( garage_item [ i ] [ gar_rotZ ] ),
				"zoom",			JSON_Float ( garage_item [ i ] [ gar_angle ] ),
				"name",			JSON_String ( item_name ( _model ) ),
				"container",	JSON_Int ( g_auction_info [ _container ] [ g_type ] )
			)
		) ;

		node = JSON_Append ( node, garageNode ) ;

		if ( ++ itemsLoaded == 10 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_CONTAINERS, 1, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
	}
	
	if ( ! itemsLoaded )
	{
		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_CONTAINERS, 1, global_string ) ;
	}
					
	toggle_controlable ( playerid, false ) ;
}

stock update_container_window ( playerid )
{
	#if defined debug_packet
		printf ( "[update_container_window] playerid: %d", playerid ) ;
	#endif

	new _container = player_container_id [ playerid ] ;
	new Node: node = JSON_Object (
		"container",			JSON_Int ( g_auction_info [ _container ] [ g_type ] ),
		"startBet",				JSON_Int ( g_auction_info [ _container ] [ g_start_bet ] ),
		"lastBet",				JSON_Int ( g_auction_info [ _container ] [ g_bet_id ] ),
		"lastBetName",			JSON_String ( g_auction_info [ _container ] [ g_bet_name ] ),
		"containerTime",		JSON_Int ( g_auction_info [ _container ] [ g_time ] )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_CONTAINERS, 0, global_string ) ;
}

stock show_container_winner ( playerid )
{
	#if defined debug_packet
		printf ( "[show_container_winner] playerid: %d", playerid ) ;
	#endif

	new Node: node, _container = player_container_id [ playerid ], momentSell, _slot ;
	for ( new i = 0 ; i < MAX_AUCTION_GARAGES_SLOT ; i ++ )
	{
		_slot = g_auction_info [ _container ] [ g_slot ] [ i ] ;
		if ( _slot < 1 ) continue ;

		momentSell += floatround ( ( item_price ( garage_item [ _slot ] [ gar_model ] ) * sell_percent ) / 100 ) ;

		node = JSON_Object (
			"id",				JSON_Int ( i ),
			"type",				JSON_Int ( garage_item [ _slot ] [ gar_type ] ),
			"model",			JSON_Int ( garage_item [ _slot ] [ gar_model ] ),
			"color1",			JSON_Int ( 1 ),
			"color2",			JSON_Int ( 1 ),
			"rotX",				JSON_Float ( garage_item [ _slot ] [ gar_rotX ] ),
			"rotY",				JSON_Float ( garage_item [ _slot ] [ gar_rotY ] ),
			"rotZ",				JSON_Float ( garage_item [ _slot ] [ gar_rotZ ] ),
			"zoom",				JSON_Float ( garage_item [ _slot ] [ gar_angle ] )
		) ;

		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_CONTAINERS, 4, global_string ) ;
	}

	node = JSON_Object (
		"container",			JSON_Int ( g_auction_info [ _container ] [ g_type ] ),
		"momentSell",			JSON_Int ( momentSell )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_CONTAINERS, 3, global_string ) ;
}

stock show_packet_container ( playerid, actionId, data [ ] )
{
	#pragma unused data
	if ( actionId == 0 ) // exit
	{
		toggle_controlable ( playerid, true ) ;
	}
	else if ( actionId == 1 ) // bet
	{
		new _container = player_container_id [ playerid ] ;
		show_g_auction ( playerid, _container ) ;
	}
	else if ( actionId == 2 ) // get prize
	{
		show_packet_container ( playerid, 255, "" ) ;

		new _container = player_container_id [ playerid ], _slot, _inv_item, _return ;
		for ( new i = 0 ; i < MAX_AUCTION_GARAGES_SLOT ; i ++ )
		{
			_slot = g_auction_info [ _container ] [ g_slot ] [ i ] ;
			if ( _slot < 1 ) continue ;

			_inv_item = garage_item [ _slot ] [ gar_model ] ;
			if ( _inv_item == 1212 )
			{
				_return = give_inventory ( playerid, RandomEx ( 2004, 2009 ), 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			}
			else if ( _inv_item == 1274 )
			{
				_return = give_inventory ( playerid, RandomEx ( 2015, 2023 ), 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			}
			else if ( _inv_item == 1582 )
			{
				_return = give_inventory ( playerid, RandomEx ( 2040, 2045 ), 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			}
			else if ( _inv_item == 348 )
			{
				_return = give_inventory ( playerid, RandomEx ( 2088, 2094 ), 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			}
			else if ( _inv_item == 2684 )
			{
				_return = give_inventory ( playerid, RandomEx ( 2084, 2087 ), 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			}
			else if ( _inv_item == 11738 )
			{
				_return = give_inventory ( playerid, ITEM_AID_KIT, RandomEx ( 1, 3 ), 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			}
			else if ( _inv_item == 1575 || _inv_item == 2061 )
			{
				new drugs_count = RandomEx ( 5, 100 ) ;
				_return = give_inventory ( playerid, 2153, drugs_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				_return = give_inventory ( playerid, 2154, drugs_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			}
			else _return = give_inventory ( playerid, _inv_item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;

			if ( _return == -1 )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно места в инвентаре.", 0, 3, CINFO_GARAGE_AUCTION_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			new scm_string [ 144 ] ;
			format ( scm_string, sizeof scm_string, "%s забрал(а) с контейнера %s", p_info [ playerid ] [ name ], item_name ( _inv_item ) ) ;
			WriteLogs ( playerid, -1, TYPE_LOG_INVENTORY, scm_string ) ;

			g_auction_info [ _container ] [ g_slot ] [ i ] = -1 ;
		}
		send_check_cinfo ( playerid, "Вы забрали содержимое контейнера.", 0, 3, CINFO_GARAGE_AUCTION_ID, PICTURE_INFO_SUCESS, "", "" ) ;
	}
	else if ( actionId == 3 ) // sell prize
	{
		new _container = player_container_id [ playerid ], momentSell = 0, _slot ;
		for ( new i = 0 ; i < MAX_AUCTION_GARAGES_SLOT ; i ++ )
		{
			_slot = g_auction_info [ _container ] [ g_slot ] [ i ] ;
			g_auction_info [ _container ] [ g_slot ] [ i ] = -1 ;
			if ( _slot < 1 ) continue ;

			momentSell += floatround ( ( item_price ( garage_item [ _slot ] [ gar_model ] ) * sell_percent ) / 100 ) ;
		}

		if ( momentSell > 0 )
		{
			send_check_cinfo ( playerid, "Вы продали содержимое контейнера", 0, 3, CINFO_GARAGE_AUCTION_ID, PICTURE_INFO_SUCESS, "", "" ) ;
			
			give_money ( playerid, momentSell ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, momentSell, "продал содержимое контейнера" ) ;
		}
		else send_check_cinfo ( playerid, "Контейнер либо пуст, либо цена содержимого равна нулю", 0, 3, CINFO_GARAGE_AUCTION_ID, PICTURE_INFO_WARNING, "", "" ) ;
	}
	else if ( actionId == 255 )
	{
		onServerDestroy ( playerid, UI_CONTAINERS ) ;
		toggle_controlable ( playerid, true ) ;
	}
	return 1 ;
}