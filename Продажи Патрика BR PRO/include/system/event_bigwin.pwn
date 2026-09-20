//=====================================================================
// NPC-событие "Большой куш" (skin 83)
//
// Исправлено по той же причине, что и Максимка: диалог, вызванный
// прямо в OnPlayerEnterDynamicArea (в обход кнопки взаимодействия),
// клиент показывает без кнопок. Теперь диалог открывается только
// через BigWin_ShowMenu(), которую нужно вызывать из общего
// обработчика кнопки взаимодействия в black-russia.pwn — см.
// IsPlayerNearBigWin(playerid) ниже.
//
// Получение приза (30 000 000$ и 15 000 BC) возможно только ОДИН РАЗ
// на аккаунт — факт получения хранится в базе данных (таблица
// bigwin_event), поэтому обойти ограничение релогом нельзя.
//=====================================================================

#define BIGWIN_DIALOG           (556101)

#define BIGWIN_SKIN              (83)
#define BIGWIN_MONEY             (30000000)
#define BIGWIN_BC                (15000)

new actor_bigwin = -1;
new sphere_bigwin = -1;
new Float: bigwin_coord[6] = {824.769104, 782.687072, 13.165440, 250.664932, 0.0, 0.0}; // x, y, z, angle, virtualworld, interior

public OnGameModeInit()
{
    mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `bigwin_event` (`account_id` INT NOT NULL, PRIMARY KEY (`account_id`))");

    actor_bigwin = CreateActorEx
    (
        "Большой куш",
        "Подойди для {FFFF00}взаимодействия",
        BIGWIN_SKIN,
        bigwin_coord[0], bigwin_coord[1], bigwin_coord[2], bigwin_coord[3],
        floatround(bigwin_coord[4]), floatround(bigwin_coord[5])
    );
    sphere_bigwin = CreateDynamicSphere(bigwin_coord[0], bigwin_coord[1], bigwin_coord[2], 2.0, floatround(bigwin_coord[4]), floatround(bigwin_coord[5]));

    #if defined bigwin_OnGameModeInit
        return bigwin_OnGameModeInit();
    #else
        return 1;
    #endif
}
    #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit bigwin_OnGameModeInit
#if defined bigwin_OnGameModeInit
    forward bigwin_OnGameModeInit();
#endif

//=====================================================================
// Проверка близости к NPC "Большой куш" — по образцу
// IsPlayerNearMikhail(). Вызывается из общего обработчика кнопки
// взаимодействия в black-russia.pwn.
//=====================================================================
stock IsPlayerNearBigWin(playerid)
{
    if(sphere_bigwin != -1 && IsPlayerInDynamicArea(playerid, sphere_bigwin))
        return 1;
    return 0;
}

//=====================================================================
// Показ меню "Большой куш" — реальная точка входа в событие.
// Вызывайте из обработчика кнопки взаимодействия (action == 18).
//=====================================================================
stock BigWin_ShowMenu(playerid)
{
    Dialog
    (
        playerid, BIGWIN_DIALOG, DIALOG_STYLE_LIST,
        "Большой куш",
        "Забрать подарок\n"\
        "Закрыть",
        "Выбрать", "Закрыть"
    );
    return 1;
}

forward OnBigWinCheck(playerid);
public OnBigWinCheck(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new rows = cache_num_rows();
    if(rows > 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "{FF0000}Большой куш:{FFFFFF} ты уже получал этот приз раньше.");
        return 1;
    }

    GivePlayerMoneyEx(playerid, BIGWIN_MONEY, "Большой куш", true, true);
    AddPlayerData(playerid, P_DONATE_RUB, +, BIGWIN_BC);
    UpdatePlayerDatabaseInt(playerid, "rub", GetPlayerData(playerid, P_DONATE_RUB));

    new query[128];
    mysql_format(mysql, query, sizeof query, "INSERT INTO `bigwin_event` (`account_id`) VALUES (%d)", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query);

    new msg[160];
    format(msg, sizeof msg, "{FFFF00}Большой куш:{FFFFFF} ты получил {FFFF00}%d$ {FFFFFF}и {FFFF00}%d BC{FFFFFF}!", BIGWIN_MONEY, BIGWIN_BC);
    SendClientMessage(playerid, -1, msg);
    return 1;
}

stock BigWin_TryClaim(playerid)
{
    new query[128];
    mysql_format(mysql, query, sizeof query, "SELECT `account_id` FROM `bigwin_event` WHERE `account_id`=%d LIMIT 1", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "OnBigWinCheck", "i", playerid);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == BIGWIN_DIALOG)
    {
        if(response && listitem == 0)
        {
            BigWin_TryClaim(playerid);
        }
        #if defined bigwin_OnDialogResponse
            return bigwin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
        #else
            return 1;
        #endif
    }

    #if defined bigwin_OnDialogResponse
        return bigwin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
    #if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse bigwin_OnDialogResponse
#if defined bigwin_OnDialogResponse
    forward bigwin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

//=====================================================================
// Тестовая команда — сразу показывает то же меню, что откроется у
// живого NPC по кнопке взаимодействия.
//=====================================================================
CMD:bigwingui(playerid, params[])
{
    #pragma unused params
    BigWin_ShowMenu(playerid);
    return 1;
}

//=====================================================================
// Конец модуля "Большой куш"
//=====================================================================
