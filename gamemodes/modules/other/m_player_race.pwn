new src_player_count [ MAX_PLAYERS ],
	src_player_type [ MAX_PLAYERS ],
	src_player_name [ MAX_PLAYERS ] [ MAX_PLAYER_NAME ],
	src_player_start [ MAX_PLAYERS ],
	src_player_started [ MAX_PLAYERS ],
	src_player_timer [ MAX_PLAYERS ],
	player_race_owner [ MAX_PLAYERS ],
	src_player_money [ MAX_PLAYERS ],
	src_player_place [ MAX_PLAYERS ] ;

new Iterator:player_race[MAX_PLAYERS]<MAX_PLAYERS-1>;

Float:race_GetDistanceBetweenPoints ( Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2 )
{
    return VectorSize ( x1 - x2, y1 - y2, z1 - z2 ) ;
}

stock player_race_clear_player_data ( playerid )
{
	format ( src_player_name [ playerid ], MAX_PLAYER_NAME, "Не выбран" ) ;
	player_race_owner [ playerid ] = -1 ;
	
	src_player_count [ playerid ] =
	src_player_type [ playerid ] =
	src_player_start [ playerid ] =
	src_player_started [ playerid ] =
	src_player_timer [ playerid ] =
	src_player_money [ playerid ] =
	src_player_place [ playerid ] = 0 ;
	return 1 ;
}

stock player_race_exitrace ( playerid )
{
	if ( player_race_owner [ playerid ] != -1 )
	{
	    DisablePlayerRaceCheckpoint ( playerid ) ;
		player_race_cp [ playerid ] =
		player_race_first_cp [ playerid ] = 0 ;
		player_race_vehicle [ playerid ] = INVALID_VEHICLE_ID ;
		is_player_race_regged [ playerid ] = false ;
		Iter_Remove(player_race[player_race_owner [ playerid ]], playerid);
		player_race_owner [ playerid ] = -1 ;
	    SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно покинули гонки." ) ;
	    return 1 ;
	}
	return 1 ;
}

stock player_race_OnGameModeInit ( )
{
	Iter_Init(player_race) ;
	return 1 ;
}

CMD:my_race ( playerid )
{
	if ( ! p_info [ playerid ] [ donate_race ] ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет данной привелегии." ) ;
    show_menu_race ( playerid ) ;
    return 1 ;
}

stock show_menu_race ( playerid )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, sizeof ( global_string ), "\
		{"#cBL"}1. {"#cWH"}Информация о текущей гонке\n\
		{"#cBL"}2. {"#cWH"}Пригласить игрока\n\
		{"#cBL"}3. {"#cWH"}Дисквалифицировать игрока\n\
		{"#cBL"}4. {"#cWH"}Начать гонку\n\
		{"#cBL"}5. {"#cWH"}Создать гонку\n\
		{"#cBL"}6. {"#cWH"}Тип гонки: %s\n\
		{"#cBL"}7. {"#cWH"}Ставка ({"#cGN"}%d${"#cWH"})\n\
		{"#cBL"}8. {"#cWH"}Выбрать маршрут ({"#cGN"}%s{"#cWH"})\n\
		{"#cBL"}9. {"#cWH"}Настройки своего маршрута\n\
		{"#cBL"}10. {"#cWH"}Позиция старта гонки\n\
		{"#cGRDialog"}Отменить гонку",
	( src_player_type [ playerid ] ) ? ( "{"#cGN"}Спринт" ) : ( "{"#cGN"}Дрифт" ), src_player_money [ playerid ], ( ! src_player_count [ playerid ] ) ? ( "{"#cRD"}Не выбран" ) : ( src_player_name [ playerid ] ) ) ;
	show_dialog ( playerid, d_menu_race, DIALOG_STYLE_LIST, "{"#cBHD"}Настройки гонки", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock show_menu_player_race ( playerid )
{
	global_string [ 0 ] = EOS ;
	
	new Float:_distance ;
	if ( src_player_count [ playerid ] )
	{
		_distance = race_GetDistanceBetweenPoints ( src_player_info [ playerid ] [ 0 ] [ race_position ] [ 0 ], src_player_info [ playerid ] [ 0 ] [ race_position ] [ 1 ], src_player_info [ playerid ] [ 0 ] [ race_position ] [ 2 ], src_player_info [ playerid ] [ src_player_count [ playerid ] - 1 ] [ race_position ] [ 0 ], src_player_info [ playerid ] [ src_player_count [ playerid ] - 1 ] [ race_position ] [ 1 ], src_player_info [ playerid ] [ src_player_count [ playerid ] - 1 ] [ race_position ] [ 2 ] ) ;
	}
	else _distance = 0.0 ;
	
	format ( global_string, sizeof ( global_string ), "\
		{"#cBL"}1. {"#cWH"}Добавить крайнюю точку\n\
		{"#cBL"}2. {"#cWH"}Подсказки\n\
		{"#cBL"}3. {"#cWH"}Проехать ({"#cGN"}%.1f{"#cWH"} м)\n\
		{"#cBL"}4. {"#cWH"}Точек в маршруте: {"#cGN"}%d/%d\n\
		{"#cBL"}5. {"#cWH"}Удалить крайнюю точку\n\
		{"#cBL"}6. {"#cWH"}Удалить маршрут",
	_distance, src_player_count [ playerid ], SRC_TRECK_COUNT ) ;
	show_dialog ( playerid, d_player_race, DIALOG_STYLE_LIST, "{"#cBHD"}Настройки маршрута", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

stock player_race_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_player_race:
	    {
	        if ( ! response ) return show_menu_race ( playerid ) ;
	        switch ( listitem )
	        {
	            case 0:
	            {
					if ( src_player_count [ playerid ] + 1 > SRC_TRECK_COUNT )
					{
						show_menu_player_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Создано максимальное количество точек." ) ;
						return 1 ;
					}
					if ( src_player_start [ playerid ] == 2 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка уже началась." ) ;
						return 1 ;
					}
					if ( GetPlayerVirtualWorld ( playerid ) > 0 || GetPlayerInterior ( playerid ) > 0 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Создавать гонку можно только на улице." ) ;
						return 1 ;
					}
					if ( player_vehicle [ playerid ] == INVALID_VEHICLE_ID )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не в транспорте." ) ;
						return 1 ;
					}
					
					new _src_count = src_player_count [ playerid ] ;
				    new Float:X, Float:Y, Float:Z, Float:A ;

					GetVehiclePos ( GetPlayerVehicleID ( playerid ), X, Y, Z ) ;
					GetVehicleZAngle ( GetPlayerVehicleID ( playerid ), A ) ;

					src_player_info [ playerid ] [ _src_count ] [ race_position ] [ 0 ] = X ;
					src_player_info [ playerid ] [ _src_count ] [ race_position ] [ 1 ] = Y ;
					src_player_info [ playerid ] [ _src_count ] [ race_position ] [ 2 ] = Z ;
					src_player_info [ playerid ] [ _src_count ] [ race_position ] [ 3 ] = A ;

					new query_string [ 256 ] ;
				    format ( query_string, sizeof query_string, "INSERT INTO `src_player_checkpoint` (`u_id`,`r_pos_x`,`r_pos_y`,`r_pos_z`,`r_pos_a`) VALUES ('%d','%f','%f','%f','%f')",
					p_info [ playerid ] [ id ], src_player_info [ playerid ] [ _src_count ] [ race_position ] [ 0 ], src_player_info [ playerid ] [ _src_count ] [ race_position ] [ 1 ], src_player_info [ playerid ] [ _src_count ] [ race_position ] [ 2 ], src_player_info [ playerid ] [ _src_count ] [ race_position ] [ 3 ] ) ;
					mysql_tquery ( sql_connection, query_string ) ;

					src_player_count [ playerid ] ++ ;
					show_menu_player_race ( playerid ) ;
	            }
	            case 1: show_menu_player_race ( playerid ) ;
	            case 2:
	            {
	                if ( ! src_player_count [ playerid ] )
					{
						show_menu_player_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваша гонка не создана." ) ;
						return 1 ;
					}
	                if ( src_player_start [ playerid ] == 2 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка уже началась." ) ;
						return 1 ;
					}
					
					is_player_race_regged [ playerid ] = true ;
	                player_race_cp [ playerid ] = 0 ;
					player_race_owner [ playerid ] = playerid ;
					new r = player_race_cp [ playerid ] ;
					SetPlayerRaceCheckpoint ( playerid, 0, src_player_info [ playerid ] [ r ] [ race_position ] [ 0 ], src_player_info [ playerid ] [ r ] [ race_position ] [ 1 ], src_player_info [ playerid ] [ r ] [ race_position ] [ 2 ], src_player_info [ playerid ] [ r + 1 ] [ race_position ] [ 0 ], src_player_info [ playerid ] [ r + 1 ] [ race_position ] [ 1 ], src_player_info [ playerid ] [ r + 1 ] [ race_position ] [ 2 ], 10.0);
	            }
				case 3: show_menu_player_race ( playerid ) ;
				case 4:
				{
				    if ( src_player_count [ playerid ] < 5 )
					{
						show_menu_player_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете полностью удалить маршрут." ) ;
						return 1 ;
					}
					if ( src_player_start [ playerid ] == 2 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка уже началась." ) ;
						return 1 ;
					}

					new _sql_string [ 144 ] ;
					format ( _sql_string, sizeof _sql_string, "DELETE FROM `src_player_checkpoint` WHERE `u_id` = '%d' ORDER BY `src_player_checkpoint`.`u_id` DESC LIMIT 1", p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, _sql_string ) ;

					src_player_count [ playerid ] -- ;
					show_menu_player_race ( playerid ) ;
				}
				case 5:
				{
				    if ( ! src_player_count [ playerid ] )
					{
						show_menu_player_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Ваша гонка не создана." ) ;
						return 1 ;
					}
					if ( src_player_start [ playerid ] == 2 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка уже началась." ) ;
						return 1 ;
					}
				
					static const _str [ ] = "DELETE FROM `src_player_checkpoint` WHERE `u_id` = '%d'" ;
				    new _sql_string [ sizeof _str + 9 ] ;
					format ( _sql_string, sizeof _sql_string, _str, p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, _sql_string ) ;
					
					src_player_count [ playerid ] = 0 ;
					
					show_menu_player_race ( playerid ) ;
				}
	        }
	    }
	    case d_menu_race:
	    {
	        if ( ! response ) return 1 ;
	        switch ( listitem )
	        {
	            case 0:
	            {
	                if ( ! src_player_count [ playerid ] )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Маршрут не выбран." ) ;
						return 1 ;
					}
					if ( ! src_player_start [ playerid ] )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка не создана." ) ;
						return 1 ;
					}
					
					new player_string [ 256 ], line_string [ 64 ], count_player = 0 ;
					for ( new p = 0 ; p < max_prace ; p ++ )
				    {
						foreach(new i: player_race[playerid])
						{
						    count_player ++ ;
						    format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s[%d]. Точка: {"#cLY"}%d\n", count_player, p_info [ i ] [ name ], i, player_race_cp [ i ] ) ;
						    strcat ( player_string, line_string ) ;
						    continue ;
						}
						count_player ++ ;
					    format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}-\n", count_player ) ;
					    strcat ( player_string, line_string ) ;
					}
					
					global_string [ 0 ] = EOS ;
					format ( global_string, 356, "\
						{"#cWH"}Статус: {"#cLY"}%s\n\
						{"#cWH"}Тип: {"#cLY"}%s\n\
						{"#cWH"}Точек: {"#cLY"}%d\n\n\
						%s\n\n\
						{"#cWH"}Баланс: {"#cGN"}%d$\n\
						{"#cWH"}Ставка: {"#cGN"}%d$", ( src_player_start [ playerid ] ) ? ( "{"#cGN"}Гонка" ) : ( "{"#cYW"}Регистрация участников" ), ( src_player_type [ playerid ] ) ? ( "{"#cGN"}Спринт" ) : ( "{"#cGN"}Дрифт" ), src_player_count [ playerid ], player_string, src_player_money [ playerid ] * Iter_Count(player_race[playerid]), src_player_money [ playerid ] ) ;
					show_dialog(playerid, d_race_back, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", global_string, "Назад", "Закрыть");
	            }
	            case 1:
	            {
	                if ( ! src_player_count [ playerid ] )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Маршрут не выбран." ) ;
						return 1 ;
					}
					if ( ! src_player_start [ playerid ] )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка не создана." ) ;
						return 1 ;
					}
					if ( src_player_start [ playerid ] == 2 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка уже началась." ) ;
						return 1 ;
					}
					if ( Iter_Count(player_race[playerid]) >= max_prace )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас максимальное количество участников." ) ;
						return 1 ;
					}
	            
	                global_string [ 0 ] = EOS ;

					new TotalPla ;
					foreach(new i: streamed_players[playerid])
					{
						if ( player_vehicle [ i ] == INVALID_VEHICLE_ID ) continue ;
						if ( is_player_race_regged [ i ] ) continue ;

						set_player_listitem_values ( playerid, TotalPla, i ) ;

						TotalPla ++;
						if(TotalPla == 20) break ;

						format( global_string, sizeof global_string, "%s{"#cWH"}%s[%d] - {"#cBL"}%s\n", global_string, p_info [ i ] [ name ], i, GetVehicleNameEx ( player_vehicle [ i ] ) ) ;
					}
					if(TotalPla == 0)
					{
		                show_dialog(playerid, d_race_back, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выбор соперника", "{"#cWH"}Нет поблизости игроков, которых можно внести в гонку!", "Принять", "");
					}
					else
					{
					    strcat ( global_string, "{"#cGRDialog"}Добавить себя в гонку" ) ;
					    show_dialog(playerid, d_race_opponent, DIALOG_STYLE_LIST, "{"#cBHD"}Выбор соперника", global_string, "Выбрать", "Назад");
					}
	            }
	            case 2:
	            {
	                if ( ! src_player_count [ playerid ] )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Маршрут не выбран." ) ;
						return 1 ;
					}
					if ( ! src_player_start [ playerid ] )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка не создана." ) ;
						return 1 ;
					}
					if ( src_player_start [ playerid ] == 2 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка уже началась." ) ;
						return 1 ;
					}
	            
	                global_string [ 0 ] = EOS ;

					new TotalPla ;
					foreach(new i: player_race[playerid])
					{
						if ( GetPlayerVehicleID ( i ) == 0 ) continue ;
						
						set_player_listitem_values ( playerid, TotalPla, i ) ;

						TotalPla ++;

						format( global_string, sizeof global_string, "%s{"#cWH"}%s[%d] - {"#cBL"}%s\n", global_string, p_info [ i ] [ name ], i, GetVehicleNameEx ( GetPlayerVehicleID ( i ) ) ) ;
					}
					if(TotalPla == 0)
					{
		                show_dialog(playerid, d_race_back, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Дисквалификация", "{"#cWH"}Нет поблизости игроков, которых можно внести в гонку!", "Принять", "");
					}
					else
					{
					    strcat ( global_string, "{"#cGRDialog"}Удалить себя из гонки" ) ;
					    show_dialog(playerid, d_race_unopponent, DIALOG_STYLE_LIST, "{"#cBHD"}Дисквалификация", global_string, "Выбрать", "Назад");
					}
	            }
	            case 3:
	            {
	                if ( ! src_player_count [ playerid ] )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Маршрут не выбран." ) ;
						return 1 ;
					}
					if ( ! src_player_start [ playerid ] )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка не создана." ) ;
						return 1 ;
					}
					if ( src_player_start [ playerid ] == 2 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка уже началась." ) ;
						return 1 ;
					}
					if ( Iter_Count(player_race[playerid]) < min_prace )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Не достаточно участников." ) ;
						return 1 ;
					}
					
					if ( ! IsPlayerInRangeOfPoint ( playerid, 5, src_player_info [ playerid ] [ 0 ] [ race_position ] [ 0 ], src_player_info [ playerid ] [ 0 ] [ race_position ] [ 1 ], src_player_info [ playerid ] [ 0 ] [ race_position ] [ 2 ] ) )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь не на старте." ) ;
						return 1 ;
					}
					
					new _player_total = 0 ;
				    foreach(new i: player_race[playerid])
					{
					    if ( ! IsPlayerInRangeOfPoint ( playerid, 15, p_t_info [ i ][ p_pos ] [ 0 ], p_t_info [ i ][ p_pos ] [ 1 ], p_t_info [ i ][ p_pos ] [ 2 ] ) ) continue ;
					    _player_total ++ ;
					}
					
					if ( _player_total != Iter_Count(player_race[playerid]) )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Рядом с Вами не все участники." ) ;
						return 1 ;
					}
					
					foreach(new i: player_race[playerid])
					{
			    		SendClientMessage ( playerid, col_gray, "{"#cYW"}* [RACE] Внимание! Гонка начата. Старт через 5 секунд." );
					
					    TogglePlayerControllable ( i, false ) ;
					}
					
					src_player_started [ playerid ] = 5 ;
					src_player_timer [ playerid ] = SetTimerEx ( "start_player_racing", 1000, true, "i", playerid ) ;
					
					new pay_money = floatround ( ( src_player_money [ playerid ] * 10 ) / 100 ) ;
					
					static const _str [ ] = "{"#cYW"}* [RACE] Вы получили процент от банка в размере %i$." ;
					new scm_string [ sizeof _str + 9 ] ;
					format ( scm_string, sizeof ( scm_string ), _str, pay_money ) ;
			    	SendClientMessage ( playerid, col_gray, scm_string );
			    	
			    	give_money ( playerid, -pay_money ) ;
	            	insert_money_log ( playerid, INVALID_PLAYER_ID, -pay_money, "за организацию гонки" ) ;
	            }
	            case 4:
	            {
	                if ( ! src_player_count [ playerid ] )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Маршрут не выбран." ) ;
						return 1 ;
					}
					if ( src_player_start [ playerid ] == 2 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка уже началась." ) ;
						return 1 ;
					}
					
					show_menu_race ( playerid ) ;
					
					src_player_start [ playerid ] = 1 ;
					
					SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы создали гонку. Приглашайте участников!" ) ;
	            }
	            case 5:
	            {
	                if ( ! src_player_count [ playerid ] )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Маршрут не выбран." ) ;
						return 1 ;
					}
					if ( src_player_start [ playerid ] == 2 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка уже началась." ) ;
						return 1 ;
					}
					
					show_menu_race ( playerid ) ;

					if ( ! src_player_type [ playerid ] )
					{
						src_player_type [ playerid ] = 1 ;
						SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы выбрали тип гонки: {"#cBL"}Спринт{"#cGRInfo"}." ) ;
					}
					else
					{
					    src_player_type [ playerid ] = 0 ;
						SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы выбрали тип гонки: {"#cBL"}Дрифт{"#cGRInfo"}." ) ;
					}
	            }
	            case 6:
	            {
	                if ( ! src_player_count [ playerid ] )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Маршрут не выбран." ) ;
						return 1 ;
					}
					if ( src_player_start [ playerid ] == 2 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка уже началась." ) ;
						return 1 ;
					}
					
					show_dialog(playerid, d_race_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Ставка",  "{"#cWH"}Укажите сумму ставки для гонки:", "Готово", "Назад");
	            }
	            case 7:
	            {
					if ( src_player_start [ playerid ] == 2 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка уже началась." ) ;
						return 1 ;
					}
					
					mysql_tquery ( sql_connection, "SELECT * FROM `src_info`", "src_playerinfo_loading", "i", playerid ) ;
	            }
	            case 8:
	            {
					static const _str [ ] = "SELECT * FROM `src_player_checkpoint` WHERE `u_id` = '%d'" ;
                 	new sql_string [ sizeof _str + 11 ] ;
					format ( sql_string, sizeof sql_string, _str, p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, sql_string, "src_player_checkpoint_loading", "i", playerid ) ;
	            }
				case 9:
				{
				    if ( ! src_player_count [ playerid ] )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Маршрут не выбран." ) ;
						return 1 ;
					}
					
					SetPlayerRaceCheckpoint ( playerid, 1, src_player_info [ playerid ] [ 0 ] [ race_position ] [ 0 ], src_player_info [ playerid ] [ 0 ] [ race_position ] [ 1 ], src_player_info [ playerid ] [ 0 ] [ race_position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
					SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
					is_gps_used { playerid } = 1 ;
				}
	            case 10:
	            {
	                if ( ! src_player_start [ playerid ] )
	                {
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка ещё не создана." ) ;
						return 1 ;
					}
					if ( src_player_start [ playerid ] == 2 )
					{
						show_menu_race ( playerid ) ;
						SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Гонка уже началась." ) ;
						return 1 ;
					}
					
					static const _str [ ] = "{"#cGInfo"}* {"#cWH"}%s вынес(ла) Вас из списка участников в гонке." ;
					new scm_string [ sizeof _str + 24 ] ;
					foreach(new i: player_race[playerid])
					{
						format ( scm_string, sizeof scm_string, _str, p_info [ playerid ] [ name ] ) ;
						SendClientMessage ( i, col_white, scm_string ) ;

						is_player_race_regged [ i ] = false ;
					}
					
					Iter_Clear(player_race[playerid]);
	                src_player_start [ playerid ] = 0 ;
	            }
	        }
	    }
	    case d_race_money:
		{
			if(response)
			{
				new _value = strval ( inputtext ) ;

				if ( _value < 1000 || _value > 100000 ) return show_dialog(playerid, d_race_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Ставка",  "{"#cWH"}Укажите сумму ставки для гонки:\n\n{"#cGRDialog"}* Сумма не может быть менее 1.000$ и более 100.000$", "Готово", "Назад");

				src_player_money [ playerid ] = _value ;
				show_menu_race ( playerid ) ;
			}
			else
			{
			    show_menu_race ( playerid ) ;
			}
			return 1 ;
		}
	    case d_race_loading:
		{
		    if ( ! response )
			{
			    clear_player_listitem_values ( playerid ) ;
				show_menu_race ( playerid ) ;
				return 1 ;
			}

			if ( ! strcmp("Выбрать свой маршрут", inputtext ) )
			{
				static const _str [ ] = "SELECT * FROM `src_player_checkpoint` WHERE `u_id` = '%d' LIMIT %d" ;
				new sql_string [ sizeof _str + 9 + 4 ] ;
				format ( sql_string, sizeof sql_string, _str, p_info [ playerid ] [ id ], SRC_TRECK_COUNT ) ;
				mysql_tquery ( sql_connection, sql_string, "src_player_checkpoint_loading", "i", playerid ) ;
			    return 1 ;
			}
			new select_id = get_player_listitem_values ( playerid, listitem ) ;

            clear_player_listitem_values ( playerid ) ;
			
			static const _str [ ] = "SELECT * FROM `src_checkpoint` WHERE `r_step` = '%d' LIMIT %d" ;
			new sql_string [ sizeof _str + 4 + 4 ] ;
			format ( sql_string, sizeof sql_string, _str, select_id, SRC_TRECK_COUNT ) ;
			mysql_tquery ( sql_connection, sql_string, "src_pl_checkpoint_loading", "i", playerid ) ;
	    }
	    case d_race_unopponent:
	    {
	        if ( ! response ) return show_menu_race ( playerid ) ;

			new _o_id = get_player_listitem_values ( playerid, listitem ) ;

			clear_player_listitem_values ( playerid ) ;

			if ( ! strcmp("Удалить себя из гонки", inputtext ) )
			{
			    if ( ! is_player_race_regged [ playerid ] ) return show_dialog(playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Произошла ошибка", "{"#cWH"}Вы не являетесь участником гонки!", "Принять", "");
                is_player_race_regged [ playerid ] = false ;
                player_race_owner [ playerid ] = -1 ;
                Iter_Remove(player_race[playerid], playerid);
				return 1 ;
			}

		    if ( ! IsPlayerConnected ( _o_id ) ) return show_dialog(playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Произошла ошибка", "{"#cWH"}Этот игрок вышел с сервера!", "Принять", "");
		    if ( ! is_player_race_regged [ _o_id ] ) return show_dialog(playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Произошла ошибка", "{"#cWH"}Игрок не является участником гонки!", "Принять", "");

			static const _str [ ] = "{"#cGInfo"}* {"#cWH"}%s вынес(ла) Вас из списка участников в гонке." ;
			new scm_string [ sizeof _str + 24 ] ;
			format ( scm_string, sizeof scm_string, _str, p_info [ playerid ] [ name ] ) ;
			SendClientMessage ( _o_id, col_white, scm_string ) ;
			
			is_player_race_regged [ _o_id ] = false ;
			player_race_owner [ _o_id ] = -1 ;

            Iter_Remove(player_race[playerid], _o_id);
		}
	    case d_race_opponent:
	    {
	        if ( ! response ) return show_menu_race ( playerid ) ;

			new _o_id = get_player_listitem_values ( playerid, listitem ) ;

			clear_player_listitem_values ( playerid ) ;
			
			if ( ! strcmp("Добавить себя в гонку", inputtext ) )
			{
			    if ( is_player_race_regged [ playerid ] ) return show_dialog(playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Произошла ошибка", "{"#cWH"}Вы уже являетесь участником гонки!", "Принять", "");
                is_player_race_regged [ playerid ] = true ;
                player_race_owner [ playerid ] = playerid ;
                Iter_Add(player_race[playerid], playerid);
				return 1 ;
			}

		    if ( ! IsPlayerConnected ( _o_id ) ) return show_dialog(playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Произошла ошибка", "{"#cWH"}Этот игрок вышел с сервера!", "Принять", "");
		    if ( is_player_race_regged [ _o_id ] ) return show_dialog(playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Произошла ошибка", "{"#cWH"}Игрок уже является участником гонки!", "Принять", "");

			new scm_string [ 144 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}%s внёс Вас в список участников в гонке.", p_info [ playerid ] [ name ] ) ;
			SendClientMessage ( _o_id, col_white, scm_string ) ;
			SendClientMessage ( _o_id, col_yellow, !"* Для выхода из гонки используйте: /exitrace" ) ;
			
			is_player_race_regged [ _o_id ] = true ;
			player_race_owner [ _o_id ] = playerid ;
			
            Iter_Add(player_race[playerid], _o_id);
		}
	    case d_race_back:
	    {
	        if ( ! response ) return 1 ;
	        show_menu_race ( playerid ) ;
	    }
	}
	return 1 ;
}

callback: start_player_racing ( playerid )
{
	src_player_started [ playerid ] -- ;
	foreach(new i: player_race[playerid])
	{
	    switch ( src_player_started [ playerid ] )
	    {
    		case 0:
			{
			    if(is_player_race_regged[i])
			    {
					GameTextForPlayer ( i,"~g~~h~START", 2000, 4);
					TogglePlayerControllable ( i, 1 ) ;
				}
				
				if ( p_info [ i ] [ money ] < src_player_money [ playerid ] )
				{
				    player_race_cp [ i ] = 0 ;
					player_race_owner [ i ] = -1 ;
					is_player_race_regged [ i ] = false ;
					SendClientMessage ( i, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно средств для участия в гонках." ) ;
				}
				else
				{
					give_money ( i, -src_player_money [ playerid ] ) ;
	            	insert_money_log ( i, INVALID_PLAYER_ID, -src_player_money [ playerid ], "ставка гонки" ) ;

					player_race_cp [ i ] = 0 ;
					player_race_owner [ i ] = playerid ;
					new r = player_race_cp [ i ] ;
					SetPlayerRaceCheckpoint ( i, 0, src_player_info [ playerid ] [ r ] [ race_position ] [ 0 ], src_player_info [ playerid ] [ r ] [ race_position ] [ 1 ], src_player_info [ playerid ] [ r ] [ race_position ] [ 2 ], src_player_info [ playerid ] [ r + 1 ] [ race_position ] [ 0 ], src_player_info [ playerid ] [ r + 1 ] [ race_position ] [ 1 ], src_player_info [ playerid ] [ r + 1 ] [ race_position ] [ 2 ], 10.0);
				}
				if ( src_player_timer [ playerid ] ) KillTimer ( src_player_timer [ playerid ] ) ;
			}
			case 1..5:
			{
				if ( is_player_race_regged [ i ] )
				{
					new td_str [ 16 ] ;
					format ( td_str, sizeof td_str, "~y~%i", src_player_started [ playerid ] ) ;
					GameTextForPlayer ( i, td_str, 1100, 4 ) ;
				}
			}
		}
	}
	return 1 ;
}

callback: src_playerinfo_loading ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if( rows )
	{
	    global_string [ 0 ] = EOS ;
		
		static const _str [ ] = "{"#cBL"}%d. {"#cWH"}%s\n" ;
		new line_string [ sizeof _str + 4 + 24 ] ;
		
	    new _r_name [ 24 ], _r_step ;
	    for ( new i = 0 ; i < rows ; i++ )
	    {
	        _r_step = cache_get_field_content_int ( i, "r_step", sql_connection ) ;
	        cache_get_field_content ( i, "r_name", _r_name, sql_connection, 24 ) ;

	        set_player_listitem_values ( playerid, i, _r_step ) ;

			format ( line_string, sizeof line_string, _str, i + 1, _r_name ) ;
			strcat ( global_string, line_string ) ;
	    }
	    strcat ( global_string, "{"#cGRDialog"}Выбрать свой маршрут" ) ;
	  	show_dialog(playerid, d_race_loading, DIALOG_STYLE_LIST, "{"#cBHD"}Выбор маршрута", global_string, "Выбрать", "Назад");
	}
	return 1 ;
}

callback: src_pl_checkpoint_loading ( playerid )
{
	new fields, time = GetTickCount ( ) ;
	cache_get_data ( src_player_count [ playerid ], fields ) ;
	if( src_player_count [ playerid ] )
	{
	    for ( new i = 0 ; i < src_player_count [ playerid ] ; i ++ )
	    {
	        src_player_info [ playerid ] [ i ] [ race_step ] = cache_get_field_content_int ( i, "r_step", sql_connection ) ;
			
	        src_player_info [ playerid ] [ i ] [ race_position ] [ 0 ] = cache_get_field_content_float ( i, "r_pos_x", sql_connection ) ;
			src_player_info [ playerid ] [ i ] [ race_position ] [ 1 ] = cache_get_field_content_float ( i, "r_pos_y", sql_connection ) ;
			src_player_info [ playerid ] [ i ] [ race_position ] [ 2 ] = cache_get_field_content_float ( i, "r_pos_z", sql_connection ) ;
			src_player_info [ playerid ] [ i ] [ race_position ] [ 3 ] = cache_get_field_content_float ( i, "r_pos_a", sql_connection ) ;
	    }
	}
	show_menu_race ( playerid ) ;
	printf("[SERVER] Загружено %d чекпоинтов для гонок Player Street Racing Club. (%d ms)", src_player_count [ playerid ], GetTickCount ( ) - time ) ;
	return 1 ;
}

callback: src_player_checkpoint_loading ( playerid )
{
	new fields, time = GetTickCount ( ) ;
	cache_get_data ( src_player_count [ playerid ], fields ) ;
	if( src_player_count [ playerid ] )
	{
	    format ( src_player_name [ playerid ], 24, "Личная" ) ;
	    for ( new i = 0 ; i < src_player_count [ playerid ] ; i ++ )
		{
	        src_player_info [ playerid ] [ i ] [ race_position ] [ 0 ] = cache_get_field_content_float ( i, "r_pos_x", sql_connection ) ;
			src_player_info [ playerid ] [ i ] [ race_position ] [ 1 ] = cache_get_field_content_float ( i, "r_pos_y", sql_connection ) ;
			src_player_info [ playerid ] [ i ] [ race_position ] [ 2 ] = cache_get_field_content_float ( i, "r_pos_z", sql_connection ) ;
			src_player_info [ playerid ] [ i ] [ race_position ] [ 3 ] = cache_get_field_content_float ( i, "r_pos_a", sql_connection ) ;
	    }
	}
	show_menu_player_race ( playerid ) ;
	printf("[SERVER] Загружено %d чекпоинтов для гонок Player Street Racing Club. (%d ms)", src_player_count [ playerid ], GetTickCount ( ) - time ) ;
	return 1 ;
}

stock player_race_OnRaceCheckpoint ( playerid ) // OnPlayerEnterRaceCheckpoint
{
	if ( player_race_owner [ playerid ] != -1 )
	{
		if ( is_player_race_regged [ playerid ] )
	  	{
	    	new ch = player_race_cp [ playerid ] ;
	   		player_race_cp [ playerid ] ++ ;
	    	player_race_first_cp [ playerid ] ++ ;

			new owner_race = player_race_owner [ playerid ] ;
	        if ( ch == src_player_count [ owner_race ] - 2 )
			{
			    SetPlayerRaceCheckpoint(playerid, 1, src_player_info [ owner_race ] [ ch ] [ race_position ] [ 0 ], src_player_info [ owner_race ] [ ch ] [ race_position ] [ 1 ], src_player_info [ owner_race ] [ ch ] [ race_position ] [ 2 ], src_player_info [ owner_race ] [ ch + 1 ] [ race_position ] [ 0 ], src_player_info [ owner_race ] [ ch + 1 ] [ race_position ] [ 1 ], src_player_info [ owner_race ] [ ch + 1 ] [ race_position ] [ 2 ], 10.0);
				return 1 ;
			}
			else if ( ch == src_player_count [ owner_race ] - 1 )
			{
			    src_player_place [ owner_race ] ++ ;

				static const _str [ ] = "{"#cYW"}* [RACE] %s занял(а) %i место. Приз составил: %i$" ;
				new text_str [ sizeof _str + 24 + 2 + 9 ] ;
				foreach(new i: player_race[owner_race])
				{
					format ( text_str, sizeof ( text_str ), _str, p_info [ playerid ] [ name ], src_player_place [ owner_race ], src_player_money [ owner_race ] ) ;
				    SendClientMessage(i, col_gray, text_str );
				    
				    is_player_race_regged [ i ] = false ;
					player_race_first_cp [ i ] = player_race_cp [ i ] = 0 ;
					player_race_owner [ i ] = -1 ;
					DisablePlayerRaceCheckpoint ( i ) ;
					src_player_place [ i ] = 0 ;
				}
				give_money ( playerid, src_player_money [ owner_race ] ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, src_player_money [ owner_race ], "выигрыш гонки" ) ;
				
				Iter_Clear(player_race[owner_race]);
			}
	    	else
	    	{
	       		SetPlayerRaceCheckpoint(playerid, 0, src_player_info [ owner_race ] [ ch ] [ race_position ] [ 0 ], src_player_info [ owner_race ] [ ch ] [ race_position ] [ 1 ], src_player_info [ owner_race ] [ ch ] [ race_position ] [ 2 ], src_player_info [ owner_race ] [ ch + 1 ] [ race_position ] [ 0 ], src_player_info [ owner_race ] [ ch + 1 ] [ race_position ] [ 1 ], src_player_info [ owner_race ] [ ch + 1 ] [ race_position ] [ 2 ], 10.0);
			}
			return 1 ;
		}
	}
	return 1 ;
}

stock player_race_OnPlayerDisconnect ( playerid )
{
	if ( player_race_owner [ playerid ] == playerid )
	{
		new owner_race = player_race_owner [ playerid ] ;
		if ( is_player_race_regged [ playerid ] )
	  	{
		    is_player_race_regged [ playerid ] = false ;
			player_race_first_cp [ playerid ] = player_race_cp [ playerid ] = 0 ;
			player_race_owner [ playerid ] = -1 ;
			DisablePlayerRaceCheckpoint ( playerid ) ;

			new pay_money = floatround ( src_player_money [ owner_race ] / 3 ) ;

			static const _str [ ] = "{"#cYW"}* [RACE] %s покинул(а) игру при активной гонке. Приз на оставшихся участников: %i$" ;
			new text_str [ sizeof _str + 24 + 9 ] ;
			foreach(new i: player_race[owner_race])
			{
				if ( i == playerid ) continue ;
				format ( text_str, sizeof ( text_str ), _str, p_info [ playerid ] [ name ], src_player_money [ owner_race ] ) ;
			    SendClientMessage(i, col_gray, text_str );

			    is_player_race_regged [ i ] = false ;
				player_race_first_cp [ i ] = player_race_cp [ i ] = 0 ;
				player_race_owner [ i ] = -1 ;
				DisablePlayerRaceCheckpoint ( i ) ;
				src_player_place [ i ] = 0 ;
				
				give_money ( i, pay_money ) ;
				insert_money_log ( i, INVALID_PLAYER_ID, pay_money, "выигрыш гонки" ) ;
			}
			Iter_Clear(player_race[owner_race]);
		}
	}
	return 1 ;
}