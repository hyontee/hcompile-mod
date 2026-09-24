static const next_lvl_activations [ ] = { 250, 500, 750, 1000, 1250, 1500, 1750, 2000, 2250, 2500 } ;
static const next_lvl_money [ ] = { 1_000_000, 2_000_000, 3_000_000, 4_000_000, 5_000_000, 6_000_000, 7_000_000, 8_000_000, 9_000_000, 10_000_000 } ;

static const next_lvl_car [ ] [ 5 ] =
{
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 }
} ;

static const next_lvl_accessories [ ] [ 3 ] =
{
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 },
	{ 0, 0 }
} ;

stock show_promocode ( playerid )
{
	mysql_tquery ( sql_connection, !"SELECT `promo_used`, `promo_up`, `promo_text` FROM `server_promocodes` ORDER BY `server_promocodes`.`promo_used` DESC LIMIT 10", "callback_top_promo", "i", playerid ) ;
	return 1 ;
}

callback: callback_top_promo ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	if ( ! rows )
	{
		show_mainmenu ( playerid ) ;
		return 1 ;
	}
	
	global_string [ 0 ] = EOS ;
	new line_string [ 100 ], promo_text [ 32 ] ;
	
	strcat ( global_string, "{"#cBL"}Название:\t{"#cBL"}Активаций:\t{"#cBL"}Уровень:\n"
	for ( new i = 0 ; i < rows ; i ++ )
	{
		new promo_used = cache_get_field_content_int ( i, "promo_used", sql_connection ) ;
		new promo_up = cache_get_field_content_int ( i, "promo_up", sql_connection ) ;
		cache_get_field_content ( i, "promo_text", promo_text, sql_connection, 32 ) ;
		
		format ( line_string, sizeof line_string, "{"#cGRDialog"}- {"#cWH"}%s\t%d\t%d\n", promo_text, promo_used, promo_up ) ;
		strcat ( global_string, line_string ) ;
	}
	show_dialog ( playerid, d_l_prom, DIALOG_STYLE_TABLIST_HEADERS, "{"#cBHD"}Топ 10 промокодов", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

callback: callback_my_promo ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	if ( ! rows )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас нет личного промокода." ) ;
		return 1 ;
	}
	
	global_string [ 0 ] = EOS ;
	
	show_dialog ( playerid, d_l_prom, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Статистика Вашего промокода", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}