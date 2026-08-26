#include <a_samp>

#define COLOR_WHITE 0xFFFFFFFF // Цвет текста (белый)
#define FONT_HEIGHT 24          // Высота шрифта
#define TEXT_SIZE_X 0.8f        // Ширина текста относительно окна клиента
#define TEXT_SIZE_Y 0.2f        // Высота текста относительно окна клиента
#define FADE_IN_TIME 1000       // Время появления (мс)
#define FADE_OUT_TIME 1000      // Время исчезновения (мс)

new gTextDrawWelcome[MAX_PLAYERS];

public OnGameModeInit()
{
    return 1;
}

public OnPlayerConnect(playerid)
{
    CreateWelcomeTextDraw(playerid);
    ShowWelcomeTextDraw(playerid);    
    return 1;
}

CreateWelcomeTextDraw(playerid)
{
    new Float:x = GetPVarFloat(playerid,"ScreenWidth") / 2.0 - TEXT_SIZE_X * GetPVarFloat(playerid,"ScreenWidth") / 2.0,
        Float:y = GetPVarFloat(playerid,"ScreenHeight") / 2.0 - TEXT_SIZE_Y * GetPVarFloat(playerid,"ScreenHeight") / 2.0;
        
    gTextDrawWelcome[playerid] = TextDrawCreate(x,y,"Добро пожаловать!");
    if(gTextDrawWelcome[playerid])
    {
        TextDrawFont(gTextDrawWelcome[playerid],FONT_HEIGHT);
        TextDrawLetterSize(gTextDrawWelcome[playerid],TEXT_SIZE_X,TEXT_SIZE_Y);
        TextDrawAlignment(gTextDrawWelcome[playerid],TEXTDRAW_ALIGN_CENTER);
        TextDrawColor(gTextDrawWelcome[playerid],COLOR_WHITE);
        TextDrawSetShadow(gTextDrawWelcome[playerid],1);
        TextDrawUseBox(gTextDrawWelcome[playerid],true);
        TextDrawBoxColor(gTextDrawWelcome[playerid],0xFFFFFFDD);
        TextDrawSetOutline(gTextDrawWelcome[playerid],1);
        TextDrawSetProportional(gTextDrawWelcome[playerid],false);
        SetTimerEx("HideWelcomeTextDraw",FADE_IN_TIME+FADE_OUT_TIME,false,"i",playerid);
    }
}

ShowWelcomeTextDraw(playerid)
{
    TextDrawShowForPlayer(playerid,gTextDrawWelcome[playerid]);
    FadeInTextDraw(playerid,FADE_IN_TIME);
}

FadeInTextDraw(playerid,time)
{
    new currentAlpha = 0;
    while(currentAlpha <= 255)
    {
        Delay(time/255);
        TextDrawColor(gTextDrawWelcome[playerid],currentAlpha << 24 | COLOR_WHITE & 0x00FFFFFF);
        currentAlpha++;
    }
}

HideWelcomeTextDraw(playerid)
{
    FadeOutTextDraw(playerid,FADE_OUT_TIME);
}

FadeOutTextDraw(playerid,time)
{
    new currentAlpha = 255;
    while(currentAlpha >= 0)
    {
        Delay(time/255);
        TextDrawColor(gTextDrawWelcome[playerid],currentAlpha << 24 | COLOR_WHITE & 0x00FFFFFF);
        currentAlpha--;
    }
    TextDrawHideForPlayer(playerid,gTextDrawWelcome[playerid]);
}

Delay(ms)
{
    Sleep(ms);
}