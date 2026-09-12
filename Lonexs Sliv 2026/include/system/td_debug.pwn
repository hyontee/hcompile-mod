#if defined _td_debug_included
    #endinput
#endif
#define _td_debug_included

new PlayerText:g_TdDebug[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:g_TdTextureDebug[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:g_TdTextureLabel[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:g_TdTextureGrid[MAX_PLAYERS][5] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...};
new PlayerText:g_TdTextureGridLabel[MAX_PLAYERS][5] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...};

CMD:tdtest(playerid, params[])
{
    #pragma unused params

    if(GetPlayerAdminEx(playerid) < 1)
        return SendClientMessage(playerid, 0xFF6347FF, "This command is available to administrators only.");

    if(g_TdDebug[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, g_TdDebug[playerid]);
        g_TdDebug[playerid] = PlayerText:INVALID_TEXT_DRAW;
        return SendClientMessage(playerid, 0xFFFFFFFF, "TD test hidden.");
    }

    g_TdDebug[playerid] = CreatePlayerTextDraw(playerid, 320.0, 210.0, "TEXTDRAW TEST: OK");
    PlayerTextDrawAlignment(playerid, g_TdDebug[playerid], 2);
    PlayerTextDrawLetterSize(playerid, g_TdDebug[playerid], 0.42, 1.8);
    PlayerTextDrawColor(playerid, g_TdDebug[playerid], 0xFFFFFFFF);
    PlayerTextDrawUseBox(playerid, g_TdDebug[playerid], 1);
    PlayerTextDrawBoxColor(playerid, g_TdDebug[playerid], 0x202020CC);
    PlayerTextDrawTextSize(playerid, g_TdDebug[playerid], 0.0, 230.0);
    PlayerTextDrawFont(playerid, g_TdDebug[playerid], 1);
    PlayerTextDrawSetOutline(playerid, g_TdDebug[playerid], 1);
    PlayerTextDrawShow(playerid, g_TdDebug[playerid]);

        return SendClientMessage(playerid, 0x66FF66FF, "TD test shown. Enter /tdtest again to hide it.");
}

CMD:tdtex(playerid, params[])
{
        #pragma unused params

        if(GetPlayerAdminEx(playerid) < 1)
                return SendClientMessage(playerid, 0xFF6347FF, "This command is available to administrators only.");

        if(g_TdTextureDebug[playerid] != PlayerText:INVALID_TEXT_DRAW)
        {
                PlayerTextDrawDestroy(playerid, g_TdTextureDebug[playerid]);
                PlayerTextDrawDestroy(playerid, g_TdTextureLabel[playerid]);
                g_TdTextureDebug[playerid] = PlayerText:INVALID_TEXT_DRAW;
                g_TdTextureLabel[playerid] = PlayerText:INVALID_TEXT_DRAW;
                return SendClientMessage(playerid, 0xFFFFFFFF, "Texture TD test hidden.");
        }

        g_TdTextureLabel[playerid] = CreatePlayerTextDraw(playerid, 320.0, 165.0, "Texture test: br_tex_gui:bracstext");
        PlayerTextDrawAlignment(playerid, g_TdTextureLabel[playerid], 2);
        PlayerTextDrawLetterSize(playerid, g_TdTextureLabel[playerid], 0.28, 1.2);
        PlayerTextDrawColor(playerid, g_TdTextureLabel[playerid], 0xFFFFFFFF);
        PlayerTextDrawFont(playerid, g_TdTextureLabel[playerid], 1);
        PlayerTextDrawSetOutline(playerid, g_TdTextureLabel[playerid], 1);
        PlayerTextDrawShow(playerid, g_TdTextureLabel[playerid]);

        g_TdTextureDebug[playerid] = CreatePlayerTextDraw(playerid, 250.0, 185.0, "br_tex_gui:bracstext");
        PlayerTextDrawFont(playerid, g_TdTextureDebug[playerid], 4);
        PlayerTextDrawColor(playerid, g_TdTextureDebug[playerid], 0xFFFFFFFF);
        PlayerTextDrawTextSize(playerid, g_TdTextureDebug[playerid], 140.0, 70.0);
        PlayerTextDrawShow(playerid, g_TdTextureDebug[playerid]);

        return SendClientMessage(playerid, 0x66FF66FF, "Texture TD test shown. Enter /tdtex again to hide it.");
}

CMD:tdtexall(playerid, params[])
{
        #pragma unused params

        if(GetPlayerAdminEx(playerid) < 1)
                return SendClientMessage(playerid, 0xFF6347FF, "This command is available to administrators only.");

        if(g_TdTextureGrid[playerid][0] != PlayerText:INVALID_TEXT_DRAW)
        {
                for(new i = 0; i < 5; i++)
                {
                        PlayerTextDrawDestroy(playerid, g_TdTextureGrid[playerid][i]);
                        PlayerTextDrawDestroy(playerid, g_TdTextureGridLabel[playerid][i]);
                        g_TdTextureGrid[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
                        g_TdTextureGridLabel[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
                }

                return SendClientMessage(playerid, 0xFFFFFFFF, "Texture grid test hidden.");
        }

        static const texture_names[5][] =
        {
                "br_tex_gui:bracstext",
                "br_tex_gui:brcontosnova",
                "br_tex_gui:brbj",
                "br_tex_gui:brrainleft",
                "br_tex_gui:braucubuy"
        };

        for(new i = 0; i < 5; i++)
        {
                new Float:x = 145.0 + float(i * 72);

                g_TdTextureGridLabel[playerid][i] = CreatePlayerTextDraw(playerid, x + 30.0, 150.0, texture_names[i]);
                PlayerTextDrawAlignment(playerid, g_TdTextureGridLabel[playerid][i], 2);
                PlayerTextDrawLetterSize(playerid, g_TdTextureGridLabel[playerid][i], 0.16, 0.8);
                PlayerTextDrawColor(playerid, g_TdTextureGridLabel[playerid][i], 0xFFFFFFFF);
                PlayerTextDrawFont(playerid, g_TdTextureGridLabel[playerid][i], 1);
                PlayerTextDrawSetOutline(playerid, g_TdTextureGridLabel[playerid][i], 1);
                PlayerTextDrawShow(playerid, g_TdTextureGridLabel[playerid][i]);

                g_TdTextureGrid[playerid][i] = CreatePlayerTextDraw(playerid, x, 165.0, texture_names[i]);
                PlayerTextDrawFont(playerid, g_TdTextureGrid[playerid][i], 4);
                PlayerTextDrawColor(playerid, g_TdTextureGrid[playerid][i], 0xFFFFFFFF);
                PlayerTextDrawTextSize(playerid, g_TdTextureGrid[playerid][i], 60.0, 45.0);
                PlayerTextDrawShow(playerid, g_TdTextureGrid[playerid][i]);
        }

        return SendClientMessage(playerid, 0x66FF66FF, "Texture grid test shown. Enter /tdtexall again to hide it.");
}
