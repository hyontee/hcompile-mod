#define CROUPIE_POSITION    6

static playerBet [ MAX_PLAYERS ] ; 

static enum    
{  
    DICE_UPDATE_BID,
    DICE_UPDATE_FIRST_DICE,
    DICE_UPDATE_TWO_DICE,
    DICE_UPDATE_PLAYER,
    DICE_UPDATE_CASINO,
    DICE_UPDATE_BUTTON
} ;

stock update_window_place ( playerid, _place, _b_id, _table )
{
    new _playerId = dice_info [ _b_id ] [ _table - 1 ] [ b_player ] [ _place ],
        _in_game = GetPVarInt ( _playerId, "InGame" ), _gameCount = 0, _str [ 32 ], _str2 [ 64 ] ;

    if ( _in_game > 1 )
    {
        _gameCount = _in_game ;
        format ( _str2, sizeof _str2, "{"#cGRDialog"}Ставка: {"#cWH"}%d", dice_info [ _b_id ] [ _table - 1 ] [ b_bet ] ) ;
    }
    else
    {
        _gameCount = 0 ;
        format ( _str2, sizeof _str2, "{"#cGRDialog"}Ставка: {"#cWH"}0", 0 ) ;
    }

    if ( _playerId == playerid ) format ( _str, sizeof _str, "Это Вы {"#cGRDialog"}[%d]", _gameCount ) ;
    else format ( _str, sizeof _str, "%s {"#cGRDialog"}[%d]", p_info [ _playerId ] [ name ], _gameCount ) ;
    new Node: node = JSON_Object (
        "id",           JSON_Int ( _place + 1 ),
        "skinId",       JSON_Int ( getNewSkinModel ( _playerId ) ),
        "name",         JSON_String ( _str ),
        "bet",          JSON_String ( _str2 )
    ) ;

    global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_CASINO_DICE, DICE_UPDATE_PLAYER, global_string ) ;

    _playerId = dice_info [ _b_id ] [ _table - 1 ] [ b_crupie ] ;
    if ( _playerId != INVALID_PLAYER_ID )
    {
        format ( _str, sizeof _str, "%s", p_info [ _playerId ] [ name ] ) ;
        node = JSON_Object (
            "id",           JSON_Int ( 6 ),
            "skinId",       JSON_Int ( getNewSkinModel ( _playerId ) ),
            "name",         JSON_String ( _str ),
            "bet",          JSON_String ( "Крупье" )
        ) ;

        global_string [ 0 ] = EOS ;
        JSON_Stringify ( node, global_string, sizeof global_string ) ;
        onServerSendData ( playerid, UI_CASINO_DICE, DICE_UPDATE_PLAYER, global_string ) ;
    }
    else
    {
        node = JSON_Object (
            "id",           JSON_Int ( 6 ),
            "skinId",       JSON_Int ( 1 ),
            "name",         JSON_String ( "Нет" ),
            "bet",          JSON_String ( "Крупье" )
        ) ;

        global_string [ 0 ] = EOS ;
        JSON_Stringify ( node, global_string, sizeof global_string ) ;
        onServerSendData ( playerid, UI_CASINO_DICE, DICE_UPDATE_PLAYER, global_string ) ;
    }
}

stock update_window_free_place ( playerid, _place, _b_id, _table )
{
    new _str [ 32 ] ;
    format ( _str, sizeof _str, "Свободное место" ) ;
    new Node: node = JSON_Object (
        "id",           JSON_Int ( _place + 1 ),
        "skinId",       JSON_Int ( 1 ),
        "name",         JSON_String ( _str ),
        "bet",          JSON_String ( "{"#cGRDialog"}Ставка: {"#cWH"}0" )
    ) ;

    global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_CASINO_DICE, DICE_UPDATE_PLAYER, global_string ) ;

    new _playerId = dice_info [ _b_id ] [ _table - 1 ] [ b_crupie ] ;
    if ( _playerId != INVALID_PLAYER_ID )
    {
        format ( _str, sizeof _str, "%s", p_info [ _playerId ] [ name ] ) ;
        node = JSON_Object (
            "id",           JSON_Int ( 6 ),
            "skinId",       JSON_Int ( getNewSkinModel ( _playerId ) ),
            "name",         JSON_String ( _str ),
            "bet",          JSON_String ( "Крупье" )
        ) ;

        global_string [ 0 ] = EOS ;
        JSON_Stringify ( node, global_string, sizeof global_string ) ;
        onServerSendData ( playerid, UI_CASINO_DICE, DICE_UPDATE_PLAYER, global_string ) ;
    }
    else
    {
        node = JSON_Object (
            "id",           JSON_Int ( 6 ),
            "skinId",       JSON_Int ( 1 ),
            "name",         JSON_String ( "Нет" ),
            "bet",          JSON_String ( "Крупье" )
        ) ;

        global_string [ 0 ] = EOS ;
        JSON_Stringify ( node, global_string, sizeof global_string ) ;
        onServerSendData ( playerid, UI_CASINO_DICE, DICE_UPDATE_PLAYER, global_string ) ;
    }
}

stock show_packet_dice ( playerid, actionId, data [ ] )
{
    #pragma unused data
    if ( actionId == 0 ) // exit
    {
        if ( player_croupier [ playerid ] ) ExitBone ( playerid ) ;
	    else show_dialog ( playerid, d_dice_exit, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Предупреждение", "{ffffff}Если вы сделали ставку и игра уже началась, то деньги Вам возвращены не будут\n\n{"#cGRDialog"}* Вы действительно хотите покинуть стол?", "Выйти", "Отмена" ) ;
    }
    else if ( actionId == 1 ) // dice button
    {
        if ( player_croupier [ playerid ] )
		{
			new null = 0, biz_id = GetPVarInt ( playerid, "p_biz_id" ), _table = player_dice_table { playerid } ;
			for ( new i = 0 ; i < 5 ; i ++ ) if ( GetPVarInt ( dice_info [ biz_id ] [ _table - 1 ] [ b_player ] [ i ], "InGame")) null++ ;
			if ( null < 2 )
			{
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кости", "{"#cRD"}* {"#cGRDialog"}Не хватает игроков для старта.", "Закрыть", "" ) ;
				return 1 ;
			}
			if ( dice_info [ biz_id ] [ _table - 1 ] [ b_started ] > 0 )
			{
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кости", "{"#cRD"}* {"#cGRDialog"}Игра уже запущена.", "Закрыть", "" ) ;
				return 1 ;
			}

			dice_info [ biz_id ] [ _table - 1 ] [ b_started ] = 30 ;
			dice_info [ biz_id ] [ _table - 1 ] [ b_timer ] = SetTimerEx ( "dice_timer", 1000, true, "ii", biz_id, _table - 1 ) ;
			return 1 ;
		}
		else
		{
			new null = 0, biz_id = GetPVarInt ( playerid, "p_biz_id" ), _table = player_dice_table { playerid } ;
            if ( dice_info [ biz_id ] [ _table - 1 ] [ b_started ] > 0 )
            {
                if ( ! GetPVarInt ( playerid, "InGame" ) )
                {
                    show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кости", "{"#cRD"}* {"#cGRDialog"}Вы не поставили ставку.", "Закрыть", "" ) ;
                    return 1 ;
                }
                if ( dice_info [ biz_id ] [ _table - 1 ] [ b_started ] <= 0 )
                {
                    show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кости", "{"#cRD"}* {"#cGRDialog"}В данный момент нельзя кинуть кости.", "Закрыть", "" ) ;
                    return 1 ;
                }
                if ( GetPVarInt ( playerid, "InGame" ) > 1 )
                {
                    show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кости", "{"#cRD"}* {"#cGRDialog"}Вы уже кидали кубики в этом раунде.", "Закрыть", "" ) ;
                    return 1 ;
                }
                SetPVarInt ( playerid, "InGame", random ( 11 ) + 2 ) ;
                update_bone ( _table - 1, biz_id ) ;

                new i ;
                for ( new g = 0 ; g < MAX_PLAYER_DICE - 1 ; g ++ )
                {
                    i = dice_info [ biz_id ] [ _table - 1 ] [ b_player ] [ g ] ;
                    if ( ! IsPlayerConnected ( i ) ) continue ;

                    if ( GetPVarInt ( i, "InGame") == 1 ) null ++ ;
                }
                if ( ! null ) dice_info [ biz_id ] [ _table - 1 ] [ b_started ] = 4 ;
            }
            else
            {
                if ( player_croupier [ playerid ] )
                {
                    for ( new i = 0 ; i < 5 ; i ++ ) if ( GetPVarInt ( dice_info [ biz_id ] [ _table - 1 ] [ b_player ] [ i ], "InGame" ) ) null++ ;
                    if ( null > 0 )
                    {
                        show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кости", "{"#cRD"}* {"#cGRDialog"}В данный момент вы не можете изменить ставку.", "Закрыть", "" ) ;
                        return 1 ;
                    }
                    return show_dialog ( playerid, d_dice_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Установка ставки для игры","{ffffff}Введите сумму для ставки\n\n{"#cGRDialog"}* Ставка должна быть не менее 1.000 фишек и не более 300.000.000 фишек","Далее","Отмена");
                }
                if ( ! dice_info [ biz_id ] [ _table - 1 ] [ b_bet ] )
                {
                    show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кости", "{"#cRD"}* {"#cGRDialog"}Ставка не установлена.", "Закрыть", "" ) ;
                    return 1 ;
                }
                if ( GetPVarInt ( playerid, "InGame" ) )
                {
                    show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кости", "{"#cRD"}* {"#cGRDialog"}Вы уже поставили ставку.", "Закрыть", "" ) ;
                    return 1 ;
                }
                if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_CASINO_CHIPS ) < dice_info [ biz_id ] [ _table - 1 ] [ b_bet ] )
                {
                    show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кости", "{"#cRD"}* {"#cGRDialog"}Недостаточно средств.", "Закрыть", "" ) ;
                    return 1 ;
                }
                if ( dice_info [ biz_id ] [ _table - 1 ] [ b_started ] > 0 )
                {
                    show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Кости", "{"#cRD"}* {"#cGRDialog"}Игра уже запущена.", "Закрыть", "" ) ;
                    return 1 ;
                }
                clear_inventory (
                    playerid,
                    ITEM_CASINO_CHIPS,
                    dice_info [ biz_id ] [ _table - 1 ] [ b_bet ]
                ) ;

                dice_info [ biz_id ] [ _table - 1 ] [ b_bank ] += dice_info [ biz_id ] [ _table - 1 ] [ b_bet ] ;
                SetPVarInt ( playerid, "InGame", 1 ) ;
                update_bone ( _table - 1, biz_id ) ;
                update_bone_table ( biz_id, _table - 1 ) ;
			    updateCasinoButton ( playerid, "БРОСИТЬ" ) ;
            }
		}
    }
    return 1 ;
}

stock updateDiceChips ( playerid )
{
    new _b_id = GetPVarInt ( playerid, "p_biz_id" ), _table = player_dice_table { playerid } ;
    new Node: node = JSON_Object (
        "bid",          JSON_Int ( dice_info [ _b_id ] [ _table - 1 ] [ b_bank ] ),
        "chips",        JSON_Int ( GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_CASINO_CHIPS ) )
    ) ;

    global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_CASINO_DICE, DICE_UPDATE_BID, global_string ) ;
    return 1 ;
}

stock updateCasinoState ( playerid, _str [ ] )
{
    onServerSendData ( playerid, UI_CASINO_DICE, DICE_UPDATE_CASINO, _str ) ;
    return 1 ;
}

stock updateCasinoButton ( playerid, _str [ ] )
{
    onServerSendData ( playerid, UI_CASINO_DICE, DICE_UPDATE_BUTTON, _str ) ;
    return 1 ;
}