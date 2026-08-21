#define pick_type_udobrenie	400
#define pick_type_halloween 401
#define pick_type_zele		402

#define area_type_grave 401
#define area_type_vedma 402
#define area_type_smotritel 403

static Float: halloween_area_grave [ 5 ] [ 3 ] =
{
	{ -2470.7106, 2558.3752, 46.0578 },
	{ -2465.1818, 2558.6564, 46.0568 },
	{ -2490.0397, 2559.2578, 46.0547 },
	{ -2485.5336, 2550.6093, 46.0843 },
	{ -2496.8344, 2550.6000, 46.0843 }
} ;

static Float: position_zele [ 3 ] = { 2316.3171, 1756.7276, 0.9862 } ;
static Float: position_udobrenie [ 3 ] = { -2475.2590, 2544.1450, 46.1064 } ;

static halloween_actor_skin [ ] = { 110, 111 } ;
static Float: halloween_actor_position [ 2 ] [ 4 ] =
{
	{ -2478.6367, 2542.8120, 46.2561, 2.4956 },
	{ -2430.3847, 2683.9055, 39.6445, 181.2140 }
} ;

new bool: toggled_tikva [ MAX_PLAYERS ] [ 20 ] ;
new bool: clear_tikva [ 20 ] = { false, ... } ;
static Float: halloween_tikva_position [ 20 ] [ 3 ] =
{
	{ -2425.0739, 1657.5181, 52.7637 },
	{ -2449.7700, 1677.9399, 52.8797 },
	{ -2462.2189, 1546.2855, 53.0255 },
	{ -2517.0195, 1540.3155, 53.0241 },
	{ -2535.8872, 1581.4992, 53.0210 },
	{ -2547.3408, 1668.1350, 52.4276 },
	{ -2529.0380, 1740.5277, 52.5624 },
	{ -2611.9001, 1842.5146, 52.6150 },
	{ -2545.5988, 1649.0478, 52.2009 },
	{ -2512.3974, 1462.5706, 52.4771 },
	{ -2475.0192, 1467.4934, 52.5753 },
	{ -2420.8435, 1523.0167, 52.5812 },
	{ -2342.2065, 1478.9888, 52.5730 },
	{ -2389.6933, 1524.0377, 52.5760 },
	{ -2350.2661, 1571.9913, 52.5729 },
	{ -2362.1604, 1617.4633, 52.5601 },
	{ -2367.5166, 1649.1922, 52.5718 },
	{ -2433.9687, 1755.1251, 52.5656 },
	{ -2530.2016, 1820.0639, 52.5639 },
	{ -2675.8815, 1809.7142, 42.2151 }
} ;

stock halloween_OnGameModeInit ( )
{
	for ( new i = 0 ; i < 2 ; i ++ )
	{
		CreateDynamicActor ( halloween_actor_skin [ i ], halloween_actor_position [ i ] [ 0 ],
													halloween_actor_position [ i ] [ 1 ],
													halloween_actor_position [ i ] [ 2 ],
													halloween_actor_position [ i ] [ 3 ] ) ;
	}
	
	new areaid ;
	for ( new i = 0 ; i < 5 ; i ++ )
	{
		areaid = CreateDynamicSphere ( halloween_area_grave [ i ] [ 0 ], halloween_area_grave [ i ] [ 1 ], halloween_area_grave [ i ] [ 2 ], 2.0, 0, 0, -1 ) ;
	    area_info [ areaid ] [ a_type ] = area_type_grave ;
	    area_info [ areaid ] [ a_item ] = i ;
	}
	
	areaid = CreateDynamicSphere ( -2478.6367, 2542.8120, 46.2561, 5.0, 0, 0, -1 ) ;
	area_info [ areaid ] [ a_type ] = area_type_smotritel ;
	
	areaid = CreateDynamicSphere ( -2430.3847, 2683.9055, 39.6445, 5.0, 0, 0, -1 ) ;
	area_info [ areaid ] [ a_type ] = area_type_vedma ;
	
	new pickupid ;
	for ( new i = 0 ; i < 20 ; i ++ )
	{
		pickupid = CreateDynamicPickup ( 19320, 23, halloween_tikva_position [ i ] [ 0 ], halloween_tikva_position [ i ] [ 1 ], halloween_tikva_position [ i ] [ 2 ], 0, 0 ) ;
	    pick_info [ pickupid ] [ pick_type ] = pick_type_halloween ;
	    pick_info [ pickupid ] [ pick_item ] = i ;
	}
	
	pickupid = CreateDynamicPickup ( 19130, 23, position_udobrenie [ 0 ], position_udobrenie [ 1 ], position_udobrenie [ 2 ], 0, 0 ) ;
	pick_info [ pickupid ] [ pick_type ] = pick_type_udobrenie ;
	CreateDynamic3DTextLabel ( "** Удобрения **", col_blue, position_udobrenie [ 0 ], position_udobrenie [ 1 ], position_udobrenie [ 2 ] + 1.0, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, 0, 0 ) ;
	
	pickupid = CreateDynamicPickup ( 1276, 23, position_zele [ 0 ], position_zele [ 1 ], position_zele [ 2 ], 0, 0 ) ;
	pick_info [ pickupid ] [ pick_type ] = pick_type_zele ;
	return 1 ;
}

new halloween_info [ 5 ] [ qinfo_ ] =
{
	{"Кладбище", "Помогите смотрителю кладбища удобрить могилы.", "300.000$"},
	{"Зелье", "Отправляйтесь и заберите секретное зелье.", "150.000$"},
	{"Тыквы", "Соберите 20 тыкв.", "500.000$"},
	{"Ведьма", "Отвезите тыквы и зелье ведьме.", "100.000$"},
	{"Смотритель", "Отвезите смотрителю зелье.", "700.000$ + Маска Punisher"}
} ;

new halloween_rewards [ sizeof halloween_info ] [ rinfo_ ] =
{
	{ 300000, 0 },
	{ 150000, 0 },
	{ 500000, 0 },
	{ 100000, 0 },
	{ 700000, 0 }
} ;

new halloween_select [ MAX_PLAYERS ] ;
new halloween_status [ MAX_PLAYERS ] ;
new halloween_progress [ MAX_PLAYERS ] ;
new is_halloween_progress [ MAX_PLAYERS char ] ;

new bool: halloween_udobrenie [ MAX_PLAYERS ] ;
new bool: halloween_grave_used [ MAX_PLAYERS ] [ 5 ] = { false, ... } ;

stock clear_player_halloween ( playerid )
{
	halloween_udobrenie [ playerid ] = false ;
	for ( new i = 0 ; i < 5 ; i ++ ) halloween_grave_used [ playerid ] [ i ] = false ;
	toggled_tikva [ playerid ] = clear_tikva ;
	is_halloween_progress { playerid } = 0 ;
	return 1 ;
}

stock halloween_EnterDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_grave:
		{
			new i = area_info [ areaid ] [ a_item ] ;
			if ( halloween_grave_used [ playerid ] [ i ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже удобряли эту могилу." ) ;
			
			halloween_grave_used [ playerid ] [ i ] = true ;
			ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 6.1, 0, 0, 0, 0, 0,1 ) ;
			
			is_halloween_progress { playerid } ++ ;
			checking_halloween_progress ( playerid, 0, 1 ) ;
			if ( is_halloween_progress { playerid } >= 5 )
			{
				SetPlayerRaceCheckpoint ( playerid, 1, -2478.6367, 2542.8120, 46.2561, 0.0, 0.0, 0.0, 2.0 ) ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
				is_gps_used { playerid } = 1 ;
				return 1 ;
			}	
			
			new _is_id = is_halloween_progress { playerid } ;
			SetPlayerRaceCheckpoint ( playerid, 1, halloween_area_grave [ _is_id ] [ 0 ], halloween_area_grave [ _is_id ] [ 1 ], halloween_area_grave [ _is_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;
			return 1 ;
		}
		case area_type_smotritel:
		{
			checking_halloween_progress ( playerid, 4, 1 ) ;
			show_halloween_quest ( playerid ) ;
			return 1 ;
		}
		case area_type_vedma:
		{
			checking_halloween_progress ( playerid, 3, 1 ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock halloween_DynamicPickup ( playerid, pickupid )
{
	switch ( pick_info [ pickupid ] [ pick_type ] )
	{
		case pick_type_udobrenie:
		{
			SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вы взяли удобрения. Удобрите пять могил." ) ;
			halloween_udobrenie [ playerid ] = true ;
			return 1 ;
		}
		case pick_type_zele:
		{
			checking_halloween_progress ( playerid, 1, 1 ) ;
			
			SetPlayerRaceCheckpoint ( playerid, 1, -2478.6367, 2542.8120, 46.2561, 0.0, 0.0, 0.0, 2.0 ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
			is_gps_used { playerid } = 1 ;
			return 1 ;
		}
		case pick_type_halloween:
		{
			new i = pick_info [ pickupid ] [ pick_item ] ;
			if ( toggled_tikva [ playerid ] [ i ] == true ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже подбирали эту тыквы. Найдите ещё тыквы." ) ;
			toggled_tikva [ playerid ] [ i ] = true ;
			
			is_halloween_progress { playerid } ++ ;
			checking_halloween_progress ( playerid, 2, 1 ) ;
			if ( is_halloween_progress { playerid } >= 20 )
			{
				SetPlayerRaceCheckpoint ( playerid, 1, -2478.6367, 2542.8120, 46.2561, 0.0, 0.0, 0.0, 2.0 ) ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
				is_gps_used { playerid } = 1 ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock checking_halloween_progress ( playerid, quest_id, amount_plus )
{
	if ( halloween_select [ playerid ] != quest_id ) return 1 ;
	if ( halloween_status [ playerid ] == 1 )
	{
	    static const _halloween_progress [ ] =
		{
			5,
			1,
			20,
			1,
			1
		} ;

		halloween_progress [ playerid ] += amount_plus ;

		quest_td_show ( playerid, halloween_progress [ playerid ], _halloween_progress [ quest_id ], "halloween_progress" ) ;

		if ( halloween_progress [ playerid ] >= _halloween_progress [ quest_id ] )
		{
		    new scm_string [ 72 + ( 32 * 2 ) ] ;
		    if ( quest_id == sizeof halloween_info - 1 )
		    {
				give_player_item ( playerid, 10977 ) ;

				format ( scm_string, sizeof scm_string, "Задание успешно выполнено. Ваша награда: {"#cWH"}%s и %s{"#cSucces"}.", halloween_info [ quest_id ] [ q_rewards ], get_accessorie_name ( 10977 ) ) ;
				SendClientMessage ( playerid, col_succes, scm_string ) ;

				SendClientMessage ( playerid, col_succes, !"Вы завершили квестовую линию. Отправляйтесь к смотрителю, чтобы получить своё вознаграждение." ) ;
		    }
		    else
		    {
		        if ( quest_id == sizeof halloween_info - 1 )
		        {
					give_player_item ( playerid, 10977 ) ;

					format ( scm_string, sizeof scm_string, "Задание успешно выполнено. Ваша награда: {"#cWH"}%s и %s{"#cSucces"}.", halloween_info [ quest_id ] [ q_rewards ], get_accessorie_name ( 10977 ) ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
		        }
		        else
		        {
					format ( scm_string, sizeof scm_string, "Задание успешно выполнено. Ваша награда: {"#cWH"}%s{"#cSucces"}.", halloween_info [ quest_id ] [ q_rewards ] ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
		        }

		        format ( scm_string, sizeof scm_string, "Следующее задание: {"#cWH"}%s{"#cSucces"}.", halloween_info [ quest_id + 1 ] [ q_name ] ) ;
				SendClientMessage ( playerid, col_succes, scm_string ) ;

				SendClientMessage ( playerid, col_succes, !"Отправляйтесь к смотрителю, чтобы получить своё вознаграждение." ) ;
		    }

			halloween_status [ playerid ] = 2 ;
			update_halloween_data ( playerid ) ;
		}
		else update_int_sql ( playerid, "u_halloween_progress", halloween_progress [ playerid ] ) ;
	}
	return 1 ;
}

stock update_halloween_data ( playerid )
{
	new sql_string [ 144 ] ;
	format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_halloween_select` = '%d', `u_halloween_status` = '%d', `u_halloween_progress` = '%d' WHERE `u_id` = '%d' LIMIT 1", halloween_select [ playerid ], halloween_status [ playerid ], halloween_progress [ playerid ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, sql_string ) ;
	return 1 ;
}

stock show_donate_halloween ( playerid )
{
	show_dialog ( playerid, d_donate_halloween, DIALOG_STYLE_TABLIST, "{"#cBHD"}Донат услуги", "\
							{"#cGRDialog"}- {"#cWH"}Пакет вампира\t{"#cGN"}500 "donate_title"\n\
							{"#cGRDialog"}- {"#cWH"}Пакет мертвеца\t{"#cGN"}1500 "donate_title"\n\
							{"#cGRDialog"}- {"#cWH"}Пакет дракулы\t{"#cGN"}3000 "donate_title"", "Выбрать", "Назад" ) ;
	return 1 ;
}

stock show_halloween_quest ( playerid )
{
    static const status_names [ ] [ ] =
	{
		"{"#cRD"}Не выполнен",
		"{"#cBL"}Выполняется",
		"{"#cGN"}Готово",
		"{"#cGN"}Выполнен"
	} ;

	global_string [ 0 ] = EOS ;
	new _quest_id = 0 ;
	for ( new k = 0 ; k < sizeof halloween_info ; k ++ )
	{
	    _quest_id ++ ;

		new line_string [ 64 + 26 ] ;
		if ( halloween_select [ playerid ] > k ) format ( line_string, sizeof ( line_string ), "{"#cBL"}%d. {"#cWH"}%s\t%s\n", _quest_id, halloween_info [ k ] [ q_name ], status_names [ 3 ] ) ;
	 	else if ( halloween_select [ playerid ] == k && halloween_status [ playerid ] == 1 ) format ( line_string, sizeof ( line_string ), "{"#cBL"}%d. {"#cWH"}%s\t%s\n", _quest_id, halloween_info [ k ] [ q_name ], status_names [ 1 ] ) ;
	 	else if ( halloween_select [ playerid ] == k && halloween_status [ playerid ] == 2 ) format ( line_string, sizeof ( line_string ), "{"#cBL"}%d. {"#cWH"}%s\t%s\n", _quest_id, halloween_info [ k ] [ q_name ], status_names [ 2 ] ) ;
	 	else format ( line_string, sizeof ( line_string ), "{"#cBL"}%d. {"#cWH"}%s\t%s\n", _quest_id, halloween_info [ k ] [ q_name ], status_names [ 0 ] ) ;
		strcat ( global_string, line_string ) ;
	}
	set_player_use_listitem ( playerid, _quest_id ) ;
	strcat ( global_string, "{"#cRD"}Отменить действующее задание" ) ;
	show_dialog ( playerid, d_halloween_list, DIALOG_STYLE_TABLIST, "{"#cBHD"}Задания", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock start_halloween_quest ( playerid )
{
	if ( halloween_select [ playerid ] == 0 )
	{
		SendClientMessage ( playerid, col_orange, !"Возьмите удобрение и отправляйтесь к могилам." ) ;
		
		is_halloween_progress { playerid } = 0 ;
		
		new _is_id = is_halloween_progress { playerid } ;
		SetPlayerRaceCheckpoint ( playerid, 1, halloween_area_grave [ _is_id ] [ 0 ], halloween_area_grave [ _is_id ] [ 1 ], halloween_area_grave [ _is_id ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
		is_gps_used { playerid } = 1 ;
	}
	else if ( halloween_select [ playerid ] == 1 )
	{
		SetPlayerRaceCheckpoint ( playerid, 1, position_zele [ 0 ], position_zele [ 1 ], position_zele [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
		is_gps_used { playerid } = 1 ;
	}
	else if ( halloween_select [ playerid ] == 2 )
	{
		is_halloween_progress { playerid } = 0 ;
		
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Тыквы разбросаны в районе кремля." ) ;
	}
	else if ( halloween_select [ playerid ] == 3 )
	{
		SetPlayerRaceCheckpoint ( playerid, 1, -2430.3847, 2683.9055, 39.6445, 0.0, 0.0, 0.0, 2.0 ) ;
		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
		is_gps_used { playerid } = 1 ;
	}
	return 1 ;
}

stock hw_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_halloween_list:
		{
			if ( ! response ) return 1 ;
			if ( listitem == get_player_use_listitem ( playerid ) )
			{
				if ( halloween_status [ playerid ] == 2 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не можете отменить задание, которое ожидает сдачи." ) ;
				halloween_status [ playerid ] = 0 ;
				halloween_progress [ playerid ] = 0 ;
				SendClientMessage ( playerid, col_succes, !"Задание успешно отменено." ) ;

				show_halloween_quest ( playerid ) ;
				return 1 ;
			}

			if ( listitem > 0 )
			{
			    if ( halloween_select [ playerid ] != listitem )
				{
					show_halloween_quest ( playerid ) ;

					return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не выполнили предыдущее задание." ) ;
				}
			}

			if ( halloween_select [ playerid ] > listitem )
			{
				show_halloween_quest ( playerid ) ;

				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Данное задание уже выполнено." ) ;
			}
			else if ( halloween_status [ playerid ] == 1 )
			{
				show_halloween_quest ( playerid ) ;

				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Это задание уже выполняется." ) ;
			}
			else if ( halloween_status [ playerid ] == 2 )
			{
			    halloween_progress [ playerid ] = 0 ;
				halloween_status [ playerid ] = 0 ;
				halloween_select [ playerid ] ++ ;
				SendClientMessage ( playerid, col_succes, !"Вы успешно сдали задание, награда получена!" ) ;

				give_money ( playerid, ( halloween_rewards [ listitem ] [ r_money ] * p_info [ playerid ] [ multiplication ] ) ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, ( halloween_rewards [ listitem ] [ r_money ] * p_info [ playerid ] [ multiplication ] ), "квест" ) ;
				rewards_exp ( playerid, halloween_rewards [ listitem ] [ r_exp ] ) ;

				update_halloween_data ( playerid ) ;
				return 1 ;
			}
			else
			{
				if ( halloween_status [ playerid ] != 0 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже выполняете какое-либо задание." ) ;

                new dialog_string [ 144 ] ;
				format ( dialog_string, sizeof dialog_string, "{"#cGRDialog"}Задание:\n{"#cWH"}%s\n\n{"#cGRDialog"}Награда:\n{"#cWH"}%s", halloween_info [ listitem ] [ q_text ], halloween_info [ listitem ] [ q_rewards ] ) ;
				show_dialog ( playerid, d_halloween_acept, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Задание", dialog_string, "Принять", "Назад" ) ;
				return 1 ;
			}
		}
		case d_halloween_acept:
		{
			if ( ! response )
			{
				show_halloween_quest ( playerid ) ;

				return clear_player_use_listitem ( playerid ) ;
			}
			clear_player_use_listitem ( playerid ) ;

			halloween_status [ playerid ] = 1 ;
			SendClientMessage ( playerid, col_succes, !"Вы успешно взяли задание, отправляйтесь на его выполнение." ) ;

			start_halloween_quest ( playerid ) ;
			update_halloween_data ( playerid ) ;
			return 1 ;
		}
		case d_donate_halloween:
		{
			if ( ! response ) return show_donate ( playerid ) ;
			
			if ( listitem == 0 )
			{
				show_dialog ( playerid, d_donate_hw, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
					{"#cGRDialog"}- {"#cWH"}Пакет вампира:\n\n\
					{"#cGRDialog"}Пакет вампира включает в себя:\n\
					\t{"#cGRDialog"}- {"#cWH"}BMW M5 F90\n\
					\t{"#cGRDialog"}- {"#cWH"}Аксессуар 'Маска Лектора'\n\
					\t{"#cGRDialog"}- {"#cWH"}100.000.000$\n\n\
					{"#cGRDialog"}* Цена: {"#cGN"}500 "donate_title"{"#cGRDialog"}.\n\
					{"#cGRDialog"}* Вы действительно хотите приобрести \"{"#cWH"}Пакет вампира{"#cGRDialog"}\"?","Принять", "Назад");
			}
			else if ( listitem == 1 )
			{
				show_dialog ( playerid, d_donate_hw, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
					{"#cGRDialog"}- {"#cWH"}Пакет мертвеца:\n\n\
					{"#cGRDialog"}Пакет мертвеца включает в себя:\n\
					\t{"#cGRDialog"}- {"#cWH"}Rolls Royce Cullinan\n\
					\t{"#cGRDialog"}- {"#cWH"}Аксессуар 'Маска Jason'\n\
					\t{"#cGRDialog"}- {"#cWH"}200.000.000$\n\n\
					{"#cGRDialog"}* Цена: {"#cGN"}1500 "donate_title"{"#cGRDialog"}.\n\
					{"#cGRDialog"}* Вы действительно хотите приобрести \"{"#cWH"}Пакет мертвеца{"#cGRDialog"}\"?","Принять", "Назад");
			}
			else if ( listitem == 2 )
			{
				show_dialog ( playerid, d_donate_hw, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
					{"#cGRDialog"}- {"#cWH"}Пакет дракулы:\n\n\
					{"#cGRDialog"}Пакет дракулы включает в себя:\n\
					\t{"#cGRDialog"}- {"#cWH"}Bugatti Divo\n\
					\t{"#cGRDialog"}- {"#cWH"}Mercedes-Benz 6x6\n\
					\t{"#cGRDialog"}- {"#cWH"}Аксессуар 'Маска Bane'\n\
					\t{"#cGRDialog"}- {"#cWH"}Аксессуар 'Маска PayDay'\n\
					\t{"#cGRDialog"}- {"#cWH"}500.000.000$\n\n\
					{"#cGRDialog"}* Цена: {"#cGN"}3000 "donate_title"{"#cGRDialog"}.\n\
					{"#cGRDialog"}* Вы действительно хотите приобрести \"{"#cWH"}Пакет дракулы{"#cGRDialog"}\"?","Принять", "Назад");
			}
			set_player_use_listitem ( playerid, listitem ) ;
			return 1 ;
		}
		case d_donate_hw:
		{
			if ( ! response ) return show_donate ( playerid ) ;
			
			static const _hw_price [ ] = { 500, 1500, 3000 } ;
			
			new _id = get_player_use_listitem ( playerid ) ;
			if ( ! get_player_donate ( playerid, _hw_price [ _id ], 2 ) )
			{
				if ( _id == 0 )
				{
					show_dialog ( playerid, d_donate_hw, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
						{"#cRD"}* У Вас недостаточно средств для приобретения данной услуги.\n\n\
						{"#cGRDialog"}- {"#cWH"}Пакет вампира:\n\n\
						{"#cGRDialog"}Пакет вампира включает в себя:\n\
						\t{"#cGRDialog"}- {"#cWH"}BMW M5 F90\n\
						\t{"#cGRDialog"}- {"#cWH"}Аксессуар 'Маска Лектора'\n\
						\t{"#cGRDialog"}- {"#cWH"}100.000.000$\n\n\
						{"#cGRDialog"}* Цена: {"#cGN"}500 "donate_title"{"#cGRDialog"}.\n\
						{"#cGRDialog"}* Вы действительно хотите приобрести \"{"#cWH"}Пакет вампира{"#cGRDialog"}\"?","Принять", "Назад");
				}
				else if ( _id == 1 )
				{
					show_dialog ( playerid, d_donate_hw, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
						{"#cRD"}* У Вас недостаточно средств для приобретения данной услуги.\n\n\
						{"#cGRDialog"}- {"#cWH"}Пакет мертвеца:\n\n\
						{"#cGRDialog"}Пакет мертвеца включает в себя:\n\
						\t{"#cGRDialog"}- {"#cWH"}Rolls Royce Cullinan\n\
						\t{"#cGRDialog"}- {"#cWH"}Аксессуар 'Маска Jason'\n\
						\t{"#cGRDialog"}- {"#cWH"}200.000.000$\n\n\
						{"#cGRDialog"}* Цена: {"#cGN"}1500 "donate_title"{"#cGRDialog"}.\n\
						{"#cGRDialog"}* Вы действительно хотите приобрести \"{"#cWH"}Пакет мертвеца{"#cGRDialog"}\"?","Принять", "Назад");
				}
				else if ( _id == 2 )
				{
					show_dialog ( playerid, d_donate_hw, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
						{"#cRD"}* У Вас недостаточно средств для приобретения данной услуги.\n\n\
						{"#cGRDialog"}- {"#cWH"}Пакет дракулы:\n\n\
						{"#cGRDialog"}Пакет дракулы включает в себя:\n\
						\t{"#cGRDialog"}- {"#cWH"}Bugatti Divo\n\
						\t{"#cGRDialog"}- {"#cWH"}Mercedes-Benz 6x6\n\
						\t{"#cGRDialog"}- {"#cWH"}Аксессуар 'Маска Bane'\n\
						\t{"#cGRDialog"}- {"#cWH"}Аксессуар 'Маска PayDay'\n\
						\t{"#cGRDialog"}- {"#cWH"}500.000.000$\n\n\
						{"#cGRDialog"}* Цена: {"#cGN"}3000 "donate_title"{"#cGRDialog"}.\n\
						{"#cGRDialog"}* Вы действительно хотите приобрести \"{"#cWH"}Пакет дракулы{"#cGRDialog"}\"?","Принять", "Назад");
				}
				return 1 ;
			}
			
			set_player_donate ( playerid, _hw_price [ _id ], 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _hw_price [ _id ], p_info [ playerid ] [ donate ], "(donate) halloween" ) ;
			
			if ( _id == 0 )
			{
				if ( p_info [ playerid ] [ max_veh ] == get_player_veh_count ( playerid ) )
				{
					p_info [ playerid ] [ max_veh ] ++ ;
					update_int_sql ( playerid, "u_maxveh", p_info [ playerid ] [ max_veh ] ) ;
				}
				
				veh_prise_create ( playerid, 0, 551 ) ;
				
				give_money ( playerid, 100_000_000 ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, 100_000_000, "halloween набор" ) ;
				
				give_player_item ( playerid, 10975 ) ;
			}
			else if ( _id == 1 )
			{
				if ( p_info [ playerid ] [ max_veh ] == get_player_veh_count ( playerid ) )
				{
					p_info [ playerid ] [ max_veh ] ++ ;
					update_int_sql ( playerid, "u_maxveh", p_info [ playerid ] [ max_veh ] ) ;
				}
				
				veh_prise_create ( playerid, 0, 558 ) ;
				
				give_money ( playerid, 200_000_000 ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, 200_000_000, "halloween набор" ) ;
				
				give_player_item ( playerid, 10973 ) ;
			}
			else if ( _id == 2 )
			{
				if ( p_info [ playerid ] [ max_veh ] == get_player_veh_count ( playerid ) )
				{
					p_info [ playerid ] [ max_veh ] += 2 ;
					update_int_sql ( playerid, "u_maxveh", p_info [ playerid ] [ max_veh ] ) ;
				}
				
				veh_prise_create ( playerid, 0, 3256 ) ;
				veh_prise_create ( playerid, 0, 489 ) ;
				
				give_money ( playerid, 500_000_000 ) ;
				insert_money_log ( playerid, INVALID_PLAYER_ID, 500_000_000, "halloween набор" ) ;
				
				give_player_item ( playerid, 10971 ) ;
				give_player_item ( playerid, 10982 ) ;
			}

			show_donate ( playerid ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Донат услуга успешно приобретена." ) ;
			return 1 ;
		}
	}
	return 0 ;
}