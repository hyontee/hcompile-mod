#define PACKET_CUSTOMRPC    			251
#define RPC_CUSTOM_HANDLING 			0x2
#define RPC_CUSTOM_VISUALS				0x3
#define RPC_CUSTOM_HANDLING_DEFAULTS	0x4
#define RPC_CUSTOM_COMPONENT			0x10

stock sc_CarSpeed ( _veh_id )
{
	#if defined debug_packet
		printf ( "[sc_CarSpeed]" ) ;
	#endif

	new BitStream: bitstream = BS_New();

	BS_WriteValue
	(
		bitstream,
		PR_UINT8,   PACKET_CUSTOMRPC, // PACKET_CUSTOMRPC
		PR_UINT32,  RPC_CUSTOM_HANDLING, // rpcid
		PR_UINT16,  _veh_id, // vehId
		PR_UINT8,	0,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MAX_SPEED ],
		PR_UINT8,	1,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_ACCELERATION ],
		PR_UINT8,	2,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_GEAR ],
		PR_UINT8,	3,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_ENGINE_INERTION ],
		PR_UINT8,	4,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MASS ],
		PR_UINT8,	5,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MASS_TURN ],
		PR_UINT8,	6,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_BRAKE_DECELERATION ],
		PR_UINT8,	7,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_TRACTION_MULTIPLIER ],
		PR_UINT8,	8,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_TRACTION_LOSS ],
		PR_UINT8,	9,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_TRACTION_BIAS ],
		PR_UINT8,	10, // ÂÛÑÎÒÀ ÏÎÄÂÅÑÊÈ
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_SUS_LOWER_LIMIT ],
		PR_UINT8,	11,
		PR_INT32,	0,
		PR_UINT8,	12, // ÄÈÀÌÅÒÐ ÊÎË¨Ñ
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_WHEEL_SIZE ],
		PR_UINT8,	13,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MAX ],
		PR_UINT8,	14,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_COUNT ]
	) ;

	PR_SendPacket(bitstream, _for_playerid, PR_SYSTEM_PRIORITY, PR_RELIABLE);
	BS_Delete(bitstream);
}

stock sc_CarSpeed_OnVehicleStreamIn ( _veh_id, _for_playerid )
{
	#if defined debug_packet
		printf ( "[sc_CarSpeed_OnVehicleStreamIn] _for_playerid: %d", _for_playerid ) ;
	#endif

	new BitStream: bitstream = BS_New();

	BS_WriteValue
	(
		bitstream,
		PR_UINT8,   PACKET_CUSTOMRPC, // PACKET_CUSTOMRPC
		PR_UINT32,  RPC_CUSTOM_HANDLING, // rpcid
		PR_UINT16,  _veh_id, // vehId
		PR_UINT8,	0,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MAX_SPEED ],
		PR_UINT8,	1,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_ACCELERATION ],
		PR_UINT8,	2,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_GEAR ],
		PR_UINT8,	3,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_ENGINE_INERTION ],
		PR_UINT8,	4,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MASS ],
		PR_UINT8,	5,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MASS_TURN ],
		PR_UINT8,	6,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_BRAKE_DECELERATION ],
		PR_UINT8,	7,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_TRACTION_MULTIPLIER ],
		PR_UINT8,	8,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_TRACTION_LOSS ],
		PR_UINT8,	9,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_TRACTION_BIAS ],
		PR_UINT8,	10, // ÂÛÑÎÒÀ ÏÎÄÂÅÑÊÈ
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_SUS_LOWER_LIMIT ],
		PR_UINT8,	11,
		PR_INT32,	0,
		PR_UINT8,	12, // ÄÈÀÌÅÒÐ ÊÎË¨Ñ
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_WHEEL_SIZE ],
		PR_UINT8,	13,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MAX ],
		PR_UINT8,	14,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_COUNT ]
	) ;

	PR_SendPacket(bitstream, _for_playerid, PR_SYSTEM_PRIORITY, PR_RELIABLE);
	BS_Delete(bitstream);
}

stock setCarComponent ( vehicleId, playerid )
{
	#if defined debug_packet
		printf ( "[setCarComponent] playerid: %d", playerid ) ;
	#endif

	new BitStream:bitstream = BS_New();
    BS_WriteValue(
		bitstream,
		PR_UINT8, PACKET_CUSTOMRPC,
    	PR_UINT32, RPC_CUSTOM_COMPONENT,

    	PR_UINT16, vehicleId,
	
    	PR_UINT8, CAR_COMPONENT_BUMPER_FRONT,
    	PR_UINT16, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ CAR_COMPONENT_BUMPER_FRONT ],
    	PR_UINT8, CAR_COMPONENT_BUMPER_REAR,
    	PR_UINT16, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ CAR_COMPONENT_BUMPER_REAR ],
    	PR_UINT8, CAR_COMPONENT_FENDER_FRONT,
    	PR_UINT16, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ CAR_COMPONENT_FENDER_FRONT ],
    	PR_UINT8, CAR_COMPONENT_FENDER_REAR,
    	PR_UINT16, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ CAR_COMPONENT_FENDER_REAR ],
    	PR_UINT8, CAR_COMPONENT_SPOILER,
    	PR_UINT16, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ CAR_COMPONENT_SPOILER ],
    	PR_UINT8, CAR_COMPONENT_EXHAUST,
    	PR_UINT16, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ CAR_COMPONENT_EXHAUST ],
    	PR_UINT8, CAR_COMPONENT_ROOF,
    	PR_UINT16, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ CAR_COMPONENT_ROOF ],
    	PR_UINT8, CAR_COMPONENT_TAILLIGHTS,
    	PR_UINT16, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ CAR_COMPONENT_TAILLIGHTS ],
    	PR_UINT8, CAR_COMPONENT_HEADLIGHTS,
    	PR_UINT16, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ CAR_COMPONENT_HEADLIGHTS ],
    	PR_UINT8, CAR_COMPONENT_DIFFUSER,
    	PR_UINT16, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ CAR_COMPONENT_DIFFUSER ],
    	PR_UINT8, CAR_COMPONENT_SPLITTER,
    	PR_UINT16, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ CAR_COMPONENT_SPLITTER ],
    	PR_UINT8, CAR_COMPONENT_EXTRA,
    	PR_UINT16, CAR_COMPONENT_EXTRA, // íóæíî, ÷òîá ïàêåò ø¸ë ïî ïîðÿäêó ïðè ïðî÷òåíèè
		PR_UINT8, 0,
    	PR_UINT8, CAR_COMPONENT_EXTRA,
    	PR_UINT16, EXTRA_COMPONENT_BOOT,
		PR_UINT8, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ EXTRA_COMPONENT_BOOT ],
    	PR_UINT8, CAR_COMPONENT_EXTRA,
    	PR_UINT16, EXTRA_COMPONENT_BONNET,
		PR_UINT8, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ EXTRA_COMPONENT_BONNET ],
    	PR_UINT8, CAR_COMPONENT_EXTRA,
    	PR_UINT16, EXTRA_COMPONENT_BUMP_REAR,
		PR_UINT8, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ EXTRA_COMPONENT_BUMP_REAR ],
    	PR_UINT8, CAR_COMPONENT_EXTRA,
    	PR_UINT16, EXTRA_COMPONENT_DEFAULT_DOOR,
		PR_UINT8, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ EXTRA_COMPONENT_DEFAULT_DOOR ],
    	PR_UINT8, CAR_COMPONENT_EXTRA,
    	PR_UINT16, EXTRA_COMPONENT_WHEEL,
		PR_UINT8, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ EXTRA_COMPONENT_WHEEL ],
    	PR_UINT8, CAR_COMPONENT_EXTRA,
    	PR_UINT16, EXTRA_COMPONENT_BUMP_FRONT,
		PR_UINT8, veh_info [ vehicleId - 1 ] [ V_DUMMY_INFO ] [ EXTRA_COMPONENT_BUMP_FRONT ]
	);

    PR_SendPacket(bitstream, playerid, PR_SYSTEM_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
}

stock sc_ResetHandling ( _veh_id )
{
	#if defined debug_packet
		printf ( "[sc_ResetHandling]" ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_HANDLING_DEFAULTS);

    BS_WriteValue(bitstream, PR_UINT16, _veh_id);
	
	PR_SendPacket(bitstream, -1, PR_SYSTEM_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
}

stock sc_player_ResetHandling ( playerid, _veh_id )
{
	#if defined debug_packet
		printf ( "[sc_ResetHandling]" ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_HANDLING_DEFAULTS);

    BS_WriteValue(bitstream, PR_UINT16, _veh_id);

	PR_SendPacket(bitstream, playerid, PR_SYSTEM_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
}

stock sc_AddHandling ( _veh_id )
{
	#if defined debug_packet
		printf ( "[sc_AddHandling]" ) ;
	#endif

	new BitStream: bitstream = BS_New();

	BS_WriteValue
	(
		bitstream,
		PR_UINT8,   PACKET_CUSTOMRPC, // PACKET_CUSTOMRPC
		PR_UINT32, 	RPC_CUSTOM_HANDLING, // rpcid
		PR_UINT16,  _veh_id, // vehId
		PR_UINT8,	0,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MAX_SPEED ],
		PR_UINT8,	1,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_ACCELERATION ],
		PR_UINT8,	2,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_GEAR ],
		PR_UINT8,	3,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_ENGINE_INERTION ],
		PR_UINT8,	4,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MASS ],
		PR_UINT8,	5,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MASS_TURN ],
		PR_UINT8,	6,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_BRAKE_DECELERATION ],
		PR_UINT8,	7,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_TRACTION_MULTIPLIER ],
		PR_UINT8,	8,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_TRACTION_LOSS ],
		PR_UINT8,	9,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_TRACTION_BIAS ],
		PR_UINT8,	10, // ÂÛÑÎÒÀ ÏÎÄÂÅÑÊÈ
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_SUS_LOWER_LIMIT ],
		PR_UINT8,	11,
		PR_INT32,	0,
		PR_UINT8,	12, // ÄÈÀÌÅÒÐ ÊÎË¨Ñ
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_WHEEL_SIZE ],
		PR_UINT8,	13,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MAX ],
		PR_UINT8,	14,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_COUNT ]
	) ;

	PR_SendPacket(bitstream, _for_playerid, PR_SYSTEM_PRIORITY, PR_RELIABLE);
	BS_Delete(bitstream);
}

stock sc_Handling_OnVehicleStreamIn ( _veh_id, _for_playerid )
{
	#if defined debug_packet
		printf ( "[sc_Handling_OnVehicleStreamIn] _for_playerid: %d", _for_playerid ) ;
	#endif

	new BitStream: bitstream = BS_New();

	BS_WriteValue
	(
		bitstream,
		PR_UINT8,   PACKET_CUSTOMRPC, // PACKET_CUSTOMRPC
		PR_UINT32,  RPC_CUSTOM_HANDLING, // rpcid
		PR_UINT16,  _veh_id, // vehId
		PR_UINT8,	0,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MAX_SPEED ],
		PR_UINT8,	1,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_ACCELERATION ],
		PR_UINT8,	2,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_GEAR ],
		PR_UINT8,	3,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_ENGINE_INERTION ],
		PR_UINT8,	4,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MASS ],
		PR_UINT8,	5,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MASS_TURN ],
		PR_UINT8,	6,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_BRAKE_DECELERATION ],
		PR_UINT8,	7,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_TRACTION_MULTIPLIER ],
		PR_UINT8,	8,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_TRACTION_LOSS ],
		PR_UINT8,	9,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_TRACTION_BIAS ],
		PR_UINT8,	10, // ÂÛÑÎÒÀ ÏÎÄÂÅÑÊÈ
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_SUS_LOWER_LIMIT ],
		PR_UINT8,	11,
		PR_INT32,	0,
		PR_UINT8,	12, // ÄÈÀÌÅÒÐ ÊÎË¨Ñ
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_WHEEL_SIZE ],
		PR_UINT8,	13,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_MAX ],
		PR_UINT8,	14,
		PR_INT32,	veh_info [ _veh_id - 1 ] [ V_HP_COUNT ]
	) ;

    PR_SendPacket(bitstream, _for_playerid, PR_SYSTEM_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
}

stock sc_CreateVehicle ( _veh_id )
{
	#if defined debug_packet
		printf ( "[sc_CreateVehicle]" ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_VISUALS);
	
    BS_WriteValue(bitstream, PR_UINT16, _veh_id);

	// headlights
    BS_WriteValue(
		bitstream,
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_lights_color ] [ 0 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_lights_color ] [ 1 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_lights_color ] [ 2 ]);

	// wheel settings
    BS_WriteValue(
		bitstream,
		PR_UINT16, veh_info [ _veh_id - 1 ] [ V_HP_WHEEL_WIDTH ],
    
		PR_INT16, veh_info [ _veh_id - 1 ] [ V_HP_WHEEL_ALIGN_FRONT ],
		PR_INT16, veh_info [ _veh_id - 1 ] [ V_HP_WHEEL_ALIGN_BACK ],
    
		PR_INT16, veh_info [ _veh_id - 1 ] [ V_HP_SPACERS ],
		PR_INT16, veh_info [ _veh_id - 1 ] [ V_HP_SPACERS ]);
	
	// main color 1
    BS_WriteValue(
		bitstream,
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_main_color ] [ 0 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_main_color ] [ 1 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_main_color ] [ 2 ]);
	
	// main color 2
    BS_WriteValue(
		bitstream,
		PR_UINT8, 0,
		PR_UINT8, 0,
		PR_UINT8, 0);
	
	// wheel color
    BS_WriteValue(
		bitstream,
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_disk_color ] [ 0 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_disk_color ] [ 1 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_disk_color ] [ 2 ]);
	
	// toner color
    BS_WriteValue(
		bitstream,
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 0 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 1 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 2 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 3 ]);
	
	// vinyl
	new _vinyl = veh_info [ _veh_id - 1 ] [ v_vinyl ] ;
	BS_WriteValue(bitstream, PR_INT16, veh_info [ _veh_id - 1 ] [ v_vinyl ]);
	
	// strobs
    BS_WriteValue(bitstream, PR_UINT8, veh_info [ _veh_id - 1 ] [ v_strobs ]);
	
	// plate
	new _plate = veh_info [ _veh_id - 1 ] [ v_plate_type ] ;
	BS_WriteValue(bitstream, PR_UINT8, _plate);
	
	if ( _plate > 1 )
	{
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( veh_info [ _veh_id - 1 ] [ v_plate ] ),
			PR_STRING, veh_info [ _veh_id - 1 ] [ v_plate ],
			
			PR_UINT8, strlen ( veh_info [ _veh_id - 1 ] [ v_region ] ),
			PR_STRING, veh_info [ _veh_id - 1 ] [ v_region ] ) ;
	}
	
	// neon
    BS_WriteValue(
		bitstream,
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_neon ] [ 0 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_neon ] [ 1 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_neon ] [ 2 ]);
	
	new _neon_type = veh_info [ _veh_id - 1 ] [ v_neon_type ] ;
	BS_WriteValue(bitstream, PR_UINT8, _neon_type);

    PR_SendPacket(bitstream, -1, PR_SYSTEM_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);
}

stock sc_OnVehicleStreamIn ( _veh_id, _for_playerid )
{
	#if defined debug_packet
		printf ( "[sc_OnVehicleStreamIn] _for_playerid: %d", _for_playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_VISUALS);

    BS_WriteValue(bitstream, PR_UINT16, _veh_id);
	
	// headlights
    BS_WriteValue(
		bitstream,
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_lights_color ] [ 0 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_lights_color ] [ 1 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_lights_color ] [ 2 ]);

	// wheel settings
    BS_WriteValue(
		bitstream,
		PR_UINT16, veh_info [ _veh_id - 1 ] [ V_HP_WHEEL_WIDTH ],
    
		PR_INT16, veh_info [ _veh_id - 1 ] [ V_HP_WHEEL_ALIGN_FRONT ],
		PR_INT16, veh_info [ _veh_id - 1 ] [ V_HP_WHEEL_ALIGN_BACK ],
    
		PR_INT16, veh_info [ _veh_id - 1 ] [ V_HP_SPACERS ],
		PR_INT16, veh_info [ _veh_id - 1 ] [ V_HP_SPACERS ]);
	
	// main color 1
    BS_WriteValue(
		bitstream,
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_main_color ] [ 0 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_main_color ] [ 1 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_main_color ] [ 2 ]);
	
	// main color 2
    BS_WriteValue(
		bitstream,
		PR_UINT8, 0,
		PR_UINT8, 0,
		PR_UINT8, 0);
	
	// wheel color
    BS_WriteValue(
		bitstream,
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_disk_color ] [ 0 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_disk_color ] [ 1 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_disk_color ] [ 2 ]);
	
	// toner color
    BS_WriteValue(
		bitstream,
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 0 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 1 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 2 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 3 ]);
	
	// vinyl
	BS_WriteValue(bitstream, PR_INT16, veh_info [ _veh_id - 1 ] [ v_vinyl ]);
	
	// strobs
    BS_WriteValue(bitstream, PR_UINT8, veh_info [ _veh_id - 1 ] [ v_strobs ]);
	
	// plate
	new _plate = veh_info [ _veh_id - 1 ] [ v_plate_type ] ;
	BS_WriteValue(bitstream, PR_UINT8, _plate);
	
	if ( _plate > 1 )
	{
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( veh_info [ _veh_id - 1 ] [ v_plate ] ),
			PR_STRING, veh_info [ _veh_id - 1 ] [ v_plate ],
			
			PR_UINT8, strlen ( veh_info [ _veh_id - 1 ] [ v_region ] ),
			PR_STRING, veh_info [ _veh_id - 1 ] [ v_region ] ) ;
	}
	
	// neon
    BS_WriteValue(
		bitstream,
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_neon ] [ 0 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_neon ] [ 1 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_neon ] [ 2 ]);
	
	new _neon_type = veh_info [ _veh_id - 1 ] [ v_neon_type ] ;
	BS_WriteValue(bitstream, PR_UINT8, _neon_type);

    PR_SendPacket(bitstream, _for_playerid, PR_SYSTEM_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);
}