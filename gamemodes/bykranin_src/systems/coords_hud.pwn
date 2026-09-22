//>> Файл: bykranin_src/systems/coords_hud.pwn
//>> Подключается из bykranin.pwn перед core/callbacks. Хуки: CoordsHud_OnConnect (OnPlayerConnect, callbacks_01.inc),
//>> CoordsHud_Update (OnPlayerTimer, on_player_timer.inc). Команда: /coords
#if defined _COORDS_HUD_INC
    #endinput
#endif
#define _COORDS_HUD_INC

/*
    Координаты внизу экрана — обычный TextDraw (не через пакетный GUI, чтобы
    работало гарантированно у всех, независимо от кастомного клиента).
    Обновляется раз в секунду из OnPlayerTimer, не на каждый OnPlayerUpdate (он вызывается
    десятки раз в секунду — спамить TextDrawSetString с такой частотой не надо).
*/

new PlayerText:CoordsHudTD[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new CoordsHudLastUpdate[MAX_PLAYERS];

stock CoordsHud_OnConnect(playerid)
{
    CoordsHudTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
    CoordsHudLastUpdate[playerid] = 0;
    return 1;
}

stock CoordsHud_Create(playerid)
{
    if(CoordsHudTD[playerid] != PlayerText:INVALID_TEXT_DRAW)
        return 0;

    CoordsHudTD[playerid] = CreatePlayerTextDraw(playerid, 320.0, 430.0, "X: 0.0  Y: 0.0  Z: 0.0");
    PlayerTextDrawAlignment(playerid, CoordsHudTD[playerid], 2); // по центру
    PlayerTextDrawFont(playerid, CoordsHudTD[playerid], 2);
    PlayerTextDrawLetterSize(playerid, CoordsHudTD[playerid], 0.22, 1.0);
    PlayerTextDrawColor(playerid, CoordsHudTD[playerid], 0xFFFFFFAA);
    PlayerTextDrawSetShadow(playerid, CoordsHudTD[playerid], 0);
    PlayerTextDrawSetOutline(playerid, CoordsHudTD[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, CoordsHudTD[playerid], 0x000000AA);
    PlayerTextDrawSetProportional(playerid, CoordsHudTD[playerid], 1);
    PlayerTextDrawShow(playerid, CoordsHudTD[playerid]);
    return 1;
}

stock CoordsHud_Destroy(playerid)
{
    if(CoordsHudTD[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, CoordsHudTD[playerid]);
        CoordsHudTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

stock CoordsHud_Update(playerid)
{
    if(CoordsHudTD[playerid] == PlayerText:INVALID_TEXT_DRAW)
        return 0;

    new now = GetTickCount();
    if(now - CoordsHudLastUpdate[playerid] < 900) // ~раз в секунду (вызывается из OnPlayerTimer)
        return 0;
    CoordsHudLastUpdate[playerid] = now;

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new text[64];
    format(text, sizeof text, "X: %.1f  Y: %.1f  Z: %.1f", x, y, z);
    PlayerTextDrawSetString(playerid, CoordsHudTD[playerid], text);
    return 1;
}

CMD:coords(playerid, params[])
{
    if(CoordsHudTD[playerid] == PlayerText:INVALID_TEXT_DRAW)
    {
        CoordsHud_Create(playerid);
        SendClientMessage(playerid, -1, ""SC"Координаты внизу экрана {33FF55}включены{FFFFFF} (снова /coords — выключить)");
    }
    else
    {
        CoordsHud_Destroy(playerid);
        SendClientMessage(playerid, -1, ""SC"Координаты внизу экрана {FF5533}выключены{FFFFFF}");
    }
    return 1;
}
// Алиас "coord" не добавляю — такая команда уже есть в проекте (разовая
// печать координат в чат), только на неё не похожа. Наша — постоянный
// текст внизу экрана, включается/выключается через /coords.
