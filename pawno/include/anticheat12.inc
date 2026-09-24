#define SQL_TABLE_ANTICHEAT "rakcheat"

#define void%0(%1) forward%0(%1); public%0(%1)

enum AC_DETECT_STATUS_INFO
{
	AcCodeName[100],
	AcCodeStatus,
	AcDetectedNums
}

new rACInfo[72][AC_DETECT_STATUS_INFO] = {
	{"AirBreak (onfoot)", 0, 0},
	{"AirBreak (in vehicle)", 0, 0},
	{"Teleport hack (onfoot)", 0, 0},
	{"Teleport hack (in vehicle)", 0, 0},
	{"Teleport hack (into/between vehicles)", 0, 0},
	{"Teleport hack (vehicle to player)", 3, 0},
	{"Teleport hack (pickups)", 3, 0},
	{"FlyHack (onfoot)", 0, 0},
	{"FlyHack (in vehicle)", 0, 0},
	{"SpeedHack (onfoot)", 0, 0},
	{"SpeedHack (in vehicle)", 0, 0},
	{"Health hack (in vehicle)", 3, 0},
	{"Health hack (onfoot)", 0, 0},
	{"Armour hack", 0, 0},
	{"Money hack", 3, 0},
	{"Weapon hack", 0, 0},
	{"Ammo hack (add)", 0, 0},
	{"Ammo hack (infinite)", 0, 0},
	{"Special actions hack", 0, 0},
	{"GodMode from bullets (onfoot)", 0, 0},
	{"GodMode from bullets (in vehicle)", 0, 0},
	{"Invisible hack", 0, 0},
	{"Lagcomp-spoof", 3, 0},
	{"Tuning hack", 0, 0},
	{"Parkour mod", 0, 0},
	{"Quick turn", 0, 0},
	{"Rapid fire", 0, 0},
	{"FakeSpawn", 0, 0},
	{"FakeKill", 0, 0},
	{"Pro Aim", 0, 0},
	{"CJ run", 0, 0},
	{"CarShot", 0, 0},
	{"CarJack", 3, 0},
	{"UnFreeze", 0, 0},
	{"AFK Ghost", 0, 0},
	{"Full Aiming", 0, 0},
	{"Fake NPC", 0, 0},
	{"Reconnect", 0, 0},
	{"High ping", 0, 0},
	{"Dialog hack", 0, 0},
	{"Protection from the sandbox", 3, 0},
	{"Protection against an invalid version", 3, 0},
	{"Rcon hack", 3, 0},
	{"Tuning crasher", 3, 0},
	{"Invalid seat crasher", 3, 0},
	{"Dialog crasher", 3, 0},
	{"Attached object crasher", 3, 0},
	{"Weapon Crasher", 3, 0},
	{"Flood protection connects to one slot", 0, 0},
	{"Flood callback functions", 0, 0},
	{"Flood change seat", 0, 0},
	{"Ddos", 3, 0},
	{"NOP's", 0, 0},
	{"Invalid position", 0, 0},
	{"Invalid quaternions", 0, 0},
	{"Invalid velocity", 0, 0},
	{"Invalid surfing offsets", 0, 0},
	{"Invalid surfing", 0, 0},
	{"Invalid animation flags", 0, 0},
	{"Invalid health", 0, 0},
	{"Invalid train speed", 0, 0},
	{"Invalid roll", 0, 0},
	{"Invalid direction", 0, 0},
	{"Invalid angular velocity", 0, 0},
	{"Invalid origin", 3, 0},
	{"Invalid hitpos", 3, 0},
	{"Invalid offsets", 3, 0},
	{"Invalid camfrontvec", 0, 0},
	{"Invalid campos", 0, 0},
	{"Invalid aimz", 0, 0},
	{"Invalid sync", 3, 0},
	{"Shakecam", 0, 0}
};

void OnCheatDetected(playerid, ip_address[], type, code)
{
	if(GetPVarInt(playerid, "AcKickAntiFlood") > GetTickCount()) return 1;
    if(rACInfo[code][AcCodeStatus] != 1 && rACInfo[code][AcCodeStatus] != 2)
    {
        rACInfo[code][AcDetectedNums]++;
		static queryFmt[] = "UPDATE "SQL_TABLE_ANTICHEAT" SET AcDetectedNums = '%d' WHERE AcId = '%d'";
		new query[sizeof(queryFmt) + (-2 + 11) + (-2 + 11)];
	    mysql_format(connect_mysql, query, sizeof(query), queryFmt, rACInfo[code][AcDetectedNums], code + 1);
	    mysql_function_query(connect_mysql, query, false, "", "");
	}
    if(type) BlockIpAddress(ip_address, 0);
    else
	{
	    switch(rACInfo[code][AcCodeStatus])
		{
			case 0:
			{
				SetPVarInt(playerid, "AcKickAntiFlood", GetTickCount() + 10000);
			    static const fmt_str[] = "[Античит] Вы были кикнуты в связи с подозрением в читерстве. Код события: %03d";
			    static string[sizeof(fmt_str) + (-4 + 50)];
			    string[0] = EOS;
			    format(string, sizeof(string), fmt_str, code);
			    SendClientMessage(playerid, 0xFF4500FF, string);
			    SendClientMessage(playerid, 0xFF4500FF, "Примечание: К ложным определениям античита могут привести следующие факторы:");
			    SendClientMessage(playerid, 0xFF4500FF, "Высокий пинг, слабое интернет-соединение, проблемы на сервере, настоящие читеры");
			    AntiCheatKickWithDesync(playerid, code);
			    static const fmt_adm[] = "Античит < ERROR %03d > %s[%d] кикнут за %s";
			    static admin[sizeof(fmt_adm) + (-4 + 50) + (-2 + MAX_PLAYER_NAME) + (-2 + 11) + (-2 + 100)];
				admin[0] = EOS;
				format(admin, sizeof(admin), fmt_adm, code, player_name[playerid], playerid, rACInfo[code][AcCodeName]);
				AdmChat(0xC0C0C0FF, admin);
			    return 0;
			}
			case 1:
			{
				SetPVarInt(playerid, "AcKickAntiFlood", GetTickCount() + 5000);
				static const fmt_str[] = "Античит < ERROR %03d > %s[%d] подозревается в %s";
				static string[sizeof(fmt_str) + (-4 + 50) + (-2 + MAX_PLAYER_NAME) + (-2 + 11) + (-2 + 100)];
				string[0] = EOS;
				format(string, sizeof(string), fmt_str, code, player_name[playerid], playerid, rACInfo[code][AcCodeName]);
				AdmChat(0xF0E68CFF, string);
				return 1;
			}
			case 2: return 1;
			case 3:
			{
				switch(code)
				{
					case 5, 6, 11, 22: return 1;
					case 14:
					{
					    new rakmoney = AntiCheatGetMoney(playerid);
					    ResetPlayerMoney(playerid);
					    GivePlayerMoney(playerid, rakmoney);
					    return 1;
					}
					case 32:
					{
						new Float:rak_X, Float:rak_Y, Float:rak_Z;
						AntiCheatGetPos(playerid, rak_X, rak_Y, rak_Z);
						SetPlayerPos(playerid, rak_X, rak_Y, rak_Z);
						return 1;
					}
					case 40, 41, 43..47, 51: return AntiCheatKickWithDesync(playerid, code), 0;
					case 64..66, 70: return 0;
				}
			}
		}
	}
	return 1;
}

void OnCheatWarning(playerid, ip_address[], type, code, code2, count)
{
    if(rACInfo[code][AcCodeStatus] != 2)
    {
		switch(code)
		{
			case 8..10, 31:
			{
				static const fmt_str[] = "Античит < ERROR %03d > %s[%d] подозревается в %s {FF4500}[ПРОВЕРИТЬ ЧЕРЕЗ СЛЕЖКУ]";
				static string[sizeof(fmt_str) + (-4 + 50) + (-2 + MAX_PLAYER_NAME) + (-2 + 11) + (-2 + 100)];
				string[0] = EOS;
				format(string, sizeof(string), fmt_str, code, player_name[playerid], playerid, rACInfo[code][AcCodeName]);
				AdmChat(0xF0E68CFF, string);
			}
		}
	}
    return 1;
}

DialogCreate:AC_CODE_SETTINGS(playerid)
{
    static const fmt_str[] = "\n{FFFACD}[%03d] {FFFFFF}%s\t%s\t%s[%d игроков]";
    static string[(sizeof(fmt_str) + (-2 + 11) + (-2 + 100) + (-2 + 50) + (-2 + 11)) * 15];
    string[0] = EOS;
    static line[sizeof(fmt_str) + (-2 + 11) + (-2 + 100) + (-2 + 50) + (-2 + 11)];
    line[0] = EOS;
    strcat(string, "{FFFFFF}Название\t{FFFFFF}Наказание\t{FFFFFF}Наказано");
    new rakpage = GetPVarInt(playerid, "AcSettingsPage") - 1;
    new raktemp;
    for(new i = rakpage * 15; i < rakpage * 15 + 15; i++)
	{
	    if(i >= sizeof(rACInfo)) break;
	    line[0] = EOS;
	    format(line, sizeof(line), fmt_str, i, rACInfo[i][AcCodeName], ((rACInfo[i][AcCodeStatus] == 0) ? "{FF4500}Кик{FFFFFF}" :
		((rACInfo[i][AcCodeStatus] == 1) ? "{FFFF00}Оповещение{FFFFFF}" : ((rACInfo[i][AcCodeStatus] == 2) ? "{9ACD32}Отключен{FFFFFF}" :
		"{00BFFF}Системный{FFFFFF}"))), (rACInfo[i][AcDetectedNums] == 0) ? "{C0C0C0}" : "{FFFFFF}", rACInfo[i][AcDetectedNums]);
		strcat(string, line);
		raktemp++;
	}
	SetPVarInt(playerid, "AcSettingsRowsOnePage", raktemp);
	if(rakpage > 0)
	{
	    SetPVarInt(playerid, "AcSettingsBackPage", 1);
	    strcat(string, "\n{EEE8AA}Предыдущая страница{FFFFFF}");
	}
	if(raktemp == 15)
	{
	    strcat(string, "\n{FFA500}Следующая страница{FFFFFF}");
	}
	Dialog_Open(playerid, Dialog:AC_CODE_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "{00BFFF}Настройка системы защиты сервера", string, "Дальше", "Отмена");
}
DialogResponse:AC_CODE_SETTINGS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        DeletePVar(playerid, "AcSettingsPage");
        DeletePVar(playerid, "AcSettingsRowsOnePage");
        DeletePVar(playerid, "AcSettingsBackPage");
        return 1;
	}
	new rakpage = GetPVarInt(playerid, "AcSettingsPage") - 1;
	new page_num = GetPVarInt(playerid, "AcSettingsRowsOnePage");
    if(GetPVarInt(playerid, "AcSettingsBackPage")  && listitem == page_num)
    {
	    if(!rakpage)
	    {
	        return Dialog_Show(playerid, Dialog:AC_CODE_SETTINGS);
		}
		DeletePVar(playerid, "AcSettingsBackPage");
		SetPVarInt(playerid, "AcSettingsPage", rakpage);
		Dialog_Show(playerid, Dialog:AC_CODE_SETTINGS);
	}
	else if(!GetPVarInt(playerid, "AcSettingsBackPage") ? (listitem == page_num) : (listitem == page_num + 1))
	{
	    if((rakpage + 1) * 15 >= sizeof(rACInfo))
	    {
	        return Dialog_Show(playerid, Dialog:AC_CODE_SETTINGS);
		}
		SetPVarInt(playerid, "AcSettingsPage", rakpage + 2);
		Dialog_Show(playerid, Dialog:AC_CODE_SETTINGS);
	}
	else
	{
	    new code = rakpage * 15 + listitem;
	    if(rACInfo[code][AcCodeStatus] == 3)
	    {
	        SendClientMessage(playerid, 0xFF4500FF, "Невозможно изменить логику работы системного античита");
	        return Dialog_Show(playerid, Dialog:AC_CODE_SETTINGS);
		}
	    SetPVarInt(playerid, "AcSettingsSelectCode", code);
	    Dialog_Show(playerid, Dialog:AC_CODE_SETTINGS_CLICK);
	}
	return 1;
}

DialogCreate:AC_CODE_SETTINGS_CLICK(playerid)
{
    Dialog_Open(playerid, Dialog:AC_CODE_SETTINGS_CLICK, DIALOG_STYLE_LIST, "{00BFFF}Настройка наказания", "Кикать\nОповещать\nОтключить", "Выбрать", "Отмена");
}
DialogResponse:AC_CODE_SETTINGS_CLICK(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        DeletePVar(playerid, "AcSettingsPage");
        DeletePVar(playerid, "AcSettingsRowsOnePage");
        DeletePVar(playerid, "AcSettingsBackPage");
        DeletePVar(playerid, "AcSettingsSelectCode");
        return 1;
	}
	new rakcode = GetPVarInt(playerid, "AcSettingsSelectCode");
	rACInfo[rakcode][AcCodeStatus] = listitem;
	switch(rACInfo[rakcode][AcCodeStatus])
	{
		case 0, 1: EnableAntiCheat(rakcode, 1);
		case 2: EnableAntiCheat(rakcode, 0);
	}
	static queryFmt[] = "UPDATE "SQL_TABLE_ANTICHEAT" SET AcCodeStatus = '%d' WHERE AcId = '%d'";
	new query[sizeof(queryFmt) + (-2 + 11) + (-2 + 11)];
    mysql_format(connect_mysql, query, sizeof(query), queryFmt, listitem, rakcode + 1);
    mysql_function_query(connect_mysql, query, false, "", "");
	DeletePVar(playerid, "AcSettingsSelectCode");
	Dialog_Show(playerid, Dialog:AC_CODE_SETTINGS);
	SendClientMessage(playerid, 0x9ACD32FF, "Наказание античита успешно изменено");
	return 1;
}

OnServerAcSettingsSuccessLoaded()
{
	new gtk = GetTickCount();
	new raktemp;
	new Cache:res = mysql_query(connect_mysql, "SELECT * FROM "SQL_TABLE_ANTICHEAT"", true);
	for(new cyc; cyc < cache_num_rows(); cyc ++)
	{
		if(raktemp > sizeof(rACInfo))
		{
			print("[Античит] raktemp > rACInfo");
			break;
		}
	    rACInfo[cyc][AcCodeStatus] = cache_get_field_content_int(cyc, "AcCodeStatus");
		rACInfo[cyc][AcDetectedNums] = cache_get_field_content_int(cyc, "AcDetectedNums");
		switch(rACInfo[cyc][AcCodeStatus])
		{
			case 0, 1, 3: EnableAntiCheat(cyc, 1);
			case 2: EnableAntiCheat(cyc, 0);
		}
	    raktemp ++;
	}
	cache_delete(res);
	printf("[Античит] Загружено %d настроек античита за %f секунд", raktemp, float((GetTickCount() - gtk) / 1000));
	return 1;
}

DisableAntiCheatForAdmins(playerid)
{
	EnableAntiCheatForPlayer(playerid, 0, 0);
	EnableAntiCheatForPlayer(playerid, 1, 0);
	EnableAntiCheatForPlayer(playerid, 2, 0);
	EnableAntiCheatForPlayer(playerid, 3, 0);
	EnableAntiCheatForPlayer(playerid, 7, 0);
	EnableAntiCheatForPlayer(playerid, 8, 0);
	EnableAntiCheatForPlayer(playerid, 10, 0);
	EnableAntiCheatForPlayer(playerid, 19, 0);
	EnableAntiCheatForPlayer(playerid, 20, 0);
	return 1;
}