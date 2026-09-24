#define MAX_CREATE_HOUSE_OBJECT 10
#define MAX_HOUSE_OBJECT 30

/*enum
{
	d_house_object_buy,
	d_house_object_buy1, 
	d_adm_house_object,
	d_adm_house_object_set
} ;*/

new house_object_count [ MAX_HOUSES ] ;
new house_object_inc_id [ MAX_HOUSES ] [ MAX_HOUSE_OBJECT ] ;
new house_object_id [ MAX_HOUSES ] [ MAX_HOUSE_OBJECT ] ;
new house_object [ MAX_HOUSES ] [ MAX_HOUSE_OBJECT ] ;
new Float: house_pos_object [ MAX_HOUSES ] [ MAX_HOUSE_OBJECT ] [ 6 ] ;
new Float: house_pos_object_open [ MAX_HOUSES ] [ MAX_HOUSE_OBJECT ] [ 6 ] ;

enum _ho_player
{
	player_house_object_inc,
	player_house_object,
	create_house_object,
	Float: create_house_pos_object [ 6 ]
} ;
new ho_player [ MAX_PLAYERS ] [ MAX_CREATE_HOUSE_OBJECT ] [ _ho_player ] ;

new price_house_object [ MAX_CREATE_HOUSE_OBJECT ] = { 200, 25, 100, 160, 200, 120, 120, 10, 25, 140 } ;

#if defined SAMP
new id_d_house_object [ MAX_CREATE_HOUSE_OBJECT ] = { 980, 966, 968, 980, 971, 988, 989, 970, 987, 19313 } ;
#endif

#if defined CRMP
new id_d_house_object [ MAX_CREATE_HOUSE_OBJECT ] = { 12803, 966, 968, 12803, 12802, 12804, 12806, 12801, 12805, 19313 } ;
#endif

#if defined Matreshka
new id_d_house_object [ MAX_CREATE_HOUSE_OBJECT ] = { 12803, 966, 968, 12803, 12802, 12804, 12806, 12801, 12805, 19313 } ;
#endif

new name_house_object [ MAX_CREATE_HOUSE_OBJECT ] [ 32 ] = 
{ 
	"Стандартные ворота",
	"Стойка под шлагбаум",
	"Шлагбаум",
	"Маленькие ворота",
	"Высокие ворота",
	"Двойные ворота (левая часть)",
	"Двойные ворота (правая часть)",
	"Маленький забор (1 секция)",
	"Средний забор (1 секция)",
	"Большой забор (1 секция)"
} ;

stock clear_houses_object ( _house_h_id )
{
	house_object_count [ _house_h_id ] = 0 ;
	for ( new q = 0 ; q < MAX_HOUSE_OBJECT ; q ++ )
	{
		house_object_id [ _house_h_id ] [ q ] =
		house_object [ _house_h_id ] [ q ] = -1 ;
	}
	return 1 ;
}

stock h_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_house_object_buy:
		{
			if ( ! response ) return clear_player_hobject ( playerid ) ;

			if ( listitem == MAX_CREATE_HOUSE_OBJECT )
			{
				new bool: _house_object_buy = false, _count_obj = 0, _price_obj = 0 ;
				for ( new i = 0 ; i < MAX_CREATE_HOUSE_OBJECT ; i ++ )
				{
					for ( new _i = 0 ; _i < sizeof id_d_house_object ; _i ++ )
					{
						if ( ho_player [ playerid ] [ i ] [ create_house_object ] != id_d_house_object [ _i ] ) continue ;

						_price_obj += price_house_object [ _i ] ;
						break ;
					}
					_count_obj ++ ;
					_house_object_buy = true ;
				}
				if ( _house_object_buy == false ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы ничего не выбрали." ) ;

				new house_id = p_info [ playerid ] [ house ] ;
				if ( house_object_count [ house_id ] + _count_obj >= MAX_HOUSE_OBJECT ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Слишком много объектов к дому! Максимум {"#cRD"}30{"#cGRInfo"}." ) ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 800, "{"#cGRDialog"}- {"#cWH"}Объекты к дому:\n\n\
											{"#cGRDialog"}* Цена: {"#cGN"}%d "donate_title"{"#cGRDialog"}.\n\
											{"#cGRDialog"}* После подтверждения Вам нужно будет ожидать проверки администрации.\n\
											{"#cGRDialog"}* Если объекты были расставлены не корректно, то администратор\n\
											{"#cGRDialog"}* не сможет их переставить, а только отменить Вашу покупку.\n\
											{"#cGRDialog"}* Перепроверьте корректность расстановки.\n\n\
											{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Объекты к дому{"#cGRDialog"}\"?", _price_obj ) ;
				show_dialog ( playerid, d_house_object_buy1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", global_string, "Принять", "Назад" ) ;

				set_player_use_listitem ( playerid, _price_obj ) ;
			}
			else
			{
				new h = p_info [ playerid ] [ house ] - 1 ;
				if ( ! IsPlayerInRangeOfPoint ( playerid, 10.0, h_info [ h ] [ h_pos ] [ 0 ], h_info [ h ] [ h_pos ] [ 1 ], h_info [ h ] [ h_pos ] [ 2 ] ) )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы не рядом с домом." ) ;
					show_house_object_buy ( playerid ) ;
					return 1 ;
				}
				
				if ( ! get_player_donate ( playerid, price_house_object [ listitem ], 2 ) )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}У Вас недостаточно "donate_title"." ) ;
					show_house_object_buy ( playerid ) ;
					return 1 ;
				}

				for ( new i = 0 ; i < MAX_CREATE_HOUSE_OBJECT ; i ++ )
				{
					if ( ho_player [ playerid ] [ i ] [ player_house_object ] != -1 ) continue ;

					ho_player [ playerid ] [ i ] [ create_house_object ] = id_d_house_object [ listitem ] ;

					ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ] = p_t_info [ playerid ] [ p_pos ] [ 0 ] + 2 ;
					ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ] = p_t_info [ playerid ] [ p_pos ] [ 1 ] + 2 ;
					ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ] = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;

					ho_player [ playerid ] [ i ] [ player_house_object ] = CreateDynamicObject ( ho_player [ playerid ] [ i ] [ create_house_object ],
										ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ],
										ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ],
										ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ],
										ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 3 ],
										ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 4 ],
										ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 5 ],
										0, 0, -1, 300.00,  300.00) ;

					create_inc_id [ playerid ] = i ;
					create_object_id [ playerid ] = ho_player [ playerid ] [ i ] [ player_house_object ] ;
					create_type { playerid } = 6 ;
					if ( player_device { playerid } == 2 ) mobile_object_edit ( playerid, true, ho_player [ playerid ] [ i ] [ create_house_object ] ) ;
					else EditDynamicObject(playerid, ho_player [ playerid ] [ i ] [ player_house_object ] ) ;

					SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Отредактируйте объект." ) ;
					break ;
				}
			}
		}
		case d_house_object_buy1:
		{
			if ( ! response ) return clear_player_hobject ( playerid ) ;

			new _price_obj = get_player_use_listitem ( playerid ) ;
			if ( ! get_player_donate ( playerid, _price_obj, 2 ) )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "{"#cRD"}* У Вас недостаточно средств для приобретения данной услуги.\n\n\
											{"#cGRDialog"}- {"#cWH"}Объекты к дому:\n\n\
											{"#cGRDialog"}* Цена: {"#cGN"}%d "donate_title"{"#cGRDialog"}.\n\
											{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Объекты к дому{"#cGRDialog"}\"?", _price_obj ) ;
				show_dialog ( playerid, d_house_object_buy1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", global_string, "Принять", "Назад" ) ;
				return 1 ;
			}
			set_player_donate ( playerid, _price_obj, 2 ) ;
			friend_pay ( playerid, floatround ( _price_obj / 10 ) ) ;

			new insert_string [ 512 ], house_id = p_info [ playerid ] [ house ] ;
			for ( new i = 0 ; i < MAX_CREATE_HOUSE_OBJECT ; i ++ )
			{
				if ( ho_player [ playerid ] [ i ] [ player_house_object ] == -1 ) continue ;

				format ( insert_string, sizeof insert_string, "INSERT INTO `house_objects` ( `object_id`, `object_x`, `object_y`, `object_z`, `object_rx`, `object_ry`, `object_rz`, `object_house`, `object_status` ) VALUES ( '%d', '%f', '%f', '%f', '%f', '%f', '%f', '%d', '0')",
				ho_player [ playerid ] [ i ] [ create_house_object ],
				ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ], ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ], ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ],
				ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 3 ], ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 4 ], ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 5 ],
				house_id ) ;
				mysql_tquery ( sql_connection, insert_string, "", "" ) ;
			}

			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно оформили заказ. Ожидайте подтверждения от администрации." ) ;
			
			new scm_string [ 144 ] ;
			format ( scm_string, sizeof ( scm_string ), "{"#cBAdmin"}[A] {"#cGRAdmin"}%s приобрел(а) объекты к дому. Введите {"#cBAdmin"}\"/h_object [ %d ]\"{"#cGRAdmin"}.", p_info [ playerid ] [ name ], house_id ) ;
			
			foreach(new i: admin_players)
			{
				if ( admin_info [ i ] [ admin ] < 8 ) continue ;
				
				SendClientMessage ( i, col_admin, scm_string ) ;
			}

			insert_debtor_message ( "Домашние объекты", scm_string, get_player_account_id ( founder_name ) ) ;
			insert_debtor_message ( "Домашние объекты", scm_string, get_player_account_id ( founder_name_2 ) ) ;
			
			clear_player_hobject ( playerid ) ;
		}
		case d_adm_house_object:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
				DeletePVar ( playerid, "adm_house_id" ) ;
				return 1 ;
			}
			if ( listitem == get_player_use_page ( playerid, 0 ) )
			{
				clear_player_use_page ( playerid ) ;
				new page_id = page_count [ playerid ] - 1;
				if ( page_id == 0 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка объектов." ) ;

					new query_string [ 69 + 9 + 4 ] ;
					format ( query_string, sizeof query_string, "SELECT * FROM `house_objects` WHERE `object_house` = '%d' LIMIT %d", GetPVarInt ( playerid, "adm_house_id" ), MAX_HOUSE_OBJECT ) ;
					mysql_tquery ( sql_connection, query_string, "adm_house_objects_callback", "ii", playerid, GetPVarInt ( playerid, "adm_house_id" ) ) ;
					return 1 ;

				}
				page_count [ playerid ] = page_id ;

				new query_string [ 69 + 9 + 4 ] ;
				format ( query_string, sizeof query_string, "SELECT * FROM `house_objects` WHERE `object_house` = '%d' LIMIT %d", GetPVarInt ( playerid, "adm_house_id" ), MAX_HOUSE_OBJECT ) ;
				mysql_tquery ( sql_connection, query_string, "adm_house_objects_callback", "ii", playerid, GetPVarInt ( playerid, "adm_house_id" ) ) ;
				return 1 ;

			}
			else if ( listitem == get_player_use_page ( playerid, 1 ) )
			{
				clear_player_use_page ( playerid ) ;
				new page_id = page_count [ playerid ] - 1 ;
				if ( ofm_formula ( page_id ) >= page_rows [ playerid ] )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка объектов." ) ;

					new query_string [ 69 + 9 + 4 ] ;
					format ( query_string, sizeof query_string, "SELECT * FROM `house_objects` WHERE `object_house` = '%d' LIMIT %d", GetPVarInt ( playerid, "adm_house_id" ), MAX_HOUSE_OBJECT ) ;
					mysql_tquery ( sql_connection, query_string, "adm_house_objects_callback", "ii", playerid, GetPVarInt ( playerid, "adm_house_id" ) ) ;
					return 1 ;
				}
				page_count [ playerid ] = page_id + 2 ;

				new query_string [ 69 + 9 + 4 ] ;
				format ( query_string, sizeof query_string, "SELECT * FROM `house_objects` WHERE `object_house` = '%d' LIMIT %d", GetPVarInt ( playerid, "adm_house_id" ), MAX_HOUSE_OBJECT ) ;
				mysql_tquery ( sql_connection, query_string, "adm_house_objects_callback", "ii", playerid, GetPVarInt ( playerid, "adm_house_id" ) ) ;
				return 1 ;
			}
			else
			{
				set_player_use_listitem ( playerid, get_player_listitem_values ( playerid, listitem ) ) ;
				clear_player_listitem_values ( playerid ) ;

				show_dialog ( playerid, d_adm_house_object_set, DIALOG_STYLE_LIST, "{"#cBHD"}Выберите действие", "Загрузить объект\nРедактировать объект\nОдобрить объект\nУдалить объект", "Выбрать", "Назад" ) ;
			}
			return 1 ;
		}
		case d_adm_house_object_set:
		{
			if ( ! response )
			{
				clear_player_listitem_values ( playerid ) ;
				page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
				DeletePVar ( playerid, "adm_house_id" ) ;
				return 1 ;
			}

			switch ( listitem )
			{
				case 0:
				{
					new listitem_id = get_player_use_listitem ( playerid ) ;

					new query_string [ 60 + 9 ] ;
					format ( query_string, sizeof query_string, "SELECT * FROM `house_objects` WHERE `o_id` = '%d' LIMIT 1", listitem_id ) ;
					mysql_tquery ( sql_connection, query_string, "adm_ph_object_load_callback", "i", playerid ) ;
				}
				case 1:
				{
					new listitem_id = get_player_use_listitem ( playerid ) ;

					new query_string [ 60 + 9 ] ;
					format ( query_string, sizeof query_string, "SELECT * FROM `house_objects` WHERE `o_id` = '%d' LIMIT 1", listitem_id ) ;
					mysql_tquery ( sql_connection, query_string, "adm_eh_object_load_callback", "i", playerid ) ;
				}
				case 2:
				{
					new listitem_id = get_player_use_listitem ( playerid ) ;

					new query_string [ 60 + 9 ] ;
					format ( query_string, sizeof query_string, "SELECT * FROM `house_objects` WHERE `o_id` = '%d' LIMIT 1", listitem_id ) ;
					mysql_tquery ( sql_connection, query_string, "adm_h_object_load_callback", "i", playerid ) ;
				}
				case 3:
				{
					new listitem_id = get_player_use_listitem ( playerid ) ;

					new query_string [ 60 + 9 ] ;
					format ( query_string, sizeof query_string, "SELECT * FROM `house_objects` WHERE `o_id` = '%d' LIMIT 1", listitem_id ) ;
					mysql_tquery ( sql_connection, query_string, "adm_dh_object_load_callback", "i", playerid ) ;
				}
			}
		}
	}
	return 1 ;
}

stock show_house_object_buy ( playerid )
{
	global_string [ 0 ] = EOS ;
	new line_string [ 128 ] ;
	for ( new i = 0 ; i < MAX_CREATE_HOUSE_OBJECT ; i ++ )
	{
		format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s - {"#cGN"}%d "donate_title"\n", i + 1, name_house_object [ i ], price_house_object [ i ] ) ;
		strcat ( global_string, line_string ) ;
	}
	strcat ( global_string, "{"#cGRDialog"}Оформить заказ" ) ;
	show_dialog ( playerid, d_house_object_buy, DIALOG_STYLE_LIST, "{"#cBHD"}Объекты к дому", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock clear_player_hobject ( playerid )
{
	for ( new i = 0 ; i < MAX_CREATE_HOUSE_OBJECT ; i ++ )
	{
		if ( IsValidDynamicObject ( ho_player [ playerid ] [ i ] [ player_house_object ] ) ) DestroyDynamicObject ( ho_player [ playerid ] [ i ] [ player_house_object ] ) ;
		
		ho_player [ playerid ] [ i ] [ player_house_object ] =
		ho_player [ playerid ] [ i ] [ create_house_object ] =
		ho_player [ playerid ] [ i ] [ player_house_object_inc ] = -1 ;
	}
	return 1 ;
}

callback: adm_ph_object_load_callback ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		page_count [ playerid ] = 0 ;
		page_rows [ playerid ] = 0 ;
		DeletePVar ( playerid, "adm_house_id" ) ;
		return 1 ;
	}
	
	new object_status = cache_get_field_content_int ( 0, "object_status", sql_connection ) ;
	
	if ( object_status == 1 )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный объект уже установлен!" ) ;
		
		new query_string [ 69 + 9 + 4 ] ;
		format ( query_string, sizeof query_string, "SELECT * FROM `house_objects` WHERE `object_house` = '%d' LIMIT %d", GetPVarInt ( playerid, "adm_house_id" ), MAX_HOUSE_OBJECT ) ;
		mysql_tquery ( sql_connection, query_string, "adm_house_objects_callback", "ii", playerid, GetPVarInt ( playerid, "adm_house_id" ) ) ;
		return 1 ;
	}
	
	for ( new i = 0 ; i < MAX_CREATE_HOUSE_OBJECT ; i ++ )
	{
		if ( ho_player [ playerid ] [ i ] [ player_house_object ] != -1 ) continue ;
		
		ho_player [ playerid ] [ i ] [ create_house_object ] = cache_get_field_content_int ( 0, "object_id", sql_connection ) ;
		
		ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ] = cache_get_field_content_float ( 0, "object_x", sql_connection ) ;
		ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ] = cache_get_field_content_float ( 0, "object_y", sql_connection ) ;
		ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ] = cache_get_field_content_float ( 0, "object_z", sql_connection ) ;
		ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 3 ] = cache_get_field_content_float ( 0, "object_rx", sql_connection ) ;
		ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 4 ] = cache_get_field_content_float ( 0, "object_ry", sql_connection ) ;
		ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 5 ] = cache_get_field_content_float ( 0, "object_rz", sql_connection ) ;
		
		ho_player [ playerid ] [ i ] [ player_house_object ] = CreateDynamicObject ( ho_player [ playerid ] [ i ] [ create_house_object ], 
							ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ], 
							ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ], 
							ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ], 
							ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 3 ], 
							ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 4 ], 
							ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 5 ], 
							0, 0, -1, 300.00,  300.00) ;
		break ;
	}
	
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно выгрузили объект. Для удаления используйте /h_object_dell" ) ;
	return 1 ;
}

callback: adm_eh_object_load_callback ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		page_count [ playerid ] = 0 ;
		page_rows [ playerid ] = 0 ;
		DeletePVar ( playerid, "adm_house_id" ) ;
		return 1 ;
	}
	
	new _inc_id = cache_get_field_content_int ( 0, "o_id", sql_connection ) ;
	for ( new i = 0 ; i < MAX_CREATE_HOUSE_OBJECT ; i ++ )
	{
		if ( ho_player [ playerid ] [ i ] [ player_house_object ] != -1 ) continue ;
		if ( _inc_id == ho_player [ playerid ] [ i ] [ player_house_object_inc ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже устанавливаете данный объект." ) ;
	}
	
	for ( new i = 0 ; i < MAX_CREATE_HOUSE_OBJECT ; i ++ )
	{
		if ( ho_player [ playerid ] [ i ] [ player_house_object ] != -1 ) continue ;
		
		ho_player [ playerid ] [ i ] [ player_house_object_inc ] = _inc_id ;
		ho_player [ playerid ] [ i ] [ create_house_object ] = cache_get_field_content_int ( 0, "object_id", sql_connection ) ;
		new house_id = cache_get_field_content_int ( 0, "object_house", sql_connection ) ;
		
		ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ] = cache_get_field_content_float ( 0, "object_x", sql_connection ) ;
		ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ] = cache_get_field_content_float ( 0, "object_y", sql_connection ) ;
		ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ] = cache_get_field_content_float ( 0, "object_z", sql_connection ) ;
		ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 3 ] = cache_get_field_content_float ( 0, "object_rx", sql_connection ) ;
		ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 4 ] = cache_get_field_content_float ( 0, "object_ry", sql_connection ) ;
		ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 5 ] = cache_get_field_content_float ( 0, "object_rz", sql_connection ) ;
		
		ho_player [ playerid ] [ i ] [ player_house_object ] = CreateDynamicObject ( ho_player [ playerid ] [ i ] [ create_house_object ], 
							ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ], 
							ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ], 
							ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ], 
							ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 3 ], 
							ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 4 ], 
							ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 5 ], 
							0, 0, -1, 300.00,  300.00) ;

		SetPVarInt ( playerid, "edit_house_object", house_id ) ;
		create_inc_id [ playerid ] = i ;
		create_object_id [ playerid ] = ho_player [ playerid ] [ i ] [ player_house_object ] ;
		create_type { playerid } = 7 ;
		if ( player_device { playerid } == 2 ) mobile_object_edit ( playerid, true, ho_player [ playerid ] [ i ] [ create_house_object ] ) ;
		else EditDynamicObject(playerid, ho_player [ playerid ] [ i ] [ player_house_object ] ) ;
		break ;
	}
	
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно выгрузили объект. Редактируйте!" ) ;
	return 1 ;
}

callback: adm_h_object_load_callback ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		page_count [ playerid ] = 0 ;
		page_rows [ playerid ] = 0 ;
		DeletePVar ( playerid, "adm_house_id" ) ;
		return 1 ;
	}
	
	new object_status = cache_get_field_content_int ( 0, "object_status", sql_connection ) ;
	
	if ( object_status == 1 )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данный объект уже установлен!" ) ;
		
		new query_string [ 69 + 9 + 4 ] ;
		format ( query_string, sizeof query_string, "SELECT * FROM `house_objects` WHERE `object_house` = '%d' LIMIT %d", GetPVarInt ( playerid, "adm_house_id" ), MAX_HOUSE_OBJECT ) ;
		mysql_tquery ( sql_connection, query_string, "adm_house_objects_callback", "ii", playerid, GetPVarInt ( playerid, "adm_house_id" ) ) ;
		return 1 ;
	}
	
	new house_id = GetPVarInt ( playerid, "adm_house_id" ) ;
	for ( new i = 0 ; i < MAX_HOUSE_OBJECT ; i ++ )
	{
		if ( house_object_id [ house_id ] [ i ] != -1 ) continue ;
		
		house_object_inc_id [ house_id ] [ i ] = cache_get_field_content_int ( 0, "o_id", sql_connection ) ;
		house_object [ house_id ] [ i ] = cache_get_field_content_int ( 0, "object_id", sql_connection ) ;
		
		house_pos_object [ house_id ] [ i ] [ 0 ] = cache_get_field_content_float ( 0, "object_x", sql_connection ) ;
		house_pos_object [ house_id ] [ i ] [ 1 ] = cache_get_field_content_float ( 0, "object_y", sql_connection ) ;
		house_pos_object [ house_id ] [ i ] [ 2 ] = cache_get_field_content_float ( 0, "object_z", sql_connection ) ;
		house_pos_object [ house_id ] [ i ] [ 3 ] = cache_get_field_content_float ( 0, "object_rx", sql_connection ) ;
		house_pos_object [ house_id ] [ i ] [ 4 ] = cache_get_field_content_float ( 0, "object_ry", sql_connection ) ;
		house_pos_object [ house_id ] [ i ] [ 5 ] = cache_get_field_content_float ( 0, "object_rz", sql_connection ) ;
		
		house_pos_object_open [ house_id ] [ i ] [ 0 ] = cache_get_field_content_float ( 0, "object_open_x", sql_connection ) ;
		house_pos_object_open [ house_id ] [ i ] [ 1 ] = cache_get_field_content_float ( 0, "object_open_y", sql_connection ) ;
		house_pos_object_open [ house_id ] [ i ] [ 2 ] = cache_get_field_content_float ( 0, "object_open_z", sql_connection ) ;
		house_pos_object_open [ house_id ] [ i ] [ 3 ] = cache_get_field_content_float ( 0, "object_open_rx", sql_connection ) ;
		house_pos_object_open [ house_id ] [ i ] [ 4 ] = cache_get_field_content_float ( 0, "object_open_ry", sql_connection ) ;
		house_pos_object_open [ house_id ] [ i ] [ 5 ] = cache_get_field_content_float ( 0, "object_open_rz", sql_connection ) ;
		
		house_object_id [ house_id ] [ i ] = CreateDynamicObject ( house_object [ house_id ] [ i ], 
							house_pos_object [ house_id ] [ i ] [ 0 ], 
							house_pos_object [ house_id ] [ i ] [ 1 ], 
							house_pos_object [ house_id ] [ i ] [ 2 ], 
							house_pos_object [ house_id ] [ i ] [ 3 ], 
							house_pos_object [ house_id ] [ i ] [ 4 ], 
							house_pos_object [ house_id ] [ i ] [ 5 ], 
							0, 0, -1, 300.00,  300.00) ;
							
		if ( house_object [ house_id ] [ i ] == 968 )
		{
			CreateDynamic3DTextLabel("** Шлагбаум **\n{"#cGR3D"}Нажмите {"#cWH3D"}H{"#cGR3D"}, чтобы открыть",col_blue,
										house_pos_object [ house_id ] [ i ] [ 0 ], house_pos_object [ house_id ] [ i ] [ 1 ], house_pos_object [ house_id ] [ i ] [ 2 ],
										15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
		}
		else if ( house_object [ house_id ] [ i ] == 980 ||
			house_object [ house_id ] [ i ] == 971 ||
			house_object [ house_id ] [ i ] == 988 ||
			house_object [ house_id ] [ i ] == 968 ||
			house_object [ house_id ] [ i ] == 989 )
		{
			CreateDynamic3DTextLabel("** Ворота **\n{"#cGR3D"}Нажмите {"#cWH3D"}H{"#cGR3D"}, чтобы открыть",col_blue,
										house_pos_object [ house_id ] [ i ] [ 0 ], house_pos_object [ house_id ] [ i ] [ 1 ], house_pos_object [ house_id ] [ i ] [ 2 ],
										15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
		}
							
		new query_string [ 79 + 9 ] ;
		format ( query_string, sizeof query_string, "UPDATE `house_objects` SET `object_status` = '1' WHERE `o_id` = '%d' LIMIT 1", get_player_use_listitem ( playerid ) ) ;
		mysql_tquery ( sql_connection, query_string, "", "" ) ;
		break ;
	}
	
	house_object_count [ house_id ] ++ ;
	
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно одобрили объект. Для удаления используйте /h_object" ) ;
	return 1 ;
}

callback: adm_dh_object_load_callback ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		page_count [ playerid ] = 0 ;
		page_rows [ playerid ] = 0 ;
		DeletePVar ( playerid, "adm_house_id" ) ;
		return 1 ;
	}
	
	new house_id = GetPVarInt ( playerid, "adm_house_id" ) ;
	new object_id = cache_get_field_content_int ( 0, "o_id", sql_connection ) ;
	for ( new i = 0 ; i < MAX_HOUSE_OBJECT ; i ++ )
	{
		if ( house_object_id [ house_id ] [ i ] == -1 ) continue ;
		
		if ( house_object_inc_id [ house_id ] [ i ] == object_id )
		{
			DestroyDynamicObject ( house_object_id [ house_id ] [ i ] ) ;
			house_object_id [ house_id ] [ i ] = -1 ;
			house_object [ house_id ] [ i ] = -1 ;
		}
		new query_string [ 58 + 9 ] ;
		format ( query_string, sizeof query_string, "DELETE FROM `house_objects` WHERE `o_id` = '%d' LIMIT 1", get_player_use_listitem ( playerid ) ) ;
		mysql_tquery ( sql_connection, query_string, "", "" ) ;
		break ;
	}
	
	house_object_count [ house_id ] -- ;
	
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Объект успешно удалён." ) ;
	return 1 ;
}

CMD:h_object ( playerid, params [ ] )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	if ( sscanf ( params, "d", params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}Используйте: /h_object [номер дома]" ) ;
	if ( params [ 0 ] < 1 || params [ 0 ] > house_count ) return SendClientMessage ( playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}Не правильно указан номер дома." ) ;
	
	page_count [ playerid ] = 1 ;
	
	new query_string [ 69 + 9 + 4 ] ;
	format ( query_string, sizeof query_string, "SELECT * FROM `house_objects` WHERE `object_house` = '%d' LIMIT %d", params [ 0 ], MAX_HOUSE_OBJECT ) ;
	mysql_tquery ( sql_connection, query_string, "adm_house_objects_callback", "ii", playerid, params [ 0 ] ) ;
	
	SetPVarInt ( playerid, "adm_house_id", params [ 0 ] ) ;
	return 1 ;
}

CMD:h_object_dell ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	clear_player_hobject ( playerid ) ;
	return 1 ;
}

CMD:h_object_edit ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	
	SetPVarInt ( playerid, "h_open_gate", 1 ) ;
	
	new i = create_object_id [ playerid ] ;							
	create_type { playerid } = 7 ;
	if ( player_device { playerid } == 2 ) mobile_object_edit ( playerid, true, ho_player [ playerid ] [ i ] [ create_house_object ] ) ;
	else EditDynamicObject(playerid, ho_player [ playerid ] [ i ] [ player_house_object ] ) ;
	return 1 ;
}

callback: adm_house_objects_callback ( playerid, _house_h_id )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		DeletePVar ( playerid, "adm_house_id" ) ;
		page_count [ playerid ] = 0 ;
		SendClientMessage ( playerid, col_gray,"{"#cRInfo"}* {"#cGRInfo"}У выбранного дома нет объектов." ) ;
		return 1 ;
	}
	
	new rows_list = page_count [ playerid ] - 1 ;
	page_rows [ playerid ] = rows ;
	new line_string [ 128 ], row_count ;

	global_string [ 0 ] = EOS ;
	for ( new i = rows_list * 10 ; i <  rows_list * 10 + 10 ; i ++ )
	{
		if ( i >= rows ) break ;

		new o_id = cache_get_field_content_int ( i, "o_id", sql_connection ) ;
		new object_id = cache_get_field_content_int ( i, "object_id", sql_connection ) ;
		new object_status = cache_get_field_content_int ( i, "object_status", sql_connection ) ;
		
		set_player_listitem_values ( playerid, i - rows_list * 10, o_id ) ;

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%d. {"#cWH"}Object ID: %d {"#cGRDialog"}(%s{"#cGRDialog"})\n", i + 1, object_id, ( object_status == 1 ) ? ( "{"#cGN"}Установлен" ) : ( "{"#cRD"}Не установлен" ) ) ;
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
	
	format ( line_string, sizeof line_string, "{"#cBHD"}Объекты дома {"#cWH"}№%d", _house_h_id ) ;
	show_dialog ( playerid, d_adm_house_object, DIALOG_STYLE_LIST, line_string, global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock h_OnPlayerEditDynamicObject(playerid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if ( player_device { playerid } != 2 && response == EDIT_RESPONSE_FINAL || player_device { playerid } == 2 && response == 1 )
	{
		if ( create_type { playerid } == 6 )
		{
			new h = p_info [ playerid ] [ house ] - 1 ;
			
			new Float: a = GetDistanceBetweenPoints ( x, y, z, h_info [ h ] [ h_pos ] [ 0 ], h_info [ h ] [ h_pos ] [ 1 ], h_info [ h ] [ h_pos ] [ 2 ] ) ;
			if ( a > 15 )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы не рядом с домом." ) ;
				
				new i = create_inc_id [ playerid ] ;
				DestroyDynamicObject ( ho_player [ playerid ] [ i ] [ player_house_object ] ) ;
				create_type { playerid } = 0 ;
				create_object_id [ playerid ] = INVALID_OBJECT_ID ;
				
				show_house_object_buy ( playerid ) ;
				return 1 ;
			}
		
			new i = create_inc_id [ playerid ] ;
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ] = x ;
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ] = y ;
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ] = z ;
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 3 ] = rx ;
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 4 ] = ry ;
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 5 ] = rz ;
			
			DestroyDynamicObject ( ho_player [ playerid ] [ i ] [ player_house_object ] ) ;
			ho_player [ playerid ] [ i ] [ player_house_object ] = CreateDynamicObject ( ho_player [ playerid ] [ i ] [ create_house_object ],
																			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ],
																			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ],
																			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ],
																			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 3 ],
																			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 4 ],
																			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 5 ], 0, 0, -1, 300.0, 300.0 ) ;

			create_type { playerid } = 0 ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			CancelEdit ( playerid ) ;

			SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы выбрали позицию для объекта. Можете оформить заказ, либо же докупить ещё объектов." ) ;
			show_house_object_buy ( playerid ) ;
			return 1 ;
		}
		if ( GetPVarInt ( playerid, "h_open_gate" ) )
		{
			if ( create_type { playerid } == 7 )
			{
				new house_id = GetPVarInt ( playerid, "edit_house_object" ) ;
				DeletePVar ( playerid, "edit_house_object" ) ;
				
				new Float: a = GetDistanceBetweenPoints ( x, y, z, h_info [ house_id - 1 ] [ h_pos ] [ 0 ], h_info [ house_id - 1 ] [ h_pos ] [ 1 ], h_info [ house_id - 1 ] [ h_pos ] [ 2 ] ) ;
				if ( a > 15 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы не рядом с домом." ) ;
					
					new i = create_inc_id [ playerid ] ;
					DestroyDynamicObject ( ho_player [ playerid ] [ i ] [ player_house_object ] ) ;
					create_type { playerid } = 0 ;
					create_object_id [ playerid ] = INVALID_OBJECT_ID ;
					return 1 ;
				}
				
				new i = create_inc_id [ playerid ] ;

                DestroyDynamicObject ( ho_player [ playerid ] [ i ] [ player_house_object ] ) ;
				ho_player [ playerid ] [ i ] [ player_house_object ] = CreateDynamicObject ( ho_player [ playerid ] [ i ] [ create_house_object ],
																				ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ],
																				ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ],
																				ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ],
																				ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 3 ],
																				ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 4 ],
																				ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 5 ], 0, 0, -1, 300.0, 300.0 ) ;

				new insert_string [ 203 + ( 8 * 6 ) + 9 ] ;
				format ( insert_string, sizeof insert_string, "UPDATE `house_objects` SET `object_open_x` = '%f', `object_open_y` = '%f', `object_open_z` = '%f', `object_open_rx` = '%f', `object_open_ry` = '%f', `object_open_rz` = '%f' WHERE `o_id` = '%d' LIMIT 1",
				house_pos_object_open [ playerid ] [ i ] [ 0 ], house_pos_object_open [ playerid ] [ i ] [ 1 ], house_pos_object_open [ playerid ] [ i ] [ 2 ],
				house_pos_object_open [ playerid ] [ i ] [ 3 ], house_pos_object_open [ playerid ] [ i ] [ 4 ], house_pos_object_open [ playerid ] [ i ] [ 5 ],
				get_player_use_listitem ( playerid ) ) ;
				mysql_tquery ( sql_connection, insert_string, "", "" ) ;

				for ( new q = 0 ; q < MAX_HOUSE_OBJECT ; q ++ )
				{
					if ( house_object_inc_id [ house_id ] [ q ] != ho_player [ playerid ] [ i ] [ player_house_object_inc ] ) continue ;

					if ( IsValidDynamicObject ( house_object_id [ house_id ] [ q ] ) ) DestroyDynamicObject ( house_object_id [ house_id ] [ q ] ) ;
					
					house_pos_object_open [ playerid ] [ q ] [ 0 ] = x ;
					house_pos_object_open [ playerid ] [ q ] [ 1 ] = y ;
					house_pos_object_open [ playerid ] [ q ] [ 2 ] = z ;
					house_pos_object_open [ playerid ] [ q ] [ 3 ] = rx ;
					house_pos_object_open [ playerid ] [ q ] [ 4 ] = ry ;
					house_pos_object_open [ playerid ] [ q ] [ 5 ] = rz ;
					
					house_object_id [ house_id ] [ q ] = CreateDynamicObject ( house_object [ house_id ] [ q ],
										house_pos_object [ house_id ] [ q ] [ 0 ],
										house_pos_object [ house_id ] [ q ] [ 1 ],
										house_pos_object [ house_id ] [ q ] [ 2 ],
										house_pos_object [ house_id ] [ q ] [ 3 ],
										house_pos_object [ house_id ] [ q ] [ 4 ],
										house_pos_object [ house_id ] [ q ] [ 5 ],
										0, 0, -1, 300.00,  300.00) ;
					break ;
				}

				create_type { playerid } = 0 ;
				create_object_id [ playerid ] = INVALID_OBJECT_ID ;
				DeletePVar ( playerid, "h_open_gate" ) ;
				CancelEdit ( playerid ) ;
				return 1 ;
			}
		}
		if ( create_type { playerid } == 7 )
		{
			new house_id = GetPVarInt ( playerid, "edit_house_object" ) ;
			DeletePVar ( playerid, "edit_house_object" ) ;
			
			new Float: a = GetDistanceBetweenPoints ( x, y, z, h_info [ house_id - 1 ] [ h_pos ] [ 0 ], h_info [ house_id - 1 ] [ h_pos ] [ 1 ], h_info [ house_id - 1 ] [ h_pos ] [ 2 ] ) ;
			if ( a > 15 )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы не рядом с домом." ) ;
				
				new i = create_inc_id [ playerid ] ;
				DestroyDynamicObject ( ho_player [ playerid ] [ i ] [ player_house_object ] ) ;
				create_type { playerid } = 0 ;
				create_object_id [ playerid ] = INVALID_OBJECT_ID ;
				return 1 ;
			}
			
			new i = create_inc_id [ playerid ] ;
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ] = x ;
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ] = y ;
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ] = z ;
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 3 ] = rx ;
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 4 ] = ry ;
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 5 ] = rz ;

            DestroyDynamicObject ( ho_player [ playerid ] [ i ] [ player_house_object ] ) ;
			ho_player [ playerid ] [ i ] [ player_house_object ] = CreateDynamicObject ( ho_player [ playerid ] [ i ] [ create_house_object ],
																			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ],
																			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ],
																			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ],
																			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 3 ],
																			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 4 ],
																			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 5 ], 0, 0, -1, 300.0, 300.0 ) ;

			new insert_string [ 173 + ( 8 * 6 ) + 9 ] ;
			format ( insert_string, sizeof insert_string, "UPDATE `house_objects` SET `object_x` = '%f', `object_y` = '%f', `object_z` = '%f', `object_rx` = '%f', `object_ry` = '%f', `object_rz` = '%f' WHERE `o_id` = '%d' LIMIT 1",
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 0 ], ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 1 ], ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 2 ],
			ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 3 ], ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 4 ], ho_player [ playerid ] [ i ] [ create_house_pos_object ] [ 5 ],
			get_player_use_listitem ( playerid ) ) ;
			mysql_tquery ( sql_connection, insert_string, "", "" ) ;

			for ( new q = 0 ; q < MAX_HOUSE_OBJECT ; q ++ )
			{
				if ( house_object_inc_id [ house_id ] [ q ] != ho_player [ playerid ] [ i ] [ player_house_object_inc ] ) continue ;
				
				if ( IsValidDynamicObject ( house_object_id [ house_id ] [ q ] ) ) DestroyDynamicObject ( house_object_id [ house_id ] [ q ] ) ;
				
				house_pos_object [ playerid ] [ q ] [ 0 ] = x ;
				house_pos_object [ playerid ] [ q ] [ 1 ] = y ;
				house_pos_object [ playerid ] [ q ] [ 2 ] = z ;
				house_pos_object [ playerid ] [ q ] [ 3 ] = rx ;
				house_pos_object [ playerid ] [ q ] [ 4 ] = ry ;
				house_pos_object [ playerid ] [ q ] [ 5 ] = rz ;

				house_object_id [ house_id ] [ q ] = CreateDynamicObject ( house_object [ house_id ] [ q ],
									house_pos_object [ house_id ] [ q ] [ 0 ],
									house_pos_object [ house_id ] [ q ] [ 1 ],
									house_pos_object [ house_id ] [ q ] [ 2 ],
									house_pos_object [ house_id ] [ q ] [ 3 ],
									house_pos_object [ house_id ] [ q ] [ 4 ],
									house_pos_object [ house_id ] [ q ] [ 5 ],
									0, 0, -1, 300.00,  300.00) ;
				break ;
			}

			if ( ho_player [ playerid ] [ i ] [ create_house_object ] == 968 ||
					ho_player [ playerid ] [ i ] [ create_house_object ] == 980 ||
					ho_player [ playerid ] [ i ] [ create_house_object ] == 971 ||
					ho_player [ playerid ] [ i ] [ create_house_object ] == 988 ||
					ho_player [ playerid ] [ i ] [ create_house_object ] == 968 ||
					ho_player [ playerid ] [ i ] [ create_house_object ] == 989) SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Для установки открытой позиции объекта используйте /h_object_edit." ) ;

			create_type { playerid } = 0 ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			CancelEdit ( playerid ) ;
			return 1 ;
		}
	}
	if ( player_device { playerid } != 2 && response == EDIT_RESPONSE_CANCEL || player_device { playerid } == 2 && response == 2 )
	{
		if ( create_type { playerid } == 6 )
		{
			DestroyDynamicObject ( ho_player [ playerid ] [ create_inc_id [ playerid ] ] [ player_house_object ] ) ;
			create_type { playerid } = 0 ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			CancelEdit ( playerid ) ;

			SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы отменили редактирование объекта." ) ;
			show_house_object_buy ( playerid ) ;
			return 1 ;
		}
		if ( create_type { playerid } == 7 )
		{
		    DestroyDynamicObject ( ho_player [ playerid ] [ create_inc_id [ playerid ] ] [ player_house_object ] ) ;
			create_type { playerid } = 0 ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			DeletePVar ( playerid, "edit_house_object" ) ;
			DeletePVar ( playerid, "h_open_gate" ) ;
			CancelEdit ( playerid ) ;
			return 1 ;
		}
	}
	return 0 ;
}

callback: houses_object_loading ( )
{
	new rows, fields, time = GetTickCount ( ) ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		new object_status, house_id ;
		for ( new r = 0 ; r < rows ; r ++ )
		{
			object_status = cache_get_field_content_int ( r, "object_status", sql_connection ) ;
		
			if ( object_status == 0 ) continue ;
		
			house_id = cache_get_field_content_int ( r, "object_house", sql_connection ) ;
			for ( new i = 0 ; i < MAX_HOUSE_OBJECT ; i ++ )
			{
				if ( house_object_id [ house_id ] [ i ] != -1 ) continue ;
				
				house_object_inc_id [ house_id ] [ i ] = cache_get_field_content_int ( r, "o_id", sql_connection ) ;
				house_object [ house_id ] [ i ] = cache_get_field_content_int ( r, "object_id", sql_connection ) ;
				
				house_pos_object [ house_id ] [ i ] [ 0 ] = cache_get_field_content_float ( r, "object_x", sql_connection ) ;
				house_pos_object [ house_id ] [ i ] [ 1 ] = cache_get_field_content_float ( r, "object_y", sql_connection ) ;
				house_pos_object [ house_id ] [ i ] [ 2 ] = cache_get_field_content_float ( r, "object_z", sql_connection ) ;
				house_pos_object [ house_id ] [ i ] [ 3 ] = cache_get_field_content_float ( r, "object_rx", sql_connection ) ;
				house_pos_object [ house_id ] [ i ] [ 4 ] = cache_get_field_content_float ( r, "object_ry", sql_connection ) ;
				house_pos_object [ house_id ] [ i ] [ 5 ] = cache_get_field_content_float ( r, "object_rz", sql_connection ) ;
				
				house_pos_object_open [ house_id ] [ i ] [ 0 ] = cache_get_field_content_float ( r, "object_open_x", sql_connection ) ;
				house_pos_object_open [ house_id ] [ i ] [ 1 ] = cache_get_field_content_float ( r, "object_open_y", sql_connection ) ;
				house_pos_object_open [ house_id ] [ i ] [ 2 ] = cache_get_field_content_float ( r, "object_open_z", sql_connection ) ;
				house_pos_object_open [ house_id ] [ i ] [ 3 ] = cache_get_field_content_float ( r, "object_open_rx", sql_connection ) ;
				house_pos_object_open [ house_id ] [ i ] [ 4 ] = cache_get_field_content_float ( r, "object_open_ry", sql_connection ) ;
				house_pos_object_open [ house_id ] [ i ] [ 5 ] = cache_get_field_content_float ( r, "object_open_rz", sql_connection ) ;
				
				if ( house_object [ house_id ] [ i ] == 968 )
				{
					CreateDynamic3DTextLabel("** Шлагбаум **\n{"#cGR3D"}Нажмите {"#cWH3D"}H{"#cGR3D"}, чтобы открыть",col_blue,
												house_pos_object [ house_id ] [ i ] [ 0 ], house_pos_object [ house_id ] [ i ] [ 1 ], house_pos_object [ house_id ] [ i ] [ 2 ],
												15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
				}
				else if ( house_object [ house_id ] [ i ] == 980 ||
					house_object [ house_id ] [ i ] == 971 ||
					house_object [ house_id ] [ i ] == 988 ||
					house_object [ house_id ] [ i ] == 968 ||
					house_object [ house_id ] [ i ] == 989 )
				{
					CreateDynamic3DTextLabel("** Ворота **\n{"#cGR3D"}Нажмите {"#cWH3D"}H{"#cGR3D"}, чтобы открыть",col_blue,
												house_pos_object [ house_id ] [ i ] [ 0 ], house_pos_object [ house_id ] [ i ] [ 1 ], house_pos_object [ house_id ] [ i ] [ 2 ],
												15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
				}
				
				house_object_id [ house_id ] [ i ] = CreateDynamicObject ( house_object [ house_id ] [ i ], 
									house_pos_object [ house_id ] [ i ] [ 0 ], 
									house_pos_object [ house_id ] [ i ] [ 1 ], 
									house_pos_object [ house_id ] [ i ] [ 2 ], 
									house_pos_object [ house_id ] [ i ] [ 3 ], 
									house_pos_object [ house_id ] [ i ] [ 4 ], 
									house_pos_object [ house_id ] [ i ] [ 5 ], 
									0, 0, -1, 300.00,  300.00) ;
				break ;
			}
			house_object_count [ house_id ] ++ ;
		}
	}
	printf ( "[SERVER] Загружено %d объектов к домам. (%d ms)", rows, GetTickCount ( ) - time ) ;
	return 1 ;
}

stock h_OnPlayerKeyStateChange ( playerid, newkeys )
{
	new g_state = GetPlayerState ( playerid ) ;
	if( ( g_state == PLAYER_STATE_DRIVER || g_state == PLAYER_STATE_PASSENGER ) && newkeys == KEY_CROUCH || g_state == PLAYER_STATE_ONFOOT && newkeys & KEY_CTRL_BACK )
	{
		if ( Iter_Count(player_houses[playerid]) > 0 || p_info [ playerid ] [ rent_house ] > 0 )
		{
			new h = -1 ;
			if ( Iter_Count(player_houses[playerid]) > 0 )
			{
				foreach(new _h: player_houses[playerid])
				{
					if ( IsPlayerInRangeOfPoint ( playerid, 50, h_info [ _h - 1 ] [ h_pos ] [ 0 ], h_info [ _h - 1 ] [ h_pos ] [ 1 ], h_info [ _h - 1 ] [ h_pos ] [ 2 ] ) )
					{
						p_info [ playerid ] [ house ] = _h ;
						h = _h - 1 ;
						break ;
					}
				}
			}
			else h = p_info [ playerid ] [ rent_house ] - 1 ;
			
			if ( h < 0 ) return 0 ;
			if ( house_object_count [ h + 1 ] < 1 ) return 0 ;

			for ( new s = 0 ; s < house_object_count [ h + 1 ] ; s ++ )
			{
				if ( house_object [ h + 1 ] [ s ] != 968 && house_object [ h + 1 ] [ s ] != 980 && house_object [ h + 1 ] [ s ] != 971 && 
					house_object [ h + 1 ] [ s ] != 988 && house_object [ h + 1 ] [ s ] != 989 ) continue ;
					
				if ( IsPlayerInRangeOfPoint ( playerid, 10.0, house_pos_object [ h + 1 ] [ s ] [ 0 ], house_pos_object [ h + 1 ] [ s ] [ 1 ], house_pos_object [ h + 1 ] [ s ] [ 2 ] ) )
				{
					if ( house_object [ h + 1 ] [ s ] == 968) 
					{
						SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Шлагбаум опустится в течение {"#cBL"}10 секунд{"#cGRInfo"}." ) ;
						
						MoveDynamicObject ( house_object_id [ h + 1 ] [ s ],
										house_pos_object_open [ h + 1 ] [ s ] [ 0 ],
										house_pos_object_open [ h + 1 ] [ s ] [ 1 ],
										house_pos_object_open [ h + 1 ] [ s ] [ 2 ],
														0.07,
										house_pos_object_open [ h + 1 ] [ s ] [ 3 ],
										house_pos_object_open [ h + 1 ] [ s ] [ 4 ],
										house_pos_object_open [ h + 1 ] [ s ] [ 5 ] ) ;
					}
					else 
					{
						SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Ворота закроются в течение {"#cBL"}10 секунд{"#cGRInfo"}." ) ;
						
						MoveDynamicObject ( house_object_id [ h + 1 ] [ s ],
										house_pos_object_open [ h + 1 ] [ s ] [ 0 ],
										house_pos_object_open [ h + 1 ] [ s ] [ 1 ],
										house_pos_object_open [ h + 1 ] [ s ] [ 2 ],
														0.8,
										house_pos_object_open [ h + 1 ] [ s ] [ 3 ],
										house_pos_object_open [ h + 1 ] [ s ] [ 4 ],
										house_pos_object_open [ h + 1 ] [ s ] [ 5 ] ) ;
					}

					SetTimerEx("close_house_gate", 10000, 0, "iii", h + 1, s ) ;
					return 1 ;
				}
			}
		}
	}
	return 0 ;
}

callback: close_house_gate ( _house_h_id, _slot_id )
{
	if ( house_object [ _house_h_id ] [ _slot_id ] == 968 )
	{
		MoveDynamicObject ( house_object_id [ _house_h_id ] [ _slot_id ], 
						house_pos_object [ _house_h_id ] [ _slot_id ] [ 0 ], 
						house_pos_object [ _house_h_id ] [ _slot_id ] [ 1 ], 
						house_pos_object [ _house_h_id ] [ _slot_id ] [ 2 ],
							0.07, 
						house_pos_object [ _house_h_id ] [ _slot_id ] [ 3 ], 
						house_pos_object [ _house_h_id ] [ _slot_id ] [ 4 ], 
						house_pos_object [ _house_h_id ] [ _slot_id ] [ 5 ] ) ;
	}
	else
	{
		MoveDynamicObject ( house_object_id [ _house_h_id ] [ _slot_id ], 
						house_pos_object [ _house_h_id ] [ _slot_id ] [ 0 ], 
						house_pos_object [ _house_h_id ] [ _slot_id ] [ 1 ], 
						house_pos_object [ _house_h_id ] [ _slot_id ] [ 2 ],
							0.8, 
						house_pos_object [ _house_h_id ] [ _slot_id ] [ 3 ], 
						house_pos_object [ _house_h_id ] [ _slot_id ] [ 4 ], 
						house_pos_object [ _house_h_id ] [ _slot_id ] [ 5 ] ) ;
	}
	return 1 ;
}