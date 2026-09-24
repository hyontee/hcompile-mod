const ID_RPC = 20 ;

const RPC_ModePlayer = 206 ;
const RPC_ModeSettings = 207 ;
const RPC_ModeBinder = 208 ;
const RPC_CustomHash = 209 ;
const RPC_CInfo = 210 ;
const RPC_BattlePass = 211 ;
const RPC_VoiceChat = 212 ;
const RPC_HudManager = 213 ;
const RPC_PlayAudioStreams = 214 ;
const RPC_Donate = 215 ;
const RPC_Trade = 216 ;
const RPC_Inventory = 217 ;
const RPC_Tuning = 218 ;
const RPC_Family = 219 ;
const RPC_Finger = 220 ;
const RPC_Apple = 221 ;
const RPC_Binary = 222 ;
const RPC_Roulette = 223 ;
const RPC_CustomSpawn = 224 ;
const RPC_DbdCancel = 225 ;

enum E_AUDIO_STRUCT
{
	box_position,			// UINT8
	urlLen, 				// UINT8
	urls[255]				// char
};

enum E_TRADE_STRUCT
{
	playerMoney, 			// UINT16
	buttonClick, 			// UINT16
	playerItem, 			// UINT16
	traderItem, 			// UINT16
	mesLen, 				// UINT8
	mesText[100]			// char
};

enum E_INV_STRUCT
{
	playerInfo, 			// UINT16
	buttonClick, 			// UINT16
	playerItem, 			// UINT16
	acsItem 				// UINT16
};

enum E_TUNE_STRUCT
{
	tunePrice, 				// UINT16
	tuneTypeId, 			// UINT16
	tuneSubId, 				// UINT16
	tuneId, 				// UINT16
	Rgb, 					// UINT8
	rGb, 					// UINT8
	rgB, 					// UINT8
	rgbA, 					// UINT8
	bool: Status 			// BOOL
};

enum E_FAMILY_STRUCT
{
	typeSelect,				// UINT16
	typeSelectId,			// UINT32
	typeIncId,				// UINT16
	typeSettings,			// UINT16
	typeLen, 				// UINT8
	typeText[100]			// char
};

enum E_FINGER_STRUCT
{
	fingerId, 				// UINT8
	fingerResult, 			// UINT8
	fingerLen, 				// UINT8
	fingerText[128]			// char
};

IRawPacket:ID_RPC(playerid, BitStream:bs)
{
    new rpcid, numberOfBitsOfData ;

    BS_ReadValue(bs,
		PR_IGNORE_BITS, 8, // packet id
		PR_UINT8, rpcid,
		PR_CUINT32, numberOfBitsOfData
    );
    
	if ( rpcid == RPC_ModePlayer )
    {
        new i_bit ;

        BS_ReadValue(bs,
            PR_UINT8, i_bit
        );

		if ( i_bit == 1 )
		{
			if ( p_t_info [ playerid ] [ p_logged ] == false || player_loaded { playerid } == 0 ) return 1 ;
			show_player_extraaction ( playerid ) ;
		}
    }
    else if ( rpcid == RPC_ModeSettings )
    {
        new i_bit ;

        BS_ReadValue(bs,
            PR_UINT8, i_bit
        );

		if ( i_bit == 1 ) 
		{
			if ( p_t_info [ playerid ] [ p_logged ] == false || player_loaded { playerid } == 0 ) return 1 ;
			show_playersettings ( playerid ) ;
		}
    }
	else if ( rpcid == RPC_ModeBinder )
    {
        new i_bit ;

        BS_ReadValue(bs,
            PR_UINT8, i_bit
        );

		if ( i_bit == 1 )
		{
			if ( p_t_info [ playerid ] [ p_logged ] == false || player_loaded { playerid } == 0 ) return 1 ; 
			show_playerbinder ( playerid, 0 ) ;
		}
    }
	else if ( rpcid == RPC_CustomHash )
    {
        new i_bit ;

        BS_ReadValue(bs,
            PR_UINT32, i_bit
        );

		player_checking_hash [ playerid ] += i_bit ;
    }
	else if ( rpcid == RPC_CInfo )
    {
        new i_bit ;

        BS_ReadValue(bs,
            PR_UINT8, i_bit
        );
		
		for ( new q = 0 ; q < 4 ; q ++ )
		{
			if ( p_t_info [ playerid ] [ ci_send ] [ q ] != i_bit ) continue ;
			
			p_t_info [ playerid ] [ ci_time ] [ q ] =
			p_t_info [ playerid ] [ ci_type ] [ q ] =
			p_t_info [ playerid ] [ ci_send ] [ q ] = -1 ;
			break ;
		}

		if ( i_bit == CINFO_ATM_ID )
		{
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_atm )
		    {
				new t = area_info [ used_area [ playerid ] ] [ a_item ] ;
	    					
	    		SetPVarInt ( playerid, "atm_enter", t + 1 ) ;
			    SetPVarInt ( playerid, "p_biz_id", atm_info [ t ] [ atm_status ] ) ;

				deposit_boxes ( playerid ) ;
				return 1 ;
			}
		}
		else if ( i_bit == CINFO_TREASURE_ID )
		{
			if ( used_area [ playerid ] == -1 ) return 1 ;
			tr_OnPlayerKeyStateChange ( playerid, KEY_YES, KEY_YES ) ;
			return 1 ;
		}
		else if ( i_bit == CINFO_ACTOR_ID )
		{
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_quest_actor )
			{
		        new j = area_info [ used_area [ playerid ] ] [ a_item ] ;

				new _a_type = quest_actor [ j ] [ actor_type ] ;
				show_area_quest_actor ( playerid, _a_type ) ;
				return 1 ;
			}
		}
		else if ( i_bit == CINFO_EVENTPASS_ID )
		{
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_eventpass )
			{
				show_event_trade ( playerid ) ;
				return 1 ;
			}
		}
		else if ( i_bit == CINFO_LOAD_TR_ID )
		{
			trucker_OnPlayerKeyStateChange ( playerid, KEY_CROUCH, KEY_CROUCH ) ;
			return 1 ;
		}
		else if ( i_bit == CINFO_LOAD_OTHER_ID )
		{
			trucker_OnPlayerKeyStateChange ( playerid, KEY_YES, KEY_YES ) ;
			return 1 ;
		}
		else if ( i_bit == CINFO_HOSPITAL_ID )
		{
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_hospital )
			{
			    new i = area_info [ used_area [ playerid ] ] [ a_item ] ;
					    
				entered_hospital_bed ( playerid, i ) ;
				return 1 ;
			}
		}
		else if ( i_bit == CINFO_DICE_ID )
		{
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_dice )
			{
			    entered_table_dice ( playerid ) ;
				return 1 ;
			}
		}
		else if ( i_bit == CINFO_KAMIKAZE_ID )
		{
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_kamikaze )
			{
			    if ( GetPVarInt ( playerid, "cm_used" ) == 0 ) cm_status ( playerid, true ) ;
			    return 1 ;
			}
		}
		else if ( i_bit == CINFO_BINARY_ID )
		{
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_binary )
			{
				SetBinaryShow ( playerid ) ;
			    return 1 ;
			}
		}
		else if ( i_bit == CINFO_ROULETTE_ID )
		{
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_roulette )
			{
				SetRouletteShow ( playerid ) ;
			    return 1 ;
			}
		}
		else if ( i_bit == CINFO_CARDS_ID )
		{
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_cards )
			{
			    if ( cards_OnPlayerKeyStateChange ( playerid ) ) return 1 ;
			    return 1 ;
			}
		}
		else if ( i_bit == CINFO_CAR_MARKET )
		{
			if ( used_area [ playerid ] == -1 ) return 1 ;
			if ( area_info [ used_area [ playerid ] ] [ a_type ] == area_type_car_market )
			{
			    show_area_carmarket ( playerid ) ;
			    return 1 ;
			}
		}
    }
	else if ( rpcid == RPC_BattlePass )
	{
		new i_bit, i_info, i_pos_bp ;

        BS_ReadValue(bs,
            PR_UINT16, i_bit,
            PR_UINT16, i_info,
            PR_UINT16, i_pos_bp
        );
		
		if ( i_bit == 0 )
		{
			if ( i_info == 1 ) return show_donate_epass ( playerid, 1 ) ;
			else if ( i_info == 2 ) return show_donate_epass ( playerid, 2 ) ;
			else if ( i_info == 3 ) return show_donate_epass ( playerid, 3 ) ;
			else if ( i_info == 4 ) return show_donate_epass ( playerid, 4 ) ;
			else if ( i_info == 5 ) return show_gps_event_actor ( playerid ) ;
			else if ( i_info == 101 ) return show_upgrade_eventpass ( playerid, 1 ) ;
			else if ( i_info == 102 ) return show_upgrade_eventpass ( playerid, 2 ) ;
			else if ( i_info == 103 ) return show_upgrade_eventpass ( playerid, 3 ) ;
			else if ( i_info == 104 ) return show_upgrade_eventpass ( playerid, 4 ) ;
			else if ( i_info == 200 )
			{
				SetBattleShop ( playerid ) ;
				return 1 ;
			}
			else if ( i_info == 201 )
			{
				SetBattleQuest ( playerid ) ;
				return 1 ;
			}
			else if ( i_info == 202 )
			{
				SetBattleStat ( playerid ) ;
				return 1 ;
			}
		}
		else if ( i_bit == 200 )
		{
			SetBattlePrise ( playerid, i_info ) ;
		}
		else if ( i_bit == 555 )
		{
			SetBattlePrise ( playerid, i_info ) ;
		}
		else
		{
			if ( gPlayerPriseActivated [ playerid ] <= gPlayerBattlePassLVL { playerid } )
			{
				if ( i_bit == 1 ) give_eventpass_prise ( playerid ) ;
				else if ( i_bit >= 5 && i_bit <= 7 ) set_battle_info ( playerid, i_bit, i_info, i_pos_bp ) ;
					
				gPlayerPriseActivated [ playerid ] += 1 ;
				update_int_sql ( playerid, "u_epriseuse", gPlayerPriseActivated [ playerid ] ) ;
			}
			
			if ( i_bit >= 10 ) set_battle_info ( playerid, i_bit, i_info, i_pos_bp ) ;
		}
	}
	else if ( rpcid == RPC_VoiceChat )
	{
		new i_bit, i_chat ;

        BS_ReadValue(bs,
            PR_UINT8, i_bit,
            PR_UINT8, i_chat
        );
		
		p_info [ playerid ] [ voice ] = i_bit ;
		p_info [ playerid ] [ chat_status ] = i_chat ;
	}
	else if ( rpcid == RPC_HudManager )
	{
		new i_bit, i_info ;

        BS_ReadValue(bs,
            PR_UINT8, i_bit,
            PR_UINT8, i_info
        );
		
		p_info [ playerid ] [ hud_id ] = i_bit ;
		p_info [ playerid ] [ info_buttons ] = i_info ;
		
		if ( p_t_info [ playerid ] [ p_logged ] == true )
		{
			if ( player_device { playerid } == 2 && p_info [ playerid ] [ hud_id ] ) SendCheckHud ( playerid ) ;
		}
	}
	else if ( rpcid == RPC_PlayAudioStreams )
	{
        new dataAudio[E_AUDIO_STRUCT];
		BS_ReadValue(
			bs,
			PR_UINT8, dataAudio[box_position],
			PR_UINT8, dataAudio[urlLen],
			PR_STRING, dataAudio[urls], dataAudio[urlLen]
		);
		
		new _s_type = g_aStreamSources [ playerid ] [ eStreamType ] ;
		if ( dataAudio[box_position] == 0 )
		{
			if ( _s_type == 1 )
			{
				#if defined m_streamsource
					DestroyStreamOther ( playerid ) ;
					
					new Float: _fx, Float: _fy, Float: _fz ;
					GetPlayerPos ( playerid, _fx, _fy, _fz ) ;
					CreateStreamOther ( playerid, 1, playerid, _fx, _fy, _fz, 30.0, GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ), dataAudio[urls] ) ;
				#endif
			}
			else if ( _s_type == 2 )
			{
				if ( GetPlayerVehicleID ( playerid ) == 0 ) return true ;
				if ( veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_sound ] < 1 ) return true ;
				
				#if defined m_streamsource
					DestroyStreamOther ( playerid ) ;
					
					new Float: _fx, Float: _fy, Float: _fz ;
					GetPlayerPos ( playerid, _fx, _fy, _fz ) ;
					CreateStreamOther ( playerid, 2, GetPlayerVehicleID ( playerid ), _fx, _fy, _fz, 30.0, GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ), dataAudio[urls] ) ;
				#endif
			}
		}
		else if ( dataAudio[box_position] == 3 )
		{
			if ( p_info [ playerid ] [ level ] < 8 ) return 1 ;
			
			if ( boombox_player [ playerid ] [ b_status ] )
			{
				DestroyRecorder ( playerid ) ;
				
				#if defined m_streamsource
					g_aStreamSources [ playerid ] [ eStreamType ] = 1 ;
					g_aStreamSources [ playerid ] [ eStreamID ] = playerid ;
					g_aStreamSources [ playerid ] [ eStreamIsFree ] = 0 ;
				#endif
	
				SetAttachedBoomBox ( playerid ) ;
			}
			else
			{
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 4 ) ) RemovePlayerAttachedObject ( playerid, 4 ) ;
				
				#if defined m_streamsource
					DestroyStreamOther ( playerid ) ;
				#endif
				
				SetAddRecorder ( playerid ) ;
			}
			return 1 ;
		}

		else if ( dataAudio[box_position] == 4 )
		{
			if ( boombox_player [ playerid ] [ b_status ] )
			{
				DestroyRecorder ( playerid ) ;
			}
			else
			{
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 4 ) ) RemovePlayerAttachedObject ( playerid, 4 ) ;
				
				#if defined m_streamsource
					DestroyStreamOther ( playerid ) ;
				#endif
			}
			return 1 ;
		}
		
		if ( boombox_player [ playerid ] [ b_status ] )
		{
			foreach(new i: streamed_players[playerid])
			{
				if ( IsPlayerInDynamicArea ( i, boombox_player [ playerid ] [ b_area ] ) )
				{
					if ( player_device { i } == 2 )
					{
						#if defined m_streamsource
							DestroyStreamSource ( i, playerid ) ;
							
							CreateStreamSource ( i, playerid, boombox_player [ playerid ] [ b_pos ] [ 0 ], boombox_player [ playerid ] [ b_pos ] [ 1 ], boombox_player [ playerid ] [ b_pos ] [ 2 ], 30.0, GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ), dataAudio[urls] ) ;
						#else
							StopStream ( i ) ;
							PlayStream(i, dataAudio[urls], boombox_player [ playerid ] [ b_pos ] [ 0 ],
																boombox_player [ playerid ] [ b_pos ] [ 1 ],
																boombox_player [ playerid ] [ b_pos ] [ 2 ], 30.0, 1);
						#endif
						continue ;
					}
						
					StopStream ( i ) ;
					PlayStream(i, dataAudio[urls], boombox_player [ playerid ] [ b_pos ] [ 0 ],
													boombox_player [ playerid ] [ b_pos ] [ 1 ],
													boombox_player [ playerid ] [ b_pos ] [ 2 ], 30.0, 1);
				}
			}
			if ( player_device { playerid } == 2 )
			{
				#if defined m_streamsource
					DestroyStreamSource ( playerid, playerid ) ;
							
					CreateStreamSource ( playerid, playerid, boombox_player [ playerid ] [ b_pos ] [ 0 ], boombox_player [ playerid ] [ b_pos ] [ 1 ], boombox_player [ playerid ] [ b_pos ] [ 2 ], 30.0, GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ), dataAudio[urls] ) ;
				#else
					StopStream ( playerid ) ;
					PlayStream ( playerid, dataAudio[urls], boombox_player [ playerid ] [ b_pos ] [ 0 ],
															boombox_player [ playerid ] [ b_pos ] [ 1 ],
															boombox_player [ playerid ] [ b_pos ] [ 2 ], 30.0, 1 ) ;					
				#endif
			}
			else
			{
				StopStream ( playerid ) ;
				PlayStream ( playerid, dataAudio[urls], boombox_player [ playerid ] [ b_pos ] [ 0 ],
															boombox_player [ playerid ] [ b_pos ] [ 1 ],
															boombox_player [ playerid ] [ b_pos ] [ 2 ], 30.0, 1 ) ;
			}
			SetPVarString ( playerid, "BBStation", dataAudio[urls] ) ;
		}
	}
	else if ( rpcid == RPC_Donate )
	{
		new _hierarchy, _internal, _confirmed ;

        BS_ReadValue(bs,
            PR_UINT16, _hierarchy,
            PR_UINT16, _internal,
			PR_UINT32, _confirmed
        );
		
		#if defined m_donate
			show_donate_accept ( playerid, _hierarchy, _internal, _confirmed ) ;
		#endif
	}
	else if ( rpcid == RPC_Trade )
	{
        new dataTrade[E_TRADE_STRUCT];
		BS_ReadValue(
			bs,
			PR_INT16, dataTrade[playerMoney],
			PR_INT16, dataTrade[buttonClick],
			PR_INT16, dataTrade[playerItem],
			PR_INT16, dataTrade[traderItem],
			PR_UINT8, dataTrade[mesLen],
			PR_STRING, dataTrade[mesText], dataTrade[mesLen]
		);
		
		show_packet_trade ( playerid, dataTrade[playerMoney], dataTrade[buttonClick], dataTrade[playerItem], dataTrade[traderItem], dataTrade[mesText]);
	}
	else if ( rpcid == RPC_Inventory )
	{
        new dataInv[E_INV_STRUCT];
		BS_ReadValue(
			bs,
			PR_INT16, dataInv[playerInfo],
			PR_INT16, dataInv[buttonClick],
			PR_INT16, dataInv[playerItem],
			PR_INT16, dataInv[acsItem]
		);
		
		show_packet_inventory ( playerid, dataInv[playerInfo], dataInv[buttonClick], dataInv[playerItem], dataInv[acsItem]);
	}
	else if ( rpcid == RPC_Tuning )
	{
        new dataTune[E_TUNE_STRUCT];
		BS_ReadValue(
			bs,
			PR_INT16, dataTune[tunePrice],
			PR_INT16, dataTune[tuneTypeId],
			PR_INT16, dataTune[tuneSubId],
			PR_INT16, dataTune[tuneId],
			PR_INT8, dataTune[Rgb],
			PR_INT8, dataTune[rGb],
			PR_INT8, dataTune[rgB],
			PR_INT8, dataTune[rgbA],
			PR_BOOL, dataTune[Status]
		);
		
		show_packet_tuning ( playerid, dataTune [ tunePrice ], dataTune [ tuneTypeId ], dataTune [ tuneSubId ], dataTune [ tuneId ], dataTune [ Rgb ], dataTune [ rGb ], dataTune [ rgB ], dataTune [ rgbA ], dataTune [ Status ] ) ;
	}
	else if ( rpcid == RPC_Family )
	{
        new dataFamily[E_FAMILY_STRUCT];
		BS_ReadValue(
			bs,
			PR_INT16, dataFamily[typeSelect],
			PR_INT32, dataFamily[typeSelectId],
			PR_INT16, dataFamily[typeIncId],
			PR_INT16, dataFamily[typeSettings],
			PR_UINT8, dataFamily[typeLen],
			PR_STRING, dataFamily[typeText], dataFamily[typeLen]
		);
		
		show_packet_family ( playerid, dataFamily [ typeSelect ], dataFamily [ typeSelectId ], dataFamily [ typeIncId ], dataFamily [ typeSettings ], dataFamily [ typeText ] ) ;
	}
	else if ( rpcid == RPC_Finger )
	{
		new dataFinger [ E_FINGER_STRUCT ] ;
		BS_ReadValue(
			bs,
			PR_UINT8, dataFinger [ fingerId ],
			PR_UINT8, dataFinger [ fingerResult ],
			PR_UINT8, dataFinger [ fingerLen ],
			PR_STRING, dataFinger [ fingerText ], dataFinger [ fingerLen ]
		);
		
		show_packet_finger ( playerid, dataFinger [ fingerId ], dataFinger [ fingerResult ], dataFinger [ fingerText ] ) ;
	}
	else if ( rpcid == RPC_Apple )
	{
		new _id, _result ;
	
		BS_ReadValue(
			bs,
			PR_UINT8, _id,
			PR_UINT32, _result
		);
		
		show_packet_apple ( playerid, _id, _result ) ;
	}
	else if ( rpcid == RPC_Binary )
	{
		new _id1, bool: _status, _result ;
	
		BS_ReadValue(
			bs,
			PR_UINT8, _id1,
			PR_UINT32, _result,
			PR_BOOL, _status
		);
		
		show_packet_binary ( playerid, _id1, _status, _result ) ;
	}
	else if ( rpcid == RPC_Roulette )
	{
		new current_bid, select_type, select_number ;
	
		BS_ReadValue(
			bs,
			PR_UINT32, current_bid,
			PR_UINT8, select_type,
			PR_UINT8, select_number
		);
		
		show_packet_roulette ( playerid, current_bid, select_type, select_number ) ;
	}
	else if ( rpcid == RPC_CustomSpawn )
	{
		new current_pos ;
	
		BS_ReadValue(
			bs,
			PR_UINT8, current_pos
		);
		
		p_info [ playerid ] [ spawnchange ] = current_pos ;
		update_int_sql ( playerid, "u_spawnchange", current_pos ) ;
	    
		show_player_hud ( playerid ) ;
	}
	else if ( rpcid == RPC_DbdCancel )
	{
		new current_id ;
	
		BS_ReadValue(
			bs,
			PR_UINT8, current_id
		);
		
		dbd_OnPlayerDisconnect ( playerid ) ;
	}
	else if ( rpcid == RPC_RadialMenu )
	{
		new current_id ;
	
		BS_ReadValue(
			bs,
			PR_UINT8, current_id
		);
		
		use_radial_menu ( playerid, current_id ) ;
	}

	return true ;
}

#define RPC_WorldPlayerAdd  			32
#define RPC_ScrCreateObject 			44
#define RPC_ScrSetPlayerAttachedObject 	113
#define RPC_SET_PLAYER_SKIN 			153
#define RPC_WORLDVEHICLE_ADD 			164

enum E_PLAYER_STRUCT
{
	e_usPlayerID,
	e_bTeam,
	e_uiSkin,
	e_pfPosX,
	e_pfPosY,
	e_pfPosZ,
	e_pfRot,
	e_uiColor,
	e_bFighting,
	e_boolVisible
} ;
static playerData [ E_PLAYER_STRUCT ] ;

#define MAX_SKIN_MODELS_REPLACE 32
new skin_replace_model [ MAX_SKIN_MODELS_REPLACE ] [ 3 ] = 
{
	{ 18000, 110, 312 },
	{ 18001, 110, 313 },
	{ 18002, 110, 314 },
	{ 18003, 110, 315 },
	{ 18004, 110, 316 },
	{ 18005, 110, 317 },
	{ 18006, 110, 318 },
	{ 18007, 110, 319 },
	{ 18008, 110, 320 },
	{ 18009, 110, 321 },
	{ 18010, 110, 322 },
	{ 18011, 110, 323 },
	{ 18012, 110, 324 },
	{ 18013, 110, 325 },
	{ 18014, 110, 326 },
	{ 18015, 110, 327 },
	{ 18016, 110, 328 },
	{ 18017, 110, 329 },
	{ 18018, 110, 330 },
	{ 18019, 110, 331 },
	{ 18020, 110, 332 },
	{ 18021, 110, 333 },
	{ 18022, 110, 334 },
	{ 18023, 110, 335 },
	{ 18024, 110, 336 },
	{ 18025, 110, 337 },
	{ 18026, 110, 338 },
	{ 18027, 110, 339 },
	{ 18028, 110, 340 },
	{ 18029, 110, 341 },
	{ 18030, 110, 342 },
	{ 18031, 110, 343 }
} ;

stock getReplacableSkinModel ( playerid )
{
	new _skin_model = 0 ;
	if ( p_info [ playerid ] [ custom_skin ] != 0 ) _skin_model = p_info [ playerid ] [ custom_skin ] ;
	else 
	{
		if ( changed_player_skin [ playerid ] == false ) return _skin_model ;
		else _skin_model = p_info [ playerid ] [ skin ] ;
	}
    return _skin_model ;
}

stock getNewSkinModel ( playerid )
{
	new _skin_model = 0 ;
	if ( p_info [ playerid ] [ custom_skin ] != 0 ) _skin_model = p_info [ playerid ] [ custom_skin ] ;
	else _skin_model = p_info [ playerid ] [ skin ] ;
    return _skin_model ;
}

stock ProcessReplaceSkin ( playerid, BitStream:bs )
{
    new player, skinid;
	BS_ReadValue(
		bs,
 		PR_UINT32, player,
		PR_UINT32, skinid);

	new custom_id = getReplacableSkinModel ( player ) ;
	if ( custom_id > 311 )
	{
		/*if ( player_checking_hash [ playerid ] < 39 && custom_id >= 312 ) return 0 ;
		if ( player_checking_hash [ playerid ] < 42 && custom_id >= 4508 ) return 0 ;
		if ( player_checking_hash [ playerid ] < 45 && custom_id >= 4521 ) return 0 ;
		if ( player_checking_hash [ playerid ] < 48 && custom_id >= 4545 ) return 0 ;*/
		
		new BitStream:bitstream = BS_New();
		
		BS_WriteValue(
			bitstream,
			PR_UINT32, player, 	//id
			PR_UINT32, custom_id);
		PR_SendRPC(bitstream, playerid, RPC_SET_PLAYER_SKIN, PR_HIGH_PRIORITY, PR_RELIABLE_SEQUENCED);
		BS_Delete(bitstream);
		return 1 ;
	}
	return 0 ;
}

stock ProcessReplaceSkinAdd ( playerid, BitStream:bs )
{
    static clearPlayerData [ E_PLAYER_STRUCT ] ;
	playerData = clearPlayerData ;

	BS_ReadValue(
 		bs,
   		PR_INT16, playerData [ e_usPlayerID ],
		PR_UINT8, playerData [ e_bTeam ],
		PR_UINT32, playerData [ e_uiSkin ],
		PR_FLOAT, playerData [ e_pfPosX ],
		PR_FLOAT, playerData [ e_pfPosY ],
		PR_FLOAT, playerData [ e_pfPosZ ],
		PR_FLOAT, playerData [ e_pfRot ],
		PR_UINT32, playerData [ e_uiColor ],
		PR_UINT8, playerData [ e_bFighting ],
		PR_BOOL, playerData [ e_boolVisible ] ) ;

	new custom_id = getReplacableSkinModel ( playerData [ e_usPlayerID ] ) ;
	if ( custom_id > 311 )
	{
		/*if ( player_checking_hash [ playerid ] < 39 && custom_id >= 312 ) return 0 ;
		if ( player_checking_hash [ playerid ] < 42 && custom_id >= 4508 ) return 0 ;
		if ( player_checking_hash [ playerid ] < 45 && custom_id >= 4521 ) return 0 ;
		if ( player_checking_hash [ playerid ] < 48 && custom_id >= 4545 ) return 0 ;*/
		
		new BitStream:bitstream = BS_New();

		BS_WriteValue(
			bitstream,
			PR_INT16, playerData [ e_usPlayerID ],
			PR_UINT8, playerData [ e_bTeam ],
			PR_UINT32, custom_id,
			PR_FLOAT, playerData [ e_pfPosX ],
			PR_FLOAT, playerData [ e_pfPosY ],
			PR_FLOAT, playerData [ e_pfPosZ ],
			PR_FLOAT, playerData [ e_pfRot ],
			PR_UINT32, playerData [ e_uiColor ],
			PR_UINT8, playerData [ e_bFighting ],
			PR_BOOL, playerData [ e_boolVisible ] ) ;
	
		PR_SendRPC(bitstream, playerid, RPC_WorldPlayerAdd, PR_HIGH_PRIORITY, PR_RELIABLE_SEQUENCED);
		BS_Delete(bitstream);
		return 1 ;
	}
	return 0 ;
}

enum E_VEHICLE_STRUCT
{
	e_vVehicleID, 			// INT16
	e_vModelID,				// UINT32
	Float:e_posX,
	Float:e_posY,
	Float:e_posZ,
	Float:e_rot,
	e_vColor1,
	e_vColor2,
	Float:e_vHealth,
	e_vInterior,
	e_vDoorDamageStatus,
	e_vPanelDamageStatus,
	e_vByteLightDamageStatus,
	e_vByteTimeDamageStatus,
	e_vByteAddSiren
} ;
static vehicleData [ E_VEHICLE_STRUCT ] ;

#define MAX_VEH_MODELS_REPLACE 15
new veh_replace_model [ MAX_VEH_MODELS_REPLACE ] [ 3 ] = 
{
	{ 17780, 451, 612 },
	{ 17781, 579, 613 },
	{ 17782, 451, 614 },
	{ 17783, 451, 615 },
	{ 17784, 579, 616 },
	{ 17785, 550, 617 },
	{ 17786, 451, 618 },
	{ 17787, 451, 619 },
	{ 17788, 451, 620 },
	{ 17789, 451, 621 },
	{ 17790, 451, 622 },
	{ 17791, 451, 623 },
	{ 17792, 451, 624 },
	{ 17793, 451, 625 },
	{ 17794, 451, 626 }
} ;

stock GetVehicleModelEx ( vehicleid, ex_model = 0 )
{
	new _v_model = 0 ;
	if ( ex_model != 0 && vehicleid == -1 )
	{
		if ( ex_model < 400 || ex_model > 611 )
		{
			for ( new i = 0 ; i < MAX_VEH_MODELS_REPLACE ; i ++ )
			{
				if ( ex_model != veh_replace_model [ i ] [ 0 ] ) continue ;
				
				_v_model = veh_replace_model [ i ] [ 2 ] ;
				break ;
			}
		}
		
		if ( _v_model == 0 ) _v_model = ex_model ;
	}
	else
	{
		if ( vehicleid == 0 || vehicleid == INVALID_VEHICLE_ID ) return 0 ;
		if ( veh_info [ vehicleid - 1 ] [ v_model_custom ] != 0 )
		{
			new _v_c_model = veh_info [ vehicleid - 1 ] [ v_model_custom ] ;
			for ( new i = 0 ; i < MAX_VEH_MODELS_REPLACE ; i ++ )
			{
				if ( _v_c_model != veh_replace_model [ i ] [ 0 ] ) continue ;
				
				_v_model = veh_replace_model [ i ] [ 2 ] ;
				break ;
			}
		}
		else _v_model = veh_info [ vehicleid - 1 ] [ v_model ] ;
	}
	
	return _v_model ;
}
#define GetVehicleModel GetVehicleModelEx

stock GetVehicleNameEx ( vehicleid, ex_model = 0 )
{
	new _vehicle_name [ 32 ], _v_model = 0 ;
	
	if ( vehicleid == 0 || vehicleid == INVALID_VEHICLE_ID )
	{
		format ( _vehicle_name, sizeof _vehicle_name, "None" ) ;
		return _vehicle_name ;
	}
	
	if ( ex_model != 0 && vehicleid == -1 )
	{
		if ( ex_model < 400 || ex_model > 611 )
		{
			for ( new i = 0 ; i < MAX_VEH_MODELS_REPLACE ; i ++ )
			{
				if ( ex_model != veh_replace_model [ i ] [ 0 ] ) continue ;
				
				_v_model = veh_replace_model [ i ] [ 2 ] ;
				break ;
			}
		}
		else _v_model = ex_model ;
	}
	else
	{
		if ( veh_info [ vehicleid - 1 ] [ v_model_custom ] != 0 )
		{
			new _v_c_model = veh_info [ vehicleid - 1 ] [ v_model_custom ] ;
			for ( new i = 0 ; i < MAX_VEH_MODELS_REPLACE ; i ++ )
			{
				if ( _v_c_model != veh_replace_model [ i ] [ 0 ] ) continue ;
				
				_v_model = veh_replace_model [ i ] [ 2 ] ;
				break ;
			}
		}
		else _v_model = veh_info [ vehicleid - 1 ] [ v_model ] ;
	}
	
	format ( _vehicle_name, sizeof _vehicle_name, "%s", vehicle_name [ _v_model - 400 ] ) ;
	return _vehicle_name ;
}

stock getReplacableVehicleModel ( vehicleid )
{
	new _v_model = 0 ;
	if ( veh_info [ vehicleid - 1 ] [ v_model_custom ] != 0 ) _v_model = veh_info [ vehicleid - 1 ] [ v_model_custom ] ;
	else _v_model = veh_info [ vehicleid - 1 ] [ v_model ] ;
    return _v_model ;
}

stock ProcessReplaceVehicle ( playerid, BitStream:bs )
{
    static clearVehicleData [ E_VEHICLE_STRUCT ] ;
	vehicleData = clearVehicleData ;
	new modSlots [ 14 ] ;
	new bytePaintJob ;
	new color1, color2 ;

	BS_ReadValue(
 		bs,
   		PR_INT16, vehicleData [ e_vVehicleID ],
		PR_UINT32, vehicleData [ e_vModelID ],
		PR_FLOAT, vehicleData [ e_posX ],
		PR_FLOAT, vehicleData [ e_posY ],
		PR_FLOAT, vehicleData [ e_posZ ],
		PR_FLOAT, vehicleData [ e_rot ],
		PR_UINT8, vehicleData [ e_vColor1 ],
		PR_UINT8, vehicleData [ e_vColor2 ],
		PR_FLOAT, vehicleData [ e_vHealth ],
		PR_UINT8, vehicleData [ e_vInterior ],
		PR_UINT32, vehicleData [ e_vDoorDamageStatus ],
		PR_UINT32, vehicleData [ e_vPanelDamageStatus ],
		PR_UINT8, vehicleData [ e_vByteLightDamageStatus ],
		PR_UINT8, vehicleData [ e_vByteTimeDamageStatus ],
		PR_UINT8, vehicleData [ e_vByteAddSiren ] ) ;
		
	for(new i = 0; i < 14; i++)
	{
 		BS_ReadValue(bs, PR_UINT8, modSlots[i]);
	}
	BS_ReadValue(bs, PR_UINT8, bytePaintJob);
	BS_ReadValue(bs, PR_UINT32, color1, PR_UINT32, color2);

    new custom_id = getReplacableVehicleModel ( vehicleData [ e_vVehicleID ] ) ;
	if ( custom_id != 0 && ( custom_id < 400 || custom_id > 611 ) )
	{
		/*if ( player_checking_hash [ playerid ] < 30 && custom_id >= 3294 ) return 0 ;
		if ( player_checking_hash [ playerid ] < 42 && custom_id >= 3298 ) return 0 ;
		if ( player_checking_hash [ playerid ] < 45 && custom_id >= 3306 ) return 0 ;
		if ( player_checking_hash [ playerid ] < 48 && custom_id >= 3310 ) return 0 ;*/
		
		new BitStream:bitstream = BS_New();

		BS_WriteValue(
			bitstream,
			PR_INT16, vehicleData [ e_vVehicleID ],
			PR_UINT32, custom_id,
			PR_FLOAT, vehicleData [ e_posX ],
			PR_FLOAT, vehicleData [ e_posY ],
			PR_FLOAT, vehicleData [ e_posZ ],
			PR_FLOAT, vehicleData [ e_rot ],
			PR_UINT8, vehicleData [ e_vColor1 ],
			PR_UINT8, vehicleData [ e_vColor2 ],
			PR_FLOAT, vehicleData [ e_vHealth ],
			PR_UINT8, vehicleData [ e_vInterior ],
			PR_UINT32, vehicleData [ e_vDoorDamageStatus ],
			PR_UINT32, vehicleData [ e_vPanelDamageStatus ],
			PR_UINT8, vehicleData [ e_vByteLightDamageStatus ],
			PR_UINT8, vehicleData [ e_vByteTimeDamageStatus ],
			PR_UINT8, vehicleData [ e_vByteAddSiren ] ) ;

		for(new i = 0; i < 14; i++)
		{
			BS_WriteValue(bitstream, PR_UINT8, modSlots[i]);
		}
		BS_WriteValue(bitstream, PR_UINT8, bytePaintJob);
		BS_WriteValue(bitstream, PR_UINT32, color1, PR_UINT32, color2);

		PR_SendRPC(bitstream, playerid, RPC_WORLDVEHICLE_ADD, PR_HIGH_PRIORITY, PR_RELIABLE_SEQUENCED);
		BS_Delete(bitstream);
		return 1 ;
	}
	return 0 ;
}

enum E_OBJECT_STRUCT
{
	e_wObjectID, 			// INT16
	e_ModelID,				// UINT32
	Float:e_objectX,		// FLOAT
	Float:e_objectY,		// FLOAT
	Float:e_objectZ,		// FLOAT
	Float:e_rotx,			// FLOAT
	Float:e_roty,			// FLOAT
	Float:e_rotz,			// FLOAT
	float:e_DrawDistance,	// FLOAT
	e_NoCameraCol,			// UINT8
	e_attachedObject,		// UINT16
	e_attachedVehicle,		// UINT16
	float:e_AttachOffsetX,	// FLOAT
	float:e_AttachOffsetY,	// FLOAT
	float:e_AttachOffsetZ,	// FLOAT
	float:e_AttachRotX,		// FLOAT
	float:e_AttachRotY,		// FLOAT
	float:e_AttachRotZ,		// FLOAT
	e_SyncRotation 			// UINT8
} ;
static dataObject [ E_OBJECT_STRUCT ] ;

stock IsShouldSendCreateObject ( playerid, BitStream:bs )
{
	static clearDataObject [ E_OBJECT_STRUCT ] ;
	dataObject = clearDataObject ;
	BS_ReadValue(
		bs,
 		PR_INT16, dataObject[e_wObjectID],
  		PR_UINT32, dataObject[e_ModelID],
   		PR_FLOAT, dataObject[e_objectX],
    	PR_FLOAT, dataObject[e_objectY],
    	PR_FLOAT, dataObject[e_objectZ],
    	PR_FLOAT, dataObject[e_rotx],
    	PR_FLOAT, dataObject[e_roty],
    	PR_FLOAT, dataObject[e_rotz],
    	PR_FLOAT, dataObject[e_DrawDistance],
    	PR_UINT8, dataObject[e_NoCameraCol],
    	PR_UINT16, dataObject[e_attachedObject],
    	PR_UINT16, dataObject[e_attachedVehicle],
    	PR_FLOAT, dataObject[e_AttachOffsetX],
    	PR_FLOAT, dataObject[e_AttachOffsetY],
    	PR_FLOAT, dataObject[e_AttachOffsetZ],
    	PR_FLOAT, dataObject[e_AttachRotX],
    	PR_FLOAT, dataObject[e_AttachRotY],
    	PR_FLOAT, dataObject[e_AttachRotZ],
    	PR_UINT8, dataObject[e_SyncRotation]
		);
	
	/*if ( player_checking_hash [ playerid ] < 27 )
	{
		if ( dataObject[e_ModelID] >= 12080 && dataObject[e_ModelID] <= 12099 || dataObject[e_ModelID] >= 12600 && dataObject[e_ModelID] <= 12633 ) return 0 ;
	}
	
	if ( player_checking_hash [ playerid ] < 39 )
	{	
		if ( dataObject[e_ModelID] >= 12635 && dataObject[e_ModelID] <= 12672 ) return 0 ;
	}
	else if ( player_checking_hash [ playerid ] >= 39 )
	{
		if ( dataObject[e_ModelID] == 2935 && ( airdrop_object [ 0 ] == dataObject[e_wObjectID] || family_airdrop_object [ 0 ] == dataObject[e_wObjectID] ) )
		{
			new BitStream:bitstream = BS_New();

			BS_WriteValue(
				bitstream,
				PR_INT16, dataObject[e_wObjectID],
				PR_UINT32, 12741,
				PR_FLOAT, dataObject[e_objectX],
				PR_FLOAT, dataObject[e_objectY],
				PR_FLOAT, dataObject[e_objectZ],
				PR_FLOAT, dataObject[e_rotx],
				PR_FLOAT, dataObject[e_roty],
				PR_FLOAT, dataObject[e_rotz],
				PR_FLOAT, dataObject[e_DrawDistance],
				PR_UINT8, dataObject[e_NoCameraCol],
				PR_UINT16, dataObject[e_attachedObject],
				PR_UINT16, dataObject[e_attachedVehicle],
				PR_FLOAT, dataObject[e_AttachOffsetX],
				PR_FLOAT, dataObject[e_AttachOffsetY],
				PR_FLOAT, dataObject[e_AttachOffsetZ],
				PR_FLOAT, dataObject[e_AttachRotX],
				PR_FLOAT, dataObject[e_AttachRotY],
				PR_FLOAT, dataObject[e_AttachRotZ],
				PR_UINT8, dataObject[e_SyncRotation]
			);

			PR_SendRPC(bitstream, playerid, RPC_ScrCreateObject, PR_HIGH_PRIORITY, PR_RELIABLE_SEQUENCED);
			BS_Delete(bitstream);
			return 0 ;
		}
		else if ( dataObject[e_ModelID] == 18849 && ( airdrop_object [ 1 ] == dataObject[e_wObjectID] || family_airdrop_object [ 1 ] == dataObject[e_wObjectID] ) )
		{
			new BitStream:bitstream = BS_New();

			BS_WriteValue(
				bitstream,
				PR_INT16, dataObject[e_wObjectID],
				PR_UINT32, 18631,
				PR_FLOAT, dataObject[e_objectX],
				PR_FLOAT, dataObject[e_objectY],
				PR_FLOAT, dataObject[e_objectZ],
				PR_FLOAT, dataObject[e_rotx],
				PR_FLOAT, dataObject[e_roty],
				PR_FLOAT, dataObject[e_rotz],
				PR_FLOAT, dataObject[e_DrawDistance],
				PR_UINT8, dataObject[e_NoCameraCol],
				PR_UINT16, dataObject[e_attachedObject],
				PR_UINT16, dataObject[e_attachedVehicle],
				PR_FLOAT, dataObject[e_AttachOffsetX],
				PR_FLOAT, dataObject[e_AttachOffsetY],
				PR_FLOAT, dataObject[e_AttachOffsetZ],
				PR_FLOAT, dataObject[e_AttachRotX],
				PR_FLOAT, dataObject[e_AttachRotY],
				PR_FLOAT, dataObject[e_AttachRotZ],
				PR_UINT8, dataObject[e_SyncRotation]
			);

			PR_SendRPC(bitstream, playerid, RPC_ScrCreateObject, PR_HIGH_PRIORITY, PR_RELIABLE_SEQUENCED);
			BS_Delete(bitstream);
			return 0 ;
		}
	}*/
	
	return 1 ;
}

stock IsShouldSendCreateAttached ( playerid, BitStream:bs )
{
    new sPlayerID, iSlot, bCreate ;
   	BS_ReadValue(
		bs,
		PR_UINT16, sPlayerID,
		PR_UINT32, iSlot,
		PR_BOOL,   bCreate);
		
	if ( bCreate )
	{
 		new modelid ;
   		BS_ReadValue(bs, PR_UINT32, modelid);
		
		/*if ( player_checking_hash [ playerid ] < 27 )
		{
			if ( modelid >= 12080 && modelid <= 12099 || modelid >= 12600 && modelid <= 12633 ) return 0 ;
		}
		
		if ( player_checking_hash [ playerid ] < 39 )
		{	
			if ( modelid >= 12635 && modelid <= 12672 ) return 0 ;
		}*/
	}
	return 1 ;
}

public OnOutcomingRPC ( playerid, rpcid, BitStream:bs )
{
	if ( rpcid == RPC_WorldPlayerAdd )
	{
		if ( playerid == -1 || playerid == INVALID_PLAYER_ID ) return 0 ;
		if ( player_device { playerid } == 2 ) // если игрок с ведра
		{
			if ( ProcessReplaceSkinAdd ( playerid, bs ) ) // если модель была заменена успешно, то оригинальный пакет не отсылаем
			{
			    return 0 ;
			}
		}
	}
	else if ( rpcid == RPC_SET_PLAYER_SKIN )
	{
		if ( playerid == -1 || playerid == INVALID_PLAYER_ID ) return 0 ;
		if ( player_device { playerid } == 2 ) // если игрок с ведра
		{
			if ( ProcessReplaceSkin ( playerid, bs ) ) // если модель была заменена успешно, то оригинальный пакет не отсылаем
			{
			    return 0 ;
			}
		}
	}
	
	if ( rpcid == RPC_WORLDVEHICLE_ADD )
	{
		if ( playerid == -1 || playerid == INVALID_PLAYER_ID ) return 0 ;
		if ( player_device { playerid } == 2 ) // если игрок с ведра
		{
			if ( ProcessReplaceVehicle ( playerid, bs ) ) // если модель была заменена успешно, то оригинальный пакет не отсылаем
			{
			    return 0 ;
			}
		}
	}
	
	else if ( rpcid == RPC_ScrCreateObject )
	{
		if ( playerid == -1 || playerid == INVALID_PLAYER_ID ) return 0 ;
		if ( player_device { playerid } == 2 ) // если игрок с ведра
		{
			if ( ! IsShouldSendCreateObject ( playerid, bs ) ) // если модель невалидная, то не отсылаем
		    {
				return 0 ;
		    }
		}
	}
	
	else if ( rpcid == RPC_ScrSetPlayerAttachedObject )
	{
		if ( playerid == -1 || playerid == INVALID_PLAYER_ID ) return 0 ;
		if ( player_device { playerid } == 2 ) // если игрок с ведра
		{
			if ( ! IsShouldSendCreateAttached ( playerid, bs ) ) // если модель невалидная, то не отсылаем
		    {
				return 0 ;
		    }
		}
	}
	return 1 ;
}