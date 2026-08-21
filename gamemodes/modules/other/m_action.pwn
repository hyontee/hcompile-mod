stock actionShow ( playerid, description [ ], duration )
{
	new Node: node = JSON_Object (
		"duration",		JSON_Int ( duration ),
		"description",	JSON_String ( description )
	) ;
	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_ACTION, 0, global_string ) ;
	return true ;
}

stock actionClickShow ( playerid, percent )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, sizeof global_string, "%d", percent ) ;
	onServerSendData ( playerid, UI_ACTION_CLICK, 0, global_string ) ;
	return true ;
}

stock packetActionClickDestroy ( playerid )
{
	checking_action_type ( playerid, action_type { playerid } ) ;
	return true ;
}

stock packetActionDestroy ( playerid )
{
	checking_action_type ( playerid, action_type { playerid } ) ;
	return true ;
}