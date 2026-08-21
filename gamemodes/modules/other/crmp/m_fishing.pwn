#define MAX_FISHING_BAG_SLOT 60
#define MAX_FISHING_RODS 5
#define MAX_FISHING_ROD_NAME 16

// Диапазоны весов рыб
#define RANGE_1_2 0
#define RANGE_2_3 1
#define RANGE_3_4 2
#define RANGE_4_5 3
#define RANGE_5_6 4
#define MAX_FISH_TYPES 5

// Прогресс необходимый для повышения уровня
enum _:FISHING_LEVEL_INFO
{
    FISHING_LEVEL_FIRST_PROGRESS = 100,
    FISHING_LEVEL_SECOND_PROGRESS = 200,
    FISHING_LEVEL_THIRD_PROGRESS = 300,
    FISHING_LEVEL_FORTH_PROGRESS = 400,
    FISHING_LEVEL_FIVES_PROGRESS = 500
} ;

enum _:FISHING_ROD
{
    FISHING_ROD_ID,
    FISHING_ROD_NAME [ MAX_FISHING_ROD_NAME ],
    Float: FISHING_ROD_CATCH_MAX_WEIGHT, // максимальный вес который может поймать игрок на этой удочке
    FISHING_ROD_REQUIRED_LEVEL,
    FISHING_ROD_CONSUMPTION, // расход энергии за ловлю
    Float: FISHING_ROD_BAG_MAX_SIZE, // 
    FISHING_ROD_PRICE // цена удочки
} ;

enum _:PLAYER_FISHING_BAG
{
    PLAYER_FISHING_BAG_CHAR_ID, // айди игрока
    PLAYER_FISHING_BAG_LEVEL, // уровень рыболова
    PLAYER_FISHING_BAG_ROD, // удочка
    PLAYER_FISHING_BAG_PROGRESS, // прогресс рыболова
    PLAYER_FISHING_BAG_ENERGY, // энергии у игрока на текущий момент
    Float: PLAYER_FISHING_BAG_MAX_WEIGHT, // максимальный вес сумки
    Float: PLAYER_FISHING_BAG_CURR_WEIGHT, // текущий вес в сумке
    PLAYER_FISHING_BAG_SLOT [ MAX_FISHING_BAG_SLOT ], // слоты хранение (минимальный вес рыбы 1 кг, максимальный размер хранения 60 кг)
	PLAYER_FISHING_BAG_SLOT_ID [ MAX_FISHING_BAG_SLOT ], // слоты хранение (минимальный вес рыбы 1 кг, максимальный размер хранения 60 кг)
	PLAYER_FISHING_BAG_BAIT, // наживка
    PT_FISHING_START_TIME, // время начала игры
    PT_FISHING_ENERGY_LAST_UPDATE // время последнего обновления энергии
} ;

enum _:FISHING_SLOT_INFO
{
    FISHING_SLOT_INFO_ID, // айди рыбы
    FISHING_SLOT_INFO_NAME [ 32 ], // название рыбы
    Float: FISHING_SLOT_INFO_WEIGHT // вес рыбы
}

new g_fishing_bag [ MAX_PLAYERS ] [ PLAYER_FISHING_BAG ] ;
new g_fishing_rods [ MAX_FISHING_RODS ] [ FISHING_ROD ] =
{
    { 1, "Kaida Omega 100", 2.0, 1, 5, 40.0, 1000 },
    { 2, "Kaida Omega 200", 3.0, 2, 4, 45.0, 2000 },
    { 3, "Kaida Omega 300", 4.0, 3, 3, 50.0, 3000 },
    { 4, "Kaida Omega 400", 5.0, 4, 2, 55.0, 4000 },
    { 5, "Kaida Omega 500", 6.0, 5, 1, 60.0, 5000 }
} ;

new g_fishing_fish_ranges [ 5 ] [ MAX_FISH_TYPES ] [ FISHING_SLOT_INFO ] =
{
    // Рыбы в диапазоне от 1.00 до 2.00
    {
        { 0, "Серебряный Карп", 1.1 },
        { 1, "Синец", 1.3 },
       	{ 2, "Карась", 1.5 },
        { 3, "Окунь", 1.7 },
        { 4, "Плотва", 1.9 }
    },
    // Рыбы в диапазоне от 2.00 до 3.00
    {
        { 5, "Обычный Карп", 2.2 },
        { 6, "Судак", 2.4 },
        { 7, "Сом", 2.6 },
        { 8, "Щука", 2.8 },
        { 9, "Линь", 2.9 }
    },
    // Рыбы в диапазоне от 3.00 до 4.00
    {
        { 10, "Травяной Карп", 3.1 },
        { 11, "Форель", 3.3 },
        { 12, "Лосось", 3.5 },
        { 13, "Лещ", 3.7 },
        { 14, "Угорь", 3.9 }
    },
    // Рыбы в диапазоне от 4.00 до 5.00
    {
        { 15, "Радужная Форель", 4.1 },
        { 16, "Бурый Трут", 4.3 },
        { 17, "Морской Окунь", 4.5 },
        { 18, "Судак", 4.7 },
        { 19, "Белорыбица", 4.9 }
    },
    // Рыбы в диапазоне от 5.00 до 6.00
    {
        { 20, "Осётр", 5.2 },
        { 21, "Мускун", 5.4 },
        { 22, "Группер", 5.6 },
        { 23, "Тарпон", 5.8 },
        { 24, "Марлин", 5.9 }
    }
} ;

#if defined SAMP
	static Float: udochka_position [ 9 ] = { 0.079376, 0.037070, 0.007706, 181.482910, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 } ;
#endif

#if defined CRMP
	static Float: udochka_position [ 9 ] = { -0.0199, -0.0499, 0.1399, 0.0000, 0.0000, 0.0000, 1.6500, 1.6500, 1.6500 } ;
#endif

static Float: fishing_position [ 14 ] [ 3 ] =
{
	{ -2017.8507, -1020.5666, 29.3852 },
	{ -2009.4909, -990.2733, 29.5369 },
	{ -2008.7752, -961.1889, 29.6111 },
	{ -2012.8808, -927.1303, 29.6471 },
	{ -2021.2031, -891.2713, 29.6444 },
	{ -2036.7109, -858.1638, 29.6140 },
	{ -2059.5417, -837.3818, 29.5997 },
	{ -2088.4533, -820.9151, 29.6774 },
	{ -2261.1203, -989.6658, 29.5210 },
	{ -2212.2390, -1034.3041, 29.4677 },
	{ -2154.5954, -1057.4725, 29.9121 },
	{ -2103.1130, -1070.6955, 29.4335 },
	{ -2080.4682, -1070.5413, 29.5115 },
	{ -2050.7670, -1055.6333, 29.5180 }
} ;

static Text3D: fishing_text [ 14 ] ;
static fishing_area [ 14 ] ;
static bool: used_fishing [ 14 ] = { false, ... } ;
new player_fishing_place [ MAX_PLAYERS char ] ;

stock clear_player_fishing ( playerid )
{
	player_fishing_place { playerid } = 0 ;
	return 1 ;
}

stock fishing_OnPlayerDisconnect ( playerid )
{
	new _place_id = player_fishing_place { playerid } ;
	if ( _place_id > 0 ) exit_player_fishing ( playerid ) ;
	return 1 ;
}

stock fishing_OnGameModeInit ( )
{
	for ( new i = 0 ; i < sizeof fishing_position ; i ++ )
	{
		fishing_text [ i ] = CreateDynamic3DTextLabel ( "** Рыбацкое место **\n{"#cGN3D"}Свободно", col_header_3d, fishing_position [ i ] [ 0 ], fishing_position [ i ] [ 1 ], fishing_position [ i ] [ 2 ] + 0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0 ) ;
		fishing_area [ i ] = CreateDynamicSphere ( fishing_position [ i ] [ 0 ], fishing_position [ i ] [ 1 ], fishing_position [ i ] [ 2 ], 2.0, -1, -1, -1 ) ;
		area_info [ fishing_area [ i ] ] [ a_type ] = area_type_fishing ;
		area_info [ fishing_area [ i ] ] [ a_item ] = i ;
	}

	mysql_tquery ( sql_connection, !"SELECT * FROM `fishing_catch` ORDER BY `fishing_catch`.`catch_id` DESC LIMIT 1", "callback_last_fish_id" ) ;
	return 1 ;
}

stock fishing_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_fishing_go:
		{
			if ( ! response ) return 1 ;
		
			new _place_id = get_player_use_listitem ( playerid ) ;
			
			new scm_string [ 52 + MAX_PLAYER_NAME ] ;
			format ( scm_string, sizeof scm_string, "** Рыбацкое место **\n{"#cRL3D"}Занято {"#cWH"}%s", p_info [ playerid ] [ name ] ) ;
			UpdateDynamic3DTextLabelText ( fishing_text [ _place_id ], col_header_3d, scm_string ) ;
			
			player_fishing_place { playerid } = _place_id + 1 ;
		    
			SetPlayerAttachedObject ( playerid, 1, udochka_object, 6, udochka_position [ 0 ], udochka_position [ 1 ], udochka_position [ 2 ], udochka_position [ 3 ], udochka_position [ 4 ], udochka_position [ 5 ], udochka_position [ 6 ], udochka_position [ 7 ], udochka_position [ 8 ] ) ;
			ApplyAnimation ( playerid, "SWORD", "sword_block", 1.0, 0, 0, 0, 1, 0, 1 ) ;
			p_t_info [ playerid ] [ p_animation ] = true ;
			
			me_action ( playerid, "достал(а) удочку" ) ;
			FishCatch ( playerid ) ;

			toggle_controlable ( playerid, false ) ;
			return 1 ;
		}
		case d_fishing_go_1:
		{
		    if ( ! response )
		    {
				exit_player_fishing ( playerid ) ;
		        return 1 ;
		    }

			ApplyAnimation ( playerid, "SWORD", "sword_block", 1.0, 0, 0, 0, 1, 0, 1 ) ;
			FishCatch ( playerid ) ;
			return 1 ;
		}
		case d_fishing_rod_shop:
		{
			if ( ! response )
			{
				ShowFishingDialog ( playerid, 1 ) ;
				return 1 ;
			}

			new rodIndex = listitem,
				rodLevel = g_fishing_rods [ rodIndex ] [ FISHING_ROD_REQUIRED_LEVEL ],
				playerLevel = g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_LEVEL ],
				rodPrice = g_fishing_rods [ rodIndex ] [ FISHING_ROD_PRICE ],
				currentRodLevel ;

			new b = GetPVarInt ( playerid, "p_biz_id" ) - 1,
            	price = 0, bool: _sucess_product = false ;
			
			price = b_price_market [ b ] [ 0 ] + rodPrice ;
			if ( mafia_player ( playerid ) )
			{
				if ( b_info [ b ] [ b_mafia ] == p_info [ playerid ] [ member ] )
				{
				    price = floatround ( ( b_price_market [ b ] [ 0 ] * 50 ) / 100 ) ;
				}
			}
			if ( b_info [ b ] [ b_product ] < b_fishing_product [ 0 ] ) _sucess_product = true ;

			if ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] > 0 )
			{
				currentRodLevel = g_fishing_rods [ g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] - 1 ] [ FISHING_ROD_REQUIRED_LEVEL ] ;

				if ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] == g_fishing_rods [ rodIndex ] [ FISHING_ROD_ID ] )
				{
					send_check_cinfo ( playerid, "У вас уже есть эта удочка!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			}
			else currentRodLevel = 0 ;

			if ( playerLevel < rodLevel )
			{
				send_check_cinfo ( playerid, "Ваш уровень рыболова слишком низкий для этой удочки!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			if ( rodLevel < currentRodLevel )
			{
				send_check_cinfo ( playerid, "Нельзя покупать удочку хуже текущей!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			if ( p_info [ playerid ] [ money ] < price )
			{
				send_check_cinfo ( playerid, "У вас недостаточно денег для покупки этой удочки!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			if ( ! _sucess_product ) give_bmoney ( b + 1, price, b_fishing_product [ 0 ] ) ;
			give_money ( playerid, -price ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Закуп охота и рыбалка" ) ;

			g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] = g_fishing_rods[ rodIndex ] [ FISHING_ROD_ID ] ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "UPDATE fishing_bag SET rod_id = %d WHERE char_id = %d LIMIT 1", g_fishing_rods [ rodIndex ] [ FISHING_ROD_ID ], p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, global_string ) ;

			send_check_cinfo ( playerid, "Вы успешно купили удочку.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы приобрели удочку. Используйте /gps - Прочее - Рыбацкое озеро." ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock show_fishing_rod_shop ( playerid )
{
	global_string [ 0 ] = EOS ;
    strcat ( global_string, "{"#cBL"}Удочка:\t{"#cBL"}Необходимый уровень:\t{"#cBL"}Расходность:\t{"#cBL"}Цена:\n" ) ;
    for ( new i = 0 ; i < MAX_FISHING_RODS ; i ++ )
	{
        new rodLevel = g_fishing_rods [ i ] [ FISHING_ROD_REQUIRED_LEVEL ] ;
        new playerLevel = g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_LEVEL ] ;

        if ( playerLevel >= rodLevel )
		{
            // Доступная удочка - белый цвет
            format ( global_string, sizeof global_string, "%s{"#cGN"}+ {"#cWH"}%s\t%d\t%d процента за рыбу\t{"#cGN"}%d"valute_title_"\n",
				global_string,
                g_fishing_rods [ i ] [ FISHING_ROD_NAME ],
                g_fishing_rods [ i ] [ FISHING_ROD_REQUIRED_LEVEL ],
                g_fishing_rods [ i ] [ FISHING_ROD_CONSUMPTION ],
                g_fishing_rods [ i ] [ FISHING_ROD_PRICE ]
            ) ;
        } 
		else
		{
            // Недоступная удочка - серый цвет
            format ( global_string, sizeof global_string, "%s{"#cRD"}- {"#cWH"}%s\t%d\t%d процента за рыбу\t{"#cGN"}%d"valute_title_"\n",
				global_string,
                g_fishing_rods [ i ] [ FISHING_ROD_NAME ],
                g_fishing_rods [ i ] [ FISHING_ROD_REQUIRED_LEVEL ],
                g_fishing_rods [ i ] [ FISHING_ROD_CONSUMPTION ],
                g_fishing_rods [ i ] [ FISHING_ROD_PRICE ]
            ) ;
        }
    }

	show_dialog ( playerid, d_fishing_rod_shop, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Магазин удочек", global_string, "Купить", "Закрыть" ) ;
	return 1 ;
}

stock fishing_EnterDynamicArea ( playerid, areaid )
{
	if ( GetPlayerState ( playerid ) == PLAYER_STATE_ONFOOT )
	{
		switch ( area_info [ areaid ] [ a_type ] )
		{
			case area_type_fishing:
			{
				if ( ! g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вам необходимо приобрести удочку. Используйте {"#cRInfo"}/gps - Бизнесы - Охота и рыбалка{"#cGRInfo"}." ) ;
				if ( ! g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_BAIT ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вам необходимо приобрести наживку. Используйте {"#cRInfo"}/gps - Бизнесы - Охота и рыбалка{"#cGRInfo"}." ) ;

				new i = area_info [ areaid ] [ a_item ] ;
				if ( used_fishing [ i ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Место занято другим игроком." ) ;

				show_dialog ( playerid, d_fishing_go, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Рыбалка", "{"#cWH"}Вы хотите занять место и начать рыбачить?", "Да", "Нет" ) ;
				set_player_use_listitem ( playerid, i ) ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

stock exit_player_fishing ( playerid )
{
	RemovePlayerAttachedObject ( playerid, 1 ) ;
	ClearAnimations ( playerid ) ;
	p_t_info [ playerid ] [ p_animation ] = false ;
	
	me_action ( playerid, "убрал(а) удочку" ) ;
		
	new _place_id = player_fishing_place { playerid } ;
	if ( _place_id > 0 )
		UpdateDynamic3DTextLabelText ( fishing_text [ _place_id - 1 ], col_header_3d, "** Рыбацкое место **\n{"#cGN3D"}Свободно" ) ;
	
	player_fishing_place { playerid } = 0 ;
	toggle_controlable ( playerid, true ) ;
	return 1 ;
}

stock FishPlayerInit ( playerid )
{
	new sql_string [ 144 ] ;
    format ( sql_string, sizeof sql_string, "SELECT level, rod_id, progress, energy, max_weight, curr_weight, bait, energy_last_update FROM fishing_bag WHERE char_id = %d LIMIT 1", p_info [ playerid ] [ id ] ) ;
    mysql_tquery ( sql_connection, sql_string, "OnFishPlayerInit", "i", playerid ) ;

	sql_string [ 0 ] = EOS ;
    format ( sql_string, sizeof sql_string, "SELECT catch_id, fish_id, weight FROM fishing_catch WHERE char_id = %d ORDER BY catch_time DESC LIMIT %d", p_info [ playerid ] [ id ], MAX_FISHING_BAG_SLOT ) ;
    mysql_tquery ( sql_connection, sql_string, "OnLoadFishingCatch", "i", playerid ) ;
    return true ;
}

new catch_inc_id = 0 ;
callback: callback_last_fish_id ( )
{
    new fields,
		rows ;

	cache_get_data ( rows, fields ) ;

    if ( rows ) catch_inc_id = cache_get_field_content_int ( 0, "catch_id", sql_connection ) ;
	return 1 ;
}

callback: OnFishPlayerInit ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CHAR_ID ] = p_info [ playerid ] [ id ] ;
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_LEVEL ] = 1 ;
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] = 0 ;
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_PROGRESS ] = 0 ;
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ENERGY ] = 100 ;
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_MAX_WEIGHT ] = 40.0 ;
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CURR_WEIGHT ] = 0.0 ;
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_BAIT ] = 0 ;
        g_fishing_bag [ playerid ] [ PT_FISHING_ENERGY_LAST_UPDATE ] = gettime ( ) ;

		new query_string [ 256 ] ;
		format ( query_string, sizeof query_string, "INSERT INTO fishing_bag (char_id, level, rod_id, progress, energy, max_weight, curr_weight, bait, energy_last_update) VALUES (%d, %d, %d, %d, %d, %.2f, %.2f, %d, NOW())", 
               p_info [ playerid ] [ id ], 1, 0, 0, 100, 40.0, 0.0, 0 ) ;
        mysql_tquery ( sql_connection, query_string ) ;
		return 1 ;
	}

    g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CHAR_ID ] = p_info [ playerid ] [ id ] ;
    g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_LEVEL ] = cache_get_field_content_int ( 0, "level" ) ;
    g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] = cache_get_field_content_int ( 0, "rod_id" ) ;
    g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_PROGRESS ] = cache_get_field_content_int ( 0, "progress" ) ;
    g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ENERGY ] = cache_get_field_content_int ( 0, "energy" ) ;
    g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_MAX_WEIGHT ] = cache_get_field_content_float ( 0, "max_weight" ) ;
    g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CURR_WEIGHT ] = cache_get_field_content_float ( 0, "curr_weight" ) ;
    g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_BAIT ] = cache_get_field_content_int ( 0, "bait" ) ;
    g_fishing_bag [ playerid ] [ PT_FISHING_ENERGY_LAST_UPDATE ] = cache_get_field_content_int ( 0, "energy_last_update" ) ;
	return 1 ;
}

callback: OnLoadFishingCatch ( playerid )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;

    for ( new i = 0 ; i < MAX_FISHING_BAG_SLOT ; i ++ )
	{
		g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT ] [ i ] =
		g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT_ID ] [ i ] = 0 ;
	}

    for ( new i = 0, Float: temp_weight ; i < rows && i < MAX_FISHING_BAG_SLOT ; i ++ )
	{
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT_ID ] [ i ] = cache_get_field_content_int ( i, "catch_id" ) ;
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT ] [ i ] = cache_get_field_content_int ( i, "fish_id" ) ;
        temp_weight = cache_get_field_content_float ( i, "weight" ) ;
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CURR_WEIGHT ] += temp_weight ;
    }
    return true ;
}

stock show_packet_fishing_game ( playerid, actionId, data [ ] )
{
	#pragma unused data
	if ( actionId == 0 )
	{
		HandleSuccessfulFishing ( playerid ) ;
	}
	else if ( actionId == 1 )
	{
		HandleUnsuccessfulFishing ( playerid ) ;
	}
	else if ( actionId == 2 ) // exit
	{
		exit_player_fishing ( playerid ) ;
	}
	else if ( actionId == 3 )
	{
		show_dialog ( playerid, d_fishing_go_1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Рыбалка", "{"#cWH"}Вы хотите продолжить рыбачить?", "Да", "Нет" ) ;
    }
	return 1 ;
}

stock show_fishing_inventory ( playerid )
{
	#if defined debug_packet
		printf ( "[show_fishing_inventory] playerid: %d", playerid ) ;
	#endif

	new rodIndex, Float: _rod_catch_max_weight = 0.0 ;
	if ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] > 0 )
	{
		rodIndex = g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] - 1 ;
    	_rod_catch_max_weight = g_fishing_rods [ rodIndex ] [ FISHING_ROD_CATCH_MAX_WEIGHT ] ;
	}

	new Node: node = JSON_Object (
		"mediumWeight",			JSON_Float ( _rod_catch_max_weight ),
		"weight",				JSON_Float ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CURR_WEIGHT ] ),
		"maxWeight",			JSON_Float ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_MAX_WEIGHT ] )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_FISHING_INVENTORY, 3, global_string ) ;

	new fishId, Float: fishWeight, Float: fishMaxWeight,
		fishFirst, fishSecond ;

	node = JSON_Array ( ) ;
    for ( new i = 0, Node: nodeFish, itemsLoaded ; i < MAX_FISHING_BAG_SLOT ; i ++ )
	{
        if ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT_ID ] [ i ] == 0 )
		{
			nodeFish = JSON_Array (
				JSON_Object (
					"id",			JSON_Int ( -1 ),
					"position",		JSON_Int ( -1 ),
					"name",			JSON_String ( "Свободно" ),
					"weight",		JSON_Float ( 0.0 ),
					"maxWeight",	JSON_Float ( 0.0 )
				)
			) ;

			node = JSON_Append ( node, nodeFish ) ;
        }
		else
		{
			fishId = g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT ] [ i ] ;
			getFishInfo ( fishId, fishFirst, fishSecond ) ;

			fishWeight = g_fishing_fish_ranges [ fishFirst ] [ fishSecond ] [ FISHING_SLOT_INFO_WEIGHT ] ;
			fishMaxWeight = g_fishing_fish_ranges [ fishFirst ] [ MAX_FISH_TYPES - 1 ] [ FISHING_SLOT_INFO_WEIGHT ] ;

			nodeFish = JSON_Array (
				JSON_Object (
					"id",			JSON_Int ( g_fishing_fish_ranges [ fishFirst ] [ fishSecond ] [ FISHING_SLOT_INFO_ID ] ),
					"position",		JSON_Int ( i ),
					"name",			JSON_String ( g_fishing_fish_ranges [ fishFirst ] [ fishSecond ] [ FISHING_SLOT_INFO_NAME ] ),
					"weight",		JSON_Float ( fishWeight ),
					"maxWeight",	JSON_Float ( fishMaxWeight )
				)
			) ;

			node = JSON_Append ( node, nodeFish ) ;
		}

		if ( ++ itemsLoaded == 10 || i == MAX_FISHING_BAG_SLOT - 1 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_FISHING_INVENTORY, 0, global_string ) ;

			itemsLoaded = 0 ;
			node = JSON_Array ( ) ;
		}
    }
	return 1 ;
}

stock getFishInfo ( fishId, &fishFirst, &fishSecond )
{
	for ( new i = 0 ; i < 5 ; i ++ )
	{
		for ( new f = 0 ; f < MAX_FISH_TYPES ; f ++ )
		{
			if ( g_fishing_fish_ranges [ i ] [ f ] [ FISHING_SLOT_INFO_ID ] == fishId )
			{
				fishFirst = i ;
				fishSecond = f ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

stock show_packet_fishing_inventory ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 ) // exit
	{
		toggle_controlable ( playerid, true ) ;
	}
	else if ( actionId == 1 ) // sell
	{
		new idx = strval ( data ),
			_b_id = GetPVarInt ( playerid, "p_biz_id" ) ;

		if ( ! _b_id || b_info [ _b_id - 1 ] [ b_type ] != bizz_type_fish )
		{
			send_check_cinfo ( playerid, "Для продажи отправляйтесь в бизнес 'с охотой на рыбалку'!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			new Float:_distance = 3000.0 ;

			foreach(new h: business_types[bizz_type_fish])
			{
				if ( b_info [ h - 1 ] [ b_type ] != bizz_type_shop ) continue ;
				new Float:__distance = GetPlayerDistanceFromPoint ( playerid, b_info [ h - 1 ] [ b_position ] [ 0 ], b_info [ h - 1 ] [ b_position ] [ 1 ], b_info [ h - 1 ] [ b_position ] [ 2 ] ) ;
				if ( _distance > __distance ) _distance = __distance, _b_id = h - 1 ;
			}

			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;

			SetPlayerRaceCheckpoint ( playerid, 1, b_info [ _b_id ] [ b_position ] [ 0 ], b_info [ _b_id ] [ b_position ] [ 1 ], b_info [ _b_id ] [ b_position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			return 1 ;
		}

		new fishId = g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT ] [ idx ], fishFirst, fishSecond ;
		getFishInfo ( fishId, fishFirst, fishSecond ) ;

		new Float: fishWeight = g_fishing_fish_ranges [ fishFirst ] [ fishSecond ] [ FISHING_SLOT_INFO_WEIGHT ] ;
		new _price = floatround ( fishWeight * _price_fish_kg ) ;

		give_money ( playerid, _price ) ;
        insert_money_log ( playerid, INVALID_PLAYER_ID, _price, "продажа рыбы" ) ;

		global_string [ 0 ] = EOS ;
		format ( global_string, 128, "Вы продали '%s' весом %2.f кг за %d"valute_title_"",
		g_fishing_fish_ranges [ fishFirst ] [ fishSecond ] [ FISHING_SLOT_INFO_NAME ], fishWeight, _price ) ;
		send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;

		removeFish ( playerid, idx ) ;
	}
	return 1 ;
}

stock removeFish ( playerid, _slot )
{
	new fishId = g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT ] [ _slot ], fishFirst, fishSecond ;
	getFishInfo ( fishId, fishFirst, fishSecond ) ;

	new Float: fishWeight = g_fishing_fish_ranges [ fishFirst ] [ fishSecond ] [ FISHING_SLOT_INFO_WEIGHT ] ;
	g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CURR_WEIGHT ] -= fishWeight ;

	global_string [ 0 ] = EOS ;
    format ( global_string, 128, "UPDATE fishing_bag SET curr_weight = %.2f WHERE char_id = %d LIMIT 1", 
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CURR_WEIGHT ],
        p_info [ playerid ] [ id ] ) ;
    mysql_tquery ( sql_connection, global_string ) ;

	new rodIndex, Float: _rod_catch_max_weight = 0.0 ;
	if ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] > 0 )
	{
		rodIndex = g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] - 1 ;
    	_rod_catch_max_weight = g_fishing_rods [ rodIndex ] [ FISHING_ROD_CATCH_MAX_WEIGHT ] ;
	}
	
	new Node: node = JSON_Object (
		"mediumWeight",			JSON_Float ( _rod_catch_max_weight ),
		"weight",				JSON_Float ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CURR_WEIGHT ] ),
		"maxWeight",			JSON_Float ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_MAX_WEIGHT ] )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_FISHING_INVENTORY, 3, global_string ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 128, "DELETE FROM `fishing_catch` WHERE `catch_id` = '%d' LIMIT 1", g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT_ID ] [ _slot ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;

	g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT_ID ] [ _slot ] =
	g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT ] [ _slot ] = 0 ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 12, "%d", _slot ) ;
    onServerSendData ( playerid, UI_FISHING_INVENTORY, 2, global_string ) ;
	return 1 ;
}

stock FishCatch ( playerid )
{
    UpdatePlayerEnergy ( playerid ) ;

    new rodIndex = g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] - 1,
    	Float: _rod_catch_max_weight = g_fishing_rods [ rodIndex ] [ FISHING_ROD_CATCH_MAX_WEIGHT ],
    	_fishing_rod_consumption = g_fishing_rods [ rodIndex ] [ FISHING_ROD_CONSUMPTION ],
    	Float: fishWeight = RandomFloatEx ( 1.0, _rod_catch_max_weight ) ;

    if ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CURR_WEIGHT ] + fishWeight > g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_MAX_WEIGHT ] )
	{
		send_check_cinfo ( playerid, "Недостаточно места в рыболовной сумке!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
    }
    
    /*
    if (g_fishing_bag[playerid][PLAYER_FISHING_BAG_ENERGY] - _fishing_rod_consumption < 0) {
        return ShowErrorNotification(playerid, "Вы устали, возвращайтесь позже");
    }
    */

    if ( ! g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_BAIT ] )
	{
		send_check_cinfo ( playerid, "Приобретите наживку чтобы рыбачить!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
    }

    g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ENERGY ] -= _fishing_rod_consumption ;
    g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_BAIT ] -- ;

	global_string [ 0 ] = EOS ;
    format ( global_string, 128, "UPDATE fishing_bag SET bait = %d, energy = %d WHERE char_id = %d LIMIT 1", 
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_BAIT ], 
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ENERGY ], 
        p_info [ playerid ] [ id ] ) ;
    mysql_tquery ( sql_connection, global_string ) ;

    g_fishing_bag [ playerid ] [ PT_FISHING_START_TIME ] = gettime ( ) ;

    new rodName [ 16 ] ;
	format ( rodName, sizeof rodName, "%s", g_fishing_rods [ rodIndex ] [ FISHING_ROD_NAME ] ) ;

    new requiredProgress ;
    new playerLevel = g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_LEVEL ] ;
    
    switch ( playerLevel )
	{
        case 1: requiredProgress = FISHING_LEVEL_FIRST_PROGRESS ;
        case 2: requiredProgress = FISHING_LEVEL_SECOND_PROGRESS ;
        case 3: requiredProgress = FISHING_LEVEL_THIRD_PROGRESS ;
        case 4: requiredProgress = FISHING_LEVEL_FORTH_PROGRESS ;
        case 5: requiredProgress = FISHING_LEVEL_FIVES_PROGRESS ;
    }

	new Node: node = JSON_Object (
		"rodName",				JSON_String ( rodName ),
		"baitCount",			JSON_Int ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_BAIT ] ),
		"currentProgress",		JSON_Int ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_PROGRESS ] ),
		"maxProgress",			JSON_Int ( requiredProgress ),
		"fishingLevel",			JSON_Int ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_LEVEL ] )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_FISHING_GAME, 0, global_string ) ;
	return 1 ;
}

stock HandleSuccessfulFishing ( playerid )
{
    if ( gettime ( ) - g_fishing_bag [ playerid ] [ PT_FISHING_START_TIME ] < 5 )
	{
        onServerDestroy ( playerid, UI_FISHING_GAME ) ;
		send_check_cinfo ( playerid, "Вы не можете поймать рыбу так быстро.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

    new rodIndex = g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ROD ] - 1,
    	Float: _rod_catch_max_weight = g_fishing_rods [ rodIndex ] [ FISHING_ROD_CATCH_MAX_WEIGHT ],
    	range ;

    new Float: fishWeight = RandomFloatEx ( 1.0, _rod_catch_max_weight ) ;
    if ( fishWeight <= 2.0 ) range = RANGE_1_2 ;
    else if ( fishWeight <= 3.0 ) range = RANGE_2_3 ;
    else if ( fishWeight <= 4.0 ) range = RANGE_3_4 ;
    else if ( fishWeight <= 5.0 ) range = RANGE_4_5 ;
    else range = RANGE_5_6 ;

    new fishIndex = random ( MAX_FISH_TYPES ),
    	fishId = g_fishing_fish_ranges [ range ] [ fishIndex ] [ FISHING_SLOT_INFO_ID ],
    	Float: actualFishWeight = g_fishing_fish_ranges [ range ] [ fishIndex ] [ FISHING_SLOT_INFO_WEIGHT ],
    	fishName [ 32 ] ;

	format ( fishName, sizeof fishName, "%s", g_fishing_fish_ranges [ range ] [ fishIndex ] [ FISHING_SLOT_INFO_NAME ] ) ;
    g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CURR_WEIGHT ] += actualFishWeight ;

	catch_inc_id ++ ;
    for ( new i = 0 ; i < MAX_FISHING_BAG_SLOT ; i ++ )
	{
        if ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT_ID ] [ i ] == 0 )
		{
            g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT ] [ i ] = fishId ;
			g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_SLOT_ID ] [ i ] = catch_inc_id ;
            break ;
        }
    }

	global_string [ 0 ] = EOS ;
    format ( global_string, 256, "INSERT INTO fishing_catch (catch_id, char_id, catch_name, fish_id, weight, catch_time) VALUES (%d, %d, '%s', %d, %.2f, NOW())",
	catch_inc_id, p_info [ playerid ] [ id ], fishName, fishId, actualFishWeight ) ;
    mysql_tquery ( sql_connection, global_string ) ;

	global_string [ 0 ] = EOS ;
    format ( global_string, 128, "UPDATE fishing_bag SET curr_weight = %.2f WHERE char_id = %d LIMIT 1", 
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CURR_WEIGHT ], 
        p_info [ playerid ] [ id ] ) ;
    mysql_tquery ( sql_connection, global_string ) ;

    AddFishingProgress ( playerid, 1 ) ;

	new Node: node = JSON_Object (
		"name",			JSON_String ( fishName ),
		"weight",		JSON_Float ( actualFishWeight )
	) ;

    global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_FISHING_GAME, 1, global_string ) ;
	
	give_event_progress ( playerid, THE_FISHING, floatround ( actualFishWeight ) ) ;
	
	checking_quest_progress ( playerid, 7, floatround ( actualFishWeight ), quest_line_medium ) ;
	
	if ( p_info [ playerid ] [ family ] > 0 )
	{
		give_all_family_quest ( p_info [ playerid ] [ family ], 4, floatround ( actualFishWeight ) ) ;
		
		if ( p_info [ playerid ] [ family_quest ] == 6 )
		{
			if ( p_info [ playerid ] [ family_quest_progress ] < 50 )
			{
				p_info [ playerid ] [ family_quest_progress ] += floatround ( actualFishWeight ) ;
				update_int_sql ( playerid, "u_family_quest_progress", p_info [ playerid ] [ family_quest_progress ] ) ;
			}
			else SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Задание успешно выполнено. Отправляйтесь к квестовому персонажу." ) ;
		}
		else if ( p_info [ playerid ] [ family_quest ] == 7 )
		{
			if ( p_info [ playerid ] [ family_quest_progress ] < 100 )
			{
				p_info [ playerid ] [ family_quest_progress ] += floatround ( actualFishWeight ) ;
				update_int_sql ( playerid, "u_family_quest_progress", p_info [ playerid ] [ family_quest_progress ] ) ;
			}
			else SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Задание успешно выполнено. Отправляйтесь к квестовому персонажу." ) ;
		}
	}

	if ( random ( 100 ) < 10 )
	{
		switch ( random ( 10 ) )
		{
			case 1, 2, 3, 4:
			{
				give_inventory ( playerid, 2684, random ( 10 ) + 3, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				if ( player_device { playerid } == 2 )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cWH"}Вам в инвентарь был добавлен предмет '%s'.\n\
												Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{"#cWH"})", item_name ( 2684 ) ) ;
					send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
				}
				else
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, sizeof global_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2684 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
					SendClientMessage ( playerid, col_yellow, !"* Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{FFFF00})" ) ;
				}
			}
			case 5, 6, 7, 8:
			{
				give_inventory ( playerid, 19941, random ( 10 ) + 3, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				if ( player_device { playerid } == 2 )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cWH"}Вам в инвентарь был добавлен предмет '%s'.\n\
												Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{"#cWH"})", item_name ( 19941 ) ) ;
					send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
				}
				else
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, sizeof global_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 19941 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
					SendClientMessage ( playerid, col_yellow, !"* Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{FFFF00})" ) ;
				}
			}
			case 9:
			{
				new _det_id ;
				switch ( random ( 5 ) )
				{
					case 0: _det_id = 1080 ;
					case 1: _det_id = 1018 ;
					case 2: _det_id = 1038 ;
					case 3: _det_id = 1140 ;
					case 4: _det_id = 1165 ;
				}
				
				give_inventory ( playerid, _det_id, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
				if ( player_device { playerid } == 2 )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cWH"}Вам в инвентарь был добавлен предмет '%s'.\n\
												Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{"#cWH"})", item_name ( _det_id ) ) ;
					send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
				}
				else
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, sizeof global_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _det_id ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
					SendClientMessage ( playerid, col_yellow, !"* Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{FFFF00})" ) ;
				}
			}
		}
	}
	
	give_global_quest ( playerid, 2, floatround ( actualFishWeight ) ) ;
	return 1 ;
}

stock HandleUnsuccessfulFishing ( playerid )
{
    send_check_cinfo ( playerid, "Улов не удался. Попробуйте снова!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
	show_dialog ( playerid, d_fishing_go_1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Рыбалка", "{"#cWH"}Вы хотите продолжить рыбачить?", "Да", "Нет" ) ;
    return 1 ;
}

stock AddFishingProgress ( playerid, newProgress )
{
    g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_PROGRESS ] += newProgress ;
    new playerLevel = g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_LEVEL ] ;
    new requiredProgress ;

    switch ( playerLevel )
	{
        case 1: requiredProgress = FISHING_LEVEL_FIRST_PROGRESS ;
        case 2: requiredProgress = FISHING_LEVEL_SECOND_PROGRESS ;
        case 3: requiredProgress = FISHING_LEVEL_THIRD_PROGRESS ;
        case 4: requiredProgress = FISHING_LEVEL_FORTH_PROGRESS ;
        case 5: requiredProgress = FISHING_LEVEL_FIVES_PROGRESS ;
    }

    if ( g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_PROGRESS ] >= requiredProgress )
	{
        if ( playerLevel < 5 )
		{
            g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_LEVEL ] ++ ;
			send_check_cinfo ( playerid, "Поздравляем! Ваш уровень рыболова повысился.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
			return 1 ;
        }
		else
		{
            g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_PROGRESS ] = requiredProgress ;
        }
    }

    global_string [ 0 ] = EOS ;
    format ( global_string, 128, "UPDATE fishing_bag SET level = %d, progress = %d WHERE char_id = %d LIMIT 1", 
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_LEVEL ], 
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_PROGRESS ], 
        p_info [ playerid ] [ id ] ) ;
    mysql_tquery ( sql_connection, global_string ) ;
	return 1 ;
}

stock UpdatePlayerEnergy ( playerid )
{
    new currentTime = gettime ( ),
    	lastUpdateTime = g_fishing_bag [ playerid ] [ PT_FISHING_ENERGY_LAST_UPDATE ],
    	timeElapsed = currentTime - lastUpdateTime,
    	minutesElapsed = timeElapsed / 60 ;

    if ( minutesElapsed < 1 ) return 1 ;

    new currentEnergy = g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ENERGY ],
    	newEnergy = currentEnergy + minutesElapsed ;

    if ( newEnergy > 100 ) newEnergy = 100 ;

    if ( newEnergy != currentEnergy )
	{
        g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_ENERGY ] = newEnergy ;
        g_fishing_bag [ playerid ] [ PT_FISHING_ENERGY_LAST_UPDATE ] = currentTime ;

		global_string [ 0 ] = EOS ;
        format ( global_string, 128, "UPDATE fishing_bag SET energy = %d, energy_last_update = NOW() WHERE char_id = %d LIMIT 1", 
            newEnergy, g_fishing_bag [ playerid ] [ PLAYER_FISHING_BAG_CHAR_ID ] ) ;
        mysql_tquery ( sql_connection, global_string ) ;
    }
	return 1 ;
}