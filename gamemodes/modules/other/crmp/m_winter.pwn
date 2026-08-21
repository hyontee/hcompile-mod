new Float: santa_position [ 4 ] = { -317.3058, 658.8489, 12.2208, 185.9248 } ;
new Float: snegurochka_position [ 4 ] = { -308.7134, 655.9216, 12.2208, 133.2548 } ;

new Float: actor_lottery_year [ 4 ] [ 4 ] =
{
	{ 1818.1879, 2518.9470, 15.8020, 284.3140 },
	{ -482.1120, 911.0720, 12.1425, 76.0915 },
	{ 2744.9440, -2442.6250, 21.9000, 172.8209 },
	{ -325.5769, 657.2178, 12.2208, 222.9341 }
} ;

new year_quest [ MAX_PLAYERS ] ;
new year_quest_progress [ MAX_PLAYERS ] ;
new player_year_question [ MAX_PLAYERS ] ;

static const year_quest_name [ ] [ 32 ] =
{
	"Новогодняя суета",
	"Загадки",
	"Сбор писем",
	"Доставка писем",
	"Подарки"
} ;

enum
{
	d_year_question = 44444,
	d_winter_lottery,
	d_winter_lottery_buy
} ;

static const year_quest_info [ ] [ 256 ] =
{
	"{"#cWH"}Новый год - это самый светлый семейный праздник.\n\
	Он дарит много тепла людям, даёт надежды, собирает семьи и\n\
	примеряет людей.\n\n\
	Для успеха этого праздника помоги мне собрать всех друзей.\n\n\
	Добавь 5 человек в /friends.",
	"{"#cWH"}Отправляйся к моей внучке Снегоручке и разгадай все наши загадки.\n\
	Только давай по честному, без вот этих Ваших интернетов.",
	"{"#cWH"}Внучок, я совсем не успеваю сделать все дела, нужна твоя помощь.\n\
	Помоги собрать письма детей, буду очень благодарен тебе за это.",
	"{"#cWH"}Так, я подготовил ответы на письма деток.\n\
	Поможешь доставить им ответы?",
	"{"#cWH"}Для того, чтоб хорошо и весело встретить новый год осталось совсем чуть-чуть!\n\
	Помоги доставить подарки детям!"
} ;

static const year_quest_snegurochka [ 20 ] [ 128 ] =
{
	"С какого года на Руси начали праздновать новый год с 31 декабря на 1 января?", // 1
	"Какого числа отмечается рождество?", // 2
	"Какой фильм считается неофициальным в России символом нового года?", // 3
	"Зимнее явление, чье составляющее никогда не бывает одинаковым?", // 4
	"Как называется гора, в скандинавской мифологии, куда поднимались для просьбы чего-то у Одина?", // 5
	"Как назывался один из охраняемых миров Асгардом, где постоянно царил снег?", // 6
	"Страна первой украшенной ёлки?", // 7
	"Первые стеклянные игрушки для елочки появились?", // 8
	"Даты нового года в Китае в 2023 году?", // 9
	"Руна счастья в скандинавской мифологии?", // 10
	"Когда начинался новый год до указа Петра Великого?", // 11
	"Что такое кашрут?", // 12
	"Как звали двух бандитов в один дома?", // 13
	"Кто приходит к плохим детям в Америке?", // 14
	"Когда открылся 2ой сервер Crime Mobile?", // 15
	"Как зовут основателей и разработчиков Crime Mobile?", // 16
	"Самая популярная новогодняя реклама?", // 17
	"Без чего новый год не праздник?",
	"Кто такие скальды?",
	"Самая быстрая машина в игре?"
} ;

static const year_question [ 20 ] [ 256 ] =
{
	"{"#cBL"}1. {"#cWH"}988 год (крещение Руси)\n{"#cBL"}2. {"#cWH"}1492 год (византийская система)\n{"#cBL"}3. {"#cWH"}1699 год (указ Петра I)", // 1
	"{"#cBL"}1. {"#cWH"}2 января\n{"#cBL"}2. {"#cWH"}7 января\n{"#cBL"}3. {"#cWH"}10 января\n{"#cBL"}4. {"#cWH"}25 декабря", // 2
	"{"#cBL"}1. {"#cWH"}Один дома\n{"#cBL"}2. {"#cWH"}Гринч похититель рождества\n{"#cBL"}3. {"#cWH"}Гарри Поттер", // 3
	"{"#cBL"}1. {"#cWH"}Снежки, которые слепили люди\n{"#cBL"}2. {"#cWH"}Снежинки\n{"#cBL"}3. {"#cWH"}Ледяные скульптуры", // 4
	"{"#cBL"}1. {"#cWH"}Лифьяберг\n{"#cBL"}2. {"#cWH"}Нильфгард\n{"#cBL"}3. {"#cWH"}Имир", // 5
	"{"#cBL"}1. {"#cWH"}Муспельхейм\n{"#cBL"}2. {"#cWH"}Нифлхейм\n{"#cBL"}3. {"#cWH"}Альвхейм", // 6
	"{"#cBL"}1. {"#cWH"}Россия\n{"#cBL"}2. {"#cWH"}Украина\n{"#cBL"}3. {"#cWH"}Германия\n{"#cBL"}4. {"#cWH"}Польша", // 7
	"{"#cBL"}1. {"#cWH"}Япония\n{"#cBL"}2. {"#cWH"}Китай\n{"#cBL"}3. {"#cWH"}Швейцария\n{"#cBL"}4. {"#cWH"}Швеция", // 8
	"{"#cBL"}1. {"#cWH"}с 21 января по 5 февраля\n{"#cBL"}2. {"#cWH"}с 1 января по 16 января\n{"#cBL"}3. {"#cWH"}с 10 января по 26 января\n{"#cBL"}4. {"#cWH"}с 20 января по 4 февраля", // 9
	"{"#cBL"}1. {"#cWH"}Райдо\n{"#cBL"}2. {"#cWH"}Вуньо\n{"#cBL"}3. {"#cWH"}Тейваз", // 10
	"{"#cBL"}1. {"#cWH"}В августе\n{"#cBL"}2. {"#cWH"}В ноябре\n{"#cBL"}3. {"#cWH"}В сентябре", // 11
	"{"#cBL"}1. {"#cWH"}Дозволенность или пригодность\n{"#cBL"}2. {"#cWH"}Название Еврейского праздника\n{"#cBL"}3. {"#cWH"}Еврейское блюдо", // 12
	"{"#cBL"}1. {"#cWH"}Гарри и Питер\n{"#cBL"}2. {"#cWH"}Гарри и Джонни\n{"#cBL"}3. {"#cWH"}Гарри и Кевин\n{"#cBL"}4. {"#cWH"}Гарри и Марвин", // 13
	"{"#cBL"}1. {"#cWH"}Санта Клаус\n{"#cBL"}2. {"#cWH"}Крампус\n{"#cBL"}3. {"#cWH"}Эльфы\n{"#cBL"}4. {"#cWH"}Олени", // 14
	"{"#cBL"}1. {"#cWH"}Октябрь 2021\n{"#cBL"}2. {"#cWH"}Ноябрь 2021\n{"#cBL"}3. {"#cWH"}Декабрь 2021", // 15
	"{"#cBL"}1. {"#cWH"}Иван и Иван\n{"#cBL"}2. {"#cWH"}Иван и Никита\n{"#cBL"}3. {"#cWH"}Иван и Дима\n{"#cBL"}4. {"#cWH"}Иван и Савелий", // 16
	"{"#cBL"}1. {"#cWH"}Fanta\n{"#cBL"}2. {"#cWH"}Sprite\n{"#cBL"}3. {"#cWH"}Flash\n{"#cBL"}4. {"#cWH"}Coca-Cola", // 17
	"{"#cBL"}1. {"#cWH"}Ёлка\n{"#cBL"}2. {"#cWH"}Бенгальская свеча\n{"#cBL"}3. {"#cWH"}Подарок\n{"#cBL"}4. {"#cWH"}Снег",
	"{"#cBL"}1. {"#cWH"}Певец-воин\n{"#cBL"}2. {"#cWH"}Рассказчик\n{"#cBL"}3. {"#cWH"}Подарок\n{"#cBL"}4. {"#cWH"}Берсерк",
	"{"#cBL"}1. {"#cWH"}Tesla Roadster\n{"#cBL"}2. {"#cWH"}Bugatti Chiron\n{"#cBL"}3. {"#cWH"}Mercedens-Benz GLS\n{"#cBL"}4. {"#cWH"}Мопед"
} ;

static const year_yes_question [ 20 ] =
{
	3, // 1
	2, // 2
	1, // 3
	2, // 4
	1, // 5
	2, // 6
	3, // 7
	4, // 8
	1, // 9
	2, // 10
	3, // 11
	1, // 12
	4, // 13
	2, // 14
	3, // 15
	2, // 16
	4, // 17
	1, // 18
	1, // 19
	1 // 20
} ;

new clear_player_questopn [ sizeof year_yes_question ] = { 0, ... } ;
new player_non_year_question [ MAX_PLAYERS ] [ sizeof year_yes_question ] ;

new clear_player_yes [ 10 ] = { -1, ... } ;
new player_yes_year_question [ MAX_PLAYERS ] [ 10 ] ;

new clear_player_winter_house [ 30 ] = { 0, ... } ;
new player_winter_house [ MAX_PLAYERS ] [ 30 ] ;

stock show_winter_house ( playerid, _h_id )
{
	if ( year_quest [ playerid ] != 2 && year_quest [ playerid ] != 3 && year_quest [ playerid ] != 4 ) return 1 ;
	
	for ( new i = 0 ; i < 30 ; i ++ )
	{
		if ( player_winter_house [ playerid ] [ i ] != 0 ) continue ;
		if ( player_winter_house [ playerid ] [ i ] == _h_id )
		{
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы уже взаимодействовали с данным домом." ) ;
			return 1 ;
		}
		
		checking_winter_progress ( playerid, 2, 1 ) ;
		checking_winter_progress ( playerid, 3, 1 ) ;
		checking_winter_progress ( playerid, 4, 1 ) ;
		player_winter_house [ playerid ] [ i ] = _h_id ;
		break ;
	}
	return 1 ;
}

stock show_year_quest ( playerid )
{
	if ( p_info [ playerid ] [ hour_played ] < THREE_HOUR_PLAYED ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Доступно с 3 часов в игре. Используйте /mm - Информация о персонаже - Статистика персонажа." ) ;
	if ( year_quest [ playerid ] > sizeof year_quest_name ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы выполнили все новогодние задания!" ) ;
	
	new _quest_id = year_quest [ playerid ] ;
	
	static const _quest_progress [ ] =
	{
		5,
		10,
		30,
		30,
		5000,
		30000,
		1,
		30000,
		200,
		1
	} ;

	if ( year_quest_progress [ playerid ] >= _quest_progress [ _quest_id ] )
	{
		year_quest [ playerid ] += 1 ;
		update_int_sql ( playerid, "u_year_quest", year_quest [ playerid ] ) ;
		
		_quest_id = year_quest [ playerid ] ;
		
		year_quest_progress [ playerid ] = 0 ;
		update_int_sql ( playerid, "u_winter_progress", year_quest_progress [ playerid ] ) ;
	}
	
	if ( _quest_id == 2 || _quest_id == 3 || _quest_id == 4 )
	{
		SendClientMessage ( playerid, col_gray, !"* Отправляйтесь к домам или квартирам и встаньте на их пикап." ) ;
	}
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 256, "{"#cGRDialog"}Задание:\n{"#cWH"}%s", year_quest_info [ _quest_id ] ) ;
	
	new header_string [ 64 ] ;
	format ( header_string, sizeof header_string, "{"#cBHD"}%s", year_quest_name [ _quest_id ] ) ;
	show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, header_string, global_string, "Принять", "" ) ;
	return 1 ;
}

stock checking_winter_progress ( playerid, quest_id, amount_plus )
{
	if ( year_quest [ playerid ] != quest_id ) return 1 ;
	
	static const _quest_progress [ ] =
	{
		5,
		10,
		30,
		30,
		30
	} ;

	year_quest_progress [ playerid ] += amount_plus ;

	if ( year_quest_progress [ playerid ] == _quest_progress [ quest_id ] )
	{
	    if ( quest_id == sizeof year_quest_name - 1 )
	    {
	        SendClientMessage ( playerid, col_succes, "Задание успешно выполнено. Ваша награда: {"#cWH"}10 "donate_title"{"#cSucces"}." ) ;
			SendClientMessage ( playerid, col_succes, !"Вы завершили квестовую линию." ) ;
			
			year_quest [ playerid ] += 1 ;
			update_int_sql ( playerid, "u_year_quest", year_quest [ playerid ] ) ;
			
			if ( random ( 10 ) == 1 ) give_inventory ( playerid, RandomEx ( skin_cross + 4718, skin_cross + 4719 ), 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			else 
			{
				new _acc_id ;
				if ( random ( 2 ) == 1 ) _acc_id = RandomEx ( 5016, 5019 ) ;
				else _acc_id = RandomEx ( 5016, 5019 ) ;
				give_player_item ( playerid, _acc_id ) ;
			}
			
			give_player_donate ( playerid, 10, 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, 10, p_info [ playerid ] [ donate ], "(donate) winter quest" ) ;
	    }
	    else
	    {
			SendClientMessage ( playerid, col_succes, "Задание успешно выполнено. Ваша награда: {"#cWH"}10 "donate_title"{"#cSucces"}." ) ;
			SendClientMessage ( playerid, col_succes, !"Отправляйтесь к Деду Морозу, чтобы взять следующее задание." ) ;

			give_player_donate ( playerid, 10, 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, 10, p_info [ playerid ] [ donate ], "(donate) winter quest" ) ;
		}

		player_winter_house [ playerid ] = clear_player_winter_house ;
		update_int_sql ( playerid, "u_winter_progress", year_quest_progress [ playerid ] ) ;
	}
	else update_int_sql ( playerid, "u_winter_progress", year_quest_progress [ playerid ] ) ;
	return 1 ;
}

stock show_year_question ( playerid, _q_id )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, sizeof global_string, "%s\n%s", year_quest_snegurochka [ _q_id ], year_question [ _q_id ] ) ;
	show_dialog ( playerid, d_year_question, DIALOG_STYLE_LIST, "{"#cBHD"}Новогодняя викторина", global_string, "Выбрать", "" ) ;
	return 1 ;
}

stock winter_EnterDynamicArea ( playerid, areaid )
{
	if ( GetPlayerState ( playerid ) == PLAYER_STATE_ONFOOT )
	{
		switch ( area_info [ areaid ] [ a_type ] )
		{
			case area_type_santa:
			{
				send_check_cinfo ( playerid, "Задания от Деда Мороза", 1, -1, CINFO_SANTA_ID, PICTURE_INFO_SUCESS, "Принять", "" ) ;
				return 1 ;
			}
			case area_type_snegurochka:
			{
				if ( year_quest [ playerid ] != 1 ) return 1 ;
				
				player_non_year_question [ playerid ] = clear_player_questopn ;
				player_yes_year_question [ playerid ] = clear_player_yes ;
				send_check_cinfo ( playerid, "Задания от Снегурочки", 1, -1, CINFO_SNEGURKA_ID, PICTURE_INFO_SUCESS, "Принять", "" ) ;
				return 1 ;
			}
			case area_type_lottery_year:
			{
				send_check_cinfo ( playerid, "Новогодняя лотерея", 1, -1, CINFO_WINTER_LOTTERY_ID, PICTURE_INFO_SUCESS, "Принять", "" ) ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

stock winter_LeaveDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_santa:
		{
			clear_check_info ( playerid, CINFO_SANTA_ID ) ;
			return 1 ;
		}
		case area_type_snegurochka:
		{
			clear_check_info ( playerid, CINFO_SNEGURKA_ID ) ;
			return 1 ;
		}
		case area_type_lottery_year:
		{
			clear_check_info ( playerid, CINFO_WINTER_LOTTERY_ID ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock winter_OnGameModeInit ( )
{
	CreateDynamicActor ( 121, santa_position [ 0 ], santa_position [ 1 ], santa_position [ 2 ], santa_position [ 3 ] ) ;
	new winter_areaid = CreateDynamicSphere ( santa_position [ 0 ], santa_position [ 1 ], santa_position [ 2 ], 2.0, 0, 0, -1 ) ;
	area_info [ winter_areaid ] [ a_type ] = area_type_santa ;

	CreateDynamic3DTextLabel ( "** Дед Мороз **", col_blue, santa_position [ 0 ], santa_position [ 1 ], santa_position [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0 ) ;
	CreateDynamic3DTextLabel ( "** Снегурочка **", col_blue, snegurochka_position [ 0 ], snegurochka_position [ 1 ], snegurochka_position [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0 ) ;

	CreateDynamicActor ( 40, snegurochka_position [ 0 ], snegurochka_position [ 1 ], snegurochka_position [ 2 ], snegurochka_position [ 3 ] ) ;
	winter_areaid = CreateDynamicSphere ( snegurochka_position [ 0 ], snegurochka_position [ 1 ], snegurochka_position [ 2 ], 2.0, 0, 0, -1 ) ;
	area_info [ winter_areaid ] [ a_type ] = area_type_snegurochka ;
	
	for ( new i = 0 ; i < sizeof actor_lottery_year ; i ++ )
	{
		#if defined server_number_one
			CreateDynamic3DTextLabel ( "** Победители в лотерее **\n\n{"#cWH"}1. Yaroslav_Duma\n2. Nikitosha_Ferucchi\n3. Ivan_Lolin\n4. Role_Rlae\n5. Nikita_Fox", col_blue, actor_lottery_year [ i ] [ 0 ], actor_lottery_year [ i ] [ 1 ], actor_lottery_year [ i ] [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0 ) ;
		#else
			CreateDynamic3DTextLabel ( "** Победители в лотерее **\n\n{"#cWH"}1. Morsik_Winston\n2. Alex_Maddson\n3. Marcel_Tape\n4. Atets_Vash\n5. Ilya_Loriks", col_blue, actor_lottery_year [ i ] [ 0 ], actor_lottery_year [ i ] [ 1 ], actor_lottery_year [ i ] [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0 ) ;
		#endif
		/*CreateDynamicActor ( 4571, actor_lottery_year [ i ] [ 0 ], actor_lottery_year [ i ] [ 1 ], actor_lottery_year [ i ] [ 2 ], actor_lottery_year [ i ] [ 3 ] ) ;
		winter_areaid = CreateDynamicSphere ( actor_lottery_year [ i ] [ 0 ], actor_lottery_year [ i ] [ 1 ], actor_lottery_year [ i ] [ 2 ], 2.0, 0, 0, -1 ) ;
		area_info [ winter_areaid ] [ a_type ] = area_type_lottery_year ;*/
	}
	return 1 ;
}

new player_winter_lottery [ MAX_PLAYERS ] [ 5 ] ;
stock show_donate_winter ( playerid )
{
	static const _price [ ] = { 25, 45, 75, 150, 300 } ;
	static const _lot_name [ ] [ 24 ] =
	{
		"доступная",
		"богатая",
		"редкая",
		"уникальная",
		"мега"
	} ;
	
	global_string [ 0 ] = EOS ;
	new line_string [ 100 ] ;
	for ( new i = 0 ; i < sizeof _price ; i ++ )
	{
		format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}Лотерея '%s'\t{"#cGN"}%d "donate_title" {"#cWH"}(Основной)\n", _lot_name [ i ], _price [ i ] ) ;
		strcat ( global_string, line_string ) ;
	}
	show_dialog ( playerid, d_winter_lottery, DIALOG_STYLE_TABLIST, "{"#cBHD"}Лотерея", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_winter_lottery ( playerid, _slot_id )
{
	static const _price [ ] = { 25, 45, 75, 150, 300 } ;
	static const _itemname [ ] [ 200 ] =
	{
		"Одежда 'Капитан Америка' (#4645)\nТабличка к нику 'TOP'\n1.000 "donate_title"",
		"Одежда 'Шейх' (#4622)\nОстрый сюрикен (анимированый)\nТабличка к нику 'Суета'\n1.000 "donate_title"",
		"Транспорт 'Helicopter' (#3370)\nТабличка к нику 'Первый'\n1.000 "donate_title"",
		"Одежда 'Sub Zero' (#4707)\nТранспорт 'Monster Dog' (#3377)\nТабличка к нику 'Отец'\n1.000 "donate_title"",
		"Жёлтые крылья (анимированый)\nТранспорт 'Hot-Rod Hell' (#3382)\nТабличка к нику 'Король'\n5.000 "donate_title""
	} ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 2048, "\
	{"#cBL"}** Лотерея №%d **\n\n\
	{"#cWH"}В данной лотерее может принять абсолютно любой участние и\n\
	купить {"#cLY"}неограниченное {"#cWH"}количество билетов.\n\
	Чем {"#cLY"}больше билетов{"#cWH"}, тем больше шанс победить в лотерее.\n\
	Каждый участник, при желании, может принять участие во Всех лотереях сразу или\n\
	в некоторых, по выбору участника.\n\n\
	Победитель будет выбран один из всех участников.\n\
	Каждая лотерея содержит уникальные призы. Призы фиксированные.\n\n\
	{"#cBL"}** Призы лотерии **\n\n\
	{"#cWH"}%s\n\n\
	Стоимость одного билета {"#cGN"}%d "donate_title"{"#cWH"}.\n\
	У Вас {"#cLY"}%d {"#cWH"}билетов данной лотереи.\n\
	Дата подведения итогов: {"#cLY"}в 00:00 по МСК 01.01.2024{"#cWH"}.\n\
	Если Вас не будет в игре, то приз отправится в Ваш инвентарь.\n\n\
	{"#cGRDialog"}* Вы желаете приобрести билет выбранной лотереи?", _slot_id + 1, _itemname [ _slot_id ], _price [ _slot_id ], get_player_lottery_count ( playerid, _slot_id ) ) ;
	show_dialog ( playerid, d_winter_lottery_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Лотерея", global_string, "Купить", "Назад" ) ;
	return 1 ;
}

stock winter_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_year_question:
		{
			if ( ! response ) return 1 ;
			
			new _id = -1 ;
			for ( new i = 0 ; i < 10 ; i ++ )
			{
				if ( player_yes_year_question [ playerid ] [ i ] != -1 ) continue ;
				
				_id = i ;
				break ;
			}
			
			if ( _id != -1 )
			{
				new _q_id = get_player_use_listitem ( playerid ) ;
				if ( year_yes_question [ _q_id ] == listitem ) player_yes_year_question [ playerid ] [ _id ] = 1 ;
				else player_yes_year_question [ playerid ] [ _id ] = 0 ;
			}
			
			if ( player_year_question [ playerid ] >= 1 || _id == -1 )
			{
				new _count = 0 ;
				for ( new i = 0 ; i < 10 ; i ++ )
				{
					if ( player_yes_year_question [ playerid ] [ i ] == 0 ) continue ;
					
					_count ++ ;
				}
				
				if ( _count >= 10 && p_info [ playerid ] [ level ] > 4 )
				{
					if ( random ( 10 ) == 1 ) give_inventory ( playerid, RandomEx ( skin_cross + 4718, skin_cross + 4719 ), 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					else 
					{
						new _acc_id ;
						if ( random ( 2 ) == 1 ) _acc_id = RandomEx ( 5016, 5019 ) ;
						else _acc_id = RandomEx ( 5016, 5019 ) ;
						give_player_item ( playerid, _acc_id ) ;
					}
				}
				
				give_player_donate ( playerid, _count * 10, 2 ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, _count * 10, p_info [ playerid ] [ donate ], "(donate) загадки" ) ;
				
				new scm_string [ 75 + 9 ] ;
				format ( scm_string, sizeof scm_string, "* Вы получили {"#cWH"}%d "donate_title" {55D400}за разгадывание загадок.", _count * 10 ) ;
				SendClientMessage ( playerid, col_green, scm_string ) ;
				
				year_quest [ playerid ] += 1 ;
				update_int_sql ( playerid, "u_year_quest", year_quest [ playerid ] ) ;
				
				year_quest_progress [ playerid ] = 0 ;
				update_int_sql ( playerid, "u_winter_progress", year_quest_progress [ playerid ] ) ;
			}
			else
			{
				player_year_question [ playerid ] ++ ;
				
				new _quest_id = 0 ;
				do
				{
					_quest_id = random ( sizeof year_yes_question ) ;
				}
				while ( player_non_year_question [ playerid ] [ _quest_id ] == 1 ) ;
				
				player_non_year_question [ playerid ] [ _quest_id ] = 1 ;
				set_player_use_listitem ( playerid, _quest_id ) ;
				show_year_question ( playerid, _quest_id ) ;
			}
			
			checking_winter_progress ( playerid, 1, 1 ) ;
			return 1 ;
		}
		case d_winter_lottery:
		{
			if ( ! response ) return 1 ;
			
			set_player_use_listitem ( playerid, listitem ) ;
			show_winter_lottery ( playerid, listitem ) ;
			return 1 ;
		}
		case d_winter_lottery_buy:
		{
			if ( ! response )
			{
				show_donate_winter ( playerid ) ;
				return 1 ;
			}
			
			static const _price [ ] = { 25, 45, 75, 150, 300 } ;
			
			new _id = get_player_use_listitem ( playerid ) ;
			if ( ! get_player_donate ( playerid, _price [ _id ], 2 ) )
			{
				show_winter_lottery ( playerid, _id ) ;
				return 1 ;
			}
			
			set_player_donate ( playerid, _price [ _id ], 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price [ _id ], p_info [ playerid ] [ donate ], "(donate) лотерея" ) ;
			
			player_winter_lottery [ playerid ] [ _id ] += 1 ;
			
			new sql_string [ 85 + 9 + MAX_PLAYER_NAME ] ;
			format ( sql_string, sizeof sql_string, "INSERT INTO `winter_lottery` (`u_id`,`u_name`,`u_lottery`) VALUES ('%d','%s','%d')",
			p_info [ playerid ] [ id ], p_info [ playerid ] [ name ], _id ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
			
			show_winter_lottery ( playerid, _id ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели лотерейный билет." ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock winter_OnPlayerDisconnect ( playerid )
{
	if ( year_quest [ playerid ] == 1 )
	{
		year_quest [ playerid ] += 1 ;
		update_int_sql ( playerid, "u_year_quest", year_quest [ playerid ] ) ;
				
		year_quest_progress [ playerid ] = 0 ;
		update_int_sql ( playerid, "u_winter_progress", year_quest_progress [ playerid ] ) ;
	}
	return 1 ;
}

stock get_player_lottery_count ( playerid, _l_id )
{
	new _l_count = 0 ;

	if ( player_winter_lottery [ playerid ] [ _l_id ] > 0 ) return player_winter_lottery [ playerid ] [ _l_id ] ;

	static const _str [ ] = "SELECT `u_id` FROM `winter_lottery` WHERE `u_id` = '%d' AND `u_lottery` = '%d'" ;
	new query_string [ sizeof _str + ( 9 * 2 ) ] ;
	format ( query_string, sizeof ( query_string ), _str, p_info [ playerid ] [ id ], _l_id ) ;
	new Cache:result = mysql_query ( sql_connection, query_string ) ;
	_l_count = cache_num_rows ( ) ;
	cache_delete ( result ) ;
	return _l_count ;
}

stock clear_player_lottery ( playerid )
{
	player_winter_lottery [ playerid ] [ 0 ] =
	player_winter_lottery [ playerid ] [ 1 ] =
	player_winter_lottery [ playerid ] [ 2 ] =
	player_winter_lottery [ playerid ] [ 3 ] =
	player_winter_lottery [ playerid ] [ 4 ] =
	player_year_question [ playerid ] = 0 ;
	
	player_non_year_question [ playerid ] = clear_player_questopn ;
	player_yes_year_question [ playerid ] = clear_player_yes ;
	player_winter_house [ playerid ] = clear_player_winter_house ;
	return 1 ;
}

CMD:winteritog ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	
	for ( new i = 0 ; i < 4 ; i ++ )
	{
		new sql_string [ 126 + 9 ] ;
		format ( sql_string, sizeof sql_string, "SELECT * FROM `winter_lottery` WHERE `u_lottery` = '%d' ORDER BY RAND() LIMIT 1", i ) ;
		mysql_tquery ( sql_connection, sql_string, "winter_itog_callback", "d", i ) ;
	}
	return 1 ;
}

callback: winter_itog_callback ( _l_id )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	new _u_id = cache_get_field_content_int ( 0, "u_id", sql_connection ) ;
	new _account_name [ MAX_PLAYER_NAME ] ;
	cache_get_field_content ( 0, "u_name", _account_name, sql_connection, MAX_PLAYER_NAME ) ;
	
	new scm_string [ 45 + 9 + MAX_PLAYER_NAME ] ;
	format ( scm_string, sizeof scm_string, "* Победитель лотереи №%d: %s. Поздравляем!", _l_id + 1, _account_name ) ;
	SendClientMessageToAll ( col_yellow, scm_string ) ;
	
	new sql_string [ 76 + ( 9 * 2 ) ] ;
	format ( sql_string, sizeof sql_string, "UPDATE `winter_winner` SET `u_id` = '%d' WHERE `u_lottery` = '%d' LIMIT 1", _u_id, _l_id ) ;
	mysql_tquery ( sql_connection, sql_string ) ;
	
	new header_string [ 64 ] ;
	format ( header_string, sizeof header_string, "Лотерея #%d", _l_id + 1 ) ;
	insert_debtor_message ( header_string, "{"#cGInfo"}* {"#cWH"}Вы победители в лотерее!\nИспользуйте {"#cGInfo"}/rlot{"#cWH"}.", _u_id ) ;
	return 1 ;
}

CMD:rlot ( playerid )
{
	new sql_string [ 126 + 9 ] ;
	format ( sql_string, sizeof sql_string, "SELECT * FROM `winter_winner` WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, sql_string, "winter_winner_callback", "d", playerid ) ;
	return 1 ;
}

callback: winter_winner_callback ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы не победили в лотерее!" ) ;
	
	new _u_lottery = cache_get_field_content_int ( 0, "u_lottery", sql_connection ) ;

	switch ( _u_lottery )
	{
		case 0:
		{
			give_inventory ( playerid, 4645, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, -1 ) ;
			give_player_donate ( playerid, 1000, 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, 1000, p_info [ playerid ] [ donate ], "(donate) выйгрыш лотерея" ) ;
			
			new sql_format [ 200 ] ;
			format ( sql_format, sizeof sql_format, "UPDATE `users` SET `u_tag_style` = '2', `u_tag_text` = 'TOP', `u_tag_color` = '4582A1', `u_tag_color_box` = '4582A1' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, sql_format ) ;
		}
		case 1:
		{
			give_inventory ( playerid, 4622, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, -1 ) ;
			give_player_donate ( playerid, 1000, 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, 1000, p_info [ playerid ] [ donate ], "(donate) выйгрыш лотерея" ) ;
			
			new sql_format [ 200 ] ;
			format ( sql_format, sizeof sql_format, "UPDATE `users` SET `u_tag_style` = '2', `u_tag_text` = 'Суета', `u_tag_color` = '4582A1', `u_tag_color_box` = '4582A1' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, sql_format ) ;
		}
		case 2:
		{
			give_inventory ( playerid, 3370, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, -1 ) ;
			give_player_donate ( playerid, 1000, 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, 1000, p_info [ playerid ] [ donate ], "(donate) выйгрыш лотерея" ) ;
			
			new sql_format [ 200 ] ;
			format ( sql_format, sizeof sql_format, "UPDATE `users` SET `u_tag_style` = '2', `u_tag_text` = 'Первый', `u_tag_color` = '4582A1', `u_tag_color_box` = '4582A1' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, sql_format ) ;
		}
		case 3:
		{
			give_inventory ( playerid, 4707, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, -1 ) ;
			give_inventory ( playerid, 3377, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, -1 ) ;
			give_player_donate ( playerid, 1000, 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, 1000, p_info [ playerid ] [ donate ], "(donate) выйгрыш лотерея" ) ;
			
			new sql_format [ 200 ] ;
			format ( sql_format, sizeof sql_format, "UPDATE `users` SET `u_tag_style` = '2', `u_tag_text` = 'Отец', `u_tag_color` = '4582A1', `u_tag_color_box` = '4582A1' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, sql_format ) ;
		}
		case 4:
		{
			give_inventory ( playerid, 8253, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, -1 ) ;
			give_inventory ( playerid, 3382, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, -1 ) ;
			give_player_donate ( playerid, 5000, 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, 5000, p_info [ playerid ] [ donate ], "(donate) выйгрыш лотерея" ) ;
			
			new sql_format [ 200 ] ;
			format ( sql_format, sizeof sql_format, "UPDATE `users` SET `u_tag_style` = '2', `u_tag_text` = 'Король', `u_tag_color` = '4582A1', `u_tag_color_box` = '4582A1' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, sql_format ) ;
		}
	}
	
	new sql_string [ 76 + ( 9 * 2 ) ] ;
	format ( sql_string, sizeof sql_string, "UPDATE `winter_winner` SET `u_id` = '-1' WHERE `u_lottery` = '%d' LIMIT 1", _u_lottery ) ;
	mysql_tquery ( sql_connection, sql_string ) ;
	return 1 ;
}

/*CREATE TABLE `winter_winner` (`inc_id` INT(3) NOT NULL AUTO_INCREMENT , `u_id` INT(11) NOT NULL DEFAULT '0' , `u_lottery` INT(3) NOT NULL DEFAULT '0' , PRIMARY KEY (`inc_id`)) ENGINE = InnoDB; 
INSERT INTO `winter_winner` (`inc_id`, `u_id`, `u_lottery`) VALUES ('1', '-1', '0'), ('2', '-1', '1');
INSERT INTO `winter_winner` (`inc_id`, `u_id`, `u_lottery`) VALUES ('3', '-1', '2'), ('4', '-1', '3');
INSERT INTO `winter_winner` (`inc_id`, `u_id`, `u_lottery`) VALUES ('5', '-1', '4');*/