static const ROWS_PER_PAGE = 15 ;
static const AUCTION_TIME = 86_400 ;

static enum _:AUCTION_TYPES
{
    TYPE_BUSINESS,
    TYPE_HOUSE
}

static playerInAuction [ MAX_PLAYERS ] [ AUCTION_TYPES ] ;

static listOrder [ MAX_PLAYERS ] [ AUCTION_TYPES ] [ 5 ] ;
static playerSearch [ MAX_PLAYERS ] [ AUCTION_TYPES ] [ 48 ] ;

static Iterator: auctionBusiness<MAX_BUSINESS> ;
static Iterator: auctionHouses<MAX_HOUSES> ;

static activeAuctionCounter ;

stock AddAuctionBusiness ( businessIdx )
{
    return Iter_Add(auctionBusiness, businessIdx);
}

stock AddAuctionHouse ( houseIdx )
{
    return Iter_Add(auctionHouses, houseIdx);
}

stock GetPlayerAuctionPropertyID ( playerid )
{
	static const _str [ ] = "\
		SELECT \
            IFNULL(am2.auction_property_sql_id, 0) AS auction_property_sql_id_2, \
            IFNULL(am3.auction_property_sql_id, 0) AS auction_property_sql_id_3 \
        FROM auction_member am \
        LEFT JOIN auction_member am2 ON am2.auction_member_char_id = am.auction_member_char_id AND am2.auction_property_type = 0 \
        LEFT JOIN auction_member am3 ON am3.auction_member_char_id = am.auction_member_char_id AND am3.auction_property_type = 1 \
        WHERE am.auction_member_char_id = %d LIMIT 2" ;
	new query_string [ sizeof _str + 9 ] ;
    format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
    mysql_tquery ( sql_connection, SQL_QUERY, "LoadPlayerAuctionPropertyID", "i", playerid ) ;
    return true ;
}

callback: LoadPlayerAuctionPropertyID ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	
	if ( rows )
	{
		playerInAuction [ playerid ] [ TYPE_BUSINESS ] = cache_get_field_content_int ( 0, "auction_property_sql_id_2" ) ;
		playerInAuction [ playerid ] [ TYPE_HOUSE ] = cache_get_field_content_int ( 0, "auction_property_sql_id_3" ) ;
	}
    else
    {
        playerInAuction [ playerid ] [ TYPE_BUSINESS ] =
        playerInAuction [ playerid ] [ TYPE_HOUSE ] = 0 ;
    }
    return true ;
}

stock handleTabletAuctions ( playerid, actionId, data [ ] )
{
	if ( actionId == AUCTIONS_APP ) // аукционы
	{
		new Node: json ;
        JSON_Parse ( data, json ) ;

        new currentPage, auctionType ;
        JSON_GetInt ( json, "currentPage", currentPage ) ;
        JSON_GetInt ( json, "type", auctionType ) ;

		if ( currentPage == 0 ) 
        {
            if ( auctionType == 0 ) 
            {
           		UpdateAuctionInterfaceBankMoney ( playerid ) ;
                UpdateAuctionInterfaceStats ( playerid ) ;
            }
            playerSearch [ playerid ] [ auctionType ] [ 0]  = EOS ;
        }

        if ( playerSearch [ playerid ] [ auctionType ] [ 0 ] != EOS ) currentPage -= 1 ;

		p_t_info [ playerid ] [ in_auctions ] = true ;
        GetAuctionPage ( playerid, auctionType, currentPage, listOrder [ playerid ] [ auctionType ] ) ;
	}
	else if ( actionId == SEARCH_BY_CATEGORY ) // // Поиск в категории по имени
	{
		new Node:node ;
        JSON_Parse ( data, node ) ;

        new auctionType, searchString [ 26 ] ;
        JSON_GetInt ( node, "type", auctionType ) ;
        JSON_GetString ( node, "searchString", searchString ) ;

	}
	else if ( actionId == MAKE_BET_AUCTION ) // Сделать ставку
	{
		new Node: json ;
        JSON_Parse ( data, json ) ;

        new propertyId, auctionType ;
        JSON_GetInt ( json, "id", propertyId ) ;
        JSON_GetInt ( json, "type", auctionType ) ;

        OnPlayerClickAuctionProperty ( playerid, propertyId, auctionType ) ;
	}
	else if ( actionId == SHOW_GEO_AUCTION ) // Показать на карте
	{
		new Node: node ;
        JSON_Parse ( data, node ) ;

        new propertyId, auctionType ;
        JSON_GetInt ( node, "id", propertyId ) ;
        JSON_GetInt ( node, "type", auctionType ) ;

        new propertyIdx = GetAuctionPropertyIdxById ( propertyId, auctionType ),
        	Float: posX, Float: posY, Float: posZ ;
        if ( auctionType == TYPE_BUSINESS ) 
        {
            posX = b_info [ propertyIdx - 1 ] [ b_position ] [ 0 ] ;
            posY = b_info [ propertyIdx - 1 ] [ b_position ] [ 1 ] ;
            posZ = b_info [ propertyIdx - 1 ] [ b_position ] [ 2 ] ;
        }
        else
        {
            posX = h_info [ propertyIdx - 1 ] [ h_pos ] [ 0 ] ;
            posY = h_info [ propertyIdx - 1 ] [ h_pos ] [ 1 ] ;
            posZ = h_info [ propertyIdx - 1 ] [ h_pos ] [ 2 ] ;
        }

		SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
		is_gps_used { playerid } = 1 ;

		SetPlayerRaceCheckpoint ( playerid, 1, posX, posY, posZ, 0.0, 0.0, 0.0, 2.0 ) ;
	}
	else if ( actionId == EXIT_AUCTIONS ) // Выйти с аукциона
	{
        format ( listOrder [ playerid ] [ TYPE_BUSINESS ], 5, "DESC" ) ;
        format ( listOrder [ playerid ] [ TYPE_HOUSE ], 5, "DESC" ) ;

		p_t_info [ playerid ] [ in_auctions ] = false ;
	}
	else if ( actionId == SORT_AUCTIONS ) // Сортировка
	{
        new Node: node ;
        JSON_Parse ( data, node ) ;

        new auctionType ;
        JSON_GetInt ( node, "type", auctionType ) ;            
        JSON_GetString ( node, "sortType", listOrder [ playerid ] [ auctionType ], 5 ) ;

        GetAuctionPage ( playerid, auctionType, 0, listOrder [ playerid ] [ auctionType ] ) ;
	}
	else if ( actionId == GET_MY_AUCTIONS ) // Меню "Мои аукционы"
	{
		GetMyAuctionBets ( playerid ) ;
	}
	return 1 ;
}

static stock GetAuctionPage ( playerid, auctionType, page, const orderType [ ] = "DESC" )
{
    if ( auctionType == TYPE_BUSINESS )
    {
		static const _str [ ] = "\
            SELECT \
                b.b_id AS id, \
                UNIX_TIMESTAMP(b.b_auction_date) AS auction_date, \
                b.b_auction_bet AS auction_bet, \
                IFNULL(u.u_name, '') AS u_name, \
                IF(am.auction_member_char_id != b.b_auction_player, 1, 0) AS is_override \
            FROM businesses b \
            LEFT JOIN users u ON b.b_auction_player=u.u_id \
            LEFT JOIN auction_member am ON am.auction_property_type = 1 AND am.auction_property_sql_id = b.b_id AND am.auction_member_char_id = %d \
            WHERE b.b_owner_inc = 0 %s \
            ORDER BY b.b_auction_bet %s \
            LIMIT 15 OFFSET %d" ;
		new query_string [ sizeof _str + 144 ] ;
        format ( query_string, 624, _str, p_info [ playerid ] [ id ], playerSearch [ playerid ] [ TYPE_BUSINESS ], orderType, page * ROWS_PER_PAGE ) ;
        mysql_tquery ( sql_connection, query_string, "LoadAuctionPage", "ii", playerid, TYPE_BUSINESS ) ;
    }
    else
    {
		static const _str [ ] = "\
            SELECT \
                h.h_id AS id, \
                UNIX_TIMESTAMP(h.h_auction_date) AS auction_date, \
                h.h_auction_bet AS auction_bet, \
                IFNULL(u.u_name, '') AS u_name, \
                IF(am.auction_member_char_id != h.h_auction_player, 1, 0) AS is_override \
            FROM houses h \
            LEFT JOIN users u ON h.h_auction_player=u.u_id \
            LEFT JOIN auction_member am ON am.auction_property_type = 1 AND am.auction_property_sql_id = h.h_id AND am.auction_member_char_id = %d \
            WHERE h.h_owner = 0 %s \
            ORDER BY h.h_auction_bet %s \
            LIMIT 15 OFFSET %d" ;
		new query_string [ sizeof _str + 144 ] ;
        format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ], playerSearch [ playerid ] [ TYPE_HOUSE ], orderType, page * ROWS_PER_PAGE ) ;
        mysql_tquery ( sql_connection, query_string, "LoadAuctionPage", "ii", playerid, TYPE_HOUSE ) ;
    }
    return true ;
}

callback: LoadAuctionPage ( playerid, auctionType )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return false ;

    new Node: node = JSON_Array ( ),
        sqlId, sqlAuctionEnd, sqlBet, sqlBetCharName [ MAX_PLAYER_NAME ],
		sqlBetOverride, sqlPropertyName [ 24 ] = "Дом" ;

    for ( new i = 0, Node: itemNode ; i < rows ; i ++ )
    {
		sqlId = cache_get_field_content_int ( i, "id" ) ;
		sqlBet = cache_get_field_content_int ( i, "auction_bet" ) ;
		sqlAuctionEnd = cache_get_field_content_int ( i, "auction_date" ) ;
		sqlBetOverride = cache_get_field_content_int ( i, "is_override" ) ;

		cache_get_field_content ( i, "u_name", sqlBetCharName ) ;

        if ( auctionType == TYPE_BUSINESS )
			format ( sqlPropertyName, sizeof sqlPropertyName, "%s", b_types [ b_info [ sqlId - 1 ] [ b_type ] ] ) ;

        itemNode = JSON_Array (
            JSON_Object (
                "id",               JSON_Int ( sqlId ),
                "type",             JSON_Int ( auctionType ),
                "name",             JSON_String ( sqlPropertyName ),
                "bet",              JSON_Int ( sqlBet ),
                "userName",         JSON_String ( sqlBetCharName ),
                "endOfAuction",     JSON_Int ( sqlAuctionEnd ),
                "isBetOverride",    JSON_Int ( sqlBetOverride )
            )
        ) ;
        node = JSON_Append ( node, itemNode ) ;
    }

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, AUCTIONS_APP + 2, global_string ) ;
    return true ;
}

static stock GetMyAuctionBets ( playerid )
{
	static const _str [ ] = "\
        SELECT \
            am.auction_property_type, \
            h.h_id, \
            h.h_auction_bet, \
            UNIX_TIMESTAMP(h.h_auction_date) AS h_auction_date, \
            IF(h.h_auction_player != am.auction_member_char_id, 1, 0) AS h_auction_player, \
            IFNULL(uh.u_name, '') AS h_owner_name, \
            b.b_id, \
            b.b_auction_bet, \
            UNIX_TIMESTAMP(b.b_auction_date) AS b_auction_date, \
            IF(b.b_auction_player != am.auction_member_char_id, 1, 0) AS b_auction_player, \
            IFNULL(ub.u_name, '') AS b_owner_name \
        FROM auction_member am \
        LEFT JOIN businesses b ON b.b_id = am.auction_property_sql_id AND am.auction_property_type = 0 \
        LEFT JOIN houses h ON h.h_id = am.auction_property_sql_id AND am.auction_property_type = 1 \
        LEFT JOIN users ub ON ub.u_id=b.b_auction_player \
        LEFT JOIN users uh ON uh.u_id=h.h_auction_player \
        WHERE am.auction_member_char_id = %d LIMIT 2" ;
	new query_string [ sizeof _str + 9 ] ;
    format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
    mysql_tquery ( sql_connection, query_string, "LoadMyAuctionBets", "i", playerid ) ;
    return true ;
}

callback: LoadMyAuctionBets ( playerid )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return false ;

    new Node: node = JSON_Array ( ),
        auctionType, sqlId, sqlAuctionEnd, sqlBet,
		sqlBetCharName [ MAX_PLAYER_NAME ], sqlBetOverride, sqlPropertyName [ 24 ] = "Дом" ;

    for ( new i = 0, Node: itemNode ; i < rows ; i ++ )
    {
		auctionType = cache_get_field_content_int ( i, "auction_property_type" ) ;

        if ( auctionType == TYPE_HOUSE )
        {
			sqlId = cache_get_field_content_int ( i, "h_id" ) ;
			sqlBet = cache_get_field_content_int ( i, "h_auction_bet" ) ;
			sqlAuctionEnd = cache_get_field_content_int ( i, "h_auction_date" ) ;
			sqlBetOverride = cache_get_field_content_int ( i, "h_auction_player" ) ;

			cache_get_field_content ( i, "h_owner_name", sqlBetCharName ) ;

            format ( sqlPropertyName, 4, "Дом" ) ;
        }
        else
        {
			sqlId = cache_get_field_content_int ( i, "b_id" ) ;
			sqlBet = cache_get_field_content_int ( i, "b_auction_bet" ) ;
			sqlAuctionEnd = cache_get_field_content_int ( i, "b_auction_date" ) ;
			sqlBetOverride = cache_get_field_content_int ( i, "b_auction_player" ) ;

			cache_get_field_content ( i, "b_owner_name", sqlBetCharName ) ;

			format ( sqlPropertyName, sizeof sqlPropertyName, "%s", b_types [ b_info [ sqlId - 1 ] [ b_type ] ] ) ;
        }

        itemNode = JSON_Array (
            JSON_Object (
                "id",               JSON_Int ( sqlId ),
                "type",             JSON_Int ( auctionType ),
                "name",             JSON_String ( sqlPropertyName ),
                "bet",              JSON_Int ( sqlBet ),
                "userName",         JSON_String ( sqlBetCharName ),
                "endOfAuction",     JSON_Int ( sqlAuctionEnd ),
                "isBetOverride",    JSON_Int ( sqlBetOverride )
            )
        ) ;
        node = JSON_Append ( node, itemNode ) ;
    }

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_TABLET, AUCTIONS_APP + 5, global_string ) ;
    return true ;
}

static stock OnPlayerClickAuctionProperty ( playerid, propertyId, auctionType )
{
    if ( auctionType == TYPE_BUSINESS )
    {
        new playerBusinessIdBet = playerInAuction [ playerid ] [ TYPE_BUSINESS ] ;
        if ( playerBusinessIdBet > 0 && playerBusinessIdBet != propertyId ) 
        {
            new charId = p_info [ playerid ] [ id ] ;
            foreach(new idx: auctionBusiness)
            {
                if ( b_info [ idx - 1 ] [ b_auction_player ] == charId )
				{
					send_check_cinfo ( playerid, "Вы уже сделали ставку на другой бизнес!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
                    return true ;
                }
            }
        }

        new businessIdx = GetAuctionPropertyIdxById ( propertyId, TYPE_BUSINESS ) ;
        if ( businessIdx == -1 )
		{
			send_check_cinfo ( playerid, "Этот бизнес не найден в списке!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            return true ;
        }

        if ( Iter_Count(player_business[playerid]) >= p_info [ playerid ] [ max_biz ] )
        {
			global_string [ 0 ] = EOS ;
            format ( global_string, 144, "У Вас имеется максимальное количество бизнесов: %d шт.", p_info [ playerid ] [ max_biz ] ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            return true ;
        }

        new currentBetCharId = b_info [ businessIdx - 1 ] [ b_auction_player ] ;
        if ( currentBetCharId == 0 )
        {
			global_string [ 0 ] = EOS ;
            format ( global_string, 512, "\
                {FFFFFF}Вы выбрали бизнес: {"#cAuction"}%s №%d\n\n\
                {FFFFFF}На данный тип имущества никто еще не поставил ставку.\n\
                Вы можете внести ставку в размере гос.стоимости - {"#cTN"}%s "valute_title_", {FFFFFF}или же выше гос.стоимости (предела нет).\n\n\
                {"#cGRDialog"}* Ниже гос.стоимости поставить ставку нельзя!\n\
                {"#cGRDialog"}* Деньги списываются с Вашего счёта.", 
                b_types [ b_info [ businessIdx - 1 ] [ b_type ] ],
                businessIdx,
                GetPlayerCashValueToSmile ( b_info [ businessIdx - 1 ] [ b_price ] )
            ) ;
        }
        else
        {
            if ( currentBetCharId == p_info [ playerid ] [ id ] )
			{
				send_check_cinfo ( playerid, "Вы уже сделали ставку на этот бизнес!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return true ;
			}

            new currentBet = b_info [ businessIdx - 1 ] [ b_auction_bet ], minimalBet = floatround ( currentBet * 1.1 ) ;

			global_string [ 0 ] = EOS ;
            format ( global_string, 512, "\
                {FFFFFF}Вы выбрали бизнес: {"#cAuction"}%s №%d\n\n\
                {FFFFFF}На данный тип имущества уже стоит ставка в размере {"#cTN"}%s "valute_title_"\n\
                {FFFFFF}Вы можете ее перебить в {"#cOR"}+10%% {FFFFFF}от нынешней ставки.\n\n\
                {"#cGRDialog"}* Минимальная возможная ставка: {"#cTN"}%s "valute_title_" {"#cGRDialog"}и выше.\n\
                {"#cGRDialog"}* Деньги списываются с Вашего счёта.", 
                b_types [ b_info [ businessIdx - 1 ] [ b_type ] ],
                businessIdx,
                GetPlayerCashValueToSmile ( currentBet ),
                GetPlayerCashValueToSmile ( minimalBet )
            ) ;
        }

        SetPVarInt ( playerid, "auction:typeId", TYPE_BUSINESS ) ;
        SetPVarInt ( playerid, "auction:propertyIdx", businessIdx ) ;

		show_dialog ( playerid, d_place_auction_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Аукцион бизнесов", global_string, "Поставить", "Отмена" ) ;
    }
    else
    {
        new playerHouseIdBet = playerInAuction [ playerid ] [ TYPE_HOUSE ] ;
        if ( playerHouseIdBet != 0 && playerHouseIdBet != propertyId ) 
        {
            new charId = p_info [ playerid ] [ id ] ;
            foreach(new idx: auctionHouses)
            {
				if ( h_info [ idx - 1 ] [ h_auction_player ] == charId )
				{
					send_check_cinfo ( playerid, "Вы уже сделали ставку на другой дом!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
                    return true ;
                }
            }
        }

        new houseIdx = GetAuctionPropertyIdxById ( propertyId, TYPE_HOUSE ) ;
        if ( houseIdx == -1 )
		{
			send_check_cinfo ( playerid, "Этот дом не найден в списке!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            return true ;
        }

		if ( Iter_Count(player_houses[playerid]) >= p_info [ playerid ] [ max_house ] )
        {
			global_string [ 0 ] = EOS ;
            format ( global_string, 144, "У Вас имеется максимальное количество домов: %d шт.", p_info [ playerid ] [ max_house ] ) ;
			send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            return true ;
        }

        new currentBetCharId = h_info [ houseIdx - 1 ] [ h_auction_player ] ;
        if ( currentBetCharId == 0 )
        {
            global_string [ 0 ] = EOS ;
            format ( global_string, 512, "\
                {FFFFFF}Вы выбрали: {"#cAuction"}Дом №%d\n\n\
                {FFFFFF}На данный тип имущества никто еще не поставил ставку.\n\
                Вы можете внести ставку в размере гос.стоимости - {"#cTN"}%s "valute_title_", {FFFFFF}или же выше гос.стоимости (предела нет).\n\n\
                {"#cGRDialog"}* Ниже гос.стоимости поставить ставку нельзя!\n\
                {"#cGRDialog"}* Деньги списываются с Вашего банковского счёта.", 
                houseIdx,
                GetPlayerCashValueToSmile ( h_info [ houseIdx - 1 ] [ h_price ] )
            ) ;
        }
        else
        {
            if ( currentBetCharId == p_info [ playerid ] [ id ] )
			{
				send_check_cinfo ( playerid, "Вы уже сделали ставку на этот дом!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
				return true ;
			}

            new currentBet = h_info [ houseIdx - 1 ] [ h_auction_bet ], minimalBet = floatround ( currentBet * 1.1 ) ;

            global_string [ 0 ] = EOS ;
            format ( global_string, 512, "\
                {FFFFFF}Вы выбрали: {"#cAuction"}Дом №%d\n\n\
                {FFFFFF}На данный тип имущества уже стоит ставка в размере {"#cTN"}%s "valute_title_"\n\
                {FFFFFF}Вы можете ее перебить в {"#cOR"}+10%% {FFFFFF}от нынешней ставки.\n\n\
                {"#cGRDialog"}* Минимальная возможная ставка: {"#cTN"}%s "valute_title_" {"#cGRDialog"}и выше.\n\
                {"#cGRDialog"}* Деньги списываются с Вашего банковского счёта.", 
                houseIdx,
                GetPlayerCashValueToSmile ( currentBet ),
                GetPlayerCashValueToSmile ( minimalBet )
            ) ;
        }

        SetPVarInt ( playerid, "auction:typeId", TYPE_HOUSE ) ;
        SetPVarInt ( playerid, "auction:propertyIdx", houseIdx ) ;

		show_dialog ( playerid, d_place_auction_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Аукцион домов", global_string, "Поставить", "Отмена" ) ;
    }
    return true ;
}

stock t_auctions_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused listitem
	switch ( dialogid )
	{
		case d_place_auction_bet:
		{
			if ( ! response ) return 1 ;

			new auctionType = GetPVarInt ( playerid, "auction:typeId" ),
				propertyIdx = GetPVarInt ( playerid, "auction:propertyIdx" ),
				bet = strval ( inputtext ) ;

			if ( auctionType == TYPE_BUSINESS )
			{
				if ( b_info [ propertyIdx - 1 ] [ b_owner_inc ] > 0 )
				{
					send_check_cinfo ( playerid, "У этого бизнеса уже есть владелец!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return true ;
				}

				new lastBetCharacter = b_info [ propertyIdx - 1 ] [ b_auction_player ] ;
				if ( lastBetCharacter == 0 ) // Первая ставка
				{  
					if ( bet < b_info [ propertyIdx - 1 ] [ b_price ] )
					{
						send_check_cinfo ( playerid, "Ваша ставка слишком низкая!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return true ;
					}

					if ( p_info [ playerid ] [ money ] < bet )
					{
						send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return true ;
					}

					b_info [ propertyIdx - 1 ] [ b_auction_date ] = gettime ( ) + AUCTION_TIME ;
				}
				else
				{
					new currentBet = b_info [ propertyIdx - 1 ] [ b_auction_bet ],
						minimalBet = floatround ( currentBet * 1.1 ) ;

					if ( bet < minimalBet )
					{
						send_check_cinfo ( playerid, "Ваша ставка слишком низкая!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return true ;
					}

					if ( p_info [ playerid ] [ money ] < bet )
					{
						send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return true ;
					}

					ReturnAuctionBet ( lastBetCharacter, currentBet, b_types [ b_info [ propertyIdx - 1 ] [ b_type ] ] ) ;
				}
				b_info [ propertyIdx - 1 ] [ b_auction_player ] = p_info [ playerid ] [ id ] ;
				b_info [ propertyIdx - 1 ] [ b_auction_bet ] = bet ;
			}
			else
			{
				if ( h_info [ propertyIdx - 1 ] [ h_owner ] > 0 )
				{
					send_check_cinfo ( playerid, "У этого дома уже есть владелец!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return true ;
				}

				new lastBetCharacter = h_info [ propertyIdx - 1 ] [ h_auction_player ] ;
				if ( lastBetCharacter == 0 ) // Первая ставка
				{   
					if ( bet < h_info [ propertyIdx - 1 ] [ h_price ] )
					{
						send_check_cinfo ( playerid, "Ваша ставка слишком низкая!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return true ;
					}

					if ( p_info [ playerid ] [ money ] < bet )
					{
						send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return true ;
					}

					h_info [ propertyIdx - 1 ] [ h_auction_date ] = gettime ( ) + AUCTION_TIME ;
				}
				else
				{
					new currentBet = h_info [ propertyIdx - 1 ] [ h_auction_bet ],
						minimalBet = floatround ( currentBet * 1.1 ) ;

					if ( bet < minimalBet )
					{
						send_check_cinfo ( playerid, "Ваша ставка слишком низкая!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return true ;
					}

					if ( p_info [ playerid ] [ money ] < bet )
					{
						send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
						return true ;
					}

					ReturnAuctionBet ( lastBetCharacter, currentBet, "Дом" ) ;
				}
				h_info [ propertyIdx - 1 ] [ h_auction_player ] = p_info [ playerid ] [ id ] ;
				h_info [ propertyIdx - 1 ] [ h_auction_bet ] = bet ;
			}

			give_money ( playerid, -bet ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, -bet, "Ставка на аукцион" ) ;
			UpdateAuctionInterfaceBankMoney ( playerid ) ;

			InsertAuctionMember ( playerid, auctionType, propertyIdx ) ;
			SavePropertyBetInfo ( propertyIdx, auctionType ) ;
			UpdateAuctionInterfaceProperty ( propertyIdx, auctionType, p_info [ playerid ] [ name ] ) ;

			UpdateAuctionInterfaceStats ( ) ;
			return 1 ;
		}
	}
	return 0 ;
}

static stock ReturnAuctionBet ( charId, moneyValue, const propertyName [ ] )
{
    new playerid = GetPlayerIDBySqlID ( charId ) ;
    if ( playerid != INVALID_PLAYER_ID )
    {
		global_string [ 0 ] = EOS ;
		format ( global_string, 256, "\
			Ваша ставка за %s в размере %d"valute_title_" была перебита\n\
            Деньги за ставку возвращены на Ваш банковский счёт",
			propertyName, moneyValue ) ;
		insert_debtor_message ( "Аукцион", global_string, charId ) ;
		insert_return_money ( "Аукцион", moneyValue, charId ) ;

		send_check_cinfo ( playerid, "Вашу ставку на аукционе перебили!\nИспользуйте /rm для возврата средств.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
    }
    else
    {
		global_string [ 0 ] = EOS ;
		format ( global_string, 256, "\
			Ваша ставка за %s в размере %d"valute_title_" была перебита\n\
            Деньги за ставку возвращены на Ваш банковский счёт",
			propertyName, moneyValue ) ;
		insert_debtor_message ( "Аукцион", global_string, charId ) ;
		insert_return_money ( "Аукцион", moneyValue, charId ) ;
    }
    return true ;
}

static stock InsertAuctionMember ( playerid, auctionType, propertyId )
{
	new query_string [ 256 ] ;
    format ( query_string, sizeof query_string, "\
        INSERT INTO auction_member (auction_member_char_id, auction_property_type, auction_property_sql_id) \
        VALUES ('%d', '%d', '%d') \
        ON DUPLICATE KEY UPDATE auction_property_sql_id = '%d'",
        p_info [ playerid ] [ id ], auctionType, propertyId,
        propertyId
    ) ;
    mysql_tquery ( sql_connection, query_string ) ;

    playerInAuction [ playerid ] [ auctionType ] = propertyId ;
    return true ;
}

static stock SavePropertyBetInfo ( propertyIdx, auctionType )
{
    if ( auctionType == TYPE_BUSINESS )
    {
		global_string [ 0 ] = EOS ;
        format ( global_string, 256, "\
            UPDATE businesses SET \
                b_auction_date = FROM_UNIXTIME(%d), \
                b_auction_bet = %d, \
                b_auction_player = %d \
            WHERE id = %d LIMIT 1", 
            b_info [ propertyIdx - 1 ] [ b_auction_date ],
            b_info [ propertyIdx - 1 ] [ b_auction_bet ],
            b_info [ propertyIdx - 1 ] [ b_auction_player ],
            b_info [ propertyIdx - 1 ] [ b_id ]
        ) ;
        mysql_tquery ( sql_connection, global_string ) ;
    }
    else
    {
		global_string [ 0 ] = EOS ;
        format ( global_string, 256, "\
            UPDATE houses SET \
                h_auction_date = FROM_UNIXTIME(%d), \
                h_auction_bet = %d, \
                h_auction_player = %d \
            WHERE id = %d LIMIT 1", 
            h_info [ propertyIdx - 1 ] [ h_auction_date ],
            h_info [ propertyIdx - 1 ] [ h_auction_bet ],
            h_info [ propertyIdx - 1 ] [ h_auction_player ],
            h_info [ propertyIdx - 1 ] [ h_id ]
        ) ;
        mysql_tquery ( sql_connection, global_string ) ;
    }
    return true ;
}

static stock EndPropertyAuction ( propertyIdx, propertyType )
{
    new propertyId, ownerId ;
    if ( propertyType == TYPE_BUSINESS )
    {
        propertyId = b_info [ propertyIdx - 1 ] [ b_id ] ;
        ownerId = b_info [ propertyIdx - 1 ] [ b_auction_player ] ;

        new playerid = GetPlayerIDBySqlID ( ownerId ) ;
        if ( playerid == INVALID_PLAYER_ID ) 
        {
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "Вы победили в аукционе за %s", b_types [ b_info [ propertyId - 1 ] [ b_type ] ] ) ;
			insert_debtor_message ( "Аукцион", global_string, ownerId ) ;

            SetBussinessOwnerByCharId ( propertyIdx, ownerId ) ;

			new sql_string [ 100 ] ;
			format ( sql_string, sizeof sql_string, "SELECT u_name FROM users WHERE u_id = %d LIMIT 1", ownerId ) ;
			mysql_tquery ( sql_connection, sql_string, "SetBussinessOwnerByCharId", "ii", propertyIdx, ownerId ) ;
        }
        else 
        {
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "\
				Вы победили в аукционе за \"%s\"", b_types [ b_info [ propertyId - 1 ] [ b_type ] ] ) ;
            send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
    		
			SetBusinessOwner ( propertyIdx, playerid ) ;
        }
    }
    else
    {
        propertyId = h_info [ propertyIdx - 1 ] [ h_id ] ;
        ownerId = h_info [ propertyIdx - 1 ] [ h_auction_player ] ;

        new playerid = GetPlayerIDBySqlID ( ownerId ) ;
        if ( playerid == INVALID_PLAYER_ID ) 
        {
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "Вы победили в аукционе за Дом №%d", propertyId ) ;
			insert_debtor_message ( "Аукцион", global_string, ownerId ) ;

			new sql_string [ 100 ] ;
			format ( sql_string, sizeof sql_string, "SELECT u_name FROM users WHERE u_id = %d LIMIT 1", ownerId ) ;
			mysql_tquery ( sql_connection, sql_string, "SetHouseOwnerByCharId", "ii", propertyIdx, ownerId ) ;
        }
        else
        {
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "\
				Вы победили в аукционе за Дом №%d", propertyId ) ;
            send_check_cinfo ( playerid, global_string, 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;

			SetHouseOwner ( propertyId, playerid ) ;
		}
    }

    RemoveAuctionInterfaceProperty ( propertyId, propertyType ) ;
    return true ;
}

callback: SetBussinessOwnerByCharId ( propertyIdx, ownerId )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return false ;

	new playerName [ MAX_PLAYER_NAME ] ;
	cache_get_field_content ( 0, "u_name", playerName ) ;

	format ( b_info [ propertyIdx - 1 ] [ b_owner_name ], MAX_PLAYER_NAME, "%s", playerName ) ;
	b_info [ propertyIdx - 1 ] [ b_owner_inc ] = ownerId ;
	b_info [ propertyIdx - 1 ] [ b_auction_status ] = 0 ;

	new query_string [ 144 ] ;
	format ( query_string, sizeof query_string, "UPDATE `businesses` SET `b_owner_inc` = '%d' WHERE `b_id` = '%d' LIMIT 1", ownerId, propertyIdx ) ;
	mysql_tquery ( sql_connection, query_string ) ;

	for ( new i = 0 ; i < MAX_B_IMPROVE ; i ++ )
	{
	    b_info [ propertyIdx - 1 ] [ b_improve ] [ i ] = 0 ;
	}

	format ( query_string, sizeof query_string, "UPDATE `businesses` SET `b_improve` = '0|0|0|0' WHERE `b_id` = '%d' LIMIT 1", propertyIdx ) ;
	mysql_tquery ( sql_connection, query_string ) ;

	b_info [ propertyIdx - 1 ] [ b_maxproduct ] = 15000 ;

	format ( query_string, sizeof query_string, "UPDATE `businesses` SET `b_maxproduct` = '%d' WHERE `b_id` = '%d' LIMIT 1", b_info [ propertyIdx - 1 ] [ b_maxproduct ], propertyIdx ) ;
	mysql_tquery ( sql_connection, query_string ) ;
			
	if ( IsValidDynamicArea ( b_info [ propertyIdx - 1 ] [ b_zz_area ] ) ) DestroyDynamicArea ( b_info [ propertyIdx - 1 ] [ b_zz_area ] ) ;

	update_blabel ( propertyIdx - 1 ) ;
	return true ;
}

stock SetBusinessOwner ( propertyIdx, playerid )
{
	format ( b_info [ propertyIdx - 1 ] [ b_owner_name ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;
	b_info [ propertyIdx - 1 ] [ b_owner_inc ] = p_info [ playerid ] [ id ] ;
	p_info [ playerid ] [ business ] = b_info [ propertyIdx - 1 ] [ b_id ] ;
	b_info [ propertyIdx - 1 ] [ b_auction_status ] = 0 ;

	p_info [ playerid ] [ business_rang ] = b_info [ propertyIdx - 1 ] [ b_settings ] [ 3 ] ;
	update_int_sql ( playerid, "u_business_rang", p_info [ playerid ] [ business_rang ] ) ;

	Iter_Add ( business_players[propertyIdx], playerid ) ;
	Iter_Add ( player_business[playerid], propertyIdx ) ;

	SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cGN"}/bpanel{"#cGRInfo"} для управление бизнесом." ) ;
	SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Вам необходимо оплачивать налоги на недвижимость." ) ;
	SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Налоги списываются 1 раз в сутки. Для получения выписки рекомендуем обратиться в банк." ) ;
	PlayerPlaySound ( playerid, 1052, 0.0, 0.0, 0.0 ) ;
	
	new query_string [ 144 ] ;
	format ( query_string, sizeof query_string, "UPDATE `businesses` SET `b_owner_inc` = '%d' WHERE `b_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ], propertyIdx ) ;
	mysql_tquery ( sql_connection, query_string ) ;

	for ( new i = 0 ; i < MAX_B_IMPROVE ; i ++ )
	{
	    b_info [ propertyIdx - 1 ] [ b_improve ] [ i ] = 0 ;
	}

	format ( query_string, sizeof query_string, "UPDATE `businesses` SET `b_improve` = '0|0|0|0' WHERE `b_id` = '%d' LIMIT 1", propertyIdx ) ;
	mysql_tquery ( sql_connection, query_string ) ;

	b_info [ propertyIdx - 1 ] [ b_maxproduct ] = 15000 ;

	format ( query_string, sizeof query_string, "UPDATE `businesses` SET `b_maxproduct` = '%d' WHERE `b_id` = '%d' LIMIT 1", b_info [ propertyIdx - 1 ] [ b_maxproduct ], propertyIdx ) ;
	mysql_tquery ( sql_connection, query_string ) ;
			
	if ( IsValidDynamicArea ( b_info [ propertyIdx - 1 ] [ b_zz_area ] ) ) DestroyDynamicArea ( b_info [ propertyIdx - 1 ] [ b_zz_area ] ) ;

	update_blabel ( propertyIdx - 1 ) ;

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
	return true ;
}

callback: SetHouseOwnerByCharId ( propertyIdx, ownerId )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return false ;

	new playerName [ MAX_PLAYER_NAME ] ;
	cache_get_field_content ( 0, "u_name", playerName ) ;

	h_info [ propertyIdx - 1 ] [ h_owner ] = ownerId ;
	format ( h_info [ propertyIdx - 1 ] [ h_owner_name ], MAX_PLAYER_NAME, "%s", playerName ) ;

	h_info [ propertyIdx - 1 ] [ h_closed ] =
	h_info [ propertyIdx - 1 ] [ h_rent_price ] =
	h_info [ propertyIdx - 1 ] [ h_rent_status ] =
	h_info [ propertyIdx - 1 ] [ h_auction_status ] = 0 ;

	for ( new i = 0 ; i < 8 ; i ++ )
	{
		h_info [ propertyIdx - 1 ] [ h_improve ] [ i ] = 0 ;
	}

	if ( IsValidDynamic3DTextLabel ( h_info [ propertyIdx - 1 ] [ h_safe ] ) ) DestroyDynamic3DTextLabel ( h_info [ propertyIdx - 1 ] [ h_safe ] ) ;
	if ( IsValidDynamic3DTextLabel ( h_info [ propertyIdx - 1 ] [ h_fridge ] ) ) DestroyDynamic3DTextLabel ( h_info [ propertyIdx - 1 ] [ h_fridge ] ) ;
	if ( h_info [ propertyIdx - 1 ] [ h_safe_object ] ) DestroyDynamicObject ( h_info [ propertyIdx - 1 ] [ h_safe_object ] ) ;
	if ( h_info [ propertyIdx - 1 ] [ h_fridge_object ] ) DestroyDynamicObject ( h_info [ propertyIdx - 1 ] [ h_fridge_object ] ) ;

    h_info [ propertyIdx - 1 ] [ h_sell_status ] =
	h_info [ propertyIdx - 1 ] [ h_safe_code ] = 0 ;

	new sql_string [ 144 ] ;
	format ( sql_string, sizeof sql_string, "UPDATE `houses` SET `h_improve` = '0|0|0|0|0|0|0|0', `h_sell_status` = '0', `h_safe_code` = '0000' WHERE `h_id` = '%d' LIMIT 1", propertyIdx ) ;
	mysql_tquery ( sql_connection, sql_string ) ;

	DestroyDynamicPickup ( h_info [ propertyIdx - 1 ] [ h_pickup ] ) ;
	if ( ! h_info [ propertyIdx - 1 ] [ h_vw ] ) DestroyDynamicMapIcon ( h_info [ propertyIdx - 1 ] [ h_icon_id ] ) ;

	h_info [ propertyIdx - 1 ] [ h_pickup ] = CreateDynamicPickup ( 1272, 23, h_info [ propertyIdx - 1 ] [ h_pos ] [ 0 ], h_info [ propertyIdx - 1 ] [ h_pos ] [ 1 ], h_info [ propertyIdx - 1 ] [ h_pos ] [ 2 ], h_info [ propertyIdx - 1 ] [ h_vw ], -1 ) ;
	if ( ! h_info [ propertyIdx - 1 ] [ h_vw ] ) h_info [ propertyIdx - 1 ] [ h_icon_id ] = CreateDynamicMapIcon ( h_info [ propertyIdx - 1 ] [ h_pos ] [ 0 ], h_info [ propertyIdx - 1 ] [ h_pos ] [ 1 ], h_info [ propertyIdx - 1 ] [ h_pos ] [ 2 ], radar_propertyR, 0, 0, 0, -1 ) ;

	if ( IsValidDynamicArea ( h_info [ propertyIdx - 1 ] [ h_zz_area ] ) ) DestroyDynamicArea ( h_info [ propertyIdx - 1 ] [ h_zz_area ] ) ;

	save_house ( propertyIdx ) ;
			
	#if defined m_familys
		clear_fam_house ( INVALID_PLAYER_ID, propertyIdx, 1 ) ;
	#endif

	if ( h_info [ propertyIdx - 1 ] [ h_podezd ] != -1 ) update_podezd ( h_info [ propertyIdx - 1 ] [ h_podezd ] ) ;
	return true ;
}

stock SetHouseOwner ( propertyIdx, playerid )
{
	p_info [ playerid ] [ house ] = propertyIdx ;
	h_info [ propertyIdx - 1 ] [ h_owner ] = p_info [ playerid ] [ id ] ;
	format ( h_info [ propertyIdx - 1 ] [ h_owner_name ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;

	h_info [ propertyIdx - 1 ] [ h_closed ] =
	h_info [ propertyIdx - 1 ] [ h_rent_price ] =
	h_info [ propertyIdx - 1 ] [ h_rent_status ] =
	h_info [ propertyIdx - 1 ] [ h_auction_status ] = 0 ;

	for ( new i = 0 ; i < 8 ; i ++ )
	{
		h_info [ propertyIdx - 1 ] [ h_improve ] [ i ] = 0 ;
	}

	if ( IsValidDynamic3DTextLabel ( h_info [ propertyIdx - 1 ] [ h_safe ] ) ) DestroyDynamic3DTextLabel ( h_info [ propertyIdx - 1 ] [ h_safe ] ) ;
	if ( IsValidDynamic3DTextLabel ( h_info [ propertyIdx - 1 ] [ h_fridge ] ) ) DestroyDynamic3DTextLabel ( h_info [ propertyIdx - 1 ] [ h_fridge ] ) ;
	if ( h_info [ propertyIdx - 1 ] [ h_safe_object ] ) DestroyDynamicObject ( h_info [ propertyIdx - 1 ] [ h_safe_object ] ) ;
	if ( h_info [ propertyIdx - 1 ] [ h_fridge_object ] ) DestroyDynamicObject ( h_info [ propertyIdx - 1 ] [ h_fridge_object ] ) ;

    h_info [ propertyIdx - 1 ] [ h_sell_status ] =
	h_info [ propertyIdx - 1 ] [ h_safe_code ] = 0 ;

	new sql_string [ 144 ] ;
	format ( sql_string, sizeof sql_string, "UPDATE `houses` SET `h_improve` = '0|0|0|0|0|0|0|0', `h_sell_status` = '0', `h_safe_code` = '0000' WHERE `h_id` = '%d' LIMIT 1", propertyIdx ) ;
	mysql_tquery ( sql_connection, sql_string ) ;

	DestroyDynamicPickup ( h_info [ propertyIdx - 1 ] [ h_pickup ] ) ;
	if ( ! h_info [ propertyIdx - 1 ] [ h_vw ] ) DestroyDynamicMapIcon ( h_info [ propertyIdx - 1 ] [ h_icon_id ] ) ;

	h_info [ propertyIdx - 1 ] [ h_pickup ] = CreateDynamicPickup ( 1272, 23, h_info [ propertyIdx - 1 ] [ h_pos ] [ 0 ], h_info [ propertyIdx - 1 ] [ h_pos ] [ 1 ], h_info [ propertyIdx - 1 ] [ h_pos ] [ 2 ], h_info [ propertyIdx - 1 ] [ h_vw ], -1 ) ;
	if ( ! h_info [ propertyIdx - 1 ] [ h_vw ] ) h_info [ propertyIdx - 1 ] [ h_icon_id ] = CreateDynamicMapIcon ( h_info [ propertyIdx - 1 ] [ h_pos ] [ 0 ], h_info [ propertyIdx - 1 ] [ h_pos ] [ 1 ], h_info [ propertyIdx - 1 ] [ h_pos ] [ 2 ], radar_propertyR, 0, 0, 0, -1 ) ;

	SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cGN"}/hmenu{"#cGRInfo"} для управление домом." ) ;
	SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Вам необходимо оплачивать налоги на недвижимость." ) ;
	SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Налоги списываются 1 раз в сутки. Для получения выписки рекомендуем обратиться в банк." ) ;
				
	if ( h_info [ propertyIdx - 1 ] [ h_garage ] )
	{
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}В доме имеется обустроенный гараж, в котором можно парковать т/с." ) ;
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Домашний гараж не даёт дополнительный слот для т/с." ) ;
	}
	if ( IsValidDynamicArea ( h_info [ propertyIdx - 1 ] [ h_zz_area ] ) ) DestroyDynamicArea ( h_info [ propertyIdx - 1 ] [ h_zz_area ] ) ;

	p_info [ playerid ] [ spawnchange ] = 1 ;
	update_int_sql ( playerid, "u_spawnchange", 1 ) ;
	save_house ( propertyIdx ) ;
			
	#if defined m_familys
		clear_fam_house ( playerid, propertyIdx, 1 ) ;
	#endif
				
	Iter_Add(player_houses[playerid], propertyIdx);
	
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

	if ( h_info [ propertyIdx - 1 ] [ h_podezd ] != -1 ) update_podezd ( h_info [ propertyIdx - 1 ] [ h_podezd ] ) ;
	return true ;
}

static stock UpdateActiveAuctionsCounter ( )
{
    activeAuctionCounter = 0 ;
    foreach(new b: auctionBusiness)
    {
        if ( b_info [ b - 1 ] [ b_auction_player ] ) activeAuctionCounter ++ ;
    }

    foreach(new h: auctionHouses) 
    {
        if ( h_info [ h - 1 ] [ h_auction_player ] ) activeAuctionCounter ++ ;
    }
    return true ;
}

static stock UpdateAuctionInterfaceBankMoney ( playerid )
{
	global_string [ 0 ] = EOS ;
    format ( global_string, 12, "%d", p_info [ playerid ] [ money ] ) ;
	onServerSendData ( playerid, UI_TABLET, AUCTIONS_APP + 8, global_string ) ;
    return true ;
}

static stock UpdateAuctionInterfaceStats ( playerid = INVALID_PLAYER_ID )
{
    UpdateActiveAuctionsCounter ( ) ;

    new jsonString [ 124 ], playerAuctions, totalAuctions = Iter_Count(auctionBusiness) + Iter_Count(auctionHouses) ;

    new Node: node = JSON_Object (
        "allAuctionsCount",  JSON_Int ( totalAuctions ),
        "allBetsCount",     JSON_Int ( activeAuctionCounter ),
        "myBetsCount",      JSON_Int ( 0 )
    ) ;

    if ( playerid == INVALID_PLAYER_ID )
    {
        foreach(new i: logged_players)
        {
            if ( p_t_info [ i ] [ in_auctions ] == false ) continue ;

            playerAuctions = 0 ;

            if ( playerInAuction [ i ] [ TYPE_BUSINESS ] > 0 ) playerAuctions++;
            if ( playerInAuction [ i ] [ TYPE_HOUSE ] > 0 ) playerAuctions ++ ;

            JSON_SetInt ( node, "myBetsCount", playerAuctions ) ;

            JSON_Stringify ( node, jsonString ) ;
            onServerSendData ( i, UI_TABLET, AUCTIONS_APP, jsonString ) ;

            jsonString [ 0 ] = EOS ;
        }
    }
    else
    {
        playerAuctions = _:( playerInAuction [ playerid ] [ TYPE_BUSINESS ] ) + _:( playerInAuction [ playerid ] [ TYPE_HOUSE ] ) ;

        JSON_SetInt ( node, "myBetsCount", playerAuctions ) ;

        JSON_Stringify ( node, jsonString ) ;
        onServerSendData ( playerid, UI_TABLET, AUCTIONS_APP, jsonString ) ;        
    }
    return true ;
}

static stock UpdateAuctionInterfaceProperty ( propertyIdx, auctionType, const charName [ ] )
{
    new Node: defaultNode, defaultNodeResult [ 256 ], 
        Node: overrideNode, overrideNodeResult [ 256 ] ;

    new propertyId, betCharId ;
    if ( auctionType == TYPE_BUSINESS )
    {
        propertyId = b_info [ propertyIdx - 1 ] [ b_id ] ;
        betCharId = b_info [ propertyIdx - 1 ] [ b_auction_player ] ;

        defaultNode = JSON_Object (
            "id",               JSON_Int ( propertyId ),
            "type",             JSON_Int ( TYPE_BUSINESS ),
            "name",             JSON_String ( b_types [ b_info [ propertyId - 1 ] [ b_type ] ] ),
            "bet",              JSON_Int ( b_info [ propertyIdx - 1 ] [ b_auction_bet ] ),
            "userName",         JSON_String ( charName ),
            "endOfAuction",     JSON_Int ( b_info [ propertyIdx - 1 ] [ b_auction_date ] ),
            "isBetOverride",    JSON_Int ( 0 )
        ) ;
    }
    else
    {
        propertyId = h_info [ propertyIdx - 1 ] [ h_id ] ;
        betCharId = h_info [ propertyIdx - 1 ] [ h_auction_player ] ;

        defaultNode = JSON_Object (
            "id",               JSON_Int ( propertyId ),
            "type",             JSON_Int ( TYPE_HOUSE ),
            "name",             JSON_String ( "Дом" ),
            "bet",              JSON_Int ( h_info [ propertyIdx - 1 ] [ h_auction_bet ] ),
            "userName",         JSON_String ( charName ),
            "endOfAuction",     JSON_Int ( h_info [ propertyIdx - 1 ] [ h_auction_date ] ),
            "isBetOverride",    JSON_Int ( 0 )
        ) ;
    }

    JSON_Stringify ( defaultNode, defaultNodeResult, sizeof defaultNodeResult ) ;

    overrideNode = defaultNode ;
    JSON_SetInt ( overrideNode, "isBetOverride", 1 ) ;

    JSON_Stringify ( overrideNode, overrideNodeResult, sizeof overrideNodeResult ) ;

    foreach(new i: logged_players)
    {
        if ( ! p_t_info [ i ] [ in_auctions ] ) continue ;
        if ( playerInAuction [ i ] [ auctionType ] == propertyId ) 
        {
            if ( p_info [ i ] [ id ] != betCharId ) onServerSendData ( i, UI_TABLET, AUCTIONS_APP + 6, overrideNodeResult ) ; // Обновить имущество в личном списке (выделив красным)
            else onServerSendData ( i, UI_TABLET, AUCTIONS_APP + 6, defaultNodeResult ) ; // Обновить имущество в личном списке 
        }
        onServerSendData ( i, UI_TABLET, AUCTIONS_APP + 3, defaultNodeResult ) ; // Обновить имущество в общем списке
    }
    return true ;
}

static stock RemoveAuctionInterfaceProperty ( propertyId, auctionType )
{
    new Node: node = JSON_Object (
        "id",   JSON_Int ( propertyId ),
        "type", JSON_Int ( auctionType )
    ) ;

	new scm_string [ 124 ] ;
    JSON_Stringify ( node, scm_string, sizeof scm_string ) ;

    foreach(new i: logged_players)
    {   
        if ( ! p_t_info [ i ] [ in_auctions ] ) 
        {
            if ( playerInAuction [ i ] [ auctionType ] == propertyId ) playerInAuction [ i ] [ auctionType ] = 0 ;
            continue ;
        }

        if ( playerInAuction [ i ] [ auctionType ] == propertyId ) 
        {
            playerInAuction [ i ] [ auctionType ] = 0 ;
            onServerSendData ( i, UI_TABLET, AUCTIONS_APP + 7, scm_string ) ;
        }
        onServerSendData ( i, UI_TABLET, AUCTIONS_APP + 4, scm_string ) ;
    }

	scm_string [ 0 ] = EOS ;
    format ( scm_string, sizeof scm_string, "\
        DELETE FROM auction_member \
        WHERE auction_property_type = %d AND auction_property_sql_id = %d",
        auctionType, propertyId
    ) ;
    mysql_tquery ( sql_connection, scm_string ) ;
    return true ;
}

static stock GetAuctionPropertyIdxById ( propertyId, propertyType )
{
    if ( propertyType == TYPE_BUSINESS )
    {
        foreach(new propertyIdx: auctionBusiness)
        {
            if ( b_info [ propertyIdx - 1 ] [ b_id ] != propertyId ) continue ;
            return propertyIdx ;
        }
    }
    else
    {
        foreach(new propertyIdx: auctionHouses)
        {
            if ( h_info [ propertyIdx - 1 ] [ h_id ] != propertyId ) continue ;
            return propertyIdx ;
        }
    }
    return -1 ;
}

stock AuctionMinuteTimer ( currentTimestamp )
{
    foreach(new i: auctionBusiness)
    {
        if ( b_info [ i - 1 ] [ b_auction_date ] <= currentTimestamp )
        {
            if ( b_info [ i - 1 ] [ b_auction_player ] == 0 ) continue ;

            new businessIdx = i ;
            EndPropertyAuction ( businessIdx, TYPE_BUSINESS ) ;
            Iter_SafeRemove(auctionBusiness, businessIdx, i) ;

            UpdateAuctionInterfaceStats ( ) ;
        }
    }

    foreach(new i: auctionHouses)
    {
        if ( h_info [ i - 1 ] [ h_auction_date ] <= currentTimestamp )
        {
            if ( h_info [ i - 1 ] [ h_auction_player ] == 0 ) continue ;

            new houseIdx = i ;
            EndPropertyAuction ( houseIdx, TYPE_HOUSE ) ;
            Iter_SafeRemove(auctionHouses, houseIdx, i) ;

            UpdateAuctionInterfaceStats ( ) ;
        }
    }
    return true ;
}