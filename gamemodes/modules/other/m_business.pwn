#include <custom/business_packet>

new bool: business_open [ MAX_PLAYERS ] ;
stock show_packet_business ( playerid, _param1, _param2, _param3 )
{
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 )
		{
			if ( _param3 == 0 )
			{
				business_open [ playerid ] = false ;
				bizHide ( playerid ) ;
				
				toggle_controlable ( playerid, true ) ;

				TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
			}
			else if ( _param3 == 1 )
			{
				if ( Iter_Count(player_business[playerid]) > 1 )
				{
					show_select_bpanel ( playerid ) ;
				}
				else
				{
					show_packet_business ( playerid, 0, 0, 0 ) ;
				}
			}
		}
		else if ( _param2 == 1 )
		{
			new dialog_string [ 121 + 9 ] ;
			format ( dialog_string, sizeof ( dialog_string ), "{"#cBL"}* {"#cGRDialog"}Средств на балансе: {"#cBL"}%d"valute_title_"\n\n{"#cWH"}Введите сумму, которую желаете снять с баланса:", b_info [ p_info [ playerid ] [ business ] - 1 ] [ b_money ] ) ;
			show_dialog ( playerid, d_bpanel_money_take, DIALOG_STYLE_INPUT, "{"#cBHD"}Снять наличные", dialog_string, "Принять", "Назад" ) ;
		}
		else if ( _param2 == 2 )
		{
			new dialog_string [ 121 + 9 ] ;
			format ( dialog_string, sizeof ( dialog_string ), "{"#cBL"}* {"#cGRDialog"}Средств на балансе: {"#cBL"}%d"valute_title_"\n\n{"#cWH"}Введите сумму, на которую желаете пополнить баланс:", b_info [ p_info [ playerid ] [ business ] - 1 ] [ b_money ] ) ;
			show_dialog ( playerid, d_bpanel_money_put, DIALOG_STYLE_INPUT, "{"#cBHD"}Пополнить баланс", dialog_string, "Принять", "Назад" ) ;
		}
		else if ( _param2 == 3 )
		{
			new _b_id = p_info [ playerid ] [ business ] ;
			b_info [ _b_id - 1 ] [ b_close ] = _param3 ;
			
			new _str [ 32 ], _str2 [ 12 ] ;
			format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( b_info [ _b_id - 1 ] [ b_money ] ) ) ;
	        format ( _str2, sizeof _str2, "%d", _b_id ) ;
			bizLayoutUpdate ( playerid, "Р", _str, b_types [ b_info [ _b_id - 1 ] [ b_type ] ], _str2, b_info [ _b_id - 1 ] [ b_type ], ( b_info [ _b_id - 1 ] [ b_close ] ) ? ( true ) : ( false ) ) ;

			new query_string [ 92 ] ;
			format ( query_string, sizeof ( query_string ), "UPDATE `businesses` SET `b_close` = '%d' WHERE `b_id` = '%d' LIMIT 1", b_info [ _b_id - 1 ] [ b_close ], p_info [ playerid ] [ business ] ) ;
			mysql_tquery ( sql_connection, query_string ) ;
		}
	}
	else if ( _param1 == 1 )
	{
		if ( _param2 == 1 )
		{
			business_open [ playerid ] = true ;
			p_info [ playerid ] [ business ] = _param3 ;
			bizLayoutPage ( playerid, 0 ) ;
			
			new _str [ 32 ], _str2 [ 12 ], _b_type = b_info [ _param3 - 1 ] [ b_type ] ;
			format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( b_info [ _param3 - 1 ] [ b_money ] ) ) ;
	        format ( _str2, sizeof _str2, "%d", _param3 ) ;
			bizLayoutUpdate ( playerid, "Р", _str, b_types [ _b_type ], _str2, _b_type, ( b_info [ _param3 - 1 ] [ b_close ] ) ? ( true ) : ( false ) ) ;
		
			if ( _b_type != bizz_type_fixcar && _b_type != bizz_type_autoshop &&
				_b_type != bizz_type_flyshop && _b_type != bizz_type_boatshop &&
				_b_type != bizz_type_electric && _b_type != bizz_type_lake && _b_type != bizz_type_reserve &&
				_b_type != bizz_type_boat_up && _b_type != bizz_type_boat_rent && _b_type != bizz_type_plane_up && _b_type != bizz_type_plane_rent &&
				_b_type != bizz_type_parking )
			{
				if ( _b_type == bizz_type_rentcar || _b_type == bizz_type_bank || _b_type == bizz_type_trucker ) bizMenuItem ( playerid, 8, "Автопарк" ) ;
				if ( _b_type == bizz_type_gas ) bizMenuItem ( playerid, 0, "Заказать топливо" ) ;
				else if ( _b_type == bizz_type_tune ) bizMenuItem ( playerid, 0, "Заказать детали" ) ;
				else bizMenuItem ( playerid, 0, "Заказать продукты" ) ;
			}
			bizMenuItem ( playerid, 1, "Улучшения" ) ;
			bizMenuItem ( playerid, 2, "Доходы" ) ;
			bizMenuItem ( playerid, 3, "Продать бизнес" ) ;
			bizMenuItem ( playerid, 4, "Персонал" ) ;
			bizMenuItem ( playerid, 5, "Музыка при входе" ) ;
			bizMenuItem ( playerid, 6, "Найти бизнес" ) ;
			bizMenuItem ( playerid, 7, "Приостановление" ) ;
			
			business_main_item ( playerid, _param3 ) ;
			
			if ( _b_type != bizz_type_gas && _b_type != bizz_type_food && _b_type != bizz_type_fixcar ) bizParentItem ( playerid, 0, "Основная информация", true ) ;
			else bizParentItem ( playerid, 0, "Основная информация", false ) ;
			business_child_item ( playerid, _param3 ) ;
			
			bizParentItem ( playerid, 1, "Ассортимент бизнеса", true ) ;
			business_shop_item ( playerid, _param3 ) ;
		}
	}
	else if ( _param1 == 2 )
	{
		if ( _param2 == 1 )
		{
			new _b_id = p_info [ playerid ] [ business ], _b_type = b_info [ _b_id - 1 ] [ b_type ] ;
			if ( _param3 == 0 ) show_dialog ( playerid, d_bpanel_order, DIALOG_STYLE_LIST, "{"#cBHD"}Заказ продуктов", "{"#cBL"}1.{"#cWH"} Установить цена за {"#cLY"}1 ед.{"#cWH"}\n{"#cBL"}2.{"#cWH"} Информация", "Выбрать", "Назад" ) ;
			else if ( _param3 == 1 ) show_b_improvment ( playerid, _b_type, _b_id ) ;
			else if ( _param3 == 2 )
			{
				new text_string [ 144 ] ;
				mysql_format ( sql_connection, text_string, sizeof ( text_string  ), "SELECT `bh_count`, `bh_date` FROM `businesses_history` WHERE `bh_business` = '%d' AND `bh_date` >= DATE(NOW()) - INTERVAL 7 DAY", p_info [ playerid ] [ business ] ) ;
				mysql_tquery ( sql_connection, text_string, "bh_story", "iii", playerid, _b_id, 1 ) ;
			}
			else if ( _param3 == 3 )
			{
				#if defined m_auction
					if ( b_info [ _b_id - 1 ] [ b_auction_status ] == 1 )
					{
						send_check_cinfo ( playerid, "Бизнес выставлен на аукционе.", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
						return 1 ;
					}

					show_dialog ( playerid, d_bpanel_sell, DIALOG_STYLE_LIST, "{"#cBHD"}Продажа бизнеса", "{"#cBL"}1.{"#cWH"} Продать игроку\n{"#cBL"}2.{"#cWH"} Продать государству", "Выбрать", "Назад" ) ;
				#else
					show_dialog ( playerid, d_bpanel_sell, DIALOG_STYLE_LIST, "{"#cBHD"}Продажа бизнеса", "{"#cBL"}1.{"#cWH"} Продать игроку\n{"#cBL"}2.{"#cWH"} Продать государству", "Выбрать", "Назад" ) ;
				#endif
				
				show_packet_business ( playerid, 0, 0, 0 ) ;
			}
			else if ( _param3 == 4 ) business_personal ( playerid ) ;
			else if ( _param3 == 5 ) business_sound ( playerid ) ;
			else if ( _param3 == 6 )
			{
				SetPlayerRaceCheckpoint ( playerid, 1, b_info [ _b_id - 1 ] [ b_position ] [ 0 ], b_info [ _b_id - 1 ] [ b_position ] [ 1 ], b_info [ _b_id - 1 ] [ b_position ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;

				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
				is_gps_used { playerid } = 1 ;
				
				show_packet_business ( playerid, 0, 0, 0 ) ;
			}
			else if ( _param3 == 7 ) business_freeze ( playerid ) ;
			else if ( _param3 == 8 ) show_fixcar ( playerid, 2 ) ;
		}
	}
	else if ( _param1 == 3 )
	{
		if ( _param2 == 1 )
		{
			if ( _param3 == 0 )
			{
				new _b_id = p_info [ playerid ] [ business ], dialog_string [ 108 ] ;
				format ( dialog_string, sizeof ( dialog_string ), "{ffffff}На данный момент цена за вход составляет {"#cBL"}%d"valute_title"{ffffff}.", b_info [ _b_id - 1 ] [ b_fee ] ) ;
				show_dialog ( playerid, d_bpanel_fee, DIALOG_STYLE_INPUT, "{"#cBHD"}Цена за вход", dialog_string, "Принять", "Назад" ) ;
			}
			else if ( _param3 == 1 )
			{
				new _b_id = p_info [ playerid ] [ business ], _b_type = b_info [ _b_id - 1 ] [ b_type ] ;
				if ( _b_type == bizz_type_shop ) ShowShopDialog ( playerid, 2 ) ;
				else if ( _b_type == bizz_type_ammo ) ShowAmmoDialog ( playerid, 2 ) ;
				else if ( _b_type == bizz_type_pharm ) ShowPharmDialog ( playerid, 2 ) ;
				else if ( _b_type == bizz_type_bank ) ShowBankDialog ( playerid ) ;
				else if ( _b_type == bizz_type_fish ) ShowFishingDialog ( playerid, 2 ) ;
				else if ( _b_type == bizz_type_bar || _b_type == bizz_type_club || _b_type == bizz_type_casino ) ShowBarDialog ( playerid, 2 ) ;
				else if ( _b_type == bizz_type_food ) ShowCafeDialog ( playerid, 2 ) ;
				else if ( _b_type == bizz_type_gym ) ShowGymDialog ( playerid ) ;
				else if ( _b_type == bizz_type_rieltore || _b_type == bizz_type_card ) ShowOtherDialog ( playerid ) ;
				else if ( _b_type == bizz_type_carshop ) ShowCarShopDialog ( playerid ) ;
				else if ( _b_type == bizz_type_gas ) ShowFillingDialog ( playerid ) ;
				else if ( _b_type == bizz_type_hotel ) ShowHotelDialog ( playerid ) ;
				else if ( _b_type == bizz_type_fixcar || _b_type == bizz_type_boat_rent || _b_type == bizz_type_plane_rent || _b_type == bizz_type_parking )
			    {
			        new dialog_string [ 108 ] ;
					format ( dialog_string, sizeof ( dialog_string ), "{ffffff}На данный момент цена на авто составляет {"#cBL"}%d"valute_title"{ffffff}.", b_info [ _b_id - 1 ] [ b_cost ] ) ;
					show_dialog ( playerid, d_bpanel_cost, DIALOG_STYLE_INPUT, "{"#cBHD"}Наценка на товар", dialog_string, "Принять", "Назад" ) ;
			    }
			    else if ( _b_type == bizz_type_boat_up || _b_type == bizz_type_plane_up )
			    {
			        new dialog_string [ 108 ] ;
					format ( dialog_string, sizeof ( dialog_string ), "{ffffff}На данный момент наценка на товар составляет {"#cBL"}%d%%{ffffff}.", b_info [ _b_id - 1 ] [ b_cost ] ) ;
					show_dialog ( playerid, d_bpanel_cost, DIALOG_STYLE_INPUT, "{"#cBHD"}Наценка на товар", dialog_string, "Принять", "Назад" ) ;
			    }
				else
				{
					new dialog_string [ 108 ] ;
					format ( dialog_string, sizeof ( dialog_string ), "{ffffff}На данный момент наценка на товар составляет {"#cBL"}%d{ffffff} процентов.", b_info [ _b_id - 1 ] [ b_cost ] ) ;
					show_dialog ( playerid, d_bpanel_cost, DIALOG_STYLE_INPUT, "{"#cBHD"}Наценка на товар", dialog_string, "Принять", "Назад" ) ;
				}
			}
		}
	}
	else if ( _param1 == 10 )
	{
		new _str [ 32 ], _str2 [ 12 ], _b_id = p_info [ playerid ] [ business ] ;
		format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( b_info [ _b_id - 1 ] [ b_money ] ) ) ;
	    format ( _str2, sizeof _str2, "%d", _b_id ) ;
		bizLayoutUpdate ( playerid, "Р", _str, b_types [ b_info [ _b_id - 1 ] [ b_type ] ], _str2, b_info [ _b_id - 1 ] [ b_type ], ( b_info [ _b_id - 1 ] [ b_close ] ) ? ( true ) : ( false ) ) ;
	}
	return 1 ;
}

stock business_main_item ( playerid, _b_id )
{
	new _str [ 24 ] ;
	bizMainItem ( playerid, "Крыша", "", f_info [ b_info [ _b_id - 1 ] [ b_mafia ] - 1 ] [ f_name ], "" ) ;
			
	new business_tax = floatround ( b_info [ _b_id - 1 ] [ b_cash_today ] / 500 ) * for_tax [ 4 ] ;
	if ( b_info [ _b_id - 1 ] [ b_improve ] [ 0 ] ) business_tax = floatround ( b_info [ _b_id - 1 ] [ b_cash_today ] / 1000 ) * for_tax [ 4 ] ;
	format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( business_tax ) ) ;
	bizMainItem ( playerid, "Налог в сутки", "", _str, "" ) ;
	
	format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_info [ _b_id - 1 ] [ b_cash_today ] ) ) ;
	bizMainItem ( playerid, "Прибыль за сегодня", "", _str, "" ) ;
	
	format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_info [ _b_id - 1 ] [ b_cash_limit ] ) ) ;
	bizMainItem ( playerid, "Максимальная прибыль", "", _str, "" ) ;
	
	new _mafia_money = floatround ( ( b_info [ _b_id - 1 ] [ b_cash_today ] / 20 ) * 100 ) ;
	format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( _mafia_money ) ) ;
	bizMainItem ( playerid, "Оплата крыши", "", _str, "" ) ;
	return 1 ;
}

stock business_child_item ( playerid, _b_id )
{
	new _b_type = b_info [ _b_id - 1 ] [ b_type ], _str [ 24 ] ;
	format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_info [ _b_id - 1 ] [ b_incass ] ) ) ;
	bizChildItem ( playerid, 0, 0, "Инкассация", _str ) ;

	if ( _b_type != bizz_type_rentcar && _b_type != bizz_type_trucker )
	{
		format ( _str, sizeof _str, "%d"valute_title_"", b_info [ _b_id - 1 ] [ b_cost ] ) ;
		if ( _b_type == bizz_type_gas ) bizChildItem ( playerid, 0, 1, "Закупка топлива", _str ) ;
		else if ( _b_type == bizz_type_tune ) bizChildItem ( playerid, 0, 1, "Закупка деталей", _str ) ;
		else bizChildItem ( playerid, 0, 1, "Закупка продуктов", _str ) ;

		format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( b_info [ _b_id - 1 ] [ b_product ] ) ) ;
		if ( _b_type == bizz_type_gas ) bizChildItem ( playerid, 0, 2, "Топливо", _str ) ;
		else if ( _b_type == bizz_type_tune ) bizChildItem ( playerid, 0, 2, "Детали", _str ) ;
		else bizChildItem ( playerid, 0, 2, "Продукты", _str ) ;

		format ( _str, sizeof _str, "%s", GetPlayerCashValueToSmile ( b_info [ _b_id - 1 ] [ b_maxproduct ] ) ) ;
		if ( _b_type == bizz_type_gas ) bizChildItem ( playerid, 0, 3, "Макс. топлива", _str ) ;
		else if ( _b_type == bizz_type_tune ) bizChildItem ( playerid, 0, 3, "Макс. деталей", _str ) ;
		else bizChildItem ( playerid, 0, 3, "Макс. продуктов", _str ) ;
		
		if ( _b_type != bizz_type_gas && _b_type != bizz_type_food && _b_type != bizz_type_fixcar )
		{
			format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_info [ _b_id - 1 ] [ b_fee ] ) ) ;
			bizChildItem ( playerid, 0, 4, "Цена за вход", _str ) ;
		}
	
		format ( _str, sizeof _str, "%d чел.", GetPlayerCashValueToSmile ( b_info [ _b_id - 1 ] [ b_visitors ] ) ) ;
		bizChildItem ( playerid, 0, 5, "Посетители", _str ) ;
	}
	
	bizChildItem ( playerid, 0, 6, "Налог зависит от прибыли за сутки", "" ) ;
	return 1 ;
}

stock business_shop_item ( playerid, _b_id )
{
	new _b_type = b_info [ _b_id - 1 ] [ b_type ], _str [ 24 ] ;
	if ( _b_type == bizz_type_shop )
	{
		for ( new i = 0 ; i < MAX_ITEM_IN_SHOP ; i ++ )
		{
			format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ i ] ) ) ;
			bizChildItem ( playerid, 1, i, b_shop [ i ] [ bs_name ], _str ) ;
		}
	}
	else if ( _b_type == bizz_type_ammo )
	{
		for ( new i = 0 ; i < MAX_AMMO_IN_SHOP ; i ++ )
		{
			format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ i ] ) ) ;
			bizChildItem ( playerid, 1, i, b_gun_shop [ i ] [ bs_name ], _str ) ;
		}
	}
	else if ( _b_type == bizz_type_pharm )
	{
		for ( new i = 0 ; i < MAX_PHARMACY_IN_SHOP ; i ++ )
		{
			format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ i ] ) ) ;
			bizChildItem ( playerid, 1, i, b_pharmacy_shop [ i ] [ bs_name ], _str ) ;
		}
	}
	else if ( _b_type == bizz_type_bank )
	{
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 0 ] ) ) ;
		bizChildItem ( playerid, 1, 0, "Операции в банкомате", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 1 ] ) ) ;
		bizChildItem ( playerid, 1, 1, "%% ставка по кредиту", _str ) ;
	}
	else if ( _b_type == bizz_type_fish )
	{
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 0 ] ) ) ;
		bizChildItem ( playerid, 1, 0, "Удочка", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 1 ] ) ) ;
		bizChildItem ( playerid, 1, 1, "Наживка", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 2 ] ) ) ;
		bizChildItem ( playerid, 1, 2, "Ружьё", _str ) ;
	}
	else if ( _b_type == bizz_type_bar || _b_type == bizz_type_club || _b_type == bizz_type_casino )
	{
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 0 ] ) ) ;
		bizChildItem ( playerid, 1, 0, "Сода", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 1 ] ) ) ;
		bizChildItem ( playerid, 1, 1, "Кока-кола", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 2 ] ) ) ;
		bizChildItem ( playerid, 1, 2, "Пиво", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 3 ] ) ) ;
		bizChildItem ( playerid, 1, 3, "Водка", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 4 ] ) ) ;
		bizChildItem ( playerid, 1, 4, "Коньяк", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 5 ] ) ) ;
		bizChildItem ( playerid, 1, 5, "Абсент", _str ) ;
	}
	else if ( _b_type == bizz_type_food )
	{
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 0 ] ) ) ;
		bizChildItem ( playerid, 1, 0, "Мороженое", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 1 ] ) ) ;
		bizChildItem ( playerid, 1, 1, "Бургер", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 2 ] ) ) ;
		bizChildItem ( playerid, 1, 2, "Хот Дог", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 3 ] ) ) ;
		bizChildItem ( playerid, 1, 3, "Салат", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 4 ] ) ) ;
		bizChildItem ( playerid, 1, 4, "Пицца", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 5 ] ) ) ;
		bizChildItem ( playerid, 1, 5, "Курица с картошкой", _str ) ;
	}
	else if ( _b_type == bizz_type_gym )
	{
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 0 ] ) ) ;
		bizChildItem ( playerid, 1, 0, "Тренировка", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 1 ] ) ) ;
		bizChildItem ( playerid, 1, 1, "Тренировка по боксу", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 2 ] ) ) ;
		bizChildItem ( playerid, 1, 2, "Тренировка Кунг Фу", _str ) ;
	}
	else if ( _b_type == bizz_type_rieltore )
	{
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 0 ] ) ) ;
		bizChildItem ( playerid, 1, 0, "Стоимость размещения (продажа)", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 1 ] ) ) ;
		bizChildItem ( playerid, 1, 1, "Стоимость размещения (аукцион)", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 2 ] ) ) ;
		bizChildItem ( playerid, 1, 2, "Обмен имуществом", _str ) ;
	}
	else if ( _b_type == bizz_type_card )
	{
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 0 ] ) ) ;
		bizChildItem ( playerid, 1, 0, "Стоимость размещения (продажа)", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 1 ] ) ) ;
		bizChildItem ( playerid, 1, 1, "Стоимость размещения (аукцион)", _str ) ;
	}
	else if ( _b_type == bizz_type_carshop )
	{
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 0 ] ) ) ;
		bizChildItem ( playerid, 1, 0, "Стоимость размещения т/с", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 1 ] ) ) ;
		bizChildItem ( playerid, 1, 1, "Процент от сделки по продаже", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 2 ] ) ) ;
		bizChildItem ( playerid, 1, 2, "Процент от сделки по обмену", _str ) ;
	}
	else if ( _b_type == bizz_type_gas )
	{
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 0 ] ) ) ;
		bizChildItem ( playerid, 1, 0, "1 литр топлива", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 1 ] ) ) ;
		bizChildItem ( playerid, 1, 1, "Канистра", _str ) ;
		
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 2 ] ) ) ;
		bizChildItem ( playerid, 1, 2, "Ремонт", _str ) ;
	}
	else if ( _b_type == bizz_type_hotel )
	{
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_price_market [ _b_id - 1 ] [ 0 ] ) ) ;
		bizChildItem ( playerid, 1, 0, "Аренда номера (сутки)", _str ) ;
	}
	else
	{
		format ( _str, sizeof _str, "%s"valute_title_"", GetPlayerCashValueToSmile ( b_info [ _b_id - 1 ] [ b_cost ] ) ) ;
		bizChildItem ( playerid, 1, 0, "Наценка на товар", _str ) ;
	}
	return 1 ;
}