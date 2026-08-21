#define incass_km_pay 2000
#define incass_pay_actor 500
#define incass_bizz_pay 5000

#define incass_model_id 582

enum
{
	d_invite_incass = 17000,
	d_job_incass,
	
	d_collector_panel,
	d_collector_biz,
	d_collector_atm,
	d_collector_atm_set
} ;
 
new incass_player_rool [ MAX_PLAYERS ] ;

new Float: actor_incass_pos [ 3 ] = { 986.3983, -474.5406, 1015.4092 } ;
new Float: actor_incass_position [ 3 ] [ 4 ] =
{
	{ 986.4239, -475.8635, 1015.4092, 18.8820 },
	{ 986.4239, -475.8635, 1015.4092, 18.8820 },
	{ 986.4239, -475.8635, 1015.4092, 18.8820 }
} ;

new Float: start_inkass_position [ 3 ] = { 990.5950, -475.4949, 1015.4092 } ;

stock clear_player_incass ( playerid )
{
	p_info [ playerid ] [ incass_invite ] = INVALID_PLAYER_ID ;
	incass_player_rool [ playerid ] = 0 ;
	return 1 ;
}

stock incass_OnGameModeInit ( )
{
	static actorid ;
	for ( new i = 0 ; i < sizeof actor_incass_position ; i ++ )
	{
		actorid = CreateActor ( 80, actor_incass_position [ i ] [ 0 ], actor_incass_position [ i ] [ 1 ], actor_incass_position [ i ] [ 2 ], actor_incass_position [ i ] [ 3 ] ) ;
		SetActorVirtualWorld ( actorid, bank_world [ i ] ) ;
	}
	
	CreateDynamic3DTextLabel ( "** Начальник службы инкассации **\n{"#cGR3D"}Подойдите для получения з/п", col_header_3d, actor_incass_pos [ 0 ], actor_incass_pos [ 1 ], actor_incass_pos [ 2 ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1 ) ;
	
	new _area_id = CreateDynamicSphere ( actor_incass_pos [ 0 ], actor_incass_pos [ 1 ], actor_incass_pos [ 2 ], 3.0, -1, -1, -1 ) ;
	area_info [ _area_id ] [ a_type ] = area_type_incass ;
	
	new _pickup_id = CreateDynamicPickup ( 1275, 23, start_inkass_position [ 0 ], start_inkass_position [ 1 ], start_inkass_position [ 2 ], -1, -1, -1 ) ;
	pick_info [ _pickup_id ] [ pick_type ] = pick_type_incass ;
	
	CreateDynamic3DTextLabel ( "** Инкассация **\n{"#cGR3D"}Подойдите для начала рабочего дня", col_header_3d, start_inkass_position [ 0 ], start_inkass_position [ 1 ], start_inkass_position [ 2 ] + 0.7, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1 ) ;
	return 1 ;
}

stock incass_EnterDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_incass:
		{
			if ( p_info [ playerid ] [ job ] != job_incass ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не работаете инкассатором. Устроиться на работу можно в Мэрии." ) ;
			if ( p_info [ playerid ] [ salary ] < 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вам нечего сдать начальнику." ) ;
			
			DisablePlayerRaceCheckpoint ( playerid ) ;
			is_gps_used { playerid } = 0 ;
			
			p_info [ playerid ] [ salary ] += incass_pay_actor ;
			give_money ( playerid, p_info [ playerid ] [ salary ] ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, p_info [ playerid ] [ salary ], "зп инкассатор" ) ;
			
			p_info [ playerid ] [ atm_good ] ++ ;
			update_int_sql ( playerid, "u_atm_good", p_info [ playerid ] [ atm_good ] ) ;

			new __t_string [ 64 ] ;
			format ( __t_string, sizeof ( __t_string ), "{"#cGInfo"}* {"#cWH"}Заработано: {"#cGN"}%d"valute_title_"", p_info [ playerid ] [ salary ] ) ;
			SendClientMessage ( playerid, col_white, __t_string ) ;
			p_info [ playerid ] [ salary ] = 0 ;
			
			checking_quest_progress ( playerid, 6, incass_pay_actor, quest_line_high ) ;
			return 1 ;
		}
	}
	return 0 ;
}

CMD:inviteinc ( playerid, params [ ] )
{
	if ( p_info [ playerid ] [ job ] != job_incass ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не работаете инкассатором." ) ;
	if ( p_info [ playerid ] [ incass_invite ] != INVALID_PLAYER_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас уже есть напарник." ) ;
	if ( sscanf ( params, "u", params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /inviteinc [id игрока]" ) ;
	if ( ! IsPlayerConnected ( params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не в сети." ) ;
	
	if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ params [ 0 ] ][ p_pos ] [ 0 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 1 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( playerid ) != GetPlayerVirtualWorld ( params [ 0 ] ) )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;
	if ( ! bad_dialog ( params [ 0 ] ) || ! bad_dialog ( playerid ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок в данный момент не может осуществлять сделки.") ;

	if ( p_info [ params [ 0 ] ] [ job ] != job_incass ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок не работает инкассатором." ) ;
	if ( p_info [ params [ 0 ] ] [ incass_invite ] != INVALID_PLAYER_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок уже работает с кем-то в паре." ) ;

	if ( incass_player_rool [ playerid ] == 0 || incass_player_rool [ params [ 0 ] ] == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Выберите роль!" ) ;

	if ( incass_player_rool [ playerid ] == incass_player_rool [ params [ 0 ] ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас одинаковые роли." ) ;
	
	buyer_id [ playerid ] = params [ 0 ] ;
	seller_id [ params [ 0 ] ] = playerid ;
		
	sell_time { playerid } =
	sell_time { params [ 0 ] } = time_sell_null ;
	
	new dialog_string [ 80 + MAX_PLAYER_NAME ] ;
	format ( dialog_string, sizeof dialog_string, "{"#cBL"}%s[%d] {"#cWH"}предлагает Вам стать его напарником.",
	p_info [ playerid ] [ name ], playerid ) ;
	show_dialog ( params [ 0 ], d_invite_incass, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Икассатор", dialog_string, "Принять", "Отмена" ) ;
		
	format ( dialog_string, sizeof ( dialog_string  ), "{"#cBInfo"}* {"#cWH"}Вы предложили {"#cBL"}%s{"#cWH"} стать Вашим напарником.",
	p_info [ params [ 0 ] ] [ name ] ) ;
	SendClientMessage ( playerid, col_white, dialog_string ) ;
	return 1 ;
}

stock incass_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_job_incass:
		{
			if ( ! response ) return 1 ;
			
			switch ( listitem )
			{
				case 0:
				{
					if ( incass_player_rool [ playerid ] != 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже работаете инкассатором." ) ;
					
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Помощь по работе", "\
					{"#cBL"}Работа водитель - охранник:\n\
					{"#cWH"}Вам потребуется напарник (инкассатор). Используйте /inviteinc [id игрока] для приглашения напарника.\n\
					{"#cGRDialog"}1. {"#cWH"}Проехать 5 банкоматов по полученным меткам.\n\
					{"#cGRDialog"}2. {"#cWH"}Произвести инкассацию.\n\
					{"#cGRDialog"}3. {"#cWH"}Во время работы Ваш напарник должен находиться рядом, иначе Вы потеряете работу!\n\
					{"#cGRDialog"}4. {"#cWH"}Сдать деньги в банк и получить зарплату.",
	 				"Закрыть", "" ) ;

	 				incass_player_rool [ playerid ] = 1 ;

	 				if ( ! p_info [ playerid ] [ gender ] ) SetPlayerSkin ( playerid, 80 ) ;
					else SetPlayerSkin ( playerid, 75 ) ;
						
	                give_weapon ( playerid, 23, 20 ) ;
					give_weapon ( playerid, 3, 1 ) ;
					
					SendClientMessage ( playerid, col_white, "{"#cBInfo"}* {"#cWH"}Вы водитель-охранник. Используйте /inviteinc [id игрока] для приглашения напарника." ) ;
				}
				case 1:
				{
					if ( incass_player_rool [ playerid ] != 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже работаете инкассатором." ) ;
					
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Помощь по работе", "\
					{"#cBL"}Работа инкассатор - охранник:\n\
					{"#cWH"}Вам потребуется напарник (водитель). Используйте /inviteinc [id игрока] для приглашения напарника.\n\
	 				{"#cGRDialog"}1. {"#cWH"}Проехать 5 банкоматов по полученным меткам.\n\
					{"#cGRDialog"}2. {"#cWH"}Произвести инкассацию.\n\
					{"#cGRDialog"}3. {"#cWH"}Во время работы Ваш напарник должен находиться рядом, иначе Вы потеряете работу!\n\
					{"#cGRDialog"}3. {"#cWH"}Сдать деньги в банк и получить зарплату.",
	 				"Закрыть", "" ) ;

					incass_player_rool [ playerid ] = 2 ;

	 				if ( ! p_info [ playerid ] [ gender ] ) SetPlayerSkin ( playerid, 80 ) ;
					else SetPlayerSkin ( playerid, 75 ) ;

	 				SetPlayerAttachedObject ( playerid, 1, 11745, 1, 0.031999, -0.170998, -0.009999, 86.000007, -178.299957, -64.500007, 1.120000, 1.079998, 1.029000  ) ;

	 				give_weapon ( playerid, 23, 20 ) ;
					give_weapon ( playerid, 3, 1 ) ;

					SendClientMessage ( playerid, col_white, "{"#cBInfo"}* {"#cWH"}Вы инкассатор-охранник. Используйте /inviteinc [id игрока] для приглашения напарника." ) ;
					return 1 ;
				}
				case 2:
				{
					if ( ! incass_player_rool [ playerid ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не работаете инкассатором." ) ;
					if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) RemovePlayerAttachedObject ( playerid, 1 ) ;
					
					if ( p_info [ playerid ] [ incass_invite ] != INVALID_PLAYER_ID )
					{
						new _targetid = p_info [ playerid ] [ incass_invite ] ;
						
						SendClientMessage ( _targetid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваш напарник закончил работу. Для продолжения найдите нового напарника!" ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы закончили работу." ) ;
						
						p_info [ _targetid ] [ incass_invite ] =
						p_info [ playerid ] [ incass_invite ] = INVALID_PLAYER_ID ;
						
						is_gps_used { _targetid } =
						is_gps_used { playerid } = 0 ;
						
						DisablePlayerRaceCheckpoint ( _targetid ) ;
						DisablePlayerRaceCheckpoint ( playerid ) ;
					}
					
					incass_player_rool [ playerid ] = 0 ;
					SetPlayerSkin ( playerid, p_info [ playerid ] [ skin ] ) ;
					
					give_money ( playerid, p_info [ playerid ] [ salary ] ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, p_info [ playerid ] [ salary ], "зп инкассатор" ) ;
					
					new __t_string [ 72 ] ;
					format ( __t_string, sizeof ( __t_string ), "{"#cGInfo"}* {"#cWH"}Заработано: {"#cGN"}%d"valute_title_"", p_info [ playerid ] [ salary ] ) ;
					SendClientMessage ( playerid, col_white, __t_string ) ;
					p_info [ playerid ] [ salary ] = 0 ;

					fraction_duty ( playerid ) ;
				}
			}
			return 1 ;
		}
		case d_invite_incass:
		{
			if ( ! response )
			{
				clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			
			new _targetid = seller_id [ playerid ] ;
			if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ _targetid ] [ p_pos ] [ 0 ], p_t_info [ _targetid ] [ p_pos ] [ 1 ], p_t_info [ _targetid ] [ p_pos ] [ 2 ] ) || p_t_info [ playerid ] [ p_data ] [ 1 ] != p_t_info [ _targetid ] [ p_data ] [ 1 ] )
			{
				clear_sell_params ( playerid, _targetid ) ;
				SendClientMessage ( _targetid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок слишком далеко." ) ;
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы слишком далеко от игрока." ) ;
			}
			
			p_info [ _targetid ] [ incass_invite ] = playerid ;
			p_info [ playerid ] [ incass_invite ] = _targetid ;
			
			new scm_string [ 63 + MAX_PLAYER_NAME ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы приняли приглашение {"#cGN"}%s{"#cWH"}.", p_info [ _targetid ] [ name ] ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;
			format( scm_string, sizeof scm_string, "{"#cGInfo"}* %s{"#cWH"} принял(а) Ваше приглашение.", p_info [ playerid ] [ name ] ) ;
			SendClientMessage ( _targetid, col_white, scm_string ) ;
			
			clear_sell_params ( playerid, _targetid ) ;
			return 1 ;
		}
		case d_collector_panel:
	    {
			if ( ! response ) return 1 ;
			switch ( listitem )
			{
			    case 0: show_collector_biz ( playerid ) ;
			    case 1: show_collector_atm ( playerid ) ;
			}
			return 1 ;
	    }
	    case d_collector_atm:
		{
			if ( ! response )
			{
			    clear_player_listitem_values ( playerid ) ;
				page_count [ playerid ] =
				page_rows [ playerid ] = 0 ;
				return 1 ;
			}

            if ( listitem == get_player_use_page ( playerid, 0 ) )
            {
                clear_player_use_page ( playerid ) ;
                if ( page_count [ playerid ] == 1 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка банкоматов." ) ;
					page_count [ playerid ] = page_count [ playerid ] ;

					show_collector_atm ( playerid ) ;
					return 1 ;
				}
                page_count [ playerid ] -= 1 ;

                show_collector_atm ( playerid ) ;
				return 1 ;
            }

            else if ( listitem == get_player_use_page ( playerid, 1 ) )
            {
                clear_player_use_page ( playerid ) ;
                if ( ofm_formula ( page_count [ playerid ] ) >= page_rows [ playerid ] )
            	{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка банкоматов." ) ;
					page_count [ playerid ] = page_count [ playerid ] ;

					show_collector_atm ( playerid ) ;
					return 1 ;
				}
                page_count [ playerid ] += 1 ;

                show_collector_atm ( playerid ) ;
				return 1 ;
            }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			set_player_use_listitem ( playerid, select_id ) ;
			
			if ( ! atm_info [ select_id ] [ atm_incass ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Обслуживание выбранного банкомата не требуется!" ), show_collector_atm ( playerid ) ;
			if ( p_info [ playerid ] [ incass_invite ] == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет напарника. Для продолжения найдите напарника!" ) ;
			
			atm_info [ select_id ] [ atm_incass ] = 0 ;
		    SetPlayerRaceCheckpoint ( playerid, 1, atm_info [ select_id ] [ atm_gps ] [ 0 ], atm_info [ select_id ] [ atm_gps ] [ 1 ], atm_info [ select_id ] [ atm_gps ] [ 2 ], 0.0, 0.0, 0.0, 5.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена. Заберите деньги с банкомата!" ) ;
			is_gps_used { playerid } = 12 ;
			
			new _targetid = p_info [ playerid ] [ incass_invite ] ;
			SetPlayerRaceCheckpoint ( _targetid, 1, atm_info [ select_id ] [ atm_gps ] [ 0 ], atm_info [ select_id ] [ atm_gps ] [ 1 ], atm_info [ select_id ] [ atm_gps ] [ 2 ], 0.0, 0.0, 0.0, 5.0 ) ;
			SendClientMessage ( _targetid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена. Заберите деньги с банкомата!" ) ;
			is_gps_used { _targetid } = 12 ;
			
            clear_player_listitem_values ( playerid ) ;
			page_count [ playerid ] = 0 ;
			page_rows [ playerid ] = 0 ;
			return 1 ;
		}
	    case d_collector_biz:
		{
			if ( ! response ) return page_count [ playerid ] = 0 ;

			if ( listitem == get_player_use_page ( playerid, 0 ) )
            {
                clear_player_use_page ( playerid ) ;
                if ( page_count [ playerid ] == 0 )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице списка бизнесов." ) ;
					show_collector_biz_set ( playerid ) ;
					return 1 ;
				}
                page_count [ playerid ] -= 1 ;

                show_collector_biz_set ( playerid ) ;
				return 1 ;
            }

            else if ( listitem == get_player_use_page ( playerid, 1 ) )
            {
                clear_player_use_page ( playerid ) ;
                if ( ofm_formula ( page_count [ playerid ] ) >= b_count )
            	{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице списка бизнесов." ) ;
					show_collector_biz_set ( playerid ) ;
					return 1 ;
				}
                page_count [ playerid ] += 1 ;

                show_collector_biz_set ( playerid ) ;
				return 1 ;
            }
			new select_id = get_player_listitem_values ( playerid, listitem ) ;
			set_player_use_listitem ( playerid, select_id ) ;

   			SetPlayerRaceCheckpoint ( playerid, 1, b_info [ select_id ] [ b_position ] [ 0 ], b_info [ select_id ] [ b_position ] [ 1 ], b_info [ select_id ] [ b_position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 13 ;

            clear_player_listitem_values ( playerid ) ;
   			page_count [ playerid ] = 0 ;
			return 1 ;
		}
	}
	return 0 ;
}

stock inkass_RaceCheckpoint ( playerid )
{
	if ( is_gps_used { playerid } == 12 )
	{
	    if ( GetPlayerState ( playerid ) != PLAYER_STATE_ONFOOT ) return 1 ;
		if ( p_info [ playerid ] [ incass_invite ] != INVALID_PLAYER_ID )
		{
			if ( incass_player_rool [ playerid ] != 2 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не инкассатор-охранник." ) ;
			
			new _targetid = p_info [ playerid ] [ incass_invite ] ;
			
			new veh_id = player_rentcar [ _targetid ],
				_owner_id = veh_info [ veh_id - 1 ] [ v_owner ] ;
			if ( veh_id == INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваш напарник не арендовал транспорт для инкассации!" ) ;
			if ( _owner_id < 1 || _owner_id > MAX_BUSINESS ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не арендовали транспорт для инкассации!" ) ;
			
			new _pay_incass = floatround ( GetPlayerDistanceFromPoint ( playerid, b_info [ _owner_id - 1 ] [ b_position ] [ 0 ], b_info [ _owner_id - 1 ] [ b_position ] [ 1 ], b_info [ _owner_id - 1 ] [ b_position ] [ 2 ] ) / 1000 ) * incass_km_pay ;
			
			p_info [ playerid ] [ salary ] += _pay_incass ;
			p_info [ _targetid ] [ salary ] += _pay_incass ;
			
			DisablePlayerRaceCheckpoint ( playerid ) ;
			is_gps_used { playerid } = 0 ;
			
			DisablePlayerRaceCheckpoint ( _targetid ) ;
			is_gps_used { _targetid } = 0 ;
			
			SetPlayerRaceCheckpoint ( playerid, 1, b_info [ _owner_id - 1 ] [ b_position ] [ 0 ], b_info [ _owner_id - 1 ] [ b_position ] [ 1 ], b_info [ _owner_id - 1 ] [ b_position ] [ 2 ], 0.0, 0.0, 0.0, 5.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена. Отвезите деньги в банк!" ) ;
			is_gps_used { playerid } = 1 ;
			
			SetPlayerRaceCheckpoint ( _targetid, 1, b_info [ _owner_id - 1 ] [ b_position ] [ 0 ], b_info [ _owner_id - 1 ] [ b_position ] [ 1 ], b_info [ _owner_id - 1 ] [ b_position ] [ 2 ], 0.0, 0.0, 0.0, 5.0 ) ;
			SendClientMessage ( _targetid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена. Отвезите деньги в банк!" ) ;
			is_gps_used { _targetid } = 1 ;
			
			give_event_progress ( playerid, THE_INCASSATION, 1 ) ;
			give_event_progress ( _targetid, THE_INCASSATION, 1 ) ;
		}
		else
		{
			DisablePlayerRaceCheckpoint ( playerid ) ;
			is_gps_used { playerid } = 0 ;
		
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет напарника!" ) ;
		}
		return 1 ;
	}
	else if ( is_gps_used { playerid } == 13 )
	{
	    if ( GetPlayerState ( playerid ) != PLAYER_STATE_ONFOOT ) return 1 ;
		if ( p_info [ playerid ] [ incass_invite ] != INVALID_PLAYER_ID )
		{
			if ( incass_player_rool [ playerid ] != 2 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не инкассатор-охранник." ) ;
			
			new _targetid = p_info [ playerid ] [ incass_invite ] ;
			
			new veh_id = player_rentcar [ _targetid ],
				_owner_id = veh_info [ veh_id - 1 ] [ v_owner ] ;
			if ( veh_id == INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваш напарник не арендовал транспорт для инкассации!" ) ;
			if ( _owner_id < 1 || _owner_id > MAX_BUSINESS ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не арендовали транспорт для инкассации!" ) ;
			
			new _pay_incass = floatround ( GetPlayerDistanceFromPoint ( playerid, b_info [ _owner_id - 1 ] [ b_position ] [ 0 ], b_info [ _owner_id - 1 ] [ b_position ] [ 1 ], b_info [ _owner_id - 1 ] [ b_position ] [ 2 ] ) / 1000 ) * incass_km_pay ;
			
			p_info [ playerid ] [ salary ] += _pay_incass + incass_bizz_pay ;
			p_info [ _targetid ] [ salary ] += _pay_incass + incass_bizz_pay ;
			
			SetPlayerRaceCheckpoint ( playerid, 1, b_info [ _owner_id - 1 ] [ b_position ] [ 0 ], b_info [ _owner_id - 1 ] [ b_position ] [ 1 ], b_info [ _owner_id - 1 ] [ b_position ] [ 2 ], 0.0, 0.0, 0.0, 5.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена. Отвезите деньги в банк!" ) ;
			is_gps_used { playerid } = 1 ;
			
			SetPlayerRaceCheckpoint ( _targetid, 1, b_info [ _owner_id - 1 ] [ b_position ] [ 0 ], b_info [ _owner_id - 1 ] [ b_position ] [ 1 ], b_info [ _owner_id - 1 ] [ b_position ] [ 2 ], 0.0, 0.0, 0.0, 5.0 ) ;
			SendClientMessage ( _targetid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена. Отвезите деньги в банк!" ) ;
			is_gps_used { _targetid } = 1 ;
			
			DisablePlayerRaceCheckpoint ( playerid ) ;
			is_gps_used { playerid } = 0 ;
			
			DisablePlayerRaceCheckpoint ( _targetid ) ;
			is_gps_used { _targetid } = 0 ;
			
			new select_id = get_player_use_listitem ( playerid ) ;
			if ( b_info [ select_id ] [ b_money ] < 100000 )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В бизнесе не достаточно средств, чтоб его инкассировать!" ) ;
				return 1 ;
			}

			new _percent_money = ( b_info [ select_id ] [ b_money ] * 10 ) / 100 ;
			b_info [ select_id ] [ b_money ] -= _percent_money ;
			b_info [ select_id ] [ b_incass ] += _percent_money ;
		}
		else
		{
			DisablePlayerRaceCheckpoint ( playerid ) ;
			is_gps_used { playerid } = 0 ;
		
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет напарника!" ) ;
		}
		return 1 ;
	}
	return 0 ;
}

stock show_collector_panel ( playerid )
{
	if ( is_gps_used { playerid } > 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас установлена метка." ) ;
	if ( p_info [ playerid ] [ incass_invite ] == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет напарника." ) ;
    show_dialog ( playerid, d_collector_panel, DIALOG_STYLE_LIST, "{"#cBHD"}Инкассация", "{"#cBL"}1. {"#cWH"}Инкассация бизнесов\n{"#cBL"}2. {"#cWH"}Обслуживание банкоматов", "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_collector_atm ( playerid )
{
    page_count [ playerid ] = 1 ;
	new rows_list = page_count [ playerid ] - 1 ;
	page_rows [ playerid ] = atm_count ;

	global_string [ 0 ] = EOS ;
	new line_string [ 128 ], _atm_string [ 32 ], row_count ;
	for ( new f = rows_list * 10 ; f < rows_list * 10 + 10 ; f ++ )
	{
		if ( f >= atm_count ) break ;

	    set_player_listitem_values ( playerid, f - rows_list * 10, f ) ;
		
		if ( atm_info [ f ] [ atm_incass ] == 1 ) format ( _atm_string, sizeof _atm_string, "{"#cLY"}Доступно" ) ;
		else if ( atm_info [ f ] [ atm_incass ] == 2 ) format ( _atm_string, sizeof _atm_string, "{"#cGN"}Срочное (%d%%)", atm_percent ) ;
		else format ( _atm_string, sizeof _atm_string, "{"#cRD"}Не требуется" ) ;

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}Банкомат {"#cBL"}№%d{"#cWH"}, Обслуживание: %s\n", f + 1, atm_info [ f ] [ atm_id ], _atm_string ) ;
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
	
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog ( playerid, d_collector_atm, DIALOG_STYLE_LIST, "{"#cBHD"}Банкоматы", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_collector_atm_set ( playerid )
{
    new rows_list = page_count [ playerid ] - 1 ;

	global_string [ 0 ] = EOS ;
	new line_string [ 128 ], _atm_string [ 32 ], row_count ;
	for ( new f = rows_list * 10 ; f < rows_list * 10 + 10 ; f ++ )
	{
		if ( f >= atm_count ) break ;

	    set_player_listitem_values ( playerid, f - rows_list * 10, f ) ;

		if ( atm_info [ f ] [ atm_incass ] == 1 ) format ( _atm_string, sizeof _atm_string, "{"#cLY"}Доступно" ) ;
		else if ( atm_info [ f ] [ atm_incass ] == 2 ) format ( _atm_string, sizeof _atm_string, "{"#cGN"}Срочное (%d%%)", atm_percent ) ;
		else format ( _atm_string, sizeof _atm_string, "{"#cRD"}Не требуется" ) ;

		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cWH"}Банкомат {"#cBL"}№%d{"#cWH"}, Обслуживание: %s\n", f + 1, atm_info [ f ] [ atm_id ], _atm_string ) ;
		strcat ( global_string, line_string ) ;
		
		row_count ++ ;
	}
	
	if ( rows_list > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < page_rows [ playerid ] )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}
	
	show_dialog ( playerid, d_collector_atm, DIALOG_STYLE_LIST, "{"#cBHD"}Банкоматы", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_collector_biz ( playerid )
{
    new count_business = 0,
		count_mafia = 0 ;
		
	page_count [ playerid ] = 0 ;

	global_string [ 0 ] = EOS ;
	new line_string [ 128 ], row_count ;
	strcat ( global_string, "{"#cBL"}№. Заработано:\t{"#cBL"}Тип:\t{"#cBL"}Название:\n" ) ;
  	for ( new b = 0 ; b < b_count ; b ++ )
	{
		if ( b_info [ b ] [ b_cash_today ] < 100000 || b_info [ b ] [ b_collector ] > gettime ( ) ) continue ;

		count_mafia ++ ;

  		if ( count_business > 10 ) continue ;
  		
  		set_player_listitem_values ( playerid, count_business, b ) ;
  		
		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cGN"}%s"valute_title_"\t{"#cWH"}%s\t%s\n", count_business + 1, GetPlayerCashValueToSmile ( b_info [ b ] [ b_cash_today ] ), b_types [ b_info [ b ] [ b_type ] ], b_info [ b ] [ b_name ] ) ;
		strcat ( global_string, line_string ) ;
		
  		count_business ++ ;
  		row_count ++ ;
	}
	if ( count_mafia == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нет бизнесов для инкассации!" ), show_collector_panel ( playerid ) ;

	if ( page_count [ playerid ] > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < count_mafia )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}

	format ( line_string, sizeof line_string, "{"#cBHD"}Бизнесы ({"#cWH"}%d {"#cBHD"}из {"#cWH"}%d{"#cBHD"})", count_mafia, b_count ) ;
	show_dialog ( playerid, d_collector_biz, DIALOG_STYLE_TABLIST_HEADERS, line_string, global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_collector_biz_set ( playerid )
{
    global_string [ 0 ] = EOS ;
	new line_string [ 128 ], count_business = 0, count_mafia = 0, row_count ;
	strcat ( global_string, "{"#cBL"}№. Заработано:\t{"#cBL"}Тип:\t{"#cBL"}Название:\n" ) ;
	for ( new b = 0 ; b < b_count ; b ++ )
	{
	    if ( b_info [ b ] [ b_cash_today ] < 100000 || b_info [ b ] [ b_collector ] > gettime ( ) ) continue ;

		count_mafia ++ ;

		if ( count_business > page_count [ playerid ] * 10 ) continue ;
		if ( count_business < ( page_count [ playerid ] * 10 ) - 10 )
		{
			count_business ++ ;
			continue ;
		}
		set_player_listitem_values ( playerid, row_count, b ) ;
		
		format ( line_string, sizeof ( line_string ), "{"#cBL"}%i. {"#cGN"}%s"valute_title_"\t{"#cWH"}%s\t%s\n", count_business + 1, GetPlayerCashValueToSmile ( b_info [ b ] [ b_cash_today ] ), b_types [ b_info [ b ] [ b_type ] ], b_info [ b ] [ b_name ] ) ;
		strcat ( global_string, line_string ) ;
		
		count_business ++ ;
		row_count ++ ;
	}

	if ( page_count [ playerid ] > 0 )
	{
		strcat ( global_string, "{"#cBL"}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < count_mafia )
	{
		strcat ( global_string, "{"#cBL"}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}

	format ( line_string, sizeof line_string, "{"#cBHD"}Бизнесы ({"#cWH"}%d {"#cBHD"}из {"#cWH"}%d{"#cBHD"})", count_mafia, b_count ) ;
	show_dialog ( playerid, d_collector_biz, DIALOG_STYLE_TABLIST_HEADERS, line_string, global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock incass_OnPlayerDeath ( playerid )
{
	if ( p_info [ playerid ] [ incass_invite ] != INVALID_PLAYER_ID )
	{
		new _targetid = p_info [ playerid ] [ incass_invite ] ;
		
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) RemovePlayerAttachedObject ( playerid, 1 ) ;
		SendClientMessage ( _targetid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваш напарник умер. Для продолжения найдите нового напарника!" ) ;
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы умерли. Рабочий день прерван!" ) ;
		
		p_info [ _targetid ] [ incass_invite ] =
		p_info [ playerid ] [ incass_invite ] = INVALID_PLAYER_ID ;
		
		is_gps_used { _targetid } =
		is_gps_used { playerid } = 0 ;
		
		DisablePlayerRaceCheckpoint ( _targetid ) ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		incass_player_rool [ playerid ] = 0 ;
	}
	return 1 ;
}

stock incass_OnPlayerDisconnect ( playerid )
{
	if ( p_info [ playerid ] [ incass_invite ] != INVALID_PLAYER_ID )
	{
		new _targetid = p_info [ playerid ] [ incass_invite ] ;
		
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) RemovePlayerAttachedObject ( playerid, 1 ) ;
		SendClientMessage ( _targetid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваш напарник покинул игру. Для продолжения найдите нового напарника!" ) ;
		
		p_info [ _targetid ] [ incass_invite ] =
		p_info [ playerid ] [ incass_invite ] = INVALID_PLAYER_ID ;
		
		is_gps_used { _targetid } =
		is_gps_used { playerid } = 0 ;
		
		DisablePlayerRaceCheckpoint ( _targetid ) ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		incass_player_rool [ playerid ] = 0 ;
	}
	return 1 ;
}

stock incass_DynamicPickup ( playerid, pickupid )
{
	switch ( pick_info [ pickupid ] [ pick_type ] )
	{
		case pick_type_incass:
		{
			if ( p_info [ playerid ] [ job ] != job_incass ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не работаете инкассатором. Устроиться на работу можно в Мэрии." ) ;
			show_dialog ( playerid, d_job_incass, DIALOG_STYLE_LIST, "{"#cBHD"}Работа в инкассации", "{"#cBL"}1. {"#cWH"}Водитель - охранник\n{"#cBL"}2. {"#cWH"}Инкассатор - охранник\n{"#cGRDialog"}- Закончить работу", "Выбрать", "Отмена");
			return 1 ;
		}
	}
	return 0 ;
}