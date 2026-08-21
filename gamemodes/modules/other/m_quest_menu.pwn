/*

	18631 - знак вопроса для пустого

*/

new quest_header_select [ MAX_PLAYERS char ] ;
new quest_info_select [ MAX_PLAYERS char ] ;

stock show_open_quest ( playerid )
{
	#if defined debug_packet
		printf ( "[show_open_quest] playerid: %d", playerid ) ;
	#endif

	new Node: node = JSON_Array ( ), Node: nodeQuest ;
	nodeQuest = JSON_Array (
		JSON_Object (
			"name",			JSON_String  ( "ЗАДАНИЯ ДЛЯ НОВИЧКОВ" ),
			"isActive",		JSON_Bool ( true )
		)
	) ;
	node = JSON_Append ( node, nodeQuest ) ;

	nodeQuest = JSON_Array (
		JSON_Object (
			"name",			JSON_String  ( "ЗАДАНИЯ ДЛЯ СЕМЕЙ" ),
			"isActive",		JSON_Bool ( false )
		)
	) ;
	node = JSON_Append ( node, nodeQuest ) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_QUEST, 2, global_string ) ;
		
	toggle_controlable ( playerid, false ) ;

	if ( quest_status [ playerid ] [ 0 ] < 1 )
	{
		quest_status [ playerid ] [ 0 ] = 1 ;
		update_quest_data ( playerid ) ;
	}
	if ( quest_gps_id { playerid } < 1 ) quest_gps_id { playerid } = 1 ;

	quest_header_select { playerid } = 0 ;
	quest_start_send ( playerid ) ;
}

stock show_packet_quest ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 ) // quest info
	{
		new _idx = strval ( data ) ;
		quest_info_select { playerid } = _idx ;
		if ( quest_header_select { playerid } == 0 )
		{
			new _str [ 24 ], _str2 [ 24 ] ;
			format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( quest_rewards [ _idx ] [ r_money ] ) ) ;
			format ( _str2, sizeof _str2, "%d EXP", quest_rewards [ _idx ] [ r_exp ] ) ;

			new Node: node = JSON_Object (
				"title",			JSON_String ( quest_info [ _idx ] [ q_name ] ),
				"task",				JSON_String ( quest_info [ _idx ] [ q_text ] ),
				"help",				JSON_String ( "" ),
				"prizes",			JSON_Array (
					JSON_String ( _str ),
					JSON_String ( _str2 )
				),
				"currentProgress",	JSON_Int ( quest_progress [ playerid ] [ 0 ] ),
				"maxProgress",		JSON_Int ( quest_progress_start [ _idx ] )
			) ;

			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_QUEST, 1, global_string ) ;
		}
		else if ( quest_header_select { playerid } == 1 )
		{
			if ( _idx == 0 )
			{
				new _quest_id = p_info [ playerid ] [ family_quest ] ;
				if ( _quest_id )
				{
					new _str [ 24 ], _str2 [ 24 ] ;
					format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( family_rewards [ _quest_id - 1 ] [ r_money ] ) ) ;
					format ( _str2, sizeof _str2, "%d "family_title"", family_rewards [ _quest_id - 1 ] [ r_exp ] ) ;

					static const _quest_progress [ ] =
					{
						10,
						20,
						1,
						1,
						10,
						50,
						100,
						1
					} ;

					new Node: node = JSON_Object (
						"title",			JSON_String ( quest_family_info [ _quest_id - 1 ] [ q_name ] ),
						"task",				JSON_String ( quest_family_info [ _quest_id - 1 ] [ q_text ] ),
						"help",				JSON_String ( "" ),
						"prizes",			JSON_Array (
							JSON_String ( _str ),
							JSON_String ( _str2 )
						),
						"currentProgress",	JSON_Int ( p_info [ playerid ] [ family_quest_progress ] ),
						"maxProgress",		JSON_Int ( _quest_progress [ _quest_id - 1 ] )
					) ;

					global_string [ 0 ] = EOS ;
					JSON_Stringify ( node, global_string, sizeof global_string ) ;
					onServerSendData ( playerid, UI_QUEST, 1, global_string ) ;
				}
			}
			else if ( _idx == 1 )
			{
				new _fam_id = p_info [ playerid ] [ family ],
					_quest_id = family_info [ _fam_id - 1 ] [ fam_quest ] ;
				if ( _quest_id )
				{
					new _str [ 24 ], _str2 [ 24 ] ;
					format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( all_family_rewards [ _quest_id - 1 ] [ r_money ] ) ) ;
					format ( _str2, sizeof _str2, "%d "family_title"", all_family_rewards [ _quest_id - 1 ] [ r_exp ] ) ;

					static const _quest_progress [ ] =
					{
						70,
						36,
						42,
						5000,
						100,
						500,
						400,
						300
					} ;

					new Node: node = JSON_Object (
						"title",			JSON_String ( all_family_quest [ _quest_id - 1 ] [ q_name ] ),
						"task",				JSON_String ( all_family_quest [ _quest_id - 1 ] [ q_text ] ),
						"help",				JSON_String ( "" ),
						"prizes",			JSON_Array (
							JSON_String ( _str ),
							JSON_String ( _str2 )
						),
						"currentProgress",	JSON_Int ( family_info [ _fam_id - 1 ] [ fam_quest_progress ] ),
						"maxProgress",		JSON_Int ( _quest_progress [ _quest_id - 1 ] )
					) ;

					global_string [ 0 ] = EOS ;
					JSON_Stringify ( node, global_string, sizeof global_string ) ;
					onServerSendData ( playerid, UI_QUEST, 1, global_string ) ;
				}
			}
		}
	}
	else if ( actionId == 1 ) // get prize
	{
		if ( quest_header_select { playerid } == 0 ) // start quest
		{
			if ( quest_select [ playerid ] [ 0 ] != quest_info_select { playerid } )
			{
				return 1 ;
			}

			if ( quest_status [ playerid ] [ 0 ] == 2 )
			{
				new _qs = quest_select [ playerid ] [ 0 ] ;

			    quest_progress [ playerid ] [ 0 ] = 0 ;
				quest_status [ playerid ] [ 0 ] = 1 ;
				quest_select [ playerid ] [ 0 ] ++ ;
				SendClientMessage ( playerid, col_succes, !"Вы успешно сдали задание, награда получена!" ) ;
				
				new _money = quest_rewards [ _qs ] [ r_money ] * p_info [ playerid ] [ multiplication ] ;

				#if defined m_perks
				new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
				if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
				#endif

				give_money ( playerid, _money ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест" ) ;
				rewards_exp ( playerid, quest_rewards [ _qs ] [ r_exp ] ) ;

				quest_start_send ( playerid ) ;
				update_quest_data ( playerid ) ;
				return 1 ;
			}
		}
		else if ( quest_header_select { playerid } == 1 ) // family
		{
			if ( quest_info_select { playerid } == 0 )
			{
				static const _quest_progress [ ] =
				{
					10,
					20,
					1,
					1,
					10,
					50,
					100,
					1
				} ;

				new family_id = p_info [ playerid ] [ family ], text_string [ 144 ], _quest_id = p_info [ playerid ] [ family_quest ] ;
				if ( p_info [ playerid ] [ family_quest_progress ] >= _quest_progress [ _quest_id - 1 ] )
				{
					format ( text_string, sizeof text_string, "{%s}[FAM] %s выполнил(а) задание. Награда: %d"valute_title_" и %d "family_title".", family_info [ family_id - 1 ] [ fam_chat_color ], p_info [ playerid ] [ name ], family_rewards [ _quest_id - 1 ] [ r_money ], family_rewards [ _quest_id - 1 ] [ r_exp ] ) ;
					family_message ( family_id, col_gray, text_string ) ;
						
					give_money ( playerid, family_rewards [ _quest_id - 1 ] [ r_money ] ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, family_rewards [ _quest_id - 1 ] [ r_money ], "семейный квест" ) ;
						
					family_info [ family_id - 1 ] [ fam_rating ] += 5 ;
					family_info [ family_id - 1 ] [ fam_ticket ] += family_rewards [ _quest_id - 1 ] [ r_exp ] ;
					
					give_all_family_quest ( family_id, 5, 1 ) ;
					give_all_family_quest ( family_id, 6, 5 ) ;
					give_all_family_quest ( family_id, 7, 5 ) ;
					give_all_family_quest ( family_id, 8, 5 ) ;
						
					p_info [ playerid ] [ family_quest ] = -1 ;
					update_int_sql ( playerid, "u_family_quest", -1 ) ;
						
					give_event_progress ( playerid, THE_FAMILY_QUEST, 1 ) ;
					checking_quest_progress ( playerid, 2, 1, quest_line_high ) ;
				}
			}
			else if ( quest_info_select { playerid } == 1 )
			{
				new _fam_id = p_info [ playerid ] [ family ] ;
				if ( _fam_id < 1 ) return 1 ;

				static const _quest_progress [ ] =
				{
					70,
					36,
					42,
					5000,
					100,
					500,
					400,
					300
				} ;
				
				new text_string [ 144 ], _quest_id = family_info [ _fam_id - 1 ] [ fam_quest ] ;
				if ( family_info [ _fam_id - 1 ] [ fam_quest_progress ] >= _quest_progress [ _quest_id - 1 ] )
				{
					format ( text_string, sizeof text_string, "{%s}[FAM] Ваша семья выполнила недельное задание. Награда: %d"valute_title_" и %d "family_title".", family_info [ _fam_id - 1 ] [ fam_chat_color ], all_family_rewards [ _quest_id - 1 ] [ r_money ], all_family_rewards [ _quest_id - 1 ] [ r_exp ] ) ;
					family_message ( _fam_id, col_gray, text_string ) ;
						
					family_info [ _fam_id - 1 ] [ fam_bank ] += all_family_rewards [ _quest_id - 1 ] [ r_money ] ;
					family_info [ _fam_id - 1 ] [ fam_rating ] += 5 ;
					family_info [ _fam_id - 1 ] [ fam_ticket ] += all_family_rewards [ _quest_id - 1 ] [ r_exp ] ;
							
					family_info [ _fam_id - 1 ] [ fam_quest ] = -1 ;
					
					format ( text_string, sizeof text_string, "UPDATE `family` SET `fam_quest` = '-1' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_id ] ) ;
					mysql_tquery ( sql_connection, text_string ) ;
				}
			}
		}
	}
	else if ( actionId == 2 ) // gps
	{
		if ( quest_header_select { playerid } == 0 )
		{
			if ( quest_status [ playerid ] [ 0 ] < 1 )
			{
				quest_status [ playerid ] [ 0 ] = 1 ;
				update_quest_data ( playerid ) ;
			}
			if ( quest_gps_id { playerid } < 1 ) quest_gps_id { playerid } = 1 ;
			check_quest ( playerid ) ;

			onServerDestroy ( playerid, UI_QUEST ) ;
			toggle_controlable ( playerid, true ) ;
		}
	}
	else if ( actionId == 3 ) // close
	{
		onServerDestroy ( playerid, UI_QUEST ) ;
		toggle_controlable ( playerid, true ) ;
	}
	else if ( actionId == 4 ) // quest header select
	{
		quest_header_select { playerid } = strval ( data ) ;
		if ( quest_header_select { playerid } == 0 )
		{
			quest_start_send ( playerid ) ;
		}
		else if ( quest_header_select { playerid } == 1 )
		{
			if ( p_info [ playerid ] [ family ] < 1 )
			{
				new Node: node = JSON_Array ( ) ;
				new Node: nodeQuest = JSON_Array (
					JSON_Object (
						"title",		JSON_String ( "Ежедневный" ),
						"prizes",		JSON_String ( "неизвестно" ),
						"status",		JSON_Int ( 0 )
					)
				) ;

				node = JSON_Append ( node, nodeQuest ) ;

				nodeQuest = JSON_Array (
					JSON_Object (
						"title",		JSON_String ( "Семейный" ),
						"prizes",		JSON_String ( "неизвестно" ),
						"status",		JSON_Int ( 0 )
					)
				) ;

				node = JSON_Append ( node, nodeQuest ) ;

				send_check_cinfo ( playerid, "Вы не состоите в семье!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			show_quest_family ( playerid ) ;
		}
	}
	return 1 ;
}

stock quest_start_send ( playerid )
{
	new Node: node = JSON_Array ( ), _quest_status, _str [ 48 ] ;
	for ( new i = 0, Node: nodeQuest ; i < MAX_QUESTS ; i ++ )
	{
		if ( quest_select [ playerid ] [ 0 ] > i ) _quest_status = 3 ;
		else if ( quest_select [ playerid ] [ 0 ] == i )
		{
			if ( quest_status [ playerid ] [ 0 ] < 1 ) _quest_status = 1 ;
			else _quest_status = 2 ;
		}
		else _quest_status = 0 ;

		format ( _str, sizeof _str, "%s"valute_title_" + %d EXP", GetPlayerCashValueToSmile ( quest_rewards [ i ] [ r_money ] ), quest_rewards [ i ] [ r_exp ] ) ;
		nodeQuest = JSON_Array (
			JSON_Object (
				"title",		JSON_String ( quest_info [ i ] [ q_name ] ),
				"prizes",		JSON_String ( _str ),
				"status",		JSON_Int ( _quest_status )
			)
		) ;

		node = JSON_Append ( node, nodeQuest ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_QUEST, 0, global_string ) ;
	return 1 ;
}

stock show_quest_family ( playerid )
{
	if ( ! p_info [ playerid ] [ family_quest ] )
	{
	    p_info [ playerid ] [ family_quest ] = random ( 8 ) + 1 ;
		p_info [ playerid ] [ family_quest_progress ] = 0 ;

		new sql_string [ 106 + 4 + 9 ] ;
		format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_family_quest` = '%d', `u_family_quest_progress` = '0' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ family_quest ], p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}

	new Node: node = JSON_Array ( ), _quest_status, _str [ 48 ], _count = 0 ;
	if ( p_info [ playerid ] [ family_quest ] > 0 )
	{
		new _quest_id = p_info [ playerid ] [ family_quest ] ;

		_quest_status = 1 ;
		format ( _str, sizeof _str, "%s"valute_title_" + %d "family_title_abb"", GetPlayerCashValueToSmile ( family_rewards [ _quest_id - 1 ] [ r_money ] ), family_rewards [ _quest_id - 1 ] [ r_exp ] ) ;
		new Node: nodeQuest = JSON_Array (
			JSON_Object (
				"title",		JSON_String ( "Ежедневный" ),
				"prizes",		JSON_String ( _str ),
				"status",		JSON_Int ( _quest_status )
			)
		) ;

		node = JSON_Append ( node, nodeQuest ) ;
		_count ++ ;
	}

	new _fam_id = p_info [ playerid ] [ family ] ;
	if ( ! family_info [ _fam_id - 1 ] [ fam_quest ] )
	{
	    family_info [ _fam_id - 1 ] [ fam_quest ] = random ( 8 ) + 1 ;
		family_info [ _fam_id - 1 ] [ fam_quest_progress ] = 0 ;
			
		new sql_string [ 99 + 4 + 9 ] ;
		format ( sql_string, sizeof sql_string, "UPDATE `family` SET `fam_quest` = '%d', `fam_quest_progress` = '0' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_quest ], family_info [ _fam_id - 1 ] [ fam_id ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
	}

	if ( family_info [ _fam_id - 1 ] [ fam_quest ] != -1 )
	{
		new _quest_id = p_info [ playerid ] [ family_quest ] ;

		_quest_status = 1 ;
		format ( _str, sizeof _str, "%s"valute_title_" + %d "family_title_abb"", GetPlayerCashValueToSmile ( all_family_rewards [ _quest_id - 1 ] [ r_money ] ), all_family_rewards [ _quest_id - 1 ] [ r_exp ] ) ;
		new Node: nodeQuest = JSON_Array (
			JSON_Object (
				"title",		JSON_String ( "Семейный" ),
				"prizes",		JSON_String ( _str ),
				"status",		JSON_Int ( _quest_status )
			)
		) ;

		node = JSON_Append ( node, nodeQuest ) ;
		_count ++ ;
	}

	if ( _count )
	{
		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_QUEST, 0, global_string ) ;
	}
	return 1 ;
}

stock show_window_monologue ( playerid, skinId, monologueText [ ], monologueAuthor [ ], actionText [ ] )
{
	#if defined debug_packet
		printf ( "[show_window_monologue] playerid: %d", playerid ) ;
	#endif

	new Node: node = JSON_Object (
		"actorId",				JSON_Int ( skinId ),
		"monologueText",		JSON_String ( monologueText ),
		"monologueAuthor",		JSON_String ( monologueAuthor ),
		"actionText",			JSON_String ( actionText )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_QUESTS_MONOLOGUES, 0, global_string ) ;
}

stock show_packet_monologue ( playerid, actionId, data [ ] )
{
	#pragma unused data
	if ( actionId == 0 ) // exit
	{
		toggle_controlable ( playerid, true ) ;
	}
	return 1 ;
}

enum
{
	EDUCATION_INV_SLOT,
	EDUCATION_INV_DRAGGED,
	EDUCATION_SPEEDOMETR,
	EDUCATION_DONATE,
	EDUCATION_CAR_BUY,
	EDUCATION_TABLET_SIM,
	EDUCATION_FIRST_ENTRANCE,
	EDUCATION_BUY_HOUSE,
	EDUCATION_BUY_BUSINESS,
	EDUCATION_CAR_INFO,
	EDUCATION_LICENSES,
	EDUCATION_SKIN_INFO,
	
	EDUCATION_FAMILY_SCROLL,
	EDUCATION_FAMILY_LEVEL,
	EDUCATION_FAMILY_GRAFFITY,
	EDUCATION_FAMILY_ENPRISES,
	EDUCATION_FAMILY_TALONS,
	EDUCATION_FAMILY_INVITE,

	MAX_EDUCATIONS
} ;

new educations [ MAX_EDUCATIONS ] [ 32 ] ;
new users_education [ MAX_PLAYERS ] [ MAX_EDUCATIONS ] ;

stock education_OnGameModeInit ( )
{
	format ( educations [ EDUCATION_INV_SLOT ], 32, "u_inventory_slot" ) ;
	format ( educations [ EDUCATION_INV_DRAGGED ], 32, "u_inventory_dragged" ) ;
	format ( educations [ EDUCATION_SPEEDOMETR ], 32, "u_speedometr" ) ;
	format ( educations [ EDUCATION_DONATE ], 32, "u_donate" ) ;
	format ( educations [ EDUCATION_CAR_BUY ], 32, "u_car_buy" ) ;
	format ( educations [ EDUCATION_TABLET_SIM ], 32, "u_tablet_sim" ) ;
	format ( educations [ EDUCATION_FIRST_ENTRANCE ], 32, "u_first_entrance" ) ;
	format ( educations [ EDUCATION_BUY_HOUSE ], 32, "u_buy_house" ) ;
	format ( educations [ EDUCATION_BUY_BUSINESS ], 32, "u_buy_business" ) ;
	format ( educations [ EDUCATION_CAR_INFO ], 32, "u_car_info" ) ;
	format ( educations [ EDUCATION_LICENSES ], 32, "u_licenses" ) ;
	format ( educations [ EDUCATION_SKIN_INFO ], 32, "u_skin_info" ) ;

	format ( educations [ EDUCATION_FAMILY_SCROLL ], 32, "u_family_scroll" ) ;
	format ( educations [ EDUCATION_FAMILY_LEVEL ], 32, "u_family_level" ) ;
	format ( educations [ EDUCATION_FAMILY_GRAFFITY ], 32, "u_family_graffity" ) ;
	format ( educations [ EDUCATION_FAMILY_ENPRISES ], 32, "u_family_enprises" ) ;
	format ( educations [ EDUCATION_FAMILY_TALONS ], 32, "u_family_talons" ) ;
	format ( educations [ EDUCATION_FAMILY_INVITE ], 32, "u_family_invite" ) ;
	return 1 ;
}

stock users_education_info ( playerid )
{
	static const _str [ ] = "SELECT * FROM `users_education` WHERE `u_sql_id` = '%d' LIMIT 1" ;
	new query_string [ sizeof _str + 9 ] ;
	format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, query_string, "load_users_education", "i", playerid ) ;
	return 1 ;
}

callback: load_users_education ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		for ( new i = 0 ; i < MAX_EDUCATIONS ; i ++ )
		{
			users_education [ playerid ] [ i ] = 0 ;
		}

		static const _str [ ] = "INSERT INTO `users_education` (`u_sql_id`) VALUES ('%d')" ;
		new query_string [ sizeof _str + 9 ] ;
		format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, query_string ) ;
		return 1 ;
	}

	users_education [ playerid ] [ EDUCATION_INV_SLOT ] = cache_get_field_content_int ( 0, "u_inventory_slot" ) ;
	users_education [ playerid ] [ EDUCATION_INV_DRAGGED ] = cache_get_field_content_int ( 0, "u_inventory_dragged" ) ;
	users_education [ playerid ] [ EDUCATION_SPEEDOMETR ] = cache_get_field_content_int ( 0, "u_speedometr" ) ;
	users_education [ playerid ] [ EDUCATION_DONATE ] = cache_get_field_content_int ( 0, "u_donate" ) ;
	users_education [ playerid ] [ EDUCATION_CAR_BUY ] = cache_get_field_content_int ( 0, "u_car_buy" ) ;
	users_education [ playerid ] [ EDUCATION_TABLET_SIM ] = cache_get_field_content_int ( 0, "u_tablet_sim" ) ;
	users_education [ playerid ] [ EDUCATION_FIRST_ENTRANCE ] = cache_get_field_content_int ( 0, "u_first_entrance" ) ;
	users_education [ playerid ] [ EDUCATION_BUY_HOUSE ] = cache_get_field_content_int ( 0, "u_buy_house" ) ;
	users_education [ playerid ] [ EDUCATION_BUY_BUSINESS ] = cache_get_field_content_int ( 0, "u_buy_business" ) ;
	users_education [ playerid ] [ EDUCATION_CAR_INFO ] = cache_get_field_content_int ( 0, "u_car_info" ) ;
	users_education [ playerid ] [ EDUCATION_LICENSES ] = cache_get_field_content_int ( 0, "u_licenses" ) ;
	users_education [ playerid ] [ EDUCATION_SKIN_INFO ] = cache_get_field_content_int ( 0, "u_skin_info" ) ;
	
	users_education [ playerid ] [ EDUCATION_FAMILY_SCROLL ] = cache_get_field_content_int ( 0, "u_family_scroll" ) ;
	users_education [ playerid ] [ EDUCATION_FAMILY_LEVEL ] = cache_get_field_content_int ( 0, "u_family_level" ) ;
	users_education [ playerid ] [ EDUCATION_FAMILY_GRAFFITY ] = cache_get_field_content_int ( 0, "u_family_graffity" ) ;
	users_education [ playerid ] [ EDUCATION_FAMILY_ENPRISES ] = cache_get_field_content_int ( 0, "u_family_enprises" ) ;
	users_education [ playerid ] [ EDUCATION_FAMILY_TALONS ] = cache_get_field_content_int ( 0, "u_family_talons" ) ;
	users_education [ playerid ] [ EDUCATION_FAMILY_INVITE ] = cache_get_field_content_int ( 0, "u_family_invite" ) ;
	return 1 ;
}

stock save_user_education ( playerid, educationId )
{
	users_education [ playerid ] [ educationId ] = 1 ;

	static const _str [ ] = "UPDATE `users_education` SET `%s` = '1' WHERE `u_sql_id` = '%d' LIMIT 1" ;
	new query_string [ sizeof _str + 32 + 9 ] ;
	format ( query_string, sizeof query_string, _str, educations [ educationId ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, query_string ) ;
	return 1 ;
}