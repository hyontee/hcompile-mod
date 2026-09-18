SetServerConfiguration(bind[], port)
{
	//51.91.91.100
	if(!strcmp(bind, "185.207.214.14") && port == 2893) // - Main
	{
		format(SERVER_INFO, sizeof(SERVER_INFO), "TAMIK);

		BONUS_CASH = 100000000;
		BONUS_LVL = 8;

		SetGameModeText("SUNNY RUSSIA");
		
		db_prod = mysql_connect("127.0.0.1", "gs336817", "gs336817", "gs336817");
		db_vost = mysql_connect("127.0.0.1", "gs336817", "gs336817", "gs336817");
	}
	else if(!strcmp(bind, "46.174.50.52") && port == 7816) // - Test
	{
		format(SERVER_INFO, sizeof(SERVER_INFO), "Test");

		BONUS_CASH = 99999999;
		BONUS_LVL = 99;

		SetGameModeText("TEST SUNNY");
		
		db_prod = mysql_connect("217.182.34.233", "gs19962", "gs19962", "3c7gQvB9znP1QRtanELNikfPE0g2CJdG");
		db_vost = mysql_connect("176.31.24.37", "gs20034", "gs20034", "dPUI3ZRaT9rmuxMYmkqu63a9culXGhdp");
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