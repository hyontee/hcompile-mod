/*

Посадка/ Полив урожая/Сбор урожая. Зп 270 за телегу. 30 секунд за один круг.
Посев/ Полив/ сбор урожая. 
- 10 мест под саженцы  полив сбор саженцев.
- Все действия сделать через команду / Alt 
- Игрок идёт на склад берет семена/лопату
- Лопата отображается на спине.
- Далее метка указывает на место под посадку семян.
- После посадки метка указывается на бочку с водой.
- Родом с бочкой стоит лейка.
- Игрок подбежал на метку с бочкой, набрал воды в руке появляется лейка.
- Далее метка указывает на куст, который посадил данный игрок.
- Полив каждого саженца, указывать меткой.
- После полива появляется растение на месте.
- После поливки в руке появляется коса игрок собирает урожай.
- После сбора растение пропадает.
- Рядом с каждой грядкой стоит телега.
- После того, как урожай собран, в руках появляется телега с зерном в которой с верху лежит лопата.
- Телегу с зерном нужно отвезти на склад.
- После того, как игрок отвёз зерно, на карте появляется метка для посадки семян.

	Object ID bush 3409

*/

#define pick_type_seed_farm			170
#define pick_type_shovel_farm		171
#define pick_type_bucket_farm		172
#define pick_type_farm_startjob		173
#define pick_type_bush_sucess		174
#define price_player_bush			270

enum
{
	d_job_farm = 9000
} ;

static player_farm_progress [ MAX_PLAYERS char ] ;
static player_farm_step [ MAX_PLAYERS char ] ;
new bool: toggled_seed_farm [ MAX_PLAYERS ] ;
new bool: toggled_shovel_farm [ MAX_PLAYERS ] ;
new bool: toggled_bucket_farm [ MAX_PLAYERS ] ;
new bool: startjob_farm [ MAX_PLAYERS ] ;
new is_farm_used [ MAX_PLAYERS char ] ;
new player_farm_bush [ MAX_PLAYERS char ] ;

stock clear_player_farm ( playerid )
{
	toggled_seed_farm [ playerid ] =
	toggled_shovel_farm [ playerid ] =
	toggled_bucket_farm [ playerid ] =
	startjob_farm [ playerid ] = false ;
	
	player_farm_bush { playerid } =
	is_farm_used { playerid } = 0 ;
	return 1 ;
}

#define MAX_BUSH_POSITION 			2
#define MAX_PLANT_POSITION			10
new farm_bush_status [ MAX_BUSH_POSITION ] [ MAX_PLANT_POSITION ] = { 0, ... } ;
new farm_bush_pickup [ MAX_BUSH_POSITION ] [ MAX_PLANT_POSITION ] ;
new farm_bush_object [ MAX_BUSH_POSITION ] [ MAX_PLANT_POSITION ] ;
new Text3D: farm_bush_text [ MAX_BUSH_POSITION ] [ MAX_PLANT_POSITION ] ;
new farm_bush_time [ MAX_BUSH_POSITION ] [ MAX_PLANT_POSITION ] ;

new bool: farm_toggled_bush [ MAX_BUSH_POSITION ] = { false, ... } ;
static Float: farm_bush_position [ MAX_BUSH_POSITION ] [ MAX_PLANT_POSITION ] [ 3 ] =
{
	{
		{ -393.43793, -1388.10132, 23.45503 },
		{ -392.76526, -1380.08069, 23.45503 },
		{ -392.26282, -1373.09924, 23.45503 },
		{ -391.55679, -1364.70129, 23.45503 },
		{ -390.66617, -1357.00623, 23.45503 },
		{ -398.38931, -1356.77454, 23.45503 },
		{ -399.21436, -1364.67468, 23.45503 },
		{ -400.35727, -1372.79236, 23.45503 },
		{ -400.88931, -1380.24719, 23.45503 },
		{ -402.43549, -1388.28955, 23.45503 }
	},
	{
		{ 0.0, 0.0, 0.0 },
		{ 0.0, 0.0, 0.0 },
		{ 0.0, 0.0, 0.0 },
		{ 0.0, 0.0, 0.0 },
		{ 0.0, 0.0, 0.0 },
		{ 0.0, 0.0, 0.0 },
		{ 0.0, 0.0, 0.0 },
		{ 0.0, 0.0, 0.0 },
		{ 0.0, 0.0, 0.0 },
		{ 0.0, 0.0, 0.0 }
	}
} ;

new Float: pick_seed_position [ 3 ] = { -382.44733, -1438.86572, 26.42010 } ;
new pickupid_seed_farm ;

new Float: pick_shovel_position [ 3 ] = { -381.16791, -1428.65771, 26.42010 } ;
new pickupid_shovel_farm ;

new Float: pick_bucket_position [ 3 ] = { -381.51636, -1434.84094, 26.03391 } ;
new pickupid_bucket_farm ;

new Float: pick_farm_startjob_position [ 3 ] = { -372.94250, -1429.64075, 26.03391 } ;
new pickupid_farm_startjob ;

new Float: farm_ambar_position [ 3 ] = { -373.21799, -1421.50696, 26.03391 } ;

stock farm_OnPlayerDisconnect ( playerid )
{
	if ( startjob_farm [ playerid ] == true )
	{
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 2 ) ) RemovePlayerAttachedObject ( playerid, 2 ) ;
		if ( player_farm_bush { playerid } )
		{
			new _bush_id = player_farm_bush { playerid } - 1 ;
			for ( new i = 0 ; i < MAX_PLANT_POSITION ; i ++ )
			{
				if ( IsValidDynamic3DTextLabel ( farm_bush_text [ _bush_id ] [ i ] ) ) DestroyDynamic3DTextLabel ( farm_bush_text [ _bush_id ] [ i ] ) ;
				if ( IsValidDynamicPickup ( farm_bush_pickup [ _bush_id ] [ i ] ) ) DestroyDynamicPickup ( farm_bush_pickup [ _bush_id ] [ i ] ) ;
				if ( IsValidDynamicObject ( farm_bush_object [ _bush_id ] [ i ] ) ) DestroyDynamicObject ( farm_bush_object [ _bush_id ] [ i ] ) ;
				
				farm_bush_status [ _bush_id ] [ i ] =
				farm_bush_time [ _bush_id ] [ i ] = 0 ;
			}
			farm_toggled_bush [ _bush_id ] = false ;
		}
	}
	return 1 ;
}

stock farm_DynamicPickup ( playerid, pickupid )
{
	switch ( pick_info [ pickupid ] [ pick_type ] )
	{
		case pick_type_seed_farm:
		{
			if ( startjob_farm [ playerid ] == false ) return SendClientMessage ( playerid, 0xFF6600FF, !"Сперва начните работу на ферме!" ) ;
			if ( toggled_seed_farm [ playerid ] == true ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже взяли семяна!" ) ;
			
			if ( toggled_shovel_farm [ playerid ] == false ) SendClientMessage ( playerid, 0xFFCC00FF, !"Теперь возьмите лопату!" ) ;
			else
			{
				new bool: _free_place = false ;
				for ( new i = 0 ; i < MAX_BUSH_POSITION ; i ++ )
				{
					if ( farm_toggled_bush [ i ] == true ) continue ;
					
					farm_toggled_bush [ i ] = true ;
					
					player_farm_bush { playerid } = i + 1 ;
					player_farm_progress { playerid } = 0 ;
					player_farm_step { playerid } = 0 ;
					
					SendClientMessage ( playerid, 0xFFCC00FF, !"Отправляйтесь к грядке и начинайте садить семяна." ) ;
					
					new _step_id = player_farm_step { playerid }, _bush_id = player_farm_bush { playerid } - 1 ;
					is_farm_used { playerid } = 1 ;
					SetPlayerRaceCheckpoint ( playerid, 1, farm_bush_position [ _bush_id ] [ _step_id ] [ 0 ],
															farm_bush_position [ _bush_id ] [ _step_id ] [ 1 ],
															farm_bush_position [ _bush_id ] [ _step_id ] [ 2 ],
															0.0, 0.0, 0.0, 2.0 ) ;
															
					_free_place = true ;
					break ;
				}
				if ( _free_place == false ) return SendClientMessage ( playerid, 0xFF6600FF, !"В данный момент нет свободной грядки! Попробуйте придти позже." ) ;
			}
			
			toggled_seed_farm [ playerid ] = true ;
			return 1 ;
		}
		case pick_type_shovel_farm:
		{
			if ( startjob_farm [ playerid ] == false ) return SendClientMessage ( playerid, 0xFF6600FF, !"Сперва начните работу на ферме!" ) ;
			if ( toggled_shovel_farm [ playerid ] == true ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже взяли лопату!" ) ;
			
			if ( toggled_seed_farm [ playerid ] == false ) SendClientMessage ( playerid, 0xFFCC00FF, !"Теперь возьмите семяна!" ) ;
			else
			{
				new bool: _free_place = false ;
				for ( new i = 0 ; i < MAX_BUSH_POSITION ; i ++ )
				{
					if ( farm_toggled_bush [ i ] == true ) continue ;
					
					farm_toggled_bush [ i ] = true ;
					
					player_farm_bush { playerid } = i + 1 ;
					player_farm_progress { playerid } = 0 ;
					player_farm_step { playerid } = 0 ;
					
					SendClientMessage ( playerid, 0xFFCC00FF, !"Отправляйтесь к грядке и начинайте садить семяна." ) ;
					
					new _step_id = player_farm_step { playerid }, _bush_id = player_farm_bush { playerid } - 1 ;
					is_farm_used { playerid } = 1 ;
					SetPlayerRaceCheckpoint ( playerid, 1, farm_bush_position [ _bush_id ] [ _step_id ] [ 0 ],
															farm_bush_position [ _bush_id ] [ _step_id ] [ 1 ],
															farm_bush_position [ _bush_id ] [ _step_id ] [ 2 ],
															0.0, 0.0, 0.0, 2.0 ) ;
															
					_free_place = true ;
					break ;
				}
				if ( _free_place == false ) return SendClientMessage ( playerid, 0xFF6600FF, !"В данный момент нет свободной грядки! Попробуйте придти позже." ) ;
			}
			
			toggled_shovel_farm [ playerid ] = true ;
			return 1 ;
		}
		case pick_type_bucket_farm:
		{
			if ( startjob_farm [ playerid ] == false ) return SendClientMessage ( playerid, 0xFF6600FF, !"Сперва начните работу на ферме!" ) ;
			if ( toggled_bucket_farm [ playerid ] == true ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже взяли лейку!" ) ;
			if ( player_farm_step { playerid } < 10 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы посадили ещё не все растения!" ) ;
			
			SendClientMessage ( playerid, 0xFFCC00FF, !"Отправляйтесь к Вашим грядкам и полейте их." ) ;
			return 1 ;
		}
		case pick_type_bush_sucess:
		{
			if ( startjob_farm [ playerid ] == false ) return SendClientMessage ( playerid, 0xFF6600FF, !"Сперва начните работу на ферме!" ) ;
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 2 ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже взяли телегу!" ) ;

			new _bush_id = player_farm_bush { playerid } - 1 ;
			for ( new i = 0 ; i < MAX_PLANT_POSITION ; i ++ )
			{
				if ( pickupid != farm_bush_pickup [ _bush_id ] [ i ] ) continue ;
				
				DestroyDynamic3DTextLabel ( farm_bush_text [ _bush_id ] [ i ] ) ;
				DestroyDynamicPickup ( farm_bush_pickup [ _bush_id ] [ i ] ) ;
				SendClientMessage ( playerid, 0xFFCC00FF, !"Отвезите телегу на склад." ) ;
				
				is_farm_used { playerid } = 2 ;
				SetPlayerRaceCheckpoint ( playerid, 1, farm_ambar_position [ 0 ], farm_ambar_position [ 1 ], farm_ambar_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
				
				SetPlayerAttachedObject ( playerid, 2, 1458, 1, -1.034844, 1.116571, -0.065124, 76.480148, 75.781570, 280.952545, 0.575599, 0.604554, 0.624122 ) ;
				break ;
			}
		}
		case pick_type_farm_startjob:
		{
			if ( startjob_farm [ playerid ] == false ) show_dialog ( playerid, d_job_farm, DIALOG_STYLE_MSGBOX, "{FFCC00}Работа на ферме", "{ffffff}Вы хотите устроиться на работу фермера?", "Да", "Нет" ) ;
			else show_dialog ( playerid, d_job_farm, DIALOG_STYLE_MSGBOX, "{FFCC00}Работа на ферме", "{ffffff}Вы действительно хотите закончить рабочий день?", "Да", "Нет" ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock farm_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_job_farm:
		{
			if ( ! response ) return 1 ;
			
			if ( startjob_farm [ playerid ] == false )
			{
				new bool: _free_place = false ;
				for ( new i = 0 ; i < MAX_BUSH_POSITION ; i ++ )
				{
					if ( farm_toggled_bush [ i ] == true ) continue ;
					
					_free_place = true ;
					break ;
				}
				if ( _free_place == false ) return SendClientMessage ( playerid, 0xFF6600FF, !"В данный момент нет свободной грядки! Попробуйте придти позже." ) ;
				
				startjob_farm [ playerid ] = true ;
				SendClientMessage ( playerid, 0xFFCC00FF, !"Вы начали рабочий день." ) ;
				SendClientMessage ( playerid, 0xFFCC00FF, !"Отправляйтесь в амбар за семенами и лопатой." ) ;
				
				SetPlayerSkin ( playerid, 34 ) ;
			}
			else
			{
				farm_OnPlayerDisconnect ( playerid ) ;
				clear_player_farm ( playerid ) ;
				
				if ( is_fraction_duty { playerid } == 1 ) SetPlayerColor ( playerid, f_info [ p_info [ playerid ] [ member ] - 1 ] [ f_radar_color ] ), SetPlayerSkin ( playerid, p_info [ playerid ] [ org_skin ] ) ;
				else SetPlayerColor ( playerid, 0xFFFFFF80 ), SetPlayerSkin ( playerid, p_info [ playerid ] [ skin ] ) ;

				startjob_farm [ playerid ] = false ;
				SendClientMessage ( playerid, 0xFFCC00FF, !"Вы закончили рабочий день." ) ;
				
				new __t_string [ 72 ] ;
				format ( __t_string, sizeof ( __t_string ), "Заработано: {99cc00}%d$", p_info [ playerid ] [ salary ] ) ;
				SendClientMessage ( playerid, 0xFFFFFFFF, __t_string ) ;
				
				give_money ( playerid, p_info [ playerid ] [ salary ] ) ;
				p_info [ playerid ] [ salary ] = 0 ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock farm_OnPlayerKeyStateChange ( playerid, newkeys, oldkeys )
{
	#pragma unused oldkeys
	if ( newkeys == KEY_WALK )
	{
		if ( startjob_farm [ playerid ] == true )
		{
			new _bush_id = player_farm_bush { playerid } - 1 ;
			for ( new i = 0 ; i < MAX_PLANT_POSITION ; i ++ )
			{
				if ( farm_bush_status [ _bush_id ] [ i ] == 2 )
				{
					if ( ! IsPlayerInRangeOfPoint ( playerid, 2.0, farm_bush_position [ _bush_id ] [ i ] [ 0 ], farm_bush_position [ _bush_id ] [ i ] [ 1 ], farm_bush_position [ _bush_id ] [ i ] [ 2 ] ) ) continue ;
					
					ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ) ;
					farm_bush_status [ _bush_id ] [ i ] = 1 ;
					
					new text_label [ 53 + 4 ] ;
					format ( text_label, sizeof text_label, "Растение\n\n{"#cWH"}До созревания: {99cc00}%d мин.", farm_bush_time [ _bush_id ] [ i ] ) ;
					UpdateDynamic3DTextLabelText ( farm_bush_text [ _bush_id ] [ i ], 0xFFCC00FF, text_label ) ;
					break ;
				}
				else if ( farm_bush_status [ _bush_id ] [ i ] == 3 )
				{
					if ( ! IsPlayerInRangeOfPoint ( playerid, 2.0, farm_bush_position [ _bush_id ] [ i ] [ 0 ], farm_bush_position [ _bush_id ] [ i ] [ 1 ], farm_bush_position [ _bush_id ] [ i ] [ 2 ] ) ) continue ;
					
					SetTimerEx ( "callback_farm_counter", 5000, false, "iii", playerid, _bush_id, i ) ;
					ApplyAnimation ( playerid, "BASEBALL", "Bat_4", 4.1, 1, 0, 0, 1, 11000 ) ;
					break ;
				}
			}
			return 1 ;
		}
	}
	return 0 ;
}

callback: callback_farm_counter ( playerid, _bush_id, _plant_id )
{
	ClearAnimations ( playerid, 1 ) ;
	
	SetPVarInt ( playerid, "tp_area_used", 1 ) ;
	
	farm_bush_status [ _bush_id ] [ _plant_id ] = 0 ;
	DestroyDynamicObject ( farm_bush_object [ _bush_id ] [ _plant_id ] ) ;
	UpdateDynamic3DTextLabelText ( farm_bush_text [ _bush_id ] [ _plant_id ], 0xFFCC00FF, !"Можно собирать" ) ;
	farm_bush_pickup [ _bush_id ] [ _plant_id ] = CreateDynamicPickup ( 1318, 23, farm_bush_position [ _bush_id ] [ _plant_id ] [ 0 ], farm_bush_position [ _bush_id ] [ _plant_id ] [ 1 ], farm_bush_position [ _bush_id ] [ _plant_id ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ farm_bush_pickup [ _bush_id ] [ _plant_id ] ] [ pick_type ] = pick_type_bush_sucess ;
	return 1 ;
}

stock farm_RaceCheckpoint ( playerid )
{
	if ( is_farm_used { playerid } == 1 )
	{
		SetTimerEx ( "callback_farm_shovel", 5000, false, "d", playerid ) ;
		ApplyAnimation(playerid, "CHAINSAW", "CSAW_G", 4.1, 1, 0, 0, 0, 0);
		DisablePlayerRaceCheckpoint ( playerid ) ;
		is_farm_used { playerid } = 0 ;
		return 1 ;
	}
	else if ( is_farm_used { playerid } == 2 )
	{
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 2 ) ) RemovePlayerAttachedObject ( playerid, 2 ) ;
		
		SendClientMessage ( playerid, 0xFFCC00FF, !"Телега доставлена на склад." ) ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		is_farm_used { playerid } = 0 ;
		
		p_info [ playerid ] [ salary ] += price_player_bush ;
		
		new t_string [ 46 ] ;
		format ( t_string, sizeof t_string, "~n~~n~~n~~n~~n~~n~~n~~n~~g~ +%d$", price_player_bush ) ;
		GameTextForPlayer ( playerid, t_string, 3000, 3 ) ;
		
		player_farm_step { playerid } -- ;
		if ( player_farm_step { playerid } <= 0 )
		{
			SendClientMessage ( playerid, 0xFFCC00FF, !"Приступайте к посадке новой партии." ) ;
			
			new _step_id = player_farm_step { playerid }, _bush_id = player_farm_bush { playerid } - 1 ;
			is_farm_used { playerid } = 1 ;
			SetPlayerRaceCheckpoint ( playerid, 1, farm_bush_position [ _bush_id ] [ _step_id ] [ 0 ],
													farm_bush_position [ _bush_id ] [ _step_id ] [ 1 ],
													farm_bush_position [ _bush_id ] [ _step_id ] [ 2 ],
													0.0, 0.0, 0.0, 2.0 ) ;
		}
		return 1 ;
	}
	else if ( is_farm_used { playerid } == 3 )
	{
		DisablePlayerRaceCheckpoint ( playerid ) ;
		is_farm_used { playerid } = 0 ;
		return 1 ;
	}
	return 0 ;
}

stock farm_minute_timer ( )
{
	new text_label [ 53 + 4 ] ;
	for ( new i = 0 ; i < MAX_BUSH_POSITION ; i ++ )
	{
		if ( farm_toggled_bush [ i ] == false ) continue ;
		
		for ( new b = 0 ; b < MAX_PLANT_POSITION ; b ++ )
		{
			if ( farm_bush_status [ i ] [ b ] != 1 ) continue ;
			
			farm_bush_time [ i ] [ b ] -- ;
			if ( farm_bush_time [ i ] [ b ] == 0 )
			{
				farm_bush_status [ i ] [ b ] = 3 ;
				UpdateDynamic3DTextLabelText ( farm_bush_text [ i ] [ b ], 0xFFCC00FF, !"Можно косить\n\n{"#cGR"}Используйте {"#cWH"}ALT {"#cGR"}для взаимодействия" ) ;
			}
			else if ( farm_bush_time [ i ] [ b ] == 2 )
			{
				UpdateDynamic3DTextLabelText ( farm_bush_text [ i ] [ b ], 0xFFCC00FF, !"Растение\n\n{99cc00}Требуется полив\n\n{"#cGR"}Используйте {"#cWH"}ALT {"#cGR"}для взаимодействия" ) ;
				farm_bush_status [ i ] [ b ] = 2 ;
			}
			else
			{
				format ( text_label, sizeof text_label, "Растение\n\n{"#cWH"}До созревания: {99cc00}%d мин.", farm_bush_time [ i ] [ b ] ) ;
				UpdateDynamic3DTextLabelText ( farm_bush_text [ i ] [ b ], 0xFFCC00FF, text_label ) ;
				
				DestroyDynamicObject ( farm_bush_object [ i ] [ b ] ) ;
				farm_bush_object [ i ] [ b ] = CreateDynamicObject ( 3409, farm_bush_position [ i ] [ b ] [ 0 ], farm_bush_position [ i ] [ b ] [ 1 ], farm_bush_position [ i ] [ b ] [ 2 ] - ( farm_bush_time [ i ] [ b ] * 2 ), 0.0, 0.0, 0.0 ) ;
			}
		}
	}
	return 1 ;
}

callback: callback_farm_shovel ( playerid )
{
	ClearAnimations ( playerid, 1 ) ;
	
	new _step_id = player_farm_step { playerid }, _bush_id = player_farm_bush { playerid } - 1 ;
	farm_bush_status [ _bush_id ] [ _step_id ] = 1 ;
	farm_bush_time [ _bush_id ] [ _step_id ] = 3 ;
	farm_bush_object [ _bush_id ] [ _step_id ] = CreateDynamicObject ( 3409, farm_bush_position [ _bush_id ] [ _step_id ] [ 0 ], farm_bush_position [ _bush_id ] [ _step_id ] [ 1 ], farm_bush_position [ _bush_id ] [ _step_id ] [ 2 ] - 6, 0.0, 0.0, 0.0 ) ;
	farm_bush_text [ _bush_id ] [ _step_id ] = CreateDynamic3DTextLabel ( !"Растение\n\n{"#cWH"}До созревания: {99cc00}3 мин.", 0xFFCC00FF, farm_bush_position [ _bush_id ] [ _step_id ] [ 0 ], farm_bush_position [ _bush_id ] [ _step_id ] [ 1 ], farm_bush_position [ _bush_id ] [ _step_id ] [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	
	player_farm_step { playerid } ++ ;
	if ( player_farm_step { playerid } >= MAX_PLANT_POSITION )
	{
		SendClientMessage ( playerid, 0xFFCC00FF, !"Нужно полить саженцы! Возьмите лейку, она у бочки." ) ;
		
		is_farm_used { playerid } = 3 ;
		SetPlayerRaceCheckpoint ( playerid, 1, pick_bucket_position [ 0 ], pick_bucket_position [ 1 ], pick_bucket_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	
	SendClientMessage ( playerid, 0xFFCC00FF, !"Переходите к следующему месту посадки." ) ;
	
	_step_id = player_farm_step { playerid } ;
	is_farm_used { playerid } = 1 ;
	SetPlayerRaceCheckpoint ( playerid, 1, farm_bush_position [ _bush_id ] [ _step_id ] [ 0 ],
											farm_bush_position [ _bush_id ] [ _step_id ] [ 1 ],
											farm_bush_position [ _bush_id ] [ _step_id ] [ 2 ],
											0.0, 0.0, 0.0, 2.0 ) ;
	return 1 ;
}

stock farm_OnGameModeInit ( )
{
	CreateDynamic3DTextLabel ( "Семяна", 0xFFCC00FF, pick_seed_position [ 0 ], pick_seed_position [ 1 ], pick_seed_position [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	pickupid_seed_farm = CreateDynamicPickup ( 1239, 23, pick_seed_position [ 0 ], pick_seed_position [ 1 ], pick_seed_position [ 2 ], 0, 0, -1 ) ;
	pick_info [ pickupid_seed_farm ] [ pick_type ] = pick_type_seed_farm ;
	
	CreateDynamic3DTextLabel ( "Лопата", 0xFFCC00FF, pick_shovel_position [ 0 ], pick_shovel_position [ 1 ], pick_shovel_position [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	pickupid_shovel_farm = CreateDynamicPickup ( 1239, 23, pick_shovel_position [ 0 ], pick_shovel_position [ 1 ], pick_shovel_position [ 2 ], 0, 0, -1 ) ;
	pick_info [ pickupid_shovel_farm ] [ pick_type ] = pick_type_shovel_farm ;
	
	CreateDynamic3DTextLabel ( "Лейка", 0xFFCC00FF, pick_bucket_position [ 0 ], pick_bucket_position [ 1 ], pick_bucket_position [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	pickupid_bucket_farm = CreateDynamicPickup ( 1239, 23, pick_bucket_position [ 0 ], pick_bucket_position [ 1 ], pick_bucket_position [ 2 ], 0, 0, -1 ) ;
	pick_info [ pickupid_bucket_farm ] [ pick_type ] = pick_type_bucket_farm ;
	
	pickupid_farm_startjob = CreateDynamicPickup ( 1275, 23, pick_farm_startjob_position [ 0 ], pick_farm_startjob_position [ 1 ], pick_farm_startjob_position [ 2 ], 0, 0, -1 ) ;
	pick_info [ pickupid_farm_startjob ] [ pick_type ] = pick_type_farm_startjob ;
	return 1 ;
}