

/*

	Tuning

*/

new Float: tuning_camera_positions [ 12 ] [ 6 ] =
{
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 }, //цвет/дефолт
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 }, //покрасочные работы
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 }, //выхлоп
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 }, //кенгурятник
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 }, //Крыша
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 }, //передний бампер
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 }, //задний бампер
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 }, //спойлер
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 }, //боковые юбки
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 }, //колёса
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 }, //Гидравлика
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 } // Нитро
} ;

new Float: component_shop_camera [ CAR_COMPONENT_EXTRA ] [ 6 ] =
{
	{ -1.399, 228.423, 952.000, 4.407, 228.616, 951.011 }, // CAR_COMPONENT_BUMPER_FRONT
	{ 9.506, 227.234, 952.000, 4.407, 228.616, 951.011 }, // CAR_COMPONENT_BUMPER_REAR
	{ 0.971, 225.347, 952.000, 4.407, 228.616, 951.011 }, // CAR_COMPONENT_FENDER_FRONT
	{ 0.971, 225.347, 952.000, 4.407, 228.616, 951.011 }, // CAR_COMPONENT_FENDER_REAR
	{ 9.506, 227.234, 952.000, 4.407, 228.616, 951.011 }, // CAR_COMPONENT_SPOILER
	{ 9.506, 227.234, 952.000, 4.407, 228.616, 951.011 }, // CAR_COMPONENT_EXHAUST
	{ -1.399, 228.423, 952.000, 4.407, 228.616, 951.011 }, // CAR_COMPONENT_ROOF
	{ 9.506, 227.234, 952.000, 4.407, 228.616, 951.011 }, // CAR_COMPONENT_TAILLIGHTS
	{ -1.399, 228.423, 952.000, 4.407, 228.616, 951.011 }, // CAR_COMPONENT_HEADLIGHTS

	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 }, // CAR_COMPONENT_DIFFUSER
	{ -4.516, 227.588, 953.000, 4.407, 228.616, 951.011 } // CAR_COMPONENT_SPLITTER
} ;
 
new Float: tuning_position [ 4 ] = { 4.407, 228.616, 951.011, 73.952 } ;
new Float: position_text_exit_tuning [ 3 ] = { -199.0709, 174.9819, 1201.0000 } ;

#define tuning_interior			24

#define type_default_tuning 	1
#define type_perfromance 		2
#define type_pantera_security	3

enum _tuning
{
	Float: t_pos [ 3 ],
	Float: t_exit_pos [ 4 ],
	t_b_id,
	t_type,
	t_area
} ;

#define MAX_BUSINESS_TUNING 5
new Float: tuning_info [ MAX_BUSINESS_TUNING ] [ _tuning ] =
{
	{ { 2429.2937, -2307.0330, 21.9400 }, { 2425.7493, -2301.6592, 22.0140, 91.6745 }, 1, type_default_tuning },
	{ { -2015.7323, -158.9904, 29.2034 }, { -2017.3889, -152.6859, 29.2763, 78.6954 }, 2, type_default_tuning },
	{ { 2346.6987, -2610.1125, 21.7845 }, { 2348.7939, -2625.4025, 22.1669, 347.8219 }, 120, type_default_tuning },
	
	{ { 1742.085, 2265.166, 15.700 }, { 1749.518, 2275.923, 15.701, 178.272 }, 3, type_perfromance },
	{ { 221.5415, 1479.5183, 11.9219 }, { 219.4406, 1485.2623, 11.9971, 83.2117 }, 110, type_perfromance }
} ;

stock GetTuningIdx ( businessId )
{
	new idx = -1 ;
	for ( new i = 0 ; i < MAX_BUSINESS_TUNING ; i ++ )
	{
		if ( tuning_info [ i ] [ t_b_id ] != businessId ) continue ;

		idx = i ;
		break ;
	}
	return idx ;
}

stock switch_camera ( playerid, cam_pos, select_cam )
{
    InterpolateCameraPos ( playerid, tuning_camera_positions [ cam_pos ] [ 0 ], tuning_camera_positions [ cam_pos ] [ 1 ], tuning_camera_positions [ _position ] [ cam_pos ] [ 2 ], tuning_camera_positions [ select_cam ] [ 0 ], tuning_camera_positions [ select_cam ] [ 1 ], tuning_camera_positions [ select_cam ] [ 2 ], 10000, CAMERA_MOVE ) ;
	InterpolateCameraLookAt ( playerid, tuning_camera_positions [ cam_pos ] [ 3 ], tuning_camera_positions [ cam_pos ] [ 4 ], tuning_camera_positions [ _position ] [ cam_pos ] [ 5 ], tuning_camera_positions [ select_cam ] [ 3 ], tuning_camera_positions [ select_cam ] [ 4 ], tuning_camera_positions [ select_cam ] [ 5 ], 10000, CAMERA_MOVE ) ;
	return 1 ;
}

stock clear_car_handling ( _v_id, _v_model )
{
	veh_info [ _v_id - 1 ] [ V_HP_MAX_SPEED ] = veh_handling [ _v_model ] [ VEHICLE_HP_MAX_SPEED ] ;
	veh_info [ _v_id - 1 ] [ V_HP_ACCELERATION ] = veh_handling [ _v_model ] [ VEHICLE_HP_ACCELERATION ] ;
	veh_info [ _v_id - 1 ] [ V_HP_GEAR ] = veh_handling [ _v_model ] [ VEHICLE_HP_GEAR ] ;
	veh_info [ _v_id - 1 ] [ V_HP_ENGINE_INERTION ] = veh_handling [ _v_model ] [ VEHICLE_HP_ENGINE_INERTION ] ;
	veh_info [ _v_id - 1 ] [ V_HP_MASS ] = veh_handling [ _v_model ] [ VEHICLE_HP_MASS ] ;
	veh_info [ _v_id - 1 ] [ V_HP_MASS_TURN ] = veh_handling [ _v_model ] [ VEHICLE_HP_MASS_TURN ] ;
	veh_info [ _v_id - 1 ] [ V_HP_BRAKE_DECELERATION ] = veh_handling [ _v_model ] [ VEHICLE_HP_BRAKE_DECELERATION ] ;
	veh_info [ _v_id - 1 ] [ V_HP_TRACTION_MULTIPLIER ] = veh_handling [ _v_model ] [ VEHICLE_HP_TRACTION_MULTIPLIER ] ;
	veh_info [ _v_id - 1 ] [ V_HP_TRACTION_LOSS ] = veh_handling [ _v_model ] [ VEHICLE_HP_TRACTION_LOSS ] ;
	veh_info [ _v_id - 1 ] [ V_HP_TRACTION_BIAS ] = veh_handling [ _v_model ] [ VEHICLE_HP_TRACTION_BIAS ] ;
	veh_info [ _v_id - 1 ] [ V_HP_SUS_LOWER_LIMIT ] = veh_handling [ _v_model ] [ VEHICLE_HP_SUS_LOWER_LIMIT ] ;
	veh_info [ _v_id - 1 ] [ V_HP_SUS_BIAS ] = veh_handling [ _v_model ] [ VEHICLE_HP_SUS_BIAS ] ;
	veh_info [ _v_id - 1 ] [ V_HP_WHEEL_SIZE ] = veh_handling [ _v_model ] [ VEHICLE_HP_WHEEL_SIZE ] ;
	veh_info [ _v_id - 1 ] [ V_HP_MAX ] = veh_handling [ _v_model ] [ VEHICLE_HP_MAX ] ;
	veh_info [ _v_id - 1 ] [ V_HP_COUNT ] = veh_handling [ _v_model ] [ VEHICLE_HP_COUNT ] ;
	veh_info [ _v_id - 1 ] [ V_HP_WHEEL_WIDTH ] = veh_handling [ _v_model ] [ VEHICLE_HP_WHEEL_WIDTH ] ;
	veh_info [ _v_id - 1 ] [ V_HP_WHEEL_ALIGN_FRONT ] = veh_handling [ _v_model ] [ VEHICLE_HP_WHEEL_ALIGN_FRONT ] ;
	veh_info [ _v_id - 1 ] [ V_HP_WHEEL_ALIGN_BACK ] = veh_handling [ _v_model ] [ VEHICLE_HP_WHEEL_ALIGN_BACK ] ;
	veh_info [ _v_id - 1 ] [ V_HP_SPACERS ] = veh_handling [ _v_model ] [ VEHICLE_HP_SPACERS ] ;
}