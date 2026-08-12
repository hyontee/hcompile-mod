stock gps_OnPlayerDisconnect(playerid, reason)
{
	PlayerTextDrawDestroy(playerid,GPSINFO[playerid][0]);
	return 1;
}

stock GPS(playerid, Float:x, Float:y, Float:z,NameSTR[])
{
	new str[144];
    if(GetPVarInt(playerid,"GPS") == 1) RemovePlayerMapIcon(playerid, 99);
    SetPlayerMapIcon(playerid, 99, x, y, z, 19, 0, MAPICON_GLOBAL);
	new Float:p[3]; GetPlayerPos(playerid,p[0],p[1],p[2]);
	format(str,sizeof(str),"{FFFFFF}Место назначение "colserver"%s{FFFFFF}. Расстояние до место назначение "colserver"%.1f м.(красный флажок)",NameSTR,GetDistanceBetweenPoints(p[0], p[1], p[2], x, y, z));
	SendClientMessage(playerid,-1,str);
    PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
    SetPVarInt(playerid,"GPS",1);
    SetPVarInt(playerid,"GPS_AREA",CreateDynamicSphere(x, y, z, 10.0, 0, 0, -1));
    SetPVarFloat(playerid,"GPSX",x);
    SetPVarFloat(playerid,"GPSY",y);
    SetPVarFloat(playerid,"GPSZ",z);

    format(str,sizeof(str),"~y~Distance~n~~w~%.1f m",GetDistanceBetweenPoints(p[0], p[1], p[2], x, y, z));
	PlayerTextDrawSetString(playerid,GPSINFO[playerid][0],str);
	
    for(new i; i < sizeof(GPSTD); i++) TextDrawShowForPlayer(playerid,GPSTD[i]);
    PlayerTextDrawShow(playerid,GPSINFO[playerid][0]);
    return true;
}
stock UNGPS(playerid)
{
    if(GetPVarInt(playerid,"GPS") == 1)
    {
        DestroyDynamicArea(GetPVarInt(playerid,"GPS_AREA"));
        DeletePVar(playerid,"GPS_AREA");
        RemovePlayerMapIcon(playerid, 99);
        SetPVarInt(playerid,"GPS",0);
        
        DeletePVar(playerid,"GPSX");
        DeletePVar(playerid,"GPSY");
        DeletePVar(playerid,"GPSZ");
	    for(new i; i < sizeof(GPSTD); i++) TextDrawHideForPlayer(playerid,GPSTD[i]);
	    PlayerTextDrawHide(playerid,GPSINFO[playerid][0]);
    }
    return true;
}
