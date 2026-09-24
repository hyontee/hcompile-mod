#define RPC_TABLET						0x147

#define TABLET_APP_CHARACTER			1
#define TABLET_APP_SETTINGS				2
#define TABLET_APP_SUPPORT				3
#define TABLET_APP_INVENTORY			4
#define TABLET_APP_COMMANDS				5
#define TABLET_APP_NICKNAME				6
#define TABLET_APP_PROMOCODE			7
#define TABLET_APP_LOTTERY				8
#define TABLET_APP_DONATE				9
#define TABLET_APP_HELP					10
#define TABLET_APP_GPS					11
#define TABLET_APP_HOUSE				12
#define TABLET_APP_GARAGE				13
#define TABLET_APP_BUSINESS				14
#define TABLET_APP_FAMILY				15
#define TABLET_APP_FRACTION				16
#define TABLET_APP_PHONE				17
#define TABLET_APP_QUESTS				18
#define TABLET_APP_BINDER				19
#define TABLET_APP_JOBS					20

stock tablet_write_app ( BitStream: bitstream, _id, _icon [ ], _title [ ], _color )
{
	BS_WriteValue ( bitstream, PR_INT32, _id ) ;
	BS_WriteValue ( bitstream, PR_UINT8, strlen ( _icon ) ) ;
	BS_WriteValue ( bitstream, PR_STRING, _icon ) ;
	BS_WriteValue ( bitstream, PR_UINT8, strlen ( _title ) ) ;
	BS_WriteValue ( bitstream, PR_STRING, _title ) ;
	BS_WriteValue ( bitstream, PR_INT32, _color ) ;
	return 1 ;
}

stock tablet_show ( playerid )
{
	new bool: _leader = p_info [ playerid ] [ leader ] > 0 ;

	new BitStream: bitstream = BS_New ( ) ;
	BS_WriteValue ( bitstream, PR_UINT8, PACKET_CUSTOMRPC ) ;
	BS_WriteValue ( bitstream, PR_UINT32, RPC_TABLET ) ;
	BS_WriteValue ( bitstream, PR_INT8, 0 ) ;
	BS_WriteValue ( bitstream, PR_UINT8, _leader ? 20 : 19 ) ;

	tablet_write_app ( bitstream, TABLET_APP_PHONE,      "ic_tablet_phone",     "Телефон",       0x7CC21B ) ;
	tablet_write_app ( bitstream, TABLET_APP_SUPPORT,    "ic_tablet_support",   "Поддержка",     0xF5B91E ) ;
	tablet_write_app ( bitstream, TABLET_APP_INVENTORY,  "ic_tablet_inventory", "Инвентарь",     0x1FB6A0 ) ;
	tablet_write_app ( bitstream, TABLET_APP_DONATE,     "ic_tablet_donate",    "Донат",         0x2EC4DB ) ;
	tablet_write_app ( bitstream, TABLET_APP_LOTTERY,    "ic_tablet_lottery",   "Лотерея",       0xF2742A ) ;
	tablet_write_app ( bitstream, TABLET_APP_QUESTS,     "ic_tablet_quests",    "Задания",       0x2F6FE0 ) ;
	tablet_write_app ( bitstream, TABLET_APP_CHARACTER,  "ic_tablet_character", "Меню персонажа", 0xC4163F ) ;
	tablet_write_app ( bitstream, TABLET_APP_BUSINESS,   "ic_tablet_business",  "Бизнес",        0xE0368C ) ;
	tablet_write_app ( bitstream, TABLET_APP_HOUSE,      "ic_tablet_house",     "Дом",           0x9BCB1F ) ;
	tablet_write_app ( bitstream, TABLET_APP_FAMILY,     "ic_tablet_family",    "Семья",         0x8E2FB8 ) ;
	if ( _leader ) tablet_write_app ( bitstream, TABLET_APP_FRACTION, "ic_tablet_fraction", "Фракция", 0x2A2D34 ) ;
	tablet_write_app ( bitstream, TABLET_APP_GARAGE,     "ic_tablet_garage",    "Мой транспорт", 0x3BA3F0 ) ;
	tablet_write_app ( bitstream, TABLET_APP_BINDER,     "ic_tablet_binder",    "Биндер",        0x5B5FD6 ) ;
	tablet_write_app ( bitstream, TABLET_APP_JOBS,       "ic_tablet_jobs",      "Собеседование", 0xB8562F ) ;
	tablet_write_app ( bitstream, TABLET_APP_GPS,        "ic_tablet_navigator", "Навигатор",     0x2E8B3E ) ;
	tablet_write_app ( bitstream, TABLET_APP_PROMOCODE,  "ic_tablet_promocode", "Промокод",      0xD8328F ) ;
	tablet_write_app ( bitstream, TABLET_APP_NICKNAME,   "ic_tablet_nickname",  "Смена ника",    0x17A6C4 ) ;
	tablet_write_app ( bitstream, TABLET_APP_COMMANDS,   "ic_tablet_commands",  "Команды",       0x4A5568 ) ;
	tablet_write_app ( bitstream, TABLET_APP_SETTINGS,   "ic_tablet_settings",  "Настройки",     0x6B7280 ) ;
	tablet_write_app ( bitstream, TABLET_APP_HELP,       "ic_tablet_help",      "Помощь",        0x0EA5A0 ) ;

	PR_SendPacket ( bitstream, playerid ) ;
	BS_Delete ( bitstream ) ;
	return 1 ;
}

stock tablet_hide ( playerid )
{
	new BitStream: bitstream = BS_New ( ) ;
	BS_WriteValue ( bitstream, PR_UINT8, PACKET_CUSTOMRPC ) ;
	BS_WriteValue ( bitstream, PR_UINT32, RPC_TABLET ) ;
	BS_WriteValue ( bitstream, PR_INT8, 1 ) ;
	PR_SendPacket ( bitstream, playerid ) ;
	BS_Delete ( bitstream ) ;
	return 1 ;
}

stock show_packet_tablet ( playerid, _app )
{
	if ( p_t_info [ playerid ] [ p_logged ] == false ) return 1 ;

	switch ( _app )
	{
		case 0: tablet_show ( playerid ) ;

		case TABLET_APP_CHARACTER .. TABLET_APP_HELP:
		{
			p_t_info [ playerid ] [ p_dialog ] = d_mm ;
			p_t_info [ playerid ] [ dialog_timer ] = 0 ;
			OnDialogResponse ( playerid, d_mm, 1, _app - TABLET_APP_CHARACTER, "\1" ) ;
		}

		case TABLET_APP_GPS: callcmd::gps ( playerid ) ;
		case TABLET_APP_HOUSE: callcmd::hmenu ( playerid ) ;
		case TABLET_APP_GARAGE: callcmd::garage ( playerid ) ;
		case TABLET_APP_BUSINESS: callcmd::bpanel ( playerid ) ;
		case TABLET_APP_FAMILY: callcmd::fmenu ( playerid ) ;
		case TABLET_APP_FRACTION: callcmd::lmenu ( playerid ) ;
		case TABLET_APP_PHONE: callcmd::phone ( playerid ) ;
		case TABLET_APP_QUESTS: callcmd::quest ( playerid ) ;
		case TABLET_APP_BINDER: show_packet_keyboard ( playerid, 1, "{\"position\":1}" ) ;
		case TABLET_APP_JOBS: show_jobmenu ( playerid ) ;
	}
	return 1 ;
}
