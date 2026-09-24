#define MAX_CASKET 10
enum _casket
{
	c_id,
	c_model,
	c_count
} ;
new casket [ MAX_CASKET ] [ _casket ] ;

enum
{
	CASKET_ITEM_COMMON = 0,
	CASKET_ITEM_RARE,
	CASKET_ITEM_EPIC,
	CASKET_ITEM_LEGENDARY
} ;

enum _casket_item
{
	c_model,
	c_rare
} ;

#define MAX_CASKET_BOX_0 8
new casket_box_0 [ MAX_CASKET_BOX_0 ] [ _casket_item ] =
{
	{ skin_cross + 4747, CASKET_ITEM_LEGENDARY },
	{ skin_cross + 4748, CASKET_ITEM_LEGENDARY },
	{ skin_cross + 4749, CASKET_ITEM_LEGENDARY },
	{ skin_cross + 4750, CASKET_ITEM_LEGENDARY },
	{ skin_cross + 4751, CASKET_ITEM_LEGENDARY },
	{ skin_cross + 4752, CASKET_ITEM_LEGENDARY },
	{ skin_cross + 4793, CASKET_ITEM_LEGENDARY },
	{ skin_cross + 4794, CASKET_ITEM_LEGENDARY }
} ;

#define MAX_CASKET_BOX_1 8
new casket_box_1 [ MAX_CASKET_BOX_1 ] [ _casket_item ] =
{
	{ skin_cross + 4714, CASKET_ITEM_LEGENDARY },
	{ skin_cross + 4652, CASKET_ITEM_LEGENDARY },
	{ skin_cross + 4657, CASKET_ITEM_LEGENDARY },
	{ 8250, CASKET_ITEM_LEGENDARY },
	{ 8249, CASKET_ITEM_LEGENDARY },
	{ 8251, CASKET_ITEM_LEGENDARY },
	{ 8252, CASKET_ITEM_LEGENDARY },
	{ 8254, CASKET_ITEM_LEGENDARY }
} ;

#define MAX_CASKET_BOX_2 7
new casket_box_2 [ MAX_CASKET_BOX_2 ] [ _casket_item ] =
{
	{ skin_cross + 4782, CASKET_ITEM_LEGENDARY },
	{ skin_cross + 4783, CASKET_ITEM_LEGENDARY },
	{ skin_cross + 4785, CASKET_ITEM_LEGENDARY },
	{ skin_cross + 4788, CASKET_ITEM_LEGENDARY },
	{ 5068, CASKET_ITEM_LEGENDARY },
	{ 5069, CASKET_ITEM_LEGENDARY },
	{ 5070, CASKET_ITEM_LEGENDARY }
} ;

#define MAX_CASKET_BOX_OTHER 16
new casket_box_other [ MAX_CASKET_BOX_OTHER ] [ _casket_item ] =
{
	{ 35, CASKET_ITEM_COMMON },
	{ 36, CASKET_ITEM_COMMON },
	{ 37, CASKET_ITEM_COMMON },
	{ 40, CASKET_ITEM_COMMON },
	{ 95, CASKET_ITEM_COMMON },
	{ 24, CASKET_ITEM_RARE },
	{ 28, CASKET_ITEM_RARE },
	{ 45, CASKET_ITEM_RARE },
	{ 128, CASKET_ITEM_RARE },
	{ 129, CASKET_ITEM_RARE },
	{ 131, CASKET_ITEM_RARE },
	{ 132, CASKET_ITEM_RARE },
	{ 55, CASKET_ITEM_EPIC },
	{ 130, CASKET_ITEM_EPIC },
	{ 133, CASKET_ITEM_EPIC },
	{ 134, CASKET_ITEM_EPIC }
} ;

stock casket_OnGameModeInit ( )
{
	mysql_tquery ( sql_connection, !"SELECT * FROM `casket`", "casket_loading" ) ;
	return 1 ;
}

callback: casket_loading ( )
{
	new rows, fields, time = GetTickCount ( ) ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		for ( new i = 0 ; i < rows ; i ++ )
		{
			casket [ i ] [ c_id ] = cache_get_field_content_int ( i, "c_id", sql_connection ) ;
			casket [ i ] [ c_model ] = cache_get_field_content_int ( i, "c_model", sql_connection ) ;
			casket [ i ] [ c_count ] = cache_get_field_content_int ( i, "c_count", sql_connection ) ;
		}
		
		printf ( "[SERVER] Загружено %d ларцов. (%d ms)", rows, GetTickCount ( ) - time ) ;
	}
	else print ( "[SERVER] Ларцы не были найдены в базе данных." ) ;
	return 1 ;
}

stock getCasketID ( _id )
{
	for ( new i = 0 ; i < MAX_CASKET ; i ++ )
	{
		if ( casket [ i ] [ c_id ] != _id ) continue ;
		
		return i ;
	}
	
	return -1 ;
}

stock updateCasketID ( _id )
{
	static const _str [ ] = "UPDATE `casket` SET `c_count` = '%d' WHERE `c_id` = '%d' LIMIT 1" ;
	new sql_string [ sizeof _str + ( 9 * 2 ) ] ;
	format ( sql_string, sizeof sql_string, _str, casket [ _id ] [ c_count ], casket [ _id ] [ c_id ] ) ;
	mysql_tquery ( sql_connection, sql_string ) ;
	return 1 ;
}

stock getCasketItem ( playerid, _id )
{
	new time = GetTickCount ( ) ;
	printf ( "[getCasketItem] started..." ) ;
	
	new _prise_id = -1, donate_count = random ( 50000 ), random_item, _count = 0 ;
	if ( donate_count >= 0 && donate_count <= 30000 )random_item = 0 ;
	else if ( donate_count >= 30001 && donate_count <= 42000 )random_item = 1 ;
	else if ( donate_count >= 42001 && donate_count <= 46000 )random_item = 2 ;
	else if ( donate_count >= 46001 && donate_count <= 50000 )random_item = 3 ;
		
	_retry_player_casket:
	if ( random_item == 0 )
	{
		if ( _id == 0 )
		{
			for ( new i = 0 ; i < MAX_CASKET_BOX_0 ; i ++ )
			{
				if ( casket_box_0 [ i ] [ c_rare ] != BP_ITEM_COMMON ) continue ;
			
				if ( random ( 5 ) == 1 )
				{
					_prise_id = casket_box_0 [ i ] [ c_model ] ;
				}
			}
		}
		else if ( _id == 1 )
		{
			for ( new i = 0 ; i < MAX_CASKET_BOX_1 ; i ++ )
			{
				if ( casket_box_1 [ i ] [ c_rare ] != BP_ITEM_COMMON ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = casket_box_1 [ i ] [ c_model ] ;
				}
			}
		}
		else if ( _id == 2 )
		{
			for ( new i = 0 ; i < MAX_CASKET_BOX_2 ; i ++ )
			{
				if ( casket_box_2 [ i ] [ c_rare ] != BP_ITEM_COMMON ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = casket_box_2 [ i ] [ c_model ] ;
				}
			}
		}
			
		if ( _count >= 10 )
		{
			_prise_id = casket_box_other [ 0 ] [ c_model ] ;
		}
				
		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_player_casket;
		}
	}
	else if ( random_item == 1 )
	{
		if ( _id == 0 )
		{
			for ( new i = 0 ; i < MAX_CASKET_BOX_0 ; i ++ )
			{
				if ( casket_box_0 [ i ] [ c_rare ] != BP_ITEM_RARE ) continue ;
			
				if ( random ( 4 ) == 1 )
				{
					_prise_id = casket_box_0 [ i ] [ c_model ] ;
				}
			}
		}
		else if ( _id == 1 )
		{
			for ( new i = 0 ; i < MAX_CASKET_BOX_1 ; i ++ )
			{
				if ( casket_box_1 [ i ] [ c_rare ] != BP_ITEM_RARE ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = casket_box_1 [ i ] [ c_model ] ;
				}
			}
		}
		else if ( _id == 2 )
		{
			for ( new i = 0 ; i < MAX_CASKET_BOX_2 ; i ++ )
			{
				if ( casket_box_2 [ i ] [ c_rare ] != BP_ITEM_RARE ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = casket_box_2 [ i ] [ c_model ] ;
				}
			}
		}
			
		if ( _count >= 10 )
		{
			_prise_id = casket_box_other [ 0 ] [ c_model ] ;
		}

		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_player_casket;
		}
	}
	else if ( random_item == 2 )
	{
		if ( _id == 0 )
		{
			for ( new i = 0 ; i < MAX_CASKET_BOX_0 ; i ++ )
			{
				if ( casket_box_0 [ i ] [ c_rare ] != BP_ITEM_EPIC ) continue ;
			
				if ( random ( 3 ) == 1 )
				{
					_prise_id = casket_box_0 [ i ] [ c_model ] ;
				}
			}
		}
		else if ( _id == 1 )
		{
			for ( new i = 0 ; i < MAX_CASKET_BOX_1 ; i ++ )
			{
				if ( casket_box_1 [ i ] [ c_rare ] != BP_ITEM_EPIC ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = casket_box_1 [ i ] [ c_model ] ;
				}
			}
		}
		else if ( _id == 2 )
		{
			for ( new i = 0 ; i < MAX_CASKET_BOX_2 ; i ++ )
			{
				if ( casket_box_2 [ i ] [ c_rare ] != BP_ITEM_EPIC ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = casket_box_2 [ i ] [ c_model ] ;
				}
			}
		}
			
		if ( _count >= 10 )
		{
			_prise_id = casket_box_other [ 0 ] [ c_model ] ;
		}

		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_player_casket;
		}
	}
	else if ( random_item == 3 )
	{
		if ( _id == 0 )
		{
			for ( new i = 0 ; i < MAX_CASKET_BOX_0 ; i ++ )
			{
				if ( casket_box_0 [ i ] [ c_rare ] != BP_ITEM_LEGENDARY ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = casket_box_0 [ i ] [ c_model ] ;
				}
			}
		}
		else if ( _id == 1 )
		{
			for ( new i = 0 ; i < MAX_CASKET_BOX_1 ; i ++ )
			{
				if ( casket_box_1 [ i ] [ c_rare ] != BP_ITEM_LEGENDARY ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = casket_box_1 [ i ] [ c_model ] ;
				}
			}
		}
		else if ( _id == 2 )
		{
			for ( new i = 0 ; i < MAX_CASKET_BOX_2 ; i ++ )
			{
				if ( casket_box_2 [ i ] [ c_rare ] != BP_ITEM_LEGENDARY ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = casket_box_2 [ i ] [ c_model ] ;
				}
			}
		}
			
		if ( _count >= 10 )
		{
			_prise_id = casket_box_other [ 0 ] [ c_model ] ;
		}

		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_player_casket;
		}
	}

	give_player_item_prise ( playerid, _prise_id, 1 ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 144, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _prise_id ) ) ;
	SendClientMessage ( playerid, col_yellow, global_string ) ;

	new scm_string [ 110 ] ;
	format ( scm_string, sizeof scm_string, "%s (CASKET #%d) %s", p_info [ playerid ] [ name ], _id, item_name ( _prise_id ) ) ;
	WriteLog ( playerid, TYPE_LOG_PLAYER_CASE, scm_string ) ;
		
	printf ( "[getCasketItem] end. (%d ms)", GetTickCount ( ) - time ) ;
	return 1 ;
}