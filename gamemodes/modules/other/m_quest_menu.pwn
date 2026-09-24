/*

	18631 - знак вопроса для пустого

*/

#include	<custom/quest_menu>

stock quest_percent ( _progress, _max )
{
	if ( _max <= 0 ) return 0 ;
	new _value = floatround ( ( float ( _progress ) / float ( _max ) ) * 100.0 ) ;
	if ( _value < 0 ) _value = 0 ;
	if ( _value > 100 ) _value = 100 ;
	return _value ;
}


stock quest_chain_active ( playerid )
{
	for ( new i = 0 ; i < 3 ; i ++ ) if ( quest_select [ playerid ] [ i ] < MAX_QUESTS ) return i ;
	return -1 ;
}

stock quest_menu_target ( _chain, _k )
{
	if ( _chain == 0 ) return quest_progress_start [ _k ] ;
	if ( _chain == 1 ) return quest_progress_medium [ _k ] ;
	return quest_progress_high [ _k ] ;
}

stock quest_menu_buttons ( playerid, _k )
{
	new _chain = quest_chain_active ( playerid ) ;
	if ( _chain == -1 ) return setQuestButtons ( playerid, "Отслеживать", false ) ;

	new _select = quest_select [ playerid ] [ _chain ] ;
	if ( _k < _select ) return setQuestButtons ( playerid, "Выполнено", false ) ;
	if ( _k > _select ) return setQuestButtons ( playerid, "Недоступно", false ) ;

	switch ( quest_status [ playerid ] [ _chain ] )
	{
		case 0: return setQuestButtons ( playerid, "Принять", false ) ;
		case 2: return setQuestButtons ( playerid, "Сдать награду", false ) ;
	}
	return setQuestButtons ( playerid, "Отслеживать", true ) ;
}

stock show_packet_quest ( playerid, _param1, _param2, _param3 )
{
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 )
		{
			questsHide ( playerid ) ;
			
			toggle_controlable ( playerid, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
		}
		else if ( _param2 == 1 )
		{
			new _id = get_player_use_listitem ( playerid ) ;
			if ( _id < 100 ) return quest_menu_accept ( playerid ) ;
			else if ( _id == 100 )
			{
				questsHide ( playerid ) ;
				show_employment_player ( playerid ) ;
			}
			else if ( _id == 101 )
			{
				show_packet_quest ( playerid, 0, 0, 0 ) ;
				new _q_id = p_info [ playerid ] [ family_quest ], _q_progress = p_info [ playerid ] [ family_quest_progress ] ;
				
				static const _quest_progress [ ] =
				{
					10,
					20,
					1,
					1,
					10,
					50,
					100,
					1
				} ;
				if ( _q_progress >= _quest_progress [ _q_id - 1 ] )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Используйте {"#cBL"}/gps - Прочее - Семейные задания{"#cWH"}, чтоб найти квестового персонажа." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Квестовый персонаж выдаст Вам вознагрождение." ) ;
					return 1 ;
				}
				
				if ( _q_id == 0 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вам необходимо приобрести ружьё. {"#cBL"}/gps - Бизнесы - охота и рыбалка{"#cWH"}." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Затем отправляйтесь в охотничьи угодья и ищите оленей. Используйте {"#cBL"}/gps - Прочее{"#cWH"}." ) ;
				}
				else if ( _q_id == 1 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Используйте {"#cBL"}/fmenu{"#cWH"}, чтоб найти людей из чёрного списка." ) ;
				}
				else if ( _q_id == 2 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Используйте {"#cBL"}/gps - Бизнесы - Банки{"#cWH"}, чтоб найти банк." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}На парковке у банка будет {"#cBL"}мешок с деньгами{"#cWH"}, встаньте на него." ) ;
				}
				else if ( _q_id == 3 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Используйте {"#cBL"}/gps - Прочее - Семейные задания{"#cWH"}, чтоб найти квестового персонажа." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Квестовый персонаж выдаст Вам машину и отметит место на карте." ) ;
				}
				else if ( _q_id == 4 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вам необходимо приобрести ружьё. {"#cBL"}/gps - Бизнесы - охота и рыбалка{"#cWH"}." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Затем отправляйтесь в охотничьи угодья и ищите оленей. Используйте {"#cBL"}/gps - Прочее{"#cWH"}." ) ;
				}
				else if ( _q_id == 5 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вам необходимо приобрести удочку. {"#cBL"}/gps - Бизнесы - охота и рыбалка{"#cWH"}." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Затем отправляйтесь в рыбацкие угодья. Используйте {"#cBL"}/gps - Прочее{"#cWH"}." ) ;
				}
				else if ( _q_id == 6 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вам необходимо приобрести удочку. {"#cBL"}/gps - Бизнесы - охота и рыбалка{"#cWH"}." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Затем отправляйтесь в рыбацкие угодья. Используйте {"#cBL"}/gps - Прочее{"#cWH"}." ) ;
				}
				else if ( _q_id == 7 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Используйте {"#cBL"}/gps - Прочее{"#cWH"}, чтоб найти место регистрации на мероприятие." ) ;
				}
			}
			else if ( _id == 102 )
			{
				show_packet_quest ( playerid, 0, 0, 0 ) ;
				new _q_id = family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_quest ], _q_progress = family_info [ p_info [ playerid ] [ family ] - 1 ] [ fam_quest_progress ] ;
				
				static const _quest_progress [ ] =
				{
					70,
					36,
					42,
					5000,
					100,
					500,
					400,
					300
				} ;
				if ( _q_progress >= _quest_progress [ _q_id - 1 ] )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Используйте {"#cBL"}/gps - Прочее - Семейные задания{"#cWH"}, чтоб найти квестового персонажа." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Квестовый персонаж выдаст Вам вознагрождение." ) ;
					return 1 ;
				}
				
				if ( _q_id == 0 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Для начала ограбления Вы должны взять с собой ещё {"#cBL"}3ёх членов Вашей семьи{"#cWH"}." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}После отправляйтесь в любой бизнес (/gps - Бизнесы) и используйте {"#cBL"}/famrobbery{"#cWH"}." ) ;
				}
				else if ( _q_id == 1 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Посылка прибывает в случайное время, которое никто не знает." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Следите за чатом, в нём будет оповещение." ) ;
				}
				else if ( _q_id == 2 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Поставка прибывает в случайное время, которое никто не знает." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Следите за чатом, в нём будет оповещение." ) ;
				}
				else if ( _q_id == 3 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Вам необходимо приобрести удочку. {"#cBL"}/gps - Бизнесы - охота и рыбалка{"#cWH"}." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Затем отправляйтесь в рыбацкие угодья. Используйте {"#cBL"}/gps - Прочее{"#cWH"}." ) ;
				}
				else if ( _q_id == 4 || _q_id == 5 || _q_id == 6 )
				{
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Семейный рейтинг можно заработать захватывая поставки и посылки, граффити." ) ;
					SendClientMessage ( playerid, col_white, !"{"#cBInfo"}* {"#cWH"}Используйте {"#cBL"}/help{"#cWH"} для получения информации." ) ;
				}
			}
		}
		else if ( _param2 == 2 ) return quest_menu_cancel ( playerid ) ;
	}
	else if ( _param1 == 1 )
	{
		if ( _param2 == 1 )
		{
			set_player_use_listitem ( playerid, _param3 ) ;
			if ( _param3 < 100 )
			{
				new _chain = quest_chain_active ( playerid ) ;
				if ( _chain != -1 )
				{
					new _k = _param3, _str [ 24 ], _money = 0, _exp = 0 ;

					if ( _chain == 0 )
					{
						_money = quest_rewards [ _k ] [ r_money ] ;
						_exp = quest_rewards [ _k ] [ r_exp ] ;
					}
					else if ( _chain == 1 )
					{
						_money = quest_rewards_2 [ _k ] [ r_money ] ;
						_exp = quest_rewards_2 [ _k ] [ r_exp ] ;
					}
					else
					{
						_money = quest_rewards_3 [ _k ] [ r_money ] ;
						_exp = quest_rewards_3 [ _k ] [ r_exp ] ;
					}

					if ( _money > 0 )
					{
						format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( _money ) ) ;
						addQuestRewardsItem ( playerid, 0, 1212, _str ) ;
					}
					if ( _exp > 0 )
					{
						format ( _str, sizeof _str, "%d exp", _exp ) ;
						addQuestRewardsItem ( playerid, 0, 2684, _str ) ;
					}

					new _name [ 32 ], _text [ 128 ] ;
					if ( _chain == 0 )
					{
						format ( _name, sizeof _name, "%s", quest_info [ _k ] [ q_name ] ) ;
						format ( _text, sizeof _text, "%s", quest_info [ _k ] [ q_text ] ) ;
					}
					else if ( _chain == 1 )
					{
						format ( _name, sizeof _name, "%s", quest_info_2 [ _k ] [ q_name ] ) ;
						format ( _text, sizeof _text, "%s", quest_info_2 [ _k ] [ q_text ] ) ;
					}
					else
					{
						format ( _name, sizeof _name, "%s", quest_info_3 [ _k ] [ q_name ] ) ;
						format ( _text, sizeof _text, "%s", quest_info_3 [ _k ] [ q_text ] ) ;
					}

					new _select = quest_select [ playerid ] [ _chain ], _max = quest_menu_target ( _chain, _k ), _progress = 0 ;
					if ( _k < _select ) _progress = _max ;
					else if ( _k == _select ) _progress = quest_progress [ playerid ] [ _chain ] ;

					new _str2 [ 48 ], _str3 [ 32 ] ;
					format ( _str2, sizeof _str2, "Прогресс: %d из %d", _progress, _max ) ;
					format ( _str3, sizeof _str3, "%d%", quest_percent ( _progress, _max ) ) ;
					updateQuestsData ( playerid, _name, _str3, _progress, _max, _str2, _text ) ;
				}
				quest_menu_buttons ( playerid, _param3 ) ;
			}
			else if ( _param3 == 100 )
			{
				new _max_emp = p_info [ playerid ] [ rank ] + NEED_EMPLOYMENT_TO_RANK ;
				if ( mayor_player ( playerid ) || gov_player ( playerid ) )
				{
					if ( _max_emp > MAX_MAYOR_EMP_INFO ) _max_emp = MAX_MAYOR_EMP_INFO ;
				}
				else if ( cop_player ( playerid ) || fbi_player ( playerid ) )
				{
					if ( _max_emp > MAX_POLICE_EMP_INFO ) _max_emp = MAX_POLICE_EMP_INFO ;
				}
				else if ( army_player ( playerid ) )
				{
					if ( _max_emp > MAX_ARMY_EMP_INFO ) _max_emp = MAX_ARMY_EMP_INFO ;
				}
				else if ( medic_player ( playerid ) )
				{
					if ( _max_emp > MAX_MEDIC_EMP_INFO ) _max_emp = MAX_MEDIC_EMP_INFO ;
				}
				else if ( mafia_player ( playerid ) )
				{
					if ( _max_emp > MAX_MAFIA_EMP_INFO ) _max_emp = MAX_MAFIA_EMP_INFO ;
				}

				new _count_player = 0 ;
				for ( new i = 0 ; i < MAX_EMPLOYMENT ; i ++ )
				{
					if ( ! p_info [ playerid ] [ emp_status ] [ i ] ) continue ;
					
					_count_player ++ ;
				}
				
				new _str [ 48 ], _str2 [ 32 ] ;
				format ( _str, sizeof _str, "Выполнено / Нужно заданий: %d / %d", _count_player, _max_emp ) ;
				format ( _str2, sizeof _str2, "%d%", quest_percent ( _count_player, _max_emp ) ) ;
				updateQuestsData ( playerid, "Повышение ранга", _str2, _count_player, _max_emp, _str, "Выполняйте задания для повышения Вашей должности в организации.\nЕсли Вы достигли максимального ранга для авто-повышения, то можете просто выполнять задания и получать награду." ) ;
				addQuestRewardsItem ( playerid, -1, 21, "Разное" ) ;
				setQuestButtons ( playerid, "Список заданий", false ) ;
			}
			else if ( _param3 == 101 )
			{
				static const _quest_progress [ ] =
				{
					10,
					20,
					1,
					1,
					10,
					50,
					100,
					1
				} ;
		
				new _str [ 24 ], _quest_id = p_info [ playerid ] [ family_quest ] ;
				if ( family_rewards [ _quest_id - 1 ] [ r_money ] > 0 )
				{
					format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( family_rewards [ _quest_id - 1 ] [ r_money ] ) ) ;
					addQuestRewardsItem ( playerid, 0, 1212, _str ) ;
				}
				if ( family_rewards [ _quest_id - 1 ] [ r_exp ] > 0 )
				{
					format ( _str, sizeof _str, "%d "family_title_abb"", family_rewards [ _quest_id - 1 ] [ r_exp ] ) ;
					addQuestRewardsItem ( playerid, 0, 2684, _str ) ;
				}
				
				new _str3 [ 48 ], _str2 [ 32 ] ;
				format ( _str3, sizeof _str3, "Прогресс: %d из %d", p_info [ playerid ] [ family_quest_progress ], _quest_progress [ _quest_id - 1 ] ) ;
				format ( _str2, sizeof _str2, "%d%", quest_percent ( p_info [ playerid ] [ family_quest_progress ], _quest_progress [ _quest_id - 1 ] ) ) ;
				updateQuestsData ( playerid, quest_family_info [ _quest_id - 1 ] [ q_name ], _str2, p_info [ playerid ] [ family_quest_progress ], _quest_progress [ _quest_id - 1 ], _str3, quest_family_info [ _quest_id - 1 ] [ q_text ] ) ;
				setQuestButtons ( playerid, "Подсказка", false ) ;
			}
			else if ( _param3 == 102 )
			{
				static const _quest_progress [ ] =
				{
					70,
					36,
					42,
					5000,
					100,
					500,
					400,
					300
				} ;

				new _str [ 24 ], _fam_id = p_info [ playerid ] [ family ], _quest_id = family_info [ _fam_id - 1 ] [ fam_quest ] ;
				if ( all_family_rewards [ _quest_id - 1 ] [ r_money ] > 0 )
				{
					format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( all_family_rewards [ _quest_id - 1 ] [ r_money ] ) ) ;
					addQuestRewardsItem ( playerid, 0, 1212, _str ) ;
				}
				if ( all_family_rewards [ _quest_id - 1 ] [ r_exp ] > 0 )
				{
					format ( _str, sizeof _str, "%d "family_title_abb"", all_family_rewards [ _quest_id - 1 ] [ r_exp ] ) ;
					addQuestRewardsItem ( playerid, 0, 2684, _str ) ;
				}
				
				new _str3 [ 48 ], _str2 [ 32 ] ;
				format ( _str3, sizeof _str3, "Прогресс: %d из %d", family_info [ _fam_id - 1 ] [ fam_quest_progress ], _quest_progress [ _quest_id - 1 ] ) ;
				format ( _str2, sizeof _str2, "%d%", quest_percent ( family_info [ _fam_id - 1 ] [ fam_quest_progress ], _quest_progress [ _quest_id - 1 ] ) ) ;
				updateQuestsData ( playerid, all_family_quest [ _quest_id - 1 ] [ q_name ], _str2, family_info [ _fam_id - 1 ] [ fam_quest_progress ], _quest_progress [ _quest_id - 1 ], _str3, all_family_quest [ _quest_id - 1 ] [ q_text ] ) ;
				setQuestButtons ( playerid, "Подсказка", false ) ;
			}
		}
	}
	return 1 ;
}

stock quest_menu_cards ( playerid )
{
	new _q_count = 0, _chain = quest_chain_active ( playerid ) ;
	if ( _chain != -1 )
	{
		new _select = quest_select [ playerid ] [ _chain ], _status = quest_status [ playerid ] [ _chain ] ;
		for ( new k = 0 ; k < MAX_QUESTS ; k ++ )
		{
			new _name [ 32 ], _head [ 24 ], _max = quest_menu_target ( _chain, k ), _progress = 0 ;

			if ( _chain == 0 ) format ( _name, sizeof _name, "%s", quest_info [ k ] [ q_name ] ) ;
			else if ( _chain == 1 ) format ( _name, sizeof _name, "%s", quest_info_2 [ k ] [ q_name ] ) ;
			else format ( _name, sizeof _name, "%s", quest_info_3 [ k ] [ q_name ] ) ;

			if ( k < _select )
			{
				format ( _head, sizeof _head, "Выполнено" ) ;
				_progress = _max ;
			}
			else if ( k == _select )
			{
				if ( _status == 0 ) format ( _head, sizeof _head, "Не взято" ) ;
				else if ( _status == 2 ) format ( _head, sizeof _head, "Готово к сдаче" ) ;
				else format ( _head, sizeof _head, "В процессе" ) ;

				_progress = quest_progress [ playerid ] [ _chain ] ;
			}
			else format ( _head, sizeof _head, "Недоступно" ) ;

			addQuestsItem ( playerid, k, 2, quest_actor [ 0 ] [ actor_skin ], _name, _head, _progress, _max ) ;
			_q_count ++ ;
		}
	}
	
	if ( p_info [ playerid ] [ member ] > 0 )
	{
		new _max_emp = p_info [ playerid ] [ rank ] + NEED_EMPLOYMENT_TO_RANK ;
		if ( mayor_player ( playerid ) || gov_player ( playerid ) )
		{
			if ( _max_emp > MAX_MAYOR_EMP_INFO ) _max_emp = MAX_MAYOR_EMP_INFO ;
		}
		else if ( cop_player ( playerid ) || fbi_player ( playerid ) )
		{
			if ( _max_emp > MAX_POLICE_EMP_INFO ) _max_emp = MAX_POLICE_EMP_INFO ;
		}
		else if ( army_player ( playerid ) )
		{
			if ( _max_emp > MAX_ARMY_EMP_INFO ) _max_emp = MAX_ARMY_EMP_INFO ;
		}
		else if ( medic_player ( playerid ) )
		{
			if ( _max_emp > MAX_MEDIC_EMP_INFO ) _max_emp = MAX_MEDIC_EMP_INFO ;
		}
		else if ( mafia_player ( playerid ) )
		{
			if ( _max_emp > MAX_MAFIA_EMP_INFO ) _max_emp = MAX_MAFIA_EMP_INFO ;
		}

		new _count_player = 0 ;
		for ( new i = 0 ; i < MAX_EMPLOYMENT ; i ++ )
		{
			if ( ! p_info [ playerid ] [ emp_status ] [ i ] ) continue ;
			
			_count_player ++ ;
		}
		
		
		addQuestsItem ( playerid, 100, 2, p_info [ playerid ] [ org_skin ], "Повышение ранга", "В процессе", _count_player, _max_emp ) ;
		_q_count ++ ;
	}
	if ( p_info [ playerid ] [ family ] > 0 )
	{
		new _fam_id = p_info [ playerid ] [ family ] ;
		if ( family_info [ _fam_id - 1 ] [ fam_quest ] != -1 )
		{
			static const _quest_progress [ ] =
			{
				70,
				36,
				42,
				5000,
				100,
				500,
				400,
				300
			} ;
			
			if ( ! family_info [ _fam_id - 1 ] [ fam_quest ] || family_info [ _fam_id - 1 ] [ fam_quest ] )
			{
				if ( ! family_info [ _fam_id - 1 ] [ fam_quest ] )
				{
					family_info [ _fam_id - 1 ] [ fam_quest ] = random ( 8 ) + 1 ;
					family_info [ _fam_id - 1 ] [ fam_quest_progress ] = 0 ;
					
					new sql_string [ 99 + 4 + 9 ] ;
					format ( sql_string, sizeof sql_string, "UPDATE `family` SET `fam_quest` = '%d', `fam_quest_progress` = '0' WHERE `fam_id` = '%d' LIMIT 1", family_info [ _fam_id - 1 ] [ fam_quest ], family_info [ _fam_id - 1 ] [ fam_id ] ) ;
					mysql_tquery ( sql_connection, sql_string ) ;
				}
				
				new _quest_id = family_info [ _fam_id - 1 ] [ fam_quest ] ;
				addQuestsItem ( playerid, 102, 2, 113, all_family_quest [ _quest_id - 1 ] [ q_name ], "В процессе", family_info [ _fam_id - 1 ] [ fam_quest_progress ], _quest_progress [ _quest_id - 1 ] ) ;
				_q_count ++ ;
			}
		}
		
		if ( p_info [ playerid ] [ family_quest ] != -1 )
		{
			static const _quest_progress [ ] =
			{
				10,
				20,
				1,
				1,
				10,
				50,
				100,
				1
			} ;
			
			if ( ! p_info [ playerid ] [ family_quest ] || p_info [ playerid ] [ family_quest ] )
			{
				if ( ! p_info [ playerid ] [ family_quest ] )
				{
					p_info [ playerid ] [ family_quest ] = random ( 8 ) + 1 ;
					p_info [ playerid ] [ family_quest_progress ] = 0 ;
					
					new sql_string [ 106 + 4 + 9 ] ;
					format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_family_quest` = '%d', `u_family_quest_progress` = '0' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ family_quest ], p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, sql_string ) ;
				}
			
				new _quest_id = p_info [ playerid ] [ family_quest ] ;
				addQuestsItem ( playerid, 101, 2, 113, quest_family_info [ _quest_id - 1 ] [ q_name ], "В процессе", p_info [ playerid ] [ family_quest_progress ], _quest_progress [ _quest_id - 1 ] ) ;
				_q_count ++ ;
			}
		}
	}
	new _chain_now = quest_chain_active ( playerid ) ;
	if ( _chain_now != -1 ) selectQuestItem ( playerid, quest_select [ playerid ] [ _chain_now ] ) ;

	return _q_count ;
}

stock quest_menu_refresh ( playerid )
{
	clearQuestItems ( playerid ) ;
	if ( ! quest_menu_cards ( playerid ) ) questsShow ( playerid, true ) ;
	return 1 ;
}

stock quest_menu_show ( playerid )
{
	questsShow ( playerid, false ) ;
	if ( ! quest_menu_cards ( playerid ) ) questsShow ( playerid, true ) ;

	toggle_controlable ( playerid, false ) ;

	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	return 1 ;
}

CMD:testq ( playerid )
{
	return quest_menu_show ( playerid ) ;
}