#define RPC_NOTICE                      0x91

enum
{
    CINFO_ATM_ID = 1,
    CINFO_TREASURE_ID,
    CINFO_ACTOR_ID,
    
    CINFO_TRUCKER_ID,
    
    CINFO_HOSPITAL_ID,
    
    CINFO_DICE_ID,
    CINFO_KAMIKAZE_ID,
    CINFO_BINARY_ID,
    CINFO_ROULETTE_ID,
    CINFO_CARDS_ID,
	CINFO_JACKPOT_ID,
    
    CINFO_TREASURE_CARD,
    CINFO_CAR_MARKET,
    
    CINFO_RENT_FAGGIO,
    CINFO_INFO_QUEST,
    
    CINFO_TUNING_ID,
    CINFO_FAMILY_ID,
    
    CINFO_AUTH_ID,
    CINFO_CASINO_ID,
    
    CINFO_TRASH_ID,
    CINFO_PRISON_ID,
    CINFO_PRISON_ELECTRIC_ID,
    
    CINFO_VALENTINE_ID,
	CINFO_HOUSE_SAFE_ID,
	CINFO_HOUSE_FREEZE_ID,
	CINFO_HOUSE_CELLAR_ID,
	CINFO_HOUSE_HMENU_ID_1,
	CINFO_HOUSE_HMENU_ID_2,
	CINFO_HOUSE_HMENU_ID_3,
	CINFO_CELLAR_ID,
	CINFO_CELLAR_MENU_ID,
	CINFO_FOREST_ID,
	CINFO_EVENTACTOR_ID,
	CINFO_BARRIERS_ID,
	CINFO_DOORS_ID,
	CINFO_HOUSEGARAGE_ID,
	CINFO_CELLARGARAGE_ID,
	CINFO_COIN_ID,
	
	CINFO_GYMBIKE_ID,
	CINFO_GYMTHREAD_ID,
	CINFO_GYMBAR_ID,
	CINFO_GYMDUMBBELLS_ID,
	CINFO_GYM_ID,
	
	CINFO_FRACTION_GUNS_ID,
	CINFO_MARKET_ID,
	CINFO_OTHER_MARKET_ID,
	CINFO_AZS_ID,
	CINFO_GARAGE_AUCTION_ID,
	CINFO_FISHING_ID,
	CINFO_INVENTORY_ID,
	
	CINFO_CAR_OPEN,
	CINFO_CAR_BAGAGE,

	CINFO_FRACTION_TASKS,
	CINFO_FRACTION_INVITE,
	
	CINFO_SANTA_ID,
	CINFO_SNEGURKA_ID,
	CINFO_WINTER_LOTTERY_ID,
	
	CINFO_OTHER_ID
} ;

enum
{
	PICTURE_INFO_SUCESS = 0,
	PICTURE_INFO_ERROR,
	PICTURE_INFO_WARNING
} ;

stock send_check_cinfo ( playerid, notyText [ ], notyType, notyTime, notySubType, notyPictureId, notyBtn1 [ ], notyBtn2 [ ] )
{
	if ( player_device { playerid } != 2 ) return 1 ;

	new BitStream: bitstream = BS_New ( ) ;
	BS_WriteValue (
		bitstream,
		PR_UINT8, PACKET_CUSTOMRPC,
		PR_UINT32, RPC_NOTICE,

		PR_INT8, 0,
		PR_UINT16, strlen ( notyText ),
		PR_STRING, notyText,
		PR_INT8, notyPictureId,
		PR_INT32, notyTime,
		PR_INT32, notySubType,
		PR_UINT16, strlen ( notyBtn1 ),
		PR_STRING, notyBtn1,
		PR_UINT16, strlen ( notyBtn2 ),
		PR_STRING, notyBtn2
	) ;
    PR_SendPacket ( bitstream, playerid ) ;
	BS_Delete ( bitstream ) ;
	return true ;
}

stock clear_check_info ( playerid, notyType )
{
	if ( player_device { playerid } != 2 ) return 1 ;

	new BitStream: bitstream = BS_New ( ) ;
	BS_WriteValue (
		bitstream,
		PR_UINT8, PACKET_CUSTOMRPC,
		PR_UINT32, RPC_NOTICE,

		PR_INT8, 2,
		PR_INT32, notyType
	) ;
    PR_SendPacket ( bitstream, playerid ) ;
	BS_Delete ( bitstream ) ;
	return true ;
}

stock SendHideNotification ( playerid, notyId )
{
	new BitStream: bitstream = BS_New ( ) ;
	BS_WriteValue (
		bitstream,
		PR_UINT8, PACKET_CUSTOMRPC,
		PR_UINT32, RPC_NOTICE,

		PR_INT8, 1,
		PR_INT32, notyId
	) ;
    PR_SendPacket ( bitstream, playerid ) ;
	BS_Delete ( bitstream ) ;
	return true ;
}

stock packetNotices ( playerid, notyId, notyType, bool: status )
{
	if ( notyType != CINFO_HOUSE_HMENU_ID_1 && notyType != CINFO_HOUSE_HMENU_ID_2 && notyType != CINFO_HOUSE_HMENU_ID_3 && notyType != CINFO_CELLAR_MENU_ID &&
		 notyType != CINFO_GYM_ID )
	{
		SendHideNotification ( playerid, notyId ) ;
	}

	switch ( notyType )
	{
		case CINFO_ATM_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_atm )
			{
				new t = area_info [ used_area [ playerid ] ] [ a_item ] ;
								
				SetPVarInt ( playerid, "atm_enter", t + 1 ) ;
				SetPVarInt ( playerid, "p_biz_id", atm_info [ t ] [ atm_status ] ) ;

				deposit_boxes ( playerid ) ;
			}
		}
		case CINFO_TREASURE_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			tr_OnPlayerKeyStateChange ( playerid, KEY_YES, KEY_YES ) ;
		}
		case CINFO_ACTOR_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_quest_actor )
			{
				new j = area_info [ used_area [ playerid ] ] [ a_item ] ;

				new _a_type = quest_actor [ j ] [ actor_type ] ;
				show_area_quest_actor ( playerid, _a_type ) ;
			}
		}
		case CINFO_HOSPITAL_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_hospital )
			{
				new i = area_info [ used_area [ playerid ] ] [ a_item ] ;
				entered_hospital_bed ( playerid, i ) ;
			}
		}
		case CINFO_DICE_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_dice )
				entered_table_dice ( playerid ) ;
		}
		case CINFO_ROULETTE_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_roulette )
				show_window_roulette ( playerid, area_info [ used_area [ playerid ] ] [ a_item ] ) ;
		}
		case CINFO_CARDS_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_blackjack )
			{
				new _table = area_info [ used_area [ playerid ] ] [ a_item ] ;
				set_player_use_listitem ( playerid, _table ) ;
				show_dialog ( playerid, d_bj_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Ставка", "{"#cWH"}Укажите сумму, которую хотите поставить для игры:", "Указать", "Отмена" ) ;
			}
		}
		case CINFO_JACKPOT_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_jackpot )
				ShowPlayerCasinoSlots ( playerid ) ;
		}
		case CINFO_CAR_MARKET:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_car_market )
				show_area_carmarket ( playerid ) ;
		}
		case CINFO_TRASH_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_trash )
				trash_active ( playerid ) ;
		}
		case CINFO_PRISON_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_prison )
				prison_KeyStateChange ( playerid, KEY_CTRL_BACK, KEY_CTRL_BACK ) ;
		}
		case CINFO_PRISON_ELECTRIC_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_prison_electric )
				prison_KeyStateChange ( playerid, KEY_CTRL_BACK, KEY_CTRL_BACK ) ;
		}
		case CINFO_TUNING_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_tuning )
				callcmd::g ( playerid ) ;
		}
		case CINFO_HOUSE_SAFE_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_safe )
			{
				if ( p_info [ playerid ] [ password_status ] ) show_dialog ( playerid, d_safe_pin, DIALOG_STYLE_INPUT, "{"#cBHD"}Код от сейфа", "{ffffff}Введите код от сейфа, чтобы получить доступ к содержимому:", "Принять", "Закрыть" ) ;
				else show_dialog ( playerid, d_safe_pin, DIALOG_STYLE_PASSWORD, "{"#cBHD"}Код от сейфа", "{ffffff}Введите код от сейфа, чтобы получить доступ к содержимому:", "Принять", "Закрыть" ) ;
				return 1 ;
			}
		}
		case CINFO_HOUSE_FREEZE_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_freeze )
			{
				send_check_cinfo ( playerid, "Для заказа продуктов используйте /service", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_WARNING, "", "" ) ;
				show_dialog ( playerid, d_h_freeze, DIALOG_STYLE_LIST, "{"#cBHD"}Холодильник", "Хот-дог ({"#cRD"}-10 прод. {"#cGN"}+20 сытость{"#cWH"})\nБургер ({"#cRD"}-15 прод. {"#cGN"}+30 сытость{"#cWH"})\nПицца ({"#cRD"}-30 прод. {"#cGN"}+60 сытость{"#cWH"})", "Съесть", "Закрыть" ) ;
				return 1 ;
			}
		}
		case CINFO_HOUSE_CELLAR_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_cellar )
				show_house_cellar ( playerid ) ;
		}
		case CINFO_HOUSE_HMENU_ID_1:
		{
			if ( ! status ) SendHideNotification ( playerid, notyId ) ;
			else callcmd::hmenu ( playerid ) ;
		}
		case CINFO_HOUSE_HMENU_ID_2:
		{
			if ( ! status ) SendHideNotification ( playerid, notyId ) ;
			else callcmd::hrent ( playerid ) ;
		}
		case CINFO_HOUSE_HMENU_ID_3:
		{
			if ( ! status ) SendHideNotification ( playerid, notyId ) ;
			else show_family_house ( playerid ) ;
		}
		case CINFO_CELLAR_ID:
		{
			show_cellar_cellar ( playerid ) ;
		}
		case CINFO_CELLAR_MENU_ID:
		{
			if ( ! status ) SendHideNotification ( playerid, notyId ) ;
			else callcmd::cellarmenu ( playerid ) ;
		}
		case CINFO_EVENTACTOR_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] != -1 && area_info [ used_area [ playerid ] ] [ a_type ] == area_type_eventpass )
				show_event_trade ( playerid ) ;
		}
		case CINFO_BARRIERS_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] != -1 && area_info [ used_area [ playerid ] ] [ a_type ] == area_type_barriers )
			{
				new j = area_info [ used_area [ playerid ] ] [ a_item ] ;
				if ( mafia_player ( playerid ) || gang_player ( playerid ) )
				{
					if ( action_type { playerid } != ACTION_ARMY_GATE )
					{
						action_type { playerid } = ACTION_ARMY_GATE ;
						actionShow ( playerid, "Взлом ворот", 100 ) ;
						return 1 ;
					}
				}
				for ( new i = 0 ; i < 4 ; i ++ )
				{
					if ( p_info [ playerid ] [ member ] != barrier_pos [ j ] [ fraction_bar ] [ i ] ) continue ;
					if ( barrier_status [ j ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Барьер уже поднят!" ) ;
							
					barrier_status [ j ] = true ;
					MoveDynamicObject ( barrier_object [ j ],
										barrier_pos [ j ] [ open_bar ] [ 0 ],
										barrier_pos [ j ] [ open_bar ] [ 1 ],
										barrier_pos [ j ] [ open_bar ] [ 2 ],
										barrier_pos [ j ] [ speed_bar ],
										barrier_pos [ j ] [ open_bar ] [ 3 ],
										barrier_pos [ j ] [ open_bar ] [ 4 ],
										barrier_pos [ j ] [ open_bar ] [ 5 ] ) ;

					SetTimerEx("barrier_callback", 10000, 0, "i", j ) ;
					if ( barrier_pos [ j ] [ double_bar_id ] != -1 )
					{
						new _double_bar_id = barrier_pos [ j ] [ double_bar_id ] ;
						MoveDynamicObject ( barrier_object [ _double_bar_id ],
											barrier_pos [ _double_bar_id ] [ open_bar ] [ 0 ],
											barrier_pos [ _double_bar_id ] [ open_bar ] [ 1 ],
											barrier_pos [ _double_bar_id ] [ open_bar ] [ 2 ],
											barrier_pos [ _double_bar_id ] [ speed_bar ],
											barrier_pos [ _double_bar_id ] [ open_bar ] [ 3 ],
											barrier_pos [ _double_bar_id ] [ open_bar ] [ 4 ],
											barrier_pos [ _double_bar_id ] [ open_bar ] [ 5 ] ) ;
						SetTimerEx("barrier_callback", 10000, 0, "i", _double_bar_id ) ;
					}

					SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Барьер опустится в течение {"#cBL"}10 секунд{"#cGRInfo"}." ) ;
				}
			}
		}
		case CINFO_DOORS_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] != -1 && area_info [ used_area [ playerid ] ] [ a_type ] == area_type_doors )
			{
				new _item = area_info [ used_area [ playerid ] ] [ a_item ] ;
				for ( new i = 0 ; i < 4 ; i ++ )
				{
					if ( p_info [ playerid ] [ member ] != door_pos [ _item ] [ fraction_doors ] [ i ] ) continue ;
						
					if ( door_status [ _item ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Дверь уже открыта!" ) ;

					door_status [ _item ] = true ;
					MoveDynamicObject ( door_object [ _item ],
										door_pos [ _item ] [ open_doors ] [ 0 ],
										door_pos [ _item ] [ open_doors ] [ 1 ],
										door_pos [ _item ] [ open_doors ] [ 2 ],
										door_pos [ _item ] [ speed_doors ],
										door_pos [ _item ] [ open_doors ] [ 3 ],
										door_pos [ _item ] [ open_doors ] [ 4 ],
										door_pos [ _item ] [ open_doors ] [ 5 ] ) ;

					SetTimerEx("door_callback", 10000, 0, "i", _item ) ;
					if ( door_pos [ _item ] [ double_doors_id ] != -1 )
					{
						new _double_doors_id = door_pos [ _item ] [ double_doors_id ] ;
						MoveDynamicObject ( door_object [ _double_doors_id ],
											door_pos [ _double_doors_id ] [ open_doors ] [ 0 ],
											door_pos [ _double_doors_id ] [ open_doors ] [ 1 ],
											door_pos [ _double_doors_id ] [ open_doors ] [ 2 ],
											door_pos [ _double_doors_id ] [ speed_doors ],
											door_pos [ _double_doors_id ] [ open_doors ] [ 3 ],
											door_pos [ _double_doors_id ] [ open_doors ] [ 4 ],
											door_pos [ _double_doors_id ] [ open_doors ] [ 5 ] ) ;
						SetTimerEx("door_callback", 10000, 0, "i", _double_doors_id ) ;
					}

					SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Дверь закроется в течении {"#cBL"}10 секунд{"#cGRInfo"}." ) ;
				}
			}
		}
		case CINFO_HOUSEGARAGE_ID:
		{
			if ( ! status ) return 1 ;
			if ( GetPVarInt ( playerid, "house_id" ) == 0 && used_area [ playerid ] != -1 )
			{
				new _a_type = area_info [ used_area [ playerid ] ] [ a_type ] ;
				if ( _a_type == area_type_housegarage )
				{
					new h = area_info [ used_area [ playerid ] ] [ a_item ] ;
					if ( h_info [ h - 1 ] [ h_garage ] == 0 ) return 1 ;
					if ( h_info [ h - 1 ] [ h_v_pos ] [ 0 ] == 0.0 && h_info [ h - 1 ] [ h_v_pos ] [ 1 ] == 0.0 && h_info [ h - 1 ] [ h_v_pos ] [ 2 ] == 0.0 ) return 1 ;
					if ( ! IsPlayerInRangeOfPoint ( playerid, 5.0, h_info [ h - 1 ] [ h_v_pos ] [ 0 ], h_info [ h - 1 ] [ h_v_pos ] [ 1 ], h_info [ h - 1 ] [ h_v_pos ] [ 2 ] ) ) return 1 ;
					if ( h_info [ h - 1 ] [ h_closed ] == 1 && h_info [ h - 1 ] [ h_owner ] != p_info [ playerid ] [ id ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гараж этого дома закрыт." ) ;
					new vehicle_id = GetPlayerVehicleID ( playerid ) ;
					if ( vehicle_id > 0 && veh_info [ vehicle_id - 1 ] [ v_type ] != vehicle_type_player ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Загонять в гараж можно только личный транспорт." ) ;
					if ( get_passenger_count ( playerid ) > 0 )  return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Для начала высадите всех пассажиров из транспорта." ) ;

					new garage_mesto = house_int [ h_info [ h - 1 ] [ h_int ] - 1 ] [ hint_class ] ;

					SetPVarInt ( playerid, "house_id", h ) ;
					send_check_cinfo ( playerid, "Открыть меню дома", 2, -1, CINFO_HOUSE_HMENU_ID_1, PICTURE_INFO_SUCESS, "Меню", "Закрыть" ) ;

					SetVehiclePos ( vehicle_id, house_veh_garage [ garage_mesto ] [ 0 ], house_veh_garage [ garage_mesto ] [ 1 ], house_veh_garage [ garage_mesto ] [ 2 ] ) ;
					SetVehicleZAngle ( vehicle_id, house_veh_garage [ garage_mesto ] [ 3 ] ) ;

					set_interior ( playerid, house_garage_interior [ garage_mesto ] ) ;
					set_world ( playerid, h_info [ h - 1 ] [ h_id ] ) ;
					LinkVehicleToInterior ( vehicle_id, house_garage_interior [ garage_mesto ] );
					SetVehicleVirtualWorld ( vehicle_id, h_info [ h - 1 ] [ h_id ] ) ;
				}
			}
		}
		case CINFO_CELLARGARAGE_ID:
		{
			if ( ! status ) return 1 ;
			if ( GetPVarInt ( playerid, "cellar_id" ) == 0 )
			{
				if ( p_info [ playerid ] [ cellar ] != -1 )
				{
					new h = p_info [ playerid ] [ cellar ] - 1 ;
					if ( cellar_info [ h ] [ cl_pos ] [ 0 ] == 0.0 && cellar_info [ h ] [ cl_pos ] [ 1 ] == 0.0 && cellar_info [ h ] [ cl_pos ] [ 2 ] == 0.0 ) return 1 ;
					if ( ! IsPlayerInRangeOfPoint ( playerid, 5.0, cellar_info [ h ] [ cl_pos ] [ 0 ], cellar_info [ h ] [ cl_pos ] [ 1 ], cellar_info [ h ] [ cl_pos ] [ 2 ] ) ) return 1 ;
					if ( cellar_info [ h ] [ cl_closed ] == 1 && cellar_info [ h ] [ cl_owner ] != p_info [ playerid ] [ id ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Этот гараж закрыт." ) ;
					new vehicle_id = GetPlayerVehicleID ( playerid ) ;
					if ( vehicle_id > 0 && veh_info [ vehicle_id - 1 ] [ v_type ] != vehicle_type_player ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Загонять в гараж можно только личный транспорт." ) ;

					SetPVarInt ( playerid, "cellar_id", h + 1 ) ;
					send_check_cinfo ( playerid, "Открыть меню гаража", 2, -1, CINFO_CELLAR_MENU_ID, PICTURE_INFO_SUCESS, "Меню", "Закрыть" ) ;

					SetVehiclePos ( vehicle_id, cellar_veh_garage [ 0 ], cellar_veh_garage [ 1 ], cellar_veh_garage [ 2 ] ) ;
					SetVehicleZAngle ( vehicle_id,cellar_veh_garage [ 3 ] ) ;

					set_interior ( playerid, cellar_interior ) ;
					set_world ( playerid, cellar_info [ h ] [ cl_id ] ) ;
					LinkVehicleToInterior ( vehicle_id, cellar_interior ) ;
					SetVehicleVirtualWorld ( vehicle_id, cellar_info [ h ] [ cl_id ] ) ;
				}
			}
		}
		case CINFO_COIN_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] != -1 && area_info [ used_area [ playerid ] ] [ a_type ] == area_type_coin )
			{
				if ( p_info [ playerid ] [ hour_played ] < THREE_HOUR_PLAYED ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре." ) ;
				if ( p_t_info [ playerid ] [ p_dialog ] != -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас открыт диалог! Вы не можете сыграть." ) ;
					
				global_string [ 0 ] = EOS ;

				new TotalPla ;
				foreach(new i: streamed_players[playerid])
				{
					set_player_listitem_values ( playerid, TotalPla, i ) ;

					TotalPla ++ ;
					if ( TotalPla == 20 ) break ;
					
					format ( global_string, sizeof global_string, "%s{"#cWH"}%s[%d]\n", global_string, p_info [ i ] [ name ], i ) ;
				}
					
				if ( TotalPla == 0 ) show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Орёл и решка", "{"#cWH"}Нет поблизости игроков, с которыми можно сыграть!", "Принять", "" ) ;
				else show_dialog ( playerid, d_coin, DIALOG_STYLE_LIST, "{"#cBHD"}Орёл и решка", global_string, "Выбрать", "Назад" ) ;
			}
		}
		case CINFO_MARKET_ID:
		{
			if ( ! status ) return 1 ;
			if ( used_area [ playerid ] != -1 && area_info [ used_area [ playerid ] ] [ a_type ] == area_type_market )
				show_open_market ( playerid ) ;
		}
		case CINFO_GYMBIKE_ID:
		{
			if ( ! status ) return 1 ;
			for ( new i = 0 ; i < max_gym_bike ; i ++ )
			{
				if ( IsPlayerInRangeOfPoint ( playerid, 1.5, gym_bike_position [ i ] [ 0 ], gym_bike_position [ i ] [ 1 ], gym_bike_position [ i ] [ 2 ] ) )
				{
					if ( is_gym_training { playerid } == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Сперва начните тренировку." ) ;
					if ( ! p_t_info [ playerid ] [ gym_shell ] )
					{
						if ( SimulatorUse [ GetPVarInt ( playerid, "p_biz_id" ) ] [ i ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Тренажёр занят." ) ;
						SetPlayerPos ( playerid, gym_bike_position [ i ] [ 0 ], gym_bike_position [ i ] [ 1 ], gym_bike_position [ i ] [ 2 ] ) ;
						SetPlayerFacingAngle ( playerid, gym_bike_position [ i ] [ 3 ] ) ;
						ApplyAnimation ( playerid, "GYMNASIUM", "gym_bike_geton", 4, 0, 0, 0, 1, 0 ) ;
						p_t_info [ playerid ] [ gym_shell ] = 1 ;
						p_t_info [ playerid ] [ gym_time ] = gettime ( ) + 4 ;
						SimulatorUse [ GetPVarInt ( playerid, "p_biz_id" ) ] [ i ] = true ;
						SetPVarInt ( playerid, "Simulator_ID", i ) ;
						send_check_cinfo ( playerid, "Нажмите 'действие' для тренировки или 'стоп' для остановки", 2, -1, CINFO_GYM_ID, PICTURE_INFO_SUCESS, "Действие", "Стоп" ) ;
					}
					else gym_stop_used ( playerid, false ) ;
					return 1 ;
				}
			}
		}
		case CINFO_GYMTHREAD_ID:
		{
			if ( ! status ) return 1 ;
			for ( new i = 0 ; i < max_gym_thread ; i ++ )
			{
				if ( IsPlayerInRangeOfPoint ( playerid, 1.5, gym_thread_position [ i ] [ 0 ], gym_thread_position [ i ] [ 1 ], gym_thread_position [ i ] [ 2 ] ) )
				{
					if ( is_gym_training { playerid } == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Сперва начните тренировку." ) ;
					if ( ! p_t_info [ playerid ] [ gym_shell ] )
					{
						if ( SimulatorUse [ GetPVarInt ( playerid, "p_biz_id" ) ] [ i + max_gym_bike ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Тренажёр занят." ) ;
						SetPlayerPos ( playerid, gym_thread_position [ i ] [ 0 ], gym_thread_position [ i ] [ 1 ], gym_thread_position [ i ] [ 2 ] ) ;
						SetPlayerFacingAngle ( playerid, gym_thread_position [ i ] [ 3 ] ) ;
						ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_geton", 4, 0, 0, 0, 1, 0, 1);
						p_t_info [ playerid ] [ gym_shell ] = 2 ;
						p_t_info [ playerid ] [ gym_time ] = gettime ( ) + 4 ;
						SimulatorUse [ GetPVarInt ( playerid, "p_biz_id" ) ] [ i + max_gym_bike ] = true ;
						SetPVarInt ( playerid, "Simulator_ID", i + max_gym_bike ) ;
						send_check_cinfo ( playerid, "Нажмите 'действие' для тренировки или 'стоп' для остановки", 2, -1, CINFO_GYM_ID, PICTURE_INFO_SUCESS, "Действие", "Стоп" ) ;
					}
					else gym_stop_used ( playerid, false ) ;
					return 1 ;
				}
			}
		}
		case CINFO_GYMBAR_ID:
		{
			if ( ! status ) return 1 ;
			for ( new i = 0 ; i < max_gym_bar ; i ++ )
			{
				if ( IsPlayerInRangeOfPoint ( playerid, 1.5, gym_bar_position [ i ] [ 0 ], gym_bar_position [ i ] [ 1 ], gym_bar_position [ i ] [ 2 ] ) )
				{
					if ( is_gym_training { playerid } == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Сперва начните тренировку." ) ;
					if ( ! p_t_info [ playerid ] [ gym_shell ] )
					{
						if ( SimulatorUse [ GetPVarInt ( playerid, "p_biz_id" ) ] [ i + max_gym_bike + max_gym_thread ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Тренажёр занят." ) ;
						SetPlayerPos ( playerid, gym_bar_position [ i ] [ 0 ], gym_bar_position [ i ] [ 1 ], gym_bar_position [ i ] [ 2 ] ) ;
						SetPlayerFacingAngle ( playerid, gym_bar_position [ i ] [ 3 ] ) ;
						ApplyAnimation(playerid, "benchpress", "gym_bp_geton", 4, 0, 0, 0, 1, 0);
						p_t_info [ playerid ] [ gym_shell ] = 3 ;
						p_t_info [ playerid ] [ gym_time ] = gettime ( ) + 4 ;
						SimulatorUse [ GetPVarInt ( playerid, "p_biz_id" ) ] [ i + max_gym_bike + max_gym_thread ] = true ;
						SetPVarInt ( playerid, "Simulator_ID", i + max_gym_bike + max_gym_thread ) ;
						if ( ! IsPlayerAttachedObjectSlotUsed ( playerid, 3 ) ) SetPlayerAttachedObject(playerid, 3, 2913, 6, 0.033000, 0.028000, -0.104999, 5.699995, -1.999999, 0.500062, 1.000000, 1.000000, 1.000000);
						send_check_cinfo ( playerid, "Нажмите 'действие' для тренировки или 'стоп' для остановки", 2, -1, CINFO_GYM_ID, PICTURE_INFO_SUCESS, "Действие", "Стоп" ) ;
					}
					else gym_stop_used ( playerid, false ) ;
					return 1 ;
				}
			}
		}
		case CINFO_GYMDUMBBELLS_ID:
		{
			if ( ! status ) return 1 ;
			for ( new i = 0 ; i < max_gym_dumbbells ; i ++ )
			{
				if ( IsPlayerInRangeOfPoint ( playerid, 1.5, gym_dumbbells_position [ i ] [ 0 ], gym_dumbbells_position [ i ] [ 1 ], gym_dumbbells_position [ i ] [ 2 ] ) )
				{
					if ( is_gym_training { playerid } == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Сперва начните тренировку." ) ;
					if ( ! p_t_info [ playerid ] [ gym_shell ] )
					{
						if ( SimulatorUse [ GetPVarInt ( playerid, "p_biz_id" ) ] [ i + max_gym_bike + max_gym_thread + max_gym_bar ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Тренажёр занят." ) ;
						SetPlayerPos ( playerid, gym_dumbbells_position [ i ] [ 0 ], gym_dumbbells_position [ i ] [ 1 ], gym_dumbbells_position [ i ] [ 2 ] ) ;
						SetPlayerFacingAngle ( playerid, gym_dumbbells_position [ i ] [ 3 ] ) ;
						ApplyAnimation(playerid, "Freeweights", "gym_free_pickup", 4, 0, 0, 0, 1, 0);
						p_t_info [ playerid ] [ gym_shell ] = 4 ;
						p_t_info [ playerid ] [ gym_time ] = gettime ( ) + 4 ;
						SimulatorUse [ GetPVarInt ( playerid, "p_biz_id" ) ] [ i + max_gym_bike + max_gym_thread + max_gym_bar ] = true ;
						SetPVarInt ( playerid, "Simulator_ID", i + max_gym_bike + max_gym_thread + max_gym_bar ) ;
						if ( ! IsPlayerAttachedObjectSlotUsed ( playerid, 3 ) ) SetPlayerAttachedObject(playerid, 3, 2915, 6, 0.083999, 0.000000, -0.039999, -7.199998, -87.000038, -3.199999, 1.000000, 1.000000, 1.000000);
						send_check_cinfo ( playerid, "Нажмите 'действие' для тренировки или 'стоп' для остановки", 2, -1, CINFO_GYM_ID, PICTURE_INFO_SUCESS, "Действие", "Стоп" ) ;
					}
					else gym_stop_used ( playerid, false ) ;
					return 1 ;
				}
			}
		}
		case CINFO_GYM_ID:
		{
			new _gym = p_t_info [ playerid ] [ gym_shell ] ;
			if ( _gym == 1 && p_t_info [ playerid ] [ gym_time ] <= gettime ( ) + 2 )
			{
				if ( status )
				{
					ApplyAnimation ( playerid, "GYMNASIUM", "gym_bike_pedal", 4, 0, 0, 0, 1, 0 ) ;
					p_t_info [ playerid ] [ gym_time ] = gettime ( ) + 2 ;
					if ( p_t_info [ playerid ] [ gym_click ] >= 100 )
					{
						if ( p_info [ playerid ] [ stats ] [ 1 ] < 100 )
						{
							GivePlayerStats ( playerid, 1, 1 ) ;
							GameTextForPlayer ( playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~w~ STAMINA ~g~+1", 3000, 3 ) ;
						}
						p_t_info [ playerid ] [ gym_click ] = 0 ;
					}
					else p_t_info [ playerid ] [ gym_click ] ++ ;
				}
				else
				{
					SendHideNotification ( playerid, notyId ) ;
					gym_stop_used ( playerid, false ) ;
				}
				return 1 ;
			}
			else if ( _gym == 2 && p_t_info [ playerid ] [ gym_time ] <= gettime ( ) + 2 )
			{
				if ( status )
				{
					ApplyAnimation ( playerid, "GYMNASIUM", "gym_tread_jog", 4, 0, 0, 0, 1, 0 ) ;
					p_t_info [ playerid ] [ gym_time ] = gettime ( ) + 2 ;
					if ( p_t_info [ playerid ] [ gym_click ] >= 100 )
					{
						if ( p_info [ playerid ] [ stats ] [ 1 ] < 100 )
						{
							GivePlayerStats ( playerid, 1, 1 ) ;
							GameTextForPlayer ( playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~w~ STAMINA ~g~+1", 3000, 3 ) ;
						}
						p_t_info [ playerid ] [ gym_click ] = 0 ;
					}
					else p_t_info [ playerid ] [ gym_click ] ++ ;
				}
				else
				{
					SendHideNotification ( playerid, notyId ) ;
					gym_stop_used ( playerid, false ) ;
				}
				return 1 ;
			}
			else if ( _gym == 3 && p_t_info [ playerid ] [ gym_time ] <= gettime ( ) + 2 )
			{
				if ( status )
				{
					ApplyAnimation ( playerid, "benchpress", "gym_bp_up_smooth", 4, 0, 0, 0, 1, 0 ) ;
					p_t_info [ playerid ] [ gym_time ] = gettime ( ) + 2 ;
					if ( p_t_info [ playerid ] [ gym_click ] >= 100 )
					{
						if ( p_info [ playerid ] [ stats ] [ 2 ] < 100 )
						{
							GivePlayerStats ( playerid, 2, 1 ) ;
							GameTextForPlayer ( playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~w~ FORCE ~g~+1", 3000, 3 ) ;
						}
						p_t_info [ playerid ] [ gym_click ] = 0 ;
					}
					else p_t_info [ playerid ] [ gym_click ] ++ ;
					if ( ! IsPlayerAttachedObjectSlotUsed ( playerid, 3 ) ) SetPlayerAttachedObject ( playerid, 3, 2913, 6, 0.033000, 0.028000, -0.104999, 5.699995, -1.999999, 0.500062, 1.000000, 1.000000, 1.000000);
				}
				else
				{
					SendHideNotification ( playerid, notyId ) ;
					gym_stop_used ( playerid, false ) ;
				}
				return 1 ;
			}
			else if ( _gym == 4 && p_t_info [ playerid ] [ gym_time ] <= gettime ( ) + 2 )
			{
				if ( status )
				{
					ApplyAnimation ( playerid, "Freeweights", "gym_free_down", 4, 0, 0, 0, 1, 0 ) ;
					p_t_info [ playerid ] [ gym_time ] = gettime ( ) + 2 ;
					if ( p_t_info [ playerid ] [ gym_click ] >= 100 )
					{
						if ( p_info [ playerid ] [ stats ] [ 2 ] < 100 )
						{
							GivePlayerStats ( playerid, 2, 1 ) ;
							GameTextForPlayer ( playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~w~ FORCE ~g~+1", 3000, 3 ) ;
						}
						p_t_info [ playerid ] [ gym_click ] = 0 ;
					}
					else p_t_info [ playerid ] [ gym_click ] ++ ;
					if ( ! IsPlayerAttachedObjectSlotUsed ( playerid, 3 ) ) SetPlayerAttachedObject ( playerid, 3, 2915, 6, 0.083999, 0.000000, -0.039999, -7.199998, -87.000038, -3.199999, 1.000000, 1.000000, 1.000000);
				}
				else
				{
					SendHideNotification ( playerid, notyId ) ;
					gym_stop_used ( playerid, false ) ;
				}
				return 1 ;
			}
		}
		case CINFO_FRACTION_TASKS:
		{
			if ( ! status ) return true ;
			showFractionTasks ( playerid ) ;
		}
		case CINFO_FRACTION_INVITE:
		{
			if ( ! status ) return true ;
			startAutoInviteQuestion ( playerid ) ;
		}
		case CINFO_FRACTION_GUNS_ID:
		{
			new _v_id = GetPlayerVehicleID ( playerid ) ;
			if ( _v_id == 0 )
			{
				clear_check_info ( playerid, CINFO_FRACTION_GUNS_ID ) ;
				return 1 ;
			}
			
			if ( status )
			{
				if ( veh_info [ _v_id - 1 ] [ v_model ] == 548 )
				{
					if ( veh_info [ _v_id - 1 ] [ v_cargo_object ] [ 0 ] != INVALID_OBJECT_ID )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже подцепили контейнер." ) ;
					for ( new i = 0 ; i < MAX_POSITION_SUBMARINE * 2 ; i ++ )
					{
						if ( army_container_object [ i ] == 0 ) continue ;
						if ( IsPlayerInRangeOfPoint ( playerid, 25, army_container_pos [ i ] [ 0 ], army_container_pos [ i ] [ 1 ], army_container_pos [ i ] [ 2 ] ) )
						{
							new Float:z_position ;
							GetPlayerPos ( playerid, z_position, z_position, z_position ) ;
							if ( z_position < 25.2 )return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы слишком близко к земле, наберите немного высоты." ) ;
							DestroyDynamicObject ( army_container_object [ i ] ) ;
							army_container_object [ i ] = INVALID_OBJECT_ID ;
											
							new tmpobjid = CreateDynamicObject(18886,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
							SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -8355712);
							AttachDynamicObjectToVehicle(tmpobjid, _v_id, 0.000, 1.421, -3.070, 0.000, 0.000, 0.000);
							veh_info [ _v_id - 1 ] [ v_cargo_object ] [ 0 ] = tmpobjid ;
											
							tmpobjid = CreateDynamicObject(19087,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
							SetDynamicObjectMaterial(tmpobjid, 0, 14584, "ab_abbatoir01", "cj_sheetmetal", -8355712);
							AttachDynamicObjectToVehicle(tmpobjid, _v_id, 0.000, 1.441, -1.670, 0.000, 0.000, 0.000);
							veh_info [ _v_id - 1 ] [ v_cargo_object ] [ 1 ] = tmpobjid ;
											
							tmpobjid = CreateDynamicObject(2935,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
							SetDynamicObjectMaterial(tmpobjid, 2, -1, "none", "none", -8355712);
							AttachDynamicObjectToVehicle(tmpobjid, _v_id, 0.000, 1.341, -5.550, 0.000, 0.000, 0.000);
							veh_info [ _v_id - 1 ] [ v_cargo_object ] [ 2 ] = tmpobjid ;

							SendClientMessage ( playerid, col_gray, !"* Контейнер прицеплен к вертолёту, доставьте его на склад армии." ) ;
						}
					}
				}
				else if ( veh_info [ _v_id - 1 ] [ v_model ] == 433 || veh_info [ _v_id - 1 ] [ v_model ] == 482 || veh_info [ _v_id - 1 ] [ v_model ] == 416 ) callcmd::loadgun ( playerid ) ;
			}
			else
			{
				new _f_id = -1 ;
				if ( IsPlayerInRangeOfPoint ( playerid, 35.0, army_unloading [ 7 ] [ 0 ], army_unloading [ 7 ] [ 1 ], army_unloading [ 7 ] [ 2 ] ) ) _f_id = 7 ;
				else if ( IsPlayerInRangeOfPoint ( playerid, 35.0, army_unloading [ 8 ] [ 0 ], army_unloading [ 8 ] [ 1 ], army_unloading [ 8 ] [ 2 ] ) ) _f_id = 8 ;
					
				if ( veh_info  [ _v_id - 1 ] [ v_model ] == 548 && _f_id != -1 )
				{
					static const _box_id [ ] = { 164, 165, 166, 167, 168, 169, 170 } ;
					for ( new i = 0 ; i < sizeof _box_id ; i ++ )
					{
						new USERS_INVENTORY_STRUCT: inventoryStruct [ _:INV_STRUCTURE_MAX ] ;
						inventoryStruct [ _:INV_ITEM ] = _box_id [ i ] ;
						inventoryStruct [ _:INV_ITEM_COUNT ] = 10 ;
						inventoryStruct [ _:INV_ITEM_TYPE ] = 0 ;
						inventoryStruct [ _:INV_ITEM_REGION ] = "" ;
						inventoryStruct [ _:INV_ITEM_PLATE ] = "" ;
						inventoryStruct [ _:INV_ITEM_PLATE_TYPE ] = NUMBERPLATE_TYPE_NONE ;
						inventoryStruct [ _:INV_ITEM_GIVE_DATE ] = 0 ;
						inventoryStruct [ _:INV_ITEM_ID ] = 0 ;
						inventoryStruct [ _:INV_ITEM_DATE ] = -1 ;
						give_fraction_item ( _f_id + 1, -1, inventoryStruct ) ;
					}
						
					static const _str [ ] = "%s разгрузил вертолёт с боеприпасами на складе %s" ;
					new scm_string [ sizeof _str + 24 + 32 ] ;
					format ( scm_string, sizeof scm_string, _str, p_info [ playerid ] [ name ], f_info [ _f_id ] [ f_name ] ) ;
					write_fraction ( playerid, p_info [ playerid ] [ member ], TYPE_LOG_OBWYAK, scm_string ) ;
					
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно разгрузили вертолёт." ) ;
					update_army_text ( ) ;
					
					if ( army_player ( playerid ) )
					{
						format ( scm_string, sizeof scm_string, "Вы получили премию в размере {"#cGN"}%d"valute_title_"", WorkSalary [ 2 ] ) ;
						SendClientMessage ( playerid, col_lblue, scm_string ) ;

						give_money(playerid, WorkSalary [ 2 ]);
						insert_money_log ( playerid, INVALID_PLAYER_ID, WorkSalary [ 2 ], "премия [2]" ) ;
					}

					if ( veh_info [ _v_id - 1 ] [ v_cargo_object ] [ 0 ] != INVALID_OBJECT_ID )
					{
						for ( new j = 0 ; j < 3 ; j ++ )
						{
							DestroyDynamicObject ( veh_info [ _v_id - 1 ] [ v_cargo_object ] [ j ] ) ;
							veh_info [ _v_id - 1 ] [ v_cargo_object ] [ j ] = INVALID_OBJECT_ID ;
						}
					}
				}
				else if ( veh_info  [ _v_id - 1 ] [ v_model ] == 433 || veh_info [ _v_id - 1 ] [ v_model ] == 482 || veh_info [ _v_id - 1 ] [ v_model ] == 416 ) callcmd::unloadgun ( playerid ) ;
				else if ( _f_id == -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы должны находиться возле разгрузочной зоны." ) ;
				return 1 ;
			}
		}
	}

	return 1 ;
}

stock noty_OnPlayerDeath ( playerid )
{
	if ( player_device { playerid } != 2 ) return 1 ;
	
	new BitStream: bitstream = BS_New ( ) ;
	BS_WriteValue (
		bitstream,
		PR_UINT8, PACKET_CUSTOMRPC,
		PR_UINT32, RPC_NOTICE,

		PR_INT8, 3
	) ;
    PR_SendPacket ( bitstream, playerid ) ;
	BS_Delete ( bitstream ) ;
	return 1 ;
}