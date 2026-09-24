/*

	Склады
			
*/

#define truck_percent 		100
#define truck_percent_txt 	"100"

#define TRUCK_SPECIAL_PRICE	250000

#define DORM_SAWMILL 	0
#define DORM_MINE	 	1
#define DORM_FACTORY	2

#define DORM_FACTORY_MINE	2
#define DORM_FACTORY_WOOD	3
#define DORM_FACTORY_GUNS	4

new Text3D: dorm_text [ 3 ] ;
new dorm_count [ 5 ] ;

new dorm_queue [ 3 ] [ 10 ] ;
new Text3D: text_dorm_queue [ 3 ] ;

new mineral_area ;
new factory_unloading_area ;
new port_unloading_area ;

new loading_area [ 3 ] ;
new loading_free_area [ 3 ] ;
new loading_playerid [ 3 ] ;

new loading_cd [ 3 ] ;

new loading_timer [ 3 ] ;
new Text3D: loading_text [ 3 ] ;


#define MINE_UNMELTED	0
#define MINE_MELTED		1

new Text3D: mine_text ;
new mine_count [ 2 ] ;

new trailer_count [ MAX_VEHICLES ] ;
new trailer_type [ MAX_VEHICLES ] ;

new PlayerText:td_db [ MAX_PLAYERS ] [ 4 ] ;
new player_tload_time [ MAX_PLAYERS ] ;
new player_leavearea_time [ MAX_PLAYERS ] ;

new Float: load_truck_zone [ 3 ] [ 3 ] =
{
	{ -1420.8485, 2578.8630, 40.3924 },
	{ -1050.1656, -2469.5339, 28.5210 },
	{ 2321.8076, 2083.8566, 15.9863 }
} ;

new Float: unload_truck_zone [ 3 ] [ 3 ] =
{
	{ 2303.3645, 2005.3925, 15.9863 },
	{ -2548.4426, 707.0451, 9.3131 },
	{ 2559.1655, -2074.5640, 21.9604 }
} ;

stock trucker_OnGameModeInit ( )
{
	new dorm_string [ 238 ] ;
	format ( dorm_string, sizeof ( dorm_string ), "** Состояние склада **\n{"#cGR3D"}Заготовки:{"#cWH"} %i / 1.000.000\n{"#cGR3D"}Металл:{"#cWH"} %i / 1.000.000\n{"#cGR3D"}Древесина:{"#cWH"} %i / 1.000.000",
													dorm_count [ DORM_FACTORY_GUNS ],
													dorm_count [ DORM_FACTORY_MINE ],
													dorm_count [ DORM_FACTORY_WOOD ] ) ;

	dorm_text [ DORM_FACTORY ] = CreateDynamic3DTextLabel( dorm_string, col_blue, 2320.9733, 2023.7401, 15.9863, 38.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;

	format ( dorm_string, 134, "** Переплавка **\n{"#cGR3D"}Руда: {"#cWH"}%d кг.\n{"#cGR3D"}Металл: {"#cWH"}%d кг.", mine_count [ MINE_UNMELTED ], mine_count [ MINE_MELTED ] ) ;
	mine_text = CreateDynamic3DTextLabel( dorm_string, col_blue, 589.9409,870.0306,-42.4973, 28.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;

	format ( dorm_string, 76, "** Древесина **\n{"#cGR3D"}Кол-во на складе:{"#cWH"} %i кг.", dorm_count [ DORM_SAWMILL ] ) ;
	dorm_text [ DORM_SAWMILL ] = CreateDynamic3DTextLabel( dorm_string, col_blue, -1053.8264, -2472.8720, 28.5139, 38.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;

	format ( dorm_string, 76, "** Металл **\n{"#cGR3D"}Кол-во на складе:{"#cWH"} %i кг.", dorm_count [ DORM_MINE ] ) ;
	dorm_text [ DORM_MINE ] = CreateDynamic3DTextLabel( dorm_string, col_blue, -1437.8201, 2530.8896, 40.6190, 38.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;

	loading_area [ DORM_MINE ] = CreateDynamicSphere ( load_truck_zone [ 0 ] [ 0 ], load_truck_zone [ 0 ] [ 1 ], load_truck_zone [ 0 ] [ 2 ], 10.0, -1, -1 ) ;
	area_info [ loading_area [ DORM_MINE ] ] [ a_type ] = area_type_load_trucker ;
	
	loading_area [ DORM_SAWMILL ] = CreateDynamicSphere ( load_truck_zone [ 1 ] [ 0 ], load_truck_zone [ 1 ] [ 1 ], load_truck_zone [ 1 ] [ 2 ], 10.0, -1, -1 ) ;
	area_info [ loading_area [ DORM_SAWMILL ] ] [ a_type ] = area_type_load_trucker ;
	
	loading_area [ DORM_FACTORY ] = CreateDynamicSphere ( load_truck_zone [ 2 ] [ 0 ], load_truck_zone [ 2 ] [ 1 ], load_truck_zone [ 2 ] [ 2 ], 10.0, -1, -1 ) ;
	area_info [ loading_area [ DORM_FACTORY ] ] [ a_type ] = area_type_load_trucker ;
	
	factory_unloading_area = CreateDynamicSphere ( unload_truck_zone [ 0 ] [ 0 ], unload_truck_zone [ 0 ] [ 1 ], unload_truck_zone [ 0 ] [ 2 ], 10.0, -1, -1 ) ;
	area_info [ factory_unloading_area ] [ a_type ] = area_type_unload_factory ;
	
	CreateDynamic3DTextLabel( "** Зона разгрузки **\n{"#cWH"}Заготовки", col_blue, unload_truck_zone [ 1 ] [ 0 ], unload_truck_zone [ 1 ] [ 1 ], unload_truck_zone [ 1 ] [ 2 ], 38.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
	port_unloading_area = CreateDynamicSphere ( unload_truck_zone [ 1 ] [ 0 ], unload_truck_zone [ 1 ] [ 1 ], unload_truck_zone [ 1 ] [ 2 ], 7.5, -1, -1 ) ;
	area_info [ port_unloading_area ] [ a_type ] = area_type_unload_port ;
	
	loading_free_area [ DORM_MINE ] = CreateDynamicSphere ( -1435.4709, 2605.2507, 40.3924, 15.0, -1, -1 ) ;
	area_info [ loading_free_area [ DORM_MINE ] ] [ a_type ] = area_type_loading_free ;
	
	loading_free_area [ DORM_SAWMILL ] = CreateDynamicSphere ( -1065.8334, -2467.3632, 28.4188, 15.0, -1, -1 ) ;
	area_info [ loading_free_area [ DORM_SAWMILL ] ] [ a_type ] = area_type_loading_free ;

	loading_free_area [ DORM_FACTORY ] = CreateDynamicSphere ( 2327.8312, 2103.5427, 15.9863, 15.0, -1, -1 ) ;
	area_info [ loading_free_area [ DORM_FACTORY ] ] [ a_type ] = area_type_loading_free ;
	
	CreateDynamic3DTextLabel( "** Зона разгрузки **\n{"#cWH"}Металл", col_blue, unload_truck_zone [ 2 ] [ 0 ], unload_truck_zone [ 2 ] [ 1 ], unload_truck_zone [ 2 ] [ 2 ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0 ) ;
	mineral_area = CreateDynamicSphere ( unload_truck_zone [ 2 ] [ 0 ], unload_truck_zone [ 2 ] [ 1 ], unload_truck_zone [ 2 ] [ 2 ], 15.0, -1, -1 ) ;
	area_info [ mineral_area ] [ a_type ] = area_type_unload_mineral ;
	
	CreateDynamicCP ( unload_truck_zone [ 2 ] [ 0 ], unload_truck_zone [ 2 ] [ 1 ], unload_truck_zone [ 2 ] [ 2 ], 1.0, -1, -1, -1 ) ;
	
	for ( new i ; i < 10 ; i ++ )
	{
		dorm_queue [ DORM_FACTORY ] [ i ] = INVALID_PLAYER_ID ;
		dorm_queue [ DORM_SAWMILL ] [ i ] = INVALID_PLAYER_ID ;
		dorm_queue [ DORM_MINE ] [ i ] = INVALID_PLAYER_ID ;
	}

	text_dorm_queue [ DORM_MINE ] = CreateDynamic3DTextLabel( "** Очередь на загрузку **", col_blue, load_truck_zone [ 0 ] [ 0 ], load_truck_zone [ 0 ] [ 1 ], load_truck_zone [ 0 ] [ 2 ], 38.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
	text_dorm_queue [ DORM_SAWMILL ] = CreateDynamic3DTextLabel( "** Очередь на загрузку **", col_blue, load_truck_zone [ 1 ] [ 0 ], load_truck_zone [ 1 ] [ 1 ], load_truck_zone [ 1 ] [ 2 ], 38.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
	text_dorm_queue [ DORM_FACTORY ] = CreateDynamic3DTextLabel( "** Очередь на загрузку **", col_blue, load_truck_zone [ 2 ] [ 0 ], load_truck_zone [ 2 ] [ 1 ], load_truck_zone [ 2 ] [ 2 ], 38.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;

	for ( new i = 0 ; i < 3 ; i ++ )
	{
		loading_playerid [ i ] = INVALID_PLAYER_ID ;
	}
	return 1 ;
}

stock trucker_minute_timer ( )
{
	if ( mine_count [ MINE_UNMELTED ] >= 30 )
	{
		mine_count [ MINE_UNMELTED ] -= 30 ;
		mine_count [ MINE_MELTED ] += 30 ;

		dorm_count [ DORM_MINE ] = mine_count [ MINE_MELTED ] ;

		new dorm_string [ 134 ] ;
		format ( dorm_string, 76, "** Металл **\n{"#cGR"}Кол-во на складе:{"#cWH"} %i кг.", dorm_count [ DORM_MINE ] ) ;
		UpdateDynamic3DTextLabelText ( dorm_text [ DORM_MINE ], col_blue, dorm_string ) ;

		format ( dorm_string, 134, "** Переплавка **\n{"#cGR"}Руда: {"#cWH"}%d кг.\n{"#cGR"}Металл: {"#cWH"}%d кг.", mine_count [ MINE_UNMELTED ], mine_count [ MINE_MELTED ] ) ;
		UpdateDynamic3DTextLabelText ( mine_text, col_blue, dorm_string ) ;
	}
	return 1 ;
}

stock trucker_second_timer ( )
{
	new _str [ 20 + ( MAX_PLAYER_NAME + 20 ) * 10 + 30 ] ;
	strcat ( _str, "** Очередь на загрузку **\n" ) ;
	for ( new i ; i < 10 ; i ++ )
	{
		if ( dorm_queue [ DORM_MINE ] [ i ] != INVALID_PLAYER_ID && !IsPlayerConnected(dorm_queue [ DORM_MINE ] [ i ]) || (dorm_queue [ DORM_MINE ] [ i ] != INVALID_PLAYER_ID &&!GetPVarInt(dorm_queue [ DORM_MINE ] [ i ], "truck_waiting"))) dorm_queue [ DORM_MINE ] [ i ] = INVALID_PLAYER_ID;
		if(i != 9 && dorm_queue [ DORM_MINE ] [ i ] == INVALID_PLAYER_ID && dorm_queue [ DORM_MINE ] [ i + 1 ] != INVALID_PLAYER_ID )
		{
			dorm_queue [ DORM_MINE ] [ i ] = dorm_queue [ DORM_MINE ] [ i + 1 ] ;
			dorm_queue [ DORM_MINE ] [ i + 1 ] = INVALID_PLAYER_ID ;
		}
		if(dorm_queue [ DORM_MINE ] [ i ] != INVALID_PLAYER_ID) format ( _str, sizeof ( _str ), "%s\n{"#cGR3D"}%i.{"#cWH"} %s", _str, i + 1, p_info [dorm_queue [ DORM_MINE ] [ i ]] [ name ] ) ;
	}
	UpdateDynamic3DTextLabelText( text_dorm_queue [ DORM_MINE ], col_blue, _str ) ;
	
	_str [ 0 ] = EOS ;
	strcat ( _str,"** Очередь на загрузку **\n" ) ;
	for ( new i ; i < 10 ; i ++ )
	{
		if ( dorm_queue [ DORM_SAWMILL ] [ i ] != INVALID_PLAYER_ID && !IsPlayerConnected(dorm_queue [ DORM_SAWMILL ] [ i ]) || (dorm_queue [ DORM_SAWMILL ] [ i ] != INVALID_PLAYER_ID &&!GetPVarInt(dorm_queue [ DORM_SAWMILL ] [ i ], "truck_waiting"))) dorm_queue [ DORM_SAWMILL ] [ i ] = INVALID_PLAYER_ID;
		if ( i != 9 && dorm_queue [ DORM_SAWMILL ] [ i ] == INVALID_PLAYER_ID && dorm_queue [ DORM_SAWMILL ] [ i + 1 ] != INVALID_PLAYER_ID )
		{
			dorm_queue [ DORM_SAWMILL ] [ i ] = dorm_queue [ DORM_SAWMILL ] [ i + 1 ] ;
			dorm_queue [ DORM_SAWMILL ] [ i + 1 ] = INVALID_PLAYER_ID ;
		}
		if ( dorm_queue [ DORM_SAWMILL ] [ i ] != INVALID_PLAYER_ID) format ( _str, sizeof ( _str ), "%s\n{"#cGR3D"}%i.{"#cWH"} %s", _str, i + 1, p_info [dorm_queue [ DORM_SAWMILL ] [ i ]] [ name ] ) ;
	}
	UpdateDynamic3DTextLabelText( text_dorm_queue [ DORM_SAWMILL ], col_blue, _str ) ;
	
	_str [ 0 ] = EOS ;
	strcat ( _str, "** Очередь на загрузку **\n" ) ;
	for ( new i ; i < 10 ; i ++ )
	{
		if ( dorm_queue [ DORM_FACTORY ] [ i ] != INVALID_PLAYER_ID && !IsPlayerConnected(dorm_queue [ DORM_FACTORY ] [ i ]) || (dorm_queue [ DORM_FACTORY ] [ i ] != INVALID_PLAYER_ID &&!GetPVarInt(dorm_queue [ DORM_FACTORY ] [ i ], "truck_waiting"))) dorm_queue [ DORM_FACTORY ] [ i ] = INVALID_PLAYER_ID;
		if(i != 9 && dorm_queue [ DORM_FACTORY ] [ i ] == INVALID_PLAYER_ID && dorm_queue [ DORM_FACTORY ] [ i + 1 ] != INVALID_PLAYER_ID )
		{
			dorm_queue [ DORM_FACTORY ] [ i ] = dorm_queue [ DORM_FACTORY ] [ i + 1 ] ;
			dorm_queue [ DORM_FACTORY ] [ i + 1 ] = INVALID_PLAYER_ID ;
		}
		if(dorm_queue [ DORM_FACTORY ] [ i ] != INVALID_PLAYER_ID) format ( _str, sizeof ( _str ), "%s\n{"#cGR3D"}%i.{"#cWH"} %s", _str, i + 1, p_info [dorm_queue [ DORM_FACTORY ] [ i ]] [ name ] ) ;
	}
	UpdateDynamic3DTextLabelText( text_dorm_queue [ DORM_FACTORY ], col_blue, _str ) ;


	loading_cd [ DORM_MINE ] += 1 ;
	if ( loading_cd [ DORM_MINE ] == 125 )loading_playerid [ DORM_MINE ] = INVALID_PLAYER_ID ;
	if ( loading_playerid [ DORM_MINE ] == INVALID_PLAYER_ID && dorm_queue [ DORM_MINE ] [ 0 ] != INVALID_PLAYER_ID )
	{
		loading_playerid [ DORM_MINE ] = dorm_queue [ DORM_MINE ] [ 0 ] ;
		loading_cd [ DORM_MINE ] = 0 ;
		SendClientMessage ( dorm_queue [ DORM_MINE ] [ 0 ], col_gray, "* Ваша фура загружена. У вас есть 2 минуты, чтобы прицепить её." ) ;
		SendClientMessage ( dorm_queue [ DORM_MINE ] [ 0 ], col_gray, "* Если вы не успеете, деньги не будут возвращены." ) ;
		new _traile_id = CreateVehicle ( 450, -1435.4709, 2605.2507, 40.3924, 315.7739, 1, 1, -1 ) ;
		player_trailer [ dorm_queue [ DORM_MINE ] [ 0 ] ] = _traile_id ;

		trailer_type [ _traile_id - 1 ] = DORM_MINE ;
		trailer_count [ _traile_id - 1 ] = GetPVarInt ( dorm_queue [ DORM_MINE ] [ 0 ], "truck_count" ) ;

		player_tload_time [ dorm_queue [ DORM_MINE ] [ 0 ] ] = 120 ;
		create_trucker_td ( dorm_queue [ DORM_MINE ] [ 0 ], _traile_id ) ;

		DeletePVar ( dorm_queue [ DORM_MINE ] [ 0 ], "truck_count" ) ;
	}
	
	loading_cd [ DORM_FACTORY ] += 1 ;
	if ( loading_cd [ DORM_FACTORY ] == 125 )loading_playerid [ DORM_FACTORY ] = INVALID_PLAYER_ID ;
	if ( loading_playerid [ DORM_FACTORY ] == INVALID_PLAYER_ID && dorm_queue [ DORM_FACTORY ] [ 0 ] != INVALID_PLAYER_ID )
	{
		loading_playerid [ DORM_FACTORY ] = dorm_queue [ DORM_FACTORY ] [ 0 ] ;
		loading_cd [ DORM_FACTORY ] = 0 ;
		SendClientMessage ( dorm_queue [ DORM_FACTORY ] [ 0 ], col_gray, !"* Ваша фура загружена. У вас есть 2 минуты, чтобы прицепить её." ) ;
		SendClientMessage ( dorm_queue [ DORM_FACTORY ] [ 0 ], col_gray, !"* Если вы не успеете, деньги не будут возвращены." ) ;
		new _traile_id = CreateVehicle ( 450, 2327.8312, 2103.5427, 15.9863, 263.7461, 1, 1, -1 ) ;
		player_trailer [ dorm_queue [ DORM_FACTORY ] [ 0 ] ] = _traile_id ;

		trailer_type [ _traile_id - 1 ] = DORM_FACTORY ;
		trailer_count [ _traile_id - 1 ] = GetPVarInt ( dorm_queue [ DORM_FACTORY ] [ 0 ], "truck_count" ) ;

		player_tload_time [ dorm_queue [ DORM_FACTORY ] [ 0 ] ] = 120 ;
		create_trucker_td ( dorm_queue [ DORM_FACTORY ] [ 0 ], _traile_id ) ;

		DeletePVar ( dorm_queue [ DORM_FACTORY ] [ 0 ], "truck_count" ) ;
	}
	
	loading_cd [ DORM_SAWMILL ] += 1 ;
	if ( loading_cd [ DORM_SAWMILL ] == 125 )loading_playerid [ DORM_SAWMILL ] = INVALID_PLAYER_ID ;
	if ( loading_playerid [ DORM_SAWMILL ] == INVALID_PLAYER_ID && dorm_queue [ DORM_SAWMILL ] [ 0 ] != INVALID_PLAYER_ID )
	{
		loading_playerid [ DORM_SAWMILL ] = dorm_queue [ DORM_SAWMILL ] [ 0 ] ;
		loading_cd [ DORM_SAWMILL ] = 0 ;
		SendClientMessage ( dorm_queue [ DORM_SAWMILL ] [ 0 ], col_gray, !"* Ваша фура загружена. У вас есть 2 минуты, чтобы прицепить её." ) ;
		SendClientMessage ( dorm_queue [ DORM_SAWMILL ] [ 0 ], col_gray, !"* Если вы не успеете, деньги не будут возвращены." ) ;
		new _traile_id = CreateVehicle ( 450, -1065.8334, -2467.3632, 28.4188, 284.1051, 1, 1, -1 ) ;
		player_trailer [ dorm_queue [ DORM_SAWMILL ] [ 0 ] ] = _traile_id ;
		trailer_type [ _traile_id - 1 ] = DORM_SAWMILL ;
		trailer_count [ _traile_id - 1 ] = GetPVarInt ( dorm_queue [ DORM_SAWMILL ] [ 0 ], "truck_count" ) ;

		player_tload_time [ dorm_queue [ DORM_SAWMILL ] [ 0 ] ] = 120 ;
		create_trucker_td ( dorm_queue [ DORM_SAWMILL ] [ 0 ], _traile_id ) ;

		DeletePVar ( dorm_queue [ DORM_SAWMILL ] [ 0 ], "truck_count" ) ;
	}
	return 1 ;
}

stock clear_player_trucker ( playerid )
{
	for ( new j = 0 ; j < 4 ; j ++ )
	{			
		td_db [ playerid ] [ j ] = PlayerText:-1 ;
	}
	
	player_trailer [ playerid ] = INVALID_VEHICLE_ID ;
	
	player_tload_time [ playerid ] =
	player_leavearea_time [ playerid ] = -1 ;
					
	p_t_info [ playerid ] [ truck_special ] = -1 ;
	return 1 ;
}

stock trucker_OnPlayerDisconnect ( playerid )
{
	if ( player_trailer [ playerid ] != INVALID_VEHICLE_ID )
	{
		for ( new j = 0 ; j < 3 ; j ++ )
		{
			if ( dorm_queue [ j ] [ 0 ] == playerid )
			{
				dorm_queue [ j ] [ 0 ] = INVALID_PLAYER_ID ;
			}	
		}
		for ( new j = 0 ; j < 4 ; j ++ )
		{			
			PlayerTextDrawDestroy ( playerid, td_db [ playerid ] [ j ] ) ;
			td_db [ playerid ] [ j ] = PlayerText:-1 ;
		}
		new _v_id = player_trailer [ playerid ] ;
		trailer_count [ _v_id - 1 ] = 0 ;
		trailer_type [ _v_id - 1 ] = -1 ;
		DestroyVehicle ( _v_id, 678 ) ;
	}
	return 1 ;
}

stock trucker_OnPlayerDeath ( playerid )
{
	if ( td_db [ playerid ] [ 1 ] != PlayerText:-1 )
	{
		for ( new j = 0 ; j < 4 ; j ++ )
		{			
			PlayerTextDrawDestroy ( playerid, td_db [ playerid ] [ j ] ) ;
			td_db [ playerid ] [ j ] = PlayerText:-1 ;
		}
	}
	return 1 ;
}

stock create_trucker_td ( playerid, vehicleid )
{
	td_db [ playerid ] [ 0 ] = CreatePlayerTextDraw(playerid, 543.000000, 182.000000, "~r~2:00" ) ;
	PlayerTextDrawBackgroundColor(playerid, td_db [ playerid ] [ 0 ], 255 ) ;
	PlayerTextDrawFont(playerid, td_db [ playerid ] [ 0 ], 2 ) ;
	PlayerTextDrawLetterSize(playerid, td_db [ playerid ] [ 0 ], 0.319999, 1.500000 ) ;
	PlayerTextDrawColor(playerid, td_db [ playerid ] [ 0 ], -1 ) ;
	PlayerTextDrawSetOutline(playerid, td_db [ playerid ] [ 0 ], 0 ) ;
	PlayerTextDrawSetProportional(playerid, td_db [ playerid ] [ 0 ], 1 ) ;
	PlayerTextDrawSetShadow(playerid, td_db [ playerid ] [ 0 ], 1 ) ;
	PlayerTextDrawSetSelectable(playerid, td_db [ playerid ] [ 0 ], 0 ) ;

	td_db [ playerid ] [ 1 ] = CreatePlayerTextDraw(playerid, 486.000000, 116.000000, "truck_img" ) ;
	PlayerTextDrawBackgroundColor(playerid, td_db [ playerid ] [ 1 ], 0 ) ;
	PlayerTextDrawFont(playerid, td_db [ playerid ] [ 1 ], 5 ) ;
	PlayerTextDrawLetterSize(playerid, td_db [ playerid ] [ 1 ], 0.500000, 1.000000 ) ;
	PlayerTextDrawColor(playerid, td_db [ playerid ] [ 1 ], -1 ) ;
	PlayerTextDrawSetOutline(playerid, td_db [ playerid ] [ 1 ], 0 ) ;
	PlayerTextDrawSetProportional(playerid, td_db [ playerid ] [ 1 ], 1 ) ;
	PlayerTextDrawSetShadow(playerid, td_db [ playerid ] [ 1 ], 1 ) ;
	PlayerTextDrawUseBox(playerid, td_db [ playerid ] [ 1 ], 0 ) ;
	PlayerTextDrawBoxColor(playerid, td_db [ playerid ] [ 1 ], 255 ) ;
	PlayerTextDrawTextSize(playerid, td_db [ playerid ] [ 1 ], 70.000000, 106.000000 ) ;
	PlayerTextDrawSetPreviewModel(playerid, td_db [ playerid ] [ 1 ], GetVehicleModel ( GetPlayerVehicleID ( playerid ) ) ) ;
	PlayerTextDrawSetPreviewRot(playerid, td_db [ playerid ] [ 1 ], 0.000000, 0.000000, -90.000000, 1.000000 ) ;
	PlayerTextDrawSetSelectable(playerid, td_db [ playerid ] [ 1 ], 0 ) ;

	td_db [ playerid ] [ 2 ] = CreatePlayerTextDraw(playerid, 534.000000, 111.000000, "trailer_img" ) ;
	PlayerTextDrawBackgroundColor(playerid, td_db [ playerid ] [ 2 ], 0 ) ;
	PlayerTextDrawFont(playerid, td_db [ playerid ] [ 2 ], 5 ) ;
	PlayerTextDrawLetterSize(playerid, td_db [ playerid ] [ 2 ], 0.500000, 1.000000 ) ;
	PlayerTextDrawColor(playerid, td_db [ playerid ] [ 2 ], -1 ) ;
	PlayerTextDrawSetOutline(playerid, td_db [ playerid ] [ 2 ], 0 ) ;
	PlayerTextDrawSetProportional(playerid, td_db [ playerid ] [ 2 ], 1 ) ;
	PlayerTextDrawSetShadow(playerid, td_db [ playerid ] [ 2 ], 1 ) ;
	PlayerTextDrawUseBox(playerid, td_db [ playerid ] [ 2 ], 0 ) ;
	PlayerTextDrawBoxColor(playerid, td_db [ playerid ] [ 2 ], 255 ) ;
	PlayerTextDrawTextSize(playerid, td_db [ playerid ] [ 2 ], 100.000000, 120.000000 ) ;
	PlayerTextDrawSetPreviewModel(playerid, td_db [ playerid ] [ 2 ], 450 ) ;
	PlayerTextDrawSetPreviewRot(playerid, td_db [ playerid ] [ 2 ], 0.000000, 0.000000, -90.000000, 1.000000 ) ;
	PlayerTextDrawSetSelectable(playerid, td_db [ playerid ] [ 2 ], 0 ) ;

	td_db [ playerid ] [ 3 ] = CreatePlayerTextDraw(playerid, 583.000000, 157.000000, "0/10.000" ) ;
	PlayerTextDrawAlignment(playerid, td_db [ playerid ] [ 3 ], 2 ) ;
	PlayerTextDrawBackgroundColor(playerid, td_db [ playerid ] [ 3 ], 0 ) ;
	PlayerTextDrawFont(playerid, td_db [ playerid ] [ 3 ], 2 ) ;
	PlayerTextDrawLetterSize(playerid, td_db [ playerid ] [ 3 ], 0.159999, 1.700000 ) ;
	PlayerTextDrawColor(playerid, td_db [ playerid ] [ 3 ], 255 ) ;
	PlayerTextDrawSetOutline(playerid, td_db [ playerid ] [ 3 ], 0 ) ;
	PlayerTextDrawSetProportional(playerid, td_db [ playerid ] [ 3 ], 1 ) ;
	PlayerTextDrawSetShadow(playerid, td_db [ playerid ] [ 3 ], 1 ) ;
	PlayerTextDrawSetSelectable(playerid, td_db [ playerid ] [ 3 ], 0 ) ;
	
	new _str [ 32 ], veh_model = GetVehicleModelEx ( GetPlayerVehicleID ( playerid ) ) ;
	format ( _str, sizeof _str, "%s/%s", 
	GetPlayerCashValueToSmile ( trailer_count [ vehicleid - 1 ] ), 
	GetPlayerCashValueToSmile ( trucker_truck_weight ( veh_model ) ) ) ;
	PlayerTextDrawSetString ( playerid, td_db [ playerid ] [ 3 ], _str ) ;
	
	for ( new i = 0 ; i < 4 ; i ++ )
	{			
		PlayerTextDrawShow ( playerid, td_db [ playerid ] [ i ] ) ;
	}
	return 1 ;
}

stock trucker_check_improve ( playerid, _id )
{
	if ( p_info [ playerid ] [ job ] == job_trucker )
	{
		new _b_id = p_info [ playerid ] [ b_worker ] ;
		if ( _b_id > 0 && b_info [ _b_id - 1 ] [ b_improve ] [ _id ] ) return true ;
	}
	return false ;
}

stock trucker_player_timer ( playerid, type = 1 )
{
	if ( type == 60 )
	{
		if ( p_info [ playerid ] [ job ] == job_trucker )
		{
			new _b_id = p_info [ playerid ] [ b_worker ], veh_id = GetPlayerVehicleID ( playerid ) ;
			if ( veh_id > 0 && _b_id > 0 && b_info [ _b_id - 1 ] [ b_improve ] [ 3 ] && trucker_truck_model ( GetVehicleModelEx ( veh_id ) ) && ++ p_t_info [ playerid ] [ truck_time ] >= 3 )
			{
				p_t_info [ playerid ] [ truck_time ] = 0 ;
				if ( p_t_info [ playerid ] [ truck_special ] != -1 )
				{
					switch ( p_t_info [ playerid ] [ truck_special ] )
					{
						case 1:
						{
							global_string [ 0 ] = EOS ;
							format ( global_string, 144, "* Поступило специальное предложение! Доставьте {"#cWH"}металл {FFFF00}и получите {"#cWH"}%s"valute_title" {"#cWH"}дополнительно.",
							GetPlayerCashValueToSmile ( p_t_info [ playerid ] [ truck_price ] ) ) ;
							SendClientMessage ( playerid, col_yellow, global_string ) ;
						}
						case 0:
						{
							global_string [ 0 ] = EOS ;
							format ( global_string, 144, "* Поступило специальное предложение! Доставьте {"#cWH"}древисину {FFFF00}и получите {"#cWH"}%s"valute_title" {"#cWH"}дополнительно.",
							GetPlayerCashValueToSmile ( p_t_info [ playerid ] [ truck_price ] ) ) ;
							SendClientMessage ( playerid, col_yellow, global_string ) ;
						}
						case 2:
						{
							global_string [ 0 ] = EOS ;
							format ( global_string, 144, "* Поступило специальное предложение! Доставьте {"#cWH"}заготовки {FFFF00}и получите {"#cWH"}%s"valute_title" {"#cWH"}дополнительно.",
							GetPlayerCashValueToSmile ( p_t_info [ playerid ] [ truck_price ] ) ) ;
							SendClientMessage ( playerid, col_yellow, global_string ) ;
						}
					}
				}
				else
				{
					switch ( random ( 20 ) )
					{
						case 1:
						{
							new _price = random ( TRUCK_SPECIAL_PRICE * 2 ) + TRUCK_SPECIAL_PRICE ;
							p_t_info [ playerid ] [ truck_special ] = 1 ;
							p_t_info [ playerid ] [ truck_time ] = 0 ;
							p_t_info [ playerid ] [ truck_price ] = _price ;
							
							global_string [ 0 ] = EOS ;
							format ( global_string, 144, "* Поступило специальное предложение! Доставьте {"#cWH"}металл {FFFF00}и получите {"#cWH"}%s"valute_title" {"#cWH"}дополнительно.",
							GetPlayerCashValueToSmile ( _price ) ) ;
							SendClientMessage ( playerid, col_yellow, global_string ) ;
						}
						case 0:
						{
							new _price = random ( TRUCK_SPECIAL_PRICE * 2 ) + TRUCK_SPECIAL_PRICE ;
							p_t_info [ playerid ] [ truck_special ] = 0 ;
							p_t_info [ playerid ] [ truck_time ] = 0 ;
							p_t_info [ playerid ] [ truck_price ] = _price ;
							
							global_string [ 0 ] = EOS ;
							format ( global_string, 144, "* Поступило специальное предложение! Доставьте {"#cWH"}древисину {FFFF00}и получите {"#cWH"}%s"valute_title" {"#cWH"}дополнительно.",
							GetPlayerCashValueToSmile ( _price ) ) ;
							SendClientMessage ( playerid, col_yellow, global_string ) ;
						}
						case 2:
						{
							new _price = random ( TRUCK_SPECIAL_PRICE * 2 ) + TRUCK_SPECIAL_PRICE ;
							p_t_info [ playerid ] [ truck_special ] = 2 ;
							p_t_info [ playerid ] [ truck_time ] = 0 ;
							p_t_info [ playerid ] [ truck_price ] = _price ;
							
							global_string [ 0 ] = EOS ;
							format ( global_string, 144, "* Поступило специальное предложение! Доставьте {"#cWH"}заготовки {FFFF00}и получите {"#cWH"}%s"valute_title" {"#cWH"}дополнительно.",
							GetPlayerCashValueToSmile ( _price ) ) ;
							SendClientMessage ( playerid, col_yellow, global_string ) ;
						}
					}
				}
			}
		}
	}
	
	if ( player_tload_time [ playerid ] > 0 && player_trailer [ playerid ] != INVALID_VEHICLE_ID )
	{
		player_tload_time [ playerid ] -- ;
		
		new _str [ 16 ] ;
		format ( _str, 16, "~r~%s", convert_time ( player_tload_time [ playerid ], TYPE_TIME_SECOND ) ) ;
		PlayerTextDrawSetString ( playerid, td_db [ playerid ] [ 0 ], _str ) ;
		
		if ( player_tload_time [ playerid ] == 0 ) 
		{
			new vehicleid = player_trailer [ playerid ] ;
			trailer_count [ vehicleid - 1 ] = 0 ;
			DestroyVehicle ( vehicleid, 670 ) ;

			for ( new j = 0 ; j < 3 ; j ++ )
			{
				if ( dorm_queue [ j ] [ 0 ] == playerid )
				{
					dorm_queue [ j ] [ 0 ] = INVALID_PLAYER_ID ;
				}				
				if ( loading_playerid [ j ] == playerid )
				{
					loading_playerid [ j ] = INVALID_PLAYER_ID ;
					DeletePVar ( playerid, "truck_waiting" ) ;
				}
			}
			for ( new j = 0 ; j < 4 ; j ++ )
			{			
				PlayerTextDrawDestroy ( playerid, td_db [ playerid ] [ j ] ) ;
				td_db [ playerid ] [ j ] = PlayerText:-1 ;
			}
			
			player_trailer [ playerid ] = INVALID_VEHICLE_ID ;
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваше время для прицепления фуры истекло. Деньги вам не будут возвращены." ) ;
			player_tload_time [ playerid ] = -1 ;
		}		
	}
	if ( player_leavearea_time [ playerid ] > 0 && player_trailer [ playerid ] != INVALID_VEHICLE_ID )
	{
		player_leavearea_time [ playerid ] -- ;
		new _str [ 16 ] ;
		format ( _str, 16, "~r~%s", convert_time ( player_leavearea_time [ playerid ], TYPE_TIME_SECOND ) ) ;
		PlayerTextDrawSetString ( playerid, td_db [ playerid ] [ 0 ], _str ) ;
		if ( player_leavearea_time [ playerid ] == 0 ) 
		{
			new vehicleid = player_trailer [ playerid ] ;
			trailer_count [ vehicleid - 1 ] = 0 ;
			DestroyVehicle ( vehicleid, 671 ) ;
			for ( new j = 0 ; j < 4 ; j ++ )
			{			
				PlayerTextDrawDestroy ( playerid, td_db [ playerid ] [ j ] ) ;
				td_db [ playerid ] [ j ] = PlayerText:-1 ;
			}
			
			player_trailer [ playerid ] = INVALID_VEHICLE_ID ;

			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваше время для выезда с зоны загрузки истекло. Деньги Вам не будут возвращены." ) ;		
		}
	}
	
	
	if ( GetVehicleTrailer ( GetPlayerVehicleID ( playerid ) ) == player_trailer [ playerid ] && player_trailer [ playerid ] != INVALID_VEHICLE_ID && GetPVarInt ( playerid, "truck_waiting" ) > 0 )
	{
		SendClientMessage ( playerid, col_gray, !"* Вы прицепили фуру. У Вас есть 1 минута, чтобы покинуть место загрузки." ) ;
		player_tload_time [ playerid ] = - 1 ;
		player_leavearea_time [ playerid ] = 60 ;
		DeletePVar ( playerid, "truck_waiting" ) ;
		
		SetTimerEx ( "UpdateTruckerTrailerMinute", 60000, false, "i", playerid ) ; 		
	}
	return 1 ;
}

callback: UpdateTruckerTrailerMinute ( playerid )
{
	for ( new j = 0 ; j < 3 ; j ++ )
	{
		if ( dorm_queue [ j ] [ 0 ] == playerid )
		{
			dorm_queue [ j ] [ 0 ] = INVALID_PLAYER_ID ;
		}
	}
}

stock trucker_OnVehicleSpawn ( vehicleid, _type )
{
	if ( _type == 1 )
	{
		if ( GetVehicleModel ( vehicleid ) == 450 )
		{
			foreach(new i: logged_players)
			{
				if ( player_trailer [ i ] != vehicleid ) continue ;
				give_money ( i, trailer_count [ vehicleid - 1 ] * 9 ) ;
				insert_money_log ( i, INVALID_PLAYER_ID, trailer_count [ vehicleid - 1 ] * 9, "страховка дб" ) ;

				trailer_count [ vehicleid - 1 ] = 0 ;
				DestroyVehicle ( vehicleid, 672 ) ;

				SendClientMessage ( i, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваш груз был уничтожен. Страховая возместила Вам часть ущерба." ) ;

				if ( GetPVarInt ( i, "truck_waiting" ) > 0 )
				{
					for ( new j = 0 ; j < 3 ; j ++ )
					{
						if ( loading_playerid [ j ] == i )
						{
							loading_playerid [ j ] = INVALID_PLAYER_ID ;
							KillTimer ( loading_timer [ j ] ) ;
							loading_timer [ j ] = - 1 ;
							DestroyDynamic3DTextLabel ( loading_text [ j ] ) ;
							loading_text [ j ] = Text3D:-1 ;
							DeletePVar ( i, "truck_waiting" ) ;
						}
					}
				}
				for ( new j = 0 ; j < 4 ; j ++ )
				{			
					PlayerTextDrawDestroy ( i, td_db [ i ] [ j ] ) ;
					td_db [ i ] [ j ] = PlayerText:-1 ;
				}
				player_trailer [ i ] = INVALID_VEHICLE_ID ;
				break ;
			}
		}
	}
	else if ( _type == 2 )
	{
		foreach(new i: logged_players)
		{
			if ( player_rentcar [ i ] == vehicleid )
			{
				new _v_id = player_rentcar [ i ] ;
				player_rentcar [ i ] = INVALID_VEHICLE_ID ;

				if ( player_trailer [ i ] != INVALID_VEHICLE_ID )
				{
					trailer_count [ vehicleid - 1 ] = 0 ;
					DestroyVehicle ( player_trailer [ i ], 673 ) ;

					SendClientMessage ( i, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не смогли доставить груз, затраты не будут возмещены." ) ;
					player_tload_time [ i ] = -1 ;

					if ( GetPVarInt ( i, "truck_waiting" ) > 0 )
					{
						for ( new j = 0 ; j < 3 ; j ++ )
						{
							if ( loading_playerid [ j ] == i )
							{
								loading_playerid [ j ] = INVALID_PLAYER_ID ;
								KillTimer ( loading_timer [ j ] ) ;
								loading_timer [ j ] = -1 ;
								DestroyDynamic3DTextLabel ( loading_text [ j ] ) ;
								loading_text [ j ] = Text3D:-1 ;
								DeletePVar ( i, "truck_waiting" ) ;
							}
						}
					}
					
					for ( new j = 0 ; j < 4 ; j ++ )
					{			
						PlayerTextDrawDestroy ( i, td_db [ i ] [ j ] ) ;
						td_db [ i ] [ j ] = PlayerText:-1 ;
					}
					player_trailer [ i ] = INVALID_VEHICLE_ID ;
				}
				SetVehicleToRespawn ( _v_id, 670 ) ;

				DisablePlayerRaceCheckpoint ( i ) ;

				SendClientMessage ( i, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Арендованный транспорт был отбуксирован." ) ;
				break;
			}
		}
	}
	return 1 ;
}

stock clear_trucker ( playerid )
{
	new _v_id = player_rentcar [ playerid ] ;
	player_rentcar [ playerid ] = INVALID_VEHICLE_ID ;

	if ( player_trailer [ playerid ] != INVALID_VEHICLE_ID )
	{
		new vehicleid = player_trailer [ playerid ] ;
		trailer_count [ vehicleid - 1 ] = 0 ;
		DestroyVehicle ( player_trailer [ playerid ], 673 ) ;

		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не смогли доставить груз, затраты не будут возмещены." ) ;
		player_tload_time [ playerid ] = -1 ;

		if ( GetPVarInt ( playerid, "truck_waiting" ) > 0 )
		{
			for ( new j = 0 ; j < 3 ; j ++ )
			{
				if ( loading_playerid [ j ] == playerid )
				{
					loading_playerid [ j ] = INVALID_PLAYER_ID ;
					KillTimer ( loading_timer [ j ] ) ;
					loading_timer [ j ] = -1 ;
					DestroyDynamic3DTextLabel ( loading_text [ j ] ) ;
					loading_text [ j ] = Text3D:-1 ;
					DeletePVar ( playerid, "truck_waiting" ) ;
				}
			}
		}
					
		for ( new j = 0 ; j < 4 ; j ++ )
		{			
			PlayerTextDrawDestroy ( playerid, td_db [ playerid ] [ j ] ) ;
			td_db [ playerid ] [ j ] = PlayerText:-1 ;
		}
		player_trailer [ playerid ] = INVALID_VEHICLE_ID ;
	}
	SetVehicleToRespawn ( _v_id, 670 ) ;
				
	DisablePlayerRaceCheckpoint ( playerid ) ;
	SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Арендованный транспорт был отбуксирован." ) ;
	return 1 ;
}

stock trucker_OnVehicleDeath ( vehicleid, killerid )
{
	#pragma unused killerid
	if ( GetVehicleModel ( vehicleid ) == 450 )
	{
		foreach(new i: logged_players)
		{
			if ( player_trailer [ i ] != vehicleid ) continue ;
			give_money ( i, trailer_count [ vehicleid - 1 ] * 9 ) ;
			insert_money_log ( i, INVALID_PLAYER_ID, trailer_count [ vehicleid - 1 ] * 9, "страховка дб" ) ;

			trailer_count [ vehicleid - 1 ] = 0 ;
			DestroyVehicle ( vehicleid, 674 ) ;

			SendClientMessage ( i, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваш груз был уничтожен. Страховая возместила Вам часть ущерба." ) ;

			if ( GetPVarInt ( i, "truck_waiting" ) > 0 )
			{
				for ( new j = 0 ; j < 3 ; j ++ )
				{
					if ( loading_playerid [ j ] == i )
					{
						loading_playerid [ j ] = INVALID_PLAYER_ID ;
						KillTimer ( loading_timer [ j ] ) ;
						loading_timer [ j ] = - 1 ;
						DestroyDynamic3DTextLabel ( loading_text [ j ] ) ;
						loading_text [ j ] = Text3D:-1 ;
						DeletePVar ( i, "truck_waiting" ) ;
					}
				}
			}
			for ( new j = 0 ; j < 4 ; j ++ )
			{			
				PlayerTextDrawDestroy ( i, td_db [ i ] [ j ] ) ;
				td_db [ i ] [ j ] = PlayerText:-1 ;
			}
			player_trailer [ i ] = INVALID_VEHICLE_ID ;
			break ;
		}
	}
	return 1 ;
}

stock trucker_EnterDynamicArea ( playerid, areaid )
{
	if ( GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER )
	{
		switch ( area_info [ areaid ] [ a_type ] )
		{
			case area_type_load_trucker:
			{
				if ( GetVehicleTrailer ( GetPlayerVehicleID ( playerid ) ) == player_trailer [ playerid ] && player_trailer [ playerid ] != INVALID_VEHICLE_ID )
				{
					SendClientMessage ( playerid, col_gray, "* У вас уже есть фура с грузом. Покиньте место загрузки в течении 1 минуты." ) ;
					td_db [ playerid ] [ 0 ] = CreatePlayerTextDraw(playerid, 543.000000, 182.000000, "~r~1:00" ) ;
					PlayerTextDrawBackgroundColor(playerid, td_db [ playerid ] [ 0 ], 255 ) ;
					PlayerTextDrawFont(playerid, td_db [ playerid ] [ 0 ], 2 ) ;
					PlayerTextDrawLetterSize(playerid, td_db [ playerid ] [ 0 ], 0.319999, 1.500000 ) ;
					PlayerTextDrawColor(playerid, td_db [ playerid ] [ 0 ], -1 ) ;
					PlayerTextDrawSetOutline(playerid, td_db [ playerid ] [ 0 ], 0 ) ;
					PlayerTextDrawSetProportional(playerid, td_db [ playerid ] [ 0 ], 1 ) ;
					PlayerTextDrawSetShadow(playerid, td_db [ playerid ] [ 0 ], 1 ) ;
					PlayerTextDrawSetSelectable(playerid, td_db [ playerid ] [ 0 ], 0 ) ;
					PlayerTextDrawShow ( playerid, td_db [ playerid ] [ 0 ] ) ;
					
					player_leavearea_time [ playerid ] = 60 ;
					return 1 ;
				}
				
				if ( player_trailer [ playerid ] == INVALID_VEHICLE_ID )
				{
					new truck_weight = trucker_truck_weight ( GetVehicleModelEx ( GetPlayerVehicleID ( playerid ) ) ) ;
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cWH"}Введите количество килограмм, которое хотите купить.\nПоддерживает тягач: {"#cWV"}%d кг{"#cWH"}\nСтоимость закупки: {"#cWV"}1 кг {"#cWH"}- {"#cGN"}"truck_percent_txt""valute_title_"", GetPlayerCashValueToSmile ( truck_weight ) ) ;
					show_dialog ( playerid, d_truck_buy, DIALOG_STYLE_INPUT, "{"#cBHD"}Закупка заготовок", global_string, "Купить", "Отмена" ) ;
				}
				return 1 ;
			}
			case area_type_unload_factory:
			{
				if ( p_info [ playerid ] [ job ] == job_trucker && player_trailer [ playerid ] != INVALID_VEHICLE_ID && GetVehicleTrailer ( GetPlayerVehicleID ( playerid ) ) == player_trailer [ playerid ] )
				{
					new _trailer_id = player_trailer [ playerid ] - 1 ;
					if ( trailer_type [ _trailer_id ] == DORM_FACTORY ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете разгружать заготовки на завод, отправляйтесь в порт." ) ;
					player_trailer [ playerid ] = INVALID_VEHICLE_ID ;
					static const trailer_type_name [ ] [ ] = {
						"древесины",
						"металла",
						"заготовок" 
					} ;

					switch ( trailer_type [ _trailer_id ] )
					{
						case DORM_SAWMILL:
						{
							dorm_count [ DORM_FACTORY_WOOD ] += trailer_count [ _trailer_id ] ;
						}
						case DORM_FACTORY:
						{
							dorm_count [ DORM_FACTORY_GUNS ] += trailer_count [ _trailer_id ] ;
						}
						case DORM_MINE:
						{
							dorm_count [ DORM_FACTORY_MINE ] += trailer_count [ _trailer_id ] ;
						}
					}
							
       				DestroyVehicle ( _trailer_id + 1, 675 ) ;
					
					for ( new j = 1 ; j < 4 ; j ++ )
					{			
						PlayerTextDrawDestroy ( playerid, td_db [ playerid ] [ j ] ) ;
						td_db [ playerid ] [ j ] = PlayerText:-1 ;
					}
							
					p_info [ playerid ] [ truck_skill ] += trailer_count [ _trailer_id ] * server_bonus [ 2 ] ;
					update_int_sql ( playerid, "u_tskill", p_info [ playerid ] [ truck_skill ] ) ;

					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно разгрузились." ) ;
					SendClientMessage ( playerid, -1, !"Информация по заказу:" ) ;
					
					new _text_string [ 128 ] ;
					format ( _text_string, 128, "{"#cGInfo"}* {"#cWH"}Разгружено %s: {"#cGN"}%i кг{"#cWH"}.", trailer_type_name [ trailer_type [ _trailer_id ] ], trailer_count [ _trailer_id ] ) ;
					SendClientMessage ( playerid, -1, _text_string ) ;

					new db_endmoney ;
					db_endmoney = trailer_count [ _trailer_id ] * truck_percent + floatround ( ( trailer_count [ _trailer_id ] * truck_percent ) * 0.10 ) ;

					format ( _text_string, 128, "{"#cGInfo"}* {"#cWH"}Заработано: {"#cGN"}%i$", ( zp_for_gos [ 8 ] * db_endmoney ) * server_bonus [ 3 ] ) ;
					SendClientMessage ( playerid, -1, _text_string ) ;
					
					give_money ( playerid, ( zp_for_gos [ 8 ] * db_endmoney ) * server_bonus [ 3 ] ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, ( zp_for_gos [ 8 ] * db_endmoney ) * server_bonus [ 3 ], "Доставка дальнобойщика" ) ;
					
					give_event_progress ( playerid, THE_TRUCKER, ( zp_for_gos [ 8 ] * db_endmoney ) * server_bonus [ 3 ] ) ;
					
					if ( p_t_info [ playerid ] [ truck_special ] != -1 && p_t_info [ playerid ] [ truck_special ] == trailer_type [ _trailer_id ] )
					{
						global_string [ 0 ] = EOS ;
						format ( global_string, 128, "* Вы выполнили специальное предложение и получаете {"#cWH"}%s"valute_title" {"#cWH"}дополнительно.",
						GetPlayerCashValueToSmile ( p_t_info [ playerid ] [ truck_price ] ) ) ;
						SendClientMessage ( playerid, col_yellow, global_string ) ;
					
						give_money ( playerid, p_t_info [ playerid ] [ truck_price ] ) ;
						insert_money_log ( playerid, INVALID_PLAYER_ID, p_t_info [ playerid ] [ truck_price ], "спец. предложение от ТК" ) ;
						
						p_t_info [ playerid ] [ truck_special ] = -1 ;
						p_t_info [ playerid ] [ truck_time ] = 0 ;
						p_t_info [ playerid ] [ truck_price ] = 0 ;
						
						if ( random ( 100 ) < 25 )
						{
							give_player_item_prise ( playerid, 138, 1, 20 ) ;
							SendClientMessage ( playerid, col_yellow, !"* Вам был добавлен предмет 'Кейс дальнобойщика'. Откройте инвентарь, используйте /mm или радиальное меню." ) ;
						}
					}
					else if ( random ( 100 ) < 10 )
					{
						give_player_item_prise ( playerid, 138, 1, 20 ) ;
						SendClientMessage ( playerid, col_yellow, !"* Вам был добавлен предмет 'Кейс дальнобойщика'. Откройте инвентарь, используйте /mm или радиальное меню." ) ;
					}
	
					trailer_count [ _trailer_id ] = 0 ;
					trailer_type [ _trailer_id ] = -1 ;
				}
				return 1 ;
			}
			case area_type_unload_port:
			{
				if ( p_info [ playerid ] [ job ] == job_trucker && player_trailer [ playerid ] != INVALID_VEHICLE_ID && GetVehicleTrailer ( GetPlayerVehicleID ( playerid ) ) == player_trailer [ playerid ] )
				{
       				new _trailer_id_ = player_trailer [ playerid ] - 1 ;
					player_trailer [ playerid ] = INVALID_VEHICLE_ID ;
					static const _trailer_type_name [ ] [ ] = {
						"древесины",
						"металла",
						"заготовок"
					} ;

					DestroyVehicle ( _trailer_id_ + 1, 676 ) ;
					
					for ( new j = 1 ; j < 4 ; j ++ )
					{			
						PlayerTextDrawDestroy ( playerid, td_db [ playerid ] [ j ] ) ;
						td_db [ playerid ] [ j ] = PlayerText:-1 ;
					}

					p_info [ playerid ] [ truck_skill ] += trailer_count [ _trailer_id_ ] * server_bonus [ 2 ] ;
					update_int_sql ( playerid, "u_tskill", p_info [ playerid ] [ truck_skill ] ) ;

					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно разгрузились." ) ;
					SendClientMessage ( playerid, -1, !"Информация по заказу:" ) ;
					
					new _text_string [ 128 ] ;
					format ( _text_string, 128, "{"#cGInfo"}* {"#cWH"}Разгружено %s: {"#cGN"}%i кг{"#cWH"}.", _trailer_type_name [ trailer_type [ _trailer_id_ ] ], trailer_count [ _trailer_id_ ] ) ;
					SendClientMessage ( playerid, -1, _text_string ) ;

					new db_endmoney ;
					db_endmoney = trailer_count [ _trailer_id_ ] * truck_percent + floatround ( ( trailer_count [ _trailer_id_ ] * truck_percent ) * 0.10 ) ;

					format ( _text_string, 128, "{"#cGInfo"}* {"#cWH"}Заработано: {"#cGN"}%i$", ( zp_for_gos [ 8 ] * db_endmoney ) * server_bonus [ 3 ] ) ;
					SendClientMessage ( playerid, -1, _text_string ) ;
					
					give_money ( playerid, ( zp_for_gos [ 8 ] * db_endmoney ) * server_bonus [ 3 ] ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, ( zp_for_gos [ 8 ] * db_endmoney ) * server_bonus [ 3 ], "Доставка дальнобойщика" ) ;
					
					give_event_progress ( playerid, THE_TRUCKER, ( zp_for_gos [ 8 ] * db_endmoney ) * server_bonus [ 3 ] ) ;
					
					if ( p_t_info [ playerid ] [ truck_special ] != -1 && p_t_info [ playerid ] [ truck_special ] == trailer_type [ _trailer_id_ ] )
					{
						global_string [ 0 ] = EOS ;
						format ( global_string, 128, "* Вы выполнили специальное предложение и получаете {"#cWH"}%s"valute_title" {"#cWH"}дополнительно.",
						GetPlayerCashValueToSmile ( p_t_info [ playerid ] [ truck_price ] ) ) ;
						SendClientMessage ( playerid, col_yellow, global_string ) ;
					
						give_money ( playerid, p_t_info [ playerid ] [ truck_price ] ) ;
						insert_money_log ( playerid, INVALID_PLAYER_ID, p_t_info [ playerid ] [ truck_price ], "спец. предложение от ТК" ) ;
						
						p_t_info [ playerid ] [ truck_special ] = -1 ;
						p_t_info [ playerid ] [ truck_time ] = 0 ;
						p_t_info [ playerid ] [ truck_price ] = 0 ;
					
						if ( random ( 100 ) < 25 )
						{
							give_player_item_prise ( playerid, 138, 1, 20 ) ;
							SendClientMessage ( playerid, col_yellow, !"* Вам был добавлен предмет 'Кейс дальнобойщика'. Откройте инвентарь, используйте /mm или радиальное меню." ) ;
						}
					}
					else if ( random ( 100 ) < 10 )
					{
						give_player_item_prise ( playerid, 138, 1, 20 ) ;
						SendClientMessage ( playerid, col_yellow, !"* Вам был добавлен предмет 'Кейс дальнобойщика'. Откройте инвентарь, используйте /mm или радиальное меню." ) ;
					}
					
					trailer_count [ _trailer_id_ ] = 0 ;
					trailer_type [ _trailer_id_ ] = -1 ;
				}
				return 1 ;
			}
			case area_type_unload_mineral:
			{
				if ( p_info [ playerid ] [ job ] == job_trucker && player_trailer [ playerid ] != INVALID_VEHICLE_ID && GetVehicleTrailer ( GetPlayerVehicleID ( playerid ) ) == player_trailer [ playerid ] )
				{
				    new _trailer_id_ = player_trailer [ playerid ] - 1 ;
					if ( trailer_type [ _trailer_id_ ] != DORM_MINE ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы можете разгружать лишь металл на завод." ) ;
					player_trailer [ playerid ] = INVALID_VEHICLE_ID ;
					static const _trailer_type_name [ ] [ ] = {
						"древесины",
						"металла",
						"заготовок" 
					} ;

					if ( trailer_type [ _trailer_id_ ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Фура должна быть заполнена металлом." ) ;

                    new db_endmoney ;
					db_endmoney = trailer_count [ _trailer_id_ ] * plant_metall_price + floatround ( ( trailer_count [ _trailer_id_ ] * plant_metall_price ) * 0.10 ) ;

					if ( f_info [ b_info [ mafia_factory_id ] [ b_mafia ] - 1 ] [ f_money ] < db_endmoney ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вам не смогут заплатить за металл." ) ;

                    f_info [ b_info [ mafia_factory_id ] [ b_mafia ] - 1 ] [ f_money ] -= db_endmoney ;

	                DestroyVehicle ( _trailer_id_ + 1, 677 ) ;
					
					for ( new j = 1 ; j < 4 ; j ++ )
					{			
						PlayerTextDrawDestroy ( playerid, td_db [ playerid ] [ j ] ) ;
						td_db [ playerid ] [ j ] = PlayerText:-1 ;
					}

	                SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно разгрузились." ) ;
					SendClientMessage ( playerid, -1, !"Информация по заказу:" ) ;
				
					new _text_string [ 128 ] ;
					format ( _text_string, 128, "{"#cGInfo"}* {"#cWH"}Разгружено %s: {"#cGN"}%i кг{"#cWH"}.", _trailer_type_name [ trailer_type [ _trailer_id_ ] ], trailer_count [ _trailer_id_ ] ) ;
					SendClientMessage ( playerid, -1, _text_string ) ;

					format ( _text_string, 128, "{"#cGInfo"}* {"#cWH"}Заработано: {"#cGN"}%i$", ( zp_for_gos [ 8 ] * db_endmoney ) * server_bonus [ 3 ] ) ;
					SendClientMessage ( playerid, -1, _text_string ) ;

					give_money ( playerid, ( zp_for_gos [ 8 ] * db_endmoney ) * server_bonus [ 3 ] ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, ( zp_for_gos [ 8 ] * db_endmoney ) * server_bonus [ 3 ], "Доставка дальнобойщика" ) ;

				    mineral += trailer_count [ _trailer_id_ ] ;
				    plant_order -= trailer_count [ _trailer_id_ ] ;
					if ( plant_order < 0 ) plant_order = 0 ;

				    if ( p_info [ playerid ] [ wanted ] + 1 < 6 ) p_info [ playerid ] [ wanted ] += 1 ;
				    else p_info [ playerid ] [ wanted ] = 6 ;
					SetPlayerWantedLevel( playerid, p_info [ playerid ] [ wanted ] ) ;

					if ( p_info [ playerid ] [ law_obedience ] != -100 ) p_info [ playerid ] [ law_obedience ] -- ;

					new scm_string [ 144 ] ;
					format ( scm_string, sizeof ( scm_string ), "Вы были объявлены в розыск! Обвинитель Неизвестный. Причина: Кража металла." ) ;
					SendClientMessage ( playerid, col_light_red, scm_string ) ;
					format ( scm_string, sizeof ( scm_string ), "Ваш текущий уровень розыска: %d", p_info [ playerid ] [ wanted ] ) ;
					SendClientMessage ( playerid, col_light_red, scm_string ) ;
					format ( scm_string, sizeof ( scm_string ), "%s был(а) объявлен(a) в розыск! Обвинитель: Неизвестный | Причина: Кража металла | Уровень розыска: %d",
					p_info [ playerid ] [ name ], p_info [ playerid ] [ wanted ] ) ;

					foreach(new i: logged_players) if ( cop_player ( i ) || fbi_player ( i ) || army_player ( i ) ) SendClientMessage ( i, col_lblue, scm_string ) ;

				    new kuznica_text [ 128 ] ;
				    format(kuznica_text, 128, "** Склад **\n{"#cGR"}Руды на складе: {"#cWH"}%i кг.", mineral ) ;
					UpdateDynamic3DTextLabelText ( RifaKyznica [ 0 ], col_blue, kuznica_text ) ;

					if ( mafia_player ( playerid ) )
						checking_mafia_quest_progress ( playerid, 3, trailer_count [ _trailer_id_ ] ) ;

					trailer_count [ _trailer_id_ ] = 0 ;
					trailer_type [ _trailer_id_ ] = -1 ;
				}
			}
		}
	}
	return 0 ;
}

stock trucker_LeaveDynamicArea ( playerid, areaid )
{
	if ( GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER )
	{
		switch ( area_info [ areaid ] [ a_type ] )
		{
			case area_type_loading_free:
			{
				if ( p_info [ playerid ] [ job ] == job_trucker && player_leavearea_time [ playerid ] > 0 )
				{
					loading_playerid [ DORM_FACTORY ] = INVALID_PLAYER_ID ;
					
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Все отлично. Теперь вы можете ехать к месту разгрузки. {"#cGRInfo"}(/gps - Работы - Разгрузочные зоны)." ) ;	
					player_leavearea_time [ playerid ] = -1 ;
					PlayerTextDrawDestroy ( playerid, td_db [ playerid ] [ 0 ] ) ;
					td_db [ playerid ] [ 0 ] = PlayerText:-1 ;
				}				
			}
		}
	}
	return 0 ;
}

stock show_tpanel ( playerid )
{
	show_dialog ( playerid, d_truck_panel, DIALOG_STYLE_LIST, "{"#cBHD"}Панель дальнобойщика", "{"#cBL"}1. {"#cWH"}Состояние складов\n{"#cBL"}2. {"#cWH"}Точки загрузки\n{"#cBL"}3. {"#cWH"}Точки разгрузки", "Выбрать", "Закрыть" ) ;
	return 1 ;
}

CMD:tskill ( playerid )
{
	global_string [ 0 ] = EOS ;

	new _t_skill = p_info [ playerid ] [ truck_skill ], _t_level = floatround ( _t_skill / 30000 ) ;
	if ( _t_level < 1 ) _t_level = 1 ;
	
	format ( global_string, 1024,
	"{"#cBL"}** Информация **\n\n\
	{"#cWH"}Ваш уровень: {"#cWV"}%d\n\
	{"#cWH"}Перевезено груза: {"#cWV"}%s кг\n\
	{"#cWH"}Необходимо перевезти для {"#cWV"}%d {"#cWH"}уровня: {"#cWV"}%s кг\n\n\
	{"#cBL"}** Транспорт **\n\n\
	%s {"#cWH"}%s {"#cGRDialog"}- 1 уровень, %s кг\n\
	%s {"#cWH"}%s {"#cGRDialog"}- 3 уровень, %s кг\n\
	%s {"#cWH"}%s {"#cGRDialog"}- 5 уровень, %s кг\n\
	%s {"#cWH"}Возможность работать на личном транспорте {"#cGRDialog"}- 7 уровень\n\n\
	{"#cLY"}Кейс дальнобойщика {"#cWH"}выпадает с шансом в 10%% за заказ,\n\
	за доставку уникального предложения шанс 25%% на выпадение кейса.",
	_t_level, GetPlayerCashValueToSmile ( _t_skill ), _t_level + 1, GetPlayerCashValueToSmile ( ( _t_level + 1 ) * 30000 ),
	( _t_level >= 1 ) ? ( "{"#cGN"}+" ) : ( "{"#cRD"}-" ),
	GetVehicleNameEx ( -1, 403 ), GetPlayerCashValueToSmile ( trucker_truck_weight ( 403 ) ),
	( _t_level >= 3 ) ? ( "{"#cGN"}+" ) : ( "{"#cRD"}-" ),
	GetVehicleNameEx ( -1, 514 ), GetPlayerCashValueToSmile ( trucker_truck_weight ( 514 ) ),
	( _t_level >= 5 ) ? ( "{"#cGN"}+" ) : ( "{"#cRD"}-" ),
	GetVehicleNameEx ( -1, 515 ), GetPlayerCashValueToSmile ( trucker_truck_weight ( 515 ) ),
	( _t_level >= 7 ) ? ( "{"#cGN"}+" ) : ( "{"#cRD"}-" ) ) ;
	show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Дальнобойщик", global_string, "Закрыть", "" ) ;
	return 1 ;
}

stock trucker_truck_weight ( veh_model )
{
	new max_weight ;
	switch ( veh_model )
	{
		case 403: max_weight = 7000 ;
		case 514: max_weight = 10000 ;
		case 515: max_weight = 12000 ;
	}
	return max_weight ;
}

stock trucker_truck_model ( veh_model )
{
	switch ( veh_model )
	{
		case 403: return 1 ;
		case 514: return 1 ;
		case 515: return 1 ;
	}
	return 0 ;
}

stock trucker_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_trucker_bizz:
		{
			if ( ! response ) return 1 ;
			
			if ( listitem == 0 )
			{
				if ( p_info [ playerid ] [ job ] != job_trucker )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не трудоустроены дальнобойщиком. Устроиться можно в Мэрии. (/gps - Важные места)" ) ;
				
				if ( p_info [ playerid ] [ b_worker ] == b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_id ] )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже работаете в этой транспортной компании." ) ;
				
				new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
				global_string [ 0 ] = EOS ;
				format ( global_string, 512, "\
					{"#cBL"}** Транспортная компания {"#cWH"}%s {"#cBL"}**\n\n\
					{"#cWH"}Процент компании: {"#cWV"}%d%%\n\
					{"#cWH"}Бюджет компании: {"#cGN"}%s"valute_title_"\n\
					{"#cWH"}Транспорт компании: {"#cWV"}%d шт.\n\n\
					{"#cGRDialog"}* Вы хотите устроиться в транспортную компанию?", 
				b_info [ _b_id - 1 ] [ b_name ], b_info [ _b_id - 1 ] [ b_cost ], GetPlayerCashValueToSmile ( b_info [ _b_id - 1 ] [ b_money ] ), b_info [ _b_id - 1 ] [ b_max_car ] ) ;
				show_dialog ( playerid, d_trucker_invite, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Транспортная компания", global_string, "Устроиться", "Закрыть" ) ;
				return 1 ;
			}
			else if ( listitem == 1 )
			{
				if ( p_info [ playerid ] [ job ] != job_trucker )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не трудоустроены дальнобойщиком. Устроиться можно в Мэрии. (/gps - Важные места)" ) ;
				
				if ( p_info [ playerid ] [ b_worker ] != b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_id ] )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не работаете в этой транспортной компании." ) ;

				new sql_string [ 110 + ( 9 * 2 ) ], _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
				format ( sql_string, sizeof sql_string, "SELECT `sv_id`, `sv_model`, `sv_rent_price`, `sv_use` FROM `rent_vehicles` WHERE `sv_owner` = '%d' LIMIT %d", 
				b_info [ _b_id - 1 ] [ b_car_marker ], b_info [ _b_id - 1 ] [ b_max_car ] ) ;
				mysql_tquery ( sql_connection, sql_string, "trucker_rent_loading_info", "d", playerid ) ;
				
				SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Используйте /tpanel для вызова меню работы." ) ;
			}
			else if ( listitem == 2 )
			{
				if ( p_info [ playerid ] [ job ] != job_trucker )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не трудоустроены дальнобойщиком. Устроиться можно в Мэрии. (/gps - Важные места)" ) ;
				
				if ( p_info [ playerid ] [ b_worker ] != b_info [ GetPVarInt ( playerid, "p_biz_id" ) - 1 ] [ b_id ] )
					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не работаете в этой транспортной компании." ) ;

				new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
				global_string [ 0 ] = EOS ;
				format ( global_string, 612, "\
				{"#cBL"}** Транспортная компания {"#cWH"}%s {"#cBL"}**\n\n\
					{"#cWH"}Процент компании: {"#cWV"}%d%%\n\
					{"#cWH"}Бюджет компании: {"#cGN"}%s"valute_title_"\n\
					{"#cWH"}Транспорт компании: {"#cWV"}%d шт.\n\n\
					{"#cBL"}** Улучшения **\n\n\
					%s {"#cWH"}%s {"#cGRDialog"}- скидка в 50%% на любой заправке, когда Вы на фуре\n\
					%s {"#cWH"}%s {"#cGRDialog"}- ремонт т/с на базе компании\n\
					%s {"#cWH"}%s {"#cGRDialog"}- следите за поступлением срочного заказа в чате\n\n\
					{"#cLY"}Кейс дальнобойщика {"#cWH"}выпадает с шансом в 10%% за заказ,\n\
					за доставку уникального предложения шанс 25%% на выпадение кейса.",
				b_info [ _b_id - 1 ] [ b_name ], b_info [ _b_id - 1 ] [ b_cost ], GetPlayerCashValueToSmile ( b_info [ _b_id - 1 ] [ b_money ] ), b_info [ _b_id - 1 ] [ b_max_car ],
				( b_info [ _b_id - 1 ] [ b_improve ] [ 1 ] > 0 ) ? ( "{"#cGN"}+" ) : ( "{"#cRD"}-" ), b_improve_truck_name [ 1 ],
				( b_info [ _b_id - 1 ] [ b_improve ] [ 2 ] > 0 ) ? ( "{"#cGN"}+" ) : ( "{"#cRD"}-" ), b_improve_truck_name [ 2 ],
				( b_info [ _b_id - 1 ] [ b_improve ] [ 3 ] > 0 ) ? ( "{"#cGN"}+" ) : ( "{"#cRD"}-" ), b_improve_truck_name [ 3 ] ) ;
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Транспортная компания", global_string, "Закрыть", "" ) ;
			}
			return 1 ;
		}
		case d_trucker_invite:
		{
			if ( ! response ) return 1 ;
			
			new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
			p_info [ playerid ] [ b_worker ] = b_info [ _b_id - 1 ] [ b_id ] ;
			p_info [ playerid ] [ business_rang ] = 1 ;
			Iter_Add(business_players[_b_id], playerid);
			
			new sql_string [ 93 + ( 9 * 2 ) ] ;
			format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_bworker` = '%d', `u_business_rang` = '1' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ b_worker ], p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
			
			new _t_string [ 128 ] ;
			format ( _t_string, sizeof ( _t_string ), "{%s}[%s] %s устроился(ась) в компанию. Приветствуем!", b_info [ _b_id - 1 ] [ b_chat_color ], b_info [ _b_id - 1 ] [ b_name ], p_info [ playerid ] [ name ] ) ;
			business_message ( _b_id, col_gray, _t_string ) ;
			return 1 ;
		}
		case d_truck_panel:
		{
			if ( ! response ) return 1 ;
			switch ( listitem )
			{
				case 0:
				{
					global_string [ 0 ] = EOS ;
					strcat ( global_string, "{"#cBL"}№. Название:\t{"#cBL"}Состояние:\n" ) ;
					format ( global_string, 722, "\
					{"#cBL"}1. {"#cWH"}Лесопилка\t{"#cGR"}Древесина: {"#cWH"}%d кг.\n\
					{"#cBL"}2. {"#cWH"}Шахта\t{"#cGR"}Металл: {"#cWH"}%d кг.\n\
					{"#cBL"}3. {"#cWH"}Завод\t{"#cGR"}Заготовки: {"#cWH"}%i/1.000.000\n\
					{"#cBL"}3. {"#cWH"}Завод\t{"#cGR"}Металл: {"#cWH"}%i/1.000.000\n\
					{"#cBL"}3. {"#cWH"}Завод\t{"#cGR"}Древесина: {"#cWH"}%i/1.000.000",
					dorm_count [ DORM_SAWMILL ], dorm_count [ DORM_MINE ], dorm_count [ DORM_FACTORY_GUNS ], dorm_count [ DORM_FACTORY_MINE ], dorm_count [ DORM_FACTORY_WOOD ] ) ;
					show_dialog ( playerid, d_truck_info, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBL"}Состояние складов", global_string, "Назад", "Закрыть" ) ;
					return 1 ;
				}
				case 1:
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 512, "\
					{"#cBL"}№. Название:\t{"#cBL"}Информация:\t{"#cBL"}Расстояние:\n\
					{"#cBL"}1. {"#cWH"}Шахта\t{"#cLY"}Загрузка металла{"#cWH"}\t%.2f км\n\
					{"#cBL"}2. {"#cWH"}Лесопилка\t{"#cLY"}Загрузка древисины{"#cWH"}\t%.2f км\n\
					{"#cBL"}3. {"#cWH"}Завод\t{"#cLY"}Загрузка заготовок{"#cWH"}\t%.2f км",
					GetPlayerDistanceFromPoint ( playerid, load_truck_zone [ 0 ] [ 0 ], load_truck_zone [ 0 ] [ 1 ], load_truck_zone [ 0 ] [ 2 ] ),
					GetPlayerDistanceFromPoint ( playerid, load_truck_zone [ 1 ] [ 0 ], load_truck_zone [ 1 ] [ 1 ], load_truck_zone [ 1 ] [ 2 ] ),
					GetPlayerDistanceFromPoint ( playerid, load_truck_zone [ 2 ] [ 0 ], load_truck_zone [ 2 ] [ 1 ], load_truck_zone [ 2 ] [ 2 ] ) ) ;		
					show_dialog ( playerid, d_truck_loadings, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBL"}Точки загрузки", global_string, "Выбрать", "Назад" ) ;
				}
				case 2:
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 512, "\
					{"#cBL"}№. Название:\t{"#cBL"}Информация:\t{"#cBL"}Расстояние:\n\
					{"#cBL"}1. {"#cWH"}Завод\t{"#cLY"}Выгрузка металла / древисины{"#cWH"}\t%.2f км\n\
					{"#cBL"}2. {"#cWH"}Порт\t{"#cLY"}Выгрузка заготовок{"#cWH"}\t%.2f км",
					GetPlayerDistanceFromPoint ( playerid, unload_truck_zone [ 0 ] [ 0 ], unload_truck_zone [ 0 ] [ 1 ], unload_truck_zone [ 0 ] [ 2 ] ),
					GetPlayerDistanceFromPoint ( playerid, unload_truck_zone [ 1 ] [ 0 ], unload_truck_zone [ 1 ] [ 1 ], unload_truck_zone [ 1 ] [ 2 ] ) ) ;		
					show_dialog ( playerid, d_truck_unloadings, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBL"}Точки разгрузки", global_string, "Выбрать", "Назад" ) ;
				}
			}
		}
		case d_truck_info:
		{
			if ( response ) return show_tpanel ( playerid ) ;
		}
		case d_truck_loadings:
		{
			if ( ! response ) return show_tpanel ( playerid ) ;
			switch ( listitem )
			{
				case 0:SetPlayerRaceCheckpoint ( playerid, 1, load_truck_zone [ 0 ] [ 0 ], load_truck_zone [ 0 ] [ 1 ], load_truck_zone [ 0 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ; // Шахта
				case 1:SetPlayerRaceCheckpoint ( playerid, 1, load_truck_zone [ 1 ] [ 0 ], load_truck_zone [ 1 ] [ 1 ], load_truck_zone [ 1 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ; // Лесопилка
				case 2:SetPlayerRaceCheckpoint ( playerid, 1, load_truck_zone [ 2 ] [ 0 ], load_truck_zone [ 2 ] [ 1 ], load_truck_zone [ 2 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ; // Завод
			}
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;	
			is_gps_used { playerid } = 1 ;
			return 1 ;	
		}
		case d_truck_unloadings:
		{
			if ( ! response ) return show_tpanel ( playerid ) ;
			switch ( listitem )
			{
				case 0:SetPlayerRaceCheckpoint ( playerid, 1, unload_truck_zone [ 0 ] [ 0 ], unload_truck_zone [ 0 ] [ 1 ], unload_truck_zone [ 0 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ; // Завод
				case 1:SetPlayerRaceCheckpoint ( playerid, 1, unload_truck_zone [ 1 ] [ 0 ], unload_truck_zone [ 1 ] [ 1 ], unload_truck_zone [ 1 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ; // Порт
			}
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;	
			is_gps_used { playerid } = 1 ;
			return 1 ;
		}
		case d_truck_buy:
		{
			if ( ! response ) return 1 ;
			new _value = strval ( inputtext ), truck_weight = trucker_truck_weight ( GetVehicleModelEx ( GetPlayerVehicleID ( playerid ) ) ) ;
			if ( _value < 1000 || _value > truck_weight )
			{
			    new veh_id = GetPlayerVehicleID ( playerid ) ;
				if ( p_info [ playerid ] [ job ] == job_trucker && used_area [ playerid ] == loading_area [ DORM_FACTORY ] && veh_info [ veh_id - 1 ] [ v_type ] == vehicle_type_job && trucker_truck_model ( GetVehicleModelEx ( veh_id ) ) )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cWH"}Введите количество килограмм, которое хотите купить.\nПоддерживает тягач: {"#cWV"}%d кг{"#cWH"}\nСтоимость закупки: {"#cWV"}1 кг {"#cWH"}- {"#cGN"}"truck_percent_txt""valute_title_"", GetPlayerCashValueToSmile ( truck_weight ) ) ;
					show_dialog ( playerid, d_truck_buy, DIALOG_STYLE_INPUT, "{"#cBHD"}Закупка заготовок", global_string, "Купить", "Отмена" ) ;
				}
				else if ( p_info [ playerid ] [ job ] == job_trucker && used_area [ playerid ] == loading_area [ DORM_SAWMILL ] && veh_info [ veh_id - 1 ] [ v_type ] == vehicle_type_job && trucker_truck_model ( GetVehicleModelEx ( veh_id ) ) )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cWH"}Введите количество килограмм, которое хотите купить.\nПоддерживает тягач: {"#cWV"}%d кг{"#cWH"}\nСтоимость закупки: {"#cWV"}1 кг {"#cWH"}- {"#cGN"}"truck_percent_txt""valute_title_"", GetPlayerCashValueToSmile ( truck_weight ) ) ;
					show_dialog ( playerid, d_truck_buy, DIALOG_STYLE_INPUT, "{"#cBHD"}Закупка древесины", global_string, "Купить", "Отмена" ) ;
				}
				else if ( p_info [ playerid ] [ job ] == job_trucker && used_area [ playerid ] == loading_area [ DORM_MINE ] && veh_info [ veh_id - 1 ] [ v_type ] == vehicle_type_job && trucker_truck_model ( GetVehicleModelEx ( veh_id ) ) )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cWH"}Введите количество килограмм, которое хотите купить.\nПоддерживает тягач: {"#cWV"}%d кг{"#cWH"}\nСтоимость закупки: {"#cWV"}1 кг {"#cWH"}- {"#cGN"}"truck_percent_txt""valute_title_"", GetPlayerCashValueToSmile ( truck_weight ) ) ;
					show_dialog ( playerid, d_truck_buy, DIALOG_STYLE_INPUT, "{"#cBHD"}Закупка металла", global_string, "Купить", "Отмена" ) ;
				}
			
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "{"#cRInfo"}* {"#cGRInfo"}Вы не можете загрузить менее {"#cRD"}1.000 кг {"#cGRInfo"}и более {"#cRD"}%s кг{"#cGRInfo"}.", GetPlayerCashValueToSmile ( truck_weight ) ) ;
				SendClientMessage ( playerid, col_gray, global_string ) ;
				return 1 ;
			}
			new dorm_id = -1 ;
			if ( used_area [ playerid ] == loading_area [ DORM_SAWMILL ] ) dorm_id = 0 ;
			else if ( used_area [ playerid ] == loading_area [ DORM_MINE ] ) dorm_id = 1 ;
			else if ( used_area [ playerid ] == loading_area [ DORM_FACTORY ] ) dorm_id = 4 ;

			if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID || dorm_id == -1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Произошла ошибка. Попробуйте ещё раз." ) ;
			if ( strval ( inputtext ) > dorm_count [ dorm_id ] ) return  SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}На складе столько нет." ) ;
			if ( p_info [ playerid ] [ money ] < _value * 10 ) return  SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно средств для закупки." ) ;
			if ( player_trailer [ playerid ] != INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас уже есть груз." ) ;

			new queue_id = -1 ;
			if ( dorm_id == 1 )
			{
				for ( new i = 0 ; i < 10 ; i ++ )
				{
					if ( dorm_queue [ DORM_MINE ] [ i ] == playerid )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже стоите в очереди." ) ;
						return 1 ;
					}
					if ( dorm_queue [ DORM_MINE ] [ i ] != INVALID_PLAYER_ID ) continue ;
					
					dorm_queue [ DORM_MINE ] [ i ] = playerid ;
					queue_id = i + 1 ;
					break ;
				}
			}
			else if ( dorm_id == 0 )
			{
				for ( new i = 0 ; i < 10 ; i ++ )
				{
					if ( dorm_queue [ DORM_SAWMILL ] [ i ] == playerid )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже стоите в очереди." ) ;
						return 1 ;
					}
					if ( dorm_queue [ DORM_SAWMILL ] [ i ] != INVALID_PLAYER_ID ) continue ;
					
					dorm_queue [ DORM_SAWMILL ] [ i ] = playerid ;
					queue_id = i + 1 ;
					break ;
				}
			}
			else if ( dorm_id == 4 )
			{
				for ( new i = 0 ; i < 10 ; i ++ )
				{
					if ( dorm_queue [ DORM_FACTORY ] [ i ] == playerid )
					{
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже стоите в очереди." ) ;
						return 1 ;
					}
					if ( dorm_queue [ DORM_FACTORY ] [ i ] != INVALID_PLAYER_ID ) continue ;
					
					dorm_queue [ DORM_FACTORY ] [ i ] = playerid ;
					queue_id = i + 1 ;
					break ;
				}
			}

			if ( queue_id == -1 )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Очередь заполнена, попробуйте позже." ) ;
				return 1 ;
			}

			SetPVarInt ( playerid, "truck_waiting", dorm_id + 1 ) ;
			SetPVarInt ( playerid, "truck_count", _value ) ;
			new _string [ 128 ] ;
			SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы встали в очередь на загрузку фуры. Ожидайте." ) ;
			format ( _string, sizeof ( _string ), "Вы номер %d в очереди.", queue_id ) ;
			SendClientMessage ( playerid, -1, _string ) ;

			if ( dorm_id == 1 )
			{
				format ( _string, sizeof ( _string ), "Куплено: Металл %d кг. | %d$", _value, _value * truck_percent ) ;
			}
			else if ( dorm_id == 0 )
			{
				format ( _string, sizeof ( _string ), "Куплено: Древесина %d кг. | %d$", _value, _value * truck_percent ) ;
			}
			else if ( dorm_id == 4 )
			{
				format ( _string, sizeof ( _string ), "Куплено: Заготовки %d кг. | %d$", _value, _value * truck_percent ) ;
			}

			SendClientMessage ( playerid, col_succes, _string ) ;
			give_money ( playerid, - _value * truck_percent ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, - _value * truck_percent, "закупка дальнобойщика" ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock show_bizz_invite ( playerid, _b_id )
{
	global_string [ 0 ] = EOS ;
	show_dialog ( playerid, d_trucker_bizz, DIALOG_STYLE_LIST, "{"#cBHD"}Транспортная компания", "{"#cBL"}1. {"#cWH"}Устроиться в компанию\n{"#cBL"}2. {"#cWH"}Аренда транспорта\n{"#cBL"}3. {"#cWH"}Информация о компании", "Выбрать", "Закрыть" ) ;
	
	SetPVarInt ( playerid, "p_biz_id", _b_id + 1 ) ;
	return 1 ;
}

callback: trucker_rent_loading_info ( playerid )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;

	SetPVarInt ( playerid, "_b_toggled", 1 ) ;

	global_string [ 0 ] = EOS ;
	new line_string [ 144 ], line_level [ 12 ], _sv_____model, _sv_____id, _sv_____rent_price, _sv_____use ;

	strcat ( global_string, "{"#cBL"}№. Название:\t{"#cBL"}Стоимость аренды:\t{"#cBL"}Требуемый уровень:\t{"#cBL"}Статус:\n" ) ;
	for ( new i = 0 ; i < rows ; i ++ )
	{
		_sv_____model = cache_get_field_content_int ( i, "sv_model", sql_connection ) ;
		_sv_____id = cache_get_field_content_int ( i, "sv_id", sql_connection ) ;
		_sv_____rent_price = cache_get_field_content_int ( i, "sv_rent_price", sql_connection ) ;
		_sv_____use = cache_get_field_content_int ( i, "sv_use", sql_connection ) ;

		set_player_listitem_values ( playerid, i, _sv_____id ) ;
		
		if ( _sv_____model == 403 ) format ( line_level, sizeof line_level, "1 ур." ) ;
		else if ( _sv_____model == 514 ) format ( line_level, sizeof line_level, "3 ур." ) ;
		else if ( _sv_____model == 515 ) format ( line_level, sizeof line_level, "5 ур." ) ;

		format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s\t{"#cGN"}%s"valute_title_"\t%s\t%s\n",
		i + 1, GetVehicleNameEx ( -1, _sv_____model ), GetPlayerCashValueToSmile (_sv_____rent_price ), line_level, ( _sv_____use < 1 ) ? ( "{"#cGN"}Свободен" ) : ( "{"#cRD"}Занят" ) ) ;
		strcat ( global_string, line_string ) ;
	}
	show_dialog ( playerid, d_use_car, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Транспорт", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}