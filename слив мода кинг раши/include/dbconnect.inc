SetServerConfiguration(bind[], port)
{
	//51.91.91.100
	if(!strcmp(bind, "195.18.27.241") && port == 1187) // - Main
	{
		format(SERVER_INFO, sizeof(SERVER_INFO), "PRIME");

		BONUS_CASH = 30000000;
		BONUS_LVL = 8;

		SetGameModeText("SUNNY RUSSIA");
		
		db_prod = mysql_connect("127.0.0.1", "gs346798", "gs346798", "999999");
		db_vost = mysql_connect("127.0.0.1", "gs346798", "gs346798", "999999");
	}
	else if(!strcmp(bind, "46.174.50.52") && port == 7816) // - Test
	{
		format(SERVER_INFO, sizeof(SERVER_INFO), "Test");

		BONUS_CASH = 99999999;
		BONUS_LVL = 99;

		SetGameModeText("PRP TEST");
		
		db_prod = mysql_connect("127.0.0.1", "gs346798", "gs346798", "999999");
		db_vost = mysql_connect("127.0.0.1", "gs346798", "gs346798", "999999");
	}
	else
	{
		printf("[debug] Сервер отключен, подключение не найдено.");
		GameModeExit();
		return 1;
	}
	
	SetTimer("OnVoiceToggle", 200, 1);
	
	return 1;
}