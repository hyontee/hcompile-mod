//#include <custom/speedometr>

stock show_packet_speedometr ( playerid, actionId, data [ ] )
{
	new _position = strval ( data ) ;
	if ( ! GetPlayerVehicleID ( playerid ) ) return 1 ;
	
	if ( actionId == 2 )
	{
		new _v_id = GetPlayerVehicleID ( playerid ) ;
		if ( _position == 1 ) toggle_engine ( playerid, _v_id ) ;
		else if ( _position == 2 ) toggle_lights ( playerid, _v_id ) ;
		else if ( _position == 3 ) toggle_locked ( playerid, _v_id ) ;
	}
	return 1 ;
}