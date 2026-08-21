//#include <custom/customhud>

stock show_packet_hud ( playerid, actionId, data [ ] )
{
	if ( actionId == 1 )
	{
		new _position = strval ( data ) ;
		if ( _position == 1 )
		{
			show_tablet_init ( playerid ) ;
		}
		else if ( _position == 2 )
		{
			show_mainmenu ( playerid ) ;
		}
		else if ( _position == 3 )
		{
			show_mobile_donate ( playerid ) ;
		}
		else if ( _position == 4 )
		{
			show_inventory_ptd ( playerid, true ) ;
		}
		else if ( _position == 6 )
		{
			show_open_quest ( playerid ) ;
		}
	}
	return 1 ;
}