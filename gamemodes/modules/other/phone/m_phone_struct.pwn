enum E_PHONE_CALL_STRUCT
{
	PC_INCOMING_PLAYER,		// исходящий вызов
	PC_OUTCOMING_PLAYER,	// входящий вызов
	bool: PC_ENABLED,		// режим телефона (вкл\откл)
	bool: PC_STATUS,
    PC_VOICE_CHAT
} ;

new g_phone_call [ MAX_PLAYERS ] [ E_PHONE_CALL_STRUCT ] ;

new 
	g_phone_call_default_values [ E_PHONE_CALL_STRUCT ] = 
{
	INVALID_PLAYER_ID,
	INVALID_PLAYER_ID,
	true,
	false,
    -1
} ;

// ------------------------------------------

#define MAX_PHONE_CALL_STREAM 100
new SV_GSTREAM: g_phone_call_stream [ MAX_PHONE_CALL_STREAM ] = { SV_NULL, ... } ;

new Iterator: IPhoneCallVoice<MAX_PHONE_CALL_STREAM>;

//========================================================================================================================================
#include									"modules/other/phone/m_phone.pwn"
//========================================================================================================================================