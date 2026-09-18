main(){}
//============================================================================== includes
#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <Pawn.CMD>
//============================================================================== server settings
#define SERVER_HOSTNAME             			"Maxe Host"
#define SERVER_VERSION              			""
#define SERVER_MAPNAME              			"16.21"
#define SERVER_GROUP                			""
#define SERVER_WEBSITE              			""
#define SERVER_FORUM							""
#define SERVER_LANGUAGE							""
//============================================================================== mysql connects
#define MYSQL_HOST                  			"127.0. 01"
#define MYSQL_USER                  			"gs350476"
#define MYSQL_PASS                  			"gs350476"
#define MYSQL_BASE                  			"Danyal4ik2012"
//============================================================================== colors
#define COLOR_WHITE								0xFFFFFFFF
#define COLOR_GREY								0x808080AA
#define COLOR_BLACK								0x00000000	
#define COLOR_RED								0xB22222AA
#define COLOR_GREEN								0x63BD4EFF
#define COLOR_BLUE								0x0000FFFF
//============================================================================== other
#define public:%0(%1) forward%0(%1); public%0(%1) // Теперь не нужно создавать callback с forward, просто public: и название.
//============================================================================== enums
enum PLAYER_INFO
{
	ID,
	Name[MAX_PLAYER_NAME+1],
	Password[16+1],
	Email[64],
	Sex,
	Skin,
	bool: Logged,
	Money
}
enum
{
	DLG_NONE,
	DLG_LOGIN,
	DLG_REG_PASS,
	DLG_REG_EMAIL,
	DLG_REG_SEX
}
//============================================================================== variables
new pInfo[MAX_PLAYERS][PLAYER_INFO];
new MySQL: connection;
////////////////////////////////////////////////////////////////////////////////
public OnGameModeInit()
{
	connection = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_BASE);
	if(mysql_errno() != 0)
	{
		print("[MySQL] Подключение отсутствует!");
		return SendRconCommand("exit");
	}
	else
	{
		print("[MySQL] Подключение присутствует!");
	}
	SetGameModeText(SERVER_VERSION);
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	SendRconCommand("hostname "SERVER_HOSTNAME"");
	SendRconCommand("mapname "SERVER_MAPNAME"");
	SendRconCommand("weburl "SERVER_WEBSITE"");
	SendRconCommand("language "SERVER_LANGUAGE"");
	return 1;
}
public OnGameModeExit()
{
	mysql_close(connection);
    return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}
public OnPlayerConnect(playerid)
{
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}
public OnPlayerSpawn(playerid)
{
	return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}
public OnVehicleSpawn(vehicleid)
{
	return 1;
}
public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}
public OnPlayerText(playerid, text[])
{
	return 1;
}
/*public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		return 1;
	}
	return 0;
}*/
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}
public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}
public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}
public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}
public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}
public OnRconCommand(cmd[])
{
	return 1;
}
public OnPlayerRequestSpawn(playerid)
{
	return 1;
}
public OnObjectMoved(objectid)
{
	return 1;
}
public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}
public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}
public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}
public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}
public OnPlayerExitedMenu(playerid)
{
	return 1;
}
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}
public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}
public OnPlayerUpdate(playerid)
{
	return 1;
}
public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}
public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}
public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}
public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
