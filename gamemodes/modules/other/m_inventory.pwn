/*

	18631 - знак вопроса для пустого

*/

#include	<custom/inventory_inc>

new player_inventory [ MAX_PLAYERS char ] ;
new bool: safe_pin_status [ MAX_PLAYERS ] ;
new bool: inventory_button_use [ MAX_PLAYERS ] ;
new bool: inventory_button [ MAX_PLAYERS ] [ 5 ] ;

/*#define MAX_INVENTORY_SLOT 75
enum _inventory
{
	i_name [ 32 ],
	i_info [ 32 ],
	i_item
} ;

#define MAX_INVENTORY 9
new inventory_info [ MAX_INVENTORY ] [ _inventory ] =
{
	{ "Камень", "на шахте", 905 },
	{ "Золото", "на шахте", 19941 },
	{ "Древесина", "на лесопилке", 1463 },
	{ "Хлопок", "на лесопилке", 2684 },
	{ "Колесо", "на работе вора деталей", 1080 },
	{ "Выхлопная труба", "на работе вора деталей", 1018 },
	{ "Элемент крыши", "на работе вора деталей", 1038 },
	{ "Бампер", "на работе вора деталей", 1140 },
	{ "Задний бампер", "на работе вора деталей", 1165 }
} ;*/

stock show_inventory_ptd ( playerid, bool: status )
{
	if ( status )
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
		invOpen ( playerid, 1, "ИНВЕНТАРЬ", "", false, 0 ) ;
		set_inventory_button ( playerid, 1 ) ;
		player_inventory { playerid } = 1 ;
	}
	else
	{
		inventory_button_use [ playerid ] =
		inventory_button [ playerid ] [ 0 ] =
		inventory_button [ playerid ] [ 1 ] =
		inventory_button [ playerid ] [ 2 ] =
		inventory_button [ playerid ] [ 3 ] =
		inventory_button [ playerid ] [ 4 ] =
		safe_pin_status [ playerid ] =
		used_inventory [ playerid ] = false ;
		toggle_controlable ( playerid, true ) ;

		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
		
		SetInventoryHide ( playerid ) ;
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
	if ( ! inventory_button_use [ playerid ] )
	{
		new _count = 1 ;
		SetInventoryButton ( playerid, "ПЕРСОНАЖ", 1, ( _type == _count ) ? ( true ) : ( false ) ) ;
		inventory_button [ playerid ] [ 0 ] = true ;
		
		_count += 2 ;
		foreach(new _v_id: streamed_vehicles[playerid])
		{
			if ( ! IsValidVehicle ( _v_id ) ) continue ;
			if ( ! IsACar ( _v_id ) ) continue ;
			new Float:x, Float:y, Float:z ;
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
					new sql_string [ 68 + ( 2 * 9 ) ] ;
					format ( sql_string, sizeof ( sql_string ), "SELECT * FROM `users_prise_vehicles` WHERE `v_id` = '%d' LIMIT %d", veh_info [ _v_id - 1 ] [ v_id ], MAX_WAREHOUSE_SLOT ) ;
					mysql_tquery ( sql_connection, sql_string, "callback_prise_vehicle_loading", "i", _v_id ) ;
				}
				idaofcar [ playerid ] = _v_id ;
				SetInventoryButton ( playerid, "БАГАЖНИК", 3, ( _type == _count ) ? ( true ) : ( false ) ) ;
				inventory_button [ playerid ] [ 1 ] = true ;
				break ;
			}
		}
		
		_count += 4 ;
		if ( GetPVarInt ( playerid, "house_id" ) > 0 )
		{
			SetInventoryButton ( playerid, "СЕЙФ", 7, ( _type == _count ) ? ( true ) : ( false ) ) ;
			inventory_button [ playerid ] [ 2 ] = true ;
		}
		
		_count += 3 ;
		if ( p_info [ playerid ] [ family ] > 0 )
		{
			new _fam_id = p_info [ playerid ] [ family ] ;
			if ( ! family_info [ _fam_id - 1 ] [ fam_safe_load ] )
			{
				static const _str [ ] = "SELECT * FROM `family_prise` WHERE `fam_id` = '%d' LIMIT %d" ;
				new sql_string [ sizeof _str + ( 2 * 9 ) ] ;
				format ( sql_string, sizeof ( sql_string ), _str, _fam_id, MAX_FAMILY_WAREHOUSE ) ;
				mysql_tquery ( sql_connection, sql_string, "callback_prise_family_loading", "i", _fam_id ) ;
			}
			SetInventoryButton ( playerid, "СЕМЬЯ", 10, ( _type == _count ) ? ( true ) : ( false ) ) ;
			inventory_button [ playerid ] [ 3 ] = true ;
		}
		
		_count += 1 ;
		if ( p_info [ playerid ] [ member ] > 0 )
		{
			SetInventoryButton ( playerid, "ОРГАНИЗАЦИЯ", 11, ( _type == _count ) ? ( true ) : ( false ) ) ;
			inventory_button [ playerid ] [ 4 ] = true ;
		}
		
		inventory_button_use [ playerid ] = true ;
	}
	else
	{
		new _count = 1, _id = 0 ;
		UpdateInventoryButton ( playerid, _id, "ПЕРСОНАЖ", 1, ( _type == _count ) ? ( true ) : ( false ) ) ;
		
		_count += 2 ;
		foreach(new _v_id: streamed_vehicles[playerid])
		{
			if ( ! IsValidVehicle ( _v_id ) ) continue ;
			if ( ! IsACar ( _v_id ) ) continue ;
			new Float:x, Float:y, Float:z ;
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
					new sql_string [ 68 + ( 2 * 9 ) ] ;
					format ( sql_string, sizeof ( sql_string ), "SELECT * FROM `users_prise_vehicles` WHERE `v_id` = '%d' LIMIT %d", veh_info [ _v_id - 1 ] [ v_id ], MAX_WAREHOUSE_SLOT ) ;
					mysql_tquery ( sql_connection, sql_string, "callback_prise_vehicle_loading", "i", _v_id ) ;
				}
				idaofcar [ playerid ] = _v_id ;
				
				if ( inventory_button [ playerid ] [ 1 ] )
				{
					_id ++ ;
					UpdateInventoryButton ( playerid, _id, "БАГАЖНИК", 3, ( _type == _count ) ? ( true ) : ( false ) ) ;
				}
				break ;
			}
		}
		
		_count += 4 ;
		if ( GetPVarInt ( playerid, "house_id" ) > 0 )
		{
			_id ++ ;
			if ( inventory_button [ playerid ] [ 2 ] ) UpdateInventoryButton ( playerid, _id, "СЕЙФ", 7, ( _type == _count ) ? ( true ) : ( false ) ) ;
		}
		
		_count += 3 ;
		if ( p_info [ playerid ] [ family ] > 0 )
		{
			new _fam_id = p_info [ playerid ] [ family ] ;
			if ( ! family_info [ _fam_id - 1 ] [ fam_safe_load ] )
			{
				static const _str [ ] = "SELECT * FROM `family_prise` WHERE `fam_id` = '%d' LIMIT %d" ;
				new sql_string [ sizeof _str + ( 2 * 9 ) ] ;
				format ( sql_string, sizeof ( sql_string ), _str, _fam_id, MAX_FAMILY_WAREHOUSE ) ;
				mysql_tquery ( sql_connection, sql_string, "callback_prise_family_loading", "i", _fam_id ) ;
			}
			
			_id ++ ;
			if ( inventory_button [ playerid ] [ 3 ] ) UpdateInventoryButton ( playerid, _id, "СЕМЬЯ", 10, ( _type == _count ) ? ( true ) : ( false ) ) ;
		}
		
		_count += 1 ;
		if ( p_info [ playerid ] [ member ] > 0 )
		{
			_id ++ ;
			if ( inventory_button [ playerid ] [ 4 ] ) UpdateInventoryButton ( playerid, _id, "ОРГАНИЗАЦИЯ", 11, ( _type == _count ) ? ( true ) : ( false ) ) ;
		}
	}
	return 1 ;
}

stock set_packet_inventory ( playerid, _param1 )
{
	if ( _param1 == 3 )
	{
		if ( ! bad_inventory ( playerid ) )
		{
			hideSelectorDialog ( playerid ) ;
			send_check_cinfo ( playerid, "Недоступно в данный момент.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		prise_open ( playerid, get_player_use_listitem ( playerid ) ) ;
	}
	else if ( _param1 == 5 )
	{
		if ( ! bad_inventory ( playerid ) )
		{
			hideSelectorDialog ( playerid ) ;
			send_check_cinfo ( playerid, "Недоступно в данный момент.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		new _id = get_player_use_listitem ( playerid ), _i_item = p_info [ playerid ] [ prise_slot ] [ _id ] ;

		new _i_count = p_info [ playerid ] [ prise_slot_count ] [ _id ] ;
		global_string [ 0 ] = EOS ;
		if ( _i_count > 1 )
		{
			format ( global_string, 200, "{"#cWH"}Вы собираетесь выбросить {"#cGN"}%s\n{"#cWH"}У Вас: {"#cGN"}%d шт.\n\n{"#cGRDialog"}* Укажите, сколько выбросить (от 1 до %d):", item_name ( _i_item ), _i_count, _i_count ) ;
			inv_dialog ( playerid, d_drop_item, DIALOG_STYLE_INPUT, "{"#cBHD"}Инвентарь", global_string, "Выкинуть", "Назад" ) ;
		}
		else
		{
			format ( global_string, 144, "{"#cWH"}Вы собираетесь выбросить {"#cGN"}%s\n\n{"#cGRDialog"}* Вы уверены, что хотите выбросить предмет?", item_name ( _i_item ) ) ;
			inv_dialog ( playerid, d_drop_item, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Инвентарь", global_string, "Выкинуть", "Назад" ) ;
		}
	}
	else if ( _param1 == 6 )
	{
		if ( ! bad_inventory ( playerid ) )
		{
			hideSelectorDialog ( playerid ) ;
			send_check_cinfo ( playerid, "Недоступно в данный момент.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		new _id = get_player_use_listitem ( playerid ), pvar_string [ 64 ], _i_item = p_info [ playerid ] [ prise_slot ] [ _id ] ;
		format ( pvar_string, sizeof pvar_string, "{"#cBHD"}Продажа %s (%d шт.)", item_name ( _i_item ), p_info [ playerid ] [ prise_slot_count ] [ _id ] ) ;
		inv_dialog ( playerid, d_prise_sell, DIALOG_STYLE_INPUT, pvar_string, "{"#cWH"}Введите ID игрока, цену и количество, за которую хотите продать:\n{"#cGRDialog"}Пример: {"#cBL"}'30 (ID), 50000 (цена), 5 (шт.)'", "Далее", "Назад" ) ;
	}
	hideSelectorDialog ( playerid ) ;
	return 1 ;
}

stock set_packet_accessories ( playerid, _param1 )
{
	if ( _param1 == 1 )
	{
		new _id = get_player_use_listitem ( playerid ) ;
		if ( acc_player [ playerid ] [ acc_used ] [ _id ] == 1 )
		{
			acc_player [ playerid ] [ acc_used ] [ _id ] = 0 ;
			for ( new i = 5 ; i < 10 ; i ++ )
			{
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, i ) ) RemovePlayerAttachedObject ( playerid, i ) ;
			}
			for ( new j = 0 ; j < MAX_ACCESORIES ; j ++ )
			{
				if ( acc_player [ playerid ] [ acc_used ] [ j ] == 0 ) continue ;
				GiveItem ( playerid, acc_player [ playerid ] [ acc_model ] [ j ], 1, j ) ;
			}

			new _query [ 90 + 9 ] ;
			format ( _query, sizeof ( _query ), "UPDATE `users_accessories` SET `acc_accessories_used`='0' WHERE `inc_id` = '%d' LIMIT 1",
			acc_player [ playerid ] [ acc_id ] [ _id ] ) ;
			mysql_tquery ( sql_connection, _query ) ;

			SetInventoryAcsID ( playerid, _id ) ;
		}
		else
		{
			if ( ! CheckAttackFreeSlot ( playerid, acc_player [ playerid ] [ acc_model ] [ _id ] ) )
			{
				hideSelectorDialog ( playerid ) ;
				send_check_cinfo ( playerid, "Слот на теле персонажа под выбранный аксессуар уже занят.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				    
			if ( acc_player [ playerid ] [ acc_model ] [ _id ] < 1 )
		    {
				hideSelectorDialog ( playerid ) ;
				send_check_cinfo ( playerid, "Произошла ошибка. Невалидный ID аксессуара.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				    
			acc_player [ playerid ] [ acc_used ] [ _id ] = 1 ;
			GiveItem ( playerid, acc_player [ playerid ] [ acc_model ] [ _id ], 1, _id ) ;

			new _query [ 90 + 9 ] ;
			format ( _query, sizeof ( _query ), "UPDATE `users_accessories` SET `acc_accessories_used`='1' WHERE `inc_id` = '%d' LIMIT 1",
			acc_player [ playerid ] [ acc_id ] [ _id ] ) ;
			mysql_tquery ( sql_connection, _query ) ;

			SetInventoryAcsID ( playerid, _id ) ;
		}
	}
	else if ( _param1 == 2 )
	{
		new _id = get_player_use_listitem ( playerid ) ;
		if ( acc_player [ playerid ] [ acc_used ] [ _id ] == 1 )
		{
			hideSelectorDialog ( playerid ) ;
			send_check_cinfo ( playerid, "Сперва снимите аксессуар.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		if ( ! bad_inventory ( playerid ) )
		{
			hideSelectorDialog ( playerid ) ;
			send_check_cinfo ( playerid, "Недоступно в данный момент.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		global_string [ 0 ] = EOS ;
		format ( global_string, 144, "{"#cWH"}Вы собираетесь выбросить {"#cGN"}%s\n\n{"#cGRDialog"}* Вы уверены, что хотите выбросить аксессуар?", get_accessorie_name ( acc_player [ playerid ] [ acc_model ] [ _id ] ) ) ;
		inv_dialog ( playerid, d_drop_accesories, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Аксессуар", global_string, "Выкинуть", "Назад" ) ;
	}
	else if ( _param1 == 3 )
	{
		new _id = get_player_use_listitem ( playerid ) ;
		if ( acc_player [ playerid ] [ acc_used ] [ _id ] == 1 )
		{
			hideSelectorDialog ( playerid ) ;
			send_check_cinfo ( playerid, "Сперва снимите аксессуар.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
				    
		if ( acc_player [ playerid ] [ acc_model ] [ _id ] < 1 )
		{
			hideSelectorDialog ( playerid ) ;
			send_check_cinfo ( playerid, "Произошла ошибка. Невалидный ID аксессуара.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		edit_acc [ playerid ] = true ;
	    acc_player [ playerid ] [ acc_used ] [ _id ] = 1 ;
		GiveItem ( playerid, acc_player [ playerid ] [ acc_model ] [ _id ], 1, _id ) ;

		new _query [ 90 + 9 ] ;
		format ( _query, sizeof ( _query ), "UPDATE `users_accessories` SET `acc_accessories_used`='1' WHERE `inc_id` = '%d' LIMIT 1",
		acc_player [ playerid ] [ acc_id ] [ _id ] ) ;
		mysql_tquery ( sql_connection, _query ) ;
		
		show_inventory_ptd ( playerid, false ) ;
	}
	else if ( _param1 == 4 )
	{
		new _id = get_player_use_listitem ( playerid ) ;
		if ( acc_player [ playerid ] [ acc_used ] [ _id ] == 1 )
		{
			hideSelectorDialog ( playerid ) ;
			send_check_cinfo ( playerid, "Сперва снимите аксессуар.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		acc_player [ playerid ] [ acc_object_x ] [ _id ] =
		acc_player [ playerid ] [ acc_object_y ] [ _id ] =
		acc_player [ playerid ] [ acc_object_z ] [ _id ] =
		acc_player [ playerid ] [ acc_rot_x ] [ _id ] =
		acc_player [ playerid ] [ acc_rot_y ] [ _id ] =
		acc_player [ playerid ] [ acc_rot_z ] [ _id ] = 0.0 ;

		save_accesories ( playerid, _id ) ;

		acc_player [ playerid ] [ acc_used ] [ _id ] = 1 ;
		GiveItem ( playerid, acc_player [ playerid ] [ acc_model ] [ _id ], 1, _id ) ;

		new _query [ 90 + 9 ] ;
		format ( _query, sizeof ( _query ), "UPDATE `users_accessories` SET `acc_accessories_used`='1' WHERE `inc_id` = '%d' LIMIT 1",
		acc_player [ playerid ] [ acc_id ] [ _id ] ) ;
		mysql_tquery ( sql_connection, _query ) ;

		send_check_cinfo ( playerid, "Положение аксессуара возвращено в начальное.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
	}
	else if ( _param1 == 5 )
	{
		new _id = get_player_use_listitem ( playerid ) ;
		if ( acc_player [ playerid ] [ acc_used ] [ _id ] == 1 )
		{
			hideSelectorDialog ( playerid ) ;
			send_check_cinfo ( playerid, "Сперва снимите аксессуар.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
				    
		if ( acc_player [ playerid ] [ acc_model ] [ _id ] < 1 )
		{
			hideSelectorDialog ( playerid ) ;
			send_check_cinfo ( playerid, "Произошла ошибка. Невалидный ID аксессуара.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		if ( ! bad_inventory ( playerid ) )
		{
			hideSelectorDialog ( playerid ) ;
			send_check_cinfo ( playerid, "Недоступно в данный момент.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		new header_string [ 64 ] ;
	    format ( header_string, sizeof header_string, "{"#cBL"}Продажа %s", get_accessorie_name ( acc_player [ playerid ] [ acc_model ] [ _id ] ) ) ;
		inv_dialog ( playerid, d_accessories_sell, DIALOG_STYLE_INPUT, header_string, "{"#cWH"}Введите ID игрока и цену, за которую хотите продать:\n{"#cGRDialog"}Пример: {"#cBL"}'30, 50000'", "Далее", "Назад" ) ;
	}
	else if ( _param1 == 6 )
	{
		new _id = get_player_use_listitem ( playerid ), _model = acc_player [ playerid ] [ acc_model ] [ _id ] ;
		if ( case_model_id ( _model ) )
		{
			if ( p_info [ playerid ] [ case_id ] == _id )
			{
				p_info [ playerid ] [ case_id ] = -1 ;
				update_int_sql ( playerid, "u_case_id", _id ) ;
				SetInventorySubItem ( playerid, 0, "Кейс" ) ;
			}
			else
			{
				p_info [ playerid ] [ case_id ] = _id ;
				update_int_sql ( playerid, "u_case_id", _id ) ;
				SetInventorySubItem ( playerid, 0, "" ) ;
			}
		}
		else if ( armour_model_id ( _model ) )
		{
			if ( p_info [ playerid ] [ armour_id ] == _id )
			{
				p_info [ playerid ] [ armour_id ] = -1 ;
				update_int_sql ( playerid, "u_armour_id", _id ) ;
				SetInventorySubItem ( playerid, 2, "Броня" ) ;
			}
			else
			{
				p_info [ playerid ] [ armour_id ] = _id ;
				update_int_sql ( playerid, "u_armour_id", _id ) ;
				SetInventorySubItem ( playerid, 2, "" ) ;
			}
		}
		else create_airball ( playerid, _model ) ;
	}
	hideSelectorDialog ( playerid ) ;
	return 1 ;
}

stock show_packet_inventory ( playerid, _param1, _param2, _param3 )
{
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 ) // exit
		{
			show_inventory_ptd ( playerid, false ) ;
		}
		else if ( _param2 == 1 ) // char
		{
			invOpen ( playerid, 1, "ИНВЕНТАРЬ", "", false, 0 ) ;
			player_inventory { playerid } = 1 ;
			set_inventory_button ( playerid, 1 ) ;
		}
		else if ( _param2 == 2 ) // vehicle
		{
			invOpen ( playerid, 2, "ТРАНСПОРТ", "", false, MAX_WAREHOUSE_SLOT ) ;
			set_inventory_button ( playerid, 2 ) ;
		}
		else if ( _param2 == 3 ) // vehicle trunk
		{
			if ( idaofcar [ playerid ] < 1 || idaofcar [ playerid ] > MAX_VEHICLES ) return 1 ;
		
			new line_string [ 48 ] ;
			format ( line_string, sizeof line_string, "БАГАЖНИК %s", GetVehicleNameEx ( veh_info [ idaofcar [ playerid ] - 1 ] [ v_vehicle ] ) ) ;
			invOpen ( playerid, 3, line_string, "", false, MAX_WAREHOUSE_SLOT ) ;
			SetWarehouseItem ( playerid, 3, idaofcar [ playerid ] ) ;
			player_inventory { playerid } = 3 ;
			set_inventory_button ( playerid, 3 ) ;
		}
		else if ( _param2 == 4 ) // Accessories
		{
			SetInventoryAcs ( playerid ) ;
			invOpen ( playerid, 4, "", "", false, 0 ) ;
		}
		else if ( _param2 == 5 ) // Upgrades
		{
			SetInventoryUpgrade ( playerid ) ;
			invOpen ( playerid, 5, "", "", false, 0 ) ;
		}
		else if ( _param2 == 6 ) // Wallet
		{
			SetInventoryWallet ( playerid ) ;
			invOpen ( playerid, 6, "", "", false, 0 ) ;
		}
		else if ( _param2 == 7 ) // warehouse
		{
			if ( p_info [ playerid ] [ hour_played ] < 5 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 5 часов в игре. Используйте /mm - Информация о персонаже - Бонусы для проверки времени." ) ;

			new _h_id = GetPVarInt ( playerid, "house_id" ) ;
			if ( _h_id < 1 || _h_id > MAX_HOUSES ) return 1 ;
		
			if ( safe_pin_status [ playerid ] == true )
			{
				new line_string [ 32 ] ;
				format ( line_string, sizeof line_string, "%s", GetPlayerCashValueToSmile ( h_info [ _h_id - 1 ] [ h_safe_data ] [ 1 ] ) ) ;
				invOpen ( playerid, 7, "СЕЙФ", line_string, true, MAX_WAREHOUSE_SLOT ) ;
				SetWarehouseItem ( playerid, 7, _h_id ) ;
				player_inventory { playerid } = 7 ;
				set_inventory_button ( playerid, 7 ) ;
			}
			else
			{
			    if ( ! h_info [ _h_id - 1 ] [ h_safe_load ] )
			    {
					static const _str [ ] = "SELECT * FROM `users_prise_houses` WHERE `h_id` = '%d' LIMIT %d" ;
					new sql_string [ sizeof _str + ( 2 * 9 ) ] ;
			       	format ( sql_string, sizeof ( sql_string ), _str, _h_id, MAX_WAREHOUSE_SLOT ) ;
					mysql_tquery ( sql_connection, sql_string, "callback_prise_house_loading", "i", _h_id ) ;
			    }
				
				if ( p_info [ playerid ] [ password_status ] ) inv_dialog ( playerid, d_safe_pin, DIALOG_STYLE_INPUT, "{"#cBHD"}Код от сейфа", "{ffffff}Введите код от сейфа, чтобы получить доступ к содержимому:", "Принять", "Закрыть" ) ;
				else inv_dialog ( playerid, d_safe_pin, DIALOG_STYLE_PASSWORD, "{"#cBHD"}Код от сейфа", "{ffffff}Введите код от сейфа, чтобы получить доступ к содержимому:", "Принять", "Закрыть" ) ;
			}
		}
		else if ( _param2 == 8 ) // money
		{
			if ( p_info [ playerid ] [ hour_played ] < 5 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 5 часов в игре. Используйте /mm - Информация о персонаже - Бонусы для проверки времени." ) ;

			new _pi = player_inventory { playerid } ;
			if ( _pi == 7 )
			{
				new _h_id = GetPVarInt ( playerid, "house_id" ) ;
				if ( _h_id < 1 || _h_id > MAX_HOUSES ) return 1 ;
			
				inv_dialog ( playerid, d_safe_access, DIALOG_STYLE_LIST, "{"#cBHD"}Сейф", "Взять деньги\nПоложить деньги\n{"#cLY"}Сменить пин-код", "Выбрать", "Закрыть" ) ;
			}
			else if ( _pi == 10 )
			{
				new header_string [ 64 ] ;
				format ( header_string, sizeof header_string, "{"#cBHD"}Банк семьи ({"#cWH"}%s"valute_title_"{"#cBHD"})", GetPlayerCashValueToSmile ( family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_bank ] ) ) ;
				inv_dialog ( playerid, d_family_bank, DIALOG_STYLE_LIST, header_string, "{"#cGRDialog"}- {"#cWH"}Положить\n{"#cGRDialog"}- {"#cWH"}Взять", "Выбрать", "Назад" ) ;
			}
			else if ( _pi == 11 )
			{
				send_check_cinfo ( playerid, "Со счёта организации нельзя снимать денежные средства.\nПополнить счёт организации можно через банковские услуги в Банке.", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			}
		}
		else if ( _param2 == 10 ) // family warehouse
		{
			if ( p_info [ playerid ] [ hour_played ] < 5 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 5 часов в игре. Используйте /mm - Информация о персонаже - Бонусы для проверки времени." ) ;

			new _str [ 32 ], _str2 [ 32 ], _fam_id = p_info [ playerid ] [ family ] ;
			if ( family_info [ _fam_id - 1 ] [ fam_house ] )
			{
				if ( GetPlayerVirtualWorld ( playerid ) != family_info [ _fam_id - 1 ] [ fam_house ] )
				{
					send_check_cinfo ( playerid, "Вы должны находиться в доме семьи.", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			}
			format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( family_info [ _fam_id - 1 ] [ fam_bank ] ) ) ;
			format ( _str2, sizeof _str2, "%s", family_info [ _fam_id - 1 ] [ fam_name ] ) ;
			invOpen ( playerid, 10, _str2, _str, true, MAX_FAMILY_WAREHOUSE ) ;
			SetWarehouseItem ( playerid, 10, _fam_id ) ;
			player_inventory { playerid } = 10 ;
			set_inventory_button ( playerid, 10 ) ;
		}
		else if ( _param2 == 11 ) // fraction warehouse
		{
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( p_info [ playerid ] [ hour_played ] < 5 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 5 часов в игре. Используйте /mm - Информация о персонаже - Бонусы для проверки времени." ) ;

			new _str [ 32 ], _str2 [ 32 ], _f_id = p_info [ playerid ] [ member ] ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] != area_type_dorm && area_info [ used_area [ playerid ] ] [ a_type ] != area_type_dorm_unload )
			{
				send_check_cinfo ( playerid, "Вы должны находиться около склада организации.", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( f_info [ _f_id - 1 ] [ f_money ] ) ) ;
			format ( _str2, sizeof _str2, "%s", f_info [ _f_id - 1 ] [ f_name ] ) ;
			invOpen ( playerid, 11, _str2, _str, true, MAX_FRACTION_WAREHOUSE ) ;
			SetWarehouseItem ( playerid, 11, _f_id ) ;
			player_inventory { playerid } = 11 ;
			set_inventory_button ( playerid, 11 ) ;
		}
	}
	else if ( _param1 == 1 )
	{
		if ( _param2 == 1 )
		{
			if ( p_info [ playerid ] [ prise_slot ] [ _param3 ] < 1 ) return 1 ;
			if ( checkInventoryMarket ( playerid, _param3 ) )
			{
				send_check_cinfo ( playerid, "Предмет выставлен на рынке.", 0, 300, CINFO_OTHER_MARKET_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			new _i_item = p_info [ playerid ] [ prise_slot ] [ _param3 ], 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				_day = p_info [ playerid ] [ prise_slot_date ] [ _param3 ],
				_count = p_info [ playerid ] [ prise_slot_count ] [ _param3 ],
				date_string [ 64 ] ;
				
			if ( _day != -1 )
			{
				timestamp_to_date ( _day + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d", s_day, s_month, s_year ) ;
			}
			else format ( date_string, sizeof date_string, " " ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
				{"#cWH"}Предмет: {"#cOR"}%s\n\
				{"#cWH"}Количество: {"#cWV"}%d шт.\n\
				{"#cWH"}%s\n\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
				%s", item_name ( _i_item ), _count, date_string, get_model_count ( _i_item ), item_description ( _i_item ) ) ;
			if ( player_inventory { playerid } == 1 )
			{
				if ( item_blocked ( _i_item ) ) showSelectorDialog ( playerid, "", "", "", "", "", "", "Информация", global_string ) ;
				else showSelectorDialog ( playerid, "", "", "Использовать", "-", "Выбросить", "Продать", "Информация", global_string ) ;
				dialogSeekBar ( playerid, false, "", "", "", 0, 100 ) ;
			
				set_player_use_listitem ( playerid, _param3 ) ;
				SetPlayerDialogsType ( playerid, 1 ) ;
			}
			else if ( player_inventory { playerid } == 3 )
			{
				showSelectorDialog ( playerid, "", "", "В багажник 1 шт.", "-", "В багажник", "Выбросить", "Информация", global_string ) ;
				new _str [ 11 ] ;
				format ( _str, sizeof _str, "%d", _count ) ;
				dialogSeekBar ( playerid, true, "0", "0", _str, 0, _count ) ;
			
				set_player_use_listitem ( playerid, _param3 ) ;
				SetPlayerDialogsType ( playerid, 13 ) ;
			}
			else if ( player_inventory { playerid } == 7 )
			{
				showSelectorDialog ( playerid, "", "", "В сейф 1 шт.", "-", "В сейф", "Выбросить", "Информация", global_string ) ;
				new _str [ 11 ] ;
				format ( _str, sizeof _str, "%d", _count ) ;
				dialogSeekBar ( playerid, true, "0", "0", _str, 0, _count ) ;
			
				set_player_use_listitem ( playerid, _param3 ) ;
				SetPlayerDialogsType ( playerid, 17 ) ;
			}
			else if ( player_inventory { playerid } == 10 )
			{
				showSelectorDialog ( playerid, "", "", "На склад 1 шт.", "-", "На склад", "Выбросить", "Информация", global_string ) ;
				new _str [ 11 ] ;
				format ( _str, sizeof _str, "%d", _count ) ;
				dialogSeekBar ( playerid, true, "0", "0", _str, 0, _count ) ;
			
				set_player_use_listitem ( playerid, _param3 ) ;
				SetPlayerDialogsType ( playerid, 20 ) ;
			}
			else if ( player_inventory { playerid } == 11 )
			{
				showSelectorDialog ( playerid, "", "", "На склад 1 шт.", "-", "На склад", "Выбросить", "Информация", global_string ) ;
				new _str [ 11 ] ;
				format ( _str, sizeof _str, "%d", _count ) ;
				dialogSeekBar ( playerid, true, "0", "0", _str, 0, _count ) ;
			
				set_player_use_listitem ( playerid, _param3 ) ;
				SetPlayerDialogsType ( playerid, 30 ) ;
			}
		}
	}
	else if ( _param1 == 2 )
	{
		if ( _param2 == 1 )
		{
			if ( _param3 == 0 )
			{
				showSelectorDialog ( playerid, "", "", "", "", "", "", "Кейс", "Если у Вас есть аксессуар кейса,\n\
																				то Вы можете использовать его, как кейс,\n\
																				который у Вас появляется свыше 40 млн.\n\n\
																				Появится только в том случае, если аксессуар был отредактирован под персонажа." ) ;
				
				dialogSeekBar ( playerid, false, "", "", "", 0, 100 ) ;
				SetPlayerDialogsType ( playerid, 0 ) ;
			}
			else if ( _param3 == 1 )
			{
				showSelectorDialog ( playerid, "", "", "", "", "", "", "Одежда", "Здесь отображается Ваша постоянная одежда.\n\
																				Вы можете в любой момент переодеться в собственном доме,\n\
																				отеле, арендованном доме." ) ;
																				
				dialogSeekBar ( playerid, false, "", "", "", 0, 100 ) ;
				SetPlayerDialogsType ( playerid, 0 ) ;
			}
			else if ( _param3 == 2 )
			{
				showSelectorDialog ( playerid, "", "", "", "", "", "", "Броня", "Если у Вас есть аксессуар брони,\n\
																				то Вы можете использовать его, как броню,\n\
																				которая появляется в момент взятия брони.\n\n\
																				Появится только в том случае, если аксессуар был отредактирован под персонажа." ) ;
																				
				dialogSeekBar ( playerid, false, "", "", "", 0, 100 ) ;
				SetPlayerDialogsType ( playerid, 0 ) ;
			}
		}
	}
	else if ( _param1 == 3 )
	{
		if ( _param2 == 1 )
		{
			if ( acc_player [ playerid ] [ acc_model ] [ _param3 ] < 1 ) return 1 ;
			
			new str_date [ 64 ],
				_acc_model = acc_player [ playerid ] [ acc_model ] [ _param3 ], 
				_acc_used = acc_player [ playerid ] [ acc_used ] [ _param3 ] ;

			if ( acc_player [ playerid ] [ acc_date ] [ _param3 ] )
			{
				new s_year, s_month, s_day, s_hour, s_minute, s_second ;
				timestamp_to_date ( acc_player [ playerid ] [ acc_date ] [ _param3 ] + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( str_date, sizeof str_date, "\n{"#cGRDialog"}Пропадёт {"#cGN"}%02d.%02d.%d", s_day, s_month, s_year ) ;
				strcat ( global_string, str_date ) ;
			}
			else format ( str_date, sizeof str_date, "" ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
				{"#cWH"}Предмет: {"#cOR"}%s\n\
				{"#cWH"}Статус: {"#cWV"}%s\n\
				{"#cWH"}%s\n\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.",
			item_name ( _acc_model ), ( _acc_used == 1 ) ? ( "{"#cGN"}Используется" ) : ( "{"#cRD"}Не надет" ), str_date, get_model_count ( _acc_model ) ) ;

			if ( _acc_used == 1 )
			{
				if ( _acc_model == 1083 ||
					_acc_model == 2511 ||
					_acc_model >= 19332 && _acc_model <= 19338 || _acc_model >= 8224 && _acc_model <= 8230 || _acc_model == 8327 ||
					case_model_id ( _acc_model ) || armour_model_id ( _acc_model ) )
						showSelectorDialog ( playerid, "Снять", "Выбросить", "Изменить", "Обнулить", "Продать", "Использовать", "Информация", global_string ) ;
						
				else
					showSelectorDialog ( playerid, "Снять", "Выбросить", "Изменить", "Обнулить", "Продать", "-", "Информация", global_string ) ;
			}
			else
			{
				if ( _acc_model == 1083 ||
					_acc_model == 2511 ||
					_acc_model >= 19332 && _acc_model <= 19338 || _acc_model >= 8224 && _acc_model <= 8230 || _acc_model == 8327 ||
					case_model_id ( _acc_model ) || armour_model_id ( _acc_model ) )
					showSelectorDialog ( playerid, "Надеть", "Выбросить", "Изменить", "Обнулить", "Продать", "Использовать", "Информация", global_string ) ;
					
				else
					showSelectorDialog ( playerid, "Надеть", "Выбросить", "Изменить", "Обнулить", "Продать", "-", "Информация", global_string ) ;
			}
			
			set_player_use_listitem ( playerid, _param3 ) ;
			SetPlayerDialogsType ( playerid, 2 ) ;
			dialogSeekBar ( playerid, false, "", "", "", 0, 100 ) ;
		}
	}
	else if ( _param1 == 5 )
	{
		if ( _param2 == 1 )
		{
			if ( _param3 < MAX_PERKS ) show_perks_info ( playerid, _param3 ) ;
		}
	}
	else if ( _param1 == 7 )
	{
		if ( player_inventory { playerid } == 3 )
		{
			new _v_id = idaofcar [ playerid ] ;
			if ( veh_info [ _v_id - 1 ] [ v_slot ] [ _param3 ] < 1 ) return 1 ;

			new _i_item = veh_info [ _v_id - 1 ] [ v_slot ] [ _param3 ], 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				_day = veh_info [ _v_id - 1 ] [ v_slot_date ] [ _param3 ], 
				_count = veh_info [ _v_id - 1 ] [ v_slot_count ] [ _param3 ],
				date_string [ 64 ] ;
				
			if ( _day != -1 )
			{
				timestamp_to_date ( _day + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d", s_day, s_month, s_year ) ;
			}
			else format ( date_string, sizeof date_string, " " ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
				{"#cWH"}Предмет: {"#cOR"}%s\n\
				{"#cWH"}Количество: {"#cWV"}%d шт.\n\
				{"#cWH"}%s\n\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
				%s", item_name ( _i_item ), _count, date_string, get_model_count ( _i_item ), item_description ( _i_item ) ) ;
			showSelectorDialog ( playerid, "", "", "В инвентарь 1 шт.", "-", "В инвентарь", "Выбросить", "Информация", global_string ) ;
			
			set_player_use_listitem ( playerid, _param3 ) ;
			SetPlayerDialogsType ( playerid, 14 ) ;
			
			new _str [ 8 ] ;
			format ( _str, sizeof _str, "%d", _count ) ;
			dialogSeekBar ( playerid, true, "0", "0", _str, 0, _count ) ;
		}
		else if ( player_inventory { playerid } == 7 )
		{
			new _h_id = GetPVarInt ( playerid, "house_id" ) ;
			if ( h_info [ _h_id - 1 ] [ h_slot ] [ _param3 ] < 1 ) return 1 ;

			new _i_item = h_info [ _h_id - 1 ] [ h_slot ] [ _param3 ], 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				_day = h_info [ _h_id - 1 ] [ h_slot_date ] [ _param3 ],
				_count = h_info [ _h_id - 1 ] [ h_slot_count ] [ _param3 ],
				date_string [ 64 ] ;
				
			if ( _day != -1 )
			{
				timestamp_to_date ( _day + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d", s_day, s_month, s_year ) ;
			}
			else format ( date_string, sizeof date_string, " " ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
				{"#cWH"}Предмет: {"#cOR"}%s\n\
				{"#cWH"}Количество: {"#cWV"}%d шт.\n\
				{"#cWH"}%s\n\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
				%s", item_name ( _i_item ), _count, date_string, get_model_count ( _i_item ), item_description ( _i_item ) ) ;
			showSelectorDialog ( playerid, "", "", "В инвентарь 1 шт.", "-", "В инвентарь", "Выбросить", "Информация", global_string ) ;
			
			set_player_use_listitem ( playerid, _param3 ) ;
			SetPlayerDialogsType ( playerid, 18 ) ;
			
			new _str [ 8 ] ;
			format ( _str, sizeof _str, "%d", _count ) ;
			dialogSeekBar ( playerid, true, "0", "0", _str, 0, _count ) ;
		}
		else if ( player_inventory { playerid } == 10 )
		{
			new _fam_id = p_info [ playerid ] [ family ],
				_i_item = family_info [ _fam_id - 1 ] [ fam_slot ] [ _param3 ], 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				_day = family_info [ _fam_id - 1 ] [ fam_slot_date ] [ _param3 ],
				_count = family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _param3 ],
				date_string [ 64 ] ;
				
			if ( _day != -1 )
			{
				timestamp_to_date ( _day + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d", s_day, s_month, s_year ) ;
			}
			else format ( date_string, sizeof date_string, " " ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
				{"#cWH"}Предмет: {"#cOR"}%s\n\
				{"#cWH"}Количество: {"#cWV"}%d шт.\n\
				{"#cWH"}%s\n\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
				%s", item_name ( _i_item ), _count, date_string, get_model_count ( _i_item ), item_description ( _i_item ) ) ;
			
			if ( family_info [ _fam_id - 1 ] [ fam_dorm_status ] )
			{
				showSelectorDialog ( playerid, "", "", "", "", "", "", "Общак закрыт", global_string ) ;
				
				set_player_use_listitem ( playerid, _param3 ) ;
				SetPlayerDialogsType ( playerid, 0 ) ;
				dialogSeekBar ( playerid, false, "", "", "", 0, 100 ) ;
			}
			if ( p_info [ playerid ] [ family_rang ] < family_info [ _fam_id - 1 ] [ fam_settings ] [ 7 ] )
			{
				static const _str [ ] = "Общак доступен с ранга %s (%d)" ;
				new scm_string [ sizeof _str + 30 + 4 ] ;
				format ( scm_string, sizeof scm_string, _str, family_rank [ _fam_id - 1 ] [ family_info [ _fam_id - 1 ] [ fam_settings ] [ 7 ] - 1 ], family_info [ _fam_id - 1 ] [ fam_settings ] [ 7 ] ) ;
				showSelectorDialog ( playerid, "", "", "", "", "", "", scm_string, global_string ) ;
				
				set_player_use_listitem ( playerid, _param3 ) ;
				SetPlayerDialogsType ( playerid, 0 ) ;
				dialogSeekBar ( playerid, false, "", "", "", 0, 100 ) ;
			}
			else
			{
				if ( item_not_get ( _i_item ) ) showSelectorDialog ( playerid, "", "", "В инвентарь 1 шт.", "Открыть ящик", "В инвентарь", "Выбросить", "Информация", global_string ) ;
				else showSelectorDialog ( playerid, "", "", "В инвентарь 1 шт.", "-", "В инвентарь", "Выбросить", "Информация", global_string ) ;
				
				set_player_use_listitem ( playerid, _param3 ) ;
				SetPlayerDialogsType ( playerid, 21 ) ;
			
				new _str [ 8 ] ;
				format ( _str, sizeof _str, "%d", _count ) ;
				dialogSeekBar ( playerid, true, "0", "0", _str, 0, _count ) ;
			}
		}
		else if ( player_inventory { playerid } == 11 )
		{
			new _f_id = p_info [ playerid ] [ member ],
				_i_item = f_info [ _f_id - 1 ] [ f_slot ] [ _param3 ], 
				s_year, s_month, s_day, s_hour, s_minute, s_second, 
				_day = f_info [ _f_id - 1 ] [ f_slot_date ] [ _param3 ],
				_count = f_info [ _f_id - 1 ] [ f_slot_count ] [ _param3 ],
				date_string [ 64 ] ;
				
			if ( _day != -1 )
			{
				timestamp_to_date ( _day + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				format ( date_string, sizeof date_string, "{"#cWH"}Пропадёт {"#cGN"}%02d.%02d.%d", s_day, s_month, s_year ) ;
			}
			else format ( date_string, sizeof date_string, " " ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "\
				{"#cWH"}Предмет: {"#cOR"}%s\n\
				{"#cWH"}Количество: {"#cWV"}%d шт.\n\
				{"#cWH"}%s\n\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
				%s", item_name ( _i_item ), _count, date_string, get_model_count ( _i_item ), item_description ( _i_item ) ) ;
			
			if ( f_info [ _f_id - 1 ] [ f_dorm_status ] )
			{
				showSelectorDialog ( playerid, "", "", "", "", "", "", "Общак закрыт", global_string ) ;
				
				set_player_use_listitem ( playerid, _param3 ) ;
				SetPlayerDialogsType ( playerid, 0 ) ;
				dialogSeekBar ( playerid, false, "", "", "", 0, 100 ) ;
			}
			if ( p_info [ playerid ] [ rank ] < f_info [ _f_id - 1 ] [ f_rank_settings ] [ 7 ] )
			{
				static const _str [ ] = "{"#cRInfo"}* {"#cGRInfo"}Общак доступен с ранга %s (%d)." ;
				new scm_string [ sizeof _str + 30 + 4 ] ;
				format ( scm_string, sizeof scm_string, _str, f_rank [ _f_id - 1 ] [ f_info [ _f_id - 1 ] [ f_rank_settings ] [ 7 ] - 1 ], f_info [ _f_id - 1 ] [ f_rank_settings ] [ 7 ] ) ;
				SendClientMessage ( playerid, col_gray, scm_string ) ;
				showSelectorDialog ( playerid, "", "", "", "", "", "", scm_string, global_string ) ;
				
				set_player_use_listitem ( playerid, _param3 ) ;
				SetPlayerDialogsType ( playerid, 0 ) ;
				dialogSeekBar ( playerid, false, "", "", "", 0, 100 ) ;
			}
			else
			{
				if ( item_not_get ( _i_item ) ) showSelectorDialog ( playerid, "", "", "В инвентарь 1 шт.", "Открыть ящик", "В инвентарь", "Выбросить", "Информация", global_string ) ;
				else showSelectorDialog ( playerid, "", "", "В инвентарь 1 шт.", "-", "В инвентарь", "Выбросить", "Информация", global_string ) ;
				
				set_player_use_listitem ( playerid, _param3 ) ;
				SetPlayerDialogsType ( playerid, 31 ) ;
			
				new _str [ 8 ] ;
				format ( _str, sizeof _str, "%d", _count ) ;
				dialogSeekBar ( playerid, true, "0", "0", _str, 0, _count ) ;
			}
		}
	}
	return 1 ;
}

stock set_packet_vehicle_put ( playerid, _param1, _param2 )
{
	if ( _param1 == 3 )
	{
		new _id = get_player_use_listitem ( playerid ), _player_slot = p_info [ playerid ] [ prise_slot ] [ _id ], _v_id = idaofcar [ playerid ] ;
		if ( _v_id < 1 || _v_id > MAX_VEHICLES ) return 1 ;
		
		new _slot = give_vehicle_item ( _v_id, _player_slot, 1 ) ;
		if ( _slot == -1 )
		{
			send_check_cinfo ( playerid, "В багажнике нет свободного места!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new query_string [ 144 ] ;
		format ( query_string, sizeof query_string, "%s положил(а) в багажник (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], veh_info [ _v_id - 1 ] [ v_id ], item_name ( _player_slot ), _player_slot, 1 ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		clear_player_item_prise ( playerid, _player_slot, 1, _id ) ;
		SetInventoryItemID ( playerid, _id ) ;
		SetWarehouseItemID ( playerid, 3, _v_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != 3 ) continue ;
			if ( idaofcar [ i ] != _v_id ) continue ;
			SetWarehouseItemID ( playerid, 3, _v_id, _slot ) ;
		}
	}
	else if ( _param1 == 5 )
	{
		new _id = get_player_use_listitem ( playerid ), _player_slot = p_info [ playerid ] [ prise_slot ] [ _id ], _v_id = idaofcar [ playerid ] ;
		if ( _v_id < 1 || _v_id > MAX_VEHICLES ) return 1 ;
		
		if ( _param2 < 1 ) _param2 = p_info [ playerid ] [ prise_slot_count ] [ _id ] ;
		if ( _param2 > p_info [ playerid ] [ prise_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "У Вас нет такого количества в инвентаре!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new _slot = give_vehicle_item ( _v_id, _player_slot, _param2 ) ;
		if ( _slot == -1 )
		{
			send_check_cinfo ( playerid, "В багажнике нет свободного места!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new query_string [ 144 ] ;
		format ( query_string, sizeof query_string, "%s положил(а) в багажник (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], veh_info [ _v_id - 1 ] [ v_id ], item_name ( _player_slot ), _player_slot, _param2 ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		clear_player_item_prise ( playerid, _player_slot, _param2, _id ) ;
		SetInventoryItemID ( playerid, _id ) ;
		SetWarehouseItemID ( playerid, 3, _v_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != 3 ) continue ;
			if ( idaofcar [ i ] != _v_id ) continue ;
			SetWarehouseItemID ( playerid, 3, _v_id, _slot ) ;
		}
	}
	else if ( _param1 == 6 )
	{
		new _id = get_player_use_listitem ( playerid ), query_string [ 144 ] ;
		format ( query_string, sizeof query_string, "%s выбросил(а) из инвентаря %s (#%d)", p_info [ playerid ] [ name ], item_name ( p_info [ playerid ] [ prise_slot ] [ _id ] ), p_info [ playerid ] [ prise_slot ] [ _id ] ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		clear_player_item_prise ( playerid, p_info [ playerid ] [ prise_slot ] [ _id ], p_info [ playerid ] [ prise_slot_count ] [ _id ], _id ) ;
	}
	hideSelectorDialog ( playerid ) ;
	return 1 ;
}

stock set_packet_vehicle_get ( playerid, _param1, _param2 )
{
	if ( _param1 == 3 )
	{
		new _id = get_player_use_listitem ( playerid ), _v_id = idaofcar [ playerid ], _v_slot = veh_info [ _v_id - 1 ] [ v_slot ] [ _id ], query_string [ 144 ] ;
		if ( _v_id < 1 || _v_id > MAX_VEHICLES ) return 1 ;
		
		if ( 1 > veh_info [ _v_id - 1 ] [ v_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "В багажнике нет такого количества!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		if ( item_not_get ( _v_slot ) )
		{
			send_check_cinfo ( playerid, "Вы не можете взять данный предмет!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new _max_slot = item_max_in_slot ( _v_slot ) ;
		if ( _max_slot != -1 && p_info [ playerid ] [ prise_slot_count ] [ get_player_item_prise ( playerid, _v_slot ) ] + 1 > _max_slot )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "Вы не можете переносить более %d шт. выбранного предмета.", _max_slot ) ;
			send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		format ( query_string, sizeof query_string, "%s взял(а) из багажника (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], veh_info [ _v_id - 1 ] [ v_id ], item_name ( _v_slot ), _v_slot, 1 ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		give_player_item_prise ( playerid, _v_slot, 1 ) ;
		new _slot = clear_vehicle_item ( _v_id, _v_slot, 1, _id ) ;
		SetWarehouseItemID ( playerid, 3, _v_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != 3 ) continue ;
			if ( idaofcar [ i ] != _v_id ) continue ;
			SetWarehouseItemID ( playerid, 3, _v_id, _slot ) ;
		}
	}
	else if ( _param1 == 5 )
	{
		new _id = get_player_use_listitem ( playerid ), _v_id = idaofcar [ playerid ], _v_slot = veh_info [ _v_id - 1 ] [ v_slot ] [ _id ], query_string [ 144 ] ;
		if ( _v_id < 1 || _v_id > MAX_VEHICLES ) return 1 ;
		
		if ( _param2 < 1 ) _param2 = veh_info [ _v_id - 1 ] [ v_slot_count ] [ _id ] ;
		if ( _param2 > veh_info [ _v_id - 1 ] [ v_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "В багажнике нет такого количества!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		if ( item_not_get ( _v_slot ) )
		{
			send_check_cinfo ( playerid, "Вы не можете взять данный предмет!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new _max_slot = item_max_in_slot ( _v_slot ) ;
		if ( _max_slot != -1 && p_info [ playerid ] [ prise_slot_count ] [ get_player_item_prise ( playerid, _v_slot ) ] + _param2 > _max_slot )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "Вы не можете переносить более %d шт. выбранного предмета.", _max_slot ) ;
			send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		format ( query_string, sizeof query_string, "%s взял(а) из багажника (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], veh_info [ _v_id - 1 ] [ v_id ], item_name ( _v_slot ), _v_slot, _param2 ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		give_player_item_prise ( playerid, _v_slot, _param2 ) ;
		new _slot = clear_vehicle_item ( _v_id, _v_slot, _param2, _id ) ;
		SetWarehouseItemID ( playerid, 3, _v_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != 3 ) continue ;
			if ( idaofcar [ i ] != _v_id ) continue ;
			SetWarehouseItemID ( playerid, 3, _v_id, _slot ) ;
		}
	}
	else if ( _param1 == 6 )
	{
		new _id = get_player_use_listitem ( playerid ), _v_id = idaofcar [ playerid ], _v_slot = veh_info [ _v_id - 1 ] [ v_slot ] [ _id ], query_string [ 144 ] ;
		if ( _v_id < 1 || _v_id > MAX_VEHICLES ) return 1 ;
		
		format ( query_string, sizeof query_string, "%s выбросил(а) из багажника (#%d) %s (#%d)", p_info [ playerid ] [ name ], veh_info [ _v_id - 1 ] [ v_id ], item_name ( _v_slot ), _v_slot ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		new _slot = clear_vehicle_item ( _v_id, _v_slot, veh_info [ _v_id - 1 ] [ v_slot_count ] [ _id ], _id ) ;
		SetWarehouseItemID ( playerid, 3, _v_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != 3 ) continue ;
			if ( idaofcar [ i ] != _v_id ) continue ;
			SetWarehouseItemID ( playerid, 3, _v_id, _slot ) ;
		}
	}
	hideSelectorDialog ( playerid ) ;
	return 1 ;
}

stock give_vehicle_item ( _v_id, _i_item, _i_count, _day = 20 )
{
	if ( _i_item < 1 ) return 1 ;

	new bool: _free_slot = false, _insert_slot = false, _slot_id = 0, _slot ;
	for ( new i = 0 ; i < MAX_WAREHOUSE_SLOT ; i ++ )
	{
		_slot = veh_info [ _v_id - 1 ] [ v_slot ] [ i ] ;
	    if ( _slot > 0 )
		{
			if ( _slot == _i_item )
			{
			    _slot_id = i ;
	    		_free_slot = true ;
	    		_insert_slot = false ;
	    		break ;
			}
			continue ;
	    }
	    else
		{
			if ( _free_slot == false )
			{
				_slot_id = i ;
				_free_slot = true ;
				_insert_slot = true ;
			}
		}
	}
	
	if ( _free_slot == false ) return -1 ;
	if ( veh_info [ _v_id - 1 ] [ v_slot_count ] [ _slot_id ] + _i_count > 1_000_000_000 ) return -1 ;
	
	veh_info [ _v_id - 1 ] [ v_slot ] [ _slot_id ] = _i_item ;
	veh_info [ _v_id - 1 ] [ v_slot_count ] [ _slot_id ] += _i_count ;
	if ( _day != -1 ) veh_info [ _v_id - 1 ] [ v_slot_date ] [ _slot_id ] = SetElapsedTime ( gettime ( ), _day, CONVERT_TIME_TO_DAYS ) ;
	else veh_info [ _v_id - 1 ] [ v_slot_date ] [ _slot_id ] = -1 ;
	
    if ( _insert_slot )
    {
        prise_vehicle_inc_id ++ ;
        veh_info [ _v_id - 1 ] [ v_slot_id ] [ _slot_id ] = prise_vehicle_inc_id ;
    
        static const _str [ ] = "INSERT INTO `users_prise_vehicles` (`v_slot`, `v_id`, `v_item`, `v_count`, `v_date`) VALUES ('%d', '%d', '%d', '%d', '%d')" ;
        new sql_string [ sizeof _str + ( 9 * 5 ) ] ;
    	format ( sql_string, sizeof sql_string, _str, prise_vehicle_inc_id, veh_info [ _v_id - 1 ] [ v_id ], veh_info [ _v_id - 1 ] [ v_slot ] [ _slot_id ], veh_info [ _v_id - 1 ] [ v_slot_count ] [ _slot_id ], veh_info [ _v_id - 1 ] [ v_slot_date ] [ _slot_id ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	else
	{
	    static const _str [ ] = "UPDATE `users_prise_vehicles` SET `v_item` = '%d', `v_count` = '%d', `v_date` = '%d' WHERE `v_slot` = '%d' LIMIT 1" ;
        new sql_string [ sizeof _str + ( 9 * 4 ) ] ;
    	format ( sql_string, sizeof sql_string, _str, veh_info [ _v_id - 1 ] [ v_slot ] [ _slot_id ], veh_info [ _v_id - 1 ] [ v_slot_count ] [ _slot_id ], veh_info [ _v_id - 1 ] [ v_slot_date ] [ _slot_id ], veh_info [ _v_id - 1 ] [ v_slot_id ] [ _slot_id ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	
	model_info [ _i_item ] [ m_count ] += 1 ;
	set_model_count ( _i_item, model_info [ _i_item ] [ m_count ] ) ;
	
	return _slot_id ;
}

stock clear_vehicle_item ( _v_id, _i_item, _i_count, _i_slot = -1 )
{
	if ( _i_slot == -1 )
	{
	    new _slot_id = 0, sql_string [ 91 + ( 9 * 3 ) ] ;
		for ( new i = 0 ; i < MAX_WAREHOUSE_SLOT ; i ++ )
		{
		    if ( veh_info [ _v_id - 1 ] [ v_slot ] [ i ] != _i_item ) continue ;

		    _slot_id = i ;
		    break ;
		}
		
		if ( veh_info [ _v_id - 1 ] [ v_slot_count ] [ _slot_id ] - _i_count < 1 )
		{
			sql_string [ 0 ] = EOS  ;
	    	format ( sql_string, sizeof sql_string, "DELETE FROM `users_prise_vehicles` WHERE `v_slot` = '%d' LIMIT 1", veh_info [ _v_id - 1 ] [ v_slot_id ] [ _slot_id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
			
			veh_info [ _v_id - 1 ] [ v_slot_id ] [ _slot_id ] =
	    	veh_info [ _v_id - 1 ] [ v_slot ] [ _slot_id ] =
	    	veh_info [ _v_id - 1 ] [ v_slot_count ] [ _slot_id ] =
	    	veh_info [ _v_id - 1 ] [ v_slot_date ] [ _slot_id ] = 0 ;
		}
		else
		{
		    veh_info [ _v_id - 1 ] [ v_slot_count ] [ _slot_id ] -= _i_count ;

			sql_string [ 0 ] = EOS  ;
		    format ( sql_string, sizeof sql_string, "UPDATE `users_prise_vehicles` SET `v_item` = '%d', `v_count` = '%d' WHERE `v_slot` = '%d' LIMIT 1", veh_info [ _v_id - 1 ] [ v_slot ] [ _slot_id ], veh_info [ _v_id - 1 ] [ v_slot_count ] [ _slot_id ], veh_info [ _v_id - 1 ] [ v_slot_id ] [ _slot_id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
	
		model_info [ _i_item ] [ m_count ] -= 1 ;
		set_model_count ( _i_item, model_info [ _i_item ] [ m_count ] ) ;
		
		return _slot_id ;
	}
	
	if ( veh_info [ _v_id - 1 ] [ v_slot_count ] [ _i_slot ] - _i_count < 1 )
	{
		new sql_string [ 62 + 9 ] ;
	   	format ( sql_string, sizeof sql_string, "DELETE FROM `users_prise_vehicles` WHERE `v_slot` = '%d' LIMIT 1", veh_info [ _v_id - 1 ] [ v_slot_id ] [ _i_slot ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
		
		veh_info [ _v_id - 1 ] [ v_slot_id ] [ _i_slot ] =
	   	veh_info [ _v_id - 1 ] [ v_slot ] [ _i_slot ] =
	   	veh_info [ _v_id - 1 ] [ v_slot_count ] [ _i_slot ] =
	   	veh_info [ _v_id - 1 ] [ v_slot_date ] [ _i_slot ] = 0 ;
	}
	else
	{
	   	veh_info [ _v_id - 1 ] [ v_slot_count ] [ _i_slot ] -= _i_count ;

		new sql_string [ 91 + ( 9 * 3 ) ] ;
	    format ( sql_string, sizeof sql_string, "UPDATE `users_prise_vehicles` SET `v_item` = '%d', `v_count` = '%d' WHERE `v_slot` = '%d' LIMIT 1", veh_info [ _v_id - 1 ] [ v_slot ] [ _i_slot ], veh_info [ _v_id - 1 ] [ v_slot_count ] [ _i_slot ], veh_info [ _v_id - 1 ] [ v_slot_id ] [ _i_slot ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	
	model_info [ _i_item ] [ m_count ] -= 1 ;
	set_model_count ( _i_item, model_info [ _i_item ] [ m_count ] ) ;
	
	return _i_slot ;
}

stock get_vehicle_item ( _v_id, _i_item )
{
	new _i_count = 0 ;
	for ( new i = 0 ; i < MAX_WAREHOUSE_SLOT ; i ++ )
	{
	    if ( veh_info [ _v_id - 1 ] [ v_slot ] [ i ] != _i_item ) continue ;

        _i_count = veh_info [ _v_id - 1 ] [ v_slot_count ] [ i ] ;
		break ;
	}
	
	return _i_count ;
}

stock set_packet_warehouse_put ( playerid, _param1, _param2 )
{
	if ( _param1 == 3 )
	{
		new _id = get_player_use_listitem ( playerid ), _player_slot = p_info [ playerid ] [ prise_slot ] [ _id ], _h_id = GetPVarInt ( playerid, "house_id" ) ;
		if ( _h_id < 1 || _h_id > MAX_HOUSES ) return 1 ;
		
		new _slot = give_warehouse_item ( _h_id, _player_slot, 1 ) ;
		if ( _slot == -1 )
		{
			send_check_cinfo ( playerid, "В сейфе нет свободного места!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new query_string [ 144 ] ;
		format ( query_string, sizeof query_string, "%s положил(а) в сейф (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _h_id, item_name ( _player_slot ), _player_slot, 1 ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		clear_player_item_prise ( playerid, _player_slot, 1, _id ) ;
		SetInventoryItemID ( playerid, _id ) ;
		SetWarehouseItemID ( playerid, 7, _h_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != 7 ) continue ;
			if ( GetPVarInt ( i, "house_id" ) != _h_id ) continue ;
			SetWarehouseItemID ( i, 7, _h_id, _slot ) ;
		}
	}
	else if ( _param1 == 5 )
	{
		new _id = get_player_use_listitem ( playerid ), _player_slot = p_info [ playerid ] [ prise_slot ] [ _id ], _h_id = GetPVarInt ( playerid, "house_id" ) ;
		if ( _h_id < 1 || _h_id > MAX_HOUSES ) return 1 ;
		
		if ( _param2 < 1 ) _param2 = p_info [ playerid ] [ prise_slot_count ] [ _id ] ;
		if ( _param2 > p_info [ playerid ] [ prise_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "У Вас нет такого количества в инвентаре!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new _slot = give_warehouse_item ( _h_id, _player_slot, _param2 ) ;
		if ( _slot == -1 )
		{
			send_check_cinfo ( playerid, "В сейфе нет свободного места!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new query_string [ 144 ] ;
		format ( query_string, sizeof query_string, "%s положил(а) в сейф (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _h_id, item_name ( _player_slot ), _player_slot, _param2 ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		clear_player_item_prise ( playerid, _player_slot, _param2, _id ) ;
		SetInventoryItemID ( playerid, _id ) ;
		SetWarehouseItemID ( playerid, 7, _h_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != 7 ) continue ;
			if ( GetPVarInt ( i, "house_id" ) != _h_id ) continue ;
			SetWarehouseItemID ( i, 7, _h_id, _slot ) ;
		}
	}
	else if ( _param1 == 6 )
	{
		new _id = get_player_use_listitem ( playerid ), query_string [ 144 ] ;

		format ( query_string, sizeof query_string, "%s выбросил(а) из инвентаря %s (#%d)", p_info [ playerid ] [ name ], item_name ( p_info [ playerid ] [ prise_slot ] [ _id ] ), p_info [ playerid ] [ prise_slot ] [ _id ] ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		clear_player_item_prise ( playerid, p_info [ playerid ] [ prise_slot ] [ _id ], p_info [ playerid ] [ prise_slot_count ] [ _id ], _id ) ;
	}
	hideSelectorDialog ( playerid ) ;
	return 1 ;
}

stock set_packet_warehouse_get ( playerid, _param1, _param2 )
{
	if ( _param1 == 3 )
	{
		new _id = get_player_use_listitem ( playerid ), _h_id = GetPVarInt ( playerid, "house_id" ), _h_slot = h_info [ _h_id - 1 ] [ h_slot ] [ _id ], query_string [ 144 ] ;
		if ( _h_id < 1 || _h_id > MAX_HOUSES ) return 1 ;
		
		if ( 1 > h_info [ _h_id - 1 ] [ h_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "В сейфе нет такого количества!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new _max_slot = item_max_in_slot ( _h_slot ) ;
		if ( _max_slot != -1 && p_info [ playerid ] [ prise_slot_count ] [ get_player_item_prise ( playerid, _h_slot ) ] + 1 > _max_slot )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "Вы не можете переносить более %d шт. выбранного предмета.", _max_slot ) ;
			send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		format ( query_string, sizeof query_string, "%s взял(а) из сейфа (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _h_id, item_name ( _h_slot ), _h_slot, 1 ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		give_player_item_prise ( playerid, _h_slot, 1 ) ;
		new _slot = clear_warehouse_item ( _h_id, _h_slot, 1, _id ) ;
		SetWarehouseItemID ( playerid, 7, _h_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != 7 ) continue ;
			if ( GetPVarInt ( i, "house_id" ) != _h_id ) continue ;
			SetWarehouseItemID ( i, 7, _h_id, _slot ) ;
		}
	}
	else if ( _param1 == 5 )
	{
		new _id = get_player_use_listitem ( playerid ), _h_id = GetPVarInt ( playerid, "house_id" ), _h_slot = h_info [ _h_id - 1 ] [ h_slot ] [ _id ], query_string [ 144 ] ;
		if ( _h_id < 1 || _h_id > MAX_HOUSES ) return 1 ;
		
		if ( _param2 < 1 ) _param2 = h_info [ _h_id - 1 ] [ h_slot_count ] [ _id ] ;
		if ( _param2 > h_info [ _h_id - 1 ] [ h_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "В сейфе нет такого количества!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new _max_slot = item_max_in_slot ( _h_slot ) ;
		if ( _max_slot != -1 && p_info [ playerid ] [ prise_slot_count ] [ get_player_item_prise ( playerid, _h_slot ) ] + _param2 > _max_slot )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "Вы не можете переносить более %d шт. выбранного предмета.", _max_slot ) ;
			send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		format ( query_string, sizeof query_string, "%s взял(а) из сейфа (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _h_id, item_name ( _h_slot ), _h_slot, _param2 ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		give_player_item_prise ( playerid, _h_slot, _param2 ) ;
		new _slot = clear_warehouse_item ( _h_id, _h_slot, _param2, _id ) ;
		SetWarehouseItemID ( playerid, 7, _h_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != 7 ) continue ;
			if ( GetPVarInt ( i, "house_id" ) != _h_id ) continue ;
			SetWarehouseItemID ( i, 7, _h_id, _slot ) ;
		}
	}
	else if ( _param1 == 6 )
	{
		new _id = get_player_use_listitem ( playerid ), _h_id = GetPVarInt ( playerid, "house_id" ), _h_slot = h_info [ _h_id - 1 ] [ h_slot ] [ _id ], query_string [ 144 ] ;
		if ( _h_id < 1 || _h_id > MAX_HOUSES ) return 1 ;
		
		format ( query_string, sizeof query_string, "%s выбросил(а) из сейфа (#%d) %s (#%d)", p_info [ playerid ] [ name ], _h_id, item_name ( _h_slot ), _h_slot ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		new _slot = clear_warehouse_item ( _h_id, _h_slot, h_info [ _h_id - 1 ] [ h_slot_count ] [ _id ], _id ) ;
		SetWarehouseItemID ( playerid, 7, _h_id, _slot ) ;
		
		foreach(new i: streamed_players[playerid])
		{
			if ( player_inventory { i } != 7 ) continue ;
			if ( GetPVarInt ( i, "house_id" ) != _h_id ) continue ;
			SetWarehouseItemID ( i, 7, _h_id, _slot ) ;
		}
	}
	hideSelectorDialog ( playerid ) ;
	return 1 ;
}

stock give_warehouse_item ( _h_id, _i_item, _i_count, _day = 20 )
{
	if ( _i_item < 1 ) return 1 ;

	new bool: _free_slot = false, _insert_slot = false, _slot_id = 0, _slot ;
	for ( new i = 0 ; i < MAX_WAREHOUSE_SLOT ; i ++ )
	{
		_slot = h_info [ _h_id - 1 ] [ h_slot ] [ i ] ;
	    if ( _slot > 0 )
		{
			if ( _slot == _i_item )
			{
			    _slot_id = i ;
	    		_free_slot = true ;
	    		_insert_slot = false ;
	    		break ;
			}
			continue ;
	    }
	    else
		{
			if ( _free_slot == false )
			{
				_slot_id = i ;
				_free_slot = true ;
				_insert_slot = true ;
			}
		}
	}
	
	if ( _free_slot == false ) return -1 ;
	if ( h_info [ _h_id - 1 ] [ h_slot_count ] [ _slot_id ] + _i_count > 1_000_000_000 ) return -1 ;
	
	h_info [ _h_id - 1 ] [ h_slot ] [ _slot_id ] = _i_item ;
	h_info [ _h_id - 1 ] [ h_slot_count ] [ _slot_id ] += _i_count ;
	if ( _day != -1 ) h_info [ _h_id - 1 ] [ h_slot_date ] [ _slot_id ] = SetElapsedTime ( gettime ( ), _day, CONVERT_TIME_TO_DAYS ) ;
	else h_info [ _h_id - 1 ] [ h_slot_date ] [ _slot_id ] = -1 ;
	
    if ( _insert_slot )
    {
        prise_house_inc_id ++ ;
        h_info [ _h_id - 1 ] [ h_slot_id ] [ _slot_id ] = prise_house_inc_id ;
    
        static const _str [ ] = "INSERT INTO `users_prise_houses` (`h_slot`, `h_id`, `h_item`, `h_count`, `h_date`) VALUES ('%d', '%d', '%d', '%d', '%d')" ;
        new sql_string [ sizeof _str + ( 9 * 5 ) ] ;
    	format ( sql_string, sizeof sql_string, _str, prise_house_inc_id, h_info [ _h_id - 1 ] [ h_id ], h_info [ _h_id - 1 ] [ h_slot ] [ _slot_id ], h_info [ _h_id - 1 ] [ h_slot_count ] [ _slot_id ], h_info [ _h_id - 1 ] [ h_slot_date ] [ _slot_id ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	else
	{
	    static const _str [ ] = "UPDATE `users_prise_houses` SET `h_item` = '%d', `h_count` = '%d', `h_date` = '%d' WHERE `h_slot` = '%d' LIMIT 1" ;
        new sql_string [ sizeof _str + ( 9 * 4 ) ] ;
    	format ( sql_string, sizeof sql_string, _str, h_info [ _h_id - 1 ] [ h_slot ] [ _slot_id ], h_info [ _h_id - 1 ] [ h_slot_count ] [ _slot_id ], h_info [ _h_id - 1 ] [ h_slot_date ] [ _slot_id ], h_info [ _h_id - 1 ] [ h_slot_id ] [ _slot_id ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	
	model_info [ _i_item ] [ m_count ] += 1 ;
	set_model_count ( _i_item, model_info [ _i_item ] [ m_count ] ) ;
	
	return _slot_id ;
}

stock clear_warehouse_item ( _h_id, _i_item, _i_count, _i_slot = -1 )
{
	if ( _i_slot == -1 )
	{
	    new _slot_id = 0, sql_string [ 91 + ( 9 * 3 ) ] ;
		for ( new i = 0 ; i < MAX_WAREHOUSE_SLOT ; i ++ )
		{
		    if ( h_info [ _h_id - 1 ] [ h_slot ] [ i ] != _i_item ) continue ;

		    _slot_id = i ;
		    break ;
		}
		
		if ( h_info [ _h_id - 1 ] [ h_slot_count ] [ _slot_id ] - _i_count < 1 )
		{
			sql_string [ 0 ] = EOS  ;
	    	format ( sql_string, sizeof sql_string, "DELETE FROM `users_prise_houses` WHERE `h_slot` = '%d' LIMIT 1", h_info [ _h_id - 1 ] [ h_slot_id ] [ _slot_id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
			
			h_info [ _h_id - 1 ] [ h_slot_id ] [ _slot_id ] =
	    	h_info [ _h_id - 1 ] [ h_slot ] [ _slot_id ] =
	    	h_info [ _h_id - 1 ] [ h_slot_count ] [ _slot_id ] =
	    	h_info [ _h_id - 1 ] [ h_slot_date ] [ _slot_id ] = 0 ;
		}
		else
		{
		    h_info [ _h_id - 1 ] [ h_slot_count ] [ _slot_id ] -= _i_count ;

			sql_string [ 0 ] = EOS  ;
		    format ( sql_string, sizeof sql_string, "UPDATE `users_prise_houses` SET `h_item` = '%d', `h_count` = '%d' WHERE `h_slot` = '%d' LIMIT 1", h_info [ _h_id - 1 ] [ h_slot ] [ _slot_id ], h_info [ _h_id - 1 ] [ h_slot_count ] [ _slot_id ], h_info [ _h_id - 1 ] [ h_slot_id ] [ _slot_id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
	
		model_info [ _i_item ] [ m_count ] -= 1 ;
		set_model_count ( _i_item, model_info [ _i_item ] [ m_count ] ) ;
		
		return _slot_id ;
	}
	
	if ( h_info [ _h_id - 1 ] [ h_slot_count ] [ _i_slot ] - _i_count < 1 )
	{
		new sql_string [ 62 + 9 ] ;
	   	format ( sql_string, sizeof sql_string, "DELETE FROM `users_prise_houses` WHERE `h_slot` = '%d' LIMIT 1", h_info [ _h_id - 1 ] [ h_slot_id ] [ _i_slot ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
		
		h_info [ _h_id - 1 ] [ h_slot_id ] [ _i_slot ] =
	   	h_info [ _h_id - 1 ] [ h_slot ] [ _i_slot ] =
	   	h_info [ _h_id - 1 ] [ h_slot_count ] [ _i_slot ] =
	   	h_info [ _h_id - 1 ] [ h_slot_date ] [ _i_slot ] = 0 ;
	}
	else
	{
	   	h_info [ _h_id - 1 ] [ h_slot_count ] [ _i_slot ] -= _i_count ;

		new sql_string [ 91 + ( 9 * 3 ) ] ;
	    format ( sql_string, sizeof sql_string, "UPDATE `users_prise_houses` SET `h_item` = '%d', `h_count` = '%d' WHERE `h_slot` = '%d' LIMIT 1", h_info [ _h_id - 1 ] [ h_slot ] [ _i_slot ], h_info [ _h_id - 1 ] [ h_slot_count ] [ _i_slot ], h_info [ _h_id - 1 ] [ h_slot_id ] [ _i_slot ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	
	model_info [ _i_item ] [ m_count ] -= 1 ;
	set_model_count ( _i_item, model_info [ _i_item ] [ m_count ] ) ;
	
	return _i_slot ;
}

stock set_packet_family_put ( playerid, _param1, _param2 )
{
	if ( _param1 == 3 )
	{
		new _id = get_player_use_listitem ( playerid ),
			_fam_id = p_info [ playerid ] [ family ],
			_player_slot = p_info [ playerid ] [ prise_slot ] [ _id ] ;
			
		if ( _fam_id < 1 ) return 1 ;
		
		new _slot = give_family_item ( _fam_id, _player_slot, 1 ) ;
		if ( _slot == -1 )
		{
			send_check_cinfo ( playerid, "В семье нет свободного места!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new query_string [ 144 ] ;
		format ( query_string, sizeof query_string, "%s положил(а) в семью (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _fam_id, item_name ( _player_slot ), _player_slot, 1 ) ;
		write_family ( playerid, _fam_id, TYPE_LOG_INVENTORY, query_string ) ;
		
		format ( query_string, sizeof ( query_string ), "{%s}[FAM] %s %s положил(а) на склад %s (1 шт.).", family_info [ _fam_id - 1 ] [ fam_chat_color ], family_rank [ _fam_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], item_name ( _player_slot ) ) ;
    	family_message ( _fam_id, col_gray, query_string ) ;
		
		clear_player_item_prise ( playerid, _player_slot, 1, _id ) ;
		SetInventoryItemID ( playerid, _id ) ;
		SetWarehouseItemID ( playerid, 10, _fam_id, _slot ) ;
		
		foreach(new i: family_players[_fam_id])
		{
			if ( player_inventory { i } != 10 ) continue ;
			SetWarehouseItemID ( i, 10, _fam_id, _slot ) ;
		}
	}
	else if ( _param1 == 5 )
	{
		new _id = get_player_use_listitem ( playerid ),
			_fam_id = p_info [ playerid ] [ family ],
			_player_slot = p_info [ playerid ] [ prise_slot ] [ _id ] ;
			
		if ( _fam_id < 1 ) return 1 ;
		
		if ( _param2 < 1 ) _param2 = p_info [ playerid ] [ prise_slot_count ] [ _id ] ;
		if ( _param2 > p_info [ playerid ] [ prise_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "У Вас нет такого количества в инвентаре!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new _slot = give_family_item ( _fam_id, _player_slot, _param2 ) ;
		if ( _slot == -1 )
		{
			send_check_cinfo ( playerid, "В семье нет свободного места!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new query_string [ 144 ] ;
		format ( query_string, sizeof query_string, "%s положил(а) в семью (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _fam_id, item_name ( _player_slot ), _player_slot, _param2 ) ;
		write_family ( playerid, _fam_id, TYPE_LOG_INVENTORY, query_string ) ;
		
		format ( query_string, sizeof ( query_string ), "{%s}[FAM] %s %s положил(а) на склад %s (%d шт.).", family_info [ _fam_id - 1 ] [ fam_chat_color ], family_rank [ _fam_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], item_name ( _player_slot ), _param2 ) ;
    	family_message ( _fam_id, col_gray, query_string ) ;
		
		clear_player_item_prise ( playerid, _player_slot, _param2, _id ) ;
		SetInventoryItemID ( playerid, _id ) ;
		SetWarehouseItemID ( playerid, 10, _fam_id, _slot ) ;
		
		foreach(new i: family_players[_fam_id])
		{
			if ( player_inventory { i } != 10 ) continue ;
			SetWarehouseItemID ( i, 10, _fam_id, _slot ) ;
		}
	}
	else if ( _param1 == 6 )
	{
		new _id = get_player_use_listitem ( playerid ), query_string [ 144 ] ;

		format ( query_string, sizeof query_string, "%s выбросил(а) из инвентаря %s (#%d)", p_info [ playerid ] [ name ], item_name ( p_info [ playerid ] [ prise_slot ] [ _id ] ), p_info [ playerid ] [ prise_slot ] [ _id ] ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		clear_player_item_prise ( playerid, p_info [ playerid ] [ prise_slot ] [ _id ], p_info [ playerid ] [ prise_slot_count ] [ _id ], _id ) ;
	}
	hideSelectorDialog ( playerid ) ;
	return 1 ;
}

stock set_packet_family_get ( playerid, _param1, _param2 )
{
	if ( _param1 == 3 )
	{
		new _id = get_player_use_listitem ( playerid ),
			_fam_id = p_info [ playerid ] [ family ],
			_fam_slot = family_info [ _fam_id - 1 ] [ fam_slot ] [ _id ],
			query_string [ 144 ] ;
			
		if ( _fam_id < 1 ) return 1 ;
		
		if ( 1 > family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "В семье нет такого количества!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		if ( item_not_get ( _fam_slot ) )
		{
			send_check_cinfo ( playerid, "Вы не можете взять данный предмет!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new _max_slot = item_max_in_slot ( _fam_slot ) ;
		if ( _max_slot != -1 && p_info [ playerid ] [ prise_slot_count ] [ get_player_item_prise ( playerid, _fam_slot ) ] + 1 > _max_slot )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "Вы не можете переносить более %d шт. выбранного предмета.", _max_slot ) ;
			send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		format ( query_string, sizeof query_string, "%s взял(а) из семьи (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _fam_id, item_name ( _fam_slot ), _fam_slot, 1 ) ;
		write_family ( playerid, _fam_id, TYPE_LOG_INVENTORY, query_string ) ;
		
		format ( query_string, sizeof ( query_string ), "{%s}[FAM] %s %s взял(а) со склада %s (1 шт.).", family_info [ _fam_id - 1 ] [ fam_chat_color ], family_rank [ _fam_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], item_name ( _fam_slot ) ) ;
    	family_message ( _fam_id, col_gray, query_string ) ;
		
		give_player_item_prise ( playerid, _fam_slot, 1 ) ;
		new _slot = clear_family_item ( _fam_id, _fam_slot, 1, _id ) ;
		SetWarehouseItemID ( playerid, 10, _fam_id, _slot ) ;
		
		foreach(new i: family_players[_fam_id])
		{
			if ( player_inventory { i } != 10 ) continue ;
			SetWarehouseItemID ( i, 10, _fam_id, _slot ) ;
		}
	}
	else if ( _param1 == 4 )
	{
		new _id = get_player_use_listitem ( playerid ),
			_fam_id = p_info [ playerid ] [ family ],
			_fam_slot = family_info [ _fam_id - 1 ] [ fam_slot ] [ _id ],
			query_string [ 144 ] ;
			
		if ( _fam_id < 1 ) return 1 ;
		
		if ( 1 > family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "В семье нет такого количества!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		if ( item_not_get ( _fam_slot ) )
		{
			new bool: _warehouse = false ;
			if ( _fam_slot == 164 )
			{
				if ( get_family_item ( _fam_id, 348 ) > 1000 ) _warehouse = true ;
			}
			else if ( _fam_slot == 165 )
			{
				if ( get_family_item ( _fam_id, 355 ) > 1000 ) _warehouse = true ;
			}
			else if ( _fam_slot == 166 )
			{
				if ( get_family_item ( _fam_id, 356 ) > 1000 ) _warehouse = true ;
			}
			else if ( _fam_slot == 167 )
			{
				if ( get_family_item ( _fam_id, 154 ) > 10000 ) _warehouse = true ;
			}
			else if ( _fam_slot == 168 )
			{
				if ( get_family_item ( _fam_id, 1244 ) > 1000 ) _warehouse = true ;
			}
			else if ( _fam_slot == 169 )
			{
				if ( get_family_item ( _fam_id, 347 ) > 1000 ) _warehouse = true ;
			}
			else if ( _fam_slot == 170 )
			{
				if ( get_family_item ( _fam_id, 349 ) > 1000 ) _warehouse = true ;
			}
			
			if ( _warehouse )
			{
				send_check_cinfo ( playerid, "Вы не можете открыть выбранный ящик!\nНа Вашем складе слишком много данного вида вооружения.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				hideSelectorDialog ( playerid ) ;
				return 1 ;
			}
			
			new _slot = clear_family_item ( _fam_id, _fam_slot, 1, _id ) ;
			
			format ( query_string, sizeof query_string, "%s открыл(а) ящик (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _fam_id, item_name ( _fam_slot ), _fam_slot, 1 ) ;
			write_family ( playerid, _fam_id, TYPE_LOG_INVENTORY, query_string ) ;
			
			format ( query_string, sizeof ( query_string ), "{%s}[FAM] %s %s открыл(а) ящик %s (1 шт.).", family_info [ _fam_id - 1 ] [ fam_chat_color ], family_rank [ _fam_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], item_name ( _fam_slot ) ) ;
			family_message ( _fam_id, col_gray, query_string ) ;
			
			SetWarehouseItemID ( playerid, 10, _fam_id, _slot ) ;
		
			foreach(new i: family_players[_fam_id])
			{
				if ( player_inventory { i } != 10 ) continue ;
				SetWarehouseItemID ( i, 10, _fam_id, _slot ) ;
			}
			
			_slot = -1 ;
			if ( _fam_slot == 164 ) _slot = give_family_item ( _fam_id, 348, 10 ) ;
			else if ( _fam_slot == 165 ) _slot = give_family_item ( _fam_id, 355, 10 ) ;
			else if ( _fam_slot == 166 ) _slot = give_family_item ( _fam_id, 356, 10 ) ;
			else if ( _fam_slot == 167 ) _slot = give_family_item ( _fam_id, 154, 100 ) ;
			else if ( _fam_slot == 168 ) _slot = give_family_item ( _fam_id, 1244, 3 ) ;
			else if ( _fam_slot == 169 ) _slot = give_family_item ( _fam_id, 347, 10 ) ;
			else if ( _fam_slot == 170 ) _slot = give_family_item ( _fam_id, 349, 10 ) ;
			
			if ( _slot != -1 )
			{
				SetWarehouseItemID ( playerid, 10, _fam_id, _slot ) ;
			
				foreach(new i: family_players[_fam_id])
				{
					if ( player_inventory { i } != 10 ) continue ;
					SetWarehouseItemID ( i, 10, _fam_id, _slot ) ;
				}
			}
		}
	}
	else if ( _param1 == 5 )
	{
		new _id = get_player_use_listitem ( playerid ),
			_fam_id = p_info [ playerid ] [ family ],
			_fam_slot = family_info [ _fam_id - 1 ] [ fam_slot ] [ _id ],
			query_string [ 144 ] ;
			
		if ( _fam_id < 1 ) return 1 ;
		
		if ( _param2 < 1 ) _param2 = family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _id ] ;
		if ( _param2 > family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "В семье нет такого количества!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		if ( item_not_get ( _fam_slot ) )
		{
			send_check_cinfo ( playerid, "Вы не можете взять данный предмет!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new _max_slot = item_max_in_slot ( _fam_slot ) ;
		if ( _max_slot != -1 && p_info [ playerid ] [ prise_slot_count ] [ get_player_item_prise ( playerid, _fam_slot ) ] + _param2 > _max_slot )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "Вы не можете переносить более %d шт. выбранного предмета.", _max_slot ) ;
			send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		format ( query_string, sizeof query_string, "%s взял(а) из семьи (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _fam_id, item_name ( _fam_slot ), _fam_slot, _param2 ) ;
		write_family ( playerid, _fam_id, TYPE_LOG_INVENTORY, query_string ) ;
		
		format ( query_string, sizeof ( query_string ), "{%s}[FAM] %s %s взял(а) со склада %s (%d шт.).", family_info [ _fam_id - 1 ] [ fam_chat_color ], family_rank [ _fam_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], item_name ( _fam_slot ), _param2 ) ;
    	family_message ( _fam_id, col_gray, query_string ) ;
		
		give_player_item_prise ( playerid, _fam_slot, _param2 ) ;
		new _slot = clear_family_item ( _fam_id, _fam_slot, _param2, _id ) ;
		SetWarehouseItemID ( playerid, 10, _fam_id, _slot ) ;
		
		foreach(new i: family_players[_fam_id])
		{
			if ( player_inventory { i } != 10 ) continue ;
			SetWarehouseItemID ( i, 10, _fam_id, _slot ) ;
		}
	}
	else if ( _param1 == 6 )
	{
		new _id = get_player_use_listitem ( playerid ),
			_fam_id = p_info [ playerid ] [ family ],
			_fam_slot = family_info [ _fam_id - 1 ] [ fam_slot ] [ _id ],
			query_string [ 144 ] ;
			
		if ( _fam_id < 1 ) return 1 ;
		
		format ( query_string, sizeof query_string, "%s выбросил(а) из семьи (#%d) %s (#%d)", p_info [ playerid ] [ name ], _fam_id, item_name ( _fam_slot ), _fam_slot ) ;
		write_family ( playerid, _fam_id, TYPE_LOG_INVENTORY, query_string ) ;
		
		format ( query_string, sizeof ( query_string ), "{%s}[FAM] %s %s выбросил(а) со склада %s.", family_info [ _fam_id - 1 ] [ fam_chat_color ], family_rank [ _fam_id - 1 ] [ p_info [ playerid ] [ family_rang ] - 1 ], p_info [ playerid ] [ name ], item_name ( _fam_slot ) ) ;
    	family_message ( _fam_id, col_gray, query_string ) ;
		
		new _slot = clear_family_item ( _fam_id, _fam_slot, family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _id ], _id ) ;
		SetWarehouseItemID ( playerid, 10, _fam_id, _slot ) ;
		
		foreach(new i: family_players[_fam_id])
		{
			if ( player_inventory { i } != 10 ) continue ;
			SetWarehouseItemID ( i, 10, _fam_id, _slot ) ;
		}
	}
	hideSelectorDialog ( playerid ) ;
	return 1 ;
}

stock give_family_item ( _fam_id, _i_item, _i_count, _day = 20 )
{
	if ( _i_item < 1 ) return 1 ;

	new bool: _free_slot = false, _insert_slot = false, _slot_id = 0, _slot ;
	for ( new i = 0 ; i < MAX_FAMILY_WAREHOUSE ; i ++ )
	{
		_slot = family_info [ _fam_id - 1 ] [ fam_slot ] [ i ] ;
	    if ( _slot > 0 )
		{
			if ( _slot == _i_item )
			{
			    _slot_id = i ;
	    		_free_slot = true ;
	    		_insert_slot = false ;
	    		break ;
			}
			continue ;
	    }
	    else
		{
			if ( _free_slot == false )
			{
				_slot_id = i ;
				_free_slot = true ;
				_insert_slot = true ;
			}
		}
	}
	
	if ( _free_slot == false ) return -1 ;
	if ( family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _slot_id ] + _i_count > 1_000_000_000 ) return -1 ;
	
	family_info [ _fam_id - 1 ] [ fam_slot ] [ _slot_id ] = _i_item ;
	family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _slot_id ] += _i_count ;
	if ( _day != -1 ) family_info [ _fam_id - 1 ] [ fam_slot_date ] [ _slot_id ] = SetElapsedTime ( gettime ( ), _day, CONVERT_TIME_TO_DAYS ) ;
	else family_info [ _fam_id - 1 ] [ fam_slot_date ] [ _slot_id ] = -1 ;
	
    if ( _insert_slot )
    {
        prise_family_inc_id ++ ;
        family_info [ _fam_id - 1 ] [ fam_slot_id ] [ _slot_id ] = prise_family_inc_id ;
    
        static const _str [ ] = "INSERT INTO `family_prise` (`fam_slot`, `fam_id`, `fam_item`, `fam_count`, `fam_date`) VALUES ('%d', '%d', '%d', '%d', '%d')" ;
        new sql_string [ sizeof _str + ( 9 * 5 ) ] ;
    	format ( sql_string, sizeof sql_string, _str, prise_family_inc_id, family_info [ _fam_id - 1 ] [ fam_id ], family_info [ _fam_id - 1 ] [ fam_slot ] [ _slot_id ], family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _slot_id ], family_info [ _fam_id - 1 ] [ fam_slot_date ] [ _slot_id ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	else
	{
	    static const _str [ ] = "UPDATE `family_prise` SET `fam_item` = '%d', `fam_count` = '%d', `fam_date` = '%d' WHERE `fam_slot` = '%d' LIMIT 1" ;
        new sql_string [ sizeof _str + ( 9 * 4 ) ] ;
    	format ( sql_string, sizeof sql_string, _str, family_info [ _fam_id - 1 ] [ fam_slot ] [ _slot_id ], family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _slot_id ], family_info [ _fam_id - 1 ] [ fam_slot_date ] [ _slot_id ], family_info [ _fam_id - 1 ] [ fam_slot_id ] [ _slot_id ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	
	model_info [ _i_item ] [ m_count ] += 1 ;
	set_model_count ( _i_item, model_info [ _i_item ] [ m_count ] ) ;
	
	return _slot_id ;
}

stock clear_family_item ( _fam_id, _i_item, _i_count, _i_slot = -1 )
{
	if ( _i_slot == -1 )
	{
	    new _slot_id = 0, sql_string [ 91 + ( 9 * 3 ) ] ;
		for ( new i = 0 ; i < MAX_FAMILY_WAREHOUSE ; i ++ )
		{
		    if ( family_info [ _fam_id - 1 ] [ fam_slot ] [ i ] != _i_item ) continue ;

		    _slot_id = i ;
		    break ;
		}
		
		if ( family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _slot_id ] - _i_count < 1 )
		{
			sql_string [ 0 ] = EOS  ;
	    	format ( sql_string, sizeof sql_string, "DELETE FROM `family_prise` WHERE `fam_slot` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_slot_id ] [ _slot_id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
			
			family_info [ _fam_id - 1 ] [ fam_slot_id ] [ _slot_id ] =
	    	family_info [ _fam_id - 1 ] [ fam_slot ] [ _slot_id ] =
	    	family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _slot_id ] =
	    	family_info [ _fam_id - 1 ] [ fam_slot_date ] [ _slot_id ] = 0 ;
		}
		else
		{
		    family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _slot_id ] -= _i_count ;

			sql_string [ 0 ] = EOS  ;
		    format ( sql_string, sizeof sql_string, "UPDATE `family_prise` SET `fam_item` = '%d', `fam_count` = '%d' WHERE `fam_slot` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_slot ] [ _slot_id ], family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _slot_id ], family_info [ _fam_id - 1 ] [ fam_slot_id ] [ _slot_id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
	
		model_info [ _i_item ] [ m_count ] -= 1 ;
		set_model_count ( _i_item, model_info [ _i_item ] [ m_count ] ) ;
		
		return _slot_id ;
	}
	
	if ( family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _i_slot ] - _i_count < 1 )
	{
		new sql_string [ 62 + 9 ] ;
	   	format ( sql_string, sizeof sql_string, "DELETE FROM `family_prise` WHERE `fam_slot` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_slot_id ] [ _i_slot ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
		
		family_info [ _fam_id - 1 ] [ fam_slot_id ] [ _i_slot ] =
	   	family_info [ _fam_id - 1 ] [ fam_slot ] [ _i_slot ] =
	   	family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _i_slot ] =
	   	family_info [ _fam_id - 1 ] [ fam_slot_date ] [ _i_slot ] = 0 ;
	}
	else
	{
	   	family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _i_slot ] -= _i_count ;

		new sql_string [ 91 + ( 9 * 3 ) ] ;
	    format ( sql_string, sizeof sql_string, "UPDATE `family_prise` SET `fam_item` = '%d', `fam_count` = '%d' WHERE `fam_slot` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_slot ] [ _i_slot ], family_info [ _fam_id - 1 ] [ fam_slot_count ] [ _i_slot ], family_info [ _fam_id - 1 ] [ fam_slot_id ] [ _i_slot ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	
	model_info [ _i_item ] [ m_count ] -= 1 ;
	set_model_count ( _i_item, model_info [ _i_item ] [ m_count ] ) ;
	
	return _i_slot ;
}

stock get_family_item ( _fam_id, _i_item )
{
	new _i_count = 0 ;
	for ( new i = 0 ; i < MAX_FAMILY_WAREHOUSE ; i ++ )
	{
	    if ( family_info [ _fam_id - 1 ] [ fam_slot ] [ i ] != _i_item ) continue ;

        _i_count = family_info [ _fam_id - 1 ] [ fam_slot_count ] [ i ] ;
		break ;
	}
	
	return _i_count ;
}

stock set_packet_fraction_put ( playerid, _param1, _param2 )
{
	if ( _param1 == 3 )
	{
		new _id = get_player_use_listitem ( playerid ), 
			_f_id = p_info [ playerid ] [ member ],
			_player_slot = p_info [ playerid ] [ prise_slot ] [ _id ] ;
			
		if ( _f_id < 1 ) return 1 ;
		
		if ( ! item_not_put ( _player_slot ) )
		{
			send_check_cinfo ( playerid, "Выбранный предмет нельзя положить на склад организации!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new _slot = give_fraction_item ( _f_id, _player_slot, 1, -1 ) ;
		if ( _slot == -1 )
		{
			send_check_cinfo ( playerid, "В организации нет свободного места!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new query_string [ 144 ] ;
		format ( query_string, sizeof query_string, "%s положил(а) в организацию (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _f_id, item_name ( _player_slot ), _player_slot, 1 ) ;
		write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
		
		if ( gang_player ( playerid ) || mafia_player ( playerid ) ) format ( query_string, sizeof ( query_string ), "[F] %s %s [id %d] положил(а) на склад {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, _param2, item_name ( _player_slot ) ) ;
		else format ( query_string, sizeof ( query_string ), "[R] %s %s [id %d] положил(а) на склад {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, 1, item_name ( _player_slot ) ) ;
		fraction_message ( _f_id, col_lblue, query_string ) ;
		
		clear_player_item_prise ( playerid, _player_slot, 1, _id ) ;
		SetInventoryItemID ( playerid, _id ) ;
		SetWarehouseItemID ( playerid, 11, _f_id, _slot ) ;
		
		foreach(new i: fraction_players[_f_id])
		{
			if ( player_inventory { i } != 11 ) continue ;
			SetWarehouseItemID ( i, 11, _f_id, _slot ) ;
		}
	}
	else if ( _param1 == 5 )
	{
		new _id = get_player_use_listitem ( playerid ), 
			_f_id = p_info [ playerid ] [ member ],
			_player_slot = p_info [ playerid ] [ prise_slot ] [ _id ] ;
			
		if ( _f_id < 1 ) return 1 ;
		
		if ( ! item_not_put ( _player_slot ) )
		{
			send_check_cinfo ( playerid, "Выбранный предмет нельзя положить на склад организации!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		if ( _param2 < 1 ) _param2 = p_info [ playerid ] [ prise_slot_count ] [ _id ] ;
		if ( _param2 > p_info [ playerid ] [ prise_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "У Вас нет такого количества в инвентаре!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new _slot = give_fraction_item ( _f_id, _player_slot, _param2, -1 ) ;
		if ( _slot == -1 )
		{
			send_check_cinfo ( playerid, "В организации нет свободного места!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new query_string [ 144 ] ;
		format ( query_string, sizeof query_string, "%s положил(а) в организацию (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _f_id, item_name ( _player_slot ), _player_slot, _param2 ) ;
		write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
		
		if ( gang_player ( playerid ) || mafia_player ( playerid ) ) format ( query_string, sizeof ( query_string ), "[F] %s %s [id %d] положил(а) на склад {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, _param2, item_name ( _player_slot ) ) ;
		else format ( query_string, sizeof ( query_string ), "[R] %s %s [id %d] положил(а) на склад {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, _param2, item_name ( _player_slot ) ) ;
		fraction_message ( _f_id, col_lblue, query_string ) ;
		
		clear_player_item_prise ( playerid, _player_slot, _param2, _id ) ;
		SetInventoryItemID ( playerid, _id ) ;
		
		foreach(new i: fraction_players[_f_id])
		{
			if ( player_inventory { i } != 11 ) continue ;
			SetWarehouseItemID ( i, 11, _f_id, _slot ) ;
		}
	}
	else if ( _param1 == 6 )
	{
		new _id = get_player_use_listitem ( playerid ), query_string [ 144 ] ;

		format ( query_string, sizeof query_string, "%s выбросил(а) из инвентаря %s (#%d)", p_info [ playerid ] [ name ], item_name ( p_info [ playerid ] [ prise_slot ] [ _id ] ), p_info [ playerid ] [ prise_slot ] [ _id ] ) ;
		WriteLog ( playerid, TYPE_LOG_INVENTORY, query_string ) ;
		
		clear_player_item_prise ( playerid, p_info [ playerid ] [ prise_slot ] [ _id ], p_info [ playerid ] [ prise_slot_count ] [ _id ], _id ) ;
	}
	hideSelectorDialog ( playerid ) ;
	return 1 ;
}

stock set_packet_fraction_get ( playerid, _param1, _param2 )
{
	if ( _param1 == 3 )
	{
		new _id = get_player_use_listitem ( playerid ), 
			_f_id = p_info [ playerid ] [ member ],
			_f_slot = f_info [ _f_id - 1 ] [ f_slot ] [ _id ],
			query_string [ 144 ] ;
			
		if ( _f_id < 1 ) return 1 ;
		
		if ( p_t_info [ playerid ] [ slot_cooldown ] [ _id ] > gettime ( ) )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "Выбранный предмет можно будет взять через %d сек.", p_t_info [ playerid ] [ slot_cooldown ] [ _id ] - gettime ( ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		else p_t_info [ playerid ] [ slot_limit ] [ _id ] = 0 ;
		
		if ( _f_slot != 153 && _f_slot != 154 && _f_slot != 155 )
		{
			if ( p_t_info [ playerid ] [ slot_limit ] [ _id ] > 1 )
			{
				send_check_cinfo ( playerid, "Лимит на предмет составляет 1 шт.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			if ( ! gang_player ( playerid ) && ! mafia_player ( playerid ) ) p_t_info [ playerid ] [ slot_cooldown ] [ _id ] = gettime ( ) + 600 ;
			else p_t_info [ playerid ] [ slot_cooldown ] [ _id ] = gettime ( ) + 300 ;
		}
		else
		{
			if ( p_t_info [ playerid ] [ slot_limit ] [ _id ] > 500 )
			{
				send_check_cinfo ( playerid, "Лимит на патроны составляет 500 шт.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
		}
		
		if ( 1 > f_info [ _f_id - 1 ] [ f_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "В организации нет такого количества!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		new _slot = clear_fraction_item ( _f_id, _f_slot, 1, _id ) ;
		if ( item_not_get ( _f_slot ) )
		{
			if ( box_submarine [ playerid ] > 0 )
			{
				send_check_cinfo ( playerid, "У Вас уже есть ящик в руках. Отнесите и положите его в фургон!", 0, 300, CINFO_INVENTORY_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
				return 1 ;
			}

			format ( query_string, sizeof query_string, "%s взял(а) из организации (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _f_id, item_name ( _f_slot ), _f_slot, 1 ) ;
			write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
			
			send_check_cinfo ( playerid, "Отнесите ящик в фургон!", 0, 300, CINFO_INVENTORY_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
			
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
			SetPlayerAttachedObject ( playerid, 0, 3013, 6,0.0,0.10,-0.2, -110.0,0.0,78.0 ) ;
			
			have_box [ playerid ] = true ;
            if ( _f_slot == 164 ) box_submarine [ playerid ] = 1 ;
			else if ( _f_slot == 165 ) box_submarine [ playerid ] = 2 ;
			else if ( _f_slot == 166 ) box_submarine [ playerid ] = 3 ;
			else if ( _f_slot == 167 ) box_submarine [ playerid ] = 4 ;
			else if ( _f_slot == 168 ) box_submarine [ playerid ] = 5 ;
			else if ( _f_slot == 169 ) box_submarine [ playerid ] = 6 ;
			else if ( _f_slot == 170 ) box_submarine [ playerid ] = 7 ;
			else if ( _f_slot == 172 ) box_submarine [ playerid ] = 8 ;
            
            new scm_string [ 100 ] ;
            format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы взяли '{"#cGN"}%s{"#cWH"}'. Отнесите и положите его в фургон.", item_name ( _f_slot ) ) ;
            SendClientMessage ( playerid, col_white, scm_string ) ;

			ClearAnimations ( playerid ) ;
			p_t_info [ playerid ] [ p_animation ] = true ;
		    ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
			
			show_inventory_ptd ( playerid, false ) ;
		}
		else
		{
			new _max_slot = item_max_in_slot ( _f_slot ) ;
			if ( _max_slot != -1 && p_info [ playerid ] [ prise_slot_count ] [ get_player_item_prise ( playerid, _f_slot ) ] + 1 > _max_slot )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 100, "Вы не можете переносить более %d шт. выбранного предмета.", _max_slot ) ;
				send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				hideSelectorDialog ( playerid ) ;
				return 1 ;
			}
			
			p_t_info [ playerid ] [ slot_limit ] [ _id ] ++ ;
			
			if ( p_t_info [ playerid ] [ slot_limit ] [ _id ] >= 500 )
			{
				if ( ! gang_player ( playerid ) && ! mafia_player ( playerid ) ) p_t_info [ playerid ] [ slot_cooldown ] [ _id ] = gettime ( ) + 300 ;
				else p_t_info [ playerid ] [ slot_cooldown ] [ _id ] = gettime ( ) + 150 ;
			}
			
			format ( query_string, sizeof query_string, "%s взял(а) из организации (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _f_id, item_name ( _f_slot ), _f_slot, 1 ) ;
			write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
			
			if ( gang_player ( playerid ) || mafia_player ( playerid ) ) format ( query_string, sizeof ( query_string ), "[F] %s %s [id %d] взял(а) со склада {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, 1, item_name ( _f_slot ) ) ;
			else format ( query_string, sizeof ( query_string ), "[R] %s %s [id %d] взял(а) со склада {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, 1, item_name ( _f_slot ) ) ;
			fraction_message ( _f_id, col_lblue, query_string ) ;
			
			give_player_item_prise ( playerid, _f_slot, 1 ) ;
			SetWarehouseItemID ( playerid, 11, _f_id, _slot ) ;
		
			foreach(new i: fraction_players[_f_id])
			{
				if ( player_inventory { i } != 11 ) continue ;
				SetWarehouseItemID ( i, 11, _f_id, _slot ) ;
			}
		}
	}
	else if ( _param1 == 4 )
	{
		new _id = get_player_use_listitem ( playerid ), 
			_f_id = p_info [ playerid ] [ member ],
			_f_slot = f_info [ _f_id - 1 ] [ f_slot ] [ _id ],
			query_string [ 144 ] ;
			
		if ( _f_id < 1 ) return 1 ;
		
		if ( 1 > f_info [ _f_id - 1 ] [ f_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "В организации нет такого количества!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		if ( item_not_get ( _f_slot ) )
		{
			new bool: _warehouse = false ;
			if ( _f_slot == 164 )
			{
				if ( get_fraction_item ( _f_id, 348 ) > 1000 ) _warehouse = true ;
			}
			else if ( _f_slot == 165 )
			{
				if ( get_fraction_item ( _f_id, 355 ) > 1000 ) _warehouse = true ;
			}
			else if ( _f_slot == 166 )
			{
				if ( get_fraction_item ( _f_id, 356 ) > 1000 ) _warehouse = true ;
			}
			else if ( _f_slot == 167 )
			{
				if ( get_fraction_item ( _f_id, 154 ) > 10000 ) _warehouse = true ;
			}
			else if ( _f_slot == 168 )
			{
				if ( get_fraction_item ( _f_id, 1244 ) > 1000 ) _warehouse = true ;
			}
			else if ( _f_slot == 169 )
			{
				if ( get_fraction_item ( _f_id, 347 ) > 1000 ) _warehouse = true ;
			}
			else if ( _f_slot == 170 )
			{
				if ( get_fraction_item ( _f_id, 349 ) > 1000 ) _warehouse = true ;
			}
			else if ( _f_slot == 172 )
			{
				if ( get_fraction_item ( _f_id, 145 ) > 1000 ) _warehouse = true ;
			}
			
			if ( _warehouse )
			{
				send_check_cinfo ( playerid, "Вы не можете открыть выбранный ящик!\nНа Вашем складе слишком много данного вида вооружения.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				hideSelectorDialog ( playerid ) ;
				return 1 ;
			}
			
			new _slot = clear_fraction_item ( _f_id, _f_slot, 1, _id ) ;
			
			format ( query_string, sizeof query_string, "%s открыл(а) ящик (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _f_id, item_name ( _f_slot ), _f_slot, 1 ) ;
			write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
			
			if ( gang_player ( playerid ) || mafia_player ( playerid ) ) format ( query_string, sizeof ( query_string ), "[F] %s %s [id %d] открыл(а) ящик {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, 1, item_name ( _f_slot ) ) ;
			else format ( query_string, sizeof ( query_string ), "[R] %s %s [id %d] открыл(а) ящик {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, 1, item_name ( _f_slot ) ) ;
			fraction_message ( _f_id, col_lblue, query_string ) ;
			
			SetWarehouseItemID ( playerid, 11, _f_id, _slot ) ;
		
			foreach(new i: fraction_players[_f_id])
			{
				if ( player_inventory { i } != 11 ) continue ;
				SetWarehouseItemID ( i, 11, _f_id, _slot ) ;
			}
			
			_slot = -1 ;
			if ( _f_slot == 164 ) _slot = give_fraction_item ( _f_id, 348, 10, -1 ) ;
			else if ( _f_slot == 165 ) _slot = give_fraction_item ( _f_id, 355, 10, -1 ) ;
			else if ( _f_slot == 166 ) _slot = give_fraction_item ( _f_id, 356, 10, -1 ) ;
			else if ( _f_slot == 167 ) _slot = give_fraction_item ( _f_id, 154, 100, -1 ) ;
			else if ( _f_slot == 168 ) _slot = give_fraction_item ( _f_id, 1244, 3, -1 ) ;
			else if ( _f_slot == 169 ) _slot = give_fraction_item ( _f_id, 347, 10, -1 ) ;
			else if ( _f_slot == 170 ) _slot = give_fraction_item ( _f_id, 349, 10, -1 ) ;
			else if ( _f_slot == 172 ) _slot = give_fraction_item ( _f_id, 145, 10, -1 ) ;
			
			if ( _slot != -1 )
			{
				SetWarehouseItemID ( playerid, 11, _f_id, _slot ) ;
		
				foreach(new i: fraction_players[_f_id])
				{
					if ( player_inventory { i } != 11 ) continue ;
					SetWarehouseItemID ( i, 11, _f_id, _slot ) ;
				}
			}
		}
	}
	else if ( _param1 == 5 )
	{
		new _id = get_player_use_listitem ( playerid ), 
			_f_id = p_info [ playerid ] [ member ],
			_f_slot = f_info [ _f_id - 1 ] [ f_slot ] [ _id ],
			query_string [ 144 ] ;
			
		if ( _f_id < 1 ) return 1 ;
		
		if ( p_t_info [ playerid ] [ slot_cooldown ] [ _id ] > gettime ( ) )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "Выбранный предмет можно будет взять через %d сек.", p_t_info [ playerid ] [ slot_cooldown ] [ _id ] - gettime ( ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		else p_t_info [ playerid ] [ slot_limit ] [ _id ] = 0 ;
		
		if ( _f_slot != 153 && _f_slot != 154 && _f_slot != 155 )
		{
			if ( p_t_info [ playerid ] [ slot_limit ] [ _id ] > 1 )
			{
				send_check_cinfo ( playerid, "Лимит на предмет составляет 1 шт.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( ! gang_player ( playerid ) && ! mafia_player ( playerid ) )
			{
				if ( _param2 > 1 )
				{
					_param2 = 1 ;
					send_check_cinfo ( playerid, "Нельзя брать сразу несколько предметов!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				}
				
				p_t_info [ playerid ] [ slot_cooldown ] [ _id ] = gettime ( ) + 600 ;
			}
			else
			{
				if ( p_info [ playerid ] [ leader ] < 1 && _param2 > 1 )
				{
					_param2 = 1 ;
					send_check_cinfo ( playerid, "Только лидер может брать сразу несколько предметов!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				}
				
				p_t_info [ playerid ] [ slot_cooldown ] [ _id ] = gettime ( ) + 300 ;
			}
		}
		else
		{
			if ( p_t_info [ playerid ] [ slot_limit ] [ _id ] > 500 )
			{
				send_check_cinfo ( playerid, "Лимит на патроны составляет 500 шт.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _param2 > 500 )
			{
				_param2 = 500 ;
				send_check_cinfo ( playerid, "Нельзя брать более 500 патрон!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			}
		}
		
		if ( _param2 > f_info [ _f_id - 1 ] [ f_slot_count ] [ _id ] )
		{
			send_check_cinfo ( playerid, "В организации нет такого количества!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}

		new _slot = clear_fraction_item ( _f_id, _f_slot, _param2, _id ) ;
		if ( item_not_get ( _f_slot ) )
		{
			if ( box_submarine [ playerid ] > 0 )
			{
				send_check_cinfo ( playerid, "У Вас уже есть ящик в руках. Отнесите и положите его в фургон!", 0, 300, CINFO_INVENTORY_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
				return 1 ;
			}

			format ( query_string, sizeof query_string, "%s взял(а) из организации (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _f_id, item_name ( _f_slot ), _f_slot, _param2 ) ;
			write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
			
			send_check_cinfo ( playerid, "Отнесите ящик в фургон!", 0, 300, CINFO_INVENTORY_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
			
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
			SetPlayerAttachedObject ( playerid, 0, 3013, 6,0.0,0.10,-0.2, -110.0,0.0,78.0 ) ;
			
			have_box [ playerid ] = true ;
            if ( _f_slot == 164 ) box_submarine [ playerid ] = 1 ;
			else if ( _f_slot == 165 ) box_submarine [ playerid ] = 2 ;
			else if ( _f_slot == 166 ) box_submarine [ playerid ] = 3 ;
			else if ( _f_slot == 167 ) box_submarine [ playerid ] = 4 ;
			else if ( _f_slot == 168 ) box_submarine [ playerid ] = 5 ;
			else if ( _f_slot == 169 ) box_submarine [ playerid ] = 6 ;
			else if ( _f_slot == 170 ) box_submarine [ playerid ] = 7 ;
			else if ( _f_slot == 172 ) box_submarine [ playerid ] = 8 ;
            
            new scm_string [ 100 ] ;
            format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы взяли '{"#cGN"}%s{"#cWH"}'. Отнесите и положите его в фургон.", item_name ( _f_slot ) ) ;
            SendClientMessage ( playerid, col_white, scm_string ) ;

			ClearAnimations ( playerid ) ;
			p_t_info [ playerid ] [ p_animation ] = true ;
		    ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
			
			show_inventory_ptd ( playerid, false ) ;
		}
		else
		{
			new _max_slot = item_max_in_slot ( _f_slot ) ;
			if ( _max_slot != -1 && p_info [ playerid ] [ prise_slot_count ] [ get_player_item_prise ( playerid, _f_slot ) ] + _param2 > _max_slot )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 100, "Вы не можете переносить более %d шт. выбранного предмета.", _max_slot ) ;
				send_check_cinfo ( playerid, global_string, 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				hideSelectorDialog ( playerid ) ;
				return 1 ;
			}
			
			p_t_info [ playerid ] [ slot_limit ] [ _id ] += _param2 ;
			
			if ( p_t_info [ playerid ] [ slot_limit ] [ _id ] >= 500 )
			{
				if ( ! gang_player ( playerid ) && ! mafia_player ( playerid ) ) p_t_info [ playerid ] [ slot_cooldown ] [ _id ] = gettime ( ) + 300 ;
				else p_t_info [ playerid ] [ slot_cooldown ] [ _id ] = gettime ( ) + 150 ;
			}
			
			format ( query_string, sizeof query_string, "%s взял(а) из организации (#%d) %s (#%d, %d шт.)", p_info [ playerid ] [ name ], _f_id, item_name ( _f_slot ), _f_slot, _param2 ) ;
			write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
			
			if ( gang_player ( playerid ) || mafia_player ( playerid ) ) format ( query_string, sizeof ( query_string ), "[F] %s %s [id %d] взял(а) со склада {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, _param2, item_name ( _f_slot ) ) ;
			else format ( query_string, sizeof ( query_string ), "[R] %s %s [id %d] взял(а) со склада {3399FF}%d шт.{"#cLB"} %s", f_rank [ _f_id - 1 ] [ p_info [ playerid ] [ rank ] - 1 ], p_info [ playerid ] [ name ], playerid, _param2, item_name ( _f_slot ) ) ;
			fraction_message ( _f_id, col_lblue, query_string ) ;
			
			give_player_item_prise ( playerid, _f_slot, _param2 ) ;
			SetWarehouseItemID ( playerid, 11, _f_id, _slot ) ;
		
			foreach(new i: fraction_players[_f_id])
			{
				if ( player_inventory { i } != 11 ) continue ;
				SetWarehouseItemID ( i, 11, _f_id, _slot ) ;
			}
		}
	}
	else if ( _param1 == 6 )
	{
		new _id = get_player_use_listitem ( playerid ), _f_id = p_info [ playerid ] [ member ], query_string [ 144 ] ;
		if ( _f_id < 1 ) return 1 ;
		
		if ( admin_info [ playerid ] [ admin ] < 8 )
		{
			send_check_cinfo ( playerid, "Выбросить может только главный администратор!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			hideSelectorDialog ( playerid ) ;
			return 1 ;
		}
		
		format ( query_string, sizeof query_string, "%s выбросил(а) из организации (#%d) %s (#%d)", p_info [ playerid ] [ name ], _f_id, item_name ( f_info [ _f_id - 1 ] [ f_slot ] [ _id ] ), f_info [ _f_id - 1 ] [ f_slot ] [ _id ] ) ;
		write_fraction ( playerid, _f_id, TYPE_LOG_INVENTORY, query_string ) ;
		
		new _slot = clear_family_item ( _f_id, f_info [ _f_id - 1 ] [ f_slot ] [ _id ], f_info [ _f_id - 1 ] [ f_slot_count ] [ _id ], _id ) ;
		SetWarehouseItemID ( playerid, 11, _f_id, _slot ) ;
		
		foreach(new i: fraction_players[_f_id])
		{
			if ( player_inventory { i } != 11 ) continue ;
			SetWarehouseItemID ( i, 11, _f_id, _slot ) ;
		}
	}
	hideSelectorDialog ( playerid ) ;
	return 1 ;
}

stock give_fraction_item ( _f_id, _i_item, _i_count, _day = 20 )
{
	if ( _i_item < 1 ) return 1 ;

	new bool: _free_slot = false, _insert_slot = false, _slot_id = 0, _slot ;
	for ( new i = 0 ; i < MAX_FRACTION_WAREHOUSE ; i ++ )
	{
		_slot = f_info [ _f_id - 1 ] [ f_slot ] [ i ] ;
	    if ( _slot > 0 )
		{
			if ( _slot == _i_item )
			{
			    _slot_id = i ;
	    		_free_slot = true ;
	    		_insert_slot = false ;
	    		break ;
			}
			continue ;
	    }
	    else
		{
			if ( _free_slot == false )
			{
				_slot_id = i ;
				_free_slot = true ;
				_insert_slot = true ;
			}
		}
	}
	
	if ( _free_slot == false ) return -1 ;
	if ( f_info [ _f_id - 1 ] [ f_slot_count ] [ _slot_id ] + _i_count > 1_000_000_000 ) return -1 ;
	
	f_info [ _f_id - 1 ] [ f_slot ] [ _slot_id ] = _i_item ;
	f_info [ _f_id - 1 ] [ f_slot_count ] [ _slot_id ] += _i_count ;
	if ( _day != -1 ) f_info [ _f_id - 1 ] [ f_slot_date ] [ _slot_id ] = SetElapsedTime ( gettime ( ), _day, CONVERT_TIME_TO_DAYS ) ;
	else f_info [ _f_id - 1 ] [ f_slot_date ] [ _slot_id ] = -1 ;
	
    if ( _insert_slot )
    {
        prise_fraction_inc_id ++ ;
        f_info [ _f_id - 1 ] [ f_slot_id ] [ _slot_id ] = prise_fraction_inc_id ;
    
        static const _str [ ] = "INSERT INTO `fractions_prise` (`f_slot`, `f_id`, `f_item`, `f_count`, `f_date`) VALUES ('%d', '%d', '%d', '%d', '%d')" ;
        new sql_string [ sizeof _str + ( 9 * 5 ) ] ;
    	format ( sql_string, sizeof sql_string, _str, prise_fraction_inc_id, _f_id, f_info [ _f_id - 1 ] [ f_slot ] [ _slot_id ], f_info [ _f_id - 1 ] [ f_slot_count ] [ _slot_id ], f_info [ _f_id - 1 ] [ f_slot_date ] [ _slot_id ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	else
	{
	    static const _str [ ] = "UPDATE `fractions_prise` SET `f_item` = '%d', `f_count` = '%d', `f_date` = '%d' WHERE `f_slot` = '%d' LIMIT 1" ;
        new sql_string [ sizeof _str + ( 9 * 4 ) ] ;
    	format ( sql_string, sizeof sql_string, _str, f_info [ _f_id - 1 ] [ f_slot ] [ _slot_id ], f_info [ _f_id - 1 ] [ f_slot_count ] [ _slot_id ], f_info [ _f_id - 1 ] [ f_slot_date ] [ _slot_id ], f_info [ _f_id - 1 ] [ f_slot_id ] [ _slot_id ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	
	model_info [ _i_item ] [ m_count ] += 1 ;
	set_model_count ( _i_item, model_info [ _i_item ] [ m_count ] ) ;
	
	return _slot_id ;
}

stock clear_fraction_item ( _f_id, _i_item, _i_count, _i_slot = -1 )
{
	if ( _i_slot == -1 )
	{
	    new _slot_id = 0, sql_string [ 91 + ( 9 * 3 ) ] ;
		for ( new i = 0 ; i < MAX_FRACTION_WAREHOUSE ; i ++ )
		{
		    if ( f_info [ _f_id - 1 ] [ f_slot ] [ i ] != _i_item ) continue ;

		    _slot_id = i ;
		    break ;
		}
		
		if ( f_info [ _f_id - 1 ] [ f_slot_count ] [ _slot_id ] - _i_count < 1 )
		{
			sql_string [ 0 ] = EOS  ;
	    	format ( sql_string, sizeof sql_string, "DELETE FROM `fractions_prise` WHERE `f_slot` = '%d' LIMIT 1", f_info [ _f_id - 1 ] [ f_slot_id ] [ _slot_id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
			
			f_info [ _f_id - 1 ] [ f_slot_id ] [ _slot_id ] =
	    	f_info [ _f_id - 1 ] [ f_slot ] [ _slot_id ] =
	    	f_info [ _f_id - 1 ] [ f_slot_count ] [ _slot_id ] =
	    	f_info [ _f_id - 1 ] [ f_slot_date ] [ _slot_id ] = 0 ;
		}
		else
		{
		    f_info [ _f_id - 1 ] [ f_slot_count ] [ _slot_id ] -= _i_count ;

			sql_string [ 0 ] = EOS  ;
		    format ( sql_string, sizeof sql_string, "UPDATE `fractions_prise` SET `f_item` = '%d', `f_count` = '%d' WHERE `f_slot` = '%d' LIMIT 1", f_info [ _f_id - 1 ] [ f_slot ] [ _slot_id ], f_info [ _f_id - 1 ] [ f_slot_count ] [ _slot_id ], f_info [ _f_id - 1 ] [ f_slot_id ] [ _slot_id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
	
		model_info [ _i_item ] [ m_count ] -= 1 ;
		set_model_count ( _i_item, model_info [ _i_item ] [ m_count ] ) ;
		
		return _slot_id ;
	}
	
	if ( f_info [ _f_id - 1 ] [ f_slot_count ] [ _i_slot ] - _i_count < 1 )
	{
		new sql_string [ 62 + 9 ] ;
	   	format ( sql_string, sizeof sql_string, "DELETE FROM `fractions_prise` WHERE `f_slot` = '%d' LIMIT 1", f_info [ _f_id - 1 ] [ f_slot_id ] [ _i_slot ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
		
		f_info [ _f_id - 1 ] [ f_slot_id ] [ _i_slot ] =
	   	f_info [ _f_id - 1 ] [ f_slot ] [ _i_slot ] =
	   	f_info [ _f_id - 1 ] [ f_slot_count ] [ _i_slot ] =
	   	f_info [ _f_id - 1 ] [ f_slot_date ] [ _i_slot ] = 0 ;
	}
	else
	{
	   	f_info [ _f_id - 1 ] [ f_slot_count ] [ _i_slot ] -= _i_count ;

		new sql_string [ 91 + ( 9 * 3 ) ] ;
	    format ( sql_string, sizeof sql_string, "UPDATE `fractions_prise` SET `f_item` = '%d', `f_count` = '%d' WHERE `f_slot` = '%d' LIMIT 1", f_info [ _f_id - 1 ] [ f_slot ] [ _i_slot ], f_info [ _f_id - 1 ] [ f_slot_count ] [ _i_slot ], f_info [ _f_id - 1 ] [ f_slot_id ] [ _i_slot ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}
	
	model_info [ _i_item ] [ m_count ] -= 1 ;
	set_model_count ( _i_item, model_info [ _i_item ] [ m_count ] ) ;
	
	return _i_slot ;
}

stock get_fraction_item ( _f_id, _i_item )
{
	new _i_count = 0 ;
	for ( new i = 0 ; i < MAX_FRACTION_WAREHOUSE ; i ++ )
	{
	    if ( f_info [ _f_id - 1 ] [ f_slot ] [ i ] != _i_item ) continue ;

        _i_count = f_info [ _f_id - 1 ] [ f_slot_count ] [ i ] ;
		break ;
	}
	
	return _i_count ;
}