#define pick_type_delivery 220
#define pick_type_pizza 221

#define KM_DELIVERY_PAY 500
#define DELIVERY_PAY 2500

new Float: pick_start_delivery_pos [ 3 ] = { 2310.2084, -1926.4329, 21.9588 } ;
new pick_start_delivery ;

new Float: pick_hand_pizza_pos [ 3 ] = { 2309.9973, -1930.7174, 21.9555 } ;
new pick_hand_pizza ;

static bool: player_pizza [ MAX_PLAYERS ] ;
static player_pizza_markered [ MAX_PLAYERS ] ;

stock clear_player_delivery ( playerid )
{
	player_pizza [ playerid ] = false ;
	player_pizza_markered [ playerid ] = 0 ;
	return 1 ;
}

stock delivery_OnGameModeInit ( )
{
	pick_start_delivery = CreateDynamicPickup ( 1275, 23, pick_start_delivery_pos [ 0 ], pick_start_delivery_pos [ 1 ], pick_start_delivery_pos [ 2 ], 0, 0, -1 ) ;
	pick_info [ pick_start_delivery ] [ pick_type ] = pick_type_delivery ;
	
	pick_hand_pizza = CreateDynamicPickup ( 1582, 23, pick_hand_pizza_pos [ 0 ], pick_hand_pizza_pos [ 1 ], pick_hand_pizza_pos [ 2 ], 0, 0, -1 ) ;
	pick_info [ pick_hand_pizza ] [ pick_type ] = pick_type_pizza ;
	
	CreateDynamic3DTextLabel ( "** Пицца для доставки **", col_header_3d, pick_hand_pizza_pos [ 0 ], pick_hand_pizza_pos [ 1 ], pick_hand_pizza_pos [ 2 ] + 1.0, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, 0, 0 );
	return 1 ;
}

stock delivery_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_job_delivery:
		{
			if ( ! response ) return 1 ;
			if ( p_info [ playerid ] [ timejob ] != job_eat_delivery )
			{
				p_info [ playerid ] [ timejob ] = job_eat_delivery ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно трудоустроились доставщиком." ) ;
				SendClientMessage ( playerid, col_gray, !"* Возьмите скутер и пиццу и отправляйтесь на доставку." ) ;
				
				if ( p_info [ playerid ] [ gender ] )
				{
					if ( random ( 2 ) == 1 ) SetPlayerSkin ( playerid, 151 ) ;
					else SetPlayerSkin ( playerid, 152 ) ;
				}
				else
				{
					if ( random ( 2 ) == 1 ) SetPlayerSkin ( playerid, 155 ) ;
					else SetPlayerSkin ( playerid, 167 ) ;
				}

				show_payment ( playerid ) ;
				clear_player_delivery ( playerid ) ;
			}
			else
			{
				fraction_duty ( playerid ) ;
				
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы завершили рабочую смену." ) ;
				new __t_string [ 72 ] ;
				format ( __t_string, sizeof ( __t_string ), "{"#cGInfo"}* {"#cWH"}Заработано: {"#cGN"}%d"valute_title_"", p_info [ playerid ] [ salary ] ) ;
				SendClientMessage ( playerid, col_white, __t_string ) ;

				give_money ( playerid, p_info [ playerid ] [ salary ] ) ;
				
				p_info [ playerid ] [ salary ] = 0 ;
				p_info [ playerid ] [ timejob ] = job_none ;

				hide_payment ( playerid ) ;
				
				DisablePlayerCheckpoint ( playerid ) ;
				is_checkpoint_used { playerid } = 0 ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock delivery_DynamicPickup ( playerid, pickupid )
{
	switch ( pick_info [ pickupid ] [ pick_type ] )
	{
		case pick_type_delivery:
		{
			if ( p_info [ playerid ] [ drive_lic ] == 0 )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет водительского удостоверения." ) ;
			if ( p_info [ playerid ] [ timejob ] != job_eat_delivery && p_info [ playerid ] [ timejob ] != 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже трудоустроены." ) ;
			if ( p_info [ playerid ] [ timejob ] != job_eat_delivery ) show_dialog ( playerid, d_job_delivery, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Работа доставщика", "{ffffff}Вы хотите устроиться на работу доставщика?", "Да", "Нет" ) ;
			else show_dialog ( playerid, d_job_delivery, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Работа доставщика", "{ffffff}Вы действительно хотите закончить рабочий день?", "Да", "Нет" ) ;
			return 1 ;
		}
		case pick_type_pizza:
		{
			if ( p_info [ playerid ] [ timejob ] != job_eat_delivery ) return 1 ;
			if ( player_pizza [ playerid ] )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже взяли заказ." ) ;
				markered_delivery_house ( playerid ) ;
				return 1 ;
			}
			
			player_pizza [ playerid ] = true ;
			//if ( IsPlayerAttachedObjectSlotUsed ( playerid, 4 ) ) RemovePlayerAttachedObject ( playerid, 4 ) ;
			//SetPlayerAttachedObject ( playerid, 4, 2814, 1, 0.0, 0.5, -0.0, 90.0, 90.0, 0.0, 1.0, 1.0, 1.0 ) ;
			//ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы взяли пиццу, теперь доставьте её." ) ;
			markered_delivery_house ( playerid ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock delivery_EnterVehicle ( playerid )
{
	if ( player_pizza [ playerid ] )
	{
		//if ( IsPlayerAttachedObjectSlotUsed ( playerid, 4 ) ) RemovePlayerAttachedObject ( playerid, 4 ) ;
		//ClearAnimations ( playerid ) ;
	}
	return 1 ;
}

stock delivery_ExitVehicle ( playerid )
{
	if ( player_pizza [ playerid ] )
	{
		//if ( IsPlayerAttachedObjectSlotUsed ( playerid, 4 ) ) RemovePlayerAttachedObject ( playerid, 4 ) ;
		//SetPlayerAttachedObject ( playerid, 4, 2814, 1, 0.0, 0.5, -0.0, 90.0, 90.0, 0.0, 1.0, 1.0, 1.0 ) ;
		//ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
	}
	return 1 ;
}

stock markered_delivery_house ( playerid )
{
	if ( player_pizza_markered [ playerid ] )
	{
		new s_house_id = player_pizza_markered [ playerid ] - 1 ;
        if ( h_info [ s_house_id ] [ h_podezd ] != -1 )
	    {
	    	new _padik_id = h_info [ s_house_id ] [ h_podezd ] - 1 ;
			SetPlayerRaceCheckpoint ( playerid, 1, podezd_info [ _padik_id ] [ p_pos ] [ 0 ], podezd_info [ _padik_id ] [ p_pos ] [ 1 ], podezd_info [ _padik_id ] [ p_pos ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
		}
		else SetPlayerRaceCheckpoint ( playerid, 1, h_info [ s_house_id ] [ h_pos ] [ 0 ], h_info [ s_house_id ] [ h_pos ] [ 1 ], h_info [ s_house_id ] [ h_pos ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Ваш дом обозначен на карте красной меткой." ) ;
		is_gps_used { playerid } = 17 ;
		return 1 ;
	}
	
	player_pizza_markered [ playerid ] = random ( house_count ) + 1 ;
	
	new s_house_id = player_pizza_markered [ playerid ] - 1 ;
    if ( h_info [ s_house_id ] [ h_podezd ] != -1 )
	{
	    new _padik_id = h_info [ s_house_id ] [ h_podezd ] - 1 ;
		SetPlayerRaceCheckpoint ( playerid, 1, podezd_info [ _padik_id ] [ p_pos ] [ 0 ], podezd_info [ _padik_id ] [ p_pos ] [ 1 ], podezd_info [ _padik_id ] [ p_pos ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
	}
	else SetPlayerRaceCheckpoint ( playerid, 1, h_info [ s_house_id ] [ h_pos ] [ 0 ], h_info [ s_house_id ] [ h_pos ] [ 1 ], h_info [ s_house_id ] [ h_pos ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Ваш дом обозначен на карте красной меткой." ) ;
	is_gps_used { playerid } = 17 ;
	
	return 1 ;
}

stock delivery_RaceCheckpoint ( playerid )
{
	if ( is_gps_used { playerid } == 17 )
	{
		if ( ! player_pizza [ playerid ] ) return 1 ;
		
		player_pizza [ playerid ] = false ;
		player_pizza_markered [ playerid ] = 0 ;
		
		new _prev_payment = floatround ( GetPlayerDistanceFromPoint ( playerid, pick_start_delivery_pos [ 0 ], pick_start_delivery_pos [ 1 ], pick_start_delivery_pos [ 2 ] ) / 1000 ) * KM_DELIVERY_PAY ;
		p_info [ playerid ] [ salary ] += _prev_payment + DELIVERY_PAY ;
		give_event_progress ( playerid, THE_DELIVERY, _prev_payment + DELIVERY_PAY ) ;
		
		new __t_string [ 72 ] ;
		format ( __t_string, sizeof ( __t_string ), "{"#cGInfo"}* {"#cWH"}Заработано: {"#cGN"}%d"valute_title_"", p_info [ playerid ] [ salary ] ) ;
		SendClientMessage ( playerid, col_white, __t_string ) ;
		
		SetPlayerRaceCheckpoint ( playerid, 1, pick_hand_pizza_pos [ 0 ], pick_hand_pizza_pos [ 1 ], pick_hand_pizza_pos [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
		is_gps_used { playerid } = 1 ;
		
		//if ( IsPlayerAttachedObjectSlotUsed ( playerid, 4 ) ) RemovePlayerAttachedObject ( playerid, 4 ) ;
		//ClearAnimations ( playerid ) ;
		
		checking_quest_progress ( playerid, 6, 1, quest_line_start ) ;
		return 1 ;
	}
	return 0 ;
}