//#define	MAX_FAMILY 500 // Закрыто, потому что юзаю в моде

#define col_fam_alliance 0xCABAA0FF

#define familywars_online 3
#define family_text_size 12.0

#define fam_level_airdrop 2
#define fam_level_dealer 3
#define fam_level_capture 4

enum
{
	d_family_airdrop = 25000,
	d_family_dealer,
	d_family_dealer_get,
	
	d_family_quest,
	
	d_family_enprises_buy,
	d_family_enprises_owner,
	d_family_enprises_reid,
	d_family_enprises_sell,
	d_family_enprises_sell_money,
	d_family_enprises_sell_ft,
	d_family_enprises_sell_player,
	d_family_enprises_sell_accept,
	d_family_enprises_item
} ;

#define MAX_FAMILY_SETTINGS 9
#define MAX_FAMILY_WAREHOUSE 40
enum _fam_enum_
{
    fam_id,
    fam_name [ 32 ],
    fam_chat_color [ 8 ],
	fam_zone_color,
	fam_creator [ MAX_PLAYER_NAME ],
    fam_nationality,
	fam_settings [ MAX_FAMILY_SETTINGS ],
	fam_enhancement [ 11 ],

	fam_bank,
	fam_house,

	fam_dorm_status,
	fam_max_warn,
	fam_rank_warn,

	fam_members,

	fam_rating,
	fam_ticket,
	fam_zones,
	fam_graffity,
	fam_graffity_color,

	fam_max_car,
	
	fam_money_limit,
	fam_car_cooldown [ 2 ],
	
	fam_quest,
	fam_quest_progress,
	
	fam_payday [ 12 ],
	fam_payday_ticket [ 12 ],
	
	fam_level,
	fam_enprises_count,
	
	fam_slot [ MAX_FAMILY_WAREHOUSE ],
	fam_slot_count [ MAX_FAMILY_WAREHOUSE ],
	fam_slot_date [ MAX_FAMILY_WAREHOUSE ],
	fam_slot_id [ MAX_FAMILY_WAREHOUSE ],
	bool: fam_safe_load
} ;
new family_info [ MAX_FAMILY ] [ _fam_enum_ ] ;
new family_rank [ MAX_FAMILY ] [ 12 ] [ 30 ] ;

new family_count = 0, prise_family_inc_id = 0 ;

new family_top [ 3 ] = { 0, ... } ;
new bonus_family_ticket [ 3 ] = { 3, 2, 1 } ;

new fam_jackdaw [ 6 ] [ 4 ] = { "", "$", "»", "V", "X", "•" } ;
new fam_brand [ 15 ] [ 14 ] = { "", "Family", "Crew", "Squad", "Corporation", "Dynasty", "Empire", "Brotherhood", "Club", "Gang", "Mafia", "Syndicate", "Union", "Guys", "Boys" } ;

new fam_enhancement_cost [ 11 ] = { 1000, 1200, 900, 800, 1100, 2000, 4000, 7000, 6000, 1000, 1500 } ;

/*
	
	Family Graffity
	
*/

enum _fam_graffity
{
	g_fam_id,
	g_fam_object,
	g_fam_member,
	Float: gr_fam_x [ 7 ],
	g_fam_area,
	g_fam_cooldown
} ;
new graf_fam_info [ 100 ] [ _fam_graffity ], count_fam_graffity ;

/*

	Family Place

*/

#define MAX_FAMILY_ENTERPRISES 	10
#define MAX_ENTERPRISES_ITEM	5
enum _fam_enprises
{
	fe_id,
	fe_skin_model,
	
	fe_owner,
	
	fe_price_money,
	fe_price_ft,
	fe_price_level,
	
	fe_hour_money,
	fe_hour_ft,
	fe_hour_rating,
	
	Float: fe_coord [ 3 ],
	Text3D: fe_label,
	fe_name [ 32 ],
	
	fe_reid,
	fe_reid_date,
	fe_reid_level,
	fe_conf_timer,
	fe_time,
	
	fe_pickup,
	fe_money,
	fe_ticket,
	fe_third_minute,
	
	fe_item [ MAX_ENTERPRISES_ITEM ],
	fe_item_count [ MAX_ENTERPRISES_ITEM ]
} ;
new fam_enprises [ MAX_FAMILY_ENTERPRISES ] [ _fam_enprises ] ;
new family_enprises_count = 0 ;

new enprises_item [ ] = { 0, 1, 2, 4, 5, 6, 7, 8, 9, 35, 36, 49, 50, 51, 52, 84, 85, 86, 87, 128, 131, 164, 165, 166, 167, 168, 169, 170, 172, 1242, 1243, 1244, 905, 19941, 1463, 2684, 1080, 1018, 1038, 1140, 1169, 19773, 11746 } ;

callback: load_family_enterprises ( )
{
    new fields ;
	cache_get_data ( family_enprises_count, fields ) ;
	if ( family_enprises_count )
	{
		for ( new i = 0 ; i < family_enprises_count ; i ++ )
		{
			fam_enprises [ i ] [ fe_id ] = cache_get_field_content_int ( i, "fe_id", sql_connection ) ;
			fam_enprises [ i ] [ fe_skin_model ] = cache_get_field_content_int ( i, "fe_skin_model", sql_connection ) ;
			
			fam_enprises [ i ] [ fe_owner ] = cache_get_field_content_int ( i, "fe_owner", sql_connection ) ;
			if ( fam_enprises [ i ] [ fe_owner ] != -1 ) family_info [ fam_enprises [ i ] [ fe_owner ] - 1 ] [ fam_enprises_count ] += 1 ;
			
			fam_enprises [ i ] [ fe_price_money ] = cache_get_field_content_int ( i, "fe_price_money", sql_connection ) ;
			fam_enprises [ i ] [ fe_price_ft ] = cache_get_field_content_int ( i, "fe_price_ft", sql_connection ) ;
			fam_enprises [ i ] [ fe_price_level ] = cache_get_field_content_int ( i, "fe_price_level", sql_connection ) ;
			
			fam_enprises [ i ] [ fe_hour_money ] = cache_get_field_content_int ( i, "fe_hour_money", sql_connection ) ;
			fam_enprises [ i ] [ fe_hour_ft ] = cache_get_field_content_int ( i, "fe_hour_ft", sql_connection ) ;
			fam_enprises [ i ] [ fe_hour_rating ] = cache_get_field_content_int ( i, "fe_hour_rating", sql_connection ) ;
			
			fam_enprises [ i ] [ fe_coord ] [ 0 ] = cache_get_field_content_float ( i, "fe_coord_x", sql_connection ) ;
			fam_enprises [ i ] [ fe_coord ] [ 1 ] = cache_get_field_content_float ( i, "fe_coord_y", sql_connection ) ;
			fam_enprises [ i ] [ fe_coord ] [ 2 ] = cache_get_field_content_float ( i, "fe_coord_z", sql_connection ) ;
			
		    cache_get_field_content ( i, "fe_name", fam_enprises [ i ] [ fe_name ], sql_connection, 32 ) ;
			
			fam_enprises [ i ] [ fe_reid ] = cache_get_field_content_int ( i, "fe_reid", sql_connection ) ;
			fam_enprises [ i ] [ fe_reid_date ] = cache_get_field_content_int ( i, "fe_reid_date", sql_connection ) ;
			fam_enprises [ i ] [ fe_reid_level ] = cache_get_field_content_int ( i, "fe_reid_level", sql_connection ) ;
			
			fam_enprises [ i ] [ fe_money ] = cache_get_field_content_int ( i, "fe_money", sql_connection ) ;
			fam_enprises [ i ] [ fe_ticket ] = cache_get_field_content_int ( i, "fe_ticket", sql_connection ) ;
			
			new sscanf_delimit [ 100 ] ;
			cache_get_field_content ( i, "fe_item", sscanf_delimit, sql_connection, sizeof sscanf_delimit ) ;
			sscanf ( sscanf_delimit, "p<|>ddddd", fam_enprises [ i ] [ fe_item ] [ 0 ], fam_enprises [ i ] [ fe_item ] [ 1 ],
			fam_enprises [ i ] [ fe_item ] [ 2 ], fam_enprises [ i ] [ fe_item ] [ 3 ], fam_enprises [ i ] [ fe_item ] [ 4 ] ) ;
			
			cache_get_field_content ( i, "fe_item_count", sscanf_delimit, sql_connection, sizeof sscanf_delimit ) ;
			sscanf ( sscanf_delimit, "p<|>ddddd", fam_enprises [ i ] [ fe_item_count ] [ 0 ], fam_enprises [ i ] [ fe_item_count ] [ 1 ],
			fam_enprises [ i ] [ fe_item_count ] [ 2 ], fam_enprises [ i ] [ fe_item_count ] [ 3 ], fam_enprises [ i ] [ fe_item_count ] [ 4 ] ) ;
			
			fam_enprises [ i ] [ fe_pickup ] = CreateDynamicPickup ( 1314, 23, fam_enprises [ i ] [ fe_coord ] [ 0 ], fam_enprises [ i ] [ fe_coord ] [ 1 ], fam_enprises [ i ] [ fe_coord ] [ 2 ], 0, 0, -1 ) ;
	   		pick_info [ fam_enprises [ i ] [ fe_pickup ] ] [ pick_type ] = pick_type_family_enprises ;
			pick_info [ fam_enprises [ i ] [ fe_pickup ] ] [ pick_item ] = i ;
			
			CreateDynamicMapIcon ( fam_enprises [ i ] [ fe_coord ] [ 0 ], fam_enprises [ i ] [ fe_coord ] [ 1 ], fam_enprises [ i ] [ fe_coord ] [ 2 ], 60, 0, 0, 0, -1 ) ;
			
			fam_enprises [ i ] [ fe_label ] = CreateDynamic3DTextLabel ( "", col_blue, fam_enprises [ i ] [ fe_coord ] [ 0 ], 
																						fam_enprises [ i ] [ fe_coord ] [ 1 ], 
																						fam_enprises [ i ] [ fe_coord ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
			update_enterprises_label ( i ) ;
		}
	}
	return 1 ;
}

stock update_enterprises_label ( _id )
{
	new s_year, s_month, s_day, s_hour, s_minute, s_second, 
		family_id = fam_enprises [ _id ] [ fe_owner ], reid_family = fam_enprises [ _id ] [ fe_reid ] ;

	global_string [ 0 ] = EOS ;
	new line_string [ 64 ] ;
	format ( line_string, sizeof line_string, "** %s **\n", fam_enprises [ _id ] [ fe_name ] ) ;
	strcat ( global_string, line_string ) ;
	if ( family_id != -1 )
	{
		format ( line_string, sizeof line_string, "{"#cGR3D"}Владелец: {%s}%s\n", family_info [ family_id - 1 ] [ fam_chat_color ], family_info [ family_id - 1 ] [ fam_name ] ) ;
		strcat ( global_string, line_string ) ;
	}
	else strcat ( global_string, "{"#cGR3D"}Владелец: {"#cRD"}Нет\n" ) ;
	if ( reid_family != -1 )
	{
		format ( line_string, sizeof line_string, "{"#cGR3D"}Крайний рейдер: {%s}%s\n", family_info [ reid_family - 1 ] [ fam_chat_color ], family_info [ reid_family - 1 ] [ fam_name ] ) ;
		strcat ( global_string, line_string ) ;
		
		timestamp_to_date ( fam_enprises [ _id ] [ fe_reid_date ] + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
		format ( line_string, sizeof line_string, "{"#cGR3D"}Дата рейда: {"#cWH"}%02d.%02d.%d в %02d:%02d:%02d\n", s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
		strcat ( global_string, line_string ) ;
	}
	else strcat ( global_string, "{"#cGR3D"}Крайний рейдер: {"#cRD"}Нет\n" ) ;
	UpdateDynamic3DTextLabelText ( fam_enprises [ _id ] [ fe_label ], col_blue, global_string ) ;
	return 1 ;
}

stock update_family_level ( _fam_id )
{
	new _fam_level = 1, _h_id = family_info [ _fam_id - 1 ] [ fam_house ] ;
	if ( _h_id )
	{
		_fam_level += 1 ;
		if ( h_info [ _h_id - 1 ] [ h_podezd ] == -1 ) _fam_level += 1 ;
	}
	if ( family_info [ _fam_id - 1 ] [ fam_rating ] > 999 ) _fam_level += floatround ( family_info [ _fam_id - 1 ] [ fam_rating ] / 1000 ) ;
	_fam_level += family_info [ _fam_id - 1 ] [ fam_enprises_count ] ;
	family_info [ _fam_id - 1 ] [ fam_level ] = _fam_level ;
	return _fam_level ;
}

stock show_family_enterprises ( playerid, _item )
{
	new _fam_id = fam_enprises [ _item ] [ fe_owner ] ;
	if ( _fam_id == -1 )
	{
		new header_string [ 48 ], _fam_level = update_family_level ( p_info [ playerid ] [ family ] ) ;
		
		global_string [ 0 ] = EOS ;
		format ( global_string, 512, "\
		{"#cWH"}Предприятие {"#cOR"}%s {"#cWH"}находится на продаже.\n\
		Необходим %s%d уровень семьи {"#cWH"}для приобретения.\n\
		Стоимость точки составляет {"#cWV"}%s"valute_title_" + %s "family_title"{"#cWH"}.\n\
		Прибыль точки составляет {"#cGN"}%s"valute_title_" + %s "family_title" + %s рейтинга.\n\n\
		{"#cGRDialog"}* Вы действительно хотите приобрести данную точку?", fam_enprises [ _item ] [ fe_name ],
		( fam_enprises [ _item ] [ fe_price_level ] > _fam_level ) ? ( "{"#cRD"}" ) : ( "{"#cGN"}" ), fam_enprises [ _item ] [ fe_price_level ],
		GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_price_money ] ), GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_price_ft ] ),
		GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_hour_money ] ), GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_hour_ft ] ), GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_hour_rating ] ) ) ;
		
		format ( header_string, sizeof header_string, "{"#cBHD"}%s", fam_enprises [ _item ] [ fe_name ] ) ;
		show_dialog ( playerid, d_family_enprises_buy, DIALOG_STYLE_MSGBOX, header_string, global_string, "Купить", "Отмена" ) ;
		
		set_player_use_listitem ( playerid, _item ) ;
		return 1 ;
	}
	else if ( _fam_id == p_info [ playerid ] [ family ] )
	{
		new s_year, s_month, s_day, s_hour, s_minute, s_second,
			fam_str [ 64 ], fam_str2 [ 64 ], 
			reid_family = fam_enprises [ _item ] [ fe_reid ],
			_item_count = 0 ;
		if ( reid_family != -1 )
		{
			format ( fam_str, sizeof fam_str, "{%s}%s", family_info [ reid_family - 1 ] [ fam_chat_color ], family_info [ reid_family - 1 ] [ fam_name ] ) ;
			
			timestamp_to_date ( fam_enprises [ _item ] [ fe_reid_date ] + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
			format ( fam_str2, sizeof fam_str2, "%02d.%02d.%d в %02d:%02d:%02d", s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
		}
		else
		{
			format ( fam_str, sizeof fam_str, "{"#cRD"}Нет" ) ;
			format ( fam_str2, sizeof fam_str2, "{"#cRD"}Нет" ) ;
		}
		
		for ( new i = 0 ; i < MAX_ENTERPRISES_ITEM ; i ++ )
		{
			if ( fam_enprises [ _item ] [ fe_item ] [ i ] == -1 ) continue ;
			
			_item_count ++ ;
		}
		
		global_string [ 0 ] = EOS ;
		format ( global_string, 1024, "\
		{"#cBL"}№. Название:\t{"#cBL"}Информация:\n\
		{"#cBL"}1. {"#cWH"}Баланс {"#cGN"}"valute_title_"{"#cWH"}\t{"#cGN"}%s"valute_title_"\n\
		{"#cBL"}2. {"#cWH"}Баланс {"#cGN"}"family_title"{"#cWH"}\t{"#cGN"}%s "family_title"\n\
		{"#cBL"}3. {"#cWH"}Доход {"#cGN"}"valute_title_" {"#cWH"}в час\t{"#cGN"}%s"valute_title_"\n\
		{"#cBL"}4. {"#cWH"}Доход {"#cGN"}"family_title" {"#cWH"}в час\t{"#cGN"}%s "family_title"\n\
		{"#cBL"}5. {"#cWH"}Рейтинга в час\t{"#cGN"}%d очк.\n\
		{"#cBL"}6. {"#cWH"}Склад предприятия\t{"#cWV"}%d {"#cWH"}из {"#cWV"}5 {"#cWH"}предметов\n\
		{"#cBL"}7. {"#cWH"}Крайний рейдер\t%s\n\
		{"#cBL"}8. {"#cWH"}Дата рейда\t%s\n\
		{"#cBL"}9. {"#cWH"}Продать предприятие\t{"#cOR"}%s{"#cWH"}\t \n\
		{"#cBL"}10. {"#cWH"}Информация\t ",
		GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_money ] ),
		GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_ticket ] ),
		GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_hour_money ] ),
		GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_hour_ft ] ),
		fam_enprises [ _item ] [ fe_hour_rating ],
		_item_count, MAX_ENTERPRISES_ITEM,
		fam_str, fam_str2, fam_enprises [ _item ] [ fe_name ] ) ;
		show_dialog ( playerid, d_family_enprises_owner, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Управление", global_string, "Выбрать", "Закрыть" ) ;
		
		set_player_use_listitem ( playerid, _item ) ;
		return 1 ;
	}
	else if ( _fam_id != p_info [ playerid ] [ family ] )
	{
		new s_year, s_month, s_day, s_hour, s_minute, s_second,
			fam_str [ 64 ], fam_str2 [ 64 ], 
			reid_family = fam_enprises [ _item ] [ fe_reid ],
			_item_count = 0 ;
		if ( reid_family != -1 )
		{
			format ( fam_str, sizeof fam_str, "{%s}%s", family_info [ reid_family - 1 ] [ fam_chat_color ], family_info [ reid_family - 1 ] [ fam_name ] ) ;
			
			timestamp_to_date ( fam_enprises [ _item ] [ fe_reid_date ] + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
			format ( fam_str2, sizeof fam_str2, "%02d.%02d.%d в %02d:%02d:%02d", s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
		}
		else
		{
			format ( fam_str, sizeof fam_str, "{"#cRD"}Нет" ) ;
			format ( fam_str2, sizeof fam_str2, "{"#cRD"}Нет" ) ;
		}
		
		for ( new i = 0 ; i < MAX_ENTERPRISES_ITEM ; i ++ )
		{
			if ( fam_enprises [ _item ] [ fe_item ] [ i ] == -1 ) continue ;
			
			_item_count ++ ;
		}
		
		global_string [ 0 ] = EOS ;
		format ( global_string, 1024, "\
		{"#cBL"}№. Название:\t{"#cBL"}Информация:\n\
		{"#cBL"}1. {"#cWH"}Баланс {"#cGN"}"valute_title_"{"#cWH"}\t{"#cGN"}%s"valute_title_"\n\
		{"#cBL"}2. {"#cWH"}Баланс {"#cGN"}"family_title"{"#cWH"}\t{"#cGN"}%s "family_title"\n\
		{"#cBL"}3. {"#cWH"}Доход {"#cGN"}"valute_title_" {"#cWH"}в час\t{"#cGN"}%s"valute_title_"\n\
		{"#cBL"}4. {"#cWH"}Доход {"#cGN"}"family_title" {"#cWH"}в час\t{"#cGN"}%s "family_title"\n\
		{"#cBL"}5. {"#cWH"}Рейтинга в час\t{"#cGN"}%d очк.\n\
		{"#cBL"}6. {"#cWH"}Склад предприятия\t{"#cWV"}%d {"#cWH"}из {"#cWV"}%d {"#cWH"}предметов\n\
		{"#cBL"}7. {"#cWH"}Крайний рейдер\t%s\n\
		{"#cBL"}8. {"#cWH"}Дата рейда\t%s\n\
		{"#cBL"}9. {"#cWH"}Начать рейд {"#cOR"}%s{"#cWH"}\tНеобходим {"#cRD"}%d ур. {"#cWH"}семьи\n\
		{"#cBL"}10. {"#cWH"}Информация\t ",
		GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_money ] ),
		GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_ticket ] ),
		GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_hour_money ] ),
		GetPlayerCashValueToSmile ( fam_enprises [ _item ] [ fe_hour_ft ] ),
		fam_enprises [ _item ] [ fe_hour_rating ],
		_item_count, MAX_ENTERPRISES_ITEM,
		fam_str, fam_str2, fam_enprises [ _item ] [ fe_name ],
		fam_enprises [ _item ] [ fe_reid_level ] ) ;
		show_dialog ( playerid, d_family_enprises_reid, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Информация", global_string, "Выбрать", "Закрыть" ) ;
		
		set_player_use_listitem ( playerid, _item ) ;
		return 1 ;
	}
	return 1 ; 
}

stock show_family_enprises_sell ( playerid )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 512, "\
	{"#cBL"}1. {"#cWH"}Цена в {"#cGN"}"valute_title_"{"#cWH"}\t{"#cGN"}%s"valute_title_"\n\
	{"#cBL"}2. {"#cWH"}Цена в {"#cGN"}"family_title"{"#cWH"}\t{"#cGN"}%s "family_title"\n\
	{"#cBL"}3. {"#cWH"}Нажмите для продажи",
	GetPlayerCashValueToSmile ( sell_price [ playerid ] ), GetPlayerCashValueToSmile ( sell_type [ playerid ] ) ) ;
	show_dialog ( playerid, d_family_enprises_sell, DIALOG_STYLE_TABLIST, "{"#cBHD"}Продажа предприятия", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

/*
	
	Family News
	
*/
new player_last_page [ MAX_PLAYERS ] ;
new bool: player_open_family [ MAX_PLAYERS ] ;

#define MAX_FAMILY_NEWS 10
enum _familyNews
{
	n_id,
	n_text [ 200 ],
	n_text_owner [ MAX_PLAYER_NAME ],
	n_text_date,
	bool: n_free_slot
} ;
new family_news [ MAX_FAMILY ] [ MAX_FAMILY_NEWS ] [ _familyNews ] ;
new bool: family_news_loading [ MAX_FAMILY ] = { false, ... } ;

#define MAX_FAMILY_TRADE_ITEM 39

enum _family_trade
{
	family_name [ 39 ],
	family_price,
	family_prise,
	family_inv_type,
	family_render_type,
	family_render_model
} ;

new family_trade [ MAX_FAMILY_TRADE_ITEM ] [ _family_trade ] =
{
	{ "Рулетка удачи {cd7f32}Bronze{"#cWH"}", 600, 45, GIVE_TYPE_INVENTORY, -1, 1 },
	{ "Рулетка удачи {c8c8c8}Silver{"#cWH"}", 1000, 55, GIVE_TYPE_INVENTORY, -1, 2 },
	{ "Рулетка удачи {c3900a}Gold{"#cWH"}", 1400, 125, GIVE_TYPE_INVENTORY, -1, 3 },
	{ "VIP {cd7f32}Bronze{"#cWH"} (3 дн.)", 500, 24, GIVE_TYPE_INVENTORY, -1, 5 },
	{ "VIP {cd7f32}Bronze{"#cWH"} (5 дн.)", 800, 25, GIVE_TYPE_INVENTORY, -1, 5 },
	{ "VIP {cd7f32}Bronze{"#cWH"} (7 дн.)", 1100, 26, GIVE_TYPE_INVENTORY, -1, 5 },
	{ "VIP {cd7f32}Bronze{"#cWH"} (10 дн.)", 1550, 27, GIVE_TYPE_INVENTORY, -1, 5 },
	{ "VIP {c8c8c8}Silver{"#cWH"} (3 дн.)", 800, 28, GIVE_TYPE_INVENTORY, -1, 5 },
	{ "VIP {c8c8c8}Silver{"#cWH"} (5 дн.)", 1300, 29, GIVE_TYPE_INVENTORY, -1, 5 },
	{ "VIP {c8c8c8}Silver{"#cWH"} (7 дн.)", 1800, 30, GIVE_TYPE_INVENTORY, -1, 5 },
	{ "VIP {c8c8c8}Silver{"#cWH"} (10 дн.)", 2650, 31, GIVE_TYPE_INVENTORY, -1, 5 },
	{ "Респиратор", 3000, 19472, GIVE_TYPE_ACESSORIES, 0, 19472 },
	{ "Чёрная гитара", 3000, 19319, GIVE_TYPE_ACESSORIES, 0, 19319 },
	{ "Белая гитара", 3000, 19318, GIVE_TYPE_ACESSORIES, 0, 19318 },
	{ "Красная гитара", 3000, 19317, GIVE_TYPE_ACESSORIES, 0, 19317 },
	{ "Одежда #34", 3000, skin_cross + 34, GIVE_TYPE_INVENTORY, 2, 34 },
	{ "Одежда #182", 4000, skin_cross + 182, GIVE_TYPE_INVENTORY, 2, 182 },
	{ "Одежда #305", 2000, skin_cross + 305, GIVE_TYPE_INVENTORY, 2, 305 },
	{ "Одежда #304", 2000, skin_cross + 304, GIVE_TYPE_INVENTORY, 2, 304 },
	{ "Одежда #4506", 2000, skin_cross + 4506, GIVE_TYPE_INVENTORY, 2, 4506 },
	{ "Одежда #4646", 5000, skin_cross + 4646, GIVE_TYPE_INVENTORY, 2, 4646 },
	{ "Одежда #4652", 5000, skin_cross + 4652, GIVE_TYPE_INVENTORY, 2, 4652 },
	{ "Одежда #4745", 10000, skin_cross + 4745, GIVE_TYPE_INVENTORY, 2, 4745 },
	{ "Одежда #4746", 10000, skin_cross + 4746, GIVE_TYPE_INVENTORY, 2, 4746 },
	{ "Kia Stinger", 1000, 439, GIVE_TYPE_INVENTORY, 1, 439 },
	{ "Mercedes-Benz G65", 2000, 424, GIVE_TYPE_INVENTORY, 1, 424 },
	{ "Mercedes-Benz G63", 20000, 543, GIVE_TYPE_INVENTORY, 1, 543 },
	{ "Ford Shelby GT500", 10000, 3272, GIVE_TYPE_INVENTORY, 1, 3272 },
	{ "Dodge Challenger SRT", 6000, 3233, GIVE_TYPE_INVENTORY, 1, 3233 },
	{ "Pagani Zonda R", 40000, 3275, GIVE_TYPE_INVENTORY, 1, 3275 },
	{ "Ждун на плечо (Аксессуар)", 10000, 12656, GIVE_TYPE_ACESSORIES, 1, 12656 },
	{ "Медвежонок (Аксессуар)", 10000, 12669, GIVE_TYPE_ACESSORIES, 1, 12669 },
	{ "Тигр (Аксессуар)", 15000, 11766, GIVE_TYPE_ACESSORIES, 1, 11766 },
	{ "Гитара-топор (Аксессуар)", 15000, 11763, GIVE_TYPE_ACESSORIES, 1, 11763 },
	{ "Рюкзак NemeN (Аксессуар)", 5000, 11902, GIVE_TYPE_ACESSORIES, 1, 11902 },
	{ "Рюкзак Clown (Аксессуар)", 5000, 11904, GIVE_TYPE_ACESSORIES, 1, 11904 },
	{ "Молот BAN (Аксессуар)", 5000, 8109, GIVE_TYPE_ACESSORIES, 1, 8109 },
	{ "Рупор WARN (Аксессуар)", 5000, 8110, GIVE_TYPE_ACESSORIES, 1, 8110 },
	{ "Увеличение мест для т/с", 2000, 0, GIVE_TYPE_NONE, -1, 4 }
} ;

new Iterator:family_players[MAX_FAMILY]<MAX_PLAYERS-1>;
new Iterator:family_vehicles[MAX_FAMILY]<MAX_VEHICLES-1>;

new Float: dorm_family_pos [ MAX_FAMILY ] [ 3 ] ;
new dorm_family_virt [ MAX_FAMILY ] ;
new dorm_family_int [ MAX_FAMILY ] ;

new dorm_family_area [ MAX_FAMILY ] ;
new dorm_family_cp [ MAX_FAMILY ] ;
new Text3D:gdorm_family_text [ MAX_FAMILY ] ;

new family_chat_color [ 5 ] [ 8 ] =
{
    "FFFFFF", "FFD39B", "FFFF00", "54FF9F", "98F5FF"
} ;

#define dip_settings_off 0
#define dip_settings_on 1

new family_diplomacy_change [ MAX_FAMILY ] [ MAX_FAMILY ] = { 0, ... } ;
new family_diplomacy [ MAX_FAMILY ] [ MAX_FAMILY ] = { 0, ... } ;
new family_dip_settings [ MAX_FAMILY ] [ MAX_FAMILY ] [ 2 ] ;

/*

	Family Wars

*/

#define MAX_WAR_ZONES 25
enum _fam_wars
{
	gz_id,
	gz_created,
	gz_name [ 32 ],
	Float:pick_pos [ 3 ],
	Float:gz_pos [ 4 ],
	gz_owner,
	gz_attacker,
 	gz_battle,
	gz_time,
	gz_timer,
	Text3D:gz_label,
	gz_hour_talon,
	gz_hour_money,
	gz_pickup,
	gz_last_capture
} ;
new family_wars [ MAX_WAR_ZONES ] [ _fam_wars ] ;

new zones_count = 0,
	zones_captured = -1,
	zones_capture_type,
	zones_kills_first = 0,
	zones_kills_two = 0,
	zones_kills_first_name [ 32 ],
	zones_kills_two_name [ 32 ] ;

new zones_war_cd = 0 ;

new zones_owner_points = -1,
	zones_attacker_points = -1 ;
	
new Text:family_td [ 38 ] ;
new PlayerText:family_ptd [ MAX_PLAYERS ] [ 10 ] ;
new bool: fam_td_status_bool [ MAX_PLAYERS ] ;

/*

	Family Dealer

*/

#define MAX_FAMILY_DEALER 3
new family_dealer_car [ 2 ] = { INVALID_VEHICLE_ID, ... } ;
new family_dealer_npc [ 5 ] = { -1, ... } ;

enum _dealer_info
{
	dealer_name [ 16 ],
	Float: dealer_position [ 3 ]
} ;

new dealer_info [ MAX_FAMILY_DEALER ] [ _dealer_info ] =
{
	{ "пгт. Батырево", { 2682.2504, 2057.8930, 8.0979 } },
	{ "г. Лыткарино", { -2152.1518, 232.6915, 24.6531 } },
	{ "свалки", { -1978.2673, -33.0610, 31.8899 } }
} ;

new Float: dealer_info_car [ MAX_FAMILY_DEALER ] [ 2 ] [ 4 ] =
{
	{
		{ 2673.0454, 2062.3395, 7.1452, 71.5824 },
		{ 2674.5009, 2052.0378, 7.1126, 113.7866 }
	},
	{
		{ -2147.0488, 240.5541, 25.2764, 321.3401 },
		{ -2143.1408, 234.2874, 25.1664, 293.5799 }
	},
	{
		{ -1974.2236, -26.2325, 32.5548, 327.6147 },
		{ -1970.1140, -33.5824, 32.4290, 280.1784 }
	}
} ;

new Float: dealer_info_npc [ MAX_FAMILY_DEALER ] [ 5 ] [ 4 ] =
{
	{
		{ 2677.5949, 2053.5878, 7.3156, 288.1557 },
		{ 2676.3256, 2061.5251, 7.3454, 237.8307 },
		{ 2671.7407, 2060.6674, 6.9245, 193.0224 },
		{ 2673.3439, 2053.2077, 6.9436, 10.0317 },
		{ 2681.8774, 2048.3256, 7.8427, 329.6086 }
	},
	{
		{ -2143.0336, 236.2039, 25.1070, 37.1315 },
		{ -2145.6174, 239.8724, 25.1785, 209.1651 },
		{ -2149.3054, 237.8211, 24.9364, 161.9527 },
		{ -2146.2185, 232.8985, 24.8862, 113.5499 },
		{ -2154.3164, 237.8327, 24.7396, 200.4244 }
	},
	{
		{ -1973.2606, -34.1886, 32.0403, 81.8773 },
		{ -1975.7888, -29.0818, 32.1375, 116.6592 },
		{ -1972.0427, -26.0134, 32.3970, 169.3677 },
		{ -1968.9106, -31.7706, 32.3026, 35.6166 },
		{ -1976.6057, -37.8361, 31.7719, 19.2877 }
	}
} ;

new family_dealer_start = 0 ;
new family_dealer_end = 0 ;
new family_dealer_number = -1 ;
new family_dealer_pickup ;
new family_dealer_area ;
new family_dealer_zone = -1 ;
new family_dealer_rectangle = -1 ;
new Float: dealer_zone_position [ 4 ] ;
new Text3D: family_dealer_label ;
new family_dealer_owner = -1 ;
new bool: family_dealer_time_stop = false ;
new family_dealer_time = 0 ;
new bool: family_dealer_owner_stoped = false ;
new family_dealer_timer = -1 ;
new family_dealer_type = 0 ;
new family_dealer_inventory [ 7 ] = { 0, ... } ;
new bool: day_dealer_car = false ;

new dealer_car_model [ ] = { 409, 550, 551, 3247, 3250, 3256, 3264, 3265, 3267 } ;

/*

	Family AirDrop

*/

#define MAX_FAMILY_AIRDROP 3
new f_air_info [ MAX_FAMILY_AIRDROP ] [ _air_info ] =
{
	{ "пгт. Эдово", { -2120.9345, 2928.4394, 150.8056,	0.0000, 0.0000, 0.0000 }, { -2120.9345, 2928.4394, 1.8056,   0.00, 0.00, 0.00 } },
	{ "пгт. Батырево", { 1311.8331, 1035.5296, 150.9358,	0.0000, 0.0000, 0.0000 }, { 1311.8331, 1035.5296, 17.9358,   0.00, 0.00, 0.00 } },
	{ "г. Южный", { 212.4493, -1841.6608, 150.3458,	0.0000, 0.0000, 0.0000 }, { 212.4493, -1841.6608, 33.3458,   0.00, 0.00, 0.00 } }
} ;

new family_start_airdrop = 0 ;
new family_end_airdrop = 0 ;
new family_airdrop_number = -1 ;
//new family_airdrop_object [ 3 ] = { INVALID_OBJECT_ID, ... } ;
new family_airdrop_pickup ;
new family_airdrop_area ;
new family_airdrop_inventory [ 7 ] = { 0, ... } ;
new family_airdrop_zone = -1 ;
new family_airdrop_rectangle = -1 ;
new Float: family_airzone_position [ 4 ] ;
new Text3D: family_airdrop_label ;
new family_airdrop_owner = -1 ;
new bool: family_airdrop_time_stop = true ;
new family_airdrop_time = 0 ;
new bool: family_aidrop_owner_stoped = false ;
new family_airdrop_timer = -1 ;
new bool: family_airdrop_from_earth = false ;

stock familys_OnDynamicObjectMoved ( objectid )
{
	if ( family_airdrop_object [ 0 ] == objectid && family_airdrop_from_earth == false )
	{
	    new Float: object_x,
			Float: object_y,
			Float: object_z,
			index = -1 ;

		GetDynamicObjectPos ( family_airdrop_object [ 0 ], object_x, object_y, object_z ) ;
		index = object_z == f_air_info [ family_airdrop_number ] [ move_position ] [ 2 ] ? 0 : 1 ;

		if ( ! index )
		{
			if ( IsValidDynamicObject ( family_airdrop_object [ 1 ] ) )
			{
				DestroyDynamicObject ( family_airdrop_object [ 1 ] ) ;
				family_airdrop_object [ 1 ] = INVALID_OBJECT_ID ;
			}
			
			if ( IsValidDynamicObject ( family_airdrop_object [ 2 ] ) )
			{
				DestroyDynamicObject ( family_airdrop_object [ 2 ] ) ;
				family_airdrop_object [ 2 ] = INVALID_OBJECT_ID ;
			}
			
			family_airdrop_from_earth = true ;
		}
		else family_airdrop_from_earth = false ;
		return 1 ;
	}
	return 0 ;
}

#include <custom/family_packet>

/*

	Family Black List

*/

enum _family_black_list
{
	bl_marker,
	bl_finder,
	bl_observe,
	bool: bl_isKilled,
	bl_onFrac [ MAX_FAMILY ],
	bl_kills [ MAX_FAMILY ],
}

new fam_bl_info [ MAX_PLAYERS ] [ _family_black_list ] ;

stock familys_Bl_Init ( playerid )
{
	for ( new i = 0 ; i < family_count ; i ++ )
	{
		fam_bl_info [ playerid ] [ bl_onFrac ] [ i ] =
		fam_bl_info [ playerid ] [ bl_kills ] [ i ] = 0 ;
	}
	fam_bl_info [ playerid ] [ bl_isKilled ] = false ;
	fam_bl_info [ playerid ] [ bl_observe ] =
	fam_bl_info [ playerid ] [ bl_finder ] = INVALID_PLAYER_ID ;
	return 1 ;
}

stock find_family_name ( _family_name [ ] )
{
	for ( new i = 0 ; i < family_count ; i ++ )
	{
		if ( ! GetString ( family_info [ i ] [ fam_name ], _family_name ) ) continue ;
		
		return 1 ;
	}
	
	return 0 ;
}

stock familys_clear_player_data ( playerid )
{
	p_info [ playerid ] [ family_text ] = Text3D:INVALID_3DTEXT_ID ;
	player_open_family [ playerid ] = false ;
	return 1 ;
}

stock family_EnterDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_fam_graffity:
		{
			new _id = area_info [ areaid ] [ a_item ] ;
		    if ( p_t_info [ playerid ] [ graffity ] != -1 ) return 1 ;
			if ( p_info [ playerid ] [ family ] < 1 ) return 1 ;
			if ( admin_info [ playerid ] [ admin ] > 0 && admin_info [ playerid ] [ admin ] < 8 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы администратор." ) ;
			if ( p_info [ playerid ] [ family ] == graf_fam_info [ _id ] [ g_fam_member ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это граффити принадлежит Вашей семье." ) ;
			if ( GetPlayerWeapon ( playerid ) != 41 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет балончика, приобретите его в магазине 24/7." ) ;
			if ( GetPlayerAmmo ( playerid ) < 500 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас не хватает краски в балончике. (1 граффити = 500 ед. балончика)");
			if ( graf_fam_info [ _id ] [ g_fam_cooldown ] > gettime ( ) )
			{
				new line_string [ 128 ], _time = graf_fam_info [ _id ] [ g_fam_cooldown ] - gettime ( ) ;
				format ( line_string, sizeof line_string, "{"#cRInfo"}* {"#cGRInfo"}Граффити можно будет закрасить через %s.", convert_time ( _time, TYPE_TIME_HOUR ) ) ;
				SendClientMessage ( playerid, col_gray, line_string ) ;
				return 1 ;
			}
	
			graf_fam_info [ _id ] [ g_fam_cooldown ] = SetElapsedTime ( gettime ( ), 2, CONVERT_TIME_TO_HOURS ) ;

			if ( GetPlayerAmmo ( playerid ) == 500 )
			{
			    set_player_ammo ( playerid, 41, 0 ) ;
				SetPlayerArmedWeapon ( playerid, 0 ) ;
			}
			else set_player_ammo ( playerid, 41, GetPlayerAmmo ( playerid ) - 500 ) ;

			p_t_info [ playerid ] [ graffity ] = _id ;

			if ( player_device { playerid } == 2 )
			{
				action_type { playerid } = ACTION_FAM_GRAFFITY ;
				actionShow ( playerid, "Граффити", 100 ) ;

				ApplyAnimation ( playerid, "SPRAYCAN", "spraycan_full", 4.0, 1, 1, 1, 0, 0, 1 ) ;
			    return 1 ;
		   	}

			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Вы начали рисовать граффити. Нажимайте на кнопки, которые высвечиваются у Вас на экране." ) ;

			action_type { playerid } = ACTION_FAM_GRAFFITY ;
			action_step { playerid } = 0 ;
			action_td_status ( playerid, true ) ;

			ApplyAnimation ( playerid, "SPRAYCAN", "spraycan_full", 4.0, 1, 1, 1, 0, 0, 1 ) ;
			return 1 ;
		}
		case area_type_family_airdrop:
		{
			new vehicleid = GetPlayerVehicleID ( playerid ) ;
			if ( vehicleid < 1 ) return 1 ;
		   	if ( ! v_bike ( vehicleid ) && ! v_plane ( vehicleid ) && ! v_boat ( vehicleid ) )
		    {
		    	sc_Handling_OnVehicleStreamIn ( vehicleid, playerid, 30, 5 ) ;
			   	SendClientMessage ( playerid, col_gray, !"{"#cRD"}* Вы попали в зону в которой действует ограничение скорости." ) ;
			   	SendClientMessage ( playerid, col_gray, !"{"#cRD"}* Покинув зону скорость восстановится." ) ;
			}
			return 1 ;
		}
		case area_type_family_airdrop1:
		{
			if ( family_aidrop_owner_stoped == false ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Битва за посылку не окончена." ) ;
		    if ( family_airdrop_owner != p_info [ playerid ] [ family ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Посылка принадлежит не Вашей семьи." ) ;
		
			global_string [ 0 ] = EOS ;
			format ( global_string, 512, "{"#cBL"}1. {"#cWH"}Ящики с Desert Eagle:\t{"#cGN"}%d {"#cWH"}шт.\n\
										{"#cBL"}2. {"#cWH"}Ящики с AK47:\t{"#cGN"}%d {"#cWH"}шт.\n\
										{"#cBL"}3. {"#cWH"}Ящики с M4A1:\t{"#cGN"}%d {"#cWH"}гр.\n\
										{"#cBL"}4. {"#cWH"}Ящики с патронами:\t{"#cGN"}%d {"#cWH"}шт.\n\
										{"#cBL"}5. {"#cWH"}Ящики с бронежилетами:\t{"#cGN"}%d {"#cWH"}шт.\n\
										{"#cBL"}5. {"#cWH"}Ящики с Silenced 9mm:\t{"#cGN"}%d {"#cWH"}шт.\n\
										{"#cBL"}5. {"#cWH"}Ящики с Shotgun:\t{"#cGN"}%d {"#cWH"}шт.",
			family_airdrop_inventory [ 0 ], family_airdrop_inventory [ 1 ], family_airdrop_inventory [ 2 ],
			family_airdrop_inventory [ 3 ], family_airdrop_inventory [ 4 ], family_airdrop_inventory [ 5 ], family_airdrop_inventory [ 6 ] ) ;

			show_dialog ( playerid, d_family_airdrop, DIALOG_STYLE_TABLIST, "{"#cBHD"}Посылка", global_string, "Выбрать", "Закрыть" ) ;
		    return 1 ;
		}
		case area_type_family_dealer:
		{
			new vehicleid = GetPlayerVehicleID ( playerid ) ;
			if ( vehicleid < 1 ) return 1 ;
		   	if ( ! v_bike ( vehicleid ) && ! v_plane ( vehicleid ) && ! v_boat ( vehicleid ) )
		    {
		    	sc_Handling_OnVehicleStreamIn ( vehicleid, playerid, 30, 5 ) ;
			   	SendClientMessage ( playerid, col_gray, !"{"#cRD"}* Вы попали в зону в которой действует ограничение скорости." ) ;
			   	SendClientMessage ( playerid, col_gray, !"{"#cRD"}* Покинув зону скорость восстановится." ) ;
			}
			return 1 ;
		}
		case area_type_family_dealer1:
		{
			if ( family_dealer_owner_stoped == false ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Битва за поставку не окончена." ) ;
		    if ( family_dealer_owner != p_info [ playerid ] [ family ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Поставка принадлежит не Вашей семьи." ) ;

			global_string [ 0 ] = EOS ;
			if ( family_dealer_type == 0 )
			{
				format ( global_string, 300, "{"#cBL"}1. {"#cWH"}Бронежилеты (1 уровень):\t{"#cGN"}%d {"#cWH"}шт.\n\
												{"#cBL"}2. {"#cWH"}Бронежилеты (2 уровень):\t{"#cGN"}%d {"#cWH"}шт.\n\
												{"#cBL"}3. {"#cWH"}Бронежилеты (3 уровень):\t{"#cGN"}%d {"#cWH"}шт.", 
				family_dealer_inventory [ 0 ], family_dealer_inventory [ 1 ], family_dealer_inventory [ 2 ] ) ;
				
				show_dialog ( playerid, d_family_dealer, DIALOG_STYLE_TABLIST, "{"#cBHD"}Поставка", global_string, "Выбрать", "Закрыть" ) ;
			}
			else if ( family_dealer_type == 1 )
			{
				format ( global_string, 356, "{"#cBL"}1. {"#cWH"}Золото:\t{"#cGN"}%d {"#cWH"}шт.\n\
											{"#cBL"}2. {"#cWH"}Хлопок:\t{"#cGN"}%d {"#cWH"}шт.\n\
											{"#cBL"}3. {"#cWH"}Колесо:\t{"#cGN"}%d {"#cWH"}шт.\n\
											{"#cBL"}4. {"#cWH"}Выхлопная труба:\t{"#cGN"}%d {"#cWH"}шт.\n\
											{"#cBL"}5. {"#cWH"}Элемент крыши:\t{"#cGN"}%d {"#cWH"}шт.\n\
											{"#cBL"}6. {"#cWH"}Бампер:\t{"#cGN"}%d {"#cWH"}шт.\n\
											{"#cBL"}7. {"#cWH"}Задний бампер:\t{"#cGN"}%d {"#cWH"}шт.", 
				family_dealer_inventory [ 0 ], family_dealer_inventory [ 1 ], family_dealer_inventory [ 2 ], 
				family_dealer_inventory [ 3 ], family_dealer_inventory [ 4 ], family_dealer_inventory [ 5 ], family_dealer_inventory [ 6 ] ) ;
				
				show_dialog ( playerid, d_family_dealer, DIALOG_STYLE_TABLIST, "{"#cBHD"}Поставка", global_string, "Выбрать", "Закрыть" ) ;
			}
			else if ( family_dealer_type == 2 )
			{
				format ( global_string, 300, "{"#cBL"}1. {"#cWH"}Транспорт в семью:\t{"#cGN"}%s", GetVehicleNameEx ( -1, family_dealer_inventory [ 0 ] ) ) ;
				
				show_dialog ( playerid, d_none, DIALOG_STYLE_TABLIST, "{"#cBHD"}Поставка", global_string, "Закрыть", "" ) ;
			}
		    return 1 ;
		}
		case area_type_family_dorm:
		{
			if ( ! p_info [ playerid ] [ family ] ) return 1 ;
			
			new family_id = p_info [ playerid ] [ family ] ;
			if ( areaid == dorm_family_area [ family_id - 1 ] )
			{
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) )
				{
					RemovePlayerAttachedObject ( playerid, 1 ) ;
					if ( p_info [ playerid ] [ robbery_money ] > 0 )
					{
						new _money = p_info [ playerid ] [ robbery_money ] ;
						p_info [ playerid ] [ robbery_money ] = 0 ;
						
						family_info [ family_id - 1 ] [ fam_bank ] += _money ;
						update_fdorm_text ( family_id ) ;
						
						new fm_string [ 144 ] ;
						format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] %s %s[%i] доставил(а) инкассацию в размере %d"valute_title_"", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, _money ) ;
						family_message ( family_id, col_gray, fm_string ) ;

						fm_string [ 0 ] = EOS ;
						mysql_format ( sql_connection, fm_string, sizeof fm_string, "UPDATE `family` SET `fam_bank` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_bank ], family_id ) ;
						mysql_tquery ( sql_connection, fm_string ) ;

						fm_string [ 0 ] = EOS ;
						format ( fm_string, sizeof fm_string, "%s доставил(а) инкассацию в размере %d"valute_title".", p_info [ playerid ] [ name ], _money ) ;
						write_family ( playerid, family_id, TYPE_LOG_OBWYAK, fm_string ) ;
					}
					else if ( p_info [ playerid ] [ robbery_ft ] > 0 )
					{
						new _money = p_info [ playerid ] [ robbery_ft ] ;
						p_info [ playerid ] [ robbery_ft ] = 0 ;
						
						family_info [ family_id - 1 ] [ fam_ticket ] += _money ;
						update_fdorm_text ( family_id ) ;
						
						new fm_string [ 144 ] ;
						format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] %s %s[%i] доставил(а) инкассацию в размере %d "family_title".", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, _money ) ;
						family_message ( family_id, col_gray, fm_string ) ;

						fm_string [ 0 ] = EOS ;
						mysql_format ( sql_connection, fm_string, sizeof fm_string, "UPDATE `family` SET `fam_ticket` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_bank ], family_id ) ;
						mysql_tquery ( sql_connection, fm_string ) ;

						fm_string [ 0 ] = EOS ;
						format ( fm_string, sizeof fm_string, "%s доставил(а) инкассацию в размере %d "family_title".", p_info [ playerid ] [ name ], _money ) ;
						write_family ( playerid, family_id, TYPE_LOG_OBWYAK, fm_string ) ;
					}
					return 1 ;
				}
				
				if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 7 ] )
				{
					static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Общак доступен с ранга %s (%d)." ;
					new scm_string [ sizeof _str + 30 + 4 ] ;
					format ( scm_string, sizeof scm_string, _str, family_rank [ family_id - 1 ] [ family_info [ family_id - 1 ] [ fam_settings ] [ 7 ] - 1 ], family_info [ family_id - 1 ] [ fam_settings ] [ 7 ] ) ;
					SendClientMessage ( playerid, col_gray, scm_string ) ;
					return 1 ;
				}
				
			    if ( ! family_info [ family_id - 1 ] [ fam_safe_load ] )
			    {
					static const _str [ ] = "SELECT * FROM `family_prise` WHERE `fam_id` = '%d' LIMIT %d" ;
					new sql_string [ sizeof _str + ( 2 * 9 ) ] ;
			       	format ( sql_string, sizeof ( sql_string ), _str, family_id, MAX_FAMILY_WAREHOUSE ) ;
					mysql_tquery ( sql_connection, sql_string, "callback_prise_family_loading", "i", family_id ) ;
			    }
				
				if ( have_box [ playerid ] )
				{
				    new _box = box_submarine [ playerid ] - 1 ;
					RemovePlayerAttachedObject ( playerid, 0 ) ;
					ClearAnimations ( playerid ) ;
					ApplyAnimation ( playerid, "CARRY", "putdwn", 4.0, 0, 1, 1, 0, 0, 1 ) ;

					have_box [ playerid ] = false ;
					box_submarine [ playerid ] = 0 ;
					p_t_info [ playerid ] [ p_animation ] = false ;

					static const _box_id [ ] = { 164, 165, 166, 167, 168, 169, 170 } ;
					new _slot = give_family_item ( family_id, _box_id [ _box ], 1 ) ;
					if ( _slot == -1 )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}На складе семьи нет свободного места." ) ;
					    return 1 ;
					}
					return 1 ;
				}
				
				show_family_dorm ( playerid ) ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock family_LeaveDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_family_airdrop:
		{
			new vehicleid = GetPlayerVehicleID ( playerid ) ;
			if ( vehicleid < 1 ) return 1 ;
			
		    #if defined m_t_stage
			new _minus_speed = 0 ;
			if ( veh_info [ vehicleid - 1 ] [ v_millage ] > 100 ) _minus_speed = floatround ( veh_info [ vehicleid - 1 ] [ v_millage ] / 100 ) ;
			new Float: _max_speed = max_veh_speed ( getReplacableVehicleModel ( vehicleid ) ) + stage_info_speed ( vehicleid ) - _minus_speed ;
			#else
			new Float: _max_speed = max_veh_speed ( getReplacableVehicleModel ( vehicleid ) ) ;
			#endif

			if ( player_device { playerid } == 2 )
			{
			    if ( ! v_bike ( vehicleid ) && ! v_plane ( vehicleid ) && ! v_boat ( vehicleid ) )
			    {
			        #if defined m_t_stage
				    	sc_Handling_OnVehicleStreamIn ( vehicleid, playerid, _max_speed, getSpeedReplacable ( _max_speed ) ) ;
					#else
				   		sc_Handling_OnVehicleStreamIn ( vehicleid, playerid, _max_speed, getSpeedReplacable ( _max_speed ) ) ;
					#endif
				}
			}

			SendClientMessage ( playerid, col_gray, !"{"#cRD"}* Скорость у транспортного средства была восстановлена." ) ;
			return 1 ;
		}
		case area_type_family_dealer:
		{
			new vehicleid = GetPlayerVehicleID ( playerid ) ;
			if ( vehicleid < 1 ) return 1 ;
			
		    #if defined m_t_stage
			new _minus_speed = 0 ;
			if ( veh_info [ vehicleid - 1 ] [ v_millage ] > 100 ) _minus_speed = floatround ( veh_info [ vehicleid - 1 ] [ v_millage ] / 100 ) ;
			new Float: _max_speed = max_veh_speed ( getReplacableVehicleModel ( vehicleid ) ) + stage_info_speed ( vehicleid ) - _minus_speed ;
			#else
			new Float: _max_speed = max_veh_speed ( getReplacableVehicleModel ( vehicleid ) ) ;
			#endif

			if ( player_device { playerid } == 2 )
			{
			    if ( ! v_bike ( vehicleid ) && ! v_plane ( vehicleid ) && ! v_boat ( vehicleid ) )
			    {
			        #if defined m_t_stage
				    	sc_Handling_OnVehicleStreamIn ( vehicleid, playerid, _max_speed, getSpeedReplacable ( _max_speed ) ) ;
					#else
				   		sc_Handling_OnVehicleStreamIn ( vehicleid, playerid, _max_speed, getSpeedReplacable ( _max_speed ) ) ;
					#endif
				}
			}

			SendClientMessage ( playerid, col_gray, !"{"#cRD"}* Скорость у транспортного средства была восстановлена." ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock graffity_painted ( playerid )
{
	new family_id = p_info [ playerid ] [ family ] ;
	if ( family_id < 1 ) return 1 ;
	
	new sql_string [ 100 ], i = p_t_info [ playerid ] [ graffity ] ;
	if ( graf_fam_info [ i ] [ g_fam_member ] > 0 )
	{
		new owner_fam_id = graf_fam_info [ i ] [ g_fam_member ] ;
		family_info [ owner_fam_id - 1 ] [ fam_graffity ] -- ;
	
		format ( sql_string, sizeof ( sql_string ), "{%s}[FAM] Одно из Ваших граффити закрасила другая семья!", family_info [ owner_fam_id - 1 ] [ fam_chat_color ] ) ;
		family_message ( owner_fam_id, col_gray, sql_string ) ;
	}

	graf_fam_info [ i ] [ g_fam_member ] = family_id ;
	family_info [ family_id - 1 ] [ fam_graffity ] ++ ;
	
	DestroyDynamicObject ( graf_fam_info [ i ] [ g_fam_object ] ) ;
	graf_fam_info [ i ] [ g_fam_object ] = CreateDynamicObject ( 2934, graf_fam_info [ i ] [ gr_fam_x ] [ 0 ], graf_fam_info [ i ] [ gr_fam_x ] [ 1 ], graf_fam_info [ i ] [ gr_fam_x ] [ 2 ], graf_fam_info [ i ] [ gr_fam_x ] [ 3 ], graf_fam_info [ i ] [ gr_fam_x ] [ 4 ], graf_fam_info [ i ] [ gr_fam_x ] [ 5 ], 0, 0 ) ;
	
	static const _color [ ] [ 10 ] =
	{
		"{ffffff}",
		"{ad01bc}",
		"{ffa200}",
		"{861400}",
		"{00de00}",
		"{e9ff00}",
		"{0c00ff}",
		"{00b7ff}",
		"{ff00ff}",
		"{ff0000}"
	} ;

	sql_string [ 0 ] = EOS ;
	format ( sql_string, sizeof sql_string, "%s%s", _color [ family_info [ family_id - 1 ] [ fam_graffity_color ] ], family_info [ family_id - 1 ] [ fam_name ] ) ;
	SetDynamicObjectMaterialText(graf_fam_info [ i ] [ g_fam_object ], 0, sql_string, 130, "Ariel", 48, 1, 0xFFFFFAF0, 0x00000000, 1);
	
	sql_string [ 0 ] = EOS ;
	format ( sql_string, sizeof sql_string, "UPDATE `family_grafity` SET `g_member` = '%d' WHERE `g_id` = '%d' LIMIT 1", graf_fam_info [ i ] [ g_fam_member ], graf_fam_info [ i ] [ g_fam_id ] ) ;
	mysql_tquery ( sql_connection, sql_string, "", "" ) ;
	
	family_info [ family_id - 1 ] [ fam_rating ] += 1 ;

	sql_string [ 0 ] = EOS ;
	format ( sql_string, sizeof ( sql_string ), "{%s}[FAM] В семью начислен бонус рейтинга (+1 очков) за закраску граффити!", family_info [ family_id - 1 ] [ fam_chat_color ] ) ;
	family_message ( family_id, col_gray, sql_string ) ;
	
	p_info [ playerid ] [ family_ticket ] += 1 ;
	update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;
	
	give_money ( playerid, 500 ) ;
    insert_money_log ( playerid, INVALID_PLAYER_ID, 500, "семейное граффити" ) ;
	
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы получили {"#cGInfo"}1 "family_title"{"#cWH"} и {"#cGInfo"}500"valute_title"{"#cWH"}." ) ;

	p_t_info [ playerid ] [ graffity ] = -1 ;
	ClearAnimations ( playerid ) ;

	action_td_status ( playerid, false ) ;
	return 1 ;
}

callback: family_enterprises_timer ( _id, _attack_family, _defeat_family )
{
	new _time = fam_enprises [ _id ] [ fe_time ] ;
	if ( _time > 1 )
	{
	    fam_enprises [ _id ] [ fe_time ] -- ;

	    new temp [ 16 ] ;
	    format ( temp, sizeof temp, "~r~%i", _time - 1 ) ;
	    foreach(new i: logged_players)
	    {
			new _family = p_info [ i ] [ family ] ;
   	 		if ( _family == _attack_family )
			{
				if ( conf_td_status_bool [ i ] == false )
				{
					conf_td_status_bool [ i ] = true ;
					show_conf_ptd ( i, true ) ;
				}
				PlayerTextDrawSetString ( i, conf_ptd [ i ], temp ) ;
				continue ;
			}
			else if ( _family == _defeat_family )
			{
				if ( conf_td_status_bool [ i ] == false )
				{
					conf_td_status_bool [ i ] = true ;
					show_conf_ptd ( i, true ) ;
				}
				PlayerTextDrawSetString ( i, conf_ptd [ i ], temp ) ;
				continue ;
			}
			else
			{
				if ( conf_td_status_bool [ i ] == true )
				{
					conf_td_status_bool [ i ] = false ;
					show_conf_ptd ( i, false ) ;
				}
			}
		}
		
		if ( _time == 1 )
		{
			KillTimer ( fam_enprises [ _id ] [ fe_conf_timer ] ) ;
	        fam_enprises [ _id ] [ fe_conf_timer ] = -1 ;
			fam_enprises [ _id ] [ fe_time ] = 0 ;
			
      		foreach(new i: logged_players)
			{
				new _family = p_info [ i ] [ family ] ;
				if ( _family == _attack_family )
			    {
					if ( conf_td_status_bool [ i ] == true )
					{
						conf_td_status_bool [ i ] = false ;
						show_conf_ptd ( i, false ) ;
					}
					continue ;
			    }
				else if ( _family == _defeat_family )
				{
					if ( conf_td_status_bool [ i ] == true )
					{
						conf_td_status_bool [ i ] = false ;
						show_conf_ptd ( i, false ) ;
					}
				    continue ;
				}
			}
			
			family_info [ _attack_family - 1 ] [ fam_rating ] += 25 ;
			family_info [ _defeat_family - 1 ] [ fam_rating ] -= 25 ;
			
        	global_string [ 0 ] = EOS ;
			format ( global_string, 144, "{%s}[FAM] Рейд предприятия '%s' завершён! В семью начислен бонус рейтинга. (+25 очков)", family_info [ _attack_family - 1 ] [ fam_chat_color ], fam_enprises [ _id ] [ fe_name ] ) ;
			family_message ( _attack_family, col_gray, global_string ) ;

			format ( global_string, 144, "{%s}[FAM] Рейд предприятия '%s' завершён! Ваша семья потеряла рейтинг. (-25 очков)", family_info [ _defeat_family - 1 ] [ fam_chat_color ], fam_enprises [ _id ] [ fe_name ] ) ;
			family_message ( _defeat_family, col_gray, global_string ) ;
		}
	}

	fam_enprises [ _id ] [ fe_third_minute ] ++ ;
	if ( fam_enprises [ _id ] [ fe_third_minute ] < 180 ) return 1 ;
	else fam_enprises [ _id ] [ fe_third_minute ] = 0 ;

	if ( _time > 1 )
	{
	    new attack_player = 0 ;
	    foreach(new i: family_players[_defeat_family])
	    {
	        if ( IsPlayerInRangeOfPoint ( i, 100.0, fam_enprises [ _id ] [ fe_coord ] [ 0 ], fam_enprises [ _id ] [ fe_coord ] [ 1 ], fam_enprises [ _id ] [ fe_coord ] [ 2 ] ) )
			{
				attack_player += 1 ;
			}
	    }
	    if ( attack_player < 1 )
	    {
			KillTimer ( fam_enprises [ _id ] [ fe_conf_timer ] ) ;
	        fam_enprises [ _id ] [ fe_conf_timer ] = -1 ;
			fam_enprises [ _id ] [ fe_time ] = 0 ;

			foreach(new i: logged_players)
			{
				new _family = p_info [ i ] [ family ] ;
				if ( _family == _attack_family )
			    {
					if ( conf_td_status_bool [ i ] == true )
					{
						conf_td_status_bool [ i ] = false ;
						show_conf_ptd ( i, false ) ;
					}
					continue ;
			    }
				else if ( _family == _defeat_family )
				{
					if ( conf_td_status_bool [ i ] == true )
					{
						conf_td_status_bool [ i ] = false ;
						show_conf_ptd ( i, false ) ;
					}
				    continue ;
				}
			}
			
        	global_string [ 0 ] = EOS ;
			format ( global_string, 128, "{%s}[FAM] Рейд предприятия '%s' завершён! Предприятие удержано.", family_info [ _attack_family - 1 ] [ fam_chat_color ], fam_enprises [ _id ] [ fe_name ] ) ;
			family_message ( _attack_family, col_gray, global_string ) ;

			format ( global_string, 128, "{%s}[FAM] Рейд предприятия '%s' завершён! Предприятие удержано.", family_info [ _defeat_family - 1 ] [ fam_chat_color ], fam_enprises [ _id ] [ fe_name ] ) ;
			family_message ( _defeat_family, col_gray, global_string ) ;
	    }
	}
	return 1 ;
}

new family_hour_cd [ 2 ] = 0 ;
stock familys_second_timer ( _type_timer, _hour )
{
	if ( _type_timer == 2 )
	{
		if ( family_hour_cd [ 0 ] < 6 ) family_hour_cd [ 0 ] ++ ;
		if ( family_hour_cd [ 1 ] < 4 ) family_hour_cd [ 1 ] ++ ;
	
		new fm_string [ 128 ] ;
		if ( family_hour_cd [ 0 ] < 6 )
		{
			for ( new i = 0 ; i < family_count ; i ++ )
			{
				if ( family_info [ i ] [ fam_zones ] < 1 ) continue ;
				
				format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] Бонус за территории будет начислен через %d час(ов).", family_info [ i ] [ fam_chat_color ], 6 - family_hour_cd [ 0 ] ) ;
				family_message ( i + 1, col_gray, fm_string ) ;
				break ;
			}
		}
		else
		{
			for ( new i = 0 ; i < family_count ; i ++ )
			{
				if ( family_info [ i ] [ fam_zones ] < 1 ) continue ;
				
				new _count_money = 0, _count_ticket = 0 ;
				for ( new zone_id = 0 ; zone_id < zones_count ; zone_id ++ )
				{
					new _family_id = family_wars [ zone_id ] [ gz_owner ] ;
					if ( _family_id == 0 ) continue ;
					
					if ( family_info [ _family_id - 1 ] [ fam_bank ] < max_money )
					{
						family_info [ _family_id - 1 ] [ fam_bank ] += family_wars [ zone_id ] [ gz_hour_money ] ;
						_count_money += family_wars [ zone_id ] [ gz_hour_money ] ;
					}
					family_info [ _family_id - 1 ] [ fam_ticket ] += family_wars [ zone_id ] [ gz_hour_talon ] ;
					_count_ticket += family_wars [ zone_id ] [ gz_hour_talon ] ;
					update_fdorm_text ( _family_id ) ;
				}
				
				if ( _count_money > 0 )
				{
					format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] В семью начислен бонус за территории в размере %d"valute_title_" и %d "family_title".", family_info [ i ] [ fam_chat_color ], _count_money, _count_ticket ) ;
					family_message ( i + 1, col_gray, fm_string ) ;
				}
				else
				{
					format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] У Вашей семьи нет подконтрольных территорий.", family_info [ i ] [ fam_chat_color ] ) ;
					family_message ( i + 1, col_gray, fm_string ) ;
				}
			}
		}
		
		if ( family_hour_cd [ 1 ] < 4 )
		{
			for ( new i = 0 ; i < family_count ; i ++ )
			{
				if ( family_info [ i ] [ fam_graffity ] < 1 ) continue ;
				
				format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] Бонус за граффити будет начислен через %d час(ов).", family_info [ i ] [ fam_chat_color ], 4 - family_hour_cd [ 1 ] ) ;
				family_message ( i + 1, col_gray, fm_string ) ;
				break ;
			}
		}
		else
		{
			new _count_money = 0, _count_ticket = 0 ;
			for ( new i = 0 ; i < family_count ; i ++ )
			{
				if ( family_info [ i ] [ fam_graffity ] < 1 ) continue ;
				
				new _fam_graffitys = family_info [ i ] [ fam_graffity ] ;
				if ( family_info [ i ] [ fam_bank ] < max_money )
				{
					family_info [ i ] [ fam_bank ] += 500 * _fam_graffitys ;
					_count_money = 500 * _fam_graffitys ;
				}
				family_info [ i ] [ fam_ticket ] += 1 * _fam_graffitys ;
				_count_ticket = 1 * _fam_graffitys ;
				update_fdorm_text ( i + 1 ) ;
				
				if ( _count_money > 0 )
				{
					format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] В семью начислен бонус за граффити в размере %d"valute_title_" и %d "family_title".", family_info [ i ] [ fam_chat_color ], _count_money, _count_ticket ) ;
					family_message ( i + 1, col_gray, fm_string ) ;
				}
				else
				{
					format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] У Вашей семьи нет подконтрольных граффити.", family_info [ i ] [ fam_chat_color ] ) ;
					family_message ( i + 1, col_gray, fm_string ) ;
				}
			}
		}
		
		if ( family_hour_cd [ 0 ] >= 6 ) family_hour_cd [ 0 ] = 0 ;
		if ( family_hour_cd [ 1 ] >= 4 ) family_hour_cd [ 1 ] = 0 ;
		
		for ( new family_id = 0 ; family_id < family_count ; family_id ++ )
		{
			if ( family_info [ family_id ] [ fam_enhancement ] [ 8 ] )
			{
				if ( family_info [ family_id ] [ fam_house ] > 0 )
				{
					new family_house = family_info [ family_id ] [ fam_house ] ;
					h_info [ family_house - 1 ] [ h_prods ] = 500 ;
				}
			}
			if ( family_info [ family_id ] [ fam_enhancement ] [ 9 ] ) family_info [ family_id ] [ fam_ticket ] ++ ;
			if ( family_info [ family_id ] [ fam_enhancement ] [ 10 ] ) family_info [ family_id ] [ fam_ticket ] ++ ;
		}
		
		mysql_tquery ( sql_connection, !"SELECT `fam_id` FROM `family` ORDER BY `family`.`fam_rating` DESC LIMIT 3", "family_itog_callback", "" ) ;
		
		if ( _hour >= 12 && _hour <= 20 )
		{
			for ( new i = 0 ; i < family_enprises_count ; i ++ )
			{
				for ( new j = 0 ; j < MAX_ENTERPRISES_ITEM ; j ++ )
				{
					if ( fam_enprises [ i ] [ fe_item ] [ j ] != -1 )
					{
						if ( random ( 5 ) == 1 ) 
						{
							if ( fam_enprises [ i ] [ fe_item_count ] [ j ] < 3 ) fam_enprises [ i ] [ fe_item_count ] [ j ] += 1 ;
						}
					}
					else
					{
						if ( random ( 10 ) == 1 )
						{
							fam_enprises [ i ] [ fe_item ] [ j ] = enprises_item [ random ( sizeof enprises_item ) ] ;
							fam_enprises [ i ] [ fe_item_count ] [ j ] = 1 ;
						}
					}
					
					global_string [ 0 ] = EOS ;
					format ( global_string, 512, "UPDATE `family_enprises` SET `fe_item` = '%d|%d|%d|%d|%d', `fe_item_count` = '%d|%d|%d|%d|%d' WHERE `fe_id` = '%d' LIMIT 1", 
					fam_enprises [ i ] [ fe_item ] [ 0 ], fam_enprises [ i ] [ fe_item ] [ 1 ], fam_enprises [ i ] [ fe_item ] [ 2 ], fam_enprises [ i ] [ fe_item ] [ 3 ], fam_enprises [ i ] [ fe_item ] [ 4 ],
					fam_enprises [ i ] [ fe_item_count ] [ 0 ], fam_enprises [ i ] [ fe_item_count ] [ 1 ], fam_enprises [ i ] [ fe_item_count ] [ 2 ], fam_enprises [ i ] [ fe_item_count ] [ 3 ], fam_enprises [ i ] [ fe_item_count ] [ 4 ], 
					fam_enprises [ i ] [ fe_id ] ) ;
					mysql_tquery ( sql_connection, global_string ) ;
				}
				
				if ( fam_enprises [ i ] [ fe_owner ] == -1 ) continue ;
				
				fam_enprises [ i ] [ fe_money ] += fam_enprises [ i ] [ fe_hour_money ] ;
				fam_enprises [ i ] [ fe_ticket ] += fam_enprises [ i ] [ fe_hour_ft ] ;
				
				new _fam_id = fam_enprises [ i ] [ fe_owner ] ;
				family_info [ _fam_id - 1 ] [ fam_rating ] += fam_enprises [ i ] [ fe_hour_rating ] ;
					
				format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] В семью начислен бонус за предприятие '%s'.", family_info [ i ] [ fam_chat_color ], fam_enprises [ i ] [ fe_name ] ) ;
				family_message ( _fam_id, col_gray, fm_string ) ;
					
				update_fdorm_text ( _fam_id ) ;
			}
		}
	}
	
	if ( family_dealer_start > 1 )
	{
	    family_dealer_start -- ;
		if ( family_dealer_start == 600 )
		{
			family_dealer_number = random ( 3 ) ;
			
			new fm_string [ 128 ], i = family_dealer_number, _fam_level ;
			for ( new f = 0 ; f < family_count ; f ++ )
			{
				_fam_level = update_family_level ( f + 1 ) ;
				if ( _fam_level < fam_level_dealer ) continue ;
				if ( ! family_info [ f ] [ fam_house ] ) continue ;
				
				format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] В район %s будет поставлена контрабанда через 5 минут!", family_info [ f ] [ fam_chat_color ], dealer_info [ i ] [ dealer_name ] ) ;
				family_message ( f + 1, col_gray, fm_string ) ;
			}
			
			if ( family_dealer_timer != -1 )
			{
				KillTimer ( family_dealer_timer ) ;
				family_dealer_timer = -1 ;
			}
			
			if ( IsValidDynamic3DTextLabel ( family_dealer_label ) )
			{
				DestroyDynamic3DTextLabel ( family_dealer_label ) ;
				family_dealer_label = Text3D:INVALID_3DTEXT_ID ;
			}
			
			if ( family_dealer_zone != -1 )
			{
				GangZoneHideForAll ( family_dealer_zone ) ;
				GangZoneDestroy ( family_dealer_zone ) ;
				family_dealer_zone = -1 ;
			}
			
			if ( family_dealer_rectangle != -1 )
			{
				DestroyDynamicArea ( family_dealer_rectangle ) ;
				family_dealer_rectangle = -1 ;
			}
		}
	    else if ( family_dealer_start == 300 )
	    {
			new i = family_dealer_number, _fam_level ;
			family_dealer_time_stop = true ;
			family_dealer_owner_stoped = false ;
			family_dealer_time = 180 ;
			family_dealer_owner = -1 ;
			
			new fm_string [ 128 ] ;
			format ( fm_string, sizeof fm_string, "** %s **\n\n{"#cWH"}Неизвестно\n{"#cWH"}До захвата: {"#cOR"}%d сек.", dealer_info [ i ] [ dealer_name ], family_dealer_time ) ;
			family_dealer_label = CreateDynamic3DTextLabel ( fm_string, col_blue, dealer_info [ i ] [ dealer_position ] [ 0 ], dealer_info [ i ] [ dealer_position ] [ 1 ], dealer_info [ i ] [ dealer_position ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
			
			get_gz_pos ( dealer_info [ i ] [ dealer_position ] [ 0 ], dealer_info [ i ] [ dealer_position ] [ 1 ], 80.0, dealer_zone_position [ 0 ], dealer_zone_position [ 1 ], dealer_zone_position [ 2 ], dealer_zone_position [ 3 ] ) ;
			family_dealer_zone = GangZoneCreate ( dealer_zone_position [ 0 ], dealer_zone_position [ 1 ], dealer_zone_position [ 2 ], dealer_zone_position [ 3 ] ) ;

			family_dealer_rectangle = CreateDynamicRectangle ( dealer_zone_position [ 0 ], dealer_zone_position [ 1 ], dealer_zone_position [ 2 ], dealer_zone_position [ 3 ], 0, 0, -1 ) ;
			area_info [ family_dealer_rectangle ] [ a_type ] = area_type_family_dealer ;

			GangZoneShowForAll ( family_dealer_zone, 0x000000AA ) ;
			
			
			
			
			
	        for ( new d = 0 ; d < 5 ; d ++ )
			{
				if ( d < 2 )
				{
					family_dealer_car [ d ] = CreateVehicle ( 482, dealer_info_car [ i ] [ d ] [ 0 ], dealer_info_car [ i ] [ d ] [ 1 ], dealer_info_car [ i ] [ d ] [ 2 ], dealer_info_car [ i ] [ d ] [ 3 ], random ( 126 ), random ( 126 ), -1 ) ;
				
					new _vehicleid = family_dealer_car [ d ] ;
					veh_info [ _vehicleid - 1 ] [ v_pos ] [ 0 ] = dealer_info_car [ i ] [ d ] [ 0 ] ;
					veh_info [ _vehicleid - 1 ] [ v_pos ] [ 1 ] = dealer_info_car [ i ] [ d ] [ 1 ] ;
					veh_info [ _vehicleid - 1 ] [ v_pos ] [ 2 ] = dealer_info_car [ i ] [ d ] [ 2 ] ;
					veh_info [ _vehicleid - 1 ] [ v_pos ] [ 3 ] = dealer_info_car [ i ] [ d ] [ 3 ] ;
					veh_info [ _vehicleid - 1 ] [ v_type ] = vehicle_type_none ;

					new engine, lights, alarm, doors, bonnet, boot, objective ;
					veh_info [ _vehicleid - 1 ] [ v_locked ] = true ;
					GetVehicleParamsEx ( _vehicleid, engine, lights, alarm, doors, bonnet, boot, objective ) ;
					SetVehicleParamsEx ( _vehicleid, engine, lights, alarm, true, bonnet, boot, objective ) ;
				}
				
				static const _skin_actor [ ] = { 110, 294, 109, 108, 33 } ;
				family_dealer_npc [ d ] = CreateActor ( _skin_actor [ random ( sizeof _skin_actor ) ], dealer_info_npc [ i ] [ d ] [ 0 ], dealer_info_npc [ i ] [ d ] [ 1 ], dealer_info_npc [ i ] [ d ] [ 2 ], dealer_info_npc [ i ] [ d ] [ 3 ] ) ;
				ApplyActorAnimation ( family_dealer_npc [ d ], "DEALER", "Dealer_idle", 4.1, 1, 0, 0, 0, 0 ) ;
			}
			
			for ( new f = 0 ; f < family_count ; f ++ )
			{
				_fam_level = update_family_level ( f + 1 ) ;
				if ( _fam_level < fam_level_dealer ) continue ;
				if ( ! family_info [ f ] [ fam_house ] ) continue ;
				
				format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] В район %s поставлена контрабанда, отправляйтесь туда!", family_info [ f ] [ fam_chat_color ], dealer_info [ i ] [ dealer_name ] ) ;
				family_message ( f + 1, col_gray, fm_string ) ;
			}
			
			family_dealer_timer = SetTimer ( "family_dealer_checkin_timer", 5000, true ) ;
			family_dealer_end = 2700 ;
	    }
	}
	
	if ( family_dealer_time_stop == false )
	{
		if ( family_dealer_time > 1 ) 
		{
			family_dealer_time -- ;
			family_update_dealer_label ( ) ;
		}
		else if ( family_dealer_time == 1 )
		{
			family_dealer_owner_stoped = true ;
			family_dealer_time_stop = true ;
			
			KillTimer ( family_dealer_timer ) ;
			family_dealer_timer = -1 ;
				
			GangZoneHideForAll ( family_dealer_zone ) ;
			GangZoneDestroy ( family_dealer_zone ) ;
			family_dealer_zone = -1 ;
				
			DestroyDynamicArea ( family_dealer_rectangle ) ;
			family_dealer_rectangle = -1 ;
				
			family_dealer_end = 600 ;
			
			family_info [ family_dealer_owner - 1 ] [ fam_rating ] += 5 ;
			give_all_family_quest ( family_dealer_owner, 3, 1 ) ;
			give_all_family_quest ( family_dealer_owner, 6, 5 ) ;
			give_all_family_quest ( family_dealer_owner, 7, 5 ) ;
			give_all_family_quest ( family_dealer_owner, 8, 5 ) ;
			
			new fm_string [ 100 ] ;
			format ( fm_string, sizeof fm_string, "{%s}[FAM] В семью начислен бонус рейтинга (+5 очков) за захват контрабанды!", family_info [ family_dealer_owner - 1 ] [ fam_chat_color ] ) ;
			//family_message ( family_dealer_owner, col_gray, fm_string ) ;
			
			foreach(new i: family_players[family_dealer_owner])
			{
				if ( p_info [ i ] [ family ] != family_dealer_owner ) continue ;
				
				SendClientMessage ( i, col_gray, fm_string ) ;
				give_event_progress ( i, THE_FAMILY_DEALER, 1 ) ;
				give_global_quest ( i, 5, 1 ) ;
			}
			
			if ( day_dealer_car == true )
			{
				switch ( random ( 10 ) )
				{
					case 0, 1, 2, 3: family_dealer_type = 0 ;
					case 4, 5, 6, 7, 8, 9: family_dealer_type = 1 ;
				}
			}
			else
			{
				switch ( random ( 10 ) )
				{
					case 0, 1, 2, 3: family_dealer_type = 0 ;
					case 4, 5, 6, 7: family_dealer_type = 1 ;
					case 8, 9:  family_dealer_type = 2, day_dealer_car = true ;
				}
			}
			
			if ( family_dealer_type == 0 )
			{
				family_dealer_inventory [ 0 ] = random ( 5 ) + 5 ; // бронежилеты
				family_dealer_inventory [ 1 ] = random ( 5 ) + 3 ; // бронежилеты
				family_dealer_inventory [ 2 ] = random ( 5 ) + 2 ; // бронежилеты
			}
			else if ( family_dealer_type == 1 )
			{
				family_dealer_inventory [ 0 ] = random ( 25 ) + 5 ; // Золото
				family_dealer_inventory [ 1 ] = random ( 25 ) + 5 ; // Хлопок
				family_dealer_inventory [ 2 ] = random ( 2 ) + 1 ; // Колесо
				family_dealer_inventory [ 3 ] = random ( 2 ) + 1 ; // Выхлопная труба
				family_dealer_inventory [ 4 ] = random ( 2 ) + 1 ; // Элемент крыши
				family_dealer_inventory [ 5 ] = random ( 2 ) + 1 ; // Бампер
				family_dealer_inventory [ 6 ] = random ( 2 ) + 1 ; // Задний бампер
			}
			else if ( family_dealer_type == 2 )
			{
				if ( family_info [ family_dealer_owner - 1 ] [ fam_max_car ] + 1 > 10 )
				{
					family_dealer_inventory [ 0 ] = random ( 5 ) + 10 ; // бронежилеты
					family_dealer_inventory [ 1 ] = random ( 5 ) + 5 ; // бронежилеты
					family_dealer_inventory [ 2 ] = random ( 5 ) + 2 ; // бронежилеты
					
					family_dealer_type = 0 ;
				}
				else
				{
					family_dealer_inventory [ 0 ] = dealer_car_model [ random ( sizeof dealer_car_model ) ] ; // т/с
				
					global_string [ 0 ] = EOS ;
					mysql_format ( sql_connection, global_string, 356, "INSERT INTO `familys_vehicles` (`sv_model`,`sv_owner`,`v_plate_type`,`v_plate`,`v_region`,`sv_pos_x`,`sv_pos_y`,`sv_pos_z`,`sv_pos_a`,`sv_type`,`sv_price`,`v_owner_fam`) VALUES ('%d','%d','2','Transit','777','%f','%f','%f','%f','%d','%d','%d')",
					family_dealer_inventory [ 0 ], family_dealer_owner,
					dealer_info [ family_dealer_number ] [ dealer_position ] [ 0 ], dealer_info [ family_dealer_number ] [ dealer_position ] [ 1 ], dealer_info [ family_dealer_number ] [ dealer_position ] [ 2 ], 0.0, 
					vehicle_type_family, GetModelPrice ( family_dealer_inventory [ 0 ] ), -1 ) ;
					mysql_tquery ( sql_connection, global_string ) ;
					
					family_info [ family_dealer_owner - 1 ] [ fam_max_car ] += 1 ;

					global_string [ 0 ] = EOS ;
					mysql_format ( sql_connection, global_string, 144, "UPDATE `family` SET `fam_max_car` = `fam_max_car` + '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_dealer_owner - 1 ] [ fam_max_car ], family_info [ family_dealer_owner - 1 ] [ fam_id ] ) ;
					mysql_tquery ( sql_connection, global_string ) ;
				}
			}
			
			if ( IsValidDynamicPickup ( family_dealer_pickup ) ) DestroyDynamicPickup ( family_dealer_pickup ) ;
			if ( IsValidDynamicArea ( family_dealer_area ) ) DestroyDynamicArea ( family_dealer_area ) ;
			
			family_dealer_pickup = CreateDynamicPickup ( 3013, 23, dealer_info [ family_dealer_number ] [ dealer_position ] [ 0 ], dealer_info [ family_dealer_number ] [ dealer_position ] [ 1 ], dealer_info [ family_dealer_number ] [ dealer_position ] [ 2 ], 0, 0, -1 ) ;
			pick_info [ family_dealer_pickup ] [ pick_type ] = pick_type_family_dealer ;
			
			family_dealer_area = CreateDynamicSphere ( dealer_info [ family_dealer_number ] [ dealer_position ] [ 0 ], dealer_info [ family_dealer_number ] [ dealer_position ] [ 1 ], dealer_info [ family_dealer_number ] [ dealer_position ] [ 2 ], 2.0, 0, -1, -1 ) ;
			area_info [ family_dealer_area ] [ a_type ] = area_type_family_dealer1 ;
		}
	}
	
	if ( family_dealer_end > 1 )
	{
	    if ( -- family_dealer_end == 1 )
	    {
			if ( family_dealer_timer != -1 )
			{
				KillTimer ( family_dealer_timer ) ;
				family_dealer_timer = -1 ;
			}

			if ( family_dealer_zone != -1 )
			{
				GangZoneHideForAll ( family_dealer_zone ) ;
				GangZoneDestroy ( family_dealer_zone ) ;
				family_dealer_zone = -1 ;
			}
			
			if ( family_dealer_rectangle != -1 )
			{		
				DestroyDynamicArea ( family_dealer_rectangle ) ;
				family_dealer_rectangle = -1 ;
			}
			
			if ( IsValidDynamicPickup ( family_dealer_pickup ) )
			{
				DestroyDynamicPickup ( family_dealer_pickup ) ;
				family_dealer_pickup = -1 ;
			}
			
			if ( IsValidDynamicArea ( family_dealer_area ) )
			{
				DestroyDynamicArea ( family_dealer_area ) ;
				family_dealer_area = -1 ;
			}
			
			if ( IsValidDynamic3DTextLabel ( family_dealer_label ) )
			{
				DestroyDynamic3DTextLabel ( family_dealer_label ) ;
				family_dealer_label = Text3D:INVALID_3DTEXT_ID ;
			}
			
			for ( new d = 0 ; d < 5 ; d ++ )
			{
				if ( d < 2 )
				{
					DestroyVehicle ( family_dealer_car [ d ], 1111 ) ;
				}
				
				DestroyActor ( family_dealer_npc [ d ] ) ;
			}

			family_dealer_number = -1 ;
			family_dealer_end = 0 ;
	    }
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	if ( family_start_airdrop > 1 )
	{
	    family_start_airdrop -- ;
		if ( family_start_airdrop == 600 )
		{
			family_airdrop_number = random ( 3 ) ;
			
			new fm_string [ 128 ], i = family_airdrop_number, _fam_level ;
			for ( new f = 0 ; f < family_count ; f ++ )
			{
				_fam_level = update_family_level ( f + 1 ) ;
				if ( _fam_level < fam_level_airdrop ) continue ;
				if ( ! family_info [ f ] [ fam_house ] ) continue ;
				
				format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] В район %s будет сброшена посылка через 5 минут!", family_info [ f ] [ fam_chat_color ], f_air_info [ i ] [ lName ] ) ;
				family_message ( f + 1, col_gray, fm_string ) ;
			}
			
			for ( new q = 0 ; q < 3 ; q ++ )
			{
				if ( IsValidDynamicObject ( family_airdrop_object [ q ] ) ) DestroyDynamicObject ( family_airdrop_object [ q ] ) ;
			}
			
			if ( family_airdrop_timer != -1 )
			{
				KillTimer ( family_airdrop_timer ) ;
				family_airdrop_timer = -1 ;
			}
			
			if ( IsValidDynamic3DTextLabel ( family_airdrop_label ) )
			{
				DestroyDynamic3DTextLabel ( family_airdrop_label ) ;
				family_airdrop_label = Text3D:INVALID_3DTEXT_ID ;
			}
			
			if ( family_airdrop_zone != -1 )
			{
				GangZoneHideForAll ( family_airdrop_zone ) ;
				GangZoneDestroy ( family_airdrop_zone ) ;
				family_airdrop_zone = -1 ;
			}
			
			if ( family_airdrop_rectangle != -1 )
			{
				DestroyDynamicArea ( family_airdrop_rectangle ) ;
				family_airdrop_rectangle = -1 ;
			}
		}
	    else if ( family_start_airdrop == 300 )
	    {
			new i = family_airdrop_number, _fam_level ;
			family_airdrop_time_stop = true ;
			family_aidrop_owner_stoped = false ;
			family_airdrop_time = 180 ;
			family_airdrop_owner = -1 ;
			
			new fm_string [ 128 ] ;
			format ( fm_string, sizeof fm_string, "** %s **\n\n{"#cWH"}Неизвестно\n{"#cWH"}До захвата: {"#cOR"}%d сек.", f_air_info [ i ] [ lName ], family_airdrop_time ) ;
			family_airdrop_label = CreateDynamic3DTextLabel ( fm_string, col_blue, f_air_info [ i ] [ move_position ] [ 0 ], f_air_info [ i ] [ move_position ] [ 1 ], f_air_info [ i ] [ move_position ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
			
			get_gz_pos ( f_air_info [ i ] [ create_position ] [ 0 ], f_air_info [ i ] [ create_position ] [ 1 ], 80.0, family_airzone_position [ 0 ], family_airzone_position [ 1 ], family_airzone_position [ 2 ], family_airzone_position [ 3 ] ) ;
			family_airdrop_zone = GangZoneCreate ( family_airzone_position [ 0 ], family_airzone_position [ 1 ], family_airzone_position [ 2 ], family_airzone_position [ 3 ] ) ;

			family_airdrop_rectangle = CreateDynamicRectangle ( family_airzone_position [ 0 ], family_airzone_position [ 1 ], family_airzone_position [ 2 ], family_airzone_position [ 3 ], 0, 0, -1 ) ;
			area_info [ family_airdrop_rectangle ] [ a_type ] = area_type_family_airdrop ;

			GangZoneShowForAll ( family_airdrop_zone, 0x000000AA ) ;
			
			
			
			
	        family_airdrop_object [ 0 ] = CreateDynamicObject ( 2935, f_air_info [ i ] [ create_position ] [ 0 ], f_air_info [ i ] [ create_position ] [ 1 ], f_air_info [ i ] [ create_position ] [ 2 ], f_air_info [ i ] [ create_position ] [ 3 ], f_air_info [ i ] [ create_position ] [ 4 ], f_air_info [ i ] [ create_position ] [ 5 ] ) ;
            MoveDynamicObject ( family_airdrop_object [ 0 ], f_air_info [ i ] [ move_position ] [ 0 ], f_air_info [ i ] [ move_position ] [ 1 ], f_air_info [ i ] [ move_position ] [ 2 ], 1, f_air_info [ i ] [ move_position ] [ 3 ], f_air_info [ i ] [ move_position ] [ 4 ], f_air_info [ i ] [ move_position ] [ 5 ] ) ;

            family_airdrop_object [ 1 ] = CreateDynamicObject ( 18849, f_air_info [ i ] [ create_position ] [ 0 ], f_air_info [ i ] [ create_position ] [ 1 ], f_air_info [ i ] [ create_position ] [ 2 ] + AIR_FRONT, f_air_info [ i ] [ create_position ] [ 3 ], f_air_info [ i ] [ create_position ] [ 4 ], f_air_info [ i ] [ create_position ] [ 5 ] ) ;
			MoveDynamicObject ( family_airdrop_object [ 1 ], f_air_info [ i ] [ move_position ] [ 0 ], f_air_info [ i ] [ move_position ] [ 1 ], f_air_info [ i ] [ move_position ] [ 2 ], 1, f_air_info [ i ] [ move_position ] [ 3 ], f_air_info [ i ] [ move_position ] [ 4 ], f_air_info [ i ] [ move_position ] [ 5 ] ) ;

            family_airdrop_object [ 2 ] = CreateDynamicObject ( 18728, f_air_info [ i ] [ move_position ] [ 0 ], f_air_info [ i ] [ move_position ] [ 1 ], f_air_info [ i ] [ move_position ] [ 2 ] - AIR_LIGHT, f_air_info [ i ] [ move_position ] [ 3 ], f_air_info [ i ] [ move_position ] [ 4 ], f_air_info [ i ] [ move_position ] [ 5 ] ) ;

			for ( new f = 0 ; f < family_count ; f ++ )
			{
				_fam_level = update_family_level ( f + 1 ) ;
				if ( _fam_level < fam_level_airdrop ) continue ;
				if ( ! family_info [ f ] [ fam_house ] ) continue ;
				
				format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] В район %s была сброшена посылка, отправляйтесь туда!", family_info [ f ] [ fam_chat_color ], f_air_info [ i ] [ lName ] ) ;
				family_message ( f + 1, col_gray, fm_string ) ;
			}
			
			family_airdrop_timer = SetTimer ( "family_air_checkin_timer", 5000, true ) ;
			family_end_airdrop = 2700 ;
	    }
	}
	
	if ( family_airdrop_time_stop == false )
	{
		if ( family_airdrop_time > 1 ) 
		{
			family_airdrop_time -- ;
			family_update_airdrop_label ( ) ;
		}
		else if ( family_airdrop_time == 1 && family_airdrop_from_earth == true )
		{
			family_aidrop_owner_stoped = true ;
			family_airdrop_time_stop = true ;
			
			KillTimer ( family_airdrop_timer ) ;
			family_airdrop_timer = -1 ;
				
			GangZoneHideForAll ( family_airdrop_zone ) ;
			GangZoneDestroy ( family_airdrop_zone ) ;
			family_airdrop_zone = -1 ;
				
			DestroyDynamicArea ( family_airdrop_rectangle ) ;
			family_airdrop_rectangle = -1 ;
				
			family_end_airdrop = 600 ;
			
			family_info [ family_airdrop_owner - 1 ] [ fam_rating ] += 5 ;
			give_all_family_quest ( family_airdrop_owner, 2, 1 ) ;
			give_all_family_quest ( family_airdrop_owner, 6, 5 ) ;
			give_all_family_quest ( family_airdrop_owner, 7, 5 ) ;
			give_all_family_quest ( family_airdrop_owner, 8, 5 ) ;
			
			new fm_string [ 100 ] ;
			format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] В семью начислен бонус рейтинга (+5 очков) за захват посылки!", family_info [ family_airdrop_owner - 1 ] [ fam_chat_color ] ) ;
			//family_message ( family_airdrop_owner, col_gray, fm_string ) ;
			
			foreach(new i: family_players[family_airdrop_owner])
			{
				if ( p_info [ i ] [ family ] != family_airdrop_owner ) continue ;
			
				SendClientMessage ( i, col_gray, fm_string ) ;
				give_event_progress ( i, THE_FAMILY_AIRDROP, 1 ) ;
			}
			
			format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] Доступный транспорт для загрузки боеприпасов: %s (#482)!", family_info [ family_airdrop_owner - 1 ] [ fam_chat_color ], GetVehicleNameEx ( -1, 482 ) ) ;
			family_message ( family_airdrop_owner, col_gray, fm_string ) ;
			
			family_airdrop_inventory [ 0 ] = random ( 10 ) + 5 ; // ящик с Desert Eagle
			family_airdrop_inventory [ 1 ] = random ( 10 ) + 5 ; // ящик с AK47
			family_airdrop_inventory [ 2 ] = random ( 10 ) + 5 ; // ящик с M4A1
			family_airdrop_inventory [ 3 ] = random ( 25 ) + 25 ; // Ящик с патронами
			family_airdrop_inventory [ 4 ] = random ( 5 ) + 5 ; // Ящик с бронежилетами
			family_airdrop_inventory [ 5 ] = random ( 10 ) + 5 ; // Ящик с Silenced 9mm
			family_airdrop_inventory [ 6 ] = random ( 10 ) + 5 ; // Ящик с Shotgun
			
			if ( IsValidDynamicPickup ( family_airdrop_pickup ) ) DestroyDynamicPickup ( family_airdrop_pickup ) ;
			if ( IsValidDynamicPickup ( family_airdrop_area ) ) DestroyDynamicPickup ( family_airdrop_area ) ;
			
			family_airdrop_pickup = CreateDynamicPickup ( 3013, 23, f_air_info [ family_airdrop_number ] [ move_position ] [ 0 ] + 5, f_air_info [ family_airdrop_number ] [ move_position ] [ 1 ] + 5, f_air_info [ family_airdrop_number ] [ move_position ] [ 2 ], 0, 0, -1 ) ;
			pick_info [ family_airdrop_pickup ] [ pick_type ] = pick_type_family_airdrop ;
			
			family_airdrop_area = CreateDynamicSphere ( f_air_info [ family_airdrop_number ] [ move_position ] [ 0 ] + 5, f_air_info [ family_airdrop_number ] [ move_position ] [ 1 ] + 5, f_air_info [ family_airdrop_number ] [ move_position ] [ 2 ], 2.0, 0, -1, -1 ) ;
			area_info [ family_airdrop_area ] [ a_type ] = area_type_family_airdrop1 ;
		}
	}
	
	if ( family_end_airdrop > 1 )
	{
	    family_end_airdrop -- ;
	    if ( family_end_airdrop == 1 )
	    {
			if ( family_airdrop_timer != -1 )
			{
				KillTimer ( family_airdrop_timer ) ;
				family_airdrop_timer = -1 ;
			}
			
			if ( family_airdrop_zone != -1 )
			{
				GangZoneHideForAll ( family_airdrop_zone ) ;
				GangZoneDestroy ( family_airdrop_zone ) ;
				family_airdrop_zone = -1 ;
			}
			
			if ( family_airdrop_rectangle != -1 )
			{
				DestroyDynamicArea ( family_airdrop_rectangle ) ;
				family_airdrop_rectangle = -1 ;
			}
			
			for ( new i = 0 ; i < 3 ; i ++ )
			{
				if ( IsValidDynamicObject ( family_airdrop_object [ i ] ) )
				{
					DestroyDynamicObject ( family_airdrop_object [ i ] ) ;
					family_airdrop_object [ i ] = INVALID_OBJECT_ID ;
				}
			}
			
			if ( IsValidDynamicPickup ( family_airdrop_pickup ) )
			{
				DestroyDynamicPickup ( family_airdrop_pickup ) ;
				family_airdrop_pickup = -1 ;
			}
			
			if ( IsValidDynamicArea ( family_airdrop_area ) )
			{
				DestroyDynamicArea ( family_airdrop_area ) ;
				family_airdrop_area = -1 ;
			}
			
			if ( IsValidDynamic3DTextLabel ( family_airdrop_label ) )
			{
				DestroyDynamic3DTextLabel ( family_airdrop_label ) ;
				family_airdrop_label = Text3D:INVALID_3DTEXT_ID ;
			}

			family_airdrop_from_earth = false ;
			family_airdrop_number = -1 ;
			family_end_airdrop = 0 ;
	    }
	}
	return 1 ;
}




stock family_update_dealer_label ( )
{
	new fm_string [ 128 ] ;
	if ( family_dealer_time == 1 )
	{
		if ( family_dealer_owner == -1 )
			format ( fm_string, sizeof fm_string, "** %s **\n\n{"#cWH"}Неизвестно", dealer_info [ family_dealer_number ] [ dealer_name ] ) ;
		
		else
			format ( fm_string, sizeof fm_string, "** %s **\n\n{%s}%s", dealer_info [ family_dealer_number ] [ dealer_name ], family_info [ family_dealer_owner - 1 ] [ fam_chat_color ], family_info [ family_dealer_owner - 1 ] [ fam_name ] ) ;
	}
	else
	{
		if ( family_dealer_owner == -1 )
			format ( fm_string, sizeof fm_string, "** %s **\n\n{"#cWH"}Неизвестно\n{"#cWH"}До захвата: {"#cOR"}%d сек.", dealer_info [ family_dealer_number ] [ dealer_name ], family_dealer_time ) ;
		
		else
			format ( fm_string, sizeof fm_string, "** %s **\n\n{%s}%s\n{"#cWH"}До захвата: {"#cOR"}%d сек.", dealer_info [ family_dealer_number ] [ dealer_name ], family_info [ family_dealer_owner - 1 ] [ fam_chat_color ], family_info [ family_dealer_owner - 1 ] [ fam_name ], family_dealer_time ) ;
	}
	if ( IsValidDynamic3DTextLabel ( family_dealer_label ) ) UpdateDynamic3DTextLabelText ( family_dealer_label, col_blue, fm_string ) ;
	return 1 ;
}

callback: family_dealer_checkin_timer ( )
{
	if ( family_dealer_owner_stoped == true )
	{
		KillTimer ( family_dealer_timer ) ;
		family_dealer_timer = -1 ;
		return 1 ;
	}
	
	new _free_fraction = 0, _count_fraction = 0, _family_count = 0, _fam_level ;
	for ( new fr_id = 0 ; fr_id < family_count ; fr_id ++ )
	{
		_fam_level = update_family_level ( fr_id + 1 ) ;
		if ( _fam_level < fam_level_dealer ) continue ;
		if ( ! family_info [ fr_id ] [ fam_house ] ) continue ;
		
		_family_count = 0 ;
		foreach(new i: family_players[fr_id + 1])
		{
			if ( p_info [ i ] [ family ] < 1 ) continue ;
			if ( GetPlayerState ( i ) != PLAYER_STATE_ONFOOT ) continue ;
			if ( ! IsPlayerInDynamicArea ( i, family_dealer_rectangle ) ) continue ;
			if ( pl_afk_time [ i ] > 30 ) continue ;
			if ( admin_info [ i ] [ admin ] > 0 ) continue ;
			if ( p_info [ i ] [ hour_played ] < 3 ) continue ;
			
			if ( p_info [ i ] [ masked ] > 0 )
			{
				p_info [ i ] [ masked ] = 0 ;
				fraction_color ( i ) ;

				if ( p_info [ i ] [ mask_status ] == 0 ) RemovePlayerAttachedObject ( i, 3 ) ;
			}
			
			//_family_count [ fr_id ] = 1 ;
			_family_count = 1 ;
			break ;
		}
		
		//if ( ! _family_count [ fr_id ] ) continue ;_family_count
		if ( ! _family_count ) continue ;
		
		_count_fraction ++ ;
		_free_fraction = fr_id + 1 ;
		
		if ( _count_fraction > 1 ) break ;
	}

	if ( _count_fraction == 1 )
	{
		if ( family_dealer_owner != _free_fraction )
		{
			family_dealer_owner = _free_fraction ;
			family_dealer_time = 180 ;
			family_dealer_time_stop = false ;
		}
		else family_dealer_time_stop = false ;
	}
	else if ( _count_fraction == 0 )
	{
		family_dealer_owner = -1 ;
		family_dealer_time_stop = true ;
		family_update_dealer_label ( ) ;
	}
	else
		family_dealer_time_stop = true, family_update_dealer_label ( ) ;
	
	return 1 ;
}





stock family_update_airdrop_label ( )
{
	new fm_string [ 128 ] ;
	
	if ( family_airdrop_time == 1 )
	{
		if ( family_airdrop_owner == -1 )
			format ( fm_string, sizeof fm_string, "** %s **\n\n{"#cWH"}Неизвестно", f_air_info [ family_airdrop_number ] [ lName ] ) ;
		
		else
			format ( fm_string, sizeof fm_string, "** %s **\n\n{%s}%s", f_air_info [ family_airdrop_number ] [ lName ], family_info [ family_airdrop_owner - 1 ] [ fam_chat_color ], family_info [ family_airdrop_owner - 1 ] [ fam_name ] ) ;
	}
	else
	{
		if ( family_airdrop_owner == -1 )
			format ( fm_string, sizeof fm_string, "** %s **\n\n{"#cWH"}Неизвестно\n{"#cWH"}До захвата: {"#cOR"}%d сек.", f_air_info [ family_airdrop_number ] [ lName ], family_airdrop_time ) ;
		
		else
			format ( fm_string, sizeof fm_string, "** %s **\n\n{%s}%s\n{"#cWH"}До захвата: {"#cOR"}%d сек.", f_air_info [ family_airdrop_number ] [ lName ], family_info [ family_airdrop_owner - 1 ] [ fam_chat_color ], family_info [ family_airdrop_owner - 1 ] [ fam_name ], family_airdrop_time ) ;
	}
	if ( IsValidDynamic3DTextLabel ( family_airdrop_label ) ) UpdateDynamic3DTextLabelText ( family_airdrop_label, col_blue, fm_string ) ;
	return 1 ;
}

callback: family_air_checkin_timer ( )
{
	if ( family_aidrop_owner_stoped == true )
	{
		KillTimer ( family_airdrop_timer ) ;
		family_airdrop_timer = -1 ;
		return 1 ;
	}
	
	new _free_fraction = 0, _count_fraction = 0, _family_count = 0, _fam_level ;
	for ( new fr_id = 0 ; fr_id < family_count ; fr_id ++ )
	{
		_fam_level = update_family_level ( fr_id + 1 ) ;
		if ( _fam_level < fam_level_airdrop ) continue ;
		if ( ! family_info [ fr_id ] [ fam_house ] ) continue ;
		
		_family_count = 0 ;
		foreach(new i: family_players[fr_id + 1])
		{
			if ( p_info [ i ] [ family ] < 1 ) continue ;
			if ( GetPlayerState ( i ) != PLAYER_STATE_ONFOOT ) continue ;
			if ( ! IsPlayerInDynamicArea ( i, family_airdrop_rectangle ) ) continue ;
			if ( pl_afk_time [ i ] > 30 ) continue ;
			if ( admin_info [ i ] [ admin ] > 0 ) continue ;
			if ( p_info [ i ] [ hour_played ] < 3 ) continue ;
			
			if ( p_info [ i ] [ masked ] > 0 )
			{
				p_info [ i ] [ masked ] = 0 ;
				fraction_color ( i ) ;

				if ( p_info [ i ] [ mask_status ] == 0 ) RemovePlayerAttachedObject ( i, 3 ) ;
			}
			
			//_family_count [ fr_id ] = 1 ;
			_family_count = 1 ;
			break ;
		}
		
		//if ( ! _family_count [ fr_id ] ) continue ;
		if ( ! _family_count ) continue ;
		
		_count_fraction ++ ;
		_free_fraction = fr_id + 1 ;
		
		if ( _count_fraction > 1 ) break ;
	}

	if ( _count_fraction == 1 )
	{
		if ( family_airdrop_owner != _free_fraction )
		{
			family_airdrop_owner = _free_fraction ;
			family_airdrop_time = 180 ;
			family_airdrop_time_stop = false ;
		}
		else family_airdrop_time_stop = false ;
	}
	else if ( _count_fraction == 0 )
	{
		family_airdrop_owner = -1 ;
		family_airdrop_time_stop = true ;
		family_update_airdrop_label ( ) ;
	}
	else
		family_airdrop_time_stop = true, family_update_airdrop_label ( ) ;
	
	return 1 ;
}

stock show_home_family ( playerid )
{
	new family_id = p_info [ playerid ] [ family ] ;
	if ( family_info [ family_id - 1 ] [ fam_house ] )
	{
		new fm_string [ 128 ] ;
        format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] %s %s[%i] убрал(а) семейный дом. У семьи больше нет дома.", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid ) ;
        family_message ( family_id, col_gray, fm_string ) ;

		h_info [ family_info [ family_id - 1 ] [ fam_house ] - 1 ] [ h_zz_status ] = 0 ;
		family_info [ family_id - 1 ] [ fam_house ] = 0 ;

		format(fm_string, sizeof(fm_string), "UPDATE `family` SET `fam_house` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_house ], family_id ) ;
		mysql_tquery(sql_connection, fm_string);
		
		if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
		else send_check_cinfo ( playerid, "Вы убрали семейный дом.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
		return 1 ;
	}

	if ( Iter_Count(player_houses[playerid]) == 1 )
	{
	    p_info [ playerid ] [ house ] = Iter_First(player_houses[playerid]) ;
		
		new house_id = p_info [ playerid ] [ house ] - 1 ;
		if ( house_int [ h_info [ house_id ] [ h_int ] - 1 ] [ hint_class ] < max_class - 2 )
		{
			show_family ( playerid ) ;

			new scm_string [ 144 ] ;
			format ( scm_string, sizeof scm_string, "{"#cRInfo"}* {"#cGRInfo"}Домом семьи можно устанавливать только дома класса: {"#cRD"}%s{"#cGRInfo"} и выше.", house_classes [ max_class - 2 ] ) ;
			SendClientMessage ( playerid, col_gray, scm_string ) ;
			return 1 ;
		}

		new fm_string [ 128 ] ;
        format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] %s %s[%i] установил(а) дом №%d, как дом семьи.", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, house_id + 1 ) ;
        family_message ( family_id, col_gray, fm_string ) ;

		family_info [ family_id - 1 ] [ fam_house ] = house_id + 1 ;
		h_info [ house_id ] [ h_zz_status ] = 1 ;

		format(fm_string, sizeof(fm_string), "UPDATE `family` SET `fam_house` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_house ], family_id ) ;
		mysql_tquery(sql_connection, fm_string);
		
		add_family_house ( house_id, 1 ) ;
		
		if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
		else send_check_cinfo ( playerid, "Вы установили семейный дом.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
	}
	else
	{
	    global_string [ 0 ] = EOS ;
	    new line_string [ 128 ], count_h = 0 ;
	    foreach(new h: player_houses[playerid])
	    {
	        set_player_listitem_values ( playerid, count_h, h ) ;

	        count_h ++ ;

			format ( line_string, sizeof line_string, "{"#cBL"}%d.{"#cWH"} %s - {"#cBL"}№%d {"#cGRDialog"}(%s{"#cGRDialog"})\n", count_h, house_classes [ house_int [ h_info [ h - 1 ] [ h_int ] - 1 ] [ hint_class ] ], h, ( h_info [ h - 1 ] [ h_closed ] ) ? ( "{"#cRD"}Закрыт" ) : ( "{"#cGN"}Открыт" ) ) ;
			strcat ( global_string, line_string ) ;
		}
	    show_dialog ( playerid, d_home_family_select, DIALOG_STYLE_LIST, "{"#cBHD"}Дома", global_string, "Выбрать", "Закрыть" ) ;
	}
	return 1 ;
}

stock add_family_house ( house_id, _type_add )
{
	if ( _type_add == 1 )
	{
		if ( h_info [ house_id ] [ h_garage ] )
		{
			if ( IsValidDynamic3DTextLabel ( h_info [ house_id ] [ h_garage_text ] ) )
			{
				DestroyDynamic3DTextLabel ( h_info [ house_id ] [ h_garage_text ] ) ;
				h_info [ house_id ] [ h_garage_text ] = Text3D:INVALID_3DTEXT_ID ;
			}

			h_info [ house_id ] [ h_garage_text ] = CreateDynamic3DTextLabel("** Семейный гараж **\n{"#cGR3D"}Нажмите {"#cWH3D"}Y{"#cGR3D"}, чтобы заехать\n{"#cGR3D"}Встаньте, чтобы взять транспорт\n\n{"#cGR3D"}Используйте {"#cWH"}/stoprent {"#cGR3D"}для сдачи т/с",col_blue,
									h_info [ house_id ] [ h_v_pos ] [ 0 ], h_info [ house_id ] [ h_v_pos ] [ 1 ], h_info [ house_id ] [ h_v_pos ] [ 2 ],
									4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1 ) ;
		}
	}
	else if ( _type_add == 2 )
	{
		if ( h_info [ house_id ] [ h_garage ] )
		{
			if ( IsValidDynamic3DTextLabel ( h_info [ house_id ] [ h_garage_text ] ) )
			{
				DestroyDynamic3DTextLabel ( h_info [ house_id ] [ h_garage_text ] ) ;
				h_info [ house_id ] [ h_garage_text ] = Text3D:INVALID_3DTEXT_ID ;
			}

			h_info [ house_id ] [ h_garage_text ] = CreateDynamic3DTextLabel("** Гараж **\n{"#cGR3D"}Нажмите {"#cWH3D"}Y{"#cGR3D"}, чтобы заехать",col_blue,
									h_info [ house_id ] [ h_v_pos ] [ 0 ], h_info [ house_id ] [ h_v_pos ] [ 1 ], h_info [ house_id ] [ h_v_pos ] [ 2 ],
									4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1 ) ;
		}
	}
	return 1 ;
}

stock update_fdorm_text ( familyid )
{
	new t_string [ 300 ] ;

	format ( t_string, sizeof ( t_string ),"\
	{%s}*** Общак %s ***\n\n\
	{"#cWH3D"}Количество территорий:{"#cOR3D"} \t%d\n\
	{"#cWH3D"}"family_title":{"#cOR3D"} \t%d шт.",
	family_info [ familyid - 1 ] [ fam_chat_color ],
	family_info [ familyid - 1 ] [ fam_name ],
	family_info [ familyid - 1 ] [ fam_zones ],
	family_info [ familyid - 1 ] [ fam_ticket ] ) ;

	UpdateDynamic3DTextLabelText( gdorm_family_text [ familyid - 1 ], col_blue, t_string ) ;
	return 1 ;
}

stock familys_OnPlayerDeath ( playerid, killerid, reason )
{
	if ( p_info [ killerid ] [ family ] )
 	{
 	    if ( p_info [ killerid ] [ family_quest ] == 2 )
 	    {
 	        if ( p_info [ killerid ] [ family_quest_progress ] < 20 )
 	        {
 	            if ( fam_bl_info [ playerid ] [ bl_onFrac ] [ p_info [ killerid ] [ family ] ] == 1 )
			 	{
			      	new family_id = p_info [ killerid ] [ family ], text_string [ 128 ] ;
				    format(text_string, sizeof text_string, "* Заплати или терпи, %s помнит о тебе.", family_info [ family_id - 1 ] [ fam_name ] );
					SendClientMessage ( playerid, col_lblue, text_string);
					format(text_string, sizeof text_string, "{%s}[FAM] %s завалил(а) %s. Крепись братва, в следующий раз терпила даст монету.", family_info [ family_id - 1 ] [ fam_chat_color ], p_info [ killerid ] [ name ], p_info [ playerid ] [ name ] );
					family_message ( family_id, col_gray, text_string ) ;
					
					p_info [ killerid ] [ family_quest_progress ] ++ ;
		    		update_int_sql ( killerid, "u_family_quest_progress", p_info [ killerid ] [ family_quest_progress ] ) ;
			 	}
 	        }
 	        else SendClientMessage ( killerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Задание успешно выполнено. Отправляйтесь к квестовому персонажу." ) ;
 	    }
 	}
	
	if ( zones_captured != -1 )
	{
		if ( ( IsPlayerInFamilyZone ( playerid, zones_captured ) || ( IsPlayerInRangeOfQuad ( playerid, family_wars [ zones_captured ] [ gz_pos ] [ 2 ], family_wars [ zones_captured ] [ gz_pos ] [ 3 ] ) < 200 || IsPlayerInRangeOfQuad ( playerid, family_wars [ zones_captured ] [ gz_pos ] [ 0 ], family_wars [ zones_captured ] [ gz_pos ] [ 1 ] ) < 200 ) ) && p_info [ playerid ] [ family ] != p_info [ killerid ] [ family ] )
		{
			new killerfamily = p_info [ killerid ] [ family ], deathfamily = p_info [ playerid ] [ family ] ;
		    if ( killerfamily != deathfamily )
		    {
				new _gz_attacker = family_wars [ zones_captured ] [ gz_attacker ],
					_gz_owner = family_wars [ zones_captured ] [ gz_owner ] ;
				if ( killerfamily == _gz_attacker && deathfamily == _gz_owner ||
				    killerfamily == _gz_attacker && family_diplomacy [ deathfamily ] [ _gz_owner ] == dip_status_alliance ||
					family_diplomacy [ killerfamily ] [ _gz_attacker ] == dip_status_alliance && deathfamily == _gz_owner && family_diplomacy [ killerfamily ] [ _gz_owner ] == dip_status_war ||
					family_diplomacy [ killerfamily ] [ _gz_attacker ] == dip_status_alliance && family_diplomacy [ deathfamily ] [ _gz_owner ] == dip_status_alliance && family_diplomacy [ killerfamily ] [ _gz_owner ] == dip_status_war )
				{
					if ( zones_capture_type == gz_type_kills )
					{
						new score_kill, query_string [ 16 ], scm_string [ 144 ], td_string [ 48 ] ;
						switch ( reason )
						{
							case 0 									: score_kill += 5 ;
							case 22, 23 							: score_kill += 4 ;
							case 5, 6, 7, 10, 11, 12, 13, 14, 15	: score_kill += 10 ;
							default 								: score_kill += 1 ;
						}

						zones_attacker_points += score_kill ;
						
						p_info [ killerid ] [ family_kills ] ++ ;
						if ( p_info [ killerid ] [ family_status ] > 1 && p_info [ killerid ] [ family_kills ] > 0 && p_info [ killerid ] [ family_death ] > 0 )
						{
							format ( query_string, 8, "%d", p_info [ killerid ] [ family_kills ] ) ;
							PlayerTextDrawSetString ( killerid, family_ptd [ killerid ] [ 5 ], query_string ) ;
							
							new Float: _kda = floatdiv ( p_info [ killerid ] [ family_kills ], p_info [ killerid ] [ family_death ] ) ;
							if ( _kda < 0 ) _kda = 0.0 ;
							
							format ( query_string, 16, "K/D:_%.2f", _kda ) ;
							PlayerTextDrawSetString ( killerid, family_ptd [ killerid ] [ 7 ], query_string ) ;
						}
						if ( p_info [ killerid ] [ family_kills ] > zones_kills_two )
						{
                            zones_kills_two = p_info [ killerid ] [ family_kills ] ;
                            format ( zones_kills_two_name, 32, "%s", p_info [ killerid ] [ name ] ) ;
						}
						
						p_info [ playerid ] [ family_death ] ++ ;
						if ( p_info [ playerid ] [ family_status ] > 1 && p_info [ playerid ] [ family_kills ] > 0 && p_info [ playerid ] [ family_death ] > 0 )
						{
							new Float: _kda = floatdiv ( p_info [ playerid ] [ family_kills ], p_info [ playerid ] [ family_death ] ) ;
							if ( _kda < 0 ) _kda = 0.0 ;
							
							format ( query_string, 16, "K/D:_%.2f", _kda ) ;
							PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 7 ], query_string ) ;
						}

						if ( zahvat_kills [ 0 ] < p_info [ killerid ] [ family_kills ] )
					    {
					        zahvat_fractions [ 0 ] = killerfamily ;
						    zahvat_kills [ 0 ] = p_info [ killerid ] [ family_kills ] ;
						    format ( zahvat_names [ 0 ], MAX_PLAYER_NAME, "%s", p_info [ killerid ] [ name ] ) ;
				   		}
					    else if ( zahvat_kills [ 1 ] < p_info [ killerid ] [ family_kills ] )
					    {
					     	zahvat_fractions [ 1 ] = killerfamily ;
						    zahvat_kills [ 1 ] = p_info [ killerid ] [ family_kills ] ;
						    format ( zahvat_names [ 1 ], MAX_PLAYER_NAME, "%s", p_info [ killerid ] [ name ] ) ;
				   		}
					    else if ( zahvat_kills [ 2 ] < p_info [ killerid ] [ family_kills ] )
					    {
						    zahvat_fractions [ 2 ] = killerfamily ;
						    zahvat_kills [ 2 ] = p_info [ killerid ] [ family_kills ] ;
						    format ( zahvat_names [ 2 ], MAX_PLAYER_NAME, "%s", p_info [ killerid ] [ name ] ) ;
					    }

						if ( killerfamily == _gz_attacker && deathfamily == _gz_owner )
						{
							format ( scm_string, sizeof scm_string, "[U-FAM] %s [%s] завалил(а) %s [%s] (+%d очков). Счёт: %s [%d] : [%d] %s",
							p_info [ killerid ] [ name ], family_info [ _gz_attacker - 1 ] [ fam_name ],
							p_info [ playerid ] [ name ], family_info [ _gz_owner - 1 ] [ fam_name ],
							score_kill, family_info [ _gz_attacker - 1 ] [ fam_name ], zones_attacker_points,
							zones_owner_points, family_info [ _gz_owner - 1 ] [ fam_name ] ) ;
						}

						else if ( killerfamily == _gz_attacker && family_diplomacy [ deathfamily ] [ _gz_owner ] == dip_status_alliance )
						{
							format ( scm_string, sizeof scm_string, "[U-FAM] %s [%s] завалил(а) %s [Альянс с %s] (+%d очков). Счёт: %s [%d] : [%d] %s",
							p_info [ killerid ] [ name ], family_info [ _gz_attacker - 1 ] [ fam_name ],
							p_info [ playerid ] [ name ], family_info [ _gz_owner - 1 ] [ fam_name ],
							score_kill, family_info [ _gz_attacker - 1 ] [ fam_name ], zones_attacker_points,
							zones_owner_points, family_info [ _gz_owner - 1 ] [ fam_name ] ) ;
						}

						else if ( family_diplomacy [ killerfamily ] [ _gz_attacker ] == dip_status_alliance && deathfamily == _gz_owner && family_diplomacy [ killerfamily ] [ _gz_owner ] == dip_status_war )
						{
							format ( scm_string, sizeof scm_string, "[U-FAM] %s [Альянс с %s] завалил(а) %s [%s] (+%d очков). Счёт: %s [%d] : [%d] %s",
							p_info [ killerid ] [ name ], family_info [ _gz_attacker - 1 ] [ fam_name ],
							p_info [ playerid ] [ name ], family_info [ _gz_owner - 1 ] [ fam_name ],
							score_kill, family_info [ _gz_attacker - 1 ] [ fam_name ], zones_attacker_points,
							zones_owner_points, family_info [ _gz_owner - 1 ] [ fam_name ] ) ;
						}

						else if ( family_diplomacy [ killerfamily ] [ _gz_attacker ] == dip_status_alliance && family_diplomacy [ deathfamily ] [ _gz_owner ] == dip_status_alliance && family_diplomacy [ killerfamily ] [ _gz_owner ] == dip_status_war )
						{
							format ( scm_string, sizeof scm_string, "[U-FAM] %s [Альянс с %s] завалил(а) %s [Альянс с %s] (+%d очков). Счёт: %s [%d] : [%d] %s",
							p_info [ killerid ] [ name ], family_info [ _gz_attacker - 1 ] [ fam_name ],
							p_info [ playerid ] [ name ], family_info [ _gz_owner - 1 ] [ fam_name ],
							score_kill, family_info [ _gz_attacker - 1 ] [ fam_name ], zones_attacker_points,
							zones_owner_points, family_info [ _gz_owner - 1 ] [ fam_name ] ) ;
						}
						
						new _family_id ;
						foreach(new i: logged_players)
						{
						    if ( ! p_info [ i ] [ family ] && ! admin_info [ i ] [ admin_settings ] [ 0 ] ) continue ;

							SendDeathMessageToPlayer ( i, killerid, playerid, reason ) ;

							_family_id = p_info [ i ] [ family ] ;
							if ( ( ( family_diplomacy [ _gz_owner ] [ _family_id ] == dip_status_alliance || is_control_chat { i } == _gz_owner || _family_id == _gz_owner ) ||
							( family_diplomacy [ _gz_attacker ] [ _family_id ] == dip_status_alliance || is_control_chat { i } == _gz_attacker || _family_id == _gz_attacker ) ) && p_info [ i ] [ settings ] [ 0 ] != 0 ) SendClientMessage ( i, family_info [ _gz_attacker - 1 ] [ fam_zone_color ], scm_string ) ;

							format ( td_string, sizeof td_string, "%d", zones_attacker_points ) ;
							PlayerTextDrawSetString ( i, family_ptd [ i ] [ 4 ], td_string ) ;

							if ( p_info [ i ] [ family_status ] > 2 )
							{
								format ( td_string, sizeof td_string, "%s", zones_kills_two_name ) ;
								PlayerTextDrawSetString ( i, family_ptd [ i ] [ 9 ], td_string ) ;
							}
						}
					}
				}
				if ( killerfamily == _gz_owner && deathfamily == _gz_attacker ||
				    killerfamily == _gz_owner && family_diplomacy [ deathfamily ] [ _gz_attacker ] == dip_status_alliance ||
					family_diplomacy [ killerfamily ] [ _gz_owner ] == dip_status_alliance && deathfamily == _gz_attacker && family_diplomacy [ killerfamily ] [ _gz_attacker ] == dip_status_war ||
					family_diplomacy [ killerfamily ] [ _gz_owner ] == dip_status_alliance && family_diplomacy [ deathfamily ] [ _gz_attacker ] == dip_status_alliance && family_diplomacy [ killerfamily ] [ _gz_attacker ] == dip_status_war )
				{
					if ( zones_capture_type == gz_type_kills )
					{
						new score_kill, query_string [ 16 ], scm_string [ 144 ], td_string [ 48 ] ;
						switch ( reason )
						{
							case 0 									: score_kill += 5 ;
							case 22, 23 							: score_kill += 4 ;
							case 5, 6, 7, 10, 11, 12, 13, 14, 15	: score_kill += 10 ;
							default 								: score_kill += 1 ;
						}

						zones_owner_points += score_kill ;
						
						p_info [ killerid ] [ family_kills ] ++ ;
						if ( p_info [ killerid ] [ family_status ] > 1 && p_info [ killerid ] [ family_kills ] > 0 && p_info [ killerid ] [ family_death ] > 0 )
						{
							format ( query_string, 8, "%d", p_info [ killerid ] [ family_kills ] ) ;
							PlayerTextDrawSetString ( killerid, family_ptd [ killerid ] [ 5 ], query_string ) ;
							
							new Float: _kda = floatdiv ( p_info [ killerid ] [ family_kills ], p_info [ killerid ] [ family_death ] ) ;
							if ( _kda < 0 ) _kda = 0.0 ;
							
							format ( query_string, 16, "K/D:_%.2f", _kda ) ;
							PlayerTextDrawSetString ( killerid, family_ptd [ killerid ] [ 7 ], query_string ) ;
						}
						if ( p_info [ killerid ] [ family_kills ] > zones_kills_first )
						{
                            zones_kills_first = p_info [ killerid ] [ family_kills ] ;
                            format ( zones_kills_first_name, 32, "%s", p_info [ killerid ] [ name ] ) ;
						}
						
						p_info [ playerid ] [ family_death ] ++ ;
						if ( p_info [ playerid ] [ family_status ] > 1 && p_info [ playerid ] [ family_kills ] > 0 && p_info [ playerid ] [ family_death ] > 0 )
						{
							new Float: _kda = floatdiv ( p_info [ playerid ] [ family_kills ], p_info [ playerid ] [ family_death ] ) ;
							if ( _kda < 0 ) _kda = 0.0 ;
							
							format ( query_string, 16, "K/D:_%.2f", _kda ) ;
							PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 7 ], query_string ) ;
						}
						
						if ( zahvat_kills [ 0 ] < p_info [ killerid ] [ family_kills ] )
					    {
					        zahvat_fractions [ 0 ] = killerfamily ;
						    zahvat_kills [ 0 ] = p_info [ killerid ] [ family_kills ] ;
						    format ( zahvat_names [ 0 ], MAX_PLAYER_NAME, "%s", p_info [ killerid ] [ name ] ) ;
				   		}
					    else if ( zahvat_kills [ 1 ] < p_info [ killerid ] [ family_kills ] )
					    {
					     	zahvat_fractions [ 1 ] = killerfamily ;
						    zahvat_kills [ 1 ] = p_info [ killerid ] [ family_kills ] ;
						    format ( zahvat_names [ 1 ], MAX_PLAYER_NAME, "%s", p_info [ killerid ] [ name ] ) ;
				   		}
					    else if ( zahvat_kills [ 2 ] < p_info [ killerid ] [ family_kills ] )
					    {
						    zahvat_fractions [ 2 ] = killerfamily ;
						    zahvat_kills [ 2 ] = p_info [ killerid ] [ family_kills ] ;
						    format ( zahvat_names [ 2 ], MAX_PLAYER_NAME, "%s", p_info [ killerid ] [ name ] ) ;
					    }

						if ( killerfamily == _gz_owner && deathfamily == _gz_attacker )
						{
							format ( scm_string, sizeof scm_string, "[U-FAM] %s [%s] завалил(а) %s [%s] (+%d очков). Счёт: %s [%d] : [%d] %s",
							p_info [ killerid ] [ name ], family_info [ _gz_owner - 1 ] [ fam_name ],
							p_info [ playerid ] [ name ], family_info [ _gz_attacker - 1 ] [ fam_name ],
							score_kill, family_info [ _gz_owner - 1 ] [ fam_name ], zones_owner_points,
							zones_attacker_points, family_info [ _gz_attacker - 1 ] [ fam_name ] ) ;
						}

						else if ( killerfamily == _gz_owner && family_diplomacy [ deathfamily ] [ _gz_attacker ] == dip_status_alliance )
						{
							format ( scm_string, sizeof scm_string, "[U-FAM] %s [%s] завалил(а) %s [Альянс с %s] (+%d очков). Счёт: %s [%d] : [%d] %s",
							p_info [ killerid ] [ name ], family_info [ _gz_owner - 1 ] [ fam_name ],
							p_info [ playerid ] [ name ], family_info [ _gz_attacker - 1 ] [ fam_name ],
							score_kill, family_info [ _gz_owner - 1 ] [ fam_name ], zones_owner_points,
							zones_attacker_points, family_info [ _gz_attacker - 1 ] [ fam_name ] ) ;
						}

						else if ( family_diplomacy [ killerfamily ] [ _gz_owner ] == dip_status_alliance && deathfamily == _gz_attacker && family_diplomacy [ killerfamily ] [ _gz_attacker ] == dip_status_war )
						{
							format ( scm_string, sizeof scm_string, "[U-FAM] %s [Альянс с %s] завалил(а) %s [%s] (+%d очков). Счёт: %s [%d] : [%d] %s",
							p_info [ killerid ] [ name ], family_info [ _gz_owner - 1 ] [ fam_name ],
							p_info [ playerid ] [ name ], family_info [ _gz_attacker - 1 ] [ fam_name ],
							score_kill, family_info [ _gz_owner - 1 ] [ fam_name ], zones_owner_points,
							zones_attacker_points, family_info [ _gz_attacker - 1 ] [ fam_name ] ) ;
						}

						else if ( family_diplomacy [ killerfamily ] [ _gz_owner ] == dip_status_alliance && family_diplomacy [ deathfamily ] [ _gz_attacker ] == dip_status_alliance && family_diplomacy [ killerfamily ] [ _gz_attacker ] == dip_status_war )
						{
							format ( scm_string, sizeof scm_string, "[U-FAM] %s [Альянс с %s] завалил(а) %s [Альянс с %s] (+%d очков). Счёт: %s [%d] : [%d] %s",
							p_info [ killerid ] [ name ], family_info [ _gz_owner - 1 ] [ fam_name ],
							p_info [ playerid ] [ name ], family_info [ _gz_attacker - 1 ] [ fam_name ],
							score_kill, family_info [ _gz_owner - 1 ] [ fam_name ], zones_owner_points,
							zones_attacker_points, family_info [ _gz_attacker - 1 ] [ fam_name ] ) ;
						}
						
						new _family_id ;
						foreach(new i: logged_players)
						{
						    if ( ! p_info [ i ] [ family ] && ! admin_info [ i ] [ admin_settings ] [ 0 ] ) continue ;

							SendDeathMessageToPlayer ( i, killerid, playerid, reason ) ;

							_family_id = p_info [ i ] [ family ] ;
							if ( ( ( family_diplomacy [ _gz_owner ] [ _family_id ] == dip_status_alliance || is_control_chat { i } == _gz_owner || _family_id == _gz_owner ) ||
							( family_diplomacy [ _gz_attacker ] [ _family_id ] == dip_status_alliance || is_control_chat { i } == _gz_attacker || _family_id == _gz_attacker ) ) && p_info [ i ] [ settings ] [ 0 ] != 0 ) SendClientMessage ( i, family_info [ _gz_owner - 1 ] [ fam_zone_color ], scm_string ) ;

                            format ( td_string, sizeof td_string, "%d", zones_owner_points ) ;
							PlayerTextDrawSetString ( i, family_ptd [ i ] [ 3 ], td_string ) ;

							if ( p_info [ i ] [ family_status ] > 2 )
							{
								format ( td_string, sizeof td_string, "%s", zones_kills_first_name ) ;
								PlayerTextDrawSetString ( i, family_ptd [ i ] [ 8 ], td_string ) ;
							}
						}
					}
				}
			}
		}
	}
	return 1 ;
}

callback: family_itog_callback ( )
{
    new rows, fields;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
	    for(new i; i < rows; i++)
	    {
	        new family_id, scm_string [ 100 ] ;
	    	family_id = cache_get_field_content_int ( i, "fam_id", sql_connection ) ;
	        if ( i == 0 )
	        {
	            family_top [ 0 ] = family_id ;
	        
	            format ( scm_string, sizeof scm_string, "{%s}[FAM] Ваша семья занимает первое место в рейтинге. Бонус: %d "family_title".", family_info [ family_id - 1 ] [ fam_chat_color ], bonus_family_ticket [ 0 ] ) ;
				family_message ( family_id, col_gray, scm_string ) ;

				family_info [ family_id - 1 ] [ fam_ticket ] += bonus_family_ticket [ 0 ] ;
				continue ;
			}
			else if ( i == 1 )
			{
			    family_top [ 1 ] = family_id ;

	            format ( scm_string, sizeof scm_string, "{%s}[FAM] Ваша семья занимает второе место в рейтинге. Бонус: %d "family_title".", family_info [ family_id - 1 ] [ fam_chat_color ], bonus_family_ticket [ 1 ] ) ;
				family_message ( family_id, col_gray, scm_string ) ;

				family_info [ family_id - 1 ] [ fam_ticket ] += bonus_family_ticket [ 1 ] ;
				continue ;
			}
			else if ( i == 2 )
			{
			    family_top [ 2 ] = family_id ;

	            format ( scm_string, sizeof scm_string, "{%s}[FAM] Ваша семья занимает третье место в рейтинге. Бонус: %d "family_title".", family_info [ family_id - 1 ] [ fam_chat_color ], bonus_family_ticket [ 2 ] ) ;
				family_message ( family_id, col_gray, scm_string ) ;

				family_info [ family_id - 1 ] [ fam_ticket ] += bonus_family_ticket [ 2 ] ;
				continue ;
			}
	    }
	}
	return 1 ;
}

stock familys_rename ( playerid, new_name [ ], old_name [ ] )
{
	new sql_string [ 138 ] ;
	new familyid = p_info [ playerid ] [ family ] ;
	if ( familyid > 0 )
    {
	    if ( GetString ( family_info [ familyid - 1 ] [ fam_creator ], old_name ) )
	    {
	        format ( family_info [ familyid - 1 ] [ fam_creator ], MAX_PLAYER_NAME, "%s", new_name ) ;
			format ( sql_string, sizeof sql_string, "UPDATE `family` SET `fam_creator` = '%s' WHERE `fam_id` = '%d' LIMIT 1", new_name, familyid ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
	    }
	}
	
	format ( sql_string, sizeof ( sql_string ), "UPDATE `familys_blacklist` SET `bl_name` = '%s' WHERE `bl_name` = '%s'", new_name, p_info [ playerid ] [ name ] ) ;
	mysql_tquery ( sql_connection, sql_string ) ;
	
	format ( sql_string, sizeof ( sql_string ), "UPDATE `familys_blacklist` SET `bl_add_name` = '%s' WHERE `bl_add_name` = '%s'", new_name, p_info [ playerid ] [ name ] ) ;
	mysql_tquery ( sql_connection, sql_string ) ;
	return 1 ;
}

CMD:allfamily ( playerid, params [ ] )
{
    if ( admin_info [ playerid ] [ admin ] < 3 )return 1 ;
    if ( sscanf ( params, "d", params [ 0 ] ) ) SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /allfamily [ид]" ) ;
    if ( params [ 0 ] > family_count ) return 1 ;
    if ( params [ 0 ] > 0 )
    {
        SetPVarInt ( playerid, "fam_id_select", params [ 0 ] - 1 ) ;
        new select_id = GetPVarInt ( playerid, "fam_id_select" ) ;
        
        new line_string [ 64 ] ;
        format ( line_string, sizeof line_string, "{"#cBHD"}{%s}%s", family_info [ select_id ] [ fam_chat_color ], family_info [ select_id ] [ fam_name ] ) ;

        global_string [ 0 ] = EOS ;
		format ( global_string, 512, "{"#cBL"}1. {"#cWH"}Изменить создателя\n{"#cBL"}2. {"#cWH"}Изменить название\n{"#cBL"}3. {"#cWH"}Изменить "family_title"\n{"#cBL"}4. {"#cWH"}Изменить кол-во слотов для т/с\n \n{"#cGRDialog"}- Создатель: {"#cWH"}%s\n{"#cGRDialog"}- "family_title": {"#cWH"}%d\n{"#cGRDialog"}- Слотов для т/с: {"#cWH"}%d\n{"#cGRDialog"}- Банк семьи: {"#cWH"}%d"valute_title_"", family_info [ select_id ] [ fam_creator ], family_info [ select_id ] [ fam_ticket ], family_info [ select_id ] [ fam_max_car ], family_info [ select_id ] [ fam_bank ] ) ;
        show_dialog(playerid, d_allfamily_select, DIALOG_STYLE_LIST, line_string, global_string, "Выбрать", "Закрыть" ) ;
        return 1 ;
    }
    page_count [ playerid ] = 1 ;
	new rows_list = page_count [ playerid ] - 1 ;
	page_rows [ playerid ] = family_count ;

	global_string [ 0 ] = EOS ;
	new line_string [ 128 ], row_count ;
	for ( new f = rows_list * 10 ; f < rows_list * 10 + 10 ; f ++ )
	{
		if ( f >= family_count ) break ;
	
	    set_player_listitem_values ( playerid, f - rows_list * 10, f ) ;
	    
		format ( line_string, sizeof ( line_string ), "{"#cWH"}%i. {%s}%s{"#cWH"}, Создатель: %s\n", f + 1, family_info [ f ] [ fam_chat_color ], family_info [ f ] [ fam_name ], family_info [ f ] [ fam_creator ] ) ;
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
	
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}

	show_dialog(playerid, d_allfamily, DIALOG_STYLE_LIST, "{"#cBHD"}Семьи", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_allfamily ( playerid )
{
    new rows_list = page_count [ playerid ] - 1 ;

	global_string [ 0 ] = EOS ;
	new line_string [ 128 ], row_count ;
	for ( new f = rows_list * 10 ; f < rows_list * 10 + 10 ; f ++ )
	{
	    if ( f >= family_count ) break ;

	    set_player_listitem_values ( playerid, f - rows_list * 10, f ) ;

		format ( line_string, sizeof ( line_string ), "{"#cWH"}%i. {%s}%s{"#cWH"}, Создатель: %s\n", f + 1, family_info [ f ] [ fam_chat_color ], family_info [ f ] [ fam_name ], family_info [ f ] [ fam_creator ] ) ;
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
	
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_allfamily, DIALOG_STYLE_LIST, "{"#cBHD"}Семьи", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock familys_offuninvite_check ( playerid, pl_name [ ], scm_uninvite [ ] )
{
	new _pl_id, query_string [ 256 ], family_id = p_info [ playerid ] [ family ] ;
	sscanf ( pl_name, "u", _pl_id ) ;
	if ( IsPlayerConnected ( _pl_id ) )
	{
	  	if ( playerid == _pl_id )
		{
	       	SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете применить это действие к себе." ) ;

			DeletePVar( playerid, "ofm_listitem" ) ;
			if ( player_open_family [ playerid ] == false )
			{
				if( ! GetPVarInt ( playerid, "ofm_type" ) )
				{
					mysql_format ( sql_connection, query_string, 144, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d'", p_info [ playerid ] [ family ] ) ;
					mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
				}
					
				mysql_format ( sql_connection, query_string, 144, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d' AND `u_family_rank` = '%d'", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "ofm_type" ) ) ;
				mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
				return 1 ;
			}
 		}

		new clf_string [ 3 + 24 ] ;
    	format ( clf_string, sizeof clf_string, "%d %s", _pl_id, scm_uninvite ) ;
		callcmd::famuninvite ( playerid, clf_string ) ;
		return 1 ;
	}
	else
	{
		format ( query_string, sizeof query_string, "{"#cRInfo"}* {"#cGRInfo"}%s выгнал(а) Вас из семьи!\n\n{"#cRInfo"}* {"#cGRInfo"}Причина: %s", p_info [ playerid ] [ name ], scm_uninvite ) ;
		
		new query_string1 [ 59 + MAX_PLAYER_NAME ] ;
		format ( query_string1, sizeof ( query_string1 ), "SELECT `u_id` FROM `users` WHERE `u_name` = '%s' LIMIT 1", pl_name ) ;
		mysql_tquery ( sql_connection, query_string1, "callback_off_message", "iiis", playerid, 5, 1, query_string ) ;
	}

	format ( query_string, 144, "UPDATE `users` SET `u_family` = '0', `u_family_rank` = '0', `u_famblock` = '0' WHERE `u_name` = '%s' LIMIT 1", pl_name ) ;
	mysql_tquery ( sql_connection, query_string, "", "" ) ;

	format ( query_string, 144, "Вы выгнали {"#cBL"}%s{"#cWH"} из семьи.", pl_name ) ;
	SendClientMessage ( playerid, col_white, query_string ) ;
		
	family_info [ family_id - 1 ] [ fam_members ] -- ;
	format ( query_string, 144, "UPDATE `family` SET `fam_members` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_members ], family_id ) ;
	mysql_tquery(sql_connection, query_string ) ;

	format(query_string, 128, "%s выгнал(а) из семьи %s.", p_info [ playerid ] [ name ], pl_name ) ;
	write_family(playerid, family_id, TYPE_LOG_UVAL, query_string);

	DeletePVar( playerid, "ofm_listitem" ) ;
	if ( player_open_family [ playerid ] == false )
	{
		if( ! GetPVarInt ( playerid, "ofm_type" ) )
		{
			mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d'", p_info [ playerid ] [ family ] ) ;
			mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
			return 1 ;
		}

		mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d' AND `u_family_rank` = '%d'", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "ofm_type" ) ) ;
		mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
	}
	return 1 ;
}

stock familys_offmembers_rank ( playerid, value_rank, pl_name [ ] )
{
	new _pl_id, _text_string [ 144 ] ;
	sscanf ( pl_name, "u", _pl_id ) ;
	if ( IsPlayerConnected ( _pl_id ) )
	{
	    if ( playerid == _pl_id )
	    {
	        SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете применить это действие к себе." ) ;

			show_offmembers_dialog ( playerid, pl_name, 1 ) ;
		  	return 1 ;
	    }
		p_info [ _pl_id ] [ family_rang ] = value_rank ;
		format ( _text_string, sizeof _text_string, "{"#cBL"}%s{FFFFFF} изменил(а) Ваш ранг в семье на {"#cBL"}%d{FFFFFF}.", p_info [ playerid ] [ name ], value_rank ) ;
		SendClientMessage ( _pl_id, col_white, _text_string ) ;
	}
	else
	{
		new query_string [ 59 + MAX_PLAYER_NAME ] ;
		format ( query_string, sizeof ( query_string ), "SELECT `u_id` FROM `users` WHERE `u_name` = '%s' LIMIT 1", pl_name ) ;
		mysql_tquery ( sql_connection, query_string, "callback_off_message", "iiis", playerid, 6, value_rank, "none" ) ;
	}

	format ( _text_string,sizeof(_text_string),"UPDATE `users` SET `u_family_rank` = '%d' WHERE `u_name` = '%s' LIMIT 1", value_rank, pl_name ) ;
	mysql_tquery ( sql_connection, _text_string, "", "" ) ;

	format ( _text_string, sizeof _text_string, "Вы изменили ранг {"#cBL"}%s{FFFFFF} на {"#cBL"}%d{FFFFFF}.", pl_name, value_rank ) ;
	SendClientMessage ( playerid, col_white, _text_string ) ;

	format(_text_string, 128, "%s изменил(а) ранг %s на %d.", p_info [ playerid ] [ name ], pl_name, value_rank ) ;
	write_family(playerid, p_info [ playerid ] [ family ], TYPE_LOG_AGIVERANK, _text_string);
	return 1 ;
}

CMD:fammute ( playerid, params [ ] )
{
    if ( p_info [ playerid ] [ family ]  < 1 ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье.");
	
	new family_id = p_info [ playerid ] [ family ] ;
	if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 5 ] )
	{
		static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Команда доступна со статуса %s (%d)." ;
	    new scm_string [ sizeof _str + 30 + 3 ] ;
	    format ( scm_string, sizeof scm_string, _str, family_rank [ family_id - 1 ] [ family_info [ family_id - 1 ] [ fam_settings ] [ 5 ] - 1 ], family_info [ family_id - 1 ] [ fam_settings ] [ 5 ] ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return 1 ;
	}
	if ( sscanf ( params, "uds[42]", params [ 0 ], params [ 1 ], params [ 2 ] ) )return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /fammute [ид] [минуты] [причина]" ) ;
	if ( ! IsPlayerConnected ( params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
	if ( p_info [ params [ 0 ] ] [ family ] != family_id ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не состоит в Вашей семье." ) ;
	if ( p_info [ params [ 0 ] ] [ family_rang ]  >= p_info [ playerid ] [ family_rang ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете дать затычку своему руководству." ) ;
	if ( params [1] < 1 || params [1] > 120 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Затычка не может быть меньше 1 минуты или больше 120 минут." ) ;

    new _t_string [ 144 ] ;
    format ( _t_string,sizeof(_t_string),"{%s}[FAM] %s %s поставил(а) затычку %s на %i мин. Причина: %s", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], p_info [ params [ 0 ] ] [ name ], params [ 1 ], params [ 2 ] ) ;
    family_message ( family_id, col_gray, _t_string ) ;

    format ( _t_string, 128, "%s поставил(а) затычку %s на %i мин. Причина: %s", p_info [ playerid ] [ name ], p_info [ params [ 0 ] ] [ name ], params [ 1 ], params [ 2 ]);
	write_family(playerid, family_id, TYPE_LOG_WARN, _t_string ) ;

	p_info [ params [ 0 ] ] [ fam_mute ] = params [ 1 ] * 60 ;
	return 1;
}

CMD:famunmute ( playerid, params [ ] )
{
    if ( p_info [ playerid ] [ family ] < 1 ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье.");
	
	new family_id = p_info [ playerid ] [ family ] ;
	if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 5 ] )
	{
	    static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Команда доступна со статуса %s (%d)." ;
	    new scm_string [ sizeof _str + 30 + 3 ] ;
	    format ( scm_string, sizeof scm_string, _str, family_rank [ family_id - 1 ] [ family_info [ family_id - 1 ] [ fam_settings ] [ 5 ] - 1 ], family_info [ family_id - 1 ] [ fam_settings ] [ 5 ] ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return 1 ;
	}
	if ( sscanf ( params, "u", params [ 0 ] ) )return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /famunmute [ид]" ) ;
	if ( ! IsPlayerConnected ( params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
	if ( p_info [ params [ 0 ] ] [ family ] != family_id ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не состоит в Вашей семье." ) ;
	if ( p_info [ params [ 0 ] ] [ family_rang ]  >= p_info [ playerid ] [ family_rang ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете дать затычку своему руководству." ) ;
	if ( p_info [ params [ 0 ] ] [ fam_mute ] == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока нет затычки." ) ;

	p_info [ params [ 0 ] ] [ fam_mute ] = 0 ;
	update_int_sql ( params [ 0 ], "u_fammute", 0 ) ;

    new _t_string [ 144 ] ;
    format(_t_string,sizeof(_t_string),"{%s}[FAM] %s %s снял(а) затычку с %s.", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], p_info [ params [ 0 ] ] [ name ] ) ;
    family_message ( family_id, col_gray, _t_string ) ;

    format(_t_string, 128, "%s снял(а) затычку с %s.", p_info [ playerid ] [ name ], p_info [ params [ 0 ] ] [ name ]);
	write_family(playerid, family_id, TYPE_LOG_WARN, _t_string);
	return 1;
}

CMD:ufam ( playerid, params [ ] )
{
    if ( p_info [ playerid ] [ family ] < 1 ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье.");
	if ( p_info [ playerid ] [ mute ] )
	{
		new scm_string [ 38 ] ;
		format ( scm_string, sizeof ( scm_string  ),"У вас бан чата | %d секунд(ы)", p_info [ playerid ] [ mute ] ) ;
		SendClientMessage ( playerid, col_light_red, scm_string ) ;
		return false ;
	}
	
	if ( p_info [ playerid ] [ fam_mute ] )
	{
		new scm_string [ 78 ] ;
		format ( scm_string, sizeof ( scm_string ),"{"#cRInfo"}* {"#cGRInfo"}У вас затычка в чате семьи | %d секунд(ы)", p_info [ playerid ] [ fam_mute ] ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return false ;
	}
	
	if ( globalchat_cooldown [ playerid ] > gettime ( ) )
	{
		new scm_string [ 81 + 9 ] ;
		format ( scm_string, sizeof ( scm_string ), "Вы уже писали в чат альянса. Повторно написать можно будет через %d секунд(ы).", globalchat_cooldown [ playerid ] - gettime ( ) ) ;
		SendClientMessage ( playerid,  col_light_red, scm_string ) ;
		return true ;
	}

	globalchat_cooldown [ playerid ] = gettime ( ) + 60 ;
	
    if ( sscanf ( params, "s[100]", params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /ufam [текст]" ) ;
  	if ( check_advertise ( playerid, params [ 0 ], report_type_ufam ) ) return 1 ;
  	
	new _t_string [ 144 ], family_id = p_info [ playerid ] [ family ] ;
	format ( _t_string, sizeof ( _t_string ), "[U-FAM] (%s) %s %s: %s", family_info [ family_id - 1 ] [ fam_name ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], params [ 0 ] ) ;
    foreach(new i: logged_players)
    {
        if ( ! p_info [ i ] [ family ] ) continue ;
        
        new other_family_id = p_info [ i ] [ family ] ;
        if ( ( family_dip_settings [ family_id ] [ other_family_id ] [ 0 ] == dip_settings_on || family_id == p_info [ i ] [ family ] ) && p_info [ i ] [ settings ] [ 5 ] != 0 )
		{
			SendClientMessage ( i, col_fam_alliance, _t_string ) ;
			if ( player_last_page [ i ] == 16 ) familyAddDiplomacyItem ( i, p_info [ playerid ] [ name ], family_info [ family_id - 1 ] [ fam_name ], params [ 0 ] ) ;
		}
    }
    return 1 ;
}

CMD:fam ( playerid, params [ ] )
{
    if ( p_info [ playerid ] [ family ] < 1 ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье.");
	if ( p_info [ playerid ] [ mute ] )
	{
		new scm_string [ 38 ] ;
		format ( scm_string, sizeof ( scm_string  ),"У вас бан чата | %d секунд(ы)", p_info [ playerid ] [ mute ] ) ;
		SendClientMessage ( playerid, col_light_red, scm_string ) ;
		return false ;
	}
	if ( p_info [ playerid ] [ fam_mute ] )
	{
		new scm_string [ 78 ] ;
		format ( scm_string, sizeof ( scm_string ),"{"#cRInfo"}* {"#cGRInfo"}У вас затычка в чате семьи | %d секунд(ы)", p_info [ playerid ] [ fam_mute ] ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return false ;
	}
    if ( sscanf ( params, "s[100]", params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /fam [текст]" ) ;
  	if ( check_advertise ( playerid, params [ 0 ], report_type_fam ) ) return 1 ;
  	
	new _t_string [ 144 ], family_id = p_info [ playerid ] [ family ] ;
    if ( p_info [ playerid ] [ famblock ] ) format(_t_string,sizeof(_t_string),"{%s}[FAM] (WB) %s %s: %s", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], params [ 0 ] ) ;
	else format(_t_string,sizeof(_t_string),"{%s}[FAM] %s %s: %s", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], params [ 0 ] ) ;
    family_message ( family_id, col_gray, _t_string ) ;
    return 1 ;
}

stock save_family_diplomacy ( family_id, to_family_id, family_dip_status )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 200, "SELECT `fam_dip` FROM `family_wars` WHERE `f_fam` = '%d' AND `f_to_fam` = '%d' OR `f_fam` = '%d' AND `f_to_fam` = '%d' LIMIT 1", family_id, to_family_id, to_family_id, family_id ) ;
	mysql_tquery ( sql_connection, global_string, "callback_save_fam_diplomacy", "iii", family_id, to_family_id, family_dip_status ) ;
	return 1 ;
}

callback: callback_save_fam_diplomacy ( family_id, to_family_id, family_dip_status )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	if ( rows )
	{
		global_string [ 0 ] = EOS ;
		mysql_format ( sql_connection, global_string, 165, "UPDATE `family_wars` SET `fam_dip` = '%d' WHERE `f_fam` = '%d' AND `f_to_fam` = '%d' OR `f_fam` = '%d' AND `f_to_fam` = '%d' LIMIT 1",
		family_dip_status, family_id, to_family_id, to_family_id, family_id ) ;
		mysql_tquery ( sql_connection, global_string ) ;

		if ( family_dip_status != dip_status_alliance )
		{
			family_dip_settings [ family_id ] [ to_family_id ] [ 0 ] = dip_settings_off ;
			family_dip_settings [ to_family_id ] [ family_id ] [ 0 ] = dip_settings_off ;
			family_dip_settings [ family_id ] [ to_family_id ] [ 1 ] = dip_settings_off ;
			family_dip_settings [ to_family_id ] [ family_id ] [ 1 ] = dip_settings_off ;
		
			global_string [ 0 ] = EOS ;
		    mysql_format ( sql_connection, global_string, 165, "UPDATE `family_wars` SET `fam_chat` = '%d', `fam_damage` = '%d' WHERE `f_fam` = '%d' AND `f_to_fam` = '%d' OR `f_fam` = '%d' AND `f_to_fam` = '%d' LIMIT 1",
			family_dip_settings [ family_id ] [ to_family_id ] [ 0 ], family_dip_settings [ family_id ] [ to_family_id ] [ 1 ], family_id, to_family_id, to_family_id, family_id ) ;
			mysql_tquery ( sql_connection, global_string ) ;
		}
		else
		{
			global_string [ 0 ] = EOS ;
		    mysql_format ( sql_connection, global_string, 165, "UPDATE `family_wars` SET `fam_chat` = '%d', `fam_damage` = '%d' WHERE `f_fam` = '%d' AND `f_to_fam` = '%d' OR `f_fam` = '%d' AND `f_to_fam` = '%d' LIMIT 1",
			family_dip_settings [ family_id ] [ to_family_id ] [ 0 ], family_dip_settings [ family_id ] [ to_family_id ] [ 1 ], family_id, to_family_id, to_family_id, family_id ) ;
			mysql_tquery ( sql_connection, global_string ) ;
		}
	}
	else
	{
		family_dip_settings [ family_id ] [ to_family_id ] [ 0 ] = dip_settings_off ;
		family_dip_settings [ to_family_id ] [ family_id ] [ 0 ] = dip_settings_off ;
		family_dip_settings [ family_id ] [ to_family_id ] [ 1 ] = dip_settings_off ;
		family_dip_settings [ to_family_id ] [ family_id ] [ 1 ] = dip_settings_off ;
		
		global_string [ 0 ] = EOS ;
	    format ( global_string, 165, "INSERT INTO `family_wars` (`f_fam`,`f_to_fam`,`fam_dip`) VALUES ('%d','%d','%d')", family_id, to_family_id, family_dip_status ) ;
		mysql_tquery ( sql_connection, global_string ) ;
	}
	return 1 ;
}

alias:fmenu("fm")
CMD:fmenu ( playerid )
{
	if ( p_info [ playerid ] [ family ] < 1 )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
	
	show_family ( playerid ) ;
	checking_quest_progress ( playerid, 1, 1, quest_line_high ) ;
	return 1 ;
}

CMD:famhouse ( playerid )
{
	if ( p_info [ playerid ] [ family ] < 1 )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте {"#cRInfo"}/reitfam{"#cGRInfo"}, чтоб найти себе семью." ) ;
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Следите за объявлениями в чате, чтоб найти себе семью." ) ;
		return 1 ;
	}
	
	new family_id = p_info [ playerid ] [ family ] ;
	if ( ! family_info [ family_id - 1 ] [ fam_house ] ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи нет дома." ) ;
	
	if ( family_info [ family_id - 1 ] [ fam_house ] )
	{
		if ( GetPlayerVirtualWorld ( playerid ) == family_info [ family_id - 1 ] [ fam_house ] )
		{
			show_family_house ( playerid ) ;
			return 1 ;
		}
	}
				
	new s_house_id = family_info [ family_id - 1 ] [ fam_house ] - 1 ;
	if ( h_info [ s_house_id ] [ h_podezd ] != -1 )
	{
	   	new _padik_id = h_info [ s_house_id ] [ h_podezd ] ;
		SetPlayerRaceCheckpoint ( playerid, 1, podezd_info [ _padik_id ] [ p_pos ] [ 0 ], podezd_info [ _padik_id ] [ p_pos ] [ 1 ], podezd_info [ _padik_id ] [ p_pos ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
	}
	else SetPlayerCheckpoint ( playerid, h_info [ s_house_id ] [ h_pos ] [ 0 ], h_info [ s_house_id ] [ h_pos ] [ 1 ], h_info [ s_house_id ] [ h_pos ] [ 2 ], 4.0 ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Ваш семейный дом обозначен на карте красной меткой." ) ;
	SendClientMessage ( playerid, col_gray, !"* Находясь в семейном доме команда {"#cWH"}/famhouse {"#cGRInfo"}откроет меню взаимодействия." ) ;
	is_gps_used { playerid } = 1 ;
	return 1 ;
}

stock clear_fam_house ( playerid, houseid, type = 0 )
{
    if ( type == 0 )
	{
		new familyid = p_info [ playerid ] [ family ] ;
		if ( familyid )
		{
		    if ( ! family_info [ familyid - 1 ] [ fam_house ] ) return 1 ;
		    if ( family_info [ familyid - 1 ] [ fam_house ] == h_info [ houseid - 1 ] [ h_id ] )
			{
				h_info [ houseid - 1 ] [ h_zz_status ] = 0 ;
			    family_info [ familyid - 1 ] [ fam_house ] = 0 ;
				
				if ( gdorm_family_text [ familyid - 1 ] != Text3D:INVALID_3DTEXT_ID )
				{
					DestroyDynamicArea ( dorm_family_area [ familyid - 1 ] ) ;
					DestroyDynamicCP ( dorm_family_cp [ familyid - 1 ] ) ;
					DestroyDynamic3DTextLabel ( gdorm_family_text [ familyid - 1 ] ) ;
					gdorm_family_text [ familyid - 1 ] = Text3D:INVALID_3DTEXT_ID ;
				}
				
				dorm_family_pos [ familyid - 1 ] [ 0 ] = dorm_family_pos [ familyid - 1 ] [ 1 ] = dorm_family_pos [ familyid - 1 ] [ 2 ] = 0.0 ;

			    new query_string [ 101 + ( 3 * 8 ) + ( 2 * 9 ) + 9 ] ;
			   	format ( query_string, sizeof query_string, "UPDATE `family` SET `fam_house` = '0', `fam_dorm` = '%f|%f|%f|%d|%d' WHERE `fam_id` = '%d' LIMIT 1",
			   	dorm_family_pos [ familyid - 1 ] [ 0 ], dorm_family_pos [ familyid - 1 ] [ 1 ], dorm_family_pos [ familyid - 1 ] [ 2 ], dorm_family_int [ familyid - 1 ], dorm_family_virt [ familyid - 1 ], familyid ) ;
			   	mysql_tquery ( sql_connection, query_string ) ;

				add_family_house ( houseid - 1, 2 ) ;
			    if ( Iter_Count(family_vehicles[familyid]) > 0 )
			    {
					foreach(new v: family_vehicles[familyid])
					{
						if ( ! IsValidVehicle ( v ) ) continue ;
						
					    DestroyVehicle ( v, 5 ) ;
					    veh_info [ v - 1 ] [ v_vehicle ] = INVALID_VEHICLE_ID ;
					}
					Iter_Clear(family_vehicles[familyid]) ;
				}
			}
		}
	}
	else if ( type == 1 )
	{
		for ( new i = 0 ; i < family_count ; i ++ )
	    {
	    	if ( ! family_info [ i ] [ fam_house ] ) continue ;
		    if ( family_info [ i ] [ fam_house ] == h_info [ houseid - 1 ] [ h_id ] )
			{
				h_info [ houseid - 1 ] [ h_zz_status ] = 0 ;
			    family_info [ i ] [ fam_house ] = 0 ;
				
				if ( gdorm_family_text [ i ] != Text3D:INVALID_3DTEXT_ID )
				{
					DestroyDynamicArea ( dorm_family_area [ i ] ) ;
					DestroyDynamicCP ( dorm_family_cp [ i ] ) ;
					DestroyDynamic3DTextLabel ( gdorm_family_text [ i ] ) ;
					gdorm_family_text [ i ] = Text3D:INVALID_3DTEXT_ID ;
				}

				dorm_family_pos [ i ] [ 0 ] = dorm_family_pos [ i ] [ 1 ] = dorm_family_pos [ i ] [ 2 ] = 0.0 ;

			    new query_string [ 101 + ( 3 * 8 ) + ( 2 * 9 ) + 9 ] ;
			   	format ( query_string, sizeof query_string, "UPDATE `family` SET `fam_house` = '0', `fam_dorm` = '%f|%f|%f|%d|%d' WHERE `fam_id` = '%d' LIMIT 1",
			   	dorm_family_pos [ i ] [ 0 ], dorm_family_pos [ i ] [ 1 ], dorm_family_pos [ i ] [ 2 ], dorm_family_int [ i ], dorm_family_virt [ i ], i + 1 ) ;
			   	mysql_tquery ( sql_connection, query_string ) ;

				add_family_house ( houseid - 1, 2 ) ;
			    if ( Iter_Count(family_vehicles[i + 1]) > 0 )
			    {
					foreach(new v: family_vehicles[i + 1])
					{
						if ( ! IsValidVehicle ( v ) ) continue ;
						
					    DestroyVehicle ( v, 5 ) ;
					    veh_info [ v - 1 ] [ v_vehicle ] = INVALID_VEHICLE_ID ;
					}
					Iter_Clear(family_vehicles[i + 1]) ;
				}
			}
			break ;
		}
	}
	else if ( type == 2 )
	{
		for ( new i = 0 ; i < family_count ; i ++ )
	    {
	    	if ( ! family_info [ i ] [ fam_house ] ) continue ;
			
			new _h_id = family_info [ i ] [ fam_house ] ;
			if ( ! GetString ( family_info [ i ] [ fam_creator ], h_info [ _h_id - 1 ] [ h_owner_name ] ) )
			{
				h_info [ _h_id - 1 ] [ h_zz_status ] = 0 ;
			    family_info [ i ] [ fam_house ] = 0 ;
				
				if ( gdorm_family_text [ i ] != Text3D:INVALID_3DTEXT_ID )
				{
					DestroyDynamicArea ( dorm_family_area [ i ] ) ;
					DestroyDynamicCP ( dorm_family_cp [ i ] ) ;
					DestroyDynamic3DTextLabel ( gdorm_family_text [ i ] ) ;
					gdorm_family_text [ i ] = Text3D:INVALID_3DTEXT_ID ;
				}

				dorm_family_pos [ i ] [ 0 ] = dorm_family_pos [ i ] [ 1 ] = dorm_family_pos [ i ] [ 2 ] = 0.0 ;

			    new query_string [ 101 + ( 3 * 8 ) + ( 2 * 9 ) + 9 ] ;
			   	format ( query_string, sizeof query_string, "UPDATE `family` SET `fam_house` = '0', `fam_dorm` = '%f|%f|%f|%d|%d' WHERE `fam_id` = '%d' LIMIT 1",
			   	dorm_family_pos [ i ] [ 0 ], dorm_family_pos [ i ] [ 1 ], dorm_family_pos [ i ] [ 2 ], dorm_family_int [ i ], dorm_family_virt [ i ], i + 1 ) ;
			   	mysql_tquery ( sql_connection, query_string ) ;

				add_family_house ( _h_id - 1, 2 ) ;
			    if ( Iter_Count(family_vehicles[i + 1]) > 0 )
			    {
					foreach(new v: family_vehicles[i + 1])
					{
						if ( ! IsValidVehicle ( v ) ) continue ;
						
					    DestroyVehicle ( v, 5 ) ;
					    veh_info [ v - 1 ] [ v_vehicle ] = INVALID_VEHICLE_ID ;
					}
					Iter_Clear(family_vehicles[i + 1]) ;
				}
			}
		}
	}
	return 1 ;
}

stock show_family_upgrade ( playerid )
{
    global_string [ 0 ] = EOS ;
    
    new family_id = p_info [ playerid ] [ family ] ;
	format ( global_string, 1256, "{"#cBL"}1.{ffffff} Дополнительный EXP {"#cGN"}(1000 "family_title"): %s\n{"#cBL"}2.{ffffff} Успех в работе {"#cGN"}(1200 "family_title"): %s\n{"#cBL"}3.{ffffff} Бизнессмены в долгу {"#cGN"}(900 "family_title"): %s\n{"#cBL"}4.{ffffff} Неузнаваемый {"#cGN"}(800 "family_title"): %s\n{"#cBL"}5.{ffffff} Больница в долгу {"#cGN"}(1100 "family_title"): %s\n{"#cBL"}6.{ffffff} Белый список {"#cGN"}(2000 "family_title"): %s\n{"#cBL"}7.{ffffff} Банковские махинации {"#cGN"}(4000 "family_title"): %s\n{"#cBL"}8.{ffffff} Мародёры {"#cGN"}(7000 "family_title"): %s\n{"#cBL"}9.{ffffff} Рыбный цех {"#cGN"}(6000 "family_title"): %s\n{"#cBL"}10.{ffffff} Галочка {"#cGN"}(1000 "family_title"): %s\n{"#cBL"}11.{ffffff} Бренд {"#cGN"}(1500 "family_title"): %s\n{"#cBL"}Информация по улучшениям",
	( family_info [ family_id - 1 ] [ fam_enhancement ] [ 0 ] ) ? ("{63BD4E}Приобретено") : ("{F04245}Не приобретено"),
	( family_info [ family_id - 1 ] [ fam_enhancement ] [ 1 ] ) ? ("{63BD4E}Приобретено") : ("{F04245}Не приобретено"),
	( family_info [ family_id - 1 ] [ fam_enhancement ] [ 2 ] ) ? ("{63BD4E}Приобретено") : ("{F04245}Не приобретено"),
	( family_info [ family_id - 1 ] [ fam_enhancement ] [ 3 ] ) ? ("{63BD4E}Приобретено") : ("{F04245}Не приобретено"),
	( family_info [ family_id - 1 ] [ fam_enhancement ] [ 4 ] ) ? ("{63BD4E}Приобретено") : ("{F04245}Не приобретено"),
	( family_info [ family_id - 1 ] [ fam_enhancement ] [ 5 ] ) ? ("{63BD4E}Приобретено") : ("{F04245}Не приобретено"),
	( family_info [ family_id - 1 ] [ fam_enhancement ] [ 6 ] ) ? ("{63BD4E}Приобретено") : ("{F04245}Не приобретено"),
	( family_info [ family_id - 1 ] [ fam_enhancement ] [ 7 ] ) ? ("{63BD4E}Приобретено") : ("{F04245}Не приобретено"),
	( family_info [ family_id - 1 ] [ fam_enhancement ] [ 8 ] ) ? ("{63BD4E}Приобретено") : ("{F04245}Не приобретено"),
	( family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ] ) ? ("{63BD4E}Приобретено") : ("{F04245}Не приобретено"),
	( family_info [ family_id - 1 ] [ fam_enhancement ] [ 10 ] ) ? ("{63BD4E}Приобретено") : ("{F04245}Не приобретено") ) ;
	show_dialog ( playerid, d_family_upgrade, DIALOG_STYLE_LIST, "{"#cBHD"}Улучшения семьи", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock show_family_dorm ( playerid )
{
    show_dialog ( playerid, d_family_dorm, DIALOG_STYLE_LIST, "{"#cBHD"}Общак", "{"#cGRDialog"}- {"#cWH"}Открыть общак\n{"#cGRDialog"}- {"#cWH"}Положить "family_title"\n{"#cGRDialog"}- {"#cWH"}Взять "family_title"", "Выбрать", "Назад" ) ;
    return 1 ;
}

stock show_family ( playerid )
{
	if ( player_device { playerid } == 2 )
	{
		new _family_id = p_info [ playerid ] [ family ] ;
		if ( _family_id < 1 ) return 1 ;

		player_open_family [ playerid ] = true ;
		familyShowMainMenuPage ( playerid ) ;
		
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
		
		if ( family_news_loading [ _family_id ] == true )
		{
			new _c_count = 0 ;
			for ( new i = 0 ; i < MAX_FAMILY_NEWS ; i ++ )
			{
				if ( family_news [ _family_id ] [ i ] [ n_id ] == 0 ) continue ;
				
				_c_count ++ ;
			}
			
			if ( ! _c_count ) return 1 ;
			
			new line_string [ 64 ], s_year, s_month, s_day, s_hour, s_minute, s_second ;
			new BitStream:bitstream = BS_New();
			BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
			BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
			
			BS_WriteValue(bitstream, PR_INT8, 3);
			BS_WriteValue(bitstream, PR_INT8, 30);
			
			BS_WriteValue(bitstream, PR_UINT8, _c_count);
			for ( new i = 0 ; i < MAX_FAMILY_NEWS ; i ++ )
			{
				if ( family_news [ _family_id ] [ i ] [ n_id ] == 0 ) continue ;
				
				timestamp_to_date ( family_news [ _family_id ] [ i ] [ n_text_date ] + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( line_string, sizeof line_string, "%02d.%02d.%d", s_day, s_month, s_year ) ;
				BS_WriteValue(
					bitstream,
					PR_UINT8, strlen ( family_news [ _family_id ] [ i ] [ n_text_owner ] ),
					PR_STRING, family_news [ _family_id ] [ i ] [ n_text_owner ],
				
					PR_UINT8, strlen ( line_string ),
					PR_STRING, line_string,
				
					PR_UINT8, strlen ( family_news [ _family_id ] [ i ] [ n_text ] ),
					PR_STRING, family_news [ _family_id ] [ i ] [ n_text ] ) ;
			}
			
			PR_SendPacket(bitstream, playerid);
			BS_Delete(bitstream);
		}
		else
		{
			new sql_string [ 64 + ( 9 * 2 ) ] ;
			format ( sql_string, sizeof sql_string, "SELECT * FROM `family_noty` WHERE `family_id` = '%d' LIMIT %d", _family_id, MAX_FAMILY_NEWS ) ;
			mysql_tquery ( sql_connection, sql_string, "callback_family_noty", "i", playerid ) ;
		}
		return 1 ;
	}
	
	global_string [ 0 ] = EOS ;

	new family_id = p_info [ playerid ] [ family ] ;
	if ( family_info [ family_id - 1 ] [ fam_house ] )
	{
		new house_string [ 48 ] ;
		new house_id = family_info [ family_id - 1 ] [ fam_house ] - 1 ;
		if ( h_info [ house_id ] [ h_improve ] [ improve_wardrobe ] == 0 ) format ( house_string, sizeof house_string, "" ) ;
		else format ( house_string, sizeof house_string, "{"#cGRDialog"}* Нажмите для взаимодействия" ) ;
		
	   	format ( global_string, 800, "\
					{"#cGRDialog"}- {"#cWH"}Информация о семье\n\
					{"#cGRDialog"}- {"#cWH"}Члены семьи\n\
					{"#cGRDialog"}- {"#cWH"}Члены семьи [ {"#cGN"}ОНЛАЙН{"#cWH"} ]\n\
					{"#cGRDialog"}- {"#cWH"}Настройки семьи\n\
					{"#cGRDialog"}- {"#cWH"}Банк семьи: {"#cGN"}%s"valute_title_"\n\
					{"#cGRDialog"}- {"#cWH"}Чёрный список\n\
					{"#cGRDialog"}- {"#cWH"}Дом семьи: {"#cGN"}№%d %s\n\
					{"#cGRDialog"}- {"#cWH"}Управление автопарком\n\
					{"#cGRDialog"}- {"#cWH"}Улучшения\n\
					{"#cGRDialog"}- {"#cWH"}История семьи\n\
					{"#cGRDialog"}- {"#cWH"}Дружеские семьи\n\
					{"#cGRDialog"}- {"#cWH"}Враждебные семьи\n\
					{"#cGRDialog"}- {"#cWH"}Передать семью\n\
					{"#cGRDialog"}Покинуть семью",
	 	GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_bank ] ), family_info [ family_id - 1 ] [ fam_house ], house_string ) ;
		show_dialog ( playerid, d_family, DIALOG_STYLE_LIST, "{"#cBHD"}Меню семьи", global_string, "Выбрать", "Закрыть" ) ;
	}
	else
	{
	    format ( global_string, 800, "\
					{"#cGRDialog"}- {"#cWH"}Информация о семье\n\
					{"#cGRDialog"}- {"#cWH"}Члены семьи\n\
					{"#cGRDialog"}- {"#cWH"}Члены семьи [ {"#cGN"}ОНЛАЙН{"#cWH"} ]\n\
					{"#cGRDialog"}- {"#cWH"}Настройки семьи\n\
					{"#cGRDialog"}- {"#cWH"}Банк семьи: {"#cGN"}%d"valute_title_"\n\
					{"#cGRDialog"}- {"#cWH"}Чёрный список\n\
					{"#cGRDialog"}- {"#cWH"}Дом семьи: {"#cRD"}Не выбран\n\
					{"#cGRDialog"}- {"#cWH"}Управление автопарком\n\
					{"#cGRDialog"}- {"#cWH"}Улучшения\n\
					{"#cGRDialog"}- {"#cWH"}История семьи\n\
					{"#cGRDialog"}- {"#cWH"}Дружеские семьи\n\
					{"#cGRDialog"}- {"#cWH"}Враждебные семьи\n\
					{"#cGRDialog"}- {"#cWH"}Передать семью\n\
					{"#cGRDialog"}Покинуть семью",
	 	GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_bank ] ) ) ;
		show_dialog ( playerid, d_family, DIALOG_STYLE_LIST, "{"#cBHD"}Меню семьи", global_string, "Выбрать", "Закрыть" ) ;
	}
	return 1 ;
}

stock show_settings_family ( playerid, family_id, select_id )
{
	global_string [ 0 ] = EOS ;
	for ( new i = 0; i < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] ; i ++ )
	{
		new line_string [ 64 ] ;
		format ( line_string, 64, "{"#cBL"}%i.{"#cWH"} %s\n", i + 1, family_rank [ family_id - 1 ] [ i ] ) ;
		strcat ( global_string, line_string ) ;
	}
	if ( select_id == 0 )
	{
	    SetPVarInt ( playerid, "select_id", 0 ) ;
		show_dialog ( playerid, d_family_settings_select, DIALOG_STYLE_LIST, "{"#cBHD"}Приём в семью", global_string, "Выбрать", "Назад" ) ;
	}
	else if ( select_id == 1 )
	{
	    SetPVarInt ( playerid, "select_id", 1 ) ;
		show_dialog ( playerid, d_family_settings_select, DIALOG_STYLE_LIST, "{"#cBHD"}Исключение из семьи", global_string, "Выбрать", "Назад" ) ;
	}
	else if ( select_id == 2 )
	{
	    SetPVarInt ( playerid, "select_id", 2 ) ;
		show_dialog ( playerid, d_family_settings_select, DIALOG_STYLE_LIST, "{"#cBHD"}Изменение статуса", global_string, "Выбрать", "Назад" ) ;
	}
	else if ( select_id == 3 )
	{
	    SetPVarInt ( playerid, "select_id", 4 ) ;
		show_dialog ( playerid, d_family_settings_select, DIALOG_STYLE_LIST, "{"#cBHD"}Чёрный список", global_string, "Выбрать", "Назад" ) ;
	}
	else if ( select_id == 4 )
	{
	    SetPVarInt ( playerid, "select_id", 5 ) ;
		show_dialog ( playerid, d_family_settings_select, DIALOG_STYLE_LIST, "{"#cBHD"}Достук к /fam(un)mute", global_string, "Выбрать", "Назад" ) ;
	}
	else if ( select_id == 5 )
	{
	    SetPVarInt ( playerid, "select_id", 6 ) ;
		show_dialog ( playerid, d_family_settings_select, DIALOG_STYLE_LIST, "{"#cBHD"}Доступ к /famlock", global_string, "Выбрать", "Назад" ) ;
	}
	else if ( select_id == 6 )
	{
	    SetPVarInt ( playerid, "select_id", 7 ) ;
		show_dialog ( playerid, d_family_settings_select, DIALOG_STYLE_LIST, "{"#cBHD"}Достук к общаку", global_string, "Выбрать", "Назад" ) ;
	}
	else if ( select_id == 7 )
	{
	    SetPVarInt ( playerid, "select_id", 8 ) ;
		show_dialog ( playerid, d_family_settings_select, DIALOG_STYLE_LIST, "{"#cBHD"}Доступ к /fam(un)warn", global_string, "Выбрать", "Назад" ) ;
	}
	return 1 ;
}

stock show_family_logs ( playerid )
{
    show_dialog ( playerid, d_familys_logs, DIALOG_STYLE_LIST, "{"#cBHD"}История семьи", "{"#cGRDialog"}- {"#cWH"}Ранговая история\n{"#cGRDialog"}- {"#cWH"}История выговоров\n{"#cGRDialog"}- {"#cWH"}Чёрный список\n{"#cGRDialog"}- {"#cWH"}История принятий\n{"#cGRDialog"}- {"#cWH"}История увольнений\n{"#cGRDialog"}- {"#cWH"}История склада", "Выбрать", "Назад" ) ;
	return 1 ;
}

stock family_settings ( playerid )
{
	global_string [ 0 ] = EOS ;

    new f = p_info [ playerid ] [ family ] - 1 ;
	format ( global_string, sizeof ( global_string ), "\
							{"#cGRDialog"}- {"#cWH"}Прием в семью\t{"#cGN"}%s\n\
							{"#cGRDialog"}- {"#cWH"}Исключение из семьи\t{"#cGN"}%s\n\
							{"#cGRDialog"}- {"#cWH"}Изменение статуса\t{"#cGN"}%s\n\
							{"#cGRDialog"}- {"#cWH"}Чёрный список\t{"#cGN"}%s\n\
							{"#cGRDialog"}- {"#cWH"}Доступ к /fam(un)mute\t{"#cGN"}%s\n\
							{"#cGRDialog"}- {"#cWH"}Доступ к /famlock\t{"#cGN"}%s\n\
							{"#cGRDialog"}- {"#cWH"}Доступ к общаку\t{"#cGN"}%s\n\
							{"#cGRDialog"}- {"#cWH"}Количество статусов\t{"#cGN"}%d\n\
							{"#cGRDialog"}- {"#cWH"}Название статусов\t \n\
							{"#cGRDialog"}- {"#cWH"}Национальность семьи\t \n\
							{"#cGRDialog"}- {"#cWH"}Оформление семейного чата\t \n\
							{"#cGRDialog"}- {"#cWH"}Позиция общака\t \n\
							{"#cGRDialog"}- {"#cWH"}Предупреждения\t ",
	family_rank [ f ] [ family_info [ f ] [ fam_settings ] [ 0 ] - 1 ],
	family_rank [ f ] [ family_info [ f ] [ fam_settings ] [ 1 ] - 1 ],
	family_rank [ f ] [ family_info [ f ] [ fam_settings ] [ 2 ] - 1 ],
	family_rank [ f ] [ family_info [ f ] [ fam_settings ] [ 4 ] - 1 ],
	family_rank [ f ] [ family_info [ f ] [ fam_settings ] [ 5 ] - 1 ],
	family_rank [ f ] [ family_info [ f ] [ fam_settings ] [ 6 ] - 1 ],
	family_rank [ f ] [ family_info [ f ] [ fam_settings ] [ 7 ] - 1 ],
	family_info [ f ] [ fam_settings ] [ 3 ] ) ;

	show_dialog ( playerid, d_family_settings, DIALOG_STYLE_TABLIST, "{"#cBHD"}Настройки семьи", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock family_sql ( familyid )
{
    new query_string [ 156 ];
    format ( query_string, sizeof query_string, "UPDATE `family` SET `fam_settings` = '%d|%d|%d|%d|%d|%d|%d|%d|%d' WHERE `fam_id` = '%d' LIMIT 1",
	family_info [ familyid - 1 ] [ fam_settings ] [ 0 ],
	family_info [ familyid - 1 ] [ fam_settings ] [ 1 ],
	family_info [ familyid - 1 ] [ fam_settings ] [ 2 ],
	family_info [ familyid - 1 ] [ fam_settings ] [ 3 ],
	family_info [ familyid - 1 ] [ fam_settings ] [ 4 ],
	family_info [ familyid - 1 ] [ fam_settings ] [ 5 ],
	family_info [ familyid - 1 ] [ fam_settings ] [ 6 ],
	family_info [ familyid - 1 ] [ fam_settings ] [ 7 ],
	family_info [ familyid - 1 ] [ fam_settings ] [ 8 ],
	familyid ) ;
 	mysql_tquery ( sql_connection, query_string ) ;
 	return 1 ;
}

CMD:faminvite ( playerid, params [ ] )
{
    if ( p_info [ playerid ] [ family ]  < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
	
	new _family_id = p_info [ playerid ] [ family ] ;
	if ( p_info [ playerid ] [ family_rang ] < family_info [ _family_id - 1 ] [ fam_settings ] [ 0 ] )
	{
	    static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Команда доступна со статуса %s (%d)." ;
	    new scm_string [ sizeof _str + 30 + 3 ] ;
	    format ( scm_string, sizeof scm_string, _str, family_rank [ _family_id - 1 ] [ family_info [ _family_id - 1 ] [ fam_settings ] [ 0 ] - 1 ], family_info [ _family_id - 1 ] [ fam_settings ] [ 0 ] ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return 1 ;
	}
	
	for ( new j = 0 ; j < 4 ; j ++ ) // Закрываем инвайт на спавнах
	{
		if ( ! IsPlayerInQuad ( playerid, anti_dm_pos [ j ] [ 0 ], anti_dm_pos [ j ] [ 1 ], anti_dm_pos [ j ] [ 2 ], anti_dm_pos [ j ] [ 3 ] ) )continue ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Запрещено принимать игроков в семью на месте появления." ) ;
		return 1 ;
	}
	
	if ( sscanf ( params, "u", params [ 0 ] ) )return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /faminvite [id/имя]" ) ;

 	if ( ! IsPlayerConnected ( params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
	if ( params [ 0 ] == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете применить это к самому себе." ) ;
	if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ params [ 0 ] ][ p_pos ] [ 0 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 1 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( params [ 0 ] ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;
	if ( ! bad_dialog ( params [ 0 ] ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Недоступно в данный момент." ) ;

	if ( p_info [ params [ 0 ] ] [ family_invite ] )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный игрок отключил приглашение о приёме в семью." ) ;
		
		new scm_string [ 62 + MAX_PLAYER_NAME ] ;
		format ( scm_string, sizeof scm_string, "{"#cRInfo"}* {"#cGRInfo"}%s пытался пригласить Вас в семью.", p_info [ playerid ] [ name ] ) ;
		SendClientMessage ( params [ 0 ], col_gray, scm_string ) ;
		SendClientMessage ( params [ 0 ], col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас выключено приглашение в семью. Включить его можно в /mm - Настройки." ) ;
		return 1 ;
	}
	if ( p_info [ params [ 0 ] ] [ family ] > 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок уже состоит в семье." ) ;
	if ( fam_bl_info [ params [ 0 ] ] [ bl_onFrac ] [ _family_id ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете принять игрока из чёрного списка семьи." ) ;
	if ( ! player_rp_name [ params [ 0 ] ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока nonRP Nick_Name." ) ;
	if ( cooldown_sentence [ playerid ] > gettime ( ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Предложение о сделке можно отправлять один раз в {"#cRD"}45 секунд{"#cGRInfo"}." ) ;

    new _t_string [ 138 ];
    format(_t_string,sizeof(_t_string),"{"#cGInfo"}* {"#cWH"}Вы пригласили {"#cGN"}%s {"#cWH"}присоединиться к семье %s",p_info [ params [ 0 ] ] [ name ], family_info [ _family_id - 1 ] [ fam_name ] ) ;
    SendClientMessage ( playerid, col_white, _t_string ) ;

    format ( _t_string, sizeof ( _t_string ),"{FFFFFF}%s приглашает вас присоединиться к семье %s.\n\n{"#cBL"}Вы согласны присоединиться?", p_info [ playerid ] [ name ], family_info [ _family_id - 1 ] [ fam_name ] ) ;
    show_dialog ( params [ 0 ], d_family_invite, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приглашение в семью", _t_string, "Да", "Нет" ) ;
	
    cooldown_sentence [ playerid ] = gettime ( ) + time_sell_sentence ;
		
	buyer_id [ playerid ] = params [ 0 ] ;
	sell_item [ playerid ] = _family_id ;
	seller_id [ params [ 0 ] ] = playerid ;
	
	sell_time { playerid } =
	sell_time { params [ 0 ] } = time_sell_null ;
    return 1 ;
}

CMD:famuninvite ( playerid, params [ ] )
{
    if ( p_info [ playerid ] [ family ]  < 1 )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
	
	new family_id = p_info [ playerid ] [ family ] ;
	if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 1 ] )
	{
	    static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Команда доступна со статуса %s (%d)." ;
	    new scm_string [ sizeof _str + 30 + 3 ] ;
	    format ( scm_string, sizeof scm_string, _str, family_rank [ family_id - 1 ] [ family_info [ family_id - 1 ] [ fam_settings ] [ 1 ] - 1 ], family_info [ family_id - 1 ] [ fam_settings ] [ 1 ] ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return 1 ;
	}
    if ( sscanf(params, "us[32]", params [ 0 ], params [ 1 ] ) )return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /famuninvite [id] [причина]" ) ;

 	if ( ! IsPlayerConnected ( params [ 0 ] ) )
	 	return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
	if ( params [ 0 ] == playerid )
		return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете применить это к самому себе." ) ;
    if ( p_info [ params [ 0 ] ] [ family ] != family_id )
		return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не состоит в Вашей семье." ) ;
    if ( p_info [ params [ 0 ] ] [ family_rang ]  >= p_info [ playerid ] [ family_rang ] )
		return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете уволить своё руководство." ) ;
    if ( strlen ( params [ 1 ] ) < 3 || strlen ( params [ 1 ] ) > 32 )
		return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Причина должна содержать от 3 до 32 символов." ) ;
	if ( is_text_invalid ( params [ 1 ] ) )
		return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Причина содержит некорректные символы." ) ;

    new _t_string [ 150 ];
    format ( _t_string, sizeof ( _t_string ), "{"#cGInfo"}* {"#cWH"}Вы выгнали {"#cGN"}%s {"#cWH"}из семьи %s", p_info [ params [ 0 ] ] [ name ], family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_name ] ) ;
    SendClientMessage ( playerid, col_white, _t_string ) ;

	format(_t_string,sizeof(_t_string),"{%s}[FAM] %s %s[%d] выгнал(а) из семьи %s[%i]! Причина: %s",
	family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, p_info [ params [ 0 ] ] [ name ], params [ 0 ], params [ 1 ] ) ;
	family_message ( family_id, col_gray, _t_string ) ;

    Iter_Remove(family_players[family_id], params [ 0 ]) ;

	new _f_warn = p_info [ params [ 0 ] ] [ fam_warning ] ;
	p_info [ params [ 0 ] ] [ family ] =
	p_info [ params [ 0 ] ] [ family_rang ] = 
	p_info [ params [ 0 ] ] [ famblock ] = 
	p_info [ params [ 0 ] ] [ fam_warning ] = 0 ;

	if ( p_info [ params [ 0 ] ] [ family_text ] != Text3D:INVALID_3DTEXT_ID )
	{
		DestroyDynamic3DTextLabel ( p_info [ params [ 0 ] ] [ family_text ] ) ;
		p_info [ params [ 0 ] ] [ family_text ] = Text3D:INVALID_3DTEXT_ID ;
	}

	format ( _t_string, sizeof ( _t_string ), "UPDATE `users` SET `u_family` = '0', `u_family_rank` = '0', `u_fam_warning` = '0', `u_famblock` = '0' WHERE `u_id` = '%d' LIMIT 1", p_info [ params [ 0 ] ] [ id ] ) ;
	mysql_tquery ( sql_connection, _t_string ) ;
	
	family_info [ family_id - 1 ] [ fam_members ] -- ;
	format ( _t_string, sizeof ( _t_string ), "UPDATE `family` SET `fam_members` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_members ], family_id ) ;
	mysql_tquery(sql_connection, _t_string ) ;
	
	format ( _t_string, 128, "DELETE FROM `family_warns` WHERE `f_u_id` = '%d' LIMIT %d", p_info [ params [ 0 ] ] [ id ], _f_warn ) ;
	mysql_tquery ( sql_connection, _t_string ) ;

    format ( _t_string, 128, "%s выгнал(а) из семьи %s. Причина: %s", p_info [ playerid ] [ name ], p_info [ params [ 0 ] ] [ name ], params [ 1 ] ) ;
	write_family ( playerid, family_id, TYPE_LOG_UVAL, _t_string ) ;

	#if defined m_binders
		update_packet_binds ( params [ 0 ] ) ;
	#endif
    return 1 ;
}

CMD:famwarn ( playerid, params [ ] )
{
 	if ( p_info [ playerid ] [ family ]  < 1 )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
	
	new family_id = p_info [ playerid ] [ family ] ;
	if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 8 ] )
	{
	    static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Команда доступна со статуса %s (%d)." ;
	    new scm_string [ sizeof _str + 30 + 3 ] ;
	    format ( scm_string, sizeof scm_string, _str, family_rank [ family_id - 1 ] [ family_info [ family_id - 1 ] [ fam_settings ] [ 8 ] - 1 ], family_info [ family_id - 1 ] [ fam_settings ] [ 8 ] ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return 1 ;
	}
	
	new targetid, _fwarn_str [ 32 ] ;
	if ( sscanf ( params, "us[32]", targetid, _fwarn_str ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /famwarn [ид/имя] [причина]" ) ;
	if ( ! IsPlayerConnected ( targetid )  || targetid == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
	if ( p_info [ targetid ] [ family ] != family_id ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не состоит в Вашей семье." ) ;
	if ( p_info [ targetid ] [ family_rang ] >= p_info [ playerid ] [ family_rang ] && family_info [ family_id - 1 ] [ fam_rank_warn ] == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете дать выговор своему руководству." ) ;
	if ( strlen ( _fwarn_str ) < 3 || strlen ( _fwarn_str ) > 32 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Причина должна содержать от 3 до 32 символов." ) ;
	if ( is_text_invalid ( _fwarn_str ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Причина содержит некорректные символы." ) ;
	if ( p_info [ targetid ] [ family_rang ] >= family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете выдать выговор лидеру." ) ;
	if ( check_advertise ( playerid, params [ 1 ], report_type_famwarn ) ) return 1 ;

	p_info [ targetid ] [ fam_warning ] ++ ;
	if ( p_info [ targetid ] [ fam_warning ] >= family_info [ family_id - 1 ] [ fam_max_warn ] )
	{
		new _t_string [ 150 ] ;
		format(_t_string,sizeof(_t_string),"{%s}[FAM] %s %s[%d] выгнал(а) из семьи %s[%i]! Причина: %s",
		family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, p_info [ targetid ] [ name ], targetid, _fwarn_str ) ;
		family_message ( family_id, col_gray, _t_string ) ;

		Iter_Remove(family_players[family_id], targetid) ;

		new _f_warn = p_info [ targetid ] [ fam_warning ] ;
		p_info [ targetid ] [ family ] =
		p_info [ targetid ] [ family_rang ] = 
		p_info [ targetid ] [ famblock ] = 
		p_info [ targetid ] [ fam_warning ] = 0 ;

		if ( p_info [ targetid ] [ family_text ] != Text3D:INVALID_3DTEXT_ID )
		{
			DestroyDynamic3DTextLabel ( p_info [ targetid ] [ family_text ] ) ;
			p_info [ targetid ] [ family_text ] = Text3D:INVALID_3DTEXT_ID ;
		}

		format ( _t_string, sizeof ( _t_string ), "UPDATE `users` SET `u_family` = '0', `u_family_rank` = '0', `u_fam_warning` = '0', `u_famblock` = '0' WHERE `u_id` = '%d' LIMIT 1", p_info [ targetid ] [ id ] ) ;
		mysql_tquery ( sql_connection, _t_string ) ;
		
		family_info [ family_id - 1 ] [ fam_members ] -- ;
		format ( _t_string, sizeof ( _t_string ), "UPDATE `family` SET `fam_members` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_members ], family_id ) ;
		mysql_tquery(sql_connection, _t_string ) ;
		
		format ( _t_string, 128, "DELETE FROM `family_warns` WHERE `f_u_id` = '%d' LIMIT %d", p_info [ targetid ] [ id ], _f_warn ) ;
		mysql_tquery ( sql_connection, _t_string ) ;

		format ( _t_string, 128, "%s выгнал(а) из семьи %s. Причина: %s", p_info [ playerid ] [ name ], p_info [ targetid ] [ name ], _fwarn_str ) ;
		write_family ( playerid, family_id, TYPE_LOG_UVAL, _t_string ) ;
	}
	else
	{
		new _t_string [ 150 ] ;
		format(_t_string,sizeof(_t_string),"{%s}[FAM] %s %s[%d] выдал(а) выговор %s[%i]! Причина: %s",
		family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, p_info [ targetid ] [ name ], targetid, _fwarn_str ) ;
		family_message ( family_id, col_gray, _t_string ) ;

	    format ( _t_string, sizeof _t_string, "INSERT INTO `family_warns` (`f_date`,`f_reason`,`f_u_id`,`to_f_name`) VALUES (NOW(),'%s','%d','%s')",
		_fwarn_str, p_info [ targetid ] [ id ], p_info [ playerid ] [ name ] ) ;
		mysql_tquery ( sql_connection, _t_string ) ;

		format ( _t_string, 128, "%s выдал(а) выговор %s (%d/%d). Причина: %s", p_info [ playerid ] [ name ], p_info [ targetid ] [ name ], p_info [ targetid ] [ fam_warning ], family_info [ family_id - 1 ] [ fam_max_warn ], _fwarn_str ) ;
		write_family ( playerid, family_id, TYPE_LOG_WARN, _t_string ) ;

		update_int_sql ( targetid, "u_fam_warning", p_info [ targetid ] [ fam_warning ] ) ;
	}

	#if defined m_binders
	    update_packet_binds ( targetid ) ;
	#endif
    return 1 ;
}

CMD:famunwarn ( playerid, params [ ] )
{
 	if ( p_info [ playerid ] [ family ]  < 1 )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
	
	new family_id = p_info [ playerid ] [ family ] ;
	if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 8 ] )
	{
	    static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Команда доступна со статуса %s (%d)." ;
	    new scm_string [ sizeof _str + 30 + 3 ] ;
	    format ( scm_string, sizeof scm_string, _str, family_rank [ family_id - 1 ] [ family_info [ family_id - 1 ] [ fam_settings ] [ 8 ] - 1 ], family_info [ family_id - 1 ] [ fam_settings ] [ 8 ] ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return 1 ;
	}
	
	if ( sscanf ( params, "u", params [ 0 ] ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /famunwarn [ид/имя]" ) ;
	if ( ! IsPlayerConnected ( params [ 0 ] )  || params [ 0 ] == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
	if ( p_info [ params [ 0 ] ] [ family ] != family_id ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не состоит в Вашей семье." ) ;
	if ( p_info [ params [ 0 ] ] [ family_rang ]  >= p_info [ playerid ] [ family_rang ] && family_info [ family_id - 1 ] [ fam_rank_warn ] == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете снять выговор своему руководству." ) ;
	if ( p_info [ params [ 0 ] ] [ fam_warning ] == 0 )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока нет выговоров." ) ;

    buyer_id [ playerid ] = params [ 0 ] ;

	static const _str [ ] = "SELECT * FROM `family_warns` WHERE `f_u_id` = '%d' LIMIT %d" ;
	new scm_string [ sizeof _str + 9 ] ;
	format ( scm_string, sizeof scm_string, _str, p_info [ params [ 0 ] ] [ id ], family_info [ family_id - 1 ] [ fam_max_warn ] ) ;
	mysql_tquery ( sql_connection, scm_string, "FamilyWarns", "i", playerid ) ;
    return 1 ;
}

CMD:famblock ( playerid, params [ ] )
{
    if ( p_info [ playerid ] [ family ]  < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
	
	new _family_id = p_info [ playerid ] [ family ] ;
	if ( p_info [ playerid ] [ family_rang ] < family_info [ _family_id - 1 ] [ fam_settings ] [ 0 ] )
	{
	    static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Команда доступна со статуса %s (%d)." ;
	    new scm_string [ sizeof _str + 30 + 3 ] ;
	    format ( scm_string, sizeof scm_string, _str, family_rank [ _family_id - 1 ] [ family_info [ _family_id - 1 ] [ fam_settings ] [ 0 ] - 1 ], family_info [ _family_id - 1 ] [ fam_settings ] [ 0 ] ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return 1 ;
	}
	
	if ( sscanf ( params, "us[32]", params [ 0 ], params [ 1 ] ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /famblock [ид/имя] [причина]" ) ;
	if ( ! IsPlayerConnected ( params [ 0 ] )  || params [ 0 ] == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
	if ( p_info [ params [ 0 ] ] [ family ] != _family_id ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не состоит в Вашей семье." ) ;
	if ( p_info [ params [ 0 ] ] [ family_rang ] >= p_info [ playerid ] [ family_rang ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете дать запрет своему руководству." ) ;
	if ( p_info [ params [ 0 ] ] [ famblock ] > 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока уже имеется запрет на участие в войнах." ) ;

	p_info [ params [ 0 ] ] [ famblock ] = 1 ;
	update_int_sql ( params [ 0 ], "u_famblock", 1 ) ;

	new _t_string [ 150 ] ;
	format(_t_string,sizeof(_t_string),"{%s}[FAM] %s %s[%d] выдал(а) запрет на участие в войнах %s. Причина: %s",
	family_info [ _family_id - 1 ] [ fam_chat_color ], family_rank [ _family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, p_info [ params [ 0 ] ] [ name ], params [ 0 ], params [ 1 ] ) ;
	family_message ( _family_id, col_gray, _t_string ) ;
	return 1 ;
}

CMD:unfamblock ( playerid, params [ ] )
{
    if ( p_info [ playerid ] [ family ]  < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
	
	new _family_id = p_info [ playerid ] [ family ] ;
	if ( p_info [ playerid ] [ family_rang ] < family_info [ _family_id - 1 ] [ fam_settings ] [ 0 ] )
	{
	    static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Команда доступна со статуса %s (%d)." ;
	    new scm_string [ sizeof _str + 30 + 3 ] ;
	    format ( scm_string, sizeof scm_string, _str, family_rank [ _family_id - 1 ] [ family_info [ _family_id - 1 ] [ fam_settings ] [ 0 ] - 1 ], family_info [ _family_id - 1 ] [ fam_settings ] [ 0 ] ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return 1 ;
	}
	if ( sscanf ( params, "u", params [ 0 ] ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /famblock [ид/имя]" ) ;
	if ( ! IsPlayerConnected ( params [ 0 ] )  || params [ 0 ] == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
	if ( p_info [ params [ 0 ] ] [ family ] != _family_id ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не состоит в Вашей семье." ) ;
	if ( p_info [ params [ 0 ] ] [ famblock ] == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока нету запрета на участие в войнах." ) ;

	p_info [ params [ 0 ] ] [ famblock ] = 0 ;
	update_int_sql ( params [ 0 ], "u_famblock", 0 ) ;

	new _t_string [ 150 ] ;
	format(_t_string,sizeof(_t_string),"{%s}[FAM] %s %s[%d] снял(а) запрет на участие в войнах с %s.",
	family_info [ _family_id - 1 ] [ fam_chat_color ], family_rank [ _family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, p_info [ params [ 0 ] ] [ name ], params [ 0 ] ) ;
	family_message ( _family_id, col_gray, _t_string ) ;
	return 1 ;
}

callback: FamilyWarns ( playerid )
{
    global_string [ 0 ] = EOS ;
    new line_string [ 128 ], warn_id ;

    new rows, fields ;
    cache_get_data ( rows, fields ) ;
	strcat ( global_string, "{"#cBL"}Выдал(а):\t{"#cBL"}Дата:\t{"#cBL"}Причина:\n" ) ;
	for ( new i = 0 ; i < rows ; i ++ )
	{
        new f_date [ 32 ], f_reason [ 32 ], to_f_name [ 32 ] ;
        warn_id = cache_get_field_content_int ( i, "f_id", sql_connection ) ;
        cache_get_field_content ( i, "f_date", f_date, sql_connection, MAX_PLAYER_NAME ) ;
        cache_get_field_content ( i, "f_reason", f_reason, sql_connection, 32 ) ;
        cache_get_field_content ( i, "to_f_name", to_f_name, sql_connection, 32 ) ;

		set_player_listitem_values ( playerid, i, warn_id ) ;

        format ( line_string, sizeof line_string, "%s\t%s\t%s\n", to_f_name, f_date, f_reason ) ;
        strcat ( global_string, line_string ) ;

        show_dialog ( playerid, d_family_warn, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Выговоры члена семьи", global_string, "Снять", "Закрыть" ) ;
    }
	return 1;
}

CMD:famrank ( playerid, params [ ] )
{
    if ( p_info [ playerid ] [ family ]  < 1 ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье.");
	
	new family_id = p_info [ playerid ] [ family ] ;
	if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 2 ] )
	{
	    static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Команда доступна со статуса %s (%d)." ;
	    new scm_string [ sizeof _str + 30 + 3 ] ;
	    format ( scm_string, sizeof scm_string, _str, family_rank [ family_id - 1 ] [ family_info [ family_id - 1 ] [ fam_settings ] [ 2 ] - 1 ], family_info [ family_id - 1 ] [ fam_settings ] [ 2 ] ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return 1 ;
	}
	if ( sscanf ( params, "u", params [ 0 ] ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /famrank [ид/имя]" ) ;
	if ( ! IsPlayerConnected ( params [ 0 ] )  || params [ 0 ] == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
	if ( p_info [ params [ 0 ] ] [ family ] != family_id ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не состоит в Вашей семье." ) ;

	global_string [ 0 ] = EOS ;
	new line_string [ 72 ] ;
	for ( new i = 0; i < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] ; i ++ )
	{
		format ( line_string, 72, "{"#cGRDialog"}%i. {"#cWH"}%s\n", i + 1, family_rank [ family_id - 1 ] [ i ] ) ;
		strcat ( global_string, line_string ) ;
	}
	show_dialog ( playerid, d_family_rank, DIALOG_STYLE_LIST, "{"#cBHD"}Семейный статус", global_string, "Выбрать", "Назад" ) ;

	buyer_id [ playerid ] = params [ 0 ] ;
	return 1 ;
}

CMD:famlock ( playerid )
{
	if ( p_info [ playerid ] [ family ]  < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
	
	new family_id = p_info [ playerid ] [ family ] ;
	if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 6 ] )
	{
	    static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Команда доступна со статуса %s (%d)." ;
	    new scm_string [ sizeof _str + 30 + 3 ] ;
	    format ( scm_string, sizeof scm_string, _str, family_rank [ family_id - 1 ] [ family_info [ family_id - 1 ] [ fam_settings ] [ 6 ] - 1 ], family_info [ family_id - 1 ] [ fam_settings ] [ 6 ] ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return 1 ;
	}

	new sql_string [ 128 ] ;
	if ( family_info [ family_id - 1 ] [ fam_dorm_status ] )
	{
		family_info [ family_id - 1 ] [ fam_dorm_status ] = 0 ;
		format ( sql_string, sizeof ( sql_string ), "UPDATE `family` SET `fam_dorm_status` = '%d' WHERE `fam_id` = '%d' LIMIT 1",
		family_info [ family_id - 1 ] [ fam_dorm_status ], family_id ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
		GameTextForPlayer ( playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~g~ DORM UNLOCKED", 3000, 3 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Склад успешно {"#cGN"}открыт{"#cWH"}." ) ;

		format(sql_string, sizeof ( sql_string ), "{%s}[FAM] %s %s открыл(а) склад.", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ] ) ;
    	family_message ( family_id, col_gray, sql_string ) ;
	}
	else
	{
		family_info [ family_id - 1 ] [ fam_dorm_status ] = 1 ;
		format ( sql_string, sizeof ( sql_string ), "UPDATE `family` SET `fam_dorm_status` = '%d' WHERE `fam_id` = '%d' LIMIT 1",
		family_info [ family_id - 1 ] [ fam_dorm_status ], family_id ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
		GameTextForPlayer ( playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~r~ DORM LOCKED", 3000, 3 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Склад успешно {"#cGN"}закрыт{"#cWH"}." ) ;

    	format(sql_string, sizeof ( sql_string ), "{%s}[FAM] %s %s закрыл(а) склад.", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ] ) ;
    	family_message ( family_id, col_gray, sql_string ) ;

	}

	return 1 ;
}

stock show_family_quest ( playerid )
{
	show_dialog ( playerid, d_family_quest, DIALOG_STYLE_LIST, "{"#cBHD"}Семейные задания", "{"#cBL"}1. {"#cWH"}Ежедневные задания\n{"#cBL"}2. {"#cWH"}Кража деталей\n{"#cBL"}3. {"#cWH"}Задание на семью", "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock used_family_quest ( playerid )
{
	if ( p_info [ playerid ] [ family_quest ] == -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже выполняли задание." ) ;
	
	static const _quest_progress [ ] =
	{
		10,
		20,
		1,
		1,
		10,
		50,
		100,
		1
	} ;
	
	if ( ! p_info [ playerid ] [ family_quest ] || p_info [ playerid ] [ family_quest ] && p_info [ playerid ] [ family_quest_progress ] < _quest_progress [ p_info [ playerid ] [ family_quest ] - 1 ] )
	{
	    if ( ! p_info [ playerid ] [ family_quest ] )
		{
			p_info [ playerid ] [ family_quest ] = random ( 8 ) + 1 ;
	    	p_info [ playerid ] [ family_quest_progress ] = 0 ;
			
			new sql_string [ 106 + 4 + 9 ] ;
			format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_family_quest` = '%d', `u_family_quest_progress` = '0' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ family_quest ], p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
	    
		new dialog_string [ 200 ], _quest_id = p_info [ playerid ] [ family_quest ] ;
		format ( dialog_string, sizeof dialog_string, "{"#cGRDialog"}Задание:\n{"#cWH"}%s\n\n{"#cGRDialog"}Награда: {"#cWH"}%s\n{"#cGRDialog"}Прогресс: {"#cWH"}%d из %d", 
		quest_family_info [ _quest_id - 1 ] [ q_text ], quest_family_info [ _quest_id - 1 ] [ q_rewards ],
		p_info [ playerid ] [ family_quest_progress ], _quest_progress [ _quest_id - 1 ] ) ;
	    show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Задание", dialog_string, "Закрыть", "" ) ;
	    
	    if ( _quest_id == 4 )
	    {
			if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"} У Вас уже есть т/с." ) ;
		
            SetPlayerRaceCheckpoint ( playerid, 1, fam_con_gps [ 0 ] [ 0 ], fam_con_gps [ 0 ] [ 1 ], fam_con_gps [ 0 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;
				
			p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 482, fam_con_buritto [ 0 ], fam_con_buritto [ 1 ], fam_con_buritto [ 2 ], fam_con_buritto [ 3 ], 1, 1, -1 ) ;

	        new engine, lights, alarm, doors, bonnet, boot, objective, _veh_id = p_t_info [ playerid ] [ pl_quest ] ;
			veh_info [ _veh_id - 1 ] [ v_locked ] = false ;
			GetVehicleParamsEx ( _veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
			SetVehicleParamsEx ( _veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;

			veh_info [ _veh_id - 1 ] [ v_fuel ] = 60.0 ;
			PutPlayerInVehicle ( playerid, _veh_id, 0 ) ;
			SetPlayerArmedWeapon ( playerid, 0 ) ;

			SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Не покидайте транспорт. Место отмечено у Вас на карте." ) ;

			toggle_engine ( playerid, _veh_id ) ;
			toggle_lights ( playerid, _veh_id ) ;
	    }
	}
	else
	{
	    new family_id = p_info [ playerid ] [ family ], text_string [ 144 ], _quest_id = p_info [ playerid ] [ family_quest ] ;
	    if ( p_info [ playerid ] [ family_quest_progress ] >= _quest_progress [ _quest_id - 1 ] )
	    {
	        format ( text_string, sizeof text_string, "{%s}[FAM] %s выполнил(а) задание. Награда: %d"valute_title_" и %d "family_title".", family_info [ family_id - 1 ] [ fam_chat_color ], p_info [ playerid ] [ name ], family_rewards [ _quest_id - 1 ] [ r_money ], family_rewards [ _quest_id - 1 ] [ r_exp ] ) ;
			family_message ( family_id, col_gray, text_string ) ;
				
			give_money ( playerid, family_rewards [ _quest_id - 1 ] [ r_money ] ) ;
           	insert_money_log ( playerid, INVALID_PLAYER_ID, family_rewards [ _quest_id - 1 ] [ r_money ], "семейный квест" ) ;
				
			family_info [ family_id - 1 ] [ fam_rating ] += 5 ;
			family_info [ family_id - 1 ] [ fam_ticket ] += family_rewards [ _quest_id - 1 ] [ r_exp ] ;
			
			give_all_family_quest ( family_id, 5, 1 ) ;
			give_all_family_quest ( family_id, 6, 5 ) ;
			give_all_family_quest ( family_id, 7, 5 ) ;
			give_all_family_quest ( family_id, 8, 5 ) ;
				
			p_info [ playerid ] [ family_quest ] = -1 ;
			update_int_sql ( playerid, "u_family_quest", -1 ) ;
				
			give_event_progress ( playerid, THE_FAMILY_QUEST, 1 ) ;
			checking_quest_progress ( playerid, 2, 1, quest_line_high ) ;
	    }
	}
	return 1 ;
}

CMD:famrobbery ( playerid )
{
	if ( cop_player ( playerid ) || fbi_player ( playerid ) || army_player ( playerid ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нельзя грабить бизнес состоя в гос. организации." ) ;
	if ( p_info [ playerid ] [ family ] < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
	
	new _fam_id = p_info [ playerid ] [ family ] ;
	if ( family_info [ _fam_id - 1 ] [ fam_quest ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи нет активного задания на ограбление." ) ;
	
	if ( p_info [ playerid ] [ robbery_coldown ] > 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже совершали ограбление." ) ;
	
	new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
	if ( _b_id < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны находиться в бизнесе." ) ;
	if ( b_info [ _b_id - 1 ] [ b_robbery ] > 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный бизнес не так давно уже грабили." ) ;
    if ( b_info [ _b_id - 1 ] [ b_cash_today ] < 100000 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В бизнесе недостаточно дневной выручки." ) ;

	new _team_count = 1 ;
	foreach(new i: streamed_players[playerid])
	{
		if ( cop_player ( i ) || fbi_player ( i ) || army_player ( i ) ) continue ;
	    if ( p_info [ playerid ] [ family ] != p_info [ i ] [ family ] ) continue ;
	    if ( p_info [ i ] [ robbery_coldown ] > 0 ) continue ;
 		if ( IsPlayerInRangeOfPoint ( playerid, 20, p_t_info [ i ] [ p_pos ] [ 0 ], p_t_info [ i ] [ p_pos ] [ 1 ], p_t_info [ i ] [ p_pos ] [ 2 ] ) && GetPlayerVirtualWorld ( i ) == GetPlayerVirtualWorld ( playerid ) )
	    {
			_team_count ++ ;
			if ( _team_count == player_robbery ) break ;
		}
	}
	if ( _team_count < player_robbery )
	{
	    static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Для начала ограбления должно быть {"#cRD"}%d{"#cGRInfo"} человек(а) включая Вас." ;
	    new scm_string [ sizeof _str + 4 ] ;
	    format ( scm_string, sizeof scm_string, _str, player_robbery ) ;
		SendClientMessage ( playerid, col_gray, scm_string ) ;
		return 1 ;
	}

	_team_count = 0 ;
	foreach(new i: streamed_players[playerid])
	{
	    if ( ! gang_player ( i ) ) continue ;
	    if ( p_info [ i ] [ robbery_coldown ] > 0 ) continue ;
 		if ( IsPlayerInRangeOfPoint ( playerid, 20, p_t_info [ i ] [ p_pos ] [ 0 ], p_t_info [ i ] [ p_pos ] [ 1 ], p_t_info [ i ] [ p_pos ] [ 2 ] ) && GetPlayerVirtualWorld ( i ) == GetPlayerVirtualWorld ( playerid ) )
	    {
	        if ( p_info [ playerid ] [ family ] == p_info [ i ] [ family ] )
		    {
				_team_count ++ ;

				SendClientMessage ( i, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Ограбление началось. Ваша задача: не умереть и не покидать бизнес." ) ;
				SendClientMessage ( i, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы можете закончить ограбление раньше, просто покиньте бизнес." ) ;

				p_info [ i ] [ robbery_stop ] = 0 ;

                p_info [ i ] [ robbery_business ] = _b_id ;

				SetPlayerAttachedObject ( i, 1, 1550, 1,   0.160001, -0.234000, -0.009998, 1.100002, 95.899940, -17.500007  ) ;

				p_info [ i ] [ robbery_coldown ] = 3 ;
				update_int_sql ( i, "u_robbery_coldown", 3 ) ;

				if ( _team_count == player_robbery ) break ;
		    }
		}
	}
	SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Ограбление началось. Ваша задача: не умереть и не покидать бизнес." ) ;
	SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы можете закончить ограбление раньше, просто покиньте бизнес." ) ;

	p_info [ playerid ] [ robbery_stop ] = 0 ;

	SetPlayerAttachedObject ( playerid, 1, 1550, 1,   0.160001, -0.234000, -0.009998, 1.100002, 95.899940, -17.500007  ) ;

	p_info [ playerid ] [ robbery_coldown ] = 3 ;
	update_int_sql ( playerid, "u_robbery_coldown", 3 ) ;

	give_all_family_quest ( _fam_id, 1, 3 ) ;
	b_info [ _b_id - 1 ] [ b_robbery ] = 4 ;
	p_info [ playerid ] [ robbery_business ] = _b_id ;

	static const _str [ ] = "UPDATE `businesses` SET `b_robbery` = '%d' WHERE `b_id` = '%d' LIMIT 1" ;
	new _sql_string [ sizeof _str + 4 + 9 ] ;
	format ( _sql_string, sizeof _sql_string, _str, b_info [ _b_id - 1 ] [ b_robbery ], b_info [ _b_id - 1 ] [ b_id ] ) ;
	mysql_tquery ( sql_connection, _sql_string ) ;
	return 1 ;
}

new all_family_quest [ MAX_QUESTS ] [ qinfo_ ] =
{
	{ "Ограбление", "Ограбьте бизнесы 70 раз. (/famrobbery)", "15.000.000"valute_title_" + 50 "family_title"" },
	{ "Контейнер", "Захватите посылку 36 раз.", "20.000.000"valute_title_" + 75 "family_title"" },
	{ "Поставка", "Захватите поставку 42 раз.", "20.000.000"valute_title_" + 75 "family_title"" },
	{ "Рыбацкое дело", "Поймате 5.000 кг рыбы.", "40.000.000"valute_title_" + 150 "family_title"" },
	{ "Выгодное дело", "Выполните 100 семейных заданий.", "15.000.000"valute_title_" + 30 "family_title"" },
	{ "Рейтинг", "Заработайте 500 рейтинга.", "50.000.000"valute_title_" + 200 "family_title"" },
	{ "Рейтинг", "Заработайте 400 рейтинга.", "40.000.000"valute_title_" + 150 "family_title"" },
	{ "Рейтинг", "Заработайте 300 рейтинга.", "30.000.000"valute_title_" + 100 "family_title"" }
} ;

new all_family_rewards [ MAX_QUESTS ] [ rinfo_ ] =
{
	{ 1500000, 50 },
	{ 2000000, 75 },
	{ 2000000, 75 },
	{ 4000000, 150 },
	{ 1500000, 30 },
	{ 5000000, 200 },
	{ 4000000, 150 },
	{ 3000000, 100 }
} ;

stock give_all_family_quest ( _fam_id, _quest_id, _progress )
{
	if ( _fam_id < 1 ) return 1 ;
	if ( family_info [ _fam_id - 1 ] [ fam_quest ] != _quest_id ) return 1 ;
	
	static const _quest_progress [ ] =
	{
		70,
		36,
		42,
		5000,
		100,
		500,
		400,
		300
	} ;
	
	new text_string [ 80 + ( 9 * 2 ) ] ;
	if ( family_info [ _fam_id - 1 ] [ fam_quest_progress ] < _quest_progress [ _quest_id - 1 ] )
	{
	    family_info [ _fam_id - 1 ] [ fam_quest_progress ] += _progress ;
			
		format ( text_string, sizeof text_string, "UPDATE `family` SET `fam_quest_progress` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_quest_progress ], family_info [ _fam_id - 1 ] [ fam_id ] ) ;
		mysql_tquery ( sql_connection, text_string ) ;
	}
	return 1 ;
}

stock clear_week_family_quest ( )
{
	new sql_string [ 99 + 4 + 9 ] ;
	for ( new i = 0 ; i < family_count ; i ++ )
	{
		family_info [ i ] [ fam_quest ] = random ( 8 ) + 1 ;
	   	family_info [ i ] [ fam_quest_progress ] = 0 ;

		sql_string [ 0 ] = EOS ;
		format ( sql_string, sizeof sql_string, "UPDATE `family` SET `fam_quest` = '%d', `fam_quest_progress` = '0' WHERE `fam_id` = '%d' LIMIT 1", family_info [ i ] [ fam_quest ], family_info [ i ] [ fam_id ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	return 1 ;
}

stock show_all_family_quest ( playerid )
{
	new _fam_id = p_info [ playerid ] [ family ] ;
	if ( family_info [ _fam_id - 1 ] [ fam_quest ] == -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваша семья уже выполнила задание." ) ;
	
	static const _quest_progress [ ] =
	{
		70,
		36,
		42,
		5000,
		100,
		500,
		400,
		300
	} ;
	
	if ( ! family_info [ _fam_id - 1 ] [ fam_quest ] || family_info [ _fam_id - 1 ] [ fam_quest ] && family_info [ _fam_id - 1 ] [ fam_quest_progress ] < _quest_progress [ family_info [ _fam_id - 1 ] [ fam_quest ] - 1 ] )
	{
	    if ( ! family_info [ _fam_id - 1 ] [ fam_quest ] )
		{
			family_info [ _fam_id - 1 ] [ fam_quest ] = random ( 8 ) + 1 ;
	    	family_info [ _fam_id - 1 ] [ fam_quest_progress ] = 0 ;
			
			new sql_string [ 99 + 4 + 9 ] ;
			format ( sql_string, sizeof sql_string, "UPDATE `family` SET `fam_quest` = '%d', `fam_quest_progress` = '0' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_quest ], family_info [ _fam_id - 1 ] [ fam_id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
	    
		global_string [ 0 ] = EOS ;
		new _quest_id = family_info [ _fam_id - 1 ] [ fam_quest ] ;
		format ( global_string, 356, "{"#cGRDialog"}Задание:\n{"#cWH"}%s\n\n{"#cGRDialog"}Награда: {"#cWH"}%s\n{"#cGRDialog"}Прогресс: {"#cWH"}%d из %d\n\n{"#cBL"}* {"#cWH"}Задание даётся на всю семью.\n{"#cBL"}* {"#cWH"}Задание обновляется раз в неделю.", 
		all_family_quest [ _quest_id - 1 ] [ q_text ], all_family_quest [ _quest_id - 1 ] [ q_rewards ],
		family_info [ _fam_id - 1 ] [ fam_quest_progress ], _quest_progress [ _quest_id - 1 ] ) ;
	    show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Задание", global_string, "Закрыть", "" ) ;
	}
	else
	{
	    new text_string [ 144 ], _quest_id = family_info [ _fam_id - 1 ] [ fam_quest ] ;
	    if ( family_info [ _fam_id - 1 ] [ fam_quest_progress ] >= _quest_progress [ _quest_id - 1 ] )
	    {
	        format ( text_string, sizeof text_string, "{%s}[FAM] Ваша семья выполнила недельное задание. Награда: %d"valute_title_" и %d "family_title".", family_info [ _fam_id - 1 ] [ fam_chat_color ], all_family_rewards [ _quest_id - 1 ] [ r_money ], all_family_rewards [ _quest_id - 1 ] [ r_exp ] ) ;
			family_message ( _fam_id, col_gray, text_string ) ;
			
			family_info [ _fam_id - 1 ] [ fam_bank ] += all_family_rewards [ _quest_id - 1 ] [ r_money ] ;
			family_info [ _fam_id - 1 ] [ fam_rating ] += 5 ;
			family_info [ _fam_id - 1 ] [ fam_ticket ] += all_family_rewards [ _quest_id - 1 ] [ r_exp ] ;
				
			family_info [ _fam_id - 1 ] [ fam_quest ] = -1 ;
			
			format ( text_string, sizeof text_string, "UPDATE `family` SET `fam_quest` = '-1' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_id ] ) ;
			mysql_tquery ( sql_connection, text_string ) ;
	    }
	}
	return 1 ;
}

CMD:sellft ( playerid, params [ ] )
{
	if ( duel_opponent [ playerid ] != INVALID_PLAYER_ID ) return 1 ;
    if ( p_info [ playerid ] [ hour_played ] < 3 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре.");
	if ( ! p_info [ playerid ] [ family_ticket ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет "family_title"." ) ;
	if ( sscanf ( params, "ddd", params [ 0 ], params [ 1 ], params [ 2 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /sellft [id/имя] [количество] [цена]") ;
	if ( ! IsPlayerConnected ( params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
	if ( params [ 0 ] == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете применить это к самому себе." ) ;
	if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ params [ 0 ] ][ p_pos ] [ 0 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 1 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( params [ 0 ] ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;
	if ( ! bad_dialog ( params [ 0 ] ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Недоступно в данный момент.") ;

	if ( p_info [ playerid ] [ hour_played ] < 3 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре.");
	if ( p_info [ params [ 0 ] ] [ hour_played ] < 3 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не отыграл 3 часа.");
	if ( params [ 1 ] < 1 || params [ 1 ] > p_info [ playerid ] [ family_ticket ] )return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Не правильно указано количество талонов." ) ;
	if ( params [ 2 ] < 1 || params [ 2 ] > 100000000 )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Цена не может быть меньше {"#cRD"}1"valute_title_"{"#cGRInfo"} или больше {"#cRD"}100.000.000"valute_title_"" ) ;

	if ( GetString ( p_t_info [ params [ 0 ] ] [ p_ip ], p_t_info [ playerid ] [ p_ip ] ) )
	{
		new scm_string [ 128 ] ;
		format ( scm_string, sizeof ( scm_string ), "{"#cRAdmin"}[A] {"#cGRAdmin"}%s[%d] продает %d "family_title" %s[%d] за %d"valute_title_" | same ip", p_info [ playerid ] [ name ], playerid, params [ 1 ], p_info [ params [ 0 ] ] [ name ], params [ 0 ], params [ 2 ] ) ;
		foreach(new i: admin_players) SendClientMessage ( i, col_admin, scm_string ) ;

		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Невозможно продать "family_title" данному игроку." ) ;
		return 1 ;
	}

	buyer_id [ playerid ] = params [ 0 ] ;
	sell_price [ playerid ] = params [ 2 ] ;
	seller_id [ params [ 0 ] ] = playerid ;
	sell_type [ playerid ] = params [ 1 ] ;

	new dialog_string [ 90 + MAX_PLAYER_NAME + 32 + 1 + 6 ] ;
	format ( dialog_string, sizeof ( dialog_string ), "Вы предложили игроку {"#cBL"}%s{FFFFFF} приобрести {"#cBL"}%d "family_title"{FFFFFF} за {"#cBL"}%d"valute_title_"",
	p_info [ params [ 0 ] ] [ name ], params [ 1 ], params [ 2 ] ) ;
	SendClientMessage ( playerid, col_white, dialog_string ) ;
	
	format ( dialog_string, sizeof ( dialog_string  ), "{"#cBL"}%s {FFFFFF}предлагает Вам приобрести {"#cBL"}%d "family_title"{FFFFFF} за {"#cBL"}%d"valute_title_"",
	p_info [ playerid ] [ name ], params [ 1 ], params [ 2 ] ) ;
	show_dialog ( params [ 0 ], d_sellft_accept, DIALOG_STYLE_MSGBOX, "{"#cBHD"}"family_title"", dialog_string, "Принять", "Отмена" ) ;
	return 1 ;
}

stock family_message ( family_stk, color, text [ ] )
{
    foreach(new i: family_players[family_stk])
    {
        if ( ( p_info [ i ] [ family ] == family_stk ) && p_info [ i ] [ settings ] [ 5 ] != 0 ) SendClientMessage ( i, color, text ) ;
    }
    return 1 ;
}

callback:callback_familylist ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В архиве штата не найдено ни 1 семьи." ) ;
		show_dialog ( playerid, d_family_hall, DIALOG_STYLE_LIST, "{"#cBHD"}Архив", "{"#cGRDialog"}- {"#cWH"}Создать семью\n{"#cGRDialog"}- {"#cWH"}Переименовать семью\n{"#cGRDialog"}- {"#cWH"}Список семей", "Выбрать", "Закрыть" ) ;
		page_count [ playerid ] = 0 ;
		return 1 ;
	}
	new rows_list = page_count [ playerid ] - 1 ;
	page_rows [ playerid ] = rows ;
	new line_string [ 128 ],
		pl_f_name [ 68 ],
		pl_f_color [ 68 ] ;

	global_string [ 0 ] = EOS ;
	for ( new i = rows_list * 10 ; i <  rows_list * 10 + 10 ; i ++ )
	{
		if ( i >= rows ) break ;

		cache_get_field_content ( i, "fam_name", pl_f_name, sql_connection, 68 ) ;
		cache_get_field_content ( i, "fam_chat_color", pl_f_color, sql_connection, 68 ) ;

		format ( line_string, sizeof ( line_string ), "{"#cWH"}%d. {%s}%s\n", i + 1, pl_f_color, pl_f_name ) ;
		strcat ( global_string, line_string ) ;
	}

	show_dialog ( playerid, d_family_list, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Архив семей", global_string, "Назад", "Далее" ) ;
	return 1 ;
}

callback: check_family_vehicles ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	new _family_id = p_info [ playerid ] [ family ] ;
	if ( rows + 1 > family_info [ _family_id - 1 ] [ fam_max_car ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRDialog"}В Вашей семье максимальное количество машин." ) ;
		
	new scm_string [ 128 ], _veh_id = GetPlayerVehicleID ( playerid ) ;
	if ( _veh_id == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRDialog"}Вы должны находиться в т/с для передачи в семью." ) ;
	format ( scm_string, sizeof scm_string, "{"#cBInfo"}* {"#cWH"}Вы успешно передали {"#cBL"}%s {"#cWH"}во владения семьи.", GetVehicleNameEx ( _veh_id ) ) ;
	SendClientMessage ( playerid, col_white, scm_string ) ;
			
	format ( scm_string, sizeof ( scm_string ), "{%s}[FAM] %s %s[%i] передал(а) %s во владение семьи.", family_info [ _family_id - 1 ] [ fam_chat_color ], family_rank [ _family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, GetVehicleNameEx ( _veh_id ) ) ;
    family_message ( _family_id, col_gray, scm_string ) ;

	format ( scm_string, sizeof scm_string, "%s передал(а) %s во владение семьи (т/с)", p_info [ playerid ] [ name ], GetVehicleNameEx ( _veh_id ) ) ;
	write_family ( playerid, _family_id, TYPE_LOG_OBWYAK, scm_string ) ;

	veh_info [ _veh_id - 1 ] [ v_owner ] = _family_id ;

	new Float:X, Float:Y, Float:Z, Float:A, sql_string [ 400 ],
		engine, lights, alarm, doors, bonnet, boot, objective,
		_v_model ;
	GetVehiclePos ( _veh_id, X, Y, Z ) ;
	GetVehicleZAngle ( _veh_id, A ) ;
			
	Iter_Remove(player_vehicles[playerid], _veh_id);
			
	format ( sql_string, 100, "UPDATE `users_vehicles` SET `v_fine` = '2' WHERE `v_id` = '%d' LIMIT 1", veh_info [ _veh_id - 1 ] [ v_id ] ) ;
	mysql_tquery ( sql_connection, sql_string ) ;

   	veh_info [ _veh_id - 1 ] [ v_pos ] [ 0 ] = X ;
    veh_info [ _veh_id - 1 ] [ v_pos ] [ 1 ] = Y ;
    veh_info [ _veh_id - 1 ] [ v_pos ] [ 2 ] = Z ;
    veh_info [ _veh_id - 1 ] [ v_pos ] [ 3 ] = A ;
	veh_info [ _veh_id - 1 ] [ v_owner_fam ] = p_info [ playerid ] [ id ] ;

	veh_info [ _veh_id - 1 ] [ v_rank ] = 1 ;

	veh_info[ _veh_id - 1 ] [ v_type ] = vehicle_type_family ;

	veh_info [ _veh_id - 1 ] [ v_fuel ] = 60.0 ;

	veh_info [ _veh_id - 1 ] [ v_locked ] = false ;
	GetVehicleParamsEx ( _veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( _veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;

	veh_plate ( _veh_id ) ;

	if ( veh_info [ _veh_id - 1 ] [ v_model_custom ] != 0 ) _v_model = veh_info [ _veh_id - 1 ] [ v_model_custom ] ;
	else _v_model = veh_info [ _veh_id - 1 ] [ v_model ] ;

	mysql_format ( sql_connection, sql_string, sizeof sql_string, "INSERT INTO `familys_vehicles` (`sv_model`,`sv_owner`,`v_plate_type`,`v_plate`,`v_region`,`sv_pos_x`,`sv_pos_y`,`sv_pos_z`,`sv_pos_a`,`sv_type`,`sv_price`,`v_owner_fam`) VALUES ('%d','%d','%d','%e','%e','%f','%f','%f','%f','%d','%d','%d')",
	_v_model, veh_info [ _veh_id - 1 ] [ v_owner ], veh_info [ _veh_id - 1 ] [ v_plate_type ], veh_info [ _veh_id - 1 ] [ v_plate ], veh_info [ _veh_id - 1 ] [ v_region ],
	veh_info [ _veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ _veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ _veh_id - 1 ] [ v_pos ] [ 2 ], veh_info [ _veh_id - 1 ] [ v_pos ] [ 3 ], vehicle_type_family, veh_info [ _veh_id - 1 ] [ v_price ], veh_info [ _veh_id - 1 ] [ v_owner_fam ] ) ;
	mysql_tquery ( sql_connection, sql_string, "create_familyvehicle_callback", "d", _veh_id ) ;
	return 1 ;
}

stock ShowFamMembers ( playerid )
{
	new line_string [ 128 ],
		_f_count = 0,
		_family_id = p_info [ playerid ] [ family ],
		_max_fam_warn = family_info [ _family_id - 1 ] [ fam_max_warn ] ;

	global_string [ 0 ] = EOS ;
	foreach(new i: family_players[_family_id])
	{
		if ( _f_count > page_count [ playerid ] * 20 ) break ;
		if ( _f_count < ( page_count [ playerid ] * 20 ) - 20 )
		{
			_f_count ++ ;
			continue ;
		}
		
		new _f_rang = p_info [ i ] [ family_rang ] ;
		if ( _f_rang < 1 || _f_rang > 12 ) _f_rang = p_info [ i ] [ family_rang ] = 1 ;
		
		_f_count ++ ;

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cGRDialog"}%s {"#cWH"}%s[%i]{"#cGRDialog"}, выговоры: {"#cWH"}%d из %d\n", _f_count, family_rank [ _family_id - 1 ] [ _f_rang - 1 ], p_info [ i ] [ name ], i, p_info [ i ] [ fam_warning ], _max_fam_warn ) ;
		strcat ( global_string, line_string ) ;
	}
	
	new _count_members = Iter_Count(family_players[_family_id]) ;
	if ( _count_members >= 20 )
	{
	    page_rows [ playerid ] = _count_members ;

		new header_string [ 58 + 9 ] ;
		format ( header_string, sizeof header_string, "{"#cBHD"}Члены семьи онлайн ({"#cWH"}%d всего{"#cBHD"})", _count_members ) ;
	    show_dialog ( playerid, d_family_omembers, DIALOG_STYLE_MSGBOX, header_string, global_string, "Вперед", "Назад" ) ;
	}
	else
	{
		new header_string [ 58 + 9 ] ;
		format ( header_string, sizeof header_string, "{"#cBHD"}Члены семьи онлайн ({"#cWH"}%d всего{"#cBHD"})", _count_members ) ;
		
		show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, header_string, global_string, "Закрыть", "" ) ;
	}
	return 1 ;
}

stock familys_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_family_enprises_buy:
		{
			if ( ! response ) return 1 ;
			
			new _family_id = p_info [ playerid ] [ family ], _item = get_player_use_listitem ( playerid ) ;
			if ( fam_enprises [ _item ] [ fe_owner ] != -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У данного предприятия уже есть владелец!" ) ;
			if ( family_info [ _family_id - 1 ] [ fam_level ] < fam_enprises [ _item ] [ fe_price_level ] ) 
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи маленький уровень для владения предприятием." ) ;
			if ( family_info [ _family_id - 1 ] [ fam_bank ] < fam_enprises [ _item ] [ fe_price_money ] )
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи недостаточно средств для приобретения предприятия." ) ;
			if ( family_info [ _family_id - 1 ] [ fam_ticket ] < fam_enprises [ _item ] [ fe_price_ft ] )
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи недостаточно "family_title" для приобретения предприятия." ) ;
			if ( p_info [ playerid ] [ family_rang ] < family_info [ _family_id - 1 ] [ fam_settings ] [ 3 ] )
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Покупка доступна только лидеру семьи." ) ;

			family_info [ _family_id - 1 ] [ fam_bank ] -= fam_enprises [ _item ] [ fe_price_money ] ;
			family_info [ _family_id - 1 ] [ fam_ticket ] -= fam_enprises [ _item ] [ fe_price_ft ] ;
			
			new query [ 144 ] ;
			mysql_format ( sql_connection, query, sizeof query, "UPDATE `family` SET `fam_ticket` = '%d', `fam_bank` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _family_id - 1 ] [ fam_ticket ], family_info [ _family_id - 1 ] [ fam_bank ], _family_id ) ;
            mysql_tquery ( sql_connection, query ) ;
			
			query [ 0 ] = EOS ;
			mysql_format ( sql_connection, query, sizeof query, "UPDATE `family_enprises` SET `fe_owner` = '%d' WHERE `fe_id` = '%d' LIMIT 1", _family_id, fam_enprises [ _item ] [ fe_id ] ) ;
            mysql_tquery ( sql_connection, query ) ;
			
			fam_enprises [ _item ] [ fe_owner ] = _family_id ;
			update_enterprises_label ( _item ) ;
			
			family_info [ _family_id - 1 ] [ fam_enprises_count ] += 1 ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели предприятие во владение Вашей семьи!" ) ;
			return 1 ;
		}
		case d_family_enprises_owner:
		{
			if ( ! response ) return 1 ;
			
			new _item = get_player_use_listitem ( playerid ), family_id = p_info [ playerid ] [ family ] ;
			if ( listitem == 0 )
			{
				if ( ! family_info [ family_id - 1 ] [ fam_house ] ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи нет дома." ) ;
				
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже инкассируете предприятие!" ) ;
				if ( fam_enprises [ _item ] [ fe_money ] < 1 ) return 1 ;
				
				if ( fam_enprises [ _item ] [ fe_money ] < 10_000_000 )
				{
					p_info [ playerid ] [ robbery_money ] = fam_enprises [ _item ] [ fe_money ] ;
					fam_enprises [ _item ] [ fe_money ] = 0 ;
					
					static const _str [ ] = "UPDATE `family_enprises` SET `fe_money` = '%d', `fe_ticket` = '%d' WHERE `fe_id` = '%d' LIMIT 1" ;
					new query [ sizeof _str + ( 9 * 3 ) ] ;
					format ( query, sizeof query, _str, fam_enprises [ _item ] [ fe_money ], fam_enprises [ _item ] [ fe_ticket ], fam_enprises [ _item ] [ fe_id ] ) ;
					mysql_tquery ( sql_connection, query ) ;
				}
				else
				{
					p_info [ playerid ] [ robbery_money ] = 10_000_000 ;
					fam_enprises [ _item ] [ fe_money ] -= 10_000_000 ;
					
					static const _str [ ] = "UPDATE `family_enprises` SET `fe_money` = '%d', `fe_ticket` = '%d' WHERE `fe_id` = '%d' LIMIT 1" ;
					new query [ sizeof _str + ( 9 * 3 ) ] ;
					format ( query, sizeof query, _str, fam_enprises [ _item ] [ fe_money ], fam_enprises [ _item ] [ fe_ticket ], fam_enprises [ _item ] [ fe_id ] ) ;
					mysql_tquery ( sql_connection, query ) ;
				}
				SetPlayerAttachedObject ( playerid, 1, 1550, 1,   0.160001, -0.234000, -0.009998, 1.100002, 95.899940, -17.500007 ) ;
				
				callcmd::famhouse ( playerid ) ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отправляйтесь в дом семьи и отнесите на склад средства." ) ;
			}
			else if ( listitem == 1 )
			{
				if ( ! family_info [ family_id - 1 ] [ fam_house ] ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи нет дома." ) ;
				
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже инкассируете предприятие!" ) ;
				if ( fam_enprises [ _item ] [ fe_ticket ] < 1 ) return 1 ;
				
				if ( fam_enprises [ _item ] [ fe_ticket ] < 100 )
				{
					p_info [ playerid ] [ robbery_ft ] = fam_enprises [ _item ] [ fe_ticket ] ;
					fam_enprises [ _item ] [ fe_ticket ] = 0 ;
					
					static const _str [ ] = "UPDATE `family_enprises` SET `fe_money` = '%d', `fe_ticket` = '%d' WHERE `fe_id` = '%d' LIMIT 1" ;
					new query [ sizeof _str + ( 9 * 3 ) ] ;
					format ( query, sizeof query, _str, fam_enprises [ _item ] [ fe_money ], fam_enprises [ _item ] [ fe_ticket ], fam_enprises [ _item ] [ fe_id ] ) ;
					mysql_tquery ( sql_connection, query ) ;
				}
				else
				{
					p_info [ playerid ] [ robbery_ft ] = 100;
					fam_enprises [ _item ] [ fe_ticket ] -= 100 ;
					
					static const _str [ ] = "UPDATE `family_enprises` SET `fe_money` = '%d', `fe_ticket` = '%d' WHERE `fe_id` = '%d' LIMIT 1" ;
					new query [ sizeof _str + ( 9 * 3 ) ] ;
					format ( query, sizeof query, _str, fam_enprises [ _item ] [ fe_money ], fam_enprises [ _item ] [ fe_ticket ], fam_enprises [ _item ] [ fe_id ] ) ;
					mysql_tquery ( sql_connection, query ) ;
				}
				SetPlayerAttachedObject ( playerid, 1, 1550, 1,   0.160001, -0.234000, -0.009998, 1.100002, 95.899940, -17.500007 ) ;
				
				callcmd::famhouse ( playerid ) ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отправляйтесь в дом семьи и отнесите на склад средства." ) ;
			}
			else if ( listitem == 2 ) show_family_enterprises ( playerid, _item ) ;
			else if ( listitem == 3 ) show_family_enterprises ( playerid, _item ) ;
			else if ( listitem == 4 ) show_family_enterprises ( playerid, _item ) ;
			else if ( listitem == 5 )
			{
				if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Склад доступен только лидеру семьи." ) ;
				
				global_string [ 0 ] = EOS ;
				strcat ( global_string, "{"#cBL"}№. Название:\t{"#cBL"}Количество:\n" ) ;
				for ( new i = 0 ; i < MAX_ENTERPRISES_ITEM ; i ++ )
				{
					if ( fam_enprises [ _item ] [ fe_item ] [ i ] != -1 )
					{
						format ( global_string, sizeof global_string, "%s{"#cBL"}%d. {"#cWH"}%s\t{"#cGN"}%d шт.\n", global_string, i + 1, 
						item_name ( fam_enprises [ _item ] [ fe_item ] [ i ] ), fam_enprises [ _item ] [ fe_item_count ] [ i ] ) ;
					}
					else
					{
						format ( global_string, sizeof global_string, "%s{"#cBL"}%d. {"#cGRDialog"}Пусто\t \n", global_string, i + 1, 
						item_name ( fam_enprises [ _item ] [ fe_item ] [ i ] ), fam_enprises [ _item ] [ fe_item_count ] [ i ] ) ;
					}
				}
				strcat ( global_string, "{"#cWH"}Информация" ) ;
				show_dialog ( playerid, d_family_enprises_item, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Склад", global_string, "Выбрать", "Закрыть" ) ;
			}
			else if ( listitem == 6 ) show_family_enterprises ( playerid, _item ) ;
			else if ( listitem == 7 ) show_family_enterprises ( playerid, _item ) ;
			else if ( listitem == 8 )
			{
				if ( fam_enprises [ _item ] [ fe_owner ] != family_id ) 
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Предприятие не пренадлежит Вашей семье!" ) ;
				if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Продажа доступна только лидеру семьи." ) ;
				
				clear_sell_params ( playerid, INVALID_PLAYER_ID ) ;
				show_family_enprises_sell ( playerid ) ;
			}
			else if ( listitem == 9 )
			{
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация о предприятии", "\
				{"#cLY"}Семейные предприятия {"#cWH"}- это альтернативный источник пассивного дохода для семьи,\n\
				а также возможность озадачить новичков и разнообразить их игру.\n\
				Каждый час происходит начисление бонусов за владение предприятием.\n\
				Начисление происходит с {"#cLY"}12:00 {"#cWH"}до {"#cLY"}20:00 {"#cWH"}часов.\n\
				В указанный временной промежуток также {"#cLY"}доступны рейды {"#cWH"}предприятий.\n\
				Рейдить одно {"#cLY"}предприятие можно раз в сутки{"#cWH"}.\n\
				Денежные средства и "family_title" {"#cLY"}нужно инкассировать {"#cWH"}с помощью членов семьи,\n\
				а рейтинг выдаётся автоматически каждый час.", "Принять", "" ) ;
			}
			return 1 ;
		}
		case d_family_enprises_reid:
		{
			if ( ! response ) return 1 ;
			
			new _item = get_player_use_listitem ( playerid ), family_id = p_info [ playerid ] [ family ] ;
			if ( listitem == 0 )
			{
				if ( ! family_info [ family_id - 1 ] [ fam_house ] ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи нет дома." ) ;
				if ( fam_enprises [ _item ] [ fe_reid ] != family_id ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваша семья не рейдит данное предприятие." ) ;
				if ( fam_enprises [ _item ] [ fe_time ] < 1 ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент предприятие никто не рейдит." ) ;
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже инкассируете предприятие!" ) ;
				if ( fam_enprises [ _item ] [ fe_money ] < 1 ) return 1 ;
				
				if ( fam_enprises [ _item ] [ fe_money ] < 10_000_000 )
				{
					p_info [ playerid ] [ robbery_money ] = fam_enprises [ _item ] [ fe_money ] ;
					fam_enprises [ _item ] [ fe_money ] = 0 ;
					
					static const _str [ ] = "UPDATE `family_enprises` SET `fe_money` = '%d', `fe_ticket` = '%d' WHERE `fe_id` = '%d' LIMIT 1" ;
					new query [ sizeof _str + ( 9 * 3 ) ] ;
					format ( query, sizeof query, _str, fam_enprises [ _item ] [ fe_money ], fam_enprises [ _item ] [ fe_ticket ], fam_enprises [ _item ] [ fe_id ] ) ;
					mysql_tquery ( sql_connection, query ) ;
				}
				else
				{
					p_info [ playerid ] [ robbery_money ] = 10_000_000 ;
					fam_enprises [ _item ] [ fe_money ] -= 10_000_000 ;
					
					static const _str [ ] = "UPDATE `family_enprises` SET `fe_money` = '%d', `fe_ticket` = '%d' WHERE `fe_id` = '%d' LIMIT 1" ;
					new query [ sizeof _str + ( 9 * 3 ) ] ;
					format ( query, sizeof query, _str, fam_enprises [ _item ] [ fe_money ], fam_enprises [ _item ] [ fe_ticket ], fam_enprises [ _item ] [ fe_id ] ) ;
					mysql_tquery ( sql_connection, query ) ;
				}
				SetPlayerAttachedObject ( playerid, 1, 1550, 1,   0.160001, -0.234000, -0.009998, 1.100002, 95.899940, -17.500007 ) ;
				
				callcmd::famhouse ( playerid ) ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отправляйтесь в дом семьи и отнесите на склад средства." ) ;
			}
			else if ( listitem == 1 )
			{
				if ( ! family_info [ family_id - 1 ] [ fam_house ] ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи нет дома." ) ;
				if ( fam_enprises [ _item ] [ fe_reid ] != family_id ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваша семья не рейдит данное предприятие." ) ;
				if ( fam_enprises [ _item ] [ fe_time ] < 1 ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент предприятие никто не рейдит." ) ;
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже инкассируете предприятие!" ) ;
				if ( fam_enprises [ _item ] [ fe_ticket ] < 1 ) return 1 ;
				
				if ( fam_enprises [ _item ] [ fe_ticket ] < 100 )
				{
					p_info [ playerid ] [ robbery_ft ] = fam_enprises [ _item ] [ fe_ticket ] ;
					fam_enprises [ _item ] [ fe_ticket ] = 0 ;
					
					static const _str [ ] = "UPDATE `family_enprises` SET `fe_money` = '%d', `fe_ticket` = '%d' WHERE `fe_id` = '%d' LIMIT 1" ;
					new query [ sizeof _str + ( 9 * 3 ) ] ;
					format ( query, sizeof query, _str, fam_enprises [ _item ] [ fe_money ], fam_enprises [ _item ] [ fe_ticket ], fam_enprises [ _item ] [ fe_id ] ) ;
					mysql_tquery ( sql_connection, query ) ;
				}
				else
				{
					p_info [ playerid ] [ robbery_ft ] = 100 ;
					fam_enprises [ _item ] [ fe_ticket ] -= 100 ;
					
					static const _str [ ] = "UPDATE `family_enprises` SET `fe_money` = '%d', `fe_ticket` = '%d' WHERE `fe_id` = '%d' LIMIT 1" ;
					new query [ sizeof _str + ( 9 * 3 ) ] ;
					format ( query, sizeof query, _str, fam_enprises [ _item ] [ fe_money ], fam_enprises [ _item ] [ fe_ticket ], fam_enprises [ _item ] [ fe_id ] ) ;
					mysql_tquery ( sql_connection, query ) ;
				}
				SetPlayerAttachedObject ( playerid, 1, 1550, 1,   0.160001, -0.234000, -0.009998, 1.100002, 95.899940, -17.500007 ) ;
				
				callcmd::famhouse ( playerid ) ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отправляйтесь в дом семьи и отнесите на склад средства." ) ;
			}
			else if ( listitem == 2 ) show_family_enterprises ( playerid, _item ) ;
			else if ( listitem == 3 ) show_family_enterprises ( playerid, _item ) ;
			else if ( listitem == 4 ) show_family_enterprises ( playerid, _item ) ;
			else if ( listitem == 5 )
			{
				if ( ! family_info [ family_id - 1 ] [ fam_house ] ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи нет дома." ) ;
				if ( fam_enprises [ _item ] [ fe_reid ] != family_id ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваша семья не рейдит данное предприятие." ) ;
				if ( fam_enprises [ _item ] [ fe_time ] < 1 ) return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент предприятие никто не рейдит." ) ;
				if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Склад доступен только лидеру семьи." ) ;
				
				global_string [ 0 ] = EOS ;
				strcat ( global_string, "{"#cBL"}№. Название:\t{"#cBL"}Количество:\n" ) ;
				for ( new i = 0 ; i < MAX_ENTERPRISES_ITEM ; i ++ )
				{
					if ( fam_enprises [ _item ] [ fe_item ] [ i ] != -1 )
					{
						format ( global_string, sizeof global_string, "%s{"#cBL"}%d. {"#cWH"}%s\t{"#cGN"}%d шт.\n", global_string, i + 1, 
						item_name ( fam_enprises [ _item ] [ fe_item ] [ i ] ), fam_enprises [ _item ] [ fe_item_count ] [ i ] ) ;
					}
					else
					{
						format ( global_string, sizeof global_string, "%s{"#cBL"}%d. {"#cGRDialog"}Пусто\t \n", global_string, i + 1, 
						item_name ( fam_enprises [ _item ] [ fe_item ] [ i ] ), fam_enprises [ _item ] [ fe_item_count ] [ i ] ) ;
					}
				}
				strcat ( global_string, "{"#cWH"}Информация" ) ;
				show_dialog ( playerid, d_family_enprises_item, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Склад", global_string, "Выбрать", "Закрыть" ) ;
			}
			else if ( listitem == 6 ) show_family_enterprises ( playerid, _item ) ;
			else if ( listitem == 7 ) show_family_enterprises ( playerid, _item ) ;
			else if ( listitem == 8 )
			{
				if ( global_hour < 12 || global_hour > 20 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Рейдить предприятия можо с 12 до 20 часов." ) ;
				
				new _fe_owner = fam_enprises [ _item ] [ fe_owner ], 
					_time = SetElapsedTime ( fam_enprises [ _item ] [ fe_reid_date ], 24, CONVERT_TIME_TO_HOURS ),
					owner_counts = 0 ;
				if ( update_family_level ( family_id ) < fam_enprises [ _item ] [ fe_reid_level ] )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи слишком маленький уровень для рейда!" ) ;
				if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Рейд может начать только лидер семьи." ) ;
				if ( _time > gettime ( ) )
				{
					new line_string [ 144 ], s_year, s_month, s_day, s_hour, s_minute, s_second ;
					timestamp_to_date ( _time + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
					
					format ( line_string, sizeof line_string, "{"#cRInfo"}* {"#cGRInfo"}Рейд данного предприятия будет доступен {"#cRInfo"}%02d.%02d.%d в %02d:%02d:%02d{"#cGRInfo"}.", s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
					SendClientMessage ( playerid, col_gray, line_string ) ;
					return 1 ;
				}
				
				foreach(new j: family_players[_fe_owner])
				{
					if ( _fe_owner == p_info [ j ] [ family ] && p_info [ j ] [ famblock ] == 0 ) owner_counts ++ ;
				}
				if ( owner_counts < familywars_online )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игроков семьи, контроллирующей предприятие, недостаточно для проведения рейда." ) ;
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "{"#cRInfo"}* {"#cGRInfo"}В игре {"#cRInfo"}%d чел.{"#cGRInfo"} из {"#cRInfo"}%d чел.{"#cGRInfo"} необходимым для рейда.", owner_counts, familywars_online ) ;
					SendClientMessage ( playerid, col_gray, global_string ) ;
					return 1 ;
				}

				fam_enprises [ _item ] [ fe_reid ] = family_id ;
				fam_enprises [ _item ] [ fe_reid_date ] = gettime ( ) ;
				
				static const _str [ ] = "UPDATE `family_enprises` SET `fe_reid` = '%d', `fe_reid_date` = '%d' WHERE `fe_id` = '%d' LIMIT 1" ;
				new query [ sizeof _str + ( 9 * 3 ) ] ;
				format ( query, sizeof query, _str, family_id, fam_enprises [ _item ] [ fe_reid_date ], fam_enprises [ _item ] [ fe_id ] ) ;
				mysql_tquery ( sql_connection, query ) ;
				
				fam_enprises [ _item ] [ fe_third_minute ] = 0 ;
				fam_enprises [ _item ] [ fe_time ] = 600 ;
				fam_enprises [ _item ] [ fe_conf_timer ] = SetTimerEx ( "family_enterprises_timer", 1000, true, "iii", _item, family_id, fam_enprises [ _item ] [ fe_owner ] ) ;
			
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "{%s}[FAM] Начался рейд предприятия '%s'!", family_info [ family_id - 1 ] [ fam_chat_color ], fam_enprises [ _item ] [ fe_name ] ) ;
				family_message ( family_id, col_gray, global_string ) ;
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "{%s}[FAM] Берите сумки с деньгами и "family_title" с предприятия и везите в общак!", family_info [ family_id - 1 ] [ fam_chat_color ] ) ;
				family_message ( family_id, col_gray, global_string ) ;
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "{%s}[FAM] Начался рейд предприятия '%s'!", family_info [ _fe_owner - 1 ] [ fam_chat_color ], fam_enprises [ _item ] [ fe_name ] ) ;
				family_message ( _fe_owner, col_gray, global_string ) ;
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "{%s}[FAM] Отбейте предприятие и остановите рейд!", family_info [ _fe_owner - 1 ] [ fam_chat_color ] ) ;
				family_message ( _fe_owner, col_gray, global_string ) ;
			}
			else if ( listitem == 9 )
			{
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация о предприятии", "\
				{"#cLY"}Семейные предприятия {"#cWH"}- это альтернативный источник пассивного дохода для семьи,\n\
				а также возможность озадачить новичков и разнообразить их игру.\n\
				Каждый час происходит начисление бонусов за владение предприятием.\n\
				Начисление происходит с {"#cLY"}12:00 {"#cWH"}до {"#cLY"}20:00 {"#cWH"}часов.\n\
				В указанный временной промежуток также {"#cLY"}доступны рейды {"#cWH"}предприятий.\n\
				Рейдить одно {"#cLY"}предприятие можно раз в сутки{"#cWH"}.\n\
				Денежные средства и "family_title" {"#cLY"}нужно инкассировать {"#cWH"}с помощью членов семьи,\n\
				а рейтинг выдаётся автоматически каждый час.", "Принять", "" ) ;
			}
			return 1 ;
		}
		case d_family_enprises_item:
		{
			if ( ! response ) return show_family_enterprises ( playerid, get_player_use_listitem ( playerid ) ) ;
			
			if ( listitem >= MAX_ENTERPRISES_ITEM )
			{
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", "\
					{"#cLY"}Склад предприятия {"#cWH"}пополняется автоматически.\n\
					Каждый час выбираются {"#cLY"}случайные предметы{"#cWH"}.\n\
					Предметов может добавиться как {"#cLY"}сразу несколько {"#cWH"}и крайне редких,\n\
					как и {"#cLY"}не добавиться вообще{"#cWH"}.\n\
					Предметы могут {"#cLY"}не добавляться {"#cWH"}по несколько часов - это дело везения.\n\
					Выпасть может большой спектр предметов, но пустых мест намного меньше,\n\
					Поэтому рекомендуем Вам постоянно следить, чтоб были пустые места.", "Принять", "" ) ;
				return 1 ;
			}
			
			new _fam_id = p_info [ playerid ] [ family ], 
				_item = get_player_use_listitem ( playerid ),
				_owner = fam_enprises [ _item ] [ fe_owner ],
				_reid = fam_enprises [ _item ] [ fe_reid ] ;
			if ( fam_enprises [ _item ] [ fe_item ] [ listitem ] == -1 )
			{
				show_family_enterprises ( playerid, _item ) ;
				return 1 ;
			}
			if ( _owner != _fam_id && _reid == _fam_id )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "{%s}[FAM] Предприятие '%s' рейдят! Со склада украли '%s'!", family_info [ _owner - 1 ] [ fam_chat_color ], fam_enprises [ _item ] [ fe_name ], item_name ( fam_enprises [ _item ] [ fe_item ] [ listitem ] ) ) ;
				family_message ( _owner, col_gray, global_string ) ;
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "{%s}[FAM] %s %s взял(а) '%s' со склада предприятия '%s'!", family_info [ _reid - 1 ] [ fam_chat_color ], family_rank [ _owner - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], item_name ( fam_enprises [ _item ] [ fe_item ] [ listitem ] ), fam_enprises [ _item ] [ fe_name ] ) ;
				family_message ( _reid, col_gray, global_string ) ;
				
				give_player_item_prise ( playerid, fam_enprises [ _item ] [ fe_item ] [ listitem ], 1 ) ;
				if ( -- fam_enprises [ _item ] [ fe_item_count ] [ listitem ] < 1 )
				{
					fam_enprises [ _item ] [ fe_item ] [ listitem ] = -1 ;
					fam_enprises [ _item ] [ fe_item_count ] [ listitem ] = 0 ;
				}
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 512, "UPDATE `family_enprises` SET `fe_item` = '%d|%d|%d|%d|%d', `fe_item_count` = '%d|%d|%d|%d|%d' WHERE `fe_id` = '%d' LIMIT 1", 
				fam_enprises [ _item ] [ fe_item ] [ 0 ], fam_enprises [ _item ] [ fe_item ] [ 1 ], fam_enprises [ _item ] [ fe_item ] [ 2 ], fam_enprises [ _item ] [ fe_item ] [ 3 ], fam_enprises [ _item ] [ fe_item ] [ 4 ],
				fam_enprises [ _item ] [ fe_item_count ] [ 0 ], fam_enprises [ _item ] [ fe_item_count ] [ 1 ], fam_enprises [ _item ] [ fe_item_count ] [ 2 ], fam_enprises [ _item ] [ fe_item_count ] [ 3 ], fam_enprises [ _item ] [ fe_item_count ] [ 4 ], 
				fam_enprises [ _item ] [ fe_id ] ) ;
				mysql_tquery ( sql_connection, global_string ) ;
				
				show_family_enterprises ( playerid, _item ) ;
			}
			else
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "{%s}[FAM] %s %s взял(а) '%s' со склада предприятия '%s'!", family_info [ _owner - 1 ] [ fam_chat_color ], family_rank [ _owner - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], item_name ( fam_enprises [ _item ] [ fe_item ] [ listitem ] ), fam_enprises [ _item ] [ fe_name ] ) ;
				family_message ( _owner, col_gray, global_string ) ;
				
				give_player_item_prise ( playerid, fam_enprises [ _item ] [ fe_item ] [ listitem ], 1 ) ;
				if ( -- fam_enprises [ _item ] [ fe_item_count ] [ listitem ] < 1 )
				{
					fam_enprises [ _item ] [ fe_item ] [ listitem ] = -1 ;
					fam_enprises [ _item ] [ fe_item_count ] [ listitem ] = 0 ;
				}
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 512, "UPDATE `family_enprises` SET `fe_item` = '%d|%d|%d|%d|%d', `fe_item_count` = '%d|%d|%d|%d|%d' WHERE `fe_id` = '%d' LIMIT 1", 
				fam_enprises [ _item ] [ fe_item ] [ 0 ], fam_enprises [ _item ] [ fe_item ] [ 1 ], fam_enprises [ _item ] [ fe_item ] [ 2 ], fam_enprises [ _item ] [ fe_item ] [ 3 ], fam_enprises [ _item ] [ fe_item ] [ 4 ],
				fam_enprises [ _item ] [ fe_item_count ] [ 0 ], fam_enprises [ _item ] [ fe_item_count ] [ 1 ], fam_enprises [ _item ] [ fe_item_count ] [ 2 ], fam_enprises [ _item ] [ fe_item_count ] [ 3 ], fam_enprises [ _item ] [ fe_item_count ] [ 4 ], 
				fam_enprises [ _item ] [ fe_id ] ) ;
				mysql_tquery ( sql_connection, global_string ) ;
				
				show_family_enterprises ( playerid, _item ) ;
			}
			return 1 ;
		}
		case d_family_enprises_sell:
		{
			if ( ! response ) return show_family_enterprises ( playerid, get_player_use_listitem ( playerid ) ) ;
			if ( listitem == 0 )
			{
				show_dialog ( playerid, d_family_enprises_sell_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Продажа предприятия", "{"#cWH"}Укажите сумму {"#cGN"}"valute_title_"{"#cWH"}, за которую хотите продать предприятие:", "Указать", "Назад" ) ;
			}
			else if ( listitem == 1 )
			{
				show_dialog ( playerid, d_family_enprises_sell_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Продажа предприятия", "{"#cWH"}Укажите сумму {"#cGN"}"family_title"{"#cWH"}, за которую хотите продать предприятие:", "Указать", "Назад" ) ;
			}
			else if ( listitem == 2 )
			{
				if ( sell_price [ playerid ] < 1 || sell_type [ playerid ] < 1 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не указали цену." ) ;
					show_family_enprises_sell ( playerid ) ;
					return 1 ;
				}
				
				show_dialog ( playerid, d_family_enprises_sell_player, DIALOG_STYLE_INPUT, "{"#cBHD"}Продажа предприятия", "{"#cWH"}Укажите ID игрока, которому хотите продать предприятие:", "Указать", "Назад" ) ;
			}
			return 1 ;
		}
		case d_family_enprises_sell_money:
		{
			if ( ! response ) return show_family_enprises_sell ( playerid ) ;
			
			new _value = strval ( inputtext ) ;
			if ( _value < 1 || _value > max_money )
			{
				show_dialog ( playerid, d_family_enprises_sell_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Продажа предприятия", "{"#cRD"}* Цена не может быть менее 1"valute_title_" и более 1.800.000.000"valute_title_"!\n{"#cWH"}Укажите сумму {"#cGN"}"valute_title_"{"#cWH"}, за которую хотите продать предприятие:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			sell_price [ playerid ] = _value ;
			show_family_enprises_sell ( playerid ) ;
			return 1 ;
		}
		case d_family_enprises_sell_ft:
		{
			if ( ! response ) return show_family_enprises_sell ( playerid ) ;
			
			new _value = strval ( inputtext ) ;
			if ( _value < 1 || _value > 1_000_000 )
			{
				show_dialog ( playerid, d_family_enprises_sell_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Продажа предприятия", "{"#cRD"}* Цена не может быть менее 1 "family_title" и более 1.000.000 "family_title"!\n\n{"#cWH"}Укажите сумму {"#cGN"}"family_title"{"#cWH"}, за которую хотите продать предприятие:", "Указать", "Назад" ) ;
				return 1 ;
			}
			
			sell_type [ playerid ] = _value ;
			show_family_enprises_sell ( playerid ) ;
			return 1 ;
		}
		case d_family_enprises_sell_player:
		{
			if ( ! response ) return show_family_enprises_sell ( playerid ) ;
			
			new _pl_id = strval ( inputtext ) ;
		    if ( ! IsPlayerConnected ( _pl_id ) || p_t_info [ _pl_id ] [ p_logged ] == false || playerid == _pl_id )
		    {
		        show_dialog ( playerid, d_family_enprises_sell_player, DIALOG_STYLE_INPUT, "{"#cBHD"}Продажа предприятия", "{"#cRD"}* Данный игрок не найден!\n\n{"#cWH"}Укажите ID игрока, которому хотите продать предприятие:", "Указать", "Назад" ) ;
				return 1 ;
		    }
		    if ( p_t_info [ _pl_id ] [ p_dialog ] != -1 )
            {
		        show_dialog ( playerid, d_family_enprises_sell_player, DIALOG_STYLE_INPUT, "{"#cBHD"}Продажа предприятия", "{"#cRD"}* Игрок в данный момент не может заключить сделку(открыт диалог)!\n\n{"#cWH"}Укажите ID игрока, которому хотите продать предприятие:", "Указать", "Назад" ) ;
				return 1 ;
		    }
			if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ _pl_id ] [ p_pos ] [ 0 ], p_t_info [ _pl_id ] [ p_pos ] [ 1 ], p_t_info [ _pl_id ] [ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( _pl_id ) != GetPlayerVirtualWorld ( playerid ) )
            {
		        show_dialog ( playerid, d_family_enprises_sell_player, DIALOG_STYLE_INPUT, "{"#cBHD"}Продажа предприятия", "{"#cRD"}* Данный игрок слишком далеко!\n\n{"#cWH"}Укажите ID игрока, которому хотите продать предприятие:", "Указать", "Назад" ) ;
				return 1 ;
		    }
		    if ( ! p_info [ _pl_id ] [ family ] )
		    {
		        show_dialog ( playerid, d_family_enprises_sell_player, DIALOG_STYLE_INPUT, "{"#cBHD"}Продажа предприятия", "{"#cRD"}* Игрок не состоит в семье!\n\n{"#cWH"}Укажите ID игрока, которому хотите продать предприятие:", "Указать", "Назад" ) ;
				return 1 ;
		    }
		    if ( p_info [ _pl_id ] [ family_rang ] < family_info [ p_info [ _pl_id ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
		    {
		        show_dialog ( playerid, d_family_enprises_sell_player, DIALOG_STYLE_INPUT, "{"#cBHD"}Продажа предприятия", "{"#cRD"}* Игрок не является лидером семьи!\n\n{"#cWH"}Укажите ID игрока, которому хотите продать предприятие:", "Указать", "Назад" ) ;
				return 1 ;
		    }
			
			if ( GetString ( p_t_info [ _pl_id ] [ p_ip ], p_t_info [ playerid ] [ p_ip ] ) )
			{
				new scm_string [ 128 ] ;
				format ( scm_string, sizeof ( scm_string ), "{"#cRAdmin"}[A] {"#cGRAdmin"}%s[%d] продает предприятие %s[%d] | same ip", p_info [ playerid ] [ name ], playerid, p_info [ _pl_id ] [ name ], _pl_id ) ;
				foreach(new i: admin_players) SendClientMessage ( i, col_admin, scm_string ) ;

				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Невозможно продать предприятие данному игроку." ) ;
				return 1 ;
			}

			buyer_id [ playerid ] = _pl_id ;
			seller_id [ _pl_id ] = playerid ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 144, "Вы предложили игроку {"#cOR"}%s{FFFFFF} приобрести Ваше семейное предприятие.", p_info [ _pl_id ] [ name ] ) ;
			SendClientMessage ( playerid, col_white, global_string ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 256, "\
			{"#cOR"}%s {"#cWH"}предлагает Вам приобрести семейное предприятие.\n\
			За {"#cGN"}%s "family_title"{FFFFFF} + {"#cGN"}%s"valute_title"{"#cWH"}.\n\n\
			{"#cGRDialog"}* Вы готовы приобрести предприятие?",
			p_info [ playerid ] [ name ], GetPlayerCashValueToSmile ( sell_type [ playerid ] ), GetPlayerCashValueToSmile ( sell_price [ playerid ] ) ) ;
			show_dialog ( _pl_id, d_family_enprises_sell_accept, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка предприятия", global_string, "Принять", "Отмена" ) ;
			return 1 ;
		}
		case d_family_enprises_sell_accept:
		{
			if ( seller_id [ playerid ] == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Продавец покинул игру." ) ;
			if ( ! response )
			{
				SendClientMessage ( seller_id [ playerid ], col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок отказался от покупки предприятия." ) ;
				clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			
			new target_id = seller_id [ playerid ], 
				_fam_id = p_info [ playerid ] [ family ], 
				_target_fam = p_info [ target_id ] [ family ],
				_money = sell_price [ target_id ], 
				_ft = sell_type [ target_id ] ;
			if ( family_info [ _fam_id - 1 ] [ fam_bank ] < _money )
			{
				SendClientMessage ( target_id, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока недостаточно денег в банке семьи для приобретения предприятия." ) ;
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно денег в банке семьи для приобретения предприятия." ) ;
				clear_sell_params ( playerid, target_id ) ;
				return 1 ;
			}
			if ( family_info [ _fam_id - 1 ] [ fam_ticket ] < _ft )
			{
				SendClientMessage ( target_id, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока недостаточно "family_title" в банке семьи для приобретения предприятия." ) ;
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно "family_title" в банке семьи для приобретения предприятия." ) ;
				clear_sell_params ( playerid, target_id ) ;
				return 1 ;
			}
			
			family_info [ _fam_id - 1 ] [ fam_bank ] -= _money ;
			family_info [ _fam_id - 1 ] [ fam_ticket ] -= _ft ;
			family_info [ _target_fam - 1 ] [ fam_bank ] += _money ;
			family_info [ _target_fam - 1 ] [ fam_ticket ] += _ft ;

			new _text_string [ 144 ], _item = get_player_use_listitem ( playerid ) ;
			format ( _text_string, sizeof _text_string, "{"#cGN"}* %s{"#cWH"} продал Вам семейное предприятие.", p_info [ target_id ] [ name ] ) ;
			SendClientMessage ( playerid, col_white, _text_string ) ;
			format( _text_string, sizeof _text_string, "{"#cGInfo"}* {"#cWH"}Вы продали {"#cGN"}%s{"#cWH"} семейное предприятие.", p_info [ playerid ] [ name ] ) ;
			SendClientMessage ( target_id, col_white, _text_string ) ;
			
			_text_string [ 0 ] = EOS ;
			mysql_format ( sql_connection, _text_string, sizeof _text_string, "UPDATE `family` SET `fam_ticket` = '%d', `fam_bank` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_ticket ], family_info [ _fam_id - 1 ] [ fam_bank ], _fam_id ) ;
            mysql_tquery ( sql_connection, _text_string ) ;
			
			_text_string [ 0 ] = EOS ;
			mysql_format ( sql_connection, _text_string, sizeof _text_string, "UPDATE `family` SET `fam_ticket` = '%d', `fam_bank` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _target_fam - 1 ] [ fam_ticket ], family_info [ _target_fam - 1 ] [ fam_bank ], _target_fam ) ;
            mysql_tquery ( sql_connection, _text_string ) ;
			
			_text_string [ 0 ] = EOS ;
			mysql_format ( sql_connection, _text_string, sizeof _text_string, "UPDATE `family_enprises` SET `fe_owner` = '%d' WHERE `fe_id` = '%d' LIMIT 1", _fam_id, fam_enprises [ _item ] [ fe_id ] ) ;
            mysql_tquery ( sql_connection, _text_string ) ;
			
			family_info [ _target_fam - 1 ] [ fam_enprises_count ] -= 1 ;
			family_info [ _fam_id - 1 ] [ fam_enprises_count ] += 1 ;
			fam_enprises [ _item ] [ fe_owner ] = _fam_id ;
			update_enterprises_label ( _item ) ;

			clear_sell_params ( playerid, target_id ) ;
			return 1 ;
		}
		case d_diplomacy_message:
		{
			if ( ! response ) return 1 ;
			
			callcmd::ufam ( playerid, inputtext ) ;
			return 1 ;
		}
		case d_family_invites:
		{
			if ( ! response ) return 1 ;
			
			callcmd::faminvite ( playerid, inputtext ) ;
			return 1 ;
		}
		case d_family_noty:
		{
			if ( ! response ) return 1 ;
			
			new _id = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
			
			if ( _id == -1 )
			{
				show_dialog ( playerid, d_family_noty1, DIALOG_STYLE_INPUT, "{"#cBHD"}Сообщение", "{"#cWH"}Введите текст сообщения:\n\n{"#cGRDialog"}* Сообщение будет видеть каждый игрок,\n{"#cGRDialog"}* который откроет семейное меню", "Выбрать", "Отмена" ) ;
				return 1 ;
			}
			
			new _family_id = p_info [ playerid ] [ family ] ;
			if ( family_news [ _family_id ] [ _id ] [ n_free_slot ] == true )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 70, "DELETE FROM `family_noty` WHERE `n_id` = '%d' LIMIT 1", family_news [ _family_id ] [ _id ] [ n_id ] ) ;
				mysql_tquery ( sql_connection, global_string ) ;
		
				family_news [ _family_id ] [ _id ] [ n_id ] = 0 ;
				family_news [ _family_id ] [ _id ] [ n_free_slot ] = false ;
				family_news_loading [ _family_id ] = false ;
				
				show_packet_family ( playerid, 0, 0, 0 ) ;
			}
			return 1 ;
		}
		case d_family_noty1:
		{
			if ( ! response ) return 1 ;
			
			if ( strlen ( inputtext ) < 3 || strlen ( inputtext ) > 255 )
			{
				send_check_cinfo ( playerid, "Вы указали некорректные символы.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( is_text_invalid ( inputtext ) || check_advertise ( playerid, inputtext, report_type_fnoty ) )
			{
				send_check_cinfo ( playerid, "Вы указали некорректные символы.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
		
			new _family_id = p_info [ playerid ] [ family ], _n_count = 0, _n_free_id = 0 ;
			for ( new i = 0 ; i < MAX_FAMILY_NEWS ; i ++ )
			{
				if ( family_news [ _family_id ] [ i ] [ n_free_slot ] == true ) continue ;

				_n_count ++ ;
				_n_free_id = i ;
			}
			
			if ( ! _n_count )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 70, "DELETE FROM `family_noty` WHERE `n_id` = '%d' LIMIT 1", family_news [ _family_id ] [ 0 ] [ n_id ] ) ;
				mysql_tquery ( sql_connection, global_string ) ;
		
				family_news [ _family_id ] [ _n_free_id ] [ n_id ] = _n_free_id + 1 ;
				format ( family_news [ _family_id ] [ _n_free_id ] [ n_text ], 200, "%s", inputtext ) ;
				format ( family_news [ _family_id ] [ _n_free_id ] [ n_text_owner ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;
				family_news [ _family_id ] [ _n_free_id ] [ n_text_date ] = SetElapsedTime ( gettime ( ), 24, CONVERT_TIME_TO_HOURS ) ;
				family_news [ _family_id ] [ _n_free_id ] [ n_free_slot ] = true ;
				family_news_loading [ _family_id ] = false ;
		
				global_string [ 0 ] = EOS ;
				format ( global_string, 356, "INSERT INTO `family_noty` (`n_id`,`family_id`,`family_text`,`family_text_owner`,`family_date`) VALUES ('%d','%d','%s','%s','%d')",
				_n_free_id + 1, _family_id, family_news [ _family_id ] [ _n_free_id ] [ n_text ], family_news [ _family_id ] [ _n_free_id ] [ n_text_owner ], SetElapsedTime ( gettime ( ), 24, CONVERT_TIME_TO_HOURS ) ) ;
				mysql_tquery ( sql_connection, global_string ) ;
				
				show_packet_family ( playerid, 0, 0, 0 ) ;
				return 1 ;
			}
			
			family_news [ _family_id ] [ _n_free_id ] [ n_id ] = _n_free_id + 1 ;
			format ( family_news [ _family_id ] [ _n_free_id ] [ n_text ], 200, "%s", inputtext ) ;
			format ( family_news [ _family_id ] [ _n_free_id ] [ n_text_owner ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;
			family_news [ _family_id ] [ _n_free_id ] [ n_text_date ] = SetElapsedTime ( gettime ( ), 24, CONVERT_TIME_TO_HOURS ) ;
			family_news [ _family_id ] [ _n_free_id ] [ n_free_slot ] = true ;
			family_news_loading [ _family_id ] = false ;
		
			global_string [ 0 ] = EOS ;
			format ( global_string, 356, "INSERT INTO `family_noty` (`n_id`,`family_id`,`family_text`,`family_text_owner`,`family_date`) VALUES ('%d','%d','%s','%s','%d')",
			_n_free_id + 1, _family_id, family_news [ _family_id ] [ _n_free_id ] [ n_text ], family_news [ _family_id ] [ _n_free_id ] [ n_text_owner ], SetElapsedTime ( gettime ( ), 24, CONVERT_TIME_TO_HOURS ) ) ;
			mysql_tquery ( sql_connection, global_string ) ;
			
			show_packet_family ( playerid, 0, 0, 0 ) ;
			return 1 ;
		}
		case d_fam_payday:
		{
			if ( ! response ) return 1 ;
			
			if ( listitem == 0 )
			{
				new family_id = p_info [ playerid ] [ family ] ;

		        global_string [ 0 ] = EOS ;
				format(global_string, 450, "{"#cWH"}Вы собираетесь изменить следующую конфигурацию:\n\n\t{"#cWH"}Название: {"#cLY"}Заработная плата в PayDay (каждый час)\n\t{"#cWH"}Текущее значение: {"#cLY"}%s"valute_title_"\n\n{"#cGRDialog"}* Введите новое значение для данной конфигурации:", GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_payday ] [ get_player_use_listitem ( playerid ) ] ) ) ;
				show_dialog(playerid, d_fam_payday_sum, DIALOG_STYLE_INPUT, "{"#cBHD"}Изменение конфигурации", global_string, "Выбрать", "Назад" ) ;
			}
			else if ( listitem == 1 )
			{
				new family_id = p_info [ playerid ] [ family ] ;

		        global_string [ 0 ] = EOS ;
				format(global_string, 450, "{"#cWH"}Вы собираетесь изменить следующую конфигурацию:\n\n\t{"#cWH"}Название: {"#cLY"}"family_title" в PayDay (каждый час)\n\t{"#cWH"}Текущее значение: {"#cLY"}%s"valute_title_"\n\n{"#cGRDialog"}* Введите новое значение для данной конфигурации:", GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_payday_ticket ] [ get_player_use_listitem ( playerid ) ] ) ) ;
				show_dialog(playerid, d_fam_payday_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Изменение конфигурации", global_string, "Выбрать", "Назад" ) ;
			}
			return 1 ;
		}
		case d_fam_payday_sum:
		{
			if ( ! response ) return 1 ;
			
			new family_id = p_info [ playerid ] [ family ], _value = strval ( inputtext ) ;
			if ( _value < 0 || _value > 10_000_000 )
			{
		        global_string [ 0 ] = EOS ;
				format(global_string, 450, "{"#cWH"}Вы собираетесь изменить следующую конфигурацию:\n\n\t{"#cWH"}Название: {"#cLY"}Заработная плата в PayDay (каждый час)\n\t{"#cWH"}Текущее значение: {"#cLY"}%s"valute_title_"\n\n{"#cGRDialog"}* Введите новое значение для данной конфигурации:", GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_payday ] [ get_player_use_listitem ( playerid ) ] ) ) ;
				show_dialog(playerid, d_fam_payday_sum, DIALOG_STYLE_INPUT, "{"#cBHD"}Изменение конфигурации", global_string, "Выбрать", "Назад" ) ;
				
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нельзя установить менее {"#cRD"}0"valute_title_"{"#cGRInfo"} и более {"#cRD"}10.000.000"valute_title"{"#cGRInfo"}." ) ;
				return 1 ;
			}
			
			family_info [ family_id - 1 ] [ fam_payday ] [ get_player_use_listitem ( playerid ) ] = _value ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 512, "UPDATE `family` SET `fam_payday` = '%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d' WHERE `fam_id` = '%d' LIMIT 1",
			family_info [ family_id - 1 ] [ fam_payday ] [ 0 ],
			family_info [ family_id - 1 ] [ fam_payday ] [ 1 ],
			family_info [ family_id - 1 ] [ fam_payday ] [ 2 ],
			family_info [ family_id - 1 ] [ fam_payday ] [ 3 ],
			family_info [ family_id - 1 ] [ fam_payday ] [ 4 ],
			family_info [ family_id - 1 ] [ fam_payday ] [ 5 ],
			family_info [ family_id - 1 ] [ fam_payday ] [ 6 ],
			family_info [ family_id - 1 ] [ fam_payday ] [ 7 ],
			family_info [ family_id - 1 ] [ fam_payday ] [ 8 ],
			family_info [ family_id - 1 ] [ fam_payday ] [ 9 ],
			family_info [ family_id - 1 ] [ fam_payday ] [ 10 ],
			family_info [ family_id - 1 ] [ fam_payday ] [ 11 ],
			family_id ) ;
			mysql_tquery ( sql_connection, global_string ) ;
			
			if ( player_open_family [ playerid ] == false ) show_family_dorm ( playerid ) ;
			else
			{
				foreach(new i: family_players[family_id])
				{
					if ( p_info [ i ] [ family ] != family_id ) continue ;
					if ( player_last_page [ i ] != 19 ) continue ;
					
					show_packet_family ( i, 19, 0, 0 ) ;
				}
			}
			return 1 ;
		}
		case d_fam_payday_ft:
		{
			if ( ! response ) return 1 ;
			
			new family_id = p_info [ playerid ] [ family ], _value = strval ( inputtext ) ;
			if ( _value < 0 || _value > 100 )
			{
		        global_string [ 0 ] = EOS ;
				format(global_string, 450, "{"#cWH"}Вы собираетесь изменить следующую конфигурацию:\n\n\t{"#cWH"}Название: {"#cLY"}"family_title" в PayDay (каждый час)\n\t{"#cWH"}Текущее значение: {"#cLY"}%s"valute_title_"\n\n{"#cGRDialog"}* Введите новое значение для данной конфигурации:", GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_payday_ticket ] [ get_player_use_listitem ( playerid ) ] ) ) ;
				show_dialog(playerid, d_fam_payday_ft, DIALOG_STYLE_INPUT, "{"#cBHD"}Изменение конфигурации", global_string, "Выбрать", "Назад" ) ;
				
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нельзя установить менее {"#cRD"}0 "family_title_abb"{"#cGRInfo"} и более {"#cRD"}100 "family_title_abb"{"#cGRInfo"}." ) ;
				return 1 ;
			}
			
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ get_player_use_listitem ( playerid ) ] = _value ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 512, "UPDATE `family` SET `fam_payday_ticket` = '%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d' WHERE `fam_id` = '%d' LIMIT 1",
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ 0 ],
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ 1 ],
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ 2 ],
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ 3 ],
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ 4 ],
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ 5 ],
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ 6 ],
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ 7 ],
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ 8 ],
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ 9 ],
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ 10 ],
			family_info [ family_id - 1 ] [ fam_payday_ticket ] [ 11 ],
			family_id ) ;
			mysql_tquery ( sql_connection, global_string ) ;
			
			if ( player_open_family [ playerid ] == false ) show_family_dorm ( playerid ) ;
			else
			{
				foreach(new i: family_players[family_id])
				{
					if ( p_info [ i ] [ family ] != family_id ) continue ;
					if ( player_last_page [ i ] != 19 ) continue ;
					
					show_packet_family ( i, 19, 0, 0 ) ;
				}
			}
			return 1 ;
		}
		case d_family_warn:
	    {
	        if ( ! response )
	        {
	            clear_player_listitem_values ( playerid ) ;
				clear_sell_params ( playerid, playerid ) ;
	            return 1 ;
	        }
			new warn_id = get_player_listitem_values ( playerid, listitem ),
				player_id = buyer_id [ playerid ],
				family_id = p_info [ playerid ] [ family ],
				scm_string [ 128 ] ;

			clear_player_listitem_values ( playerid ) ;

			p_info [ player_id ] [ fam_warning ] -= 1 ;
			update_int_sql ( player_id, "u_fam_warning", p_info [ player_id ] [ fam_warning ] ) ;
			
			format ( scm_string, sizeof ( scm_string ), "{%s}[FAM] %s %s[%d] снял(а) выговор %s[%i]!",
			family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, p_info [ player_id ] [ name ], player_id ) ;
			family_message ( family_id, col_gray, scm_string ) ;

			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof ( scm_string  ), "DELETE FROM `family_warns` WHERE `f_id` = '%d' LIMIT 1", warn_id ) ;
			mysql_tquery ( sql_connection, scm_string ) ;

			scm_string [ 0 ] = EOS ;
			format ( scm_string, 128, "%s снял(а) выговор %s", p_info [ playerid ] [ name ], p_info [ player_id ] [ name ] ) ;
			write_family ( playerid, family_id, TYPE_LOG_WARN, scm_string ) ;

			clear_sell_params ( playerid, playerid ) ;
	        return 1 ;
	    }
		case d_family_quest:
		{
			if ( ! response ) return 1 ;
			
			if ( listitem == 0 ) used_family_quest ( playerid ) ;
			else if ( listitem == 1 ) show_thief_info ( playerid ) ;
			else if ( listitem == 2 ) show_all_family_quest ( playerid ) ;
			
			return 1 ;
		}
		case d_family_dealer:
		{
			if ( ! response ) return 1 ;
			
			set_player_use_listitem ( playerid, listitem ) ;
			if ( family_dealer_type == 0 )
			{
				static const _dealer_name [ ] [ 25 ] =
				{
					"Бронежилет (1 уровень)",
					"Бронежилет (2 уровень)",
					"Бронежилет (3 уровень)"
				} ;
				
				new header_string [ 32 ] ;
				format ( header_string, sizeof header_string, "{"#cBHD"}Взять %s:", _dealer_name [ listitem ] ) ;
				show_dialog ( playerid, d_family_dealer_get, DIALOG_STYLE_INPUT, header_string, "{"#cWH"}Введите количество, которое желаете взять:", "Взять", "Назад" ) ;
			}
			else if ( family_dealer_type == 1 )
			{
				static const _dealer_name [ ] [ 18 ] =
				{
					"золото",
					"хлопок",
					"колесо",
					"выхлопная труба",
					"элемент крыши",
					"бампер",
					"задний бампер"
				} ;

				new header_string [ 32 ] ;
				format ( header_string, sizeof header_string, "{"#cBHD"}Взять %s:", _dealer_name [ listitem ] ) ;
				show_dialog ( playerid, d_family_dealer_get, DIALOG_STYLE_INPUT, header_string, "{"#cWH"}Введите количество, которое желаете взять:", "Взять", "Назад" ) ;
			}
			return 1 ;
		}
		case d_family_dealer_get:
		{
			if ( ! response ) return 1 ;
			
			new _id = get_player_use_listitem ( playerid ), _value = strval ( inputtext ) ;
			if ( _value < 1 || _value > family_dealer_inventory [ _id ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В поставке нет такого количества предметов." ) ;
			
			if ( family_dealer_type == 0 )
			{
				family_dealer_inventory [ _id ] -= _value ;
				
				static const _dealer_id [ ] = { 1242, 1243, 1244 } ;
				give_player_item_prise ( playerid, _dealer_id [ _id ], _value ) ;
				
				new query_string [ 128 ] ;
				format ( query_string, sizeof ( query_string ), "{"#cGInfo"}* {"#cWH"}Вы взяли с контейнера {"#cGN"}%d{"#cWH"} бронежилетов.", _value ) ;
				SendClientMessage ( playerid, col_white, query_string ) ;

				format(query_string, sizeof ( query_string ), "%s взял(а) с контейнера {3399FF}%i{"#cLB"} бронежилетов", p_info [ playerid ] [ name ], _value ) ;
				send_world_message ( playerid, 25.0, query_string, col_lblue, col_lblue, col_lblue, false ) ;
			}
			else if ( family_dealer_type == 1 )
			{
				static const _dealer_name [ ] [ 18 ] =
				{
					"золота",
					"хлопка",
					"колес",
					"выхлопных труб",
					"элементов крыши",
					"бамперов",
					"задних бамперов"
				} ;
				
				static const _dealer_id [ ] = { 19941, 2684, 1080, 1018, 1038, 1140, 1165 } ;
				
				family_dealer_inventory [ _id ] -= _value ;
				give_player_item_prise ( playerid, _dealer_id [ _id ], _value ) ;
				
				new query_string [ 128 ] ;
				format ( query_string, sizeof ( query_string ), "{"#cGInfo"}* {"#cWH"}Вы взяли с контейнера {"#cGN"}%d{"#cWH"} %s.", _value, _dealer_name [ _id ] ) ;
				SendClientMessage ( playerid, col_white, query_string ) ;

				format(query_string, sizeof ( query_string ), "%s взял(а) с контейнера {3399FF}%i{"#cLB"} %s", p_info [ playerid ] [ name ], _value, _dealer_name [ _id ] ) ;
				send_world_message ( playerid, 25.0, query_string, col_lblue, col_lblue, col_lblue, false ) ;
			}
			return 1 ;
		}
		case d_fam_clothes:
		{
			if ( ! response ) return show_family ( playerid ) ;
			if ( listitem == 5 )
			{
				if ( p_info [ playerid ] [ member ] == 0 )
				{
					new line_string [ 36 ] ;
					global_string [ 0 ] = EOS ;

					for ( new j = 0 ; j < 5 ; j ++ )
					{
						if ( p_info [ playerid ] [ temp_skin ] [ j ] == 0 )
						{
							strcat ( global_string, "{"#cGRDialog"}- Пусто\n" ) ;
						}
						else
						{
							format ( line_string, 36, "{ffffff}Одежда | %d\n", p_info [ playerid ] [ temp_skin ] [ j ] ) ;
							strcat ( global_string, line_string ) ;
						}
					}
					strcat ( global_string, "Одежда организации" ) ;
					show_dialog ( playerid, d_fam_clothes, DIALOG_STYLE_LIST, "{"#cBHD"}Гардероб", global_string, "Выбрать", "Назад" ) ;
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в организации." ) ;
				}
				SetPlayerSkin ( playerid, p_info [ playerid ] [ org_skin ] ) ;
				SetPlayerColor ( playerid, f_info [ p_info [ playerid ] [ member ] - 1 ] [ f_radar_color ] ) ;
				is_fraction_duty { playerid } = 1 ;


				new line_string [ 36 ] ;
				global_string [ 0 ] = EOS ;
				for ( new j = 0 ; j < 5 ; j ++ )
				{
					if ( p_info [ playerid ] [ temp_skin ] [ j ] == 0 )
					{
						strcat ( global_string, "{"#cGRDialog"}- Пусто\n" ) ;
					}
					else
					{
						format ( line_string, 36, "{ffffff}Одежда | %d\n", p_info [ playerid ] [ temp_skin ] [ j ] ) ;
						strcat ( global_string, line_string ) ;
					}
				}
				strcat ( global_string, "Одежда организации" ) ;
				show_dialog ( playerid, d_fam_clothes, DIALOG_STYLE_LIST, "{"#cBHD"}Гардероб", global_string, "Выбрать", "Назад" ) ;
				return 1 ;
			}
			if ( p_info [ playerid ] [ temp_skin ] [ listitem ] == 0 )
			{
				new line_string [ 36 ] ;
				global_string [ 0 ] = EOS ;

				for ( new j = 0 ; j < 5 ; j ++ )
				{
					if ( p_info [ playerid ] [ temp_skin ] [ j ] == 0 )
					{
						strcat ( global_string, "{"#cGRDialog"}- Пусто\n" ) ;
					}
					else
					{
						format ( line_string, 36, "{ffffff}Одежда | %d\n", p_info [ playerid ] [ temp_skin ] [ j ] ) ;
						strcat ( global_string, line_string ) ;
					}
				}
				strcat ( global_string, "Одежда организации" ) ;
				show_dialog ( playerid, d_fam_clothes, DIALOG_STYLE_LIST, "{"#cBHD"}Гардероб", global_string, "Выбрать", "Назад" ) ;
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данном слоте нет одежды." ) ;
			}
			set_skin ( playerid, p_info [ playerid ] [ temp_skin ] [ listitem ] ) ;
			new line_string [ 36 ] ;
			global_string [ 0 ] = EOS ;

			for ( new j = 0 ; j < 5 ; j ++ )
			{
				if ( p_info [ playerid ] [ temp_skin ] [ j ] == 0 )
				{
					strcat ( global_string, "{"#cGRDialog"}- Пусто\n" ) ;
				}
				else
				{
					format ( line_string, 36, "{ffffff}Одежда | %d\n", p_info [ playerid ] [ temp_skin ] [ j ] ) ;
					strcat ( global_string, line_string ) ;
				}
			}
			strcat ( global_string, "Одежда организации" ) ;
			show_dialog ( playerid, d_fam_clothes, DIALOG_STYLE_LIST, "{"#cBHD"}Гардероб", global_string, "Выбрать", "Назад" ) ;
		}
		case d_family_airdrop:
		{
			if ( ! response ) return 1 ;
			
			static const _box_id [ ] = { 164, 165, 166, 167, 168, 169, 170 } ;
			if ( family_airdrop_inventory [ listitem ] < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В контейнере не осталось ящиков с боеприпасами." ) ;
			if ( box_submarine [ playerid ] > 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас уже есть ящик в руках. Отнесите и положите его в фургон." ) ;

			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
			SetPlayerAttachedObject ( playerid, 0, 3013, 6,0.0,0.10,-0.2, -110.0,0.0,78.0 ) ;

			have_box [ playerid ] = true ;
            box_submarine [ playerid ] = listitem + 1 ;

            new scm_string [ 100 ] ;
            format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы взяли '{"#cGN"}%s{"#cWH"}'. Отнесите и положите его в фургон.", item_name ( _box_id [ listitem ] ) ) ;
            SendClientMessage ( playerid, col_white, scm_string ) ;

			ClearAnimations ( playerid ) ;
			p_t_info [ playerid ] [ p_animation ] = true ;
		    ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;

		    family_airdrop_inventory [ listitem ] -= 1 ;
			return 1 ;
		}
		case d_givecar_family:
		{
			if ( ! response ) return 1 ;
			
			new _family_id = p_info [ playerid ] [ family ] ;
			
			new sql_string [ 68 + 9 + 4 ] ;
		    format ( sql_string, sizeof sql_string, "SELECT `sv_owner` FROM `familys_vehicles` WHERE `sv_owner` = '%d' LIMIT %d", _family_id, family_info [ _family_id - 1 ] [ fam_max_car ] ) ;
			mysql_tquery ( sql_connection, sql_string, "check_family_vehicles", "i", playerid ) ;
			return 1 ;
		}
		case d_familys_logs:
	    {
	        if ( ! response )
		    {
		        if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
		        return 1 ;
		    }
	        switch ( listitem )
	        {
	            case 0:
	            {
		            page_count [ playerid ] = 1 ;
		            SetPVarInt ( playerid, "logs_type", TYPE_LOG_AGIVERANK + 1 ) ;

		            new sql_string [ 145 + 9 + 4 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' AND `type` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "logs_type" ) - 1 ) ;
					mysql_tquery(sql_connection, sql_string, "get_familys_logs", "i", playerid);
				}
				case 1:
	            {
		            page_count [ playerid ] = 1 ;
		            SetPVarInt ( playerid, "logs_type", TYPE_LOG_WARN + 1 ) ;

		            new sql_string [ 145 + 9 + 4 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' AND `type` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "logs_type" ) - 1 ) ;
					mysql_tquery(sql_connection, sql_string, "get_familys_logs", "i", playerid);
				}
				case 2:
	            {
		            page_count [ playerid ] = 1 ;
		            SetPVarInt ( playerid, "logs_type", TYPE_LOG_BL + 1 ) ;

		            new sql_string [ 145 + 9 + 4 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' AND `type` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "logs_type" ) - 1 ) ;
					mysql_tquery(sql_connection, sql_string, "get_familys_logs", "i", playerid);
				}
                case 3:
	            {
		            page_count [ playerid ] = 1 ;
		            SetPVarInt ( playerid, "logs_type", TYPE_LOG_INVITE + 1 ) ;

		            new sql_string [ 145 + 9 + 4 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' AND `type` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "logs_type" ) - 1 ) ;
					mysql_tquery(sql_connection, sql_string, "get_familys_logs", "i", playerid);
				}
				case 4:
	            {
		            page_count [ playerid ] = 1 ;
		            SetPVarInt ( playerid, "logs_type", TYPE_LOG_UVAL + 1 ) ;

		            new sql_string [ 145 + 9 + 4 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' AND `type` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "logs_type" ) - 1 ) ;
					mysql_tquery(sql_connection, sql_string, "get_familys_logs", "i", playerid);
				}
				case 5:
	            {
		            page_count [ playerid ] = 1 ;
		            SetPVarInt ( playerid, "logs_type", TYPE_LOG_OBWYAK + 1 ) ;

		            new sql_string [ 145 + 9 + 4 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' AND `type` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "logs_type" ) - 1 ) ;
					mysql_tquery(sql_connection, sql_string, "get_familys_logs", "i", playerid);
				}
	        }
			return 1 ;
	    }
	    case d_familys_logback:
		{
		    if ( ! response )
		    {
		        DeletePVar ( playerid, "logs_type" ) ;

		        if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
		        return 1 ;
		    }

		    new sql_string [ 145 + 9 + 4 ] ;
			format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' AND `type` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "logs_type" ) - 1 ) ;
			mysql_tquery(sql_connection, sql_string, "get_familys_logs", "i", playerid);
			return 1 ;
		}
	    case d_familys_lognext:
		{
			if ( ! response )
			{
			    clear_player_listitem_values ( playerid ) ;
			    if ( page_count [ playerid ] == 1 )
				{
					page_count [ playerid ] = 0 ;
					page_rows [ playerid ] = 0 ;
					DeletePVar ( playerid, "logs_type" ) ;
				}
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}

			if ( listitem == get_player_use_page ( playerid, 0 ) )
			{
				clear_player_use_page ( playerid ) ;
			    if ( page_count [ playerid ] == 1 )
				{
				    clear_player_listitem_values ( playerid ) ;
					page_count [ playerid ] = 0 ;
					page_rows [ playerid ] = 0 ;
					DeletePVar ( playerid, "logs_type" ) ;
					show_family ( playerid ) ;
					return 1 ;
				}
				else
				{
					new sql_string [ 145 + 9 + 4 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' AND `type` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "logs_type" ) - 1 ) ;
					mysql_tquery(sql_connection, sql_string, "get_familys_logs", "i", playerid);

					page_count [ playerid ] -= 1 ;
				}
				return 1 ;
			}
			else if ( listitem == get_player_use_page ( playerid, 1 ) )
			{
				clear_player_use_page ( playerid ) ;
			    if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице логов." ) ;

				    new sql_string [ 145 + 9 + 4 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' AND `type` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "logs_type" ) - 1 ) ;
					mysql_tquery(sql_connection, sql_string, "get_familys_logs", "i", playerid);

					page_count [ playerid ] = page_count [ playerid ] ;
					return 1 ;
				}

    			new sql_string [ 145 + 9 + 4 ] ;
				format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' AND `type` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "logs_type" ) - 1 ) ;
				mysql_tquery(sql_connection, sql_string, "get_familys_logs", "i", playerid);

				page_count [ playerid ] += 1 ;
				return 1 ;
			}
			new select_id = get_player_listitem_values ( playerid, listitem ) ;

			clear_player_listitem_values ( playerid ) ;

			new sql_string [ 56 + 9 ] ;
			format ( sql_string, sizeof sql_string, "SELECT * FROM `logs_family` WHERE `id` = '%d' LIMIT 1", select_id ) ;
			mysql_tquery(sql_connection, sql_string, "get_familys_logs_info", "i", playerid);
			return 1 ;
		}
		case d_family_logback:
		{
		    if ( ! response )
		    {
		        if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
		        return 1 ;
		    }

  			new sql_string [ 127 + 9 ] ;
			format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ] ) ;
			mysql_tquery(sql_connection, sql_string, "logs_family", "i", playerid);
			return 1 ;
		}
		case d_family_lognext:
		{
			if ( ! response )
			{
			    clear_player_listitem_values ( playerid ) ;
			    if ( page_count [ playerid ] == 1 )
				{
					page_count [ playerid ] = 0 ;
					page_rows [ playerid ] = 0 ;
				}
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}

			if ( listitem == get_player_use_page ( playerid, 0 ) )
			{
				clear_player_use_page ( playerid ) ;
			    if ( page_count [ playerid ] == 1 )
				{
				    clear_player_listitem_values ( playerid ) ;
					page_count [ playerid ] = 0 ;
					page_rows [ playerid ] = 0 ;
					show_family ( playerid ) ;
					return 1 ;
				}
				else
				{
					new sql_string [ 127 + 9 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ] ) ;
					mysql_tquery(sql_connection, sql_string, "logs_family", "i", playerid);

					page_count [ playerid ] -= 1 ;
				}
				return 1 ;
			}
			else if ( listitem == get_player_use_page ( playerid, 1 ) )
			{
				clear_player_use_page ( playerid ) ;
			    if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице логов." ) ;

					new sql_string [ 127 + 9 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ] ) ;
					mysql_tquery(sql_connection, sql_string, "logs_family", "i", playerid);

					page_count [ playerid ] = page_count [ playerid ] ;
					return 1 ;
				}

				new sql_string [ 127 + 9 ] ;
				format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `family` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ] ) ;
				mysql_tquery(sql_connection, sql_string, "logs_family", "i", playerid);

				page_count [ playerid ] += 1 ;
				return 1 ;
			}
			new select_id = get_player_listitem_values ( playerid, listitem ) ;

			clear_player_listitem_values ( playerid ) ;
			page_rows [ playerid ] = 0 ;

			new sql_string [ 56 + 9 ] ;
			format ( sql_string, sizeof sql_string, "SELECT * FROM `logs_family` WHERE `id` = '%d' LIMIT 1", select_id ) ;
			mysql_tquery(sql_connection, sql_string, "logs_info_family", "i", playerid);
			return 1 ;
		}
		case d_allfamily:
		{
			if ( ! response )
			{
			    clear_player_listitem_values ( playerid ) ;
				page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
				return 1 ;
			}

            if ( listitem == get_player_use_page ( playerid, 0 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( page_count [ playerid ] == 1 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка семей." ) ;
					page_count [ playerid ] = page_count [ playerid ] ;

					show_allfamily ( playerid ) ;
					return 1;
				}
                page_count [ playerid ] -= 1 ;

                show_allfamily ( playerid ) ;
				return 1 ;
            }

            else if ( listitem == get_player_use_page ( playerid, 1 ) )
            {
				clear_player_use_page ( playerid ) ;
                if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
            	{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка семей." ) ;
					page_count [ playerid ] = page_count [ playerid ] ;

					show_allfamily ( playerid ) ;
					return 1;
				}
                page_count [ playerid ] += 1 ;

                show_allfamily ( playerid ) ;
				return 1 ;
            }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			SetPVarInt ( playerid, "fam_id_select", select_id ) ;

            new line_string [ 64 ] ;
            format ( line_string, sizeof line_string, "{"#cBHD"}{%s}%s", family_info [ select_id ] [ fam_chat_color ], family_info [ select_id ] [ fam_name ] ) ;

            global_string [ 0 ] = EOS ;
			format ( global_string, 650, "{"#cBL"}1. {"#cWH"}Изменить создателя\n{"#cBL"}2. {"#cWH"}Изменить название\n{"#cBL"}3. {"#cWH"}Изменить "family_title"\n{"#cBL"}4. {"#cWH"}Изменить кол-во слотов для т/с\n \n{"#cGRDialog"}- Создатель: {"#cWH"}%s\n{"#cGRDialog"}- "family_title": {"#cWH"}%d\n{"#cGRDialog"}- Слотов для т/с: {"#cWH"}%d\n{"#cGRDialog"}- Банк семьи: {"#cWH"}%d"valute_title_"", family_info [ select_id ] [ fam_creator ], family_info [ select_id ] [ fam_ticket ], family_info [ select_id ] [ fam_max_car ], family_info [ select_id ] [ fam_bank ] ) ;
            show_dialog(playerid, d_allfamily_select, DIALOG_STYLE_LIST, line_string, global_string, "Выбрать", "Закрыть" ) ;

            clear_player_listitem_values ( playerid ) ;
			page_count [ playerid ] = 0 ;
			page_rows [ playerid ] = 0 ;
			return 1 ;
		}
		case d_allfamily_select:
		{
		    if ( ! response ) return callcmd::allfamily ( playerid, "" ), DeletePVar ( playerid, "fam_id_select" ) ;
			switch ( listitem )
			{
			    case 0:
			    {
			        if( admin_info [ playerid ] [ admin ] < 8 ) return DeletePVar ( playerid, "fam_id_select" ) ;
			        if ( ! GetString ( p_info [ playerid ] [ name ], founder_name ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, Вам данная функция не доступна." ) ;
			        new select_id = GetPVarInt ( playerid, "fam_id_select" ) ;
			        
			        new line_string [ 64 ] ;
            		format ( line_string, sizeof line_string, "{"#cBHD"}{%s}%s", family_info [ select_id ] [ fam_chat_color ], family_info [ select_id ] [ fam_name ] ) ;
           	 		show_dialog(playerid, d_allfamily_creator, DIALOG_STYLE_INPUT, line_string, "{FFFFFF}Введите ID игрока, которого хотите установить создателем:", "Выбрать", "Закрыть" ) ;
			    }
			    case 1:
			    {
			        if( admin_info [ playerid ] [ admin ] < 8 ) return DeletePVar ( playerid, "fam_id_select" ) ;
                    if ( ! GetString ( p_info [ playerid ] [ name ], founder_name ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, Вам данная функция не доступна." ) ;
			        new select_id = GetPVarInt ( playerid, "fam_id_select" ) ;

			        new line_string [ 64 ] ;
            		format ( line_string, sizeof line_string, "{"#cBHD"}{%s}%s", family_info [ select_id ] [ fam_chat_color ], family_info [ select_id ] [ fam_name ] ) ;
           	 		show_dialog(playerid, d_allfamily_name, DIALOG_STYLE_INPUT, line_string, "{FFFFFF}Введите название, которое хотите установить для семьи:", "Выбрать", "Закрыть" ) ;
			    }
			    case 2:
			    {
			        if( admin_info [ playerid ] [ admin ] < 8 ) return DeletePVar ( playerid, "fam_id_select" ) ;
                    if ( ! GetString ( p_info [ playerid ] [ name ], founder_name ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, Вам данная функция не доступна." ) ;
			        new select_id = GetPVarInt ( playerid, "fam_id_select" ) ;

			        new line_string [ 64 ] ;
            		format ( line_string, sizeof line_string, "{"#cBHD"}{%s}%s", family_info [ select_id ] [ fam_chat_color ], family_info [ select_id ] [ fam_name ] ) ;
           	 		show_dialog(playerid, d_allfamily_ticket, DIALOG_STYLE_INPUT, line_string, "{FFFFFF}Введите количество "family_title", которое хотите выдать семье:", "Выбрать", "Закрыть" ) ;
			    }
			    case 3:
			    {
			        if( admin_info [ playerid ] [ admin ] < 8 ) return DeletePVar ( playerid, "fam_id_select" ) ;
                    if ( ! GetString ( p_info [ playerid ] [ name ], founder_name ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, Вам данная функция не доступна." ) ;
			        new select_id = GetPVarInt ( playerid, "fam_id_select" ) ;

			        new line_string [ 64 ] ;
            		format ( line_string, sizeof line_string, "{"#cBHD"}{%s}%s", family_info [ select_id ] [ fam_chat_color ], family_info [ select_id ] [ fam_name ] ) ;
           	 		show_dialog(playerid, d_allfamily_cars, DIALOG_STYLE_INPUT, line_string, "{FFFFFF}Введите количество слотов для т/с, которое хотите установить семье:", "Выбрать", "Закрыть" ) ;
			    }
			}
			return 1 ;
		}
		case d_allfamily_cars:
		{
		    if ( ! response ) return callcmd::allfamily ( playerid, "" ), DeletePVar ( playerid, "fam_id_select" ) ;

		    new _ticket = strval ( inputtext ), familyid = GetPVarInt ( playerid, "fam_id_select" ) ;
		    if ( _ticket < 1 || _ticket > 50 )
			{
				new line_string [ 64 ] ;
            	format ( line_string, sizeof line_string, "{"#cBHD"}{%s}%s", family_info [ familyid ] [ fam_chat_color ], family_info [ familyid ] [ fam_name ] ) ;
           	 	show_dialog(playerid, d_allfamily_cars, DIALOG_STYLE_INPUT, line_string, "{FFFFFF}Введите количество слотов для т/с, которое хотите установить семье:\n\n{"#cGRDialog"}* Нельзя менее 1 и более 50", "Выбрать", "Закрыть" ) ;
				return 1 ;
			}

			family_info [ familyid ] [ fam_max_car ] += _ticket ;

			new query [ 144 ] ;
			mysql_format ( sql_connection, query, sizeof query, "UPDATE `family` SET `fam_max_car` = `fam_max_car` + '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ familyid ] [ fam_max_car ], family_info [ familyid ] [ fam_id ] ) ;
            mysql_tquery ( sql_connection, query ) ;
            
            format(query, 128, "%s выдал семье %s слотов для т/с (+%d).", p_info [ playerid ] [ name ], family_info [ familyid ] [ fam_name ], _ticket ) ;
			WriteLog(playerid, TYPE_LOG_ADMIN, query);

			callcmd::allfamily ( playerid, "" ), DeletePVar ( playerid, "fam_id_select" ) ;
			return 1 ;
		}
		case d_allfamily_ticket:
		{
		    if ( ! response ) return callcmd::allfamily ( playerid, "" ), DeletePVar ( playerid, "fam_id_select" ) ;

		    new _ticket = strval ( inputtext ), familyid = GetPVarInt ( playerid, "fam_id_select" ) ;
		    if ( _ticket > 100000 )
			{
				new line_string [ 64 ] ;
            	format ( line_string, sizeof line_string, "{"#cBHD"}{%s}%s", family_info [ familyid ] [ fam_chat_color ], family_info [ familyid ] [ fam_name ] ) ;
           	 	show_dialog(playerid, d_allfamily_ticket, DIALOG_STYLE_INPUT, line_string, "{FFFFFF}Введите количество "family_title", которое хотите выдать семье:\n\n{"#cGRDialog"}* Вы не можете выдать более 100.000 "family_title"", "Выбрать", "Закрыть" ) ;
				return 1 ;
			}
			
			family_info [ familyid ] [ fam_ticket ] += _ticket ;

			new query [ 144 ] ;
			mysql_format ( sql_connection, query, sizeof query, "UPDATE `family` SET `fam_ticket` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ familyid ] [ fam_ticket ], family_info [ familyid ] [ fam_id ] ) ;
            mysql_tquery ( sql_connection, query ) ;
            
            format(query, 128, "%s выдал семье %s "family_title" (+%d).", p_info [ playerid ] [ name ], family_info [ familyid ] [ fam_name ], _ticket ) ;
			WriteLog(playerid, TYPE_LOG_ADMIN, query);

			callcmd::allfamily ( playerid, "" ), DeletePVar ( playerid, "fam_id_select" ) ;
			return 1 ;
		}
		case d_allfamily_name:
		{
		    if ( ! response ) return callcmd::allfamily ( playerid, "" ), DeletePVar ( playerid, "fam_id_select" ) ;

		    new familyid = GetPVarInt ( playerid, "fam_id_select" ) ;
		    if ( strlen ( inputtext ) < 3 || strlen ( inputtext ) > 32 )
			{
				new line_string [ 64 ] ;
            	format ( line_string, sizeof line_string, "{"#cBHD"}{%s}%s", family_info [ familyid ] [ fam_chat_color ], family_info [ familyid ] [ fam_name ] ) ;
           	 	show_dialog(playerid, d_allfamily_name, DIALOG_STYLE_INPUT, line_string, "{FFFFFF}Введите название, которое хотите установить для семьи:\n\n{"#cGRDialog"}* Длина названия не может быть менее 3 и более 32 символов", "Выбрать", "Закрыть" ) ;
				return 1 ;
			}

			new query [ 144 ] ;
			mysql_format ( sql_connection, query, sizeof query, "UPDATE `family` SET `fam_name` = '%e' WHERE `fam_id` = '%d' LIMIT 1", inputtext, family_info [ familyid ] [ fam_id ] ) ;
            mysql_tquery ( sql_connection, query ) ;
            
            format(query, 128, "%s переименовал семью %s на %s.", p_info [ playerid ] [ name ], family_info [ familyid ] [ fam_name ], inputtext ) ;
			WriteLog(playerid, TYPE_LOG_ADMIN, query);

			format ( family_info [ familyid ] [ fam_name ], 68, inputtext ) ;

			new _fam_jackdaw [ 28 ] ;
			switch ( family_info [ familyid ] [ fam_enhancement ] [ 9 ] )
			{
			    case 0: format ( _fam_jackdaw, sizeof _fam_jackdaw, "" ) ;
			    default: format ( _fam_jackdaw, sizeof _fam_jackdaw, "[{%s}%s{"#cWH"}] ", family_info [ familyid ] [ fam_chat_color ], fam_jackdaw [ family_info [ familyid ] [ fam_enhancement ] [ 9 ] ] ) ;
			}
			
			format ( query, 128, "%s{%s}%s {"#cWH3D"}%s", _fam_jackdaw, family_info [ familyid ] [ fam_chat_color ], family_info [ familyid ] [ fam_name ], fam_brand [ family_info [ familyid ] [ fam_enhancement ] [ 10 ] ] ) ;
			foreach(new i: family_players[familyid + 1])
			{
				if ( p_info [ i ] [ family ] != familyid + 1 ) continue ;
				
				if ( IsValidDynamic3DTextLabel ( p_info [ i ] [ family_text ] ) ) UpdateDynamic3DTextLabelText ( p_info [ i ] [ family_text ], -1, query ) ;
			}

			if ( family_info [ familyid ] [ fam_house ] )
		   	{
		   	    if ( Iter_Count(family_vehicles[familyid + 1]) != 0 )
		  	    {
					foreach(new i: family_vehicles[familyid + 1]) veh_plate ( i ) ;
				}
			}

			if ( gdorm_family_text [ familyid ] != Text3D:INVALID_3DTEXT_ID ) update_fdorm_text ( familyid + 1 ) ;

			format ( query, 144, "{"#cGInfo"}* {"#cWH"}Вы успешно переименовали семью {"#cGN"}%s{"#cWH"}.", family_info [ familyid ] [ fam_name ] ) ;
            SendClientMessage(playerid, col_white, query);

			callcmd::allfamily ( playerid, "" ), DeletePVar ( playerid, "fam_id_select" ) ;
			return 1 ;
		}
		case d_allfamily_creator:
		{
		    if ( ! response ) return callcmd::allfamily ( playerid, "" ), DeletePVar ( playerid, "fam_id_select" ) ;

		    new player_id = strval ( inputtext ), familyid = GetPVarInt ( playerid, "fam_id_select" ) ;
		    if ( player_id < 0 )
			{
				new line_string [ 64 ] ;
            	format ( line_string, sizeof line_string, "{"#cBHD"}{%s}%s", family_info [ familyid ] [ fam_chat_color ], family_info [ familyid ] [ fam_name ] ) ;
           	 	show_dialog(playerid, d_allfamily_creator, DIALOG_STYLE_INPUT, line_string, "{FFFFFF}Введите ID игрока, которого хотите установить создателем:\n\n{"#cGRDialog"}* Не правильно указан ID игрока", "Выбрать", "Закрыть" ) ;
				return 1 ;
			}
			if ( ! IsPlayerConnected ( player_id ) )
			{
				new line_string [ 64 ] ;
            	format ( line_string, sizeof line_string, "{"#cBHD"}{%s}%s", family_info [ familyid ] [ fam_chat_color ], family_info [ familyid ] [ fam_name ] ) ;
           	 	show_dialog(playerid, d_allfamily_creator, DIALOG_STYLE_INPUT, line_string, "{FFFFFF}Введите ID игрока, которого хотите установить создателем:\n\n{"#cGRDialog"}* Данный игрок не в сети", "Выбрать", "Закрыть" ) ;
                return 1 ;
			}
			format ( family_info [ familyid ] [ fam_creator ], MAX_PLAYER_NAME, "%s", p_info [ player_id ] [ name ] ) ;

			new query [ 144 ] ;
			format ( query, sizeof ( query ), "UPDATE `family` SET `fam_creator` = '%s' WHERE `fam_id` = '%d' LIMIT 1", family_info [ familyid ] [ fam_creator ], family_info [ familyid ] [ fam_id ] ) ;
			mysql_tquery ( sql_connection, query ) ;
			
			p_info [ player_id ] [ family ] = familyid + 1 ;
			update_int_sql ( player_id, "u_family", p_info [ player_id ] [ family ] ) ;

			p_info [ player_id ] [ family_rang ] = family_info [ familyid ] [ fam_settings ] [ 3 ] ;
			update_int_sql ( player_id, "u_family_rank", p_info [ player_id ] [ family_rang ] ) ;

			format ( query, sizeof query, "{"#cGInfo"}* {"#cGRInfo"}Теперь Вы новый лидер семьи {%s}%s{"#cGRInfo"}.", family_info [ familyid ] [ fam_chat_color ], family_info [ familyid ] [ fam_name ] ) ;
			SendClientMessage ( player_id, col_gray, query ) ;
			
			new text_str [ 128 ] ;
			if ( p_info [ player_id ] [ family_text ] != Text3D:INVALID_3DTEXT_ID )
			{
				DestroyDynamic3DTextLabel ( p_info [ player_id ] [ family_text ] ) ;
				p_info [ player_id ] [ family_text ] = Text3D:INVALID_3DTEXT_ID ;
			}
			
			new _fam_jackdaw [ 28 ] ;
			switch ( family_info [ familyid ] [ fam_enhancement ] [ 9 ] )
			{
			    case 0: format ( _fam_jackdaw, sizeof _fam_jackdaw, "" ) ;
			    default: format ( _fam_jackdaw, sizeof _fam_jackdaw, "[{%s}%s{"#cWH3D"}] ", family_info [ familyid ] [ fam_chat_color ], fam_jackdaw [ family_info [ familyid ] [ fam_enhancement ] [ 9 ] ] ) ;
			}
			
			format ( text_str, sizeof text_str, "%s{%s}%s {"#cWH3D"}%s", _fam_jackdaw, family_info [ familyid ] [ fam_chat_color ], family_info [ familyid ] [ fam_name ], fam_brand [ family_info [ familyid ] [ fam_enhancement ] [ 10 ] ] ) ;
			p_info [ player_id ] [ family_text ] = CreateDynamic3DTextLabel( text_str, col_white, 0.0, 0.0, 0.0, family_text_size, player_id, INVALID_VEHICLE_ID, 1 ) ;

			callcmd::allfamily ( playerid, "" ), DeletePVar ( playerid, "fam_id_select" ) ;
			return 1 ;
		}
		case d_family_prise:
		{
		    if ( ! response ) return 1 ;
    		
			if ( listitem == MAX_FAMILY_TRADE_ITEM - 1 )
			{
				if ( ! p_info [ playerid ] [ family ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
				
				new family_id = p_info [ playerid ] [ family ] ;
			    if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Покупать может только лидер семьи." ) ;
					return 1 ;
				}

				if ( family_info [ family_id - 1 ] [ fam_ticket ] < family_trade [ listitem ] [ family_price ] )
				{
				    SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}На балансе Вашей семьи недостаточно "family_title"." ) ;
				    return 1 ;
				}
				
				new _h_id = family_info [ family_id - 1 ] [ fam_house ] ;
				if ( _h_id < 1 )
				{
					send_check_cinfo ( playerid, "У Вашей семьи нет дома!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( h_info [ _h_id - 1 ] [ h_podezd ] != -1 )
				{
					send_check_cinfo ( playerid, "У Вашей семьи не частный дом!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( family_info [ family_id - 1 ] [ fam_max_car ] + 1 > 10 )
				{
				    SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Семья не может иметь более 10 парковочных мест." ) ;
				    return 1 ;
				}
			
			    family_info [ family_id - 1 ] [ fam_ticket ] -= family_trade [ listitem ] [ family_price ] ;
			
			    family_info [ family_id - 1 ] [ fam_max_car ] ++ ;
			    
			    new sql_string [ 144 ] ;
			    format ( sql_string, sizeof sql_string, "UPDATE `family` SET `fam_max_car` = '%d', `fam_ticket` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_max_car ], family_info [ family_id - 1 ] [ fam_ticket ], family_id ) ;
		    	mysql_tquery(sql_connection, sql_string ) ;
		    	
		    	format(sql_string, sizeof sql_string, "%s купил(а) %s за %d семейных талонов.", p_info [ playerid ] [ name ], family_trade [ listitem ] [ family_name ], family_trade [ listitem ] [ family_price ] ) ;
				write_family(playerid, family_id, TYPE_LOG_OBWYAK, sql_string);
			}
			else
			{
			    if ( p_info [ playerid ] [ family_ticket ] < family_trade [ listitem ] [ family_price ] )
				{
				    SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно "family_title"." ) ;
				    return 1 ;
				}
			
			    p_info [ playerid ] [ family_ticket ] -= family_trade [ listitem ] [ family_price ] ;
				update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;

				new _inv_type = family_trade [ listitem ] [ family_inv_type ] ;
				if ( _inv_type == GIVE_TYPE_INVENTORY )
				{
					give_player_item_prise ( playerid, family_trade [ listitem ] [ family_prise ], 1 ) ;
					SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cWH"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cWH"}." ) ;
				}
				else if ( _inv_type == GIVE_TYPE_ACESSORIES )
				{
					give_player_item ( playerid, family_trade [ listitem ] [ family_prise ] ) ;
					SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cWH"}Используйте {"#cBL"}\"/mm - Инвентарь - Аксессуары\"{"#cWH"}." ) ;
				}
				
				new query_string [ 128 ] ;
				format ( query_string, sizeof query_string, "%s приобрел(а) %s за семейные талоны.", p_info [ playerid ] [ name ], family_trade [ listitem ] [ family_name ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_FAMTRADE, query_string ) ;
			}
			return 1 ;
		}
		case d_offamily_logback:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
				page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
				DeletePVar ( playerid, "ofm_listitem" ) ;
				DeletePVar ( playerid, "ofm_type" ) ;

		        show_family ( playerid ) ;
		        return 1 ;
		    }

  			new pvar_string [ 38 ],
				pl_name [ MAX_PLAYER_NAME ] ;
			format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
			GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;

		   	new sql_string [ 125 + MAX_PLAYER_NAME ] ;
			format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `name` = '%s' ORDER BY `logs_family`.`id` DESC LIMIT 200", pl_name ) ;
			mysql_tquery(sql_connection, sql_string, "logs_player_family", "i", playerid);
			return 1 ;
		}
	    case d_offamily_lognext:
		{
			if ( ! response )
			{
			    clear_player_listitem_values ( playerid ) ;
			    if ( page_count [ playerid ] == 1 )
				{
					page_count [ playerid ] = 0 ;
					page_rows [ playerid ] = 0 ;
				}
				return 1 ;
			}

            if ( listitem == get_player_use_page ( playerid, 0 ) )
			{
				clear_player_use_page ( playerid ) ;
			    if ( page_count [ playerid ] == 1 )
				{
				    clear_player_listitem_values ( playerid ) ;
					page_count [ playerid ] = 0 ;
					page_rows [ playerid ] = 0 ;
					DeletePVar ( playerid, "ofm_listitem" ) ;
					DeletePVar ( playerid, "ofm_type" ) ;
					return 1 ;
				}
				else
				{
					new pvar_string [ 38 ],
						pl_name [ MAX_PLAYER_NAME ] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
					GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;

				    new sql_string [ 125 + MAX_PLAYER_NAME ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `name` = '%s' ORDER BY `logs_family`.`id` DESC LIMIT 200", pl_name ) ;
					mysql_tquery(sql_connection, sql_string, "logs_player_family", "i", playerid);

     				page_count [ playerid ] -= 1 ;
				}
				return 1 ;
			}
			else if ( listitem == get_player_use_page ( playerid, 1 ) )
			{
				clear_player_use_page ( playerid ) ;
			    if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице логов." ) ;

					new pvar_string [ 38 ],
						pl_name [ MAX_PLAYER_NAME ] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
					GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;

				    new sql_string [ 125 + MAX_PLAYER_NAME ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `name` = '%s' ORDER BY `logs_family`.`id` DESC LIMIT 200", pl_name ) ;
					mysql_tquery(sql_connection, sql_string, "logs_player_family", "i", playerid);

					page_count [ playerid ] = page_count [ playerid ] ;
					return 1 ;
				}

				new pvar_string [ 38 ],
					pl_name [ MAX_PLAYER_NAME ] ;
				format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
				GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;

			    new sql_string [ 125 + MAX_PLAYER_NAME ] ;
				format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `name` = '%s' ORDER BY `logs_family`.`id` DESC LIMIT 200", pl_name ) ;
				mysql_tquery(sql_connection, sql_string, "logs_player_family", "i", playerid);

				page_count [ playerid ] += 1 ;
				return 1 ;
			}
			new select_id = get_player_listitem_values ( playerid, listitem ) ;

			clear_player_listitem_values ( playerid ) ;

			new sql_string [ 56 + 9 ] ;
			format ( sql_string, sizeof sql_string, "SELECT * FROM `logs_family` WHERE `id` = '%d' LIMIT 1", select_id ) ;
			mysql_tquery(sql_connection, sql_string, "logs_player_family_info", "i", playerid);
			return 1 ;
		}
		case d_offmembers_list4:
		{
			if ( ! response )
			{
				for ( new i = 0 ; i < 10 ; i ++ )
				{
					new pvar_string [ 8 ] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", i ) ;
					DeletePVar ( playerid, pvar_string ) ;
				}
				page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
				DeletePVar ( playerid, "ofm_listitem" ) ;
				DeletePVar ( playerid, "ofm_type" ) ;
				return 1 ;
			}
			if ( listitem == get_player_use_page ( playerid, 0 ) )
			{
				clear_player_use_page ( playerid ) ;
				new page_id = page_count [ playerid ] - 1;
				if ( page_id == 0 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице чёрного списка." ) ;
					if( ! GetPVarInt ( playerid, "ofm_type" ) )
					{
					    new sql_string [ 79 + 9 ] ;
						format ( sql_string, sizeof sql_string, "SELECT `bl_name`,`bl_date` FROM `familys_blacklist` WHERE `bl_family` = '%d'", p_info [ playerid ] [ family ] ) ;
						mysql_tquery ( sql_connection, sql_string, "callback_bl_family", "i", playerid ) ;
						return 1;
					}
					return 1 ;

				}
				page_count [ playerid ] = page_id ;

				if( ! GetPVarInt ( playerid, "ofm_type" ) )
				{
					new sql_string [ 79 + 9 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `bl_name`,`bl_date` FROM `familys_blacklist` WHERE `bl_family` = '%d'", p_info [ playerid ] [ family ] ) ;
					mysql_tquery ( sql_connection, sql_string, "callback_bl_family", "i", playerid ) ;
					return 1;
				}

			}
			else if ( listitem == get_player_use_page ( playerid, 1 ) )
			{
				clear_player_use_page ( playerid ) ;
				new page_id = page_count [ playerid ] - 1 ;
				if ( ofm_formula ( page_id ) >= page_rows [ playerid ] )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице чёрного списка." ) ;
					if( ! GetPVarInt ( playerid, "ofm_type" ) )
					{
						new sql_string [ 79 + 9 ] ;
						format ( sql_string, sizeof sql_string, "SELECT `bl_name`,`bl_date` FROM `familys_blacklist` WHERE `bl_family` = '%d'", p_info [ playerid ] [ family ] ) ;
						mysql_tquery ( sql_connection, sql_string, "callback_bl_family", "i", playerid ) ;
						return 1;
					}
					return 1 ;
				}
				page_count [ playerid ] = page_id + 2 ;
				if( ! GetPVarInt ( playerid, "ofm_type" ) )
				{
					new sql_string [ 79 + 9 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `bl_name`,`bl_date` FROM `familys_blacklist` WHERE `bl_family` = '%d'", p_info [ playerid ] [ family ] ) ;
					mysql_tquery ( sql_connection, sql_string, "callback_bl_family", "i", playerid ) ;
					return 1;
				}
			}
			else
			{
				new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
				format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", listitem ) ;
				GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;
				SetPVarInt ( playerid, "ofm_listitem", listitem ) ;

				show_offmembers_dialog ( playerid, pl_name, 4 ) ;
			}
			return 1 ;
		}

		case d_offmembers_pl_menu4:
		{
			if ( ! response )
			{
				DeletePVar( playerid, "ofm_listitem" ) ;
				if( ! GetPVarInt ( playerid, "ofm_type" ) )
				{
					new sql_string [ 79 + 9 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `bl_name`,`bl_date` FROM `familys_blacklist` WHERE `bl_family` = '%d'", p_info [ playerid ] [ family ] ) ;
					mysql_tquery ( sql_connection, sql_string, "callback_bl_family", "i", playerid ) ;
					return 1;
				}
				return 1 ;
			}
			switch ( listitem )
			{
				case 0:
				{
					new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
					GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;
					
					new query_string [ 102 + MAX_PLAYER_NAME ] ;
					mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `bl_date`, `bl_reason`, `bl_add_name` FROM `familys_blacklist` WHERE `bl_name` = '%s' LIMIT 1", pl_name ) ;
					mysql_tquery ( sql_connection, query_string, "callback_bl_family_info", "i", playerid ) ;
				}
				case 1:
				{
					new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
					GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;
					format ( pvar_string, sizeof ( pvar_string ), "{"#cBL"}%s", pl_name ) ;

					new query_string [ 138 ] ;
					mysql_format ( sql_connection, query_string, sizeof ( query_string ),"SELECT `bl_player` FROM `familys_blacklist` WHERE `bl_name` = '%e' AND `bl_family`='%d' LIMIT 1",
					pl_name, p_info [ playerid ] [ family ] ) ;
					mysql_tquery ( sql_connection, query_string, "check_bl_list_family", "dsd", playerid, pl_name, 1 ) ;

					DeletePVar( playerid, "ofm_listitem" ) ;
				}
			}
			return 1 ;
		}
		case d_offmembers_pl_menu_info4:
		{
			new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
			format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
			GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;

            show_offmembers_dialog ( playerid, pl_name, 4 ) ;
			return 1 ;
		}
		case d_home_family_select:
		{
		    if ( ! response )
		    {
		        clear_player_listitem_values ( playerid ) ;
		        return 1 ;
		    }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			p_info [ playerid ] [ house ] = select_id ;

			clear_player_listitem_values ( playerid ) ;
		    
		    new house_id = p_info [ playerid ] [ house ] - 1, family_id = p_info [ playerid ] [ family ] ;
			if ( house_int [ h_info [ house_id ] [ h_int ] - 1 ] [ hint_class ] < max_class - 2 )
			{
				show_family ( playerid ) ;

				new scm_string [ 144 ] ;
				format ( scm_string, sizeof scm_string, "{"#cRInfo"}* {"#cGRInfo"}Домом семьи можно устанавливать только дома класса: {"#cRD"}%s{"#cGRInfo"} и выше.", house_classes [ max_class - 2 ] ) ;
				SendClientMessage ( playerid, col_gray, scm_string ) ;
				return 1 ;
			}

			new fm_string [ 128 ] ;
	        format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] %s %s[%i] установил(а) дом №%d, как дом семьи.", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, house_id + 1 ) ;
	        family_message ( family_id, col_gray, fm_string ) ;

			family_info [ family_id - 1 ] [ fam_house ] = house_id + 1 ;

			format(fm_string, sizeof(fm_string), "UPDATE `family` SET `fam_house` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_house ], family_id ) ;
			mysql_tquery(sql_connection, fm_string);

			add_family_house ( house_id, 1 ) ;

			if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
			else send_check_cinfo ( playerid, "Вы установили семейный дом.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
			return 1 ;
		}
		case d_sellft_accept:
		{
			if ( seller_id [ playerid ] == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Продавец покинул игру." ) ;
			if ( ! response )
			{
				SendClientMessage ( seller_id [ playerid ], col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок отказался от покупки "family_title"." ) ;
				clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			new target_id = seller_id [ playerid ] ;
			if ( p_info [ playerid ] [ money ] < sell_price [ target_id ] )
			{
				SendClientMessage ( target_id, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока недостаточно денег для приобретения "family_title"." ) ;
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно денег для приобретения "family_title"." ) ;
				clear_sell_params ( playerid, target_id ) ;
				return 1 ;
			}
			
			if ( p_info [ target_id ] [ family_ticket ] < sell_type [ target_id ] )
			{
				SendClientMessage ( target_id, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока недостаточно "family_title"." ) ;
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно "family_title"." ) ;
				clear_sell_params ( playerid, target_id ) ;
				return 1 ;
			}
			
			if ( target_id == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете применить это к самому себе." ) ;

			new _text_string [ 128 ];
			format ( _text_string, sizeof( _text_string ), "{"#cGN"}* %s{"#cWH"} продал Вам {"#cGN"}%d {"#cWH"}"family_title" за {"#cGN"}%d"valute_title"{"#cWH"}.", p_info [ target_id ] [ name ], sell_type [ target_id ], sell_price [ target_id ] ) ;
			SendClientMessage ( playerid, col_white, _text_string ) ;
			format( _text_string, sizeof ( _text_string ), "{"#cGInfo"}* {"#cWH"}Вы продали {"#cGN"}%d {"#cWH"}"family_title" {"#cGN"}%s{"#cWH"} за {"#cGN"}%d"valute_title"{"#cWH"}.", sell_type [ target_id ], p_info [ playerid ] [ name ], sell_price [ target_id ] ) ;
			SendClientMessage ( target_id, col_white, _text_string ) ;

			give_money ( playerid,- sell_price [ target_id ] ) ;
			format ( _text_string, sizeof _text_string, "покупка "family_title" (%d шт.)", sell_type [ target_id ] ) ;
			insert_money_log ( playerid, target_id, -sell_price [ target_id ], _text_string ) ;
			
			give_money ( seller_id [ playerid ], sell_price [ target_id ] ) ;
			format ( _text_string, sizeof _text_string, "продажа "family_title"(%d шт.)", sell_type [ target_id ] ) ;
			insert_money_log ( target_id, playerid, sell_price [ target_id ], _text_string ) ;

			p_info [ playerid ] [ family_ticket ] += sell_type [ target_id ] ;
			update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;

			p_info [ target_id ] [ family_ticket ] -= sell_type [ target_id ] ;
			update_int_sql ( target_id, "u_family_ticket", p_info [ target_id ] [ family_ticket ] ) ;

			clear_sell_params ( playerid, target_id ) ;
			return 1 ;
		}
		case d_family_hall:
		{
			if ( ! response ) return 1 ;
			switch ( listitem )
			{
				case 0:
				{
					if ( family_count + 1 > regfamily_free )
						show_dialog ( playerid, d_family_create, DIALOG_STYLE_INPUT, "{"#cBHD"}Создание семьи", "{"#cGRDialog"}* Стоимость регистрации семьи составляет {"#cGN"}"regfamily_price_txt_d" "donate_title" (Основной)\n\n{FFFFFF}Введите название своей семьи:", "Создать", "Назад" ) ;
				
					else
						show_dialog ( playerid, d_family_create, DIALOG_STYLE_INPUT, "{"#cBHD"}Создание семьи", "{"#cGRDialog"}* Стоимость регистрации семьи составляет {"#cGN"}"regfamily_price_txt"\n\n{FFFFFF}Введите название своей семьи:", "Создать", "Назад" ) ;
				}
				case 1: show_dialog ( playerid, d_family_rename, DIALOG_STYLE_INPUT, "{"#cBHD"}Переименование семьи", "{"#cGRDialog"}* Стоимость внесения информационных поправок в архив составляет {"#cGN"}"renamefamily_price_txt"\n\n{FFFFFF}Введите новое название своей семьи:", "Принять", "Назад" ) ;
				case 2:
				{
					page_count [ playerid ] = 1 ;
					mysql_tquery ( sql_connection, !"SELECT `fam_name`, `fam_chat_color` FROM `family` WHERE 1", "callback_familylist", "i", playerid ) ;
				}
			}
			return 1 ;
		}
		case d_family_list:
		{
			if ( response )
			{
				if ( page_count [ playerid ] == 1 )
				{
					show_dialog ( playerid, d_family_hall, DIALOG_STYLE_LIST, "{"#cBHD"}Архив штата", "{"#cGRDialog"}- {"#cWH"}Создать семью\n{"#cGRDialog"}- {"#cWH"}Переименовать семью\n{"#cGRDialog"}- {"#cWH"}Список семей", "Выбрать", "Закрыть" ) ;
					page_count [ playerid ] = 0 ;
					page_rows [ playerid ] = 0 ;
					return 1 ;
				}
				else
				{
					mysql_tquery ( sql_connection, !"SELECT `fam_name`, `fam_chat_color` FROM `family` WHERE 1", "callback_familylist", "i", playerid ) ;
					page_count [ playerid ] -= 1 ;
				}
				return 1 ;
			}
			else
			{
				if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице архива семей штата." ) ;
					mysql_tquery ( sql_connection, !"SELECT `fam_name`, `fam_chat_color` FROM `family` WHERE 1", "callback_familylist", "i", playerid ) ;
					page_count [ playerid ] = page_count [ playerid ] ;
					return 1 ;
				}
				mysql_tquery ( sql_connection, !"SELECT `fam_name`, `fam_chat_color` FROM `family` WHERE 1", "callback_familylist", "i", playerid ) ;
				page_count [ playerid ] += 1 ;
			}
			return 1 ;
		}
		case d_family_rename:
		{
			if ( ! response )
			{
				if ( player_open_family [ playerid ] == false )
				{
					show_dialog ( playerid, d_family_hall, DIALOG_STYLE_LIST, "{"#cBHD"}Архив штата", "{"#cGRDialog"}- {"#cWH"}Создать семью\n{"#cGRDialog"}- {"#cWH"}Переименовать семью\n{"#cGRDialog"}- {"#cWH"}Список семей", "Выбрать", "Закрыть" ) ;
				}
				return 1 ;
			}
			if ( p_info [ playerid ] [ money ] < renamefamily_price ) return show_dialog ( playerid, d_family_rename, DIALOG_STYLE_INPUT, "{"#cBHD"}Переименование семьи", "{"#cGRDialog"}* Стоимость внесения информационных поправок в архив составляет {"#cGN"}"renamefamily_price_txt"\n\n{FFFFFF}Введите новое название своей семьи:", "Принять", "Назад" ) ;
			if ( p_info [ playerid ] [ family ]  < 1 )
			{
				if ( player_open_family [ playerid ] == false )
				{
					show_dialog ( playerid, d_family_hall, DIALOG_STYLE_LIST, "{"#cBHD"}Архив штата", "{"#cGRDialog"}- {"#cWH"}Создать семью\n{"#cGRDialog"}- {"#cWH"}Переименовать семью\n{"#cGRDialog"}- {"#cWH"}Список семей", "Выбрать", "Закрыть" ) ;
				}
				return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
			}
			if ( ! GetString ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_creator ], p_info [ playerid ] [ name ] ) )
			{
				if ( player_open_family [ playerid ] == false )
				{
					show_dialog ( playerid, d_family_hall, DIALOG_STYLE_LIST, "{"#cBHD"}Архив штата", "{"#cGRDialog"}- {"#cWH"}Создать семью\n{"#cGRDialog"}- {"#cWH"}Переименовать семью\n{"#cGRDialog"}- {"#cWH"}Список семей", "Выбрать", "Закрыть" ) ;
				}
				return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не владелец семьи." ) ;
			}
			if ( strlen ( inputtext ) < 2 || strlen ( inputtext ) > 24 )
            {
                show_dialog ( playerid, d_family_rename, DIALOG_STYLE_INPUT, "{"#cBHD"}Переименование семьи", "{"#cRD"}* Название семьи не может быть менее 2 символов или превышать 24 символов.\n\n{FFFFFF}Введите новое название своей семьи:", "Принять", "Назад" ) ;
				return 1 ;
			}
			if ( is_text_invalid ( inputtext ) )
            {
                show_dialog ( playerid, d_family_rename, DIALOG_STYLE_INPUT, "{"#cBHD"}Переименование семьи", "{"#cRD"}* Название семьи содержит некорректные символы.\n\n{FFFFFF}Введите новое название своей семьи:", "Принять", "Назад" ) ;
				return 1 ;
			}
			if ( find_family_name ( inputtext ) )
			{
                show_dialog ( playerid, d_family_rename, DIALOG_STYLE_INPUT, "{"#cBHD"}Переименование семьи", "{"#cRD"}* Название уже занято другой семьёй.\n\n{FFFFFF}Введите новое название своей семьи:", "Принять", "Назад" ) ;
				return 1 ;
			}
			else
			{
			    new family_id = p_info [ playerid ] [ family ] ;
			
				new query [ 144 ] ;
				mysql_format ( sql_connection, query, sizeof query, "UPDATE `family` SET `fam_name` = '%e' WHERE `fam_id` = '%d' LIMIT 1", inputtext, family_id ) ;
                mysql_tquery ( sql_connection, query ) ;

                give_money ( playerid, -renamefamily_price ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, -renamefamily_price, "ренейм семьи" ) ;

				format ( family_info [ family_id - 1 ] [ fam_name ], 32, inputtext );

				new _fam_jackdaw [ 28 ] ;
				switch ( family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ] )
				{
				    case 0: format ( _fam_jackdaw, sizeof _fam_jackdaw, "" ) ;
				    default: format ( _fam_jackdaw, sizeof _fam_jackdaw, "[{%s}%s{"#cWH"}] ", family_info [ family_id - 1 ] [ fam_chat_color ], fam_jackdaw [ family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ] ] ) ;
				}
				
				format ( query, 128, "%s{%s}%s {"#cWH3D"}%s", _fam_jackdaw, family_info [ family_id - 1 ] [ fam_chat_color ], family_info [ family_id - 1 ] [ fam_name ], fam_brand [ family_info [ family_id - 1 ] [ fam_enhancement ] [ 10 ] ] ) ;	
				foreach(new i: family_players[family_id])
				{
					if ( p_info [ i ] [ family ] != family_id ) continue ;

					if ( IsValidDynamic3DTextLabel ( p_info [ i ] [ family_text ] ) ) UpdateDynamic3DTextLabelText ( p_info [ i ] [ family_text ], -1, query ) ;
				}

				if ( family_info [ family_id - 1 ] [ fam_house ] )
			   	{
			   	    if ( Iter_Count(family_vehicles[family_id]) != 0 )
			   	    {
						foreach(new i: family_vehicles[family_id]) veh_plate ( i ) ;
					}
				}

				if ( gdorm_family_text [ family_id - 1 ] != Text3D:INVALID_3DTEXT_ID ) update_fdorm_text ( family_id ) ;

				format ( query, 144, "{"#cGInfo"}* {"#cWH"}Вы успешно переименовали семью {"#cGN"}%s{"#cWH"}.", family_info [ family_id - 1 ] [ fam_name ] ) ;
                SendClientMessage(playerid, col_white, query);
				
				if ( player_open_family [ playerid ] == true ) show_packet_family ( playerid, 1, 0, 0 ) ;
			}
			return 1 ;
		}
		case d_family_create:
		{
			if ( ! response )return show_dialog ( playerid, d_family_hall, DIALOG_STYLE_LIST, "{"#cBHD"}Архив штата", "{"#cGRDialog"}- {"#cWH"}Создать семью\n{"#cGRDialog"}- {"#cWH"}Переименовать семью\n{"#cGRDialog"}- {"#cWH"}Список семей", "Выбрать", "Закрыть" ) ;
			
			if ( admin_info [ playerid ] [ admin ] > 0 && admin_info [ playerid ] [ admin ] < 6 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы администратор." ) ;
			
			if ( family_count + 1 > regfamily_free )
			{
				if ( ! get_player_donate ( playerid, regfamily_price_donate, 2 ) ) return show_dialog ( playerid, d_family_create, DIALOG_STYLE_INPUT, "{"#cBHD"}Создание семьи", "{"#cRD"}* Стоимость регистрации семьи составляет "regfamily_price_txt_d" "donate_title" (Основной).\n\n{FFFFFF}Введите название своей семьи:", "Создать", "Назад" ) ;
			}
			else
			{
				if ( p_info [ playerid ] [ money ] < regfamily_price ) return show_dialog ( playerid, d_family_create, DIALOG_STYLE_INPUT, "{"#cBHD"}Создание семьи", "{"#cRD"}* Стоимость регистрации семьи составляет "regfamily_price_txt".\n\n{FFFFFF}Введите название своей семьи:", "Создать", "Назад" ) ;
			}
			
			if ( p_info [ playerid ] [ family ] > 0 )
			{
				show_dialog ( playerid, d_family_hall, DIALOG_STYLE_LIST, "{"#cBHD"}Архив штата", "{"#cGRDialog"}- {"#cWH"}Создать семью\n{"#cGRDialog"}- {"#cWH"}Переименовать семью\n{"#cGRDialog"}- {"#cWH"}Список семей", "Выбрать", "Закрыть" ) ;
				return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже состоите в семье." ) ;
			}
			if ( p_info [ playerid ] [ level ] < regfamily_level )
            {
				new dialog_string [ 93 + 4 ] ;
				format ( dialog_string, sizeof dialog_string, "{"#cRInfo"}* Создание семьи доступно с %d уровня.\n\n{"#cWH"}Введите название своей семьи:", regfamily_level ) ;
                show_dialog ( playerid, d_family_create, DIALOG_STYLE_INPUT, "{"#cBHD"}Создание семьи", dialog_string, "Создать", "Назад" ) ;
				return 1 ;
			}
			if ( strlen ( inputtext ) < 2 || strlen ( inputtext ) > 24 )
            {
                show_dialog ( playerid, d_family_create, DIALOG_STYLE_INPUT, "{"#cBHD"}Создание семьи", "{"#cRD"}* Название семьи не может быть менее 2 символов или превышать 24 символов.\n\n{FFFFFF}Введите название своей семьи:", "Создать", "Назад" ) ;
				return 1 ;
			}
			if ( family_count + 1 >= MAX_FAMILY )
			{
                show_dialog ( playerid, d_family_create, DIALOG_STYLE_INPUT, "{"#cBHD"}Создание семьи", "{"#cRD"}* На сервере создано максимальное количество семей.\n\n{FFFFFF}Введите название своей семьи:", "Создать", "Назад" ) ;
				return 1 ;
			}
			if ( is_text_invalid ( inputtext ) )
            {
                show_dialog ( playerid, d_family_create, DIALOG_STYLE_INPUT, "{"#cBHD"}Создание семьи", "{"#cRD"}* Название семьи содержит некорректные символы.\n\n{FFFFFF}Введите название своей семьи:", "Создать", "Назад" ) ;
				return 1 ;
			}
			if ( find_family_name ( inputtext ) )
			{
                show_dialog ( playerid, d_family_create, DIALOG_STYLE_INPUT, "{"#cBHD"}Создание семьи", "{"#cRD"}* Название уже занято другой семьёй.\n\n{FFFFFF}Введите название своей семьи:", "Создать", "Назад" ) ;
				return 1 ;
			}
			else
			{
				if ( family_count + 1 > 50 )
				{
					set_player_donate ( playerid, regfamily_price_donate, 2 ) ;
					insert_donate_log ( playerid, INVALID_PLAYER_ID, regfamily_price_donate, p_info [ playerid ] [ donate ], "(donate) создание семьи" ) ;
				}
				else
				{
					give_money ( playerid, -regfamily_price ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, -regfamily_price, "создание семьи" ) ;
				}
				
				new query [ 166 ] ;
				mysql_format ( sql_connection, query, sizeof query, "INSERT INTO `family` (`fam_name`,`fam_creator`,`fam_date`) VALUES ( '%e', '%s', NOW())", inputtext, p_info [ playerid ] [ name ] ) ;
                mysql_tquery ( sql_connection, query ) ;

                p_info [ playerid ] [ family ] = family_count + 1 ;
                p_info [ playerid ] [ family_rang ] = 3 ;

				new family_id = p_info [ playerid ] [ family ] ;
                Iter_Add(family_players[family_id], playerid);

				format ( query, sizeof query, "UPDATE `users` SET `u_family` = '%d', `u_family_rank` = '3', `u_family_date` = NOW() WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ family ], p_info [ playerid ] [ id ] ) ;
				mysql_tquery ( sql_connection, query ) ;

                format ( family_info [ family_count ] [ fam_name ], 32, inputtext );
                format ( family_info [ family_count ] [ fam_creator ], 24, p_info [ playerid ] [ name ] );
                format ( family_info [ family_count ] [ fam_chat_color ], 8, "FFFFFF" ) ;
                format ( family_rank [ family_count ] [ 0 ], 30, "Член семьи" ) ;
                format ( family_rank [ family_count ] [ 1 ], 30, "Заместитель" ) ;
                format ( family_rank [ family_count ] [ 2 ], 30, "Глава семьи" ) ;

				family_info [ family_count ] [ fam_settings ] [ 0 ] =
				family_info [ family_count ] [ fam_settings ] [ 1 ] =
				family_info [ family_count ] [ fam_settings ] [ 2 ] =
				family_info [ family_count ] [ fam_settings ] [ 3 ] =
				family_info [ family_count ] [ fam_settings ] [ 4 ] =
				family_info [ family_count ] [ fam_settings ] [ 5 ] =
				family_info [ family_count ] [ fam_settings ] [ 6 ] =
				family_info [ family_count ] [ fam_settings ] [ 7 ] =
				family_info [ family_count ] [ fam_settings ] [ 8 ] = 3 ;
				
				family_info [ family_count ] [ fam_enhancement ] [ 0 ] =
				family_info [ family_count ] [ fam_enhancement ] [ 1 ] =
				family_info [ family_count ] [ fam_enhancement ] [ 2 ] =
				family_info [ family_count ] [ fam_enhancement ] [ 3 ] =
				family_info [ family_count ] [ fam_enhancement ] [ 4 ] =
				family_info [ family_count ] [ fam_enhancement ] [ 5 ] =
				family_info [ family_count ] [ fam_enhancement ] [ 6 ] =
				family_info [ family_count ] [ fam_enhancement ] [ 7 ] =
				family_info [ family_count ] [ fam_enhancement ] [ 8 ] =
				family_info [ family_count ] [ fam_enhancement ] [ 9 ] =
				family_info [ family_count ] [ fam_enhancement ] [ 10 ] = 0 ;
				
				family_info [ family_count ] [ fam_rating ] =
				family_info [ family_count ] [ fam_ticket ] =
				family_info [ family_count ] [ fam_house ] = 0 ;
				
				family_info [ family_count ] [ fam_max_car ] = 3 ;

				family_info [ family_count ] [ fam_members ] = 1 ;
				format ( query, sizeof ( query ), "UPDATE `family` SET `fam_members` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_count ] [ fam_members ], family_count + 1 ) ;
				mysql_tquery(sql_connection, query ) ;
				
				new _fam_jackdaw [ 28 ] ;
				switch ( family_info [ family_count ] [ fam_enhancement ] [ 9 ] )
				{
				    case 0: format ( _fam_jackdaw, sizeof _fam_jackdaw, "" ) ;
				    default: format ( _fam_jackdaw, sizeof _fam_jackdaw, "[{%s}%s{"#cWH3D"}] ", family_info [ family_count ] [ fam_chat_color ], fam_jackdaw [ family_info [ family_count ] [ fam_enhancement ] [ 9 ] ] ) ;
				}

				format ( query, 128, "%s{%s}%s {"#cWH3D"}%s", _fam_jackdaw, family_info [ family_count ] [ fam_chat_color ], family_info [ family_count ] [ fam_name ], fam_brand [ family_info [ family_count ] [ fam_enhancement ] [ 10 ] ] ) ;
				p_info [ playerid ] [ family_text ] = CreateDynamic3DTextLabel( query, col_white, 0.0, 0.0, 0.0, family_text_size, playerid, INVALID_VEHICLE_ID, 1 ) ;

				format ( query, 144, "{"#cGInfo"}* {"#cWH"}Вы успешно создали семью {"#cGN"}%s{"#cWH"}. Меню семьи - {"#cGN"}/fmenu{"#cWH"}.", family_info [ family_count ] [ fam_name ] ) ;
                SendClientMessage(playerid, col_white, query);

                family_count ++ ;
            }
			return 1 ;
        }
		case d_offamily_selection:
		{
			if ( ! response ) return show_family ( playerid ), DeletePVar ( playerid, "ofm_type" ) ;
			
			if ( listitem == 0 )
			{
				page_count [ playerid ] = 1 ;
				new query_string [ 144 ] ;
				mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d'", p_info [ playerid ] [ family ] ) ;
				mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
			}
			else show_dialog ( playerid, d_offamily_filter, DIALOG_STYLE_INPUT, "{"#cBHD"}Члены семьи", "{FFFFFF}Введите ранг для фильтра:", "Далее", "Назад" ) ;
			
			return 1 ;
		}
		case d_offamily_filter:
		{
			if ( ! response ) return show_dialog ( playerid, d_offamily_selection, DIALOG_STYLE_LIST, "{"#cBHD"}Члены семьи", "Все члены семьи оффлайн\nФильтр по рангу", "Выбрать", "Назад" ) ;
			
			new _pl_filter = strval ( inputtext ), _family_id = p_info [ playerid ] [ family ] ;
			if ( _pl_filter < 1 || _pl_filter > family_info [ _family_id - 1 ] [ fam_settings ] [ 3 ] )return show_dialog ( playerid, d_offmembers_filter, DIALOG_STYLE_INPUT, "{"#cBHD"}Члены организации", "{"#cRD"}* Неверный номер ранга!\n\n{FFFFFF}Введите ранг для фильтра:", "Далее", "Назад" ) ;
			SetPVarInt ( playerid, "ofm_type", _pl_filter ) ;
			
			page_count [ playerid ] = 1 ;
			new query_string [ 144 ] ;
			mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d' AND `u_family_rank` = '%d'", _family_id, _pl_filter ) ;
			mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
			return 1 ;
		}
        case d_offmembers_list1:
		{
			if ( ! response )
			{
				for ( new i = 0 ; i < 10 ; i ++ )
				{
					new pvar_string [ 8 ] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", i ) ;
					DeletePVar ( playerid, pvar_string ) ;
				}
				page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
				DeletePVar ( playerid, "ofm_listitem" ) ;
				DeletePVar ( playerid, "ofm_type" ) ;
				return 1 ;
			}
			if ( listitem == get_player_use_page ( playerid, 0 ) )
			{
				clear_player_use_page ( playerid ) ;
				new page_id = page_count [ playerid ] - 1;
				if ( page_id == 0 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка членов семьи." ) ;
					if( ! GetPVarInt ( playerid, "ofm_type" ) )
					{
						new query_string [ 144 ] ;
						mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d'", p_info [ playerid ] [ family ] ) ;
						mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
						return 1 ;
					}
					
					new query_string [ 144 ] ;
					mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d' AND `u_family_rank` = '%d'", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "ofm_type" ) ) ;
					mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
					return 1 ;

				}
				page_count [ playerid ] = page_id ;

				new query_string [ 144 ] ;
				if( ! GetPVarInt ( playerid, "ofm_type" ) )
				{
					mysql_format ( sql_connection, query_string, 144, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d'", p_info [ playerid ] [ family ] ) ;
					mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
					return 1 ;
				}
			
				mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d' AND `u_family_rank` = '%d'", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "ofm_type" ) ) ;
				mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
				return 1 ;
			}
			else if ( listitem == get_player_use_page ( playerid, 1 ) )
			{
				clear_player_use_page ( playerid ) ;
				new page_id = page_count [ playerid ] - 1 ;
				if ( ofm_formula ( page_id ) >= page_rows [ playerid ] )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка членов семьи." ) ;
					new query_string [ 144 ] ;
					if( ! GetPVarInt ( playerid, "ofm_type" ) )
					{
						mysql_format ( sql_connection, query_string, 144, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d'", p_info [ playerid ] [ family ] ) ;
						mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
						return 1;
					}
					
					mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d' AND `u_family_rank` = '%d'", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "ofm_type" ) ) ;
					mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
					return 1 ;
				}
				page_count [ playerid ] = page_id + 2 ;
				new query_string [ 144 ] ;
				if( ! GetPVarInt ( playerid, "ofm_type" ) )
				{
					mysql_format ( sql_connection, query_string, 144, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d'", p_info [ playerid ] [ family ] ) ;
					mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
					return 1;
				}

				mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d' AND `u_family_rank` = '%d'", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "ofm_type" ) ) ;
				mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
			}
			else
			{
				new pvar_string [ 28 ], pl_name [ 20 ] ;
				format ( pvar_string, 10, "ofm_%d", listitem ) ;
				GetPVarString ( playerid, pvar_string, pl_name, 20 ) ;
				SetPVarInt ( playerid, "ofm_listitem", listitem ) ;
				
				show_offmembers_dialog ( playerid, pl_name, 1 ) ;
			}
			return 1 ;
		}

		case d_offmembers_pl_menu1:
		{
			if ( ! response )
			{
				DeletePVar( playerid, "ofm_listitem" ) ;
				if( ! GetPVarInt ( playerid, "ofm_type" ) && player_open_family [ playerid ] == false )
				{
					new query_string [ 128 ] ;
					mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d'", p_info [ playerid ] [ family ] ) ;
					mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
					return 1 ;
				}
				return 1 ;
			}
			switch ( listitem )
			{
				case 0:
				{
					new pvar_string [ 18 ], pl_name [ 20 ] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
					GetPVarString ( playerid, pvar_string, pl_name, 20 ) ;
					new query_string [ 144 ] ;
					mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_family_rank`,`u_family_date`,`u_last_date` FROM `users` WHERE `u_name` = '%s' LIMIT 1", pl_name ) ;
					mysql_tquery ( sql_connection, query_string, "callback_offamily_info", "i", playerid ) ;
				}
				case 1: show_dialog ( playerid, d_offmembers_pl_uninvite1, DIALOG_STYLE_INPUT, "{"#cBHD"}Увольнение игрока", "{FFFFFF}Введите причину увольнения:\n\n{"#cGRDialog"}* Минимальное количество символов 3, максимальное 24", "Выбрать", "Назад" ) ;
				case 2: show_dialog ( playerid, d_offmembers_pl_rank1, DIALOG_STYLE_INPUT, "{"#cBHD"}Изменение ранга игрока", "{FFFFFF}Введите номер ранга, который хотите установить для игрока:", "Выбрать", "Назад" ) ;
                case 3:
				{
				    new pvar_string [ 38 ],
						pl_name [ MAX_PLAYER_NAME ] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
					GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;

				    page_count [ playerid ] = 1 ;
					
				    new sql_string [ 125 + MAX_PLAYER_NAME ] ;
					format ( sql_string, sizeof sql_string, "SELECT `id`, `name`, `text_time`, `type` FROM `logs_family` WHERE `name` = '%s' ORDER BY `logs_family`.`id` DESC LIMIT 200", pl_name ) ;
					mysql_tquery(sql_connection, sql_string, "logs_player_family", "i", playerid);
				}
				case 4:
				{
				    new pvar_string [ 38 ],
						pl_name [ MAX_PLAYER_NAME ] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
					GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;

				    page_count [ playerid ] = 1 ;

					new query_string [ 80 + MAX_PLAYER_NAME ];
					format ( query_string, sizeof query_string, "SELECT * FROM `users_online` WHERE `accountid` = '%d' ORDER BY `users_online`.`id` DESC", get_player_account_id ( pl_name ) ) ;
					mysql_tquery ( sql_connection, query_string, "offtime_callback", "i", playerid ) ;

					off_time_account [ playerid ] = get_player_account_id ( pl_name ) ;
					off_time_status { playerid } = 2 ;
				}
			}
			return 1 ;
		}
		case d_offmembers_pl_uninvite1:
		{
			new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
			format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
			GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;
			format ( pvar_string, sizeof ( pvar_string ), "{"#cBL"}%s", pl_name ) ;
		
		    if ( ! response ) return show_offmembers_dialog ( playerid, pl_name, 1 ) ;

		    if ( strlen ( inputtext ) < 3 || strlen ( inputtext ) > 24 )return show_dialog ( playerid, d_offmembers_pl_uninvite1, DIALOG_STYLE_INPUT, "{"#cBHD"}Увольнение игрока", "{FFFFFF}Введите причину увольнения:\n\n{"#cGRDialog"}* Минимальное количество символов 3, максимальное 24", "Выбрать", "Назад" ) ;

			offuninvite_check ( playerid, pl_name, 6, inputtext ) ;
		}
		case d_offmembers_pl_rank1:
		{
			new pvar_string [ 38 ],
				pl_name [ MAX_PLAYER_NAME ] ;
			format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
			GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;
			if ( strval ( inputtext ) < 1 || strval ( inputtext ) > family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )return show_dialog ( playerid, d_offmembers_pl_rank1, DIALOG_STYLE_INPUT, "{"#cBHD"}Повышение/понижение", "{"#cGRDialog"}* Неверный номер ранга!\n\n{FFFFFF}Введите номер ранга, который хотите установить для игрока:", "Выбрать", "Назад" ), SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Неверное значение ранга." ) ;
            if ( strval ( inputtext ) >= p_info [ playerid ] [ family_rang ] )return show_dialog ( playerid, d_offmembers_pl_rank1, DIALOG_STYLE_INPUT, "{"#cBHD"}Повышение/понижение", "{"#cGRDialog"}Неверный номер ранга!\n\n{FFFFFF}Введите номер ранга, который хотите установить для игрока:", "Выбрать", "Назад" ), SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете назначить игрока на статус выше Вашего." ) ;
			if ( response )
			{
			    offmembers_rank ( playerid, strval ( inputtext ), pl_name, 1 ) ;
			}
			show_offmembers_dialog ( playerid, pl_name, 1 ) ;
			return 1 ;
		}
		case d_offmembers_pl_menu_info1:
		{
			new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
			format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
			GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;

			if ( player_open_family [ playerid ] == false ) show_offmembers_dialog ( playerid, pl_name, 1 ) ;
			return 1 ;
		}
		case d_family_upgrade:
		{
		    if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}
		    
			new family_id = p_info [ playerid ] [ family ] ;
		    if ( listitem != 11 && family_info [ family_id - 1 ] [ fam_enhancement ] [ listitem ] == 1 )
			{
				if ( player_open_family [ playerid ] == false ) SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи уже приобретено данное улучшение!" ) ;
				else send_check_cinfo ( playerid, "У Вашей семьи уже приобретено данное улучшение!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			switch ( listitem )
			{
				case 0: show_dialog ( playerid, d_family_upgrade1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приобрести улучшение", "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Дополнительный респект'\n\n{"#cGRDialog"}* Стоимость данного улучшения составляет: {"#cBL"}1000 "family_title"{ffffff}.", "Приобрести", "Отмена" ) ;
				case 1: show_dialog ( playerid, d_family_upgrade1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приобрести улучшение", "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Успех в работе'\n\n{"#cGRDialog"}* Стоимость данного улучшения составляет: {"#cBL"}1200 "family_title"{ffffff}.", "Приобрести", "Отмена" ) ;
				case 2: show_dialog ( playerid, d_family_upgrade1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приобрести улучшение", "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Бизнессмены в долгу'\n\n{"#cGRDialog"}* Стоимость данного улучшения составляет: {"#cBL"}900 "family_title"{ffffff}.", "Приобрести", "Отмена" ) ;
				case 3: show_dialog ( playerid, d_family_upgrade1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приобрести улучшение", "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Неузнаваемый'\n\n{"#cGRDialog"}* Стоимость данного улучшения составляет: {"#cBL"}800 "family_title"{ffffff}.", "Приобрести", "Отмена" ) ;
                case 4: show_dialog ( playerid, d_family_upgrade1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приобрести улучшение", "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Больница в долгу'\n\n{"#cGRDialog"}* Стоимость данного улучшения составляет: {"#cBL"}1100 "family_title"{ffffff}.", "Приобрести", "Отмена" ) ;
				case 5: show_dialog ( playerid, d_family_upgrade1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приобрести улучшение", "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Белый список'\n\n{"#cGRDialog"}* Стоимость данного улучшения составляет: {"#cBL"}2000 "family_title"{ffffff}.", "Приобрести", "Отмена" ) ;
				case 6: show_dialog ( playerid, d_family_upgrade1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приобрести улучшение", "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Банковские махинации'\n\n{"#cGRDialog"}* Стоимость данного улучшения составляет: {"#cBL"}4000 "family_title"{ffffff}.", "Приобрести", "Отмена" ) ;
				case 7: show_dialog ( playerid, d_family_upgrade1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приобрести улучшение", "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Мародёры'\n\n{"#cGRDialog"}* Стоимость данного улучшения составляет: {"#cBL"}7000 "family_title"{ffffff}.", "Приобрести", "Отмена" ) ;
                case 8: show_dialog ( playerid, d_family_upgrade1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приобрести улучшение", "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Рыбный цех'\n\n{"#cGRDialog"}* Стоимость данного улучшения составляет: {"#cBL"}6000 "family_title"{ffffff}.", "Приобрести", "Отмена" ) ;
                case 9: show_dialog ( playerid, d_family_upgrade1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приобрести улучшение", "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Галочка'\n\n{"#cGRDialog"}* Стоимость данного улучшения составляет: {"#cBL"}1000 "family_title"{ffffff}.", "Приобрести", "Отмена" ) ;
                case 10: show_dialog ( playerid, d_family_upgrade1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приобрести улучшение", "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Бренд'\n\n{"#cGRDialog"}* Стоимость данного улучшения составляет: {"#cBL"}1500 "family_title"{ffffff}.", "Приобрести", "Отмена" ) ;
				case 11:
				{
					show_dialog ( playerid, d_family_info, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация по улучшениям", "\
					{"#cGRDialog"}- Улучшение {"#cWH"}'Дополнительный респект' {"#cGRDialog"}все члены семьи начнут получать дополнительные 1-2 EXP каждый час.\n\
					{"#cGRDialog"}- Улучшение {"#cWH"}'Успех в работе' {"#cGRDialog"}за выполнение заданий семья будет получать дополнительный "family_title".\n\
					{"#cGRDialog"}- Улучшение {"#cWH"}'Бизнессмены в долгу' {"#cGRDialog"}понижение налогооблажения для всех членов семьи.\n\
					{"#cGRDialog"}- Улучшение {"#cWH"}'Неузнаваемый' {"#cGRDialog"}время действия маски увеличивается в 2 раза.\n\
					{"#cGRDialog"}- Улучшение {"#cWH"}'Больница в долгу' {"#cGRDialog"}члены семьи не будут попадать в больницу после смерти.\n\
					{"#cGRDialog"}- Улучшение {"#cWH"}'Белый список' {"#cGRDialog"}меньше штраф за превышение скорости.\n\
					{"#cGRDialog"}- Улучшение {"#cWH"}'Банковские махинации' {"#cGRDialog"}члены семьи смогут хранить до 10.000.000"valute_title_" на основном счёте.\n\
					{"#cGRDialog"}- Улучшение {"#cWH"}'Мародёры' {"#cGRDialog"}члены семьи смогут воровать патроны и боеприпасы у армии.\n\
					{"#cGRDialog"}- Улучшение {"#cWH"}'Галочка' {"#cGRDialog"}дополнительный "family_title" каждый час, приписка перед названием.\n\
					{"#cGRDialog"}- Улучшение {"#cWH"}'Рыбный цех' {"#cGRDialog"}холодильник в доме пополняется автоматически.\n\
					{"#cGRDialog"}- Улучшение {"#cWH"}'Бренд' {"#cGRDialog"}дополнительный "family_title" каждый час, приписка после названия.", "Назад", "Закрыть" ) ;
				}
			}
			SetPVarInt ( playerid, "PlayerEnhancement", listitem ) ;
			return 1 ;
		}
		case d_family_upgrade1:
		{
			if ( response )
			{
			    if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
				{
					DeletePVar ( playerid, "PlayerEnhancement" ) ;
					show_family_upgrade ( playerid ) ;
					if ( player_open_family [ playerid ] == false ) SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Покупка улучшений семьи доступна только лидеру." ) ;
					else send_check_cinfo ( playerid, "Покупка улучшений семьи доступна только лидеру!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			
				new family_id = p_info [ playerid ] [ family ], enhancementid = GetPVarInt ( playerid, "PlayerEnhancement" ) ;
				if ( family_info [ family_id - 1 ] [ fam_ticket ] >= fam_enhancement_cost [ enhancementid ] )
				{
					if ( enhancementid == 9 )
					{
						global_string [ 0 ] = EOS ;
						new line_string [ 64 ] ;
						format ( global_string, sizeof global_string, "{"#cBL"}Выберите галочку\n" ) ;
					    for ( new i = 1 ; i < sizeof ( fam_jackdaw ) ; i ++ )
					    {
					        format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s\n", i, fam_jackdaw [ i ] ) ;
					        strcat ( global_string, line_string ) ;
					    }
					    show_dialog ( playerid, d_family_jackdaw, DIALOG_STYLE_LIST, "{"#cBHD"}Галочка", global_string, "Выбрать", "" ) ;
					}
					else if ( enhancementid == 10 )
					{
					    global_string [ 0 ] = EOS ;
						new line_string [ 64 ] ;
						format ( global_string, sizeof global_string, "{"#cBL"}Выберите бренд\n" ) ;
					    for ( new i = 1 ; i < sizeof ( fam_brand ) ; i ++ )
					    {
					        format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s\n", i, fam_brand [ i ] ) ;
					        strcat ( global_string, line_string ) ;
					    }
					    show_dialog ( playerid, d_family_brand, DIALOG_STYLE_LIST, "{"#cBHD"}Бренд", global_string, "Выбрать", "" ) ;
					}
					else
					{
						family_info [ family_id - 1 ] [ fam_enhancement ] [ enhancementid ] = 1 ;
						
						if ( player_open_family [ playerid ] == false ) SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRDialog"}Вы успешно приобрели улучшение!" ) ;
						else send_check_cinfo ( playerid, "Вы успешно приобрели улучшение!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;

						family_info [ family_id - 1 ] [ fam_ticket ] -= fam_enhancement_cost [ enhancementid ] ;
						
						new query_string [ 156 + ( 9 * 2 ) ] ;
						format ( query_string, sizeof ( query_string ), "UPDATE `family` SET `fam_ticket` = '%d', `fam_enhancement` = '%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d' WHERE `fam_id` = '%d' LIMIT 1",
						family_info [ family_id - 1 ] [ fam_ticket ],
						family_info [ family_id - 1 ] [ fam_enhancement ] [ 0 ],
						family_info [ family_id - 1 ] [ fam_enhancement ] [ 1 ],
						family_info [ family_id - 1 ] [ fam_enhancement ] [ 2 ],
						family_info [ family_id - 1 ] [ fam_enhancement ] [ 3 ],
						family_info [ family_id - 1 ] [ fam_enhancement ] [ 4 ],
						family_info [ family_id - 1 ] [ fam_enhancement ] [ 5 ],
						family_info [ family_id - 1 ] [ fam_enhancement ] [ 6 ],
						family_info [ family_id - 1 ] [ fam_enhancement ] [ 7 ],
						family_info [ family_id - 1 ] [ fam_enhancement ] [ 8 ],
						family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ],
						family_info [ family_id - 1 ] [ fam_enhancement ] [ 10 ], family_id ) ;
						mysql_tquery ( sql_connection, query_string ) ;
						
						DeletePVar ( playerid, "PlayerEnhancement" ) ;
						show_family_upgrade ( playerid ) ;
					}
				}
				else
				{
					if ( player_open_family [ playerid ] == false ) SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно "family_title" для покупки данного улучшения." ) ;
					else send_check_cinfo ( playerid, "У Вас недостаточно "family_title" для покупки данного улучшения!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					
					DeletePVar ( playerid, "PlayerEnhancement" ) ;
					show_family_upgrade ( playerid ) ;
				}
			}
			return 1 ;
		}
		case d_family_jackdaw:
		{
		    if ( ! response )
		    {
		        DeletePVar ( playerid, "PlayerEnhancement" ) ;
				show_family_upgrade ( playerid ) ;
				return 1 ;
		    }
		    
		    if ( listitem == 0 )
		    {
		        DeletePVar ( playerid, "PlayerEnhancement" ) ;
				show_family_upgrade ( playerid ) ;
				return 1 ;
		    }
		    
		    new family_id = p_info [ playerid ] [ family ], enhancementid = GetPVarInt ( playerid, "PlayerEnhancement" ) ;
		    family_info [ family_id - 1 ] [ fam_enhancement ] [ enhancementid ] = listitem ;
		    
		    if ( player_open_family [ playerid ] == false ) SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRDialog"}Вы успешно приобрели улучшение!" ) ;
			else send_check_cinfo ( playerid, "Вы успешно приобрели улучшение!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
			
			family_info [ family_id - 1 ] [ fam_ticket ] -= fam_enhancement_cost [ enhancementid ] ;
			
			new query_string [ 156 + ( 9 * 2 ) ] ;
			format ( query_string, sizeof ( query_string ), "UPDATE `family` SET `fam_ticket` = '%d', `fam_enhancement` = '%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d' WHERE `fam_id` = '%d' LIMIT 1",
			family_info [ family_id - 1 ] [ fam_ticket ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 0 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 1 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 2 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 3 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 4 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 5 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 6 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 7 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 8 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 10 ], family_id ) ;
			mysql_tquery ( sql_connection, query_string ) ;
			
			new _fam_jackdaw [ 28 ] ;
			switch ( family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ] )
			{
			    case 0: format ( _fam_jackdaw, sizeof _fam_jackdaw, "" ) ;
			    default: format ( _fam_jackdaw, sizeof _fam_jackdaw, "[{%s}%s{"#cWH"}] ", family_info [ family_id - 1 ] [ fam_chat_color ], fam_jackdaw [ family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ] ] ) ;
			}

			format ( query_string, 128, "%s{%s}%s {"#cWH3D"}%s", _fam_jackdaw, family_info [ family_id - 1 ] [ fam_chat_color ], family_info [ family_id - 1 ] [ fam_name ], fam_brand [ family_info [ family_id - 1 ] [ fam_enhancement ] [ 10 ] ] ) ;
			foreach(new i: family_players[family_id])
			{
				if ( p_info [ i ] [ family ] != family_id ) continue ;

				if ( IsValidDynamic3DTextLabel ( p_info [ i ] [ family_text ] ) ) UpdateDynamic3DTextLabelText ( p_info [ i ] [ family_text ], -1, query_string ) ;
			}
			
			DeletePVar ( playerid, "PlayerEnhancement" ) ;
			show_family_upgrade ( playerid ) ;
			return 1 ;
		}
		case d_family_brand:
		{
		    if ( ! response )
		    {
		        DeletePVar ( playerid, "PlayerEnhancement" ) ;
				show_family_upgrade ( playerid ) ;
				return 1 ;
		    }
		    
		    if ( listitem == 0 )
		    {
		        DeletePVar ( playerid, "PlayerEnhancement" ) ;
				show_family_upgrade ( playerid ) ;
				return 1 ;
		    }
		    
		    new family_id = p_info [ playerid ] [ family ], enhancementid = GetPVarInt ( playerid, "PlayerEnhancement" ) ;
		    family_info [ family_id - 1 ] [ fam_enhancement ] [ enhancementid ] = listitem ;

		    if ( player_open_family [ playerid ] == false ) SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRDialog"}Вы успешно приобрели улучшение!" ) ;
			else send_check_cinfo ( playerid, "Вы успешно приобрели улучшение!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;

			family_info [ family_id - 1 ] [ fam_ticket ] -= fam_enhancement_cost [ enhancementid ] ;
			
			new query_string [ 156 + ( 9 * 2 ) ] ;
			format ( query_string, sizeof ( query_string ), "UPDATE `family` SET `fam_ticket` = '%d', `fam_enhancement` = '%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d' WHERE `fam_id` = '%d' LIMIT 1",
			family_info [ family_id - 1 ] [ fam_ticket ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 0 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 1 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 2 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 3 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 4 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 5 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 6 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 7 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 8 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ],
			family_info [ family_id - 1 ] [ fam_enhancement ] [ 10 ], family_id ) ;
			mysql_tquery ( sql_connection, query_string ) ;
			
			new _fam_jackdaw [ 28 ] ;
			switch ( family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ] )
			{
			    case 0: format ( _fam_jackdaw, sizeof _fam_jackdaw, "" ) ;
			    default: format ( _fam_jackdaw, sizeof _fam_jackdaw, "[{%s}%s{"#cWH"}] ", family_info [ family_id - 1 ] [ fam_chat_color ], fam_jackdaw [ family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ] ] ) ;
			}

			format ( query_string, 128, "%s{%s}%s {"#cWH3D"}%s", _fam_jackdaw, family_info [ family_id - 1 ] [ fam_chat_color ], family_info [ family_id - 1 ] [ fam_name ], fam_brand [ family_info [ family_id - 1 ] [ fam_enhancement ] [ 10 ] ] ) ;
			foreach(new i: family_players[family_id])
			{
				if ( p_info [ i ] [ family ] != family_id ) continue ;

				if ( IsValidDynamic3DTextLabel ( p_info [ i ] [ family_text ] ) ) UpdateDynamic3DTextLabelText ( p_info [ i ] [ family_text ], -1, query_string ) ;
			}

			DeletePVar ( playerid, "PlayerEnhancement" ) ;
			show_family_upgrade ( playerid ) ;
			return 1 ;
		}
		case d_fam_dip_war:
		{
		    if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}

		    new _pl_id = strval ( inputtext ) ;
		    if ( ! IsPlayerConnected ( _pl_id ) || p_t_info [ _pl_id ] [ p_logged ] == false )
		    {
		        show_dialog ( playerid, d_fam_dip_war, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить враждебную семью", "{"#cRD"}* Данный игрок не найден!\n\n{ffffff}Введите ID игрока, которому желаете предложить вражду семей:", "Принять", "Назад" ) ;
		        return 1 ;
		    }
		    if ( p_t_info [ _pl_id ] [ p_dialog ] != -1 )
            {
		        show_dialog ( playerid, d_fam_dip_war, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить враждебную семью", "{"#cRD"}* Игрок в данный момент не может заключить сделку(открыт диалог)!\n\n{ffffff}Введите ID игрока, которому желаете предложить вражду семей:", "Принять", "Назад" ) ;
		        return 1 ;
		    }
			if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ _pl_id ] [ p_pos ] [ 0 ], p_t_info [ _pl_id ] [ p_pos ] [ 1 ], p_t_info [ _pl_id ] [ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( _pl_id ) != GetPlayerVirtualWorld ( playerid ) )
            {
		        show_dialog ( playerid, d_fam_dip_war, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить враждебную семью", "{"#cRD"}* Данный игрок слишком далеко!\n\n{ffffff}Введите ID игрока, которому желаете предложить вражду семей:", "Принять", "Назад" ) ;
		        return 1 ;
		    }
		    if ( ! p_info [ _pl_id ] [ family ] )
		    {
		        show_dialog ( playerid, d_fam_dip_war, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить враждебную семью", "{"#cRD"}* Игрок не состоит в семье!\n\n{ffffff}Введите ID игрока, которому желаете предложить вражду семей:", "Принять", "Назад" ) ;
		        return 1 ;
		    }

		    if ( family_diplomacy [ p_info [ playerid ] [ family ] ] [ p_info [ _pl_id ] [ family ] ] == dip_status_war )
		    {
		        show_dialog ( playerid, d_fam_dip_war, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить враждебную семью", "{"#cRD"}* Вы уже находитесь в данных дипломатических отношениях!\n\n{ffffff}Введите ID игрока, которому желаете предложить вражду семей:", "Принять", "Назад" ) ;
		        return 1 ;
		    }

		    new family_id = p_info [ playerid ] [ family ],
				other_family_id = p_info [ _pl_id ] [ family ] ;
				
            new step = 0 ;
		    for ( new i = 0 ; i < family_count ; i ++ )
			{
			    if ( step == 7 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У данной семьи максимальное количество враждебных семей." ) ;
				if ( family_diplomacy [ other_family_id ] [ family_info [ i ] [ fam_id ] ] != dip_status_war ) continue ;

				step ++ ;
			}

		    family_diplomacy [ family_id ] [ family_info [ other_family_id - 1 ] [ fam_id ] ] = dip_status_war ;
			family_diplomacy [ family_info [ other_family_id - 1 ] [ fam_id ] ] [ family_id ] = dip_status_war ;

			new fm_string [ 144 ] ;
			format ( fm_string, sizeof fm_string, "[FAM] - [ДИПЛОМАТИЯ]: %s объявила войну %s. (Инициатор: %s)", family_info [ family_id - 1 ] [ fam_name ], family_info [ other_family_id - 1 ] [ fam_name ], p_info [ playerid ] [ name ] ) ;
			foreach(new i: logged_players)
			{
				if ( ! p_info [ i ] [ family ] ) continue ;
			    if ( family_id == p_info [ i ] [ family ] || other_family_id == p_info [ i ] [ family ] || family_diplomacy [ family_id ] [ p_info [ i ] [ family ] ] == dip_status_alliance )
				{
					SendClientMessage ( i, col_fam_alliance, fm_string ) ;
				}
			}

			family_diplomacy_change [ family_info [ other_family_id - 1 ] [ fam_id ] ] [ family_id ] = 
			family_diplomacy_change [ family_id ] [ family_info [ other_family_id - 1 ] [ fam_id ] ] = SetElapsedTime ( gettime ( ), 1, CONVERT_TIME_TO_DAYS ) ;
			save_family_diplomacy ( family_id, family_info [ other_family_id - 1 ] [ fam_id ], family_diplomacy [ family_id ] [ family_info [ other_family_id - 1 ] [ fam_id ] ] ) ;
			return 1 ;
		}
		case d_fam_dip_invite:
		{
		    if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}
		    
		    new _pl_id = strval ( inputtext ) ;
		    if ( ! IsPlayerConnected ( _pl_id ) || p_t_info [ _pl_id ] [ p_logged ] == false )
		    {
		        show_dialog ( playerid, d_fam_dip_invite, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить дружескую семью", "{"#cRD"}* Данный игрок не найден!\n\n{ffffff}Введите ID игрока, которому желаете предложить дружбу семей:", "Принять", "Назад" ) ;
		        return 1 ;
		    }
		    if ( p_t_info [ _pl_id ] [ p_dialog ] != -1 )
            {
		        show_dialog ( playerid, d_fam_dip_invite, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить дружескую семью", "{"#cRD"}* Игрок в данный момент не может заключить сделку(открыт диалог)!\n\n{ffffff}Введите ID игрока, которому желаете предложить дружбу семей:", "Принять", "Назад" ) ;
		        return 1 ;
		    }
			if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ _pl_id ] [ p_pos ] [ 0 ], p_t_info [ _pl_id ] [ p_pos ] [ 1 ], p_t_info [ _pl_id ] [ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( _pl_id ) != GetPlayerVirtualWorld ( playerid ) )
            {
		        show_dialog ( playerid, d_fam_dip_invite, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить дружескую семью", "{"#cRD"}* Данный игрок слишком далеко!\n\n{ffffff}Введите ID игрока, которому желаете предложить дружбу семей:", "Принять", "Назад" ) ;
		        return 1 ;
		    }
		    if ( ! p_info [ _pl_id ] [ family ] )
		    {
		        show_dialog ( playerid, d_fam_dip_invite, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить дружескую семью", "{"#cRD"}* Игрок не состоит в семье!\n\n{ffffff}Введите ID игрока, которому желаете предложить дружбу семей:", "Принять", "Назад" ) ;
		        return 1 ;
		    }
			if ( p_info [ _pl_id ] [ family_rang ] < family_info [ p_info [ _pl_id ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
		    {
		        show_dialog ( playerid, d_fam_dip_invite, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить дружескую семью", "{"#cRD"}* Игрок не лидер семьи!\n\n{ffffff}Введите ID игрока, которому желаете предложить дружбу семей:", "Принять", "Назад" ) ;
		        return 1 ;
		    }
		    if ( family_diplomacy [ p_info [ playerid ] [ family ] ] [ p_info [ _pl_id ] [ family ] ] == dip_status_alliance )
		    {
		        show_dialog ( playerid, d_fam_dip_invite, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить дружескую семью", "{"#cRD"}* Вы уже находитесь в данных дипломатических отношениях!\n\n{ffffff}Введите ID игрока, которому желаете предложить дружбу семей:", "Принять", "Назад" ) ;
		        return 1 ;
		    }
		    
		    new dialog_string [ 166 ],
				family_id = p_info [ playerid ] [ family ],
				other_family_id = p_info [ _pl_id ] [ family ] ;
				
            new step = 0 ;
		    for ( new i = 0 ; i < family_count ; i ++ )
			{
			    if ( step == 7 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У данной семьи максимальное количество дружеских семей." ) ;
				if ( family_diplomacy [ other_family_id ] [ family_info [ i ] [ fam_id ] ] != dip_status_alliance ) continue ;

				step ++ ;
			}

			format ( dialog_string, sizeof ( dialog_string ), "{%s}%s {"#cBL"}%s{"#cWH"} предлагает Вам дружбу семей",
			family_info [ family_id - 1 ] [ fam_chat_color ], family_info [ family_id - 1 ] [ fam_name ], p_info [ playerid ] [ name ] ) ;
			show_dialog ( _pl_id, d_fam_dip_invite_id, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Дружба семей", dialog_string, "Принять", "Закрыть" ) ;
			
			format ( dialog_string, sizeof ( dialog_string ), "Вы предложили {%s}%s {"#cGN"}%s{"#cWH"} дружбу семей.",
			family_info [ other_family_id - 1 ] [ fam_chat_color ], family_info [ other_family_id - 1 ] [ fam_name ], p_info [ _pl_id ] [ name ] ) ;
			SendClientMessage ( playerid, col_white, dialog_string ) ;
			
			SetPVarInt ( _pl_id, "family_id", family_id ) ;
			SetPVarInt ( _pl_id, "player_id", playerid ) ;
			return 1 ;
		}
		case d_fam_dip_invite_id:
		{
		    if ( ! response ) 
			{
				DeletePVar ( playerid, "family_id" ), DeletePVar ( playerid, "player_id" ) ;
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}
		    
		    new family_id = GetPVarInt ( playerid, "family_id" ),
		        player_id = GetPVarInt ( playerid, "player_id" ) ;
		    DeletePVar ( playerid, "family_id" ) ;
		    DeletePVar ( playerid, "player_id" ) ;
		    
		    new fr_id = p_info [ playerid ] [ family ] ;
		    family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] = dip_status_alliance ;
			family_diplomacy [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] = dip_status_alliance ;

			new fm_string [ 144 ] ;
			format ( fm_string, sizeof fm_string, "[FAM] - [ДИПЛОМАТИЯ]: %s заключила союз с %s. (Инициатор: %s)", family_info [ family_id - 1 ] [ fam_name ], family_info [ fr_id - 1 ] [ fam_name ], p_info [ player_id ] [ name ] ) ;
			foreach(new i: logged_players)
			{
				if ( ! p_info [ i ] [ family ] ) continue ;
			    if ( family_id == p_info [ i ] [ family ] || family_diplomacy [ family_id ] [ p_info [ i ] [ family ] ] == dip_status_alliance )
				{
					SendClientMessage ( i, col_fam_alliance, fm_string ) ;
				}
			}
			
			family_diplomacy_change [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] = 
			family_diplomacy_change [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] = SetElapsedTime ( gettime ( ), 1, CONVERT_TIME_TO_DAYS ) ;
			save_family_diplomacy ( family_id, family_info [ fr_id - 1 ] [ fam_id ], family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] ) ;
			return 1 ;
		}
		case d_fam_dip_list:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				DeletePVar ( playerid, "dip_step" ) ;
				return 1 ;
			}
			
			if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
			{
			    clear_player_listitem_values ( playerid ) ;
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Запрос на дипломатию доступен только лидеру." ) ;
			}
			
			if ( get_player_use_page ( playerid, 0 ) != -1 && listitem == get_player_use_page ( playerid, 0 ) )
			{
				clear_player_use_page ( playerid ) ;
			    clear_player_listitem_values ( playerid ) ;
				if ( GetPVarInt ( playerid, "dip_step" ) == 7 )
				{
					if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
					DeletePVar ( playerid, "dip_step" ) ;
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас максимальное количество дружеских семей." ) ;
				}
			
			    show_dialog ( playerid, d_fam_dip_invite, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить дружескую семью", "{ffffff}Введите ID игрока, которому желаете предложить дружбу семей:", "Принять", "Назад" ) ;
			    return 1 ;
			}
			if ( get_player_use_page ( playerid, 1 ) != -1 && listitem == get_player_use_page ( playerid, 1 ) )
			{
				clear_player_use_page ( playerid ) ;
			    clear_player_listitem_values ( playerid ) ;
				if ( GetPVarInt ( playerid, "dip_step" ) == 7 )
				{
					if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
					DeletePVar ( playerid, "dip_step" ) ;
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас максимальное количество враждебных семей." ) ;
				}

			    show_dialog ( playerid, d_fam_dip_war, DIALOG_STYLE_INPUT, "{"#cBHD"}Добавить враждебную семью", "{ffffff}Введите ID игрока, которому желаете предложить вражду семей:", "Принять", "Назад" ) ;
			    return 1 ;
			}
			
			new header_string [ 64 ] ;
			new fr_id = get_player_listitem_values ( playerid, listitem ) ;
			clear_player_listitem_values ( playerid ) ;
			SetPVarInt ( playerid, "d_listitem", fr_id + 1 ) ;

			format ( header_string, sizeof header_string, "{"#cBHD"}{%s}%s", family_info [ fr_id ] [ fam_chat_color ], family_info [ fr_id ] [ fam_name ] ) ;

            new family_id = p_info [ playerid ] [ family ] ;
			if ( family_diplomacy [ family_id ] [ fr_id + 1 ] == dip_status_alliance )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 512, "Нейтралитет\nОбъявить войну\nПредложить союз\n{"#cGRDialog"}Общий чат: %s\n{"#cGRDialog"}Нанесение урона: %s",
				( family_dip_settings [ family_id ] [ fr_id + 1 ] [ 0 ] == dip_settings_off ) ? ( "{"#cRD"}Выключен" ) : ( "{"#cGN"}Включен" ),
				( family_dip_settings [ family_id ] [ fr_id + 1 ] [ 1 ] == dip_settings_off ) ? ( "{"#cRD"}Выключен" ) : ( "{"#cGN"}Включен" ) ) ;
				show_dialog ( playerid, d_fam_dip_change, DIALOG_STYLE_LIST, header_string, global_string, "Выбрать", "Закрыть" ) ;
			}
			else show_dialog ( playerid, d_fam_dip_change, DIALOG_STYLE_LIST, header_string, "Нейтралитет\nОбъявить войну\nПредложить союз", "Выбрать", "Закрыть" ) ;
			return 1 ;
		}
		case d_fam_dip_change:
		{
			if ( mw_biz != -1 || zones_captured != -1 || conf_time > 0 )
			{
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Невозможно изменять дипломатию во время войны." ) ;
			}
			if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}
			new fr_id = GetPVarInt ( playerid, "d_listitem" ) ;
			DeletePVar ( playerid, "d_listitem" ) ;
			
			new family_id = p_info [ playerid ] [ family ] ;
			if ( family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] == listitem ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже находитесь в данных дипломатических отношениях." ) ;
			if ( listitem == 3 )
			{
				if ( family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] == dip_status_war ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы враждуете." ) ;
			
			    if ( family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 0 ] == dip_settings_on ) 
					family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 0 ] = dip_settings_off ;
			    
				else 
					family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 0 ] = dip_settings_on ;
			    
			    new fm_string [ 144 ] ;
				format ( fm_string, sizeof fm_string, "[FAM] - [ДИПЛОМАТИЯ]: %s %s общий чат для %s. (Инициатор: %s)", family_info [ family_id - 1 ] [ fam_name ], ( family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 0 ] == dip_settings_off ) ? ( "закрыла" ) : ( "открыла" ), family_info [ fr_id - 1 ] [ fam_name ], p_info [ playerid ] [ name ] ) ;
				foreach(new i: logged_players)
				{
					if ( ! p_info [ i ] [ family ] ) continue ;
				    if ( family_id == p_info [ i ] [ family ] || family_info [ fr_id - 1 ] [ fam_id ] == p_info [ i ] [ family ] )
					{
						SendClientMessage ( i, col_fam_alliance, fm_string ) ;
					}
				}

				save_family_diplomacy ( family_id, family_info [ fr_id - 1 ] [ fam_id ], family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] ) ;
			    return 1 ;
			}
			if ( listitem == 4 )
			{
				if ( family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] == dip_status_war ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы враждуете." ) ;
				
			    if ( family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 1 ] == dip_settings_on ) 
					family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 1 ] = dip_settings_off ;
				
			    else 
					family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 1 ] = dip_settings_on ;

			    new fm_string [ 144 ] ;
				format ( fm_string, sizeof fm_string, "[FAM] - [ДИПЛОМАТИЯ]: %s %s нанесение урона для %s. (Инициатор: %s)", family_info [ family_id - 1 ] [ fam_name ], ( family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 1 ] == dip_settings_off ) ? ( "выключила" ) : ( "включила" ), family_info [ fr_id - 1 ] [ fam_name ], p_info [ playerid ] [ name ] ) ;
				foreach(new i: logged_players)
				{
					if ( ! p_info [ i ] [ family ] ) continue ;
				    if ( family_id == p_info [ i ] [ family ] || family_info [ fr_id - 1 ] [ fam_id ] == p_info [ i ] [ family ] )
					{
						SendClientMessage ( i, col_fam_alliance, fm_string ) ;
					}
				}

				save_family_diplomacy ( family_id, family_info [ fr_id - 1 ] [ fam_id ], family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] ) ;
			    return 1 ;
			}
			
			if ( family_diplomacy_change [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] > gettime ( ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Отношения можно менять раз в сутки." ) ;
			if ( listitem == 2 )
			{
			    if ( GetPVarInt ( playerid, "dip_step" ) == 7 )
				{
					if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
					DeletePVar ( playerid, "dip_step" ) ;
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас максимальное количество дружеских семей." ) ;
				}
			
				if ( family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] == dip_status_alliance_get_invite )
				{
					family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] = dip_status_alliance ;
					family_diplomacy [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] = dip_status_alliance ;

					new fm_string [ 144 ] ;
					format ( fm_string, sizeof fm_string, "[FAM] - [ДИПЛОМАТИЯ]: %s заключила союз с %s. (Инициатор: %s)", family_info [ family_id - 1 ] [ fam_name ], family_info [ fr_id - 1 ] [ fam_name ], p_info [ playerid ] [ name ] ) ;
					foreach(new i: logged_players)
					{
						if ( ! p_info [ i ] [ family ] ) continue ;
					    if ( family_id == p_info [ i ] [ family ] || family_diplomacy [ family_id ] [ p_info [ i ] [ family ] ] == dip_status_alliance )
						{
							SendClientMessage ( i, col_fam_alliance, fm_string ) ;
						}
					}
					
					if ( listitem != dip_status_neutral ) save_family_diplomacy ( family_id, family_info [ fr_id - 1 ] [ fam_id ], family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] ) ;
					else
					{
						new sql_string [ 79 + 9 + 9 ] ;
						mysql_format ( sql_connection, sql_string, sizeof sql_string, "DELETE FROM `family_wars` WHERE `f_fam` = '%d' AND `f_to_fam` = '%d' LIMIT 1",
						family_id, family_info [ fr_id - 1 ] [ fam_id ] ) ;
						mysql_tquery ( sql_connection, sql_string, "", "" ) ;

						mysql_format ( sql_connection, sql_string, sizeof sql_string, "DELETE FROM `family_wars` WHERE `f_fam` = '%d' AND `f_to_fam` = '%d' LIMIT 1",
						family_info [ fr_id - 1 ] [ fam_id ], family_id ) ;
						mysql_tquery ( sql_connection, sql_string, "", "" ) ;
						
						family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 0 ] = dip_settings_off ;
					    family_dip_settings [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] [ 0 ] = dip_settings_off ;
					    family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 1 ] = dip_settings_off ;
					    family_dip_settings [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] [ 1 ] = dip_settings_off ;
					}
					
					family_diplomacy_change [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] = 
					family_diplomacy_change [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] = SetElapsedTime ( gettime ( ), 1, CONVERT_TIME_TO_DAYS ) ;
					if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
					return 1 ;
				}
				family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] = dip_status_alliance_invite ;
				family_diplomacy [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] = dip_status_alliance_get_invite ;
				
				if ( listitem != dip_status_neutral ) save_family_diplomacy ( family_id, family_info [ fr_id - 1 ] [ fam_id ], family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] ) ;
				else
				{
					new sql_string [ 79 + 9 + 9 ] ;
					mysql_format ( sql_connection, sql_string, sizeof sql_string, "DELETE FROM `family_wars` WHERE `f_fam` = '%d' AND `f_to_fam` = '%d' LIMIT 1",
					family_id, family_info [ fr_id - 1 ] [ fam_id ] ) ;
					mysql_tquery ( sql_connection, sql_string, "", "" ) ;

					mysql_format ( sql_connection, sql_string, sizeof sql_string, "DELETE FROM `family_wars` WHERE `f_fam` = '%d' AND `f_to_fam` = '%d' LIMIT 1",
					family_info [ fr_id - 1 ] [ fam_id ], family_id ) ;
					mysql_tquery ( sql_connection, sql_string, "", "" ) ;
					
					family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 0 ] = dip_settings_off ;
				    family_dip_settings [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] [ 0 ] = dip_settings_off ;
				    family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 1 ] = dip_settings_off ;
				    family_dip_settings [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] [ 1 ] = dip_settings_off ;
				}

				family_diplomacy_change [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] = 
				family_diplomacy_change [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] = SetElapsedTime ( gettime ( ), 1, CONVERT_TIME_TO_DAYS ) ;
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}
			
			if ( listitem == 1 )
			{
			    if ( GetPVarInt ( playerid, "dip_step" ) == 7 )
				{
					if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
					DeletePVar ( playerid, "dip_step" ) ;
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас максимальное количество враждебных семей." ) ;
				}
			}
			
			family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] = listitem ;
			family_diplomacy [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] = listitem ;

			new fm_string [ 144 ] ;
			format ( fm_string, sizeof fm_string, "[FAM] - [ДИПЛОМАТИЯ]: %s %s %s. (Инициатор: %s)", family_info [ family_id - 1 ] [ fam_name ], ( listitem == 0 ) ? ( "заключила нейтралитет с" ) : ( "объявила войну" ), family_info [ fr_id - 1 ] [ fam_name ], p_info [ playerid ] [ name ] ) ;
			foreach(new i: logged_players)
			{
				if ( ! p_info [ i ] [ family ] ) continue ;
			    if ( family_id == p_info [ i ] [ family ] || family_diplomacy [ family_id ] [ p_info [ i ] [ family ] ] == dip_status_alliance )
				{
					SendClientMessage ( i, col_fam_alliance, fm_string ) ;
				}
			}

			if ( listitem != dip_status_neutral ) save_family_diplomacy ( family_id, family_info [ fr_id - 1 ] [ fam_id ], family_diplomacy [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] ) ;
			else
			{
				new sql_string [ 79 + 9 + 9 ] ;
				mysql_format ( sql_connection, sql_string, sizeof sql_string, "DELETE FROM `family_wars` WHERE `f_fam` = '%d' AND `f_to_fam` = '%d' LIMIT 1",
				family_id, family_info [ fr_id - 1 ] [ fam_id ] ) ;
				mysql_tquery ( sql_connection, sql_string, "", "" ) ;

				mysql_format ( sql_connection, sql_string, sizeof sql_string, "DELETE FROM `family_wars` WHERE `f_fam` = '%d' AND `f_to_fam` = '%d' LIMIT 1",
				family_info [ fr_id - 1 ] [ fam_id ], family_id ) ;
				mysql_tquery ( sql_connection, sql_string, "", "" ) ;
				
				family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 0 ] = dip_settings_off ;
			    family_dip_settings [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] [ 0 ] = dip_settings_off ;
			    family_dip_settings [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] [ 1 ] = dip_settings_off ;
			    family_dip_settings [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] [ 1 ] = dip_settings_off ;
			}
			family_diplomacy_change [ family_info [ fr_id - 1 ] [ fam_id ] ] [ family_id ] = 
			family_diplomacy_change [ family_id ] [ family_info [ fr_id - 1 ] [ fam_id ] ] = SetElapsedTime ( gettime ( ), 1, CONVERT_TIME_TO_DAYS ) ;
			return 1 ;
		}
		case d_family:
		{
			if ( ! response ) return 1 ;
            switch ( listitem )
            {
                case 0:
                {
                    global_string [ 0 ] = EOS ;
					new nationality_string [ 20 ] ;
					new family_id = p_info [ playerid ] [ family ] ;
					
					new scm_family_top [ 100 ] ;
					format ( scm_family_top, sizeof scm_family_top, " " ) ;
					if ( family_top [ 0 ] == family_id )
					{
					    format ( scm_family_top, sizeof scm_family_top, "\n\n{"#cGRDialog"}Ваша семья первая в ТОП рейтинге.\n{"#cGRDialog"}Бонус: %d "family_title" в PayDay", bonus_family_ticket [ 0 ] ) ;
					}
					else if ( family_top [ 1 ] == family_id )
					{
					    format ( scm_family_top, sizeof scm_family_top, "\n\n{"#cGRDialog"}Ваша семья вторая в ТОП рейтинге.\n{"#cGRDialog"}Бонус: %d "family_title" в PayDay", bonus_family_ticket [ 1 ] ) ;
					}
					else if ( family_top [ 2 ] == family_id )
					{
					    format ( scm_family_top, sizeof scm_family_top, "\n\n{"#cGRDialog"}Ваша семья третья в ТОП рейтинге.\n{"#cGRDialog"}Бонус: %d "family_title" в PayDay", bonus_family_ticket [ 2 ] ) ;
					}

					switch ( family_info [ family_id - 1 ] [ fam_nationality ] )
					{
						case 1:nationality_string = "американцы";
						case 2:nationality_string = "японцы";
						case 3:nationality_string = "итальянцы";
						case 4:nationality_string = "мексиканцы";
						case 5:nationality_string = "латиноамериканцы";
						case 6:nationality_string = "испанцы";
						case 7:nationality_string = "русские";
						case 8:nationality_string = "португальцы";
						case 9:nationality_string = "французы";
						default:nationality_string = "неизвестно";
					}
					format ( global_string, sizeof ( global_string ),"{"#cWH"}Семья %s\n\n{"#cGRDialog"}Создатель семьи:{"#cWH"} %s\n\n{"#cGRDialog"}Национальность: {"#cWH"}%s\n{"#cGRDialog"}Онлайн: {"#cWH"}%i{"#cGRDialog"} чел.\n{"#cGRDialog"}Состав семьи: {"#cWH"}%i{"#cGRDialog"} чел.\n\n{"#cGRDialog"}Доступно мест для т/с: {"#cWH"}%i\n{"#cGRDialog"}У Вашей семьи т/с: {"#cWH"}%i\n\n{"#cGRDialog"}Рейтинг семьи: {"#cWH"}%d{"#cGRDialog"} очк.\n{"#cGRDialog"}"family_title": {"#cWH"}%d{"#cGRDialog"} шт. %s",
					family_info [ family_id - 1 ] [ fam_name ], family_info [ family_id - 1 ] [ fam_creator ], nationality_string, Iter_Count(family_players[family_id]), family_info [ family_id - 1 ] [ fam_members ], family_info [ family_id - 1 ] [ fam_max_car ], Iter_Count(family_vehicles[family_id]), family_info [ family_id - 1 ] [ fam_rating ], family_info [ family_id - 1 ] [ fam_ticket ], scm_family_top ) ;
					show_dialog ( playerid, d_family_info, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация о семье", global_string, "Назад", "Закрыть" ) ;
                }
                case 1:
                {
					if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
					{
						show_family ( playerid ) ;
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Оффлайн список членов семьи доступен только лидеру." ) ;
					}

					show_dialog ( playerid, d_offamily_selection, DIALOG_STYLE_LIST, "{"#cBHD"}Члены семьи", "Все члены семьи оффлайн\nФильтр по рангу", "Выбрать", "Назад" ) ;
                }
                case 2:
                {
					page_count [ playerid ] = 1 ;
					ShowFamMembers ( playerid ) ;
                }
				case 3:
				{
					family_settings ( playerid ) ;
				}
				case 4:
				{
					new header_string [ 64 ] ;
					format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_bank ] ) ) ;
				    inv_dialog ( playerid, d_family_bank, DIALOG_STYLE_LIST, header_string, "{"#cGRDialog"}- {"#cWH"}Положить\n{"#cGRDialog"}- {"#cWH"}Взять", "Выбрать", "Назад" ) ;
				}
				case 5:
				{
				    show_dialog ( playerid, d_blacklist_family, DIALOG_STYLE_LIST, "{"#cBHD"}Чёрный список", "{"#cGRDialog"}- {"#cWH"}Добавить человека в чёрный список\n{"#cGRDialog"}- {"#cWH"}Очистить черный список\n{"#cGRDialog"}- {"#cWH"}Убрать человека из черного списка\n{"#cGRDialog"}- {"#cWH"}Чёрный список игроков", "Выбрать", "Назад" ) ;
				}
				case 6:
				{
				    if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
					{
						if ( p_info [ playerid ] [ family ]  < 1 )return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
	
						show_family_house ( playerid ) ;
						return 1 ;
					}

					if ( ! Iter_Count(player_houses[playerid]) )
					{
						show_family ( playerid ) ;
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет дома." ) ;
					}

					show_home_family ( playerid ) ;
				}
				case 7:
				{
				    if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
					{
						show_family ( playerid ) ;
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Автопарк доступен только лидеру семьи." ) ;
					}
					
					show_fixcar ( playerid, 5 ) ;
				}
				case 8: show_family_upgrade ( playerid ) ;
				case 9:
				{
				    if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
					{
						show_family ( playerid ) ;
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Лог семьи доступен только лидеру семьи." ) ;
					}

				    show_family_logs ( playerid ) ;
				}
				case 10:
				{
				    static const dip_status [ ] [ ] =
					{
						"{FFF2C7}Нейтралитет",
						"{"#cRD"}Война",
						"{"#cGN"}Союз",
						"{"#cBL"}Запрос на союз",
						"{"#cBL"}Запрос на союз"
					} ;

					new step = 0,
						line_string [ 128 ],
						family_id = p_info [ playerid ] [ family ],
						row_count ;

					global_string [ 0 ] = EOS ;
					for ( new i = 0 ; i < family_count ; i ++ )
					{
					    if ( step == 7 ) break ;
					    if ( family_id == i + 1 ) continue ;
						if ( family_diplomacy [ family_id ] [ i + 1 ] == dip_status_war || family_diplomacy [ family_id ] [ i + 1 ] == dip_status_neutral ) continue ;
						
						set_player_listitem_values ( playerid, step, i ) ;

						format ( line_string, sizeof line_string, "{"#cBL"}%i. {%s}%s{"#cWH"} - %s{"#cWH"}, Создатель: %s\n", step + 1, family_info [ i ] [ fam_chat_color ], family_info [ i ] [ fam_name ], dip_status [ family_diplomacy [ family_id ] [ i + 1 ] ], family_info [ i ] [ fam_creator ] ) ;
						strcat ( global_string, line_string ) ;
						
						step ++ ;
						row_count ++ ;
						if ( step == 7 ) SetPVarInt ( playerid, "dip_step", step ) ;
					}
					
                    strcat ( global_string, "{"#cGN"}Добавить дружескую семью\n" ) ;
					set_player_use_page ( playerid, row_count, 0 ) ;
					
					show_dialog ( playerid, d_fam_dip_list, DIALOG_STYLE_LIST, "{"#cBHD"}Дружеские семьи", global_string, "Выбрать", "Закрыть" ) ;
					return 1 ;
				}
				case 11:
				{
				    static const dip_status [ ] [ ] =
					{
						"{FFF2C7}Нейтралитет",
						"{"#cRD"}Война",
						"{"#cGN"}Союз",
						"{"#cBL"}Запрос на союз",
						"{"#cBL"}Запрос на союз"
					} ;
				
				    new step = 0,
						line_string [ 128 ],
						family_id = p_info [ playerid ] [ family ],
						row_count ;

					global_string [ 0 ] = EOS ;
					for ( new i = 0 ; i < family_count ; i ++ )
					{
						if ( step == 7 ) break ;
					    if ( family_id == i + 1 ) continue ;
						if ( family_diplomacy [ family_id ] [ i + 1 ] != dip_status_war ) continue ;

						set_player_listitem_values ( playerid, step, i ) ;

						format ( line_string, sizeof line_string, "{"#cBL"}%i. {%s}%s{"#cWH"} - %s{"#cWH"}, Создатель: %s\n", step + 1, family_info [ i ] [ fam_chat_color ], family_info [ i ] [ fam_name ], dip_status [ family_diplomacy [ family_id ] [ i + 1 ] ], family_info [ i ] [ fam_creator ] ) ;
						strcat ( global_string, line_string ) ;
						
						step ++ ;
						row_count ++ ;
						if ( step == 7 ) SetPVarInt ( playerid, "dip_step", step ) ;
					}
					
					strcat ( global_string, "{"#cRD"}Добавить враждебную семью\n" ) ;
					set_player_use_page ( playerid, row_count, 1 ) ;
					
					show_dialog ( playerid, d_fam_dip_list, DIALOG_STYLE_LIST, "{"#cBHD"}Враждебные семьи", global_string, "Выбрать", "Закрыть" ) ;
					return 1 ;
				}
				case 12:
				{
				    if ( ! GetString ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_creator ], p_info [ playerid ] [ name ] ) )
					{
						show_family ( playerid ) ;
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Передавать семью может только создатель." ) ;
					}

					show_dialog ( playerid, d_family_creator, DIALOG_STYLE_INPUT, "{"#cBHD"}Передача семьи", "{"#cWH"}Введите ID игрока, которому хотите передать семью:", "Принять", "Назад" ) ;
				}
                case 13:
                {
                    new family_id = p_info [ playerid ] [ family ] ;
					if ( GetString ( family_info [ family_id - 1 ] [ fam_creator ], p_info [ playerid ] [ name ] ) )
					{
						show_family ( playerid ) ;
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Лидер семьи не может покинуть её." ) ;
					}
					
					new fm_string [ 144 ] ;
                    format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] %s %s[%i] покинул(а) семью!", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid ) ;
                    family_message ( family_id, col_gray, fm_string ) ;
					
					format ( fm_string, 128, "DELETE FROM `family_warns` WHERE `f_u_id` = '%d' LIMIT %d", p_info [ playerid ] [ id ], p_info [ playerid ] [ fam_warning ] ) ;
					mysql_tquery ( sql_connection, fm_string ) ;

                    Iter_Remove(family_players[family_id], playerid) ;

                    p_info [ playerid ] [ family ] =
					p_info [ playerid ] [ family_rang ] = 
					p_info [ playerid ] [ famblock ] = 
					p_info [ playerid ] [ fam_warning ] = 0 ;
					
					if ( p_info [ playerid ] [ family_text ] != Text3D:INVALID_3DTEXT_ID )
					{
						DestroyDynamic3DTextLabel ( p_info [ playerid ] [ family_text ] ) ;
						p_info [ playerid ] [ family_text ] = Text3D:INVALID_3DTEXT_ID ;
					}
					
					family_info [ family_id - 1 ] [ fam_members ] -- ;
					format ( fm_string, sizeof ( fm_string ), "UPDATE `family` SET `fam_members` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_members ], family_id ) ;
					mysql_tquery(sql_connection, fm_string ) ;

					format(fm_string, sizeof(fm_string), "UPDATE `users` SET `u_family` = '0', `u_family_rank` = '0', `u_fam_warning` = '0', `u_famblock` = '0' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
					mysql_tquery(sql_connection, fm_string);

					#if defined m_binders
						update_packet_binds ( playerid ) ;
					#endif
  				}
            }
			return 1 ;
		}
		case d_fam_maxwarn:
		{
		    if ( ! response ) return show_family ( playerid ) ;

		    new _fam_id = p_info [ playerid ] [ family ] ;
		    
		    new _max_warn = strval ( inputtext ) ;
		    if ( ! _max_warn || _max_warn > max_fwarn )
			{
		        global_string [ 0 ] = EOS ;
				format(global_string, 356, "{"#cWH"}Вы собираетесь изменить следующую конфигурацию:\n\n{"#cWH"}Название: {"#cLY"}Количество предупреждений в семье\n{"#cWH"}Текущее значение: {"#cLY"}%d\n\n{"#cGRDialog"}* Введите новое значение для данной конфигурации:", family_info [ _fam_id - 1 ] [ fam_max_warn ] ) ;
				show_dialog(playerid, d_fam_maxwarn, DIALOG_STYLE_INPUT, "{"#cBHD"}Изменение конфигурации", global_string, "Выбрать", "Назад");

                SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не правильно указали количество выговоров требуемых для увольнения." ) ;
				format ( global_string, 128, "{"#cRInfo"}* {"#cGRInfo"}Нельзя установить менее {"#cRD"}1{"#cGRInfo"} и более {"#cRD"}%d{"#cGRInfo"} выговоров.", max_fwarn ) ;
				SendClientMessage ( playerid, col_gray, global_string ) ;
		        return 1 ;
		    }

		    show_family ( playerid ) ;
		    family_info [ _fam_id - 1 ] [ fam_max_warn ] = _max_warn ;

			static const _str [ ] = "UPDATE `family` SET `fam_max_warn` = '%d' WHERE `fam_id` = '%d' LIMIT 1" ;
		    new query_string [ sizeof _str + 4 + 4 ] ;
		    format ( query_string, sizeof query_string, _str, _max_warn, family_info [ _fam_id - 1 ] [ fam_id ] ) ;
        	mysql_tquery ( sql_connection, query_string ) ;
			return 1 ;
		}
		case d_fam_house:
		{
			if ( ! response ) return show_family ( playerid ) ;
			
			if ( listitem == 0 )
			{
				new family_id = p_info [ playerid ] [ family ] ;
				if ( ! family_info [ family_id - 1 ] [ fam_house ] )return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи нет дома." ), show_family ( playerid ) ;
						
				new house_id = family_info [ family_id - 1 ] [ fam_house ] - 1 ;
				if ( h_info [ house_id ] [ h_improve ] [ improve_wardrobe ] == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В доме нет гардероба." ) ;
				if ( ! IsPlayerInRangeOfPoint ( playerid, 30, house_int [ h_info [ house_id ] [ h_int ] - 1 ] [ hint_position ] [ 0 ], house_int [ h_info [ house_id ] [ h_int ] - 1 ] [ hint_position ] [ 1 ], house_int [ h_info [ house_id ] [ h_int ] - 1 ] [ hint_position ] [ 2 ] ) )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны находиться в доме семьи." ) ;
						
				new line_string [ 36 ] ;
				global_string [ 0 ] = EOS ;
				for ( new j = 0 ; j < 5 ; j ++ )
				{
					if ( p_info [ playerid ] [ temp_skin ] [ j ] == 0 )
					{
						strcat ( global_string, "{"#cGRDialog"}- Пусто\n" ) ;
					}
					else
					{
						format ( line_string, 36, "{ffffff}Одежда | %d\n", p_info [ playerid ] [ temp_skin ] [ j ] ) ;
						strcat ( global_string, line_string ) ;
					}
				}
				strcat ( global_string, "Одежда организации" ) ;
				show_dialog ( playerid, d_fam_clothes, DIALOG_STYLE_LIST, "{"#cBHD"}Гардероб", global_string, "Выбрать", "Назад" ) ;
			}
			else if ( listitem == 1 )
			{
				new family_id = p_info [ playerid ] [ family ] ;
				if ( ! family_info [ family_id - 1 ] [ fam_house ] )return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи нет дома." ), show_family ( playerid ) ;
						
				new house_id = family_info [ family_id - 1 ] [ fam_house ] - 1 ;
				if ( h_info [ house_id ] [ h_improve ] [ improve_cellar ] == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В доме нет оборудованного подвала." ) ;
				if ( ! IsPlayerInRangeOfPoint ( playerid, 30, house_int [ h_info [ house_id ] [ h_int ] - 1 ] [ hint_position ] [ 0 ], house_int [ h_info [ house_id ] [ h_int ] - 1 ] [ hint_position ] [ 1 ], house_int [ h_info [ house_id ] [ h_int ] - 1 ] [ hint_position ] [ 2 ] ) )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны находиться в доме семьи." ) ;
						
				set_pos ( playerid, house_cellar_position [ 0 ], house_cellar_position [ 1 ], house_cellar_position [ 2 ], house_cellar_position [ 3 ], house_cellar_int, h_info [ house_id ] [ h_id ] ) ;
				SetPVarInt ( playerid, "tp_area_used", 1 ) ;
				teleport_tick [ playerid ] = GetTickCount ( ) ;
			}
			return 1 ;
		}
		case d_family_creator:
		{
		    if ( ! response ) return show_family ( playerid ) ;

		    new player_id = strval ( inputtext ), familyid = p_info [ playerid ] [ family ] ;
		    if ( player_id < 0 ) return show_dialog ( playerid, d_family_creator, DIALOG_STYLE_INPUT, "{"#cBHD"}Передача семьи", "{"#cWH"}Введите ID игрока, которому хотите передать семью:\n\n{"#cGRDialog"}* Не правильно указан ID игрока.", "Принять", "Назад" ) ;
			if ( ! IsPlayerConnected ( player_id ) ) return show_dialog ( playerid, d_family_creator, DIALOG_STYLE_INPUT, "{"#cBHD"}Передача семьи", "{"#cWH"}Введите ID игрока, которому хотите передать семью:\n\n{"#cGRDialog"}* Данный игрок не в сети.", "Принять", "Назад" ) ;
            if ( p_info [ playerid ] [ family ] != p_info [ player_id ] [ family ] ) return show_dialog ( playerid, d_family_creator, DIALOG_STYLE_INPUT, "{"#cBHD"}Передача семьи", "{"#cWH"}Введите ID игрока, которому хотите передать семью:\n\n{"#cGRDialog"}* Игрок не состоит в Вашей семье.", "Принять", "Назад" ) ;

			format ( family_info [ familyid - 1 ] [ fam_creator ], MAX_PLAYER_NAME, "%s", p_info [ player_id ] [ name ] ) ;

			new query [ 144 ] ;
			format ( query, sizeof ( query ), "UPDATE `family` SET `fam_creator` = '%s' WHERE `fam_id` = '%d' LIMIT 1", family_info [ familyid - 1 ] [ fam_creator ], familyid ) ;
			mysql_tquery ( sql_connection, query ) ;

			foreach(new i: family_players[familyid])
			{
				if ( player_id == i ) continue ;
				if ( p_info [ i ] [ family ] != familyid ) continue ;
				
				p_info [ i ] [ family_rang ] = 1 ;
			}
			
			format ( query, 128, "UPDATE `users` SET `u_family_rank` = '1' WHERE `u_family` = '%d' LIMIT %d", familyid, ( family_info [ familyid - 1 ] [ fam_members ] > 0 ) ? ( family_info [ familyid - 1 ] [ fam_members ] ) : ( 1 ) ) ;
			mysql_tquery ( sql_connection, query ) ;

			p_info [ player_id ] [ family_rang ] = family_info [ familyid - 1 ] [ fam_settings ] [ 3 ] ;
			update_int_sql ( player_id, "u_family_rank", p_info [ player_id ] [ family_rang ] ) ;

			format ( query, sizeof query, "{"#cGInfo"}* {"#cGRInfo"}Вы успешно передали %s семью {%s}%s{"#cGRInfo"}.", p_info [ player_id ] [ name ], family_info [ familyid - 1 ] [ fam_chat_color ], family_info [ familyid - 1 ] [ fam_name ] ) ;
			SendClientMessage ( playerid, col_gray, query ) ;

			format ( query, sizeof query, "{"#cGInfo"}* {"#cGRInfo"}Теперь Вы новый лидер семьи {%s}%s{"#cGRInfo"}.", family_info [ familyid - 1 ] [ fam_chat_color ], family_info [ familyid - 1 ] [ fam_name ] ) ;
			SendClientMessage ( player_id, col_gray, query ) ;
			
			format ( query, sizeof query, "%s передал(а) семью %s.", p_info [ playerid ] [ name ], p_info [ player_id ] [ name ] ) ;
			write_family ( playerid, familyid, TYPE_LOG_OBWYAK, query ) ;
			
			if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
			else SetFamilyHide ( playerid ) ;
			return 1 ;
		}
		case d_fam_fixcar:
		{
			if ( ! response ) return show_family ( playerid ) ;

			new family_id = p_info [ playerid ] [ family ] ;
			if ( ! family_info [ family_id - 1 ] [ fam_house ] )
			{
				show_family ( playerid ) ;
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет дома семьи." ) ;
			}

			if ( listitem == 0 )
			{
				if ( family_info [ family_id - 1 ] [ fam_bank ] < price_fixcar * Iter_Count(family_vehicles[family_id]) )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В банке семьи недостаточно средств." ) ;

					show_fixcar ( playerid, 5 ) ;
					return 1 ;
				}
				
				if ( Iter_Count(family_vehicles[family_id]) < 1 )
				{
                    show_fixcar ( playerid, 5 ) ;
					return 1 ;
				}
				
				new _veh_count [ 50 ] = { INVALID_VEHICLE_ID, ... }, _slot_id = 0 ;
				foreach(new vehicleid: family_vehicles[family_id])
				{
				    if ( vehicleid >= 2000 && vehicleid <= INVALID_VEHICLE_ID ) continue ;
					if ( ! IsValidVehicle ( vehicleid ) ) continue ;
					if ( is_vehicle_occupied ( vehicleid ) != -1 ) continue ;

                    _veh_count [ _slot_id ] = vehicleid ;
                    _slot_id ++ ;
				}
				
				for ( new i = 0 ; i < _slot_id ; i ++ )
				{
					if ( _veh_count [ i ] == INVALID_VEHICLE_ID ) continue ;
					
					SetVehicleToRespawn ( _veh_count [ i ], 24 ) ;
				}
				
				SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Весь незанятый транспорт был отбуксирован." ) ;
				show_family ( playerid ) ;

				family_info [ family_id - 1 ] [ fam_bank ] -= price_fixcar * Iter_Count(family_vehicles[family_id]) ;

				new query_string [ 70 + 9 + 9 ];
				mysql_format ( sql_connection, query_string, sizeof query_string, "UPDATE `family` SET `fam_bank` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_bank ], family_id ) ;
				mysql_tquery ( sql_connection, query_string ) ;
				return 1 ;
			}
			if ( family_info [ family_id - 1 ] [ fam_bank ] < price_fixcar )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В банке семьи недостаточно средств." ) ;
			
			new vehicleid = get_player_listitem_values ( playerid, listitem - 1 ) ;
			show_menu_fixcar ( playerid, vehicleid, 5 ) ;
			return 1 ;
		}
		case d_fam_fixcar1:
		{
		    if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}

		    new family_id = p_info [ playerid ] [ family ] ;
		    switch ( listitem )
		    {
		        case 0:
		        {
		            global_string [ 0 ] = EOS ;
					for ( new i = 0; i < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] ; i ++ )
					{
						new line_string [ 64 ] ;
						format ( line_string, 64, "{"#cGRDialog"}%i.{"#cWH"} %s\n", i + 1, family_rank [ family_id - 1 ] [ i ] ) ;
						strcat ( global_string, line_string ) ;
					}
					show_dialog ( playerid, d_fam_fixcar2, DIALOG_STYLE_LIST, "{"#cBHD"}Ранг доступности", global_string, "Выбрать", "Назад" ) ;
		        }
		        case 1:
		        {
		        	new vehicleid = get_player_use_listitem ( playerid ) ;
		        	
			    	if ( is_vehicle_occupied ( vehicleid ) != -1) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Транспорт используется." ) ;
					SetVehicleToRespawn ( vehicleid, 25 ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Транспорт отремонтирован и отбуксирован к месту стоянки." ) ;
					family_info [ family_id - 1 ] [ fam_bank ] -= price_fixcar ;

					new query_string [ 70 + 9 + 9 ];
					mysql_format ( sql_connection, query_string, sizeof query_string, "UPDATE `family` SET `fam_bank` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_bank ], family_id ) ;
					mysql_tquery ( sql_connection, query_string ) ;

					if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
					else show_packet_family ( playerid, 14, 0, 0 ) ;
		        }
		        case 2:
		        {
		            if ( GetPlayerState ( playerid ) != PLAYER_STATE_DRIVER ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нужно быть в транспорте." ) ;

					new s_house_id = family_info [ family_id - 1 ] [ fam_house ] ;
					if ( ! IsPlayerInRangeOfPoint ( playerid, 50, h_info [ s_house_id - 1 ] [ h_pos ] [ 0 ],
															h_info [ s_house_id - 1 ] [ h_pos ] [ 1 ],
															h_info [ s_house_id - 1 ] [ h_pos ] [ 2 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны находиться около дома." ) ;
					if ( GetPlayerVirtualWorld ( playerid ) != 0 || GetPlayerInterior ( playerid ) != 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны находиться около дома." ) ;

					new veh_id = get_player_use_listitem ( playerid ) ;

					if ( GetPlayerVehicleID ( playerid ) != veh_id ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нужно быть в транспорте, который хотите переставить." ) ;

		            SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Позиция автомобиля изменена." ) ;

		            GetVehiclePos ( veh_id, veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] ) ;
					GetVehicleZAngle ( veh_id, veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] ) ;

					new new_veh_id = CreateVehicle( getReplacableVehicleModel ( veh_id ), veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ], veh_info [ veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ veh_id - 1 ] [ v_color ] [ 1 ], SPAWN_TIME_FAMILY_VEHICLE ) ;
					Iter_Add(family_vehicles[family_id], new_veh_id ) ;

					veh_info [ new_veh_id - 1 ] [ v_type ] = vehicle_type_family ;
					veh_info [ new_veh_id - 1 ] [ v_id ] = veh_info [ veh_id - 1 ] [ v_id ] ;
					veh_info [ new_veh_id - 1 ] [ v_pos ] [ 0 ] = veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ] ;
					veh_info [ new_veh_id - 1 ] [ v_pos ] [ 1 ] = veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ] ;
					veh_info [ new_veh_id - 1 ] [ v_pos ] [ 2 ] = veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] ;
					veh_info [ new_veh_id - 1 ] [ v_pos ] [ 3 ] = veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] ;

					veh_info [ new_veh_id - 1 ] [ v_model ] = veh_info [ veh_id - 1 ] [ v_model ] ;
					veh_info [ new_veh_id - 1 ] [ v_owner ] = veh_info [ veh_id - 1 ] [ v_owner ] ;
					veh_info [ new_veh_id - 1 ] [ v_color ] [ 0 ] = veh_info [ veh_id - 1 ] [ v_color ] [ 0 ] ;
					veh_info [ new_veh_id - 1 ] [ v_color ] [ 1 ] = veh_info [ veh_id - 1 ] [ v_color ] [ 1 ] ;

					veh_info [ new_veh_id - 1 ] [ v_rank ] = veh_info [ veh_id - 1 ] [ v_rank ] ;
					veh_info [ new_veh_id - 1 ] [ v_owner_fam ] = veh_info [ veh_id - 1 ] [ v_owner_fam ] ;

					veh_info [ new_veh_id - 1 ] [ v_paint ] = veh_info [ veh_id - 1 ] [ v_paint ] ;
					if ( veh_info [ new_veh_id - 1 ] [ v_paint ] != 3 )
					{
						ChangeVehiclePaintjob ( new_veh_id, veh_info [ new_veh_id - 1 ] [ v_paint ] ) ;
					}

					veh_info [ new_veh_id - 1 ] [ v_locked ] = veh_info [ veh_id - 1 ] [ v_locked ] ;

					format ( veh_info [ new_veh_id - 1 ] [ v_plate ], 12, "%s", veh_info [ veh_id - 1 ] [ v_plate ] ) ;
					format ( veh_info [ new_veh_id - 1 ] [ v_region ], 12, "%s", veh_info [ veh_id - 1 ] [ v_region ] ) ;
					veh_info [ new_veh_id - 1 ] [ v_plate_type ] = veh_info [ veh_id - 1 ] [ v_plate_type ] ;

					veh_info [ new_veh_id - 1 ] [ v_fuel ] = veh_info [ veh_id - 1 ] [ v_fuel ] ;
					veh_info [ new_veh_id - 1 ] [ v_millage ] = veh_info [ veh_id - 1 ] [ v_millage ] ;
					
					veh_info [ new_veh_id - 1 ] [ v_suspension ] [ 0 ] = veh_info [ veh_id - 1 ] [ v_suspension ] [ 0 ] ;
					veh_info [ new_veh_id - 1 ] [ v_suspension ] [ 1 ] = veh_info [ veh_id - 1 ] [ v_suspension ] [ 1 ] ;
					veh_info [ new_veh_id - 1 ] [ v_wheel_size ] = veh_info [ veh_id - 1 ] [ v_wheel_size ] ;
					veh_info [ new_veh_id - 1 ] [ v_wheel_width ] = veh_info [ veh_id - 1 ] [ v_wheel_width ] ;
					veh_info [ new_veh_id - 1 ] [ v_wheel_alignment ] [ 0 ] = veh_info [ veh_id - 1 ] [ v_wheel_alignment ] [ 0 ] ;
					veh_info [ new_veh_id - 1 ] [ v_wheel_alignment ] [ 1 ] = veh_info [ veh_id - 1 ] [ v_wheel_alignment ] [ 1 ] ;
					veh_info [ new_veh_id - 1 ] [ v_lights_color ] = veh_info [ veh_id - 1 ] [ v_lights_color ] ;
					veh_info [ new_veh_id - 1 ] [ v_neon ] = veh_info [ veh_id - 1 ] [ v_neon ] ;
					veh_info [ new_veh_id - 1 ] [ v_neon_type ] = veh_info [ veh_id - 1 ] [ v_neon_type ] ;
					veh_info [ new_veh_id - 1 ] [ v_toner ] [ 0 ] = veh_info [ veh_id - 1 ] [ v_toner ] [ 0 ] ;
					veh_info [ new_veh_id - 1 ] [ v_toner ] [ 1 ] = veh_info [ veh_id - 1 ] [ v_toner ] [ 1 ] ;
					veh_info [ new_veh_id - 1 ] [ v_toner ] [ 2 ] = veh_info [ veh_id - 1 ] [ v_toner ] [ 2 ] ;
					veh_info [ new_veh_id - 1 ] [ v_toner ] [ 3 ] = veh_info [ veh_id - 1 ] [ v_toner ] [ 3 ] ;
					veh_info [ new_veh_id - 1 ] [ v_vinyl ] = veh_info [ veh_id - 1 ] [ v_vinyl ] ;

					veh_info [ new_veh_id - 1 ] [ v_stage_speed ] = veh_info [ veh_id - 1 ] [ v_stage_speed ] ;
					veh_info [ new_veh_id - 1 ] [ v_stage_brake ] = veh_info [ veh_id - 1 ] [ v_stage_brake ] ;
			
					veh_info [ new_veh_id - 1 ] [ v_pantera_strobs ] = veh_info [ veh_id - 1 ] [ v_pantera_strobs ] ;
					veh_info [ new_veh_id - 1 ] [ v_pantera_alarm ] = veh_info [ veh_id - 1 ] [ v_pantera_alarm ] ;
					veh_info [ new_veh_id - 1 ] [ v_pantera_engine ] = veh_info [ veh_id - 1 ] [ v_pantera_engine ] ;
					veh_info [ new_veh_id - 1 ] [ v_pantera_radar ] = veh_info [ veh_id - 1 ] [ v_pantera_radar ] ;
					veh_info [ new_veh_id - 1 ] [ v_pantera_gps ] = veh_info [ veh_id - 1 ] [ v_pantera_gps ] ;
					veh_info [ new_veh_id - 1 ] [ v_pantera_armour ] = veh_info [ veh_id - 1 ] [ v_pantera_armour ] ;
					veh_info [ new_veh_id - 1 ] [ v_pantera_launch ] = veh_info [ veh_id - 1 ] [ v_pantera_launch ] ;
					veh_info [ new_veh_id - 1 ] [ v_sound ] = veh_info [ veh_id - 1 ] [ v_sound ] ;

					veh_info [ new_veh_id - 1 ] [ v_engine_boost ] = veh_info [ veh_id - 1 ] [ v_engine_boost ] ;
					veh_info [ new_veh_id - 1 ] [ v_brake_boost ] = veh_info [ veh_id - 1 ] [ v_brake_boost ] ;
					veh_info [ new_veh_id - 1 ] [ v_stability_boost ] = veh_info [ veh_id - 1 ] [ v_stability_boost ] ;

					for ( new i = 0 ; i < 5 ; i ++ )
					{
						veh_info [ new_veh_id - 1 ] [ v_pt_engine ] [ i ] = veh_info [ veh_id - 1 ] [ v_pt_engine ] [ i ] ;
						veh_info [ new_veh_id - 1 ] [ v_pt_brake ] [ i ] = veh_info [ veh_id - 1 ] [ v_pt_engine ] [ i ] ;
						veh_info [ new_veh_id - 1 ] [ v_pt_stability ] [ i ] = veh_info [ veh_id - 1 ] [ v_pt_engine ] [ i ] ;
					}
					veh_info [ new_veh_id - 1 ] [ v_vehicle ] = new_veh_id ;

					veh_info [ new_veh_id - 1 ] [ v_vw ] = GetPlayerVirtualWorld ( playerid ) ;
					veh_info [ new_veh_id - 1 ] [ v_int ] = GetPlayerInterior ( playerid ) ;
					if ( veh_info [ new_veh_id - 1 ] [ v_int ] != 0 )LinkVehicleToInterior ( new_veh_id, veh_info [ new_veh_id - 1 ] [ v_int ] ) ;
					if ( veh_info [ new_veh_id - 1 ] [ v_vw ] != 0 )SetVehicleVirtualWorld ( new_veh_id, veh_info [ new_veh_id - 1 ] [ v_vw ] ) ;

					veh_plate ( new_veh_id ) ;

					for ( new j = 0; j < 10; j ++ )
					{
						veh_info [ new_veh_id - 1 ] [ v_component ] [ j ] = veh_info [ veh_id - 1 ] [ v_component ] [ j ] ;
						AddVehicleComponent ( veh_info [ new_veh_id - 1 ] [ v_vehicle ], veh_info [ new_veh_id - 1 ] [ v_component ] [ j ] ) ;
					}

					SetVehicleNumberPlate ( new_veh_id, veh_info [ new_veh_id - 1 ] [ v_plate ] ) ;

					OnVehicleIteration ( new_veh_id ) ;
					DestroyVehicle ( veh_id, 5 ) ;
					Iter_Remove(family_vehicles[family_id], veh_id ) ;

         			new query_string [ 165 + ( 4 * 8 ) + ( 2 * 9 ) + 9 ];
     		   		format ( query_string, sizeof query_string, "UPDATE `familys_vehicles` SET `sv_pos_x` = '%f', `sv_pos_y` = '%f', `sv_pos_z` = '%f', `sv_pos_a` = '%f',`v_vw` = '%d',`v_int` = '%d' WHERE `sv_id` = '%d' LIMIT 1",
         	   		veh_info [ new_veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ new_veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ new_veh_id - 1 ] [ v_pos ] [ 2 ], veh_info [ new_veh_id - 1 ] [ v_pos ] [ 3 ],
					veh_info [ new_veh_id - 1 ] [ v_vw ], veh_info [ new_veh_id - 1 ] [ v_int ], veh_info [ new_veh_id - 1 ] [ v_id ] ) ;
     		  		mysql_tquery ( sql_connection, query_string ) ;

					if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
					else show_packet_family ( playerid, 14, 0, 0 ) ;
		        }
				case 3:
				{
				    new vehicleid = get_player_use_listitem ( playerid ) ;
				    
				    SetPlayerRaceCheckpoint ( playerid, 1, veh_info [ vehicleid - 1 ] [ v_pos ] [ 0 ], veh_info [ vehicleid - 1 ] [ v_pos ] [ 1 ], veh_info [ vehicleid - 1 ] [ v_pos ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
					is_gps_used { playerid } = 1 ;
				}
				case 4:
				{
				    new vehicleid = get_player_use_listitem ( playerid ) ;

					new line_string [ 144 ] ;
					if ( veh_info [ vehicleid - 1 ] [ v_owner_fam ] > 0 && veh_info [ vehicleid - 1 ] [ v_owner_fam ] != p_info [ playerid ] [ id ] )
					{
						format ( line_string, sizeof line_string, "{"#cWH"}Вы собиратесь вернуть {"#cGN"}%s {"#cWH"} его владельцу.\n\n{"#cGRDialog"}* Вы уверены?", GetVehicleNameEx ( veh_info [ vehicleid - 1 ] [ v_vehicle ] ) ) ;
						show_dialog ( playerid, d_fam_fixcar_sell, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Возврат транспорта", line_string, "Выбрать", "Назад" ) ;
					}
					else
					{
						format ( line_string, sizeof line_string, "{"#cWH"}Вы собиратесь продать {"#cGN"}%s {"#cWH"}за {"#cGN"}%d"valute_title"{"#cWH"}.\n\n{"#cGRDialog"}* Вы уверены?", GetVehicleNameEx ( veh_info [ vehicleid - 1 ] [ v_vehicle ] ), veh_info [ vehicleid - 1 ] [ v_price ] ) ;
						show_dialog ( playerid, d_fam_fixcar_sell, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Продажа транспорта", line_string, "Выбрать", "Назад" ) ;
					}
				}
		    }
			return 1 ;
		}
		case d_fam_fixcar_sell:
		{
		    if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}

            new family_id = p_info [ playerid ] [ family ] ;
            new vehicleid = get_player_use_listitem ( playerid ) ;
			
			new query_string [ 71 + 9 + 9 ] ;
			if ( veh_info [ vehicleid - 1 ] [ v_owner_fam ] > 0 )
			{
				new string [ 144 ] ;
				format ( string, sizeof string, "UPDATE `users_vehicles` SET `v_fine` = '1' WHERE `v_owner` = '%d' AND `v_model` = '%d' AND `v_fine` = '2' LIMIT 1", veh_info [ vehicleid - 1 ] [ v_owner_fam ], veh_info [ vehicleid - 1 ] [ v_model ] ) ;
				mysql_tquery ( sql_connection, string ) ;
				
				format ( string, sizeof string, "Вернул(а) т/с %s владельцу из семьи (account id: %d).", GetVehicleNameEx ( -1, veh_info [ vehicleid - 1 ] [ v_model ] ), veh_info [ vehicleid - 1 ] [ v_owner_fam ] ) ;
				WriteLogs ( playerid, p_info [ playerid ] [ member ], TYPE_LOG_FAMILY_CAR, string ) ;
			}
			
			format ( query_string, sizeof query_string, "DELETE FROM `familys_vehicles` WHERE `sv_id` = '%d' LIMIT 1", veh_info [ vehicleid - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, query_string ) ;
			
			new target_id = veh_info [ vehicleid - 1 ] [ v_renter ] ;
		    if ( target_id != INVALID_PLAYER_ID && IsPlayerConnected ( target_id ) )
		   	{
				player_rentcar [ target_id ] = INVALID_VEHICLE_ID ;
				SendClientMessage ( target_id, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Арендованный транспорт был отбуксирован. Владелец забрал своё т/с из семьи." ) ;
			}

            Iter_Remove(family_vehicles[family_id], vehicleid ) ;
		    DestroyVehicle ( vehicleid, 5 ) ;

		    if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
			else show_packet_family ( playerid, 14, 0, 0 ) ;
			return 1 ;
		}
		case d_fam_fixcar2:
		{
			if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}

			new vehicle_id = get_player_use_listitem ( playerid ) ;
			
			veh_info [ vehicle_id - 1 ] [ v_rank ] = listitem + 1 ;

			new query_string [ 78 + 9 + 9 ] ;
            format ( query_string, sizeof query_string, "UPDATE `familys_vehicles` SET `sv_rank` = '%d' WHERE `sv_id` = '%d' LIMIT 1",
            veh_info [ vehicle_id - 1 ] [ v_rank ],
			veh_info [ vehicle_id - 1 ] [ v_id ] ) ;
            mysql_tquery ( sql_connection, query_string ) ;

           	if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
			else show_packet_family ( playerid, 14, 0, 0 ) ;
			return 1 ;
		}
		case d_blacklist_family:
		{
			if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}
			switch ( listitem )
			{
				case 0:
				{
					new _family_id = p_info [ playerid ] [ family ] ;
					if ( p_info [ playerid ] [ family_rang ] < family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] )
				    {
						static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Чёрный список доступен со статуса %s (%d)." ;
					    new scm_string [ sizeof _str ] ;
					    format ( scm_string, sizeof scm_string, _str, family_rank [ _family_id - 1 ] [ family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] - 1 ], family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] ) ;
						SendClientMessage ( playerid, col_gray, scm_string ) ;
						return 1 ;
					}
					
					show_dialog ( playerid, d_blinvite_family, DIALOG_STYLE_INPUT, "{"#cBHD"}Чёрный список", "{FFFFFF}Введите ID игрока и причину, которого хотите добавить в чёрный список:\n\n{"#cGRDialog"}* Пример ввода: 1, оскорбление семьи", "Принять", "Назад" ) ;
				}
				case 1:
				{
					new _family_id = p_info [ playerid ] [ family ] ;
					if ( p_info [ playerid ] [ family_rang ] < family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] )
				    {
						static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Чёрный список доступен со статуса %s (%d)." ;
					    new scm_string [ sizeof _str ] ;
					    format ( scm_string, sizeof scm_string, _str, family_rank [ _family_id - 1 ] [ family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] - 1 ], family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] ) ;
						SendClientMessage ( playerid, col_gray, scm_string ) ;
						return 1 ;
					}
					
					show_dialog ( playerid, d_blclear_family, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Чёрный список", "{FFFFFF}\n\nВы действительно желаете очистить чёрный список семьи?\n\n{"#cGRDialog"}* Отменить данное действие будет невозможно", "Принять", "Назад" ) ;
				}
				case 2:
				{
					new _family_id = p_info [ playerid ] [ family ] ;
					if ( p_info [ playerid ] [ family_rang ] < family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] )
				    {
						static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Чёрный список доступен со статуса %s (%d)." ;
					    new scm_string [ sizeof _str ] ;
					    format ( scm_string, sizeof scm_string, _str, family_rank [ _family_id - 1 ] [ family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] - 1 ], family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] ) ;
						SendClientMessage ( playerid, col_gray, scm_string ) ;
						return 1 ;
					}
					
					show_dialog ( playerid, d_bluninvite_family, DIALOG_STYLE_INPUT, "{"#cBHD"}Чёрный список", "{FFFFFF}Введите имя игрока, которого хотите удалить из чёрного списка:", "Принять", "Назад" ) ;
				}
				case 3:
				{
					new _family_id = p_info [ playerid ] [ family ] ;
					if ( p_info [ playerid ] [ family_rang ] < family_info [ _family_id - 1 ] [ fam_settings ] [ 3 ] )
				    {
						SendClientMessage ( playerid, col_gray, "{"#cRInfo"}* {"#cGRInfo"}Данный раздел доступен только лидеру семьи!" ) ;
						return 1 ;
					}
					
				    new sql_string [ 79 + 9 ] ;
					format ( sql_string, sizeof sql_string, "SELECT `bl_name`,`bl_date` FROM `familys_blacklist` WHERE `bl_family` = '%d'", _family_id ) ;
					mysql_tquery ( sql_connection, sql_string, "callback_bl_family", "i", playerid ) ;
				    page_count [ playerid ] = 1 ;
				}
				case 4:
				{
					global_string [ 0 ] = EOS ;
					new line_string [ 100 ], _count = 0 ;
					
					new _family_id = p_info [ playerid ] [ family ] ;
					foreach(new i: logged_players)
					{
						if ( fam_bl_info [ i ] [ bl_onFrac ] [ _family_id ] )
						{
							_count ++ ;
							
							format ( line_string, sizeof line_string, "{"#cBL"}%i. {"#cGRDialog"}%s {"#cWH"}%s[%i]\n", _count, p_info [ i ] [ name ], i ) ;
							strcat ( global_string, line_string ) ;
						}
					}
					
					if ( _count == 0 ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Чёрный список", "{"#cGRDialog"}* Нет игроков из чёрного списка в сети!", "Закрыть", "" ) ;
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Чёрный список", global_string, "Закрыть", "" ) ;
				}
			}
			return 1 ;
		}
		case d_blclear_family:
		{
			if ( ! response )return show_dialog ( playerid, d_blacklist_family, DIALOG_STYLE_LIST, "{"#cBHD"}Чёрный список", "Добавить человека в чёрный список\nОчистить черный список\nУбрать человека из черного списка\nЧёрный список игроков\nЧёрный список игроков [ {"#cGN"}ОНЛАЙН{"#cWH"} ]", "Выбрать", "Назад" ) ;
			
			new _family_id = p_info [ playerid ] [ family ] ;
			new sql_string [ 59 + MAX_PLAYER_NAME ] ;
			format ( sql_string, sizeof ( sql_string ), "DELETE FROM `familys_blacklist` WHERE `bl_family` = '%d'", _family_id ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
			
			foreach(new i: logged_players)
			{
			    if ( fam_bl_info [ i ] [ bl_onFrac ] [ _family_id ] )
			    {
			        fam_bl_info [ i ] [ bl_onFrac ] [ _family_id ] =
					fam_bl_info [ i ] [ bl_kills ] [ _family_id ] = 0 ;
				}
			}

			format(sql_string, sizeof sql_string, "%s очистил(а) чёрный список.", p_info [ playerid ] [ name ]);
			write_family(playerid, p_info [ playerid ] [ family ], TYPE_LOG_BL, sql_string);

			SendClientMessage ( playerid, col_succes, "Чёрный список успешно очищен." );
			show_dialog ( playerid, d_blacklist_family, DIALOG_STYLE_LIST, "{"#cBHD"}Чёрный список", "Добавить человека в чёрный список\nОчистить черный список\nУбрать человека из черного списка\nЧёрный список игроков\nЧёрный список игроков [ {"#cGN"}ОНЛАЙН{"#cWH"} ]", "Выбрать", "Назад" ) ;
			return 1 ;
		}
		case d_bluninvite_family:
		{
			if ( ! response )
			{
				show_dialog ( playerid, d_blacklist_family, DIALOG_STYLE_LIST, "{"#cBHD"}Чёрный список", "Добавить человека в чёрный список\nОчистить черный список\nУбрать человека из черного списка\nЧёрный список игроков\nЧёрный список игроков [ {"#cGN"}ОНЛАЙН{"#cWH"} ]", "Выбрать", "Назад" ) ;
				return 1 ;
			}
			if ( ! strlen ( inputtext ) )return show_dialog ( playerid, d_bluninvite_family, DIALOG_STYLE_INPUT, "{"#cBHD"}Чёрный список", "{"#cGRDialog"}Неверный формат никнейма!\n\n{FFFFFF}Введите имя игрока, которого хотите удалить из чёрного списка:", "Принять", "Назад" ) ;
			if ( is_text_invalid ( inputtext ) )return show_dialog ( playerid, d_bluninvite_family, DIALOG_STYLE_INPUT, "{"#cBHD"}Чёрный список", "{"#cGRDialog"}Неверный формат никнейма!\n\n{FFFFFF}Введите имя игрока, которого хотите удалить из чёрного списка:", "Принять", "Назад" ) ;
			if ( strlen ( inputtext ) < 6 || strlen ( inputtext ) > 24 )return show_dialog ( playerid, d_bluninvite_family, DIALOG_STYLE_INPUT, "{"#cBHD"}Чёрный список", "{"#cGRDialog"}Неверный формат никнейма!\n\n{FFFFFF}Введите имя игрока, которого хотите удалить из чёрного списка:", "Принять", "Назад" ) ;

			new query_string [ 138 ] ;
			mysql_format ( sql_connection, query_string, sizeof ( query_string ),"SELECT `bl_player` FROM `familys_blacklist` WHERE `bl_name` = '%e' AND `bl_family`='%d' LIMIT 1",
			inputtext, p_info [ playerid ] [ family ] ) ;
			mysql_tquery ( sql_connection, query_string, "check_bl_list_family", "dsd", playerid, inputtext, 1 ) ;
			return 1 ;
		}
		case d_blinvite_family:
		{
			if ( ! response )
			{
				show_dialog ( playerid, d_blacklist_family, DIALOG_STYLE_LIST, "{"#cBHD"}Чёрный список", "Добавить человека в чёрный список\nОчистить черный список\nУбрать человека из черного списка\nЧёрный список игроков\nЧёрный список игроков [ {"#cGN"}ОНЛАЙН{"#cWH"} ]", "Выбрать", "Назад" ) ;
				return 1 ;
			}
			new targetid, reason [ 24 ], family_id = p_info [ playerid ] [ family ] ;
			if ( sscanf ( inputtext, "p<,>ds[24]", targetid, reason ) )
			{
			    show_dialog ( playerid, d_blinvite_family, DIALOG_STYLE_INPUT, "{"#cBHD"}Чёрный список", "{FFFFFF}Введите ID игрока и причину, которого хотите добавить в чёрный список:\n\n{"#cGRDialog"}* Пример ввода: 1, оскорбление семьи", "Принять", "Назад" ) ;
			    return 1 ;
			}
			if ( targetid < 0 ) return show_dialog ( playerid, d_blinvite_family, DIALOG_STYLE_INPUT, "{"#cBHD"}Чёрный список", "{"#cGRDialog"}Неверный ID игрока!\n\n{FFFFFF}Введите ID игрока, которого хотите добавить в чёрный список:\n\n{"#cGRDialog"}* Пример ввода: 1, оскорбление семьи", "Принять", "Назад" ) ;
			if ( ! IsPlayerConnected ( targetid ) || targetid == playerid ) return show_dialog ( playerid, d_blinvite_family, DIALOG_STYLE_INPUT, "{"#cBHD"}Чёрный список", "{"#cGRDialog"}Неверный ID игрока!\n\n{FFFFFF}Введите ID игрока, которого хотите добавить в чёрный список:\n\n{"#cGRDialog"}* Пример ввода: 1, оскорбление семьи", "Принять", "Назад" ) ;
			if ( p_info [ targetid ] [ family ] == family_id ) return show_dialog ( playerid, d_blinvite_family, DIALOG_STYLE_INPUT, "{"#cBHD"}Чёрный список", "{"#cGRDialog"}Игрок в Вашей семье!\n\n{FFFFFF}Введите ID игрока, которого хотите добавить в чёрный список:\n\n{"#cGRDialog"}* Пример ввода: 1, оскорбление семьи", "Принять", "Назад" ) ;
			if ( strlen ( reason ) < 5 ) return show_dialog ( playerid, d_blinvite_family, DIALOG_STYLE_INPUT, "{"#cBHD"}Чёрный список", "{"#cGRDialog"}Причина слишком коротка!\n\n{FFFFFF}Введите ID игрока, которого хотите добавить в чёрный список:\n\n{"#cGRDialog"}* Пример ввода: 1, оскорбление семьи", "Принять", "Назад" ) ;
            if ( strlen ( reason ) > 24 ) return show_dialog ( playerid, d_blinvite_family, DIALOG_STYLE_INPUT, "{"#cBHD"}Чёрный список", "{"#cGRDialog"}Причина слишком длинная!\n\n{FFFFFF}Введите ID игрока, которого хотите добавить в чёрный список:\n\n{"#cGRDialog"}* Пример ввода: 1, оскорбление семьи", "Принять", "Назад" ) ;

            fam_bl_info [ targetid ] [ bl_onFrac ] [ family_id ] = 1 ;
			fam_bl_info [ targetid ] [ bl_kills ] [ family_id ] = 0 ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 356, "INSERT INTO `familys_blacklist`(`bl_death`,`bl_player`,`bl_family`,`bl_name`,`bl_date`,`bl_last_date`,`bl_reason`,`bl_add_name`) VALUES ('%d','%d','%d','%s',NOW(),NOW(),'%s','%s')",
			fam_bl_info [ targetid ] [ bl_kills ] [ family_id ], p_info [ targetid ] [ id ], family_id, p_info [ targetid ] [ name ], reason, p_info [ playerid ] [ name ] ) ;
			mysql_tquery ( sql_connection, global_string ) ;

			global_string [ 0 ] = EOS ;
			format(global_string, 128, "%s добавил(а) %s в чёрный список семьи \"%s\". Причина: %s", p_info [ playerid ] [ name ], p_info [ targetid ] [ name ], family_info [ family_id - 1 ] [ fam_name ], reason);
			write_family(playerid, p_info [ playerid ] [ family ], TYPE_LOG_BL, global_string);

			global_string [ 0 ] = EOS ;
			format ( global_string, 144, "{"#cGInfo"}* {"#cWH"}%s добавил Вас в чёрный список семьи \"%s\". Причина: %s", p_info [ playerid ] [ name ], family_info [ family_id - 1 ] [ fam_name ], reason ) ;
			SendClientMessage ( targetid, col_white, global_string ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 144, "{"#cGInfo"}* {"#cWH"}Вы добавили в чёрный список %s.", p_info [ targetid ] [ name ]);
			SendClientMessage ( playerid, col_white, global_string );
			
			show_dialog ( playerid, d_blacklist_family, DIALOG_STYLE_LIST, "{"#cBHD"}Чёрный список", "Добавить человека в чёрный список\nОчистить черный список\nУбрать человека из черного списка\nЧёрный список игроков\nЧёрный список игроков [ {"#cGN"}ОНЛАЙН{"#cWH"} ]", "Выбрать", "Назад" ) ;
			return 1 ;
		}
		case d_family_bank:
		{
		    if ( ! response )
			{
				if ( used_inventory [ playerid ] == true ) return 1 ;
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}
			
			switch ( listitem )
			{
			    case 0:
				{
					new header_string [ 64 ] ;
					format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_bank ] ) ) ;
					inv_dialog ( playerid, d_family_bank_put, DIALOG_STYLE_INPUT, header_string, "{"#cWH"}Введите сумму, которую хотите положить в банк семьи:", "Выбрать", "Назад" ) ;
			    }
				case 1: 
				{
					new header_string [ 64 ] ;
					format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_bank ] ) ) ;
					inv_dialog ( playerid, d_family_bank_take, DIALOG_STYLE_INPUT, header_string, "{"#cWH"}Введите сумму, которую хотите взять с банка семьи:", "Выбрать", "Назад" ) ;
				}
			}
			return 1 ;
		}
		case d_family_bank_put:
		{
		    if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}

		    new _value = strval ( inputtext ), familyid = p_info [ playerid ] [ family ] ;
		    if ( p_info [ playerid ] [ hour_played ] < 5 )
			{
				new header_string [ 64 ] ;
				format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ familyid - 1 ] [ fam_bank ] ) ) ;
				inv_dialog ( playerid, d_family_bank_put, DIALOG_STYLE_INPUT, header_string, "{"#cWH"}Введите сумму, которую хотите положить в банк семьи:\n\n{"#cGRDialog"}* Доступно с 5 часов в игре", "Выбрать", "Назад" ) ;
				return 1 ;
			}
			if ( _value < 1 )
			{
				new header_string [ 64 ] ;
				format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ familyid - 1 ] [ fam_bank ] ) ) ;
				inv_dialog ( playerid, d_family_bank_put, DIALOG_STYLE_INPUT, header_string, "{"#cWH"}Введите сумму, которую хотите положить в банк семьи:\n\n{"#cGRDialog"}* Нельзя положить менее 1"valute_title_"", "Выбрать", "Назад" ) ;
				return 1 ;
			}
			if ( _value > p_info [ playerid ] [ money ] )
			{
				new header_string [ 64 ] ;
				format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ familyid - 1 ] [ fam_bank ] ) ) ;
				inv_dialog ( playerid, d_family_bank_put, DIALOG_STYLE_INPUT, header_string, "{"#cWH"}Введите сумму, которую хотите положить в банк семьи:\n\n{"#cGRDialog"}* У Вас недостаточно средств", "Выбрать", "Назад" ) ;
				return 1 ;
			}
			if ( family_info [ familyid - 1 ] [ fam_bank ] + _value > max_money || family_info [ familyid - 1 ] [ fam_bank ] + _value < min_money )
			{
				new header_string [ 64 ] ;
				format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ familyid - 1 ] [ fam_bank ] ) ) ;
				inv_dialog ( playerid, d_family_bank_put, DIALOG_STYLE_INPUT, header_string, "{"#cWH"}Введите сумму, которую хотите положить в банк семьи:\n\n{"#cGRDialog"}* Лимит средств в общаке не может превышать 1.800.000.000"valute_title_"", "Выбрать", "Назад" ) ;
				return 1 ;
			}
            new fm_string [ 128 ] ;
          	format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] %s %s[%i] положил(а) в банк семьи %d"valute_title_"", family_info [ familyid - 1 ] [ fam_chat_color ], family_rank [ familyid - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, _value ) ;
        	family_message ( familyid, col_gray, fm_string ) ;

        	give_money ( playerid, -_value ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -_value, "банк фамы" ) ;

            family_info [ familyid - 1 ] [ fam_bank ] += _value ;

			mysql_format ( sql_connection, fm_string, sizeof fm_string, "UPDATE `family` SET `fam_bank` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ familyid - 1 ] [ fam_bank ], familyid ) ;
			mysql_tquery ( sql_connection, fm_string ) ;

			format ( fm_string, sizeof fm_string, "%s положил в банк семьи %d"valute_title".", p_info [ playerid ] [ name ], _value);
			write_family ( playerid, familyid, TYPE_LOG_OBWYAK, fm_string ) ;

			if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
			else show_packet_family ( playerid, 3, 0, 0 ) ;
			return 1 ;
		}
		case d_family_bank_take:
		{
		    if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
				return 1 ;
			}

		    new _value = strval ( inputtext ), familyid = p_info [ playerid ] [ family ] ;

			if ( ! GetString ( family_info [ familyid - 1 ] [ fam_creator ], p_info [ playerid ] [ name ] ) )
			{
				show_family ( playerid ) ;
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Брать деньги с банка семьи может только лидер." ) ;
			}

		    if ( _value < 1 )
			{
				new header_string [ 64 ] ;
				format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ familyid - 1 ] [ fam_bank ] ) ) ;
				inv_dialog ( playerid, d_family_bank_take, DIALOG_STYLE_INPUT, header_string, "{"#cWH"}Введите сумму, которую хотите взять с банка семьи:\n\n{"#cGRDialog"}* Нельзя взять менее 1"valute_title_"", "Выбрать", "Назад" ) ;
				return 1 ;
			}
			if ( family_info [ familyid - 1 ] [ fam_bank ] < _value )
			{
				new header_string [ 64 ] ;
				format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ familyid - 1 ] [ fam_bank ] ) ) ;
				inv_dialog ( playerid, d_family_bank_take, DIALOG_STYLE_INPUT, "{"#cBHD"}Банк семьи", "{"#cWH"}Введите сумму, которую хотите взять с банка семьи:\n\n{"#cGRDialog"}* В банке семьи недостаточно средств", "Выбрать", "Назад" ) ;
				return 1 ;
			}

            new fm_string [ 128 ] ;
          	format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] %s %s[%i] взял(а) c банка семьи %d"valute_title_"", family_info [ familyid - 1 ] [ fam_chat_color ], family_rank [ familyid - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid, _value ) ;
        	family_message ( familyid, col_gray, fm_string ) ;

        	give_money ( playerid, _value ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _value, "банк фамы" ) ;

            family_info [ familyid - 1 ] [ fam_bank ] -= _value ;

			fm_string [ 0 ] = EOS ;
			mysql_format ( sql_connection, fm_string, sizeof fm_string, "UPDATE `family` SET `fam_bank` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ familyid - 1 ] [ fam_bank ], familyid ) ;
			mysql_tquery ( sql_connection, fm_string ) ;

			fm_string [ 0 ] = EOS ;
			format ( fm_string, sizeof fm_string, "%s взял с банка семьи %d"valute_title".", p_info [ playerid ] [ name ], _value);
			write_family ( playerid, familyid, TYPE_LOG_OBWYAK, fm_string ) ;

			if ( player_open_family [ playerid ] == false ) show_family ( playerid ) ;
			else show_packet_family ( playerid, 3, 0, 0 ) ;
			return 1 ;
		}
		case d_family_omembers:
		{
			if ( ! response )
			{
			    if ( page_count [ playerid ] == 1 )
				{
				    page_count [ playerid ] = 0 ;
				    page_rows [ playerid ] = 0 ;
					show_family ( playerid ) ;
					return 1 ;
				}
                page_count [ playerid ] -= 1 ;
				ShowFamMembers ( playerid ) ;
				return 1 ;
			}

			if ( page_count [ playerid ] * 20 >= page_rows [ playerid ] )
           	{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка членов семьи." ) ;
				ShowFamMembers ( playerid ) ;
				return 1 ;
			}
            page_count [ playerid ] += 1 ;
			ShowFamMembers ( playerid ) ;
			return 1 ;
		}
		case d_family_info:
		{
			if ( response ) return show_family ( playerid ) ;
		}
		case d_family_dorm:
		{
			if ( ! response ) return 1 ;
			switch ( listitem )
			{
				case 0:
				{
					if ( player_device { playerid } == 2 )
					{
						used_inventory [ playerid ] = true ;
						toggle_controlable ( playerid, false ) ;

						TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
						TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
						TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
						TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
						TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
						TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;

						SetInventoryShow ( playerid ) ;
						SetInventoryItem ( playerid ) ;
						invUpdateData ( playerid ) ;
						SetInventorySubItem ( playerid, 0, "Кейс" ) ;
						SetInventorySubItem ( playerid, 1, "" ) ;
						SetInventorySubItem ( playerid, 2, "Броня" ) ;
						set_inventory_button ( playerid, 10 ) ;
						show_packet_inventory ( playerid, 0, 10, 0 ) ;
						return 1 ;
					}
				}
				case 1: show_dialog ( playerid, d_ftalons_put, DIALOG_STYLE_INPUT, "{"#cBHD"}Положить "family_title":","{"#cWH"}Введите количество "family_title", которое желаете положить:","Положить","Назад");
				case 2:
				{
					if ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_dorm_status ] )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Общак закрыт." ) ;
					show_dialog ( playerid, d_ftalons_get, DIALOG_STYLE_INPUT, "{"#cBHD"}Взять "family_title":","{"#cWH"}Введите количество "family_title", которое желаете взять:","Взять","Назад");
				}
			}
			return 1 ;
		}
		case d_ftalons_get:
		{
			if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) show_family_dorm ( playerid ) ;
				return 1 ;
			}
			
			new d_amount = strval ( inputtext ), familyid = p_info [ playerid ] [ family ] ;
			if ( ! GetString ( family_info [ familyid - 1 ] [ fam_creator ], p_info [ playerid ] [ name ] ) )
			{
				show_family_dorm ( playerid ) ;
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Снимать "family_title" может только лидер семьи." ) ;
			}

			if ( d_amount < 1 || d_amount > 100000 ) return show_dialog ( playerid, d_ftalons_get, DIALOG_STYLE_INPUT, "{"#cBHD"}Взять "family_title":","{"#cRInfo"}* {"#cGRDialog"}Количество "family_title" должно быть от {"#cRD"}1 {"#cGRDialog"}до {"#cRD"}100.000\n\n{"#cWH"}Введите количество "family_title", которое желаете взять:","Взять","Назад");
			if ( family_info [ familyid - 1 ] [ fam_ticket ] < d_amount ) return show_dialog ( playerid, d_ftalons_get, DIALOG_STYLE_INPUT, "{"#cBHD"}Взять "family_title":","{"#cRInfo"}* {"#cGRDialog"}На складе нет такого количества "family_title".\n\n{"#cWH"}Введите количество "family_title", которое желаете взять:","Взять","Назад");

			family_info [ familyid - 1 ] [ fam_ticket ] -= d_amount ;
			p_info [ playerid ] [ family_ticket ] += d_amount ;
			update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;

			new query_string [ 128 ] ;
			format ( query_string, 86, "UPDATE `family` SET `fam_ticket` = '%d' WHERE `fam_id` = '%d' LIMIT 1",
			family_info [ familyid - 1 ] [ fam_ticket ], familyid ) ;
			mysql_tquery ( sql_connection, query_string, "", "" ) ;

			format ( query_string, sizeof ( query_string ), "{%s}[FAM] %s %s взял(а) со склада %i "family_title".", family_info [ familyid - 1 ] [ fam_chat_color ], family_rank [ familyid - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], d_amount ) ;
    		family_message ( familyid, col_gray, query_string ) ;

            format(query_string, 128, "%s взял со склада %d "family_title".", p_info [ playerid ] [ name ], d_amount);
			write_family(playerid, familyid, TYPE_LOG_OBWYAK, query_string);

   			if ( player_open_family [ playerid ] == false ) show_family_dorm ( playerid ) ;
			else
			{
				foreach(new i: family_players[familyid])
				{
					if ( p_info [ i ] [ family ] != familyid ) continue ;
					if ( player_last_page [ i ] != 6 ) continue ;
					
					show_packet_family ( i, 6, 0, 0 ) ;
				}
			}

			update_fdorm_text ( familyid ) ;
			return 1 ;
		}
		case d_ftalons_put:
		{
			if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) show_family_dorm ( playerid ) ;
				return 1 ;
			}
			
			new d_amount = strval ( inputtext ), familyid = p_info [ playerid ] [ family ] ;
            if ( p_info [ playerid ] [ hour_played ] < 3 ) return show_dialog ( playerid, d_ftalons_put, DIALOG_STYLE_INPUT, "{"#cBHD"}Положить "family_title":","{"#cRInfo"}* {"#cGRDialog"}Доступно с 3 часов в игре.\n\n{"#cWH"}Введите количество "family_title", которое желаете положить:","Положить","Назад");
			if ( d_amount < 1 ) return show_dialog ( playerid, d_ftalons_put, DIALOG_STYLE_INPUT, "{"#cBHD"}Положить "family_title":","{"#cRInfo"}* {"#cGRDialog"}Количество "family_title" должно быть от {"#cRD"}1\n\n{"#cWH"}Введите количество "family_title", которое желаете положить:","Положить","Назад");
			if ( p_info [ playerid ] [ family_ticket ] < d_amount ) return show_dialog ( playerid, d_ftalons_put, DIALOG_STYLE_INPUT, "{"#cBHD"}Положить "family_title":","{"#cRInfo"}* {"#cGRDialog"}У Вас нет такого количества "family_title".\n\n{"#cWH"}Введите количество "family_title", которое желаете положить:","Положить","Назад");

			family_info [ familyid - 1 ] [ fam_ticket ] += d_amount ;
			p_info [ playerid ] [ family_ticket ] -= d_amount ;
			update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;

			new query_string [ 128 ];
			format ( query_string, sizeof query_string, "UPDATE `family` SET `fam_ticket` = '%d' WHERE `fam_id` = '%d' LIMIT 1",
			family_info [ familyid - 1 ] [ fam_ticket ], familyid ) ;
			mysql_tquery ( sql_connection, query_string, "", "" ) ;

            format(query_string, sizeof ( query_string ), "{%s}[FAM] %s %s положил(а) на склад %i "family_title".", family_info [ familyid - 1 ] [ fam_chat_color ], family_rank [ familyid - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], d_amount ) ;
    		family_message ( familyid, col_gray, query_string ) ;

			format(query_string, sizeof query_string, "%s положил на склад %d "family_title".", p_info [ playerid ] [ name ], d_amount);
			write_family(playerid, familyid, TYPE_LOG_OBWYAK, query_string);

			if ( player_open_family [ playerid ] == false ) show_family_dorm ( playerid ) ;
			else
			{
				foreach(new i: family_players[familyid])
				{
					if ( p_info [ i ] [ family ] != familyid ) continue ;
					if ( player_last_page [ i ] != 6 ) continue ;
					
					show_packet_family ( i, 6, 0, 0 ) ;
				}
			}

			update_fdorm_text ( familyid ) ;
			return 1 ;
		}
		case d_family_settings:
		{
		    if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
				return 1 ;
			}

			if ( ! p_info [ playerid ] [ family ] ) return 1 ;
			if ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] > p_info [ playerid ] [ family_rang ] )
			{
				if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Настройки семьи может использовать только лидер семьи." ) ;
			}
			switch ( listitem )
			{
				case 0..6: show_settings_family ( playerid, p_info [ playerid ] [ family ], listitem ) ;
				case 7:
				{
					show_dialog ( playerid, d_family_settings_c, DIALOG_STYLE_INPUT, "{"#cBHD"}Количество статусов", "{"#cWH"}Введите количество семейных статусов, которое желаете установить:\n\n{"#cGRDialog"}* Количество статусов не может быть меньше 3 и больше 12", "Принять", "Назад" ) ;
					return 1 ;
				}
				case 8:
				{
					global_string [ 0 ] = EOS ;
					new line_string [ 72 ] ;
					for ( new i = 0; i < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] ; i ++ )
					{
						format ( line_string, 72, "{"#cBL"}%i. {"#cWH"}%s\n", i + 1, family_rank [ p_info [ playerid ] [ family ] - 1 ] [ i ] ) ;
						strcat ( global_string, line_string ) ;
					}
					show_dialog ( playerid, d_family_rank_list, DIALOG_STYLE_LIST, "{"#cBHD"}Название статуса", global_string, "Выбрать", "Назад" ) ;
					return 1 ;
				}
				case 9:
                {
					show_dialog ( playerid, d_family_national, DIALOG_STYLE_LIST, "{"#cBHD"}Национальность семьи","{"#cGRDialog"}- {"#cWH"}Американцы\n{"#cGRDialog"}- {"#cWH"}Японцы\n{"#cGRDialog"}- {"#cWH"}Итальянцы\n{"#cGRDialog"}- {"#cWH"}Мексиканцы\n{"#cGRDialog"}- {"#cWH"}Латиноамериканцы\n{"#cGRDialog"}- {"#cWH"}Испанцы\n{"#cGRDialog"}- {"#cWH"}Русские\n{"#cGRDialog"}- {"#cWH"}Португальцы\n{"#cGRDialog"}- {"#cWH"}Французы","Выбрать","Отмена");
					return 1 ;
				}
                case 10:
                {
					new color_dialog [ 248 ];
					format ( color_dialog, sizeof ( color_dialog ),"{"#cBL"}Готовые цвета:\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 1\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 2\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 3\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 4\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 5\n{"#cGRDialog"}Ввести свой RGB-цвет", family_chat_color [ 0 ],family_chat_color [ 1 ],family_chat_color [ 2 ],family_chat_color [ 3 ],family_chat_color [ 4 ]);
					show_dialog ( playerid, d_family_color, DIALOG_STYLE_LIST, "{"#cBHD"}Цвет чата", color_dialog, "Выбрать","Отмена" ) ;
					return 1 ;
				}
				case 11:
				{
				    new i = p_info [ playerid ] [ family ] - 1 ;
				    if ( ! family_info [ i ] [ fam_house ] )
					{
						if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет дома семьи." ) ;
					}

					if ( GetPVarInt ( playerid, "house_id" ) > 0 && GetPlayerVirtualWorld ( playerid ) == GetPVarInt ( playerid, "house_id" ) )
					{
					    new h = GetPVarInt ( playerid, "house_id" ) - 1 ;
					    if ( h != family_info [ i ] [ fam_house ] - 1 )
					    {
					        if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
							return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны находиться в доме семьи." ) ;
					    }
					}
					else
					{
					    if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны находиться в доме семьи." ) ;
					}

				    SendClientMessage ( playerid, col_gray, !"* Позиция общака семьи изменена." ) ;

				    GetPlayerPos ( playerid, dorm_family_pos [ i ] [ 0 ], dorm_family_pos [ i ] [ 1 ], dorm_family_pos [ i ] [ 2 ] ) ;

					new h = GetPVarInt ( playerid, "house_id" ) - 1 ;
					dorm_family_int [ i ] = GetPlayerInterior ( playerid ) ;
					dorm_family_virt [ i ] = h_info [ h ] [ h_id ] ;

                    if ( gdorm_family_text [ i ] != Text3D:INVALID_3DTEXT_ID )
					{
						DestroyDynamicArea ( dorm_family_area [ i ] ) ;
						DestroyDynamicCP ( dorm_family_cp [ i ] ) ;
						DestroyDynamic3DTextLabel ( gdorm_family_text [ i ] ) ;
					}

					dorm_family_cp [ i ] = CreateDynamicCP ( dorm_family_pos [ i ] [ 0 ], dorm_family_pos [ i ] [ 1 ], dorm_family_pos [ i ] [ 2 ], 1.0, dorm_family_virt [ i ], dorm_family_int [ i ], -1 ) ;
					dorm_family_area [ i ] = CreateDynamicSphere ( dorm_family_pos [ i ] [ 0 ], dorm_family_pos [ i ] [ 1 ], dorm_family_pos [ i ] [ 2 ] + 1, 2.0, dorm_family_virt [ i ], dorm_family_int [ i ], -1 ) ;
					area_info [ dorm_family_area [ i ] ] [ a_type ] = area_type_family_dorm ;

	                new t_string [ 300 ] ;

					format ( t_string,sizeof ( t_string ),"\
					{%s}*** Общак %s ***\n\n\
					{"#cWH3D"}Количество территорий:{"#cOR3D"} \t%d\n\
					{"#cWH3D"}"family_title":{"#cOR3D"} \t%d шт.",
					family_info [ i ] [ fam_chat_color ],
					family_info [ i ] [ fam_name ],
					family_info [ i ] [ fam_zones ],
					family_info [ i ] [ fam_ticket ] ) ;

					gdorm_family_text [ i ] = CreateDynamic3DTextLabel ( t_string, col_blue, dorm_family_pos [ i ] [ 0 ], dorm_family_pos [ i ] [ 1 ], dorm_family_pos [ i ] [ 2 ] + 1, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, dorm_family_virt [ i ], dorm_family_int [ i ] ) ;

				    new query_string [ 82 + ( 4 * 8 ) + ( 2 * 9 ) + 9 ];
			    	format ( query_string, sizeof query_string, "UPDATE `family` SET `fam_dorm` = '%f|%f|%f|%d|%d' WHERE `fam_id` = '%d' LIMIT 1",
			      	dorm_family_pos [ i ] [ 0 ], dorm_family_pos [ i ] [ 1 ], dorm_family_pos [ i ] [ 2 ], dorm_family_int [ i ], dorm_family_virt [ i ],
					p_info [ playerid ] [ family ] ) ;
			   		mysql_tquery ( sql_connection, query_string ) ;

			   		format(query_string, 128, "%s изменил(а) место общака", p_info [ playerid ] [ name ]);
					write_family(playerid, p_info [ playerid ] [ family ], TYPE_LOG_OBWYAK, query_string);

					if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
					return 1 ;
				}
				case 12:
				{
					global_string [ 0 ] = EOS ;

					new family_id = p_info [ playerid ] [ family ] ;
					format ( global_string, 356, "{"#cGRDialog"}- {"#cWH"}Предупреждения ({"#cGN"}%d{"#cWH"})\n{"#cGRDialog"}- {"#cWH"}Доступ к /fam(un)warn ({"#cGN"}%s{"#cWH"})\n{"#cGRDialog"}- {"#cWH"}Выдача предупреждения старшим (%s{"#cWH"})", family_info [ family_id - 1 ] [ fam_max_warn ], family_rank [ family_id - 1 ] [ family_info [ family_id - 1 ] [ fam_settings ] [ 8 ] - 1 ], (  family_info [ family_id - 1 ] [ fam_rank_warn ] == 0 ) ? ( "{"#cRD"}Нет" ) : ( "{"#cGN"}Доступно" ) ) ;
					show_dialog ( playerid, d_famwarn_settings, DIALOG_STYLE_LIST, "{"#cBHD"}Предупреждения", global_string, "Выбрать", "Назад" ) ;
				}
			}
			return 1 ;
		}
		case d_famwarn_settings:
		{
		    if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
				return 1 ;
			}
		    switch ( listitem )
		    {
		        case 0:
		        {
		            new family_id = p_info [ playerid ] [ family ] ;

		            global_string [ 0 ] = EOS ;
					format(global_string, 450, "{"#cWH"}Вы собираетесь изменить следующую конфигурацию:\n\n\t{"#cWH"}Название: {"#cLY"}Количество предупреждений в семье\n\t{"#cWH"}Текущее значение: {"#cLY"}%d\n\n{"#cGRDialog"}* Введите новое значение для данной конфигурации:", family_info [ family_id - 1 ] [ fam_max_warn ] ) ;
					show_dialog(playerid, d_fam_maxwarn, DIALOG_STYLE_INPUT, "{"#cBHD"}Изменение конфигурации", global_string, "Выбрать", "Назад" ) ;
					return 1 ;
		        }
		        case 1:
		        {
		            show_settings_family ( playerid, p_info [ playerid ] [ family ], 7 ) ;
					return 1 ;
				}
				case 2:
				{
				    new family_id = p_info [ playerid ] [ family ] ;

				    if ( family_info [ family_id - 1 ] [ fam_rank_warn ] == 1 ) family_info [ family_id - 1 ] [ fam_rank_warn ] = 0 ;
					else family_info [ family_id - 1 ] [ fam_rank_warn ] = 1 ;

					static const _str [ ] = "UPDATE `family` SET `fam_rank_warn` = '%d' WHERE `fam_id` = '%d' LIMIT 1" ;
					new scm_string [ sizeof _str + 4 + 9 ] ;
		            format ( scm_string, sizeof scm_string, _str, family_info [ family_id - 1 ] [ fam_rank_warn ], family_info [ family_id - 1 ] [ fam_id ] ) ;
		            mysql_tquery ( sql_connection, scm_string ) ;

					if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
				    return 1 ;
				}
			}
		}
		case d_family_color:
		{
			if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
				return 1 ;
			}
			switch ( listitem )
			{
				case 6:show_dialog ( playerid, d_family_color_rgb, DIALOG_STYLE_INPUT, "{"#cBHD"}Цвет чата", "{FFFFFF}Введите цвет, который желаете применить для чата семьи:\n\n{"#cGRDialog"}* Цвет должен быть в RGB формате, например: FFFF00", "Принять", "Назад" ) ;
				case 0:
				{
					new color_dialog [ 248 ];
					format ( color_dialog, sizeof ( color_dialog ),"{"#cBL"}Готовые цвета:\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 1\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 2\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 3\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 4\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 5\n{"#cGRDialog"}Ввести свой RGB-цвет",family_chat_color [ 0 ],family_chat_color [ 1 ],family_chat_color [ 2 ],family_chat_color [ 3 ],family_chat_color [ 4 ]);
					show_dialog ( playerid, d_family_color, DIALOG_STYLE_LIST, "{"#cBHD"}Цвет чата", color_dialog, "Выбрать","Отмена" ) ;
					return 1 ;
				}
				default:
				{
				    new familyid = p_info [ playerid ] [ family ] ;
					format ( family_info [ familyid - 1 ] [ fam_chat_color ], 8, "%s", family_chat_color [ listitem - 1 ] ) ;
					
					new str_to_hex [ 28 ] ;
					format ( str_to_hex, sizeof str_to_hex, "0x%s55", family_chat_color [ listitem - 1 ] ) ;
					family_info [ familyid - 1 ] [ fam_zone_color ] = StrToHex ( str_to_hex ) ;

					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Цвет чата семьи изменён." ) ;
					new query_string [ 128 ];
					mysql_format ( sql_connection, query_string, sizeof query_string, "UPDATE `family` SET `fam_chat_color` = '%e' WHERE `fam_id` = '%d' LIMIT 1", family_info [ familyid - 1 ] [ fam_chat_color ], familyid ) ;
					mysql_tquery ( sql_connection, query_string ) ;

                    new _fam_jackdaw [ 28 ] ;
					switch ( family_info [ familyid - 1 ] [ fam_enhancement ] [ 9 ] )
					{
					    case 0: format ( _fam_jackdaw, sizeof _fam_jackdaw, "" ) ;
					    default: format ( _fam_jackdaw, sizeof _fam_jackdaw, "[{%s}%s{"#cWH"}] ", family_info [ familyid - 1 ] [ fam_chat_color ], fam_jackdaw [ family_info [ familyid - 1 ] [ fam_enhancement ] [ 9 ] ] ) ;
					}

					format ( query_string, 128, "%s{%s}%s {"#cWH3D"}%s", _fam_jackdaw, family_info [ familyid - 1 ] [ fam_chat_color ], family_info [ familyid - 1 ] [ fam_name ], fam_brand [ family_info [ familyid - 1 ] [ fam_enhancement ] [ 10 ] ] ) ;
					foreach(new i: family_players[familyid])
					{
						if ( p_info [ i ] [ family ] != familyid ) continue ;

						if ( IsValidDynamic3DTextLabel ( p_info [ i ] [ family_text ] ) ) UpdateDynamic3DTextLabelText ( p_info [ i ] [ family_text ], -1, query_string ) ;
					}

					if ( family_info [ familyid - 1 ] [ fam_house ] )
				   	{
				   	    if ( Iter_Count(family_vehicles[familyid]) != 0 )
				   	    {
							foreach(new i: family_vehicles[familyid]) veh_plate ( i ) ;
						}
					}
					
					for ( new i = 0 ; i < zones_count ; i ++ )
					{
						if ( family_wars [ i ] [ gz_owner ] != familyid ) continue ;
						
						GangZoneHideForAll ( family_wars [ i ] [ gz_created ] ) ;
						GangZoneShowForAll ( family_wars [ i ] [ gz_created ], GetFamilyZoneColor ( family_wars [ i ] [ gz_owner ] ) ) ;
						
						update_famzones_label ( i, familyid ) ;
					}

					if ( gdorm_family_text [ familyid - 1 ] != Text3D:INVALID_3DTEXT_ID ) update_fdorm_text ( familyid ) ;

					if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
				}
			}
			return 1 ;
		}
		case d_family_color_rgb:
		{
			if ( ! response )
			{
				new color_dialog [ 248 ];
				format ( color_dialog, sizeof ( color_dialog ),"{"#cBL"}Готовые цвета:\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 1\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 2\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 3\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 4\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 5\n{"#cGRDialog"}Ввести свой RGB-цвет",family_chat_color [ 0 ],family_chat_color [ 1 ],family_chat_color [ 2 ],family_chat_color [ 3 ],family_chat_color [ 4 ]);
				show_dialog ( playerid, d_family_color, DIALOG_STYLE_LIST, "{"#cBHD"}Цвет чата", color_dialog, "Выбрать","Отмена" ) ;
				return 1 ;
			}
			if ( strlen ( inputtext ) != 6 || is_text_invalid ( inputtext ) ) return show_dialog ( playerid, d_family_color_rgb, DIALOG_STYLE_INPUT, "{"#cBHD"}Цвет чата", "{FFFFFF}Введите цвет, который желаете применить для чата семьи:\n\n{"#cRD"}* Цвет должен быть в RGB формате, например: FFFF00", "Принять", "Назад" ) ;

            new familyid = p_info [ playerid ] [ family ] ;
			format ( family_info [ familyid - 1 ] [ fam_chat_color ], 8, "%s", inputtext ) ;
			
			new str_to_hex [ 28 ] ;
			format ( str_to_hex, sizeof str_to_hex, "0x%s55", inputtext ) ;
			family_info [ familyid - 1 ] [ fam_zone_color ] = StrToHex ( str_to_hex ) ;

			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Цвет чата семьи изменён." ) ;
			new query_string [ 128 ];
			mysql_format ( sql_connection, query_string, sizeof query_string, "UPDATE `family` SET `fam_chat_color` = '%e' WHERE `fam_id` = '%d' LIMIT 1", family_info [ familyid - 1 ] [ fam_chat_color ], familyid ) ;
			mysql_tquery ( sql_connection, query_string ) ;

			new _fam_jackdaw [ 28 ] ;
			switch ( family_info [ familyid - 1 ] [ fam_enhancement ] [ 9 ] )
			{
			    case 0: format ( _fam_jackdaw, sizeof _fam_jackdaw, "" ) ;
			    default: format ( _fam_jackdaw, sizeof _fam_jackdaw, "[{%s}%s{"#cWH"}] ", family_info [ familyid - 1 ] [ fam_chat_color ], fam_jackdaw [ family_info [ familyid - 1 ] [ fam_enhancement ] [ 9 ] ] ) ;
			}

			format ( query_string, 128, "%s{%s}%s {"#cWH3D"}%s", _fam_jackdaw, family_info [ familyid - 1 ] [ fam_chat_color ], family_info [ familyid - 1 ] [ fam_name ], fam_brand [ family_info [ familyid - 1 ] [ fam_enhancement ] [ 10 ] ] ) ;
			foreach(new i: family_players[familyid])
			{
				if ( p_info [ i ] [ family ] != familyid ) continue ;

				if ( IsValidDynamic3DTextLabel ( p_info [ i ] [ family_text ] ) ) UpdateDynamic3DTextLabelText ( p_info [ i ] [ family_text ], -1, query_string ) ;
			}

			if ( family_info [ familyid - 1 ] [ fam_house ] )
		   	{
      			if ( Iter_Count(family_vehicles[familyid]) != 0 )
		   		{
					foreach(new i: family_vehicles[familyid]) veh_plate ( i ) ;
				}
			}
			
			for ( new i = 0 ; i < zones_count ; i ++ )
			{
				if ( family_wars [ i ] [ gz_owner ] != familyid ) continue ;
						
				GangZoneHideForAll ( family_wars [ i ] [ gz_created ] ) ;
				GangZoneShowForAll ( family_wars [ i ] [ gz_created ], GetFamilyZoneColor ( family_wars [ i ] [ gz_owner ] ) ) ;
				
				update_famzones_label ( i, familyid ) ;
			}

			if ( gdorm_family_text [ familyid - 1 ] != Text3D:INVALID_3DTEXT_ID ) update_fdorm_text ( familyid ) ;

			if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
			return 1 ;
		}
		case d_family_rank_list:
		{
		    if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
				return 1 ;
			}
			SetPVarInt ( playerid, "rank_name_listitem", listitem ) ;
			show_dialog ( playerid, d_family_rank_name, DIALOG_STYLE_INPUT, "{"#cBHD"}Название статуса", "{FFFFFF}Введите название статуса:\n\n{"#cGRDialog"}* Название статуса должно составлять от 3 до 30 символов\n* Название статуса не должно содержать некорректных символов", "Принять", "Назад" ) ;
			return 1 ;
		}
		case d_family_rank_name:
		{
			if ( ! response )
			{
				global_string [ 0 ] = EOS ;
				new line_string [ 72 ] ;
				for ( new i = 0; i < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] ; i ++ )
				{
					format ( line_string, 72, "{"#cGRDialog"}%i. {"#cWH"}%s\n", i + 1, family_rank [ p_info [ playerid ] [ family ] - 1 ] [ i ] ) ;
					strcat ( global_string, line_string ) ;
				}
				show_dialog ( playerid, d_family_rank_list, DIALOG_STYLE_LIST, "{"#cBHD"}Название статуса", global_string, "Выбрать", "Назад" ) ;
				return 1 ;
			}
			if ( strlen ( inputtext ) < 3 || strlen ( inputtext ) > 30 ) return show_dialog ( playerid, d_family_rank_name, DIALOG_STYLE_INPUT, "{"#cBHD"}Название статуса", "{FFFFFF}Введите название статуса:\n\n{"#cRD"}* Название статуса должно составлять от 3 до 30 символов", "Принять", "Назад" ) ;
			if ( is_text_invalid ( inputtext ) ) return show_dialog ( playerid, d_family_rank_name, DIALOG_STYLE_INPUT, "{"#cBHD"}Название статуса", "{FFFFFF}Введите название статуса:\n\n{"#cRD"}* Название статуса не должно содержать некорректных символов", "Принять", "Назад" ) ;

            new familyid = p_info [ playerid ] [ family ] ;
			new dialog_rank_id = GetPVarInt ( playerid, "rank_name_listitem" ) ;
			format ( family_rank [ familyid - 1 ] [ dialog_rank_id ], 30, "%s", inputtext ) ;

			global_string [ 0 ] = EOS ;
			new line_string [ 72 ] ;
			for ( new i = 0; i < family_info [ familyid - 1 ] [ fam_settings ] [ 3 ] ; i ++ )
			{
				format ( line_string, 72, "{"#cGRDialog"}%i. {"#cWH"}%s\n", i + 1, family_rank [ familyid - 1 ] [ i ] ) ;
				strcat ( global_string, line_string ) ;
			}
			show_dialog ( playerid, d_family_rank_list, DIALOG_STYLE_LIST, "{"#cBHD"}Название статуса", global_string, "Выбрать", "Назад" ) ;


			mysql_format ( sql_connection, global_string, sizeof ( global_string ), "UPDATE `family` SET `fam_ranks` = '%e|%e|%e|%e|%e|%e|%e|%e|%e|%e|%e|%e' WHERE `fam_id` = '%d' LIMIT 1",
			family_rank [ familyid - 1 ] [ 0 ], family_rank [ familyid - 1 ] [ 1 ],
			family_rank [ familyid - 1 ] [ 2 ], family_rank [ familyid - 1 ] [ 3 ],
			family_rank [ familyid - 1 ] [ 4 ], family_rank [ familyid - 1 ] [ 5 ],
			family_rank [ familyid - 1 ] [ 6 ], family_rank [ familyid - 1 ] [ 7 ],
			family_rank [ familyid - 1 ] [ 8 ], family_rank [ familyid - 1 ] [ 9 ],
			family_rank [ familyid - 1 ] [ 10 ], family_rank [ familyid - 1 ] [ 11 ],
			familyid ) ;
			mysql_tquery ( sql_connection, global_string, "", "" ) ;

			return 1 ;
		}
		case d_family_national:
		{
			if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
				return 1 ;
			}
			
			new _family_id = p_info [ playerid ] [ family ] ;
			family_info [ _family_id - 1 ] [ fam_nationality ] = listitem + 1;

            SendClientMessage ( playerid, col_white,"{"#cGInfo"}* {"#cWH"}Национальность семьи изменена." ) ;
			
            new query_string [ 77 + 4 + 9 ];
            format ( query_string, sizeof query_string, "UPDATE `family` SET `fam_nationality` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _family_id - 1 ] [ fam_nationality ], _family_id ) ;
            mysql_tquery ( sql_connection, query_string ) ;

   			if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
			return 1 ;
		}
		case d_family_settings_c:
		{
			if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
				return 1 ;
			}
			new rank_count = strval ( inputtext ) ;
			if ( rank_count < 3 || rank_count > 12 )return show_dialog ( playerid, d_family_settings_c, DIALOG_STYLE_INPUT, "{"#cBHD"}Количество статусов", "{"#cWH"}Введите количество семейных статусов, которое желаете установить:\n\n{"#cRD"}* Количество статусов не может быть меньше 3 и больше 12", "Принять", "Назад" ) ;

			new family_id = p_info [ playerid ] [ family ] ;
			foreach(new i: family_players[family_id])
			{
				if ( family_id != p_info [ i ] [ family ] ) continue ;
				if ( i == playerid ) continue ;
				if ( p_info [ i ] [ family_rang ] < rank_count ) continue ;
				
				p_info [ i ] [ family ] = 1 ;
				update_int_sql ( i, "u_family_rank", 1 ) ;
			}

			p_info [ playerid ] [ family_rang ] = rank_count ;
			update_int_sql ( playerid, "u_family_rank", rank_count ) ;
			
			family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] = rank_count ;

			new _t_string [ 43 + MAX_PLAYER_NAME + 9 ] ;
			format ( _t_string, sizeof _t_string, "%s изменил(а) количество статусов на %d.", p_info [ playerid ] [ name ], rank_count ) ;
			write_family ( playerid, family_id, TYPE_LOG_OBWYAK, _t_string ) ;

			if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
			else show_packet_family ( playerid, 4, 0, 0 ) ;
			family_sql ( family_id ) ;
			return 1 ;
		}
		case d_family_settings_select:
		{
			if ( ! response )
			{
				if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
				return 1 ;
			}

			family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ GetPVarInt ( playerid, "select_id" ) ] = listitem + 1 ;
			DeletePVar ( playerid, "select_id" ) ;

			if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
			else show_packet_family ( playerid, 4, 0, 0 ) ;
			family_sql ( p_info [ playerid ] [ family ] ) ;
			return 1 ;
		}
		case d_family_invite:
        {
            if ( ! response )
			{
				clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			
            new pl_id = seller_id [ playerid ] ;
			if ( ! IsPlayerConnected ( pl_id ) || pl_id == INVALID_PLAYER_ID )
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок покинул(а) игру." ) ;
			
			new family_id = p_info [ pl_id ] [ family ] ;
			if ( family_id < 1 )
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Произошла ошибка. Попросите отправить приглашение повторно." ) ;
				
            p_info [ playerid ] [ family ] = family_id ;
            p_info [ playerid ] [ family_rang ] = 1 ;

			Iter_Add(family_players[family_id], playerid ) ;

            new _t_string [ 170 ];
            format(_t_string,sizeof(_t_string),"{%s}[FAM] %s присоединился к семье (Пригласил: %s). Приветствуем!", family_info [ family_id - 1 ] [ fam_chat_color ], p_info [ playerid ] [ name ], p_info [ pl_id ] [ name ] ) ;
            family_message ( family_id, col_gray, _t_string ) ;
			
			SendClientMessage ( playerid, col_gray, !"* Используйте {"#cWH"}/mm - Команды сервера {"#cGRInfo"}для ознакомления с функционалом семьи." ) ;

			new text_str [ 128 ] ;
			new _fam_jackdaw [ 28 ] ;
			switch ( family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ] )
			{
			    case 0: format ( _fam_jackdaw, sizeof _fam_jackdaw, "" ) ;
			    default: format ( _fam_jackdaw, sizeof _fam_jackdaw, "[{%s}%s{"#cWH3D"}] ", family_info [ family_id - 1 ] [ fam_chat_color ], fam_jackdaw [ family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ] ] ) ;
			}

			format ( text_str, 128, "%s{%s}%s {"#cWH3D"}%s", _fam_jackdaw, family_info [ family_id - 1 ] [ fam_chat_color ], family_info [ family_id - 1 ] [ fam_name ], fam_brand [ family_info [ family_id - 1 ] [ fam_enhancement ] [ 10 ] ] ) ;
			p_info [ playerid ] [ family_text ] = CreateDynamic3DTextLabel( text_str, col_white, 0.0, 0.0, 0.0, family_text_size, playerid, INVALID_VEHICLE_ID, 1 ) ;

			format ( _t_string, sizeof ( _t_string ), "UPDATE `users` SET u_family='%d',u_family_rank='1',`u_family_date` = NOW() WHERE `u_id` = '%d' LIMIT 1", family_id, p_info [ playerid ] [ id ] ) ;
			mysql_tquery(sql_connection, _t_string ) ;
			
			family_info [ family_id - 1 ] [ fam_members ] ++ ;
			format ( _t_string, sizeof ( _t_string ), "UPDATE `family` SET `fam_members` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_members ], p_info [ playerid ] [ family ] ) ;
			mysql_tquery(sql_connection, _t_string ) ;

			format(_t_string, 128, "%s принял(а) в семью %s.", p_info [ pl_id ] [ name ], p_info [ playerid ] [ name ]);
			write_family(pl_id, family_id, TYPE_LOG_INVITE, _t_string);

			#if defined m_binders
			    update_packet_binds ( playerid ) ;
			#endif
			
			give_event_progress ( playerid, THE_FAMILY, 1 ) ;
			checking_quest_progress ( playerid, 0, 1, quest_line_high ) ;
			
			clear_sell_params ( playerid, pl_id ) ;
			return 1 ;
        }
		case d_family_rank:
		{
			if ( ! response ) return clear_sell_params ( playerid, playerid ) ;
			new _pl_id = buyer_id [ playerid ] ;

			if ( ! IsPlayerConnected ( _pl_id )  || _pl_id == playerid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не найден." ) ;
			if ( p_info [ _pl_id ] [ family ] != p_info [ playerid ] [ family ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не состоит в Вашей семье." ) ;
			if ( listitem + 1 >= p_info [ playerid ] [ family_rang ] || p_info [ playerid ] [ family_rang ] <= p_info [ _pl_id ] [ family_rang ] )
			{
				global_string [ 0 ] = EOS ;
				new line_string [ 72 ] ;
				new _family_id = p_info [ playerid ] [ family ] ;
				for ( new i = 0; i < family_info [ _family_id - 1 ] [ fam_settings ] [ 3 ] ; i ++ )
				{
					format ( line_string, 72, "{"#cGRDialog"}%i. {"#cWH"}%s\n", i + 1, family_rank [ _family_id - 1 ] [ i ] ) ;
					strcat ( global_string, line_string ) ;
				}
				show_dialog ( playerid, d_family_rank, DIALOG_STYLE_LIST, "{"#cBHD"}Семейный статус", global_string, "Выбрать", "Назад" ) ;
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете назначить игрока на статус выше Вашего." ) ;
			}
			p_info [ _pl_id ] [ family_rang ] = listitem + 1 ;
			update_int_sql ( _pl_id, "u_family_rank", listitem + 1 ) ;

			new _text_string [ 128 ] ;
			format ( _text_string, 128, "{"#cGInfo"}* {"#cWH"}Вы назначили %s на статус {"#cGN"}%s(%d)", p_info [ _pl_id ] [ name ], family_rank [ p_info [ _pl_id ] [ family ] - 1 ] [ listitem ], listitem + 1 ) ;
			SendClientMessage ( playerid, col_white, _text_string ) ;
			format ( _text_string, 128, "{"#cGN"}* %s {"#cWH"}назначил Вас на статус {"#cGN"}%s(%d)", p_info [ playerid ] [ name ], family_rank [ p_info [ _pl_id ] [ family ] - 1 ] [ listitem ], listitem + 1 ) ;
			SendClientMessage ( _pl_id, col_succes, _text_string ) ;

			format(_text_string, 128, "%s назначил %s на статус %s.", p_info [ playerid ] [ name ], p_info [ _pl_id ] [ name ], family_rank [ p_info [ _pl_id ] [ family ] - 1 ] [ listitem ]);
			write_family(playerid, p_info [ playerid ] [ family ], TYPE_LOG_AGIVERANK, _text_string);
			
			clear_sell_params ( playerid, playerid ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock familys_OnPlayerDisconnect ( playerid, reason )
{
	if ( p_info [ playerid ] [ family ] )
	{
	    new familyid = p_info [ playerid ] [ family ] ;
		Iter_Remove(family_players[familyid], playerid) ;
	}
	
	if ( fam_td_status_bool [ playerid ] == true )
	{
		fam_td_status ( playerid, false ) ;
		fam_td_status_bool [ playerid ] = false ;
	}
	
	if ( zones_captured != -1 && reason != 0 ) familywar_quit ( playerid, reason ) ;
	
	if ( p_info [ playerid ] [ family_text ] != Text3D:INVALID_3DTEXT_ID )
	{
		DestroyDynamic3DTextLabel ( p_info [ playerid ] [ family_text ] ) ;
		p_info [ playerid ] [ family_text ] = Text3D:INVALID_3DTEXT_ID ;
	}
	return 1 ;
}

stock familys_load_user ( playerid )
{
	if ( p_info [ playerid ] [ family ] )
	{
		new text_str [ 128 ], family_id = p_info [ playerid ] [ family ] ;
		new _fam_jackdaw [ 28 ] ;
		switch ( family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ] )
		{
		    case 0: format ( _fam_jackdaw, sizeof _fam_jackdaw, "" ) ;
		    default: format ( _fam_jackdaw, sizeof _fam_jackdaw, "[{%s}%s{"#cWH3D"}] ", family_info [ family_id - 1 ] [ fam_chat_color ], fam_jackdaw [ family_info [ family_id - 1 ] [ fam_enhancement ] [ 9 ] ] ) ;
		}

		format ( text_str, 128, "%s{%s}%s {"#cWH3D"}%s", _fam_jackdaw, family_info [ family_id - 1 ] [ fam_chat_color ], family_info [ family_id - 1 ] [ fam_name ], fam_brand [ family_info [ family_id - 1 ] [ fam_enhancement ] [ 10 ] ] ) ;
		p_info [ playerid ] [ family_text ] = CreateDynamic3DTextLabel( text_str, col_white, 0.0, 0.0, 0.0, family_text_size, playerid, INVALID_VEHICLE_ID, 1 ) ;
	
		Iter_Add(family_players[family_id], playerid ) ;
	}
	
	for ( new i = 0; i < zones_count; i ++ )
	{
		GangZoneShowForPlayer ( playerid, family_wars [ i ] [ gz_created ], GetFamilyZoneColor ( family_wars [ i ] [ gz_owner ] ) ) ;
	}
	
	new sql_string [ 100 ] ;
	format ( sql_string, sizeof sql_string, "SELECT `bl_family`, `bl_death` FROM `familys_blacklist` WHERE `bl_player` = '%d'", p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, sql_string, "callback_bl_fam_check", "i", playerid ) ;
	return 1 ;
}

callback: callback_bl_fam_check ( playerid )
{
	new rows = cache_get_row_count ( ) ;
	if ( rows )
	{
		new temp[ 128 ], query [ 128 ], src [ 256 ] ;
		format(temp, sizeof temp, "* Вы находитесь в черном списке ");

		for ( new i, family_id, kills ; i < rows ; i ++ )
		{
			family_id = cache_get_field_content_int ( i, "bl_family", sql_connection ) ;
			kills = cache_get_field_content_int ( i, "bl_death", sql_connection ) ;

			fam_bl_info [ playerid ] [ bl_onFrac ] [ family_id ] = 1 ;
			fam_bl_info [ playerid ] [ bl_kills ] [ family_id ] = kills ;

			format ( temp, sizeof temp, "%s, ", family_info [ family_id - 1 ] [ fam_name ] ) ;
			strcat ( src, temp ) ;
		}

		temp[strlen(temp)-2] = '\0';
		SendClientMessage ( playerid, col_lblue, temp ) ;

		format ( query, sizeof query, "UPDATE `familys_blacklist` SET `bl_last_date` = NOW() WHERE `bl_player` = '%d' LIMIT %d", p_info [ playerid ] [ id ], rows ) ;
		mysql_tquery ( sql_connection, query, "", "" ) ;
	}
	return 1 ;
}

callback: check_bl_list_family ( playerid, pl_name [ ], _type )
{
	if ( _type == 1 )
	{
		new rows, fields ;
		cache_get_data ( rows, fields ) ;
		if ( rows )
		{
			new target_inc = cache_get_field_content_int ( 0, "bl_player", sql_connection ) ;

			new sql_string [ 128 ], _family_id = p_info [ playerid ] [ family ] ;
			format ( sql_string, sizeof ( sql_string ), "DELETE FROM `familys_blacklist` WHERE `bl_player`='%d' AND `bl_family`='%d' LIMIT 1",
			target_inc, _family_id ) ;
			mysql_tquery ( sql_connection, sql_string ) ;

			new _pl_id ;
			sscanf ( pl_name, "u", _pl_id ) ;
			if ( IsPlayerConnected ( _pl_id ) )
			{
				format ( sql_string, sizeof ( sql_string ), "{"#cGInfo"}* {"#cWH"}%s убрал(а) Вас из чёрного списка семьи \"%s\".", p_info [ playerid ] [ name ], family_info [ _family_id - 1 ] [ fam_name ] ) ;
				SendClientMessage ( _pl_id, col_white, sql_string ) ;
				
				fam_bl_info [ _pl_id ] [ bl_onFrac ] [ _family_id ] =
				fam_bl_info [ _pl_id ] [ bl_kills ] [ _family_id ] = 0 ;
			}

			format(sql_string, 128, "%s убрал(а) %s из чёрного списка семьи \"%s\".", p_info [ playerid ] [ name ], pl_name, family_info [ _family_id - 1 ] [ fam_name ]);
			write_family(playerid, _family_id, TYPE_LOG_BL, sql_string);

			format ( sql_string, sizeof sql_string, "{"#cGInfo"}* {"#cWH"}Вы убрали из чёрного списка %s.", pl_name ) ;
			SendClientMessage ( playerid, col_white, sql_string );
			show_dialog ( playerid, d_blacklist_family, DIALOG_STYLE_LIST, "{"#cBHD"}Чёрный список", "Добавить человека в чёрный список\nОчистить черный список\nУбрать человека из черного списка\nЧёрный список игроков\nЧёрный список игроков [ {"#cGN"}ОНЛАЙН{"#cWH"} ]", "Выбрать", "Назад" ) ;

		}
		else
		{
			new text_string [ 60 + MAX_PLAYER_NAME ] ;
			format ( text_string, sizeof text_string, "{"#cRInfo"}* {"#cGRInfo"}%s не найден(а) в чёрном списке.", pl_name );
			SendClientMessage ( playerid, col_gray, text_string );
			show_dialog ( playerid, d_blacklist_family, DIALOG_STYLE_LIST, "{"#cBHD"}Чёрный список", "Добавить человека в чёрный список\nОчистить черный список\nУбрать человека из черного списка\nЧёрный список игроков\nЧёрный список игроков [ {"#cGN"}ОНЛАЙН{"#cWH"} ]", "Выбрать", "Назад" ) ;
		}
	}
	else if ( _type == 2 )
	{
		new rows, fields ;
		cache_get_data ( rows, fields ) ;
		if ( rows )
		{
			new _pl_name [ 24 ] ;
			new target_inc = cache_get_field_content_int ( 0, "bl_player", sql_connection ) ;
			cache_get_field_content ( 0, "bl_name", _pl_name, sql_connection, 24 ) ;

			new sql_string [ 128 ], _family_id = p_info [ playerid ] [ family ] ;
			format ( sql_string, sizeof ( sql_string ), "DELETE FROM `familys_blacklist` WHERE `bl_player`='%d' AND `bl_family`='%d' LIMIT 1",
			target_inc, _family_id ) ;
			mysql_tquery ( sql_connection, sql_string ) ;

			new _pl_id ;
			sscanf ( pl_name, "u", _pl_id ) ;
			if ( IsPlayerConnected ( _pl_id ) )
			{
				format ( sql_string, sizeof ( sql_string ), "{"#cGInfo"}* {"#cWH"}%s убрал(а) Вас из чёрного списка семьи \"%s\".", p_info [ playerid ] [ name ], family_info [ _family_id - 1 ] [ fam_name ] ) ;
				SendClientMessage ( _pl_id, col_white, sql_string ) ;
				
				fam_bl_info [ _pl_id ] [ bl_onFrac ] [ _family_id ] =
				fam_bl_info [ _pl_id ] [ bl_kills ] [ _family_id ] = 0 ;
			}

			format(sql_string, 128, "%s убрал(а) %s из чёрного списка семьи \"%s\".", p_info [ playerid ] [ name ], pl_name, family_info [ _family_id - 1 ] [ fam_name ]);
			write_family(playerid, _family_id, TYPE_LOG_BL, sql_string);

			format ( sql_string, sizeof sql_string, "Вы убрали из чёрного списка %s.", pl_name ) ;
			send_check_cinfo ( playerid, sql_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
			show_packet_family ( playerid, 18, 0, 0 ) ;
		}
	}
	return 1 ;
}

callback: callback_offamily ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игроки с данными параметрами не найдены." ) ;
		show_family ( playerid ) ;
		page_count [ playerid ] = 0 ;
		return 1 ;
	}

	new rows_list = page_count [ playerid ] - 1 ;
	page_rows [ playerid ] = rows ;
	
	global_string [ 0 ] = EOS ;
	new line_string [ MAX_PLAYER_NAME + 128 ], pl_ofm_name [ 24 ], pl_ofm_online [ 48 ], fam_c_rank, fam_c_time, row_count ;
	new family_id = p_info [ playerid ] [ family ] ;
	for ( new i = rows_list * 10 ; i <  rows_list * 10 + 10 ; i ++ )
	{
		if ( i >= rows ) break ;

		cache_get_field_content ( i, "u_name", pl_ofm_name, sql_connection, 24 ) ;
		fam_c_rank = cache_get_field_content_int ( i, "u_family_rank", sql_connection ) ;
		fam_c_time = cache_get_field_content_int ( i, "u_played_time", sql_connection ) ;

		new pvar_string [ 8 ] ;
		format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", i - rows_list * 10 ) ;
		SetPVarString ( playerid, pvar_string, pl_ofm_name ) ;

		new _pl_id ;
		sscanf ( pl_ofm_name, "u", _pl_id ) ;
		
		if ( IsPlayerConnected ( _pl_id ) ) format ( pl_ofm_online, sizeof pl_ofm_online, "Сейчас играет ({"#cGN"}ONLINE{ffffff})" ) ;
		else
		{
		    new float_time = gettime( ) - fam_c_time ;
			format ( pl_ofm_online, sizeof pl_ofm_online, "%s ({"#cRD"}OFFLINE{ffffff})", check_float_time ( float_time ) ) ;
		}

		format ( line_string, sizeof ( line_string ), "%s - {"#cBL"}%s (%d){"#cWH"} - %s\n", pl_ofm_name, family_rank [ family_id - 1 ] [ fam_c_rank - 1 ], fam_c_rank, pl_ofm_online ) ;
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
	
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < rows )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}

	show_dialog ( playerid, d_offmembers_list1, DIALOG_STYLE_LIST, "{"#cBHD"}Члены семьи оффлайн", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

callback: callback_offamily_info ( playerid )
{
	new rows, fields;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		new last_date [ 16 ], fraction_date [ 24 ], fam_c_rank ;

		fam_c_rank = cache_get_field_content_int ( 0, "u_family_rank", sql_connection ) ;
		cache_get_field_content(0, "u_last_date", last_date, sql_connection, 24 ) ;
		cache_get_field_content(0, "u_family_date", fraction_date, sql_connection, 24 ) ;

		new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
		format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
		GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;

		new dialog_string [ 256 ] ;
		format ( dialog_string, sizeof ( dialog_string ), "{"#cWH"}Имя: {"#cBL"}%s{"#cWH"}\nДолжность: {"#cBL"}%s (%d){"#cWH"}\nВ семье с {"#cBL"}%s{"#cWH"}\nПоследний вход: {"#cBL"}%s{"#cWH"}", pl_name, family_rank [ p_info [ playerid ] [ family ] - 1 ] [ fam_c_rank - 1 ], fam_c_rank, fraction_date, last_date ) ;
		show_dialog ( playerid, d_offmembers_pl_menu_info1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация об игроке", dialog_string, "Назад", "" ) ;
	}
	if ( ! rows )
	{
		new query_string [ 144 ];
		DeletePVar( playerid, "ofm_listitem" ) ;
		if( ! GetPVarInt ( playerid, "ofm_type" ) )
		{
			mysql_format ( sql_connection, query_string, 144, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d'", p_info [ playerid ] [ family ] ) ;
			mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
			return 1 ;
		}
		
		mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name`,`u_played_time`,`u_family_rank` FROM `users` WHERE `u_family` = '%d' AND `u_family_rank` = '%d'", p_info [ playerid ] [ family ], GetPVarInt ( playerid, "ofm_type" ) ) ;
		mysql_tquery ( sql_connection, query_string, "callback_offamily", "i", playerid ) ;
	}
	return 1 ;
}

callback: callback_bl_family ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;

	if ( player_device { playerid } == 2 )
	{
		if ( ! rows )
		{
			send_check_cinfo ( playerid, "Нет игроков в чёрном списке семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		new BitStream:bitstream = BS_New();
		BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
		BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
		BS_WriteValue(bitstream, PR_INT8, 4);
		BS_WriteValue(bitstream, PR_INT8, 36);
		
		BS_WriteValue(bitstream, PR_UINT8, rows);
		new line_string [ 64 ], pl_ofm_name [ 24 ], pl_reason [ 24 ], pl_ofm_online [ 24 ] ;
		for ( new i = 0 ; i < rows ; i ++ )
		{
			new _bl_player = cache_get_field_content_int ( i, "bl_player", sql_connection ) ;
			format ( line_string, sizeof line_string, "%d", _bl_player ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			cache_get_field_content ( i, "bl_name", pl_ofm_name, sql_connection, 24 ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( pl_ofm_name ) ) ;
			BS_WriteValue(bitstream, PR_STRING, pl_ofm_name ) ;
			
			cache_get_field_content ( i, "bl_reason", pl_reason, sql_connection, 24 ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( pl_reason ) ) ;
			BS_WriteValue(bitstream, PR_STRING, pl_reason ) ;
			
			cache_get_field_content ( i, "bl_date", pl_ofm_online, sql_connection, 24 ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( pl_ofm_online ) ) ;
			BS_WriteValue(bitstream, PR_STRING, pl_ofm_online ) ;
		}
		
		PR_SendPacket(bitstream, playerid);
		BS_Delete(bitstream);
		return 1 ;
	}
	
	if ( ! rows ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игроки с данными параметрами не найдены." );
	new rows_list = page_count [ playerid ] - 1 ;
	page_rows [ playerid ] = rows ;
	
	global_string [ 0 ] = EOS ;
	new line_string [ 128 ], pl_ofm_name [ 24 ], pl_ofm_online [ 24 ], row_count ;
	for ( new i = rows_list * 10 ; i <  rows_list * 10 + 10 ; i ++ )
	{
		if ( i >= rows ) break ;

		cache_get_field_content ( i, "bl_name", pl_ofm_name, sql_connection, 24 ) ;
		cache_get_field_content ( i, "bl_date", pl_ofm_online, sql_connection, 24 ) ;

		new pvar_string [ 8 ] ;
		format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", i - rows_list * 10 ) ;
		SetPVarString ( playerid, pvar_string, pl_ofm_name ) ;

		new _pl_id ;
		sscanf ( pl_ofm_name, "u", _pl_id ) ;

		format ( line_string, sizeof ( line_string ), "%s - Дата занесения: {"#cBL"}%s{"#cWH"} (%s)\n", pl_ofm_name, pl_ofm_online, ( IsPlayerConnected ( _pl_id ) ) ? ( "{"#cGN"}ONLINE{ffffff}" ) : ( "{"#cRD"}OFFLINE{ffffff}" ) ) ;
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
    
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < rows )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog ( playerid, d_offmembers_list4, DIALOG_STYLE_LIST, "{"#cBHD"}Чёрный список", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

callback: callback_bl_family_info ( playerid )
{
	new rows, fields;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		new pl_date [ 24 ], pl_reason [ 24 ], pl_add_name [ 32 ] ;

		cache_get_field_content ( 0, "bl_date", pl_date, sql_connection, 24 ) ;
		cache_get_field_content ( 0, "bl_reason", pl_reason, sql_connection, 24 ) ;
		cache_get_field_content ( 0, "bl_add_name", pl_add_name, sql_connection, 32 ) ;

		new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
		format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
		GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;

		static const _str [ ] = "{"#cWH"}Имя: {"#cBL"}%s{"#cWH"}\nПричина: {"#cBL"}%s{"#cWH"}\nДата занесения: {"#cBL"}%s{"#cWH"}\nЗанес: {"#cBL"}%s{"#cWH"}" ;
		new dialog_string [ sizeof _str + 24 + 24 + 16 + 24 ] ;
		format ( dialog_string, sizeof ( dialog_string ), _str, pl_name, pl_reason, pl_date, pl_add_name ) ;
		show_dialog ( playerid, d_offmembers_pl_menu_info4, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация о игроке", dialog_string, "Назад", "" ) ;
	}
	if ( ! rows )
	{
		DeletePVar( playerid, "ofm_listitem" ) ;
		if( ! GetPVarInt ( playerid, "ofm_type" ) )
		{
			new sql_string [ 79 + 9 ] ;
			format ( sql_string, sizeof sql_string, "SELECT `bl_name`,`bl_date` FROM `familys_blacklist` WHERE `bl_family` = '%d'", p_info [ playerid ] [ family ] ) ;
			mysql_tquery ( sql_connection, sql_string, "callback_bl_family", "i", playerid ) ;
			return 1;
		}
	}
	return 1 ;
}

callback: get_familys_logs_info ( playerid )
{
    new rows, fields;
	cache_get_data(rows, fields);

	if ( ! rows )
	{
	    page_count [ playerid ] = 0 ;
		show_family ( playerid ) ;
		return 1 ;
	}

	new _t_name [ 32 ], _t_date [ 48 ], _t_text [ 128 ], _t_type ;
	cache_get_field_content ( 0, "name", _t_name, sql_connection, 32 ) ;
	cache_get_field_content ( 0, "text_date", _t_date, sql_connection, 48 ) ;
	cache_get_field_content ( 0, "Text", _t_text, sql_connection, 128 ) ;
	_t_type = cache_get_field_content_int ( 0, "type", sql_connection ) ;

	static const _str [ ] = "{"#cWH"}Ник персонажа: {"#cOR"}%s\n{"#cWH"}Дата: {"#cWV"}%s\n{"#cWH"}Тип: {"#cOR"}%s\n\n{"#cWH"}Действие: {"#cGN"}%s" ;
	new logs_dialog [ sizeof _str + 24 + 16 + 24 + 128 ] ;
	format ( logs_dialog, sizeof(logs_dialog), _str, _t_name, _t_date, logs_type_family ( _t_type ), _t_text ) ;
	show_dialog ( playerid, d_familys_logback, DIALOG_STYLE_MSGBOX, "{"#cBHD"}История семьи", logs_dialog, "Назад", "Закрыть" ) ;
	return 1 ;
}

callback: get_familys_logs ( playerid )
{
    global_string [ 0 ] = EOS ;
	new rows, fields;
	cache_get_data(rows, fields);
	if ( ! rows )
	{
	    page_count [ playerid ] = 0 ;
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Активных логов не найдено." ) ;
		return 1 ;
	}
	
	page_rows [ playerid ] = rows ;
    new rows_list = page_count [ playerid ] - 1 ;
    global_string [ 0 ] = EOS ;
	new line_string [ 128 ], row_count ;
    new _t_name [ 32 ], _t_id, _t_time, float_time, _t_type ;
	for ( new i = rows_list * 10 ; i <  rows_list * 10 + 10 ; i ++ )
	{
	    if ( i >= rows ) break ;

	    _t_id = cache_get_field_content_int ( i, "id", sql_connection ) ;

		cache_get_field_content ( i, "name", _t_name, sql_connection, 32 ) ;
		_t_time = cache_get_field_content_int ( i, "text_time", sql_connection ) ;
		_t_type = cache_get_field_content_int ( i, "type", sql_connection ) ;

        float_time = gettime( ) - _t_time ;

		set_player_listitem_values ( playerid, i - rows_list * 10, _t_id ) ;

		format(line_string, sizeof(line_string), "{"#cBL"}%d. {"#cGRDialog"}[%s{"#cGRDialog"}] {"#cWH"}%s {"#cGRDialog"}(%s)\n", i + 1, logs_type_family ( _t_type ), _t_name, check_float_time ( float_time ));
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
	
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < rows )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_familys_lognext, DIALOG_STYLE_LIST, "{"#cBHD"}История семьи", global_string, "Выбрать", "Закрыть");
	return 1 ;
}

callback: logs_info_family ( playerid )
{
    new rows, fields;
	cache_get_data(rows, fields);

	if ( ! rows )
	{
	    page_count [ playerid ] = 0 ;
		show_family ( playerid ) ;
		return 1 ;
	}

	new _t_name [ 32 ], _t_date [ 48 ], _t_text [ 128 ], _t_type ;
	cache_get_field_content ( 0, "name", _t_name, sql_connection, 32 ) ;
	cache_get_field_content ( 0, "text_date", _t_date, sql_connection, 48 ) ;
	cache_get_field_content ( 0, "Text", _t_text, sql_connection, 128 ) ;
	_t_type = cache_get_field_content_int ( 0, "type", sql_connection ) ;

	static const _str [ ] = "{"#cWH"}Ник персонажа: {"#cOR"}%s\n{"#cWH"}Дата: {"#cWV"}%s\n{"#cWH"}Тип: {"#cOR"}%s\n\n{"#cWH"}Действие: {"#cGN"}%s" ;
	new logs_dialog [ sizeof _str + 24 + 16 + 24 + 128 ] ;
	format ( logs_dialog, sizeof(logs_dialog), _str, _t_name, _t_date, logs_type_family ( _t_type ), _t_text);
	show_dialog ( playerid, d_family_logback, DIALOG_STYLE_MSGBOX, "{"#cBHD"}История семьи", logs_dialog, "Назад", "Закрыть" ) ;
	return 1 ;
}

callback: logs_family ( playerid )
{
    global_string [ 0 ] = EOS ;
	new rows, fields;
	cache_get_data(rows, fields);
	if ( ! rows )
	{
	    page_count [ playerid ] = 0 ;
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Активных логов не найдено." ) ;
		return 1 ;
	}

	page_rows [ playerid ] = rows ;
    new rows_list = page_count [ playerid ] - 1 ;
    global_string [ 0 ] = EOS ;
	new line_string [ 128 ], row_count ;
    new _t_name [ 32 ], _t_id, _t_time, float_time, _t_type ;
	for ( new i = rows_list * 10 ; i <  rows_list * 10 + 10 ; i ++ )
	{
	    if ( i >= rows ) break ;

	    _t_id = cache_get_field_content_int ( i, "id", sql_connection ) ;

		cache_get_field_content ( i, "name", _t_name, sql_connection, 32 ) ;
		_t_time = cache_get_field_content_int ( i, "text_time", sql_connection ) ;
		_t_type = cache_get_field_content_int ( i, "type", sql_connection ) ;

        float_time = gettime( ) - _t_time ;

		set_player_listitem_values ( playerid, i - rows_list * 10, _t_id ) ;

		format(line_string, sizeof(line_string), "{"#cBL"}%d. {"#cGRDialog"}[%s{"#cGRDialog"}] {"#cWH"}%s {"#cGRDialog"}(%s)\n", i + 1, logs_type_family ( _t_type ), _t_name, check_float_time ( float_time ));
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
	
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < rows )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_family_lognext, DIALOG_STYLE_LIST, "{"#cBHD"}История семьи", global_string, "Выбрать", "Закрыть");
	return 1 ;
}

callback: logs_player_family_info ( playerid )
{
    new rows, fields;
	cache_get_data(rows, fields);

	if ( ! rows )
	{
	    page_count [ playerid ] = 0 ;
		show_family ( playerid ) ;
		return 1 ;
	}

	new _t_name [ 32 ], _t_date [ 48 ], _t_text [ 128 ], _t_type ;
	cache_get_field_content ( 0, "name", _t_name, sql_connection, 32 ) ;
	cache_get_field_content ( 0, "text_date", _t_date, sql_connection, 48 ) ;
	cache_get_field_content ( 0, "Text", _t_text, sql_connection, 128 ) ;
	_t_type = cache_get_field_content_int ( 0, "type", sql_connection ) ;

	static const _str [ ] = "{"#cWH"}Ник персонажа: {"#cOR"}%s\n{"#cWH"}Дата: {"#cWV"}%s\n{"#cWH"}Тип: {"#cOR"}%s\n\n{"#cWH"}Действие: {"#cGN"}%s" ;
	new logs_dialog [ sizeof _str + 24 + 16 + 24 + 128 ] ;
	format ( logs_dialog, sizeof(logs_dialog), _str, _t_name, _t_date, logs_type_family ( _t_type ), _t_text);
	show_dialog ( playerid, d_offamily_logback, DIALOG_STYLE_MSGBOX, "{"#cBHD"}История семьи", logs_dialog, "Назад", "Закрыть" ) ;
	return 1 ;
}

callback: logs_player_family ( playerid )
{
    global_string [ 0 ] = EOS ;
	new rows, fields;
	cache_get_data(rows, fields);
	if ( ! rows )
	{
	    page_count [ playerid ] = 0 ;
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Активных логов не найдено." ) ;
		return 1 ;
	}

	page_rows [ playerid ] = rows ;
    new rows_list = page_count [ playerid ] - 1 ;
    global_string [ 0 ] = EOS ;
	new line_string [ 128 ], row_count ;
    new _t_name [ 32 ], _t_id, _t_time, float_time, _t_type ;
	for ( new i = rows_list * 10 ; i <  rows_list * 10 + 10 ; i ++ )
	{
	    if ( i >= rows ) break ;

	    _t_id = cache_get_field_content_int ( i, "id", sql_connection ) ;

		cache_get_field_content ( i, "name", _t_name, sql_connection, 32 ) ;
		_t_time = cache_get_field_content_int ( i, "text_time", sql_connection ) ;
		_t_type = cache_get_field_content_int ( i, "type", sql_connection ) ;

        float_time = gettime( ) - _t_time ;

		set_player_listitem_values ( playerid, i - rows_list * 10, _t_id ) ;

		format(line_string, sizeof(line_string), "{"#cBL"}%d. {"#cGRDialog"}[%s{"#cGRDialog"}] {"#cWH"}%s {"#cGRDialog"}(%s)\n", i + 1, logs_type_family ( _t_type ), _t_name, check_float_time ( float_time ));
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
	
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < rows )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog(playerid, d_offamily_lognext, DIALOG_STYLE_LIST, "{"#cBHD"}История семьи", global_string, "Выбрать", "Закрыть");
	return 1;
}

stock write_family ( playerid, fam, type, text [ ] )
{
	global_string [ 0 ] = EOS ;

	format(global_string, sizeof global_string, "INSERT INTO `logs_family`(`name`, `family`, `type`, `Text`, `text_date`, `text_time`) VALUES ('%s', '%d', '%d', '%s', NOW(), '%d')", p_info [ playerid ] [ name ], fam, type, text, gettime( ) ) ;
	mysql_tquery(sql_connection, global_string, "", "");
	return 1 ;
}

stock familys_OnPlayerGiveDamage ( playerid, damagedid, weaponid, Float:amount )
{
	new _f_id = p_info [ playerid ] [ family ], _df_id = p_info [ damagedid ] [ family ] ;
	if ( _f_id != 0 && _df_id != 0 )
	{
		if ( family_dip_settings [ _f_id ] [ _df_id ] [ 1 ] == dip_settings_on )
		{
			GameTextForPlayer ( playerid, "~r~STOP THE FIRE~n~~r~ON YOUR ALLIES", 2000, 3 ) ;
			GiveDamageForPlayer ( damagedid, playerid, weaponid, 0.0 ) ;
		    return 1 ;
	    }
	}
	
	if ( zones_captured != -1 )
	{
		if ( ( IsPlayerInFamilyZone ( playerid, zones_captured ) || ( IsPlayerInRangeOfQuad ( playerid, family_wars [ zones_captured ] [ gz_pos ] [ 2 ], family_wars [ zones_captured ] [ gz_pos ] [ 3 ] ) < 200 || IsPlayerInRangeOfQuad ( playerid, family_wars [ zones_captured ] [ gz_pos ] [ 0 ], family_wars [ zones_captured ] [ gz_pos ] [ 1 ] ) < 200 ) ) )
		{
			if ( p_info [ playerid ] [ famblock ] > 0 )
   			{
   			    SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас имеется запрет на участие в захватах." ) ;
		   		GiveDamageForPlayer ( damagedid, playerid, weaponid, 0.0 ) ;
   			    return 1 ;
   			}
   			if ( p_info [ damagedid ] [ famblock ] > 0 )
   			{
   			    SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У игрока имеется запрет на участие в захватах." ) ;
		   		GiveDamageForPlayer ( damagedid, playerid, weaponid, 0.0 ) ;
   			    return 1 ;
   			}
				
			if ( _f_id == _df_id ||
				family_dip_settings [ _f_id ] [ _df_id ] [ 1 ] == dip_settings_on )
			{
				GameTextForPlayer ( playerid, "~r~STOP THE FIRE~n~~r~ON YOUR ALLIES", 2000, 3 ) ;
				GiveDamageForPlayer ( damagedid, playerid, weaponid, 0.0 ) ;
				return 1 ;
			}
		}
		
		p_info [ playerid ] [ family_damage ] += amount ;

		if ( p_info [ playerid ] [ family_status ] > 1 )
		{
			new _string [ 16 ] ;
			format ( _string, sizeof _string, "%.2f", p_info [ playerid ] [ family_damage ] ) ;
			PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 6 ], _string ) ;
		}
	}
	return 1 ;
}

stock familys_pay_day_time ( playerid )
{
	new _family_id = p_info [ playerid ] [ family ] ;
	if ( _family_id > 0 )
	{
		new _fam_money = family_info [ _family_id - 1 ] [ fam_payday ] [ p_info [ playerid ] [ family_rang ] - 1 ],
			_fam_ticket = family_info [ _family_id - 1 ] [ fam_payday_ticket ] [ p_info [ playerid ] [ family_rang ] - 1 ] ;
		if ( _fam_money > 0 )
		{
			if ( family_info [ _family_id - 1 ] [ fam_bank ] > _fam_money )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "Премиальные (%s): {"#cGN"}%i"valute_title_"{"#cWH"}", family_info [ _family_id - 1 ] [ fam_name ], _fam_money ) ;
				SendClientMessage ( playerid, col_white, global_string ) ;
				
				family_info [ _family_id - 1 ] [ fam_bank ] -= _fam_money ;
				give_money ( playerid, _fam_money ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, _fam_money, "family payday" ) ;
			}
			else
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В банке семьи недостаточно средств, чтоб выплатить Вам заработную плату!" ) ;
			}
		}
		if ( _fam_ticket > 0 )
		{
			if ( family_info [ _family_id - 1 ] [ fam_ticket ] > _fam_ticket )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "Премиальные (%s): {"#cGN"}%i "family_title"{"#cWH"}", family_info [ _family_id - 1 ] [ fam_name ], _fam_ticket ) ;
				SendClientMessage ( playerid, col_white, global_string ) ;
				
				family_info [ _family_id - 1 ] [ fam_ticket ] -= _fam_ticket ;
				p_info [ playerid ] [ family_ticket ] += _fam_ticket ;
			}
			else
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В банке семьи недостаточно средств, чтоб выплатить Вам "family_title"!" ) ;
			}
		}
	}
	return 1 ;
}

stock familys_player_timer ( playerid, _checking_count )
{
	new _fam_id = p_info [ playerid ] [ family ] ;
	if ( _fam_id > 0 )
	{
	    if ( ! p_info [ playerid ] [ family_quest ] )
	    {
	        if ( ++ p_t_info [ playerid ] [ send_family ] > _checking_count )
	        {
				static const _str [ ] = "{%s}[FAM] Вам доступен ежедневный семейный квест. (/gps - Прочее - Семейный центр)" ;
	            new text_string [ sizeof _str + 8 ] ;
				format ( text_string, sizeof text_string, _str, family_info [ _fam_id - 1 ] [ fam_chat_color ] ) ;
				SendClientMessage ( playerid, col_gray, text_string ) ;
				
				p_t_info [ playerid ] [ send_family ] = 0 ;
			}
		}
		else
		{
			if ( ++ p_t_info [ playerid ] [ send_family ] > _checking_count )
			{
				static const _quest_progress [ ] =
				{
					70,
					36,
					42,
					5000,
					100,
					500,
					400,
					300
				} ;
				
				if ( family_info [ _fam_id - 1 ] [ fam_quest ] > 0 && family_info [ _fam_id - 1 ] [ fam_quest_progress ] < _quest_progress [ family_info [ _fam_id - 1 ] [ fam_quest ] - 1 ] )
				{
					static const _str [ ] = "{%s}[FAM] Вашей семье доступен еженедельный семейный квест. (/gps - Прочее - Семейный центр)" ;
					new text_string [ sizeof _str + 8 ] ;
					format ( text_string, sizeof text_string, _str, family_info [ _fam_id - 1 ] [ fam_chat_color ] ) ;
					SendClientMessage ( playerid, col_gray, text_string ) ;
				}
				
				p_t_info [ playerid ] [ send_family ] = 0 ;
			}
		}
	}
	return 1 ;
}

stock familys_OnGameModeInit ( )
{
	mysql_tquery ( sql_connection, !"SELECT * FROM `family` ORDER BY `family`.`fam_id` ASC", "family_loading" ) ;
	mysql_tquery ( sql_connection, !"SELECT * FROM `family_prise` ORDER BY `family_prise`.`fam_slot` DESC LIMIT 1", "callback_last_prise_family" ) ;

	Iter_Init(family_players) ;
	Iter_Init(family_vehicles) ;
	return 1 ;
}

callback: callback_last_prise_family ( )
{
    new fields,
		rows,
		time = GetTickCount ( ) ;

	cache_get_data ( rows, fields ) ;

    if ( rows ) prise_family_inc_id = cache_get_field_content_int ( 0, "fam_slot", sql_connection ) ;
    printf("[SERVER] Загружен %d последний предмет в семье. (%d ms)", prise_family_inc_id, GetTickCount ( ) - time ) ;
	return 1 ;
}

callback: load_fam_graffity ( )
{
	new fields, time = GetTickCount ( ) ;
	cache_get_data ( count_fam_graffity, fields ) ;
	for ( new i = 1 ; i < count_fam_graffity ; i ++ )
	{
		graf_fam_info [ i ] [ g_fam_id ] = cache_get_row_int ( i - 1, 0, sql_connection ) ;
		graf_fam_info [ i ] [ g_fam_member ] = cache_get_row_int ( i - 1, 1, sql_connection ) ;
		graf_fam_info [ i ] [ gr_fam_x ] [ 0 ] = cache_get_row_float ( i - 1, 2, sql_connection ) ;
		graf_fam_info [ i ] [ gr_fam_x ] [ 1 ] = cache_get_row_float ( i - 1, 3, sql_connection ) ;
		graf_fam_info [ i ] [ gr_fam_x ] [ 2 ] = cache_get_row_float ( i - 1, 4, sql_connection ) ;
		graf_fam_info [ i ] [ gr_fam_x ] [ 3 ] = cache_get_row_float ( i - 1, 5, sql_connection ) ;
		graf_fam_info [ i ] [ gr_fam_x ] [ 4 ] = cache_get_row_float ( i - 1, 6, sql_connection ) ;
		graf_fam_info [ i ] [ gr_fam_x ] [ 5 ] = cache_get_row_float ( i - 1, 7, sql_connection ) ;
		graf_fam_info [ i ] [ gr_fam_x ] [ 6 ] = cache_get_row_float ( i - 1, 8, sql_connection ) ;
		
		if ( graf_fam_info [ i ] [ g_fam_member ] > 0 )
		{
			new family_id = graf_fam_info [ i ] [ g_fam_member ] ;
			family_info [ family_id - 1 ] [ fam_graffity ] ++ ;
			
			static const _color [ ] [ 10 ] =
			{
				"{ffffff}",
				"{ad01bc}",
				"{ffa200}",
				"{861400}",
				"{00de00}",
				"{e9ff00}",
				"{0c00ff}",
				"{00b7ff}",
				"{ff00ff}",
				"{ff0000}"
			} ;
				
			graf_fam_info [ i ] [ g_fam_object ] = CreateDynamicObject ( 2934, graf_fam_info [ i ] [ gr_fam_x ] [ 0 ], graf_fam_info [ i ] [ gr_fam_x ] [ 1 ], graf_fam_info [ i ] [ gr_fam_x ] [ 2 ], graf_fam_info [ i ] [ gr_fam_x ] [ 3 ], graf_fam_info [ i ] [ gr_fam_x ] [ 4 ], graf_fam_info [ i ] [ gr_fam_x ] [ 5 ], 0, 0 ) ;
			
			new sql_string [ 100 ] ;
			format ( sql_string, sizeof sql_string, "%s%s", _color [ family_info [ family_id - 1 ] [ fam_graffity_color ] ], family_info [ family_id - 1 ] [ fam_name ] ) ;
			SetDynamicObjectMaterialText(graf_fam_info [ i ] [ g_fam_object ], 0, sql_string, 130, "Ariel", 48, 1, 0xFFFFFAF0, 0x00000000, 1);
		}
		else
		{
			graf_fam_info [ i ] [ g_fam_object ] = CreateDynamicObject ( 2934, graf_fam_info [ i ] [ gr_fam_x ] [ 0 ], graf_fam_info [ i ] [ gr_fam_x ] [ 1 ], graf_fam_info [ i ] [ gr_fam_x ] [ 2 ], graf_fam_info [ i ] [ gr_fam_x ] [ 3 ], graf_fam_info [ i ] [ gr_fam_x ] [ 4 ], graf_fam_info [ i ] [ gr_fam_x ] [ 5 ], 0, 0 ) ;
			SetDynamicObjectMaterialText(graf_fam_info [ i ] [ g_fam_object ], 0, "Unknown", 130, "Ariel", 48, 1, 0xFFFFFAF0, 0x00000000, 1);
		}
		graf_fam_info [ i ] [ g_fam_area ] = CreateDynamicSphere ( graf_fam_info [ i ] [ gr_fam_x ] [ 0 ], graf_fam_info [ i ] [ gr_fam_x ] [ 1 ], graf_fam_info [ i ] [ gr_fam_x ] [ 2 ], 5.0, -1, -1, -1 ) ;
		area_info [ graf_fam_info [ i ] [ g_fam_area ] ] [ a_type ] = area_type_fam_graffity ;
		area_info [ graf_fam_info [ i ] [ g_fam_area ] ] [ a_item ] = i ;
	}
	printf ( "[SERVER] Загружено %i семейных граффити. (%d ms)", count_fam_graffity, GetTickCount ( ) - time ) ;
	return 1 ;
}

callback: family_wars_loading ( )
{
    new rows, fields, time = GetTickCount ( ) ;
    cache_get_data ( rows, fields ) ;
	if ( rows )
	{
	    for ( new i = 0 ; i < rows ; i ++ )
		{
		    new fr_fam, fr_to_fam, fr_fam_dip, fam_dip_chat, fam_dip_damage ;
		    fr_fam = cache_get_field_content_int ( i, "f_fam", sql_connection ) ;
		    fr_to_fam = cache_get_field_content_int ( i, "f_to_fam", sql_connection ) ;
		    fr_fam_dip = cache_get_field_content_int ( i, "fam_dip", sql_connection ) ;
		    fam_dip_chat = cache_get_field_content_int ( i, "fam_chat", sql_connection ) ;
		    fam_dip_damage = cache_get_field_content_int ( i, "fam_damage", sql_connection ) ;

		    family_diplomacy [ fr_fam ] [ fr_to_fam ] =
		    family_diplomacy [ fr_to_fam ] [ fr_fam ] = fr_fam_dip ;

		    family_dip_settings [ fr_fam ] [ fr_to_fam ] [ 0 ] = fam_dip_chat ;
		    family_dip_settings [ fr_fam ] [ fr_to_fam ] [ 1 ] = fam_dip_damage ;
		}
	}
	printf ( "[SERVER] Загружено %d дипломатических семей. (%d ms)", rows, GetTickCount ( ) - time ) ;
	return 1 ;
}

callback: family_loading ( )
{
    new fields, time = GetTickCount ( ) ;
    cache_get_data ( family_count, fields ) ;
    if ( family_count )
    {
		new str_to_hex [ 28 ] ;
        for ( new f = 0 ; f < family_count ; f ++ )
        {
            family_info [ f ] [ fam_id ] = cache_get_field_content_int ( f, "fam_id", sql_connection ) ;
			cache_get_field_content ( f, "fam_name", family_info [ f ] [ fam_name ], sql_connection, 68 ) ;
			cache_get_field_content ( f, "fam_creator", family_info [ f ] [ fam_creator ], sql_connection, MAX_PLAYER_NAME ) ;

            family_info [ f ] [ fam_nationality ] = cache_get_field_content_int (f, "fam_nationality", sql_connection ) ;

			cache_get_field_content ( f, "fam_chat_color", family_info [ f ] [ fam_chat_color ], sql_connection, 8 ) ;
			
			format ( str_to_hex, sizeof str_to_hex, "0x%s55", family_info [ f ] [ fam_chat_color ] ) ;
			family_info [ f ] [ fam_zone_color ] = StrToHex ( str_to_hex ) ;

			global_string [ 0 ] = EOS ;
			cache_get_field_content ( f, "fam_settings", global_string, sql_connection, 64 ), sscanf ( global_string, "p<|>ddddddddd",
			family_info [ f ] [ fam_settings ] [ 0 ], family_info [ f ] [ fam_settings ] [ 1 ], family_info [ f ] [ fam_settings ] [ 2 ],
			family_info [ f ] [ fam_settings ] [ 3 ], family_info [ f ] [ fam_settings ] [ 4 ], family_info [ f ] [ fam_settings ] [ 5 ],
			family_info [ f ] [ fam_settings ] [ 6 ], family_info [ f ] [ fam_settings ] [ 7 ], family_info [ f ] [ fam_settings ] [ 8 ] ) ;

			global_string [ 0 ] = EOS ;
			cache_get_field_content ( f, "fam_ranks", global_string, sql_connection, 372 ), sscanf ( global_string, "p<|>s[30]s[30]s[30]s[30]s[30]s[30]s[30]s[30]s[30]s[30]s[30]s[30]",
			family_rank [ f ] [ 0 ], family_rank [ f ] [ 1 ], family_rank [ f ] [ 2 ], family_rank [ f ] [ 3 ],
			family_rank [ f ] [ 4 ], family_rank [ f ] [ 5 ], family_rank [ f ] [ 6 ], family_rank [ f ] [ 7 ],
			family_rank [ f ] [ 8 ], family_rank [ f ] [ 9 ], family_rank [ f ] [ 10 ], family_rank [ f ] [ 11 ] ) ;

			family_info [ f ] [ fam_bank ] = cache_get_field_content_int ( f, "fam_bank", sql_connection ) ;
			family_info [ f ] [ fam_house ] = cache_get_field_content_int ( f, "fam_house", sql_connection ) ;

			family_info [ f ] [ fam_dorm_status ] = cache_get_field_content_int ( f, "fam_dorm_status", sql_connection ) ;

			family_info [ f ] [ fam_max_warn ] = cache_get_field_content_int ( f, "fam_max_warn", sql_connection ) ;
			family_info [ f ] [ fam_rank_warn ] = cache_get_field_content_int ( f, "fam_rank_warn", sql_connection ) ;
			
			global_string [ 0 ] = EOS ;
			cache_get_field_content ( f, "fam_dorm", global_string ), sscanf ( global_string, "p<|>fffdd",
			dorm_family_pos [ f ] [ 0 ], dorm_family_pos [ f ] [ 1 ], dorm_family_pos [ f ] [ 2 ],
			dorm_family_int [ f ], dorm_family_virt [ f ] ) ;
			
			global_string [ 0 ] = EOS ;
			cache_get_field_content ( f, "fam_enhancement", global_string ), sscanf ( global_string, "p<|>ddddddddddd",
			family_info [ f ] [ fam_enhancement ] [ 0 ], family_info [ f ] [ fam_enhancement ] [ 1 ], family_info [ f ] [ fam_enhancement ] [ 2 ],
			family_info [ f ] [ fam_enhancement ] [ 3 ], family_info [ f ] [ fam_enhancement ] [ 4 ], family_info [ f ] [ fam_enhancement ] [ 5 ],
			family_info [ f ] [ fam_enhancement ] [ 6 ], family_info [ f ] [ fam_enhancement ] [ 7 ], family_info [ f ] [ fam_enhancement ] [ 8 ],
			family_info [ f ] [ fam_enhancement ] [ 9 ], family_info [ f ] [ fam_enhancement ] [ 10 ] ) ;

			if ( family_info [ f ] [ fam_house ] )
			{
				new _house_id = family_info [ f ] [ fam_house ] ;
				add_family_house ( _house_id - 1, 1 ) ;
				h_info [ _house_id - 1 ] [ h_zz_status ] = 1 ;
				
				if ( h_info [ _house_id - 1 ] [ h_garage ] && ! IsValidDynamicArea ( h_info [ _house_id - 1 ] [ h_zz_area ] ) )
				{
					new Float: pos [ 4 ] ;
					get_gz_pos ( h_info [ _house_id - 1 ] [ h_pos ] [ 0 ], h_info [ _house_id - 1 ] [ h_pos ] [ 1 ], 50.0, pos [ 0 ], pos [ 1 ], pos [ 2 ], pos [ 3 ] ) ;
					h_info [ _house_id - 1 ] [ h_zz_area ] = CreateDynamicRectangle ( pos [ 0 ], pos [ 1 ], pos [ 2 ], pos [ 3 ], 0, 0, -1 ) ;
					area_info [ h_info [ _house_id - 1 ] [ h_zz_area ] ] [ a_type ] = area_type_sellstatus ;
				}
				
				if ( dorm_family_virt [ f ] == family_info [ f ] [ fam_house ] )
				{
					if ( dorm_family_pos [ f ] [ 0 ] + dorm_family_pos [ f ] [ 1 ] + dorm_family_pos [ f ] [ 2 ] != 0.0 )
					{
						new t_string [ 300 ] ;
						dorm_family_cp [ f ] = CreateDynamicCP ( dorm_family_pos [ f ] [ 0 ], dorm_family_pos [ f ] [ 1 ], dorm_family_pos [ f ] [ 2 ], 1.0, dorm_family_virt [ f ], dorm_family_int [ f ], -1 ) ;
						dorm_family_area [ f ] = CreateDynamicSphere ( dorm_family_pos [ f ] [ 0 ], dorm_family_pos [ f ] [ 1 ], dorm_family_pos [ f ] [ 2 ] + 1, 2.0, dorm_family_virt [ f ], dorm_family_int [ f ], -1 ) ;
						area_info [ dorm_family_area [ f ] ] [ a_type ] = area_type_family_dorm ;

						format ( t_string,sizeof ( t_string ),"\
						{%s}*** Общак %s ***\n\n\
						{"#cWH3D"}Количество территорий:{"#cOR3D"} \t%d\n\
						{"#cWH3D"}"family_title":{"#cOR3D"} \t%d шт.",
						family_info [ f ] [ fam_chat_color ],
						family_info [ f ] [ fam_name ],
						family_info [ f ] [ fam_zones ],
						family_info [ f ] [ fam_ticket ] ) ;

						gdorm_family_text [ f ] = CreateDynamic3DTextLabel ( t_string, col_blue, dorm_family_pos [ f ] [ 0 ], dorm_family_pos [ f ] [ 1 ], dorm_family_pos [ f ] [ 2 ] + 1, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, dorm_family_virt [ f ], dorm_family_int [ f ] ) ;
					}
				}
			}
			
			family_info [ f ] [ fam_members ] = cache_get_field_content_int ( f, "fam_members", sql_connection ) ;
			
			family_info [ f ] [ fam_rating ] = cache_get_field_content_int ( f, "fam_rating", sql_connection ) ;
			family_info [ f ] [ fam_ticket ] = cache_get_field_content_int ( f, "fam_ticket", sql_connection ) ;
			
			family_info [ f ] [ fam_max_car ] = cache_get_field_content_int ( f, "fam_max_car", sql_connection ) ;
			
			family_info [ f ] [ fam_quest ] = cache_get_field_content_int ( f, "fam_quest", sql_connection ) ;
			family_info [ f ] [ fam_quest_progress ] = cache_get_field_content_int ( f, "fam_quest_progress", sql_connection ) ;
			
			family_info [ f ] [ fam_graffity_color ] = cache_get_field_content_int ( f, "fam_graffity_color", sql_connection ) ;
			
			global_string [ 0 ] = EOS ;
			cache_get_field_content ( f, "fam_payday", global_string ), sscanf ( global_string, "p<|>dddddddddddd",
			family_info [ f ] [ fam_payday ] [ 0 ], family_info [ f ] [ fam_payday ] [ 1 ], family_info [ f ] [ fam_payday ] [ 2 ],
			family_info [ f ] [ fam_payday ] [ 3 ], family_info [ f ] [ fam_payday ] [ 4 ], family_info [ f ] [ fam_payday ] [ 5 ],
			family_info [ f ] [ fam_payday ] [ 6 ], family_info [ f ] [ fam_payday ] [ 7 ], family_info [ f ] [ fam_payday ] [ 8 ],
			family_info [ f ] [ fam_payday ] [ 9 ], family_info [ f ] [ fam_payday ] [ 10 ], family_info [ f ] [ fam_payday ] [ 11 ] ) ;
			
			global_string [ 0 ] = EOS ;
			cache_get_field_content ( f, "fam_payday_ticket", global_string ), sscanf ( global_string, "p<|>dddddddddddd",
			family_info [ f ] [ fam_payday_ticket ] [ 0 ], family_info [ f ] [ fam_payday_ticket ] [ 1 ], family_info [ f ] [ fam_payday_ticket ] [ 2 ],
			family_info [ f ] [ fam_payday_ticket ] [ 3 ], family_info [ f ] [ fam_payday_ticket ] [ 4 ], family_info [ f ] [ fam_payday_ticket ] [ 5 ],
			family_info [ f ] [ fam_payday_ticket ] [ 6 ], family_info [ f ] [ fam_payday_ticket ] [ 7 ], family_info [ f ] [ fam_payday_ticket ] [ 8 ],
			family_info [ f ] [ fam_payday_ticket ] [ 9 ], family_info [ f ] [ fam_payday_ticket ] [ 10 ], family_info [ f ] [ fam_payday_ticket ] [ 11 ] ) ;
		}
    }
	
	new dialog_string [ 128 ] ;
    for ( new i = 0 ; i < family_count ; i ++ )
    {
		family_diplomacy [ i ] [ i ] = dip_status_alliance ;
			
        for ( new q = 0 ; q < family_count ; q ++ )
    	{
        	family_diplomacy [ i ] [ q ] = dip_status_neutral ;
	    	family_dip_settings [ i ] [ q ] [ 0 ] = dip_settings_off ;
	    	family_dip_settings [ i ] [ q ] [ 1 ] = dip_settings_off ;
	    }
		
		format ( dialog_string, sizeof dialog_string, "UPDATE `users` SET `u_family_rank` = '%d' WHERE `u_name` = '%s' AND `u_family` = '%d'", 
		family_info [ i ] [ fam_settings ] [ 3 ], family_info [ i ] [ fam_creator ], i + 1 ) ;
		mysql_tquery ( sql_connection, dialog_string ) ;
    
        format ( dialog_string, sizeof ( dialog_string ),"SELECT `u_family` FROM `users` WHERE `u_family` = '%d'", i + 1 ) ;
		mysql_tquery ( sql_connection, dialog_string, "family_loading_member", "i", i ) ;
		break ;
    }
    printf ( "[SERVER] Загружено %d семей. (%d ms)", family_count, GetTickCount ( ) - time ) ;
    mysql_tquery ( sql_connection, !"SELECT * FROM `family_wars`", "family_wars_loading" ) ;
	mysql_tquery ( sql_connection, !"SELECT * FROM `familyzones` ORDER BY `familyzones`.`gz_id` ASC", "familyzones_loading" ) ;
	mysql_tquery ( sql_connection, !"SELECT * FROM `family_grafity`", "load_fam_graffity" ) ;
	mysql_tquery ( sql_connection, !"SELECT * FROM `family_enprises`", "load_family_enterprises" ) ;
    return 1 ;
}

callback: family_loading_member ( _fam_id )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	new dialog_string [ 128 ] ;
	family_info [ _fam_id ] [ fam_members ] = rows ;
	format ( dialog_string, sizeof ( dialog_string ), "UPDATE `family` SET `fam_members` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _fam_id ] [ fam_members ], _fam_id + 1 ) ;
	mysql_tquery ( sql_connection, dialog_string ) ;
	
    for ( new i = _fam_id + 1 ; i < family_count ; i ++ )
    {
		family_diplomacy [ i ] [ i ] = dip_status_alliance ;
			
        for ( new q = 0 ; q < family_count ; q ++ )
    	{
        	family_diplomacy [ i ] [ q ] = dip_status_neutral ;
	    	family_dip_settings [ i ] [ q ] [ 0 ] = dip_settings_off ;
	    	family_dip_settings [ i ] [ q ] [ 1 ] = dip_settings_off ;
	    }
		
		format ( dialog_string, sizeof dialog_string, "UPDATE `users` SET `u_family_rank` = '%d' WHERE `u_name` = '%s' AND `u_family` = '%d'", 
		family_info [ i ] [ fam_settings ] [ 3 ], family_info [ i ] [ fam_creator ], _fam_id + 1 ) ;
		mysql_tquery ( sql_connection, dialog_string ) ;
    
        format ( dialog_string, sizeof ( dialog_string ),"SELECT `u_family` FROM `users` WHERE `u_family` = '%d'", i + 1 ) ;
		mysql_tquery ( sql_connection, dialog_string, "family_loading_member", "i", i ) ;
		break ;
    }
	return 1 ;
}

callback: callback_prise_family_loading ( _fam_id )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;

	for ( new i = 0 ; i < MAX_FAMILY_WAREHOUSE ; i ++ )
	{
	    family_info [ _fam_id - 1 ] [ fam_slot_id ] [ i ] =
	    family_info [ _fam_id - 1 ] [ fam_slot ] [ i ] =
	    family_info [ _fam_id - 1 ] [ fam_slot_count ] [ i ] =
	    family_info [ _fam_id - 1 ] [ fam_slot_date ] [ i ] = 0 ;
	}

	if ( rows )
	{
	    for ( new i = 0 ; i < rows ; i ++ )
	    {
	        if ( i > MAX_FAMILY_WAREHOUSE - 1 ) break ;
	        family_info [ _fam_id - 1 ] [ fam_slot_id ] [ i ] = cache_get_field_content_int ( i, "fam_slot", sql_connection ) ;
	        family_info [ _fam_id - 1 ] [ fam_slot ] [ i ] = cache_get_field_content_int ( i, "fam_item", sql_connection ) ;
	        family_info [ _fam_id - 1 ] [ fam_slot_count ] [ i ] = cache_get_field_content_int ( i, "fam_count", sql_connection ) ;
	        family_info [ _fam_id - 1 ] [ fam_slot_date ] [ i ] = cache_get_field_content_int ( i, "fam_date", sql_connection ) ;
	    }
	}
	
	family_info [ _fam_id - 1 ] [ fam_safe_load ] = true ;
	return 1 ;
}

callback: familyzones_loading ( )
{
	new fields, time = GetTickCount ( ) ;
	cache_get_data ( zones_count, fields ) ;
	if ( zones_count )
	{
		new scm_string [ 168 ] ;
        for ( new t = 0 ; t < zones_count ; t ++ )
        {
			family_wars [ t ] [ gz_id ] = cache_get_field_content_int ( t, "gz_id", sql_connection ) ;
			family_wars [ t ] [ gz_owner ] = cache_get_field_content_int ( t, "gz_owner", sql_connection ) ;
			family_wars [ t ] [ gz_hour_talon ] = cache_get_field_content_int ( t, "gz_hour_talon", sql_connection ) ;
			family_wars [ t ] [ gz_hour_money ] = cache_get_field_content_int ( t, "gz_hour_money", sql_connection ) ;
			family_wars [ t ] [ gz_last_capture ] = cache_get_field_content_int ( t, "gz_last_capture", sql_connection ) ;
			if ( GetElapsedTime ( gettime ( ), family_wars [ t ] [ gz_last_capture ], CONVERT_TIME_TO_WEEKS ) > 1 )
			{
				family_wars [ t ] [ gz_owner ] = 0 ;
				SaveFamilyZone ( t ) ;
			}
			
			cache_get_field_content ( t, "gz_name", family_wars [ t ] [ gz_name ], sql_connection, 32 ) ;

			family_wars [ t ] [ pick_pos ] [ 0 ] = cache_get_field_content_float ( t, "gz_x", sql_connection ) ;
			family_wars [ t ] [ pick_pos ] [ 1 ] = cache_get_field_content_float ( t, "gz_y", sql_connection ) ;
			family_wars [ t ] [ pick_pos ] [ 2 ] = cache_get_field_content_float ( t, "gz_z", sql_connection ) ;
															
      		get_gz_pos ( family_wars [ t ] [ pick_pos ] [ 0 ], family_wars [ t ] [ pick_pos ] [ 1 ], 80.0, family_wars [ t ] [ gz_pos ] [ 0 ],
																											family_wars [ t ] [ gz_pos ] [ 1 ],
																											family_wars [ t ] [ gz_pos ] [ 2 ],
																											family_wars [ t ] [ gz_pos ] [ 3 ] ) ;

			family_wars [ t ] [ gz_created ] = GangZoneCreate ( family_wars [ t ] [ gz_pos ] [ 0 ],
															family_wars [ t ] [ gz_pos ] [ 1 ],
															family_wars [ t ] [ gz_pos ] [ 2 ],
															family_wars [ t ] [ gz_pos ] [ 3 ] ) ;

			new _family_id = family_wars [ t ] [ gz_owner ] ;
			if ( _family_id == 0 )
			{
				format ( scm_string, sizeof scm_string, "** %s **\n\n{"#cWH3D"}Под контролем: Неизвестно\n{"#cWH3D"}Талонов в час: {"#cOR3D"}%d шт.\n{"#cWH3D"}Денег в час: {"#cOR3D"}%s"valute_title_"", 
														family_wars [ t ] [ gz_name ], 
														family_wars [ t ] [ gz_hour_talon ],
														GetPlayerCashValueToSmile ( family_wars [ t ] [ gz_hour_money ] ) ) ;
				family_wars [ t ] [ gz_label ] = CreateDynamic3DTextLabel ( scm_string, col_blue, family_wars [ t ] [ pick_pos ] [ 0 ], family_wars [ t ] [ pick_pos ] [ 1 ], family_wars [ t ] [ pick_pos ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, 0, 0 );
			
				family_wars [ t ] [ gz_pickup ] = CreateDynamicPickup ( 1239, 23, family_wars [ t ] [ pick_pos ] [ 0 ], family_wars [ t ] [ pick_pos ] [ 1 ], family_wars [ t ] [ pick_pos ] [ 2 ], 0, 0, -1 ) ;
				pick_info [ family_wars [ t ] [ gz_pickup ] ] [ pick_type ] = pick_type_family_wars ;
			}
			else
			{
				format ( scm_string, sizeof scm_string, "** %s **\n\n{"#cWH3D"}Под контролем: {%s}%s\n{"#cWH3D"}Талонов в час: {"#cOR3D"}%d шт.\n{"#cWH3D"}Денег в час: {"#cOR3D"}%s"valute_title_"", 
														family_wars [ t ] [ gz_name ], 
														family_info [ _family_id - 1 ] [ fam_chat_color ],
														family_info [ _family_id - 1 ] [ fam_name ],
														family_wars [ t ] [ gz_hour_talon ],
														GetPlayerCashValueToSmile ( family_wars [ t ] [ gz_hour_money ] ) ) ;
				family_wars [ t ] [ gz_label ] = CreateDynamic3DTextLabel ( scm_string, col_blue, family_wars [ t ] [ pick_pos ] [ 0 ], family_wars [ t ] [ pick_pos ] [ 1 ], family_wars [ t ] [ pick_pos ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, 0, 0 );
			
				family_wars [ t ] [ gz_pickup ] = CreateDynamicPickup ( 1239, 23, family_wars [ t ] [ pick_pos ] [ 0 ], family_wars [ t ] [ pick_pos ] [ 1 ], family_wars [ t ] [ pick_pos ] [ 2 ], 0, 0, -1 ) ;
				pick_info [ family_wars [ t ] [ gz_pickup ] ] [ pick_type ] = pick_type_family_wars ;
				
				family_info [ _family_id - 1 ] [ fam_zones ] ++ ;
				update_fdorm_text ( _family_id ) ;
			}
		}
	}
	printf ( "[SERVER] Загружено %d семейных зон. (%d ms)", zones_count, GetTickCount ( ) - time ) ;
	return 1 ;
}

stock familys_DynamicPickup ( playerid, pickupid )
{
	switch ( pick_info [ pickupid ] [ pick_type ] )
	{
		case pick_type_family_wars:
		{
			if ( ! p_info [ playerid ] [ family ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Захват доступен только семьям." ) ;
			if ( zones_captured != -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент уже идет война." ) ;
			
			new _family_id = p_info [ playerid ] [ family ], _h_id = family_info [ _family_id - 1 ] [ fam_house ], _fam_level = update_family_level ( _family_id ) ;
			if ( _fam_level < fam_level_capture ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вашей семье не хватает уровня для участия в захватах." ) ;
			if ( ! _h_id ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи нет дома." ) ;
			if ( h_info [ _h_id - 1 ] [ h_podezd ] != -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи не частный дом." ) ;

			new year,
				month,
				day,
				hour,
				minute,
				second ;

			getdate ( year, month, day ) ;
			gettime ( hour, minute, second ) ;
			FixHour ( hour ) ;
			
			if ( global_hour < 12 || global_hour > 23 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Захват территорий возможен только с 12 до 23 часов." ) ;

			if ( zones_war_cd > gettime ( ) )
			{
				new s_year, s_month, s_day, s_hour, s_minute, s_second ;
				timestamp_to_date ( zones_war_cd + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				
				new text_str [ 78 ] ;
				format ( text_str, sizeof ( text_str ), "{"#cRInfo"}* {"#cGRInfo"}Захват будет доступен в %02d:%02d:%02d.", s_hour, s_minute, s_second ) ;
				return SendClientMessage ( playerid, col_gray, text_str ) ;
			}

			if ( Iter_Count(family_players[_family_id]) < familywars_online) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В Вашей семье слишком мало игроков для захвата территории." ) ;
	
			for ( new i = 0 ; i < zones_count ; i ++ )
			{
				if ( IsPlayerInFamilyZone ( playerid, i ) )
				{
					if ( family_wars [ i ] [ gz_owner ] == 0 )
					{
						new _string [ 128 ] ;
						format ( _string, sizeof ( _string ), "[U-FAM] '%s' захватила территорию.",
						family_info [ _family_id - 1 ] [ fam_name ] ) ;
						foreach(new q: logged_players) if ( p_info [ q ] [ family ] ) SendClientMessage ( q, col_fam_alliance, _string ) ;

						family_info [ _family_id - 1 ] [ fam_zones ] ++ ;
						update_fdorm_text ( _family_id ) ;
						
						give_all_family_quest ( _family_id, 6, 5 ) ;
						give_all_family_quest ( _family_id, 7, 5 ) ;
						give_all_family_quest ( _family_id, 8, 5 ) ;
						family_info [ _family_id - 1 ] [ fam_rating ] += 5 ;

						family_wars [ i ] [ gz_owner ] = _family_id ;
						update_famzones_label ( i, family_wars [ i ] [ gz_owner ] ) ;
						SaveFamilyZone ( i ) ;
						return 1 ;
					}
					
					if ( family_wars [ i ] [ gz_owner ] == p_info [ playerid ] [ family ] )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете захватить свою территорию." ) ;
					if ( family_diplomacy [ _family_id ] [ family_wars [ i ] [ gz_owner ] ] != dip_status_war ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Между Вашей семьёй и семьёй контролирующей территорию нет войны." ) ;
					
					new owner_counts = 0 ;
					foreach(new j: family_players[family_wars [ i ] [ gz_owner ]])
					{
						if ( family_wars [ i ] [ gz_owner ] == p_info [ j ] [ family ] && p_info [ j ] [ famblock ] == 0 ) owner_counts ++ ;
					}
					if ( owner_counts < familywars_online )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игроков семьи, контроллирующей территорию, недостаточно для проведения захвата." ) ;
						global_string [ 0 ] = EOS ;
						format ( global_string, 128, "{"#cRInfo"}* {"#cGRInfo"}В игре {"#cRInfo"}%d чел.{"#cGRInfo"} из {"#cRInfo"}%d чел.{"#cGRInfo"} необходимым для захвата.", owner_counts, familywars_online ) ;
						SendClientMessage ( playerid, col_gray, global_string ) ;
						return 1 ;
					}

					zones_captured = i ;
					family_wars [ i ] [ gz_time ] = 600 ;
					family_wars [ i ] [ gz_attacker ] = _family_id ;

					new _string [ 144 ] ;
					format ( _string, sizeof ( _string ), "[U-FAM] '%s' спровоцировала битву за '%s' с '%s'.",
					family_info [ _family_id - 1 ] [ fam_name ],
					family_wars [ i ] [ gz_name ],
					family_info [ family_wars [ i ] [ gz_owner ] - 1 ] [ fam_name ] ) ;
					foreach(new j: logged_players) if ( p_info [ j ] [ family ] ) SendClientMessage ( j, col_fam_alliance, _string ) ;

					format ( _string, sizeof ( _string ), "* %s %s[%d] спровоцировал(а) войну.",
					family_rank [ _family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ],
					p_info [ playerid ] [ name ],
					playerid ) ;
					foreach(new j: logged_players) if ( p_info [ j ] [ family ] ) SendClientMessage ( j, col_fam_alliance, _string ) ;

					zones_owner_points =
					zones_attacker_points =
					zones_kills_first =
					zones_kills_two = 0 ;
						
					format ( zones_kills_first_name, 32, "None" ) ;
					format ( zones_kills_two_name, 32, "None" ) ;
					
					zones_war_cd = SetElapsedTime ( gettime ( ), 4, CONVERT_TIME_TO_HOURS ) ;

					format ( _string, sizeof ( _string ),"UPDATE `users` SET `u_capture_start` = `u_capture_start`+1 WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, _string, "", "" ) ;

					GangZoneFlashForAll ( family_wars [ i ] [ gz_created ], family_info [ _family_id - 1 ] [ fam_zone_color ] ) ;

					zones_capture_type = gz_type_kills ;

					family_wars [ i ] [ gz_timer ] = SetTimerEx ( "familywars_timer", 1000, 1, "iiii", i, _family_id, family_wars [ i ] [ gz_owner ], zones_capture_type ) ;
					break ;
				}
			}
			return 1 ;
		}
		case pick_type_family_enprises:
		{
			if ( p_info [ playerid ] [ family ] < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
			
			new _fam_id = p_info [ playerid ] [ family ], _item = pick_info [ pickupid ] [ pick_item ] ;
			if ( fam_enprises [ _item ] [ fe_owner ] == _fam_id )
			{
				show_family_enterprises ( playerid, _item ) ;
				return 1 ;
			}
			
			if ( update_family_level ( _fam_id ) < fam_enprises [ _item ] [ fe_reid_level ] )
			{
				new line_string [ 128 ] ;
				format ( line_string, sizeof line_string, "{"#cRInfo"}* {"#cGRInfo"}Для взаимодействия с предприятием Ваша семья должа быть {"#cRInfo"}%d уровня{"#cGRInfo"}.", fam_enprises [ _item ] [ fe_reid_level ] ) ;
				SendClientMessage ( playerid, col_gray, line_string ) ;
				return 1 ;
			}
			
			show_family_enterprises ( playerid, _item ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock familys_OnPlayerStateChange ( playerid, newstate, oldstate )
{
	#pragma unused oldstate
	if ( newstate == PLAYER_STATE_DRIVER )
	{
		new veh_id = GetPlayerVehicleID ( playerid ) ;
		if ( veh_info [ veh_id - 1 ] [ v_type ] == vehicle_type_family )
		{
			if ( veh_info [ veh_id - 1 ] [ v_owner ] != p_info [ playerid ] [ family ] )
			{
				RemovePlayerFromVehicle ( playerid ) ;
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Этот транспорт недоступен для Вас." ) ;
				return 1 ;
			}
			if ( veh_info [ veh_id - 1 ] [ v_rank ] > p_info [ playerid ] [ family_rang ] )
			{
				RemovePlayerFromVehicle ( playerid ) ;
				new _t_string [ 64 ] ;
				format ( _t_string, sizeof _t_string, "{"#cRInfo"}* {"#cGRInfo"}Транспорт доступен с {"#cRD"}%d{"#cGRInfo"} ранга.", veh_info [ veh_id - 1 ] [ v_rank ] ) ;
				SendClientMessage ( playerid, col_gray, _t_string ) ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

stock familys_OnPlayerExitVehicle ( playerid, vehicleid )
{
	if ( p_info [ playerid ] [ family ] )
	{
	    if ( p_info [ playerid ] [ family_quest ] == 3 && veh_info [ vehicleid - 1 ] [ v_model ] == 428 ||
			p_info [ playerid ] [ family_quest ] == 4 && veh_info [ vehicleid - 1 ] [ v_model ] == 482 &&
			( p_t_info [ playerid ] [ pl_quest ] == GetPlayerVehicleID ( playerid ) || veh_info [ vehicleid - 1 ] [ v_type ] == vehicle_type_family ) )
	    {
	        if ( ! p_info [ playerid ] [ family_quest_progress ] )
	        {
				is_leave_quest_vehicle { playerid } = 60 ;
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас есть {"#cRD"}60 секунд{"#cGRInfo"} для возврата в транспорт." ) ;
				GameTextForPlayer ( playerid, "~r~60", 5000, 6 ) ;
			}
	    }
	}
	return 1 ;
}

callback: load_family_vehicles ( _fam_id )
{
	new fields, rows, time = GetTickCount ( ) ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		new unix_time = gettime ( ) ;
		for ( new i = 0 ; i < rows ; i ++ )
		{
		    new veh_id = GetVehicleID ( ) ;

			veh_info [ veh_id - 1 ] [ v_id ] = cache_get_field_content_int ( i, "sv_id", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_model ] = cache_get_field_content_int ( i, "sv_model", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_type ] = cache_get_field_content_int ( i, "sv_type", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_owner ] = cache_get_field_content_int ( i, "sv_owner", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_owner_fam ] = cache_get_field_content_int ( i, "v_owner_fam", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_color ] [ 0 ] = cache_get_field_content_int ( i, "sv_color_1", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_color ] [ 1 ] = cache_get_field_content_int ( i, "sv_color_2", sql_connection ) ;

			veh_info [ veh_id - 1 ] [ v_paint ] = cache_get_field_content_int ( i, "sv_paint", sql_connection ) ;

			veh_info [ veh_id - 1 ] [ v_plate_type ] = cache_get_field_content_int ( i, "v_plate_type", sql_connection ) ;
			cache_get_field_content ( i, "v_plate", veh_info [ veh_id - 1 ] [ v_plate ], sql_connection, 32 ) ;
			cache_get_field_content ( i, "v_region", veh_info [ veh_id - 1 ] [ v_region ], sql_connection, 10 ) ;
			
			veh_info [ veh_id - 1 ] [ v_fuel ] = cache_get_field_content_float ( i,"sv_fuel", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_millage ] = cache_get_field_content_float ( i,"sv_millage", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_rank ] = cache_get_field_content_int ( i, "sv_rank", sql_connection ) ;

			veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ] = cache_get_field_content_float ( i,"sv_pos_x", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ] = cache_get_field_content_float ( i,"sv_pos_y", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] = cache_get_field_content_float ( i,"sv_pos_z", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] = cache_get_field_content_float ( i,"sv_pos_a", sql_connection ) ;
			
			veh_info [ veh_id - 1 ] [ v_vw ] = cache_get_field_content_int ( i, "v_vw", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_int ] = cache_get_field_content_int ( i, "v_int", sql_connection ) ;
			
			veh_info [ veh_id - 1 ] [ v_engine_boost ] = cache_get_field_content_float ( i, "sv_engine_boost", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_brake_boost ] = cache_get_field_content_float ( i, "sv_brake_boost", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_stability_boost ] = cache_get_field_content_float ( i, "sv_stability_boost", sql_connection ) ;

			new sscanf_delimit [ 126 ] ;
			cache_get_field_content ( i, "v_eng_details", sscanf_delimit, sql_connection, 16 ) ;
			sscanf ( sscanf_delimit, "p<|>ddddd", veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 1 ],
			veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 3 ], veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 4 ]	) ;

			cache_get_field_content ( i, "v_brake_details", sscanf_delimit, sql_connection, 16 ) ;
			sscanf ( sscanf_delimit, "p<|>ddddd", veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 1 ],
			veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 3 ], veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 4 ]	) ;

			cache_get_field_content ( i, "v_stab_details", sscanf_delimit, sql_connection, 16 ) ;
			sscanf ( sscanf_delimit, "p<|>ddddd", veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 1 ],
			veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 3 ], veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 4 ]	) ;

			cache_get_field_content ( i, "v_components", sscanf_delimit, sql_connection, 126 ) ;
			sscanf ( sscanf_delimit, "p<|>dddddddddd", veh_info [ veh_id - 1 ] [ v_component ] [ 0 ], veh_info [ veh_id - 1 ] [ v_component ] [ 1 ],
			veh_info [ veh_id - 1 ] [ v_component ] [ 2 ], veh_info [ veh_id - 1 ] [ v_component ] [ 3 ], veh_info [ veh_id - 1 ] [ v_component ] [ 4 ],
			veh_info [ veh_id - 1 ] [ v_component ] [ 5 ], veh_info [ veh_id - 1 ] [ v_component ] [ 6 ], veh_info [ veh_id - 1 ] [ v_component ] [ 7 ],
			veh_info [ veh_id - 1 ] [ v_component ] [ 8 ], veh_info [ veh_id - 1 ] [ v_component ] [ 9 ] ) ;
			
			veh_info [ veh_id - 1 ] [ v_pantera_strobs ] = cache_get_field_content_int ( i, "v_pantera_strobs", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_alarm ] = cache_get_field_content_int ( i, "v_pantera_alarm", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_engine ] = cache_get_field_content_int ( i, "v_pantera_engine", sql_connection ) ;
			
			veh_info [ veh_id - 1 ] [ v_pantera_radar ] = cache_get_field_content_int ( i, "v_pantera_radar", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_rdate ] = cache_get_field_content_int ( i, "v_pantera_rdate", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_pantera_rdate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_pantera_radar ] )
			{
			    veh_info [ veh_id - 1 ] [ v_pantera_rdate ] =
			    veh_info [ veh_id - 1 ] [ v_pantera_radar ] = 0 ;

			    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `v_pantera_rdate` = '0', `v_pantera_radar` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, sscanf_delimit ) ;
			}

			veh_info [ veh_id - 1 ] [ v_pantera_gps ] = cache_get_field_content_int ( i, "v_pantera_gps", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_gdate ] = cache_get_field_content_int ( i, "v_pantera_gdate", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_pantera_gdate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_pantera_gps ] )
			{
			    veh_info [ veh_id - 1 ] [ v_pantera_gdate ] =
			    veh_info [ veh_id - 1 ] [ v_pantera_gps ] = 0 ;

			    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `v_pantera_gdate` = '0', `v_pantera_gps` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, sscanf_delimit ) ;
			}

			veh_info [ veh_id - 1 ] [ v_pantera_armour ] = cache_get_field_content_int ( i, "v_pantera_armour", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_adate ] = cache_get_field_content_int ( i, "v_pantera_adate", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_pantera_adate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_pantera_armour ] )
			{
			    veh_info [ veh_id - 1 ] [ v_pantera_adate ] =
			    veh_info [ veh_id - 1 ] [ v_pantera_armour ] = 0 ;

			    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `v_pantera_adate` = '0', `v_pantera_armour` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, sscanf_delimit ) ;
			}

			veh_info [ veh_id - 1 ] [ v_pantera_launch ] = cache_get_field_content_int ( i, "v_pantera_launch", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_ldate ] = cache_get_field_content_int ( i, "v_pantera_ldate", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_pantera_ldate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_pantera_launch ] == 1 )
			{
			    veh_info [ veh_id - 1 ] [ v_pantera_ldate ] =
			    veh_info [ veh_id - 1 ] [ v_pantera_launch ] = 0 ;

			    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `v_pantera_ldate` = '0', `v_pantera_launch` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, sscanf_delimit ) ;
			}
			
			veh_info [ veh_id - 1 ] [ v_sound ] = cache_get_field_content_int ( i, "v_sound", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_pantera_sdate ] = cache_get_field_content_int ( i, "v_pantera_sdate", sql_connection ) ;
			if ( veh_info [ veh_id - 1 ] [ v_pantera_sdate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_sound ] == 1 )
			{
			    veh_info [ veh_id - 1 ] [ v_sound ] =
			    veh_info [ veh_id - 1 ] [ v_pantera_sdate ] = 0 ;

			    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `v_sound` = '0', `v_pantera_sdate` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, sscanf_delimit ) ;
			}
			
			sscanf_delimit [ 0 ] = EOS ;
			cache_get_field_content ( i, "v_suspension", sscanf_delimit, sql_connection, 20 ) ;
			sscanf ( sscanf_delimit, "p<|>ff", veh_info [ veh_id - 1 ] [ v_suspension ] [ 0 ], veh_info [ veh_id - 1 ] [ v_suspension ] [ 1 ] ) ;

			veh_info [ veh_id - 1 ] [ v_wheel_size ] = cache_get_field_content_float ( i, "v_wheel_size", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_wheel_width ] = cache_get_field_content_int ( i, "v_wheel_width", sql_connection ) ;

			cache_get_field_content ( i, "v_wheel_alignment", sscanf_delimit, sql_connection, 20 ) ;
			sscanf ( sscanf_delimit, "p<|>dd", veh_info [ veh_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ veh_id - 1 ] [ v_wheel_alignment ] [ 1 ] ) ;

			cache_get_field_content ( i, "v_wheel_offset", sscanf_delimit, sql_connection, 20 ) ;
			sscanf ( sscanf_delimit, "p<|>dd", veh_info [ veh_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ veh_id - 1 ] [ v_wheel_offset ] [ 1 ] ) ;

			veh_info [ veh_id - 1 ] [ v_lights_color ] = cache_get_field_content_int ( i, "v_lights_color", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_neon ] = cache_get_field_content_int ( i, "v_neon", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_neon_type ] = cache_get_field_content_int ( i, "v_neon_type", sql_connection ) ;
			
			cache_get_field_content ( i, "v_toner", sscanf_delimit, sql_connection, 20 ) ;
			sscanf ( sscanf_delimit, "p<|>dddd", veh_info [ veh_id - 1 ] [ v_toner ] [ 0 ], veh_info [ veh_id - 1 ] [ v_toner ] [ 1 ], veh_info [ veh_id - 1 ] [ v_toner ] [ 2 ], veh_info [ veh_id - 1 ] [ v_toner ] [ 3 ] ) ;

			veh_info [ veh_id - 1 ] [ v_vinyl ] = cache_get_field_content_int ( i, "v_vinyl", sql_connection ) ;
			
			veh_info [ veh_id - 1 ] [ v_stage_speed ] = cache_get_field_content_int ( i, "v_stage_speed", sql_connection ) ;
			veh_info [ veh_id - 1 ] [ v_stage_brake ] = cache_get_field_content_int ( i, "v_stage_brake", sql_connection ) ;
			
            veh_info [ veh_id - 1 ] [ v_key ] = 1 ;
			veh_info [ veh_id - 1 ] [ v_locked ] = false ;
			veh_info [ veh_id - 1 ] [ v_fuel ] = 35.0 ;

			veh_info [ veh_id - 1 ] [ v_vehicle ] = CreateVehicle ( veh_info [ veh_id - 1 ] [ v_model ], veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ], veh_info [ veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ veh_id - 1 ] [ v_color ] [ 1 ], SPAWN_TIME_FAMILY_VEHICLE ) ;
			SetVehicleNumberPlate ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_plate ] ) ;
			
			if ( veh_info [ veh_id - 1 ] [ v_int ] != 0 )LinkVehicleToInterior ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_int ] ) ;
			if ( veh_info [ veh_id - 1 ] [ v_vw ] != 0 )SetVehicleVirtualWorld ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_vw ] ) ;

			if ( veh_info [ veh_id - 1 ] [ v_paint ] != 3 )
			{
				ChangeVehiclePaintjob ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_paint ] ) ;
			}

            for ( new j = 0; j < 10; j ++ )
			{
			    if ( veh_info [ veh_id - 1 ] [ v_component ] [ j ] == 0 ) continue ;
				AddVehicleComponent ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_component ] [ j ] ) ;
			}

			veh_plate ( veh_id ) ;
			veh_info [ veh_id - 1 ] [ v_trunk_open ] = false ;
			veh_info [ veh_id - 1 ] [ v_trunk_load ] = false ;
			
			veh_info [ veh_id - 1 ] [ v_price ] = cache_get_field_content_int ( i, "sv_price", sql_connection ) ;

			Iter_Add(family_vehicles[veh_info [ veh_id - 1 ] [ v_owner ]], veh_info [ veh_id - 1 ] [ v_vehicle ] ) ;
		}
	}

	printf ( "[SERVER] Загружено %d автомобилей семьи. (%d ms)", rows, GetTickCount ( ) - time ) ;
   	return 1 ;
}

stock fam_td_status ( playerid, bool: status )
{
	if ( status )
	{
   		family_ptd[playerid][0] = CreatePlayerTextDraw(playerid, 71.0336, 245.1704, "00:00"); // 1 Box ( Time )
		PlayerTextDrawLetterSize(playerid, family_ptd[playerid][0], 0.1748, 0.7578);
		PlayerTextDrawTextSize(playerid, family_ptd[playerid][0], 0.0000, 14.0000);
		PlayerTextDrawAlignment(playerid, family_ptd[playerid][0], 2);
		PlayerTextDrawColor(playerid, family_ptd[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, family_ptd[playerid][0], 255);
		PlayerTextDrawFont(playerid, family_ptd[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, family_ptd[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, family_ptd[playerid][0], 0);

		family_ptd[playerid][1] = CreatePlayerTextDraw(playerid, 40.0342, 226.9185, "East_Side_Ballas"); // 1 Box ( Left Gang )
		PlayerTextDrawLetterSize(playerid, family_ptd[playerid][1], 0.1748, 0.7578);
		PlayerTextDrawTextSize(playerid, family_ptd[playerid][1], 0.0000, 38.0000);
		PlayerTextDrawAlignment(playerid, family_ptd[playerid][1], 2);
		PlayerTextDrawColor(playerid, family_ptd[playerid][1], -1061109505);
		PlayerTextDrawUseBox(playerid, family_ptd[playerid][1], 1);
		PlayerTextDrawBoxColor(playerid, family_ptd[playerid][1], color_box);
		PlayerTextDrawBackgroundColor(playerid, family_ptd[playerid][1], 255);
		PlayerTextDrawFont(playerid, family_ptd[playerid][1], 1);
		PlayerTextDrawSetProportional(playerid, family_ptd[playerid][1], 1);
		PlayerTextDrawSetShadow(playerid, family_ptd[playerid][1], 0);

		family_ptd[playerid][2] = CreatePlayerTextDraw(playerid, 102.3333, 226.9185, "East_Side_Ballas"); // 1 Box ( Right Gang )
		PlayerTextDrawLetterSize(playerid, family_ptd[playerid][2], 0.1748, 0.7578);
		PlayerTextDrawTextSize(playerid, family_ptd[playerid][2], 0.0000, 38.0000);
		PlayerTextDrawAlignment(playerid, family_ptd[playerid][2], 2);
		PlayerTextDrawColor(playerid, family_ptd[playerid][2], -1061109505);
		PlayerTextDrawUseBox(playerid, family_ptd[playerid][2], 1);
		PlayerTextDrawBoxColor(playerid, family_ptd[playerid][2], color_box);
		PlayerTextDrawBackgroundColor(playerid, family_ptd[playerid][2], 255);
		PlayerTextDrawFont(playerid, family_ptd[playerid][2], 1);
		PlayerTextDrawSetProportional(playerid, family_ptd[playerid][2], 1);
		PlayerTextDrawSetShadow(playerid, family_ptd[playerid][2], 0);

		family_ptd[playerid][3] = CreatePlayerTextDraw(playerid, 27.4342, 245.1704, "100"); // 1 Box ( Left Gang )
		PlayerTextDrawLetterSize(playerid, family_ptd[playerid][3], 0.1748, 0.7578);
		PlayerTextDrawTextSize(playerid, family_ptd[playerid][3], 0.0000, 14.0000);
		PlayerTextDrawAlignment(playerid, family_ptd[playerid][3], 2);
		PlayerTextDrawColor(playerid, family_ptd[playerid][3], -1);
		PlayerTextDrawUseBox(playerid, family_ptd[playerid][3], 1);
		PlayerTextDrawBoxColor(playerid, family_ptd[playerid][3], color_textdraw);
		PlayerTextDrawBackgroundColor(playerid, family_ptd[playerid][3], 255);
		PlayerTextDrawFont(playerid, family_ptd[playerid][3], 1);
		PlayerTextDrawSetProportional(playerid, family_ptd[playerid][3], 1);
		PlayerTextDrawSetShadow(playerid, family_ptd[playerid][3], 0);

		family_ptd[playerid][4] = CreatePlayerTextDraw(playerid, 114.6675, 245.2704, "100"); // 1 Box ( Right Gang )
		PlayerTextDrawLetterSize(playerid, family_ptd[playerid][4], 0.1748, 0.7578);
		PlayerTextDrawTextSize(playerid, family_ptd[playerid][4], 0.0000, 14.0000);
		PlayerTextDrawAlignment(playerid, family_ptd[playerid][4], 2);
		PlayerTextDrawColor(playerid, family_ptd[playerid][4], -1);
		PlayerTextDrawUseBox(playerid, family_ptd[playerid][4], 1);
		PlayerTextDrawBoxColor(playerid, family_ptd[playerid][4], color_textdraw);
		PlayerTextDrawBackgroundColor(playerid, family_ptd[playerid][4], 255);
		PlayerTextDrawFont(playerid, family_ptd[playerid][4], 1);
		PlayerTextDrawSetProportional(playerid, family_ptd[playerid][4], 1);
		PlayerTextDrawSetShadow(playerid, family_ptd[playerid][4], 0);
		
		new _string [ 64 ] ;
		PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 0 ], "TIME:_07:00" ) ;
		
		format ( _string, sizeof _string, "%s", family_info [ family_wars [ zones_captured ] [ gz_owner ] - 1 ] [ fam_name ] ) ;
		PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 1 ], _string ) ;
		
		format ( _string, sizeof _string, "%s", family_info [ family_wars [ zones_captured ] [ gz_attacker ] - 1 ] [ fam_name ] ) ;
		PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 2 ], _string ) ;

		format ( _string, sizeof _string, "%d", zones_owner_points ) ;
		PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 3 ], _string ) ;

		format ( _string, sizeof _string, "%d", zones_attacker_points ) ;
		PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 4 ], _string ) ;

		if ( p_info [ playerid ] [ family_status ] > 1 )
		{
   			family_ptd[playerid][5] = CreatePlayerTextDraw(playerid, 30.1009, 276.4188, "K:_0"); // 2 Box ( Kills )
			PlayerTextDrawLetterSize(playerid, family_ptd[playerid][5], 0.1748, 0.7578);
			PlayerTextDrawTextSize(playerid, family_ptd[playerid][5], 0.0000, 20.0000);
			PlayerTextDrawAlignment(playerid, family_ptd[playerid][5], 2);
			PlayerTextDrawColor(playerid, family_ptd[playerid][5], -1);
			PlayerTextDrawUseBox(playerid, family_ptd[playerid][5], 1);
			PlayerTextDrawBoxColor(playerid, family_ptd[playerid][5], color_textdraw);
			PlayerTextDrawBackgroundColor(playerid, family_ptd[playerid][5], 255);
			PlayerTextDrawFont(playerid, family_ptd[playerid][5], 1);
			PlayerTextDrawSetProportional(playerid, family_ptd[playerid][5], 1);
			PlayerTextDrawSetShadow(playerid, family_ptd[playerid][5], 0);

			family_ptd[playerid][6] = CreatePlayerTextDraw(playerid, 111.4676, 276.4188, "D:_0"); // 2 Box ( Damage )
			PlayerTextDrawLetterSize(playerid, family_ptd[playerid][6], 0.1748, 0.7578);
			PlayerTextDrawTextSize(playerid, family_ptd[playerid][6], 0.0000, 20.0000);
			PlayerTextDrawAlignment(playerid, family_ptd[playerid][6], 2);
			PlayerTextDrawColor(playerid, family_ptd[playerid][6], -1);
			PlayerTextDrawUseBox(playerid, family_ptd[playerid][6], 1);
			PlayerTextDrawBoxColor(playerid, family_ptd[playerid][6], color_textdraw);
			PlayerTextDrawBackgroundColor(playerid, family_ptd[playerid][6], 255);
			PlayerTextDrawFont(playerid, family_ptd[playerid][6], 1);
			PlayerTextDrawSetProportional(playerid, family_ptd[playerid][6], 1);
			PlayerTextDrawSetShadow(playerid, family_ptd[playerid][6], 0);

			family_ptd[playerid][7] = CreatePlayerTextDraw(playerid, 71.0336, 276.5723, "K/D:_0.00"); // 2 Box ( K/D Ratio )
			PlayerTextDrawLetterSize(playerid, family_ptd[playerid][7], 0.1748, 0.7578);
			PlayerTextDrawTextSize(playerid, family_ptd[playerid][7], 0.0000, 14.0000);
			PlayerTextDrawAlignment(playerid, family_ptd[playerid][7], 2);
			PlayerTextDrawColor(playerid, family_ptd[playerid][7], -1);
			PlayerTextDrawBackgroundColor(playerid, family_ptd[playerid][7], 255);
			PlayerTextDrawFont(playerid, family_ptd[playerid][7], 1);
			PlayerTextDrawSetProportional(playerid, family_ptd[playerid][7], 1);
			PlayerTextDrawSetShadow(playerid, family_ptd[playerid][7], 0);
			
			format ( _string, sizeof _string, "%d", p_info [ playerid ] [ family_kills ] ) ;
			PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 5 ], _string ) ;
			
			format ( _string, sizeof _string, "%.2f", p_info [ playerid ] [ family_damage ] ) ;
			PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 6 ], _string ) ;
			
			if ( ! p_info [ playerid ] [ family_kills ] || ! p_info [ playerid ] [ family_death ] ) format ( _string, sizeof _string, "K/D:_0.00" ) ;
			else format ( _string, sizeof _string, "K/D:_%.2f", floatdiv ( p_info [ playerid ] [ family_kills ], p_info [ playerid ] [ family_death ] ) ) ;
			PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 7 ], _string ) ;
		}

        if ( p_info [ playerid ] [ family_status ] > 2 )
		{
   			family_ptd[playerid][8] = CreatePlayerTextDraw(playerid, 15.8332, 308.2572, "PLAYER_1"); // 3 Box ( Left Player )
			PlayerTextDrawLetterSize(playerid, family_ptd[playerid][8], 0.1636, 0.7869);
			PlayerTextDrawAlignment(playerid, family_ptd[playerid][8], 1);
			PlayerTextDrawColor(playerid, family_ptd[playerid][8], -1061109505);
			PlayerTextDrawBackgroundColor(playerid, family_ptd[playerid][8], 49);
			PlayerTextDrawFont(playerid, family_ptd[playerid][8], 1);
			PlayerTextDrawSetProportional(playerid, family_ptd[playerid][8], 1);
			PlayerTextDrawSetShadow(playerid, family_ptd[playerid][8], 1);

			family_ptd[playerid][9] = CreatePlayerTextDraw(playerid, 127.0330, 308.2573, "PLAYER_2"); // 3 Box ( Right Player )
			PlayerTextDrawLetterSize(playerid, family_ptd[playerid][9], 0.1636, 0.7869);
			PlayerTextDrawAlignment(playerid, family_ptd[playerid][9], 3);
			PlayerTextDrawColor(playerid, family_ptd[playerid][9], -1061109505);
			PlayerTextDrawBackgroundColor(playerid, family_ptd[playerid][9], 49);
			PlayerTextDrawFont(playerid, family_ptd[playerid][9], 1);
			PlayerTextDrawSetProportional(playerid, family_ptd[playerid][9], 1);
			PlayerTextDrawSetShadow(playerid, family_ptd[playerid][9], 1);
			
			format ( _string, sizeof _string, "%s", zones_kills_first_name ) ;
			PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 8 ], _string ) ;
			
			format ( _string, sizeof _string, "%s", zones_kills_two_name ) ;
			PlayerTextDrawSetString ( playerid, family_ptd [ playerid ] [ 9 ], _string ) ;
		}
		
		for ( new i = 0 ; i < 38 ; i ++ )
		{
		    if ( p_info [ playerid ] [ family_status ] == 2 )
		    {
		        if ( i < 32 ) TextDrawShowForPlayer ( playerid, family_td [ i ] ) ;
		        if ( i < 8 ) PlayerTextDrawShow ( playerid, family_ptd [ playerid ] [ i ] ) ;
		    }
		    else if ( p_info [ playerid ] [ family_status ] == 3 )
		    {
		        TextDrawShowForPlayer ( playerid, family_td [ i ] ) ;
		        if ( i < 10 ) PlayerTextDrawShow ( playerid, family_ptd [ playerid ] [ i ] ) ;
		    }
		    else
		    {
		        if ( i < 26 ) TextDrawShowForPlayer ( playerid, family_td [ i ] ) ;
		        if ( i < 5 ) PlayerTextDrawShow ( playerid, family_ptd [ playerid ] [ i ] ) ;
		    }
		}
	}
	else
	{
	    for ( new i = 0 ; i < 38 ; i ++ )
		{
		    if ( p_info [ playerid ] [ family_status ] == 2 )
		    {
		        if ( i < 32 ) TextDrawHideForPlayer ( playerid, family_td [ i ] ) ;
		        if ( i < 8 )
			    {
					PlayerTextDrawDestroy ( playerid, family_ptd [ playerid ] [ i ] ) ;
					family_ptd [ playerid ] [ i ] = PlayerText:-1;
				}
		    }
		    else if ( p_info [ playerid ] [ family_status ] == 3 )
		    {
		        TextDrawHideForPlayer ( playerid, family_td [ i ] ) ;
		        if ( i < 10 )
			    {
					PlayerTextDrawDestroy ( playerid, family_ptd [ playerid ] [ i ] ) ;
					family_ptd [ playerid ] [ i ] = PlayerText:-1;
				}
		    }
		    else
		    {
		        if ( i < 26 ) TextDrawHideForPlayer ( playerid, family_td [ i ] ) ;
		        if ( i < 5 )
			    {
					PlayerTextDrawDestroy ( playerid, family_ptd [ playerid ] [ i ] ) ;
					family_ptd [ playerid ] [ i ] = PlayerText:-1;
				}
		    }
		}
	}
	return 1 ;
}

callback: familywars_timer ( gz_tid, gz_attacker_team, gz_owner_team, capture_type )
{
	new td_string [ 48 ] ;
	format ( td_string, sizeof ( td_string ), "%s", convert_time ( family_wars [ gz_tid ] [ gz_time ], TYPE_TIME_SECOND ) ) ;
	foreach(new pl_id: logged_players)
	{
		if ( ! p_info [ pl_id ] [ family ] && fam_td_status_bool [ pl_id ] == true )
		{
			fam_td_status ( pl_id, false ) ;
			fam_td_status_bool [ pl_id ] = false ;
			for ( new j = 0 ; j < 5 ; j ++ ) SendDeathMessageToPlayer ( pl_id, 1001, 1001, 200 ) ;
		}
		else if ( p_info [ pl_id ] [ family ] && fam_td_status_bool [ pl_id ] == false )
		{
		    p_info [ pl_id ] [ family_kills ] =
			p_info [ pl_id ] [ family_death ] = 0 ;
    		p_info [ pl_id ] [ family_damage ] = 0.0 ;
		
			fam_td_status ( pl_id, true ) ;
			GangZoneFlashForPlayer ( pl_id, family_wars [ gz_tid ] [ gz_created ], 0x000000AA ) ; // family_info [ gz_attacker_team - 1 ] [ fam_zone_color ]
			fam_td_status_bool [ pl_id ] = true ;
		}
		
		if ( p_info [ pl_id ] [ family ] && fam_td_status_bool [ pl_id ] == true )
		{
		    if ( family_wars [ gz_tid ] [ gz_time ] >= 1 ) PlayerTextDrawSetString ( pl_id, family_ptd [ pl_id ] [ 0 ], td_string ) ;
		}
	}
	if ( family_wars [ gz_tid ] [ gz_time ] > 1 ) family_wars [ gz_tid ] [ gz_time ] -- ;
	else if ( family_wars [ gz_tid ] [ gz_time ] == 1 )
	{
		if ( zones_owner_points < 1 && zones_attacker_points < 1 )
		{
			new _count_attacker = 0 ;
			foreach(new q: family_players[gz_attacker_team])
			{
				if ( IsPlayerInFamilyZone ( q, zones_captured ) && p_info [ q ] [ hour_played ] > 3 )
				{
					p_info [ q ] [ fam_captured ] ++ ;
					_count_attacker ++ ;
				}
			}
			
			new _count_defender = 0 ;
			foreach(new q: family_players[gz_owner_team])
			{
				if ( IsPlayerInFamilyZone ( q, zones_captured ) && p_info [ q ] [ hour_played ] > 3 )
				{
					p_info [ q ] [ fam_captured ] ++ ;
					_count_defender ++ ;
				}
			}
			
			if ( _count_defender >= _count_attacker )
			{
				new _string [ 128 ] ;
				format ( _string, sizeof ( _string ), "[U-FAM] '%s' отстояла свою территорию.",
				family_info [ family_wars [ gz_tid ] [ gz_owner ] - 1 ] [ fam_name ] ) ;
				foreach(new i: logged_players) if ( p_info [ i ] [ family ] ) SendClientMessage ( i, col_fam_alliance, _string ) ;
			}
			else
			{
				new _string [ 128 ] ;
				format ( _string, sizeof ( _string ), "[U-FAM] '%s' захватила территорию у '%s'.",
				family_info [ family_wars [ gz_tid ] [ gz_attacker ] - 1 ] [ fam_name ],
				family_info [ family_wars [ gz_tid ] [ gz_owner ] - 1 ] [ fam_name ] ) ;
				foreach(new i: logged_players) if ( p_info [ i ] [ family ] ) SendClientMessage ( i, col_fam_alliance, _string ) ;

				family_info [ gz_attacker_team - 1 ] [ fam_zones ] ++ ;
				update_fdorm_text ( gz_attacker_team ) ;
				
				family_info [ gz_owner_team - 1 ] [ fam_zones ] -- ;
				update_fdorm_text ( gz_owner_team ) ;
				
				family_info [ gz_attacker_team - 1 ] [ fam_rating ] += 5 ;
				give_all_family_quest ( gz_attacker_team, 6, 5 ) ;
				give_all_family_quest ( gz_attacker_team, 7, 5 ) ;
				give_all_family_quest ( gz_attacker_team, 8, 5 ) ;

				family_wars [ gz_tid ] [ gz_owner ] = family_wars [ gz_tid ] [ gz_attacker ] ;
				update_famzones_label ( gz_tid, family_wars [ gz_tid ] [ gz_owner ] ) ;
			}
		}
		else if ( zones_owner_points >= zones_attacker_points ) // победа хозяев
		{
			new _string [ 128 ] ;
			format ( _string, sizeof ( _string ), "[U-FAM] '%s' отстояла свою территорию.",
			family_info [ family_wars [ gz_tid ] [ gz_owner ] - 1 ] [ fam_name ] ) ;
			foreach(new i: logged_players) if ( p_info [ i ] [ family ] ) SendClientMessage ( i, col_fam_alliance, _string ) ;
		}
		else if ( zones_owner_points < zones_attacker_points ) // победа атаки
		{
			new _string [ 128 ] ;
			format ( _string, sizeof ( _string ), "[U-FAM] '%s' захватила территорию у '%s'.",
			family_info [ family_wars [ gz_tid ] [ gz_attacker ] - 1 ] [ fam_name ],
			family_info [ family_wars [ gz_tid ] [ gz_owner ] - 1 ] [ fam_name ] ) ;
			foreach(new i: logged_players) if ( p_info [ i ] [ family ] ) SendClientMessage ( i, col_fam_alliance, _string ) ;

			family_info [ gz_attacker_team - 1 ] [ fam_zones ] ++ ;
			update_fdorm_text ( gz_attacker_team ) ;
			
			family_info [ gz_owner_team - 1 ] [ fam_zones ] -- ;
			update_fdorm_text ( gz_owner_team ) ;
			
			family_info [ gz_attacker_team - 1 ] [ fam_rating ] += 5 ;
			give_all_family_quest ( gz_attacker_team, 6, 5 ) ;
			give_all_family_quest ( gz_attacker_team, 7, 5 ) ;
			give_all_family_quest ( gz_attacker_team, 8, 5 ) ;

			family_wars [ gz_tid ] [ gz_owner ] = family_wars [ gz_tid ] [ gz_attacker ] ;
			update_famzones_label ( gz_tid, family_wars [ gz_tid ] [ gz_owner ] ) ;
		}
		
		foreach(new i: logged_players)
		{
			if ( fam_td_status_bool [ i ] == true )
			{
				fam_td_status ( i, false ) ;
				fam_td_status_bool [ i ] = false ;
				for ( new j = 0 ; j < 5 ; j ++ ) SendDeathMessageToPlayer ( i, 1001, 1001, 200 ) ;
			}
			p_info [ i ] [ family_kills ] =
			p_info [ i ] [ family_death ] = 0 ;
		    p_info [ i ] [ family_damage ] = 0.0 ;
		}

		KillTimer ( family_wars [ gz_tid ] [ gz_timer ] ) ;

		zones_captured =
		zones_owner_points =
		zones_attacker_points = -1 ;

		family_wars [ gz_tid ] [ gz_time ] =
		family_wars [ gz_tid ] [ gz_attacker ] = 0 ;

		GangZoneStopFlashForAll( family_wars [ gz_tid ] [ gz_created ] ) ;
		GangZoneHideForAll ( family_wars [ gz_tid ] [ gz_created ] ) ;
		GangZoneShowForAll ( family_wars [ gz_tid ] [ gz_created ], GetFamilyZoneColor ( family_wars [ gz_tid ] [ gz_owner ] ) ) ;
		SaveFamilyZone ( gz_tid ) ;
	}
	return 1 ;
}

stock update_famzones_label ( _zone_id, _family_id )
{
	new scm_string [ 168 ] ;
	format ( scm_string, sizeof scm_string, "** %s **\n\n{"#cWH3D"}Под контролем: {%s}%s\n{"#cWH3D"}Талонов в час: {"#cOR3D"}%d шт.\n{"#cWH3D"}Денег в час: {"#cOR3D"}%s"valute_title_"", 
											family_wars [ _zone_id ] [ gz_name ], 
											family_info [ _family_id - 1 ] [ fam_chat_color ], 
											family_info [ _family_id - 1 ] [ fam_name ],
											family_wars [ _zone_id ] [ gz_hour_talon ],
											GetPlayerCashValueToSmile ( family_wars [ _zone_id ] [ gz_hour_money ] ) ) ;
	UpdateDynamic3DTextLabelText ( family_wars [ _zone_id ] [ gz_label ], col_blue, scm_string ) ;
	return 1 ;
}

stock GetFamilyZoneColor ( familyid )
{
	if ( familyid == 0 )return 0xFFFFFF55 ;
	else return family_info [ familyid - 1 ] [ fam_zone_color ] ;
}

stock IsPlayerInFamilyZone ( playerid, familyzoneid )
{
	new Float:pos_x,
		Float:pos_y,
		Float:pos_z ;

	GetPlayerPos ( playerid, pos_x, pos_y, pos_z ) ;
	if ( pos_x >= family_wars [ familyzoneid ] [ gz_pos ] [ 0 ] && pos_x <= family_wars [ familyzoneid ] [ gz_pos ] [ 2 ] && pos_y >= family_wars [ familyzoneid ] [ gz_pos ] [ 1 ] && pos_y <= family_wars [ familyzoneid ] [ gz_pos ] [ 3 ] ) return 1 ;
	else return 0 ;
}

stock SaveFamilyZone ( familyzoneid )
{
	family_wars [ familyzoneid ] [ gz_last_capture ] = gettime ( ) ;

	global_string [ 0 ] = EOS ;
    format ( global_string, 130, "UPDATE `familyzones` SET `gz_owner` = '%d', `gz_last_capture` = '%d' WHERE `gz_id` = '%d' LIMIT 1", 
	family_wars [ familyzoneid ] [ gz_owner ], family_wars [ familyzoneid ] [ gz_last_capture ], family_wars [ familyzoneid ] [ gz_id ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;
	return 1 ;
}

stock familywar_quit ( playerid, reason_quit )
{
    if ( zones_captured != -1 && reason_quit != 0 )
	{
	    if ( ! p_info [ playerid ] [ family ] ) return 1 ;
	    if ( p_t_info [ playerid ] [ last_time_damage ] < gettime ( ) ) return 1 ;
		if ( ( IsPlayerInFamilyZone ( playerid, zones_captured ) || ( IsPlayerInRangeOfQuad ( playerid, family_wars [ zones_captured ] [ gz_pos ] [ 2 ], family_wars [ zones_captured ] [ gz_pos ] [ 3 ] ) < 200 || IsPlayerInRangeOfQuad ( playerid, family_wars [ zones_captured ] [ gz_pos ] [ 0 ], family_wars [ zones_captured ] [ gz_pos ] [ 1 ] ) < 200 ) ) )
		{
			new _family_id = p_info [ playerid ] [ family ] ;
			new _gz_attacker = family_wars [ zones_captured ] [ gz_attacker ] ;
			new _gz_owner = family_wars [ zones_captured ] [ gz_owner ] ;
   			if ( _family_id == _gz_attacker || _family_id == _gz_owner ||
				family_diplomacy [ _family_id ] [ _gz_attacker ] == dip_status_alliance && family_diplomacy [ _family_id ] [ _gz_owner ] == dip_status_war ||
				family_diplomacy [ _family_id ] [ _gz_owner ] == dip_status_alliance && family_diplomacy [ _family_id ] [ _gz_attacker ] == dip_status_war )
   			{
   			    new score_kill ;
				switch ( p_t_info [ playerid ] [ last_gun_damage ] )
				{
					case 0 									: score_kill += 5 ;
					case 22, 23 							: score_kill += 4 ;
					case 5, 6, 7, 10, 11, 12, 13, 14, 15	: score_kill += 10 ;
					default 								: score_kill += 1 ;
				}

				new scm_string [ 144 ], td_string [ 48 ] ;
   			    if ( _family_id == _gz_attacker )
				{
				    zones_owner_points += score_kill ;

					format ( scm_string, sizeof scm_string, "[U-FAM] %s [%s] покинул(а) поле боя (+%d очков для %s). Счёт: %s [%d] : [%d] %s",
					p_info [ playerid ] [ name ], family_info [ _gz_attacker - 1 ] [ fam_name ],
					score_kill, family_info [ _gz_owner - 1 ] [ fam_name ],
					family_info [ _gz_attacker - 1 ] [ fam_name ], zones_attacker_points,
					zones_owner_points, family_info [ _gz_owner - 1 ] [ fam_name ] ) ;
				}
				
				else if ( _family_id == _gz_owner )
				{
				    zones_attacker_points += score_kill ;

					format ( scm_string, sizeof scm_string, "[U-FAM] %s [%s] покинул(а) поле боя (+%d очков для %s). Счёт: %s [%d] : [%d] %s",
					p_info [ playerid ] [ name ], family_info [ _gz_owner - 1 ] [ fam_name ],
					score_kill, family_info [ _gz_attacker - 1 ] [ fam_name ],
					family_info [ _gz_attacker - 1 ] [ fam_name ], zones_attacker_points,
					zones_owner_points, family_info [ _gz_owner - 1 ] [ fam_name ] ) ;
				}
				
				else if ( family_diplomacy [ _family_id ] [ _gz_attacker ] == dip_status_alliance  )
				{
				    zones_owner_points += score_kill ;

					format ( scm_string, sizeof scm_string, "[U-FAM] %s [Альянс с %s] покинул(а) поле боя (+%d очков для %s). Счёт: %s [%d] : [%d] %s",
					p_info [ playerid ] [ name ], family_info [ _gz_attacker - 1 ] [ fam_name ],
					score_kill, family_info [ _gz_owner - 1 ] [ fam_name ],
					family_info [ _gz_attacker - 1 ] [ fam_name ], zones_attacker_points,
					zones_owner_points, family_info [ _gz_owner - 1 ] [ fam_name ] ) ;

				}
				
				else if ( family_diplomacy [ _family_id ] [ _gz_owner ] == dip_status_alliance )
				{
				    zones_attacker_points += score_kill ;

					format ( scm_string, sizeof scm_string, "[U-FAM] %s [Альянс с %s] покинул(а) поле боя (+%d очков для %s). Счёт: %s [%d] : [%d] %s",
					p_info [ playerid ] [ name ], family_info [ _gz_owner - 1 ] [ fam_name ],
					score_kill, family_info [ _gz_attacker - 1 ] [ fam_name ],
					family_info [ _gz_attacker - 1 ] [ fam_name ], zones_attacker_points,
					zones_owner_points, family_info [ _gz_owner - 1 ] [ fam_name ] ) ;
				}
				
				foreach(new i: logged_players)
				{
				    if ( ! p_info [ i ] [ family ] ) continue ;
					
					if ( ( ( family_diplomacy [ _gz_owner ] [ p_info [ i ] [ family ] ] == dip_status_alliance || is_control_chat { i } == _gz_owner || p_info [ i ] [ family ] == _gz_owner ) ||
					( family_diplomacy [ _gz_attacker ] [ p_info [ i ] [ family ] ] == dip_status_alliance || is_control_chat { i } == _gz_attacker || p_info [ i ] [ family ] == _gz_attacker ) ) && p_info [ i ] [ settings ] [ 0 ] != 0 ) SendClientMessage ( i, family_info [ family_wars [ zones_captured ] [ gz_owner ] - 1 ] [ fam_zone_color ], scm_string ) ;

                    format ( td_string, sizeof td_string, "%d", zones_attacker_points ) ;
					PlayerTextDrawSetString ( i, family_ptd [ i ] [ 4 ], td_string ) ;

					format ( td_string, sizeof td_string, "%d", zones_owner_points ) ;
					PlayerTextDrawSetString ( i, family_ptd [ i ] [ 3 ], td_string ) ;
				}

				format ( scm_string, sizeof ( scm_string ), "{"#cBAdmin"}[A]{"#cGRAdmin"} %s [%s] покинул(а) поле боя (на +%d очков).",
				p_info [ playerid ] [ name ], family_info [ _family_id - 1 ] [ fam_name ], score_kill ) ;
				admin_message ( 0, col_admin, scm_string ) ;
   			}
		}
	}
	return 1 ;
}

callback: create_familyvehicle_callback ( _v_id )
{
	veh_info [ _v_id - 1 ] [ v_id ] = cache_insert_id ( ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 266, "UPDATE `familys_vehicles` SET `v_components` = '%d|%d|%d|%d|%d|%d|%d|%d|%d|%d',`sv_color_1` = '%d',`sv_color_2` = '%d',`sv_paint`='%d' WHERE `sv_id` = '%d' LIMIT 1",
	veh_info [ _v_id - 1 ] [ v_component ] [ 0 ],
	veh_info [ _v_id - 1 ] [ v_component ] [ 1 ],
	veh_info [ _v_id - 1 ] [ v_component ] [ 2 ],
	veh_info [ _v_id - 1 ] [ v_component ] [ 3 ],
	veh_info [ _v_id - 1 ] [ v_component ] [ 4 ],
	veh_info [ _v_id - 1 ] [ v_component ] [ 5 ],
	veh_info [ _v_id - 1 ] [ v_component ] [ 6 ],
	veh_info [ _v_id - 1 ] [ v_component ] [ 7 ],
	veh_info [ _v_id - 1 ] [ v_component ] [ 8 ],
	veh_info [ _v_id - 1 ] [ v_component ] [ 9 ],
	veh_info [ _v_id - 1 ] [ v_color ] [ 0 ],
	veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
	veh_info [ _v_id - 1 ] [ v_paint ],
	veh_info [ _v_id - 1 ] [ v_id ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 266, "UPDATE `familys_vehicles` SET `v_eng_details` = '%d|%d|%d|%d|%d',`sv_engine_boost` = '%f' WHERE `sv_id` = '%d' LIMIT 1",
	veh_info [ _v_id - 1 ] [ v_pt_engine ] [ 0 ],
	veh_info [ _v_id - 1 ] [ v_pt_engine ] [ 1 ],
	veh_info [ _v_id - 1 ] [ v_pt_engine ] [ 2 ],
	veh_info [ _v_id - 1 ] [ v_pt_engine ] [ 3 ],
	veh_info [ _v_id - 1 ] [ v_pt_engine ] [ 4 ],
	veh_info [ _v_id - 1 ] [ v_engine_boost ],
	veh_info [ _v_id - 1 ] [ v_id ] ) ;
	mysql_tquery ( sql_connection, global_string, "", "" ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 266, "UPDATE `familys_vehicles` SET `v_brake_details` = '%d|%d|%d|%d|%d',`sv_brake_boost` = '%f' WHERE `sv_id` = '%d' LIMIT 1",
	veh_info [ _v_id - 1 ] [ v_pt_brake ] [ 0 ],
	veh_info [ _v_id - 1 ] [ v_pt_brake ] [ 1 ],
	veh_info [ _v_id - 1 ] [ v_pt_brake ] [ 2 ],
	veh_info [ _v_id - 1 ] [ v_pt_brake ] [ 3 ],
	veh_info [ _v_id - 1 ] [ v_pt_brake ] [ 4 ],
	veh_info [ _v_id - 1 ] [ v_brake_boost ],
	veh_info [ _v_id - 1 ] [ v_id ] ) ;
	mysql_tquery ( sql_connection, global_string, "", "" ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 266, "UPDATE `familys_vehicles` SET `v_stab_details` = '%d|%d|%d|%d|%d',`sv_stability_boost` = '%f' WHERE `sv_id` = '%d' LIMIT 1",
	veh_info [ _v_id - 1 ] [ v_pt_stability ] [ 0 ],
	veh_info [ _v_id - 1 ] [ v_pt_stability ] [ 1 ],
	veh_info [ _v_id - 1 ] [ v_pt_stability ] [ 2 ],
	veh_info [ _v_id - 1 ] [ v_pt_stability ] [ 3 ],
	veh_info [ _v_id - 1 ] [ v_pt_stability ] [ 4 ],
	veh_info [ _v_id - 1 ] [ v_stability_boost ],
	veh_info [ _v_id - 1 ] [ v_id ] ) ;
	mysql_tquery ( sql_connection, global_string, "", "" ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 128, "UPDATE `familys_vehicles` SET `v_pantera_rdate` = '%d', `v_pantera_radar` = '%d' WHERE `sv_id` = '%d' LIMIT 1", 
	veh_info [ _v_id - 1 ] [ v_pantera_rdate ], veh_info [ _v_id - 1 ] [ v_pantera_radar ], veh_info [ _v_id - 1 ] [ v_id ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 128, "UPDATE `familys_vehicles` SET `v_pantera_gdate` = '%d', `v_pantera_gps` = '%d' WHERE `sv_id` = '%d' LIMIT 1", 
	veh_info [ _v_id - 1 ] [ v_pantera_gdate ], veh_info [ _v_id - 1 ] [ v_pantera_gps ], veh_info [ _v_id - 1 ] [ v_id ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 128, "UPDATE `familys_vehicles` SET `v_pantera_adate` = '%d', `v_pantera_armour` = '%d' WHERE `sv_id` = '%d' LIMIT 1", 
	veh_info [ _v_id - 1 ] [ v_pantera_adate ], veh_info [ _v_id - 1 ] [ v_pantera_armour ], veh_info [ _v_id - 1 ] [ v_id ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 128, "UPDATE `familys_vehicles` SET `v_pantera_ldate` = '%d', `v_pantera_launch` = '%d' WHERE `sv_id` = '%d' LIMIT 1", 
	veh_info [ _v_id - 1 ] [ v_pantera_ldate ], veh_info [ _v_id - 1 ] [ v_pantera_launch ], veh_info [ _v_id - 1 ] [ v_id ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 128, "UPDATE `familys_vehicles` SET `v_sound` = '%d', `v_pantera_sdate` = '%d' WHERE `sv_id` = '%d' LIMIT 1", 
	veh_info [ _v_id - 1 ] [ v_sound ], veh_info [ _v_id - 1 ] [ v_pantera_sdate ], veh_info [ _v_id - 1 ] [ v_id ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;
	
	DestroyVehicle ( _v_id, 1000 ) ;
	return 1 ;
}

CMD:famcar ( playerid )
{
	if ( p_info [ playerid ] [ hour_played ] < 3 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре." ) ;
	if ( ! p_info [ playerid ] [ family ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
	if ( GetPlayerVehicleID ( playerid ) == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны быть в машине." ) ;
	
	new _family_id = p_info [ playerid ] [ family ] ;
	if ( ! family_info [ _family_id - 1 ] [ fam_house ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи нет дома." ) ;
	
	new _h_id = family_info [ _family_id - 1 ] [ fam_house ] ;
	if ( h_info [ _h_id - 1 ] [ h_podezd ] != -1 ) 
	{
		new _p_info = h_info [ _h_id - 1 ] [ h_podezd ] ;
		if ( ! podezd_info [ _p_info ] [ p_parking ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вашей семьи не частный дом." ) ;
	}
	else
		if ( ! IsPlayerInRangeOfPoint ( playerid, 50, h_info [ _h_id - 1 ] [ h_pos ] [ 0 ], h_info [ _h_id - 1 ] [ h_pos ] [ 1 ], h_info [ _h_id - 1 ] [ h_pos ] [ 2 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны находиться около семейного дома." ) ;
	
	new _veh_id = GetPlayerVehicleID ( playerid ) ;
	if ( veh_info [ _veh_id - 1 ] [ v_type ] != vehicle_type_player ) return 1 ;
	if ( veh_info [ _veh_id - 1 ] [ v_owner ] != p_info [ playerid ] [ id ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Передавать в семью можно только личный транспорт." ) ;
	if ( veh_info [ _veh_id - 1 ] [ v_date_used ] > 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный транспорт у Вас от промокода, его нельзя продать." ) ;
	if ( v_plane ( _veh_id ) || v_boat ( _veh_id ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нельзя передавать в семью воздушный и водный транспорт." ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 162, "{"#cWH"}Вы действительно хотите передать {"#cBL"}%s {"#cWH"}в семью?\n\n{"#cGRDialog"}* В дальнейшем Вы не сможете его забрать.", GetVehicleNameEx ( _veh_id ) ) ;
	show_dialog ( playerid, d_givecar_family, DIALOG_STYLE_MSGBOX, "{"#cBHD"}", global_string, "Да", "Нет" ) ;
	return 1 ;
}

CMD:reitfam ( playerid )
{
	mysql_tquery ( sql_connection, !"SELECT `fam_id` FROM `family` ORDER BY `family`.`fam_rating` DESC LIMIT 10", "family_rating_callback", "i", playerid ) ;
	return 1 ;
}

callback: family_rating_callback ( playerid )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;

	global_string [ 0 ] = EOS ;

	new _family_id, line_string [ 128 ], bool: _your_family = false ;
	strcat ( global_string, "{"#cBL"}Название семьи:\t{"#cBL"}Рейтинг:\t{"#cBL"}Захвачено зон:\t{"#cBL"}Создатель семьи:\n" ) ;
	for ( new i = 0 ; i < rows ; i ++ )
	{
 		_family_id = cache_get_field_content_int ( i, "fam_id", sql_connection ) ;

 		format ( line_string, sizeof line_string, "{%s}%s\t{"#cBHD"}%d\t%d\t{fFFFFF}%s\n", family_info [ _family_id - 1 ] [ fam_chat_color ], family_info [ _family_id - 1 ] [ fam_name ], family_info [ _family_id - 1 ] [ fam_rating ], family_info [ _family_id - 1 ] [ fam_zones ], family_info [ _family_id - 1 ] [ fam_creator ] ) ;
        strcat ( global_string, line_string ) ;
		
		if ( _family_id == p_info [ playerid ] [ family ] ) _your_family = true ;
	}
	
	if ( ! _your_family && p_info [ playerid ] [ family ] > 0 )
	{
		_family_id = p_info [ playerid ] [ family ] ;
		format ( line_string, sizeof line_string, "{%s}%s\t{"#cBHD"}%d\t%d\t{fFFFFF}%s\n", family_info [ _family_id - 1 ] [ fam_chat_color ], family_info [ _family_id - 1 ] [ fam_name ], family_info [ _family_id - 1 ] [ fam_rating ], family_info [ _family_id - 1 ] [ fam_zones ], family_info [ _family_id - 1 ] [ fam_creator ] ) ;
        strcat ( global_string, line_string ) ;
	}
	show_dialog ( playerid, d_none, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Рейтинг семей", global_string, "Закрыть", "" ) ;
	return 1 ;
}

callback: family_rating_smali ( playerid )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows || rows < 10 )
	{
		send_check_cinfo ( playerid, "Рейтинг семей ещё не сформирован!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}
	
    new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
	BS_WriteValue(bitstream, PR_INT8, 4);
	BS_WriteValue(bitstream, PR_INT8, 28);
	
	BS_WriteValue(bitstream, PR_UINT8, 10);

	new _family_id, _your_family = -1, _your_family_position = -1, line_string [ 64 ] ;
	for ( new i = 0 ; i < rows ; i ++ )
	{
		_family_id = cache_get_field_content_int ( i, "fam_id", sql_connection ) ;
		if ( i < 10 )
		{
			format ( line_string, sizeof line_string, "%d", i + 1 ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
	
			BS_WriteValue(bitstream, PR_UINT8, strlen ( family_info [ _family_id - 1 ] [ fam_name ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, family_info [ _family_id - 1 ] [ fam_name ]);
			
			format ( line_string, sizeof line_string, "%d", family_info [ _family_id - 1 ] [ fam_members ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			format ( line_string, sizeof line_string, "%d", family_info [ _family_id - 1 ] [ fam_rating ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
		}
		
		if ( _family_id == p_info [ playerid ] [ family ] )
		{
			_your_family = _family_id ;
			_your_family_position = i + 1 ;
		}
	}

    PR_SendPacket(bitstream, playerid);
	BS_Delete(bitstream);
	
	if ( _your_family != -1 )
	{
		new BitStream:bitstream1 = BS_New();
		BS_WriteValue(bitstream1, PR_UINT8, PACKET_CUSTOMRPC);
		BS_WriteValue(bitstream1, PR_UINT32, RPC_FAMILY);
					
		BS_WriteValue(bitstream1, PR_INT8, 4);
		BS_WriteValue(bitstream1, PR_INT8, 28);
		
		BS_WriteValue(bitstream1, PR_UINT8, 1);
		
		format ( line_string, sizeof line_string, "%d", _your_family_position ) ;
		BS_WriteValue(bitstream1, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream1, PR_STRING, line_string ) ;
	
		BS_WriteValue(bitstream1, PR_UINT8, strlen ( family_info [ _family_id - 1 ] [ fam_name ] ) ) ;
		BS_WriteValue(bitstream1, PR_STRING, family_info [ _family_id - 1 ] [ fam_name ]);
			
		format ( line_string, sizeof line_string, "%d", family_info [ _family_id - 1 ] [ fam_members ] ) ;
		BS_WriteValue(bitstream1, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream1, PR_STRING, line_string ) ;
			
		format ( line_string, sizeof line_string, "%d", family_info [ _family_id - 1 ] [ fam_rating ] ) ;
		BS_WriteValue(bitstream1, PR_UINT8, strlen ( line_string ) ) ;
		BS_WriteValue(bitstream1, PR_STRING, line_string ) ;

		PR_SendPacket(bitstream1, playerid);
		BS_Delete(bitstream1);
	}
	return 1 ;
}

callback: callback_family_noty ( playerid )
{
    new rows, fields, _family_id = p_info [ playerid ] [ family ] ;
	family_news_loading [ _family_id ] = true ;
	
	for ( new i = 0 ; i < MAX_FAMILY_NEWS ; i ++ )
	{
		family_news [ _family_id ] [ i ] [ n_id ] = 0 ;
		family_news [ _family_id ] [ i ] [ n_free_slot ] = false ;
	}
	
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;
	
	new line_string [ 64 ], s_year, s_month, s_day, s_hour, s_minute, s_second ;
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
	
	BS_WriteValue(bitstream, PR_INT8, 3);
	BS_WriteValue(bitstream, PR_INT8, 30);
	
	BS_WriteValue(bitstream, PR_UINT8, rows);
	for ( new i = 0 ; i < rows ; i ++ )
	{
		family_news [ _family_id ] [ i ] [ n_id ] = cache_get_field_content_int ( i, "n_id", sql_connection ) ;
		cache_get_field_content ( i, "family_text", family_news [ _family_id ] [ i ] [ n_text ], sql_connection, 200 ) ;
		cache_get_field_content ( i, "family_text_owner", family_news [ _family_id ] [ i ] [ n_text_owner ], sql_connection, MAX_PLAYER_NAME ) ;
		family_news [ _family_id ] [ i ] [ n_text_date ] = cache_get_field_content_int ( i, "family_date", sql_connection ) ;
		family_news [ _family_id ] [ i ] [ n_free_slot ] = true ;
		
		timestamp_to_date ( family_news [ _family_id ] [ i ] [ n_text_date ] + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
		format ( line_string, sizeof line_string, "%02d.%02d.%d", s_day, s_month, s_year ) ;
		
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( family_news [ _family_id ] [ i ] [ n_text_owner ] ),
			PR_STRING, family_news [ _family_id ] [ i ] [ n_text_owner ],
		
			PR_UINT8, strlen ( line_string ),
			PR_STRING, line_string,
		
			PR_UINT8, strlen ( family_news [ _family_id ] [ i ] [ n_text ] ),
			PR_STRING, family_news [ _family_id ] [ i ] [ n_text ] ) ;
	}
	
	PR_SendPacket(bitstream, playerid);
	BS_Delete(bitstream);
	return 1 ;
}

enum _family_users_rating
{
	fu_name [ MAX_PLAYER_NAME ],
	fu_count
} ;
new family_users_rating [ MAX_FAMILY ] [ 3 ] [ 10 ] [ _family_users_rating ] ;
new bool: family_users_rating_loaded [ MAX_FAMILY ] = false ;

callback: family_rating_users ( playerid, _type )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows || rows < 10 )
	{
		send_check_cinfo ( playerid, "Рейтинг игроков ещё не сформирован!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}
	
    new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
	BS_WriteValue(bitstream, PR_INT8, 3);
	BS_WriteValue(bitstream, PR_INT8, 29);
	
	BS_WriteValue(bitstream, PR_UINT8, 10);

	new line_string [ 64 ], family_id = p_info [ playerid ] [ family ] ;
	for ( new i = 0 ; i < rows ; i ++ )
	{
		if ( _type == 1 ) family_users_rating [ family_id ] [ _type - 1 ] [ i ] [ fu_count ] = cache_get_field_content_int ( i, "u_week_played", sql_connection ) ;
		if ( _type == 2 ) family_users_rating [ family_id ] [ _type - 1 ] [ i ] [ fu_count ] = cache_get_field_content_int ( i, "u_fam_captured", sql_connection ) ;
		if ( _type == 3 ) family_users_rating [ family_id ] [ _type - 1 ] [ i ] [ fu_count ] = cache_get_field_content_int ( i, "u_fam_graffity", sql_connection ) ;
		cache_get_field_content ( i, "u_name", family_users_rating [ family_id ] [ _type - 1 ] [ i ] [ fu_name ], sql_connection, MAX_PLAYER_NAME ) ;
		
		format ( line_string, sizeof line_string, "%d", family_users_rating [ family_id ] [ _type - 1 ] [ i ] [ fu_count ] ) ;
		BS_WriteValue(
			bitstream,
			PR_UINT32, _type,
	
			PR_UINT8, strlen ( family_users_rating [ family_id ] [ _type - 1 ] [ i ] [ fu_name ] ),
			PR_STRING, family_users_rating [ family_id ] [ _type - 1 ] [ i ] [ fu_name ],
			
			PR_UINT8, strlen ( line_string ),
			PR_STRING, line_string ) ;
	}

    PR_SendPacket(bitstream, playerid);
	BS_Delete(bitstream);
	
	if ( _type == 1 ) 
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, 144, "SELECT `u_id`, `u_name`, `u_fam_captured` FROM `users` WHERE `u_family` = '%d' ORDER BY `users`.`u_fam_captured` DESC LIMIT 10", p_info [ playerid ] [ family ] ) ;
		mysql_tquery ( sql_connection, global_string, "family_rating_users", "ii", playerid, 2 ) ;
	}
	else if ( _type == 2 )
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, 144, "SELECT `u_id`, `u_name`, `u_fam_graffity` FROM `users` WHERE `u_family` = '%d' ORDER BY `users`.`u_fam_graffity` DESC LIMIT 10", p_info [ playerid ] [ family ] ) ;
		mysql_tquery ( sql_connection, global_string, "family_rating_users", "ii", playerid, 3 ) ;
	}
	family_users_rating_loaded [ family_id ] = true ;
	return 1 ;
}

stock show_family_house ( playerid )
{
	show_dialog ( playerid, d_fam_house, DIALOG_STYLE_LIST, "{"#cBHD"}Взаимодействие с домом", "{"#cBL"}1. {"#cWH"}Гардероб\n{"#cBL"}2. {"#cWH"}Подвал", "Выбрать", "Назад" ) ;
	return 1 ;
}

stock show_packet_family ( playerid, _param, _param2, _param3 )
{
	player_last_page [ playerid ] = _param ;
	if ( _param == 0 )
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 ) // back page
			{
				new _family_id = p_info [ playerid ] [ family ] ;
				if ( _family_id < 1 ) return 1 ;
				
				familyShowMainMenuPage ( playerid ) ;
		
				if ( family_news_loading [ _family_id ] == true )
				{
					new _c_count = 0 ;
					for ( new i = 0 ; i < MAX_FAMILY_NEWS ; i ++ )
					{
						if ( family_news [ _family_id ] [ i ] [ n_id ] == 0 ) continue ;
						
						_c_count ++ ;
					}
					
					if ( ! _c_count ) return 1 ;
					
					new line_string [ 64 ], s_year, s_month, s_day, s_hour, s_minute, s_second ;
					new BitStream:bitstream = BS_New();
					BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
					BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
					
					BS_WriteValue(bitstream, PR_INT8, 3);
					BS_WriteValue(bitstream, PR_INT8, 30);
					
					BS_WriteValue(bitstream, PR_UINT8, _c_count);
					for ( new i = 0 ; i < MAX_FAMILY_NEWS ; i ++ )
					{
						if ( family_news [ _family_id ] [ i ] [ n_id ] == 0 ) continue ;
						
						timestamp_to_date ( family_news [ _family_id ] [ i ] [ n_text_date ] + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
						format ( line_string, sizeof line_string, "%02d.%02d.%d", s_day, s_month, s_year ) ;
						BS_WriteValue(
							bitstream,
							PR_UINT8, strlen ( family_news [ _family_id ] [ i ] [ n_text_owner ] ),
							PR_STRING, family_news [ _family_id ] [ i ] [ n_text_owner ],
						
							PR_UINT8, strlen ( line_string ),
							PR_STRING, line_string,
						
							PR_UINT8, strlen ( family_news [ _family_id ] [ i ] [ n_text ] ),
							PR_STRING, family_news [ _family_id ] [ i ] [ n_text ] ) ;
					}
					
					PR_SendPacket(bitstream, playerid);
					BS_Delete(bitstream);
				}
				else
				{
					new sql_string [ 64 + ( 9 * 2 ) ] ;
					format ( sql_string, sizeof sql_string, "SELECT * FROM `family_noty` WHERE `family_id` = '%d' LIMIT %d", _family_id, MAX_FAMILY_NEWS ) ;
					mysql_tquery ( sql_connection, sql_string, "callback_family_noty", "i", playerid ) ;
				}
			}
		}
		else if ( _param2 == 1 ) // написать сообщение
		{
			if ( _param3 == 0 )
			{
				new _family_id = p_info [ playerid ] [ family ] ;
				if ( p_info [ playerid ] [ family_rang ] < family_info [ _family_id - 1 ] [ fam_settings ] [ 3 ] )
				{
					send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				global_string [ 0 ] = EOS ;
				new line_string [ 128 ], _n_count = 0, s_year, s_month, s_day, s_hour, s_minute, s_second ;
				strcat ( global_string, "{"#cBL"}Текст:\t{"#cBL"}От кого:\t{"#cBL"}Дата:\n" ) ;
				for ( new i = 0 ; i < MAX_FAMILY_NEWS ; i ++ )
				{
					if ( family_news [ _family_id ] [ i ] [ n_free_slot ] == false ) continue ;

					timestamp_to_date ( family_news [ _family_id ] [ i ] [ n_text_date ] + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
					format ( line_string, sizeof line_string, "%s\t%s\t%02d.%02d.%d\n", family_news [ _family_id ] [ i ] [ n_text ], family_news [ _family_id ] [ i ] [ n_text_owner ], s_day, s_month, s_year ) ;
					strcat ( global_string, line_string ) ;
					
					set_player_listitem_values ( playerid, _n_count, i ) ;
					_n_count ++ ;
				}
				strcat ( global_string, "{"#cGRDialog"}Новое объявление" ) ;
				set_player_listitem_values ( playerid, _n_count, -1 ) ;
				
				show_dialog ( playerid, d_family_noty, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Сообщения", global_string, "Выбрать", "Отмена" ) ;
			}
		}
		else if ( _param2 == 2 ) // принять в семью
		{
			if ( _param3 == 0 )
			{
				show_dialog ( playerid, d_family_invites, DIALOG_STYLE_INPUT, "{"#cBHD"}Принять в семью", "{"#cWH"}Введите ID игрока, которого хотите принять в семью:", "Выбрать", "Отмена" ) ;
			}
		}
		else if ( _param2 == 3 )
		{
			if ( _param3 == 0 )
			{
				new family_id = p_info [ playerid ] [ family ] ;
				if ( family_id < 1 )
				{
					show_packet_family ( playerid, 255, 255, 255 ) ;
					return 1 ;
				}
				if ( GetString ( family_info [ family_id - 1 ] [ fam_creator ], p_info [ playerid ] [ name ] ) )
				{
					send_check_cinfo ( playerid, "Лидер семьи не может покинуть её.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
						
				new fm_string [ 144 ] ;
				format ( fm_string, sizeof ( fm_string ), "{%s}[FAM] %s %s[%i] покинул(а) семью!", family_info [ family_id - 1 ] [ fam_chat_color ], family_rank [ family_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], playerid ) ;
				family_message ( family_id, col_gray, fm_string ) ;
						
				format ( fm_string, 128, "DELETE FROM `family_warns` WHERE `f_u_id` = '%d' LIMIT %d", p_info [ playerid ] [ id ], p_info [ playerid ] [ fam_warning ] ) ;
				mysql_tquery ( sql_connection, fm_string ) ;

				Iter_Remove(family_players[family_id], playerid) ;

				p_info [ playerid ] [ family ] =
				p_info [ playerid ] [ family_rang ] = 
				p_info [ playerid ] [ famblock ] = 
				p_info [ playerid ] [ fam_warning ] = 0 ;
						
				if ( p_info [ playerid ] [ family_text ] != Text3D:INVALID_3DTEXT_ID )
				{
					DestroyDynamic3DTextLabel ( p_info [ playerid ] [ family_text ] ) ;
					p_info [ playerid ] [ family_text ] = Text3D:INVALID_3DTEXT_ID ;
				}
						
				family_info [ family_id - 1 ] [ fam_members ] -- ;
				format ( fm_string, sizeof ( fm_string ), "UPDATE `family` SET `fam_members` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_members ], family_id ) ;
				mysql_tquery(sql_connection, fm_string ) ;

				format(fm_string, sizeof(fm_string), "UPDATE `users` SET `u_family` = '0', `u_family_rank` = '0', `u_fam_warning` = '0', `u_famblock` = '0' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
				mysql_tquery(sql_connection, fm_string);

				#if defined m_binders
					update_packet_binds ( playerid ) ;
				#endif
			}
		}
	}
	else if ( _param == 1 ) // информация
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				new family_id = p_info [ playerid ] [ family ], line_string [ 64 ], line_string2 [ 64 ] ;
				format ( line_string, sizeof line_string, "%d человек онлайн", Iter_Count(family_players[family_id]) ) ;
				format ( line_string2, sizeof line_string2, "%d человек оффлайн", family_info [ family_id - 1 ] [ fam_members ] ) ;
				familyShowInformationPage ( playerid, line_string, line_string2 ) ;
			}
		}
		else if ( _param2 == 1 ) // смена названия семьи
		{
			if ( _param3 == 0 )
			{
				if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
				{
					send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				show_dialog ( playerid, d_family_rename, DIALOG_STYLE_INPUT, "{"#cBHD"}Переименование семьи", "{"#cGRDialog"}* Стоимость внесения информационных поправок в архив составляет {"#cGN"}"renamefamily_price_txt"\n\n{FFFFFF}Введите новое название своей семьи:", "Принять", "Назад" ) ;
			}
		}
		else if ( _param2 == 2 ) // смена цвета семьи
		{
			if ( _param3 == 0 )
			{
				if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
				{
					send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new color_dialog [ 248 ];
				format ( color_dialog, sizeof ( color_dialog ),"{"#cBL"}Готовые цвета:\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 1\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 2\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 3\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 4\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 5\n{"#cGRDialog"}Ввести свой RGB-цвет", family_chat_color [ 0 ],family_chat_color [ 1 ],family_chat_color [ 2 ],family_chat_color [ 3 ],family_chat_color [ 4 ]);
				show_dialog ( playerid, d_family_color, DIALOG_STYLE_LIST, "{"#cBHD"}Цвет чата", color_dialog, "Выбрать","Отмена" ) ;
			}
		}
		else if ( _param2 == 3 ) // уровень семьи
		{
			if ( _param3 == 0 )
			{
				if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
				{
					send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new color_dialog [ 248 ];
				format ( color_dialog, sizeof ( color_dialog ),"{"#cBL"}Готовые цвета:\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 1\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 2\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 3\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 4\n{"#cGRDialog"}- {"#cWH"}{%s}Цвет 5\n{"#cGRDialog"}Ввести свой RGB-цвет", family_chat_color [ 0 ],family_chat_color [ 1 ],family_chat_color [ 2 ],family_chat_color [ 3 ],family_chat_color [ 4 ]);
				show_dialog ( playerid, d_family_color, DIALOG_STYLE_LIST, "{"#cBHD"}Цвет чата", color_dialog, "Выбрать","Отмена" ) ;
				
				global_string [ 0 ] = EOS ;
				new line_string [ 100 ], _fam_level = 1 ;
				
				new _fam_id = p_info [ playerid ] [ family ], _h_id = family_info [ _fam_id - 1 ] [ fam_house ] ;
				if ( _h_id )
				{
					_fam_level += 1 ;
					if ( h_info [ _h_id - 1 ] [ h_podezd ] == -1 ) _fam_level += 1 ;
				}
				if ( family_info [ _fam_id - 1 ] [ fam_rating ] > 999 ) _fam_level += floatround ( family_info [ _fam_id - 1 ] [ fam_rating ] / 1000 ) ;
				_fam_level += family_info [ _fam_id - 1 ] [ fam_enprises_count ] ;
				family_info [ _fam_id - 1 ] [ fam_level ] = _fam_level ;
				
				strcat ( global_string, !"{"#cBL"}** Повышение уровня **\n\n" ) ;
				if ( _h_id )
				{
					if ( h_info [ _h_id - 1 ] [ h_podezd ] != -1 )
					{
						strcat ( global_string, !"{"#cGN"}+ {"#cWH"}За семейный дом {"#cGN"}+1 уровень\n" ) ;
						strcat ( global_string, !"{"#cRD"}- {"#cWH"}За {"#cLY"}частный {"#cWH"}семейный дом {"#cGN"}+2 уровеня\n" ) ;
					}
					else
					{
						strcat ( global_string, !"{"#cRD"}- {"#cWH"}За семейный дом {"#cGN"}+1 уровень\n" ) ;
						strcat ( global_string, !"{"#cGN"}+ {"#cWH"}За {"#cLY"}частный {"#cWH"}семейный дом {"#cGN"}+2 уровеня\n" ) ;
					}
				}
				else
				{
					strcat ( global_string, !"{"#cRD"}- {"#cWH"}За семейный дом {"#cGN"}+1 уровень\n" ) ;
					strcat ( global_string, !"{"#cRD"}- {"#cWH"}За {"#cLY"}частный {"#cWH"}семейный дом {"#cGN"}+2 уровеня\n" ) ;
				}
				
				format ( line_string, sizeof line_string, "{"#cGN"}%d ур. {"#cWH"}За каждую {"#cLY"}1.000 рейтинга{"#cWH"} {"#cGN"}+1 уровень\n", floatround ( family_info [ _fam_id - 1 ] [ fam_rating ] / 1000 ) ) ;
				strcat ( global_string, line_string ) ;
				
				format ( line_string, sizeof line_string, "{"#cGN"}%d ур. {"#cWH"}За каждое предприятие {"#cGN"}+1 уровень\n\n", family_info [ _fam_id - 1 ] [ fam_enprises_count ] ) ;
				strcat ( global_string, line_string ) ;
					
				if ( _fam_level == 1 )
				{
					strcat ( global_string, !"{"#cBL"}** Возможности 1 уровня **\n\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Закраска граффити\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Выполнение заданий\n\n" ) ;
				}
				if ( _fam_level == 1 || _fam_level == 2 )
				{
					strcat ( global_string, !"{"#cBL"}** Возможности 2 уровня **\n\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Закраска граффити\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Выполнение заданий\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Участие в поставках {"#cGRDialog"}(Наличие семейного дома)\n\n" ) ;
				}
				if ( _fam_level == 2 || _fam_level == 3 )
				{
					strcat ( global_string, !"{"#cBL"}** Возможности 3 уровня **\n\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Закраска граффити\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Выполнение заданий\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Участие в поставках {"#cGRDialog"}(Наличие семейного дома)\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Участие в контрабандах {"#cGRDialog"}(Наличие семейного дома)\n\n" ) ;
				}
				if ( _fam_level == 3 || _fam_level == 4 )
				{
					strcat ( global_string, !"{"#cBL"}** Возможности 4 уровня **\n\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Закраска граффити\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Выполнение заданий\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Участие в поставках {"#cGRDialog"}(Наличие семейного дома)\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Участие в контрабандах {"#cGRDialog"}(Наличие семейного дома)\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Участие в захвате территорий {"#cGRDialog"}(Наличие частного семейного дома)\n\n" ) ;
				}
				if ( _fam_level == 4 || _fam_level == 5 )
				{
					strcat ( global_string, !"{"#cBL"}** Возможности 5 уровня **\n\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Закраска граффити\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Выполнение заданий\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Участие в поставках {"#cGRDialog"}(Наличие семейного дома)\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Участие в контрабандах {"#cGRDialog"}(Наличие семейного дома)\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Участие в захвате территорий {"#cGRDialog"}(Наличие частного семейного дома)\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Доступ к рейду предприятий\n\n" ) ;
				}
				if ( _fam_level == 5 || _fam_level >= 6 )
				{
					strcat ( global_string, !"{"#cBL"}** Возможности 6 уровня и выше **\n\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Закраска граффити\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Выполнение заданий\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Участие в поставках {"#cGRDialog"}(Наличие семейного дома)\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Участие в контрабандах {"#cGRDialog"}(Наличие семейного дома)\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Участие в захвате территорий {"#cGRDialog"}(Наличие частного семейного дома)\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Доступ к рейду предприятий\n" ) ;
					strcat ( global_string, !"{"#cGRDialog"}- {"#cWH"}Доступ к покупке предприятий\n\n" ) ;
				}
				
				new header_string [ 48 ] ;
				format ( header_string, sizeof header_string, "{"#cBHD"}Ваша семья {"#cWH"}%d уровня", _fam_level ) ;
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, header_string, global_string, "Принять", "" ) ;
			}
		}
	}
	else if ( _param == 2 ) // состав
	{
		if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
		{
			show_packet_family ( playerid, 20, 0, 0 ) ;
			return 1 ;
		}
		
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowMembersPage ( playerid ) ;
				page_rows [ playerid ] = 100 ;
			}
			else page_rows [ playerid ] += 100 ;
				
			global_string [ 0 ] = EOS ;
			mysql_format ( sql_connection, global_string, 144, "SELECT `u_id`,`u_name`,`u_fam_warning`,`u_week_played` FROM `users` WHERE `u_family` = '%d' LIMIT %d", p_info [ playerid ] [ family ], page_rows [ playerid ] ) ;
			mysql_tquery ( sql_connection, global_string, "callback_offamily_device", "ii", playerid, 32 ) ;
		}
		else if ( _param2 == 1 )
		{
			if ( p_info [ playerid ] [ id ] == _param3 )
			{
				send_check_cinfo ( playerid, "Вы выбрали себя!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			global_string [ 0 ] = EOS ;
			mysql_format ( sql_connection, global_string, 100, "SELECT `u_name` FROM `users` WHERE `u_id` = '%d' LIMIT 1", _param3 ) ;
			mysql_tquery ( sql_connection, global_string, "callback_offamily_name", "i", playerid ) ;
		}
	}
	else if ( _param == 3 ) // safe logs
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowSafePage ( playerid ) ;
				
				if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
				{
					send_check_cinfo ( playerid, "Вам не будет отображён лог действий семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				}
				else
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 200, "SELECT `id`, `name`, `Text`, `text_date`, `type` FROM `logs_family` WHERE `family` = '%d' AND `type` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ], TYPE_LOG_OBWYAK ) ;
					mysql_tquery(sql_connection, global_string, "get_familys_logs_device", "ii", playerid, 47);
				}
			}
		}
	}
	else if ( _param == 45 ) // safe get
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
				{
					send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new header_string [ 64 ] ;
				format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_bank ] ) ) ;
				inv_dialog ( playerid, d_family_bank_take, DIALOG_STYLE_INPUT, header_string, "{"#cWH"}Введите сумму, которую хотите взять с банка семьи:", "Выбрать", "Назад" ) ;
			}
		}
	}
	else if ( _param == 46 ) // safe put
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				new header_string [ 64 ] ;
				format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_bank ] ) ) ;
				inv_dialog ( playerid, d_family_bank_put, DIALOG_STYLE_INPUT, header_string, "{"#cWH"}Введите сумму, которую хотите положить в банк семьи:", "Выбрать", "Назад" ) ;
			}
		}
	}
	else if ( _param == 4 ) // settings
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowSettingsPage ( playerid ) ;
				
				static const _settings_name [ ] [ 26 ] =
				{
					"Прием в семью",
					"Исключение из семьи",
					"Изменение статуса",
					"Чёрный список",
					"Доступ к /fam(un)mute",
					"Доступ к /famlock",
					"Доступ к общаку",
					"Количество статусов",
					"Название статусов",
					"Национальность семьи",
					"Позиция общака",
					"Предупреждения",
					"Семейный дом"
				} ;
				static const _settings_id [ ] = { 0, 1, 2, 4, 5, 6, 7, 3 } ;
				
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
				BS_WriteValue(bitstream, PR_INT8, 2);
				BS_WriteValue(bitstream, PR_INT8, 41);
		
				BS_WriteValue(bitstream, PR_UINT8, 13);
				
				new line_string [ 100 ], family_id = p_info [ playerid ] [ family ] ;
				for ( new i = 0 ; i < 13 ; i ++ )
				{
					BS_WriteValue(bitstream, PR_UINT8, strlen ( _settings_name [ i ] ) ) ;
					BS_WriteValue(bitstream, PR_STRING, _settings_name [ i ] ) ;
					
					if ( i < sizeof _settings_id )
					{
						new _id = _settings_id [ i ] ;
						format ( line_string, sizeof line_string, "Доступно со статуса '%s' (%d)", family_rank [ family_id - 1 ] [ family_info [ family_id - 1 ] [ fam_settings ] [ _id ] - 1 ], family_info [ family_id - 1 ] [ fam_settings ] [ _id ] ) ;
						BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
						BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					}
					else
					{
						BS_WriteValue(bitstream, PR_UINT8, strlen ( " " ) ) ;
						BS_WriteValue(bitstream, PR_STRING, " " ) ;
					}
				}
				
				PR_SendPacket(bitstream, playerid);
				BS_Delete(bitstream);
			}
		}
		else if ( _param2 == 1 )
		{
			switch ( _param3 )
			{
				case 0..6:
				{
					if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
					{
						send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
					
					show_settings_family ( playerid, p_info [ playerid ] [ family ], _param3 ) ;
				}
				case 7:
				{
					if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
					{
						send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
					
					show_dialog ( playerid, d_family_settings_c, DIALOG_STYLE_INPUT, "{"#cBHD"}Количество статусов", "{"#cWH"}Введите количество семейных статусов, которое желаете установить:\n\n{"#cGRDialog"}* Количество статусов не может быть меньше 3 и больше 12", "Принять", "Назад" ) ;
					return 1 ;
				}
				case 8:
				{
					if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
					{
						send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
					
					global_string [ 0 ] = EOS ;
					new line_string [ 72 ] ;
					for ( new i = 0; i < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] ; i ++ )
					{
						format ( line_string, 72, "{"#cBL"}%i. {"#cWH"}%s\n", i + 1, family_rank [ p_info [ playerid ] [ family ] - 1 ] [ i ] ) ;
						strcat ( global_string, line_string ) ;
					}
					show_dialog ( playerid, d_family_rank_list, DIALOG_STYLE_LIST, "{"#cBHD"}Название статуса", global_string, "Выбрать", "Назад" ) ;
					return 1 ;
				}
				case 9:
                {
					if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
					{
						send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
					
					show_dialog ( playerid, d_family_national, DIALOG_STYLE_LIST, "{"#cBHD"}Национальность семьи","{"#cGRDialog"}- {"#cWH"}Американцы\n{"#cGRDialog"}- {"#cWH"}Японцы\n{"#cGRDialog"}- {"#cWH"}Итальянцы\n{"#cGRDialog"}- {"#cWH"}Мексиканцы\n{"#cGRDialog"}- {"#cWH"}Латиноамериканцы\n{"#cGRDialog"}- {"#cWH"}Испанцы\n{"#cGRDialog"}- {"#cWH"}Русские\n{"#cGRDialog"}- {"#cWH"}Португальцы\n{"#cGRDialog"}- {"#cWH"}Французы","Выбрать","Отмена");
					return 1 ;
				}
				case 10:
				{
					if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
					{
						send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
					
				    new i = p_info [ playerid ] [ family ] - 1 ;
				    if ( ! family_info [ i ] [ fam_house ] )
					{
						if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет дома семьи." ) ;
					}

					if ( GetPVarInt ( playerid, "house_id" ) > 0 && GetPlayerVirtualWorld ( playerid ) == GetPVarInt ( playerid, "house_id" ) )
					{
					    new h = GetPVarInt ( playerid, "house_id" ) - 1 ;
					    if ( h != family_info [ i ] [ fam_house ] - 1 )
					    {
					        if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
							return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны находиться в доме семьи." ) ;
					    }
					}
					else
					{
					    if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны находиться в доме семьи." ) ;
					}

				    SendClientMessage ( playerid, col_gray, !"* Позиция общака семьи изменена." ) ;

				    GetPlayerPos ( playerid, dorm_family_pos [ i ] [ 0 ], dorm_family_pos [ i ] [ 1 ], dorm_family_pos [ i ] [ 2 ] ) ;

					new h = GetPVarInt ( playerid, "house_id" ) - 1 ;
					dorm_family_int [ i ] = GetPlayerInterior ( playerid ) ;
					dorm_family_virt [ i ] = h_info [ h ] [ h_id ] ;

                    if ( gdorm_family_text [ i ] != Text3D:INVALID_3DTEXT_ID )
					{
						DestroyDynamicArea ( dorm_family_area [ i ] ) ;
						DestroyDynamicCP ( dorm_family_cp [ i ] ) ;
						DestroyDynamic3DTextLabel ( gdorm_family_text [ i ] ) ;
					}

					dorm_family_cp [ i ] = CreateDynamicCP ( dorm_family_pos [ i ] [ 0 ], dorm_family_pos [ i ] [ 1 ], dorm_family_pos [ i ] [ 2 ], 1.0, dorm_family_virt [ i ], dorm_family_int [ i ], -1 ) ;
					dorm_family_area [ i ] = CreateDynamicSphere ( dorm_family_pos [ i ] [ 0 ], dorm_family_pos [ i ] [ 1 ], dorm_family_pos [ i ] [ 2 ] + 1, 2.0, dorm_family_virt [ i ], dorm_family_int [ i ], -1 ) ;
                    area_info [ dorm_family_area [ i ] ] [ a_type ] = area_type_family_dorm ;

	                new t_string [ 300 ] ;

					format ( t_string,sizeof ( t_string ),"\
					{%s}*** Общак %s ***\n\n\
					{"#cWH3D"}Количество территорий:{"#cOR3D"} \t%d\n\
					{"#cWH3D"}"family_title":{"#cOR3D"} \t%d шт.",
					family_info [ i ] [ fam_chat_color ],
					family_info [ i ] [ fam_name ],
					family_info [ i ] [ fam_zones ],
					family_info [ i ] [ fam_ticket ] ) ;

					gdorm_family_text [ i ] = CreateDynamic3DTextLabel ( t_string, col_blue, dorm_family_pos [ i ] [ 0 ], dorm_family_pos [ i ] [ 1 ], dorm_family_pos [ i ] [ 2 ] + 1, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, dorm_family_virt [ i ], dorm_family_int [ i ] ) ;

				    new query_string [ 82 + ( 4 * 8 ) + ( 2 * 9 ) + 9 ];
			    	format ( query_string, sizeof query_string, "UPDATE `family` SET `fam_dorm` = '%f|%f|%f|%d|%d' WHERE `fam_id` = '%d' LIMIT 1",
			      	dorm_family_pos [ i ] [ 0 ], dorm_family_pos [ i ] [ 1 ], dorm_family_pos [ i ] [ 2 ], dorm_family_int [ i ], dorm_family_virt [ i ],
					p_info [ playerid ] [ family ] ) ;
			   		mysql_tquery ( sql_connection, query_string ) ;

			   		format(query_string, 128, "%s изменил(а) место общака", p_info [ playerid ] [ name ]);
					write_family(playerid, p_info [ playerid ] [ family ], TYPE_LOG_OBWYAK, query_string);
		    
					if ( player_open_family [ playerid ] == false ) family_settings ( playerid ) ;
					return 1 ;
				}
				case 11:
				{
					if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
					{
						send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
					
					global_string [ 0 ] = EOS ;

					new family_id = p_info [ playerid ] [ family ] ;
					format ( global_string, 356, "{"#cGRDialog"}- {"#cWH"}Предупреждения ({"#cGN"}%d{"#cWH"})\n{"#cGRDialog"}- {"#cWH"}Доступ к /fam(un)warn ({"#cGN"}%s{"#cWH"})\n{"#cGRDialog"}- {"#cWH"}Выдача предупреждения старшим (%s{"#cWH"})", family_info [ family_id - 1 ] [ fam_max_warn ], family_rank [ family_id - 1 ] [ family_info [ family_id - 1 ] [ fam_settings ] [ 8 ] - 1 ], (  family_info [ family_id - 1 ] [ fam_rank_warn ] == 0 ) ? ( "{"#cRD"}Нет" ) : ( "{"#cGN"}Доступно" ) ) ;
					show_dialog ( playerid, d_famwarn_settings, DIALOG_STYLE_LIST, "{"#cBHD"}Предупреждения", global_string, "Выбрать", "Назад" ) ;
				}
				case 12:
				{
					if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
					{
						if ( p_info [ playerid ] [ family ]  < 1 )return SendClientMessage(playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не состоите в семье." ) ;
	
						show_family_house ( playerid ) ;
						return 1 ;
					}

					if ( ! Iter_Count(player_houses[playerid]) )
					{
						show_family ( playerid ) ;
						return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет дома." ) ;
					}

					show_home_family ( playerid ) ;
				}
			}
		}
	}
	else if ( _param == 5 ) // quest
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				new _fam_id = p_info [ playerid ] [ family ] ;
				if ( ! p_info [ playerid ] [ family_quest ] )
				{
					p_info [ playerid ] [ family_quest ] = random ( 8 ) + 1 ;
					p_info [ playerid ] [ family_quest_progress ] = 0 ;
						
					new sql_string [ 106 + 4 + 9 ] ;
					format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_family_quest` = '%d', `u_family_quest_progress` = '0' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ family_quest ], p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, sql_string ) ;
				}
				
				if ( ! family_info [ _fam_id - 1 ] [ fam_quest ] )
				{
					family_info [ _fam_id - 1 ] [ fam_quest ] = random ( 8 ) + 1 ;
					family_info [ _fam_id - 1 ] [ fam_quest_progress ] = 0 ;
					
					new sql_string [ 99 + 4 + 9 ] ;
					format ( sql_string, sizeof sql_string, "UPDATE `family` SET `fam_quest` = '%d', `fam_quest_progress` = '0' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_quest ], family_info [ _fam_id - 1 ] [ fam_id ] ) ;
					mysql_tquery ( sql_connection, sql_string ) ;
				}
		
				if ( p_info [ playerid ] [ family_quest ] != -1 ) show_packet_family ( playerid, 5, 1, 0 ) ;
				else if ( family_info [ _fam_id - 1 ] [ fam_quest ] != -1 ) show_packet_family ( playerid, 5, 1, 1 ) ;
				else show_packet_family ( playerid, 5, 1, 2 ) ;
			}
		}
		else if ( _param2 == 1 )
		{
			set_player_use_listitem ( playerid, _param3 ) ;
			if ( _param3 == 0 )
			{
				if ( p_info [ playerid ] [ family_quest ] != -1 )
				{
					new family_id = p_info [ playerid ] [ family ], line_string [ 64 ], line_string2 [ 64 ] ;
					format ( line_string, sizeof line_string, "%d человек онлайн", Iter_Count(family_players[family_id]) ) ;
					format ( line_string2, sizeof line_string2, "%d человек оффлайн", family_info [ family_id - 1 ] [ fam_members ] ) ;
					
					new _quest_id = p_info [ playerid ] [ family_quest ] ;
					static const _quest_progress [ ] =
					{
						10,
						20,
						1,
						1,
						10,
						50,
						100,
						1
					} ;
					if ( _quest_id && p_info [ playerid ] [ family_quest_progress ] < _quest_progress [ _quest_id - 1 ] )
					{
						familyShowQuestsContractsPage ( playerid, 
														line_string, 
														line_string2, 
														quest_family_info [ _quest_id - 1 ] [ q_name ], 
														quest_family_info [ _quest_id - 1 ] [ q_text ],
														p_info [ playerid ] [ family_quest_progress ], 
														_quest_progress [ _quest_id - 1 ], 
														family_rewards [ _quest_id - 1 ] [ r_exp ], 
														family_rewards [ _quest_id - 1 ] [ r_money ], 
														"Информация", 
														2 ) ;
					}
					else
					{
						familyShowQuestsContractsPage ( playerid, 
														line_string, 
														line_string2, 
														quest_family_info [ _quest_id - 1 ] [ q_name ], 
														quest_family_info [ _quest_id - 1 ] [ q_text ],
														p_info [ playerid ] [ family_quest_progress ], 
														_quest_progress [ _quest_id - 1 ], 
														family_rewards [ _quest_id - 1 ] [ r_exp ], 
														family_rewards [ _quest_id - 1 ] [ r_money ], 
														"Забрать награду", 
														2 ) ;
					}
				
					if ( p_info [ playerid ] [ family_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Ежедневный", 1, 1 ) ;
					else familyAddQuestsContractsItem ( playerid, "Ежедневный", 0, 0 ) ;
					
					if ( family_info [ family_id - 1 ] [ fam_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Семейный", 1, 1 ) ;
					else familyAddQuestsContractsItem ( playerid, "Семейный", 0, 0 ) ;
					
					familyAddQuestsContractsItem ( playerid, "Граффити", 1, 1 ) ;
					
					new _fam_level = update_family_level ( family_id ) ;
					if ( _fam_level >= 2 ) familyAddQuestsContractsItem ( playerid, "Поставка", 1, 1 ) ;
					if ( _fam_level >= 3 ) familyAddQuestsContractsItem ( playerid, "Контрабанда", 1, 1 ) ;
					if ( _fam_level >= 4 ) familyAddQuestsContractsItem ( playerid, "Территории", 1, 1 ) ;
					if ( _fam_level >= 5 ) familyAddQuestsContractsItem ( playerid, "Рейдеры", 1, 1 ) ;
					if ( _fam_level >= 6 && family_info [ family_id - 1 ] [ fam_enprises_count ] ) familyAddQuestsContractsItem ( playerid, "Инкассация", 1, 1 ) ;
				}
				else send_check_cinfo ( playerid, "Задание уже выполнено!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( _param3 == 1 )
			{
				new family_id = p_info [ playerid ] [ family ], line_string [ 64 ], line_string2 [ 64 ] ;
				if ( family_info [ family_id - 1 ] [ fam_quest ] != -1 )
				{
					format ( line_string, sizeof line_string, "%d человек онлайн", Iter_Count(family_players[family_id]) ) ;
					format ( line_string2, sizeof line_string2, "%d человек оффлайн", family_info [ family_id - 1 ] [ fam_members ] ) ;
					
					new _quest_id = family_info [ family_id - 1 ] [ fam_quest ] ;
					static const _quest_progress [ ] =
					{
						70,
						36,
						42,
						5000,
						100,
						500,
						400,
						300
					} ;
					
					if ( family_info [ family_id - 1 ] [ fam_quest_progress ] < _quest_progress [ _quest_id - 1 ] )
					{
						familyShowQuestsContractsPage ( playerid, 
														line_string, 
														line_string2, 
														all_family_quest [ _quest_id - 1 ] [ q_name ], 
														all_family_quest [ _quest_id - 1 ] [ q_text ],
														family_info [ family_id - 1 ] [ fam_quest_progress ], 
														_quest_progress [ _quest_id - 1 ], 
														all_family_rewards [ _quest_id - 1 ] [ r_exp ], 
														all_family_rewards [ _quest_id - 1 ] [ r_money ], 
														"Информация", 
														2 ) ;
					}
					else
					{
						familyShowQuestsContractsPage ( playerid, 
														line_string, 
														line_string2, 
														all_family_quest [ _quest_id - 1 ] [ q_name ], 
														all_family_quest [ _quest_id - 1 ] [ q_text ],
														family_info [ family_id - 1 ] [ fam_quest_progress ], 
														_quest_progress [ _quest_id - 1 ], 
														all_family_rewards [ _quest_id - 1 ] [ r_exp ], 
														all_family_rewards [ _quest_id - 1 ] [ r_money ], 
														"Забрать награду", 
														2 ) ;
					}
				
					if ( p_info [ playerid ] [ family_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Ежедневный", 1, 1 ) ;
					else familyAddQuestsContractsItem ( playerid, "Ежедневный", 0, 0 ) ;
					
					if ( family_info [ family_id - 1 ] [ fam_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Семейный", 1, 1 ) ;
					else familyAddQuestsContractsItem ( playerid, "Семейный", 0, 0 ) ;
					
					familyAddQuestsContractsItem ( playerid, "Граффити", 1, 1 ) ;
					
					new _fam_level = update_family_level ( family_id ) ;
					if ( _fam_level >= 2 ) familyAddQuestsContractsItem ( playerid, "Поставка", 1, 1 ) ;
					if ( _fam_level >= 3 ) familyAddQuestsContractsItem ( playerid, "Контрабанда", 1, 1 ) ;
					if ( _fam_level >= 4 ) familyAddQuestsContractsItem ( playerid, "Территории", 1, 1 ) ;
					if ( _fam_level >= 5 ) familyAddQuestsContractsItem ( playerid, "Рейдеры", 1, 1 ) ;
					if ( _fam_level >= 6 && family_info [ family_id - 1 ] [ fam_enprises_count ] ) familyAddQuestsContractsItem ( playerid, "Инкассация", 1, 1 ) ;
				}
				else send_check_cinfo ( playerid, "Задание уже выполнено!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( _param3 == 2 )
			{
				new family_id = p_info [ playerid ] [ family ], line_string [ 64 ], line_string2 [ 64 ] ;
				if ( family_info [ family_id - 1 ] [ fam_quest ] != -1 )
				{
					format ( line_string, sizeof line_string, "%d человек онлайн", Iter_Count(family_players[family_id]) ) ;
					format ( line_string2, sizeof line_string2, "%d человек оффлайн", family_info [ family_id - 1 ] [ fam_members ] ) ;

					familyShowQuestsContractsPage ( playerid, 
													line_string, 
													line_string2, 
													"Граффити", 
													"Закрашивайте граффити вражеских семей и получайте бонусы для своей семьи.",
													family_info [ family_id - 1 ] [ fam_graffity ],
													count_fam_graffity,
													1,
													500,
													"Найти граффити",
													2 ) ;

					if ( p_info [ playerid ] [ family_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Ежедневный", 1, 1 ) ;
					else familyAddQuestsContractsItem ( playerid, "Ежедневный", 0, 0 ) ;
					
					if ( family_info [ family_id - 1 ] [ fam_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Семейный", 1, 1 ) ;
					else familyAddQuestsContractsItem ( playerid, "Семейный", 0, 0 ) ;
					
					familyAddQuestsContractsItem ( playerid, "Граффити", 1, 1 ) ;
					
					new _fam_level = update_family_level ( family_id ) ;
					if ( _fam_level >= 2 ) familyAddQuestsContractsItem ( playerid, "Поставка", 1, 1 ) ;
					if ( _fam_level >= 3 ) familyAddQuestsContractsItem ( playerid, "Контрабанда", 1, 1 ) ;
					if ( _fam_level >= 4 ) familyAddQuestsContractsItem ( playerid, "Территории", 1, 1 ) ;
					if ( _fam_level >= 5 ) familyAddQuestsContractsItem ( playerid, "Рейдеры", 1, 1 ) ;
					if ( _fam_level >= 6 && family_info [ family_id - 1 ] [ fam_enprises_count ] ) familyAddQuestsContractsItem ( playerid, "Инкассация", 1, 1 ) ;
				}
				else send_check_cinfo ( playerid, "Задание уже выполнено!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else if ( _param3 == 3 )
			{
				new family_id = p_info [ playerid ] [ family ], line_string [ 64 ], line_string2 [ 64 ] ;
				format ( line_string, sizeof line_string, "%d человек онлайн", Iter_Count(family_players[family_id]) ) ;
				format ( line_string2, sizeof line_string2, "%d человек оффлайн", family_info [ family_id - 1 ] [ fam_members ] ) ;

				familyShowQuestsContractsPage ( playerid, 
												line_string, 
												line_string2, 
												"Поставка", 
												"Захватите возднушную поставку и заберите перехваченое в общак семьи.",
												0,
												1,
												5,
												500_000,
												"Когда прибудет поставка, то на карте появится чёрный квадрат",
												1 ) ;

				if ( p_info [ playerid ] [ family_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Ежедневный", 1, 1 ) ;
				else familyAddQuestsContractsItem ( playerid, "Ежедневный", 0, 0 ) ;
					
				if ( family_info [ family_id - 1 ] [ fam_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Семейный", 1, 1 ) ;
				else familyAddQuestsContractsItem ( playerid, "Семейный", 0, 0 ) ;
					
				familyAddQuestsContractsItem ( playerid, "Граффити", 1, 1 ) ;
					
				new _fam_level = update_family_level ( family_id ) ;
				if ( _fam_level >= 2 ) familyAddQuestsContractsItem ( playerid, "Поставка", 1, 1 ) ;
				if ( _fam_level >= 3 ) familyAddQuestsContractsItem ( playerid, "Контрабанда", 1, 1 ) ;
				if ( _fam_level >= 4 ) familyAddQuestsContractsItem ( playerid, "Территории", 1, 1 ) ;
				if ( _fam_level >= 5 ) familyAddQuestsContractsItem ( playerid, "Рейдеры", 1, 1 ) ;
				if ( _fam_level >= 6 && family_info [ family_id - 1 ] [ fam_enprises_count ] ) familyAddQuestsContractsItem ( playerid, "Инкассация", 1, 1 ) ;
			}
			else if ( _param3 == 4 )
			{
				new family_id = p_info [ playerid ] [ family ], line_string [ 64 ], line_string2 [ 64 ] ;
				format ( line_string, sizeof line_string, "%d человек онлайн", Iter_Count(family_players[family_id]) ) ;
				format ( line_string2, sizeof line_string2, "%d человек оффлайн", family_info [ family_id - 1 ] [ fam_members ] ) ;

				familyShowQuestsContractsPage ( playerid, 
												line_string, 
												line_string2, 
												"Контрабанда", 
												"Захватите контрабанду и заберите перехваченое в общак семьи.",
												0,
												1,
												5,
												500_000,
												"Когда прибудет контрабанда, то на карте появится чёрный квадрат",
												1 ) ;

				if ( p_info [ playerid ] [ family_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Ежедневный", 1, 1 ) ;
				else familyAddQuestsContractsItem ( playerid, "Ежедневный", 0, 0 ) ;
					
				if ( family_info [ family_id - 1 ] [ fam_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Семейный", 1, 1 ) ;
				else familyAddQuestsContractsItem ( playerid, "Семейный", 0, 0 ) ;
					
				familyAddQuestsContractsItem ( playerid, "Граффити", 1, 1 ) ;
					
				new _fam_level = update_family_level ( family_id ) ;
				if ( _fam_level >= 2 ) familyAddQuestsContractsItem ( playerid, "Поставка", 1, 1 ) ;
				if ( _fam_level >= 3 ) familyAddQuestsContractsItem ( playerid, "Контрабанда", 1, 1 ) ;
				if ( _fam_level >= 4 ) familyAddQuestsContractsItem ( playerid, "Территории", 1, 1 ) ;
				if ( _fam_level >= 5 ) familyAddQuestsContractsItem ( playerid, "Рейдеры", 1, 1 ) ;
				if ( _fam_level >= 6 && family_info [ family_id - 1 ] [ fam_enprises_count ] ) familyAddQuestsContractsItem ( playerid, "Инкассация", 1, 1 ) ;
			}
			else if ( _param3 == 5 )
			{
				new family_id = p_info [ playerid ] [ family ], line_string [ 64 ], line_string2 [ 64 ] ;
				format ( line_string, sizeof line_string, "%d человек онлайн", Iter_Count(family_players[family_id]) ) ;
				format ( line_string2, sizeof line_string2, "%d человек оффлайн", family_info [ family_id - 1 ] [ fam_members ] ) ;

				familyShowQuestsContractsPage ( playerid, 
												line_string, 
												line_string2, 
												"Территории", 
												"Захватывайте территории и получайте рейтинг, деньги и "family_title".",
												0,
												1,
												5,
												100_000,
												"Территории отмечены на карте цветным квадратом",
												1 ) ;

				if ( p_info [ playerid ] [ family_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Ежедневный", 1, 1 ) ;
				else familyAddQuestsContractsItem ( playerid, "Ежедневный", 0, 0 ) ;
					
				if ( family_info [ family_id - 1 ] [ fam_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Семейный", 1, 1 ) ;
				else familyAddQuestsContractsItem ( playerid, "Семейный", 0, 0 ) ;
					
				familyAddQuestsContractsItem ( playerid, "Граффити", 1, 1 ) ;
					
				new _fam_level = update_family_level ( family_id ) ;
				if ( _fam_level >= 2 ) familyAddQuestsContractsItem ( playerid, "Поставка", 1, 1 ) ;
				if ( _fam_level >= 3 ) familyAddQuestsContractsItem ( playerid, "Контрабанда", 1, 1 ) ;
				if ( _fam_level >= 4 ) familyAddQuestsContractsItem ( playerid, "Территории", 1, 1 ) ;
				if ( _fam_level >= 5 ) familyAddQuestsContractsItem ( playerid, "Рейдеры", 1, 1 ) ;
				if ( _fam_level >= 6 && family_info [ family_id - 1 ] [ fam_enprises_count ] ) familyAddQuestsContractsItem ( playerid, "Инкассация", 1, 1 ) ;
			}
			else if ( _param3 == 6 )
			{
				new family_id = p_info [ playerid ] [ family ], line_string [ 64 ], line_string2 [ 64 ] ;
				format ( line_string, sizeof line_string, "%d человек онлайн", Iter_Count(family_players[family_id]) ) ;
				format ( line_string2, sizeof line_string2, "%d человек оффлайн", family_info [ family_id - 1 ] [ fam_members ] ) ;

				familyShowQuestsContractsPage ( playerid, 
												line_string, 
												line_string2, 
												"Рейдеры", 
												"Откройте раздел 'Предприятия' и отмечайте их на GPS.",
												0,
												1,
												100,
												1_000_000,
												"Раздел 'Предприятия'",
												1 ) ;

				if ( p_info [ playerid ] [ family_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Ежедневный", 1, 1 ) ;
				else familyAddQuestsContractsItem ( playerid, "Ежедневный", 0, 0 ) ;
					
				if ( family_info [ family_id - 1 ] [ fam_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Семейный", 1, 1 ) ;
				else familyAddQuestsContractsItem ( playerid, "Семейный", 0, 0 ) ;
					
				familyAddQuestsContractsItem ( playerid, "Граффити", 1, 1 ) ;
					
				new _fam_level = update_family_level ( family_id ) ;
				if ( _fam_level >= 2 ) familyAddQuestsContractsItem ( playerid, "Поставка", 1, 1 ) ;
				if ( _fam_level >= 3 ) familyAddQuestsContractsItem ( playerid, "Контрабанда", 1, 1 ) ;
				if ( _fam_level >= 4 ) familyAddQuestsContractsItem ( playerid, "Территории", 1, 1 ) ;
				if ( _fam_level >= 5 ) familyAddQuestsContractsItem ( playerid, "Рейдеры", 1, 1 ) ;
				if ( _fam_level >= 6 && family_info [ family_id - 1 ] [ fam_enprises_count ] ) familyAddQuestsContractsItem ( playerid, "Инкассация", 1, 1 ) ;
			}
			else if ( _param3 == 7 )
			{
				new family_id = p_info [ playerid ] [ family ], line_string [ 64 ], line_string2 [ 64 ] ;
				format ( line_string, sizeof line_string, "%d человек онлайн", Iter_Count(family_players[family_id]) ) ;
				format ( line_string2, sizeof line_string2, "%d человек оффлайн", family_info [ family_id - 1 ] [ fam_members ] ) ;

				familyShowQuestsContractsPage ( playerid, 
												line_string, 
												line_string2, 
												"Инкассация", 
												"Откройте раздел 'Предприятия семьи' и отмечайте их на GPS.",
												0,
												1,
												100,
												1_000_000,
												"Раздел 'Предприятия'",
												1 ) ;

				if ( p_info [ playerid ] [ family_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Ежедневный", 1, 1 ) ;
				else familyAddQuestsContractsItem ( playerid, "Ежедневный", 0, 0 ) ;
					
				if ( family_info [ family_id - 1 ] [ fam_quest ] != -1 ) familyAddQuestsContractsItem ( playerid, "Семейный", 1, 1 ) ;
				else familyAddQuestsContractsItem ( playerid, "Семейный", 0, 0 ) ;
					
				familyAddQuestsContractsItem ( playerid, "Граффити", 1, 1 ) ;
					
				new _fam_level = update_family_level ( family_id ) ;
				if ( _fam_level >= 2 ) familyAddQuestsContractsItem ( playerid, "Поставка", 1, 1 ) ;
				if ( _fam_level >= 3 ) familyAddQuestsContractsItem ( playerid, "Контрабанда", 1, 1 ) ;
				if ( _fam_level >= 4 ) familyAddQuestsContractsItem ( playerid, "Территории", 1, 1 ) ;
				if ( _fam_level >= 5 ) familyAddQuestsContractsItem ( playerid, "Рейдеры", 1, 1 ) ;
				if ( _fam_level >= 6 && family_info [ family_id - 1 ] [ fam_enprises_count ] ) familyAddQuestsContractsItem ( playerid, "Инкассация", 1, 1 ) ;
			}
		}
		else if ( _param2 == 2 )
		{
			_param3 = get_player_use_listitem ( playerid ) ;
			if ( _param3 == 0 )
			{
				new _quest_id = p_info [ playerid ] [ family_quest ] ;
				static const _quest_progress [ ] =
				{
					10,
					20,
					1,
					1,
					10,
					50,
					100,
					1
				} ;
				if ( _quest_id && p_info [ playerid ] [ family_quest_progress ] < _quest_progress [ _quest_id - 1 ] )
				{
					if ( _quest_id == 4 ) send_check_cinfo ( playerid, "Отправляйтесь к квестовому персонажу! (/gps - Прочее)", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
				}
				else
				{
					new family_id = p_info [ playerid ] [ family ], text_string [ 144 ] ;
					if ( p_info [ playerid ] [ family_quest_progress ] >= _quest_progress [ _quest_id - 1 ] )
					{
						format ( text_string, sizeof text_string, "{%s}[FAM] %s выполнил(а) задание. Награда: %d"valute_title_" и %d "family_title".", family_info [ family_id - 1 ] [ fam_chat_color ], p_info [ playerid ] [ name ], family_rewards [ _quest_id - 1 ] [ r_money ], family_rewards [ _quest_id - 1 ] [ r_exp ] ) ;
						family_message ( family_id, col_gray, text_string ) ;
							
						give_money ( playerid, family_rewards [ _quest_id - 1 ] [ r_money ] ) ;
						insert_money_log ( playerid, INVALID_PLAYER_ID, family_rewards [ _quest_id - 1 ] [ r_money ], "семейный квест" ) ;
							
						family_info [ family_id - 1 ] [ fam_rating ] += 5 ;
						family_info [ family_id - 1 ] [ fam_ticket ] += family_rewards [ _quest_id - 1 ] [ r_exp ] ;
						
						give_all_family_quest ( family_id, 5, 1 ) ;
						give_all_family_quest ( family_id, 6, 5 ) ;
						give_all_family_quest ( family_id, 7, 5 ) ;
						give_all_family_quest ( family_id, 8, 5 ) ;
							
						p_info [ playerid ] [ family_quest ] = -1 ;
						update_int_sql ( playerid, "u_family_quest", -1 ) ;
							
						give_event_progress ( playerid, THE_FAMILY_QUEST, 1 ) ;
						show_packet_family ( playerid, 255, 255, 255 ) ;
					}
				}
			}
			else if ( _param3 == 1 )
			{
				static const _quest_progress [ ] =
				{
					70,
					36,
					42,
					5000,
					100,
					500,
					400,
					300
				} ;
				
				new _fam_id = p_info [ playerid ] [ family ] ;
				new text_string [ 144 ], _quest_id = family_info [ _fam_id - 1 ] [ fam_quest ] ;
				if ( family_info [ _fam_id - 1 ] [ fam_quest_progress ] >= _quest_progress [ _quest_id - 1 ] )
				{
					format ( text_string, sizeof text_string, "{%s}[FAM] Ваша семья выполнила недельное задание. Награда: %d"valute_title_" и %d "family_title".", family_info [ _fam_id - 1 ] [ fam_chat_color ], all_family_rewards [ _quest_id - 1 ] [ r_money ], all_family_rewards [ _quest_id - 1 ] [ r_exp ] ) ;
					family_message ( _fam_id, col_gray, text_string ) ;
						
					family_info [ _fam_id - 1 ] [ fam_bank ] += all_family_rewards [ _quest_id - 1 ] [ r_money ] ;
					family_info [ _fam_id - 1 ] [ fam_rating ] += 5 ;
					family_info [ _fam_id - 1 ] [ fam_ticket ] += all_family_rewards [ _quest_id - 1 ] [ r_exp ] ;
							
					family_info [ _fam_id - 1 ] [ fam_quest ] = -1 ;
						
					format ( text_string, sizeof text_string, "UPDATE `family` SET `fam_quest` = '-1' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_id ] ) ;
					mysql_tquery ( sql_connection, text_string ) ;
					show_packet_family ( playerid, 255, 255, 255 ) ;
				}
			}
			else if ( _param3 == 2 )
			{
				new family_id = p_info [ playerid ] [ family ] ;
				if ( family_info [ family_id - 1 ] [ fam_graffity ] >= count_fam_graffity )
				{
					send_check_cinfo ( playerid, "Все граффити и так под контролем Вашей семьи.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new bool: _player_graffity = false ;
				for ( new i = 1 ; i < count_fam_graffity ; i ++ )
				{
					if ( graf_fam_info [ i ] [ g_fam_member ] == family_id ) continue ;
					if ( graf_fam_info [ i ] [ g_fam_cooldown ] > gettime ( ) ) continue ;
					
					SetPlayerRaceCheckpoint ( playerid, 1, graf_fam_info [ i ] [ gr_fam_x ] [ 0 ], graf_fam_info [ i ] [ gr_fam_x ] [ 1 ], graf_fam_info [ i ] [ gr_fam_x ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
					is_gps_used { playerid } = 1 ;
			
					send_check_cinfo ( playerid, "Свободное граффити отмечено на карте.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
					show_packet_family ( playerid, 255, 255, 255 ) ;
					
					_player_graffity = true ;
					break ;
				}
				
				if ( ! _player_graffity )
				{
					send_check_cinfo ( playerid, "На данный момент нет граффити, которое можно закрасить.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				}
			}
		}
	}
	else if ( _param == 6 ) // warehouse
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				new family_id = p_info [ playerid ] [ family ], _count = 0 ;
				if ( ! family_info [ family_id - 1 ] [ fam_house ] )
				{
					send_check_cinfo ( playerid, "У Вас нет дома семьи.", 0, 300, CINFO_FAMILY_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				familyShowWarehousePage ( playerid ) ;
				
				static const _box_id [ ] = { 153, 154, 155, 164, 165, 166, 167, 168, 169, 170, 172, 331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322, 323, 324, 325, 326, 342, 343, 346, 347, 347, 348, 349, 350, 353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367 } ;
				new line_string [ 64 ], _prise, _prise_count ;
				for ( new i = 0 ; i < sizeof _box_id ; i ++ )
				{
					if ( get_family_item ( family_id, _box_id [ i ] ) < 1 ) continue ;
					
					_count ++ ;
				}
				
				if ( _count > 0 )
				{
					new BitStream:bitstream = BS_New();
					BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
					BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
					
					BS_WriteValue(bitstream, PR_INT8, 2);
					BS_WriteValue(bitstream, PR_INT8, 40);
			
					BS_WriteValue(bitstream, PR_UINT8, _count + 1);
					for ( new i = 0 ; i < sizeof _box_id ; i ++ )
					{
						_prise_count = get_family_item ( family_id, _box_id [ i ] ) ;
						if ( _prise_count < 1 ) continue ;
						
						BS_WriteValue(bitstream, PR_UINT32, 1);
						
						if ( _prise == 155 ) format ( line_string, sizeof line_string, "%s (на складе: %d гр.)", item_name ( _box_id [ i ] ), _prise ) ;
						else if ( _prise == 154 ) format ( line_string, sizeof line_string, "%s (на складе: %d пт.)", item_name ( _box_id [ i ] ), _prise ) ;
						else if ( _prise == 153 ) format ( line_string, sizeof line_string, "%s (на складе: %d ед.)", item_name ( _box_id [ i ] ), _prise ) ;
						else format ( line_string, sizeof line_string, "%s (на складе: %d шт.)", item_name ( _box_id [ i ] ), _prise ) ;
						BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
						BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					}
					
					format ( line_string, sizeof line_string, ""family_title" (на складе: %d шт.)", family_info [ family_id - 1 ] [ fam_ticket ] ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;

					PR_SendPacket(bitstream, playerid);
					BS_Delete(bitstream);
				}
				
				_count = 0 ;
				for ( new i = 0 ; i < MAX_FAMILY_WAREHOUSE ; i ++ )
				{
					_prise = family_info [ family_id - 1 ] [ fam_slot ] [ i ] ;
					if ( _prise < 1 ) continue ;
					
					_count ++ ;
				}
				
				if ( _count > 0 )
				{
					new BitStream:bitstream = BS_New();
					BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
					BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
					
					BS_WriteValue(bitstream, PR_INT8, 2);
					BS_WriteValue(bitstream, PR_INT8, 40);
			
					BS_WriteValue(bitstream, PR_UINT8, _count);
					for ( new i = 0 ; i < MAX_FAMILY_WAREHOUSE ; i ++ )
					{
						_prise = family_info [ family_id - 1 ] [ fam_slot ] [ i ] ;
						if ( _prise < 1 ) continue ;
						
						BS_WriteValue(bitstream, PR_UINT32, 2);
						
						_prise_count = p_info [ playerid ] [ prise_slot_count ] [ i ] ;
						if ( _prise == 155 ) format ( line_string, sizeof line_string, "%s (%d гр.)", item_name ( _prise ), _prise_count ) ;
						else if ( _prise == 154 ) format ( line_string, sizeof line_string, "%s (%d пт.)", item_name ( _prise ), _prise_count ) ;
						else if ( _prise == 153 ) format ( line_string, sizeof line_string, "%s (%d ед.)", item_name ( _prise ), _prise_count ) ;
						else format ( line_string, sizeof line_string, "%s (%d шт.)", item_name ( _prise ), _prise_count ) ;
						BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
						BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					}

					PR_SendPacket(bitstream, playerid);
					BS_Delete(bitstream);
				}
			}
		}
		else if ( _param2 == 1 || _param2 == 2 )
		{
			if ( p_info [ playerid ] [ family ] )
			{
				new family_id = p_info [ playerid ] [ family ] ;
				if ( family_info [ family_id - 1 ] [ fam_house ] )
				{
					if ( GetPlayerVirtualWorld ( playerid ) == family_info [ family_id - 1 ] [ fam_house ] )
						show_family_dorm ( playerid ) ;
					
					else
						send_check_cinfo ( playerid, "Вы должны находиться в доме семьи.", 0, 300, CINFO_FAMILY_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				}
			}
		}
	}
	else if ( _param == 15 ) // warehouse logs
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
				{
					send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				familyShowWarehouseLogPage ( playerid ) ;
		
				global_string [ 0 ] = EOS ;
				format ( global_string, 200, "SELECT `id`, `name`, `Text`, `text_date`, `type` FROM `logs_family` WHERE `family` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ] ) ;
				mysql_tquery(sql_connection, global_string, "get_familys_logs_device", "ii", playerid, 39 );
			}
		}
	}
	else if ( _param == 16 ) // diplomacy
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowDiplomacyPage ( playerid ) ;
			}
		}
		else if ( _param2 == 1 )
		{
			if ( _param3 == 0 )
			{
				show_dialog ( playerid, d_diplomacy_message, DIALOG_STYLE_INPUT, "{"#cBHD"}Дипломатический чат", "{"#cWH"}Введите сообщение, которое хотите отправить Вашим союзникам:", "Отправить", "Закрыть" ) ;				
			}
		}
	}
	else if ( _param == 7 ) // family rating
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowTopFamsPage ( playerid, 0 ) ;
				mysql_tquery ( sql_connection, !"SELECT `fam_id` FROM `family` ORDER BY `family`.`fam_members` DESC", "family_rating_smali", "i", playerid ) ;
			}
		}
	}
	else if ( _param == 8 ) // players rating
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowTopPlayersPage ( playerid ) ;
				
				new family_id = p_info [ playerid ] [ family ] ;
				if ( family_users_rating_loaded [ family_id ] == true )
				{
					new line_string [ 64 ] ;
					for ( new q = 0 ; q < 3 ; q ++ )
					{
						new BitStream:bitstream = BS_New();
						BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
						BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
									
						BS_WriteValue(bitstream, PR_INT8, 3);
						BS_WriteValue(bitstream, PR_INT8, 29);
						
						BS_WriteValue(bitstream, PR_UINT8, 10);
						
						for ( new i = 0 ; i < 10 ; i ++ )
						{
							BS_WriteValue(bitstream, PR_UINT32, q + 1 ) ;
						
							BS_WriteValue(bitstream, PR_UINT8, strlen ( family_users_rating [ family_id ] [ q ] [ i ] [ fu_name ] ) ) ;
							BS_WriteValue(bitstream, PR_STRING, family_users_rating [ family_id ] [ q ] [ i ] [ fu_name ] ) ;
								
							format ( line_string, sizeof line_string, "%d", family_users_rating [ family_id ] [ q ] [ i ] [ fu_count ] ) ;
							BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
							BS_WriteValue(bitstream, PR_STRING, line_string ) ;
						}
						
						PR_SendPacket(bitstream, playerid);
						BS_Delete(bitstream);
					}
				}
				else
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 144, "SELECT `u_id`, `u_name`, `u_week_played` FROM `users` WHERE `u_family` = '%d' ORDER BY `users`.`u_week_played` DESC LIMIT 10", p_info [ playerid ] [ family ] ) ;
					mysql_tquery ( sql_connection, global_string, "family_rating_users", "ii", playerid, 1 ) ;
				}
			}
		}
	}
	else if ( _param == 9 ) // upgrade
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowUpgradePage ( playerid ) ;
				
				static const _name_enh [ ] [ 24 ] =
				{
					"Дополнительный EXP",
					"Успех в работе",
					"Бизнессмены в долгу",
					"Неузнаваемый",
					"Больница в долгу",
					"Белый список",
					"Банковские махинации",
					"Мародёры",
					"Рыбный цех",
					"Галочка",
					"Бренд"
				} ;
				
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
				BS_WriteValue(bitstream, PR_INT8, 10);
				BS_WriteValue(bitstream, PR_INT8, 49);
		
				BS_WriteValue(bitstream, PR_UINT8, 11);
				
				new line_string [ 64 ], family_id = p_info [ playerid ] [ family ] ;
				for ( new i = 0 ; i < 11 ; i ++ )
				{
					BS_WriteValue(bitstream, PR_INT8, -1);
					BS_WriteValue(bitstream, PR_UINT32, 9);
					
					BS_WriteValue(bitstream, PR_UINT8, strlen ( _name_enh [ i ] ) ) ;
					BS_WriteValue(bitstream, PR_STRING, _name_enh [ i ] ) ;
					
					if ( family_info [ family_id - 1 ] [ fam_enhancement ] [ i ] ) format ( line_string, sizeof line_string, "Куплено" ) ;
					else format ( line_string, sizeof line_string, "Купить за %d "family_title"", fam_enhancement_cost [ i ] ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					
					BS_WriteValue(bitstream, PR_INT8, 1);
					BS_WriteValue(bitstream, PR_INT8, 1);
					
					BS_WriteValue(bitstream, PR_FLOAT, 20.0);
					BS_WriteValue(bitstream, PR_FLOAT, 180.0);
					BS_WriteValue(bitstream, PR_FLOAT, 45.0);
					BS_WriteValue(bitstream, PR_FLOAT, 0.78);
				}
				
				PR_SendPacket(bitstream, playerid);
				BS_Delete(bitstream);
			}
		}
		else if ( _param2 == 1 )
		{
			if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
			{
				send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			global_string [ 0 ] = EOS ;
			if ( _param3 == 0 ) strcat ( global_string, "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Дополнительный EXP'\n\n{"#cGRDialog"}- Улучшение {"#cWH"}'Дополнительный респект' {"#cGRDialog"}все члены семьи начнут получать дополнительные 1-2 EXP каждый час." ) ;
			else if ( _param3 == 1 ) strcat ( global_string, "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Успех в работе'\n\n{"#cGRDialog"}- Улучшение {"#cWH"}'Успех в работе' {"#cGRDialog"}за выполнение заданий семья будет получать дополнительный "family_title"." ) ;
			else if ( _param3 == 2 ) strcat ( global_string, "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Бизнессмены в долгу'\n\n{"#cGRDialog"}- Улучшение {"#cWH"}'Бизнессмены в долгу' {"#cGRDialog"}понижение налогооблажения для всех членов семьи." ) ;
			else if ( _param3 == 3 ) strcat ( global_string, "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Неузнаваемый'\n\n{"#cGRDialog"}- Улучшение {"#cWH"}'Неузнаваемый' {"#cGRDialog"}время действия маски увеличивается в 2 раза." ) ;
			else if ( _param3 == 4 ) strcat ( global_string, "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Больница в долгу'\n\n{"#cGRDialog"}- Улучшение {"#cWH"}'Больница в долгу' {"#cGRDialog"}члены семьи не будут попадать в больницу после смерти." ) ;
			else if ( _param3 == 5 ) strcat ( global_string, "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Белый список'\n\n{"#cGRDialog"}- Улучшение {"#cWH"}'Белый список' {"#cGRDialog"}меньше штраф за превышение скорости." ) ;
			else if ( _param3 == 6 ) strcat ( global_string, "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Банковские махинации'\n\n{"#cGRDialog"}- Улучшение {"#cWH"}'Банковские махинации' {"#cGRDialog"}члены семьи смогут хранить до 10.000.000"valute_title_" на основном счёте." ) ;
			else if ( _param3 == 7 ) strcat ( global_string, "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Мародёры'\n\n{"#cGRDialog"}- Улучшение {"#cWH"}'Дополнительный респект' {"#cGRDialog"}все члены семьи начнут получать дополнительные 1-2 EXP каждый час." ) ;
			else if ( _param3 == 8 ) strcat ( global_string, "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Рыбный цех'\n\n{"#cGRDialog"}- Улучшение {"#cWH"}'Рыбный цех' {"#cGRDialog"}холодильник в доме пополняется автоматически." ) ;
			else if ( _param3 == 9 ) strcat ( global_string, "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Галочка'\n\n{"#cGRDialog"}- Улучшение {"#cWH"}'Галочка' {"#cGRDialog"}дополнительный "family_title" каждый час, приписка перед названием." ) ;
			else if ( _param3 == 10 ) strcat ( global_string, "{ffffff}Вы собираетесь приобрести улучшение {"#cBL"}'Бренд'\n\n{"#cGRDialog"}- Улучшение {"#cWH"}'Бренд' {"#cGRDialog"}дополнительный "family_title" каждый час, приписка после названия." ) ;

			new line_string [ 97 + 9 ] ;
			format ( line_string, sizeof line_string, "\n\n{"#cGRDialog"}* Стоимость данного улучшения составляет: {"#cBL"}%d "family_title"{ffffff}.", fam_enhancement_cost [ _param3 ] ) ;
			strcat ( global_string, line_string ) ;
			show_dialog ( playerid, d_family_upgrade1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приобрести улучшение", global_string, "Приобрести", "Отмена" ) ;
			SetPVarInt ( playerid, "PlayerEnhancement", _param3 ) ;
		}
	}
	else if ( _param == 10 ) // shop
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowShopPage ( playerid ) ;
				
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
				BS_WriteValue(bitstream, PR_INT8, 10);
				BS_WriteValue(bitstream, PR_INT8, 48);
		
				BS_WriteValue(bitstream, PR_UINT8, MAX_FAMILY_TRADE_ITEM);
				
				new line_string [ 32 ] ;
				for ( new i = 0 ; i < MAX_FAMILY_TRADE_ITEM ; i ++ )
				{
					BS_WriteValue(bitstream, PR_INT8, family_trade [ i ] [ family_render_type ]);
					BS_WriteValue(bitstream, PR_UINT32, family_trade [ i ] [ family_render_model ]);
					
					BS_WriteValue(bitstream, PR_UINT8, strlen ( family_trade [ i ] [ family_name ] ) ) ;
					BS_WriteValue(bitstream, PR_STRING, family_trade [ i ] [ family_name ] ) ;
					
					format ( line_string, sizeof line_string, "%d "family_title"", family_trade [ i ] [ family_price ] ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					
					BS_WriteValue(bitstream, PR_INT8, 1);
					BS_WriteValue(bitstream, PR_INT8, 1);
					
					BS_WriteValue(bitstream, PR_FLOAT, 20.0);
					BS_WriteValue(bitstream, PR_FLOAT, 180.0);
					BS_WriteValue(bitstream, PR_FLOAT, 45.0);
					BS_WriteValue(bitstream, PR_FLOAT, 0.78);
				}
				
				PR_SendPacket(bitstream, playerid);
				BS_Delete(bitstream);
			}
		}
		else if ( _param2 == 1 )
		{
			if ( _param3 == MAX_FAMILY_TRADE_ITEM - 1 )
			{
				if ( ! p_info [ playerid ] [ family ] )
				{
					send_check_cinfo ( playerid, "Вы не состоите в семье!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
					
				new family_id = p_info [ playerid ] [ family ] ;
				if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] )
				{
					send_check_cinfo ( playerid, "Покупать может только лидер семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( family_info [ family_id - 1 ] [ fam_ticket ] < family_trade [ _param3 ] [ family_price ] )
				{
					send_check_cinfo ( playerid, "На балансе Вашей семьи недостаточно "family_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new _h_id = family_info [ family_id - 1 ] [ fam_house ] ;
				if ( _h_id < 1 )
				{
					send_check_cinfo ( playerid, "У Вашей семьи нет дома!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( h_info [ _h_id - 1 ] [ h_podezd ] != -1 )
				{
					send_check_cinfo ( playerid, "У Вашей семьи не частный дом!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
					
				if ( family_info [ family_id - 1 ] [ fam_max_car ] + 1 > 10 )
				{
					send_check_cinfo ( playerid, "Семья не может иметь более 10 парковочных мест!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
					
				family_info [ family_id - 1 ] [ fam_ticket ] -= family_trade [ _param3 ] [ family_price ] ;
					
				family_info [ family_id - 1 ] [ fam_max_car ] ++ ;
						
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "UPDATE `family` SET `fam_max_car` = '%d', `fam_ticket` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_max_car ], family_info [ family_id - 1 ] [ fam_ticket ], family_id ) ;
				mysql_tquery(sql_connection, global_string ) ;
						
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "%s купил(а) %s за %d семейных талонов.", p_info [ playerid ] [ name ], family_trade [ _param3 ] [ family_name ], family_trade [ _param3 ] [ family_price ] ) ;
				write_family ( playerid, family_id, TYPE_LOG_OBWYAK, global_string ) ;
			}
			else
			{
				if ( p_info [ playerid ] [ family_ticket ] < family_trade [ _param3 ] [ family_price ] )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно "family_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
					
				p_info [ playerid ] [ family_ticket ] -= family_trade [ _param3 ] [ family_price ] ;
				update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;

				new _inv_type = family_trade [ _param3 ] [ family_inv_type ] ;
				if ( _inv_type == GIVE_TYPE_INVENTORY )
				{
					give_player_item_prise ( playerid, family_trade [ _param3 ] [ family_prise ], 1 ) ;
					send_check_cinfo ( playerid, "Используйте \"/mm - Инвентарь - Подарочный инвентарь\"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
				}
				else if ( _inv_type == GIVE_TYPE_ACESSORIES )
				{
					give_player_item ( playerid, family_trade [ _param3 ] [ family_prise ] ) ;
					send_check_cinfo ( playerid, "Используйте \"/mm - Инвентарь - Аксессуары\"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
				}
						
				new query_string [ 128 ] ;
				format ( query_string, sizeof query_string, "%s приобрел(а) %s за семейные талоны.", p_info [ playerid ] [ name ], family_trade [ _param3 ] [ family_name ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_FAMTRADE, query_string ) ;
				
				show_packet_family ( playerid, 10, 0, 0 ) ;
			}
		}
	}
	else if ( _param == 11 ) // graffiti color
	{
		if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
		{
			send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
			
		if ( _param2 == 1 )
		{
			if ( _param3 == 0 )
			{
				new family_id = p_info [ playerid ] [ family ] ;
				if ( family_info [ family_id - 1 ] [ fam_ticket ] < 500 )
				{
					send_check_cinfo ( playerid, "У Вашей семьи недостаточно "family_title".", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
					return 1 ;
				}
				
				new _color_id = get_player_use_listitem ( playerid ) ;
				family_info [ family_id - 1 ] [ fam_graffity_color ] = _color_id ;
				family_info [ family_id - 1 ] [ fam_ticket ] -= 500 ;
						
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "UPDATE `family` SET `fam_graffity_color` = '%d', `fam_ticket` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ family_id - 1 ] [ fam_graffity_color ], family_info [ family_id - 1 ] [ fam_ticket ], family_id ) ;
				mysql_tquery(sql_connection, global_string ) ;
				
				static const _color [ ] [ 10 ] =
				{
					"{ffffff}",
					"{ad01bc}",
					"{ffa200}",
					"{861400}",
					"{00de00}",
					"{e9ff00}",
					"{0c00ff}",
					"{00b7ff}",
					"{ff00ff}",
					"{ff0000}"
				} ;
				
				for ( new i = 1 ; i < count_fam_graffity ; i ++ )
				{
					new _family_id = graf_fam_info [ i ] [ g_fam_member ] ;
					if ( _family_id != family_id ) continue ;
					
					DestroyDynamicObject ( graf_fam_info [ i ] [ g_fam_object ] ) ;
					graf_fam_info [ i ] [ g_fam_object ] = CreateDynamicObject ( 2934, graf_fam_info [ i ] [ gr_fam_x ] [ 0 ], graf_fam_info [ i ] [ gr_fam_x ] [ 1 ], graf_fam_info [ i ] [ gr_fam_x ] [ 2 ], graf_fam_info [ i ] [ gr_fam_x ] [ 3 ], graf_fam_info [ i ] [ gr_fam_x ] [ 4 ], graf_fam_info [ i ] [ gr_fam_x ] [ 5 ], 0, 0 ) ;
					
					global_string [ 0 ] = EOS ;
					format ( global_string, 64, "%s%s", _color [ _color_id ], family_info [ family_id - 1 ] [ fam_name ] ) ;
					SetDynamicObjectMaterialText(graf_fam_info [ i ] [ g_fam_object ], 0, global_string, 130, "Ariel", 48, 1, 0xFFFFFAF0, 0x00000000, 1);
				}
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "%s купил(а) новый цвет граффити за %d семейных талонов.", p_info [ playerid ] [ name ], 500 ) ;
				write_family ( playerid, family_id, TYPE_LOG_OBWYAK, global_string ) ;
				
				send_check_cinfo ( playerid, "Вы успешно сменили цвет Ваших граффити.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
			}
		}
		else if ( _param2 == 2 && _param3 < 10 )
		{
			send_check_cinfo ( playerid, "Вы выбрали цвет. Можете приобрести его.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
			set_player_use_listitem ( playerid, _param3 ) ;
		}
	}
	else if ( _param == 12 ) // graffiti text
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				new _family_id = p_info [ playerid ] [ family ] ;
				if ( family_info [ _family_id - 1 ] [ fam_graffity ] < 1 )
				{
					send_check_cinfo ( playerid, "У Вашей семьи нет захваченных граффити!\nИщите граффити по карте и закрашивайте.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
		
				familyShowChangeGraffitiPage ( playerid ) ;
				
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
				BS_WriteValue(bitstream, PR_INT8, 2);
				BS_WriteValue(bitstream, PR_INT8, 27);
				
				BS_WriteValue(bitstream, PR_UINT8, family_info [ _family_id - 1 ] [ fam_graffity ]);
				
				for ( new i = 1 ; i < count_fam_graffity ; i ++ )
				{
					_family_id = graf_fam_info [ i ] [ g_fam_member ] ;
					if ( _family_id != p_info [ playerid ] [ family ] ) continue ;
					
					BS_WriteValue(bitstream, PR_UINT32, 2934);
					
					BS_WriteValue(bitstream, PR_UINT8, strlen ( family_info [ _family_id - 1 ] [ fam_name ] ) ) ;
					BS_WriteValue(bitstream, PR_STRING, family_info [ _family_id - 1 ] [ fam_name ] ) ;
				}
				
				PR_SendPacket(bitstream, playerid);
				BS_Delete(bitstream);
			}
		}
		else if ( _param2 == 1 )
		{
			familyShowBuyGraffitiPage ( playerid, "Купить за 500 "family_title"" ) ;
		}
	}
	else if ( _param == 13 ) // ranks players
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowSettingsRanksPage ( playerid, _param3 ) ;
				page_rows [ playerid ] = 100 ;
				page_count [ playerid ] = 1 ;
			}
			else page_rows [ playerid ] += 100 ;
			
			if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
			{
				new _players_count = 0, family_id = p_info [ playerid ] [ family ] ;
				foreach(new i: family_players[family_id])
				{
					if ( p_info [ i ] [ family ] != family_id ) continue ;
					if ( p_info [ i ] [ family_rang ] != _param3 + 1 ) continue ;
					
					_players_count ++ ;
				}
				if ( ! _players_count )
				{
					send_check_cinfo ( playerid, "Нет членов семьи на выбранном ранге!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
				BS_WriteValue(bitstream, PR_INT8, 3);
				BS_WriteValue(bitstream, PR_INT8, 42);
				
				BS_WriteValue(bitstream, PR_UINT8, _players_count);
				
				new line_string [ 64 ] ;
				foreach(new i: family_players[family_id])
				{
					if ( p_info [ i ] [ family ] != family_id ) continue ;
					if ( p_info [ i ] [ family_rang ] != _param3 + 1 ) continue ;
					
					format ( line_string, sizeof line_string, "%d", p_info [ i ] [ id ] ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					
					BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ i ] [ name ] ) ) ;
					BS_WriteValue(bitstream, PR_STRING, p_info [ i ] [ name ] ) ;
					
					// онлайн за неделю
					format ( line_string, sizeof line_string, "%d час(ов)", p_info [ i ] [ week_played ] ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
				}
				
				PR_SendPacket(bitstream, playerid);
				BS_Delete(bitstream);
			}
			else
			{
				global_string [ 0 ] = EOS ;
				mysql_format ( sql_connection, global_string, 144, "SELECT `u_id`,`u_name`,`u_fam_warning`,`u_week_played` FROM `users` WHERE `u_family` = '%d' AND `u_family_rank` = '%d' LIMIT %d", p_info [ playerid ] [ family ], page_count [ playerid ], page_rows [ playerid ] ) ;
				mysql_tquery ( sql_connection, global_string, "callback_offamily_device", "ii", playerid, 42 ) ;
			}
		}
		else if ( _param2 == 1 )
		{
			familyShowSettingsRanksPage ( playerid, _param3 ) ;
			page_rows [ playerid ] = 100 ;
			page_count [ playerid ] = _param3 + 1 ;
			
			if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
			{
				new _players_count = 0, family_id = p_info [ playerid ] [ family ] ;
				foreach(new i: family_players[family_id])
				{
					if ( p_info [ i ] [ family ] != family_id ) continue ;
					if ( p_info [ i ] [ family_rang ] != _param3 + 1 ) continue ;
					
					_players_count ++ ;
				}
				if ( ! _players_count )
				{
					send_check_cinfo ( playerid, "Нет членов семьи на выбранном ранге!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
				BS_WriteValue(bitstream, PR_INT8, 3);
				BS_WriteValue(bitstream, PR_INT8, 42);
				
				BS_WriteValue(bitstream, PR_UINT8, _players_count);
				
				new line_string [ 64 ] ;
				foreach(new i: family_players[family_id])
				{
					if ( p_info [ i ] [ family ] != family_id ) continue ;
					if ( p_info [ i ] [ family_rang ] != _param3 + 1 ) continue ;
					
					format ( line_string, sizeof line_string, "%d", p_info [ i ] [ id ] ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					
					BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ i ] [ name ] ) ) ;
					BS_WriteValue(bitstream, PR_STRING, p_info [ i ] [ name ] ) ;
					
					// онлайн за неделю
					format ( line_string, sizeof line_string, "%d час(ов)", p_info [ i ] [ week_played ] ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
				}
				
				PR_SendPacket(bitstream, playerid);
				BS_Delete(bitstream);
			}
			else
			{
				global_string [ 0 ] = EOS ;
				mysql_format ( sql_connection, global_string, 144, "SELECT `u_id`,`u_name`,`u_fam_warning`,`u_week_played` FROM `users` WHERE `u_family` = '%d' AND `u_family_rank` = '%d' LIMIT %d", p_info [ playerid ] [ family ], page_count [ playerid ], page_rows [ playerid ] ) ;
				mysql_tquery ( sql_connection, global_string, "callback_offamily_device", "ii", playerid, 42 ) ;
			}
		}
		else if ( _param2 == 2 )
		{
			if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
			{
				send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			global_string [ 0 ] = EOS ;
			mysql_format ( sql_connection, global_string, 156, "UPDATE `users` SET `u_family_rank` = `u_family_rank` - '1' WHERE `u_id` = '%d' AND `u_family_rank` > '1' AND `u_family_rank` < '%d' LIMIT 1", _param3, p_info [ playerid ] [ family_rang ] ) ;
			mysql_tquery ( sql_connection, global_string ) ;
		}
		else if ( _param2 == 3 )
		{
			if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
			{
				send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			global_string [ 0 ] = EOS ;
			mysql_format ( sql_connection, global_string, 144, "UPDATE `users` SET `u_family_rank` = `u_family_rank` + '1' WHERE `u_id` = '%d' AND `u_family_rank` < '%d' LIMIT 1", _param3, p_info [ playerid ] [ family_rang ] - 1 ) ;
			mysql_tquery ( sql_connection, global_string ) ;
		}
	}
	else if ( _param == 14 ) // vehicles
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowSettingsCarsPage ( playerid ) ;
				
				new family_id = p_info [ playerid ] [ family ] ;
				if ( ! family_info [ family_id - 1 ] [ fam_house ] )
				{
					send_check_cinfo ( playerid, "У Вас нет дома семьи.", 0, 300, CINFO_FAMILY_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] )
				{
					new _count = 0 ;
					foreach(new i: family_vehicles[family_id])
					{
						if ( veh_info [ i - 1 ] [ v_type ] != vehicle_type_family ) continue ;
						if ( veh_info [ i - 1 ] [ v_owner ] != family_id ) continue ;
					
						_count ++ ;
					}
					
					if ( ! _count )
					{
						send_check_cinfo ( playerid, "Нет загруженного транспорта.", 0, 300, CINFO_FAMILY_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
					
					new BitStream:bitstream = BS_New();
					BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
					BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
					
					BS_WriteValue(bitstream, PR_INT8, 11);
					BS_WriteValue(bitstream, PR_INT8, 44);
					
					BS_WriteValue(bitstream, PR_UINT8, _count);

					foreach(new i: family_vehicles[family_id])
					{
						if ( veh_info [ i - 1 ] [ v_type ] != vehicle_type_family ) continue ;
						if ( veh_info [ i - 1 ] [ v_owner ] != family_id ) continue ;
						
						BS_WriteValue(bitstream, PR_INT8, 3);
						BS_WriteValue(bitstream, PR_UINT32, veh_info [ i - 1 ] [ v_model ]);
						
						BS_WriteValue(bitstream, PR_UINT8, strlen ( GetVehicleNameEx ( -1, veh_info [ i - 1 ] [ v_model ] ) ) ) ;
						BS_WriteValue(bitstream, PR_STRING, GetVehicleNameEx ( -1, veh_info [ i - 1 ] [ v_model ] ) ) ;
						
						BS_WriteValue(bitstream, PR_INT8, veh_info [ i - 1 ] [ v_color ] [ 0 ]);
						BS_WriteValue(bitstream, PR_INT8, veh_info [ i - 1 ] [ v_color ] [ 1 ]);
					
						BS_WriteValue(bitstream, PR_FLOAT, 20.0);
						BS_WriteValue(bitstream, PR_FLOAT, 180.0);
						BS_WriteValue(bitstream, PR_FLOAT, 45.0);
						BS_WriteValue(bitstream, PR_FLOAT, 0.78);
						
						BS_WriteValue(bitstream, PR_UINT8, strlen ( "Заспавнить" ) ) ;
						BS_WriteValue(bitstream, PR_STRING, "Заспавнить" ) ;
						BS_WriteValue(bitstream, PR_INT8, 1);
					}
					
					PR_SendPacket(bitstream, playerid);
					BS_Delete(bitstream);
				}
				else
				{
					static const _str [ ] = "SELECT `sv_id`, `sv_model`, `sv_use`, `sv_color_1`, `sv_color_2` FROM `familys_vehicles` WHERE `sv_owner` = '%d' LIMIT %d" ;
					new sql_string [ sizeof _str + 9 + 4 ] ;
					format ( sql_string, sizeof sql_string, _str, family_id, family_info [ family_id - 1 ] [ fam_max_car ] ) ;
					mysql_tquery ( sql_connection, sql_string, "family_vehicles_li_device", "ddd", playerid, 1, _param3 ) ;
				}
			}
		}
		else if ( _param2 == 1 )
		{
			new family_id = p_info [ playerid ] [ family ] ;
			if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] )
			{
				if ( end_for_job ( playerid ) )
				{
					show_packet_family ( playerid, 14, 0, 0 ) ;
				}
				return 1 ;
			}
			else
			{
				if ( player_rentcar [ playerid ] != INVALID_VEHICLE_ID )
				{
					send_check_cinfo ( playerid, "Вы уже арендуете транспорт, сначала откажитесь от старого {"#cRD"}/stoprent{"#cWH"}.", 0, 300, CINFO_FAMILY_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( family_info [ family_id - 1 ] [ fam_car_cooldown ] [ 1 ] > gettime ( ) )
				{
					send_check_cinfo ( playerid, "Транспорт можно брать раз в {"#cRInfo"}60 секунд{"#cWH"}.", 0, 300, CINFO_FAMILY_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				static const _str [ ] = "SELECT `sv_id`, `sv_use` FROM `familys_vehicles` WHERE `sv_owner` = '%d' LIMIT %d" ;
				new sql_string [ sizeof _str + 9 + 4 ] ;
				format ( sql_string, sizeof sql_string, _str, family_id, family_info [ family_id - 1 ] [ fam_max_car ] ) ;
				mysql_tquery ( sql_connection, sql_string, "family_vehicles_li_device", "ddd", playerid, 2, _param3 ) ;
			}
		}
		else if ( _param2 == 2 )
		{
			new family_id = p_info [ playerid ] [ family ] ;
			if ( p_info [ playerid ] [ family_rang ] < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] )
			{
				send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			static const _str [ ] = "SELECT `sv_id`, `sv_use` FROM `familys_vehicles` WHERE `sv_owner` = '%d' LIMIT %d" ;
			new sql_string [ sizeof _str + 9 + 4 ] ;
			format ( sql_string, sizeof sql_string, _str, family_id, family_info [ family_id - 1 ] [ fam_max_car ] ) ;
			mysql_tquery ( sql_connection, sql_string, "family_vehicles_li_device", "ddd", playerid, 3, _param3 ) ;
		}
	}
	else if ( _param == 47 ) // family logs
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
				{
					send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				familyShowSettingsLogPage ( playerid ) ;
		
				global_string [ 0 ] = EOS ;
				format ( global_string, 200, "SELECT `id`, `name`, `Text`, `text_date`, `type` FROM `logs_family` WHERE `family` = '%d' ORDER BY `logs_family`.`id` DESC LIMIT 200", p_info [ playerid ] [ family ] ) ;
				mysql_tquery(sql_connection, global_string, "get_familys_logs_device", "ii", playerid, 31 );
			}
		}
	}
	else if ( _param == 22 ) // graffiti text
	{
		if ( _param2 == 0 ) // click button
		{
			if ( _param3 == 0 )
			{
				new family_id = p_info [ playerid ] [ family ], line_string [ 64 ], line_string2 [ 64 ] ;
				format ( line_string, sizeof line_string, "%d человек онлайн", Iter_Count(family_players[family_id]) ) ;
				format ( line_string2, sizeof line_string2, "%d человек оффлайн", family_info [ family_id - 1 ] [ fam_members ] ) ;
				familyShowQGInfoPage ( playerid, line_string, line_string2, "Информация", 1, 8, 23 ) ;
				
				if ( family_info [ family_id - 1 ] [ fam_enprises_count ] < 1 )
				{
					send_check_cinfo ( playerid, "У Вашей семьи нет предприятий под контролем!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
				BS_WriteValue(bitstream, PR_INT8, 2);
				BS_WriteValue(bitstream, PR_INT8, 48);
				
				BS_WriteValue(bitstream, PR_UINT8, family_info [ family_id - 1 ] [ fam_enprises_count ]);
				
				for ( new i = 0 ; i < family_enprises_count ; i ++ )
				{
					if ( family_id != fam_enprises [ i ] [ fe_owner ] ) continue ;
					
					BS_WriteValue(bitstream, PR_UINT32, fam_enprises [ i ] [ fe_skin_model ]);
					
					BS_WriteValue(bitstream, PR_UINT8, strlen ( family_info [ family_id - 1 ] [ fam_name ] ) ) ;
					BS_WriteValue(bitstream, PR_STRING, family_info [ family_id - 1 ] [ fam_name ] ) ;
				}
				
				PR_SendPacket(bitstream, playerid);
				BS_Delete(bitstream);
			}
		}
		else if ( _param2 == 1 )
		{
			new _count = 0 ;
			for ( new i = 0 ; i < family_enprises_count ; i ++ )
			{
				if ( _count != _param3 )
				{
					_count ++ ;
					continue ;
				}
				
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
				is_gps_used { playerid } = 1 ;

				SetPlayerRaceCheckpoint ( playerid, 1, fam_enprises [ _count ] [ fe_coord ] [ 0 ], fam_enprises [ _count ] [ fe_coord ] [ 1 ], fam_enprises [ _count ] [ fe_coord ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			}
		}
	}
	else if ( _param == 23 ) // family wars
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				new family_id = p_info [ playerid ] [ family ], line_string [ 64 ], line_string2 [ 64 ] ;
				format ( line_string, sizeof line_string, "%d человек онлайн", Iter_Count(family_players[family_id]) ) ;
				format ( line_string2, sizeof line_string2, "%d человек оффлайн", family_info [ family_id - 1 ] [ fam_members ] ) ;
				familyShowQuestsWarsPage ( playerid, line_string, line_string2 ) ;
			}
		}
		else if ( _param2 == 1 )
		{
			static const dip_status [ ] [ ] =
			{
				"{FFF2C7}Нейтралитет",
				"{"#cRD"}Война",
				"{"#cGN"}Союз",
				"{"#cBL"}Запрос на союз",
				"{"#cBL"}Запрос на союз"
			} ;

			new step = 0,
				line_string [ 128 ],
				family_id = p_info [ playerid ] [ family ],
				row_count ;

			global_string [ 0 ] = EOS ;
			for ( new i = 0 ; i < family_count ; i ++ )
			{
			    if ( step == 7 ) break ;
			    if ( family_id == i + 1 ) continue ;
				if ( family_diplomacy [ family_id ] [ i + 1 ] == dip_status_war || family_diplomacy [ family_id ] [ i + 1 ] == dip_status_neutral ) continue ;
						
				set_player_listitem_values ( playerid, step, i ) ;

				format ( line_string, sizeof line_string, "{"#cBL"}%i. {%s}%s{"#cWH"} - %s{"#cWH"}, Создатель: %s\n", step + 1, family_info [ i ] [ fam_chat_color ], family_info [ i ] [ fam_name ], dip_status [ family_diplomacy [ family_id ] [ i + 1 ] ], family_info [ i ] [ fam_creator ] ) ;
				strcat ( global_string, line_string ) ;
						
				step ++ ;
				row_count ++ ;
				if ( step == 7 ) SetPVarInt ( playerid, "dip_step", step ) ;
			}
					
            strcat ( global_string, "{"#cGN"}Добавить дружескую семью\n" ) ;
			set_player_use_page ( playerid, row_count, 0 ) ;
					
			show_dialog ( playerid, d_fam_dip_list, DIALOG_STYLE_LIST, "{"#cBHD"}Дружеские семьи", global_string, "Выбрать", "Закрыть" ) ;
		}
		else if ( _param2 == 2 )
		{
			if ( ! GetString ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_creator ], p_info [ playerid ] [ name ] ) )
			{
				show_family ( playerid ) ;
				send_check_cinfo ( playerid, "Передавать семью может только создатель.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			show_dialog ( playerid, d_family_creator, DIALOG_STYLE_INPUT, "{"#cBHD"}Передача семьи", "{"#cWH"}Введите ID игрока, которому хотите передать семью:", "Принять", "Назад" ) ;
		}
		else if ( _param2 == 3 )
		{
		    static const dip_status [ ] [ ] =
			{
				"{FFF2C7}Нейтралитет",
				"{"#cRD"}Война",
				"{"#cGN"}Союз",
				"{"#cBL"}Запрос на союз",
				"{"#cBL"}Запрос на союз"
			} ;
				
		    new step = 0,
				line_string [ 128 ],
				family_id = p_info [ playerid ] [ family ],
				row_count ;

			global_string [ 0 ] = EOS ;
			for ( new i = 0 ; i < family_count ; i ++ )
			{
				if ( step == 7 ) break ;
			    if ( family_id == i + 1 ) continue ;
				if ( family_diplomacy [ family_id ] [ i + 1 ] != dip_status_war ) continue ;
				
				set_player_listitem_values ( playerid, step, i ) ;

				format ( line_string, sizeof line_string, "{"#cBL"}%i. {%s}%s{"#cWH"} - %s{"#cWH"}, Создатель: %s\n", step + 1, family_info [ i ] [ fam_chat_color ], family_info [ i ] [ fam_name ], dip_status [ family_diplomacy [ family_id ] [ i + 1 ] ], family_info [ i ] [ fam_creator ] ) ;
				strcat ( global_string, line_string ) ;
						
				step ++ ;
				row_count ++ ;
				if ( step == 7 ) SetPVarInt ( playerid, "dip_step", step ) ;
			}
					
			strcat ( global_string, "{"#cRD"}Добавить враждебную семью\n" ) ;
			set_player_use_page ( playerid, row_count, 1 ) ;
					
			show_dialog ( playerid, d_fam_dip_list, DIALOG_STYLE_LIST, "{"#cBHD"}Враждебные семьи", global_string, "Выбрать", "Закрыть" ) ;
		}
	}
	else if ( _param == 24 ) // graffiti map
	{
		if ( _param2 == 0 ) // click button
		{
			if ( _param3 == 0 )
			{
				new family_id = p_info [ playerid ] [ family ], line_string [ 64 ], line_string2 [ 64 ] ;
				format ( line_string, sizeof line_string, "%d человек онлайн", Iter_Count(family_players[family_id]) ) ;
				format ( line_string2, sizeof line_string2, "%d человек оффлайн", family_info [ family_id - 1 ] [ fam_members ] ) ;
				familyShowQGInfoPage ( playerid, line_string, line_string2, "Информация", 1, 6, 24 ) ;
				
				if ( family_enprises_count < 1 )
				{
					send_check_cinfo ( playerid, "В игре нет предприятий!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
				BS_WriteValue(bitstream, PR_INT8, 2);
				BS_WriteValue(bitstream, PR_INT8, 48);
				
				BS_WriteValue(bitstream, PR_UINT8, family_enprises_count);
				
				for ( new i = 0 ; i < family_enprises_count ; i ++ )
				{
					BS_WriteValue(bitstream, PR_UINT32, fam_enprises [ i ] [ fe_skin_model ]);
					
					family_id = fam_enprises [ i ] [ fe_owner ] ;
					if ( family_id == -1 )
					{
						BS_WriteValue(bitstream, PR_UINT8, strlen ( "Нет владельца" ) ) ;
						BS_WriteValue(bitstream, PR_STRING, "Нет владельца" ) ;
					}
					else
					{
						BS_WriteValue(bitstream, PR_UINT8, strlen ( family_info [ family_id - 1 ] [ fam_name ] ) ) ;
						BS_WriteValue(bitstream, PR_STRING, family_info [ family_id - 1 ] [ fam_name ] ) ;
					}
				}
				
				PR_SendPacket(bitstream, playerid);
				BS_Delete(bitstream);
			}
		}
		else if ( _param2 == 1 )
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;

			SetPlayerRaceCheckpoint ( playerid, 1, fam_enprises [ _param3 ] [ fe_coord ] [ 0 ], fam_enprises [ _param3 ] [ fe_coord ] [ 1 ], fam_enprises [ _param3 ] [ fe_coord ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		}
	}
	else if ( _param == 20 ) // online players
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowMembersOnlinePage ( playerid ) ;
				
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
				BS_WriteValue(bitstream, PR_INT8, 5);
				BS_WriteValue(bitstream, PR_INT8, 33);
		
				new family_id = p_info [ playerid ] [ family ], line_string [ 64 ] ;
				BS_WriteValue(bitstream, PR_UINT8, Iter_Count(family_players[family_id]));
				foreach(new i: family_players[family_id])
				{
					format ( line_string, sizeof line_string, "%d", p_info [ i ] [ id ] ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					
					BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ i ] [ name ] ) ) ;
					BS_WriteValue(bitstream, PR_STRING, p_info [ i ] [ name ] ) ;
					
					format ( line_string, sizeof line_string, "%d / 3", p_info [ i ] [ fam_warning ] ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					
					// онлайн за неделю
					format ( line_string, sizeof line_string, "%d час(ов)", p_info [ i ] [ week_played ] ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;

					format ( line_string, sizeof line_string, "В игре" ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
				}
				
				PR_SendPacket(bitstream, playerid);
				BS_Delete(bitstream);
			}
		}
		else if ( _param2 == 1 )
		{
			if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
			{
				send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( p_info [ playerid ] [ id ] == _param3 )
			{
				send_check_cinfo ( playerid, "Вы выбрали себя!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			global_string [ 0 ] = EOS ;
			mysql_format ( sql_connection, global_string, 144, "SELECT `u_name` FROM `users` WHERE `u_id` = '%d' LIMIT 1", _param3 ) ;
			mysql_tquery ( sql_connection, global_string, "callback_offamily_name", "i", playerid ) ;
		}
	}
	else if ( _param == 17 ) // ranks players
	{
		if ( _param2 == 0 )
		{
			familyShowMembersRanksPage ( playerid, _param3 ) ;
				
			new _players_count = 0, family_id = p_info [ playerid ] [ family ] ;
			foreach(new i: family_players[family_id])
			{
				if ( p_info [ i ] [ family ] != family_id ) continue ;
				if ( p_info [ i ] [ family_rang ] != _param3 + 1 ) continue ;
					
				_players_count ++ ;
			}
			if ( ! _players_count )
			{
				send_check_cinfo ( playerid, "Нет членов семьи на выбранном ранге!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			new BitStream:bitstream = BS_New();
			BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
			BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
			BS_WriteValue(bitstream, PR_INT8, 5);
			BS_WriteValue(bitstream, PR_INT8, 35);
				
			BS_WriteValue(bitstream, PR_UINT8, Iter_Count(family_players[family_id]));
				
			new line_string [ 64 ] ;
			foreach(new i: family_players[family_id])
			{
				if ( p_info [ i ] [ family ] != family_id ) continue ;
				if ( p_info [ i ] [ family_rang ] != _param3 + 1 ) continue ;
					
				format ( line_string, sizeof line_string, "%d", p_info [ i ] [ id ] ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
				BS_WriteValue(bitstream, PR_STRING, line_string ) ;
				
				BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ i ] [ name ] ) ) ;
				BS_WriteValue(bitstream, PR_STRING, p_info [ i ] [ name ] ) ;
					
				format ( line_string, sizeof line_string, "%d / 3", p_info [ i ] [ fam_warning ] ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
				BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					
				// онлайн за неделю
				format ( line_string, sizeof line_string, "%d час(ов)", p_info [ i ] [ week_played ] ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
				BS_WriteValue(bitstream, PR_STRING, line_string ) ;

				format ( line_string, sizeof line_string, "В игре" ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
				BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			}
				
			PR_SendPacket(bitstream, playerid);
			BS_Delete(bitstream);
			
			//new query_string [ 144 ] ;
			//mysql_format ( sql_connection, query_string, 144, "SELECT `u_id`,`u_name`,`u_fam_warning` FROM `users` WHERE `u_family` = '%d' AND `u_family_rank` = '%d'", p_info [ playerid ] [ family ], _param3 + 1 ) ;
			//mysql_tquery ( sql_connection, query_string, "callback_offamily_device", "ii", playerid, 35 ) ;
		}
		else if ( _param2 == 1 )
		{
			familyShowMembersRanksPage ( playerid, _param3 ) ;
			
			new _players_count = 0, family_id = p_info [ playerid ] [ family ] ;
			foreach(new i: family_players[family_id])
			{
				if ( p_info [ i ] [ family ] != family_id ) continue ;
				if ( p_info [ i ] [ family_rang ] != _param3 + 1 ) continue ;
					
				_players_count ++ ;
			}
			if ( ! _players_count )
			{
				send_check_cinfo ( playerid, "Нет членов семьи на выбранном ранге!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			new BitStream:bitstream = BS_New();
			BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
			BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
			BS_WriteValue(bitstream, PR_INT8, 5);
			BS_WriteValue(bitstream, PR_INT8, 35);
				
			BS_WriteValue(bitstream, PR_UINT8, Iter_Count(family_players[family_id]));
				
			new line_string [ 64 ] ;
			foreach(new i: family_players[family_id])
			{
				if ( p_info [ i ] [ family ] != family_id ) continue ;
				if ( p_info [ i ] [ family_rang ] != _param3 + 1 ) continue ;
					
				format ( line_string, sizeof line_string, "%d", p_info [ i ] [ id ] ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
				BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					
				BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ i ] [ name ] ) ) ;
				BS_WriteValue(bitstream, PR_STRING, p_info [ i ] [ name ] ) ;
					
				format ( line_string, sizeof line_string, "%d / 3", p_info [ i ] [ fam_warning ] ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
				BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					
				// онлайн за неделю
				format ( line_string, sizeof line_string, "%d час(ов)", p_info [ i ] [ week_played ] ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
				BS_WriteValue(bitstream, PR_STRING, line_string ) ;

				format ( line_string, sizeof line_string, "В игре" ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
				BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			}
				
			PR_SendPacket(bitstream, playerid);
			BS_Delete(bitstream);
			
			//new query_string [ 144 ] ;
			//mysql_format ( sql_connection, query_string, 144, "SELECT `u_id`,`u_name`,`u_fam_warning` FROM `users` WHERE `u_family` = '%d' AND `u_family_rank` = '%d'", p_info [ playerid ] [ family ], _param3 + 1 ) ;
			//mysql_tquery ( sql_connection, query_string, "callback_offamily_device", "ii", playerid, 35 ) ;
		}
		else if ( _param2 == 2 )
		{
			if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
			{
				send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( p_info [ playerid ] [ id ] == _param3 )
			{
				send_check_cinfo ( playerid, "Вы выбрали себя!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			global_string [ 0 ] = EOS ;
			mysql_format ( sql_connection, global_string, 100, "SELECT `u_name` FROM `users` WHERE `u_id` = '%d' LIMIT 1", _param3 ) ;
			mysql_tquery ( sql_connection, global_string, "callback_offamily_name", "i", playerid ) ;
		}
	}
	else if ( _param == 18 ) // black list
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowMembersBlackPage ( playerid ) ;
				
				new _family_id = p_info [ playerid ] [ family ] ;
				if ( p_info [ playerid ] [ family_rang ] < family_info [ _family_id - 1 ] [ fam_settings ] [ 3 ] )
				{
					new _players_bl = 0 ;
					foreach(new i: logged_players)
					{
						if ( fam_bl_info [ i ] [ bl_onFrac ] [ _family_id ] )
						{
							_players_bl ++ ;
						}
					}
					
					if ( ! _players_bl )
					{
						send_check_cinfo ( playerid, "Нет игроков в чёрном списке семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
					
					new BitStream:bitstream = BS_New();
					BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
					BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
							
					BS_WriteValue(bitstream, PR_INT8, 4);
					BS_WriteValue(bitstream, PR_INT8, 36);
					
					BS_WriteValue(bitstream, PR_UINT8, _players_bl);
					
					new line_string [ 64 ] ;
					foreach(new i: logged_players)
					{
						if ( fam_bl_info [ i ] [ bl_onFrac ] [ _family_id ] )
						{
							format ( line_string, sizeof line_string, "%d", p_info [ i ] [ id ] ) ;
							BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
							BS_WriteValue(bitstream, PR_STRING, line_string ) ;
							
							BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ i ] [ name ] ) ) ;
							BS_WriteValue(bitstream, PR_STRING, p_info [ i ] [ name ] ) ;
							
							format ( line_string, sizeof line_string, "-" ) ;
							BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
							BS_WriteValue(bitstream, PR_STRING, line_string ) ;
							
							format ( line_string, sizeof line_string, "-" ) ;
							BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
							BS_WriteValue(bitstream, PR_STRING, line_string ) ;
						}
					}
					
					PR_SendPacket(bitstream, playerid);
					BS_Delete(bitstream);
				}
				else
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "SELECT `bl_player`,`bl_name`,`bl_date`,`bl_reason` FROM `familys_blacklist` WHERE `bl_family` = '%d'", _family_id ) ;
					mysql_tquery ( sql_connection, global_string, "callback_bl_family", "i", playerid ) ;
				}
			}
		}
		else if ( _param2 == 1 )
		{
			new _family_id = p_info [ playerid ] [ family ] ;
			if ( p_info [ playerid ] [ family_rang ] < family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] )
			{
				static const _str [ ] = "Чёрный список доступен со статуса %s (%d)." ;
			    new scm_string [ sizeof _str ] ;
			    format ( scm_string, sizeof scm_string, _str, family_rank [ _family_id - 1 ] [ family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] - 1 ], family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] ) ;
				send_check_cinfo ( playerid, scm_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			global_string [ 0 ] = EOS ;
			mysql_format ( sql_connection, global_string, 138, "SELECT `bl_player`, `bl_name` FROM `familys_blacklist` WHERE `bl_player` = '%d' AND `bl_family`='%d' LIMIT 1", _param3, _family_id ) ;
			mysql_tquery ( sql_connection, global_string, "check_bl_list_family", "dsd", playerid, " ", 2 ) ;
		}
		else if ( _param2 == 2 )
		{
			new _family_id = p_info [ playerid ] [ family ] ;
			if ( p_info [ playerid ] [ family_rang ] < family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] )
			{
				static const _str [ ] = "Чёрный список доступен со статуса %s (%d)." ;
			    new scm_string [ sizeof _str ] ;
			    format ( scm_string, sizeof scm_string, _str, family_rank [ _family_id - 1 ] [ family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] - 1 ], family_info [ _family_id - 1 ] [ fam_settings ] [ 4 ] ) ;
				send_check_cinfo ( playerid, scm_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			show_dialog ( playerid, d_blinvite_family, DIALOG_STYLE_INPUT, "{"#cBHD"}Чёрный список", "{FFFFFF}Введите ID игрока и причину, которого хотите добавить в чёрный список:\n\n{"#cGRDialog"}* Пример ввода: 1, оскорбление семьи", "Принять", "Назад" ) ;
		}
	}
	else if ( _param == 19 ) // payday
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowMembersPaydayPage ( playerid ) ;
				
				new family_id = p_info [ playerid ] [ family ] ;
				new _h_id = family_info [ family_id - 1 ] [ fam_house ] ;
				if ( _h_id < 1 )
				{
					send_check_cinfo ( playerid, "У Вашей семьи нет дома!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( h_info [ _h_id - 1 ] [ h_podezd ] != -1 )
				{
					send_check_cinfo ( playerid, "У Вашей семьи не частный дом!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
				BS_WriteValue(bitstream, PR_INT8, 3);
				BS_WriteValue(bitstream, PR_INT8, 37);
				
				BS_WriteValue(bitstream, PR_UINT8, family_info [ family_id - 1 ] [ fam_settings ] [ 3 ]);
				
				new line_string [ 64 ] ;
				for ( new i = 0 ; i < family_info [ family_id - 1 ] [ fam_settings ] [ 3 ] ; i ++ )
				{
					format ( line_string, sizeof line_string, "%d", i + 1 ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					
					BS_WriteValue(bitstream, PR_UINT8, strlen ( family_rank [ family_id - 1 ] [ i ] ) ) ;
					BS_WriteValue(bitstream, PR_STRING, family_rank [ family_id - 1 ] [ i ] ) ;

					format ( line_string, sizeof line_string, "%s"valute_title_" + %d "family_title_abb"", GetPlayerCashValueToSmile ( family_info [ family_id - 1 ] [ fam_payday ] [ i ] ), family_info [ family_id - 1 ] [ fam_payday_ticket ] [ i ] ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
				}
				
				PR_SendPacket(bitstream, playerid);
				BS_Delete(bitstream);
			}
		}
		else if ( _param2 == 1 )
		{
			if ( p_info [ playerid ] [ family_rang ] < family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_settings ] [ 3 ] )
			{
				send_check_cinfo ( playerid, "Раздел доступен только лидеру семьи!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			set_player_use_listitem ( playerid, _param3 ) ;
			show_dialog ( playerid, d_fam_payday, DIALOG_STYLE_LIST, "{"#cBHD"}Заработная плата", "{"#cGRDialog"}- {"#cWH"}Установить сумму\n{"#cGRDialog"}- {"#cWH"}Установить "family_title"", "Выбрать", "Закрыть" ) ;
		}
	}
	else if ( _param == 21 ) // muted players
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowMembersMutedPage ( playerid ) ;
				
				new family_id = p_info [ playerid ] [ family ], _players_muted = 0 ;
				foreach(new i: family_players[family_id])
				{
					if ( p_info [ i ] [ family ] != family_id ) continue ;
					if ( p_info [ i ] [ mute ] < 1 && p_info [ i ] [ fam_mute ] < 1 ) continue ;
					
					_players_muted ++ ;
				}
				if ( ! _players_muted )
				{
					send_check_cinfo ( playerid, "Нет членов семьи с баном чата!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
				BS_WriteValue(bitstream, PR_INT8, 5);
				BS_WriteValue(bitstream, PR_INT8, 33);
					
				BS_WriteValue(bitstream, PR_UINT8, _players_muted);
		
				new line_string [ 64 ] ;
				foreach(new i: family_players[family_id])
				{
					if ( p_info [ i ] [ family ] != family_id ) continue ;
					if ( p_info [ i ] [ mute ] < 1 && p_info [ i ] [ fam_mute ] < 1 ) continue ;
				
					format ( line_string, sizeof line_string, "%d", p_info [ i ] [ id ] ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
					
					BS_WriteValue(bitstream, PR_UINT8, strlen ( p_info [ i ] [ name ] ) ) ;
					BS_WriteValue(bitstream, PR_STRING, p_info [ i ] [ name ] ) ;
					
					format ( line_string, sizeof line_string, "%s", convert_time ( p_info [ i ] [ mute ], TYPE_TIME_HOUR ) ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;

					if ( p_info [ playerid ] [ mute ] > 0 ) format ( line_string, sizeof line_string, "Сервер" ) ;
					else format ( line_string, sizeof line_string, "Семья" ) ;
					BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
					BS_WriteValue(bitstream, PR_STRING, line_string ) ;
				}
				
				PR_SendPacket(bitstream, playerid);
				BS_Delete(bitstream);
			}
		}
		else if ( _param2 == 1 )
		{
			new bool: _player_muted = false, family_id = p_info [ playerid ] [ family ] ;
			foreach(new i: family_players[family_id])
			{
				if ( p_info [ i ] [ family ] != family_id ) continue ;
				if ( _param3 != p_info [ i ] [ id ] ) continue ;
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 32, "%d", i ) ;
				callcmd::famunwarn ( playerid, global_string ) ;
				
				_player_muted = true ;
				break ;
			}
			
			if ( ! _player_muted )
			{
				static const _str [ ] = "UPDATE `users` SET `u_fammute` = '0' WHERE `u_id` = '%d' LIMIT 1" ;
				new sql_string [ sizeof _str + 9 ] ;
				format ( sql_string, sizeof sql_string, _str, _param3 ) ;
				mysql_tquery ( sql_connection, sql_string ) ;
			}
			
			show_packet_family ( playerid, 21, 0, 0 ) ;
		}
	}
	else if ( _param == 49 ) // family rating
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				familyShowTopFamsPage ( playerid, 1 ) ;
				mysql_tquery ( sql_connection, !"SELECT `fam_id` FROM `family` ORDER BY `family`.`fam_rating` DESC", "family_rating_smali", "i", playerid ) ;
			}
		}
	}
	else if ( _param == 255 )
	{
		if ( _param2 == 255 )
		{
			if ( _param3 == 255 )
			{
				SetFamilyHide ( playerid ) ;
				player_last_page [ playerid ] = -1 ;
		
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
			}
		}
	}
	return 1 ;
}

callback: callback_offamily_device ( playerid, _packet_type )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;

	new line_string [ 64 ], pl_ofm_name [ 24 ], fam_c_warning, fam_c_id, fam_c_week ;

	new BitStream:bitstream = BS_New();
				
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);
				
	if ( _packet_type == 42 ) BS_WriteValue(bitstream, PR_INT8, 3);
	else BS_WriteValue(bitstream, PR_INT8, 5);
	BS_WriteValue(bitstream, PR_INT8, _packet_type);
				
	if ( rows - page_rows [ playerid ] < 1 ) BS_WriteValue(bitstream, PR_UINT8, 100);
	else BS_WriteValue(bitstream, PR_UINT8, rows - page_rows [ playerid ]);
	for ( new i = page_rows [ playerid ] - 100 ; i < rows ; i ++ )
	{
		fam_c_id = cache_get_field_content_int ( i, "u_id", sql_connection ) ;
		cache_get_field_content ( i, "u_name", pl_ofm_name, sql_connection, 24 ) ;
		fam_c_warning = cache_get_field_content_int ( i, "u_fam_warning", sql_connection ) ;
		fam_c_week = cache_get_field_content_int ( i, "u_week_played", sql_connection ) ;
		
		if ( _packet_type == 42 )
		{
			format ( line_string, sizeof line_string, "%d", fam_c_id ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
				
			BS_WriteValue(bitstream, PR_UINT8, strlen ( pl_ofm_name ) ) ;
			BS_WriteValue(bitstream, PR_STRING, pl_ofm_name ) ;
				
			format ( line_string, sizeof line_string, "%d час(ов)", fam_c_week ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
		}
		else
		{
			format ( line_string, sizeof line_string, "%d", fam_c_id ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
				
			BS_WriteValue(bitstream, PR_UINT8, strlen ( pl_ofm_name ) ) ;
			BS_WriteValue(bitstream, PR_STRING, pl_ofm_name ) ;
				
			format ( line_string, sizeof line_string, "%d / 3", fam_c_warning ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
				
			format ( line_string, sizeof line_string, "%d час(ов)", fam_c_week ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
				
			new _pl_id ;
			sscanf ( pl_ofm_name, "u", _pl_id ) ;
			if ( IsPlayerConnected ( _pl_id ) )
			{
				format ( line_string, sizeof line_string, "В игре" ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
				BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			}
			else
			{
				format ( line_string, sizeof line_string, "Не в сети" ) ;
				BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
				BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			}
		}
	}
		
	PR_SendPacket(bitstream, playerid);
	BS_Delete(bitstream);
	return 1 ;
}

callback: callback_offamily_name ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;
	
	new pl_name [ 24 ] ;
	cache_get_field_content ( 0, "u_name", pl_name, sql_connection, 24 ) ;
	
	new pvar_string [ 38 ] ;
	format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", 0 ) ;
	SetPVarString ( playerid, pvar_string, pl_name ) ;
	SetPVarInt ( playerid, "ofm_listitem", 0 ) ;

	show_offmembers_dialog ( playerid, pl_name, 1 ) ;
	return 1 ;
}

callback: get_familys_logs_device ( playerid, _packet_type )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;
	
	new _t_name [ 24 ], _t_date [ 48 ], _t_text [ 128 ] ;
	new _c_count = 0, bool: need_packet = false ;

	new BitStream:bititerator;
	for ( new i = 0 ; i < rows ; i ++ )
	{
		if ( _c_count == 0 )
		{
			need_packet = true ;

			new BitStream:bitstream = BS_New();
			bititerator = bitstream;
					
			BS_WriteValue(bititerator, PR_UINT8, PACKET_CUSTOMRPC);
			BS_WriteValue(bititerator, PR_UINT32, RPC_FAMILY);
					
			if ( _packet_type == 31 || _packet_type == 39 ) BS_WriteValue(bitstream, PR_INT8, 3);
			else BS_WriteValue(bitstream, PR_INT8, 4);
			BS_WriteValue(bitstream, PR_INT8, _packet_type);
					
			if ( rows - i > 50 ) BS_WriteValue(bititerator, PR_UINT8, 50);
			else BS_WriteValue(bititerator, PR_UINT8, rows - i);
		}

		cache_get_field_content ( i, "name", _t_name, sql_connection, 24 ) ;
		cache_get_field_content ( i, "text_date", _t_date, sql_connection, 48 ) ;
		cache_get_field_content ( i, "Text", _t_text, sql_connection, 128 ) ;
		new _t_type = cache_get_field_content_int ( i, "type", sql_connection ) ;
		
		if ( _packet_type == 31 || _packet_type == 39 )
		{
			BS_WriteValue(bititerator, PR_UINT8, strlen ( _t_name ) ) ;
			BS_WriteValue(bititerator, PR_STRING, _t_name ) ;
				
			BS_WriteValue(bititerator, PR_UINT8, strlen ( _t_text ) ) ;
			BS_WriteValue(bititerator, PR_STRING, _t_text ) ;
				
			BS_WriteValue(bititerator, PR_UINT8, strlen ( _t_date ) ) ;
			BS_WriteValue(bititerator, PR_STRING, _t_date ) ;
		}
		else
		{
			BS_WriteValue(bititerator, PR_UINT8, strlen ( _t_name ) ) ;
			BS_WriteValue(bititerator, PR_STRING, _t_name ) ;
				
			BS_WriteValue(bititerator, PR_UINT8, strlen ( _t_text ) ) ;
			BS_WriteValue(bititerator, PR_STRING, _t_text ) ;
				
			BS_WriteValue(bititerator, PR_UINT8, strlen ( logs_type_family ( _t_type ) ) ) ;
			BS_WriteValue(bititerator, PR_STRING, logs_type_family ( _t_type ) ) ;
				
			BS_WriteValue(bititerator, PR_UINT8, strlen ( _t_date ) ) ;
			BS_WriteValue(bititerator, PR_STRING, _t_date ) ;
		}

		if ( ++ _c_count == 50 )
		{
			PR_SendPacket(bititerator, playerid);
			BS_Delete(bititerator);
				
			_c_count = 0 ;
			need_packet = false ;
		}
	}
		
	if ( need_packet == true )
	{
		PR_SendPacket(bititerator, playerid);
		BS_Delete(bititerator);
					
		_c_count = 0 ;
		need_packet = false ;
	}
	return 1 ;
}

callback: family_vehicles_li_device ( playerid, _type, _param )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		send_check_cinfo ( playerid, "У Вашей семьи нет транспорта!", 0, 300, CINFO_FAMILY_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	if ( _type == 1 )
	{
		new BitStream:bitstream = BS_New();
		BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
		BS_WriteValue(bitstream, PR_UINT32, RPC_FAMILY);

		BS_WriteValue(bitstream, PR_INT8, 11);
		BS_WriteValue(bitstream, PR_INT8, 44);

		BS_WriteValue(bitstream, PR_UINT8, rows);

		for ( new i = 0 ; i < rows ; i ++ )
		{
			//new _sv_id = cache_get_field_content_int ( i, "sv_id", sql_connection ) ;
			new _sv_model = cache_get_field_content_int ( i, "sv_model", sql_connection ) ;
			new _sv_use = cache_get_field_content_int ( i, "sv_use", sql_connection ) ;
			new _sv_color_1 = cache_get_field_content_int ( i, "sv_color_1", sql_connection ) ;
			new _sv_color_2 = cache_get_field_content_int ( i, "sv_color_2", sql_connection ) ;

			BS_WriteValue(bitstream, PR_INT8, 3);
			BS_WriteValue(bitstream, PR_UINT32, _sv_model);

			BS_WriteValue(bitstream, PR_UINT8, strlen ( GetVehicleNameEx ( -1, _sv_model ) ) ) ;
			BS_WriteValue(bitstream, PR_STRING, GetVehicleNameEx ( -1, _sv_model ) ) ;

			BS_WriteValue(bitstream, PR_INT8, _sv_color_1);
			BS_WriteValue(bitstream, PR_INT8, _sv_color_2);

			BS_WriteValue(bitstream, PR_FLOAT, 20.0);
			BS_WriteValue(bitstream, PR_FLOAT, 180.0);
			BS_WriteValue(bitstream, PR_FLOAT, 45.0);
			BS_WriteValue(bitstream, PR_FLOAT, 0.78);
			
			if ( _sv_use != 1 )
			{
				BS_WriteValue(bitstream, PR_UINT8, strlen ( "Загрузить" ) ) ;
				BS_WriteValue(bitstream, PR_STRING, "Загрузить" ) ;
				BS_WriteValue(bitstream, PR_INT8, 2);
			}
			else
			{
				BS_WriteValue(bitstream, PR_UINT8, strlen ( "Заспавнить" ) ) ;
				BS_WriteValue(bitstream, PR_STRING, "Заспавнить" ) ;
				BS_WriteValue(bitstream, PR_INT8, 1);
			}
		}

		PR_SendPacket(bitstream, playerid);
		BS_Delete(bitstream);
	}
	else if ( _type == 2 )
	{
		for ( new i = 0 ; i < rows ; i ++ )
		{
			if ( i != _param ) continue ;
			new _sv_id = cache_get_field_content_int ( i, "sv_id", sql_connection ) ;
			new _sv_use = cache_get_field_content_int ( i, "sv_use", sql_connection ) ;
			
			if ( _sv_use != 1 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 80, "SELECT * FROM `familys_vehicles` WHERE `sv_id` = '%d' LIMIT 1", _sv_id ) ;
				mysql_tquery ( sql_connection, global_string, "vehicles_loading_family1", "dd", playerid, _param ) ;
			}
			else
			{
				new _family_id = p_info [ playerid ] [ family ] ;
				foreach(new veh_id: family_vehicles[_family_id])
				{
					if ( veh_info [ veh_id - 1 ] [ v_type ] != vehicle_type_family ) continue ;
					if ( veh_info [ veh_id - 1 ] [ v_owner ] != _family_id ) continue ;
					if ( veh_info [ veh_id - 1 ] [ v_id ] != _sv_id ) continue ;
					
					if ( is_vehicle_occupied ( veh_id ) != -1)
					{
						send_check_cinfo ( playerid, "Транспорт используется!", 0, 300, CINFO_FAMILY_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
					
					SetVehicleToRespawn ( veh_id, 25 ) ;
					send_check_cinfo ( playerid, "Транспорт отремонтирован и отбуксирован к месту стоянки.", 0, 300, CINFO_FAMILY_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
					family_info [ _family_id - 1 ] [ fam_bank ] -= price_fixcar ;

					global_string [ 0 ] = EOS ;
					mysql_format ( sql_connection, global_string, 100, "UPDATE `family` SET `fam_bank` = '%d' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _family_id - 1 ] [ fam_bank ], _family_id ) ;
					mysql_tquery ( sql_connection, global_string ) ;
					
					familyUpdateSettingsCarsItem ( playerid, _param, veh_id, "Загрузить", 2 ) ;
					break ;
				}
			}
			return 1 ;
		}
	}
	else if ( _type == 3 )
	{
		for ( new i = 0 ; i < rows ; i ++ )
		{
			if ( i != _param ) continue ;
			new _sv_id = cache_get_field_content_int ( i, "sv_id", sql_connection ) ;
			new _sv_use = cache_get_field_content_int ( i, "sv_use", sql_connection ) ;
			
			if ( _sv_use != 1 )
			{
				send_check_cinfo ( playerid, "Управлять можно только загруженным транспортом.", 0, 300, CINFO_FAMILY_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			}
			else
			{
				new _family_id = p_info [ playerid ] [ family ] ;
				foreach(new veh_id: family_vehicles[_family_id])
				{
					if ( veh_info [ veh_id - 1 ] [ v_type ] != vehicle_type_family ) continue ;
					if ( veh_info [ veh_id - 1 ] [ v_owner ] != _family_id ) continue ;
					if ( veh_info [ veh_id - 1 ] [ v_id ] != _sv_id ) continue ;
					
					show_menu_fixcar ( playerid, veh_id, 5 ) ;
					break ;
				}
			}
			return 1 ;
		}
	}
	return 1 ;
}

callback: vehicles_loading_family1 ( playerid, _param )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if( rows )
	{
		new unix_time = gettime ( ), veh_id = GetVehicleID ( ), _family_id = p_info [ playerid ] [ family ] ;
		if ( _family_id < 1 ) return 1 ;
		
		new sv_use = cache_get_field_content_int ( 0, "sv_use", sql_connection ) ;
		if ( sv_use == 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный транспорт уже загружен!" ) ;
		
		veh_info [ veh_id - 1 ] [ v_rank ] = cache_get_field_content_int ( 0, "sv_rank", sql_connection ) ;
		
		if ( veh_info [ veh_id - 1 ] [ v_rank ] < 1 ) veh_info [ veh_id - 1 ] [ v_rank ] = 1 ;
		if ( p_info [ playerid ] [ family_rang ] < veh_info [ veh_id - 1 ] [ v_rank ] )
		{
			static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Транспорт доступен с ранга %s (%d)." ;
			new scm_string [ sizeof _str + 30 + 3 ] ;
			format ( scm_string, sizeof scm_string, _str, family_rank [ _family_id - 1 ] [ veh_info [ veh_id - 1 ] [ v_rank ] - 1 ], veh_info [ veh_id - 1 ] [ v_rank ] ) ;
			SendClientMessage ( playerid, col_gray, scm_string ) ;
			return 1 ;
		}
		
		veh_info [ veh_id - 1 ] [ v_id ] = cache_get_field_content_int ( 0, "sv_id", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_model ] = cache_get_field_content_int ( 0, "sv_model", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_type ] = cache_get_field_content_int ( 0, "sv_type", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_owner ] = cache_get_field_content_int ( 0, "sv_owner", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_owner_fam ] = cache_get_field_content_int ( 0, "v_owner_fam", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_color ] [ 0 ] = cache_get_field_content_int ( 0, "sv_color_1", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_color ] [ 1 ] = cache_get_field_content_int ( 0, "sv_color_2", sql_connection ) ;

		veh_info [ veh_id - 1 ] [ v_paint ] = cache_get_field_content_int ( 0, "sv_paint", sql_connection ) ;
			
		veh_info [ veh_id - 1 ] [ v_plate_type ] = cache_get_field_content_int ( 0, "v_plate_type", sql_connection ) ;
		cache_get_field_content ( 0, "v_plate", veh_info [ veh_id - 1 ] [ v_plate ], sql_connection, 32 ) ;
		cache_get_field_content ( 0, "v_region", veh_info [ veh_id - 1 ] [ v_region ], sql_connection, 10 ) ;
			
		veh_info [ veh_id - 1 ] [ v_fuel ] = cache_get_field_content_float ( 0, "sv_fuel", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_millage ] = cache_get_field_content_float ( 0, "sv_millage", sql_connection ) ;

		veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ] = cache_get_field_content_float ( 0, "sv_pos_x", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ] = cache_get_field_content_float ( 0, "sv_pos_y", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] = cache_get_field_content_float ( 0, "sv_pos_z", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] = cache_get_field_content_float ( 0, "sv_pos_a", sql_connection ) ;
			
		veh_info [ veh_id - 1 ] [ v_vw ] = cache_get_field_content_int ( 0, "v_vw", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_int ] = cache_get_field_content_int ( 0, "v_int", sql_connection ) ;
			
		veh_info [ veh_id - 1 ] [ v_engine_boost ] = cache_get_field_content_float ( 0, "sv_engine_boost", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_brake_boost ] = cache_get_field_content_float ( 0, "sv_brake_boost", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_stability_boost ] = cache_get_field_content_float ( 0, "sv_stability_boost", sql_connection ) ;

		new sscanf_delimit [ 126 ] ;
		cache_get_field_content ( 0, "v_eng_details", sscanf_delimit, sql_connection, 16 ) ;
		sscanf ( sscanf_delimit, "p<|>ddddd", veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 1 ],
		veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 3 ], veh_info [ veh_id - 1 ] [ v_pt_engine ] [ 4 ]	) ;

		cache_get_field_content ( 0, "v_brake_details", sscanf_delimit, sql_connection, 16 ) ;
		sscanf ( sscanf_delimit, "p<|>ddddd", veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 1 ],
		veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 3 ], veh_info [ veh_id - 1 ] [ v_pt_brake ] [ 4 ]	) ;

		cache_get_field_content ( 0, "v_stab_details", sscanf_delimit, sql_connection, 16 ) ;
		sscanf ( sscanf_delimit, "p<|>ddddd", veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 1 ],
		veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 3 ], veh_info [ veh_id - 1 ] [ v_pt_stability ] [ 4 ]	) ;

		cache_get_field_content ( 0, "v_components", sscanf_delimit, sql_connection, 126 ) ;
		sscanf ( sscanf_delimit, "p<|>dddddddddd", veh_info [ veh_id - 1 ] [ v_component ] [ 0 ], veh_info [ veh_id - 1 ] [ v_component ] [ 1 ],
		veh_info [ veh_id - 1 ] [ v_component ] [ 2 ], veh_info [ veh_id - 1 ] [ v_component ] [ 3 ], veh_info [ veh_id - 1 ] [ v_component ] [ 4 ],
		veh_info [ veh_id - 1 ] [ v_component ] [ 5 ], veh_info [ veh_id - 1 ] [ v_component ] [ 6 ], veh_info [ veh_id - 1 ] [ v_component ] [ 7 ],
		veh_info [ veh_id - 1 ] [ v_component ] [ 8 ], veh_info [ veh_id - 1 ] [ v_component ] [ 9 ] ) ;
			
		veh_info [ veh_id - 1 ] [ v_pantera_strobs ] = cache_get_field_content_int ( 0, "v_pantera_strobs", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pantera_alarm ] = cache_get_field_content_int ( 0, "v_pantera_alarm", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pantera_engine ] = cache_get_field_content_int ( 0, "v_pantera_engine", sql_connection ) ;
			
		veh_info [ veh_id - 1 ] [ v_pantera_radar ] = cache_get_field_content_int ( 0, "v_pantera_radar", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pantera_rdate ] = cache_get_field_content_int ( 0, "v_pantera_rdate", sql_connection ) ;
		if ( veh_info [ veh_id - 1 ] [ v_pantera_rdate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_pantera_radar ] )
		{
		    veh_info [ veh_id - 1 ] [ v_pantera_rdate ] =
		    veh_info [ veh_id - 1 ] [ v_pantera_radar ] = 0 ;

		    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `v_pantera_rdate` = '0', `v_pantera_radar` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, sscanf_delimit ) ;
		}

		veh_info [ veh_id - 1 ] [ v_pantera_gps ] = cache_get_field_content_int ( 0, "v_pantera_gps", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pantera_gdate ] = cache_get_field_content_int ( 0, "v_pantera_gdate", sql_connection ) ;
		if ( veh_info [ veh_id - 1 ] [ v_pantera_gdate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_pantera_gps ] )
		{
		    veh_info [ veh_id - 1 ] [ v_pantera_gdate ] =
		    veh_info [ veh_id - 1 ] [ v_pantera_gps ] = 0 ;

		    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `v_pantera_gdate` = '0', `v_pantera_gps` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, sscanf_delimit ) ;
		}

		veh_info [ veh_id - 1 ] [ v_pantera_armour ] = cache_get_field_content_int ( 0, "v_pantera_armour", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pantera_adate ] = cache_get_field_content_int ( 0, "v_pantera_adate", sql_connection ) ;
		if ( veh_info [ veh_id - 1 ] [ v_pantera_adate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_pantera_armour ] )
		{
		    veh_info [ veh_id - 1 ] [ v_pantera_adate ] =
		    veh_info [ veh_id - 1 ] [ v_pantera_armour ] = 0 ;

		    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `v_pantera_adate` = '0', `v_pantera_armour` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, sscanf_delimit ) ;
		}

		veh_info [ veh_id - 1 ] [ v_pantera_launch ] = cache_get_field_content_int ( 0, "v_pantera_launch", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pantera_ldate ] = cache_get_field_content_int ( 0, "v_pantera_ldate", sql_connection ) ;
		if ( veh_info [ veh_id - 1 ] [ v_pantera_ldate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_pantera_launch ] == 1 )
		{
		    veh_info [ veh_id - 1 ] [ v_pantera_ldate ] =
		    veh_info [ veh_id - 1 ] [ v_pantera_launch ] = 0 ;

		    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `v_pantera_ldate` = '0', `v_pantera_launch` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, sscanf_delimit ) ;
		}
		
		veh_info [ veh_id - 1 ] [ v_sound ] = cache_get_field_content_int ( 0, "v_sound", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_pantera_sdate ] = cache_get_field_content_int ( 0, "v_pantera_sdate", sql_connection ) ;
		if ( veh_info [ veh_id - 1 ] [ v_pantera_sdate ] - unix_time < 0 && veh_info [ veh_id - 1 ] [ v_sound ] == 1 )
		{
		    veh_info [ veh_id - 1 ] [ v_sound ] =
		    veh_info [ veh_id - 1 ] [ v_pantera_sdate ] = 0 ;

		    format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `v_sound` = '0', `v_pantera_sdate` = '0' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, sscanf_delimit ) ;
		}
			
		sscanf_delimit [ 0 ] = EOS ;
		cache_get_field_content ( 0, "v_suspension", sscanf_delimit, sql_connection, 20 ) ;
		sscanf ( sscanf_delimit, "p<|>ff", veh_info [ veh_id - 1 ] [ v_suspension ] [ 0 ], veh_info [ veh_id - 1 ] [ v_suspension ] [ 1 ] ) ;

		veh_info [ veh_id - 1 ] [ v_wheel_size ] = cache_get_field_content_float ( 0, "v_wheel_size", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_wheel_width ] = cache_get_field_content_int ( 0, "v_wheel_width", sql_connection ) ;

		cache_get_field_content ( 0, "v_wheel_alignment", sscanf_delimit, sql_connection, 20 ) ;
		sscanf ( sscanf_delimit, "p<|>dd", veh_info [ veh_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ veh_id - 1 ] [ v_wheel_alignment ] [ 1 ] ) ;

		cache_get_field_content ( 0, "v_wheel_offset", sscanf_delimit, sql_connection, 20 ) ;
		sscanf ( sscanf_delimit, "p<|>dd", veh_info [ veh_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ veh_id - 1 ] [ v_wheel_offset ] [ 1 ] ) ;

		veh_info [ veh_id - 1 ] [ v_lights_color ] = cache_get_field_content_int ( 0, "v_lights_color", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_neon ] = cache_get_field_content_int ( 0, "v_neon", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_neon_type ] = cache_get_field_content_int (0, "v_neon_type", sql_connection ) ;
			
		cache_get_field_content ( 0, "v_toner", sscanf_delimit, sql_connection, 20 ) ;
		sscanf ( sscanf_delimit, "p<|>dddd", veh_info [ veh_id - 1 ] [ v_toner ] [ 0 ], veh_info [ veh_id - 1 ] [ v_toner ] [ 1 ], veh_info [ veh_id - 1 ] [ v_toner ] [ 2 ], veh_info [ veh_id - 1 ] [ v_toner ] [ 3 ] ) ;

		veh_info [ veh_id - 1 ] [ v_vinyl ] = cache_get_field_content_int ( 0, "v_vinyl", sql_connection ) ;
			
		veh_info [ veh_id - 1 ] [ v_stage_speed ] = cache_get_field_content_int ( 0, "v_stage_speed", sql_connection ) ;
		veh_info [ veh_id - 1 ] [ v_stage_brake ] = cache_get_field_content_int ( 0, "v_stage_brake", sql_connection ) ;
			
        veh_info [ veh_id - 1 ] [ v_key ] = 1 ;
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		veh_info [ veh_id - 1 ] [ v_fuel ] = 35.0 ;




		new _house_id = family_info [ _family_id - 1 ] [ fam_house ] ;
		
		if ( h_info [ _house_id - 1 ] [ h_podezd ] != -1 )
		{
			veh_info [ veh_id - 1 ] [ v_vehicle ] = CreateVehicle ( veh_info [ veh_id - 1 ] [ v_model ], position_vehicle_parking [ 0 ], position_vehicle_parking [ 1 ], position_vehicle_parking [ 2 ], position_vehicle_parking [ 3 ], veh_info [ veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ veh_id - 1 ] [ v_color ] [ 1 ], SPAWN_TIME_FAMILY_VEHICLE ) ;
			
			LinkVehicleToInterior ( veh_id, GetPlayerInterior ( playerid ) ) ;
			SetVehicleVirtualWorld ( veh_id, GetPlayerVirtualWorld ( playerid ) ) ;
		}
		else
		{
			veh_info [ veh_id - 1 ] [ v_vehicle ] = CreateVehicle ( veh_info [ veh_id - 1 ] [ v_model ], h_info [ _house_id - 1 ] [ h_v_pos ] [ 0 ], h_info [ _house_id - 1 ] [ h_v_pos ] [ 1 ], h_info [ _house_id - 1 ] [ h_v_pos ] [ 2 ], h_info [ _house_id - 1 ] [ h_v_pos ] [ 3 ], veh_info [ veh_id - 1 ] [ v_color ] [ 0 ], veh_info [ veh_id - 1 ] [ v_color ] [ 1 ], SPAWN_TIME_FAMILY_VEHICLE ) ;
		
			if ( veh_info [ veh_id - 1 ] [ v_int ] != 0 )LinkVehicleToInterior ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_int ] ) ;
			if ( veh_info [ veh_id - 1 ] [ v_vw ] != 0 )SetVehicleVirtualWorld ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_vw ] ) ;
		}
		SetVehicleNumberPlate ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_plate ] ) ;
		
		veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;
		player_rentcar [ playerid ] = veh_id ;
		family_info [ _family_id - 1 ] [ fam_car_cooldown ] [ 1 ] = gettime ( ) + 60 ;
		
		format ( sscanf_delimit, sizeof sscanf_delimit, "UPDATE `familys_vehicles` SET `sv_use` = '1' WHERE `sv_id` = '%d' LIMIT 1", veh_info [ veh_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, sscanf_delimit ) ;
		
	
	
	
		
			

		if ( veh_info [ veh_id - 1 ] [ v_paint ] != 3 )
		{
			ChangeVehiclePaintjob ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_paint ] ) ;
		}

        for ( new j = 0; j < 10; j ++ )
		{
		    if ( veh_info [ veh_id - 1 ] [ v_component ] [ j ] == 0 ) continue ;
			AddVehicleComponent ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_component ] [ j ] ) ;
		}

		veh_plate ( veh_id ) ;
		veh_info [ veh_id - 1 ] [ v_trunk_open ] = false ;
		veh_info [ veh_id - 1 ] [ v_trunk_load ] = false ;
			
		veh_info [ veh_id - 1 ] [ v_price ] = cache_get_field_content_int ( 0, "sv_price", sql_connection ) ;

		Iter_Add(family_vehicles[veh_info [ veh_id - 1 ] [ v_owner ]], veh_info [ veh_id - 1 ] [ v_vehicle ] ) ;
		
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
		
		familyUpdateSettingsCarsItem ( playerid, _param, veh_id, "Заспавнить", 1 ) ;
	}
	return 1 ;
}