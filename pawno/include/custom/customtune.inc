/*

    SetWheelOffset - вылет колёс.
    Минимальное значение -17, максимальное значение 17
    
    SetWheelAlignment - выворот колёс.
    Минимальное значение -7, максимальное значение 7
    
    SetWheelWidth - ширина колёс.
    Минимальное значение 105, максимальное 150
	
	hp_suspension_lower_limit - уровень подвески.
	hp_suspension_bias - баланс подвески.
	hp_wheel_size - размер колёс.
	
	new rgb_array [ 127 ] =
	{
		0xFFFFFFFF, 0xF5F5F5FF, 0x2A77A1FF, 0x840410FF, 0x263739FF, 0x86446EFF, 0xD78E10FF, 0x4C75B7FF, 0xBDBEC6FF, 0x5E7072FF,
		0x46597AFF, 0x656A79FF, 0x5D7E8DFF, 0x58595AFF, 0xD6DAD6FF, 0x9CA1A3FF, 0x335F3FFF, 0x730E1AFF, 0x7B0A2AFF, 0x9F9D94FF,
		0x3B4E78FF, 0x732E3EFF, 0x691E3BFF, 0x96918CFF, 0x515459FF, 0x3F3E45FF, 0xA5A9A7FF, 0x635C5AFF, 0x3D4A68FF, 0x979592FF,
		0x421F21FF, 0x5F272BFF, 0x8494ABFF, 0x767B7CFF, 0x646464FF, 0x5A5752FF, 0x252527FF, 0x2D3A35FF, 0x93A396FF, 0x6D7A88FF,
		0x221918FF, 0x6F675FFF, 0x7C1C2AFF, 0x5F0A15FF, 0x193826FF, 0x5D1B20FF, 0x9D9872FF, 0x7A7560FF, 0x989586FF, 0xADB0B0FF,
		0x848988FF, 0x304F45FF, 0x4D6268FF, 0x162248FF, 0x272F4BFF, 0x7D6256FF, 0x9EA4ABFF, 0x9C8D71FF, 0x6D1822FF, 0x4E6881FF,
		0x9C9C98FF, 0x917347FF, 0x661C26FF, 0x949D9FFF, 0xA4A7A5FF, 0x8E8C46FF, 0x341A1EFF, 0x6A7A8CFF, 0xAAAD8EFF, 0xAB988FFF,
		0x851F2EFF, 0x6F8297FF, 0x585853FF, 0x9AA790FF, 0x601A23FF, 0x20202CFF, 0xA4A096FF, 0xAA9D84FF, 0x78222BFF, 0x0E316DFF,
		0x722A3FFF, 0x7B715EFF, 0x741D28FF, 0x1E2E32FF, 0x4D322FFF, 0x7C1B44FF, 0x2E5B20FF, 0x395A83FF, 0x6D2837FF, 0xA7A28FFF,
		0xAFB1B1FF, 0x364155FF, 0x6D6C6EFF, 0x0F6A89FF, 0x204B6BFF, 0x2B3E57FF, 0x9B9F9DFF, 0x6C8495FF, 0x4D8495FF, 0xAE9B7FFF,
		0x406C8FFF, 0x1F253BFF, 0xAB9276FF, 0x134573FF, 0x96816CFF, 0x64686AFF, 0x105082FF, 0xA19983FF, 0x385694FF, 0x525661FF,
		0x7F6956FF, 0x8C929AFF, 0x596E87FF, 0x473532FF, 0x44624FFF, 0x730A27FF, 0x223457FF, 0x640D1BFF, 0xA3ADC6FF, 0x695853FF,
		0x9B8B80FF, 0x620B1CFF, 0x5B5D5EFF, 0x624428FF, 0x731827FF, 0x1B376DFF, 0xEC6AAEFF
	} ;
	
	
	
	Примеры использования:
	
	new r, g, b ;
	color_converter ( rgb_array [ МАССИВ ГДЕ ХРАНИТСЯ НОМЕР ЦВЕТА ], r, g, b ) ;
	SetVehicleLightsColors ( vehicleid, r, g, b ) ;
	
	stock color_converter ( hexValue, &r, &g, &b )
	{
		r = 256 + ( ( hexValue & 0xFF000000 ) >> 24 ) ;

		if ( r > 255 )
			r -= 256 ;

		g = ( hexValue & 0x00ff0000 ) >> 16 ;
		b = ( hexValue & 0x0000ff00 ) >> 8 ;
	}

*/

enum
{
	eNeonTypes_OFF = 0,
	eNeonTypes_ON_TYPE_STATIC,		// просто цвет
	eNeonTypes_ON_TYPE_RAINDOW,		// переливается цветами
	eNeonTypes_ON_TYPE_FLASH,		// моргает
	eNeonTypes_ON_TYPE_SHARP,		// рандомный цвет
	eNeonTypes_ON_TYPE_TEXTURE
};

enum
{
	ccBumperF = 0,
	ccBumperR,
	ccFenderF,
	ccFenderR,
	ccSpoiler,
	ccExhaust,
	ccRoof,
	ccTaillights,
	ccHeadlights,
	ccDiffuser,
	ccSplitter,
	ccExtra,
	ccMax
} ;

#define EXTRA_COMPONENT_BOOT			10
#define EXTRA_COMPONENT_BONNET			11
#define EXTRA_COMPONENT_BUMP_REAR		12
#define EXTRA_COMPONENT_DEFAULT_DOOR 	13
#define EXTRA_COMPONENT_WHEEL			14
#define EXTRA_COMPONENT_BUMP_FRONT		15

enum
{
	hp_max_speed = 0,
	hp_acceleration,
	hp_gear,
	hp_engine_inertion,
	hp_mass,
	hp_mass_turn,
	
	hp_brake_deceleration,
	hp_traction_multiplier,
	hp_traction_loss,
	hp_traction_bias,
	hp_suspension_lower_limit,
	hp_suspension_bias,
	
	hp_wheel_size,
	
	hp_max
} ;

#define PACKET_CUSTOMRPC    			251
#define RPC_CUSTOM_HANDLING 			0x2
#define RPC_CUSTOM_VISUALS				0x3
#define RPC_CUSTOM_HANDLING_DEFAULTS	0x4
#define RPC_CUSTOM_COMPONENT			0x10

stock color_converter ( hexValue, &r, &g, &b )
{
    r = 256 + ( ( hexValue & 0xFF000000 ) >> 24 ) ;

    if ( r > 255 )
        r -= 256 ;

    g = ( hexValue & 0x00ff0000 ) >> 16 ;
    b = ( hexValue & 0x0000ff00 ) >> 8 ;
}

stock sc_CarSpeed ( _veh_id, Float: _max_speed, Float: _max_acceleration )
{
	#if defined debug_packet
		printf ( "[sc_CarSpeed]" ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_HANDLING);

    BS_WriteValue(bitstream, PR_UINT16, _veh_id);
    BS_WriteValue(bitstream, PR_UINT8, 2);
	
    BS_WriteValue(bitstream, PR_UINT8, hp_max_speed);
    BS_WriteValue(bitstream, PR_FLOAT, _max_speed);

    BS_WriteValue(bitstream, PR_UINT8, hp_acceleration);
    BS_WriteValue(bitstream, PR_FLOAT, _max_acceleration);

    PR_SendPacket(bitstream, -1);

    BS_Delete(bitstream);
}

stock sc_CarSpeed_OnVehicleStreamIn ( _veh_id, _for_playerid, Float: _max_speed, Float: _max_acceleration )
{
	#if defined debug_packet
		printf ( "[sc_CarSpeed_OnVehicleStreamIn] _for_playerid: %d", _for_playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_HANDLING);

    BS_WriteValue(bitstream, PR_UINT16, _veh_id);
    BS_WriteValue(bitstream, PR_UINT8, 2);
	
    BS_WriteValue(bitstream, PR_UINT8, hp_max_speed);
    BS_WriteValue(bitstream, PR_FLOAT, _max_speed);

    BS_WriteValue(bitstream, PR_UINT8, hp_acceleration);
    BS_WriteValue(bitstream, PR_FLOAT, _max_acceleration);

    PR_SendPacket(bitstream, _for_playerid);

    BS_Delete(bitstream);
}

stock sc_car_component ( _veh_id, E_CUSTOM_COMPONENTS, EXTRA_COMPONENT_ID, STATUS_COMPONENT )
{
	#if defined debug_packet
		printf ( "[sc_car_component]" ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_COMPONENT);

    BS_WriteValue(bitstream, PR_UINT16, _veh_id);
	
    BS_WriteValue(bitstream, PR_UINT8, E_CUSTOM_COMPONENTS);
    BS_WriteValue(bitstream, PR_UINT16, EXTRA_COMPONENT_ID);
	
    BS_WriteValue(bitstream, PR_BOOL, STATUS_COMPONENT);

    PR_SendPacket(bitstream, -1);

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
	
	PR_SendPacket(bitstream, -1);

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
	
	PR_SendPacket(bitstream, playerid);

    BS_Delete(bitstream);
}

stock sc_AddHandling ( _veh_id )
{
	#if defined debug_packet
		printf ( "[sc_AddHandling]" ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_HANDLING);

    BS_WriteValue(bitstream, PR_UINT16, _veh_id);
    BS_WriteValue(bitstream, PR_UINT8, 3);
	
    BS_WriteValue(bitstream, PR_UINT8, hp_suspension_lower_limit);
    BS_WriteValue(bitstream, PR_FLOAT, veh_info [ _veh_id - 1 ] [ v_suspension ] [ 0 ]);

    BS_WriteValue(bitstream, PR_UINT8, hp_suspension_bias);
    BS_WriteValue(bitstream, PR_FLOAT, veh_info [ _veh_id - 1 ] [ v_suspension ] [ 1 ]);
	
	BS_WriteValue(bitstream, PR_UINT8, hp_wheel_size);
    BS_WriteValue(bitstream, PR_FLOAT, veh_info [ _veh_id - 1 ] [ v_wheel_size ]);

    PR_SendPacket(bitstream, -1);

    BS_Delete(bitstream);
}

stock sc_Handling_OnVehicleStreamIn ( _veh_id, _for_playerid, Float: _max_speed, Float: _max_acceleration )
{
	#if defined debug_packet
		printf ( "[sc_Handling_OnVehicleStreamIn] _for_playerid: %d", _for_playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_HANDLING);

    BS_WriteValue(
		bitstream,
		PR_UINT16, _veh_id,
		PR_UINT8, 5,
	
		PR_UINT8, hp_suspension_lower_limit,
		PR_FLOAT, veh_info [ _veh_id - 1 ] [ v_suspension ] [ 0 ],

		PR_UINT8, hp_suspension_bias,
		PR_FLOAT, veh_info [ _veh_id - 1 ] [ v_suspension ] [ 1 ],
	
		PR_UINT8, hp_wheel_size,
		PR_FLOAT, veh_info [ _veh_id - 1 ] [ v_wheel_size ],
	
		PR_UINT8, hp_max_speed,
		PR_FLOAT, _max_speed,

		PR_UINT8, hp_acceleration,
		PR_FLOAT, _max_acceleration);

    PR_SendPacket(bitstream, _for_playerid);

    BS_Delete(bitstream);
}

stock SetVehicleHandling ( playerid, _veh_id, Float: _suspension_1, Float: _suspension_2, Float: _wheel_size )
{
	#if defined debug_packet
		printf ( "[SetVehicleHandling] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_HANDLING);

    BS_WriteValue(bitstream, PR_UINT16, _veh_id);
    BS_WriteValue(bitstream, PR_UINT8, 3);
	
    BS_WriteValue(bitstream, PR_UINT8, hp_suspension_lower_limit);
    BS_WriteValue(bitstream, PR_FLOAT, _suspension_1);

    BS_WriteValue(bitstream, PR_UINT8, hp_suspension_bias);
    BS_WriteValue(bitstream, PR_FLOAT, _suspension_2);
	
	BS_WriteValue(bitstream, PR_UINT8, hp_wheel_size);
    BS_WriteValue(bitstream, PR_FLOAT, _wheel_size);

    PR_SendPacket(bitstream, playerid);

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
	
	new _r, _g, _b ;

    BS_WriteValue(bitstream, PR_UINT16, _veh_id);

	// headlights
	color_converter ( rgb_array [ veh_info [ _veh_id - 1 ] [ v_lights_color ] ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);

	// wheel settings
    BS_WriteValue(
		bitstream,
		PR_UINT16, veh_info [ _veh_id - 1 ] [ v_wheel_width ],
    
		PR_INT8, veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 0 ],
		PR_INT8, veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 1 ],
    
		PR_INT16, veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 0 ],
		PR_INT16, veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 1 ]);
	
	// main color 1
	color_converter ( rgb_array [ veh_info [ _veh_id - 1 ] [ v_color ] [ 0 ] ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);
	
	// main color 2
	color_converter ( rgb_array [ veh_info [ _veh_id - 1 ] [ v_color ] [ 1 ] ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);
	
	// wheel color
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);
	
	// toner color
    BS_WriteValue(
		bitstream,
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 0 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 1 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 2 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 3 ],
	
		PR_UINT8, strlen ( tuning_name_toner ( _veh_id ) ),
		PR_STRING, tuning_name_toner ( _veh_id ) ) ;
	
	// vinyl
	new _vinyl = veh_info [ _veh_id - 1 ] [ v_vinyl ] ;
	BS_WriteValue(bitstream, PR_INT16, veh_info [ _veh_id - 1 ] [ v_vinyl ]);
	
	if ( _vinyl > 0 )
	{
		new _str [ 32 ] ;
		format ( _str, sizeof _str, "v_cust_body_%d", veh_info [ _veh_id - 1 ] [ v_vinyl ] ) ;
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( "gui" ),
			PR_STRING, "gui",
		
			PR_UINT8, strlen ( _str ),
			PR_STRING, _str,
			
			PR_UINT8, strlen ( tuning_name_vinyl ( _veh_id ) ),
			PR_STRING, tuning_name_vinyl ( _veh_id ) ) ;
	}
	
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
	color_converter ( rgb_array [ veh_info [ _veh_id - 1 ] [ v_neon ] ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);
	
	new _neon_type = veh_info [ _veh_id - 1 ] [ v_neon_type ] ;
	BS_WriteValue(bitstream, PR_UINT8, _neon_type);
	
	if ( _neon_type == eNeonTypes_OFF )
	{
		// не отправляем
	}
	else if ( _neon_type == eNeonTypes_ON_TYPE_TEXTURE )
	{
		new tex_name [ 12 ] ;
		format ( tex_name, sizeof tex_name, "neon_%d", veh_info [ _veh_id - 1 ] [ v_neon ] ) ;
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( "txd" ),
			PR_STRING, "txd",
		
			PR_UINT8, strlen ( tex_name ),
			PR_STRING, tex_name ) ;
	}
	else
	{
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( "txd" ),
			PR_STRING, "txd",
			
			PR_UINT8, strlen ( "coronastar" ),
			PR_STRING, "coronastar" ) ;
	}

    PR_SendPacket(bitstream, -1);

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
	
	new _r, _g, _b ;

	// headlights
	color_converter ( rgb_array [ veh_info [ _veh_id - 1 ] [ v_lights_color ] ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);

	// wheel settings
    BS_WriteValue(
		bitstream,
		PR_UINT16, veh_info [ _veh_id - 1 ] [ v_wheel_width ],
    
		PR_INT8, veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 0 ],
		PR_INT8, veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 1 ],
    
		PR_INT16, veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 0 ],
		PR_INT16, veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 1 ]);
	
	// main color 1
	color_converter ( rgb_array [ veh_info [ _veh_id - 1 ] [ v_color ] [ 0 ] ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);
	
	// main color 2
	color_converter ( rgb_array [ veh_info [ _veh_id - 1 ] [ v_color ] [ 1 ] ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);
	
	// wheel color
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);
	
	// toner color
    BS_WriteValue(
		bitstream,
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 0 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 1 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 2 ],
		PR_UINT8, veh_info [ _veh_id - 1 ] [ v_toner ] [ 3 ],
	
		PR_UINT8, strlen ( tuning_name_toner ( _veh_id ) ),
		PR_STRING, tuning_name_toner ( _veh_id ) ) ;
	
	// vinyl
	BS_WriteValue(bitstream, PR_INT16, veh_info [ _veh_id - 1 ] [ v_vinyl ]);
	if ( veh_info [ _veh_id - 1 ] [ v_vinyl ] > 0 )
	{
		new _str [ 32 ] ;
		format ( _str, sizeof _str, "v_cust_body_%d", veh_info [ _veh_id - 1 ] [ v_vinyl ] ) ;
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( "gui" ),
			PR_STRING, "gui",
		
			PR_UINT8, strlen ( _str ),
			PR_STRING, _str,
			
			PR_UINT8, strlen ( tuning_name_vinyl ( _veh_id ) ),
			PR_STRING, tuning_name_vinyl ( _veh_id ) ) ;
	}
	
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
	color_converter ( rgb_array [ veh_info [ _veh_id - 1 ] [ v_neon ] ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);
	
	new _neon_type = veh_info [ _veh_id - 1 ] [ v_neon_type ] ;
	BS_WriteValue(bitstream, PR_UINT8, _neon_type);
	
	if ( _neon_type == eNeonTypes_OFF )
	{
		// не отправляем
	}
	else if ( _neon_type == eNeonTypes_ON_TYPE_TEXTURE )
	{
		new tex_name [ 12 ] ;
		format ( tex_name, sizeof tex_name, "neon_%d", veh_info [ _veh_id - 1 ] [ v_neon ] ) ;
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( "txd" ),
			PR_STRING, "txd",
		
			PR_UINT8, strlen ( tex_name ),
			PR_STRING, tex_name ) ;
	}
	else
	{
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( "txd" ),
			PR_STRING, "txd",
			
			PR_UINT8, strlen ( "coronastar" ),
			PR_STRING, "coronastar" ) ;
	}

    PR_SendPacket(bitstream, _for_playerid);

    BS_Delete(bitstream);
}

stock sc_VehicleDynamicParams ( _veh_id, _for_playerid,
						_lights_color,
						_wheel_width, _wheel_alignment_0, _wheel_alignment_1, _wheel_offset_0, _wheel_offset_1,
						_color_0, _color_1, _color_2,
						_toner_0, _toner_1, _toner_2, _toner_3,
						_vinyl,
						_neon, _neon_type )
{
	#if defined debug_packet
		printf ( "[sc_VehicleDynamicParams] _for_playerid: %d", _for_playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_VISUALS);

    BS_WriteValue(bitstream, PR_UINT16, _veh_id);
	
	new _r, _g, _b ;

	// headlights
	color_converter ( rgb_array [ _lights_color ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);

	// wheel settings
    BS_WriteValue(
		bitstream,
		PR_UINT16, _wheel_width,
    
		PR_INT8, _wheel_alignment_0,
		PR_INT8, _wheel_alignment_1,
    
		PR_INT16, _wheel_offset_0,
		PR_INT16, _wheel_offset_1);
	
	// main color 1
	color_converter ( rgb_array [ _color_0 ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);
	
	// main color 2
	color_converter ( rgb_array [ _color_1 ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);
	
	// wheel color
	color_converter ( rgb_array [ _color_2 ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);
	
	// toner color
    BS_WriteValue(
		bitstream,
		PR_UINT8, _toner_0,
		PR_UINT8, _toner_1,
		PR_UINT8, _toner_2,
		PR_UINT8, _toner_3,
	
		PR_UINT8, strlen ( tuning_name_toner ( _veh_id ) ),
		PR_STRING, tuning_name_toner ( _veh_id ) ) ;
	
	// vinyl
	BS_WriteValue(bitstream, PR_INT16, _vinyl);
	
	if ( _vinyl > 0 )
	{
		new _str [ 32 ] ;
		format ( _str, sizeof _str, "v_cust_body_%d", _vinyl ) ;
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( "gui" ),
			PR_STRING, "gui",
		
			PR_UINT8, strlen ( _str ),
			PR_STRING, _str,
			
			PR_UINT8, strlen ( tuning_name_vinyl ( _veh_id ) ),
			PR_STRING, tuning_name_vinyl ( _veh_id ) ) ;
	}
	
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
	color_converter ( rgb_array [ _neon ], _r, _g, _b ) ;
    BS_WriteValue(
		bitstream,
		PR_UINT8, _r,
		PR_UINT8, _g,
		PR_UINT8, _b);
	
	BS_WriteValue(bitstream, PR_UINT8, _neon_type);
	
	if ( _neon_type == eNeonTypes_OFF )
	{
		// не отправляем
	}
	else if ( _neon_type == eNeonTypes_ON_TYPE_TEXTURE )
	{
		new tex_name [ 12 ] ;
		format ( tex_name, sizeof tex_name, "neon_%d", _neon ) ;
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( "txd" ),
			PR_STRING, "txd",
		
			PR_UINT8, strlen ( tex_name ),
			PR_STRING, tex_name ) ;
	}
	else
	{
		BS_WriteValue(
			bitstream,
			PR_UINT8, strlen ( "txd" ),
			PR_STRING, "txd",
			
			PR_UINT8, strlen ( "coronastar" ),
			PR_STRING, "coronastar" ) ;
	}

    PR_SendPacket(bitstream, _for_playerid);

    BS_Delete(bitstream);
}

stock tuning_valid_toner ( _veh_id )
{
	switch ( getReplacableVehicleModel ( _veh_id ) )
	{
		#if defined SAMP
			case 3201, 3202, 3203, 3204, 3205, 3206, 3207, 3208, 3209, 3210, 3211, 3212, 3213, 3214, 3215, 3216, 3217, 3218, 3224, 3225, 3226, 3227, 3228, 3229, 3230,
				3231, 3232, 3233, 3234, 3235, 3236, 3237, 3238, 3239, 3240: return 1 ;
				
			default: return 0 ;
		#endif
		
		#if defined CRMP
			case 400, 401, 402, 403, 404, 405, 410, 412, 415, 419, 420, 421, 426, 429, 436, 438, 440, 458, 466, 467, 470, 474, 475, 477, 479, 480, 489, 491, 492, 494, 496,
				502, 505, 507, 516, 517, 518, 526, 527, 529, 534, 541, 543, 546, 547, 549, 551, 558, 559, 560, 561, 566, 575, 576, 579, 587, 589, 604, 3352, 3353, 3354, 3356: return 1 ;
				
			case 451, 500, 506, 567, 580, 585, 600, 602, 3230, 3231, 3232, 3316, 3317, 3323, 3324, 3327, 3330, 3331, 3332, 3336: return 1 ;
			
			case 409, 424, 434, 442, 485, 490, 503, 540, 545, 550, 562, 565, 568, 572, 3217, 3226, 3227, 3228, 3233, 3234, 3235, 3236, 3237, 3238, 3239, 3241, 3242,
				3243, 2344, 3245, 3246, 3247, 3250, 3251, 2352, 3253, 3254, 3255, 3257, 3258, 3259, 3260, 3261, 3262, 3263, 3264, 3265, 3266, 3267, 3268, 3269,
				3270, 3271, 3272, 3273, 3275, 3276, 3277, 3279, 3280, 3281, 3282, 3283, 3286, 3287, 3288, 3289, 3290, 3291, 3292, 3293, 3294, 3295, 3296, 3297,
				596, 597, 598, 427, 3355: return 1 ;
				
			case 411, 445, 504, 542, 603, 3229, 3240, 3248, 3249, 3256, 3274, 3284, 3285, 3298, 3299, 3300, 3301, 3302, 3303, 3304, 3305, 3306, 3307, 3308, 3309,
				3310, 3311, 3312, 3313, 3314, 3315, 3318, 3319, 3320, 3321, 3322, 3333, 3334, 3335, 3343, 3344, 3345, 3346, 3357,
				3358, 3359, 3360, 3361, 3362, 3363, 3364, 3365, 3366, 3367, 3368, 3373, 3374, 3375, 3376, 3384: return 1 ;
				
			default: return 0 ;
		#endif
		
		#if defined Matreshka
			case 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 
			431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 
			463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 
			495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 
			527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 
			559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 
			591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611: return 1 ;
		
			default: return 0 ;
		#endif
	}
	return 0 ;
}

stock tuning_name_toner ( _veh_id )
{
	new _toner_name [ 32 ] ;
	switch ( getReplacableVehicleModel ( _veh_id ) )
	{
		#if defined SAMP
			case 3201, 3202, 3203, 3204, 3205, 3206, 3207, 3208, 3209, 3210, 3211, 3212, 3213, 3214, 3215, 3216, 3217, 3218, 3224, 3225, 3226, 3227, 3228, 3229, 3230,
				3231, 3232, 3233, 3234, 3235, 3236, 3237, 3238, 3239, 3240: format ( _toner_name, sizeof _toner_name, "remaptoner" ) ;
				
			default: format ( _toner_name, sizeof _toner_name, "none" ) ;
		#endif
		
		#if defined CRMP
			case 400, 401, 402, 403, 404, 405, 410, 412, 415, 419, 420, 421, 426, 429, 436, 438, 440, 458, 466, 467, 470, 474, 475, 477, 479, 480, 489, 491, 492, 494, 496,
				502, 505, 507, 516, 517, 518, 526, 527, 529, 534, 541, 543, 546, 547, 549, 551, 558, 559, 560, 561, 566, 575, 576, 579, 587, 589, 604, 3352, 3353, 3354, 3356: format ( _toner_name, sizeof _toner_name, "remap_toner_" ) ;
			
			case 451, 500, 506, 567, 580, 585, 600, 602, 3230, 3231, 3232, 3316, 3317, 3323, 3324, 3327, 3330, 3331, 3332, 3336: format ( _toner_name, sizeof _toner_name, "remap_toner" ) ;
			
			case 409, 424, 434, 442, 485, 490, 503, 540, 545, 550, 562, 565, 568, 572, 3217, 3226, 3227, 3228, 3233, 3234, 3235, 3236, 3237, 3238, 3239, 3241, 3242,
				3243, 2344, 3245, 3246, 3247, 3250, 3251, 2352, 3253, 3254, 3255, 3257, 3258, 3259, 3260, 3261, 3262, 3263, 3264, 3265, 3266, 3267, 3268, 3269,
				3270, 3271, 3272, 3273, 3275, 3276, 3277, 3279, 3280, 3281, 3282, 3283, 3286, 3287, 3288, 3289, 3290, 3291, 3292, 3293, 3294, 3295, 3296, 3297,
				596, 597, 598, 427, 3355: format ( _toner_name, sizeof _toner_name, "remap_toner_" ) ;
		
			case 411, 445, 504, 542, 603, 3229, 3240, 3248, 3249, 3256, 3274, 3284, 3285, 3298, 3299, 3300, 3301, 3302, 3303, 3304, 3305, 3306, 3307, 3308, 3309,
				3310, 3311, 3312, 3313, 3314, 3315, 3318, 3319, 3320, 3321, 3322, 3333, 3334, 3335, 3343, 3344, 3345, 3346, 3357,
				3358, 3359, 3360, 3361, 3362, 3363, 3364, 3365, 3366, 3367, 3368, 3373, 3374, 3375, 3376, 3384: format ( _toner_name, sizeof _toner_name, "remaptoner" ) ;
			
			default: format ( _toner_name, sizeof _toner_name, "none" ) ;
		#endif
		
		#if defined Matreshka
			case 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 
			431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 
			463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 
			495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 
			527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 
			559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 
			591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611: format ( _toner_name, sizeof _toner_name, "remap_toner" ) ;
		
			default: format ( _toner_name, sizeof _toner_name, "none" ) ;
		#endif
	}
	return _toner_name ;
}

stock tuning_valid_vinyl ( _veh_id )
{
	switch ( getReplacableVehicleModel ( _veh_id ) )
	{
		#if defined SAMP
			case 3201, 3202, 3203, 3204, 3205, 3206, 3207, 3208, 3209, 3210, 3211, 3212, 3213, 3214, 3215, 3216, 3217, 3218, 3224, 3225, 3226, 3227, 3228, 3229, 3230,
				3231, 3232, 3233, 3234, 3235, 3236, 3237, 3238, 3239, 3240: return 1 ;
		
			default: return 0 ;
		#endif
		
		#if defined CRMP
			case 400, 401, 402, 403, 404, 405, 410, 412, 415, 419, 420, 421, 426, 429, 436, 438, 440, 458, 466, 467, 470, 474, 475, 477, 479, 480, 489, 491, 492, 494, 496,
				502, 505, 507, 516, 517, 518, 526, 527, 529, 534, 541, 543, 546, 547, 549, 551, 558, 559, 560, 561, 566, 575, 576, 579, 587, 589, 604, 3352, 3353, 3354, 3356: return 1 ;
			
			case 451, 500, 506, 567, 580, 585, 600, 602, 3230, 3231, 3232, 3316, 3317, 3323, 3324, 3327, 3330, 3331, 3332, 3336: return 1 ;
			
			case 409, 424, 434, 442, 485, 490, 503, 540, 545, 550, 562, 565, 568, 572, 3217, 3226, 3227, 3228, 3233, 3234, 3235, 3236, 3237, 3238, 3239, 3241, 3242,
				3243, 2344, 3245, 3246, 3247, 3250, 3251, 2352, 3253, 3254, 3255, 3257, 3258, 3259, 3260, 3261, 3262, 3263, 3264, 3265, 3266, 3267, 3268, 3269,
				3270, 3271, 3272, 3273, 3275, 3276, 3277, 3279, 3280, 3281, 3282, 3283, 3286, 3287, 3288, 3289, 3290, 3291, 3292, 3293, 3294, 3295, 3296, 3297, 3355: return 1 ;
				
			case 411, 445, 504, 542, 603, 3229, 3240, 3248, 3249, 3256, 3274, 3284, 3285, 3298, 3299, 3300, 3301, 3302, 3303, 3304, 3305, 3306, 3307, 3308, 3309,
				3310, 3311, 3312, 3313, 3314, 3315, 3318, 3319, 3320, 3321, 3322, 3333, 3334, 3335, 3343, 3344, 3345, 3346, 3357,
				3358, 3359, 3360, 3361, 3362, 3363, 3364, 3365, 3366, 3367, 3368, 3373, 3374, 3375, 3376, 3384: return 1 ;
		
			default: return 0 ;
		#endif
		
		#if defined Matreshka
			case 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 
			431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 
			463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 
			495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 
			527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 
			559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 
			591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611: return 1 ;
		
			default: return 0 ;
		#endif
	}
	return 0 ;
}

stock tuning_name_vinyl ( _veh_id )
{
	new _vinyl_name [ 32 ] ;
	switch ( getReplacableVehicleModel ( _veh_id ) )
	{
		#if defined SAMP
			case 3201, 3202, 3203, 3204, 3205, 3206, 3207, 3208, 3209, 3210, 3211, 3212, 3213, 3214, 3215, 3216, 3217, 3218, 3224, 3225, 3226, 3227, 3228, 3229, 3230,
				3231, 3232, 3233, 3234, 3235, 3236, 3237, 3238, 3239, 3240: format ( _vinyl_name, sizeof _vinyl_name, "remapvehicles" ) ;
				
			default: format ( _vinyl_name, sizeof _vinyl_name, "none" ) ;
		#endif
		
		#if defined CRMP
			case 400, 401, 402, 403, 404, 405, 410, 412, 415, 419, 420, 421, 426, 429, 436, 438, 440, 458, 466, 467, 470, 474, 475, 477, 479, 480, 489, 491, 492, 494, 496,
				502, 505, 507, 516, 517, 518, 526, 527, 529, 534, 541, 543, 546, 547, 549, 551, 558, 559, 560, 561, 566, 575, 576, 579, 587, 589, 604, 3352, 3353, 3354, 3356: format ( _vinyl_name, sizeof _vinyl_name, "remap_cbody_0" ) ;
			
			case 451, 500, 506, 567, 580, 585, 600, 602, 3230, 3231, 3232, 3316, 3317, 3323, 3324, 3327, 3330, 3331, 3332, 3336: format ( _vinyl_name, sizeof _vinyl_name, "remap_body" ) ;
			
			case 409, 424, 434, 442, 485, 490, 503, 540, 545, 550, 562, 565, 568, 572, 3217, 3226, 3227, 3228, 3233, 3234, 3235, 3236, 3237, 3238, 3239, 3241, 3242,
				3243, 2344, 3245, 3246, 3247, 3250, 3251, 2352, 3253, 3254, 3255, 3257, 3258, 3259, 3260, 3261, 3262, 3263, 3264, 3265, 3266, 3267, 3268, 3269,
				3270, 3271, 3272, 3273, 3275, 3276, 3277, 3279, 3280, 3281, 3282, 3283, 3286, 3287, 3288, 3289, 3290, 3291, 3292, 3293, 3294, 3295, 3296, 3297, 3355: format ( _vinyl_name, sizeof _vinyl_name, "remap_cbody_0" ) ;
			
			case 411, 445, 504, 542, 603, 3229, 3240, 3248, 3249, 3256, 3274, 3284, 3285, 3298, 3299, 3300, 3301, 3302, 3303, 3304, 3305, 3306, 3307, 3308, 3309,
				3310, 3311, 3312, 3313, 3314, 3315, 3318, 3319, 3320, 3321, 3322, 3333, 3334, 3335, 3343, 3344, 3345, 3346, 3357,
				3358, 3359, 3360, 3361, 3362, 3363, 3364, 3365, 3366, 3367, 3368, 3373, 3374, 3375, 3376, 3384: format ( _vinyl_name, sizeof _vinyl_name, "remapvehicles" ) ;
			
			default: format ( _vinyl_name, sizeof _vinyl_name, "none" ) ;
		#endif
		
		#if defined Matreshka
			case 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 
			431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 
			463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 
			495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 
			527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 
			559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 
			591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611: format ( _vinyl_name, sizeof _vinyl_name, "remap_body" ) ;
		
			default: format ( _vinyl_name, sizeof _vinyl_name, "none" ) ;
		#endif
	}
	return _vinyl_name ;
}