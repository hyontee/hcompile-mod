enum
{
	CATEGORY_ACS = 0,
    CATEGORY_CARS,
    CATEGORY_SKINS,
    CATEGORY_HOUSES,
    CATEGORY_BUSINESS,
    CATEGORY_INVENTORY
} ;

stock t_market_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_admin_ad_delete:
		{
			if ( ! response ) return 1 ;

			deleteMarketAd ( playerid, get_player_use_listitem ( playerid ) ) ;

			new query_string [ 128 ] ;
			format ( query_string, sizeof query_string, "%s удалил(а) объявление (#%d)",
			p_info [ playerid ] [ name ], get_player_use_listitem ( playerid ) ) ;
			WriteLog ( playerid, TYPE_LOG_MARKET_PLACE, query_string ) ;
			return 1 ;
		}
		case d_admin_ad_blocked:
		{
			if ( ! response ) return 1 ;

			new idx = get_player_use_listitem ( playerid ) ;
			foreach(new i: logged_players)
			{
				if ( p_info [ i ] [ id ] != idx ) continue ;

				p_info [ i ] [ market_block ] = 1 ;

				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "Администратор %s выдал(а) Вам блокировку на подачу объявлений в маркет плэйсе!\nЕсли Вы не согласны, то сделайте скриншот и подайте жалобу.", p_info [ playerid ] [ name ] ) ;
				send_check_cinfo ( playerid, global_string, 0, 7, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				break ;
			}

			new query_string [ 128 ] ;
			format ( query_string, sizeof query_string, "UPDATE `users` SET `u_market_block` = '1' WHERE `u_id` = '%d' LIMIT 1", idx ) ;
			mysql_tquery ( sql_connection, query_string ) ;

			query_string [ 0 ] = EOS ;
			format ( query_string, sizeof query_string, "%s выдал(а) блокировку объявлений (#%d)",
			p_info [ playerid ] [ name ], idx ) ;
			WriteLog ( playerid, TYPE_LOG_MARKET_PLACE, query_string ) ;

			send_check_cinfo ( playerid, "Вы заблокировали игроку подачу объявлений.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
			return 1 ;
		}
	}
	return 0 ;
}

callback: callback_buy_market ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		send_check_cinfo ( playerid, "Объявление больше не доступно!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
	}

	new idx, priceCount, ownerId, categoryId, modelId, targetId = INVALID_PLAYER_ID ;
	idx = cache_get_field_content_int ( 0, "id" ) ;
	priceCount = cache_get_field_content_int ( 0, "price" ) ;
	ownerId = cache_get_field_content_int ( 0, "ownerId" ) ;
	categoryId = cache_get_field_content_int ( 0, "category" ) ;
	modelId = cache_get_field_content_int ( 0, "modelInsert" ) ;

	foreach(new i: logged_players)
	{
		if ( p_info [ i ] [ id ] != ownerId ) continue ;

		targetId = i ;
		break ;
	}

	if ( categoryId == CATEGORY_HOUSES )
	{
		buyMarketAd ( playerid, ownerId, idx ) ; // нужно обязательно обновить владельца полностью
		return_market_houses ( playerid, modelId ) ;

		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Вы успешно приобрели данную недвижимость. Используйте {"#cGN"}/hmenu{"#cGRInfo"} для управление домом." ) ;
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Вам необходимо оплачивать налоги на недвижимость." ) ;
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Налоги списываются 1 раз в сутки. Для получения выписки рекомендуем обратиться в банк." ) ;
				
		if ( h_info [ modelId - 1 ] [ h_garage ] )
		{
			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}В доме имеется обустроенный гараж, в котором можно парковать т/с." ) ;
			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Домашний гараж не даёт дополнительный слот для т/с." ) ;
		}

		if ( ! users_education [ playerid ] [ EDUCATION_BUY_HOUSE ] )
		{
			show_window_monologue (
				playerid,
				5,
				"Поздравляю тебя с покупкой дома! \
				Не забывай оплачивать налоги. Налоги на недвижимость начисляются раз в сутки. \
				Оплатить их можно в банке или банкомате. Используй /gps, чтоб найти ближайший. \
				Если сумма долга превысит "tax_limit", то сотрудники Мэрии опечатать имущество для аукциона.",
				"Местный",
				"Понял"
			) ;
		
			save_user_education ( playerid, EDUCATION_BUY_HOUSE ) ;
		}

		checking_quest_progress ( playerid, 2, 1, quest_line_medium ) ;

		give_money ( playerid, -priceCount ) ;

		if ( targetId == INVALID_PLAYER_ID )
		{
			insert_debtor_message ( "Market Place", "Выставленный дом на маркет плэйсе был продан!\nПолучить деньги можно в банке подойдя к надписи \"получение переводов\".", ownerId ) ;
			insert_return_money ( "Market Place", priceCount, ownerId ) ;

			new query_string [ 100 ] ;
			format ( query_string, sizeof query_string, "(market) покупка Дома #%d у #%d", modelId, ownerId ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -priceCount, query_string ) ;
		}
		else
		{
			new query_string [ 144 ] ;
			format ( query_string, sizeof query_string, "(market) покупка Дома #%d у %s", modelId, p_info [ targetId ] [ name ] ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -priceCount, query_string ) ;

			give_money ( targetId, priceCount ) ;

			format ( query_string, sizeof query_string, "(market) продажа Дома #%d (%s)", modelId, p_info [ playerid ] [ name ] ) ;
			insert_money_log ( targetId, INVALID_PLAYER_ID, priceCount, query_string ) ;

			send_check_cinfo ( targetId, "Выставленный бизнес на маркет плэйсе был куплен!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		}
	}
	else if ( categoryId == CATEGORY_BUSINESS )
	{
		buyMarketAd ( playerid, ownerId, idx ) ; // нужно обязательно обновить владельца полностью
		return_market_business ( playerid, modelId ) ;

		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Вы успешно приобрели данный бизнес. Используйте {"#cGN"}/bpanel{"#cGRInfo"} для управление бизнесом." ) ;
	 	SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Вам необходимо оплачивать налоги на недвижимость." ) ;
	 	SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Налоги списываются 1 раз в сутки. Для получения выписки рекомендуем обратиться в банк." ) ;
		PlayerPlaySound ( playerid, 1052, 0.0, 0.0, 0.0 ) ;

		if ( ! users_education [ playerid ] [ EDUCATION_BUY_BUSINESS ] )
		{
			show_window_monologue (
				playerid,
				5,
				"Поздравляю тебя с покупкой дома! \
				Не забывай оплачивать налоги. Налоги на недвижимость начисляются раз в сутки. \
				Оплатить их можно в банке или банкомате. Используй /gps, чтоб найти ближайший. \
				Если сумма долга превысит "tax_limit", то сотрудники Мэрии опечатать имущество для аукциона.",
				"Местный",
				"Понял"
			) ;

			save_user_education ( playerid, EDUCATION_BUY_BUSINESS ) ;
		}

		give_money ( playerid, -priceCount ) ;

		if ( targetId == INVALID_PLAYER_ID )
		{
			insert_debtor_message ( "Market Place", "Выставленный бизнес на маркет плэйсе был продан!\nПолучить деньги можно в банке подойдя к надписи \"получение переводов\".", ownerId ) ;
			insert_return_money ( "Market Place", priceCount, ownerId ) ;

			new query_string [ 100 ] ;
			format ( query_string, sizeof query_string, "(market) покупка бизнеса #%d у #%d", modelId, ownerId ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -priceCount, query_string ) ;
		}
		else
		{
			new query_string [ 144 ] ;
			format ( query_string, sizeof query_string, "(market) покупка Бизнеса #%d у %s", modelId, p_info [ targetId ] [ name ] ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -priceCount, query_string ) ;

			give_money ( targetId, priceCount ) ;

			format ( query_string, sizeof query_string, "(market) продажа Бизнеса #%d (%s)", modelId, p_info [ playerid ] [ name ] ) ;
			insert_money_log ( targetId, INVALID_PLAYER_ID, priceCount, query_string ) ;

			send_check_cinfo ( targetId, "Выставленный бизнес на маркет плэйсе был куплен!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		}
	}
	else
	{
		buyMarketAd ( playerid, -1, idx ) ; // не обязательно обновлять владельца полностью
		insertMarketPlace ( p_info [ playerid ] [ id ], modelId, 1, 0, 0, -1 ) ;

		give_money ( playerid, -priceCount ) ;
		send_check_cinfo ( playerid, "Предмет отправлен в отделение почты.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
			
		if ( targetId == INVALID_PLAYER_ID )
		{
			insert_debtor_message ( "Market Place", "Выставленный предмет на маркет плэйсе был продан!\nПолучить деньги можно в банке подойдя к надписи \"получение переводов\".", ownerId ) ;
			insert_return_money ( "Market Place", priceCount, ownerId ) ;

			new query_string [ 144 ] ;
			format ( query_string, sizeof query_string, "(market) покупка %s у #%d", item_name ( modelId ), ownerId ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -priceCount, query_string ) ;
		}
		else
		{
			new query_string [ 144 ] ;
			format ( query_string, sizeof query_string, "(market) покупка %s у %s", item_name ( modelId ), p_info [ targetId ] [ name ] ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -priceCount, query_string ) ;

			give_money ( targetId, priceCount ) ;

			format ( query_string, sizeof query_string, "(market) продажа %s (%s)", item_name ( modelId ), p_info [ playerid ] [ name ] ) ;
			insert_money_log ( targetId, INVALID_PLAYER_ID, priceCount, query_string ) ;

			send_check_cinfo ( targetId, "Выставленный предмет на маркет плэйсе был куплен!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		}
	}
	return 1 ;
}

stock handleTabletMarket ( playerid, actionId, data [ ] )
{
	if ( actionId == MARKET_APP ) // buy
	{
		new Node: json ;
        JSON_Parse ( data, json ) ;

        new idx, ownerId, categoryId, priceCount, renderType, modelId ;
        JSON_GetInt ( json, "id", idx ) ;
        JSON_GetInt ( json, "ownerId", ownerId ) ;
        JSON_GetInt ( json, "category", categoryId ) ;
        JSON_GetInt ( json, "price", priceCount ) ;
        JSON_GetInt ( json, "type", renderType ) ;
        JSON_GetInt ( json, "modelInsert", modelId ) ;

		if ( admin_info [ playerid ] [ admin ] > 0 && admin_info [ playerid ] [ admin ] < 8 )
		{
			send_check_cinfo ( playerid, "Администратор не может покупать на маркет плэйсе!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		if ( p_info [ playerid ] [ hour_played ] < THREE_HOUR_PLAYED )
		{
			send_check_cinfo ( playerid, "Доступно с 3 часов в игре!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		if ( p_info [ playerid ] [ money ] < priceCount )
		{
			send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		if ( categoryId == CATEGORY_HOUSES )
		{
			if ( Iter_Count(player_houses[playerid]) >= p_info [ playerid ] [ max_house ] )
			{
				send_check_cinfo ( playerid, "У Вас в собственности уже есть недвижимость!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
		}
		else if ( categoryId == CATEGORY_BUSINESS )
		{
			if ( Iter_Count(player_business[playerid]) >= p_info [ playerid ] [ max_biz ] )
			{
				send_check_cinfo ( playerid, "У Вас в собственности уже есть недвижимость!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
		}

		static const _str [ ] = "SELECT * FROM `market_item` WHERE `id` = '%d' LIMIT 1" ;
		new query_string [ sizeof _str + 9 ] ;
		format ( query_string, sizeof query_string, _str, idx ) ;
		mysql_tquery ( sql_connection, query_string, "callback_buy_market", "i", playerid ) ;
	}
	else if ( actionId == MARKET_APP + 1 ) // contact info
	{
		new bool: _player = false, ownerId = strval ( data ) ;
		foreach(new i: logged_players)
		{
			if ( p_info [ i ] [ id ] != ownerId ) continue ;

			_player = true ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 144, "Продавец в игре!\n%s[%d] - тел. %d", p_info [ i ] [ name ], i, p_info [ i ] [ number ] ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
			return 1 ;
		}

		if ( ! _player )
		{
			send_check_cinfo ( playerid, "Продавца нет в игре.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
	}
	else if ( actionId == MARKET_APP + 2 ) // info
	{
		send_check_cinfo ( playerid, "Вы выбрали своё объявление!\nДля его редактирования откройте 'мои объявления'.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
	}
	else if ( actionId == MARKET_APP + 3 ) // open market
	{
		p_t_info [ playerid ] [ in_market ] = true ;
	}
	else if ( actionId == MARKET_APP + 4 ) // close market
	{
		p_t_info [ playerid ] [ in_market ] = false ;
	}
	else if ( actionId == MARKET_APP + 5 ) // open item
	{
		new idx = strval ( data ) ;
		p_t_info [ playerid ] [ market_with_id ] = idx ;
	}
	else if ( actionId == MARKET_APP + 6 ) // open item and update watchers
	{
		new idx = strval ( data ) ;
		p_t_info [ playerid ] [ market_with_id ] = idx ;
		updateWatchers ( idx ) ;
	}
	else if ( actionId == MARKET_APP + 7 ) // error description empty
	{
		send_check_cinfo ( playerid, "Вы не указали описание.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
	}
	else if ( actionId == MARKET_APP + 8 ) // error price
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, 144, "Цена не может быть меньше 1"valute_title_" и более %s"valute_title_"", GetPlayerCashValueToSmile ( max_money ) ) ;
		send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
	}
	else if ( actionId == MARKET_APP + 9 ) // create ad
	{
		new Node: json ;
        JSON_Parse ( data, json ) ;

        new idx, categoryId ;
        JSON_GetInt ( json, "id", idx ) ;
        JSON_GetInt ( json, "category", categoryId ) ;
		
		if ( categoryId == CATEGORY_ACS )
		{
			new query_string [ 128 ] ;
			format ( query_string, sizeof query_string, "%s создал(а) объявление (ACS: %s)",
			p_info [ playerid ] [ name ], item_name ( GetUserAccessories ( playerid, ACS_MODEL, idx ) ) ) ;
			WriteLog ( playerid, TYPE_LOG_MARKET_PLACE, query_string ) ;

			clear_accessories ( playerid, GetUserAccessories ( playerid, ACS_ID, idx ) ) ;
		}
		else if ( categoryId == CATEGORY_SKINS )
		{
			new query_string [ 128 ] ;
			format ( query_string, sizeof query_string, "%s создал(а) объявление (SKINS: #%d)",
			p_info [ playerid ] [ name ], p_info [ playerid ] [ temp_skin ] [ idx ] ) ;
			WriteLog ( playerid, TYPE_LOG_MARKET_PLACE, query_string ) ;

			p_info [ playerid ] [ temp_skin ] [ idx ] = 0 ;

			new _query [ 126 ] ;
			format ( _query, sizeof ( _query ), "UPDATE `users` SET `u_tempskin`='%d|%d|%d|%d|%d' WHERE `u_id` = '%d' LIMIT 1",
			p_info [ playerid ] [ temp_skin ] [ 0 ], p_info [ playerid ] [ temp_skin ] [ 1 ], p_info [ playerid ] [ temp_skin ] [ 2 ],
			p_info [ playerid ] [ temp_skin ] [ 3 ], p_info [ playerid ] [ temp_skin ] [ 4 ], p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, _query ) ;
		}
		else if ( categoryId == CATEGORY_CARS )
		{
			foreach(new vehicleId: player_vehicles[playerid])
			{
				if ( veh_info [ vehicleId - 1 ] [ v_id ] != idx ) continue ;

		        Iter_Remove(player_vehicles[playerid], vehicleId ) ;
				DestroyVehicle ( vehicleId, 789 ) ;
				break ;
			}

			global_string [ 0 ] = EOS ;
			format ( global_string, 100, "DELETE FROM `users_vehicles` WHERE `v_id` = '%d' LIMIT 1", idx ) ;
			mysql_tquery ( sql_connection, global_string ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 144, "UPDATE `licence_plate` SET `licence_plate_use_own_car_id` = '0' WHERE `licence_plate_use_own_car_id` = '%d' LIMIT 1", idx ) ;
			mysql_tquery ( sql_connection, global_string ) ;

			new query_string [ 128 ] ;
			format ( query_string, sizeof query_string, "%s создал(а) объявление (CARS: #%d)",
			p_info [ playerid ] [ name ], idx ) ;
			WriteLog ( playerid, TYPE_LOG_MARKET_PLACE, query_string ) ;
		}
		else if ( categoryId == CATEGORY_HOUSES )
		{
			
		}
		else if ( categoryId == CATEGORY_BUSINESS )
		{
			
		}
		else if ( categoryId == CATEGORY_INVENTORY )
		{
			new query_string [ 128 ] ;
			format ( query_string, sizeof query_string, "%s создал(а) объявление (INV: %s)",
			p_info [ playerid ] [ name ], item_name ( GetUsersInventory ( playerid, INV_ITEM, idx ) ) ) ;
			WriteLog ( playerid, TYPE_LOG_MARKET_PLACE, query_string ) ;

			if ( GetUsersInventory ( playerid, INV_ITEM_TYPE, idx ) == INVENTORY_TYPE_ACCESSORIES )
				dropped_accessories ( GetUsersInventory ( playerid, INV_ITEM_ID, idx ) ) ;

			if ( GetUsersInventory ( playerid, INV_ITEM_TYPE, idx ) == INVENTORY_TYPE_SKINS )
				dropped_skins ( GetUsersInventory ( playerid, INV_ITEM_ID, idx ) ) ;

			clear_inventory (
				playerid,
				GetUsersInventory ( playerid, INV_ITEM, idx ),
				1
			) ;
		}

		//marketReset ( ) ;
		send_check_cinfo ( playerid, "Вы успешно выставили объявление.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
	}
	else if ( actionId == MARKET_APP + 10 ) // admin delete ad
	{
		new idx = strval ( data ) ;
		show_dialog ( playerid, d_admin_ad_delete, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Market Place", "{"#cWH"}Вы действительно хотите удалить объявление?", "Удалить", "Нет" ) ;
		set_player_use_listitem ( playerid, idx ) ;
	}
	else if ( actionId == MARKET_APP + 11 ) // admin blocked owner ad
	{
		new idx = strval ( data ) ;
		show_dialog ( playerid, d_admin_ad_blocked, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Market Place", "{"#cWH"}Вы действительно хотите заблокировать игроку подачу объявлений?", "Да", "Нет" ) ;
		set_player_use_listitem ( playerid, idx ) ;
	}
	else if ( actionId == MARKET_APP + 12 ) // open sell
	{
		if ( admin_info [ playerid ] [ admin ] > 0 && admin_info [ playerid ] [ admin ] < 8 )
		{
			send_check_cinfo ( playerid, "Администратор не может выкладывать объявления!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		if ( p_info [ playerid ] [ hour_played ] < THREE_HOUR_PLAYED )
		{
			send_check_cinfo ( playerid, "Доступно с 3 часов в игре!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		if ( p_info [ playerid ] [ market_block ] )
		{
			send_check_cinfo ( playerid, "Вы не можете подавать объявления!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}

		marketSellHouses ( playerid ) ;
		marketSellBusiness ( playerid ) ;
		marketSellAcs ( playerid ) ;
		marketSellSkins ( playerid ) ;
		marketSellCars ( playerid ) ;
		marketSellItems ( playerid ) ;
	}
	else if ( actionId == MARKET_APP + 13 ) // update ad
	{
		new idx = strval ( data ) ;
		marketResetId ( idx ) ;
	}
	else if ( actionId == MARKET_APP + 14 ) // delete ad
	{
		new Node: json ;
        JSON_Parse ( data, json ) ;

        new idx, categoryId, renderType, modelId ;
        JSON_GetInt ( json, "id", idx ) ;
        JSON_GetInt ( json, "category", categoryId ) ;
        JSON_GetInt ( json, "type", renderType ) ;
        JSON_GetInt ( json, "modelInsert", modelId ) ;

		if ( categoryId == CATEGORY_HOUSES )
		{
			deleteMarketAd ( playerid, idx ) ;
			send_check_cinfo ( playerid, "Объявление снято с публикации.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;

			new query_string [ 128 ] ;
			format ( query_string, sizeof query_string, "%s снял(а) объявление с публикации (Дом #%d)", p_info [ playerid ] [ name ], modelId ) ;
			WriteLog ( playerid, TYPE_LOG_MARKET_PLACE, query_string ) ;
		}
		else if ( categoryId == CATEGORY_BUSINESS )
		{
			deleteMarketAd ( playerid, idx ) ;
			send_check_cinfo ( playerid, "Объявление снято с публикации.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;

			new query_string [ 128 ] ;
			format ( query_string, sizeof query_string, "%s снял(а) объявление с публикации (Бизнес #%d)", p_info [ playerid ] [ name ], modelId ) ;
			WriteLog ( playerid, TYPE_LOG_MARKET_PLACE, query_string ) ;
		}
		else
		{
			new _return = give_inventory (
				playerid,
				modelId,
				1,
				0,
				"",
				"",
				NUMBERPLATE_TYPE_NONE,
				0
			) ;

			if ( _return == -1 )
			{
				send_check_cinfo ( playerid, "В инвентаре недостаточно места!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}

			new query_string [ 128 ] ;
			format ( query_string, sizeof query_string, "%s снял(а) объявление с публикации (%s)", p_info [ playerid ] [ name ], item_name ( modelId ) ) ;
			WriteLog ( playerid, TYPE_LOG_MARKET_PLACE, query_string ) ;

			deleteMarketAd ( playerid, idx ) ;
			send_check_cinfo ( playerid, "Объявление снято с публикации.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		}
	}
	else if ( actionId == MARKET_APP + 15 ) // created
	{
		send_check_cinfo ( playerid, "Объявление с выбранным товаром уже создано.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
	}
	return 1 ;
}

stock marketSellHouses ( playerid )
{
	new Node: node = JSON_Array ( ), itemsLoaded = 0, _str [ 48 ] ;
	foreach(new h: player_houses[playerid])
	{
		if ( h_info [ h - 1 ] [ h_podezd ] != -1 )
	    {
	    	format ( _str, sizeof _str, "Квартира %s (#%d)", house_classes [ house_int [ h_info [ h - 1 ] [ h_int ] - 1 ] [ hint_class ] ], h ) ;
		}
		else
		{
			format ( _str, sizeof _str, "Дом %s (#%d)", house_classes [ house_int [ h_info [ h - 1 ] [ h_int ] - 1 ] [ hint_class ] ], h ) ;
		}
		new Node: sellNode = JSON_Array (
			JSON_Object (
				"id",			JSON_Int ( h ),
				"ownerId",		JSON_Int ( p_info [ playerid ] [ id ] ),
				"category",		JSON_Int ( CATEGORY_HOUSES ),
				"name",			JSON_String ( _str ),
				"type",			JSON_Int ( -1 ),
				"model",		JSON_Int ( -1 ),
				"modelInsert",	JSON_Int ( h ),
				"color1",  		JSON_Int ( 1 ),
				"color2",      	JSON_Int ( 1 ),
				"rotX",			JSON_Float ( 20.0 ),
				"rotY",			JSON_Float ( 180.0 ),
				"rotZ",			JSON_Float ( 45.0 ),
				"zoom",			JSON_Float ( 0.78 )
			)
		) ;

		node = JSON_Append ( node, sellNode ) ;

		if ( ++ itemsLoaded == 5 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TABLET, MARKET_APP + 4, global_string ) ;

			itemsLoaded = 0 ;
			node = JSON_Array ( ) ;
		}
	}

	if ( itemsLoaded )
	{
		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, MARKET_APP + 4, global_string ) ;

		itemsLoaded = 0 ;
	}
	return 1 ;
}

stock return_market_houses ( playerid, _h_id )
{
	new house_id = _h_id, pl_id ;

	sscanf ( h_info [ house_id - 1 ] [ h_owner_name ], "u", pl_id ) ;
	if ( IsPlayerConnected( pl_id ) )
	{
		Iter_Remove(player_houses[pl_id], house_id);
	}

	p_info [ playerid ] [ house ] = house_id ;

	format ( h_info [ house_id - 1 ] [ h_owner_name ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;
	h_info [ house_id - 1 ] [ h_owner ] = p_info [ playerid ] [ id ] ;

	Iter_Add(player_houses[playerid], house_id);

	p_info [ playerid ] [ spawnchange ] = 1 ;
	update_int_sql ( playerid, "u_spawnchange", 1 ) ;

	PlayerPlaySound ( playerid, 1052, 0.0, 0.0, 0.0 ) ;

	h_info [ house_id - 1 ] [ h_sell_status ] =
	h_info [ house_id - 1 ] [ h_safe_code ] = 0 ;
			
	global_string [ 0 ] = EOS ;
	format ( global_string, 256, "UPDATE `houses` SET `h_owner` = '%d', `h_ownername` = '%s', `h_sell_status` = '0', `h_safe_code` = '0000' WHERE `h_id` = '%d' LIMIT 1",
	p_info [ playerid ] [ id ], p_info [ playerid ] [ name ], h_info [ house_id - 1 ] [ h_id ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;
	return 1 ;
}

stock marketSellBusiness ( playerid )
{
	new Node: node = JSON_Array ( ), itemsLoaded = 0, _str [ 32 ] ;
	foreach(new b: player_business[playerid])
	{
		format ( _str, sizeof _str, "%s (#%d)", b_types [ b_info [ b - 1 ] [ b_type ] ], b ) ;
		new Node: sellNode = JSON_Array (
			JSON_Object (
				"id",			JSON_Int ( b ),
				"ownerId",		JSON_Int ( p_info [ playerid ] [ id ] ),
				"category",		JSON_Int ( CATEGORY_BUSINESS ),
				"name",			JSON_String ( _str ),
				"type",			JSON_Int ( -1 ),
				"model",		JSON_Int ( -1 ),
				"modelInsert",	JSON_Int ( b ),
				"color1",  		JSON_Int ( 1 ),
				"color2",      	JSON_Int ( 1 ),
				"rotX",			JSON_Float ( 20.0 ),
				"rotY",			JSON_Float ( 180.0 ),
				"rotZ",			JSON_Float ( 45.0 ),
				"zoom",			JSON_Float ( 0.78 )
			)
		) ;

		node = JSON_Append ( node, sellNode ) ;

		if ( ++ itemsLoaded == 5 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TABLET, MARKET_APP + 4, global_string ) ;

			itemsLoaded = 0 ;
			node = JSON_Array ( ) ;
		}
	}

	if ( itemsLoaded )
	{
		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, MARKET_APP + 4, global_string ) ;

		itemsLoaded = 0 ;
	}
}

stock return_market_business ( playerid, _b_id )
{
	new b = _b_id - 1, pl_id ;

	sscanf ( b_info [ b ] [ b_owner_name ], "u", pl_id ) ;
	if ( IsPlayerConnected( pl_id ) )
	{
		Iter_Remove ( business_players[b + 1], pl_id ) ;
		Iter_Remove(player_business[pl_id], b_info [ b ][ b_id ]);
	}

	format ( b_info [ b ] [ b_owner_name ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;
	b_info [ b ] [ b_owner_inc ] = p_info [ playerid ] [ id ] ;
	p_info [ playerid ] [ business ] = b_info [ b ] [ b_id ] ;

	Iter_Add ( business_players[b + 1], playerid ) ;
	Iter_Add(player_business[playerid], b_info [ b ][ b_id ]);

	b_info [ b ] [ b_sell_status ] = 0 ;
			
	new query_string [ 144 ] ;
	format ( query_string, sizeof query_string, "UPDATE `businesses` SET `b_sell_status` = '0', `b_owner_inc` = '%d', `b_owner_name` = '%s' WHERE `b_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ], p_info [ playerid ] [ name ], b_info [ b ] [ b_id ] ) ;
	mysql_tquery ( sql_connection, query_string ) ;

	update_blabel ( b ) ;
	return 1 ;
}

stock marketSellAcs ( playerid )
{
	new Node: node = JSON_Array ( ), _model, itemsLoaded = 0 ;
	for ( new i = 0, Node: sellNode ; i < MAX_ACCESORIES ; i ++ )
	{
		_model = GetUserAccessories ( playerid, ACS_MODEL, i ) ;
		if ( _model < 1 ) continue ;

		sellNode = JSON_Array (
			JSON_Object (
				"id",			JSON_Int ( i ),
				"ownerId",		JSON_Int ( p_info [ playerid ] [ id ] ),
				"category",		JSON_Int ( CATEGORY_ACS ),
				"name",			JSON_String ( item_name ( _model ) ),
				"type",			JSON_Int ( item_render_type ( _model ) ),
				"model",		JSON_Int ( item_object_id ( _model ) ),
				"modelInsert",	JSON_Int ( _model ),
				"color1",  		JSON_Int ( item_color ( _model, 1 ) ),
				"color2",      	JSON_Int ( 1 ),
				"rotX",			JSON_Float ( 20.0 ),
				"rotY",			JSON_Float ( 180.0 ),
				"rotZ",			JSON_Float ( 45.0 ),
				"zoom",			JSON_Float ( 0.78 )
			)
		) ;

		node = JSON_Append ( node, sellNode ) ;

		if ( ++ itemsLoaded == 5 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TABLET, MARKET_APP + 4, global_string ) ;

			itemsLoaded = 0 ;
			node = JSON_Array ( ) ;
		}
	}

	if ( itemsLoaded )
	{
		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, MARKET_APP + 4, global_string ) ;

		itemsLoaded = 0 ;
	}
}

stock marketSellSkins ( playerid )
{
	new Node: node = JSON_Array ( ), _model, itemsLoaded = 0 ;
	for ( new i = 0, Node: sellNode ; i < 5 ; i ++ )
	{
		_model = p_info [ playerid ] [ temp_skin ] [ i ] ;

		if ( _model < 1 ) continue ;
		if ( getNewSkinModel ( playerid ) == _model ) continue ;

		sellNode = JSON_Array (
			JSON_Object (
				"id",			JSON_Int ( i ),
				"ownerId",		JSON_Int ( p_info [ playerid ] [ id ] ),
				"category",		JSON_Int ( CATEGORY_SKINS ),
				"name",			JSON_String ( item_name ( _model ) ),
				"type",			JSON_Int ( item_render_type ( _model ) ),
				"model",		JSON_Int ( item_object_id ( _model ) ),
				"modelInsert",	JSON_Int ( _model ),
				"color1",  		JSON_Int ( 1 ),
				"color2",      	JSON_Int ( 1 ),
				"rotX",			JSON_Float ( 20.0 ),
				"rotY",			JSON_Float ( 180.0 ),
				"rotZ",			JSON_Float ( 45.0 ),
				"zoom",			JSON_Float ( 0.78 )
			)
		) ;

		node = JSON_Append ( node, sellNode ) ;

		if ( ++ itemsLoaded == 5 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TABLET, MARKET_APP + 4, global_string ) ;

			itemsLoaded = 0 ;
			node = JSON_Array ( ) ;
		}
	}

	if ( itemsLoaded )
	{
		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, MARKET_APP + 4, global_string ) ;

		itemsLoaded = 0 ;
	}
}

stock marketSellCars ( playerid )
{
	new query_string [ 128 ] ;
	format ( query_string, sizeof query_string, "SELECT `v_id`, `v_model` FROM `users_vehicles` WHERE `v_owner` = '%d' LIMIT %d", 
	p_info [ playerid ] [ id ], p_info [ playerid ] [ max_veh ] ) ;
	mysql_tquery ( sql_connection, query_string, "callback_market_vehicle", "i", playerid ) ;
	return 1 ;
}

callback: callback_market_vehicle ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;

	new Node: node = JSON_Array ( ), _model, _id, itemsLoaded = 0 ;
	for ( new i = 0, Node: sellNode ; i < rows ; i ++ )
	{
		_id = cache_get_field_content_int ( i, "v_id" ) ;
		_model = cache_get_field_content_int ( i, "v_model" ) ;
		if ( _model < 1 || item_blocked ( playerid, _model, 1, i ) ) continue ;

		sellNode = JSON_Array (
			JSON_Object (
				"id",			JSON_Int ( _id ),
				"ownerId",		JSON_Int ( p_info [ playerid ] [ id ] ),
				"category",		JSON_Int ( CATEGORY_CARS ),
				"name",			JSON_String ( item_name ( _model ) ),
				"type",			JSON_Int ( item_render_type ( _model ) ),
				"model",		JSON_Int ( item_object_id ( _model ) ),
				"modelInsert",	JSON_Int ( _model ),
				"color1",  		JSON_Int ( 1 ),
				"color2",      	JSON_Int ( 1 ),
				"rotX",			JSON_Float ( 20.0 ),
				"rotY",			JSON_Float ( 180.0 ),
				"rotZ",			JSON_Float ( 45.0 ),
				"zoom",			JSON_Float ( 0.78 )
			)
		) ;

		node = JSON_Append ( node, sellNode ) ;

		if ( ++ itemsLoaded == 5 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TABLET, MARKET_APP + 4, global_string ) ;

			itemsLoaded = 0 ;
			node = JSON_Array ( ) ;
		}
	}

	if ( itemsLoaded )
	{
		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, MARKET_APP + 4, global_string ) ;

		itemsLoaded = 0 ;
	}
	return 1 ;
}

stock marketSellItems ( playerid )
{
	new Node: node = JSON_Array ( ), _model, _modelInsert, itemsLoaded = 0 ;
	for ( new i = 0, Node: sellNode ; i < MAX_INVENTORY_SLOTS ; i ++ )
	{
		_model = USERS_INVENTORY [ playerid ] [ i ] [ INV_ITEM ] ;
		if ( _model < 1 || item_blocked ( playerid, _model, 1, i ) ) continue ;

		_modelInsert = _model ;
		sellNode = JSON_Array (
			JSON_Object (
				"id",			JSON_Int ( i ),
				"ownerId",		JSON_Int ( p_info [ playerid ] [ id ] ),
				"category",		JSON_Int ( CATEGORY_INVENTORY ),
				"name",			JSON_String ( item_name ( _model ) ),
				"type",			JSON_Int ( item_render_type ( _model ) ),
				"model",		JSON_Int ( item_object_id ( _model ) ),
				"modelInsert",	JSON_Int ( _modelInsert ),
				"color1",  		JSON_Int ( item_color ( _model, 1 ) ),
				"color2",      	JSON_Int ( 1 ),
				"rotX",			JSON_Float ( 20.0 ),
				"rotY",			JSON_Float ( 180.0 ),
				"rotZ",			JSON_Float ( 45.0 ),
				"zoom",			JSON_Float ( 0.78 )
			)
		) ;

		node = JSON_Append ( node, sellNode ) ;

		if ( ++ itemsLoaded == 5 )
		{
			global_string [ 0 ] = EOS ;
			JSON_Stringify ( node, global_string, sizeof global_string ) ;
			onServerSendData ( playerid, UI_TABLET, MARKET_APP + 4, global_string ) ;

			itemsLoaded = 0 ;
			node = JSON_Array ( ) ;
		}
	}

	if ( itemsLoaded )
	{
		global_string [ 0 ] = EOS ;
		JSON_Stringify ( node, global_string, sizeof global_string ) ;
		onServerSendData ( playerid, UI_TABLET, MARKET_APP + 4, global_string ) ;

		itemsLoaded = 0 ;
	}
}

stock marketResetId ( adId )
{
	new fmt_str [ 12 ] ;
	format ( fmt_str, sizeof fmt_str, "%d", adId ) ;
	foreach (new i: logged_players)
	{
		if ( p_t_info [ i ] [ in_market ] )
		{
			onServerSendData ( i, UI_TABLET, MARKET_APP + 5, fmt_str ) ; // обновить просмотры
		}
	}
}

stock marketReset ( )
{
	foreach (new i: logged_players)
	{
		if ( p_t_info [ i ] [ in_market ] )
		{
			onServerSendData ( i, UI_TABLET, MARKET_APP + 3, "" ) ; // перезагрузить объявления
		}
	}
}

stock updateWatchers ( adId )
{
	new fmt_str [ 12 ] ;
	format ( fmt_str, sizeof fmt_str, "%d", adId ) ;
	foreach (new i: logged_players)
	{
		if ( p_t_info [ i ] [ in_market ] )
		{
			onServerSendData ( i, UI_TABLET, MARKET_APP + 2, fmt_str ) ; // обновить просмотры
		}
	}
	static const _str [ ] = "UPDATE `market_item` SET `watchers` = `watchers` + 1 WHERE `id` = '%d' LIMIT 1" ;
	new query_string [ sizeof _str + 9 ] ;
	format ( query_string, sizeof query_string, _str, adId ) ;
	mysql_tquery ( sql_connection, query_string ) ;
}

stock buyMarketAd ( playerid, ownerId, adId )
{
	static const _str [ ] = "DELETE FROM `market_item` WHERE `id` = '%d' LIMIT 1" ;
	new query_string [ sizeof _str + 9 ] ;
	format ( query_string, sizeof query_string, _str, adId ) ;
	mysql_tquery ( sql_connection, query_string ) ;

	new fmt_str [ 12 ] ;
	format ( fmt_str, sizeof fmt_str, "%d", adId ) ;
	foreach (new i: logged_players)
	{
		if ( p_t_info [ i ] [ in_market ] )
		{
			if ( p_t_info [ i ] [ market_with_id ] == adId && i != playerid )
			{
				send_check_cinfo ( i, "Объявление, которое Вы просматривали, купили!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				onServerSendData ( i, UI_TABLET, MARKET_APP + 1, "0" ) ; // вернуть с объявления
			}
			if ( ownerId == p_info [ i ] [ id ] )
			{
				onServerSendData ( i, UI_TABLET, MARKET_APP + 1, "3" ) ; // вернуть с объявления
			}
			onServerSendData ( i, UI_TABLET, MARKET_APP, fmt_str ) ; // обновить
		}
	}

	onServerSendData ( playerid, UI_TABLET, MARKET_APP + 1, "0" ) ; // вернуть с объявления
	onServerSendData ( playerid, UI_TABLET, MARKET_APP, fmt_str ) ; // обновить
	return 1 ;
}

stock deleteMarketAd ( playerid, adId )
{
	new fmt_str [ 12 ] ;
	format ( fmt_str, sizeof fmt_str, "%d", adId ) ;
	foreach (new i: logged_players)
	{
		if ( p_t_info [ i ] [ in_market ] )
		{
			if ( p_t_info [ i ] [ market_with_id ] == adId && i != playerid )
			{
				send_check_cinfo ( i, "Объявление, которое Вы просматривали, удалили!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				onServerSendData ( i, UI_TABLET, MARKET_APP + 1, "0" ) ; // вернуть с объявления
			}
			onServerSendData ( i, UI_TABLET, MARKET_APP, fmt_str ) ; // обновить
		}
	}

	static const _str [ ] = "DELETE FROM `market_item` WHERE `id` = '%d' LIMIT 1" ;
	new query_string [ sizeof _str + 9 ] ;
	format ( query_string, sizeof query_string, _str, adId ) ;
	mysql_tquery ( sql_connection, query_string ) ;

	onServerSendData ( playerid, UI_TABLET, MARKET_APP + 1, "0" ) ; // вернуть с объявления
	onServerSendData ( playerid, UI_TABLET, MARKET_APP, fmt_str ) ; // обновить
	return 1 ;
}

stock clearTabletMarketItem ( )
{
	mysql_tquery ( sql_connection, "SELECT `id`, `ownerId`, `category`, `modelInsert` FROM `market_item` WHERE `date` < NOW() - INTERVAL 3 DAY", "callback_clear_market" ) ;
	return 1 ;
}

callback: callback_clear_market ( )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;

	for ( new i = 0 ; i < rows ; i ++ )
	{
		new ownerId = cache_get_field_content_int ( i, "ownerId" ) ;
		new categoryId = cache_get_field_content_int ( i, "category" ) ;
		new modelInsert = cache_get_field_content_int ( i, "modelInsert" ) ;

		if ( categoryId == CATEGORY_ACS || categoryId == CATEGORY_CARS || 
			categoryId == CATEGORY_SKINS || categoryId == CATEGORY_INVENTORY )
		{
			insert_debtor_message ( "Market Place", "Срок Вашего объявления на маркет плэйсе закончился.\nПредметы отправлены на почту (/gps - Бизнесы).", ownerId ) ;
			insertMarketPlace ( ownerId, modelInsert, 1, NUMBERPLATE_TYPE_NONE, 0 ) ;
		}
	}

	mysql_tquery ( sql_connection, "DELETE FROM `market_item` WHERE `date` < NOW() - INTERVAL 3 DAY" ) ;
	return 1 ;
}

stock deleteForSellProperty ( idx, categoryId )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 100, "DELETE FROM `market_item` WHERE `category` = '%d' AND `modelInsert` = '%d' LIMIT 1", categoryId, idx ) ;
	mysql_tquery ( sql_connection, global_string ) ;
	return 1 ;
}