#define MAX_ROULETTE_TABLES	2

const CASINO_CHIP_PRICE = 100_000 ;

static enum 
{
    ACTION_TYPE_UPDATE_CHIPS,
    ACTION_TYPE_UPDATE_SECONDS,
    ACTION_TYPE_UPDATE_NUMBER,
    ACTION_TYPE_GIVE_WIN,
    ACTION_TYPE_UPDATE_LAST_BETS,
    ACTION_TYPE_UPDATE_BUTTON
}

static enum 
{
    ROULETTE_STATE_IDLE,
    ROULETTE_STATE_BETS,
    ROULETTE_STATE_STARTED,
    ROULETTE_STATE_END
}

static enum ROULETTE_DATA
{
    ROULETTE_STATE,
    ROULETTE_TIMER,
    ROULETTE_BETS_COUNT,
    ROULETTE_LAST_NUMBERS [ 5 ]
}

new rouletteTable [ MAX_BUSINESS ] [ MAX_ROULETTE_TABLES ] [ ROULETTE_DATA ] ;

static enum 
{
    BET_TYPE_ZERO,
    BET_TYPE_NUMBER,
    BET_TYPE_RED,
    BET_TYPE_BLACK
}

static playerBet [ MAX_PLAYERS ] ;
static playerBetType [ MAX_PLAYERS char ] ;
static playerTable [ MAX_PLAYERS char ] = { 255, ... } ;
static playerPosition [ MAX_PLAYERS char ] ;

static const betMultiplier [ ] = { 22, 10, 2, 2 } ;

static const Float: tablePosition [ ] [ 3 ] =
{
    { 2333.980, 104.413, 802.031 },
    { 2330.847, 103.454, 802.031 }
} ;

stock roulette_OnGameModeInit ( )
{
    for ( new i = 0 ; i < MAX_ROULETTE_TABLES ; i ++ )
    {
        CreateDynamic3DTextLabel ( "** Рулетка **\n{"#cGR3D"}Подойдите для взаимодействия", col_header_3d, tablePosition [ i ] [ 0 ], tablePosition [ i ] [ 1 ], tablePosition [ i ] [ 2 ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 22 );
        new _areaid = CreateDynamicSphere ( tablePosition [ i ] [ 0 ], tablePosition [ i ] [ 1 ], tablePosition [ i ] [ 2 ], 3.0, -1, -1, -1 ) ;
		area_info [ _areaid ] [ a_type ] = area_type_roulette ;
        area_info [ _areaid ] [ a_item ] = i ;
    }
    return 1 ;
}

stock show_window_roulette ( playerid, tableid )
{
	#if defined debug_packet
		printf ( "[show_window_roulette] playerid: %d", playerid ) ;
	#endif

    playerTable { playerid } = tableid ;

    SendClientSecondsLeft ( playerid, tableid ) ;
    ResetPlayerBet ( playerid ) ;

    SendClientLastBids ( playerid, tableid ) ;
    SendClientChips ( playerid ) ;
    SendClientButtonState ( playerid, tableid ) ;

	toggle_controlable ( playerid, false ) ;
}

stock show_packet_roulette ( playerid, actionId, data [ ] )
{
	if ( actionId == 0 ) // set bet
	{
        new Node: node ;
        JSON_Parse ( data, node ) ;

        new bet, _position ; 
        JSON_GetInt ( node, "chipsCount", bet ) ;
        JSON_GetInt ( node, "position", _position ) ;

        if ( bet == -1 ) return ResetPlayerBet ( playerid ) ;

        SetPlayerBet ( playerid, bet, _position ) ;
	}
	else if ( actionId == 1 ) // end game
	{
		new tableid = playerTable { playerid }, _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
        if ( tableid == 255 ) return false ;

        SendClientLastBids ( playerid, tableid ) ;

        if ( playerBet [ playerid ] > 0 ) 
        {
            new lastNumber = rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_LAST_NUMBERS ] [ 4 ],
                isWinner = IsPlayersWin ( playerid, lastNumber ) ;

            new chipsReward = playerBet [ playerid ] ;
            if ( isWinner ) 
            {
                chipsReward *= betMultiplier [ playerBetType { playerid } ] ;
                GivePlayerCasinoChips ( playerid, chipsReward, true ) ;
            }
            else
            {
                new chipsPrice = betMultiplier [ playerBetType { playerid } ] * CASINO_CHIP_PRICE ;
				give_bmoney ( GetPVarInt ( playerid, "p_biz_id " ) - 1, chipsPrice, 0 ) ;
            }

            SendClientEndingScreen ( playerid,  isWinner ? true : false, chipsReward ) ;
            playerBet [ playerid ] = 0 ;
        }

        SendClientSecondsLeft ( playerid, tableid ) ;
        SendClientChips ( playerid ) ;
        SendClientButtonState ( playerid, tableid ) ;
	}
    else if ( actionId == 2 ) // exit
    {
		toggle_controlable ( playerid, true ) ;
    }
	return 1 ;
}

static stock IsPlayersWin ( playerid, winnerNumber )
{
    new betType = playerBetType { playerid } ;

    if ( betType == BET_TYPE_ZERO && winnerNumber == 0 ) return true ;
    else
    {
        if ( betType == BET_TYPE_NUMBER && winnerNumber == playerPosition { playerid } ) return true;
        else if ( betType == BET_TYPE_RED && ( winnerNumber % 2 ) == 0 ) return true ;
        else if ( betType == BET_TYPE_BLACK && ( winnerNumber % 2 ) != 0 ) return true ;
    }
    return false ;
}

static stock SendClientChips ( playerid )
{
    new chipsStr [ 12 ] ;
    valstr ( chipsStr, GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_CASINO_CHIPS ) ) ;
    onServerSendData ( playerid, UI_CASINO_ROULETTE, ACTION_TYPE_UPDATE_CHIPS, chipsStr ) ; 
    return true ;
}

static stock SendClientEndingScreen ( playerid, bool: status, chips )
{
    new Node: node = JSON_Object (
        "chipsCount", 		JSON_Int ( chips ),
        "status", 			JSON_Int ( status )
    ) ;

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_CASINO_ROULETTE, ACTION_TYPE_GIVE_WIN, global_string ) ;
    return true ;
}

static stock SendClientButtonState ( playerid, tableid )
{
    new stateStr [ 2 ], stateid, bool: hasBet = ( playerBet [ playerid ] > 0 ), _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
    switch ( rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_STATE ] )
    {
        case ROULETTE_STATE_BETS, ROULETTE_STATE_IDLE: stateid = ( hasBet ) ? ( 3 ) : ( 1 ) ;
        case ROULETTE_STATE_STARTED: stateid = ( hasBet ) ? ( 2 ) : ( 0 ) ;
    }

    valstr ( stateStr, stateid ) ;
    onServerSendData ( playerid, UI_CASINO_ROULETTE, ACTION_TYPE_UPDATE_BUTTON, stateStr ) ;
    return true ;
}

static stock SendClientLastBids ( playerid, tableid )
{
    new Node: node = JSON_Array ( ), _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
    for ( new i = 0, Node: numberNode ; i < 5 ; i ++ ) 
    {
        numberNode = JSON_Array (
            JSON_Object (
                "id", 			JSON_Int ( rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_LAST_NUMBERS ] [ i ] )
            )
        ) ;
        node = JSON_Append ( node, numberNode ) ;
    }

	global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_CASINO_ROULETTE, ACTION_TYPE_UPDATE_LAST_BETS, global_string ) ;
    return true ;
}

static stock SetPlayerBet ( playerid, newBet, _position )
{
    new tableid = playerTable { playerid }, _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
    if ( tableid == 255 ) return false ;

    if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_CASINO_CHIPS ) < newBet )
	{
		send_check_cinfo ( playerid, "У Вас недостаточно фишек!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
    }

    if ( rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_STATE ] == ROULETTE_STATE_STARTED )
	{
		send_check_cinfo ( playerid, "В данный момент ставки не принимаются!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
    }

    if ( newBet < 5 || newBet > 500 )
	{
		send_check_cinfo ( playerid, "Количество фишек должно быть не менее 5 и не более 500!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
    }

    if ( ++ rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_BETS_COUNT ] > 0 && 
		rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_STATE ] == ROULETTE_STATE_IDLE ) 
    {
        UpdateRouletteState ( _b_id, tableid, ROULETTE_STATE_BETS, 20 ) ;

        foreach(new i: logged_players) 
        {
            if ( playerTable { i } != tableid ) continue ;
			if ( GetPVarInt ( i, "p_biz_id" ) != _b_id ) continue ;
            SendClientSecondsLeft ( i, tableid ) ;
        }
    }

    switch ( _position )
    {
        case 0: playerBetType { playerid } = BET_TYPE_ZERO ;
        case 22: playerBetType { playerid } = BET_TYPE_RED ;
        case 23: playerBetType { playerid } = BET_TYPE_BLACK ;
        default: playerBetType { playerid } = BET_TYPE_NUMBER ;
    }

    playerBet [ playerid ] = newBet ;
    playerPosition { playerid } = _position ;

    GivePlayerCasinoChips ( playerid, newBet, false ) ;

    SendClientChips ( playerid ) ;
    SendClientButtonState ( playerid, tableid ) ;
    return true ;
}

static stock ResetPlayerBet ( playerid )
{
    new currentBet = playerBet [ playerid ] ;
    if ( currentBet == 0 ) return false ;

    new tableid = playerTable { playerid }, _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
    if ( rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_STATE ] == ROULETTE_STATE_BETS )
    {
        if ( -- rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_BETS_COUNT ] < 1 ) 
        {
            UpdateRouletteState ( _b_id, tableid, ROULETTE_STATE_IDLE, 0 ) ;

            foreach(new i: logged_players) 
            {
                if ( playerTable { i } != tableid ) continue ;
				if ( GetPVarInt ( i, "p_biz_id" ) != _b_id ) continue ;
                SendClientSecondsLeft ( i, tableid ) ;
            }
        }
        GivePlayerCasinoChips ( playerid, currentBet, true ) ;
    }

    playerBet [ playerid ] = 0 ;

    SendClientButtonState ( playerid, tableid ) ;
    SendClientChips ( playerid ) ;
    return true ;
}

static stock UpdateRouletteState ( _b_id, tableid, newState, timeLeft )
{
    rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_STATE ] = newState ;
    rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_TIMER ] = timeLeft ;
    return true ;
}

static stock SendClientSecondsLeft ( playerid, tableid )
{
    new secondsStr [ 3 ], _b_id = GetPVarInt ( playerid, "p_biz_id" ) ;
    valstr ( secondsStr, rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_TIMER ] ) ;
    onServerSendData ( playerid, UI_CASINO_ROULETTE, ACTION_TYPE_UPDATE_SECONDS, secondsStr ) ; 
    return true ;
}

static stock GivePlayerCasinoChips ( playerid, chips, bool: status )    
{   
	if ( ! status ) clear_inventory ( playerid, ITEM_CASINO_CHIPS, chips ) ;
	else
	{
		give_inventory (
			playerid,
			ITEM_CASINO_CHIPS,
			chips,
			0,
			"",
			"",
			NUMBERPLATE_TYPE_NONE,
			0
		) ;
	}
}

stock RouletteSecondTimer ( )
{
	foreach(new b: business_types[bizz_type_casino])
	{
		for ( new tableid ; tableid < MAX_ROULETTE_TABLES ; tableid ++ )
		{
			if ( rouletteTable [ b ] [ tableid ] [ ROULETTE_TIMER ] > 0 )
			{
				if ( -- rouletteTable [ b ] [ tableid ] [ ROULETTE_TIMER ] > 0 ) continue ;

				switch ( rouletteTable [ b ] [ tableid ] [ ROULETTE_STATE ] )
				{
					case ROULETTE_STATE_BETS: SpinRoulette ( b, tableid ) ;
					case ROULETTE_STATE_STARTED: 
					{
						UpdateRouletteState ( b, tableid, ROULETTE_STATE_IDLE, 0 ) ;
						rouletteTable [ b ] [ tableid ] [ ROULETTE_BETS_COUNT ] = 0 ;
					}
				}
			}
		}
	}
    return true ;
}

static stock SpinRoulette ( _b_id, tableid )
{
    new randomNumber [ 3 ], _number = random ( 22 ) ;
    valstr ( randomNumber, _number ) ;

    UpdateRouletteState ( _b_id, tableid, ROULETTE_STATE_STARTED, 5 ) ;
    AddNumberToTableHistory ( _b_id, tableid, _number ) ;

    foreach(new playerid: logged_players) 
    {
        if ( playerTable { playerid } != tableid ) continue ;
		if ( GetPVarInt ( playerid, "p_biz_id" ) != _b_id ) continue ;

        onServerSendData ( playerid, UI_CASINO_ROULETTE, ACTION_TYPE_UPDATE_NUMBER, randomNumber ) ; 
        SendClientButtonState ( playerid, tableid ) ;
    }
    return true ;
}

static stock AddNumberToTableHistory ( _b_id, tableid, newNumber )
{
    for ( new i = 0 ; i < 4 ; i ++ )
	{
        rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_LAST_NUMBERS ] [ i ] = rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_LAST_NUMBERS ] [ i + 1 ] ;
    }

    rouletteTable [ _b_id ] [ tableid ] [ ROULETTE_LAST_NUMBERS ] [ 4 ] = newNumber ;
    return true ;
}