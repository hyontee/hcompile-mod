//SetPlayerPosAC(playerid, Float:x, Float:y, Float:z, worldid = -1, interiorid = -1, setUP = false)
#if defined _ac_inc
	#endinput
#endif
#define _ac_inc
// Массив AC_TRIGGER_TYPE_NAME хранит в себе названия типов срабатываний (наказаний) анти-чита.  
static const AC_TRIGGER_TYPE_NAME[AC_MAX_TRIGGER_TYPES][AC_MAX_TRIGGER_TYPE_NAME_LENGTH] =  
{ 
    {"Отключён"}, 
    {"Warning"}, 
    {"Kick"} 
}; 
// Массив AC_CODE хранит в себе текстовые форматы номеров кода анти-чита  
static const AC_CODE[AC_MAX_CODES][AC_MAX_CODE_LENGTH] =  
{ 
    "000", "001", "002", "003", "004", "005", "006", "007", "008", "009", 
    "010", "011", "012", "013", "014", "015", "016", "017", "018", "019", "020", 
    "021", "022", "023", "024", "025", "026", "027", "028", "029", "030", 
    "031", "032", "033", "034", "035", "036", "037", "038", "039", "040", 
    "041", "042", "043", "044", "045", "046", "047", "048", "049", "050", "051", "052" 
}; 
// Массив AC_CODE_NAME хранит в себе названия читов, которые соответствуют кодам анти-чита  
static const AC_CODE_NAME[AC_MAX_CODES][AC_MAX_CODE_NAME_LENGTH] =  
{ 
    {"AirBreak (onfoot)"}, 
    {"AirBreak (in vehicle)"}, 
    {"Teleport (onfoot)"}, 
    {"Teleport (in vehicle)"}, 
    {"Teleport (into/between vehicles)"}, 
    {"Teleport (vehicle to player)"}, 
    {"Teleport (pickups)"}, 
    {"FlyHack (onfoot)"}, 
    {"FlyHack (in vehicle)"}, 
    {"SpeedHack (onfoot)"}, 
    {"SpeedHack (in vehicle)"}, 
    {"Health hack (in vehicle)"}, 
    {"Health hack (onfoot)"}, 
    {"Armour hack"}, 
    {"Money hack"}, 
    {"Weapon hack"}, 
    {"Ammo hack (add)"}, 
    {"Ammo hack (infinite)"}, 
    {"Special actions hack"}, 
    {"GodMode from bullets (onfoot)"}, 
    {"GodMode from bullets (in vehicle)"}, 
    {"Invisible hack"}, 
    {"Lagcomp-spoof"}, 
    {"Tuning hack"}, 
    {"Parkour mod"}, 
    {"Quick turn"}, 
    {"Rapid fire"}, 
    {"FakeSpawn"}, 
    {"FakeKill"}, 
    {"Pro Aim"}, 
    {"CJ run"}, 
    {"CarShot"}, 
    {"CarJack"}, 
    {"UnFreeze"}, 
    {"AFK Ghost"}, 
    {"Full Aiming"}, 
    {"Fake NPC"}, 
    {"Reconnect"}, 
    {"High ping"}, 
    {"Dialog hack"}, 
    {"Sandbox"}, 
    {"Invalid version"}, 
    {"Rcon hack"}, 
    {"Tuning crasher"}, 
    {"Invalid seat crasher"}, 
    {"Dialog crasher"}, 
    {"Attached object crasher"}, 
    {"Weapon Crasher"}, 
    {"Connects to one slot"}, 
    {"Flood callback functions"}, 
    {"Flood change seat"}, 
    {"DDos"}, 
    {"NOP's"} 
}; 

publics: OnCheatDetected(playerid, const ip_address[], type, code, code2)
{
    if (type == 0)
    {//47 code
        switch(code)
        {
            case 2: {
				if (pTemp[playerid][tSelectSkin]) return 1;
                if (pInfo[playerid][pAdmin] > 0) return 1;
			}
			case 3: {
				if (GetPVarInt(playerid,"AntiKickGarage") > gettime()) return 1;
			}
            case 5: {
                if (GetPVarInt(playerid, "AutoShopShow") != 0) return 1; 
            }
            case 14: return 1; 
            case 12: return SetPlayerHealth(playerid, GetPlayerHP(playerid));
            case 13: return SetPlayerArmour(playerid, GetPlayer_Armour(playerid));
            case 27: if (pTemp[playerid][tPaintTeam] != 0) return 1;
            case 30: {
                PlayerSpawnEx(playerid);
				return 1;
            }
            case 32: {
                new 
                    Float:x, 
                    Float:y, 
                    Float:z;

                AntiCheatGetPos(playerid, x, y, z);
                return SetPlayerPosAC(playerid, x, y, z, pTemp[playerid][tVirtualWorld], pTemp[playerid][tInterior]);
            }
            case 39: {//DIALOG HACK
                ac_ShowPlayerDialog(playerid, -1);
                return 1;
            }
            case 40: {
                SendClientMessage(playerid, -1, MAX_CONNECTS_MSG);
                return AntiCheatKickWithDesync(playerid, code);
            }
            case 41:  {
                SendClientMessage(playerid, -1, UNKNOWN_CLIENT_MSG);
                return AntiCheatKickWithDesync(playerid, code);
            }
            case 43 .. 47:  {
                //ResetPlayerWeapons(playerid);
                //Kick(playerid);
                return 1;
            }
            default:
            {
                if (pTemp[playerid][PlayerAFK] > 3) return 1;
                if (pInfo[playerid][pAdmin] > 0) return 1;
                if (gettime() - pAntiCheatLastCodeTriggerTime[playerid][code] < AC_TRIGGER_ANTIFLOOD_TIME)
                    return 1;
                
                pAntiCheatLastCodeTriggerTime[playerid][code] = gettime();
                AC_CODE_TRIGGERED_COUNT[code]++;

                new
                    string_[128],
                    trigger_type = AC_CODE_TRIGGER_TYPE[code];

                if (trigger_type == AC_CODE_TRIGGER_TYPE_WARNING)
                {
                    format(string_, sizeof string_, "<Warning> %s[%d]: Возможно: %s [code: %03d]", pInfo[playerid][pName], playerid, AC_CODE_NAME[code], code);
					SendACMessageAdmins(COLOR_REDD, string_, 2);
                }
                else // AC_CODE_TRIGGER_TYPE_KICK
                {
                    format(string_, sizeof string_, "<Warning> %s[%d] был кикнут по подозрению: %s [code: %03d].", pInfo[playerid][pName], playerid, AC_CODE_NAME[code], code);
                   	SendACMessageAdmins(COLOR_REDD, string_, 2);
                    format(string_, sizeof string_,"Вы были кикнуты по подозрению в читерстве (Наименование: %s, Код: %d)", AC_CODE_NAME[code], code);
					SendClientMessage(playerid, COLOR_LIGHTRED, string_);
                    AntiCheatKickWithDesync(playerid, code);
                }
            }
        }
    }
    else // AC_GLOBAL_TRIGGER_TYPE_IP
    {
        AC_CODE_TRIGGERED_COUNT[code]++;
        new
            string[58 - 8 + 16 + AC_MAX_CODE_NAME_LENGTH + AC_MAX_CODE_LENGTH];
        format(string, sizeof(string), "<AC-BAN-IP> IP-адрес %s был заблокирован: %s [code: %03d].", ip_address, AC_CODE_NAME[code], code);
       	SendACMessageAdmins(COLOR_REDD, string, 2);
        BlockIpAddress(ip_address, 0);
    }
    return 1;
}  
stock ShowPlayer_AntiCheatSettings(playerid)
{
    static
        dialog_string[42 + 19 - 8 + (AC_MAX_CODE_LENGTH + AC_MAX_CODE_NAME_LENGTH + AC_MAX_TRIGGER_TYPE_NAME_LENGTH + 10)*AC_MAX_CODES_ON_PAGE] = EOS;

    new
        triggeredCount = 0,
        page = pAntiCheatSettingsPage{playerid},
        next = 0,
        index = 0;

    dialog_string = "Название\tНаказание\tКол-во срабатываний\n";
    for(new i = 0; i < AC_MAX_CODES; i++)
    {
        if (i >= (page * AC_MAX_CODES_ON_PAGE) && i < (page * AC_MAX_CODES_ON_PAGE) + AC_MAX_CODES_ON_PAGE)
            next++;

        if (i >= (page - 1) * AC_MAX_CODES_ON_PAGE && i < ((page - 1) * AC_MAX_CODES_ON_PAGE) + AC_MAX_CODES_ON_PAGE)
        {
            triggeredCount = AC_CODE_TRIGGERED_COUNT[i];

            format(dialog_string, sizeof(dialog_string), "%s[%s] %s\t%s\t%d\n", 
                dialog_string,
                AC_CODE[i], 
                AC_CODE_NAME[i],
                AC_TRIGGER_TYPE_NAME[AC_CODE_TRIGGER_TYPE[i]],
                triggeredCount);

            pAntiCheatSettingsMenuListData[playerid][index++] = i;
        }
    }
    if (next) 
        strcat(dialog_string, ">>> Следующая страница\n");

    if (page > 1) 
        strcat(dialog_string, "<<< Предыдущая страница");
    return ShowPlayerDialog(playerid, DIALOG_ANTICHEAT_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Настройки: "colwhi"Анти-чита", dialog_string, "Выбрать", "Отмена");
}

// Функция показа меню редактирования типа срабатывания определённого кода в анти-чите
stock ShowPlayer_AntiCheatEditCode(playerid, code)
{
    new
        dialog_header[22 - 4 + AC_MAX_CODE_LENGTH + AC_MAX_CODE_NAME_LENGTH],
        dialog_string[AC_MAX_TRIGGER_TYPE_NAME_LENGTH*AC_MAX_TRIGGER_TYPES];

    format(dialog_header, sizeof dialog_header, "Код: %s | Название: %s", AC_CODE[code], AC_CODE_NAME[code]);

    for(new i = 0; i < AC_MAX_TRIGGER_TYPES; i++)
    {
        strcat(dialog_string, AC_TRIGGER_TYPE_NAME[i]);

        if (i + 1 != AC_MAX_TRIGGER_TYPES)
            strcat(dialog_string, "\n");
    }
    return ShowPlayerDialog(playerid, DIALOG_ANTICHEAT_EDIT_CODE, DIALOG_STYLE_LIST, dialog_header, dialog_string, !"Выбрать", !"Назад");
}
publics: UploadAntiCheatSettings()
{
    new
		rows = 0,
		tick = GetTickCount();
    cache_get_row_count(rows);

    if (rows > 0)
    {
        for(new i = 0; i < AC_MAX_CODES; i++)
        {
            cache_get_value_name_int(i, "ac_code_trigger_type", AC_CODE_TRIGGER_TYPE[i]);

            if (AC_CODE_TRIGGER_TYPE[i] == AC_CODE_TRIGGER_TYPE_DISABLED)
                EnableAntiCheat(i, 0);
        }
        printf("[Загрузка ...] Настройки анти-чита успешно загружены (загружено: %d). Потрачено: %dмс.", rows, GetTickCount() - tick);
    }
    else print("[Загрузка ...] Настройки анти-чита не найдены в базе данных. Загрузка мода остановлена - настройте анти-чит."); 
    return 1;
}