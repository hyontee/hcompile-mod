#include 									<custom/tune_packet>

forward exit_tuning ( playerid, _biz_id ) ;

enum _tune_info
{
	t_position,
	t_name [ 24 ],
	t_icon
} ;

new tuning_menu_name [ 5 ] [ _tune_info ] =
{
	{ 0, "ТЮНИНГ", 10 },
	{ 1, "ДЕТЕЙЛИНГ", 1 },
	{ 2, "STAGE", 13 },
	{ 3, "ТО ДВИГАТЕЛЯ", 4 },
	{ 4, "УДАЛЕНИЕ ТЮНИНГА", 6 }
} ;

new tuning_menu_name_2 [ 5 ] [ _tune_info ] =
{
	{ 0, "PERFOMANCE", 10 },
	{ 1, "ДЕТЕЙЛИНГ", 1 },
	{ 2, "STAGE", 13 },
	{ 3, "ТО ДВИГАТЕЛЯ", 4 },
	{ 4, "УДАЛЕНИЕ ТЮНИНГА", 6 }
} ;

new tuning_submenu [ 4 ] [ _tune_info ] =
{
	{ 0, "ЦВЕТ КУЗОВА", 1 },
	{ 1, "ДИСКИ", 15 },
	{ 2, "ГИДРАВЛИКА", 11 },
	{ 3, "НИТРО", 5 }
} ;

new tuning_submenu_2 [ 9 ] [ _tune_info ] =
{
	{ 0, "ПОДВЕСКА", 2 },
	{ 1, "РАЗМЕР\nКОЛЁС", 15 },
	{ 2, "ВЫВОРОТ\nКОЛЁС", 15 },
	{ 3, "ВЫЛЕТ\nКОЛЁС", 15 },
	{ 4, "ЦВЕТ ФАР", 7 },
	{ 5, "НЕОН", 6 },
	{ 6, "ТОНИРОВКА", 6 },
	{ 7, "ВИНИЛ", 1 },
	{ 8, "НЕОН (ДОНАТ)", 6 }
} ;

new tuning_submenu_3 [ 3 ] [ _tune_info ] =
{
	{ 0, "ДВИГАТЕЛЬ", 2 },
	{ 1, "ТОРМОЗА", 15 },
	{ 2, "СТАБИЛИЗАЦИЯ", 15 }
} ;

new player_tune_color [ MAX_PLAYERS ] ;
new player_tune_colored [ MAX_PLAYERS ] [ 2 ] ;
new player_submenu [ MAX_PLAYERS ] ;
new player_seekbar [ MAX_PLAYERS ] [ 2 ] ;
new player_250ms [ MAX_PLAYERS ] ;
new player_tune_shadow [ MAX_PLAYERS ] [ 2 ] ;
new player_tune_toner [ MAX_PLAYERS ] [ 4 ] ;
new bool: player_perfomance [ MAX_PLAYERS ] ;

CMD:testa ( playerid, params [ ] )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	if ( sscanf ( params, "d", params [ 0 ] ) ) return 1 ;
	
	p_t_info [ playerid ] [ tuning_vehicle ] = GetPlayerVehicleID ( playerid ) ;
	showTuning ( playerid, ( params [ 0 ] == 1 ) ? ( true ) : ( false ) ) ;
	return 1 ;
}

stock showTuning ( playerid, bool: status )
{
	player_perfomance [ playerid ] = status ;
	
	new _str [ 32 ], _str2 [ 8 ], _v_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
	format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
	format ( _str2, sizeof _str2, "%d", GetTuningCount ( playerid ) ) ;
	showTune ( playerid, GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), _str, _str2, GetTuningTotalPrice ( playerid ) ) ;
	
	clearMenu ( playerid, 0 ) ;
	clearMenu ( playerid, 1 ) ;
	
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
				
	BS_WriteValue(bitstream, PR_INT8, 11);
	
	if ( status )
	{
		BS_WriteValue(bitstream, PR_UINT8, sizeof tuning_menu_name_2);
		for ( new i = 0 ; i < sizeof tuning_menu_name_2 ; i ++ )
		{
			BS_WriteValue(bitstream, PR_INT8, 0);
						
			BS_WriteValue(bitstream, PR_UINT8, strlen ( tuning_menu_name_2 [ i ] [ t_name ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, tuning_menu_name_2 [ i ] [ t_name ] ) ;
						
			BS_WriteValue(bitstream, PR_INT8, tuning_menu_name_2 [ i ] [ t_icon ]);
		}
	}
	else
	{
		BS_WriteValue(bitstream, PR_UINT8, sizeof tuning_menu_name);
		for ( new i = 0 ; i < sizeof tuning_menu_name ; i ++ )
		{
			BS_WriteValue(bitstream, PR_INT8, 0);
						
			BS_WriteValue(bitstream, PR_UINT8, strlen ( tuning_menu_name [ i ] [ t_name ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, tuning_menu_name [ i ] [ t_name ] ) ;
						
			BS_WriteValue(bitstream, PR_INT8, tuning_menu_name [ i ] [ t_icon ]);
		}
	}

	PR_SendPacket(bitstream, playerid);
	BS_Delete(bitstream);
	
	player_submenu [ playerid ] = -1 ;
	p_t_info [ playerid ] [ component_id ] [ 0 ] = -1 ;
	p_t_info [ playerid ] [ component_id ] [ 1 ] = -1 ;
			
	toggle_controlable ( playerid, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	
	new engine, lights, alarm, doors, bonnet, boot, objective ;
	GetVehicleParamsEx ( _v_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( _v_id, true, true, alarm, doors, bonnet, boot, objective ) ;
	
	player_tune_shadow [ playerid ] [ 0 ] = 255 ;
	player_tune_toner [ playerid ] [ 0 ] = -1 ;
	return 1 ;
}

stock show_packet_tune ( playerid, _param1, _param2, _param3 )
{
	new _v_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
	if ( _v_id < 1 || _v_id > MAX_VEHICLES )
	{
		carComponentClear ( playerid ) ;
		carCharacteristicLayout ( playerid, false, "" ) ;
		carColorLayout ( playerid, false, "", false, false ) ;
		carWheelsLayout ( playerid, false, "" ) ;
		carTintSettingsLayout ( playerid, false, "" ) ;
		carCartLayout ( playerid, false, "" ) ;
		clearCartItem ( playerid ) ;
		hideTune ( playerid ) ;
			
		toggle_controlable ( playerid, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
		SetCameraBehindPlayer ( playerid ) ;
		
		send_check_cinfo ( playerid, "Загоните т/с заново!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}
	
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 )
		{
			carComponentClear ( playerid ) ;
			carCharacteristicLayout ( playerid, false, "" ) ;
			carColorLayout ( playerid, false, "", false, false ) ;
			carWheelsLayout ( playerid, false, "" ) ;
			carTintSettingsLayout ( playerid, false, "" ) ;
			carCartLayout ( playerid, false, "" ) ;
			clearCartItem ( playerid ) ;
			hideTune ( playerid ) ;
			
			toggle_controlable ( playerid, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
			SetCameraBehindPlayer ( playerid ) ;
			
			player_submenu [ playerid ] = -1 ;
			
			new point = -1,
				_v_model = getReplacableVehicleModel ( _v_id ) ;

			for ( new i = 0; i <= 91 ; i ++ )
			{
				if ( _v_model == legal_tuns [ i ] [ 0 ] )
				{
					point = i;
					break ;
				}
			}
			
			if ( point != -1 )
			{
				for ( new j = 0; j <= 57  ; j ++ )
				{
					RemoveVehicleComponent ( _v_id, legal_tuns [ point ] [ j ] ) ;
				}
			}
			
			for ( new j = 0 ; j < 10 ; j ++ )
			{
				if ( veh_info [ _v_id - 1 ] [ v_component ] [ j ] == 0 ) continue ;
				AddVehicleComponent ( veh_info [ _v_id - 1 ] [ v_vehicle ], veh_info [ _v_id - 1 ] [ v_component ] [ j ] ) ;
			}
			
			if ( veh_info [ _v_id - 1 ] [ v_paint ] != 3 )
			{
				n_ChangeVehicleColor ( _v_id, veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ] ) ;
				ChangeVehiclePaintjob ( _v_id, veh_info [ _v_id - 1 ] [ v_paint ] ) ;
			}
			else
			{
				ChangeVehiclePaintjob ( _v_id, 3 ) ;
				n_ChangeVehicleColor ( _v_id, veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ] ) ;
			}
			
			if ( player_tune_shadow [ playerid ] [ 0 ] != 255 )
			{
				veh_info [ _v_id - 1 ] [ v_neon ] = player_tune_shadow [ playerid ] [ 0 ] ;
				veh_info [ _v_id - 1 ] [ v_neon_type ] = player_tune_shadow [ playerid ] [ 1 ] ;
				player_tune_shadow [ playerid ] [ 0 ] = 255 ;
			}
			if ( player_tune_toner [ playerid ] [ 0 ] != -1 )
			{
				veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ] = player_tune_toner [ playerid ] [ 0 ] ;
				veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ] = player_tune_toner [ playerid ] [ 1 ] ;
				veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ] = player_tune_toner [ playerid ] [ 2 ] ;
				veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ] = player_tune_toner [ playerid ] [ 3 ] ;
			}
			clear_car_custom ( _v_id, 3, playerid ) ;

			//
			exit_tuning ( playerid, GetPVarInt ( playerid, "p_biz_id" ) ) ;
			PutPlayerInVehicle ( playerid, _v_id, 0 ) ;
			SetCameraBehindPlayer ( playerid ) ;
		}
		else if ( _param2 == 1 ) // корзина
		{
			carCartLayout ( playerid, true, GetTuningTotalPrice ( playerid ) ) ;
			
			new _str [ 32 ], _price, _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
			if ( player_perfomance [ playerid ] )
			{
				for ( new i = 0 ; i < 5 ; i ++ )
				{
					if ( p_t_info [ playerid ] [ pt_engine ] [ i ] != 1 ) continue ;
					
					if ( _b_id > 0 ) _price = engine_ptune_price [ i ] * b_info [ _b_id - 1 ] [ b_cost ] ;
					else _price = engine_ptune_price [ i ] ;
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					addCartItem ( playerid, engine_ptune [ i ], _str ) ;
				}
				for ( new i = 0 ; i < 5 ; i ++ )
				{
					if ( p_t_info [ playerid ] [ pt_brake ] [ i ] != 1 ) continue ;
					
					if ( _b_id > 0 ) _price = brake_ptune_price [ i ] * b_info [ _b_id - 1 ] [ b_cost ] ;
					else _price = brake_ptune_price [ i ] ;
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					addCartItem ( playerid, brake_ptune [ i ], _str ) ;
				}
				for ( new i = 0 ; i < 5 ; i ++ )
				{
					if ( p_t_info [ playerid ] [ pt_stability ] [ i ] != 1 ) continue ;
					
					if ( _b_id > 0 ) _price = stability_ptune_price [ i ] * b_info [ _b_id - 1 ] [ b_cost ] ;
					else _price = stability_ptune_price [ i ] ;
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					addCartItem ( playerid, stability_ptune [ i ], _str ) ;
				}
				return 1 ;
			}
			
			if ( p_t_info [ playerid ] [ component_id ] [ 0 ] != -1 )
			{
				if ( _b_id > 0 ) _price = tuning_price [ 0 ] * b_info [ _b_id - 1 ] [ b_cost ] ;
				else _price = tuning_price [ 0 ] ;
				format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
				addCartItem ( playerid, "Цвет кузова #1", _str ) ;
			}
			if ( p_t_info [ playerid ] [ component_id ] [ 1 ] != -1 )
			{
				if ( _b_id > 0 ) _price = tuning_price [ 1 ] * b_info [ _b_id - 1 ] [ b_cost ] ;
				else _price = tuning_price [ 1 ] ;
				format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
				addCartItem ( playerid, "Цвет кузова #2", _str ) ;
			}
			if ( p_t_info [ playerid ] [ component_id ] [ 9 ] )
			{
				if ( _b_id > 0 ) _price = tuning_price [ 9 ] * b_info [ _b_id - 1 ] [ b_cost ] ;
				else _price = tuning_price [ 9 ] ;
				format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
				addCartItem ( playerid, "Колёса", _str ) ;
			}
			if ( p_t_info [ playerid ] [ component_id ] [ 10 ] )
			{
				if ( _b_id > 0 ) _price = tuning_price [ 10 ] * b_info [ _b_id - 1 ] [ b_cost ] ;
				else _price = tuning_price [ 10 ] ;
				format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
				addCartItem ( playerid, "Гидравлика", _str ) ;
			}
			if ( p_t_info [ playerid ] [ component_id ] [ 11 ] )
			{
				if ( _b_id > 0 ) _price = tuning_price [ 11 ] * b_info [ _b_id - 1 ] [ b_cost ] ;
				else _price = tuning_price [ 11 ] ;
				format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
				addCartItem ( playerid, "Нитро", _str ) ;
			}
		}
	}
	else if ( _param1 == 1 )
	{
		if ( _param2 == 1 )
		{
			clearMenu ( playerid, 1 ) ;
			
			carComponentClear ( playerid ) ;
			carCharacteristicLayout ( playerid, false, "" ) ;
			carColorLayout ( playerid, false, "", false, false ) ;
			carWheelsLayout ( playerid, false, "" ) ;
			carTintSettingsLayout ( playerid, false, "" ) ;
			
			set_player_use_listitem ( playerid, _param3 ) ;
			if ( _param3 == 0 )
			{
				if ( player_perfomance [ playerid ] )
				{
					new BitStream:bitstream = BS_New();
					BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
					BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
					
					BS_WriteValue(bitstream, PR_INT8, 11);
					
					BS_WriteValue(bitstream, PR_UINT8, sizeof tuning_submenu_3);
					for ( new i = 0 ; i < sizeof tuning_submenu_3 ; i ++ )
					{
						BS_WriteValue(bitstream, PR_INT8, 1);
						
						BS_WriteValue(bitstream, PR_UINT8, strlen ( tuning_submenu_3 [ i ] [ t_name ] ) ) ;
						BS_WriteValue(bitstream, PR_STRING, tuning_submenu_3 [ i ] [ t_name ] ) ;
						
						BS_WriteValue(bitstream, PR_INT8, tuning_submenu_3 [ i ] [ t_icon ]);
					}

					PR_SendPacket(bitstream, playerid);

					BS_Delete(bitstream);
					return 1 ;
				}
				
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
				
				BS_WriteValue(bitstream, PR_INT8, 11);
				
				BS_WriteValue(bitstream, PR_UINT8, sizeof tuning_submenu);
				for ( new i = 0 ; i < sizeof tuning_submenu ; i ++ )
				{
					BS_WriteValue(bitstream, PR_INT8, 1);
					
					BS_WriteValue(bitstream, PR_UINT8, strlen ( tuning_submenu [ i ] [ t_name ] ) ) ;
					BS_WriteValue(bitstream, PR_STRING, tuning_submenu [ i ] [ t_name ] ) ;
					
					BS_WriteValue(bitstream, PR_INT8, tuning_submenu [ i ] [ t_icon ]);
				}

				PR_SendPacket(bitstream, playerid);

				BS_Delete(bitstream);
			}
			else if ( _param3 == 1 )
			{
				new BitStream:bitstream = BS_New();
				BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
				BS_WriteValue(bitstream, PR_UINT32, RPC_TUNING);
				
				BS_WriteValue(bitstream, PR_INT8, 11);
				
				BS_WriteValue(bitstream, PR_UINT8, sizeof tuning_submenu_2);
				for ( new i = 0 ; i < sizeof tuning_submenu_2 ; i ++ )
				{
					BS_WriteValue(bitstream, PR_INT8, 1);
					
					BS_WriteValue(bitstream, PR_UINT8, strlen ( tuning_submenu_2 [ i ] [ t_name ] ) ) ;
					BS_WriteValue(bitstream, PR_STRING, tuning_submenu_2 [ i ] [ t_name ] ) ;
					
					BS_WriteValue(bitstream, PR_INT8, tuning_submenu_2 [ i ] [ t_icon ]);
				}

				PR_SendPacket(bitstream, playerid);

				BS_Delete(bitstream);
			}
			else if ( _param3 == 2 )
			{
				carCharacteristicLayout ( playerid, true, "ХАРАКТЕРИСТИКИ" ) ;
				
				new _v_model = getReplacableVehicleModel ( _v_id ), _m_speed = max_veh_speed ( _v_model ), _minus_speed = 0, _str [ 32 ] ;
				if ( veh_info [ _v_id - 1 ] [ v_millage ] > 100 ) _minus_speed = floatround ( veh_info [ _v_id - 1 ] [ v_millage ] / 100 ) ;
				new _veh_speed = floatround ( _m_speed + stage_info_speed ( _v_id ) - _minus_speed ) ;
				format ( _str, sizeof _str, "%d", _veh_speed ) ;
				carCharacteristicAdd ( playerid, "Макс. скорость", _m_speed + stage_max_speed [ 2 ], _veh_speed, _str, "" ) ;
				format ( _str, sizeof _str, "%d", floatround ( ( _m_speed / 10 ) + stage_brake [ 2 ] ) ) ;
				carCharacteristicAdd ( playerid, "Торможение", 100, floatround ( ( _m_speed / 10 ) + stage_brake [ 2 ] ), _str, "" ) ;
				format ( _str, sizeof _str, "%d", floatround ( ( _m_speed / 10 ) + stage_stability [ 2 ] ) ) ;
				carCharacteristicAdd ( playerid, "Стабилизация", 100, floatround ( ( _m_speed / 10 ) + stage_stability [ 2 ] ), _str, "" ) ;
				
				carComponentAdd ( playerid, "", "", "", "", "", "", 0, 1080, "Stage 1", "20.000.000", "Купить" ) ;
				carComponentAdd ( playerid, ""donate_title" (бонус)", "#FFFFFF", "#903464", "", "", "", 0, 1080, "Stage 2", "500", "Купить" ) ;
				carComponentAdd ( playerid, ""donate_title"", "#FFFFFF", "#AA3333", "", "", "", 0, 1080, "Stage 3", "300", "Купить" ) ;
			}
			else if ( _param3 == 3 ) show_remove_millage ( playerid ) ;
			else if ( _param3 == 4 ) show_removetuning ( playerid ) ;
		}
	}
	else if ( _param1 == 2 )
	{
		if ( _param2 == 1 )
		{
			if ( player_submenu [ playerid ] == _param3 ) return 1 ;
			
			new _id = get_player_use_listitem ( playerid ) ;
			player_submenu [ playerid ] = _param3 ;
			
			carComponentClear ( playerid ) ;
			carCharacteristicLayout ( playerid, false, "" ) ;
			carColorLayout ( playerid, false, "", false, false ) ;
			carWheelsLayout ( playerid, false, "" ) ;
			carTintSettingsLayout ( playerid, false, "" ) ;
			
			if ( player_tune_shadow [ playerid ] [ 0 ] != 255 )
			{
				veh_info [ _v_id - 1 ] [ v_neon ] = player_tune_shadow [ playerid ] [ 0 ] ;
				veh_info [ _v_id - 1 ] [ v_neon_type ] = player_tune_shadow [ playerid ] [ 1 ] ;
				player_tune_shadow [ playerid ] [ 0 ] = 255 ;
			}
			if ( player_tune_toner [ playerid ] [ 0 ] != -1 )
			{
				veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ] = player_tune_toner [ playerid ] [ 0 ] ;
				veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ] = player_tune_toner [ playerid ] [ 1 ] ;
				veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ] = player_tune_toner [ playerid ] [ 2 ] ;
				veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ] = player_tune_toner [ playerid ] [ 3 ] ;
			}
			
			player_custom_vinyl [ playerid ] = 0 ;
			clear_car_custom ( _v_id, 3, playerid ) ;
			
			if ( _id == 0 )
			{
				if ( player_perfomance [ playerid ] )
				{
					if ( _param3 == 0 )
					{
						new _str [ 24 ], _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_cost = 1 ;
						if ( _b_id > 0 ) _b_cost = b_info [ _b_id - 1 ] [ b_cost ] ;
						else _b_cost = 1 ;
						
						for ( new i = 0 ; i < 5 ; i ++ )
						{
							format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( engine_ptune_price [ i ] * _b_cost ) ) ;
							if ( veh_info [ _v_id - 1 ] [ v_pt_engine ] [ i ] == 1 ) carComponentAdd ( playerid, "Установлено", "#FFFFFF", "#33AA33", "", "", "", -1, 1, engine_ptune [ i ], _str, "Добавить в корзину" ) ;
							else carComponentAdd ( playerid, "", "", "", "", "", "", -1, 42, engine_ptune [ i ], _str, "Добавить в корзину" ) ;
						}
					}
					else if ( _param3 == 1 )
					{
						new _str [ 24 ], _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_cost = 1 ;
						if ( _b_id > 0 ) _b_cost = b_info [ _b_id - 1 ] [ b_cost ] ;
						else _b_cost = 1 ;
						
						for ( new i = 0 ; i < 5 ; i ++ )
						{
							format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( brake_ptune_price [ i ] * _b_cost ) ) ;
							if ( veh_info [ _v_id - 1 ] [ v_pt_brake ] [ i ] == 1 ) carComponentAdd ( playerid, "Установлено", "#FFFFFF", "#33AA33", "", "", "", -1, 2, brake_ptune [ i ], _str, "Добавить в корзину" ) ;
							else carComponentAdd ( playerid, "", "", "", "", "", "", -1, 38, brake_ptune [ i ], _str, "Добавить в корзину" ) ;
						}
					}
					else if ( _param3 == 2 )
					{
						new _str [ 24 ], _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_cost = 1 ;
						if ( _b_id > 0 ) _b_cost = b_info [ _b_id - 1 ] [ b_cost ] ;
						else _b_cost = 1 ;
						
						for ( new i = 0 ; i < 5 ; i ++ )
						{
							format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( stability_ptune_price [ i ] * _b_cost ) ) ;
							if ( veh_info [ _v_id - 1 ] [ v_pt_stability ] [ i ] == 1 ) carComponentAdd ( playerid, "Установлено", "#FFFFFF", "#33AA33", "", "", "", -1, 3, stability_ptune [ i ], _str, "Добавить в корзину" ) ;
							else carComponentAdd ( playerid, "", "", "", "", "", "", -1, 47, stability_ptune [ i ], _str, "Добавить в корзину" ) ;
						}
					}
					return 1 ;
				}
				
				if ( _param3 == 0 )
				{
					player_tune_color [ playerid ] = 0 ;
					player_tune_colored [ playerid ] [ 0 ] =
					player_tune_colored [ playerid ] [ 1 ] = -1 ;
					
					carColorLayout ( playerid, true, "Цвет кузова #1", true, false ) ;
					colorsAdd ( playerid, 2 ) ;
					
					new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _str [ 24 ] ;
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					new _price = tuning_price [ 0 ] * _b_price ;
					
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					carComponentAdd ( playerid, "", "", "", "", "", "", 0, 1080, "Цвет кузова #1", _str, "Добавить в корзину" ) ;
					carComponentAdd ( playerid, "", "", "", "", "", "", 0, 1080, "Цвет кузова #2", _str, "Добавить в корзину" ) ;
				}
				else if ( _param3 == 1 )
				{
					new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _str [ 16 ], _str2 [ 24 ] ;
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					new _price = tuning_price [ 9 ] * _b_price ;
					
					format ( _str2, sizeof _str2, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					for ( new i = 0 ; i < sizeof tuning_wheels ; i ++ )
					{
						format ( _str, sizeof _str, "Диски #%d", i + 1 ) ;
						carComponentAdd ( playerid, "", "", "", "", "", "", 0, tuning_wheels [ i ], _str, _str2, "Добавить в корзину" ) ;
					}
				}
				else if ( _param3 == 2 )
				{
					new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _str [ 24 ] ;
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					new _price = tuning_price [ 10 ] * _b_price ;
					
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					carComponentAdd ( playerid, "", "", "", "", "", "", 0, 1087, "Гидравлика", _str, "Добавить в корзину" ) ;
				}
				else if ( _param3 == 3 )
				{
					new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _str [ 24 ] ;
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					new _price = tuning_price [ 11 ] * _b_price ;
					
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					carComponentAdd ( playerid, "", "", "", "", "", "", 0, 1010, "Нитро", _str, "Добавить в корзину" ) ;
				}
			}
			else if ( _id == 1 )
			{
				if ( _param3 == 0 )
				{
					player_seekbar [ playerid ] [ 0 ] =
					player_seekbar [ playerid ] [ 1 ] = 0 ;
					player_custom_suspension [ playerid ] [ 0 ] = -0.20;
					player_custom_suspension [ playerid ] [ 1 ] = 0.20;
					carWheelsLayout ( playerid, true, "Уровень и баланс" ) ;
					carWheelsSettings ( playerid, 0, true, "Установите уровень подвески", "-0.20", "0.03", "", player_seekbar [ playerid ] [ 0 ] ) ;
					carWheelsSettings ( playerid, 1, true, "Установите баланс подвески", "0.20", "0.60", "", player_seekbar [ playerid ] [ 1 ] ) ;
					
					new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _stage = player_submenu [ playerid ], _str [ 24 ] ;
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					new _price = custom_price [ _stage ] * _b_price ;
					
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					carComponentAdd ( playerid, "", "", "", "", "", "", 0, 1080, "Подвеска", _str, "Купить" ) ;
					
					SetVehicleHandling ( playerid, _v_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				else if ( _param3 == 1 )
				{
					player_seekbar [ playerid ] [ 0 ] =
					player_seekbar [ playerid ] [ 1 ] = 0 ;
					player_custom_wheelsize [ playerid ] = 0.60;
					player_custom_wheelwidth [ playerid ] = 105;
					carWheelsLayout ( playerid, true, "Размер и ширина" ) ;
					carWheelsSettings ( playerid, 0, true, "Установите размер колёс", "0.60", "0.90", "", player_seekbar [ playerid ] [ 0 ] ) ;
					carWheelsSettings ( playerid, 1, true, "Установите ширину колёс", "105", "150", "", player_seekbar [ playerid ] [ 1 ] ) ;
					
					new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _stage = player_submenu [ playerid ], _str [ 24 ] ;
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					new _price = custom_price [ _stage ] * _b_price ;
					
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					carComponentAdd ( playerid, "", "", "", "", "", "", 0, 1080, "Колёса", _str, "Купить" ) ;
					
					SetVehicleHandling ( playerid, _v_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				else if ( _param3 == 2 ) // выворот колёс
				{
					player_seekbar [ playerid ] [ 0 ] =
					player_seekbar [ playerid ] [ 1 ] = 0 ;
					player_custom_wheelalignment [ playerid ] [ 0 ] = -7;
					player_custom_wheelalignment [ playerid ] [ 1 ] = -7;
					carWheelsLayout ( playerid, true, "Выворот колёс" ) ;
					carWheelsSettings ( playerid, 0, true, "Передние колёса", "-7", "7", "", player_seekbar [ playerid ] [ 0 ] ) ;
					carWheelsSettings ( playerid, 1, true, "Задние колёса", "-7", "7", "", player_seekbar [ playerid ] [ 1 ] ) ;
					
					new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _stage = player_submenu [ playerid ], _str [ 24 ] ;
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					new _price = custom_price [ _stage ] * _b_price ;
					
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					carComponentAdd ( playerid, "", "", "", "", "", "", 0, 1080, "Колёса", _str, "Купить" ) ;
					
					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], player_custom_wheelalignment [ playerid ] [ 0 ], player_custom_wheelalignment [ playerid ] [ 1 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
				else if ( _param3 == 3 ) // вылет колёс
				{
					player_seekbar [ playerid ] [ 0 ] =
					player_seekbar [ playerid ] [ 1 ] = 0 ;
					player_custom_wheeloffstet [ playerid ] [ 0 ] = -17;
					player_custom_wheeloffstet [ playerid ] [ 1 ] = -17;
					carWheelsLayout ( playerid, true, "Вылет колёс" ) ;
					carWheelsSettings ( playerid, 0, true, "Передние колёса", "-17", "17", "", player_seekbar [ playerid ] [ 0 ] ) ;
					carWheelsSettings ( playerid, 1, true, "Задние колёса", "-17", "17", "", player_seekbar [ playerid ] [ 1 ] ) ;
					
					new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _stage = player_submenu [ playerid ], _str [ 24 ] ;
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					new _price = custom_price [ _stage ] * _b_price ;
					
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					carComponentAdd ( playerid, "", "", "", "", "", "", 0, 1080, "Колёса", _str, "Купить" ) ;

					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], player_custom_wheeloffstet [ playerid ] [ 0 ], player_custom_wheeloffstet [ playerid ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
				else if ( _param3 == 4 ) // цвет фар
				{
					carTintSettingsLayout ( playerid, true, "Цвет фар" ) ;
					carTintSettings ( playerid, 0, true, "", "", "", -1 ) ;
					carTintSettings ( playerid, 1, false, "", "", "", -1 ) ;
					colorsAdd ( playerid, 2 ) ;
					
					new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _stage = player_submenu [ playerid ], _str [ 24 ] ;
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					new _price = custom_price [ _stage ] * _b_price ;
					
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					carComponentAdd ( playerid, "", "", "", "", "", "", 0, 1080, "Цвет фар", _str, "Купить" ) ;
				}
				else if ( _param3 == 5 ) // неон
				{
					carTintSettingsLayout ( playerid, true, "Неон" ) ;
					carTintSettings ( playerid, 0, true, "", "", "", -1 ) ;
					carTintSettings ( playerid, 1, false, "", "", "", -1 ) ;
					colorsAdd ( playerid, 2 ) ;
					
					new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _stage = player_submenu [ playerid ], _str [ 24 ] ;
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					new _price = custom_price [ _stage ] * _b_price ;
					
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					carComponentAdd ( playerid, "", "", "", "", "", "", 0, 1080, "Неон", _str, "Купить" ) ;
				}
				else if ( _param3 == 6 ) // тонировка
				{
					player_seekbar [ playerid ] [ 1 ] = 50 ;
					carTintSettingsLayout ( playerid, true, "Тонировка" ) ;
					carTintSettings ( playerid, 0, true, "Светопропускаемость", "", "", -1 ) ;
					carTintSettings ( playerid, 1, true, "0%", "100%", "", player_seekbar [ playerid ] [ 1 ] ) ;
					colorsAdd ( playerid, 2 ) ;
					
					new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _stage = player_submenu [ playerid ], _str [ 24 ] ;
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					new _price = custom_price [ _stage ] * _b_price ;
					
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					carComponentAdd ( playerid, "", "", "", "", "", "", 0, 1080, "Тонировка", _str, "Купить" ) ;
				}
				else if ( _param3 == 7 ) // винилы
				{
					new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _stage = player_submenu [ playerid ], _str [ 24 ] ;
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					new _price = custom_price [ _stage ] * _b_price ;
					
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _price ) ) ;
					for ( new i = 0 ; i < 53 ; i ++ )
					{
						carComponentAdd ( playerid, "", "", "", "", "", "", 10, i, "Винил", _str, "Купить" ) ;
					}
					
					send_check_cinfo ( playerid, "Для установки винила цвет кузова должен быть белым.\nНе на все модели возможно установить винил.", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
				}
				else if ( _param3 == 8 ) // неон донат
				{
					for ( new i = 0 ; i < 53 ; i ++ )
					{
						carComponentAdd ( playerid, ""donate_title"", "#FFFFFF", "#AA3333", "", "", "", 11, i, "Неон", "200", "Купить" ) ;
					}
					
					if ( player_tune_shadow [ playerid ] [ 0 ] == 255 )
					{
						player_tune_shadow [ playerid ] [ 0 ] = veh_info [ _v_id - 1 ] [ v_neon ] ;
						player_tune_shadow [ playerid ] [ 1 ] = veh_info [ _v_id - 1 ] [ v_neon_type ] ;
					}
				}
			}
			else if ( _id == 2 )
			{
				
			}
		}
	}
	else if ( _param1 == 3 )
	{
		if ( _param2 == 1 ) // colors
		{
			new _id = get_player_use_listitem ( playerid ) ;
			if ( _id == 0 )
			{
				new _stage = player_submenu [ playerid ] ;
				if ( _stage == 0 ) // цвет кузова
				{
					new _v_color_0, _v_color_1 ;
					player_tune_colored [ playerid ] [ player_tune_color [ playerid ] ] = _param3 ;
					if ( player_tune_colored [ playerid ] [ 0 ] == -1 && player_tune_colored [ playerid ] [ 1 ] != -1 )
					{
						ChangeVehicleColor ( _v_id, veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], player_tune_colored [ playerid ] [ 1 ] ) ;
						_v_color_0 = veh_info [ _v_id - 1 ] [ v_color ] [ 0 ] ;
						_v_color_1 = player_tune_colored [ playerid ] [ 1 ] ;
					}
					else if ( player_tune_colored [ playerid ] [ 0 ] != -1 && player_tune_colored [ playerid ] [ 1 ] == -1 )
					{
						ChangeVehicleColor ( _v_id, player_tune_colored [ playerid ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ] ) ;
						_v_color_0 = player_tune_colored [ playerid ] [ 0 ] ;
						_v_color_1 = veh_info [ _v_id - 1 ] [ v_color ] [ 1 ] ;
					}
					else
					{
						ChangeVehicleColor ( _v_id, player_tune_colored [ playerid ] [ 0 ], player_tune_colored [ playerid ] [ 1 ] ) ;
						_v_color_0 = player_tune_colored [ playerid ] [ 0 ] ;
						_v_color_1 = player_tune_colored [ playerid ] [ 1 ] ;
					}
					
					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], player_custom_wheeloffstet [ playerid ] [ 0 ], player_custom_wheeloffstet [ playerid ] [ 1 ],
												_v_color_0, _v_color_1, _v_color_1,
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
			}
			else if ( _id == 1 )
			{
				new _stage = player_submenu [ playerid ] ;
				if ( _stage == 4 ) // цвет фар
				{
					player_custom_lights_color [ playerid ] = _param3 ;

					sc_VehicleDynamicParams ( _v_id, playerid,
												player_custom_lights_color [ playerid ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
				else if ( _stage == 5 ) // неон
				{
					if ( player_tune_shadow [ playerid ] [ 0 ] == 255 )
					{
						player_tune_shadow [ playerid ] [ 0 ] = veh_info [ _v_id - 1 ] [ v_neon ] ;
						player_tune_shadow [ playerid ] [ 1 ] = veh_info [ _v_id - 1 ] [ v_neon_type ] ;
					}
					
					new _r, _g, _b ;
					color_converter ( rgb_array [ _param3 ], _r, _g, _b ) ;
					veh_info [ _v_id - 1 ] [ v_neon ] = _param3 ;
					veh_info [ _v_id - 1 ] [ v_neon_type ] = eNeonTypes_ON_TYPE_STATIC ;
					sc_OnVehicleStreamIn ( _v_id, playerid ) ;
				}
				else if ( _stage == 6 ) // тонировка
				{
					new _r, _g, _b ;
					color_converter ( rgb_array [ _param3 ], _r, _g, _b ) ;
					veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ] = _r ;
					veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ] = _g ;
					veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ] = _b ;
					veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ] = 0xFF ;
					sc_OnVehicleStreamIn ( _v_id, playerid ) ;
					
					if ( player_tune_toner [ playerid ] [ 0 ] == -1 )
					{
						player_tune_toner [ playerid ] [ 0 ] = veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ] ;
						player_tune_toner [ playerid ] [ 1 ] = veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ] ;
						player_tune_toner [ playerid ] [ 2 ] = veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ] ;
						player_tune_toner [ playerid ] [ 3 ] = veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ] ;
					}
				}
			}
		}
		else if ( _param2 == 2 ) // car component
		{
			new _id = get_player_use_listitem ( playerid ) ;
			if ( ! player_perfomance [ playerid ] && _id == 0 )
			{
				new _stage = player_submenu [ playerid ] ;
				if ( _stage == 1 ) // диски
				{
					AddVehicleComponent ( _v_id, tuning_wheels [ _param3 ] ) ;
				}
			}
			else if ( _id == 1 )
			{
				new _stage = player_submenu [ playerid ] ;
				if ( _stage == 5 ) // переключение фар
				{
					if ( _param3 == 1 )
					{
						carTintSettingsLayout ( playerid, false, "" ) ;
						carTintSettings ( playerid, 0, false, "", "", "", -1 ) ;
						carTintSettings ( playerid, 1, false, "", "", "", -1 ) ;
						
						player_submenu [ playerid ] = -1 ;
					}
				}
				else if ( _stage == 7 ) // винилы
				{
					player_custom_vinyl [ playerid ] = _param3 + 1 ;
					
					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												player_custom_vinyl [ playerid ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
				else if ( _stage == 8 ) // неон донат
				{
					if ( player_tune_shadow [ playerid ] [ 0 ] == 255 )
					{
						player_tune_shadow [ playerid ] [ 0 ] = veh_info [ _v_id - 1 ] [ v_neon ] ;
						player_tune_shadow [ playerid ] [ 1 ] = veh_info [ _v_id - 1 ] [ v_neon_type ] ;
					}
					
					veh_info [ _v_id - 1 ] [ v_neon ] = _param3 + 1 ;
					veh_info [ _v_id - 1 ] [ v_neon_type ] = eNeonTypes_ON_TYPE_TEXTURE ;
					sc_OnVehicleStreamIn ( _v_id, playerid ) ;
				}
			}
			else if ( _id == 2 )
			{
				if ( _param3 == 0 )
				{
					new _v_model = getReplacableVehicleModel ( _v_id ), _m_speed = max_veh_speed ( _v_model ), _minus_speed = 0, _str [ 32 ] ;
					if ( veh_info [ _v_id - 1 ] [ v_millage ] > 100 ) _minus_speed = floatround ( veh_info [ _v_id - 1 ] [ v_millage ] / 100 ) ;
					new _veh_speed = floatround ( _m_speed + stage_max_speed [ 0 ] - _minus_speed ) ;
					format ( _str, sizeof _str, "%d", _veh_speed ) ;
					carCharacteristicUpdate ( playerid, 0, "Макс. скорость", _m_speed + stage_max_speed [ 2 ], _veh_speed, _str, "" ) ;
					format ( _str, sizeof _str, "%d", floatround ( ( _m_speed / 10 ) + stage_brake [ 0 ] ) ) ;
					carCharacteristicUpdate ( playerid, 1, "Торможение", 100, floatround ( ( _m_speed / 10 ) + stage_brake [ 0 ] ), _str, "" ) ;
					format ( _str, sizeof _str, "%d", floatround ( ( _m_speed / 10 ) + stage_stability [ 0 ] ) ) ;
					carCharacteristicUpdate ( playerid, 2, "Стабилизация", 100, floatround ( ( _m_speed / 10 ) + stage_stability [ 0 ] ), _str, "" ) ;
				}
				else if ( _param3 == 1 )
				{
					new _v_model = getReplacableVehicleModel ( _v_id ), _m_speed = max_veh_speed ( _v_model ), _minus_speed = 0, _str [ 32 ] ;
					if ( veh_info [ _v_id - 1 ] [ v_millage ] > 100 ) _minus_speed = floatround ( veh_info [ _v_id - 1 ] [ v_millage ] / 100 ) ;
					new _veh_speed = floatround ( _m_speed + stage_max_speed [ 1 ] - _minus_speed ) ;
					format ( _str, sizeof _str, "%d", _veh_speed ) ;
					carCharacteristicUpdate ( playerid, 0, "Макс. скорость", _m_speed + stage_max_speed [ 2 ], _veh_speed, _str, "" ) ;
					format ( _str, sizeof _str, "%d", floatround ( ( _m_speed / 10 ) + stage_brake [ 1 ] ) ) ;
					carCharacteristicUpdate ( playerid, 1, "Торможение", 100, floatround ( ( _m_speed / 10 ) + stage_brake [ 1 ] ), _str, "" ) ;
					format ( _str, sizeof _str, "%d", floatround ( ( _m_speed / 10 ) + stage_stability [ 1 ] ) ) ;
					carCharacteristicUpdate ( playerid, 2, "Стабилизация", 100, floatround ( ( _m_speed / 10 ) + stage_stability [ 1 ] ), _str, "" ) ;
				}
				else if ( _param3 == 2 )
				{
					new _v_model = getReplacableVehicleModel ( _v_id ), _m_speed = max_veh_speed ( _v_model ), _minus_speed = 0, _str [ 32 ] ;
					if ( veh_info [ _v_id - 1 ] [ v_millage ] > 100 ) _minus_speed = floatround ( veh_info [ _v_id - 1 ] [ v_millage ] / 100 ) ;
					new _veh_speed = floatround ( _m_speed + stage_max_speed [ 2 ] - _minus_speed ) ;
					format ( _str, sizeof _str, "%d", _veh_speed ) ;
					carCharacteristicUpdate ( playerid, 0, "Макс. скорость", _m_speed + stage_max_speed [ 2 ], _veh_speed, _str, "" ) ;
					format ( _str, sizeof _str, "%d", floatround ( ( _m_speed / 10 ) + stage_brake [ 2 ] ) ) ;
					carCharacteristicUpdate ( playerid, 1, "Торможение", 100, floatround ( ( _m_speed / 10 ) + stage_brake [ 2 ] ), _str, "" ) ;
					format ( _str, sizeof _str, "%d", floatround ( ( _m_speed / 10 ) + stage_stability [ 1 ] ) ) ;
					carCharacteristicUpdate ( playerid, 2, "Стабилизация", 100, floatround ( ( _m_speed / 10 ) + stage_stability [ 2 ] ), _str, "" ) ;
				}
			}
		}
		else if ( _param2 == 3 ) // add bucket
		{
			new _id = get_player_use_listitem ( playerid ) ;
			if ( _id == 0 )
			{
				new _stage = player_submenu [ playerid ] ;
				if ( player_perfomance [ playerid ] )
				{
					if ( _stage == 0 )
					{
						if ( veh_info [ _v_id - 1 ] [ v_pt_engine ] [ _param3 ] == 1 )
							return send_check_cinfo ( playerid, "У Вас уже установлено данное улучшение!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
							
						p_t_info [ playerid ] [ pt_engine ] [ _param3 ] = 1 ;
					}
					else if ( _stage == 1 )
					{
						if ( veh_info [ _v_id - 1 ] [ v_pt_brake ] [ _param3 ] == 1 )
							return send_check_cinfo ( playerid, "У Вас уже установлено данное улучшение!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
							
						p_t_info [ playerid ] [ pt_brake ] [ _param3 ] = 1 ;
					}
					else if ( _stage == 2 )
					{
						if ( veh_info [ _v_id - 1 ] [ v_pt_stability ] [ _param3 ] == 1 )
							return send_check_cinfo ( playerid, "У Вас уже установлено данное улучшение!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
							
						p_t_info [ playerid ] [ pt_stability ] [ _param3 ] = 1 ;
					}
					
					new _str [ 32 ], _str2 [ 8 ] ;
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
					format ( _str2, sizeof _str2, "%d", GetTuningCount ( playerid ) ) ;
					showTune ( playerid, GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), _str, _str2, GetTuningTotalPrice ( playerid ) ) ;
					return 1 ;
				}
				
				if ( _stage == 0 ) // цвет кузова
				{
					if ( player_tune_colored [ playerid ] [ 0 ] != -1 ) p_t_info [ playerid ] [ component_id ] [ 0 ] = player_tune_colored [ playerid ] [ 0 ] ;
					if ( player_tune_colored [ playerid ] [ 1 ] != -1 ) p_t_info [ playerid ] [ component_id ] [ 1 ] = player_tune_colored [ playerid ] [ 1 ] ;
					
					new _str [ 32 ], _str2 [ 8 ] ;
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
					format ( _str2, sizeof _str2, "%d", GetTuningCount ( playerid ) ) ;
					showTune ( playerid, GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), _str, _str2, GetTuningTotalPrice ( playerid ) ) ;
				}
				else if ( _stage == 1 ) // диски
				{
					p_t_info [ playerid ] [ component_id ] [ 9 ] = tuning_wheels [ _param3 ] ;
					
					new _str [ 32 ], _str2 [ 8 ] ;
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
					format ( _str2, sizeof _str2, "%d", GetTuningCount ( playerid ) ) ;
					showTune ( playerid, GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), _str, _str2, GetTuningTotalPrice ( playerid ) ) ;
				}
				else if ( _stage == 2 ) // гидравлика
				{
					p_t_info [ playerid ] [ component_id ] [ 10 ] = 1087 ;
					
					new _str [ 32 ], _str2 [ 8 ] ;
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
					format ( _str2, sizeof _str2, "%d", GetTuningCount ( playerid ) ) ;
					showTune ( playerid, GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), _str, _str2, GetTuningTotalPrice ( playerid ) ) ;
				}
				else if ( _stage == 3 ) // нитро
				{
					p_t_info [ playerid ] [ component_id ] [ 11 ] = 1010 ;
					
					new _str [ 32 ], _str2 [ 8 ] ;
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
					format ( _str2, sizeof _str2, "%d", GetTuningCount ( playerid ) ) ;
					showTune ( playerid, GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), _str, _str2, GetTuningTotalPrice ( playerid ) ) ;
				}
			}
			else if ( _id == 1 )
			{
				new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _b_price = 0, _stage = player_submenu [ playerid ], bool: _sucess_product = false ;
				if ( _stage == 8 )
				{
					if ( ! get_player_donate ( playerid, 200, 2 ) )
						return send_check_cinfo ( playerid, "У Вас не достаточно средств!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				
					set_player_donate ( playerid, 200, 2 ) ;
					insert_donate_log ( playerid, INVALID_PLAYER_ID, 200, p_info [ playerid ] [ donate ], "(donate) neon" ) ;
					
					checking_quest_progress ( playerid, 6, 1, quest_line_medium ) ;
				}
				else
				{
					if ( _b_id > 0 ) _b_price = b_info [ _b_id - 1 ] [ b_cost ] ;
					else _b_price = 1 ;
					
					new _price = custom_price [ _stage ] * _b_price ;
					
					if ( p_info [ playerid ] [ money ] < _price )
						return send_check_cinfo ( playerid, "У Вас не достаточно средств!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;

					if ( _b_id > 0 && b_info [ _b_id - 1 ] [ b_product ] < 120 ) _sucess_product = true ;
					
					give_money ( playerid, -_price ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, -_price, "кастомный тюнинг" ) ;
					
					checking_quest_progress ( playerid, 6, 1, quest_line_medium ) ;

					if ( _b_id > 0 && ! _sucess_product ) give_bmoney ( _b_id, floatround ( _price / 10 ), 120 ) ;
				}
				
				if ( _stage == 0 ) // уровень подвески
				{
					veh_info [ _v_id - 1 ] [ v_suspension ] [ 0 ] = player_custom_suspension [ playerid ] [ 0 ] ;
					veh_info [ _v_id - 1 ] [ v_suspension ] [ 1 ] = player_custom_suspension [ playerid ] [ 1 ] ;
				}
				else if ( _stage == 1 ) // размер колёс
				{
					veh_info [ _v_id - 1 ] [ v_wheel_size ] = player_custom_wheelsize [ playerid ] ;
					veh_info [ _v_id - 1 ] [ v_wheel_width ] = player_custom_wheelwidth [ playerid ] ;
				}
				else if ( _stage == 2 ) // выворот колёс
				{
					veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ] = player_custom_wheelalignment [ playerid ] [ 0 ] ;
					veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ] = player_custom_wheelalignment [ playerid ] [ 1 ] ;
				}
				else if ( _stage == 3 ) // вылет колёс
				{
					veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ] = player_custom_wheeloffstet [ playerid ] [ 0 ] ;
					veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ] = player_custom_wheeloffstet [ playerid ] [ 1 ] ;
				}
				else if ( _stage == 4 ) // цвет фар
				{
					veh_info [ _v_id - 1 ] [ v_lights_color ] = player_custom_lights_color [ playerid ] ;
				}
				else if ( _stage == 5 ) player_tune_shadow [ playerid ] [ 0 ] = 255 ; // неон
				else if ( _stage == 6 ) player_tune_toner [ playerid ] [ 0 ] = -1 ;
				else if ( _stage == 7 )
				{
					veh_info [ _v_id - 1 ] [ v_vinyl ] = player_custom_vinyl [ playerid ] ;
					player_custom_vinyl [ playerid ] = 0 ;
				}
				else if ( _stage == 8 ) player_tune_shadow [ playerid ] [ 0 ] = 255 ; // неон донат
				
				save_car_custom ( _v_id ) ;
				clear_car_custom ( _v_id, 3, playerid ) ;
			}
			else if ( _id == 2 )
			{
				if ( veh_info [ _v_id - 1 ] [ v_stage_speed ] == _param3 + 1 ) return send_check_cinfo ( playerid, "У Вас уже установлен выбранный Stage!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				
				switch ( _param3 + 1 )
				{
					case 1:
					{
						if ( p_info [ playerid ] [ money ] < 20_000_000 ) return send_check_cinfo ( playerid, "У Вас не достаточно средств!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						
						give_money ( playerid, -20_000_000 ) ;
						insert_money_log ( playerid, INVALID_PLAYER_ID, -20_000_000, "stage (lvl 1)" ) ;
					}
					case 2:
					{
						if ( ! get_player_donate ( playerid, 500, 1 ) ) return send_check_cinfo ( playerid, "У Вас не достаточно "donate_title" на бонусном счёте!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						
						set_player_donate ( playerid, 500, 1 ) ;
					}
					case 3:
					{
						if ( ! get_player_donate ( playerid, 300, 2 ) ) return send_check_cinfo ( playerid, "У Вас не достаточно "donate_title" на основном счёте!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			
						set_player_donate ( playerid, 300, 2 ) ;
						insert_donate_log ( playerid, INVALID_PLAYER_ID, 300, p_info [ playerid ] [ donate ], "(donate) stage (lvl 2)" ) ;
					}
				}
				
				veh_info [ _v_id - 1 ] [ v_stage_speed ] = _param3 + 1 ;
				veh_info [ _v_id - 1 ] [ v_stage_brake ] = _param3 + 1 ;
				save_car_stage ( _v_id ) ;
			}
		}
	}
	else if ( _param1 == 4 )
	{
		new _stage = player_submenu [ playerid ] ;
		if ( _param2 == 1 ) // верхний SeekBar
		{
			if ( _stage == 0 ) // уровень подвески
			{
				if ( player_seekbar [ playerid ] [ 0 ] < _param3 ) 
				{
					player_seekbar [ playerid ] [ 0 ] = _param3 ;
					player_custom_suspension [ playerid ] [ 0 ] += 0.01 ;
				}
				else
				{
					player_seekbar [ playerid ] [ 0 ] = _param3 ;
					player_custom_suspension [ playerid ] [ 0 ] -= 0.01 ;
				}
				if ( player_custom_suspension [ playerid ] [ 0 ] <= -0.20 || player_seekbar [ playerid ] [ 0 ] < 1 ) player_seekbar [ playerid ] [ 0 ] = 0, player_custom_suspension [ playerid ] [ 0 ] = -0.20 ;
				if ( player_custom_suspension [ playerid ] [ 0 ] >= 0.03 || player_seekbar [ playerid ] [ 0 ] > 99 ) player_seekbar [ playerid ] [ 0 ] = 100, player_custom_suspension [ playerid ] [ 0 ] = 0.03 ;
				
				new _str [ 12 ] ;
				format ( _str, sizeof _str, "%.2f", player_custom_suspension [ playerid ] [ 0 ] ) ;
				carWheelsSettings ( playerid, 0, true, "Установите уровень подвески", "-0.20", "0.03", _str, -1 ) ;
					
				SetVehicleHandling ( playerid, _v_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
			}
			else if ( _stage == 1 ) // размер колёс
			{
				if ( player_seekbar [ playerid ] [ 0 ] < _param3 ) 
				{
					player_seekbar [ playerid ] [ 0 ] = _param3 ;
					player_custom_wheelsize [ playerid ] += 0.01 ;
				}
				else
				{
					player_seekbar [ playerid ] [ 0 ] = _param3 ;
					player_custom_wheelsize [ playerid ] -= 0.01 ;
				}
				if ( player_custom_wheelsize [ playerid ] <= 0.60 || player_seekbar [ playerid ] [ 0 ] < 1 ) player_seekbar [ playerid ] [ 0 ] = 0, player_custom_wheelsize [ playerid ] = 0.60 ;
				if ( player_custom_wheelsize [ playerid ] >= 0.90 || player_seekbar [ playerid ] [ 0 ] > 99 ) player_seekbar [ playerid ] [ 0 ] = 100, player_custom_wheelsize [ playerid ] = 0.90 ;
				
				new _str [ 12 ] ;
				format ( _str, sizeof _str, "%.2f", player_custom_suspension [ playerid ] [ 0 ] ) ;
				carWheelsSettings ( playerid, 0, true, "Установите размер колёс", "0.60", "0.90", _str, -1 ) ;
					
				SetVehicleHandling ( playerid, _v_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
			}
			else if ( _stage == 2 ) // выворот передних колёс
			{
				if ( player_seekbar [ playerid ] [ 0 ] < _param3 ) 
				{
					player_seekbar [ playerid ] [ 0 ] = _param3 ;
					player_custom_wheelalignment [ playerid ] [ 0 ] += 1 ;
				}
				else
				{
					player_seekbar [ playerid ] [ 0 ] = _param3 ;
					player_custom_wheelalignment [ playerid ] [ 0 ] -= 1 ;
				}
				if ( player_custom_wheelalignment [ playerid ] [ 0 ] <= -7 || player_seekbar [ playerid ] [ 0 ] < 1 ) player_seekbar [ playerid ] [ 0 ] = 0, player_custom_wheelalignment [ playerid ] [ 0 ] = -7 ;
				if ( player_custom_wheelalignment [ playerid ] [ 0 ] >= 7 || player_seekbar [ playerid ] [ 0 ] > 99 ) player_seekbar [ playerid ] [ 0 ] = 100, player_custom_wheelalignment [ playerid ] [ 0 ] = 7 ;
				
				new _str [ 12 ] ;
				format ( _str, sizeof _str, "%d", player_custom_wheelalignment [ playerid ] [ 0 ] ) ;
				carWheelsSettings ( playerid, 0, true, "Передние колёса", "-7", "7", _str, -1 ) ;
		
				sc_VehicleDynamicParams ( _v_id, playerid,
											veh_info [ _v_id - 1 ] [ v_lights_color ],
											veh_info [ _v_id - 1 ] [ v_wheel_width ], player_custom_wheelalignment [ playerid ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
											veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
											veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
											veh_info [ _v_id - 1 ] [ v_vinyl ],
											veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
			}
			else if ( _stage == 3 ) // вылет передних колёс
			{
				if ( player_seekbar [ playerid ] [ 0 ] < _param3 ) 
				{
					player_seekbar [ playerid ] [ 0 ] = _param3 ;
					player_custom_wheeloffstet [ playerid ] [ 0 ] += 1 ;
				}
				else
				{
					player_seekbar [ playerid ] [ 0 ] = _param3 ;
					player_custom_wheelalignment [ playerid ] [ 0 ] -= 1 ;
				}
				if ( player_custom_wheeloffstet [ playerid ] [ 0 ] <= -17 || player_seekbar [ playerid ] [ 0 ] < 1 ) player_seekbar [ playerid ] [ 0 ] = 0, player_custom_wheeloffstet [ playerid ] [ 0 ] = -17 ;
				if ( player_custom_wheeloffstet [ playerid ] [ 0 ] >= 17 || player_seekbar [ playerid ] [ 0 ] > 99 ) player_seekbar [ playerid ] [ 0 ] = 100, player_custom_wheeloffstet [ playerid ] [ 0 ] = 17 ;
				
				new _str [ 12 ] ;
				format ( _str, sizeof _str, "%d", player_custom_wheeloffstet [ playerid ] [ 0 ] ) ;
				carWheelsSettings ( playerid, 0, true, "Передние колёса", "-17", "17", _str, -1 ) ;
					
				sc_VehicleDynamicParams ( _v_id, playerid,
											veh_info [ _v_id - 1 ] [ v_lights_color ],
											veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], player_custom_wheeloffstet [ playerid ] [ 0 ], player_custom_wheeloffstet [ playerid ] [ 1 ],
											veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
											veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
											veh_info [ _v_id - 1 ] [ v_vinyl ],
											veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
			}
		}
		else if ( _param2 == 2 )
		{
			if ( _param3 == 1 )
			{
				if ( _stage == 0 ) // уровень подвески
				{
					if ( player_custom_suspension [ playerid ] [ 0 ] <= -0.20 ) return 1 ;
					
					player_seekbar [ playerid ] [ 0 ] -= 4 ;
					if ( player_seekbar [ playerid ] [ 0 ] < 0 ) player_seekbar [ playerid ] [ 0 ] = 0 ;
					player_custom_suspension [ playerid ] [ 0 ] -= 0.01 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%.2f", player_custom_suspension [ playerid ] [ 0 ] ) ;
					carWheelsSettings ( playerid, 0, true, "Установите уровень подвески", "-0.20", "0.03", _str, player_seekbar [ playerid ] [ 0 ] ) ;
					
					SetVehicleHandling ( playerid, _v_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				else if ( _stage == 1 ) // размер колёс
				{
					if ( player_custom_wheelsize [ playerid ] <= 0.60 ) return 1 ;
					
					player_seekbar [ playerid ] [ 0 ] -= 3 ;
					if ( player_seekbar [ playerid ] [ 0 ] < 0 ) player_seekbar [ playerid ] [ 0 ] = 0 ;
					player_custom_wheelsize [ playerid ] -= 0.01 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%.2f", player_custom_suspension [ playerid ] [ 0 ] ) ;
					carWheelsSettings ( playerid, 0, true, "Установите размер колёс", "0.60", "0.90", _str, player_seekbar [ playerid ] [ 0 ] ) ;
					
					SetVehicleHandling ( playerid, _v_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				else if ( _stage == 2 ) // выворот передних колёс
				{
					if ( player_custom_wheelalignment [ playerid ] [ 0 ] <= -7 ) return 1 ;
					
					player_seekbar [ playerid ] [ 0 ] -= 9 ;
					if ( player_seekbar [ playerid ] [ 0 ] < 0 ) player_seekbar [ playerid ] [ 0 ] = 0 ;
					player_custom_wheelalignment [ playerid ] [ 0 ] -= 1 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%d", player_custom_wheelalignment [ playerid ] [ 0 ] ) ;
					carWheelsSettings ( playerid, 0, true, "Передние колёса", "-7", "7", _str, player_seekbar [ playerid ] [ 0 ] ) ;
						
					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], player_custom_wheelalignment [ playerid ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
				else if ( _stage == 3 ) // вылет передних колёс
				{
					if ( player_custom_wheeloffstet [ playerid ] [ 0 ] <= -17 ) return 1 ;
					
					player_seekbar [ playerid ] [ 0 ] -= 3 ;
					if ( player_seekbar [ playerid ] [ 0 ] < 0 ) player_seekbar [ playerid ] [ 0 ] = 0 ;
					player_custom_wheeloffstet [ playerid ] [ 0 ] -= 1 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%d", player_custom_wheeloffstet [ playerid ] [ 0 ] ) ;
					carWheelsSettings ( playerid, 0, true, "Передние колёса", "-17", "17", _str, player_seekbar [ playerid ] [ 0 ] ) ;
						
					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], player_custom_wheeloffstet [ playerid ] [ 0 ], player_custom_wheeloffstet [ playerid ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
			}
			else if ( _param3 == 2 )
			{
				if ( _stage == 0 ) // уровень подвески
				{
					if ( player_custom_suspension [ playerid ] [ 0 ] >= 0.03 ) return 1 ;
					
					player_seekbar [ playerid ] [ 0 ] += 4 ;
					if ( player_seekbar [ playerid ] [ 0 ] > 100 ) player_seekbar [ playerid ] [ 0 ] = 0 ;
					
					player_custom_suspension [ playerid ] [ 0 ] += 0.01 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%.2f", player_custom_wheelsize [ playerid ] ) ;
					carWheelsSettings ( playerid, 0, true, "Установите уровень подвески", "-0.20", "0.03", _str, player_seekbar [ playerid ] [ 0 ] ) ;
					
					SetVehicleHandling ( playerid, _v_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				else if ( _stage == 1 ) // размер колёс
				{
					if ( player_custom_wheelsize [ playerid ] >= 0.90 ) return 1 ;
					
					player_seekbar [ playerid ] [ 0 ] += 3 ;
					if ( player_seekbar [ playerid ] [ 0 ] > 100 ) player_seekbar [ playerid ] [ 0 ] = 0 ;
					
					player_custom_wheelsize [ playerid ] += 0.01 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%.2f", player_custom_wheelsize [ playerid ] ) ;
					carWheelsSettings ( playerid, 0, true, "Установите размер колёс", "0.60", "0.90", _str, player_seekbar [ playerid ] [ 0 ] ) ;
					
					SetVehicleHandling ( playerid, _v_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				else if ( _stage == 2 ) // выворот передних колёс
				{
					if ( player_custom_wheelalignment [ playerid ] [ 0 ] >= 7 ) return 1 ;
					
					player_seekbar [ playerid ] [ 0 ] += 9 ;
					if ( player_seekbar [ playerid ] [ 0 ] > 100 ) player_seekbar [ playerid ] [ 0 ] = 0 ;
					
					player_custom_wheelalignment [ playerid ] [ 0 ] += 1 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%d", player_custom_wheelalignment [ playerid ] [ 0 ] ) ;
					carWheelsSettings ( playerid, 0, true, "Передние колёса", "-7", "7", _str, player_seekbar [ playerid ] [ 0 ] ) ;
		
					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], player_custom_wheelalignment [ playerid ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
				else if ( _stage == 3 ) // вылет передних колёс
				{
					if ( player_custom_wheeloffstet [ playerid ] [ 0 ] >= 17 ) return 1 ;
					
					player_seekbar [ playerid ] [ 0 ] += 9 ;
					if ( player_seekbar [ playerid ] [ 0 ] > 100 ) player_seekbar [ playerid ] [ 0 ] = 0 ;
					
					player_custom_wheeloffstet [ playerid ] [ 0 ] += 1 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%d", player_custom_wheeloffstet [ playerid ] [ 0 ] ) ;
					carWheelsSettings ( playerid, 0, true, "Передние колёса", "-17", "17", _str, player_seekbar [ playerid ] [ 0 ] ) ;

					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], player_custom_wheeloffstet [ playerid ] [ 0 ], player_custom_wheeloffstet [ playerid ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
			}
		}
		else if ( _param2 == 5 ) // нижний SeekBar
		{
			if ( _stage == 0 ) // баланс подвески
			{
				if ( player_seekbar [ playerid ] [ 1 ] < _param3 ) 
				{
					player_seekbar [ playerid ] [ 1 ] = _param3 ;
					player_custom_suspension [ playerid ] [ 1 ] += 0.01 ;
				}
				else
				{
					player_seekbar [ playerid ] [ 1 ] = _param3 ;
					player_custom_suspension [ playerid ] [ 1 ] -= 0.01 ;
				}
				if ( player_custom_suspension [ playerid ] [ 1 ] <= 0.20 || player_seekbar [ playerid ] [ 1 ] < 1 ) player_seekbar [ playerid ] [ 1 ] = 0, player_custom_suspension [ playerid ] [ 1 ] = 0.20 ;
				if ( player_custom_suspension [ playerid ] [ 1 ] >= 0.60 || player_seekbar [ playerid ] [ 1 ] > 99 ) player_seekbar [ playerid ] [ 1 ] = 100, player_custom_suspension [ playerid ] [ 1 ] = 0.60 ;
				
				new _str [ 12 ] ;
				format ( _str, sizeof _str, "%.2f", player_custom_suspension [ playerid ] [ 1 ] ) ;
				carWheelsSettings ( playerid, 1, true, "Установите баланс подвески", "0.20", "0.60", _str, -1 ) ;
					
				SetVehicleHandling ( playerid, _v_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
			}
			else if ( _stage == 1 ) // ширина колёс
			{
				if ( player_seekbar [ playerid ] [ 1 ] < _param3 ) 
				{
					player_seekbar [ playerid ] [ 1 ] = _param3 ;
					player_custom_wheelwidth [ playerid ] += 1 ;
				}
				else
				{
					player_seekbar [ playerid ] [ 1 ] = _param3 ;
					player_custom_wheelwidth [ playerid ] -= 1 ;
				}
				if ( player_custom_wheelwidth [ playerid ] <= 105 || player_seekbar [ playerid ] [ 1 ] < 1 ) player_seekbar [ playerid ] [ 1 ] = 0, player_custom_wheelwidth [ playerid ] = 105 ;
				if ( player_custom_wheelwidth [ playerid ] >= 150 || player_seekbar [ playerid ] [ 1 ] > 99 ) player_seekbar [ playerid ] [ 1 ] = 100, player_custom_wheelwidth [ playerid ] = 150 ;
				
				new _str [ 12 ] ;
				format ( _str, sizeof _str, "%.2f", player_custom_wheelwidth [ playerid ] ) ;
				carWheelsSettings ( playerid, 1, true, "Установите ширину колёс", "105", "150", _str, -1 ) ;
	
				sc_VehicleDynamicParams ( _v_id, playerid,
											veh_info [ _v_id - 1 ] [ v_lights_color ],
											player_custom_wheelwidth [ playerid ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
											veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
											veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
											veh_info [ _v_id - 1 ] [ v_vinyl ],
											veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
			}
			else if ( _stage == 2 ) // выворот задних колёс
			{
				if ( player_seekbar [ playerid ] [ 1 ] < _param3 ) 
				{
					player_seekbar [ playerid ] [ 1 ] = _param3 ;
					player_custom_wheelalignment [ playerid ] [ 1 ] += 1 ;
				}
				else
				{
					player_seekbar [ playerid ] [ 1 ] = _param3 ;
					player_custom_wheelalignment [ playerid ] [ 1 ] -= 1 ;
				}
				if ( player_custom_wheelalignment [ playerid ] [ 1 ] <= -7 || player_seekbar [ playerid ] [ 1 ] < 1 ) player_seekbar [ playerid ] [ 1 ] = 0, player_custom_wheelalignment [ playerid ] [ 1 ] = -7 ;
				if ( player_custom_wheelalignment [ playerid ] [ 1 ] >= 7 || player_seekbar [ playerid ] [ 1 ] > 99 ) player_seekbar [ playerid ] [ 1 ] = 100, player_custom_wheelalignment [ playerid ] [ 1 ] = 7 ;
				
				new _str [ 12 ] ;
				format ( _str, sizeof _str, "%d", player_custom_wheelalignment [ playerid ] [ 1 ] ) ;
				carWheelsSettings ( playerid, 1, true, "Задние колёса", "-7", "7", _str, -1 ) ;
						
				sc_VehicleDynamicParams ( _v_id, playerid,
											veh_info [ _v_id - 1 ] [ v_lights_color ],
											veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], player_custom_wheelalignment [ playerid ] [ 1 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
											veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
											veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
											veh_info [ _v_id - 1 ] [ v_vinyl ],
											veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
			}
			else if ( _stage == 3 ) // вылет задних колёс
			{
				if ( player_seekbar [ playerid ] [ 1 ] < _param3 ) 
				{
					player_seekbar [ playerid ] [ 1 ] = _param3 ;
					player_custom_wheeloffstet [ playerid ] [ 1 ] += 1 ;
				}
				else
				{
					player_seekbar [ playerid ] [ 1 ] = _param3 ;
					player_custom_wheeloffstet [ playerid ] [ 1 ] -= 1 ;
				}
				if ( player_custom_wheeloffstet [ playerid ] [ 1 ] <= -17 || player_seekbar [ playerid ] [ 1 ] < 1 ) player_seekbar [ playerid ] [ 1 ] = 0, player_custom_wheeloffstet [ playerid ] [ 1 ] = -17 ;
				if ( player_custom_wheeloffstet [ playerid ] [ 1 ] >= 17 || player_seekbar [ playerid ] [ 1 ] > 99 ) player_seekbar [ playerid ] [ 1 ] = 100, player_custom_wheeloffstet [ playerid ] [ 1 ] = 17 ;
				
				new _str [ 12 ] ;
				format ( _str, sizeof _str, "%d", player_custom_wheeloffstet [ playerid ] [ 1 ] ) ;
				carWheelsSettings ( playerid, 1, true, "Задние колёса", "-17", "17", _str, -1 ) ;
					
				sc_VehicleDynamicParams ( _v_id, playerid,
											veh_info [ _v_id - 1 ] [ v_lights_color ],
											veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], player_custom_wheeloffstet [ playerid ] [ 0 ], player_custom_wheeloffstet [ playerid ] [ 1 ],
											veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
											veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
											veh_info [ _v_id - 1 ] [ v_vinyl ],
											veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
			}
		}
		else if ( _param2 == 6 )
		{
			if ( _param3 == 1 )
			{
				if ( _stage == 0 ) // баланс подвески
				{
					if ( player_custom_suspension [ playerid ] [ 1 ] <= 0.20 ) return 1 ;
					
					player_seekbar [ playerid ] [ 1 ] -= 3 ;
					if ( player_seekbar [ playerid ] [ 1 ] < 0 ) player_seekbar [ playerid ] [ 1 ] = 0 ;
					
					player_custom_suspension [ playerid ] [ 1 ] -= 0.01 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%.2f", player_custom_suspension [ playerid ] [ 1 ] ) ;
					carWheelsSettings ( playerid, 1, true, "Установите баланс подвески", "0.20", "0.60", _str, player_seekbar [ playerid ] [ 1 ] ) ;
					
					SetVehicleHandling ( playerid, _v_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				else if ( _stage == 1 ) // ширина колёс
				{
					if ( player_custom_wheelwidth [ playerid ] <= 105 ) return 1 ;
					
					player_seekbar [ playerid ] [ 1 ] -= 2 ;
					if ( player_seekbar [ playerid ] [ 1 ] < 0 ) player_seekbar [ playerid ] [ 1 ] = 0 ;
					
					player_custom_wheelwidth [ playerid ] -= 1 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%d", player_custom_wheelwidth [ playerid ] ) ;
					carWheelsSettings ( playerid, 1, true, "Установите ширину колёс", "105", "150", _str, player_seekbar [ playerid ] [ 1 ] ) ;
					
					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												player_custom_wheelwidth [ playerid ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
				else if ( _stage == 2 ) // выворот задних колёс
				{
					if ( player_custom_wheelalignment [ playerid ] [ 1 ] <= -7 ) return 1 ;
					
					player_seekbar [ playerid ] [ 1 ] -= 9 ;
					if ( player_seekbar [ playerid ] [ 1 ] < 0 ) player_seekbar [ playerid ] [ 1 ] = 0 ;
					
					player_custom_wheelalignment [ playerid ] [ 1 ] -= 1 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%d", player_custom_wheelalignment [ playerid ] [ 1 ] ) ;
					carWheelsSettings ( playerid, 1, true, "Задние колёса", "-7", "7", _str, player_seekbar [ playerid ] [ 1 ] ) ;
						
					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], player_custom_wheelalignment [ playerid ] [ 1 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
				else if ( _stage == 3 ) // вылет задних колёс
				{
					if ( player_custom_wheeloffstet [ playerid ] [ 1 ] <= -17 ) return 1 ;
					
					player_seekbar [ playerid ] [ 1 ] -= 3 ;
					if ( player_seekbar [ playerid ] [ 1 ] < 0 ) player_seekbar [ playerid ] [ 1 ] = 0 ;
					
					player_custom_wheeloffstet [ playerid ] [ 1 ] -= 1 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%d", player_custom_wheeloffstet [ playerid ] [ 1 ] ) ;
					carWheelsSettings ( playerid, 1, true, "Задние колёса", "-17", "17", _str, player_seekbar [ playerid ] [ 1 ] ) ;
		
					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], player_custom_wheeloffstet [ playerid ] [ 0 ], player_custom_wheeloffstet [ playerid ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
			}
			else if ( _param3 == 2 )
			{
				if ( _stage == 0 ) // баланс подвески
				{
					if ( player_custom_suspension [ playerid ] [ 1 ] >= 0.60 ) return 1 ;
					
					player_seekbar [ playerid ] [ 1 ] += 3 ;
					if ( player_seekbar [ playerid ] [ 1 ] > 100 ) player_seekbar [ playerid ] [ 1 ] = 100 ;
					
					player_custom_suspension [ playerid ] [ 1 ] += 0.01 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%.2f", player_custom_suspension [ playerid ] [ 1 ] ) ;
					carWheelsSettings ( playerid, 1, true, "Установите баланс подвески", "0.20", "0.60", _str, player_seekbar [ playerid ] [ 1 ] ) ;
					
					SetVehicleHandling ( playerid, _v_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				else if ( _stage == 1 ) // ширина колёс
				{
					if ( player_custom_wheelwidth [ playerid ] >= 150 ) return 1 ;
					
					player_seekbar [ playerid ] [ 1 ] += 2 ;
					if ( player_seekbar [ playerid ] [ 1 ] > 100 ) player_seekbar [ playerid ] [ 1 ] = 100 ;
					
					player_custom_wheelwidth [ playerid ] += 1 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%d", player_custom_wheelwidth [ playerid ] ) ;
					carWheelsSettings ( playerid, 1, true, "Установите ширину колёс", "105", "150", _str, player_seekbar [ playerid ] [ 1 ] ) ;
		
					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												player_custom_wheelwidth [ playerid ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
				else if ( _stage == 2 ) // выворот задних колёс
				{
					if ( player_custom_wheelalignment [ playerid ] [ 1 ] >= 7 ) return 1 ;
					
					player_seekbar [ playerid ] [ 1 ] += 9 ;
					if ( player_seekbar [ playerid ] [ 1 ] > 100 ) player_seekbar [ playerid ] [ 1 ] = 100 ;
					
					player_custom_wheelalignment [ playerid ] [ 1 ] += 1 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%d", player_custom_wheelalignment [ playerid ] [ 1 ] ) ;
					carWheelsSettings ( playerid, 1, true, "Задние колёса", "-7", "7", _str, player_seekbar [ playerid ] [ 1 ] ) ;
		
					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], player_custom_wheelalignment [ playerid ] [ 1 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
				else if ( _stage == 3 ) // вылет задних колёс
				{
					if ( player_custom_wheeloffstet [ playerid ] [ 1 ] >= 17 ) return 1 ;
					
					player_seekbar [ playerid ] [ 1 ] += 3 ;
					if ( player_seekbar [ playerid ] [ 1 ] > 100 ) player_seekbar [ playerid ] [ 1 ] = 100 ;
					
					player_custom_wheeloffstet [ playerid ] [ 1 ] += 1 ;
					
					new _str [ 12 ] ;
					format ( _str, sizeof _str, "%d", player_custom_wheeloffstet [ playerid ] [ 1 ] ) ;
					carWheelsSettings ( playerid, 1, true, "Задние колёса", "-17", "17", _str, player_seekbar [ playerid ] [ 1 ] ) ;

					sc_VehicleDynamicParams ( _v_id, playerid,
												veh_info [ _v_id - 1 ] [ v_lights_color ],
												veh_info [ _v_id - 1 ] [ v_wheel_width ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ], player_custom_wheeloffstet [ playerid ] [ 0 ], player_custom_wheeloffstet [ playerid ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ],
												veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ], veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
												veh_info [ _v_id - 1 ] [ v_vinyl ],
												veh_info [ _v_id - 1 ] [ v_neon ], veh_info [ _v_id - 1 ] [ v_neon_type ] ) ;
				}
			}
		}
	}
	else if ( _param1 == 5 )
	{
		new _stage = player_submenu [ playerid ] ;
		if ( _param2 == 1 )
		{
			if ( _stage == 6 )
			{
				if ( GetTickCount ( ) - player_250ms [ playerid ] < 250 ) return 1 ;
				
				player_250ms [ playerid ] = GetTickCount ( ) ;
				
				if ( player_seekbar [ playerid ] [ 1 ] < _param3 )  player_seekbar [ playerid ] [ 1 ] = _param3 ;
				else player_seekbar [ playerid ] [ 1 ] = _param3 ;

				new _str [ 8 ] ;
				format ( _str, sizeof _str, "%d%", player_seekbar [ playerid ] [ 1 ] ) ;
				carTintSettings ( playerid, 1, true, "0%", "100%", _str, player_seekbar [ playerid ] [ 1 ] ) ;

				if ( player_seekbar [ playerid ] [ 1 ] > 90 ) veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ] = 256;
				else veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ] = player_seekbar [ playerid ] [ 1 ] * 2 ;
				sc_OnVehicleStreamIn ( _v_id, playerid ) ;
			}
		}
		else if ( _param2 == 2 )
		{
			if ( _param3 == 1 )
			{
				if ( _stage == 6 )
				{
					if ( GetTickCount ( ) - player_250ms [ playerid ] < 250 ) return 1 ;
					
					player_250ms [ playerid ] = GetTickCount ( ) ;
				
					if ( player_seekbar [ playerid ] [ 1 ] > 0 ) player_seekbar [ playerid ] [ 1 ] -= 1 ;

					new _str [ 8 ] ;
					format ( _str, sizeof _str, "%d%", player_seekbar [ playerid ] [ 1 ] ) ;
					carTintSettings ( playerid, 1, true, "0%", "100%", _str, player_seekbar [ playerid ] [ 1 ] ) ;

					if ( player_seekbar [ playerid ] [ 1 ] > 90 ) veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ] = 0xFF;
					else veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ] = player_seekbar [ playerid ] [ 1 ] * 2 ;
					sc_OnVehicleStreamIn ( _v_id, playerid ) ;
				}
			}
			else if ( _param3 == 2 )
			{
				if ( _stage == 6 )
				{
					if ( player_seekbar [ playerid ] [ 1 ] < 100 ) player_seekbar [ playerid ] [ 1 ] += 1 ;

					new _str [ 8 ] ;
					format ( _str, sizeof _str, "%d%", player_seekbar [ playerid ] [ 1 ] ) ;
					carTintSettings ( playerid, 1, true, "0%", "100%", _str, player_seekbar [ playerid ] [ 1 ] ) ;

					if ( player_seekbar [ playerid ] [ 1 ] > 90 ) veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ] = 0xFF;
					else veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ] = player_seekbar [ playerid ] [ 1 ] * 2 ;
					sc_OnVehicleStreamIn ( _v_id, playerid ) ;
				}
			}
		}
	}
	else if ( _param1 == 7 )
	{
		if ( _param2 == 1 )
		{
			if ( player_tune_color [ playerid ] == 0 ) 
			{
				player_tune_color [ playerid ] = 1 ;
				carColorLayout ( playerid, true, "Цвет кузова #2", true, false ) ;
			}
			else
			{
				player_tune_color [ playerid ] = 0 ;
				carColorLayout ( playerid, true, "Цвет кузова #1", true, false ) ;
			}
		}
	}
	else if ( _param1 == 8 )
	{
		if ( _param2 == 1 )
		{
			if ( _param3 == 0 )
			{
				carCartLayout ( playerid, false, "" ) ;
				clearCartItem ( playerid ) ;
			}
			else if ( _param3 == 1 )
			{
				carCartLayout ( playerid, false, "" ) ;
				clearCartItem ( playerid ) ;
				
				if ( player_perfomance [ playerid ] )
				{
					for ( new i = 0 ; i < 5 ; i ++ )
					{
						p_t_info [ playerid ] [ pt_engine ] [ i ] =
						p_t_info [ playerid ] [ pt_brake ] [ i ] =
						p_t_info [ playerid ] [ pt_stability ] [ i ] = 0 ;
					}
					
					new _str [ 32 ], _str2 [ 8 ] ;
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
					format ( _str2, sizeof _str2, "%d", GetTuningCount ( playerid ) ) ;
					showTune ( playerid, GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), _str, _str2, GetTuningTotalPrice ( playerid ) ) ;
					return 1 ;
				}
				
				p_t_info [ playerid ] [ component_id ] [ 0 ] =
				p_t_info [ playerid ] [ component_id ] [ 1 ] = -1 ;
				
				p_t_info [ playerid ] [ component_id ] [ 9 ] =
				p_t_info [ playerid ] [ component_id ] [ 10 ] =
				p_t_info [ playerid ] [ component_id ] [ 11 ] = 0 ;
				
				new _str [ 32 ], _str2 [ 8 ] ;
				format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
				format ( _str2, sizeof _str2, "%d", GetTuningCount ( playerid ) ) ;
				showTune ( playerid, GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), _str, _str2, GetTuningTotalPrice ( playerid ) ) ;
			
				new point = -1,
					_v_model = getReplacableVehicleModel ( _v_id ) ;

				for ( new i = 0; i <= 91 ; i ++ )
				{
					if ( _v_model == legal_tuns [ i ] [ 0 ] )
					{
						point = i;
						break ;
					}
				}
				
				if ( point != -1 )
				{
					for ( new j = 0; j <= 57  ; j ++ )
					{
						RemoveVehicleComponent ( _v_id, legal_tuns [ point ] [ j ] ) ;
					}
				}
				
				for ( new j = 0 ; j < 10 ; j ++ )
				{
					if ( veh_info [ _v_id - 1 ] [ v_component ] [ j ] == 0 ) continue ;
					AddVehicleComponent ( veh_info [ _v_id - 1 ] [ v_vehicle ], veh_info [ _v_id - 1 ] [ v_component ] [ j ] ) ;
				}
				
				if ( veh_info [ _v_id - 1 ] [ v_paint ] != 3 )
				{
					n_ChangeVehicleColor ( _v_id, veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ] ) ;
					ChangeVehiclePaintjob ( _v_id, veh_info [ _v_id - 1 ] [ v_paint ] ) ;
				}
				else
				{
					ChangeVehiclePaintjob ( _v_id, 3 ) ;
					n_ChangeVehicleColor ( _v_id, veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ] ) ;
				}
				
				clear_car_custom ( _v_id, 3, playerid ) ;
			}
			else if ( _param3 == 2 )
			{
				new _price = 0, _b_id = GetPVarInt ( playerid, "p_biz_id" ), bool: _sucess_product = false ;
				
				if ( player_perfomance [ playerid ] )
				{
					new _id ;
					for ( new i = 0 ; i < 5 ; i ++ )
					{
						_id = p_t_info [ playerid ] [ pt_engine ] [ i ] ;
						if ( _id == 1 )
						{
							if ( _b_id > 0 ) _price += engine_ptune_price [ i ] * b_info [ _b_id - 1 ] [ b_cost ] ;
							else _price += engine_ptune_price [ i ] ;
						}
						
						_id = p_t_info [ playerid ] [ pt_brake ] [ i ] ;
						if ( _id == 1 )
						{
							if ( _b_id > 0 ) _price += brake_ptune_price [ i ] * b_info [ _b_id - 1 ] [ b_cost ] ;
							else _price += brake_ptune_price [ i ] ;
						}
						
						_id = p_t_info [ playerid ] [ pt_stability ] [ i ] ;
						if ( _id == 1 )
						{
							if ( _b_id > 0 ) _price += stability_ptune_price [ i ] * b_info [ _b_id - 1 ] [ b_cost ] ;
							else _price += stability_ptune_price [ i ] ;
						}
					}
					
					if ( p_info [ playerid ] [ money ] < _price )
						return send_check_cinfo ( playerid, "У Вас не достаточно средств!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;

					if ( _b_id > 0 && b_info [ _b_id - 1 ] [ b_product ] < 120 ) _sucess_product = true ;
						
					give_money ( playerid, -_price ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, -_price, "perfomance тюнинг" ) ;
						
					checking_quest_progress ( playerid, 6, 1, quest_line_medium ) ;
					give_event_progress ( playerid, THE_PERFOMANCE_VEHICLE, 1 ) ;

					if ( _b_id > 0 && ! _sucess_product ) give_bmoney ( _b_id, floatround ( _price / 10 ), 120 ) ;
					
					for ( new i = 0 ; i < 5 ; i ++ )
					{
						_id = p_t_info [ playerid ] [ pt_engine ] [ i ] ;
						if ( _id == 1 )
						{
							p_t_info [ playerid ] [ pt_engine ] [ i ] = 0 ;
							veh_info [ _v_id - 1 ] [ v_pt_engine ] [ i ] = 1 ;
							veh_info [ _v_id - 1 ] [ v_engine_boost ] += engine_ptune_boost [ i ] ;
						}
						
						_id = p_t_info [ playerid ] [ pt_brake ] [ i ] ;
						if ( _id == 1 )
						{
							p_t_info [ playerid ] [ pt_brake ] [ i ] = 0 ;
							veh_info [ _v_id - 1 ] [ v_pt_brake ] [ i ] = 1 ;
							veh_info [ _v_id - 1 ] [ v_brake_boost ] += brake_ptune_boost [ i ] ;
						}
						
						_id = p_t_info [ playerid ] [ pt_stability ] [ i ] ;
						if ( _id == 1 )
						{
							p_t_info [ playerid ] [ pt_stability ] [ i ] = 0 ;
							veh_info [ _v_id - 1 ] [ v_pt_stability ] [ i ] = 1 ;
							veh_info [ _v_id - 1 ] [ v_stability_boost ] += stability_ptune_boost [ i ] ;
						}
					}
				
					clear_car_custom ( _v_id, 3, playerid ) ;
					save_perfomance ( _v_id ) ;
					
					carCartLayout ( playerid, false, "" ) ;
					clearCartItem ( playerid ) ;
				
					new _str [ 32 ], _str2 [ 8 ] ;
					format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
					format ( _str2, sizeof _str2, "%d", GetTuningCount ( playerid ) ) ;
					showTune ( playerid, GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), _str, _str2, GetTuningTotalPrice ( playerid ) ) ;
					return 1 ;
				}
				
				for ( new i = 0 ; i < 12 ; i ++ )
				{
					new _comp_id = p_t_info [ playerid ] [ component_id ] [ i ] ;
					if ( _comp_id == -1 || _comp_id == 0 ) continue ;
							
					if ( _b_id > 0 ) _price += tuning_price [ i ] * b_info [ _b_id - 1 ] [ b_cost ] ;
					else _price += tuning_price [ i ] ;
				}
					
				if ( p_info [ playerid ] [ money ] < _price )
					return send_check_cinfo ( playerid, "У Вас не достаточно средств!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;

				if ( _b_id > 0 && b_info [ _b_id - 1 ] [ b_product ] < 120 ) _sucess_product = true ;
					
				give_money ( playerid, -_price ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, -_price, "кастомный тюнинг" ) ;
					
				checking_quest_progress ( playerid, 6, 1, quest_line_medium ) ;

				if ( _b_id > 0 && ! _sucess_product ) give_bmoney ( _b_id, floatround ( _price / 10 ), 120 ) ;
				
				for ( new j = 2 ; j < 12 ; j ++ )
				{
					new _comp_id = p_t_info [ playerid ] [ component_id ] [ j ] ;
					if ( _comp_id == 0 || _comp_id == -1 ) continue ;
					
					veh_info [ _v_id - 1 ] [ v_component ] [ j - 2 ] = _comp_id ;
				}
				
				if ( p_t_info [ playerid ] [ component_id ] [ 0 ] != -1 )
				{
					veh_info [ _v_id - 1 ] [ v_color ] [ 0 ] = p_t_info [ playerid ] [ component_id ] [ 0 ] ;
					give_event_progress ( playerid, THE_PAINT_VEHICLE, 1 ) ;
				}
				if ( p_t_info [ playerid ] [ component_id ] [ 1 ] != -1 )
				{
					veh_info [ _v_id - 1 ] [ v_color ] [ 1 ] = p_t_info [ playerid ] [ component_id ] [ 1 ] ;
					give_event_progress ( playerid, THE_PAINT_VEHICLE, 1 ) ;
				}
				
				new point = -1,
					_v_model = getReplacableVehicleModel ( _v_id ) ;

				for ( new i = 0; i <= 91 ; i ++ )
				{
					if ( _v_model == legal_tuns [ i ] [ 0 ] )
					{
						point = i;
						break ;
					}
				}
				
				if ( point != -1 )
				{
					for ( new j = 0; j <= 57  ; j ++ )
					{
						RemoveVehicleComponent ( _v_id, legal_tuns [ point ] [ j ] ) ;
					}
				}
				
				for ( new j = 0 ; j < 10 ; j ++ )
				{
					if ( veh_info [ _v_id - 1 ] [ v_component ] [ j ] == 0 ) continue ;
					AddVehicleComponent ( veh_info [ _v_id - 1 ] [ v_vehicle ], veh_info [ _v_id - 1 ] [ v_component ] [ j ] ) ;
				}
				
				if ( veh_info [ _v_id - 1 ] [ v_paint ] != 3 )
				{
					n_ChangeVehicleColor ( _v_id, veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ] ) ;
					ChangeVehiclePaintjob ( _v_id, veh_info [ _v_id - 1 ] [ v_paint ] ) ;
				}
				else
				{
					ChangeVehiclePaintjob ( _v_id, 3 ) ;
					n_ChangeVehicleColor ( _v_id, veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ] ) ;
				}
				
				p_t_info [ playerid ] [ component_id ] [ 0 ] =
				p_t_info [ playerid ] [ component_id ] [ 1 ] = -1 ;
				p_t_info [ playerid ] [ component_id ] [ 9 ] =
				p_t_info [ playerid ] [ component_id ] [ 10 ] =
				p_t_info [ playerid ] [ component_id ] [ 11 ] = 0 ;
				
				clear_car_custom ( _v_id, 3, playerid ) ;
				save_tuning ( playerid ) ;
				
				carCartLayout ( playerid, false, "" ) ;
				clearCartItem ( playerid ) ;
			
				new _str [ 32 ], _str2 [ 8 ] ;
				format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
				format ( _str2, sizeof _str2, "%d", GetTuningCount ( playerid ) ) ;
				showTune ( playerid, GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), _str, _str2, GetTuningTotalPrice ( playerid ) ) ;
			}
		}
		else if ( _param2 == 2 )
		{
			if ( player_perfomance [ playerid ] )
			{
				send_check_cinfo ( playerid, "Очистите корзину полностью!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			static const _t_id [ ] = { 0, 1, 9, 10, 11 } ;
			if ( _param3 < 2 )
			{
				p_t_info [ playerid ] [ component_id ] [ _t_id [ _param3 ] ] = -1 ;
				
				if ( p_t_info [ playerid ] [ component_id ] [ 0 ] == -1 && p_t_info [ playerid ] [ component_id ] [ 1 ] != -1 ) ChangeVehicleColor ( _v_id, veh_info [ _v_id - 1 ] [ v_color ] [ 0 ], p_t_info [ playerid ] [ component_id ] [ 1 ] ) ;
				else if ( p_t_info [ playerid ] [ component_id ] [ 0 ] != -1 && p_t_info [ playerid ] [ component_id ] [ 1 ] == -1 ) ChangeVehicleColor ( _v_id, p_t_info [ playerid ] [ component_id ] [ 0 ], veh_info [ _v_id - 1 ] [ v_color ] [ 1 ] ) ;
				else ChangeVehicleColor ( _v_id, p_t_info [ playerid ] [ component_id ] [ 0 ], p_t_info [ playerid ] [ component_id ] [ 1 ] ) ;
			}
			else 
			{
				RemoveVehicleComponent ( _v_id, p_t_info [ playerid ] [ component_id ] [ _t_id [ _param3 ] ] ) ;
				p_t_info [ playerid ] [ component_id ] [ _t_id [ _param3 ] ] = 0 ;
			
				for ( new j = 0 ; j < 10 ; j ++ )
				{
					if ( veh_info [ _v_id - 1 ] [ v_component ] [ j ] == 0 ) continue ;
					AddVehicleComponent ( veh_info [ _v_id - 1 ] [ v_vehicle ], veh_info [ _v_id - 1 ] [ v_component ] [ j ] ) ;
				}
			}
			
			new _str [ 32 ], _str2 [ 8 ] ;
			format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ money ] ) ) ;
			format ( _str2, sizeof _str2, "%d", GetTuningCount ( playerid ) ) ;
			showTune ( playerid, GetVehicleNameEx ( veh_info [ _v_id - 1 ] [ v_vehicle ] ), _str, _str2, GetTuningTotalPrice ( playerid ) ) ;
		}
	}
	return 1 ;
}

stock GetTuningCount ( playerid )
{
	new _count = 0 ;
	if ( player_perfomance [ playerid ] )
	{
		new _id ;
		for ( new i = 0 ; i < 5 ; i ++ )
		{
			_id = p_t_info [ playerid ] [ pt_engine ] [ i ] ;
			if ( _id == 1 ) _count ++ ;
			
			_id = p_t_info [ playerid ] [ pt_brake ] [ i ] ;
			if ( _id == 1 ) _count ++ ;
			
			_id = p_t_info [ playerid ] [ pt_stability ] [ i ] ;
			if ( _id == 1 ) _count ++ ;
		}
	}
	else
	{
		for ( new i = 0 ; i < 12 ; i ++ )
		{
			new _comp_id = p_t_info [ playerid ] [ component_id ] [ i ] ;
			if ( _comp_id == -1 || _comp_id == 0 ) continue ;
					
			_count ++ ;
		}
	}
	return _count ;
}

stock GetTuningTotalPrice ( playerid )
{
	new _str [ 32 ], _total_price = 0, _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
	if ( player_perfomance [ playerid ] )
	{
		new _id ;
		for ( new i = 0 ; i < 5 ; i ++ )
		{
			_id = p_t_info [ playerid ] [ pt_engine ] [ i ] ;
			if ( _id == 1 )
			{
				if ( _b_id > 0 ) _total_price += engine_ptune_price [ i ] * b_info [ _b_id - 1 ] [ b_cost ] ;
				else _total_price += engine_ptune_price [ i ] ;
			}
			
			_id = p_t_info [ playerid ] [ pt_brake ] [ i ] ;
			if ( _id == 1 )
			{
				if ( _b_id > 0 ) _total_price += brake_ptune_price [ i ] * b_info [ _b_id - 1 ] [ b_cost ] ;
				else _total_price += brake_ptune_price [ i ] ;
			}
			
			_id = p_t_info [ playerid ] [ pt_stability ] [ i ] ;
			if ( _id == 1 )
			{
				if ( _b_id > 0 ) _total_price += stability_ptune_price [ i ] * b_info [ _b_id - 1 ] [ b_cost ] ;
				else _total_price += stability_ptune_price [ i ] ;
			}
		}
	}
	else
	{
		for ( new i = 0 ; i < 12 ; i ++ )
		{
			new _comp_id = p_t_info [ playerid ] [ component_id ] [ i ] ;
			if ( _comp_id == -1 || _comp_id == 0 ) continue ;
					
			if ( _b_id > 0 ) _total_price += tuning_price [ i ] * b_info [ _b_id - 1 ] [ b_cost ] ;
			else _total_price += tuning_price [ i ] ;
		}
	}
	format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( _total_price ) ) ;
	return _str ;
}

stock save_perfomance ( _veh_id )
{
		new _v_type = veh_info [ _veh_id - 1 ] [ v_type ] ;
	    if ( _v_type == vehicle_type_player )
		{
		    global_string [ 0 ] = EOS ;
			format ( global_string, 356, "UPDATE `users_vehicles` SET `v_eng_details` = '%d|%d|%d|%d|%d', `v_engine_boost` = '%f', \
																						`v_brake_details` = '%d|%d|%d|%d|%d', `v_brake_boost` = '%f', \
																						`v_stab_details` = '%d|%d|%d|%d|%d', `v_stability_boost` = '%f' WHERE `v_id` = '%d' LIMIT 1",
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 0 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 1 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 2 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 3 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 4 ],
			veh_info [ _veh_id - 1 ] [ v_engine_boost ],

			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 0 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 1 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 2 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 3 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 4 ],
			veh_info [ _veh_id - 1 ] [ v_brake_boost ],

			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 0 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 1 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 2 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 3 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 4 ],
			veh_info [ _veh_id - 1 ] [ v_stability_boost ],

			veh_info [ _veh_id - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, global_string ) ;
		}
		else if ( _v_type == vehicle_type_family )
		{
		    global_string [ 0 ] = EOS ;
			format ( global_string, 356, "UPDATE `familys_vehicles` SET `v_eng_details` = '%d|%d|%d|%d|%d',`sv_engine_boost` = '%f', \
																							`v_brake_details` = '%d|%d|%d|%d|%d',`sv_brake_boost` = '%f', \
																							`v_stab_details` = '%d|%d|%d|%d|%d',`sv_stability_boost` = '%f' WHERE `sv_id` = '%d' LIMIT 1",
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 0 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 1 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 2 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 3 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 4 ],
			veh_info [ _veh_id - 1 ] [ v_engine_boost ],

			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 0 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 1 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 2 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 3 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 4 ],
			veh_info [ _veh_id - 1 ] [ v_brake_boost ],

			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 0 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 1 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 2 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 3 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 4 ],
			veh_info [ _veh_id - 1 ] [ v_stability_boost ],
					
			veh_info [ _veh_id - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, global_string ) ;
		}
		else if ( _v_type == vehicle_type_rentcar )
		{
		    global_string [ 0 ] = EOS ;
			format ( global_string, 356, "UPDATE `rent_vehicles` SET `v_eng_details` = '%d|%d|%d|%d|%d',`sv_engine_boost` = '%f', \
																						`v_brake_details` = '%d|%d|%d|%d|%d',`sv_brake_boost` = '%f', \
																						`v_stab_details` = '%d|%d|%d|%d|%d',`sv_stability_boost` = '%f' WHERE `sv_id` = '%d' LIMIT 1",
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 0 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 1 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 2 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 3 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 4 ],
			veh_info [ _veh_id - 1 ] [ v_engine_boost ],

			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 0 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 1 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 2 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 3 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 4 ],
			veh_info [ _veh_id - 1 ] [ v_brake_boost ],

			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 0 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 1 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 2 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 3 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 4 ],
			veh_info [ _veh_id - 1 ] [ v_stability_boost ],

			veh_info [ _veh_id - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, global_string ) ;
		}
		else if ( _v_type == vehicle_type_house )
		{
		    global_string [ 0 ] = EOS ;
			format ( global_string, 356, "UPDATE `house_vehicles` SET `v_eng_details` = '%d|%d|%d|%d|%d',`sv_engine_boost` = '%f', \
																						`v_brake_details` = '%d|%d|%d|%d|%d',`sv_brake_boost` = '%f', \
																						`v_stab_details` = '%d|%d|%d|%d|%d',`sv_stability_boost` = '%f' WHERE `sv_id` = '%d' LIMIT 1",
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 0 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 1 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 2 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 3 ],
			veh_info [ _veh_id - 1 ] [ v_pt_engine ] [ 4 ],
			veh_info [ _veh_id - 1 ] [ v_engine_boost ],

			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 0 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 1 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 2 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 3 ],
			veh_info [ _veh_id - 1 ] [ v_pt_brake ] [ 4 ],
			veh_info [ _veh_id - 1 ] [ v_brake_boost ],

			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 0 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 1 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 2 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 3 ],
			veh_info [ _veh_id - 1 ] [ v_pt_stability ] [ 4 ],
			veh_info [ _veh_id - 1 ] [ v_stability_boost ],

			veh_info [ _veh_id - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, global_string ) ;
		}
		return 1 ;
}