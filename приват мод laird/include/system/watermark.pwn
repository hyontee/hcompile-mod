// ==================================================================================
// watermark.pwn — надпись "RUSSIA CRMP" в углу экрана (обычный TextDraw)
// Подключение: #include "watermark.pwn" в главном файле геймода, в любом месте
// вместе с остальными #include.
// ==================================================================================

new Text:WebTextDraw[2];
new Text:welcomeText;

public OnGameModeInit()
{
    WebTextDraw[1] = TextDrawCreate(570.0, 110.0, "RUSSIA");
    TextDrawLetterSize(WebTextDraw[1], 0.401000, 1.387999);
    TextDrawAlignment(WebTextDraw[1], 2);
    TextDrawColor(WebTextDraw[1], -1);
    TextDrawSetShadow(WebTextDraw[1], 1);
    TextDrawSetOutline(WebTextDraw[1], 0);
    TextDrawBackgroundColor(WebTextDraw[1], 51);
    TextDrawFont(WebTextDraw[1], 2);
    TextDrawSetProportional(WebTextDraw[1], 1);

    WebTextDraw[0] = TextDrawCreate(580.5, 128.0, "CRMP");
    TextDrawLetterSize(WebTextDraw[0], 0.295000, 0.966400);
    TextDrawAlignment(WebTextDraw[0], 2);
    TextDrawColor(WebTextDraw[0], -5963521);
    TextDrawUseBox(WebTextDraw[0], true);
    TextDrawBoxColor(WebTextDraw[0], 0);
    TextDrawSetShadow(WebTextDraw[0], 0);
    TextDrawSetOutline(WebTextDraw[0], 0);
    TextDrawBackgroundColor(WebTextDraw[0], 51);
    TextDrawFont(WebTextDraw[0], 2);
    TextDrawSetProportional(WebTextDraw[0], 1);

    welcomeText = TextDrawCreate(0.0, 0.0, " ");

    #if defined wm_OnGameModeInit
        return wm_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit wm_OnGameModeInit
#if defined wm_OnGameModeInit
    forward wm_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
    TextDrawShowForPlayer(playerid, WebTextDraw[0]);
    TextDrawShowForPlayer(playerid, WebTextDraw[1]);

    #if defined wm_OnPlayerConnect
        return wm_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect wm_OnPlayerConnect
#if defined wm_OnPlayerConnect
    forward wm_OnPlayerConnect(playerid);
#endif
