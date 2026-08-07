static Float:Postion_X, Postion_Y, Position_Z;
static bool:PostionFixed[MAX_PLAYERS];


stock AC_SetPlayerPos(playerid, Float:X, Float:Y, Float:Z)
{
    GetPlayerPos(playerid, X,Y,Z);
    Postion_X = X;
    Postion_Y = Y;
    Position_Z = Z;
    PostionFixed[playerid] = true;
    SetPlayerPos(playerid, X,Y,Z);
    PostionFixed[playerid] = false;
    return 1;
    // 
    // 
    



}

foreach(new:i, Player)