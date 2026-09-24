#define PACKET_CUSTOMRPC    			251
#define RPC_FRACTION					0x130

stock empShow ( playerid, bool: status )
{
	#if defined debug_packet
		printf ( "[empShow] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FRACTION);
	
	BS_WriteValue(bitstream, PR_INT8, 0);
	BS_WriteValue(bitstream, PR_BOOL, status);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock empHide ( playerid )
{
	#if defined debug_packet
		printf ( "[empHide] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FRACTION);
	
	BS_WriteValue(bitstream, PR_INT8, 1);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock empHeaderText ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[empHeaderText] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FRACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 2,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock empTopTable ( playerid, bool: status )
{
	#if defined debug_packet
		printf ( "[empTopTable] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FRACTION);
	
	BS_WriteValue(bitstream, PR_INT8, 3);
	BS_WriteValue(bitstream, PR_BOOL, status);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock empStatistic ( playerid, bool: status, bool: status2, _max, _progress, _str [ ], _str2 [ ], _str3 [ ] )
{
	#if defined debug_packet
		printf ( "[empStatistic] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FRACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 4,
	
		PR_BOOL, status,
		PR_BOOL, status2,
	
		PR_INT32, _max,
		PR_INT32, _progress,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2,
	
		PR_UINT8, strlen ( _str3 ),
		PR_STRING, _str3 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock empGlobalInfo ( playerid, _str [ ], _str2 [ ] )
{
	#if defined debug_packet
		printf ( "[empGlobalInfo] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FRACTION);
	
	BS_WriteValue(
		bitstream,
		PR_INT8, 5,
	
		PR_UINT8, strlen ( _str ),
		PR_STRING, _str,
	
		PR_UINT8, strlen ( _str2 ),
		PR_STRING, _str2 ) ;

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock empTaskItem ( playerid, _fr_id )
{
	#if defined debug_packet
		printf ( "[empTaskItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FRACTION);
	
	BS_WriteValue(bitstream, PR_INT8, 6);
	
	new line_string [ 12 ] ;
	if ( _fr_id == 1 || _fr_id == 11 )
	{
		BS_WriteValue(bitstream, PR_UINT8, MAX_MAYOR_EMP_INFO);
		for ( new i = 0 ; i < MAX_MAYOR_EMP_INFO ; i ++ )
		{
			if ( p_info [ playerid ] [ emp_status ] [ i ] ) BS_WriteValue(bitstream, PR_INT8, 4 ) ;
			else BS_WriteValue(bitstream, PR_INT8, mayor_emp_info [ i ] [ emp_icon ] ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( mayor_emp_info [ i ] [ emp_name ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, mayor_emp_info [ i ] [ emp_name ] ) ;
			
			BS_WriteValue(bitstream, PR_INT32, mayor_emp_info [ i ] [ emp_max ] ) ;
			BS_WriteValue(bitstream, PR_INT32, p_info [ playerid ] [ emp_progress ] [ i ] ) ;
			
			format ( line_string, sizeof line_string, " / %d", mayor_emp_info [ i ] [ emp_max ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			format ( line_string, sizeof line_string, "%d", p_info [ playerid ] [ emp_progress ] [ i ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( mayor_emp_info [ i ] [ emp_description ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, mayor_emp_info [ i ] [ emp_description ] ) ;
		}
	}
	else if ( _fr_id == 4 || _fr_id == 5 || _fr_id == 6 || _fr_id == 7 )
	{
		BS_WriteValue(bitstream, PR_UINT8, MAX_POLICE_EMP_INFO);
		for ( new i = 0 ; i < MAX_POLICE_EMP_INFO ; i ++ )
		{
			if ( p_info [ playerid ] [ emp_status ] [ i ] ) BS_WriteValue(bitstream, PR_INT8, 4 ) ;
			else BS_WriteValue(bitstream, PR_INT8, police_emp_info [ i ] [ emp_icon ] ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( police_emp_info [ i ] [ emp_name ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, police_emp_info [ i ] [ emp_name ] ) ;
			
			BS_WriteValue(bitstream, PR_INT32, police_emp_info [ i ] [ emp_max ] ) ;
			BS_WriteValue(bitstream, PR_INT32, p_info [ playerid ] [ emp_progress ] [ i ] ) ;
			
			format ( line_string, sizeof line_string, " / %d", police_emp_info [ i ] [ emp_max ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			format ( line_string, sizeof line_string, "%d", p_info [ playerid ] [ emp_progress ] [ i ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( police_emp_info [ i ] [ emp_description ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, police_emp_info [ i ] [ emp_description ] ) ;
		}
	}
	else if ( _fr_id == 8 || _fr_id == 9 )
	{
		BS_WriteValue(bitstream, PR_UINT8, MAX_ARMY_EMP_INFO);
		for ( new i = 0 ; i < MAX_ARMY_EMP_INFO ; i ++ )
		{
			if ( p_info [ playerid ] [ emp_status ] [ i ] ) BS_WriteValue(bitstream, PR_INT8, 4 ) ;
			else BS_WriteValue(bitstream, PR_INT8, army_emp_info [ i ] [ emp_icon ] ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( army_emp_info [ i ] [ emp_name ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, army_emp_info [ i ] [ emp_name ] ) ;
			
			BS_WriteValue(bitstream, PR_INT32, army_emp_info [ i ] [ emp_max ] ) ;
			BS_WriteValue(bitstream, PR_INT32, p_info [ playerid ] [ emp_progress ] [ i ] ) ;
			
			format ( line_string, sizeof line_string, " / %d", army_emp_info [ i ] [ emp_max ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			format ( line_string, sizeof line_string, "%d", p_info [ playerid ] [ emp_progress ] [ i ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( army_emp_info [ i ] [ emp_description ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, army_emp_info [ i ] [ emp_description ] ) ;
		}
	}
	else if ( _fr_id == 15 )
	{
		BS_WriteValue(bitstream, PR_UINT8, MAX_MEDIC_EMP_INFO);
		for ( new i = 0 ; i < MAX_MEDIC_EMP_INFO ; i ++ )
		{
			if ( p_info [ playerid ] [ emp_status ] [ i ] ) BS_WriteValue(bitstream, PR_INT8, 4 ) ;
			else BS_WriteValue(bitstream, PR_INT8, medic_emp_info [ i ] [ emp_icon ] ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( medic_emp_info [ i ] [ emp_name ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, medic_emp_info [ i ] [ emp_name ] ) ;
			
			BS_WriteValue(bitstream, PR_INT32, medic_emp_info [ i ] [ emp_max ] ) ;
			BS_WriteValue(bitstream, PR_INT32, p_info [ playerid ] [ emp_progress ] [ i ] ) ;
			
			format ( line_string, sizeof line_string, " / %d", medic_emp_info [ i ] [ emp_max ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			format ( line_string, sizeof line_string, "%d", p_info [ playerid ] [ emp_progress ] [ i ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( medic_emp_info [ i ] [ emp_description ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, medic_emp_info [ i ] [ emp_description ] ) ;
		}
	}
	else if ( _fr_id == 23 || _fr_id == 24 || _fr_id == 25 )
	{
		BS_WriteValue(bitstream, PR_UINT8, MAX_MAFIA_EMP_INFO);
		for ( new i = 0 ; i < MAX_MAFIA_EMP_INFO ; i ++ )
		{
			if ( p_info [ playerid ] [ emp_status ] [ i ] ) BS_WriteValue(bitstream, PR_INT8, 4 ) ;
			else BS_WriteValue(bitstream, PR_INT8, mafia_emp_info [ i ] [ emp_icon ] ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( mafia_emp_info [ i ] [ emp_name ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, mafia_emp_info [ i ] [ emp_name ] ) ;
			
			BS_WriteValue(bitstream, PR_INT32, mafia_emp_info [ i ] [ emp_max ] ) ;
			BS_WriteValue(bitstream, PR_INT32, p_info [ playerid ] [ emp_progress ] [ i ] ) ;
			
			format ( line_string, sizeof line_string, " / %d", mafia_emp_info [ i ] [ emp_max ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			format ( line_string, sizeof line_string, "%d", p_info [ playerid ] [ emp_progress ] [ i ] ) ;
			BS_WriteValue(bitstream, PR_UINT8, strlen ( line_string ) ) ;
			BS_WriteValue(bitstream, PR_STRING, line_string ) ;
			
			BS_WriteValue(bitstream, PR_UINT8, strlen ( mafia_emp_info [ i ] [ emp_description ] ) ) ;
			BS_WriteValue(bitstream, PR_STRING, mafia_emp_info [ i ] [ emp_description ] ) ;
		}
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock empSubTaskItem ( playerid, _fr_id, _id )
{
	#if defined debug_packet
		printf ( "[empSubTaskItem] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_FRACTION);
	
	BS_WriteValue(bitstream, PR_INT8, 7);
	
	new _item ;
	if ( _fr_id == 1 || _fr_id == 11 )
	{
		new _count = 0 ;
		for ( new i = 0 ; i < 5 ; i ++ )
		{
			if ( mayor_emp_info [ _id ] [ emp_model ] [ i ] == -1 ) continue ;
			
			_count ++ ;
		}
		
		if ( ! _count )
		{
			BS_WriteValue(
				bitstream,
				PR_UINT8, 1,
			
				PR_INT8, -1,
				PR_INT32, -1,
				
				PR_UINT8, 1,
				PR_UINT8, 1,
				
				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78,
				
				PR_UINT8, strlen ( "" ),
				PR_STRING, "" ) ;
		}
		else
		{
			BS_WriteValue(bitstream, PR_UINT8, _count);
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				_item = mayor_emp_info [ _id ] [ emp_model ] [ i ] ;
				if ( _item == -1 ) continue ;
				
				BS_WriteValue(
					bitstream,
					PR_INT8, item_render_type ( _item ),
					PR_INT32, item_object_id ( playerid, _item ),
					
					PR_UINT8, 1,
					PR_UINT8, 1,
					
					PR_FLOAT, 20.0,
					PR_FLOAT, 180.0,
					PR_FLOAT, 45.0,
					PR_FLOAT, 0.78,
					
					PR_UINT8, strlen ( item_name ( _item ) ),
					PR_STRING, item_name ( _item ) ) ;
			}
		}
	}
	else if ( _fr_id == 4 || _fr_id == 5 || _fr_id == 6 || _fr_id == 7 )
	{
		new _count = 0 ;
		for ( new i = 0 ; i < 5 ; i ++ )
		{
			if ( police_emp_info [ _id ] [ emp_model ] [ i ] == -1 ) continue ;
			
			_count ++ ;
		}
		
		if ( ! _count )
		{
			BS_WriteValue(
				bitstream,
				PR_UINT8, 1,
			
				PR_INT8, -1,
				PR_INT32, -1,
				
				PR_UINT8, 1,
				PR_UINT8, 1,
				
				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78,
				
				PR_UINT8, strlen ( "" ),
				PR_STRING, "" ) ;
		}
		else
		{
			BS_WriteValue(bitstream, PR_UINT8, _count);
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				_item = police_emp_info [ _id ] [ emp_model ] [ i ] ;
				if ( _item == -1 ) continue ;
				
				BS_WriteValue(
					bitstream,
					PR_INT8, item_render_type ( _item ),
					PR_INT32, item_object_id ( playerid, _item ),
					
					PR_UINT8, 1,
					PR_UINT8, 1,
					
					PR_FLOAT, 20.0,
					PR_FLOAT, 180.0,
					PR_FLOAT, 45.0,
					PR_FLOAT, 0.78,
					
					PR_UINT8, strlen ( item_name ( _item ) ),
					PR_STRING, item_name ( _item ) ) ;
			}
		}
	}
	else if ( _fr_id == 8 || _fr_id == 9 )
	{
		new _count = 0 ;
		for ( new i = 0 ; i < 5 ; i ++ )
		{
			if ( army_emp_info [ _id ] [ emp_model ] [ i ] == -1 ) continue ;
			
			_count ++ ;
		}
		
		if ( ! _count )
		{
			BS_WriteValue(
				bitstream,
				PR_UINT8, 1,
			
				PR_INT8, -1,
				PR_INT32, -1,
				
				PR_UINT8, 1,
				PR_UINT8, 1,
				
				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78,
				
				PR_UINT8, strlen ( "" ),
				PR_STRING, "" ) ;
		}
		else
		{
			BS_WriteValue(bitstream, PR_UINT8, _count);
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				_item = army_emp_info [ _id ] [ emp_model ] [ i ] ;
				if ( _item == -1 ) continue ;
				
				BS_WriteValue(
					bitstream,
					PR_INT8, item_render_type ( _item ),
					PR_INT32, item_object_id ( playerid, _item ),
					
					PR_UINT8, 1,
					PR_UINT8, 1,
					
					PR_FLOAT, 20.0,
					PR_FLOAT, 180.0,
					PR_FLOAT, 45.0,
					PR_FLOAT, 0.78,
					
					PR_UINT8, strlen ( item_name ( _item ) ),
					PR_STRING, item_name ( _item ) ) ;
			}
		}
	}
	else if ( _fr_id == 15 )
	{
		new _count = 0 ;
		for ( new i = 0 ; i < 5 ; i ++ )
		{
			if ( medic_emp_info [ _id ] [ emp_model ] [ i ] == -1 ) continue ;
			
			_count ++ ;
		}
		
		if ( ! _count )
		{
			BS_WriteValue(
				bitstream,
				PR_UINT8, 1,
			
				PR_INT8, -1,
				PR_INT32, -1,
				
				PR_UINT8, 1,
				PR_UINT8, 1,
				
				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78,
				
				PR_UINT8, strlen ( "" ),
				PR_STRING, "" ) ;
		}
		else
		{
			BS_WriteValue(bitstream, PR_UINT8, _count);
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				_item = medic_emp_info [ _id ] [ emp_model ] [ i ] ;
				if ( _item == -1 ) continue ;
				
				BS_WriteValue(
					bitstream,
					PR_INT8, item_render_type ( _item ),
					PR_INT32, item_object_id ( playerid, _item ),
					
					PR_UINT8, 1,
					PR_UINT8, 1,
					
					PR_FLOAT, 20.0,
					PR_FLOAT, 180.0,
					PR_FLOAT, 45.0,
					PR_FLOAT, 0.78,
					
					PR_UINT8, strlen ( item_name ( _item ) ),
					PR_STRING, item_name ( _item ) ) ;
			}
		}
	}
	else if ( _fr_id == 23 || _fr_id == 24 || _fr_id == 25 )
	{
		new _count = 0 ;
		for ( new i = 0 ; i < 5 ; i ++ )
		{
			if ( mafia_emp_info [ _id ] [ emp_model ] [ i ] == -1 ) continue ;
			
			_count ++ ;
		}
		
		if ( ! _count )
		{
			BS_WriteValue(
				bitstream,
				PR_UINT8, 1,
			
				PR_INT8, -1,
				PR_INT32, -1,
				
				PR_UINT8, 1,
				PR_UINT8, 1,
				
				PR_FLOAT, 20.0,
				PR_FLOAT, 180.0,
				PR_FLOAT, 45.0,
				PR_FLOAT, 0.78,
				
				PR_UINT8, strlen ( "" ),
				PR_STRING, "" ) ;
		}
		else
		{
			BS_WriteValue(bitstream, PR_UINT8, _count);
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				_item = mafia_emp_info [ _id ] [ emp_model ] [ i ] ;
				if ( _item == -1 ) continue ;
				
				BS_WriteValue(
					bitstream,
					PR_INT8, item_render_type ( _item ),
					PR_INT32, item_object_id ( playerid, _item ),
					
					PR_UINT8, 1,
					PR_UINT8, 1,
					
					PR_FLOAT, 20.0,
					PR_FLOAT, 180.0,
					PR_FLOAT, 45.0,
					PR_FLOAT, 0.78,
					
					PR_UINT8, strlen ( item_name ( _item ) ),
					PR_STRING, item_name ( _item ) ) ;
			}
		}
	}

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}