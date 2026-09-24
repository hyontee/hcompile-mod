#define PACKET_CUSTOMRPC    			251

#define RPC_SHOW_NOTIFICATION			0x61

stock SendCheckCInfo ( playerid, _byte_text [ ], _byte_type, _byte_progress, _byte_id, _byte_send, _byte_picture, _btn_text_1 [ ], _btn_text_2 [ ] )
{
	#if defined debug_packet
		printf ( "[SendCheckCInfo] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_NOTIFICATION);
    
	BS_WriteValue(
		bitstream,
		PR_INT8, 0,
	
		PR_UINT16, strlen ( _byte_text ),
		PR_STRING, _byte_text,

		PR_UINT8, _byte_type, // кликабельная - 1, не кликабельная - 2
		PR_INT32, _byte_progress, // Время в мс. -1 - без времени
		PR_UINT16, _byte_id, // select ID
		PR_UINT16, _byte_send, // Ответ от клиента, который вернётся при нажатии. При закрытии возвращает 255
		PR_UINT8, _byte_picture, // Картинка и её цвет
    
		PR_UINT8, strlen ( _btn_text_1 ),
		PR_STRING, _btn_text_1,
    
		PR_UINT8, strlen ( _btn_text_2 ),
		PR_STRING, _btn_text_2);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SendHideNotification ( playerid, _notyId )
{
	#if defined debug_packet
		printf ( "[SendHideNotification] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_NOTIFICATION);
    
	BS_WriteValue(bitstream, PR_INT8, 1);
	BS_WriteValue(bitstream, PR_UINT8, _notyId);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SendNotyDialog ( playerid, _body [ ], _promo [ ], _btnUse [ ], _btnCancel [ ], _caption [ ] )
{
	#if defined debug_packet
		printf ( "[SendNotyDialog] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_NOTIFICATION);
    
	BS_WriteValue(bitstream, PR_INT8, 2);
    BS_WriteValue(bitstream, PR_INT8, 1);
    
	BS_WriteValue(bitstream, PR_UINT16, strlen ( _body ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _body);
    
	BS_WriteValue(bitstream, PR_UINT16, strlen ( _promo ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _promo);

	BS_WriteValue(bitstream, PR_UINT16, strlen ( _btnUse ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _btnUse);
    
	BS_WriteValue(bitstream, PR_UINT16, strlen ( _btnCancel ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _btnCancel);
    
	BS_WriteValue(bitstream, PR_UINT16, strlen ( _caption ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _caption);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SendNotyModel ( playerid, _model )
{
	#if defined debug_packet
		printf ( "[SendNotyModel] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_NOTIFICATION);
    
	BS_WriteValue(bitstream, PR_INT8, 2);
    BS_WriteValue(bitstream, PR_INT8, 2);
    
	BS_WriteValue(bitstream, PR_INT8, 1 ) ;
	BS_WriteValue(bitstream, PR_UINT32, _model ) ;
		
	BS_WriteValue(bitstream, PR_UINT8, 1 ) ;
	BS_WriteValue(bitstream, PR_UINT8, 1 ) ;
			
	BS_WriteValue(bitstream, PR_FLOAT, 20.0 ) ;
	BS_WriteValue(bitstream, PR_FLOAT, 180.0 ) ;
	BS_WriteValue(bitstream, PR_FLOAT, 45.0 ) ;
	BS_WriteValue(bitstream, PR_FLOAT, 0.78 ) ;
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock SendNotyImage ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[SendNotyImage] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_NOTIFICATION);
    
	BS_WriteValue(bitstream, PR_INT8, 2);
    BS_WriteValue(bitstream, PR_INT8, 3);
    
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock showNotyBig ( playerid, _str [ ] )
{
	#if defined debug_packet
		printf ( "[showNotyBig] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_NOTIFICATION);
    
	BS_WriteValue(bitstream, PR_INT8, 3);
    
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _str ) ) ;
	BS_WriteValue(bitstream, PR_STRING, _str);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock hideNotyBig ( playerid )
{
	#if defined debug_packet
		printf ( "[hideNotyBig] playerid: %d", playerid ) ;
	#endif
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_NOTIFICATION);
    
	BS_WriteValue(bitstream, PR_INT8, 4);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}