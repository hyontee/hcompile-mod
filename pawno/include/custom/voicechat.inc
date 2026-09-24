native PVC_Start(port, maxOnline, ip[]); // для запуска сервера
native PVC_MutePlayer(playerid);
native PVC_UnMutePlayer(playerid);
native PVC_Disconnect(playerid);
native PVC_PushInfo(playerid, Float:posX, Float:posY, Float:posZ, vw, ispectating);	// вызывать каждые 100-200 мс для обновления позиций
native PVC_StartPushInfo(); // вызвать перед VC_PushInfo
native PVC_EndPushInfo(); // вызвать после пуша
native PVC_ResetPushInfo(); // отмена пуша

#define PACKET_CUSTOMRPC    			251
#define RPC_CUSTOM_VOICE_CONNECT		0x44
#define RPC_CUSTOM_VOICE_DISCONNECT		0x45
#define RPC_CUSTOM_VOICE_VOLUME			0x46
#define RPC_CUSTOM_VOICE_MUTE			0x47
#define RPC_CUSTOM_VOICE_UNMUTE			0x48
#define RPC_CUSTOM_VOICE_VOLUMETOPLAYER 0x49
#define RPC_CUSTOM_VOICE_SETTINGS		0x50

stock ConnectPlayerVoice ( playerid )
{
	#if defined debug_packet
		printf ( "[ConnectPlayerVoice] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_VOICE_CONNECT);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock DisconnectPlayerVoice ( playerid )
{
	#if defined debug_packet
		printf ( "[DisconnectPlayerVoice] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_VOICE_DISCONNECT);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock VolumePlayerVoice ( playerid )
{
	#if defined debug_packet
		printf ( "[VolumePlayerVoice] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_VOICE_VOLUME);

    BS_WriteValue(bitstream, PR_UINT8, p_info [ playerid ] [ voice_volume ]);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock MutePlayerVoice ( playerid, targetid )
{
	#if defined debug_packet
		printf ( "[MutePlayerVoice] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_VOICE_MUTE);

    BS_WriteValue(bitstream, PR_UINT16, targetid);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock UnMutePlayerVoice ( playerid, targetid )
{
	#if defined debug_packet
		printf ( "[UnMutePlayerVoice] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_VOICE_UNMUTE);

    BS_WriteValue(bitstream, PR_UINT16, targetid);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock VolumePlayerToPlayerVoice ( playerid, targetid, volume_value )
{
	#if defined debug_packet
		printf ( "[VolumePlayerToPlayerVoice] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_VOICE_VOLUMETOPLAYER);

    BS_WriteValue(bitstream, PR_UINT16, targetid);
    BS_WriteValue(bitstream, PR_UINT8, volume_value);
	
    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock OpenVoiceSettings ( playerid )
{
	#if defined debug_packet
		printf ( "[OpenVoiceSettings] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_CUSTOM_VOICE_SETTINGS);

    PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}