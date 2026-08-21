#define MAX_PROMOCODE_LEVEL		10
#define MAX_PROMOCODE 			200
enum PROMOCODE_STRUCT
{
	PROMO_ID,
	PROMO_OWNER,
	PROMO_NAME [ 32 ],
	PROMO_LEVEL,
	PROMO_ACTIVATIONS,
	PROMO_REFERAL_MONEY,

	PROMO_PLAYER_LEVEL [ 3 ]
} ;
new PromocodeStruct [ MAX_PROMOCODE ] [ PROMOCODE_STRUCT ] ;

enum PROMO_PRICE_STRUCT
{
	PROMO_PRICE_NULL,
	PROMO_PRICE_DONATE,
	PROMO_PRICE_ACTIVATIONS
} ;

enum PROMOCODE_REWARDS
{
	PROMO_MONEY,
	PROMO_PERCENT,
	PROMO_PRICE_TYPE [ 2 ],
	PROMO_PRICE [ 2 ]
} ;
new PromocodeRewards [ MAX_PROMOCODE_LEVEL ] [ PROMOCODE_REWARDS ] =
{
	{ 100_000, 2, { PROMO_PRICE_DONATE, PROMO_PRICE_NULL }, { 1_000, 0 } },
	{ 150_000, 2, { PROMO_PRICE_DONATE, PROMO_PRICE_ACTIVATIONS }, { 1_000, 5 } },
	{ 200_000, 2, { PROMO_PRICE_DONATE, PROMO_PRICE_ACTIVATIONS }, { 1_000, 10 } },
	{ 250_000, 2, { PROMO_PRICE_DONATE, PROMO_PRICE_ACTIVATIONS }, { 1_000, 20 } },
	{ 300_000, 3, { PROMO_PRICE_DONATE, PROMO_PRICE_ACTIVATIONS }, { 1_000, 40 } },
	{ 400_000, 3, { PROMO_PRICE_DONATE, PROMO_PRICE_ACTIVATIONS }, { 1_000, 80 } },
	{ 450_000, 4, { PROMO_PRICE_DONATE, PROMO_PRICE_ACTIVATIONS }, { 1_000, 100 } },
	{ 500_000, 4, { PROMO_PRICE_DONATE, PROMO_PRICE_ACTIVATIONS }, { 1_000, 125 } },
	{ 550_000, 4, { PROMO_PRICE_DONATE, PROMO_PRICE_ACTIVATIONS }, { 1_000, 150 } },
	{ 600_000, 5, { PROMO_PRICE_DONATE, PROMO_PRICE_ACTIVATIONS }, { 1_000, 200 } }
} ;

stock promo_OnGameModeInit ( )
{
	mysql_tquery ( sql_connection, !"SELECT * FROM users_promocodes", "LoadUsersPromocodes" ) ;
	return true ;
}

callback: LoadUsersPromocodes ( )
{
	new rows, fields, time = GetTickCount ( ) ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return false ;

	for ( new i = 0 ; i < rows ; i ++ )
	{
		PromocodeStruct [ i ] [ PROMO_ID ] = cache_get_field_content_int ( i, "promo_id", sql_connection ) ;
		PromocodeStruct [ i ] [ PROMO_OWNER ] = cache_get_field_content_int ( i, "promo_owner", sql_connection ) ;
		cache_get_field_content ( i, "promo_name", PromocodeStruct [ i ] [ PROMO_NAME ], sql_connection, 32 ) ;
		PromocodeStruct [ i ] [ PROMO_LEVEL ] = cache_get_field_content_int ( i, "promo_level", sql_connection ) ;
		PromocodeStruct [ i ] [ PROMO_ACTIVATIONS ] = cache_get_field_content_int ( i, "promo_activations", sql_connection ) ;
		PromocodeStruct [ i ] [ PROMO_REFERAL_MONEY ] = cache_get_field_content_int ( i, "promo_referal_money", sql_connection ) ;
	}
	printf ( "[SERVER] Загружено %d промокодов игроков. (%d ms)", rows, GetTickCount ( ) - time ) ;
	return true ;
}

stock ShowPromocodeMain ( playerid )
{
	new promoId = p_info [ playerid ] [ owner_promo_id ] ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 512, "\
		{"#cBL"}1. {"#cWH"}Ваш промо-код: {"#cOR"}%s\n\
		{"#cBL"}2. {"#cWH"}Уровень промо-кода: {"#cOR"}%d из %d\n\
		{"#cBL"}3. {"#cWH"}Баланс: {"#cOR"}%d реферальных монет\n\
		{"#cBL"}4. {"#cWH"}Список игроков {"#cGRDialog"}всего %d использований",
	PromocodeStruct [ promoId ] [ PROMO_NAME ],
	PromocodeStruct [ promoId ] [ PROMO_LEVEL ], MAX_PROMOCODE_LEVEL,
	PromocodeStruct [ promoId ] [ PROMO_REFERAL_MONEY ], PromocodeStruct [ promoId ] [ PROMO_ACTIVATIONS ] ) ;

	show_dialog ( playerid, d_user_promo, DIALOG_STYLE_LIST, "{"#cBHD"}Статистика промокода", global_string, "Выбрать", "Назад" ) ;
	return true ;
}

stock ShowPromocodeLevel ( playerid )
{
	new promoId = p_info [ playerid ] [ owner_promo_id ], strMoney [ 64 ], strActivations [ 64 ] ;

	global_string [ 0 ] = EOS ;
	strcat ( global_string, "{"#cBL"}Уровень:\t{"#cBL"}Бонус:\t{"#cBL"}Стоимость:\t{"#cBL"}Требования:\n" ) ;
	for ( new i = 0 ; i < MAX_PROMOCODE_LEVEL ; i ++ )
	{
		if ( PromocodeRewards [ i ] [ PROMO_PRICE_TYPE ] [ PROMO_PRICE_DONATE ] > 0 )
			format ( strMoney, sizeof strMoney, "%s "donate_title"", GetPlayerCashValueToSmile ( GetPlayerCashValueToSmile ( PromocodeRewards [ i ] [ PROMO_PRICE_TYPE ] [ PROMO_PRICE_DONATE ] ) ) ) ;
		
		else
			format ( strMoney, sizeof strMoney, "-" ) ;

		if ( PromocodeRewards [ i ] [ PROMO_PRICE_TYPE ] [ PROMO_PRICE_ACTIVATIONS ] > 0 )
			format ( strActivations, sizeof strActivations, "%d использований", PromocodeRewards [ i ] [ PROMO_PRICE_TYPE ] [ PROMO_PRICE_ACTIVATIONS ] ) ;
		
		else
			format ( strActivations, sizeof strActivations, "-" ) ;

		if ( PromocodeStruct [ promoId ] [ PROMO_LEVEL ] >= i )
		{
			format (
				global_string, sizeof global_string,
					"%s{"#cWH"}%d уровень\t%s"valute_title_", %d.00% от доната в реф. монеты\t%s\t%s\n",
				global_string, i + 1,
				GetPlayerCashValueToSmile ( PromocodeRewards [ i ] [ PROMO_MONEY ] ), PromocodeRewards [ i ] [ PROMO_PERCENT ],
				strMoney, strActivations
			) ;
		}
		else
		{
			format (
				global_string, sizeof global_string,
					"%s{"#cGRDialog"}%d уровень\t%s"valute_title_", %d.00% от доната в реф. монеты\t%s\t%s\n",
				global_string, i + 1,
				GetPlayerCashValueToSmile ( PromocodeRewards [ i ] [ PROMO_MONEY ] ), PromocodeRewards [ i ] [ PROMO_PERCENT ],
				strMoney, strActivations
			) ;
		}
	}

	static const _header [ ] = "{"#cBHD"}Промо-код: {"#cWH"}%s   {"#cBHD"}Уровень: {"#cWH"}%d из %d" ;
	new header_string [ sizeof _header + 32 + ( 9 * 2 ) ] ;
	format ( header_string, sizeof header_string, _header, PromocodeStruct [ promoId ] [ PROMO_NAME ], PromocodeStruct [ promoId ] [ PROMO_LEVEL ], MAX_PROMOCODE_LEVEL ) ;
	show_dialog ( playerid, d_user_promo_level, DIALOG_STYLE_TABLIST_HEADERS, header_string, global_string, "Повысить", "Назад" ) ;
	return true ;
}

stock promo_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case d_user_promo:
		{
			if ( ! response ) return show_mainmenu ( playerid ) ;

			if ( listitem == 0 ) ShowPromocodeLevel ( playerid ) ;
			else if ( listitem == 1 ) ShowPromocodeLevel ( playerid ) ;
			else if ( listitem == 2 ) { }
			else if ( listitem == 3 ) initPromocodeStats ( playerid, 1 ) ;
			return true ;
		}
		case d_user_promo_level:
		{
			if ( ! response ) return ShowPromocodeMain ( playerid ) ;

			new promoId = p_info [ playerid ] [ owner_promo_id ],
				promoLevel = PromocodeStruct [ promoId ] [ PROMO_LEVEL ] ;

			if ( ! get_player_donate ( playerid, PromocodeRewards [ promoLevel + 1 ] [ PROMO_PRICE_TYPE ] [ PROMO_PRICE_DONATE ], 2 ) )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно "donate_title"." ) ;
			}
			else if ( PromocodeRewards [ promoLevel + 1 ] [ PROMO_PRICE_TYPE ] [ PROMO_PRICE_ACTIVATIONS ] > PromocodeStruct [ promoId ] [ PROMO_ACTIVATIONS ] )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно использований." ) ;
			}
			else if ( promoLevel >= MAX_PROMOCODE_LEVEL )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас максимальный уровень промо-кода." ) ;
			}
			else
			{
				PromocodeStruct [ promoId ] [ PROMO_LEVEL ] += 1 ;

				static const _str [ ] = "UPDATE users_promocodes SET promo_level = promo_level + 1 WHERE promo_id = %d LIMIT 1" ;
				new query_string [ sizeof _str + 9 ] ;
				format ( query_string, sizeof query_string, _str, promoId ) ;
				mysql_tquery ( sql_connection, query_string ) ;
			}

			ShowPromocodeMain ( playerid ) ;
			return true ;
		}
	}
	return false ;
}

callback: initPromocodeStats ( playerid, init )
{
	if ( init )
	{
		static const _str [ ] = "\
			SELECT \
				IFNULL((SELECT COUNT(u_id) FROM users WHERE u_level > 3 AND u_promo_id = %d), 0) AS third_level_count, \
				IFNULL((SELECT COUNT(u_id) FROM users WHERE u_level > 5 AND u_promo_id = %d), 0) AS six_level_count \
			FROM users" ;
		new query_string [ sizeof _str + ( 9 * 2 ) ], promoId = p_info [ playerid ] [ owner_promo_id ] ;
		format ( query_string, sizeof query_string, _str, promoId, promoId ) ;
		mysql_tquery ( sql_connection, query_string, "initPromocodeStats", "ii", playerid, 0 ) ;
	}
	else
	{
		new rows, fields ;
		cache_get_data ( rows, fields ) ;
		if ( ! rows )
		{
			send_check_cinfo ( playerid, "Ничего не найдено!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			ShowPromocodeMain ( playerid ) ;
			return false ;
		}

		new third_level_count = cache_get_field_content_int ( 0, "third_level_count" ) ;
		new six_level_count = cache_get_field_content_int ( 0, "six_level_count" ) ;
	}
	return true ;
}