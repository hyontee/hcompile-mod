#define MAX_CASKET_INFO 	100
#define MAX_CASKET_MODEL	100
#define CASKET_CROSS		5000

enum STRUCT_CASKET_INFO
{
	CASKET_ID,
	CASKET_NAME [ 32 ],
	CASKET_DESCRIPTION [ 1024 ],
	CASKET_MODEL [ MAX_CASKET_MODEL ],
	CASKET_RARE [ MAX_CASKET_MODEL ]
} ;
new CASKET_INFO [ MAX_CASKET_INFO ] [ STRUCT_CASKET_INFO ] ;
new casket_count = 0 ;

#define GetCasketInfo(%0,%1)		CASKET_INFO[%0][%1]
#define GetCasketModel(%0,%1,%2)	CASKET_INFO[%0][%1][%2]

static const clearCasketInfo [ MAX_CASKET_MODEL ] = { -1, ... } ;

stock casket_OnGameModeInit ( )
{
	mysql_tquery ( sql_connection, !"SELECT * FROM casket_info", "casket_loading" ) ;
	return true ;
}

callback: casket_loading ( )
{
	new fields, time = GetTickCount ( ) ;
	cache_get_data ( casket_count, fields ) ;
	if ( ! casket_count )
	{
		printf ( "[SERVER] Ларцы не были найдены в базе данных." ) ;
		return false ;
	}

	for ( new i = casket_count - 1 ; i < MAX_CASKET_INFO ; i ++ )
	{
		GetCasketInfo ( i, CASKET_RARE ) =
		GetCasketInfo ( i, CASKET_MODEL ) = clearCasketInfo ;
	}

	for ( new i = 0 ; i < casket_count ; i ++ )
	{
		GetCasketInfo ( i, CASKET_ID ) = cache_get_field_content_int ( i, "id", sql_connection ) ;
		cache_get_field_content ( i, "casket_info", CASKET_INFO [ i ] [ CASKET_DESCRIPTION ], sql_connection ) ;

		global_string [ 0 ] = EOS ;
		cache_get_field_content ( i, "casket_item", global_string, sql_connection ) ;
		JsonConvertCasket ( global_string, i ) ;
	}
	
	printf ( "[SERVER] Загружено %d ларцов. (%d ms)", casket_count, GetTickCount ( ) - time ) ;
	return true ;
}

stock JsonConvertCasket ( data [ ], casketId )
{
	new Node: json, Node: nodeIterate, Node: nodeWrite ;
	JSON_Parse ( data, json ) ;

    JSON_GetArray ( json, "casket_item", nodeIterate ) ;

	new idx = 0 ;
    while ( ! JSON_ArrayObject ( nodeIterate, idx, nodeWrite ) )
	{
		JSON_GetInt ( nodeWrite, "casket_model", GetCasketModel ( casketId, CASKET_MODEL, idx ) ) ;
		JSON_GetInt ( nodeWrite, "casket_rare", GetCasketModel ( casketId, CASKET_RARE, idx ) ) ;
		idx ++ ;
	}
	return true ;
}

stock GetCasketId ( itemIdx )
{
	new idx = itemIdx - CASKET_CROSS ;
	return idx ;
}

stock GetCasketRandomRarity ( casketId )
{
	new freeCount = 0,
		freeId [ 40 ] = { -1, ... },
		idx,
		itemRarity = GetRandomWeightedNumber ( rarityChanceDefault ) ;

	for ( new i = 0 ; i < MAX_CASKET_MODEL ; i ++ )
	{
		if ( GetCasketModel ( casketId, CASKET_RARE, i ) != itemRarity ) continue ;

		freeId [ freeCount ] = i ;
		freeCount ++ ;
	}

	if ( freeCount < 2 ) idx = 0 ;
	else idx = freeId [ random ( freeCount ) ] ;

	return idx ;
}