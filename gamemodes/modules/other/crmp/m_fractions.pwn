#define MAX_AUTO_RANK 				5
#define NEED_EMPLOYMENT_TO_RANK		2
new player_employment_tick [ MAX_PLAYERS ] ;

enum _emp_info
{
	emp_icon,
	emp_name [ 32 ],
	emp_max,
	emp_description [ 256 ],
	emp_help [ 256 ],
	emp_model [ 5 ],
	bool: emp_random
} ;

#define MAX_ARMY_EMP_INFO 7
new army_emp_info [ MAX_ARMY_EMP_INFO ] [ _emp_info ] =
{
	{ 2, "Доставка боеприпасов", 25, "Доставьте 25 ящиков с боеприпасами на склады гос. организаций. (/armpanel)", "Возьмите грузовик с парковки организации и следуйте подсказкам.", { 1, 9, -1, -1, -1 }, false },
	{ 2, "Подводная лодка", 1, "Захватите контроль над подводной лодкой 1 раз", "Подлодка прибывает в случайное время.\nКогда она прибудет, то в чате появится оповещение.", { 45, -1, -1, -1, -1 }, false },
	{ 2, "Контрабанда", 1, "Перехватите посылку для криминальных организаций 1 раз", "Посылка сбрасывается в случайное время.\nКогда она прибудет, то в чате появится оповещение.", { 49, -1, -1, -1, -1 }, false },
	{ 2, "Охрана базы", 3, "Остановите 3ёх преступников, которые проникли на военную базу", "Убивайте посторонних на военной базе.", { 89, -1, -1, -1, -1 }, false },
	{ 2, "Конфискация", 1, "Примите участие в конфискации", "Соберите состав и отправляйтесь на базу криминальной организации.\nПо прибытию используйте /confisc.", { 40, -1, -1, -1, -1 }, false },
	{ 2, "Склад", 1, "Возьмите что-нибудь со склада организации.", "Отправляйтесь в оружейную и исследуйте склад на наличие вооружения.", { 3, -1, -1, -1, -1 }, false },
	{ 2, "Военный билет", 1, "Получите военный билет.", "Вам необходимо отыграть 15 часов в организации и получить 3 ранг.", { 89, 90, 92, -1, -1 }, false }
} ;

#define MAX_POLICE_EMP_INFO 8
new police_emp_info [ MAX_POLICE_EMP_INFO ] [ _emp_info ] =
{
	{ 2, "Обыск", 25, "Обыщите 25 человек.", "Используйте /frisk для проверки содержимого карманов у игроков.", { 1, 9, -1, -1, -1 }, false },
	{ 2, "Штрафы", 10, "Выпишите 10 штрафов.", "Выписывайте штрафы игрокам, которые нарушают. (/ticket)", { 84, -1, -1, -1, -1 }, false },
	{ 2, "Склад", 1, "Возьмите что-нибудь со склада организации.", "Отправляйтесь в оружейную и исследуйте склад на наличие вооружения.", { 9, -1, -1, -1, -1 }, false },
	{ 2, "Опасные преступники", 5, "Поймайте 5ых преступников с 4+ уровнем розыска.", "Используйте /wanted для поиска преступников и не забывайте о напарнике.\nНаграда в этом задании выдаётся случайная из представленых.", { 12047, 12048, 12049, 12050, 12051 }, true },
	{ 2, "Тренировка", 1, "Посетите тренировочный комплекс", "Найдите на Вашей базе тренировочный комплекс и посетите его.", { 1, -1, -1, -1, -1 }, false },
	{ 2, "Подводная лодка", 1, "Захватите контроль над подводной лодкой 1 раз", "Подлодка прибывает в случайное время.\nКогда она прибудет, то в чате появится оповещение.\nНаграда в этом задании выдаётся случайная из представленых.", { 1, 1, 2, 8, 9 }, true },
	{ 2, "Контрабанда", 1, "Перехватите посылку для криминальных организаций 1 раз", "Посылка сбрасывается в случайное время.\nКогда она прибудет, то в чате появится оповещение.\nНаграда в этом задании выдаётся случайная из представленых.", { 1, 1, 2, 8, 9 }, true },
	{ 2, "Волк в овечей шкуре", 10, "Проверьте содержимое карманов у военных", "Отправляйтесь на военную базу и проверьте военных на наличие запрещённых предметов.\nИспользуйте /frisk для обыска.", { 9, -1, -1, -1, -1 }, false }
} ;

#define MAX_MAYOR_EMP_INFO 3
new mayor_emp_info [ MAX_MAYOR_EMP_INFO ] [ _emp_info ] =
{
	{ 2, "Опечатка", 1, "Опечатайте недвижимость.", "Возьмите в интерьере Мэрии задание на опечатку имущества.", { 9, -1, -1, -1, -1 }, false },
	{ 2, "Тренировка", 1, "Посетите тренировочный комплекс", "Найдите на Вашей базе тренировочный комплекс и посетите его.", { 95, -1, -1, -1, -1 }, false },
	{ 2, "Адвокат", 5, "Рассмотрите дела 5и заключённых", "Отправляйтесь в КПЗ в отделении полиции или в тюрьму.\nИспользуйте /free для помощи игрокам.", { 1, 7, -1, -1, -1 }, false }
} ;

#define MAX_MEDIC_EMP_INFO 6
new medic_emp_info [ MAX_MEDIC_EMP_INFO ] [ _emp_info ] =
{
	{ 2, "Лечение", 20, "Вылечите 20 игроков.", "Используйте /heal.", { 1, 7, -1, -1, -1 }, false },
	{ 2, "Доктор", 5, "Примите 5 вызовов.", "Используйте /gomedhelp.", { 95, -1, -1, -1, -1 }, false },
	{ 2, "Мед. карта", 5, "Выдайте 10 мед. карт.", "Используйте /givemc.", { 45, -1, -1, -1, -1 }, false },
	{ 2, "Доставка", 1000, "Развезите 1.000 аптечек по складам организаций.", "Возьмите транспорт с парковки организации и следуйте подсказкам.", { 45, 7, -1, -1, -1 }, false },
	{ 2, "Военный врач", 10, "Проведите мед. осмотр у 10 военных.", "Выдайте мед. карту, вылечите если необходимо.", { 1, 7, -1, -1, -1 }, false },
	{ 2, "Мед. осмотр", 10, "Проведите мед. осмотр у 10 полицейских.", "Выдайте мед. карту, вылечите если необходимо.", { 1, 7, -1, -1, -1 }, false }
} ;

#define MAX_GANG_EMP_INFO 2
new gang_emp_info [ MAX_GANG_EMP_INFO ] [ _emp_info ] =
{
	{ 2, "Лечение", 20, "Вылечите 20 игроков", "Используя команду /heal вылечите 20 игроков.", { 1, 9, -1, -1, -1 }, false },
	{ 2, "Доктор", 5, "Примите 5 вызовов", "Используя /goheal примите 5 вызовов.", { 4, -1, -1, -1, -1 }, false }
} ;

#define MAX_MAFIA_EMP_INFO 7
new mafia_emp_info [ MAX_MAFIA_EMP_INFO ] [ _emp_info ] =
{
	{ 2, "Захват", 1, "Примите участие в захвате.", "Убейте 5 человек на захвате из конкурирующей организации.", { 1, 7, -1, -1, -1 } },
	{ 2, "Подводная лодка", 1, "Захватите контроль над подводной лодкой 1 раз", "Подлодка прибывает в случайное время.\nКогда она прибудет, то в чате появится оповещение.\nНаграда в этом задании выдаётся случайная из представленых.", { 89, 90, 92, 93, 87 }, true },
	{ 2, "Контрабанда", 1, "Перехватите посылку для криминальных организаций 1 раз", "Посылка сбрасывается в случайное время.\nКогда она прибудет, то в чате появится оповещение.\nНаграда в этом задании выдаётся случайная из представленых.", { 128, 95, 7, 9, 0 }, true },
	{ 2, "Боеприпасы", 3, "Украдите со склада армии 3 раза", "Отправляйтесь на военную базу и обвариуйте её.\nИщите пикапы с вооружением.", { 7, -1, -1, -1, -1 }, false },
	{ 2, "Hitman's", 3, "Выполните 3 заказа на убийство.", "В подвале на Вашей базе можно взять заказ на убийство.\nЧтоб заказать убийство используйте /contract.", { 9, -1, -1, -1, -1 }, false },
	{ 2, "Банк", 1, "Ограбьте банк.", "В подвале на Вашей базе можно начать ограбление банка.\nСоберите команду из 4ёх человек и вперёд!", { 1, -1, -1, -1, -1 }, false },
	{ 2, "Доставка боеприпасов", 25, "Доставьте 25 ящиков с боеприпасами на склад Вашей организации.", "Вы можете пополнить его, как оружием, так и аптечками.", { 1, 7, -1, -1, -1 }, false }
} ;

#include <custom/fraction_packet>

stock show_employment_player ( playerid )
{
	new _fr_id = p_info [ playerid ] [ member ] ;
	if ( _fr_id > 0 )
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
		
		empShow ( playerid, false ) ;
		if ( p_info [ playerid ] [ rank ] > MAX_AUTO_RANK ) empHeaderText ( playerid, "Вы достигли максимальный ранг для авто-повышений", "" ) ;
		else empHeaderText ( playerid, "Задания для повышения на ранг", f_rank [ _fr_id - 1 ] [ p_info [ playerid ] [ rank ] ] ) ;
		
		new _count_player = 0, _str [ 12 ], _str2 [ 12 ] ;
		for ( new i = 0 ; i < MAX_EMPLOYMENT ; i ++ )
		{
			if ( ! p_info [ playerid ] [ emp_status ] [ i ] ) continue ;
			
			_count_player ++ ;
		}
		format ( _str, sizeof _str, "%d", _count_player ) ;
		format ( _str2, sizeof _str2, " / %d", _max_emp ) ;
		if ( _count_player >= _max_emp && p_info [ playerid ] [ rank ] <= MAX_AUTO_RANK ) empStatistic ( playerid, true, true, _max_emp, _count_player, _str, _str2, "Выполнено / Нужно заданий" ) ;
		else empStatistic ( playerid, true, false, _max_emp, _count_player, _str, _str2, "Выполнено / Нужно заданий" ) ;
		empGlobalInfo ( playerid, "Трудовая книжка", f_info [ _fr_id - 1 ] [ f_name ] ) ;
		empTaskItem ( playerid, _fr_id ) ;
	}
	else
	{
		empShow ( playerid, true ) ;
		empHeaderText ( playerid, "Вы не состоите в организации", "" ) ;
		empStatistic ( playerid, false, false, 100, 0, "", "", "" ) ;
		empGlobalInfo ( playerid, "Трудовая книжка", "" ) ;
	}
	empTopTable ( playerid, false ) ;
            
	toggle_controlable ( playerid, false ) ;

	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	return 1 ;
}

stock give_emp_progress ( playerid, _q_id, _progress )
{
	if ( p_info [ playerid ] [ member ] < 1 ) return 1 ;
	if ( p_info [ playerid ] [ emp_status ] [ _q_id ] ) return 1 ;
	
	if ( mayor_player ( playerid ) || gov_player ( playerid ) )
	{
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= mayor_emp_info [ _q_id ] [ emp_max ] ) return 1 ;
		
		p_info [ playerid ] [ emp_progress ] [ _q_id ] += _progress ;
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= mayor_emp_info [ _q_id ] [ emp_max ] ) p_info [ playerid ] [ emp_status ] [ _q_id ] = true ;
		
		new _item ;
		if ( mayor_emp_info [ _q_id ] [ emp_random ] )
		{
			_item = mayor_emp_info [ _q_id ] [ emp_model ] [ random ( 5 ) ] ;
			give_player_item_prise ( playerid, _item, 1 ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _item ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		else
		{
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				_item = mayor_emp_info [ _q_id ] [ emp_model ] [ i ] ;
				if ( _item == -1 ) continue ;
				
				give_player_item_prise ( playerid, _item, 1 ) ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _item ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
		}
	}
	else if ( cop_player ( playerid ) || fbi_player ( playerid ) )
	{
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= police_emp_info [ _q_id ] [ emp_max ] ) return 1 ;
		
		p_info [ playerid ] [ emp_progress ] [ _q_id ] += _progress ;
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= police_emp_info [ _q_id ] [ emp_max ] ) p_info [ playerid ] [ emp_status ] [ _q_id ] = true ;
		
		new _item ;
		if ( police_emp_info [ _q_id ] [ emp_random ] )
		{
			_item = police_emp_info [ _q_id ] [ emp_model ] [ random ( 5 ) ] ;
			give_player_item_prise ( playerid, _item, 1 ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _item ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		else
		{
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				_item = police_emp_info [ _q_id ] [ emp_model ] [ i ] ;
				if ( _item == -1 ) continue ;
				
				give_player_item_prise ( playerid, _item, 1 ) ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _item ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
		}
	}
	else if ( army_player ( playerid ) )
	{
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= army_emp_info [ _q_id ] [ emp_max ] ) return 1 ;
		
		p_info [ playerid ] [ emp_progress ] [ _q_id ] += _progress ;
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= army_emp_info [ _q_id ] [ emp_max ] ) p_info [ playerid ] [ emp_status ] [ _q_id ] = true ;
		
		new _item ;
		if ( army_emp_info [ _q_id ] [ emp_random ] )
		{
			_item = army_emp_info [ _q_id ] [ emp_model ] [ random ( 5 ) ] ;
			give_player_item_prise ( playerid, _item, 1 ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _item ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		else
		{
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				_item = army_emp_info [ _q_id ] [ emp_model ] [ i ] ;
				if ( _item == -1 ) continue ;
				
				give_player_item_prise ( playerid, _item, 1 ) ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _item ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
		}
	}
	else if ( medic_player ( playerid ) )
	{
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= medic_emp_info [ _q_id ] [ emp_max ] ) return 1 ;
		
		p_info [ playerid ] [ emp_progress ] [ _q_id ] += _progress ;
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= medic_emp_info [ _q_id ] [ emp_max ] ) p_info [ playerid ] [ emp_status ] [ _q_id ] = true ;
		
		new _item ;
		if ( medic_emp_info [ _q_id ] [ emp_random ] )
		{
			_item = medic_emp_info [ _q_id ] [ emp_model ] [ random ( 5 ) ] ;
			give_player_item_prise ( playerid, _item, 1 ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _item ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		else
		{
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				_item = medic_emp_info [ _q_id ] [ emp_model ] [ i ] ;
				if ( _item == -1 ) continue ;
				
				give_player_item_prise ( playerid, _item, 1 ) ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _item ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
		}
	}
	else if ( mafia_player ( playerid ) )
	{
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= mafia_emp_info [ _q_id ] [ emp_max ] ) return 1 ;
		
		p_info [ playerid ] [ emp_progress ] [ _q_id ] += _progress ;
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= mafia_emp_info [ _q_id ] [ emp_max ] ) p_info [ playerid ] [ emp_status ] [ _q_id ] = true ;
		
		new _item ;
		if ( mafia_emp_info [ _q_id ] [ emp_random ] )
		{
			_item = mafia_emp_info [ _q_id ] [ emp_model ] [ random ( 5 ) ] ;
			give_player_item_prise ( playerid, _item, 1 ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _item ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		else
		{
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				_item = mafia_emp_info [ _q_id ] [ emp_model ] [ i ] ;
				if ( _item == -1 ) continue ;
				
				give_player_item_prise ( playerid, _item, 1 ) ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _item ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
		}
	}
	
	new sql_string [ 512 ] ;
	format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_emp_status` = '%d|%d|%d|%d|%d|%d|%d|%d|%d|%d', `u_emp_progress` = '%d|%d|%d|%d|%d|%d|%d|%d|%d|%d' WHERE `u_id` = '%d' LIMIT 1",
	p_info [ playerid ] [ emp_status ] [ 0 ], p_info [ playerid ] [ emp_status ] [ 1 ], p_info [ playerid ] [ emp_status ] [ 2 ], p_info [ playerid ] [ emp_status ] [ 3 ], p_info [ playerid ] [ emp_status ] [ 4 ],
	p_info [ playerid ] [ emp_status ] [ 5 ], p_info [ playerid ] [ emp_status ] [ 6 ], p_info [ playerid ] [ emp_status ] [ 7 ], p_info [ playerid ] [ emp_status ] [ 8 ], p_info [ playerid ] [ emp_status ] [ 9 ],
	p_info [ playerid ] [ emp_progress ] [ 0 ], p_info [ playerid ] [ emp_progress ] [ 1 ], p_info [ playerid ] [ emp_progress ] [ 2 ], p_info [ playerid ] [ emp_progress ] [ 3 ], p_info [ playerid ] [ emp_progress ] [ 4 ],
	p_info [ playerid ] [ emp_progress ] [ 5 ], p_info [ playerid ] [ emp_progress ] [ 6 ], p_info [ playerid ] [ emp_progress ] [ 7 ], p_info [ playerid ] [ emp_progress ] [ 8 ], p_info [ playerid ] [ emp_progress ] [ 9 ],
	p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, sql_string ) ;
	return 1 ;
}

stock show_packet_fraction ( playerid, _param1, _param2, _param3 )
{
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 )
		{
			empHide ( playerid ) ;
            
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
			new _fr_id = p_info [ playerid ] [ member ] ;
			if ( _fr_id > 0 )
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
				
				empShow ( playerid, false ) ;
				if ( p_info [ playerid ] [ rank ] > MAX_AUTO_RANK ) empHeaderText ( playerid, "Вы достигли максимальный ранг для авто-повышений", "" ) ;
				else empHeaderText ( playerid, "Задания для повышения на ранг", f_rank [ _fr_id - 1 ] [ p_info [ playerid ] [ rank ] ] ) ;
				
				new _count_player = 0, _str [ 12 ], _str2 [ 12 ] ;
				for ( new i = 0 ; i < MAX_EMPLOYMENT ; i ++ )
				{
					if ( ! p_info [ playerid ] [ emp_status ] [ i ] ) continue ;
					
					_count_player ++ ;
				}
				format ( _str, sizeof _str, "%d", _count_player ) ;
				format ( _str2, sizeof _str2, " / %d", _max_emp ) ;
				if ( _count_player >= _max_emp && p_info [ playerid ] [ rank ] <= MAX_AUTO_RANK ) empStatistic ( playerid, true, true, _max_emp, _count_player, _str, _str2, "Выполнено / Нужно заданий" ) ;
				else empStatistic ( playerid, true, false, _max_emp, _count_player, _str, _str2, "Выполнено / Нужно заданий" ) ;
				empGlobalInfo ( playerid, "Трудовая книжка", f_info [ _fr_id - 1 ] [ f_name ] ) ;
				empTaskItem ( playerid, _fr_id ) ;
			}
			else
			{
				empShow ( playerid, true ) ;
				empHeaderText ( playerid, "Вы не состоите в организации", "" ) ;
				empStatistic ( playerid, false, false, 100, 0, "", "", "" ) ;
				empGlobalInfo ( playerid, "Трудовая книжка", "" ) ;
			}
			empTopTable ( playerid, false ) ;
		}
		else if ( _param2 == 2 )
		{
			if ( GetTickCount ( ) - player_employment_tick [ playerid ] < 15000 )
			{
				send_check_cinfo ( playerid, "Просматривать историю можно раз в 15 секунд.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			empTopTable ( playerid, true ) ;
			empHeaderText ( playerid, "Вы просматриваете историю организаций игрока", p_info [ playerid ] [ name ] ) ;
			empStatistic ( playerid, false, false, 100, 0, "", "", "" ) ;
			empGlobalInfo ( playerid, "", "" ) ;
			
			static const _str [ ] = "SELECT * FROM `users_jobinfo` WHERE `ji_uid` = '%d' ORDER BY `users_jobinfo`.`ji_id` DESC LIMIT 50" ;
			new query_string [ sizeof _str + 9 ] ;
			format ( query_string, sizeof ( query_string ), _str, p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, query_string, "employment_callback", "i", playerid ) ;
			
			player_employment_tick [ playerid ] = GetTickCount ( ) ;
		}
		else if ( _param2 == 3 )
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
			
			new _count_player = 0, _str [ 12 ], _str2 [ 12 ], _fr_id = p_info [ playerid ] [ member ] ;
			for ( new i = 0 ; i < MAX_EMPLOYMENT ; i ++ )
			{
				if ( ! p_info [ playerid ] [ emp_status ] [ i ] ) continue ;
					
				_count_player ++ ;
			}
			
			gettime_clear_employment ( playerid ) ;
			
			if ( _count_player >= _max_emp && p_info [ playerid ] [ rank ] <= MAX_AUTO_RANK )
			{
				empShow ( playerid, false ) ;
				if ( p_info [ playerid ] [ rank ] > MAX_AUTO_RANK ) empHeaderText ( playerid, "Вы достигли максимальный ранг для авто-повышений", "" ) ;
				else empHeaderText ( playerid, "Задания для повышения на ранг", f_rank [ _fr_id - 1 ] [ p_info [ playerid ] [ rank ] ] ) ;
			
				p_info [ playerid ] [ rank ] += 1 ;
				update_int_sql ( playerid, "u_rank", p_info [ playerid ] [ rank ] ) ;
				
				format ( _str, sizeof _str, "%d", _count_player ) ;
				format ( _str2, sizeof _str2, " / %d", _max_emp ) ;
				if ( _count_player >= _max_emp && p_info [ playerid ] [ rank ] <= MAX_AUTO_RANK ) empStatistic ( playerid, true, true, _max_emp, _count_player, _str, _str2, "Выполнено / Нужно заданий" ) ;
				else empStatistic ( playerid, true, false, _max_emp, _count_player, _str, _str2, "Выполнено / Нужно заданий" ) ;
				empGlobalInfo ( playerid, "Трудовая книжка", f_info [ _fr_id - 1 ] [ f_name ] ) ;
				empTaskItem ( playerid, _fr_id ) ;
			}
			else send_check_cinfo ( playerid, "Вы достигли максимального ранга по авто-повышению.", 0, 300, CINFO_FRACTION_GUNS_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
		}
	}
	else if ( _param1 == 1 )
	{
		if ( _param2 == 1 )
		{
			if ( mayor_player ( playerid ) || gov_player ( playerid ) )
			{
				if ( _param3 >= MAX_MAYOR_EMP_INFO ) return 1 ;
			}
			else if ( cop_player ( playerid ) || fbi_player ( playerid ) )
			{
				if ( _param3 >= MAX_POLICE_EMP_INFO ) return 1 ;
			}
			else if ( army_player ( playerid ) )
			{
				if ( _param3 >= MAX_ARMY_EMP_INFO ) return 1 ;
			}
			else if ( medic_player ( playerid ) )
			{
				if ( _param3 >= MAX_MEDIC_EMP_INFO ) return 1 ;
			}
			else if ( mafia_player ( playerid ) )
			{
				if ( _param3 >= MAX_MAFIA_EMP_INFO ) return 1 ;
			}
			
			empSubTaskItem ( playerid, p_info [ playerid ] [ member ], _param3 ) ;
		}
		else if ( _param2 == 2 )
		{
			if ( mayor_player ( playerid ) || gov_player ( playerid ) )
			{
				if ( _param3 >= MAX_MAYOR_EMP_INFO ) return 1 ;
			}
			else if ( cop_player ( playerid ) || fbi_player ( playerid ) )
			{
				if ( _param3 >= MAX_POLICE_EMP_INFO ) return 1 ;
			}
			else if ( army_player ( playerid ) )
			{
				if ( _param3 >= MAX_ARMY_EMP_INFO ) return 1 ;
			}
			else if ( medic_player ( playerid ) )
			{
				if ( _param3 >= MAX_MEDIC_EMP_INFO ) return 1 ;
			}
			else if ( mafia_player ( playerid ) )
			{
				if ( _param3 >= MAX_MAFIA_EMP_INFO ) return 1 ;
			}
			
			global_string [ 0 ] = EOS ;
			if ( mayor_player ( playerid ) || gov_player ( playerid ) ) format ( global_string, 312, "{"#cWH"}%s", mayor_emp_info [ _param3 ] [ emp_help ] ) ;
			else if ( cop_player ( playerid ) || fbi_player ( playerid ) ) format ( global_string, 312, "{"#cWH"}%s", police_emp_info [ _param3 ] [ emp_help ] ) ;
			else if ( army_player ( playerid ) ) format ( global_string, 312, "{"#cWH"}%s", army_emp_info [ _param3 ] [ emp_help ] ) ;
			else if ( medic_player ( playerid ) ) format ( global_string, 312, "{"#cWH"}%s", medic_emp_info [ _param3 ] [ emp_help ] ) ;
			else if ( mafia_player ( playerid ) ) format ( global_string, 312, "{"#cWH"}%s", mafia_emp_info [ _param3 ] [ emp_help ] ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", global_string, "Принять", "" ) ;
		}
	}
	return 1 ;
}

stock gettime_clear_employment ( playerid )
{
	for ( new i = 0 ; i < MAX_EMPLOYMENT ; i ++ )
	{
		p_info [ playerid ] [ emp_status ] [ i ] = 0 ;
		p_info [ playerid ] [ emp_progress ] [ i ] = 0 ;
	}
	
	new sql_string [ 512 ] ;
	format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_emp_status` = '%d|%d|%d|%d|%d|%d|%d|%d|%d|%d', `u_emp_progress` = '%d|%d|%d|%d|%d|%d|%d|%d|%d|%d' WHERE `u_id` = '%d' LIMIT 1",
	p_info [ playerid ] [ emp_status ] [ 0 ], p_info [ playerid ] [ emp_status ] [ 1 ], p_info [ playerid ] [ emp_status ] [ 2 ], p_info [ playerid ] [ emp_status ] [ 3 ], p_info [ playerid ] [ emp_status ] [ 4 ],
	p_info [ playerid ] [ emp_status ] [ 5 ], p_info [ playerid ] [ emp_status ] [ 6 ], p_info [ playerid ] [ emp_status ] [ 7 ], p_info [ playerid ] [ emp_status ] [ 8 ], p_info [ playerid ] [ emp_status ] [ 9 ],
	p_info [ playerid ] [ emp_progress ] [ 0 ], p_info [ playerid ] [ emp_progress ] [ 1 ], p_info [ playerid ] [ emp_progress ] [ 2 ], p_info [ playerid ] [ emp_progress ] [ 3 ], p_info [ playerid ] [ emp_progress ] [ 4 ],
	p_info [ playerid ] [ emp_progress ] [ 5 ], p_info [ playerid ] [ emp_progress ] [ 6 ], p_info [ playerid ] [ emp_progress ] [ 7 ], p_info [ playerid ] [ emp_progress ] [ 8 ], p_info [ playerid ] [ emp_progress ] [ 9 ],
	p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, sql_string ) ;
	return 1 ;
}

stock show_employment ( playerid, targetid )
{
	empShow ( targetid, false ) ;
	empHeaderText ( targetid, "Вы просматриваете историю организаций игрока", p_info [ playerid ] [ name ] ) ;
	empStatistic ( targetid, false, false, 100, 0, "", "", "" ) ;
	empGlobalInfo ( targetid, "", "" ) ;
	empTopTable ( targetid, true ) ;
			
	static const _str [ ] = "SELECT * FROM `users_jobinfo` WHERE `ji_uid` = '%d' ORDER BY `users_jobinfo`.`ji_id` DESC LIMIT 50" ;
	new query_string [ sizeof _str + 9 ] ;
	format ( query_string, sizeof ( query_string ), _str, p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, query_string, "employment_callback", "i", targetid ) ;
	
	send_check_cinfo ( playerid, "Сменив раздел Вы переключитесь на свою статистику.", 0, 300, CINFO_FRACTION_GUNS_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
	return 1 ;
}

callback: employment_callback ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;

	if ( rows )
	{
		new BitStream:bitstream = BS_New();
		BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
		BS_WriteValue(bitstream, PR_UINT32, RPC_FRACTION);
		
		BS_WriteValue(bitstream, PR_INT8, 8);
		BS_WriteValue(bitstream, PR_UINT8, rows);
		
	    global_string [ 0 ] = EOS ;
		new line_string [ 128 ], ji_date [ 16 ], ji_reason [ 32 ], ji_fraction, ji_rank, ji_type ;
		for ( new i = 0 ; i < rows ; i ++ )
		{
			ji_fraction = cache_get_field_content_int ( i, "ji_fraction", sql_connection ) ;
			ji_rank = cache_get_field_content_int ( i, "ji_rank", sql_connection ) ;
			ji_type = cache_get_field_content_int ( i, "ji_type", sql_connection ) ;

			cache_get_field_content ( i, "ji_date", ji_date, sql_connection, 16 ) ;
			cache_get_field_content ( i, "ji_reason", ji_reason, sql_connection, 32 ) ;

			format ( line_string, sizeof line_string, "%s", f_info [ ji_fraction - 1 ] [ f_name ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;

			switch ( ji_type )
			{
				case LABOR_TYPE_INVITE: format ( line_string, sizeof line_string, "/invite" ) ;
				case LABOR_TYPE_UNINVITE: format ( line_string, sizeof line_string, "/uninvite" ) ;
				case LABOR_TYPE_UNINVITE_LEAVE: format ( line_string, sizeof line_string, "/leave" ) ;
				case LABOR_TYPE_NEXT_RANG: format ( line_string, sizeof line_string, "/rank" ) ;
				case LABOR_TYPE_BACK_RANG: format ( line_string, sizeof line_string, "/rank" ) ;
				case LABOR_TYPE_TICKET: format ( line_string, sizeof line_string, "/fwarn" ) ;
			}
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;

			switch ( ji_type )
			{
				case LABOR_TYPE_INVITE: format ( line_string, sizeof line_string, "Был назначен на должность %s", f_rank [ ji_fraction - 1 ] [ ji_rank - 1 ] ) ;
				case LABOR_TYPE_UNINVITE: format ( line_string, sizeof line_string, "Был уволен с должности %s по причине: %s", f_rank [ ji_fraction - 1 ] [ ji_rank - 1 ] ) ;
				case LABOR_TYPE_UNINVITE_LEAVE: format ( line_string, sizeof line_string, "Покинул должность %s по собственному желанию", f_rank [ ji_fraction - 1 ] [ ji_rank - 1 ] ) ;
				case LABOR_TYPE_NEXT_RANG: format ( line_string, sizeof line_string, "Повышен до должности %s", f_rank [ ji_fraction - 1 ] [ ji_rank - 1 ] ) ;
				case LABOR_TYPE_BACK_RANG: format ( line_string, sizeof line_string, "Понижен до должности %s", f_rank [ ji_fraction - 1 ] [ ji_rank - 1 ] ) ;
				case LABOR_TYPE_TICKET: format ( line_string, sizeof line_string, "Получил выговор по причине: %s", f_rank [ ji_fraction - 1 ] [ ji_rank - 1 ] ) ;
			}
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;

			format ( line_string, sizeof line_string, "-" ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;

			format ( line_string, sizeof line_string, "%s", ji_date ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
		}

		PR_SendPacket(bitstream, playerid);

		BS_Delete(bitstream);
	}
	else send_check_cinfo ( playerid, "У Вас нет истории трудоустройства.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
	return 1 ;
}