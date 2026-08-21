#define GIVE_FREE_CASE_TIME		(3 * 3600)

enum
{
	CASE_FREE_ID,
	CASE_BMW_ID,
	CASE_MERCEDES_ID,
	CASE_MAJOR_ID,
	CASE_LAMBO_ID,
	CASE_BEZUMIE_HAOSA_ID,
	CASE_LEGENDS_SAND_ID,

	CASE_MAX_ID
} ;
new donate_cases_info [ CASE_MAX_ID ] [ 32 ] ;
new users_donate_cases [ MAX_PLAYERS ] [ CASE_MAX_ID ] ;

new donate_player_time [ MAX_PLAYERS ] ;
new playerMultiplyItem [ MAX_PLAYERS ] [ 10 ] = { 0, ... } ;
new playerMultiplyClear [ 10 ] = { 0, ... } ;
new playerDonateSellItem [ MAX_PLAYERS ] ;

stock donate_player_timer ( playerid, _count )
{
	donate_player_time [ playerid ] += _count ;
	if ( donate_player_time [ playerid ] >= GIVE_FREE_CASE_TIME )
	{
		users_donate_cases [ playerid ] [ CASE_FREE_ID ] += 1 ;
		saveUserDonateCase ( playerid, donate_cases_info [ CASE_FREE_ID ], users_donate_cases [ playerid ] [ CASE_FREE_ID ] ) ;

		donate_player_time [ playerid ] = 0 ;
		donate_OnPlayerDisconnect ( playerid ) ;

		SendClientMessage ( playerid, col_yellow, !"* Вам был добавлен предмет 'Кейс бесплатный'. Используйте донат-меню для его прокрутки." ) ;
	}
	return 1 ;
}

stock donate_OnPlayerDisconnect ( playerid )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 256, "UPDATE `users` SET `u_dp_time` = '%d' WHERE `u_id` = '%d' LIMIT 1",
	donate_player_time [ playerid ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;
	return 1 ;
}

enum
{
	d_c_donate_vipgold = 17777,
	d_donate_casket,
	
	d_donate_buy_skins,
	d_donate_buy_vehicles,
	d_donate_buy_acs
} ;

enum _donate_roulette
{
	bp_model,
	bp_rare,
	bp_render,
	bp_color [ 10 ],
	bp_donate_price
} ;

new donate_free_case [ ] [ _donate_roulette ] =
{
	{ 427, RARE_TYPE_RED, RENDER_TYPE_VEHICLE, "", 0 }, // Chevrolet Camaro ZL1
	{ 20, RARE_TYPE_PURPLE, RENDER_TYPE_SKINS, "", 0 },
	{ 3509, RARE_TYPE_PURPLE, NON_RENDER_TYPE, "", 0 },
	{ 2024, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // vip bronze
	{ 1, RARE_TYPE_GRAY, RENDER_TYPE_SKINS, "", 0 },
	{ 2, RARE_TYPE_GRAY, RENDER_TYPE_SKINS, "", 0 },
	{ 4, RARE_TYPE_GRAY, RENDER_TYPE_SKINS, "", 0 },
	{ 6, RARE_TYPE_GRAY, RENDER_TYPE_SKINS, "", 0 },
	{ 11, RARE_TYPE_GRAY, RENDER_TYPE_SKINS, "", 0 },
	{ 2002, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2001, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2050, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2049, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2009, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2008, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 } // money
} ;

new donate_bmw_case [ ] [ _donate_roulette ] =
{
	{ 466, RARE_TYPE_RED, RENDER_TYPE_VEHICLE, "", 0 }, // BMW M5 F90
	{ 507, RARE_TYPE_RED, RENDER_TYPE_VEHICLE, "", 0 }, // BMW 50D E39
	{ 14120, RARE_TYPE_PURPLE, RENDER_TYPE_OBJECT, "", 0 },
	{ 2002, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2001, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2050, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2049, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2009, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2008, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 } // money
} ;

new donate_mercedes_case [ ] [ _donate_roulette ] =
{
	{ 490, RARE_TYPE_RED, RENDER_TYPE_VEHICLE, "", 0 }, // Mercedes-Benz G63
	{ 504, RARE_TYPE_RED, RENDER_TYPE_VEHICLE, "", 0 }, // Mercedes-Benz GT 63S
	{ 14119, RARE_TYPE_PURPLE, RENDER_TYPE_OBJECT, "", 0 },
	{ 2002, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2001, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2050, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2049, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2009, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2008, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 } // money
} ;

new donate_major_case [ ] [ _donate_roulette ] =
{
	{ 503, RARE_TYPE_RED, RENDER_TYPE_VEHICLE, "", 0 }, // BMW I8
	{ 508, RARE_TYPE_RED, RENDER_TYPE_VEHICLE, "", 0 }, // Mercedes-Benz CLS63
	{ 38, RARE_TYPE_PURPLE, RENDER_TYPE_SKINS, "", 0 },
	{ 39, RARE_TYPE_PURPLE, RENDER_TYPE_SKINS, "", 0 },
	{ 14396, RARE_TYPE_GRAY, RENDER_TYPE_OBJECT, "", 0 },
	{ 14395, RARE_TYPE_GRAY, RENDER_TYPE_OBJECT, "", 0 },
	{ 2002, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2001, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2050, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2049, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2009, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2008, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 } // money
} ;

new donate_lambo_case [ ] [ _donate_roulette ] =
{
	{ 602, RARE_TYPE_RED, RENDER_TYPE_VEHICLE, "", 0 }, // Lamborghini Huracan
	{ 475, RARE_TYPE_RED, RENDER_TYPE_VEHICLE, "", 0 }, // Lamborghini Urus
	{ 477, RARE_TYPE_RED, RENDER_TYPE_VEHICLE, "", 0 }, // Lamborghini Countach
	{ 81, RARE_TYPE_PURPLE, RENDER_TYPE_SKINS, "", 0 },
	{ 2002, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2001, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2050, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2049, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2009, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2008, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 } // money
} ;

new bezumie_haosa_case [ ] [ _donate_roulette ] =
{
	{ 3501, RARE_TYPE_RED, NON_RENDER_TYPE, "", 250 },
	{ 3504, RARE_TYPE_RED, NON_RENDER_TYPE, "", 250 },
	{ 3507, RARE_TYPE_PURPLE, NON_RENDER_TYPE, "", 250 },
	{ 3515, RARE_TYPE_PURPLE, NON_RENDER_TYPE, "", 250 },
	{ 3518, RARE_TYPE_PURPLE, NON_RENDER_TYPE, "", 250 },
	{ 2002, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2001, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2050, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2049, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2009, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2008, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 } // money
} ;

new legends_sand_case [ ] [ _donate_roulette ] =
{
	{ 3500, RARE_TYPE_RED, NON_RENDER_TYPE, "", 250 },
	{ 3503, RARE_TYPE_RED, NON_RENDER_TYPE, "", 250 },
	{ 3511, RARE_TYPE_RED, NON_RENDER_TYPE, "", 250 },
	{ 3513, RARE_TYPE_PURPLE, NON_RENDER_TYPE, "", 250 },
	{ 2002, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2001, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // exp
	{ 2050, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2049, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2009, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 }, // money
	{ 2008, RARE_TYPE_GRAY, NON_RENDER_TYPE, "", 0 } // money
} ;

enum _donate_list
{
	HierarchyID,
	getInternalID,
	d_Name [ 48 ],
	Subname [ 128 ],
	Type,
	ModelId,
	Color1,
	Color2,
	Cost,
	OldCost,
	ItemBG
} ;

new donate_cases [ ] [ _donate_list ] =
{
	{ 1, 1, "Бесплатный", " ", NON_RENDER_TYPE, 8, 1, 1, 0, 0, CASE_FREE_ID },
	{ 1, 2, "Кейс BMW", " ", NON_RENDER_TYPE, 4, 1, 1, 100, 0, CASE_BMW_ID },
	{ 1, 3, "Кейс Mercedes", " ", NON_RENDER_TYPE, 12, 1, 1, 100, 0, CASE_MERCEDES_ID },
	{ 1, 4, "Кейс Мажор", " ", NON_RENDER_TYPE, 11, 1, 1, 150, 0, CASE_MAJOR_ID },
	{ 1, 5, "Кейс Ламбо", " ", NON_RENDER_TYPE, 9, 1, 1, 150, 0, CASE_LAMBO_ID },
	{ 1, 6, "Безумие хаоса", " ", NON_RENDER_TYPE, 3, 1, 1, 80, 0, CASE_BEZUMIE_HAOSA_ID },
	{ 1, 7, "Легенды песков", " ", NON_RENDER_TYPE, 10, 1, 1, 80, 0, CASE_LEGENDS_SAND_ID }
} ;

new donate_skins [ ] [ _donate_list ] =
{
	{ 1, 1, "Skin 1", " ", 2, 186, 1, 1, 5000, 0, 0 },
	{ 1, 2, "Skin 1", " ", 2, 188, 1, 1, 1000, 0, 0 },
	{ 1, 3, "Skin 1", " ", 2, 289, 1, 1, 500, 0, 0 },
	{ 1, 4, "Skin 1", " ", 2, 290, 1, 1, 500, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 293, 1, 1, 500, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 294, 1, 1, 750, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 296, 1, 1, 1250, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 272, 1, 1, 5000, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 278, 1, 1, 750, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 170, 1, 1, 300, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 171, 1, 1, 300, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 172, 1, 1, 300, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 174, 1, 1, 1000, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 159, 1, 1, 300, 0, 0 },
	{ 1, 5, "Skin 1", " ", 2, 160, 1, 1, 1000, 0, 0 }
} ;

new donate_vehicles [ ] [ _donate_list ] =
{
	{ 2, 1, "Skin 1", " ", 1, 402, 1, 1, 1000, 0, 0 },
	{ 2, 2, "Skin 1", " ", 1, 411, 1, 1, 500, 0, 0 },
	{ 2, 3, "Skin 1", " ", 1, 412, 1, 1, 500, 0, 0 },
	{ 2, 4, "Skin 1", " ", 1, 415, 1, 1, 1000, 0, 0 },
	{ 2, 5, "Skin 1", " ", 1, 437, 1, 1, 300, 0, 0 },
	{ 2, 6, "Skin 1", " ", 1, 451, 1, 1, 300, 0, 0 },
	{ 2, 7, "Skin 1", " ", 1, 466, 1, 1, 1500, 0, 0 },
	{ 2, 8, "Skin 1", " ", 1, 480, 1, 1, 2000, 0, 0 },
	{ 2, 9, "Skin 1", " ", 1, 490, 1, 1, 2000, 0, 0 },
	{ 2, 10, "Skin 1", " ", 1, 503, 1, 1, 2000, 0, 0 },
	{ 2, 11, "Skin 1", " ", 1, 542, 1, 1, 1000, 0, 0 },
	{ 2, 12, "Skin 1", " ", 1, 603, 1, 1, 1800, 0, 0 },
	{ 2, 13, "Skin 1", " ", 1, 475, 1, 1, 3000, 0, 0 },
	{ 2, 14, "Skin 1", " ", 1, 477, 1, 1, 3000, 0, 0 },
	{ 2, 15, "Skin 1", " ", 1, 494, 1, 1, 3000, 0, 0 },
	{ 2, 16, "Skin 1", " ", 1, 495, 1, 1, 3000, 0, 0 },
	{ 2, 17, "Skin 1", " ", 1, 463, 1, 1, 3000, 0, 0 },
	{ 2, 19, "Skin 1", " ", 1, 469, 1, 1, 1500, 0, 0 },
	{ 2, 20, "Skin 1", " ", 1, 447, 1, 1, 2000, 0, 0 },
	{ 2, 21, "Skin 1", " ", 1, 487, 1, 1, 3000, 0, 0 },
	{ 2, 22, "Skin 1", " ", 1, 513, 1, 1, 800, 0, 0 },
	{ 2, 23, "Skin 1", " ", 1, 593, 1, 1, 800, 0, 0 }
} ;

new donate_acs [ ] [ _donate_list ] =
{
	{ 5, 1, "Skin 1", " ", 0, 12144, 1, 1, 750, 0, 0 },
	{ 5, 2, "Skin 1", " ", 0, 12151, 1, 1, 750, 0, 0 },
	{ 5, 3, "Skin 1", " ", 0, 12152, 1, 1, 750, 0, 0 },
	{ 5, 4, "Skin 1", " ", 0, 12153, 1, 1, 750, 0, 0 },
	{ 5, 5, "Skin 1", " ", 0, 12155, 1, 1, 750, 0, 0 },
	{ 5, 6, "Skin 1", " ", 0, 12159, 1, 1, 750, 0, 0 },
	{ 5, 7, "Skin 1", " ", 0, 12161, 1, 1, 750, 0, 0 },
	{ 5, 8, "Skin 1", " ", 0, 14395, 1, 1, 300, 0, 0 },
	{ 5, 9, "Skin 1", " ", 0, 14396, 1, 1, 300, 0, 0 },
	{ 5, 10, "Skin 1", " ", 0, 14397, 1, 1, 300, 0, 0 }
} ;

enum DONATE_VIP_DATA
{
    VIP_TYPE [ 8 ],
    VIP_PRICE,
    VIP_FULL_PRICE,
    VIP_OFFERS [ 600 ]
} ;

new donateVip [ ] [ DONATE_VIP_DATA ] =
{
    { "BRONZE", 300, 400, "Смена стиля походки\nСмена стиля разговора\n+0.2% на счёт в банке\nНе кикает за долгий AFK\nКаждый 5ый PayDay +1 "family_title"\nКаждый 5ый PayDay +1 "donate_title" (Основной)\nУскоренное лечение в больнице\nУскоренная прокачка навыков оружия\nПонижение уровня розыска в 2 раза быстрее\n+3% шанса к выпадению предметов для крафта\nПривилегия действует 30 календарных дней" },
    { "SILVER", 500, 700, "Все привилегии VIP 'Bronze'\nДополнительный слот для автомобиля\nДоступ к /admins\nЛимит в банке х3\n0.5% на счёт в банке\nКаждый 5ый PayDay +1 EXP\nКаждый 3ий PayDay +1 "family_title"\nКаждый 5ый PayDay +2 "donate_title" (Основной)\nСкидка в 30% при оплате штрафов\nУскоренная прокачка навыков на работах\nПри смерти на военной базе материалы не пропадают\nСытость уменьшается в 2 раза медленее\nВозможность владения 3 бизнесами\nВозможность владения 2 домами\n+5% шанса к выпадению предметов для крафта\nПривилегия действует 30 календарных дней" },
    { "GOLD", 800, 1200, "Все привилегии VIP 'Bronze'\nВсе привилегии VIP 'Silver'\nБесконечный голод\nДополнительный слот для автомобиля\nЛимит в банке х5\n0.8% на счёт в банке\nКаждый 3ий PayDay +1 EXP\nКаждый PayDay +1 "family_title"\nКаждый 3ий PayDay +3 "donate_title" (Основной)\nСрок в тюрьме уменьшается в 2 раза быстрее (Не jail)\nСкидка в 50% при оплате штрафов\nВозможность владения 4 бизнесами\nВозможность владения 3 домами\n+10% шанса к выпадению предметов для крафта\nПривилегия действует 30 календарных дней" }
} ;

new donate_services [ ] [ _donate_list ] =
{
	// other
	{ 8, 1, "Права адм. 1 ур.", " ", -1, 55, 1, 1, 550, 0, 1 },
	{ 8, 2, "Права адм. 2 ур.", " ", -1, 55, 1, 1, 700, 0, 1 },
	{ 8, 3, "Права адм. 3 ур.", " ", -1, 55, 1, 1, 850, 0, 1 },
	{ 8, 4, "Права адм. 4 ур.", " ", -1, 55, 1, 1, 2200, 0, 1 },
	{ 8, 5, "Права адм. 5 ур.", " ", -1, 55, 1, 1, 3600, 0, 1 },
	{ 8, 6, "Права адм. 6 ур.", " ", -1, 55, 1, 1, 7000, 0, 1 },
	{ 8, 7, "VIP 'Bronze'", "Услуга на 30 дней", -1, 30, 1, 1, 300, 0, 1 },
	{ 8, 8, "VIP 'Silver'", "Услуга на 30 дней", -1, 30, 1, 1, 500, 0, 1 },
	{ 8, 9, "VIP 'Gold'", "Услуга на 30 дней", -1, 30, 1, 1, 800, 0, 1 },
	{ 8, 10, "Смена игрового никнейма", " ", -1, 101, 1, 1, 100, 0, 1 },
	{ 8, 11, "Снятие предупреждения", " ", -1, 99, 1, 1, 200, 0, 1 },
	{ 8, 12, "Дополнительный слот для машины", "Навсегда", -1, 23, 1, 1, 600, 0, 1 },
	{ 8, 13, "Смена номера телефона", " ", -1, 55, 1, 1, 300, 0, 1 },
	{ 8, 14, "Смена номера автомобиля", " ", -1, 55, 1, 1, 500, 0, 1 },
	{ 8, 15, "Слот для бизнеса", "Навсегда", -1, 100, 1, 1, 1000, 0, 1 },
	{ 8, 16, "Слот для дома", "Навсегда", -1, 103, 1, 1, 800, 0, 1 },
	{ 8, 17, "Vine Plus", "Услуга на 30 дней", -1, 55, 1, 1, 500, 0, 1 },
	{ 8, 18, "Военный билет", " ", -1, 149, 1, 1, 50, 0, 1 },
	

	// бонус. счёт
	{ 8, 21, "Смена игрового возраста", " ", -1, 55, 1, 1, 50, 0, 0 },
	{ 8, 22, "Смена игрового пола", " ", -1, 104, 1, 1, 50, 0, 0 },
	{ 8, 23, "Получить новую трудовую книжку", " ", -1, 55, 1, 1, 50, 0, 0 },
	{ 8, 24, "Лицензии", " ", -1, 55, 1, 1, 150, 0, 0 },
	{ 8, 25, "Навыки оружия", " ", -1, 55, 1, 1, 200, 0, 0 },
	{ 8, 26, "Гонки (/myrace)", " ", -1, 55, 1, 1, 300, 0, 0 },
	{ 8, 27, "Законопослушность", " ", -1, 102, 1, 1, 20, 0, 0 },
	{ 8, 28, "Вылечиться от болезней", " ", -1, 55, 1, 1, 50, 0, 0 },
	{ 8, 29, "Рабочие навыки", " ", -1, 55, 1, 1, 750, 0, 0 },
	{ 8, 30, "Военный билет", " ", -1, 149, 1, 1, 250, 0, 0 }
} ;

#define MAX_DISCOUNT 20
new donate_discount_id [ MAX_DISCOUNT ] = { -1, ... } ;
new donate_discount_model [ MAX_DISCOUNT ] ;
new donate_discount_percent [ MAX_DISCOUNT ] ;
new donate_discount_hierarchy [ MAX_DISCOUNT ] ;
new donate_discount_date [ MAX_DISCOUNT ] ;

//#include 									<custom/donate_packet>

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
	static const _donate_id [ ] = { 1, 2, 3, 3, 4 } ; // 3 vip, 4 adminka
	if ( _type == 1 )
	{
		for ( new i = 0 ; i < sizeof _donate_id ; i ++ )
		{
			new _random ;
			if ( _donate_id [ i ] == 3 ) _random = random ( 1 ) + 1 ;
			else _random = random ( 3 ) + 2 ;
			
			for ( new q = 0 ; q < _random ; q ++ )
			{
				for ( new d = 0 ; d < MAX_DISCOUNT ; d ++ )
				{
					if ( donate_discount_id [ d ] != -1 && donate_discount_date [ d ] > gettime ( ) ) continue ;
					
					new _count2 = 0 ;
					new _random2 ;
					if ( i == 0 ) _random2 = random ( sizeof donate_skins ) ;
					else if ( i == 1 ) _random2 = random ( sizeof donate_vehicles ) ;
					else if ( i == 2 ) _random2 = random ( sizeof donate_acs ) ;
					else if ( i == 3 ) _random2 = RandomEx ( 6, 8 ) ;
					else if ( i == 4 ) _random2 = RandomEx ( 0, 5 ) ;
					
					retry_random2:
					_count2 = 0 ;
					if ( i == 0 ) _random2 = random ( sizeof donate_skins ) ;
					else if ( i == 1 ) _random2 = random ( sizeof donate_vehicles ) ;
					else if ( i == 2 ) _random2 = random ( sizeof donate_acs ) ;
					else if ( i == 3 ) _random2 = RandomEx ( 6, 8 ) ;
					else if ( i == 4 ) _random2 = RandomEx ( 0, 5 ) ;
					for ( new h = 0 ; h < MAX_DISCOUNT ; h ++ )
					{
						if ( donate_discount_id [ h ] == _random2 && donate_discount_hierarchy [ h ] == _donate_id [ i ] )
						{
							goto retry_random2 ;
							break ;
						}
					}

					if ( i == 0 )
					{
						for ( new h = 0 ; h < sizeof donate_skins ; h ++ )
						{
							if ( _random2 != _count2 )
							{
								_count2 ++ ;
								continue ;
							}
							
							new bool: _need_insert = false ;
							if ( donate_discount_id [ d ] != -1 ) _need_insert = false ;
							else _need_insert = true ;
								
							donate_discount_id [ d ] = _random2 ;
							donate_discount_model [ d ] = donate_skins [ h ] [ ModelId ] ;
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
					else if ( i == 1 )
					{
						for ( new h = 0 ; h < sizeof donate_vehicles ; h ++ )
						{
							if ( _random2 != _count2 )
							{
								_count2 ++ ;
								continue ;
							}
							
							new bool: _need_insert = false ;
							if ( donate_discount_id [ d ] != -1 ) _need_insert = false ;
							else _need_insert = true ;
								
							donate_discount_id [ d ] = _random2 ;
							donate_discount_model [ d ] = donate_vehicles [ h ] [ ModelId ] ;
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
					else if ( i == 2 )
					{
						for ( new h = 0 ; h < sizeof donate_acs ; h ++ )
						{
							if ( _random2 != _count2 )
							{
								_count2 ++ ;
								continue ;
							}
							
							new bool: _need_insert = false ;
							if ( donate_discount_id [ d ] != -1 ) _need_insert = false ;
							else _need_insert = true ;
								
							donate_discount_id [ d ] = _random2 ;
							donate_discount_model [ d ] = donate_acs [ h ] [ ModelId ] ;
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
					else
					{
						for ( new h = 0 ; h < sizeof donate_services ; h ++ )
						{
							if ( _random2 != _count2 )
							{
								_count2 ++ ;
								continue ;
							}
							
							new bool: _need_insert = false ;
							if ( donate_discount_id [ d ] != -1 ) _need_insert = false ;
							else _need_insert = true ;
								
							donate_discount_id [ d ] = _random2 ;
							donate_discount_model [ d ] = donate_services [ h ] [ ModelId ] ;
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
			if ( random ( 3 ) == 1 ) i = RandomEx ( 3, 4 ) ;
			else i = RandomEx ( 0, 2 ) ;
			
			new _count2 = 0, _count3 = 0 ;
			new _random2 ;
			if ( i == 0 ) _random2 = random ( sizeof donate_skins ) ;
			else if ( i == 1 ) _random2 = random ( sizeof donate_vehicles ) ;
			else if ( i == 2 ) _random2 = random ( sizeof donate_acs ) ;
			else if ( i == 3 ) _random2 = RandomEx ( 6, 8 ) ;
			else if ( i == 4 ) _random2 = RandomEx ( 0, 5 ) ;

			retry_random3:
			_count2 = 0 ;
			if ( i == 0 ) _random2 = random ( sizeof donate_skins ) ;
			else if ( i == 1 ) _random2 = random ( sizeof donate_vehicles ) ;
			else if ( i == 2 ) _random2 = random ( sizeof donate_acs ) ;
			else if ( i == 3 ) _random2 = RandomEx ( 6, 8 ) ;
			else if ( i == 4 ) _random2 = RandomEx ( 0, 5 ) ;
			for ( new h = 0 ; h < MAX_DISCOUNT ; h ++ )
			{
				if ( donate_discount_id [ h ] == _random2 && donate_discount_hierarchy [ h ] == _donate_id [ i ] && _count3 < 5 )
				{
					_count3 ++ ;
					goto retry_random3 ;
					break ;
				}
			}

			if ( i == 0 )
			{
				for ( new h = 0 ; h < sizeof donate_skins ; h ++ )
				{
					if ( _random2 != _count2 )
					{
						_count2 ++ ;
						continue ;
					}
							
					new bool: _need_insert = false ;
					if ( donate_discount_id [ d ] != -1 ) _need_insert = false ;
					else _need_insert = true ;
								
					donate_discount_id [ d ] = _random2 ;
					donate_discount_model [ d ] = donate_skins [ h ] [ ModelId ] ;
					donate_discount_percent [ d ] = random ( 15 ) + 10 ;
					donate_discount_hierarchy [ d ] = _donate_id [ i ] ;
								
					new _random_days ;
					if ( _donate_id [ i ] == 3 ) _random_days = random ( 3 ) + 1 ;
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
			else if ( i == 1 )
			{
				for ( new h = 0 ; h < sizeof donate_vehicles ; h ++ )
				{
					if ( _random2 != _count2 )
					{
						_count2 ++ ;
						continue ;
					}
							
					new bool: _need_insert = false ;
					if ( donate_discount_id [ d ] != -1 ) _need_insert = false ;
					else _need_insert = true ;
								
					donate_discount_id [ d ] = _random2 ;
					donate_discount_model [ d ] = donate_vehicles [ h ] [ ModelId ] ;
					donate_discount_percent [ d ] = random ( 15 ) + 10 ;
					donate_discount_hierarchy [ d ] = _donate_id [ i ] ;
								
					new _random_days ;
					if ( _donate_id [ i ] == 3 ) _random_days = random ( 3 ) + 1 ;
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
			else if ( i == 2 )
			{
				for ( new h = 0 ; h < sizeof donate_acs ; h ++ )
				{
					if ( _random2 != _count2 )
					{
						_count2 ++ ;
						continue ;
					}
							
					new bool: _need_insert = false ;
					if ( donate_discount_id [ d ] != -1 ) _need_insert = false ;
					else _need_insert = true ;
								
					donate_discount_id [ d ] = _random2 ;
					donate_discount_model [ d ] = donate_acs [ h ] [ ModelId ] ;
					donate_discount_percent [ d ] = random ( 15 ) + 10 ;
					donate_discount_hierarchy [ d ] = _donate_id [ i ] ;
								
					new _random_days ;
					if ( _donate_id [ i ] == 3 ) _random_days = random ( 3 ) + 1 ;
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
			else
			{
				for ( new h = 0 ; h < sizeof donate_services ; h ++ )
				{
					if ( _random2 != _count2 )
					{
						_count2 ++ ;
						continue ;
					}
							
					new bool: _need_insert = false ;
					if ( donate_discount_id [ d ] != -1 ) _need_insert = false ;
					else _need_insert = true ;
								
					donate_discount_id [ d ] = _random2 ;
					donate_discount_model [ d ] = donate_services [ h ] [ ModelId ] ;
					donate_discount_percent [ d ] = random ( 15 ) + 10 ;
					donate_discount_hierarchy [ d ] = _donate_id [ i ] ;
								
					new _random_days ;
					if ( _donate_id [ i ] == 3 ) _random_days = random ( 3 ) + 1 ;
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
	if ( _hierarchy == 0 )
	{
		for ( new i = 0 ; i < sizeof donate_skins ; i ++ )
		{
			if ( donate_skins [ i ] [ getInternalID ] != _internal + 1 ) continue ;
			
			return i ;
		}
	}
	else if ( _hierarchy == 1 )
	{
		for ( new i = 0 ; i < sizeof donate_vehicles ; i ++ )
		{
			if ( donate_vehicles [ i ] [ getInternalID ] != _internal + 1 ) continue ;
			
			return i ;
		}
	}
	else if ( _hierarchy == 1 )
	{
		for ( new i = 0 ; i < sizeof donate_acs ; i ++ )
		{
			if ( donate_acs [ i ] [ getInternalID ] != _internal + 1 ) continue ;
			
			return i ;
		}
	}
	else
	{
		for ( new i = 0 ; i < sizeof donate_services ; i ++ )
		{
			if ( donate_services [ i ] [ getInternalID ] != _internal + 1 ) continue ;
			
			return i ;
		}
	}
	return 1 ;
}

stock donate_OnGameModeInit ( )
{
	format ( donate_cases_info [ CASE_FREE_ID ], 32, "u_free_count" ) ;
	format ( donate_cases_info [ CASE_BMW_ID ], 32, "u_bmw_count" ) ;
	format ( donate_cases_info [ CASE_MERCEDES_ID ], 32, "u_mercedes_count" ) ;
	format ( donate_cases_info [ CASE_MAJOR_ID ], 32, "u_major_count" ) ;
	format ( donate_cases_info [ CASE_LAMBO_ID ], 32, "u_lambo_count" ) ;
	format ( donate_cases_info [ CASE_BEZUMIE_HAOSA_ID ], 32, "u_bezumie_haosa_count" ) ;
	format ( donate_cases_info [ CASE_LEGENDS_SAND_ID ], 32, "u_legends_sand_count" ) ;

	mysql_tquery ( sql_connection, !"SELECT * FROM `donate_discount`", "donate_discount_loading" ) ;
	return 1 ;
}

stock saveUserDonateCase ( playerid, caseName [ ], caseCount )
{
	static const _str [ ] = "UPDATE users_case_count SET `%s` = %d WHERE u_id = %d LIMIT 1" ;
	new query_string [ sizeof _str + 32 + ( 9 * 2 ) ] ;
	format ( query_string, sizeof query_string, _str, caseName, caseCount, p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, query_string ) ;
	return true ;
}

callback: loadUserDonateCases ( playerid, init )
{
	if ( init )
	{
		static const _str [ ] = "SELECT * FROM users_case_count WHERE u_id = %d LIMIT 1" ;
		new query_string [ sizeof _str + 9 ] ;
		format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, query_string, "loadUserDonateCases", "ii", playerid, 0 ) ;
	}
	else
	{
		new rows = cache_num_rows ( sql_connection ) ;
		if ( ! rows )
		{
			for ( new i = 0 ; i < CASE_MAX_ID ; i ++ ) users_donate_cases [ playerid ] [ i ] = 0 ;

			static const _str [ ] = "INSERT INTO users_case_count (u_id) VALUES ('%d')" ;
			new query_string [ sizeof _str + ( 3 * 9 ) ] ;
			format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, query_string ) ;
			return false ;
		}

		users_donate_cases [ playerid ] [ CASE_FREE_ID ] = cache_get_field_content_int ( 0, "u_free_count", sql_connection ) ;
		users_donate_cases [ playerid ] [ CASE_BMW_ID ] = cache_get_field_content_int ( 0, "u_bmw_count", sql_connection ) ;
		users_donate_cases [ playerid ] [ CASE_MERCEDES_ID ] = cache_get_field_content_int ( 0, "u_mercedes_count", sql_connection ) ;
		users_donate_cases [ playerid ] [ CASE_MAJOR_ID ] = cache_get_field_content_int ( 0, "u_major_count", sql_connection ) ;
		users_donate_cases [ playerid ] [ CASE_LAMBO_ID ] = cache_get_field_content_int ( 0, "u_lambo_count", sql_connection ) ;
		users_donate_cases [ playerid ] [ CASE_BEZUMIE_HAOSA_ID ] = cache_get_field_content_int ( 0, "u_bezumie_haosa_count", sql_connection ) ;
		users_donate_cases [ playerid ] [ CASE_LEGENDS_SAND_ID ] = cache_get_field_content_int ( 0, "u_legends_sand_count", sql_connection ) ;
	}
	return true ;
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

stock show_mobile_donate ( playerid )
{
	setUpdateBalance ( playerid, p_info [ playerid ] [ donate ] ) ;
	toggle_controlable ( playerid, false ) ;

	if ( ! users_education [ playerid ] [ EDUCATION_DONATE ] )
	{
		show_window_monologue (
			playerid,
			5,
			"Привет, друг! Ты открыл донат-меню. \
			Нажми на иконку валюты в правом верхнем углу и ты увидишь весь список.",
			"Местный",
			"Понял"
		) ;

		save_user_education ( playerid, EDUCATION_DONATE ) ;
	}
	return 1 ;
}

stock show_donate_packet ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 ) // уточнения курса
	{
		setExchangeRate ( playerid ) ;
	}
	else if ( actionId == 1 ) // обмен валюты
	{
		new Node: json = JSON_Object ( ) ;
		JSON_Parse ( data, json ) ;

		new _type, _sum, _payment ;
		JSON_GetInt ( json, "type", _type ) ;
		JSON_GetInt ( json, "sum", _sum ) ;

		if ( _type == 0 ) _payment = _sum ;
		else if ( _type == 1 ) _payment = convertion_fam_price * _sum ;
		if ( ! get_player_donate ( playerid, _payment, 2 ) )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		if ( _type == 0 )
		{
			_payment = _sum * convertion_price ;
			give_money ( playerid, _payment ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _payment, "конвертация валюты" ) ;
			set_player_donate ( playerid, _sum, 2 ) ;
		}
		else if ( _type == 1 )
		{
			_payment = convertion_fam_price * _sum ;
			give_inventory (
				playerid,
				ITEM_FAMILY_TALON,
				_sum,
				0,
				"",
				"",
				NUMBERPLATE_TYPE_NONE,
				0,
				-1
			) ;
			set_player_donate ( playerid, _payment, 2 ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _payment, "конвертация "family_title"" ) ;
		}

		setUpdateBalance ( playerid, p_info [ playerid ] [ donate ] ) ;
		send_check_cinfo ( playerid, "Вы успешно конвертировали валюту.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
	}
	else if ( actionId == 2 ) // skins menu
	{
		setAddSkins ( playerid ) ;
	}
	else if ( actionId == 3 ) // примерка скина
	{
		new _position = strval ( data ) ;
		show_for_timeskin ( playerid, donate_skins [ _position ] [ ModelId ] ) ;
		
		toggle_controlable ( playerid, true ) ;
		onServerDestroy ( playerid, UI_DONATE_MENU ) ;
	}
	else if ( actionId == 4 ) // buy skin
	{
		new _position = strval ( data ),
			_price = donate_skins [ _position ] [ Cost ],
			_model = donate_skins [ _position ] [ ModelId ] ;
		
		global_string [ 0 ] = EOS ;
		format ( global_string, 356, "\
			{"#cWH"}Название: {"#cOR"}%s\n\
			{"#cWH"}Стоимость: {"#cGN"}%s "donate_title"\n\
			{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
			{"#cGRDialog"}* Вы действительно хотите приобрести?", item_name ( _model ), GetPlayerCashValueToSmile ( _price ), get_model_count ( _model ) ) ;
				
		new header_string [ 64 ] ;
		format ( header_string, sizeof header_string, "{"#cBHD"}Покупка {"#cWH"}%s", item_name ( _model ) ) ;
		show_dialog ( playerid, d_donate_buy_skins, DIALOG_STYLE_MSGBOX, header_string, global_string, "Купить", "Отмена" ) ;

		set_player_use_listitem ( playerid, _position ) ;
	}
	else if ( actionId == 5 ) // cars menu
	{
		setAddCars ( playerid ) ;
	}
	else if ( actionId == 6 ) // test drive
	{
		new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
		if ( ! _b_id || b_info [ _b_id - 1 ] [ b_type ] != bizz_type_autoshop )
		{
			send_check_cinfo ( playerid, "Вы должны находиться в автосалоне!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		onServerDestroy ( playerid, UI_DONATE_MENU ) ;

		new _position = strval ( data ),
			_model = donate_vehicles [ _position ] [ ModelId ],
			ts_spawn_slot = random ( 5 ),
			classId = GetPlayerAutoSalonData ( playerid, PAS_SELECTED_AUTO_SALON ) ;

		set_world ( playerid, 0 ) ;
		set_interior ( playerid, 0 ) ;

		p_t_info [ playerid ] [ test_drive ] = CreateVehicle ( _model,
														t_shop_respawn [ classId - 1 ] [ ts_spawn_slot ] [ 0 ],
														t_shop_respawn [ classId - 1 ] [ ts_spawn_slot ] [ 1 ],
														t_shop_respawn [ classId - 1 ] [ ts_spawn_slot ] [ 2 ],
														t_shop_respawn [ classId - 1 ] [ ts_spawn_slot ] [ 3 ],
														0, 0, -1 ) ;

		new veh_id = p_t_info [ playerid ] [ test_drive ] ;
		PutPlayerInVehicle ( playerid, veh_id, 0 ) ;
		veh_info [ veh_id - 1 ] [ v_vehicle ] = veh_id ;
		veh_info [ veh_id - 1 ] [ v_fuel ] = 60.0 ;

		new engine, lights, alarm, doors, bonnet, boot, objective ;
		GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( veh_id, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective ) ;

		toggle_engine ( playerid, veh_id ) ;
		toggle_lights ( playerid, veh_id ) ;

		veh_info [ veh_id - 1 ] [ v_locked ] = false ;
		toggle_locked ( playerid, veh_id ) ;

		if ( IsValidDynamic3DTextLabel ( veh_info [ veh_id - 1 ] [ v_label ] ) )
		{
			DestroyDynamic3DTextLabel ( veh_info [ veh_id - 1 ] [ v_label ] ) ;
			veh_info [ veh_id - 1 ] [ v_label ] = Text3D:INVALID_3DTEXT_ID ;
		}

		veh_info [ veh_id - 1 ] [ v_test_drive ] = true ;
		veh_info [ veh_id - 1 ] [ v_label ] = CreateDynamic3DTextLabel("** ТЕСТ-ДРАЙВ **", col_blue, 0.0, 0.0, 1.3, 10.0, INVALID_PLAYER_ID, veh_id, 1);
		SetVehicleNumberPlate ( veh_info [ veh_id - 1 ] [ v_vehicle ], "Test-Drive" ) ;
	}
	else if ( actionId == 7 ) // buy car
	{
		new _position = strval ( data ),
			_price = donate_vehicles [ _position ] [ Cost ],
			_model = donate_vehicles [ _position ] [ ModelId ] ;
		
		global_string [ 0 ] = EOS ;
		format ( global_string, 356, "\
			{"#cWH"}Название: {"#cOR"}%s\n\
			{"#cWH"}Стоимость: {"#cGN"}%s "donate_title"\n\
			{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
			{"#cGRDialog"}* Вы действительно хотите приобрести?", item_name ( _model ), GetPlayerCashValueToSmile ( _price ), get_model_count ( _model ) ) ;
				
		new header_string [ 64 ] ;
		format ( header_string, sizeof header_string, "{"#cBHD"}Покупка {"#cWH"}%s", item_name ( _model ) ) ;
		show_dialog ( playerid, d_donate_buy_vehicles, DIALOG_STYLE_MSGBOX, header_string, global_string, "Купить", "Отмена" ) ;

		set_player_use_listitem ( playerid, _position ) ;
	}
	else if ( actionId == 8 ) // vip menu
	{
		showDonateVip ( playerid ) ;
	}
	else if ( actionId == 9 ) // buy vip
	{
		new _position = strval ( data ) ;
		if ( _position == 0 ) show_donate_vip ( playerid, 0, donateVip [ 0 ] [ VIP_PRICE ] ) ;
		else if ( _position == 1 ) show_donate_vip ( playerid, 1, donateVip [ 1 ] [ VIP_PRICE ] ) ;
		else if ( _position == 2 ) show_donate_vip ( playerid, 2, donateVip [ 2 ] [ VIP_PRICE ] ) ;
	}
	else if ( actionId == 10 ) // service page
	{
		setAddServices ( playerid ) ;
	}
	else if ( actionId == 11 || actionId == 12 ) // service buy
	{
		new _int = strval ( data ), _price, _donateType ;

		_donateType = donate_services [ _int ] [ ItemBG ] ;
		_price = donate_services [ _int ] [ Cost ] ;
		_int = donate_services [ _int ] [ getInternalID ] ;
		if ( ! get_player_donate ( playerid, _price, _donateType + 1 ) )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
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
		else if ( _int == 10 ) show_dialog ( playerid, d_donate_rename, DIALOG_STYLE_INPUT, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Смена Ник-Нейма:\n\n{"#cGRDialog"}* Цена: {"#cGN"}100 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите сменить Ваш \"{"#cWH"}Ник-Нейм{"#cGRDialog"}\".","Принять", "Назад");
		else if ( _int == 11 ) show_dialog ( playerid, d_donate_unwarn, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Снять предупреждение:\n\n{"#cGRDialog"}* Цена: {"#cGN"}200 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите снять \"{"#cWH"}Предупреждение{"#cGRDialog"}\"?","Принять", "Назад");
		else if ( _int == 12 ) show_dialog ( playerid, d_donate_maxveh, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", "{"#cGRDialog"}- {"#cWH"}Дополнительный слот для машины:\n\n{"#cGRDialog"}- {"#cWH"}Даёт Вам право иметь ещё одним транспортным средством.\n\n{"#cGRDialog"}* Цена: {"#cGN"}600 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Дополнительный слот для автомобиля{"#cGRDialog"}\"?","Принять", "Назад");
		else if ( _int == 13 )
		{
			show_dialog ( playerid, d_donate_phone_list, DIALOG_STYLE_INPUT, "{"#cBHD"}Донат услуги", "\
			{"#cGRDialog"}- {"#cWH"}Смена номера телефона:\n\n\
			{"#cGRDialog"}* Цена на на 4-значный номер телефона: {"#cGN"}400 "donate_title"{"#cGRDialog"}.\n\
			{"#cGRDialog"}* Цена на на 5-значный номер телефона: {"#cGN"}300 "donate_title"{"#cGRDialog"}.\n\n\
			{"#cGRDialog"}* Введите номер телефона, который желаете приобрести:","Принять", "Назад" ) ;
		}
		else if ( _int == 14 )
		{
			show_dialog ( playerid, d_donate_number, DIALOG_STYLE_INPUT, "{"#cBHD"}Донат услуги","\
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
			show_dialog ( playerid, d_donate_biz, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", "\
			{"#cGRDialog"}- {"#cWH"}Слот для бизнеса:\n\n\
			{"#cGRDialog"}- {"#cWH"}Вы получите дополнительный слот для бизнеса навсегда\n\n\
			{"#cGRDialog"}* Цена: {"#cGN"}1000 "donate_title"{"#cGRDialog"}.\n\
			{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Слот для бизнеса{"#cGRDialog"}\"?", "Принять", "Назад" ) ;
		}
		else if ( _int == 16 )
		{
			show_dialog ( playerid, d_donate_house, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", "\
			{"#cGRDialog"}- {"#cWH"}Слот для дома:\n\n\
			{"#cGRDialog"}- {"#cWH"}Вы получите дополнительный слот для дома навсегда\n\n\
			{"#cGRDialog"}* Цена: {"#cGN"}800 "donate_title"{"#cGRDialog"}.\n\
			{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Слот для дома{"#cGRDialog"}\"?", "Принять", "Назад" ) ;
		}
		else if ( _int == 17 )
		{
			show_dialog ( playerid, d_donate_crime, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", "\
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
			show_dialog ( playerid, d_donate_bilet, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", "\
			{"#cGRDialog"}- {"#cWH"}Военный билет:\n\n\
			{"#cGRDialog"}- {"#cWH"}Вы получите военный билет и сможете вступить в гос. структуры\n\n\
			{"#cGRDialog"}* Цена: {"#cGN"}50 "donate_title"{"#cGRDialog"}.\n\
			{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Военный билет{"#cGRDialog"}\"?", "Принять", "Назад" ) ;
		}
		
		else if ( _int == 21 )
		{
			show_dialog ( playerid, d_donate_age, DIALOG_STYLE_INPUT, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Смена возраста:\n\n{"#cGRDialog"}* Цена: {"#cGN"}50 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите сменить Ваш \"{"#cWH"}Возраст{"#cGRDialog"}\"?","Принять", "Назад");
		}
		else if ( _int == 22 )
		{
			show_dialog ( playerid, d_donate_sex, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Смена пола:\n\n{"#cGRDialog"}* Цена: {"#cGN"}50 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите сменить Ваш \"{"#cWH"}Пол{"#cGRDialog"}\"?","Принять", "Назад");
		}
		else if ( _int == 23 )
		{
			show_dialog ( playerid, d_donate_jobinfo, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Получить новую трудовую книжку:\n\n{"#cGRDialog"}- {"#cWH"}Если Вы состояли в незаконных вооружённых формированиях и Вас не берут на работу\n{"#cWH"}  в государственные службы или в Радиоцентры? Вы можете поменять трудовую книжку.\n\n{"#cGRDialog"}* Цена: {"#cGN"}50 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Новую трудовую книжку{"#cGRDialog"}\"?","Принять", "Назад");
		}
		else if ( _int == 24 )
		{
			show_dialog ( playerid, d_donate_licenses, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
			{"#cGRDialog"}- {"#cWH"}Лицензии:\n\n\
			{"#cGRDialog"}Лицензии включают в себя:\n\
			\t{"#cGRDialog"}- {"#cWH"}Лицензия на вождение.\n\
			\t{"#cGRDialog"}- {"#cWH"}Лицензия на воздушный транспорт.\n\
			\t{"#cGRDialog"}- {"#cWH"}Лицензия на судовождение.\n\
			\t{"#cGRDialog"}- {"#cWH"}Лицензия на право ношения оружия.\n\n\
			{"#cGRDialog"}* Цена: {"#cGN"}150 "donate_title"{"#cGRDialog"}.\n\
			{"#cGRDialog"}* Вы действительно хотите приобрести \"{"#cWH"}Комплект лицензий{"#cGRDialog"}\"?","Принять", "Назад");
		}
		else if ( _int == 25 )
		{
			show_dialog ( playerid, d_donate_skills, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
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
		else if ( _int == 26 )
		{
			show_dialog ( playerid, d_donate_race, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Создание гонок:\n\n{"#cGRDialog"}- {"#cWH"}Вы сможете создавать свои, уникальные, трассы. (/my_race)\n\n{"#cGRDialog"}* Цена: {"#cGN"}300 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}доступ к созданию гонок{"#cGRDialog"}\"?","Принять", "Назад");
		}
		else if ( _int == 27 )
		{
			show_dialog ( playerid, d_donate_law, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Законопослушность:\n\n{"#cGRDialog"}- {"#cWH"}Вы повысите свою законопослушность на 10 пунктов.\n\n{"#cGRDialog"}* Цена: {"#cGN"}20 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}законопослушность{"#cGRDialog"}\"?","Принять", "Назад");
		}
		else if ( _int == 28 )
		{
			show_dialog ( playerid, d_donate_heal, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Лечение от болезней:\n\n{"#cGRDialog"}- {"#cWH"}Все ваши болезни обнулятся.\n\n{"#cGRDialog"}* Цена: {"#cGN"}50 "donate_title"{"#cGRDialog"}.\n{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}лечение от болезней{"#cGRDialog"}\"?","Принять", "Назад");
		}
		else if ( _int == 29 )
		{
			show_dialog ( playerid, d_donate_job, DIALOG_STYLE_LIST, "{"#cBHD"}Донат услуги","{"#cGRDialog"}- {"#cWH"}Дальнобойщик\n{"#cGRDialog"}- {"#cWH"}Таксист\n{"#cGRDialog"}- {"#cWH"}Механик\n{"#cGRDialog"}- {"#cWH"}Водитель автобуса\n{"#cGRDialog"}- {"#cWH"}Автоугонщик\n{"#cGRDialog"}* Цена: {"#cGN"}100 "donate_title"","Принять", "Назад");
		}
		else if ( _int == 30 )
		{
			show_dialog ( playerid, d_donate_bilet1, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", "\
			{"#cGRDialog"}- {"#cWH"}Военный билет:\n\n\
			{"#cGRDialog"}- {"#cWH"}Вы получите военный билет и сможете вступить в гос. структуры\n\n\
			{"#cGRDialog"}* Цена: {"#cGN"}250 "donate_title"{"#cGRDialog"}.\n\
			{"#cGRDialog"}* Вы действительно хотите получить \"{"#cWH"}Военный билет{"#cGRDialog"}\"?", "Принять", "Назад" ) ;
		}
	}
	else if ( actionId == 13 ) // stocks page
	{
		setAddActions ( playerid ) ;
	}
	else if ( actionId == 14 ) // buy stocks
	{
		new _position = strval ( data ),
			_hierarchy = donate_discount_hierarchy [ _position ],
			_discount = find_donate ( _hierarchy, donate_discount_id [ _position ] ),
			_type,
			_price ;
				
		if ( _hierarchy == 1 )
		{
			_type = 0 ;
			_price = donate_skins [ _discount ] [ Cost ] - floatround ( ( donate_skins [ _discount ] [ Cost ] * donate_discount_percent [ _position ] ) / 100 ) ;
		}
		else if ( _hierarchy == 2 )
		{
			_type = 1 ;
			_price = donate_vehicles [ _discount ] [ Cost ] - floatround ( ( donate_vehicles [ _discount ] [ Cost ] * donate_discount_percent [ _position ] ) / 100 ) ;
		}
		else if ( _hierarchy == 3 )
		{
			_type = 2 ;
			_price = donate_acs [ _discount ] [ Cost ] - floatround ( ( donate_acs [ _discount ] [ Cost ] * donate_discount_percent [ _position ] ) / 100 ) ;
		}
		else
		{
			_type = 3 ;
			_price = donate_services [ _discount ] [ Cost ] - floatround ( ( donate_services [ _discount ] [ Cost ] * donate_discount_percent [ _position ] ) / 100 ) ;
		}

		if ( ! get_player_donate ( playerid, _price, 2 ) )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
				
		if ( _type == 0 )
		{
			new _model = donate_skins [ _discount ] [ ModelId ] ;
			give_inventory ( playerid, _model, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			
			set_player_donate ( playerid, _price, 2 ) ;
			
			new line_string [ 64 ] ;
			format ( line_string, sizeof line_string, "(donate) покупка %s", item_name ( _model ) ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _model ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
	
			setUpdateBalance ( playerid, p_info [ playerid ] [ donate ] ) ;
		}
		else if ( _type == 1 )
		{
			new _model = donate_vehicles [ _discount ] [ ModelId ] ;
			give_inventory ( playerid, _model, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			
			set_player_donate ( playerid, _price, 2 ) ;
			
			new line_string [ 64 ] ;
			format ( line_string, sizeof line_string, "(donate) покупка %s", item_name ( _model ) ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _model ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
	
			setUpdateBalance ( playerid, p_info [ playerid ] [ donate ] ) ;
		}
		else if ( _type == 2 )
		{
			new _model = donate_acs [ _discount ] [ ModelId ] ;
			give_inventory ( playerid, _model, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			
			set_player_donate ( playerid, _price, 2 ) ;
			
			new line_string [ 64 ] ;
			format ( line_string, sizeof line_string, "(donate) покупка %s", item_name ( _model ) ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
			
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _model ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
	
			setUpdateBalance ( playerid, p_info [ playerid ] [ donate ] ) ;
		}
		else
		{
			if ( donate_services [ _discount ] [ getInternalID ] == 1 ) show_c_donate_vip ( playerid, 1, _price ) ;
			else if ( donate_services [ _discount ] [ getInternalID ] == 2 ) show_c_donate_vip ( playerid, 2, _price ) ;
			else if ( donate_services [ _discount ] [ getInternalID ] == 3 ) show_c_donate_vip ( playerid, 3, _price ) ;
			else if ( donate_services [ _discount ] [ getInternalID ] == 4 ) show_c_donate_vip ( playerid, 4, _price ) ;
			else if ( donate_services [ _discount ] [ getInternalID ] == 5 ) show_c_donate_vip ( playerid, 5, _price ) ;
			else if ( donate_services [ _discount ] [ getInternalID ] == 6 ) show_c_donate_vip ( playerid, 6, _price ) ;
			else if ( donate_services [ _discount ] [ getInternalID ] == 7 ) show_donate_vip ( playerid, 0, _price ) ;
			else if ( donate_services [ _discount ] [ getInternalID ] == 8 ) show_donate_vip ( playerid, 1, _price ) ;
			else if ( donate_services [ _discount ] [ getInternalID ] == 9 ) show_donate_vip ( playerid, 2, _price ) ;
		}
	}
	else if ( actionId == 15 ) // case page
	{
		setAddCases ( playerid ) ;
	}
	else if ( actionId == 16 ) // case id
	{
		new idx = strval ( data ) ;
		setCasesItems ( playerid, idx ) ;
		set_player_use_listitem ( playerid, donate_cases [ idx ] [ ItemBG ] ) ;

		new _price = donate_cases [ idx ] [ Cost ] * 1 ;
		if ( ! get_player_donate ( playerid, _price, 2 ) ) onServerSendData ( playerid, UI_DONATE_MENU, 16, "true" ) ;
		else onServerSendData ( playerid, UI_DONATE_MENU, 16, "false" ) ;
	}
	else if ( actionId == 17 ) // case open
	{
		new idx = strval ( data ),
			caseId = get_player_use_listitem ( playerid ),
			casePrice = donate_cases [ caseId ] [ Cost ] * idx ;

		if ( caseId == CASE_FREE_ID )
		{
			if ( users_donate_cases [ playerid ] [ caseId ] - idx < 0 )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно бесплатных кейсов!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			users_donate_cases [ playerid ] [ caseId ] -= idx ;
			saveUserDonateCase ( playerid, donate_cases_info [ caseId ], users_donate_cases [ playerid ] [ caseId ] ) ;
		}
		else
		{
			if ( users_donate_cases [ playerid ] [ caseId ] > 0 )
			{
				if ( users_donate_cases [ playerid ] [ caseId ] - idx < 0 )
				{
					new countPayCase = idx - users_donate_cases [ playerid ] [ caseId ] ;
					casePrice = donate_cases [ caseId ] [ Cost ] * countPayCase ;
					if ( ! get_player_donate ( playerid, casePrice, 2 ) )
					{
						send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}

					set_player_donate ( playerid, casePrice, 2 ) ;
				
					new line_string [ 64 ] ;
					format ( line_string, sizeof line_string, "(donate) открытие кейса %s (%d шт.)", donate_cases [ caseId ] [ d_Name ], idx ) ;
					insert_donate_log ( playerid, INVALID_PLAYER_ID, casePrice, p_info [ playerid ] [ donate ], line_string ) ;
				}

				users_donate_cases [ playerid ] [ caseId ] -= idx ;
				saveUserDonateCase ( playerid, donate_cases_info [ caseId ], users_donate_cases [ playerid ] [ caseId ] ) ;
			}
			else
			{
				if ( ! get_player_donate ( playerid, casePrice, 2 ) )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}

				set_player_donate ( playerid, casePrice, 2 ) ;
			
				new line_string [ 64 ] ;
				format ( line_string, sizeof line_string, "(donate) открытие кейса %s (%d шт.)", donate_cases [ caseId ] [ d_Name ], idx ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, casePrice, p_info [ playerid ] [ donate ], line_string ) ;
			}
		}

		playerMultiplyItem [ playerid ] = playerMultiplyClear ;
		playerDonateSellItem [ playerid ] = 0 ;

		setCasesResult ( playerid, idx ) ;
		setUpdateBalance ( playerid, p_info [ playerid ] [ donate ] ) ;
	}
	else if ( actionId == 18 ) // закрытие доната
	{
		//closeDonate ( playerid ) ;
	}
	else if ( actionId == 19 ) // buy acs
	{
		new _position = strval ( data ),
			_price = donate_acs [ _position ] [ Cost ],
			_model = donate_acs [ _position ] [ ModelId ] ;
		
		global_string [ 0 ] = EOS ;
		format ( global_string, 356, "\
			{"#cWH"}Название: {"#cOR"}%s\n\
			{"#cWH"}Стоимость: {"#cGN"}%s "donate_title"\n\
			{"#cWH"}Количество данного предмета на сервере: {"#cWV"}%d шт.\n\n\
			{"#cGRDialog"}* Вы действительно хотите приобрести?", item_name ( _model ), GetPlayerCashValueToSmile ( _price ), get_model_count ( _model ) ) ;
				
		new header_string [ 64 ] ;
		format ( header_string, sizeof header_string, "{"#cBHD"}Покупка {"#cWH"}%s", item_name ( _model ) ) ;
		show_dialog ( playerid, d_donate_buy_acs, DIALOG_STYLE_MSGBOX, header_string, global_string, "Купить", "Отмена" ) ;

		set_player_use_listitem ( playerid, _position ) ;
	}
	else if ( actionId == 20 ) // open acs
	{
		setAddAcs ( playerid ) ;
	}
	else if ( actionId == 21 ) // use storage item
	{
		static const _str [ ] = "SELECT * FROM users_case_storage WHERE id = %d LIMIT 1" ;
		new query_string [ sizeof _str + 9 ] ;
		format ( query_string, sizeof query_string, _str, strval ( data ) ) ;
		mysql_tquery ( sql_connection, query_string, "loadUsersCaseStorage", "ii", playerid, strval ( data ) ) ;
	}
	else if ( actionId == 22 ) // pressed button storage
	{
		new idx = strval ( data ) ;
		if ( idx == 0 )
		{
			if ( page_count [ playerid ] > 0 )
			{
				onServerSendData ( playerid, UI_DONATE_MENU, 17, "" ) ;

				page_count [ playerid ] -= 1 ;
				PlayerDonateCaseStorage ( playerid, page_count [ playerid ], 1 ) ;

				new pageCount = floatround ( page_rows [ playerid ] / 12 ) + 1 ;
				new Node: node = JSON_Object (
					"currentPage",		JSON_Int ( page_count [ playerid ] + 1 ),
					"maxPage",			JSON_Int ( pageCount )
				) ;

				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;
				onServerSendData ( playerid, UI_DONATE_MENU, 15, global_string ) ;
			}
		}
		else if ( idx == 1 )
		{
			new pageCount = floatround ( page_rows [ playerid ] / 12 ) + 1 ;
			if ( page_count [ playerid ] < pageCount )
			{
				onServerSendData ( playerid, UI_DONATE_MENU, 17, "" ) ;

				page_count [ playerid ] += 1 ;
				PlayerDonateCaseStorage ( playerid, page_count [ playerid ], 1 ) ;
			
				new Node: node = JSON_Object (
					"currentPage",		JSON_Int ( page_count [ playerid ] + 1 ),
					"maxPage",			JSON_Int ( pageCount )
				) ;

				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;
				onServerSendData ( playerid, UI_DONATE_MENU, 15, global_string ) ;
			}
		}
	}
	else if ( actionId == 23 ) // open case storage
	{
		PlayerDonateCaseStorageCount ( playerid, 1 ) ;
		PlayerDonateCaseStorage ( playerid, 0, 1 ) ;
	}
	else if ( actionId == 24 ) // case check donate
	{
		new _position = strval ( data ) ;

		new _caseId = get_player_use_listitem ( playerid ),
			_price = donate_cases [ _caseId ] [ Cost ] * _position ;
		
		if ( ! get_player_donate ( playerid, _price, 2 ) ) onServerSendData ( playerid, UI_DONATE_MENU, 16, "true" ) ;
		else onServerSendData ( playerid, UI_DONATE_MENU, 16, "false" ) ;
	}
	else if ( actionId == 25 ) // add storage item
	{
		new caseId = get_player_use_listitem ( playerid ) ;
		for ( new i = 0 ; i < 10 ; i ++ )
		{
			if ( ! playerMultiplyItem [ playerid ] [ i ] ) continue ;
			insertPlayerDonateCaseStorage ( playerid, caseId, playerMultiplyItem [ playerid ] [ i ] ) ;
		}
		playerMultiplyItem [ playerid ] = playerMultiplyClear ;
		playerDonateSellItem [ playerid ] = 0 ;
	}
	else if ( actionId == 26 ) // sell storage item
	{
		if ( playerDonateSellItem [ playerid ] > 0 )
		{
			give_player_donate ( playerid, playerDonateSellItem [ playerid ], 2 ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, playerDonateSellItem [ playerid ], p_info [ playerid ] [ donate ], "(donate) продажа предметов рулетки" ) ;
		}
		
		playerMultiplyItem [ playerid ] = playerMultiplyClear ;
		playerDonateSellItem [ playerid ] = 0 ;

		setUpdateBalance ( playerid, p_info [ playerid ] [ donate ] ) ;
	}
	return 1 ;
}

stock packetDonateDestroy ( playerid )
{
	toggle_controlable ( playerid, true ) ;
	return true ;
}

stock getDonateModelPrice ( typeId, modelId )
{
	new price = 0 ;
	switch ( typeId )
	{
		case RENDER_TYPE_OBJECT:
		{
			for ( new i = 0 ; i < sizeof donate_acs ; i ++ )
			{
				if ( donate_acs [ i ] [ ModelId ] != modelId ) continue ;

				price = donate_acs [ i ] [ Cost ] ;
				break ;
			}
		}
		case RENDER_TYPE_VEHICLE:
		{
			for ( new i = 0 ; i < sizeof donate_vehicles ; i ++ )
			{
				if ( donate_vehicles [ i ] [ ModelId ] != modelId ) continue ;

				price = donate_vehicles [ i ] [ Cost ] ;
				break ;
			}
		}
		case RENDER_TYPE_SKINS:
		{
			for ( new i = 0 ; i < sizeof donate_skins ; i ++ )
			{
				if ( donate_skins [ i ] [ ModelId ] != modelId ) continue ;

				price = donate_skins [ i ] [ Cost ] ;
				break ;
			}
		}
	}
	price = floatround ( price / 10 ) ;
	return price ;
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

		show_dialog ( playerid, d_c_donate_vipgold, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", global_string, "Принять", "Назад" ) ;
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

		show_dialog ( playerid, d_c_donate_vipgold, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", global_string, "Принять", "Назад" ) ;
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
					
		show_dialog ( playerid, d_c_donate_vipgold, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги", global_string, "Принять", "Назад" ) ;
	}
	
	set_player_use_listitem ( playerid, _vip_id ) ;
	sell_price [ playerid ] = _price ;
	return 1 ;
}

stock show_c_donate_vip ( playerid, _admin_id, _price )
{
	new sql_string [ 200 ] ;
	format ( sql_string, sizeof sql_string, "INSERT INTO `users_admins`(`u_a_id`, `u_a_name`, `u_a_level`, `u_a_issued`, `u_a_dostup`) VALUES ('%d','%s','%d', NOW(), '0|0|0|0|0|0')",
	p_info [ playerid ] [ id ], p_info [ playerid ] [ name ], _admin_id ) ;
	mysql_tquery ( sql_connection, sql_string ) ;

	for ( new i = 0 ; i < 6 ; i ++ )
		admin_info [ playerid ] [ dostup ] [ i ] = 0 ;
			    	
    admin_info [ playerid ] [ player_admin ] = true ;
    update_int_sql ( playerid, "u_admin", 1 ) ;

	set_player_donate ( playerid, _price, 2 ) ;
	insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], "(donate) admin" ) ;

	mysql_tquery ( sql_connection, "SELECT `u_a_id`, `u_a_name` FROM `users_admins` WHERE `u_a_level` > '6'", "callback_buy_admin", "i", playerid ) ;

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
		case d_donate_buy_skins:
		{
			if ( ! response ) return 1 ;

			new _position = get_player_use_listitem ( playerid ), _price = donate_skins [ _position ] [ Cost ] ;
			if ( ! get_player_donate ( playerid, _price, 2 ) )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			new _model = donate_skins [ _position ] [ ModelId ] ;
			give_inventory ( playerid, _model, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;

			set_player_donate ( playerid, _price, 2 ) ;

			new line_string [ 64 ] ;
			format ( line_string, sizeof line_string, "(donate) покупка %s", item_name ( _model ) ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
				
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _model ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		
			setUpdateBalance ( playerid, p_info [ playerid ] [ donate ] ) ;
			return 1 ;
		}
		case d_donate_buy_vehicles:
		{
			if ( ! response ) return 1 ;

			new _position = get_player_use_listitem ( playerid ), _price = donate_vehicles [ _position ] [ Cost ] ;
			if ( ! get_player_donate ( playerid, _price, 2 ) )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			new _model = donate_vehicles [ _position ] [ ModelId ] ;
			give_inventory ( playerid, _model, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
			set_player_donate ( playerid, _price, 2 ) ;
				
			new line_string [ 64 ] ;
			format ( line_string, sizeof line_string, "(donate) покупка %s", item_name ( _model ) ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
				
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _model ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		
			setUpdateBalance ( playerid, p_info [ playerid ] [ donate ] ) ;
			return 1 ;
		}
		case d_donate_buy_acs:
		{
			if ( ! response ) return 1 ;

			new _position = get_player_use_listitem ( playerid ), _price = donate_acs [ _position ] [ Cost ] ;
			if ( ! get_player_donate ( playerid, _price, 2 ) )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
					
			new _model = donate_acs [ _position ] [ ModelId ] ;
			give_inventory ( playerid, _model, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
			set_player_donate ( playerid, _price, 2 ) ;
				
			new line_string [ 64 ] ;
			format ( line_string, sizeof line_string, "(donate) покупка %s", item_name ( _model ) ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
				
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _model ) ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		
			setUpdateBalance ( playerid, p_info [ playerid ] [ donate ] ) ;
			return 1 ;
		}
		case d_donate_casket:
		{
			if ( ! response ) return 1 ;
			
			new _param3 = GetPVarInt ( playerid, "donate_id" ), _price = donate_services [ _param3 ] [ Cost ], _int = donate_services [ _param3 ] [ getInternalID ] ;
			DeletePVar ( playerid, "donate_id" ) ;
			if ( ! get_player_donate ( playerid, _price, 2 ) )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
				
			set_player_donate ( playerid, _price, 2 ) ;
				
			new line_string [ 64 ] ;
			format ( line_string, sizeof line_string, "(donate) покупка roulette #%d", _int ) ;
			insert_donate_log ( playerid, INVALID_PLAYER_ID, _price, p_info [ playerid ] [ donate ], line_string ) ;
			
			if ( _int == 1 ) give_inventory ( playerid, 2045, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			else if ( _int == 2 ) give_inventory ( playerid, 2055, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			else if ( _int == 3 ) give_inventory ( playerid, 2125, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			else if ( _int == 4 ) give_inventory ( playerid, 2190, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			else if ( _int == 5 ) give_inventory ( playerid, 2191, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			else if ( _int == 6 ) give_inventory ( playerid, 2192, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			
			setUpdateBalance ( playerid, p_info [ playerid ] [ donate ] ) ;
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
					show_dialog ( playerid, d_c_donate_vipgold, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
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
					show_dialog ( playerid, d_c_donate_vipgold, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
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
					show_dialog ( playerid, d_c_donate_vipgold, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Донат услуги","\
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
				return 1 ;
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
				return 1 ;
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
				
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы успешно приобрели услугу VIP {c3900a}'Gold'{"#cWH"}." ) ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

callback: loadUsersCaseStorage ( playerid, idx )
{
	new rows = cache_num_rows ( sql_connection ) ;
	if ( ! rows ) return false ;

	new modelId = cache_get_field_content_int ( 0, "item_idx", sql_connection ) ;

	new returnId = give_inventory (
		playerid,
		modelId,
		1,
		0,
		"",
		"",
		NUMBERPLATE_TYPE_NONE,
		0
	) ;
	if ( returnId == -1 )
	{
		send_check_cinfo ( playerid, "У Вас нет свободного слота в инвентаре!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return false ;
	}

	global_string [ 0 ] = EOS ;
	format ( global_string, 12, "%d", idx ) ;
	onServerSendData ( playerid, UI_DONATE_MENU, 14, global_string ) ;

	static const _str [ ] = "DELETE FROM users_case_storage WHERE id = %d LIMIT 1" ;
	new query_string [ sizeof _str + 9 ] ;
	format ( query_string, sizeof query_string, _str, idx ) ;
	mysql_tquery ( sql_connection, query_string ) ;
	return true ;
}

stock insertPlayerDonateCaseStorage ( playerid, caseId, modelId )
{
	static const _str [ ] = "INSERT INTO users_case_storage (u_id,case_idx,item_idx) VALUES ('%d','%d','%d')" ;
	new query_string [ sizeof _str + ( 3 * 9 ) ] ;
	format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ], caseId, modelId ) ;
	mysql_tquery ( sql_connection, query_string ) ;
	return true ;
}

callback: PlayerDonateCaseStorageCount ( playerid, init )
{
	if ( init )
	{
		static const _str [ ] = "SELECT case_idx FROM users_case_storage WHERE u_id = %d" ;
		new query_string [ sizeof _str + 9 ] ;
		format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, query_string, "PlayerDonateCaseStorageCount", "ii", playerid, 0 ) ;
	}
	else
	{
		new rows, fields ;
		cache_get_data ( rows, fields ) ;
		page_rows [ playerid ] = rows ;

		new pageCount = floatround ( page_rows [ playerid ] / 12 ) + 1 ;
		new Node: node = JSON_Object (
			"currentPage",		JSON_Int ( page_count [ playerid ] + 1 ),
			"maxPage",			JSON_Int ( pageCount )
		) ;

		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_DONATE_MENU, 15, global_string ) ;
	}
	return true ;
}

callback: PlayerDonateCaseStorage ( playerid, page, init )
{
	if ( init )
	{
		static const _str [ ] = "\
			SELECT \
				ucs.*, \
				UNIX_TIMESTAMP(ucs.date) AS unix_date \
			FROM users_case_storage ucs WHERE ucs.u_id = %d LIMIT 12 OFFSET %d" ;
		new query_string [ sizeof _str + ( 9 * 2 ) ] ;
		format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ], page * 12 ) ;
		mysql_tquery ( sql_connection, query_string, "PlayerDonateCaseStorage", "iii", playerid, page, 0 ) ;
	}
	else
	{
		page_count [ playerid ] = page ;

		new rows = cache_num_rows ( sql_connection ) ;
		if ( ! rows ) return false ;

		new Node: node = JSON_Array ( ), idx, modelId, dateTime, clockId ;
		for ( new i = 0, Node: caseNode, itemsLoaded = 0 ; i < rows ; i ++ )
		{
			idx = cache_get_field_content_int ( i, "id", sql_connection ) ;
			modelId = cache_get_field_content_int ( i, "item_idx", sql_connection ) ;
			dateTime = cache_get_field_content_int ( i, "unix_date", sql_connection ) ;

			dateTime = GetElapsedTime ( dateTime, gettime ( ), CONVERT_TIME_TO_DAYS ) ;
			switch ( dateTime )
			{
				case 5, 6, 7: clockId = 0 ;
				case 2, 3, 4: clockId = 1 ;
				default: clockId = 2 ;
			}

			caseNode = JSON_Array (
				JSON_Object (
					"position",			JSON_Int ( idx ),
					"type",         	JSON_Int ( item_render_type ( modelId ) ),
					"model",  			JSON_Int ( item_object_id ( modelId ) ),
					"color1",  			JSON_Int ( item_color ( modelId, 0 ) ),
					"color2",      		JSON_Int ( 0 ),
					"rotX",				JSON_Float ( 20.0 ),
					"rotY",				JSON_Float ( 180.0 ),
					"rotZ",				JSON_Float ( 45.0 ),
					"zoom",				JSON_Float ( 0.78 ),
					"name",				JSON_String ( item_name ( modelId ) ),
					"time",				JSON_Int ( dateTime ),
					"clock",			JSON_Int ( clockId )
				)
			) ;
			node = JSON_Append ( node, caseNode ) ;

			if ( ++ itemsLoaded == 5 || i == rows - 1 )
			{
				global_string [ 0 ] = EOS ;
				JSON_Stringify ( node, global_string, sizeof global_string ) ;
				onServerSendData ( playerid, UI_DONATE_MENU, 13, global_string ) ;

				node = JSON_Array ( ) ;
				itemsLoaded = 0 ;
			}
		}
	}
	return true ;
}

stock GetCaseRandomRarity ( caseType )
{
	new freeCount = 0, freeId [ 20 ] = { -1, ... }, idx,
		itemRarity = GetRandomWeightedNumber ( rarityChanceDefault ) ;

	switch ( caseType )
	{
		case 0:
		{
			for ( new i = 0 ; i < sizeof donate_free_case ; i ++ )
			{
				if ( donate_free_case [ i ] [ bp_rare ] != itemRarity ) continue ;

				freeId [ freeCount ] = i ;
				freeCount ++ ;
			}
		}
		case 1:
		{
			for ( new i = 0 ; i < sizeof donate_bmw_case ; i ++ )
			{
				if ( donate_bmw_case [ i ] [ bp_rare ] != itemRarity ) continue ;

				freeId [ freeCount ] = i ;
				freeCount ++ ;
			}
		}
		case 2:
		{
			for ( new i = 0 ; i < sizeof donate_mercedes_case ; i ++ )
			{
				if ( donate_mercedes_case [ i ] [ bp_rare ] != itemRarity ) continue ;

				freeId [ freeCount ] = i ;
				freeCount ++ ;
			}
		}
		case 3:
		{
			for ( new i = 0 ; i < sizeof donate_major_case ; i ++ )
			{
				if ( donate_major_case [ i ] [ bp_rare ] != itemRarity ) continue ;

				freeId [ freeCount ] = i ;
				freeCount ++ ;
			}
		}
		case 4:
		{
			for ( new i = 0 ; i < sizeof donate_lambo_case ; i ++ )
			{
				if ( donate_lambo_case [ i ] [ bp_rare ] != itemRarity ) continue ;

				freeId [ freeCount ] = i ;
				freeCount ++ ;
			}
		}
		case 5:
		{
			for ( new i = 0 ; i < sizeof bezumie_haosa_case ; i ++ )
			{
				if ( bezumie_haosa_case [ i ] [ bp_rare ] != itemRarity ) continue ;

				freeId [ freeCount ] = i ;
				freeCount ++ ;
			}
		}
		case 6:
		{
			for ( new i = 0 ; i < sizeof legends_sand_case ; i ++ )
			{
				if ( legends_sand_case [ i ] [ bp_rare ] != itemRarity ) continue ;

				freeId [ freeCount ] = i ;
				freeCount ++ ;
			}
		}
	}

	if ( ! freeCount ) idx = 0 ;
	else if ( freeCount > 0 && freeCount < 2 ) idx = freeId [ freeCount - 1 ] ;
	else idx = freeId [ random ( freeCount ) ] ;

	return idx ;
}
