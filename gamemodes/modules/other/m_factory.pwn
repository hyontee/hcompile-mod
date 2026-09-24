#define area_type_factory_meat 100
#define area_type_factory_apple 101
#define area_type_factory_army 103
#define area_type_factory_army_take 104

new PlayerText: press_abc_PTD [ MAX_PLAYERS ] [ 7 ] ;
new factory_key_id [ 3 ] = { KEY_YES, KEY_NO, KEY_CTRL_BACK } ;

new Float: factory_start_job [ 3 ] = { 874.3621, -245.0471, 653.4221 } ;
new factory_pickup_id ;

new Float: people_factory_pos [ 2 ] [ 4 ] =
{
	{ 876.3964,-231.4647,653.4614,359.3568 },
	{ 878.4698,-236.2314,653.4221,178.2878 }
} ;
new people_factory_pickup_id [ 2 ] ;

new Float: army_factory_pos [ 2 ] [ 4 ] =
{
	{ 913.2983,3.2372,681.9090,358.7385 },
	{ 875.2602,-236.2739,653.4221,177.7742 }
} ;
new army_factory_pickup_id [ 2 ] ;

new player_factory_checkpoint [ MAX_PLAYERS char ] ;
new is_leave_factory_table [ MAX_PLAYERS char ] ;
new player_factory_table [ MAX_PLAYERS char ] ;
new player_factory_progress [ MAX_PLAYERS char ] ;
new player_factory_object [ MAX_PLAYERS ] [ 2 ] ;
new player_factory_toggled [ MAX_PLAYERS ] ;

stock factory_clear_player ( playerid )
{
	player_factory_table { playerid } =
	is_leave_factory_table { playerid } = 
	player_factory_checkpoint { playerid } =
	player_factory_progress { playerid } = 0 ;
	
	player_factory_object [ playerid ] [ 0 ] =
	player_factory_object [ playerid ] [ 1 ] = INVALID_OBJECT_ID ;
	
	player_factory_toggled [ playerid ] = 0 ;
	return 1 ;
}

new Float: factory_warehouse_position [ 3 ] [ 3 ] =
{
	{ 872.0617,-205.2098,653.4221 },
	{ 881.5583,-206.4286,653.4221 },
	{ 905.3158,5.9756,681.8697 }
} ;

/*

	Цех по сборке оружия

*/

new bool: army_toggled = false ;
new army_timer = -1 ;

new army_factory_player [ 6 ] = { INVALID_PLAYER_ID, ... } ;
new army_factory_take_player [ 6 ] = { INVALID_PLAYER_ID, ... } ;

new Text3D: table_army_text [ 6 ],
	Text3D: table_army_take_text [ 6 ] ;
		
new table_army_area [ 6 ],
	table_army_take_area [ 6 ] ;
		
new bool: table_army_toggled [ 6 ] = { false, ... } ;
new Float: table_army_position [ 6 ] [ 3 ] =
{
	{ 916.0431,17.1969,681.8975 },
	{ 916.0439,19.6801,681.8975 },
	{ 916.0439,22.0423,681.8975 },
	{ 919.6037,17.3886,681.9109 },
	{ 919.6013,19.8188,681.9109 },
	{ 919.6013,22.3663,681.9109 }
} ;
	
new bool: table_army_take_toggled [ 6 ] = { false, ... } ;
new Float: table_army_take_position [ 6 ] [ 3 ] =
{
	{ 911.2414,22.4584,681.8697 },
	{ 911.2407,19.9231,681.8697 },
	{ 911.2407,17.4663,681.8697 },
	{ 907.6779,22.3027,681.8975 },
	{ 907.6824,19.7101,681.8975 },
	{ 907.6835,17.3958,681.8975 }
} ;

new army_key_up = -1,
	army_key_down = -1 ;

#define MAX_ARM_OBJ 10
enum _arm_obj
{
	arm_box_id,
	arm_type_move,
	arm_object
} ;
new arm_info [ MAX_ARM_OBJ ] [ _arm_obj ] ;

new factory_box_id [ 3 ] = { 2040, 2969, 3014 } ;
new factory_object_id [ 3 ] = { 2061, 3082, 356 } ;

new Float: army_move_position_1 [ 4 ] [ 2 ] [ 6 ] = 
{
	{
		{ 917.79517, 16.33625, 681.77222,   90.00000, 0.00000, 180.00000 },
		{ 917.7952, 24.4681, 681.7722,   90.00000, 0.00000, 180.00000 }
	},
	{
		{ 917.7952, 24.4681, 681.7722,   90.0000, 0.0000, -90.0000 },
		{ 913.0292, 24.4681, 681.7722,   90.0000, 0.0000, -90.0000 }
	},
	{
		{ 913.0292, 24.4681, 681.8702,   0.0000, 0.0000, -90.0000 },
		{ 909.3965, 24.4681, 681.8702,   0.0000, 0.0000, -90.0000 }
	},
	{
		{ 909.3965, 24.4681, 681.8702,   0.0000, 0.0000, 0.0000 },
		{ 909.3965, 15.5335, 681.8702,   0.0000, 0.0000, 0.0000 }
	}
} ;

new Float: army_move_position_2 [ 4 ] [ 2 ] [ 6 ] = 
{
	{
		{ 917.79944, 16.52409, 681.83862,   90.00000, 0.00000, 0.00000 },
		{ 917.7994, 24.6033, 681.8386,   90.00000, 0.00000, 0.00000 }
	},
	{
		{ 917.7994, 24.6033, 681.8386,   90.0000, 0.0000, 90.0000 },
		{ 912.9771, 24.6033, 681.8386,   90.0000, 0.0000, 90.0000 }
	},
	{
		{ 912.9771, 24.4940, 681.8386,   0.0000, 0.0000, 90.0000 },
		{ 909.3758, 24.4940, 681.8386,   0.0000, 0.0000, 90.0000 }
	},
	{
		{ 909.3758, 24.4940, 681.8386,   0.0000, 0.0000, 90.0000 },
		{ 909.3758, 15.6277, 681.8386,   0.0000, 0.0000, 90.0000 }
	}
} ;

new Float: army_move_position_3 [ 4 ] [ 2 ] [ 6 ] = 
{
	{
		{ 917.77356, 16.27864, 681.78888,   90.00000, 0.00000, 90.00000 },
		{ 917.7994, 24.3361, 681.7889,   90.00000, 0.00000, 90.00000 }
	},
	{
		{ 917.7994, 24.3361, 681.7889,   90.00000, 0.00000, 180.00000 },
		{ 913.0943, 24.3361, 681.7889,   90.00000, 0.00000, 180.00000 }
	},
	{
		{ 913.1566, 24.3950, 681.9088,   0.0000, 0.0000, 90.0000 },
		{ 909.4445, 24.3950, 681.9088,   0.0000, 0.0000, 90.0000 }
	},
	{
		{ 909.4445, 24.3950, 681.9088,   0.0000, 0.0000, 90.0000 },
		{ 909.4445, 15.4827, 681.9088,   0.0000, 0.0000, 90.0000 }
	}
} ;

callback: callback_re_create_1 ( playerid )
{
	RemovePlayerAttachedObject ( playerid, 0 ) ;
	RemovePlayerAttachedObject ( playerid, 1 ) ;
	
	ClearAnimations ( playerid, 1 ) ;
	
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы упаковали боеприпасы в ящик." ) ;
	
	TogglePlayerControllable ( playerid, true ) ;
	p_t_info [ playerid ] [ p_animation ] = false ;
	return 1 ;
}

stock re_create_army_object_1 ( i )
{
	arm_info [ i ] [ arm_type_move ] ++ ;
	new _box_id = arm_info [ i ] [ arm_box_id ], _move_id = arm_info [ i ] [ arm_type_move ] ;
	if ( _box_id == 0 )
	{
		arm_info [ i ] [ arm_object ] = CreateDynamicObject ( factory_object_id [ _box_id ], army_move_position_1 [ _move_id ] [ 0 ] [ 0 ], 
																								army_move_position_1 [ _move_id ] [ 0 ] [ 1 ], 
																								army_move_position_1 [ _move_id ] [ 0 ] [ 2 ], 
																								army_move_position_1 [ _move_id ] [ 0 ] [ 3 ], 
																								army_move_position_1 [ _move_id ] [ 0 ] [ 4 ], 
																								army_move_position_1 [ _move_id ] [ 0 ] [ 5 ] ) ;
																									
		MoveDynamicObject ( arm_info [ i ] [ arm_object ], army_move_position_1 [ _move_id ] [ 1 ] [ 0 ], army_move_position_1 [ _move_id ] [ 1 ] [ 1 ], army_move_position_1 [ _move_id ] [ 1 ] [ 2 ], 1.0,
															army_move_position_1 [ _move_id ] [ 1 ] [ 3 ], army_move_position_1 [ _move_id ] [ 1 ] [ 4 ], army_move_position_1 [ _move_id ] [ 1 ] [ 5 ] ) ;
	}
	else if ( _box_id == 1 )
	{
		arm_info [ i ] [ arm_object ] = CreateDynamicObject ( factory_object_id [ _box_id ], army_move_position_2 [ _move_id ] [ 0 ] [ 0 ], 
																								army_move_position_2 [ _move_id ] [ 0 ] [ 1 ], 
																								army_move_position_2 [ _move_id ] [ 0 ] [ 2 ], 
																								army_move_position_2 [ _move_id ] [ 0 ] [ 3 ], 
																								army_move_position_2 [ _move_id ] [ 0 ] [ 4 ], 
																								army_move_position_2 [ _move_id ] [ 0 ] [ 5 ] ) ;
																									
		MoveDynamicObject ( arm_info [ i ] [ arm_object ], army_move_position_2 [ _move_id ] [ 1 ] [ 0 ], army_move_position_2 [ _move_id ] [ 1 ] [ 1 ], army_move_position_2 [ _move_id ] [ 1 ] [ 2 ], 1.0,
															army_move_position_2 [ _move_id ] [ 1 ] [ 3 ], army_move_position_2 [ _move_id ] [ 1 ] [ 4 ], army_move_position_2 [ _move_id ] [ 1 ] [ 5 ] ) ;
	}
	else if ( _box_id == 2 )
	{
		arm_info [ i ] [ arm_object ] = CreateDynamicObject ( factory_object_id [ _box_id ], army_move_position_3 [ _move_id ] [ 0 ] [ 0 ], 
																								army_move_position_3 [ _move_id ] [ 0 ] [ 1 ], 
																								army_move_position_3 [ _move_id ] [ 0 ] [ 2 ], 
																								army_move_position_3 [ _move_id ] [ 0 ] [ 3 ], 
																								army_move_position_3 [ _move_id ] [ 0 ] [ 4 ], 
																								army_move_position_3 [ _move_id ] [ 0 ] [ 5 ] ) ;
																									
		MoveDynamicObject ( arm_info [ i ] [ arm_object ], army_move_position_3 [ _move_id ] [ 1 ] [ 0 ], army_move_position_3 [ _move_id ] [ 1 ] [ 1 ], army_move_position_3 [ _move_id ] [ 1 ] [ 2 ], 1.0,
															army_move_position_3 [ _move_id ] [ 1 ] [ 3 ], army_move_position_3 [ _move_id ] [ 1 ] [ 4 ], army_move_position_3 [ _move_id ] [ 1 ] [ 5 ] ) ;
	}
	return 1 ;
}

stock re_create_army_object_2 ( i )
{
	arm_info [ i ] [ arm_type_move ] ++ ;
	new _box_id = arm_info [ i ] [ arm_box_id ], _move_id = arm_info [ i ] [ arm_type_move ] ;
	if ( _box_id == 0 )
	{
		arm_info [ i ] [ arm_object ] = CreateDynamicObject ( factory_box_id [ _box_id ], army_move_position_1 [ _move_id ] [ 0 ] [ 0 ], 
																								army_move_position_1 [ _move_id ] [ 0 ] [ 1 ], 
																								army_move_position_1 [ _move_id ] [ 0 ] [ 2 ], 
																								army_move_position_1 [ _move_id ] [ 0 ] [ 3 ], 
																								army_move_position_1 [ _move_id ] [ 0 ] [ 4 ], 
																								army_move_position_1 [ _move_id ] [ 0 ] [ 5 ] ) ;
																									
		MoveDynamicObject ( arm_info [ i ] [ arm_object ], army_move_position_1 [ _move_id ] [ 1 ] [ 0 ], army_move_position_1 [ _move_id ] [ 1 ] [ 1 ], army_move_position_1 [ _move_id ] [ 1 ] [ 2 ], 1.0,
															army_move_position_1 [ _move_id ] [ 1 ] [ 3 ], army_move_position_1 [ _move_id ] [ 1 ] [ 4 ], army_move_position_1 [ _move_id ] [ 1 ] [ 5 ] ) ;
	}
	else if ( _box_id == 1 )
	{
		arm_info [ i ] [ arm_object ] = CreateDynamicObject ( factory_box_id [ _box_id ], army_move_position_2 [ _move_id ] [ 0 ] [ 0 ], 
																								army_move_position_2 [ _move_id ] [ 0 ] [ 1 ], 
																								army_move_position_2 [ _move_id ] [ 0 ] [ 2 ], 
																								army_move_position_2 [ _move_id ] [ 0 ] [ 3 ], 
																								army_move_position_2 [ _move_id ] [ 0 ] [ 4 ], 
																								army_move_position_2 [ _move_id ] [ 0 ] [ 5 ] ) ;
																									
		MoveDynamicObject ( arm_info [ i ] [ arm_object ], army_move_position_2 [ _move_id ] [ 1 ] [ 0 ], army_move_position_2 [ _move_id ] [ 1 ] [ 1 ], army_move_position_2 [ _move_id ] [ 1 ] [ 2 ], 1.0,
															army_move_position_2 [ _move_id ] [ 1 ] [ 3 ], army_move_position_2 [ _move_id ] [ 1 ] [ 4 ], army_move_position_2 [ _move_id ] [ 1 ] [ 5 ] ) ;
	}
	else if ( _box_id == 2 )
	{
		arm_info [ i ] [ arm_object ] = CreateDynamicObject ( factory_box_id [ _box_id ], army_move_position_3 [ _move_id ] [ 0 ] [ 0 ], 
																								army_move_position_3 [ _move_id ] [ 0 ] [ 1 ], 
																								army_move_position_3 [ _move_id ] [ 0 ] [ 2 ], 
																								army_move_position_3 [ _move_id ] [ 0 ] [ 3 ], 
																								army_move_position_3 [ _move_id ] [ 0 ] [ 4 ], 
																								army_move_position_3 [ _move_id ] [ 0 ] [ 5 ] ) ;
																									
		MoveDynamicObject ( arm_info [ i ] [ arm_object ], army_move_position_3 [ _move_id ] [ 1 ] [ 0 ], army_move_position_3 [ _move_id ] [ 1 ] [ 1 ], army_move_position_3 [ _move_id ] [ 1 ] [ 2 ], 1.0,
															army_move_position_3 [ _move_id ] [ 1 ] [ 3 ], army_move_position_3 [ _move_id ] [ 1 ] [ 4 ], army_move_position_3 [ _move_id ] [ 1 ] [ 5 ] ) ;
	}
	
	if ( _move_id == 3 )
	{
		new _key_id = random ( sizeof factory_key_id ) ;
		army_key_down = factory_key_id [ _key_id ] ;
		
		for ( new p = 0 ; p < sizeof army_factory_take_player ; p ++ )
		{
			if ( army_factory_take_player [ p ] == INVALID_PLAYER_ID ) continue ;
						
			new playerid = army_factory_take_player [ p ] ;
			if ( ! IsPlayerInDynamicArea ( playerid, table_army_take_area [ player_factory_table { playerid } - 1 ] ) ) continue ;
						
			if ( army_key_down == KEY_YES ) PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "PRESS:_Y" ) ;
			else if ( army_key_down == KEY_NO ) PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "PRESS:_N" ) ;
			else if ( army_key_down == KEY_CTRL_BACK ) PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "PRESS:_H" ) ;
		}
	}
	return 1 ;
}

callback: callback_army_move ( )
{
	for ( new i = 0 ; i < MAX_ARM_OBJ ; i ++ )
	{
		if ( arm_info [ i ] [ arm_object ] != INVALID_OBJECT_ID ) continue ;
		
		arm_info [ i ] [ arm_box_id ] = random ( sizeof factory_object_id ) ;
		arm_info [ i ] [ arm_type_move ] = 0 ;
		
		new _box_id = arm_info [ i ] [ arm_box_id ], _move_id = arm_info [ i ] [ arm_type_move ] ;
		if ( _box_id == 0 )
		{
			arm_info [ i ] [ arm_object ] = CreateDynamicObject ( factory_object_id [ _box_id ], army_move_position_1 [ _move_id ] [ 0 ] [ 0 ], 
																									army_move_position_1 [ _move_id ] [ 0 ] [ 1 ], 
																									army_move_position_1 [ _move_id ] [ 0 ] [ 2 ], 
																									army_move_position_1 [ _move_id ] [ 0 ] [ 3 ], 
																									army_move_position_1 [ _move_id ] [ 0 ] [ 4 ], 
																									army_move_position_1 [ _move_id ] [ 0 ] [ 5 ] ) ;
																									
			MoveDynamicObject ( arm_info [ i ] [ arm_object ], army_move_position_1 [ _move_id ] [ 1 ] [ 0 ], army_move_position_1 [ _move_id ] [ 1 ] [ 1 ], army_move_position_1 [ _move_id ] [ 1 ] [ 2 ], 1.0,
																army_move_position_1 [ _move_id ] [ 1 ] [ 3 ], army_move_position_1 [ _move_id ] [ 1 ] [ 4 ], army_move_position_1 [ _move_id ] [ 1 ] [ 5 ] ) ;
		}
		else if ( _box_id == 1 )
		{
			arm_info [ i ] [ arm_object ] = CreateDynamicObject ( factory_object_id [ _box_id ], army_move_position_2 [ _move_id ] [ 0 ] [ 0 ], 
																									army_move_position_2 [ _move_id ] [ 0 ] [ 1 ], 
																									army_move_position_2 [ _move_id ] [ 0 ] [ 2 ], 
																									army_move_position_2 [ _move_id ] [ 0 ] [ 3 ], 
																									army_move_position_2 [ _move_id ] [ 0 ] [ 4 ], 
																									army_move_position_2 [ _move_id ] [ 0 ] [ 5 ] ) ;
																									
			MoveDynamicObject ( arm_info [ i ] [ arm_object ], army_move_position_2 [ _move_id ] [ 1 ] [ 0 ], army_move_position_2 [ _move_id ] [ 1 ] [ 1 ], army_move_position_2 [ _move_id ] [ 1 ] [ 2 ], 1.0,
																army_move_position_2 [ _move_id ] [ 1 ] [ 3 ], army_move_position_2 [ _move_id ] [ 1 ] [ 4 ], army_move_position_2 [ _move_id ] [ 1 ] [ 5 ] ) ;
		}
		else if ( _box_id == 2 )
		{
			arm_info [ i ] [ arm_object ] = CreateDynamicObject ( factory_object_id [ _box_id ], army_move_position_3 [ _move_id ] [ 0 ] [ 0 ], 
																									army_move_position_3 [ _move_id ] [ 0 ] [ 1 ], 
																									army_move_position_3 [ _move_id ] [ 0 ] [ 2 ], 
																									army_move_position_3 [ _move_id ] [ 0 ] [ 3 ], 
																									army_move_position_3 [ _move_id ] [ 0 ] [ 4 ], 
																									army_move_position_3 [ _move_id ] [ 0 ] [ 5 ] ) ;
																									
			MoveDynamicObject ( arm_info [ i ] [ arm_object ], army_move_position_3 [ _move_id ] [ 1 ] [ 0 ], army_move_position_3 [ _move_id ] [ 1 ] [ 1 ], army_move_position_3 [ _move_id ] [ 1 ] [ 2 ], 1.0,
																army_move_position_3 [ _move_id ] [ 1 ] [ 3 ], army_move_position_3 [ _move_id ] [ 1 ] [ 4 ], army_move_position_3 [ _move_id ] [ 1 ] [ 5 ] ) ;
		}

		new _key_id = random ( sizeof factory_key_id ) ;
		army_key_up = factory_key_id [ _key_id ] ;

		for ( new p = 0 ; p < sizeof army_factory_player ; p ++ )
		{
			if ( army_factory_player [ p ] == INVALID_PLAYER_ID ) continue ;
				
			new playerid = army_factory_player [ p ] ;
			if ( ! IsPlayerInDynamicArea ( playerid, table_army_area [ player_factory_table { playerid } - 1 ] ) ) continue ;
			if ( p_t_info [ playerid ] [ p_animation ] ) continue ;
			
			if ( army_key_up == KEY_YES ) PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "PRESS:_Y" ) ;
			else if ( army_key_up == KEY_NO ) PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "PRESS:_N" ) ;
			else if ( army_key_up == KEY_CTRL_BACK ) PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "PRESS:_H" ) ;
			
			GetPlayerFacingAngle ( playerid, p_t_info [ playerid ] [ p_pos ] [ 3 ] ) ;
			set_pos ( playerid, p_t_info [ playerid ] [ p_pos ] [ 0 ] + 0.01, 
								p_t_info [ playerid ] [ p_pos ] [ 1 ] + 0.01, 
								p_t_info [ playerid ] [ p_pos ] [ 2 ] + 0.01,
								p_t_info [ playerid ] [ p_pos ] [ 3 ], 17, 1 ) ;
		}
		break ;
	}
	return 1 ;
}

/*

	Цех с мясом и яблоками

*/

// МЯСО

new meat_object = INVALID_OBJECT_ID ;

new meat_key_id ;
new Float: meat_move_position [ 2 ] [ 6 ] =
{
	{ 872.4686, -211.5866, 653.3322, 0.0000, 0.0000, 0.0000 },
	{ 872.3377, -218.8587, 653.3322, 0.0000, 0.0000, 0.0000 }
} ;

new Float: meat_in_table [ 12 ] [ 6 ] =
{
	{ 873.5990, -212.9940, 653.3322, 0.0000, 0.0000, 90.0000 },
	{ 873.5990, -213.3540, 653.3322, 0.0000, 0.0000, 90.0000 },
	{ 873.6356, -215.4377, 653.3322, 0.0000, 0.0000, 90.0000 },
	{ 873.5990, -215.8139, 653.3322, 0.0000, 0.0000, 90.0000 },
	{ 873.5990, -217.8740, 653.3322, 0.0000, 0.0000, 90.0000 },
	{ 873.5990, -218.2339, 653.3322, 0.0000, 0.0000, 90.0000 },
	
	{ 871.5488, -212.9940, 653.3322, 0.0000, 0.0000, 90.0000 },
	{ 871.5488, -213.3540, 653.3322, 0.0000, 0.0000, 90.0000 },
	{ 871.5488, -215.4539, 653.3322, 0.0000, 0.0000, 90.0000 },
	{ 871.5488, -215.8139, 653.3322, 0.0000, 0.0000, 90.0000 },
	{ 871.5488, -217.8740, 653.3322, 0.0000, 0.0000, 90.0000 },
	{ 871.5488, -218.2339, 653.3322, 0.0000, 0.0000, 90.0000 }
} ;

new meat_factory_player [ 6 ] = { INVALID_PLAYER_ID, ... } ;
new table_meat_area [ 6 ] ;
new bool: table_meat_toggled [ 6 ] = { false, ... } ;
new Float: table_meat_position [ 6 ] [ 3 ] =
{
	{ 874.3149,-213.0478,653.4221 },
	{ 874.3157,-215.5553,653.4221 },
	{ 874.3152,-218.0196,653.4221 },
	{ 870.7568,-213.1752,653.4500 },
	{ 870.7576,-215.5728,653.4500 },
	{ 870.7578,-218.0929,653.4500 }
} ;
new Text3D: table_meat_text [ 6 ] ;

callback: callback_fresh_meat ( playerid )
{
	if ( ! IsPlayerConnected ( playerid ) ) return 1 ;
	
	DestroyDynamicObject ( player_factory_object [ playerid ] [ 0 ] ) ;
	DestroyDynamicObject ( player_factory_object [ playerid ] [ 1 ] ) ;
	player_factory_object [ playerid ] [ 0 ] =
	player_factory_object [ playerid ] [ 1 ] = INVALID_OBJECT_ID ;
	
	SetPlayerAttachedObject ( playerid, 0, 3013, 6, 0.0, 0.10, -0.2, -110.0, 0.0, 0.0 ) ;
	p_t_info [ playerid ] [ p_animation ] = true ;
	
	TogglePlayerControllable ( playerid, true ) ;
	ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
	
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отнесите ящик к остальным заготовкам." ) ;
	
	show_factory_ptd ( playerid, false, -1 ) ;
	
	SetPlayerRaceCheckpoint ( playerid, 1, factory_warehouse_position [ 0 ] [ 0 ], factory_warehouse_position [ 0 ] [ 1 ], factory_warehouse_position [ 0 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
	player_factory_checkpoint { playerid } = 1 ;
	return 1 ;
}

callback: callback_moving_meat ( )
{
	meat_object = CreateDynamicObject ( 2806, meat_move_position [ 0 ] [ 0 ], meat_move_position [ 0 ] [ 1 ], meat_move_position [ 0 ] [ 2 ], meat_move_position [ 0 ] [ 3 ], meat_move_position [ 0 ] [ 4 ], meat_move_position [ 0 ] [ 5 ] ) ;
	
	MoveDynamicObject ( meat_object, meat_move_position [ 1 ] [ 0 ], meat_move_position [ 1 ] [ 1 ], meat_move_position [ 1 ] [ 2 ], 1.0,
									meat_move_position [ 1 ] [ 3 ], meat_move_position [ 1 ] [ 4 ], meat_move_position [ 1 ] [ 5 ] ) ;
	
	new _key_id = random ( sizeof factory_key_id ) ;
	meat_key_id = factory_key_id [ _key_id ] ;
	
	for ( new p = 0 ; p < sizeof meat_factory_player ; p ++ )
	{
		if ( meat_factory_player [ p ] == INVALID_PLAYER_ID ) continue ;
			
		new playerid = meat_factory_player [ p ] ;
		if ( ! IsPlayerInDynamicArea ( playerid, table_meat_area [ player_factory_table { playerid } - 1 ] ) ) continue ;
		
		if ( meat_key_id == KEY_YES ) PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "PRESS:_Y" ) ;
		else if ( meat_key_id == KEY_NO ) PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "PRESS:_N" ) ;
		else if ( meat_key_id == KEY_CTRL_BACK ) PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "PRESS:_H" ) ;
		
		GetPlayerFacingAngle ( playerid, p_t_info [ playerid ] [ p_pos ] [ 3 ] ) ;
		set_pos ( playerid, p_t_info [ playerid ] [ p_pos ] [ 0 ] + 0.01, 
							p_t_info [ playerid ] [ p_pos ] [ 1 ] + 0.01, 
							p_t_info [ playerid ] [ p_pos ] [ 2 ] + 0.01,
							p_t_info [ playerid ] [ p_pos ] [ 3 ], 17, 1 ) ;
	}
	return 1 ;
}

// ЯБЛОКИ

new apple_timer = -1 ;

new Float: apple_move_position [ 2 ] [ 6 ] =
{
	{ 880.8479, -217.2924, 653.3286, 0.0000, 0.0000, 0.0000 },
	{ 880.8479, -210.7885, 653.3286, 0.0000, 0.0000, 0.0000 }
} ;

new apple_object [ 5 ] = { INVALID_OBJECT_ID, ... } ;
new bool: apple_toggled = false ;
new apple_factory_player [ 6 ] = { INVALID_PLAYER_ID, ... } ;
new table_apple_area [ 6 ] ;
new bool: table_apple_toggled [ 6 ] = { false, ... } ;
new Float: table_apple_position [ 6 ] [ 3 ] =
{
	{ 879.1182,-212.0785,653.4500 },
	{ 879.1182,-214.4728,653.4500 },
	{ 879.1182,-217.0051,653.4500 },
	{ 882.6760,-216.9347,653.4634 },
	{ 882.6755,-214.4029,653.4634 },
	{ 882.6756,-211.9782,653.4634 }
} ;
new Text3D: table_apple_text [ 6 ] ;

new apple_key_id ;

new Float: apple_in_table [ 6 ] [ 6 ] =
{
	{ 879.8778, -212.0263, 653.2701, 0.0000, 0.0000, 0.0000 },
	{ 879.8778, -214.4963, 653.2701, 0.0000, 0.0000, 0.0000 },
	{ 879.8778, -216.9563, 653.2701, 0.0000, 0.0000, 0.0000 },
	{ 881.8782, -216.9563, 653.2701, 0.0000, 0.0000, 0.0000 },
	{ 881.8782, -214.4463, 653.2701, 0.0000, 0.0000, 0.0000 },
	{ 881.8782, -211.9662, 653.2701, 0.0000, 0.0000, 0.0000 }
} ;

callback: callback_moving_apple ( )
{
	for ( new i = 0 ; i < 5 ; i ++ )
	{
		if ( apple_object [ i ] != INVALID_OBJECT_ID ) continue ;
		
		apple_object [ i ] = CreateDynamicObject ( 19575, apple_move_position [ 0 ] [ 0 ], apple_move_position [ 0 ] [ 1 ], apple_move_position [ 0 ] [ 2 ], apple_move_position [ 0 ] [ 3 ], apple_move_position [ 0 ] [ 4 ], apple_move_position [ 0 ] [ 5 ] ) ;
		
		MoveDynamicObject ( apple_object [ i ], apple_move_position [ 1 ] [ 0 ], apple_move_position [ 1 ] [ 1 ], apple_move_position [ 1 ] [ 2 ], 1.0,
												apple_move_position [ 1 ] [ 3 ], apple_move_position [ 1 ] [ 4 ], apple_move_position [ 1 ] [ 5 ] ) ;

		new _key_id = random ( sizeof factory_key_id ) ;
		apple_key_id = factory_key_id [ _key_id ] ;

		for ( new p = 0 ; p < sizeof meat_factory_player ; p ++ )
		{
			if ( apple_factory_player [ p ] == INVALID_PLAYER_ID ) continue ;
				
			new playerid = apple_factory_player [ p ] ;
			if ( ! IsPlayerInDynamicArea ( playerid, table_apple_area [ player_factory_table { playerid } - 1 ] ) ) continue ;
			
			if ( apple_key_id == KEY_YES ) PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "PRESS:_Y" ) ;
			else if ( apple_key_id == KEY_NO ) PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "PRESS:_N" ) ;
			else if ( apple_key_id == KEY_CTRL_BACK ) PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "PRESS:_H" ) ;
			
			GetPlayerFacingAngle ( playerid, p_t_info [ playerid ] [ p_pos ] [ 3 ] ) ;
			set_pos ( playerid, p_t_info [ playerid ] [ p_pos ] [ 0 ] + 0.01, 
								p_t_info [ playerid ] [ p_pos ] [ 1 ] + 0.01, 
								p_t_info [ playerid ] [ p_pos ] [ 2 ] + 0.01,
								p_t_info [ playerid ] [ p_pos ] [ 3 ], 17, 1 ) ;
		}
		break ;
	}
	return 1 ;
}

stock factory_OnDynamicObjectMoved ( objectid )
{
	if ( meat_object == objectid )
	{
		new Float: object_x,
			Float: object_y,
			Float: object_z,
			index = -1 ;
		
		GetDynamicObjectPos ( meat_object, object_x, object_y, object_z ) ;
		index = object_y == meat_move_position [ 1 ] [ 1 ] ? 0 : 1 ;
		
		new bool: _players = false ;
		for ( new i = 0 ; i < sizeof meat_factory_player ; i ++ )
		{
			if ( meat_factory_player [ i ] == INVALID_PLAYER_ID ) continue ;
			
			_players = true ;
			break ;
		}
		
		if ( ! index )
		{
		    StopDynamicObject ( meat_object ) ;
			DestroyDynamicObject ( meat_object ) ;
			meat_object = INVALID_OBJECT_ID ;
			
			if ( _players ) SetTimer ( "callback_moving_meat", 1500, false ) ;
		}
		return 1 ;
	}
	if ( apple_toggled )
	{
		for ( new i = 0 ; i < 5 ; i ++ )
		{
			if ( apple_object [ i ] == INVALID_OBJECT_ID ) continue ;
			if ( apple_object [ i ] == objectid )
			{
				new Float: object_x,
					Float: object_y,
					Float: object_z,
					index = -1 ;
				
				GetDynamicObjectPos ( apple_object [ i ], object_x, object_y, object_z ) ;
				index = object_y == apple_move_position [ 1 ] [ 1 ] ? 0 : 1 ;
				
				if ( ! index )
				{
					StopDynamicObject ( apple_object [ i ] ) ;
					DestroyDynamicObject ( apple_object [ i ] ) ;
					apple_object [ i ] = INVALID_OBJECT_ID ;
				}
				return 1 ;
			}
		}
	}
	if ( army_toggled )
	{
		for ( new i = 0 ; i < MAX_ARM_OBJ ; i ++ )
		{
			if ( arm_info [ i ] [ arm_object ] == INVALID_OBJECT_ID ) continue ;
			if ( arm_info [ i ] [ arm_object ] == objectid )
			{
				new Float: object_x,
					Float: object_y,
					Float: object_z,
					index_y = -1,
					index_x = -1,
					_move_id = arm_info [ i ] [ arm_type_move ] ;
				
				GetDynamicObjectPos ( arm_info [ i ] [ arm_object ], object_x, object_y, object_z ) ;
				switch ( arm_info [ i ] [ arm_box_id ] )
				{
					case 0: 
					{
						index_x = object_x == army_move_position_1 [ _move_id ] [ 1 ] [ 0 ] ? 0 : 1 ;
						index_y = object_y == army_move_position_1 [ _move_id ] [ 1 ] [ 1 ] ? 0 : 1 ;
					}
					case 1:
					{
						index_x = object_x == army_move_position_2 [ _move_id ] [ 1 ] [ 0 ] ? 0 : 1 ;
						index_y = object_y == army_move_position_2 [ _move_id ] [ 1 ] [ 1 ] ? 0 : 1 ;
					}
					case 2:
					{
						index_x = object_x == army_move_position_3 [ _move_id ] [ 1 ] [ 0 ] ? 0 : 1 ;
						index_y = object_y == army_move_position_3 [ _move_id ] [ 1 ] [ 1 ] ? 0 : 1 ;
					}
				}
				
				if ( _move_id == 0 && ! index_y )
				{
					StopDynamicObject ( arm_info [ i ] [ arm_object ] ) ;
					DestroyDynamicObject ( arm_info [ i ] [ arm_object ] ) ;
					
					re_create_army_object_1 ( i ) ;
				}
				else if ( _move_id == 1 && ! index_x )
				{
					StopDynamicObject ( arm_info [ i ] [ arm_object ] ) ;
					DestroyDynamicObject ( arm_info [ i ] [ arm_object ] ) ;
					
					re_create_army_object_2 ( i ) ;
				}
				else if ( _move_id == 2 && ! index_x )
				{
					StopDynamicObject ( arm_info [ i ] [ arm_object ] ) ;
					DestroyDynamicObject ( arm_info [ i ] [ arm_object ] ) ;
					
					re_create_army_object_2 ( i ) ;
				}
				else if ( _move_id == 3 && ! index_y )
				{
					StopDynamicObject ( arm_info [ i ] [ arm_object ] ) ;
					DestroyDynamicObject ( arm_info [ i ] [ arm_object ] ) ;
					arm_info [ i ] [ arm_object ] = INVALID_OBJECT_ID ;
				}
				return 1 ;
			}
		}
	}
	return 0 ;
}

stock factory_EnterRaceCheckpoint ( playerid )
{
	if ( player_factory_checkpoint { playerid } == 1 )
	{
		ApplyAnimation ( playerid, "CARRY", "putdwn", 4.0, 0, 1, 1, 0, 0, 1 ) ;
		
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Возвращайтесь к Вашему столу." ) ;
		
		DisablePlayerRaceCheckpoint ( playerid ) ;
		player_factory_checkpoint { playerid } = 0 ;
		
		is_leave_factory_table { playerid } = 15 ;
		p_t_info [ playerid ] [ p_animation ] = false ;
		
		p_info [ playerid ] [ newbie_job_skill ] [ 3 ] ++ ;
		if ( p_info [ playerid ] [ newbie_job_skill ] [ 3 ] == 100 ) SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Теперь Вам доступен промышленный цех." ) ;
		return 1 ;
	}
	return 0 ;
}

stock factory_OnPlayerKeyStateChange ( playerid, newkeys, oldkeys )
{
	#pragma unused oldkeys
	if ( p_info [ playerid ] [ timejob ] == job_factory )
	{
		if ( player_factory_table { playerid } )
		{
			if ( IsPlayerInDynamicArea ( playerid, table_meat_area [ player_factory_table { playerid } - 1 ] ) )
			{
				if ( newkeys & meat_key_id && meat_key_id != -1 )
				{
					if ( player_factory_object [ playerid ] [ 0 ] != INVALID_OBJECT_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас уже есть мясо." ) ;
					if ( player_factory_checkpoint { playerid } ) return 1 ;
					
					StopDynamicObject ( meat_object ) ;
					DestroyDynamicObject ( meat_object ) ;
					meat_object = INVALID_OBJECT_ID ;
					meat_key_id = -1 ;
					
					for ( new p = 0 ; p < sizeof meat_factory_player ; p ++ )
					{
						if ( meat_factory_player [ p ] == INVALID_PLAYER_ID ) continue ;
									
						new playerid = meat_factory_player [ p ] ;
						if ( ! IsPlayerInDynamicArea ( playerid, table_meat_area [ player_factory_table { playerid } - 1 ] ) ) continue ;
									
						PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "WAITING..." ) ;
					}
					
					new _table = ( player_factory_table { playerid } - 1 ) * 2 ;
					player_factory_object [ playerid ] [ 0 ] = CreateDynamicObject ( 2804, meat_in_table [ _table ] [ 0 ], meat_in_table [ _table ] [ 1 ], meat_in_table [ _table ] [ 2 ], meat_in_table [ _table ] [ 3 ], meat_in_table [ _table ] [ 4 ], meat_in_table [ _table ] [ 5 ] ) ;
					player_factory_object [ playerid ] [ 1 ] = CreateDynamicObject ( 2804, meat_in_table [ _table + 1 ] [ 0 ], meat_in_table [ _table + 1 ] [ 1 ], meat_in_table [ _table + 1 ] [ 2 ], meat_in_table [ _table + 1 ] [ 3 ], meat_in_table [ _table + 1 ] [ 4 ], meat_in_table [ _table + 1 ] [ 5 ] ) ;
					
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы взяли куски обработанного мяса. Теперь приступайте к упаковыванию мяса." ) ;
					ApplyAnimation ( playerid, "CAR_CHAT", "CAR_Sc4_BL", 4.0, 1, 1, 1, 1, 5800, 0 ) ;
					
					TogglePlayerControllable ( playerid, false ) ;
					SetTimerEx ( "callback_fresh_meat", 4000, false, "i", playerid ) ;
					SetTimer ( "callback_moving_meat", 1500, false ) ;
					return 1 ;
				}
			}
			else if ( IsPlayerInDynamicArea ( playerid, table_apple_area [ player_factory_table { playerid } - 1 ] ) )
			{
				if ( newkeys & apple_key_id && apple_key_id != -1 )
				{
					if ( player_factory_checkpoint { playerid } ) return 1 ;

					apple_key_id = -1 ;
					
					player_factory_progress { playerid } ++ ;
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы положили яблоко в ящик." ) ;
					
					for ( new p = 0 ; p < sizeof apple_factory_player ; p ++ )
					{
						if ( apple_factory_player [ p ] == INVALID_PLAYER_ID ) continue ;
									
						new playerid = apple_factory_player [ p ] ;
						if ( ! IsPlayerInDynamicArea ( playerid, table_apple_area [ player_factory_table { playerid } - 1 ] ) ) continue ;
									
						PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "WAITING..." ) ;
					}
					
					if ( player_factory_progress { playerid } >= 10 )
					{
						DestroyDynamicObject ( player_factory_object [ playerid ] [ 0 ] ) ;
						player_factory_object [ playerid ] [ 0 ] = INVALID_OBJECT_ID ;
						
						SetPlayerAttachedObject ( playerid, 0, 19636, 6, 0.0, 0.10, -0.2, -110.0, 0.0, 0.0 ) ;
						ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
						p_t_info [ playerid ] [ p_animation ] = true ;
						
						SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отнесите ящик к остальным заготовкам." ) ;
						
						show_factory_ptd ( playerid, false, -1 ) ;
			
						SetPlayerRaceCheckpoint ( playerid, 1, factory_warehouse_position [ 1 ] [ 0 ], factory_warehouse_position [ 1 ] [ 1 ], factory_warehouse_position [ 1 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
						player_factory_checkpoint { playerid } = 1 ;
						
						player_factory_progress { playerid } = 0 ;
					}
					return 1 ;
				}
			}
			else if ( IsPlayerInDynamicArea ( playerid, table_army_area [ player_factory_table { playerid } - 1 ] ) )
			{
				if ( newkeys & army_key_up && army_key_up != -1 )
				{
					if ( player_factory_checkpoint { playerid } ) return 1 ;
					if ( p_t_info [ playerid ] [ p_animation ] ) return 1 ;

					army_key_up = -1 ;
					
					for ( new p = 0 ; p < sizeof army_factory_player ; p ++ )
					{
						if ( army_factory_player [ p ] == INVALID_PLAYER_ID ) continue ;
									
						new playerid = army_factory_player [ p ] ;
						if ( ! IsPlayerInDynamicArea ( playerid, table_army_area [ player_factory_table { playerid } - 1 ] ) ) continue ;
									
						PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "WAITING..." ) ;
					}
					
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы начали упаковывать боеприпасы в ящик, ожидайте." ) ;
					
					ApplyAnimation ( playerid, "CAR_CHAT", "CAR_Sc4_BL", 4.0, 1, 1, 1, 1, 5800, 0 ) ;
					p_t_info [ playerid ] [ p_animation ] = true ;

					SetPlayerAttachedObject ( playerid, 0, 18644, 5, 0.078999, 0.042999, -0.012999, -3.299995, 0.000000, 0.000000 ) ;
					SetPlayerAttachedObject ( playerid, 1, 18635, 6 ) ;
					
					TogglePlayerControllable ( playerid, false ) ;
					SetTimerEx ( "callback_re_create_1", 5000, false, "i", playerid ) ;
					return 1 ;
				}
			}
			else if ( IsPlayerInDynamicArea ( playerid, table_army_take_area [ player_factory_table { playerid } - 1 ] ) )
			{
				if ( newkeys & army_key_down && army_key_down != -1 )
				{
					if ( player_factory_checkpoint { playerid } ) return 1 ;

					army_key_down = -1 ;
					
					for ( new p = 0 ; p < sizeof army_factory_take_player ; p ++ )
					{
						if ( army_factory_take_player [ p ] == INVALID_PLAYER_ID ) continue ;
									
						new playerid = army_factory_take_player [ p ] ;
						if ( ! IsPlayerInDynamicArea ( playerid, table_army_take_area [ player_factory_table { playerid } - 1 ] ) ) continue ;
									
						PlayerTextDrawSetString ( playerid, press_abc_PTD [ playerid ] [ 6 ], "WAITING..." ) ;
					}

					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отнесите ящик к остальным заготовкам." ) ;
					
					show_factory_ptd ( playerid, false, -1 ) ;
					
					SetPlayerAttachedObject ( playerid, 0, 3013, 6, 0.0, 0.10, -0.2, -110.0, 0.0, 0.0 ) ;
					ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
					p_t_info [ playerid ] [ p_animation ] = true ;
					
					SetPlayerRaceCheckpoint ( playerid, 1, factory_warehouse_position [ 2 ] [ 0 ], factory_warehouse_position [ 2 ] [ 1 ], factory_warehouse_position [ 2 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
					player_factory_checkpoint { playerid } = 1 ;
					return 1 ;
				}
			}
		}
	}
	return 0 ;
}

stock factory_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_job_factory:
		{
			if ( ! response ) return 1 ;
			if ( p_info [ playerid ] [ timejob ] != job_factory )
			{
				p_info [ playerid ] [ timejob ] = job_factory ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно трудоустроились на завод." ) ;
				SendClientMessage ( playerid, col_gray, !"* Занимайте свободное место у стола и следуйте подсказкам." ) ;
				SetPlayerSkin ( playerid, 27 ) ;
			}
			else
			{
				fraction_duty ( playerid ) ;
				
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы завершили рабочую смену." ) ;
				new __t_string [ 72 ] ;
				format ( __t_string, sizeof ( __t_string ), "{"#cGInfo"}* {"#cWH"}Заработано: {"#cGN"}%d$", p_info [ playerid ] [ salary ] ) ;
				SendClientMessage ( playerid, col_white, __t_string ) ;

				give_money ( playerid, p_info [ playerid ] [ salary ] ) ;
				p_info [ playerid ] [ salary ] = 0 ;
				p_info [ playerid ] [ timejob ] = job_none ;

				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
				DisablePlayerCheckpoint ( playerid ) ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock factory_EnterDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_factory_meat:
		{
			if ( p_info [ playerid ] [ timejob ] != job_factory ) return 1 ;
			
			new _areaid ;
			for ( new i = 0 ; i < sizeof table_meat_area ; i ++ )
			{
				if ( areaid != table_meat_area [ i ] ) continue ;
				
				_areaid = i ;
				break ;
			}
			if ( player_factory_table { playerid } )
			{
				if ( player_factory_table { playerid } - 1 != _areaid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это не Ваше рабочее место!" ) ;
				
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы вернулись на рабочее место. Ожидайте на конверее мясо." ) ;
				is_leave_factory_table { playerid } = 0 ;
				
				show_factory_ptd ( playerid, true, meat_key_id ) ;
			}
			else
			{
				if ( table_meat_toggled [ _areaid ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Рабочее место занято!" ) ;
					
				player_factory_table { playerid } = _areaid + 1 ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы заняли рабочее место. Ожидайте на конверее мясо." ) ;
				
				for ( new i = 0 ; i < sizeof meat_factory_player ; i ++ )
				{
					if ( meat_factory_player [ i ] != INVALID_PLAYER_ID ) continue ;
					
					meat_factory_player [ i ] = playerid ;
					break ;
				}
				
				if ( meat_object == INVALID_OBJECT_ID ) SetTimer ( "callback_moving_meat", 1500, false ) ;
				
				table_meat_toggled [ _areaid ] = true ;
				
				show_factory_ptd ( playerid, true, meat_key_id ) ;
				
				new text_label [ 110 ] ;
				format ( text_label, sizeof text_label, "** Рабочее место **\n\n{"#cRL3D"}Занято {"#cWH"}%s", p_info [ playerid ] [ name ] ) ;
				UpdateDynamic3DTextLabelText ( table_meat_text [ _areaid ], col_blue, text_label ) ;
				
				player_factory_toggled [ playerid ] = 1 ;
			}
			return 1 ;
		}
		case area_type_factory_apple:
		{
			if ( p_info [ playerid ] [ timejob ] != job_factory ) return 1 ;
			
			new _areaid ;
			for ( new i = 0 ; i < sizeof table_apple_area ; i ++ )
			{
				if ( areaid != table_apple_area [ i ] ) continue ;
				
				_areaid = i ;
				break ;
			}
			if ( player_factory_table { playerid } )
			{
				if ( player_factory_table { playerid } - 1 != _areaid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это не Ваше рабочее место!" ) ;
				
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы вернулись на рабочее место. Ожидайте на конверее яблоки." ) ;
				is_leave_factory_table { playerid } = 0 ;
				
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
				if ( player_factory_object [ playerid ] [ 0 ] != INVALID_OBJECT_ID ) return 1 ;
				
				show_factory_ptd ( playerid, true, apple_key_id ) ;
				
				player_factory_object [ playerid ] [ 0 ] = CreateDynamicObject ( 19639, apple_in_table [ _areaid ] [ 0 ], apple_in_table [ _areaid ] [ 1 ], apple_in_table [ _areaid ] [ 2 ], apple_in_table [ _areaid ] [ 3 ], apple_in_table [ _areaid ] [ 4 ], apple_in_table [ _areaid ] [ 5 ] ) ;
			}
			else
			{
				if ( table_apple_toggled [ _areaid ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Рабочее место занято!" ) ;
					
				player_factory_table { playerid } = _areaid + 1 ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы заняли рабочее место. Ожидайте на конверее яблоки." ) ;
				
				for ( new i = 0 ; i < sizeof apple_factory_player ; i ++ )
				{
					if ( apple_factory_player [ i ] != INVALID_PLAYER_ID ) continue ;
					
					apple_factory_player [ i ] = playerid ;
					break ;
				}
				
				if ( ! apple_toggled )
				{
					for ( new i = 0 ; i < sizeof apple_factory_player ; i ++ )
					{
						if ( apple_factory_player [ i ] == INVALID_PLAYER_ID ) continue ;
						
						apple_toggled = true ;
						apple_timer = SetTimer ( "callback_moving_apple", 3000, true ) ;
						break ;
					}
				}
				
				player_factory_object [ playerid ] [ 0 ] = CreateDynamicObject ( 19639, apple_in_table [ _areaid ] [ 0 ], apple_in_table [ _areaid ] [ 1 ], apple_in_table [ _areaid ] [ 2 ], apple_in_table [ _areaid ] [ 3 ], apple_in_table [ _areaid ] [ 4 ], apple_in_table [ _areaid ] [ 5 ] ) ;
				
				table_apple_toggled [ _areaid ] = true ;
				
				show_factory_ptd ( playerid, true, apple_key_id ) ;
				
				new text_label [ 110 ] ;
				format ( text_label, sizeof text_label, "** Рабочее место **\n\n{"#cRL3D"}Занято {"#cWH"}%s", p_info [ playerid ] [ name ] ) ;
				UpdateDynamic3DTextLabelText ( table_apple_text [ _areaid ], col_blue, text_label ) ;
				
				player_factory_toggled [ playerid ] = 2 ;
			}
			return 1 ;
		}
		case area_type_factory_army:
		{
			if ( p_info [ playerid ] [ timejob ] != job_factory ) return 1 ;
			
			new _areaid ;
			for ( new i = 0 ; i < sizeof table_army_area ; i ++ )
			{
				if ( areaid != table_army_area [ i ] ) continue ;
				
				_areaid = i ;
				break ;
			}
			if ( player_factory_table { playerid } )
			{
				if ( player_factory_table { playerid } - 1 != _areaid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это не Ваше рабочее место!" ) ;
				
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы вернулись на рабочее место. Ожидайте на конверее боеприпасы." ) ;
				is_leave_factory_table { playerid } = 0 ;
				
				show_factory_ptd ( playerid, true, army_key_up ) ;
			}
			else
			{
				if ( table_army_toggled [ _areaid ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Рабочее место занято!" ) ;
					
				player_factory_table { playerid } = _areaid + 1 ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы заняли рабочее место. Ожидайте на конверее боеприпасы." ) ;
				
				for ( new i = 0 ; i < sizeof army_factory_player ; i ++ )
				{
					if ( army_factory_player [ i ] != INVALID_PLAYER_ID ) continue ;
					
					army_factory_player [ i ] = playerid ;
					break ;
				}
				
				if ( ! army_toggled )
				{
					if ( army_timer == -1 )
					{
						army_toggled = true ;
						army_timer = SetTimer ( "callback_army_move", 3000, true ) ;
					}
				}

				table_army_toggled [ _areaid ] = true ;
				
				show_factory_ptd ( playerid, true, army_key_up ) ;
				
				new text_label [ 110 ] ;
				format ( text_label, sizeof text_label, "** Рабочее место **\n\n{"#cRL3D"}Занято {"#cWH"}%s", p_info [ playerid ] [ name ] ) ;
				UpdateDynamic3DTextLabelText ( table_army_text [ _areaid ], col_blue, text_label ) ;
				
				player_factory_toggled [ playerid ] = 3 ;
			}
			return 1 ;
		}
		case area_type_factory_army_take:
		{
			if ( p_info [ playerid ] [ timejob ] != job_factory ) return 1 ;
			
			new _areaid ;
			for ( new i = 0 ; i < sizeof table_army_take_area ; i ++ )
			{
				if ( areaid != table_army_take_area [ i ] ) continue ;
				
				_areaid = i ;
				break ;
			}
			if ( player_factory_table { playerid } )
			{
				if ( player_factory_table { playerid } - 1 != _areaid ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это не Ваше рабочее место!" ) ;
				
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы вернулись на рабочее место. Ожидайте на конверее боеприпасы." ) ;
				is_leave_factory_table { playerid } = 0 ;
				
				show_factory_ptd ( playerid, true, army_key_down ) ;
			}
			else
			{
				if ( table_army_take_toggled [ _areaid ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Рабочее место занято!" ) ;
					
				player_factory_table { playerid } = _areaid + 1 ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы заняли рабочее место. Ожидайте на конверее боеприпасы." ) ;
				
				for ( new i = 0 ; i < sizeof army_factory_take_player ; i ++ )
				{
					if ( army_factory_take_player [ i ] != INVALID_PLAYER_ID ) continue ;
					
					army_factory_take_player [ i ] = playerid ;
					break ;
				}
				
				if ( ! army_toggled )
				{
					if ( army_timer == -1 )
					{
						army_toggled = true ;
						army_timer = SetTimer ( "callback_army_move", 3000, true ) ;
					}
				}

				table_army_take_toggled [ _areaid ] = true ;
				
				show_factory_ptd ( playerid, true, army_key_down ) ;
				
				new text_label [ 110 ] ;
				format ( text_label, sizeof text_label, "** Рабочее место **\n\n{"#cRL3D"}Занято {"#cWH"}%s", p_info [ playerid ] [ name ] ) ;
				UpdateDynamic3DTextLabelText ( table_army_take_text [ _areaid ], col_blue, text_label ) ;
				
				player_factory_toggled [ playerid ] = 4 ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock factory_LeaveDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_factory_meat:
		{
			if ( player_factory_table { playerid } == 0 ) return 1 ;
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
			
			new _areaid ;
			for ( new i = 0 ; i < sizeof table_meat_area ; i ++ )
			{
				if ( areaid != table_meat_area [ i ] ) continue ;
				
				_areaid = i ;
				break ;
			}
			if ( player_factory_table { playerid } - 1 != _areaid ) return 1 ;
			
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас есть {"#cRD"}15 секунд{"#cGRInfo"} для возврата к столу, иначе стол будет освобождён." ) ;
			GameTextForPlayer ( playerid, "~r~15", 5000, 6 ) ;
			
			show_factory_ptd ( playerid, false, -1 ) ;
			
			is_leave_factory_table { playerid } = 15 ;
			return 1 ;
		}
		case area_type_factory_apple:
		{
			if ( player_factory_table { playerid } == 0 ) return 1 ;
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
			
			new _areaid ;
			for ( new i = 0 ; i < sizeof table_apple_area ; i ++ )
			{
				if ( areaid != table_apple_area [ i ] ) continue ;
				
				_areaid = i ;
				break ;
			}
			if ( player_factory_table { playerid } - 1 != _areaid ) return 1 ;
			
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас есть {"#cRD"}15 секунд{"#cGRInfo"} для возврата к столу, иначе стол будет освобождён." ) ;
			GameTextForPlayer ( playerid, "~r~15", 5000, 6 ) ;
			
			show_factory_ptd ( playerid, false, -1 ) ;
			
			is_leave_factory_table { playerid } = 15 ;
			return 1 ;
		}
		case area_type_factory_army:
		{
			if ( player_factory_table { playerid } == 0 ) return 1 ;
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
			
			new _areaid ;
			for ( new i = 0 ; i < sizeof table_army_area ; i ++ )
			{
				if ( areaid != table_army_area [ i ] ) continue ;
				
				_areaid = i ;
				break ;
			}
			if ( player_factory_table { playerid } - 1 != _areaid ) return 1 ;
			
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас есть {"#cRD"}15 секунд{"#cGRInfo"} для возврата к столу, иначе стол будет освобождён." ) ;
			GameTextForPlayer ( playerid, "~r~15", 5000, 6 ) ;
			
			show_factory_ptd ( playerid, false, -1 ) ;
			
			is_leave_factory_table { playerid } = 15 ;
			return 1 ;
		}
		case area_type_factory_army_take:
		{
			if ( player_factory_table { playerid } == 0 ) return 1 ;
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
			
			new _areaid ;
			for ( new i = 0 ; i < sizeof table_army_take_area ; i ++ )
			{
				if ( areaid != table_army_take_area [ i ] ) continue ;
				
				_areaid = i ;
				break ;
			}
			if ( player_factory_table { playerid } - 1 != _areaid ) return 1 ;
			
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас есть {"#cRD"}15 секунд{"#cGRInfo"} для возврата к столу, иначе стол будет освобождён." ) ;
			GameTextForPlayer ( playerid, "~r~15", 5000, 6 ) ;
			
			show_factory_ptd ( playerid, false, -1 ) ;
			
			is_leave_factory_table { playerid } = 15 ;
			return 1 ;
		}
	}
	return 0 ;
}

stock factory_player_timer ( playerid )
{
	if ( p_info [ playerid ] [ timejob ] == job_factory )
	{
	    if ( GetPlayerInterior ( playerid ) != 17 )
	    {
			SetPlayerSkin ( playerid, p_info [ playerid ] [ skin ] ) ;
			give_money ( playerid, p_info [ playerid ] [ salary ] ) ;

			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы покинули территорию завода и завершили рабочую смену." ) ;
			
			new __t_string [ 72 ] ;
			format ( __t_string, sizeof ( __t_string ), "{"#cGInfo"}* {"#cWH"}Заработано: {"#cGN"}%d$", p_info [ playerid ] [ salary ] ) ;
			SendClientMessage ( playerid, col_white, __t_string ) ;
			p_info [ playerid ] [ salary ] = 0 ;

			p_info [ playerid ] [ timejob ] = job_none ;

			RemovePlayerAttachedObject ( playerid, 0 ) ;
			DisablePlayerCheckpoint ( playerid ) ;
		}
	}
	
	if ( is_leave_factory_table { playerid } > 0 )
	{
		new t_string [ 6 ] ;
		format ( t_string, 6, "~r~%d", is_leave_factory_table { playerid } ) ;
		GameTextForPlayer ( playerid, t_string, 5000, 6 ) ;
		if ( is_leave_factory_table { playerid } == 1 )
		{
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не успели вовремя вернуться к столу, стол освобождён." ) ;
			GameTextForPlayer ( playerid, "~r~FAILED", 5000, 6 ) ;
			
			if ( player_factory_toggled [ playerid ] == 1 )
			{
				new _areaid = player_factory_table { playerid } - 1 ;
				table_meat_toggled [ _areaid ] = false ;
				UpdateDynamic3DTextLabelText ( table_meat_text [ _areaid ], col_blue, "** Рабочее место **\n\n{"#cGN3D"}Свободно" ) ;
				
				for ( new i = 0 ; i < sizeof meat_factory_player ; i ++ )
				{
					if ( meat_factory_player [ i ] != playerid ) continue ;
							
					meat_factory_player [ i ] = INVALID_PLAYER_ID ;
					break ;
				}
				
				if ( IsValidDynamicObject ( player_factory_object [ playerid ] [ 0 ] ) ) DestroyDynamicObject ( player_factory_object [ playerid ] [ 0 ] ), player_factory_object [ playerid ] [ 0 ] = INVALID_OBJECT_ID ;
				if ( IsValidDynamicObject ( player_factory_object [ playerid ] [ 1 ] ) ) DestroyDynamicObject ( player_factory_object [ playerid ] [ 1 ] ), player_factory_object [ playerid ] [ 1 ] = INVALID_OBJECT_ID ;
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
			}
			else if ( player_factory_toggled [ playerid ] == 2 )
			{
				new _areaid = player_factory_table { playerid } - 1 ;
				table_apple_toggled [ _areaid ] = false ;
				UpdateDynamic3DTextLabelText ( table_apple_text [ _areaid ], col_blue, "** Рабочее место **\n\n{"#cGN3D"}Свободно" ) ;
				
				for ( new i = 0 ; i < sizeof apple_factory_player ; i ++ )
				{
					if ( apple_factory_player [ i ] != playerid ) continue ;
							
					apple_factory_player [ i ] = INVALID_PLAYER_ID ;
					break ;
				}
				
				if ( apple_toggled )
				{
					new bool: _player_in_table = false ;
					for ( new i = 0 ; i < sizeof apple_factory_player ; i ++ )
					{
						if ( apple_factory_player [ i ] == INVALID_PLAYER_ID ) continue ;
								
						_player_in_table = true ;
						break ;
					}
					if ( ! _player_in_table ) 
					{
						for ( new i = 0 ; i < 5 ; i ++ )
						{
							if ( apple_object [ i ] == INVALID_OBJECT_ID ) continue ;
							DestroyDynamicObject ( apple_object [ i ] ) ;
							apple_object [ i ] = INVALID_OBJECT_ID ;
						}
						
						apple_toggled = false ;
						KillTimer ( apple_timer ) ;
						apple_timer = -1 ;
					}
				}
				
				if ( IsValidDynamicObject ( player_factory_object [ playerid ] [ 0 ] ) ) DestroyDynamicObject ( player_factory_object [ playerid ] [ 0 ] ), player_factory_object [ playerid ] [ 0 ] = INVALID_OBJECT_ID ;
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
			}
			else if ( player_factory_toggled [ playerid ] == 3 )
			{
				new _areaid = player_factory_table { playerid } - 1 ;
				table_army_toggled [ _areaid ] = false ;
				UpdateDynamic3DTextLabelText ( table_army_text [ _areaid ], col_blue, "** Рабочее место **\n\n{"#cGN3D"}Свободно" ) ;
				
				for ( new i = 0 ; i < sizeof army_factory_player ; i ++ )
				{
					if ( army_factory_player [ i ] != playerid ) continue ;
							
					army_factory_player [ i ] = INVALID_PLAYER_ID ;
					break ;
				}
				
				if ( army_toggled )
				{
					new bool: _player_in_table = false ;
					for ( new i = 0 ; i < sizeof army_factory_player ; i ++ )
					{
						if ( army_factory_player [ i ] == INVALID_PLAYER_ID ) continue ;
								
						_player_in_table = true ;
						break ;
					}
					if ( ! _player_in_table ) 
					{
						for ( new i = 0 ; i < MAX_ARM_OBJ ; i ++ )
						{
							if ( arm_info [ i ] [ arm_object ] == INVALID_OBJECT_ID ) continue ;
							
							DestroyDynamicObject ( arm_info [ i ] [ arm_object ] ) ;
							arm_info [ i ] [ arm_object ] = INVALID_OBJECT_ID ;
						}
						
						army_toggled = false ;
						KillTimer ( army_timer ) ;
						army_timer = -1 ;
					}
				}
				
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) RemovePlayerAttachedObject ( playerid, 1 ) ;
			}
			else if ( player_factory_toggled [ playerid ] == 4 )
			{
				new _areaid = player_factory_table { playerid } - 1 ;
				table_army_take_toggled [ _areaid ] = false ;
				UpdateDynamic3DTextLabelText ( table_army_take_text [ _areaid ], col_blue, "** Рабочее место **\n\n{"#cGN3D"}Свободно" ) ;
				
				for ( new i = 0 ; i < sizeof army_factory_take_player ; i ++ )
				{
					if ( army_factory_take_player [ i ] != playerid ) continue ;
							
					army_factory_take_player [ i ] = INVALID_PLAYER_ID ;
					break ;
				}
				
				if ( army_toggled )
				{
					new bool: _player_in_table = false ;
					for ( new i = 0 ; i < sizeof army_factory_take_player ; i ++ )
					{
						if ( army_factory_take_player [ i ] == INVALID_PLAYER_ID ) continue ;
								
						_player_in_table = true ;
						break ;
					}
					if ( ! _player_in_table ) 
					{
						for ( new i = 0 ; i < MAX_ARM_OBJ ; i ++ )
						{
							if ( arm_info [ i ] [ arm_object ] == INVALID_OBJECT_ID ) continue ;
							
							DestroyDynamicObject ( arm_info [ i ] [ arm_object ] ) ;
							arm_info [ i ] [ arm_object ] = INVALID_OBJECT_ID ;
						}
						
						army_toggled = false ;
						KillTimer ( army_timer ) ;
						army_timer = -1 ;
					}
				}
				
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
				if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) RemovePlayerAttachedObject ( playerid, 1 ) ;
			}
			
			player_factory_toggled [ playerid ] = 0 ;
			player_factory_table { playerid } = 0 ;
			is_leave_factory_table { playerid } = 0 ;
		}
		else is_leave_factory_table { playerid } -- ;
	}
	return 1 ;
}

stock factory_OnPlayerDisconnect ( playerid )
{
	if ( press_abc_PTD [ playerid ] [ 0 ] != PlayerText:-1 ) show_factory_ptd ( playerid, false, -1 ) ;
	if ( player_factory_toggled [ playerid ] == 1 )
	{
		if ( IsValidDynamicObject ( player_factory_object [ playerid ] [ 0 ] ) ) DestroyDynamicObject ( player_factory_object [ playerid ] [ 0 ] ), player_factory_object [ playerid ] [ 0 ] = INVALID_OBJECT_ID ;
		if ( IsValidDynamicObject ( player_factory_object [ playerid ] [ 1 ] ) ) DestroyDynamicObject ( player_factory_object [ playerid ] [ 1 ] ), player_factory_object [ playerid ] [ 1 ] = INVALID_OBJECT_ID ;
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
		
		for ( new i = 0 ; i < sizeof meat_factory_player ; i ++ )
		{
			if ( meat_factory_player [ i ] != playerid ) continue ;
					
			meat_factory_player [ i ] = INVALID_PLAYER_ID ;
			break ;
		}
		
		new _areaid = player_factory_table { playerid } - 1 ;
		table_meat_toggled [ _areaid ] = false ;
		UpdateDynamic3DTextLabelText ( table_meat_text [ _areaid ], col_blue, "** Рабочее место **\n\n{"#cGN3D"}Свободно" ) ;
		
		player_factory_toggled [ playerid ] = 0 ;
		player_factory_table { playerid } = 0 ;
		is_leave_factory_table { playerid } = 0 ;
	}
	else if ( player_factory_toggled [ playerid ] == 2 )
	{
		if ( IsValidDynamicObject ( player_factory_object [ playerid ] [ 0 ] ) ) DestroyDynamicObject ( player_factory_object [ playerid ] [ 0 ] ), player_factory_object [ playerid ] [ 0 ] = INVALID_OBJECT_ID ;
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
		
		for ( new i = 0 ; i < sizeof apple_factory_player ; i ++ )
		{
			if ( apple_factory_player [ i ] != playerid ) continue ;
					
			apple_factory_player [ i ] = INVALID_PLAYER_ID ;
			break ;
		}
		
		if ( apple_toggled )
		{
			new bool: _player_in_table = false ;
			for ( new i = 0 ; i < sizeof apple_factory_player ; i ++ )
			{
				if ( apple_factory_player [ i ] == INVALID_PLAYER_ID ) continue ;
						
				_player_in_table = true ;
				break ;
			}
			if ( ! _player_in_table ) 
			{
				for ( new i = 0 ; i < 5 ; i ++ )
				{
					if ( apple_object [ i ] == INVALID_OBJECT_ID ) continue ;
					DestroyDynamicObject ( apple_object [ i ] ) ;
					apple_object [ i ] = INVALID_OBJECT_ID ;
				}
				
				apple_toggled = false ;
				KillTimer ( apple_timer ) ;
				apple_timer = -1 ;
			}
		}
		
		new _areaid = player_factory_table { playerid } - 1 ;
		table_apple_toggled [ _areaid ] = false ;
		UpdateDynamic3DTextLabelText ( table_apple_text [ _areaid ], col_blue, "** Рабочее место **\n\n{"#cGN3D"}Свободно" ) ;
		
		player_factory_toggled [ playerid ] = 0 ;
		player_factory_table { playerid } = 0 ;
		is_leave_factory_table { playerid } = 0 ;
	}
	else if ( player_factory_toggled [ playerid ] == 3 )
	{
		new _areaid = player_factory_table { playerid } - 1 ;
		table_army_toggled [ _areaid ] = false ;
		UpdateDynamic3DTextLabelText ( table_army_text [ _areaid ], col_blue, "** Рабочее место **\n\n{"#cGN3D"}Свободно" ) ;
				
		for ( new i = 0 ; i < sizeof army_factory_player ; i ++ )
		{
			if ( army_factory_player [ i ] != playerid ) continue ;
							
			army_factory_player [ i ] = INVALID_PLAYER_ID ;
			break ;
		}
				
		if ( army_toggled )
		{
			new bool: _player_in_table = false ;
			for ( new i = 0 ; i < sizeof army_factory_player ; i ++ )
			{
				if ( army_factory_player [ i ] == INVALID_PLAYER_ID ) continue ;
								
				_player_in_table = true ;
				break ;
			}
			if ( ! _player_in_table ) 
			{
				for ( new i = 0 ; i < MAX_ARM_OBJ ; i ++ )
				{
					if ( arm_info [ i ] [ arm_object ] == INVALID_OBJECT_ID ) continue ;
							
					DestroyDynamicObject ( arm_info [ i ] [ arm_object ] ) ;
					arm_info [ i ] [ arm_object ] = INVALID_OBJECT_ID ;
				}
				
				army_toggled = false ;
				KillTimer ( army_timer ) ;
				army_timer = -1 ;
			}
		}
				
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) RemovePlayerAttachedObject ( playerid, 1 ) ;
		
		player_factory_toggled [ playerid ] = 0 ;
		player_factory_table { playerid } = 0 ;
		is_leave_factory_table { playerid } = 0 ;
	}
	else if ( player_factory_toggled [ playerid ] == 4 )
	{
		new _areaid = player_factory_table { playerid } - 1 ;
		table_army_take_toggled [ _areaid ] = false ;
		UpdateDynamic3DTextLabelText ( table_army_take_text [ _areaid ], col_blue, "** Рабочее место **\n\n{"#cGN3D"}Свободно" ) ;
				
		for ( new i = 0 ; i < sizeof army_factory_take_player ; i ++ )
		{
			if ( army_factory_take_player [ i ] != playerid ) continue ;
							
			army_factory_take_player [ i ] = INVALID_PLAYER_ID ;
			break ;
		}
				
		if ( army_toggled )
		{
			new bool: _player_in_table = false ;
			for ( new i = 0 ; i < sizeof army_factory_take_player ; i ++ )
			{
				if ( army_factory_take_player [ i ] == INVALID_PLAYER_ID ) continue ;
								
				_player_in_table = true ;
				break ;
			}
			if ( ! _player_in_table ) 
			{
				for ( new i = 0 ; i < MAX_ARM_OBJ ; i ++ )
				{
					if ( arm_info [ i ] [ arm_object ] == INVALID_OBJECT_ID ) continue ;
							
					DestroyDynamicObject ( arm_info [ i ] [ arm_object ] ) ;
					arm_info [ i ] [ arm_object ] = INVALID_OBJECT_ID ;
				}
				
				army_toggled = false ;
				KillTimer ( army_timer ) ;
				army_timer = -1 ;
			}
		}
				
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) RemovePlayerAttachedObject ( playerid, 1 ) ;
		
		player_factory_toggled [ playerid ] = 0 ;
		player_factory_table { playerid } = 0 ;
		is_leave_factory_table { playerid } = 0 ;
	}
	return 1 ;
}

stock factory_DynamicPickup ( playerid, pickupid )
{
	if ( pickupid == factory_pickup_id )
	{
		if ( p_info [ playerid ] [ timejob ] != job_factory && p_info [ playerid ] [ timejob ] != 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже трудоустроены." ) ;
		if ( p_info [ playerid ] [ timejob ] != job_factory )show_dialog ( playerid, d_job_factory, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Работа на заводе", "{ffffff}Вы хотите устроиться на работу?", "Да", "Нет" ) ;
		else show_dialog ( playerid, d_job_factory, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Работа на заводе", "{ffffff}Вы действительно хотите закончить рабочий день?", "Да", "Нет" ) ;
		return 1 ;
	}
	else if ( pickupid == people_factory_pickup_id [ 0 ] )
	{
		set_pos ( playerid, people_factory_pos [ 1 ] [ 0 ], people_factory_pos [ 1 ] [ 1 ], people_factory_pos [ 1 ] [ 2 ], people_factory_pos [ 1 ] [ 3 ], 17, 1 ) ;
		return 1 ;
	}
	else if ( pickupid == people_factory_pickup_id [ 1 ] )
	{
		set_pos ( playerid, people_factory_pos [ 0 ] [ 0 ], people_factory_pos [ 0 ] [ 1 ], people_factory_pos [ 0 ] [ 2 ], people_factory_pos [ 0 ] [ 3 ], 17, 1 ) ;
		return 1 ;
	}
	else if ( pickupid == army_factory_pickup_id [ 0 ] )
	{
		set_pos ( playerid, army_factory_pos [ 1 ] [ 0 ], army_factory_pos [ 1 ] [ 1 ], army_factory_pos [ 1 ] [ 2 ], army_factory_pos [ 1 ] [ 3 ], 17, 1 ) ;
		return 1 ;
	}
	else if ( pickupid == army_factory_pickup_id [ 1 ] )
	{
		if ( p_info [ playerid ] [ newbie_job_skill ] [ 3 ] < 100 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вам не доступен промышленный цех. Необходим уровень навыка {"#cRInfo"}100{"#cGRInfo"}." ) ;
		set_pos ( playerid, army_factory_pos [ 0 ] [ 0 ], army_factory_pos [ 0 ] [ 1 ], army_factory_pos [ 0 ] [ 2 ], army_factory_pos [ 0 ] [ 3 ], 17, 1 ) ;
		return 1 ;
	}
	return 0 ;
}

stock show_factory_ptd ( playerid, bool: status, _key_id )
{
	if ( status )
	{
		press_abc_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 286.2998, 424.6297, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, press_abc_PTD[playerid][0], 67.0000, 13.2900);
		PlayerTextDrawAlignment(playerid, press_abc_PTD[playerid][0], 1);
		PlayerTextDrawColor(playerid, press_abc_PTD[playerid][0], 235802367);
		PlayerTextDrawBackgroundColor(playerid, press_abc_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, press_abc_PTD[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, press_abc_PTD[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, press_abc_PTD[playerid][0], 0);

		press_abc_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 283.8665, 430.3519, "LD_Beat:Chit"); // пусто
		PlayerTextDrawTextSize(playerid, press_abc_PTD[playerid][1], 7.0000, 9.0000);
		PlayerTextDrawAlignment(playerid, press_abc_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, press_abc_PTD[playerid][1], 235802367);
		PlayerTextDrawBackgroundColor(playerid, press_abc_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, press_abc_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, press_abc_PTD[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, press_abc_PTD[playerid][1], 0);

		press_abc_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 349.3999, 430.3519, "LD_Beat:Chit"); // пусто
		PlayerTextDrawTextSize(playerid, press_abc_PTD[playerid][2], 7.0000, 9.0000);
		PlayerTextDrawAlignment(playerid, press_abc_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, press_abc_PTD[playerid][2], 235802367);
		PlayerTextDrawBackgroundColor(playerid, press_abc_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, press_abc_PTD[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, press_abc_PTD[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, press_abc_PTD[playerid][2], 0);

		press_abc_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 285.0000, 416.9037, "O"); // пусто
		PlayerTextDrawLetterSize(playerid, press_abc_PTD[playerid][3], 0.4646, 2.6162);
		PlayerTextDrawAlignment(playerid, press_abc_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, press_abc_PTD[playerid][3], -5963521);
		PlayerTextDrawBackgroundColor(playerid, press_abc_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, press_abc_PTD[playerid][3], 2);
		PlayerTextDrawSetProportional(playerid, press_abc_PTD[playerid][3], 1);
		PlayerTextDrawSetShadow(playerid, press_abc_PTD[playerid][3], 0);

		press_abc_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 343.8668, 416.9037, "O"); // пусто
		PlayerTextDrawLetterSize(playerid, press_abc_PTD[playerid][4], 0.4646, 2.6162);
		PlayerTextDrawAlignment(playerid, press_abc_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, press_abc_PTD[playerid][4], -5963521);
		PlayerTextDrawBackgroundColor(playerid, press_abc_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, press_abc_PTD[playerid][4], 2);
		PlayerTextDrawSetProportional(playerid, press_abc_PTD[playerid][4], 1);
		PlayerTextDrawSetShadow(playerid, press_abc_PTD[playerid][4], 0);

		press_abc_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 286.9664, 423.8000, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, press_abc_PTD[playerid][5], 66.3100, 13.0000);
		PlayerTextDrawAlignment(playerid, press_abc_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, press_abc_PTD[playerid][5], -5963521);
		PlayerTextDrawBackgroundColor(playerid, press_abc_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, press_abc_PTD[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, press_abc_PTD[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, press_abc_PTD[playerid][5], 0);

		new key_string [ 14 ] ;
		if ( _key_id == KEY_YES ) format ( key_string, sizeof key_string, "PRESS:_Y" ) ;
		else if ( _key_id == KEY_NO ) format ( key_string, sizeof key_string, "PRESS:_N" ) ;
		else if ( _key_id == KEY_CTRL_BACK ) format ( key_string, sizeof key_string, "PRESS:_H" ) ;
		else format ( key_string, sizeof key_string, "WAITING..." ) ;
		press_abc_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 319.8666, 424.4703, key_string); // пусто
		PlayerTextDrawLetterSize(playerid, press_abc_PTD[playerid][6], 0.1629, 1.1561);
		PlayerTextDrawAlignment(playerid, press_abc_PTD[playerid][6], 2);
		PlayerTextDrawColor(playerid, press_abc_PTD[playerid][6], 235802367);
		PlayerTextDrawBackgroundColor(playerid, press_abc_PTD[playerid][6], 255);
		PlayerTextDrawFont(playerid, press_abc_PTD[playerid][6], 2);
		PlayerTextDrawSetProportional(playerid, press_abc_PTD[playerid][6], 1);
		PlayerTextDrawSetShadow(playerid, press_abc_PTD[playerid][6], 0);
		
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			PlayerTextDrawShow ( playerid, press_abc_PTD [ playerid ] [ i ] ) ;
		}
	}
	else
	{
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			PlayerTextDrawDestroy ( playerid, press_abc_PTD [ playerid ] [ i ] ) ;
			press_abc_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		}
	}
	return 1 ;
}

stock factory_OnGameModeInit ( )
{
	for ( new i = 0 ; i < 2 ; i ++ )
	{
		people_factory_pickup_id [ i ] = CreateDynamicPickup ( 1318, 23, people_factory_pos [ i ] [ 0 ], people_factory_pos [ i ] [ 1 ], people_factory_pos [ i ] [ 2 ], -1, -1, -1 ) ;
		army_factory_pickup_id [ i ] = CreateDynamicPickup ( 1318, 23, army_factory_pos [ i ] [ 0 ], army_factory_pos [ i ] [ 1 ], army_factory_pos [ i ] [ 2 ], -1, -1, -1 ) ;
	}
	CreateDynamic3DTextLabel ( "** Продуктовый цех **", col_blue, people_factory_pos [ 1 ] [ 0 ], people_factory_pos [ 1 ] [ 1 ], people_factory_pos [ 1 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );
	CreateDynamic3DTextLabel ( "** Промышленный цех **", col_blue, army_factory_pos [ 1 ] [ 0 ], army_factory_pos [ 1 ] [ 1 ], army_factory_pos [ 1 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );
	
	
	factory_pickup_id = CreateDynamicPickup ( 1275, 23, factory_start_job [ 0 ], factory_start_job [ 1 ], factory_start_job [ 2 ], -1, -1, -1 ) ;
	
	for ( new i = 0 ; i < sizeof table_meat_position ; i ++ )
	{
		table_meat_text [ i ] = CreateDynamic3DTextLabel ( "** Рабочее место **\n{"#cGN3D"}Свободно", col_blue, table_meat_position [ i ] [ 0 ], table_meat_position [ i ] [ 1 ], table_meat_position [ i ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );
		table_meat_area [ i ] = CreateDynamicSphere ( table_meat_position [ i ] [ 0 ], table_meat_position [ i ] [ 1 ], table_meat_position [ i ] [ 2 ], 1.0, -1, -1, -1 ) ;
		area_info [ table_meat_area [ i ] ] [ a_type ] = area_type_factory_meat ;
		
		CreateDynamicCP ( table_meat_position [ i ] [ 0 ], table_meat_position [ i ] [ 1 ], table_meat_position [ i ] [ 2 ], 1.0, -1, 17, -1 ) ;
	}
	
	for ( new i = 0 ; i < sizeof table_apple_position ; i ++ )
	{
		table_apple_text [ i ] = CreateDynamic3DTextLabel ( "** Рабочее место **\n{"#cGN3D"}Свободно", col_blue, table_apple_position [ i ] [ 0 ], table_apple_position [ i ] [ 1 ], table_apple_position [ i ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );
		table_apple_area [ i ] = CreateDynamicSphere ( table_apple_position [ i ] [ 0 ], table_apple_position [ i ] [ 1 ], table_apple_position [ i ] [ 2 ], 1.0, -1, -1, -1 ) ;
		area_info [ table_apple_area [ i ] ] [ a_type ] = area_type_factory_apple ;
		
		CreateDynamicCP ( table_apple_position [ i ] [ 0 ], table_apple_position [ i ] [ 1 ], table_apple_position [ i ] [ 2 ], 1.0, -1, 17, -1 ) ;
	}
	
	for ( new i = 0 ; i < MAX_ARM_OBJ ; i ++ )
	{
		arm_info [ i ] [ arm_object ] = INVALID_OBJECT_ID ;
	}
	
	for ( new i = 0 ; i < 6 ; i ++ )
	{
		table_army_text [ i ] = CreateDynamic3DTextLabel ( "** Рабочее место **\n{"#cGN3D"}Свободно", col_blue, table_army_position [ i ] [ 0 ], table_army_position [ i ] [ 1 ], table_army_position [ i ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );
		table_army_take_text [ i ] = CreateDynamic3DTextLabel ( "** Рабочее место **\n{"#cGN3D"}Свободно", col_blue, table_army_take_position [ i ] [ 0 ], table_army_take_position [ i ] [ 1 ], table_army_take_position [ i ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );
		
		table_army_area [ i ] = CreateDynamicSphere ( table_army_position [ i ] [ 0 ], table_army_position [ i ] [ 1 ], table_army_position [ i ] [ 2 ], 1.0, -1, -1, -1 ) ;
		table_army_take_area [ i ] = CreateDynamicSphere ( table_army_take_position [ i ] [ 0 ], table_army_take_position [ i ] [ 1 ], table_army_take_position [ i ] [ 2 ], 1.0, -1, -1, -1 ) ;
		
		area_info [ table_army_area [ i ] ] [ a_type ] = area_type_factory_army ;
		area_info [ table_army_take_area [ i ] ] [ a_type ] = area_type_factory_army_take ;
		
		CreateDynamicCP ( table_army_position [ i ] [ 0 ], table_army_position [ i ] [ 1 ], table_army_position [ i ] [ 2 ], 1.0, -1, 17, -1 ) ;
		CreateDynamicCP ( table_army_take_position [ i ] [ 0 ], table_army_take_position [ i ] [ 1 ], table_army_take_position [ i ] [ 2 ], 1.0, -1, 17, -1 ) ;
	}
	
	// zavod st . int
	texture_object = CreateDynamicObjectEx(18981, 876.372619, -213.488464, 651.922119, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "concrete12", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 886.611633, -211.268066, 654.841979, 0.000000, 179.999984, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 886.611633, -217.197814, 654.841979, 0.000000, 179.999984, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 886.611633, -205.347961, 654.841979, 0.000000, 179.999984, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 880.971618, -232.076797, 654.841979, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 875.071838, -232.076797, 654.841979, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 869.212280, -232.076797, 654.841979, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 866.139648, -223.078033, 654.841979, -0.000007, 179.999984, 0.000068, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 866.139648, -217.148284, 654.841979, -0.000007, 179.999984, 0.000068, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 866.139648, -228.998138, 654.841979, -0.000007, 179.999984, 0.000068, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 880.971618, -202.627319, 654.841979, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 875.071838, -202.627319, 654.841979, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 869.212280, -202.627319, 654.841979, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(18981, 876.372619, -238.408432, 651.922119, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "concrete12", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 886.611633, -228.998123, 654.841979, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 886.781494, -232.076797, 654.841979, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 886.611633, -223.078018, 654.841979, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 866.139648, -205.347991, 654.841979, -0.000007, 179.999984, 0.000114, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 886.781494, -232.076797, 660.801696, -0.000014, 179.999984, -89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 866.139648, -211.268096, 654.841979, -0.000007, 179.999984, 0.000114, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 886.969848, -223.519912, 655.806701, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 886.969848, -206.679901, 655.806701, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 876.799926, -202.299926, 655.806701, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 865.781494, -210.826202, 655.806701, -0.000014, 0.000007, 89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 865.781494, -227.666229, 655.806701, -0.000014, 0.000007, 89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 876.160156, -232.399826, 655.806701, 0.000000, 0.000000, 540.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 886.611633, -211.268066, 660.801696, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 886.611633, -217.197814, 660.801696, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 886.611633, -205.347961, 660.801696, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 880.971618, -232.076797, 660.801696, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 875.071838, -232.076797, 660.801696, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 869.212280, -232.076797, 660.801696, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 866.139648, -223.078033, 660.801696, -0.000007, 179.999984, 0.000114, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 866.139648, -217.148284, 660.801696, -0.000007, 179.999984, 0.000114, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 866.139648, -228.998138, 660.801696, -0.000007, 179.999984, 0.000114, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 880.971618, -202.627319, 660.801696, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 875.071838, -202.627319, 660.801696, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 866.139648, -205.347991, 660.801696, -0.000007, 179.999984, 0.000159, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 886.611633, -228.998123, 660.801696, 0.000000, 179.999984, -179.999893, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 886.851318, -202.626937, 654.841979, -0.000007, 179.999984, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 886.611633, -223.078018, 660.801696, 0.000000, 179.999984, -179.999893, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 866.139648, -211.268096, 660.801696, -0.000007, 179.999984, 0.000159, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 886.851318, -202.626937, 660.801696, -0.000014, 179.999984, 89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(18981, 876.372619, -213.488464, 661.371826, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16639, "a51_labs", "ws_trainstationwin1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(18981, 876.372619, -238.398513, 661.371826, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16639, "a51_labs", "ws_trainstationwin1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 876.511840, -202.687301, 654.841979, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 13659, "8bars", "bridgeconc", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19358, 876.412414, -202.784683, 654.132202, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 4829, "airport_las", "liftdoorsac256", 0x00000000);
	texture_object = CreateDynamicObjectEx(16322, 872.539550, -214.656570, 653.979553, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 5, 1252, "barrelexpos", "atm", 0x00000000);
	texture_object = CreateDynamicObjectEx(3361, 871.221130, -230.768249, 654.381774, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 16640, "a51", "bluemetal", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 4003, "cityhall_tr_lan", "sl_griddyfence_sml", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 3, 16640, "a51", "bluemetal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 869.182067, -202.627319, 660.801696, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(3361, 881.601196, -230.768249, 654.381774, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 16640, "a51", "bluemetal", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 4003, "cityhall_tr_lan", "sl_griddyfence_sml", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 3, 16640, "a51", "bluemetal", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 859.950012, -202.299926, 655.806701, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 892.990295, -232.399826, 655.806701, 0.000000, 0.000000, 540.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 886.060180, -227.232986, 656.377685, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 886.060180, -217.693038, 656.377685, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 886.060180, -208.083053, 656.377685, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 886.060180, -198.513015, 656.377685, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 884.313232, -228.034500, 656.934265, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 884.313232, -224.604446, 656.934265, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 884.313232, -221.144409, 656.934265, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 884.313232, -217.684356, 656.934265, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 884.313232, -214.224288, 656.934265, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 884.313232, -210.764251, 656.934265, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 884.313232, -207.314147, 656.934265, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 884.313232, -204.504241, 656.934265, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 866.770263, -227.232986, 656.377685, 0.000000, 270.000000, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 866.770263, -217.693038, 656.377685, 0.000000, 270.000000, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 866.770263, -208.083053, 656.377685, 0.000000, 270.000000, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 868.503051, -228.034500, 656.934265, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 868.503051, -224.604446, 656.934265, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 868.503051, -221.144409, 656.934265, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 868.503051, -217.684356, 656.934265, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 868.503051, -214.224288, 656.934265, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 868.503051, -210.764251, 656.934265, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 868.503051, -207.314147, 656.934265, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 868.503051, -204.504241, 656.934265, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 866.770263, -198.533081, 656.377685, 0.000000, 270.000000, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 876.511840, -232.037261, 654.841979, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 13659, "8bars", "bridgeconc", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19358, 876.412414, -231.954696, 654.132202, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16136, "des_telescopestuff", "carparkdoor3_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(2127, 866.700866, -228.262847, 654.022338, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 893.619995, -202.299926, 655.806701, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 869.331542, -207.223648, 660.140014, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 869.331542, -212.183700, 660.140014, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 869.331542, -217.173797, 660.140014, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 869.331542, -222.173751, 660.140014, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 869.331542, -227.173782, 660.140014, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 871.731567, -229.753799, 660.140014, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 876.701416, -229.753799, 660.140014, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 881.691345, -229.753799, 660.140014, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 884.081848, -207.223648, 660.140014, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 884.081848, -212.183700, 660.140014, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 884.081848, -217.173797, 660.140014, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 884.081848, -222.173751, 660.140014, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 884.081848, -227.173782, 660.140014, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.791503, -207.223648, 660.140014, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.791503, -212.183700, 660.140014, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.791503, -217.173797, 660.140014, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.791503, -222.173751, 660.140014, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.791503, -227.173782, 660.140014, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.452148, -207.223648, 660.140014, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.452148, -212.183700, 660.140014, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.452148, -217.173797, 660.140014, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.452148, -222.173751, 660.140014, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.452148, -227.173782, 660.140014, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 871.731567, -204.813842, 660.140014, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 876.701416, -204.813842, 660.140014, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 881.691345, -204.813842, 660.140014, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 876.492553, -209.999114, 660.940490, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 876.492553, -220.249191, 660.940490, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 876.492553, -224.549194, 660.940490, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 878.863098, -209.239166, 660.940490, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 874.572509, -209.239166, 660.940490, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 878.863098, -213.489166, 660.940490, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 874.572509, -213.489166, 660.940490, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 878.863098, -217.739181, 660.940490, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 874.572509, -217.739181, 660.940490, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 878.863098, -221.739227, 660.940490, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 874.572509, -221.739227, 660.940490, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 878.863098, -225.949188, 660.940490, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 874.572509, -225.949188, 660.940490, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.791503, -208.823715, 657.739990, 90.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.791503, -208.823715, 652.750000, 90.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.440673, -208.823715, 657.739990, 89.999992, 90.000015, -89.999992, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.440673, -208.823715, 652.750000, 89.999992, 90.000015, -89.999992, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.791503, -225.573745, 657.739990, 89.999992, 90.000015, -89.999992, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.791503, -225.573745, 652.750000, 89.999992, 90.000015, -89.999992, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.440673, -225.573745, 657.739990, 89.999992, 90.000015, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.440673, -225.573745, 652.750000, 89.999992, 90.000015, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(16322, 880.900146, -214.656570, 653.979553, 0.000000, 0.000000, 630.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 5, 1252, "barrelexpos", "atm", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.452148, -212.053787, 657.770019, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.452148, -217.033721, 657.770019, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.452148, -222.023757, 657.770019, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.453125, -223.093734, 657.770019, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.792358, -212.053787, 657.770019, 0.000000, 0.000037, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.792358, -217.033721, 657.770019, 0.000000, 0.000037, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.792358, -222.023757, 657.770019, 0.000000, 0.000037, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.793334, -223.093734, 657.770019, 0.000000, 0.000037, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19759, 879.395263, -223.824829, 656.292419, 450.000000, 180.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 880.816223, -221.526229, 652.362060, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "sm_conc_hatch", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 880.818176, -213.636123, 652.364013, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "sm_conc_hatch", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.432739, -223.093734, 657.770019, 0.000000, 0.000045, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(3295, 880.799560, -223.785583, 652.332031, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(921, 880.804321, -222.096191, 656.381958, 360.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2127, "cj_kitchen", "CJ_RED", 0x00000000);
	texture_object = CreateDynamicObjectEx(19431, 879.664245, -222.572753, 654.352233, 0.000000, 0.000000, 308.799987, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(19431, 881.854614, -222.572753, 654.352233, -0.000000, 0.000009, 38.799972, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(1943, 880.024963, -225.180038, 653.978149, 0.000000, 0.000000, -35.999996, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	texture_object = CreateDynamicObjectEx(1943, 880.845153, -222.235000, 654.048217, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	texture_object = CreateDynamicObjectEx(19940, 881.057067, -221.317520, 653.744567, 0.000000, -36.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(19940, 880.697021, -221.317520, 653.744567, 0.000007, -36.000015, 179.999832, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(19940, 880.734008, -218.429870, 653.293701, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(19940, 881.024230, -218.430877, 653.294677, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(19940, 881.057067, -219.391845, 653.474853, -15.100049, -35.999965, 0.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(19940, 880.697021, -219.391845, 653.474853, 15.100049, -35.999992, 179.999572, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(19759, 873.944702, -223.824829, 656.292419, 89.999992, 180.000000, 269.999969, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 872.455627, -221.526229, 652.362060, 0.000000, 270.000000, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "sm_conc_hatch", 0x00000000);
	texture_object = CreateDynamicObjectEx(2659, 879.726013, -222.402206, 654.011962, 540.000000, 90.000000, -141.000015, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16644, "a51_detailstuff", "a51_secdesk", 0x00000000);
	texture_object = CreateDynamicObjectEx(1953, 880.812805, -222.136077, 654.703369, 90.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 2, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(10985, 892.022033, -224.711853, 652.874938, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 19638, "fruitcrates1", "applesgreen1", 0x00000000);
	texture_object = CreateDynamicObjectEx(10985, 890.926635, -222.544906, 652.874938, 0.000000, 0.000000, -133.399993, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 19638, "fruitcrates1", "applesred1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 875.272827, -235.794662, 654.132202, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16136, "des_telescopestuff", "carparkdoor3_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19481, 877.963195, -241.125595, 652.462219, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 19063, "xmasorbs", "sphere", 0x55FFFFFF);
	texture_object = CreateDynamicObjectEx(2691, 886.486389, -224.332015, 652.462341, -89.999992, 180.000015, 89.999969, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 19638, "fruitcrates1", "applesgreen1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2691, 886.486389, -222.201904, 652.462341, -89.999992, 180.000015, 89.999969, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 19638, "fruitcrates1", "applesgreen1", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 880.089050, -212.743728, 652.792480, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 880.089050, -215.243789, 652.792480, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 880.089050, -217.683761, 652.792480, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 881.739868, -212.743728, 652.792480, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 881.739868, -215.243789, 652.792480, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 881.739868, -217.683761, 652.792480, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(743, 879.946166, -225.294555, 653.607055, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 872.457580, -213.636123, 652.364013, 0.000000, 270.000000, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "sm_conc_hatch", 0x00000000);
	texture_object = CreateDynamicObjectEx(3295, 872.438964, -223.785583, 652.332031, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(921, 872.443725, -222.096191, 656.381958, 0.000000, -0.000007, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2127, "cj_kitchen", "CJ_RED", 0x00000000);
	texture_object = CreateDynamicObjectEx(19431, 871.303649, -222.572753, 654.352233, -0.000004, 0.000003, -51.200000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(19431, 873.494018, -222.572753, 654.352233, 0.000003, 0.000014, 38.799972, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(2263, 871.349975, -225.570266, 653.893371, 0.000000, 0.000000, -34.200012, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	texture_object = CreateDynamicObjectEx(2263, 872.536315, -221.728424, 654.893371, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	texture_object = CreateDynamicObjectEx(2263, 871.349975, -225.570266, 654.463439, 0.000000, 0.000000, -34.200012, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	texture_object = CreateDynamicObjectEx(2659, 871.365417, -222.402206, 654.011962, 0.000000, -89.999984, 38.999996, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16644, "a51_detailstuff", "a51_secdesk", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 871.728454, -212.743728, 652.792480, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 871.728454, -215.243789, 652.792480, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 871.728454, -217.683761, 652.792480, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 873.379272, -212.743728, 652.792480, 0.000029, 0.000000, 89.999908, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 873.379272, -215.243789, 652.792480, 0.000029, 0.000000, 89.999908, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 873.379272, -217.683761, 652.792480, 0.000029, 0.000000, 89.999908, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(743, 871.585571, -225.294555, 653.607055, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	texture_object = CreateDynamicObjectEx(1234, 872.511596, -221.986068, 655.424560, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1234, 872.511596, -219.336074, 655.424560, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1234, 872.511596, -216.686111, 655.424560, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1234, 872.511596, -214.046066, 655.424560, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1234, 872.511596, -211.416091, 655.424560, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1234, 872.511596, -211.066101, 655.425537, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2263, 872.536315, -221.728424, 654.383178, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	texture_object = CreateDynamicObjectEx(2263, 872.536315, -221.728424, 653.873229, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	texture_object = CreateDynamicObjectEx(2127, 866.720642, -227.252853, 654.212402, 0.000007, -179.999984, 89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(2127, 866.700866, -226.212875, 654.022338, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(2127, 866.720642, -225.202880, 654.212402, 0.000014, -179.999984, 89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(2127, 866.700866, -224.212936, 654.022338, 0.000029, 0.000000, 89.999908, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(2127, 866.720642, -223.202941, 654.212402, 0.000022, -179.999984, 89.999938, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 876.022338, -205.283767, 652.359863, 180.000000, 90.000038, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 876.022338, -210.253784, 652.359863, 180.000000, 90.000038, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 876.022338, -215.253723, 652.359863, 180.000000, 90.000038, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 876.022338, -220.253677, 652.359863, 180.000000, 90.000038, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 876.022338, -225.253768, 652.359863, 180.000000, 90.000038, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 876.022338, -230.223754, 652.359863, 180.000000, 90.000038, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.522460, -231.933731, 653.009704, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 885.512084, -231.933731, 653.009704, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 871.021911, -231.933731, 653.009704, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 866.031860, -231.933731, 653.009704, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 871.342468, -202.663665, 653.009704, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 866.332519, -202.663665, 653.009704, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 881.872192, -202.663665, 653.009704, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 886.861877, -202.663665, 653.009704, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 886.561767, -205.023651, 653.009704, 360.000000, 180.000030, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 886.561767, -210.003662, 653.009704, 360.000000, 180.000030, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 886.561767, -214.983657, 653.009704, 360.000000, 180.000030, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 886.561767, -219.973693, 653.009704, 360.000000, 180.000030, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 886.561767, -224.963668, 653.009704, 360.000000, 180.000030, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 886.561767, -229.933639, 653.009704, 360.000000, 180.000030, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 866.191711, -205.023651, 653.009704, 0.000000, 180.000030, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 866.191711, -210.003662, 653.009704, 0.000000, 180.000030, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 866.191711, -214.983657, 653.009704, 0.000000, 180.000030, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 866.191711, -219.973693, 653.009704, 0.000000, 180.000030, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 866.191711, -224.963668, 653.009704, 0.000000, 180.000030, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 866.191711, -229.933639, 653.009704, 0.000000, 180.000030, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 873.192138, -208.843719, 652.360839, 180.000000, 90.000038, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 878.181945, -208.843719, 652.360839, 180.000000, 90.000038, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.072204, -208.843719, 652.361816, 180.000000, 90.000038, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 870.692260, -210.593688, 652.360839, 180.000000, 90.000038, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 870.692260, -215.593704, 652.360839, 180.000000, 90.000038, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 870.692260, -220.583755, 652.360839, 180.000000, 90.000038, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 870.692260, -223.843734, 652.360839, 180.000000, 90.000038, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 872.442504, -226.343750, 652.360839, 180.000000, 90.000038, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 877.432617, -226.343750, 652.360839, 180.000000, 90.000038, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.062622, -226.343750, 652.361816, 180.000000, 90.000038, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 882.562194, -224.593734, 652.361816, 180.000000, 90.000038, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 882.562194, -219.593750, 652.361816, 180.000000, 90.000038, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 882.562194, -214.613693, 652.361816, 180.000000, 90.000038, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 882.562194, -210.593658, 652.361816, 180.000000, 90.000038, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.674560, -211.390396, 650.948608, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.674560, -216.530395, 650.948608, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.674560, -221.700439, 650.948608, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.674560, -226.850479, 650.948608, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.674560, -232.000503, 650.948608, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.674560, -205.720504, 650.948608, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.674560, -200.630493, 650.948608, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.124328, -221.240600, 650.948608, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.124328, -216.100585, 650.948608, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.124328, -210.930541, 650.948608, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.124328, -205.780517, 650.948608, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.124328, -200.630493, 650.948608, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.124328, -226.910461, 650.948608, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 876.124328, -232.000488, 650.948608, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 859.320190, -232.399826, 655.806701, 0.000000, 0.000000, 540.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19172, 876.465698, -231.927108, 659.569274, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 915, "airconext", "cj_plating3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19172, 876.465698, -202.767120, 659.569274, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 915, "airconext", "cj_plating3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19172, 866.266296, -215.177108, 659.569274, 0.000000, 0.000000, 450.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 915, "airconext", "cj_plating3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19172, 886.466064, -215.177108, 659.569274, 0.000000, 0.000000, 630.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 915, "airconext", "cj_plating3", 0x00000000);
	texture_object = CreateDynamicObjectEx(920, 873.618652, -219.064529, 652.821899, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16644, "a51_detailstuff", "aluminiumbands256", 0x00000000);
	texture_object = CreateDynamicObjectEx(920, 879.858825, -219.504501, 652.821899, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16644, "a51_detailstuff", "aluminiumbands256", 0x00000000);
	texture_object = CreateDynamicObjectEx(920, 873.618652, -210.254486, 652.821899, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16644, "a51_detailstuff", "aluminiumbands256", 0x00000000);
	texture_object = CreateDynamicObjectEx(920, 879.858825, -210.634552, 652.821899, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16644, "a51_detailstuff", "aluminiumbands256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19480, 876.525329, -217.641464, 652.431457, 0.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 19063, "xmasorbs", "sphere", 0x00000000);
	texture_object = CreateDynamicObjectEx(19480, 870.075439, -217.641464, 652.431457, 0.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 19063, "xmasorbs", "sphere", 0x00000000);
	texture_object = CreateDynamicObjectEx(19480, 883.125427, -217.641464, 652.431457, 0.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 19063, "xmasorbs", "sphere", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 880.971618, -235.736755, 654.941894, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 4835, "airoads_las", "tardor2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 875.061645, -235.736755, 654.941894, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 4835, "airoads_las", "tardor2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 872.201416, -238.246719, 654.941894, 0.000000, 179.999984, -0.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 4835, "airoads_las", "tardor2", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19464, 872.201416, -244.166732, 654.941894, 0.000000, 179.999984, -0.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 4835, "airoads_las", "tardor2", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19464, 883.651428, -238.246719, 654.941894, 0.000000, 179.999984, -0.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 4835, "airoads_las", "tardor2", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19464, 883.651428, -244.166732, 654.941894, 0.000000, 179.999984, -0.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 4835, "airoads_las", "tardor2", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19464, 880.971618, -246.946655, 654.941894, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 4835, "airoads_las", "tardor2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 875.061645, -246.946655, 654.941894, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 4835, "airoads_las", "tardor2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19358, 878.442749, -235.794662, 654.132202, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16136, "des_telescopestuff", "carparkdoor3_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 877.992370, -246.894592, 654.132202, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 13364, "cetown3cs_t", "sw_door17", 0x00000000);
	texture_object = CreateDynamicObjectEx(8661, 890.769409, -244.674224, 657.491516, 180.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14756, "smallsfhs", "ah_whitiles", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 881.150085, -242.863891, 654.891723, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 17562, "coast_apts", "scumtiles1_LAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 881.150085, -238.683868, 654.891723, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 17562, "coast_apts", "scumtiles1_LAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 874.668579, -242.863891, 654.891723, 89.999992, 89.999992, -89.999992, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 17562, "coast_apts", "scumtiles1_LAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 874.668579, -238.683868, 654.891723, 89.999992, 89.999992, -89.999992, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 17562, "coast_apts", "scumtiles1_LAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 874.278320, -241.153930, 652.331481, 360.000000, 89.999992, 0.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 17562, "coast_apts", "scumtiles1_LAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 880.758911, -241.153930, 652.331481, 360.000000, 89.999992, 0.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 17562, "coast_apts", "scumtiles1_LAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(2631, 872.301757, -241.220031, 655.462036, 90.000000, 450.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 15034, "genhotelsave", "AH_windows", 0x00000000);
	texture_object = CreateDynamicObjectEx(2631, 883.512145, -241.220031, 655.462036, 90.000000, 450.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 15034, "genhotelsave", "AH_windows", 0x00000000);
	texture_object = CreateDynamicObjectEx(1726, 874.949218, -242.096267, 652.382019, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 14495, "sweetshall", "mcstraps_door1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1726, 880.879272, -240.076278, 652.382019, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 14495, "sweetshall", "mcstraps_door1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2740, 879.975891, -243.221359, 657.362792, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(2740, 879.975891, -239.081390, 657.362792, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(2740, 875.775329, -243.221359, 657.362792, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(2740, 875.775329, -239.081390, 657.362792, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(2258, 877.609619, -235.901565, 656.621887, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 13007, "sw_bankint", "closed_temp", 0x00000000);
	texture_object = CreateDynamicObjectEx(18846, 877.932006, -241.133056, 658.972656, 180.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 6988, "vgnfremnt1", "casinolights3_128n", 0x00000000);
	texture_object = CreateDynamicObjectEx(2974, 871.597229, -236.797363, 651.882141, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "a51_strips1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2734, 872.935791, -236.790786, 654.092163, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 1714, "cj_office", "of_monitor_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(2258, 876.269775, -235.901565, 656.611694, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 19962, "samproadsigns", "stopsign", 0x00000000);
	texture_object = CreateDynamicObjectEx(18981, 913.298339, 21.245727, 680.369689, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "concrete12", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 923.537353, 23.466125, 683.289550, 0.000000, 179.999984, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 923.537353, 17.536376, 683.289550, 0.000000, 179.999984, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 923.537353, 29.386230, 683.289550, 0.000000, 179.999984, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 917.897338, 2.657393, 683.289550, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 911.997558, 2.657393, 683.289550, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 906.138000, 2.657393, 683.289550, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 903.065368, 11.656158, 683.289550, -0.000007, 179.999984, 0.000068, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 903.065368, 17.585905, 683.289550, -0.000007, 179.999984, 0.000068, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 903.065368, 5.736052, 683.289550, -0.000007, 179.999984, 0.000068, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 917.897338, 32.106872, 683.289550, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 911.997558, 32.106872, 683.289550, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 906.138000, 32.106872, 683.289550, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(18981, 913.298339, -3.674240, 680.369689, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "concrete12", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 923.537353, 5.736067, 683.289550, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 923.707214, 2.657393, 683.289550, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 923.537353, 11.656172, 683.289550, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 903.065368, 29.386199, 683.289550, -0.000007, 179.999984, 0.000114, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 923.707214, 2.657393, 689.249267, -0.000014, 179.999984, -89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 903.065368, 23.466093, 683.289550, -0.000007, 179.999984, 0.000114, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 923.895568, 11.214279, 684.254272, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 923.895568, 28.054290, 684.254272, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 913.725646, 32.434265, 684.254272, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 902.707214, 23.907989, 684.254272, -0.000014, 0.000007, 89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 902.707214, 7.067962, 684.254272, -0.000014, 0.000007, 89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 913.085876, 2.334364, 684.254272, 0.000000, 0.000000, 540.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 923.537353, 23.466125, 689.249267, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 923.537353, 17.536376, 689.249267, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 923.537353, 29.386230, 689.249267, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 917.897338, 2.657393, 689.249267, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 911.997558, 2.657393, 689.249267, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 906.138000, 2.657393, 689.249267, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 903.065368, 11.656158, 689.249267, -0.000007, 179.999984, 0.000114, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 903.065368, 17.585905, 689.249267, -0.000007, 179.999984, 0.000114, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 903.065368, 5.736052, 689.249267, -0.000007, 179.999984, 0.000114, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 917.897338, 32.106872, 689.249267, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 911.997558, 32.106872, 689.249267, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 903.065368, 29.386199, 689.249267, -0.000007, 179.999984, 0.000159, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 923.537353, 5.736067, 689.249267, 0.000000, 179.999984, -179.999893, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 923.777038, 32.107254, 683.289550, -0.000007, 179.999984, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 923.537353, 11.656172, 689.249267, 0.000000, 179.999984, -179.999893, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 903.065368, 23.466093, 689.249267, -0.000007, 179.999984, 0.000159, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 923.777038, 32.107254, 689.249267, -0.000014, 179.999984, 89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(18981, 913.298339, 21.245727, 689.819396, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16639, "a51_labs", "ws_trainstationwin1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(18981, 913.298339, -3.634270, 689.819396, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16639, "a51_labs", "ws_trainstationwin1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19464, 913.437561, 32.046890, 683.289550, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 13659, "8bars", "bridgeconc", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19358, 913.338134, 31.949508, 682.579772, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 4829, "airport_las", "liftdoorsac256", 0x00000000);
	texture_object = CreateDynamicObjectEx(16322, 909.465270, 20.077621, 682.427124, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 5, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(3361, 908.146850, 3.965941, 682.829345, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 16640, "a51", "bluemetal", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 4003, "cityhall_tr_lan", "sl_griddyfence_sml", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 3, 16640, "a51", "bluemetal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 906.107788, 32.106872, 689.249267, -0.000007, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18773, "tunnelsections", "stonewalltile1-5", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(3361, 918.526916, 3.965941, 682.829345, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 16640, "a51", "bluemetal", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 4003, "cityhall_tr_lan", "sl_griddyfence_sml", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 3, 16640, "a51", "bluemetal", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 896.875732, 32.434265, 684.254272, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 929.916015, 2.334364, 684.254272, 0.000000, 0.000000, 540.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 922.985900, 7.501204, 684.825256, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 922.985900, 17.041151, 684.825256, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 922.985900, 26.651138, 684.825256, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 922.985900, 36.221176, 684.825256, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 921.238952, 6.699690, 685.381835, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 921.238952, 10.129744, 685.381835, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 921.238952, 13.589781, 685.381835, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 921.238952, 17.049835, 685.381835, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 921.238952, 20.509901, 685.381835, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 921.238952, 23.969940, 685.381835, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 921.238952, 27.420043, 685.381835, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 921.238952, 30.229949, 685.381835, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 903.695983, 7.501204, 684.825256, 0.000000, 270.000000, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 903.695983, 17.041151, 684.825256, 0.000000, 270.000000, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 903.695983, 26.651138, 684.825256, 0.000000, 270.000000, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 905.428771, 6.699690, 685.381835, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 905.428771, 10.129744, 685.381835, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 905.428771, 13.589781, 685.381835, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 905.428771, 17.049835, 685.381835, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 905.428771, 20.509901, 685.381835, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 905.428771, 23.969940, 685.381835, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 905.428771, 27.420043, 685.381835, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 905.428771, 30.229949, 685.381835, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(19450, 903.695983, 36.201110, 684.825256, 0.000000, 270.000000, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(1431, 921.839477, 11.870468, 681.369628, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14690, "7_11_posters", "cokopops_1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19464, 913.437561, 2.696928, 683.289550, 0.000000, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 13659, "8bars", "bridgeconc", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19358, 913.338134, 2.779495, 682.579772, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16136, "des_telescopestuff", "carparkdoor3_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(2127, 903.626586, 6.471343, 682.469909, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 930.545715, 32.434265, 684.254272, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 906.257263, 27.510543, 688.587585, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 906.257263, 22.550491, 688.587585, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 906.257263, 17.560394, 688.587585, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 906.257263, 12.560440, 688.587585, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 906.257263, 7.560409, 688.587585, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 908.657287, 4.980391, 688.587585, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 913.627136, 4.980391, 688.587585, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 918.617065, 4.980391, 688.587585, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 921.007568, 27.510543, 688.587585, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 921.007568, 22.550491, 688.587585, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 921.007568, 17.560394, 688.587585, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 921.007568, 12.560440, 688.587585, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 921.007568, 7.560409, 688.587585, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.717224, 27.510543, 688.587585, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.717224, 22.550491, 688.587585, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.717224, 17.560394, 688.587585, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.717224, 12.560440, 688.587585, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.717224, 7.560409, 688.587585, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.377868, 27.510543, 688.587585, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.377868, 22.550491, 688.587585, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.377868, 17.560394, 688.587585, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.377868, 12.560440, 688.587585, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.377868, 7.560409, 688.587585, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 908.657287, 29.920349, 688.587585, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 913.627136, 29.920349, 688.587585, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 918.617065, 29.920349, 688.587585, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 913.418273, 24.735076, 689.388061, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 913.418273, 14.484999, 689.388061, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 913.418273, 10.184996, 689.388061, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 915.788818, 25.495025, 689.388061, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 911.498229, 25.495025, 689.388061, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 915.788818, 21.245025, 689.388061, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 911.498229, 21.245025, 689.388061, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 915.788818, 16.995010, 689.388061, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 911.498229, 16.995010, 689.388061, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 915.788818, 12.994963, 689.388061, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 911.498229, 12.994963, 689.388061, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 915.788818, 8.785002, 689.388061, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(3578, 911.498229, 8.785002, 689.388061, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16322, "a51_stores", "dish_panel_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.717224, 25.910476, 686.187561, 90.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.717224, 25.910476, 681.197570, 90.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.366394, 25.910476, 686.187561, 89.999992, 90.000015, -89.999992, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.366394, 25.910476, 681.197570, 89.999992, 90.000015, -89.999992, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.717224, 9.160446, 686.187561, 89.999992, 90.000015, -89.999992, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.717224, 9.160446, 681.197570, 89.999992, 90.000015, -89.999992, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.366394, 9.160446, 686.187561, 89.999992, 90.000015, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.366394, 9.160446, 681.197570, 89.999992, 90.000015, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "pavegrey128", 0x00000000);
	texture_object = CreateDynamicObjectEx(16322, 917.825866, 20.077621, 682.427124, 0.000000, 0.000000, 630.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 5, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.377868, 22.680404, 686.217590, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.377868, 17.700468, 686.217590, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.377868, 12.710433, 686.217590, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.378845, 11.640457, 686.217590, 0.000000, 0.000029, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.718078, 22.680404, 686.217590, 0.000000, 0.000037, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.718078, 17.700468, 686.217590, 0.000000, 0.000037, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.718078, 12.710433, 686.217590, 0.000000, 0.000037, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.719055, 11.640457, 686.217590, 0.000000, 0.000037, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19759, 916.320983, 10.909361, 684.739990, 450.000000, 180.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 917.741943, 13.207962, 680.809631, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "sm_conc_hatch", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 917.743896, 21.098068, 680.811584, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "sm_conc_hatch", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.358459, 11.640457, 686.217590, 0.000000, 0.000045, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(16322, 913.615478, 24.477626, 682.447265, -0.000007, 0.000000, 180.000030, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 5, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(3295, 917.725280, 10.948608, 680.779602, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(921, 917.730041, 12.637999, 684.829528, 360.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2127, "cj_kitchen", "CJ_RED", 0x00000000);
	texture_object = CreateDynamicObjectEx(19431, 916.589965, 12.161437, 682.799804, 0.000000, 0.000000, 308.799987, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(1943, 916.950683, 9.554153, 682.425720, 0.000000, 0.000000, -35.999996, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	texture_object = CreateDynamicObjectEx(1943, 917.770874, 12.499191, 682.655822, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	texture_object = CreateDynamicObjectEx(19940, 917.789794, 14.973319, 681.742248, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(2685, 914.675659, 23.842836, 682.127380, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 4510, "barrierblk", "warnsigns1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19940, 917.790222, 13.070699, 682.147583, -23.700004, 0.000007, 0.000003, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 909.381347, 13.207962, 680.809631, 0.000000, 270.000000, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "sm_conc_hatch", 0x00000000);
	texture_object = CreateDynamicObjectEx(2659, 916.651733, 12.331985, 682.459533, 540.000000, 90.000000, -141.000015, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16644, "a51_detailstuff", "a51_secdesk", 0x00000000);
	texture_object = CreateDynamicObjectEx(19843, 911.916076, 23.947807, 682.208984, 89.999992, 89.999992, -89.999992, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "a51_panels1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19843, 912.915954, 23.947807, 682.208984, 89.999992, 89.999992, -89.999992, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "a51_panels1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1431, 922.959716, 9.609451, 681.369628, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14690, "7_11_posters", "cokopops_1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1431, 922.959716, 7.359436, 681.369628, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14690, "7_11_posters", "cokopops_1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1431, 921.839477, 9.600462, 681.369628, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14690, "7_11_posters", "cokopops_1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1431, 921.839477, 7.300445, 681.369628, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14690, "7_11_posters", "cokopops_1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1431, 922.249633, 5.710464, 681.369628, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14690, "7_11_posters", "cokopops_1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19843, 911.916076, 25.037822, 682.208984, 89.999992, 89.999992, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "a51_panels1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19843, 912.915954, 25.037822, 682.208984, 89.999992, 89.999992, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "a51_panels1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19843, 913.906372, 23.947807, 682.208984, 89.999992, 89.999992, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "a51_panels1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19843, 914.585998, 23.948806, 682.208984, 89.999992, 89.999992, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "a51_panels1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19843, 913.906372, 25.037822, 682.208984, 89.999992, 90.000000, -89.999969, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "a51_panels1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19843, 914.585998, 25.028806, 682.208984, 89.999992, 89.999992, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "a51_panels1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19843, 914.395874, 24.458810, 682.759155, 180.000000, 180.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14668, "711c", "gun_ceiling3", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 917.014770, 21.990463, 681.240051, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 917.014770, 19.490402, 681.240051, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 917.014770, 17.050430, 681.240051, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 918.665588, 21.990463, 681.240051, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 918.665588, 19.490402, 681.240051, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 918.665588, 17.050430, 681.240051, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19843, 913.405822, 24.458810, 682.759155, 180.000000, 180.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14668, "711c", "gun_ceiling3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19843, 912.466064, 24.458810, 682.759155, 180.000000, 180.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14668, "711c", "gun_ceiling3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19843, 911.996032, 24.458810, 682.759155, 180.000000, 180.000000, -89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14668, "711c", "gun_ceiling3", 0x00000000);
	texture_object = CreateDynamicObjectEx(743, 916.871887, 9.439636, 682.054626, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 909.383300, 21.098068, 680.811584, 0.000000, 270.000000, -179.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "sm_conc_hatch", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 908.654174, 21.990463, 681.240051, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 908.654174, 19.490402, 681.240051, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 908.654174, 17.050430, 681.240051, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 910.304992, 21.990463, 681.240051, 0.000029, 0.000000, 89.999908, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 910.304992, 19.490402, 681.240051, 0.000029, 0.000000, 89.999908, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(941, 910.304992, 17.050430, 681.240051, 0.000029, 0.000000, 89.999908, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16271, "des_factory", "dish_cylinder_a", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(1636, 914.355529, 24.485008, 682.336853, 270.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "a51_cardreader", 0x00000000);
	texture_object = CreateDynamicObjectEx(1636, 913.115295, 24.485008, 682.336853, 270.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "a51_cardreader", 0x00000000);
	texture_object = CreateDynamicObjectEx(1636, 911.745300, 24.485008, 682.336853, 270.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "a51_cardreader", 0x00000000);
	texture_object = CreateDynamicObjectEx(1431, 909.509460, 10.870444, 681.389648, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14690, "7_11_posters", "cokopops_1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1431, 909.509460, 10.010444, 681.389648, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14690, "7_11_posters", "cokopops_1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1431, 909.509460, 10.470444, 682.459777, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 14690, "7_11_posters", "cokopops_1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2127, 903.646362, 7.481338, 682.659973, 0.000007, -179.999984, 89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(2127, 903.626586, 8.521315, 682.469909, 0.000022, 0.000000, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(2127, 903.646362, 9.531311, 682.659973, 0.000014, -179.999984, 89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(2127, 903.626586, 10.521254, 682.469909, 0.000029, 0.000000, 89.999908, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(2127, 903.646362, 11.531250, 682.659973, 0.000022, -179.999984, 89.999938, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 1, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 912.948059, 29.450424, 680.807434, 180.000000, 90.000038, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 912.948059, 24.480407, 680.807434, 180.000000, 90.000038, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 912.948059, 19.480468, 680.807434, 180.000000, 90.000038, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 912.948059, 14.480513, 680.807434, 180.000000, 90.000038, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 912.948059, 9.480422, 680.807434, 180.000000, 90.000038, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 912.948059, 4.510437, 680.807434, 180.000000, 90.000038, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 917.448181, 2.800460, 681.457275, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 922.437805, 2.800460, 681.457275, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 907.947631, 2.800460, 681.457275, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 902.957580, 2.800460, 681.457275, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 908.268188, 32.070526, 681.457275, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 903.258239, 32.070526, 681.457275, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 918.797912, 32.070526, 681.457275, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 923.787597, 32.070526, 681.457275, 360.000000, 180.000030, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 923.487487, 29.710540, 681.457275, 360.000000, 180.000030, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 923.487487, 24.730529, 681.457275, 360.000000, 180.000030, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 923.487487, 19.750534, 681.457275, 360.000000, 180.000030, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 923.487487, 14.760498, 681.457275, 360.000000, 180.000030, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 923.487487, 9.770523, 681.457275, 360.000000, 180.000030, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 923.487487, 4.800551, 681.457275, 360.000000, 180.000030, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 903.117431, 29.710540, 681.457275, 0.000000, 180.000030, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 903.117431, 24.730529, 681.457275, 0.000000, 180.000030, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 903.117431, 19.750534, 681.457275, 0.000000, 180.000030, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 903.117431, 14.760498, 681.457275, 0.000000, 180.000030, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 903.117431, 9.770523, 681.457275, 0.000000, 180.000030, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 903.117431, 4.800551, 681.457275, 0.000000, 180.000030, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 910.117858, 25.890472, 680.808410, 180.000000, 90.000038, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 915.107666, 25.890472, 680.808410, 180.000000, 90.000038, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 916.997924, 25.890472, 680.809387, 180.000000, 90.000038, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 907.617980, 24.140502, 680.808410, 180.000000, 90.000038, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 907.617980, 19.140487, 680.808410, 180.000000, 90.000038, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 907.617980, 14.150436, 680.808410, 180.000000, 90.000038, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 907.617980, 10.890457, 680.808410, 180.000000, 90.000038, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 909.368225, 8.390440, 680.808410, 180.000000, 90.000038, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 914.358337, 8.390440, 680.808410, 180.000000, 90.000038, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 916.988342, 8.390440, 680.809387, 180.000000, 90.000038, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 919.487915, 10.140457, 680.809387, 180.000000, 90.000038, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 919.487915, 15.140440, 680.809387, 180.000000, 90.000038, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 919.487915, 20.120498, 680.809387, 180.000000, 90.000038, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 919.487915, 24.140533, 680.809387, 180.000000, 90.000038, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.600280, 23.343795, 679.396179, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.600280, 18.203796, 679.396179, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.600280, 13.033752, 679.396179, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.600280, 7.883711, 679.396179, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.600280, 2.733688, 679.396179, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.600280, 29.013687, 679.396179, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.600280, 34.103698, 679.396179, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.050048, 13.493591, 679.396179, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.050048, 18.633604, 679.396179, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.050048, 23.803649, 679.396179, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.050048, 28.953674, 679.396179, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.050048, 34.103698, 679.396179, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.050048, 7.823729, 679.396179, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 913.050048, 2.733702, 679.396179, 0.000000, -0.000007, -90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 18631, "nomodelfile", "hazardtile6", 0x00000000);
	texture_object = CreateDynamicObjectEx(7901, 896.245910, 2.334364, 684.254272, 0.000000, 0.000000, 540.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19172, 913.391418, 2.807082, 688.016845, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 915, "airconext", "cj_plating3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19172, 913.391418, 31.967071, 688.016845, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 915, "airconext", "cj_plating3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19172, 903.192016, 19.557083, 688.016845, 0.000000, 0.000000, 450.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 915, "airconext", "cj_plating3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19172, 923.391784, 19.557083, 688.016845, 0.000000, 0.000000, 630.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 915, "airconext", "cj_plating3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19480, 913.451049, 17.092727, 680.879028, 0.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 19063, "xmasorbs", "sphere", 0x00000000);
	texture_object = CreateDynamicObjectEx(19480, 907.001159, 17.092727, 680.879028, 0.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 19063, "xmasorbs", "sphere", 0x00000000);
	texture_object = CreateDynamicObjectEx(19480, 920.051147, 17.092727, 680.879028, 0.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	SetDynamicObjectMaterial(texture_object, 0, 19063, "xmasorbs", "sphere", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	texture_object = CreateDynamicObjectEx(3785, 876.403442, -202.926864, 656.422302, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1431, 884.913757, -222.863723, 652.922058, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3361, 885.303344, -216.615859, 650.280395, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 877.204895, -201.915588, 653.531982, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 876.054931, -201.915588, 653.531982, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3361, 885.303344, -208.425781, 650.280395, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3361, 885.303344, -200.235809, 650.280395, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3361, 867.352844, -201.915802, 650.280395, 0.000000, 179.999984, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3361, 867.352844, -210.095794, 650.280395, 0.000000, 179.999984, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3361, 867.352844, -218.285858, 650.280395, 0.000000, 179.999984, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1893, 872.460388, -212.665466, 657.734436, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1893, 872.460388, -216.225448, 657.734436, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1893, 872.460388, -219.785507, 657.734436, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2649, 878.942321, -223.784652, 652.382080, 360.000000, 270.000000, 720.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1893, 880.790527, -212.665466, 657.734436, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1893, 880.790527, -216.225448, 657.734436, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1893, 880.790527, -219.785507, 657.734436, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2649, 874.321838, -223.784652, 652.382080, 0.000000, 270.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2983, 879.507873, -223.798675, 654.572265, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19758, 876.498107, -205.706817, 659.382568, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19758, 876.498107, -228.806777, 659.382568, 0.000000, -0.000014, 179.999908, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2886, 880.748474, -225.945770, 654.150695, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18633, 880.810180, -222.120803, 654.738098, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1009, 879.414978, -222.654922, 654.282409, 360.000000, 90.000000, 133.900100, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 876.403442, -231.826858, 656.422302, 0.000000, 0.000000, 450.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1431, 886.033996, -222.863723, 652.922058, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1431, 886.033996, -225.124740, 652.922058, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1431, 886.033996, -227.374755, 652.922058, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1431, 884.913757, -225.133728, 652.922058, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1431, 885.323913, -229.023727, 652.922058, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2886, 876.476135, -235.918487, 654.262573, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 870.259155, -228.655273, 653.162109, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2983, 873.767333, -223.798675, 654.572265, -0.000007, 0.000000, 90.000022, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19836, 872.828857, -221.190002, 652.458068, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19836, 872.278808, -220.720016, 652.458068, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19836, 873.608886, -217.670013, 653.288024, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19836, 873.608886, -215.660064, 653.288024, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1009, 871.054382, -222.654922, 654.282409, 0.000000, 89.999992, 133.900085, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19836, 873.608886, -212.820068, 653.288024, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19836, 871.518615, -217.670013, 653.288024, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19836, 871.518615, -215.660064, 653.288024, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19836, 871.518615, -212.820068, 653.288024, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19590, 873.826110, -212.459823, 653.302307, 180.000000, 90.000000, 46.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19590, 873.826110, -214.869827, 653.302307, 0.000000, 270.000000, -134.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19590, 873.826110, -217.179809, 653.302307, -0.000004, 270.000000, -134.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19590, 871.325561, -217.179809, 653.302307, 0.000000, 270.000000, 45.999958, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19590, 871.325561, -214.769836, 653.302307, -0.000004, 270.000000, 45.999977, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19590, 871.325561, -212.459838, 653.302307, -0.000009, 270.000000, 45.999977, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 865.993225, -228.017272, 653.522033, 89.999992, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 865.993225, -227.127243, 653.522033, 89.999992, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2922, 866.955200, -227.743759, 654.392211, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 865.993225, -225.967300, 653.522033, 89.999992, 179.999984, -89.999969, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 865.993225, -225.077270, 653.522033, 89.999992, 179.999984, -89.999969, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2922, 866.955200, -225.713760, 654.392211, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 865.993225, -223.967361, 653.522033, 89.999992, 180.000000, -89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 865.993225, -223.077331, 653.522033, 89.999992, 180.000000, -89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2922, 866.955200, -223.713714, 654.392211, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 866.857055, -209.940567, 659.502319, 0.000000, 90.000000, 89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 866.857055, -223.580612, 659.502319, 0.000000, -89.999984, 90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 885.897644, -223.580596, 659.502319, -0.000007, 89.999992, -90.000015, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 885.897644, -209.940582, 659.502319, -0.000007, -89.999992, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 878.507751, -224.630783, 659.712585, 89.999992, 89.999992, -89.999969, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 878.507751, -210.960769, 659.712585, 89.999992, 224.901016, -44.901054, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 874.446899, -224.630783, 659.712585, 89.999992, 90.000007, -89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 874.446899, -210.960769, 659.712585, 89.999992, 244.403289, -64.403327, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 870.259155, -204.235290, 653.162109, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 870.259155, -206.135299, 653.162109, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 870.259155, -205.245300, 654.682250, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 880.399475, -204.455337, 653.162109, 0.000007, -0.000007, 179.999908, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 882.299499, -204.455337, 653.162109, 0.000007, -0.000007, 179.999908, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 881.409484, -204.455337, 654.682250, 0.000007, -0.000007, 179.999908, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19809, 873.546020, -211.627334, 653.332336, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19809, 873.546020, -214.137390, 653.332336, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19809, 873.546020, -216.457412, 653.332336, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19809, 871.575317, -211.627334, 653.332336, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19809, 871.575317, -214.137390, 653.332336, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19809, 871.575317, -216.457412, 653.332336, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19903, 880.215759, -220.992401, 652.422119, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19903, 873.505676, -220.992401, 652.422119, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(930, 867.330749, -218.860824, 652.962097, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(930, 867.330749, -219.570846, 652.962097, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(930, 867.330749, -220.270828, 652.962097, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(930, 867.330749, -221.000839, 652.962097, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18687, 880.796325, -222.627868, 653.191162, -33.199996, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18736, 878.241271, -217.581176, 657.831726, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18736, 874.670837, -217.581176, 656.881042, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18736, 868.170288, -217.581176, 657.651550, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18717, 879.872009, -219.177062, 651.421447, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18717, 873.581420, -219.387054, 651.421447, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18717, 873.581420, -210.727035, 651.421447, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18717, 879.861572, -210.317031, 651.421447, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18736, 879.001953, -223.984420, 651.671936, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18736, 874.832031, -223.984420, 651.671936, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 871.453308, -202.886901, 659.542541, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 881.593139, -202.886901, 659.542541, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 866.383178, -204.846908, 659.542541, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 886.393432, -204.846908, 659.542541, 0.000000, 0.000000, 540.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 866.383178, -229.406829, 659.542541, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 886.393432, -229.406829, 659.542541, 0.000000, -0.000007, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 872.083129, -231.846786, 659.542541, 0.000000, 0.000007, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 881.193054, -231.846786, 659.542541, 0.000000, 0.000007, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 872.665771, -245.984008, 652.422119, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 873.256042, -246.554016, 652.422119, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 872.665771, -245.323974, 652.422119, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 872.665771, -244.673965, 652.422119, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 872.665771, -244.024017, 652.422119, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 873.925964, -246.554016, 652.422119, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 874.595886, -246.554016, 652.422119, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 875.265808, -246.554016, 652.422119, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 882.701477, -246.589065, 652.422119, 0.000007, -0.000007, 179.999908, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 883.271484, -245.998794, 652.422119, -0.000007, -0.000007, -89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 882.041442, -246.589065, 652.422119, 0.000007, -0.000007, 179.999908, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 881.391418, -246.589065, 652.422119, 0.000007, -0.000007, 179.999908, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 880.741455, -246.589065, 652.422119, 0.000007, -0.000007, 179.999908, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 883.271484, -245.328872, 652.422119, -0.000007, -0.000007, -89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 883.271484, -244.658950, 652.422119, -0.000007, -0.000007, -89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11729, 883.271484, -243.989028, 652.422119, -0.000007, -0.000007, -89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3576, 881.199523, -237.058380, 653.492187, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2886, 879.616149, -235.918487, 654.262573, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(927, 872.381103, -237.519332, 655.002258, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2886, 872.296081, -238.508468, 654.092529, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(11711, 877.999572, -246.807785, 656.142211, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 913.329162, 31.807327, 684.869873, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3361, 922.229064, 18.118331, 678.727966, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 914.130615, 32.818603, 681.979553, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 912.980651, 32.818603, 681.979553, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3361, 922.229064, 26.308410, 678.727966, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3361, 922.229064, 34.498382, 678.727966, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3361, 904.278564, 32.818389, 678.727966, 0.000000, 179.999984, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3361, 904.278564, 24.638397, 678.727966, 0.000000, 179.999984, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3361, 904.278564, 16.448333, 678.727966, 0.000000, 179.999984, 89.999931, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1893, 909.386108, 22.068725, 686.182006, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1893, 909.386108, 18.508743, 686.182006, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1893, 909.386108, 14.948683, 686.182006, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2649, 915.868041, 10.949539, 680.829650, 360.000000, 270.000000, 720.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1893, 917.716247, 22.068725, 686.182006, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1893, 917.716247, 18.508743, 686.182006, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1893, 917.716247, 14.948683, 686.182006, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2983, 916.433593, 10.935516, 683.019836, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19758, 913.423828, 29.027374, 687.830139, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19758, 913.423828, 5.927412, 687.830139, 0.000000, -0.000014, 179.999908, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18717, 909.467041, 12.832697, 680.775390, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2886, 917.674194, 8.788420, 682.598266, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18735, 912.599060, 23.265199, 681.909423, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2649, 912.238220, 23.419542, 680.829650, 360.000000, 270.000000, 810.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3384, 918.694274, 12.221424, 682.539978, 0.000000, 0.000000, -131.099899, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(929, 909.454040, 13.354207, 681.886901, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1688, 913.252868, 24.516807, 683.623352, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1009, 916.340698, 12.079269, 682.729980, 360.000000, 90.000000, 133.900100, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 913.329162, 2.907332, 684.869873, 0.000000, 0.000000, 450.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 907.184875, 6.078917, 681.609680, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19562, 916.764282, 23.206399, 681.717590, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19562, 916.764282, 23.046396, 681.717590, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19562, 919.005004, 23.206399, 681.717590, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19561, 910.312622, 16.433183, 681.700317, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19561, 910.312622, 16.643184, 681.700317, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19561, 910.312622, 18.773191, 681.700317, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19561, 910.312622, 18.983192, 681.700317, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18646, 914.007873, 23.810781, 682.390136, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19562, 916.764282, 18.266401, 681.717590, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19562, 916.764282, 18.096399, 681.717590, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19562, 916.764282, 20.756404, 681.717590, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19562, 916.764282, 20.586402, 681.717590, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19562, 919.005004, 23.046396, 681.717590, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19562, 919.005004, 18.266401, 681.717590, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19562, 919.005004, 18.096399, 681.717590, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19562, 919.005004, 20.756404, 681.717590, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19562, 919.005004, 20.586402, 681.717590, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19561, 910.312622, 21.393196, 681.700317, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19561, 910.312622, 21.603197, 681.700317, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19561, 908.601989, 16.433183, 681.700317, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19561, 908.601989, 16.643184, 681.700317, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19561, 908.601989, 18.773191, 681.700317, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19561, 908.601989, 18.983192, 681.700317, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19561, 908.601989, 21.393196, 681.700317, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19561, 908.601989, 21.603197, 681.700317, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 902.918945, 6.716917, 681.969604, 89.999992, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 902.918945, 7.606947, 681.969604, 89.999992, 179.999984, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2922, 903.880920, 6.990431, 682.839782, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 902.918945, 8.766890, 681.969604, 89.999992, 179.999984, -89.999969, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 902.918945, 9.656921, 681.969604, 89.999992, 179.999984, -89.999969, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2922, 903.880920, 9.020430, 682.839782, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 902.918945, 10.766830, 681.969604, 89.999992, 180.000000, -89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2372, 902.918945, 11.656860, 681.969604, 89.999992, 180.000000, -89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(2922, 903.880920, 11.020477, 682.839782, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 903.782775, 24.793624, 687.949890, 0.000000, 90.000000, 89.999977, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 903.782775, 11.153578, 687.949890, 0.000000, -89.999984, 90.000007, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 922.823364, 11.153594, 687.949890, -0.000007, 89.999992, -90.000015, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 922.823364, 24.793609, 687.949890, -0.000007, -89.999992, -89.999984, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 915.433471, 10.103407, 688.160156, 89.999992, 89.999992, -89.999969, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 915.433471, 23.773422, 688.160156, 89.999992, 224.901016, -44.901054, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 911.372619, 10.103407, 688.160156, 89.999992, 90.000007, -89.999961, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3675, 911.372619, 23.773422, 688.160156, 89.999992, 244.403289, -64.403327, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 907.184875, 30.498901, 681.609680, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 907.184875, 28.598892, 681.609680, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 907.184875, 29.488891, 683.129821, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 917.325195, 30.278854, 681.609680, 0.000007, -0.000007, 179.999908, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 919.225219, 30.278854, 681.609680, 0.000007, -0.000007, 179.999908, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(1685, 918.335205, 30.278854, 683.129821, 0.000007, -0.000007, 179.999908, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(19903, 917.141479, 13.741789, 680.869689, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(930, 904.256469, 15.873367, 681.409667, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(930, 904.256469, 15.163345, 681.409667, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(930, 904.256469, 14.463362, 681.409667, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(930, 904.256469, 13.733351, 681.409667, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18736, 915.166992, 17.153015, 686.279296, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18736, 911.596557, 17.153015, 685.328613, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18736, 905.096008, 17.153015, 686.099121, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(18736, 915.927673, 10.749771, 680.119506, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 908.379028, 31.847290, 687.990112, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 918.518859, 31.847290, 687.990112, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 903.308898, 29.887283, 687.990112, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 923.319152, 29.887283, 687.990112, 0.000000, 0.000000, 540.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 903.308898, 5.327362, 687.990112, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 923.319152, 5.327362, 687.990112, 0.000000, -0.000007, 179.999954, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 909.008850, 2.887404, 687.990112, 0.000000, 0.000007, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	texture_object = CreateDynamicObjectEx(3785, 918.118774, 2.887404, 687.990112, 0.000000, 0.000007, 90.000000, 300.00, 300.00, { -1 }, { 17 }); 
	return 1 ;
}