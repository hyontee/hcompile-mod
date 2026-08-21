static const Float: numbersWeight [ 7 ] = { 0.50, 0.25, 0.14, 0.05, 0.03, 0.02, 0.01 } ; // Вероятность от 0 до 1 
static const moneyMultiplier [ 7 ] = { 1, 3, 5, 10, 25, 50, 100 } ;  

static playerBet [ MAX_PLAYERS ] ; 

static enum    
{  
    ACTION_TYPE_SET_BET,   
    ACTION_TYPE_START_SPIN,
    ACTION_TYPE_CONTINUE   
}

#define MAX_ROULETTE_SLOTS 4

static const Float: tablePosition [ ] [ 3 ] =
{
    { 2349.627, 99.833, 801.000 },
    { 2346.602, 98.258, 801.000 },
    { 2344.645, 98.264, 801.000 },
    { 2341.477, 99.803, 801.000 }
} ;

stock slots_OnGameModeInit ( )
{
    for ( new i = 0 ; i < MAX_ROULETTE_SLOTS ; i ++ )
    {
        CreateDynamic3DTextLabel ( "** Слоты **\n{"#cGR3D"}Подойдите для взаимодействия", col_header_3d, tablePosition [ i ] [ 0 ], tablePosition [ i ] [ 1 ], tablePosition [ i ] [ 2 ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 22 );
        new _areaid = CreateDynamicSphere ( tablePosition [ i ] [ 0 ], tablePosition [ i ] [ 1 ], tablePosition [ i ] [ 2 ], 2.5, -1, -1, -1 ) ;
		area_info [ _areaid ] [ a_type ] = area_type_jackpot ;
    }
    return 1 ;
}

stock ShowPlayerCasinoSlots ( playerid )  
{  
	#if defined debug_packet
		printf ( "[ShowPlayerCasinoSlots] playerid: %d", playerid ) ;
	#endif

    SetPlayerBet ( playerid, 0 ) ; 
    toggle_controlable ( playerid, false ) ;
    return true ;   
}

stock slots_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
    #pragma unused listitem
    switch ( dialogid )
    {
        case d_slots_bet:
        {
            if ( ! response ) return 1 ;

            new inputBet = strval ( inputtext ) ;  
            if ( inputBet < 1 || inputBet > 500 ) {   
                send_check_cinfo ( playerid, "Количество фишек должно быть не менее 5 и не более 500!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		        return 1 ;
            }  

            if ( inputBet > GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_CASINO_CHIPS ) )    
            {  
                send_check_cinfo ( playerid, "У Вас недостаточно фишек!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		        return 1 ;
            }  

            SetPlayerBet ( playerid, inputBet ) ;
            return 1 ;
        }
    }
    return 0 ;
}

stock show_packet_jackpot ( playerid, actionId, data [ ] )
{
    #pragma unused data
    if ( actionId == ACTION_TYPE_SET_BET )
    {  
         show_dialog ( playerid, d_slots_bet, DIALOG_STYLE_INPUT, "{"#cBHD"}Ставка", "\
            {"#cWH"}Введите количество фишек, на которое будете играть:\n\n\
            {"#cGRDialog"}* Количество фишек должно быть не менее 5 и не более 500.", "Поставить", "Выйти" ) ;
    }  
    if ( actionId == ACTION_TYPE_START_SPIN )
    {  
        if ( playerBet [ playerid ] == 0 )
        {
		    send_check_cinfo ( playerid, "Установите ставку!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		    return 1 ;
        }  

        if ( playerBet [ playerid ] > GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_CASINO_CHIPS ) )
        {
		    send_check_cinfo ( playerid, "У Вас недостаточно фишек!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		    return 1 ;
        }  

        GivePlayerCasinoChips ( playerid, playerBet [ playerid ], false ) ;
        UpdateClientChips ( playerid ) ;

        GenerateSlotsCombination ( playerid ) ;
    }  
    if ( actionId == ACTION_TYPE_CONTINUE )
    {  
        if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_CASINO_CHIPS ) >= playerBet [ playerid ] ) SetPlayerBet ( playerid, playerBet [ playerid ] ) ;   
        else SetPlayerBet ( playerid, 0 ) ;
    }
    else if ( actionId == 3 ) // exit
    {
	    toggle_controlable ( playerid, true ) ;
    }
    return 1 ;
}

static stock SetPlayerBet ( playerid, bet )   
{  
    playerBet [ playerid ] = bet ; 
    UpdateClientChips ( playerid ) ;   
    return true ;   
}  

static stock UpdateClientChips ( playerid )   
{  
    new Node: node = JSON_Object (  
        "totalChips",  JSON_Int ( GetInventoryFindItem ( playerid, SUB_INVENTORY, ITEM_CASINO_CHIPS ) ), 
        "currentChip", JSON_Int ( playerBet [ playerid ] )   
    ) ; 

    global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_CASINO_SLOTS, ACTION_TYPE_SET_BET, global_string ) ;
    return true ;   
}  

static stock GenerateSlotsCombination ( playerid )
{  
    new generatedNumbers [ 3 ], chipsValue = playerBet [ playerid ] ;  

    for ( new i = 0 ; i < 3 ; i ++ )
    {   
        generatedNumbers [ i ] = GetRandomWeightedNumber ( numbersWeight ) + 1 ;   
    }
    
    if ( generatedNumbers [ 0 ] == generatedNumbers [ 1 ] && generatedNumbers [ 1 ] == generatedNumbers [ 2 ] )   
    {  
        new combinationIdx = generatedNumbers [ 0 ] - 1 ;
        chipsValue *= moneyMultiplier [ combinationIdx ] ;

        GivePlayerCasinoChips ( playerid, chipsValue, true ) ;
    }
    else
    {
        new combinationIdx = generatedNumbers [ 0 ] - 1 ;  
        new biz_chipsValue ;
        biz_chipsValue *= moneyMultiplier [ combinationIdx ] ; 

        new chipsPrice = biz_chipsValue * CASINO_CHIP_PRICE ;
        give_bmoney ( GetPVarInt ( playerid, "p_biz_id" ), chipsPrice, 0 ) ;
    }

    new combinationStr [ 4 ] ; 
    format ( combinationStr, 4, "%d%d%d", generatedNumbers [ 0 ], generatedNumbers [ 1 ], generatedNumbers [ 2 ] ) ;

    new Node: node = JSON_Object (   
        "resultChip",    JSON_Int ( chipsValue ),
        "combination",   JSON_String ( combinationStr )
    ) ; 

    global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_CASINO_SLOTS, ACTION_TYPE_START_SPIN, global_string ) ;
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