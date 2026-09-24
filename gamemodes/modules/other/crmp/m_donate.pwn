//ALTER TABLE `users` ADD `u_dp_time` INT(11) NOT NULL DEFAULT '0' AFTER `u_donate_payment`, ADD `u_dp_activated` INT(3) NOT NULL DEFAULT '0' AFTER `u_dp_time`; 
//CREATE TABLE `donate_action` (`started_promo_roulette` INT(3) NOT NULL DEFAULT '0' ) ENGINE = InnoDB;

#define auto_case_time (3600 * 15)
#define player_case_time (3600 * 7)
#define max_activated_auto 3

new promo_roulette_date = 0 ;
new started_promo_roulette = 0 ;
new donate_player_time [ MAX_PLAYERS ] ;
new donate_player_activated [ MAX_PLAYERS ] ;
new donate_player_case [ MAX_PLAYERS ] ;

CMD:daction ( playerid, params [ ] )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	if ( sscanf ( params, "d", params [ 0 ] ) ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте: /daction [дни]" ) ;
	
	if ( started_promo_roulette )
	{
		started_promo_roulette = 0 ;
		promo_roulette_date = 0 ;

		mysql_tquery ( sql_connection, "UPDATE `donate_action` SET `started_promo_roulette` = '0', `promo_roulette_date` = '0'" ) ;
		
		SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вы успешно отключили донат-акцию." ) ;
		return 1 ;
	}
	
	started_promo_roulette = 1 ;
	promo_roulette_date = SetElapsedTime ( gettime ( ), params [ 0 ], CONVERT_TIME_TO_DAYS ) ;
	
	foreach(new i: logged_players)
	{
		donate_player_time [ i ] =
		donate_player_activated [ i ] = 0 ;
	}
	
	mysql_tquery ( sql_connection, !"UPDATE `users` SET `u_dp_time` = '0', `u_dp_activated` = '0'" ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 128, "UPDATE `donate_action` SET `started_promo_roulette` = '%d', `promo_roulette_date` = '%d'", started_promo_roulette, promo_roulette_date ) ;
	mysql_tquery ( sql_connection, global_string ) ;
	
	SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вы успешно запустили донат-акцию." ) ;
	return 1 ;
}

stock donate_player_timer ( playerid, _count )
{
	if ( donate_player_case [ playerid ] > 0 )
	{
		if ( donate_player_time [ playerid ] + _count >= player_case_time && donate_player_time [ playerid ] < player_case_time )
		{
			donate_player_time [ playerid ] = 0 ;
				
			SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вы отыграли нужное количество времени." ) ;
				
			give_player_item_prise ( playerid, 45, 1 ) ;
			SendClientMessage ( playerid, col_yellow, !"* Вам был добавлен предмет 'Bronze рулетка'. Откройте инвентарь, используйте /mm или радиальное меню." ) ;
			
			donate_OnPlayerDisconnect ( playerid, 2 ) ;
		}
		else
		{
			donate_player_time [ playerid ] += _count ;
		}
	}
	else if ( started_promo_roulette )
	{
		if ( donate_player_activated [ playerid ] < max_activated_auto )
		{
			if ( donate_player_time [ playerid ] + _count >= auto_case_time && donate_player_time [ playerid ] < auto_case_time )
			{
				donate_player_time [ playerid ] = 0 ;
				
				SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вы отыграли нужное количество времени." ) ;
				
				if ( donate_player_activated [ playerid ] == 0 )
				{
					give_player_item_prise ( playerid, 45, 1 ) ;
					SendClientMessage ( playerid, col_yellow, !"* Вам был добавлен предмет 'Bronze рулетка'. Откройте инвентарь, используйте /mm или радиальное меню." ) ;
				}
				else if ( donate_player_activated [ playerid ] == 1 )
				{
					give_player_item_prise ( playerid, 55, 1 ) ;
					SendClientMessage ( playerid, col_yellow, !"* Вам был добавлен предмет 'Bronze рулетка'. Откройте инвентарь, используйте /mm или радиальное меню." ) ;
				}
				else if ( donate_player_activated [ playerid ] == 2 )
				{
					give_player_item_prise ( playerid, 125, 1 ) ;
					SendClientMessage ( playerid, col_yellow, !"* Вам был добавлен предмет 'Bronze рулетка'. Откройте инвентарь, используйте /mm или радиальное меню." ) ;
				}
				
				donate_player_activated [ playerid ] ++ ;
				donate_OnPlayerDisconnect ( playerid, 2 ) ;
			}
			else
			{
				donate_player_time [ playerid ] += _count ;
			}
		}
	}
	return 1 ;
}

stock donate_OnPlayerDisconnect ( playerid, _type = 0 )
{
	if ( donate_player_case [ playerid ] > 0 )
	{
		if ( _type == 2 ) donate_player_case [ playerid ] -= 1 ;

		global_string [ 0 ] = EOS ;
		format ( global_string, 144, "UPDATE `users` SET `u_dp_time` = '%d', `u_dp_activated` = '%d', `u_dp_case` = '%d' WHERE `u_id` = '%d' LIMIT 1",
		donate_player_time [ playerid ], donate_player_activated [ playerid ], donate_player_case [ playerid ], p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, global_string ) ;
	}
	else if ( started_promo_roulette )
	{
		if ( _type == 2 || donate_player_activated [ playerid ] < max_activated_auto )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "UPDATE `users` SET `u_dp_time` = '%d', `u_dp_activated` = '%d' WHERE `u_id` = '%d' LIMIT 1",
			donate_player_time [ playerid ], donate_player_activated [ playerid ], p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, global_string ) ;
		}
	}
	return 1 ;
}

stock donate_OnPlayerSpawn ( playerid )
{
	if ( donate_player_case [ playerid ] > 0 )
	{
		SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Запущена уникальная акция: отыгрывай и забирай рулетку удачи!" ) ;
		SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Всё очень просто: проводи время в игре и рулетку удачи! {"#cBL"}(/acase)" ) ;
		SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Также используйте {"#cBL"}/acase {"#cWH"}для просмотра детальной информации." ) ;
	}
	else if ( started_promo_roulette )
	{
		if ( donate_player_activated [ playerid ] < max_activated_auto )
		{
			SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Запущена уникальная акция: отыгрывай и забирай рулетку удачи!" ) ;
			SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Всё очень просто: проводи время в игре и рулетку удачи! {"#cBL"}(/acase)" ) ;
			SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Также используйте {"#cBL"}/acase {"#cWH"}для просмотра детальной информации." ) ;
		}
	}
	return 1 ;
}

CMD:acase ( playerid )
{
	if ( donate_player_case [ playerid ] > 0 )
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, 700, "{"#cBL"}** Рулетка **\n\n\
									{"#cWH"}Рулетка содержит в себе самые уникальные предметы.\n\
									Подбор предметов начинается от самых простых и заканчивается теми,\n\
									которые никогда и нигде не появлялись в игре.\n\n\
									{"#cBL"}** Как получить **\n\n\
									{"#cLY"}1. {"#cWH"}Вы можете приобрести часы в /donate и забрать его быстрее.\n\
									{"#cLY"}2. {"#cWH"}Вам нужно отыграть {"#cLY"}15 часов {"#cWH"}и тогда Вам откроется возможность его получить.\n\n\
									Вы отыграли: {"#cBL"}%d сек.{"#cWH"}\n\
									Нужно отыграть: {"#cBL"}%d сек.{"#cWH"}\n\
									Вы получили рулеток: {"#cBL"}%d шт. из 1 шт.{"#cWH"}\n\n\
									{"#cGRDialog"}* Учёт времени идёт за каждую минуту проведённую в игре.", 
		donate_player_time [ playerid ], player_case_time, donate_player_activated [ playerid ] ) ;
		show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Авто-кейс", global_string, "Закрыть", "" ) ;
	}
	else if ( started_promo_roulette )
	{
		if ( donate_player_activated [ playerid ] < max_activated_auto )
		{
			new s_year, s_month, s_day, s_hour, s_minute, s_second ;
			timestamp_to_date ( promo_roulette_date + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;

			global_string [ 0 ] = EOS ;
			if ( player_device { playerid } != 2 )
			{
				format ( global_string, 700, "{"#cBL"}** Рулетка **\n\n\
											{"#cWH"}Рулетка содержит в себе самые уникальные предметы.\n\
											Подбор предметов начинается от самых простых и заканчивается теми,\n\
											которые никогда и нигде не появлялись в игре.\n\n\
											{"#cBL"}** Как получить **\n\n\
											{"#cLY"}1. {"#cWH"}Вы можете приобрести часы в /donate и забрать его быстрее.\n\
											{"#cLY"}2. {"#cWH"}Вам нужно отыграть {"#cLY"}15 часов {"#cWH"}и тогда Вам откроется возможность его получить.\n\n\
											Вы отыграли: {"#cBL"}%s{"#cWH"}\n\
											Нужно отыграть: {"#cBL"}%s{"#cWH"}\n\
											Вы получили рулеток: {"#cBL"}%d шт. из %d шт.{"#cWH"}\n\n\
											Рулетка до {"#cLY"}%02d.%02d.%d{"#cWH"} включительно.", 
				convert_time ( donate_player_time [ playerid ], TYPE_TIME_HOUR ), convert_time ( auto_case_time, TYPE_TIME_HOUR ), donate_player_activated [ playerid ], max_activated_auto,
				s_day, s_month, s_year ) ;
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Авто-кейс", global_string, "Закрыть", "" ) ;
			}
			else if ( player_device { playerid } == 2 )
			{
				format ( global_string, 700, "{"#cWH"}Рулетка содержит в себе самые уникальные предметы.\n\
											Подбор предметов начинается от самых простых и заканчивается теми,\n\
											которые никогда и нигде не появлялись в игре.\n\n\
											{"#cBL"}** Как получить **\n\n\
											{"#cLY"}1. {"#cWH"}Вы можете приобрести часы в /donate и забрать его быстрее.\n\
											{"#cLY"}2. {"#cWH"}Вам нужно отыграть {"#cLY"}15 часов {"#cWH"}и тогда Вам откроется возможность его получить.\n\n\
											Вы отыграли: {"#cBL"}%s{"#cWH"}\n\
											Нужно отыграть: {"#cBL"}%s{"#cWH"}\n\
											Вы получили рулеток: {"#cBL"}%d шт. из %d шт.{"#cWH"}\n\n\
											Рулетка до {"#cLY"}%02d.%02d.%d{"#cWH"} включительно.", 
				convert_time ( donate_player_time [ playerid ], TYPE_TIME_HOUR ), convert_time ( auto_case_time, TYPE_TIME_HOUR ), donate_player_activated [ playerid ], max_activated_auto,
				s_day, s_month, s_year ) ;
				
				new _str [ 34 ] ;
				if ( donate_player_time [ playerid ] >= auto_case_time ) format ( _str, sizeof _str, "Можно забрать! /donate - кейсы", convert_time ( auto_case_time - donate_player_time [ playerid ], TYPE_TIME_HOUR ) ) ;
				else format ( _str, sizeof _str, "%s до получения", convert_time ( auto_case_time - donate_player_time [ playerid ], TYPE_TIME_HOUR ) ) ;
				SendNotyDialog ( playerid, global_string, _str, "Принять", "", "Рулетка" ) ;
				SendNotyImage ( playerid, "case_new_cars" ) ;
			}
		}
		else
		{
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже получили рулетку!" ) ;
		}
	}
	return 1 ;
}

enum
{
	d_c_donate_vipgold = 37777,
	d_c_donate_case,
	d_c_donate_case_1,
	d_donate_casket,
	d_donate_buy,
	d_donate_buy_1
} ;

enum _donate_category
{
	dc_name [ 24 ],
	dc_icon
} ;

#define MAX_DONATE_CATEGORY 12
new donate_category [ MAX_DONATE_CATEGORY ] [ _donate_category ] =
{
	{ "Акции", 1 },
	{ "Одежда", 11 },
	{ "Эконом", 13 },
	{ "Средний", 13 },
	{ "Бизнес", 13 },
	{ "Аксессуары", 8 },
	{ "Кейсы", 2 },
	{ "Валюта", 3 },
	{ "Прочее", 0 },
	{ "Бонусный счёт", 0 },
	{ "Наборы", 7 },
	{ "Музыка", 9 }
} ;

enum _donate_list
{
	HierarchyID,
	getInternalID,
	d_Name [ 48 ],
	Subname [ 32 ],
	Type,
	ModelId,
	Color1,
	Color2,
	Cost,
	OldCost,
	ItemBG
} ;

new donate_list_count [ ] = { 69, 21, 39, 31, 39, 6, 2, 23, 11, 7, 3 } ;

new donate_list [ ] [ _donate_list ] =
{
	// skins
	/*{ 1, 1, "Skin 1", " ", 2, 84, 1, 1, 250, 0, 0 },
	{ 1, 2, "Skin 1", " ", 2, 105, 1, 1, 250, 0, 0 },
	{ 1, 3, "Skin 1", " ", 2, 106, 1, 1, 250, 0, 0 },
	{ 1, 4, "Skin 1", " ", 2, 109, 1, 1, 250, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 110, 1, 1, 250, 0, 0 },
	{ 1, 6, "Skin 1", " ", 2, 64, 1, 1, 400, 0, 0 },
	{ 1, 7, "Skin 1", " ", 2, 33, 1, 1, 400, 0, 0 },
	{ 1, 8, "Skin 1", " ", 2, 45, 1, 1, 400, 0, 0 },
	{ 1, 9, "Skin 1", " ", 2, 47, 1, 1, 400, 0, 0 },
	{ 1, 10, "Skin 1", " ", 2, 77, 1, 1, 400, 0, 0 },
	{ 1, 11, "Skin 1", " ", 2, 178, 1, 1, 400, 0, 0 },
	{ 1, 12, "Skin 1", " ", 2, 180, 1, 1, 400, 0, 0 },
	{ 1, 13, "Skin 1", " ", 2, 300, 1, 1, 600, 0, 0 },
	{ 1, 14, "Skin 1", " ", 2, 303, 1, 1, 600, 0, 0 },
	{ 1, 15, "Skin 1", " ", 2, 310, 1, 1, 600, 0, 0 },
	{ 1, 16, "Skin 1", " ", 2, 311, 1, 1, 250, 0, 0 },
	{ 1, 17, "Skin 1", " ", 2, 10, 1, 1, 400, 0, 0 },
	{ 1, 18, "Skin 1", " ", 2, 130, 1, 1, 400, 0, 0 },
	{ 1, 19, "Skin 1", " ", 2, 139, 1, 1, 400, 0, 0 },
	{ 1, 20, "Skin 1", " ", 2, 145, 1, 1, 400, 0, 0 },*/
	{ 1, 1, "Skin 1", " ", 2, 313, 1, 1, 750, 0, 0 },
	{ 1, 2, "Skin 1", " ", 2, 314, 1, 1, 750, 0, 0 },
	{ 1, 3, "Skin 1", " ", 2, 318, 1, 1, 400, 0, 0 },
	{ 1, 4, "Skin 1", " ", 2, 4507, 1, 1, 400, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 4521, 1, 1, 1500, 0, 0 },
	{ 1, 6, "Skin 1", " ", 2, 4522, 1, 1, 300, 0, 0 },
	{ 1, 7, "Skin 1", " ", 2, 4523, 1, 1, 300, 0, 0 },
	{ 1, 8, "Skin 1", " ", 2, 4524, 1, 1, 1500, 0, 0 },
	{ 1, 9, "Skin 1", " ", 2, 4529, 1, 1, 2000, 0, 0 },
	{ 1, 10, "Skin 1", " ", 2, 4530, 1, 1, 2500, 0, 0 },
	{ 1, 11, "Skin 1", " ", 2, 4531, 1, 1, 500, 0, 0 },
	{ 1, 12, "Skin 1", " ", 2, 4532, 1, 1, 2000, 0, 0 },
	{ 1, 13, "Skin 1", " ", 2, 4533, 1, 1, 500, 0, 0 },
	{ 1, 14, "Skin 1", " ", 2, 4534, 1, 1, 2500, 0, 0 },
	{ 1, 15, "Skin 1", " ", 2, 4544, 1, 1, 2500, 0, 0 },
	{ 1, 16, "Skin 1", " ", 2, 118, 1, 1, 1000, 0, 0 },
	{ 1, 17, "Skin 1", " ", 2, 144, 1, 1, 1500, 0, 0 },
	{ 1, 18, "Skin 1", " ", 2, 4545, 1, 1, 1000, 0, 0 },
	{ 1, 19, "Skin 1", " ", 2, 4546, 1, 1, 1000, 0, 0 },
	{ 1, 20, "Skin 1", " ", 2, 4547, 1, 1, 1000, 0, 0 },
	{ 1, 21, "Skin 1", " ", 2, 4548, 1, 1, 1000, 0, 0 },
	{ 1, 22, "Skin 1", " ", 2, 4549, 1, 1, 1000, 0, 0 },
	{ 1, 23, "Skin 1", " ", 2, 4550, 1, 1, 3000, 0, 0 },
	{ 1, 24, "Skin 1", " ", 2, 4556, 1, 1, 2500, 0, 0 },
	{ 1, 25, "Skin 1", " ", 2, 4572, 1, 1, 2000, 0, 0 },
	{ 1, 26, "Skin 1", " ", 2, 4575, 1, 1, 700, 0, 0 },
	{ 1, 27, "Skin 1", " ", 2, 4576, 1, 1, 1000, 0, 0 },
	//{ 1, 28, "Skin 1", " ", 2, 4590, 1, 1, 600, 0, 0 },
	//{ 1, 29, "Skin 1", " ", 2, 4591, 1, 1, 600, 0, 0 },
	//{ 1, 30, "Skin 1", " ", 2, 4593, 1, 1, 800, 0, 0 },
	{ 1, 28, "Skin 1", " ", 2, 4597, 1, 1, 1500, 0, 0 },
	{ 1, 29, "Skin 1", " ", 2, 4598, 1, 1, 1000, 0, 0 },
	{ 1, 30, "Skin 1", " ", 2, 4605, 1, 1, 1000, 0, 0 },
	{ 1, 31, "Skin 1", " ", 2, 4606, 1, 1, 500, 0, 0 },
	{ 1, 32, "Skin 1", " ", 2, 4607, 1, 1, 2000, 0, 0 },
	{ 1, 33, "Skin 1", " ", 2, 4608, 1, 1, 1500, 0, 0 },
	{ 1, 34, "Skin 1", " ", 2, 4609, 1, 1, 700, 0, 0 },
	{ 1, 35, "Skin 1", " ", 2, 4611, 1, 1, 800, 0, 0 },
	{ 1, 36, "Skin 1", " ", 2, 4612, 1, 1, 1500, 0, 0 },
	{ 1, 37, "Skin 1", " ", 2, 4613, 1, 1, 1500, 0, 0 },
	{ 1, 38, "Skin 1", " ", 2, 4614, 1, 1, 1500, 0, 0 },
	{ 1, 39, "Skin 1", " ", 2, 4622, 1, 1, 500, 0, 0 },
	//{ 1, 40, "Skin 1", " ", 2, 4630, 1, 1, 500, 0, 0 },
	//{ 1, 41, "Skin 1", " ", 2, 4635, 1, 1, 300, 0, 0 },
	{ 1, 40, "Skin 1", " ", 2, 4636, 1, 1, 5000, 0, 0 },
	{ 1, 41, "Skin 1", " ", 2, 4637, 1, 1, 1000, 0, 0 },
	{ 1, 42, "Skin 1", " ", 2, 4641, 1, 1, 1500, 0, 0 },
	{ 1, 43, "Skin 1", " ", 2, 4642, 1, 1, 2500, 0, 0 },
	{ 1, 44, "Skin 1", " ", 2, 4644, 1, 1, 1500, 0, 0 },
	{ 1, 45, "Skin 1", " ", 2, 4645, 1, 1, 2000, 0, 0 },
	{ 1, 46, "Skin 1", " ", 2, 4650, 1, 1, 2000, 0, 0 },
	{ 1, 47, "Skin 1", " ", 2, 4651, 1, 1, 700, 0, 0 },
	{ 1, 48, "Skin 1", " ", 2, 4655, 1, 1, 1500, 0, 0 },
	{ 1, 49, "Skin 1", " ", 2, 4657, 1, 1, 4000, 0, 0 },
	{ 1, 50, "Skin 1", " ", 2, 4658, 1, 1, 3000, 0, 0 },
	{ 1, 51, "Skin 1", " ", 2, 4660, 1, 1, 2000, 0, 0 },
	{ 1, 52, "Skin 1", " ", 2, 4663, 1, 1, 2000, 0, 0 },
	{ 1, 53, "Skin 1", " ", 2, 4664, 1, 1, 1000, 0, 0 },
	{ 1, 54, "Skin 1", " ", 2, 4665, 1, 1, 1000, 0, 0 },
	{ 1, 55, "Skin 1", " ", 2, 4683, 1, 1, 1000, 0, 0 },
	{ 1, 56, "Skin 1", " ", 2, 4692, 1, 1, 4000, 0, 0 },
	{ 1, 57, "Skin 1", " ", 2, 4693, 1, 1, 3000, 0, 0 },
	
	{ 1, 58, "Skin 1", " ", 2, 4699, 1, 1, 10000, 0, 0 },
	{ 1, 59, "Skin 1", " ", 2, 4705, 1, 1, 1000, 0, 0 },
	{ 1, 60, "Skin 1", " ", 2, 4706, 1, 1, 1000, 0, 0 },
	{ 1, 61, "Skin 1", " ", 2, 4707, 1, 1, 1000, 0, 0 },
	{ 1, 62, "Skin 1", " ", 2, 4709, 1, 1, 10000, 0, 0 },
	{ 1, 63, "Skin 1", " ", 2, 4710, 1, 1, 15000, 0, 0 },
	{ 1, 64, "Skin 1", " ", 2, 4714, 1, 1, 5000, 0, 0 },
	
	{ 1, 65, "Skin 1", " ", 2, 4734, 1, 1, 5000, 0, 0 },
	{ 1, 66, "Skin 1", " ", 2, 4736, 1, 1, 5000, 0, 0 },
	{ 1, 67, "Skin 1", " ", 2, 4741, 1, 1, 2500, 0, 0 },
	{ 1, 68, "Skin 1", " ", 2, 4743, 1, 1, 1000, 0, 0 },
	{ 1, 69, "Skin 1", " ", 2, 4744, 1, 1, 1000, 0, 0 },

	// vehicles eco
	{ 2, 1, "Skin 1", " ", 1, 491, 1, 1, 850, 0, 0 },
	{ 2, 2, "Skin 1", " ", 1, 551, 1, 1, 850, 0, 0 },
	{ 2, 3, "Skin 1", " ", 1, 409, 1, 1, 850, 0, 0 },
	{ 2, 4, "Skin 1", " ", 1, 565, 1, 1, 900, 0, 0 },
	{ 2, 5, "Skin 1", " ", 1, 3233, 1, 1, 500, 0, 0 },
	{ 2, 6, "Skin 1", " ", 1, 3234, 1, 1, 300, 0, 0 },
	{ 2, 7, "Skin 1", " ", 1, 3247, 1, 1, 300, 0, 0 },
	{ 2, 8, "Skin 1", " ", 1, 3255, 1, 1, 300, 0, 0 },
	{ 2, 9, "Skin 1", " ", 1, 3252, 1, 1, 850, 0, 0 },
	{ 2, 10, "Skin 1", " ", 1, 3267, 1, 1, 850, 0, 0 },
	{ 2, 11, "Skin 1", " ", 1, 3268, 1, 1, 850, 0, 0 },
	{ 2, 12, "Skin 1", " ", 1, 3273, 1, 1, 850, 0, 0 },
	{ 2, 13, "Skin 1", " ", 1, 3279, 1, 1, 500, 0, 0 },
	{ 2, 14, "Skin 1", " ", 1, 3299, 1, 1, 500, 0, 0 },
	{ 2, 15, "Skin 1", " ", 1, 3308, 1, 1, 500, 0, 0 },
	{ 2, 16, "Skin 1", " ", 1, 3310, 1, 1, 500, 0, 0 },
	{ 2, 17, "Skin 1", " ", 1, 3312, 1, 1, 700, 0, 0 },
	{ 2, 18, "Skin 1", " ", 1, 513, 1, 1, 800, 0, 0 },
	{ 2, 19, "Skin 1", " ", 1, 593, 1, 1, 800, 0, 0 },
	{ 2, 20, "Skin 1", " ", 1, 3344, 1, 1, 500, 0, 0 },
	{ 2, 21, "Skin 1", " ", 1, 3353, 1, 1, 800, 0, 0 },

	// vehicles mid
	{ 3, 1, "Skin 1", " ", 1, 411, 1, 1, 2200, 0, 0 },
	{ 3, 2, "Skin 1", " ", 1, 415, 1, 1, 1200, 0, 0 },
	{ 3, 3, "Skin 1", " ", 1, 419, 1, 1, 1200, 0, 0 },
	{ 3, 4, "Skin 1", " ", 1, 489, 1, 1, 2800, 0, 0 },
	{ 3, 5, "Skin 1", " ", 1, 541, 1, 1, 1200, 0, 0 },
	{ 3, 6, "Skin 1", " ", 1, 543, 1, 1, 1800, 0, 0 },
	{ 3, 7, "Skin 1", " ", 1, 558, 1, 1, 1000, 0, 0 },
	{ 3, 8, "Skin 1", " ", 1, 603, 1, 1, 1200, 0, 0 },
	{ 3, 9, "Skin 1", " ", 1, 545, 1, 1, 1200, 0, 0 },
	{ 3, 10, "Skin 1", " ", 1, 434, 1, 1, 2200, 0, 0 },
	//{ 3, 11, "Skin 1", " ", 1, 504, 1, 1, 1200, 0, 0 },
	{ 3, 11, "Skin 1", " ", 1, 490, 1, 1, 1800, 0, 0 },
	{ 3, 12, "Skin 1", " ", 1, 3250, 1, 1, 1200, 0, 0 },
	{ 3, 13, "Skin 1", " ", 1, 3260, 1, 1, 1500, 0, 0 },
	{ 3, 14, "Skin 1", " ", 1, 3261, 1, 1, 1800, 0, 0 },
	{ 3, 15, "Skin 1", " ", 1, 3262, 1, 1, 1200, 0, 0 },
	{ 3, 16, "Skin 1", " ", 1, 3263, 1, 1, 1500, 0, 0 },
	{ 3, 17, "Skin 1", " ", 1, 3264, 1, 1, 1200, 0, 0 },
	{ 3, 18, "Skin 1", " ", 1, 3271, 1, 1, 1000, 0, 0 },
	{ 3, 19, "Skin 1", " ", 1, 3274, 1, 1, 2000, 0, 0 },
	{ 3, 20, "Skin 1", " ", 1, 3281, 1, 1, 1000, 0, 0 },
	{ 3, 21, "Skin 1", " ", 1, 3284, 1, 1, 2000, 0, 0 },
	{ 3, 22, "Skin 1", " ", 1, 3286, 1, 1, 1500, 0, 0 },
	{ 3, 23, "Skin 1", " ", 1, 3287, 1, 1, 1500, 0, 0 },
	{ 3, 24, "Skin 1", " ", 1, 3288, 1, 1, 1500, 0, 0 },
	{ 3, 25, "Skin 1", " ", 1, 3291, 1, 1, 2000, 0, 0 },
	{ 3, 26, "Skin 1", " ", 1, 3293, 1, 1, 1200, 0, 0 },
	{ 3, 27, "Skin 1", " ", 1, 3302, 1, 1, 1200, 0, 0 },
	{ 3, 28, "Skin 1", " ", 1, 3304, 1, 1, 2000, 0, 0 },
	{ 3, 29, "Skin 1", " ", 1, 3306, 1, 1, 2000, 0, 0 },
	{ 3, 30, "Skin 1", " ", 1, 3319, 1, 1, 1200, 0, 0 },
	{ 3, 31, "Skin 1", " ", 1, 3331, 1, 1, 1400, 0, 0 },
	{ 3, 32, "Skin 1", " ", 1, 469, 1, 1, 1500, 0, 0 },
	{ 3, 33, "Skin 1", " ", 1, 447, 1, 1, 2000, 0, 0 },
	{ 3, 34, "Skin 1", " ", 1, 3334, 1, 1, 1000, 0, 0 },
	{ 3, 35, "Skin 1", " ", 1, 3348, 1, 1, 1300, 0, 0 },
	{ 3, 36, "Skin 1", " ", 1, 3355, 1, 1, 1500, 0, 0 },
	{ 3, 37, "Skin 1", " ", 1, 3361, 1, 1, 1300, 0, 0 },
	{ 3, 38, "Skin 1", " ", 1, 3381, 1, 1, 2500, 0, 0 },
	{ 3, 39, "Skin 1", " ", 1, 3382, 1, 1, 2500, 0, 0 },

	// vehicles high
	{ 4, 1, "Skin 1", " ", 1, 3256, 1, 1, 3000, 0, 0 },
	{ 4, 2, "Skin 1", " ", 1, 3275, 1, 1, 3000, 0, 0 },
	{ 4, 3, "Skin 1", " ", 1, 3265, 1, 1, 3000, 0, 0 },
	{ 4, 4, "Skin 1", " ", 1, 3277, 1, 1, 3000, 0, 0 },
	{ 4, 5, "Skin 1", " ", 1, 3282, 1, 1, 3000, 0, 0 },
	{ 4, 6, "Skin 1", " ", 1, 444, 1, 1, 5000, 0, 0 },
	{ 4, 7, "Skin 1", " ", 1, 495, 1, 1, 3000, 0, 0 },
	{ 4, 8, "Skin 1", " ", 1, 596, 1, 1, 3000, 0, 0 },
	{ 4, 9, "Skin 1", " ", 1, 597, 1, 1, 3000, 0, 0 },
	{ 4, 10, "Skin 1", " ", 1, 598, 1, 1, 3000, 0, 0 },
	{ 4, 11, "Skin 1", " ", 1, 3295, 1, 1, 3000, 0, 0 },
	{ 4, 12, "Skin 1", " ", 1, 3296, 1, 1, 5000, 0, 0 },
	{ 4, 13, "Skin 1", " ", 1, 3297, 1, 1, 3000, 0, 0 },
	{ 4, 14, "Skin 1", " ", 1, 3298, 1, 1, 3000, 0, 0 },
	{ 4, 15, "Skin 1", " ", 1, 3313, 1, 1, 5000, 0, 0 },
	{ 4, 16, "Skin 1", " ", 1, 3316, 1, 1, 5000, 0, 0 },
	{ 4, 17, "Skin 1", " ", 1, 3317, 1, 1, 5000, 0, 0 },
	{ 4, 18, "Skin 1", " ", 1, 3332, 1, 1, 3000, 0, 0 },
	{ 4, 19, "Skin 1", " ", 1, 487, 1, 1, 3000, 0, 0 },
	{ 4, 20, "Skin 1", " ", 1, 3336, 1, 1, 3000, 0, 0 },
	{ 4, 21, "Skin 1", " ", 1, 3347, 1, 1, 3000, 0, 0 },
	{ 4, 22, "Skin 1", " ", 1, 3349, 1, 1, 3000, 0, 0 },
	{ 4, 23, "Skin 1", " ", 1, 3354, 1, 1, 3000, 0, 0 },
	{ 4, 24, "Skin 1", " ", 1, 3359, 1, 1, 3000, 0, 0 },
	{ 4, 25, "Skin 1", " ", 1, 3362, 1, 1, 3000, 0, 0 },
	{ 4, 26, "Skin 1", " ", 1, 3363, 1, 1, 4000, 0, 0 },
	{ 4, 27, "Skin 1", " ", 1, 3377, 1, 1, 7000, 0, 0 },
	{ 4, 28, "Skin 1", " ", 1, 3378, 1, 1, 7000, 0, 0 },
	{ 4, 29, "Skin 1", " ", 1, 3369, 1, 1, 7000, 0, 0 },
	{ 4, 30, "Skin 1", " ", 1, 3370, 1, 1, 5000, 0, 0 },
	{ 4, 31, "Skin 1", " ", 1, 3386, 1, 1, 10000, 0, 0 },
	
	// accesories
	{ 5, 1, "Skin 1", " ", 0, 12080, 1, 1, 900, 0, 0 },
	{ 5, 2, "Skin 1", " ", 0, 12081, 1, 1, 900, 0, 0 },
	{ 5, 3, "Skin 1", " ", 0, 12082, 1, 1, 900, 0, 0 },
	{ 5, 4, "Skin 1", " ", 0, 12617, 1, 1, 500, 0, 0 },
	{ 5, 5, "Skin 1", " ", 0, 12619, 1, 1, 500, 0, 0 },
	{ 5, 6, "Skin 1", " ", 0, 12620, 1, 1, 500, 0, 0 },
	{ 5, 7, "Skin 1", " ", 0, 12621, 1, 1, 500, 0, 0 },
	{ 5, 8, "Skin 1", " ", 0, 12622, 1, 1, 500, 0, 0 },
	{ 5, 9, "Skin 1", " ", 0, 12640, 1, 1, 750, 0, 0 },
	{ 5, 10, "Skin 1", " ", 0, 12651, 1, 1, 1000, 0, 0 },
	{ 5, 11, "Skin 1", " ", 0, 12659, 1, 1, 1000, 0, 0 },
	{ 5, 12, "Skin 1", " ", 0, 12660, 1, 1, 1000, 0, 0 },
	{ 5, 13, "Skin 1", " ", 0, 12662, 1, 1, 1000, 0, 0 },
	{ 5, 14, "Skin 1", " ", 0, 12664, 1, 1, 1000, 0, 0 },
	{ 5, 15, "Skin 1", " ", 0, 12665, 1, 1, 1000, 0, 0 },
	{ 5, 16, "Skin 1", " ", 0, 12657, 1, 1, 500, 0, 0 },
	{ 5, 17, "Skin 1", " ", 0, 12668, 1, 1, 500, 0, 0 },
	{ 5, 18, "Skin 1", " ", 0, 11767, 1, 1, 1000, 0, 0 },
	{ 5, 19, "Skin 1", " ", 0, 11768, 1, 1, 1000, 0, 0 },
	{ 5, 20, "Skin 1", " ", 0, 11769, 1, 1, 1000, 0, 0 },
	{ 5, 21, "Skin 1", " ", 0, 11770, 1, 1, 1000, 0, 0 },
	{ 5, 22, "Skin 1", " ", 0, 11906, 1, 1, 500, 0, 0 },
	{ 5, 23, "Skin 1", " ", 0, 11907, 1, 1, 500, 0, 0 },
	{ 5, 24, "Skin 1", " ", 0, 11911, 1, 1, 1000, 0, 0 },
	{ 5, 25, "Skin 1", " ", 0, 8105, 1, 1, 1500, 0, 0 },
	{ 5, 26, "Skin 1", " ", 0, 8106, 1, 1, 1500, 0, 0 },
	{ 5, 27, "Skin 1", " ", 0, 8107, 1, 1, 1500, 0, 0 },
	{ 5, 28, "Skin 1", " ", 0, 8200, 1, 1, 4000, 0, 0 },
	{ 5, 29, "Skin 1", " ", 0, 8218, 1, 1, 4000, 0, 0 },
	{ 5, 30, "Skin 1", " ", 0, 8219, 1, 1, 4000, 0, 0 },
	{ 5, 31, "Skin 1", " ", 0, 8250, 1, 1, 4000, 0, 0 },
	{ 5, 32, "Skin 1", " ", 0, 8253, 1, 1, 4000, 0, 0 },
	{ 5, 33, "Skin 1", " ", 0, 8208, 1, 1, 1000, 0, 0 },
	{ 5, 34, "Skin 1", " ", 0, 8214, 1, 1, 1000, 0, 0 },
	{ 5, 35, "Skin 1", " ", 0, 8224, 1, 1, 10000, 0, 0 },
	{ 5, 36, "Skin 1", " ", 0, 8225, 1, 1, 10000, 0, 0 },
	{ 5, 37, "Skin 1", " ", 0, 5056, 1, 1, 5000, 0, 0 },
	{ 5, 38, "Skin 1", " ", 0, 5065, 1, 1, 5000, 0, 0 },
	{ 5, 39, "Skin 1", " ", 0, 5067, 1, 1, 5000, 0, 0 },

	// case
	{ 6, 1, "Bronze", " ", -1, 190, 1, 1, 200, 0, 0 },
	{ 6, 2, "Silver", " ", -1, 191, 1, 1, 400, 0, 0 },
	{ 6, 3, "Gold", " ", -1, 192, 1, 1, 800, 0, 0 },
	{ 6, 4, "Ларец Fortnite", " ", -1, 168, 1, 1, 400, 0, 0 },
	{ 6, 5, "Ларец Star Wars", " ", -1, 169, 1, 1, 200, 0, 0 },
	{ 6, 6, "Ларец Zombie", " ", -1, 170, 1, 1, 250, 0, 0 },
	
	// case
	{ 7, 1, "Рубли", " ", -1, 22, 1, 1, 40000, 0, 0 },
	{ 7, 2, ""family_title"", " ", -1, 22, 1, 1, 4, 0, 0 },
	
	// other
	{ 8, 1, "Права адм. 1 ур.", " ", -1, 55, 1, 1, 550, 0, 0 },
	{ 8, 2, "Права адм. 2 ур.", " ", -1, 55, 1, 1, 700, 0, 0 },
	{ 8, 3, "Права адм. 3 ур.", " ", -1, 55, 1, 1, 850, 0, 0 },
	{ 8, 4, "Права адм. 4 ур.", " ", -1, 55, 1, 1, 2200, 0, 0 },
	{ 8, 5, "Права адм. 5 ур.", " ", -1, 55, 1, 1, 3600, 0, 0 },
	{ 8, 6, "Права адм. 6 ур.", " ", -1, 55, 1, 1, 7000, 0, 0 },
	{ 8, 7, "VIP 'Bronze'", " ", -1, 30, 1, 1, 300, 0, 0 },
	{ 8, 8, "VIP 'Silver'", " ", -1, 30, 1, 1, 500, 0, 0 },
	{ 8, 9, "VIP 'Gold'", " ", -1, 30, 1, 1, 800, 0, 0 },
	{ 8, 10, "Смена игрового никнейма", " ", -1, 101, 1, 1, 100, 0, 0 },
	{ 8, 11, "Снятие предупреждения", " ", -1, 99, 1, 1, 200, 0, 0 },
	{ 8, 12, "Дополнительный слот для машины", " ", -1, 23, 1, 1, 600, 0, 0 },
	{ 8, 13, "Смена номера телефона", " ", -1, 55, 1, 1, 300, 0, 0 },
	{ 8, 14, "Смена номера автомобиля", " ", -1, 55, 1, 1, 500, 0, 0 },
	{ 8, 15, "Слот для бизнеса", " ", -1, 100, 1, 1, 1000, 0, 0 },
	{ 8, 16, "Слот для дома", " ", -1, 103, 1, 1, 800, 0, 0 },
	{ 8, 17, "Crime Plus", " ", -1, 55, 1, 1, 500, 0, 0 },
	{ 8, 18, "Военный билет", " ", -1, 149, 1, 1, 50, 0, 0 },
	{ 8, 19, "Battle Premium", " ", -1, 152, 1, 1, 2000, 0, 0 },
	{ 8, 20, "Battle +1 lvl", " ", -1, 153, 1, 1, 200, 0, 0 },
	{ 8, 21, "Battle limit (#1)", " ", -1, 154, 1, 1, 1000, 0, 0 },
	{ 8, 22, "Battle limit (#2)", " ", -1, 155, 1, 1, 500, 0, 0 },

	// бонус. счёт
	{ 9, 1, "Смена игрового возраста", " ", -1, 55, 1, 1, 50, 0, 0 },
	{ 9, 2, "Смена игрового пола", " ", -1, 104, 1, 1, 50, 0, 0 },
	{ 9, 3, "Получить новую трудовую книжку", " ", -1, 55, 1, 1, 50, 0, 0 },
	{ 9, 4, "Лицензии", " ", -1, 55, 1, 1, 150, 0, 0 },
	{ 9, 5, "Навыки оружия", " ", -1, 55, 1, 1, 200, 0, 0 },
	{ 9, 6, "Гонки (/myrace)", " ", -1, 55, 1, 1, 300, 0, 0 },
	{ 9, 7, "Законопослушность", " ", -1, 102, 1, 1, 20, 0, 0 },
	{ 9, 8, "Вылечиться от болезней", " ", -1, 55, 1, 1, 50, 0, 0 },
	{ 9, 9, "Launch-Control", " ", -1, 55, 1, 1, 750, 0, 0 },
	{ 9, 10, "Рабочие навыки", " ", -1, 55, 1, 1, 750, 0, 0 },
	{ 9, 11, "Военный билет", " ", -1, 149, 1, 1, 250, 0, 0 },

	// наборы
	{ 10, 1, "Зимний", " ", -1, 56, 1, 1, 1600, 0, 0 },
	{ 10, 2, "Мажор", " ", -1, 56, 1, 1, 2300, 0, 2 },
	{ 10, 3, "Опасный", " ", -1, 56, 1, 1, 3400, 0, 3 },
	{ 10, 4, "Новогодний", " ", -1, 56, 1, 1, 4400, 0, 4 },
	{ 10, 5, "Дед Мороз", " ", -1, 56, 1, 1, 8000, 0, 5 },
	{ 10, 6, "Скуби-Ду", " ", -1, 56, 1, 1, 18000, 0, 5 },
	{ 10, 7, "Трансформеры", " ", -1, 56, 1, 1, 20000, 0, 5 },
	
	// music
	{ 11, 1, "Аудиосистема в авто", "30 дней", 0, jbl_object, 1, 1, 200, 0, 0 },
	{ 11, 2, "JBL колонка", "30 дней", 0, jbl_object, 1, 1, 200, 0, 0 },
	{ 11, 3, "Аудиосистема + JBL", " ", 0, jbl_object, 1, 1, 300, 0, 0 }
	// Podpiska
	/*{ 9, 1, "Лечение в больнице в 2 раза быстрее", " ", -1, 1, 1, 1, 500, 0, 0 },
	{ 9, 2, "Штрафы перестают начисляться", " ", -1, 1, 1, 1, 500, 0, 0 },
	{ 9, 3, "Вы не сможете заболеть", " ", -1, 1, 1, 1, 500, 0, 0 },
	{ 9, 4, "Если у Вас активирована карта кладов,", " ", -1, 1, 1, 1, 500, 0, 0 },
	{ 9, 5, "то будет появляться квадрат", " ", -1, 1, 1, 1, 500, 0, 0 },
	{ 9, 6, "Использование аптечек, наркотиков и", " ", -1, 1, 1, 1, 500, 0, 0 },
	{ 9, 7, "лекарств без ограничения времени", " ", -1, 1, 1, 1, 500, 0, 0 },
	{ 9, 8, "Уровень розыска понижается в 2 раза быстрее", " ", -1, 1, 1, 1, 500, 0, 0 },
	{ 9, 9, "Шанс выпадения деталей для крафта", " ", -1, 1, 1, 1, 500, 0, 0 },
	{ 9, 10, "увеличен в 3 раза", " ", -1, 1, 1, 1, 500, 0, 0 },
	{ 9, 11, "Шанс крафта увеличен на 10%", " ", -1, 1, 1, 1, 500, 0, 0 },
	{ 9, 12, "Подписка действует 30 дней", " ", -1, 1, 1, 1, 500, 0, 0 },*/
} ;

#define MAX_DISCOUNT 20
new donate_discount_id [ MAX_DISCOUNT ] = { -1, ... } ;
new donate_discount_model [ MAX_DISCOUNT ] ;
new donate_discount_percent [ MAX_DISCOUNT ] ;
new donate_discount_hierarchy [ MAX_DISCOUNT ] ;
new donate_discount_date [ MAX_DISCOUNT ] ;

#include 									<custom/donate_packet>

stock clear_donate_discount ( )
{
	for ( new d = 0 ; d < MAX_DISCOUNT ; d ++ )
	{
		donate_discount_id [ d ] = -1 ;
		donate_discount_date [ d ] = 0 ;
	}
	mysql_tquery ( sql_connection, !"TRUNCATE TABLE `donate_discount`" ) ;
	return 1 ;
}

stock reset_donate_discount ( _type )
{
	new time = GetTickCount ( ) ;
	static const _donate_id [ ] = { 1, 2, 3, 4, 5, 8, 8 } ; // 5 vip, 6 adminka
	new _donate_count [ ] = { 0, 1, 2, 3, 4, -1, -1 } ;
	if ( _type == 1 )
	{
		for ( new i = 0 ; i < sizeof _donate_id ; i ++ )
		{
			new _random ;
			if ( _donate_id [ i ] == 8 ) _random = random ( 1 ) + 1 ;
			else _random = random ( 3 ) + 2 ;
			
			for ( new q = 0 ; q < _random ; q ++ )
			{
				for ( new d = 0 ; d < MAX_DISCOUNT ; d ++ )
				{
					if ( donate_discount_id [ d ] != -1 && donate_discount_date [ d ] > gettime ( ) ) continue ;
					
					new _count2 = 0 ;
					new _random2 ;
					if ( i == 5 ) _random2 = RandomEx ( 6, 8 ) ;
					else if ( i == 6 ) _random2 = RandomEx ( 0, 5 ) ;
					else _random2 = random ( donate_list_count [ _donate_count [ i ] ] ) ;
					
					retry_random2:
					_count2 = 0 ;
					if ( i == 5 ) _random2 = RandomEx ( 6, 8 ) ;
					else if ( i == 6 ) _random2 = RandomEx ( 0, 5 ) ;
					else _random2 = random ( donate_list_count [ _donate_count [ i ] ] ) ;
					for ( new h = 0 ; h < MAX_DISCOUNT ; h ++ )
					{
						if ( donate_discount_id [ h ] == _random2 && donate_discount_hierarchy [ h ] == _donate_id [ i ] )
						{
							goto retry_random2 ;
							break ;
						}
					}

					for ( new h = 0 ; h < sizeof donate_list ; h ++ )
					{
						if ( donate_list [ h ] [ HierarchyID ] != _donate_id [ i ] ) continue ;
						if ( _random2 != _count2 )
						{
							_count2 ++ ;
							continue ;
						}
						
						new bool: _need_insert = false ;
						if ( donate_discount_id [ d ] != -1 ) _need_insert = false ;
						else _need_insert = true ;
							
						donate_discount_id [ d ] = _random2 ;
						donate_discount_model [ d ] = donate_list [ h ] [ ModelId ] ;
						donate_discount_percent [ d ] = random ( 15 ) + 10 ;
						donate_discount_hierarchy [ d ] = _donate_id [ i ] ;
							
						new _random_days ;
						if ( _donate_id [ i ] == 8 ) _random_days = random ( 3 ) + 1 ;
						else _random_days = random ( 5 ) + 3 ;

						donate_discount_date [ d ] = SetElapsedTime ( gettime ( ), _random_days, CONVERT_TIME_TO_DAYS ) ;
						
						if ( _need_insert )
						{
							global_string [ 0 ] = EOS ;
							format ( global_string, 512, "INSERT INTO `donate_discount` (`d_id`,`d_model`,`d_percent`,`d_hierarchy`,`d_date`) VALUES ('%d','%d','%d','%d','%d')",
							donate_discount_id [ d ], donate_discount_model [ d ], donate_discount_percent [ d ], donate_discount_hierarchy [ d ], donate_discount_date [ d ] ) ;
							mysql_tquery ( sql_connection, global_string ) ;
						}
						else
						{
							global_string [ 0 ] = EOS ;
							format ( global_string, 512, "UPDATE `donate_discount` SET `d_id` = '%d', `d_model` = '%d', `d_percent` = '%d', `d_hierarchy` = '%d', `d_date` = '%d' WHERE `inc_id` = '%d' LIMIT 1",
							donate_discount_id [ d ], donate_discount_model [ d ], donate_discount_percent [ d ], donate_discount_hierarchy [ d ], donate_discount_date [ d ], d + 1 ) ;
							mysql_tquery ( sql_connection, global_string ) ;
						}
							
						_count2 = 0 ;
						break ;
					}
					break ;
				}
				continue ;
			}
		}
	}
	else if ( _type == 2 )
	{
		for ( new d = 0 ; d < MAX_DISCOUNT ; d ++ )
		{
			if ( donate_discount_date [ d ] > gettime ( ) ) continue ;

			new i ;
			if ( random ( 3 ) == 1 ) i = RandomEx ( 5, 6 ) ;
			else i = RandomEx ( 0, 4 ) ;
			
			new _count2 = 0, _count3 = 0 ;
			new _random2 ;
			if ( i == 5 ) _random2 = RandomEx ( 6, 8 ) ;
			else if ( i == 6 ) _random2 = RandomEx ( 0, 5 ) ;
			else _random2 = random ( donate_list_count [ _donate_count [ i ] ] ) ;

			retry_random3:
			_count2 = 0 ;
			if ( i == 5 ) _random2 = RandomEx ( 6, 8 ) ;
			else if ( i == 6 ) _random2 = RandomEx ( 0, 5 ) ;
			else _random2 = random ( donate_list_count [ _donate_count [ i ] ] ) ;
			for ( new h = 0 ; h < MAX_DISCOUNT ; h ++ )
			{
				if ( donate_discount_id [ h ] == _random2 && donate_discount_hierarchy [ h ] == _donate_id [ i ] && _count3 < 5 )
				{
					_count3 ++ ;
					goto retry_random3 ;
					break ;
				}
			}

			for ( new h = 0 ; h < sizeof donate_list ; h ++ )
			{
				if ( donate_list [ h ] [ HierarchyID ] != _donate_id [ i ] ) continue ;
				if ( _random2 != _count2 )
				{
					_count2 ++ ;
					continue ;
				}
						
				new bool: _need_insert = false ;
				if ( donate_discount_id [ d ] != -1 ) _need_insert = false ;
				else _need_insert = true ;
							
				donate_discount_id [ d ] = _random2 ;
				donate_discount_model [ d ] = donate_list [ h ] [ ModelId ] ;
				donate_discount_percent [ d ] = random ( 15 ) + 10 ;
				donate_discount_hierarchy [ d ] = _donate_id [ i ] ;
							
				new _random_days ;
				if ( _donate_id [ i ] == 8 ) _random_days = random ( 3 ) + 1 ;
				else _random_days = random ( 3 ) + 3 ;

				donate_discount_date [ d ] = SetElapsedTime ( gettime ( ), _random_days, CONVERT_TIME_TO_DAYS ) ;
						
				if ( _need_insert )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 512, "INSERT INTO `donate_discount` (`d_id`,`d_model`,`d_percent`,`d_hierarchy`,`d_date`) VALUES ('%d','%d','%d','%d','%d')",
					donate_discount_id [ d ], donate_discount_model [ d ], donate_discount_percent [ d ], donate_discount_hierarchy [ d ], donate_discount_date [ d ] ) ;
					mysql_tquery ( sql_connection, global_string ) ;
				}
				else
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 512, "UPDATE `donate_discount` SET `d_id` = '%d', `d_model` = '%d', `d_percent` = '%d', `d_hierarchy` = '%d', `d_date` = '%d' WHERE `inc_id` = '%d' LIMIT 1",
					donate_discount_id [ d ], donate_discount_model [ d ], donate_discount_percent [ d ], donate_discount_hierarchy [ d ], donate_discount_date [ d ], d + 1 ) ;
					mysql_tquery ( sql_connection, global_string ) ;
				}
							
				_count2 = 0 ;
				break ;
			}
		}
	}
	printf ( "[reset_donate_discount] %d ms.", time - GetTickCount ( ) ) ;
	return 1 ;
}

stock find_discount ( _hierarchy, _modelId, &_percent, &_date )
{
	for ( new q = 0 ; q < MAX_DISCOUNT ; q ++ )
	{
		if ( _hierarchy != donate_discount_hierarchy [ q ] ) continue ;
		if ( _modelId - 1 != donate_discount_id [ q ] ) continue ;
		if ( donate_discount_date [ q ] < gettime ( ) ) continue ;
		
		_percent = donate_discount_percent [ q ] ;
		_date = donate_discount_date [ q ] ;
		return 1 ;
	}
	
	_percent = 0 ;
	_date = 0 ;
	return 0 ;
}

stock find_donate ( _hierarchy, _internal )
{
	for ( new i = 0 ; i < sizeof donate_list ; i ++ )
	{
		if ( donate_list [ i ] [ HierarchyID ] != _hierarchy ) continue ;
		if ( donate_list [ i ] [ getInternalID ] != _internal + 1 ) continue ;
		
		return i ;
	}
	return 1 ;
}

stock donate_OnGameModeInit ( )
{
	mysql_tquery ( sql_connection, !"SELECT * FROM `donate_discount`", "donate_discount_loading" ) ;
	mysql_tquery ( sql_connection, !"SELECT * FROM `donate_action`", "donate_action_loading" ) ;
	return 1 ;
}

callback: donate_discount_loading ( )
{
    new fields,
		rows ;

	cache_get_data ( rows, fields ) ;
	
	if ( rows )
	{
		for ( new i = 0 ; i < rows ; i ++ )
		{
			donate_discount_id [ i ] = cache_get_field_content_int ( i, "d_id", sql_connection ) ;
			donate_discount_model [ i ] = cache_get_field_content_int ( i, "d_model", sql_connection ) ;
			donate_discount_percent [ i ] = cache_get_field_content_int ( i, "d_percent", sql_connection ) ;
			donate_discount_hierarchy [ i ] = cache_get_field_content_int ( i, "d_hierarchy", sql_connection ) ;
			donate_discount_date [ i ] = cache_get_field_content_int ( i, "d_date", sql_connection ) ;
		}
		reset_donate_discount ( 2 ) ;
	}
	else reset_donate_discount ( 1 ) ;
	return 1 ;
}

callback: donate_action_loading ( )
{
    new fields,
		rows ;

	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;
	
	started_promo_roulette = cache_get_field_content_int ( 0, "started_promo_roulette", sql_connection ) ;
	promo_roulette_date = cache_get_field_content_int ( 0, "promo_roulette_date", sql_connection ) ;
	
	if ( started_promo_roulette && promo_roulette_date < gettime ( ) )
	{
		started_promo_roulette = 0 ;
		mysql_tquery ( sql_connection, !"UPDATE `donate_action` SET `started_promo_roulette` = '0'" ) ;
	}
	return 1 ;
}

CMD:testd ( playerid )
{
	show_mobile_donate ( playerid ) ;
	return 1 ;
}

stock show_mobile_donate ( playerid )
{
	donateAddCategory ( playerid ) ;
	donateAddItem ( playerid, 0 ) ;
	set_player_use_listitem ( playerid, 0 ) ;
	SetPVarInt ( playerid, "donate_category", 0 ) ;
			
	new _str [ 12 ], _str2 [ 24 ], _str3 [ 24 ] ;
	format ( _str, sizeof _str, "" ) ;
	format ( _str2, sizeof _str2, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
	format ( _str3, sizeof _str3, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
	donateUpdateInfo ( playerid, _str, _str2, _str3 ) ;
	return 1 ;
}

stock show_donate_packet ( playerid, _param1, _json_data [ ] )
{
	new Node: json = JSON_Object();
	JSON_Parse ( _json_data, json ) ;
	
	new _param2 ;
	JSON_GetInt ( json, "position", _param2 ) ;
	
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 )
		{
			closeDonate ( playerid ) ;
		}
		else if ( _param2 == 1 )
		{
			send_check_cinfo ( playerid, "* Пополнить игровой счёт можно на сайте проекта: "site_name"", 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
		}
	}
	else if ( _param1 == 1 )
	{
		donateItemClear ( playerid ) ;
		donateAddItem ( playerid, _param2 ) ;
		set_player_use_listitem ( playerid, _param2 ) ;
		SetPVarInt ( playerid, "donate_category", _param2 ) ;
			
		new _str [ 12 ], _str2 [ 24 ], _str3 [ 24 ] ;
		format ( _str, sizeof _str, "" ) ;
		format ( _str2, sizeof _str2, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
		format ( _str3, sizeof _str3, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
		donateUpdateInfo ( playerid, _str, _str2, _str3 ) ;
	}
	else if ( _param1 == 2 )
	{
		new _id = GetPVarInt ( playerid, "donate_category" ) ;
		set_player_use_listitem ( playerid, _id ) ;
		if ( _id == 0 )
		{
			new _discount = find_donate ( donate_discount_hierarchy [ _param2 ], donate_discount_id [ _param2 ] ),
				_type = donate_list [ _discount ] [ HierarchyID ],
				_price = donate_list [ _discount ] [ Cost ] - floatround ( ( donate_list [ _discount ] [ Cost ] * donate_discount_percent [ _param2 ] ) / 100 ) ;
				
			if ( ! get_player_donate ( playerid, _price, 2 ) )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			if ( _type == 1 )
			{
				new _model = donate_list [ _discount ] [ ModelId ] + skin_cross ;
				give_player_item_prise ( playerid, _model, 1 ) ;
				
				set_player_donate ( playerid, _price, 2 ) ;
				
				new line_string [ 64 ] ;
				format ( line_string, sizeof line_string, "(donate) покупка %s", item_name ( _model ) ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _model ) ) ;
				send_check_cinfo ( playerid, global_string, 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
		
				new _str [ 12 ], _str2 [ 24 ], _str3 [ 24 ] ;
				format ( _str, sizeof _str, "" ) ;
				format ( _str2, sizeof _str2, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
				format ( _str3, sizeof _str3, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
				donateUpdateInfo ( playerid, _str, _str2, _str3 ) ;
			}
			else if ( _type == 2 || _type == 3 || _type == 4 || _type == 5 )
			{
				new _model = donate_list [ _discount ] [ ModelId ] ;
				give_player_item_prise ( playerid, _model, 1 ) ;
				
				set_player_donate ( playerid, _price, 2 ) ;
				
				new line_string [ 64 ] ;
				format ( line_string, sizeof line_string, "(donate) покупка %s", item_name ( _model ) ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _model ) ) ;
				send_check_cinfo ( playerid, global_string, 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
		
				new _str [ 12 ], _str2 [ 24 ], _str3 [ 24 ] ;
				format ( _str, sizeof _str, "" ) ;
				format ( _str2, sizeof _str2, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
				format ( _str3, sizeof _str3, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
				donateUpdateInfo ( playerid, _str, _str2, _str3 ) ;
			}
			else if ( _type == 8 )
			{
				if ( donate_list [ _discount ] [ getInternalID ] == 1 ) show_c_donate_vip ( playerid, 1, _price ) ;
				else if ( donate_list [ _discount ] [ getInternalID ] == 2 ) show_c_donate_vip ( playerid, 2, _price ) ;
				else if ( donate_list [ _discount ] [ getInternalID ] == 3 ) show_c_donate_vip ( playerid, 3, _price ) ;
				else if ( donate_list [ _discount ] [ getInternalID ] == 4 ) show_c_donate_vip ( playerid, 4, _price ) ;
				else if ( donate_list [ _discount ] [ getInternalID ] == 5 ) show_c_donate_vip ( playerid, 5, _price ) ;
				else if ( donate_list [ _discount ] [ getInternalID ] == 6 ) show_c_donate_vip ( playerid, 6, _price ) ;
				else if ( donate_list [ _discount ] [ getInternalID ] == 7 ) show_donate_vip ( playerid, 0, _price ) ;
				else if ( donate_list [ _discount ] [ getInternalID ] == 8 ) show_donate_vip ( playerid, 1, _price ) ;
				else if ( donate_list [ _discount ] [ getInternalID ] == 9 ) show_donate_vip ( playerid, 2, _price ) ;
			}
		}
		else if ( _id == 1 )
		{
			new _price = donate_list [ _param2 ] [ Cost ], _model = donate_list [ _param2 ] [ ModelId ] + skin_cross ;
			global_string [ 0 ] = EOS ;
			format ( global_string, 356, "\
				{"#cWH"}Название: {"#cOR"}%s\n\
				{"#cWH"}Стоимость: {"#cGN"}%s "donate_title"\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
				{"#cGRDialog"}* Вы действительно хотите приобрести?", item_name ( _model ), GetPlayerCashValueToSmile ( _price ), get_model_count ( _model ) ) ;
				
			new header_string [ 64 ] ;
			format ( header_string, sizeof header_string, "{"#cBHD"}Покупка {"#cWH"}%s", item_name ( _model ) ) ;
			inv_dialog ( playerid, d_donate_buy_1, DIALOG_STYLE_MSGBOX, header_string, global_string, "Купить", "Отмена" ) ;
			SetPVarInt ( playerid, "donate_id", _param2 ) ;
		}
		else if ( _id == 2 || _id == 3 || _id == 4 || _id == 5 )
		{
			new _price = donate_list [ _param2 ] [ Cost ], _model = donate_list [ _param2 ] [ ModelId ] ;
			global_string [ 0 ] = EOS ;
			format ( global_string, 356, "\
				{"#cWH"}Название: {"#cOR"}%s\n\
				{"#cWH"}Стоимость: {"#cGN"}%s "donate_title"\n\
				{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
				{"#cGRDialog"}* Вы действительно хотите приобрести?", item_name ( _model ), GetPlayerCashValueToSmile ( _price ), get_model_count ( _model ) ) ;
				
			new header_string [ 64 ] ;
			format ( header_string, sizeof header_string, "{"#cBHD"}Покупка {"#cWH"}%s", item_name ( _model ) ) ;
			inv_dialog ( playerid, d_donate_buy, DIALOG_STYLE_MSGBOX, header_string, global_string, "Купить", "Отмена" ) ;
			SetPVarInt ( playerid, "donate_id", _param2 ) ;
		}
		else if ( _id == 6 )
		{
			new _price = donate_list [ _param2 ] [ Cost ], _int = donate_list [ _param2 ] [ getInternalID ] ;
			if ( _int >= 4 && _int <= 6 )
			{
				new _item_id ;
				if ( _int == 4 ) _item_id = 190 ;
				else if ( _int == 5 ) _item_id = 191 ;
				else if ( _int == 6 ) _item_id = 192 ;
				
				inv_dialog ( playerid, d_donate_casket, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Покупка ларца", item_description ( _item_id ), "Купить", "Закрыть" ) ;
				SetPVarInt ( playerid, "donate_id", _param2 ) ;
				return 1 ;
			}
			
			if ( ! get_player_donate ( playerid, _price, 2 ) )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			set_player_donate ( playerid, _price, 2 ) ;
				
			new line_string [ 64 ] ;
			format ( line_string, sizeof line_string, "(donate) покупка roulette #%d", _int ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
			
			if ( _int == 1 ) give_player_item_prise ( playerid, 45, 1 ) ;
			else if ( _int == 2 ) give_player_item_prise ( playerid, 55, 1 ) ;
			else if ( _int == 3 ) give_player_item_prise ( playerid, 125, 1 ) ;
			
			new _str [ 12 ], _str2 [ 24 ], _str3 [ 24 ] ;
			format ( _str, sizeof _str, "" ) ;
			format ( _str2, sizeof _str2, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
			format ( _str3, sizeof _str3, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
			donateUpdateInfo ( playerid, _str, _str2, _str3 ) ;
		}
		else if ( _id == 7 )
		{
			new _int = donate_list [ _param2 ] [ getInternalID ] ;
	
			if ( _int == 1 ) inv_dialog ( playerid, d_donate_money, DIALOG_STYLE_INPUT, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Игровая валюта:\n\n{"#cGRDialog"}* Курс виртуальной валюты: {"#cGN"}1 "donate_title_abb"{"#cGRDialog"} = {"#cGN"}"conv_text_price""valute_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Введите количество "donate_title" Вы хотите обменять на \"{"#cWH"}Виртуальную валюту{"#cGRDialog"}\".","Принять", "Назад" ) ;
			else if ( _int == 2 ) inv_dialog ( playerid, d_donate_talon, DIALOG_STYLE_INPUT, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Семейные талоны:\n\n{"#cGRDialog"}* Курс семейных талонов: {"#cGN"}1 "family_title_abb"{"#cGRDialog"} = {"#cGN"}"conv_fam_text_price" "donate_title_abb"{"#cGRDialog"}.\n{"#cGRDialog"}* Введите количество "donate_title" Вы хотите обменять на \"{"#cWH"}"family_title"{"#cGRDialog"}\".","Принять", "Назад" ) ;
		}
		else if ( _id == 8 )
		{
			new _price = donate_list [ _param2 ] [ Cost ], _int = donate_list [ _param2 ] [ getInternalID ] ;
			if ( ! get_player_donate ( playerid, _price, 2 ) )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _int == 1 ) show_c_donate_vip ( playerid, 1, _price ) ;
			else if ( _int == 2 ) show_c_donate_vip ( playerid, 2, _price ) ;
			else if ( _int == 3 ) show_c_donate_vip ( playerid, 3, _price ) ;
			else if ( _int == 4 ) show_c_donate_vip ( playerid, 4, _price ) ;
			else if ( _int == 5 ) show_c_donate_vip ( playerid, 5, _price ) ;
			else if ( _int == 6 ) show_c_donate_vip ( playerid, 6, _price ) ;
			else if ( _int == 7 ) show_donate_vip ( playerid, 0, _price ) ;
			else if ( _int == 8 ) show_donate_vip ( playerid, 1, _price ) ;
			else if ( _int == 9 ) show_donate_vip ( playerid, 2, _price ) ;
			else if ( _int == 10 ) inv_dialog ( playerid, d_donate_rename, DIALOG_STYLE_INPUT, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Смена Ник-Нейма:\n\n{"#cGRDialog"}* Цена: {"#cGN"}100 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите сменить Ваш \"{"#cWH"}Ник-Нейм{"#cGRDialog"}\".","Принять", "Назад");
			else if ( _int == 11 ) inv_dialog ( playerid, d_donate_unwarn, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Снять предупреждение:\n\n{"#cGRDialog"}* Цена: {"#cGN"}200 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите снять \"{"#cWH"}Предупреждение{"#cGRDialog"}\"?","Принять", "Назад");
			else if ( _int == 12 ) inv_dialog ( playerid, d_donate_maxveh, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", "{"#cGRDialog"}- {"#cWH"}Дополнительный слот для машины:\n\n{"#cGRDialog"}- {"#cWH"}Даёт Вам право иметь ещё одним транспортным средством.\n\n{"#cGRDialog"}* Цена: {"#cGN"}600 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Дополнительный слот для автомобиля{"#cGRDialog"}\"?","Принять", "Назад");
			else if ( _int == 13 )
			{
				inv_dialog ( playerid, d_donate_phone_list, DIALOG_STYLE_INPUT, "{"#cBHD"}Донат услуги", "\
				{"#cGRDialog"}- {"#cWH"}Смена номера телефона:\n\n\
				{"#cGRDialog"}* Цена на на 4-значный номер телефона: {"#cGN"}400 "donate_title"{"#cGRDialog"}.\n\
				{"#cGRDialog"}* Цена на на 5-значный номер телефона: {"#cGN"}300 "donate_title"{"#cGRDialog"}.\n\n\
				{"#cGRDialog"}* Введите номер телефона, который желаете приобрести:","Принять", "Назад" ) ;
			}
			else if ( _int == 14 )
			{
				inv_dialog ( playerid, d_donate_number, DIALOG_STYLE_INPUT, "{"#cBHD"}Донат услуги","\
				{"#cGR"}- {"#cWH"}Смена номера автомобиля:\n\n\
				{"#cGR"}* Цена: {"#cGN"}500 "donate_title"{"#cGR"}.\n\n\
				{"#cGR"}- {"#cWH"}Критерии:\n\
				{"#cGR"}1. {"#cWH"}Необходимо указать тип номера.\n\
				{"#cGR"}2. {"#cWH"}Необходимо указать сам номер.\n\
				{"#cGR"}3. {"#cWH"}Необходимо указать регион.\n\n\
				{"#cGR"}- {"#cWH"}Типы номеров:\n\
				{"#cGR"}Тип 2. {"#cWH"}Русские номера (Пример: A111AA | 11).\n\
				{"#cGR"}Тип 3. {"#cWH"}Украинские номера (Пример: AA 1111 AA).\n\
				{"#cGR"}Тип 4. {"#cWH"}Белоруские номера (Пример: 1111 AA-1).\n\
				{"#cGR"}Тип 5. {"#cWH"}Казахские номера (Пример: 111AAA | 11).\n\
				{"#cGR"}Тип 6. {"#cWH"}Полицейские номера (Пример: A 1111 | 11).\n\n\
				{"#cGR"}* Пример ввода номера: 2, A111AA, 77 (тип номера, номер, регион)\n\
				{"#cGR"}* Введите номер, который желаете приобрести:","Принять", "Назад" ) ;
			}
			else if ( _int == 15 )
			{
				inv_dialog ( playerid, d_donate_biz, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", "\
				{"#cGRDialog"}- {"#cWH"}Слот для бизнеса:\n\n\
				{"#cGRDialog"}- {"#cWH"}Вы получите дополнительный слот для бизнеса навсегда\n\n\
				{"#cGRDialog"}* Цена: {"#cGN"}1000 "donate_title"{"#cGRDialog"}.\n\
				{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Слот для бизнеса{"#cGRDialog"}\"?", "Принять", "Назад" ) ;
			}
			else if ( _int == 16 )
			{
				inv_dialog ( playerid, d_donate_house, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", "\
				{"#cGRDialog"}- {"#cWH"}Слот для дома:\n\n\
				{"#cGRDialog"}- {"#cWH"}Вы получите дополнительный слот для дома навсегда\n\n\
				{"#cGRDialog"}* Цена: {"#cGN"}800 "donate_title"{"#cGRDialog"}.\n\
				{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Слот для дома{"#cGRDialog"}\"?", "Принять", "Назад" ) ;
			}
			else if ( _int == 17 )
			{
				inv_dialog ( playerid, d_donate_crime, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", "\
				{"#cGRDialog"}- {"#cWH"}Подписка '"logo_name" Плюс' даёт Вам следующие возможности:\n\n\
				{"#cGRDialog"}- {"#cWH"}Лечение в больнице в 2 раза быстрее (стакается c VIP)\n\
				{"#cGRDialog"}- {"#cWH"}Штрафы перестают начисляться\n\
				{"#cGRDialog"}- {"#cWH"}Вы не сможете заболеть\n\
				{"#cGRDialog"}- {"#cWH"}Если у Вас активирована карта кладов, то будет появляться квадрат, а не текст в чате\n\
				{"#cGRDialog"}- {"#cWH"}Использование аптечек, наркотиков и лекарств без ограничения времени\n\
				{"#cGRDialog"}- {"#cWH"}Уровень розыска понижается в 2 раза быстрее (стакается c VIP)\n\
				{"#cGRDialog"}- {"#cWH"}Шанс выпадения деталей для крафта увеличен в 3 раза\n\
				{"#cGRDialog"}- {"#cWH"}Подписка действует 30 дней\n\n\
				{"#cGRDialog"}* Цена: {"#cGN"}500 "donate_title"{"#cGRDialog"}.\n\
				{"#cGRDialog"}* Вы действительно хотите получить подписку\"{"#cWH"}"logo_name" Плюс{"#cGRDialog"}\"?", "Принять", "Назад" ) ;
			}
			else if ( _int == 18 )
			{
				inv_dialog ( playerid, d_donate_bilet, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", "\
				{"#cGRDialog"}- {"#cWH"}Военный билет:\n\n\
				{"#cGRDialog"}- {"#cWH"}Вы получите военный билет и сможете вступить в гос. структуры\n\n\
				{"#cGRDialog"}* Цена: {"#cGN"}50 "donate_title"{"#cGRDialog"}.\n\
				{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Военный билет{"#cGRDialog"}\"?", "Принять", "Назад" ) ;
			}
			else if ( _int == 19 )
			{
				new _eprem_price = 2000, _discount = 0, _type = 0 ;
				if ( get_player_item_prise ( playerid, 184 ) > 0 ) _discount = 10, _type = 1 ;
				else if ( get_player_item_prise ( playerid, 185 ) > 0 ) _discount = 30, _type = 2 ;
				else if ( get_player_item_prise ( playerid, 186 ) > 0 ) _discount = 50, _type = 3 ;
				_eprem_price = 2000 - floatround ( ( 2000 * _discount ) / 100 ) ;
				if ( ! get_player_donate ( playerid, _eprem_price, 2 ) )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( _type == 1 ) clear_player_item_prise ( playerid, 184, 1 ) ;
				else if ( _type == 2 ) clear_player_item_prise ( playerid, 185, 1 ) ;
				else if ( _type == 3 ) clear_player_item_prise ( playerid, 186, 1 ) ;
				
				set_player_donate ( playerid, _eprem_price, 2 ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, _eprem_price, p_info [ playerid ] [ donate ], "(donate) bp premium" ) ;

				give_player_item_prise ( playerid, 174, 1, -1 ) ;
					
				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( 174 ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
			else if ( _int == 20 )
			{
				new _elvl_price = 200, _discount = 0, _type = 0 ;
				if ( get_player_item_prise ( playerid, 184 ) > 0 ) _discount = 10, _type = 1 ;
				else if ( get_player_item_prise ( playerid, 185 ) > 0 ) _discount = 30, _type = 2 ;
				else if ( get_player_item_prise ( playerid, 186 ) > 0 ) _discount = 50, _type = 3 ;
				_elvl_price = 200 - floatround ( ( 200 * _discount ) / 100 ) ;
				if ( ! get_player_donate ( playerid, _elvl_price, 2 ) )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( _type == 1 ) clear_player_item_prise ( playerid, 184, 1 ) ;
				else if ( _type == 2 ) clear_player_item_prise ( playerid, 185, 1 ) ;
				else if ( _type == 3 ) clear_player_item_prise ( playerid, 186, 1 ) ;
					
				set_player_donate ( playerid, _elvl_price, 2 ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, _elvl_price, p_info [ playerid ] [ donate ], "(donate) bp lvl" ) ;

				give_player_item_prise ( playerid, 175, 1, -1 ) ;
					
				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( 175 ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
			else if ( _int == 21 )
			{
				new _elimit_price = 1000, _discount = 0, _type = 0 ;
				if ( get_player_item_prise ( playerid, 184 ) > 0 ) _discount = 10, _type = 1 ;
				else if ( get_player_item_prise ( playerid, 185 ) > 0 ) _discount = 30, _type = 2 ;
				else if ( get_player_item_prise ( playerid, 186 ) > 0 ) _discount = 50, _type = 3 ;
				_elimit_price = 1000 - floatround ( ( 1000 * _discount ) / 100 ) ;
				if ( ! get_player_donate ( playerid, _elimit_price, 2 ) )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
					
				if ( _type == 1 ) clear_player_item_prise ( playerid, 184, 1 ) ;
				else if ( _type == 2 ) clear_player_item_prise ( playerid, 185, 1 ) ;
				else if ( _type == 3 ) clear_player_item_prise ( playerid, 186, 1 ) ;
				
				set_player_donate ( playerid, _elimit_price, 2 ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, _elimit_price, p_info [ playerid ] [ donate ], "(donate) bp lvl" ) ;

				give_player_item_prise ( playerid, 176, 1, -1 ) ;
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( 176 ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
			else if ( _int == 22 )
			{
				new _elimit_price = 500, _discount = 0, _type = 0 ;
				if ( get_player_item_prise ( playerid, 184 ) > 0 ) _discount = 10, _type = 1 ;
				else if ( get_player_item_prise ( playerid, 185 ) > 0 ) _discount = 30, _type = 2 ;
				else if ( get_player_item_prise ( playerid, 186 ) > 0 ) _discount = 50, _type = 3 ;
				_elimit_price = 500 - floatround ( ( 500 * _discount ) / 100 ) ;
				if ( ! get_player_donate ( playerid, _elimit_price, 2 ) )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( _type == 1 ) clear_player_item_prise ( playerid, 184, 1 ) ;
				else if ( _type == 2 ) clear_player_item_prise ( playerid, 185, 1 ) ;
				else if ( _type == 3 ) clear_player_item_prise ( playerid, 186, 1 ) ;

				set_player_donate ( playerid, _elimit_price, 2 ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, _elimit_price, p_info [ playerid ] [ donate ], "(donate) bp lvl" ) ;

				give_player_item_prise ( playerid, 177, 1, -1 ) ;
					
				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( 177 ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
		}
		else if ( _id == 9 )
		{
			new _int = donate_list [ _param2 ] [ getInternalID ] ;
			if ( _int == 1 )
			{
				inv_dialog ( playerid, d_donate_age, DIALOG_STYLE_INPUT, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Смена возраста:\n\n{"#cGRDialog"}* Цена: {"#cGN"}50 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите сменить Ваш \"{"#cWH"}Возраст{"#cGRDialog"}\"?","Принять", "Назад");
			}
			else if ( _int == 2 )
			{
				inv_dialog ( playerid, d_donate_sex, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Смена пола:\n\n{"#cGRDialog"}* Цена: {"#cGN"}50 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите сменить Ваш \"{"#cWH"}Пол{"#cGRDialog"}\"?","Принять", "Назад");
			}
			else if ( _int == 3 )
			{
				inv_dialog ( playerid, d_donate_jobinfo, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Получить новую трудовую книжку:\n\n{"#cGRDialog"}- {"#cWH"}Если Вы состояли в незаконных вооружённых формированиях и Вас не берут на работу\n{"#cWH"}  в государственные службы или в Радиоцентры? Вы можете поменять трудовую книжку.\n\n{"#cGRDialog"}* Цена: {"#cGN"}50 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Новую трудовую книжку{"#cGRDialog"}\"?","Принять", "Назад");
			}
			else if ( _int == 4 )
			{
				inv_dialog ( playerid, d_donate_licenses, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
				{"#cGRDialog"}- {"#cWH"}Лицензии:\n\n\
				{"#cGRDialog"}Лицензии включают в себя:\n\
				\t{"#cGRDialog"}- {"#cWH"}Лицензия на вождение.\n\
				\t{"#cGRDialog"}- {"#cWH"}Лицензия на воздушный транспорт.\n\
				\t{"#cGRDialog"}- {"#cWH"}Лицензия на судовождение.\n\
				\t{"#cGRDialog"}- {"#cWH"}Лицензия на право ношения оружия.\n\n\
				{"#cGRDialog"}* Цена: {"#cGN"}150 "donate_title"{"#cGRDialog"}.\n\
				{"#cGRDialog"}* Вы действительно хотите приобрести \"{"#cWH"}Комплект лицензий{"#cGRDialog"}\"?","Принять", "Назад");
			}
			else if ( _int == 5 )
			{
				inv_dialog ( playerid, d_donate_skills, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
				{"#cGRDialog"}- {"#cWH"}Скиллы:\n\n\
				{"#cGRDialog"}Скиллы включают в себя:\n\
				\t{"#cGRDialog"}- {"#cWH"}Владение SD Pistol\n\
				\t{"#cGRDialog"}- {"#cWH"}Владение Desert Eagle\n\
				\t{"#cGRDialog"}- {"#cWH"}Владение Shotgun\n\
				\t{"#cGRDialog"}- {"#cWH"}Владение MP5\n\
				\t{"#cGRDialog"}- {"#cWH"}Владение M4\n\
				\t{"#cGRDialog"}- {"#cWH"}Владение AK-47\n\
				\t{"#cGRDialog"}- {"#cWH"}Владение Rifle\n\n\
				{"#cGRDialog"}* Цена: {"#cGN"}200 "donate_title"{"#cGRDialog"}.\n\
				{"#cGRDialog"}* Вы действительно хотите приобрести \"{"#cWH"}Комплект скиллов{"#cGRDialog"}\"?","Принять", "Назад");
			}
			else if ( _int == 6 )
			{
				inv_dialog ( playerid, d_donate_race, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Создание гонок:\n\n{"#cGRDialog"}- {"#cWH"}Вы сможете создавать свои, уникальные, трассы. (/my_race)\n\n{"#cGRDialog"}* Цена: {"#cGN"}300 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}доступ к созданию гонок{"#cGRDialog"}\"?","Принять", "Назад");
			}
			else if ( _int == 7 )
			{
				inv_dialog ( playerid, d_donate_law, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Законопослушность:\n\n{"#cGRDialog"}- {"#cWH"}Вы повысите свою законопослушность на 10 пунктов.\n\n{"#cGRDialog"}* Цена: {"#cGN"}20 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}законопослушность{"#cGRDialog"}\"?","Принять", "Назад");
			}
			else if ( _int == 8 )
			{
				inv_dialog ( playerid, d_donate_heal, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Лечение от болезней:\n\n{"#cGRDialog"}- {"#cWH"}Все ваши болезни обнулятся.\n\n{"#cGRDialog"}* Цена: {"#cGN"}50 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}лечение от болезней{"#cGRDialog"}\"?","Принять", "Назад");
			}
			else if ( _int == 9 )
			{
				inv_dialog ( playerid, d_donate_launch, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Launch-Control:\n\n{"#cGRDialog"}- {"#cWH"}Начальное ускорение для транспорта.\n{"#cGRDialog"}- {"#cWH"}Launch-Control будет привязан к т/с на всегда.\n{"#cGRDialog"}- {"#cWH"}Использование: Газ + Тормоз одновременно.\n\n{"#cGRDialog"}* Цена: {"#cGN"}750 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Launch-Control{"#cGRDialog"}\"?","Принять", "Назад");
			}
			else if ( _int == 10 )
			{
				inv_dialog ( playerid, d_donate_job, DIALOG_STYLE_LIST, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Дальнобойщик\n{"#cGRDialog"}- {"#cWH"}Таксист\n{"#cGRDialog"}- {"#cWH"}Механик\n{"#cGRDialog"}- {"#cWH"}Водитель автобуса\n{"#cGRDialog"}- {"#cWH"}Автоугонщик\n{"#cGRDialog"}* Цена: {"#cGN"}100 "donate_title"","Принять", "Назад");
			}
			else if ( _int == 11 )
			{
				inv_dialog ( playerid, d_donate_bilet1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", "\
				{"#cGRDialog"}- {"#cWH"}Военный билет:\n\n\
				{"#cGRDialog"}- {"#cWH"}Вы получите военный билет и сможете вступить в гос. структуры\n\n\
				{"#cGRDialog"}* Цена: {"#cGN"}250 "donate_title"{"#cGRDialog"}.\n\
				{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Военный билет{"#cGRDialog"}\"?", "Принять", "Назад" ) ;
			}
		}
		else if ( _id == 10 )
		{
			show_donate_packets ( playerid ) ;
			closeDonate ( playerid ) ;
		}
		else if ( _id == 11 )
		{
			new _price = donate_list [ _param2 ] [ Cost ], _int = donate_list [ _param2 ] [ getInternalID ] ;
			if ( ! get_player_donate ( playerid, _price, 2 ) )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( _int == 1 )
			{
				if ( GetPlayerVehicleID ( playerid ) == 0 )
				{
					send_check_cinfo ( playerid, "Вы должны находится в транспорте, на который хотите установить аудиосистему!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new _v_id = GetPlayerVehicleID ( playerid ) ;
				if ( veh_info [ _v_id - 1 ] [ v_type ] != vehicle_type_player )
				{
					send_check_cinfo ( playerid, "Вы должны находится в транспорте, на который хотите установить аудиосистему!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( veh_info [ _v_id - 1 ] [ v_owner ] != p_info [ playerid ] [ id ] )
				{
					send_check_cinfo ( playerid, "Вы должны находится в своём транспорте!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				if ( veh_info [ _v_id - 1 ] [ v_sound ] == 2 )
				{
					send_check_cinfo ( playerid, "У Вас уже есть активная аудиосистема!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				veh_info [ _v_id - 1 ] [ v_sound ] = 2 ;
				veh_info [ _v_id - 1 ] [ v_pantera_sdate ] = 0 ;
				
				new query_string [ 144 ] ;
				format ( query_string, sizeof ( query_string ),"UPDATE `users_vehicles` SET `v_sound` = '%d', `v_pantera_sdate` = '%d' WHERE `v_id` = '%d' LIMIT 1",
				veh_info [ _v_id - 1 ] [ v_sound ],
				veh_info [ _v_id - 1 ] [ v_pantera_sdate ],
				veh_info [ _v_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, query_string, "", "" ) ;
					
				send_check_cinfo ( playerid, "Вы приобрели аудио-систему! /play (в т/с) - управление автозвуком!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
			}
			else if ( _int == 2 )
			{
				if ( p_info [ playerid ] [ boombox ] == true )
				{
					send_check_cinfo ( playerid, "У Вас уже есть активная подписка на аудиосистему!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
					
				p_info [ playerid ] [ boombox ] = true ;
				p_info [ playerid ] [ boombox_date ] = SetElapsedTime ( gettime ( ), 30, CONVERT_TIME_TO_DAYS ) ;
				update_int_sql ( playerid, "u_boombox_date", p_info [ playerid ] [ boombox_date ] ) ;
				
				send_check_cinfo ( playerid, "Вы приобрели колонку! /recorder - управление колонкой!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
			}
			else if ( _int == 3 )
			{
				if ( GetPlayerVehicleID ( playerid ) == 0 )
				{
					send_check_cinfo ( playerid, "Вы должны находится в транспорте, на который хотите установить аудиосистему!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
					return 1 ;
				}
					
				new _v_id = GetPlayerVehicleID ( playerid ) ;
				if ( veh_info [ _v_id - 1 ] [ v_type ] != vehicle_type_player )
				{
					send_check_cinfo ( playerid, "Вы должны находится в транспорте, на который хотите установить аудиосистему!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
					return 1 ;
				}
				
				if ( veh_info [ _v_id - 1 ] [ v_owner ] != p_info [ playerid ] [ id ] )
				{
					send_check_cinfo ( playerid, "Вы должны находится в своём транспорте!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
					return 1 ;
				}
				
				veh_info [ _v_id - 1 ] [ v_sound ] = 2 ;
				veh_info [ _v_id - 1 ] [ v_pantera_sdate ] = 0 ;
			
				new query_string [ 144 ] ;
				format ( query_string, sizeof ( query_string ),"UPDATE `users_vehicles` SET `v_sound` = '%d', `v_pantera_sdate` = '%d' WHERE `v_id` = '%d' LIMIT 1",
				veh_info [ _v_id - 1 ] [ v_sound ],
				veh_info [ _v_id - 1 ] [ v_pantera_sdate ],
				veh_info [ _v_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, query_string, "", "" ) ;
					
				p_info [ playerid ] [ boombox ] = true ;
				p_info [ playerid ] [ boombox_date ] = SetElapsedTime ( gettime ( ), 30, CONVERT_TIME_TO_DAYS ) ;
				update_int_sql ( playerid, "u_boombox_date", p_info [ playerid ] [ boombox_date ] ) ;
				
				send_check_cinfo ( playerid, "Вы приобрели аудио-систему! /recorder, /play (в т/с) - управление автозвуком!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
			}
					
			set_player_donate ( playerid, _price, 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], "(donate) music" ) ;

			new _str [ 12 ], _str2 [ 24 ], _str3 [ 24 ] ;
			format ( _str, sizeof _str, "" ) ;
			format ( _str2, sizeof _str2, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
			format ( _str3, sizeof _str3, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
			donateUpdateInfo ( playerid, _str, _str2, _str3 ) ;
		}
	}
	return 1 ;
}

stock show_donate_vip ( playerid, _vip_id, _price )
{
	if ( _vip_id == 0 )
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, sizeof global_string, "\
			{"#cGRDialog"}- {"#cWH"}Привилегия VIP {cd7f32}'Bronze'{"#cWH"} даёт Вам следующие возможности:\n\n\
			{"#cGRDialog"}- {"#cWH"}Смена стиля походки\n\
			{"#cGRDialog"}- {"#cWH"}Смена стиля разговора\n\
			{"#cGRDialog"}- {"#cWH"}Каждый час кол-во денег на банковском счету увеличивается на 0.2%\n\
			{"#cGRDialog"}- {"#cWH"}Не кикает за долгий AFK\n\
			{"#cGRDialog"}- {"#cWH"}Каждый 5ый PayDay +1 "family_title"\n\
			{"#cGRDialog"}- {"#cWH"}Каждый 5ый PayDay +2 "donate_title" (Основной)\n\
			{"#cGRDialog"}- {"#cWH"}Ускоренное лечение в больнице\n\
			{"#cGRDialog"}- {"#cWH"}Ускоренная прокачка навыков оружия\n\
			{"#cGRDialog"}- {"#cWH"}Ограничение на рыбалке поднимается до 60 кг в час\n\
			{"#cGRDialog"}- {"#cWH"}Понижение уровня розыска в 2 раза быстрее\n\
			{"#cGRDialog"}- {"#cWH"}Возможность владения 2 бизнесами\n\
			{"#cGRDialog"}- {"#cWH"}Привилегия действует 30 календарных дней\n\n\
			{"#cGRDialog"}* Цена: {"#cGN"}%d "donate_title"{"#cGRDialog"}.\n\
			{"#cGRDialog"}* Вы действительно хотите получить привилегию\"{"#cWH"}VIP {cd7f32}'Bronze'{"#cGRDialog"}\"?", _price ) ;

		inv_dialog ( playerid, d_c_donate_vipgold, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", global_string, "Принять", "Назад" ) ;
	}
	else if ( _vip_id == 1 )
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, sizeof global_string, "\
			{"#cGRDialog"}- {"#cWH"}Привилегия VIP {c8c8c8}'Silver'{"#cWH"} даёт Вам следующие возможности:\n\n\
			{"#cGRDialog"}- {"#cWH"}Все привилегии VIP {cd7f32}'Bronze'{"#cWH"}\n\
			{"#cGRDialog"}- {"#cWH"}Дополнительный слот для автомобиля\n\
			{"#cGRDialog"}- {"#cWH"}Возможность видеть список администрации онлайн {"#cBL"}'/admins'\n\
			{"#cGRDialog"}- {"#cWH"}Лимит денежных средств на банковском счету увеличивается в 3 раза\n\
			{"#cGRDialog"}- {"#cWH"}Каждый час кол-во денег на банковском счету увеличивается на 0.5%\n\
			{"#cGRDialog"}- {"#cWH"}Каждый 5ый PayDay +1 EXP\n\
			{"#cGRDialog"}- {"#cWH"}Каждый 3ий PayDay +1 "family_title"\n\
			{"#cGRDialog"}- {"#cWH"}Каждый 5ый и 3ий PayDay +3 "donate_title" (Основной)\n\
			{"#cGRDialog"}- {"#cWH"}Скидка в 30%% при оплате штрафов\n\
			{"#cGRDialog"}- {"#cWH"}Ускоренная прокачка навыков на работах\n\
			{"#cGRDialog"}- {"#cWH"}При смерти на военной базе материалы не пропадают\n\
			{"#cGRDialog"}- {"#cWH"}Сытость уменьшается в 2 раза медленее\n\
			{"#cGRDialog"}- {"#cWH"}Возможность владения 3 бизнесами\n\
			{"#cGRDialog"}- {"#cWH"}Возможность владения 2 домами\n\
			{"#cGRDialog"}- {"#cWH"}Привилегия действует 30 календарных дней\n\n\
			{"#cGRDialog"}* Цена: {"#cGN"}%d "donate_title"{"#cGRDialog"}.\n\
			{"#cGRDialog"}* Вы действительно хотите получить привилегию\"{"#cWH"}VIP {c8c8c8}'Silver'{"#cGRDialog"}\"?", _price ) ;

		inv_dialog ( playerid, d_c_donate_vipgold, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", global_string, "Принять", "Назад" ) ;
	}
	else if ( _vip_id == 2 )
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, sizeof global_string, "\
			{"#cGRDialog"}- {"#cWH"}Привилегия VIP {c3900a}'Gold'{"#cWH"} даёт Вам следующие возможности:\n\n\
			{"#cGRDialog"}- {"#cWH"}Все привилегии VIP {cd7f32}'Bronze'{"#cWH"}\n\
			{"#cGRDialog"}- {"#cWH"}Все привилегии VIP {c8c8c8}'Silver'{"#cWH"}\n\
			{"#cGRDialog"}- {"#cWH"}Бесконечный голод\n\
			{"#cGRDialog"}- {"#cWH"}Дополнительный слот для автомобиля\n\
			{"#cGRDialog"}- {"#cWH"}Лимит денежных средств на банковском счету увеличивается в 5 раза\n\
			{"#cGRDialog"}- {"#cWH"}Каждый час кол-во денег на банковском счету увеличивается на 0.8%\n\
			{"#cGRDialog"}- {"#cWH"}Каждый 3ий PayDay +1 EXP\n\
			{"#cGRDialog"}- {"#cWH"}Каждый PayDay +1 "family_title"\n\
			{"#cGRDialog"}- {"#cWH"}Каждый 3ий PayDay +4 "donate_title" (Основной)\n\
			{"#cGRDialog"}- {"#cWH"}Срок в тюрьме уменьшается в 2 раза быстрее (Не jail)\n\
			{"#cGRDialog"}- {"#cWH"}Скидка в 50%% при оплате штрафов\n\
			{"#cGRDialog"}- {"#cWH"}Возможность владения 4 бизнесами\n\
			{"#cGRDialog"}- {"#cWH"}Возможность владения 3 домами\n\
			{"#cGRDialog"}- {"#cWH"}Привилегия действует 30 календарных дней\n\n\
			{"#cGRDialog"}* Цена: {"#cGN"}%d "donate_title"{"#cGRDialog"}.\n\
			{"#cGRDialog"}* Вы действительно хотите получить привилегию\"{"#cWH"}VIP {c3900a}'Gold'{"#cGRDialog"}\"?", _price ) ;
					
		inv_dialog ( playerid, d_c_donate_vipgold, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", global_string, "Принять", "Назад" ) ;
	}
	
	set_player_use_listitem ( playerid, _vip_id ) ;
	sell_price [ playerid ] = _price ;
	return 1 ;
}

stock show_c_donate_vip ( playerid, _admin_id, _price )
{
	new sql_string [ 200 ] ;
	format ( sql_string, sizeof sql_string, "INSERT INTO `users_admins`(`u_a_id`, `u_a_name`, `u_a_level`, `u_a_date`, `u_a_issued`, `u_a_dostup`) VALUES ('%d','%s','%d', NOW(), NOW(), '0|0|0|0|0|0')",
	p_info [ playerid ] [ id ], p_info [ playerid ] [ name ], _admin_id ) ;
	mysql_tquery ( sql_connection, sql_string ) ;

	for ( new i = 0 ; i < 6 ; i ++ )
		admin_info [ playerid ] [ dostup ] [ i ] = 0 ;
			    	
    admin_info [ playerid ] [ player_admin ] = true ;
    update_int_sql ( playerid, "u_admin", 1 ) ;

	set_player_donate ( playerid, _price, 2 ) ;
	insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], "(donate) admin" ) ;

	mysql_tquery ( sql_connection, "SELECT `u_a_id`, `u_a_name` FROM `users_admins` WHERE `u_a_level` > '6'", "callback_buy_admin", "i", playerid ) ;

	friend_pay ( playerid, 10 ) ;
	SendClientMessage ( playerid, col_lblue, !"Введите /alogin для авторизации в админ панель." ) ;
	SendClientMessage ( playerid, col_lblue, !"Настоятельно рекомендуем Вам ознакомится с правилами проекта. {"#cWH"}("forum_name" - Основной раздел - Правила проекта)" ) ;
	return 1 ;
}

stock donate_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_donate_buy:
		{
			if ( ! response ) return 1 ;
			
			new _param3 = GetPVarInt ( playerid, "donate_id" ), _price = donate_list [ _param3 ] [ Cost ], _model = donate_list [ _param3 ] [ ModelId ] ;
			DeletePVar ( playerid, "donate_id" ) ;
			if ( ! get_player_donate ( playerid, _price, 2 ) )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			give_player_item_prise ( playerid, _model, 1 ) ;
					
			set_player_donate ( playerid, _price, 2 ) ;
					
			new line_string [ 64 ] ;
			format ( line_string, sizeof line_string, "(donate) покупка %s", item_name ( _model ) ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
					
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _model ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
			
			new _str [ 12 ], _str2 [ 24 ], _str3 [ 24 ] ;
			format ( _str, sizeof _str, "" ) ;
			format ( _str2, sizeof _str2, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
			format ( _str3, sizeof _str3, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
			donateUpdateInfo ( playerid, _str, _str2, _str3 ) ;
			return 1 ;
		}
		case d_donate_buy_1:
		{
			if ( ! response ) return 1 ;
			
			new _param3 = GetPVarInt ( playerid, "donate_id" ), _price = donate_list [ _param3 ] [ Cost ], _model = donate_list [ _param3 ] [ ModelId ] + skin_cross ;
			DeletePVar ( playerid, "donate_id" ) ;
			if ( ! get_player_donate ( playerid, _price, 2 ) )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			give_player_item_prise ( playerid, _model, 1 ) ;
					
			set_player_donate ( playerid, _price, 2 ) ;
				
			new line_string [ 64 ] ;
			format ( line_string, sizeof line_string, "(donate) покупка %s", item_name ( _model ) ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
				
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _model ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 300, CINFO_AZS_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
		
			new _str [ 12 ], _str2 [ 24 ], _str3 [ 24 ] ;
			format ( _str, sizeof _str, "" ) ;
			format ( _str2, sizeof _str2, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
			format ( _str3, sizeof _str3, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
			donateUpdateInfo ( playerid, _str, _str2, _str3 ) ;
			return 1 ;
		}
		case d_donate_casket:
		{
			if ( ! response ) return 1 ;
			
			new _param3 = GetPVarInt ( playerid, "donate_id" ), _price = donate_list [ _param3 ] [ Cost ], _int = donate_list [ _param3 ] [ getInternalID ] ;
			DeletePVar ( playerid, "donate_id" ) ;
			if ( ! get_player_donate ( playerid, _price, 2 ) )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			set_player_donate ( playerid, _price, 2 ) ;
				
			new line_string [ 64 ] ;
			format ( line_string, sizeof line_string, "(donate) покупка roulette #%d", _int ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
			
			if ( _int == 1 ) give_player_item_prise ( playerid, 45, 1 ) ;
			else if ( _int == 2 ) give_player_item_prise ( playerid, 55, 1 ) ;
			else if ( _int == 3 ) give_player_item_prise ( playerid, 125, 1 ) ;
			else if ( _int == 4 ) give_player_item_prise ( playerid, 190, 1 ) ;
			else if ( _int == 5 ) give_player_item_prise ( playerid, 191, 1 ) ;
			else if ( _int == 6 ) give_player_item_prise ( playerid, 192, 1 ) ;
			
			new _str [ 12 ], _str2 [ 24 ], _str3 [ 24 ] ;
			format ( _str, sizeof _str, "" ) ;
			format ( _str2, sizeof _str2, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ family_ticket ] ) ) ;
			format ( _str3, sizeof _str3, "%s", GetPlayerCashValueToSmile ( p_info [ playerid ] [ donate ] ) ) ;
			donateUpdateInfo ( playerid, _str, _str2, _str3 ) ;
			return 1 ;
		}
		case d_c_donate_case:
		{
			if ( ! response ) return 1 ;
			
			if ( listitem == 0 )
			{
				set_player_use_listitem ( playerid, 0 ) ;
				show_dialog ( playerid, d_c_donate_case_1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
					{"#cGRDialog"}* Цена: {"#cGN"}100 "donate_title"{"#cGRDialog"}.\n\
					{"#cGRDialog"}* Вы действительно хотите получить привилегию\"{"#cWH"}+1 час к рулетке{"#cGRDialog"}\"?", "Принять", "Назад" ) ;
			}
			else if ( listitem == 1 )
			{
				set_player_use_listitem ( playerid, 1 ) ;
				show_dialog ( playerid, d_c_donate_case_1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
					{"#cGRDialog"}* Цена: {"#cGN"}1000 "donate_title"{"#cGRDialog"}.\n\
					{"#cGRDialog"}* Вы действительно хотите получить привилегию\"{"#cWH"}доступ к авто-кейсу{"#cGRDialog"}\"?", "Принять", "Назад" ) ;
			}
			return 1 ;
		}
		case d_c_donate_case_1:
		{
			if ( ! response ) return 1 ;
			
			if ( get_player_use_listitem ( playerid ) == 0 )
			{
				new _sell_price = 100 ;
				if ( ! get_player_donate ( playerid, _sell_price, 2 ) )
				{
					show_dialog ( playerid, d_c_donate_case_1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
						{"#cRD"}* У Вас недостаточно средств для приобретения данной услуги.\n\n\
						{"#cGRDialog"}* Цена: {"#cGN"}100 "donate_title"{"#cGRDialog"}.\n\
						{"#cGRDialog"}* Вы действительно хотите получить привилегию\"{"#cWH"}+1 час к рулетке{"#cGRDialog"}\"?","Принять", "Назад" ) ;
					return 1 ;
				}

				set_player_donate ( playerid, _sell_price, 2 ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, _sell_price, p_info [ playerid ] [ donate ], "(donate) auto case" ) ;

				friend_pay ( playerid, _sell_price / 10 ) ;
				
				donate_player_time [ playerid ] += 3600 ;
				donate_OnPlayerDisconnect ( playerid ) ;
			    
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели услугу." ) ;
			}
			else if ( get_player_use_listitem ( playerid ) == 1 )
			{
				new _sell_price = 1000 ;
				if ( ! get_player_donate ( playerid, _sell_price, 2 ) )
				{
					show_dialog ( playerid, d_c_donate_case_1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
						{"#cRD"}* У Вас недостаточно средств для приобретения данной услуги.\n\n\
						{"#cGRDialog"}* Цена: {"#cGN"}1000 "donate_title"{"#cGRDialog"}.\n\
						{"#cGRDialog"}* Вы действительно хотите получить привилегию\"{"#cWH"}доступ к авто-кейсу{"#cGRDialog"}\"?","Принять", "Назад" ) ;
					return 1 ;
				}

				set_player_donate ( playerid, _sell_price, 2 ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, _sell_price, p_info [ playerid ] [ donate ], "(donate) auto case" ) ;

				friend_pay ( playerid, _sell_price / 10 ) ;
				
				donate_player_time [ playerid ] += auto_case_time ;
				donate_OnPlayerDisconnect ( playerid ) ;
			    
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели услугу." ) ;
			}
			return 1 ;
		}
		case d_c_donate_vipgold:
		{
			if ( ! response ) return 1 ;
			
			new list_item = get_player_use_listitem ( playerid ) ;
			if ( list_item + 1 == p_info [ playerid ] [ vip ] || list_item + 1 < p_info [ playerid ] [ vip ] ) 
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас уже имеется VIP выбранного уровня либо уровнем выше." ) ;

			new _sell_price = sell_price [ playerid ] ;
			if ( ! get_player_donate ( playerid, _sell_price, 2 ) )
			{
			    if ( list_item == 0 )
				{
					inv_dialog ( playerid, d_c_donate_vipgold, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
						{"#cRD"}* У Вас недостаточно средств для приобретения данной услуги.\n\n\
						{"#cGRDialog"}- {"#cWH"}Привилегия VIP {cd7f32}'Bronze'{"#cWH"} даёт Вам следующие возможности:\n\n\
						{"#cGRDialog"}- {"#cWH"}Смена стиля походки\n\
						{"#cGRDialog"}- {"#cWH"}Смена стиля разговора\n\
						{"#cGRDialog"}- {"#cWH"}Каждый час кол-во денег на банковском счету увеличивается на 0.2%\n\
						{"#cGRDialog"}- {"#cWH"}Не кикает за долгий AFK\n\
						{"#cGRDialog"}- {"#cWH"}Каждый 5ый PayDay +1 "family_title"\n\
						{"#cGRDialog"}- {"#cWH"}Каждый 5ый PayDay +1 "donate_title" (Основной)\n\
						{"#cGRDialog"}- {"#cWH"}Ускоренное лечение в больнице\n\
						{"#cGRDialog"}- {"#cWH"}Ускоренная прокачка навыков оружия\n\
						{"#cGRDialog"}- {"#cWH"}Понижение уровня розыска в 2 раза быстрее\n\
						{"#cGRDialog"}- {"#cWH"}Возможность владения 2 бизнесами\n\
						{"#cGRDialog"}- {"#cWH"}+3%% шанса к выпадению предметов для крафта\n\
						{"#cGRDialog"}- {"#cWH"}Привилегия действует 30 календарных дней\n\n\
						{"#cGRDialog"}* Цена: {"#cGN"}300 "donate_title"{"#cGRDialog"}.\n\
						{"#cGRDialog"}* Вы действительно хотите получить привилегию\"{"#cWH"}VIP {cd7f32}'Bronze'{"#cGRDialog"}\"?","Принять", "Назад");
				}
				else if ( list_item == 1 )
				{
					inv_dialog ( playerid, d_c_donate_vipgold, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
						{"#cRD"}* У Вас недостаточно средств для приобретения данной услуги.\n\n\
						{"#cGRDialog"}- {"#cWH"}Привилегия VIP {c8c8c8}'Silver'{"#cWH"} даёт Вам следующие возможности:\n\n\
						{"#cGRDialog"}- {"#cWH"}Все привилегии VIP {cd7f32}'Bronze'{"#cWH"}\n\
						{"#cGRDialog"}- {"#cWH"}Дополнительный слот для автомобиля\n\
						{"#cGRDialog"}- {"#cWH"}Возможность видеть список администрации онлайн {"#cBL"}'/admins'\n\
						{"#cGRDialog"}- {"#cWH"}Лимит денежных средств на банковском счету увеличивается в 3 раза\n\
						{"#cGRDialog"}- {"#cWH"}Каждый час кол-во денег на банковском счету увеличивается на 0.5%\n\
						{"#cGRDialog"}- {"#cWH"}Каждый 5ый PayDay +1 EXP\n\
						{"#cGRDialog"}- {"#cWH"}Каждый 3ий PayDay +1 "family_title"\n\
						{"#cGRDialog"}- {"#cWH"}Каждый 5ый PayDay +2 "donate_title" (Основной)\n\
						{"#cGRDialog"}- {"#cWH"}Скидка в 30%% при оплате штрафов\n\
						{"#cGRDialog"}- {"#cWH"}Ускоренная прокачка навыков на работах\n\
						{"#cGRDialog"}- {"#cWH"}При смерти на военной базе материалы не пропадают\n\
						{"#cGRDialog"}- {"#cWH"}Сытость уменьшается в 2 раза медленее\n\
						{"#cGRDialog"}- {"#cWH"}Возможность владения 3 бизнесами\n\
						{"#cGRDialog"}- {"#cWH"}Возможность владения 2 домами\n\
						{"#cGRDialog"}- {"#cWH"}+5%% шанса к выпадению предметов для крафта\n\
						{"#cGRDialog"}- {"#cWH"}Привилегия действует 30 календарных дней\n\n\
						{"#cGRDialog"}* Цена: {"#cGN"}500 "donate_title"{"#cGRDialog"}.\n\
						{"#cGRDialog"}* Вы действительно хотите получить привилегию\"{"#cWH"}VIP {c8c8c8}'Silver'{"#cGRDialog"}\"?","Принять", "Назад");
				}
				else if ( list_item == 2 )
				{
					inv_dialog ( playerid, d_c_donate_vipgold, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
						{"#cRD"}* У Вас недостаточно средств для приобретения данной услуги.\n\n\
						{"#cGRDialog"}- {"#cWH"}Привилегия VIP {c3900a}'Gold'{"#cWH"} даёт Вам следующие возможности:\n\n\
						{"#cGRDialog"}- {"#cWH"}Все привилегии VIP {cd7f32}'Bronze'{"#cWH"}\n\
						{"#cGRDialog"}- {"#cWH"}Все привилегии VIP {c8c8c8}'Silver'{"#cWH"}\n\
						{"#cGRDialog"}- {"#cWH"}Бесконечный голод\n\
						{"#cGRDialog"}- {"#cWH"}Дополнительный слот для автомобиля\n\
						{"#cGRDialog"}- {"#cWH"}Лимит денежных средств на банковском счету увеличивается в 5 раза\n\
						{"#cGRDialog"}- {"#cWH"}Каждый час кол-во денег на банковском счету увеличивается на 0.8%\n\
						{"#cGRDialog"}- {"#cWH"}Каждый 3ий PayDay +1 EXP\n\
						{"#cGRDialog"}- {"#cWH"}Каждый PayDay +1 "family_title"\n\
						{"#cGRDialog"}- {"#cWH"}Каждый 3ий PayDay +3 "donate_title" (Основной)\n\
						{"#cGRDialog"}- {"#cWH"}Срок в тюрьме уменьшается в 2 раза быстрее (Не jail)\n\
						{"#cGRDialog"}- {"#cWH"}Скидка в 50%% при оплате штрафов\n\
						{"#cGRDialog"}- {"#cWH"}Возможность владения 4 бизнесами\n\
						{"#cGRDialog"}- {"#cWH"}Возможность владения 3 домами\n\
						{"#cGRDialog"}- {"#cWH"}+10%% шанса к выпадению предметов для крафта\n\
						{"#cGRDialog"}- {"#cWH"}Привилегия действует 30 календарных дней\n\n\
						{"#cGRDialog"}* Цена: {"#cGN"}800 "donate_title"{"#cGRDialog"}.\n\
						{"#cGRDialog"}* Вы действительно хотите получить привилегию\"{"#cWH"}VIP {c3900a}'Gold'{"#cGRDialog"}\"?","Принять", "Назад");
				}
				return 1 ;
			}

			set_player_donate ( playerid, _sell_price, 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _sell_price, p_info [ playerid ] [ donate ], "(donate) vip" ) ;

			friend_pay ( playerid, _sell_price / 10 ) ;

			if ( list_item == 0 )
			{
			    p_info [ playerid ] [ vip ] = 1 ;
			    
			    if ( p_info [ playerid ] [ vip_day ] > gettime ( ) )
				{
					p_info [ playerid ] [ vip_day ] += 30 * 86400 ;

			    	new sql_string [ 186 ] ;
			    	format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_vip` = '1', `u_vip_day` = '%d' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ vip_day ], p_info [ playerid ] [ id ] ) ;
			    	mysql_tquery ( sql_connection, sql_string ) ;
				}
			    else
				{
					p_info [ playerid ] [ vip_day ] = SetElapsedTime ( gettime ( ), 30, CONVERT_TIME_TO_DAYS ) ;
			    	p_info [ playerid ] [ max_biz ] += 1 ;
			    	
			    	new sql_string [ 186 ] ;
			    	format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_vip` = '1', `u_vip_day` = '%d', `u_maxbiz` = `u_maxbiz` + '1' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ vip_day ], p_info [ playerid ] [ id ] ) ;
			    	mysql_tquery ( sql_connection, sql_string ) ;
				}

			    SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели услугу VIP {cd7f32}'Bronze'{"#cWH"}." ) ;
			}
			else if ( list_item == 1 )
			{
			    if ( p_info [ playerid ] [ vip_day ] > gettime ( ) )
				{
				    switch ( p_info [ playerid ] [ vip ] )
				    {
				        case 1:
				        {
				            p_info [ playerid ] [ max_house ] += 1 ;
				    		p_info [ playerid ] [ max_biz ] += 2 ;

						    p_info [ playerid ] [ max_veh ] += 1 ;
							update_int_sql ( playerid, "u_maxveh", p_info [ playerid ] [ max_veh ] ) ;

					    	new query_string [ 113 + 9 ] ;
							format ( query_string, sizeof ( query_string ), "UPDATE `users` SET `u_maxbiz` = `u_maxbiz` + '1',`u_maxhouse` = `u_maxhouse` + '1' WHERE `u_id` = '%d' LIMIT 1",
							p_info [ playerid ] [ id ] ) ;
							mysql_tquery ( sql_connection, query_string ) ;
				        }
				    }

			    	p_info [ playerid ] [ vip ] = 2 ;
					p_info [ playerid ] [ vip_day ] += 30 * 86400 ;
					
					new sql_string [ 356 ] ;
				    format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_vip` = '2', `u_vip_day` = '%d' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ vip_day ], p_info [ playerid ] [ id ] ) ;
				    mysql_tquery ( sql_connection, sql_string ) ;
				}
			    else
				{
			    	p_info [ playerid ] [ vip ] = 2 ;
					p_info [ playerid ] [ vip_day ] = SetElapsedTime ( gettime ( ), 30, CONVERT_TIME_TO_DAYS ) ;

				    p_info [ playerid ] [ max_house ] += 2 ;
				    p_info [ playerid ] [ max_biz ] += 3 ;

				    new sql_string [ 356 ] ;
				    format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_vip` = '2', `u_vip_day` = '%d', `u_maxbiz` = `u_maxbiz` + '2', `u_maxhouse` = `u_maxhouse` + '1' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ vip_day ], p_info [ playerid ] [ id ] ) ;
				    mysql_tquery ( sql_connection, sql_string ) ;

				    p_info [ playerid ] [ max_veh ] += 1 ;
					update_int_sql ( playerid, "u_maxveh", p_info [ playerid ] [ max_veh ] ) ;
				}

			    SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели услугу VIP {c8c8c8}'Silver'{"#cWH"}." ) ;
			}
			else if ( list_item == 2 )
			{
			    if ( p_info [ playerid ] [ vip_day ] > gettime ( ) )
				{
				    switch ( p_info [ playerid ] [ vip ] )
				    {
				        case 1:
				        {
				            p_info [ playerid ] [ max_house ] += 3 ;
				    		p_info [ playerid ] [ max_biz ] += 2 ;

						    p_info [ playerid ] [ max_veh ] += 1 ;
							update_int_sql ( playerid, "u_maxveh", p_info [ playerid ] [ max_veh ] ) ;

					    	new query_string [ 113 + 9 ] ;
							format ( query_string, sizeof ( query_string ), "UPDATE `users` SET `u_maxbiz` = `u_maxbiz` + '2',`u_maxhouse` = `u_maxhouse` + '2' WHERE `u_id` = '%d' LIMIT 1",
							p_info [ playerid ] [ id ] ) ;
							mysql_tquery ( sql_connection, query_string ) ;
				        }
				        case 2:
				        {
				            p_info [ playerid ] [ max_house ] += 1 ;
				    		p_info [ playerid ] [ max_biz ] += 1 ;

					    	new query_string [ 113 + 9 ] ;
							format ( query_string, sizeof ( query_string ), "UPDATE `users` SET `u_maxbiz` = `u_maxbiz` + '1',`u_maxhouse` = `u_maxhouse` + '1' WHERE `u_id` = '%d' LIMIT 1",
							p_info [ playerid ] [ id ] ) ;
							mysql_tquery ( sql_connection, query_string ) ;
				        }
				    }
				
			    	p_info [ playerid ] [ vip ] = 3 ;
					p_info [ playerid ] [ vip_day ] += 30 * 86400 ;

					p_info [ playerid ] [ hunger_immune ] = 1 ;
					p_info [ playerid ] [ hunger_immune_time ] = 0 ;
					p_info [ playerid ] [ hunger ] = 100 ;
					
					new query_string [ 356 ] ;
					format ( query_string, sizeof ( query_string ), "UPDATE `users` SET `u_vip` = '3', `u_hungerimmune` = '1', `u_hungerimmunetime` = '0', `u_vip_day` = '%d' WHERE `u_id` = '%d' LIMIT 1",
					p_info [ playerid ] [ vip_day ], p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, query_string ) ;
				}
			    else
				{
			    	p_info [ playerid ] [ vip ] = 3 ;
					p_info [ playerid ] [ vip_day ] = SetElapsedTime ( gettime ( ), 30, CONVERT_TIME_TO_DAYS ) ;

                    p_info [ playerid ] [ max_house ] += 3 ;
				    p_info [ playerid ] [ max_biz ] += 4 ;

					p_info [ playerid ] [ max_veh ] += 1 ;

					p_info [ playerid ] [ hunger_immune ] = 1 ;
					p_info [ playerid ] [ hunger_immune_time ] = 0 ;
					p_info [ playerid ] [ hunger ] = 100 ;

					new query_string [ 356 ] ;
					format ( query_string, sizeof ( query_string ), "UPDATE `users` SET `u_vip` = '3',`u_maxveh` = '%d',`u_hungerimmune` = '1',`u_hungerimmunetime` = '0',\
					`u_vip_day` = '%d',`u_maxbiz` = `u_maxbiz` + '3',`u_maxhouse` = `u_maxhouse` + '2' WHERE `u_id` = '%d' LIMIT 1",
					p_info [ playerid ] [ max_veh ], p_info [ playerid ] [ vip_day ], p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, query_string ) ;
				}
			}

			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели услугу VIP {c3900a}'Gold'{"#cWH"}." ) ;
			return 1 ;
		}
	}
	return 0 ;
}