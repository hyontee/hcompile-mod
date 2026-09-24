#define MAX_TIRE_REPAIR_ELEMENTS		6
#define MAX_TIRE_REPAIR_DISK_ELEMENTS	18

enum E_TIRE_REPAIR_CENTER_STRUCT
{
    TRCI_NAME [ 32 ],
    TRCI_TYPE,
    TRCI_PRICE
} ;

new g_tire_repair_center_info [ MAX_TIRE_REPAIR_ELEMENTS ] [ E_TIRE_REPAIR_CENTER_STRUCT ] =
{
    { "Высоту подвески",     TIRE_CENTER_SUSPENSION_HEIGHT,             120_000 },  
    { "Диаметр колёс",       TIRE_CENTER_WHEEL_DIAMETER,                200_000 },  
    { "Ширину колёс",        TIRE_CENTER_WHEEL_WIDTH,                   130_000 },  
    { "Передний развал",     TIRE_CENTER_WHEEL_ALIGN_FRONT,             65_000 },  
    { "Задний развал",       TIRE_CENTER_WHEEL_ALIGN_BACK,              65_000 },  
    { "Проставки",           TIRE_CENTER_SPACERS,                       175_000 }   
} ;

enum E_TIRE_REPAIR_CENTER_D_STRUCT
{
    TRCD_ID,
    TRCD_PRICE
} ;

new g_tire_repair_center_disk [ MAX_TIRE_REPAIR_DISK_ELEMENTS ] [ E_TIRE_REPAIR_CENTER_D_STRUCT ] =
{
    { 0,         0 },
    { 1097,      120_000 },
    { 1025,      150_000 },
    { 1074,      180_000 },
    { 1079,      210_000 },
    { 1096,      240_000 },
    { 1085,      270_000 },
    { 1075,      300_000 },
    { 1080,      330_000 },
    { 1073,      360_000 },
    { 1082,      500_000 },
    { 1083,      500_000 },
    { 1077,      500_000 },
    { 1076,      500_000 },
    { 1081,      500_000 },
    { 1098,      500_000 },
    { 1078,      500_000 },
    { 1084,      500_000 }
} ;

stock show_window_tireshop ( playerid )
{
	#if defined debug_packet
		printf ( "[show_window_tireshop] playerid: %d", playerid ) ;
	#endif

	SetPlayerCameraPos ( playerid, tuning_camera_positions [ 3 ] [ 0 ], tuning_camera_positions [ 3 ] [ 1 ], tuning_camera_positions [ 3 ] [ 2 ] ) ;
	SetPlayerCameraLookAt ( playerid, tuning_camera_positions [ 3 ] [ 3 ], tuning_camera_positions [ 3 ] [ 4 ], tuning_camera_positions [ 3 ] [ 5 ] ) ;
	
	new _v_id = GetPlayerVehicleID ( playerid ) ;

	global_string [ 0 ] = EOS ;
    format ( global_string, 48, "%d", p_info [ playerid ] [ money ] ) ;
	onServerSendData ( playerid, UI_TIRE_SHOP, 0, global_string ) ;

	new Node: node = JSON_Array ( ) ;
	for ( new idx = 0, Node: servicePrice ; idx < MAX_TIRE_REPAIR_ELEMENTS ; idx ++ )
    {
		servicePrice = JSON_Array (
			JSON_Object (
				"type",				JSON_Int ( g_tire_repair_center_info [ idx ] [ TRCI_TYPE ] ),
				"price",			JSON_Int ( g_tire_repair_center_info [ idx ] [ TRCI_PRICE ] )
			)
		) ;

		node = JSON_Append ( node, servicePrice ) ;
    }

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TIRE_SHOP, 1, global_string ) ;

	new disk_name [ 15 ] ;
	node = JSON_Array ( ) ;
	for ( new idx = 0, count = 0, Node: tirePrice, itemsLoaded = 0 ; idx < MAX_TIRE_REPAIR_DISK_ELEMENTS ; idx ++ ) 
	{
		count ++ ;
		if ( veh_info [ _v_id - 1 ] [ v_disk_id ] )
		{
			format ( disk_name, sizeof disk_name, "Диск #%d", count ) ;
		}
		else disk_name = "Default" ;

		tirePrice = JSON_Array (
			JSON_Object (
				"diskId",			JSON_Int ( g_tire_repair_center_disk [ idx ] [ TRCD_ID ] ),
				"diskName",			JSON_String ( disk_name ),
				"diskPrice",		JSON_Int ( g_tire_repair_center_disk [ idx ] [ TRCD_PRICE ] ),
				"diskModel",		JSON_Int ( g_tire_repair_center_disk [ idx ] [ TRCD_ID ] ),
				"diskColor1",		JSON_Int ( 0 ),
				"diskColor2",		JSON_Int ( 0 ),
				"diskRotX",			JSON_Float ( 20.0 ),
				"diskRotY",			JSON_Float ( 180.0 ),
				"diskRotZ",			JSON_Float ( 45.0 ),
				"diskZoom",			JSON_Float ( 0.78 ),
				"isInstalled",		JSON_Int ( veh_info [ _v_id - 1 ] [ v_disk_id ] == g_tire_repair_center_disk [ idx ] [ TRCD_ID ] ? 1 : 0 )
			)
		) ;

		node = JSON_Append ( node, tirePrice ) ;

		if ( ++ itemsLoaded == 5 || idx == MAX_TIRE_REPAIR_DISK_ELEMENTS - 1 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TIRE_SHOP, 2, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
	}

	new engine, lights, alarm, doors, bonnet, boot, objective ;
	GetVehicleParamsEx ( _v_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( _v_id, VEHICLE_PARAMS_ON, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective ) ;

	toggle_controlable ( playerid, false ) ;
}

stock show_packet_tireshop ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 ) // exit
	{
		if ( GetPVarInt ( playerid, "p_biz_id" ) )
		{
		    new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		    DeletePVar ( playerid, "p_biz_id" ) ;
		    exit_tuning ( playerid, _b_id ) ;
		}
		
		toggle_controlable ( playerid, true ) ;
		SetCameraBehindPlayer ( playerid ) ;
	}
	else if ( actionId == 1 ) // buy other
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new _type, _value, _v_id = GetPlayerVehicleID ( playerid ) ;
		JSON_GetInt ( json, "type", _type ) ;
		JSON_GetInt ( json, "value", _value ) ;

        new handling_id = -1 ;
        switch ( _type )
        {
        	case TIRE_CENTER_SUSPENSION_HEIGHT: handling_id = veh_info [ _v_id - 1 ] [ V_HP_SUS_LOWER_LIMIT ] ;
         	case TIRE_CENTER_WHEEL_DIAMETER: handling_id = veh_info [ _v_id - 1 ] [ V_HP_WHEEL_SIZE ] ;
           	case TIRE_CENTER_WHEEL_WIDTH: handling_id = veh_info [ _v_id - 1 ] [ V_HP_WHEEL_WIDTH ] ;
           	case TIRE_CENTER_WHEEL_ALIGN_FRONT: handling_id = veh_info [ _v_id - 1 ] [ V_HP_WHEEL_ALIGN_FRONT ] ;
          	case TIRE_CENTER_WHEEL_ALIGN_BACK: handling_id = veh_info [ _v_id - 1 ] [ V_HP_WHEEL_ALIGN_BACK ] ;
           	case TIRE_CENTER_SPACERS: handling_id = veh_info [ _v_id - 1 ] [ V_HP_SPACERS ] ;
     	}

     	if ( handling_id == _value )
		{
			send_check_cinfo ( playerid, "На данном Т/С уже установлен выбранный параметр с таким значением.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

     	new idx = GetTireRepairCenterIndex ( _type ),
			servicePrice = g_tire_repair_center_info [ idx ] [ TRCI_PRICE ] ;

		global_string [ 0 ] = EOS ;
        format ( global_string, 144, "{FFFFFF}Вы действительно хотите изменить {"#cOR"}\"%s\" {FFFFFF}за {"#cTN"}%d "valute_title_"{FFFFFF}?", g_tire_repair_center_info [ idx ] [ TRCI_NAME ], servicePrice ) ;
        show_dialog ( playerid, d_tire_repair_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Изменения", global_string, "Да", "Отмена" ) ;

        SetPVarInt ( playerid, "TIRE_CENTER_type", _type ) ;
      	SetPVarInt ( playerid, "TIRE_CENTER_value", _value ) ;
	}
	else if ( actionId == 2 ) // buy disk
	{
		new diskId = strval ( data ), _price = 0, _v_id = GetPlayerVehicleID ( playerid ) ;
		if ( veh_info [ _v_id - 1 ] [ v_disk_id ] == diskId )
		{
			send_check_cinfo ( playerid, "Данные диски уже установлены на Ваше Т/С.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

        if ( diskId != 0 )
        {
            new idx = GetTireRepairCenterDiskIndex ( diskId ) ;
            _price = g_tire_repair_center_disk [ idx ] [ TRCD_PRICE ] ;
        }

		global_string [ 0 ] = EOS ;
        format ( global_string, 144, "{FFFFFF}Вы действительно хотите купить эти диски {FFFFFF}за {"#cTN"}%d "valute_title_"{FFFFFF}?", _price ) ;
        show_dialog ( playerid, d_tire_repair_buy_disk, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка дисков", global_string, "Да", "Отмена" ) ;

        SetPVarInt ( playerid, "TIRE_CENTER_disk_id", diskId ) ;
	}
	return 1 ;
}

stock tire_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_tire_repair_buy_element:
		{
			if ( ! response ) return true ;

			new _v_id = GetPlayerVehicleID ( playerid ) ;

            new type_id = GetPVarInt ( playerid, "TIRE_CENTER_type" ),
            	value = GetPVarInt ( playerid, "TIRE_CENTER_value" ) ;

            DeletePVar ( playerid, "TIRE_CENTER_type" ) ;
            DeletePVar ( playerid, "TIRE_CENTER_value" ) ;

            new idx = GetTireRepairCenterIndex ( type_id ),
            	price = g_tire_repair_center_info [ idx ] [ TRCI_PRICE ] ;

            if ( p_info [ playerid ] [ money ] < price )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно средств.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			give_money ( playerid, -price ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Услуги шиномонтажки" ) ;

            switch ( type_id )
            {
                case TIRE_CENTER_SUSPENSION_HEIGHT: veh_info [ _v_id - 1 ] [ V_HP_SUS_LOWER_LIMIT ] = value ;
                case TIRE_CENTER_WHEEL_DIAMETER: veh_info [ _v_id - 1 ] [ V_HP_WHEEL_SIZE ] = value ;
                case TIRE_CENTER_WHEEL_WIDTH: veh_info [ _v_id - 1 ] [ V_HP_WHEEL_WIDTH ] = value ;
                case TIRE_CENTER_WHEEL_ALIGN_FRONT: veh_info [ _v_id - 1 ] [ V_HP_WHEEL_ALIGN_FRONT ] = value ;
                case TIRE_CENTER_WHEEL_ALIGN_BACK: veh_info [ _v_id - 1 ] [ V_HP_WHEEL_ALIGN_BACK ] = value ;
                case TIRE_CENTER_SPACERS: veh_info [ _v_id - 1 ] [ V_HP_SPACERS ] = value ;
            }

			if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_player ) SaveVehicleHandling ( _v_id, "users_vehicles_handling" ) ;
			else if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_family ) SaveVehicleHandling ( _v_id, "familys_vehicles_handling" ) ;
			give_bmoney ( GetPVarInt ( playerid, "p_biz_id " ), price, 0 ) ;

			sc_OnVehicleStreamIn ( _v_id, playerid ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 48, "%d", p_info [ playerid ] [ money ] ) ;
			onServerSendData ( playerid, UI_TIRE_SHOP, 0, global_string ) ;

			new Node: node = JSON_Object (
				"type",			JSON_Int ( type_id ),
				"value",		JSON_Int ( value )
			) ;
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TIRE_SHOP, 3, global_string ) ;
			return true ;
		}
		case d_tire_repair_buy_disk:
		{
			if ( ! response ) return true ;

			new _v_id = GetPlayerVehicleID ( playerid ),
				disk_id = GetPVarInt ( playerid, "TIRE_CENTER_disk_id" ),
				price = 0 ;

            DeletePVar ( playerid, "TIRE_CENTER_disk_id" ) ;

            if ( disk_id != 0 )
            {
                new idx = GetTireRepairCenterDiskIndex ( disk_id ) ;
                price = g_tire_repair_center_disk [ idx ] [ TRCD_PRICE ] ;

				if ( p_info [ playerid ] [ money ] < price )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно средств.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				give_money ( playerid, -price ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Установка дисков" ) ;

				give_bmoney ( GetPVarInt ( playerid, "p_biz_id " ), price, 0 ) ;
            }

			global_string [ 0 ] = EOS ;
			format ( global_string, 48, "%d", p_info [ playerid ] [ money ] ) ;
			onServerSendData ( playerid, UI_TIRE_SHOP, 0, global_string ) ;

            new old_disk_id = veh_info [ _v_id - 1 ] [ v_disk_id ] ;
            veh_info [ _v_id - 1 ] [ v_disk_id ] = disk_id ;

			if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_player ) SaveTuningToOwnableCar ( _v_id, "users_vehicles_tuning" ) ;
			else if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_family ) SaveTuningToOwnableCar ( _v_id, "familys_vehicles_tuning" ) ;
			
            if ( ! price )
            {
                RemoveVehicleComponent ( _v_id, old_disk_id ) ;
            }
			else
			{
				AddVehicleComponent ( _v_id, disk_id ) ;
			}

			global_string [ 0 ] = EOS ;
			format ( global_string, sizeof global_string, "%d", disk_id ) ;
            onServerSendData ( playerid, UI_TIRE_SHOP, 4, global_string ) ;
			return true ;
		}
	}
	return false ;
}

stock GetTireRepairCenterIndex ( type_id )
{
    new index = -1 ;
    for ( new idx = 0 ; idx < MAX_TIRE_REPAIR_ELEMENTS ; idx ++ ) 
    {    
        if ( g_tire_repair_center_info [ idx ] [ TRCI_TYPE ] != type_id ) continue ;

        index = idx ;
        break ;
    }

    return index ;
}

stock GetTireRepairCenterDiskIndex ( disk_id )
{
    new index = -1 ;
    for ( new idx = 0 ; idx < MAX_TIRE_REPAIR_DISK_ELEMENTS ; idx ++ ) 
    {    
        if ( g_tire_repair_center_disk [ idx ] [ TRCD_ID ] != disk_id ) continue ;

        index = idx ;
        break ;
    }

    return index ;
}
