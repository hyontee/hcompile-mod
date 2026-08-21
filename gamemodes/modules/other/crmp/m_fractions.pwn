enum FRACTION_ACTOR_STRUCT
{
	TASKS_ACTOR_SKIN, 
	Float: TASKS_ACTOR [ 4 ],
	TASKS_ACTOR_INT,
	TASKS_ACTOR_VW,

	INVITE_ACTOR_SKIN,
	Float: INVITE_ACTOR [ 4 ],
	INVITE_ACTOR_INT,
	INVITE_ACTOR_VW,

	Float: INVITE_GPS [ 3 ],
	FRACTION_ACTOR_ID,

	FRACTION_DESCRIPTION [ 144 ]
} ;

new FRACTION_ACTOR [ ] [ FRACTION_ACTOR_STRUCT ] =
{
	{ // mayour
		55, { 82.391, -1995.545, 951.000, 5.870 }, 13, 10, // tasks actor
		216, { 39.142, -1985.438, 951.000, 174.712 }, 13, 10, // invite actor
		{ -317.8642, 725.5924, 12.0625 }, // invite actor gps
		1, // fraction id
		"3х летняя прописка"
	},
	{ // police
		242, { 917.564, 9.766, 1405.674, 271.974 }, 1, 1, // tasks actor
		242, { 907.002, 10.183, 1405.690, 143.449 }, 1, 1, // invite actor
		{ 211.6654, 1379.4928, 11.9219 }, // invite actor gps
		4, // fraction id
		"3х летняя прописка\nВоенный билет\nБыть законопослушным"
	},
	{ // police
		242, { 917.564, 9.766, 1405.674, 271.974 }, 1, 2, // tasks actor
		242, { 907.002, 10.183, 1405.690, 143.449 }, 1, 2, // invite actor
		{ 2581.6452, -2434.9899, 21.7972 }, // invite actor gps
		5, // fraction id
		"3х летняя прописка\nВоенный билет\nБыть законопослушным"
	},
	{ // fbi
		140, { -657.804, -2.921, 660.782, 269.024 }, 16, 300, // tasks actor
		140, { -649.063, 3.930, 660.785, 172.797 }, 16, 300, // invite actor
		{ 2412.2810, -1849.9652, 21.8573 }, // invite actor gps
		7, // fraction id
		"3х летняя прописка\nВоенный билет\nБыть законопослушным"
	},
	{ // army
		236, { -1402.988, 288.081, 1401.000, 247.520 }, 18, 1, // tasks actor
		236, { 1901.069, 1712.168, 15.887, 281.948 }, 0, 0, // invite actor
		{ 1901.069, 1712.168, 15.887 }, // invite actor gps
		8, // fraction id
		"3х летняя прописка"
	},
	{ // turma
		130, { 795.221, -857.557, 1503.990, 44.061 }, 20, 1, // tasks actor
		130, { 779.502, -857.529, 1503.990, 291.780 }, 20, 1, // invite actor
		{ -1773.6077, -2770.5070, 13.9966 }, // invite actor gps
		12, // fraction id
		"3х летняя прописка\nВоенный билет\nБыть законопослушным"
	},
	{ // hospital
		145, { -732.806, -498.034, 944.961, 43.227 }, 2, 1, // tasks actor
		145, { -751.082, -497.024, 944.961, 308.865 }, 2, 1, // invite actor
		{ -286.5593, 583.0414, 12.1202 }, // invite actor gps
		15, // fraction id
		"3х летняя прописка"
	},
	{ // radio
		216, { 859.990, 2675.338, 1008.625, 235.488 }, 10, 2, // tasks actor
		216, { 847.944, 2672.465, 1008.625, 130.902 }, 10, 2, // invite actor
		{ 1826.2534, 2095.8588, 15.8540 }, // invite actor gps
		27, // fraction id
		"3х летняя прописка"
	}
} ;

#define MAX_AUTO_INVITE_QUESTIONS 8
static playerInviteTrueAnswer [ MAX_PLAYERS ] = { 0, ... } ;
static autoInviteQuestions [ MAX_AUTO_INVITE_QUESTIONS ] [ 52 ] =
{
	"Разрешено ли возвращаться на место выхода?",
	"Что такое зеленая зона?",
	"Разрешено ли убивать игроков без причины?",
	"Что такое ООС информация?",
	"Что будет сотруднику за нарушение правил устава?",
	"Что такое IC информация?",
	"Разрешено ли убивать коллег из организации?",
	"Что такое RolePlay?"
} ;

static autoInviteAnswers [ MAX_AUTO_INVITE_QUESTIONS ] [ 4 ] [ 64 ] =
{
	{
		"Разрешено. Я могу вернуться чтобы продолжить свои дела",
		"Запрещено. Это противоречит правилам сервера",
		"Разрешено если хочешь отомстить обидчику",
		"Разрешено если я не участвовал в перестрелке"
	},
	{
		"Зона в которой нужно убивать игроков",
		"Зона для применения насилия",
		"Зона, запрещающая наносить урон игрокам",
		"Зона, разрешающая нарушать правила игры"
	},
	{
		"Разрешено. Я могу убить игрока если он мне мешает",
		"Разрешено. Я не получу за это никакого наказания",
		"Запрещено",
		"Только с разрешения администрации"
	},
	{
		"Информация из игрового процесса",
		"Информация вне игрового процесса",
		"Информация от лидера",
		"Информация от администрации"
	},
	{
		"Повысят",
		"Дадут конфетку",
		"Дадут по еб*алу",
		"Дадут выговор либо уволят из организации"
	},
	{
		"Информация из игрового процесса",
		"Информация вне игрового процесса",
		"Информация от лидера",
		"Информация от админов"
	},
	{
		"Разрешено. Мне за это ничего не будет",
		"Запрещено. Это нарушает правила игры",
		"Разрешено. Коллега не гражданский",
		"А когда не разрешено"
	},
	{
		"Игра по правилам",
		"Игра по ролям",
		"Игра без правил",
		"Игра по уставу организации"
	}
} ;

static autoInviteTrueAnswer [ MAX_AUTO_INVITE_QUESTIONS ] =
{
	1,
	3,
	3,
	2,
	4,
	1,
	2,
	2
} ;

static stock showAutoInviteQuestion ( playerid )
{
	new idx = get_player_use_listitem ( playerid ) ;
	global_string [ 0 ] = EOS ;
	format ( global_string, sizeof global_string, "{"#cBL"}%s\n{"#cWH"}* %s\n* %s\n* %s\n* %s", 
	autoInviteQuestions [ idx ],
	autoInviteAnswers [ idx ] [ 0 ], autoInviteAnswers [ idx ] [ 1 ],
	autoInviteAnswers [ idx ] [ 2 ], autoInviteAnswers [ idx ] [ 3 ] ) ;
	show_dialog ( playerid, d_auto_invite_test, DIALOG_STYLE_LIST, "{"#cBHD"}Теоритическая часть", global_string, "Выбрать", "Отмена" ) ;
	return true ;
}

stock startAutoInviteQuestion ( playerid )
{
	if ( p_info [ playerid ] [ ai_cooldown ] > gettime ( ) )
	{
		new s_year, s_month, s_day, s_hour, s_minute, s_second ;
		timestamp_to_date ( p_info [ playerid ] [ ai_cooldown ] + CONVERT_TIME_TO_MOSCOW, s_year, s_month, s_day, s_hour, s_minute, s_second ) ;

		global_string [ 0 ] = EOS ;
		format ( global_string, 144, "Повторно пройти тест можно будет %02d.%02d.%d в %02d:%02d:%02d", s_day, s_month, s_year, s_hour, s_minute, s_second ) ;
		send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return false ;
	}

	if ( p_info [ playerid ] [ hour_played ] < THREE_HOUR_PLAYED )
	{
		send_check_cinfo ( playerid, "Доступно с 3 часов в игре!\nИспользуйте /mm - Информация о персонаже - Статистика персонажа", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return false ;
	}

	if ( ! GetInventoryFindItem ( playerid, SUB_INVENTORY, 2173 ) )
	{
		send_check_cinfo ( playerid, "У Вас нет паспорта! Получить его можно в Мэрии", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return false ;
	}

	new areaId = used_area [ playerid ], fractionId = area_info [ areaId ] [ a_item ] ;
	switch ( fractionId )
	{
		case 4, 5, 12:
		{
			if ( ! GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_MILITARY_ID ) )
			{
				send_check_cinfo ( playerid, "У Вас нет военного билета! Получить его можно в армии или /donate", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return false ;
			}
			if ( p_info [ playerid ] [ law_obedience ] < 30 )
			{
				send_check_cinfo ( playerid, "\
					У Вас нехватает законопослушности. Необходимо 30 законопослушности\n\
					Законопослушность повышается каждый час проведённый в игре\n\
					Законопослушность уменьшается за убийство игроков", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return false ;
			}
		}
		case 7:
		{
			if ( ! GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_MILITARY_ID ) )
			{
				send_check_cinfo ( playerid, "У Вас нет военного билета! Получить его можно в армии или /donate", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return false ;
			}
			if ( p_info [ playerid ] [ law_obedience ] < 50 )
			{
				send_check_cinfo ( playerid, "\
					У Вас нехватает законопослушности. Необходимо 50 законопослушности\n\
					Законопослушность повышается каждый час проведённый в игре\n\
					Законопослушность уменьшается за убийство игроков", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return false ;
			}
		}
	}

	set_player_use_listitem ( playerid, 0 ) ;
	playerInviteTrueAnswer [ playerid ] = 0 ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 512, "\
	{"#cBL"}** Вступление в %s **\n\n\
	{"#cWH"}Вам необходимо пройти тестирование\n\
	состощее из {"#cTN"}%d {"#cWH"}вопросов.\n\n\
	{"#cGRDialog"}* Вы готовы начать тестирование?", f_info [ fractionId - 1 ] [ f_name ], MAX_AUTO_INVITE_QUESTIONS ) ;
	show_dialog ( playerid, d_auto_invite_start, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Вступление в организацию", global_string, "Начать", "Отмена" ) ;
	return true ;
}

stock fractions_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_auto_invite_start:
		{
			if ( ! response ) return true ;

			showAutoInviteQuestion ( playerid ) ;
			return true ;
		}
		case d_auto_invite_test:
		{
			if ( ! response ) return true ;

			new idx = get_player_use_listitem ( playerid ) ;
			if ( listitem - 1 == autoInviteTrueAnswer [ idx ] )
				playerInviteTrueAnswer [ playerid ] ++ ;

			if ( idx < MAX_AUTO_INVITE_QUESTIONS - 1 )
			{
				set_player_use_listitem ( playerid, idx + 1 ) ;
				showAutoInviteQuestion ( playerid ) ;
			}
			else
			{
				global_string [ 0 ] = EOS ;
				if ( playerInviteTrueAnswer [ playerid ] == MAX_AUTO_INVITE_QUESTIONS )
				{
					new areaId = used_area [ playerid ],
						fractionId = area_info [ areaId ] [ a_item ] ;

					p_info [ playerid ] [ member ] = fractionId ;
					p_info [ playerid ] [ rank ] = 1 ;
					day_invite_player [ fractionId - 1 ] += 1 ;

					new _skin_invite ;
					if ( f_info [ fractionId - 1 ] [ f_skin_type ] == 1 ) _skin_invite = f_skin_rank [ fractionId - 1 ] [ p_info [ playerid ] [ gender ] ] [ 0 ] ;
					else _skin_invite = f_skin_invite [ fractionId - 1 ] [ p_info [ playerid ] [ gender ] ] ;

					p_info [ playerid ] [ org_skin ] = _skin_invite ;
					SetPlayerSkin ( playerid, p_info [ playerid ] [ org_skin ] ) ;

					SetPlayerColor ( playerid, f_info [ fractionId - 1 ] [ f_radar_color ] ) ;

					p_info [ playerid ] [ spawnchange ] = 2 ;
					p_info [ playerid ] [ org_date ] = 0 ;

					Iter_Add ( fraction_players[fractionId], playerid ) ;
					fractionUserInsert ( playerid ) ;
					ResetFractionTasks ( playerid, true ) ;

					f_info [ fractionId - 1 ] [ f_members ] ++ ;

					new dialog_string [ 128 ] ;
					format ( dialog_string, sizeof dialog_string, "UPDATE `fractions` SET `f_members` = '%d' WHERE `f_id` = '%d' LIMIT 1", f_info [ fractionId - 1 ] [ f_members ], fractionId ) ;
					mysql_tquery ( sql_connection, dialog_string ) ;

					format ( dialog_string, sizeof dialog_string, "{"#cGInfo"}* {"#cWH"}Вы успешно вступили в организацию \"%s\".", f_info [ fractionId - 1 ] [ f_name ] ) ;
					SendClientMessage ( playerid, col_white, dialog_string ) ;

					SendClientMessage ( playerid, col_green, !"* Вы успешно прошли тест!" ) ;
					if ( gang_player ( playerid ) || mafia_player ( playerid ) ) format ( dialog_string, sizeof dialog_string, "[F] %s присоединился к организации (Тестирование). Приветствуем!", p_info [ playerid ] [ name ] ) ;
					else format ( dialog_string, sizeof dialog_string, "[R] %s присоединился к организации (Тестирование). Приветствуем!", p_info [ playerid ] [ name ] ) ;
					fraction_message ( fractionId, col_lblue, dialog_string ) ;
					
					SendClientMessage ( playerid, col_wavy, !"Используйте {"#cWH"}/mm - Команды сервера {"#cWV"}для ознакомления с функционалом организации." ) ;

					insert_joblist ( playerid, "INVITE", LABOR_TYPE_INVITE ) ;
					give_event_progress ( playerid, THE_FRACTION, 1 ) ;
				}
				else
				{
					format ( global_string, 144, "* Вы ответили правильно на %d вопросов из %d. Тест не пройден!", playerInviteTrueAnswer [ playerid ], MAX_AUTO_INVITE_QUESTIONS ) ;
					SendClientMessage ( playerid, col_red, global_string ) ;
				}

				p_info [ playerid ] [ ai_cooldown ] = SetElapsedTime ( gettime ( ), 12, CONVERT_TIME_TO_HOURS ) ;
				update_int_sql ( playerid, "u_ai_cooldown", p_info [ playerid ] [ ai_cooldown ] ) ;
			}
			return true ;
		}
	}
	return false ;
}

stock fractions_OnGameModeInit ( )
{
	new actorId, areaId ;
	for ( new i = 0 ; i < sizeof FRACTION_ACTOR ; i ++ )
	{
		// tasks
		actorId = CreateActor (
			FRACTION_ACTOR [ i ] [ TASKS_ACTOR_SKIN ],
			FRACTION_ACTOR [ i ] [ TASKS_ACTOR ] [ 0 ],
			FRACTION_ACTOR [ i ] [ TASKS_ACTOR ] [ 1 ],
			FRACTION_ACTOR [ i ] [ TASKS_ACTOR ] [ 2 ],
			FRACTION_ACTOR [ i ] [ TASKS_ACTOR ] [ 3 ]
		) ;
		SetActorVirtualWorld ( actorId, FRACTION_ACTOR [ i ] [ TASKS_ACTOR_VW ] ) ;

		CreateDynamic3DTextLabel ( 
			"** Задания организации **", 
			col_header_3d, 
			FRACTION_ACTOR [ i ] [ TASKS_ACTOR ] [ 0 ],
			FRACTION_ACTOR [ i ] [ TASKS_ACTOR ] [ 1 ],
			FRACTION_ACTOR [ i ] [ TASKS_ACTOR ] [ 2 ] + 0.5, 
			5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, FRACTION_ACTOR [ i ] [ TASKS_ACTOR_VW ], FRACTION_ACTOR [ i ] [ TASKS_ACTOR_INT ]
		) ;

		areaId = CreateDynamicSphere ( FRACTION_ACTOR [ i ] [ TASKS_ACTOR ] [ 0 ], FRACTION_ACTOR [ i ] [ TASKS_ACTOR ] [ 1 ], FRACTION_ACTOR [ i ] [ TASKS_ACTOR ] [ 2 ], 3.0, FRACTION_ACTOR [ i ] [ TASKS_ACTOR_VW ], FRACTION_ACTOR [ i ] [ TASKS_ACTOR_INT ], -1 ) ;
        area_info [ areaId ] [ a_type ] = area_type_fraction_tasks ;
        area_info [ areaId ] [ a_item ] = FRACTION_ACTOR [ i ] [ FRACTION_ACTOR_ID ] ;

		// auto invite
		actorId = CreateActor (
			FRACTION_ACTOR [ i ] [ INVITE_ACTOR_SKIN ],
			FRACTION_ACTOR [ i ] [ INVITE_ACTOR ] [ 0 ],
			FRACTION_ACTOR [ i ] [ INVITE_ACTOR ] [ 1 ],
			FRACTION_ACTOR [ i ] [ INVITE_ACTOR ] [ 2 ],
			FRACTION_ACTOR [ i ] [ INVITE_ACTOR ] [ 3 ]
		) ;
		SetActorVirtualWorld ( actorId, FRACTION_ACTOR [ i ] [ INVITE_ACTOR_VW ] ) ;

		CreateDynamic3DTextLabel ( 
			"** Набор в организацию **", 
			col_header_3d, 
			FRACTION_ACTOR [ i ] [ INVITE_ACTOR ] [ 0 ],
			FRACTION_ACTOR [ i ] [ INVITE_ACTOR ] [ 1 ],
			FRACTION_ACTOR [ i ] [ INVITE_ACTOR ] [ 2 ] + 0.5, 
			5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, FRACTION_ACTOR [ i ] [ TASKS_ACTOR_VW ], FRACTION_ACTOR [ i ] [ TASKS_ACTOR_INT ]
		) ;

		areaId = CreateDynamicSphere ( FRACTION_ACTOR [ i ] [ INVITE_ACTOR ] [ 0 ], FRACTION_ACTOR [ i ] [ INVITE_ACTOR ] [ 1 ], FRACTION_ACTOR [ i ] [ INVITE_ACTOR ] [ 2 ], 3.0, FRACTION_ACTOR [ i ] [ INVITE_ACTOR_VW ], FRACTION_ACTOR [ i ] [ INVITE_ACTOR_INT ], -1 ) ;
        area_info [ areaId ] [ a_type ] = area_type_fraction_invite ;
        area_info [ areaId ] [ a_item ] = FRACTION_ACTOR [ i ] [ FRACTION_ACTOR_ID ] ;
	}
	return true ;
}

stock fractions_EnterDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_fraction_tasks:
		{
			new fractionId = area_info [ areaid ] [ a_item ] ;
			if ( p_info [ playerid ] [ member ] != fractionId )
			{
				send_check_cinfo ( playerid, "Вы не являетесь сотрудником данной организации!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return true ;
			}
			send_check_cinfo ( playerid, "Задания организации", 1, -1, CINFO_FRACTION_TASKS, PICTURE_INFO_SUCESS, "Задания", "" ) ;
			return true ;
		}
		case area_type_fraction_invite:
		{
			if ( p_info [ playerid ] [ member ] > 0 )
			{
				send_check_cinfo ( playerid, "Вы уже состоите в организации!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return true ;
			}
			send_check_cinfo ( playerid, "Набор в организацию", 1, -1, CINFO_FRACTION_INVITE, PICTURE_INFO_SUCESS, "Вступить", "" ) ;
			return true ;
		}
	}
	return false ;
}

stock fractions_LeaveDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_fraction_tasks:
		{
		    clear_check_info ( playerid, CINFO_FRACTION_TASKS ) ;
			return true ;
		}
		case area_type_fraction_invite:
		{
		    clear_check_info ( playerid, CINFO_FRACTION_INVITE ) ;
			return true ;
		}
	}
	return false ;
}

#define MAX_AUTO_RANK				5
#define MAX_FRACTION_TASKS			3
#define MAX_FRACTION_TASKS_DAY		5
#define MAX_FRACTION_TASKS_PRIZE	3

enum _emp_info
{
	EMP_ICON,
	EMP_NAME [ 32 ],
	EMP_MAX,
	EMP_DESCRIPTION [ 256 ],
	EMP_HELP [ 256 ],
	EMP_MODEL [ MAX_FRACTION_TASKS_PRIZE ]
} ;

#define MAX_ARMY_EMP_INFO 7
new ArmyEmpInfo [ MAX_ARMY_EMP_INFO ] [ _emp_info ] =
{
	{ 2, "Доставка боеприпасов", 25, "Доставьте 25 ящиков с боеприпасами на склады гос. организаций. (/armpanel)", "Возьмите грузовик с парковки организации и следуйте подсказкам.", { 2001, 2009, 2046 } },
	{ 2, "Подводная лодка", 1, "Захватите контроль над подводной лодкой 1 раз", "Подлодка прибывает в случайное время.\nКогда она прибудет, то в чате появится оповещение.", { 2045, 2046, -1 } },
	{ 2, "Контрабанда", 1, "Перехватите посылку для криминальных организаций 1 раз", "Посылка сбрасывается в случайное время.\nКогда она прибудет, то в чате появится оповещение.", { 2049, 2046, -1 } },
	{ 2, "Охрана базы", 3, "Остановите 3ёх преступников, которые проникли на военную базу", "Убивайте посторонних на военной базе.", { 2089, 2046, -1 } },
	{ 2, "Конфискация", 1, "Примите участие в конфискации", "Соберите состав и отправляйтесь на базу криминальной организации.\nПо прибытию используйте /confisc.", { 2040, 2046, -1 } },
	{ 2, "Склад", 1, "Возьмите что-нибудь со склада организации.", "Отправляйтесь в оружейную и исследуйте склад на наличие вооружения.", { 2003, 2046, -1 } },
	{ 2, "Военный билет", 1, "Получите военный билет.", "Вам необходимо отыграть 15 часов в организации и получить 3 ранг.", { 2089, 2090, 2092 } }
} ;

#define MAX_POLICE_EMP_INFO 8
new PoliceEmpInfo [ MAX_POLICE_EMP_INFO ] [ _emp_info ] =
{
	{ 2, "Обыск", 25, "Обыщите 25 человек.", "Используйте /frisk для проверки содержимого карманов у игроков.", { 2001, 2009, 2046 } },
	{ 2, "Штрафы", 10, "Выпишите 10 штрафов.", "Выписывайте штрафы игрокам, которые нарушают. (/ticket)", { 2084, 2046, -1 } },
	{ 2, "Склад", 1, "Возьмите что-нибудь со склада организации.", "Отправляйтесь в оружейную и исследуйте склад на наличие вооружения.", { 2009, 2046, -1 } },
	{ 2, "Опасные преступники", 5, "Поймайте 5ых преступников с 4+ уровнем розыска.", "Используйте /wanted для поиска преступников и не забывайте о напарнике.\nНаграда в этом задании выдаётся случайная из представленых.", { 12047, 12048, 12049 } },
	{ 2, "Тренировка", 1, "Посетите тренировочный комплекс", "Найдите на Вашей базе тренировочный комплекс и посетите его.", { 2001, 2046, -1 } },
	{ 2, "Подводная лодка", 1, "Захватите контроль над подводной лодкой 1 раз", "Подлодка прибывает в случайное время.\nКогда она прибудет, то в чате появится оповещение.\nНаграда в этом задании выдаётся случайная из представленых.", { 2001, 2001, 2002 } },
	{ 2, "Контрабанда", 1, "Перехватите посылку для криминальных организаций 1 раз", "Посылка сбрасывается в случайное время.\nКогда она прибудет, то в чате появится оповещение.\nНаграда в этом задании выдаётся случайная из представленых.", { 2001, 2001, 2002 } },
	{ 2, "Волк в овечей шкуре", 10, "Проверьте содержимое карманов у военных", "Отправляйтесь на военную базу и проверьте военных на наличие запрещённых предметов.\nИспользуйте /frisk для обыска.", { 2009, 2046, -1 } }
} ;

#define MAX_MAYOR_EMP_INFO 3
new MayorEmpInfo [ MAX_MAYOR_EMP_INFO ] [ _emp_info ] =
{
	{ 2, "Опечатка", 1, "Опечатайте недвижимость.", "Возьмите в интерьере Мэрии задание на опечатку имущества.", { 2009, 2046, -1 } },
	{ 2, "Тренировка", 1, "Посетите тренировочный комплекс", "Найдите на Вашей базе тренировочный комплекс и посетите его.", { 2095, 2046, -1 } },
	{ 2, "Адвокат", 5, "Рассмотрите дела 5и заключённых", "Отправляйтесь в КПЗ в отделении полиции или в тюрьму.\nИспользуйте /free для помощи игрокам.", { 2001, 2007, 2046 } }
} ;

#define MAX_MEDIC_EMP_INFO 6
new MedicEmpInfo [ MAX_MEDIC_EMP_INFO ] [ _emp_info ] =
{
	{ 2, "Лечение", 20, "Вылечите 20 игроков.", "Используйте /heal.", { 2001, 2007, 2046 } },
	{ 2, "Доктор", 5, "Примите 5 вызовов.", "Используйте /gomedhelp.", { 2095, 2046, -1 } },
	{ 2, "Мед. карта", 5, "Выдайте 10 мед. карт.", "Используйте /givemc.", { 2045, 2046, -1 } },
	{ 2, "Доставка", 1000, "Развезите 1.000 аптечек по складам организаций.", "Возьмите транспорт с парковки организации и следуйте подсказкам.", { 2045, 2007, 2046 } },
	{ 2, "Военный врач", 10, "Проведите мед. осмотр у 10 военных.", "Выдайте мед. карту, вылечите если необходимо.", { 2001, 2007, 2046 } },
	{ 2, "Мед. осмотр", 10, "Проведите мед. осмотр у 10 полицейских.", "Выдайте мед. карту, вылечите если необходимо.", { 2001, 2007, 2046 } }
} ;

#define MAX_MAFIA_EMP_INFO 7
new MafiaEmpInfo [ MAX_MAFIA_EMP_INFO ] [ _emp_info ] =
{
	{ 2, "Захват", 1, "Примите участие в захвате.", "Убейте 5 человек на захвате из конкурирующей организации.", { 2001, 2007, 2046 } },
	{ 2, "Подводная лодка", 1, "Захватите контроль над подводной лодкой 1 раз", "Подлодка прибывает в случайное время.\nКогда она прибудет, то в чате появится оповещение.\nНаграда в этом задании выдаётся случайная из представленых.", { 2089, 2090, 2092 } },
	{ 2, "Контрабанда", 1, "Перехватите посылку для криминальных организаций 1 раз", "Посылка сбрасывается в случайное время.\nКогда она прибудет, то в чате появится оповещение.\nНаграда в этом задании выдаётся случайная из представленых.", { 2128, 2095, 2007 } },
	{ 2, "Боеприпасы", 3, "Украдите со склада армии 3 раза", "Отправляйтесь на военную базу и обвариуйте её.\nИщите пикапы с вооружением.", { 2007, 2046, -1 } },
	{ 2, "Hitman's", 3, "Выполните 3 заказа на убийство.", "В подвале на Вашей базе можно взять заказ на убийство.\nЧтоб заказать убийство используйте /contract.", { 2009, 2046, -1 } },
	{ 2, "Банк", 1, "Ограбьте банк.", "В подвале на Вашей базе можно начать ограбление банка.\nСоберите команду из 4ёх человек и вперёд!", { 2001, 2046, -1 } },
	{ 2, "Доставка боеприпасов", 25, "Доставьте 25 ящиков с боеприпасами на склад Вашей организации.", "Вы можете пополнить его, как оружием, так и аптечками.", { 2001, 2007, 2046 } }
} ;

stock give_emp_progress ( playerid, _q_id, _progress )
{
	new fractionId = p_info [ playerid ] [ member ] ;
	if ( ! fractionId ) return 1 ;
	
	if ( mayor_player ( playerid ) || gov_player ( playerid ) )
	{
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= MayorEmpInfo [ _q_id ] [ EMP_MAX ] ) return 1 ;
		
		p_info [ playerid ] [ emp_progress ] [ _q_id ] += _progress ;
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= MayorEmpInfo [ _q_id ] [ EMP_MAX ] )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вы выполнили задание организации '%s'.", MayorEmpInfo [ _q_id ] [ EMP_NAME ] ) ;
			SendClientMessage ( playerid, col_lblue, global_string ) ;
		
			new _item ;
			for ( new i = 0 ; i < MAX_FRACTION_TASKS_PRIZE ; i ++ )
			{
				_item = MayorEmpInfo [ _q_id ] [ EMP_MODEL ] [ i ] ;
				if ( _item == -1 ) continue ;
				if ( _item == 46 )
				{
					static const _str [ ] = "UPDATE `fractions` SET `f_quest_rating` = `f_quest_rating` + '%d' WHERE `f_id` = '%d' LIMIT 1" ;
					new query_string [ sizeof _str + ( 9 * 2 ) ] ;
					format ( query_string, sizeof query_string, _str, RandomEx ( 100, 400 ), fractionId ) ;
					mysql_tquery ( sql_connection, query_string ) ;
					continue ;
				}
					
				give_inventory ( playerid, _item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _item ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
		}
		else
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вы выполнили часть задания '%s'. Прогресс: %d / %d.",
			MayorEmpInfo [ _q_id ] [ EMP_NAME ], p_info [ playerid ] [ emp_progress ] [ _q_id ], MayorEmpInfo [ _q_id ] [ EMP_MAX ] ) ;
			SendClientMessage ( playerid, col_lblue, global_string ) ;
		}
	}
	else if ( cop_player ( playerid ) || fbi_player ( playerid ) )
	{
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= PoliceEmpInfo [ _q_id ] [ EMP_MAX ] ) return 1 ;
		
		p_info [ playerid ] [ emp_progress ] [ _q_id ] += _progress ;
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= PoliceEmpInfo [ _q_id ] [ EMP_MAX ] )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вы выполнили задание организации '%s'.", PoliceEmpInfo [ _q_id ] [ EMP_NAME ] ) ;
			SendClientMessage ( playerid, col_lblue, global_string ) ;
		
			new _item ;
			for ( new i = 0 ; i < MAX_FRACTION_TASKS_PRIZE ; i ++ )
			{
				_item = PoliceEmpInfo [ _q_id ] [ EMP_MODEL ] [ i ] ;
				if ( _item == -1 ) continue ;
				if ( _item == 46 )
				{
					static const _str [ ] = "UPDATE `fractions` SET `f_quest_rating` = `f_quest_rating` + '%d' WHERE `f_id` = '%d' LIMIT 1" ;
					new query_string [ sizeof _str + ( 9 * 2 ) ] ;
					format ( query_string, sizeof query_string, _str, RandomEx ( 100, 400 ), fractionId ) ;
					mysql_tquery ( sql_connection, query_string ) ;
					continue ;
				}
					
				give_inventory ( playerid, _item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _item ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
		}
		else
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вы выполнили часть задания '%s'. Прогресс: %d / %d.",
			PoliceEmpInfo [ _q_id ] [ EMP_NAME ], p_info [ playerid ] [ emp_progress ] [ _q_id ], PoliceEmpInfo [ _q_id ] [ EMP_MAX ] ) ;
			SendClientMessage ( playerid, col_lblue, global_string ) ;
		}
	}
	else if ( army_player ( playerid ) )
	{
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= ArmyEmpInfo [ _q_id ] [ EMP_MAX ] ) return 1 ;
		
		p_info [ playerid ] [ emp_progress ] [ _q_id ] += _progress ;
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= ArmyEmpInfo [ _q_id ] [ EMP_MAX ] )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вы выполнили задание организации '%s'.", ArmyEmpInfo [ _q_id ] [ EMP_NAME ] ) ;
			SendClientMessage ( playerid, col_lblue, global_string ) ;
		
			new _item ;
			for ( new i = 0 ; i < MAX_FRACTION_TASKS_PRIZE ; i ++ )
			{
				_item = ArmyEmpInfo [ _q_id ] [ EMP_MODEL ] [ i ] ;
				if ( _item == -1 ) continue ;
				if ( _item == 46 )
				{
					static const _str [ ] = "UPDATE `fractions` SET `f_quest_rating` = `f_quest_rating` + '%d' WHERE `f_id` = '%d' LIMIT 1" ;
					new query_string [ sizeof _str + ( 9 * 2 ) ] ;
					format ( query_string, sizeof query_string, _str, RandomEx ( 100, 400 ), fractionId ) ;
					mysql_tquery ( sql_connection, query_string ) ;
					continue ;
				}
					
				give_inventory ( playerid, _item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _item ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
		}
		else
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вы выполнили часть задания '%s'. Прогресс: %d / %d.",
			ArmyEmpInfo [ _q_id ] [ EMP_NAME ], p_info [ playerid ] [ emp_progress ] [ _q_id ], ArmyEmpInfo [ _q_id ] [ EMP_MAX ] ) ;
			SendClientMessage ( playerid, col_lblue, global_string ) ;
		}
	}
	else if ( medic_player ( playerid ) )
	{
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= MedicEmpInfo [ _q_id ] [ EMP_MAX ] ) return 1 ;
		
		p_info [ playerid ] [ emp_progress ] [ _q_id ] += _progress ;
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= MedicEmpInfo [ _q_id ] [ EMP_MAX ] )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вы выполнили задание организации '%s'.", MedicEmpInfo [ _q_id ] [ EMP_NAME ] ) ;
			SendClientMessage ( playerid, col_lblue, global_string ) ;
		
			new _item ;
			for ( new i = 0 ; i < MAX_FRACTION_TASKS_PRIZE ; i ++ )
			{
				_item = MedicEmpInfo [ _q_id ] [ EMP_MODEL ] [ i ] ;
				if ( _item == -1 ) continue ;
				if ( _item == 46 )
				{
					static const _str [ ] = "UPDATE `fractions` SET `f_quest_rating` = `f_quest_rating` + '%d' WHERE `f_id` = '%d' LIMIT 1" ;
					new query_string [ sizeof _str + ( 9 * 2 ) ] ;
					format ( query_string, sizeof query_string, _str, RandomEx ( 100, 400 ), fractionId ) ;
					mysql_tquery ( sql_connection, query_string ) ;
					continue ;
				}

				give_inventory ( playerid, _item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _item ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
		}
		else
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вы выполнили часть задания '%s'. Прогресс: %d / %d.",
			MedicEmpInfo [ _q_id ] [ EMP_NAME ], p_info [ playerid ] [ emp_progress ] [ _q_id ], MedicEmpInfo [ _q_id ] [ EMP_MAX ] ) ;
			SendClientMessage ( playerid, col_lblue, global_string ) ;
		}
	}
	else if ( mafia_player ( playerid ) )
	{
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= MafiaEmpInfo [ _q_id ] [ EMP_MAX ] ) return 1 ;
		
		p_info [ playerid ] [ emp_progress ] [ _q_id ] += _progress ;
		if ( p_info [ playerid ] [ emp_progress ] [ _q_id ] >= MafiaEmpInfo [ _q_id ] [ EMP_MAX ] )
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вы выполнили задание организации '%s'.", MafiaEmpInfo [ _q_id ] [ EMP_NAME ] ) ;
			SendClientMessage ( playerid, col_lblue, global_string ) ;
		
			new _item ;
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				_item = MafiaEmpInfo [ _q_id ] [ EMP_MODEL ] [ i ] ;
				if ( _item == -1 ) continue ;
				if ( _item == 46 )
				{
					static const _str [ ] = "UPDATE `fractions` SET `f_quest_rating` = `f_quest_rating` + '%d' WHERE `f_id` = '%d' LIMIT 1" ;
					new query_string [ sizeof _str + ( 9 * 2 ) ] ;
					format ( query_string, sizeof query_string, _str, RandomEx ( 100, 400 ), fractionId ) ;
					mysql_tquery ( sql_connection, query_string ) ;
					continue ;
				}
					
				give_inventory ( playerid, _item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _item ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
		}
		else
		{
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вы выполнили часть задания '%s'. Прогресс: %d / %d.",
			MafiaEmpInfo [ _q_id ] [ EMP_NAME ], p_info [ playerid ] [ emp_progress ] [ _q_id ], MafiaEmpInfo [ _q_id ] [ EMP_MAX ] ) ;
			SendClientMessage ( playerid, col_lblue, global_string ) ;
		}
	}
	
	CheckFractionTasks ( playerid ) ;
	SaveFractionTasks ( playerid ) ;
	return 1 ;
}

callback: OnFractionTasksLoad ( playerid, bool: status )
{
    if ( ! status )
    {
        static const _str [ ] = "SELECT * FROM users_quests_fraction WHERE u_sql_id = %d LIMIT 1" ;
        new query_string [ sizeof _str + 9 ] ;
        format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
        mysql_tquery ( sql_connection, query_string, "OnFractionTasksLoad", "ii", playerid, true ) ;
    }
    else
    {
        new rows, fields ;
        cache_get_data ( rows, fields ) ;

        if ( ! rows )
        {
            new query_string [ 64 ] ;
            format ( query_string, sizeof query_string, "INSERT INTO users_quests_fraction (u_sql_id) VALUES (%d)", p_info [ playerid ] [ id ] ) ;
            mysql_tquery ( sql_connection, query_string ) ;

			p_info [ playerid ] [ emp_cooldown ] = 0 ;
			ResetFractionTasks ( playerid ) ;
        }
        else
        {
			new sscanf_delimit [ 100 ] ;
			cache_get_field_content ( 0, "u_quest_id", sscanf_delimit ) ;
			sscanf ( sscanf_delimit, "p<|>ddd", p_info [ playerid ] [ emp_status ] [ 0 ], p_info [ playerid ] [ emp_status ] [ 1 ], p_info [ playerid ] [ emp_status ] [ 2 ] ) ;

            cache_get_field_content ( 0, "u_quest_progress", sscanf_delimit ) ;
			sscanf ( sscanf_delimit, "p<|>ddd", p_info [ playerid ] [ emp_progress ] [ 0 ], p_info [ playerid ] [ emp_progress ] [ 1 ], p_info [ playerid ] [ emp_progress ] [ 2 ] ) ;
        
			p_info [ playerid ] [ emp_cooldown ] = cache_get_field_content_int ( 0, "u_quest_cooldown" ) ;
			p_info [ playerid ] [ emp_count ] = cache_get_field_content_int ( 0, "u_quest_count" ) ;
			p_info [ playerid ] [ emp_access ] = cache_get_field_content_int ( 0, "u_quest_status" ) ;
		
			ResetFractionTasks ( playerid ) ;
		}
    }
    return true ;
}

stock ResetFractionTasks ( playerid, bool: isReset = false )
{
	if ( p_info [ playerid ] [ emp_cooldown ] > gettime ( ) && ! isReset ) return false ;
	if ( p_info [ playerid ] [ member ] < 1 ) return false ;

	new _max_emp ;
	if ( mayor_player ( playerid ) || gov_player ( playerid ) ) _max_emp = MAX_MAYOR_EMP_INFO ;
	else if ( cop_player ( playerid ) || fbi_player ( playerid ) ) _max_emp = MAX_POLICE_EMP_INFO ;
	else if ( army_player ( playerid ) ) _max_emp = MAX_ARMY_EMP_INFO ;
	else if ( medic_player ( playerid ) ) _max_emp = MAX_MEDIC_EMP_INFO ;
	else if ( mafia_player ( playerid ) ) _max_emp = MAX_MAFIA_EMP_INFO ;

	CheckFractionTasks ( playerid ) ;

	for ( new i = 0 ; i < MAX_FRACTION_TASKS ; i ++ )
	{
		p_info [ playerid ] [ emp_status ] [ i ] = random ( _max_emp ) ;
		p_info [ playerid ] [ emp_progress ] [ i ] = 0 ;
	}

	p_info [ playerid ] [ emp_cooldown ] = SetElapsedTime ( gettime ( ), 24, CONVERT_TIME_TO_HOURS ) ;
	SaveFractionTasks ( playerid ) ;
	return true ;
}

stock CheckFractionTasks ( playerid )
{
	new taskId, countMax = 0 ;
	for ( new i = 0 ; i < MAX_FRACTION_TASKS ; i ++ )
	{
		taskId = p_info [ playerid ] [ emp_status ] [ i ] ;
		if ( taskId != -1 )
		{
			if ( p_info [ playerid ] [ emp_progress ] [ i ] >= getFractionTaskProgress ( playerid, taskId ) )
			{
				countMax ++ ;
			}
		}
	}

	if ( countMax >= MAX_FRACTION_TASKS )
	{
		p_info [ playerid ] [ emp_count ] += 1 ;
		p_info [ playerid ] [ emp_access ] = 1 ;
	}
	else p_info [ playerid ] [ emp_count ] = 0 ;
	return true ;
}

stock SaveFractionTasks ( playerid )
{
	static const _str [ ] = "UPDATE users_quests_fraction SET u_quest_id = '%d|%d|%d', u_quest_progress = '%d|%d|%d', u_quest_cooldown = %d, u_quest_status = %d WHERE u_sql_id = %d LIMIT 1" ;
	new query_string [ sizeof _str + ( 8 * 9 ) ] ;
	format ( query_string, sizeof query_string, _str,
	p_info [ playerid ] [ emp_status ] [ 0 ], p_info [ playerid ] [ emp_status ] [ 1 ], p_info [ playerid ] [ emp_status ] [ 2 ],
	p_info [ playerid ] [ emp_progress ] [ 0 ], p_info [ playerid ] [ emp_progress ] [ 1 ], p_info [ playerid ] [ emp_progress ] [ 2 ],
	p_info [ playerid ] [ emp_cooldown ], p_info [ playerid ] [ emp_access ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, query_string ) ;
	return true ;
}

static empHeaderInfo [ ] [ 100 ] =
{
	"При выполнении 3-ех\nзаданий подряд в течении\n2 дней, получите повышение",
	"При выполнении 3-ех\nзаданий подряд в течении\n4 дней, получите повышение",
	"При выполнении 3-ех\nзаданий подряд в течении\n5 дней, получите подарок"
} ;

stock showFractionTasks ( playerid )
{
	ResetFractionTasks ( playerid ) ;

	new fractionId = p_info [ playerid ] [ member ], needDay = 0, empCount = p_info [ playerid ] [ emp_count ], bool: isNextRank = false ;
	if ( p_info [ playerid ] [ emp_access ] )
	{
		if ( empCount == 2 ) isNextRank = true ;
		else if ( empCount == 4 ) isNextRank = true ;
		else if ( empCount == MAX_FRACTION_TASKS_DAY ) isNextRank = true ;
	}

	if ( empCount < 2 ) needDay = 2, empCount = 0 ;
	else if ( empCount > 1 && empCount < 4 ) needDay = 4, empCount = 1 ;
	else needDay = MAX_FRACTION_TASKS_DAY, empCount = 2 ;

	new Node: node = JSON_Object (
		"fractionId",		JSON_Int ( fractionId ),
		"fractionName",		JSON_String ( f_info [ fractionId - 1 ] [ f_name ] ),
		"time",				JSON_Int ( p_info [ playerid ] [ emp_cooldown ] - gettime ( ) ),
		"timeEnd",			JSON_Int ( 0 ),
		"progress",			JSON_Int ( p_info [ playerid ] [ emp_count ] ),
		"max",				JSON_Int ( needDay ),
		"info",				JSON_String ( empHeaderInfo [ empCount ] ),
		"firstText",		JSON_String ( "75.000 "valute_title_" каждому\nчлену фракции" ),
		"secondText",		JSON_String ( "75.000 "valute_title_" каждому\nчлену фракции" ),
		"thirdText",		JSON_String ( "75.000 "valute_title_" каждому\nчлену фракции" ),
		"isAvailable",		JSON_Bool ( isNextRank )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_FRACTION_TASKS, 2, global_string ) ;

	fractionDailyTasks ( playerid ) ;
	return true ;
}

stock fractionDailyTasks ( playerid )
{
	new Node: node = JSON_Array ( ), taskId ;
	for ( new i = 0, Node: taskNode ; i < MAX_FRACTION_TASKS ; i ++ )
	{
		taskId = p_info [ playerid ] [ emp_status ] [ i ] ;

		new Node: json = JSON_Array ( ) ;
		JSON_Parse ( getFractionTaskPrizes ( playerid, taskId ), json ) ;

		taskNode = JSON_Array (
			JSON_Object (
				"id",			JSON_Int ( i ),
				"name",			JSON_String ( getFractionTaskName ( playerid, taskId ) ),
				"description",	JSON_String ( getFractionTaskDescription ( playerid, taskId ) ),
				"progress",		JSON_Int ( p_info [ playerid ] [ emp_progress ] [ i ] ),
				"max",			JSON_Int ( getFractionTaskProgress ( playerid, taskId ) ),
				"rewards",		json,
				"isChosen",		JSON_Bool ( true ),
				"isVisible",	JSON_Bool ( false )
			)
		) ;

		node = JSON_Append ( node, taskNode ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_FRACTION_TASKS, 0, global_string ) ;
	return true ;
}

stock getFractionTaskName ( playerid, taskId )
{
	new message [ 32 ] ;
	if ( mayor_player ( playerid ) || gov_player ( playerid ) )
	{
		format ( message, sizeof message, "%s", MayorEmpInfo [ taskId ] [ EMP_NAME ] ) ;
	}
	else if ( cop_player ( playerid ) || fbi_player ( playerid ) )
	{
		format ( message, sizeof message, "%s", PoliceEmpInfo [ taskId ] [ EMP_NAME ] ) ;
	}
	else if ( army_player ( playerid ) )
	{
		format ( message, sizeof message, "%s", ArmyEmpInfo [ taskId ] [ EMP_NAME ] ) ;
	}
	else if ( medic_player ( playerid ) )
	{
		format ( message, sizeof message, "%s", MedicEmpInfo [ taskId ] [ EMP_NAME ] ) ;
	}
	else if ( mafia_player ( playerid ) )
	{
		format ( message, sizeof message, "%s", MafiaEmpInfo [ taskId ] [ EMP_NAME ] ) ;
	}
	return message ;
}

stock getFractionTaskDescription ( playerid, taskId )
{
	new message [ 32 ] ;
	if ( mayor_player ( playerid ) || gov_player ( playerid ) )
	{
		format ( message, sizeof message, "%s", MayorEmpInfo [ taskId ] [ EMP_DESCRIPTION ] ) ;
	}
	else if ( cop_player ( playerid ) || fbi_player ( playerid ) )
	{
		format ( message, sizeof message, "%s", PoliceEmpInfo [ taskId ] [ EMP_DESCRIPTION ] ) ;
	}
	else if ( army_player ( playerid ) )
	{
		format ( message, sizeof message, "%s", ArmyEmpInfo [ taskId ] [ EMP_DESCRIPTION ] ) ;
	}
	else if ( medic_player ( playerid ) )
	{
		format ( message, sizeof message, "%s", MedicEmpInfo [ taskId ] [ EMP_DESCRIPTION ] ) ;
	}
	else if ( mafia_player ( playerid ) )
	{
		format ( message, sizeof message, "%s", MafiaEmpInfo [ taskId ] [ EMP_DESCRIPTION ] ) ;
	}
	return message ;
}

stock getFractionTaskProgress ( playerid, taskId )
{
	new maxProgress ;
	if ( mayor_player ( playerid ) || gov_player ( playerid ) ) maxProgress = MayorEmpInfo [ taskId ] [ EMP_MAX ] ;
	else if ( cop_player ( playerid ) || fbi_player ( playerid ) ) maxProgress = PoliceEmpInfo [ taskId ] [ EMP_MAX ] ;
	else if ( army_player ( playerid ) ) maxProgress = ArmyEmpInfo [ taskId ] [ EMP_MAX ] ;
	else if ( medic_player ( playerid ) ) maxProgress = MedicEmpInfo [ taskId ] [ EMP_MAX ] ;
	else if ( mafia_player ( playerid ) ) maxProgress = MafiaEmpInfo [ taskId ] [ EMP_MAX ] ;
	return maxProgress ;
}

stock getFractionTaskPrizes ( playerid, taskId )
{
	new Node: node = JSON_Array ( ), modelId ;
	for ( new i = 0, Node: prizeNode ; i < 3 ; i ++ )
	{
		if ( mayor_player ( playerid ) || gov_player ( playerid ) ) modelId = MayorEmpInfo [ taskId ] [ EMP_MODEL ] [ i ] ;
		else if ( cop_player ( playerid ) || fbi_player ( playerid ) ) modelId = PoliceEmpInfo [ taskId ] [ EMP_MODEL ] [ i ] ;
		else if ( army_player ( playerid ) ) modelId = ArmyEmpInfo [ taskId ] [ EMP_MODEL ] [ i ] ;
		else if ( medic_player ( playerid ) ) modelId = MedicEmpInfo [ taskId ] [ EMP_MODEL ] [ i ] ;
		else if ( mafia_player ( playerid ) ) modelId = MafiaEmpInfo [ taskId ] [ EMP_MODEL ] [ i ] ;

		prizeNode = JSON_Array (
			JSON_Object (
				"name",			JSON_String ( item_name ( modelId ) ),
				"type",			JSON_Int ( item_render_type ( modelId ) ),
				"model",		JSON_Int ( item_object_id ( modelId ) ),
				"color1",  		JSON_Int ( item_color ( modelId, 1 ) ),
				"color2",      	JSON_Int ( 1 ),
				"rotX",			JSON_Float ( 20.0 ),
				"rotY",			JSON_Float ( 180.0 ),
				"rotZ",			JSON_Float ( 45.0 ),
				"zoom",			JSON_Float ( 0.78 )
			)
		) ;

		node = JSON_Append ( node, prizeNode ) ;
	}
	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	return global_string ;
}

stock packetFractionTasks ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 ) // кнопка "выбрать" у задания
	{
		new idx = strval ( data ), strHeader [ 32 ] ;

		global_string [ 0 ] = EOS ;
		if ( mayor_player ( playerid ) || gov_player ( playerid ) )
		{
			format ( global_string, 512, "\
				{"#cBL"}** Задание **\n\
				{"#cWH"}%s\n\n\
				{"#cBL"}** Подсказка **\n\
				{"#cWH"}%s", MayorEmpInfo [ idx ] [ EMP_DESCRIPTION ], MayorEmpInfo [ idx ] [ EMP_HELP ] ) ;
			format ( strHeader, sizeof strHeader, "{"#cBHD"}%s", MayorEmpInfo [ idx ] [ EMP_NAME ] ) ;
		}
		else if ( cop_player ( playerid ) || fbi_player ( playerid ) )
		{
			format ( global_string, 512, "\
				{"#cBL"}** Задание **\n\
				{"#cWH"}%s\n\n\
				{"#cBL"}** Подсказка **\n\
				{"#cWH"}%s", PoliceEmpInfo [ idx ] [ EMP_DESCRIPTION ], PoliceEmpInfo [ idx ] [ EMP_HELP ] ) ;
			format ( strHeader, sizeof strHeader, "{"#cBHD"}%s", PoliceEmpInfo [ idx ] [ EMP_NAME ] ) ;
		}
		else if ( army_player ( playerid ) )
		{
			format ( global_string, 512, "\
				{"#cBL"}** Задание **\n\
				{"#cWH"}%s\n\n\
				{"#cBL"}** Подсказка **\n\
				{"#cWH"}%s", ArmyEmpInfo [ idx ] [ EMP_DESCRIPTION ], ArmyEmpInfo [ idx ] [ EMP_HELP ] ) ;
			format ( strHeader, sizeof strHeader, "{"#cBHD"}%s", ArmyEmpInfo [ idx ] [ EMP_NAME ] ) ;
		}
		else if ( medic_player ( playerid ) )
		{
			format ( global_string, 512, "\
				{"#cBL"}** Задание **\n\
				{"#cWH"}%s\n\n\
				{"#cBL"}** Подсказка **\n\
				{"#cWH"}%s", MedicEmpInfo [ idx ] [ EMP_DESCRIPTION ], MedicEmpInfo [ idx ] [ EMP_HELP ] ) ;
			format ( strHeader, sizeof strHeader, "{"#cBHD"}%s", MedicEmpInfo [ idx ] [ EMP_NAME ] ) ;
		}
		else if ( mafia_player ( playerid ) )
		{
			format ( global_string, 512, "\
				{"#cBL"}** Задание **\n\
				{"#cWH"}%s\n\n\
				{"#cBL"}** Подсказка **\n\
				{"#cWH"}%s", MafiaEmpInfo [ idx ] [ EMP_DESCRIPTION ], MafiaEmpInfo [ idx ] [ EMP_HELP ] ) ;
			format ( strHeader, sizeof strHeader, "{"#cBHD"}%s", MafiaEmpInfo [ idx ] [ EMP_NAME ] ) ;
		}
		show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, strHeader, global_string, "Принять", "" ) ;
	}
	else if ( actionId == 1 ) // кнопка за выполнение заданий по дням
	{
		new fractionId = p_info [ playerid ] [ member ] ;
		switch ( p_info [ playerid ] [ emp_count ] )
		{
			case 2, 4:
			{
				if ( p_info [ playerid ] [ rank ] < MAX_AUTO_RANK && p_info [ playerid ] [ emp_access ] )
				{
					p_info [ playerid ] [ rank ] += 1 ;
			
					write_fraction ( playerid, fractionId, TYPE_LOG_AGIVERANK, "Выполнив задания был(а) повышен(а)" ) ;
					insert_joblist ( playerid, "RANK", LABOR_TYPE_NEXT_RANG, p_info [ playerid ] [ rank ] ) ;

					update_int_sql ( playerid, "u_rank", p_info [ playerid ] [ rank ] ) ;

					if ( f_info [ fractionId - 1 ] [ f_skin_type ] == 1 )
					{
						p_info [ playerid ] [ org_skin ] = f_skin_rank [ fractionId - 1 ] [ p_info [ playerid ] [ gender ] ] [ p_info [ playerid ] [ rank ] ] ;
						update_int_sql ( playerid, "u_org_skin", p_info [ playerid ] [ org_skin ] ) ;

						fraction_duty ( playerid ) ;
					}
				}

				p_info [ playerid ] [ emp_access ] = 0 ;
				SaveFractionTasks ( playerid ) ;
			}
			case 5:
			{
				p_info [ playerid ] [ emp_count ] =
				p_info [ playerid ] [ emp_access ] = 0 ;
				SaveFractionTasks ( playerid ) ;
			}
		}
	}
	else if ( actionId == 2 ) // рейтинг
	{
		mysql_tquery ( sql_connection, !"SELECT `f_id`, `f_quest_rating` FROM `fractions` WHERE `f_name` NOT LIKE 'Резерв' ORDER BY `fractions`.`f_quest_rating` DESC", "fractionsQuestRating", "i", playerid ) ;
	}
	return true ;
}

stock packetFractionTasksDestroy ( playerid )
{
	toggle_controlable ( playerid, true ) ;
	return true ;
}

callback: fractionsQuestRating ( playerid )
{
	new Node: node = JSON_Array ( ),
		fractionId, fractionScore,
		rows = cache_num_rows ( sql_connection ) ;
	for ( new i = 0, Node: fractionNode ; i < rows ; i ++ )
	{
		fractionId = cache_get_field_content_int ( i, "f_id", sql_connection ) ;
		fractionScore = cache_get_field_content_int ( i, "f_quest_rating", sql_connection ) ;

		fractionNode = JSON_Array (
			JSON_Object (
				"position",		JSON_Int ( i ),
				"name",			JSON_String ( f_info [ fractionId - 1 ] [ f_name ] ),
				"score",		JSON_Int ( fractionScore )
			)
		) ;
		node = JSON_Append ( node, fractionNode ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_FRACTION_TASKS, 1, global_string ) ;
	return true ;
}