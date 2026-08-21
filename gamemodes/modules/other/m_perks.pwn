#define MAX_PERKS 17

enum
{
	d_perks = 22222,
	d_perks_update
} ;

enum
{
	PERK_ALCOHOLIC = 0,
	PERK_COLLECTIONER,
	PERK_FUELL,
	PERK_BAR,
	PERK_QUEST,
	PERK_JOBMAN,
	PERK_BOMBILA,
	PERK_MECHANIC,
	PERK_UTILIZATOR,
	PERK_OGUREC,
	PERK_TORCHOK,
	PERK_TURIST,
	PERK_MAFIA,
	PERK_TAZER,
	PERK_ECONOMIC,
	PERK_AUTO,
	PERK_ADMIN_FRIEND
} ;

enum _perks
{
	perk_max_lvl,
	perk_next_lvl,
	perk_name [ 24 ],
	perk_level,
	perk_icon
} ;

new perk_info [ MAX_PERKS ] [ _perks ] =
{
	{ 12, 1, "Алкаш", 1, 58 },
	{ 5, 1, "Коллекционер мелочи", 1, 59 },
	{ 10, 2, "Любитель заправки", 1, 60 },
	{ 5, 1, "Завсегдатай бара", 1, 61 },
	{ 5, 2, "Квестовый маньяк", 2, 62 },
	{ 5, 1, "Работяга", 2, 63 },
	{ 5, 3, "Бомбила", 4, 64 },
	{ 5, 3, "Механик", 4, 65 },
	{ 5, 3, "Утилизатор", 5, 66 },
	{ 5, 1, "Огурчик", 5, 67 },
	{ 2, 5, "Торчок", 7, 68 },
	{ 7, 1, "Турист", 10, 69 },
	{ 5, 3, "Мафиози", 10, 70 },
	{ 4, 3, "Мастер тазера", 10, 71 },
	{ 1, 10, "Экономист", 20, 72 },
	{ 2, 10, "Автолюбитель", 20, 73 },
	{ 1, 20, "Друг админов", 30, 74 }
} ;

stock show_perks ( playerid )
{
	global_string [ 0 ] = EOS ;
	strcat ( global_string, "{"#cBL"}Название:\t{"#cBL"}Прогресс:\t{"#cBL"}Требуемый игровой уровень:\n" ) ;
	
	new line_string [ 100 ] ;
	for ( new i = 0 ; i < MAX_PERKS ; i ++ )
	{
		format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}%s\t%d из %d\t%d\n", perk_info [ i ] [ perk_name ], p_info [ playerid ] [ perk_lvl ] [ i ], perk_info [ i ] [ perk_max_lvl ], perk_info [ i ] [ perk_level ] ) ;
		strcat ( global_string, line_string ) ;
	}
	
	line_string [ 0 ] = EOS ;
	format ( line_string, sizeof line_string, "{"#cBHD"}Доступно очков: {"#cWH"}%d шт.", p_info [ playerid ] [ perks ] ) ;
	show_dialog ( playerid, d_perks, DIALOG_STYLE_TABLIST_HEADERS, line_string, global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_perks_info ( playerid, _perk_id )
{
	static const _perks_params [ ] [ 100 ] =
	{
		"Увеличивает количество HP при пополнении из бара + алкоголь меньше опьяняет.",
		"Уменьшает стоимость предметов в 24/7.",
		"Уменьшает стоимость бензина на заправках.",
		"Уменьшает стоимость напитков в баре.",
		"Повышение награды за выполнение квестов.",
		"Повышение награды за любую работу.",
		"Увеличивает прибыль на дежурстве таксиста.",
		"Увеличивает прибыль на дежурстве механика.",
		"Увеличивает стоимость утилизации автомобиля.",
		"Уменьшает шанс заболеть.",
		"Увеличивает количество HP, получаемых от наркотиков, а также снижает наркотическое опьянение.",
		"Уменьшение потери хп от РП системы голода.",
		"Уменьшает вероятность сотрудникам ПО обнаружить запрещённые вещества при обыске.",
		"Снижает время перезарядки электрошокера.",
		"Уменьшает налоги на транспортное средство.",
		"Уменьшает цены на автомобили в автосалонах.",
		"Увеличивает кол-во максимальных варнов до 4."
	} ;
			
	new perk_string [ 70 ] ;
	if ( perk_info [ _perk_id ] [ perk_level ] > p_info [ playerid ] [ level ] ) format ( perk_string, sizeof perk_string, "{"#cRD"}* Ваш игровой уровень слишком низок для этого перка!\n\n" ) ;
	else format ( perk_string, sizeof perk_string, "" ) ;
		
	new _perk_next_lvl [ 30 ] ;
	if ( perk_info [ _perk_id ] [ perk_max_lvl ] > p_info [ playerid ] [ perk_lvl ] [ _perk_id ] ) format ( _perk_next_lvl, sizeof _perk_next_lvl, "%d очков", perk_info [ _perk_id ] [ perk_next_lvl ] ) ;
	else format ( _perk_next_lvl, sizeof _perk_next_lvl, "У Вас максимальный уровень" ) ;
			
	global_string [ 0 ] = EOS ;
	format ( global_string, 256, "%s{"#cWH"}%s\n\nУровень прокачки: %d из %d\nСтоимость прокачки: %s", perk_string, _perks_params [ _perk_id ], p_info [ playerid ] [ perk_lvl ] [ _perk_id ], perk_info [ _perk_id ] [ perk_max_lvl ], _perk_next_lvl ) ;
			
	new header_string [ 32 ] ;
	format ( header_string, sizeof header_string, "{"#cBHD"}%s", perk_info [ _perk_id ] [ perk_name ] ) ;
	show_dialog ( playerid, d_perks_update, DIALOG_STYLE_MSGBOX, header_string, global_string, "Прокачать", "Назад" ) ;
	return 1 ;
}

stock perks_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_perks:
		{
			if ( ! response ) return 1 ;
			
			set_player_use_listitem ( playerid, listitem ) ;
			show_perks_info ( playerid, listitem ) ;
			return 1 ;
		}
		case d_perks_update:
		{
			if ( ! response ) return show_perks ( playerid ) ;
			
			new _perk_id = get_player_use_listitem ( playerid ) ;
			if ( _perk_id > MAX_PERKS ) return 1 ;
			if ( p_info [ playerid ] [ perks ] < perk_info [ _perk_id ] [ perk_next_lvl ] )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно очков для прокачки перка." ) ;
				show_perks_info ( playerid, _perk_id ) ;
				return 1 ;
			}
			
			if ( perk_info [ _perk_id ] [ perk_level ] > p_info [ playerid ] [ level ] )
			{
				show_perks_info ( playerid, _perk_id ) ;
				return 1 ;
			}
			
			if ( perk_info [ _perk_id ] [ perk_max_lvl ] <= p_info [ playerid ] [ perk_lvl ] [ _perk_id ] )
			{
				show_perks_info ( playerid, _perk_id ) ;
				return 1 ;
			}
			
			p_info [ playerid ] [ perks ] -= perk_info [ _perk_id ] [ perk_next_lvl ] ;
			p_info [ playerid ] [ perk_lvl ] [ _perk_id ] += 1 ;
			
			new sql_string [ 135 + ( 9 * 2 ) ] ;
			format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_perks` = '%d', `u_perk_lvl` = '%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d' WHERE `u_id` = '%d' LIMIT 1",
			p_info [ playerid ] [ perks ],
			p_info [ playerid ] [ perk_lvl ] [ 0 ], p_info [ playerid ] [ perk_lvl ] [ 1 ], p_info [ playerid ] [ perk_lvl ] [ 2 ], 
			p_info [ playerid ] [ perk_lvl ] [ 3 ], p_info [ playerid ] [ perk_lvl ] [ 4 ], p_info [ playerid ] [ perk_lvl ] [ 5 ], 
			p_info [ playerid ] [ perk_lvl ] [ 6 ], p_info [ playerid ] [ perk_lvl ] [ 7 ], p_info [ playerid ] [ perk_lvl ] [ 8 ], 
			p_info [ playerid ] [ perk_lvl ] [ 9 ], p_info [ playerid ] [ perk_lvl ] [ 10 ], p_info [ playerid ] [ perk_lvl ] [ 11 ], 
			p_info [ playerid ] [ perk_lvl ] [ 12 ], p_info [ playerid ] [ perk_lvl ] [ 13 ], p_info [ playerid ] [ perk_lvl ] [ 14 ], 
			p_info [ playerid ] [ perk_lvl ] [ 15 ], p_info [ playerid ] [ perk_lvl ] [ 16 ], p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
			
			show_perks ( playerid ) ;
			give_event_progress ( playerid, THE_PERK, 1 ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock get_perk_info ( playerid, _type_perk )
{
	new _perk_count, _perk_lvl = p_info [ playerid ] [ perk_lvl ] [ _type_perk ] ;
	if ( _type_perk == PERK_ALCOHOLIC )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 1 ;
			case 2: _perk_count = 2 ;
			case 3: _perk_count = 2 ;
			case 4: _perk_count = 2 ;
			case 5: _perk_count = 4 ;
			case 6: _perk_count = 4 ;
			case 7: _perk_count = 4 ;
			case 8: _perk_count = 4 ;
			case 9: _perk_count = 4 ;
			case 10: _perk_count = 5 ;
			case 11: _perk_count = 5 ;
			case 12: _perk_count = 7 ;
		}
	}
	else if ( _type_perk == PERK_COLLECTIONER )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 5 ;
			case 2: _perk_count = 10 ;
			case 3: _perk_count = 12 ;
			case 4: _perk_count = 15 ;
			case 5: _perk_count = 20 ;
		}
	}
	else if ( _type_perk == PERK_FUELL )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 2 ;
			case 2: _perk_count = 5 ;
			case 3: _perk_count = 7 ;
			case 4: _perk_count = 10 ;
			case 5: _perk_count = 12 ;
			case 6: _perk_count = 15 ;
			case 7: _perk_count = 17 ;
			case 8: _perk_count = 20 ;
			case 9: _perk_count = 23 ;
			case 10: _perk_count = 25 ;
		}
	}
	else if ( _type_perk == PERK_BAR )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 3 ;
			case 2: _perk_count = 5 ;
			case 3: _perk_count = 10 ;
			case 4: _perk_count = 15 ;
			case 5: _perk_count = 20 ;
		}
	}
	else if ( _type_perk == PERK_QUEST )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 3 ;
			case 2: _perk_count = 5 ;
			case 3: _perk_count = 10 ;
			case 4: _perk_count = 15 ;
			case 5: _perk_count = 20 ;
		}
	}
	else if ( _type_perk == PERK_JOBMAN )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 3 ;
			case 2: _perk_count = 5 ;
			case 3: _perk_count = 10 ;
			case 4: _perk_count = 15 ;
			case 5: _perk_count = 20 ;
		}
	}
	else if ( _type_perk == PERK_BOMBILA )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 3 ;
			case 2: _perk_count = 5 ;
			case 3: _perk_count = 7 ;
			case 4: _perk_count = 10 ;
			case 5: _perk_count = 15 ;
		}
	}
	else if ( _type_perk == PERK_MECHANIC )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 3 ;
			case 2: _perk_count = 5 ;
			case 3: _perk_count = 7 ;
			case 4: _perk_count = 10 ;
			case 5: _perk_count = 15 ;
		}
	}
	else if ( _type_perk == PERK_UTILIZATOR )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 5 ;
			case 2: _perk_count = 10 ;
			case 3: _perk_count = 15 ;
			case 4: _perk_count = 20 ;
			case 5: _perk_count = 25 ;
		}
	}
	else if ( _type_perk == PERK_OGUREC )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 10 ;
			case 2: _perk_count = 20 ;
			case 3: _perk_count = 30 ;
			case 4: _perk_count = 40 ;
			case 5: _perk_count = 50 ;
		}
	}
	else if ( _type_perk == PERK_TORCHOK )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 15 ;
			case 1: _perk_count = 20 ;
			case 2: _perk_count = 25 ;
		}
	}
	else if ( _type_perk == PERK_TURIST )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 3 ;
			case 1: _perk_count = 4 ;
			case 2: _perk_count = 5 ;
			case 3: _perk_count = 6 ;
			case 4: _perk_count = 7 ;
			case 5: _perk_count = 8 ;
			case 6: _perk_count = 9 ;
			case 7: _perk_count = 10 ;
		}
	}
	else if ( _type_perk == PERK_MAFIA )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 5 ;
			case 2: _perk_count = 10 ;
			case 3: _perk_count = 15 ;
			case 4: _perk_count = 20 ;
			case 5: _perk_count = 25 ;
		}
	}
	else if ( _type_perk == PERK_TAZER )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 60 ;
			case 1: _perk_count = 30 ;
			case 2: _perk_count = 28 ;
			case 3: _perk_count = 25 ;
			case 4: _perk_count = 22 ;
		}
	}
	else if ( _type_perk == PERK_ECONOMIC )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 10 ;
		}
	}
	else if ( _type_perk == PERK_AUTO )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 0 ;
			case 1: _perk_count = 10 ;
			case 2: _perk_count = 20 ;
		}
	}
	else if ( _type_perk == PERK_ADMIN_FRIEND )
	{
		switch ( _perk_lvl )
		{
			case 0: _perk_count = 3 ;
			case 1: _perk_count = 4 ;
		}
	}
	return _perk_count ;
}