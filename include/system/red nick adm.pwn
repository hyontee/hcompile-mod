замените у себя в коде 

public OnPlayerText на 

public OnPlayerText(playerid, text[])
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    new message[144];

    if(!strcmp(text, ")", true))
    {
        format(message, sizeof(message), "* %s улыбается", name);
    }
    else if(!strcmp(text, "))", true))
    {
        format(message, sizeof(message), "* %s смеется", name);
    }
    else if(!strcmp(text, "(", true))
    {
        format(message, sizeof(message), "* %s грустит", name);
    }
    else if(!strcmp(text, "((", true))
    {
        format(message, sizeof(message), "* %s плачет", name);
    }
    else
    {
        SendMessageInChat(playerid, text);
        return 0;
    }

    new
        Float:px,
        Float:py,
        Float:pz,
        pvw = GetPlayerVirtualWorld(playerid),
        pint = GetPlayerInterior(playerid);

    GetPlayerPos(playerid, px, py, pz);

    for(new i = 0; i < GM_MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(GetPlayerVirtualWorld(i) != pvw) continue;
        if(GetPlayerInterior(i) != pint) continue;
        if(GetPlayerDistanceFromPoint(i, px, py, pz) > 30.0) continue;

        SendClientMessage(i, -1, message);
    }

    SetPlayerChatBubble(playerid, message, 0x00CCFFFF, 30.0, 8000);
    return 0;
}

и в коде поменяйте у себя SendMessageInChat на

stock SendMessageInChat(playerid, const text[])
{
    new message[256];

    if(GetPlayerAdminEx(playerid))
    {
        format(message, sizeof(message),
            "- %s {FF0000}(%s)[%d]",
            text,
            GetPlayerNameEx(playerid),
            playerid
        );
    }
    else
    {
        format(message, sizeof(message),
            "- %s (%s)[%d]",
            text,
            GetPlayerNameEx(playerid),
            playerid
        );
    }

    new
        Float:px,
        Float:py,
        Float:pz,
        pvw = GetPlayerVirtualWorld(playerid),
        pint = GetPlayerInterior(playerid);

    GetPlayerPos(playerid, px, py, pz);

    for(new i = 0; i < GM_MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(GetPlayerVirtualWorld(i) != pvw) continue;
        if(GetPlayerInterior(i) != pint) continue;
        if(GetPlayerDistanceFromPoint(i, px, py, pz) > 30.0) continue;

        SendClientMessage(i, -1, message);
    }

    new bubble_text[144];

    SetPlayerChatBubble(playerid, bubble_text, 0x00CCFFFF, 30.0, 8000);
    return 1;
}