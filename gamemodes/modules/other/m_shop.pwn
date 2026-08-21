
#define MAX_AUTO_SALON_VEHICLE      	100

enum E_PLAYER_AUTO_SALON_STRUCT
{
    PAS_SELECTED_CAR,
    PAS_SELECTED_COLOR_R,
    PAS_SELECTED_COLOR_G,
    PAS_SELECTED_COLOR_B,
    PAS_CREATED_CAR,
    PAS_SELECTED_AUTO_SALON
} ;
new g_player_auto_salon [ MAX_PLAYERS ] [ E_PLAYER_AUTO_SALON_STRUCT ] ;

new 
	g_player_auto_salon_def_val [ E_PLAYER_AUTO_SALON_STRUCT ] =
{
    0,
    0,
    0,
    0,
    INVALID_VEHICLE_ID,
    0
} ;

#define ClearPlayerAutoSalonInfo(%0) 		g_player_auto_salon[%0] = g_player_auto_salon_def_val

#define GetPlayerAutoSalonData(%0,%1) 		g_player_auto_salon[%0][%1]
#define SetPlayerAutoSalonData(%0,%1,%2)	g_player_auto_salon[%0][%1] = %2
#define AddPlayerAutoSalonData(%0,%1,%2,%3)	g_player_auto_salon[%0][%1] %2= %3

#define MAX_AUTO_SALON_VEHICLE      100
new g_auto_salon_max_vehicles [ VEHICLE_CLASS_MAX ] ;

enum E_AUTO_SALON_VEHICLE_STRUCT
{
    ASV_MODEL_ID,
    ASV_PRICE
} ;
new g_auto_salon_vehicle [ MAX_AUTO_SALON_VEHICLE ] [ VEHICLE_CLASS_MAX ] [ E_AUTO_SALON_VEHICLE_STRUCT ] ;

#define GetAutoSalonVehicleData(%0,%1,%2) 	g_auto_salon_vehicle[%0][%1][%2]
#define AutoSalonVehicleModelID(%0,%1)		GetAutoSalonVehicleData(%0, %1, ASV_MODEL_ID) 

#define MAX_AUTO_SALON_VEHICLE_COLOR	10

enum E_AUTO_SALON_VEH_COLOR_STRUCT
{
    ASVC_HEX [ 24 ],
    ASVC_COLOR_R,
    ASVC_COLOR_G,
    ASVC_COLOR_B
} ;

new g_auto_salon_vehicle_color [ MAX_AUTO_SALON_VEHICLE_COLOR ] [ E_AUTO_SALON_VEH_COLOR_STRUCT ] =
{
	{ "#FF0000", 255, 0, 0 },
    { "#FF7E36", 255, 126, 54 },
    { "#54E0FF", 84, 224, 255 },
    { "#9BFF6B", 155, 255, 107 },
    { "#FCFF5C", 252, 255, 92 },
    { "#3870FF", 56, 112, 255 },
    { "#8C46FF", 140, 70, 255 },
    { "#FB39FF", 251, 57, 255 },
    { "#000000", 0, 0, 0 },
    { "#FFFFFF", 255, 255, 255 }
} ;

stock show_car_showroom ( playerid )
{
	#if defined debug_packet
		printf ( "[show_car_showroom] playerid: %d", playerid ) ;
	#endif

	global_string [ 0 ] = EOS ;
	format ( global_string, 100, "%d", p_info [ playerid ] [ money ] ) ;
	onServerSendData ( playerid, UI_CAR_SHOWROOM, 1, global_string ) ;

	new Node: node = JSON_Object ( ), classId = GetPlayerAutoSalonData ( playerid, PAS_SELECTED_AUTO_SALON ) ;
	switch ( classId )
	{
		case VEHICLE_CLASS_LOW:
		{
			node = JSON_Object (
				"type",			JSON_String ( "АВТОСАЛОН" ),
				"className",	JSON_String ( "эконом" )
			) ;
		}
		case VEHICLE_CLASS_MEDIUM:
		{
			node = JSON_Object (
				"type",			JSON_String ( "АВТОСАЛОН" ),
				"className",	JSON_String ( "средний" )
			) ;
		}
		case VEHICLE_CLASS_HIGH:
		{
			node = JSON_Object (
				"type",			JSON_String ( "АВТОСАЛОН" ),
				"className",	JSON_String ( "премиум" )
			) ;
		}
		case VEHICLE_CLASS_MOTO:
		{
			node = JSON_Object (
				"type",			JSON_String ( "МОТОСАЛОН" ),
				"className",	JSON_String ( "~" )
			) ;
		}
	}
	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_CAR_SHOWROOM, 2, global_string ) ;

	initColorsAdapter ( playerid ) ;
	initCarsAdapter ( playerid, classId ) ;
		
	toggle_controlable ( playerid, false ) ;
	return 1 ;
}

stock initColorsAdapter ( playerid )
{
	new Node: node = JSON_Array ( ) ;
	for ( new i = 0, Node: nodeColor ; i < MAX_AUTO_SALON_VEHICLE_COLOR ; i ++ )
	{
		nodeColor = JSON_Array (
			JSON_String ( g_auto_salon_vehicle_color [ i ] [ ASVC_HEX ] )
		) ;

		node = JSON_Append ( node, nodeColor ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_CAR_SHOWROOM, 3, global_string ) ;
	return true ;
}

stock initCarsAdapter ( playerid, classId )
{
	new Node: node = JSON_Array ( ), modelId ;
	for ( new i = 0, Node: nodeCar, itemsLoaded = 0 ; i < g_auto_salon_max_vehicles [ classId ] ; i ++ )
	{
		modelId = AutoSalonVehicleModelID ( i, classId ) ;
		nodeCar = JSON_Array (
			JSON_Object (
				"name",			JSON_String ( GetVehicleNameEx ( INVALID_VEHICLE_ID, modelId ) ),
				"model",		JSON_Int ( modelId ),
				"color1",  		JSON_Int ( 0 ),
				"color2",      	JSON_Int ( 0 ),
				"rotX",			JSON_Float ( 20.0 ),
				"rotY",			JSON_Float ( 180.0 ),
				"rotZ",			JSON_Float ( 45.0 ),
				"zoom",			JSON_Float ( 0.78 )
			)
		) ;
		node = JSON_Append ( node, nodeCar ) ;

		if ( ++ itemsLoaded == 5 || i == g_auto_salon_max_vehicles [ classId ] - 1 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_CAR_SHOWROOM, 4, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
	}
	return true ;
}

stock update_car_showroom ( playerid )
{
	#if defined debug_packet
		printf ( "[update_car_showroom] playerid: %d", playerid ) ;
	#endif

	new vehicleId = GetPlayerAutoSalonData ( playerid, PAS_CREATED_CAR ),
		modelId = GetVehicleModelEx ( vehicleId ) ;
	new Node: node = JSON_Object (
		"price",			JSON_Int ( GetModelPrice ( modelId ) ),
		"speed",			JSON_Int ( max_veh_speed ( modelId ) ),
		"fuelCapacity",		JSON_Int ( 100 ),
		"trunkCapacity",	JSON_Int ( getTrunkCapacity ( INVALID_VEHICLE_ID, modelId ) )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_CAR_SHOWROOM, 0, global_string ) ;
	return 1 ;
}

stock show_packet_car_showroom ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 ) // buy
	{
		p_t_info [ playerid ] [ p_dialog ] = d_carbuy_info ;
		OnDialogResponse ( playerid, d_carbuy_info, 1, 0, "" ) ;
	}
	else if ( actionId == 1 ) // previous
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new idx, modelId ;
		JSON_GetInt ( json, "id", idx ) ;
		JSON_GetInt ( json, "model", modelId ) ;

		GetPlayerAutoSalonData ( playerid, PAS_SELECTED_CAR ) = idx ;
		initCarShopModel ( playerid, modelId ) ;
		//nextVehicleCarShop ( playerid, false, false ) ;
	}
	else if ( actionId == 2 ) // next
	{
		//nextVehicleCarShop ( playerid, true, false ) ;
	}
	else if ( actionId == 3 ) // color
	{
		new color_index = -1, _v_id = GetPlayerAutoSalonData ( playerid, PAS_CREATED_CAR ) ;
        for ( new idx = 0 ; idx < MAX_AUTO_SALON_VEHICLE_COLOR ; idx ++ )
        {
        	if ( strfind ( g_auto_salon_vehicle_color [ idx ] [ ASVC_HEX ], data ) != -1 )
            {
               	color_index = idx ;
                break ;
            }
        }

        SetPlayerAutoSalonData ( playerid, PAS_SELECTED_COLOR_R, g_auto_salon_vehicle_color [ color_index ] [ ASVC_COLOR_R ] ) ;
        SetPlayerAutoSalonData ( playerid, PAS_SELECTED_COLOR_G, g_auto_salon_vehicle_color [ color_index ] [ ASVC_COLOR_G ] ) ;
        SetPlayerAutoSalonData ( playerid, PAS_SELECTED_COLOR_B, g_auto_salon_vehicle_color [ color_index ] [ ASVC_COLOR_B ] ) ;
		veh_info [ _v_id - 1 ] [ v_main_color ] [ 0 ] = GetPlayerAutoSalonData ( playerid, PAS_SELECTED_COLOR_R ) ;
		veh_info [ _v_id - 1 ] [ v_main_color ] [ 1 ] = GetPlayerAutoSalonData ( playerid, PAS_SELECTED_COLOR_G ) ;
		veh_info [ _v_id - 1 ] [ v_main_color ] [ 2 ] = GetPlayerAutoSalonData ( playerid, PAS_SELECTED_COLOR_B ) ;
		sc_OnVehicleStreamIn ( _v_id, playerid ) ;
	}
	else if ( actionId == 5 ) // destroy
	{
		onServerDestroy ( playerid, UI_CAR_SHOWROOM ) ;
		clear_carbuy ( playerid ) ;
            
		toggle_controlable ( playerid, true ) ;
	}
	else if ( actionId == 6 ) // test drive
	{
		SetCameraBehindPlayer ( playerid ) ;
		onServerDestroy ( playerid, UI_CAR_SHOWROOM ) ;
		toggle_controlable ( playerid, true ) ;
		
		new classId = GetPlayerAutoSalonData ( playerid, PAS_SELECTED_AUTO_SALON ),
			ts_vehicle = GetPlayerAutoSalonData ( playerid, PAS_CREATED_CAR ) ;

		set_world ( playerid, 0 ) ;
		set_interior ( playerid, 0 ) ;

		new ts_spawn_slot = random ( 5 ) ;
		p_t_info [ playerid ] [ test_drive ] = CreateVehicle ( GetVehicleModelEx ( ts_vehicle ),
																t_shop_respawn [ classId - 1 ] [ ts_spawn_slot ] [ 0 ],
																t_shop_respawn [ classId - 1 ] [ ts_spawn_slot ] [ 1 ],
																t_shop_respawn [ classId - 1 ] [ ts_spawn_slot ] [ 2 ],
																t_shop_respawn [ classId - 1 ] [ ts_spawn_slot ] [ 3 ],
																veh_info [ ts_vehicle - 1 ] [ v_color ] [ 0 ], veh_info [ ts_vehicle - 1 ] [ v_color ] [ 1 ], -1 ) ;

		new veh_id = p_t_info [ playerid ] [ test_drive ] ;
		PutPlayerInVehicle ( playerid, veh_id, 0 ) ;
		veh_info [ veh_id - 1 ] [ v_vehicle ] = veh_id ;
		veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;

		veh_info [ veh_id - 1 ] [ v_main_color ] [ 0 ] = GetPlayerAutoSalonData ( playerid, PAS_SELECTED_COLOR_R ) ;
		veh_info [ veh_id - 1 ] [ v_main_color ] [ 1 ] = GetPlayerAutoSalonData ( playerid, PAS_SELECTED_COLOR_G ) ;
		veh_info [ veh_id - 1 ] [ v_main_color ] [ 2 ] = GetPlayerAutoSalonData ( playerid, PAS_SELECTED_COLOR_B ) ;
		sc_OnVehicleStreamIn ( veh_id, playerid ) ;

    	if ( IsValidVehicle ( GetPlayerAutoSalonData ( playerid, PAS_CREATED_CAR ) ) )
       		DestroyVehicle ( GetPlayerAutoSalonData ( playerid, PAS_CREATED_CAR ), 1513 ) ;

		new engine, lights, alarm, doors, bonnet, boot, objective ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective ) ;
	    SetVehicleParamsEx ( veh_id, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective ) ;

		toggle_engine ( playerid, veh_id ) ;
		toggle_lights ( playerid, veh_id ) ;

		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		toggle_locked ( playerid, veh_id ) ;

		if ( IsValidDynamic3DTextLabel ( veh_info [ veh_id - 1 ] [ v_label ] ) )
		{
	  		DestroyDynamic3DTextLabel ( veh_info [ veh_id - 1 ] [ v_label ] ) ;
			veh_info [ veh_id - 1 ] [ v_label ] = Text3D:INVALID_3DTEXT_ID ;
		}

		veh_info [ veh_id - 1 ] [ v_test_drive ] = true ;
		veh_info [ veh_id - 1 ] [ v_label ] = CreateDynamic3DTextLabel("** ТЕСТ-ДРАЙВ **", col_blue, 0.0, 0.0, 1.3, 10.0, INVALID_PLAYER_ID, veh_id, 1);
		SetVehicleNumberPlate ( veh_info [ veh_id - 1 ] [ v_vehicle ], "Test-Drive" ) ;

      	show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация:",
		"{"#cBL"}Информация о транспорте:\n\n{"#cBL"}- {"#cWH"}Вы выбрали тест-драйв.\n{"#cBL"}- {"#cWH"}Тестируйте т/с катаясь по городу.\n\n{"#cBL"}- {"#cWH"}Покинув транспорт вы вернётесь в салон.\n\n{"#cGRDialog"}* Вы ознакомились с информацией и желаете продолжить?", "Закрыть", "" ) ;
	}
	return 1 ;
}

new player_clothes_select [ MAX_PLAYERS char ] ;
stock show_clothes ( playerid, _type )
{
	if ( _type == 1 ) onServerSendData ( playerid, UI_CLOTHES_N_ACS, 1, "м а г а з и н  о д е ж д ы" ) ;
	else onServerSendData ( playerid, UI_CLOTHES_N_ACS, 1, "м а г а з и н  а к с е с с у а р о в" ) ;
	player_clothes_select { playerid } = _type ;
	update_clothes ( playerid ) ;
	toggle_controlable ( playerid, false ) ;
	return 1 ;
}

stock update_clothes ( playerid )
{
	#if defined debug_packet
		printf ( "[update_clothes] playerid: %d", playerid ) ;
	#endif

	if ( player_clothes_select { playerid } == 1 )
	{
		new _ss_number = GetPVarInt ( playerid, "skin_select_number" ),
			_gender = p_info [ playerid ] [ gender ],
			_skinId = shop_skins [ _gender ] [ _ss_number ] ;
		new Node: node = JSON_Object (
			"itemName",			JSON_String ( item_name ( _skinId ) ),
			"itemPrice",		JSON_Int ( shop_skins_price [ _gender ] [ _ss_number ] )
		) ;

		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_CLOTHES_N_ACS, 0, global_string ) ;
	}
	else if ( player_clothes_select { playerid } == 2 )
	{
		new acc_number = GetPVarInt ( playerid, "p_acc_id" ),
			acc_type = GetPVarInt ( playerid, "p_acc_listitem" ) - 1,
			_acsId = accessories_items [ acc_type ] [ acc_number ] ;
		new Node: node = JSON_Object (
			"itemName",			JSON_String ( item_name ( _acsId ) ),
			"itemPrice",		JSON_Int ( accessories_items_price [ acc_type ] [ acc_number ] )
		) ;

		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_CLOTHES_N_ACS, 0, global_string ) ;
	}
	return 1 ;
}

stock show_packet_clothes ( playerid, actionId, data [ ] )
{
	#pragma unused data
	if ( actionId == 0 ) // left
	{
		if ( player_clothes_select { playerid } == 1 )
		{
			new _gender = p_info [ playerid ] [ gender ], skin_count = GetPVarInt ( playerid, "skin_select_number" ) ;
			if ( skin_count == 0 )
			{
				if ( _gender == 0 )
				{
					skin_count = last_skin_shop [ 0 ] ;
					SetPVarInt ( playerid, "skin_select_number", skin_count ) ;
					SetPlayerSkin ( playerid, shop_skins [ _gender ] [ skin_count ] ) ;
				
					update_clothes ( playerid ) ;
					return 1 ;
				}
				else if ( _gender == 1 )
				{
					skin_count = last_skin_shop [ 1 ] ;
					SetPVarInt ( playerid, "skin_select_number", skin_count ) ;
					SetPlayerSkin ( playerid, shop_skins [ _gender ] [ skin_count ] ) ;
				}
			}

			SetPVarInt ( playerid, "skin_select_number", skin_count - 1 ) ;
			SetPlayerSkin ( playerid, shop_skins [ _gender ] [ skin_count - 1 ] ) ;
		}
		else if ( player_clothes_select { playerid } == 2 )
		{
			new acc_number = GetPVarInt ( playerid, "p_acc_id" ),
				acc_type = GetPVarInt ( playerid, "p_acc_listitem" ) - 1 ;

			if ( acc_number == 0 )
			{
				for ( new j = 0 ; j < 50 ; j ++ )
				{
					if ( accessories_items [ acc_type ] [ j + 1 ] == 1 )
					{
						acc_number = j ;
						break ;
					}
				}
				SetPVarInt ( playerid, "p_acc_id", acc_number ) ;

				if ( IsValidDynamicPickup ( acs_pickup [ playerid ] ) ) DestroyDynamicPickup ( acs_pickup [ playerid ] ) ;
				acs_pickup [ playerid ] = CreateDynamicPickup ( accessories_items [ acc_type ] [ acc_number ], 23, acs_shop_position [ 0 ], acs_shop_position [ 1 ], acs_shop_position [ 2 ], playerid, GetPlayerInterior ( playerid ), -1 ) ;
				Streamer_Update ( playerid ) ;

				update_clothes ( playerid ) ;
				return 1 ;
			}

			if ( IsValidDynamicPickup ( acs_pickup [ playerid ] ) ) DestroyDynamicPickup ( acs_pickup [ playerid ] ) ;
			acs_pickup [ playerid ] = CreateDynamicPickup ( accessories_items [ acc_type ] [ acc_number - 1 ], 23, acs_shop_position [ 0 ], acs_shop_position [ 1 ], acs_shop_position [ 2 ], playerid, GetPlayerInterior ( playerid ), -1 ) ;
			Streamer_Update ( playerid ) ;
			
			SetPVarInt ( playerid, "p_acc_id", acc_number - 1 ) ;
		}

		update_clothes ( playerid ) ;
	}
	else if ( actionId == 1 ) // right
	{
		if ( player_clothes_select { playerid } == 1 )
		{
			new _gender = p_info [ playerid ] [ gender ], skin_count = GetPVarInt ( playerid, "skin_select_number" ) ;
			if ( _gender == 0 )
			{
				if ( shop_skins [ _gender ] [ skin_count + 1 ] == 0 )
				{
					skin_count = 0 ;
					SetPVarInt ( playerid, "skin_select_number", 0 ) ;
					SetPlayerSkin ( playerid, shop_skins [ _gender ] [ 0 ] ) ;
				
					update_clothes ( playerid ) ;
					return 1 ;
				}
			}
			else if ( _gender == 1 )
			{
				if ( shop_skins [ _gender ] [ skin_count + 1 ] == 0 )
				{
					skin_count = 0 ;
					SetPVarInt ( playerid, "skin_select_number", 0 ) ;
					SetPlayerSkin ( playerid, shop_skins [ _gender ] [ 0 ] ) ;
				
					update_clothes ( playerid ) ;
					return 1 ;
				}
			}

			SetPVarInt ( playerid, "skin_select_number", skin_count + 1 ) ;
			SetPlayerSkin ( playerid, shop_skins [ _gender ] [ skin_count + 1 ] ) ;
		}
		else if ( player_clothes_select { playerid } == 2 )
		{
			new acc_number = GetPVarInt ( playerid, "p_acc_id" ),
				acc_type = GetPVarInt ( playerid, "p_acc_listitem" ) - 1 ;

			if ( accessories_items [ acc_type ] [ acc_number + 1 ] == 1 )
			{
				acc_number = 0 ;
				SetPVarInt ( playerid, "p_acc_id", 0 ) ;
				
				if ( IsValidDynamicPickup ( acs_pickup [ playerid ] ) ) DestroyDynamicPickup ( acs_pickup [ playerid ] ) ;
				acs_pickup [ playerid ] = CreateDynamicPickup ( accessories_items [ acc_type ] [ acc_number ], 23, acs_shop_position [ 0 ], acs_shop_position [ 1 ], acs_shop_position [ 2 ], playerid, GetPlayerInterior ( playerid ), -1 ) ;
				Streamer_Update ( playerid ) ;
				
				update_clothes ( playerid ) ;
				return 1 ;
			}
			if ( IsValidDynamicPickup ( acs_pickup [ playerid ] ) ) DestroyDynamicPickup ( acs_pickup [ playerid ] ) ;
			acs_pickup [ playerid ] = CreateDynamicPickup ( accessories_items [ acc_type ] [ acc_number + 1 ], 23, acs_shop_position [ 0 ], acs_shop_position [ 1 ], acs_shop_position [ 2 ], playerid, GetPlayerInterior ( playerid ), -1 ) ;
			Streamer_Update ( playerid ) ;

			SetPVarInt ( playerid, "p_acc_id", acc_number + 1 ) ;
		}

		update_clothes ( playerid ) ;
	}
	else if ( actionId == 2 ) // buy
	{
		if ( player_clothes_select { playerid } == 1 ) accept_buy_skins ( playerid ) ;
		else if ( player_clothes_select { playerid } == 2 )
		{
			new _d_str [ 107 + 9 ] ;
			format ( _d_str, sizeof _d_str, "{ffffff}Стоимость:\t{"#cBL"}%d"valute_title_"\n\n{"#cGRDialog"}* Вы действительно желаете приобрести данный аксессуар?", accessories_items_price [ GetPVarInt ( playerid, "p_acc_listitem" ) - 1 ] [ GetPVarInt ( playerid, "p_acc_id" ) ] ) ;
			show_dialog ( playerid, d_buy_accessories, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка аксессуаров", _d_str, "Купить", "Назад" ) ;
		}
	}
	else if ( actionId == 3 ) // exit
	{
		if ( player_clothes_select { playerid } == 1 ) close_buy_skins ( playerid ) ;
		else if ( player_clothes_select { playerid } == 2 ) close_buy_accessories ( playerid ) ;
		onServerDestroy ( playerid, UI_CLOTHES_N_ACS ) ;
            
		toggle_controlable ( playerid, true ) ;
	}
	return 1 ;
}

enum _weapon_shop
{
	ws_id,
	ws_name [ 24 ],
	ws_render_type,
	ws_model,
	bool: ws_active
} ;

new weapon_shop [ 5 ] [ _weapon_shop ] =
{
	{ 0, "ПИСТОЛЕТЫ", -1, 9, true },
	{ 1, "АВТОМАТЫ", -1, 10, false },
	{ 2, "ВИНТОВКИ", -1, 11, false },
	{ 3, "ХОЛОДНОЕ\nОРУЖИЕ", -1, 12, false },
	{ 4, "БОЕПРИПАСЫ", -1, 13, false }
} ;

stock show_ammo_packet ( playerid )
{
	#if defined debug_packet
		printf ( "[show_ammo_packet] playerid: %d", playerid ) ;
	#endif

	global_string [ 0 ] = EOS ;
	format ( global_string, 100, "%d", p_info [ playerid ] [ money ] ) ;
	onServerSendData ( playerid, UI_WEAPON_SHOP, 0, global_string ) ;

	new Node: node = JSON_Array ( ) ;
	for ( new i = 0, Node: weaponNode ; i < sizeof weapon_shop ; i ++ )
	{
		weaponNode = JSON_Array (
			JSON_Object (
				"id",         		JSON_Int ( weapon_shop [ i ] [ ws_id ] ),
				"title",  			JSON_String ( weapon_shop [ i ] [ ws_name ] ),
				"isPressed",		JSON_Bool ( weapon_shop [ i ] [ ws_active ] ),
				"type",				JSON_Int ( weapon_shop [ i ] [ ws_render_type ] ),
				"model",			JSON_Int ( weapon_shop [ i ] [ ws_model ] ),
				"color1",  			JSON_Int ( 1 ),
				"color2",      		JSON_Int ( 1 ),
				"rotX",				JSON_Float ( 20.0 ),
				"rotY",				JSON_Float ( 180.0 ),
				"rotZ",				JSON_Float ( 45.0 ),
				"zoom",				JSON_Float ( 0.78 )
			)
		) ;
		node = JSON_Append ( node, weaponNode ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_WEAPON_SHOP, 2, global_string ) ;

	node = JSON_Object ( "position", 0 ) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	show_packet_weapon_shop ( playerid, 1, global_string ) ;
}

stock show_packet_weapon_shop ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 )
	{
		toggle_controlable ( playerid, true ) ;
	}
	else if ( actionId == 1 )
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new _position ;
		JSON_GetInt ( json, "position", _position ) ;

		static const _weapon_size [ ] = { 2, 3, 1, 2, 1 } ;
		static const weapon_grouped [ ] [ ] =
		{
			{ 0, 1 },
			{ 2, 3, 4 },
			{ 5, 6 },
			{ 7, 8 },
			{ 9 }
		} ;
		
		new Node: node = JSON_Array ( ), _id, _price, _b_id = GetPVarInt ( playerid, "p_biz_id" ), itemsLoaded = 0 ;
		for ( new i = 0, Node: weaponNode ; i < _weapon_size [ _position ] ; i ++ )
		{
			_id = weapon_grouped [ _position ] [ i ] ;
			_price = b_price_market [ _b_id - 1 ] [ _id ] ;

			if ( mafia_player ( playerid ) )
			{
				if ( b_info [ _b_id - 1 ] [ b_mafia ] == p_info [ playerid ] [ member ] )
				{
					_price = floatround ( _price / 2 ) ;
				}
			}

			weaponNode = JSON_Array (
				JSON_Object (
					"id",         		JSON_Int ( _id ),
					"categoryId",      	JSON_Int ( _position ),
					"title",  			JSON_String ( b_gun_shop [ _id ] [ bs_name ] ),
					"type",				JSON_Int ( b_gun_shop [ _id ] [ bs_type ] ),
					"model",			JSON_Int ( b_gun_shop [ _id ] [ bs_model ] ),
					"color1",  			JSON_Int ( 1 ),
					"color2",      		JSON_Int ( 1 ),
					"rotX",				JSON_Float ( 20.0 ),
					"rotY",				JSON_Float ( 180.0 ),
					"rotZ",				JSON_Float ( 45.0 ),
					"zoom",				JSON_Float ( 0.78 ),
					"price",			JSON_Int ( _price )
				)
			) ;
			node = JSON_Append ( node, weaponNode ) ;

			if ( ++ itemsLoaded == 5 || i == _weapon_size [ _position ] - 1 )
			{
				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;
				onServerSendData ( playerid, UI_WEAPON_SHOP, 1, global_string ) ;

				node = JSON_Array ( ) ;
				itemsLoaded = 0 ;
			}
		}
	}
	else if ( actionId == 2 )
	{
		new Node: json = JSON_Object(), _id;
		JSON_Parse ( data, json ) ;

		JSON_GetInt ( json, "position", _id ) ;

		new _b_id = GetPVarInt ( playerid, "p_biz_id" ),
			line_string [ 24 ],
			_price = b_price_market [ _b_id - 1 ] [ _id ],
			_maxmoney = floatround ( p_info [ playerid ] [ money ] / _price ),
			_maxitem = floatround ( b_info [ _b_id - 1 ] [ b_product ] / b_gun_shop [ _id ] [ bs_product ] ) ;
					
		if ( mafia_player ( playerid ) )
		{
			if ( b_info [ _b_id - 1 ] [ b_mafia ] == p_info [ playerid ] [ member ] )
			{
				_price = floatround ( _price / 2 ) ;
			}
		}
		if ( b_price_market [ _b_id - 1 ] [ _id ] > get_b_price_market ( _id, _b_id ) ) format ( line_string, sizeof line_string, "{"#cRD"}завышена" ) ;
		else format ( line_string, sizeof line_string, "{"#cOR"}рыночная" ) ;
			
		global_string [ 0 ] = EOS ;
		format ( global_string, 512, "\
		{"#cWH"}Предмет: {"#cOR"}%s\n\
		{"#cWH"}Стоимость: {"#cGN"}%s"valute_title_" за 1 шт.\n\
		{"#cWH"}В наличии: {"#cGN"}%d шт.\n\
		{"#cWH"}Цена %s\n\n\
		{"#cGRDialog"}* Введите какое количество Вы хотите купить:\n\
		{"#cGRDialog"}* Ваших денег хватает на %d ед. товара.", 
		b_gun_shop [ _id ] [ bs_name ], GetPlayerCashValueToSmile ( _price ),
		_maxitem, line_string,
		( _maxmoney > _maxitem ) ? ( _maxitem ) : ( _maxmoney ) ) ;
				
		show_dialog ( playerid, d_ammo_shop, DIALOG_STYLE_INPUT, "{"#cBHD"}Покупка предмета", global_string, "Купить", "Отмена" ) ;
			
		set_player_use_listitem ( playerid, _id ) ;
	}
	return 1 ;
}

stock show_packet_product ( playerid )
{
	#if defined debug_packet
		printf ( "[show_packet_product] playerid: %d", playerid ) ;
	#endif

	global_string [ 0 ] = EOS ;
	format ( global_string, 100, "%d", p_info [ playerid ] [ money ] ) ;
	onServerSendData ( playerid, UI_PRODUCT_STORE, 0, global_string ) ;

	new Node: node = JSON_Array ( ), _b_id = GetPVarInt ( playerid, "p_biz_id" ), 
		price, itemsLoaded = 0, _maxmoney, _maxitem, line_string [ 24 ] ;
	for ( new i = 0, Node: productNode ; i < MAX_ITEM_IN_SHOP ; i ++ )
	{
		price = b_price_market [ _b_id - 1 ] [ i ] ;
				
		if ( b_info [ _b_id - 1 ] [ b_mafia ] == p_info [ playerid ] [ member ] )
		{
		    price = floatround ( b_price_market [ _b_id - 1 ] [ i ] / 50 ) ;
		}

		_maxmoney = floatround ( p_info [ playerid ] [ money ] / price ) ;
		_maxitem = floatround ( b_info [ _b_id - 1 ] [ b_product ] / b_shop [ i ] [ bs_product ] ) ;

		if ( b_price_market [ _b_id - 1 ] [ i ] > get_b_price_market ( i, _b_id ) ) format ( line_string, sizeof line_string, "завышена" ) ;
		else format ( line_string, sizeof line_string, "рыночная" ) ;

		global_string [ 0 ] = EOS ;
		format ( global_string, 512, "\
		Предмет: %s\n\
		Стоимость: %s"valute_title_" за 1 шт.\n\
		В наличии: %d шт.\n\
		Цена %s\n\n\
		* Ваших денег хватает на %d ед. товара.", 
		b_shop [ i ] [ bs_name ], GetPlayerCashValueToSmile ( price ),
		_maxitem, line_string,
		( _maxmoney > _maxitem ) ? ( _maxitem ) : ( _maxmoney ) ) ;

		productNode = JSON_Array (
			JSON_Object (
				"id",         			JSON_Int ( i ),
				"productName", 			JSON_String ( b_shop [ i ] [ bs_name ] ),
				"productDescription",	JSON_String ( global_string ),
				"productPrice",			JSON_Int ( price ),
				"type",					JSON_Int ( b_shop [ i ] [ bs_type ] ),
				"model",				JSON_Int ( b_shop [ i ] [ bs_model ] ),
				"color1",  				JSON_Int ( 1 ),
				"color2",      			JSON_Int ( 1 ),
				"rotX",					JSON_Float ( 20.0 ),
				"rotY",					JSON_Float ( 180.0 ),
				"rotZ",					JSON_Float ( 45.0 ),
				"zoom",					JSON_Float ( 0.78 ),
				"isAmountVisible",		JSON_Bool ( b_shop [ i ] [ is_amount ] )
			)
		) ;
		node = JSON_Append ( node, productNode ) ;

		if ( ++ itemsLoaded == 5 || i == MAX_ITEM_IN_SHOP - 1 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_PRODUCT_STORE, 1, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
	}

	used_shop_product [ playerid ] = true ;
}

stock show_packet_product_store ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 )
	{
		used_shop_product [ playerid ] = false ;
		toggle_controlable ( playerid, true ) ;
	}
	else if ( actionId == 1 )
	{
		new Node: json = JSON_Object(), _id, _value;
		JSON_Parse ( data, json ) ;

		JSON_GetInt ( json, "productId", _id ) ;
		JSON_GetInt ( json, "productCount", _value ) ;

		set_player_use_listitem ( playerid, _value ) ;

		p_t_info [ playerid ] [ p_dialog ] = d_shop ;
		OnDialogResponse ( playerid, d_shop, 1, _id, "" ) ;
	}
	return 1 ;
}