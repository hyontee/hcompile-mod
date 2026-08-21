#define MAX_UK_WANTED_LIST             19
#define MAX_PDD_WANTED_LIST            16

enum E_MVD_TABLET_UK_WANTED_STRUCT
{
    MT_UK_WL_REASON [ 100 ],
    MT_UK_WL_SUSPECT_LEVEL
} ;

new g_mvd_tablet_UK_wanted_list [ MAX_UK_WANTED_LIST ] [ E_MVD_TABLET_UK_WANTED_STRUCT ] = 
{
    { "Неподчинение сотруднику власти",                          1 },
    { "Убийство",                                                5 },
    { "Умышленное причинение тяжкого вреда здоровью",            3 },
    { "Умышленное причинение средней тяжести вреда здоровью",    2 },
    { "Угроза убийством или причинением тяжкого вреда здоровью", 1 },
    { "Изнасилование",                                           3 },
    { "Кража",                                                   2 },
    { "Мошенничество",                                           3 },
    { "Грабёж",                                                  2 },
    { "Разбой",                                                  2 },
    { "Вымогательство",                                          1 },
    { "Хулиганство",                                             1 },
    { "Незаконное приобретение, хранение, перевозка, изготовление, \
      переработка наркотических средств",                        3 },
    { "Незаконные производство, сбыт или \
      пересылка наркотических средств",                          4 },
    { "Нарушение правил дорожного движения и \
      эксплуатации транспортных средств",                        1 },
    { "Применение насилия в отношении представителя власти",     5 },
    { "Подделка документов, государственных наград, \
      штампов, печатей, бланков",                                4 },
    { "Самоуправство",                                           3 },
    { "Мелкое хищение",                                          1 }
} ;

enum E_MVD_TABLET_PDD_WANTED_STRUCT
{
    MT_PDD_WL_REASON [ 100 ],
    MT_PDD_WL_TICKET_PRICE,
    MT_PDD_WL_SUSPECT_LEVEL
};

new g_mvd_tablet_PDD_wanted_list [ MAX_PDD_WANTED_LIST ] [ E_MVD_TABLET_PDD_WANTED_STRUCT ] = 
{
    { "Во время движения не были включены фары",                 500,        0 },
    { "Превышение установленной скорости движения",              2500,       0 },
    { "Проезд на запрещающий сигнал светофора",                  500,        0 },
    { "Непредоставление преимущества пешеходам",                 500,        0 },
    { "Нарушение правил обгона",                                 2500,       0 },
    { "Неправильная парковка",                                   500,        0 },
    { "Управление транспортным средством в \
    состоянии алкогольного опьянения",                          10000,       0 },
    { "Нарушение правил проезда перекрестков",                   2500,       0 },
    { "Непредоставление преимущества другим \
     транспортным средствам при перестроении",                  2500,        0 },
    { "Нарушение правил использования ремней безопасности",      500,        0 },
    { "Управление транспортным средством без документов",        10000,      4 },
    { "Нарушение правил перевозки детей",                        500,        0 },
    { "Проезд по встречной полосе движения",                     2500,       0 },
    { "Нарушение правил проезда железнодорожных переездов",      3000,       0 },
    { "Нарушение правил остановки и стоянки",                    2000,       0 },
    { "Нарушение правил маневрирования",                         2000,       0 }
} ;

stock handleTabletMvd ( playerid, actionId, data [ ] )
{
	if ( actionId == MVD_APP ) // mvd open
	{
        onServerSendData ( playerid, UI_TABLET, MVD_APP + 6, "Объявить в розыск" ) ;

        new Node: node = JSON_Object (
        	"nickname",     JSON_String ( p_info [ playerid ] [ name ] ),
          	"isDuty",       JSON_Int ( is_fraction_duty { playerid } ),
           	"arrestCount",  JSON_Int ( p_info [ playerid ] [ arrest_count ] ),
          	"skinId",       JSON_Int ( getNewSkinModel ( playerid ) )
       	) ;

		global_string [ 0 ] = EOS ;
        JSON_Stringify ( node, global_string, sizeof global_string ) ;
        onServerSendData ( playerid, UI_TABLET, MVD_APP, global_string ) ;
	}
	else if ( actionId == MVD_APP + 1 ) // список розыскиваемых
	{
		new Node: node = JSON_Array ( ), Node: nodeWanted, itemsLoaded = 0, Float: _distance ;
		foreach(new i: logged_players)
		{
			if ( p_info [ i ] [ wanted ] < 1 ) continue ;

			_distance = GetDistanceBetweenPoints ( 
				p_t_info [ playerid ] [ p_pos ] [ 0 ], 
				p_t_info [ playerid ] [ p_pos ] [ 1 ], 
				p_t_info [ playerid ] [ p_pos ] [ 2 ],
				p_t_info [ i ] [ p_pos ] [ 0 ], 
				p_t_info [ i ] [ p_pos ] [ 1 ], 
				p_t_info [ i ] [ p_pos ] [ 2 ]
			) ;

			nodeWanted = JSON_Array (
					JSON_Object (
					"skinId",       JSON_Int ( getNewSkinModel ( i ) ),
					"playerName",   JSON_String ( p_info [ i ] [ name ] ),
					"reason",       JSON_String ( "" ),
					"wantedLevel",  JSON_Int ( p_info [ i ] [ wanted ] ),
					"distance",     JSON_Int ( floatround ( _distance ) )
				)
			) ;

			node = JSON_Append ( node, nodeWanted ) ;

			if ( ++ itemsLoaded == 5 )
			{
				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;
				onServerSendData ( playerid, UI_TABLET, MVD_APP + 1, global_string ) ;

				node = JSON_Array ( ) ;
				itemsLoaded = 0 ;
			}
		}

		if ( itemsLoaded )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TABLET, MVD_APP + 1, global_string ) ;
		}
	}
	else if ( actionId == MVD_APP + 2 ) // выдача розыска или штрафа
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new _value [ MAX_PLAYER_NAME ], _type, _reason, bool: _fine ;
		JSON_GetString ( json, "value", _value ) ;
		JSON_GetInt ( json, "type", _type ) ;
		JSON_GetInt ( json, "reason", _reason ) ;
		JSON_GetBool ( json, "fine", _fine ) ;

		tablet_sanction [ playerid ] = true ;

		if ( _fine ) // штраф
		{
			new _cmdStr [ 100 ] ;
			format ( _cmdStr, sizeof _cmdStr, "%s %d %s", _value, g_mvd_tablet_PDD_wanted_list [ _reason ] [ MT_PDD_WL_TICKET_PRICE ], g_mvd_tablet_PDD_wanted_list [ _reason ] [ MT_PDD_WL_REASON ] ) ;
			callcmd::ticket ( playerid, _cmdStr ) ;
		}
		else // розыск
		{
			new _cmdStr [ 100 ] ;
			format ( _cmdStr, sizeof _cmdStr, "%s %d %s", _value, g_mvd_tablet_UK_wanted_list [ _reason ] [ MT_UK_WL_SUSPECT_LEVEL ], g_mvd_tablet_UK_wanted_list [ _reason ] [ MT_UK_WL_REASON ] ) ;
			callcmd::su ( playerid, _cmdStr ) ;
		}
	}
	else if ( actionId == MVD_APP + 4 ) // игроки со штрафом
	{
      	new Node: data_node,
           	fine_type,
          	targetid_str [ 64 ],
          	targetid = INVALID_PLAYER_ID ;

        JSON_Parse ( data, data_node ) ;

        JSON_GetInt ( data_node, "inputType", fine_type ) ;
        JSON_GetString ( data_node, "value", targetid_str ) ;

        if ( ! fine_type )
        {
        	targetid = strval ( targetid_str ) ;
           	targetid_str [ 0 ] = EOS ;

          	if ( targetid == INVALID_PLAYER_ID )
			{
				send_check_cinfo ( playerid, "Неверный ID игрока!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

            format ( targetid_str, sizeof ( targetid_str ), "%s", p_info [ targetid ] [ name ] ) ;
        }

		global_string [ 0 ] = EOS ;
        format ( global_string, 256, "\
			SELECT \
			ut.*, \
			us.u_name \
			FROM users_tickets AS ut \
			LEFT JOIN users AS us ON ut.u_id=us.u_id \
			WHERE us.u_name = '%s'", targetid_str ) ;
        mysql_tquery ( sql_connection, global_string, "ShowMVDVehicleFines", "i", playerid ) ;
	}
	else if ( actionId == MVD_APP + 5 ) // categories reason
	{
		global_string [ 0 ] = EOS ;
		new fmt_str [ 128 ], reason_name [ 100 ] ;

		format ( fmt_str, sizeof fmt_str, "[{ \"categoryId\": %d, \"categoryName\": \"%s\", \"listWantedReason\":[", 0, "УК" ) ;
		strcat ( global_string, fmt_str ) ;

		for ( new idx = 0 ; idx < MAX_UK_WANTED_LIST ; idx ++ ) 
		{    
			reason_name [ 0 ] = EOS ;
			format ( reason_name, sizeof reason_name, "%s", g_mvd_tablet_UK_wanted_list [ idx ] [ MT_UK_WL_REASON ] ) ;
			format ( fmt_str, sizeof fmt_str, "{ \"id\": %d, \"name\": \"%s\" },", idx, reason_name ) ;
			strcat ( global_string, fmt_str ) ;
		}
		strdel ( global_string, strlen ( global_string ) - 1, strlen ( global_string ) ) ;
		strcat ( global_string, "] } ]" ) ;

		onServerSendData ( playerid, UI_TABLET, REQ_GET_CATEGORIES_N_REASONS, global_string ) ;



		global_string [ 0 ] = EOS ;
		fmt_str [ 0 ] = EOS ;
		format ( fmt_str, sizeof fmt_str, "[{ \"categoryId\": %d, \"categoryName\": \"%s\", \"listWantedReason\":[", 1, "ПДД" ) ;
		strcat ( global_string, fmt_str ) ;

		for ( new idx = 0 ; idx < MAX_PDD_WANTED_LIST ; idx ++ ) 
		{
			reason_name [ 0 ] = EOS ;
			format ( reason_name, sizeof reason_name, "%s", g_mvd_tablet_PDD_wanted_list [ idx ] [ MT_PDD_WL_REASON ] ) ;
			format ( fmt_str, sizeof fmt_str, "{ \"id\": %d, \"name\": \"%s\" },", idx, reason_name ) ;
			strcat ( global_string, fmt_str ) ;
		}
		strdel ( global_string, strlen ( global_string ) - 1, strlen ( global_string ) ) ;
		strcat ( global_string, " ] } ]" ) ;

		onServerSendData ( playerid, UI_TABLET, REQ_GET_CATEGORIES_N_REASONS, global_string ) ;
	}
	else if ( actionId == MVD_APP + 6 ) // mark in suspect
	{
		new targetid = INVALID_PLAYER_ID ;
		sscanf ( data, "u", targetid ) ;

		if ( ! IsPlayerConnected ( targetid ) ) return 1 ;
	
		SetPlayerRaceCheckpoint ( playerid, 1, p_t_info [ targetid ] [ p_pos ] [ 0 ], p_t_info [ targetid ] [ p_pos ] [ 1 ], p_t_info [ targetid ] [ p_pos ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
		is_gps_used { playerid } = 1 ;

		send_check_cinfo ( playerid, "Вы отметили последнее местоположении преступника.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
	}
	return 1 ;
}

callback: ShowMVDVehicleFines ( playerid )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		send_check_cinfo ( playerid, "Информация не найдена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

    new Node: node = JSON_Object ( "fines", JSON_Array ( ) ) ;

    new fine_id,
        fine_veh_modelid,
        fine_number [ 64 ],
        fine_owner [ 24 ],
        fine_reason [ 100 ],
        fine_date [ 30 ],
        fine_amount ;

    for ( new i = 0 ; i < rows ; i ++ )
    {
        fine_id = cache_get_field_content_int ( i, "id" ) ;
        fine_veh_modelid = cache_get_field_content_int ( i, "car_model" ) ;
        cache_get_field_content ( i, "car_number", fine_number ) ;
        cache_get_field_content ( i, "u_name", fine_owner ) ;
        cache_get_field_content ( i, "fine_type", fine_reason ) ;
        cache_get_field_content ( i, "fine_date", fine_date ) ;
        fine_amount = cache_get_field_content_int ( i, "fine_value" ) ;

        JSON_ArrayAppend ( node, "fines",
        	JSON_Object (
            	"id",           JSON_Int ( fine_id ),
               	"car",          JSON_String ( GetVehicleNameEx ( INVALID_VEHICLE_ID, fine_veh_modelid ) ),
              	"plateNumber",  JSON_String ( fine_number ),
               	"owner",        JSON_String ( fine_owner ),
              	"date",         JSON_String ( fine_date ),
              	"reason",       JSON_String ( fine_reason ),
               	"amount",       JSON_Int ( fine_amount )
          	)
		) ;
    }

    new Node: fines_node ;
    JSON_GetObject ( node, "fines", fines_node ) ;

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( fines_node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_TABLET, MVD_APP + 4, global_string ) ;
    return true ;
}