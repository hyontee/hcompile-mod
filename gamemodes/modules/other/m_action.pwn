#include <custom/action>

stock show_packet_action ( playerid, _param1, _param2, _param3, _param4 )
{
	if ( _param4 == 0 )
	{
		if ( _param1 == 1 )
		{
			if ( _param2 == 1 )
			{
				if ( _param3 >= 100 )
				{
					actionHide ( playerid ) ;
					checking_action_type ( playerid, action_type { playerid } ) ;
				}
			}
		}
	}
	else if ( _param4 == 1 )
	{
		if ( _param1 == 1 )
		{
			if ( _param2 == 1 )
			{
				if ( _param3 >= 100 )
				{
					actionClickHide ( playerid ) ;
					checking_action_type ( playerid, action_type { playerid } ) ;
				}
			}
		}
	}
	return 1 ;
}