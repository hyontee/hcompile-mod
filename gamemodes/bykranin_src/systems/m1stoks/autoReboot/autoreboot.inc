//>> Файл: bykranin_src/systems/m1stoks/autoReboot/autoreboot.inc  (121 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: AutoReboot_ResetWarnings, AutoReboot_SecondsUntilReboot, AutoReboot_SendWarning, AutoReboot_Notify, AutoReboot_ExecuteRestart, AutoReboot_Init, AutoReboot_OnSecondTimer
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: modules/m1stoks/autoReboot/autoreboot.inc
#if defined _autoreboot_included
	#endinput
#endif
#define _autoreboot_included

#define AUTOREBOOT_HOUR       9
#define AUTOREBOOT_MINUTE     0
#define AUTOREBOOT_SECOND     0

#define AUTOREBOOT_WARN_1H    3600
#define AUTOREBOOT_WARN_30M   1800
#define AUTOREBOOT_WARN_15M   900
#define AUTOREBOOT_WARN_5M    300
#define AUTOREBOOT_WARN_1M    60
#define AUTOREBOOT_WARN_30S   30

#define AUTOREBOOT_COLOR      0xFF6600FF

enum E_AUTOREBOOT_WARN
{
	AR_WARN_1H,
	AR_WARN_30M,
	AR_WARN_15M,
	AR_WARN_5M,
	AR_WARN_1M,
	AR_WARN_30S,
	MAX_AR_WARNINGS
}

new bool:ar_warn_sent[MAX_AR_WARNINGS];
new ar_rebooting;

stock AutoReboot_ResetWarnings()
{
	for(new i = 0; i < MAX_AR_WARNINGS; i++)
		ar_warn_sent[i] = false;

	ar_rebooting = 0;
}

stock AutoReboot_SecondsUntilReboot()
{
	new hour, minute, second;
	gettime(hour, minute, second);

	new now_secs    = hour * 3600 + minute * 60 + second;
	new target_secs = AUTOREBOOT_HOUR * 3600 + AUTOREBOOT_MINUTE * 60 + AUTOREBOOT_SECOND;

	new diff = target_secs - now_secs;
	if(diff < 0)
		diff += 86400;

	return diff;
}

stock AutoReboot_SendWarning(const text[])
{
	new string[128];
	format(string, sizeof(string), "[Сервер]: {FFFFFF}Сервер будет автоматически перезагружен через: %s.", text);
	SendClientMessageToAll(AUTOREBOOT_COLOR, string);
	printf("[AutoReboot]: Сервер будет автоматически перезагружен через: %s.", text);
}

stock AutoReboot_Notify(E_AUTOREBOOT_WARN:warn_id, const text[])
{
	if(ar_warn_sent[_:warn_id])
		return 0;

	ar_warn_sent[_:warn_id] = true;
	AutoReboot_SendWarning(text);
	return 1;
}

stock AutoReboot_ExecuteRestart()
{
	if(ar_rebooting)
		return 0;

	ar_rebooting = 1;
	SendClientMessageToAll(AUTOREBOOT_COLOR, "[Сервер]: {FFFFFF}Сервер начал перезапуск.");
	print("[AutoReboot]: Сервер начал перезапуск.");
	SendRconCommand("exit");
	return 1;
}

stock AutoReboot_Init()
{
	AutoReboot_ResetWarnings();

	new seconds_left = AutoReboot_SecondsUntilReboot();
	printf("[AutoReboot]: Система загружена. Следующий перезапуск через %d сек. (%02d:%02d)", seconds_left, seconds_left / 3600, (seconds_left % 3600) / 60);
}

stock AutoReboot_OnSecondTimer()
{
	if(ar_rebooting)
		return 0;

	new seconds_left = AutoReboot_SecondsUntilReboot();

	switch(seconds_left)
	{
		case AUTOREBOOT_WARN_1H:   AutoReboot_Notify(AR_WARN_1H,   "1 час");
		case AUTOREBOOT_WARN_30M:  AutoReboot_Notify(AR_WARN_30M,  "30 минут");
		case AUTOREBOOT_WARN_15M:  AutoReboot_Notify(AR_WARN_15M,  "15 минут");
		case AUTOREBOOT_WARN_5M:   AutoReboot_Notify(AR_WARN_5M,   "5 минут");
		case AUTOREBOOT_WARN_1M:   AutoReboot_Notify(AR_WARN_1M,   "1 минуту");
		case AUTOREBOOT_WARN_30S:  AutoReboot_Notify(AR_WARN_30S,  "30 секунд");
		case 0: AutoReboot_ExecuteRestart();
	}
	return 1;
}

CMD:testinc(playerid)
{
	SendClientMessage(playerid, -1, "testinc");
	return 1;
}
// END INLINED: modules/m1stoks/autoReboot/autoreboot.inc
