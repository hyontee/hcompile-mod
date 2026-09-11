
#if defined _nexus_remote_switch_included
	#endinput
#endif
#define _nexus_remote_switch_included

#define NEXUS_SWITCH_URL		"gist.githubusercontent.com/Romatiochik/b952d047c33d2e84630b07cd0eef5b26/raw/status.txt"
#define NEXUS_SWITCH_INTERVAL	(300000) // как часто перепроверять, мс (5 минут)

new bool:g_NexusModEnabled = true;
new bool:g_NexusFirstCheckDone = false;

forward Nexus_CheckSwitch();
forward Nexus_OnSwitchResponse(index, response_code, data[]);

// Вызвать один раз из OnGameModeInit()
stock Nexus_InitSwitch()
{
	Nexus_CheckSwitch();
	SetTimer("Nexus_CheckSwitch", NEXUS_SWITCH_INTERVAL, true);
	return 1;
}

public Nexus_CheckSwitch()
{
	HTTP(0, HTTP_GET, NEXUS_SWITCH_URL, "", "Nexus_OnSwitchResponse");
	return 1;
}

public Nexus_OnSwitchResponse(index, response_code, data[])
{
	if(response_code != 200)
	{
		printf("[nexus] проверка недоступна (HTTP %d), состояние не изменено", response_code);
		return 1;
	}

	new bool:should_be_enabled = (data[0] == '1');

	if(!g_NexusFirstCheckDone)
	{
		g_NexusFirstCheckDone = true;
		g_NexusModEnabled = should_be_enabled;
		print(should_be_enabled ? ("мод включен by nexus") : ("[ОШИБКА] мод отключен by nexus"));
		if(!should_be_enabled) Nexus_ShutdownServer();
		return 1;
	}

	if(should_be_enabled && !g_NexusModEnabled)
	{
		g_NexusModEnabled = true;
		print("мод включен by nexus");
	}
	else if(!should_be_enabled && g_NexusModEnabled)
	{
		g_NexusModEnabled = false;
		print("[ОШИБКА] мод отключен by nexus");
		Nexus_ShutdownServer();
	}
	return 1;
}

// Кикает всех, кто уже на сервере, когда мод отключается на лету
stock Nexus_ShutdownServer()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			SendClientMessage(i, 0xFF0000FF, "Сервер временно недоступен. Обратитесь к администрации.");
			SetTimerEx("FixedKick", 1000, false, "i", i);
		}
	}
	return 1;
}

stock bool:Nexus_IsModEnabled()
{
	return g_NexusModEnabled;
}
