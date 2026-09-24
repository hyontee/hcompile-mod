#define PACKET_CUSTOMRPC    			251

#define MAX_STREAM_SOURCES				1000

#define RPC_STREAM_CREATE				0x30
#define RPC_STREAM_DESTROY				0x31
#define RPC_STREAM_INDIVIDUAL			0x32
#define RPC_STREAM_VOLUME				0x33
#define RPC_STREAM_ATTACH               0x34

enum E_STREAM_SOURCE
{
	eStreamID,
	Float: eStreamPos [ 3 ],
	Float: eStreamDistance,
	eStreamInt,
	eStreamURL [ 256 ],
	eStreamName [ 256 ],
	eStreamRepeat,
	eStreamCurrentTime,
	eStreamType,
	eStreamAttach
} ;

new g_aStreamSources [ MAX_STREAM_SOURCES ] [ E_STREAM_SOURCE ] ;

stock InitStreamSources ( )
{
	for ( new i = 0 ; i < MAX_STREAM_SOURCES ; i ++ )
	{
		g_aStreamSources [ i ] [ eStreamID ] = -1 ;
		
		g_aStreamSources [ i ] [ eStreamType ] =
		g_aStreamSources [ i ] [ eStreamAttach ] = 0 ;
	}
	printf ( "[STREAM SOURCES] Initialized..." ) ;
}

stock CreateAllStreamSourcesForPlayer ( playerid )
{
	for ( new i = 0 ; i < MAX_STREAM_SOURCES ; i ++ )
	{
		if ( g_aStreamSources [ i ] [ eStreamID ] != -1 )
		{
			new BitStream:bitstream = BS_New();
			BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
			BS_WriteValue(bitstream, PR_UINT32, RPC_STREAM_CREATE);
			
			BS_WriteValue(
				bitstream,
				PR_UINT16, g_aStreamSources [ i ] [ eStreamID ],
				
				PR_FLOAT, g_aStreamSources [ i ] [ eStreamPos ] [ 0 ],
				PR_FLOAT, g_aStreamSources [ i ] [ eStreamPos ] [ 1 ],
				PR_FLOAT, g_aStreamSources [ i ] [ eStreamPos ] [ 2 ],
				PR_FLOAT, g_aStreamSources [ i ] [ eStreamDistance ],
				
				PR_UINT16, g_aStreamSources [ i ] [ eStreamInt ],
				
				PR_UINT16, strlen ( g_aStreamSources [ i ] [ eStreamURL ] ),
				PR_STRING, g_aStreamSources [ i ] [ eStreamURL ],
				
				PR_UINT8, g_aStreamSources [ i ] [ eStreamRepeat ],
				PR_UINT32, g_aStreamSources [ i ] [ eStreamCurrentTime ]);

			PR_SendPacket(bitstream, playerid);

			BS_Delete(bitstream);
		}
	}
}

stock CreateStreamSource ( playerid, streamId )
{
	#if defined debug_packet
		printf ( "[CreateStreamSource] playerid: %d", playerid ) ;
	#endif

	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_STREAM_CREATE);
			
	BS_WriteValue(
		bitstream,
		PR_UINT16, g_aStreamSources [ streamId ] [ eStreamID ],
		
		PR_FLOAT, g_aStreamSources [ streamId ] [ eStreamPos ] [ 0 ],
		PR_FLOAT, g_aStreamSources [ streamId ] [ eStreamPos ] [ 1 ],
		PR_FLOAT, g_aStreamSources [ streamId ] [ eStreamPos ] [ 2 ],
		PR_FLOAT, g_aStreamSources [ streamId ] [ eStreamDistance ],
		
		PR_UINT16, g_aStreamSources [ streamId ] [ eStreamInt ],
		
		PR_UINT16, strlen ( g_aStreamSources [ streamId ] [ eStreamURL ] ),
		PR_STRING, g_aStreamSources [ streamId ] [ eStreamURL ],
		
		PR_UINT8, g_aStreamSources [ streamId ] [ eStreamRepeat ],
		PR_UINT32, g_aStreamSources [ streamId ] [ eStreamCurrentTime ]);

	PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock CreateStreamCord ( playerid, _url [ ], Float: fPosX, Float: fPosY, Float: fPosZ, Float: fDistance, needRepeat )
{
	#if defined debug_packet
		printf ( "[CreateStreamCord] playerid: %d", playerid ) ;
	#endif

	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_PLAY_STREAM_CORD);
			
	BS_WriteValue(
		bitstream,
		PR_UINT16, strlen ( _url ),
		PR_STRING, _url,
		
		PR_FLOAT, fPosX,
		PR_FLOAT, fPosY,
		PR_FLOAT, fPosZ,
		PR_FLOAT, fDistance,
		
		PR_UINT8, needRepeat);

	PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock PlayerIndividualStream ( playerid, _url [ ], needRepeat )
{
	#if defined debug_packet
		printf ( "[PlayerIndividualStream] playerid: %d", playerid ) ;
	#endif

	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_STREAM_INDIVIDUAL);
			
	BS_WriteValue(
		bitstream,
		PR_UINT16, strlen ( _url ),
		PR_STRING, _url,
		
		PR_UINT8, needRepeat);

	PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock DestroyStreamSource ( playerid, streamId )
{
	#if defined debug_packet
		printf ( "[DestroyStreamSource] playerid: %d", playerid ) ;
	#endif

	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_STREAM_DESTROY);
			
	BS_WriteValue(
		bitstream,
		PR_UINT16, g_aStreamSources [ streamId ] [ eStreamID ]);

	PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

stock VolumeStreamSource ( playerid )
{
	#if defined debug_packet
		printf ( "[VolumeStreamSource] playerid: %d", playerid ) ;
	#endif

	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_STREAM_VOLUME);

	PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}

enum
{
    NONE = 0,
    TOVEHICLE,
    TOPLAYER
} ;

stock AttachStreamSource ( playerid, streamId )
{
	#if defined debug_packet
		printf ( "[AttachStreamSource] playerid: %d", playerid ) ;
	#endif

	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_STREAM_ATTACH);
			
	BS_WriteValue(
		bitstream,
		PR_UINT16, g_aStreamSources [ streamId ] [ eStreamID ],
		PR_UINT8, g_aStreamSources [ streamId ] [ eStreamType ],
		PR_UINT16, g_aStreamSources [ streamId ] [ eStreamAttach ]);

	PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
}