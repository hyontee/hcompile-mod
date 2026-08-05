/// La1ghter 2012
#include a_samp.inc
#define MAX_RAD_NAME (16) /// макс. имя радио ( не ссылка )
#define MAX_RADIO (2) /// макс. радио
#define L_DIAG (9200) /// изпользуемый диалог
#define TIME_UPDATE (1500) /// время обновления таймера
//-------------------------------------
enum vehplayer {
    Float:Poos[3],
	SeeVehicle,
} ;
new VPInfo [ MAX_PLAYERS ] [ vehplayer ] ;
//------------------------------------------
new RadioVeh [ MAX_VEHICLES ] = { -1, ... },
	MaxPlayers,
	timer
;
new Radio [ MAX_RADIO ] [ 2 ] [ 72 ] = {
	{ "HOT 108", "http://www.hot108.com/hot108.pls" },
	{ "Reggae", "http://radio.bigupradio.com:8005/listen.pls" }
} ;
//==============================================================================
public OnFilterScriptInit ( ) {
	MaxPlayers = GetMaxPlayers() - 1;
	timer = SetTimer("Global", true, TIME_UPDATE ) ;
	return true ;
}
public OnFilterScriptExit ( ) KillTimer ( timer ) ;

public OnPlayerConnect ( playerid ) {
    VPInfo [playerid] [SeeVehicle] = -1;
    return true ;
}
public OnPlayerCommandText( playerid, cmdtext[] )
{
    if(!strcmp(cmdtext[1], "radio", true))
	{
		if(!IsPlayerInAnyVehicle(playerid) ) return true ;
	    new _str [ MAX_RADIO * MAX_RAD_NAME + 2] ;
		for( new _r; _r < MAX_RADIO ; ++ _r) strcat( _str, Radio[_r][0] ), strcat( _str,"\n" );
		strcat( _str,"Выключить\n" );
  		ShowPlayerDialog(playerid, L_DIAG, DIALOG_STYLE_LIST, "La1ghter", _str, "Выбрать", "Выход");
  		return true ;
	}
	return false ;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if( dialogid == L_DIAG && response )
	{
	    if ( listitem < MAX_RADIO )
	    {
	        RadioVeh[GetPlayerVehicleID(playerid)] = listitem;
	        for (new i; i <= MaxPlayers ; ++ i) {
	            if(!IsPlayerConnected(i) || GetPlayerVehicleID(i) != GetPlayerVehicleID(playerid)) continue;
     			PlayAudioStreamForPlayer(i, Radio [ listitem ] [ 1 ]);
			}
		}
		else if ( listitem >= MAX_RADIO )
		{
		    RadioVeh[GetPlayerVehicleID(playerid)] = -1 ;
		    for (new i; i <= MaxPlayers ; ++ i) {
 				if(!IsPlayerConnected(i) || GetPlayerVehicleID(i) != GetPlayerVehicleID(playerid)) continue;
     			StopAudioStreamForPlayer(i) ;
			}
	    }
	    return true ;
	}
	return false;
}
public OnPlayerExitVehicle ( playerid, vehicleid ) {
	if ( RadioVeh[vehicleid] != -1 ) StopAudioStreamForPlayer(playerid);
	return true ;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) {
		if( RadioVeh[GetPlayerVehicleID(playerid)] != -1) PlayAudioStreamForPlayer(playerid, Radio [ RadioVeh [GetPlayerVehicleID(playerid)] ] [ 1 ] );
	}
	return true ;
}
Global() ;
public Global ( )
{
	new
 		vehid, bool: find = false, Float: Ve[3]
	;
    for (new playerid; playerid <= MaxPlayers ; ++ playerid)
	{
   		if( !IsPlayerConnected(playerid) || IsPlayerInAnyVehicle(playerid) && VPInfo[playerid] [SeeVehicle] == -1 || GetPlayerInterior(playerid) || GetPlayerVirtualWorld(playerid) ) continue ;
		if( VPInfo[playerid] [SeeVehicle] != -1 )
		{
	    	GetVehiclePos (VPInfo[playerid] [SeeVehicle], Ve[0],Ve[1],Ve[2] ) ;
			if( !IsPlayerInRangeOfPoint(playerid, 7.0, VPInfo[playerid][Poos] [0],VPInfo[playerid][Poos][1],VPInfo[playerid][Poos][2]) || IsPlayerInAnyVehicle(playerid) || !IsPlayerInRangeOfPoint(playerid, 7.0, Ve[0],Ve[1],Ve[2]) )
			{
				StopAudioStreamForPlayer(playerid) ;
				VPInfo[playerid] [SeeVehicle] = -1 ;
			}
		}
		for( new _v = 1; _v < MAX_VEHICLES ; ++ _v ) {
        	if ( RadioVeh[_v] == -1  || !IsVehicleStreamedIn(_v, playerid) ) continue ;
        	GetVehiclePos( _v, Ve[0],Ve[1],Ve[2] ) ;
        	if( !IsPlayerInRangeOfPoint(playerid, 7.0,Ve[0],Ve[1],Ve[2]) ) continue ;
			for (new z; z != 3; ++ z) VPInfo[playerid] [Poos] [z] = Ve[z] ;
  			vehid = _v, find = true ;
	  		break ;
		}
		if( vehid != VPInfo[playerid] [SeeVehicle] && find && !IsPlayerInAnyVehicle(playerid) ) {
	 		VPInfo[playerid] [SeeVehicle] = vehid ;
        	PlayAudioStreamForPlayer(playerid, Radio [RadioVeh[vehid]][1], VPInfo[playerid] [Poos] [0],VPInfo[playerid][Poos][1],VPInfo[playerid] [Poos][2],7.0,1);
		}
	}
	return true ;
}
/// La1ghter 2012
