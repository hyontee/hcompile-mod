#include <custom/ui_interface>

forward show_packet_tune ( playerid, _param1, _param2, _param3 ) ;

stock notify_server ( playerid, uiElementId, actionId, data [ ] )
{
	if ( uiElementId == 1 )
	{
		show_donate_packet ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == 2 )
	{
		show_packet_speedometr ( playerid, actionId, data ) ;
	}
	else if ( uiElementId == 3 )
	{
		new Node: json = JSON_Object ( ), _param2, _param3 ;
		JSON_Parse ( data, json ) ;
		JSON_GetInt ( json, "b", _param2 ) ;
		JSON_GetInt ( json, "c", _param3 ) ;

		show_packet_tune ( playerid, actionId, _param2, _param3 ) ;
	}
	else if ( uiElementId == 4 )
	{
		new Node: json = JSON_Object ( ), _param2, _param3 ;
		JSON_Parse ( data, json ) ;
		JSON_GetInt ( json, "b", _param2 ) ;
		JSON_GetInt ( json, "c", _param3 ) ;

		show_packet_business ( playerid, actionId, _param2, _param3 ) ;
	}
	else if ( uiElementId == 7 )
	{
		show_packet_keyboard ( playerid, actionId, data ) ;
	}
	return 1 ;
}