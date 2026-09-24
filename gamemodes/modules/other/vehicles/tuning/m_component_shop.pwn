
enum E_COMPONENT_SHOP_DETAIL_STRUCT
{
	CSDS_NAME [ 32 ],
	CSDS_PRICE
} ;
new COMPONENT_SHOP_DETAIL [ CAR_COMPONENT_MAX ] [ E_COMPONENT_SHOP_DETAIL_STRUCT ] =
{
	{ "Default", 0 },
	{ "Деталь №1", 100 },
	{ "Деталь №2", 100 },
	{ "Деталь №3", 100 },
	{ "Деталь №4", 100 },
	{ "Деталь №5", 100 },
	{ "Деталь №6", 100 },
	{ "Деталь №7", 100 },
	{ "Деталь №8", 100 },
	{ "Деталь №9", 100 },
	{ "Деталь №10", 100 },
	{ "Деталь №11", 100 },
	{ "Деталь №12", 100 },
	{ "Деталь №13", 100 },
	{ "Деталь №14", 100 },
	{ "Деталь №15", 100 },
	{ "Деталь №16", 100 },
	{ "Деталь №17", 100 }
} ;

stock showComponentShop ( playerid )
{
 	global_string [ 0 ] = EOS ;
	format ( global_string, 48, "%d", p_info [ playerid ] [ money ] ) ;
	onServerSendData ( playerid, UI_COMPONENT_SHOP, 0, global_string ) ;

	new Node: node = JSON_Array ( ),
		Node: nodeMenu = JSON_Array ( ),
		vehicleId = GetPlayerVehicleID ( playerid ),
		modelId = getVehicleOrdinalNumber ( vehicleId ),
		dummyCount ;
	for ( new ccId = 0, Node: nodeMenuItem ; ccId < CAR_COMPONENT_EXTRA ; ccId ++ )
	{
		dummyCount = GetVehicleDataDummy ( modelId, ccId ) ;
		for ( new dummy = 0, Node: dummyNode ; dummy < dummyCount ; dummy ++ )
		{
			dummyNode = JSON_Array (
				JSON_Object (
					"type",			JSON_Int ( ccId ),
					"name",			JSON_String ( COMPONENT_SHOP_DETAIL [ dummy ] [ CSDS_NAME ] ),
					"installed",	JSON_Int ( veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ ccId ] == ( dummy ) ? 1 : 0 ),
					"price",		JSON_Int ( COMPONENT_SHOP_DETAIL [ dummy ] [ CSDS_PRICE ] )
				)
			) ;
			node = JSON_Append ( node, dummyNode ) ;
		}

		if ( dummyCount )
		{
			nodeMenuItem = JSON_Array (
				JSON_Int ( ccId )
			) ;
			nodeMenu = JSON_Append ( nodeMenu, nodeMenuItem ) ;

			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_COMPONENT_SHOP, 3, global_string ) ;

			node = JSON_Array ( ) ;
		}
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( nodeMenu, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_COMPONENT_SHOP, 1, global_string ) ;

	SetPlayerCameraPos ( playerid, component_shop_camera [ CAR_COMPONENT_BUMPER_FRONT ] [ 0 ], component_shop_camera [ CAR_COMPONENT_BUMPER_FRONT ] [ 1 ], component_shop_camera [ CAR_COMPONENT_BUMPER_FRONT ] [ 2 ] ) ;
	SetPlayerCameraLookAt ( playerid, component_shop_camera [ CAR_COMPONENT_BUMPER_FRONT ] [ 3 ], component_shop_camera [ CAR_COMPONENT_BUMPER_FRONT ] [ 4 ], component_shop_camera [ CAR_COMPONENT_BUMPER_FRONT ] [ 5 ] ) ;

	new engine, lights, alarm, doors, bonnet, boot, objective ;
	GetVehicleParamsEx ( vehicleId, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( vehicleId, VEHICLE_PARAMS_ON, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective ) ;

	toggle_controlable ( playerid, false ) ;
}

stock packetComponentShop ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 )
	{
		setCarComponent ( GetPlayerVehicleID ( playerid ), playerid ) ;

		new idx = strval ( data ) ;
		SetPlayerCameraPos ( playerid, component_shop_camera [ idx ] [ 0 ], component_shop_camera [ idx ] [ 1 ], component_shop_camera [ idx ] [ 2 ] ) ;
		SetPlayerCameraLookAt ( playerid, component_shop_camera [ idx ] [ 3 ], component_shop_camera [ idx ] [ 4 ], component_shop_camera [ idx ] [ 5 ], 1 ) ;
	}
	else if ( actionId == 1 )
	{
		new Node: node, componentType, idx, vehicleId = GetPlayerVehicleID ( playerid ), _price = 0 ;
        JSON_Parse ( data, node ) ;

        JSON_GetInt ( node, "type", componentType ) ;
        JSON_GetInt ( node, "position", idx ) ;

		if ( veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ componentType ] == idx )
		{
			send_check_cinfo ( playerid, "У Вас уже есть эта деталь.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		_price = COMPONENT_SHOP_DETAIL [ idx ] [ CSDS_PRICE ] ;
		if ( _price > 0 )
		{
			if ( p_info [ playerid ] [ money ] < _price )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно денег для покупки данной детали.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			global_string [ 0 ] = EOS ;
			format ( global_string, 144, "{FFFFFF}Вы действительно хотите купить {"#cOR"}\"%s\" {"#cWH"}за {"#cTN"}%d "valute_title_"{"#cWH"}?", COMPONENT_SHOP_DETAIL [ idx ] [ CSDS_NAME ], _price ) ;
			show_dialog ( playerid, d_component_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Детейлинг-центр", global_string, "Да", "Отмена" ) ;
		}
		else
		{
			show_dialog ( playerid, d_component_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Детейлинг-центр", "{"#cWH"}Вы действительно хотите убрать деталь с личного Т/С?", "Да", "Отмена" ) ;
		}
		set_listitem_info ( playerid, 0, componentType ) ;
		set_listitem_info ( playerid, 1, idx ) ;
	}
	return true ;
}

stock component_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_component_buy_element:
		{
			if ( ! response ) return true ;

			new componentType = get_listitem_info ( playerid, 0 ),
				idx = get_listitem_info ( playerid, 1 ),
				vehicleId = GetPlayerVehicleID ( playerid ),
				_price = COMPONENT_SHOP_DETAIL [ idx ] [ CSDS_PRICE ] ;

			if ( p_info [ playerid ] [ money ] < _price )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно денег для покупки данной детали.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return true ;
			}

			if ( _price > 0 )
			{
				give_money ( playerid, -_price ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, -_price, "Покупка детали" ) ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 48, "%d", p_info [ playerid ] [ money ] ) ;
				onServerSendData ( playerid, UI_COMPONENT_SHOP, 0, global_string ) ;
			}

			veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ componentType ] = idx ;

			if ( veh_info [ vehicleId - 1 ] [ v_type ] == vehicle_type_player ) SaveComponentToOwnableCar ( vehicleId, "users_vehicles_component" ) ;
			else if ( veh_info [ vehicleId - 1 ] [ v_type ] == vehicle_type_family ) SaveComponentToOwnableCar ( vehicleId, "familys_vehicles_component" ) ;

			new Node: node = JSON_Object (
				"type",		JSON_Int ( componentType ),
				"id",		JSON_Int ( idx )
			) ;
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_COMPONENT_SHOP, 2, global_string ) ;

			setCarComponent ( vehicleId, playerid ) ;
			return true ;
		}
	}
	return false ;
}

stock packetComponentShopDestroy ( playerid )
{
	if ( GetPVarInt ( playerid, "p_biz_id" ) )
	{
	    new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
	    DeletePVar ( playerid, "p_biz_id" ) ;
	    exit_tuning ( playerid, _b_id ) ;
	}
	
	toggle_controlable ( playerid, true ) ;
	SetCameraBehindPlayer ( playerid ) ;
	setCarComponent ( GetPlayerVehicleID ( playerid ), playerid ) ;
	return true ;
}