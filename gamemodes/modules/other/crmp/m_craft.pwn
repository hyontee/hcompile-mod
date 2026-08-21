/*

	18631 - знак вопроса для пустого крафта

*/

#define MAX_CRAFT 12
enum _craft
{
	c_name [ 32 ],
	c_item,
	c_give_item,
	c_composition [ 5 ],
	c_quantity [ 5 ],
	c_price,
	c_chance,
	c_color,
	c_type
} ;

new player_craft_item [ MAX_PLAYERS ] ;
new player_craft_button [ MAX_PLAYERS ] ;
new player_count_craft [ MAX_PLAYERS char ] ;
new player_craft_time [ MAX_PLAYERS char ] ;
new bool: used_craft [ MAX_PLAYERS ] ;

new craft_info [ MAX_CRAFT ] [ _craft ] =
{
	{ "Ежедневный кейс", 19624, 2003, { 905, 19941, 1463, 2684, 18631 }, { 3, 10, 25, 3, 0 }, 500_000, 5, -1, RENDER_TYPE_OBJECT },
	{ "Семейный кейс", 19624, 2048, { 905, 19941, 1463, 2684, 18631 }, { 40, 40, 40, 40, 0 }, 50_000_000, 5, 8388863, RENDER_TYPE_OBJECT },
	{ "Горный велосипед", 481, 1083, { 905, 19941, 1080, 2684, 18631 }, { 100, 100, 5, 100, 0 }, 50_000_000, 5, 41215, RENDER_TYPE_VEHICLE },
	{ "Jeep GrandCherokee V8", 566, 566, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 10_000_000, 15, -2147483393, RENDER_TYPE_VEHICLE },
	{ "Audi Q7", 567, 567, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 10_000_000, 15, -2147483393, RENDER_TYPE_VEHICLE },
	{ "Одежда #286", 286, 286, { 1463, 2684, 18631, 18631, 18631 }, { 5000, 5000, 0, 0, 0 }, 10_000_000, 20, 8388863, RENDER_TYPE_SKINS },
	{ "Одежда #287", 287, 287, { 1463, 2684, 18631, 18631, 18631 }, { 5000, 5000, 0, 0, 0 }, 10_000_000, 20, 8388863, RENDER_TYPE_SKINS },
	{ "Одежда #291", 291, 291, { 1463, 2684, 18631, 18631, 18631 }, { 5000, 5000, 0, 0, 0 }, 25_000_000, 20, 8388863, RENDER_TYPE_SKINS },

	{ "Улучшенный верстак", 19624, 19624, { 905, 19941, 1463, 2684, 18631 }, { 40, 40, 40, 40, 0 }, 10_000_000, 40, 41215, RENDER_TYPE_OBJECT },

	{ "AWP Anime", 3502, 3502, { 1463, 2684, 18631, 18631, 18631 }, { 5000, 5000, 0, 0, 0 }, 25_000_000, 20, 8388863, NON_RENDER_TYPE },
	{ "White AK-74", 3510, 3510, { 1463, 2684, 18631, 18631, 18631 }, { 5000, 5000, 0, 0, 0 }, 25_000_000, 20, 8388863, NON_RENDER_TYPE },
	{ "Death Mak", 3514, 3514, { 1463, 2684, 18631, 18631, 18631 }, { 5000, 5000, 0, 0, 0 }, 25_000_000, 20, 8388863, NON_RENDER_TYPE }
} ;

callback: craft_timer ( playerid, _count )
{
	if ( player_craft_time { playerid } == 1 )
	{
		if ( player_count_craft { playerid } > 1 )
		{
			player_count_craft { playerid } -- ;
			player_craft_time { playerid } = 20 ;
			
			job_timer [ playerid ] = SetTimerEx ( "craft_timer", 1000, false, "ii", playerid, _count ) ;
		}
		else
		{
			KillTimer ( job_timer [ playerid ] ) ;
			job_timer [ playerid ] = -1 ;
			
			toggle_controlable ( playerid, true ) ;
			craft_ptd_status ( playerid, true ) ;
		}
		
		new _craft_id = get_player_use_listitem ( playerid ), _price = craft_info [ _craft_id ] [ c_price ], _chance_bonus = 0, _h_id = -1 ;
		give_money ( playerid, -_price ) ;
        insert_money_log ( playerid, INVALID_PLAYER_ID, -_price, "крафт" ) ;
		
		if ( GetPVarInt ( playerid, "house_id" ) > 0 ) 
		{
			_h_id = GetPVarInt ( playerid, "house_id" ) ;
			_chance_bonus = h_info [ _h_id - 1 ] [ h_upgrade_craft ] ;
		}
		else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 ) 
		{
			_h_id = GetPVarInt ( playerid, "cellar_id" ) ;
			_chance_bonus = cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] ;
		}
		
		if ( p_info [ playerid ] [ crime_plus ] ) _chance_bonus += 10 ;
		
		if ( player_device { playerid } == 2 )
		{
			new scm_string [ 87 + 32 ], _item = craft_info [ _craft_id ] [ c_give_item ] ;
			if ( random ( 100 ) <= craft_info [ _craft_id ] [ c_chance ] + _chance_bonus )
			{
				updateCraftProgress ( playerid, 0, 0, false ) ;

				format ( scm_string, sizeof scm_string, "%s скрафтил %s.", p_info [ playerid ] [ name ], craft_info [ _craft_id ] [ c_name ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_CRAFT, scm_string ) ;
				
				if ( _item == 19624 )
				{
					if ( GetPVarInt ( playerid, "house_id" ) > 0 )
					{
						h_info [ _h_id - 1 ] [ h_upgrade_craft ] = 10 ;
					
						new sql_string [ 74 + 9 ] ;
						format ( sql_string, sizeof sql_string, "UPDATE `houses` SET `h_upgrade_craft` = '10' WHERE `h_id` = '%d' LIMIT 1", h_info [ _h_id - 1 ] [ h_id ] ) ;
						mysql_tquery ( sql_connection, sql_string ) ;
					}
					else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 )
					{
						cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] = 10 ;
					
						new sql_string [ 78 + 9 ] ;
						format ( sql_string, sizeof sql_string, "UPDATE `cellars` SET `cl_upgrade_craft` = '10' WHERE `cl_id` = '%d' LIMIT 1", cellar_info [ _h_id - 1 ] [ cl_id ] ) ;
						mysql_tquery ( sql_connection, sql_string ) ;
					}
				}
				else
				{
					if ( _item == 255 ) _item = craft_info [ _craft_id ] [ c_item ] ;
					give_inventory ( playerid, _item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, -1 ) ;
					
					scm_string [ 0 ] = EOS ;
					format ( scm_string, sizeof scm_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _item ) ) ;
					SendClientMessage ( playerid, col_yellow, scm_string ) ;

					send_check_cinfo ( playerid, scm_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
				}
			}
			else
			{
				updateCraftProgress ( playerid, 0, 0, false ) ;
				send_check_cinfo ( playerid, "Неудачная попытка крафта!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				
				format ( scm_string, sizeof scm_string, "%s неудачная попытка крафта %s.", p_info [ playerid ] [ name ], craft_info [ _craft_id ] [ c_name ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_CRAFT, scm_string ) ;
			}
		}
		else
		{
			new scm_string [ 87 + 32 ], _item = craft_info [ _craft_id ] [ c_give_item ] ;
			if ( random ( 100 ) <= craft_info [ _craft_id ] [ c_chance ] + _chance_bonus )
			{
				format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы скрафтили %s. Поздравляем!", craft_info [ _craft_id ] [ c_name ] ) ;
				SendClientMessage ( playerid, col_white, scm_string ) ;
				
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Успех", scm_string, "Закрыть", "" ) ;
			
				format ( scm_string, sizeof scm_string, "%s скрафтил %s.", p_info [ playerid ] [ name ], craft_info [ _craft_id ] [ c_name ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_CRAFT, scm_string ) ;
				
				if ( craft_info [ _craft_id ] [ c_give_item ] == 19624 )
				{
					if ( GetPVarInt ( playerid, "house_id" ) > 0 )
					{
						h_info [ _h_id - 1 ] [ h_upgrade_craft ] = 10 ;
					
						new sql_string [ 74 + 9 ] ;
						format ( sql_string, sizeof sql_string, "UPDATE `houses` SET `h_upgrade_craft` = '10' WHERE `h_id` = '%d' LIMIT 1", h_info [ _h_id - 1 ] [ h_id ] ) ;
						mysql_tquery ( sql_connection, sql_string ) ;
					}
					else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 )
					{
						cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] = 10 ;
					
						new sql_string [ 78 + 9 ] ;
						format ( sql_string, sizeof sql_string, "UPDATE `cellars` SET `cl_upgrade_craft` = '10' WHERE `cl_id` = '%d' LIMIT 1", cellar_info [ _h_id - 1 ] [ cl_id ] ) ;
						mysql_tquery ( sql_connection, sql_string ) ;
					}
				}
				else if ( craft_info [ _craft_id ] [ c_give_item ] == 255 )
				{
					give_inventory ( playerid, craft_info [ _craft_id ] [ c_item ], 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				}
				else
				{
					if ( _item == 255 ) _item = craft_info [ _craft_id ] [ c_item ] ;
					give_inventory ( playerid, _item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, -1 ) ;
						
					scm_string [ 0 ] = EOS ;
					format ( scm_string, sizeof scm_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _item ) ) ;
					SendClientMessage ( playerid, col_yellow, scm_string ) ;
				}
			}
			else
			{
				ClearAnimations ( playerid ) ;
				
				format ( scm_string, sizeof scm_string, "{"#cRInfo"}* {"#cGRInfo"}У Вас не получилось скрафтить %s. Можете попробовать снова!", craft_info [ _craft_id ] [ c_name ] ) ;
				SendClientMessage ( playerid, col_gray, scm_string ) ;
				
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Неудачная попытка", scm_string, "Закрыть", "" ) ;

				format ( scm_string, sizeof scm_string, "%s неудачная попытка крафта %s.", p_info [ playerid ] [ name ], craft_info [ _craft_id ] [ c_name ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_CRAFT, scm_string ) ;
			}
		}
	}
	else
	{
		player_craft_time { playerid } -- ;

		updateCraftProgress ( playerid, ( 20 - player_craft_time { playerid } ), 20, true ) ;
		job_timer [ playerid ] = SetTimerEx ( "craft_timer", 1000, false, "ii", playerid, _count ) ;
	}
	return 1 ;
}

stock craft_OnPlayerDisconnect ( playerid )
{
	if ( used_craft [ playerid ] == true )
	{
		craft_ptd_status ( playerid, false ) ;
		if ( job_timer [ playerid ] != -1 )
		{
			KillTimer ( job_timer [ playerid ] ) ;
			job_timer [ playerid ] = -1 ;
		}
	}
	return 1 ;
}

stock craft_ptd_status ( playerid, bool: status )
{
	if ( status )
	{
		toggle_controlable ( playerid, false ) ;
		
		used_craft [ playerid ] = true ;
		page_count [ playerid ] = 1 ;
		player_count_craft { playerid } = 1 ;
		set_player_use_listitem ( playerid, 0 ) ;
		
		showWindowCraft ( playerid ) ;
	}
	else
	{
		toggle_controlable ( playerid, true ) ;
	
		used_craft [ playerid ] = false ;
		page_count [ playerid ] = 0 ;
	}
	return 1 ;
}

stock showWindowCraft ( playerid )
{
	player_craft_button { playerid } = 0 ;
	player_count_craft { playerid } = 1 ;
	updateCraftCount ( playerid ) ;

	craftItemsType ( playerid, RENDER_TYPE_OBJECT ) ;

	static const strHeader [ 4 ] [ 12 ] =
	{
		"Предметы",
		"Транспорт",
		"Одежда",
		"Остальное"
	} ;

	new Node: node = JSON_Array ( ), bool: firstItem = true ;
	for ( new i = 0, Node: strNode ; i < sizeof strHeader ; i ++ )
	{
		strNode = JSON_Array (
			JSON_Object (
				"name",			JSON_String ( strHeader [ i ] ),
				"isActive",		JSON_Bool ( firstItem )
			)
		) ;

		node = JSON_Append ( node, strNode ) ;
		firstItem = false ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_CRAFT_SCREEN, 1, global_string ) ;

	new _chance_bonus = 0, _h_id = -1 ;
	if ( GetPVarInt ( playerid, "house_id" ) > 0 ) 
	{
		_h_id = GetPVarInt ( playerid, "house_id" ) ;
		_chance_bonus = h_info [ _h_id - 1 ] [ h_upgrade_craft ] ;
	}
	else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 ) 
	{
		_h_id = GetPVarInt ( playerid, "cellar_id" ) ;
		_chance_bonus = cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] ;
	}
			
	if ( p_info [ playerid ] [ crime_plus ] ) _chance_bonus += 10 ;
			
	new _str [ 48 ] ;
	format ( _str, sizeof _str, "верстак (+%d%)", _chance_bonus ) ;
	onServerSendData ( playerid, UI_CRAFT_SCREEN, 5, _str ) ;
}

stock craftItemsType ( playerid, craftType )
{
	new Node: node = JSON_Array ( ), bool: firstItem = true, itemsLoaded = 0, modelId, strRare [ 12 ] ;
	for ( new i = 0, Node: craftNode ; i < MAX_CRAFT ; i ++ )
	{
		if ( craft_info [ i ] [ c_type ] != craftType ) continue ;

		modelId = craft_info [ i ] [ c_item ] ;
		format ( strRare, sizeof strRare, "%d", craft_info [ i ] [ c_color ] ) ;

		craftNode = JSON_Array (
			JSON_Object (
				"name",			JSON_String ( craft_info [ i ] [ c_name ] ),
				"rare",			JSON_String ( strRare ),
				"id",			JSON_Int ( i ),
				"type",			JSON_Int ( item_render_type ( modelId ) ),
				"model",		JSON_Int ( item_object_id ( modelId ) ),
				"color1",  		JSON_Int ( item_color ( modelId, 1 ) ),
				"color2",      	JSON_Int ( 1 ),
				"rotX",			JSON_Float ( 20.0 ),
				"rotY",			JSON_Float ( 180.0 ),
				"rotZ",			JSON_Float ( 45.0 ),
				"zoom",			JSON_Float ( 0.78 ),
				"isActive",		JSON_Bool ( firstItem )
			)
		) ;

		node = JSON_Append ( node, craftNode ) ;
		if ( firstItem )
		{
			player_craft_item [ playerid ] = i ;
			craftItemRes ( playerid, i ) ;
			craftInfo ( playerid, i ) ;
		}
		firstItem = false ;

		if ( ++ itemsLoaded == 5 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_CRAFT_SCREEN, 0, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
	}

	if ( itemsLoaded )
	{
		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_CRAFT_SCREEN, 0, global_string ) ;
	}
}

stock packetCraft ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 ) // выбор предмета из списка
	{
		if ( job_timer [ playerid ] != -1 )
		{
			send_check_cinfo ( playerid, "Вы уже изготавливаете предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		new idx = strval ( data ) ;
		player_count_craft { playerid } = 1 ;
		updateCraftCount ( playerid ) ;

		player_craft_button { playerid } = 0 ;
		player_craft_item [ playerid ] = idx ;
		craftItemRes ( playerid, idx ) ;
		craftInfo ( playerid, idx ) ;
	}
	else if ( actionId == 1 ) // выбор раздела
	{
		if ( job_timer [ playerid ] != -1 )
		{
			send_check_cinfo ( playerid, "Вы уже изготавливаете предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		new idx = strval ( data ) ;
		if ( idx == 0 ) craftItemsType ( playerid, RENDER_TYPE_OBJECT ) ;
		else if ( idx == 1 ) craftItemsType ( playerid, RENDER_TYPE_VEHICLE ) ;
		else if ( idx == 2 ) craftItemsType ( playerid, RENDER_TYPE_SKINS ) ;
		else if ( idx == 3 ) craftItemsType ( playerid, NON_RENDER_TYPE ) ;
	}
	else if ( actionId == 2 ) // выбор предмета требуемого для крафта
	{
		if ( job_timer [ playerid ] != -1 )
		{
			send_check_cinfo ( playerid, "Вы уже изготавливаете предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		new modelId = strval ( data ) ;
		show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", item_description ( modelId ), "Принять", "" ) ;
	}
	else if ( actionId == 3 ) // -
	{
		if ( job_timer [ playerid ] != -1 )
		{
			send_check_cinfo ( playerid, "Вы уже изготавливаете предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		player_craft_button { playerid } = 0 ;
		if ( player_count_craft { playerid } > 1 ) player_count_craft { playerid } -= 1 ;
		updateCraftCount ( playerid ) ;
		craftItemRes ( playerid, player_craft_item [ playerid ] ) ;
	}
	else if ( actionId == 4 ) // +
	{
		if ( job_timer [ playerid ] != -1 )
		{
			send_check_cinfo ( playerid, "Вы уже изготавливаете предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		player_craft_button { playerid } = 0 ;
		player_count_craft { playerid } += 1 ;
		updateCraftCount ( playerid ) ;
		craftItemRes ( playerid, player_craft_item [ playerid ] ) ;
	}
	else if ( actionId == 5 ) // начать крафт
	{
		if ( job_timer [ playerid ] != -1 )
		{
			send_check_cinfo ( playerid, "Вы уже изготавливаете предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		new itemCraft = player_craft_item [ playerid ] ;
		if ( p_info [ playerid ] [ money ] < craft_info [ itemCraft ] [ c_price ] * player_count_craft { playerid } )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно денежных средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
					
		for ( new i = 0 ; i < 5 ; i ++ )
		{
			if ( craft_info [ itemCraft ] [ c_composition ] [ i ] == 18631 ) continue ;

			new itemCount = GetInventoryFindItem ( playerid, SUB_INVENTORY, craft_info [ itemCraft ] [ c_composition ] [ i ] ) ;
			if ( itemCount < craft_info [ itemCraft ] [ c_quantity ] [ i ] * player_count_craft { playerid } )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно ингредиентов!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
		}
				
		for ( new i = 0 ; i < 5 ; i ++ )
		{
			if ( craft_info [ itemCraft ] [ c_composition ] [ i ] == 18631 ) continue ;
				
			clear_inventory ( playerid, craft_info [ itemCraft ] [ c_composition ] [ i ], craft_info [ itemCraft ] [ c_quantity ] [ i ] * player_count_craft { playerid } ) ;
		}
			
		send_check_cinfo ( playerid, "Вы начали крафтить. Ожидайте!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		job_timer [ playerid ] = SetTimerEx ( "craft_timer", 1000, false, "ii", playerid, player_count_craft { playerid } ) ;
		player_craft_time { playerid } = 20 ;

		used_craft [ playerid ] = true ;
		ApplyAnimation ( playerid, "CAR_CHAT", "CAR_Sc4_BL", 4.0, 1, 1, 1, 1, 5800, 0 ) ;
	}
	return true ;
}

stock packetCraftDestroy ( playerid )
{
	craft_ptd_status ( playerid, false ) ;
	return true ;
}

stock updateCraftCount ( playerid )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 12, "%d", player_count_craft { playerid } ) ;
	onServerSendData ( playerid, UI_CRAFT_SCREEN, 3, global_string ) ;
}

stock craftButtonState ( playerid, stateId )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 12, "%d", stateId ) ;
	onServerSendData ( playerid, UI_CRAFT_SCREEN, 6, global_string ) ;
}

stock craftItemRes ( playerid, itemId )
{
	new Node: node = JSON_Array ( ), modelId, itemCount, itemQuantity, strName [ 32 ], strRare [ 12 ] ;
	for ( new i = 0, Node: resNode ; i < 5 ; i ++ )
	{
		modelId = craft_info [ itemId ] [ c_composition ] [ i ] ;
		if ( modelId == 18631 ) continue ;

		itemCount = GetInventoryFindItem ( playerid, SUB_INVENTORY, modelId ) ;
		itemQuantity = craft_info [ itemId ] [ c_quantity ] [ i ] * player_count_craft { playerid } ;
		format ( strName, sizeof strName, "%d/%d", itemCount, itemQuantity ) ;
			
		if ( itemCount >= itemQuantity ) format ( strRare, sizeof strRare, "#ff33AA33" ) ;
		else
		{
			player_craft_button { playerid } = 1 ;
			format ( strRare, sizeof strRare, "#ffAA3333" ) ;
		}

		resNode = JSON_Array (
			JSON_Object (
				"name",			JSON_String ( strName ),
				"rare",			JSON_String ( strRare ),
				"id",			JSON_Int ( i ),
				"type",			JSON_Int ( item_render_type ( modelId ) ),
				"model",		JSON_Int ( item_object_id ( modelId ) ),
				"color1",  		JSON_Int ( item_color ( modelId, 1 ) ),
				"color2",      	JSON_Int ( 1 ),
				"rotX",			JSON_Float ( 20.0 ),
				"rotY",			JSON_Float ( 180.0 ),
				"rotZ",			JSON_Float ( 45.0 ),
				"zoom",			JSON_Float ( 0.78 ),
				"isActive",		JSON_Bool ( false )
			)
		) ;
		node = JSON_Append ( node, resNode ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_CRAFT_SCREEN, 2, global_string ) ;

	craftButtonState ( playerid, player_craft_button { playerid } ) ;
}

stock craftInfo ( playerid, itemId )
{
	new _chance_bonus = 0, _str [ 12 ], _h_id ;
	if ( GetPVarInt ( playerid, "house_id" ) > 0 ) 
	{
		_h_id = GetPVarInt ( playerid, "house_id" ) ;
		_chance_bonus = h_info [ _h_id - 1 ] [ h_upgrade_craft ] ;
	}
	else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 ) 
	{
		_h_id = GetPVarInt ( playerid, "cellar_id" ) ;
		_chance_bonus = cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] ;
	}
	if ( p_info [ playerid ] [ crime_plus ] ) _chance_bonus += 10 ;
		
	format ( _str, sizeof _str, "%d ", craft_info [ itemId ] [ c_chance ] + _chance_bonus ) ;
	updateCraftInfo ( playerid, 0, "ШАНС УСПЕХА", _str, true ) ;
	format ( _str, sizeof _str, "%s ", GetPlayerCashValueToSmile ( craft_info [ itemId ] [ c_price ] * player_count_craft { playerid } ) ) ;
	updateCraftInfo ( playerid, 1, "СТОИМОСТЬ", _str, true ) ;
	updateCraftInfo ( playerid, 2, "", "", false ) ;
}

stock updateCraftInfo ( playerid, idx, strName [ ], strInfo [ ], bool: visible )
{
	new Node: node = JSON_Object (
		"id",		JSON_Int ( idx ),
		"name",		JSON_String ( strName ),
		"info",		JSON_String ( strInfo ),
		"visible",	JSON_Bool ( visible )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_CRAFT_SCREEN, 4, global_string ) ;
}

stock updateCraftProgress ( playerid, progress, max, bool: visible )
{
	new Node: node = JSON_Object (
		"max",		JSON_Int ( max ),
		"progress",	JSON_Int ( progress ),
		"visible",	JSON_Bool ( visible )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_CRAFT_SCREEN, 7, global_string ) ;
}