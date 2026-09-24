new valentine_gift = 0 ;
new valentine_action = 0 ;
new valentine_gettime = 0 ;
new valentine_end_gettime = 0 ;

#define MAX_VALENTINE_QUEST 4
new player_valentine [ MAX_PLAYERS ] ;
new player_valentine_quest [ MAX_PLAYERS ] [ MAX_VALENTINE_QUEST ] ;
new player_valentine_quest_progress [ MAX_PLAYERS ] [ MAX_VALENTINE_QUEST ] ;
new player_valentine_status [ MAX_PLAYERS ] [ MAX_VALENTINE_QUEST ] ;
new player_valentine_select [ MAX_PLAYERS char ] ;
new bool: m_bValentineRPC [ MAX_PLAYERS ] ;
new bool: m_bUsedValentine [ MAX_PLAYERS ] ;

new Float: quest_start_position [ 6 ] [ 3 ] =
{
	{ 2373.7189, -1951.5236, 21.9759 },
	{ 33.5771, -2864.2258, 33.5225 },
	{ -2231.0458, 260.0757, 24.5395 },
	
	{ -2498.9375, 2896.6735, 40.5921 },
	{ -1060.6400, 2146.7180, 38.0321 },
	{ 1735.7314, 2269.7651, 15.8677 }
} ;

#define MAX_VALENTINE_BOX 5
new player_valentine_box [ MAX_PLAYERS ] [ MAX_VALENTINE_BOX ] ;

#define MAX_VALENTINE_PRICE 11
new valentine_price [ MAX_VALENTINE_PRICE ] =
{
	1_000_000,
	10_000_000,
	100_000_000,
	1_000_000_000,
	1_500_000_000,
	
	2_000,
	5_000,
	10_000,
	25_000,
	50_000,
	100_000
} ;

new valentine_price_ft [ MAX_VALENTINE_PRICE ] =
{
	6,
	60,
	600,
	6000,
	9000,
	
	2_000,
	5_000,
	10_000,
	25_000,
	50_000,
	100_000
} ;

/*new valentine_price [ MAX_VALENTINE_PRICE ] =
{
	500_000,
	5_000_000,
	50_000_000,
	500_000_000,
	750_000_000,
	
	2_000,
	5_000,
	10_000,
	25_000,
	50_000,
	100_000
} ;

new valentine_price_ft [ MAX_VALENTINE_PRICE ] =
{
	3,
	30,
	300,
	3000,
	4500,
	
	2_000,
	5_000,
	10_000,
	25_000,
	50_000,
	100_000
} ;*/

new valentine_box_name [ ] [ 22 ] =
{
	"Подарок XS",
	"Подарок S",
	"Подарок M",
	"Подарок L",
	"Подарок XL",
	
	"Предмет случайный",
	"Аксессуар случайный",
	"Одежда случайная"
} ;

new valentine_vehicle_model [ 3 ] = { 3327, 3368, 3364 } ;
new valentine_skin_model [ ] = { 4656, 4662, 4663, 4639, 4643, 4623, 4624, 4625 } ;
new valentine_acs_model [ ] = { 8108, 8111, 8112, 12643, 12644, 12645, 12670, 12671, 12672 } ;

new valentine_target [ 6 ] [ 128 ] =
{
	"Качай и играй",
	"Семьи в деле",
	"Сердца за любовь",
	
	"За прохождение заданий Event Pass все будут получать x1.2 дополнительного опыта в течении 48 часов!",
	"Каждый час все игроки будут получать по 1 "family_title" в течении 48 часов!",
	"Каждый час все игроки будут получать по 50 сердцец в течении 24 часов!"
} ;

#define MAX_VALENTINE_LOBBY 4
new player_valentine_lobby [ MAX_PLAYERS ] [ MAX_VALENTINE_LOBBY ] ;
new player_valentine_ready [ MAX_PLAYERS ] [ MAX_VALENTINE_LOBBY ] ;
new player_valentine_in_lobby [ MAX_PLAYERS ] ;

#define MAX_VALENTINE_TOP 8
#define MAX_VALENTINE_TOP_PLAYERS 5
enum _valentine_top
{
	valentine_name [ MAX_PLAYER_NAME ],
	valentine_count
} ;
new valentine_top [ MAX_VALENTINE_TOP ] [ MAX_VALENTINE_TOP_PLAYERS ] [ _valentine_top ] ;

enum
{
	d_valentine_friend = 10200,
	d_valentine_invite,
	d_valentine_gift,
	d_valentine_buy,
	d_valentine_buy_1
} ;

#include 									<custom/valentine>

CMD:valentine ( playerid )
{
	if ( valentine_end_gettime < gettime ( ) ) return 1 ;
	if ( p_t_info [ playerid ] [ p_logged ] == false ) return 1 ;

	new s_year, s_month, s_day, s_hour, s_minute, s_second ;
	timestamp_to_date ( valentine_end_gettime - gettime ( ), s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
	
	new str_date [ 32 ] ;
	format ( str_date, sizeof str_date, "%02d дн. %02d ч. %02d м.", s_day, s_hour, s_minute ) ;
	
	ValentineShow ( playerid, str_date, "Действует" ) ;
	return 1 ;
}

stock use_valentine_manager ( playerid, _i, _i2, _i3 )
{
	#if defined debug_rpc
		printf ( "[use_valentine_manager] playerid: %d, _i: %d, _i2: %d, _i3: %d", playerid, _i, _i2, _i3 ) ;
	#endif
	
	if ( valentine_end_gettime < gettime ( ) ) return 1 ;
	if ( p_t_info [ playerid ] [ p_logged ] == false ) return 1 ;
	if ( _i == 0 )
	{
		if ( _i2 == 0 && _i3 == 0 )
		{
			new s_year, s_month, s_day, s_hour, s_minute, s_second ;
			timestamp_to_date ( valentine_end_gettime - gettime ( ), s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
			
			new str_date [ 32 ] ;
			format ( str_date, sizeof str_date, "%02d дн. %02d ч. %02d м.", s_day, s_hour, s_minute ) ;
			
			ValentineShow ( playerid, str_date, "Действует" ) ;
		}
		else if ( _i2 == 3 )
		{
			player_valentine_select { playerid } = 1 ;
			ValentineLobbyShow ( playerid, 0 ) ;
			ValentineLobbyState ( playerid, LOBBY_STATE_START ) ;
			ValentineLobbySetName ( playerid, 0, p_info [ playerid ] [ name ] ) ;
			player_valentine_lobby [ playerid ] [ 0 ] = playerid ;
		}
		else if ( _i2 == 4 )
		{
			player_valentine_select { playerid } = 2 ;
			ValentineLobbyShow ( playerid, 1 ) ;
			ValentineLobbyState ( playerid, LOBBY_STATE_START ) ;
			ValentineLobbySetName ( playerid, 0, p_info [ playerid ] [ name ] ) ;
			player_valentine_lobby [ playerid ] [ 0 ] = playerid ;
		}
	}
	else if ( _i == 1 ) 
	{
		if ( _i2 == 0 && _i3 == 0 ) ValentineSendShow ( playerid ) ;
		else if ( _i2 > 0 && _i2 < 6 && _i3 == 0 ) SetPVarInt ( playerid, "current_valentine_box", _i2 - 1 ) ;
		else if ( _i2 == 6 && _i3 > 0 )
		{
			if ( p_info [ playerid ] [ hour_played ] < 5 )
			{
				send_check_cinfo ( playerid, "Доступно с 5 часов в игре.", 0, 300, CINFO_VALENTINE_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( player_valentine_box [ playerid ] [ GetPVarInt ( playerid, "current_valentine_box" ) ] < _i3 )
			{
				send_check_cinfo ( playerid, "У Вас нет такого количества подарков!", 0, 300, CINFO_VALENTINE_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			SetPVarInt ( playerid, "current_valentine_count", _i3 ) ;
			show_dialog ( playerid, d_valentine_gift, DIALOG_STYLE_INPUT, "{"#cBHD"}Подарить другу", "{"#cWH"}Укажите ID друга, которому хотите подарить бокс валентинок:", "Выбрать", "Отмена" ) ;
		}
		else if ( _i2 == 7 && _i3 > 0 )
		{
			if ( p_info [ playerid ] [ hour_played ] < 5 )
			{
				send_check_cinfo ( playerid, "Доступно с 5 часов в игре.", 0, 300, CINFO_VALENTINE_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			if ( Iter_Count(logged_players) < 50 )
			{
				send_check_cinfo ( playerid, "Дарить случайному игроку можно, когда онлайн выше 50.", 0, 300, CINFO_VALENTINE_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			new _count = _i3, _box_id = GetPVarInt ( playerid, "current_valentine_box" ) ;
			DeletePVar ( playerid, "current_valentine_box" ) ;
			
			if ( player_valentine_box [ playerid ] [ _box_id ] < _i3 )
			{
				send_check_cinfo ( playerid, "У Вас нет такого количества подарков!", 0, 300, CINFO_VALENTINE_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			player_valentine_box [ playerid ] [ _box_id ] -= _count ;
			update_valentine_box ( playerid ) ;
			save_statistic_valentine ( playerid, 0, _count, 0, 0 ) ;
			
			switch ( _box_id )
			{
				/*case 0: _count = ( random ( 3 ) + 1 ) * _count ;
				case 1: _count = ( random ( 20 ) + 15 ) * _count ;
				case 2: _count = ( random ( 200 ) + 200 ) * _count ;
				case 3: _count = ( random ( 2000 ) + 2000 ) * _count ;
				case 4: _count = ( random ( 20000 ) + 20000 ) * _count ;*/
				
				case 0: _count = ( random ( 3 ) + 1 ) * _count ;
				case 1: _count = ( random ( 20 ) + 15 ) * _count ;
				case 2: _count = ( random ( 200 ) + 200 ) * _count ;
				case 3: _count = ( random ( 500 ) + 2000 ) * _count ;
				case 4: _count = ( random ( 5000 ) + 20000 ) * _count ;
			}
			
			new _targetid = Iter_Random(logged_players) ;
			
			player_valentine [ _targetid ] += _count ;
			update_valentine_sql ( _targetid, "u_valentine", player_valentine [ _targetid ] ) ;
			if ( player_device { _targetid } == 2 && p_info [ _targetid ] [ hud_id ] ) SendCheckHud ( _targetid ) ;
			save_statistic_valentine ( _targetid, _count, 0, 0, 0 ) ;
			
			player_valentine [ playerid ] += _count ;
			update_valentine_sql ( playerid, "u_valentine", player_valentine [ playerid ] ) ;
			if ( player_device { playerid } == 2 && p_info [ playerid ] [ hud_id ] ) SendCheckHud ( playerid ) ;
			
			new scm_string [ 70 + MAX_PLAYER_NAME + 9 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}%s подарил(а) Вам {"#cGN"}%d сердец{"#cWH"}.", p_info [ playerid ] [ name ], _count ) ;
			SendClientMessage ( _targetid, col_white, scm_string ) ;
			
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы подарили %s {"#cGN"}%d сердец{"#cWH"}.", p_info [ _targetid ] [ name ], _count ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "(heart) подарил %s %d сердец", p_info [ _targetid ] [ name ], _count ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _count, player_valentine [ playerid ], scm_string ) ;
			
			ValentineSendShow ( playerid ) ;
			ValentineGiftUpdate ( _count ) ;
		}
	}
	else if ( _i == 2 && _i3 == 0 )
	{
		if ( _i2 == 0 ) ValentineTasksShow ( playerid ) ;
		else if ( _i2 > 0 )
		{
			if ( player_valentine_status [ playerid ] [ _i2 - 1 ] == 1 )
			{
				new _quest_progress = player_valentine_quest [ playerid ] [ _i2 - 1 ] ;
				if ( _quest_progress == 3 )
				{
					player_valentine_quest [ playerid ] [ _i2 - 1 ] += 1 ;
					update_valentine_quest ( playerid ) ;
					
					player_valentine_status [ playerid ] [ _i2 - 1 ] = 0 ;
					update_valentine_status ( playerid ) ;
					
					player_valentine_box [ playerid ] [ 1 ] += 1 ;
					update_valentine_box ( playerid ) ;
					
					save_statistic_valentine ( playerid, 0, 1, 0, 0 ) ;
				}
				else
				{
					player_valentine_quest [ playerid ] [ _i2 - 1 ] += 1 ;
					update_valentine_quest ( playerid ) ;
					
					player_valentine_status [ playerid ] [ _i2 - 1 ] = 0 ;
					update_valentine_status ( playerid ) ;
					
					player_valentine_box [ playerid ] [ 0 ] += 1 ;
					update_valentine_box ( playerid ) ;
					
					save_statistic_valentine ( playerid, 0, 1, 0, 0 ) ;
				}
				ValentineTasksShow ( playerid ) ;
			}
			else
			{
				if ( _i2 == 3 )
				{
					player_valentine_select { playerid } = 1 ;
					ValentineLobbyShow ( playerid, 0 ) ;
					ValentineLobbyState ( playerid, LOBBY_STATE_START ) ;
					ValentineLobbySetName ( playerid, 0, p_info [ playerid ] [ name ] ) ;
					player_valentine_lobby [ playerid ] [ 0 ] = playerid ;
				}
				else if ( _i2 == 4 )
				{
					player_valentine_select { playerid } = 2 ;
					ValentineLobbyShow ( playerid, 1 ) ;
					ValentineLobbyState ( playerid, LOBBY_STATE_START ) ;
					ValentineLobbySetName ( playerid, 0, p_info [ playerid ] [ name ] ) ;
					player_valentine_lobby [ playerid ] [ 0 ] = playerid ;
				}
			}
		}
	}
	else if ( _i == 3 )
	{
		if ( _i2 == 0 && _i3 == 0 ) ValentineShopShow ( playerid ) ;
		else if ( _i2 > 0 && _i3 == 0 )
		{
			SetPVarInt ( playerid, "valentine_box", _i2 ) ;
			if ( _i2 <= 5 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 512, "\
					Купить за {"#cGN"}${"#cWH"} - {"#cGN"}%d${"#cWH"}\n\
					Купить за {"#cOR"}"family_title_abb"{"#cWH"} - {"#cGN"}%d "family_title"{"#cWH"}\n \n\
					{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}.", valentine_price [ _i2 - 1 ], valentine_price_ft [ _i2 - 1 ], valentine_box_name [ _i2 - 1 ] ) ;
				show_dialog ( playerid, d_valentine_buy_1, DIALOG_STYLE_LIST, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
			}
			else if ( _i2 == 6 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}за {"#cGN"}%d сердец{"#cWH"}.\n\n{"#cGRDialog"}Вы уверены?", valentine_box_name [ _i2 - 1 ], valentine_price [ _i2 - 1 ] ) ;
				show_dialog ( playerid, d_valentine_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
			}
			else if ( _i2 == 7 )
			{
				new _skin_string [ 512 ] ;
				for ( new i = 0 ; i < sizeof valentine_acs_model ; i ++ )
				{
					format ( _skin_string, sizeof _skin_string, "%s{"#cWH"}%d. %s (#%d)\n", _skin_string, i + 1, get_accessorie_name ( valentine_acs_model [ i ] ), valentine_acs_model [ i ] ) ;
				}
		
				global_string [ 0 ] = EOS ;
				format ( global_string, 512, "\
					{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}за {"#cGN"}%d сердец{"#cWH"}.\n\n\
					{"#cBL"}** Возможные аксессуары **\n\n\
					{"#cWH"}%s\n\
					{"#cGRDialog"}Вы уверены?", 
					valentine_box_name [ _i2 - 1 ], valentine_price [ _i2 - 1 ], _skin_string ) ;
				show_dialog ( playerid, d_valentine_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
			}
			else if ( _i2 == 8 )
			{
				new _skin_string [ 512 ] ;
				for ( new i = 0 ; i < sizeof valentine_skin_model ; i ++ )
				{
					format ( _skin_string, sizeof _skin_string, "%s{"#cWH"}%d. %s (#%d)\n", _skin_string, i + 1, get_skin_name ( valentine_skin_model [ i ] ), valentine_skin_model [ i ] ) ;
				}
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 512, "\
					{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}за {"#cGN"}%d сердец{"#cWH"}.\n\n\
					{"#cBL"}** Возможные скины **\n\n\
					{"#cWH"}%s\n\
					{"#cGRDialog"}Вы уверены?", 
				valentine_box_name [ _i2 - 1 ], valentine_price [ _i2 - 1 ], _skin_string ) ;
				show_dialog ( playerid, d_valentine_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
			}
			else if ( _i2 >= 400 && _i2 < 4000 )
			{
				new _v_model = _i2, _id_car ;
				
				if ( _v_model == valentine_vehicle_model [ 0 ] ) _id_car = 8 ;
				else if ( _v_model == valentine_vehicle_model [ 1 ] ) _id_car = 9 ;
				else if ( _v_model == valentine_vehicle_model [ 2 ] ) _id_car = 10 ;
		
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}за {"#cGN"}%d сердец{"#cWH"}.\n\n{"#cGRDialog"}Вы уверены?", GetVehicleNameEx ( -1, _v_model ), valentine_price [ _id_car ] ) ;
				show_dialog ( playerid, d_valentine_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
			}
			else
			{
				new _v_model = valentine_vehicle_model [ _i2 - 9 ] ;
		
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}за {"#cGN"}%d сердец{"#cWH"}.\n\n{"#cGRDialog"}Вы уверены?", GetVehicleNameEx ( -1, _v_model ), valentine_price [ _i2 - 1 ] ) ;
				show_dialog ( playerid, d_valentine_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
			}
		}
	}
	else if ( _i == 4 )
	{
		if ( _i2 == 0 && _i3 == 0 )
		{
			ValentineTopShow ( playerid ) ;
			ValentineAddTop ( playerid, 0 ) ;
		}
		else if ( _i2 == 1 && _i3 == 0 ) ValentineAddTop ( playerid, 1 ) ;
	}
	else if ( _i == 5 && _i2 == 0 && _i3 == 0 ) ValentineDescShow ( playerid ) ;
	else if ( _i == 6 && _i2 == 1 && _i3 == 0 )
	{
		new _select = player_valentine_select { playerid } ;
		if ( _select > 0 )
		{
			for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
			{
				if ( player_valentine_lobby [ playerid ] [ i ] == INVALID_PLAYER_ID ) continue ;
					
				new _player_lobby_id = player_valentine_lobby [ playerid ] [ i ] ;
				
				ValentineLobbyReady ( _player_lobby_id, i, 0 ) ;
				ValentineLobbySetName ( _player_lobby_id, i, "Нет игрока" ) ;
				
				ValentineLobbyHide ( _player_lobby_id ) ;
			}
				
			for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
			{
				player_valentine_ready [ playerid ] [ i ] = 0 ;
				player_valentine_lobby [ playerid ] [ i ] = INVALID_PLAYER_ID ;
				
				ValentineLobbyReady ( playerid, i, 0 ) ;
				ValentineLobbySetName ( playerid, i, "Нет игрока" ) ;
			}
			
			player_valentine_select { playerid } = 0 ;
			ValentineLobbyHide ( playerid ) ;
		}
		else
		{
			if ( player_valentine_in_lobby [ playerid ] == INVALID_PLAYER_ID )
			{
				ValentineLobbyHide ( playerid ) ;
				return 1 ;
			}
			new _targetid = player_valentine_in_lobby [ playerid ] ;
			player_valentine_in_lobby [ playerid ] = INVALID_PLAYER_ID ;
			
			_select = player_valentine_select { _targetid } - 1 ;
			if ( _select == 0 || _select == 1 )
			{
				for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
				{
					if ( player_valentine_lobby [ _targetid ] [ i ] != playerid ) continue ;

					player_valentine_ready [ _targetid ] [ i ] = 0 ;
					player_valentine_lobby [ _targetid ] [ i ] = INVALID_PLAYER_ID ;
					for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
					{
						if ( player_valentine_lobby [ _targetid ] [ q ] == INVALID_PLAYER_ID ) continue ;
							
						new _player_lobby_id = player_valentine_lobby [ _targetid ] [ q ] ;
						ValentineLobbyReady ( _player_lobby_id, i, 0 ) ;
						ValentineLobbySetName ( _player_lobby_id, i, "Нет игрока" ) ;
					}
					break ;
				}
			}
			
			ValentineLobbyState ( _targetid, LOBBY_STATE_START ) ;
			ValentineLobbyHide ( playerid ) ;
		}
	}
	else if ( _i == 6 && _i2 == 2 && _i3 == 0 )
	{
		if ( admin_info [ playerid ] [ admin ] > 0 && admin_info [ playerid ] [ admin ] < 8 )
		{
			send_check_cinfo ( playerid, "У Вас нет возможности проходить задания!", 0, 300, CINFO_VALENTINE_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		new _select = player_valentine_select { playerid } ;
		if ( _select > 0 )
			show_dialog ( playerid, d_valentine_friend, DIALOG_STYLE_INPUT, "{"#cBHD"}Пригласить друга", "{"#cWH"}Укажите ID друга, которого желаете пригласить в лобби:", "Выбрать", "Отмена" ) ;
	}
	else if ( _i == 6 && _i2 == 3 && _i3 == 0 )
	{
		new _select = player_valentine_select { playerid } ;
		if ( _select > 0 )
		{
			new _count = 0 ;
			for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
			{
				if ( player_valentine_lobby [ playerid ] [ i ] == INVALID_PLAYER_ID ) continue ;
				
				_count ++ ;
			}
	
			if ( _select == 1 && _count >= PLAYER_IN_TWO_LOBBY || _select == 2 && _count >= PLAYER_IN_FOUR_LOBBY )
			{
				for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
				{
					if ( player_valentine_lobby [ playerid ] [ i ] != playerid ) continue ;

					player_valentine_ready [ playerid ] [ i ] = 1 ;
					new _count_ready = 0 ;
					for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
					{
						if ( player_valentine_lobby [ playerid ] [ q ] == INVALID_PLAYER_ID ) continue ;
							
						ValentineLobbyReady ( player_valentine_ready [ playerid ] [ q ], i, 1 ) ;
						if ( player_valentine_ready [ playerid ] [ q ] == 1 ) _count_ready ++ ;
					}
					
					if ( _select == 1 && _count_ready >= PLAYER_IN_TWO_LOBBY || _select == 2 && _count_ready >= PLAYER_IN_FOUR_LOBBY )
					{
						// start lobby
						new _random ;
						if ( _select == 1 ) _random = random ( 3 ) ;
						else _random = RandomEx ( 3, 5 ) ;
						for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
						{
							if ( player_valentine_lobby [ playerid ] [ q ] == INVALID_PLAYER_ID ) continue ;
							
							new player_id = player_valentine_lobby [ playerid ] [ q ] ;
							SetPlayerRaceCheckpoint ( player_id, 1, quest_start_position [ _random ] [ 0 ], quest_start_position [ _random ] [ 1 ], quest_start_position [ _random ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
							is_gps_used { player_id } = 20 ;
							
							send_check_cinfo ( player_id, "Отправляйтесь на указанную точку на карте!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
							m_bUsedValentine [ player_id ] = true ;
							ValentineLobbyHide ( player_id ) ;
						}
					}
					break ;
				}
			}
			else
			{
				// Поиск случайных игроков
			}
		}
		else
		{
			if ( player_valentine_in_lobby [ playerid ] == INVALID_PLAYER_ID )
			{
				ValentineLobbyHide ( playerid ) ;
				return 1 ;
			}
			
			new _targetid = player_valentine_in_lobby [ playerid ] ;
			
			new _count = 0 ;
			for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
			{
				if ( player_valentine_lobby [ _targetid ] [ i ] == INVALID_PLAYER_ID ) continue ;
				
				_count ++ ;
			}
	
			_select = player_valentine_select { _targetid } - 1 ;
			if ( _select == 0 && _count >= PLAYER_IN_TWO_LOBBY || _select == 1 && _count >= PLAYER_IN_FOUR_LOBBY )
			{
				for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
				{
					if ( player_valentine_lobby [ _targetid ] [ i ] != playerid ) continue ;

					player_valentine_ready [ _targetid ] [ i ] = 1 ;
					new _count_ready = 0 ;
					for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
					{
						if ( player_valentine_lobby [ _targetid ] [ q ] == INVALID_PLAYER_ID ) continue ;
							
						ValentineLobbyReady ( player_valentine_ready [ _targetid ] [ q ], i, 1 ) ;
						if ( player_valentine_ready [ _targetid ] [ q ] == 1 ) _count_ready ++ ;
					}
					
					if ( _select == 0 && _count_ready >= PLAYER_IN_TWO_LOBBY || _select == 1 && _count_ready >= PLAYER_IN_FOUR_LOBBY )
					{
						// start lobby
						new _random ;
						if ( _select == 0 ) _random = random ( 3 ) ;
						else _random = RandomEx ( 3, 5 ) ;
						for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
						{
							if ( player_valentine_lobby [ _targetid ] [ q ] == INVALID_PLAYER_ID ) continue ;
							
							new player_id = player_valentine_lobby [ _targetid ] [ q ] ;
							SetPlayerRaceCheckpoint ( player_id, 1, quest_start_position [ _random ] [ 0 ], quest_start_position [ _random ] [ 1 ], quest_start_position [ _random ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
							is_gps_used { player_id } = 20 ;
							
							send_check_cinfo ( player_id, "Отправляйтесь на указанную точку на карте!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
							m_bUsedValentine [ player_id ] = true ;
							ValentineLobbyHide ( player_id ) ;
						}
					}
					break ;
				}
			}
		}
	}
	return 1 ;
}

stock valentine_RaceCheckpoint ( playerid )
{
	if ( is_gps_used { playerid } == 20 )
	{
		new _select = player_valentine_select { playerid } ;
		if ( _select > 0 )
		{
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) )
			{
				for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
				{
					if ( player_valentine_lobby [ playerid ] [ q ] == INVALID_PLAYER_ID ) continue ;
					
					new _targetid = player_valentine_lobby [ playerid ] [ q ] ;
					if ( GetPlayerDistanceFromPoint ( playerid, p_t_info [ _targetid ] [ p_pos ] [ 0 ],
																p_t_info [ _targetid ] [ p_pos ] [ 1 ],
																p_t_info [ _targetid ] [ p_pos ] [ 2 ] ) > 15 )
					{
						send_check_cinfo ( playerid, "Не все члены команды собрались в одном месте!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
				}
				
				for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
				{
					if ( player_valentine_lobby [ playerid ] [ q ] == INVALID_PLAYER_ID ) continue ;
					
					new _targetid = player_valentine_lobby [ playerid ] [ q ] ;
					
					DisablePlayerRaceCheckpoint ( _targetid ) ;
					is_gps_used { _targetid } = 0 ;
					
					RemovePlayerAttachedObject ( _targetid, 0 ) ;
					
					if ( _select == 1 ) save_statistic_valentine ( _targetid, 0, 0, 1, 0 ), give_valentine_progress ( _targetid, 2 ) ;
					else save_statistic_valentine ( _targetid, 0, 0, 0, 1 ), give_valentine_progress ( _targetid, 3 ) ;
					
					send_check_cinfo ( _targetid, "Задание успешно выполнено!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
				}
				valentine_OnPlayerDisconnect ( playerid ) ;
				return 1 ;
			}
			
			for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
			{
				if ( player_valentine_lobby [ playerid ] [ q ] == INVALID_PLAYER_ID ) continue ;
				
				new _targetid = player_valentine_lobby [ playerid ] [ q ] ;
				if ( GetPlayerDistanceFromPoint ( playerid, p_t_info [ _targetid ] [ p_pos ] [ 0 ],
															p_t_info [ _targetid ] [ p_pos ] [ 1 ],
															p_t_info [ _targetid ] [ p_pos ] [ 2 ] ) > 15 )
				{
					send_check_cinfo ( playerid, "Не все члены команды собрались в одном месте!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			}
			
			new _random ;
			if ( _select == 0 ) _random = RandomEx ( 3, 5 ) ;
			else _random = random ( 3 ) ;
			for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
			{
				if ( player_valentine_lobby [ playerid ] [ q ] == INVALID_PLAYER_ID ) continue ;
				
				new _targetid = player_valentine_lobby [ playerid ] [ q ] ;
				
				DisablePlayerRaceCheckpoint ( _targetid ) ;
				is_gps_used { _targetid } = 0 ;
		
				SetPlayerAttachedObject ( _targetid, 1, 1550, 1,   0.160001, -0.234000, -0.009998, 1.100002, 95.899940, -17.500007  ) ;
				
				SetPlayerRaceCheckpoint ( _targetid, 1, quest_start_position [ _random ] [ 0 ], quest_start_position [ _random ] [ 1 ], quest_start_position [ _random ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
				is_gps_used { _targetid } = 20 ;
							
				send_check_cinfo ( _targetid, "Отправляйтесь на указанную точку на карте!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
			}
			return 1 ;
		}
		else if ( player_valentine_in_lobby [ playerid ] != INVALID_PLAYER_ID )
		{
			new _targetid = player_valentine_in_lobby [ playerid ] ;
		
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 1 ) )
			{
				for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
				{
					if ( player_valentine_lobby [ _targetid ] [ q ] == INVALID_PLAYER_ID ) continue ;
					
					new player_id = player_valentine_lobby [ _targetid ] [ q ] ;
					if ( GetPlayerDistanceFromPoint ( playerid, p_t_info [ player_id ] [ p_pos ] [ 0 ],
																p_t_info [ player_id ] [ p_pos ] [ 1 ],
																p_t_info [ player_id ] [ p_pos ] [ 2 ] ) > 15 )
					{
						send_check_cinfo ( playerid, "Не все члены команды собрались в одном месте!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}
				}
				
				for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
				{
					if ( player_valentine_lobby [ _targetid ] [ q ] == INVALID_PLAYER_ID ) continue ;
					
					new player_id = player_valentine_lobby [ _targetid ] [ q ] ;
					
					DisablePlayerRaceCheckpoint ( player_id ) ;
					is_gps_used { player_id } = 0 ;
					
					RemovePlayerAttachedObject ( player_id, 0 ) ;
					
					if ( _select == 1 ) save_statistic_valentine ( player_id, 0, 0, 1, 0 ), give_valentine_progress ( player_id, 2 ) ;
					else save_statistic_valentine ( player_id, 0, 0, 0, 1 ), give_valentine_progress ( player_id, 3 ) ;
					
					send_check_cinfo ( player_id, "Задание успешно выполнено!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
				}
				valentine_OnPlayerDisconnect ( _targetid ) ;
				return 1 ;
			}
			
			for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
			{
				if ( player_valentine_lobby [ _targetid ] [ q ] == INVALID_PLAYER_ID ) continue ;
				
				new player_id = player_valentine_lobby [ _targetid ] [ q ] ;
				if ( GetPlayerDistanceFromPoint ( playerid, p_t_info [ player_id ] [ p_pos ] [ 0 ],
															p_t_info [ player_id ] [ p_pos ] [ 1 ],
															p_t_info [ player_id ] [ p_pos ] [ 2 ] ) > 15 )
				{
					send_check_cinfo ( playerid, "Не все члены команды собрались в одном месте!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			}
			
			new _random ;
			if ( _select == 0 ) _random = RandomEx ( 3, 5 ) ;
			else _random = random ( 3 ) ;
			for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
			{
				if ( player_valentine_lobby [ _targetid ] [ q ] == INVALID_PLAYER_ID ) continue ;
				
				new player_id = player_valentine_lobby [ _targetid ] [ q ] ;
				
				DisablePlayerRaceCheckpoint ( player_id ) ;
				is_gps_used { player_id } = 0 ;
		
				SetPlayerAttachedObject ( player_id, 1, 1550, 1,   0.160001, -0.234000, -0.009998, 1.100002, 95.899940, -17.500007  ) ;
				
				SetPlayerRaceCheckpoint ( player_id, 1, quest_start_position [ _random ] [ 0 ], quest_start_position [ _random ] [ 1 ], quest_start_position [ _random ] [ 2 ], 0.0, 0.0, 0.0, 4.0 ) ;
				is_gps_used { player_id } = 20 ;
							
				send_check_cinfo ( player_id, "Отправляйтесь на указанную точку на карте!", 0, 300, CINFO_TUNING_ID, CINFO_TYPE_AREA, PICTURE_INFO_WARNING, "", "" ) ;
			}
			return 1 ;
		}
		return 1 ;
	}
	return 0 ;
}

stock valentine_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_valentine_friend:
		{
			if ( ! response ) return 1 ;
		
			new _targetid = strval ( inputtext ) ;
			if ( ! IsPlayerConnected ( _targetid ) || _targetid == playerid )
			{
				show_dialog ( playerid, d_valentine_friend, DIALOG_STYLE_INPUT, "{"#cBHD"}Пригласить друга", "{"#cRD"}* Игрок не в сети!\n\n{"#cWH"}Укажите ID друга, которого желаете пригласить в лобби:", "Выбрать", "Отмена" ) ;
				return 1 ;
			}
			
			if ( cooldown_sentence [ playerid ] > gettime ( ) )
			{
				show_dialog ( playerid, d_valentine_friend, DIALOG_STYLE_INPUT, "{"#cBHD"}Пригласить друга", "{"#cRD"}* Приглашение можно отправлять раз в 45 секунд.\n\n{"#cWH"}Укажите ID друга, которого желаете пригласить в лобби:", "Выбрать", "Отмена" ) ;
				return 1 ;
			}

			if ( ! bad_dialog ( _targetid ) || p_info [ _targetid ] [ jailed ] > 0 || pl_afk_time [ _targetid ] > 3 || admin_info [ _targetid ] [ admin ] > 0 && admin_info [ _targetid ] [ admin ] < 8 )
			{
				show_dialog ( playerid, d_valentine_friend, DIALOG_STYLE_INPUT, "{"#cBHD"}Пригласить друга", "{"#cRD"}* Игрок в данный момент не может осуществлять сделки.\n\n{"#cWH"}Укажите ID друга, которого желаете пригласить в лобби:", "Выбрать", "Отмена" ) ;
				return 1 ;
			}

			if ( get_speed ( _targetid ) > 5 )
			{
				show_dialog ( playerid, d_valentine_friend, DIALOG_STYLE_INPUT, "{"#cBHD"}Пригласить друга", "{"#cRD"}* Игрок находится в движении.\n\n{"#cWH"}Укажите ID друга, которого желаете пригласить в лобби:", "Выбрать", "Отмена" ) ;
				return 1 ;
			}
			
			if ( player_valentine_select { _targetid } > 0 || player_valentine_in_lobby [ _targetid ] != INVALID_PLAYER_ID )
			{
				show_dialog ( playerid, d_valentine_friend, DIALOG_STYLE_INPUT, "{"#cBHD"}Пригласить друга", "{"#cRD"}* Игрок уже находится в лобби.\n\n{"#cWH"}Укажите ID друга, которого желаете пригласить в лобби:", "Выбрать", "Отмена" ) ;
				return 1 ;
			}
			
			cooldown_sentence [ playerid ] = gettime ( ) + time_sell_sentence ;
			
			buyer_id [ playerid ] = _targetid ;
			seller_id [ _targetid ] = playerid ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 144, "\
			{"#cWH"}%s приглашает Вас принять участие в командных состязаниях за сердца.", p_info [ playerid ] [ name ] ) ;
			show_dialog ( _targetid, d_valentine_invite, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Приглашение", global_string, "Принять", "Отмена" ) ;
			
			sell_time { playerid } =
			sell_time { _targetid } = time_sell_null ;
			return 1 ;
		}
		case d_valentine_invite:
		{
			new targetid = seller_id [ playerid ] ;
			if ( ! response )
			{
				clear_sell_params ( playerid, targetid ) ;
				SendClientMessage ( targetid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Игрок отказался от приглашения." ) ;
				return 1 ;
			}
			
			for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
			{
				if ( player_valentine_lobby [ targetid ] [ i ] != INVALID_PLAYER_ID ) continue ;
				
				player_valentine_lobby [ targetid ] [ i ] = playerid ;
				break ;
			}
		
			new _lobby_id = player_valentine_select { targetid } - 1 ;
			ValentineLobbyShow ( playerid, _lobby_id ) ;
			ValentineLobbyState ( playerid, LOBBY_STATE_READY ) ;
			player_valentine_in_lobby [ playerid ] = targetid ;
			
			new _count = 0 ;
			for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
			{
				if ( player_valentine_lobby [ targetid ] [ i ] == INVALID_PLAYER_ID ) continue ;
				
				_count ++ ;
			}
			
			for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
			{
				if ( player_valentine_lobby [ targetid ] [ i ] == INVALID_PLAYER_ID ) continue ;
				
				new _player_lobby_id = player_valentine_lobby [ targetid ] [ i ] ;
				if ( _lobby_id == 0 && _count >= PLAYER_IN_TWO_LOBBY ) ValentineLobbyState ( _player_lobby_id, LOBBY_STATE_READY ) ;
				else if ( _lobby_id == 1 && _count >= PLAYER_IN_FOUR_LOBBY ) ValentineLobbyState ( _player_lobby_id, LOBBY_STATE_READY ) ;
				for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
				{
					if ( player_valentine_lobby [ targetid ] [ q ] == INVALID_PLAYER_ID ) continue ;
					
					new _player_id = player_valentine_lobby [ targetid ] [ q ] ;
					ValentineLobbySetName ( _player_lobby_id, q, p_info [ _player_id ] [ name ] ) ;
				}
			}
			
			clear_sell_params ( playerid, targetid ) ;
			return 1 ;
		}
		case d_valentine_gift:
		{
			if ( ! response )
			{
				DeletePVar ( playerid, "current_valentine_box" ) ;
				DeletePVar ( playerid, "current_valentine_count" ) ;
				return 1 ;
			}
			
			new _targetid = strval ( inputtext ) ;
			if ( ! IsPlayerConnected ( _targetid ) || _targetid == playerid )
			{
				show_dialog ( playerid, d_valentine_gift, DIALOG_STYLE_INPUT, "{"#cBHD"}Подарить другу", "{"#cRD"}* Игрок не в сети!\n\n{"#cWH"}Укажите ID друга, которому хотите подарить бокс валентинок:", "Выбрать", "Отмена" ) ;
				return 1 ;
			}
			
			new _box_id = GetPVarInt ( playerid, "current_valentine_box" ), _count = GetPVarInt ( playerid, "current_valentine_count" ) ;
			DeletePVar ( playerid, "current_valentine_box" ) ;
			DeletePVar ( playerid, "current_valentine_count" ) ;
			
			player_valentine_box [ playerid ] [ _box_id ] -= _count ;
			update_valentine_box ( playerid ) ;
			save_statistic_valentine ( playerid, 0, _count, 0, 0 ) ;
			
			switch ( _box_id )
			{
				/*case 0: _count = ( random ( 3 ) + 1 ) * _count ;
				case 1: _count = ( random ( 20 ) + 15 ) * _count ;
				case 2: _count = ( random ( 200 ) + 200 ) * _count ;
				case 3: _count = ( random ( 2000 ) + 2000 ) * _count ;
				case 4: _count = ( random ( 20000 ) + 20000 ) * _count ;*/
				
				case 0: _count = ( random ( 3 ) + 1 ) * _count ;
				case 1: _count = ( random ( 20 ) + 15 ) * _count ;
				case 2: _count = ( random ( 200 ) + 200 ) * _count ;
				case 3: _count = ( random ( 500 ) + 2000 ) * _count ;
				case 4: _count = ( random ( 5000 ) + 20000 ) * _count ;
			}
			player_valentine [ _targetid ] += _count ;
			update_valentine_sql ( _targetid, "u_valentine", player_valentine [ _targetid ] ) ;
			if ( player_device { _targetid } == 2 && p_info [ _targetid ] [ hud_id ] ) SendCheckHud ( _targetid ) ;
			save_statistic_valentine ( _targetid, _count, 0, 0, 0 ) ;
			
			player_valentine [ playerid ] += _count ;
			update_valentine_sql ( playerid, "u_valentine", player_valentine [ playerid ] ) ;
			if ( player_device { playerid } == 2 && p_info [ playerid ] [ hud_id ] ) SendCheckHud ( playerid ) ;
			
			new scm_string [ 70 + MAX_PLAYER_NAME + 9 ] ;
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}%s подарил(а) Вам {"#cGN"}%d сердец{"#cWH"}.", p_info [ playerid ] [ name ], _count ) ;
			SendClientMessage ( _targetid, col_white, scm_string ) ;
			
			format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы подарили %s {"#cGN"}%d сердец{"#cWH"}.", p_info [ _targetid ] [ name ], _count ) ;
			SendClientMessage ( playerid, col_white, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "(heart) подарил %s %d сердец", p_info [ _targetid ] [ name ], _count ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _count, player_valentine [ playerid ], scm_string ) ;
			
			ValentineSendShow ( playerid ) ;
			ValentineGiftUpdate ( _count ) ;
			return 1 ;
		}
		case d_valentine_buy:
		{
			if ( ! response ) return DeletePVar ( playerid, "valentine_box" ), DeletePVar ( playerid, "valentine_listitem" ) ;
			
			new _i2 = GetPVarInt ( playerid, "valentine_box" ) ;
			if ( _i2 <= 5 )
			{
				new _select = GetPVarInt ( playerid, "valentine_listitem" ) ;
				if ( _select == 0 )
				{
					if ( p_info [ playerid ] [ money ] < valentine_price [ _i2 - 1 ] )
					{
						global_string [ 0 ] = EOS ;
						format ( global_string, 256, "{"#cRD"}* У Вас недостаточно средств!\n\n{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}за {"#cGN"}%d${"#cWH"}.\n\n{"#cGRDialog"}Вы уверены?", valentine_box_name [ _i2 - 1 ], valentine_price [ _i2 - 1 ] ) ;
						show_dialog ( playerid, d_valentine_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
						return 1 ;
					}
            
					give_money ( playerid, -valentine_price [ _i2 - 1 ] ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, -valentine_price [ _i2 - 1 ], "(heart) box сердец" ) ;
					
					player_valentine_box [ playerid ] [ _i2 - 1 ] += 1 ;
					update_valentine_box ( playerid ) ;
					
					send_check_cinfo ( playerid, "Вы успешно приобрели подарок!", 0, 300, CINFO_VALENTINE_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
				}
				else if ( _select == 1 )
				{
					if ( p_info [ playerid ] [ family_ticket ] < valentine_price_ft [ _i2 - 1 ] )
					{
						global_string [ 0 ] = EOS ;
						format ( global_string, 256, "{"#cRD"}* У Вас недостаточно "family_title"!\n\n{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}за {"#cGN"}%d "family_title"{"#cWH"}.\n\n{"#cGRDialog"}Вы уверены?", valentine_box_name [ _i2 - 1 ], valentine_price_ft [ _i2 - 1 ] ) ;
						show_dialog ( playerid, d_valentine_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
						return 1 ;
					}
					
				    p_info [ playerid ] [ family_ticket ] -= valentine_price_ft [ _i2 - 1 ] ;
					update_int_sql ( playerid, "u_family_ticket", p_info [ playerid ] [ family_ticket ] ) ;
					
					player_valentine_box [ playerid ] [ _i2 - 1 ] += 1 ;
					update_valentine_box ( playerid ) ;
				
					insert_donate_log ( playerid, INVALID_PLAYER_ID, valentine_price_ft [ _i2 - 1 ], p_info [ playerid ] [ family_ticket ], "(heart) buy box (ft)" ) ;
					send_check_cinfo ( playerid, "Вы успешно приобрели подарок!", 0, 300, CINFO_VALENTINE_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
				}
			}
			else if ( _i2 > 5 && _i2 <= 8 )
			{
				if ( player_valentine [ playerid ] < valentine_price [ _i2 - 1 ] )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cRD"}* У Вас недостаточно сердец!\n\n{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}за {"#cGN"}%d сердец{"#cWH"}.\n\n{"#cGRDialog"}Вы уверены?", valentine_box_name [ _i2 - 1 ], valentine_price [ _i2 - 1 ] ) ;
					show_dialog ( playerid, d_valentine_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
					return 1 ;
				}
				
				player_valentine [ playerid ] -= valentine_price [ _i2 - 1 ] ;
				update_valentine_sql ( playerid, "u_valentine", player_valentine [ playerid ] ) ;
				if ( player_device { playerid } == 2 && p_info [ playerid ] [ hud_id ] ) SendCheckHud ( playerid ) ;
				
				insert_donate_log ( playerid, INVALID_PLAYER_ID, valentine_price [ _i2 - 1 ], player_valentine [ playerid ], "(heart) open box" ) ;
				
				if ( _i2 == 6 )
				{
					new donate_count = random ( 107000 ),
						random_item ;

					if ( donate_count >= 0 && donate_count <= 20000 )random_item = prise_skills ;
					else if ( donate_count >= 20001 && donate_count <= 40000 )random_item = prise_skills ;
					else if ( donate_count >= 40001 && donate_count <= 57000 )random_item = prise_licenses ;
					else if ( donate_count >= 57001 && donate_count <= 75000 )random_item = prise_drugs ;

					else if ( donate_count >= 75001 && donate_count <= 84000 )random_item = prise_guns ;

					else if ( donate_count >= 84001 && donate_count <= 95000 )random_item = prise_skin ;
					else if ( donate_count >= 95001 && donate_count <= 100000 )random_item = prise_money ;
					else if ( donate_count >= 100001 && donate_count <= 101000 )random_item = prise_donate ;

					else if ( donate_count >= 101001 && donate_count <= 108000 )random_item = prise_satiety ;
					else if ( donate_count >= 108001 && donate_count <= 102000 )random_item = prise_car ;
					else if ( donate_count >= 102001 && donate_count <= 105000 )random_item = prise_yacht ;
					else if ( donate_count >= 105001 && donate_count <= 107000 )random_item = prise_accesories ;
					
					show_valentine_result ( playerid, random_item ) ;
				}
				else if ( _i2 == 7 )
				{
					give_player_item ( playerid, valentine_acs_model [ random ( sizeof valentine_acs_model ) ] ) ;
				}
				else if ( _i2 == 8 )
				{
					give_player_item_prise ( playerid, skin_cross + valentine_skin_model [ random ( sizeof valentine_skin_model ) ], 1 ) ;
					SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"} для открытия подарка." ) ;
				}
			}
			else if ( _i2 >= 400 && _i2 < 4000 )
			{
				new _v_model = _i2, _id_car ;
					
				if ( _v_model == valentine_vehicle_model [ 0 ] ) _id_car = 8 ;
				else if ( _v_model == valentine_vehicle_model [ 1 ] ) _id_car = 9 ;
				else if ( _v_model == valentine_vehicle_model [ 2 ] ) _id_car = 10 ;
				if ( player_valentine [ playerid ] < valentine_price [ _id_car ] )
				{
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cRD"}* У Вас недостаточно сердец!\n\n{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}за {"#cGN"}%d сердец{"#cWH"}.\n\n{"#cGRDialog"}Вы уверены?", GetVehicleNameEx ( -1, _v_model ), valentine_price [ _id_car ] ) ;
					show_dialog ( playerid, d_valentine_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
					return 1 ;
				}
				
				player_valentine [ playerid ] -= valentine_price [ _i2 - 1 ] ;
				update_valentine_sql ( playerid, "u_valentine", player_valentine [ playerid ] ) ;
				if ( player_device { playerid } == 2 && p_info [ playerid ] [ hud_id ] ) SendCheckHud ( playerid ) ;
				
				insert_donate_log ( playerid, INVALID_PLAYER_ID, valentine_price [ _i2 - 1 ], player_valentine [ playerid ], "(heart) buy car" ) ;
				
				_v_model = _i2 ;
				veh_prise_create ( playerid, 5, _v_model ) ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Услуга успешно приобретена. Используйте /cars." ) ;
			}
			else if ( _i2 >= 9 && _i2 <= 11 )
			{
				if ( player_valentine [ playerid ] < valentine_price [ _i2 - 1 ] )
				{
					new _v_model = valentine_vehicle_model [ _i2 - 9 ] ;
			
					global_string [ 0 ] = EOS ;
					format ( global_string, 256, "{"#cRD"}* У Вас недостаточно сердец!\n\n{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}за {"#cGN"}%d сердец{"#cWH"}.\n\n{"#cGRDialog"}Вы уверены?", GetVehicleNameEx ( -1, _v_model ), valentine_price [ _i2 - 1 ] ) ;
					show_dialog ( playerid, d_valentine_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
					return 1 ;
				}
				
				player_valentine [ playerid ] -= valentine_price [ _i2 - 1 ] ;
				update_valentine_sql ( playerid, "u_valentine", player_valentine [ playerid ] ) ;
				if ( player_device { playerid } == 2 && p_info [ playerid ] [ hud_id ] ) SendCheckHud ( playerid ) ;
				
				insert_donate_log ( playerid, INVALID_PLAYER_ID, valentine_price [ _i2 - 1 ], player_valentine [ playerid ], "(heart) buy car" ) ;
				
				new _v_model = valentine_vehicle_model [ _i2 - 9 ] ;
				veh_prise_create ( playerid, 5, _v_model ) ;
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Услуга успешно приобретена. Используйте /cars." ) ;
			}
			DeletePVar ( playerid, "valentine_box" ) ;
			DeletePVar ( playerid, "valentine_listitem" ) ;
			return 1 ;
		}
		case d_valentine_buy_1:
		{
			if ( ! response ) return DeletePVar ( playerid, "valentine_box" ) ;
			
			new _i2 = GetPVarInt ( playerid, "valentine_box" ) ;
			if ( listitem == 0 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}за {"#cGN"}%d${"#cWH"}.\n\n{"#cGRDialog"}Вы уверены?", valentine_box_name [ _i2 - 1 ], valentine_price [ _i2 - 1 ] ) ;
				show_dialog ( playerid, d_valentine_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
				
				SetPVarInt ( playerid, "valentine_listitem", listitem ) ;
			}
			else if ( listitem == 1 )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "{"#cWH"}Вы собираетесь приобрести {"#cOR"}%s {"#cWH"}за {"#cGN"}%d "family_title"{"#cWH"}.\n\n{"#cGRDialog"}Вы уверены?", valentine_box_name [ _i2 - 1 ], valentine_price_ft [ _i2 - 1 ] ) ;
				show_dialog ( playerid, d_valentine_buy, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Подтверждение покупки", global_string, "Принять", "Отмена" ) ;
				
				SetPVarInt ( playerid, "valentine_listitem", listitem ) ;
			}
			return 1 ;
		}
	}
	return 0 ;
}

stock show_valentine_result ( playerid, _random_item )
{
	switch ( _random_item )
	{
		case prise_skills:
		{
		    new prize_type ;
			if ( random ( 15 ) == 1 ) prize_type = 36 ;
			else prize_type = RandomEx ( 88, 94 ) ;

			new query_string [ 128 ] ;
			format ( query_string, sizeof ( query_string ),"{"#cBL"}Поздравляем!\n\n{"#cWH"}Вы получили предмет:\n{"#cBL"}-{"#cWH"} %s", item_name ( prize_type ) ) ;
		    show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выигрыш", query_string, "Закрыть", "" ) ;

		    SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"} для открытия подарка." ) ;

			give_player_item_prise ( playerid, prize_type, 1 ) ;
		}
		case prise_licenses:
		{
		    new prize_type ;
			if ( random ( 15 ) == 1 ) prize_type = 35 ;
			else prize_type = RandomEx ( 84, 87 ) ;

			new query_string [ 128 ] ;
			format ( query_string, sizeof ( query_string ),"{"#cBL"}Поздравляем!\n\n{"#cWH"}Вы получили предмет:\n{"#cBL"}-{"#cWH"} %s", item_name ( prize_type ) ) ;
		    show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выигрыш", query_string, "Закрыть", "" ) ;

            SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"} для открытия подарка." ) ;

		   	give_player_item_prise ( playerid, prize_type, 1 ) ;
		}
		case prise_aidkits:
		{
			new aidkit_count = RandomEx ( 1, 3 ) ;
			give_player_item_prise ( playerid, 145, aidkit_count ) ;
			
			new query_string [ 128 ] ;
			format ( query_string, sizeof ( query_string ),"{"#cBL"}Поздравляем!\n\n{"#cWH"}Вы получили предмет:\n{"#cBL"}-{"#cWH"} %d универсальных аптечек", aidkit_count ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выигрыш", query_string, "Закрыть", "" ) ;
		}
		case prise_drugs:
		{
			new drugs_count = RandomEx ( 5, 100 ) ;
			give_player_item_prise ( playerid, 155, drugs_count ) ;
			
			new query_string [ 128 ] ;
			format ( query_string, sizeof ( query_string ),"{"#cBL"}Поздравляем!\n\n{"#cWH"}Вы получили предмет:\n{"#cBL"}-{"#cWH"} %d гр. наркотиков", drugs_count ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выигрыш", query_string, "Закрыть", "" ) ;
		}
		case prise_guns:
		{
			new drugs_count = RandomEx ( 5, 100 ) ;
			give_player_item_prise ( playerid, 153, drugs_count ) ;
			give_player_item_prise ( playerid, 154, drugs_count ) ;

			new query_string [ 128 ] ;
			format ( query_string, sizeof ( query_string ),"{"#cBL"}Поздравляем!\n\n{"#cWH"}Вы получили предмет:\n{"#cBL"}-{"#cWH"} %d ед.оружия и патронов", drugs_count ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выигрыш", query_string, "Закрыть", "" ) ;
		}
		case prise_skin:
		{
			new money_count = dr_skin [ random ( sizeof dr_skin ) ] + skin_cross ;

			new dialog_string [ 128 ] ;
			format ( dialog_string, sizeof ( dialog_string ),"{"#cBL"}Поздравляем!\n\n{"#cWH"}Вы получили предмет:\n{"#cBL"}-{"#cWH"} Одежда №%d", money_count - skin_cross ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выигрыш", dialog_string, "Закрыть", "" ) ;

            SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"} для открытия подарка." ) ;

			give_player_item_prise ( playerid, money_count, 1 ) ;
		}
		case prise_money:
		{
			new money_count = 0 ;
			switch ( random ( 5 ) )
			{
				case 0,1,3,4: money_count = RandomEx ( 4, 9 ) ;
				case 2: money_count = RandomEx ( 50, 55 ) ;
			}

			new dialog_string [ 128 ] ;
			format ( dialog_string, sizeof ( dialog_string ),"{"#cBL"}Поздравляем!\n\n{"#cWH"}Вы получили предмет:\n{"#cBL"}-{"#cWH"} %s", item_name ( money_count ) ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выигрыш", dialog_string, "Закрыть", "" ) ;

            SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"} для открытия подарка." ) ;

		   	give_player_item_prise ( playerid, money_count, 1 ) ;
		}
		case prise_donate:
		{
			new money_count = RandomEx ( 15, 23 ) ;

			new query_string [ 128 ] ;
			format ( query_string, sizeof ( query_string ),"{"#cBL"}Поздравляем!\n\n{"#cWH"}Вы получили предмет:\n{"#cBL"}-{"#cWH"} %d "donate_title"", item_name ( money_count ) ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выигрыш", query_string, "Закрыть", "" ) ;

			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"} для открытия подарка." ) ;

		   	give_player_item_prise ( playerid, money_count, 1 ) ;
		}
		case prise_satiety:
		{
		    new result_random = RandomEx ( 40, 44 ) ;

            new query_string [ 128 ] ;
			format ( query_string, sizeof ( query_string ), "{"#cBL"}Поздравляем!\n\n{"#cWH"}Вы получили предмет:\n{"#cBL"}-{"#cWH"} %s", item_name ( result_random ) ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выигрыш", query_string, "Закрыть", "" ) ;

			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"} для открытия подарка." ) ;

		   	give_player_item_prise ( playerid, result_random, 1 ) ;
		}
		case prise_car:
		{
			new result_random = dr_veh_models [ random ( 8 ) ] [ random ( 6 ) ] ;

            new query_string [ 128 ] ;
			format ( query_string, sizeof ( query_string ), "{"#cBL"}Поздравляем!\n\n{"#cWH"}Вы получили предмет:\n{"#cBL"}-{"#cWH"} %s", item_name ( result_random ) ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выигрыш", query_string, "Закрыть", "" ) ;

			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"} для открытия подарка." ) ;

		   	give_player_item_prise ( playerid, result_random, 1 ) ;
		}
		case prise_yacht:
		{
		    new result_random = 454 ;

		    new query_string [ 128 ] ;
			format ( query_string, sizeof ( query_string ), "{"#cBL"}Поздравляем!\n\n{"#cWH"}Вы получили предмет:\n{"#cBL"}-{"#cWH"} %s", item_name ( result_random ) ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выигрыш", query_string, "Закрыть", "" ) ;

			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"} для открытия подарка." ) ;

		   	give_player_item_prise ( playerid, result_random, 1 ) ;
		}
		case prise_accesories:
		{
			new money_count = dr_accesories [ random ( sizeof dr_accesories ) ] ;
            
		    new dialog_string [ 128 ] ;
			format ( dialog_string, sizeof ( dialog_string ), "{"#cBL"}Поздравляем!\n\n{"#cWH"}Вы получили предмет:\n{"#cBL"}-{"#cWH"} %s", get_accessorie_name ( money_count ) ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Выигрыш", dialog_string, "Закрыть", "" ) ;

            SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"} для открытия подарка." ) ;

			give_player_item ( playerid, money_count ) ;
		}
	}
	return 1 ;
}

stock clear_player_valentine ( playerid )
{
	if ( valentine_end_gettime < gettime ( ) ) return 1 ;
	
	player_valentine_in_lobby [ playerid ] = INVALID_PLAYER_ID ;
	m_bValentineRPC [ playerid ] = false ;
	m_bUsedValentine [ playerid ] = false ;
	
	for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
	{
		player_valentine_lobby [ playerid ] [ i ] = INVALID_PLAYER_ID ;
		player_valentine_ready [ playerid ] [ i ] = 0 ;
	}
	return 1 ;
}

stock valentine_OnGameModeInit ( )
{
	mysql_tquery ( sql_connection, !"SELECT * FROM `users_valentines` ORDER BY `users_valentines`.`u_day_valentine` DESC LIMIT 5", "valentines_loading", "i", 0 ) ;
	mysql_tquery ( sql_connection, !"SELECT * FROM `users_valentines` ORDER BY `users_valentines`.`u_day_gift` DESC LIMIT 5", "valentines_loading", "i", 1 ) ;
	mysql_tquery ( sql_connection, !"SELECT * FROM `users_valentines` ORDER BY `users_valentines`.`u_day_quest_2` DESC LIMIT 5", "valentines_loading", "i", 2 ) ;
	mysql_tquery ( sql_connection, !"SELECT * FROM `users_valentines` ORDER BY `users_valentines`.`u_day_quest_3` DESC LIMIT 5", "valentines_loading", "i", 3 ) ;
	
	mysql_tquery ( sql_connection, !"SELECT * FROM `users_valentines` ORDER BY `users_valentines`.`u_all_valentine` DESC LIMIT 5", "valentines_loading", "i", 4 ) ;
	mysql_tquery ( sql_connection, !"SELECT * FROM `users_valentines` ORDER BY `users_valentines`.`u_all_gift` DESC LIMIT 5", "valentines_loading", "i", 5 ) ;
	mysql_tquery ( sql_connection, !"SELECT * FROM `users_valentines` ORDER BY `users_valentines`.`u_all_quest_2` DESC LIMIT 5", "valentines_loading", "i", 6 ) ;
	mysql_tquery ( sql_connection, !"SELECT * FROM `users_valentines` ORDER BY `users_valentines`.`u_all_quest_3` DESC LIMIT 5", "valentines_loading", "i", 7 ) ;
	
	mysql_tquery ( sql_connection, !"SELECT * FROM `valentines`", "valentines_gift_loading" ) ;
	return 1 ;
}

callback: valentines_loading ( _position )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		for ( new i = 0 ; i < rows ; i ++ )
		{
			if ( _position == 0 ) valentine_top [ _position ] [ i ] [ valentine_count ] = cache_get_field_content_int ( i, "u_day_valentine", sql_connection ) ;
			else if ( _position == 1 ) valentine_top [ _position ] [ i ] [ valentine_count ] = cache_get_field_content_int ( i, "u_day_gift", sql_connection ) ;
			else if ( _position == 2 ) valentine_top [ _position ] [ i ] [ valentine_count ] = cache_get_field_content_int ( i, "u_day_quest_2", sql_connection ) ;
			else if ( _position == 3 ) valentine_top [ _position ] [ i ] [ valentine_count ] = cache_get_field_content_int ( i, "u_day_quest_3", sql_connection ) ;
			else if ( _position == 4 ) valentine_top [ _position ] [ i ] [ valentine_count ] = cache_get_field_content_int ( i, "u_all_valentine", sql_connection ) ;
			else if ( _position == 5 ) valentine_top [ _position ] [ i ] [ valentine_count ] = cache_get_field_content_int ( i, "u_all_gift", sql_connection ) ;
			else if ( _position == 6 ) valentine_top [ _position ] [ i ] [ valentine_count ] = cache_get_field_content_int ( i, "u_all_quest_2", sql_connection ) ;
			else if ( _position == 7 ) valentine_top [ _position ] [ i ] [ valentine_count ] = cache_get_field_content_int ( i, "u_all_quest_3", sql_connection ) ;
			cache_get_field_content ( i, "u_name", valentine_top [ _position ] [ i ] [ valentine_name ], sql_connection, MAX_PLAYER_NAME ) ;
		}
	}
	return 1 ;
}

callback: valentines_gift_loading ( )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		valentine_gift = cache_get_field_content_int ( 0, "valentine_gift", sql_connection ) ;
		valentine_gettime = cache_get_field_content_int ( 0, "valentine_gettime", sql_connection ) ;
		valentine_action = cache_get_field_content_int ( 0, "valentine_action", sql_connection ) ;
		valentine_end_gettime = cache_get_field_content_int ( 0, "valentine_end_gettime", sql_connection ) ;
	}
	return 1 ;
}

stock valentine_load_user ( playerid )
{
	if ( valentine_end_gettime < gettime ( ) ) return 1 ;
	
	SendClientMessage ( playerid, col_orange, !"* Праздничный эвент ждёт своих победителей! Используйте /valentine." ) ;
	
	new sql_string [ 63 + 9 ] ;
	format ( sql_string, sizeof sql_string, "SELECT * FROM `users_valentines` WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, sql_string, "valentines_load_user", "i", playerid ) ;
	return 1 ;
}

callback: valentines_load_user ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		player_valentine [ playerid ] = cache_get_field_content_int ( 0, "u_valentine", sql_connection ) ;
		if ( player_device { playerid } == 2 && p_info [ playerid ] [ hud_id ] ) SendCheckHud ( playerid ) ;
		
		new sscanf_delimit [ 100 ] ;
		cache_get_field_content ( 0, "u_quest", sscanf_delimit, sql_connection, sizeof sscanf_delimit ) ;
		sscanf ( sscanf_delimit, "p<|>dddd", player_valentine_quest [ playerid ] [ 0 ], player_valentine_quest [ playerid ] [ 1 ],
											player_valentine_quest [ playerid ] [ 2 ], player_valentine_quest [ playerid ] [ 3 ] ) ;

		cache_get_field_content ( 0, "u_quest_progress", sscanf_delimit, sql_connection, sizeof sscanf_delimit ) ;
		sscanf ( sscanf_delimit, "p<|>dddd", player_valentine_quest_progress [ playerid ] [ 0 ], player_valentine_quest_progress [ playerid ] [ 1 ],
											player_valentine_quest_progress [ playerid ] [ 2 ], player_valentine_quest_progress [ playerid ] [ 3 ] ) ;
											
		cache_get_field_content ( 0, "u_quest_status", sscanf_delimit, sql_connection, sizeof sscanf_delimit ) ;
		sscanf ( sscanf_delimit, "p<|>dddd", player_valentine_status [ playerid ] [ 0 ], player_valentine_status [ playerid ] [ 1 ],
											player_valentine_status [ playerid ] [ 2 ], player_valentine_status [ playerid ] [ 3 ] ) ;
											
		cache_get_field_content ( 0, "u_box", sscanf_delimit, sql_connection, sizeof sscanf_delimit ) ;
		sscanf ( sscanf_delimit, "p<|>ddddd", player_valentine_box [ playerid ] [ 0 ], player_valentine_box [ playerid ] [ 1 ],
											player_valentine_box [ playerid ] [ 2 ], player_valentine_box [ playerid ] [ 3 ], player_valentine_box [ playerid ] [ 4 ] ) ;
	}
	else
	{
		new sql_string [ 70 + 9 + MAX_PLAYER_NAME ] ;
		format ( sql_string, sizeof sql_string, "INSERT INTO `users_valentines` (`u_id`,`u_name`) VALUES ('%d','%s')",
		p_info [ playerid ] [ id ], p_info [ playerid ] [ name ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;
		
		player_valentine [ playerid ] = 0 ;
		
		for ( new i = 0 ; i < MAX_VALENTINE_QUEST ; i ++ )
		{
			player_valentine_quest [ playerid ] [ i ] =
			player_valentine_quest_progress [ playerid ] [ i ] =
			player_valentine_status [ playerid ] [ i ] = 0 ;
		}
		
		for ( new i = 0 ; i < MAX_VALENTINE_BOX ; i ++ )
		{
			player_valentine_box [ playerid ] [ i ] = 0 ;
		}
	}
	return 1 ;
}

stock save_statistic_valentine ( playerid, _day_valentine, _day_gift, _day_quest_2, _day_quest_3 )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 512, "UPDATE `users_valentines` SET `u_day_valentine` = `u_day_valentine` + '%d', `u_day_gift` = `u_day_gift` + '%d', `u_day_quest_2` = `u_day_quest_2` + '%d',\
								`u_day_quest_3` = `u_day_quest_3` + '%d', `u_all_valentine` = `u_all_valentine` + '%d', `u_all_gift` = `u_all_gift` + '%d',\
								`u_all_quest_2` = `u_all_quest_2` + '%d', `u_all_quest_3` = `u_all_quest_3` + '%d' WHERE `u_id` = '%d' LIMIT 1",
	_day_valentine, _day_gift, _day_quest_2, _day_quest_3, _day_valentine, _day_gift, _day_quest_2, _day_quest_3, p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;
	return 1 ;
}

stock update_valentine_quest ( playerid )
{
	new query_string [ 128 ] ;
	format ( query_string, sizeof(query_string), "UPDATE `users_valentines` SET `u_quest` = '%d|%d|%d|%d' WHERE `u_id` = '%d' LIMIT 1",
	player_valentine_quest [ playerid ] [ 0 ], player_valentine_quest [ playerid ] [ 1 ], player_valentine_quest [ playerid ] [ 2 ],
	player_valentine_quest [ playerid ] [ 3 ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, query_string, "", "" ) ;
	return true ;
}

stock update_valentine_quest_progress ( playerid )
{
	new query_string [ 128 ] ;
	format ( query_string, sizeof(query_string), "UPDATE `users_valentines` SET `u_quest_progress` = '%d|%d|%d|%d' WHERE `u_id` = '%d' LIMIT 1", 
	player_valentine_quest_progress [ playerid ] [ 0 ], player_valentine_quest_progress [ playerid ] [ 1 ], player_valentine_quest_progress [ playerid ] [ 2 ],
	player_valentine_quest_progress [ playerid ] [ 3 ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, query_string, "", "" ) ;
	return true ;
}

stock update_valentine_status ( playerid )
{
	new query_string [ 128 ] ;
	format ( query_string, sizeof(query_string), "UPDATE `users_valentines` SET `u_quest_status` = '%d|%d|%d|%d' WHERE `u_id` = '%d' LIMIT 1", 
	player_valentine_status [ playerid ] [ 0 ], player_valentine_status [ playerid ] [ 1 ], player_valentine_status [ playerid ] [ 2 ],
	player_valentine_status [ playerid ] [ 3 ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, query_string, "", "" ) ;
	return true ;
}

stock update_valentine_box ( playerid )
{
	new query_string [ 128 ] ;
	format ( query_string, sizeof(query_string), "UPDATE `users_valentines` SET `u_box` = '%d|%d|%d|%d|%d' WHERE `u_id` = '%d' LIMIT 1", 
	player_valentine_box [ playerid ] [ 0 ], player_valentine_box [ playerid ] [ 1 ], player_valentine_box [ playerid ] [ 2 ],
	player_valentine_box [ playerid ] [ 3 ], player_valentine_box [ playerid ] [ 4 ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, query_string, "", "" ) ;
	return true ;
}

stock update_valentine_sql ( playerid, field [ ], data )
{
	new query_string [ 128 ] ;
	format ( query_string, sizeof(query_string), "UPDATE `users_valentines` SET `%s` = '%d' WHERE `u_id` = '%d' LIMIT 1", field, data, p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, query_string, "", "" ) ;
	return true ;
}

stock ValentineGiftUpdate ( _count )
{
	if ( valentine_gift < 1_000_000 && valentine_gift + _count >= 1_000_000 )
	{
		valentine_gettime = SetElapsedTime ( gettime ( ), 48, CONVERT_TIME_TO_HOURS ) ;
		valentine_action = 1 ;
		
		SendClientMessageToAll ( col_orange, !"* Достигнута цель #1 по сбору сердец. На 48 часов включена акция х1.2 опыта на задания в Event Pass." ) ;
	}
	else if ( valentine_gift < 3_000_000 && valentine_gift + _count >= 3_000_000 )
	{
		valentine_gettime = SetElapsedTime ( gettime ( ), 48, CONVERT_TIME_TO_HOURS ) ;
		valentine_action = 2 ;
		
		SendClientMessageToAll ( col_orange, !"* Достигнута цель #2 по сбору сердец. На 48 часов включена акция +1 "family_title" каждый час." ) ;
	}
	else if ( valentine_gift < 5_000_000 && valentine_gift + _count >= 5_000_000 )
	{
		valentine_gettime = SetElapsedTime ( gettime ( ), 24, CONVERT_TIME_TO_HOURS ) ;
		valentine_action = 3 ;
		
		SendClientMessageToAll ( col_orange, !"* Достигнута цель #3 по сбору сердец. На 24 часа включена акция +50 сердец каждый час." ) ;
	}
	
	valentine_gift += _count ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 144, "UPDATE `valentines` SET `valentine_gift` = '%d', `valentine_action` = '%d', `valentine_gettime` = '%d'", valentine_gift, valentine_action, valentine_gettime ) ;
	mysql_tquery ( sql_connection, global_string, "", "" ) ;
	return true ;
}

stock ValentineGettime ( )
{
	if ( valentine_gettime > gettime ( ) ) return valentine_action ;
	
	valentine_action = 0 ;
	return 0 ;
}

stock valentine_pay_day ( playerid )
{
	if ( ValentineGettime ( ) == 2 ) p_info [ playerid ] [ family_ticket ] += 1 ;
	else if ( ValentineGettime ( ) == 3 )
	{
		player_valentine [ playerid ] += 50 ;
		update_valentine_sql ( playerid, "u_valentine", player_valentine [ playerid ] ) ;
		if ( player_device { playerid } == 2 && p_info [ playerid ] [ hud_id ] ) SendCheckHud ( playerid ) ;
	}
	
	give_valentine_progress ( playerid, 0 ) ;
	return 1 ;
}

stock give_valentine_progress ( playerid, _quest_id )
{
	if ( valentine_end_gettime < gettime ( ) ) return 1 ;
	
	if ( player_valentine_status [ playerid ] [ _quest_id ] != 1 )
	{
		if ( player_valentine_quest [ playerid ] [ _quest_id ] >= 3 ) return 1 ;
		player_valentine_quest_progress [ playerid ] [ _quest_id ] += 1 ;
		
		new _quest_need_progress [ ] =
		{
			2,
			1,
			1,
			1,
		} ;
		
		if ( player_valentine_quest_progress [ playerid ] [ _quest_id ] >= _quest_need_progress [ _quest_id ] )
		{
			player_valentine_status [ playerid ] [ _quest_id ] = 1 ;
			update_valentine_status ( playerid ) ;
			
			player_valentine_quest_progress [ playerid ] [ _quest_id ] = 0 ;
		}
		update_valentine_quest_progress ( playerid ) ;
	}
	return 1 ;
}

stock valentine_gettime_clear ( playerid )
{
	if ( valentine_end_gettime < gettime ( ) ) return 1 ;
	
	for ( new i = 0 ; i < MAX_VALENTINE_QUEST ; i ++ )
	{
		player_valentine_quest [ playerid ] [ i ] =
		player_valentine_quest_progress [ playerid ] [ i ] =
		player_valentine_status [ playerid ] [ i ] = 0 ;
	}
	
	update_valentine_quest ( playerid ) ;
	update_valentine_quest_progress ( playerid ) ;
	update_valentine_status ( playerid ) ;
	return 1 ;
}

stock valentine_OnPlayerDisconnect ( playerid )
{
	if ( valentine_end_gettime < gettime ( ) ) return 1 ;
	
	new _select = player_valentine_select { playerid } ;
	if ( _select > 0 )
	{
		for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
		{
			if ( player_valentine_lobby [ playerid ] [ i ] == INVALID_PLAYER_ID ) continue ;
					
			new _player_lobby_id = player_valentine_lobby [ playerid ] [ i ] ;
			if ( m_bUsedValentine [ playerid ] == false ) ValentineLobbyHide ( _player_lobby_id ) ;
			m_bUsedValentine [ playerid ] = false ;
		}

		for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
		{
			player_valentine_ready [ playerid ] [ i ] = 0 ;
			player_valentine_lobby [ playerid ] [ i ] = INVALID_PLAYER_ID ;
		}
	}
	else if ( player_valentine_in_lobby [ playerid ] != INVALID_PLAYER_ID )
	{
		new _targetid = player_valentine_in_lobby [ playerid ] ;
		player_valentine_in_lobby [ playerid ] = INVALID_PLAYER_ID ;
			
		_select = player_valentine_select { _targetid } - 1 ;
		if ( _select == 0 || _select == 1 )
		{
			for ( new i = 0 ; i < MAX_VALENTINE_LOBBY ; i ++ )
			{
				if ( player_valentine_lobby [ _targetid ] [ i ] != playerid ) continue ;

				player_valentine_ready [ _targetid ] [ i ] = 0 ;
				player_valentine_lobby [ _targetid ] [ i ] = INVALID_PLAYER_ID ;
				for ( new q = 0 ; q < MAX_VALENTINE_LOBBY ; q ++ )
				{
					if ( player_valentine_lobby [ _targetid ] [ q ] == INVALID_PLAYER_ID ) continue ;
							
					new _player_lobby_id = player_valentine_lobby [ _targetid ] [ q ] ;
					if ( m_bUsedValentine [ _targetid ] == false )
					{
						ValentineLobbyReady ( _player_lobby_id, i, 0 ) ;
						ValentineLobbySetName ( _player_lobby_id, i, "Нет игрока" ) ;
					}
					m_bUsedValentine [ _targetid ] = false ;
				}
				break ;
			}
		}
	}
	return 1 ;
}

CMD:vstart ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	
	valentine_end_gettime = SetElapsedTime ( gettime ( ), 14, CONVERT_TIME_TO_DAYS ) ;
	valentine_gift = 0 ;
	valentine_action = 0 ;
	valentine_gettime = 0 ;
	
	foreach(new i: logged_players)
	{
		player_valentine [ i ] =
		player_valentine_quest_progress [ i ] [ 0 ] =
		player_valentine_quest_progress [ i ] [ 1 ] =
		player_valentine_quest_progress [ i ] [ 2 ] =
		player_valentine_quest_progress [ i ] [ 3 ] =
		player_valentine_status [ i ] [ 0 ] =
		player_valentine_status [ i ] [ 1 ] =
		player_valentine_status [ i ] [ 2 ] =
		player_valentine_status [ i ] [ 3 ] =
		player_valentine_box [ i ] [ 0 ] =
		player_valentine_box [ i ] [ 1 ] =
		player_valentine_box [ i ] [ 2 ] =
		player_valentine_box [ i ] [ 3 ] =
		player_valentine_box [ i ] [ 4 ] = 0 ;
		
		if ( player_device { i } == 2 && p_info [ i ] [ hud_id ] ) SendCheckHud ( i ) ;
	}
	
	mysql_tquery ( sql_connection, !"UPDATE `users_valentines` SET `u_valentine` = '0', `u_quest_progress` = '0|0|0|0', `u_quest_status` = '0|0|0|0', `u_box` = '0|0|0|0|0'" ) ;
	
	global_string [ 0 ] = EOS ;
	format ( global_string, 200, "UPDATE `valentines` SET `valentine_gift` = '%d', `valentine_action` = '%d', `valentine_gettime` = '%d', `valentine_end_gettime` = '%d'", valentine_gift, valentine_action, valentine_gettime, valentine_end_gettime ) ;
	mysql_tquery ( sql_connection, global_string, "", "" ) ;
	return 1 ;
}

/*
	
	CREATE TABLE `users_valentines` (`inc_id` INT(11) NOT NULL AUTO_INCREMENT , `u_id` INT(11) NOT NULL DEFAULT '0' , `u_name` VARCHAR(32) NOT NULL , `u_valentine` INT(11) NOT NULL DEFAULT '0' , `u_quest` VARCHAR(100) NOT NULL DEFAULT '0|0|0|0' , `u_quest_status` VARCHAR(100) NOT NULL DEFAULT '0|0|0|0' , `u_box` VARCHAR(100) NOT NULL DEFAULT '0|0|0|0|0' , `u_day_valentine` INT(11) NOT NULL DEFAULT '0' , `u_day_gift` INT(11) NOT NULL DEFAULT '0' , `u_day_quest_2` INT(11) NOT NULL DEFAULT '0' , `u_day_quest_3` INT(11) NOT NULL DEFAULT '0' , `u_all_valentine` INT(11) NOT NULL DEFAULT '0' , PRIMARY KEY (`inc_id`)) ENGINE = InnoDB; 
	ALTER TABLE `users_valentines` ADD `u_all_gift` INT(11) NOT NULL DEFAULT '0' AFTER `u_all_valentine`, ADD `u_all_quest_2` INT(11) NOT NULL DEFAULT '0' AFTER `u_all_gift`, ADD `u_all_quest_3` INT(11) NOT NULL DEFAULT '0' AFTER `u_all_quest_2`; 
	ALTER TABLE `users_valentines` ADD `u_quest_progress` VARCHAR(128) NOT NULL DEFAULT '0|0|0|0' AFTER `u_quest`; 
	CREATE TABLE `valentines` (`valentine_gift` INT(11) NOT NULL DEFAULT '0' , `valentine_gettime` INT(11) NOT NULL DEFAULT '0' , `valentine_action` INT(11) NOT NULL DEFAULT '0' , `valentine_end_gettime` INT(11) NOT NULL DEFAULT '0' ) ENGINE = InnoDB;
	INSERT INTO `valentines` (`valentine_gift`, `valentine_gettime`, `valentine_action`, `valentine_end_gettime`) VALUES ('0', '0', '0', '0');
	
	INSERT INTO `businesses` (`b_id`, `b_owner_inc`, `b_owner_name`, `b_name`, `b_pos_x`, `b_pos_y`, `b_pos_z`, `b_pos_c`, `b_int`, `b_money`, `b_close`, `b_price`, `b_donate_price`, `b_product`, `b_type`, `b_cost`, `b_fee`, `b_maxproduct`, `b_improve`, `b_mafia`, `b_tax`, `b_procurement_x`, `b_procurement_y`, `b_procurement_z`, `b_repair_x`, `b_repair_y`, `b_repair_z`, `b_status_salary`, `b_salary`, `b_ranks`, `b_settings`, `b_chat_color`, `b_robbery`, `b_win_prise`, `b_win_car`, `b_sound`, `b_radio_status`, `b_radio_url`, `b_sell_status`, `b_meeting`, `b_family`, `b_freeze`, `b_freeze_day`, `b_freeze_date`, `b_max_car`, `b_cash_today`, `b_visitors`, `b_rating`, `b_car_marker`) VALUES ('141', '-1', 'Собственность штата', 'Обслуживание судов', '2394.8554', '-2551.0600', '21.9865', '2.9071', '0', '0', '0', '750000', '3000', '1000', '27', '50', '0', '15000', '0|0|0|0', '25', '0', '0', '0', '0', '0', '0', '0', '0', '20000|20000|30000|40000|50000|60000|85000|100000|0|0|0|0', 'Сотрудник Компании|Помошник Компании|Инвеститор Компании|Механник Компании|Мэнеджер Компании|Заместитель Директора Компани|Директор Компании|Владелец Компании|none|none|none|none', '1|6|8|8|8|3|3|3', 'FFFF00', '0', '0', '0', '0', '0', 'e', '0', '1672240210', '0', '0', '7', '1639698348', '15', '14073551', '0', '0', '0');
	INSERT INTO `businesses` (`b_id`, `b_owner_inc`, `b_owner_name`, `b_name`, `b_pos_x`, `b_pos_y`, `b_pos_z`, `b_pos_c`, `b_int`, `b_money`, `b_close`, `b_price`, `b_donate_price`, `b_product`, `b_type`, `b_cost`, `b_fee`, `b_maxproduct`, `b_improve`, `b_mafia`, `b_tax`, `b_procurement_x`, `b_procurement_y`, `b_procurement_z`, `b_repair_x`, `b_repair_y`, `b_repair_z`, `b_status_salary`, `b_salary`, `b_ranks`, `b_settings`, `b_chat_color`, `b_robbery`, `b_win_prise`, `b_win_car`, `b_sound`, `b_radio_status`, `b_radio_url`, `b_sell_status`, `b_meeting`, `b_family`, `b_freeze`, `b_freeze_day`, `b_freeze_date`, `b_max_car`, `b_cash_today`, `b_visitors`, `b_rating`, `b_car_marker`) VALUES ('142', '-1', 'Собственность штата', 'Управление судами', '2425.2114', '237.5540', '17.3241', '181.2747', '0', '0', '0', '750000', '1500', '1000', '28', '50', '0', '15000', '0|0|0|0', '25', '0', '0', '0', '0', '0', '0', '0', '0', '20000|20000|30000|40000|50000|60000|85000|100000|0|0|0|0', 'Сотрудник Компании|Помошник Компании|Инвеститор Компании|Механник Компании|Мэнеджер Компании|Заместитель Директора Компани|Директор Компании|Владелец Компании|none|none|none|none', '1|6|8|8|8|3|3|3', 'FFFF00', '0', '0', '0', '0', '0', 'e', '0', '1672240210', '0', '0', '7', '1639698348', '15', '14073551', '0', '0', '0');
	INSERT INTO `businesses` (`b_id`, `b_owner_inc`, `b_owner_name`, `b_name`, `b_pos_x`, `b_pos_y`, `b_pos_z`, `b_pos_c`, `b_int`, `b_money`, `b_close`, `b_price`, `b_donate_price`, `b_product`, `b_type`, `b_cost`, `b_fee`, `b_maxproduct`, `b_improve`, `b_mafia`, `b_tax`, `b_procurement_x`, `b_procurement_y`, `b_procurement_z`, `b_repair_x`, `b_repair_y`, `b_repair_z`, `b_status_salary`, `b_salary`, `b_ranks`, `b_settings`, `b_chat_color`, `b_robbery`, `b_win_prise`, `b_win_car`, `b_sound`, `b_radio_status`, `b_radio_url`, `b_sell_status`, `b_meeting`, `b_family`, `b_freeze`, `b_freeze_day`, `b_freeze_date`, `b_max_car`, `b_cash_today`, `b_visitors`, `b_rating`, `b_car_marker`) VALUES ('143', '-1', 'Собственность штата', 'Обслуживание бортов', '2423.0249', '-2550.8671', '21.9874', '297.6259', '0', '0', '0', '750000', '3000', '1000', '29', '50', '0', '15000', '0|0|0|0', '25', '0', '0', '0', '0', '0', '0', '0', '0', '20000|20000|30000|40000|50000|60000|85000|100000|0|0|0|0', 'Сотрудник Компании|Помошник Компании|Инвеститор Компании|Механник Компании|Мэнеджер Компании|Заместитель Директора Компани|Директор Компании|Владелец Компании|none|none|none|none', '1|6|8|8|8|3|3|3', 'FFFF00', '0', '0', '0', '0', '0', 'e', '0', '1672240210', '0', '0', '7', '1639698348', '15', '14073551', '0', '0', '0');
	INSERT INTO `businesses` (`b_id`, `b_owner_inc`, `b_owner_name`, `b_name`, `b_pos_x`, `b_pos_y`, `b_pos_z`, `b_pos_c`, `b_int`, `b_money`, `b_close`, `b_price`, `b_donate_price`, `b_product`, `b_type`, `b_cost`, `b_fee`, `b_maxproduct`, `b_improve`, `b_mafia`, `b_tax`, `b_procurement_x`, `b_procurement_y`, `b_procurement_z`, `b_repair_x`, `b_repair_y`, `b_repair_z`, `b_status_salary`, `b_salary`, `b_ranks`, `b_settings`, `b_chat_color`, `b_robbery`, `b_win_prise`, `b_win_car`, `b_sound`, `b_radio_status`, `b_radio_url`, `b_sell_status`, `b_meeting`, `b_family`, `b_freeze`, `b_freeze_day`, `b_freeze_date`, `b_max_car`, `b_cash_today`, `b_visitors`, `b_rating`, `b_car_marker`) VALUES ('144', '-1', 'Собственность штата', 'Управление бортами', '2132.9086', '-1982.3607', '20.2513', '1.3999', '0', '0', '0', '750000', '1500', '1000', '30', '50', '0', '15000', '0|0|0|0', '25', '0', '0', '0', '0', '0', '0', '0', '0', '20000|20000|30000|40000|50000|60000|85000|100000|0|0|0|0', 'Сотрудник Компании|Помошник Компании|Инвеститор Компании|Механник Компании|Мэнеджер Компании|Заместитель Директора Компани|Директор Компании|Владелец Компании|none|none|none|none', '1|6|8|8|8|3|3|3', 'FFFF00', '0', '0', '0', '0', '0', 'e', '0', '1672240210', '0', '0', '7', '1639698348', '15', '14073551', '0', '0', '0');
	UPDATE `businesses` SET `b_type` = '32' WHERE `businesses`.`b_id` = 90;
	UPDATE `businesses` SET `b_type` = '31' WHERE `businesses`.`b_id` = 91;

	UPDATE `houses` SET `h_meeting` = '1678461000' WHERE `h_owner` = '-1';
	UPDATE `businesses` SET `b_meeting` = '1678461000' WHERE `b_owner_inc` = '-1';
	
	TRUNCATE TABLE `donate_discount`;
	
*/