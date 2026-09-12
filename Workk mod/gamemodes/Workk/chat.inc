#if defined _workk_chat_included
    #endinput
#endif
#define _workk_chat_included

#include <a_samp>

#define CHAT_RANGE_LOCAL   (20.0)
#define CHAT_RANGE_WHISPER (3.0)
#define CHAT_RANGE_SHOUT   (37.0)

stock SendMessageInRange(playerid, const text[], color, Float:range)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && IsPlayerLoggedIn(i) && IsPlayerInRangeOfPoint(i, range, x, y, z))
        {
            SendClientMessage(i, color, text);
        }
    }
    return 1;
}

CMD:me(playerid, params[])
{
    if(IsPlayerMuted(playerid)) return SendClientMessage(playerid, COLOR_ADMIN, "Вы не можете использовать это: вы в муте.");
    if(!strlen(params)) return SendClientMessage(playerid, COLOR_YELLOW, "Используйте: /me [текст]");

    new text[144];
    format(text, sizeof(text), "* %s %s", GetPlayerNameEx(playerid), params);
    SendMessageInRange(playerid, text, 0xC2A2DAFF, CHAT_RANGE_LOCAL);
    return 1;
}

CMD:do(playerid, params[])
{
    if(IsPlayerMuted(playerid)) return SendClientMessage(playerid, COLOR_ADMIN, "Вы не можете использовать это: вы в муте.");
    if(!strlen(params)) return SendClientMessage(playerid, COLOR_YELLOW, "Используйте: /do [текст]");

    new text[144];
    format(text, sizeof(text), "* %s (( %s ))", params, GetPlayerNameEx(playerid));
    SendMessageInRange(playerid, text, 0xDD90FFFF, CHAT_RANGE_LOCAL);
    return 1;
}

CMD:try(playerid, params[])
{
    if(IsPlayerMuted(playerid)) return SendClientMessage(playerid, COLOR_ADMIN, "Вы не можете использовать это: вы в муте.");
    if(!strlen(params)) return SendClientMessage(playerid, COLOR_YELLOW, "Используйте: /try [текст]");

    new text[160];
    format(text, sizeof(text), "* %s пытается: %s - %s", GetPlayerNameEx(playerid), params, !random(3) ? "{66CC00}Удачно" : "{FF6600}Неудачно");
    SendMessageInRange(playerid, text, 0xDD90FFFF, CHAT_RANGE_LOCAL);
    return 1;
}

CMD:w(playerid, params[])
{
    if(IsPlayerMuted(playerid)) return SendClientMessage(playerid, COLOR_ADMIN, "Вы не можете использовать это: вы в муте.");
    if(!strlen(params)) return SendClientMessage(playerid, COLOR_YELLOW, "Используйте: /w [текст]");

    new text[144];
    format(text, sizeof(text), "%s шепчет: %s", GetPlayerNameEx(playerid), params);
    SendMessageInRange(playerid, text, 0xACCE90FF, CHAT_RANGE_WHISPER);
    return 1;
}

CMD:s(playerid, params[])
{
    if(IsPlayerMuted(playerid)) return SendClientMessage(playerid, COLOR_ADMIN, "Вы не можете использовать это: вы в муте.");
    if(!strlen(params)) return SendClientMessage(playerid, COLOR_YELLOW, "Используйте: /s [текст]");

    new text[144];
    format(text, sizeof(text), "%s [%d] кричит: %s", GetPlayerNameEx(playerid), playerid, params);
    SendMessageInRange(playerid, text, COLOR_WHITE, CHAT_RANGE_SHOUT);
    return 1;
}

CMD:n(playerid, params[])
{
    if(IsPlayerMuted(playerid)) return SendClientMessage(playerid, COLOR_ADMIN, "Вы не можете использовать это: вы в муте.");
    if(!strlen(params)) return SendClientMessage(playerid, COLOR_YELLOW, "Используйте: /n [нон-рп сообщение]");

    new text[160];
    format(text, sizeof(text), "(( %s [%d]: %s ))", GetPlayerNameEx(playerid), playerid, params);
    SendMessageInRange(playerid, text, 0xCCCC99FF, CHAT_RANGE_LOCAL);
    return 1;
}

CMD:b(playerid, params[])
{
    if(IsPlayerMuted(playerid)) return SendClientMessage(playerid, COLOR_ADMIN, "Вы не можете использовать это: вы в муте.");
    if(!strlen(params)) return SendClientMessage(playerid, COLOR_YELLOW, "Используйте: /b [текст]");

    new text[160];
    format(text, sizeof(text), "(( OOC %s [%d]: %s ))", GetPlayerNameEx(playerid), playerid, params);
    SendClientMessageToAll(0x9999FFFF, text);
    return 1;
}

CMD:hi(playerid, params[])
{
    #pragma unused params
    new text[100];
    format(text, sizeof(text), "* %s машет рукой в знак приветствия", GetPlayerNameEx(playerid));
    SendMessageInRange(playerid, text, 0xC2A2DAFF, CHAT_RANGE_LOCAL);
    return 1;
}

CMD:id(playerid, params[])
{
    if(!strlen(params))
    {
        new text[64];
        format(text, sizeof(text), "Ваш ID: %d", playerid);
        return SendClientMessage(playerid, COLOR_YELLOW, text);
    }

    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_YELLOW, "Используйте: /id [ник]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "Такого игрока нет в игре.");

    new text[80];
    format(text, sizeof(text), "%s имеет ID: %d", GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, COLOR_YELLOW, text);
    return 1;
}
