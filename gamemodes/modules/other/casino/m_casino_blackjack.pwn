static enum    
{  
    BJ_UPDATE_TIME,
    BJ_UPDATE_MOVE,
    BJ_UPDATE_INFO,
    BJ_UPDATE_CARD_INFO,
    BJ_UPDATE_PLAYER_INFO,
    BJ_UPDATE_STATE
} ;

static enum
{
    SUIT_SPADES,
    SUIT_CLUBS,
    SUIT_HEARTS,
    SUIT_DIAMONDS
} ;

#define MAX_CARDS 52
enum _bj_card_info
{
    card_id,
    card_suit,
    card_score,
    bool: card_active
} ;

new bj_card_info [ MAX_CARDS ] [ _bj_card_info ] =
{
    { 1, SUIT_SPADES, 2, true },
    { 2, SUIT_SPADES, 3, true },
    { 3, SUIT_SPADES, 4, true },
    { 4, SUIT_SPADES, 5, true },
    { 5, SUIT_SPADES, 6, true },
    { 6, SUIT_SPADES, 7, true },
    { 7, SUIT_SPADES, 8, true },
    { 8, SUIT_SPADES, 9, true },
    { 9, SUIT_SPADES, 10, true },
    { 10, SUIT_SPADES, 10, true },
    { 11, SUIT_SPADES, 10, true },
    { 12, SUIT_SPADES, 10, true },
    { 13, SUIT_SPADES, 1, true },

    { 1, SUIT_CLUBS, 2, true },
    { 2, SUIT_CLUBS, 3, true },
    { 3, SUIT_CLUBS, 4, true },
    { 4, SUIT_CLUBS, 5, true },
    { 5, SUIT_CLUBS, 6, true },
    { 6, SUIT_CLUBS, 7, true },
    { 7, SUIT_CLUBS, 8, true },
    { 8, SUIT_CLUBS, 9, true },
    { 9, SUIT_CLUBS, 10, true },
    { 10, SUIT_CLUBS, 10, true },
    { 11, SUIT_CLUBS, 10, true },
    { 12, SUIT_CLUBS, 10, true },
    { 13, SUIT_CLUBS, 1, true },

    { 1, SUIT_HEARTS, 2, true },
    { 2, SUIT_HEARTS, 3, true },
    { 3, SUIT_HEARTS, 4, true },
    { 4, SUIT_HEARTS, 5, true },
    { 5, SUIT_HEARTS, 6, true },
    { 6, SUIT_HEARTS, 7, true },
    { 7, SUIT_HEARTS, 8, true },
    { 8, SUIT_HEARTS, 9, true },
    { 9, SUIT_HEARTS, 10, true },
    { 10, SUIT_HEARTS, 10, true },
    { 11, SUIT_HEARTS, 10, true },
    { 12, SUIT_HEARTS, 10, true },
    { 13, SUIT_HEARTS, 1, true },

    { 1, SUIT_DIAMONDS, 2, true },
    { 2, SUIT_DIAMONDS, 3, true },
    { 3, SUIT_DIAMONDS, 4, true },
    { 4, SUIT_DIAMONDS, 5, true },
    { 5, SUIT_DIAMONDS, 6, true },
    { 6, SUIT_DIAMONDS, 7, true },
    { 7, SUIT_DIAMONDS, 8, true },
    { 8, SUIT_DIAMONDS, 9, true },
    { 9, SUIT_DIAMONDS, 10, true },
    { 10, SUIT_DIAMONDS, 10, true },
    { 11, SUIT_DIAMONDS, 10, true },
    { 12, SUIT_DIAMONDS, 10, true },
    { 13, SUIT_DIAMONDS, 1, true }
} ;

#define MOVE_BJ_TIME        30
#define DEALER_TABLE_ID     0
#define MAX_BJ_PLAYERS      4
#define MAX_PLAYER_CARDS    7
#define MAX_BJ_TABLE        2
#define MAX_BJ_SCORE        21

new bj_card_table [ MAX_BUSINESS ] [ MAX_BJ_TABLE ] [ MAX_CARDS ] [ _bj_card_info ] ;

static enum
{
    BJ_WAITINIG,
    BJ_START,
    BJ_FINISH
} ;

static enum
{
    BJ_NOT_ACTION,
    BJ_X2,
    BJ_STAY,
    BJ_MORE,
    BJ_WIN
} ;

static enum _blackjack
{
    bj_time,
    bj_player_move,
    bj_player [ MAX_BJ_PLAYERS ],
    bj_dealer_card [ MAX_PLAYER_CARDS ],
    bj_status,
    Text3D: bj_text
} ;
new blackjack [ MAX_BUSINESS ] [ MAX_BJ_TABLE ] [ _blackjack ] ;

static playerBet [ MAX_PLAYERS ] ;
static playerTable [ MAX_PLAYERS char ] ;
static playerState [ MAX_PLAYERS char ] ;
static playerCards [ MAX_PLAYERS ] [ MAX_PLAYER_CARDS ] ;

static const Float: tablePosition [ ] [ 3 ] =
{
    { 2334.928, 108.266, 801.992 },
    { 2331.075, 108.087, 801.992 }
} ;

stock bj_OnGameModeInit ( )
{
    for ( new i = 0 ; i < MAX_BJ_TABLE ; i ++ )
    {
        new _areaid = CreateDynamicSphere ( tablePosition [ i ] [ 0 ], tablePosition [ i ] [ 1 ], tablePosition [ i ] [ 2 ], 3.0, -1, -1, -1 ) ;
		area_info [ _areaid ] [ a_type ] = area_type_blackjack ;
        area_info [ _areaid ] [ a_item ] = i ;
    }

    foreach(new b: business_types[bizz_type_casino])
    {
        for ( new i = 0 ; i < MAX_BJ_TABLE ; i ++ )
        {
            bj_card_table [ b - 1 ] [ i ] = bj_card_info ;

            blackjack [ b - 1 ] [ i ] [ bj_player_move ] = -1 ;
            blackjack [ b - 1 ] [ i ] [ bj_status ] = BJ_WAITINIG ;
            blackjack [ b - 1 ] [ i ] [ bj_time ] = MOVE_BJ_TIME ;

            for ( new c = 0 ; c < MAX_PLAYER_CARDS ; c ++ )
            {
                blackjack [ b - 1 ] [ i ] [ bj_dealer_card ] [ c ] = -1 ;
            }

            for ( new p = 0 ; p < MAX_BJ_PLAYERS ; p ++ )
            {
                blackjack [ b - 1 ] [ i ] [ bj_player ] [ p ] = -1 ;
            }

            blackjack [ b - 1 ] [ i ] [ bj_text ] = CreateDynamic3DTextLabel ( "** BlackJack **\n{"#cGR3D"}Подойдите для взаимодействия", col_header_3d, tablePosition [ i ] [ 0 ], tablePosition [ i ] [ 1 ], tablePosition [ i ] [ 2 ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, b_info [ b - 1 ] [ b_id ] + 1000, 22 );
            update_blackjack_label ( b, i + 1 ) ;
        }
    }
    return 1 ;
}

stock update_blackjack_label ( _b_id, _table_id )
{
    new status_string [ 64 ] ;
    if ( blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_status ] == BJ_WAITINIG )
        format ( status_string, sizeof status_string, "{"#cLY"}Ожидание игроков" ) ;

    else if ( blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_status ] == BJ_START )
        format ( status_string, sizeof status_string, "{"#cGN"}Идёт игра" ) ;

    else
        format ( status_string, sizeof status_string, "{"#cOR"}Подведение итогов" ) ;

    global_string [ 0 ] = EOS ;
    format ( global_string, 256, "** BlackJack **\n{"#cWH"}Статус: %s\n\n{"#cGR3D"}Подойдите для взаимодействия", status_string ) ;
    UpdateDynamic3DTextLabelText ( blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_text ], col_blue, global_string ) ;
}

stock clear_player_blackjack ( playerid )
{
    for ( new i = 0 ; i < MAX_PLAYER_CARDS ; i ++ )
    {
        playerCards [ playerid ] [ i ] = -1 ;
    }
    playerBet [ playerid ] =
    playerTable { playerid } = 0 ;
    return 1 ;
}

stock enter_table_blackjack ( playerid, _b_id, _table_id )
{
    if ( blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_status ] != BJ_WAITINIG )
    {
        send_check_cinfo ( playerid, "Вы не можете присоединиться к столу, т.к. идёт игра.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 0 ;
    }
    
    clear_player_blackjack ( playerid ) ;
	toggle_controlable ( playerid, false ) ;
    
    for ( new i = 0, _playerId ; i < MAX_BJ_PLAYERS ; i ++ )
    {
        if ( blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] != -1 ) continue ;

        blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] = playerid ;
        for ( new p = 0 ; p < MAX_BJ_PLAYERS ; p ++ )
        {
            _playerId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ p ] ;
            if ( _playerId != -1 )
            {
                updateTableInfo ( _playerId, _b_id, _table_id ) ;
            }
        }
        return 1 ;
    }
    return 0 ;
}

stock exit_table_blackjack ( playerid )
{
    if ( playerTable { playerid } > 0 )
    {
        new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _table_id = playerTable { playerid } ;
        for ( new i = 0, _playerId, bool: isMove = false ; i < MAX_BJ_PLAYERS ; i ++ )
        {
            if ( blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] != playerid ) continue ;

            blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] = -1 ;
            if ( blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player_move ] != -1 ) isMove = true ;
            for ( new p = 0 ; p < MAX_BJ_PLAYERS ; p ++ )
            {
                _playerId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ p ] ;
                if ( _playerId != -1 )
                {
                    updateTableInfo ( _playerId, _b_id, _table_id ) ;
                }
            }
            if ( isMove ) checkBlackJackTable ( _b_id, _table_id ) ;
            break ;
        }
    }
}

stock bj_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
    #pragma unused listitem
    switch ( dialogid )
    {
        case d_bj_bet:
        {
            if ( ! response ) return 1 ;

            new _value = strval ( inputtext ), _table = get_player_use_listitem ( playerid ) ;
            if ( _value < 10 || _value > 500 )
            {
                show_dialog ( playerid, d_bj_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Ставка", "{"#cRD"}* Поставить можно от 10 до 500 фишек!\n\n{"#cWH"}Укажите сумму, которую хотите поставить для игры:", "Указать", "Отмена" ) ;
                return 1 ;
            }

            if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_CASINO_CHIPS ) < _value )
            {
                show_dialog ( playerid, d_bj_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Ставка", "{"#cRD"}* У Вас недостаточно фишек для старта!\n\n{"#cWH"}Укажите сумму, которую хотите поставить для игры:", "Указать", "Отмена" ) ;
                return 1 ;
            }

			if ( ! GetPVarInt ( playerid, "p_biz_id" ) ) return bad_exit ( playerid ) ;

            if ( ! enter_table_blackjack ( playerid, GetPVarInt ( playerid, "p_biz_id" ), _table + 1 ) ) return 1 ;

			show_window_blackjack ( playerid, _table ) ;
            playerBet [ playerid ] = _value ;
            return 1 ;
        }
    }
    return 0 ;
}

stock show_window_blackjack ( playerid, _table )
{
	#if defined debug_packet
		printf ( "[show_window_blackjack] playerid: %d", playerid ) ;
	#endif

    playerTable { playerid } = _table + 1 ;
    updatePlayerChips ( playerid ) ;
    updatePlayerState ( playerid, 3 ) ;

    new _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;

    _table = playerTable { playerid } ;
    setDealerPacket ( playerid, _b_id, _table ) ;
    updateTableInfo ( playerid, _b_id, _table ) ;

    global_string [ 0 ] = EOS ;
    format ( global_string, sizeof global_string, "%d", blackjack [ _b_id - 1 ] [ _table - 1 ] [ bj_time ] ) ;
    onServerSendData ( playerid, UI_CASINO_BLACKJACK, BJ_UPDATE_TIME, global_string ) ;
    if ( blackjack [ _b_id - 1 ] [ _table - 1 ] [ bj_player_move ] != -1 )
    {
        new _playerId = blackjack [ _b_id - 1 ] [ _table - 1 ] [ bj_player_move ] ;
        onServerSendData ( playerid, UI_CASINO_BLACKJACK, BJ_UPDATE_MOVE, p_info [ _playerId ] [ name ] ) ;
    }
    else
    {
        if ( blackjack [ _b_id - 1 ] [ _table - 1 ] [ bj_status ] == BJ_WAITINIG )
            onServerSendData ( playerid, UI_CASINO_BLACKJACK, BJ_UPDATE_MOVE, "Ожидание игроков..." ) ;

        if ( blackjack [ _b_id - 1 ] [ _table - 1 ] [ bj_status ] == BJ_FINISH )
            onServerSendData ( playerid, UI_CASINO_BLACKJACK, BJ_UPDATE_MOVE, "Конец игры..." ) ;
    }
}

stock updatePlayerChips ( playerid )
{
    new Node: node = JSON_Object (
        "bid",          JSON_Int ( playerBet [ playerid ] ),
        "chips",        JSON_Int ( GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_CASINO_CHIPS ) )
    ) ;

    global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_CASINO_BLACKJACK, BJ_UPDATE_INFO, global_string ) ;
    return 1 ;
}

stock show_packet_blackjack ( playerid, actionId, data [ ] )
{
    #pragma unused data
    if ( actionId == 0 ) // exit
    {
        exit_table_blackjack ( playerid ) ;
	    toggle_controlable ( playerid, true ) ;
    }
    else if ( actionId == 1 ) // help
    {
        show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}BlackJack", "\
            {"#cBL"}** Правила **\n\n\
            {"#cBL"}Цель игрока {"#cWH"}- собрать руку, сумма очков в которой превышает сумму очков у дилера.\n\
            Важно собрать не более 21 очков, в ином случае игрок проиграет (перебор).\n\n\
            Для игры используется шесть стандартных колод из 52 карт. Для участия в игре игрок\n\
            должен сделать ставку.\n\
            После того как все ставки сделаны, дилер раздает игрокам по две карты в открытую, а\n\
            себе одну открытую и одну закрытую карты.\n\n\
            После того как игрок и дилер завершили брать карты, сравниваются значения\n\
            финальных рук дилера и игрока.\n\
            Если сумма очков у игрока больше, чем у дилера, то он получает выплату 3 к 2 от своей\n\
            ставки.\n\
            Если суммы очков равны (за исключением блэкджек), то это ничья и игроку\n\
            возвращается его ставка.\n\
            Если же дилер набрал больше очков, то игрок проигрывает.", "Закрыть", "" ) ;
    }
    else if ( actionId == 2 ) // x2
    {
        if ( playerState { playerid } == BJ_STAY )
        {
            send_check_cinfo ( playerid, "Вы выбрали 'стоп'! Вы больше не можете ходить.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
        }

        playerState { playerid } = BJ_X2 ;
        checkBlackJackTable ( GetPVarInt ( playerid, "p_biz_id" ), playerTable { playerid } ) ;
        updatePlayerState ( playerid, 3 ) ;
    }
    else if ( actionId == 3 ) // stop
    {
        if ( playerState { playerid } == BJ_STAY )
        {
            send_check_cinfo ( playerid, "Вы выбрали 'стоп'! Вы больше не можете ходить.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
        }

        playerState { playerid } = BJ_STAY ;
        checkBlackJackTable ( GetPVarInt ( playerid, "p_biz_id" ), playerTable { playerid } ) ;
        updatePlayerState ( playerid, 3 ) ;
    }
    else if ( actionId == 4 ) // take
    {
        if ( playerState { playerid } == BJ_STAY )
        {
            send_check_cinfo ( playerid, "Вы выбрали 'стоп'! Вы больше не можете ходить.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
        }

        playerState { playerid } = BJ_MORE ;
        checkBlackJackTable ( GetPVarInt ( playerid, "p_biz_id" ), playerTable { playerid } ) ;
        updatePlayerState ( playerid, 3 ) ;
    }
    return 1 ;
}

stock updatePlayerState ( playerid, _state )
{
    global_string [ 0 ] = EOS ;
    format ( global_string, 12, "%d", _state ) ;
    onServerSendData ( playerid, UI_CASINO_BLACKJACK, BJ_UPDATE_STATE, global_string ) ;
}

stock BlackJackSecondTimer ( )
{
    foreach(new b: business_types[bizz_type_casino])
    {
        for ( new i = 0 ; i < MAX_BJ_TABLE ; i ++ )
        {
            if ( -- blackjack [ b - 1 ] [ i ] [ bj_time ] == 1 )
            {
                if ( blackjack [ b - 1 ] [ i ] [ bj_status ] == BJ_START )
                    checkBlackJackTable ( b, i + 1 ) ;

                else if ( blackjack [ b - 1 ] [ i ] [ bj_status ] == BJ_WAITINIG )
                    startBlackJackTable ( b, i + 1 ) ;

                else if ( blackjack [ b - 1 ] [ i ] [ bj_status ] == BJ_FINISH )
                {
                    clear_bj_table ( b, i + 1 ) ;
                    for ( new p = 0, _playerId ; p < MAX_BJ_PLAYERS ; p ++ )
                    {
                        if ( blackjack [ b - 1 ] [ i ] [ bj_player ] [ p ] != -1 )
                        {
                            _playerId = blackjack [ b - 1 ] [ i ] [ bj_player ] [ p ] ;
                            setDealerPacket ( _playerId, b, i + 1 ) ;
                            updateTableInfo ( _playerId, b, i + 1 ) ;

                            global_string [ 0 ] = EOS ;
                            format ( global_string, 12, "%d", blackjack [ b - 1 ] [ i ] [ bj_time ] ) ;
                            onServerSendData ( _playerId, UI_CASINO_BLACKJACK, BJ_UPDATE_TIME, global_string ) ;
                            onServerSendData ( _playerId, UI_CASINO_BLACKJACK, BJ_UPDATE_MOVE, "Ожидание игроков..." ) ;
                        }
                    }
                }
                update_blackjack_label ( b, i + 1 ) ;
            }
        }
    }
    return 1 ;
}

stock clearBlackJackMove ( _b_id, _table_id )
{
    new _playerId ;
    for ( new i = 0 ; i < MAX_BJ_PLAYERS ; i ++ )
    {
        _playerId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] ;
        if ( _playerId != -1 )
        {
            playerState { _playerId } = BJ_NOT_ACTION ;
        }
    }
}

stock checkBlackJackTable ( _b_id, _table_id )
{
    new _playerId, _pId, _state, bool: isMove = false, _stayCount = 0, _playerCount = 0 ;
    for ( new i = 0 ; i < MAX_BJ_PLAYERS ; i ++ )
    {
        _playerId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] ;
        if ( _playerId != -1 )
        {
            _playerCount ++ ;

            _state = playerState { _playerId } ;
            if ( _state == BJ_STAY || getPlayerScore ( _playerId ) >= MAX_BJ_SCORE )
            {
                _stayCount ++ ;
                updatePlayerState ( _playerId, 3 ) ;
                continue ;
            }

            if ( _state != BJ_MORE )
            {
                for ( new p = 0 ; p < MAX_BJ_PLAYERS ; p ++ )
                {
                    if ( blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ p ] == -1 ) continue ;

                    _pId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ p ] ;

                    global_string [ 0 ] = EOS ;
                    format ( global_string, sizeof global_string, "%d", MOVE_BJ_TIME ) ;
                    onServerSendData ( _pId, UI_CASINO_BLACKJACK, BJ_UPDATE_TIME, global_string ) ;
                    onServerSendData ( _pId, UI_CASINO_BLACKJACK, BJ_UPDATE_MOVE, p_info [ _playerId ] [ name ] ) ;
                    
                    blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player_move ] = _playerId ;
                }

                isMove = true ;
                blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_time ] = MOVE_BJ_TIME ;
                updatePlayerState ( _playerId, 1 ) ;
                break ;
            }

            if ( ! isMove )
            {
                for ( new c = 0 ; c < MAX_PLAYER_CARDS ; c ++ )
                {
                    if ( playerCards [ _playerId ] [ c ] != -1 ) continue ;
                    
                    playerCards [ _playerId ] [ c ] = getFreeCardId ( _b_id, _table_id ) ;
                    break ;
                }
                
                new _cardId, _score ;
                for ( new c = 0 ; c < MAX_PLAYER_CARDS ; c ++ )
                {
                    if ( playerCards [ _playerId ] [ c ] == -1 ) continue ;

                    _cardId = playerCards [ _playerId ] [ c ] ;
                    _score += bj_card_info [ _cardId ] [ card_score ] ;
                    if ( _score >= MAX_BJ_SCORE )
                    {
                        playerState { _playerId } = BJ_STAY ;
                        updatePlayerState ( _playerId, 3 ) ;
                        break ;
                    }
                }
            }
        }
    }

    if ( _stayCount == _playerCount )
    {
        blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_time ] = MOVE_BJ_TIME ;
        blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_status ] = BJ_FINISH ;

        blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_dealer_card ] [ 1 ] = getFreeCardId ( _b_id, _table_id ) ;

        new _dealerScore = getDealerScore ( _b_id, _table_id ) ;
        if ( _dealerScore < 16 ) blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_dealer_card ] [ 2 ] = getFreeCardId ( _b_id, _table_id ) ;
        
        _dealerScore = getDealerScore ( _b_id, _table_id ) ;
        for ( new i = 0, _score ; i < MAX_BJ_PLAYERS ; i ++ )
        {
            _playerId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] ;
            if ( _playerId != -1 )
            {
                setDealerPacket ( _playerId, _b_id, _table_id ) ;

                _score = 0 ;
                for ( new c = 0, _cardId ; c < MAX_PLAYER_CARDS ; c ++ )
                {
                    if ( playerCards [ _playerId ] [ c ] == -1 ) continue ;

                    _cardId = playerCards [ _playerId ] [ c ] ;
                    _score += bj_card_info [ _cardId ] [ card_score ] ;
                }

                if ( _dealerScore > MAX_BJ_SCORE )
                {
                    if ( _score <= MAX_BJ_SCORE )
                    {
                        send_check_cinfo ( _playerId, "Вы выиграли! Дилер перебрал", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
                        give_inventory (
                            _playerId,
                            ITEM_CASINO_CHIPS,
                            playerBet [ _playerId ] * 2,
                            0,
                            "",
                            "",
                            NUMBERPLATE_TYPE_NONE,
                            0
                        ) ;
                        updatePlayerChips ( _playerId ) ;
                        continue ;
                    }
                    else
                    {
                        send_check_cinfo ( _playerId, "Вы проиграли! Вы перебрали. (1)", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
                        continue ;
                    }
                }
                else
                {
                    if ( _score > MAX_BJ_SCORE )
                    {
                        send_check_cinfo ( _playerId, "Вы проиграли! Вы перебрали. (2)", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
                        continue ;
                    }
                    else if ( _score == MAX_BJ_SCORE )
                    {
                        send_check_cinfo ( _playerId, "Вы выиграли! У Вас BlackJack.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
                        give_inventory (
                            _playerId,
                            ITEM_CASINO_CHIPS,
                            playerBet [ _playerId ] * 3,
                            0,
                            "",
                            "",
                            NUMBERPLATE_TYPE_NONE,
                            0
                        ) ;
                        updatePlayerChips ( _playerId ) ;
                        continue ;
                    }
                    else if ( _score > _dealerScore )
                    {
                        send_check_cinfo ( _playerId, "Вы выиграли! Вы набрали больше дилера.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
                        give_inventory (
                            _playerId,
                            ITEM_CASINO_CHIPS,
                            playerBet [ _playerId ] * 2,
                            0,
                            "",
                            "",
                            NUMBERPLATE_TYPE_NONE,
                            0
                        ) ;
                        updatePlayerChips ( _playerId ) ;
                        continue ;
                    }
                    else if ( _score == _dealerScore )
                    {
                        send_check_cinfo ( _playerId, "У Вас ничья с дилером!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
                        give_inventory (
                            _playerId,
                            ITEM_CASINO_CHIPS,
                            playerBet [ _playerId ],
                            0,
                            "",
                            "",
                            NUMBERPLATE_TYPE_NONE,
                            0
                        ) ;
                        updatePlayerChips ( _playerId ) ;
                        continue ;
                    }
                    else
                    {
                        send_check_cinfo ( _playerId, "Вы проиграли!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
                        continue ;
                    }
                }
            }
        }

        for ( new i = 0 ; i < MAX_BJ_PLAYERS ; i ++ )
        {
            _playerId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] ;
            if ( _playerId != -1 )
            {
                updateTableInfo ( _playerId, _b_id, _table_id ) ;
                onServerSendData ( _playerId, UI_CASINO_BLACKJACK, BJ_UPDATE_MOVE, "Конец игры..." ) ;
            }
        }
        return 1 ;
    }

    if ( ! isMove )
    {
        if ( blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_time ] > 5 ) blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_time ] = 5 ;

        for ( new i = 0 ; i < MAX_BJ_PLAYERS ; i ++ )
        {
            _playerId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] ;
            if ( _playerId != -1 ) 
            {
                global_string [ 0 ] = EOS ;
                format ( global_string, sizeof global_string, "%d", blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_time ] ) ;
                onServerSendData ( _pId, UI_CASINO_BLACKJACK, BJ_UPDATE_TIME, global_string ) ;

                setDealerPacket ( _playerId, _b_id, _table_id ) ;
                updateTableInfo ( _playerId, _b_id, _table_id ) ;
            }
        }
        clearBlackJackMove ( _b_id, _table_id ) ;
    }
    return 1 ;
}

stock startBlackJackTable ( _b_id, _table_id )
{
    new _playersCount = 0 ;
    for ( new i = 0, _playerId ; i < MAX_BJ_PLAYERS ; i ++ )
    {
        _playerId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] ;
        if ( _playerId != -1 )
        {
            if ( GetInventoryFindItem ( _playerId, SUB_INVENTORY, ITEM_CASINO_CHIPS ) < playerBet [ _playerId ] )
            {
                send_check_cinfo ( _playerId, "У Вас недостаточно фишек для старта!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
                show_packet_blackjack ( _playerId, 0, "" ) ;
                continue ;
            }

            clear_inventory ( _playerId, ITEM_CASINO_CHIPS, playerBet [ _playerId ] ) ;
            updatePlayerChips ( _playerId ) ;

            _playersCount ++ ;
        }
    }

    if ( ! _playersCount )
    {
        blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_status ] = BJ_WAITINIG ;
        blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_time ] = MOVE_BJ_TIME ;
        return 1 ;
    }

    blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_status ] = BJ_START ;
    blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_time ] = MOVE_BJ_TIME ;

    bj_card_table [ _b_id - 1 ] [ _table_id - 1 ] = bj_card_info ;

    blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_dealer_card ] [ 0 ] = getFreeCardId ( _b_id, _table_id ) ;
    blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_dealer_card ] [ 1 ] = 0 ;

    new isFirst = false ;
    for ( new i = 0, _playerId ; i < MAX_BJ_PLAYERS ; i ++ )
    {
        _playerId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] ;
        if ( _playerId != -1 )
        {
            new _score = 0 ;
            for ( new c = 0 ; c < 2 ; c ++ )
            {
                if ( playerCards [ _playerId ] [ c ] != -1 ) continue ;
                        
                playerCards [ _playerId ] [ c ] = getFreeCardId ( _b_id, _table_id ) ;
                _score += bj_card_info [ playerCards [ _playerId ] [ c ] ] [ card_score ] ;
                if ( _score == MAX_BJ_SCORE )
                {
                    playerState { _playerId } = BJ_STAY ;
                    send_check_cinfo ( _playerId, "У Вас BlacJack со старта. Вы выиграли!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
                    updatePlayerState ( _playerId, 3 ) ;
                    updatePlayerChips ( _playerId ) ;
                    break ;
                }
            }
            if ( ! isFirst && playerState { _playerId } != BJ_STAY )
            {
                isFirst = true ;
                updatePlayerState ( _playerId, 1 ) ;

                global_string [ 0 ] = EOS ;
                format ( global_string, 12, "%d", MOVE_BJ_TIME ) ;
                for ( new p = 0, _pId ; p < MAX_BJ_PLAYERS ; p ++ )
                {
                    _pId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ p ] ;
                    if ( _pId != -1 )
                    {
                        onServerSendData ( _pId, UI_CASINO_BLACKJACK, BJ_UPDATE_TIME, global_string ) ;
                        onServerSendData ( _pId, UI_CASINO_BLACKJACK, BJ_UPDATE_MOVE, p_info [ _playerId ] [ name ] ) ;
                    }
                }
                blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player_move ] = _playerId ;
            }
            else updatePlayerState ( _playerId, 3 ) ;
            
            setDealerPacket ( _playerId, _b_id, _table_id ) ;
            updateTableInfo ( _playerId, _b_id, _table_id ) ;
        }
    }

    clearBlackJackMove ( _b_id, _table_id ) ;
    checkBlackJackTable ( _b_id, _table_id ) ;
    return 1 ;
}

stock updateTableInfo ( playerid, _b_id, _table_id )
{
    new Node: node, _playerId, _score, _id, _bg, _str [ 24 ],
        _status = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_status ] ;
    for ( new i = 0 ; i < MAX_BJ_PLAYERS ; i ++ )
    {
        if ( blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] == -1 )
        {
            format ( _str, sizeof _str, "ОЧКИ: 0" ) ;
            node = JSON_Object (
                "id",           JSON_Int ( i + 1 ),
                "name",         JSON_String ( "Свободно" ),
                "score",        JSON_String ( _str ),
                "bg",           JSON_Int ( 0 )
            ) ;

            global_string [ 0 ] = EOS ;
            JSON_Stringify ( node, global_string, sizeof global_string ) ;
            onServerSendData ( playerid, UI_CASINO_BLACKJACK, BJ_UPDATE_PLAYER_INFO, global_string ) ;

            node = JSON_Array ( ) ;
            for ( new c = 0, Node: nodeCards ; c < MAX_PLAYER_CARDS ; c ++ )
            {
                nodeCards = JSON_Array (
                    JSON_Object (
                        "id",           JSON_Int ( i + 1 ),
                        "position",     JSON_Int ( c ),
                        "cardType",     JSON_Int ( -1 ),
                        "cardId",       JSON_Int ( -1 )
                    )
                ) ;

                node = JSON_Append ( node, nodeCards ) ;
            }

            global_string [ 0 ] = EOS ;
            JSON_Stringify ( node, global_string, sizeof global_string ) ;
            onServerSendData ( playerid, UI_CASINO_BLACKJACK, BJ_UPDATE_CARD_INFO, global_string ) ;
            continue ;
        }

        _playerId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] ;

        node = JSON_Array ( ) ;
        for ( new c = 0, Node: nodeCards ; c < MAX_PLAYER_CARDS ; c ++ )
        {
            if ( playerCards [ _playerId ] [ c ] == -1 )
            {
                nodeCards = JSON_Array (
                    JSON_Object (
                        "id",           JSON_Int ( i + 1 ),
                        "position",     JSON_Int ( c ),
                        "cardType",     JSON_Int ( -1 ),
                        "cardId",       JSON_Int ( -1 )
                    )
                ) ;

                node = JSON_Append ( node, nodeCards ) ;
                continue ;
            }

            _id = playerCards [ _playerId ] [ c ] ;
            _score += bj_card_info [ _id ] [ card_score ] ;

            if ( _status == BJ_START )
            {
                if ( _score == MAX_BJ_SCORE ) _bg = 2 ;
                else if ( _score > MAX_BJ_SCORE ) _bg = 3 ;
                else _bg = 1 ;
            }
            else if ( _status == BJ_FINISH )
            {
                new _dealerScore = getDealerScore ( _b_id, _table_id ) ;
                if ( _dealerScore > MAX_BJ_SCORE )
                {
                    if ( _score <= MAX_BJ_SCORE ) _bg = 2 ;
                    else _bg = 3 ;
                }
                else
                {
                    if ( _score > MAX_BJ_SCORE ) _bg = 3 ;
                    else if ( _score < _dealerScore ) _bg = 3 ;
                    else _bg = 2 ;
                }
            }

            nodeCards = JSON_Array (
                JSON_Object (
                    "id",           JSON_Int ( i + 1 ),
                    "position",     JSON_Int ( c ),
                    "cardType",     JSON_Int ( bj_card_info [ _id ] [ card_suit ] ),
                    "cardId",       JSON_Int ( bj_card_info [ _id ] [ card_id ] )
                )
            ) ;

            node = JSON_Append ( node, nodeCards ) ;
        }

        global_string [ 0 ] = EOS ;
        JSON_Stringify ( node, global_string, sizeof global_string ) ;
        onServerSendData ( playerid, UI_CASINO_BLACKJACK, BJ_UPDATE_CARD_INFO, global_string ) ;

        format ( _str, sizeof _str, "ОЧКИ: %d", _score ) ;
        node = JSON_Object (
            "id",           JSON_Int ( i + 1 ),
            "name",         JSON_String ( p_info [ _playerId ] [ name ] ),
            "score",        JSON_String ( _str ),
            "bg",           JSON_Int ( _bg )
        ) ;

        global_string [ 0 ] = EOS ;
        JSON_Stringify ( node, global_string, sizeof global_string ) ;
        onServerSendData ( playerid, UI_CASINO_BLACKJACK, BJ_UPDATE_PLAYER_INFO, global_string ) ;
    }
    return 1 ;
}

stock getFreeCardId ( _b_id, _table_id )
{
    new _card_id = -1, _random, _iteration = 0 ;
    do
    {
        _random = random ( MAX_CARDS ) ;
        _iteration ++ ;
    }
    while ( bj_card_table [ _b_id - 1 ] [ _table_id - 1 ] [ _random ] [ card_active ] && _iteration < 10 ) ;

    if ( ! bj_card_table [ _b_id - 1 ] [ _table_id - 1 ] [ _random ] [ card_active ] )
    {
        for ( new i = 0 ; i < MAX_CARDS ; i ++ )
        {
            if ( ! bj_card_table [ _b_id - 1 ] [ _table_id - 1 ] [ i ] [ card_active ] ) continue ;

            bj_card_table [ _b_id - 1 ] [ _table_id - 1 ] [ i ] [ card_active ] = true ;
            _card_id = i ;
            break ;
        }
    }
    else
    {
        bj_card_table [ _b_id - 1 ] [ _table_id - 1 ] [ _random ] [ card_active ] = true ;
        _card_id = _random ;
    }

    return _card_id ;
}

stock setDealerPacket ( playerid, _b_id, _table_id )
{
	#if defined debug_packet
		printf ( "[setDealerPacket] playerid: %d", playerid ) ;
	#endif

    new Node: node = JSON_Array ( ), _card, _score, _str [ 24 ] ;
    for ( new c = 0, Node: nodeCards ; c < MAX_PLAYER_CARDS ; c ++ )
    {
        _card = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_dealer_card ] [ c ] ;
        if ( _card == -1 )
        {
            nodeCards = JSON_Array (
                JSON_Object (
                    "id",           JSON_Int ( DEALER_TABLE_ID ),
                    "position",     JSON_Int ( c ),
                    "cardType",     JSON_Int ( -1 ),
                    "cardId",       JSON_Int ( -1 )
                )
            ) ;
            node = JSON_Append ( node, nodeCards ) ;
            continue ;
        }
        else if ( _card == 0 )
        {
            node = JSON_Array (
                JSON_Object (
                    "id",           JSON_Int ( DEALER_TABLE_ID ),
                    "position",     JSON_Int ( c ),
                    "cardType",     JSON_Int ( 0 ),
                    "cardId",       JSON_Int ( 0 )
                )
            ) ;
            node = JSON_Append ( node, nodeCards ) ;
            continue ;
        }

        _score += bj_card_info [ _card ] [ card_score ] ;
        node = JSON_Array (
            JSON_Object (
                "id",           JSON_Int ( DEALER_TABLE_ID ),
                "position",     JSON_Int ( c ),
                "cardType",     JSON_Int ( bj_card_info [ _card ] [ card_suit ] ),
                "cardId",       JSON_Int ( bj_card_info [ _card ] [ card_id ] )
            )
        ) ;
        node = JSON_Append ( node, nodeCards ) ;
    }
    global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_CASINO_BLACKJACK, BJ_UPDATE_CARD_INFO, global_string ) ;

    format ( _str, sizeof _str, "ОЧКИ: %d", _score ) ;
    node = JSON_Object (
        "id",           JSON_Int ( DEALER_TABLE_ID ),
        "name",         JSON_String ( "" ),
        "score",        JSON_String ( _str ),
        "bg",           JSON_Int ( 0 )
    ) ;

    global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_CASINO_BLACKJACK, BJ_UPDATE_PLAYER_INFO, global_string ) ;
}

stock getDealerScore ( _b_id, _table_id )
{
    new _card, _score = 0 ;
    for ( new c = 0 ; c < MAX_PLAYER_CARDS ; c ++ )
    {
        _card = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_dealer_card ] [ c ] ;
        if ( _card == -1 ) continue ;

        _score += bj_card_info [ _card ] [ card_score ] ;
    }
    return _score ;
}

stock getPlayerScore ( playerid )
{
    new _cardId, _score ;
    for ( new c = 0 ; c < MAX_PLAYER_CARDS ; c ++ )
    {
        if ( playerCards [ playerid ] [ c ] == -1 ) continue ;

        _cardId = playerCards [ playerid ] [ c ] ;
        _score += bj_card_info [ _cardId ] [ card_score ] ;
    }
    return _score ;
}

stock clear_bj_table ( _b_id, _table_id )
{
    new Node: node, _playerId, _bjPlayerId ;
    for ( new i = 0 ; i < MAX_BJ_PLAYERS ; i ++ )
    {
        _playerId = blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player ] [ i ] ;
        if ( _playerId != -1 )
        {
            for ( new c = 0 ; c < MAX_PLAYER_CARDS ; c ++ )
            {
                playerCards [ _bjPlayerId ] [ c ] = -1 ;
            }
        }
    }

    for ( new c = 0 ; c < MAX_PLAYER_CARDS ; c ++ )
    {
        blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_dealer_card ] [ c ] = -1 ;
    }

    blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_player_move ] = -1 ;
    blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_status ] = BJ_WAITINIG ;
    blackjack [ _b_id - 1 ] [ _table_id - 1 ] [ bj_time ] = MOVE_BJ_TIME ;
}