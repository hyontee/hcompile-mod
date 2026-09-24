#define PACKET_CUSTOMRPC    			251
#define RPC_BOATS_SHOW					0x230
#define RPC_BOATS_HIDE					0x231
#define RPC_BOATS_COLOR					0x232
#define RPC_BOATS_UPGRADE				0x233
#define RPC_BOATS_RENT					0x234
#define RPC_BOATS_SELECT				0x235

stock SetBoatsShow ( playerid, _i )
{
	#if defined debug_packet
		printf ( "[SetBoatsShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BOATS_SHOW);
	
	BS_WriteValue(bitstream, PR_UINT8, _i);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetBoatsHide ( playerid )
{
	#if defined debug_packet
		printf ( "[SetBoatsHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BOATS_HIDE);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetBoatsColor ( playerid, _vehicleid )
{
	#if defined debug_packet
		printf ( "[SetBoatsColor] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BOATS_COLOR);
	
	BS_WriteValue(bitstream, PR_UINT8, veh_info [ _vehicleid - 1 ] [ v_color ] [ 0 ]);
	BS_WriteValue(bitstream, PR_UINT32, 1_000_000);
	BS_WriteValue(bitstream, PR_UINT8, 1);
	BS_WriteValue(bitstream, PR_UINT16, getReplacableVehicleModel ( _vehicleid ));

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetBoatsUpgrade ( playerid, _vehicleid )
{
	#if defined debug_packet
		printf ( "[SetBoatsUpgrade] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BOATS_UPGRADE);
	
	BS_WriteValue(bitstream, PR_UINT16, getReplacableVehicleModel ( _vehicleid ));
	BS_WriteValue(bitstream, PR_UINT8, 1);
	
	BS_WriteValue(bitstream, PR_UINT8, 6);
	new _st_speed = veh_info [ _vehicleid - 1 ] [ v_stage_speed ] ;
	BS_WriteValue(bitstream, PR_UINT8, _st_speed);
	if ( _st_speed >= 3 ) BS_WriteValue(bitstream, PR_INT32, -1);
	else BS_WriteValue(bitstream, PR_INT32, boats_price [ _st_speed ]);

	BS_WriteValue(bitstream, PR_UINT8, _st_speed);
	if ( _st_speed >= 3 ) BS_WriteValue(bitstream, PR_INT32, -1);
	else BS_WriteValue(bitstream, PR_INT32, boats_price [ _st_speed ]);
	
	BS_WriteValue(bitstream, PR_UINT8, _st_speed);
	if ( _st_speed >= 3 ) BS_WriteValue(bitstream, PR_INT32, -1);
	else BS_WriteValue(bitstream, PR_INT32, boats_price [ _st_speed ]);
	
	BS_WriteValue(bitstream, PR_UINT8, veh_info [ _vehicleid - 1 ] [ v_pantera_armour ]);
	BS_WriteValue(bitstream, PR_INT32, 1_000_000);
	
	BS_WriteValue(bitstream, PR_UINT8, veh_info [ _vehicleid - 1 ] [ v_pantera_engine ]);
	BS_WriteValue(bitstream, PR_INT32, 1_000_000);
	
	BS_WriteValue(bitstream, PR_UINT8, veh_info [ _vehicleid - 1 ] [ v_color ] [ 0 ]);
	BS_WriteValue(bitstream, PR_INT32, 1_000_000);
	
    #if defined m_t_stage
	new _minus_speed = 0 ;
	if ( veh_info [ _vehicleid - 1 ] [ v_millage ] > 100 ) _minus_speed = floatround ( veh_info [ _vehicleid - 1 ] [ v_millage ] / 100 ) ;
	new Float: _max_speed = max_veh_speed ( getReplacableVehicleModel ( _vehicleid ) ) + stage_info_speed ( _vehicleid ) - _minus_speed ;
	#else
	new Float: _max_speed = max_veh_speed ( getReplacableVehicleModel ( _vehicleid ) ) ;
	#endif
	new Float: _upd_speed = getSpeedReplacable ( _max_speed ) ;
	BS_WriteValue(bitstream, PR_UINT8, 4);
	BS_WriteValue(bitstream, PR_INT16, floatround ( _upd_speed ));
	BS_WriteValue(bitstream, PR_INT16, floatround ( _max_speed ));
	BS_WriteValue(bitstream, PR_INT16, 60);
	if ( veh_info [ _vehicleid - 1 ] [ v_pt_stability ] [ 2 ] != 0 ) BS_WriteValue(bitstream, PR_INT16, 2);
	else if ( veh_info [ _vehicleid - 1 ] [ v_pt_stability ] [ 1 ] != 0 ) BS_WriteValue(bitstream, PR_INT16, 1);
	else BS_WriteValue(bitstream, PR_INT16, 0);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetBoatsRent ( playerid, _type )
{
	#if defined debug_packet
		printf ( "[SetBoatsRent] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BOATS_RENT);
	
	new _b_cost = b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_cost ] ;
	if ( _type == 1 )
	{
		BS_WriteValue(bitstream, PR_UINT8, sizeof boats_model);
		for ( new i = 0 ; i < sizeof boats_model ; i ++ )
		{
			new _model = boats_model [ i ] ;
			BS_WriteValue(bitstream, PR_UINT8, i);
			BS_WriteValue(bitstream, PR_UINT8, 1);
			BS_WriteValue(bitstream, PR_UINT16, max_veh_speed ( _model ) ) ;
			BS_WriteValue(bitstream, PR_UINT32, _b_cost);
			BS_WriteValue(bitstream, PR_UINT8, 1);
			BS_WriteValue(bitstream, PR_UINT16, _model);
		}
	}
	else
	{
		BS_WriteValue(bitstream, PR_UINT8, sizeof planes_model);
		for ( new i = 0 ; i < sizeof planes_model ; i ++ )
		{
			new _model = planes_model [ i ] ;
			BS_WriteValue(bitstream, PR_UINT8, i);
			BS_WriteValue(bitstream, PR_UINT8, 0);
			BS_WriteValue(bitstream, PR_UINT16, max_veh_speed ( _model ) ) ;
			BS_WriteValue(bitstream, PR_UINT32, _b_cost);
			BS_WriteValue(bitstream, PR_UINT8, 0);
			BS_WriteValue(bitstream, PR_UINT16, _model);
		}
	}
	
	/*BS_WriteValue(bitstream, PR_UINT8, _id);
	BS_WriteValue(bitstream, PR_UINT8, _typeVehicle);
	BS_WriteValue(bitstream, PR_UINT16, _speed);
	BS_WriteValue(bitstream, PR_UINT32, _cost);
	BS_WriteValue(bitstream, PR_UINT8, _type);
	BS_WriteValue(bitstream, PR_UINT16, _modelId);*/

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SetBoatsSelect ( playerid, _type )
{
	#if defined debug_packet
		printf ( "[SetBoatsSelect] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_BOATS_SELECT);
	
	if ( _type == 1 )
	{
		new _count = 0 ;
		foreach(new i: player_vehicles[playerid])
		{
			if ( VehicleState [ i ] != VEHICLE_STATE_BOAT ) continue ;
			
			_count ++ ;
		}
	
		BS_WriteValue(bitstream, PR_UINT8, _count);
		foreach(new i: player_vehicles[playerid])
		{
			if ( VehicleState [ i ] != VEHICLE_STATE_BOAT ) continue ;
			
			new _model = veh_info [ i - 1 ] [ v_model ] ;
			BS_WriteValue(bitstream, PR_UINT8, i);
			BS_WriteValue(bitstream, PR_UINT8, strlen ( GetVehicleNameEx ( -1, _model ) ) ) ;
			BS_WriteValue(bitstream, PR_STRING, GetVehicleNameEx ( -1, _model ) ) ;
			BS_WriteValue(bitstream, PR_UINT16, max_veh_speed ( getReplacableVehicleModel ( i ) ) ) ;
			BS_WriteValue(bitstream, PR_BOOL, true);
			BS_WriteValue(bitstream, PR_UINT8, 1);
			BS_WriteValue(bitstream, PR_UINT16, _model);
		}
	}
	else
	{
		new _count = 0 ;
		foreach(new i: player_vehicles[playerid])
		{
			if ( VehicleState [ i ] != VEHICLE_STATE_PLANE ) continue ;
			
			_count ++ ;
		}
	
		BS_WriteValue(bitstream, PR_UINT8, _count);
		foreach(new i: player_vehicles[playerid])
		{
			if ( VehicleState [ i ] != VEHICLE_STATE_PLANE ) continue ;
			
			new _model = veh_info [ i - 1 ] [ v_model ] ;
			BS_WriteValue(bitstream, PR_UINT8, i);
			BS_WriteValue(bitstream, PR_UINT8, strlen ( GetVehicleNameEx ( -1, _model ) ) ) ;
			BS_WriteValue(bitstream, PR_STRING, GetVehicleNameEx ( -1, _model ) ) ;
			BS_WriteValue(bitstream, PR_UINT16, max_veh_speed ( getReplacableVehicleModel ( i ) ) ) ;
			BS_WriteValue(bitstream, PR_BOOL, true);
			BS_WriteValue(bitstream, PR_UINT8, 1);
			BS_WriteValue(bitstream, PR_UINT16, _model);
		}
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}