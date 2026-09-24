#define MAX_TUNING_NEONS     			5
#define MAX_TUNING_STROBE_LIGHTS     	4
#define MAX_TUNING_NITRO     			3
#define MAX_TUNING_COLORS_PARAMS    	5
#define MAX_TUNING_VYNIL    			18

enum E_TUNING_CENTER_N_STRUCT
{
    TCN_NAME [ 45 ],
    TCN_PRICE
} ;

new g_tuning_center_neon [ MAX_TUNING_NEONS ] [ E_TUNING_CENTER_N_STRUCT ] =
{
    { "Нет неона",       0 },
    { "Статичный",       100_000 },
    { "Переливающийся",  150_000 },
    { "Моргающий",       200_000 },
    { "Резкий",          250_000 }
} ;

enum E_TUNING_CENTER_SL_STRUCT
{
    TCSL_NAME [ 50 ],
    TCSL_PRICE
} ;

new g_tuning_center_strobe_light [ MAX_TUNING_STROBE_LIGHTS ] [ E_TUNING_CENTER_SL_STRUCT ] =
{
    { "Нет стробоскопа",  0 },
    { "Режим 2",          150_000 },
    { "Режим 3",          150_000 },
    { "Режим 4",          150_000 }
} ;

enum E_TUNING_CENTER_NITRO_STRUCT
{
    TC_NITRO_ID,
    TC_NITRO_NAME [ 45 ],
    TC_NITRO_PRICE
} ;

new g_tuning_center_nitro [ MAX_TUNING_NITRO ] [ E_TUNING_CENTER_NITRO_STRUCT ] =
{
    { 0,     "Нет нитро",            0 },
    { 1009,  "Уровень нитро 1",      150_000 },
    { 1008,  "Уровень нитро 2",      250_000 }
    //{ 1010,  "Уровень нитро 3",      350_000 }
} ;

enum E_TUNING_COLORS_INFO_STRUCT
{
    TCI_TYPE,
    TCI_PRICE
} ;

new g_tuning_colors_info [ MAX_TUNING_COLORS_PARAMS ] [ E_TUNING_COLORS_INFO_STRUCT ] =
{
    { TUNING_CENTER_NEON_COLOR,          55_000 },
    { TUNING_CENTER_LIGHT_COLOR,         90_000 },
    { TUNING_CENTER_TINTING_COLOR,       80_000 },
    { TUNING_CENTER_BODY_PAINT_COLOR,    60_000 },
    { TUNING_CENTER_DISK_COLOR,          50_000 }
} ;

enum E_TUNING_CENTER_VINYL
{
    VNL_NAME [ 45 ],
    VNL_PRICE
} ;

new g_tuning_center_vinyl [ MAX_TUNING_VYNIL ] [ E_TUNING_CENTER_VINYL ] =
{
    { "Нет винила",       	0 },
    { "Винил #1",       	100_000 },
    { "Винил #2",  			150_000 },
    { "Винил #3",       	200_000 },
    { "Винил #4",          	250_000 },
    { "Винил #5",          	250_000 },
    { "Винил #6",          	250_000 },
    { "Винил #7",          	250_000 },
    { "Винил #8",          	250_000 },
    { "Винил #9",          	250_000 },
    { "Винил #10",          250_000 },
    { "Винил #11",          250_000 },
    { "Винил #12",          250_000 },
    { "Винил #13",          250_000 },
    { "Винил #14",          250_000 },
    { "Винил #15",          250_000 },
    { "Винил #16",          250_000 },
    { "Винил #17",          250_000 }
} ;

stock show_window_tuning ( playerid )
{
	#if defined debug_packet
		printf ( "[show_window_tuning] playerid: %d", playerid ) ;
	#endif

	SetPlayerCameraPos ( playerid, tuning_camera_positions [ 3 ] [ 0 ], tuning_camera_positions [ 3 ] [ 1 ], tuning_camera_positions [ 3 ] [ 2 ] ) ;
	SetPlayerCameraLookAt ( playerid, tuning_camera_positions [ 3 ] [ 3 ], tuning_camera_positions [ 3 ] [ 4 ], tuning_camera_positions [ 3 ] [ 5 ] ) ;

	new _v_id = GetPlayerVehicleID ( playerid ) ;

	global_string [ 0 ] = EOS ;
    format ( global_string, 48, "%d", p_info [ playerid ] [ money ] ) ;
	onServerSendData ( playerid, UI_TUNING, 0, global_string ) ;

	new Node: node = JSON_Array ( ) ;
	for ( new idx = 0, Node: servicePrice ; idx < MAX_TUNING_NEONS ; idx ++ )
    {
		servicePrice = JSON_Array (
			JSON_Object (
				"type",				JSON_Int ( idx ),
				"name",				JSON_String ( g_tuning_center_neon [ idx ] [ TCN_NAME ] ),
				"installed",		JSON_Int ( veh_info [ _v_id - 1 ] [ v_neon_type ] == idx ? 1 : 0 ),
				"price",			JSON_Int ( g_tuning_center_neon [ idx ] [ TCN_PRICE ] )
			)
		) ;

		node = JSON_Append ( node, servicePrice ) ;
    }

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TUNING, 1, global_string ) ;

	node = JSON_Array ( ) ;
	for ( new idx = 0, Node: servicePrice ; idx < MAX_TUNING_STROBE_LIGHTS ; idx ++ )
    {
		servicePrice = JSON_Array (
			JSON_Object (
				"type",				JSON_Int ( idx ),
				"name",				JSON_String ( g_tuning_center_strobe_light [ idx ] [ TCSL_NAME ] ),
				"installed",		JSON_Int ( veh_info [ _v_id - 1 ] [ v_pantera_strobs ] == idx ? 1 : 0 ),
				"price",			JSON_Int ( g_tuning_center_strobe_light [ idx ] [ TCSL_PRICE ] )
			)
		) ;

		node = JSON_Append ( node, servicePrice ) ;
    }

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TUNING, 2, global_string ) ;

	node = JSON_Array ( ) ;
	for ( new idx = 0, Node: servicePrice ; idx < MAX_TUNING_NITRO ; idx ++ )
    {
		servicePrice = JSON_Array (
			JSON_Object (
				"type",				JSON_Int ( idx ),
				"name",				JSON_String ( g_tuning_center_nitro [ idx ] [ TC_NITRO_NAME ] ),
				"installed",		JSON_Int ( 0 ),
				"price",			JSON_Int ( g_tuning_center_nitro [ idx ] [ TC_NITRO_PRICE ] )
			)
		) ;

		node = JSON_Append ( node, servicePrice ) ;
    }

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TUNING, 3, global_string ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, sizeof global_string, "%d", veh_info [ _v_id - 1 ] [ v_disk_id ] ) ;
	onServerSendData ( playerid, UI_TUNING, 4, global_string ) ;

	node = JSON_Array ( ) ;
	for ( new idx = 0, Node: servicePrice ; idx < MAX_TUNING_COLORS_PARAMS ; idx ++ ) 
    {    
		servicePrice = JSON_Array (
			JSON_Object (
				"type",				JSON_Int ( g_tuning_colors_info [ idx ] [ TCI_TYPE ] ),
				"value",			JSON_Int ( g_tuning_colors_info [ idx ] [ TCI_PRICE ] )
			)
		) ;

		node = JSON_Append ( node, servicePrice ) ;
    }

    global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TUNING, 6, global_string ) ;

    new rgba ;
    if ( veh_info [ _v_id - 1 ] [ v_neon_type ] == NEON_TYPE_NONE )
        rgba = RGBA ( 255, 255, 255, 255 ) ;

    else
        rgba = RGBA ( veh_info [ _v_id - 1 ] [ v_neon ] [ 0 ], veh_info [ _v_id - 1 ] [ v_neon ] [ 1 ], veh_info [ _v_id - 1 ] [ v_neon ] [ 2 ], 255 ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, sizeof global_string, "%d", rgba ) ;
	onServerSendData ( playerid, UI_TUNING, 7, global_string ) ;

	node = JSON_Array ( ) ;
	for ( new idx = 0, Node: servicePrice, itemsLoaded = 0 ; idx < MAX_TUNING_VYNIL ; idx ++ ) 
    {    
		servicePrice = JSON_Array (
			JSON_Object (
				"type",				JSON_Int ( idx ),
				"name",				JSON_String ( g_tuning_center_vinyl [ idx ] [ VNL_NAME ] ),
				"installed",		JSON_Int ( veh_info [ _v_id - 1 ] [ v_vinyl ] == idx ),
				"price",			JSON_Int ( g_tuning_center_vinyl [ idx ] [ VNL_PRICE ] )
			)
		) ;

		node = JSON_Append ( node, servicePrice ) ;

		if ( ++ itemsLoaded == 5 || idx == MAX_TUNING_VYNIL - 1 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TUNING, 8, global_string ) ;

			node = JSON_Array ( ) ;
			itemsLoaded = 0 ;
		}
    }

	new engine, lights, alarm, doors, bonnet, boot, objective ;
	GetVehicleParamsEx ( _v_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( _v_id, VEHICLE_PARAMS_ON, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective ) ;

	toggle_controlable ( playerid, false ) ;
}

stock show_packet_tuning ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 )
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
	else if ( actionId == 1 )
	{
		new Node: node, _typeId, _value, _price = 0, _v_id = GetPlayerVehicleID ( playerid ) ;
        JSON_Parse ( data, node ) ;

        JSON_GetInt ( node, "type", _typeId ) ;
        JSON_GetInt ( node, "value", _value ) ;

        switch ( _typeId )
      	{
        	case TUNING_CENTER_NEON_TYPE:
         	{
				if ( _value > MAX_TUNING_NEONS ) return 1 ;

				if ( veh_info [ _v_id - 1 ] [ v_neon_type ] == _value )
				{
					send_check_cinfo ( playerid, "У Вас уже есть неон данного типа.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				_price = g_tuning_center_neon [ _value ] [ TCN_PRICE ] ;
              	if ( _price > 0 )
              	{
                	if ( p_info [ playerid ] [ money ] < _price )
					{
						send_check_cinfo ( playerid, "У Вас недостаточно денег для покупки неона данного типа.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}

					global_string [ 0 ] = EOS ;
                    format ( global_string, 144, "{FFFFFF}Вы действительно хотите купить {"#cOR"}\"%s неон\" {"#cWH"}за {"#cTN"}%d "valute_title_"{"#cWH"}?", g_tuning_center_neon [ _value ] [ TCN_NAME ], _price ) ;
                    show_dialog ( playerid, d_tune_center_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тюнинг-центр", global_string, "Да", "Отмена" ) ;
                }
                else 
            	{
                	show_dialog ( playerid, d_tune_center_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тюнинг-центр", "{"#cWH"}Вы действительно хотите убрать неон с личного Т/С?", "Да", "Отмена" ) ;
             	}
         	}
          	case TUNING_CENTER_NEON_COLOR:
          	{
				if ( veh_info [ _v_id - 1 ] [ v_neon_type ] == NEON_TYPE_NONE )
				{
					send_check_cinfo ( playerid, "На Ваше Т/С не установлен неон.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				if ( veh_info [ _v_id - 1 ] [ v_neon_type ] != NEON_TYPE_STATIC && veh_info [ _v_id - 1 ] [ v_neon_type ] != NEON_TYPE_BLINKING )
				{
					send_check_cinfo ( playerid, "Вы не можете установить цвет на текущий тип неона.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

            	new neon_color [ 4 ] ;
              	parseRGBA ( _value, neon_color [ 0 ], neon_color [ 1 ], neon_color [ 2 ], neon_color [ 3 ] ) ;

				if ( veh_info [ _v_id - 1 ] [ v_neon ] [ 0 ] == neon_color [ 0 ] &&
					veh_info [ _v_id - 1 ] [ v_neon ] [ 1 ] == neon_color [ 1 ] &&
					veh_info [ _v_id - 1 ] [ v_neon ] [ 2 ] == neon_color [ 2 ] )
				{
					send_check_cinfo ( playerid, "На Вашем Т/С уже установлен выбранный цвет.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

               	_price = 55_000 ;
            	if ( p_info [ playerid ] [ money ] < _price )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно денег для покупки цвета неона.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				global_string [ 0 ] = EOS ;
              	format ( global_string, 144, "{FFFFFF}Вы действительно хотите изменить {"#cOR"}\"Цвет неона\" {FFFFFF}за {"#cTN"}%d руб{FFFFFF}?", _price ) ;
              	show_dialog ( playerid, d_tune_center_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тюнинг-центр", global_string, "Да", "Отмена" ) ;
            }
            case TUNING_CENTER_LIGHT_COLOR:
            {
                new light_color [ 4 ] ;
                parseRGBA ( _value, light_color [ 0 ], light_color [ 1 ], light_color [ 2 ], light_color [ 3 ] ) ;

				if ( veh_info [ _v_id - 1 ] [ v_lights_color ] [ 0 ] == light_color [ 0 ] &&
					veh_info [ _v_id - 1 ] [ v_lights_color ] [ 1 ] == light_color [ 1 ] &&
					veh_info [ _v_id - 1 ] [ v_lights_color ] [ 2 ] == light_color [ 2 ] )
				{
					send_check_cinfo ( playerid, "На Вашем Т/С уже установлен выбранный цвет фар.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

                _price = 90_000 ;
            	if ( p_info [ playerid ] [ money ] < _price )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно денег для покупки цвета фар.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				global_string [ 0 ] = EOS ;
               	format ( global_string, 144, "{FFFFFF}Вы действительно хотите изменить {"#cOR"}\"Цвет фар\" {FFFFFF}за {"#cTN"}%d руб{FFFFFF}?", _price ) ;
               	show_dialog ( playerid, d_tune_center_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тюнинг-центр", global_string, "Да", "Отмена" ) ;
          	}
           	case TUNING_CENTER_TINTING_COLOR:
           	{
            	new tinting_color [ 4 ] ;
            	parseRGBA ( _value, tinting_color [ 0 ], tinting_color [ 1 ], tinting_color [ 2 ], tinting_color [ 3 ] ) ;

				if ( veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ] == tinting_color [ 0 ] &&
					veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ] == tinting_color [ 1 ] &&
					veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ] == tinting_color [ 2 ] &&
					veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ] == tinting_color [ 3 ] )
				{
					send_check_cinfo ( playerid, "На Вашем Т/С уже установлена тонировка с данным цветом.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

             	_price = 80_000 ;
            	if ( p_info [ playerid ] [ money ] < _price )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно денег для покупки цвета тонировки.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				global_string [ 0 ] = EOS ;
              	format ( global_string, 144, "{FFFFFF}Вы действительно хотите изменить {"#cOR"}\"Цвет тонировки\" {FFFFFF}за {"#cTN"}%d руб{FFFFFF}?", _price ) ;
               	show_dialog ( playerid, d_tune_center_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тюнинг-центр", global_string, "Да", "Отмена" ) ;
           	}
           	case TUNING_CENTER_BODY_PAINT_COLOR:
          	{
            	new body_painting_color [ 4 ] ;
             	parseRGBA ( _value, body_painting_color [ 0 ], body_painting_color [ 1 ], body_painting_color [ 2 ], body_painting_color [ 3 ] ) ;

				if ( veh_info [ _v_id - 1 ] [ v_main_color ] [ 0 ] == body_painting_color [ 0 ] &&
					veh_info [ _v_id - 1 ] [ v_main_color ] [ 1 ] == body_painting_color [ 1 ] &&
					veh_info [ _v_id - 1 ] [ v_main_color ] [ 2 ] == body_painting_color [ 2 ] )
				{
					send_check_cinfo ( playerid, "На Вашем Т/С уже установлен цвет кузова с данным цветом.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

              	_price = 60_000 ;
            	if ( p_info [ playerid ] [ money ] < _price )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно денег для покупки цвета кузова.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				global_string [ 0 ] = EOS ;
               	format ( global_string, 144, "{FFFFFF}Вы действительно хотите изменить {"#cOR"}\"Цвет кузова\" {FFFFFF}за {"#cTN"}%d руб{FFFFFF}?", _price ) ;
               	show_dialog ( playerid, d_tune_center_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тюнинг-центр", global_string, "Да", "Отмена" ) ;
           	}
           	case TUNING_CENTER_DISK_COLOR:
           	{
            	new disk_color [ 4 ] ;
               	parseRGBA ( _value, disk_color [ 0 ], disk_color [ 1 ], disk_color [ 2 ], disk_color [ 3 ] ) ;

				if ( veh_info [ _v_id - 1 ] [ v_disk_color ] [ 0 ] == disk_color [ 0 ] &&
					veh_info [ _v_id - 1 ] [ v_disk_color ] [ 1 ] == disk_color [ 1 ] &&
					veh_info [ _v_id - 1 ] [ v_disk_color ] [ 2 ] == disk_color [ 2 ] )
				{
					send_check_cinfo ( playerid, "На Вашем Т/С уже установлен цвет дисков с данным цветом.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

             	_price = 50_000 ;
            	if ( p_info [ playerid ] [ money ] < _price )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно денег для покупки цвета неона.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				global_string [ 0 ] = EOS ;
              	format ( global_string, 144, "{FFFFFF}Вы действительно хотите изменить {"#cOR"}\"Цвет дисков\" {FFFFFF}за {"#cTN"}%d руб{FFFFFF}?", _price ) ;
               	show_dialog ( playerid, d_tune_center_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тюнинг-центр", global_string, "Да", "Отмена" ) ;
          	}
			case TUNING_CENTER_VINYL:
			{
				if ( _value > MAX_TUNING_VYNIL ) return 1 ;

				if ( veh_info [ _v_id - 1 ] [ v_vinyl ] == _value )
				{
					send_check_cinfo ( playerid, "На Вашем Т/С уже установлен этот винил.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

             	_price = g_tuning_center_vinyl [ _value ] [ VNL_PRICE ] ;
            	if ( p_info [ playerid ] [ money ] < _price )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно денег для покупки винила.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
 
				global_string [ 0 ] = EOS ;
              	format ( global_string, 144, "{FFFFFF}Вы действительно хотите изменить {"#cOR"}\"Винил\" {FFFFFF}за {"#cTN"}%d руб{FFFFFF}?", _price ) ;
               	show_dialog ( playerid, d_tune_center_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тюнинг-центр", global_string, "Да", "Отмена" ) ;
			}
            case TUNING_CENTER_STROB_LIGHT:
            {
				if ( _value > MAX_TUNING_STROBE_LIGHTS ) return 1 ;

            	if ( veh_info [ _v_id - 1 ] [ v_pantera_strobs ] == _value )
				{
					send_check_cinfo ( playerid, "У Вас уже есть стробоскоп данного типа.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
                                       
              	_price = g_tuning_center_strobe_light [ _value ] [ TCSL_PRICE ] ;
              	if ( _price > 0 )
               	{
					if ( p_info [ playerid ] [ money ] < _price )
					{
						send_check_cinfo ( playerid, "У Вас недостаточно денег для покупки стробоскопа данного типа.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}

					global_string [ 0 ] = EOS ;
                  	format ( global_string, 144, "{FFFFFF}Вы действительно хотите купить {"#cOR"}\"%s стробоскоп\" {FFFFFF}за {"#cTN"}%d руб{FFFFFF}?", g_tuning_center_strobe_light [ _value ] [ TCSL_NAME ], _price ) ;
                  	show_dialog ( playerid, d_tune_center_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тюнинг-центр", global_string, "Да", "Отмена" ) ;
               	}
               	else
               	{
               		show_dialog ( playerid, d_tune_center_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тюнинг-центр", "{FFFFFF}Вы действительно хотите убрать стробоскоп с личного Т/С?", "Да", "Отмена" ) ;
             	}
          	}
          	case TUNING_CENTER_NITRO:
           	{
				if ( _value < 0 || _value > MAX_TUNING_NITRO ) return 1 ;

             	if ( veh_info [ _v_id - 1 ] [ v_nitro ] == g_tuning_center_nitro [ _value ] [ TC_NITRO_ID ] )
				{
					send_check_cinfo ( playerid, "У Вас уже есть нитро данного типа.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

              	_price = g_tuning_center_nitro [ _value ] [ TC_NITRO_PRICE ] ;
              	if ( _price > 0 )
               	{
					if ( p_info [ playerid ] [ money ] < _price )
					{
						send_check_cinfo ( playerid, "У Вас недостаточно денег для покупки нитро данного типа.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}

					global_string [ 0 ] = EOS ;
                   	format ( global_string, 144, "{FFFFFF}Вы действительно хотите купить {"#cOR"}\"%s\" {FFFFFF}за {"#cTN"}%d "valute_title_"{FFFFFF}?", g_tuning_center_nitro [ _value ] [ TC_NITRO_NAME ], _price ) ;
                   	show_dialog ( playerid, d_tune_center_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тюнинг-центр", global_string, "Да", "Отмена" ) ;
              	}
              	else 
               	{
               		show_dialog ( playerid, d_tune_center_buy_element, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Тюнинг-центр", "{FFFFFF}Вы действительно хотите убрать нитро с личного Т/С?", "Да", "Отмена" ) ;
             	}
          	}
         	default:
               	return true ;
     	}

		set_listitem_info ( playerid, 0, _typeId ) ;
		set_listitem_info ( playerid, 1, _value ) ;
	}
	return 1 ;
}

stock tune_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_tune_center_buy_element:
		{
			if ( ! response ) return 1 ;

			new _v_id = GetPlayerVehicleID ( playerid ) ;

            new type_id = get_listitem_info ( playerid, 0 ),
				value = get_listitem_info ( playerid, 1 ),
				price = 0 ;
				
            switch ( type_id )
            {
                case TUNING_CENTER_NEON_TYPE:
                {
                    price = g_tuning_center_neon [ value ] [ TCN_PRICE ] ;
                    if ( price > 0 )
                    {
						give_money ( playerid, -price ) ;
						insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Покупка неона" ) ;
                    }

                    veh_info [ _v_id - 1 ] [ v_neon_type ] = value ;
                }
                case TUNING_CENTER_NEON_COLOR:
                {
                    new neon_color [ 4 ] ;
                    parseRGBA ( value, neon_color [ 0 ], neon_color [ 1 ], neon_color [ 2 ], neon_color [ 3 ] ) ;

                    price = 55_000 ;
					give_money ( playerid, -price ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Установка цвета неона" ) ;

                    veh_info [ _v_id - 1 ] [ v_neon ] [ 0 ] = neon_color [ 0 ] ;
                    veh_info [ _v_id - 1 ] [ v_neon ] [ 1 ] = neon_color [ 1 ] ;
                    veh_info [ _v_id - 1 ] [ v_neon ] [ 2 ] = neon_color [ 2 ] ;
                }
                case TUNING_CENTER_LIGHT_COLOR:
                {
                    new light_color [ 4 ] ;
                    parseRGBA ( value, light_color [ 0 ], light_color [ 1 ], light_color [ 2 ], light_color [ 3 ] ) ;

                    price = 90_000 ;
					give_money ( playerid, -price ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Установка цвета фар" ) ;

                    veh_info [ _v_id - 1 ] [ v_lights_color ] [ 0 ] = light_color [ 0 ] ;
                    veh_info [ _v_id - 1 ] [ v_lights_color ] [ 1 ] = light_color [ 1 ] ;
                    veh_info [ _v_id - 1 ] [ v_lights_color ] [ 2 ] = light_color [ 2 ] ;
                }
                case TUNING_CENTER_TINTING_COLOR:
                {
                    new tinting_color [ 4 ] ;
                    parseRGBA ( value, tinting_color [ 0 ], tinting_color [ 1 ], tinting_color [ 2 ], tinting_color [ 3 ] ) ;

                    price = 80_000 ;
					give_money ( playerid, -price ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Тонировка авто" ) ;

                    veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ] = tinting_color [ 0 ] ;
                    veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ] = tinting_color [ 1 ] ;
                    veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ] = tinting_color [ 2 ] ;
                    veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ] = tinting_color [ 3 ] ;
				}
                case TUNING_CENTER_BODY_PAINT_COLOR:
                {
                    new body_painting_color [ 4 ] ;
                    parseRGBA ( value, body_painting_color [ 0 ], body_painting_color [ 1 ], body_painting_color [ 2 ], body_painting_color [ 3 ] ) ;

                    price = 60_000 ;
					give_money ( playerid, -price ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Покраска кузова" ) ;

                    veh_info [ _v_id - 1 ] [ v_main_color ] [ 0 ] = body_painting_color [ 0 ] ;
                    veh_info [ _v_id - 1 ] [ v_main_color ] [ 1 ] = body_painting_color [ 1 ] ;
                    veh_info [ _v_id - 1 ] [ v_main_color ] [ 2 ] = body_painting_color [ 2 ] ;
                }
                case TUNING_CENTER_DISK_COLOR:
                {
                    new disk_color [ 4 ] ;
                    parseRGBA ( value, disk_color [ 0 ], disk_color [ 1 ], disk_color [ 2 ], disk_color [ 3 ] ) ;

                    price = 50_000 ;
					give_money ( playerid, -price ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Установка цвета колёс" ) ;

                    veh_info [ _v_id - 1 ] [ v_disk_color ] [ 0 ] = disk_color [ 0 ] ;
                    veh_info [ _v_id - 1 ] [ v_disk_color ] [ 1 ] = disk_color [ 1 ] ;
                    veh_info [ _v_id - 1 ] [ v_disk_color ] [ 2 ] = disk_color [ 2 ] ;
                }
				case TUNING_CENTER_VINYL:
				{
					price = g_tuning_center_vinyl [ value ] [ VNL_PRICE ] ;
                    if ( price > 0 )
                    {
						give_money ( playerid, -price ) ;
						insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Установка винила" ) ;
                    }

                    veh_info [ _v_id - 1 ] [ v_vinyl ] = value ;
				}
                case TUNING_CENTER_STROB_LIGHT:
                {
                    price = g_tuning_center_strobe_light [ value ] [ TCSL_PRICE ] ;
                    if ( price > 0 )
                    {
						give_money ( playerid, -price ) ;
						insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Установка стробоскопа" ) ;
                    }

                    veh_info [ _v_id - 1 ] [ v_pantera_strobs ] = value ;
                }
                case TUNING_CENTER_NITRO:
                {
                    price = g_tuning_center_nitro [ value ] [ TC_NITRO_PRICE ] ;
                    if ( price > 0 )
                    {
						give_money ( playerid, -price ) ;
						insert_money_log ( playerid, INVALID_PLAYER_ID, -price, "Установка нитро" ) ;

						AddVehicleComponent ( _v_id, veh_info [ _v_id - 1 ] [ v_nitro ] ) ;
                    }
                    else 
                    {
                        RemoveVehicleComponent ( _v_id, veh_info [ _v_id - 1 ] [ v_nitro ] ) ;
                    }

                    veh_info [ _v_id - 1 ] [ v_nitro ] = g_tuning_center_nitro [ value ] [ TC_NITRO_ID ] ;
                }
                default: 
                    return true ;
            }
 
			global_string [ 0 ] = EOS ;
			format ( global_string, 48, "%d", p_info [ playerid ] [ money ] ) ;
			onServerSendData ( playerid, UI_TUNING, 0, global_string ) ;

			new Node: node = JSON_Object (
				"type",			JSON_Int ( type_id ),
				"value",		JSON_Int ( value )
			) ;

			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TUNING, 5, global_string ) ;

			if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_player ) 
			{
				SaveComponentToOwnableCar ( _v_id, "users_vehicles_component" ) ;
				SaveVehicleHandling ( _v_id, "users_vehicles_handling" ) ;
				SaveTuningToOwnableCar ( _v_id, "users_vehicles_tuning" ) ;
			}
			else if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_family )
			{
				SaveComponentToOwnableCar ( _v_id, "familys_vehicles_component" ) ;
				SaveVehicleHandling ( _v_id, "familys_vehicles_handling" ) ;
				SaveTuningToOwnableCar ( _v_id, "familys_vehicles_tuning" ) ;
			}
			
			give_bmoney ( GetPVarInt ( playerid, "p_biz_id " ), price, 0 ) ;

			sc_OnVehicleStreamIn ( _v_id, playerid ) ;
			return 1 ;
		}
	}
	return false ;
}