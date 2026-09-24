/*

	ALTER TABLE `users_vehicles` ADD `v_suspension` VARCHAR(20) NOT NULL DEFAULT '0.0|0.0', ADD `v_wheel_size` FLOAT NOT NULL DEFAULT '0.0', ADD `v_wheel_width` INT(4) NOT NULL DEFAULT '0', ADD `v_wheel_alignment` VARCHAR(20) NOT NULL DEFAULT '0.0|0.0', ADD `v_wheel_offset` VARCHAR(20) NOT NULL DEFAULT '0.0|0.0', ADD `v_lights_color` INT(4) NOT NULL DEFAULT '0', ADD `v_shadow_color` INT(4) NOT NULL DEFAULT '0', ADD `v_toner` INT(4) NOT NULL DEFAULT '0', ADD `v_vinyl` INT(4) NOT NULL DEFAULT '0'; 


	new sscanf_delimit [ 126 ] ;
	cache_get_field_content ( i, "v_suspension", sscanf_delimit, sql_connection, 20 ) ;
	sscanf ( sscanf_delimit, "p<|>ff", veh_info [ veh_id - 1 ] [ v_suspension ] [ 0 ], veh_info [ veh_id - 1 ] [ v_suspension ] [ 1 ] ) ;
	
	veh_info [ veh_id - 1 ] [ v_wheel_size ] = cache_get_field_content_float ( i, "v_wheel_size", sql_connection ) ;
	veh_info [ veh_id - 1 ] [ v_wheel_width ] = cache_get_field_content_int ( i, "v_wheel_width", sql_connection ) ;
	
	cache_get_field_content ( i, "v_wheel_alignment", sscanf_delimit, sql_connection, 20 ) ;
	sscanf ( sscanf_delimit, "p<|>dd", veh_info [ veh_id - 1 ] [ v_wheel_alignment ] [ 0 ], veh_info [ veh_id - 1 ] [ v_wheel_alignment ] [ 1 ] ) ;
	
	cache_get_field_content ( i, "v_wheel_offset", sscanf_delimit, sql_connection, 20 ) ;
	sscanf ( sscanf_delimit, "p<|>dd", veh_info [ veh_id - 1 ] [ v_wheel_offset ] [ 0 ], veh_info [ veh_id - 1 ] [ v_wheel_offset ] [ 1 ] ) ;
	
	veh_info [ veh_id - 1 ] [ v_lights_color ] = cache_get_field_content_int ( i, "v_lights_color", sql_connection ) ;
	veh_info [ veh_id - 1 ] [ v_shadow_color ] = cache_get_field_content_int ( i, "v_shadow_color", sql_connection ) ;
	veh_info [ veh_id - 1 ] [ v_toner ] = cache_get_field_content_int ( i, "v_toner", sql_connection ) ;
	veh_info [ veh_id - 1 ] [ v_vinyl ] = cache_get_field_content_int ( i, "v_vinyl", sql_connection ) ;

*/

#define ofm_formula_tuning(%1)	(%1 * 12) // + 1

#define color_select_tune		0xFFD700FF
#define color_default_tune		0x000000FF

#include <custom/customtune>

const Float: default_lowerlimit = 0.03 ;
const Float: default_suspbias = 0.20 ;
const Float: default_wheelsize = 0.80 ;
const default_wheelwidth = 105 ;
const default_wheelalignment = 0 ;
const default_wheeloffset = 0 ;

new custom_name [ ] [ 24 ] =
{
	"LOWER LIMIT",
	"SUSPENSION BIAS",
	"WHEEL SIZE",
	"WHEEL WIDTH",
	"WHEEL ALIGNMENT (F)",
	"WHEEL ALIGNMENT (R)",
	"WHEEL OFFSET (F)",
	"WHEEL OFFSET (R)",
	"LIGHTS COLOR",
	"NEON COLOR",
	"TONER",
	"VINYL",
	"NEON IMG"
} ;

new custom_price [ ] =
{
	20000,
	20000,
	10000,
	10000,
	60000,
	60000,
	70000,
	70000,
	1000,
	1000,
	5000,
	15000,
	
	200 // donate
} ;

// default
static PlayerText:ptd_t_custom [ MAX_PLAYERS ] [ 48 ] ;
static PlayerText:ptd_t_paint [ MAX_PLAYERS ] [ 35 ] ;

new bool: player_use_custom [ MAX_PLAYERS ] ;
static player_custom_page [ MAX_PLAYERS char ] ;

new Float: player_custom_suspension [ MAX_PLAYERS ] [ 2 ] ;
new Float: player_custom_wheelsize [ MAX_PLAYERS ] ;
new player_custom_wheelwidth [ MAX_PLAYERS ] ;
new player_custom_wheelalignment [ MAX_PLAYERS ] [ 2 ] ;
new player_custom_wheeloffstet [ MAX_PLAYERS ] [ 2 ] ;
new player_custom_lights_color [ MAX_PLAYERS ] ;
new player_custom_shadow_color [ MAX_PLAYERS ] ;
new player_custom_shadow_type [ MAX_PLAYERS ] ;
new player_custom_toner [ MAX_PLAYERS ] ;
new player_custom_vinyl [ MAX_PLAYERS ] ;

new bool: player_used_paint [ MAX_PLAYERS ] ;
new player_custom_toner_percent [ MAX_PLAYERS ] ;

new remap_toner [ 8 ] [ 2 ] = 
{
	{ 1, 8 },
	{ 9, 16 },
	{ 17, 24 },
	{ 25, 32 },
	{ 33, 40 },
	{ 41, 48 },
	{ 49, 56 },
	{ 57, 64 }
} ;

new custom_body [ ] = 
{ 
	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
	11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 
	31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 
	51, 52, 53 
} ;

new custom_neon [ ] =
{
	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
	11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50
} ;
		
stock clear_player_custom ( playerid )
{
	player_use_custom [ playerid ] = false ;
	player_used_paint [ playerid ] = false ;
	
	for ( new i = 0 ; i < 35 ; i ++ )
	{
		ptd_t_paint [ playerid ] [ i ] = PlayerText:-1 ;
	}
	return 1 ;
}

stock tuning_OnPlayerDisconnect ( playerid )
{
	if ( player_use_custom [ playerid ] )
	{
		show_ptd_custom ( playerid, false ) ;
	}
	return 1 ;
}

stock clear_car_custom ( _veh_id, _type_clear, playerid = -1 )
{
	if ( _veh_id == INVALID_VEHICLE_ID ) return 1 ;
	
	if ( _type_clear == 1 )
	{
		veh_info [ _veh_id - 1 ] [ v_suspension ] [ 0 ] =
		veh_info [ _veh_id - 1 ] [ v_suspension ] [ 1 ] = 0.0 ;
		veh_info [ _veh_id - 1 ] [ v_wheel_size ] = 0.0 ;
		
		veh_info [ _veh_id - 1 ] [ v_wheel_width ] = 0 ;
		veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 0 ] =
		veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 1 ] = 0 ;
		veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 0 ] =
		veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 1 ] = 0 ;
		
		veh_info [ _veh_id - 1 ] [ v_lights_color ] =
		veh_info [ _veh_id - 1 ] [ v_neon ] =
		veh_info [ _veh_id - 1 ] [ v_neon_type ] = 0 ;
		
		veh_info [ _veh_id - 1 ] [ v_toner ] [ 0 ] =
		veh_info [ _veh_id - 1 ] [ v_toner ] [ 1 ] =
		veh_info [ _veh_id - 1 ] [ v_toner ] [ 2 ] =
		veh_info [ _veh_id - 1 ] [ v_vinyl ] = 0 ;
	}
	else if ( _type_clear == 2 )
	{
		if ( veh_info [ _veh_id - 1 ] [ v_suspension ] [ 0 ] <= default_lowerlimit )
		{
			player_custom_suspension [ playerid ] [ 0 ] = default_lowerlimit ;
		}
		else player_custom_suspension [ playerid ] [ 0 ] = veh_info [ _veh_id - 1 ] [ v_suspension ] [ 0 ] ;
		
		if ( veh_info [ _veh_id - 1 ] [ v_suspension ] [ 1 ] <= default_suspbias )
		{
			player_custom_suspension [ playerid ] [ 1 ] = default_suspbias ;
		}
		else player_custom_suspension [ playerid ] [ 1 ] = veh_info [ _veh_id - 1 ] [ v_suspension ] [ 1 ] ;
		
		if ( veh_info [ _veh_id - 1 ] [ v_wheel_size ] <= default_wheelsize )
		{
			player_custom_wheelsize [ playerid ] = default_wheelsize ;
		}
		else player_custom_wheelsize [ playerid ] = veh_info [ _veh_id - 1 ] [ v_wheel_size ] ;
		
		if ( veh_info [ _veh_id - 1 ] [ v_wheel_width ] <= default_wheelwidth )
		{
			player_custom_wheelwidth [ playerid ] = default_wheelwidth ;
		}
		else player_custom_wheelwidth [ playerid ] = veh_info [ _veh_id - 1 ] [ v_wheel_width ] ;
		
		if ( veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 0 ] <= default_wheelalignment )
		{
			player_custom_wheelalignment [ playerid ] [ 0 ] = default_wheelalignment ;
		}
		else player_custom_wheelalignment [ playerid ] [ 0 ] = veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 0 ] ;
		
		if ( veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 1 ] <= default_wheelalignment )
		{
			player_custom_wheelalignment [ playerid ] [ 1 ] = default_wheelalignment ;
		}
		else player_custom_wheelalignment [ playerid ] [ 1 ] = veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 1 ] ;
		
		if ( veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 0 ] <= default_wheeloffset )
		{
			player_custom_wheeloffstet [ playerid ] [ 0 ] = default_wheeloffset ;
		}
		else player_custom_wheeloffstet [ playerid ] [ 0 ] = veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 0 ] ;
		
		if ( veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 1 ] <= default_wheeloffset )
		{
			player_custom_wheeloffstet [ playerid ] [ 1 ] = default_wheeloffset ;
		}
		else player_custom_wheeloffstet [ playerid ] [ 1 ] = veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 1 ] ;
		
		player_custom_lights_color [ playerid ] = veh_info [ _veh_id - 1 ] [ v_lights_color ] ;
		player_custom_shadow_color [ playerid ] = veh_info [ _veh_id - 1 ] [ v_neon ] ;
		player_custom_shadow_type [ playerid ] = veh_info [ _veh_id - 1 ] [ v_neon_type ] ;
		
		player_custom_toner [ playerid ] = veh_info [ _veh_id - 1 ] [ v_toner ] ;
		player_custom_vinyl [ playerid ] = veh_info [ _veh_id - 1 ] [ v_vinyl ] ;
	}
	else if ( _type_clear == 3 )
	{
		#if defined m_t_stage
			new _minus_speed = 0 ;
			if ( veh_info [ _veh_id - 1 ] [ v_millage ] > 100 ) _minus_speed = floatround ( veh_info [ _veh_id - 1 ] [ v_millage ] / 100 ) ;

			new Float: _max_speed = max_veh_speed ( getReplacableVehicleModel ( _veh_id ) ) + stage_info_speed ( _veh_id ) - _minus_speed ;
		#else
			new Float: _max_speed = max_veh_speed ( getReplacableVehicleModel ( _veh_id ) ) ;
		#endif

		sc_ResetHandling ( _veh_id ) ;
		sc_Handling_OnVehicleStreamIn ( _veh_id, playerid, _max_speed, _max_speed / 5 ) ;
		sc_OnVehicleStreamIn ( _veh_id, playerid ) ;
	}
	return 1 ;
}

stock cheching_custom_tuning ( playerid, _veh_id )
{
	new _page_id = player_custom_page { playerid } ;
	switch ( _page_id )
	{
		case 0: if ( veh_info [ _veh_id - 1 ] [ v_suspension ] [ 0 ] == player_custom_suspension [ playerid ] [ 0 ] ) return 1 ;
		case 1: if ( veh_info [ _veh_id - 1 ] [ v_suspension ] [ 1 ] == player_custom_suspension [ playerid ] [ 1 ] ) return 1 ;
		case 2: if ( veh_info [ _veh_id - 1 ] [ v_wheel_size ] == player_custom_wheelwidth [ playerid ] ) return 1 ;
		case 3: if ( veh_info [ _veh_id - 1 ] [ v_wheel_width ] == player_custom_wheelsize [ playerid ] ) return 1 ;
		case 4: if ( veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 0 ] == player_custom_wheelalignment [ playerid ] [ 0 ] ) return 1 ;
		case 5: if ( veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 1 ] == player_custom_wheelalignment [ playerid ] [ 1 ] ) return 1 ;
		case 6: if ( veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 0 ] == player_custom_wheeloffstet [ playerid ] [ 0 ] ) return 1 ;
		case 7: if ( veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 1 ] == player_custom_wheeloffstet [ playerid ] [ 1 ] ) return 1 ;
		case 8: if ( veh_info [ _veh_id - 1 ] [ v_lights_color ] == player_custom_lights_color [ playerid ] ) return 1 ;
		case 9: if ( veh_info [ _veh_id - 1 ] [ v_neon ] == player_custom_shadow_color [ playerid ] ) return 1 ;
		case 10: if ( veh_info [ _veh_id - 1 ] [ v_toner ] == player_custom_toner [ playerid ] ) return 1 ;
		case 11: if ( veh_info [ _veh_id - 1 ] [ v_vinyl ] == player_custom_vinyl [ playerid ] ) return 1 ;
		case 12: if ( veh_info [ _veh_id - 1 ] [ v_neon ] == player_custom_shadow_color [ playerid ] ) return 1 ;
	}
	return 0 ;
}

stock tuning_PlayerTextDraw ( playerid, PlayerText:playertextid )
{
	if ( player_use_custom [ playerid ] )
	{
		if ( player_device { playerid } != 2 && playertextid == ptd_t_custom [ playerid ] [ 15 ] )
		{
			if ( player_custom_page { playerid } <= 0 ) return 1 ;
			
			if ( player_custom_page { playerid } == 8 )
			{
				show_paint_ptd ( playerid, -1, false ) ;
			}
			else if ( player_custom_page { playerid } == 9 )
			{
				page_count [ playerid ] = 1 ;
				update_custom_paint ( playerid, 8, true ) ;
			}
			else if ( player_custom_page { playerid } == 10 )
			{
				page_count [ playerid ] = 1 ;
				update_custom_paint ( playerid, 9, true ) ;
			}
			else if ( player_custom_page { playerid } == 11 )
			{
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Винилы", "{"#cWH"}Винилы можно установить только на т/с белого цвета.", "Понятно", "" ) ;
				
				page_count [ playerid ] = 1 ;
				update_custom_paint ( playerid, 10, true ) ;
			}
			else if ( player_custom_page { playerid } == 12 )
			{
				new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
				if ( _veh_id == INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не загоняли т/с в автосервис." ) ;
			
				clear_car_custom ( _veh_id, 2, playerid ) ;
				clear_car_custom ( _veh_id, 3, playerid ) ;
				
				page_count [ playerid ] = 1 ;
				update_custom_paint ( playerid, 11, true ) ;
			}
			
			player_custom_page { playerid } -- ;
			
			new Float: _custom_mas ;
			switch ( player_custom_page { playerid } )
			{
				case 0: _custom_mas = player_custom_suspension [ playerid ] [ 0 ] ;
				case 1: _custom_mas = player_custom_suspension [ playerid ] [ 1 ] ;
				case 2: _custom_mas = player_custom_wheelsize [ playerid ] ;
				case 3: _custom_mas = player_custom_wheelwidth [ playerid ] ;
				case 4: _custom_mas = player_custom_wheelalignment [ playerid ] [ 0 ] ;
				case 5: _custom_mas = player_custom_wheelalignment [ playerid ] [ 1 ] ;
				case 6: _custom_mas = player_custom_wheeloffstet [ playerid ] [ 0 ] ;
				case 7: _custom_mas = player_custom_wheeloffstet [ playerid ] [ 1 ] ;
				case 8:
				{
					_custom_mas = player_custom_lights_color [ playerid ] ;
					
					new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
					if ( _veh_id == INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не загоняли т/с в автосервис." ) ;
			
					new engine, lights, alarm, doors, bonnet, boot, objective ;
					GetVehicleParamsEx ( _veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
					SetVehicleParamsEx ( _veh_id, true, true, alarm, doors, bonnet, boot, objective ) ;
				}
				case 9: _custom_mas = player_custom_shadow_color [ playerid ] ;
				case 10: _custom_mas = player_custom_toner [ playerid ] ;
				case 11: _custom_mas = player_custom_vinyl [ playerid ] ;
				case 12:
				{
					_custom_mas = player_custom_lights_color [ playerid ] ;
					
					new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
					if ( _veh_id == INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не загоняли т/с в автосервис." ) ;
			
					new engine, lights, alarm, doors, bonnet, boot, objective ;
					GetVehicleParamsEx ( _veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
					SetVehicleParamsEx ( _veh_id, true, true, alarm, doors, bonnet, boot, objective ) ;
				}
			}
			
			if ( player_device { playerid } != 2 )
			{
				new _td_string [ 24 ] ;
				format  ( _td_string, sizeof _td_string, "%s", custom_name [ player_custom_page { playerid } ] ) ;
				PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 17 ], _td_string ) ;
				
				format  ( _td_string, sizeof _td_string, "%.2f", _custom_mas ) ;
				PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 35 ], _td_string ) ;
			}
			return 1 ;
		}
		else if ( player_device { playerid } != 2 && playertextid == ptd_t_custom [ playerid ] [ 16 ] )
		{
			if ( player_custom_page { playerid } >= sizeof custom_name - 1 ) return 1 ;
			
			player_custom_page { playerid } ++ ;
			
			if ( player_custom_page { playerid } == 8 )
			{
				show_paint_ptd ( playerid, 8, true ) ;
			}
			else if ( player_custom_page { playerid } == 9 )
			{
				page_count [ playerid ] = 1 ;
				update_custom_paint ( playerid, 9, true ) ;
			}
			else if ( player_custom_page { playerid } == 10 )
			{
				page_count [ playerid ] = 1 ;
				update_custom_paint ( playerid, 10, true ) ;
			}
			else if ( player_custom_page { playerid } == 11 )
			{
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Винилы", "{"#cWH"}Винилы можно установить только на т/с белого цвета.", "Понятно", "" ) ;
				
				page_count [ playerid ] = 1 ;
				update_custom_paint ( playerid, 11, true ) ;
			}
			else if ( player_custom_page { playerid } == 12 )
			{
				new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
				if ( _veh_id == INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не загоняли т/с в автосервис." ) ;
			
				clear_car_custom ( _veh_id, 2, playerid ) ;
				
				page_count [ playerid ] = 1 ;
				update_custom_paint ( playerid, 12, true ) ;
			}
			
			new Float: _custom_mas ;
			switch ( player_custom_page { playerid } )
			{
				case 0: _custom_mas = player_custom_suspension [ playerid ] [ 0 ] ;
				case 1: _custom_mas = player_custom_suspension [ playerid ] [ 1 ] ;
				case 2: _custom_mas = player_custom_wheelsize [ playerid ] ;
				case 3: _custom_mas = player_custom_wheelwidth [ playerid ] ;
				case 4: _custom_mas = player_custom_wheelalignment [ playerid ] [ 0 ] ;
				case 5: _custom_mas = player_custom_wheelalignment [ playerid ] [ 1 ] ;
				case 6: _custom_mas = player_custom_wheeloffstet [ playerid ] [ 0 ] ;
				case 7: _custom_mas = player_custom_wheeloffstet [ playerid ] [ 1 ] ;
				case 8: 
				{
					_custom_mas = player_custom_lights_color [ playerid ] ;
					
					new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
					if ( _veh_id == INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не загоняли т/с в автосервис." ) ;
			
					new engine, lights, alarm, doors, bonnet, boot, objective ;
					GetVehicleParamsEx ( _veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
					SetVehicleParamsEx ( _veh_id, true, true, alarm, doors, bonnet, boot, objective ) ;
				}
				case 9: _custom_mas = player_custom_shadow_color [ playerid ] ;
				case 10: _custom_mas = player_custom_toner [ playerid ] ;
				case 11: _custom_mas = player_custom_vinyl [ playerid ] ;
				case 12:
				{
					_custom_mas = player_custom_lights_color [ playerid ] ;
					
					new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
					if ( _veh_id == INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не загоняли т/с в автосервис." ) ;
			
					new engine, lights, alarm, doors, bonnet, boot, objective ;
					GetVehicleParamsEx ( _veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
					SetVehicleParamsEx ( _veh_id, true, true, alarm, doors, bonnet, boot, objective ) ;
				}
			}
			
			if ( player_device { playerid } != 2 )
			{
				new _td_string [ 24 ] ;
				format  ( _td_string, sizeof _td_string, "%s", custom_name [ player_custom_page { playerid } ] ) ;
				PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 17 ], _td_string ) ;
			
				format  ( _td_string, sizeof _td_string, "%.2f", _custom_mas ) ;
				PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 35 ], _td_string ) ;
			}
			return 1 ;
		}
		else if ( player_device { playerid } != 2 && playertextid == ptd_t_custom [ playerid ] [ 24 ] )
		{
			new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
			if ( _veh_id == INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не загоняли т/с в автосервис." ) ;
			
			new _page_id = player_custom_page { playerid } ;
			new Float: _custom_mas ;
			switch ( _page_id )
			{
				case 0:
				{
					if ( player_custom_suspension [ playerid ] [ 0 ] <= -0.20 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это минимальный уровень подвески." ) ;
					
					player_custom_suspension [ playerid ] [ 0 ] -= 0.01 ;
					_custom_mas = player_custom_suspension [ playerid ] [ 0 ] ;
					
					SetVehicleHandling ( playerid, _veh_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				case 1:
				{
					if ( player_custom_suspension [ playerid ] [ 1 ] <= 0.20 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это минимальный баланс подвески." ) ;
					
					player_custom_suspension [ playerid ] [ 1 ] -= 0.01 ;
					_custom_mas = player_custom_suspension [ playerid ] [ 1 ] ;
					
					SetVehicleHandling ( playerid, _veh_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				case 2:
				{
					if ( player_custom_wheelsize [ playerid ] <= 0.60 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это минимальный размер колёс." ) ;
					
					player_custom_wheelsize [ playerid ] -= 0.05 ;
					_custom_mas = player_custom_wheelsize [ playerid ] ;
					
					SetVehicleHandling ( playerid, _veh_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				case 3:
				{
					if ( player_custom_wheelwidth [ playerid ] == 105 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это минимальная ширина колёс." ) ;
					
					player_custom_wheelwidth [ playerid ] -= 5 ;
					_custom_mas = player_custom_wheelwidth [ playerid ] ;
					
					//SetVehicleWidthWheel ( playerid, _veh_id, player_custom_wheelwidth [ playerid ] ) ;
				}
				case 4:
				{
					if ( player_custom_wheelalignment [ playerid ] [ 0 ] == -7 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это минимальный выворот колёс." ) ;
					
					player_custom_wheelalignment [ playerid ] [ 0 ] -= 1 ;
					_custom_mas = player_custom_wheelalignment [ playerid ] [ 0 ] ;
					
					//SetVehicleWheelAlignment ( playerid, _veh_id, 0, player_custom_wheelalignment [ playerid ] [ 0 ] ) ;
				}
				case 5:
				{
					if ( player_custom_wheelalignment [ playerid ] [ 1 ] == -7 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это минимальный выворот колёс." ) ;
					
					player_custom_wheelalignment [ playerid ] [ 1 ] -= 1 ;
					_custom_mas = player_custom_wheelalignment [ playerid ] [ 1 ] ;
					
					//SetVehicleWheelAlignment ( playerid, _veh_id, 1, player_custom_wheelalignment [ playerid ] [ 1 ] ) ;
				}
				case 6:
				{
					if ( player_custom_wheeloffstet [ playerid ] [ 0 ] == -17 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это минимальный вылет колёс." ) ;
					
					player_custom_wheeloffstet [ playerid ] [ 0 ] -= 1 ;
					_custom_mas = player_custom_wheeloffstet [ playerid ] [ 0 ] ;
					
					//SetVehicleWheelOffset ( playerid, _veh_id, 0, player_custom_wheeloffstet [ playerid ] [ 0 ] ) ;
				}
				case 7:
				{
					if ( player_custom_wheeloffstet [ playerid ] [ 1 ] == -17 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это минимальный вылет колёс." ) ;
					
					player_custom_wheeloffstet [ playerid ] [ 1 ] -= 1 ;
					_custom_mas = player_custom_wheeloffstet [ playerid ] [ 1 ] ;
					
					//SetVehicleWheelOffset ( playerid, _veh_id, 1, player_custom_wheeloffstet [ playerid ] [ 1 ] ) ;
				}
				case 8:
				{
					if ( player_custom_lights_color [ playerid ] == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первом цвете фар." ) ;
					
					player_custom_lights_color [ playerid ] -= 1 ;
					_custom_mas = player_custom_lights_color [ playerid ] ;
					
					/*new _r, _g, _b ;
					color_converter ( rgb_array [ player_custom_lights_color [ playerid ] ], _r, _g, _b ) ;
					SetVehicleLightsColors ( playerid, _veh_id, _r, _g, _b ) ;*/
				}
				case 9:
				{
					if ( player_custom_shadow_color [ playerid ] == 0 )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на позиции, которая убирает неон." ) ;
						//SetVehicleNeon ( playerid, _veh_id, 0, 0, 0, 0, 0, " " ) ;
						return 1 ;
					}
					
					player_custom_shadow_color [ playerid ] -= 1 ;
					if ( player_custom_shadow_color [ playerid ] >= sizeof rgb_array - 1 ) player_custom_shadow_color [ playerid ] = sizeof rgb_array - 1 ;
					_custom_mas = player_custom_shadow_color [ playerid ] ;
					
					/*new _r, _g, _b ;
					color_converter ( rgb_array [ player_custom_shadow_color [ playerid ] ], _r, _g, _b ) ;
					SetVehicleNeon ( playerid, _veh_id, 7, 6, _r, _g, _b, "coronastar" ) ;*/
				}
				case 10:
				{
					if ( player_custom_toner [ playerid ] == 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первом тонере." ) ;
					if ( ! tuning_valid_toner ( _veh_id ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, на данную модель нет тонировки." ) ;
					
					player_custom_toner [ playerid ] -= 1 ;
					_custom_mas = player_custom_toner [ playerid ] ;
					
					/*new _toner_id = player_custom_toner [ playerid ] ;
					SetVehicleToner ( playerid, _veh_id, _toner_id, _toner_id, _toner_id, tuning_name_toner ( _veh_id ) ) ;*/
					
					new bool: _true_change = false, bool: _true_change_1 = false ;
					for ( new i = 0 ; i < sizeof remap_toner ; i ++ )
					{
						if ( player_custom_toner [ playerid ] == remap_toner [ i ] [ 0 ] )
						{
							_true_change = true ;
							break ;
						}
						else if ( player_custom_toner [ playerid ] == remap_toner [ i ] [ 1 ] )
						{
							_true_change_1 = true ;
							break ;
						}
					}
					
					if ( _true_change == true ) player_custom_toner_percent [ playerid ] = 30 ;
					else if ( _true_change_1 == true ) player_custom_toner_percent [ playerid ] = 100 ;
					else player_custom_toner_percent [ playerid ] -= 10 ;
					
					if ( player_device { playerid } != 2 )
					{
						new _td_string [ 24 ] ;
						format  ( _td_string, sizeof _td_string, "%d%%", player_custom_toner_percent [ playerid ] ) ;
						PlayerTextDrawSetString ( playerid, ptd_t_paint [ playerid ] [ 12 ], _td_string ) ;
					}
				}
				case 11:
				{
					if ( player_custom_vinyl [ playerid ] == 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первом виниле." ) ;
					if ( ! tuning_valid_vinyl ( _veh_id ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, на данную модель нет винилов." ) ;
					
					player_custom_vinyl [ playerid ] -= 1 ;
					_custom_mas = player_custom_vinyl [ playerid ] ;
					
					/*new _vinyl_id = player_custom_vinyl [ playerid ] ;
					SetVehicleVinyls ( playerid, _veh_id, _vinyl_id, _vinyl_id, tuning_name_vinyl ( _veh_id ) ) ;*/
				}
				case 12:
				{
					if ( player_custom_shadow_color [ playerid ] <= sizeof rgb_array - 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последнем цвете неона." ) ;
					
					player_custom_shadow_color [ playerid ] -= 1 ;
					_custom_mas = player_custom_shadow_color [ playerid ] ;
					
					new _r, _g, _b ;
					color_converter ( rgb_array [ 1 ], _r, _g, _b ) ;
					
					/*new tex_name [ 32 ] ;
					format ( tex_name, sizeof tex_name, "neon_%d", player_custom_shadow_color [ playerid ] - sizeof rgb_array ) ;
					SetVehicleNeon ( playerid, _veh_id, 7, 6, _r, _g, _b, tex_name ) ;*/
					
					new _td_string [ 24 ] ;
					if ( player_device { playerid } != 2 )
					{
						format ( _td_string, sizeof _td_string, "%d "donate_title_abb"", custom_price [ _page_id ] ) ;
						PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 26 ], _td_string ) ;
						
						format  ( _td_string, sizeof _td_string, "%.2f", _custom_mas ) ;
						PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 35 ], _td_string ) ;
					}
					return 1 ;
				}
			}
			
			if ( ! p_t_info [ playerid ] [ component_id ] [ _page_id ] ) 
			{
				p_t_info [ playerid ] [ total_price ] += custom_price [ _page_id ] ;
				p_t_info [ playerid ] [ component_id ] [ _page_id ] = 1 ;
			}
			else
			{
				if ( cheching_custom_tuning ( playerid, _veh_id ) )
				{
					p_t_info [ playerid ] [ total_price ] -= custom_price [ _page_id ] ;
					p_t_info [ playerid ] [ component_id ] [ _page_id ] = 0 ;
				}
			}
			
			new _td_string [ 24 ] ;
			if ( player_device { playerid } != 2 )
			{
				format ( _td_string, sizeof _td_string, "%d$", p_t_info [ playerid ] [ total_price ] * b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_cost ] ) ;
				PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 26 ], _td_string ) ;
				
				format  ( _td_string, sizeof _td_string, "%.2f", _custom_mas ) ;
				PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 35 ], _td_string ) ;
			}
			return 1 ;
		}
		else if ( player_device { playerid } != 2 && playertextid == ptd_t_custom [ playerid ] [ 25 ] )
		{
			new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
			if ( _veh_id == INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не загоняли т/с в автосервис." ) ;
			
			new _page_id = player_custom_page { playerid } ;
			new Float: _custom_mas ;
			switch ( _page_id )
			{
				case 0:
				{
					if ( player_custom_suspension [ playerid ] [ 0 ] >= 0.03 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это максимальный уровень подвески." ) ;
					
					player_custom_suspension [ playerid ] [ 0 ] += 0.01 ;
					_custom_mas = player_custom_suspension [ playerid ] [ 0 ] ;
					
					SetVehicleHandling ( playerid, _veh_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				case 1:
				{
					if ( player_custom_suspension [ playerid ] [ 1 ] >= 0.60 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это максимальный баланс подвески." ) ;
					
					player_custom_suspension [ playerid ] [ 1 ] += 0.01 ;
					_custom_mas = player_custom_suspension [ playerid ] [ 1 ] ;
					
					SetVehicleHandling ( playerid, _veh_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				case 2:
				{
					if ( player_custom_wheelsize [ playerid ] >= 0.90 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это максимальный размер колёс." ) ;
					
					player_custom_wheelsize [ playerid ] += 0.05 ;
					_custom_mas = player_custom_wheelsize [ playerid ] ;
					
					SetVehicleHandling ( playerid, _veh_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
				}
				case 3:
				{
					if ( player_custom_wheelwidth [ playerid ] == 150 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это максимальная ширина колёс." ) ;
					
					player_custom_wheelwidth [ playerid ] += 5 ;
					_custom_mas = player_custom_wheelwidth [ playerid ] ;
					
					//SetVehicleWidthWheel ( playerid, _veh_id, player_custom_wheelwidth [ playerid ] ) ;
				}
				case 4:
				{
					if ( player_custom_wheelalignment [ playerid ] [ 0 ] == 7 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это максимальный выворот колёс." ) ;
					
					player_custom_wheelalignment [ playerid ] [ 0 ] += 1 ;
					_custom_mas = player_custom_wheelalignment [ playerid ] [ 0 ] ;
					
					//SetVehicleWheelAlignment ( playerid, _veh_id, 0, player_custom_wheelalignment [ playerid ] [ 0 ] ) ;
				}
				case 5:
				{
					if ( player_custom_wheelalignment [ playerid ] [ 1 ] == 7 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это максимальный выворот колёс." ) ;
					
					player_custom_wheelalignment [ playerid ] [ 1 ] += 1 ;
					_custom_mas = player_custom_wheelalignment [ playerid ] [ 1 ] ;
					
					//SetVehicleWheelAlignment ( playerid, _veh_id, 1, player_custom_wheelalignment [ playerid ] [ 1 ] ) ;
				}
				case 6:
				{
					if ( player_custom_wheeloffstet [ playerid ] [ 0 ] == 17 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это максимальный вылет колёс." ) ;
					
					player_custom_wheeloffstet [ playerid ] [ 0 ] += 1 ;
					_custom_mas = player_custom_wheeloffstet [ playerid ] [ 0 ] ;
					
					//SetVehicleWheelOffset ( playerid, _veh_id, 0, player_custom_wheeloffstet [ playerid ] [ 0 ] ) ;
				}
				case 7:
				{
					if ( player_custom_wheeloffstet [ playerid ] [ 1 ] == 17 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это максимальный вылет колёс." ) ;
					
					player_custom_wheeloffstet [ playerid ] [ 1 ] += 1 ;
					_custom_mas = player_custom_wheeloffstet [ playerid ] [ 1 ] ;
					
					//SetVehicleWheelOffset ( playerid, _veh_id, 1, player_custom_wheeloffstet [ playerid ] [ 1 ] ) ;
				}
				case 8:
				{
					if ( player_custom_lights_color [ playerid ] >= sizeof rgb_array - 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последнем цвете фар." ) ;
					
					player_custom_lights_color [ playerid ] += 1 ;
					_custom_mas = player_custom_lights_color [ playerid ] ;
					
					/*new _r, _g, _b ;
					color_converter ( rgb_array [ player_custom_lights_color [ playerid ] ], _r, _g, _b ) ;
					SetVehicleLightsColors ( playerid, _veh_id, _r, _g, _b ) ;*/
				}
				case 9:
				{
					if ( player_custom_shadow_color [ playerid ] >= sizeof rgb_array - 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последнем цвете неона." ) ;
					
					player_custom_shadow_color [ playerid ] += 1 ;
					_custom_mas = player_custom_shadow_color [ playerid ] ;
					
					/*new _r, _g, _b ;
					color_converter ( rgb_array [ player_custom_shadow_color [ playerid ] ], _r, _g, _b ) ;
					SetVehicleNeon ( playerid, _veh_id, 7, 6, _r, _g, _b, "coronastar" ) ;*/
				}
				case 10:
				{
					if ( player_custom_toner [ playerid ] == 64 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последнем тонере." ) ;
					if ( ! tuning_valid_toner ( _veh_id ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, на данную модель нет тонировки." ) ;
					
					player_custom_toner [ playerid ] += 1 ;
					_custom_mas = player_custom_toner [ playerid ] ;
					
					/*new _toner_id = player_custom_toner [ playerid ] ;
					SetVehicleToner ( playerid, _veh_id, _toner_id, _toner_id, _toner_id, tuning_name_toner ( _veh_id ) ) ;*/
					
					new bool: _true_change = false, bool: _true_change_1 = false ;
					for ( new i = 0 ; i < sizeof remap_toner ; i ++ )
					{
						if ( player_custom_toner [ playerid ] == remap_toner [ i ] [ 0 ] )
						{
							_true_change = true ;
							break ;
						}
						else if ( player_custom_toner [ playerid ] == remap_toner [ i ] [ 1 ] )
						{
							_true_change_1 = true ;
							break ;
						}
					}
					
					if ( _true_change == true ) player_custom_toner_percent [ playerid ] = 30 ;
					else if ( _true_change_1 == true ) player_custom_toner_percent [ playerid ] = 100 ;
					else player_custom_toner_percent [ playerid ] += 10 ;
					
					if ( player_device { playerid } != 2 )
					{
						new _td_string [ 24 ] ;
						format  ( _td_string, sizeof _td_string, "%d%%", player_custom_toner_percent [ playerid ] ) ;
						PlayerTextDrawSetString ( playerid, ptd_t_paint [ playerid ] [ 12 ], _td_string ) ;
					}
				}
				case 11:
				{
					if ( player_custom_vinyl [ playerid ] == sizeof custom_body - 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последнем виниле." ) ;
					if ( ! tuning_valid_vinyl ( _veh_id ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, на данную модель нет винилов." ) ;
					
					player_custom_vinyl [ playerid ] += 1 ;
					_custom_mas = player_custom_vinyl [ playerid ] ;
					
					/*new _vinyl_id = player_custom_vinyl [ playerid ] ;
					SetVehicleVinyls ( playerid, _veh_id, _vinyl_id, _vinyl_id, tuning_name_vinyl ( _veh_id ) ) ;*/
				}
				case 12:
				{
					if ( player_custom_shadow_color [ playerid ] >= sizeof custom_neon - 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последнем цвете неона." ) ;
					
					player_custom_shadow_color [ playerid ] += 1 ;
					player_custom_shadow_type [ playerid ] = eNeonTypes_ON_TYPE_TEXTURE ;
					_custom_mas = player_custom_shadow_color [ playerid ] ;
					
					new _r, _g, _b ;
					color_converter ( rgb_array [ 1 ], _r, _g, _b ) ;
					
					/*new tex_name [ 32 ] ;
					format ( tex_name, sizeof tex_name, "neon_%d", player_custom_shadow_color [ playerid ] - sizeof rgb_array ) ;
					SetVehicleNeon ( playerid, _veh_id, 7, 6, _r, _g, _b, tex_name ) ;*/
					
					new _td_string [ 24 ] ;
					if ( player_device { playerid } != 2 )
					{
						format ( _td_string, sizeof _td_string, "%d "donate_title_abb"", custom_price [ _page_id ] ) ;
						PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 26 ], _td_string ) ;
						
						format  ( _td_string, sizeof _td_string, "%.2f", _custom_mas ) ;
						PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 35 ], _td_string ) ;
					}
					return 1 ;
				}
			}
			
			if ( ! p_t_info [ playerid ] [ component_id ] [ _page_id ] ) 
			{
				p_t_info [ playerid ] [ total_price ] += custom_price [ _page_id ] ;
				p_t_info [ playerid ] [ component_id ] [ _page_id ] = 1 ;
			}
			else
			{
				if ( cheching_custom_tuning ( playerid, _veh_id ) )
				{
					p_t_info [ playerid ] [ total_price ] -= custom_price [ _page_id ] ;
					p_t_info [ playerid ] [ component_id ] [ _page_id ] = 0 ;
				}
			}
			
			new _td_string [ 24 ] ;
			if ( player_device { playerid } != 2 )
			{
				format ( _td_string, sizeof _td_string, "%d$", p_t_info [ playerid ] [ total_price ] * b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_cost ] ) ;
				PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 26 ], _td_string ) ;
				
				format  ( _td_string, sizeof _td_string, "%.2f", _custom_mas ) ;
				PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 35 ], _td_string ) ;
			}
			return 1 ;
		}
		else if ( player_device { playerid } != 2 && ( playertextid == ptd_t_custom [ playerid ] [ 36 ] || playertextid == ptd_t_custom [ playerid ] [ 39 ] ) )
		{
			if ( GetPVarInt ( playerid, "tuning_page_camera" ) == 1 ) return 1 ;
			
			SetPVarInt ( playerid, "tuning_page_camera", GetPVarInt ( playerid, "tuning_page_camera" ) - 1 ) ;
			new tuning_page = GetPVarInt ( playerid, "tuning_page_camera" ) ;
			switch_camera ( playerid, tuning_page - 1, 0 ) ;
			return 1 ;
		}
		else if ( player_device { playerid } != 2 && ( playertextid == ptd_t_custom [ playerid ] [ 37 ] || playertextid == ptd_t_custom [ playerid ] [ 38 ] ) )
		{
			if ( GetPVarInt ( playerid, "tuning_page_camera" ) == 12 ) return 1 ;
			
			SetPVarInt ( playerid, "tuning_page_camera", GetPVarInt ( playerid, "tuning_page_camera" ) + 1 ) ;
			new tuning_page = GetPVarInt ( playerid, "tuning_page_camera" ) ;
			switch_camera ( playerid, tuning_page - 1, 0 ) ;
			return 1 ;
		}
		else if ( player_device { playerid } != 2 && playertextid == ptd_t_custom [ playerid ] [ 46 ] )
		{
			new _page_id = player_custom_page { playerid } ;
			if ( _page_id == 12 )
			{
				show_dialog ( playerid, d_donate_neon, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
				{"#cGRDialog"}- {"#cWH"}Установка неона:\n\n\
				{"#cGRDialog"}* Цена: {"#cGN"}200 "donate_title"{"#cGRDialog"}.\n\
				{"#cGRDialog"}* Вы действительно хотите установить \"{"#cWH"}неон{"#cGRDialog"}\".", "Выбрать", "Закрыть" ) ;
				return 1 ;
			}
			
			global_string [ 0 ] = EOS ;
			static const custom_info_rus [ 12 ] [ 24 ] = 
			{
				"Уровень подвески",
				"Баланс подвески",
				"Размер колёс",
				"Ширина колёс",
				"Выворот колёс",
				"Выворот колёс",
				"Вылет колёс",
				"Вылет колёс",
				"Цвет фар",
				"Неон",
				"Тонировка",
				"Винил"
			} ; 
			
			new line_string [ 100 ], _b_price = b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_cost ] ;
			new bool: _count = false ;
			for ( new i = 0 ; i < 13 ; i ++ )
			{
				if ( ! p_t_info [ playerid ] [ component_id ] [ i ] ) continue ;
				
				format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}%s: {"#cGN"}%d$\n", custom_info_rus [ i ], custom_price [ i ] * _b_price ) ;
				strcat ( global_string, line_string ) ;
				
				_count = true ;
			}
			if ( _count == false ) return show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Детейлинг", "{"#cRInfo"}* {"#cGRDialog"}Вы не выбрали компоненты.", "Закрыть", "" ) ;
			
			format ( line_string, sizeof line_string, "{"#cGRDialog"}Общая стоимость: {"#cWH"}%d$", p_t_info [ playerid ] [ total_price ] * _b_price ) ;
			show_dialog ( playerid, d_detail_tune, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Детейлинг", global_string, "Установить", "Закрыть" ) ;
			return 1 ;
		}
		else if ( player_device { playerid } != 2 && playertextid == ptd_t_custom [ playerid ] [ 47 ] )
		{
			show_ptd_custom ( playerid, false ) ;
			
			new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
			clear_car_custom ( _veh_id, 3, playerid ) ;
			return 1 ;
		}
	}
	
	if ( player_used_paint [ playerid ] == true )
	{
		if ( player_device { playerid } != 2 && playertextid == ptd_t_paint [ playerid ] [ 22 ] )
		{
			if ( ofm_formula_tuning ( page_count [ playerid ] ) >= page_rows [ playerid ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRD"}* {"#cGR"}Вы находитесь на последней странице." ) ;
		
			page_count [ playerid ] += 1 ;
			
			new _page_id = player_custom_page { playerid } ;
			if ( _page_id == 8 || _page_id == 9 ) update_custom_paint ( playerid, _page_id, true ) ;
			else if ( _page_id == 10 ) update_custom_paint ( playerid, _page_id, true ) ;
			else if ( _page_id == 11 ) update_custom_paint ( playerid, _page_id, true ) ;
			else if ( _page_id == 12 ) update_custom_paint ( playerid, _page_id, true ) ;
			return 1 ;
		}
		
		else if ( player_device { playerid } != 2 && playertextid == ptd_t_paint [ playerid ] [ 21 ] )
		{
			if ( page_count [ playerid ] == 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRD"}* {"#cGR"}Вы находитесь на первой странице." ) ;
			
			page_count [ playerid ] -= 1 ;
			
			new _page_id = player_custom_page { playerid } ;
			if ( _page_id == 8 || _page_id == 9 ) update_custom_paint ( playerid, _page_id, true ) ;
			else if ( _page_id == 10 ) update_custom_paint ( playerid, _page_id, true ) ;
			else if ( _page_id == 11 ) update_custom_paint ( playerid, _page_id, true ) ;
			else if ( _page_id == 12 ) update_custom_paint ( playerid, _page_id, true ) ;
			return 1 ;
		}
		
		if ( player_device { playerid } != 2 )
		{
			for ( new i = 23 ; i < 35 ; i ++ )
			{
				if ( playertextid == ptd_t_paint [ playerid ] [ i ] )
				{
					new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
					new _page_id = player_custom_page { playerid } ;
					new Float: _custom_mas ;
					if ( _page_id == 10 )
					{
						if ( ! tuning_valid_toner ( _veh_id ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, на данную модель нет тонировки." ) ;		
						
						player_custom_toner [ playerid ] = remap_toner [ i - 23 ] [ 0 ] ;
						_custom_mas = player_custom_toner [ playerid ] ;
						
						/*new _toner_id = player_custom_toner [ playerid ] ;
						SetVehicleToner ( playerid, _veh_id, _toner_id, _toner_id, _toner_id, tuning_name_toner ( _veh_id ) ) ;*/
					}
					else if ( _page_id == 11 )
					{
						if ( ! tuning_valid_vinyl ( _veh_id ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}К сожалению, на данную модель нет винилов." ) ;
					
						new _vinyl_id_on ;
						if ( page_count [ playerid ] > 1 ) _vinyl_id_on = ( 12 * ( page_count [ playerid ] - 1 ) ) + ( ( i - 23 ) + 1 ) ;
						else _vinyl_id_on = i - 23 ;
					
						player_custom_vinyl [ playerid ] = custom_body [ _vinyl_id_on ] ;
						_custom_mas = player_custom_vinyl [ playerid ] ;
						
						/*new _vinyl_id = player_custom_vinyl [ playerid ] ;
						SetVehicleVinyls ( playerid, _veh_id, _vinyl_id, _vinyl_id, tuning_name_vinyl ( _veh_id ) ) ;*/
					}
					else if ( _page_id == 12 )
					{
						new _neon_id_on ;
						if ( page_count [ playerid ] > 1 ) _neon_id_on = ( 12 * ( page_count [ playerid ] - 1 ) ) + ( ( i - 23 ) + 1 ) ;
						else _neon_id_on = i - 23 ;
					
						_neon_id_on += sizeof rgb_array ;
						player_custom_shadow_color [ playerid ] = custom_neon [ _neon_id_on ] ;
						
						new _r, _g, _b ;
						color_converter ( rgb_array [ 1 ], _r, _g, _b ) ;
						
						/*new tex_name [ 32 ] ;
						format ( tex_name, sizeof tex_name, "neon_%d", player_custom_shadow_color [ playerid ] - sizeof rgb_array ) ;
						SetVehicleNeon ( playerid, _veh_id, 7, 6, _r, _g, _b, tex_name ) ;*/
					
						new _td_string [ 24 ] ;
						if ( player_device { playerid } != 2 )
						{
							format ( _td_string, sizeof _td_string, "%d "donate_title_abb"", custom_price [ _page_id ] ) ;
							PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 26 ], _td_string ) ;
							
							format  ( _td_string, sizeof _td_string, "%.2f", _custom_mas ) ;
							PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 35 ], _td_string ) ;
						}
						return 1 ;
					}

					if ( ! p_t_info [ playerid ] [ component_id ] [ _page_id ] ) 
					{
						p_t_info [ playerid ] [ total_price ] += custom_price [ player_custom_page { playerid } ] ;
						p_t_info [ playerid ] [ component_id ] [ _page_id ] = 1 ;
					}
					else
					{
						if ( cheching_custom_tuning ( playerid, _veh_id ) )
						{
							p_t_info [ playerid ] [ total_price ] -= custom_price [ player_custom_page { playerid } ] ;
							p_t_info [ playerid ] [ component_id ] [ _page_id ] = 0 ;
						}
					}
					
					new _td_string [ 24 ] ;
					format ( _td_string, sizeof _td_string, "%d$", p_t_info [ playerid ] [ total_price ] * b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_cost ] ) ;
					PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 26 ], _td_string ) ;
					
					format  ( _td_string, sizeof _td_string, "%.2f", _custom_mas ) ;
					PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 35 ], _td_string ) ;
					
					player_custom_toner_percent [ playerid ] = 30 ;
					format  ( _td_string, sizeof _td_string, "%d%%", player_custom_toner_percent [ playerid ] ) ;
					PlayerTextDrawSetString ( playerid, ptd_t_paint [ playerid ] [ 12 ], _td_string ) ;
					return 1 ;
				}
			}
		}
	}
	return 0 ;
}

stock show_ptd_custom ( playerid, bool: status )
{
	if ( status )
	{
		new _td_string [ 32 ], _v_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
		if ( player_device { playerid } != 2 )
		{
			ptd_t_custom[playerid][0] = CreatePlayerTextDraw(playerid, 318.7664, 339.3888, "Box"); // Tuning Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][0], 0.0000, 4.1332);
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][0], 0.0000, 127.4197);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][0], 2);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][0], -5963521);
			PlayerTextDrawUseBox(playerid, ptd_t_custom[playerid][0], 1);
			PlayerTextDrawBoxColor(playerid, ptd_t_custom[playerid][0], -5963596);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][0], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][0], 1);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][0], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][0], 0);

			ptd_t_custom[playerid][1] = CreatePlayerTextDraw(playerid, 256.9998, 337.5182, "particle:lamp_shad_64"); // Tuning Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][1], 129.0000, 35.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][1], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][1], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][1], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][1], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][1], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][1], 0);

			ptd_t_custom[playerid][2] = CreatePlayerTextDraw(playerid, 253.8332, 365.4254, "ld_spac:white"); // Tuning Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][2], 129.9200, 67.9899);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][2], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][2], 168430335);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][2], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][2], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][2], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][2], 0);

			ptd_t_custom[playerid][3] = CreatePlayerTextDraw(playerid, 251.4998, 425.4490, "ld_beat:chit"); // Tuning Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][3], 14.0000, 17.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][3], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][3], 168430335);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][3], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][3], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][3], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][3], 0);

			ptd_t_custom[playerid][4] = CreatePlayerTextDraw(playerid, 372.0992, 425.3489, "ld_beat:chit"); // Tuning Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][4], 14.0000, 17.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][4], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][4], 168430335);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][4], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][4], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][4], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][4], 0);

			ptd_t_custom[playerid][5] = CreatePlayerTextDraw(playerid, 251.3999, 356.7144, "ld_beat:chit"); // Tuning Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][5], 14.0000, 17.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][5], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][5], 168430335);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][5], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][5], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][5], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][5], 0);

			ptd_t_custom[playerid][6] = CreatePlayerTextDraw(playerid, 372.2993, 356.7144, "ld_beat:chit"); // Tuning Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][6], 14.0000, 17.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][6], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][6], 168430335);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][6], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][6], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][6], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][6], 0);

			ptd_t_custom[playerid][7] = CreatePlayerTextDraw(playerid, 258.5663, 359.6182, "ld_spac:white"); // Category Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][7], 120.9199, 79.9899);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][7], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][7], 168430335);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][7], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][7], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][7], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][7], 0);

			ptd_t_custom[playerid][8] = CreatePlayerTextDraw(playerid, 275.1671, 361.9626, "O"); // Category Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][8], 0.4083, 3.1382);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][8], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][8], 437918463);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][8], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][8], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][8], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][8], 0);

			ptd_t_custom[playerid][9] = CreatePlayerTextDraw(playerid, 352.1671, 361.9626, "O"); // Category Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][9], 0.4083, 3.1382);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][9], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][9], 437918463);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][9], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][9], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][9], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][9], 0);

			ptd_t_custom[playerid][10] = CreatePlayerTextDraw(playerid, 276.5663, 370.3885, "ld_spac:white"); // Category Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][10], 84.0000, 15.6300);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][10], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][10], 437918463);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][10], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][10], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][10], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][10], 0);

			ptd_t_custom[playerid][11] = CreatePlayerTextDraw(playerid, 259.1670, 361.9626, "O"); // Category Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][11], 0.5371, 3.1382);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][11], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][11], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][11], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][11], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][11], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][11], 0);

			ptd_t_custom[playerid][12] = CreatePlayerTextDraw(playerid, 365.1670, 361.9626, "O"); // Category Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][12], 0.5371, 3.1382);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][12], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][12], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][12], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][12], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][12], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][12], 0);

			ptd_t_custom[playerid][13] = CreatePlayerTextDraw(playerid, 261.2329, 372.0478, "ld_spac:white"); // Category Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][13], 10.0000, 12.6300);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][13], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][13], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][13], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][13], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][13], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][13], 0);

			ptd_t_custom[playerid][14] = CreatePlayerTextDraw(playerid, 366.8994, 372.0478, "ld_spac:white"); // Category Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][14], 10.0000, 12.6300);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][14], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][14], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][14], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][14], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][14], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][14], 0);

			ptd_t_custom[playerid][15] = CreatePlayerTextDraw(playerid, 265.9330, 373.7627, "<<"); // Left Category
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][15], 0.0882, 0.9943);
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][15], 10.0000, 10.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][15], 2);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][15], 235802367);
			PlayerTextDrawUseBox(playerid, ptd_t_custom[playerid][15], 1);
			PlayerTextDrawBoxColor(playerid, ptd_t_custom[playerid][15], 0);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][15], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][15], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][15], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][15], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_custom[playerid][15], true);

			ptd_t_custom[playerid][16] = CreatePlayerTextDraw(playerid, 372.4991, 373.7627, ">>"); // Right Category
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][16], 0.0851, 0.9943);
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][16], 10.0000, 10.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][16], 2);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][16], 235802367);
			PlayerTextDrawUseBox(playerid, ptd_t_custom[playerid][16], 1);
			PlayerTextDrawBoxColor(playerid, ptd_t_custom[playerid][16], 0);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][16], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][16], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][16], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][16], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_custom[playerid][16], true);

			ptd_t_custom[playerid][17] = CreatePlayerTextDraw(playerid, 318.2664, 372.9330, "Ypoўe®©_Јoљўeckњ"); // Category Name
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][17], 0.1279, 1.0068);
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][17], 10.0000, 528.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][17], 2);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][17], -1061109505);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][17], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][17], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][17], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][17], 0);

			ptd_t_custom[playerid][18] = CreatePlayerTextDraw(playerid, 303.0678, 385.1366, "O"); // Left Select Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][18], 0.4083, 3.1082);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][18], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][18], 505290495);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][18], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][18], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][18], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][18], 0);

			ptd_t_custom[playerid][19] = CreatePlayerTextDraw(playerid, 368.5341, 385.1710, "O"); // Right Select Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][19], 0.4083, 3.1082);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][19], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][19], 505290495);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][19], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][19], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][19], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][19], 0);

			ptd_t_custom[playerid][20] = CreatePlayerTextDraw(playerid, 324.7318, 385.1710, "o"); // Right Select Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][20], 0.4083, 3.1082);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][20], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][20], 505290495);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][20], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][20], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][20], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][20], 0);

			ptd_t_custom[playerid][21] = CreatePlayerTextDraw(playerid, 259.2650, 385.1366, "o"); // Left Select Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][21], 0.4083, 3.1082);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][21], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][21], 505290495);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][21], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][21], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][21], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][21], 0);

			ptd_t_custom[playerid][22] = CreatePlayerTextDraw(playerid, 261.0327, 393.4181, "ld_spac:white"); // Left Select Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][22], 50.0000, 15.2798);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][22], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][22], 505290495);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][22], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][22], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][22], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][22], 0);

			ptd_t_custom[playerid][23] = CreatePlayerTextDraw(playerid, 326.3662, 393.4181, "ld_spac:white"); // Right Select Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][23], 50.3698, 15.2798);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][23], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][23], 505290495);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][23], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][23], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][23], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][23], 0);

			ptd_t_custom[playerid][24] = CreatePlayerTextDraw(playerid, 286.2664, 395.9626, "<<"); // Left Select
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][24], 0.1351, 1.1395);
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][24], 10.0000, 50.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][24], 2);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][24], -1);
			PlayerTextDrawUseBox(playerid, ptd_t_custom[playerid][24], 1);
			PlayerTextDrawBoxColor(playerid, ptd_t_custom[playerid][24], 0);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][24], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][24], 1);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][24], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][24], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_custom[playerid][24], true);

			ptd_t_custom[playerid][25] = CreatePlayerTextDraw(playerid, 351.5996, 395.7627, ">>"); // Right Select
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][25], 0.1351, 1.1395);
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][25], 10.0000, 50.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][25], 2);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][25], -1);
			PlayerTextDrawUseBox(playerid, ptd_t_custom[playerid][25], 1);
			PlayerTextDrawBoxColor(playerid, ptd_t_custom[playerid][25], 0);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][25], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][25], 1);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][25], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][25], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_custom[playerid][25], true);

			ptd_t_custom[playerid][26] = CreatePlayerTextDraw(playerid, 377.3330, 343.4813, "$100.000"); // Price Text
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][26], 0.2249, 1.0814);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][26], 3);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][26], -1);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][26], 15);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][26], 1);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][26], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][26], 1);

			ptd_t_custom[playerid][27] = CreatePlayerTextDraw(playerid, 486.4348, 220.6109, "O"); // Icon (Eye)
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][27], 0.8439, 4.7607);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][27], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][27], 168430335);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][27], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][27], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][27], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][27], 0);

			ptd_t_custom[playerid][28] = CreatePlayerTextDraw(playerid, 490.0013, 235.0590, "ld_spac:white"); // Icon (Eye)
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][28], 15.0000, 19.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][28], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][28], 168430335);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][28], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][28], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][28], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][28], 0);

			ptd_t_custom[playerid][29] = CreatePlayerTextDraw(playerid, 496.1011, 243.1407, "ld_beat:chit"); // Icon (Eye)
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][29], 2.0000, 2.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][29], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][29], -1);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][29], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][29], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][29], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][29], 0);

			ptd_t_custom[playerid][30] = CreatePlayerTextDraw(playerid, 489.0014, 237.1331, "ld_beat:chit"); // Icon (Eye)
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][30], 16.0000, 16.2199);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][30], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][30], -1);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][30], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][30], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][30], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][30], 0);

			ptd_t_custom[playerid][31] = CreatePlayerTextDraw(playerid, 487.9346, 239.0924, "ld_beat:chit"); // Icon (Eye)
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][31], 18.0000, 12.3698);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][31], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][31], 235802367);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][31], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][31], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][31], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][31], 0);

			ptd_t_custom[playerid][32] = CreatePlayerTextDraw(playerid, 493.7680, 241.4812, "ld_beat:chit"); // Icon (Eye)
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][32], 6.2600, 7.1199);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][32], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][32], -1);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][32], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][32], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][32], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][32], 0);

			ptd_t_custom[playerid][33] = CreatePlayerTextDraw(playerid, 494.6347, 242.4109, "ld_beat:chit"); // Icon (Eye)
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][33], 4.3098, 5.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][33], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][33], 235802367);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][33], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][33], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][33], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][33], 0);

			ptd_t_custom[playerid][34] = CreatePlayerTextDraw(playerid, 494.7015, 241.7073, "W"); // Icon (Eye)
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][34], 0.1274, 0.1896);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][34], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][34], -1);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][34], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][34], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][34], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][34], 0);

			ptd_t_custom[playerid][35] = CreatePlayerTextDraw(playerid, 258.9997, 344.3110, "0.00"); // Float Text
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][35], 0.2249, 1.0814);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][35], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][35], -1);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][35], 15);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][35], 1);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][35], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][35], 1);

			ptd_t_custom[playerid][36] = CreatePlayerTextDraw(playerid, 465.6675, 234.6443, "ld_beat:left"); // Left Camera
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][36], 16.0000, 22.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][36], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][36], 235802367);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][36], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][36], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][36], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][36], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_custom[playerid][36], true);

			ptd_t_custom[playerid][37] = CreatePlayerTextDraw(playerid, 512.5347, 234.6443, "ld_beat:right"); // Right Camera
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][37], 16.0000, 22.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][37], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][37], 235802367);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][37], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][37], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][37], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][37], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_custom[playerid][37], true);

			ptd_t_custom[playerid][38] = CreatePlayerTextDraw(playerid, 489.0678, 208.5110, "ld_beat:up"); // Up Camera
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][38], 16.0000, 22.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][38], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][38], 235802367);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][38], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][38], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][38], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][38], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_custom[playerid][38], true);

			ptd_t_custom[playerid][39] = CreatePlayerTextDraw(playerid, 489.0675, 261.4002, "ld_beat:down"); // Down Camera
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][39], 16.0000, 22.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][39], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][39], 235802367);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][39], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][39], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][39], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][39], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_custom[playerid][39], true);

			ptd_t_custom[playerid][40] = CreatePlayerTextDraw(playerid, 303.0678, 407.1380, "O"); // Buy Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][40], 0.4083, 3.1082);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][40], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][40], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][40], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][40], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][40], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][40], 0);

			ptd_t_custom[playerid][41] = CreatePlayerTextDraw(playerid, 368.5341, 407.1724, "O"); // Exit Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][41], 0.4083, 3.1082);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][41], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][41], 505290495);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][41], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][41], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][41], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][41], 0);

			ptd_t_custom[playerid][42] = CreatePlayerTextDraw(playerid, 324.7318, 407.1724, "o"); // Exit Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][42], 0.4083, 3.1082);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][42], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][42], 505290495);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][42], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][42], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][42], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][42], 0);

			ptd_t_custom[playerid][43] = CreatePlayerTextDraw(playerid, 259.2650, 407.1380, "o"); // Buy Background
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][43], 0.4083, 3.1082);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][43], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][43], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][43], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][43], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][43], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][43], 0);

			ptd_t_custom[playerid][44] = CreatePlayerTextDraw(playerid, 261.0327, 415.4195, "ld_spac:white"); // Buy Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][44], 50.0000, 15.2798);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][44], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][44], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][44], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][44], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][44], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][44], 0);

			ptd_t_custom[playerid][45] = CreatePlayerTextDraw(playerid, 326.3662, 415.4195, "ld_spac:white"); // Exit Background
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][45], 50.3698, 15.2798);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][45], 1);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][45], 505290495);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][45], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][45], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][45], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][45], 0);

			ptd_t_custom[playerid][46] = CreatePlayerTextDraw(playerid, 286.2664, 417.9640, "BUY"); // Buy Text
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][46], 0.1381, 1.0316);
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][46], 10.0000, 50.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][46], 2);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][46], -1);
			PlayerTextDrawUseBox(playerid, ptd_t_custom[playerid][46], 1);
			PlayerTextDrawBoxColor(playerid, ptd_t_custom[playerid][46], 0);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][46], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][46], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][46], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][46], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_custom[playerid][46], true);

			ptd_t_custom[playerid][47] = CreatePlayerTextDraw(playerid, 351.5996, 417.7641, "EXIT"); // Exit Text
			PlayerTextDrawLetterSize(playerid, ptd_t_custom[playerid][47], 0.1371, 1.0565);
			PlayerTextDrawTextSize(playerid, ptd_t_custom[playerid][47], 10.0000, 50.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_custom[playerid][47], 2);
			PlayerTextDrawColor(playerid, ptd_t_custom[playerid][47], -1);
			PlayerTextDrawUseBox(playerid, ptd_t_custom[playerid][47], 1);
			PlayerTextDrawBoxColor(playerid, ptd_t_custom[playerid][47], 0);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_custom[playerid][47], 255);
			PlayerTextDrawFont(playerid, ptd_t_custom[playerid][47], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_custom[playerid][47], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_custom[playerid][47], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_custom[playerid][47], true);
			
			format ( _td_string, sizeof _td_string, "%s", custom_name [ 0 ] ) ;
			PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 17 ], _td_string ) ;
			
			format ( _td_string, sizeof _td_string, "%d$", custom_price [ 0 ] ) ;
			PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 26 ], _td_string ) ;
			
			format ( _td_string, sizeof _td_string, "%.2f", veh_info [ _v_id - 1 ] [ v_suspension ] [ 0 ] ) ;
			PlayerTextDrawSetString ( playerid, ptd_t_custom [ playerid ] [ 35 ], _td_string ) ;
			
			for ( new i = 0 ; i < 48 ; i ++ )
			{
				PlayerTextDrawShow ( playerid, ptd_t_custom [ playerid ] [ i ] ) ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
		
		}
		
		SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
		player_custom_page { playerid } = 0 ;
		player_use_custom [ playerid ] = true ;
		
		clear_car_custom ( _v_id, 2, playerid ) ;
		SetVehicleHandling ( playerid, _v_id, player_custom_suspension [ playerid ] [ 0 ], player_custom_suspension [ playerid ] [ 1 ], player_custom_wheelsize [ playerid ] ) ;
		
		/*SetVehicleWidthWheel ( playerid, _v_id, player_custom_wheelwidth [ playerid ] ) ;
		
		SetVehicleWheelAlignment ( playerid, _v_id, 0, player_custom_wheelalignment [ playerid ] [ 0 ] ) ;
		SetVehicleWheelAlignment ( playerid, _v_id, 1, player_custom_wheelalignment [ playerid ] [ 1 ] ) ;
		
		SetVehicleWheelOffset ( playerid, _v_id, 0, player_custom_wheeloffstet [ playerid ] [ 0 ] ) ;
		SetVehicleWheelOffset ( playerid, _v_id, 1, player_custom_wheeloffstet [ playerid ] [ 1 ] ) ;
		
		new _r, _g, _b ;
		color_converter ( rgb_array [ player_custom_lights_color [ playerid ] ], _r, _g, _b ) ;
		SetVehicleLightsColors ( playerid, _v_id, _r, _g, _b ) ;
		
		if ( player_custom_shadow_color [ playerid ] )
		{
			if ( player_custom_shadow_type [ playerid ] == eNeonTypes_ON_TYPE_TEXTURE )
			{
				new tex_name [ 32 ] ;
				color_converter ( rgb_array [ 1 ], _r, _g, _b ) ;

				format ( tex_name, sizeof tex_name, "neon_%d", player_custom_shadow_color [ playerid ] ) ;
				SetVehicleNeon ( playerid, _v_id, 7, 6, _r, _g, _b, tex_name ) ;
			}
			else 
			{
				color_converter ( rgb_array [ player_custom_shadow_color [ playerid ] ], _r, _g, _b ) ;
				SetVehicleNeon ( playerid, _v_id, 7, 6, _r, _g, _b, "coronastar" ) ;
			}
		}
		
		new _toner_id = player_custom_toner [ playerid ] ;
		SetVehicleToner ( playerid, _v_id, _toner_id, _toner_id, _toner_id, tuning_name_toner ( _v_id ) ) ;
		
		new _vinyl_id = player_custom_vinyl [ playerid ] ;
		SetVehicleVinyls ( playerid, _v_id, _vinyl_id, _vinyl_id, tuning_name_vinyl ( _v_id ) ) ;*/
		
		new _pos ;
		if ( p_t_info [ playerid ] [ tune_pos ] [ 0 ] ) _pos = 0 ;
		else _pos = 1 ;
	    SetPlayerCameraPos ( playerid, tuning_camera_positions [ _pos ] [ 0 ] [ 0 ], tuning_camera_positions [ _pos ] [ 0 ] [ 1 ], tuning_camera_positions [ _pos ] [ 0 ] [ 2 ] ) ;
		SetPlayerCameraLookAt ( playerid, tuning_camera_positions [ _pos ] [ 0 ] [ 3 ], tuning_camera_positions [ _pos ] [ 0 ] [ 4 ], tuning_camera_positions [ _pos ] [ 0 ] [ 5 ] ) ;
		SetPVarInt ( playerid, "tuning_page_camera", 1 ) ;
		
		p_t_info [ playerid ] [ total_price ] = 0 ;
		for ( new i = 0 ; i < 13 ; i ++ ) p_t_info [ playerid ] [ component_id ] [ i ] = 0 ;
		
		page_count [ playerid ] = 1 ;
		page_rows [ playerid ] = 0 ;
	}
	else
	{
		player_custom_suspension [ playerid ] [ 0 ] =
		player_custom_suspension [ playerid ] [ 1 ] = 0.0 ;
		player_custom_wheelsize [ playerid ] = 0.0 ;
		
		player_custom_wheelwidth [ playerid ] = 0 ;
		player_custom_wheelalignment [ playerid ] [ 0 ] =
		player_custom_wheelalignment [ playerid ] [ 1 ] = 0 ;
		player_custom_wheeloffstet [ playerid ] [ 0 ] =
		player_custom_wheeloffstet [ playerid ] [ 1 ] = 0 ;
		
		player_custom_lights_color [ playerid ] =
		player_custom_shadow_color [ playerid ] =
		player_custom_shadow_type [ playerid ] = 0 ;
		
		player_custom_toner [ playerid ] = 1 ;
		player_custom_vinyl [ playerid ] = 0 ;
		
		player_use_custom [ playerid ] = false ;
		player_used_paint [ playerid ] = false ;
		
		show_paint_ptd ( playerid, -1, false ) ;
		
		if ( player_device { playerid } != 2 )
		{
			for ( new i = 0 ; i < 48 ; i ++ )
			{
				PlayerTextDrawDestroy ( playerid, ptd_t_custom [ playerid ] [ i ] ) ;
				ptd_t_custom [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
		
		}
		CancelSelectTextDraw ( playerid ) ;
		SetCameraBehindPlayer ( playerid ) ;
		
		DeletePVar ( playerid, "tuning_page_camera" ) ;
	}
	return 1 ;
}

stock save_car_custom ( _v_id )
{
	global_string [ 0 ] = EOS ;
	if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_player )
	{
		format ( global_string, 512, "UPDATE `users_vehicles` SET `v_suspension` = '%f|%f', `v_wheel_size` = '%f',\
													`v_wheel_width` = '%d', `v_wheel_alignment` = '%d|%d', `v_wheel_offset` = '%d|%d',\
													`v_lights_color` = '%d', `v_neon` = '%d', `v_neon_type` = '%d',\
													`v_toner` = '%d|%d|%d|%d', `v_vinyl` = '%d' WHERE `v_id` = '%d' LIMIT 1",
		veh_info [ _v_id - 1 ] [ v_suspension ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_suspension ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_wheel_size ],
		veh_info [ _v_id - 1 ] [ v_wheel_width ],
		veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_lights_color ],
		veh_info [ _v_id - 1 ] [ v_neon ],
		veh_info [ _v_id - 1 ] [ v_neon_type ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
		veh_info [ _v_id - 1 ] [ v_vinyl ],
		veh_info [ _v_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, global_string ) ;
	}
	else if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_family )
	{
		format ( global_string, 512, "UPDATE `familys_vehicles` SET `v_suspension` = '%f|%f', `v_wheel_size` = '%f',\
													`v_wheel_width` = '%d', `v_wheel_alignment` = '%d|%d', `v_wheel_offset` = '%d|%d',\
													`v_lights_color` = '%d', `v_neon` = '%d', `v_neon_type` = '%d',\
													`v_toner` = '%d|%d|%d|%d', `v_vinyl` = '%d' WHERE `sv_id` = '%d' LIMIT 1",
		veh_info [ _v_id - 1 ] [ v_suspension ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_suspension ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_wheel_size ],
		veh_info [ _v_id - 1 ] [ v_wheel_width ],
		veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_lights_color ],
		veh_info [ _v_id - 1 ] [ v_neon ],
		veh_info [ _v_id - 1 ] [ v_neon_type ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
		veh_info [ _v_id - 1 ] [ v_vinyl ],
		veh_info [ _v_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, global_string ) ;
	}
	else if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_rentcar )
	{		
		format ( global_string, 512, "UPDATE `rent_vehicles` SET `v_suspension` = '%f|%f', `v_wheel_size` = '%f',\
													`v_wheel_width` = '%d', `v_wheel_alignment` = '%d|%d', `v_wheel_offset` = '%d|%d',\
													`v_lights_color` = '%d', `v_neon` = '%d', `v_neon_type` = '%d',\
													`v_toner` = '%d|%d|%d|%d', `v_vinyl` = '%d' WHERE `sv_id` = '%d' LIMIT 1",
		veh_info [ _v_id - 1 ] [ v_suspension ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_suspension ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_wheel_size ],
		veh_info [ _v_id - 1 ] [ v_wheel_width ],
		veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_lights_color ],
		veh_info [ _v_id - 1 ] [ v_neon ],
		veh_info [ _v_id - 1 ] [ v_neon_type ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
		veh_info [ _v_id - 1 ] [ v_vinyl ],
		veh_info [ _v_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, global_string ) ;
	}
	else if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_house )
	{
		format ( global_string, 512, "UPDATE `house_vehicles` SET `v_suspension` = '%f|%f', `v_wheel_size` = '%f',\
													`v_wheel_width` = '%d', `v_wheel_alignment` = '%d|%d', `v_wheel_offset` = '%d|%d',\
													`v_lights_color` = '%d', `v_neon` = '%d', `v_neon_type` = '%d',\
													`v_toner` = '%d|%d|%d|%d', `v_vinyl` = '%d' WHERE `sv_id` = '%d' LIMIT 1",
		veh_info [ _v_id - 1 ] [ v_suspension ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_suspension ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_wheel_size ],
		veh_info [ _v_id - 1 ] [ v_wheel_width ],
		veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_wheel_alignment ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_wheel_offset ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_lights_color ],
		veh_info [ _v_id - 1 ] [ v_neon ],
		veh_info [ _v_id - 1 ] [ v_neon_type ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 0 ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 1 ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 2 ],
		veh_info [ _v_id - 1 ] [ v_toner ] [ 3 ],
		veh_info [ _v_id - 1 ] [ v_vinyl ],
		veh_info [ _v_id - 1 ] [ v_id ] ) ;
		mysql_tquery ( sql_connection, global_string ) ;
	}
	return 1 ;
}

stock show_paint_ptd ( playerid, _type, bool: status )
{
	if ( status )
	{
		if ( player_device { playerid } != 2 ) 
		{
			ptd_t_paint[playerid][0] = CreatePlayerTextDraw(playerid, 61.8329, 146.2545, "Box"); // Tuning Background
			PlayerTextDrawLetterSize(playerid, ptd_t_paint[playerid][0], 0.0000, 4.8997);
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][0], 0.0000, 76.4300);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][0], 2);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][0], -5963521);
			PlayerTextDrawUseBox(playerid, ptd_t_paint[playerid][0], 1);
			PlayerTextDrawBoxColor(playerid, ptd_t_paint[playerid][0], -5963596);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][0], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][0], 1);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][0], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][0], 0);

			ptd_t_paint[playerid][1] = CreatePlayerTextDraw(playerid, 83.6660, 151.0070, "SET COLOR"); // Price Text
			PlayerTextDrawLetterSize(playerid, ptd_t_paint[playerid][1], 0.1868, 0.9196);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][1], 3);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][1], -1);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][1], 15);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][1], 1);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][1], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][1], 1);

			ptd_t_paint[playerid][2] = CreatePlayerTextDraw(playerid, 22.3332, 173.2518, "ld_spac:white"); // пусто
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][2], 79.2200, 142.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][2], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][2], 235802367);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][2], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][2], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][2], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][2], 0);

			ptd_t_paint[playerid][3] = CreatePlayerTextDraw(playerid, 19.3332, 303.5038, "ld_beat:chit"); // пусто
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][3], 17.0000, 23.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][3], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][3], 235802367);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][3], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][3], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][3], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][3], 0);

			ptd_t_paint[playerid][4] = CreatePlayerTextDraw(playerid, 87.3666, 303.5038, "ld_beat:chit"); // пусто
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][4], 17.0000, 23.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][4], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][4], 235802367);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][4], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][4], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][4], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][4], 0);

			ptd_t_paint[playerid][5] = CreatePlayerTextDraw(playerid, 19.3332, 161.6369, "ld_beat:chit"); // пусто
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][5], 17.0000, 23.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][5], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][5], 235802367);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][5], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][5], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][5], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][5], 0);

			ptd_t_paint[playerid][6] = CreatePlayerTextDraw(playerid, 87.3666, 161.6369, "ld_beat:chit"); // пусто
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][6], 17.0000, 23.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][6], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][6], 235802367);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][6], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][6], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][6], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][6], 0);

			ptd_t_paint[playerid][7] = CreatePlayerTextDraw(playerid, 27.9997, 165.3704, "ld_spac:white"); // пусто
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][7], 68.0000, 157.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][7], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][7], 235802367);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][7], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][7], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][7], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][7], 0);

			ptd_t_paint[playerid][8] = CreatePlayerTextDraw(playerid, 29.5983, 170.6934, "o"); // Buy Background
			PlayerTextDrawLetterSize(playerid, ptd_t_paint[playerid][8], 0.4083, 3.1082);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][8], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][8], 437918463);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][8], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][8], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][8], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][8], 0);

			ptd_t_paint[playerid][9] = CreatePlayerTextDraw(playerid, 84.4017, 170.6934, "o"); // Buy Background
			PlayerTextDrawLetterSize(playerid, ptd_t_paint[playerid][9], 0.4083, 3.1082);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][9], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][9], 437918463);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][9], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][9], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][9], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][9], 0);

			ptd_t_paint[playerid][10] = CreatePlayerTextDraw(playerid, 37.6665, 179.0592, "ld_spac:white"); // пусто
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][10], 51.0000, 15.4097);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][10], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][10], 437918463);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][10], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][10], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][10], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][10], 0);

			ptd_t_paint[playerid][11] = CreatePlayerTextDraw(playerid, 31.3332, 180.7185, "ld_spac:white"); // пусто
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][11], 62.0000, 11.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][11], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][11], 437918463);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][11], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][11], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][11], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][11], 0);

			ptd_t_paint[playerid][12] = CreatePlayerTextDraw(playerid, 61.9999, 181.7037, "50%"); // пусто
			PlayerTextDrawLetterSize(playerid, ptd_t_paint[playerid][12], 0.2090, 1.0398);
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][12], 15.0000, 63.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][12], 2);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][12], -1);
			PlayerTextDrawUseBox(playerid, ptd_t_paint[playerid][12], 1);
			PlayerTextDrawBoxColor(playerid, ptd_t_paint[playerid][12], 0);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][12], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][12], 3);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][12], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][12], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_paint[playerid][12], true);

			ptd_t_paint[playerid][13] = CreatePlayerTextDraw(playerid, 22.1648, 321.0140, "o"); // Buy Background
			PlayerTextDrawLetterSize(playerid, ptd_t_paint[playerid][13], 0.4079, 3.0666);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][13], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][13], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][13], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][13], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][13], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][13], 0);

			ptd_t_paint[playerid][14] = CreatePlayerTextDraw(playerid, 91.3983, 321.0140, "o"); // Buy Background
			PlayerTextDrawLetterSize(playerid, ptd_t_paint[playerid][14], 0.4079, 3.0666);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][14], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][14], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][14], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][14], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][14], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][14], 0);

			ptd_t_paint[playerid][15] = CreatePlayerTextDraw(playerid, 49.4314, 321.0140, "o"); // Buy Background
			PlayerTextDrawLetterSize(playerid, ptd_t_paint[playerid][15], 0.4079, 3.0666);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][15], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][15], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][15], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][15], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][15], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][15], 0);

			ptd_t_paint[playerid][16] = CreatePlayerTextDraw(playerid, 64.6312, 321.0140, "o"); // Buy Background
			PlayerTextDrawLetterSize(playerid, ptd_t_paint[playerid][16], 0.4079, 3.0666);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][16], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][16], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][16], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][16], 2);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][16], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][16], 0);

			ptd_t_paint[playerid][17] = CreatePlayerTextDraw(playerid, 23.9999, 330.8815, "ld_spac:white"); // пусто
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][17], 34.0000, 12.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][17], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][17], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][17], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][17], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][17], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][17], 0);

			ptd_t_paint[playerid][18] = CreatePlayerTextDraw(playerid, 66.3331, 330.0519, "ld_spac:white"); // пусто
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][18], 34.0000, 12.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][18], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][18], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][18], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][18], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][18], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][18], 0);

			ptd_t_paint[playerid][19] = CreatePlayerTextDraw(playerid, 30.3332, 329.3222, "ld_spac:white"); // пусто
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][19], 21.0000, 15.3000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][19], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][19], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][19], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][19], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][19], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][19], 0);

			ptd_t_paint[playerid][20] = CreatePlayerTextDraw(playerid, 72.6666, 329.3370, "ld_spac:white"); // пусто
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][20], 21.0000, 15.3000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][20], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][20], -5963521);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][20], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][20], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][20], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][20], 0);

			ptd_t_paint[playerid][21] = CreatePlayerTextDraw(playerid, 40.6665, 331.0368, "<<"); // пусто
			PlayerTextDrawLetterSize(playerid, ptd_t_paint[playerid][21], 0.1356, 1.2223);
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][21], 10.0000, 35.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][21], 2);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][21], -1);
			PlayerTextDrawUseBox(playerid, ptd_t_paint[playerid][21], 1);
			PlayerTextDrawBoxColor(playerid, ptd_t_paint[playerid][21], 0);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][21], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][21], 1);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][21], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][21], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_paint[playerid][21], true);

			ptd_t_paint[playerid][22] = CreatePlayerTextDraw(playerid, 83.3331, 331.0368, ">>"); // пусто
			PlayerTextDrawLetterSize(playerid, ptd_t_paint[playerid][22], 0.1356, 1.2223);
			PlayerTextDrawTextSize(playerid, ptd_t_paint[playerid][22], 10.0000, 35.0000);
			PlayerTextDrawAlignment(playerid, ptd_t_paint[playerid][22], 2);
			PlayerTextDrawColor(playerid, ptd_t_paint[playerid][22], -1);
			PlayerTextDrawUseBox(playerid, ptd_t_paint[playerid][22], 1);
			PlayerTextDrawBoxColor(playerid, ptd_t_paint[playerid][22], 0);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint[playerid][22], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint[playerid][22], 1);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint[playerid][22], 1);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint[playerid][22], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_paint[playerid][22], true);
			
			update_custom_paint ( playerid, _type, false ) ;
			
			for ( new i = 0 ; i < 35 ; i ++ )
			{
				if ( ptd_t_paint [ playerid ] [ i ] == PlayerText:-1 ) continue ;
				PlayerTextDrawShow ( playerid, ptd_t_paint [ playerid ] [ i ] ) ;
			}
			
			new _td_string [ 24 ] ;
			format  ( _td_string, sizeof _td_string, "%d%%", player_custom_toner_percent [ playerid ] ) ;
			PlayerTextDrawSetString ( playerid, ptd_t_paint [ playerid ] [ 12 ], _td_string ) ;
		}
		else if ( player_device { playerid } == 2 )
		{
			
		}
		
		player_last_select_tune [ playerid ] = -1 ;
		
		player_custom_toner_percent [ playerid ] = 30 ;
		player_used_paint [ playerid ] = true ;
	}
	else
	{
		if ( player_device { playerid } != 2 )
		{
			for ( new i = 0 ; i < 35 ; i ++ )
			{
				if ( ptd_t_paint [ playerid ] [ i ] == PlayerText:-1 ) continue ;
				PlayerTextDrawDestroy ( playerid, ptd_t_paint [ playerid ] [ i ] ) ;
				ptd_t_paint [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
		
		}
		player_used_paint [ playerid ] = false ;
	}
	return 1 ;
}

stock update_custom_paint ( playerid, _type, bool: status )
{
	if ( status )
	{
		if ( player_device { playerid } != 2 )
		{
			for ( new i = 23 ; i < 35 ; i ++ )
			{
				if ( ptd_t_paint [ playerid ] [ i ] == PlayerText:-1 ) continue ;
				PlayerTextDrawDestroy ( playerid, ptd_t_paint [ playerid ] [ i ] ) ;
				ptd_t_paint [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
		
		}
		player_last_select_tune [ playerid ] = -1 ;
	}
	
	if ( _type == 8 || _type == 9 ) page_rows [ playerid ] = sizeof rgb_array ;
	else if ( _type == 10 ) page_rows [ playerid ] = sizeof remap_toner ;
	else if ( _type == 11 ) page_rows [ playerid ] = sizeof custom_body ;
	else if ( _type == 12 ) page_rows [ playerid ] = sizeof custom_neon ;
	
	if ( player_device { playerid } != 2 )
	{
		static const Float: _position_box [ ] [ 2 ] =
		{
			{ 29.9999, 204.3627 },
			{ 53.0000, 204.3627 },
			{ 76.3335, 204.3627 },
			{ 29.9999, 231.7407 },
			{ 53.0000, 231.7406 },
			{ 76.3335, 231.7406 },
			{ 29.9999, 259.5332 },
			{ 53.0000, 259.5332 },
			{ 76.3335, 259.5332 },
			{ 29.9999, 286.9111 },
			{ 53.0000, 286.9111 },
			{ 76.3335, 286.9111 }
		} ;

		new td_string [ 32 ] ;
		for ( new i = 23 ; i < 35 ; i ++ )
		{
			if ( _type == 10 ) 
			{
				if ( i - 23 >= sizeof remap_toner ) break ;
				
				new _toner_id ;
				if ( page_count [ playerid ] > 1 ) _toner_id = ( 12 * ( page_count [ playerid ] - 1 ) ) + ( ( i - 23 ) + 1 ) ;
				else _toner_id = i - 23 ;
			
				format ( td_string, sizeof td_string, "samp:v_cust_t_%d", remap_toner [ _toner_id ] [ 1 ] ) ;
			}
			else if ( _type == 11 ) 
			{
				if ( i - 23 == 0 && page_count [ playerid ] == 1 ) format ( td_string, sizeof td_string, "ld_spac:white" ) ;
				else 
				{
					new _vinyl_id ;
					if ( page_count [ playerid ] > 1 ) 
					{
						_vinyl_id = ( 12 * ( page_count [ playerid ] - 1 ) ) + ( ( i - 23 ) + 1 ) ;
						if ( _vinyl_id >= sizeof custom_body - 1 ) break ;
					}
					else _vinyl_id = i - 23 ;
				
					format ( td_string, sizeof td_string, "samp:v_cust_body_%d", custom_body [ _vinyl_id ] ) ;
				}
			}
			else if ( _type == 12 ) 
			{
				if ( i - 23 == 0 && page_count [ playerid ] == 1 ) format ( td_string, sizeof td_string, "ld_spac:white" ) ;
				else 
				{
					new _neon_id ;
					if ( page_count [ playerid ] > 1 ) 
					{
						_neon_id = ( 12 * ( page_count [ playerid ] - 1 ) ) + ( ( i - 23 ) + 1 ) ;
						if ( _neon_id >= sizeof custom_neon - 1 ) break ;
					}
					else _neon_id = i - 23 ;
				
					format ( td_string, sizeof td_string, "samp:neon_%d", custom_neon [ _neon_id ] ) ;
				}
			}
			ptd_t_paint [ playerid ] [ i ] = CreatePlayerTextDraw(playerid, _position_box [ i - 23 ] [ 0 ], _position_box [ i - 23 ] [ 1 ], td_string);
			PlayerTextDrawTextSize(playerid, ptd_t_paint [ playerid ] [ i ], 18.0000, 22.0400);
			PlayerTextDrawAlignment(playerid, ptd_t_paint [ playerid ] [ i ], 1);
			PlayerTextDrawColor(playerid, ptd_t_paint [ playerid ] [ i ], -1);
			PlayerTextDrawBackgroundColor(playerid, ptd_t_paint [ playerid ] [ i ], 255);
			PlayerTextDrawFont(playerid, ptd_t_paint [ playerid ] [ i ], 4);
			PlayerTextDrawSetProportional(playerid, ptd_t_paint [ playerid ] [ i ], 0);
			PlayerTextDrawSetShadow(playerid, ptd_t_paint [ playerid ] [ i ], 0);
			PlayerTextDrawSetSelectable(playerid, ptd_t_paint [ playerid ] [ i ], true);
		}
	}
	
	if ( status )
	{
		if ( player_device { playerid } != 2 )
		{
			for ( new i = 23 ; i < 35 ; i ++ )
			{
				if ( ptd_t_paint [ playerid ] [ i ] == PlayerText:-1 ) continue ;
				PlayerTextDrawShow ( playerid, ptd_t_paint [ playerid ] [ i ] ) ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
		
		}
		
		player_last_select_tune [ playerid ] = -1 ;
	}
	return 1 ;
}

stock tuning_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_donate_neon:
		{
			if ( ! response ) return 1 ;
			
			new _page_id = player_custom_page { playerid } ;

			if ( ! get_player_donate ( playerid, custom_price [ _page_id ], 2 ) )
			{
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
				{"#cRD"}* У Вас недостаточно средств для приобретения данной услуги.\n\n\
				{"#cGRDialog"}- {"#cWH"}Установка неона:\n\n\
				{"#cGRDialog"}* Цена: {"#cGN"}200 "donate_title"{"#cGRDialog"}.\n\
				{"#cGRDialog"}* Вы действительно хотите установить \"{"#cWH"}неон{"#cGRDialog"}\".", "Назад", "" ) ;
				return 1 ;
			}
				
			set_player_donate ( playerid, custom_price [ _page_id ], 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, custom_price [ _page_id ], p_info [ playerid ] [ donate ], "(donate) neon" ) ;
			
			new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
			veh_info [ _veh_id - 1 ] [ v_neon ] = player_custom_shadow_color [ playerid ] ;
			veh_info [ _veh_id - 1 ] [ v_neon_type ] = eNeonTypes_ON_TYPE_TEXTURE ;
				
			save_car_custom ( _veh_id ) ;
			clear_car_custom ( _veh_id, 3, playerid ) ;
			
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Детейлинг", "{"#cBHD"}Выбранные комопоненты успешно установлены.", "Закрыть", "" ) ;
			return 1 ;
		}
		case d_detail_tune:
		{
			if ( ! response ) return 1 ;
			
			new _b_price = b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_cost ] ;
			new _veh_id = p_t_info [ playerid ] [ tuning_vehicle ] ;
			new _price = p_t_info [ playerid ] [ total_price ] * _b_price ;
			
			if ( p_info [ playerid ] [ money ] < _price ) 
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно средств." ) ;
			
			give_money ( playerid, -_price ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -_price, "кастомный тюнинг" ) ;
			
			for ( new i = 0 ; i < 13 ; i ++ )
			{
				if ( ! p_t_info [ playerid ] [ component_id ] [ i ] ) continue ;
				
				p_t_info [ playerid ] [ component_id ] [ i ] = 0 ;
				
				if ( i == 0 ) veh_info [ _veh_id - 1 ] [ v_suspension ] [ 0 ] = player_custom_suspension [ playerid ] [ 0 ] ;
				else if ( i == 1 ) veh_info [ _veh_id - 1 ] [ v_suspension ] [ 1 ] = player_custom_suspension [ playerid ] [ 1 ] ;
				else if ( i == 2 ) veh_info [ _veh_id - 1 ] [ v_wheel_size ] = player_custom_wheelsize [ playerid ] ;
				else if ( i == 3 ) veh_info [ _veh_id - 1 ] [ v_wheel_width ] = player_custom_wheelwidth [ playerid ] ;
				else if ( i == 4 ) veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 0 ] = player_custom_wheelalignment [ playerid ] [ 0 ] ;
				else if ( i == 5 ) veh_info [ _veh_id - 1 ] [ v_wheel_alignment ] [ 1 ] = player_custom_wheelalignment [ playerid ] [ 1 ] ;
				else if ( i == 6 ) veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 0 ] = player_custom_wheeloffstet [ playerid ] [ 0 ] ;
				else if ( i == 7 ) veh_info [ _veh_id - 1 ] [ v_wheel_offset ] [ 1 ] = player_custom_wheeloffstet [ playerid ] [ 1 ] ;
				else if ( i == 8 ) veh_info [ _veh_id - 1 ] [ v_lights_color ] = player_custom_lights_color [ playerid ] ;
				else if ( i == 9 )
				{
					veh_info [ _veh_id - 1 ] [ v_neon ] = player_custom_shadow_color [ playerid ] ;
					veh_info [ _veh_id - 1 ] [ v_neon_type ] = player_custom_shadow_type [ playerid ] ;
				}
				else if ( i == 10 ) veh_info [ _veh_id - 1 ] [ v_toner ] = player_custom_toner [ playerid ] ;
				else if ( i == 11 ) veh_info [ _veh_id - 1 ] [ v_vinyl ] = player_custom_vinyl [ playerid ] ;
				else if ( i == 12 )
				{
					veh_info [ _veh_id - 1 ] [ v_neon ] = player_custom_shadow_color [ playerid ] ;
					veh_info [ _veh_id - 1 ] [ v_neon_type ] = player_custom_shadow_type [ playerid ] ;
				}
			}
			
			save_car_custom ( _veh_id ) ;
			
			show_ptd_custom ( playerid, false ) ;
			clear_car_custom ( _veh_id, 3, playerid ) ;
			
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Детейлинг", "{"#cBHD"}Выбранные комопоненты успешно установлены.", "Закрыть", "" ) ;
			return 1 ;
		}
	}
	return 0 ;
}