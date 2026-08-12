#include <a_samp>

// Настройки вайтлиста
#define WHITELIST_MODE         true    // Включить вайтлист?
new const whitelistPlayers[][] =       // Ники разрешённых игроков
{
    "dev_shram",
    "Test_Test",
    "Vitalka_Coder",
    "Dev_Vitaliya"
};

// Настройки времени открытия
#define SERVER_OPEN_TIME       true    // Включить временной доступ?
#define OPEN_DAY              1       // День
#define OPEN_MONTH            5       // Месяц
#define OPEN_HOUR             12      // Час
#define OPEN_MINUTE           0       // Минута

public OnPlayerConnect(playerid)
{
    // --- Проверка времени доступа ---
    #if SERVER_OPEN_TIME == true
    {
        new month, day, hour, minute;
        getdate(_, month, day);
        gettime(hour, minute, _);

        if(month < OPEN_MONTH || (month == OPEN_MONTH && day < OPEN_DAY) || 
          (month == OPEN_MONTH && day == OPEN_DAY && hour < OPEN_HOUR) ||
          (month == OPEN_MONTH && day == OPEN_DAY && hour == OPEN_HOUR && minute < OPEN_MINUTE))
        {
            new msg[128];
            format(msg, sizeof(msg), 
                "������ ��������� %02d.%02d � %02d:%02d",
                OPEN_DAY, OPEN_MONTH, OPEN_HOUR, OPEN_MINUTE);
            
            SendClientMessage(playerid, 0xFC6701FF, msg);
            SetTimerEx("DelayedKick", 150, false, "i", playerid);
            return 1;
        }
    }
    #endif

    // --- Проверка вайтлиста ---
    #if WHITELIST_MODE == true
    {
        new name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, sizeof(name));

        new allowed;
        for(new i; i < sizeof(whitelistPlayers); i++) 
        {
            if(!strcmp(name, whitelistPlayers[i], false)) 
            {
                allowed = 1;
                break;
            }
        }

        if(!allowed)
        {
            SendClientMessage(playerid, 0xFF0000AA, "������ ������ ��� ��������!");
            SetTimerEx("DelayedKick", 100, false, "i", playerid);
            return 1;
        }
    }
    #endif

    // Если прошли все проверки
    printf("[ACCESS] ����� %s ����� �� ������", ReturnPlayerName(playerid));
    return 1;
}

forward DelayedKick(playerid);
public DelayedKick(playerid) return Kick(playerid);

stock ReturnPlayerName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}
