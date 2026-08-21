new taxiMultiplie = 1 ;

enum TAXI_VEHICLES
{
    TAXI_CLASS,
    TAXI_MODELS,
    TAXI_RENT_PRICE
} ;
new taxi_vehicles [ ] [ TAXI_VEHICLES ] =
{
    { 0, 410, 2500 },
    { 0, 420, 1500 },
    { 0, 440, 5000 },
    { 0, 456, 1000 },

    { 1, 438, 7500 },
    { 1, 445, 10000 },
    { 1, 459, 5000 },
    { 1, 496, 10000 },

    { 2, 458, 15000 },
    { 2, 479, 10000 },
    { 2, 480, 20000 },
    { 2, 504, 20000 }
} ;

new taxiActorNames [ ] [ 12 ] = { "Иван", "Андрей", "Анатолий", "Виталик", "Никита", "Роман", "Алёшка", "Руслан", "Валя", "Витёк" } ;
new taxiActorSkins [ ] = { 1, 2, 6, 7, 11, 12, 13 } ;

new Float: taxiStartPosition [ MAX_PLAYERS ] [ 3 ] ;
new Float: taxiEndPosition [ MAX_PLAYERS ] [ 3 ] ;
new taxiClassSelect [ MAX_PLAYERS ] ;
new taxiDriverId [ MAX_PLAYERS ] ;
new taxiPassenger [ MAX_PLAYERS ] [ 2 ] ;

new Float: taxiActorStartPosition [ MAX_ACTORS ] [ 3 ] ;
new Float: taxiActorEndPosition [ MAX_ACTORS ] [ 3 ] ;
new taxiActorClassSelect [ MAX_ACTORS ] ;

#define MAX_TAXI_PROGRESS   100
#define MAX_TAXI_LEVEL      2

#define MAX_ACTOR_IN_CLASS  10
#define MAX_TAXI_ORDERS     250
enum TAXI_ORDER_INFO
{
    ORDER_ID,
    CLASS_ID,
    ACTOR_NAME_ID,
    bool: IS_PLAYER
} ;
new taxi_order_info [ MAX_TAXI_ORDERS ] [ TAXI_ORDER_INFO ] ;

#define MAX_TAXI_ACTORS     48
new taxiActorClass [ MAX_TAXI_ACTORS ] ;
new bool: taxiActorToggled [ MAX_TAXI_ACTORS ] = { false, ... } ;
new Float: taxiActorPosition [ MAX_TAXI_ACTORS ] [ 4 ] =
{
    { 2744.187, -2417.562, 21.896, 270.378 },
    { 767.686, -1321.354, 40.717, 161.114 },
    { 515.910, 894.810, 12.007, 274.063 },
    { 1848.273, 2045.514, 15.883, 355.274 },
    { 499.355, 570.680, 11.158, 67.702 },
    { -2490.686, 2844.977, 37.636, 102.367 },
    { -484.053, 927.050, 12.148, 272.534 },
    { -479.020, 901.294, 11.952, 273.441 },
    { -482.705, 931.690, 12.148, 266.941 },
    { 1741.073, 2846.959, 11.887, 180.374 },
    { -451.036, 935.888, 11.952, 89.375 },
    { -2393.822, 77.814, 21.452, 72.156 },
    { -426.610, -32.828, 12.172, 61.075 },
    { 1776.663, -2444.138, 11.000, 92.201 },
    { -2469.329, 1659.327, 52.556, 274.096 },
    { 617.891, -1270.699, 40.616, 160.990 },
    { 2655.646, -1621.617, 22.257, 93.179 },
    { 1833.881, 1327.457, 9.757, 169.175 },
    { -559.343, -1576.091, 40.648, 335.233 },
    { 1819.001, 232.847, 7.883, 141.530 },
    { -362.698, 16.121, 12.172, 9.638 },
    { -1709.432, -2796.976, 13.501, 236.284 },
    { 1778.028, 2863.160, 11.893, 272.828 },
    { 1822.133, 2500.429, 15.664, 116.596 },
    { 459.275, 1659.049, 12.133, 82.591 },
    { 460.049, 1670.520, 12.180, 85.250 },
    { 220.471, 544.758, 12.000, 336.041 },
    { 450.613, 1641.126, 12.180, 39.821 },
    { 1804.953, 2527.244, 15.664, 115.491 },
    { 2747.268, -2460.159, 21.688, 286.760 },
    { 2746.665, -2442.650, 21.688, 264.907 },
    { 2774.431, -2433.688, 21.887, 98.686 },
    { -2440.837, 65.778, 21.123, 345.800 },
    { -289.655, 1706.248, 12.276, 357.615 },
    { -866.899, 1200.540, 10.479, 206.100 },
    { 2202.932, 2210.657, 12.238, 0.202 },
    { 2305.336, -2548.405, 21.808, 248.950 },
    { 1669.142, 1295.017, 11.999, 296.346 },
    { 2616.837, -2459.772, 22.011, 86.925 },
    { -72.494, -958.002, 41.266, 50.344 },
    { -2539.345, -774.291, 29.234, 1.852 },
    { 210.616, 657.640, 12.001, 246.722 },
    { -2437.053, 2788.413, 37.632, 191.939 },
    { 2214.754, -2387.783, 21.945, 13.577 },
    { -6.594, 574.736, 12.148, 169.302 },
    { -2471.189, 2847.135, 37.714, 77.068 },
    { -55.324, 1080.999, 12.000, 6.183 },
    { 2018.535, -1027.530, 2.335, 1.698 }
} ;

new Float: taxiActorExitPosition [ MAX_TAXI_ACTORS ] [ 4 ] =
{
    { 739.286, -1343.249, 40.717, 334.368 },
    { 514.109, 961.942, 12.041, 273.563 },
    { 1843.850, 2041.424, 15.883, 9.356 },
    { 510.280, 597.857, 11.158, 76.788 },
    { -2475.267, 2833.089, 37.636, 91.466 },
    { -1507.109, 1604.489, 36.569, 270.107 },
    { 414.462, 395.150, 12.000, 345.675 },
    { 474.923, 1872.100, 12.000, 333.445 },
    { 1730.750, 2832.723, 11.874, 353.249 },
    { -482.353, 923.783, 12.148, 285.989 },
    { -2388.478, 108.598, 21.454, 87.008 },
    { -421.775, -83.256, 12.172, 115.423 },
    { 1776.977, -2420.657, 11.000, 91.318 },
    { -2470.575, 1665.039, 52.643, 271.287 },
    { -18.751, -2789.119, 38.602, 103.154 },
    { 2165.964, -1960.033, 18.812, 269.654 },
    { 1802.767, 1328.642, 9.756, 183.030 },
    { 742.694, -2313.069, 36.558, 255.349 },
    { 2407.081, -2026.605, 21.977, 266.108 },
    { -343.218, 13.074, 12.172, 347.951 },
    { -1692.842, -2810.757, 14.233, 335.518 },
    { 1768.271, 2833.719, 11.948, 352.705 },
    { 1823.464, 2497.272, 15.664, 119.515 },
    { 2416.952, -924.813, 2.337, 170.399 },
    { -314.809, 727.741, 12.123, 183.879 },
    { 193.150, 554.562, 12.000, 343.879 },
    { 441.625, 1636.690, 12.180, 28.163 },
    { 1828.945, 2494.055, 15.664, 120.232 },
    { 2746.514, -2468.744, 21.688, 277.528 },
    { 1957.931, -2611.712, 11.017, 355.040 },
    { 2179.836, -2232.633, 21.961, 86.290 },
    { -2459.543, 67.786, 20.946, 357.831 },
    { 1898.365, -2424.147, 10.805, 214.761 },
    { -482.465, 893.557, 12.148, 276.001 },
    { 1841.639, 206.801, 7.883, 134.970 },
    { 2313.697, -2402.232, 21.978, 283.277 },
    { 1835.980, 1326.496, 9.827, 88.832 },
    { 2612.118, -2564.780, 24.419, 85.016 },
    { 600.711, -1284.510, 40.736, 332.363 },
    { -2005.079, -964.606, 30.288, 353.740 },
    { -2345.790, 224.886, 22.027, 345.335 },
    { -2796.192, -703.946, 7.693, 2.481 },
    { 2238.923, -2385.360, 21.945, 126.928 },
    { -154.750, 595.104, 12.146, 168.179 },
    { -2587.852, 2789.970, 37.702, 7.940 },
    { -282.982, 1717.047, 12.433, 101.915 },
    { 1918.581, 1714.641, 15.776, 8.765 },
    { -340.188, -891.126, 41.173, 207.754 }
} ;

new taxiClassName [ 3 ] [ 12 ] = { "Эконом", "Комфорт", "Бизнес" } ;

stock clear_player_job_taxi ( playerid )
{
    taxiClassSelect [ playerid ] =
    taxiPassenger [ playerid ] [ 1 ] = 0 ;

    taxiDriverId [ playerid ] =
    taxiPassenger [ playerid ] [ 0 ] = INVALID_PLAYER_ID ;
    return 1 ;
}

stock taxi_OnPlayerDeath ( playerid )
{
    new passId = taxiPassenger [ playerid ] [ 0 ], driverId = taxiDriverId [ playerid ] ;
    if ( passId != INVALID_PLAYER_ID )
    {
        switch ( taxiPassenger [ playerid ] [ 1 ] )
        {
            case 0: deleteTaxiOrder ( passId, p_info [ playerid ] [ taxi_skill ] ) ;
            case 1:
            {
                clear_player_job_taxi ( passId ) ;
			    send_check_cinfo ( passId, "Водитель погиб(ла), поездка остановлена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            }
        }
        clear_player_job_taxi ( playerid ) ;
    }
    else if ( driverId != INVALID_PLAYER_ID )
    {
        clear_player_job_taxi ( driverId ) ;
        clear_player_job_taxi ( playerid ) ;

        send_check_cinfo ( driverId, "Игрок умер(ла), поездка остановлена!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
    }
    return 1 ;
}

stock taxi_OnPlayerDisconnect ( playerid )
{
    new passId = taxiPassenger [ playerid ] [ 0 ], driverId = taxiDriverId [ playerid ] ;
    if ( passId != INVALID_PLAYER_ID )
    {
        switch ( taxiPassenger [ playerid ] [ 1 ] )
        {
            case 0: deleteTaxiOrder ( passId, p_info [ playerid ] [ taxi_skill ] ) ;
            case 1:
            {
                clear_player_job_taxi ( passId ) ;
			    send_check_cinfo ( passId, "Водитель покинул(а) игру!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            }
        }
        clear_player_job_taxi ( playerid ) ;
    }
    else if ( driverId != INVALID_PLAYER_ID )
    {
        taxi_RaceCheckpoint ( driverId, 3 ) ;

        clear_player_job_taxi ( driverId ) ;
        clear_player_job_taxi ( playerid ) ;

        send_check_cinfo ( driverId, "Игрок покинул(а) игру!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
    }
    return 1 ;
}

stock taxi_OnGameModeInit ( )
{
#if defined SERVER_BONUS
    taxiMultiplie = 10 ;
#else
    taxiMultiplie = 1 ;
#endif

    for ( new i = 0 ; i < MAX_TAXI_ORDERS ; i ++ )
    {
        taxi_order_info [ i ] [ ORDER_ID ] = INVALID_PLAYER_ID ;
    }

    for ( new i = 0 ; i < 3 ; i ++ ) preparationOnCreationActor ( i ) ;
    return 1 ;
}

stock getTaxiPrice ( playerid, bool: status )
{
	new taxiPrice, Float: _distance ;
    if ( ! status )
    {
        new passId = taxiPassenger [ playerid ] [ 0 ] ;
        if ( passId != INVALID_PLAYER_ID )
        {
            _distance = GetDistanceBetweenPoints (
                taxiActorStartPosition [ playerid ] [ 0 ], 
                taxiActorStartPosition [ playerid ] [ 1 ], 
                taxiActorStartPosition [ playerid ] [ 2 ], 
                taxiActorEndPosition [ playerid ] [ 0 ], 
                taxiActorEndPosition [ playerid ] [ 1 ], 
                taxiActorEndPosition [ playerid ] [ 2 ]
            ) ;
            taxiPrice = floatround ( _distance * ( taxiActorClassSelect [ playerid ] + 1 ) ) * taxiMultiplie ;
        }
        else
        {
            _distance = GetDistanceBetweenPoints (
                taxiActorPosition [ playerid ] [ 0 ], 
                taxiActorPosition [ playerid ] [ 1 ], 
                taxiActorPosition [ playerid ] [ 2 ], 
                taxiActorExitPosition [ playerid ] [ 0 ], 
                taxiActorExitPosition [ playerid ] [ 1 ], 
                taxiActorExitPosition [ playerid ] [ 2 ]
            ) ;
            taxiPrice = floatround ( _distance * ( taxiActorClass [ playerid ] + 1 ) ) * taxiMultiplie ;
        }
    }
    else
    {
        _distance = GetDistanceBetweenPoints (
            taxiStartPosition [ playerid ] [ 0 ], 
            taxiStartPosition [ playerid ] [ 1 ], 
            taxiStartPosition [ playerid ] [ 2 ], 
            taxiEndPosition [ playerid ] [ 0 ], 
            taxiEndPosition [ playerid ] [ 1 ], 
            taxiEndPosition [ playerid ] [ 2 ]
        ) ;
        taxiPrice = floatround ( _distance * ( taxiClassSelect [ playerid ] + 1 ) ) * taxiMultiplie ;
    }
	return taxiPrice ;
}

stock getTaxiDistance ( playerid, toid, bool: status )
{
	new Float: _distance ;
    if ( ! status )
    {
        _distance = GetDistanceBetweenPoints (
            taxiActorPosition [ toid ] [ 0 ], 
            taxiActorPosition [ toid ] [ 1 ], 
            taxiActorPosition [ toid ] [ 2 ], 
            p_t_info [ playerid ] [ p_pos ] [ 0 ], 
            p_t_info [ playerid ] [ p_pos ] [ 1 ], 
            p_t_info [ playerid ] [ p_pos ] [ 2 ]
        ) ;
    }
    else
    {
        _distance = GetDistanceBetweenPoints (
            taxiStartPosition [ toid ] [ 0 ], 
            taxiStartPosition [ toid ] [ 1 ], 
            taxiStartPosition [ toid ] [ 2 ], 
            p_t_info [ playerid ] [ p_pos ] [ 0 ], 
            p_t_info [ playerid ] [ p_pos ] [ 1 ], 
            p_t_info [ playerid ] [ p_pos ] [ 2 ]
        ) ;
    }
	return floatround ( _distance ) ;
}

stock getTaxiPassengerName ( idx )
{
    new charName [ MAX_PLAYER_NAME ] ;
    if ( taxi_order_info [ idx ] [ IS_PLAYER ] )
    {
        format ( charName, sizeof charName, "%s", p_info [ taxi_order_info [ idx ] [ ORDER_ID ] ] [ name ] ) ;
    }
    else
    {
        new nameId = taxi_order_info [ idx ] [ ACTOR_NAME_ID ] ;
        format ( charName, sizeof charName, "%s", taxiActorNames [ nameId ] ) ;
    }
    return charName ;
}

stock getFreeOrderId ( )
{
    new freeID = INVALID_PLAYER_ID ;
    for ( new i = 0 ; i < MAX_TAXI_ORDERS ; i ++ )
    {
        if ( taxi_order_info [ i ] [ ORDER_ID ] != INVALID_PLAYER_ID ) continue ;

        freeID = i ;
        break ;
    }
    return freeID ;
}

stock getOrderId ( playerid )
{
    new orderId = INVALID_PLAYER_ID ;
    for ( new i = 0 ; i < MAX_TAXI_ORDERS ; i ++ )
    {
        if ( taxi_order_info [ i ] [ ORDER_ID ] != playerid ) continue ;

        orderId = i ;
        break ;
    }
    return orderId ;
}

stock insertTaxiOrder ( orderSlot, playerid, taxiClass, bool: status )
{
    taxi_order_info [ orderSlot ] [ ORDER_ID ] = playerid ;
    taxi_order_info [ orderSlot ] [ CLASS_ID ] = taxiClass ;
    taxi_order_info [ orderSlot ] [ IS_PLAYER ] = status ;
    return 1 ;
}

stock removeTaxiOrder ( orderSlot )
{
    taxiActorToggled [ orderSlot ] = false ;
    taxi_order_info [ orderSlot ] [ ORDER_ID ] = INVALID_PLAYER_ID ;
    return 1 ;
}

callback: deleteTaxiOrder ( actorid, classid )
{
    DestroyActor ( actorid ) ;
    SetTimerEx ( "preparationOnCreationActor", ( 1000 * 60 ) * 5, false, "i", classid ) ;
    return 1 ;
}

callback: preparationOnCreationActor ( taxiClass )
{
    new _count = 0, freeID = INVALID_PLAYER_ID ;
    for ( new i = 0 ; i < MAX_TAXI_ORDERS ; i ++ )
    {
        if ( taxi_order_info [ i ] [ ORDER_ID ] == INVALID_PLAYER_ID ) continue ;
        if ( taxi_order_info [ i ] [ IS_PLAYER ] ) continue ;
        if ( taxi_order_info [ i ] [ CLASS_ID ] != taxiClass ) continue ;

        _count ++ ;
    }

    if ( _count >= MAX_ACTOR_IN_CLASS ) return 1 ;

    do
    {
        freeID = getFreeOrderId ( ) ;
        if ( freeID == INVALID_PLAYER_ID ) _count = MAX_ACTOR_IN_CLASS ;
        else
        {
            new actorPosition = getFreeActorPosition ( ) ;
            taxiActorClass [ actorPosition ] = taxiClass ;
            taxi_order_info [ freeID ] [ ACTOR_NAME_ID ] = random ( sizeof taxiActorNames ) ;
            insertTaxiOrder ( freeID, actorPosition, taxiClass, false ) ;

            static const _str [ ] = "* [Такси] Поступил новый заказ. (Клиент: %s, класс такси: %s)" ;
            new scm_string [ sizeof _str + 64 ] ;
            format ( scm_string, sizeof scm_string, _str, taxiActorNames [ taxi_order_info [ freeID ] [ ACTOR_NAME_ID ] ], taxiClassName [ taxiClass ] ) ;
            setTaxiDriverMessage ( taxiClass, scm_string ) ;

            _count ++ ;
        }
    }
    while ( _count < MAX_ACTOR_IN_CLASS ) ;
    return 1 ;
}

stock createTaxiActor ( idx, actorPosition )
{
    new actorId = CreateActor ( taxiActorSkins [ random ( sizeof taxiActorSkins ) ], taxiActorPosition [ actorPosition ] [ 0 ], taxiActorPosition [ actorPosition ] [ 1 ], taxiActorPosition [ actorPosition ] [ 2 ], taxiActorPosition [ actorPosition ] [ 3 ] ) ;
    SetActorVirtualWorld ( actorId, 0 ) ;

    taxiActorStartPosition [ actorId ] [ 0 ] = taxiActorPosition [ actorPosition ] [ 0 ] ;
    taxiActorStartPosition [ actorId ] [ 1 ] = taxiActorPosition [ actorPosition ] [ 1 ] ;
    taxiActorStartPosition [ actorId ] [ 2 ] = taxiActorPosition [ actorPosition ] [ 2 ] ;

    taxiActorEndPosition [ actorId ] [ 0 ] = taxiActorExitPosition [ actorPosition ] [ 0 ] ;
    taxiActorEndPosition [ actorId ] [ 1 ] = taxiActorExitPosition [ actorPosition ] [ 1 ] ;
    taxiActorEndPosition [ actorId ] [ 2 ] = taxiActorExitPosition [ actorPosition ] [ 2 ] ;

    actor_info [ actorId ] [ ACTOR_TYPE ] = ACTOR_TYPE_TAXI ;
    actor_info [ actorId ] [ ACTOR_NUM_ID ] = actorPosition ;
    taxiActorClassSelect [ actorId ] = taxiActorClass [ actorPosition ] ;
    format ( actor_info [ actorId ] [ ACTOR_NAME ], MAX_PLAYER_NAME, "%s (%d)", taxiActorNames [ taxi_order_info [ idx ] [ ACTOR_NAME_ID ] ], actorPosition ) ;
    return actorId ;
}

stock getFreeActorPosition ( )
{
    new FreeID = -1, _count = 0 ;
    do
    {
        FreeID = random ( MAX_TAXI_ACTORS ) ;
        _count ++ ;
    }
    while ( taxiActorToggled [ FreeID ] == true && _count < 10 ) ;

    if ( taxiActorToggled [ FreeID ] )
    {
        for ( new i = 0 ; i < MAX_TAXI_ACTORS ; i ++ )
        {
            if ( taxiActorToggled [ i ] ) continue ;

            FreeID = i ;
            break ;
        }
    }

    taxiActorToggled [ FreeID ] = true ;
    return FreeID ;
}

stock giveTaxiProgress ( playerid )
{
    if ( ++ p_info [ playerid ] [ taxi_progress ] >= MAX_TAXI_PROGRESS && p_info [ playerid ] [ taxi_skill ] < MAX_TAXI_LEVEL )
    {
        p_info [ playerid ] [ taxi_skill ] += 1 ;
        p_info [ playerid ] [ taxi_progress ] = 0 ;
    }

    static const _str [ ] = "UPDATE users_jobs SET u_taxi_skill = %d, u_taxi_progress = %d WHERE u_sql_id = %d LIMIT 1" ;
    new query_string [ sizeof _str + ( 3 * 9 ) ] ;
    format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ taxi_skill ], p_info [ playerid ] [ taxi_progress ], p_info [ playerid ] [ id ] ) ;
    mysql_tquery ( sql_connection, query_string ) ;
    return 1 ;
}

stock taxi_player_timer ( playerid )
{
    new passId = taxiPassenger [ playerid ] [ 0 ], typePass = taxiPassenger [ playerid ] [ 1 ] ;
    if ( passId != INVALID_PLAYER_ID && ! typePass && actor_info [ passId ] [ ACTOR_VEHICLE_ID ] != INVALID_VEHICLE_ID )
    {
        if ( GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER )
        {
            SetActorPos ( passId, p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ] ) ;
            //actorPutInVeh ( -1, passId, GetPlayerVehicleID ( playerid ), -1 ) ;
        }
    }
    return true ;
}

stock taxi_StateChange ( playerid, newstate, oldstate )
{
    #pragma unused
    if ( oldstate == PLAYER_STATE_DRIVER )
    {
        new passId = taxiPassenger [ playerid ] [ 0 ], typePass = taxiPassenger [ playerid ] [ 1 ] ;
        if ( passId != INVALID_PLAYER_ID && ! typePass && actor_info [ passId ] [ ACTOR_IN_CAR ] )
        {
            send_check_cinfo ( driverId, "Вы покинули т/с, заказ прерван!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;

            actorInvulnerable ( -1, passId, false ) ;
            actorRemoveFromVeh ( -1, passId, player_rentcar [ playerid ], 0 ) ;
            SetTimerEx ( "deleteTaxiOrder", 5000, false, "ii", passId, p_info [ playerid ] [ taxi_skill ] ) ;
            actor_info [ passId ] [ ACTOR_IN_CAR ] = false ;

            taxiPassenger [ playerid ] [ 0 ] = INVALID_PLAYER_ID ;
            taxiPassenger [ playerid ] [ 1 ] = 0 ;
        }
    }
    return true ;
}

stock taxi_OnPlayerEnterVehicle ( playerid, vehicleid )
{
    new driverId = taxiDriverId [ playerid ] ;
    if ( driverId != INVALID_PLAYER_ID && driverId == veh_info [ vehicleid - 1 ] [ v_driver ] )
    {
        send_check_cinfo ( driverId, "Место высадки отмечено на карте", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		is_gps_used { driverId } = 3 ;

		SetPlayerRaceCheckpoint ( driverId, 1, taxiEndPosition [ playerid ] [ 0 ], taxiEndPosition [ playerid ] [ 1 ], taxiEndPosition [ playerid ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
    }
    return true ;
}

stock taxi_RaceCheckpoint ( playerid, checkPointID )
{
    new passId = taxiPassenger [ playerid ] [ 0 ], typePass = taxiPassenger [ playerid ] [ 1 ] ;
    if ( GetPlayerVehicleID ( playerid ) == 0 || veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_type ] != vehicle_type_job )
    {
        send_check_cinfo ( playerid, "Вы не в рабочем транспорте!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
        if ( passId != INVALID_PLAYER_ID && typePass == 0 ) deleteTaxiOrder ( passId, p_info [ playerid ] [ taxi_skill ] ) ;
        return true ;
    }

    if ( checkPointID == 3 )
    {
        if ( passId != INVALID_PLAYER_ID )
        {
            if ( typePass == 1 )
            {
                new _price = getTaxiPrice ( passId, true ) ;
                if ( p_info [ passId ] [ money ] < _price )
                {
                    give_money ( passId, -_price ) ;
                    insert_money_log ( passId, playerid, -_price, "Потратил на такси" ) ;

                    give_money ( playerid, _price ) ;
                    insert_money_log ( playerid, passId, _price, "Получил с такси" ) ;
                    
                    DisablePlayerRaceCheckpoint ( playerid ) ;
                    is_gps_used { playerid } = 0 ;

                    p_info [ playerid ] [ taxi_earned ] += _price ;

                    send_check_cinfo ( playerid, "Вы успешно выполнили заказ", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
                }
                else
                {
                    send_check_cinfo ( playerid, "Вы успешно выполнили заказ.\nУ игрока недостаточно средств для оплаты проезда!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
                }

	            RemovePlayerFromVehicle ( passId ) ;
                
                taxiPassenger [ playerid ] [ 0 ] = INVALID_PLAYER_ID ;
                taxiPassenger [ playerid ] [ 1 ] = 0 ;
            }
            else
            {
                new _price = getTaxiPrice ( passId, false ) ;

                give_money ( playerid, _price ) ;
                insert_money_log ( playerid, INVALID_PLAYER_ID, _price, "Получил с такси, привёз бота" ) ;
                
                DisablePlayerRaceCheckpoint ( playerid ) ;
                is_gps_used { playerid } = 0 ;

                p_info [ playerid ] [ taxi_earned ] += _price ;

                actorInvulnerable ( -1, passId, false ) ;
                actorRemoveFromVeh ( -1, passId, GetPlayerVehicleID ( playerid ), 0 ) ;
                SetTimerEx ( "deleteTaxiOrder", 5000, false, "ii", passId, p_info [ playerid ] [ taxi_skill ] ) ;
                actor_info [ passId ] [ ACTOR_VEHICLE_ID ] = INVALID_VEHICLE_ID ;

                taxiPassenger [ playerid ] [ 0 ] = INVALID_PLAYER_ID ;
                taxiPassenger [ playerid ] [ 1 ] = 0 ;
            }

            giveTaxiProgress ( playerid ) ;
        }
    }
    else if ( checkPointID == 6 )
    {
        if ( passId != INVALID_PLAYER_ID && typePass == 0 )
        {
            send_check_cinfo ( playerid, "Место высадки отмечено на карте", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
		    is_gps_used { playerid } = 3 ;

		    SetPlayerRaceCheckpoint ( playerid, 1, taxiActorEndPosition [ passId ] [ 0 ], taxiActorEndPosition [ passId ] [ 1 ], taxiActorEndPosition [ passId ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
            actorEnterCarPass ( -1, passId, GetPlayerVehicleID ( playerid ), -1 ) ;
            SetTimerEx ( "actorInCar", 2500, false, "ii", passId, GetPlayerVehicleID ( playerid ) ) ;
        }
    }
    return 1 ;
}

callback: actorInCar ( actorid, vehicleid )
{
    actor_info [ actorid ] [ ACTOR_VEHICLE_ID ] = vehicleid ;
    actorInvulnerable ( -1, actorid, true ) ;
    return true ;
}

stock showTaxiWindow ( playerid, classId )
{
    new Node: node = JSON_Array ( ), modelId, itemsLoaded = 0 ;
    if ( classId == -1 )
    {
        for ( new i = 0, Node: vehicleNode ; i < sizeof taxi_vehicles ; i ++ )
        {
            modelId = taxi_vehicles [ i ] [ TAXI_MODELS ] ;
            vehicleNode = JSON_Array (
                JSON_Object (
                    "model",            JSON_Int ( taxi_vehicles [ i ] [ TAXI_MODELS ] ),
                    "color1",           JSON_Int ( 0 ),
                    "color2",           JSON_Int ( 0 ),
                    "name",             JSON_String ( veh_data [ modelId ] [ VEHICLE_NAME ] ),
                    "price",            JSON_Int ( taxi_vehicles [ i ] [ TAXI_RENT_PRICE ] ),
                    "classId",          JSON_Int ( taxi_vehicles [ i ] [ TAXI_CLASS ] )
                )
            ) ;

            node = JSON_Append ( node, vehicleNode ) ;

            if ( ++ itemsLoaded == 5 )
            {
                global_string [ 0 ] = EOS ;
                JSON_Stringify ( node, global_string, sizeof global_string ) ;
                onServerSendData ( playerid, UI_TAXI_JOBS, 0, global_string ) ;

                node = JSON_Array ( ) ;
                itemsLoaded = 0 ;
            }
        }
    }
    else
    {
        for ( new i = 0, Node: vehicleNode ; i < sizeof taxi_vehicles ; i ++ )
        {
            if ( taxi_vehicles [ i ] [ TAXI_CLASS ] != classId ) continue ;

            modelId = taxi_vehicles [ i ] [ TAXI_MODELS ] ;
            vehicleNode = JSON_Array (
                JSON_Object (
                    "model",            JSON_Int ( taxi_vehicles [ i ] [ TAXI_MODELS ] ),
                    "color1",           JSON_Int ( 0 ),
                    "color2",           JSON_Int ( 0 ),
                    "name",             JSON_String ( veh_data [ modelId ] [ VEHICLE_NAME ] ),
                    "price",            JSON_Int ( taxi_vehicles [ i ] [ TAXI_RENT_PRICE ] ),
                    "classId",          JSON_Int ( classId )
                )
            ) ;

            node = JSON_Append ( node, vehicleNode ) ;

            if ( ++ itemsLoaded == 5 )
            {
                global_string [ 0 ] = EOS ;
                JSON_Stringify ( node, global_string, sizeof global_string ) ;
                onServerSendData ( playerid, UI_TAXI_JOBS, 0, global_string ) ;

                node = JSON_Array ( ) ;
                itemsLoaded = 0 ;
            }
        }
    }

    if ( itemsLoaded )
    {
        global_string [ 0 ] = EOS ;
        JSON_Stringify ( node, global_string, sizeof global_string ) ;
        onServerSendData ( playerid, UI_TAXI_JOBS, 0, global_string ) ;
    }

    toggle_controlable ( playerid, false ) ;
    return true ;
}

stock showTaxiReset ( playerid )
{
    onServerSendData ( playerid, UI_TAXI_JOBS, 1, "" ) ;
    return true ;
}

stock showTaxiConfirm ( playerid, idx, modelId )
{
    new Node: node = JSON_Object (
        "model",            JSON_Int ( modelId ),
        "color1",           JSON_Int ( 0 ),
        "color2",           JSON_Int ( 0 ),
        "name",             JSON_String ( veh_data [ modelId ] [ VEHICLE_NAME ] ),
        "price",            JSON_Int ( taxi_vehicles [ idx ] [ TAXI_RENT_PRICE ] ),
        "classId",          JSON_Int ( taxi_vehicles [ idx ] [ TAXI_CLASS ] )
    ) ;

    global_string [ 0 ] = EOS ;
    JSON_Stringify ( node, global_string, sizeof global_string ) ;
    onServerSendData ( playerid, UI_TAXI_JOBS, 2, global_string ) ;
    return true ;
}

stock packetTaxiJobs ( playerid, actionId, data [ ] )
{
    if ( actionId == 0 )
    {
        showTaxiReset ( playerid ) ;
        showTaxiWindow ( playerid, -1 ) ;
    }
    else if ( actionId == 1 )
    {
        showTaxiReset ( playerid ) ;
        showTaxiWindow ( playerid, 0 ) ;
    }
    else if ( actionId == 2 )
    {
        showTaxiReset ( playerid ) ;
        showTaxiWindow ( playerid, 1 ) ;
    }
    else if ( actionId == 3 )
    {
        showTaxiReset ( playerid ) ;
        showTaxiWindow ( playerid, 2 ) ;
    }
    else if ( actionId == 4 )
    {
        new modelId = strval ( data ) ;
        for ( new q = 0 ; q < sizeof taxi_vehicles ; q ++ )
        {
            if ( taxi_vehicles [ q ] [ TAXI_MODELS ] != modelId ) continue ;
            if ( p_info [ playerid ] [ taxi_skill ] < taxi_vehicles [ q ] [ TAXI_CLASS ] )
            {
                send_check_cinfo ( playerid, "Ваш уровень на работе слишком мал!\nПосмотреть Ваш уровень можно в приложении 'Taxi Driver' в планшете.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
                return 1 ;
            }

            set_player_use_listitem ( playerid, q ) ;
            showTaxiConfirm ( playerid, q, modelId ) ;
            return 1 ;
        }
    }
    else if ( actionId == 5 )
    {
        new idx = get_player_use_listitem ( playerid ) ;
        if ( taxi_vehicles [ idx ] [ TAXI_RENT_PRICE ] > p_info [ playerid ] [ money ] )
        {
            send_check_cinfo ( playerid, "У Вас недостаточно средств!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            return 1 ;
        }

        if ( player_rentcar [ playerid ] != INVALID_VEHICLE_ID )
        {
            send_check_cinfo ( playerid, "Вы уже арендуете транспорт! Используйте /stoprent.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
            return 1 ;
        }

        give_money ( playerid, -taxi_vehicles [ idx ] [ TAXI_RENT_PRICE ] ) ;
        insert_money_log ( playerid, INVALID_PLAYER_ID, -taxi_vehicles [ idx ] [ TAXI_RENT_PRICE ], "Аренда такси" ) ;

        createTaxiRentVehicle ( playerid, taxi_vehicles [ idx ] [ TAXI_MODELS ] ) ;
        onServerDestroy ( playerid, UI_TAXI_JOBS ) ;
    }
    return true ;
}

stock createTaxiRentVehicle ( playerid, modelId )
{
    new _veh_id = GetVehicleID ( ), jobId = p_info [ playerid ] [ job ] ;
    veh_info [ _veh_id - 1 ] [ v_plate_type ] = 2 ;
				
	if ( veh_info [ _veh_id - 1 ] [ v_id ] < 10 ) format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "P00%dPP", veh_info [ _veh_id - 1 ] [ v_id ] ) ;
	else if ( veh_info [ _veh_id - 1 ] [ v_id ] > 9 && veh_info [ _veh_id - 1 ] [ v_id ] < 100 ) format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "P0%dPP", veh_info [ _veh_id - 1 ] [ v_id ] ) ;
	else if ( veh_info [ _veh_id - 1 ] [ v_id ] > 99 && veh_info [ _veh_id - 1 ] [ v_id ] < 1000 ) format ( veh_info [ _veh_id - 1 ] [ v_plate ], 12, "P%dPP", veh_info [ _veh_id - 1 ] [ v_id ] ) ;
				
	format ( veh_info [ _veh_id - 1 ] [ v_region ], 12, "77" ) ;

	veh_info [ _veh_id - 1 ] [ v_vehicle ] = AddStaticVehicleEx ( modelId, jobs_structure [ jobId ] [ JOB_VEHICLE_SPAWN ] [ 0 ], jobs_structure [ jobId ] [ JOB_VEHICLE_SPAWN ] [ 1 ], jobs_structure [ jobId ] [ JOB_VEHICLE_SPAWN ] [ 2 ], jobs_structure [ jobId ] [ JOB_VEHICLE_SPAWN ] [ 3 ], 6, 6, SPAWN_TIME_SERVER_VEHICLE ) ;
    veh_info [ _veh_id - 1 ] [ v_type ] = vehicle_type_job ;
    veh_info [ _veh_id - 1 ] [ v_owner ] = jobId ;
    veh_info [ _veh_id - 1 ] [ v_renter ] = playerid ;
    veh_info [ _veh_id - 1 ] [ v_fuel ] = 40.0 ;

	player_vehicle [ playerid ] = _veh_id ;
	player_rentcar [ playerid ] = _veh_id ;
		
	new engine, lights, alarm, doors, bonnet, boot, objective ;
	veh_info [ _veh_id - 1 ] [ v_locked ] = false ;
	GetVehicleParamsEx ( _veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
	SetVehicleParamsEx ( _veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
    
	if ( IsValidDynamic3DTextLabel ( veh_info [ _veh_id - 1 ] [ v_label ] ) )
	{
		DestroyDynamic3DTextLabel ( veh_info [ _veh_id - 1 ] [ v_label ] ) ;
		veh_info [ _veh_id - 1 ] [ v_label ] = CreateDynamic3DTextLabel ( "** Такси **\n{"#cGR3D"}Заказать можно через планшет", col_header_3d, 0.0, 0.0, 1.5, 20.0, INVALID_PLAYER_ID, _veh_id ) ;
		return 1 ;
	}
	if ( ! IsValidDynamic3DTextLabel ( veh_info [ _veh_id - 1 ] [ v_label ] ) )  veh_info [ _veh_id - 1 ] [ v_label ] = CreateDynamic3DTextLabel ( "** Такси **\n{"#cGR3D"}Заказать можно через планшет", col_header_3d, 0.0, 0.0, 1.5, 20.0, INVALID_PLAYER_ID, _veh_id ) ;
	
    SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
	is_gps_used { playerid } = 1 ;

	SetPlayerRaceCheckpoint ( playerid, 1, jobs_structure [ jobId ] [ JOB_VEHICLE_SPAWN ] [ 0 ], jobs_structure [ jobId ] [ JOB_VEHICLE_SPAWN ] [ 1 ], jobs_structure [ jobId ] [ JOB_VEHICLE_SPAWN ] [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
    return true ;
}

stock packetTaxiDestroy ( playerid )
{
    toggle_controlable ( playerid, true ) ;
    return true ;
}

stock setTaxiDriverMessage ( classId, message [ ] )
{
	foreach(new i: logged_players)
	{
		if ( p_info [ i ] [ job ] != job_taxi && job_started [ i ] ) continue ;
        if ( p_info [ i ] [ taxi_skill ] != classId ) continue ;

		SendClientMessage ( i, col_yellow, message ) ;
	}
    return true ;
}

stock getTaxiPlayersOnline ( )
{
	new onlinePlayers = 0 ;
	foreach(new i: logged_players)
	{
		if ( p_info [ i ] [ job ] != job_taxi && job_started [ i ] ) continue ;

		onlinePlayers ++ ;
	}
	return onlinePlayers ;
}