/*

	18631 - знак вопроса для пустого

*/

new player_inventory [ MAX_PLAYERS char ] ;
new bool: safe_pin_status [ MAX_PLAYERS ] ;

static playerTradeName [ MAX_PLAYERS ] [ MAX_PLAYER_NAME ] ;

stock show_inventory_ptd ( playerid, bool: status )
{
	if ( status )
	{
		used_inventory [ playerid ] = true ;
		toggle_controlable ( playerid, false ) ;
		
		SetInventoryItem ( playerid ) ;
		SetInventoryAcs ( playerid ) ;
		setInventoryLayout ( playerid, 0 ) ;
		setCharacterInfo ( playerid ) ;
		set_inventory_button ( playerid, 1 ) ;
		player_inventory { playerid } = 1 ;

		if ( ! users_education [ playerid ] [ EDUCATION_INV_SLOT ] )
		{
			show_window_monologue (
				playerid,
				5,
				"Привет, друг! Ты открыл инвентарь. Для взаимодействия с предметами просто нажимай на них! \
				Давай потренируемся. Выбери какой-то предмет нажатием.",
				"Местный",
				"Понял"
			) ;
		}
	}
	else
	{
		safe_pin_status [ playerid ] =
		used_inventory [ playerid ] = false ;
		toggle_controlable ( playerid, true ) ;
	}
	return 1 ;
}

stock inventory_OnPlayerDisconnect ( playerid )
{
	if ( used_inventory [ playerid ] == true )
	{
		show_inventory_ptd ( playerid, false ) ;
	}
	return 1 ;
}

stock set_inventory_button ( playerid, _type )
{
	player_inventory { playerid } = _type ;

	new Node: node = JSON_Array ( ), Node: nodeCategory ;
	nodeCategory = JSON_Array (
		JSON_Object (
			"id", JSON_Int ( SUB_INVENTORY ),
			"name", JSON_String ( "ПЕРСОНАЖ" ),
			"isActive", JSON_Bool ( ( _type == SUB_INVENTORY ) ? true : false )
		)
	) ;
	node = JSON_Append ( node, nodeCategory ) ;

	nodeCategory = JSON_Array (
		JSON_Object (
			"id", JSON_Int ( SUB_INV_FISHING ),
			"name", JSON_String ( "РЫБАЛКА" ),
			"isActive", JSON_Bool ( ( _type == SUB_INV_FISHING ) ? true : false )
		)
	) ;
	node = JSON_Append ( node, nodeCategory ) ;

	/*nodeCategory = JSON_Array (
		JSON_Object (
			"id", JSON_Int ( SUB_INV_GUARDS ),
			"name", JSON_String ( "ОХРАННИКИ" ),
			"isActive", JSON_Bool ( ( _type == SUB_INV_GUARDS ) ? true : false )
		)
	) ;
	node = JSON_Append ( node, nodeCategory ) ;*/

	foreach(new _v_id: streamed_vehicles[playerid])
	{
		if ( ! IsValidVehicle ( _v_id ) ) continue ;
		if ( getVehicleSubtype ( _v_id ) != VEHICLE_STATE_CAR ) continue ;

		new Float: x, Float: y, Float: z ;
		GetVehicleShiftPos ( _v_id, 1, x, y, z, 4.0 ) ;
		if ( IsPlayerInRangeOfPoint ( playerid, 4, x, y, z ) )
		{
			new _v_type = veh_info [ _v_id - 1 ] [ v_type ] ;
			if ( _v_type == vehicle_type_player )
			{
				if ( veh_info [ _v_id - 1 ] [ v_trunk_open ] == false && veh_info [ _v_id - 1 ] [ v_owner ] != p_info [ playerid ] [ id ] ) break ;
			}
			else if ( _v_type == vehicle_type_server )
			{
				if ( veh_info [ _v_id - 1 ] [ v_trunk_open ] == false && veh_info [ _v_id - 1 ] [ v_owner ] != p_info [ playerid ] [ member ] ) break ;
			}
			else if ( _v_type == vehicle_type_family )
			{
				if ( veh_info [ _v_id - 1 ] [ v_trunk_open ] == false && veh_info [ _v_id - 1 ] [ v_owner ] != p_info [ playerid ] [ family ] ) break ;
			}
			else if ( _v_type == vehicle_type_rentcar )
			{
				if ( veh_info [ _v_id - 1 ] [ v_trunk_open ] == false && _v_id != player_rentcar [ playerid ] ) break ;
			}
			else if ( _v_type == vehicle_type_house )
			{
				if ( ! Iter_Count(player_houses[playerid]) )
				{
					if ( veh_info [ _v_id - 1 ] [ v_trunk_open ] == false && veh_info [ _v_id - 1 ] [ v_owner ] != p_info [ playerid ] [ rent_house ] ) break ;
				}
				else
				{
					new _count_h = 0 ;
					foreach(new h: player_houses[playerid])
					{
						if ( veh_info [ _v_id - 1 ] [ v_trunk_open ] == false && veh_info [ _v_id - 1 ] [ v_owner ] == h ) _count_h ++ ;
					}
					if ( _count_h == 0 ) break ;
				}
			}
			else break ;
				
			if ( veh_info [ _v_id - 1 ] [ v_trunk_load ] == false )
			{
				static const _str [ ] = "SELECT * FROM `users_vehicles_inventory` WHERE `v_id` = '%d' LIMIT %d" ;
				new sql_string [ sizeof _str + ( 2 * 9 ) ] ;
				format ( sql_string, sizeof ( sql_string ), _str, veh_info [ _v_id - 1 ] [ v_id ], getTrunkCapacity ( _v_id ) ) ;
				mysql_tquery ( sql_connection, sql_string, "callback_prise_vehicle_loading", "i", _v_id ) ;
			}
			idaofcar [ playerid ] = _v_id ;
			nodeCategory = JSON_Array (
				JSON_Object (
					"id", JSON_Int ( SUB_INV_VEHICLE ),
					"name", JSON_String ( "БАГАЖНИК" ),
					"isActive", JSON_Bool ( ( _type == SUB_INV_VEHICLE ) ? true : false )
				)
			) ;
			node = JSON_Append ( node, nodeCategory ) ;
			break ;
		}
	}

	if ( GetPVarInt ( playerid, "house_id" ) )
	{
		nodeCategory = JSON_Array (
			JSON_Object (
				"id", JSON_Int ( SUB_INV_HOUSE ),
				"name", JSON_String ( "ДОМАШНИЙ СЕЙФ" ),
				"isActive", JSON_Bool ( ( _type == SUB_INV_HOUSE ) ? true : false )
			)
		) ;
		node = JSON_Append ( node, nodeCategory ) ;
	}

	if ( p_info [ playerid ] [ family ] > 0 )
	{
		new _fam_id = p_info [ playerid ] [ family ] ;
		if ( ! family_info [ _fam_id - 1 ] [ fam_safe_load ] )
		{
			static const _str [ ] = "SELECT * FROM `familys_inventory` WHERE `fam_id` = '%d' LIMIT %d" ;
			new sql_string [ sizeof _str + ( 2 * 9 ) ] ;
			format ( sql_string, sizeof ( sql_string ), _str, _fam_id, MAX_FAMILY_WAREHOUSE ) ;
			mysql_tquery ( sql_connection, sql_string, "callback_prise_family_loading", "i", _fam_id ) ;
		}

		nodeCategory = JSON_Array (
			JSON_Object (
				"id", JSON_Int ( SUB_INV_FAMILY ),
				"name", JSON_String ( "СЕМЬЯ" ),
				"isActive", JSON_Bool ( ( _type == SUB_INV_FAMILY ) ? true : false )
			)
		) ;
		node = JSON_Append ( node, nodeCategory ) ;
	}

	if ( p_info [ playerid ] [ member ] > 0 )
	{
		nodeCategory = JSON_Array (
			JSON_Object (
				"id", JSON_Int ( SUB_INV_FRACTION ),
				"name", JSON_String ( "ОРГАНИЗАЦИЯ" ),
				"isActive", JSON_Bool ( ( _type == SUB_INV_FRACTION ) ? true : false )
			)
		) ;
		node = JSON_Append ( node, nodeCategory ) ;
	}
	
	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_INVENTORY, 9, global_string ) ;
	return 1 ;
}

stock show_packet_inventory ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 )
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new moveFromIndex, moveToIndex, moveFromInventoryType, moveToInventoryType, moveFromInventoryIndex, moveToInventoryIndex ;
		JSON_GetInt ( json, "moveFromIndex", moveFromIndex ) ;
		JSON_GetInt ( json, "moveToIndex", moveToIndex ) ;
		JSON_GetInt ( json, "moveFromInventoryType", moveFromInventoryType ) ;
		JSON_GetInt ( json, "moveToInventoryType", moveToInventoryType ) ;

		/* параметры для охранников, у остальных инвентарей -1 */
		JSON_GetInt ( json, "moveFromInventoryIndex", moveFromInventoryIndex ) ;
		JSON_GetInt ( json, "moveToInventoryIndex", moveToInventoryIndex ) ;

		if ( ! users_education [ playerid ] [ EDUCATION_INV_DRAGGED ] )
		{
			show_window_monologue (
				playerid,
				5,
				"Какой же ты красавчик! У тебя получается всё просто превосходно.",
				"Местный",
				"Понял"
			) ;

			save_user_education ( playerid, EDUCATION_INV_DRAGGED ) ;
		}

		if ( moveFromInventoryType == moveToInventoryType )
		{
			switch ( moveFromInventoryType )
			{
				case 0: // инвентарь
				{
					dragged_player_inventory ( playerid, moveFromIndex, moveToIndex ) ;
				}
				case 1: // аксессуары
				{

				}
				case 2: // склад
				{
					new _type = player_inventory { playerid } ;
					if ( _type == SUB_INV_VEHICLE ) dragged_vehicle_item ( playerid, idaofcar [ playerid ], moveFromIndex, moveToIndex ) ;
					else if ( _type == SUB_INV_HOUSE ) dragged_warehouse_item ( playerid, GetPVarInt ( playerid, "house_id" ), moveFromIndex, moveToIndex ) ;
					else if ( _type == SUB_INV_FAMILY ) dragged_family_item ( p_info [ playerid ] [ family ], moveFromIndex, moveToIndex ) ;
					else if ( _type == SUB_INV_FRACTION ) dragged_fraction_item ( p_info [ playerid ] [ member ], moveFromIndex, moveToIndex ) ;
				}
				case 3: // trader
				{

				}
				case 4: // receiver
				{

				}
			}
		}
		else
		{
			switch ( moveToInventoryType )
			{
				case 0: // инвентарь
				{
					new _type = player_inventory { playerid } ;
					if ( _type == SUB_INV_VEHICLE ) set_packet_vehicle_get ( playerid, false, moveFromIndex, moveToIndex ) ;
					else if ( _type == SUB_INV_HOUSE ) set_packet_warehouse_get ( playerid, false, moveFromIndex, moveToIndex ) ;
					else if ( _type == SUB_INV_FAMILY ) set_packet_family_get ( playerid, false, moveFromIndex, moveToIndex ) ;
					else if ( _type == SUB_INV_FRACTION ) set_packet_fraction_get ( playerid, false, moveFromIndex, moveToIndex ) ;
					else if ( _type == SUB_INV_MARKET_PLACE ) dragged_market_place ( playerid, moveFromIndex, moveToIndex, true ) ;
					else
					{
						new _count = 1, _return = -1 ;
						if ( GetUserAccessories ( playerid, ACS_MODEL, moveFromIndex ) == ITEM_SIM_CARD )
						{
							new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
							inventoryStruct [ _:INV_ITEM ] = ITEM_SIM_CARD ;
							inventoryStruct [ _:INV_ITEM_COUNT ] = 1 ;
							inventoryStruct [ _:INV_ITEM_TYPE ] = INVENTORY_TYPE_SIMCARD ;
							inventoryStruct [ _:INV_ITEM_PLATE_TYPE ] = NUMBERPLATE_TYPE_NONE ;
							inventoryStruct [ _:INV_ITEM_GIVE_DATE ] = GetUserAccessories ( playerid, ACS_COUNT, moveFromIndex ) ;
							inventoryStruct [ _:INV_ITEM_ID ] = GetUserAccessories ( playerid, ACS_ITEM_ID, moveFromIndex ) ;
							inventoryStruct [ _:INV_ITEM_DATE ] = GetElapsedTime ( GetUserAccessories ( playerid, ACS_DATE, moveFromIndex ), gettime ( ), CONVERT_TIME_TO_DAYS ) ;
							_return = giveInventorySlot ( playerid, inventoryStruct, moveToIndex ) ;
						}
						else
						{
							new USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ] ;
							moveInventory [ _:INV_ITEM ] = GetUserAccessories ( playerid, ACS_MODEL, moveFromIndex ) ;
							moveInventory [ _:INV_ITEM_COUNT ] = _count ;
							moveInventory [ _:INV_ITEM_TYPE ] = INVENTORY_TYPE_ACCESSORIES ;
							moveInventory [ _:INV_ITEM_REGION ] = "" ;
							moveInventory [ _:INV_ITEM_PLATE ] = "" ;
							moveInventory [ _:INV_ITEM_PLATE_TYPE ] = NUMBERPLATE_TYPE_NONE ;
							moveInventory [ _:INV_ITEM_ID ] = GetUserAccessories ( playerid, ACS_ID, moveFromIndex ) ;
							moveInventory [ _:INV_ITEM_DATE ] = GetElapsedTime ( GetUserAccessories ( playerid, ACS_DATE, moveFromIndex ), gettime ( ), CONVERT_TIME_TO_DAYS ) ;
							moveInventory [ _:INV_OBJ_X ] = GetUserAccessories ( playerid, ACS_OBJ_X, moveFromIndex ) ;
							moveInventory [ _:INV_OBJ_Y ] = GetUserAccessories ( playerid, ACS_OBJ_Y, moveFromIndex ) ;
							moveInventory [ _:INV_OBJ_Z ] = GetUserAccessories ( playerid, ACS_OBJ_Z, moveFromIndex ) ;
							moveInventory [ _:INV_ROT_X ] = GetUserAccessories ( playerid, ACS_ROT_X, moveFromIndex ) ;
							moveInventory [ _:INV_ROT_Y ] = GetUserAccessories ( playerid, ACS_ROT_Y, moveFromIndex ) ;
							moveInventory [ _:INV_ROT_Z ] = GetUserAccessories ( playerid, ACS_ROT_Z, moveFromIndex ) ;
							_return = giveInventorySlot ( playerid, moveInventory, moveToIndex ) ;
						}
						if ( _return == -1 )
						{
							send_check_cinfo ( playerid, "Вы не можете переместить предмет в выбранный слот!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
							return 1 ;
						}
						clear_accessories ( playerid, GetUserAccessories ( playerid, ACS_ID, moveFromIndex ) ) ;
					}
				}
				case 1: // аксессуары
				{
					new _modelId = GetUsersInventory ( playerid, INV_ITEM, moveFromIndex ) ;
					if ( ! GetAccessoriesItem ( _modelId ) )
					{
				        send_check_cinfo ( playerid, "Выбранный предмет не аксессуар!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
				    }

					if ( _modelId == ITEM_SIM_CARD && getPlayerAccessories ( playerid, ITEM_SIM_CARD ) )
					{
						send_check_cinfo ( playerid, "У Вас уже есть активная SIM-карта!\nСперва перенести в инвентарь активную.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}

					if ( weapon_skins ( _modelId ) )
					{
						if ( ! CheckAttackFreeSlotWeapon ( playerid, _modelId ) )
						{
							send_check_cinfo ( playerid, "У Вас уже активирован скин на это оружие!\nСперва снимите старый скин.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
							return 1 ;
						}
					}
					else
					{
						if ( ! CheckAttackFreeSlot ( playerid, _modelId ) )
						{
							send_check_cinfo ( playerid, "Слот на теле персонажа под выбранный аксессуар уже занят!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
							return 1 ;
						}
					}

					new _count = 1 ;
					if ( GetUsersInventory ( playerid, INV_ITEM, moveFromIndex ) == ITEM_SIM_CARD )
						_count = GetUsersInventory ( playerid, INV_ITEM_GIVE_DATE, moveFromIndex ) ;

					new USER_ACCESSORIES_STRUCT: acsStruct [ _:ACS_STRUCTURE_MAX ] ;
					acsStruct [ _:ACS_ID ] = GetUsersInventory ( playerid, INV_ITEM_ID, moveFromIndex ) ;
					acsStruct [ _:ACS_MODEL ] = _modelId ;
					acsStruct [ _:ACS_USED ] = 0 ;
					acsStruct [ _:ACS_DATE ] = GetElapsedTime ( GetUsersInventory ( playerid, INV_ITEM_DATE, moveFromIndex ), gettime ( ), CONVERT_TIME_TO_DAYS ) ;
					acsStruct [ _:ACS_COUNT ] = _count ;
					acsStruct [ _:ACS_ITEM_ID ] = GetUsersInventory ( playerid, INV_ITEM_ID, moveFromIndex ) ;
					acsStruct [ _:ACS_OBJ_X ] = GetUsersInventory ( playerid, INV_OBJ_X, moveFromIndex ) ;
					acsStruct [ _:ACS_OBJ_Y ] = GetUsersInventory ( playerid, INV_OBJ_Y, moveFromIndex ) ;
					acsStruct [ _:ACS_OBJ_Z ] = GetUsersInventory ( playerid, INV_OBJ_Z, moveFromIndex ) ;
					acsStruct [ _:ACS_ROT_X ] = GetUsersInventory ( playerid, INV_ROT_X, moveFromIndex ) ;
					acsStruct [ _:ACS_ROT_Y ] = GetUsersInventory ( playerid, INV_ROT_Y, moveFromIndex ) ;
					acsStruct [ _:ACS_ROT_Z ] = GetUsersInventory ( playerid, INV_ROT_Z, moveFromIndex ) ;
					new _return = give_accessories ( playerid, moveToIndex, acsStruct ) ;
					if ( _return == -1 )
					{
						send_check_cinfo ( playerid, "Вы не можете переместить предмет в выбранный слот!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
					clear_inventory_slot ( playerid, _modelId, 1, moveFromIndex ) ;
				}
				case 2: // склад
				{
					new _type = player_inventory { playerid } ;
					if ( _type == SUB_INV_VEHICLE ) set_packet_vehicle_put ( playerid, moveFromIndex, moveToIndex ) ;
					else if ( _type == SUB_INV_HOUSE ) set_packet_warehouse_put ( playerid, moveFromIndex, moveToIndex ) ;
					else if ( _type == SUB_INV_FAMILY ) set_packet_family_put ( playerid, moveFromIndex, moveToIndex ) ;
					else if ( _type == SUB_INV_FRACTION ) set_packet_fraction_put ( playerid, moveFromIndex, moveToIndex ) ;
					else if ( _type == SUB_INV_MARKET_PLACE ) dragged_market_place ( playerid, moveFromIndex, moveToIndex, false ) ;
				}
				case 3: // trader
				{

				}
				case 4: // receiver
				{

				}
			}
		}
	}
	else if ( actionId == 1 )
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new itemIndex, itemCount, inventoryType, action, _item ;
		JSON_GetInt ( json, "itemIndex", itemIndex ) ;
		JSON_GetInt ( json, "itemCount", itemCount ) ;
		JSON_GetInt ( json, "inventoryType", inventoryType ) ;
		JSON_GetInt ( json, "action", action ) ;

		if ( itemIndex < 0 )
		{
			send_check_cinfo ( playerid, "Произошла ошибка! Попробуйте заново.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		if ( inventoryType == 0 ) // инвентарь
		{
			_item = GetUsersInventory ( playerid, INV_ITEM, itemIndex ) ;
			if ( action == 0 ) // использовать
			{
				if ( _item == 2250 )
				{
				    send_check_cinfo ( playerid, "Для взаимодействия с номерами отправляйтесь в полицейский участок!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( GetAccessoriesItem ( _item ) )
				{
				    send_check_cinfo ( playerid, "Для взаимодействия нужно надеть аксессуар!\nПеретащите в слот для аксессуара.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( _item != 224 && item_blocked ( playerid, _item ) )
				{

				}
				else prise_open ( playerid, itemIndex ) ;
			}
			else if ( action == 1 ) // передать
			{
				new _pl_id ;
				sscanf ( playerTradeName [ playerid ], "u", _pl_id ) ;
				if ( ! IsPlayerConnected ( _pl_id ) )
				{
					send_check_cinfo ( playerid, "Игрока нет в сети!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( ! IsPlayerInRangeOfPoint ( _pl_id, 5, p_t_info [ playerid ] [ p_pos ] [ 0 ],
													p_t_info [ playerid ] [ p_pos ] [ 1 ],
													p_t_info [ playerid ] [ p_pos ] [ 2 ] ) )
				{
					send_check_cinfo ( playerid, "Игрок слишком далеко!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( _item == 2250 )
				{
				    send_check_cinfo ( playerid, "Для взаимодействия с номерами отправляйтесь в полицейский участок!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( item_blocked ( playerid, _item ) )
				{
				    send_check_cinfo ( playerid, "Этот предмет нельзя передать!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, GetUsersInventory ( playerid, INV_ITEM, itemIndex ) ) < itemCount )
				{
					send_check_cinfo ( playerid, "У Вас нет такого количества предмета!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				new _return = give_inventory (
					_pl_id,
					GetUsersInventory ( playerid, INV_ITEM, itemIndex ),
					itemCount,
					GetUsersInventory ( playerid, INV_ITEM_TYPE, itemIndex ),
					GetUsersInventory ( playerid, INV_ITEM_REGION, itemIndex ),
					GetUsersInventory ( playerid, INV_ITEM_PLATE, itemIndex ),
					NUMBERPLATE_TYPE_NONE,
					GetElapsedTime ( GetUsersInventory ( playerid, INV_ITEM_DATE, itemIndex ), gettime ( ), CONVERT_TIME_TO_DAYS )
				) ;
				if ( _return == -1 )
				{
					send_check_cinfo ( playerid, "У игрока нет свободного места в инвентаре!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				new query_string [ 144 ] ;
				format ( query_string, sizeof query_string, "%s передал(а) %s (#%d, %d шт.)",
				p_info [ playerid ] [ name ], p_info [ _pl_id ] [ name ], GetUsersInventory ( playerid, INV_ITEM, itemIndex ), itemCount ) ;
				WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;

				clear_inventory_slot (
					playerid,
					GetUsersInventory ( playerid, INV_ITEM, itemIndex ),
					itemCount,
					itemIndex
				) ;
			}
			else if ( action == 2 ) // выкинуть
			{
				if ( item_blocked ( playerid, _item ) )
				{
					send_check_cinfo ( playerid, "Вы не можете выкинуть выбранный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( GetUsersInventory ( playerid, INV_ITEM_TYPE, itemIndex ) == RENDER_TYPE_PLATE )
				{
					static const _str [ ] = "DELETE FROM `licence_plate` WHERE `licence_plate_char_id` = '%d' AND `id` = '%d' LIMIT 1" ;
					new query_string [ sizeof _str + ( 9 * 2 ) ] ;
					format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ], GetUsersInventory ( playerid, INV_ITEM_ID, itemIndex ) ) ;
					mysql_tquery ( sql_connection, query_string ) ;
				}

				if ( GetUsersInventory ( playerid, INV_ITEM_TYPE, itemIndex ) == INVENTORY_TYPE_ACCESSORIES )
					dropped_accessories ( GetUsersInventory ( playerid, INV_ITEM_ID, itemIndex ) ) ;

				if ( GetUsersInventory ( playerid, INV_ITEM_TYPE, itemIndex ) == INVENTORY_TYPE_SKINS )
					dropped_skins ( GetUsersInventory ( playerid, INV_ITEM_ID, itemIndex ) ) ;

				clear_inventory_slot ( playerid, GetUsersInventory ( playerid, INV_ITEM, itemIndex ), itemCount, itemIndex ) ;
			}
			else if ( action == 3 ) // разделить
			{
				if ( item_blocked ( playerid, _item ) )
				{
					send_check_cinfo ( playerid, "Вы не можете разделить выбранный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				new _slot = GetInventoryFreeSlot ( playerid, SUB_INVENTORY ) ;
				if ( _slot == -1 )
				{
					send_check_cinfo ( playerid, "У Вас нет свободного места в инвентаре.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				clear_inventory_slot ( 
					playerid, 
					GetUsersInventory ( playerid, INV_ITEM, itemIndex ),
					itemCount,
					itemIndex
				) ;
				give_inventory_slot (
					playerid,
					GetUsersInventory ( playerid, INV_ITEM, itemIndex ),
					itemCount,
					0,
					"",
					"",
					NUMBERPLATE_TYPE_NONE,
					0,
					_slot,
					GetElapsedTime ( GetUsersInventory ( playerid, INV_ITEM_DATE, itemIndex ), gettime ( ), CONVERT_TIME_TO_DAYS )
				) ;
			}
			else if ( action == 4 ) // информация
			{
				new invType = player_inventory { playerid } ;
				GetInventoryInfo ( playerid, invType, itemIndex ) ;
			}
		}
		else if ( inventoryType == 1 ) // аксессуары
		{
			if ( action == 0 ) // использовать
			{
				if ( weapon_skins ( GetUserAccessories ( playerid, ACS_MODEL, itemIndex ) ) )
				{
					send_check_cinfo ( playerid, "Возьмите в руки оружие, чтоб скин отобразился.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				else if ( GetUserAccessories ( playerid, ACS_MODEL, itemIndex ) == ITEM_SIM_CARD )
				{
					send_check_cinfo ( playerid, "SIM-карта уже активирована.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				create_airball ( playerid, GetUserAccessories ( playerid, ACS_MODEL, itemIndex ) ) ;
			}
			else if ( action == 1 ) // изменить
			{
				if ( weapon_skins ( GetUserAccessories ( playerid, ACS_MODEL, itemIndex ) ) )
				{
					send_check_cinfo ( playerid, "Возьмите в руки оружие, чтоб скин отобразился.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				else if ( GetUserAccessories ( playerid, ACS_MODEL, itemIndex ) == ITEM_SIM_CARD )
				{
					send_check_cinfo ( playerid, "SIM-карта уже активирована.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				show_inventory_ptd ( playerid, false ) ;
				onServerSendData ( playerid, UI_INVENTORY, 10, "" ) ;

				GetUserAccessories ( playerid, ACS_USED, itemIndex ) = 0 ;
				for ( new i = 5 ; i < 10 ; i ++ )
				{
					if ( IsPlayerAttachedObjectSlotUsed ( playerid, i ) ) RemovePlayerAttachedObject ( playerid, i ) ;
				}
				attachUserAccessories ( playerid ) ;

				edit_acc [ playerid ] = true ;
				GetUserAccessories ( playerid, ACS_USED, itemIndex ) = 1 ;
				attachUserAccessories ( playerid, itemIndex ) ;
				set_player_use_listitem ( playerid, itemIndex ) ;

				new _query [ 90 + 9 ] ;
				format ( _query, sizeof ( _query ), "UPDATE `users_accessories` SET `acs_used`='1' WHERE `id` = '%d' LIMIT 1",
				GetUserAccessories ( playerid, ACS_ID, itemIndex ) ) ;
				mysql_tquery ( sql_connection, _query ) ;
			}
			else if ( action == 2 ) // выкинуть
			{
				clear_accessories ( playerid, GetUserAccessories ( playerid, ACS_ID, itemIndex ) ) ;
				dropped_accessories ( GetUserAccessories ( playerid, ACS_ID, itemIndex ) ) ;
			}
			else if ( action == 3 ) // обнулить
			{
				if ( weapon_skins ( GetUserAccessories ( playerid, ACS_MODEL, itemIndex ) ) )
				{
					send_check_cinfo ( playerid, "Возьмите в руки оружие, чтоб скин отобразился.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				else if ( GetUserAccessories ( playerid, ACS_MODEL, itemIndex ) == ITEM_SIM_CARD )
				{
					send_check_cinfo ( playerid, "SIM-карту нельзя обнулить.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				GetUserAccessories ( playerid, ACS_OBJ_X, itemIndex ) =
				GetUserAccessories ( playerid, ACS_OBJ_Y, itemIndex ) =
				GetUserAccessories ( playerid, ACS_OBJ_Z, itemIndex ) =
				GetUserAccessories ( playerid, ACS_ROT_X, itemIndex ) =
				GetUserAccessories ( playerid, ACS_ROT_Y, itemIndex ) =
				GetUserAccessories ( playerid, ACS_ROT_Z, itemIndex ) = 0.0 ;

				save_accesories ( playerid, itemIndex ) ;

				for ( new i = 5 ; i < 10 ; i ++ ) if ( IsPlayerAttachedObjectSlotUsed ( playerid, i ) ) RemovePlayerAttachedObject ( playerid, i ) ;
				attachUserAccessories ( playerid ) ;
			}
			else if ( action == 4 ) // информация
			{
				new invType = player_inventory { playerid } ;
				GetInventoryInfo ( playerid, invType, itemIndex ) ;
			}
		}
		else if ( inventoryType == 2 ) // остальное
		{
			if ( action == 0 ) // информация
			{
				new _type = player_inventory { playerid } ;
				if ( _type == SUB_INV_FAMILY )
				{
					new familyId = p_info [ playerid ] [ family ] ;
					if ( family_info [ familyId - 1 ] [ fam_creator_id ] != p_info [ playerid ] [ id ] )
					{
						send_check_cinfo ( playerid, "Вы не владелец семьи!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return false ;
					}
					set_packet_family_use ( playerid, itemIndex ) ;
				}
				else if ( _type  == SUB_INV_FRACTION )
				{
					if ( ! p_info [ playerid ] [ leader ] )
					{
						send_check_cinfo ( playerid, "Вы не лидер организации!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return false ;
					}
					set_packet_fraction_use ( playerid, itemIndex ) ;
				}
			}
			else if ( action == 1 ) // отмена
			{

			}
			else if ( action == 2 ) // выкинуть
			{
				new _type = player_inventory { playerid } ;
				if ( _type == SUB_INV_VEHICLE ) set_packet_vehicle_get ( playerid, true, itemIndex, -1 ) ;
				else if ( _type == SUB_INV_HOUSE ) set_packet_warehouse_get ( playerid, true, itemIndex, -1 ) ;
				else if ( _type == SUB_INV_FAMILY )
				{
					new familyId = p_info [ playerid ] [ family ] ;
					if ( family_info [ familyId - 1 ] [ fam_creator_id ] != p_info [ playerid ] [ id ] )
					{
						send_check_cinfo ( playerid, "Вы не владелец семьи!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return false ;
					}
					set_packet_family_get ( playerid, true, itemIndex, -1 ) ;
				}
				else if ( _type == SUB_INV_FRACTION )
				{
					if ( ! p_info [ playerid ] [ leader ] )
					{
						send_check_cinfo ( playerid, "Вы не лидер организации!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return false ;
					}
					set_packet_fraction_get ( playerid, true, itemIndex, -1 ) ;
				}
				else if ( _type == SUB_INV_MARKET_PLACE )
				{
					if ( GetMarketPlaceInventory ( playerid, INV_ITEM_TYPE, itemIndex ) == INVENTORY_TYPE_ACCESSORIES )
						dropped_accessories ( GetMarketPlaceInventory ( playerid, INV_ITEM_ID, itemIndex ) ) ;

					if ( GetMarketPlaceInventory ( playerid, INV_ITEM_TYPE, itemIndex ) == INVENTORY_TYPE_SKINS )
						dropped_skins ( GetMarketPlaceInventory ( playerid, INV_ITEM_ID, itemIndex ) ) ;

					clear_market_place_slot ( playerid, GetMarketPlaceInventory ( playerid, INV_ITEM, itemIndex ), itemCount, itemIndex ) ;
				}
			}
			else if ( action == 3 ) // разделить
			{
				new _type = player_inventory { playerid } ;
				if ( _type == SUB_INV_VEHICLE ) set_packet_vehicle_divide ( playerid, itemIndex, itemCount ) ;
				else if ( _type == SUB_INV_HOUSE ) set_packet_warehouse_divide ( playerid, itemIndex, itemCount ) ;
				else if ( _type == SUB_INV_FAMILY )
				{
					new familyId = p_info [ playerid ] [ family ] ;
					if ( family_info [ familyId - 1 ] [ fam_creator_id ] != p_info [ playerid ] [ id ] )
					{
						send_check_cinfo ( playerid, "Вы не владелец семьи!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return false ;
					}
					set_packet_family_divide ( playerid, itemIndex, itemCount ) ;
				}
				else if ( _type == SUB_INV_FRACTION )
				{
					if ( ! p_info [ playerid ] [ leader ] )
					{
						send_check_cinfo ( playerid, "Вы не лидер организации!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return false ;
					}
					set_packet_fraction_divide ( playerid, itemIndex, itemCount ) ;
				}
				else if ( _type == SUB_INV_MARKET_PLACE ) set_market_place_divide ( playerid, itemIndex, itemCount ) ;
			}
			else if ( action == 4 ) // информация
			{
				new invType = player_inventory { playerid } ;
				GetInventoryInfo ( playerid, invType, itemIndex ) ;
			}
		}
	}
	else if ( actionId == 2 )
	{
		new subInv = strval ( data ) ;
		player_inventory { playerid } = subInv ;
		if ( subInv == SUB_INVENTORY ) // инвентарь
		{
			SetInventoryAcs ( playerid ) ;
			setInventoryLayout ( playerid, 0 ) ;
			setCharacterInfo ( playerid ) ;
		}
		else if ( subInv == SUB_INV_FISHING ) // рыбалка
		{
			show_packet_inventory ( playerid, 3, "0" ) ;
			onServerDestroy ( playerid, UI_INVENTORY ) ;
			show_fishing_inventory ( playerid ) ;
		}
		else if ( subInv == SUB_INV_VEHICLE ) // багажник
		{
			new _v_id = idaofcar [ playerid ] ;
			setInventoryLayout ( playerid, 1 ) ;
			setInventoryWarehouse ( playerid, subInv, _v_id ) ;
			setWarehouseInfo (
				playerid,
				"Багажник", 
				"Здесь хранятся предметы, которые\nв автомобиле", 
				"ВАШ ТРАНСПОРТ", 
				"ГОС. НОМЕРА",
				GetVehicleNameEx ( _v_id ),
				plate_number1 ( veh_info [ _v_id - 1 ] [ v_plate_type ], veh_info [ _v_id - 1 ] [ v_plate ], veh_info [ _v_id - 1 ] [ v_region ] )
			) ;
		}
		else if ( subInv == SUB_INV_HOUSE ) // домашний сейф
		{
			if ( ! safe_pin_status [ playerid ] )
			{
				if ( p_info [ playerid ] [ password_status ] ) show_dialog ( playerid, d_safe_pin, DIALOG_STYLE_INPUT, "{"#cBHD"}Код от сейфа", "{ffffff}Введите код от сейфа, чтобы получить доступ к содержимому:", "Принять", "Закрыть" ) ;
				else show_dialog ( playerid, d_safe_pin, DIALOG_STYLE_PASSWORD, "{"#cBHD"}Код от сейфа", "{ffffff}Введите код от сейфа, чтобы получить доступ к содержимому:", "Принять", "Закрыть" ) ;
				return 1 ;
			}

			new _h_id = GetPVarInt ( playerid, "house_id" ), _str [ 12 ], _str2 [ 32 ] ;
			setInventoryLayout ( playerid, 1 ) ;
			setInventoryWarehouse ( playerid, subInv, _h_id ) ;
			format ( _str, sizeof _str, "%d", _h_id ) ;
			format ( _str2, sizeof _str2, "%s", GetPlayerCashValueToSmile ( h_info [ _h_id - 1 ] [ h_safe_data ] [ 1 ] ) ) ;
			setWarehouseInfo (
				playerid,
				"Домашний сейф", 
				"Здесь хранятся предметы, которые\nв доме", 
				"СЕЙФ ДОМА", 
				"ДЕНЕГ В СЕФЕЙ",
				_str,
				_str2
			) ;
		}
		else if ( subInv == SUB_INV_FAMILY ) // семейный склад
		{
			new _fam_id = p_info [ playerid ] [ family ], _str [ 32 ] ;
			if ( family_info [ _fam_id - 1 ] [ fam_house ] )
			{
				if ( GetPlayerVirtualWorld ( playerid ) != family_info [ _fam_id - 1 ] [ fam_house ] )
				{
					send_check_cinfo ( playerid, "Вы должны находиться в доме семьи.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			}
			else
			{
				send_check_cinfo ( playerid, "У Вашей семьи нет дома.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			setInventoryLayout ( playerid, 1 ) ;
			setInventoryWarehouse ( playerid, subInv, _fam_id ) ;
			format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( family_info [ _fam_id - 1 ] [ fam_bank ] ) ) ;
			setWarehouseInfo (
				playerid,
				"Семейный склад", 
				"Здесь хранятся предметы, которые\nв семье", 
				"СЕМЬЯ", 
				"ДЕНЕГ В СЕМЬЕ",
				family_info [ _fam_id - 1 ] [ fam_name ],
				_str
			) ;
		}
		else if ( subInv == SUB_INV_FRACTION ) // склад организации
		{
			new _f_id = p_info [ playerid ] [ member ], _str [ 32 ] ;
			if ( used_area [ playerid ] == -1 || area_info [ used_area [ playerid ] ] [ a_type ] != area_type_dorm && area_info [ used_area [ playerid ] ] [ a_type ] != area_type_dorm_unload )
			{
				send_check_cinfo ( playerid, "Вы должны находиться около склада организации.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			setInventoryLayout ( playerid, 1 ) ;
			setInventoryWarehouse ( playerid, subInv, _f_id ) ;
			format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( f_info [ _f_id - 1 ] [ f_money ] ) ) ;
			setWarehouseInfo (
				playerid,
				"Склад организации", 
				"Здесь хранятся предметы, которые\nв организации", 
				"ОРГАНИЗАЦИЯ", 
				"ДЕНЕГ В ОРГАНИЗАЦИИ",
				f_info [ _f_id - 1 ] [ f_name ],
				_str
			) ;
		}
		else if ( subInv == SUB_INV_GUARDS ) // инвентарь охранников
		{
			setInventoryLayout ( playerid, 2 ) ;
			SetGuardsInfo ( playerid ) ;
		}
	}
	else if ( actionId == 3 )
	{
		new idx = strval ( data ) ;
		if ( idx == 0 ) show_inventory_ptd ( playerid, false ) ; // exit
		else if ( idx == 1 ) show_mainmenu ( playerid ) ; // main menu
		else if ( idx == 2 ) show_playersettings ( playerid ) ; // settings
		else if ( idx == 3 ) // tablet
		{
			show_inventory_ptd ( playerid, false ) ;
			onServerSendData ( playerid, UI_INVENTORY, 10, "" ) ;
			
			callcmd::phone ( playerid ) ;
		}
	}
	else if ( actionId == 4 )
	{
		if ( p_info [ playerid ] [ hour_played ] < FIVE_HOUR_PLAYED ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 5 часов в игре. Используйте /mm - Информация о персонаже - Статистика персонажа." ) ;

		new _type = player_inventory { playerid } ;
		if ( _type == SUB_INV_HOUSE )
		{
			new _h_id = GetPVarInt ( playerid, "house_id" ) ;
			if ( _h_id < 1 || _h_id > MAX_HOUSES ) return 1 ;
			
			show_dialog ( playerid, d_safe_access, DIALOG_STYLE_LIST, "{"#cBHD"}Сейф", "Взять деньги\nПоложить деньги\n{"#cLY"}Сменить пин-код", "Выбрать", "Закрыть" ) ;
		}
		else if ( _type == SUB_INV_FAMILY )
		{
			new header_string [ 64 ] ;
			format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_bank ] ) ) ;
			show_dialog ( playerid, d_family_bank, DIALOG_STYLE_LIST, header_string, "{"#cGRDialog"}- {"#cWH"}Положить\n{"#cGRDialog"}- {"#cWH"}Взять", "Выбрать", "Назад" ) ;
		}
		else if ( _type == SUB_INV_FRACTION )
		{
			send_check_cinfo ( playerid, "Со счёта организации нельзя снимать денежные средства.\nПополнить счёт организации можно через банковские услуги в Банке.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		}
	}
	else if ( actionId == 5 )
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new itemIndex, inventoryType ;
		JSON_GetInt ( json, "itemIndex", itemIndex ) ;
		JSON_GetInt ( json, "inventoryType", inventoryType ) ;
		
		if ( ! users_education [ playerid ] [ EDUCATION_INV_SLOT ] )
		{
			show_window_monologue (
				playerid,
				5,
				"Отлично! Теперь давай потренируемся перемещать предмет. \
				Для этого тебе нужно его зажать и подержать, пока не увидишь, \
				что за твоим пальцем двигается выбранный предмет.",
				"Местный",
				"Понял"
			) ;

			save_user_education ( playerid, EDUCATION_INV_SLOT ) ;
		}

		if ( ! users_education [ playerid ] [ EDUCATION_INV_DRAGGED ] )
		{
			show_window_monologue (
				playerid,
				5,
				"Отлично! Теперь давай потренируемся перемещать предмет. \
				Для этого тебе нужно его зажать и подержать, пока не увидишь, \
				что за твоим пальцем двигается выбранный предмет.",
				"Местный",
				"Понял"
			) ;
		}

		if ( inventoryType == 0 ) // inventory
		{
			new modelId = GetUsersInventory ( playerid, INV_ITEM, itemIndex ), 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				dayAction = GetUsersInventory ( playerid, INV_ITEM_DATE, itemIndex ),
				modelCount = GetUsersInventory ( playerid, INV_ITEM_COUNT, itemIndex ),
				date_string [ 64 ] ;
					
			if ( dayAction != -1 )
			{
				timestamp_to_date ( dayAction + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d\n", s_day, s_month, s_year ) ;
			}
			else format ( date_string, sizeof date_string, " " ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
				{"#cWH"}Предмет: {"#cOR"}%s\n\
				{"#cWH"}Количество: {"#cWV"}%d шт.\n\
				{"#cWH"}%s\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.",
			item_name ( modelId ), modelCount, date_string, get_model_count ( modelId ) ) ;

			onServerSendData ( playerid, UI_INVENTORY, 12, global_string ) ;

			new Node: node = JSON_Array ( ), Node: nodePlayer ;
			foreach(new i: streamed_players[playerid])
			{
				nodePlayer = JSON_Array (
					JSON_String ( p_info [ i ] [ name ] )
				) ;

				node = JSON_Append ( node, nodePlayer ) ;
			}
			
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_INVENTORY, 11, global_string ) ;

			playerTradeName [ playerid ] [ 0 ] = EOS ;
		}
		else if ( inventoryType == 1 ) // acessories
		{
			new modelId = GetUserAccessories ( playerid, ACS_MODEL, itemIndex ), 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				dayAction = GetUserAccessories ( playerid, ACS_DATE, itemIndex ),
				modelCount = 1,
				date_string [ 64 ] ;
					
			if ( dayAction != -1 )
			{
				timestamp_to_date ( dayAction + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d\n", s_day, s_month, s_year ) ;
			}
			else format ( date_string, sizeof date_string, " " ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
				{"#cWH"}Предмет: {"#cOR"}%s\n\
				{"#cWH"}Количество: {"#cWV"}%d шт.\n\
				{"#cWH"}%s\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.",
			item_name ( modelId ), modelCount, date_string, get_model_count ( modelId ) ) ;

			onServerSendData ( playerid, UI_INVENTORY, 12, global_string ) ;
		}
		else if ( inventoryType == 2 ) // warehouse
		{
			new invType = player_inventory { playerid } ;
			GetInventoryItemInfo ( playerid, invType, itemIndex ) ;
		}
	}
	else if ( actionId == 6 ) // select name
	{
		format ( playerTradeName [ playerid ], MAX_PLAYER_NAME, "%s", data ) ;
	}
	else if ( actionId == 7 ) // money
	{
		new _pi = player_inventory { playerid } ;
		if ( _pi == 7 )
		{
			if ( p_info [ playerid ] [ hour_played ] < FIVE_HOUR_PLAYED ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 5 часов в игре. Используйте /mm - Информация о персонаже - Статистика персонажа." ) ;

			new _h_id = GetPVarInt ( playerid, "house_id" ) ;
			if ( _h_id < 1 || _h_id > MAX_HOUSES ) return 1 ;
		
			show_dialog ( playerid, d_safe_access, DIALOG_STYLE_LIST, "{"#cBHD"}Сейф", "Взять деньги\nПоложить деньги\n{"#cLY"}Сменить пин-код", "Выбрать", "Закрыть" ) ;
		}
		else if ( _pi == 10 )
		{
			if ( p_info [ playerid ] [ hour_played ] < FIVE_HOUR_PLAYED ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 5 часов в игре. Используйте /mm - Информация о персонаже - Статистика персонажа." ) ;

			new header_string [ 64 ] ;
			format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_bank ] ) ) ;
			show_dialog ( playerid, d_family_bank, DIALOG_STYLE_LIST, header_string, "{"#cGRDialog"}- {"#cWH"}Положить\n{"#cGRDialog"}- {"#cWH"}Взять", "Выбрать", "Назад" ) ;
		}
		else if ( _pi == 11 )
		{
			if ( p_info [ playerid ] [ hour_played ] < FIVE_HOUR_PLAYED ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 5 часов в игре. Используйте /mm - Информация о персонаже - Статистика персонажа." ) ;

			send_check_cinfo ( playerid, "Со счёта организации нельзя снимать денежные средства.\nПополнить счёт организации можно через банковские услуги в Банке.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		}
	}
	else if ( actionId == 9 ) // click guard, need show info
	{
		
	}
	return 1 ;
}

stock GetInventoryItemInfo ( playerid, inventoryType, itemIndex )
{
	new s_year, s_month, s_day, s_hour, s_minute, s_second,
		modelId, modelCount, dayAction, date_string [ 64 ] ;
	if ( inventoryType == SUB_INV_VEHICLE )
	{
		new vehicleId = idaofcar [ playerid ] ;
			
		modelId = GetVehicleInventory ( vehicleId, INV_ITEM, itemIndex ) ;
		dayAction = GetVehicleInventory ( vehicleId, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetVehicleInventory ( vehicleId, INV_ITEM_COUNT, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_HOUSE )
	{
		new houseId = GetPVarInt ( playerid, "house_id" ) ;

		modelId = GetHouseInventory ( houseId, INV_ITEM, itemIndex ) ;
		dayAction = GetHouseInventory ( houseId, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetHouseInventory ( houseId, INV_ITEM_COUNT, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_FAMILY )
	{
		new familyId = p_info [ playerid ] [ family ] ;

		modelId = GetFamilyInventory ( familyId, INV_ITEM, itemIndex ) ;
		dayAction = GetFamilyInventory ( familyId, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetFamilyInventory ( familyId, INV_ITEM_COUNT, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_FRACTION )
	{
		new fId = p_info [ playerid ] [ member ] ;

		modelId = GetFractionInventory ( fId, INV_ITEM, itemIndex ) ;
		dayAction = GetFractionInventory ( fId, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetFractionInventory ( fId, INV_ITEM_COUNT, itemIndex ) ;
	}
	else if ( inventoryType == SUB_INV_MARKET_PLACE )
	{
		modelId = GetMarketPlaceInventory ( playerid, INV_ITEM, itemIndex ) ; 
		dayAction = GetMarketPlaceInventory ( playerid, INV_ITEM_DATE, itemIndex ) ;
		modelCount = GetMarketPlaceInventory ( playerid, INV_ITEM_COUNT, itemIndex ) ;
	}
	if ( dayAction != -1 )
	{
		timestamp_to_date ( dayAction + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
		format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d\n", s_day, s_month, s_year ) ;
	}
	else format ( date_string, sizeof date_string, " " ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, sizeof global_string, "\
		{"#cWH"}Предмет: {"#cOR"}%s\n\
		{"#cWH"}Количество: {"#cWV"}%d шт.\n\
		{"#cWH"}%s\n\
		{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.",
	item_name ( modelId ), modelCount, date_string, get_model_count ( modelId ) ) ;

	onServerSendData ( playerid, UI_INVENTORY, 12, global_string ) ;
	return true ;
}

stock set_packet_vehicle_put ( playerid, _id, _toId )
{
	new _v_id = idaofcar [ playerid ],
		draggedItem = GetUsersInventory ( playerid, INV_ITEM, _id ), 
		draggedItemCount = GetUsersInventory ( playerid, INV_ITEM_COUNT, _id ) ;
	if ( _v_id < 1 || _v_id > MAX_VEHICLES ) return 1 ;

	if ( item_blocked ( playerid, draggedItem, 1 ) )
	{
		send_check_cinfo ( playerid, "Выбранный предмет нельзя переместить!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
	inventoryStruct = TransferInventoryStructure ( playerid, SUB_INVENTORY, _id ) ;
	inventoryStruct [ _:INV_ITEM ] = draggedItem ;
	inventoryStruct [ _:INV_ITEM_COUNT ] = draggedItemCount ;
	new _slot = give_vehicle_item ( _v_id, _toId, inventoryStruct ) ;
	if ( _slot == -1 )
	{
		send_check_cinfo ( playerid, "В багажнике нет свободного места!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}
	
	new query_string [ 144 ] ;
	format ( query_string, sizeof query_string, "%s положил(а) в багажник (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], veh_info [ _v_id - 1 ] [ v_id ], item_name ( draggedItem ), draggedItem, draggedItemCount ) ;
	WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
	
	clear_inventory_slot ( playerid, draggedItem, draggedItemCount, _id ) ;
	updateInventorySlot ( playerid, _id ) ;
	SetWarehouseItemID ( playerid, SUB_INV_VEHICLE, _v_id, _slot ) ;

	foreach(new i: streamed_players[playerid])
	{
		if ( player_inventory { i } != SUB_INV_VEHICLE ) continue ;
		if ( idaofcar [ i ] != _v_id ) continue ;
		SetWarehouseItemID ( i, SUB_INV_VEHICLE, _v_id, _slot ) ;		
	}
	return 1 ;
}

stock set_packet_vehicle_divide ( playerid, _id, itemCount )
{
	new _v_id = idaofcar [ playerid ], 
		draggedItem = GetVehicleInventory ( _v_id, INV_ITEM, _id ),
		query_string [ 144 ] ;

	if ( item_blocked ( playerid, draggedItem ) )
	{
		send_check_cinfo ( playerid, "Вы не можете разделить выбранный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new freeSlotId = GetInventoryFreeSlot ( _v_id, SUB_INV_VEHICLE ) ;
	if ( freeSlotId == -1 )
	{
		send_check_cinfo ( playerid, "У Вас нет свободного места в багажнике.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new _slot = clear_vehicle_item ( _v_id, draggedItem, itemCount, _id ) ;
	SetWarehouseItemID ( playerid, SUB_INV_VEHICLE, _v_id, _slot ) ;
	foreach(new i: streamed_players[playerid])
	{
		if ( player_inventory { i } != SUB_INV_VEHICLE ) continue ;
		if ( idaofcar [ i ] != _v_id ) continue ;
		SetWarehouseItemID ( i, SUB_INV_VEHICLE, _v_id, _slot ) ;
	}
	
	new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
	inventoryStruct = TransferInventoryStructure ( _v_id, SUB_INV_VEHICLE, _id ) ;
	inventoryStruct [ _:INV_ITEM ] = draggedItem ;
	inventoryStruct [ _:INV_ITEM_COUNT ] = itemCount ;
	_slot = give_vehicle_item ( _v_id, freeSlotId, inventoryStruct ) ;

	SetWarehouseItemID ( playerid, SUB_INV_VEHICLE, _v_id, _slot ) ;
	foreach(new i: streamed_players[playerid])
	{
		if ( player_inventory { i } != SUB_INV_VEHICLE ) continue ;
		if ( idaofcar [ i ] != _v_id ) continue ;
		SetWarehouseItemID ( i, SUB_INV_VEHICLE, _v_id, _slot ) ;
	}
		
	format ( query_string, sizeof query_string, "%s разделил(а) в багажнике (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], veh_info [ _v_id - 1 ] [ v_id ], item_name ( draggedItem ), draggedItem, itemCount ) ;
	WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
	return 1 ;
}

stock set_packet_vehicle_get ( playerid, bool: status, _id, _toId )
{
	if ( ! status )
	{
		new _v_id = idaofcar [ playerid ], 
			draggedItem = GetVehicleInventory ( _v_id, INV_ITEM, _id ), 
			draggedItemCount = GetVehicleInventory ( _v_id, INV_ITEM_COUNT, _id ),
			query_string [ 144 ] ;

		if ( ! draggedItem ) return false ;
		if ( _v_id < 1 || _v_id > MAX_VEHICLES ) return false ;
		
		if ( item_blocked ( playerid, GetUsersInventory ( playerid, INV_ITEM, _toId ), 1 ) )
		{
			send_check_cinfo ( playerid, "В эту ячейку нельзя переместить!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		if ( item_not_get ( draggedItem ) )
		{
			send_check_cinfo ( playerid, "Вы не можете взять данный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		new _max_slot = item_max_in_slot ( draggedItem ) ;
		if ( _max_slot != -1 && GetUsersInventory ( playerid, INV_ITEM_COUNT, GetInventoryFindItem ( playerid, SUB_INVENTORY, draggedItem ) ) + draggedItemCount > _max_slot )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "Вы не можете переносить более %d шт. выбранного предмета.", _max_slot ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		format ( query_string, sizeof query_string, "%s взял(а) из багажника (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], veh_info [ _v_id - 1 ] [ v_id ], item_name ( draggedItem ), draggedItem, draggedItemCount ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		new USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] ;
		itemStruct = TransferInventoryStructure ( _v_id, SUB_INV_VEHICLE, _id ) ;
		new _slot = GiveInventorySlot ( playerid, SUB_INVENTORY, _toId, itemStruct ) ;
		if ( _slot == -1 )
		{
			send_check_cinfo ( playerid, "Выбарнный слот инвентаря не пустой!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		_slot = clear_vehicle_item ( _v_id, draggedItem, draggedItemCount, _id ) ;
		SetWarehouseItemID ( playerid, SUB_INV_VEHICLE, _v_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != SUB_INV_VEHICLE ) continue ;
			if ( idaofcar [ i ] != _v_id ) continue ;
			SetWarehouseItemID ( i, SUB_INV_VEHICLE, _v_id, _slot ) ;
		}
	}
	else if ( status )
	{
		new _v_id = idaofcar [ playerid ], 
			draggedItem = GetVehicleInventory ( _v_id, INV_ITEM, _id ), 
			draggedItemCount = GetVehicleInventory ( _v_id, INV_ITEM_COUNT, _id ),
			query_string [ 144 ] ;
		if ( _v_id < 1 || _v_id > MAX_VEHICLES ) return 1 ;
		
		if ( GetVehicleInventory ( _v_id, INV_ITEM_TYPE, _id ) == INVENTORY_TYPE_ACCESSORIES )
			dropped_accessories ( GetVehicleInventory ( _v_id, INV_ITEM_ID, _id ) ) ;

		if ( GetVehicleInventory ( _v_id, INV_ITEM_TYPE, _id ) == INVENTORY_TYPE_SKINS )
			dropped_skins ( GetVehicleInventory ( _v_id, INV_ITEM_ID, _id ) ) ;

		format ( query_string, sizeof query_string, "%s выбросил(а) из багажника (#%d) %s (#%d)", p_info [ playerid ] [ name ], veh_info [ _v_id - 1 ] [ v_id ], item_name ( draggedItem ), draggedItemCount ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		new _slot = clear_vehicle_item ( _v_id, draggedItem, draggedItemCount, _id ) ;
		SetWarehouseItemID ( playerid, SUB_INV_VEHICLE, _v_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != SUB_INV_VEHICLE ) continue ;
			if ( idaofcar [ i ] != _v_id ) continue ;
			SetWarehouseItemID ( i, SUB_INV_VEHICLE, _v_id, _slot ) ;
		}
	}
	return 1 ;
}

stock give_vehicle_item ( vehicleId, slotId, const USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] )
{
	if ( slotId == -1 ) slotId = GiveInventory ( vehicleId, SUB_INV_VEHICLE, itemStruct ) ;
	else GiveInventorySlot ( vehicleId, SUB_INV_VEHICLE, slotId, itemStruct ) ;
	return slotId ;
}

stock clear_vehicle_item ( vehicleId, modelId, modelCount, slotId = -1 )
{
	if ( slotId == -1 ) slotId = ClearInventory ( vehicleId, SUB_INV_VEHICLE, modelId, modelCount ) ;
	else slotId = ClearInventorySlot ( vehicleId, SUB_INV_VEHICLE, slotId, modelId, modelCount ) ;
	return slotId ;
}

stock dragged_vehicle_item ( playerid, vehicleId, moveFromIndex, moveToIndex )
{
	new draggedItem = GetVehicleInventory ( vehicleId, INV_ITEM, moveFromIndex ),
		draggedItemCount = GetVehicleInventory ( vehicleId, INV_ITEM_COUNT, moveFromIndex ),
		droppedItem = GetVehicleInventory ( vehicleId, INV_ITEM, moveToIndex ),
		droppedItemCount = GetVehicleInventory ( vehicleId, INV_ITEM_COUNT, moveToIndex ),
		USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ],
		USERS_INVENTORY_STRUCT: toInventory [ _:INV_STRUCTURE_MAX ] ;

	moveInventory = TransferInventoryStructure ( vehicleId, SUB_INV_VEHICLE, moveFromIndex ) ;
	toInventory = TransferInventoryStructure ( vehicleId, SUB_INV_VEHICLE, moveToIndex ) ;

	if ( droppedItem > 0 )
	{
		if ( draggedItem == droppedItem )
		{
			clear_vehicle_item ( vehicleId, draggedItem, draggedItemCount, moveFromIndex ) ;
			give_vehicle_item ( vehicleId, moveToIndex, moveInventory ) ;

			foreach(new i: streamed_players[playerid])
			{
				if ( player_inventory { i } != SUB_INV_VEHICLE ) continue ;
				if ( idaofcar [ i ] != vehicleId ) continue ;

				SetWarehouseItemID ( i, SUB_INV_VEHICLE, vehicleId, moveFromIndex ) ;
				SetWarehouseItemID ( i, SUB_INV_VEHICLE, vehicleId, moveToIndex ) ;
			}
			return 1 ;
		}

		clear_vehicle_item ( vehicleId, draggedItem, draggedItemCount, moveFromIndex ) ;
		clear_vehicle_item ( vehicleId, droppedItem, droppedItemCount, moveToIndex ) ;
		
		give_vehicle_item ( vehicleId, moveToIndex, moveInventory ) ;
		give_vehicle_item ( vehicleId, moveFromIndex, toInventory ) ;
	}
	else
	{
		clear_vehicle_item ( vehicleId, draggedItem, draggedItemCount, moveFromIndex ) ;
		give_vehicle_item ( vehicleId, moveToIndex, moveInventory ) ;
	}

	foreach(new i: streamed_players[playerid])
	{
		if ( player_inventory { i } != SUB_INV_VEHICLE ) continue ;
		if ( idaofcar [ i ] != vehicleId ) continue ;

		SetWarehouseItemID ( i, SUB_INV_VEHICLE, vehicleId, moveFromIndex ) ;
		SetWarehouseItemID ( i, SUB_INV_VEHICLE, vehicleId, moveToIndex ) ;
	}
	return 1 ;
}

stock set_packet_warehouse_put ( playerid, _id, _toId )
{
	new _h_id = GetPVarInt ( playerid, "house_id" ),
		draggedItem = GetUsersInventory ( playerid, INV_ITEM, _id ),
		draggedItemCount = GetUsersInventory ( playerid, INV_ITEM_COUNT, _id ) ;
	if ( _h_id < 1 || _h_id > MAX_HOUSES ) return 1 ;

	if ( item_blocked ( playerid, draggedItem, 1 ) )
	{
		send_check_cinfo ( playerid, "Выбранный предмет нельзя переместить!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
	inventoryStruct = TransferInventoryStructure ( playerid, SUB_INVENTORY, _id ) ;
	inventoryStruct [ _:INV_ITEM ] = draggedItem ;
	inventoryStruct [ _:INV_ITEM_COUNT ] = draggedItemCount ;
	new _slot = give_warehouse_item ( _h_id, _toId, inventoryStruct ) ;
	if ( _slot == -1 )
	{
		send_check_cinfo ( playerid, "В сейфе нет свободного места!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}
		
	new query_string [ 144 ] ;
	format ( query_string, sizeof query_string, "%s положил(а) в сейф (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _h_id, item_name ( draggedItem ), draggedItem, draggedItemCount ) ;
	WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
	clear_inventory_slot ( playerid, draggedItem, draggedItemCount, _id ) ;
	updateInventorySlot ( playerid, _id ) ;
	SetWarehouseItemID ( playerid, SUB_INV_HOUSE, _h_id, _slot ) ;
		
	foreach(new i: streamed_players[playerid])
	{
		if ( player_inventory { i } != SUB_INV_HOUSE ) continue ;
		if ( GetPVarInt ( i, "house_id" ) != _h_id ) continue ;
		SetWarehouseItemID ( i, SUB_INV_HOUSE, _h_id, _slot ) ;
	}
	return 1 ;
}

stock set_packet_warehouse_divide ( playerid, _id, itemCount )
{
	new _h_id = GetPVarInt ( playerid, "house_id" ), 
		draggedItem = GetHouseInventory ( _h_id, INV_ITEM, _id ),
		query_string [ 144 ] ;

	if ( item_blocked ( playerid, draggedItem ) )
	{
		send_check_cinfo ( playerid, "Вы не можете разделить выбранный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new freeSlotId = GetInventoryFreeSlot ( _h_id, SUB_INV_HOUSE ) ;
	if ( freeSlotId == -1 )
	{
		send_check_cinfo ( playerid, "У Вас нет свободного места на складе.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new _slot = clear_warehouse_item ( _h_id, draggedItem, itemCount, _id ) ;
	SetWarehouseItemID ( playerid, SUB_INV_HOUSE, _h_id, _slot ) ;
	foreach(new i: streamed_players[playerid])
	{
		if ( player_inventory { i } != SUB_INV_HOUSE ) continue ;
		if ( GetPVarInt ( i, "house_id" ) != _h_id ) continue ;
		SetWarehouseItemID ( i, SUB_INV_HOUSE, _h_id, _slot ) ;
	}

	new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
	inventoryStruct = TransferInventoryStructure ( _h_id, SUB_INV_HOUSE, _id ) ;
	inventoryStruct [ _:INV_ITEM ] = draggedItem ;
	inventoryStruct [ _:INV_ITEM_COUNT ] = itemCount ;
	_slot = give_warehouse_item ( _h_id, freeSlotId, inventoryStruct ) ;

	SetWarehouseItemID ( playerid, SUB_INV_HOUSE, _h_id, _slot ) ;
	foreach(new i: streamed_players[playerid])
	{
		if ( player_inventory { i } != SUB_INV_HOUSE ) continue ;
		if ( GetPVarInt ( i, "house_id" ) != _h_id ) continue ;
		SetWarehouseItemID ( i, SUB_INV_HOUSE, _h_id, _slot ) ;
	}
		
	format ( query_string, sizeof query_string, "%s разделил(а) в сейфе дома (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _h_id, item_name ( draggedItem ), draggedItem, itemCount ) ;
	WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
	return 1 ;
}

stock set_packet_warehouse_get ( playerid, bool: status, _id, _toId )
{
	if ( ! status )
	{
		new _h_id = GetPVarInt ( playerid, "house_id" ),
			draggedItem = GetHouseInventory ( _h_id, INV_ITEM, _id ),
			draggedItemCount = GetHouseInventory ( _h_id, INV_ITEM_COUNT, _id ),
			query_string [ 144 ] ;

		if ( ! draggedItem ) return false ;
		if ( _h_id < 1 || _h_id > MAX_HOUSES ) return false ;
		
		if ( item_blocked ( playerid, GetUsersInventory ( playerid, INV_ITEM, _toId ) ) )
		{
			send_check_cinfo ( playerid, "В эту ячейку нельзя переместить!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		new _max_slot = item_max_in_slot ( draggedItem ) ;
		if ( _max_slot != -1 && GetUsersInventory ( playerid, INV_ITEM_COUNT, GetInventoryFindItem ( playerid, SUB_INVENTORY, draggedItem ) ) + draggedItemCount > _max_slot )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "Вы не можете переносить более %d шт. выбранного предмета.", _max_slot ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		new USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] ;
		itemStruct = TransferInventoryStructure ( _h_id, SUB_INV_HOUSE, _id ) ;
		new _slot = GiveInventorySlot ( playerid, SUB_INVENTORY, _toId, itemStruct ) ;
		if ( _slot == -1 )
		{
			send_check_cinfo ( playerid, "Выбарнный слот инвентаря не пустой!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		_slot = clear_warehouse_item ( _h_id, draggedItem, draggedItemCount, _id ) ;
		SetWarehouseItemID ( playerid, SUB_INV_HOUSE, _h_id, _slot ) ;
		
		format ( query_string, sizeof query_string, "%s взял(а) из сейфа (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _h_id, item_name ( draggedItem ), draggedItem, draggedItemCount ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != SUB_INV_HOUSE ) continue ;
			if ( GetPVarInt ( i, "house_id" ) != _h_id ) continue ;
			SetWarehouseItemID ( i, SUB_INV_HOUSE, _h_id, _slot ) ;
		}
	}
	else if ( status )
	{
		new _h_id = GetPVarInt ( playerid, "house_id" ), 
			draggedItem = GetHouseInventory ( _h_id, INV_ITEM, _id ), 
			draggedItemCount = GetHouseInventory ( _h_id, INV_ITEM_COUNT, _id ),
			query_string [ 144 ] ;
		if ( _h_id < 1 || _h_id > MAX_HOUSES ) return 1 ;
		
		if ( GetHouseInventory ( _h_id, INV_ITEM_TYPE, _id ) == INVENTORY_TYPE_ACCESSORIES )
			dropped_accessories ( GetHouseInventory ( _h_id, INV_ITEM_ID, _id ) ) ;

		if ( GetHouseInventory ( _h_id, INV_ITEM_TYPE, _id ) == INVENTORY_TYPE_SKINS )
			dropped_skins ( GetHouseInventory ( _h_id, INV_ITEM_ID, _id ) ) ;
		
		format ( query_string, sizeof query_string, "%s выбросил(а) из сейфа (#%d) %s (#%d)", p_info [ playerid ] [ name ], _h_id, item_name ( draggedItem ), draggedItem ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		new _slot = clear_warehouse_item ( _h_id, draggedItem, draggedItemCount, _id ) ;
		SetWarehouseItemID ( playerid, SUB_INV_HOUSE, _h_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != SUB_INV_HOUSE ) continue ;
			if ( GetPVarInt ( i, "house_id" ) != _h_id ) continue ;
			SetWarehouseItemID ( i, SUB_INV_HOUSE, _h_id, _slot ) ;
		}
	}
	return 1 ;
}

stock give_warehouse_item ( houseId, slotId, const USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] )
{
	if ( slotId == -1 ) slotId = GiveInventory ( houseId, SUB_INV_HOUSE, itemStruct ) ;
	else GiveInventorySlot ( houseId, SUB_INV_HOUSE, slotId, itemStruct ) ;
	return slotId ;
}

stock clear_warehouse_item ( houseId, modelId, modelCount, slotId = -1 )
{
	if ( slotId == -1 ) slotId = ClearInventory ( houseId, SUB_INV_HOUSE, modelId, modelCount ) ;
	else slotId = ClearInventorySlot ( houseId, SUB_INV_HOUSE, slotId, modelId, modelCount ) ;
	return slotId ;
}

stock dragged_warehouse_item ( playerid, houseId, moveFromIndex, moveToIndex )
{
	new draggedItem = GetHouseInventory ( houseId, INV_ITEM, moveFromIndex ),
		draggedItemCount = GetHouseInventory ( houseId, INV_ITEM_COUNT, moveFromIndex ),
		droppedItem = GetHouseInventory ( houseId, INV_ITEM, moveToIndex ),
		droppedItemCount = GetHouseInventory ( houseId, INV_ITEM_COUNT, moveToIndex ),
		USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ],
		USERS_INVENTORY_STRUCT: toInventory [ _:INV_STRUCTURE_MAX ] ;

	moveInventory = TransferInventoryStructure ( houseId, SUB_INV_HOUSE, moveFromIndex ) ;
	toInventory = TransferInventoryStructure ( houseId, SUB_INV_HOUSE, moveToIndex ) ;

	if ( droppedItem > 0 )
	{
		if ( draggedItem == droppedItem )
		{
			clear_warehouse_item ( houseId, draggedItem, draggedItemCount, moveFromIndex ) ;
			give_warehouse_item ( houseId, moveToIndex, moveInventory ) ;

			foreach(new i: streamed_players[playerid])
			{
				if ( player_inventory { i } != SUB_INV_HOUSE ) continue ;
				if ( GetPVarInt ( i, "house_id" ) != houseId ) continue ;

				SetWarehouseItemID ( i, SUB_INV_HOUSE, houseId, moveFromIndex ) ;
				SetWarehouseItemID ( i, SUB_INV_HOUSE, houseId, moveToIndex ) ;
			}
			return 1 ;
		}

		clear_warehouse_item ( houseId, draggedItem, draggedItemCount, moveFromIndex ) ;
		clear_warehouse_item ( houseId, droppedItem, droppedItemCount, moveToIndex ) ;
		
		give_warehouse_item ( houseId, moveToIndex, moveInventory ) ;
		give_warehouse_item ( houseId, moveFromIndex, toInventory ) ;
	}
	else
	{
		clear_warehouse_item ( houseId, draggedItem, draggedItemCount, moveFromIndex ) ;
		give_warehouse_item ( houseId, moveToIndex, moveInventory ) ;
	}

	foreach(new i: streamed_players[playerid])
	{
		if ( player_inventory { i } != SUB_INV_HOUSE ) continue ;
		if ( GetPVarInt ( i, "house_id" ) != houseId ) continue ;

		SetWarehouseItemID ( i, SUB_INV_HOUSE, houseId, moveFromIndex ) ;
		SetWarehouseItemID ( i, SUB_INV_HOUSE, houseId, moveToIndex ) ;
	}
	return 1 ;
}

stock set_packet_family_put ( playerid, _id, _toId )
{
	new _fam_id = p_info [ playerid ] [ family ],
		draggedItem = GetUsersInventory ( playerid, INV_ITEM, _id ),
		draggedItemCount = GetUsersInventory ( playerid, INV_ITEM_COUNT, _id ) ;
	if ( _fam_id < 1 ) return 1 ;

	if ( item_blocked ( playerid, draggedItem, 1 ) )
	{
		send_check_cinfo ( playerid, "Выбранный предмет нельзя переместить!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
	inventoryStruct = TransferInventoryStructure ( playerid, SUB_INVENTORY, _id ) ;
	inventoryStruct [ _:INV_ITEM ] = draggedItem ;
	inventoryStruct [ _:INV_ITEM_COUNT ] = draggedItemCount ;
	new _slot = give_family_item ( _fam_id, _toId, inventoryStruct ) ;
	if ( _slot == -1 )
	{
		send_check_cinfo ( playerid, "В семье нет свободного места!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}
		
	new query_string [ 144 ] ;
	format ( query_string, sizeof query_string, "%s положил(а) в семью (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _fam_id, item_name ( draggedItem ), draggedItem, draggedItemCount ) ;
	write_family ( playerid, _fam_id, TYPE_LOG_INVENTORY, query_string ) ;
		
	format ( query_string, sizeof ( query_string ), "{%s}[FAM] %s %s положил(а) на склад %s (%d шт.).", family_info [ _fam_id - 1 ] [ fam_chat_color ], family_rank [ _fam_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], item_name ( draggedItem ), draggedItemCount ) ;
    family_message ( _fam_id, col_gray, query_string ) ;
		
	clear_inventory_slot ( playerid, draggedItem, draggedItemCount, _id ) ;
	updateInventorySlot ( playerid, _id ) ;
	
	foreach(new i: family_players[_fam_id])
	{
		if ( player_inventory { i } != SUB_INV_FAMILY ) continue ;
		SetWarehouseItemID ( i, SUB_INV_FAMILY, _fam_id, _slot ) ;
	}
	return 1 ;
}

stock set_packet_family_divide ( playerid, _id, itemCount )
{
	new _fam_id = p_info [ playerid ] [ family ], 
		draggedItem = GetFamilyInventory ( _fam_id, INV_ITEM, _id ), 
		query_string [ 144 ] ;

	if ( item_blocked ( playerid, draggedItem ) )
	{
		send_check_cinfo ( playerid, "Вы не можете разделить выбранный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new freeSlotId = GetInventoryFreeSlot ( _fam_id, SUB_INV_FAMILY ) ;
	if ( freeSlotId == -1 )
	{
		send_check_cinfo ( playerid, "У Вас нет свободного места на складе.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new _slot = clear_family_item ( _fam_id, draggedItem, itemCount, _id ) ;
	foreach(new i: family_players[_fam_id])
	{
		if ( player_inventory { i } != SUB_INV_FAMILY ) continue ;
		SetWarehouseItemID ( i, SUB_INV_FAMILY, _fam_id, _slot ) ;
	}

	new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
	inventoryStruct = TransferInventoryStructure ( _fam_id, SUB_INV_FAMILY, _id ) ;
	inventoryStruct [ _:INV_ITEM ] = draggedItem ;
	inventoryStruct [ _:INV_ITEM_COUNT ] = itemCount ;
	_slot = give_family_item ( _fam_id, freeSlotId, inventoryStruct ) ;
	foreach(new i: family_players[_fam_id])
	{
		if ( player_inventory { i } != SUB_INV_FAMILY ) continue ;
		SetWarehouseItemID ( i, SUB_INV_FAMILY, _fam_id, _slot ) ;
	}
		
	format ( query_string, sizeof query_string, "%s разделил(а) на складе семьи (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _fam_id, item_name ( draggedItem ), draggedItem, itemCount ) ;
	write_family ( playerid, _fam_id, TYPE_LOG_INVENTORY, query_string ) ;
	return 1 ;
}

stock set_packet_family_use ( playerid, _id )
{
	new _fam_id = p_info [ playerid ] [ family ],
		draggedItem = GetFamilyInventory ( _fam_id, INV_ITEM, _id ),
		query_string [ 144 ] ;

	if ( 1 > GetFamilyInventory ( _fam_id, INV_ITEM_COUNT, _id ) )
	{
		send_check_cinfo ( playerid, "В семье нет такого количества!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}
		
	if ( item_not_get ( draggedItem ) )
	{
		new bool: _warehouse = false ;
		switch ( draggedItem )
		{
			case 164: if ( GetInventoryFindItem ( _fam_id, SUB_INV_FAMILY, 348 ) > 1000 ) _warehouse = true ;
			case 165: if ( GetInventoryFindItem ( _fam_id, SUB_INV_FAMILY, 355 ) > 1000 ) _warehouse = true ;
			case 166: if ( GetInventoryFindItem ( _fam_id, SUB_INV_FAMILY, 356 ) > 1000 ) _warehouse = true ;
			case 167: if ( GetInventoryFindItem ( _fam_id, SUB_INV_FAMILY, 154 ) > 10000 ) _warehouse = true ;
			case 168: if ( GetInventoryFindItem ( _fam_id, SUB_INV_FAMILY, 1244 ) > 1000 ) _warehouse = true ;
			case 169: if ( GetInventoryFindItem ( _fam_id, SUB_INV_FAMILY, 347 ) > 1000 ) _warehouse = true ;
			case 170: if ( GetInventoryFindItem ( _fam_id, SUB_INV_FAMILY, 349 ) > 1000 ) _warehouse = true ;
			case 172: if ( GetInventoryFindItem ( _fam_id, SUB_INV_FAMILY, 145 ) > 1000 ) _warehouse = true ;
		}
		if ( _warehouse )
		{
			send_check_cinfo ( playerid, "Вы не можете открыть выбранный ящик!\nНа Вашем складе слишком много данного вида вооружения.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		new _slot = clear_family_item ( _fam_id, draggedItem, 1, _id ) ;	
		format ( query_string, sizeof query_string, "%s открыл(а) ящик (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _fam_id, item_name ( draggedItem ), draggedItem, 1 ) ;
		write_family ( playerid, _fam_id, TYPE_LOG_INVENTORY, query_string ) ;
			
		format ( query_string, sizeof ( query_string ), "{%s}[FAM] %s %s открыл(а) ящик %s (1 шт.).", family_info [ _fam_id - 1 ] [ fam_chat_color ], family_rank [ _fam_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], item_name ( draggedItem ) ) ;
		family_message ( _fam_id, col_gray, query_string ) ;

		foreach(new i: family_players[_fam_id])
		{
			if ( player_inventory { i } != SUB_INV_FAMILY ) continue ;
			SetWarehouseItemID ( i, SUB_INV_FAMILY, _fam_id, _slot ) ;
		}
			
		_slot = -1 ;

		new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
		inventoryStruct [ _:INV_ITEM_TYPE ] = GetFamilyInventory ( _fam_id, INV_ITEM_TYPE, _id ) ;
		format ( inventoryStruct [ _:INV_ITEM_REGION ], 12, "%s", GetFamilyInventory ( _fam_id, INV_ITEM_REGION, _id ) ) ;
		format ( inventoryStruct [ _:INV_ITEM_PLATE ], 12, "%s", GetFamilyInventory ( _fam_id, INV_ITEM_PLATE, _id ) ) ;
		inventoryStruct [ _:INV_ITEM_PLATE_TYPE ] = GetFamilyInventory ( _fam_id, INV_ITEM_PLATE_TYPE, _id ) ;
		inventoryStruct [ _:INV_ITEM_GIVE_DATE ] = 0 ;
		inventoryStruct [ _:INV_ITEM_ID ] = GetFamilyInventory ( _fam_id, INV_ITEM_ID, _id ) ;
		inventoryStruct [ _:INV_ITEM_DATE ] = GetFamilyInventory ( _fam_id, INV_ITEM_DATE, _id ) ;
		switch ( draggedItem )
		{
			case 164:
			{
				inventoryStruct [ _:INV_ITEM ] = 348 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
				_slot = give_family_item ( _fam_id, -1, inventoryStruct ) ;
			}
			case 165:
			{
				inventoryStruct [ _:INV_ITEM ] = 355 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
				_slot = give_family_item ( _fam_id, -1, inventoryStruct ) ;
			}
			case 166:
			{
				inventoryStruct [ _:INV_ITEM ] = 356 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
				_slot = give_family_item ( _fam_id, -1, inventoryStruct ) ;
			}
			case 167:
			{
				inventoryStruct [ _:INV_ITEM ] = 154 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 100 ;
				_slot = give_family_item ( _fam_id, -1, inventoryStruct ) ;
			}
			case 168:
			{
				inventoryStruct [ _:INV_ITEM ] = 1244 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 3 ;
				_slot = give_family_item ( _fam_id, -1, inventoryStruct ) ;
			}
			case 169:
			{
				inventoryStruct [ _:INV_ITEM ] = 347 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
				_slot = give_family_item ( _fam_id, -1, inventoryStruct ) ;
			}
			case 170:
			{
				inventoryStruct [ _:INV_ITEM ] = 349 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
				_slot = give_family_item ( _fam_id, -1, inventoryStruct ) ;
			}
			case 172:
			{
				inventoryStruct [ _:INV_ITEM ] = 145 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
				_slot = give_family_item ( _fam_id, -1, inventoryStruct ) ;
			}
		}

		if ( _slot != -1 )
		{
			foreach(new i: family_players[_fam_id])
			{
				if ( player_inventory { i } != SUB_INV_FAMILY ) continue ;
				SetWarehouseItemID ( i, SUB_INV_FAMILY, _fam_id, _slot ) ;
			}
		}
	}
	else
	{
		send_check_cinfo ( playerid, "С этим предметом нельзя взаимодействовать со склада.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
	}
	return true ;
}

stock set_packet_family_get ( playerid, bool: status, _id, _toId )
{
	if ( ! status )
	{
		new _fam_id = p_info [ playerid ] [ family ],
			_dragged_slot = GetFamilyInventory ( _fam_id, INV_ITEM, _id ),
			_dragged_slot_count = GetFamilyInventory ( _fam_id, INV_ITEM_COUNT, _id ),
			query_string [ 144 ] ;
			
		if ( ! _dragged_slot ) return false ;
		if ( _fam_id < 1 ) return false ;
		
		if ( item_blocked ( playerid, GetUsersInventory ( playerid, INV_ITEM, _toId ) ) )
		{
			send_check_cinfo ( playerid, "В эту ячейку нельзя переместить!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		if ( item_not_get ( _dragged_slot ) )
		{
			send_check_cinfo ( playerid, "Вы не можете взять данный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		new _max_slot = item_max_in_slot ( _dragged_slot ) ;
		if ( _max_slot != -1 && GetUsersInventory ( playerid, INV_ITEM_COUNT, GetInventoryFindItem ( playerid, SUB_INVENTORY, _dragged_slot ) ) + _dragged_slot_count > _max_slot )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "Вы не можете переносить более %d шт. выбранного предмета.", _max_slot ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		format ( query_string, sizeof query_string, "%s взял(а) из семьи (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _fam_id, item_name ( _dragged_slot ), _dragged_slot, _dragged_slot_count ) ;
		write_family ( playerid, _fam_id, TYPE_LOG_INVENTORY, query_string ) ;
		
		format ( query_string, sizeof ( query_string ), "{%s}[FAM] %s %s взял(а) со склада %s (%d шт.).", family_info [ _fam_id - 1 ] [ fam_chat_color ], family_rank [ _fam_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], item_name ( _dragged_slot ), _dragged_slot_count ) ;
    	family_message ( _fam_id, col_gray, query_string ) ;
		
		new USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] ;
		itemStruct = TransferInventoryStructure ( _fam_id, SUB_INV_FAMILY, _id ) ;
		new _slot = GiveInventorySlot ( playerid, SUB_INVENTORY, _toId, itemStruct ) ;
		if ( _slot == -1 )
		{
			send_check_cinfo ( playerid, "Выбарнный слот инвентаря не пустой!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		_slot = clear_family_item ( _fam_id, _dragged_slot, _dragged_slot_count, _id ) ;
		foreach(new i: family_players[_fam_id])
		{
			if ( player_inventory { i } != SUB_INV_FAMILY ) continue ;
			SetWarehouseItemID ( i, SUB_INV_FAMILY, _fam_id, _slot ) ;
		}
	}
	else if ( status )
	{
		new _fam_id = p_info [ playerid ] [ family ],
			_dragged_slot = GetFamilyInventory ( _fam_id, INV_ITEM, _id ),
			_dragged_slot_count = GetFamilyInventory ( _fam_id, INV_ITEM_COUNT, _id ),
			query_string [ 144 ] ;
			
		if ( _fam_id < 1 ) return 1 ;
		
		if ( GetFamilyInventory ( _fam_id, INV_ITEM_TYPE, _id ) == INVENTORY_TYPE_ACCESSORIES )
			dropped_accessories ( GetFamilyInventory ( _fam_id, INV_ITEM_ID, _id ) ) ;

		if ( GetFamilyInventory ( _fam_id, INV_ITEM_TYPE, _id ) == INVENTORY_TYPE_SKINS )
			dropped_skins ( GetFamilyInventory ( _fam_id, INV_ITEM_ID, _id ) ) ;
		
		format ( query_string, sizeof query_string, "%s выбросил(а) из семьи (#%d) %s (#%d)", p_info [ playerid ] [ name ], _fam_id, item_name ( _dragged_slot ), _dragged_slot ) ;
		write_family ( playerid, _fam_id, TYPE_LOG_INVENTORY, query_string ) ;
		
		format ( query_string, sizeof ( query_string ), "{%s}[FAM] %s %s выбросил(а) со склада %s.", family_info [ _fam_id - 1 ] [ fam_chat_color ], family_rank [ _fam_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], item_name ( _dragged_slot ) ) ;
    	family_message ( _fam_id, col_gray, query_string ) ;
		
		new _slot = clear_family_item ( _fam_id, _dragged_slot, _dragged_slot_count, _id ) ;
		foreach(new i: family_players[_fam_id])
		{
			if ( player_inventory { i } != SUB_INV_FAMILY ) continue ;
			SetWarehouseItemID ( i, SUB_INV_FAMILY, _fam_id, _slot ) ;
		}
	}
	return 1 ;
}

stock give_family_item ( familyId, slotId, const USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] )
{
	if ( slotId == -1 ) slotId = GiveInventory ( familyId, SUB_INV_FAMILY, itemStruct ) ;
	else GiveInventorySlot ( familyId, SUB_INV_FAMILY, slotId, itemStruct ) ;
	return slotId ;
}

stock clear_family_item ( familyId, modelId, modelCount, slotId = -1 )
{
	if ( slotId == -1 ) slotId = ClearInventory ( familyId, SUB_INV_FAMILY, modelId, modelCount ) ;
	else slotId = ClearInventorySlot ( familyId, SUB_INV_FAMILY, slotId, modelId, modelCount ) ;
	return slotId ;
}

stock dragged_family_item ( familyId, moveFromIndex, moveToIndex )
{
	new draggedItem = GetFamilyInventory ( familyId, INV_ITEM, moveFromIndex ),
		draggedItemCount = GetFamilyInventory ( familyId, INV_ITEM_COUNT, moveFromIndex ),
		droppedItem = GetFamilyInventory ( familyId, INV_ITEM, moveToIndex ),
		droppedItemCount = GetFamilyInventory ( familyId, INV_ITEM_COUNT, moveToIndex ),
		USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ],
		USERS_INVENTORY_STRUCT: toInventory [ _:INV_STRUCTURE_MAX ] ;

	moveInventory = TransferInventoryStructure ( familyId, SUB_INV_FAMILY, moveFromIndex ) ;
	toInventory = TransferInventoryStructure ( familyId, SUB_INV_FAMILY, moveToIndex ) ;

	if ( droppedItem > 0 )
	{
		if ( draggedItem == droppedItem )
		{
			clear_family_item ( familyId, draggedItem, draggedItemCount, moveFromIndex ) ;
			give_family_item ( familyId, moveToIndex, moveInventory ) ;

			foreach(new i: family_players[familyId])
			{
				if ( player_inventory { i } != SUB_INV_FAMILY ) continue ;

				SetWarehouseItemID ( i, SUB_INV_FAMILY, familyId, moveFromIndex ) ;
				SetWarehouseItemID ( i, SUB_INV_FAMILY, familyId, moveToIndex ) ;
			}
			return 1 ;
		}

		clear_family_item ( familyId, draggedItem, draggedItemCount, moveFromIndex ) ;
		clear_family_item ( familyId, droppedItem, droppedItemCount, moveToIndex ) ;
		
		give_family_item ( familyId, moveToIndex, moveInventory ) ;
		give_family_item ( familyId, moveFromIndex, toInventory ) ;
	}
	else
	{
		clear_family_item ( familyId, draggedItem, draggedItemCount, moveFromIndex ) ;
		give_family_item ( familyId, moveToIndex, moveInventory ) ;
	}

	foreach(new i: family_players[familyId])
	{
		if ( player_inventory { i } != SUB_INV_FAMILY ) continue ;

		SetWarehouseItemID ( i, SUB_INV_FAMILY, familyId, moveFromIndex ) ;
		SetWarehouseItemID ( i, SUB_INV_FAMILY, familyId, moveToIndex ) ;
	}
	return 1 ;
}

stock set_packet_fraction_put ( playerid, _id, _toId )
{
	new _f_id = p_info [ playerid ] [ member ],
		draggedItem = GetUsersInventory ( playerid, INV_ITEM, _id ),
		draggedItemCount = GetUsersInventory ( playerid, INV_ITEM_COUNT, _id ) ;
	if ( _f_id < 1 ) return 1 ;

	if ( item_blocked ( playerid, draggedItem, 1 ) )
	{
		send_check_cinfo ( playerid, "Выбранный предмет нельзя переместить!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}
		
	if ( ! item_not_put ( draggedItem ) )
	{
		send_check_cinfo ( playerid, "Выбранный предмет нельзя положить на склад организации!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
	inventoryStruct = TransferInventoryStructure ( playerid, SUB_INVENTORY, _id ) ;
	inventoryStruct [ _:INV_ITEM ] = draggedItem ;
	inventoryStruct [ _:INV_ITEM_COUNT ] = draggedItemCount ;
	new _slot = give_fraction_item ( _f_id, _toId, inventoryStruct ) ;
	if ( _slot == -1 )
	{
		send_check_cinfo ( playerid, "В организации нет свободного места!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}
		
	new query_string [ 144 ] ;
	format ( query_string, sizeof query_string, "%s положил(а) в организацию (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _f_id, item_name ( draggedItem ), draggedItem, draggedItemCount ) ;
	write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
		
	if ( gang_player ( playerid ) || mafia_player ( playerid ) ) format ( query_string, sizeof ( query_string ), "[F] %s %s [id %d] положил(а) на склад {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, draggedItemCount, item_name ( draggedItem ) ) ;
	else format ( query_string, sizeof ( query_string ), "[R] %s %s [id %d] положил(а) на склад {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, draggedItemCount, item_name ( draggedItem ) ) ;
	fraction_message ( _f_id, col_lblue, query_string ) ;
		
	clear_inventory_slot ( playerid, draggedItem, draggedItemCount, _id ) ;
	updateInventorySlot ( playerid, _id ) ;

	foreach(new i: fraction_players[_f_id])
	{
		if ( player_inventory { i } != SUB_INV_FRACTION ) continue ;
		SetWarehouseItemID ( i, SUB_INV_FRACTION, _f_id, _slot ) ;
	}
	return 1 ;
}

stock set_packet_fraction_divide ( playerid, _id, itemCount )
{
	new _f_id = p_info [ playerid ] [ member ], 
		draggedItem = GetFractionInventory ( _f_id, INV_ITEM, _id ),
		query_string [ 144 ] ;

	if ( item_blocked ( playerid, draggedItem ) )
	{
		send_check_cinfo ( playerid, "Вы не можете разделить выбранный предмет!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new freeSlotId = GetInventoryFreeSlot ( _f_id, SUB_INV_FRACTION ) ;
	if ( freeSlotId == -1 )
	{
		send_check_cinfo ( playerid, "У Вас нет свободного места на складе.", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new _slot = clear_fraction_item ( _f_id, draggedItem, itemCount, _id ) ;
	foreach(new i: fraction_players[_f_id])
	{
		if ( player_inventory { i } != SUB_INV_FRACTION ) continue ;
		SetWarehouseItemID ( i, SUB_INV_FRACTION, _f_id, _slot ) ;
	}

	new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
	inventoryStruct = TransferInventoryStructure ( _f_id, SUB_INV_FRACTION, _id ) ;
	inventoryStruct [ _:INV_ITEM ] = draggedItem ;
	inventoryStruct [ _:INV_ITEM_COUNT ] = itemCount ;
	_slot = give_fraction_item ( _f_id, freeSlotId, inventoryStruct ) ;
	foreach(new i: fraction_players[_f_id])
	{
		if ( player_inventory { i } != SUB_INV_FRACTION ) continue ;
		SetWarehouseItemID ( i, SUB_INV_FRACTION, _f_id, _slot ) ;
	}
		
	format ( query_string, sizeof query_string, "%s разделил(а) на складе организации (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _f_id, item_name ( draggedItem ), draggedItem, itemCount ) ;
	write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
	return 1 ;
}

stock set_packet_fraction_use ( playerid, _id )
{
	new _f_id = p_info [ playerid ] [ member ],
		_f_slot = GetFractionInventory ( _f_id, INV_ITEM, _id ),
		query_string [ 144 ] ;

	if ( item_not_get ( _f_slot ) )
	{
		new bool: _warehouse = false ;
		switch ( _f_slot )
		{
			case 164: if ( GetInventoryFindItem ( _f_id, SUB_INV_FRACTION, 348 ) > 1000 ) _warehouse = true ;
			case 165: if ( GetInventoryFindItem ( _f_id, SUB_INV_FRACTION, 355 ) > 1000 ) _warehouse = true ;
			case 166: if ( GetInventoryFindItem ( _f_id, SUB_INV_FRACTION, 356 ) > 1000 ) _warehouse = true ;
			case 167: if ( GetInventoryFindItem ( _f_id, SUB_INV_FRACTION, 154 ) > 10000 ) _warehouse = true ;
			case 168: if ( GetInventoryFindItem ( _f_id, SUB_INV_FRACTION, 1244 ) > 1000 ) _warehouse = true ;
			case 169: if ( GetInventoryFindItem ( _f_id, SUB_INV_FRACTION, 347 ) > 1000 ) _warehouse = true ;
			case 170: if ( GetInventoryFindItem ( _f_id, SUB_INV_FRACTION, 349 ) > 1000 ) _warehouse = true ;
			case 172: if ( GetInventoryFindItem ( _f_id, SUB_INV_FRACTION, 145 ) > 1000 ) _warehouse = true ;
		}
			
		if ( _warehouse )
		{
			send_check_cinfo ( playerid, "Вы не можете открыть выбранный ящик!\nНа Вашем складе слишком много данного вида вооружения.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		new _slot = clear_fraction_item ( _f_id, _f_slot, 1, _id ) ;
		format ( query_string, sizeof query_string, "%s открыл(а) ящик (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _f_id, item_name ( _f_slot ), _f_slot, 1 ) ;
		write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;

		if ( gang_player ( playerid ) || mafia_player ( playerid ) ) format ( query_string, sizeof ( query_string ), "[F] %s %s [id %d] открыл(а) ящик {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, 1, item_name ( _f_slot ) ) ;
		else format ( query_string, sizeof ( query_string ), "[R] %s %s [id %d] открыл(а) ящик {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, 1, item_name ( _f_slot ) ) ;
		fraction_message ( _f_id, col_lblue, query_string ) ;

		foreach(new i: fraction_players[_f_id])
		{
			if ( player_inventory { i } != SUB_INV_FRACTION ) continue ;
			SetWarehouseItemID ( i, SUB_INV_FRACTION, _f_id, _slot ) ;
		}

		_slot = -1 ;

		new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
		inventoryStruct [ _:INV_ITEM_TYPE ] = GetFractionInventory ( _f_id, INV_ITEM_TYPE, _id ) ;
		format ( inventoryStruct [ _:INV_ITEM_REGION ], 12, "%s", GetFractionInventory ( _f_id, INV_ITEM_REGION, _id ) ) ;
		format ( inventoryStruct [ _:INV_ITEM_PLATE ], 12, "%s", GetFractionInventory ( _f_id, INV_ITEM_PLATE, _id ) ) ;
		inventoryStruct [ _:INV_ITEM_PLATE_TYPE ] = GetFractionInventory ( _f_id, INV_ITEM_PLATE_TYPE, _id ) ;
		inventoryStruct [ _:INV_ITEM_GIVE_DATE ] = 0 ;
		inventoryStruct [ _:INV_ITEM_ID ] = GetFractionInventory ( _f_id, INV_ITEM_ID, _id ) ;
		inventoryStruct [ _:INV_ITEM_DATE ] = GetFractionInventory ( _f_id, INV_ITEM_DATE, _id ) ;
		switch ( _f_slot )
		{
			case 164:
			{
				inventoryStruct [ _:INV_ITEM ] = 348 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
				_slot = give_fraction_item ( _f_id, -1, inventoryStruct ) ;
			}
			case 165:
			{
				inventoryStruct [ _:INV_ITEM ] = 355 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
				_slot = give_fraction_item ( _f_id, -1, inventoryStruct ) ;
			}
			case 166:
			{
				inventoryStruct [ _:INV_ITEM ] = 356 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
				_slot = give_fraction_item ( _f_id, -1, inventoryStruct ) ;
			}
			case 167:
			{
				inventoryStruct [ _:INV_ITEM ] = 154 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 100 ;
				_slot = give_fraction_item ( _f_id, -1, inventoryStruct ) ;
			}
			case 168:
			{
				inventoryStruct [ _:INV_ITEM ] = 1244 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 3 ;
				_slot = give_fraction_item ( _f_id, -1, inventoryStruct ) ;
			}
			case 169:
			{
				inventoryStruct [ _:INV_ITEM ] = 347 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
				_slot = give_fraction_item ( _f_id, -1, inventoryStruct ) ;
			}
			case 170:
			{
				inventoryStruct [ _:INV_ITEM ] = 349 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
				_slot = give_fraction_item ( _f_id, -1, inventoryStruct ) ;
			}
			case 172:
			{
				inventoryStruct [ _:INV_ITEM ] = 145 ;
				inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
				_slot = give_fraction_item ( _f_id, -1, inventoryStruct ) ;
			}
		}

		if ( _slot != -1 )
		{
			foreach(new i: fraction_players[_f_id])
			{
				if ( player_inventory { i } != SUB_INV_FRACTION ) continue ;
				SetWarehouseItemID ( i, SUB_INV_FRACTION, _f_id, _slot ) ;
			}
		}
	}
	else
	{
		send_check_cinfo ( playerid, "С этим предметом нельзя взаимодействовать со склада.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
	}
	return true ;
}

stock set_packet_fraction_get ( playerid, bool: status, _id, _toId )
{
	if ( ! status )
	{
		new _f_id = p_info [ playerid ] [ member ],
			_dragged_slot = GetFractionInventory ( _f_id, INV_ITEM, _id ),
			_dragged_slot_count = 0,
			_dragged_type = GetFractionInventory ( _f_id, INV_ITEM_TYPE, _id ),
			_dragged_id = GetFractionInventory ( _f_id, INV_ITEM_ID, _id ),
			_dragged_slot_date = GetElapsedTime ( GetFractionInventory ( _f_id, INV_ITEM_DATE, _id ), gettime ( ), CONVERT_TIME_TO_DAYS ),
			query_string [ 144 ] ;
			
		if ( ! _dragged_slot ) return false ;
		if ( _f_id < 1 ) return false ;
		
		if ( item_blocked ( playerid, GetUsersInventory ( playerid, INV_ITEM, _toId ) ) )
		{
			send_check_cinfo ( playerid, "В эту ячейку нельзя переместить!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		if ( p_t_info [ playerid ] [ slot_cooldown ] [ _id ] > gettime ( ) )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "Выбранный предмет можно будет взять через %d сек.", p_t_info [ playerid ] [ slot_cooldown ] [ _id ] - gettime ( ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		else p_t_info [ playerid ] [ slot_limit ] [ _id ] = 0 ;
		
		if ( _dragged_slot != 153 && _dragged_slot != 154 && _dragged_slot != 155 )
		{
			if ( p_t_info [ playerid ] [ slot_limit ] [ _id ] > 1 )
			{
				send_check_cinfo ( playerid, "Лимит на предмет составляет 1 шт.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( ! gang_player ( playerid ) && ! mafia_player ( playerid ) )
			{
				_dragged_slot_count = 1 ;
				p_t_info [ playerid ] [ slot_cooldown ] [ _id ] = gettime ( ) + 600 ;
			}
			else
			{
				_dragged_slot_count = 1 ;
				p_t_info [ playerid ] [ slot_cooldown ] [ _id ] = gettime ( ) + 300 ;
			}
		}
		else
		{
			if ( p_t_info [ playerid ] [ slot_limit ] [ _id ] > 500 )
			{
				send_check_cinfo ( playerid, "Лимит на патроны составляет 500 шт.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			_dragged_slot_count = 50 ;
		}

		new _slot = clear_fraction_item ( _f_id, _dragged_slot, _dragged_slot_count, _id ) ;
		if ( item_not_get ( _dragged_slot ) )
		{
			if ( box_submarine [ playerid ] > 0 )
			{
				send_check_cinfo ( playerid, "У Вас уже есть ящик в руках. Отнесите и положите его в фургон!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_WARNING, "", "" ) ;
				return 1 ;
			}

			format ( query_string, sizeof query_string, "%s взял(а) из организации (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _f_id, item_name ( _dragged_slot ), _dragged_slot, _dragged_slot_count ) ;
			write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
			
			send_check_cinfo ( playerid, "Отнесите ящик в фургон!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_WARNING, "", "" ) ;
			
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
			SetPlayerAttachedObject ( playerid, 0, 3013, 6,0.0,0.10,-0.2, -110.0,0.0,78.0 ) ;
			
			have_box [ playerid ] = true ;
            if ( _dragged_slot == 164 ) box_submarine [ playerid ] = 1 ;
			else if ( _dragged_slot == 165 ) box_submarine [ playerid ] = 2 ;
			else if ( _dragged_slot == 166 ) box_submarine [ playerid ] = 3 ;
			else if ( _dragged_slot == 167 ) box_submarine [ playerid ] = 4 ;
			else if ( _dragged_slot == 168 ) box_submarine [ playerid ] = 5 ;
			else if ( _dragged_slot == 169 ) box_submarine [ playerid ] = 6 ;
			else if ( _dragged_slot == 170 ) box_submarine [ playerid ] = 7 ;
			else if ( _dragged_slot == 172 ) box_submarine [ playerid ] = 8 ;
            
            new scm_string [ 100 ] ;
            format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы взяли '{"#cGN"}%s{"#cWH"}'. Отнесите и положите его в фургон.", item_name ( _dragged_slot ) ) ;
            SendClientMessage ( playerid, col_white, scm_string ) ;

			ClearAnimations ( playerid ) ;
			p_t_info [ playerid ] [ p_animation ] = true ;
		    ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
			
			show_inventory_ptd ( playerid, false ) ;
		}
		else
		{
			if ( _dragged_slot_count > GetFractionInventory ( _f_id, INV_ITEM_COUNT, _id ) )
			{
				send_check_cinfo ( playerid, "На складе организации недостаточно выбранного предмета!", 0, 3, CINFO_INVENTORY_ID, PICTURE_INFO_WARNING, "", "" ) ;
				return 1 ;
			}

			new _max_slot = item_max_in_slot ( _dragged_slot ) ;
			if ( _max_slot != -1 && GetUsersInventory ( playerid, INV_ITEM_COUNT, GetInventoryFindItem ( playerid, SUB_INVENTORY, _dragged_slot ) ) + _dragged_slot_count > _max_slot )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 100, "Вы не можете переносить более %d шт. выбранного предмета.", _max_slot ) ;
				send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			p_t_info [ playerid ] [ slot_limit ] [ _id ] += _dragged_slot_count ;
			
			if ( p_t_info [ playerid ] [ slot_limit ] [ _id ] >= 500 )
			{
				if ( ! gang_player ( playerid ) && ! mafia_player ( playerid ) ) p_t_info [ playerid ] [ slot_cooldown ] [ _id ] = gettime ( ) + 300 ;
				else p_t_info [ playerid ] [ slot_cooldown ] [ _id ] = gettime ( ) + 150 ;
			}
			
			format ( query_string, sizeof query_string, "%s взял(а) из организации (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _f_id, item_name ( _dragged_slot ), _dragged_slot, _dragged_slot_count ) ;
			write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
			
			if ( gang_player ( playerid ) || mafia_player ( playerid ) ) format ( query_string, sizeof ( query_string ), "[F] %s %s [id %d] взял(а) со склада {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, _dragged_slot_count, item_name ( _dragged_slot ) ) ;
			else format ( query_string, sizeof ( query_string ), "[R] %s %s [id %d] взял(а) со склада {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, _dragged_slot_count, item_name ( _dragged_slot ) ) ;
			fraction_message ( _f_id, col_lblue, query_string ) ;

			give_inventory_slot (
				playerid, 
				_dragged_slot, 
				_dragged_slot_count, 
				_dragged_type, 
				"", 
				"",
				NUMBERPLATE_TYPE_NONE,
				_dragged_id,
				_toId, 
				_dragged_slot_date 
			) ;

			foreach(new i: fraction_players[_f_id])
			{
				if ( player_inventory { i } != SUB_INV_FRACTION ) continue ;
				SetWarehouseItemID ( i, SUB_INV_FRACTION, _f_id, _slot ) ;
			}
		}
	}
	else if ( status )
	{
		new _f_id = p_info [ playerid ] [ member ],
			_dragged_slot = GetFractionInventory ( _f_id, INV_ITEM, _id ),
			_dragged_slot_count = GetFractionInventory ( _f_id, INV_ITEM_COUNT, _id ),
			query_string [ 144 ] ;
		if ( _f_id < 1 ) return 1 ;
		
		if ( admin_info [ playerid ] [ admin ] < 8 )
		{
			send_check_cinfo ( playerid, "Выбросить может только главный администратор!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		if ( GetFractionInventory ( _f_id, INV_ITEM_TYPE, _id ) == INVENTORY_TYPE_ACCESSORIES )
			dropped_accessories ( GetFractionInventory ( _f_id, INV_ITEM_ID, _id ) ) ;

		if ( GetFractionInventory ( _f_id, INV_ITEM_TYPE, _id ) == INVENTORY_TYPE_SKINS )
			dropped_skins ( GetFractionInventory ( _f_id, INV_ITEM_ID, _id ) ) ;
		
		format ( query_string, sizeof query_string, "%s выбросил(а) из организации (#%d) %s (#%d)", p_info [ playerid ] [ name ], _f_id, item_name ( _dragged_slot ), _dragged_slot ) ;
		write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
		
		new _slot = clear_fraction_item ( _f_id, _dragged_slot, _dragged_slot_count, _id ) ;
		foreach(new i: fraction_players[_f_id])
		{
			if ( player_inventory { i } != SUB_INV_FRACTION ) continue ;
			SetWarehouseItemID ( i, SUB_INV_FRACTION, _f_id, _slot ) ;
		}
	}
	return 1 ;
}

stock give_fraction_item ( fId, slotId, const USERS_INVENTORY_STRUCT: itemStruct [ _:INV_STRUCTURE_MAX ] )
{
	if ( slotId == -1 ) slotId = GiveInventory ( fId, SUB_INV_FRACTION, itemStruct ) ;
	else GiveInventorySlot ( fId, SUB_INV_FRACTION, slotId, itemStruct ) ;
	return slotId ;
}

stock clear_fraction_item ( fId, modelId, modelCount, slotId = -1 )
{
	if ( slotId == -1 ) slotId = ClearInventory ( fId, SUB_INV_FRACTION, modelId, modelCount ) ;
	else slotId = ClearInventorySlot ( fId, SUB_INV_FRACTION, slotId, modelId, modelCount ) ;
	return slotId ;
}

stock dragged_fraction_item ( fId, moveFromIndex, moveToIndex )
{
	new draggedItem = GetFractionInventory ( fId, INV_ITEM, moveFromIndex ),
		draggedItemCount = GetFractionInventory ( fId, INV_ITEM_COUNT, moveFromIndex ),
		droppedItem = GetFractionInventory ( fId, INV_ITEM, moveToIndex ),
		droppedItemCount = GetFractionInventory ( fId, INV_ITEM_COUNT, moveToIndex ),
		USERS_INVENTORY_STRUCT: moveInventory [ _:INV_STRUCTURE_MAX ],
		USERS_INVENTORY_STRUCT: toInventory [ _:INV_STRUCTURE_MAX ] ;

	moveInventory = TransferInventoryStructure ( fId, SUB_INV_FRACTION, moveFromIndex ) ;
	toInventory = TransferInventoryStructure ( fId, SUB_INV_FRACTION, moveToIndex ) ;

	if ( droppedItem > 0 )
	{
		if ( draggedItem == droppedItem )
		{
			clear_fraction_item ( fId, draggedItem, draggedItemCount, moveFromIndex ) ;
			give_fraction_item ( fId, moveToIndex, moveInventory ) ;

			foreach(new i: fraction_players[fId])
			{
				if ( player_inventory { i } != SUB_INV_FRACTION ) continue ;

				SetWarehouseItemID ( i, SUB_INV_FRACTION, fId, moveFromIndex ) ;
				SetWarehouseItemID ( i, SUB_INV_FRACTION, fId, moveToIndex ) ;
			}
			return 1 ;
		}

		clear_fraction_item ( fId, draggedItem, draggedItemCount, moveFromIndex ) ;
		clear_fraction_item ( fId, droppedItem, droppedItemCount, moveToIndex ) ;
		
		give_fraction_item ( fId, moveToIndex, moveInventory ) ;
		give_fraction_item ( fId, moveFromIndex, toInventory ) ;
	}
	else
	{
		clear_fraction_item ( fId, draggedItem, draggedItemCount, moveFromIndex ) ;
		give_fraction_item ( fId, moveToIndex, moveInventory ) ;
	}

	foreach(new i: fraction_players[fId])
	{
		if ( player_inventory { i } != SUB_INV_FRACTION ) continue ;

		SetWarehouseItemID ( i, SUB_INV_FRACTION, fId, moveFromIndex ) ;
		SetWarehouseItemID ( i, SUB_INV_FRACTION, fId, moveToIndex ) ;
	}
	return 1 ;
}