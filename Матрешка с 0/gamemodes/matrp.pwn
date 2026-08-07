/*
		Мод разрабатывался лично мною(kranin).
		
						)
*/


//==================================  Инклюды  =================================
#include <a_samp>
#include <a_mysql>
#include <fix>
#include <Foreach>
#include <Pawn.Regex>
#include <streamer>
#include <sscanf2>
#include <Pawn.CMD>
#include <crashdetect>
#include <jit>
//==============================================================================

#define         MYSQL_HOST          "localhost"
#define         MYSQL_USER          "gs274"
#define         MYSQL_PASS          "gs274"
#define         MYSQL_BASE          "2bW9azrnpKpT9vn9"

//=================================  Дефайны  ==================================
#define         SCM                 SendClientMessage
#define         SCMTA               SendClientMessageToAll
#define         SPD                 ShowPlayerDialog
//==============================================================================

//==================================  Цвета  ===================================
#define         COLOR_WHITE         0xFFFFFFFF
#define         COLOR_RED           0xFF0000FF
#define         COLOR_ERROR         0xFF6347FF
#define         COLOR_GREEN         0x008000FF
#define         COLOR_BLUE      	0x0000FFFF
#define         COLOR_SEA           0x1E90FFFF
//==============================================================================

//==================================  Сервер  ==================================

main()
{
	print("\n----------------------------------");
	print("------   Matreshka Started   ------");
	print("------   By @kranin  ------");
	print("----------------------------------\n");
}

#define         SERVER_NAME         "Matreshka RolePlay"
#define         SERVER_MODE         "matrp v0.1"
#define         SERVER_MAP          "Russia"
#define         SERVER_LANG         "Russian"

#define         SERVER_WEB          "matrp.ru"
#define         SERVER_GROUP        "vk.com/russian_mobile"
#define         SERVER_AUTOR        "vk.com/kranin"

//==============================================================================

//================================  Переменные  ================================
new MySQL:dbHandle;
//==============================================================================

enum player
{
	ID,
	NAME[MAX_PLAYER_NAME],
	PASSWORD[24],
}
new player_info[MAX_PLAYERS][player];

enum dialogs
{
	DLG_REGISTR,
	DLG_LOGIN,
	DLG_REGEMAIL,
}

public OnGameModeInit()
{
	ConnectMySQL();
	
	SendRconCommand("hostname Matreshka Mobile | 01");
	SendRconCommand("mapname "SERVER_MAP"");
	SendRconCommand("weburl  "SERVER_WEB"");
	SendRconCommand("language  "SERVER_LANG"");
	SetGameModeText(SERVER_MODE);
	return 1;
}

stock ConnectMySQL()
{
	dbHandle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_BASE);
	switch(mysql_errno())
	{
	    case 0:print("[LOGS] MySQL started");
	    default:print("[LOGS] MySQL no started");
	}
	mysql_log(ERROR | WARNING);
 	mysql_set_charset("cp1251");
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	GetPlayerName(playerid, player_info[playerid][NAME], MAX_PLAYER_NAME);
	static const fmt_query[128] = "SELECT `id` from `accounts` WHERE `name` = '%s'";
	new query[sizeof(fmt_query)+(-2+MAX_PLAYER_NAME)];
	format(query, sizeof(query), fmt_query, player_info[playerid][NAME]);
	mysql_tquery(dbHandle, query, "LogRegistr", "i", playerid);
	return 1;
}

forward LogRegistr(playerid);
public LogRegistr(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows) LogLogin(playerid);
	else ShowRegistr(playerid);
}

forward LogLogin(playerid);
public LogLogin(playerid)
{

}

stock ShowRegistr(playerid)
{
    new dialog[280];
    format(dialog, sizeof(dialog),
    "{FFFFFF}Приветствуем тебя {FFFF00}%s{FFFFFF}, мы рады видеть тебя на {FF00FF}Matreshka {FFFFFF}RolePlay\n\
	Аккаунт с таким {FFFF00}именем {FFFFFF}не зарегистрирован\n\n\
	Для игры на сервере Вы должны пройти {FFFF00}регистрацию\n\
	{FFFFFF}Придумайте пароль который будет надежён для Вас и нажмите \"Далее\"\n\
	Пароль должен {1E90FF}состоять {FFFFFF}из цифр и символов регистра",
   	player_info[playerid][NAME]
   	);
   	SPD(playerid, DLG_REGISTR, DIALOG_STYLE_INPUT, "{FFD700}Регистрация {FFFFFF}| Ввод пароля", dialog, "Далее", "Выход");
}

stock ShowLogin(playerid)
{
	SCM(playerid, COLOR_RED, "Игрок зареган");
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

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

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
	switch(dialogid)
	{
	    case DLG_REGISTR:
	    {
	        new str;
			if(response)
			{
			    if(!strlen(inputtext))
			    {
			        ShowRegistr(playerid);
			        return SCM(playerid, COLOR_ERROR, "[Ошибка] {FFFFFF}Введите пароль в поле ниже и нажмите \"Далее\"");
			    }
			    if(strlen(inputtext) < 6 || strlen(inputtext) > 32)
			    {
			        ShowRegistr(playerid);
			        return SCM(playerid, COLOR_ERROR, "[Ошибка] {FFFFFF}Длина вашего пароля должна быть от 6-и до 32-х симловов");
			    }
			    new regex:rg_passwordcheck = regex_new("^[a-zA-Z0-9]{1,}$");
				if(regex_check(inputtext, rg_passwordcheck))
				{
				    strmid(player_info[playerid][PASSWORD], inputtext, 0, str, 32);
				    SPD(playerid, DLG_REGEMAIL, DIALOG_STYLE_INPUT, "{FFD700}Регистрация {FFFFFF}| Ввод Email почты",
				        "{FFFFFF}Введите ваш настоящий {DAA520}Email {FFFFFF}адрес почты\n\n\
						Если вы утеряете доступ к {FFD700}электронной почте, {FFFFFF}то Вы сможете восстановить её через почту\n\
						Введите его в поле ниже и нажмите {FFD700}\"Далее\"",
					"Далее", "");
				}
				else
				{
				    ShowRegistr(playerid);
				    return SCM(playerid, COLOR_ERROR, "[Ошибка] {FFFFFF}Пароль может состоять только из чисел и латинских символов");
				}
			}
			else
			{
			    SCM(playerid, COLOR_ERROR, "Введите команду /q, чтобы покинуть сервер");
			    SPD(playerid, -1, 0, " ", " ", " ", "");
			    return Kick(playerid);
			}
	    }
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
