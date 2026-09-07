// ============================================================
//  AdminTime - top-screen time/date display for admins
//  lonexs STUDIO
//
//  Как подключить:
//   1. Положите этот файл в папку filterscripts/ вашего сервера
//      и скомпилируйте его в pawno (получится admintime.amx).
//   2. В server.cfg добавьте в строку filterscripts:
//         filterscripts admintime
//   3. Если у вас своя система админки (не RCON), замените
//      функцию IsAdmin(playerid) ниже на проверку вашей
//      переменной, например: return PlayerInfo[playerid][pAdmin] > 0;
// ============================================================

#include <a_samp>

#define ADMINTIME_COLOR         0xFFFFFFFF   // цвет текста
#define ADMINTIME_X             320.0        // X позиция (по центру сверху)
#define ADMINTIME_Y             3.0          // Y позиция (самый верх экрана)

new PlayerText:AdminTimeTD[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new AdminTimeTimer;

// ---- ЗАМЕНИТЕ ЭТУ ФУНКЦИЮ ПОД ВАШУ СИСТЕМУ АДМИНКИ ----
stock IsAdmin(playerid)
{
    if (IsPlayerAdmin(playerid)) return 1; // RCON-админ по умолчанию
    // Пример для своей системы:
    // if (PlayerInfo[playerid][pAdmin] > 0) return 1;
    return 0;
}
// ---------------------------------------------------------

public OnFilterScriptInit()
{
    AdminTimeTimer = SetTimer("AdminTime_Update", 1000, true);
    print("[AdminTime] Filterscript loaded.");
    return 1;
}

public OnFilterScriptExit()
{
    if (AdminTimeTimer != 0)
        KillTimer(AdminTimeTimer);

    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (AdminTimeTD[i] != PlayerText:INVALID_TEXT_DRAW)
        {
            PlayerTextDrawDestroy(i, AdminTimeTD[i]);
            AdminTimeTD[i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }
    return 1;
}

public OnPlayerConnect(playerid)
{
    AdminTimeTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if (AdminTimeTD[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, AdminTimeTD[playerid]);
        AdminTimeTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

forward AdminTime_Update();
public AdminTime_Update()
{
    new hh, mm, ss, day, month, year;
    gettime(hh, mm, ss);
    getdate(year, month, day);

    new str[64];
    format(str, sizeof(str), "%02d:%02d:%02d-%02d.%02d.%d", hh, mm, ss, day, month, year);

    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (!IsPlayerConnected(i)) continue;
        if (!IsAdmin(i))
        {
            // если игрок разжалован без реконнекта - убираем текстдрав
            if (AdminTimeTD[i] != PlayerText:INVALID_TEXT_DRAW)
            {
                PlayerTextDrawDestroy(i, AdminTimeTD[i]);
                AdminTimeTD[i] = PlayerText:INVALID_TEXT_DRAW;
            }
            continue;
        }

        if (AdminTimeTD[i] == PlayerText:INVALID_TEXT_DRAW)
        {
            AdminTimeTD[i] = CreatePlayerTextDraw(i, ADMINTIME_X, ADMINTIME_Y, str);
            PlayerTextDrawFont(i, AdminTimeTD[i], TEXT_DRAW_FONT_MONOSPACE);
            PlayerTextDrawLetterSize(i, AdminTimeTD[i], 0.35, 1.4);
            PlayerTextDrawAlignment(i, AdminTimeTD[i], 2); // center
            PlayerTextDrawColor(i, AdminTimeTD[i], ADMINTIME_COLOR);
            PlayerTextDrawSetOutline(i, AdminTimeTD[i], 1);
            PlayerTextDrawSetShadow(i, AdminTimeTD[i], 0);
            PlayerTextDrawSetProportional(i, AdminTimeTD[i], 1);
            PlayerTextDrawBackgroundColor(i, AdminTimeTD[i], 0x00000096);
            PlayerTextDrawShow(i, AdminTimeTD[i]);
        }
        else
        {
            PlayerTextDrawSetString(i, AdminTimeTD[i], str);
        }
    }
    return 1;
}
