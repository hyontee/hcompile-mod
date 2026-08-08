#include 	<a_samp>
#include 	<a_mysql>
#include 	<sscanf2>
#include 	<foreach>

#include 	<Pawn.CMD>
#include 	<Pawn.RakNet>
#include 	<mxINI.inc>



#define CUSTOM_RPC_TOGGLE_HUD_ELEMENT   0x1
#define PACKET_CUSTOMRPC    			251

#define HUD_ELEMENT_HIDE				0
#define HUD_ELEMENT_SHOW				1

#define HUD_ELEMENT_CHAT    			                  0
#define HUD_ELEMENT_MAP     			                  1
#define HUD_ELEMENT_TAGS    			                  2
#define HUD_ELEMENT_BUTTONS 			                  3
#define HUD_ELEMENT_HUD     			                  4
#define HUD_ELEMENT_VOICE								  5
#define HUD_ELEMENT_TEXTLABELS			                  6

#define MAX_STREAM_SOURCES				1000

#define RPC_STREAM_CREATE				0x2
#define RPC_STREAM_POS					0x3
#define RPC_STREAM_DESTROY				0x4
#define RPC_STREAM_INDIVIDUAL			0x5
#define RPC_STREAM_VOLUME				0x6
#define RPC_STREAM_ISENABLED			0x7
#define RPC_OPEN_LINK					0x8
#define RPC_TIMEOUT_CHAT 				0x9
#define RPC_OPEN_SETTINGS				0x15
#define RPC_CUSTOM_SET_FUEL				0x25
#define RPC_CUSTOM_SET_LEVEL 			0x26
#define RPC_CUSTOM_SET_MILEAGE			0x28

#define RPC_SHOW_NOTIFICATION      		0x32

#define RPC_CUSTOM_SHOW_HUD				0x35
#define RPC_CUSTOM_HIDE_HUD				0x36







//==============================================================================
#define SERVER_NAME			"Paradise | CR:MP"
#define SERVER_GAME_MODE    "Paradise RP"
#define SERVER_MAP_NAME		"CRMP"
#define SERVER_WEBSITE		"vk.com/gadzhimgh"
#define SERVER_FORUM		""
#define SERVER_DONATE		""
//==============================================================================
#define CWHITE 		0xFFFFFFFF
#define CRED 		0xFF0000FF
#define CCYAN 		0x0000FFFF
#define CPINK 		0xFF00FFFF
#define CBLUE 		0x00FFFFFF
#define CYELLOW 	0xFFFF00FF
#define CGREY 		0x7F7F7FFF
#define CGREEN   	0x00FF00FF
#define CORANGE 	0xFF8000FF
#define CGOLD		0xFFD700FF
#define CDSB		0x00BFFFFF
#define CPURPLE     0xF7619300
#define CLRED    	0xFF3030FF

//------------------------------Цвет рации--------------------------------------

#define cRR         0x3CB371FF
#define cFF         0x6495EDFF

//______________________________________________________________________________
//------------------------------------------------------------------------------
#define CW          "{FFFFFF}"
#define CR          "{FF0000}"
#define CBB         "{0000FF}"
#define CP          "{FF00FF}"
#define CB          "{00FFFF}"
#define CY          "{FFFF00}"
#define CGRY		"{7F7F7F}"
#define CG	        "{00FF00}"
#define CO          "{FF8000}"
#define CGLD		"{FFD700}"
//------------------------------------------------------------------------------
#define CDG         "{006400}"
#define CDO         "{FF8C00}"
#define CLR         "{FF3030}"
#define cBi			"{3399FF}"


#define SCM 			SendClientMessage
#define SCMTA   		SendClientMessageToAll
#define SPD         	ShowPlayerDialog
//------------------------------------------------------------------------------
#define		DSI		DIALOG_STYLE_INPUT
#define 	DSM		DIALOG_STYLE_MSGBOX
#define 	DSL		DIALOG_STYLE_LIST
#define 	DSP		DIALOG_STYLE_PASSWORD
#define 	DST		DIALOG_STYLE_TABLIST



enum MYSQL_SETTINGS
{
	MYSQL_HOST,
	MYSQL_USER,
	MYSQL_PASSWORD,
	MYSQL_DATABASE
}
new MySQLSettings[MYSQL_SETTINGS][30];


//enum
//{
//    D_DICE_SET_BET,
//}



#define MAX_DICE_LOBBY 10



//============================= КОСТИ ==========================================
new PlayerText:dice_balance[MAX_PLAYERS];

new Text:dice_fon[MAX_DICE_LOBBY];
new Text:dice_table[MAX_DICE_LOBBY];
new Text:dice_bet[MAX_DICE_LOBBY];
new Text:dice_all_bank[MAX_DICE_LOBBY];

new Text:dice_set_bet;
new Text:dice_drop_bones;
new Text:dice_exit;

new Text:dice_members[MAX_DICE_LOBBY][5];
new Text:dice_members_ready[MAX_DICE_LOBBY][5];

new Text:dice_timer[MAX_DICE_LOBBY];

new Text3D: DiceTableText[MAX_DICE_LOBBY+1];

new Float:DiceTablePos[MAX_DICE_LOBBY+1][3];// =
//{
//	{0.0,0.0,0.0},
//	{0.0,0.0,1001.0}
//};



enum Dice_Info
{
	Bet,
	Bank,
	Croupier,
	bool:Started,
	StartTimer,
	Members[5],
	bool:Members_ready[5],
}
new DiceInfo[MAX_DICE_LOBBY][Dice_Info];


enum P_Info
{
	bool:OnLobbyDice,
	bool:pDiceCroupier,
	bool:pDiceBet,
	pDiceLobby,
	pDiceTable,
	
	//bool:pFreeze,
};
new pInfo[MAX_PLAYERS][P_Info];



new PosconnectID;

new CountDiceLobby;





main()
{
    new a[][] =     {"Unarmed (Fist)","Brass K"};
	#pragma unused a
}


public OnFilterScriptInit()
{
    print("--------------------------------------");
    print("         Система КОСТИ by KBAS's");
    print("--------------------------------------\n");
    LoadSettingsSystem();
	LoadDiceTable();
	//SetTimer("TimerLoadDiceSystem", 1000, false);
    return 1;
}

public OnFilterScriptExit()
{
	return 1;
}



public OnPlayerConnect(playerid)
{
    dice_balance[playerid] = CreatePlayerTextDraw(playerid, 550.999755, 185.186706, "Ђaћa®c: 1000000");
	PlayerTextDrawLetterSize(playerid,			dice_balance[playerid], 0.357998, 1.405866);
	PlayerTextDrawAlignment(playerid,			dice_balance[playerid], 2);
	PlayerTextDrawColor(playerid,				dice_balance[playerid], -1);
	PlayerTextDrawSetShadow(playerid,			dice_balance[playerid], 0);
	PlayerTextDrawSetOutline(playerid,			dice_balance[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid,		dice_balance[playerid], 51);
	PlayerTextDrawFont(playerid,				dice_balance[playerid], 1);
	PlayerTextDrawSetProportional(playerid,		dice_balance[playerid], 1);
	return 1;
}




public OnPlayerClickTextDraw(playerid, Text:clickedid)//ВПИСАТЬ ЦВЕТА!
{
	if(clickedid == dice_set_bet)
	{
	    new lobby = pInfo[playerid][pDiceLobby];
		if(playerid == DiceInfo[lobby][Croupier])
		{
			SPD(playerid, 19997, DSI, ""CR"Установка ставки для игры:", "Ставка должна быть не менее 1000 рублей\nи не более 1000000 рублей", "Далее", "Отмена");
		}
		else
		{
		    if(DiceInfo[lobby][Croupier] == 1000) return SCM(playerid, CLRED, "| "CW"На данном столе нет крупье.");
		    if(DiceInfo[lobby][Bet] == 0) return SCM(playerid, CLRED, "| "CW"Сначала дилер должен установить ставку.");
		    if(pInfo[playerid][pDiceBet] == true) return SCM(playerid, CLRED, "| "CW"Вы уже поставили ставку.");
			if(playermoney(playerid) < DiceInfo[lobby][Bet]) return SCM(playerid, CLRED, "| "CW"У Вас недостаточно средств.");
			DiceInfo[lobby][Members_ready][pInfo[playerid][pDiceTable]] = true;

			TextDrawSetString(dice_members_ready[lobby][pInfo[playerid][pDiceTable]], "++");

			pInfo[playerid][pDiceBet] = true; DiceInfo[lobby][Members_ready][pInfo[playerid][pDiceTable]] = true;

			//GivePlayerMoneyEx(playerid, -DiceInfo[lobby][Bet]);

			DiceInfo[lobby][Bank] += DiceInfo[lobby][Bet];

			new str[20];
			format(str, sizeof str, "Ђaћa®c: %d", playermoney(playerid));
			PlayerTextDrawShow(playerid, dice_balance[playerid]);
			PlayerTextDrawSetString(playerid, dice_balance[playerid], str);
		}
	}

	if(clickedid == dice_drop_bones)
	{
	    new lobby = pInfo[playerid][pDiceLobby];
		if(playerid == DiceInfo[lobby][Croupier])
		{
	    	if(DiceInfo[lobby][Started] == true) return SCM(playerid, CLRED, "| "CW"Дождитесь окончания игры.");
            if(DiceInfo[lobby][Bet] == 0) return SCM(playerid, CLRED, "| "CW"Вы не установили ставку.");
            new active;
            if(DiceInfo[lobby][Members][0] < 1000) active++;
            if(DiceInfo[lobby][Members][1] < 1000) active++;
            if(DiceInfo[lobby][Members][2] < 1000) active++;
            if(DiceInfo[lobby][Members][3] < 1000) active++;
            if(DiceInfo[lobby][Members][4] < 1000) active++;

            if(active < 2) return SCM(playerid, CLRED, "| "CW"Дождитесь участников.");

            if(DiceInfo[lobby][Members][0] < 1000 && DiceInfo[lobby][Members_ready][0] == true) { GivePlayerMoneyEx(DiceInfo[lobby][Members][0], -DiceInfo[lobby][Bet]); }
            if(DiceInfo[lobby][Members][1] < 1000 && DiceInfo[lobby][Members_ready][1] == true) { GivePlayerMoneyEx(DiceInfo[lobby][Members][1], -DiceInfo[lobby][Bet]); }
            if(DiceInfo[lobby][Members][2] < 1000 && DiceInfo[lobby][Members_ready][2] == true) { GivePlayerMoneyEx(DiceInfo[lobby][Members][2], -DiceInfo[lobby][Bet]); }
            if(DiceInfo[lobby][Members][3] < 1000 && DiceInfo[lobby][Members_ready][3] == true) { GivePlayerMoneyEx(DiceInfo[lobby][Members][3], -DiceInfo[lobby][Bet]); }
            if(DiceInfo[lobby][Members][4] < 1000 && DiceInfo[lobby][Members_ready][4] == true) { GivePlayerMoneyEx(DiceInfo[lobby][Members][4], -DiceInfo[lobby][Bet]); }

            DiceInfo[lobby][StartTimer] = 10;
            DiceInfo[lobby][Started] = true;


		}
		else SCM(playerid, CLRED, "| "CW"Вы не крупье.");
	}

	if(clickedid == dice_exit)
	{
	    if(DiceInfo[pInfo[playerid][pDiceLobby]][Started] == true) return SCM(playerid, CLRED, "| "CW"Дождитесь окончания игры.");
	    ExitPlayerDice(playerid, pInfo[playerid][pDiceLobby]);
	}
    return 1;
}



public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
//	if(pInfo[playerid][pFreeze] == true) { FreezePlayer(playerid); }
    if(dialogid == 19997)
	{
	    if(response)
	    {
	        if(pInfo[playerid][OnLobbyDice])
	        {
				new lobby = pInfo[playerid][pDiceLobby];
	        	if(DiceInfo[lobby][Started] == false)
	        	{
					new bet;
		            if(sscanf(inputtext,"d",bet))
		            {
		                SCM(playerid, CLRED, "| "CW"Введите ставку для стола.");
                        SPD(playerid, 19997, DSI, ""CR"Установка ставки для игры:", "Ставка должна быть не менее 1000 рублей\nи не более 1000000 рублей", "Далее", "Отмена");
		                return 0;
		            }
		            if(!(999 < bet < 1000001))
		            {
		                SCM(playerid, CLRED, "| "CW"Минимально 1000 рублей, Максимально 1000000 рублей.");
		                SPD(playerid, 19997, DSI, ""CR"Установка ставки для игры:", "Ставка должна быть не менее 1000 рублей\nи не более 1000000 рублей", "Далее", "Отмена");
		                return 0;
		            }


                    DiceInfo[lobby][Bet] = bet;
                    DiceInfo[lobby][Bank] = 0;

					new strkbass[20];
					format(strkbass, sizeof strkbass, "C¦aўka: %d", bet);
					TextDrawSetString(dice_bet[lobby], strkbass);

					TextDrawShowForPlayer(playerid, dice_bet[lobby]);

					for(new i; i < 5; i++)
					{
						if(DiceInfo[lobby][Members][i] < 1000)
						{
							TextDrawShowForPlayer(DiceInfo[lobby][Members][i], dice_bet[lobby]);
							pInfo[DiceInfo[lobby][Members][i]][pDiceBet] = false;
		     				DiceInfo[lobby][Members_ready][i] = false;
							TextDrawSetString(dice_members_ready[lobby][i], "--");
						}
					}
				}
				else SCM(playerid, CLRED, "| "CW"Игра уже началась.");
			}
		}
	}
	return 1;
}








stock LoadDiceTable()
{

	PosconnectID = mysql_connect(MySQLSettings[MYSQL_HOST],MySQLSettings[MYSQL_USER],MySQLSettings[MYSQL_DATABASE],MySQLSettings[MYSQL_PASSWORD]);
	new str[102];
    switch(mysql_errno())
	{
	    case 1044: format(str, sizeof str, "[Пользователю %s в доступе к БД %s отказано]", MySQLSettings[MYSQL_USER], MySQLSettings[MYSQL_DATABASE]);
		case 1045: format(str, sizeof str, "[Пользователю %s отказанно в доступе(Не верный пароль: %s)]", MySQLSettings[MYSQL_USER], MySQLSettings[MYSQL_PASSWORD]);
	    case 1049: format(str, sizeof str, "[Неизвестная БД: %s]", MySQLSettings[MYSQL_DATABASE]);
	    case 2003: format(str, sizeof str, "[Не удается подключиться к серверу MySQL на %s]", MySQLSettings[MYSQL_HOST]);
	    case 2005: format(str, sizeof str, "[Сервер неизвестный MySQL, хост: %s]", MySQLSettings[MYSQL_HOST]);
	    default:   format(str, sizeof str, "[Неизвестная ошибка. Код ошибки: %d]", mysql_errno());
	}
	if(mysql_errno() == 0)
	{
		print("Загрузка кости...");
		//printf("%d", CountDiceLobby);
		for(new lobby; lobby < CountDiceLobby; lobby++)
		{
		    LoadDiceTablePos(lobby+1);

	        LoadDiceTextDraw(lobby);

	        ReloadDiceTable(lobby);
	        DiceInfo[lobby][Bet] = 500000;
	        DiceInfo[lobby][Croupier] = 1000;


			SetTimerEx("TimerSecondUpdateDice", 1000, true, "d", lobby);

		}
	}
	//mysql_close(PosconnectID);
	return 1;
}

stock LoadDiceTablePos(table)
{
	//сохранка данных
	new qString[72];
	format(qString, sizeof(qString), "SELECT `posx`, `posy`, `posz` FROM `dicebykbass` WHERE `dicetable` = %d", table);
	mysql_function_query(PosconnectID, qString, true, "LoadDiceTablePosInfo", "d", table);
	//LoadMySQLSettings();
}
forward LoadDiceTablePosInfo(table);
public LoadDiceTablePosInfo(table)
{
    //printf("Загрузка координат %d-го стола...", table);
    new rows, fields;
    cache_get_data(rows, fields);
    if(!rows)
    {
        printf("ВНИМАНИЕ: Не найдено координат для %d-го стола. Установите их в своей базе данных.", table);
    }
    else
    {
	    DiceTablePos[table][0] = cache_get_field_content_float(0, "posx", PosconnectID);
	    DiceTablePos[table][1] = cache_get_field_content_float(0, "posy", PosconnectID);
	    DiceTablePos[table][2] = cache_get_field_content_float(0, "posz", PosconnectID);
	    
	    if(DiceTablePos[table][0] == 0 && DiceTablePos[table][1] == 0 && DiceTablePos[table][2] == 0)
	    {
        	printf("ВНИМАНИЕ: Координаты %d-го стола не указаны. Пропишите их в своей базе данных.", table);
	    }
		else
		{
			printf("Координаты для %d-го стола успешно получены из БД", table);

		    new strkbass[64];
		    format(strkbass, sizeof strkbass, ""CY"Столик %d\n"CW"Подойдите для взаимодействия и введите /dice", table);
	        DiceTableText[table] = Create3DTextLabel("КОСТИ\n{FFFFFF}Для начала игры введите /dice", CLRED, DiceTablePos[table][0], DiceTablePos[table][1], DiceTablePos[table][2], 3.0, 0);
		}
    }
}

forward TimerSecondUpdateDice(lobby);
public TimerSecondUpdateDice(lobby)
{
	new all_bank[20];
	format(all_bank, sizeof all_bank, "O—Ўњќ —a®k: %d", DiceInfo[lobby][Bank]);
	TextDrawSetString(dice_all_bank[lobby], all_bank);

	if(DiceInfo[lobby][Croupier] < 1000)
	{
		if(DiceInfo[lobby][Started] == true)
		{
		    if(DiceInfo[lobby][StartTimer] == 0)
		    {
		        DiceInfo[lobby][Started] = false;
		        //SCMTA(CLRED, "STOP DICE");

				TextDrawHideForPlayer(DiceInfo[lobby][Croupier], dice_timer[lobby]);
				for(new i; i < 5; i++) if(DiceInfo[lobby][Members][i] < 1000) TextDrawHideForPlayer(DiceInfo[lobby][Members][i], dice_timer[lobby]);

	            TextDrawSetString(dice_timer[lobby], "10");

		        //КОД КОСТИ

		        new members_count[5]; new strkbass[10];

				new max_point[2] = 0;

				for(new i; i < 5; i++)
				{
					if(DiceInfo[lobby][Members][i] < 1000)
					{
					    if(DiceInfo[lobby][Members_ready][i] == true && pInfo[DiceInfo[lobby][Members][i]][pDiceBet] == true)
					    {
							members_count[i] = random(10);

							new str_point[3];
							format(str_point, sizeof str_point, "%d", members_count[i]);
		        			TextDrawSetString(dice_members_ready[lobby][0], str_point);

						    if(members_count[i] > max_point[0]) { max_point[0] = members_count[i]; max_point[1] = i; }
						    else if(members_count[i] == max_point[0]) { members_count[i]--; }
					    }
				    }
				}
				new win_str[64];

				format(win_str, sizeof win_str, "{00693e}Побеждает %s. У него %d очков", playername(DiceInfo[lobby][Members][max_point[1]]), max_point[0]);
				SCM(DiceInfo[lobby][Croupier], CWHITE, win_str);

				GivePlayerMoneyEx(DiceInfo[lobby][Members][max_point[1]], DiceInfo[lobby][Bank]-((DiceInfo[lobby][Bank]/100)*6));
				GivePlayerMoneyEx(DiceInfo[lobby][Croupier], DiceInfo[lobby][Bet]/100);


				DiceInfo[lobby][Bank] = 0; DiceInfo[lobby][Bet] = 0;
				TextDrawSetString(dice_bet[lobby], "C¦aўka: 0");


		        if(DiceInfo[lobby][Members][0] < 1000) { format(strkbass, sizeof strkbass, "Выпало: %d", members_count[0]); SetPlayerChatBubble(DiceInfo[lobby][Members][0], strkbass, CLRED, 5.0, 5000); SCM(DiceInfo[lobby][Members][0], 0x00693e, win_str); DiceInfo[lobby][Members_ready][0] = false; pInfo[DiceInfo[lobby][Members][0]][pDiceBet] = false; }
		        if(DiceInfo[lobby][Members][1] < 1000) { format(strkbass, sizeof strkbass, "Выпало: %d", members_count[1]); SetPlayerChatBubble(DiceInfo[lobby][Members][1], strkbass, CLRED, 5.0, 5000); SCM(DiceInfo[lobby][Members][1], 0x00693e, win_str); DiceInfo[lobby][Members_ready][1] = false; pInfo[DiceInfo[lobby][Members][1]][pDiceBet] = false; }
		        if(DiceInfo[lobby][Members][2] < 1000) { format(strkbass, sizeof strkbass, "Выпало: %d", members_count[2]); SetPlayerChatBubble(DiceInfo[lobby][Members][2], strkbass, CLRED, 5.0, 5000); SCM(DiceInfo[lobby][Members][2], 0x00693e, win_str); DiceInfo[lobby][Members_ready][2] = false; pInfo[DiceInfo[lobby][Members][2]][pDiceBet] = false; }
		        if(DiceInfo[lobby][Members][3] < 1000) { format(strkbass, sizeof strkbass, "Выпало: %d", members_count[3]); SetPlayerChatBubble(DiceInfo[lobby][Members][3], strkbass, CLRED, 5.0, 5000); SCM(DiceInfo[lobby][Members][3], 0x00693e, win_str); DiceInfo[lobby][Members_ready][3] = false; pInfo[DiceInfo[lobby][Members][3]][pDiceBet] = false; }
		        if(DiceInfo[lobby][Members][4] < 1000) { format(strkbass, sizeof strkbass, "Выпало: %d", members_count[4]); SetPlayerChatBubble(DiceInfo[lobby][Members][4], strkbass, CLRED, 5.0, 5000); SCM(DiceInfo[lobby][Members][4], 0x00693e, win_str); DiceInfo[lobby][Members_ready][4] = false; pInfo[DiceInfo[lobby][Members][4]][pDiceBet] = false; }

				SetTimerEx("TimerZeroSetBetDice", 3000, false, "d", lobby);
			}
		    else
			{
				new strkbass[3];
				format(strkbass, sizeof strkbass, "%d", DiceInfo[lobby][StartTimer]);
	            TextDrawSetString(dice_timer[lobby], strkbass);

				TextDrawShowForPlayer(DiceInfo[lobby][Croupier], dice_timer[lobby]);

				for(new i; i < 5; i++) if(DiceInfo[lobby][Members][i] < 1000) TextDrawShowForPlayer(DiceInfo[lobby][Members][i], dice_timer[lobby]);

				DiceInfo[lobby][StartTimer]--;
			}
		}
	}
}

forward TimerZeroSetBetDice(lobby);
public TimerZeroSetBetDice(lobby)
{
    TextDrawSetString(dice_members_ready[lobby][0], "--");
    TextDrawSetString(dice_members_ready[lobby][1], "--");
    TextDrawSetString(dice_members_ready[lobby][2], "--");
    TextDrawSetString(dice_members_ready[lobby][3], "--");
    TextDrawSetString(dice_members_ready[lobby][4], "--");
}

stock ReloadDiceTable(lobby)
{
	DiceInfo[lobby][Members][0] = 1000;
	DiceInfo[lobby][Members][1] = 1000;
	DiceInfo[lobby][Members][2] = 1000;
	DiceInfo[lobby][Members][3] = 1000;
	DiceInfo[lobby][Members][4] = 1000;
}

stock InitPlayerDice(playerid, lobby)
{
    pInfo[playerid][OnLobbyDice] = true;

	new strkbass[24];
	TextDrawShowForPlayer(playerid, dice_fon[lobby]);

	format(strkbass, sizeof strkbass, "C¦oћ %d", lobby+1);
	TextDrawSetString(dice_table[lobby], strkbass);
	TextDrawShowForPlayer(playerid, dice_table[lobby]);

	format(strkbass, sizeof strkbass, "C¦aўka: %d", DiceInfo[lobby][Bet]);
	TextDrawSetString(dice_bet[lobby], strkbass);
	TextDrawShowForPlayer(playerid, dice_bet[lobby]);

	format(strkbass, sizeof strkbass, "O—Ўњќ —a®k: %d", DiceInfo[lobby][Bank]);
	TextDrawSetString(dice_all_bank[lobby], strkbass);
	TextDrawShowForPlayer(playerid, dice_all_bank[lobby]);

	TextDrawShowForPlayer(playerid, dice_set_bet);
	TextDrawShowForPlayer(playerid, dice_drop_bones);
	TextDrawShowForPlayer(playerid, dice_exit);

	for(new i; i < 5; i++)
	{
	    if(DiceInfo[lobby][Members][i] < 1000)
	    {
			format(strkbass, sizeof strkbass, "%s", playername(DiceInfo[lobby][Members][i]));
			TextDrawSetString(dice_members[lobby][i], strkbass);
	    }
	    else TextDrawSetString(dice_members[lobby][i], "--");
		TextDrawShowForPlayer(playerid, dice_members[lobby][i]);

	    if(DiceInfo[lobby][Members_ready][i] == true && pInfo[DiceInfo[lobby][Members][i]][pDiceBet] == true)
	    {
			TextDrawSetString(dice_members_ready[lobby][i], "++");
	    }
	    else TextDrawSetString(dice_members_ready[lobby][i], "--");
		TextDrawShowForPlayer(playerid, dice_members_ready[lobby][i]);
	}

	//TextDrawShowForPlayer(playerid, dice_timer[lobby]);

	new str[20];
	format(str, sizeof str, "Ђaћa®c: %d", playermoney(playerid));
	PlayerTextDrawShow(playerid, dice_balance[playerid]);
	PlayerTextDrawSetString(playerid, dice_balance[playerid], str);

	//PlayerTextDrawSetString(playerid, bj_bet[playerid], str);

	FreezePlayer(playerid);
	HidePlayerHud(playerid);

	foreach(new i : Player)
	{
	    ShowPlayerNameTagForPlayer(playerid, i, 0);
	}

	SelectTextDraw(playerid, false);
}

stock ExitPlayerDice(playerid, lobby)
{
	if(DiceInfo[lobby][Croupier] == playerid) { DiceInfo[lobby][Croupier] = 1000; pInfo[playerid][OnLobbyDice] = false; }
	else
	{
		DiceInfo[lobby][Members][pInfo[playerid][pDiceTable]] = 1000;
		TextDrawSetString(dice_members[lobby][pInfo[playerid][pDiceTable]], "--");
		TextDrawSetString(dice_members_ready[lobby][pInfo[playerid][pDiceTable]], "--");

		if(pInfo[playerid][pDiceBet] == true && DiceInfo[lobby][Members_ready][pInfo[playerid][pDiceTable]] == true) { DiceInfo[lobby][Bank] -= DiceInfo[lobby][Bet]; }

		DiceInfo[lobby][Members_ready][pInfo[playerid][pDiceTable]] = false; pInfo[playerid][pDiceBet] = false;


		pInfo[playerid][OnLobbyDice] = false; pInfo[playerid][pDiceLobby] = 0; pInfo[playerid][pDiceTable] = 0;
	}

	TextDrawHideForPlayer(playerid, dice_fon[lobby]);
	TextDrawHideForPlayer(playerid, dice_table[lobby]);
	TextDrawHideForPlayer(playerid, dice_bet[lobby]);
	TextDrawHideForPlayer(playerid, dice_all_bank[lobby]);

	TextDrawHideForPlayer(playerid, dice_set_bet);
	TextDrawHideForPlayer(playerid, dice_drop_bones);
	TextDrawHideForPlayer(playerid, dice_exit);

	for(new i; i < 5; i++)
	{
		TextDrawHideForPlayer(playerid, dice_members[lobby][i]);
		TextDrawHideForPlayer(playerid, dice_members_ready[lobby][i]);
	}

	TextDrawHideForPlayer(playerid, dice_timer[lobby]);

	PlayerTextDrawHide(playerid, dice_balance[playerid]);

	//PlayerTextDrawSetString(playerid, bj_bet[playerid], str);

	CancelSelectTextDraw(playerid);
	UnFreezePlayer(playerid);
	ShowPlayerHud(playerid);

	foreach(new i : Player)
	{
	    ShowPlayerNameTagForPlayer(playerid, i, 1);
	}
}

CMD:dice(playerid)
{
	new bool:distance;
	if(pInfo[playerid][OnLobbyDice] == false)
	{
		for(new i; i < CountDiceLobby; i++)
		{
			if(CheckPlayerDistanceToPoint(playerid, DiceTablePos[i+1][0], DiceTablePos[i+1][1], DiceTablePos[i+1][2], 3))
		    {
		     	distance = true;
		        if(pInfo[playerid][pDiceCroupier] == true)
		        {
		            if(DiceInfo[i][Croupier] < 1000) return SCM(playerid, CLRED, "| "CW"За этим столом уже есть крупье");
		            DiceInfo[i][Croupier] = playerid; pInfo[playerid][pDiceLobby] = i; InitPlayerDice(playerid, i);
		        }
		        else
		        {
					if(DiceInfo[i][Started] == false)
					{
						if(DiceInfo[i][Members][0] == 1000) 	     { DiceInfo[i][Members][0] = playerid; pInfo[playerid][pDiceLobby] = i; pInfo[playerid][pDiceTable] = 0; InitPlayerDice(playerid, i); }
						else if(DiceInfo[i][Members][1] == 1000) 	 { DiceInfo[i][Members][1] = playerid; pInfo[playerid][pDiceLobby] = i; pInfo[playerid][pDiceTable] = 1; InitPlayerDice(playerid, i); }
						else if(DiceInfo[i][Members][2] == 1000) 	 { DiceInfo[i][Members][2] = playerid; pInfo[playerid][pDiceLobby] = i; pInfo[playerid][pDiceTable] = 2; InitPlayerDice(playerid, i); }
						else if(DiceInfo[i][Members][3] == 1000) 	 { DiceInfo[i][Members][3] = playerid; pInfo[playerid][pDiceLobby] = i; pInfo[playerid][pDiceTable] = 3; InitPlayerDice(playerid, i); }
						else if(DiceInfo[i][Members][4] == 1000) 	 { DiceInfo[i][Members][4] = playerid; pInfo[playerid][pDiceLobby] = i; pInfo[playerid][pDiceTable] = 4; InitPlayerDice(playerid, i); }
						else SCM(playerid, CLRED, "| "CW"Данный стол уже занят.");
					}
					else SCM(playerid, CLRED, "| "CW"На этом столе уже началась игра.");
				}
		    }
		    else continue;
		}
		if(distance == false) SCM(playerid, CLRED, "| "CW"Вы находитесь слишком далеко от стола");
	}
	return 1;
}

CMD:setdice(playerid)
{
	pInfo[playerid][pDiceCroupier] = true;
	return 1;
}

stock LoadDiceTextDraw(lobby)
{
    dice_fon[lobby] = TextDrawCreate(467.200042, 109.760002, "dicebykbass:kbassdice");
	TextDrawLetterSize(			dice_fon[lobby], 0.000000, 0.000000);
	TextDrawTextSize(			dice_fon[lobby], 163.199951, 218.773101);
	TextDrawAlignment(			dice_fon[lobby], 1);
	TextDrawColor(				dice_fon[lobby], -1);
	TextDrawSetShadow(			dice_fon[lobby], 0);
	TextDrawSetOutline(			dice_fon[lobby], 0);
	TextDrawFont(				dice_fon[lobby], 4);


	dice_set_bet = TextDrawCreate(476.799987, 280.746673, "textures:button");
	TextDrawLetterSize(			dice_set_bet, 0.000000, 0.000000);
	TextDrawTextSize(			dice_set_bet, 59.200000, 17.920021);
	TextDrawAlignment(			dice_set_bet, 1);
	TextDrawColor(				dice_set_bet, -1);
	TextDrawSetShadow(			dice_set_bet, 0);
	TextDrawSetOutline(			dice_set_bet, 0);
	TextDrawFont(				dice_set_bet, 4);
	TextDrawSetSelectable(		dice_set_bet, true);

	dice_drop_bones = TextDrawCreate(541.799865, 280.253326, "textures:button");
	TextDrawLetterSize(			dice_drop_bones, 0.000000, 0.000000);
	TextDrawTextSize(			dice_drop_bones, 59.200000, 17.920021);
	TextDrawAlignment(			dice_drop_bones, 1);
	TextDrawColor(				dice_drop_bones, -1);
	TextDrawSetShadow(			dice_drop_bones, 0);
	TextDrawSetOutline(			dice_drop_bones, 0);
	TextDrawFont(				dice_drop_bones, 4);
	TextDrawSetSelectable(		dice_drop_bones, true);

	dice_exit = TextDrawCreate(607.600036, 280.506652, "textures:button");
	TextDrawLetterSize(			dice_exit, 0.000000, 0.000000);
	TextDrawTextSize(			dice_exit, 15.200000, 17.920021);
	TextDrawAlignment(			dice_exit, 1);
	TextDrawColor(				dice_exit, -1);
	TextDrawSetShadow(			dice_exit, 0);
	TextDrawSetOutline(			dice_exit, 0);
	TextDrawFont(				dice_exit, 4);
	TextDrawSetSelectable(		dice_exit, true);


	dice_timer[lobby] = TextDrawCreate(292.799896, 223.999893, "9");
	TextDrawLetterSize(			dice_timer[lobby], 0.641999, 3.197865);
	TextDrawAlignment(			dice_timer[lobby], 1);
	TextDrawColor(				dice_timer[lobby], 16711935);
	TextDrawSetShadow(			dice_timer[lobby], 0);
	TextDrawSetOutline(			dice_timer[lobby], 1);
	TextDrawBackgroundColor(	dice_timer[lobby], 51);
	TextDrawFont(				dice_timer[lobby], 1);
	TextDrawSetProportional(	dice_timer[lobby], 1);


	dice_table[lobby] = TextDrawCreate(550.399719, 136.639968, "C¦oћ 1");
	TextDrawLetterSize(			dice_table[lobby], 0.357998, 1.405866);
	TextDrawAlignment(			dice_table[lobby], 2);
	TextDrawColor(				dice_table[lobby], -1);
	TextDrawSetShadow(			dice_table[lobby], 0);
	TextDrawSetOutline(			dice_table[lobby], 1);
	TextDrawBackgroundColor(	dice_table[lobby], 51);
	TextDrawFont(				dice_table[lobby], 1);
	TextDrawSetProportional(	dice_table[lobby], 1);

	dice_bet[lobby] = TextDrawCreate(550.599731, 159.293319, "C¦aўka: 1000000");
	TextDrawLetterSize(			dice_bet[lobby], 0.357998, 1.405866);
	TextDrawAlignment(			dice_bet[lobby], 2);
	TextDrawColor(				dice_bet[lobby], -1);
	TextDrawSetShadow(			dice_bet[lobby], 0);
	TextDrawSetOutline(			dice_bet[lobby], 1);
	TextDrawBackgroundColor(	dice_bet[lobby], 51);
	TextDrawFont(				dice_bet[lobby], 1);
	TextDrawSetProportional(	dice_bet[lobby], 1);

	dice_all_bank[lobby] = TextDrawCreate(550.799743, 172.240036, "O—Ўњќ —a®k: 0");
	TextDrawLetterSize(			dice_all_bank[lobby], 0.357998, 1.405866);
	TextDrawAlignment(			dice_all_bank[lobby], 2);
	TextDrawColor(				dice_all_bank[lobby], -1);
	TextDrawSetShadow(			dice_all_bank[lobby], 0);
	TextDrawSetOutline(			dice_all_bank[lobby], 1);
	TextDrawBackgroundColor(	dice_all_bank[lobby], 51);
	TextDrawFont(				dice_all_bank[lobby], 1);
	TextDrawSetProportional(	dice_all_bank[lobby], 1);

	dice_members[lobby][0] = TextDrawCreate(474.400085, 212.800033, "BY KBAS's");
	TextDrawLetterSize(			dice_members[lobby][0], 0.285198, 1.174396);
	TextDrawAlignment(			dice_members[lobby][0], 1);
	TextDrawColor(				dice_members[lobby][0], -1);
	TextDrawSetShadow(			dice_members[lobby][0], 0);
	TextDrawSetOutline(			dice_members[lobby][0], 1);
	TextDrawBackgroundColor(	dice_members[lobby][0], 51);
	TextDrawFont(				dice_members[lobby][0], 1);
	TextDrawSetProportional(	dice_members[lobby][0], 1);


	dice_members[lobby][1] = TextDrawCreate(474.400085, 225.000106, "BY KBAS's");
	TextDrawLetterSize(			dice_members[lobby][1], 0.285198, 1.174396);
	TextDrawAlignment(			dice_members[lobby][1], 1);
	TextDrawColor(				dice_members[lobby][1], -1);
	TextDrawSetShadow(			dice_members[lobby][1], 0);
	TextDrawSetOutline(			dice_members[lobby][1], 1);
	TextDrawBackgroundColor(	dice_members[lobby][1], 51);
	TextDrawFont(				dice_members[lobby][1], 1);
	TextDrawSetProportional(	dice_members[lobby][1], 1);

	dice_members[lobby][2] = TextDrawCreate(474.400085, 237.200180, "BY KBAS's");
	TextDrawLetterSize(			dice_members[lobby][2], 0.285198, 1.174396);
	TextDrawAlignment(			dice_members[lobby][2], 1);
	TextDrawColor(				dice_members[lobby][2], -1);
	TextDrawSetShadow(			dice_members[lobby][2], 0);
	TextDrawSetOutline(			dice_members[lobby][2], 1);
	TextDrawBackgroundColor(	dice_members[lobby][2], 51);
	TextDrawFont(				dice_members[lobby][2], 1);
	TextDrawSetProportional(	dice_members[lobby][2], 1);

	dice_members[lobby][3] = TextDrawCreate(474.400085, 249.400253, "BY KBAS's");
	TextDrawLetterSize(			dice_members[lobby][3], 0.285198, 1.174396);
	TextDrawAlignment(			dice_members[lobby][3], 1);
	TextDrawColor(				dice_members[lobby][3], -1);
	TextDrawSetShadow(			dice_members[lobby][3], 0);
	TextDrawSetOutline(			dice_members[lobby][3], 1);
	TextDrawBackgroundColor(	dice_members[lobby][3], 51);
	TextDrawFont(				dice_members[lobby][3], 1);
	TextDrawSetProportional(	dice_members[lobby][3], 1);

	dice_members[lobby][4] = TextDrawCreate(474.400085, 262.347015, "BY KBAS's");
	TextDrawLetterSize(			dice_members[lobby][4], 0.285198, 1.174396);
	TextDrawAlignment(			dice_members[lobby][4], 1);
	TextDrawColor(				dice_members[lobby][4], -1);
	TextDrawSetShadow(			dice_members[lobby][4], 0);
	TextDrawSetOutline(			dice_members[lobby][4], 1);
	TextDrawBackgroundColor(	dice_members[lobby][4], 51);
	TextDrawFont(				dice_members[lobby][4], 1);
	TextDrawSetProportional(	dice_members[lobby][4], 1);


	dice_members_ready[lobby][0] = TextDrawCreate(611.599999, 213.053359, "--");
	TextDrawLetterSize(			dice_members_ready[lobby][0], 0.285198, 1.174396);
	TextDrawAlignment(			dice_members_ready[lobby][0], 1);
	TextDrawColor(				dice_members_ready[lobby][0], -1);
	TextDrawSetShadow(			dice_members_ready[lobby][0], 0);
	TextDrawSetOutline(			dice_members_ready[lobby][0], 1);
	TextDrawBackgroundColor(	dice_members_ready[lobby][0], 51);
	TextDrawFont(				dice_members_ready[lobby][0], 1);
	TextDrawSetProportional(	dice_members_ready[lobby][0], 1);

	dice_members_ready[lobby][1] = TextDrawCreate(611.599999, 226.746749, "--");
	TextDrawLetterSize(			dice_members_ready[lobby][1], 0.285198, 1.174396);
	TextDrawAlignment(			dice_members_ready[lobby][1], 1);
	TextDrawColor(				dice_members_ready[lobby][1], -1);
	TextDrawSetShadow(			dice_members_ready[lobby][1], 0);
	TextDrawSetOutline(			dice_members_ready[lobby][1], 1);
	TextDrawBackgroundColor(	dice_members_ready[lobby][1], 51);
	TextDrawFont(				dice_members_ready[lobby][1], 1);
	TextDrawSetProportional(	dice_members_ready[lobby][1], 1);

	dice_members_ready[lobby][2] = TextDrawCreate(611.599999, 239.693405, "--");
	TextDrawLetterSize(			dice_members_ready[lobby][2], 0.285198, 1.174396);
	TextDrawAlignment(			dice_members_ready[lobby][2], 1);
	TextDrawColor(				dice_members_ready[lobby][2], -1);
	TextDrawSetShadow(			dice_members_ready[lobby][2], 0);
	TextDrawSetOutline(			dice_members_ready[lobby][2], 1);
	TextDrawBackgroundColor(	dice_members_ready[lobby][2], 51);
	TextDrawFont(				dice_members_ready[lobby][2], 1);
	TextDrawSetProportional(	dice_members_ready[lobby][2], 1);

	dice_members_ready[lobby][3] = TextDrawCreate(611.599999, 251.893463, "--");
	TextDrawLetterSize(			dice_members_ready[lobby][3], 0.285198, 1.174396);
	TextDrawAlignment(			dice_members_ready[lobby][3], 1);
	TextDrawColor(				dice_members_ready[lobby][3], -1);
	TextDrawSetShadow(			dice_members_ready[lobby][3], 0);
	TextDrawSetOutline(			dice_members_ready[lobby][3], 1);
	TextDrawBackgroundColor(	dice_members_ready[lobby][3], 51);
	TextDrawFont(				dice_members_ready[lobby][3], 1);
	TextDrawSetProportional(	dice_members_ready[lobby][3], 1);

	dice_members_ready[lobby][4] = TextDrawCreate(611.599999, 263.346862, "--");
	TextDrawLetterSize(			dice_members_ready[lobby][4], 0.285198, 1.174396);
	TextDrawAlignment(			dice_members_ready[lobby][4], 1);
	TextDrawColor(				dice_members_ready[lobby][4], -1);
	TextDrawSetShadow(			dice_members_ready[lobby][4], 0);
	TextDrawSetOutline(			dice_members_ready[lobby][4], 1);
	TextDrawBackgroundColor(	dice_members_ready[lobby][4], 51);
	TextDrawFont(				dice_members_ready[lobby][4], 1);
	TextDrawSetProportional(	dice_members_ready[lobby][4], 1);
}






stock CheckPlayerDistanceToPoint(playerid, Float:x, Float:y, Float:z, Float: distance)
{
	if(IsPlayerInRangeOfPoint(playerid, distance, x, y, z)) return 1;
	else return 0;
}






stock playermoney(playerid)
{
	return GetPlayerMoney(playerid);
}

stock playername(playerid)
{
	new name[MAX_PLAYER_NAME]; GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	return name;
}



stock GivePlayerMoneyEx(playerid, money)
{
	GivePlayerMoney(playerid, money);
	new str[30], moneystr[11];
	ConvertMoney(money, moneystr);
	if(money > 0)
	{
		format(str, sizeof str, "      + %s", moneystr);
		ShowNotification(playerid, 1, str, 5, "", "");
	}
	else if(money != 0)
	{
		format(str, sizeof str, "      %s", moneystr);
		ShowNotification(playerid, 0, str, 5, "", "");
	}
}






stock ConvertMoney(money, string[], length = sizeof string)
{
	format(string, length, "%d", money < 0 ? -money : money);
	for(new i = strlen(string); (i -= 3) > 0;)
	{
	    if(string[i] != '\0' && '0' <= string[i] <= '9')
	    {
	        strins(string, ".", i, length);
	    }
	    else
	    {
	        return;
	    }
	}

	if(money < 0)
	{
	    strins(string, "-", 0, length);
	}
}




stock KickEx(playerid, string[])
{
	SCM(playerid, CLRED, string);
	SetTimerEx("TimerKickEx", 100, false, "d", playerid);
	return 1;
}
forward TimerKickEx(playerid);
public TimerKickEx(playerid)
{
	Kick(playerid);
}


stock FreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, 0);
//    pInfo[playerid][pFreeze] = true;
    return 1;
}

stock UnFreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, 1);
//    pInfo[playerid][pFreeze] = false;
    return 1;
}


stock SendCustomRPC(playerid, rpcid, ...)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, rpcid);
    for (new i = 0; i < numargs()-2; ++i)
    {
        BS_WriteValue(bitstream, PR_UINT32, getarg(i+2));
    }

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

	BS_Delete(bitstream);
}


stock TogglePlayerHudElement(playerid, hudid, value)
{
    SendCustomRPC(playerid, CUSTOM_RPC_TOGGLE_HUD_ELEMENT, hudid, value);
}

stock TogglePlayerAllHudElements(playerid, value)
{
	for(new i = 0; i < 7; i++)
	{
		SendCustomRPC(playerid, CUSTOM_RPC_TOGGLE_HUD_ELEMENT, i, value);
	}
}


stock ShowPlayerHud(playerid)
{
	SendCustomRPC(playerid, RPC_CUSTOM_SHOW_HUD);
}

stock HidePlayerHud(playerid)
{
	SendCustomRPC(playerid, RPC_CUSTOM_HIDE_HUD);
	TogglePlayerHudElement(playerid, HUD_ELEMENT_MAP, HUD_ELEMENT_HIDE);
}





stock ShowNotification(playerid, type, const text[], duration, const actionforBtn[], const textBtn[])
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_NOTIFICATION);

    BS_WriteValue(bitstream, PR_INT32, type);

    BS_WriteValue(bitstream, PR_UINT16, strlen(text));
    BS_WriteValue(bitstream, PR_STRING, text);

    BS_WriteValue(bitstream, PR_INT32, duration);

    BS_WriteValue(bitstream, PR_UINT16, strlen(actionforBtn));
    BS_WriteValue(bitstream, PR_STRING, actionforBtn);

    BS_WriteValue(bitstream, PR_UINT16, strlen(textBtn));
    BS_WriteValue(bitstream, PR_STRING, textBtn);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

	return true;
}




stock LoadSettingsSystem()
{
	new FileID = ini_openFile("kbass_system_auth.ini"),errCode;
	if(FileID < 0)
	{
		printf("Ошибка: В корневой папке сервера по пути /scriptfiles/ отсуствует файл авторизации kbass_system_auth.ini.");
		//printf("Код ошибки: %d", FileID);
		return 0;
	}
	else
	{
		errCode = ini_getInteger(FileID,"maxlobby",CountDiceLobby);
		if(errCode < 0)
		{
			print("ВНИМАНИЕ: Произошла ошибка при чтении количества столов! (maxlobby)");
			printf("Убедитесь что в файле настроек системы имеется строка \"maxlobby =\",\nпо пути /scriptfiles/kbass_system_auth.ini.\nКод ошибки: %d",errCode);
		}
		if(CountDiceLobby > MAX_DICE_LOBBY)
		{
			CountDiceLobby = 10;
			print("Примечание: Максимальное количество столов не должно превышать значение 10!");
		}

		errCode = ini_getString(FileID,"host",MySQLSettings[MYSQL_HOST]);
		if(errCode < 0)
		{
			print("ВНИМАНИЕ: Произошла ошибка при чтении адреса баз данных! (host)");
			printf("Убедитесь что в файле настроек системы имеется строка \"host =\",\nпо пути /scriptfiles/kbass_system_auth.ini.\nКод ошибки: %d",errCode);
		}
		errCode = ini_getString(FileID,"username",MySQLSettings[MYSQL_USER]);
		if(errCode < 0)
		{
			print("ВНИМАНИЕ: Произошла ошибка при чтении пользователя баз данных! (username)");
			printf("Убедитесь что в файле настроек системы имеется строка \"username =\",\nпо пути /scriptfiles/kbass_system_auth.ini.\nКод ошибки: %d",errCode);
		}
		errCode = ini_getString(FileID,"database",MySQLSettings[MYSQL_DATABASE]);
		if(errCode < 0)
		{
			print("ВНИМАНИЕ: Произошла ошибка при чтении базы данных! (database)");
			printf("Убедитесь что в файле настроек системы имеется строка \"database =\",\nпо пути /scriptfiles/kbass_system_auth.ini.\nКод ошибки: %d",errCode);
		}
		errCode = ini_getString(FileID,"password",MySQLSettings[MYSQL_PASSWORD]);
		if(errCode < 0)
		{
			print("ВНИМАНИЕ: Произошла ошибка при чтении пароля базы данных! (password)");
			printf("Убедитесь что в файле настроек системы имеется строка \"password =\",\nпо пути /scriptfiles/kbass_system_auth.ini.\nКод ошибки: %d",errCode);
		}
	}
	ini_closeFile(FileID);
	return 1;
}
