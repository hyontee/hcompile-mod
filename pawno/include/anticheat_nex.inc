static const AC_CODE_NAME[AC_MAX_CODES][AC_MAX_CODE_NAME_LENGTH] =
{
	{"AirBrake (onfoot)"}, // 0
	{"AirBrake (in vehicle)"}, // 1
	{"Телепорт-Пешком "}, // 2
	{"Телепорт в машине "}, // 3
	{"Teleport (into/between vehicles) "}, // 4
	{"Teleport (vehicle to player) "}, // 5
	{"Teleport (pickups) "}, // 6
	{"FlyHack (onfoot) "},
	{"FlyHack (in vehicle) "},
	{"SpeedHack (onfoot) "},
	{"SpeedHack (in vehicle) "},
	{"Health hack (in vehicle) "},
	{"Health hack (onfoot) "},
	{"Armour hack" },
	{"Money hack "},
	{"Weapon hack "},
	{"Ammo hack (add) "},
	{"Ammo hack (infinite) "},
	{"Special actions hack "},
	{"GodMode from bullets (onfoot) "},
	{"GodMode from bullets (in vehicle) "},
	{"Невидимка "},
	{"Lagcomp-spoof "},
	{"Tuning hack "},
	{"Parkour mod "},
	{"Quanterion Change "},
	{"Rapid fire "},
	{"FakeSpawn "},
	{"FakeKill "},
	{"Silent AimBot "},
	{"CJ run "},
	{"CarShot "},
	{"CarJack "},
	{"UnFreeze "},
	{"AFK Ghost "},
	{"Full Aiming "},
	{"Fake NPC "},
	{"Reconnect "},
	{"High ping "},
	{"Dialog hack "},
	{"Sandbox "},
	{"Невалидная версия "},
	{"Rcon hack "},
	{"Tuning crasher "},
	{"Invalid seat crasher "},
	{"Dialog crasher "},
	{"Attached object crasher "},
	{"Weapon Crasher "},
	{"Подключение в один слот "},
	{"Flood callback functions"},
	{"Flood change seat "},
	{"DDos "},
	{"Игнорирование функции"},
	{"Anti-Fast movement "}
}; 

stock Float:GetPlayerPacketLoss(playerid)
{
    new stats[401], stringstats[70];
    GetPlayerNetworkStats(playerid, stats, sizeof(stats));
    new len = strfind(stats, "Packetloss: ");
    new Float:packetloss = 0.0;
    if(len != -1)
    {
        strmid(stringstats, stats, len, strlen(stats));
        new len2 = strfind(stringstats, "%");
        if(len != -1)
        {
            strdel(stats, 0, strlen(stats));
            strmid(stats, stringstats, len2-3, len2);
            packetloss = floatstr(stats);
        }
    }
    return packetloss;
} 

CB: OnCheatWarning(playerid, ip_address[], type, code, code2, count)
{
	if(pData[playerid][IsAdmin] > 1) return 0;
	if(type == 0)
    {//47 code
		if(gPlayerLogged[playerid] == 1)
		{
			switch(code)
			{
				case 0..52:
					{
//						new stringwarning[256];
                        if(playerwarning[playerid] == 0)
						{
							ASendMes(2, 0xFFA07AFF," < QANTICHEAT > %s[%d]: подозревается в использовании читов %s",getName(playerid),playerid, AC_CODE_NAME[code]);
							ASendMes(2, 0xFFA07AFF," [PacketLoss: %.1f] [Ping: %d] [WSend: 1.0] [Code: %03d]",GetPlayerPacketLoss(playerid), GetPlayerPing(playerid), code);
							AddCheater(playerid, 0);
							playerwarning[playerid] = 5;
						}
					}
			}
			switch(code2)
			{
				case 0..52:
					{
					    if(playerwarning[playerid] == 0)
     					{
							ASendMes(2, 0xFFA07AFF," < QANTICHEAT > %s[%d]: подозревается в использовании читов %s",getName(playerid),playerid, AC_CODE_NAME[code2]);
							ASendMes(2, 0xFFA07AFF," [PacketLoss: %.1f] [Ping: %d] [WSend: 1.0] [Code: %03d]",GetPlayerPacketLoss(playerid), GetPlayerPing(playerid), code);
							AddCheater(playerid, 0);
							playerwarning[playerid] = 5;
						}
					}
			}
		}
	}
	return 1;
}

// Массив AC_CODE хранит в себе текстовые форматы номеров кода анти-чита
forward OnCheatDetected(playerid, const ip_address[], type, code, code2);
public OnCheatDetected(playerid, const ip_address[], type, code, code2)
{
	if(type == AC_GLOBAL_TRIGGER_TYPE_PLAYER)
	{
		switch(code)
		{
			/*case 0,1,2,3,4:
			{
				if(gettime() - pAntiCheatLastCodeTriggerTime[playerid][code] < AC_TRIGGER_ANTIFLOOD_TIME) return 1;
				pAntiCheatLastCodeTriggerTime[playerid][code] = gettime();
				AC_CODE_TRIGGERED_COUNT[code]++;
				new trigger_type = AC_CODE_TRIGGER_TYPE[code];
				if(trigger_type == AC_CODE_TRIGGER_TYPE_WARNING)
				{
     				
     				if(playerwarning[playerid] == 0)
     				{
						ASendMes(2, 0xff0000ff," < QANTICHEAT > %s[%d]: подозревается в использовании читов %s",getName(playerid),playerid, AC_CODE_NAME[code]);
						ASendMes(2, 0xFFA07AFF," [PacketLoss: %.1f] [Ping: %d] [WSend: 1.0] [Code: %03d]",GetPlayerPacketLoss(playerid), GetPlayerPing(playerid), code);
						AddCheater(playerid, 0);
						playerwarning[playerid] = 5;
					}
					
				}
				else // AC_CODE_TRIGGER_TYPE_KICK
				{
				
					new Float:x, Float:y, Float:z;
					if(code == 0)
					{
						SetPVarInt(playerid, "Srabotal", GetPVarInt(playerid, "Srabotal")+1);
						if(GetPVarInt(playerid, "Srabotal") >= 2)
						{
							SendMes(playerid, COLOR_LIGHTRED, " Сработала антирассинхронизация. Вы были телепортированы/заспавнены [code: %d]", code);
							SCM(playerid, COLOR_LIGHTRED, " В случае, если у вас плохое интернет-соединение, оставайтесь на месте до прогрузки интерьера");
							ASendMes(2, COLOR_LIGHTRED, " [ANTIDESYNC] %s[%d] | type: SetPlayerPos (new pos)", getName(playerid), playerid);
							PlayerSpawn(playerid);
							SetPVarInt(playerid, "SleepTP", 1000);
							return 0;
						}
					}
					AntiCheatGetPos(playerid, x, y, z);
					SendMes(playerid, COLOR_LIGHTRED, " Сработала антирассинхронизация. Вы были телепортированы/заспавнены [code: %d]", code);
					SCM(playerid, COLOR_LIGHTRED, " В случае, если у вас плохое интернет-соединение, оставайтесь на месте до прогрузки интерьера");
					if(code == 2){
						ASendMes(2, COLOR_LIGHTRED, " [ANTIDESYNC] %s[%d] | type: SetPlayerPos (разрыв координат)", getName(playerid), playerid);
						okSetPlayerPos(playerid, x, y, z);
						SetPVarInt(playerid, "SleepAir", 1000);
						SetPVarFloat(playerid, "x", x);
						SetPVarFloat(playerid, "y", y);
						SetPVarFloat(playerid, "z", z);
						return 0;
					}
					if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
					{
						ASendMes(2, COLOR_LIGHTRED, " [ANTIDESYNC] %s[%d] | type: onfoot [code: %d]", getName(playerid), playerid, code);
					}
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						ASendMes(2, COLOR_LIGHTRED, " [ANTIDESYNC] %s[%d] | type: driver [code: %d]", getName(playerid), playerid, code);
					}
					if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
					{
						ASendMes(2, COLOR_LIGHTRED, " [ANTIDESYNC] %s[%d] | type: passenger [code: %d]", getName(playerid), playerid, code);
					}
					okSetPlayerPos(playerid, x, y, z);
					SetPVarInt(playerid, "SleepAir", 1000);
					SetPVarFloat(playerid, "x", x);
					SetPVarFloat(playerid, "y", y);
					SetPVarFloat(playerid, "z", z);
				}	
				return 1;
			}*/
			case 5, 6, 11, 22:
			{
				return 1;
			}
			case 32: // CarJack
			{
				new Float:x, Float:y, Float:z;
				AntiCheatGetPos(playerid, x, y, z);
				return okSetPlayerPos(playerid, x, y, z);
			}
			case 40: // Sandbox
			{
				SendClientMessage(playerid, -1, MAX_CONNECTS_MSG);
				return AntiCheatKickWithDesync(playerid, code);
			}
			case 41: // Invalid Version
			{
				SendClientMessage(playerid, -1, UNKNOWN_CLIENT_MSG);
				return AntiCheatKickWithDesync(playerid, code);
			}
			default:
			{
				if(gettime() - pAntiCheatLastCodeTriggerTime[playerid][code] < AC_TRIGGER_ANTIFLOOD_TIME) return 1;
				pAntiCheatLastCodeTriggerTime[playerid][code] = gettime();
				AC_CODE_TRIGGERED_COUNT[code]++;
				new trigger_type = AC_CODE_TRIGGER_TYPE[code];
				if(trigger_type == AC_CODE_TRIGGER_TYPE_WARNING)
				{
     				//format(string, sizeof(string), " %s[%d] подозревается в использовании чит-программ: %s [code: %03d].", /*NickName*/, playerid, AC_CODE_NAME[code], code);
     				if(playerwarning[playerid] == 0)
     				{
						ASendMes(2, 0xFFA07AFF," < QANTICHEAT > %s[%d]: подозревается в использовании читов %s",getName(playerid),playerid, AC_CODE_NAME[code]);
						ASendMes(2, 0xFFA07AFF," [PacketLoss: %.1f] [Ping: %d] [WSend: 1.0] [Code: %03d]",GetPlayerPacketLoss(playerid), GetPlayerPing(playerid), code);
						AddCheater(playerid, 0);
						playerwarning[playerid] = 5;
					}
					/*Отправка сообщения администрации. Пример: SendAdminMessage(-1, string);*/
				}
				else // AC_CODE_TRIGGER_TYPE_KICK
				{
					new hourkick, minutekick, secondkick, daykick, monthkick, yearkick;
					getdate(yearkick, monthkick, daykick);
					gettime(hourkick, minutekick, secondkick);
					ASendMes(2, 0xFFA07AFF," < QANTICHEAT > %s[%d]: был кикнут за подозрение в читерстве %s [Ping: %d] [Code: %03d]",getName(playerid),playerid, AC_CODE_NAME[code], GetPlayerPing(playerid), code);
					SendMes(playerid, -1, " Соединение с сервером разорвано. (Принудительно - %d:%d:%d %d/%d/%d)", hourkick, minutekick, secondkick, daykick, monthkick, yearkick);
					new stringkick[512];
					new hour, minute, second;
					gettime(hour, minute, second);
					new year, month, day;
					getdate(year, month, day);
					format(stringkick, 512, "\n\t{FFFFFF}Вы были кикнуты по подозрению в использовании чит-программ\n\tЕсли вы считаете, что произошла ошибка, то сообщите нам\n\thttps://forum.warrior-rp.ru/ » {FFFFFF}Технический раздел\n\t{FFFFFF}Ник: {FF0000}%s\n\t{FFFFFF}Причина: {FF0000}%s(%d)\n\t{FFFFFF}Дата: {FF0000}%d.%d.%d %d:%d:%d\n\t{FFFFFF}PacketLoss: {FF0000}%.1f\n\t{FFFFFF}Ping: {FF0000}%d", getName(playerid), AC_CODE_NAME[code], code, day, month, year, hour, minute, second, GetPlayerPacketLoss(playerid), GetPlayerPing(playerid));
					SendPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Network AntiCheat v1.0", stringkick, "x", "");
					AntiCheatKickWithDesync(playerid, code);
				}
			}
		}
	}
	else // AC_GLOBAL_TRIGGER_TYPE_IP
	{
		AC_CODE_TRIGGERED_COUNT[code]++;
		BlockIpAddress(ip_address, 0);
	}
	return 1;
}