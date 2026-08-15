#if defined _BR_DEATH_FORWARDS_INC_
    #endinput
#endif
#define _BR_DEATH_FORWARDS_INC_

// ALS sscanf (флаги BR_* Ч без пустого #define, ломающего forward в sscanf2.inc)
#define BR_SSCANF_GAME_MODE_INIT
#define BR_SSCANF_PLAYER_CONNECT
#define BR_SSCANF_PLAYER_DISCONNECT

forward SSCANF_OnPlayerConnect(playerid);
forward SSCANF_OnPlayerDisconnect(playerid, reason);
forward SSCANF_OnGameModeInit();

forward conti_OnGameModeInit();
forward conti_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
forward conti_OnPlayerClickTextDraw(playerid, Text:clickedid);
