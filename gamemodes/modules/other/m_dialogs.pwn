#include <custom/dialogs>

new player_dialogs_type [ MAX_PLAYERS ] ;

stock show_packet_dialogs ( playerid, _param1, _param2 )
{
	new _type = player_dialogs_type [ playerid ] ;
	if ( _type == 0 ) hideSelectorDialog ( playerid ) ;
	else if ( _type == 1 ) set_packet_inventory ( playerid, _param1 ) ;
	else if ( _type == 2 ) set_packet_accessories ( playerid, _param1 ) ;
	else if ( _type == 3 ) set_packet_trade_valute ( playerid, _param1 ) ;
	else if ( _type == 4 ) set_packet_trade_value ( playerid, _param1, _param2 ) ;
	else if ( _type == 13 ) set_packet_vehicle_put ( playerid, _param1, _param2 ) ;
	else if ( _type == 14 ) set_packet_vehicle_get ( playerid, _param1, _param2 ) ;
	else if ( _type == 17 ) set_packet_warehouse_put ( playerid, _param1, _param2 ) ;
	else if ( _type == 18 ) set_packet_warehouse_get ( playerid, _param1, _param2 ) ;
	else if ( _type == 20 ) set_packet_family_put ( playerid, _param1, _param2 ) ;
	else if ( _type == 21 ) set_packet_family_get ( playerid, _param1, _param2 ) ;
	else if ( _type == 30 ) set_packet_fraction_put ( playerid, _param1, _param2 ) ;
	else if ( _type == 31 ) set_packet_fraction_get ( playerid, _param1, _param2 ) ;
	player_dialogs_type [ playerid ] = 0 ;
	return 1 ;
}

stock SetPlayerDialogsType ( playerid, _type )
{
	player_dialogs_type [ playerid ] = _type ;
	return 1 ;
}

stock inv_dialog_fields ( dialogid, fields [ ], size = sizeof fields )
{
	switch ( dialogid )
	{
		case d_prise_sell: format ( fields, size, "#ID игрока|#Цена|#Количество" ) ;
		case d_accessories_sell: format ( fields, size, "#ID игрока|#Цена" ) ;
		case d_drop_item: format ( fields, size, "#Количество" ) ;
		case d_donate_rename: format ( fields, size, "Новый ник" ) ;
		case d_donate_number: format ( fields, size, "#Тип номера|Номер|#Регион" ) ;
		default: format ( fields, size, "#" ) ;
	}
	return 1 ;
}

stock inv_dialog ( playerid, dialogid, style, caption [ ], info [ ], button1 [ ], button2 [ ] )
{
	if ( player_device { playerid } != 2 ) return show_dialog ( playerid, dialogid, style, caption, info, button1, button2 ) ;

	new _fields [ 64 ] ;
	inv_dialog_fields ( dialogid, _fields ) ;

	p_t_info [ playerid ] [ p_dialog ] = dialogid ;

	new BitStream: bitstream = BS_New ( ) ;
	BS_WriteValue ( bitstream, PR_UINT8, PACKET_CUSTOMRPC ) ;
	BS_WriteValue ( bitstream, PR_UINT32, RPC_DIALOGS ) ;
	BS_WriteValue (
		bitstream,
		PR_INT8, 4,
		PR_INT32, dialogid,
		PR_INT8, style,
		PR_UINT32, strlen ( caption ),
		PR_STRING, caption,
		PR_UINT32, strlen ( info ),
		PR_STRING, info,
		PR_UINT32, strlen ( button1 ),
		PR_STRING, button1,
		PR_UINT32, strlen ( button2 ),
		PR_STRING, button2,
		PR_UINT32, strlen ( _fields ),
		PR_STRING, _fields,
		PR_UINT32, 0,
		PR_STRING, ""
	) ;
	PR_SendPacket ( bitstream, playerid ) ;
	BS_Delete ( bitstream ) ;
	return 1 ;
}

stock inv_dialog_response ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	if ( p_t_info [ playerid ] [ p_dialog ] != dialogid ) return 1 ;
	if ( inputtext [ 0 ] == EOS ) return OnDialogResponse ( playerid, dialogid, response, listitem, "\1" ) ;
	return OnDialogResponse ( playerid, dialogid, response, listitem, inputtext ) ;
}
