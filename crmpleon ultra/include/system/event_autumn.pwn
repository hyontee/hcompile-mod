//=====================================================================
// Осенний ивент — "Золотой след" (Проводник осеннего события)
// Модуль подключается отдельным #include, чтобы не трогать основной
// файл (используется стандартный для этого мода ALS-паттерн колбэков,
// как и в include/system/event_new_year.pwn).
//=====================================================================

#define AUTUMN_GUIDE_DIALOG_INTRO   (555001)
#define AUTUMN_GUIDE_DIALOG_MENU    (555002)
#define AUTUMN_GUIDE_DIALOG_INFO    (555003)

#define AUTUMN_REWARD_MONEY         (30000000)
#define AUTUMN_REWARD_DONATE        (15000)

new sphere_autumn_guide = -1;
new sphere_autumn_treasure = -1;
new Float: autumn_guide_coord[4]    = {828.557373, 793.312927, 13.155678, 255.083129}; // NPC "Проводник осеннего события"
new Float: autumn_treasure_coord[4] = {417.279479, 1070.428710, 12.249264, 3.220652};  // Место, куда нужно приехать за наградой

public OnGameModeInit()
{
    CreateActorEx
    (
        "{FFA500}Проводник осеннего события",
        "Доступно до 30.11.2026\nПодойдите, чтобы начать историю",
        275, // Park Ranger
        autumn_guide_coord[0], autumn_guide_coord[1], autumn_guide_coord[2], autumn_guide_coord[3],
        0, 0
    );
    sphere_autumn_guide = CreateDynamicSphere(autumn_guide_coord[0], autumn_guide_coord[1], autumn_guide_coord[2], 2.0);
    sphere_autumn_treasure = CreateDynamicSphere(autumn_treasure_coord[0], autumn_treasure_coord[1], autumn_treasure_coord[2], 3.0);

    #if defined autumn_OnGameModeInit
        return autumn_OnGameModeInit();
    #else
        return 1;
    #endif
}
    #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit autumn_OnGameModeInit
#if defined autumn_OnGameModeInit
    forward autumn_OnGameModeInit();
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == sphere_autumn_guide)
    {
        if(GetPVarInt(playerid, "AutumnGuideStarted") == 0)
        {
            Dialog
            (
                playerid, AUTUMN_GUIDE_DIALOG_INTRO, DIALOG_STYLE_MSGBOX,
                "Проводник 'Золотого следа'",
                "Старый тракт редко бывает тихим, но после последней грозы \n"\
                "там произошло что-то странное. Связь пропала, на дороге \n"\
                "остались свежие следы, а несколько человек слышали машину \n"\
                "глубокой ночью. Я не знаю, что именно случилось. Лесник \n"\
                "Григорий был рядом одним из первых. Если хотите узнать, \n"\
                "что произошло — я покажу вам, с чего начать поиски.",
                "Далее", "Позже"
            );
        }
        else
        {
            Dialog
            (
                playerid, AUTUMN_GUIDE_DIALOG_MENU, DIALOG_STYLE_LIST,
                "Проводник 'Золотого следа'",
                "Начать поиск\n"\
                "Что известно?\n"\
                "Позже",
                "Выбрать", "Закрыть"
            );
        }
    }
    else if(areaid == sphere_autumn_treasure)
    {
        if(GetPVarInt(playerid, "AutumnGuideStarted") == 1 && GetPVarInt(playerid, "AutumnGuideCompleted") == 0)
        {
            SetPVarInt(playerid, "AutumnGuideCompleted", 1);

            GivePlayerMoneyEx(playerid, AUTUMN_REWARD_MONEY, "Ивент - Золотой след", true, true);
            GivePlayerDonate(playerid, AUTUMN_REWARD_DONATE, "Ивент - Золотой след", true);

            DisablePlayerCheckpoint(playerid);

            new msg[144];
            format(msg, sizeof msg, "{FFA500}Проводник:{FFFFFF} Вы нашли то, что искали! Награда: {00FF00}%d руб.{FFFFFF} и {00FF00}%d доната{FFFFFF}.", AUTUMN_REWARD_MONEY, AUTUMN_REWARD_DONATE);
            SendClientMessage(playerid, -1, msg);
        }
    }

    #if defined autumn_OnPlayerEnterDynamicArea
        return autumn_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
    #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea autumn_OnPlayerEnterDynamicArea
#if defined autumn_OnPlayerEnterDynamicArea
    forward autumn_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == AUTUMN_GUIDE_DIALOG_INTRO)
    {
        if(response)
        {
            Dialog
            (
                playerid, AUTUMN_GUIDE_DIALOG_MENU, DIALOG_STYLE_LIST,
                "Проводник 'Золотого следа'",
                "Начать поиск\n"\
                "Что известно?\n"\
                "Позже",
                "Выбрать", "Закрыть"
            );
        }
        #if defined autumn_OnDialogResponse
            return autumn_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
        #else
            return 1;
        #endif
    }

    if(dialogid == AUTUMN_GUIDE_DIALOG_MENU)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0: // Начать поиск
                {
                    if(GetPVarInt(playerid, "AutumnGuideCompleted") == 1)
                    {
                        SendClientMessage(playerid, -1, "{FFA500}Проводник:{FFFFFF} Вы уже нашли клад в этом событии.");
                    }
                    else
                    {
                        SetPVarInt(playerid, "AutumnGuideStarted", 1);
                        EnablePlayerGPS(playerid, 55, autumn_treasure_coord[0], autumn_treasure_coord[1], autumn_treasure_coord[2], "{FFA500}Проводник:{FFFFFF} Место отмечено на карте! Отправляйтесь туда.");
                    }
                }
                case 1: // Что известно?
                {
                    Dialog
                    (
                        playerid, AUTUMN_GUIDE_DIALOG_INFO, DIALOG_STYLE_MSGBOX,
                        "Что известно",
                        "Пропала связь на старом тракте после грозы. \n"\
                        "На дороге найдены свежие следы, ночью слышали шум \n"\
                        "машины. Лесник Григорий был одним из первых, кто \n"\
                        "оказался на месте.",
                        "Назад", "Закрыть"
                    );
                }
                case 2: // Позже
                {
                }
            }
        }
        #if defined autumn_OnDialogResponse
            return autumn_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
        #else
            return 1;
        #endif
    }

    if(dialogid == AUTUMN_GUIDE_DIALOG_INFO)
    {
        if(response)
        {
            Dialog
            (
                playerid, AUTUMN_GUIDE_DIALOG_MENU, DIALOG_STYLE_LIST,
                "Проводник 'Золотого следа'",
                "Начать поиск\n"\
                "Что известно?\n"\
                "Позже",
                "Выбрать", "Закрыть"
            );
        }
        #if defined autumn_OnDialogResponse
            return autumn_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
        #else
            return 1;
        #endif
    }

    #if defined autumn_OnDialogResponse
        return autumn_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
    #if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse autumn_OnDialogResponse
#if defined autumn_OnDialogResponse
    forward autumn_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

//=====================================================================
// Конец модуля осеннего ивента
//=====================================================================
