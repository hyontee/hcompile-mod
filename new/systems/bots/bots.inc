#if defined _USUPOV_BOTS_INC
    #endinput
#endif
#define _USUPOV_BOTS_INC

#define BOT_DEFAULT_PASSWORD "111111"
#define BOT_NPC_SCRIPT "bot_idle"
#define BOT_TP_RADIUS (2.0)
#define BOT_RUN_TIMER_MS (700)
#define BOT_RUN_STEP_MIN (0.08)
#define BOT_RUN_STEP_MAX (0.22)
#define BOT_VEH_SPEED_MIN (0.35)
#define BOT_VEH_SPEED_MAX (0.75)
#define BOT_VEHICLE_RANDOM_CHANCE (20)

new const BOT_NAMES[][MAX_PLAYER_NAME] =
{
    "Jirok16",
    "Dolbaeba_Pudorasik",
    "Kirill_Vovk",
    "Shram_xyilo"
};

new const Float:BOT_SPAWNS[][4] =
{
    {1467.771484, -1734.948242, 13.546875, 0.0},
    {2740.712158, -2441.565185, 21.774286, 269.248382},
    {-2429.236083, 203.175277, 26.096101, 176.712112},
    {1801.694091, 2523.137695, 14.602633, 109.981643},
    {-2667.526611, 2006.567016, 11.197804, 176.496978}
};

new const BOT_RANDOM_SKINS[] =
{
   122, 12293, 78, 11947
};

new const BOT_VEHICLE_MODELS[] =
{
    400, 401, 404, 405, 410, 421, 426, 436, 445, 466, 475,
    489, 490, 495, 496, 505, 507, 516, 526, 529, 533, 540,
    542, 543, 550, 558, 559, 560, 562, 579, 585, 587, 589,
    603, 604
};

CMD:bot(playerid, params[])
{
    #pragma unused params

    if(!Bot_IsAdminOperator(playerid))
        return 1;

    new list[1024];
    Bot_BuildDialogList(list, sizeof(list));
    if(!list[0])
        return SendClientMessage(playerid, Color_Red, "Bot list is empty.");

    ShowPlayerDialog(playerid, 16582, DIALOG_STYLE_LIST, "Bot Manager", list, "Connect", "Cancel");
    return 1;
}

CMD:bottp(playerid, params[])
{
    #pragma unused params

    if(!Bot_IsAdminOperator(playerid))
        return 1;

    new count = Bot_TeleportAllToPlayer(playerid);
    if(count <= 0)
        return SendClientMessage(playerid, Color_Red, "No connected bots found.");

    new msg[96];
    format(msg, sizeof(msg), "Bots teleported: %d", count);
    SendClientMessage(playerid, Color_White, msg);
    return 1;
}

CMD:botrun(playerid, params[])
{
    if(!Bot_IsAdminOperator(playerid))
        return 1;

    new runState = -1;
    if(!isnull(params))
    {
        if(!strcmp(params, "on", true) || !strcmp(params, "1", true)) runState = 1;
        else if(!strcmp(params, "off", true) || !strcmp(params, "0", true)) runState = 0;
        else return SendClientMessage(playerid, Color_Grey, "Usage: /botrun [on/off]");
    }

    if(runState == -1) runState = g_bot_run_active ? 0 : 1;

    if(runState)
        return Bot_RunStart(playerid);

    return Bot_RunStop(playerid, true);
}

CMD:msgbot(playerid, params[])
{
    if(!Bot_IsAdminOperator(playerid))
        return 1;

    if(isnull(params))
        return SendClientMessage(playerid, Color_Grey, "Использование: /msgbot [сообщение]"), 1;

    new text[96];
    format(text, sizeof(text), "%s", params);
    if(strlen(text) > 90) text[90] = '\0';

    new sent = Bot_SendChatToAll(text);
    if(sent <= 0)
        return SendClientMessage(playerid, Color_Red, "Нет подключенных ботов."), 1;

    new msg[96];
    format(msg, sizeof(msg), "Сообщение отправлено ботам: %d", sent);
    SendClientMessage(playerid, Color_White, msg);
    return 1;
}