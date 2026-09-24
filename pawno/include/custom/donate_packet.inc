#define PACKET_CUSTOMRPC    			251
#define RPC_DONATE						0x90

/*

	РУССКИЕ СИМВОЛЫ В ИНКЛУДАХ НЕ ЧИТАЕТ, БЛЕАТЬ

*/

stock closeDonate ( playerid )
{
	#if defined debug_packet
		printf ( "[closeDonate] playerid: %d", playerid ) ;
	#endif
	
	onServerDestroy ( playerid, 1 ) ;
}

stock donateAddCategory ( playerid )
{
	#if defined debug_packet
		printf ( "[donateAddCategory] playerid: %d", playerid ) ;
	#endif
	
	new Node: json = JSON_Object("donateCategory", JSON_Array()) ;
	for ( new i = 0 ; i < MAX_DONATE_CATEGORY ; i ++ )
	{
        JSON_ArrayAppend
        (
            json, "donateCategory",
            JSON_Object
            (
                "icon", 				JSON_Int ( donate_category [ i ] [ dc_icon ] ),
                "name", 				JSON_String ( donate_category [ i ] [ dc_name ] )
            )
        );
	}

    new Node: json_correct;
    JSON_GetObject(json, "donateCategory", json_correct); 

	global_string [ 0 ] = EOS ;
    JSON_Stringify(json_correct, global_string, sizeof global_string);
	onServerSendData ( playerid, 1, 1, global_string ) ;
}

stock donateAddItem ( playerid, _type )
{
	#if defined debug_packet
		printf ( "[donateAddItem] playerid: %d", playerid ) ;
	#endif
	
	new json_string [ 512 ] ;
	if ( _type == 0 )
	{
		new _id, _model, line_string [ 32 ], _typeRender ;
		for ( new i = 0 ; i < MAX_DISCOUNT ; i ++ )
		{
			if ( donate_discount_id [ i ] == -1 || donate_discount_date [ i ] < gettime ( ) ) continue ;
			
			json_string [ 0 ] = EOS ;
			format ( json_string, sizeof json_string, "{ \"position\": %d,", i ) ;
			
			_id = find_donate ( donate_discount_hierarchy [ i ], donate_discount_id [ i ] ) ;
			_model = donate_list [ _id ] [ ModelId ] ;
			_typeRender = donate_list [ _id ] [ HierarchyID ] ;
			format ( json_string, sizeof json_string, "%s\"type\": %d,", json_string, donate_list [ _id ] [ Type ] ) ;
			format ( json_string, sizeof json_string, "%s\"model\": %d,", json_string, _model ) ;
				
			format ( json_string, sizeof json_string, "%s\"color1\": %d,", json_string, 1 ) ;
			format ( json_string, sizeof json_string, "%s\"color2\": %d,", json_string, 2 ) ;
				
			format ( json_string, sizeof json_string, "%s\"rotX\": %f,", json_string, 20.0 ) ;
			format ( json_string, sizeof json_string, "%s\"rotY\": %f,", json_string, 180.0 ) ;
			format ( json_string, sizeof json_string, "%s\"rotZ\": %f,", json_string, 45.0 ) ;
			format ( json_string, sizeof json_string, "%s\"zoom\": %f,", json_string, 0.78 ) ;
			
			if ( _typeRender == 1 ) format ( json_string, sizeof json_string, "%s\"name\": \"%s\",", json_string, item_name ( _model + skin_cross ) ) ;
			else if ( _typeRender == 2 || _typeRender == 3 || _typeRender == 4 || _typeRender == 5 ) format ( json_string, sizeof json_string, "%s\"name\": \"%s\",", json_string, item_name ( _model ) ) ;
			else format ( json_string, sizeof json_string, "%s\"name\": \"%s\",", json_string, donate_list [ _id ] [ d_Name ] ) ;
			
			new s_year, s_month, s_day, s_hour, s_minute, s_second ;
			timestamp_to_date ( donate_discount_date [ i ] + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
			format ( line_string, sizeof line_string, "%d%% | %02d.%02d.%d", donate_discount_percent [ i ], s_day, s_month, s_year ) ;
			format ( json_string, sizeof json_string, "%s\"discount\": \"%s\",", json_string, line_string ) ;
			
			format ( json_string, sizeof json_string, "%s\"special\": true,", json_string ) ;
			
			format ( line_string, sizeof line_string, "%s", GetPlayerCashValueToSmile ( donate_list [ _id ] [ Cost ] - floatround ( ( donate_list [ _id ] [ Cost ] * donate_discount_percent [ i ] ) / 100 ) ) ) ;
			format ( json_string, sizeof json_string, "%s\"price\": \"%s\" }", json_string, line_string ) ;
		
			onServerSendData ( playerid, 1, 2, json_string ) ;
		}
	}
	else
	{
		new _count = 0, _model, line_string [ 24 ], _typeRender ;
		for ( new i = 0 ; i < sizeof donate_list ; i ++ )
		{
			if ( donate_list [ i ] [ HierarchyID ] != _type ) continue ;
			if ( _count >= donate_list_count [ _type - 1 ] ) break ;
			
			json_string [ 0 ] = EOS ;
			format ( json_string, sizeof json_string, "{ \"position\": %d,", i ) ;
			
			_model = donate_list [ i ] [ ModelId ] ;
			format ( json_string, sizeof json_string, "%s\"type\": %d,", json_string, donate_list [ i ] [ Type ] ) ;
			format ( json_string, sizeof json_string, "%s\"model\": %d,", json_string, _model ) ;
				
			format ( json_string, sizeof json_string, "%s\"color1\": %d,", json_string, 1 ) ;
			format ( json_string, sizeof json_string, "%s\"color2\": %d,", json_string, 2 ) ;
				
			format ( json_string, sizeof json_string, "%s\"rotX\": %f,", json_string, 20.0 ) ;
			format ( json_string, sizeof json_string, "%s\"rotY\": %f,", json_string, 180.0 ) ;
			format ( json_string, sizeof json_string, "%s\"rotZ\": %f,", json_string, 45.0 ) ;
			format ( json_string, sizeof json_string, "%s\"zoom\": %f,", json_string, 0.78 ) ;
			
			_typeRender = donate_list [ i ] [ HierarchyID ] ;
			if ( _typeRender == 1 ) format ( json_string, sizeof json_string, "%s\"name\": \"%s\",", json_string, item_name ( _model + skin_cross ) ) ;
			else if ( _typeRender == 2 || _typeRender == 3 || _typeRender == 4 || _typeRender == 5 ) format ( json_string, sizeof json_string, "%s\"name\": \"%s\",", json_string, item_name ( _model ) ) ;
			else format ( json_string, sizeof json_string, "%s\"name\": \"%s\",", json_string, donate_list [ i ] [ d_Name ] ) ;
			
			if ( _type == 8 && ( _model == 152 || _model == 153 || _model == 154 || _model == 155 ) )
			{
				new _discount = 0 ;
				if ( get_player_item_prise ( playerid, 184 ) > 0 ) _discount = 10 ;
				else if ( get_player_item_prise ( playerid, 185 ) > 0 ) _discount = 30 ;
				else if ( get_player_item_prise ( playerid, 186 ) > 0 ) _discount = 50 ;
				if ( _discount > 0 )
				{
					format ( line_string, sizeof line_string, "Скидка %d%", _discount ) ;
					format ( json_string, sizeof json_string, "%s\"discount\": \"%s\",", json_string, line_string ) ;
					format ( json_string, sizeof json_string, "%s\"special\": true,", json_string ) ;
					
					format ( line_string, sizeof line_string, "%s", GetPlayerCashValueToSmile ( donate_list [ i ] [ Cost ] - floatround ( ( donate_list [ i ] [ Cost ] * _discount ) / 100 ) ) ) ;
					format ( json_string, sizeof json_string, "%s\"price\": \"%s\" }", json_string, line_string ) ;
				}
				else
				{
					format ( json_string, sizeof json_string, "%s\"discount\": \"%s\",", json_string, "" ) ;
					format ( json_string, sizeof json_string, "%s\"special\": false,", json_string ) ;
					
					format ( line_string, sizeof line_string, "%s", GetPlayerCashValueToSmile ( donate_list [ i ] [ Cost ] ) ) ;
					format ( json_string, sizeof json_string, "%s\"price\": \"%s\" }", json_string, line_string ) ;
				}
			}
			else
			{
				format ( json_string, sizeof json_string, "%s\"discount\": \"%s\",", json_string, "" ) ;
				format ( json_string, sizeof json_string, "%s\"special\": false,", json_string ) ;
				
				format ( line_string, sizeof line_string, "%s", GetPlayerCashValueToSmile ( donate_list [ i ] [ Cost ] ) ) ;
				format ( json_string, sizeof json_string, "%s\"price\": \"%s\" }", json_string, line_string ) ;
			}
			
			_count ++ ;
		
			onServerSendData ( playerid, 1, 2, json_string ) ;
		}
	}
}

stock donateItemClear ( playerid )
{
	#if defined debug_packet
		printf ( "[donateItemClear] playerid: %d", playerid ) ;
	#endif

	onServerSendData ( playerid, 1, 3, "" ) ;
}

stock donateUpdateInfo ( playerid, _str [ ], _str2 [ ], _str3 [ ] )
{
	#if defined debug_packet
		printf ( "[donateUpdateInfo] playerid: %d", playerid ) ;
	#endif

	global_string [ 0 ] = EOS ;
	format ( global_string, 144, "{\"title\": \"%s\", \"balance2\": \"%s\", \"balance\": \"%s\"}", _str, _str2, _str3 ) ;
	onServerSendData ( playerid, 1, 4, global_string ) ;
}