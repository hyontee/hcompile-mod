//=====================================================================
// NPC-проводник "Максимка" (skin 6881)
//
// ВАЖНО (исправлено): в этом моде диалоги у NPC НЕ открываются сами
// по себе при входе в зону — игрок нажимает кнопку взаимодействия,
// клиент шлёт RPC (action == 18), и сервер уже сам проверяет, у
// какого NPC стоит игрок (см. IsPlayerNearMikhail/IsPlayerNearHelper
// в black-russia.pwn) и вызывает нужную команду. Диалог, вызванный
// в обход этой цепочки (как было раньше — прямо в
// OnPlayerEnterDynamicArea), у клиента отображается без кнопок.
//
// Поэтому здесь: зона входа только даёт возможность проверить
// близость, а сам диалог показывается через Maximka_ShowMenu() —
// её нужно вызывать из общего обработчика кнопки взаимодействия в
// black-russia.pwn (добавлено рядом с проверкой Михалыча) — см.
// IsPlayerNearMaximka(playerid) ниже.
//=====================================================================

#define MAXIMKA_DIALOG_MENU    (556002)
#define MAXIMKA_DIALOG_INFO    (556003)

#define MAXIMKA_SKIN            (6881)

#define MAXIMKA_QUEST_SKIN       (89)      // ID СКИНА (model_id), который нужно сдать (не обычный item_id!)
#define MAXIMKA_MONEY            (30000000)
#define MAXIMKA_BC               (10000)

new sphere_maximka_guide = -1;
new Float: maximka_coord[6] = {1794.309814, 2538.657958, 14.730228, 204.727081, 0.0, 0.0}; // x, y, z, angle, virtualworld, interior

public OnGameModeInit()
{
    CreateActorEx
    (
        "{FFA500}Максимка",
        "Подойдите для {FFFF00}взаимодействия",
        MAXIMKA_SKIN,
        maximka_coord[0], maximka_coord[1], maximka_coord[2], maximka_coord[3],
        floatround(maximka_coord[4]), floatround(maximka_coord[5])
    );
    sphere_maximka_guide = CreateDynamicSphere(maximka_coord[0], maximka_coord[1], maximka_coord[2], 2.0, floatround(maximka_coord[4]), floatround(maximka_coord[5]));

    #if defined maximka_OnGameModeInit
        return maximka_OnGameModeInit();
    #else
        return 1;
    #endif
}
    #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit maximka_OnGameModeInit
#if defined maximka_OnGameModeInit
    forward maximka_OnGameModeInit();
#endif

//=====================================================================
// Проверка близости к Максимке — по образцу IsPlayerNearMikhail().
// Вызывается из общего обработчика кнопки взаимодействия в
// black-russia.pwn.
//=====================================================================
stock IsPlayerNearMaximka(playerid)
{
    if(sphere_maximka_guide != -1 && IsPlayerInDynamicArea(playerid, sphere_maximka_guide))
        return 1;
    return 0;
}

//=====================================================================
// Показ меню Максимки — реальная точка входа в событие. Вызывайте её
// из обработчика кнопки взаимодействия (action == 18), а не из
// OnPlayerEnterDynamicArea.
//=====================================================================
stock Maximka_ShowMenu(playerid)
{
    Dialog
    (
        playerid, MAXIMKA_DIALOG_MENU, DIALOG_STYLE_LIST,
        "Максимка",
        "Сдать скин (получить награду)\n"\
        "Что известно?\n"\
        "Закрыть",
        "Выбрать", "Закрыть"
    );
    return 1;
}

//=====================================================================
// Логика сдачи скина Максимке (вынесена в отдельную функцию, чтобы
// вызывать её и из диалога, и из команды /maximkagui).
//=====================================================================
stock Maximka_TryClaimQuest(playerid)
{
    new slot = Inventory11_FindSkinSlotByModel(playerid, MAXIMKA_QUEST_SKIN);

    if(slot < 0)
    {
        SendClientMessage(playerid, -1, "{FFA500}Максимка:{FFFFFF} У тебя нет нужного скина. Принеси его мне, и я отблагодарю тебя!");
        return 0;
    }

    if(!Inventory11_DeleteSlotFromDatabase(playerid, slot))
    {
        SendClientMessage(playerid, -1, "{FF0000}Максимка:{FFFFFF} Не удалось забрать скин, попробуй ещё раз чуть позже.");
        return 0;
    }

    GivePlayerMoneyEx(playerid, MAXIMKA_MONEY, "Максимка", true, true);
    AddPlayerData(playerid, P_DONATE_RUB, +, MAXIMKA_BC);
    UpdatePlayerDatabaseInt(playerid, "rub", GetPlayerData(playerid, P_DONATE_RUB));

    new msg[160];
    format(msg, sizeof msg, "{FFA500}Максимка:{FFFFFF} Спасибо! Держи награду: {FFFF00}%d$ {FFFFFF}и {FFFF00}%d BC{FFFFFF}!", MAXIMKA_MONEY, MAXIMKA_BC);
    SendClientMessage(playerid, -1, msg);

    printf("[MAXIMKA] Player %d turned in skin %d, reward: %d$ / %d BC", playerid, MAXIMKA_QUEST_SKIN, MAXIMKA_MONEY, MAXIMKA_BC);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == MAXIMKA_DIALOG_MENU)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0: // Сдать скин
                {
                    Maximka_TryClaimQuest(playerid);
                }
                case 1: // Что известно?
                {
                    Dialog
                    (
                        playerid, MAXIMKA_DIALOG_INFO, DIALOG_STYLE_MSGBOX,
                        "Что известно",
                        "Здесь можно написать подсказку или описание \n"\
                        "текущего этапа задания Максимки.",
                        "Назад", "Закрыть"
                    );
                }
                case 2: // Закрыть
                {
                }
            }
        }
        #if defined maximka_OnDialogResponse
            return maximka_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
        #else
            return 1;
        #endif
    }

    if(dialogid == MAXIMKA_DIALOG_INFO)
    {
        if(response)
        {
            Maximka_ShowMenu(playerid);
        }
        #if defined maximka_OnDialogResponse
            return maximka_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
        #else
            return 1;
        #endif
    }

    #if defined maximka_OnDialogResponse
        return maximka_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
    #if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse maximka_OnDialogResponse
#if defined maximka_OnDialogResponse
    forward maximka_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

//=====================================================================
// Поиск слота скина в инвентаре по номеру модели (для скинов item_id
// в таблице `inventory` всегда 134, а конкретный номер скина лежит
// в поле `model_id` — см. Inventory11_AddSkinToInventory /
// Inventory11_SaveDonatSkinToDatabase в black-russia.pwn).
//=====================================================================
stock Inventory11_FindSkinSlotByModel(playerid, modelid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return -1;
    }

    new query[196];
    mysql_format(mysql, query, sizeof(query), "SELECT slot FROM inventory WHERE account_id = %d AND item_id = 134 AND model_id = %d ORDER BY slot ASC LIMIT 1", account_id, modelid);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[MAXIMKA][ERROR] FindSkinSlotByModel failed errno=%d account_id=%d model=%d query=%s", mysql_errno(), account_id, modelid, query);
        cache_delete(result);
        return -1;
    }

    if(cache_num_rows() <= 0)
    {
        cache_delete(result);
        return -1;
    }

    new slot = cache_get_field_content_int(0, "slot");
    cache_delete(result);
    return slot;
}

//=====================================================================
// Тестовая команда — сразу показывает то же меню, что откроется у
// живого NPC по кнопке взаимодействия. Полезно, чтобы проверить
// событие, не подходя к актёру.
//=====================================================================
CMD:maximkagui(playerid, params[])
{
    #pragma unused params
    Maximka_ShowMenu(playerid);
    return 1;
}

//=====================================================================
// Конец модуля Максимки
//=====================================================================
