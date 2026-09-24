enum
{
    NEON_TYPE_NONE = 0,
    NEON_TYPE_STATIC = 1,			// просто цвет
    NEON_TYPE_IRIDESCENT = 2,		// переливается цветами
    NEON_TYPE_BLINKING = 3,			// моргает
    NEON_TYPE_CUTTING = 4			// рандомный цвет
} ;

enum
{
    TUNING_CENTER_NEON_TYPE = 0,
    TUNING_CENTER_NEON_COLOR = 1,
    TUNING_CENTER_LIGHT_COLOR = 2,
    TUNING_CENTER_TINTING_COLOR = 3,
    TUNING_CENTER_BODY_PAINT_COLOR = 4,
    TUNING_CENTER_DISK_COLOR = 6,
    TUNING_CENTER_VINYL = 7,
    TUNING_CENTER_STROB_LIGHT = 8,
    TUNING_CENTER_NITRO = 9
} ;

enum
{
    TIRE_CENTER_SUSPENSION_HEIGHT,
    TIRE_CENTER_WHEEL_DIAMETER,
    TIRE_CENTER_WHEEL_WIDTH,
    TIRE_CENTER_WHEEL_ALIGN_FRONT,
    TIRE_CENTER_WHEEL_ALIGN_BACK,
    TIRE_CENTER_SPACERS
} ;

stock RGBA ( red, green, blue, alpha )
{
	return ( ( ( red & 0xFF ) << 24 ) | ( ( green & 0xFF ) << 16 ) | ( ( blue & 0xFF ) << 8 ) | ( alpha & 0xFF ) ) ;
}

stock parseRGBA ( color, &r, &g, &b, &a ) 
{
	r = ( color >> 24 ) & 0xFF ;
	g = ( color >> 16 ) & 0xFF ;
	b = ( color >> 8 ) & 0xFF ;
	a = color & 0xFF ;
}

stock rgbaToColorInt ( red, green, blue ) 
{
    return ( red << 16 ) | ( green << 8 ) | blue ;
}

stock color_converter ( hexValue, &r, &g, &b )
{
    r = 256 + ( ( hexValue & 0xFF000000 ) >> 24 ) ;

    if ( r > 255 )
        r -= 256 ;

    g = ( hexValue & 0x00ff0000 ) >> 16 ;
    b = ( hexValue & 0x0000ff00 ) >> 8 ;
}

#define MAX_VEHICLE_MODELS				700

enum E_VEHICLE_HANDLING
{
    VEHICLE_HP_MAX_SPEED,
    VEHICLE_HP_ACCELERATION,
    VEHICLE_HP_GEAR,
    VEHICLE_HP_ENGINE_INERTION,
    VEHICLE_HP_MASS,
    VEHICLE_HP_MASS_TURN,
    VEHICLE_HP_BRAKE_DECELERATION,
    VEHICLE_HP_TRACTION_MULTIPLIER,
    VEHICLE_HP_TRACTION_LOSS,
    VEHICLE_HP_TRACTION_BIAS,
    VEHICLE_HP_SUS_LOWER_LIMIT,
    VEHICLE_HP_SUS_BIAS,
    VEHICLE_HP_WHEEL_SIZE,
    VEHICLE_HP_MAX,
    VEHICLE_HP_COUNT,
    VEHICLE_HP_WHEEL_WIDTH,
    VEHICLE_HP_WHEEL_ALIGN_FRONT,
    VEHICLE_HP_WHEEL_ALIGN_BACK,
    VEHICLE_HP_SPACERS
} ;

new veh_handling [ MAX_VEHICLE_MODELS ] [ E_VEHICLE_HANDLING ] ;

enum
{
    VEHICLE_FUEL_TYPE_92 = 1,
    VEHICLE_FUEL_TYPE_95 = 2,
    VEHICLE_FUEL_TYPE_98 = 3,
    VEHICLE_FUEL_TYPE_DT = 4,
    VEHICLE_FUEL_TYPE_CHARGE = 5
} ;

enum
{
	VEHICLE_CLASS_LOW = 1,
	VEHICLE_CLASS_MEDIUM = 2,
	VEHICLE_CLASS_HIGH = 3,
	VEHICLE_CLASS_DONATE = 4,
	VEHICLE_CLASS_TRUCK = 5,
	VEHICLE_CLASS_BOAT = 6,
	VEHICLE_CLASS_FLY = 7,
	VEHICLE_CLASS_MOTO = 8,
	VEHICLE_CLASS_OTHER = 9,
	VEHICLE_CLASS_MAX = 10
} ;

enum _veh_data
{
	VEHICLE_REPLACE,
	VEHICLE_NAME [ 32 ],
	VEHICLE_PRICE,
	VEHICLE_TRUNK_CAPACITY,
	VEHICLE_CLASS_ID,
	VEHICLE_FUEL_TYPE_ID,

	VEHICLE_DUMMY_COUNT [ CAR_COMPONENT_MAX ],
	VEHICLE_DUMMY_SIZE,

	bool: VEHICLE_USED
} ;
new veh_data [ MAX_VEHICLE_MODELS ] [ _veh_data ] ;

#define GetVehicleDataDummy(%0,%1) 		veh_data[%0][VEHICLE_DUMMY_COUNT][%1]
#define GetVehicleDataDummySize(%0)		veh_data[%0][VEHICLE_DUMMY_SIZE]

new g_VehicleColoursTableRGBA [ 256 ] = 
{
    // The existing colours from "data/carcols.dat"
    0x000000FF, 0xF5F5F5FF, 0x2A77A1FF, 0x840410FF, 0x263739FF, 0x86446EFF, 0xD78E10FF, 0x4C75B7FF, 0xBDBEC6FF, 0x5E7072FF,
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
    0x9B8B80FF, 0x620B1CFF, 0x5B5D5EFF, 0x624428FF, 0x731827FF, 0x1B376DFF, 0xEC6AAEFF, 0x000000FF,
    // SA-MP extended colours (0.3x)
    0x177517FF, 0x210606FF, 0x125478FF, 0x452A0DFF, 0x571E1EFF, 0x010701FF, 0x25225AFF, 0x2C89AAFF, 0x8A4DBDFF, 0x35963AFF,
    0xB7B7B7FF, 0x464C8DFF, 0x84888CFF, 0x817867FF, 0x817A26FF, 0x6A506FFF, 0x583E6FFF, 0x8CB972FF, 0x824F78FF, 0x6D276AFF,
    0x1E1D13FF, 0x1E1306FF, 0x1F2518FF, 0x2C4531FF, 0x1E4C99FF, 0x2E5F43FF, 0x1E9948FF, 0x1E9999FF, 0x999976FF, 0x7C8499FF,
    0x992E1EFF, 0x2C1E08FF, 0x142407FF, 0x993E4DFF, 0x1E4C99FF, 0x198181FF, 0x1A292AFF, 0x16616FFF, 0x1B6687FF, 0x6C3F99FF,
    0x481A0EFF, 0x7A7399FF, 0x746D99FF, 0x53387EFF, 0x222407FF, 0x3E190CFF, 0x46210EFF, 0x991E1EFF, 0x8D4C8DFF, 0x805B80FF,
    0x7B3E7EFF, 0x3C1737FF, 0x733517FF, 0x781818FF, 0x83341AFF, 0x8E2F1CFF, 0x7E3E53FF, 0x7C6D7CFF, 0x020C02FF, 0x072407FF,
    0x163012FF, 0x16301BFF, 0x642B4FFF, 0x368452FF, 0x999590FF, 0x818D96FF, 0x99991EFF, 0x7F994CFF, 0x839292FF, 0x788222FF,
    0x2B3C99FF, 0x3A3A0BFF, 0x8A794EFF, 0x0E1F49FF, 0x15371CFF, 0x15273AFF, 0x375775FF, 0x060820FF, 0x071326FF, 0x20394BFF,
    0x2C5089FF, 0x15426CFF, 0x103250FF, 0x241663FF, 0x692015FF, 0x8C8D94FF, 0x516013FF, 0x090F02FF, 0x8C573AFF, 0x52888EFF,
    0x995C52FF, 0x99581EFF, 0x993A63FF, 0x998F4EFF, 0x99311EFF, 0x0D1842FF, 0x521E1EFF, 0x42420DFF, 0x4C991EFF, 0x082A1DFF,
    0x96821DFF, 0x197F19FF, 0x3B141FFF, 0x745217FF, 0x893F8DFF, 0x7E1A6CFF, 0x0B370BFF, 0x27450DFF, 0x071F24FF, 0x784573FF,
    0x8A653AFF, 0x732617FF, 0x319490FF, 0x56941DFF, 0x59163DFF, 0x1B8A2FFF, 0x38160BFF, 0x041804FF, 0x355D8EFF, 0x2E3F5BFF,
    0x561A28FF, 0x4E0E27FF, 0x706C67FF, 0x3B3E42FF, 0x2E2D33FF, 0x7B7E7DFF, 0x4A4442FF, 0x28344EFF
} ;

stock SetVehicleDataAll ( vehicleid )
{
	new modelid = getVehicleOrdinalNumber ( vehicleid ),
		color1 = veh_info [ vehicleid - 1 ] [ v_color ] [ 0 ] ;

	if ( veh_handling [ modelid ] [ VEHICLE_HP_MAX_SPEED ] < 1 ) modelid = 466 ;

	veh_info [ vehicleid - 1 ] [ v_plate_type ] = 1 ;

	veh_info [ vehicleid - 1 ] [ v_main_color ] [ 0 ] = ( g_VehicleColoursTableRGBA [ color1 ] >> 24 ) & 0xFF ;
	veh_info [ vehicleid - 1 ] [ v_main_color ] [ 1 ] = ( g_VehicleColoursTableRGBA [ color1 ] >> 16 ) & 0xFF ;
	veh_info [ vehicleid - 1 ] [ v_main_color ] [ 2 ] = ( g_VehicleColoursTableRGBA [ color1 ] >> 8 ) & 0xFF ;

	veh_info [ vehicleid - 1 ] [ v_disk_color ] [ 0 ] =
	veh_info [ vehicleid - 1 ] [ v_disk_color ] [ 1 ] =
	veh_info [ vehicleid - 1 ] [ v_disk_color ] [ 2 ] = 0 ;

	veh_info [ vehicleid - 1 ] [ v_lights_color ] [ 0 ] =
	veh_info [ vehicleid - 1 ] [ v_lights_color ] [ 1 ] =
	veh_info [ vehicleid - 1 ] [ v_lights_color ] [ 2 ] = 255 ;

	veh_info [ vehicleid - 1 ] [ v_neon ] [ 0 ] =
	veh_info [ vehicleid - 1 ] [ v_neon ] [ 1 ] =
	veh_info [ vehicleid - 1 ] [ v_neon ] [ 2 ] =
	veh_info [ vehicleid - 1 ] [ v_neon_type ] = 0 ;

	veh_info [ vehicleid - 1 ] [ v_toner ] [ 0 ] =
	veh_info [ vehicleid - 1 ] [ v_toner ] [ 1 ] =
	veh_info [ vehicleid - 1 ] [ v_toner ] [ 2 ] = 0 ;
	veh_info [ vehicleid - 1 ] [ v_toner ] [ 3 ] = 100 ;

	veh_info [ vehicleid - 1 ] [ v_strobs ] =
	veh_info [ vehicleid - 1 ] [ v_pantera_strobs ] =
	veh_info [ vehicleid - 1 ] [ v_vinyl ] = 0 ;

	veh_info [ vehicleid - 1 ] [ v_sound ] = INVALID_PLAYER_ID ;

	veh_info [ vehicleid - 1 ] [ V_HP_MAX_SPEED ] = veh_handling [ modelid ] [ VEHICLE_HP_MAX_SPEED ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_ACCELERATION ] = veh_handling [ modelid ] [ VEHICLE_HP_ACCELERATION ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_GEAR ] = veh_handling [ modelid ] [ VEHICLE_HP_GEAR ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_ENGINE_INERTION ] = veh_handling [ modelid ] [ VEHICLE_HP_ENGINE_INERTION ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_MASS ] = veh_handling [ modelid ] [ VEHICLE_HP_MASS ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_MASS_TURN ] = veh_handling [ modelid ] [ VEHICLE_HP_MASS_TURN ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_BRAKE_DECELERATION ] = veh_handling [ modelid ] [ VEHICLE_HP_BRAKE_DECELERATION ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_TRACTION_MULTIPLIER ] = veh_handling [ modelid ] [ VEHICLE_HP_TRACTION_MULTIPLIER ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_TRACTION_LOSS ] = veh_handling [ modelid ] [ VEHICLE_HP_TRACTION_LOSS ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_TRACTION_BIAS ] = veh_handling [ modelid ] [ VEHICLE_HP_TRACTION_BIAS ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_SUS_LOWER_LIMIT ] = veh_handling [ modelid ] [ VEHICLE_HP_SUS_LOWER_LIMIT ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_SUS_BIAS ] = veh_handling [ modelid ] [ VEHICLE_HP_SUS_BIAS ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_WHEEL_SIZE ] = veh_handling [ modelid ] [ VEHICLE_HP_WHEEL_SIZE ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_MAX ] = veh_handling [ modelid ] [ VEHICLE_HP_MAX ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_COUNT ] = veh_handling [ modelid ] [ VEHICLE_HP_COUNT ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_WHEEL_WIDTH ] = veh_handling [ modelid ] [ VEHICLE_HP_WHEEL_WIDTH ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_WHEEL_ALIGN_FRONT ] = veh_handling [ modelid ] [ VEHICLE_HP_WHEEL_ALIGN_FRONT ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_WHEEL_ALIGN_BACK ] = veh_handling [ modelid ] [ VEHICLE_HP_WHEEL_ALIGN_BACK ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_SPACERS ] = veh_handling [ modelid ] [ VEHICLE_HP_SPACERS ] ;
	
	veh_info [ vehicleid - 1 ] [ V_DUMMY_INFO ] = clearDummyInfo ;
}

stock reInitVehicleData ( vehicleid, toVehicleid )
{
	veh_info [ vehicleid - 1 ] [ V_HP_MAX_SPEED ] = veh_info [ toVehicleid - 1 ] [ V_HP_MAX_SPEED ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_ACCELERATION ] = veh_info [ toVehicleid - 1 ] [ V_HP_ACCELERATION ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_GEAR ] = veh_info [ toVehicleid - 1 ] [ V_HP_GEAR ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_ENGINE_INERTION ] = veh_info [ toVehicleid - 1 ] [ V_HP_ENGINE_INERTION ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_MASS ] = veh_info [ toVehicleid - 1 ] [ V_HP_MASS ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_MASS_TURN ] = veh_info [ toVehicleid - 1 ] [ V_HP_MASS_TURN ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_BRAKE_DECELERATION ] = veh_info [ toVehicleid - 1 ] [ V_HP_BRAKE_DECELERATION ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_TRACTION_MULTIPLIER ] = veh_info [ toVehicleid - 1 ] [ V_HP_TRACTION_MULTIPLIER ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_TRACTION_LOSS ] = veh_info [ toVehicleid - 1 ] [ V_HP_TRACTION_LOSS ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_TRACTION_BIAS ] = veh_info [ toVehicleid - 1 ] [ V_HP_TRACTION_BIAS ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_SUS_LOWER_LIMIT ] = veh_info [ toVehicleid - 1 ] [ V_HP_SUS_LOWER_LIMIT ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_SUS_BIAS ] = veh_info [ toVehicleid - 1 ] [ V_HP_SUS_BIAS ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_WHEEL_SIZE ] = veh_info [ toVehicleid - 1 ] [ V_HP_WHEEL_SIZE ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_MAX ] = veh_info [ toVehicleid - 1 ] [ V_HP_MAX ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_COUNT ] = veh_info [ toVehicleid - 1 ] [ V_HP_COUNT ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_WHEEL_WIDTH ] = veh_info [ toVehicleid - 1 ] [ V_HP_WHEEL_WIDTH ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_WHEEL_ALIGN_FRONT ] = veh_info [ toVehicleid - 1 ] [ V_HP_WHEEL_ALIGN_FRONT ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_WHEEL_ALIGN_BACK ] = veh_info [ toVehicleid - 1 ] [ V_HP_WHEEL_ALIGN_BACK ] ;
	veh_info [ vehicleid - 1 ] [ V_HP_SPACERS ] = veh_info [ toVehicleid - 1 ] [ V_HP_SPACERS ] ;
}

stock GetVehicleModelEx ( vehicleId, modelId = 0 )
{
	new replaceId ;
	if ( vehicleId == INVALID_VEHICLE_ID ) replaceId = modelId ;
	else
	{
		modelId = veh_info [ vehicleId - 1 ] [ v_model ] ;
		replaceId = modelId ;
	}
	
	return replaceId ;
}
#define GetVehicleModel GetVehicleModelEx

stock GetVehicleNameEx ( vehicleId, modelId = 0 )
{
	new replaceId, vehicleName [ 32 ] ;
	if ( vehicleId == INVALID_VEHICLE_ID )
	{
		replaceId = modelId ;
		format ( vehicleName, sizeof vehicleName, "%s", veh_data [ replaceId ] [ VEHICLE_NAME ] ) ;
	}
	else
	{
		modelId = veh_info [ vehicleId - 1 ] [ v_model ] ;
		replaceId = modelId ;
		format ( vehicleName, sizeof vehicleName, "%s", veh_data [ replaceId ] [ VEHICLE_NAME ] ) ;
	}
	
	return vehicleName ;
}

stock getValidReplacableModel ( modelId )
{
	if ( ! veh_data [ modelId ] [ VEHICLE_USED ] ) return 0 ;

	new replaceId = modelId ;
	return replaceId ;
}

stock getReplacableVehicleModel ( vehicleId )
{
	new modelId = veh_info [ vehicleId - 1 ] [ v_model ], replaceId = 0 ;
	if ( veh_data [ modelId ] [ VEHICLE_REPLACE ] ) replaceId = veh_data [ modelId ] [ VEHICLE_REPLACE ] ;
    return replaceId ;
}

stock getReplacableVehicleCreate ( modelId )
{
	if ( veh_data [ modelId ] [ VEHICLE_REPLACE ] ) modelId = veh_data [ modelId ] [ VEHICLE_REPLACE ] ;
    return modelId ;
}

stock getVehicleOrdinalNumber ( vehicleId )
{
	new modelId = veh_info [ vehicleId - 1 ] [ v_model ] ;
	return modelId ;
}

stock GetModelPrice ( modelId )
{
	return veh_data [ modelId ] [ VEHICLE_PRICE ] ;
}

stock getTrunkCapacity ( vehicleId, modelId = 0 )
{
	new capacity ;
	if ( vehicleId == INVALID_VEHICLE_ID ) capacity = veh_data [ modelId ] [ VEHICLE_TRUNK_CAPACITY ] ;
	else
	{
		modelId = veh_info [ vehicleId - 1 ] [ v_model ] ;
		capacity = veh_data [ modelId ] [ VEHICLE_TRUNK_CAPACITY ] ;
	}
	return capacity ;
}

enum
{
	VEHICLE_STATE_CAR,
	VEHICLE_STATE_BIKE,
	VEHICLE_STATE_VELIK,
	VEHICLE_STATE_PLANE,
	VEHICLE_STATE_BOAT,
	VEHICLE_STATE_MOPED,
	VEHICLE_STATE_TRAIN
} ;

stock getVehicleSubtype ( vehicleId, modelId = 0 )
{
	if ( vehicleId != INVALID_VEHICLE_ID ) modelId = veh_info [ vehicleId - 1 ] [ v_model ] ;
	if ( modelId != 0 )
	{
		switch ( modelId )
		{
		    case 430, 446, 452, 453, 454, 472, 473, 484, 493: return VEHICLE_STATE_BOAT ;
			case 417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553,
				 563, 577, 592, 593: return VEHICLE_STATE_PLANE ;
			case 581, 522, 461, 521, 523, 463, 468, 471, 586: return VEHICLE_STATE_BIKE ;
			case 509, 481, 510: return VEHICLE_STATE_VELIK ;
			case 462, 448: return VEHICLE_STATE_MOPED ;
			case 538, 537: return VEHICLE_STATE_TRAIN ;
			default: return VEHICLE_STATE_CAR ;
		}
	}
	return -1 ;
}