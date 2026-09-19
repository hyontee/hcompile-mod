#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid)
{
    SendClientMessage(playerid, 0xFFFFFFFF, ""SC"test hook.");
    
    return Y_HOOKS_CONTINUE_RETURN_1;

}