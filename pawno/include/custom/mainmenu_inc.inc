// Игровое меню (пауза). Клиент: java/CMainMenu.cpp + MainMenuManager.java,
// раскладка res/layout/main_menu_layout.xml.
//
// Как подключить:
//   1. #include <custom/mainmenu_inc> в модуле, откуда будете дёргать меню.
//   2. В custompacket_crmp.inc объявить const RPC_MainMenu = 262 и добавить
//      ветку разбора ответа (клиент шлёт один PR_INT32 -- id нажатой кнопки).
//
// Кнопка с id 0 -- "ПРОДОЛЖИТЬ", её клиент рисует сам и на сервер не шлёт.
// Номера иконок совпадают с MainMenuAdapter.ICONS:
//   0 - продолжить, 1 - карта, 2 - настройки, 3 - админка, 4 - домой.

#if !defined PACKET_CUSTOMRPC
	#define PACKET_CUSTOMRPC			251
#endif

#define RPC_MAIN_MENU_SHOW				0x1A0
#define RPC_MAIN_MENU_HIDE				0x1A1
#define RPC_MAIN_MENU_ITEMS				0x1A2

#define MAIN_MENU_ICON_CONTINUE			0
#define MAIN_MENU_ICON_MAP				1
#define MAIN_MENU_ICON_SETTINGS			2
#define MAIN_MENU_ICON_ADMIN			3
#define MAIN_MENU_ICON_HOME				4

#define RPC_MAIN_MENU_ADMIN				0x1A3

// id кнопок, которые доходят до сервера (остальные клиент обрабатывает сам)
#define MAIN_MENU_ITEM_ADMIN			6

stock SetMainMenuShow ( playerid )
{
	#if defined debug_packet
		printf ( "[SetMainMenuShow] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MAIN_MENU_SHOW);

	PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock SetMainMenuHide ( playerid )
{
	#if defined debug_packet
		printf ( "[SetMainMenuHide] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MAIN_MENU_HIDE);

	PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

// Пример набора кнопок. Клиент перед приёмом чистит список и сам ставит
// "ПРОДОЛЖИТЬ" первой, так что здесь её перечислять не нужно.
stock SetMainMenuItems ( playerid )
{
	#if defined debug_packet
		printf ( "[SetMainMenuItems] playerid: %d", playerid ) ;
	#endif
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MAIN_MENU_ITEMS);

	BS_WriteValue(bitstream, PR_UINT8, 3);

	main_menu_write_item ( bitstream, 1, MAIN_MENU_ICON_MAP,      "КАРТА" ) ;
	main_menu_write_item ( bitstream, 2, MAIN_MENU_ICON_SETTINGS, "НАСТРОЙКИ" ) ;
	main_menu_write_item ( bitstream, 3, MAIN_MENU_ICON_ADMIN,    "АДМИНКА" ) ;

	PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

stock main_menu_write_item ( BitStream:bitstream, _id, _icon, _title [ ] )
{
	BS_WriteValue(bitstream, PR_INT32, _id);
	BS_WriteValue(bitstream, PR_UINT8, _icon);
	BS_WriteValue(bitstream, PR_UINT8, strlen ( _title ) );
	BS_WriteValue(bitstream, PR_STRING, _title);
	return 1 ;
}

// Разрешение на кнопку "АДМИНКА". Клиент сам не может знать, админ ли игрок,
// поэтому кнопки у него нет, пока не придёт этот пакет с единицей.
// Слать после авторизации и при смене уровня админки.
stock SetMainMenuAdmin ( playerid, bool: allowed )
{
	#if defined debug_packet
		printf ( "[SetMainMenuAdmin] playerid: %d allowed: %d", playerid, allowed ) ;
	#endif
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_MAIN_MENU_ADMIN);

	BS_WriteValue(bitstream, PR_UINT8, allowed ? 1 : 0);

	PR_SendPacket(bitstream, playerid);

	BS_Delete(bitstream);
	return 1 ;
}

// Разбор нажатия. Клиент шлёт один PR_INT32 -- id кнопки.
// 0 (продолжить), 1 (карта), 2 (настройки), 3 (статистика), 4 (управление),
// 5 (выход) клиент обрабатывает сам, сюда они не доходят.
stock use_main_menu ( playerid, _id )
{
	switch ( _id )
	{
		case MAIN_MENU_ITEM_ADMIN:
		{
			if ( admin_info [ playerid ] [ admin ] < 1 ) return 1 ;

			// Панель уже была на сервере до нас: m_admin_tools.pwn +
			// custom/admin_tools.inc. Не хватало только клиентской части,
			// её перенесли из CRIME (java/CAdminTools.cpp).
			show_admin_tools ( playerid ) ;
		}
	}
	return 1 ;
}
