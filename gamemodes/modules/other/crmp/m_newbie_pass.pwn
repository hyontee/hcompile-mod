new
	gNewBiePassLVL [ MAX_PLAYERS char ],
	gNewBiePassEXP [ MAX_PLAYERS char ],
	bool: gNewBiePassLimit [ MAX_PLAYERS ],
	gNewBiePassQuest [ MAX_PLAYERS ],
	gNewBiePA [ MAX_PLAYERS ],
	gNewBieMonitorBonus [ MAX_PLAYERS ] ;

new NewBiePass [ MAX_BATTLE_PASS_ITEMS ] [ ENUM_BATTLE_PASS_ITEMS ] =
{
    {"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 		"Dodge TRX", 9, 3361, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR}, // 0
	{"2 EXP", 2, 2, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 											"Skin Рулетка", 12, 1, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 1
	
	{"VIP Bronze (3 дн.)", 156, 24, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,							"Деньги: 2 000 000"valute_title_"", 1, 2_000_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 2
	{"10 "donate_title"", 4, 10, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 								"10 "donate_title"", 4, 10, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 3
	
	//{"Лотерея", 28, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER, 										"Лотерея", 29, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 4
	{"Рюкзак Supreme", 8, 12663, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT, 							"Рюзак Пикачу", 8, 5003, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT}, // 4
	{"Аптечка", BP_INVENTORY, ITEM_AID_KIT, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 					"Деньги: 1 000 000"valute_title_"", 1, 1_000_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 5
	
	{"Brozne Рулетка", 45, 1, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 								"Skin Рулетка #2", 13, 1, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 6
	{"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 		"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 7

	{"15 "donate_title"", 4, 15, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 								"15 "donate_title"", 4, 15, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 8
	{"Деньги: 2 000 000"valute_title_"", 1, 2_000_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 		"4 EXP", 2, 4, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 9

	{"Канистра", BP_INVENTORY, 157, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 							"Деньги: 2 500 000"valute_title_"", 1, 2_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 10
	{"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 											"Car Рулетка", 18, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 11

	{"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 		"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 12
	{"Silver Рулетка", 55, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER, 									"Одежда #4735", 3, 4735, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN}, // 13

	{"20 "donate_title"", 4, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 								"20 "donate_title"", 4, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 14
	{"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 			"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 15
	
	{"Brozne Рулетка", 45, 1, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 									"Рулетка аксессуаров", 10, 1, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 16
	{"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,		"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 17
	
	{"25 "donate_title"", 4, 25, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,								"Custom Броня #5", 8, 5040, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT}, // 18
	{"Одежда #4669", 3, 4669, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN,									"Одежда #4723", 3, 4723, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN}, // 19

	{"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,			"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 20
	{"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,											"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 21

	{"Военная броня", 8, 5015, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT,								"BMW M1", 9, 3359, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT}, // 22
	{"Аптечка", BP_INVENTORY, ITEM_AID_KIT, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER,						"Рулетка аксессуаров", 10, 1, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 23

	{"Деньги: 3 500 000"valute_title_"", 1, 3_500_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,			"Деньги: 3 500 000"valute_title_"", 1, 3_500_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 24
	{"Рем. комплект", BP_INVENTORY, 156, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER,					"+1 слот т/с", 23, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER}, // 25
	
	{"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,											"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 26
	{"Silver Рулетка", 6, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER,									"Рулетка аксессуаров #2", 11, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 27
	
	// 28
	
	{"10 "family_title"", 22, 10, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,								"10 "family_title"", 22, 10, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 28
	{"Деньги: 2 500 000"valute_title_"", 1, 2_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,		"Skin Рулетка #4", 15, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER}, // 29
	
	{"20 "donate_title"", 26, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,								"20 "donate_title"", 26, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 30
	{"Одежда #4640", 3, 4640, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN,									"Деньги: 2 500 000"valute_title_"", 1, 2_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 31
	
	{"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,											"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 32
	{"Деньги: 1 000 000"valute_title_"", 1, 1_000_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,		"Деньги: 1 000 000"valute_title_"", 1, 1_000_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 33
	
	{"Рулетка удачи Bronze", 96, 1, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,							"Рулетка аксессуаров #2", 11, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 34
	{"Рулетка удачи Silver", 97, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER,								"Crime Plus (3 часа)", 25, 3, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 35
	
	{"Battle Pass 10%", BP_INVENTORY, 184, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER,					"Skin Рулетка #5", 16, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER}, // 36
	{"20 "donate_title"", 26, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,								"20 "donate_title"", 26, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 37
	
	{"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,			"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 38
	{"Очки Heart", 8, 12611, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT,								"Custom Броня #6", 8, 5041, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_OBJECT}, // 39

	{"Деньги: 1 000 000"valute_title_"", 1, 1_000_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,		"Деньги: 5 000 000"valute_title_"", 1, 5_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 40
	{"Карта кладов (5 часов)", 24, 5, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,							"Car Рулетка #2", 19, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER}, // 41
	
	// 42

	{"10 "family_title"", 22, 10, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,								"10 "family_title"", 22, 10, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 42
	{"Audi CF", 9, 3373, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR,										"Skin Рулетка #2", 14, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER}, // 43

	{"Crime Plus (1 час)", 25, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER,								"Деньги: 10 000 000"valute_title_"", 1, 10_000_000, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 44
	{"Kawasaki", 9, 522, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_CAR,									"Карта кладов (15 часов)", 24, 15, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 45

	{"Золото (~5 шт.)", 27, 19941, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT,						"Золото (~15 шт.)", 27, 19941, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT}, // 46
	{"Хлопок (~5 шт.)", 27, 2684, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT,							"Хлопок (~15 шт.)", 27, 2684, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT}, // 47

	{"Рулетка удачи Bronze", 96, 1, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,							"VIP Gold (3 дн.)", 30, 1, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 48
	{"Рулетка удачи Silver", 97, 1, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,							"Рулетка удачи Gold", 98, 1, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 49

	{"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,			"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 50
	{"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,											"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 51

	{"20 "donate_title"", 4, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 								"20 "donate_title"", 4, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 52
	{"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 			"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 53
		
	{"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,											"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 54
	{"Рулетка удачи Silver", 97, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER,								"Рулетка аксессуаров #2", 11, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 55
	
	{"Золото (~5 шт.)", 27, 19941, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT,						"Ключ от тюрьмы", 27, 11746, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT}, // 56
	{"Хлопок (~5 шт.)", 27, 2684, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT,							"Бампер", 27, 1140, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT}, // 57

	{"Деньги: 10 000 000"valute_title_"", 1, 10_000_000, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER,		"Skin Рулетка #6", 17, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER}, // 58
	{"Секретный приз", 21, 300, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER,							"Секретный приз", 21, 300, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER} // 59
} ;

new gNewBieQuestStatus [ MAX_PLAYERS ] [ MAX_PLAYER_EP_QUEST ] ;
new gNewBieQuestProgress [ MAX_PLAYERS ] [ MAX_PLAYER_EP_QUEST ] ;

//#include 									<custom/newbiepass>

stock update_newbie_progress ( playerid, quest, progress, _id )
{
	if ( gNewBiePassLVL { playerid } >= MAX_BATTLE_PASS_ITEMS ) return 1 ;

	if ( gNewBieQuestProgress [ playerid ] [ _id ] < QuestData [ quest ] [ eqProgress ] )
	{
		gNewBieQuestProgress [ playerid ] [ _id ] += progress ;

		new scm_string [ 68 + 32 ] ;
		if ( gNewBieQuestProgress [ playerid ] [ _id ] == QuestData [ quest ] [ eqProgress ] )
		{
			format ( scm_string, sizeof scm_string, "Вы выполнили часть задания. {"#cWH"}Прогресс: %d из %d{"#cOR"}.", gNewBieQuestProgress [ playerid ] [ _id ], QuestData [ quest ] [ eqProgress ] ) ;
			SendClientMessage ( playerid, col_orange, scm_string ) ;
		}
		else if ( gNewBieQuestProgress [ playerid ] [ _id ] > QuestData [ quest ] [ eqProgress ] )
		{
			format ( scm_string, sizeof scm_string, "Вы выполнили часть задания. {"#cWH"}Прогресс: %d из %d{"#cOR"}.", QuestData [ quest ] [ eqProgress ], QuestData [ quest ] [ eqProgress ] ) ;
			SendClientMessage ( playerid, col_orange, scm_string ) ;
		}
		else 
		{
			format ( scm_string, sizeof scm_string, "Вы выполнили часть задания. {"#cWH"}Прогресс: %d из %d{"#cOR"}.", gNewBieQuestProgress [ playerid ] [ _id ], QuestData [ quest ] [ eqProgress ] ) ;
			SendClientMessage ( playerid, col_orange, scm_string ) ;
		}
		
		if ( gNewBieQuestProgress [ playerid ] [ _id ] >= QuestData [ quest ] [ eqProgress ] )
		{
			set_newbie_levelup ( playerid, QuestData [ quest ] [ eqEPassEXP ] ) ;
				
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы успешно выполнили задание {"#cWH"}\"%s\"{"#cOR"}!", QuestData [ quest ] [ eqName ] ) ;
			SendClientMessage ( playerid, col_orange, scm_string ) ;
			
			gNewBiePassQuest [ playerid ] += 1 ;
			
			newbie_check_limit ( playerid ) ;
		}
		save_newbie_progress ( playerid ) ;
	}
	return 1 ;
}

stock give_newbie_progress ( playerid, params_quest, params_amount )
{
	if ( gNewBiePassLVL { playerid } >= MAX_BATTLE_PASS_ITEMS ) return 1 ;
	
	for ( new i = 0 ; i < MAX_PLAYER_EP_QUEST ; i ++ )
	{
		if ( gNewBieQuestStatus [ playerid ] [ i ] != params_quest ) continue ;
		if ( gNewBieQuestProgress [ playerid ] [ i ] >= QuestData [ params_quest ] [ eqProgress ] ) continue ;
		
		update_newbie_progress ( playerid, params_quest, params_amount, i ) ;
		break ;
	}
	return 1 ;
}

stock newbie_check_limit ( playerid )
{
	if ( gNewBiePassLimit [ playerid ] == false ) return 1 ;
	
	new _count = 0, _q_id ;
	for ( new i = 0 ; i < MAX_PLAYER_EP_QUEST ; i ++ )
	{
		_q_id = gNewBieQuestStatus [ playerid ] [ i ] ;
		if ( gNewBieQuestProgress [ playerid ] [ i ] < QuestData [ _q_id ] [ eqProgress ] ) continue ;
		
		_count ++ ;
	}
	
	if ( _count == MAX_PLAYER_EP_QUEST )
	{
		gettime_clear_newbiepass ( playerid ) ;
	}
	return 1 ;
}

stock save_newbie_progress ( playerid )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 900, "UPDATE `users` SET `u_newbie_pass_quest` = '%d|%d|%d|%d|%d|%d', `u_newbie_pass_progress` = '%d|%d|%d|%d|%d|%d', `u_newbie_monitor` = '%d', `u_newbie_quest` = '%d' WHERE `u_id` = '%d' LIMIT 1",
	gNewBieQuestStatus [ playerid ] [ 0 ], gNewBieQuestStatus [ playerid ] [ 1 ], gNewBieQuestStatus [ playerid ] [ 2 ],
	gNewBieQuestStatus [ playerid ] [ 3 ], gNewBieQuestStatus [ playerid ] [ 4 ], gNewBieQuestStatus [ playerid ] [ 5 ],
	gNewBieQuestProgress [ playerid ] [ 0 ], gNewBieQuestProgress [ playerid ] [ 1 ], gNewBieQuestProgress [ playerid ] [ 2 ],
	gNewBieQuestProgress [ playerid ] [ 3 ], gNewBieQuestProgress [ playerid ] [ 4 ], gNewBieQuestProgress [ playerid ] [ 5 ],
	gNewBieMonitorBonus [ playerid ], gNewBiePassQuest [ playerid ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;
	return 1 ;
}

stock set_newbie_levelup ( playerid, _bexp )
{
	new
		BPLevel = gNewBiePassLVL { playerid } ;

	if ( BPLevel == MAX_BATTLE_PASS_ITEMS )
		return 1 ;

	new _bexp_dop = 0 ;
	#if defined m_valentine
		if ( ValentineGettime ( ) == 1 ) _bexp_dop += floatround ( _bexp * 1.2 ) ;
	#endif
	gNewBiePassEXP { playerid } += _bexp + _bexp_dop ;

	new BPExp = gNewBiePassEXP { playerid }, string [ 102 + ( 4 * 9 ) ] ;
	if ( BPExp >= 100 )
	{
		gNewBiePassEXP { playerid } 		= BPExp - 100 ;
		BPLevel 							= gNewBiePassLVL { playerid } += 1 ;
		new BPCoins							= ( BPLevel * 2 ) + ( random ( 100 ) + 10 ) ;
		
		gPlayerBattlePassCoins [ playerid ] += BPCoins ;
		
		if ( player_device { playerid } != 2 )
		{
			format ( string, sizeof string, "{"#cWH"}Ваш уровень Event Pass повысился.\n\nВаша награда в Event Pass: {F1C40F}%s\n{"#cWH"}Получено "event_coins": {F1C40F}%d", NewBiePass [ BPLevel ] [ bpiName ], BPCoins ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Event Pass", string, "Получить", "" ) ;

			switch ( NewBiePass [ BPLevel ] [ bpiType ] )
			{
				case BP_NONE:
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Произошла ошабка при выдаче приза. Идентификатор: неизвестный приз." ) ;
				}
				case BP_SKIN:
				{
					SendClientMessage ( playerid, col_succes, !"Поздравляем! Вы получаете скин!" ) ;

					give_inventory ( playerid, NewBiePass [ BPLevel ] [ bpiAmount ], 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
					format ( string, sizeof string, "* Вам был добавлен предмет 'Одежда #%d'. Откройте инвентарь, используйте /mm или радиальное меню.", NewBiePass [ BPLevel ] [ bpiAmount ] ) ;
					SendClientMessage ( playerid, col_yellow, string ) ;
				}
				case BP_MONEY:
				{
					new scm_string [ 52 + 9 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d"valute_title"{"#cSucces"}.", NewBiePass [ BPLevel ] [ bpiAmount ] ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;

					give_money ( playerid, NewBiePass [ BPLevel ] [ bpiAmount ] ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, NewBiePass [ BPLevel ] [ bpiAmount ], "приз за EventPass" ) ;
				}
				case BP_SECRET:
				{
					if ( event_count >= 1 )
					{
						event_count -- ;
						
						new sql_string [ 100 ] ;
						format ( sql_string, sizeof sql_string, "UPDATE `bp_event` SET `event_count` = '%d' LIMIT 1", event_count ) ;
						mysql_tquery ( sql_connection, sql_string ) ;
						
						new _car_id ;
						switch ( random ( 6 ) )
						{
							/*case 0: _car_id = 405 ;
							case 1: _car_id = 419 ;
							case 2: _car_id = 575 ;
							case 3: _car_id = 576 ;
							case 4: _car_id = 411 ;
							case 5: _car_id = 409 ;*/
							case 0: _car_id = 3322 ;
							case 1: _car_id = 3322 ;
							case 2: _car_id = 3323 ;
							case 3: _car_id = 3323 ;
							case 4: _car_id = 3324 ;
							case 5: _car_id = 3324 ;
						}
						veh_prise_create ( playerid, 0, _car_id ) ;
						
						new scm_string [ 52 + 9 ] ;
						format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%s{"#cSucces"}.", GetVehicleNameEx ( INVALID_VEHICLE_ID, _car_id ) ) ;
						SendClientMessage ( playerid, col_succes, scm_string ) ;
					}
					else
					{
						new scm_string [ 52 + 9 ] ;
						format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "donate_title"{"#cSucces"}.", NewBiePass [ BPLevel ] [ bpiAmount ] ) ;
						SendClientMessage ( playerid, col_succes, scm_string ) ;
						
						give_player_donate ( playerid, NewBiePass [ BPLevel ] [ bpiAmount ], 2 ) ;
					}
				}
				case BP_EXP:
				{
					new scm_string [ 52 + 9 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d EXP{"#cSucces"}.", NewBiePass [ BPLevel ] [ bpiAmount ] ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
					
					rewards_exp ( playerid, NewBiePass [ BPLevel ] [ bpiAmount ] ) ;
				}
				case BP_DONATE:
				{
					new scm_string [ 52 + 9 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "donate_title"{"#cSucces"}.", NewBiePass [ BPLevel ] [ bpiAmount ] ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
						
					give_player_donate ( playerid, NewBiePass [ BPLevel ] [ bpiAmount ], 2 ) ;
				}
				case BP_BRONZE_ROULETTE:
				{
					new scm_string [ 52 + 9 ], _rou_count = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d рулетку(ок){"#cSucces"}.", _rou_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
					
					give_inventory ( playerid, 2045, _rou_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2045 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_SILVER_ROULETTE:
				{
					new scm_string [ 52 + 9 ], _rou_count = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d рулетку(ок){"#cSucces"}.", _rou_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
					
					give_inventory ( playerid, 2055, _rou_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2055 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_GOLD_ROULETTE:
				{
					new scm_string [ 52 + 9 ], _rou_count = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d рулетку(ок){"#cSucces"}.", _rou_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
					
					give_inventory ( playerid, 2125, _rou_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2125 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_ACCS:
				{
					new _acc_id = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					give_inventory ( playerid, _acc_id, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _acc_id ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_FAMILY:
				{
					new _er_count = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					
					give_inventory (
						playerid,
						ITEM_FAMILY_TALON,
						_er_count,
						0,
						"",
						"",
						NUMBERPLATE_TYPE_NONE,
						0,
						-1
					) ;
						
					new scm_string [ 100 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "family_title"{"#cSucces"}.", _er_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
				}
				case BP_SLOT_CAR:
				{
					SendClientMessage ( playerid, col_succes, "Поздравляем! Вы получаете {"#cWH"}+1 слот для т/с{"#cSucces"}." ) ;
					
					p_info [ playerid ] [ max_veh ] ++ ;
					update_int_sql ( playerid, "u_maxveh", p_info [ playerid ] [ max_veh ] ) ;
				}
				case BP_TREASURE:
				{
					new _er_count = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					
					new _treasure_card ;
					if ( p_info [ playerid ] [ treasure_card ] > gettime ( ) )
					{
						_treasure_card = _er_count * 3600 ;

						p_info [ playerid ] [ treasure_card ] += _treasure_card ;
						update_int_sql ( playerid, "u_treasure_card", p_info [ playerid ] [ treasure_card ] ) ;
					}
					else
					{
						_treasure_card = SetElapsedTime ( gettime ( ), _er_count, CONVERT_TIME_TO_HOURS ) ;

						p_info [ playerid ] [ treasure_card ] = _treasure_card ;
						update_int_sql ( playerid, "u_treasure_card", _treasure_card ) ;
					}
					
					new scm_string [ 100 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}карту кладов (%d ч.){"#cSucces"}.", _er_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
				}
				case BP_CRIME:
				{
					new _er_count = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					
					p_info [ playerid ] [ crime_plus ] = true ;
					if ( p_info [ playerid ] [ crime_plus_date ] > gettime ( ) ) p_info [ playerid ] [ crime_plus_date ] += _er_count * 3600 ;
					else p_info [ playerid ] [ crime_plus_date ] = SetElapsedTime ( gettime ( ), _er_count, CONVERT_TIME_TO_DAYS ) ;
					update_int_sql ( playerid, "u_crime_plus_date", p_info [ playerid ] [ crime_plus_date ] ) ;
					
					new scm_string [ 100 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}Crime Plus (%d ч.){"#cSucces"}.", _er_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
				}
				case BP_DONATE_BONUS:
				{
					new _er_count = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					
					new scm_string [ 100 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "donate_title"{"#cSucces"}.", _er_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
							
					give_player_donate ( playerid, _er_count, 1 ) ;
				}
				case BP_DETAIL_CRAFT:
				{
					new _bpiAmount = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					give_inventory ( playerid, _bpiAmount, random ( 15 ) + 10, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _bpiAmount ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
					SendClientMessage ( playerid, col_yellow, !"* Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{FFFF00})" ) ;
				}
				case BP_ROULETTE_ITEM_0:
				{
					new _bpiAmount = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					give_inventory ( playerid, 2045, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2045 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_ROULETTE_ITEM_1:
				{
					new _bpiAmount = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					give_inventory ( playerid, 2055, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2055 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_ROULETTE_ITEM_2:
				{
					new _bpiAmount = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					give_inventory ( playerid, 125, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 125 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_INVENTORY:
				{
					new _bpiAmount = NewBiePass [ BPLevel ] [ bpiAmount ] ;
					give_inventory ( playerid, _bpiAmount, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
						
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _bpiAmount ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
			}
		}
		else
		{
			if ( BPLevel < MAX_BATTLE_PASS_ITEMS )
			{
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "{"#cWH"}Ваш уровень Event Pass повысился.\n\nВаша награда в Event Pass: {F1C40F}%s\n{"#cWH"}Получено "event_coins": {F1C40F}%d", NewBiePass [ BPLevel ] [ bpiName ], BPCoins ) ;
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Event Pass", global_string, "Получить", "" ) ;
				
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте /einfo для получения приза." ) ;
			}
		}
	}
	string [ 0 ] = EOS ;
	format ( string, sizeof string, "UPDATE `users` SET `u_newbie_pass` = '%d', `u_newbie_exp` = '%d', `u_ecoins` = '%d' WHERE `u_id` = '%d' LIMIT 1", gNewBiePassLVL { playerid }, gNewBiePassEXP { playerid }, gPlayerBattlePassCoins [ playerid ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, string ) ;
	return 1 ;
}

stock give_newbie_prise ( playerid )
{
	new BPLevel = gNewBiePA [ playerid ], _bpiType = NewBiePass [ BPLevel ] [ bpiType ], _bpiAmount = NewBiePass [ BPLevel ] [ bpiAmount ] ;
	switch ( _bpiType )
	{
	    case BP_NONE:
		{
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Произошла ошибка при выдаче приза. Идентификатор: неизвестный приз." ) ;
		}
		case BP_SKIN:
		{
			new sql_string [ 128 ] ;
			format ( sql_string, sizeof sql_string, "%s (BP_SKIN) #%d", p_info [ playerid ] [ name ], _bpiAmount ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, sql_string ) ;
		
            SendClientMessage ( playerid, col_succes, !"Поздравляем! Вы получаете скин!" ) ;
			   
			give_inventory ( playerid, _bpiAmount, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
			format ( sql_string, sizeof sql_string, "* Вам был добавлен предмет 'Одежда #%d'. Откройте инвентарь, используйте /mm или радиальное меню.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_yellow, sql_string ) ;
		}
		case BP_CAR:
		{
			new sql_string [ 128 ] ;
			format ( sql_string, sizeof sql_string, "%s (BP_CAR) #%d", p_info [ playerid ] [ name ], _bpiAmount ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, sql_string ) ;
			
            SendClientMessage ( playerid, col_succes, !"Поздравляем! Вы получаете транспорт!" ) ;
			   
			give_inventory ( playerid, _bpiAmount, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
			format ( sql_string, sizeof sql_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _bpiAmount ) ) ;
			SendClientMessage ( playerid, col_yellow, sql_string ) ;
		}
		case BP_MONEY:
		{
			new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d"valute_title"{"#cSucces"}.", _bpiAmount ) ;
            SendClientMessage ( playerid, col_succes, scm_string ) ;

            give_money ( playerid, _bpiAmount ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _bpiAmount, "приз за EventPass" ) ;
		}
		case BP_SECRET:
		{
			new sql_string [ 100 ] ;
			format ( sql_string, sizeof sql_string, "%s (BP_SECRET)", p_info [ playerid ] [ name ] ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, sql_string ) ;
			
			new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "donate_title"{"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
				
			give_player_donate ( playerid, _bpiAmount, 2 ) ;
		}
		case BP_EXP:
		{
			new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d EXP{"#cSucces"}.", _bpiAmount ) ;
            SendClientMessage ( playerid, col_succes, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "%s (BP_EXP) %d EXP", p_info [ playerid ] [ name ], _bpiAmount ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
			
			rewards_exp ( playerid, _bpiAmount ) ;
		}
		case BP_DONATE:
		{
            new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "donate_title"{"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "%s (BP_DONATE) %d "donate_title"", p_info [ playerid ] [ name ], _bpiAmount ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
					
			give_player_donate ( playerid, _bpiAmount, 2 ) ;
		}
		case BP_BRONZE_ROULETTE:
		{
			if ( player_device { playerid } == 2 ) return SendClientMessage ( playerid, col_white, "{"#cBInfo"}* {"#cWH"}Откройте {"#cBInfo"}Event Pass {"#cWH"}и используйте рулетку." ) ;
		
			new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d рулетку(ок){"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
					
			give_inventory ( playerid, 2045, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2045 ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		case BP_SILVER_ROULETTE:
		{
			if ( player_device { playerid } == 2 ) return SendClientMessage ( playerid, col_white, "{"#cBInfo"}* {"#cWH"}Откройте {"#cBInfo"}Event Pass {"#cWH"}и используйте рулетку." ) ;
			
			new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d рулетку(ок){"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
					
			give_inventory ( playerid, 2055, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2055 ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		case BP_GOLD_ROULETTE:
		{
			if ( player_device { playerid } == 2 ) return SendClientMessage ( playerid, col_white, "{"#cBInfo"}* {"#cWH"}Откройте {"#cBInfo"}Event Pass {"#cWH"}и используйте рулетку." ) ;
			
			new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d рулетку(ок){"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
					
			give_inventory ( playerid, 2125, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2125 ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		case BP_ACCS:
		{
			give_inventory ( playerid, _bpiAmount, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			
			new scm_string [ 66 + 32 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете аксессуар {"#cWH"}\"%s\"{"#cSucces"}.", get_accessorie_name ( _bpiAmount ) ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "%s (BP_ACCS) %s", p_info [ playerid ] [ name ], get_accessorie_name ( _bpiAmount ) ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
		}
		case BP_FAMILY:
		{
			give_inventory (
				playerid,
				ITEM_FAMILY_TALON,
				_bpiAmount,
				0,
				"",
				"",
				NUMBERPLATE_TYPE_NONE,
				0,
				-1
			) ;
				
			new scm_string [ 100 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "family_title"{"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "%s (BP_FAMILY) %d "family_title"", p_info [ playerid ] [ name ], _bpiAmount ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
		}
		case BP_SLOT_CAR:
		{
			SendClientMessage ( playerid, col_succes, "Поздравляем! Вы получаете {"#cWH"}+1 слот для т/с{"#cSucces"}." ) ;
			
			p_info [ playerid ] [ max_veh ] ++ ;
			update_int_sql ( playerid, "u_maxveh", p_info [ playerid ] [ max_veh ] ) ;
			
			new scm_string [ 100 ] ;
			format ( scm_string, sizeof scm_string, "%s (BP_SLOT_CAR)", p_info [ playerid ] [ name ] ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
		}
		case BP_TREASURE:
		{
			new _treasure_card ;
			if ( p_info [ playerid ] [ treasure_card ] > gettime ( ) )
			{
				_treasure_card = _bpiAmount * 3600 ;

				p_info [ playerid ] [ treasure_card ] += _treasure_card ;
				update_int_sql ( playerid, "u_treasure_card", p_info [ playerid ] [ treasure_card ] ) ;
			}
			else
			{
				_treasure_card = SetElapsedTime ( gettime ( ), _bpiAmount, CONVERT_TIME_TO_HOURS ) ;

				p_info [ playerid ] [ treasure_card ] = _treasure_card ;
				update_int_sql ( playerid, "u_treasure_card", _treasure_card ) ;
			}
				
			new scm_string [ 100 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}карту кладов (%d ч.){"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
		}
		case BP_CRIME:
		{
			p_info [ playerid ] [ crime_plus ] = true ;
			if ( p_info [ playerid ] [ crime_plus_date ] > gettime ( ) ) p_info [ playerid ] [ crime_plus_date ] += _bpiAmount * 3600 ;
			else p_info [ playerid ] [ crime_plus_date ] = SetElapsedTime ( gettime ( ), _bpiAmount, CONVERT_TIME_TO_DAYS ) ;
			update_int_sql ( playerid, "u_crime_plus_date", p_info [ playerid ] [ crime_plus_date ] ) ;
				
			new scm_string [ 100 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}Crime Plus (%d ч.){"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "%s (BP_CRIME)", p_info [ playerid ] [ name ] ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
		}
		case BP_DONATE_BONUS:
		{
			new scm_string [ 100 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "donate_title"{"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "%s (BP_DONATE_BONUS) %d "donate_title"", p_info [ playerid ] [ name ], _bpiAmount ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
					
			give_player_donate ( playerid, _bpiAmount, 1 ) ;
		}
		case BP_DETAIL_CRAFT:
		{
			give_inventory ( playerid, _bpiAmount, random ( 15 ) + 10, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _bpiAmount ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
			SendClientMessage ( playerid, col_yellow, !"* Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{FFFF00})" ) ;
		}
		case BP_ROULETTE_ITEM_0:
		{
			give_inventory ( playerid, 2045, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2045 ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		case BP_ROULETTE_ITEM_1:
		{
			give_inventory ( playerid, 2055, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2055 ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		case BP_ROULETTE_ITEM_2:
		{
			give_inventory ( playerid, 2125, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2125 ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		case BP_INVENTORY:
		{
			give_inventory ( playerid, _bpiAmount, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
						
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _bpiAmount ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
	}
	return 1 ;
}

stock gettime_clear_newbiepass ( playerid )
{
	if ( gNewBiePassLVL { playerid } >= MAX_BATTLE_PASS_ITEMS ) return 1 ;
	for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ ) gNewBieQuestStatus [ playerid ] [ q ] = -1 ;
	
	new _random ;
	
	start_random_ep:
	_random = random ( MAX_EVENT_QUESTS ) ;
	for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ )
	{
		if ( gNewBieQuestStatus [ playerid ] [ q ] == _random )
		{
			goto start_random_ep ;
			break ;
		}
		if ( gNewBieQuestStatus [ playerid ] [ q ] != -1 ) continue ;
		
		gNewBieQuestStatus [ playerid ] [ q ] = _random ;
		goto start_random_ep ;
		break ;
	}
	
	gNewBieMonitorBonus [ playerid ] = random ( 6 ) + 1 ;
	gNewBieQuestProgress [ playerid ] = ClearPlayerEventProgress ;
    save_newbie_progress ( playerid ) ;
	return 1 ;
}

stock show_packet_newbie ( playerid, _param1, _param2, _param3 )
{
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 ) // back to bp
		{
			newbieShow ( playerid, "приветственный" ) ;
			selectNewBie ( playerid, 0 ) ;
			
			new _count = 0, _id ;
			for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ )
			{
				_id = gNewBieQuestStatus [ playerid ] [ q ] ;
				if ( _id == -1 ) continue ;
				if ( gNewBieQuestProgress [ playerid ] [ q ] < QuestData [ _id ] [ eqProgress ] ) continue ;
				
				_count ++ ;
			}
			
			new _str [ 12 ], _str2 [ 12 ], _str3 [ 12 ], bool: _limit = gNewBiePassLimit [ playerid ] ;
			format ( _str, sizeof _str, "%d", gNewBiePassLVL { playerid } + 1 ) ;
			if ( _limit ) format ( _str2, sizeof _str2, "%d", _count ) ;
			else format ( _str2, sizeof _str2, "%d/%d", _count, MAX_PLAYER_EP_QUEST ) ;
			format ( _str3, sizeof _str3, "%d", gNewBiePassQuest [ playerid ] ) ;
			if ( _limit ) newbieUpdateMainLayout ( playerid, _str, _str2, false, _str3 ) ;
			else newbieUpdateMainLayout ( playerid, _str, _str2, true, _str3 ) ;
			newbieAddBPItem ( playerid, 10 ) ;
		}
		else if ( _param2 == 2 ) // item take
		{
			if ( gNewBiePA [ playerid ] <= gNewBiePassLVL { playerid } )
			{
				give_newbie_prise ( playerid ) ;
				
				gNewBiePA [ playerid ] += 1 ;
				new _activated = gNewBiePA [ playerid ] ;
				update_int_sql ( playerid, "u_newbie_priseuse", _activated ) ;
				newbieUpdateBPItem ( playerid, _activated - 1 ) ;
				if ( _activated < MAX_BATTLE_PASS_ITEMS ) newbieUpdateBPItem ( playerid, _activated ) ;
			}
		}
		else if ( _param2 == 4 ) // add item in main (прогрузка каждые 10 позиций)
		{
			if ( _param3 < MAX_BATTLE_PASS_ITEMS )
				newbieAddBPItem ( playerid, _param3 + 10 ) ;
		}
		else if ( _param2 == 5 ) // limit
		{
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Лимит заданий в сутки", "\
				Вы можете снять лимит заданий в сутки.\n\
				Сняв лимит задания будут обновляться сразу после выполнения.\n\n\
				{"#cGRDialog"}* Услуга доступна в {"#cWH"}/donate{"#cGRDialog"}.", "Принять", "" ) ;
		}
	}
	else if ( _param1 == 1 )
	{
		selectNewBie ( playerid, 0 ) ;
			
		new _count = 0, _id ;
		for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ )
		{
			_id = gNewBieQuestStatus [ playerid ] [ q ] ;
			if ( _id == -1 ) continue ;
			if ( gNewBieQuestProgress [ playerid ] [ q ] < QuestData [ _id ] [ eqProgress ] ) continue ;
				
			_count ++ ;
		}
		new _str [ 12 ], _str2 [ 12 ], _str3 [ 12 ], bool: _limit = gNewBiePassLimit [ playerid ] ;
		format ( _str, sizeof _str, "%d", gNewBiePassLVL { playerid } + 1 ) ;
		if ( _limit ) format ( _str2, sizeof _str2, "%d", _count ) ;
		else format ( _str2, sizeof _str2, "%d/%d", _count, MAX_PLAYER_EP_QUEST ) ;
		format ( _str3, sizeof _str3, "%d", gNewBiePassQuest [ playerid ] ) ;
		if ( _limit ) newbieUpdateMainLayout ( playerid, _str, _str2, false, _str3 ) ;
		else newbieUpdateMainLayout ( playerid, _str, _str2, true, _str3 ) ;
	}
	else if ( _param1 == 3 )
	{
		selectNewBie ( playerid, 1 ) ;
		newbieAddTasks ( playerid, "очков опыта" ) ;
	}
	else if ( _param1 == 4 )
	{
		if ( _param2 == 1 )
		{
			if ( gNewBieMonitorBonus [ playerid ] == _param3 )
			{
				newbieMiniPrize ( playerid, 0 ) ;
				
				gNewBieMonitorBonus [ playerid ] = -1 ;
				update_int_sql ( playerid, "u_newbie_monitor", -1 ) ;
				
				new _item ;
				if ( _param3 == 1 ) _item = RandomEx ( 15, 23 ) ;
				else if ( _param3 == 2 )
				{
					switch ( random ( 5 ) )
					{
						case 0, 1, 2, 3: _item = 3 ;
						case 4: _item = 45 ;
					}
				}
				else if ( _param3 == 3 ) _item = RandomEx ( 4, 9 ) ;
				else if ( _param3 == 4 ) _item = RandomEx ( 37, 44 ) ;
				else if ( _param3 == 5 ) _item = RandomEx ( 88, 94 ) ;
				else if ( _param3 == 6 ) _item = RandomEx ( 84, 87 ) ;
				
				give_inventory ( playerid, _item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, -1 ) ;
			
				global_string [ 0 ] = EOS ;
				format ( global_string, 144, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _item ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
				
				new sql_string [ 128 ] ;
				format ( sql_string, sizeof sql_string, "%s (BP_NEWBIE) %s", p_info [ playerid ] [ name ], item_name ( _item ) ) ;
				WriteLog ( playerid, TYPE_LOG_BATTLEPASS, sql_string ) ;
			}
		}
	}
	else if ( _param1 == 255 ) // hide
	{
		newbieHide ( playerid ) ;
		
		toggle_controlable ( playerid, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
	}
	return 1 ;
}

CMD:testbp ( playerid )
{
	newbieShow ( playerid, "приветственный" ) ;
	selectNewBie ( playerid, 0 ) ;
	newbieMiniPrize ( playerid, ( gNewBieMonitorBonus [ playerid ] < 1 ) ? ( 0 ) : ( gNewBieMonitorBonus [ playerid ] ) ) ;
			
	new _count = 0, _id ;
	for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ )
	{
		_id = gNewBieQuestStatus [ playerid ] [ q ] ;
		if ( _id == -1 ) continue ;
		if ( gNewBieQuestProgress [ playerid ] [ q ] < QuestData [ _id ] [ eqProgress ] ) continue ;
				
		_count ++ ;
	}
			
	new _str [ 12 ], _str2 [ 12 ], _str3 [ 12 ], bool: _limit = gNewBiePassLimit [ playerid ] ;
	format ( _str, sizeof _str, "%d", gNewBiePassLVL { playerid } + 1 ) ;
	if ( _limit ) format ( _str2, sizeof _str2, "%d", _count ) ;
	else format ( _str2, sizeof _str2, "%d/%d", _count, MAX_PLAYER_EP_QUEST ) ;
	format ( _str3, sizeof _str3, "%d", gNewBiePassQuest [ playerid ] ) ;
	if ( _limit ) newbieUpdateMainLayout ( playerid, _str, _str2, false, _str3 ) ;
	else newbieUpdateMainLayout ( playerid, _str, _str2, true, _str3 ) ;
	newbieAddBPItem ( playerid, 10 ) ;
	
	newbieAddGuideMainLayout ( playerid ) ;
	
	toggle_controlable ( playerid, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	return 1 ;
}