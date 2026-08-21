/* 

	Квесты для армии:
	полоса припятсвий
	разменирование бомб
	
	Квесты для медиков:
	доставка медикаментов
	
	ALTER TABLE `users_quests` ADD `u_farm_quest_0` INT(11) NOT NULL DEFAULT '0' AFTER `u_mission_time`, ADD `u_farm_quest_1` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_0`, ADD `u_farm_quest_2` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_1`, ADD `u_farm_quest_3` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_2`, ADD `u_farm_quest_4` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_3`, ADD `u_farm_quest_5` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_4`, ADD `u_farm_quest_6` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_5`, ADD `u_farm_quest_7` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_6`, ADD `u_farm_quest_8` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_7`, ADD `u_farm_quest_9` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_8`, ADD `u_farm_quest_10` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_9`, ADD `u_farm_quest_11` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_10`, ADD `u_farm_quest_12` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_11`, ADD `u_farm_quest_13` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_12`, ADD `u_farm_quest_14` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_13`, ADD `u_farm_quest_15` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_14`, ADD `u_farm_quest_16` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_15`, ADD `u_farm_quest_17` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_16`, ADD `u_farm_quest_18` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_17`, ADD `u_farm_quest_19` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_18`, ADD `u_farm_quest_20` INT(11) NULL DEFAULT '0' AFTER `u_farm_quest_19`, ADD `u_farm_quest_21` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_20`, ADD `u_farm_quest_22` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_21`, ADD `u_farm_quest_23` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_22`, ADD `u_farm_quest_24` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_23`, ADD `u_farm_quest_25` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_24`, ADD `u_farm_quest_26` INT(11) NOT NULL DEFAULT '0' AFTER `u_farm_quest_25`; 
	
*/

new Float: quest_position [ 27 ] [ 3 ] =
{
	{ 0.0, 0.0, 0.0 },
	{ 2594.6833, 2787.5974, 10.8203 }, // Ограбление
	{ 2594.6731, 2793.6741, 10.8203 }, // Граффити
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 1357.3638, -1021.4371, 21.0000 }, // Сено
	{ 1315.0041, -993.5960, 21.0000 }, // Яйца
	{ 2133.1914, 1792.6624, 31.0000 }, // Дойка коров
	{ 1319.6794, -908.4382, 21.0000 }, // Фермер
	{ 1319.6794, -908.4382, 21.0000 },
	{ 1319.6794, -908.4382, 21.0000 },
	{ 1319.4278, -933.1977, 21.0000 }, // Мясокомбинат
	{ 1316.2607, -968.3598, 21.0000 }, // Кормление коров
	{ 2129.9936, 1817.5139, 31.0000 }, // Сбор фруктов
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ -2248.0346, -815.4050, 29.5322 }, // Черепахи
	{ -2193.6640, -793.3474, 29.3472 } // Жемчуг
} ;

new Float: quest_actor_position [ 27 ] [ 4 ] =
{
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 }, // Ограбление
	{ 0.0, 0.0, 0.0, 0.0 }, // Графити
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 1355.5583, -1021.8785, 21.0000, 284.5146 }, // Сено
	{ 1313.4984, -991.8844, 21.0000, 233.5279 }, // Яйца
	{ 2135.3994, 1795.1126, 31.0000, 131.1682 }, // Дойка коров
	{ 1317.0039, -906.7600, 21.0000, 233.7491 }, // Фермер
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 1316.9418, -931.6925, 21.0000, 232.5119 }, // Мясокомбинат
	{ 1313.5915, -970.2471, 21.0000, 295.2414 }, // Кормление коров
	{ 2132.1262, 1819.6269, 31.0000, 131.0500 }, // Сбор фруктов
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0, 0.0 },
	{ -2247.7106, -816.4519, 29.4201, 9.4874 }, // Черепахи
	{ -2193.1164, -793.9199, 29.3127, 46.9940 } // Жемчуг
} ;

#define quest_maze_reward 40000
#define quest_graffity_reward 32000
#define quest_hay_reward 20000
#define quest_eggs_reward 25000
#define quest_milking_reward 20000

#define quest_farmer1_reward 15000
#define quest_farmer2_reward 20000
#define quest_farmer3_reward 15000
#define quest_farmer_all_reward 15000

#define quest_meat_reward 30000
#define quest_cow_food_reward 20000
#define quest_fruit_reward 30000
#define quest_turtle_reward 30000
#define quest_pearle_reward 25000

new PlayerText: quest_PTD [ MAX_PLAYERS ] [ 7 ] ;

new player_quest [ MAX_PLAYERS ] ;
new player_quest_progress [ MAX_PLAYERS char ] ;
new player_quest_id [ MAX_PLAYERS char ] ;
new player_quest_step [ MAX_PLAYERS char ] ;
new player_quest_object [ MAX_PLAYERS ] [ 3 ] ;
new player_quest_pickup [ MAX_PLAYERS ] [ 3 ] ;
new player_quest_area [ MAX_PLAYERS ] [ 3 ] ;
new quest_icon [ MAX_PLAYERS ] [ 3 ] = { -1, ... } ;
new player_quest_vehicle [ MAX_PLAYERS ] ;
new player_quest_vehicle_attached [ MAX_PLAYERS ] [ 11 ] ;
new player_quest_vehicle_spawn [ MAX_PLAYERS char ] ;
new player_quest_selector [ MAX_PLAYERS char ] ;
new player_quest_warning [ MAX_PLAYERS char ] ;
new bool: player_quest_area_used [ MAX_PLAYERS ] [ 15 ] ;
new player_quest_time [ MAX_PLAYERS ] ;
new player_quest_cooldown [ MAX_PLAYERS + 1 ] [ 27 ] = { 0, ... } ;

new is_quest_used [ MAX_PLAYERS char ] ;

stock clear_player_quest ( playerid )
{
	is_quest_used { playerid } = 
	player_quest_progress { playerid } =
	player_quest_id { playerid } =
	player_quest_step { playerid } =
	player_quest_warning { playerid } = 0 ;
	
	player_quest_cooldown [ playerid ] = player_quest_cooldown [ MAX_PLAYERS ] ;
	
	quest_icon [ playerid ] [ 0 ] =
	quest_icon [ playerid ] [ 1 ] =
	quest_icon [ playerid ] [ 2 ] = -1 ;
	
	player_quest_vehicle_spawn { playerid } = 0 ;
	player_quest_vehicle [ playerid ] = INVALID_VEHICLE_ID ;
	
	player_quest [ playerid ] =
	player_quest_time [ playerid ] = 0 ;
	return 1 ;
}

CMD:exitquest ( playerid )
{
	if ( player_quest [ playerid ] == 0 ) return 1 ;
	quest_OnPlayerDisconnect ( playerid ) ;
	SendClientMessage ( playerid, col_red, !"Вы закончили выполнение квеста! Можете пройти его в любое время." ) ;
	return 1 ;
}

/*

	Остров (Жемчуг)
	
*/

new pearle_player_quest = 0 ;
new bool: pearle_quest_active = false ;
new pearle_pickup ;
new Text3D: pearle_text ;

new pearle_area [ 15 ] ;
new Float: pearle_position [ 15 ] [ 6 ] = // 953
{
	{ -2117.0979, -989.0664, 17.0689, 0.0000, 0.0000, -105.0000 },
	{ -2144.6398, -977.9166, 21.5725, 0.0000, 0.0000, 15.0000 },
	{ -2135.9484, -954.8655, 16.2896, 0.0000, 0.0000, -20.0000 },
	{ -2107.9008, -939.9106, 17.6642, 0.0000, 0.0000, 90.0000 },
	{ -2133.9733, -929.3045, 16.1889, 0.0000, 0.0000, -50.0000 },
	{ -2163.2800, -934.2246, 15.4002, 0.0000, 0.0000, 35.0000 },
	{ -2193.2023, -932.1349, 13.3566, 0.0000, 0.0000, -15.0000 },
	{ -2211.0195, -936.6353, 16.5360, 0.0000, 0.0000, 40.0000 },
	{ -2217.5393, -917.2340, 18.7176, 0.0000, 0.0000, -25.0000 },
	{ -2228.2773, -901.3948, 16.9973, 0.0000, 0.0000, 55.0000 },
	{ -2206.8942, -889.0131, 19.6926, 0.0000, 0.0000, -25.0000 },
	{ -2177.3193, -894.1143, 15.2725, 0.0000, 0.0000, -30.0000 },
	{ -2144.1655, -896.7028, 17.6852, 0.0000, 0.0000, 0.0000 },
	{ -2130.7431, -901.6591, 15.5465, 0.0000, 0.0000, -55.0000 },
	{ -2116.3557, -938.3288, 17.9237, 0.0000, 0.0000, -115.0000 }
} ;

stock create_player_pearle ( playerid )
{
	player_quest [ playerid ] = 26 ;
	
	player_quest_time [ playerid ] = 20 * 60 ;
	show_quest_ptd ( playerid, true ) ;
		
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Жемчуг\"{"#cWH"}! Время на прохождение квеста: 20 минут." ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Поговаривают, что эти места богаты жемчугом, попробуй и ты попытать удачу в его поисках!" ) ;
	SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;

	player_quest_step { playerid } = 0 ;
	player_quest_id { playerid } = 0 ;
	
	for ( new i = 0 ; i < sizeof pearle_position ; i ++ )
	{
		player_quest_area_used [ playerid ] [ i ] = false ;
	}

	player_quest_progress { playerid } = 0 ;
	
	new text_label [ 110 ] ;
	format ( text_label, sizeof text_label, "** Жемчуг **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", pearle_player_quest, ( pearle_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	UpdateDynamic3DTextLabelText ( pearle_text, col_header_3d, text_label ) ;
	return 1 ;
}

/*

	Остров (Черепахи)
	
*/

new turtle_player_quest = 0 ;
new bool: turtle_quest_active = false ;
new turtle_pickup ;
new Text3D: turtle_text ;

new Float: reefer_cable_attached [ 2 ] [ 6 ] = // 19087
{
	{ 0.031, 2.269, -0.789, 0.000, 0.000, 0.000 },
    { 0.038, -2.744, -0.789, 0.000, 0.000, 0.000 }
} ;

new Float: reefer_container_attached [ 6 ] = { 0.000, 0.000, -4.600, 0.000, 0.000, 0.000 } ; // 2932

new Float: reefer_turtle_attached [ 3 ] [ 6 ] = // 1609
{
	{ -0.163, 2.267, -4.677, 0.000, 2.000, 68.299 },
    { 0.051, -0.074, -4.609, 0.000, 2.000, -68.299 },
    { -0.046, -2.431, -4.693, 0.000, -2.000, 87.999 }
} ;

new bool: reefer_position_toggled [ 4 ] = { false, ... } ;
new Float: reefer_position [ 4 ] [ 4 ] =
{
	{ -2190.3776, -881.0839, 27.6488, 199.7418 },
	{ -2204.6176, -887.1255, 27.6473, 182.8044 },
	{ -2174.9514, -874.7570, 27.6480, 209.1236 },
	{ -2159.1179, -873.8884, 27.6492, 184.4821 }
} ;

new Float: turtles_position [ 8 ] [ 6 ] =
{
	{ -2169.2736, -905.9220, 22.5800, 0.0000, 0.0000, 0.0000 },
	{ -2132.6318, -915.2232, 26.3896, 0.0000, 0.0000, 0.0000 },
	{ -2109.3425, -949.0195, 23.5638, 0.0000, 0.0000, 0.0000 },
	{ -2102.3894, -1001.3137, 26.3951, 0.0000, 0.0000, 0.0000 },
	{ -2181.5092, -949.6612, 24.4974, 0.0000, 0.0000, -95.0000 },
	{ -2225.4719, -933.9519, 26.0469, 0.0000, 0.0000, 0.0000 },
	{ -2133.9077, -917.3197, 25.3374, 0.0000, 0.0000, 70.0000 },
	{ -2110.4987, -947.8549, 25.9607, 0.0000, 0.0000, 45.0000 }
} ;

stock create_player_turtle ( playerid )
{
	player_quest [ playerid ] = 25 ;
	
	player_quest_time [ playerid ] = 60 * 60 ;
	show_quest_ptd ( playerid, true ) ;
		
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Черепахи\"{"#cWH"}! Время на прохождение квеста: 60 минут." ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Берите лодку и отправляйтесь на место, где последний раз видели черепах." ) ;
	SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;
	
	for ( new i = 0 ; i < sizeof reefer_position ; i ++ )
	{
		if ( reefer_position_toggled [ i ] == true ) continue ;
		
		reefer_position_toggled [ i ] = true ;
		player_quest_vehicle_spawn { playerid } = i + 1 ;
		p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 453, reefer_position [ i ] [ 0 ], reefer_position [ i ] [ 1 ], reefer_position [ i ] [ 2 ], reefer_position [ i ] [ 3 ], 1, 1, -1 ) ;
		break ;
	}

	new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
	new engine, lights, alarm, doors, bonnet, boot, objective ;
	veh_info [ veh_id - 1 ] [ v_locked ] = false ;
	GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
			
	veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
	veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
	veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;

	new _count = 0 ;
	new _id = player_quest_vehicle_spawn { playerid } - 1 ;
	for ( new i = 0 ; i < sizeof reefer_cable_attached ; i ++ )
	{
		player_quest_vehicle_attached [ playerid ] [ i ] = CreateDynamicObject ( 19087, reefer_position [ _id ] [ 0 ], reefer_position [ _id ] [ 1 ], reefer_position [ _id ] [ 2 ], 0.0, 0.0, reefer_position [ _id ] [ 3 ] ) ;

		AttachDynamicObjectToVehicle( player_quest_vehicle_attached [ playerid ] [ i ], veh_id, reefer_cable_attached [ i ] [ 0 ],
																								reefer_cable_attached [ i ] [ 1 ],
																								reefer_cable_attached [ i ] [ 2 ],
																								reefer_cable_attached [ i ] [ 3 ],
																								reefer_cable_attached [ i ] [ 4 ],
																								reefer_cable_attached [ i ] [ 5 ] ) ;
																							
		_count ++ ;
	}
	
	player_quest_vehicle_attached [ playerid ] [ _count ] = CreateDynamicObject ( 2932, reefer_position [ _id ] [ 0 ], reefer_position [ _id ] [ 1 ], reefer_position [ _id ] [ 2 ], 0.0, 0.0, reefer_position [ _id ] [ 3 ] ) ;
	//SetDynamicObjectMaterial ( player_quest_vehicle_attached [ playerid ] [ _count ], 1, 13659, "8bars", "Upt_Fence_Mesh", 0 ) ;
	//SetDynamicObjectMaterial ( player_quest_vehicle_attached [ playerid ] [ _count ], 0, 13659, "8bars", "Upt_Fence_Mesh", 0 ) ;

	AttachDynamicObjectToVehicle( player_quest_vehicle_attached [ playerid ] [ _count ], veh_id, reefer_container_attached [ 0 ],
																									reefer_container_attached [ 1 ],
																									reefer_container_attached [ 2 ],
																									reefer_container_attached [ 3 ],
																									reefer_container_attached [ 4 ],
																									reefer_container_attached [ 5 ] ) ;
					
	player_quest_step { playerid } = 0 ;
	player_quest_id { playerid } = 0 ;

	is_quest_used { playerid } = 150 ;
	SetPlayerRaceCheckpoint ( playerid, 1, reefer_position [ _id ] [ 0 ], reefer_position [ _id ] [ 1 ], reefer_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		
	player_quest_progress { playerid } = 0 ;
	
	new text_label [ 110 ] ;
	format ( text_label, sizeof text_label, "** Черепахи **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", turtle_player_quest, ( turtle_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	UpdateDynamic3DTextLabelText ( turtle_text, col_header_3d, text_label ) ;
	return 1 ;
}

/*

	Ферма (Сбор фруктов)
	
*/

new fruit_player_quest = 0 ;
new bool: fruit_quest_active = false ;
new Text3D: fruit_text ;

new Float: fruit_pickup_position [ 3 ] = { 2229.8259, 1777.2456, 31.4645 } ;

new Float: fruit_position_unload [ 3 ] = { 1461.9035, 2021.6871, 21.0000 } ;
new Float: yosemite_vehicle_attached [ 8 ] [ 6 ] =
{
	{ 0.029, -2.359, -0.229, 0.000, -0.399, 89.600 },
    { 0.046, -1.768, -0.225, -0.500, 1.400, -90.100 },
    { 0.051, -1.148, -0.209, -0.500, -1.400, 90.100 },
    { 0.028, -2.353, -0.059, -0.500, 1.400, -90.100 },
    { 0.051, -1.753, -0.044, -0.500, -1.400, 90.100 },
    { 0.060, -1.153, -0.030, -0.500, 1.400, -90.100 },
    { 0.055, -2.303, 0.100, 0.500, -1.400, -0.299 },
    { 0.029, -1.303, 0.107, 0.500, 1.400, 0.299 }
} ;

new bool: yosemite_position_toggled [ 4 ] = { false, ... } ;
new Float: yosemite_position [ 4 ] [ 4 ] = 
{
	{ 2102.2678, 1825.8848, 31.1015, 206.5262 },
	{ 2097.3540, 1825.6737, 31.1016, 205.7419 },
	{ 2092.2966, 1824.6290, 31.1044, 203.0077 },
	{ 2087.0686, 1822.7822, 31.1058, 205.9695 }
} ;

new Float: yosemite_position_loaded [ 4 ] [ 3 ] =
{
	{ 2215.0192, 1784.1296, 31.1013 },
	{ 2208.4191, 1783.6082, 31.1021 },
	{ 2200.4968, 1783.9792, 31.1021 },
	{ 2193.6452, 1783.7287, 31.1044 }
} ;

new apple_in_tree_players [ 4 ] = { -1, ... } ;
new apple_in_tree_timer = -1 ;
new apple_in_tree_object [ 21 ] [ 10 ] ;
new apple_in_tree_area [ 21 ] ;
new bool: apple_in_tree_toggled [ 21 ] = { false, ... } ;
new Float: start_apple_position_in_tree [ 21 ] [ 6 ] =
{
	{ 2226.1406, 1767.7884, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2219.6970, 1756.8435, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2221.4550, 1732.1003, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2227.3649, 1702.3457, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2207.9616, 1713.7480, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2219.0263, 1722.1744, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2209.0000, 1735.8690, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2202.6291, 1742.3999, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2207.9880, 1760.4266, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2218.8107, 1715.7559, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2211.5839, 1698.3917, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2224.8427, 1741.4008, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2230.1911, 1724.4410, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2205.0053, 1727.4721, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2215.0922, 1770.4234, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2196.1669, 1730.0759, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2201.9096, 1706.4627, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2199.3359, 1689.7687, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2196.1687, 1717.9476, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2194.1901, 1745.8809, 32.6166, 0.0000, 0.0000, 0.0000 },
	{ 2213.2270, 1732.7766, 32.6166, 0.0000, 0.0000, 0.0000 }
} ;
new apple_in_tree_fruit [ 21 ] ;
new apple_in_tree_fruit_object [ 3 ] = { 19574, 19575, 19576 } ;
new apple_in_tree_box [ 4 ] = { 19638, 19636, 19637, 19639 } ;

stock create_player_fruit ( playerid )
{
	player_quest [ playerid ] = 18 ;
	
	player_quest_time [ playerid ] = 30 * 60 ;
	show_quest_ptd ( playerid, true ) ;
		
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Сбор фруктов\"{"#cWH"}! Время на прохождение квеста: 30 минут." ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Садитесь в машину для погрузки ящиков." ) ;
	SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;
	
	for ( new i = 0 ; i < sizeof yosemite_position ; i ++ )
	{
		if ( yosemite_position_toggled [ i ] == true ) continue ;
			
		yosemite_position_toggled [ i ] = true ;
		player_quest_vehicle_spawn { playerid } = i + 1 ;
		p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 554, yosemite_position [ i ] [ 0 ], yosemite_position [ i ] [ 1 ], yosemite_position [ i ] [ 2 ], yosemite_position [ i ] [ 3 ], 1, 1, -1 ) ;
		break ;
	}

	new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
	new engine, lights, alarm, doors, bonnet, boot, objective ;
	veh_info [ veh_id - 1 ] [ v_locked ] = false ;
	GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
				
	veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
	veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
	veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;
					
	player_quest_step { playerid } = 0 ;
	player_quest_id { playerid } = 0 ;

	new _id = player_quest_vehicle_spawn { playerid } - 1 ;
	is_quest_used { playerid } = 136 ;
	SetPlayerRaceCheckpoint ( playerid, 1, yosemite_position [ _id ] [ 0 ], yosemite_position [ _id ] [ 1 ], yosemite_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		
	player_quest_progress { playerid } = 0 ;
	
	new text_label [ 110 ] ;
	format ( text_label, sizeof text_label, "** Сбор фруктов **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", fruit_player_quest, ( fruit_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	UpdateDynamic3DTextLabelText ( fruit_text, col_header_3d, text_label ) ;
	return 1 ;
}

callback: callback_collect_fruit ( playerid, _tree_id )
{
	apple_in_tree_toggled [ _tree_id ] = false ;
	for ( new i = 0 ; i < 10 ; i ++ )
	{
		if ( IsValidDynamicObject ( apple_in_tree_object [ _tree_id ] [ i ] ) ) DestroyDynamicObject ( apple_in_tree_object [ _tree_id ] [ i ] ) ;
	}
	
	new _box_id ;
	switch ( apple_in_tree_fruit [ _tree_id ] )
	{
		case 19574: _box_id = apple_in_tree_box [ 0 ], player_quest_id { playerid } = 1 ;
		case 19575: _box_id = apple_in_tree_box [ 1 ], player_quest_id { playerid } = 2 ;
		case 19576: _box_id = apple_in_tree_box [ 2 ], player_quest_id { playerid } = 3 ;
	}

	ClearAnimations ( playerid ) ;
	SetPlayerAttachedObject ( playerid, 0, _box_id, 6, 0.0, 0.10, -0.2, -110.0, 0.0, 0.0 ) ;
  	ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
	p_t_info [ playerid ] [ p_animation ] = true ;
	
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Теперь Вам необходимо положить ящик в машину." ) ;
	
	new Float:boot_pos [ 3 ] ;
	GetCoordBootVehicle ( p_t_info [ playerid ] [ pl_quest ], boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ) ;
	
	is_quest_used { playerid } = 138 ;
	SetPlayerRaceCheckpoint ( playerid, 1, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
	return 1 ;
}

callback: callback_apple_in_tree ( )
{
	new bool: _players = false ;
	for ( new i = 0 ; i < sizeof apple_in_tree_players ; i ++ )
	{
		if ( apple_in_tree_players [ i ] == -1 ) continue ;
		
		new playerid = apple_in_tree_players [ i ] ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Созрело дерево с фруктами. Успейте собрать первым!" ) ;
		
		_players = true ;
	}
	
	if ( _players ) create_apple_in_tree ( ) ;
	else 
	{
		KillTimer ( apple_in_tree_timer ) ;
		apple_in_tree_timer = -1 ;
		
		for ( new d = 0 ; d < sizeof start_apple_position_in_tree ; d ++ )
		{
			apple_in_tree_toggled [ d ] = false ;
			if ( IsValidDynamicArea ( apple_in_tree_area [ d ] ) ) DestroyDynamicArea ( apple_in_tree_area [ d ] ) ;
			for ( new i = 0 ; i < 10 ; i ++ )
			{
				if ( IsValidDynamicObject ( apple_in_tree_object [ d ] [ i ] ) ) DestroyDynamicObject ( apple_in_tree_object [ d ] [ i ] ) ;
			}
		}
	}
	return 1 ;
}

stock create_apple_in_tree ( )
{
	new _random, _count = 0 ;
	do
	{
		_random = random ( sizeof start_apple_position_in_tree ) ;
		_count ++ ;
	}
	while ( apple_in_tree_toggled [ _random ] == true && _count < 10 ) ;
	
	if ( apple_in_tree_toggled [ _random ] == true ) return 1 ;
	
	apple_in_tree_toggled [ _random ] = true ;
	apple_in_tree_fruit [ _random ] = apple_in_tree_fruit_object [ random ( 3 ) ] ;
	for ( new i = 0 ; i < 10 ; i ++ )
	{
		apple_in_tree_object [ _random ] [ i ] = CreateDynamicObject(apple_in_tree_fruit [ _random ], start_apple_position_in_tree [ _random ] [ 0 ] + float ( - random ( 2 ) + random ( 2 ) ), 
																										start_apple_position_in_tree [ _random ] [ 1 ] + float ( - random ( 2 ) + random ( 2 ) ), 
																										start_apple_position_in_tree [ _random ] [ 2 ] + random ( 3 ), 0.000000, 0.000000, 0.000000);
	}
	
	apple_in_tree_area [ _random ] = CreateDynamicSphere ( start_apple_position_in_tree [ _random ] [ 0 ], start_apple_position_in_tree [ _random ] [ 1 ], start_apple_position_in_tree [ _random ] [ 2 ], 3.0, -1, -1, -1 ) ;
	area_info [ apple_in_tree_area [ _random ] ] [ a_type ] = area_type_apple_in_tree ;
	return 1 ;
}

/*

	Ферма (Кормление коров)
	
*/

new cow_food_player_quest = 0 ;
new bool: cow_food_quest_active = false ;
new Text3D: cow_food_text ;

new Float: bobcat_vehicle_attached [ 6 ] [ 6 ] = // 2060
{
	{ -0.230, -1.121, -0.230, 0.000, 0.000, 89.700 },
    { 0.240, -1.111, -0.230, 0.000, 0.000, -89.700 },
    { -0.240, -1.111, 0.039, 0.000, 0.000, 89.700 },
    { 0.240, -1.111, 0.039, 0.000, 0.000, -89.700 },
    { -0.027, -2.066, -0.150, 0.000, 0.000, -175.800 },
    { 0.027, -2.066, 0.059, 0.000, 0.000, 175.800 }
} ;

new Float: bobcat_loaded [ 3 ] = { 1462.4812, 2012.1762, 21.0000 } ;
new Float: bobcat_unloaded [ 3 ] = { 1398.8669, -996.3434, 21.0000 } ;

new bool: bobcat_position_toggled [ 4 ] = { false, ... } ;
new Float: bobcat_position [ 4 ] [ 4 ] = 
{
	{ 1388.6352, -1012.5374, 20.9807, 63.1900 },
	{ 1388.8808, -1017.9045, 20.9850, 65.9703 },
	{ 1389.1408, -1023.7773, 20.9916, 66.0982 },
	{ 1389.4887, -1030.0262, 20.9908, 68.5607 }
} ;

new Float: cow_food_position [ 10 ] [ 3 ] =
{
	{ 1397.3552, -1003.0787, 21.0684 },
	{ 1397.6250, -1006.1762, 21.0684 },
	{ 1397.9245, -1009.6195, 21.0684 },
	{ 1398.2113, -1012.8884, 21.0684 },
	{ 1398.4895, -1016.0540, 21.0684 },
	{ 1398.7818, -1019.4107, 21.0696 },
	{ 1399.0625, -1022.5996, 21.0696 },
	{ 1399.3605, -1026.0466, 21.0697 },
	{ 1399.6297, -1029.0559, 21.0696 },
	{ 1399.9158, -1032.3435, 21.0696 }
} ;

new Float: pick_bag_cow_food [ 3 ] = { 1404.8720, -1010.0371, 21.5152 } ;

stock create_player_cow_food ( playerid )
{
	player_quest [ playerid ] = 17 ;
	
	player_quest_time [ playerid ] = 20 * 60 ;
	show_quest_ptd ( playerid, true ) ;
		
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Кормление коров\"{"#cWH"}! Время на прохождение квеста: 20 минут." ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Животные на ферме проголодались, надо их покормить. Возьмите машину и отправляйтесь на склад за комбикормом." ) ;
	SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;
	
	for ( new i = 0 ; i < sizeof bobcat_position ; i ++ )
	{
		if ( bobcat_position_toggled [ i ] == true ) continue ;
			
		bobcat_position_toggled [ i ] = true ;
		player_quest_vehicle_spawn { playerid } = i + 1 ;
		p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 422, bobcat_position [ i ] [ 0 ], bobcat_position [ i ] [ 1 ], bobcat_position [ i ] [ 2 ], bobcat_position [ i ] [ 3 ], 1, 1, -1 ) ;
		break ;
	}

	new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
	new engine, lights, alarm, doors, bonnet, boot, objective ;
	veh_info [ veh_id - 1 ] [ v_locked ] = false ;
	GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
				
	veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
	veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
	veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;
					
	player_quest_step { playerid } = 0 ;

	new _id = player_quest_vehicle_spawn { playerid } - 1 ;
	is_quest_used { playerid } = 130 ;
	SetPlayerRaceCheckpoint ( playerid, 1, bobcat_position [ _id ] [ 0 ], bobcat_position [ _id ] [ 1 ], bobcat_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		
	player_quest_progress { playerid } = 0 ;
	
	new text_label [ 110 ] ;
	format ( text_label, sizeof text_label, "** Кормление коров **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", cow_food_player_quest, ( cow_food_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	UpdateDynamic3DTextLabelText ( cow_food_text, col_header_3d, text_label ) ;
	return 1 ;
}

/*

	Ферма (Мясокомбинат)
	
	
	туша на верёвке - 2589
	первый объект для мува - 2806
	второй объект для мува - 2804
	эффект дыма - 18671
	
*/

new move_max_playerid [ 4 ] = { -1, ... } ;

new meat_player_quest = 0 ;
new bool: meat_quest_active = false ;
new Text3D: meat_text ;

new Float: meat_position [ 12 ] [ 3 ] =
{
	{ 956.02777, 2143.88062, 1016.28296 },
	{ 956.02777, 2140.52832, 1016.28302 },
	{ 956.02777, 2136.47949, 1016.28302 },
	{ 962.55151, 2143.88062, 1016.28302 },
	{ 962.55151, 2140.52832, 1016.28302 },
	{ 962.55151, 2136.47949, 1016.28302 },
	{ 956.02777, 2132.65234, 1016.28302 },
	{ 956.02777, 2128.77881, 1016.28302 },
	{ 956.02777, 2124.58960, 1016.28302 },
	{ 962.55151, 2132.65234, 1016.28302 },
	{ 962.57562, 2128.77881, 1016.28302 },
	{ 962.55151, 2124.58960, 1016.28302 }
} ;

new Float: cow_factory_position [ 12 ] [ 6 ] =
{
	{ 957.84430, 2143.49756, 1009.99335,   0.00000, 0.00000, 5.40000 },
	{ 959.36902, 2140.60815, 1009.99335,   0.00000, 0.00000, 5.40000 },
	{ 954.15674, 2140.27979, 1009.99335,   0.00000, 0.00000, 5.40000 },
	{ 963.89612, 2139.22607, 1009.99335,   0.00000, 0.00000, 5.40000 },
	{ 963.47485, 2144.38623, 1009.99335,   0.00000, 0.00000, 5.40000 },
	{ 960.55902, 2137.31860, 1009.99335,   0.00000, 0.00000, 5.40000 },
	{ 957.77209, 2133.78467, 1009.99335,   0.00000, 0.00000, 5.40000 },
	{ 954.05310, 2129.33154, 1009.99335,   0.00000, 0.00000, 5.40000 },
	{ 957.73999, 2128.37720, 1009.99335,   0.00000, 0.00000, 5.40000 },
	{ 961.02832, 2126.66968, 1009.99335,   0.00000, 0.00000, 5.40000 },
	{ 963.51929, 2131.67285, 1009.99335,   0.00000, 0.00000, 5.40000 },
	{ 963.67786, 2127.02344, 1009.99335,   0.00000, 0.00000, 5.40000 }
} ;

new Float: move_big_meat_factory [ 2 ] [ 6 ] = 
{
	{ 942.34003, 2118.76709, 1011.24097,   0.00000, 0.00000, -66.06000 },
	{ 942.38647, 2120.99292, 1011.24097,   0.00000, 0.00000, -66.06000 }
} ;

new Float: move_smol_meat_factory [ 4 ] [ 6 ] = 
{
	{ 942.32440, 2124.45117, 1011.29663,   0.00000, 0.00000, -68.03998 },
	{ 942.32440, 2123.81104, 1011.29657,   0.00000, 0.00000, -68.04000 },
	{ 942.32440, 2136.77246, 1011.29657,   0.00000, 0.00000, -68.04000 },
	{ 942.32440, 2136.21997, 1011.29657,   0.00000, 0.00000, -68.04000 }
} ;

new Float: move_smol_meat_factory_box [ 4 ] [ 6 ] = 
{
	{ 942.32440, 2154.21826, 1011.22650,   0.00000, 0.00000, -68.04000 },
	{ 942.32440, 2154.78101, 1011.22650,   0.00000, 0.00000, -68.04000 },
	{ 942.32440, 2158.61670, 1011.22650,   0.00000, 0.00000, -68.04000 },
	{ 942.32440, 2159.20850, 1011.22650,   0.00000, 0.00000, -68.04000 }
} ;

new Float: move_box_meat_factory [ 2 ] [ 6 ] = // 2969
{
	{ 942.35321, 2160.10596, 1011.26459,   0.00000, 0.00000, 0.00000 },
	{ 942.35321, 2172.49463, 1011.26459,   0.00000, 0.00000, 0.00000 }
} ;

new Float: pickup_meat_factory [ 6 ] [ 3 ] = 
{
	{ 953.7387, 2120.5420, 1011.0234 },
	{ 942.4282, 2117.9021, 1011.0303 },
	{ 942.3623, 2137.2947, 1011.0234 },
	{ 942.4485, 2153.7461, 1011.0234 },
	{ 942.2971, 2173.1387, 1011.0234 },
	{ 948.7299, 2168.9336, 1011.0303 }
} ;

new bool: dft_meat_toggled [ 4 ] = { false, ... } ;
new Float: dft_meat_position [ 4 ] [ 4 ] =
{
	{ 1305.0625, -946.4295, 21.6255, 230.4944 },
	{ 1295.6241, -946.4601, 21.6251, 225.2146 },
	{ 1287.5931, -946.6533, 21.6252, 220.6678 },
	{ 1279.3671, -947.3677, 21.6249, 218.8096 }
} ;

new Float: dft_meat_attached_fence [ 3 ] [ 6 ] =
{
	{ -1.511, -2.612, 0.780, 0.000, 0.000, 0.000 }, // 8167
    { 1.331, -2.612, 0.780, 0.000, 0.000, 0.000 }, // 8167
    { -0.003, -5.334, 0.870, 0.000, 90.399, 0.000 } // 3278
} ;

new Float: dft_meat_cow_attached [ 3 ] [ 6 ] = // 19833
{
	{ 0.038, 0.784, -0.290, 0.000, 0.000, -69.599 },
    { 0.110, -1.423, -0.290, 0.000, 0.000, 69.599 },
    { -0.104, -3.655, -0.290, 0.000, 0.000, -89.000 }
} ;

new Float: cow_field_position [ 8 ] [ 6 ] = // 19833
{
	{ 2146.6110, 1711.5476, 30.4333, 0.0000, 0.0000, 0.0000},
	{ 2164.3840, 1704.5408, 30.4333, 0.0000, 0.0000, 0.0000 },
	{ 2175.5932, 1712.0812, 30.4333, 0.0000, 0.0000, 0.0000 },
	{ 2179.2268, 1730.5001, 30.4333, 0.0000, 0.0000, 0.0000 },
	{ 2165.1916, 1733.6560, 30.4333, 0.0000, 0.0000, 0.0000 },
	{ 2148.3774, 1730.6759, 30.4333, 0.0000, 0.0000, 0.0000 },
	{ 2175.1320, 1755.5811, 30.4333, 0.0000, 0.0000, 0.0000 },
	{ 2156.3549, 1763.9462, 30.4333, 0.0000, 0.0000, 0.0000 }
} ;

new Float: meat_factory_position [ 3 ] = { 1429.0568, 1991.6402, 21.0000 } ;
new Float: pick_saw_factory [ 3 ] = { 960.8913, 2099.4424, 1011.0248 } ;

stock create_player_meat ( playerid )
{
	player_quest [ playerid ] = 16 ;
	
	player_quest_time [ playerid ] = 20 * 60 ;
	show_quest_ptd ( playerid, true ) ;
		
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Мясокомбинат\"{"#cWH"}! Время на прохождение квеста: 20 минут." ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Возьмите машину и отправляйтесь собирать коров." ) ;
	SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;
	
	for ( new i = 0 ; i < sizeof dft_meat_position ; i ++ )
	{
		if ( dft_meat_toggled [ i ] == true ) continue ;
			
		dft_meat_toggled [ i ] = true ;
		player_quest_vehicle_spawn { playerid } = i + 1 ;
		p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 578, dft_meat_position [ i ] [ 0 ], dft_meat_position [ i ] [ 1 ], dft_meat_position [ i ] [ 2 ], dft_meat_position [ i ] [ 3 ], 1, 1, -1 ) ;
		break ;
	}

	new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
	new engine, lights, alarm, doors, bonnet, boot, objective ;
	veh_info [ veh_id - 1 ] [ v_locked ] = false ;
	GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
				
	veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
	veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
	veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;
					
	player_quest_step { playerid } = 0 ;
		
	new _id = player_quest_vehicle_spawn { playerid } - 1 ;
	for ( new i = 0 ; i < sizeof dft_meat_attached_fence ; i ++ )
	{
		if ( i == 2 ) player_quest_vehicle_attached [ playerid ] [ i ] = CreateDynamicObject ( 3278, dft_meat_position [ _id ] [ 0 ], dft_meat_position [ _id ] [ 1 ], dft_meat_position [ _id ] [ 2 ], 0.0, 0.0, dft_meat_position [ _id ] [ 3 ] ) ;
		else player_quest_vehicle_attached [ playerid ] [ i ] = CreateDynamicObject ( 8167, dft_meat_position [ _id ] [ 0 ], dft_meat_position [ _id ] [ 1 ], dft_meat_position [ _id ] [ 2 ], 0.0, 0.0, dft_meat_position [ _id ] [ 3 ] ) ;

		AttachDynamicObjectToVehicle( player_quest_vehicle_attached [ playerid ] [ i ], veh_id, dft_meat_attached_fence [ i ] [ 0 ],
																								dft_meat_attached_fence [ i ] [ 1 ],
																								dft_meat_attached_fence [ i ] [ 2 ],
																								dft_meat_attached_fence [ i ] [ 3 ],
																								dft_meat_attached_fence [ i ] [ 4 ],
																								dft_meat_attached_fence [ i ] [ 5 ] ) ;
	}
		
	is_quest_used { playerid } = 126 ;
	SetPlayerRaceCheckpoint ( playerid, 1, dft_meat_position [ _id ] [ 0 ], dft_meat_position [ _id ] [ 1 ], dft_meat_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		
	player_quest_progress { playerid } = 0 ;
	
	new text_label [ 110 ] ;
	format ( text_label, sizeof text_label, "** Мясокомбинат **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", meat_player_quest, ( meat_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	UpdateDynamic3DTextLabelText ( meat_text, col_header_3d, text_label ) ;
	return 1 ;
}

callback: callback_meat_factory ( playerid )
{
	new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
	
	DestroyDynamicObject ( veh_info [ veh_id - 1 ] [ v_cargo_object ] [ player_quest_progress { playerid } ] ) ;
	veh_info [ veh_id - 1 ] [ v_cargo_object ] [ player_quest_progress { playerid } ] = INVALID_OBJECT_ID ;
		
	new _id = player_quest_vehicle_spawn { playerid } - 1 ;
	new _step = ( _id * 3 ) + player_quest_progress { playerid } ;
	veh_info [ veh_id - 1 ] [ v_cargo_object ] [ player_quest_progress { playerid } ] = CreateDynamicObject ( 2589, meat_position [ _step ] [ 0 ], meat_position [ _step ] [ 1 ], meat_position [ _step ] [ 2 ], 0.0, 0.0, 0.0 ) ;
	
	p_t_info [ playerid ] [ p_animation ] = false ;
	
	player_quest_progress { playerid } ++ ;
	if ( player_quest_progress { playerid } >= 3 )
	{
		player_quest_progress { playerid } = 0 ;
	
		player_quest_pickup [ playerid ] [ 0 ] = CreateDynamicPickup ( 1239, 23, pickup_meat_factory [ 0 ] [ 0 ], pickup_meat_factory [ 0 ] [ 1 ], pickup_meat_factory [ 0 ] [ 2 ], GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ), playerid ) ;
		pick_info [ player_quest_pickup [ playerid ] [ 0 ] ] [ pick_type ] = pick_type_meat ;
				
		player_quest_pickup [ playerid ] [ 1 ] = CreateDynamicPickup ( 1239, 23, pickup_meat_factory [ 1 ] [ 0 ], pickup_meat_factory [ 1 ] [ 1 ], pickup_meat_factory [ 1 ] [ 2 ], GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ), playerid ) ;
		pick_info [ player_quest_pickup [ playerid ] [ 1 ] ] [ pick_type ] = pick_type_meat_use_factory ;
		
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы сделали заготовки. Теперь необходима конвеерная обработка." ) ;
		
		RemoveWeaponFromSlot ( playerid, get_weapon_slot ( 9 ) ) ;
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
	}
	else
	{
		is_quest_used { playerid } = 128 ;
		_step = ( _id * 3 ) + player_quest_progress { playerid } ;
		SetPlayerRaceCheckpoint ( playerid, 1, cow_factory_position [ _step ] [ 0 ], cow_factory_position [ _step ] [ 1 ], cow_factory_position [ _step ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
	}
	return 1 ;
}

stock quest_OnDynamicObjectMoved ( objectid )
{
	for ( new i = 0 ; i < sizeof move_max_playerid ; i ++ )
	{
		new playerid = move_max_playerid [ i ] ;
		if ( playerid == -1 ) continue ;
		if ( player_quest_object [ playerid ] [ 0 ] == objectid )
		{
			new Float: object_x,
				Float: object_y,
				Float: object_z,
				index = -1,
				type_meat = 0 ;
			
			GetDynamicObjectPos ( player_quest_object [ playerid ] [ 0 ], object_x, object_y, object_z ) ;
			if ( player_quest_step { playerid } == 1 )
			{
				index = object_y == move_big_meat_factory [ 1 ] [ 1 ] ? 0 : 1 ;
				
				type_meat = 1 ;
			}
			else if ( player_quest_step { playerid } == 2 )
			{
				index = object_y == move_smol_meat_factory [ 2 ] [ 1 ] ? 0 : 1 ;
				
				type_meat = 2 ;
			}
			else if ( player_quest_step { playerid } == 3 )
			{
				index = object_y == move_smol_meat_factory_box [ 2 ] [ 1 ] ? 0 : 1 ;
				
				type_meat = 3 ;
			}
			else if ( player_quest_step { playerid } == 4 )
			{
				index = object_y == move_box_meat_factory [ 1 ] [ 1 ] ? 0 : 1 ;
				
				type_meat = 4 ;
			}
			
			if ( ! index )
			{
				if ( IsValidDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ) StopDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
				if ( IsValidDynamicObject ( player_quest_object [ playerid ] [ 1 ] ) ) StopDynamicObject ( player_quest_object [ playerid ] [ 1 ] ) ;

				if ( type_meat == 1 )
				{
					DestroyDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
					
					player_quest_object [ playerid ] [ 0 ] = CreateDynamicObject ( 2804, move_smol_meat_factory [ 0 ] [ 0 ], move_smol_meat_factory [ 0 ] [ 1 ], move_smol_meat_factory [ 0 ] [ 2 ],
																						move_smol_meat_factory [ 0 ] [ 3 ], move_smol_meat_factory [ 0 ] [ 4 ], move_smol_meat_factory [ 0 ] [ 5 ] ) ;
																					
					MoveDynamicObject ( player_quest_object [ playerid ] [ 0 ], move_smol_meat_factory [ 2 ] [ 0 ], move_smol_meat_factory [ 2 ] [ 1 ], move_smol_meat_factory [ 2 ] [ 2 ], 1.0,
																				move_smol_meat_factory [ 2 ] [ 3 ], move_smol_meat_factory [ 2 ] [ 4 ], move_smol_meat_factory [ 2 ] [ 5 ] ) ;
																					
					player_quest_object [ playerid ] [ 1 ] = CreateDynamicObject ( 2804, move_smol_meat_factory [ 1 ] [ 0 ], move_smol_meat_factory [ 1 ] [ 1 ], move_smol_meat_factory [ 1 ] [ 2 ],
																						move_smol_meat_factory [ 1 ] [ 3 ], move_smol_meat_factory [ 1 ] [ 4 ], move_smol_meat_factory [ 1 ] [ 5 ] ) ;
																						
					MoveDynamicObject ( player_quest_object [ playerid ] [ 1 ], move_smol_meat_factory [ 3 ] [ 0 ], move_smol_meat_factory [ 3 ] [ 1 ], move_smol_meat_factory [ 3 ] [ 2 ], 1.0,
																				move_smol_meat_factory [ 3 ] [ 3 ], move_smol_meat_factory [ 3 ] [ 4 ], move_smol_meat_factory [ 3 ] [ 5 ] ) ;
				
					player_quest_step { playerid } = 2 ;
				}
				else if ( type_meat == 2 )
				{
					player_quest_selector { playerid } = 0 ;
				
					player_quest_pickup [ playerid ] [ 1 ] = CreateDynamicPickup ( 2804, 23, pickup_meat_factory [ 2 ] [ 0 ], pickup_meat_factory [ 2 ] [ 1 ], pickup_meat_factory [ 2 ] [ 2 ], GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ), playerid ) ;
					pick_info [ player_quest_pickup [ playerid ] [ 1 ] ] [ pick_type ] = pick_type_meat_loader ;
					
					player_quest_pickup [ playerid ] [ 2 ] = CreateDynamicPickup ( 2804, 23, pickup_meat_factory [ 3 ] [ 0 ], pickup_meat_factory [ 3 ] [ 1 ], pickup_meat_factory [ 3 ] [ 2 ], GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ), playerid ) ;
					pick_info [ player_quest_pickup [ playerid ] [ 2 ] ] [ pick_type ] = pick_type_meat_unloader ;
				
					player_quest_step { playerid } = 3 ;
				}
				else if ( type_meat == 3 )
				{
					DestroyDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
					DestroyDynamicObject ( player_quest_object [ playerid ] [ 1 ] ) ;
					
					player_quest_object [ playerid ] [ 0 ] = CreateDynamicObject ( 2969, move_box_meat_factory [ 0 ] [ 0 ], move_box_meat_factory [ 0 ] [ 1 ], move_box_meat_factory [ 0 ] [ 2 ],
																						move_box_meat_factory [ 0 ] [ 3 ], move_box_meat_factory [ 0 ] [ 4 ], move_box_meat_factory [ 0 ] [ 5 ] ) ;
				
					MoveDynamicObject ( player_quest_object [ playerid ] [ 0 ], move_box_meat_factory [ 1 ] [ 0 ], move_box_meat_factory [ 1 ] [ 1 ], move_box_meat_factory [ 1 ] [ 2 ], 1.0,
																				move_box_meat_factory [ 1 ] [ 3 ], move_box_meat_factory [ 1 ] [ 4 ], move_box_meat_factory [ 1 ] [ 5 ] ) ;
				
					player_quest_step { playerid } = 4 ;
				}
				else if ( type_meat == 4 )
				{
					player_quest_selector { playerid } = 0 ;
				
					player_quest_pickup [ playerid ] [ 1 ] = CreateDynamicPickup ( 3013, 23, pickup_meat_factory [ 4 ] [ 0 ], pickup_meat_factory [ 4 ] [ 1 ], pickup_meat_factory [ 4 ] [ 2 ], GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ), playerid ) ;
					pick_info [ player_quest_pickup [ playerid ] [ 1 ] ] [ pick_type ] = pick_type_meat_loader ;
					
					player_quest_pickup [ playerid ] [ 2 ] = CreateDynamicPickup ( 3013, 23, pickup_meat_factory [ 5 ] [ 0 ], pickup_meat_factory [ 5 ] [ 1 ], pickup_meat_factory [ 5 ] [ 2 ], GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ), playerid ) ;
					pick_info [ player_quest_pickup [ playerid ] [ 2 ] ] [ pick_type ] = pick_type_meat_unloader ;
				
					move_max_playerid [ i ] = -1 ;
				}
			}
		}
		return 1 ;
	}
	return 0 ;
}

/*

	Ферма (фермер)
	
*/

new farmer_player_quest [ 3 ] = { 0, ... } ;
new bool: farmer_quest_active [ 3 ] = { false, ... } ;
new Text3D: farmer_text ;

new bool: farmer_tractor_toggled [ 4 ] = { false, ... } ;
new Float: farmer_tractor_position [ 4 ] [ 4 ] =
{
	{ 1296.4306, -855.9399, 20.9647, 222.4154 },
	{ 1293.1087, -858.4613, 20.9632, 215.7619 },
	{ 1289.5484, -861.0039, 20.9661, 213.9468 },
	{ 1285.4129, -862.9534, 20.9674, 209.1145 }
} ;

new bool: farmer_camel_toggled [ 4 ] = { false, ... } ;
new Float: farmer_camel_position [ 4 ] [ 4 ] =
{
	{ 1424.3168, -919.8383, 21.5656, 51.4841 },
	{ 1423.1746, -931.8274, 21.5685, 62.7603 },
	{ 1423.3609, -943.1787, 21.5712, 74.5379 },
	{ 1423.5601, -953.8541, 21.5597, 79.1399 }
} ;

new bool: farmer_walton_toggled [ 4 ] = { false, ... } ;
new Float: farmer_walton_position [ 4 ] [ 4 ] =
{
	{ 1296.8696, -886.6594, 20.9965, 329.3031 },
	{ 1302.3542, -887.5381, 20.9980, 356.8489 },
	{ 1308.4505, -887.5774, 20.9957, 359.3426 },
	{ 1313.8203, -886.1711, 20.9992, 18.2325 }
} ;

new Float: farmer_tractor_checkpoint [ 40 ] [ 3 ] =
{
	{ 1327.5108, -815.7138, 21.4355 },
	{ 1337.5335, -815.8486, 21.4706 },
	{ 1357.2667, -815.5618, 21.4552 },
	{ 1381.6289, -815.9221, 21.4627 },
	{ 1402.3507, -816.2090, 21.4580 },
	{ 1413.4643, -825.1135, 21.4274 },
	{ 1398.4182, -825.0463, 21.4238 },
	{ 1376.3939, -824.9212, 21.4185 },
	{ 1347.2353, -824.7213, 21.4209 },
	{ 1330.9530, -824.5885, 21.4223 },
	{ 1326.6492, -834.2944, 21.4470 },
	{ 1344.3823, -834.3154, 21.4727 },
	{ 1368.2144, -834.4039, 21.4645 },
	{ 1392.6362, -834.7700, 21.4609 },
	{ 1409.9482, -835.1260, 21.4673 },
	{ 1416.1473, -840.2796, 21.4675 },
	{ 1405.4771, -840.1432, 21.4974 },
	{ 1380.8909, -839.5214, 21.5053 },
	{ 1346.9394, -839.3004, 21.5055 },
	{ 1331.0374, -839.0925, 21.4916 },
	{ 1327.0220, -849.8165, 21.4110 },
	{ 1336.9827, -849.8420, 21.4136 },
	{ 1353.4410, -849.8015, 21.4126 },
	{ 1378.6589, -849.8245, 21.4131 },
	{ 1406.3734, -850.2192, 21.4230 },
	{ 1415.9010, -855.5894, 21.4641 },
	{ 1407.9779, -855.7147, 21.4900 },
	{ 1381.4721, -855.2265, 21.4829 },
	{ 1359.0759, -855.0955, 21.4822 },
	{ 1334.1546, -855.2133, 21.4848 },
	{ 1326.8276, -865.2870, 21.4179 },
	{ 1347.4084, -865.4451, 21.4323 },
	{ 1376.7431, -865.6975, 21.4183 },
	{ 1401.3414, -865.7026, 21.4189 },
	{ 1414.4780, -866.0979, 21.4125 },
	{ 1417.9333, -875.1147, 21.4568 },
	{ 1403.7478, -875.0821, 21.4777 },
	{ 1378.4150, -875.1448, 21.4846 },
	{ 1348.8721, -875.2983, 21.4864 },
	{ 1330.8648, -875.4116, 21.4699 }
} ;

new Float: farmer_camel_checkpoint [ 24 ] [ 3 ] =
{
	{ 1432.0166, -864.1248, 111.6704 },
	{ 1389.7109, -707.4797, 132.3742 },
	{ 1289.9810, -771.6718, 121.6560 },
	{ 1198.1584, -852.6813, 109.8840 },
	{ 1233.4753, -957.2922, 108.4955 },
	{ 1354.5072, -962.9680, 78.6288 },
	{ 1442.3896, -944.9121, 77.7159 },
	{ 1464.2745, -859.8270, 77.5938 },
	{ 1397.5849, -859.9044, 91.6403 },
	{ 1301.2087, -856.5836, 86.7032 },
	{ 1279.3356, -701.2278, 133.6757 },
	{ 1436.3400, -655.2549, 126.3119 },
	{ 1602.0699, -656.2810, 134.6245 },
	{ 1823.5645, -736.5761, 137.3550 },
	{ 1597.3835, -953.1561, 100.8314 },
	{ 1438.1342, -945.9804, 87.1236 },
	{ 1359.9317, -1010.0116, 92.7697 },
	{ 1271.2919, -1000.8839, 97.2392 },
	{ 1265.8631, -901.1144, 92.7135 },
	{ 1381.5200, -864.9625, 64.3684 },
	{ 1345.1536, -805.1805, 56.4813 },
	{ 1265.2794, -902.0889, 87.5476 },
	{ 1328.2542, -925.2454, 64.1933 },
	{ 1431.8884, -938.3923, 60.7322 }
} ;

new Float: farmer_pumpkin_position [ 29 ] [ 3 ] = // 19320
{
	{ 1332.4324, -815.9453, 20.7738 },
	{ 1340.4829, -824.2122, 20.7738 },
	{ 1348.1018, -815.4743, 20.7738 },
	{ 1364.0866, -824.9579, 20.7738 },
	{ 1377.0227, -816.0560, 20.7738 },
	{ 1398.1547, -816.1274, 20.7738 },
	{ 1410.7019, -825.0270, 20.7738 },
	{ 1401.8591, -824.9798, 20.7738 },
	{ 1401.1450, -834.9738, 20.7738 },
	{ 1406.3609, -835.0898, 20.7738 },
	{ 1386.6925, -839.2921, 20.7738 },
	{ 1400.1126, -840.1855, 20.7738 },
	{ 1412.2061, -840.1668, 20.7738 },
	{ 1364.6942, -839.2217, 20.7738 },
	{ 1350.0778, -849.5113, 20.7738 },
	{ 1330.9331, -849.8490, 20.7738 },
	{ 1348.1286, -854.8198, 20.7738 },
	{ 1338.1384, -854.8343, 20.7738 },
	{ 1372.0040, -855.2792, 20.7738 },
	{ 1391.2764, -855.1530, 20.7738 },
	{ 1411.8233, -855.5340, 20.7738 },
	{ 1409.8948, -865.9326, 20.7738 },
	{ 1397.5311, -866.1456, 20.7738 },
	{ 1360.6120, -865.5863, 20.7738 },
	{ 1337.7009, -865.4625, 20.7738 },
	{ 1330.9074, -865.4064, 20.7738 },
	{ 1345.9016, -875.3123, 20.7738 },
	{ 1360.3413, -875.1893, 20.7738 },
	{ 1371.0341, -875.4047, 20.7738 }
} ;

new Float: farmer_walton_field_position [ 4 ] [ 3 ] =
{
	{ 1339.4788, -913.4696, 20.9953 },
	{ 1343.3576, -913.4876, 20.9951 },
	{ 1347.7038, -913.5844, 20.9885 },
	{ 1352.0998, -913.6013, 20.9913 }
} ;

new Float: farmer_pumpkin_attached [ 7 ] [ 6 ] =
{
	{ 0.650, -2.211, 0.230, 0.000, 0.000, 0.000 },
    { -0.069, -2.201, 0.230, 0.000, 0.000, 0.000 },
    { -0.630, -1.681, 0.230, 0.000, 0.000, 0.000 },
    { 0.630, -1.380, 0.230, 0.000, 0.000, 0.000 },
    { -0.610, -0.870, 0.230, 0.000, 0.000, 0.000 },
    { -0.628, -2.100, 0.530, 0.000, 0.000, 0.000 },
    { 0.278, -2.180, 0.570, 0.000, 0.000, 0.000 }
} ;

new Float: unload_pumpkin_position [ 3 ] = { 1462.4812, 2012.1762, 21.0000 } ;

stock create_player_farmer ( playerid, _type )
{
	if ( _type == 1 )
	{
		player_quest [ playerid ] = 13 ;
		
		player_quest_time [ playerid ] = 10 * 60 ;
		show_quest_ptd ( playerid, true ) ;

		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Фермер (Этап №1)\"{"#cWH"}! Время на прохождение квеста: 10 минут." ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Садитесь в указанный трактор." ) ;
		SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;

		for ( new i = 0 ; i < sizeof farmer_tractor_position ; i ++ )
		{
			if ( farmer_tractor_toggled [ i ] == true ) continue ;
			
			farmer_tractor_toggled [ i ] = true ;
			player_quest_vehicle_spawn { playerid } = i + 1 ;
			
			p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 531, farmer_tractor_position [ i ] [ 0 ], farmer_tractor_position [ i ] [ 1 ], farmer_tractor_position [ i ] [ 2 ], farmer_tractor_position [ i ] [ 3 ], 1, 1, -1 ) ;
			
			is_quest_used { playerid } = 114 ;
			SetPlayerRaceCheckpoint ( playerid, 1, farmer_tractor_position [ i ] [ 0 ], farmer_tractor_position [ i ] [ 1 ], farmer_tractor_position [ i ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			break ;
		}
		
		new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;

		veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
		veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
		veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;

		player_quest_step { playerid } = 0 ;
	}
	else if ( _type == 2 )
	{
		player_quest [ playerid ] = 14 ;
		
		player_quest_time [ playerid ] = 20 * 60 ;
		show_quest_ptd ( playerid, true ) ;

		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Фермер (Этап №2)\"{"#cWH"}! Время на прохождение квеста: 20 минут." ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Садитесь в указанный самолёт и начинайте распылять удобрения." ) ;
		SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;

		for ( new i = 0 ; i < sizeof farmer_camel_position ; i ++ )
		{
			if ( farmer_camel_toggled [ i ] == true ) continue ;
			
			farmer_camel_toggled [ i ] = true ;
			player_quest_vehicle_spawn { playerid } = i + 1 ;
			
			p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 513, farmer_camel_position [ i ] [ 0 ], farmer_camel_position [ i ] [ 1 ], farmer_camel_position [ i ] [ 2 ], farmer_camel_position [ i ] [ 3 ], 1, 1, -1 ) ;
			
			is_quest_used { playerid } = 117 ;
			SetPlayerRaceCheckpoint ( playerid, 1, farmer_camel_position [ i ] [ 0 ], farmer_camel_position [ i ] [ 1 ], farmer_camel_position [ i ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			break ;
		}
		
		new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;

		veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
		veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
		veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;

		player_quest_step { playerid } = 0 ;
	}
	else if ( _type == 3 )
	{
		player_quest [ playerid ] = 15 ;
		
		player_quest_time [ playerid ] = 12 * 60 ;
		show_quest_ptd ( playerid, true ) ;

		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Фермер (Этап №3)\"{"#cWH"}! Время на прохождение квеста: 12 минут." ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Садитесь в указанный грузовик и езжайте на поле." ) ;
		SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;

		for ( new i = 0 ; i < sizeof farmer_walton_position ; i ++ )
		{
			if ( farmer_walton_toggled [ i ] == true ) continue ;
			
			farmer_walton_toggled [ i ] = true ;
			player_quest_vehicle_spawn { playerid } = i + 1 ;
			
			p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 478, farmer_walton_position [ i ] [ 0 ], farmer_walton_position [ i ] [ 1 ], farmer_walton_position [ i ] [ 2 ], farmer_walton_position [ i ] [ 3 ], 1, 1, -1 ) ;
			
			is_quest_used { playerid } = 120 ;
			SetPlayerRaceCheckpoint ( playerid, 1, farmer_walton_position [ i ] [ 0 ], farmer_walton_position [ i ] [ 1 ], farmer_walton_position [ i ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			break ;
		}
		
		new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;

		veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
		veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
		veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;

		player_quest_step { playerid } = 0 ;
	}
	
	new text_label [ 256 ] ;
	format ( text_label, sizeof text_label, "** Фермер **\n\n{"#cWH3D"}Игроков на квесте:\n\
															{"#cBL3D"}1. {"#cWH3D"}Вспахивание поля: {"#cGN3D"}%d\n\
															{"#cBL3D"}2. {"#cWH3D"}Распыление удобрения: {"#cGN3D"}%d\n\
															{"#cBL3D"}3. {"#cWH3D"}Сбор тыкв: {"#cGN3D"}%d", farmer_player_quest [ 0 ], farmer_player_quest [ 1 ], farmer_player_quest [ 2 ] ) ;
	UpdateDynamic3DTextLabelText ( farmer_text, col_header_3d, text_label ) ;
	return 1 ;
}

/*

	Ферма (дойка коров)
	
*/

new milking_player_quest = 0 ;
new bool: milking_quest_active = false ;
new Text3D: milking_text ;

new Float: cow_bucket_position [ 9 ] [ 3 ] = // 19468
{
	{ 2174.5112, 1696.2005, 30.4333 },
	{ 2154.8059, 1696.0522, 30.4333 },
	{ 2183.2770, 1705.5687, 30.4333 },
	{ 2157.2233, 1712.0758, 30.4333 },
	{ 2179.5012, 1721.6270, 30.4333 },
	{ 2156.8764, 1724.8801, 30.4333 },
	{ 2165.3940, 1713.5504, 30.4333 },
	{ 2173.7541, 1744.4333, 30.4333 },
	{ 2153.2377, 1752.1986, 30.4333 }
} ;

new bool: mule_position_toggled [ 4 ] = { false, ... } ;
new Float: mule_vehicle_position [ 4 ] [ 4 ] = 
{
	{ 2101.5690, 1773.4500, 31.0945, 324.0223 },
	{ 2095.5634, 1773.6118, 31.0945, 328.5058 },
	{ 2089.8618, 1775.1291, 31.0947, 328.4749 },
	{ 2084.0344, 1777.9104, 31.0945, 326.0017 }
} ;

new Float: field_cow_position [ 4 ] [ 3 ] = 
{
	{ 2135.9948, 1692.2031, 31.1075 },
	{ 2135.4694, 1698.2130, 31.0945 },
	{ 2134.8251, 1703.5550, 31.0945 },
	{ 2134.5664, 1710.0645, 31.0944 }
} ;

new Float: bucket_pickup_position [ 3 ] = { 2139.6037, 1772.2623, 31.4590 } ;
new Float: unload_milk_position [ 3 ] = { 1461.9035, 2021.6871, 21.0000 } ;

stock create_player_milking ( playerid )
{
	player_quest [ playerid ] = 12 ;
	
	player_quest_time [ playerid ] = 15 * 60 ;
	show_quest_ptd ( playerid, true ) ;

	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Дойка коров\"{"#cWH"}! Время на прохождение квеста: 15 минут." ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Возьмите молоковоз и подгоните его на поле." ) ;
	SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;

	for ( new i = 0 ; i < sizeof mule_vehicle_position ; i ++ )
	{
		if ( mule_position_toggled [ i ] == true ) continue ;
		
		mule_position_toggled [ i ] = true ;
		player_quest_vehicle_spawn { playerid } = i + 1 ;
		
		p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 414, mule_vehicle_position [ i ] [ 0 ], mule_vehicle_position [ i ] [ 1 ], mule_vehicle_position [ i ] [ 2 ], mule_vehicle_position [ i ] [ 3 ], 1, 1, -1 ) ;
		
		is_quest_used { playerid } = 109 ;
		SetPlayerRaceCheckpoint ( playerid, 1, mule_vehicle_position [ i ] [ 0 ], mule_vehicle_position [ i ] [ 1 ], mule_vehicle_position [ i ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		break ;
	}
	
	new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
	new engine, lights, alarm, doors, bonnet, boot, objective ;
	veh_info [ veh_id - 1 ] [ v_locked ] = false ;
	GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;

	veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
	veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
	veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;

	player_quest_step { playerid } = 0 ;
	
	new text_label [ 100 ] ;
	format ( text_label, sizeof text_label, "** Дойка коров **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", milking_player_quest, ( milking_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	UpdateDynamic3DTextLabelText ( milking_text, col_header_3d, text_label ) ;
	return 1 ;
}

callback: callback_milking ( playerid )
{
	SetPlayerAttachedObject ( playerid, 1, 19468, 5, 0.378001, 0.003001, -0.014999, 53.500022, -94.900039, -33.999877, 0.963998, 0.916998, 1.000000 ) ;
	
	DestroyDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
	
	new Float:boot_pos [ 3 ] ;
	GetCoordBootVehicle ( p_t_info [ playerid ] [ pl_quest ], boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ) ;

	is_quest_used { playerid } = 111 ;
	SetPlayerRaceCheckpoint ( playerid, 1, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
	return 1 ;
}

/*

	Ферма (яйца)
	
*/

new eggs_player_quest = 0 ;
new bool: eggs_quest_active = false ;
new Text3D: eggs_text ;

new Float: vehicle_attached_faggio [ 6 ] = { -0.008, -0.700, 0.877, -0.199, 4.099, 89.199 } ; // 19592

new bool: faggio_position_toggled [ 4 ] = { false, ... } ;
new Float: faggio_position [ 4 ] [ 4 ] = 
{
	{ 1302.8343, -1055.9936, 20.6129, 324.3341 },
	{ 1300.7275, -1054.5822, 20.6119, 327.8689 },
	{ 1298.0183, -1052.8999, 20.6117, 334.7287 },
	{ 1295.3653, -1051.1961, 20.6121, 337.9104 }
} ;

new Float: faggio_unload_position [ 3 ] = { 1461.9035, 2021.6871, 21.0000 } ;
new Float: chicken_coop_position [ 10 ] [ 3 ] =
{
	{ 1294.2772, -1058.8164, 21.0000 },
	{ 1294.2558, -1063.1954, 21.0000 },
	{ 1290.1558, -1063.0701, 21.0000 },
	{ 1290.1789, -1058.6715, 21.0000 },
	{ 1286.1501, -1063.2819, 21.0000 },
	{ 1286.2980, -1058.6094, 21.0000 },
	{ 1282.1757, -1058.6832, 21.0000 },
	{ 1282.1179, -1063.3293, 21.0000 },
	{ 1278.2509, -1063.1044, 21.0000 },
	{ 1278.3226, -1058.6385, 21.0000 }
} ;

stock create_player_eggs ( playerid )
{
	player_quest [ playerid ] = 11 ;
	
	player_quest_time [ playerid ] = 15 * 60 ;
	show_quest_ptd ( playerid, true ) ;

	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Сбор яиц\"{"#cWH"}! Время на прохождение квеста: 15 минут." ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Собирайте яйца и кладите их в корзину мопеда." ) ;
	SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;

	for ( new i = 0 ; i < sizeof faggio_position ; i ++ )
	{
		if ( faggio_position_toggled [ i ] == true ) continue ;
		
		faggio_position_toggled [ i ] = true ;
		player_quest_vehicle_spawn { playerid } = i + 1 ;
		p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 462, faggio_position [ i ] [ 0 ], faggio_position [ i ] [ 1 ], faggio_position [ i ] [ 2 ], faggio_position [ i ] [ 3 ], 1, 1, -1 ) ;
		break ;
	}	
	
	new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
	new engine, lights, alarm, doors, bonnet, boot, objective ;
	veh_info [ veh_id - 1 ] [ v_locked ] = false ;
	GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
				
	veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
	veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
	veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;
					
	player_quest_step { playerid } = 0 ;
					
	new _id = player_quest_vehicle_spawn { playerid } ;
	veh_info [ veh_id - 1 ] [ v_cargo_object ] [ 0 ] = CreateDynamicObject ( 19592, faggio_position [ _id ] [ 0 ], faggio_position [ _id ] [ 1 ], faggio_position [ _id ] [ 2 ], 0.0, 0.0, faggio_position [ _id ] [ 3 ] ) ;
	AttachDynamicObjectToVehicle( veh_info [ veh_id - 1 ] [ v_cargo_object ] [ 0 ], veh_id, vehicle_attached_faggio [ 0 ],
																							vehicle_attached_faggio [ 1 ],
																							vehicle_attached_faggio [ 2 ],
																							vehicle_attached_faggio [ 3 ],
																							vehicle_attached_faggio [ 4 ],
																							vehicle_attached_faggio [ 5 ] ) ;
	
	new _random = random ( sizeof chicken_coop_position ) ;
	is_quest_used { playerid } = 105 ;
	SetPlayerRaceCheckpoint ( playerid, 1, chicken_coop_position [ _random ] [ 0 ], chicken_coop_position [ _random ] [ 1 ], chicken_coop_position [ _random ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;

	new text_label [ 100 ] ;
	format ( text_label, sizeof text_label, "** Сбор яиц **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", eggs_player_quest, ( eggs_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	UpdateDynamic3DTextLabelText ( eggs_text, col_header_3d, text_label ) ;
	return 1 ;
}

/*

	Ферма (сено)
	
*/

new hay_player_quest = 0 ;
new bool: hay_quest_active = false ;
new Text3D: hay_text ;

new Float: vehicle_attached_tractor [ 6 ] = { -0.0468, -3.1236, -0.2913,   0.0000, 0.0000, -90.0000 } ; // 1454
new Float: vehicle_attached_loader [ 6 ] = { 0.000, 0.865, 0.615, 91.399, -1.399, 0.000 } ; // 1454
new Float: vehicle_attached_dft_fence [ 2 ] [ 6 ] = // 994
{
	{ 1.414, 1.921, -0.200, 0.000, 0.000, -89.999 },
    { -1.447, 1.895, -0.240, 0.000, 0.000, -89.900 }
} ;

new Float: vehicle_attached_dft_hay [ 8 ] [ 6 ] = // 1454
{
	{ -0.662, 1.478, 0.500, 0.000, -2.999, -90.699 },
    { 0.639, 1.167, 0.508, 0.000, -2.999, -90.399 },
    { -0.666, -0.177, 0.498, 0.000, -3.999, 90.399 },
    { 0.648, -0.504, 0.495, 0.000, -3.999, -90.399 },
    { -0.639, -1.824, 0.490, 0.000, -2.900, 90.399 },
    { 0.644, -2.128, 0.480, 0.000, -2.900, -90.399 },
    { -0.562, -3.588, 0.357, 89.099, 2.900, -90.399 },
    { 0.642, -4.734, 0.358, 89.099, -2.900, 90.399 }
} ;

new Float: hay_position_in_field [ 9 ] [ 6 ] = // 1454
{
	{ 1341.8272, -887.0773, 21.1405 },
	{ 1367.0638, -892.8096, 21.1405 },
	{ 1383.1771, -893.3016, 21.1405 },
	{ 1408.1799, -894.5780, 21.1405 },
	{ 1410.4508, -878.7434, 21.1405 },
	{ 1390.1502, -880.1004, 21.1405 },
	{ 1376.1304, -880.3063, 21.1405 },
	{ 1359.8428, -880.3520, 21.1405 },
	{ 1341.1297, -884.3994, 21.1405 }
} ;

new Float: hay_unload_position [ 3 ] = { 1412.0046, -1002.8357, 20.5999 } ;
new Float: tractor_position [ 4 ] = { 1388.6533, -1068.0686, 20.9673, 25.8902 } ;
new Float: loader_position [ 4 ] = { 1411.2958, -1030.9550, 20.7631, 277.0180 } ;
new Float: dft_position [ 4 ] = { 1428.2941, -992.1304, 21.6242, 356.5678 } ;

new Float: unload_dft_position [ 3 ] = { 1462.4812, 2012.1762, 21.0000 } ;

new Float: hay_ambar_position [ 2 ] [ 6 ] = // 1454
{
	{ 1415.4154, -1017.3469, 20.5999, 90.0000, 0.0000, 0.0000 },
	{ 1412.0046, -1002.8357, 20.5999, 90.0000, 0.0000, 0.0000 }
} ;

stock create_player_hay ( playerid, _type )
{
	if ( _type == 1 ) // трактор
	{
		player_quest [ playerid ] = 10 ;
		
		player_quest_time [ playerid ] = 20 * 60 ;
		show_quest_ptd ( playerid, true ) ;

		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Сено\"{"#cWH"}! Время на прохождение квеста: 20 минут." ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Возьмите трактор и уберите сено с поля в ангар." ) ;
		SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;
	
		p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 531, tractor_position [ 0 ], tractor_position [ 1 ], tractor_position [ 2 ], tractor_position [ 3 ], 1, 1, -1 ) ;
	
		new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
		
		veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
		veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
		veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;
		
		player_quest_progress { playerid } = 0 ;
		is_quest_used { playerid } = 100 ;
		SetPlayerRaceCheckpoint ( playerid, 1, tractor_position [ 0 ], tractor_position [ 1 ], tractor_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
	}
	else if ( _type == 2 ) // погрузчик
	{
		player_quest [ playerid ] = 10 ;

		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Теперь берите погрузчик и грузите сено в фургон." ) ;
	
		p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 530, loader_position [ 0 ], loader_position [ 1 ], loader_position [ 2 ], loader_position [ 3 ], 1, 1, -1 ) ;
		player_quest_vehicle [ playerid ] = CreateVehicle ( 578, dft_position [ 0 ], dft_position [ 1 ], dft_position [ 2 ], dft_position [ 3 ], 1, 1, -1 ) ;
		
		player_quest_step { playerid } = 0 ;
		
		for ( new i = 0 ; i < sizeof vehicle_attached_dft_fence ; i ++ )
		{
			player_quest_vehicle_attached [ playerid ] [ i ] = CreateDynamicObject ( 994, dft_position [ 0 ], dft_position [ 1 ], dft_position [ 2 ], 0.0, 0.0, dft_position [ 3 ] ) ;
																							
			AttachDynamicObjectToVehicle( player_quest_vehicle_attached [ playerid ] [ i ], player_quest_vehicle [ playerid ], vehicle_attached_dft_fence [ i ] [ 0 ],
																																vehicle_attached_dft_fence [ i ] [ 1 ],
																																vehicle_attached_dft_fence [ i ] [ 2 ],
																																vehicle_attached_dft_fence [ i ] [ 3 ],
																																vehicle_attached_dft_fence [ i ] [ 4 ],
																																vehicle_attached_dft_fence [ i ] [ 5 ] ) ;
		}
	
		new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
		
		veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
		veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
		veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;
		
		new _random = random ( 2 ) ;
		
		is_quest_used { playerid } = 102 ;
		SetPlayerRaceCheckpoint ( playerid, 1, hay_ambar_position [ _random ] [ 0 ], hay_ambar_position [ _random ] [ 1 ], hay_ambar_position [ _random ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		
		veh_info [ veh_id - 1 ] [ v_cargo_object ] [ 0 ] = CreateDynamicObject ( 1454, hay_ambar_position [ _random ] [ 0 ], 
																						hay_ambar_position [ _random ] [ 1 ], 
																						hay_ambar_position [ _random ] [ 2 ], 
																						hay_ambar_position [ _random ] [ 3 ], 
																						hay_ambar_position [ _random ] [ 4 ], 
																						hay_ambar_position [ _random ] [ 5 ] ) ;
																						
		player_quest_area [ playerid ] [ 0 ] = CreateDynamicSphere ( hay_ambar_position [ _random ] [ 0 ], hay_ambar_position [ _random ] [ 1 ], hay_ambar_position [ _random ] [ 2 ], 5.0, -1, -1, playerid ) ;
		area_info [ player_quest_area [ playerid ] [ 0 ] ] [ a_type ] = area_type_hay_loader ;
		
		veh_id = player_quest_vehicle [ playerid ] ;
		veh_info [ veh_id - 1 ] [ v_locked ] = true ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, lights, alarm, true, bonnet, boot, objective ) ;
	}
	else if ( _type == 3 )
	{
		p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 578, dft_position [ 0 ], dft_position [ 1 ], dft_position [ 2 ], dft_position [ 3 ], 1, 1, -1 ) ;
					
		new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
				
		veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
		veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
		veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;
					
		player_quest_step { playerid } = 0 ;
					
		for ( new i = 0 ; i < sizeof vehicle_attached_dft_fence ; i ++ )
		{
			player_quest_vehicle_attached [ playerid ] [ i ] = CreateDynamicObject ( 994, dft_position [ 0 ], dft_position [ 1 ], dft_position [ 2 ], 0.0, 0.0, dft_position [ 3 ] ) ;
																										
			AttachDynamicObjectToVehicle( player_quest_vehicle_attached [ playerid ] [ i ], veh_id, vehicle_attached_dft_fence [ i ] [ 0 ],
																									vehicle_attached_dft_fence [ i ] [ 1 ],
																									vehicle_attached_dft_fence [ i ] [ 2 ],
																									vehicle_attached_dft_fence [ i ] [ 3 ],
																									vehicle_attached_dft_fence [ i ] [ 4 ],
																									vehicle_attached_dft_fence [ i ] [ 5 ] ) ;
		}
		for ( new i = 0 ; i < sizeof vehicle_attached_dft_hay ; i ++ )
		{
			player_quest_vehicle_attached [ playerid ] [ i + 2 ] = CreateDynamicObject ( 1454, dft_position [ 0 ], dft_position [ 1 ], dft_position [ 2 ], 0.0, 0.0, dft_position [ 3 ] ) ;
			AttachDynamicObjectToVehicle( player_quest_vehicle_attached [ playerid ] [ i + 2 ], veh_id, vehicle_attached_dft_hay [ i ] [ 0 ],
																										vehicle_attached_dft_hay [ i ] [ 1 ],
																										vehicle_attached_dft_hay [ i ] [ 2 ],
																										vehicle_attached_dft_hay [ i ] [ 3 ],
																										vehicle_attached_dft_hay [ i ] [ 4 ],
																										vehicle_attached_dft_hay [ i ] [ 5 ] ) ;
		}
					
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Теперь нужно отвезти груз." ) ;
		is_quest_used { playerid } = 103 ;
		SetPlayerRaceCheckpoint ( playerid, 1, unload_dft_position [ 0 ], unload_dft_position [ 1 ], unload_dft_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
	}
	
	new text_label [ 100 ] ;
	format ( text_label, sizeof text_label, "** Сено **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", hay_player_quest, ( hay_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	UpdateDynamic3DTextLabelText ( hay_text, col_header_3d, text_label ) ;
	return 1 ;
}

/*

	Граффити

*/

new graffity_player_quest = 0 ;
new bool: graffity_quest_active = false ;
new Text3D: graffity_text ;

new Float: spray_in_box_pos [ 4 ] [ 6 ] =
{
	{ 2555.86133, 2835.81934, 9.98649,   0.00000, 90.00000, -44.58000 },
	{ 2596.77856, 2845.09546, 10.05655,   0.00000, 90.00000, 0.00000 },
	{ 2578.42700, 2846.01367, 10.01095,   0.00000, 90.00000, 0.00000 },
	{ 2572.00562, 2821.87061, 10.01863,   0.00000, 90.00000, -39.12001 }
} ;

new Float: shotgun_position [ 3 ] = { 2575.5535, 2840.1121, 19.9922 } ;
new Float: start_graffity [ 4 ] = { 2579.2065, 2804.8806, 10.8203, 355.0876 } ;

stock create_player_graffity ( playerid )
{
	graffity_player_quest ++ ;
	graffity_quest_active = true ;
	
	new text_label [ 100 ] ;
	format ( text_label, sizeof text_label, "** Граффити **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", graffity_player_quest, ( graffity_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	UpdateDynamic3DTextLabelText ( graffity_text, col_header_3d, text_label ) ;
	
	player_quest [ playerid ] = 2 ;
	
	player_quest_time [ playerid ] = 60 * 60 ;
	show_quest_ptd ( playerid, true ) ;

	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Граффити\"{"#cWH"}! Время на прохождение квеста: 60 минут." ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вам нужно найти 2 баллончика с краской. Чтобы искать баллончики, нужно разбивать коробки." ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Если какие-то коробки окажутся слишком крепкими, на крыше припрятано оружие." ) ;
	SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;
	
	set_pos ( playerid, start_graffity [ 0 ], start_graffity [ 1 ], start_graffity [ 2 ], start_graffity [ 3 ], 0, 25 ) ;
	
	new _c_graffity [ sizeof spray_in_box_pos ] = { 0, ... } ;
	new _position = 0 ;
	new _random ;
	
	enter_graffity_start:
	do
	{
		_random = random ( sizeof spray_in_box_pos ) ;
	}
	while ( _c_graffity [ _random ] == 1 ) ;
		
	_c_graffity [ _random ] = 1 ;
	player_quest_object [ playerid ] [ _position ] = CreateDynamicObject ( 365, spray_in_box_pos [ _random ] [ 0 ], spray_in_box_pos [ _random ] [ 1 ], spray_in_box_pos [ _random ] [ 2 ], spray_in_box_pos [ _random ] [ 3 ], spray_in_box_pos [ _random ] [ 4 ], spray_in_box_pos [ _random ] [ 5 ] ) ; 
	player_quest_area [ playerid ] [ _position ] = CreateDynamicSphere ( spray_in_box_pos [ _random ] [ 0 ], spray_in_box_pos [ _random ] [ 1 ], spray_in_box_pos [ _random ] [ 2 ], 2.0, -1, -1, -1 ) ;
	area_info [ player_quest_area [ playerid ] [ _position ] ] [ a_type ] = area_type_graffity_spray ;

	_position ++ ;
	if ( _position < 2 ) goto enter_graffity_start;
	
	player_quest_pickup [ playerid ] [ 0 ] = CreateDynamicPickup ( 349, 23, shotgun_position [ 0 ], shotgun_position [ 1 ], shotgun_position [ 2 ], 25, 0, -1 ) ;
	pick_info [ player_quest_pickup [ playerid ] [ 0 ] ] [ pick_type ] = pick_type_quest_shotgun ;
	return 1 ;
}

stock start_graffity_quest ( playerid )
{
	graffity_quest_active = false ;
	
	for ( new i = 0 ; i < 3 ; i ++ )
	{
		if ( IsValidDynamicObject ( player_quest_object [ playerid ] [ i ] ) ) DestroyDynamicObject ( player_quest_object [ playerid ] [ i ] ) ;
		if ( IsValidDynamicArea ( player_quest_area [ playerid ] [ i ] ) ) DestroyDynamicArea ( player_quest_area [ playerid ] [ i ] ) ;
	}
	if ( IsValidDynamicPickup ( player_quest_pickup [ playerid ] [ 0 ] ) ) DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ 0 ] ) ;
	
	new text_label [ 100 ] ;
	format ( text_label, sizeof text_label, "** Граффити **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", graffity_player_quest, ( graffity_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	UpdateDynamic3DTextLabelText ( graffity_text, col_header_3d, text_label ) ;

	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}У Вас на карте отмечены граффити, которые нужно закрасить. Отправляйтесь туда." ) ;

	set_pos ( playerid, 2589.7061, 2790.2842, 10.8203, 90.2910, 0, 0 ) ;
	give_weapon ( playerid, 41, 1500 ) ;
	
	new _random, _count = 0 ;
	do
	{
		_random = random ( count_graffity ) ;
		_count ++ ;
	}
	while ( graf_info [ _random ] [ g_member ] == p_info [ playerid ] [ member ] && _count < 10 ) ;
	
	if ( graf_info [ _random ] [ g_member ] == p_info [ playerid ] [ member ] )
	{
		graffity_player_quest -- ;
		player_quest [ playerid ] = 0 ;
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент нет граффити, которые не пренадлежат Вашей банде." ) ;
		return 1 ;
	}
	
	is_quest_used { playerid } = 10 ;
	SetPlayerRaceCheckpoint ( playerid, 1, graf_info [ _random ] [ gr_x ] [ 0 ], graf_info [ _random ] [ gr_x ] [ 1 ], graf_info [ _random ] [ gr_x ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
	return 1 ;
}

/*

	Ограбление

*/

new maze_player_quest = 0 ;
new bool: maze_quest_active = false ;
new Text3D: maze_text ;

new Float: money_bag_position [ 5 ] [ 3 ] [ 3 ] =
{
	{
		{ -233.7232, 2715.8713, 66.9513 },
		{ -218.1458, 2720.5933, 66.7158 },
		{ -230.3197, 2722.9512, 62.6875 }
	},
	{
		{ -1455.3820, 2638.6729, 55.8359 },
		{ -1459.4083, 2648.6604, 55.8359 },
		{ -1463.2830, 2628.9712, 55.8359 }
	},
	{
		{ 2334.1089, -65.9419, 29.9303 },
		{ 2324.5293, -81.9785, 30.4834 },
		{ 2321.2451, -74.3411, 26.4844 }
	},
	{
		{ 1276.3757, 287.2841, 19.5614 },
		{ 1289.4852, 292.8834, 25.7998 },
		{ 1281.1595, 271.7791, 23.7625 }
	},
	{
		{ 260.2548, -151.4730, 1.5703 },
		{ 243.8807, -160.8360, 1.5781 },
		{ 267.5717, -182.1867, 7.0613 }
	}
} ;

new Float: vehicle_attached [ 3 ] [ 6 ] =
{
	{ -0.640, -0.990, 0.100, 0.000, 0.000, 0.000 },
    { 0.610, -1.010, 0.090, 0.000, 0.000, 0.000 },
    { 0.010, -0.999, 0.100, 0.000, 0.000, 0.000 }
} ;

new Float: end_maze_quest [ 3 ] = { 2487.5378, -1461.0344, 24.0180 } ;

new Float: start_maze [ 3 ] [ 4 ] =
{
	{ 2729.1270, 2805.0222, 10.8203, 268.9821 },
	{ 2719.6816, 2819.2354, 10.8203, 266.9121 },
	{ 2712.9182, 2713.7073, 10.8203, 269.3701 }
} ;

new Float: dynamite_maze [ 6 ] [ 3 ] =
{
	{ 2701.2476, 2741.4060, 10.8203 },
	{ 2714.7349, 2733.8794, 10.8203 },
	{ 2738.2124, 2749.6038, 10.8203 },
	{ 2738.7839, 2775.2751, 10.8203 },
	{ 2735.8774, 2835.9646, 10.8203 },
	{ 2701.9043, 2762.5728, 10.8203 }
} ;

new bool: maze_free [ 5 ] = { false, ... } ;
new Float: save_explosion_position [ 5 ] [ 3 ] =
{
	{ -229.7124, 2743.1111, 62.6875 },
	{ -1437.3529, 2634.6777, 55.8359 },
	{ 2349.8184, -65.9565, 26.4844 },
	{ 1312.5503, 284.2878, 19.5547 },
	{ 225.3580, -158.8378, 1.5781 }
} ;

new Float: explosion_position [ 5 ] [ 3 ] [ 3 ] =
{
	{
		{ -227.6904, 2721.7021, 62.8294 },
		{ -221.7211, 2710.5752, 62.9766 },
		{ -235.8731, 2710.8311, 62.9766 }
	},
	{
		{ -1463.1693, 2628.6116, 58.7734 },
		{ -1470.4924, 2615.5747, 58.7879 },
		{ -1465.6121, 2611.3186, 56.1296 }
	},
	{
		{ 2322.8667, -62.9817, 26.4844 },
		{ 2333.4758, -57.8324, 26.4844 },
		{ 2333.1440, -67.4389, 26.4844 }
	},
	{
		{ 1297.8789, 291.6674, 19.5469 },
		{ 1280.1641, 283.9614, 19.5547 },
		{ 1289.0826, 304.1272, 19.5547 }
	},
	{
		{ 255.4942, -158.2009, 1.5703 },
		{ 253.7584, -163.8312, 5.0786 },
		{ 273.1954, -158.0844, 1.7405 }
	}
} ;

callback: explosion_dynamite ( playerid )
{
	new _bank = player_quest_id { playerid } ;
	for ( new i = 0 ; i < 3 ; i ++ )
	{
		DestroyDynamicObject ( player_quest_object [ playerid ] [ i ] ) ;
		CreateExplosion ( explosion_position [ _bank ] [ i ] [ 0 ], explosion_position [ _bank ] [ i ] [ 1 ], explosion_position [ _bank ] [ i ] [ 2 ], 6, 3.0 ) ;
		
		player_quest_pickup [ playerid ] [ i ] = CreateDynamicPickup ( 1550, 23, money_bag_position [ _bank ] [ i ] [ 0 ], money_bag_position [ _bank ] [ i ] [ 1 ], money_bag_position [ _bank ] [ i ] [ 2 ], 0, 0, -1 ) ;
		pick_info [ player_quest_pickup [ playerid ] [ i ] ] [ pick_type ] = pick_type_quest_robbery ;
	}
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Соберите мешки с деньгами!" ) ;
	return 1 ;
}

stock create_player_maze ( playerid )
{
	maze_player_quest ++ ;
	maze_quest_active = true ;
	
	new text_label [ 100 ] ;
	format ( text_label, sizeof text_label, "** Ограбление **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", maze_player_quest, ( maze_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	UpdateDynamic3DTextLabelText ( maze_text, col_header_3d, text_label ) ;
	
	player_quest [ playerid ] = 1 ;
	
	player_quest_time [ playerid ] = 40 * 60 ;
	show_quest_ptd ( playerid, true ) ;

	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы выбрали квест {"#cGInfo"}\"Ограбление\"{"#cWH"}! Время на прохождение квеста: 40 минут." ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Решил срубить лёгких денег? Сначала надо достать взрывчатку, здесь в лабиринтах склада как раз завалялось несколько штук." ) ;
	SendClientMessage ( playerid, col_orange, !"Используйте /exitquest для досрочного завершения задания." ) ;
	
	new _random = random ( sizeof start_maze ) ;
	set_pos ( playerid, start_maze [ _random ] [ 0 ], start_maze [ _random ] [ 1 ], start_maze [ _random ] [ 2 ], start_maze [ _random ] [ 3 ], 0, 25 ) ;
	
	new _maze_dynamite [ sizeof dynamite_maze ] = { 0, ... }, _position = 0 ;
	
	enter_maze_start:
	do
	{
		_random = random ( sizeof dynamite_maze ) ;
	}
	while ( _maze_dynamite [ _random ] == 1 ) ;
		
	_maze_dynamite [ _random ] = 1 ;
	player_quest_pickup [ playerid ] [ _position ] = CreateDynamicPickup ( 1654, 23, dynamite_maze [ _random ] [ 0 ], dynamite_maze [ _random ] [ 1 ], dynamite_maze [ _random ] [ 2 ], 25, 0, -1 ) ;
	pick_info [ player_quest_pickup [ playerid ] [ _position ] ] [ pick_type ] = pick_type_maze ;
		
	quest_icon [ playerid ] [ _position ] = SetPlayerMapIcon ( playerid, _position, dynamite_maze [ _random ] [ 0 ], dynamite_maze [ _random ] [ 1 ], dynamite_maze [ _random ] [ 2 ], 56, 0, MAPICON_GLOBAL ) ;
	
	_position ++ ;
	if ( _position < 3 ) goto enter_maze_start;
	return 1 ;
}

stock start_maze_quest ( playerid )
{
	maze_quest_active = false ;
	
	for ( new i = 0 ; i < 3 ; i ++ )
	{
		if ( IsValidDynamicPickup ( player_quest_pickup [ playerid ] [ i ] ) ) DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ i ] ) ;
		if ( quest_icon [ playerid ] [ i ] != -1 ) 
		{
			RemovePlayerMapIcon ( playerid, i ) ;
			quest_icon [ playerid ] [ i ] = -1 ;
		}
	}
	
	new text_label [ 100 ] ;
	format ( text_label, sizeof text_label, "** Ограбление **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", maze_player_quest, ( maze_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	UpdateDynamic3DTextLabelText ( maze_text, col_header_3d, text_label ) ;

	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Бери машину и езжай к хранилищу." ) ;

	set_pos ( playerid, 2589.7061, 2790.2842, 10.8203, 90.2910, 0, 0 ) ;
	
	p_t_info [ playerid ] [ pl_quest ] = CreateVehicle ( 536, 2574.5115, 2791.1504, 10.5580, 180.1682, 1, 1, -1 ) ;

	new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
	new engine, lights, alarm, doors, bonnet, boot, objective ;
    veh_info [ veh_id - 1 ] [ v_locked ] = false ;
	GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
	
	veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;
	veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_quest ;
	veh_info [ veh_id - 1 ] [ v_renter ] = playerid ;
	
	new _random ;
	do
	{
		_random = random ( sizeof save_explosion_position ) ;
	}
	while ( maze_free [ _random ] == true ) ;
	
	maze_free [ _random ] = true ;
	player_quest_id { playerid } = _random ;
	
	new _bank = player_quest_id { playerid } ;
	is_quest_used { playerid } = 1 ;
	SetPlayerRaceCheckpoint ( playerid, 1, save_explosion_position [ _bank ] [ 0 ], save_explosion_position [ _bank ] [ 1 ], save_explosion_position [ _bank ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
	return 1 ;
}

stock quest_EnterRaceCheckpoint ( playerid )
{
	new _is_quest = is_quest_used { playerid } ;
	if ( _is_quest == 1 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
		
		new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		
		new engine, lights, alarm, doors, bonnet, boot, objective ;
        veh_info [ veh_id - 1 ] [ v_locked ] = true ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, VEHICLE_PARAMS_OFF, lights, alarm, true, bonnet, boot, objective ) ;
		RemovePlayerFromVehicle ( playerid ) ;
		
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Теперь нужно заложить динамит. Места закладки отмечены красным." ) ;
		
		is_quest_used { playerid } = 2 ;
		player_quest_step { playerid } = 0 ;
		new _step = player_quest_step { playerid }, _bank = player_quest_id { playerid } ;
		SetPlayerRaceCheckpoint ( playerid, 1, explosion_position [ _bank ] [ _step ] [ 0 ], explosion_position [ _bank ] [ _step ] [ 1 ], explosion_position [ _bank ] [ _step ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 2 )
	{
		ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Переходите к следующему месту." ) ;
		
		is_quest_used { playerid } = 3 ;
		new _step = player_quest_step { playerid }, _bank = player_quest_id { playerid } ;
		player_quest_object [ playerid ] [ 0 ] = CreateDynamicObject ( 1654, explosion_position [ _bank ] [ _step ] [ 0 ], explosion_position [ _bank ] [ _step ] [ 1 ], explosion_position [ _bank ] [ _step ] [ 2 ], 0.0, 0.0, 0.0, 0, 0 ) ;
		
		player_quest_step { playerid } ++ ;
		_step = player_quest_step { playerid } ;
		SetPlayerRaceCheckpoint ( playerid, 1, explosion_position [ _bank ] [ _step ] [ 0 ], explosion_position [ _bank ] [ _step ] [ 1 ], explosion_position [ _bank ] [ _step ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 3 )
	{
		ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Переходите к следующему месту." ) ;
		
		is_quest_used { playerid } = 4 ;
		new _step = player_quest_step { playerid }, _bank = player_quest_id { playerid } ;
		player_quest_object [ playerid ] [ 1 ] = CreateDynamicObject ( 1654, explosion_position [ _bank ] [ _step ] [ 0 ], explosion_position [ _bank ] [ _step ] [ 1 ], explosion_position [ _bank ] [ _step ] [ 2 ], 0.0, 0.0, 0.0, 0, 0 ) ;
		
		player_quest_step { playerid } ++ ;
		_step = player_quest_step { playerid } ;
		SetPlayerRaceCheckpoint ( playerid, 1, explosion_position [ _bank ] [ _step ] [ 0 ], explosion_position [ _bank ] [ _step ] [ 1 ], explosion_position [ _bank ] [ _step ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 4 )
	{
		ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно заложили динамит. Отбегите на безопасное расстояние." ) ;
		
		is_quest_used { playerid } = 5 ;
		player_quest_progress { playerid } = 0 ;
		new _step = player_quest_step { playerid }, _bank = player_quest_id { playerid } ;
		
		player_quest_object [ playerid ] [ 2 ] = CreateDynamicObject ( 1654, explosion_position [ _bank ] [ _step ] [ 0 ], explosion_position [ _bank ] [ _step ] [ 1 ], explosion_position [ _bank ] [ _step ] [ 2 ], 0.0, 0.0, 0.0, 0, 0 ) ;
		SetPlayerRaceCheckpoint ( playerid, 1, save_explosion_position [ _bank ] [ 0 ], save_explosion_position [ _bank ] [ 1 ], save_explosion_position [ _bank ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 5 )
	{
		SetTimerEx ( "explosion_dynamite", 3000, false, "i", playerid ) ;
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		return 1 ;
	}
	else if ( _is_quest == 6 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
		
		maze_free [ player_quest_id { playerid } ] = false ;
		
		maze_player_quest -- ;
		player_quest [ playerid ] = 0 ;
		
		new text_label [ 100 ] ;
		format ( text_label, sizeof text_label, "** Ограбление **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", maze_player_quest, ( maze_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
		UpdateDynamic3DTextLabelText ( maze_text, col_header_3d, text_label ) ;
		
		DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
		p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
		
		new _money = quest_maze_reward ;
		
		#if defined m_perks
		new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
		if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
		#endif
		
		give_money ( playerid, _money ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест ограбление" ) ;
		
		format ( text_label, sizeof text_label, "{"#cWH"}Вы завершили задание и получили {"#cGN"}%d"valute_title"{"#cWH"}.", _money ) ;
		show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Ограбление", text_label, "Закрыть", "" ) ;
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		return 1 ;
	}
	else if ( _is_quest == 10 )
	{
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Закрасьте граффити." ) ;
		
		player_quest_step { playerid } ++ ;
		
		new _random, _count = 0 ;
		do
		{
			_random = random ( count_graffity ) ;
			_count ++ ;
		}
		while ( graf_info [ _random ] [ g_member ] == p_info [ playerid ] [ member ] && _count < 10 ) ;
		
		if ( graf_info [ _random ] [ g_member ] == p_info [ playerid ] [ member ] )
		{
			graffity_player_quest -- ;
			player_quest [ playerid ] = 0 ;
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент нет граффити, которые не пренадлежат Вашей банде." ) ;
			player_quest_step { playerid } = 3 ;
		}
		
		if ( player_quest_step { playerid } >= 3 )
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы завершили квест." ) ;
		
			is_quest_used { playerid } = 0 ;
			DisablePlayerRaceCheckpoint ( playerid ) ;
			
			graffity_player_quest -- ;
			player_quest [ playerid ] = 0 ;
			
			new text_label [ 100 ] ;
			format ( text_label, sizeof text_label, "** Граффити **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", graffity_player_quest, ( graffity_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
			UpdateDynamic3DTextLabelText ( graffity_text, col_header_3d, text_label ) ;
			
			new _money = quest_graffity_reward ;
		
			#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
			if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
			#endif
			
			give_money ( playerid, _money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест граффити" ) ;
			
			format ( text_label, sizeof text_label, "{"#cWH"}Вы завершили задание и получили {"#cGN"}%d"valute_title"{"#cWH"}.", _money ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Граффити", text_label, "Закрыть", "" ) ;
			return 1 ;
		}
		
		is_quest_used { playerid } = 10 ;
		SetPlayerRaceCheckpoint ( playerid, 1, graf_info [ _random ] [ gr_x ] [ 0 ], graf_info [ _random ] [ gr_x ] [ 1 ], graf_info [ _random ] [ gr_x ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 100 )
	{
		if ( player_quest_progress { playerid } == 0 )
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Чтобы убрать стог сена, подъедьте к нему задом." ) ;
		}
		
		new _random = random ( sizeof hay_position_in_field ) ;
		veh_info [ p_t_info [ playerid ] [ pl_quest ] - 1 ] [ v_cargo_object ] [ 0 ] = CreateDynamicObject ( 1454, hay_position_in_field [ _random ] [ 0 ],
																													hay_position_in_field [ _random ] [ 1 ],
																													hay_position_in_field [ _random ] [ 2 ],
																													hay_position_in_field [ _random ] [ 3 ],
																													hay_position_in_field [ _random ] [ 4 ],
																													hay_position_in_field [ _random ] [ 5 ] ) ;
		
		player_quest_area [ playerid ] [ 0 ] = CreateDynamicSphere ( hay_position_in_field [ _random ] [ 0 ], hay_position_in_field [ _random ] [ 1 ], hay_position_in_field [ _random ] [ 2 ], 5.0, -1, -1, playerid ) ;
		area_info [ player_quest_area [ playerid ] [ 0 ] ] [ a_type ] = area_type_hay ;
		
		is_quest_used { playerid } = 0 ;
		SetPlayerRaceCheckpoint ( playerid, 1, hay_position_in_field [ _random ] [ 0 ], hay_position_in_field [ _random ] [ 1 ], hay_position_in_field [ _random ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 101 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
		
		new vehicleid = p_t_info [ playerid ] [ pl_quest ] ;
		DestroyDynamicObject ( veh_info [ vehicleid - 1 ] [ v_cargo_object ] [ 0 ] ) ;
		veh_info [ vehicleid - 1 ] [ v_cargo_object ] [ 0 ] = INVALID_OBJECT_ID ;
		
		player_quest_progress { playerid } ++ ;
		if ( player_quest_progress { playerid } >= 8 )
		{
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
			
			player_vehicle [ playerid ] = INVALID_VEHICLE_ID ;
			
			is_quest_used { playerid } = 0 ;
			DisablePlayerRaceCheckpoint ( playerid ) ;
			
			create_player_hay ( playerid, 2 ) ;
		}
		else
		{
			new scm_string [ 87 + 4 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы привезли стог сена. Осталось привезти {"#cGInfo"}%d{"#cWH"}.", 8 - player_quest_progress { playerid } ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;

			new _random = random ( sizeof hay_position_in_field ) ;
			veh_info [ p_t_info [ playerid ] [ pl_quest ] - 1 ] [ v_cargo_object ] [ 0 ] = CreateDynamicObject ( 1454, hay_position_in_field [ _random ] [ 0 ],
																													hay_position_in_field [ _random ] [ 1 ],
																													hay_position_in_field [ _random ] [ 2 ],
																													hay_position_in_field [ _random ] [ 3 ],
																													hay_position_in_field [ _random ] [ 4 ],
																													hay_position_in_field [ _random ] [ 5 ] ) ;
		
			player_quest_area [ playerid ] [ 0 ] = CreateDynamicSphere ( hay_position_in_field [ _random ] [ 0 ], hay_position_in_field [ _random ] [ 1 ], hay_position_in_field [ _random ] [ 2 ], 5.0, -1, -1, playerid ) ;
			area_info [ player_quest_area [ playerid ] [ 0 ] ] [ a_type ] = area_type_hay ;
		
			is_quest_used { playerid } = 0 ;
			SetPlayerRaceCheckpoint ( playerid, 1, hay_position_in_field [ _random ] [ 0 ], hay_position_in_field [ _random ] [ 1 ], hay_position_in_field [ _random ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		}
		return 1 ;
	}
	else if ( _is_quest == 102 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		return 1 ;
	}
	else if ( _is_quest == 103 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
		
		for ( new i = 0 ; i < sizeof vehicle_attached_dft_hay ; i ++ )
		{
			DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i + 2 ] ) ;
		}
		
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вернитесь на ферму за наградой." ) ;
		
		is_quest_used { playerid } = 104 ;
		SetPlayerRaceCheckpoint ( playerid, 1, dft_position [ 0 ], dft_position [ 1 ], dft_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 104 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		for ( new i = 0 ; i < sizeof vehicle_attached_dft_fence ; i ++ )
		{
			DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
		}
		
		DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
		p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
		
		is_quest_used { playerid } = 250 ; 
		new _quest_id = player_quest [ playerid ] ;
		SetPlayerRaceCheckpoint ( playerid, 1, quest_position [ _quest_id ] [ 0 ], quest_position [ _quest_id ] [ 1 ], quest_position [ _quest_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 105 )
	{
		ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ) ;
	
		new Float:boot_pos [ 3 ] ;
		GetCoordBootVehicle ( p_t_info [ playerid ] [ pl_quest ], boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ) ;

		is_quest_used { playerid } = 106 ;
		SetPlayerRaceCheckpoint ( playerid, 1, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 106 )
	{
		player_quest_progress { playerid } ++ ;
		if ( player_quest_progress { playerid } >= 15 )
		{
			is_quest_used { playerid } = 107 ;
			SetPlayerRaceCheckpoint ( playerid, 1, faggio_unload_position [ 0 ], faggio_unload_position [ 1 ], faggio_unload_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы собрали яйца. Теперь их необходимо отвезти на переработку." ) ;
		}
		else
		{
			new scm_string [ 96 + 4 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы положили яйца в корзину. Осталось принести {"#cGInfo"}%d {"#cWH"}яиц.", 15 - player_quest_progress { playerid } ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;
		
			new _random = random ( sizeof chicken_coop_position ) ;
		
			is_quest_used { playerid } = 105 ;
			SetPlayerRaceCheckpoint ( playerid, 1, chicken_coop_position [ _random ] [ 0 ], chicken_coop_position [ _random ] [ 1 ], chicken_coop_position [ _random ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		}
		return 1 ;
	}
	else if ( _is_quest == 107 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вернитесь на ферму за наградой." ) ;
		
		is_quest_used { playerid } = 108 ;
		new _id = player_quest_vehicle_spawn { playerid } ;
		SetPlayerRaceCheckpoint ( playerid, 1, faggio_position [ _id ] [ 0 ], faggio_position [ _id ] [ 1 ], faggio_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 108 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		is_quest_used { playerid } = 250 ; 
		new _quest_id = player_quest [ playerid ] ;
		SetPlayerRaceCheckpoint ( playerid, 1, quest_position [ _quest_id ] [ 0 ], quest_position [ _quest_id ] [ 1 ], quest_position [ _quest_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 109 )
	{
		new _id = player_quest_vehicle_spawn { playerid } - 1 ;
		if ( IsPlayerInRangeOfPoint ( playerid, 4.0, field_cow_position [ _id ] [ 0 ], field_cow_position [ _id ] [ 1 ], field_cow_position [ _id ] [ 2 ] ) )
		{
			if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
			if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
		
			new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
			new engine, lights, alarm, doors, bonnet, boot, objective ;
			veh_info [ veh_id - 1 ] [ v_locked ] = true ;
			GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
			SetVehicleParamsEx ( veh_id, engine, lights, alarm, true, bonnet, boot, objective ) ;
			
			RemovePlayerFromVehicle ( playerid ) ;
			
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Возьмите ведро со стола и приступайте доить коров!" ) ;
		
			is_quest_used { playerid } = 0 ;
			SetPlayerRaceCheckpoint ( playerid, 1, bucket_pickup_position [ 0 ], bucket_pickup_position [ 1 ], bucket_pickup_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		}
		else
		{
			is_quest_used { playerid } = 109 ;
			SetPlayerRaceCheckpoint ( playerid, 1, field_cow_position [ _id ] [ 0 ], field_cow_position [ _id ] [ 1 ], field_cow_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		}
		return 1 ;
	}
	else if ( _is_quest == 110 )
	{
		ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ) ;
		
		new _id = player_quest_id { playerid } ;
		player_quest_object [ playerid ] [ 0 ] = CreateDynamicObject ( 19468, cow_bucket_position [ _id ] [ 0 ], cow_bucket_position [ _id ] [ 1 ], cow_bucket_position [ _id ] [ 2 ], 0.0, 0.0, 0.0 ) ;
		RemovePlayerAttachedObject ( playerid, 1 ) ;
		
		SetTimerEx ( "callback_milking", 3000, false, "i", playerid ) ;
		return 1 ;
	}
	else if ( _is_quest == 111 )
	{
		player_quest_progress { playerid } ++ ;
		if ( player_quest_progress { playerid } >= 10 )
		{
			RemovePlayerAttachedObject ( playerid, 1 ) ;
			
			is_quest_used { playerid } = 112 ;
			SetPlayerRaceCheckpoint ( playerid, 1, unload_milk_position [ 0 ], unload_milk_position [ 1 ], unload_milk_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отвезите молоко на склад!" ) ;
			
			new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
			new engine, lights, alarm, doors, bonnet, boot, objective ;
			veh_info [ veh_id - 1 ] [ v_locked ] = false ;
			GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
			SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
			return 1 ;
		}
		
		new scm_string [ 98 + 4 ] ;
		format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы принесли ведро с молоком. Осталось подоить {"#cGInfo"}%d {"#cWH"}коров.", 10 - player_quest_progress { playerid } ) ;
		SendClientMessage ( playerid, col_white, scm_string ) ;
	
		player_quest_id { playerid } = random ( sizeof cow_bucket_position ) ;
		is_quest_used { playerid } = 110 ;
		SetPlayerRaceCheckpoint ( playerid, 1, cow_bucket_position [ player_quest_id { playerid } ] [ 0 ], cow_bucket_position [ player_quest_id { playerid } ] [ 1 ], cow_bucket_position [ player_quest_id { playerid } ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 112 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
		
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вернитесь на ферму за наградой." ) ;
		
		is_quest_used { playerid } = 113 ;
		new _id = player_quest_vehicle_spawn { playerid } ;
		SetPlayerRaceCheckpoint ( playerid, 1, mule_vehicle_position [ _id ] [ 0 ], mule_vehicle_position [ _id ] [ 1 ], mule_vehicle_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 113 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		is_quest_used { playerid } = 250 ; 
		new _quest_id = player_quest [ playerid ] ;
		SetPlayerRaceCheckpoint ( playerid, 1, quest_position [ _quest_id ] [ 0 ], quest_position [ _quest_id ] [ 1 ], quest_position [ _quest_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 114 )
	{
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Теперь отправляйтесь на поле. Вспашите его, посадите семяна!" ) ;
		
		player_quest_step { playerid } = 0 ;
		is_quest_used { playerid } = 115 ;
		new _id = random ( sizeof farmer_tractor_checkpoint ) ;
		SetPlayerRaceCheckpoint ( playerid, 1, farmer_tractor_checkpoint [ _id ] [ 0 ], farmer_tractor_checkpoint [ _id ] [ 1 ], farmer_tractor_checkpoint [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 115 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		player_quest_step { playerid } ++ ;
		if ( player_quest_step { playerid } >= 20 )
		{
			player_quest_step { playerid } = 0 ;
			GameTextForPlayer ( playerid, "GOOD JOB!", 5000, 6 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вернитесь на ферму за наградой." ) ;
			
			is_quest_used { playerid } = 116 ;
			new _id = player_quest_vehicle_spawn { playerid } - 1 ;
			SetPlayerRaceCheckpoint ( playerid, 1, farmer_tractor_position [ _id ] [ 0 ], farmer_tractor_position [ _id ] [ 1 ], farmer_tractor_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			return 1 ;
		}
		
		new string [ 8 ] ;
		format ( string, sizeof string, "~g~%d", 20 - player_quest_step { playerid } ) ;
		GameTextForPlayer ( playerid, string, 5000, 6 ) ;
		
		is_quest_used { playerid } = 115 ;
		new _id = random ( sizeof farmer_tractor_checkpoint ) ;
		SetPlayerRaceCheckpoint ( playerid, 1, farmer_tractor_checkpoint [ _id ] [ 0 ], farmer_tractor_checkpoint [ _id ] [ 1 ], farmer_tractor_checkpoint [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 116 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		is_quest_used { playerid } = 250 ; 
		new _quest_id = player_quest [ playerid ] ;
		SetPlayerRaceCheckpoint ( playerid, 1, quest_position [ _quest_id ] [ 0 ], quest_position [ _quest_id ] [ 1 ], quest_position [ _quest_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 117 )
	{
		player_quest_step { playerid } = 0 ;
		is_quest_used { playerid } = 118 ;
		new _id = random ( sizeof farmer_camel_checkpoint ) ;
		SetPlayerRaceCheckpoint ( playerid, 3, farmer_camel_checkpoint [ _id ] [ 0 ], farmer_camel_checkpoint [ _id ] [ 1 ], farmer_camel_checkpoint [ _id ] [ 2 ], 0.0, 0.0, 0.0, 6.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 118 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		player_quest_step { playerid } ++ ;
		if ( player_quest_step { playerid } >= 20 )
		{
			player_quest_step { playerid } = 0 ;
			GameTextForPlayer ( playerid, "GOOD JOB!", 5000, 6 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вернитесь на ферму за наградой." ) ;
			
			is_quest_used { playerid } = 119 ;
			new _id = player_quest_vehicle_spawn { playerid } - 1 ;
			SetPlayerRaceCheckpoint ( playerid, 1, farmer_camel_position [ _id ] [ 0 ], farmer_camel_position [ _id ] [ 1 ], farmer_camel_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			return 1 ;
		}
		
		new string [ 8 ] ;
		format ( string, sizeof string, "~g~%d", 20 - player_quest_step { playerid } ) ;
		GameTextForPlayer ( playerid, string, 5000, 6 ) ;
		
		is_quest_used { playerid } = 118 ;
		new _id = random ( sizeof farmer_camel_checkpoint ) ;
		SetPlayerRaceCheckpoint ( playerid, 3, farmer_camel_checkpoint [ _id ] [ 0 ], farmer_camel_checkpoint [ _id ] [ 1 ], farmer_camel_checkpoint [ _id ] [ 2 ], 0.0, 0.0, 0.0, 6.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 119 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		is_quest_used { playerid } = 250 ; 
		new _quest_id = player_quest [ playerid ] ;
		SetPlayerRaceCheckpoint ( playerid, 1, quest_position [ _quest_id ] [ 0 ], quest_position [ _quest_id ] [ 1 ], quest_position [ _quest_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 120 )
	{
		is_quest_used { playerid } = 121 ;
		new _id = player_quest_vehicle_spawn { playerid } - 1 ;
		SetPlayerRaceCheckpoint ( playerid, 1, farmer_walton_field_position [ _id ] [ 0 ], farmer_walton_field_position [ _id ] [ 1 ], farmer_walton_field_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 121 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
		
		RemovePlayerFromVehicle ( playerid ) ;
	
		player_quest_step { playerid } = 0 ;
		is_quest_used { playerid } = 122 ;
		new _id = random ( sizeof farmer_pumpkin_position ) ;
		SetPlayerRaceCheckpoint ( playerid, 1, farmer_pumpkin_position [ _id ] [ 0 ], farmer_pumpkin_position [ _id ] [ 1 ], farmer_pumpkin_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		player_quest_object [ playerid ] [ 0 ] = CreateDynamicObject ( 19320, farmer_pumpkin_position [ _id ] [ 0 ], farmer_pumpkin_position [ _id ] [ 1 ], farmer_pumpkin_position [ _id ] [ 2 ], 0.0, 0.0, 0.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 122 )
	{
		DestroyDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
		
		ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
		SetPlayerAttachedObject ( playerid, 1, 19320, 5, 0.045000, 0.152000, 0.217000, 100.199966, -176.199951, 102.500015, 0.567000, 0.327000, 0.516000 ) ;
	
		new Float:boot_pos [ 3 ] ;
		GetCoordBootVehicle ( p_t_info [ playerid ] [ pl_quest ], boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ) ;

		is_quest_used { playerid } = 123 ;
		SetPlayerRaceCheckpoint ( playerid, 1, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 123 )
	{
		player_quest_step { playerid } ++ ;
		if ( player_quest_step { playerid } >= sizeof farmer_pumpkin_attached )
		{
			new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
			new engine, lights, alarm, doors, bonnet, boot, objective ;
			veh_info [ veh_id - 1 ] [ v_locked ] = true ;
			GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
			SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
			
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отвезите тыквы на склад!" ) ;
			
			is_quest_used { playerid } = 124 ;
			SetPlayerRaceCheckpoint ( playerid, 1, unload_pumpkin_position [ 0 ], unload_pumpkin_position [ 1 ], unload_pumpkin_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			return 1 ;
		}
		
		RemovePlayerAttachedObject ( playerid, 1 ) ;
		
		new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		new _c_id = player_quest_step { playerid } - 1 ;
		player_quest_vehicle_attached [ playerid ] [ _c_id ] = CreateDynamicObject ( 19320, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ) ;
		AttachDynamicObjectToVehicle( player_quest_vehicle_attached [ playerid ] [ _c_id ], veh_id, farmer_pumpkin_attached [ _c_id ] [ 0 ], 
																									farmer_pumpkin_attached [ _c_id ] [ 1 ], 
																									farmer_pumpkin_attached [ _c_id ] [ 2 ],   
																									farmer_pumpkin_attached [ _c_id ] [ 3 ], 
																									farmer_pumpkin_attached [ _c_id ] [ 4 ], 
																									farmer_pumpkin_attached [ _c_id ] [ 5 ] ) ;
		
		is_quest_used { playerid } = 122 ;
		new _id = random ( sizeof farmer_pumpkin_position ) ;
		SetPlayerRaceCheckpoint ( playerid, 1, farmer_pumpkin_position [ _id ] [ 0 ], farmer_pumpkin_position [ _id ] [ 1 ], farmer_pumpkin_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		player_quest_object [ playerid ] [ 0 ] = CreateDynamicObject ( 19320, farmer_pumpkin_position [ _id ] [ 0 ], farmer_pumpkin_position [ _id ] [ 1 ], farmer_pumpkin_position [ _id ] [ 2 ], 0.0, 0.0, 0.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 124 )
	{
		for ( new i = 0 ; i < sizeof farmer_pumpkin_attached ; i ++ )
		{
			DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
		}
		
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вернитесь на ферму за наградой." ) ;
			
		is_quest_used { playerid } = 125 ;
		new _id = player_quest_vehicle_spawn { playerid } - 1 ;
		SetPlayerRaceCheckpoint ( playerid, 1, farmer_walton_position [ _id ] [ 0 ], farmer_walton_position [ _id ] [ 1 ], farmer_walton_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 125 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		is_quest_used { playerid } = 250 ; 
		new _quest_id = player_quest [ playerid ] ;
		SetPlayerRaceCheckpoint ( playerid, 1, quest_position [ _quest_id ] [ 0 ], quest_position [ _quest_id ] [ 1 ], quest_position [ _quest_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 126 )
	{
		new _random = random ( sizeof cow_field_position ) ;
		
		new i = player_quest_progress { playerid } ;
		veh_info [ p_t_info [ playerid ] [ pl_quest ] - 1 ] [ v_cargo_object ] [ i ] = CreateDynamicObject ( 19833, cow_field_position [ _random ] [ 0 ], cow_field_position [ _random ] [ 1 ], cow_field_position [ _random ] [ 2 ],
																													cow_field_position [ _random ] [ 3 ], cow_field_position [ _random ] [ 4 ], cow_field_position [ _random ] [ 5 ] ) ;
		
		is_quest_used { playerid } = 0 ;
		SetPlayerRaceCheckpoint ( playerid, 1, cow_field_position [ _random ] [ 0 ], cow_field_position [ _random ] [ 1 ], cow_field_position [ _random ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
	
		player_quest_area [ playerid ] [ 0 ] = CreateDynamicSphere ( cow_field_position [ _random ] [ 0 ], cow_field_position [ _random ] [ 1 ], cow_field_position [ _random ] [ 2 ], 5.0, -1, -1, playerid ) ;
		area_info [ player_quest_area [ playerid ] [ 0 ] ] [ a_type ] = area_type_meat_loader ;
		return 1 ;
	}
	else if ( _is_quest == 127 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		for ( new i = 0 ; i < 3 ; i ++ )
		{
			DestroyDynamicObject ( veh_info [ veh_id - 1 ] [ v_cargo_object ] [ i ] ) ;
			veh_info [ veh_id - 1 ] [ v_cargo_object ] [ i ] = INVALID_OBJECT_ID ;
		}
		
		new _id = player_quest_vehicle_spawn { playerid } - 1 ;
		for ( new i = 0 ; i < 3 ; i ++ )
		{
			veh_info [ veh_id - 1 ] [ v_cargo_object ] [ i ] = CreateDynamicObject ( 19833, cow_factory_position [ ( _id * 3 ) + i ] [ 0 ], cow_factory_position [ ( _id * 3 ) + i ] [ 1 ], cow_factory_position [ ( _id * 3 ) + i ] [ 2 ],
																							cow_factory_position [ ( _id * 3 ) + i ] [ 3 ], cow_factory_position [ ( _id * 3 ) + i ] [ 4 ], cow_factory_position [ ( _id * 3 ) + i ] [ 5 ] ) ;
		}
		
		new engine, lights, alarm, doors, bonnet, boot, objective ;
		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
		
		RemovePlayerFromVehicle ( playerid ) ;
		
		is_quest_used { playerid } = 128 ;
		SetPlayerRaceCheckpoint ( playerid, 1, cow_factory_position [ _id * 3 ] [ 0 ], cow_factory_position [ _id * 3 ] [ 1 ], cow_factory_position [ _id * 3 ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		
		player_quest_progress { playerid } = 0 ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Заходите внутрь и подготовьтесь, пока животных будут разгружать. Возьмите бензопилу." ) ;
		return 1 ;
	}
	else if ( _is_quest == 128 )
	{
		if ( GetPlayerWeapon ( playerid ) != 9 ) return 1 ;
		
		ApplyAnimation ( playerid, "CHAINSAW", "WEAPON_csaw", 1.0, 1, 0, 0, 0, 6000, 0 ) ;
		p_t_info [ playerid ] [ p_animation ] = true ;
		
		SetTimerEx ( "callback_meat_factory", 6000, false, "i", playerid ) ;
		return 1 ;
	}
	else if ( _is_quest == 129 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		is_quest_used { playerid } = 250 ; 
		new _quest_id = player_quest [ playerid ] ;
		SetPlayerRaceCheckpoint ( playerid, 1, quest_position [ _quest_id ] [ 0 ], quest_position [ _quest_id ] [ 1 ], quest_position [ _quest_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 130 )
	{
		is_quest_used { playerid } = 131 ;
		SetPlayerRaceCheckpoint ( playerid, 1, bobcat_loaded [ 0 ], bobcat_loaded [ 1 ], bobcat_loaded [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 131 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
		
		if ( player_quest_vehicle_spawn { playerid } )
		{
			bobcat_position_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
			player_quest_vehicle_spawn { playerid } = 0 ;
		}
		
		new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		for ( new i = 0 ; i < sizeof bobcat_vehicle_attached ; i ++ )
		{
			player_quest_vehicle_attached [ playerid ] [ i ] = CreateDynamicObject( 2060, veh_info [ veh_id - 1 ] [ v_now_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_now_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_now_pos ] [ 2 ], 0.0, 0.0, veh_info [ veh_id - 1 ] [ v_now_pos ] [ 3 ] ) ;
			AttachDynamicObjectToVehicle( player_quest_vehicle_attached [ playerid ] [ i ], veh_id, bobcat_vehicle_attached [ i ] [ 0 ], 
																									bobcat_vehicle_attached [ i ] [ 1 ], 
																									bobcat_vehicle_attached [ i ] [ 2 ],   
																									bobcat_vehicle_attached [ i ] [ 3 ], 
																									bobcat_vehicle_attached [ i ] [ 4 ], 
																									bobcat_vehicle_attached [ i ] [ 5 ] ) ;
		}
		
		is_quest_used { playerid } = 132 ;
		SetPlayerRaceCheckpoint ( playerid, 1, bobcat_unloaded [ 0 ], bobcat_unloaded [ 1 ], bobcat_unloaded [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Транспорт загружен. Возвращайтесь на ферму." ) ;
		return 1 ;
	}
	else if ( _is_quest == 132 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
		p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
	
		for ( new i = 0 ; i < sizeof bobcat_vehicle_attached ; i ++ )
		{
			DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
		}

		is_quest_used { playerid } = 133 ;
		SetPlayerRaceCheckpoint ( playerid, 1, pick_bag_cow_food [ 0 ], pick_bag_cow_food [ 1 ], pick_bag_cow_food [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Теперь возьмите корм и отправляйтесь в сарай." ) ;
		return 1 ;
	}
	else if ( _is_quest == 133 )
	{
		ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
		p_t_info [ playerid ] [ p_animation ] = true ;
		
		SetPlayerAttachedObject ( playerid, 0, 2060, 6,0.0,0.10,-0.2, -110.0,0.0,78.0 ) ;
		
		new _random = random ( sizeof cow_food_position ) ;
		is_quest_used { playerid } = 134 ;
		SetPlayerRaceCheckpoint ( playerid, 1, cow_food_position [ _random ] [ 0 ], cow_food_position [ _random ] [ 1 ], cow_food_position [ _random ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 134 )
	{
		ApplyAnimation ( playerid, "CARRY", "putdwn", 4.0, 0, 1, 1, 0, 0, 1 ) ;
	
		player_quest_progress { playerid } ++ ;
		player_quest_step { playerid } ++ ;
		if ( player_quest_step { playerid } >= 2 )
		{
			RemovePlayerAttachedObject ( playerid, 0 ) ;
			
			is_quest_used { playerid } = 133 ;
			SetPlayerRaceCheckpoint ( playerid, 1, pick_bag_cow_food [ 0 ], pick_bag_cow_food [ 1 ], pick_bag_cow_food [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			p_t_info [ playerid ] [ p_animation ] = false ;
			
			player_quest_step { playerid } = 0 ;
			return 1 ;
		}
		
		if ( player_quest_progress { playerid } >= 10 )
		{
			RemovePlayerAttachedObject ( playerid, 0 ) ;
			
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вернитесь на ферму за наградой." ) ;
			
			is_quest_used { playerid } = 135 ;
			SetPlayerRaceCheckpoint ( playerid, 1, pick_bag_cow_food [ 0 ], pick_bag_cow_food [ 1 ], pick_bag_cow_food [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			p_t_info [ playerid ] [ p_animation ] = false ;
			return 1 ;
		}
		
		new _random = random ( sizeof cow_food_position ) ;
		is_quest_used { playerid } = 134 ;
		SetPlayerRaceCheckpoint ( playerid, 1, cow_food_position [ _random ] [ 0 ], cow_food_position [ _random ] [ 1 ], cow_food_position [ _random ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 135 )
	{
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		is_quest_used { playerid } = 250 ; 
		new _quest_id = player_quest [ playerid ] ;
		SetPlayerRaceCheckpoint ( playerid, 1, quest_position [ _quest_id ] [ 0 ], quest_position [ _quest_id ] [ 1 ], quest_position [ _quest_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 136 )
	{
		new _id = player_quest_vehicle_spawn { playerid } - 1 ;
		is_quest_used { playerid } = 137 ;
		SetPlayerRaceCheckpoint ( playerid, 1, yosemite_position_loaded [ _id ] [ 0 ], yosemite_position_loaded [ _id ] [ 1 ], yosemite_position_loaded [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отправляйтесь на место загрузки." ) ;
		return 1 ;
	}
	else if ( _is_quest == 137 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;

		is_quest_used { playerid } = 0 ;
		SetPlayerRaceCheckpoint ( playerid, 1, fruit_pickup_position [ 0 ], fruit_pickup_position [ 1 ], fruit_pickup_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Возьмите ящик для сбора фруктов." ) ;
		
		new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		
		new engine, lights, alarm, doors, bonnet, boot, objective ;
        veh_info [ veh_id - 1 ] [ v_locked ] = true ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, VEHICLE_PARAMS_OFF, lights, alarm, true, bonnet, boot, objective ) ;
		
		RemovePlayerFromVehicle ( playerid ) ;
		return 1 ;
	}
	else if ( _is_quest == 138 )
	{
		RemovePlayerAttachedObject ( playerid, 0 ) ;
	
		new _id = player_quest_step { playerid }, _box_id = apple_in_tree_box [ player_quest_id { playerid } - 1 ] ;
		player_quest_vehicle_attached [ playerid ] [ _id ] = CreateDynamicObject ( _box_id, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ) ;
		AttachDynamicObjectToVehicle( player_quest_vehicle_attached [ playerid ] [ _id ], p_t_info [ playerid ] [ pl_quest ], yosemite_vehicle_attached [ _id ] [ 0 ],
																																yosemite_vehicle_attached [ _id ] [ 1 ],
																																yosemite_vehicle_attached [ _id ] [ 2 ],
																																yosemite_vehicle_attached [ _id ] [ 3 ],
																																yosemite_vehicle_attached [ _id ] [ 4 ],
																																yosemite_vehicle_attached [ _id ] [ 5 ] ) ;
		
		player_quest_step { playerid } ++ ;
		
		if ( player_quest_step { playerid } >= sizeof yosemite_vehicle_attached )
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отправляйтесь на склад и разгрузите фрукты." ) ;
			
			is_quest_used { playerid } = 139 ;
			SetPlayerRaceCheckpoint ( playerid, 1, fruit_position_unload [ 0 ], fruit_position_unload [ 1 ], fruit_position_unload [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			
			new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
		
			new engine, lights, alarm, doors, bonnet, boot, objective ;
			veh_info [ veh_id - 1 ] [ v_locked ] = false ;
			GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
			SetVehicleParamsEx ( veh_id, VEHICLE_PARAMS_ON, lights, alarm, false, bonnet, boot, objective ) ;
			
			for ( new i = 0 ; i < sizeof apple_in_tree_players ; i ++ )
			{
				if ( apple_in_tree_players [ i ] == playerid )
				{
					apple_in_tree_players [ i ] = -1 ;
					break ;
				}
			}
			
			p_t_info [ playerid ] [ p_animation ] = false ;
			return 1 ;
		}

		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		new scm_string [ 100 + 4 ] ;
		format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы принесли ящик с фруктами. Осталось принести {"#cGInfo"}%d {"#cWH"}ящиков.", sizeof yosemite_vehicle_attached - player_quest_step { playerid } ) ;
		SendClientMessage ( playerid, col_white, scm_string ) ;
		
		player_quest_id { playerid } = 0 ;

		SetPlayerAttachedObject ( playerid, 0, apple_in_tree_box [ 3 ], 6, 0.0, 0.10, -0.2, -110.0, 0.0, 0.0 ) ;
		p_t_info [ playerid ] [ p_animation ] = true ;
		return 1 ;
	}
	else if ( _is_quest == 139 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		for ( new i = 0 ; i < sizeof yosemite_vehicle_attached ; i ++ )
		{
			DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
		}
	
		new _id = player_quest_vehicle_spawn { playerid } - 1 ;

		is_quest_used { playerid } = 140 ;
		SetPlayerRaceCheckpoint ( playerid, 1, yosemite_position [ _id ] [ 0 ], yosemite_position [ _id ] [ 1 ], yosemite_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;

		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вернитесь на ферму за наградой." ) ;
		return 1 ;
	}
	else if ( _is_quest == 140 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		is_quest_used { playerid } = 250 ; 
		new _quest_id = player_quest [ playerid ] ;
		SetPlayerRaceCheckpoint ( playerid, 1, quest_position [ _quest_id ] [ 0 ], quest_position [ _quest_id ] [ 1 ], quest_position [ _quest_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 150 )
	{
		new _id = random ( sizeof turtles_position ) ;
		is_quest_used { playerid } = 151 ;
		SetPlayerRaceCheckpoint ( playerid, 1, turtles_position [ _id ] [ 0 ], turtles_position [ _id ] [ 1 ], turtles_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		player_quest_object [ playerid ] [ 0 ] = CreateDynamicObject ( 1609, turtles_position [ _id ] [ 0 ], turtles_position [ _id ] [ 1 ], turtles_position [ _id ] [ 2 ],
																				turtles_position [ _id ] [ 3 ], turtles_position [ _id ] [ 4 ], turtles_position [ _id ] [ 5 ] ) ;
		
		player_quest_area [ playerid ] [ 0 ] = CreateDynamicSphere ( turtles_position [ _id ] [ 0 ], turtles_position [ _id ] [ 1 ], turtles_position [ _id ] [ 2 ], 5.0, -1, -1, playerid ) ;
		area_info [ player_quest_area [ playerid ] [ 0 ] ] [ a_type ] = area_type_turtle ;
		return 1 ;
	}
	else if ( _is_quest == 151 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Теперь ныряйте в воду и ловите черепаху." ) ;
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		return 1 ;
	}
	else if ( _is_quest == 152 )
	{
		if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID ) return 1 ;
		if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		is_quest_used { playerid } = 250 ; 
		new _quest_id = player_quest [ playerid ] ;
		SetPlayerRaceCheckpoint ( playerid, 1, quest_position [ _quest_id ] [ 0 ], quest_position [ _quest_id ] [ 1 ], quest_position [ _quest_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		return 1 ;
	}
	else if ( _is_quest == 250 )
	{
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		new sql_string [ 110 ], _quest_id = player_quest [ playerid ] ;
		
		player_quest_cooldown [ playerid ] [ _quest_id ] = SetElapsedTime ( gettime ( ), random ( 6 ) + 3, CONVERT_TIME_TO_HOURS ) ;
		
		format ( sql_string, sizeof sql_string, "UPDATE `users_quests` SET `u_farm_quest_%d` = '%d' WHERE `u_id` = '%d' LIMIT 1", _quest_id, player_quest_cooldown [ playerid ] [ _quest_id ], p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
		
		new _quest = player_quest [ playerid ] ;
		if ( _quest == 10 )
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы завершили квест." ) ;
				
			hay_player_quest -- ;
			hay_quest_active = false ;
			player_quest [ playerid ] = 0 ;
			
			player_quest_time [ playerid ] = 0 ;
			show_quest_ptd ( playerid, false ) ;

			new text_label [ 100 ] ;
			format ( text_label, sizeof text_label, "** Сено **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", hay_player_quest, ( hay_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
			UpdateDynamic3DTextLabelText ( hay_text, col_header_3d, text_label ) ;
			
			new _money = quest_hay_reward ;
		
			#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
			if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
			#endif
				
			give_money ( playerid, _money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест сено" ) ;
			
			format ( text_label, sizeof text_label, "{"#cWH"}Вы завершили задание и получили {"#cGN"}%d"valute_title"{"#cWH"}.", _money ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Сено", text_label, "Закрыть", "" ) ;
		}
		else if ( _quest == 11 )
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы завершили квест." ) ;
			
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
				
			if ( player_quest_vehicle_spawn { playerid } )
			{
				faggio_position_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
				player_quest_vehicle_spawn { playerid } = 0 ;
			}
			
			eggs_player_quest -- ;
			if ( eggs_player_quest < 4 )
			{
				if ( eggs_quest_active ) eggs_quest_active = false ;
			}
			
			player_quest [ playerid ] = 0 ;
			
			player_quest_time [ playerid ] = 0 ;
			show_quest_ptd ( playerid, false ) ;
				
			new text_label [ 100 ] ;
			format ( text_label, sizeof text_label, "** Сбор яиц **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", eggs_player_quest, ( eggs_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
			UpdateDynamic3DTextLabelText ( eggs_text, col_header_3d, text_label ) ;
			
			new _money = quest_eggs_reward ;
		
			#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
			if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
			#endif
				
			give_money ( playerid, _money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест яйца" ) ;
			
			format ( text_label, sizeof text_label, "{"#cWH"}Вы завершили задание и получили {"#cGN"}%d"valute_title"{"#cWH"}.", _money ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Сбор яиц", text_label, "Закрыть", "" ) ;
		}
		else if ( _quest == 12 )
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы завершили квест." ) ;
			
			if ( player_quest_vehicle_spawn { playerid } )
			{
				mule_position_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
				player_quest_vehicle_spawn { playerid } = 0 ;
			}
			
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
			
			milking_player_quest -- ;
			if ( milking_player_quest < 4 )
			{
				if ( milking_quest_active ) milking_quest_active = false ;
			}
			player_quest [ playerid ] = 0 ;
			
			player_quest_time [ playerid ] = 0 ;
			show_quest_ptd ( playerid, false ) ;
				
			new text_label [ 100 ] ;
			format ( text_label, sizeof text_label, "** Дойка коров **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", milking_player_quest, ( milking_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
			UpdateDynamic3DTextLabelText ( milking_text, col_header_3d, text_label ) ;
			
			new _money = quest_milking_reward ;
		
			#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
			if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
			#endif
				
			give_money ( playerid, _money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест дойка коров" ) ;
			
			format ( text_label, sizeof text_label, "{"#cWH"}Вы завершили задание и получили {"#cGN"}%d"valute_title"{"#cWH"}.", _money ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Дойка коров", text_label, "Закрыть", "" ) ;
		}
		else if ( _quest == 13 )
		{
			new _money = quest_farmer1_reward ;
		
			#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
			if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
			#endif
				
			give_money ( playerid, _money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест вспахивание поля" ) ;
		
			new scm_string [ 98 + 9 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы завершили квест (Этап №1). Награда за прохождение этапа: {"#cGInfo"}%d"valute_title_"", _money ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;
			
			if ( player_quest_vehicle_spawn { playerid } )
			{
				farmer_tractor_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
				player_quest_vehicle_spawn { playerid } = 0 ;
			}
			
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
			
			farmer_player_quest [ 0 ] -- ;
			if ( farmer_player_quest [ 0 ] < 4 )
			{
				if ( farmer_quest_active [ 0 ] ) farmer_quest_active [ 0 ] = false ;
			}
			player_quest [ playerid ] = 0 ;
			
			player_quest_time [ playerid ] = 0 ;
			show_quest_ptd ( playerid, false ) ;
			
			p_info [ playerid ] [ farmer_quest_id ] = 2 ;
			update_int_sql ( playerid, "u_farmer_quest_id", 2 ) ;
				
			new text_label [ 256 ] ;
			format ( text_label, sizeof text_label, "** Фермер **\n\n{"#cWH3D"}Игроков на квесте:\n\
																	{"#cBL3D"}1. {"#cWH3D"}Вспахивание поля: {"#cGN3D"}%d\n\
																	{"#cBL3D"}2. {"#cWH3D"}Распыление удобрения: {"#cGN3D"}%d\n\
																	{"#cBL3D"}3. {"#cWH3D"}Сбор тыкв: {"#cGN3D"}%d", farmer_player_quest [ 0 ], farmer_player_quest [ 1 ], farmer_player_quest [ 2 ] ) ;
			UpdateDynamic3DTextLabelText ( farmer_text, col_header_3d, text_label ) ;
		}
		else if ( _quest == 14 )
		{
			new _money = quest_farmer2_reward ;
		
			#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
			if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
			#endif
				
			give_money ( playerid, _money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест распыление удобрения" ) ;
			
			new scm_string [ 98 + 9 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы завершили квест (Этап №2). Награда за прохождение этапа: {"#cGInfo"}%d"valute_title_"", _money ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;
			
			if ( player_quest_vehicle_spawn { playerid } )
			{
				farmer_camel_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
				player_quest_vehicle_spawn { playerid } = 0 ;
			}
			
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
			
			farmer_player_quest [ 1 ] -- ;
			if ( farmer_player_quest [ 1 ] < 4 )
			{
				if ( farmer_quest_active [ 1 ] ) farmer_quest_active [ 1 ] = false ;
			}
			player_quest [ playerid ] = 0 ;
			
			player_quest_time [ playerid ] = 0 ;
			show_quest_ptd ( playerid, false ) ;
			
			p_info [ playerid ] [ farmer_quest_id ] = 3 ;
			update_int_sql ( playerid, "u_farmer_quest_id", 3 ) ;
				
			new text_label [ 256 ] ;
			format ( text_label, sizeof text_label, "** Фермер **\n\n{"#cWH3D"}Игроков на квесте:\n\
																	{"#cBL3D"}1. {"#cWH3D"}Вспахивание поля: {"#cGN3D"}%d\n\
																	{"#cBL3D"}2. {"#cWH3D"}Распыление удобрения: {"#cGN3D"}%d\n\
																	{"#cBL3D"}3. {"#cWH3D"}Сбор тыкв: {"#cGN3D"}%d", farmer_player_quest [ 0 ], farmer_player_quest [ 1 ], farmer_player_quest [ 2 ] ) ;
			UpdateDynamic3DTextLabelText ( farmer_text, col_header_3d, text_label ) ;
		}
		else if ( _quest == 15 )
		{
			new _money = quest_farmer3_reward + quest_farmer_all_reward ;
		
			#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
			if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
			#endif
				
			give_money ( playerid, _money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест сбор тыкв" ) ;
			
			new scm_string [ 98 + 9 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы завершили квест (Этап №3). Награда за прохождение этапа: {"#cGInfo"}%d"valute_title_"", quest_farmer3_reward ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;
			
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Награда за прохождение всех частей квеста: {"#cGInfo"}%d"valute_title_"", quest_farmer_all_reward ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;
			
			if ( player_quest_vehicle_spawn { playerid } )
			{
				farmer_walton_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
				player_quest_vehicle_spawn { playerid } = 0 ;
			}
			
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
			
			farmer_player_quest [ 2 ] -- ;
			if ( farmer_player_quest [ 2 ] < 4 )
			{
				if ( farmer_quest_active [ 2 ] ) farmer_quest_active [ 2 ] = false ;
			}
			player_quest [ playerid ] = 0 ;
			
			player_quest_time [ playerid ] = 0 ;
			show_quest_ptd ( playerid, false ) ;
			
			p_info [ playerid ] [ farmer_quest_id ] = 1 ;
			update_int_sql ( playerid, "u_farmer_quest_id", 1 ) ;
				
			new text_label [ 256 ] ;
			format ( text_label, sizeof text_label, "** Фермер **\n\n{"#cWH3D"}Игроков на квесте:\n\
																	{"#cBL3D"}1. {"#cWH3D"}Вспахивание поля: {"#cGN3D"}%d\n\
																	{"#cBL3D"}2. {"#cWH3D"}Распыление удобрения: {"#cGN3D"}%d\n\
																	{"#cBL3D"}3. {"#cWH3D"}Сбор тыкв: {"#cGN3D"}%d", farmer_player_quest [ 0 ], farmer_player_quest [ 1 ], farmer_player_quest [ 2 ] ) ;
			UpdateDynamic3DTextLabelText ( farmer_text, col_header_3d, text_label ) ;
		}
		else if ( _quest == 16 )
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы завершили квест." ) ;
			
			if ( player_quest_vehicle_spawn { playerid } )
			{
				dft_meat_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
				player_quest_vehicle_spawn { playerid } = 0 ;
			}
			
			for ( new i = 0 ; i < sizeof dft_meat_attached_fence ; i ++ )
			{
				DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
			}
			
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
			
			meat_player_quest -- ;
			if ( meat_player_quest < 4 )
			{
				if ( meat_quest_active ) meat_quest_active = false ;
			}
			player_quest [ playerid ] = 0 ;
			
			player_quest_time [ playerid ] = 0 ;
			show_quest_ptd ( playerid, false ) ;
				
			new text_label [ 110 ] ;
			format ( text_label, sizeof text_label, "** Мясокомбинат **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", meat_player_quest, ( meat_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
			UpdateDynamic3DTextLabelText ( meat_text, col_header_3d, text_label ) ;
			
			new _money = quest_meat_reward ;
		
			#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
			if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
			#endif
				
			give_money ( playerid, _money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест мясокомбинат" ) ;
			
			format ( text_label, sizeof text_label, "{"#cWH"}Вы завершили задание и получили {"#cGN"}%d"valute_title"{"#cWH"}.", _money ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Мясокомбинат", text_label, "Закрыть", "" ) ;
		}
		else if ( _quest == 17 )
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы завершили квест." ) ;

			cow_food_player_quest -- ;
			if ( cow_food_player_quest < 4 )
			{
				if ( cow_food_quest_active ) cow_food_quest_active = false ;
			}
			player_quest [ playerid ] = 0 ;
			
			player_quest_time [ playerid ] = 0 ;
			show_quest_ptd ( playerid, false ) ;
				
			new text_label [ 110 ] ;
			format ( text_label, sizeof text_label, "** Кормление коров **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", cow_food_player_quest, ( cow_food_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
			UpdateDynamic3DTextLabelText ( cow_food_text, col_header_3d, text_label ) ;
				
			new _money = quest_cow_food_reward ;
		
			#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
			if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
			#endif
			
			give_money ( playerid, _money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест кормление коров" ) ;
			
			format ( text_label, sizeof text_label, "{"#cWH"}Вы завершили задание и получили {"#cGN"}%d"valute_title"{"#cWH"}.", _money ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кормление коров", text_label, "Закрыть", "" ) ;
		}
		else if ( _quest == 18 )
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы завершили квест." ) ;

			fruit_player_quest -- ;
			if ( fruit_player_quest < 4 )
			{
				if ( fruit_quest_active ) fruit_quest_active = false ;
			}
			player_quest [ playerid ] = 0 ;
			
			player_quest_time [ playerid ] = 0 ;
			show_quest_ptd ( playerid, false ) ;
			
			if ( player_quest_vehicle_spawn { playerid } )
			{
				yosemite_position_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
				player_quest_vehicle_spawn { playerid } = 0 ;
			}
			
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
				
			new text_label [ 110 ] ;
			format ( text_label, sizeof text_label, "** Сбор фруктов **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", fruit_player_quest, ( fruit_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
			UpdateDynamic3DTextLabelText ( fruit_text, col_header_3d, text_label ) ;
			
			new _money = quest_fruit_reward ;
		
			#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
			if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
			#endif
			
			give_money ( playerid, _money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест сбор фруктов" ) ;
			
			format ( text_label, sizeof text_label, "{"#cWH"}Вы завершили задание и получили {"#cGN"}%d"valute_title"{"#cWH"}.", _money ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Сбор фруктов", text_label, "Закрыть", "" ) ;
		}
		else if ( _quest == 25 )
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы завершили квест." ) ;

			turtle_player_quest -- ;
			if ( turtle_player_quest < 4 )
			{
				if ( turtle_quest_active ) turtle_quest_active = false ;
			}
			player_quest [ playerid ] = 0 ;
			
			player_quest_time [ playerid ] = 0 ;
			show_quest_ptd ( playerid, false ) ;
			
			if ( player_quest_vehicle_spawn { playerid } )
			{
				reefer_position_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
				player_quest_vehicle_spawn { playerid } = 0 ;
			}
			
			if ( IsValidDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ) DestroyDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ;
			if ( IsValidDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ) DestroyDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
			
			for ( new i = 0 ; i < 11 ; i ++ )
			{
				if ( IsValidDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ) DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
			}
			
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
				
			new text_label [ 110 ] ;
			format ( text_label, sizeof text_label, "** Черепахи **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", turtle_player_quest, ( turtle_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
			UpdateDynamic3DTextLabelText ( turtle_text, col_header_3d, text_label ) ;
			
			new _money = quest_turtle_reward ;
		
			#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
			if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
			#endif
				
			give_money ( playerid, _money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест черепахи" ) ;
			
			format ( text_label, sizeof text_label, "{"#cWH"}Вы завершили задание и получили {"#cGN"}%d"valute_title"{"#cWH"}.", _money ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Черепахи", text_label, "Закрыть", "" ) ;
			
			give_event_progress ( playerid, THE_ISLAND_QUEST, 1 ) ;
		}
		else if ( _quest == 26 )
		{
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы завершили квест." ) ;

			pearle_player_quest -- ;
			if ( pearle_player_quest < 4 )
			{
				if ( pearle_quest_active ) pearle_quest_active = false ;
			}
			player_quest [ playerid ] = 0 ;
			
			player_quest_time [ playerid ] = 0 ;
			show_quest_ptd ( playerid, false ) ;
				
			new text_label [ 110 ] ;
			format ( text_label, sizeof text_label, "** Жемчуг **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", pearle_player_quest, ( pearle_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
			UpdateDynamic3DTextLabelText ( pearle_text, col_header_3d, text_label ) ;
			
			new _money = quest_pearle_reward ;
		
			#if defined m_perks
			new _perk_stats = get_perk_info ( playerid, PERK_QUEST ) ;
			if ( _perk_stats > 0 ) _money = _money + floatround ( ( _money * _perk_stats ) / 100 ) ;
			#endif
				
			give_money ( playerid, _money ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _money, "квест жемчуг" ) ;
			
			format ( text_label, sizeof text_label, "{"#cWH"}Вы завершили задание и получили {"#cGN"}%d"valute_title"{"#cWH"}.", _money ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Жемчуг", text_label, "Закрыть", "" ) ;
			
			give_event_progress ( playerid, THE_ISLAND_QUEST, 1 ) ;
		}
		return 1 ;
	}
	return 0 ;
}

stock quest_OnVehicleSpawn ( vehicleid )
{
	if ( veh_info [ vehicleid - 1 ] [ v_type ] == vehicle_type_quest )
	{
		new playerid = veh_info [ vehicleid - 1 ] [ v_renter ] ;
	    if ( IsPlayerConnected ( playerid ) )
		{
			if ( player_quest [ playerid ] != 0 )
			{
				quest_OnPlayerDisconnect ( playerid ) ;
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Арендованный транспорт был отбуксирован. Задание прервано!" ) ;
			}
			else
			{
				if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID ) DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ), p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Арендованный транспорт был отбуксирован. Задание прервано!" ) ;
			}
			veh_info [ vehicleid - 1 ] [ v_renter ] = INVALID_PLAYER_ID ;
		}
		else veh_info [ vehicleid - 1 ] [ v_renter ] = INVALID_PLAYER_ID ;
	}
	return 1 ;
}

stock quest_OnPlayerDisconnect ( playerid )
{
	new _quest = player_quest [ playerid ] ;
	if ( _quest == 1 )
	{
		if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID ) DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ), p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) RemovePlayerAttachedObject ( playerid, 1 ) ;
		maze_free [ player_quest_id { playerid } ] = false ;
		
		maze_player_quest -- ;
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		for ( new i = 0 ; i < 3 ; i ++ )
		{
			if ( IsValidDynamicPickup ( player_quest_pickup [ playerid ] [ i ] ) ) DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ i ] ) ;
			if ( quest_icon [ playerid ] [ i ] != -1 ) 
			{
				RemovePlayerMapIcon ( playerid, i ) ;
				quest_icon [ playerid ] [ i ] = -1 ;
				
				if ( maze_quest_active ) maze_quest_active = false ;
			}
			break ;
		}
		
		new text_label [ 100 ] ;
		format ( text_label, sizeof text_label, "** Ограбление **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", maze_player_quest, ( maze_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
		UpdateDynamic3DTextLabelText ( maze_text, col_header_3d, text_label ) ;
	}
	else if ( _quest == 2 )
	{
		graffity_player_quest -- ;
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		for ( new i = 0 ; i < 3 ; i ++ )
		{
			if ( IsValidDynamicObject ( player_quest_object [ playerid ] [ i ] ) ) DestroyDynamicObject ( player_quest_object [ playerid ] [ i ] ) ;
			if ( IsValidDynamicArea ( player_quest_area [ playerid ] [ i ] ) )
			{
				DestroyDynamicArea ( player_quest_area [ playerid ] [ i ] ) ;
				
				if ( graffity_quest_active ) graffity_quest_active = false ;
			}
			break ;
		}
		if ( IsValidDynamicPickup ( player_quest_pickup [ playerid ] [ 0 ] ) ) DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ 0 ] ) ;
		
		new text_label [ 100 ] ;
		format ( text_label, sizeof text_label, "** Граффити **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", graffity_player_quest, ( graffity_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
		UpdateDynamic3DTextLabelText ( graffity_text, col_header_3d, text_label ) ;
	}
	else if ( _quest == 10 )
	{
		for ( new i = 0 ; i < sizeof vehicle_attached_dft_fence +  sizeof vehicle_attached_dft_hay ; i ++ )
		{
			if ( IsValidDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ) DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
		}
		if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID ) DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ), p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
		if ( player_quest_vehicle [ playerid ] != INVALID_VEHICLE_ID ) DestroyVehicle ( player_quest_vehicle [ playerid ], 1 ), player_quest_vehicle [ playerid ] = INVALID_VEHICLE_ID ;
		if ( IsValidDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ) DestroyDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ;
		if ( hay_quest_active ) hay_quest_active = false ;
		hay_player_quest -- ;
		
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		new text_label [ 100 ] ;
		format ( text_label, sizeof text_label, "** Сено **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", hay_player_quest, ( hay_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
		UpdateDynamic3DTextLabelText ( hay_text, col_header_3d, text_label ) ;
	}
	else if ( _quest == 11 )
	{
		if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID ) DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ), p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
	
		if ( player_quest_vehicle_spawn { playerid } )
		{
			faggio_position_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
			player_quest_vehicle_spawn { playerid } = 0 ;
		}
		
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		eggs_player_quest -- ;
		if ( eggs_player_quest < 4 )
		{
			if ( eggs_quest_active ) eggs_quest_active = false ;
		}
	
		new text_label [ 100 ] ;
		format ( text_label, sizeof text_label, "** Сбор яиц **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", eggs_player_quest, ( eggs_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
		UpdateDynamic3DTextLabelText ( eggs_text, col_header_3d, text_label ) ;
	}
	else if ( _quest == 12 )
	{
		if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID ) DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ), p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
		if ( IsValidDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ) DestroyDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
		
		if ( player_quest_vehicle_spawn { playerid } )
		{
			mule_position_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
			player_quest_vehicle_spawn { playerid } = 0 ;
		}
		
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		milking_player_quest -- ;
		if ( milking_player_quest < 4 )
		{
			if ( milking_quest_active ) milking_quest_active = false ;
		}
		
		new text_label [ 100 ] ;
		format ( text_label, sizeof text_label, "** Дойка коров **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", milking_player_quest, ( milking_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
		UpdateDynamic3DTextLabelText ( milking_text, col_header_3d, text_label ) ;
	}
	else if ( _quest == 13 )
	{
		if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID ) DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ), p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;

		if ( player_quest_vehicle_spawn { playerid } )
		{
			farmer_tractor_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
			player_quest_vehicle_spawn { playerid } = 0 ;
		}
		
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		farmer_player_quest [ 0 ] -- ;
		if ( farmer_player_quest [ 0 ] < 4 )
		{
			if ( farmer_quest_active [ 0 ] ) farmer_quest_active [ 0 ] = false ;
		}
			
		new text_label [ 256 ] ;
		format ( text_label, sizeof text_label, "** Фермер **\n\n{"#cWH3D"}Игроков на квесте:\n\
																{"#cBL3D"}1. {"#cWH3D"}Вспахивание поля: {"#cGN3D"}%d\n\
																{"#cBL3D"}2. {"#cWH3D"}Распыление удобрения: {"#cGN3D"}%d\n\
																{"#cBL3D"}3. {"#cWH3D"}Сбор тыкв: {"#cGN3D"}%d", farmer_player_quest [ 0 ], farmer_player_quest [ 1 ], farmer_player_quest [ 2 ] ) ;
		UpdateDynamic3DTextLabelText ( farmer_text, col_header_3d, text_label ) ;
	}
	else if ( _quest == 14 )
	{
		if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID ) DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ), p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;

		if ( player_quest_vehicle_spawn { playerid } )
		{
			farmer_camel_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
			player_quest_vehicle_spawn { playerid } = 0 ;
		}
		
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		farmer_player_quest [ 1 ] -- ;
		if ( farmer_player_quest [ 1 ] < 4 )
		{
			if ( farmer_quest_active [ 1 ] ) farmer_quest_active [ 1 ] = false ;
		}
			
		new text_label [ 256 ] ;
		format ( text_label, sizeof text_label, "** Фермер **\n\n{"#cWH3D"}Игроков на квесте:\n\
																{"#cBL3D"}1. {"#cWH3D"}Вспахивание поля: {"#cGN3D"}%d\n\
																{"#cBL3D"}2. {"#cWH3D"}Распыление удобрения: {"#cGN3D"}%d\n\
																{"#cBL3D"}3. {"#cWH3D"}Сбор тыкв: {"#cGN3D"}%d", farmer_player_quest [ 0 ], farmer_player_quest [ 1 ], farmer_player_quest [ 2 ] ) ;
		UpdateDynamic3DTextLabelText ( farmer_text, col_header_3d, text_label ) ;
	}
	else if ( _quest == 15 )
	{
		for ( new i = 0 ; i < sizeof farmer_pumpkin_attached ; i ++ )
		{
			if ( IsValidDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ) DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
		}
		
		if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID ) DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ), p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
		if ( IsValidDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ) DestroyDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
		
		if ( player_quest_vehicle_spawn { playerid } )
		{
			farmer_walton_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
			player_quest_vehicle_spawn { playerid } = 0 ;
		}
		
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		farmer_player_quest [ 2 ] -- ;
		if ( farmer_player_quest [ 2 ] < 4 )
		{
			if ( farmer_quest_active [ 2 ] ) farmer_quest_active [ 2 ] = false ;
		}
			
		new text_label [ 256 ] ;
		format ( text_label, sizeof text_label, "** Фермер **\n\n{"#cWH3D"}Игроков на квесте:\n\
																{"#cBL3D"}1. {"#cWH3D"}Вспахивание поля: {"#cGN3D"}%d\n\
																{"#cBL3D"}2. {"#cWH3D"}Распыление удобрения: {"#cGN3D"}%d\n\
																{"#cBL3D"}3. {"#cWH3D"}Сбор тыкв: {"#cGN3D"}%d", farmer_player_quest [ 0 ], farmer_player_quest [ 1 ], farmer_player_quest [ 2 ] ) ;
		UpdateDynamic3DTextLabelText ( farmer_text, col_header_3d, text_label ) ;
	}
	else if ( _quest == 16 )
	{
		if ( IsValidDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ) DestroyDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
		if ( IsValidDynamicObject ( player_quest_object [ playerid ] [ 1 ] ) ) DestroyDynamicObject ( player_quest_object [ playerid ] [ 1 ] ) ;
		if ( IsValidDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ) DestroyDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ;
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
		RemoveWeaponFromSlot ( playerid, get_weapon_slot ( 9 ) ) ;
		
		for ( new i = 0 ; i < 3 ; i ++ )
		{
			if ( IsValidDynamicPickup ( player_quest_pickup [ playerid ] [ i ] ) ) DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ i ] ) ;
		}
		
		for ( new i = 0 ; i < sizeof move_max_playerid ; i ++ )
		{
			if ( move_max_playerid [ i ] == playerid )
			{
				move_max_playerid [ i ] = -1 ;
				break ;
			}
		}
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;

		if ( player_quest_vehicle_spawn { playerid } )
		{
			dft_meat_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
			player_quest_vehicle_spawn { playerid } = 0 ;
		}
		
		for ( new i = 0 ; i < sizeof dft_meat_attached_fence ; i ++ )
		{
			if ( IsValidDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ) DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
		}
		
		if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID )
		{
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
		}
		
		meat_player_quest -- ;
		if ( meat_player_quest < 4 )
		{
			if ( meat_quest_active ) meat_quest_active = false ;
		}
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
			
		new text_label [ 110 ] ;
		format ( text_label, sizeof text_label, "** Мясокомбинат **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", meat_player_quest, ( meat_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
		UpdateDynamic3DTextLabelText ( meat_text, col_header_3d, text_label ) ;
	}
	else if ( _quest == 17 )
	{
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
		for ( new i = 0 ; i < sizeof bobcat_vehicle_attached ; i ++ )
		{
			if ( IsValidDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ) DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
		}
		
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;
		
		if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID )
		{
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
		}
		
		cow_food_player_quest -- ;
		if ( cow_food_player_quest < 4 )
		{
			if ( cow_food_quest_active ) cow_food_quest_active = false ;
		}
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
			
		new text_label [ 110 ] ;
		format ( text_label, sizeof text_label, "** Кормление коров **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", cow_food_player_quest, ( cow_food_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
		UpdateDynamic3DTextLabelText ( cow_food_text, col_header_3d, text_label ) ;
	}
	else if ( _quest == 18 )
	{
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
		for ( new i = 0 ; i < sizeof yosemite_vehicle_attached ; i ++ )
		{
			if ( IsValidDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ) DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
		}
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;

		fruit_player_quest -- ;
		if ( fruit_player_quest < 4 )
		{
			if ( fruit_quest_active ) fruit_quest_active = false ;
		}
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
		
		for ( new i = 0 ; i < sizeof apple_in_tree_players ; i ++ )
		{
			if ( apple_in_tree_players [ i ] == playerid )
			{
				apple_in_tree_players [ i ] = -1 ;
				break ;
			}
		}
		
		if ( player_quest_vehicle_spawn { playerid } )
		{
			yosemite_position_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
			player_quest_vehicle_spawn { playerid } = 0 ;
		}
		
		if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID )
		{
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
		}
		
		new text_label [ 110 ] ;
		format ( text_label, sizeof text_label, "** Сбор фруктов **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", fruit_player_quest, ( fruit_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
		UpdateDynamic3DTextLabelText ( fruit_text, col_header_3d, text_label ) ;
	}
	else if ( _quest == 25 )
	{
		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) RemovePlayerAttachedObject ( playerid, 0 ) ;
	
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;

		turtle_player_quest -- ;
		if ( turtle_player_quest < 4 )
		{
			if ( turtle_quest_active ) turtle_quest_active = false ;
		}
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
		
		if ( player_quest_vehicle_spawn { playerid } )
		{
			reefer_position_toggled [ player_quest_vehicle_spawn { playerid } - 1 ] = false ;
			player_quest_vehicle_spawn { playerid } = 0 ;
		}
		
		if ( IsValidDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ) DestroyDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ;
		if ( IsValidDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ) DestroyDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
		
		for ( new i = 0 ; i < 11 ; i ++ )
		{
			if ( IsValidDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ) DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
		}
		
		if ( p_t_info [ playerid ] [ pl_quest ] != INVALID_VEHICLE_ID )
		{
			DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
			p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
		}
			
		new text_label [ 110 ] ;
		format ( text_label, sizeof text_label, "** Черепахи **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", turtle_player_quest, ( turtle_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
		UpdateDynamic3DTextLabelText ( turtle_text, col_header_3d, text_label ) ;
	}
	else if ( _quest == 26 )
	{
		is_quest_used { playerid } = 0 ;
		DisablePlayerRaceCheckpoint ( playerid ) ;

		pearle_player_quest -- ;
		if ( pearle_player_quest < 4 )
		{
			if ( pearle_quest_active ) pearle_quest_active = false ;
		}
		player_quest [ playerid ] = 0 ;
		
		player_quest_time [ playerid ] = 0 ;
		show_quest_ptd ( playerid, false ) ;
			
		new text_label [ 110 ] ;
		format ( text_label, sizeof text_label, "** Жемчуг **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", pearle_player_quest, ( pearle_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
		UpdateDynamic3DTextLabelText ( pearle_text, col_header_3d, text_label ) ;
	}
	return 1 ;
}

stock quest_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_farmer_quest:
		{
			if ( ! response ) return 1 ;
			
			if ( listitem == 0 )
			{
				if ( p_info [ playerid ] [ drive_lic ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет водительских прав!" ) ;
				if ( p_info [ playerid ] [ farmer_quest_id ] != 1 ) return 1 ;
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( farmer_quest_active [ 0 ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент поле занято, подождите пока игрок пройдёт квест!" ) ;

				farmer_player_quest [ 0 ] ++ ;
				if ( farmer_player_quest [ 0 ] >= 4 ) farmer_quest_active [ 0 ] = true ;
				
				create_player_farmer ( playerid, 1 ) ;
			}
			else if ( listitem == 1 )
			{
				if ( p_info [ playerid ] [ fly_lic ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет лицензии пилота!" ) ;
				if ( p_info [ playerid ] [ farmer_quest_id ] != 2 ) return 1 ;
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( farmer_quest_active [ 1 ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент поле занято, подождите пока игрок пройдёт квест!" ) ;

				farmer_player_quest [ 1 ] ++ ;
				if ( farmer_player_quest [ 1 ] >= 4 ) farmer_quest_active [ 1 ] = true ;
				
				create_player_farmer ( playerid, 2 ) ;
			}
			else if ( listitem == 2 )
			{
				if ( p_info [ playerid ] [ drive_lic ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет водительских прав!" ) ;
				if ( p_info [ playerid ] [ farmer_quest_id ] != 3 ) return 1 ;
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( farmer_quest_active [ 2 ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент поле занято, подождите пока игрок пройдёт квест!" ) ;

				farmer_player_quest [ 2 ] ++ ;
				if ( farmer_player_quest [ 2 ] >= 4 ) farmer_quest_active [ 2 ] = true ;
				
				create_player_farmer ( playerid, 3 ) ;
			}
			return 1 ;
		}
		case d_maze_quest:
		{
			if ( ! response ) return clear_player_use_listitem ( playerid ) ;
			
			new list_item = get_player_use_listitem ( playerid ) ;
			clear_player_use_listitem ( playerid ) ;
			
			if ( player_quest_cooldown [ playerid ] [ list_item ] > gettime ( ) )
			{
				new line_string [ 100 ] ;
				new s_year, s_month, s_day, s_hour, s_minute, s_second ;
				timestamp_to_date ( player_quest_cooldown [ playerid ] [ list_item ] + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				
				format ( line_string, sizeof line_string, "{"#cRInfo"}* {"#cGRInfo"}Квест будет доступен %02d.%02d.%d в %02d:%02d:%02d.", s_day, s_month, s_year, s_hour, s_minute, s_second ) ;
				SendClientMessage ( playerid, col_gray, line_string ) ;
				return 1 ;
			}
			
			if ( list_item == 1 )
			{
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( p_info [ playerid ] [ drive_lic ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет водительских прав!" ) ;
				if ( ! gang_player ( playerid ) && ! mafia_player ( playerid ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Квест доступен для криминальных организаций!" ) ;
				if ( maze_player_quest >= 5 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент на квесте находится максимальное количество человек!" ) ;
				if ( maze_quest_active == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент лабиринт занят, подождите не много!" ) ;
		
				create_player_maze ( playerid ) ;
			}
			else if ( list_item == 2 )
			{
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( p_info [ playerid ] [ drive_lic ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет водительских прав!" ) ;
				if ( ! gang_player ( playerid ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Квест доступен для криминальных организаций!" ) ;
				if ( graffity_quest_active == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент склад с коробками занят, подождите не много!" ) ;
		
				create_player_graffity ( playerid ) ;
			}
			else if ( list_item == 10 )
			{
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( p_info [ playerid ] [ drive_lic ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет водительских прав!" ) ;
				if ( hay_quest_active == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент поле занято, подождите пока игрок пройдёт квест!" ) ;
		
				hay_player_quest ++ ;
				hay_quest_active = true ;
		
				create_player_hay ( playerid, 1 ) ;
			}
			else if ( list_item == 11 )
			{
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( p_info [ playerid ] [ drive_lic ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет водительских прав!" ) ;
				if ( eggs_quest_active == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент курятник занят, подождите пока игрок пройдёт квест!" ) ;
		
				eggs_player_quest ++ ;
				if ( eggs_player_quest >= 4 ) eggs_quest_active = true ;
		
				create_player_eggs ( playerid ) ;
			}
			else if ( list_item == 12 )
			{
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( p_info [ playerid ] [ drive_lic ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет водительских прав!" ) ;
				if ( milking_quest_active == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент поле с коровами занято, подождите пока игрок пройдёт квест!" ) ;

				milking_player_quest ++ ;
				if ( milking_player_quest >= 4 ) milking_quest_active = true ;
		
				create_player_milking ( playerid ) ;
			}
			else if ( list_item == 16 )
			{
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( p_info [ playerid ] [ drive_lic ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет водительских прав!" ) ;
				if ( meat_quest_active == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент все места заняты, подождите пока игрок пройдёт квест!" ) ;

				meat_player_quest ++ ;
				if ( meat_player_quest >= 4 ) meat_quest_active = true ;
		
				create_player_meat ( playerid ) ;
			}
			else if ( list_item == 17 )
			{
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( p_info [ playerid ] [ drive_lic ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет водительских прав!" ) ;
				if ( cow_food_quest_active == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент все места заняты, подождите пока игрок пройдёт квест!" ) ;

				cow_food_player_quest ++ ;
				if ( cow_food_player_quest >= 4 ) cow_food_quest_active = true ;
		
				create_player_cow_food ( playerid ) ;
			}
			else if ( list_item == 18 )
			{
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( p_info [ playerid ] [ drive_lic ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет водительских прав!" ) ;
				if ( fruit_quest_active == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент все места заняты, подождите пока игрок пройдёт квест!" ) ;

				for ( new i = 0 ; i < sizeof apple_in_tree_players ; i ++ )
				{
					if ( apple_in_tree_players [ i ] != -1 ) continue ;
					
					apple_in_tree_players [ i ] = playerid ;
					break ;
				}

				fruit_player_quest ++ ;
				if ( fruit_player_quest >= 4 ) fruit_quest_active = true ;
				else if ( fruit_player_quest == 1 ) apple_in_tree_timer = SetTimer ( "callback_apple_in_tree", 60 * 1000, true ) ; 
		
				create_apple_in_tree ( ) ;
				create_player_fruit ( playerid ) ;
			}
			else if ( list_item == 25 )
			{
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( p_info [ playerid ] [ boat_lic ] != 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет лицензии на водный транспорт!" ) ;
				if ( turtle_quest_active == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент все места заняты, подождите пока игрок пройдёт квест!" ) ;

				turtle_player_quest ++ ;
				if ( turtle_player_quest >= 4 ) turtle_quest_active = true ;

				create_player_turtle ( playerid ) ;
			}
			else if ( list_item == 26 )
			{
				if ( player_quest [ playerid ] != 0 ) return 1 ;
				if ( pearle_quest_active == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данный момент все места заняты, подождите пока игрок пройдёт квест!" ) ;

				pearle_player_quest ++ ;
				if ( pearle_player_quest >= 4 ) pearle_quest_active = true ;

				create_player_pearle ( playerid ) ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock quest_PickUpDynamicPickup ( playerid, pickupid )
{
	switch ( pick_info [ pickupid ] [ pick_type ] )
	{
		case pick_type_quest_shotgun:
		{
			give_weapon ( playerid, 25, 10 ) ;
			DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ 0 ] ) ;
			return 1 ;
		}
		case pick_type_fruit:
		{
			if ( player_quest [ playerid ] != 18 ) return 1 ;
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
			
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы взяли ящик. Теперь ищите деревья с фруктами и собирайте фрукты!" ) ;
			
			ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
			SetPlayerAttachedObject ( playerid, 0, apple_in_tree_box [ 3 ], 6, 0.0, 0.10, -0.2, -110.0, 0.0, 0.0 ) ;
			p_t_info [ playerid ] [ p_animation ] = true ;
			
			is_quest_used { playerid } = 0 ;
			DisablePlayerRaceCheckpoint ( playerid ) ;
			return 1 ;
		}
		case pick_type_factory_saw:
		{
			if ( player_quest [ playerid ] != 16 ) return 1 ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы взяли бензопилу. Отправляйтесь к коровам!" ) ;
			
			give_weapon ( playerid, 9, 1 ) ;
			return 1 ;
		}
		case pick_type_meat:
		{
			if ( player_quest [ playerid ] != 16 ) return 1 ;
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
			if ( IsValidDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ) return 1 ;
			
			ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
			p_t_info [ playerid ] [ p_animation ] = true ;
			
			SetPlayerAttachedObject ( playerid, 0, 2806, 6,0.0,0.10,-0.2, -110.0,0.0,78.0 ) ;
			
			new veh_id = p_t_info [ playerid ] [ pl_quest ] ;
			DestroyDynamicObject ( veh_info [ veh_id - 1 ] [ v_cargo_object ] [ player_quest_progress { playerid } ] ) ;
			veh_info [ veh_id - 1 ] [ v_cargo_object ] [ player_quest_progress { playerid } ] = INVALID_OBJECT_ID ;
			
			player_quest_progress { playerid } ++ ;
			return 1 ;
		}
		case pick_type_meat_use_factory:
		{
			if ( player_quest [ playerid ] != 16 ) return 1 ;
			if ( ! IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
			
			ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
			RemovePlayerAttachedObject ( playerid, 0 ) ;
			
			for ( new i = 0 ; i < sizeof move_max_playerid ; i ++ )
			{
				if ( move_max_playerid [ i ] != -1 ) continue ;
				
				move_max_playerid [ i ] = playerid ;
				break ;
			}
			
			player_quest_object [ playerid ] [ 0 ] = CreateDynamicObject ( 2806, move_big_meat_factory [ 0 ] [ 0 ], move_big_meat_factory [ 0 ] [ 1 ], move_big_meat_factory [ 0 ] [ 2 ],
																				move_big_meat_factory [ 0 ] [ 3 ], move_big_meat_factory [ 0 ] [ 4 ], move_big_meat_factory [ 0 ] [ 5 ] ) ;
			
			MoveDynamicObject ( player_quest_object [ playerid ] [ 0 ], move_big_meat_factory [ 1 ] [ 0 ], move_big_meat_factory [ 1 ] [ 1 ], move_big_meat_factory [ 1 ] [ 2 ], 1.0,
																		move_big_meat_factory [ 1 ] [ 3 ], move_big_meat_factory [ 1 ] [ 4 ], move_big_meat_factory [ 1 ] [ 5 ] ) ;
			
			player_quest_step { playerid } = 1 ;
			DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ 1 ] ) ;
			return 1 ;
		}
		case pick_type_meat_loader:
		{
			if ( player_quest [ playerid ] != 16 ) return 1 ;
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
			
			if ( player_quest_step { playerid } == 4 ) 
			{
				ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
				p_t_info [ playerid ] [ p_animation ] = true ;
				
				SetPlayerAttachedObject ( playerid, 0, 3013, 6,0.0,0.10,-0.2, -110.0,0.0,78.0 ) ;
				
				DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ 1 ] ) ;
				DestroyDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
				return 1 ; // Чтоб дальше код не шёл
			}
			else 
			{
				ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
				p_t_info [ playerid ] [ p_animation ] = true ;
				
				SetPlayerAttachedObject ( playerid, 0, 2804, 6,0.0,0.10,-0.2, -110.0,0.0,78.0 ) ;
			}
			
			if ( player_quest_selector { playerid } == 0 ) DestroyDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
			else
			{
				DestroyDynamicObject ( player_quest_object [ playerid ] [ 1 ] ) ;
				DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ 1 ] ) ;
			}
			player_quest_selector { playerid } ++ ;
			return 1 ;
		}
		case pick_type_meat_unloader:
		{
			if ( player_quest [ playerid ] != 16 ) return 1 ;
			if ( ! IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
			
			ApplyAnimation ( playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
			RemovePlayerAttachedObject ( playerid, 0 ) ;
			
			if ( player_quest_step { playerid } == 4 ) 
			{
				if ( player_quest_progress { playerid } >= 3 )
				{
					new _id = player_quest_vehicle_spawn { playerid } - 1 ;

					is_quest_used { playerid } = 129 ;
					SetPlayerRaceCheckpoint ( playerid, 1, dft_meat_position [ _id ] [ 0 ], dft_meat_position [ _id ] [ 1 ], dft_meat_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
					
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вернитесь на ферму за наградой." ) ;
					DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ 2 ] ) ;
				}
				else
				{
					DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ 2 ] ) ;
				
					player_quest_pickup [ playerid ] [ 1 ] = CreateDynamicPickup ( 1239, 23, pickup_meat_factory [ 1 ] [ 0 ], pickup_meat_factory [ 1 ] [ 1 ], pickup_meat_factory [ 1 ] [ 2 ], GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ), playerid ) ;
					pick_info [ player_quest_pickup [ playerid ] [ 1 ] ] [ pick_type ] = pick_type_meat_use_factory ;
					
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Теперь нужно положить на конвеер следующую тушу." ) ;
				}
				return 1 ; // Чтоб дальше код не шёл
			}
			
			if ( ! IsValidDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ) 
			{
				player_quest_object [ playerid ] [ 0 ] = CreateDynamicObject ( 2804, move_smol_meat_factory_box [ 0 ] [ 0 ], move_smol_meat_factory_box [ 0 ] [ 1 ], move_smol_meat_factory_box [ 0 ] [ 2 ],
																					move_smol_meat_factory_box [ 0 ] [ 3 ], move_smol_meat_factory_box [ 0 ] [ 4 ], move_smol_meat_factory_box [ 0 ] [ 5 ] ) ;
			}
			else
			{
				MoveDynamicObject ( player_quest_object [ playerid ] [ 0 ], move_smol_meat_factory_box [ 2 ] [ 0 ], move_smol_meat_factory_box [ 2 ] [ 1 ], move_smol_meat_factory_box [ 2 ] [ 2 ], 1.0,
																			move_smol_meat_factory_box [ 2 ] [ 3 ], move_smol_meat_factory_box [ 2 ] [ 4 ], move_smol_meat_factory_box [ 2 ] [ 5 ] ) ;
																				
				player_quest_object [ playerid ] [ 1 ] = CreateDynamicObject ( 2804, move_smol_meat_factory_box [ 1 ] [ 0 ], move_smol_meat_factory_box [ 1 ] [ 1 ], move_smol_meat_factory_box [ 1 ] [ 2 ],
																					move_smol_meat_factory_box [ 1 ] [ 3 ], move_smol_meat_factory_box [ 1 ] [ 4 ], move_smol_meat_factory_box [ 1 ] [ 5 ] ) ;
																					
				MoveDynamicObject ( player_quest_object [ playerid ] [ 1 ], move_smol_meat_factory_box [ 3 ] [ 0 ], move_smol_meat_factory_box [ 3 ] [ 1 ], move_smol_meat_factory_box [ 3 ] [ 2 ], 1.0,
																			move_smol_meat_factory_box [ 3 ] [ 3 ], move_smol_meat_factory_box [ 3 ] [ 4 ], move_smol_meat_factory_box [ 3 ] [ 5 ] ) ;
				
				DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ 2 ] ) ;
			}
			return 1 ;
		}
		case pick_type_quest_bucket:
		{
			if ( player_quest [ playerid ] != 12 ) return 1 ;
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) ) return 1 ;
			
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы взяли ведро. Отправляйтесь доить коров!" ) ;
			
			SetPlayerAttachedObject ( playerid, 1, 19468, 5, 0.378001, 0.003001, -0.014999, 53.500022, -94.900039, -33.999877, 0.963998, 0.916998, 1.000000 ) ;
			
			player_quest_id { playerid } = random ( sizeof cow_bucket_position ) ;
			is_quest_used { playerid } = 110 ;
			
			new _quest = player_quest_id { playerid } ;
			SetPlayerRaceCheckpoint ( playerid, 1, cow_bucket_position [ _quest ] [ 0 ], cow_bucket_position [ _quest ] [ 1 ], cow_bucket_position [ _quest ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			return 1 ;
		}
		case pick_type_farmer_enter:
		{
			new quest_text_1 [ 42 ],
				quest_text_2 [ 42 ],
				quest_text_3 [ 42 ] ;
			
			new _quest = p_info [ playerid ] [ farmer_quest_id ] ;
			if ( _quest == 1 )
			{
				format ( quest_text_1, sizeof quest_text_1, "{"#cWH"}[ {"#cGN"}ДОСТУПЕН {"#cWH"}]" ) ;
				format ( quest_text_2, sizeof quest_text_2, "{"#cWH"}[ {"#cRD"}НЕДОСТУПЕН {"#cWH"}]" ) ;
				format ( quest_text_3, sizeof quest_text_3, "{"#cWH"}[ {"#cRD"}НЕДОСТУПЕН {"#cWH"}]" ) ;
			}
			else if (_quest == 2 )
			{
				format ( quest_text_1, sizeof quest_text_1, "{"#cWH"}[ {"#cRD"}НЕДОСТУПЕН {"#cWH"}]" ) ;
				format ( quest_text_2, sizeof quest_text_2, "{"#cWH"}[ {"#cGN"}ДОСТУПЕН {"#cWH"}]" ) ;
				format ( quest_text_3, sizeof quest_text_3, "{"#cWH"}[ {"#cRD"}НЕДОСТУПЕН {"#cWH"}]" ) ;
			}
			else if ( _quest == 3 )
			{
				format ( quest_text_1, sizeof quest_text_1, "{"#cWH"}[ {"#cRD"}НЕДОСТУПЕН {"#cWH"}]" ) ;
				format ( quest_text_2, sizeof quest_text_2, "{"#cWH"}[ {"#cRD"}НЕДОСТУПЕН {"#cWH"}]" ) ;
				format ( quest_text_3, sizeof quest_text_3, "{"#cWH"}[ {"#cGN"}ДОСТУПЕН {"#cWH"}]" ) ;
			}
		
			new dialog_string [ 256 ] ;
			format ( dialog_string, sizeof dialog_string, "{"#cBL"}1. {"#cWH"}Вспахивание поля %s\n\
															{"#cBL"}2. {"#cWH"}Распыление удобрения %s\n\
															{"#cBL"}3. {"#cWH"}Сбор тыкв %s", quest_text_1, quest_text_2, quest_text_3 ) ;
			show_dialog ( playerid, d_farmer_quest, DIALOG_STYLE_LIST, "{"#cBHD"}Фермер", dialog_string, "Выбрать", "Закрыть" ) ;
			return 1 ;
		}
		case pick_type_pearle_enter:
		{
			new dialog_string [ 186 ] ;
			format ( dialog_string, sizeof dialog_string, "{"#cBL"}Задачи:\n\n{"#cWH"}1. Собирать ракушки в гротах у острова.\n\nНаграда: {"#cGN"}%d"valute_title_"\n\n{"#cGRDialog"}* Вы готовы пройти квест?", quest_pearle_reward ) ;
			show_dialog ( playerid, d_maze_quest, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Жемчуг", dialog_string, "Выбрать", "Закрыть" ) ;
			
			set_player_use_listitem ( playerid, 26 ) ;
			return 1 ;
		}
		case pick_type_turtle_enter:
		{
			new dialog_string [ 200 ] ;
			format ( dialog_string, sizeof dialog_string, "{"#cBL"}Задачи:\n\n{"#cWH"}1. Взять лодку и плыть в океан.\n2. Поймать черепах.\n3. Доставить черепах на склад.\n\nНаграда: {"#cGN"}%d"valute_title_"\n\n{"#cGRDialog"}* Вы готовы пройти квест?", quest_turtle_reward ) ;
			show_dialog ( playerid, d_maze_quest, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Черепахи", dialog_string, "Выбрать", "Закрыть" ) ;
			
			set_player_use_listitem ( playerid, 25 ) ;
			return 1 ;
		}
		case pick_type_fruit_enter:
		{
			new dialog_string [ 186 ] ;
			format ( dialog_string, sizeof dialog_string, "{"#cBL"}Задачи:\n\n{"#cWH"}1. Собрать яблоки и апельсины в ящики.\n2. Доставить фрукты на склад.\n\nНаграда: {"#cGN"}%d"valute_title_"\n\n{"#cGRDialog"}* Вы готовы пройти квест?", quest_fruit_reward ) ;
			show_dialog ( playerid, d_maze_quest, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Сбор фруктов", dialog_string, "Выбрать", "Закрыть" ) ;
			
			set_player_use_listitem ( playerid, 18 ) ;
			return 1 ;
		}
		case pick_type_cow_food_enter:
		{
			new dialog_string [ 186 ] ;
			format ( dialog_string, sizeof dialog_string, "{"#cBL"}Задачи:\n\n{"#cWH"}1. Съездить за комбикормом для коров.\n2. Наркомить коров.\n\nНаграда: {"#cGN"}%d"valute_title_"\n\n{"#cGRDialog"}* Вы готовы пройти квест?", quest_cow_food_reward ) ;
			show_dialog ( playerid, d_maze_quest, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Мясокомбинат", dialog_string, "Выбрать", "Закрыть" ) ;
			
			set_player_use_listitem ( playerid, 17 ) ;
			return 1 ;
		}
		case pick_type_meat_enter:
		{
			new dialog_string [ 256 ] ;
			format ( dialog_string, sizeof dialog_string, "{"#cBL"}Задачи:\n\n{"#cWH"}1. Загрузить коровы в грузовик.\n2. Доставить коров на мясокомбинат.\n3. Убить коров.\n4. Упаковать туши в коробки.\n5. Доставить коробки на склад.\n\nНаграда: {"#cGN"}%d"valute_title_"\n\n{"#cGRDialog"}* Вы готовы пройти квест?", quest_meat_reward ) ;
			show_dialog ( playerid, d_maze_quest, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Мясокомбинат", dialog_string, "Выбрать", "Закрыть" ) ;
			
			set_player_use_listitem ( playerid, 16 ) ;
			return 1 ;
		}
		case pick_type_milking_enter:
		{
			new dialog_string [ 186 ] ;
			format ( dialog_string, sizeof dialog_string, "{"#cBL"}Задачи:\n\n{"#cWH"}1. Подоить коров.\n2. Отвезти молоко на склад.\n\nНаграда: {"#cGN"}%d"valute_title_"\n\n{"#cGRDialog"}* Вы готовы пройти квест?", quest_milking_reward ) ;
			show_dialog ( playerid, d_maze_quest, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Дойка коров", dialog_string, "Выбрать", "Закрыть" ) ;
			
			set_player_use_listitem ( playerid, 12 ) ;
			return 1 ;
		}
		case pick_type_eggs_enter:
		{
			new dialog_string [ 186 ] ;
			format ( dialog_string, sizeof dialog_string, "{"#cBL"}Задачи:\n\n{"#cWH"}1. Собрать яйца.\n2. Отвезти яйца на склад.\n\nНаграда: {"#cGN"}%d"valute_title_"\n\n{"#cGRDialog"}* Вы готовы пройти квест?", quest_eggs_reward ) ;
			show_dialog ( playerid, d_maze_quest, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Сбор яиц", dialog_string, "Выбрать", "Закрыть" ) ;
			
			set_player_use_listitem ( playerid, 11 ) ;
			return 1 ;
		}
		case pick_type_hay_enter:
		{
			new dialog_string [ 200 ] ;
			format ( dialog_string, sizeof dialog_string, "{"#cBL"}Задачи:\n\n{"#cWH"}1. Убрать сено с поля в ангар.\n2. Загрузить собранное сено в грузовик.\n3. Доставить сено на склад для переработки.\n\nНаграда: {"#cGN"}%d"valute_title_"\n\n{"#cGRDialog"}* Вы готовы пройти квест?", quest_hay_reward ) ;
			show_dialog ( playerid, d_maze_quest, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Сено", dialog_string, "Выбрать", "Закрыть" ) ;
			
			set_player_use_listitem ( playerid, 10 ) ;
			return 1 ;
		}
		case pick_type_graffity_enter:
		{
			new dialog_string [ 186 ] ;
			format ( dialog_string, sizeof dialog_string, "{"#cBL"}Задачи:\n\n{"#cWH"}1. Найти балончики с краской.\n2. Нарисовать граффити своей банды.\n\nНаграда: {"#cGN"}%d"valute_title_"\n\n{"#cGRDialog"}* Вы готовы пройти квест?", quest_graffity_reward ) ;
			show_dialog ( playerid, d_maze_quest, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Граффити", dialog_string, "Выбрать", "Закрыть" ) ;
			
			set_player_use_listitem ( playerid, 2 ) ;
			return 1 ;
		}
		case pick_type_maze_enter:
		{
			new dialog_string [ 186 ] ;
			format ( dialog_string, sizeof dialog_string, "{"#cBL"}Задачи:\n\n{"#cWH"}1. Найти динамиты в лабиринте.\n2. Совершить ограбление хранилища.\n\nНаграда: {"#cGN"}%d"valute_title_"\n\n{"#cGRDialog"}* Вы готовы пройти квест?", quest_maze_reward ) ;
			show_dialog ( playerid, d_maze_quest, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Ограбление", dialog_string, "Выбрать", "Закрыть" ) ;
			
			set_player_use_listitem ( playerid, 1 ) ;
			return 1 ;
		}
		case pick_type_maze:
		{
			for ( new i = 0 ; i < 3 ; i ++ )
			{
				if ( pickupid != player_quest_pickup [ playerid ] [ i ] ) continue ;
				
				player_quest_step { playerid } ++ ;
				if ( player_quest_step { playerid } >= 3 )
				{
					start_maze_quest ( playerid ) ;
					player_quest_step { playerid } = 0 ;
				}
				else
				{
					new t_string [ 76 + 4 ] ;
					format ( t_string, sizeof ( t_string ), "{"#cGInfo"}* {"#cWH"}Вы нашли динамит. осталось найти {"#cGN"}%d{"#cWH"}.", 3 - player_quest_step { playerid } ) ;
					SendClientMessage ( playerid, col_white, t_string ) ;
				}
				
				DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ i ] ) ;
				break ;
			}
			return 1 ;
		}
		case pick_type_quest_robbery:
		{
			for ( new i = 0 ; i < 3 ; i ++ )
			{
				if ( pickupid != player_quest_pickup [ playerid ] [ i ] ) continue ;
				
				if ( ! IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) )
				{
					SetPlayerAttachedObject ( playerid, 1, 1550, 1,   0.160001, -0.234000, -0.009998, 1.100002, 95.899940, -17.500007  ) ;
					
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы взяли сумку с деньгами. Отнесите и положите её в машину." ) ;
     				SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}У багажника нажмите 'Y' для того, чтобы положить сумку с деньгами." ) ;
					
					DestroyDynamicPickup ( player_quest_pickup [ playerid ] [ i ] ) ;
				}
				break ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock quest_OnPlayerKeyStateChange ( playerid, newkeys, oldkeys )
{
	#pragma unused oldkeys
	#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
	if(PRESSED(KEY_SECONDARY_ATTACK) || PRESSED(KEY_JUMP) || PRESSED(KEY_FIRE) || PRESSED(KEY_SPRINT) || PRESSED(KEY_CROUCH))
	{
		new _quest = player_quest [ playerid ] ;
		if ( _quest == 16 )
		{
			if ( ! IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
			
			ClearAnimations ( playerid ) ;
			ApplyAnimation ( playerid, "FAT", "IDLE_tired", 3.0, 1, 0, 0, 0, 3000, 1 ) ;
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете использовать это действие так как Вы выполняете задание." ) ;
			return 1 ;
		}
		else if ( _quest == 17 )
		{
			if ( ! IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уронили мешок. Вам необходимо взять новый!" ) ;

			RemovePlayerAttachedObject ( playerid, 0 ) ;
			p_t_info [ playerid ] [ p_animation ] = false ;
						
			DisablePlayerCheckpoint ( playerid ) ;
			
			is_quest_used { playerid } = 133 ;
			SetPlayerRaceCheckpoint ( playerid, 1, pick_bag_cow_food [ 0 ], pick_bag_cow_food [ 1 ], pick_bag_cow_food [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;

			ClearAnimations ( playerid ) ;
			ApplyAnimation ( playerid, "PED","IDLE_tired", 4.1, 0, 1, 1, 0, 1 ) ;
			return 1 ;
		}
		else if ( _quest == 18 )
		{
			if ( ! IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) ) return 1 ;
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уронили ящик. Вам необходимо взять новый!" ) ;

			RemovePlayerAttachedObject ( playerid, 0 ) ;
			p_t_info [ playerid ] [ p_animation ] = false ;
						
			DisablePlayerCheckpoint ( playerid ) ;
			
			is_quest_used { playerid } = 0 ;
			SetPlayerRaceCheckpoint ( playerid, 1, fruit_pickup_position [ 0 ], fruit_pickup_position [ 1 ], fruit_pickup_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;

			ClearAnimations ( playerid ) ;
			ApplyAnimation ( playerid, "PED","IDLE_tired", 4.1, 0, 1, 1, 0, 1 ) ;
			return 1 ;
		}
	}
	if ( newkeys & KEY_YES )
	{
		if ( player_quest [ playerid ] == 1 && IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) )
		{
			foreach ( new veh_id: streamed_vehicles[ playerid ])
			{
				if ( veh_info [ veh_id - 1 ] [ v_model ] != 536 ) continue ;
				new Float:boot_pos [ 3 ] ;
				GetCoordBootVehicle ( veh_id, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ) ;
				if ( IsPlayerInRangeOfPoint ( playerid, 2.0, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ) )
				{
					RemovePlayerAttachedObject ( playerid, 1 ) ;
					ClearAnimations ( playerid ) ;
					
					if ( veh_info [ veh_id - 1 ] [ v_cargo ] + 1 > 3 )
					{
						veh_info [ veh_id - 1 ] [ v_cargo ] = 3 ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Машина уже полностью загружена сумками с деньгами." ) ;
						return 1 ;
					}
					else veh_info [ veh_id - 1 ] [ v_cargo ] += 1 ;
					
					player_quest_progress { playerid } ++ ;

					new t_string [ 102 ] ;
					format ( t_string, sizeof ( t_string ), "{"#cGInfo"}* {"#cWH"}Вы положили сумку в машину. Сумок с деньгами в машине {"#cGN"}%d{"#cWH"}.",
					veh_info [ veh_id - 1 ] [ v_cargo ] ) ;
					SendClientMessage ( playerid, col_white, t_string ) ;
					
					if ( player_quest_progress { playerid } >= 3 )
					{
						SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отвезите награбленное на место, которое отмечено на карте." ) ;
						
						is_quest_used { playerid } = 6 ;
						SetPlayerRaceCheckpoint ( playerid, 1, end_maze_quest [ 0 ], end_maze_quest [ 1 ], end_maze_quest [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
						
						new veh_id_quest = p_t_info [ playerid ] [ pl_quest ] ;
		
						new engine, lights, alarm, doors, bonnet, boot, objective ;
						veh_info [ veh_id_quest - 1 ] [ v_locked ] = false ;
						GetVehicleParamsEx ( veh_id_quest, engine, lights, alarm, doors, bonnet, boot, objective ) ;
						SetVehicleParamsEx ( veh_id_quest, VEHICLE_PARAMS_ON, lights, alarm, false, bonnet, boot, objective ) ;
						
						suspect_player ( playerid, "Взлом хранилища", 3 ) ;
					}

					quest_attached ( veh_id ) ;
					return 1 ;
				}
			}
		}
	}
	return 0 ;
}

stock quest_attached ( vehicleid )
{
	for ( new i = 0 ; i < 3 ; i ++ )
	{
		if ( veh_info [ vehicleid - 1 ] [ v_cargo_object ] [ i ] != INVALID_OBJECT_ID ) continue ;

		veh_info [ vehicleid - 1 ] [ v_cargo_object ] [ i ] = CreateDynamicObject ( 1550, veh_info [ vehicleid - 1 ] [ v_now_pos ] [ 0 ], veh_info [ vehicleid - 1 ] [ v_now_pos ] [ 1 ], veh_info [ vehicleid - 1 ] [ v_now_pos ] [ 2 ], 0.0, 0.0, veh_info [ vehicleid - 1 ] [ v_now_pos ] [ 3 ] ) ;
		AttachDynamicObjectToVehicle( veh_info [ vehicleid - 1 ] [ v_cargo_object ] [ i ], vehicleid, vehicle_attached [ i ] [ 0 ], 
																									vehicle_attached [ i ] [ 1 ], 
																									vehicle_attached [ i ] [ 2 ],   
																									vehicle_attached [ i ] [ 3 ], 
																									vehicle_attached [ i ] [ 4 ], 
																									vehicle_attached [ i ] [ 5 ] ) ;
		break ;
	}
	return 1 ;
}

stock quest_OnPlayerEnterDynamicArea ( playerid, areaid )
{
	if ( GetPlayerState ( playerid ) == PLAYER_STATE_ONFOOT )
	{
		switch ( area_info [ areaid ] [ a_type ] )
		{
			case area_type_graffity_spray:
			{
				for ( new i = 0 ; i < 3 ; i ++ )
				{
					if ( areaid != player_quest_area [ playerid ] [ i ] ) continue ;
					
					player_quest_step { playerid } ++ ;
					if ( player_quest_step { playerid } >= 2 )
					{
						player_quest_step { playerid } = 0 ;
						start_graffity_quest ( playerid ) ;
					}
					else
					{
						new t_string [ 78 + 4 ] ;
						format ( t_string, sizeof ( t_string ), "{"#cGInfo"}* {"#cWH"}Вы нашли баллончик. осталось найти {"#cGN"}%d{"#cWH"}.", 2 - player_quest_step { playerid } ) ;
						SendClientMessage ( playerid, col_white, t_string ) ;
					}
					
					DestroyDynamicObject ( player_quest_object [ playerid ] [ i ] ) ;
					DestroyDynamicArea ( player_quest_area [ playerid ] [ i ] ) ;
					break ;
				}
				return 1 ;
			}
			case area_type_pearle:
			{
				if ( player_quest [ playerid ] != 26 ) return 1 ;
				
				new _area_id = area_info [ areaid ] [ a_item ] ;
				if ( player_quest_area_used [ playerid ] [ _area_id ] == true ) return SendClientMessage ( playerid, col_gray, "{"#cRInfo"}* {"#cGRInfo"}Вы уже собрали эту жемчужину." ) ;
				
				player_quest_area_used [ playerid ] [ _area_id ] = true ;
				
				player_quest_progress { playerid } ++ ;
				
				if ( player_quest_progress { playerid } >= 10 )
				{
					is_quest_used { playerid } = 0 ;
					DisablePlayerRaceCheckpoint ( playerid ) ;
					
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отправляйтесь на остров за наградой." ) ;
					
					is_quest_used { playerid } = 250 ; 
					new _quest_id = player_quest [ playerid ] ;
					SetPlayerRaceCheckpoint ( playerid, 1, quest_position [ _quest_id ] [ 0 ], quest_position [ _quest_id ] [ 1 ], quest_position [ _quest_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
					return 1 ;
				}

				new scm_string [ 85 + 4 ] ;
				format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы собрали жемчужину. Осталось собрать {"#cGInfo"}%d{"#cWH"}.", 10 - player_quest_progress { playerid } ) ;
				SendClientMessage ( playerid, col_white, scm_string ) ;
				return 1 ;
			}
			case area_type_turtle:
			{
				if ( player_quest [ playerid ] != 25 ) return 1 ;
				if ( p_t_info [ playerid ] [ pl_quest ] == INVALID_VEHICLE_ID )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет лодки с клеткой для черепах!" ) ;
					return 1 ;
				}
				
				DestroyDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ;
				DestroyDynamicObject ( player_quest_object [ playerid ] [ 0 ] ) ;
				
				SetPlayerAttachedObject ( playerid, 0,  1609, 1, -0.202001, 0.778001, 0.088999, -90.699958, -175.099990, 88.899909, 0.607000, 0.439998, 0.558000  ) ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Доставьте черепаху в клетку." ) ;
				
				new _veh_id = p_t_info [ playerid ] [ pl_quest ] ;
				player_quest_area [ playerid ] [ 0 ] = CreateDynamicSphere ( veh_info [ _veh_id - 1 ] [ v_now_pos ] [ 0 ], veh_info [ _veh_id - 1 ] [ v_now_pos ] [ 1 ], veh_info [ _veh_id - 1 ] [ v_now_pos ] [ 2 ] - 4.0, 5.0, -1, -1, playerid ) ;
				area_info [ player_quest_area [ playerid ] [ 0 ] ] [ a_type ] = area_type_unturtle ;
				return 1 ;
			}
			case area_type_unturtle:
			{
				if ( player_quest [ playerid ] != 25 ) return 1 ;
				
				DestroyDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ;
				RemovePlayerAttachedObject ( playerid, 0 ) ;
				
				new _veh_id = p_t_info [ playerid ] [ pl_quest ], _id = player_quest_step { playerid } ;
				for ( new i = 0 ; i < sizeof reefer_turtle_attached ; i ++ )
				{
					if ( IsValidDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ) continue ;
					
					player_quest_vehicle_attached [ playerid ] [ i ] = CreateDynamicObject ( 1609, veh_info [ _veh_id - 1 ] [ v_now_pos ] [ 0 ], veh_info [ _veh_id - 1 ] [ v_now_pos ] [ 1 ], veh_info [ _veh_id - 1 ] [ v_now_pos ] [ 2 ], 0.0, 0.0, 0.0 ) ;

					AttachDynamicObjectToVehicle( player_quest_vehicle_attached [ playerid ] [ i ], _veh_id, reefer_turtle_attached [ _id ] [ 0 ],
																											reefer_turtle_attached [ _id ] [ 1 ],
																											reefer_turtle_attached [ _id ] [ 2 ],
																											reefer_turtle_attached [ _id ] [ 3 ],
																											reefer_turtle_attached [ _id ] [ 4 ],
																											reefer_turtle_attached [ _id ] [ 5 ] ) ;
					break ;
				}
				
				player_quest_step { playerid } ++ ;
				if ( player_quest_step { playerid } >= 3 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отправляйтесь на остров за наградой." ) ;
					
					new _id_spawn = player_quest_vehicle_spawn { playerid } - 1 ;
					is_quest_used { playerid } = 152 ;
					SetPlayerRaceCheckpoint ( playerid, 1, reefer_position [ _id_spawn ] [ 0 ], reefer_position [ _id_spawn ] [ 1 ], reefer_position [ _id_spawn ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
					return 1 ;
				}
				
				_id = random ( sizeof turtles_position ) ;
				is_quest_used { playerid } = 151 ;
				SetPlayerRaceCheckpoint ( playerid, 1, turtles_position [ _id ] [ 0 ], turtles_position [ _id ] [ 1 ], turtles_position [ _id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
				player_quest_object [ playerid ] [ 0 ] = CreateDynamicObject ( 1609, turtles_position [ _id ] [ 0 ], turtles_position [ _id ] [ 1 ], turtles_position [ _id ] [ 2 ],
																						turtles_position [ _id ] [ 3 ], turtles_position [ _id ] [ 4 ], turtles_position [ _id ] [ 5 ] ) ;
				
				player_quest_area [ playerid ] [ 0 ] = CreateDynamicSphere ( turtles_position [ _id ] [ 0 ], turtles_position [ _id ] [ 1 ], turtles_position [ _id ] [ 2 ], 5.0, -1, -1, playerid ) ;
				area_info [ player_quest_area [ playerid ] [ 0 ] ] [ a_type ] = area_type_turtle ;
				
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Отправляйтесь на следующее место, где последний раз видели черепах." ) ;
				return 1 ;
			}
			case area_type_apple_in_tree:
			{
				if ( player_quest [ playerid ] != 18 ) return 1 ;
				if ( player_quest_id { playerid } > 0 ) return 1 ;
				
				for ( new i = 0 ; i < sizeof start_apple_position_in_tree ; i ++ )
				{
					if ( areaid != apple_in_tree_area [ i ] ) continue ;
					
					ApplyAnimation ( playerid, "ON_LOOKERS", "Pointup_loop", 4.1, 0, 1, 1, 1, 1 ) ;
					RemovePlayerAttachedObject ( playerid, 0 ) ;
					
					DestroyDynamicArea ( apple_in_tree_area [ i ] ) ;
					SetTimerEx ( "callback_collect_fruit", 4000, false, "ii", playerid, i ) ;
					break ;
				}
				return 1 ;
			}
		}
	}
	if ( GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER )
	{
		switch ( area_info [ areaid ] [ a_type ] )
		{
			case area_type_hay:
			{
				if ( GetPlayerVehicleID ( playerid ) == 0 ) return 1 ;
				if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
				
				DestroyDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ;
				
				new vehicleid = GetPlayerVehicleID ( playerid ) ;
				AttachDynamicObjectToVehicle( veh_info [ vehicleid - 1 ] [ v_cargo_object ] [ 0 ], p_t_info [ playerid ] [ pl_quest ], vehicle_attached_tractor [ 0 ], 
																																	vehicle_attached_tractor [ 1 ], 
																																	vehicle_attached_tractor [ 2 ],   
																																	vehicle_attached_tractor [ 3 ], 
																																	vehicle_attached_tractor [ 4 ], 
																																	vehicle_attached_tractor [ 5 ] ) ;
				
				is_quest_used { playerid } = 101 ;
				SetPlayerRaceCheckpoint ( playerid, 1, hay_unload_position [ 0 ], hay_unload_position [ 1 ], hay_unload_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
				return 1 ;
			}
			case area_type_hay_loader:
			{
				if ( GetPlayerVehicleID ( playerid ) == 0 ) return 1 ;
				if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
				
				new vehicleid = GetPlayerVehicleID ( playerid ) ;
				AttachDynamicObjectToVehicle( veh_info [ vehicleid - 1 ] [ v_cargo_object ] [ 0 ], vehicleid, vehicle_attached_loader [ 0 ], 
																												vehicle_attached_loader [ 1 ], 
																												vehicle_attached_loader [ 2 ],   
																												vehicle_attached_loader [ 3 ], 
																												vehicle_attached_loader [ 4 ], 
																												vehicle_attached_loader [ 5 ] ) ;
				
				new Float:boot_pos [ 3 ] ;
				GetCoordBootVehicle ( player_quest_vehicle [ playerid ], boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ) ;
				
				DestroyDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ;
				player_quest_area [ playerid ] [ 0 ] = CreateDynamicSphere ( boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ], 5.0, -1, -1, playerid ) ;
				area_info [ player_quest_area [ playerid ] [ 0 ] ] [ a_type ] = area_type_hay_unloader ;
				
				is_quest_used { playerid } = 102 ;
				SetPlayerRaceCheckpoint ( playerid, 1, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
				return 1 ;
			}
			case area_type_hay_unloader:
			{
				if ( GetPlayerVehicleID ( playerid ) == 0 ) return 1 ;
				if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
				
				new vehicleid = GetPlayerVehicleID ( playerid ) ;
				DestroyDynamicObject ( veh_info [ vehicleid - 1 ] [ v_cargo_object ] [ 0 ] ) ;
				DestroyDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ;
				
				player_quest_step { playerid } ++ ;
				if ( player_quest_step { playerid } >= sizeof vehicle_attached_dft_hay )
				{
					DestroyVehicle ( p_t_info [ playerid ] [ pl_quest ], 1 ) ;
					p_t_info [ playerid ] [ pl_quest ] = INVALID_VEHICLE_ID ;
					
					DestroyVehicle ( player_quest_vehicle [ playerid ], 1 ) ;
					player_quest_vehicle [ playerid ] = INVALID_VEHICLE_ID ;
					
					for ( new i = 0 ; i < sizeof vehicle_attached_dft_fence + sizeof vehicle_attached_dft_hay ; i ++ )
					{
						DestroyDynamicObject ( player_quest_vehicle_attached [ playerid ] [ i ] ) ;
					}
					
					create_player_hay ( playerid, 3 ) ;
					return 1 ;
				}

				new _random = random ( sizeof hay_ambar_position ) ;
				is_quest_used { playerid } = 102 ;
				SetPlayerRaceCheckpoint ( playerid, 1, hay_ambar_position [ _random ] [ 0 ], hay_ambar_position [ _random ] [ 1 ], hay_ambar_position [ _random ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
				
				new _pos_attach = player_quest_step { playerid } - 1 ;
				player_quest_vehicle_attached [ playerid ] [ _pos_attach + 2 ] = CreateDynamicObject ( 1454, dft_position [ 0 ], dft_position [ 1 ], dft_position [ 2 ], 0.0, 0.0, dft_position [ 3 ] ) ;
				AttachDynamicObjectToVehicle( player_quest_vehicle_attached [ playerid ] [ _pos_attach + 2 ], player_quest_vehicle [ playerid ], vehicle_attached_dft_hay [ _pos_attach ] [ 0 ],
																																				vehicle_attached_dft_hay [ _pos_attach ] [ 1 ],
																																				vehicle_attached_dft_hay [ _pos_attach ] [ 2 ],
																																				vehicle_attached_dft_hay [ _pos_attach ] [ 3 ],
																																				vehicle_attached_dft_hay [ _pos_attach ] [ 4 ],
																																				vehicle_attached_dft_hay [ _pos_attach ] [ 5 ] ) ;
				
				veh_info [ vehicleid - 1 ] [ v_cargo_object ] [ 0 ] = CreateDynamicObject ( 1454, hay_ambar_position [ _random ] [ 0 ], 
																								hay_ambar_position [ _random ] [ 1 ], 
																								hay_ambar_position [ _random ] [ 2 ], 
																								hay_ambar_position [ _random ] [ 3 ], 
																								hay_ambar_position [ _random ] [ 4 ], 
																								hay_ambar_position [ _random ] [ 5 ] ) ;
				
				player_quest_area [ playerid ] [ 0 ] = CreateDynamicSphere ( hay_ambar_position [ _random ] [ 0 ], hay_ambar_position [ _random ] [ 1 ], hay_ambar_position [ _random ] [ 2 ], 5.0, -1, -1, playerid ) ;
				area_info [ player_quest_area [ playerid ] [ 0 ] ] [ a_type ] = area_type_hay_loader ;
				return 1 ;
			}
			case area_type_meat_loader:
			{
				if ( GetPlayerVehicleID ( playerid ) == 0 ) return 1 ;
				if ( player_vehicle [ playerid ] != p_t_info [ playerid ] [ pl_quest ] ) return 1 ;
				
				DestroyDynamicArea ( player_quest_area [ playerid ] [ 0 ] ) ;
				
				new vehicleid = GetPlayerVehicleID ( playerid ) ;
				new i = player_quest_progress { playerid } ;
				AttachDynamicObjectToVehicle( veh_info [ vehicleid - 1 ] [ v_cargo_object ] [ i ], vehicleid, dft_meat_cow_attached [ i ] [ 0 ], 
																												dft_meat_cow_attached [ i ] [ 1 ], 
																												dft_meat_cow_attached [ i ] [ 2 ],   
																												dft_meat_cow_attached [ i ] [ 3 ], 
																												dft_meat_cow_attached [ i ] [ 4 ], 
																												dft_meat_cow_attached [ i ] [ 5 ] ) ;
																												
				player_quest_progress { playerid } ++ ;
				if ( player_quest_progress { playerid } >= 3 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Теперь отправляйтесь на мясокомбинат." ) ;
					player_quest_progress { playerid } = 0 ;
					
					is_quest_used { playerid } = 127 ;
					SetPlayerRaceCheckpoint ( playerid, 1, meat_factory_position [ 0 ], meat_factory_position [ 1 ], meat_factory_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
				}
				else
				{
					new _random = random ( sizeof cow_field_position ) ;
		
					new _n_prog = player_quest_progress { playerid } ;
					veh_info [ p_t_info [ playerid ] [ pl_quest ] - 1 ] [ v_cargo_object ] [ _n_prog ] = CreateDynamicObject ( 19833, cow_field_position [ _random ] [ 0 ], cow_field_position [ _random ] [ 1 ], cow_field_position [ _random ] [ 2 ],
																																cow_field_position [ _random ] [ 3 ], cow_field_position [ _random ] [ 4 ], cow_field_position [ _random ] [ 5 ] ) ;
					
					is_quest_used { playerid } = 0 ;
					SetPlayerRaceCheckpoint ( playerid, 1, cow_field_position [ _random ] [ 0 ], cow_field_position [ _random ] [ 1 ], cow_field_position [ _random ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
				
					player_quest_area [ playerid ] [ 0 ] = CreateDynamicSphere ( cow_field_position [ _random ] [ 0 ], cow_field_position [ _random ] [ 1 ], cow_field_position [ _random ] [ 2 ], 5.0, -1, -1, playerid ) ;
					area_info [ player_quest_area [ playerid ] [ 0 ] ] [ a_type ] = area_type_meat_loader ;
				}
				return 1 ;
			}
			case area_type_apple_in_tree_vehicle:
			{
				player_quest_warning { playerid } ++ ;
				if ( player_quest_warning { playerid } >= 2 )
				{
					if ( player_quest [ playerid ] != 0 )
					{
						SendClientMessage ( playerid, col_red, !"Вы нарушили правила и были дисквалифицированы с задания." ) ;
						callcmd::exitquest ( playerid ) ;
					}
					else
					{
						SendClientMessage ( playerid, col_red, !"Вы нарушили правила и у Вас была отнята половина хп." ) ;
						SendClientMessage ( playerid, col_red, !"Ваше транспортное средство было заспавнено." ) ;
						SetVehicleToRespawn ( GetPlayerVehicleID ( playerid ), 22 ) ;
						set_health ( playerid, p_t_info [ playerid ] [ p_health ] / 2 ) ;
					}
					player_quest_warning { playerid } = 0 ;
					return 1 ;
				}
				SendClientMessage ( playerid, col_red, !"Аккуратнее! При повторном наезде на фруктовое дерево из сада Вам будет худо." ) ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

stock quest_player_timer ( playerid )
{
	if ( player_quest_time [ playerid ] > 0 ) 
	{
		player_quest_time [ playerid ] -- ;
		
		new td_string [ 16 ] ;
		format ( td_string, sizeof td_string, "%s", convert_time ( player_quest_time [ playerid ], TYPE_TIME_SECOND ) ) ;
		PlayerTextDrawSetString ( playerid, quest_PTD [ playerid ] [ 3 ], td_string ) ;
		if ( player_quest_time [ playerid ] == 1 )
		{
			quest_OnPlayerDisconnect ( playerid ) ;
			SendClientMessage ( playerid, col_red, !"Вы не успели выполнить квест! Можете пройти его в любое время." ) ;
		}
	}
	return 1 ;
}

stock show_quest_ptd ( playerid, bool: status )
{
	if ( status )
	{
		quest_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 279.6665, 13.3149, "particle:lamp_shad_64"); // пусто
		PlayerTextDrawTextSize(playerid, quest_PTD[playerid][0], 80.0000, 20.0000);
		PlayerTextDrawAlignment(playerid, quest_PTD[playerid][0], 1);
		PlayerTextDrawColor(playerid, quest_PTD[playerid][0], color_particle);
		PlayerTextDrawBackgroundColor(playerid, quest_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, quest_PTD[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, quest_PTD[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, quest_PTD[playerid][0], 0);

		quest_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 279.6665, 35.5334, "particle:lamp_shad_64"); // пусто
		PlayerTextDrawTextSize(playerid, quest_PTD[playerid][1], 78.0000, -20.0000);
		PlayerTextDrawAlignment(playerid, quest_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, quest_PTD[playerid][1], color_particle);
		PlayerTextDrawBackgroundColor(playerid, quest_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, quest_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, quest_PTD[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, quest_PTD[playerid][1], 0);

		quest_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 302.6665, 34.4444, "QUEST_TIME"); // пусто
		PlayerTextDrawLetterSize(playerid, quest_PTD[playerid][2], 0.1843, 1.0102);
		PlayerTextDrawAlignment(playerid, quest_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, quest_PTD[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, quest_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, quest_PTD[playerid][2], 1);
		PlayerTextDrawSetProportional(playerid, quest_PTD[playerid][2], 1);
		PlayerTextDrawSetShadow(playerid, quest_PTD[playerid][2], 0);

		quest_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 318.9999, 17.8518, "00:00"); // пусто
		PlayerTextDrawLetterSize(playerid, quest_PTD[playerid][3], 0.1844, 1.3379);
		PlayerTextDrawAlignment(playerid, quest_PTD[playerid][3], 2);
		PlayerTextDrawColor(playerid, quest_PTD[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, quest_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, quest_PTD[playerid][3], 2);
		PlayerTextDrawSetProportional(playerid, quest_PTD[playerid][3], 1);
		PlayerTextDrawSetShadow(playerid, quest_PTD[playerid][3], 0);

		quest_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 351.6665, 17.8518, "X"); // пусто
		PlayerTextDrawLetterSize(playerid, quest_PTD[playerid][4], 0.1849, 0.7038);
		PlayerTextDrawAlignment(playerid, quest_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, quest_PTD[playerid][4], color_textdraw);
		PlayerTextDrawBackgroundColor(playerid, quest_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, quest_PTD[playerid][4], 1);
		PlayerTextDrawSetProportional(playerid, quest_PTD[playerid][4], 1);
		PlayerTextDrawSetShadow(playerid, quest_PTD[playerid][4], 0);

		quest_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 355.0000, 25.3185, "X"); // пусто
		PlayerTextDrawLetterSize(playerid, quest_PTD[playerid][5], 0.1089, 0.6126);
		PlayerTextDrawAlignment(playerid, quest_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, quest_PTD[playerid][5], color_textdraw);
		PlayerTextDrawBackgroundColor(playerid, quest_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, quest_PTD[playerid][5], 2);
		PlayerTextDrawSetProportional(playerid, quest_PTD[playerid][5], 1);
		PlayerTextDrawSetShadow(playerid, quest_PTD[playerid][5], 0);

		quest_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 358.0000, 19.5109, ">"); // пусто
		PlayerTextDrawLetterSize(playerid, quest_PTD[playerid][6], 0.0793, 0.6955);
		PlayerTextDrawAlignment(playerid, quest_PTD[playerid][6], 1);
		PlayerTextDrawColor(playerid, quest_PTD[playerid][6], color_textdraw);
		PlayerTextDrawBackgroundColor(playerid, quest_PTD[playerid][6], 255);
		PlayerTextDrawFont(playerid, quest_PTD[playerid][6], 2);
		PlayerTextDrawSetProportional(playerid, quest_PTD[playerid][6], 1);
		PlayerTextDrawSetShadow(playerid, quest_PTD[playerid][6], 0);
		
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			PlayerTextDrawShow ( playerid, quest_PTD [ playerid ] [ i ] ) ;
		}
	}
	else
	{
		for ( new i = 0 ; i < 7 ; i ++ )
		{
			PlayerTextDrawDestroy ( playerid, quest_PTD [ playerid ] [ i ] ) ;
			quest_PTD [ playerid ] [ i ] = PlayerText:-1 ;
		}
	}
	return 1 ;
}

stock quest_OnGameModeInit ( )
{
	new farm_label [ 256 ] ;
	// Ограбление
/*
	new maze_pickup = CreateDynamicPickup ( 1550, 23, quest_position [ 1 ] [ 0 ], quest_position [ 1 ] [ 1 ], quest_position [ 1 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ maze_pickup ] [ pick_type ] = pick_type_maze_enter ;
	
	maze_quest_active = false ;
	
	new text_label [ 100 ] ;
	format ( text_label, sizeof text_label, "** Ограбление **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", maze_player_quest, ( maze_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	maze_text = CreateDynamic3DTextLabel ( text_label, col_header_3d, quest_position [ 1 ] [ 0 ], quest_position [ 1 ] [ 1 ], quest_position [ 1 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );

	// Граффити

	new graffity_pickup = CreateDynamicPickup ( 365, 23, quest_position [ 2 ] [ 0 ], quest_position [ 2 ] [ 1 ], quest_position [ 2 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ graffity_pickup ] [ pick_type ] = pick_type_graffity_enter ;
	
	graffity_quest_active = false ;
	
	format ( text_label, sizeof text_label, "** Граффити **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", graffity_player_quest, ( graffity_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	graffity_text = CreateDynamic3DTextLabel ( text_label, col_header_3d, quest_position [ 2 ] [ 0 ], quest_position [ 2 ] [ 1 ], quest_position [ 2 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );
	
	// Сено

	new hay_pickup = CreateDynamicPickup ( 2901, 23, quest_position [ 10 ] [ 0 ], quest_position [ 10 ] [ 1 ], quest_position [ 10 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ hay_pickup ] [ pick_type ] = pick_type_hay_enter ;
	
	CreateActor ( 161, quest_actor_position [ 10 ] [ 0 ], quest_actor_position [ 10 ] [ 1 ], quest_actor_position [ 10 ] [ 2 ], quest_actor_position [ 10 ] [ 3 ] ) ;
	
	hay_quest_active = false ;
	
	format ( text_label, sizeof text_label, "** Сено **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", hay_player_quest, ( hay_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	hay_text = CreateDynamic3DTextLabel ( text_label, col_header_3d, quest_position [ 10 ] [ 0 ], quest_position [ 10 ] [ 1 ], quest_position [ 10 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );

	// Яйца

	new eggs_pickup = CreateDynamicPickup ( 19344, 23, quest_position [ 11 ] [ 0 ], quest_position [ 11 ] [ 1 ], quest_position [ 11 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ eggs_pickup ] [ pick_type ] = pick_type_eggs_enter ;
	
	CreateActor ( 159, quest_actor_position [ 11 ] [ 0 ], quest_actor_position [ 11 ] [ 1 ], quest_actor_position [ 11 ] [ 2 ], quest_actor_position [ 11 ] [ 3 ] ) ;
	
	eggs_quest_active = false ;
	
	format ( text_label, sizeof text_label, "** Сбор яиц **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", eggs_player_quest, ( eggs_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	eggs_text = CreateDynamic3DTextLabel ( text_label, col_header_3d, quest_position [ 11 ] [ 0 ], quest_position [ 11 ] [ 1 ], quest_position [ 11 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );

	// Дойка коров

	new milking_pickup = CreateDynamicPickup ( 2709, 23, quest_position [ 12 ] [ 0 ], quest_position [ 12 ] [ 1 ], quest_position [ 12 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ milking_pickup ] [ pick_type ] = pick_type_milking_enter ;
	
	new bucket_pickup = CreateDynamicPickup ( 19468, 23, bucket_pickup_position [ 0 ], bucket_pickup_position [ 1 ], bucket_pickup_position [ 2 ], 0, 0, -1 ) ;
	pick_info [ bucket_pickup ] [ pick_type ] = pick_type_quest_bucket ;
	
	CreateActor ( 199, quest_actor_position [ 12 ] [ 0 ], quest_actor_position [ 12 ] [ 1 ], quest_actor_position [ 12 ] [ 2 ], quest_actor_position [ 12 ] [ 3 ] ) ;
	
	milking_quest_active = false ;
	
	format ( text_label, sizeof text_label, "** Дойка коров **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", milking_player_quest, ( milking_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	milking_text = CreateDynamic3DTextLabel ( text_label, col_header_3d, quest_position [ 12 ] [ 0 ], quest_position [ 12 ] [ 1 ], quest_position [ 12 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );

	// Фермер
	
	new farmer_pickup = CreateDynamicPickup ( 19320, 23, quest_position [ 13 ] [ 0 ], quest_position [ 13 ] [ 1 ], quest_position [ 13 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ farmer_pickup ] [ pick_type ] = pick_type_farmer_enter ;
	
	CreateActor ( 34, quest_actor_position [ 13 ] [ 0 ], quest_actor_position [ 13 ] [ 1 ], quest_actor_position [ 13 ] [ 2 ], quest_actor_position [ 13 ] [ 3 ] ) ;
	
	farmer_quest_active [ 0 ] = false ;
	farmer_quest_active [ 1 ] = false ;
	farmer_quest_active [ 2 ] = false ;
	
	format ( farm_label, sizeof farm_label, "** Фермер **\n\n{"#cWH3D"}Игроков на квесте:\n\
																{"#cBL3D"}1. {"#cWH3D"}Вспахивание поля: {"#cGN3D"}%d\n\
																{"#cBL3D"}2. {"#cWH3D"}Распыление удобрения: {"#cGN3D"}%d\n\
																{"#cBL3D"}3. {"#cWH3D"}Сбор тыкв: {"#cGN3D"}%d", farmer_player_quest [ 0 ], farmer_player_quest [ 1 ], farmer_player_quest [ 2 ] ) ;
	farmer_text = CreateDynamic3DTextLabel ( farm_label, col_header_3d, quest_position [ 13 ] [ 0 ], quest_position [ 13 ] [ 1 ], quest_position [ 13 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );

	// Мясокомбинат

	new meat_pickup = CreateDynamicPickup ( 2806, 23, quest_position [ 16 ] [ 0 ], quest_position [ 16 ] [ 1 ], quest_position [ 16 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ meat_pickup ] [ pick_type ] = pick_type_meat_enter ;
	
	new pickupid_saw_factory = CreateDynamicPickup ( 1239, 23, pick_saw_factory [ 0 ], pick_saw_factory [ 1 ], pick_saw_factory [ 2 ], -1, -1, -1 ) ;
	pick_info [ pickupid_saw_factory ] [ pick_type ] = pick_type_factory_saw ;
	
	meat_quest_active = false ;
	
	format ( farm_label, 110, "** Мясокомбинат **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", meat_player_quest, ( meat_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	meat_text = CreateDynamic3DTextLabel ( farm_label, col_header_3d, quest_position [ 16 ] [ 0 ], quest_position [ 16 ] [ 1 ], quest_position [ 16 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );

	// Кормление коров

	new cow_food_pickup = CreateDynamicPickup ( 2060, 23, quest_position [ 17 ] [ 0 ], quest_position [ 17 ] [ 1 ], quest_position [ 17 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ cow_food_pickup ] [ pick_type ] = pick_type_cow_food_enter ;
	
	CreateActor ( 201, quest_actor_position [ 17 ] [ 0 ], quest_actor_position [ 17 ] [ 1 ], quest_actor_position [ 17 ] [ 2 ], quest_actor_position [ 17 ] [ 3 ] ) ;
	
	cow_food_quest_active = false ;
	
	format ( farm_label, 110, "** Кормление коров **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", cow_food_player_quest, ( cow_food_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	cow_food_text = CreateDynamic3DTextLabel ( farm_label, col_header_3d, quest_position [ 17 ] [ 0 ], quest_position [ 17 ] [ 1 ], quest_position [ 17 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );

	// Сбор фруктов
	
	for ( new i = 0 ; i < sizeof start_apple_position_in_tree ; i ++ )
	{
		new areaid = CreateDynamicSphere ( start_apple_position_in_tree [ i ] [ 0 ], start_apple_position_in_tree [ i ] [ 1 ], start_apple_position_in_tree [ i ] [ 2 ], 3.0, -1, -1, -1 ) ;
		area_info [ areaid ] [ a_type ] = area_type_apple_in_tree_vehicle ;
	}
	
	new fruit_pickup = CreateDynamicPickup ( 19576, 23, quest_position [ 18 ] [ 0 ], quest_position [ 18 ] [ 1 ], quest_position [ 18 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ fruit_pickup ] [ pick_type ] = pick_type_fruit_enter ;
	
	new fruit_pickupid = CreateDynamicPickup ( 19639, 23, fruit_pickup_position [ 0 ], fruit_pickup_position [ 1 ], fruit_pickup_position [ 2 ], -1, -1, -1 ) ;
	pick_info [ fruit_pickupid ] [ pick_type ] = pick_type_fruit ;
	
	fruit_quest_active = false ;
	
	format ( farm_label, 110, "** Сбор фруктов **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", fruit_player_quest, ( fruit_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	fruit_text = CreateDynamic3DTextLabel ( farm_label, col_header_3d, quest_position [ 18 ] [ 0 ], quest_position [ 18 ] [ 1 ], quest_position [ 18 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );
*/
	// Черепахи

	turtle_pickup = CreateDynamicPickup ( 1239, 23, quest_position [ 25 ] [ 0 ], quest_position [ 25 ] [ 1 ], quest_position [ 25 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ turtle_pickup ] [ pick_type ] = pick_type_turtle_enter ;
	
	CreateActor ( 35, quest_actor_position [ 25 ] [ 0 ], quest_actor_position [ 25 ] [ 1 ], quest_actor_position [ 25 ] [ 2 ], quest_actor_position [ 25 ] [ 3 ] ) ;
	
	turtle_quest_active = false ;
	
	format ( farm_label, 110, "** Черепахи **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", turtle_player_quest, ( turtle_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	turtle_text = CreateDynamic3DTextLabel ( farm_label, col_header_3d, quest_position [ 25 ] [ 0 ], quest_position [ 25 ] [ 1 ], quest_position [ 25 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );

	// Жемчуг

	pearle_pickup = CreateDynamicPickup ( 1239, 23, quest_position [ 26 ] [ 0 ], quest_position [ 26 ] [ 1 ], quest_position [ 26 ] [ 2 ], 0, 0, -1 ) ;
	pick_info [ pearle_pickup ] [ pick_type ] = pick_type_pearle_enter ;
	
	CreateActor ( 37, quest_actor_position [ 26 ] [ 0 ], quest_actor_position [ 26 ] [ 1 ], quest_actor_position [ 26 ] [ 2 ], quest_actor_position [ 26 ] [ 3 ] ) ;
	
	pearle_quest_active = false ;
	
	format ( farm_label, 110, "** Жемчуг **\n\n{"#cWH3D"}Игроков на квесте: {"#cGN3D"}%d\n{"#cWH3D"}Квест %s", pearle_player_quest, ( pearle_quest_active == false ) ? ( "{"#cGN3D"}доступен" ) : ( "{"#cRL3D"}занят" ) ) ;
	pearle_text = CreateDynamic3DTextLabel ( farm_label, col_header_3d, quest_position [ 26 ] [ 0 ], quest_position [ 26 ] [ 1 ], quest_position [ 26 ] [ 2 ] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1, -1 );

	for ( new i = 0 ; i < sizeof pearle_position ; i ++ )
	{
		CreateDynamicObject ( 953, pearle_position [ i ] [ 0 ], pearle_position [ i ] [ 1 ], pearle_position [ i ] [ 2 ], pearle_position [ i ] [ 3 ], pearle_position [ i ] [ 4 ], pearle_position [ i ] [ 5 ] ) ;
	
		pearle_area [ i ] = CreateDynamicSphere ( pearle_position [ i ] [ 0 ], pearle_position [ i ] [ 1 ], pearle_position [ i ] [ 2 ], 3.0, -1, -1, -1 ) ;
		area_info [ pearle_area [ i ] ] [ a_type ] = area_type_pearle ;
		area_info [ pearle_area [ i ] ] [ a_item ] = i ;
	}

	/*// Коровник
	CreateDynamicObjectEx ( 16918, 1403.8489, -1017.8966, 24.2000, 3.0000, 0.0000, 95.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	
	CreateDynamicObjectEx ( 19833, 1394.6990, -1003.3834, 20.0553, 0.0000, 0.0000, 100.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 1394.6990, -1006.6834, 20.0553, 0.0000, 0.0000, 100.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 1394.6990, -1009.9834, 20.0553, 0.0000, 0.0000, 100.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 1394.6990, -1013.2834, 20.0553, 0.0000, 0.0000, 100.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 1394.6990, -1016.5834, 20.0553, 0.0000, 0.0000, 100.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 1394.6990, -1019.8834, 20.0553, 0.0000, 0.0000, 100.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 1394.6990, -1023.1834, 20.0553, 0.0000, 0.0000, 100.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 1394.6990, -1026.4834, 20.0553, 0.0000, 0.0000, 100.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 1394.6990, -1029.7834, 20.0553, 0.0000, 0.0000, 100.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 1394.6990, -1033.0834, 20.0553, 0.0000, 0.0000, 100.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	
	// Фрукты
	CreateDynamicObjectEx ( 792, 2226.1406, 1767.7884, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2219.6970, 1756.8435, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2221.4550, 1732.1003, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2227.3649, 1702.3457, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2207.9616, 1713.7480, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2219.0263, 1722.1744, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2209.0000, 1735.8690, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2202.6291, 1742.3999, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2207.9880, 1760.4266, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2218.8107, 1715.7559, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2211.5839, 1698.3917, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2224.8427, 1741.4008, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2230.1911, 1724.4410, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2205.0053, 1727.4721, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2215.0922, 1770.4234, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2196.1669, 1730.0759, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2201.9096, 1706.4627, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2199.3359, 1689.7687, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2196.1687, 1717.9476, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2194.1901, 1745.8809, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 792, 2213.2270, 1732.7766, 30.4287, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	
	// Дойка
	CreateDynamicObjectEx ( 19833, 2174.5112, 1696.2005, 30.4333, 0.0000, 0.0000, -125.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 2154.8059, 1696.0522, 30.4333, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 2183.2770, 1705.5687, 30.4333, 0.0000, 0.0000, -132.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 2157.2233, 1712.0758, 30.4333, 0.0000, 0.0000, 130.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 2179.5012, 1721.6270, 30.4333, 0.0000, 0.0000, 148.5000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 2156.8764, 1724.8801, 30.4333, 0.0000, 0.0000, 60.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 2165.3940, 1713.5504, 30.4333, 0.0000, 0.0000, 40.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 2173.7541, 1744.4333, 30.4333, 0.0000, 0.0000, -60.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 19833, 2153.2377, 1752.1986, 30.4333, 0.0000, 0.0000, 150.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	
	// Курятник
	CreateDynamicObjectEx ( 1451, 1294.2437, -1064.1370, 21.0000, 0.0000, 0.0000, -180.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 1451, 1290.2437, -1064.1370, 21.0000, 0.0000, 0.0000, -180.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 1451, 1286.2437, -1064.1370, 21.0000, 0.0000, 0.0000, -180.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 1451, 1282.2437, -1064.1370, 21.0000, 0.0000, 0.0000, -180.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 1451, 1278.2437, -1064.1370, 21.0000, 0.0000, 0.0000, -180.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 1451, 1294.2437, -1057.8374, 21.0000, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 1451, 1290.2437, -1057.8374, 21.0000, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 1451, 1286.2437, -1057.8374, 21.0000, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 1451, 1282.2437, -1057.8374, 21.0000, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;
	CreateDynamicObjectEx ( 1451, 1278.2437, -1057.8374, 21.0000, 0.0000, 0.0000, 0.0000, 300.000, 300.000, { 0 }, { 0 } ) ;*/
	return 1 ;
}