#define PACKET_CUSTOMRPC    			251
#define RPC_TIMEOUT_CHAT 				0x20
#define CUSTOM_RPC_TOGGLE_HUD_ELEMENT	0x22
#define RPC_CUSTOM_AIM 					0x23
#define RPC_OPEN_SETTINGS_JAVA			0x24
#define RPC_CHECK_HUD					0x26

#define RPC_CHECK_CASH 					0x60
#define RPC_CHATMESSAGE					0x62
#define RPC_RADIALMENU					0x63
#define RPC_RADIALMENU_HIDE				0x64

#define RPC_LABEL_CUSTOM 				0x101

#define RPC_FINGER_PRINT				0x140

#define RPC_CHECK_ANDROID				0x160

#define RPC_MOBILE_CLIENT				0x280

#define HUD_ELEMENT_CHAT    			0
#define HUD_ELEMENT_MAP     			1
#define HUD_ELEMENT_TAGS    			2
#define HUD_ELEMENT_WIDGETS 			3
#define HUD_ELEMENT_HUD     			4
#define HUD_ELEMENT_VOICE				5
#define HUD_ELEMENT_TEXTLABELS			6
#define HUD_ELEMENT_BUTTONS				7
#define HUD_ELEMENT_KILL_LIST			8

#define HUD_MAX							9

stock TogglePlayerHudElement ( playerid, hud_element, bool: status_element )
{
	#if defined debug_packet
		printf ( "[TogglePlayerHudElement] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, CUSTOM_RPC_TOGGLE_HUD_ELEMENT);
	
	BS_WriteValue(bitstream, PR_UINT8, hud_element);
	BS_WriteValue(bitstream, PR_BOOL, status_element);
	
	PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SendChangeAim ( playerid, texture_name [ ] )
{
	#if defined debug_packet
		printf ( "[SendChangeAim] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_AIM);
	
    BS_WriteValue(bitstream, PR_UINT8, strlen ( texture_name ));
    BS_WriteValue(bitstream, PR_STRING, texture_name);

    PR_SendPacket(bitstream, playerid);

    BS_Delete(bitstream);
}

stock ToggleClientSettings ( playerid )
{
	#if defined debug_packet
		printf ( "[ToggleClientSettings] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_OPEN_SETTINGS_JAVA);

    PR_SendPacket(bitstream, playerid);

    BS_Delete(bitstream);
}

stock SendCheckHud ( playerid )
{
	#if defined debug_packet
		printf ( "[SendCheckHud] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CHECK_HUD);
    
	BS_WriteValue(bitstream, PR_UINT8, p_info [ playerid ] [ hunger ]);
    
	BS_WriteValue(bitstream, PR_UINT32, server_bonus [ 1 ]);
	
	if ( valentine_end_gettime > gettime ( ) )
	{
		BS_WriteValue(bitstream, PR_UINT32, player_valentine [ playerid ]); // kol-vo valentinok
		BS_WriteValue(bitstream, PR_BOOL, true); // otobrazhenie menu valention
	}
	else
	{
		BS_WriteValue(bitstream, PR_UINT32, player_valentine [ playerid ]); // kol-vo valentinok
		BS_WriteValue(bitstream, PR_BOOL, false); // otobrazhenie menu valention
	}
	
	new bool: _b_gz = false ;
	if ( used_area [ playerid ] != -1 && area_info [ used_area [ playerid ] ] [ a_type ] == area_type_antidm ) _b_gz = true ;
	BS_WriteValue(bitstream, PR_BOOL, _b_gz); // green zone
	
	if ( e2y_start_gettime > gettime ( ) ) BS_WriteValue(bitstream, PR_BOOL, true);
	else BS_WriteValue(bitstream, PR_BOOL, false);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SendCheckHash ( playerid, texture_name [ ], cash_name [ ], cash_version )
{
	#if defined debug_packet
		printf ( "[SendCheckHash] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();

    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CHECK_CASH);

    BS_WriteValue(
		bitstream,
		PR_UINT8, strlen(texture_name),
		PR_STRING, texture_name,
	
		PR_UINT8, strlen(cash_name),
		PR_STRING, cash_name,
	
		PR_UINT16, cash_version);

    PR_SendPacket(bitstream, playerid);
    BS_Delete(bitstream);
}

stock setLabelCustom ( playerid, _labelId, bool: _showBg, bool: _showIcon, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[setLabelCustom] playerid: %d", playerid ) ;
	#endif
	
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_LABEL_CUSTOM);
    
	BS_WriteValue(bitstream, PR_UINT16, _labelId );
	
	BS_WriteValue(bitstream, PR_BOOL, _showBg ) ;
	BS_WriteValue(bitstream, PR_BOOL, _showIcon ) ;
	if ( _showIcon )
	{
		BS_WriteValue(bitstream, PR_UINT16, strlen ( _str ) ) ;
		BS_WriteValue(bitstream, PR_STRING, _str ) ;
		
		BS_WriteValue(bitstream, PR_UINT16, strlen ( _str2 ) ) ;
		BS_WriteValue(bitstream, PR_STRING, _str2 ) ;
	}
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock ShowFingerPrint ( playerid, _id, _text [ ] )
{
	#if defined debug_packet
		printf ( "[ShowFingerPrint] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FINGER_PRINT);
    
	BS_WriteValue(bitstream, PR_UINT8, _id);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _text ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _text);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock CheckAndroidID ( playerid, _id )
{
	#if defined debug_packet
		printf ( "[CheckAndroidID] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CHECK_ANDROID);
	
    BS_WriteValue(bitstream, PR_INT8, _id);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SendCustomMessage ( playerid, dwColor, dwMessage [ ], dwType, dwNumber )
{
	#if defined debug_packet
		printf ( "[SendCustomMessage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CHATMESSAGE);
	
	BS_WriteValue(bitstream, PR_UINT32, dwColor);
	
	BS_WriteValue(bitstream, PR_UINT32, strlen ( dwMessage ) ) ;
	BS_WriteValue(bitstream, PR_STRING, dwMessage ) ;
	
	BS_WriteValue(bitstream, PR_UINT8, dwType);
	BS_WriteValue(bitstream, PR_UINT32, dwNumber);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

enum
{
	RADIAL_PASSPORT = 0,
	RADIAL_FRACTION,
	RADIAL_FAMILY,
	RADIAL_LICENSE,
	RADIAL_KISS,
	RADIAL_SKILL,
	RADIAL_HUD,
	RADIAL_MONEY,
	RADIAL_PROPERTY,
	RADIAL_PLAYER,
	RADIAL_AZS,
	RADIAL_INVENTORY,
	RADIAL_BUSINESS,
	RADIAL_TRUCKER,
	RADIAL_CAR,
	RADIAL_CAR_ENGINE,
	RADIAL_CAR_LIGHTS,
	RADIAL_CAR_LOCK,
	RADIAL_CAR_PARKING,
	RADIAL_CAR_UNLOAD,
	RADIAL_CAR_PLACE,
	RADIAL_CAR_BAGAGE,
	RADIAL_CAR_PTS,
	RADIAL_CAR_KEY,
	RADIAL_GARAGE,
	RADIAL_CAR_STROBS,
	RADIAL_CAR_LIGHTS_ELEMENTS,
	RADIAL_CAR_NEON,
	RADIAL_MUSIC,
	RADIAL_GPS,
	RADIAL_MENU,
	RADIAL_CAR_UNRENT,
	RADIAL_CAR_COMMANDS,
	RADIAL_CAR_STROBS_POLICE,
	RADIAL_CAR_LIGHTS_COLOR,
	RADIAL_TRADE,
	RADIAL_JOBLIST,
	RADIAL_HI
} ;

stock ShowRadialMenu ( playerid )
{
	#if defined debug_packet
		printf ( "[ShowRadialMenu] playerid: %d", playerid ) ;
	#endif

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_RADIALMENU);
	
	if ( GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER )
	{
		BS_WriteValue(bitstream, PR_INT8, RADIAL_PASSPORT);
		
		BS_WriteValue(bitstream, PR_INT8, RADIAL_CAR);
		BS_WriteValue(bitstream, PR_INT8, RADIAL_CAR_ENGINE);
		
		if ( veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_key ] ) BS_WriteValue(bitstream, PR_INT8, RADIAL_MUSIC);
		else BS_WriteValue(bitstream, PR_INT8, RADIAL_CAR_KEY);
		
		BS_WriteValue(bitstream, PR_INT8, -1);
		BS_WriteValue(bitstream, PR_INT8, -1);
		
		BS_WriteValue(bitstream, PR_INT8, RADIAL_GPS);
		
		if ( veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_strobs ] ) BS_WriteValue(bitstream, PR_INT8, RADIAL_CAR_STROBS);
		else BS_WriteValue(bitstream, PR_INT8, RADIAL_CAR_LIGHTS);
		
		if ( Iter_Count(player_business[playerid]) > 0 ) BS_WriteValue(bitstream, PR_INT8, RADIAL_CAR_LOCK);
		else BS_WriteValue(bitstream, PR_INT8, -1);
		
		BS_WriteValue(bitstream, PR_INT8, RADIAL_CAR_UNRENT);
	}
	else if ( get_player_use_listitem ( playerid ) != -1 )
	{
		BS_WriteValue(
			bitstream,
			PR_INT8, RADIAL_PASSPORT,
			PR_INT8, RADIAL_LICENSE,
			PR_INT8, RADIAL_SKILL,
			PR_INT8, RADIAL_TRADE,
			PR_INT8, RADIAL_JOBLIST,
			PR_INT8, RADIAL_KISS,
			PR_INT8, RADIAL_HI,
			PR_INT8, RADIAL_MONEY,
			PR_INT8, -1,
			PR_INT8, -1);
	}
	else
	{
		BS_WriteValue(bitstream, PR_INT8, RADIAL_PASSPORT);
		
		new bool: _hud = false, bool: _money = false ;
		
		if ( p_info [ playerid ] [ member ] > 0 ) BS_WriteValue(bitstream, PR_INT8, RADIAL_FRACTION);
		else 
		{
			BS_WriteValue(bitstream, PR_INT8, RADIAL_HUD);
			_hud = true ;
		}
		if ( p_info [ playerid ] [ family ] > 0 ) BS_WriteValue(bitstream, PR_INT8, RADIAL_FAMILY);
		else
		{
			if ( ! _hud )
			{
				BS_WriteValue(bitstream, PR_INT8, RADIAL_HUD);
				_hud = true ;
			}
			else if ( ! _money )
			{
				BS_WriteValue(bitstream, PR_INT8, RADIAL_MONEY);
				_money = true ;
			}
			else BS_WriteValue(bitstream, PR_INT8, -1);
		}
		
		BS_WriteValue(bitstream, PR_INT8, RADIAL_LICENSE);
		BS_WriteValue(bitstream, PR_INT8, RADIAL_INVENTORY);
		BS_WriteValue(bitstream, PR_INT8, RADIAL_SKILL);
		BS_WriteValue(bitstream, PR_INT8, RADIAL_GPS);
		
		if ( Iter_Count(player_houses[playerid]) > 0 ) BS_WriteValue(bitstream, PR_INT8, RADIAL_PROPERTY);
		else
		{
			if ( ! _hud )
			{
				BS_WriteValue(bitstream, PR_INT8, RADIAL_HUD);
				_hud = true ;
			}
			else if ( ! _money )
			{
				BS_WriteValue(bitstream, PR_INT8, RADIAL_MONEY);
				_money = true ;
			}
			else BS_WriteValue(bitstream, PR_INT8, -1);
		}
		
		if ( Iter_Count(player_business[playerid]) > 0 ) BS_WriteValue(bitstream, PR_INT8, RADIAL_BUSINESS);
		else
		{
			if ( ! _hud )
			{
				BS_WriteValue(bitstream, PR_INT8, RADIAL_HUD);
				_hud = true ;
			}
			else if ( ! _money )
			{
				BS_WriteValue(bitstream, PR_INT8, RADIAL_MONEY);
				_money = true ;
			}
			else BS_WriteValue(bitstream, PR_INT8, -1);
		}
		
		if ( ! _money ) BS_WriteValue(bitstream, PR_INT8, RADIAL_MONEY);
		else BS_WriteValue(bitstream, PR_INT8, RADIAL_JOBLIST);
	}
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock ShowCarRadialMenu ( playerid )
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_RADIALMENU);

	BS_WriteValue(
		bitstream,
		PR_INT8, RADIAL_CAR_LOCK,
		PR_INT8, RADIAL_CAR_BAGAGE,
		PR_INT8, -1,
		PR_INT8, -1,
		PR_INT8, -1,
		PR_INT8, -1,
		PR_INT8, -1,
		PR_INT8, -1,
		PR_INT8, -1,
		PR_INT8, -1);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock HideRadialMenu ( playerid )
{
	#if defined debug_packet
		printf ( "[HideRadialMenu] playerid: %d", playerid ) ;
	#endif

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_RADIALMENU_HIDE);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetMobileClient ( playerid )
{
	#if defined debug_packet
		printf ( "[SetMobileClient] playerid: %d", playerid ) ;
	#endif

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MOBILE_CLIENT);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}